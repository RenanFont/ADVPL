#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} NaturOFM
Classe para retornar os dados do fornecedores

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class NaturOFM
	data cCodEmp
	data cFilEntida
	data cCod
	data cDescri
	data cTipo
	data cPai
	data cUso
	data cMsBloq

	data empresa
	data cod
	data descri
	data sincroniza
	
	data oJson
	data aDados
	data aJDados
	data cError

	method new_NaturOFM() constructor 
	method setByAlias_NaturOFM()
	method qryInfo_NaturOFM()
	method getInfo_NaturOFM()
	method setJson_NaturOFM()
endclass

/*/{Protheus.doc} new_NaturOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_NaturOFM() class NaturOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_NaturOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_NaturOFM() class NaturOFM
    local cAliasQry	:= ::qryInfo_NaturOFM()
    local oNaturOFM	:= nil

    while( !(cAliasQry)->( Eof() ) )
        oNaturOFM  := nil
        oNaturOFM  := NaturOFM():new_NaturOFM()

        oNaturOFM:setByAlias_NaturOFM(cAliasQry)
        oNaturOFM:setJson_NaturOFM()
        
        AAdd( ::aDados  , oNaturOFM )
        Aadd( ::aJDados , oNaturOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_NaturOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_NaturOFM() class NaturOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf

    cQuery += CRLF + "  FROM "+ RetSqlName("SED") +" SED  	"
    cQuery += CRLF + "  WHERE                             	"
    cQuery += CRLF + "      SED.D_E_L_E_T_ = ' '           	"

	if( !Empty(::descri) )
        cQuery += CRLF + " AND SED.ED_DESCRIC LIKE '%"+ Alltrim(::descri) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SED.ED_CODIGO = '"+ Alltrim(::cod) +"' "
    endIf
     
    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SED.ED_XDTALT + ' ' + SED.ED_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_NaturOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_NaturOFM(cAliasQry) class NaturOFM
	::cCodEmp		:= cEmpAnt
	::cFilEntida	:= (cAliasQry)->ED_FILIAL
	::cCod			:= (cAliasQry)->ED_CODIGO
	::cDescri		:= (cAliasQry)->ED_DESCRIC
	::cTipo			:= (cAliasQry)->ED_TIPO
	::cPai			:= (cAliasQry)->ED_PAI
	::cUso			:= (cAliasQry)->ED_USO
	::cMsBloq		:= iif( allTrim( (cAliasQry)->ED_MSBLQL ) == "1", "BLOQUEADO", "N_BLOQUEADO" )
return

/*/{Protheus.doc} setJson_NaturOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_NaturOFM() class NaturOFM
	::oJson["cCodEmp"]		:= ::cCodEmp	
	::oJson["cFilEntida"]	:= ::cFilEntida
	::oJson["cCod"]			:= ::cCod		
	::oJson["cDescri"]		:= ::cDescri	
	::oJson["cTipo"]		:= ::cTipo		
	::oJson["cPai"]			:= ::cPai		
	::oJson["cUso"]			:= ::cUso		
	::oJson["cMsBloq"]		:= ::cMsBloq	
return
