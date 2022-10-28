#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} CTBR0007
Soma de contas Contabil UNION
@author Vitor Costa
@since 20/03/20
@type function
/*/
user function CTBR0007()

	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
    Local cCredDe   := Space(TamSX3("CT2_CREDIT")[1])
    Local cCredAte  := Space(TamSX3("CT2_CREDIT")[1])
    Local cCCCDe     := Space(TamSX3("CT2_CCC")[1])
    Local cCCCAte    := Space(TamSX3("CT2_CCC")[1])
    Local cCCDDe     := Space(TamSX3("CT2_CCD")[1])
    Local cCCDAte    := Space(TamSX3("CT2_CCD")[1])

    Local aParamBox	:= {}
	Private cTitulo 	:= OemToAnsi("Soma de contas Contabil UNION")
    
	
    AADD(aParamBox,{1, "Data De"	    ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	    ,dDataAte	    ,""  ,"",""	  ,""   ,50         ,.T.})
    AADD(aParamBox,{1, "Conta De"	    ,cCredDe		,""  ,"",""   ,""   ,50         ,.F.}) 
    AADD(aParamBox,{1, "Conta Ate"	    ,cCredAte		,""  ,"",""   ,""   ,50         ,.T.}) 
    AADD(aParamBox,{1, "CCC. De"  	    ,cCCCDe		    ,""  ,"",""   ,""   ,50         ,.F.}) 
    AADD(aParamBox,{1, "CCC. Ate"	    ,cCCCAte	    ,""  ,"",""   ,""   ,50         ,.T.}) 
    AADD(aParamBox,{1, "CCD. De"  	    ,cCCDDe		    ,""  ,"",""   ,""   ,50         ,.F.}) 
    AADD(aParamBox,{1, "CCD. Ate"	    ,cCCDAte	    ,""  ,"",""   ,""   ,50         ,.T.}) 	

    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({|| CTBR0007B(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08)})
	EndIf
    
    U_MCERLOG()
return

/*/{Protheus.doc} CTBR0007B
Soma de contas Contabil UNION
@author Vitor Costa
@since 20/03/20
@type function
/*/
Static Function CTBR0007B(dDataDe, dDataAte, cCredDe, cCredAte, cCCCDe, cCCCAte,cCCDDe,cCCDAte)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Soma de contas Contabil UNION_" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	Local cQryCred	:= ""
	Local cQryDeb	:= ""
	
	cQryCred	:= RetQryCred(dDataDe, dDataAte, cCredDe, cCredAte, cCCCDe, cCCCAte)
	cQryDeb	    := RetQryDeb(dDataDe, dDataAte, cCredDe, cCredAte, cCCDDe,cCCDAte) 
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:OpenClasExcel()
	
	//Debito
	oObjExcel:cQuery := cQryCred 
	oObjExcel:SetNomePlanilha("Credito")
	oObjExcel:PrintXml()
	
	//Credito
	oObjExcel:cQuery := cQryDeb 
	oObjExcel:SetNomePlanilha("Debito")
	oObjExcel:PrintXml()
	
	oObjExcel:CloseClasExcel()
Return

/*/{Protheus.doc} RetQryCred
Soma de contas Contabil UNION
@author Vitor Costa
@since 20/03/20
@type function
/*/
Static Function RetQryCred(dDataDe, dDataAte, cCredDe, cCredAte, cCCCDe, cCCCAte)

	Local cQuery := ""
	
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'CERATTI' EMPRESA,                                                                                                              " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,            " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2020 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_CREDIT BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCC BETWEEN '" +cCCCDe+ "' AND '" +cCCCAte+ "'                                                                            " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF
	cQuery += "	UNION                                                                                                                               " + CRLF
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'OMAMORI' EMPRESA,                                                                                                              " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2010 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_CREDIT BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCC BETWEEN '" +cCCCDe+ "' AND '" +cCCCAte+ "'                                                                            " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF
	cQuery += "	UNION                                                                                                                               " + CRLF
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'TALIS' EMPRESA,                                                                                                                " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2060 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_CREDIT BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCC BETWEEN '" +cCCCDe+ "' AND '" +cCCCAte+ "'                                                                            " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF
	cQuery += "	UNION                                                                                                                               " + CRLF
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'CLEAN FIELD' EMPRESA,                                                                                                          " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2070 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_CREDIT BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCC BETWEEN '" +cCCCDe+ "' AND '" +cCCCAte+ "'                                                                            " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF	

	
return cQuery

/*/{Protheus.doc} RetQryDeb
Soma de contas Contabil UNION
@author Vitor Costa
@since 20/03/20
@type function
/*/
Static Function RetQryDeb(dDataDe, dDataAte, cCredDe, cCredAte, cCCDDe, cCCDAte) 
	
    Local cQuery := ""
	
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'CERATTI' EMPRESA,                                                                                                              " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2020 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_DEBITO BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCD BETWEEN '" +cCCDDe+ "' AND '" +cCCDAte+ "'                                                                          " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF
	cQuery += "	UNION                                                                                                                               " + CRLF
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'OMAMORI' EMPRESA,                                                                                                              " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2010 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_DEBITO BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCD BETWEEN '" +cCCDDe+ "' AND '" +cCCDAte+ "'                                                                          " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF
	cQuery += "	UNION                                                                                                                               " + CRLF
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'TALIS' EMPRESA,                                                                                                                " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2060 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_DEBITO BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCD BETWEEN '" +cCCDDe+ "' AND '" +cCCDAte+ "'                                                                          " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF
	cQuery += "	UNION                                                                                                                               " + CRLF
	cQuery += "	SELECT                                                                                                                              " + CRLF
	cQuery += "		'CLEAN FIELD' EMPRESA,                                                                                                          " + CRLF
	cQuery += "		CT2_FILIAL,CT2_DATA DT_LCTO,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_MOEDLC,CT2_DC,CT2_DEBITO,CT2_CREDIT,             " + CRLF
	cQuery += "		CT2_DCD,CT2_DCC,CT2_VALOR,CT2_MOEDAS,CT2_HP,CT2_HIST,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,CT2_CLVLCR       " + CRLF
	cQuery += "		CT2_ATIVDE,CT2_ATIVCR,CT2_EMPORI,CT2_FILORI                                                                                     " + CRLF
	cQuery += "	FROM CT2070 (NOLOCK)                                                                                                                " + CRLF
	cQuery += "	WHERE CT2_DATA BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                                                 " + CRLF
	cQuery += "		AND CT2_DEBITO BETWEEN '" +cCredDe+ "' AND '" +cCredAte+ "'                                                                     " + CRLF
	cQuery += "		AND CT2_CCD BETWEEN '" +cCCDDe+ "' AND '" +cCCDAte+ "'                                                                          " + CRLF
	cQuery += "		AND D_E_L_E_T_ = ''                                                                                                             " + CRLF	


return cQuery