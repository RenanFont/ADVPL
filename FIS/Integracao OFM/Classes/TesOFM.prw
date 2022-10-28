#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} TesOFM
Classe para retornar os dados do fornecedores

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class TesOFM 
	data cCodEmp
	data cFilEntida
	data cCod
	data cTexto
	data cCF
	data cCredIpi
	data cCredICM
	data cPisCred
	data cPisCof
	data cEstoque
	data cDuplic
	data cFinalid
	data cMsBloq

	data empresa
	data cod
	data finalid
	data sincroniza

    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_TesOFM() constructor 
	method setByAlias_TesOFM()
	method qryInfo_TesOFM()
	method getInfo_TesOFM()
    method setJson_TesOFM()
endclass

/*/{Protheus.doc} new_TesOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_TesOFM() class TesOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_TesOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_TesOFM() class TesOFM
    local cAliasQry	:= ::qryInfo_TesOFM()
    local oTesOFM	:= nil

    while( !(cAliasQry)->( Eof() ) )
        oTesOFM  := nil
        oTesOFM  := TesOFM():new_TesOFM()

        oTesOFM:setByAlias_TesOFM(cAliasQry)
        oTesOFM:setJson_TesOFM()
        
        AAdd( ::aDados  , oTesOFM )
        Aadd( ::aJDados , oTesOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_TesOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_TesOFM() class TesOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf
	
    cQuery += CRLF + "  FROM "+ RetSqlName("SF4") +" SF4  	"
    cQuery += CRLF + "  WHERE                             	"
    cQuery += CRLF + "      SF4.D_E_L_E_T_ = ' '         	"

	 if( !Empty(::finalid) )
        cQuery += CRLF + " AND SF4.F4_FINALID LIKE '%"+ Alltrim(::finalid) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SF4.F4_CODIGO = '"+ Alltrim(::cod) +"' "
    endIf
     
    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SF4.F4_XDTALT + ' ' + SF4.F4_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_TesOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_TesOFM(cAliasQry) class TesOFM
	::cCodEmp		:= cEmpAnt
	::cFilEntida	:= (cAliasQry)->F4_FILIAL
	::cCod			:= (cAliasQry)->F4_CODIGO
	::cTexto		:= (cAliasQry)->F4_TEXTO
	::cCF			:= (cAliasQry)->F4_CF
	::cCredIpi		:= (cAliasQry)->F4_CREDIPI
	::cCredICM		:= (cAliasQry)->F4_CREDICM
	::cPisCred		:= (cAliasQry)->F4_PISCRED
	::cPisCof		:= (cAliasQry)->F4_PISCOF
	::cEstoque		:= (cAliasQry)->F4_ESTOQUE
	::cDuplic		:= (cAliasQry)->F4_DUPLIC
	::cFinalid		:= (cAliasQry)->F4_FINALID
	::cMsBloq		:= iif( allTrim( (cAliasQry)->F4_MSBLQL ) == "1", "BLOQUEADO", "N_BLOQUEADO" )
return

/*/{Protheus.doc} setJson_TesOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_TesOFM() class TesOFM
	::oJson["cCodEmp"]		:= ::cCodEmp	
	::oJson["cFilEntida"]	:= ::cFilEntida
	::oJson["cCod"]			:= ::cCod		
	::oJson["cTexto"]		:= ::cTexto	
	::oJson["cCF"]			:= ::cCF		
	::oJson["cCredIpi"]		:= ::cCredIpi	
	::oJson["cCredICM"]		:= ::cCredICM	
	::oJson["cPisCred"]		:= ::cPisCred	
	::oJson["cPisCof"]		:= ::cPisCof	
	::oJson["cEstoque"]		:= ::cEstoque	
	::oJson["cDuplic"]		:= ::cDuplic	
	::oJson["cFinalid"]		:= ::cFinalid	
	::oJson["cMsBloq"]		:= ::cMsBloq	
return
