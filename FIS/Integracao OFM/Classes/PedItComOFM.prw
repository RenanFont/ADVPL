#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} PedItComOFM
Classe para retornar os itens dos pedidos de compras

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class PedItComOFM 
    data cCodEmpr   //SM0_EMPRESA
    data cDesEmpr   //SM0_DESCEMP
    data cNumPed    //C7_NUM
    data cItem      //C7_ITEM
    data cSequen    //C7_SEQUEN    
    data cCodProd   //C7_PRODUTO
    data cDescri    //C7_DESCRI
    data cUM        //C7_UM
    data nPreco     //C7_PRECO
    data nQuant     //C7_QUANT
    data nQtdEntr   //C7_QUJE
    data nSaldo     //C7_QUANT
    data cClVl      //C7_CLVL
    
    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_PedItComOFM() constructor 
	method setByAlias_PedItComOFM()
	method qryInfo_PedItComOFM()
	method getInfo_PedItComOFM()
    method setJson_PedItComOFM()
endclass

/*/{Protheus.doc} new_PedItComOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_PedItComOFM() class PedItComOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_PedItComOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_PedItComOFM() class PedItComOFM
    local cAliasQry     := ::qryInfo_PedItComOFM()
    local oPedItComOFM    := nil
    
    while( !(cAliasQry)->( Eof() ) )
        oPedItComOFM  := nil
        oPedItComOFM  := PedItComOFM():new_PedItComOFM()

        oPedItComOFM:setByAlias_PedItComOFM(cAliasQry)
        oPedItComOFM:setJson_PedItComOFM()
        
        AAdd( ::aDados  , oPedItComOFM )
        Aadd( ::aJDados , oPedItComOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} qryInfo_PedItComOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_PedItComOFM() class PedItComOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf
    cQuery += CRLF + "  FROM "+ RetSqlName("SC7") +" SC7  			        "
    cQuery += CRLF + "  INNER JOIN "+ RetSqlName("SB1") +" SB1 ON           "
    cQuery += CRLF + "          SB1.B1_FILIAL   = '"+ xFilial("SB1") +"'    "
    cQuery += CRLF + "      AND SB1.B1_COD      = SC7.C7_PRODUTO            "    
    cQuery += CRLF + "      AND SB1.D_E_L_E_T_  = ''                        "
    cQuery += CRLF + "  WHERE                                               "
    cQuery += CRLF + "          SC7.C7_NUM      = '"+ ::cNumPed +"'         "
    cQuery += CRLF + "      AND SC7.D_E_L_E_T_  = ''                        "

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_PedItComOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_PedItComOFM(cAliasQry) class PedItComOFM
    ::cCodEmpr  := cEmpAnt
    ::cDesEmpr  := FWFilName ( cEmpAnt, cFilAnt )
    ::cNumPed   := (cAliasQry)->C7_NUM
    ::cItem     := (cAliasQry)->C7_ITEM
    ::cSequen   := (cAliasQry)->C7_SEQUEN    
    ::cCodProd  := (cAliasQry)->C7_PRODUTO
    ::cDescri   := (cAliasQry)->C7_DESCRI
    ::cUM       := (cAliasQry)->C7_UM
    ::nPreco    := (cAliasQry)->C7_PRECO
    ::nQuant    := (cAliasQry)->C7_QUANT
    ::cClVl     := (cAliasQry)->C7_CLVL
    ::nQtdEntr  := (cAliasQry)->C7_QUJE
    ::nSaldo    := (cAliasQry)->C7_QUANT - (cAliasQry)->C7_QUJE
return

/*/{Protheus.doc} setJson_PedItComOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_PedItComOFM() class PedItComOFM
        
    ::oJson["cCodEmpr"]  := ::cCodEmpr
    ::oJson["cDesEmpr"]  := ::cDesEmpr
    ::oJson["cNumPed"]   := ::cNumPed
    ::oJson["cItem"]     := ::cItem
    ::oJson["cSequen"]   := ::cSequen    
    ::oJson["cCodProd"]  := ::cCodProd
    ::oJson["cDescri"]   := ::cDescri
    ::oJson["cUM"]       := ::cUM
    ::oJson["nPreco"]    := ::nPreco
    ::oJson["nQuant"]    := ::nQuant
    ::oJson["nSaldo"]    := ::nSaldo
    ::oJson["nQtdEntr"]  := ::nQtdEntr
    ::oJson["cClVl"]     := ::cClVl

return
