#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} ProdOFM
Classe para retornar os dados do fornecedores

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class ProdOFM 
	data cCodEmp
    data cFilEntida //B1_FILIAL
    data cCod       //B1_COD    
    data cDescri    //B1_DESC
    data cDescLonga //B5_CEME
    data cUM        //B1_UM
    data cSeqUM     //B1_SEGUM
    data cUltRev    //B1_UREV
    data cNCM       //B1_POSIPI
    data cTipo      //B1_TIPO    
    data cCEST      //B1_CEST
    data cEAN       //B1_VEREAN
    data nPesBrut   //B1_PESBRU
    data nPesoLiq   //B1_PESO
    data cOrigem    //B1_ORIGEM
    data cMsBloq    //B1_MSBLQL
    data cTpReceita

    data empresa
    data cod
    data descri
    data sincroniza
    
    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_ProdOFM() constructor 
	method setByAlias_ProdOFM()
	method qryInfo_ProdOFM()
	method getInfo_ProdOFM()
    method setJson_ProdOFM()
    method defTpReceita_ProdOFM()
endclass

/*/{Protheus.doc} new_ProdOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_ProdOFM() class ProdOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_ProdOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_ProdOFM() class ProdOFM
    local cAliasQry	:= ::qryInfo_ProdOFM()
    local oProdOFM	:= nil

    while( !(cAliasQry)->( Eof() ) )
        oProdOFM  := nil
        oProdOFM  := ProdOFM():new_ProdOFM()

        oProdOFM:setByAlias_ProdOFM(cAliasQry)
        oProdOFM:defTpReceita_ProdOFM()
        oProdOFM:setJson_ProdOFM()
                
        AAdd( ::aDados  , oProdOFM )
        Aadd( ::aJDados , oProdOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_ProdOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_ProdOFM() class ProdOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf

    cQuery += CRLF + "  FROM "		+ RetSqlName("SB1") +" SB1                  "
    cQuery += CRLF + "  LEFT JOIN "	+ RetSqlName("SB5") +" SB5  ON              "    
    cQuery += CRLF + "          SB5.B5_FILIAL	= '" + xFilial( "SB5" ) + "'    "
    cQuery += CRLF + "      AND	SB5.B5_COD		= SB1.B1_COD                    "
    cQuery += CRLF + "      AND	SB5.D_E_L_E_T_	= ' '                           "
	cQuery += CRLF + "  WHERE                                                   "
    cQuery += CRLF + "      SB1.D_E_L_E_T_ = ' '                                "
    
    if( !Empty(::cod) )
        cQuery += CRLF + " AND SB1.B1_COD = '"+ Alltrim(::cod) +"' "
    endIf

    if( !Empty(::descri) )
        cQuery += CRLF + " AND SB1.B1_DESC LIKE '%"+ Alltrim(::descri) +"%' "
    endIf

    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SB1.B1_XDTALT + ' ' + SB1.B1_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_ProdOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_ProdOFM(cAliasQry) class ProdOFM
    ::cCodEmp       := cEmpAnt
    ::cFilEntida    := (cAliasQry)->B1_FILIAL
	::cCod			:= (cAliasQry)->B1_COD
	::cDescri		:= (cAliasQry)->B1_DESC
	::cDescLonga	:= (cAliasQry)->B5_CEME
	::cUM			:= (cAliasQry)->B1_UM
    ::cSeqUM        := (cAliasQry)->B1_SEGUM
	::cUltRev		:= (cAliasQry)->B1_UREV
	::cNCM			:= (cAliasQry)->B1_POSIPI
	::cTipo			:= (cAliasQry)->B1_TIPO
	::cTipo			:= (cAliasQry)->B1_TIPO
	::cCEST			:= (cAliasQry)->B1_CEST	
	::cEAN			:= (cAliasQry)->B1_VEREAN
	::nPesBrut		:= (cAliasQry)->B1_PESBRU
	::nPesoLiq		:= (cAliasQry)->B1_PESO	
	::cOrigem		:= (cAliasQry)->B1_ORIGEM
	::cMsBloq		:= iif( allTrim((cAliasQry)->B1_MSBLQL) == "1", "BLOQUEADO", "N_BLOQUEADO" )
return

/*/{Protheus.doc} setJson_ProdOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_ProdOFM() class ProdOFM
	::oJson["cCodEmp"]		:= ::cCodEmp
	::oJson["cFilEntida"]	:= ::cFilEntida
	::oJson["cCod"]			:= ::cCod
	::oJson["cDescri"]		:= ::cDescri
	::oJson["cDescLonga"]	:= ::cDescLonga
	::oJson["cUM"]			:= ::cUM
    ::oJson["cSeqUM"]       := ::cSeqUM    
	::oJson["cUltRev"]		:= ::cUltRev
	::oJson["cNCM"]			:= ::cNCM
	::oJson["cTipo"]		:= ::cTipo
	::oJson["cTipo"]		:= ::cTipo
	::oJson["cCEST"]		:= ::cCEST
	::oJson["cEAN"]			:= ::cEAN
	::oJson["nPesBrut"]		:= ::nPesBrut
	::oJson["nPesoLiq"]		:= ::nPesoLiq
	::oJson["cOrigem"]		:= ::cOrigem
	::oJson["cMsBloq"]		:= ::cMsBloq
    ::oJson["cTpReceita"]   := ::cTpReceita
return

/*/{Protheus.doc} defTpReceita_ProdOFM
Metodo para buscar o tipo x fiscal
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method defTpReceita_ProdOFM() class ProdOFM
    local cTipo00 := Upper( Alltrim( GetMv("MV_BLKTP00") ) )
    local cTipo01 := Upper( Alltrim( GetMv("MV_BLKTP01") ) )
    local cTipo02 := Upper( Alltrim( GetMv("MV_BLKTP02") ) )
    local cTipo03 := Upper( Alltrim( GetMv("MV_BLKTP03") ) )
    local cTipo04 := Upper( Alltrim( GetMv("MV_BLKTP04") ) )
    local cTipo05 := Upper( Alltrim( GetMv("MV_BLKTP05") ) )
    local cTipo06 := Upper( Alltrim( GetMv("MV_BLKTP06") ) )
    local cTipo10 := Upper( Alltrim( GetMv("MV_BLKTP10") ) )

    ::cTipo := Alltrim(Upper(::cTipo))

    if( ::cTipo $ cTipo00 )
        ::cTpReceita := "00"

    elseIf( ::cTipo $ cTipo01 )
        ::cTpReceita := "01"

    elseIf( ::cTipo $ cTipo02 )
        ::cTpReceita := "02"

    elseIf( ::cTipo $ cTipo03 )
        ::cTpReceita := "03"

    elseIf( ::cTipo $ cTipo04 )
        ::cTpReceita := "04"

    elseIf( ::cTipo $ cTipo05 )
        ::cTpReceita := "05"

    elseIf( ::cTipo $ cTipo06 )
        ::cTpReceita := "06"

    elseIf( ::cTipo $ cTipo10 )
        ::cTpReceita := "10"
    else 
        ::cTpReceita := ""

    endIf
    
return
