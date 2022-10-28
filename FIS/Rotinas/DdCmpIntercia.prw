#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} DdCmpIntercia
Classe para buscar as inforações para envio das informações

@author Geeker Company
@since 28/09/2017
@version 1.0 
/*/
class DdCmpIntercia from LongNameClass
 	data R_SUCESSO
	data R_ERRO
	
	data P_PARCIAL
	data P_BAIXADO
	data P_NAOBAIXA
	
	data cAliasQry		
	data aDados

	data nCobranca
	data nStatus
	data nRetorno
	
	data lOK
	data cFil
	data cPrefixo
	data cNumero
	data cParcela
	data cTipo
	data cFornece
	data cLoja
	data cForCob
	data cLojCob
	data cNomeFor
	data cPortado
	data dEmissao
	data dVencto
	data dVencRea
	data nNumVenc
	data nValor
	data nSaldo
	data nRecno
	data cEmpCob
	data cEnvCob
	data cStatBaixa
	data cRetCob
	data cRetErro
	data cHistorico
	data cEmCobr

	data cFilDe
    data cCliDe
    data cNomeDe
	data cPrefDe
	data cNumDe
	data cNatDe
    data dEmisDe
    data dEmisAte
	data dVencDe
	data dVencAte
	data dVencReDe
	data dVencReAte
	data cTpParam
	
	method new() constructor 
	method setByAlias()
	method qryInfo()
	method getInfo()
endclass

/*/{Protheus.doc} new
Metodo construtor
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method new() class DdCmpIntercia
	::R_SUCESSO		:= "S"
	::R_ERRO		:= "E"
	
	::P_PARCIAL		:= "P"
	::P_BAIXADO		:= "B"
	::P_NAOBAIXA	:= "N"

	::cAliasQry 	:= GetNextAlias()
	::aDados		:= {}

	::nCobranca		:= 1
	::nStatus		:= 1
	::nRetorno		:= 1
	
	::lOK			:= .F.

	::cFil			:= ''
	::cPrefixo		:= ''
	::cNumero		:= ''
	::cParcela		:= ''
	::cTipo			:= ''
	::cFornece		:= ''
	::cLoja			:= ''
	::cForCob		:= ''
	::cLojCob		:= ''
	::cNomeFor		:= ''
	::cPortado 		:= ''	
	::dEmissao		:= Ctod('  /  /  ')
	::dVencto		:= Ctod('  /  /  ')
	::dVencRea		:= Ctod('  /  /  ')
	::nValor		:= 0
	::nSaldo		:= 0
	::nRecno		:= 0
	::cEmpCob		:= ''
	::cEnvCob		:= ''
	::cStatBaixa	:= ''

	::cFilDe		:= ''
    ::cCliDe		:= ''
    ::cNomeDe		:= ''
	::cPrefDe		:= ''
	::cNumDe		:= ''
	::cNatDe		:= ''
    ::dEmisDe		:= Ctod('  /  /  ')
    ::dEmisAte		:= Ctod('  /  /  ')
	::dVencDe		:= Ctod('  /  /  ')
	::dVencAte		:= Ctod('  /  /  ')
	::dVencReDe		:= Ctod('  /  /  ')
	::dVencReAte	:= Ctod('  /  /  ')
	::cTpParam		:= GetMv("ZZ_TPFICB", .T., "'NF'")

return

/*/{Protheus.doc} exec
Executa os métodos principais
@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method getInfo() class DdCmpIntercia
	local oDdCmpIcia 	:= nil
	local cRet			:= ""
	
	::cAliasQry := ::qryInfo()
	
	while !(::cAliasQry)->(Eof())
		oDdCmpIcia := DdCmpIntercia():new()		
		oDdCmpIcia:setByAlias(::cAliasQry)
	
		AAdd(::aDados, oDdCmpIcia)
		
		(::cAliasQry)->(DbSkip())
	endDo
	
	if(Select(::cAliasQry) > 0)
		(::cAliasQry)->(DbCloseArea())
	endIf

return cRet

/*/{Protheus.doc} qryInfo
Metodo para buscar os dados dos titulos

@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method qryInfo() class DdCmpIntercia
	local cQuery 	:= ""
	
	cQuery += CRLF + " SELECT 	SE2.*, "
	cQuery += CRLF + " 			SE2.R_E_C_N_O_ E2RECNO, SA2.A2_NOME "
	CQuery += CRLF + " FROM " + RetSqlName("SE2") + " SE2 "

	CQuery += CRLF + " INNER JOIN " + RetSqlName("SA2") + " SA2 "
	CQuery += CRLF + " 	ON	SA2.D_E_L_E_T_ = ''	"
	CQuery += CRLF + " 	AND SA2.A2_FILIAL = '" + FwFilial('SA2') + "' "
	CQuery += CRLF + " 	AND SA2.A2_COD = SE2.E2_FORNECE "
	CQuery += CRLF + " 	AND SA2.A2_LOJA = SE2.E2_LOJA "

	cQuery += CRLF + " WHERE 	SE2.D_E_L_E_T_ = '' "
	cQuery += CRLF + "		AND SE2.E2_SALDO > 0 "
		
	//cQuery += CRLF + " AND SE2.E2_FILIAL = '" + FwxFilial('SE2') + "' "	//Comentado Bruno Tamanaka 2022/05/04 -- Chamado 0322-000170

	//Emissão
	If !Empty( ::dEmisDe )
		cQuery += CRLF + "   AND SE2.E2_EMISSAO	>= '"+ DtoS(::dEmisDe) +"' "
	Else
		cQuery += CRLF + "   AND SE2.E2_EMISSAO	>= '' "
	Endif
	
	If !Empty( ::dEmisAte )
		cQuery += CRLF + "   AND SE2.E2_EMISSAO	<= '"+ DtoS(::dEmisAte) +"' "
	Else
		cQuery += CRLF + "   AND SE2.E2_EMISSAO	<= '99999999' "
	Endif
	
	//Vencimento
	If !Empty( ::dVencDe )
		cQuery += CRLF + "   AND SE2.E2_VENCTO	>= '"+ DtoS(::dVencDe) +"' "
	Else
		cQuery += CRLF + "   AND SE2.E2_VENCTO	>= '' "
	Endif
	
	If !Empty( ::dVencAte )
		cQuery += CRLF + "   AND SE2.E2_VENCTO	<= '"+ DtoS(::dVencAte) +"' "
	Else
		cQuery += CRLF + "   AND SE2.E2_VENCTO	<= '99999999' "
	Endif

	If !Empty( ::dVencReDe )
		cQuery += CRLF + "   AND SE2.E2_VENCREA	>= '"+ DtoS(::dVencReDe) +"' "
	Else
		cQuery += CRLF + "   AND SE2.E2_VENCREA	>= '' "
	Endif
	
	If !Empty( ::dVencReAte )
		cQuery += CRLF + "   AND SE2.E2_VENCREA	<= '"+ DtoS(::dVencReAte) +"' "
	Else
		cQuery += CRLF + "   AND SE2.E2_VENCREA	<= '99999999' "
	Endif

	cQuery += CRLF + "   AND SE2.E2_FORNECE IN('000229','003345') "

	if(!Empty(::cTpParam))
		cQuery += CRLF + "   AND SE2.E2_TIPO IN ("+ ::cTpParam +") " + CRLF	
	endIf	

	TcQuery cQuery New Alias (::cAliasQry)
		
return ::cAliasQry

/*/{Protheus.doc} setByAlias
Seta os valores pelo alias

@author Fabio Hayama - Geeker Company
@since 28/09/2017 
@version 1.0
/*/
method setByAlias(cAliasQry) class DdCmpIntercia
	::lOK			:= .F.
	
	SE2->(DbGoTo((cAliasQry)->E2RECNO))
	
	::cFil			:= Alltrim((cAliasQry)->E2_FILIAL)
	::cPrefixo		:= Alltrim((cAliasQry)->E2_PREFIXO)
	::cNumero		:= Alltrim((cAliasQry)->E2_NUM)
	::cParcela		:= Alltrim((cAliasQry)->E2_PARCELA)
	::cTipo			:= Alltrim((cAliasQry)->E2_TIPO)
	::cFornece		:= Alltrim((cAliasQry)->E2_FORNECE)	
	::cLoja			:= Alltrim((cAliasQry)->E2_LOJA)
	::cNomeFor		:= Alltrim((cAliasQry)->A2_NOME)
	::dEmissao		:= StoD( (cAliasQry)->E2_EMISSAO )
	::dVencto		:= StoD( (cAliasQry)->E2_VENCTO )
	::dVencRea		:= StoD( (cAliasQry)->E2_VENCREA )	
	::nNumVenc		:= iif(::dVencRea < dDataBase, dDataBase - ::dVencRea, 0)
	::nValor		:= (cAliasQry)->E2_VALOR
	::nSaldo		:= (cAliasQry)->E2_SALDO
	::nRecno		:= (cAliasQry)->E2RECNO
	
	if(::nSaldo == 0)
		::cStatBaixa	:= ::P_BAIXADO
	elseIf(::nSaldo >=  ::nValor)
	 	::cStatBaixa	:= ::P_NAOBAIXA
	else
	 	::cStatBaixa	:= ::P_PARCIAL
	endIf
	
return
