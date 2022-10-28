#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'

// Apenas para desenvolvedores
#define __DEBUG__					0	// GETMV('GK_DEBUG_MODE'))
#define __PRODUCTION__				0	// GetEnvServer() == "PRODUCAO"
#define __DEVELOPMENT__				!__PRODUCTION

// Propriedades do framework
#define TIMESTAMP_FORMAT_UTC		3	// https://tdn.totvs.com/display/framework/FWTimeStamp

// Auxiliar para o código de API RESTful
#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>}        => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute}         => EndCase
#xtranslate @{Route}            => Do Case
#xtranslate @{When <path>}      => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default}          => Otherwise

// Auxiliar para verificação de variáveis
#xtranslate isArray(<x>) 	=> ValType(<x>) == 'A'
#xtranslate isString(<x>) 	=> ValType(<x>) == 'C'
#xtranslate isNumber(<x>)	=> ValType(<x>) == 'N'
#xtranslate isObject(<x>) 	=> ValType(<x>) == 'O'
#xtranslate isNull(<x>)		=> ValType(<x>) == 'U'

/*/{Protheus.doc} WsDocEntrOFM
Tela para consulta dos fornecedores Protheus x OFM

@author Fabio Hayama - Geeker Company
@since 04/12/2016
@version 1.0
/*/
wsRestful WsDocEntrOFM DESCRIPTION "Integracao de Doc Entrada Protheus x OFM"
	wsData empresa 		As String OPTIONAL
	wsData fornec 		As String OPTIONAL
	wsData loja 		As String OPTIONAL
	wsData cgcfor 		As String OPTIONAL
	wsData nomefor 		As String OPTIONAL
	wsData razaofor 	As String OPTIONAL	
	wsData documento 	As String OPTIONAL
	wsData serie 		As String OPTIONAL
	wsData tipo 		As String OPTIONAL
	wsData especie 		As String OPTIONAL
	wsData emissao 		As String OPTIONAL
	wsData dtLanc		As String OPTIONAL
	wsData chaveNfe		As String OPTIONAL
	wsData sincroniza	As String OPTIONAL

	wsMethod GET Description "Retorna os dados da rota de WsDocEntrOFM" wsSyntax "/WsDocEntrOFM/get"
	wsMethod POST Description "Post WsDocEntrOFM" wsSyntax "/WsDocEntrOFM/post"
end wsRestful

wsMethod GET wsReceive empresa, nome, cod, cnpj, sincroniza  wsService WsDocEntrOFM	
	local oJson 		:= JsonObject():New()
	local nSeconds		:= Seconds()
	local cError		:= ""
	local cFilParam		:= GetMv("ZZ_FLPROFM", .F., "01")
	local oEntidaOFM	:= DocEntrada():new_DocEntrada()
	local lValSeg		:= .F.

	::SetContentType('application/json')

	cError := u_vlEmpOFM(::empresa)

	if( Empty(cError) )
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(::empresa, cFilParam, , "COM")

		lValSeg := SuperGetMV("ZZ_VLSGWS", .F., .F.)
		
		@{Route}

			@{When '/get'}	
				LgAuthKey 				:= ::GetHeader( "LgAuthKey" )
				PssAuthKey				:= ::GetHeader( "PssAuthKey" )

				if( !lValSeg .OR. u_PssRotMD5Ws(LgAuthKey, PssAuthKey) )
					oEntidaOFM:empresa		:= ::empresa
					oEntidaOFM:fornec		:= ::fornec
					oEntidaOFM:loja			:= ::loja
					oEntidaOFM:cgcfor		:= ::cgcfor
					oEntidaOFM:nomefor		:= ::nomefor
					oEntidaOFM:razaofor		:= ::razaofor
					oEntidaOFM:documento	:= ::documento
					oEntidaOFM:serie		:= ::serie
					oEntidaOFM:tipo			:= ::tipo
					oEntidaOFM:especie		:= ::especie
					oEntidaOFM:emissao		:= ::emissao
					oEntidaOFM:sincroniza	:= ::sincroniza
					oEntidaOFM:dtLanc		:= ::dtLanc
					oEntidaOFM:chaveNfe		:= ::chaveNfe

					oEntidaOFM:getInfo_DocEntrada()

					if( Empty(oEntidaOFM:cError) )
						oJson["status"] := "OK"
						oJson["dados"] 	:= oEntidaOFM:aJDados
					else
						oJson["status"] := "NOK"
						oJson["dados"] 	:= oEntidaOFM:cError
					endIf
				else
					oJson["status"] := "NOK"
					oJson["dados"] 	:= "Credencias incorretas ou nao informadas"
				endIf

			@{Default}
				SetRestFault(404, "Ops! Invalid route: 404 not found")
				return (.F.)

		@{EndRoute}
	else
		oJson["status"] := "NOK"
		oJson["dados"] 	:= cError
	endIf

	if (__DEBUG__)
		oJson["__debug__"]							:= Eval(bObject)
		oJson["__debug__"]["environment"]			:= iif(__PRODUCTION__, "production", "development")
		oJson["__debug__"]["params"]				:= ::aURLParms
		oJson["__debug__"]["timestamp"]				:= fwTimestamp(TIMESTAMP_FORMAT_UTC)
		oJson["__debug__"]["server"]				:= GetEnvServer()
		oJson["__debug__"]["runtime"]				:= AllTrim(Str(Seconds() - nSeconds))
		oJson["__debug__"]["charset"]				:= "Este é apenas um teste de codificação :D"
	endIf

	// INFO: Provisório até a correção do JsonObject():GetNames() ... "Ele está vindo vazio"
	::SetResponse(oJson:ToJson())

return (.T.)

wsMethod POST wsService WsDocEntrOFM
	local cJSON			:= ::GetContent()	
	local oParser		:= nil
	local oJson			:= JsonObject():New()	
	local oDocEntrOFM	:= DocEntrOFM():new_DocEntrOFM()
	local cError		:= ''
	local lValSeg		:= SuperGetMV("ZZ_VLSGWS", .F., .F.)

	::SetContentType("application/json")

	if( !FwJsonDeserialize(cJSON, @oParser) )
		SetRestFault(400, "Dado(s) nao informado(s) e/ou invalido(s)")
		return .F.
	endIf

	LgAuthKey 	:= ::GetHeader( "LgAuthKey" )
	PssAuthKey	:= ::GetHeader( "PssAuthKey" )

	if( !lValSeg .OR. u_PssRotMD5Ws(LgAuthKey, PssAuthKey) )
		if( Empty(cError) )	
			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(oParser:cCodEmp, oParser:cFilDoc, , "COM")
			
			oDocEntrOFM:oParser := oParser
			oDocEntrOFM:manRegis_DocEntrOFM()

			if( Empty(oDocEntrOFM:cError) )
				oJson["status"] := "OK"
				oJson["dados"] 	:= oDocEntrOFM:nSF1Recno
			else
				oJson["status"] := "NOK"
				oJson["dados"] 	:= oDocEntrOFM:cError
			endIf
		endIf
	else
		oJson["status"] := "NOK"
		oJson["dados"] 	:= "Credencias incorretas ou nao informadas"
	endIf

	if (__DEBUG__)
		oJson["__debug__"]							:= Eval(bObject)
		oJson["__debug__"]["environment"]			:= iif(__PRODUCTION__, "production", "development")
		oJson["__debug__"]["params"]				:= ::aURLParms
		oJson["__debug__"]["timestamp"]				:= fwTimestamp(TIMESTAMP_FORMAT_UTC)
		oJson["__debug__"]["server"]				:= GetEnvServer()
		oJson["__debug__"]["runtime"]				:= AllTrim(Str(Seconds() - nSeconds))
		oJson["__debug__"]["charset"]				:= "Este é apenas um teste de codificação :D"
	endIf

	::SetResponse( FwJsonSerialize(oJson) )

	FreeObj(oJson)
	FreeObj(oParser)	
return (.T.)
