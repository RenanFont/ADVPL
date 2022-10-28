#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0005
Conferencia de Notas entre Empresas
@author Vitor Costa
@since 13/03/20
@type function
/*/
user function FISR0005()

	Private cTitulo 	:= OemToAnsi("Conferencia de Notas entre Empresas")

		Processa({|| FISR0005B()})
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0005B
Conferencia de Notas entre Empresas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function FISR0005B()
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Conferencia de Notas entre Empresas_" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	Local cQryOpT	:= ""
	Local cQryETO	:= ""
	Local cQrySOpC	:= "" 
	Local cQryECdO	:= ""  
	
	cQryOpT	:= SaiOmaTalis()
	cQryETO	:= EntTaDOma() 
	cQrySOpC	:= SaiOpClean() 
	cQryECdO	:= EntCleDOma()  
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:OpenClasExcel()
	
	//Saida OMA P-Talis
	oObjExcel:cQuery := cQryOpT
	oObjExcel:SetNomePlanilha("Saida OMA P-Talis")
	oObjExcel:PrintXml()
	
	//Entrada TALIS de OMA
	oObjExcel:cQuery := cQryETO
	oObjExcel:SetNomePlanilha("Entrada TALIS de OMA")
	oObjExcel:PrintXml()
	
	//Saida OMA para Clean
	oObjExcel:cQuery := cQrySOpC
	oObjExcel:SetNomePlanilha("Saida OMA para Clean")
	oObjExcel:PrintXml()
	
	//Entrada Clean de OMA
	oObjExcel:cQuery := cQryECdO
	oObjExcel:SetNomePlanilha("Entrada Clean de OMA")
	oObjExcel:PrintXml()			
	
	oObjExcel:CloseClasExcel()
Return

/*/{Protheus.doc} SaiOmaTalis
Conferencia de Notas entre Empresas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function SaiOmaTalis()

	Local cQuery := ""
	
	cQuery += "	SELECT                                                                                                                  " + CRLF
	cQuery += "		D2_FILIAL,CONVERT(DATE,D2_EMISSAO)D2_EMISSAO,D2_DOC, D2_SERIE, D2_TIPO, D2_ITEM, D2_CLIENTE,D2_LOJA,A1_NOME,        " + CRLF
	cQuery += "		D2_COD,D2_UM,D2_QUANT,D2_TOTAL,D2_TES,D2_CF,D2_SEGUM,D2_QTSEGUM                                                     " + CRLF
	cQuery += "	FROM SD2010 D2 (NOLOCK)                                                                                                 " + CRLF
	cQuery += "		INNER JOIN SA1010 A1 (NOLOCK)                                                                                       " + CRLF
	cQuery += "		ON A1_COD = D2_CLIENTE                                                                                              " + CRLF
	cQuery += "		AND A1_LOJA = D2_LOJA                                                                                               " + CRLF
	cQuery += "		AND A1.D_E_L_E_T_ = ''                                                                                              " + CRLF
	cQuery += "	WHERE D2_CLIENTE = '043243' 	                                                                                        " + CRLF
	cQuery += "		AND D2_EMISSAO BETWEEN DateAdd(mm, DateDiff(mm,0,GetDate()) - 6, 0) AND DateAdd(mm, DateDiff(mm,0,GetDate())+1, -1) " + CRLF
	cQuery += "		AND D2.D_E_L_E_T_ = ''                                                                                              " + CRLF
	cQuery += "	ORDER BY D2_EMISSAO                                                                                                     " + CRLF
	
return cQuery

/*/{Protheus.doc} EntTaDOma
Conferencia de Notas entre Empresas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function EntTaDOma() 
	
    Local cQuery := ""
	
	cQuery += "	SELECT                                                                                              " + CRLF
	cQuery += "		D1_FILIAL,D1_EMISSAO,D1_DOC,1_SERIE,D1_TIPO,D1_ITEM,D1_FORNECE,D1_LOJA,A2_NOME,D1_COD,D1_UM,    " + CRLF
	cQuery += "		D1_QUANT,D1_TOTAL,D1_TES,D1_CF,D1_SEGUM,D1_QTSEGUM                                              " + CRLF
	cQuery += "	FROM SD1060 D1 (NOLOCK)                                                                             " + CRLF
	cQuery += "		INNER JOIN SA2010 A2 (NOLOCK)                                                                   " + CRLF
	cQuery += "			ON A2_COD = D1_FORNECE                                                                      " + CRLF
	cQuery += "			AND A2_LOJA = D1_LOJA                                                                       " + CRLF
	cQuery += "			AND A2.D_E_L_E_T_ = ''                                                                      " + CRLF
	cQuery += "	WHERE D1_FORNECE = '000229'                                                                         " + CRLF
	cQuery += "		AND D1_EMISSAO BETWEEN DateAdd(mm, DateDiff(mm,0,GetDate()) - 6, 0)                             " + CRLF
	cQuery += "		AND DateAdd(mm, DateDiff(mm,0,GetDate())+1, -1)                                                 " + CRLF
	cQuery += "		AND D1.D_E_L_E_T_ = ''                                                                          " + CRLF
	cQuery += "	ORDER BY D1_EMISSAO                                                                                 " + CRLF

return cQuery

/*/{Protheus.doc} SaiOpClean
Conferencia de Notas entre Empresas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static Function SaiOpClean() 
	
    Local cQuery := ""
	
	cQuery += "	SELECT                                                                                                                     " + CRLF
	cQuery += "		D2_FILIAL,D2_EMISSAO,D2_DOC,D2_SERIE,D2_TIPO,D2_ITEM,D2_CLIENTE,D2_LOJA,A1_NOME,D2_COD,D2_UM,                          " + CRLF
	cQuery += "		D2_QUANT,D2_TOTAL,D2_TES,D2_CF,D2_SEGUM,D2_QTSEGUM                                                                     " + CRLF
	cQuery += "	FROM SD2010 D2 (NOLOCK)                                                                                                    " + CRLF
	cQuery += "		INNER JOIN SA1010 A1 (NOLOCK)                                                                                          " + CRLF
	cQuery += "			ON A1_COD = D2_CLIENTE                                                                                             " + CRLF
	cQuery += "			AND A1_LOJA = D2_LOJA                                                                                              " + CRLF
	cQuery += "			AND A1.D_E_L_E_T_ = ''                                                                                             " + CRLF
	cQuery += "	WHERE D2_CLIENTE = '043746'                                                                                                " + CRLF
	cQuery += "		AND D2_EMISSAO BETWEEN DateAdd(mm, DateDiff(mm,0,GetDate()) - 6, 0) AND DateAdd(mm, DateDiff(mm,0,GetDate())+1, -1)    " + CRLF
	cQuery += "		AND D2.D_E_L_E_T_ = ''                                                                                                 " + CRLF
	cQuery += "	ORDER BY D2_EMISSAO                                                                                                        " + CRLF
                                                                                                    
return cQuery                                                                                       
                                                                                                    
/*/{Protheus.doc} EntCleDOma
Conferencia de Notas entre Empresas
@author Vitor Costa
@since 13/03/20
@type function
/*/
Static function EntCleDOma()                                                                  

	Local cQuery := ""                                                                              
                                                                                                    
	cQuery += "	SELECT                                                                                                                     " + CRLF
	cQuery += "	D1_FILIAL,D1_EMISSAO,D1_DOC,D1_SERIE,D1_TIPO,D1_ITEM,D1_FORNECE,D1_LOJA,A2_NOME,D1_COD,D1_UM,                              " + CRLF
	cQuery += "	D1_QUANT,D1_TOTAL,D1_TES,D1_CF,D1_SEGUM,D1_QTSEGUM                                                                         " + CRLF
	cQuery += "	FROM SD1070 D1 (NOLOCK)                                                                                                    " + CRLF
	cQuery += "		INNER JOIN SA2010 A2 (NOLOCK)                                                                                          " + CRLF
	cQuery += "			ON A2_COD = D1_FORNECE                                                                                             " + CRLF
	cQuery += "			AND A2_LOJA = D1_LOJA                                                                                              " + CRLF
	cQuery += "			AND A2.D_E_L_E_T_ = ''                                                                                             " + CRLF
	cQuery += "	WHERE D1_FORNECE = '000229'                                                                                                " + CRLF
	cQuery += "		AND D1_EMISSAO BETWEEN DateAdd(mm, DateDiff(mm,0,GetDate()) - 6, 0) AND DateAdd(mm, DateDiff(mm,0,GetDate())+1, -1)    " + CRLF
	cQuery += "		AND D1.D_E_L_E_T_ = ''                                                                                                 " + CRLF
	cQuery += "	ORDER BY D1_EMISSAO                                                                                                        " + CRLF

return cQuery