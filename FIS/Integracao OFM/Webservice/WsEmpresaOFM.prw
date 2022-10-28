#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'

// Apenas para desenvolvedores
#define __DEBUG__					0	// GETMV('GK_DEBUG_MODE'))
#define __PRODUCTION__				0	// GetEnvServer() == "PRODUCAO"
#define __DEVELOPMENT__				!__PRODUCTION

// Propriedades do framework
#define TIMESTAMP_FORMAT_UTC		3	// https://tdn.totvs.com/display/framework/FWTimeStamp

// Auxiliar para o c�digo de API RESTful
#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>}        => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute}         => EndCase
#xtranslate @{Route}            => Do Case
#xtranslate @{When <path>}      => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default}          => Otherwise

// Auxiliar para verifica��o de vari�veis
#xtranslate isArray(<x>) 	=> ValType(<x>) == 'A'
#xtranslate isString(<x>) 	=> ValType(<x>) == 'C'
#xtranslate isNumber(<x>)	=> ValType(<x>) == 'N'
#xtranslate isObject(<x>) 	=> ValType(<x>) == 'O'
#xtranslate isNull(<x>)		=> ValType(<x>) == 'U'

/*/{Protheus.doc} WsEmpresaOFM
Tela para consulta de empresas Protheus x OFM

@author Fabio Hayama - Geeker Company
@since 04/12/2016
@version 1.0
/*/
wsRestful WsEmpresaOFM DESCRIPTION "Integracao de empresa - Protheus x OFM"
	wsData empresa 		As String OPTIONAL
	wsData filial 		As String OPTIONAL
	wsData descri		As String OPTIONAL
	wsData nome			As String OPTIONAL

	wsMethod GET	Description "Retorna os dados da rota de WsEmpresaOFM"	wsSyntax "/WsEmpresaOFM/get"
	wsMethod POST	Description "Post WsEmpresaOFM"							wsSyntax "/WsEmpresaOFM/post"
end wsRestful

wsMethod GET wsReceive empresa, filial, descri, nome wsService WsEmpresaOFM	
	local oJson 		:= JsonObject():New()
	local nSeconds		:= Seconds()
	local cError		:= ""
	local cEmpParam		:= GetMv("ZZ_EMPROFM", .F., "01")
	local cFilParam		:= GetMv("ZZ_FLPROFM", .F., "01")
	local oEntidaOFM	:= EmpresaOFM():new_EmpresaOFM()
	local lValSeg		:= .F.

	::SetContentType('application/json')

	if( Empty(cError) )
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(cEmpParam, cFilParam, , "FAT")

		lValSeg := SuperGetMV("ZZ_VLSGWS", .F., .F.)
		
		@{Route}

			@{When '/get'}
				LgAuthKey 				:= ::GetHeader( "LgAuthKey" )
				PssAuthKey				:= ::GetHeader( "PssAuthKey" )

				if( !lValSeg .OR. u_PssRotMD5Ws(LgAuthKey, PssAuthKey) )				
					oEntidaOFM:empresa	:= ::empresa
					oEntidaOFM:filial	:= ::filial
					oEntidaOFM:descri	:= ::descri
					oEntidaOFM:nome		:= ::nome

					oEntidaOFM:getInfo_EmpresaOFM()

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
		oJson["__debug__"]["charset"]				:= "Este � apenas um teste de codifica��o :D"
	endIf

	// INFO: Provis�rio at� a corre��o do JsonObject():GetNames() ... "Ele est� vindo vazio"
	::SetResponse(oJson:ToJson())

return (.T.)

wsMethod POST wsService WsEmpresaOFM	
return (.T.)
