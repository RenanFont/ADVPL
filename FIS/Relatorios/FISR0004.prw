#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0004
Conferencia de Faturamento por NCM
@author Vitor Costa
@since 13/03/20
@type function
/*/
user function FISR0004()

	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	
    Local aParamBox	:= {}
	Private cTitulo 	:= OemToAnsi("Conferencia de Faturamento por NCM")

	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})

	If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({|| FISR0004B(MV_PAR01,MV_PAR02)})
	EndIf
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0004A
Conferencia de Faturamento por NCM
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0004A(dDataDe, dDataAte)
	
	local cQuery := ""

	cQuery += " SELECT                                                                                                                              " + CRLF
	cQuery += " 	D2_COD,                                                                                                                         " + CRLF
	cQuery += " 	MAX(SB1.B1_POSIPI)B1_POSIPI,                                                                                                    " + CRLF
	cQuery += " 	SUM(D2_TOTAL)D2_TOTAL                                                                                                           " + CRLF
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 (NOLOCK)                                                                                         " + CRLF
	cQuery += " 	LEFT JOIN " + RetSqlName("SD2") + " SD2 (NOLOCK) ON                                                                             " + CRLF
	cQuery += " 		D2_DOC = F2_DOC                                                                                                             " + CRLF
	cQuery += " 		AND D2_SERIE = F2_SERIE                                                                                                     " + CRLF
	cQuery += " 		AND D2_CLIENTE = F2_CLIENTE                                                                                                 " + CRLF
	cQuery += " 		AND D2_LOJA = F2_LOJA                                                                                                       " + CRLF
	cQuery += " 		AND	SD2.D_E_L_E_T_ = ''                                                                                                     " + CRLF
	cQuery += " 	LEFT JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON                                                                             " + CRLF
	cQuery += " 	SB1.B1_COD = SD2.D2_COD                                                                                                         " + CRLF
	cQuery += " 	AND SB1.D_E_L_E_T_ = ''                                                                                                         " + CRLF
	cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2")+ "'                                                                                           " + CRLF
	cQuery += " 	AND F2_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                             " + CRLF
	cQuery += " 	AND D2_CF IN ('5101','5102','5113','5114','5116','5401','5403','5405','6101','6102','6107','6108','6109','6110','6401','6403')  " + CRLF
	cQuery += " 	AND SF2.D_E_L_E_T_ = ''                                                                                                         " + CRLF
	cQuery += " 	GROUP BY D2_COD                                                                                                                 " + CRLF
	cQuery += " 	ORDER BY D2_COD                                                                                                                 " + CRLF

return cQuery

/*/{Protheus.doc} FISR0004B
Conferencia de Faturamento por NCM
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0004B(dDataDe, dDataAte)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= OemToAnsi("Conferencia de Faturamento por NCM_" + cTipoEmp)	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := FISR0004A(dDataDe, dDataAte)
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return