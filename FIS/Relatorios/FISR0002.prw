#include 'totvs.ch'
#include 'topconn.ch'


/*/{Protheus.doc} FISR0002
Conferencia de ICMS ST
@author Vitor Costa
@since 13/03/20
@type function
/*/
user function FISR0002()

	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
    
    Local aParamBox	:= {}
	Private cTitulo 	:= OemToAnsi("Conferencia de ICMS ST")
    
	
    AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})
	
    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({|| FISR0002B(MV_PAR01,MV_PAR02)})
	EndIf
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0002A
Conferencia de ICMS ST
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0002A(dDataDe, dDataAte)
	
    local cQuery := ""

    cQuery += " SELECT                                                                                                                            " + CRLF
    cQuery += " 	SUBSTRING(VWLIVROFISCALFILIAL02.F3_ENTRADA,1,6) as PERIODO,                                                                   " + CRLF
    cQuery += " 	VWLIVROFISCALFILIAL02.F3_CFO,                                                                                                 " + CRLF
    cQuery += " 	VWLIVROFISCALFILIAL02.F3_ESTADO,                                                                                              " + CRLF
    cQuery += " 	VWLIVROFISCALFILIAL02.CANCELADA,                                                                                              " + CRLF
    cQuery += " 	SUM(VWLIVROFISCALFILIAL02.ICMSRETID) AS ICMSRETID,                                                                            " + CRLF
    cQuery += " 	SUM(VWLIVROFISCALFILIAL02.ICMSRETIDDEVOL) AS ICMSRETIDDEVOL                                                                   " + CRLF
    cQuery += "                                                                                                                                   " + CRLF
    cQuery += " FROM VWLIVROFISCALFILIAL02 VWLIVROFISCALFILIAL02                                                                                  " + CRLF
    cQuery += " WHERE                                                                                                                             " + CRLF
    cQuery += " 	(VWLIVROFISCALFILIAL02.F3_ENTRADA>='"+DToS(dDataDe)+"' And VWLIVROFISCALFILIAL02.F3_ENTRADA<'"+DToS(dDataAte)+"')             " + CRLF
    cQuery += " 	AND VWLIVROFISCALFILIAL02.CANCELADA = 'N'                                                                                     " + CRLF
    cQuery += " GROUP BY SUBSTRING(VWLIVROFISCALFILIAL02.F3_ENTRADA,1,6),VWLIVROFISCALFILIAL02.F3_CFO,F3_ESTADO,VWLIVROFISCALFILIAL02.CANCELADA   " + CRLF
    cQuery += " ORDER BY VWLIVROFISCALFILIAL02.CANCELADA, VWLIVROFISCALFILIAL02.F3_ESTADO                                                         " + CRLF
	
return cQuery

/*/{Protheus.doc} FISR0002B
Conferencia de ICMS ST
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0002B(dDataDe, dDataAte)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= OemToAnsi("Conferencia de ICMS ST_" + cTipoEmp)	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := FISR0002A(dDataDe, dDataAte)
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return