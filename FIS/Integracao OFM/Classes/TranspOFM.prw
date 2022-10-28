#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} TranspOFM
Classe para retornar os dados das transportadoras

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class TranspOFM 
    data cCodEmp    //SM0_EMPRESA
    data cCod       //A4_COD
    data cNome      //A4_NOME
    data cCNPJ      //A4_CGC
    data cEnd       //A4_END
    data cEst       //A4_EST
    
    data empresa
    data nome
    data cod
    data cnpj
    data sincroniza

    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_TranspOFM() constructor 
	method setByAlias_TranspOFM()
	method qryInfo_TranspOFM()
	method getInfo_TranspOFM()
    method setJson_TranspOFM()
endclass

/*/{Protheus.doc} new_TranspOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_TranspOFM() class TranspOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_TranspOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_TranspOFM() class TranspOFM
    local cAliasQry     := ::qryInfo_TranspOFM()
    local oTranspOFM    := nil
    
    while( !(cAliasQry)->( Eof() ) )
        oTranspOFM  := nil
        oTranspOFM  := TranspOFM():new_TranspOFM()

        oTranspOFM:setByAlias_TranspOFM(cAliasQry)
        oTranspOFM:setJson_TranspOFM()
        
        AAdd( ::aDados  , oTranspOFM )
        Aadd( ::aJDados , oTranspOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_TranspOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_TranspOFM() class TranspOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf
    cQuery += CRLF + "  FROM "+ RetSqlName("SA4") +" SA4  "
    cQuery += CRLF + "  WHERE                             "
    cQuery += CRLF + "      SA4.D_E_L_E_T_ = ''           "

     if( !Empty(::nome) )
        cQuery += CRLF + " AND SA4.A4_NOME LIKE '%"+ Alltrim(::nome) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SA4.A4_COD = '"+ Alltrim(::cod) +"' "
    endIf
    
    if( !Empty(::cnpj) )
        cQuery += CRLF + " AND SA4.A4_CGC = '"+ Alltrim(::cnpj) +"' "
    endIf

    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SA4.A4_XDTALT + ' ' + SA4.A4_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_TranspOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_TranspOFM(cAliasQry) class TranspOFM
    ::cCodEmp       := cEmpAnt
    ::cCod          := (cAliasQry)->A4_COD
    ::cNome         := (cAliasQry)->A4_NOME
    ::cCNPJ         := (cAliasQry)->A4_CGC
    ::cEnd          := (cAliasQry)->A4_END
    ::cEst          := (cAliasQry)->A4_EST
return

/*/{Protheus.doc} setJson_TranspOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_TranspOFM() class TranspOFM
    
    ::oJson["cCodEmp"]     := ::cCodEmp
    ::oJson["cCod"]        := ::cCod
    ::oJson["cNome"]       := ::cNome
    ::oJson["cCNPJ"]       := ::cCNPJ
    ::oJson["cEnd"]        := ::cEnd
    ::oJson["cEst"]        := ::cEst

return
