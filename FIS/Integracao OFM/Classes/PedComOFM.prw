#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} PedComOFM
Classe para retornar os pedidos de compras

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class PedComOFM 
    data cCodEmpr   //SM0_EMPRESA
    data cDesEmpr   //SM0_DESCEMP
    data cFilPed    //C7_FILIAL
    data cEmissao   //C7_EMISSAO
    data cNumPed    //C7_NUM
    data cFornec    //C7_FORNECE
    data cLoja      //C7_LOJA
    data cNome      //A2_NOME
    data cNomFant   //A2_NREDUZ
    data cEnder     //A2_END
    data cCNPJ      //A2_CGC
    data cCndPgto   //C7_COND

    data aItens
    data aJItens

    data empresa
    data cgcfor
    data fornec
    data loja
    data nomefor
    data razaofor
    data numped
    data emissao
    data cnpj
    data sincroniza
    
    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_PedComOFM() constructor 
	method setByAlias_PedComOFM()
	method qryInfo_PedComOFM()
	method getInfo_PedComOFM()
    method setJson_PedComOFM()
endclass

/*/{Protheus.doc} new_PedComOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_PedComOFM() class PedComOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}

    ::aItens    := {}
    ::aJItens   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_PedComOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_PedComOFM() class PedComOFM
    local cAliasQry     := ::qryInfo_PedComOFM()
    local oPedComOFM    := nil
    local oPedItComOFM  := nil
    
    while( !(cAliasQry)->( Eof() ) )
        oPedComOFM              := nil
        oPedComOFM              := PedComOFM():new_PedComOFM()

        oPedItComOFM            := nil
        oPedItComOFM            := PedItComOFM():new_PedItComOFM()

        oPedItComOFM:cNumPed    := (cAliasQry)->C7_NUM
        oPedItComOFM:getInfo_PedItComOFM()
        
        oPedComOFM:aJItens      := oPedItComOFM:aJDados

        AAdd( oPedComOFM:aItens, oPedItComOFM )
        
        oPedComOFM:setByAlias_PedComOFM(cAliasQry)
        oPedComOFM:setJson_PedComOFM()

        AAdd( ::aDados  , oPedComOFM )
        Aadd( ::aJDados , oPedComOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} qryInfo_PedComOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_PedComOFM() class PedComOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT DISTINCT TOP "+ cTopEnt +" C7_FILIAL, C7_EMISSAO, C7_NUM, C7_FORNECE, A2_NOME, A2_NREDUZ, C7_LOJA, A2_END, A2_CGC, C7_COND  "        
    else
        cQuery += CRLF + "  SELECT DISTINCT C7_FILIAL, C7_EMISSAO, C7_NUM, C7_FORNECE, A2_NOME, A2_NREDUZ, C7_LOJA, A2_END, A2_CGC, C7_COND "        
    endIf

    cQuery += CRLF + "  FROM "+ RetSqlName("SC7") +" SC7  			"
    cQuery += CRLF + "  INNER JOIN "+ RetSqlName("SA2") +" SA2 ON   "
    cQuery += CRLF + "          SA2.A2_FILIAL   = ''                "
    cQuery += CRLF + "      AND SA2.A2_COD      = SC7.C7_FORNECE    "
    cQuery += CRLF + "      AND SA2.A2_LOJA     = SC7.C7_LOJA       "

    if( !Empty(::razaofor) )
        cQuery += CRLF + " AND SA2.A2_NOME LIKE '%"+ Alltrim(::razaofor) +"%' "
    endIf

    if( !Empty(::nomefor) )
        cQuery += CRLF + " AND SA2.A2_NREDUZ LIKE '%"+ Alltrim(::nomefor) +"%' "
    endIf

    if( !Empty(::fornec) )
        cQuery += CRLF + " AND SA2.A2_COD = '"+ Alltrim(::fornec) +"' "
    endIf
    
    if( !Empty(::loja) )
        cQuery += CRLF + " AND SA2.A2_LOJA = '"+ Alltrim(::loja) +"' "
    endIf

    if( !Empty(::cgcfor) )
        cQuery += CRLF + " AND SA2.A2_CGC = '"+ Alltrim(::cgcfor) +"' "
    endIf

    cQuery += CRLF + "      AND SA2.D_E_L_E_T_  = ''                "
    cQuery += CRLF + "  WHERE                                       "
    cQuery += CRLF + "      SC7.D_E_L_E_T_ = ''                     "

    if( !Empty(::numped) )
        cQuery += CRLF + " AND SC7.C7_NUM = '"+ Alltrim(::numped) +"' "
    endIf

    if( !Empty(::emissao) )
        cQuery += CRLF + " AND SC7.C7_EMISSAO = '"+ Alltrim(::emissao) +"' "
    endIf

    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SC7.C7_XDTALT + ' ' + SC7.C7_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_PedComOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_PedComOFM(cAliasQry) class PedComOFM
    ::cCodEmpr  := cEmpAnt
    ::cDesEmpr  := FWFilName ( cEmpAnt, cFilAnt )
    ::cFilPed   := (cAliasQry)->C7_FILIAL
    ::cEmissao  := (cAliasQry)->C7_EMISSAO
    ::cNumPed   := (cAliasQry)->C7_NUM
    ::cFornec   := (cAliasQry)->C7_FORNECE
    ::cLoja     := (cAliasQry)->C7_LOJA
    ::cNome     := (cAliasQry)->A2_NOME
    ::cNomFant  := (cAliasQry)->A2_NREDUZ
    ::cEnder    := (cAliasQry)->A2_END
    ::cCNPJ     := (cAliasQry)->A2_CGC
    ::cCndPgto  := (cAliasQry)->C7_COND
return

/*/{Protheus.doc} setJson_PedComOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_PedComOFM() class PedComOFM
        
    ::oJson["cCodEmpr"]     := ::cCodEmpr
    ::oJson["cDesEmpr"]     := ::cDesEmpr
    ::oJson["cFilPed"]      := ::cFilPed
    ::oJson["cEmissao"]     := ::cEmissao
    ::oJson["cNumPed"]      := ::cNumPed
    ::oJson["cFornec"]      := ::cFornec
    ::oJson["cLoja"]        := ::cLoja
    ::oJson["cNome"]        := ::cNome
    ::oJson["cNomFant"]     := ::cNomFant
    ::oJson["cEnder"]       := ::cEnder
    ::oJson["cCNPJ"]        := ::cCNPJ
    ::oJson["cCndPgto"]     := ::cCndPgto
    ::oJson["aItens"]       := ::aJItens

return
