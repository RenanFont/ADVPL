#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} CondPgtOFM
Classe para retornar os dados do fornecedores

@author Fabio Hayama - Geeker Company
@since 28/09/2017
@version 1.0
/*/
class CondPgtOFM
	data cCodEmp
	data cFilEntida
	data cCod
	data cDescri
	data cTipo
	data cMsBloq

	data empresa
	data cod
	data descri
	data sincroniza

	data oJson
	data aDados
	data aJDados
	data cError

	method new_CondPgtOFM() constructor 
	method setByAlias_CondPgtOFM()
	method qryInfo_CondPgtOFM()
	method getInfo_CondPgtOFM()
	method setJson_CondPgtOFM()
endclass

/*/{Protheus.doc} new_CondPgtOFM
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new_CondPgtOFM() class CondPgtOFM
    ::oJson     := JsonObject():New()

    ::aDados    := {}
    ::aJDados   := {}
    
    ::cError    := ""
return

/*/{Protheus.doc} getInfo_CondPgtOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo_CondPgtOFM() class CondPgtOFM
    local cAliasQry	:= ::qryInfo_CondPgtOFM()
    local oCondPgtOFM	:= nil

    while( !(cAliasQry)->( Eof() ) )
        oCondPgtOFM  := nil
        oCondPgtOFM  := CondPgtOFM():new_CondPgtOFM()

        oCondPgtOFM:setByAlias_CondPgtOFM(cAliasQry)
        oCondPgtOFM:setJson_CondPgtOFM()
        
        AAdd( ::aDados  , oCondPgtOFM )
        Aadd( ::aJDados , oCondPgtOFM:oJson )
               
        (cAliasQry)->( DbSkip() )
    endDo

    if( Select(cAliasQry) > 0 )
        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} getInfo_CondPgtOFM
Metodo para buscar as informacoes
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo_CondPgtOFM() class CondPgtOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
    local cTopEnt   := GetMv("ZZ_TPOFM", .F., "")

    if( !Empty(cTopEnt) )
        cQuery += CRLF + "  SELECT TOP "+ cTopEnt +" *  "        
    else
        cQuery += CRLF + "  SELECT *                    "        
    endIf
    
    cQuery += CRLF + "  FROM "+ RetSqlName("SE4") +" SE4  	"
    cQuery += CRLF + "  WHERE                             	"
    cQuery += CRLF + "      SE4.D_E_L_E_T_ = ' '           	"

    if( !Empty(::descri) )
        cQuery += CRLF + " AND SE4.E4_DESCRI LIKE '%"+ Alltrim(::descri) +"%' "
    endIf

    if( !Empty(::cod) )
        cQuery += CRLF + " AND SE4.E4_CODIGO = '"+ Alltrim(::cod) +"' "
    endIf
     
    if( !Empty(::sincroniza) )
        cQuery += CRLF + " AND SE4.E4_XDTALT + ' ' + SE4.E4_XHRALT >= '"+ ::sincroniza +"' "
    endIf

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry

/*/{Protheus.doc} setByAlias_CondPgtOFM
Metodo para setar as informacoes pelo alias
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias_CondPgtOFM(cAliasQry) class CondPgtOFM
	::cCodEmp		:= cEmpAnt
	::cFilEntida	:= (cAliasQry)->E4_FILIAL
	::cCod			:= (cAliasQry)->E4_CODIGO
	::cDescri		:= (cAliasQry)->E4_DESCRI
	::cTipo			:= (cAliasQry)->E4_TIPO
	::cMsBloq		:= iif( allTrim( (cAliasQry)->E4_MSBLQL ) == "1", "BLOQUEADO", "N_BLOQUEADO" )
return

/*/{Protheus.doc} setJson_CondPgtOFM
Metodo para setar os valores do JSON
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setJson_CondPgtOFM() class CondPgtOFM
	::oJson["cCodEmp"]		:= ::cCodEmp
	::oJson["cFilEntida"]	:= ::cFilEntida
	::oJson["cCod"]			:= ::cCod
	::oJson["cDescri"]		:= ::cDescri
	::oJson["cTipo"]		:= ::cTipo
	::oJson["cMsBloq"]		:= ::cMsBloq
return
