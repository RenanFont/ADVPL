#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FornecOFM
Classe para retornar os dados do fornecedores

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class FornecOFM 
    data cCodEmp    //SM0_EMPRESA
    data cFilEntida //A2_FILIAL
    data cCod       //A2_COD
    data cLoja      //A2_LOJA
    data cNome      //A2_NOME
    data cNomFant   //A2_NREDUZ
    data cCNPJ      //A2_CGC
    data cMail      //A2_EMAIL
    data cTel       //A2_TEL
    data cInscr     //A2_INSCR
    data cEnd       //A2_END
    data cNrEnd     //A2_NR_END
    data cCompl     //A2_COMPLEM
    data cBairro    //A2_BAIRRO
    data cCEP       //A2_CEP
    data cEst       //A2_EST
    data cMun       //A2_MUN
    data cCodMun    //A2_COD_MUN
    data cPais      //A2_PAIS
    data cMsBloq    //A2_MSBLQL
    data cInscMun   //A2_INSCRM 
    data cNatureza  //A2_NATUREZ  
    
    data empresa
    data nome
    data razao
    data cod
    data loja
    data cnpj
    data sincroniza

    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_FornecOFM() constructor 
	method setByAlias_FornecOFM()
	method qryInfo_FornecOFM()
	method getInfo_FornecOFM()
    method setJson_FornecOFM()
endclass

/*/{Protheus.doc} new_FornecOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_FornecOFM() class FornecOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_FornecOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_FornecOFM() class FornecOFM
    local cAliasQry     := ::qryInfo_FornecOFM()
    local oFornecOFM    := nil
    
    while( !(cAliasQry)->( Eof() ) )
        oFornecOFM  := nil
        oFornecOFM  := FornecOFM():new_FornecOFM()

        oFornecOFM:setByAlias_FornecOFM(cAliasQry)
        oFornecOFM:setJson_FornecOFM()
        
        AAdd( ::aDados  , oFornecOFM )
        Aadd( ::aJDados , oFornecOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_FornecOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_FornecOFM() class FornecOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    conout("Eita preula")
    conout(cTopEnt)

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf
    
    cQuery += CRLF + "  FROM "+ RetSqlName("SA2") +" SA2    "
    cQuery += CRLF + "  WHERE                               "
    cQuery += CRLF + "      SA2.D_E_L_E_T_ = ' '            "

    if( !Empty(::razao) )
        cQuery += CRLF + " AND SA2.A2_NOME LIKE '%"+ Alltrim(::razao) +"%' "
    endIf

    if( !Empty(::nome) )
        cQuery += CRLF + " AND SA2.A2_NREDUZ LIKE '%"+ Alltrim(::nome) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SA2.A2_COD = '"+ Alltrim(::cod) +"' "
    endIf
    
    if( !Empty(::loja) )
        cQuery += CRLF + " AND SA2.A2_LOJA = '"+ Alltrim(::loja) +"' "
    endIf

    if( !Empty(::cnpj) )
        cQuery += CRLF + " AND SA2.A2_CGC = '"+ Alltrim(::cnpj) +"' "
    endIf

    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SA2.A2_XDTALT + ' ' + SA2.A2_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_FornecOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_FornecOFM(cAliasQry) class FornecOFM
    ::cCodEmp       := cEmpAnt
    ::cFilEntida    := (cAliasQry)->A2_FILIAL
    ::cCod          := (cAliasQry)->A2_COD
    ::cLoja         := (cAliasQry)->A2_LOJA
    ::cNome         := (cAliasQry)->A2_NOME
    ::cNomFant      := (cAliasQry)->A2_NREDUZ
    ::cCNPJ         := (cAliasQry)->A2_CGC
    ::cMail         := (cAliasQry)->A2_EMAIL
    ::cTel          := (cAliasQry)->A2_TEL
    ::cInscr        := (cAliasQry)->A2_INSCR
    ::cEnd          := (cAliasQry)->A2_END
    ::cNrEnd        := (cAliasQry)->A2_NR_END
    ::cCompl        := (cAliasQry)->A2_COMPLEM
    ::cBairro       := (cAliasQry)->A2_BAIRRO
    ::cCEP          := (cAliasQry)->A2_CEP
    ::cEst          := (cAliasQry)->A2_EST
    ::cMun          := (cAliasQry)->A2_MUN
    ::cCodMun       := (cAliasQry)->A2_COD_MUN
    ::cPais         := (cAliasQry)->A2_PAIS
    ::cMsBloq       := iif( Alltrim((cAliasQry)->A2_MSBLQL) == "1", "BLOQUEADO", "N_BLOQUEADO" )
    ::cInscMun      := (cAliasQry)->A2_INSCRM   
    ::cNatureza     := (cAliasQry)->A2_NATUREZ
return

/*/{Protheus.doc} setJson_FornecOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_FornecOFM() class FornecOFM
    
    ::oJson["cCodEmp"]     := ::cCodEmp
    ::oJson["cFilEntida"]  := ::cFilEntida
    ::oJson["cCod"]        := ::cCod
    ::oJson["cLoja"]       := ::cLoja
    ::oJson["cNome"]       := ::cNome
    ::oJson["cNomFant"]    := ::cNomFant
    ::oJson["cCNPJ"]       := ::cCNPJ
    ::oJson["cMail"]       := ::cMail
    ::oJson["cTel"]        := ::cTel
    ::oJson["cInscr"]      := ::cInscr
    ::oJson["cEnd"]        := ::cEnd
    ::oJson["cNrEnd"]      := ::cNrEnd
    ::oJson["cCompl"]      := ::cCompl
    ::oJson["cBairro"]     := ::cBairro
    ::oJson["cCEP"]        := ::cCEP
    ::oJson["cEst"]        := ::cEst
    ::oJson["cMun"]        := ::cMun
    ::oJson["cCodMun"]     := ::cCodMun
    ::oJson["cPais"]       := ::cPais
    ::oJson["cMsBloq"]     := ::cMsBloq
    ::oJson["cInscMun"]    := ::cInscMun 
    ::oJson["cNatureza"]   := ::cNatureza
    
return
