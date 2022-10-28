#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'

/*/{Protheus.doc} ExRotMD5
Teste MD5

@author Fabio Hayama - Geeker Company
@since 04/12/2016
@version 1.0
/*/
user function PssRotMD5Ws(cParLogin, cParSenha)
    local cLoginWs  := Alltrim( GetMV("ZZ_PSLGWS", .F., "wsofmlogin") )
    local cPassWs   := Alltrim( GetMV("ZZ_PSLGWS", .F., "gsT99H60qQRgma") )
    local lRet      := .F.

    cLoginWs := MD5( cLoginWs, 2 )
    cPassWs  := MD5( cPassWs , 2 )
    
    if( cPassWs == cParSenha .AND. cLoginWs == cParLogin )
        lRet := .T.
    endIf

return lRet
