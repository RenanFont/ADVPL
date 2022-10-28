#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISE0001
Impress�o do Relat�rio.EXPDADOS*
@author FABIANO.AVILA
@since 05/11/2018
@param cQuery, characters, Query.
@type function
/*/
user function FISE0001()
	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	Local lRet 		:= .T.
	Local aParamBox	:= {}
	Private cTitulo 	:= "Relat�rio Impostos Entradas"
	
	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.}) 		   
	
	lRet := ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
	
	If lRet

	Processa({||FISE0001A1()})
	EndIf
	
	U_MCERLOG()
return

/*/{Protheus.doc} FISE0001A1
Impress�o do Relat�rio.EXPDADOS*
@author FABIANO.AVILA
@since 05/11/2018
@param cQuery, characters, Query.
@type function
/*/
Static Function FISE0001A1(dDataDe, dDataAte)
	local cQuery := ""
	
	cQuery += "	SELECT " + CRLF
	cQuery += "		D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA CHAVE, F1_CHVNFE, FT_FILIAL, FT_NFISCAL, FT_SERIE, FT_ESPECIE, FT_CLIEFOR, FT_LOJA, " + CRLF 
	cQuery += "		CASE WHEN D1_TIPO IN ('B','D') THEN (SELECT LTRIM(RTRIM(A1_NOME)) FROM " + retSqlName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ = '' AND A1_FILIAL = '" + xFilial("SA1")+ "' AND A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA) " + CRLF
	cQuery += "		ELSE (SELECT LTRIM(RTRIM(A2_NOME)) FROM " + retSqlName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ = '' AND A2_FILIAL ='" + xFilial("SA2") + "' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA ) END AS RAZAO,FT_ESTADO, " + CRLF 
	cQuery += "		CONVERT(smalldatetime, FT_EMISSAO,103)DT_EMISSAO, CONVERT(smalldatetime, FT_ENTRADA,103)DT_DIGITACAO, " + CRLF
	cQuery += "		D1_COD, LTRIM(RTRIM(B1_DESC)), D1_ITEM, D1_QUANT, B1_TIPO, B1_POSIPI, FT_POSIPI, D1_TES, " + CRLF
	cQuery += "		CASE " + CRLF
	cQuery += "		WHEN F4_TPREG = '1' THEN 'N�O CUMULATIVO TES: '+F4_CODIGO " + CRLF
	cQuery += "		WHEN F4_TPREG = '' THEN 'N�O CONFIGURADO TES: '+F4_CODIGO " + CRLF
	cQuery += "		ELSE 'CUMULATIVO TES: '+F4_CODIGO END AS REGIME, " + CRLF
	cQuery += "		LTRIM(RTRIM(F4_FINALID)), D1_CF, FT_INDNTFR IND_NATUR_FRETE, F4_INDNTFR, " + CRLF
	cQuery += "		CASE " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '0' THEN 'Opera��es de vendas, com �nus suportado pelo estabelecimento vendedor' " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '1' THEN 'Opera��es de vendas, com �nus suportado pelo adquirente' " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '2' THEN 'Opera��es de compras (bens para revenda, mat�rias-prima e outros produtos, geradores de cr�dito)' " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '3' THEN 'Opera��es de compras (bens para revenda, mat�rias-prima e outros produtos, n�o geradores de cr�dito)' " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '4' THEN 'Transfer�ncia de produtos acabados entre estabelecimentos da pessoa jur�dica' " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '5' THEN 'Transfer�ncia de produtos em elabora��o entre estabelecimentos da pessoa jur�dica' " + CRLF
	cQuery += "		WHEN FT_INDNTFR = '9' THEN 'Outras' " + CRLF
	cQuery += "		ELSE 'NAO PREENCHIDO' END AS NAT_FRETE, " + CRLF
	cQuery += "		FT_CODBCC, " + CRLF
	cQuery += "		CASE " + CRLF
	cQuery += "		WHEN FT_CODBCC = '01' THEN 'Aquisi��o de bens para revenda' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '02' THEN 'Aquisi��o de bens utilizados como insumo' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '03' THEN 'Aquisi��o de servi�os utilizados como insumo' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '04' THEN 'Energia el�trica e t�rmica, inclusive sob a forma de vapor' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '05' THEN 'Alugu�is de pr�dios' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '06' THEN 'Alugu�is de m�quinas e equipamentos' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '07' THEN 'Armazenagem de mercadoria e frete na opera��o de venda' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '08' THEN 'Contrapresta��es de arrendamento mercantil' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '09' THEN 'M�quinas, equipamentos e outros bens incorporados ao ativo imobilizado (cr�dito sobre encargos de deprecia��o).' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '10' THEN 'M�quinas, equipamentos e outros bens incorporados ao ativo imobilizado (cr�dito com base no valor de aquisi��o).' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '11' THEN 'Amortiza��o e Deprecia��o de edifica��es e benfeitorias em im�veis' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '12' THEN 'Devolu��o de Vendas Sujeitas � Incid�ncia N�o-Cumulativa' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '13' THEN 'Outras Opera��es com Direito a Cr�dito' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '14' THEN 'Atividade de Transporte de Cargas � Subcontrata��o' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '15' THEN 'Atividade Imobili�ria � Custo Incorrido de Unidade Imobili�ria' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '16' THEN 'Atividade Imobili�ria � Custo Or�ado de unidade n�o conclu�da' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '17' THEN 'Atividade de Presta��o Servi�os de Limpeza, Conserva��o/Manuten��o, vale-transporte, vale-refei��o ou vale-alimenta��o, uniforme.' " + CRLF
	cQuery += "		WHEN FT_CODBCC = '18' THEN 'Estoque de abertura de bens' " + CRLF
	cQuery += "		ELSE 'NAO PREENCHIDO' END AS DESC_COD_CREDITO, F4_CODBCC, " + CRLF
	cQuery += "		CASE " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('102','113','117','118','121','251','403','652') AND FT_CODBCC = '01') THEN 'COD. BASE CALC 01 CRED OK' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('101','111','116','120','122','126','128','401','407','556','651','653') AND FT_CODBCC = '02') THEN 'COD. BASE CALC 02 CRED OK' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('124', '125', '933') AND FT_CODBCC = '03') THEN 'COD. BASE CALC 03 CRED OK' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('201', '202', '203', '204', '410', '411', '660', '661', '662') AND FT_CODBCC = '12') THEN 'COD. BASE CALC 12 CRED OK' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('922') AND FT_CODBCC = '13') THEN 'COD. BASE CALC 13 CRED OK' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('102', '113', '117', '118', '121', '251', '403', '652') AND FT_CODBCC <> '01') THEN 'COD. BASE CALC ERRADO - 01' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('101', '111', '116', '120', '122', '126', '128', '401', '407', '556', '651', '653') AND FT_CODBCC <> '02') " + CRLF
	cQuery += "		THEN 'COD. BASE CALC ERRADO - 02' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('124', '125', '933') AND FT_CODBCC <> '03') THEN 'COD. BASE CALC ERRADO - 03' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('201', '202', '203', '204', '410', '411', '660', '661', '662') AND FT_CODBCC <> '12') THEN 'COD. BASE CALC ERRADO - 12' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('50') AND SUBSTRING(FT_CFOP,2,3) IN ('922') AND FT_CODBCC <> '13') THEN 'COD. BASE CALC ERRADO - 13' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF IN ('70', '71', '72', '73', '74', '75', '98') AND FT_CODBCC = '') THEN 'COD. BASE CALC S/DIR/CRED OK' " + CRLF
	cQuery += "		WHEN (FT_CSTCOF NOT IN ('70', '71', '72', '73', '74', '75', '98') AND FT_CODBCC <> '' AND SUBSTRING(FT_CFOP,2,3) NOT IN ('102', '113', '117', '118', '121', '251', '403', '652', " + CRLF
	cQuery += "		 '101', '111', '116', '120', '122', '126', '128', '401', '407', '556', '651', '653', '124', '125', '933', '201', '202', '203', '204', '410', '411', '660', '661', '662')) THEN " + CRLF
	cQuery += "		'CFOP SEM DIREITO A CR�DITO ERRO' ELSE 'N�O CONFIGURADO' END AS COD_BS_CALC_CRED, FT_CODBCC, " + CRLF
	cQuery += "		F4_CSTPIS CST_PIS_TES, FT_CSTPIS, FT_ALIQPIS, D1_CUSTO, FT_BASEPIS, FT_VALPIS, F4_CSTCOF CST_COF_TES, FT_CSTCOF, FT_ALIQCOF, FT_BASECOF, FT_VALCOF, D1_VALCMAJ, FT_MALQCOF, FT_MVALCOF, FT_VALCONT, D1_CONTA, " + CRLF
	cQuery += "		FT_ICMSRET, FT_CLASFIS, FT_BASEICM, FT_ALIQICM, FT_VALICM, FT_BASEIPI, FT_ALIQIPI, FT_VALIPI, FT_CTIPI, D1_NFORI, D1_SERIORI, D1_ITEMORI, D1_QTDEDEV, D1_VALDEV " + CRLF
	cQuery += "		FROM " + retSqlName("SD1") + " SD1 									" + CRLF
	cQuery += "			JOIN " + retSqlName("SF1") + " SF1 								" + CRLF
	cQuery += "				ON	SF1.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				AND F1_FILIAL	=	'" + xFilial("SF1")+"'					" + CRLF
	cQuery += "				AND F1_DOC		=	D1_DOC									" + CRLF
	cQuery += "				AND F1_SERIE	=	D1_SERIE								" + CRLF
	cQuery += "				AND F1_FORNECE	=	D1_FORNECE								" + CRLF
	cQuery += "				AND F1_LOJA		=	D1_LOJA									" + CRLF
	cQuery += "				AND F1_DTDIGIT	=	D1_DTDIGIT								" + CRLF
	cQuery += "			JOIN " + retSqlName("SFT") + " SFT 								" + CRLF
	cQuery += "				ON	SFT.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				AND FT_FILIAL	=	'" + xFilial("SFT")+"'					" + CRLF
	cQuery += "				AND FT_NFISCAL	=	D1_DOC									" + CRLF
	cQuery += "				AND FT_SERIE	=	D1_SERIE								" + CRLF
	cQuery += "				AND FT_CLIEFOR	=	D1_FORNECE								" + CRLF
	cQuery += "				AND FT_LOJA		=	D1_LOJA									" + CRLF
	cQuery += "				AND FT_PRODUTO	=	D1_COD									" + CRLF
	cQuery += "				AND FT_ITEM		=	D1_ITEM									" + CRLF
	cQuery += "				AND FT_ENTRADA	=	D1_DTDIGIT								" + CRLF
	cQuery += "				AND FT_TIPOMOV	=	'E'										" + CRLF
	cQuery += "			JOIN " + retSqlName("SF4") + " SF4 								" + CRLF
	cQuery += "				ON	SF4.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				AND F4_FILIAL	=	'" + xFilial("SF4")+"'					" + CRLF
	cQuery += "				AND F4_CODIGO	=	D1_TES									" + CRLF
	cQuery += "			JOIN " + retSqlName("SB1") + " SB1 								" + CRLF
	cQuery += "				ON	SB1.D_E_L_E_T_ = ''										" + CRLF
	cQuery += "				AND B1_FILIAL	=	'" + xFilial("SB1")+"'					" + CRLF
	cQuery += "				AND B1_COD		=	D1_COD									" + CRLF
	cQuery += "	WHERE SD1.D_E_L_E_T_ = ''												" + CRLF
	cQuery += " AND D1_FILIAL = '" + xFilial("SD1")+"'									" + CRLF
	cQuery += " AND D1_DTDIGIT BETWEEN '"+dToS(MV_PAR01)+"' AND '"+dToS(MV_PAR02)+"' 	" + CRLF
	cQuery += "	ORDER BY 3, 10, 5, 6, 4, 14												" + CRLF
	ConOut(cQuery)
	Processa({ || FISE0001A2(cQuery)})
	
return 

/*/{Protheus.doc} FISE0001A2
Impress�o do Relat�rio.EXPDADOS*
@author FABIANO.AVILA
@since 05/11/2018
@param cQuery, characters, Query.
@type function
/*/
Static Function FISE0001A2(cQuery)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Entradas_" + cTipoEmp	
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
