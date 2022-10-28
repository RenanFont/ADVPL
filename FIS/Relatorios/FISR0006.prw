#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0006
Relatorio DIFAL
@author Vitor Costa
@since 13/03/20
@type function
/*/
user function FISR0006()

	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
    Local cTipo     := Space(TamSX3("D2_TIPO")[1])
	
    Local aParamBox	:= {}
	Private cTitulo 	:= OemToAnsi("Relatorio DIFAL")

	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})
    AADD(aParamBox,{1, "Tipo"	       ,cTipo   	,""  ,"",""	  ,""   ,50         ,.F.})
	
    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({|| FISR0006B(MV_PAR01,MV_PAR02,MV_PAR03)})
	EndIf
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0006A
Relatorio DIFAL
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0006A(dDataDe, dDataAte, cTipo)
	
	local cQuery := ""

	cQuery += " SELECT                                                                                                          " + CRLF
	cQuery += " 	CONVERT(DATE,D2_EMISSAO)D2_EMISSAO,D2_DOC,D2_CF,D2_TOTAL,D2_VALICM,D2_VALBRUT,D2_TIPO,D2_DIFAL,D2_EST,     " + CRLF
	cQuery += " 	D2_VFCPDIF,D2_PDORI,D2_PDDES                                                                               " + CRLF
	cQuery += " FROM " + RetSqlName("SD2") + " SD2(NOLOCK)                                                                     " + CRLF
	cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2")+ "'                                                                      " + CRLF
	cQuery += " 	AND D2_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                        " + CRLF
	if !Empty(cTipo)
        cQuery += " 	AND D2_TIPO = '%"+cTipo+"%'                                                                            " + CRLF
    EndIf
    cQuery += " 	AND D_E_L_E_T_ = ''                                                                                        " + CRLF
	cQuery += " GROUP BY D2_EMISSAO,D2_DOC,D2_CF,D2_TOTAL,D2_VALICM,D2_VALBRUT,D2_TIPO,D2_EST,D2_DIFAL,D2_PDORI,               " + CRLF
	cQuery += " D2_VFCPDIF,D2_PDDES                                                                                            " + CRLF
	cQuery += " ORDER BY D2_EMISSAO                                                                                            " + CRLF

return cQuery

/*/{Protheus.doc} FISR0006B
Relatorio DIFAL
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0006B(dDataDe, dDataAte, cTipo)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= OemToAnsi("Relatorio DIFAL_" + cTipoEmp)	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := FISR0006A(dDataDe, dDataAte, cTipo)
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return
