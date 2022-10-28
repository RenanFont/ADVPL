#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} LP52001D
//LP Para trazer a conta Debito nos descontos contratuais baseados na baixa de desconto
já alterada no ponto de entrada F200TIT, pelo cadastro na tabela ZZI
@author Manoel Nésio
@since 13/01/2020
@version undefined
@example
(examples)
@see (links_or_references)
/*/
user function LP52001D()

	Local aArea 	:= GetArea()  
	Local cMov		:= ""//Left(Posicione("ZZI",1,xFilial("ZZI")+SE5->E5_CLIENTE+SE5->E5_LOJA,"ZZI_MOTBX"),1)
	Local cConta	:= ""
	Local cSe5		:= GetNextAlias()

	cQuery := " SELECT E5_MOTBX " 
	cQuery += " FROM "+ RetSqlName("SE5") +" SE5 					" + CRLF
	cQuery += " WHERE												" + CRLF
	cQuery += "         SE5.E5_FILIAL  	= '"+  SE5->E5_FILIAL	+"'		"        + CRLF
	cQuery += "     AND SE5.E5_NUMERO  	= '"+  SE5->E5_NUMERO 	    +"'		" + CRLF	
	cQuery += "     AND SE5.E5_PARCELA 	= '"+  SE5->E5_PARCELA 	    +"'		" + CRLF
	cQuery += "     AND SE5.E5_TIPO 	= '"+  SE5->E5_TIPO 	    +"'		" + CRLF
	cQuery += "     AND SE5.E5_PREFIXO 	= '"+  SE5->E5_PREFIXO 	    +"'		" + CRLF
	cQuery += "     AND SE5.E5_CLIFOR   = '"+  SE5->E5_CLIENTE	+"'		" + CRLF	
	cQuery += "     AND SE5.E5_LOJA     = '"+  SE5->E5_LOJA     +"'		" + CRLF	
	cQuery += "     AND SE5.E5_TIPODOC  = 'DC'		" + CRLF				
	cQuery += "     AND SE5.D_E_L_E_T_  = ''						" + CRLF
	
	if Select(cSe5) > 0

		dbSelectArea(cSe5)
		dbCloseArea()

	endif

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cSe5, .F., .T. )

	If (cSe5)->( !Eof() )

		cMov := ALLTRIM((cSe5)->E5_MOTBX)

	ENDIF

	(cSe5)->(dbclosearea() )

	cConta:= IiF(Left(cMov,1) == "C", '32000001', IiF(Left(cMov,1) == "P",'32000002','45120003' ) )

	RestArea(aArea)

return(cConta)