#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} EmpresaOFM
Classe para retornar os dados das emrpesas

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class EmpresaOFM 
	data cCodEmp
	data cFilEntida	
	data cDescri
    data cNome
    data cCNPJ

    data empresa
    data filial
    data descri
    data nome

    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_EmpresaOFM() constructor 
	method setByBD_EmpresaOFM()	
	method getInfo_EmpresaOFM()
    method setJson_EmpresaOFM()
endclass

/*/{Protheus.doc} new_EmpresaOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_EmpresaOFM() class EmpresaOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_EmpresaOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_EmpresaOFM() class EmpresaOFM    
    local oEmpresaOFM	:= nil
    local lContinua     := .T.

    DbSelectArea( "SM0" )
	DbGoTop()
	While( !SM0->( Eof() ) )
        lContinua := .T.
      
        if( !Empty(::empresa) .AND. Alltrim(SM0->M0_CODIGO) != ::empresa )
            lContinua := .F.
        endIf

        if( !Empty(::filial) .AND. Alltrim(SM0->M0_CODFIL) != ::filial )
            lContinua := .F.
        endIf

        if( !Empty(::descri) .AND. !Alltrim(::descri) $ Alltrim(SM0->M0_FILIAL) )
            lContinua := .F.
        endIf

        if( !Empty(::nome) .AND. !Alltrim(::nome) $ Alltrim(SM0->M0_NOME) )
            lContinua := .F.
        endIf

        if( lContinua )
            oEmpresaOFM := nil
            oEmpresaOFM := EmpresaOFM():new_EmpresaOFM()

            oEmpresaOFM:setByBD_EmpresaOFM()
            oEmpresaOFM:setJson_EmpresaOFM()

            AAdd( ::aDados  , oEmpresaOFM )
            Aadd( ::aJDados , oEmpresaOFM:oJson )
        endIf
		
		SM0->( DbSkip() )
	End

	SM0->( dbCloseArea() )

return

/*/{Protheus.doc} setByBD_EmpresaOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByBD_EmpresaOFM() class EmpresaOFM

	::cCodEmp		:= SM0->M0_CODIGO
	::cFilEntida	:= SM0->M0_CODFIL
	::cDescri		:= SM0->M0_FILIAL
    ::cNome         := SM0->M0_NOME
    ::cCNPJ         := SM0->M0_CGC

return

/*/{Protheus.doc} setJson_EmpresaOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_EmpresaOFM() class EmpresaOFM

	::oJson["cCodEmp"]      := ::cCodEmp
	::oJson["cFilEntida"]   := ::cFilEntida
	::oJson["cDescri"]      := ::cDescri
	::oJson["cNome"]        := ::cNome
    ::oJson["cCNPJ"]        := ::cCNPJ

return
