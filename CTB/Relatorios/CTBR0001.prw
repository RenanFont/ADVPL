#include 'totvs.ch'

/*/{Protheus.doc} CTBR0001
Execução da impressão do Relatório de Verbas via Contabil.
@author 	Thomas Galvão
@since 		20/01/2020
@version 	1.0
@return 	return, Nil
/*/
user function CTBR0001()
	Local aParamBox	:= {}
	Local dDataDe	:= FirstDate( MonthSub( Date(), 1 ))
	Local dDataAte	:= LastDate(  MonthSub( Date(), 1 ))
	Private cTitulo := "Relatório Controle de Verbas - Contabilidade"
	
	aAdd(aParamBox,{1, "Data De ?"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	aAdd(aParamBox,{1, "Data Ate?"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.}) 	 
	
	If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({||CTBR0001A(MV_PAR01, MV_PAR02) })
	EndIf
	
	U_MCERLOG()
	
return

/*/{Protheus.doc} CTBR0001A
Execução da impressão do Relatório.
@author 	Thomas Galvão
@since 		20/01/2020
@version 	1.0
@return 	return, Nil
/*/
Static Function CTBR0001A(dDataDe, dDataAte)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Relatorio_Verbas_Contabil_" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	Local cQryVer	:= ""  
	
	default dDataDe 	:= ""
	default dDataAte	:= ""
	
	cQryVer	:= GetVerbCtb(dDataDe, dDataAte)
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:OpenClasExcel()
	
	//Verbas Contabil
	oObjExcel:cQuery := cQryVer
	oObjExcel:SetNomePlanilha("Verbas Contabil")
	oObjExcel:PrintXml()
		
	oObjExcel:CloseClasExcel()
Return

/*/{Protheus.doc} GetVerbCtb
Query do Relatorio
@author 	Thomas Galvão
@since 		20/01/2020
@version 	1.0
@return 	return, Nil
/*/
Static Function GetVerbCtb(dDataDe, dDataAte)
	local cQryVer := ""
	
	default dDataDe 	:= ""
	default dDataAte	:= "" 

	cQryVer += "SELECT EMPRESA, CT2_EMPORI, CT2_FILORI,                                                                                                                                                                               " + CRLF
	cQryVer += "	CONVERT(DATE,TMP.CT2_DATA) CT2_DATA,                                                                                                                                                                              " + CRLF
	cQryVer += "	CT1_DESC01,                                                                                                                                                                                                       " + CRLF
	cQryVer += "	CT2_CREDIT,                                                                                                                                                                                                       " + CRLF
	cQryVer += "	ISNULL(	CASE                                                                                                                                                                                                      " + CRLF
	cQryVer += "				WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN 'CLIENTE'                                                                                                                                              " + CRLF
	cQryVer += "				ELSE 'FORNECEDOR'                                                                                                                                                                                     " + CRLF
	cQryVer += "			END,'') TABELA, TMP.CLIENTE,                                                                                                                                                                              " + CRLF
	cQryVer += "	ISNULL(CASE                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN                                                                                                                                                                " + CRLF
	cQryVer += "			(SELECT TOP 1 A1_CGC FROM SA1010 SA1 WHERE A1_FILIAL = '' AND A1_COD = TMP.CLIENTE AND A1_LOJA = '01' AND SA1.D_E_L_E_T_ = '')                                                                            " + CRLF
	cQryVer += "		ELSE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			(SELECT TOP 1 A2_CGC FROM SA2010 SA2 WHERE A2_FILIAL = '' AND A2_LOJA = '01' AND A2_COD = TMP.CLIENTE AND SA2.D_E_L_E_T_ = '')                                                                            " + CRLF
	cQryVer += "	END,'') A1_CGC,                                                                                                                                                                                                   " + CRLF
	cQryVer += "	ISNULL(CASE                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN                                                                                                                                                                " + CRLF
	cQryVer += "			(SELECT TOP 1 A1_COD FROM SA1010 SA1 WHERE A1_FILIAL = '' AND A1_COD = TMP.CLIENTE AND A1_LOJA = '01' AND SA1.D_E_L_E_T_ = '')                                                                            " + CRLF
	cQryVer += "		ELSE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			(SELECT TOP 1 A2_COD FROM SA2010 SA2 WHERE A2_FILIAL = '' AND A2_LOJA = '01' AND A2_COD = TMP.CLIENTE AND SA2.D_E_L_E_T_ = '')                                                                            " + CRLF
	cQryVer += "	END,'') A1_COD,                                                                                                                                                                                                   " + CRLF
	cQryVer += "	ISNULL(CASE                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN                                                                                                                                                                " + CRLF
	cQryVer += "			(SELECT TOP 1 A1_NOME FROM SA1010 SA1 WHERE A1_FILIAL = '' AND A1_COD = TMP.CLIENTE AND A1_LOJA = '01' AND SA1.D_E_L_E_T_ = '')                                                                           " + CRLF
	cQryVer += "		ELSE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			(SELECT TOP 1 A2_NREDUZ FROM SA2010 SA2 WHERE A2_FILIAL = '' AND A2_COD = TMP.CLIENTE AND A2_LOJA = '01' AND SA2.D_E_L_E_T_ = '')                                                                         " + CRLF
	cQryVer += "	END,'') A1_NOME,                                                                                                                                                                                                  " + CRLF
	cQryVer += "	ISNULL(CASE                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN                                                                                                                                                                " + CRLF
	cQryVer += "			(SELECT TOP 1 A1_NREDUZ FROM SA1010 SA1 WHERE A1_FILIAL = '' AND A1_COD = TMP.CLIENTE AND A1_LOJA = '01' AND SA1.D_E_L_E_T_ = '')                                                                         " + CRLF
	cQryVer += "		ELSE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			(SELECT TOP 1 A2_NREDUZ FROM SA2010 SA2 WHERE A2_FILIAL = '' AND A2_COD = TMP.CLIENTE AND A2_LOJA = '01' AND SA2.D_E_L_E_T_ = '')                                                                         " + CRLF
	cQryVer += "	END,'') A1_NREDUZ,                                                                                                                                                                                                " + CRLF
	cQryVer += "	ISNULL(CASE                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN                                                                                                                                                                " + CRLF
	cQryVer += "			(SELECT TOP 1 A1_TABPRE FROM SA1010 SA1 WHERE A1_FILIAL = '' AND A1_COD = TMP.CLIENTE AND A1_LOJA = '01' AND SA1.D_E_L_E_T_ = '')                                                                         " + CRLF
	cQryVer += "		ELSE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			''                                                                                                                                                                                                        " + CRLF
	cQryVer += "	END,'') A1_TABPRE,                                                                                                                                                                                                " + CRLF
	cQryVer += "	ISNULL(CASE                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN CT2_CREDIT NOT IN ('21100001', '  ') THEN                                                                                                                                                                " + CRLF
	cQryVer += "			(SELECT TOP 1 A1_COND FROM SA1010 SA1 WHERE A1_FILIAL = '' AND A1_COD = TMP.CLIENTE AND A1_LOJA = '01' AND SA1.D_E_L_E_T_ = '')                                                                           " + CRLF
	cQryVer += "		ELSE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			''                                                                                                                                                                                                        " + CRLF
	cQryVer += "	END,'') A1_COND,                                                                                                                                                                                                  " + CRLF
	cQryVer += "	CT2_HIST,                                                                                                                                                                                                         " + CRLF
	cQryVer += "	DEBITO, CREDITO, CT2_LOTE, DESCRICAO                                                                                                                                                                              " + CRLF
	cQryVer += "FROM (                                                                                                                                                                                                                " + CRLF
	cQryVer += "	SELECT                                                                                                                                                                                                            " + CRLF
	cQryVer += "		'OMAMORI' EMPRESA,                                                                                                                                                                                            " + CRLF
	cQryVer += "		SUBSTRING(CT2_HIST,1,5) HIST,                                                                                                                                                                                 " + CRLF
	cQryVer += "		CASE WHEN SUBSTRING(CT2_HIST,1,5) = 'RECLA' THEN SUBSTRING(CT2_HIST, 48,6)                                                                                                                                    " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC.' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-5,6)                                                                                                                      " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC ' THEN SUBSTRING(CT2_HIST,19,6)                                                                                                                                          " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' OR SUBSTRING(CT2_HIST,1,5) = 'PROVI'  THEN ''                                                                                                                          " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF -' THEN                                                                                                                                                                   " + CRLF
	cQryVer += "			CASE                                                                                                                                                                                                      " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1010 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                 " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2010 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE2.D_E_L_E_T_ = '' )     " + CRLF
	cQryVer += "				ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1010 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                                                 " + CRLF
	cQryVer += "			END                                                                                                                                                                                                       " + CRLF
	cQryVer += "			ELSE SUBSTRING(CT2_HIST,1,6)                                                                                                                                                                              " + CRLF
	cQryVer += "		END CLIENTE,                                                                                                                                                                                                  " + CRLF
	cQryVer += "		CT2_DATA,                                                                                                                                                                                                     " + CRLF
	cQryVer += " 		CT2_DEBITO, CT2_CREDIT, CT1_DESC01, CT2_CCD, CT2_CCC,CT2_CLVLDB, CT2_CLVLCR,                                                                                                                                  " + CRLF
	cQryVer += "		CT2_ITEMD, CT2_ITEMC, CT2_HIST, CT2_VALOR AS DEBITO, 0 As CREDITO,CT2_LOTE,                                                                                                                                   " + CRLF
	cQryVer += "		CASE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008811' THEN 'FISCAL'                                                                                                                                                                    " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST LIKE '%DCF%' THEN 'FINANCEIRO DCF'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST NOT LIKE '%DCF%' THEN 'FINANCEIRO'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '000006'  THEN 'AJUSTE DE PROVISAO E LANCAMENTO'                                                                                                                                          " + CRLF
	cQryVer += "		END DESCRICAO                                                                                                                                                                                                 " + CRLF
	cQryVer += "		, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_LP,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI                                                                                                                                      " + CRLF
	cQryVer += "	FROM CT2010 (NOLOCK) CT2                                                                                                                                                                                          " + CRLF
	cQryVer += " 		INNER JOIN CT1010 (NOLOCK) CT1                                                                                                                                                                                " + CRLF
	cQryVer += "			ON CT1_FILIAL = ''                                                                                                                                                                                        " + CRLF
	cQryVer += "			AND CT1_CONTA  = CT2_DEBITO                                                                                                                                                                               " + CRLF
	cQryVer += "			AND CT1_CONTA BETWEEN '32000001' AND '32000002'                                                                                                                                                           " + CRLF
	cQryVer += "			AND CT1.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += " 		LEFT JOIN CTT010 (NOLOCK) CTT                                                                                                                                                                                 " + CRLF
	cQryVer += "			ON	CTT_FILIAL = ''                                                                                                                                                                                       " + CRLF
	cQryVer += "			AND CTT_CUSTO = CT2_CCD                                                                                                                                                                                   " + CRLF
	cQryVer += "			AND CTT.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += "	WHERE	CT2_FILIAL BETWEEN '  ' AND 'ZZ'                                                                                                                                                                          " + CRLF
	cQryVer += "		AND CT2_DATA 	BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'                                                                                                                                  " + CRLF
	cQryVer += "		AND CT2.D_E_L_E_T_<>'*'                                                                                                                                                                                       " + CRLF
	cQryVer += "	 UNION ALL                                                                                                                                                                                                        " + CRLF
	cQryVer += "	 SELECT                                                                                                                                                                                                           " + CRLF
	cQryVer += "		'OMAMORI' EMPRESA,                                                                                                                                                                                            " + CRLF
	cQryVer += "		SUBSTRING(CT2_HIST,1,5) HIST,                                                                                                                                                                                 " + CRLF
	cQryVer += "		CASE WHEN SUBSTRING(CT2_HIST,1,5) = 'RECLA' THEN SUBSTRING(CT2_HIST, 48,6)                                                                                                                                    " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC.' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-6,6)                                                                                                                  " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC ' THEN SUBSTRING(CT2_HIST,19,6)                                                                                                                                      " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' OR SUBSTRING(CT2_HIST,1,5) = 'PROVI' THEN ''                                                                                                                       " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'SERV ' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-8,6)                                                                                                                  " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF -' THEN                                                                                                                                                               " + CRLF
	cQryVer += "				CASE                                                                                                                                                                                                  " + CRLF
	cQryVer += "					WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1010 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )             " + CRLF
	cQryVer += "					WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2010 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE2.D_E_L_E_T_ = '' ) " + CRLF
	cQryVer += "					ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1010 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                                             " + CRLF
	cQryVer += "				END                                                                                                                                                                                                   " + CRLF
	cQryVer += "			ELSE SUBSTRING(CT2_HIST,1,6)                                                                                                                                                                              " + CRLF
	cQryVer += "		END CLIENTE,                                                                                                                                                                                                  " + CRLF
	cQryVer += "		CT2_DATA,                                                                                                                                                                                                     " + CRLF
	cQryVer += " 		CT2_DEBITO, CT2_CREDIT		, CT1_DESC01					, CT2_CCD		, CT2_CCC,                                                                                                                        " + CRLF
	cQryVer += " 		CT2_CLVLDB, CT2_CLVLCR	, CT2_ITEMD	, CT2_ITEMC, CT2_HIST,                                                                                                                                                    " + CRLF
	cQryVer += "		0 AS DEBITO, CT2_VALOR AS CREDITO, CT2_LOTE,                                                                                                                                                                  " + CRLF
	cQryVer += "		CASE WHEN CT2_LOTE = '008811' THEN 'FISCAL'                                                                                                                                                                   " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST LIKE '%DCF%' THEN 'FINANCEIRO DCF'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST NOT LIKE '%DCF%' THEN 'FINANCEIRO'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '000006'  THEN 'AJUSTE DE PROVISAO E LANCAMENTO'                                                                                                                                          " + CRLF
	cQryVer += "		END DESCRICAO,                                                                                                                                                                                                " + CRLF
	cQryVer += "		CT2_SBLOTE, CT2_DOC,CT2_LINHA,CT2_LP,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI                                                                                                                                         " + CRLF
	cQryVer += "	FROM CT2010 (NOLOCK) CT2                                                                                                                                                                                          " + CRLF
	cQryVer += " 		INNER JOIN CT1010 (NOLOCK) CT1 ON CT1_FILIAL = '' AND CT1_CONTA = CT2_CREDIT AND CT1_CONTA BETWEEN '32000001' And '32000002' AND CT1.D_E_L_E_T_= ''                                                           " + CRLF
	cQryVer += " 		LEFT JOIN CTT010 (NOLOCK) CTT ON CTT_FILIAL = '' AND CTT_CUSTO = CT2_CCC AND CTT.D_E_L_E_T_=''                                                                                                                " + CRLF
	cQryVer += "	WHERE CT2_FILIAL BETWEEN '  ' AND 'ZZ'   		                                                                                                                                                                  " + CRLF
	cQryVer += "		 AND CT2_DATA 	BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'                                                                                                                                  " + CRLF
	cQryVer += "		 AND CT2.D_E_L_E_T_<>'*'                                                                                                                                                                                      " + CRLF
	cQryVer += "	UNION ALL                                                                                                                                                                                                         " + CRLF
	cQryVer += "	SELECT                                                                                                                                                                                                            " + CRLF
	cQryVer += "		'TALIS' EMPRESA,                                                                                                                                                                                              " + CRLF
	cQryVer += "		SUBSTRING(CT2_HIST,1,5) HIST,                                                                                                                                                                                 " + CRLF
	cQryVer += "		CASE WHEN SUBSTRING(CT2_HIST,1,5) = 'RECLA' THEN SUBSTRING(CT2_HIST, 47,6)                                                                                                                                    " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC.' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-5,6)                                                                                                                  " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC ' THEN SUBSTRING(CT2_HIST,19,6)                                                                                                                                      " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' OR SUBSTRING(CT2_HIST,1,5) = 'PROVI'  THEN ''                                                                                                                      " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'SERV ' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-8,6)                                                                                                                  " + CRLF
	cQryVer += "			WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF -' THEN                                                                                                                                                               " + CRLF
	cQryVer += "				CASE                                                                                                                                                                                                  " + CRLF
	cQryVer += "					WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1060 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )             " + CRLF
	cQryVer += "					WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2060 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE2.D_E_L_E_T_ = '' ) " + CRLF
	cQryVer += "					ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1060 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                                             " + CRLF
	cQryVer += "				END                                                                                                                                                                                                   " + CRLF
	cQryVer += "			ELSE SUBSTRING(CT2_HIST,1,6)                                                                                                                                                                              " + CRLF
	cQryVer += "		END CLIENTE,                                                                                                                                                                                                  " + CRLF
	cQryVer += "		CT2_DATA,                                                                                                                                                                                                     " + CRLF
	cQryVer += " 		CT2_DEBITO, CT2_CREDIT, CT1_DESC01, CT2_CCD, CT2_CCC,CT2_CLVLDB, CT2_CLVLCR,                                                                                                                                  " + CRLF
	cQryVer += "		CT2_ITEMD, CT2_ITEMC, CT2_HIST, CT2_VALOR AS DEBITO, 0 As CREDITO,CT2_LOTE,                                                                                                                                   " + CRLF
	cQryVer += "		CASE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008811' THEN 'FISCAL'                                                                                                                                                                    " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST LIKE '%DCF%' THEN 'FINANCEIRO DCF'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST NOT LIKE '%DCF%' THEN 'FINANCEIRO'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '000006'  THEN 'AJUSTE DE PROVISAO E LANCAMENTO'                                                                                                                                          " + CRLF
	cQryVer += "		END DESCRICAO                                                                                                                                                                                                 " + CRLF
	cQryVer += "		, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_LP,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI                                                                                                                                      " + CRLF
	cQryVer += "	FROM CT2060 (NOLOCK) CT2                                                                                                                                                                                          " + CRLF
	cQryVer += " 		INNER JOIN CT1060 (NOLOCK) CT1                                                                                                                                                                                " + CRLF
	cQryVer += "			ON CT1_FILIAL = ''                                                                                                                                                                                        " + CRLF
	cQryVer += "			AND CT1_CONTA  = CT2_DEBITO                                                                                                                                                                               " + CRLF
	cQryVer += "			AND CT1_CONTA BETWEEN '32000001' AND '32000002'                                                                                                                                                           " + CRLF
	cQryVer += "			AND CT1.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += " 		LEFT JOIN CTT060 (NOLOCK) CTT                                                                                                                                                                                 " + CRLF
	cQryVer += "			ON CTT_FILIAL = ''                                                                                                                                                                                        " + CRLF
	cQryVer += "			AND CTT_CUSTO = CT2_CCD                                                                                                                                                                                   " + CRLF
	cQryVer += "			AND CTT.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += "	WHERE	CT2_FILIAL BETWEEN '  ' AND 'ZZ'                                                                                                                                                                          " + CRLF
	cQryVer += "		AND CT2_DATA 	BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'                                                                                                                                  " + CRLF
	cQryVer += "		AND CT2.D_E_L_E_T_<>'*'                                                                                                                                                                                       " + CRLF
	cQryVer += "	 UNION ALL                                                                                                                                                                                                        " + CRLF
	cQryVer += "	 SELECT                                                                                                                                                                                                           " + CRLF
	cQryVer += "		'TALIS' EMPRESA,                                                                                                                                                                                              " + CRLF
	cQryVer += "		SUBSTRING(CT2_HIST,1,5) HIST,                                                                                                                                                                                 " + CRLF
	cQryVer += "		CASE WHEN SUBSTRING(CT2_HIST,1,5) = 'RECLA' THEN SUBSTRING(CT2_HIST, 47,6)                                                                                                                                    " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC.' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-6,6)                                                                                                                      " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC ' THEN SUBSTRING(CT2_HIST,19,6)                                                                                                                                          " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' OR SUBSTRING(CT2_HIST,1,5) = 'PROVI' THEN ''                                                                                                                           " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF -' THEN                                                                                                                                                                   " + CRLF
	cQryVer += "			CASE                                                                                                                                                                                                      " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1060 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                 " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2060 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE2.D_E_L_E_T_ = '' )     " + CRLF
	cQryVer += "				ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1060 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                                                 " + CRLF
	cQryVer += "			END                                                                                                                                                                                                       " + CRLF
	cQryVer += "			ELSE SUBSTRING(CT2_HIST,1,6)                                                                                                                                                                              " + CRLF
	cQryVer += "		END CLIENTE,                                                                                                                                                                                                  " + CRLF
	cQryVer += "		CT2_DATA,                                                                                                                                                                                                     " + CRLF
	cQryVer += " 		CT2_DEBITO, CT2_CREDIT		, CT1_DESC01					, CT2_CCD		, CT2_CCC,                                                                                                                        " + CRLF
	cQryVer += " 		CT2_CLVLDB, CT2_CLVLCR	, CT2_ITEMD	, CT2_ITEMC, CT2_HIST,                                                                                                                                                    " + CRLF
	cQryVer += "		0 AS DEBITO, CT2_VALOR AS CREDITO, CT2_LOTE,                                                                                                                                                                  " + CRLF
	cQryVer += "		CASE WHEN CT2_LOTE = '008811' THEN 'FISCAL'                                                                                                                                                                   " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST LIKE '%DCF%' THEN 'FINANCEIRO DCF'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST NOT LIKE '%DCF%' THEN 'FINANCEIRO'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '000006'  THEN 'AJUSTE DE PROVISAO E LANCAMENTO'                                                                                                                                          " + CRLF
	cQryVer += "		END DESCRICAO,                                                                                                                                                                                                " + CRLF
	cQryVer += "		CT2_SBLOTE, CT2_DOC,CT2_LINHA,CT2_LP,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI                                                                                                                                         " + CRLF
	cQryVer += "	FROM CT2060 (NOLOCK) CT2                                                                                                                                                                                          " + CRLF
	cQryVer += " 		INNER JOIN CT1060 (NOLOCK) CT1                                                                                                                                                                                " + CRLF
	cQryVer += "			ON CT1_FILIAL = ''                                                                                                                                                                                        " + CRLF
	cQryVer += "			AND CT1_CONTA = CT2_CREDIT                                                                                                                                                                                " + CRLF
	cQryVer += "			AND CT1_CONTA BETWEEN '32000001' And '32000002'                                                                                                                                                           " + CRLF
	cQryVer += "			AND CT1.D_E_L_E_T_= ''                                                                                                                                                                                    " + CRLF
	cQryVer += " 		LEFT JOIN CTT060 (NOLOCK) CTT                                                                                                                                                                                 " + CRLF
	cQryVer += "			ON	CTT_FILIAL = ''                                                                                                                                                                                       " + CRLF
	cQryVer += "			AND CTT_CUSTO = CT2_CCC                                                                                                                                                                                   " + CRLF
	cQryVer += "			AND CTT.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += "	WHERE CT2_FILIAL BETWEEN '  ' AND 'ZZ'   		                                                                                                                                                                  " + CRLF
	cQryVer += "		 AND CT2_DATA 	BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'                                                                                                                                  " + CRLF
	cQryVer += "		 AND CT2.D_E_L_E_T_<>'*'                                                                                                                                                                                      " + CRLF
	cQryVer += "	UNION ALL                                                                                                                                                                                                         " + CRLF
	cQryVer += "	SELECT                                                                                                                                                                                                            " + CRLF
	cQryVer += "		'CLEAN FIELD' EMPRESA,                                                                                                                                                                                        " + CRLF
	cQryVer += "		SUBSTRING(CT2_HIST,1,5) HIST,                                                                                                                                                                                 " + CRLF
	cQryVer += "		CASE WHEN SUBSTRING(CT2_HIST,1,5) = 'RECLA' THEN SUBSTRING(CT2_HIST, 48,6)                                                                                                                                    " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC.' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-5,6)                                                                                                                      " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC ' THEN SUBSTRING(CT2_HIST,19,6)                                                                                                                                          " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' AND CT2_HIST LIKE '%DCF%' THEN SUBSTRING(CT2_HIST,57,6)                                                                                                                " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' OR SUBSTRING(CT2_HIST,1,5) = 'PROVI'  THEN ''                                                                                                                          " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF -' THEN                                                                                                                                                                   " + CRLF
	cQryVer += "			CASE                                                                                                                                                                                                      " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1070 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                 " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2070 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE2.D_E_L_E_T_ = '' )     " + CRLF
	cQryVer += "				ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1070 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                                                 " + CRLF
	cQryVer += "			END                                                                                                                                                                                                       " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF V' THEN                                                                                                                                                                   " + CRLF
	cQryVer += "			CASE                                                                                                                                                                                                      " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1070 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 26,9) AND SE1.D_E_L_E_T_ = '' )                 " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2070 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 26,9) AND SE2.D_E_L_E_T_ = '' )     " + CRLF
	cQryVer += "				ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1070 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 26,9) AND SE1.D_E_L_E_T_ = '' )                                                 " + CRLF
	cQryVer += "			END                                                                                                                                                                                                       " + CRLF
	cQryVer += "		ELSE SUBSTRING(CT2_HIST,1,6)                                                                                                                                                                                  " + CRLF
	cQryVer += "		END CLIENTE,                                                                                                                                                                                                  " + CRLF
	cQryVer += "		CT2_DATA,                                                                                                                                                                                                     " + CRLF
	cQryVer += " 		CT2_DEBITO, CT2_CREDIT, CT1_DESC01, CT2_CCD, CT2_CCC,CT2_CLVLDB, CT2_CLVLCR,                                                                                                                                  " + CRLF
	cQryVer += "		CT2_ITEMD, CT2_ITEMC, CT2_HIST, CT2_VALOR AS DEBITO, 0 As CREDITO,CT2_LOTE,                                                                                                                                   " + CRLF
	cQryVer += "		CASE                                                                                                                                                                                                          " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008811' THEN 'FISCAL'                                                                                                                                                                    " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST LIKE '%DCF%' THEN 'FINANCEIRO DCF'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST NOT LIKE '%DCF%' THEN 'FINANCEIRO'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '000006'  THEN 'AJUSTE DE PROVISAO E LANCAMENTO'                                                                                                                                          " + CRLF
	cQryVer += "		END DESCRICAO                                                                                                                                                                                                 " + CRLF
	cQryVer += "		, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_LP,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI                                                                                                                                      " + CRLF
	cQryVer += "	FROM CT2070 (NOLOCK) CT2                                                                                                                                                                                          " + CRLF
	cQryVer += " 		INNER JOIN CT1070 (NOLOCK) CT1                                                                                                                                                                                " + CRLF
	cQryVer += "			ON	CT1_FILIAL = ''                                                                                                                                                                                       " + CRLF
	cQryVer += "			AND CT1_CONTA  = CT2_DEBITO                                                                                                                                                                               " + CRLF
	cQryVer += "			AND CT1_CONTA BETWEEN '32000001' AND '32000002'                                                                                                                                                           " + CRLF
	cQryVer += "			AND CT1.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += " 		LEFT JOIN CTT070 (NOLOCK) CTT                                                                                                                                                                                 " + CRLF
	cQryVer += "			ON	CTT_FILIAL = ''                                                                                                                                                                                       " + CRLF
	cQryVer += "			AND CTT_CUSTO = CT2_CCD                                                                                                                                                                                   " + CRLF
	cQryVer += "			AND CTT.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += "	WHERE	CT2_FILIAL BETWEEN '  ' AND 'ZZ'                                                                                                                                                                          " + CRLF
	cQryVer += "		AND CT2_DATA 	BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'                                                                                                                                  " + CRLF
	cQryVer += "		AND CT2.D_E_L_E_T_<>'*'                                                                                                                                                                                       " + CRLF
	cQryVer += "	 UNION ALL                                                                                                                                                                                                        " + CRLF
	cQryVer += "	 SELECT                                                                                                                                                                                                           " + CRLF
	cQryVer += "		'CLEAN FIELD' EMPRESA,                                                                                                                                                                                        " + CRLF
	cQryVer += "		SUBSTRING(CT2_HIST,1,5) HIST,                                                                                                                                                                                 " + CRLF
	cQryVer += "		CASE WHEN SUBSTRING(CT2_HIST,1,5) = 'RECLA' THEN SUBSTRING(CT2_HIST, 48,6)                                                                                                                                    " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC.' THEN SUBSTRING(CT2_HIST,LEN(RTRIM(CT2_HIST))-6,6)                                                                                                                      " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DESC ' THEN SUBSTRING(CT2_HIST,19,6)                                                                                                                                          " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' AND CT2_HIST LIKE '%DCF%' THEN SUBSTRING(CT2_HIST,57,6)                                                                                                                " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'ESTOR' OR SUBSTRING(CT2_HIST,1,5) = 'PROVI' THEN ''                                                                                                                           " + CRLF
	cQryVer += "		WHEN SUBSTRING(CT2_HIST,1,5) = 'DCF -' THEN                                                                                                                                                                   " + CRLF
	cQryVer += "			CASE                                                                                                                                                                                                      " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21500004') THEN (SELECT  TOP 1 E1_CLIENTE FROM SE1070 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                 " + CRLF
	cQryVer += "				WHEN CT2_CREDIT IN ('21100001') THEN (SELECT  TOP 1 E2_FORNECE E1_CLIENTE FROM SE2070 (NOLOCK) SE2 WHERE  E2_FILIAL = CT2_FILORI AND E2_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE2.D_E_L_E_T_ = '' )     " + CRLF
	cQryVer += "				ELSE (SELECT  TOP 1 E1_CLIENTE FROM SE1070 (NOLOCK) SE1 WHERE E1_FILIAL = CT2_FILORI AND E1_NUM = SUBSTRING(CT2_HIST, 15,9) AND SE1.D_E_L_E_T_ = '' )                                                 " + CRLF
	cQryVer += "			END                                                                                                                                                                                                       " + CRLF
	cQryVer += "			ELSE SUBSTRING(CT2_HIST,1,6)                                                                                                                                                                              " + CRLF
	cQryVer += "		END CLIENTE,                                                                                                                                                                                                  " + CRLF
	cQryVer += "		CT2_DATA,                                                                                                                                                                                                     " + CRLF
	cQryVer += " 		CT2_DEBITO, CT2_CREDIT		, CT1_DESC01					, CT2_CCD		, CT2_CCC,                                                                                                                        " + CRLF
	cQryVer += " 		CT2_CLVLDB, CT2_CLVLCR	, CT2_ITEMD	, CT2_ITEMC, CT2_HIST,                                                                                                                                                    " + CRLF
	cQryVer += "		0 AS DEBITO, CT2_VALOR AS CREDITO, CT2_LOTE,                                                                                                                                                                  " + CRLF
	cQryVer += "		CASE WHEN CT2_LOTE = '008811' THEN 'FISCAL'                                                                                                                                                                   " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST LIKE '%DCF%' THEN 'FINANCEIRO DCF'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '008850' AND CT2_HIST NOT LIKE '%DCF%' THEN 'FINANCEIRO'                                                                                                                                  " + CRLF
	cQryVer += "			WHEN CT2_LOTE = '000006'  THEN 'AJUSTE DE PROVISAO E LANCAMENTO'                                                                                                                                          " + CRLF
	cQryVer += "		END DESCRICAO,                                                                                                                                                                                                " + CRLF
	cQryVer += "		CT2_SBLOTE, CT2_DOC,CT2_LINHA,CT2_LP,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI                                                                                                                                         " + CRLF
	cQryVer += "	FROM CT2070 (NOLOCK) CT2                                                                                                                                                                                          " + CRLF
	cQryVer += " 		INNER JOIN CT1070 (NOLOCK) CT1                                                                                                                                                                                " + CRLF
	cQryVer += "			ON	CT1_FILIAL = ''                                                                                                                                                                                       " + CRLF
	cQryVer += "			AND CT1_CONTA = CT2_CREDIT                                                                                                                                                                                " + CRLF
	cQryVer += "			AND CT1_CONTA BETWEEN '32000001' And '32000002'                                                                                                                                                           " + CRLF
	cQryVer += "			AND CT1.D_E_L_E_T_= ''                                                                                                                                                                                    " + CRLF
	cQryVer += " 		LEFT JOIN CTT070 (NOLOCK) CTT                                                                                                                                                                                 " + CRLF
	cQryVer += "			ON	CTT_FILIAL = ''                                                                                                                                                                                       " + CRLF
	cQryVer += "			AND CTT_CUSTO = CT2_CCC                                                                                                                                                                                   " + CRLF
	cQryVer += "			AND CTT.D_E_L_E_T_=''                                                                                                                                                                                     " + CRLF
	cQryVer += "	WHERE CT2_FILIAL BETWEEN '  ' AND 'ZZ'   		                                                                                                                                                                  " + CRLF
	cQryVer += "		 AND CT2_DATA 	BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'                                                                                                                                  " + CRLF
	cQryVer += "		 AND CT2.D_E_L_E_T_<>'*'                                                                                                                                                                                      " + CRLF
	cQryVer += ") AS TMP                                                                                                                                                                                                              " + CRLF
	cQryVer += "WHERE	CT2_LOTE IN ('008850', '008811','000006')                                                                                                                                                                     " + CRLF
	cQryVer += "	AND DESCRICAO <> 'FINANCEIRO'                                                                                                                                                                                     " + CRLF
	cQryVer += "	AND CT2_HIST NOT LIKE '%RECLASSIFICACAO ENTRE CONTAS%'                                                                                                                                                            " + CRLF
	cQryVer += "	AND CT2_HIST NOT LIKE '%RECLASSIFICAÇÃO ENTRE CONTAS%'                                                                                                                                                            " + CRLF
	cQryVer += "	AND CT2_HIST NOT LIKE '%REVERSAO%'                                                                                                                                                                                " + CRLF
	cQryVer += "ORDER BY TMP.EMPRESA, CT2_EMPORI, CT2_FILORI, CT2_DATA, DESCRICAO                                                                                                                                                     " + CRLF
	
	cQryVer := ChangeQuery(cQryVer)
Return cQryVer