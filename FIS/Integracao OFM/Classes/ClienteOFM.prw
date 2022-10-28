#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} ClienteOFM
Classe para retornar os dados do clientes

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class ClienteOFM 
    data cCodEmp    //SM0_EMPRESA
    data cNome      //A1_NOME
    data cCod       //A1_COD
    data cLoja      //A1_LOJA
    data cCNPJ      //A1_CGC
    data cEnd       //A1_END

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
        	
	method new_ClienteOFM() constructor 
	method setByAlias_ClienteOFM()
	method qryInfo_ClienteOFM()
	method getInfo_ClienteOFM()
    method setJson_ClienteOFM()
endclass

/*/{Protheus.doc} new_ClienteOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_ClienteOFM() class ClienteOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_ClienteOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_ClienteOFM() class ClienteOFM
    local cAliasQry     := ::qryInfo_ClienteOFM()
    local oClienteOFM    := nil
    
    while( !(cAliasQry)->( Eof() ) )
        oClienteOFM  := nil
        oClienteOFM  := ClienteOFM():new_ClienteOFM()

        oClienteOFM:setByAlias_ClienteOFM(cAliasQry)
        oClienteOFM:setJson_ClienteOFM()
        
        AAdd( ::aDados  , oClienteOFM )
        Aadd( ::aJDados , oClienteOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_ClienteOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_ClienteOFM() class ClienteOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    conout("cTopEnt")
    conout(cTopEnt)

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *   "        
    else
        cQuery += CRLF + "  SELECT *                     "        
    endIf

    cQuery += CRLF + "  FROM "+ RetSqlName("SA1") +" SA1  "
    cQuery += CRLF + "  WHERE                             "
    cQuery += CRLF + "      SA1.D_E_L_E_T_ = ''           "

    if( !Empty(::razao) )
        cQuery += CRLF + " AND SA1.A1_NOME LIKE '%"+ Alltrim(::razao) +"%' "
    endIf

    if( !Empty(::nome) )
        cQuery += CRLF + " AND SA1.A1_NREDUZ LIKE '%"+ Alltrim(::nome) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SA1.A1_COD = '"+ Alltrim(::cod) +"' "
    endIf
    
    if( !Empty(::loja) )
        cQuery += CRLF + " AND SA1.A1_LOJA = '"+ Alltrim(::loja) +"' "
    endIf

    if( !Empty(::cnpj) )
        cQuery += CRLF + " AND SA1.A1_CGC = '"+ Alltrim(::cnpj) +"' "
    endIf

    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SA1.A1_XDTALT + ' ' + SA1.A1_XHRALT >= '"+ ::sincroniza +"' "
    endIf
    
    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_ClienteOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_ClienteOFM(cAliasQry) class ClienteOFM
    ::cCodEmp       := cEmpAnt
    ::cNome         := (cAliasQry)->A1_NOME
    ::cCod          := (cAliasQry)->A1_COD
    ::cLoja         := (cAliasQry)->A1_LOJA
    ::cCNPJ         := (cAliasQry)->A1_CGC
    ::cEnd          := (cAliasQry)->A1_END
return

/*/{Protheus.doc} setJson_ClienteOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_ClienteOFM() class ClienteOFM
    
    ::oJson["cCodEmp"]  := ::cCodEmp
    ::oJson["cNome"]    := ::cNome
    ::oJson["cCod"]     := ::cCod
    ::oJson["cLoja"]    := ::cLoja
    ::oJson["cCNPJ"]    := ::cCNPJ
    ::oJson["cEnd"]     := ::cEnd

return
