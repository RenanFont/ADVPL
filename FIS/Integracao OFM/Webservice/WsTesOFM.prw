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

/*/{Protheus.doc} WsTesOFM
Tela para consulta dos TES Protheus x OFM

@author Fabio Hayama - Geeker Company
@since 04/12/2016
@version 1.0
/*/
wsRestful WsTesOFM DESCRIPTION "Integracao de TES Protheus x OFM"
	wsData empresa 		As String OPTIONAL
	wsData cod 			As String OPTIONAL
	wsData finalid		As String OPTIONAL
	wsData sincroniza 	As String OPTIONAL

	wsMethod GET	Description "Retorna os dados da rota de WsTesOFM"	wsSyntax "/WsTesOFM/get"
	wsMethod POST	Description "Post WsTesOFM"							wsSyntax "/WsTesOFM/post"
end wsRestful

wsMethod GET wsReceive empresa, cod, finalid, sincroniza wsService WsTesOFM	
	local oJson 		:= JsonObject():New()
	local nSeconds		:= Seconds()
	local cError		:= ""
	local cFilParam		:= GetMv("ZZ_FLPROFM", .F., "01")
	local oEntidaOFM	:= TesOFM():new_TesOFM()
	local lValSeg		:= .F.

	::SetContentType('application/json')

	cError := u_vlEmpOFM(::empresa)

	if( Empty(cError) )
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(::empresa, cFilParam, , "FAT")

		lValSeg := SuperGetMV("ZZ_VLSGWS", .F., .F.)
		
		@{Route}

			@{When '/get'}
				LgAuthKey 				:= ::GetHeader( "LgAuthKey" )
				PssAuthKey				:= ::GetHeader( "PssAuthKey" )
				
				if( !lValSeg .OR. u_PssRotMD5Ws(LgAuthKey, PssAuthKey) )
					oEntidaOFM:empresa		:= ::empresa
					oEntidaOFM:cod			:= ::cod
					oEntidaOFM:finalid		:= ::finalid
					oEntidaOFM:sincroniza	:= ::sincroniza

					oEntidaOFM:getInfo_TesOFM()

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

wsMethod POST wsService WsTesOFM	
return (.T.)
