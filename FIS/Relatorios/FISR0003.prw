#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0003
Conferencia Cancelamento de Notas
@author Vitor Costa
@since 13/03/20
@type function
/*/
user function FISR0003()

	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	
    Local aParamBox	:= {}
	Private cTitulo 	:= OemToAnsi("Conferencia Cancelamento de Notas")

	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})

	If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({|| FISR0003B(MV_PAR01,MV_PAR02)})
	EndIf
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0003A
Conferencia Cancelamento de Notas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0003A(dDataDe, dDataAte)

	local cQuery 	:= ""
/*
	cQuery += " SELECT                                                                      " + CRLF
	cQuery += " 	vwnfimp.FILIAL,                                                         " + CRLF
	cQuery += " 	vwnfimp.TIPO,                                                           " + CRLF
	cQuery += " 	vwnfimp.DATA,                                                           " + CRLF
	cQuery += " 	vwnfimp.F2_DOC,                                                         " + CRLF
	cQuery += " 	vwnfimp.F2_SERIE                                                        " + CRLF
	cQuery += " FROM vwnfimp vwnfimp                                                        " + CRLF
	cQuery += " WHERE vwnfimp.EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'  " + CRLF
*/
	cQuery += " SELECT																			" + CRLF
	cQuery += "			'S' AS TIPO,															" + CRLF
	cQuery += "			F2_FILIAL AS FILIAL,													" + CRLF
	cQuery += "			F2_EMISSAO AS EMISSAO,													" + CRLF
	cQuery += "			F2_DOC AS DOCUMENTO,													" + CRLF
	cQuery += "			F2_SERIE AS SERIE														" + CRLF
	cQuery += "FROM																				" + CRLF
	cQuery += "" + RetSqlName("SF2") +"	SF2														" + CRLF
	cQuery += "WHERE																			" + CRLF
	cQuery += "		F2_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'				" + CRLF
	cQuery += "		AND SF2.D_E_L_E_T_ = ' '													" + CRLF
	cQuery += "UNION ALL																		" + CRLF
	cQuery += "SELECT																			" + CRLF
	cQuery += "		'E' AS TIPO,																" + CRLF
	cQuery += "		F1_FILIAL AS FILIAL,														" + CRLF
	cQuery += "		F1_EMISSAO AS EMISSAO,														" + CRLF
	cQuery += "		F1_DOC AS DOCUMENTO,														" + CRLF
	cQuery += "		F1_SERIE AS SERIE															" + CRLF
	cQuery += "FROM																				" + CRLF
	cQuery += "" + RetSqlName("SF1") +"	SF1														" + CRLF
	cQuery += "WHERE																			" + CRLF
	cQuery += "F1_DTDIGIT BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'					" + CRLF
	cQuery += "AND F1_TIPO IN ('1', '2', '3', '4', '5')											" + CRLF
	cQuery += "AND SF1.D_E_L_E_T_ = ' '															" + CRLF
	cQuery += "ORDER BY																			" + CRLF
	cQuery += "EMISSAO																			" + CRLF


return cQuery

/*/{Protheus.doc} FISR0003B
Conferencia Cancelamento de Notas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0003B(dDataDe, dDataAte)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= OemToAnsi("Conferencia Cancelamento de Notas_" + cTipoEmp)	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := FISR0003A(dDataDe, dDataAte)
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return
