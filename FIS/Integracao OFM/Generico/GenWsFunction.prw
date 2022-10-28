#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'

/*/{Protheus.doc} drop_error
Funcao para explodir o erro para o WS

@author Fabio Hayama - Geeker Company
@since 04/12/2016
@version 1.0
/*/
user function drop_error(c_msg)
return (SetRestFault(400, EncodeUTF8(c_msg, "cp1252")), .F.)

/*/{Protheus.doc} vldEmpresa
Funcao para explodir o erro para o WS

@author Fabio Hayama - Geeker Company
@since 04/12/2016
@version 1.0
/*/
user function vlEmpOFM(cCodEmp)
    local cRet      := ""
    local cEmpVld   := GetMv("ZZ_EMRSOFM", .F., "01|02|06|07|")

    if( Empty(cCodEmp) )
        cRet := "Empresa vazia."

    elseIf( !Alltrim(Upper(cCodEmp)) $ cEmpVld )
        cRet := "Empresa invalida para integracao."
        
    endIf

return cRet
