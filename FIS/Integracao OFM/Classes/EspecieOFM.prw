#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} EspecieOFM
Classe para retornar os dados das especie das notas de entrada

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class EspecieOFM 
	data cCodEmp
	data cFilEntida
	data cCod
	data cDescri

	data empresa
	data cod
	data descri

    data oJson
    data aDados
    data aJDados    
    data cError
        	
	method new_EspecieOFM() constructor 
	method setByAlias_EspecieOFM()
	method qryInfo_EspecieOFM()
	method getInfo_EspecieOFM()
    method setJson_EspecieOFM()
endclass

/*/{Protheus.doc} new_EspecieOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_EspecieOFM() class EspecieOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_EspecieOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_EspecieOFM() class EspecieOFM
    local cAliasQry	:= ::qryInfo_EspecieOFM()
    local oEspecieOFM	:= nil

    while( !(cAliasQry)->( Eof() ) )
        oEspecieOFM  := nil
        oEspecieOFM  := EspecieOFM():new_EspecieOFM()

        oEspecieOFM:setByAlias_EspecieOFM(cAliasQry)
        oEspecieOFM:setJson_EspecieOFM()
        
        AAdd( ::aDados  , oEspecieOFM )
        Aadd( ::aJDados , oEspecieOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_EspecieOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_EspecieOFM() class EspecieOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()

	cQuery += CRLF + "  SELECT X5_FILIAL, X5_TABELA, X5_CHAVE, X5_DESCRI	"
	cQuery += CRLF + "  FROM "+ RetSqlName("SX5") +" SX5    				"
	cQuery += CRLF + "  WHERE                               				"
	cQuery += CRLF + "  		SX5.X5_TABELA   = '42'      				"
	cQuery += CRLF + "  	AND SX5.D_E_L_E_T_  = ''        				"

    if( !Empty(::descri) )
        cQuery += CRLF + " AND SX5.X5_DESCRI LIKE '%"+ Alltrim(::descri) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SX5.X5_CHAVE = '"+ Alltrim(::cod) +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_EspecieOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_EspecieOFM(cAliasQry) class EspecieOFM

	::cCodEmp		:= cEmpAnt
	::cFilEntida	:= (cAliasQry)->X5_FILIAL
	::cCod			:= (cAliasQry)->X5_CHAVE
	::cDescri		:= (cAliasQry)->X5_DESCRI

return

/*/{Protheus.doc} setJson_EspecieOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_EspecieOFM() class EspecieOFM

	::oJson["cCodEmp"]		:= ::cCodEmp	
	::oJson["cFilEntida"]	:= ::cFilEntida
	::oJson["cCod"]			:= ::cCod
	::oJson["cDescri"]		:= ::cDescri

return
