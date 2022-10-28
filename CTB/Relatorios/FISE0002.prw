#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISE0002
Impressão do Relatório.EXPDADOS*
@author FABIANO.AVILA
@since 05/11/2018
@param cQuery, characters, Query.
@type function
/*/
user function FISE0002()
	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	Local lRet 		:= .T.
	Local aParamBox	:= {}
	Private cTitulo 	:= "Relatório Impostos Saídas"
	
	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.}) 		   
	
	lRet := ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
	
	If lRet

	Processa({||FISE0002A1()})
	EndIf
	
	U_MCERLOG()
return

/*/{Protheus.doc} FISE0002A1
Impressão do Relatório.EXPDADOS*
@author FABIANO.AVILA
@since 05/11/2018
@param cQuery, characters, Query.
@type function
/*/
Static Function FISE0002A1(dDataDe, dDataAte)
	local cQuery := ""
	
	cQuery += "	SELECT " + CRLF
	cQuery += "		D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA CHAVE, FT_CHVNFE, FT_FILIAL, RTRIM(FT_NFISCAL) NUM_DOC, FT_SERIE, FT_ESPECIE, FT_CLIEFOR, FT_LOJA," + CRLF 
	cQuery += "		CASE WHEN D2_TIPO IN ('B','D') THEN (SELECT LTRIM(RTRIM(A2_NOME)) FROM " + retSqlName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ = '' AND A2_FILIAL ='" + xFilial("SA2") + "' AND A2_COD = D2_CLIENTE AND A2_LOJA = D2_LOJA)" + CRLF
	cQuery += "		ELSE (SELECT LTRIM(RTRIM(A1_NOME)) FROM " + retSqlName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ = '' AND A1_FILIAL = '" + xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA ) END RAZAO, FT_ESTADO," + CRLF 
	cQuery += "		CONVERT(smalldatetime, FT_EMISSAO,103) DT_EMISSAO, CONVERT(smalldatetime, FT_ENTRADA,103) DT_ENTRADA, D2_COD, B1_DESC, D2_ITEM, D2_QUANT," + CRLF
	cQuery += "		D2_UM, B1_TIPO, B1_POSIPI NCM_PROD, FT_POSIPI, D2_TES, F4_FINALID, D2_EST, D2_CF, F4_CF CFOP_TES, F4_CSTPIS CST_PIS_TES, FT_CSTPIS," + CRLF
	cQuery += "		FT_ALIQPIS, FT_BASEPIS, FT_VALPIS, F4_CSTCOF CST_COF_TES, FT_CSTCOF, FT_ALIQCOF, FT_BASECOF, FT_VALCOF," + CRLF
	cQuery += "		CASE " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC <> ' ' AND F4_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'NÃO PREENCHER NA TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC = ' ' AND F4_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC IN ('4310', '4317') AND F4_CSTCOF IN ('02', '03', '04')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC = '4312' AND F4_CSTCOF IN ('05')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC = '4313' AND F4_CSTCOF IN ('06')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC = '4314' AND F4_CSTCOF IN ('07')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC = '4315' AND F4_CSTCOF IN ('08')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			WHEN (F4_TIPO = 'S' AND F4_TNATREC = '4316' AND F4_CSTCOF IN ('09')) THEN 'OK TABELA '+F4_TNATREC+' TES: '+F4_CODIGO " + CRLF
	cQuery += "			ELSE 'VERIFICAR TABELA RECEITAS '+F4_TNATREC+' DA TES: '+F4_CODIGO" + CRLF
	cQuery += "		END AS TAB_NAT_RECEITAS_TES," + CRLF
	cQuery += "		CASE" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC <> ' ' AND FT_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'NÃO PREENCHER'" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC = ' ' AND FT_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'OK TABELA'+FT_TNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC IN ('4310', '4317') AND FT_CSTCOF IN ('02', '03', '04')) THEN 'OK TABELA'" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC = '4312' AND FT_CSTCOF IN ('05')) THEN 'OK TABELA'+FT_TNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC = '4313' AND FT_CSTCOF IN ('06')) THEN 'OK TABELA'+FT_TNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC = '4314' AND FT_CSTCOF IN ('07')) THEN 'OK TABELA'+FT_TNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC = '4315' AND FT_CSTCOF IN ('08')) THEN 'OK TABELA'+FT_TNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_TNATREC = '4316' AND FT_CSTCOF IN ('09')) THEN 'OK TABELA'+FT_TNATREC" + CRLF
	cQuery += "		ELSE 'VERIFICAR TABELA RECEITAS '+FT_TNATREC " + CRLF
	cQuery += "		END AS TAB_NAT_RECEITAS_LIVRO," + CRLF
	cQuery += "		CASE" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'NÃO PREENCHER NA TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC  = ' ' AND F4_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_TNATREC IN ('4310', '4317') AND F4_CSTCOF IN ('02', '03', '04')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_TNATREC = '4312' AND F4_CSTCOF IN ('05')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_TNATREC = '4313' AND F4_CSTCOF IN ('06')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_TNATREC = '4314' AND F4_CSTCOF IN ('07')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_TNATREC = '4315' AND F4_CSTCOF IN ('08')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		WHEN (F4_TIPO = 'S' AND F4_CNATREC <> ' ' AND F4_TNATREC = '4316' AND F4_CSTCOF IN ('09')) THEN 'OK NATUREZA '+F4_CNATREC+' TES: '+F4_CODIGO" + CRLF
	cQuery += "		ELSE 'VERIFICAR NATUREZA RECEITAS '+F4_CNATREC+' DA TES: '+F4_CODIGO" + CRLF
	cQuery += "		END AS COD_NAT_RECEITAS_TES," + CRLF
	cQuery += "		CASE" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'NÃO PREENCHER' "+ CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC  = ' ' AND FT_CSTCOF NOT IN ('02', '03', '04', '05', '06', '07', '08', '09')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_TNATREC IN ('4310', '4317') AND FT_CSTCOF IN ('02', '03', '04')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_TNATREC = '4312' AND FT_CSTCOF IN ('05')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_TNATREC = '4313' AND FT_CSTCOF IN ('06')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_TNATREC = '4314' AND FT_CSTCOF IN ('07')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_TNATREC = '4315' AND FT_CSTCOF IN ('08')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		WHEN (FT_TIPOMOV = 'S' AND FT_CNATREC <> ' ' AND FT_TNATREC = '4316' AND FT_CSTCOF IN ('09')) THEN 'OK NATUREZA '+FT_CNATREC" + CRLF
	cQuery += "		ELSE 'VERIFICAR NATUREZA RECEITAS '+FT_CNATREC" + CRLF
	cQuery += "		END AS COD_NAT_RECEITAS_LIVRO," + CRLF
	cQuery += "		FT_TNATREC XTAB_NAT_RECEITAS, FT_CNATREC XCOD_NAT_RECEITAS, FT_VALCONT, FT_ICMSRET, FT_CLASFIS CST_ICMS, FT_BASEICM," + CRLF
	cQuery += "		FT_ALIQICM, FT_VALICM, FT_BASEIPI, FT_ALIQIPI, FT_VALIPI, FT_CTIPI, D2_NFORI, D2_SERIORI, D2_ITEMORI, D2_QTDEDEV, D2_VALDEV	" + CRLF
	cQuery += "		FROM " + retSqlName("SD2") + " SD2 									" + CRLF
	cQuery += "			JOIN " + retSqlName("SFT") + " SFT 								" + CRLF
	cQuery += "				ON	SFT.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				AND FT_FILIAL	=	'" + xFilial("SFT")+"'					" + CRLF
	cQuery += "				AND FT_NFISCAL	=	D2_DOC									" + CRLF
	cQuery += "				AND FT_SERIE	=	D2_SERIE								" + CRLF
	cQuery += "				AND FT_CLIEFOR	=	D2_CLIENTE								" + CRLF
	cQuery += "				AND FT_LOJA		=	D2_LOJA									" + CRLF
	cQuery += "				AND FT_PRODUTO	=	D2_COD									" + CRLF
	cQuery += "				AND FT_ITEM		=	D2_ITEM									" + CRLF
	cQuery += "				AND FT_ENTRADA	=	D2_EMISSAO								" + CRLF
	cQuery += "				AND FT_TIPOMOV	=	'S'										" + CRLF
	cQuery += "				AND FT_DTCANC	=	''										" + CRLF
	cQuery += "			JOIN " + retSqlName("SF4") + " SF4 								" + CRLF
	cQuery += "				ON	SF4.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				and F4_FILIAL	=	'" + xFilial("SF4")+"'					" + CRLF
	cQuery += "				AND F4_CODIGO	=	D2_TES									" + CRLF
	cQuery += "			JOIN " + retSqlName("SB1") + " SB1 								" + CRLF
	cQuery += "				ON	SB1.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				AND B1_FILIAL	=	'" + xFilial("SB1")+"'					" + CRLF
	cQuery += "				AND B1_COD		=	D2_COD									" + CRLF
	cQuery += "	WHERE SD2.D_E_L_E_T_ = ''												" + CRLF
	cQuery += " AND D2_FILIAL = '" + xFilial("SD2")+"'									" + CRLF
	cQuery += " AND D2_EMISSAO BETWEEN '"+dToS(MV_PAR01)+"' AND '"+dToS(MV_PAR02)+"'	" + CRLF
	cQuery += "	ORDER BY 3, 10, 5, 4, 7, 14												" + CRLF
	ConOut(cQuery)
	Processa({ || FISE0002A2(cQuery)})
	
return 

/*/{Protheus.doc} FISE0002A2
Impressão do Relatório.EXPDADOS*
@author FABIANO.AVILA
@since 05/11/2018
@param cQuery, characters, Query.
@type function
/*/
Static Function FISE0002A2(cQuery)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Saidas_" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := cQuery
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()
	
	oObjExcel:CloseClasExcel()
Return
