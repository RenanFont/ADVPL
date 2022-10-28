#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0008
Impressão do Relatório.EXPDADOS*
@author Vitor Costa
@since 06/09/19
@param cQuery, characters, Query.
@type function
/*/
user function FISR0008()
	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	Local lRet 		:= .T.
	Local aParamBox	:= {}
	Private cTitulo 	:= "Relatório Relação NF Entrada Cliente UNION"
	Private cAlias 		:= GetNextAlias()

	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.}) 		   

	lRet := ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)

	If lRet

		oReport := ReportDef(cAlias)
		oReport:printDialog()

	EndIf
	
	U_MCERLOG()
return

Static Function ReportDef(cAlias, cGrupo)

	Local cTitle  := "Relatório Relação NF Entrada Cliente UNION"
	Local cHelp   := "Relatório Relação NF Entrada Cliente UNION"
	Local oReport
	Local oSection1

	oReport := TReport():New('FISR0008R',cTitle,,{|oReport| RptPrtV3(oReport,cAlias)},cHelp)

	//Primeira seção
	oSection1 := TRSection():New(oReport,"COMISSAO",{cAlias}) 

	TRCell():New(oSection1,"EMPRESA"					,	cAlias, "EMPRESA", "", 10 ,,        					{ || (cAlias)->EMPRESA     } )
	TRCell():New(oSection1,"EMISSAO"					,	cAlias, "EMISSAO", "", 11,,								{ || (cAlias)->EMISSAO } )
	TRCell():New(oSection1,"CHAVE"						,	cAlias, "CHAVE", "", 45,,								{ || (cAlias)->CHAVE } )
	TRCell():New(oSection1,"DOCUMENTO"					,	cAlias, "DOCUMENTO", "", 9,,							{ || (cAlias)->DOCUMENTO } )
	TRCell():New(oSection1,"ENT_NF"						,	cAlias, "ENT_NF", "", 9,,								{ || (cAlias)->ENT_NF } )
	TRCell():New(oSection1,"CNPJ"						,	cAlias, "CNPJ", "", 14,,								{ || (cAlias)->CNPJ } )
	TRCell():New(oSection1,"CODIGO"						,	cAlias, "CODIGO", "", 6,,								{ || (cAlias)->A1_COD } )
	TRCell():New(oSection1,"FORNECE"					,	cAlias, "FORNECE", "", TamSX3("A1_NOME")[1],,			{ || (cAlias)->FORNECE } )
	TRCell():New(oSection1,"UF"							,	cAlias, "UF", "", 2,,									{ || (cAlias)->UF} )
	TRCell():New(oSection1,"CFOP_CLI"					,	cAlias, "CFOP_CLI", "", 4,,								{ || (cAlias)->CFOP_CLI } )
	TRCell():New(oSection1,"CF_ENTR"					,	cAlias, "CF_ENTR", "", 4,,								{ || (cAlias)->CF_ENTR } )
	TRCell():New(oSection1,"PRODUTO"					,	cAlias, "PRODUTO", "", 11,,								{ || (cAlias)->PRODUTO } )
	TRCell():New(oSection1,"DESCRICAO"					,	cAlias, "DESCRICAO", "", TamSX3("B1_DESC")[1] ,,        { || (cAlias)->DESCRICAO     } )
	TRCell():New(oSection1,"CSTICMS_CLI"				,	cAlias, "CSTICMS_CLI", "", 3 ,,        					{ || (cAlias)->CSTICMS_CLI     } )
	TRCell():New(oSection1,"CSTICMS"					,	cAlias, "CSTICMS", "", 3 ,,        						{ || (cAlias)->CSTICMS     } )
	TRCell():New(oSection1,"NCM_CLI"					,	cAlias, "NCM_CLI", "", 8 ,,        						{ || (cAlias)->NCM_CLI     } )
	TRCell():New(oSection1,"NCM"						,	cAlias, "NCM", "", 8 ,,        							{ || (cAlias)->NCM     } )
	TRCell():New(oSection1,"ALIQICMS_CLI"				,	cAlias, "ALIQICMS_CLI", "", 4 ,,        				{ || (cAlias)->ALIQICMS_CLI     } )
	TRCell():New(oSection1,"ALIQICMS"					,	cAlias, "ALIQICMS", "", 4 ,,        					{ || (cAlias)->ALIQICMS     } )
	TRCell():New(oSection1,"ALIQPIS_CLI"				,	cAlias, "ALIQPIS_CLI", "", 4 ,,        					{ || (cAlias)->ALIQPIS_CLI     } )
	TRCell():New(oSection1,"ALIQPIS"					,	cAlias, "ALIQPIS", "", 4 ,,        						{ || (cAlias)->ALIQPIS     } )
	TRCell():New(oSection1,"ALIQCOF_CLI"				,	cAlias, "ALIQCOF_CLI", "", 4 ,,        					{ || (cAlias)->ALIQCOF_CLI     } )
	TRCell():New(oSection1,"ALIQCOF"					,	cAlias, "ALIQCOF", "", 4 ,,        						{ || (cAlias)->ALIQCOF     } )
	TRCell():New(oSection1,"CSTIPI"						,	cAlias, "CSTIPI", "", 2 ,,        						{ || (cAlias)->CSTIPI     } )
	TRCell():New(oSection1,"CSTPIS"						,	cAlias, "CSTPIS", "", 2 ,,        						{ || (cAlias)->CSTPIS     } )
	TRCell():New(oSection1,"SCTCOF"						,	cAlias, "SCTCOF", "", 2 ,,        						{ || (cAlias)->SCTCOF     } )
	TRCell():New(oSection1,"REDU_ICMS"					,	cAlias, "REDU_ICMS", "", 5 ,,        					{ || (cAlias)->REDU_ICMS     } )
	TRCell():New(oSection1,"DISPOS_LEGAL"				,	cAlias, "DISPOS_LEGAL", "", 45 ,,        				{ || (cAlias)->DISPOS_LEGAL     } )
	TRCell():New(oSection1,"SITUACAO"					,	cAlias, "SITUACAO", "", 14 ,,        					{ || (cAlias)->SITUACAO     } )
	TRCell():New(oSection1,"MANIFESTO"					,	cAlias, "MANIFESTO", "", 26 ,,        					{ || (cAlias)->MANIFESTO     } )
	
Return(oReport)
/*
Funcao Reportprint
Monta a query e executa a impresso
*/

Static Function RptPrtV3( oReport, cAlias )

	Local oSecao1 	:= oReport:Section(1)
	Local lCabec	:= .T.
	Local cQuery 	:= ""

	cQuery += " SELECT DISTINCT                                                                                                                                                   " + CRLF
	cQuery += " 	'OMAMORI' EMPRESA,                                                                                                                                            " + CRLF
	cQuery += " 	CONVERT (DATE,XML_EMISSA,103) EMISSAO,CAB.XML_CHAVE CHAVE,SUBSTRING (XML_NUMNF,4,9) DOCUMENTO,                                                                " + CRLF
	cQuery += " 	F1.F1_DOC ENT_NF,                                                                                                                                             " + CRLF
	cQuery += " 	CAB.XML_EMIT CNPJ,A1_COD,UPPER(XML_NOMEMT) FORNECE, A1_EST UF,XIT_CFNFE CFOP_CLI,                                                                             " + CRLF
	cQuery += " 	D1.D1_CF CF_ENTR,D1.D1_COD PRODUTO,B1_DESC DESCRICAO, XIT_CLASFI CSTICMS_CLI, D1.D1_CLASFIS CSTICMS, XIT_NCM NCM_CLI, B1_POSIPI NCM,                          " + CRLF
	cQuery += " 	XIT_PICM ALIQICMS_CLI,D1.D1_ALIQSOL ALIQICMS, XIT_PPIS ALIQPIS_CLI,D1.D1_ALQIMP6 ALIQPIS ,XIT_PCOF ALIQCOF_CLI, D1.D1_ALQIMP5 ALIQCOF,                        " + CRLF
	cQuery += " 	F4_CTIPI CSTIPI, F4_CSTPIS CSTPIS, F4_CSTCOF SCTCOF, F4_BASEICM REDU_ICMS, F4_DISPLEG DISPOS_LEGAL,                                                           " + CRLF
	cQuery += " CASE                                                                                                                                                              " + CRLF
	cQuery += " 		WHEN CAB.XML_STATF1 = 'A' AND CAB.XML_LANCAD <> '' THEN 'CLASSIFICADA'                                                                                    " + CRLF
	cQuery += " 		WHEN XIT.XIT_LOTEC <> '' THEN 'NF CANCELADA'                                                                                                              " + CRLF
	cQuery += " 		WHEN F3_CODRSEF = '102' THEN 'NF INUTILIZADA'                                                                                                             " + CRLF
	cQuery += " 		WHEN F3_CODRSEF = '101' THEN 'NF CANCELADA'                                                                                                               " + CRLF
	cQuery += " 		WHEN CAB.XML_LANCAD = '' THEN 'PENDENTE'                                                                                                                  " + CRLF
	cQuery += " END SITUACAO,                                                                                                                                                      " + CRLF
	cQuery += " 	CASE                                                                                                                                                          " + CRLF
	cQuery += " 		WHEN C00_STATUS = '0' THEN 'SEM MANIFESTO'                                                                                                                " + CRLF
	cQuery += " 		WHEN C00_STATUS = '1' THEN 'MANIFESTO CONFIRMADO'                                                                                                         " + CRLF
	cQuery += " 		WHEN C00_STATUS = '2' THEN 'MANIFESTACAO DESCONHECIDA'                                                                                                    " + CRLF
	cQuery += " 		WHEN C00_STATUS = '3' THEN 'MANIFESTACAO NAO REALIZADA'                                                                                                   " + CRLF
	cQuery += " 		WHEN C00_STATUS = '4' THEN 'CIENCIA DA MANIFESTACAO'                                                                                                      " + CRLF
	cQuery += " 	END MANIFESTO                                                                                                                                                 " + CRLF
	cQuery += " FROM RECNFXML CAB (NOLOCK)                                                                                                                                        " + CRLF
	cQuery += " 	LEFT JOIN RECNFXMLITENS XIT (NOLOCK) ON XIT_CHAVE = XML_CHAVE AND XIT.D_E_L_E_T_ = ''                                                                         " + CRLF
	cQuery += " 	FULL JOIN SF1010 F1 (NOLOCK) ON F1_CHVNFE = XML_CHAVE  AND F1.D_E_L_E_T_ = ''                                                                                 " + CRLF
	cQuery += " 	LEFT JOIN SD1010 D1 (NOLOCK) ON D1.D1_FILIAL = F1.F1_FILIAL AND D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE         " + CRLF
	cQuery += " 	LEFT JOIN SB1010 B1 (NOLOCK) ON B1_COD = D1_COD AND B1.D_E_L_E_T_ = ''                                                                                        " + CRLF
	cQuery += " 	LEFT JOIN SF4010 F4 (NOLOCK) ON F4_CODIGO = D1.D1_TES  AND F4.D_E_L_E_T_ = ''                                                                                 " + CRLF
	cQuery += " 	FULL JOIN RECNFSINCXM SIT (NOLOCK) ON SIT.XML_CHAVE = CAB.XML_CHAVE AND SIT.D_E_L_E_T_ = ''                                                                   " + CRLF
	cQuery += " 	LEFT JOIN SA1010 A1 (NOLOCK) ON A1_CGC = CAB.XML_EMIT AND A1.D_E_L_E_T_ = ''                                                                                  " + CRLF
	cQuery += " 	LEFT JOIN SF3010 F3 (NOLOCK) ON F3_NFISCAL = SUBSTRING (XML_NUMNF,4,9) AND F3_FILIAL = '02' AND F3.D_E_L_E_T_ = '' 	                                          " + CRLF
	cQuery += "		LEFT JOIN C00010 C00 (NOLOCK) ON C00_CHVNFE = CAB.XML_CHAVE AND C00_CNPJEM = CAB.XML_EMIT AND C00.D_E_L_E_T_ = ''                                             " + CRLF
	cQuery += " WHERE CAB.XML_EMIT NOT IN ('13847910000156','13847910000237','13847910000407','13479490000100')                                                                   " + CRLF
	cQuery += " 	AND XML_EMISSA BETWEEN '"+dToS(MV_PAR01)+"' AND '"+dToS(MV_PAR02)+"'                                                                                          " + CRLF
	cQuery += " 	AND XML_CLIFOR = 'C'                                                                                                                                          " + CRLF
	cQuery += " 	AND XML_DEST = '05205107000270'                                                                                                                               " + CRLF
	cQuery += " 	AND CAB.D_E_L_E_T_ = ''                                                                                                                                       " + CRLF

	cQuery += " UNION ALL                                                                                                                                                         " + CRLF

	cQuery += " 	SELECT DISTINCT                                                                                                                                               " + CRLF 
	cQuery += " 		'TALIS' EMPRESA,                                                                                                                                          " + CRLF 
	cQuery += " 		CONVERT (DATE,XML_EMISSA,103) EMISSAO,CAB.XML_CHAVE CHAVE,SUBSTRING (XML_NUMNF,4,9) DOCUMENTO,                                                            " + CRLF 
	cQuery += " 		F6.F1_DOC ENTR,                                                                                                                                           " + CRLF 
	cQuery += " 		CAB.XML_EMIT CNPJ,A1_COD,UPPER(XML_NOMEMT) FORNECE, A1_EST UF,XIT_CFNFE CFOP_CLI,                                                                         " + CRLF 
	cQuery += " 		D1.D1_CF CF_ENTR,D1.D1_COD PRODUTO,B1_DESC DESCRICAO, XIT_CLASFI CSTICMS_CLI, D1.D1_CLASFIS CSTICMS, XIT_NCM NCM_CLI, B1_POSIPI NCM,                      " + CRLF 
	cQuery += " 		XIT_PICM ALIQICMS_CLI,D1.D1_ALIQSOL ALIQICMS, XIT_PPIS ALIQPIS_CLI,D1.D1_ALQIMP6 ALIQPIS ,XIT_PCOF ALIQCOF_CLI, D1.D1_ALQIMP5 ALIQCOF,                    " + CRLF 
	cQuery += " 		F4_CTIPI CSTIPI, F4_CSTPIS CSTPIS, F4_CSTCOF SCTCOF, F4_BASEICM REDU_ICMS, F4_DISPLEG DISPOS_LEGAL,                                                       " + CRLF 
	cQuery += " 	CASE                                                                                                                                                          " + CRLF 
	cQuery += " 		WHEN CAB.XML_STATF1 = 'A' AND CAB.XML_LANCAD <> '' THEN 'CLASSIFICADA'                                                                                    " + CRLF 
	cQuery += " 		WHEN XIT.XIT_LOTEC <> '' THEN 'NF CANCELADA'                                                                                                              " + CRLF 
	cQuery += " 		WHEN F3_CODRSEF = '102' THEN 'NF INUTILIZADA'                                                                                                             " + CRLF 
	cQuery += " 		WHEN F3_CODRSEF = '101' THEN 'NF CANCELADA'                                                                                                               " + CRLF 
	cQuery += " 		WHEN CAB.XML_LANCAD = '' THEN 'PENDENTE'                                                                                                                  " + CRLF 
	cQuery += " 	END SITUACAO,                                                                                                                                                 " + CRLF 
	cQuery += " 	CASE                                                                                                                                                          " + CRLF 
	cQuery += " 		WHEN C00_STATUS = '0' THEN 'SEM MANIFESTO'                                                                                                                " + CRLF 
	cQuery += " 		WHEN C00_STATUS = '1' THEN 'MANIFESTO CONFIRMADO'                                                                                                         " + CRLF 
	cQuery += " 		WHEN C00_STATUS = '2' THEN 'MANIFESTACAO DESCONHECIDA'                                                                                                    " + CRLF 
	cQuery += " 		WHEN C00_STATUS = '3' THEN 'MANIFESTACAO NAO REALIZADA'                                                                                                   " + CRLF 
	cQuery += " 		WHEN C00_STATUS = '4' THEN 'CIENCIA DA MANIFESTACAO'                                                                                                      " + CRLF 
	cQuery += " 	END MANIFESTO	                                                                                                                                              " + CRLF 
	cQuery += " 	FROM RECNFXML CAB (NOLOCK)                                                                                                                                    " + CRLF 
	cQuery += " 		LEFT JOIN RECNFXMLITENS XIT (NOLOCK) ON XIT_CHAVE = XML_CHAVE AND XIT.D_E_L_E_T_ = ''                                                                     " + CRLF 
	cQuery += " 		FULL JOIN SF1060 F6 (NOLOCK) ON F6.F1_CHVNFE = XML_CHAVE  AND F6.D_E_L_E_T_ = ''                                                                          " + CRLF 
	cQuery += " 		LEFT JOIN SD1060 D1 (NOLOCK) ON D1.D1_FILIAL = F6.F1_FILIAL AND D1.D1_DOC = F6.F1_DOC AND D1.D1_SERIE = F6.F1_SERIE AND D1.D1_FORNECE = F6.F1_FORNECE     " + CRLF 
	cQuery += " 		LEFT JOIN SB1060 B1 (NOLOCK) ON B1_COD = D1_COD AND B1.D_E_L_E_T_ = ''                                                                                    " + CRLF 
	cQuery += " 		LEFT JOIN SF4060 F4 (NOLOCK) ON F4_CODIGO = D1.D1_TES  AND F4.D_E_L_E_T_ = ''                                                                             " + CRLF 
	cQuery += " 		FULL JOIN RECNFSINCXM SIT (NOLOCK) ON SIT.XML_CHAVE = CAB.XML_CHAVE AND SIT.D_E_L_E_T_ = ''                                                               " + CRLF 
	cQuery += " 		LEFT JOIN SA1060 A1 (NOLOCK) ON A1_CGC = CAB.XML_EMIT AND A1.D_E_L_E_T_ = ''                                                                              " + CRLF 
	cQuery += " 		LEFT JOIN SF3010 F3 (NOLOCK) ON F3_NFISCAL = SUBSTRING (XML_NUMNF,4,9) AND F3_FILIAL = '02' AND F3.D_E_L_E_T_ = ''                                        " + CRLF 
	cQuery += " 		LEFT JOIN C00060 C00 (NOLOCK) ON C00_CHVNFE = CAB.XML_CHAVE AND C00_CNPJEM = CAB.XML_EMIT AND C00.D_E_L_E_T_ = ''		                                  " + CRLF 
	cQuery += " 	WHERE XML_EMISSA BETWEEN '"+dToS(MV_PAR01)+"' AND '"+dToS(MV_PAR02)+"'                                                                                        " + CRLF 
	cQuery += " 		AND CAB.XML_DEST = '13479490000100'                                                                                                                       " + CRLF 
	cQuery += " 		AND XML_CLIFOR = 'C'                                                                                                                                      " + CRLF 
	cQuery += " 		AND CAB.D_E_L_E_T_ = ''                                                                                                                                   " + CRLF 

	cQuery += " UNION ALL                                                                                                                                                         " + CRLF

	cQuery += " 	SELECT DISTINCT                                                                                                                                               " + CRLF
	cQuery += " 		'CLEAN FIELD' EMPRESA,                                                                                                                                    " + CRLF
	cQuery += " 		CONVERT (DATE,XML_EMISSA,103) EMISSAO,CAB.XML_CHAVE CHAVE,SUBSTRING (XML_NUMNF,4,9) DOCUMENTO,                                                            " + CRLF
	cQuery += " 		F7.F1_DOC ENT_NF,                                                                                                                                         " + CRLF
	cQuery += " 		CAB.XML_EMIT CNPJ,A1_COD,UPPER(XML_NOMEMT) FORNECE, A1_EST UF,XIT_CFNFE CFOP_CLI,                                                                         " + CRLF
	cQuery += " 		D1.D1_CF CF_ENTR,D1.D1_COD PRODUTO,B1_DESC DESCRICAO, XIT_CLASFI CSTICMS_CLI, D1.D1_CLASFIS CSTICMS, XIT_NCM NCM_CLI, B1_POSIPI NCM,                      " + CRLF
	cQuery += " 		XIT_PICM ALIQICMS_CLI,D1.D1_ALIQSOL ALIQICMS, XIT_PPIS ALIQPIS_CLI,D1.D1_ALQIMP6 ALIQPIS ,XIT_PCOF ALIQCOF_CLI, D1.D1_ALQIMP5 ALIQCOF,                    " + CRLF
	cQuery += " 		F4_CTIPI CSTIPI, F4_CSTPIS CSTPIS, F4_CSTCOF SCTCOF, F4_BASEICM REDU_ICMS, F4_DISPLEG DISPOS_LEGAL,                                                       " + CRLF
	cQuery += " 	CASE                                                                                                                                                          " + CRLF
	cQuery += " 		WHEN CAB.XML_STATF1 = 'A' AND CAB.XML_LANCAD <> '' THEN 'CLASSIFICADA'                                                                                    " + CRLF
	cQuery += " 		WHEN XIT.XIT_LOTEC <> '' THEN 'NF CANCELADA'                                                                                                              " + CRLF
	cQuery += " 		WHEN F3_CODRSEF = '102' THEN 'NF INUTILIZADA'                                                                                                             " + CRLF
	cQuery += " 		WHEN F3_CODRSEF = '101' THEN 'NF CANCELADA'                                                                                                               " + CRLF
	cQuery += " 		WHEN CAB.XML_LANCAD = '' THEN 'PENDENTE'                                                                                                                  " + CRLF
	cQuery += " 	END SITUACAO,                                                                                                                                                 " + CRLF
	cQuery += " 	CASE                                                                                                                                                          " + CRLF
	cQuery += " 		WHEN C00_STATUS = '0' THEN 'SEM MANIFESTO'                                                                                                                " + CRLF
	cQuery += " 		WHEN C00_STATUS = '1' THEN 'MANIFESTO CONFIRMADO'                                                                                                         " + CRLF
	cQuery += " 		WHEN C00_STATUS = '2' THEN 'MANIFESTACAO DESCONHECIDA'                                                                                                    " + CRLF
	cQuery += " 		WHEN C00_STATUS = '3' THEN 'MANIFESTACAO NAO REALIZADA'                                                                                                   " + CRLF
	cQuery += " 		WHEN C00_STATUS = '4' THEN 'CIENCIA DA MANIFESTACAO'                                                                                                      " + CRLF
	cQuery += " 	END MANIFESTO	                                                                                                                                              " + CRLF
	cQuery += " 	FROM RECNFXML CAB (NOLOCK)                                                                                                                                    " + CRLF
	cQuery += " 		LEFT JOIN RECNFXMLITENS XIT (NOLOCK) ON XIT_CHAVE = XML_CHAVE AND XIT.D_E_L_E_T_ = ''                                                                     " + CRLF
	cQuery += " 		FULL JOIN SF1070 F7 (NOLOCK) ON F7.F1_CHVNFE = XML_CHAVE  AND F7.D_E_L_E_T_ = ''                                                                          " + CRLF
	cQuery += " 		LEFT JOIN SD1070 D1 (NOLOCK) ON D1.D1_FILIAL = F7.F1_FILIAL AND D1.D1_DOC = F7.F1_DOC AND D1.D1_SERIE = F7.F1_SERIE AND D1.D1_FORNECE = F7.F1_FORNECE     " + CRLF
	cQuery += " 		LEFT JOIN SB1070 B1 (NOLOCK) ON B1_COD = D1_COD AND B1.D_E_L_E_T_ = ''                                                                                    " + CRLF
	cQuery += " 		LEFT JOIN SF4070 F4 (NOLOCK) ON F4_CODIGO = D1.D1_TES  AND F4.D_E_L_E_T_ = ''                                                                             " + CRLF
	cQuery += " 		FULL JOIN RECNFSINCXM SIT (NOLOCK) ON SIT.XML_CHAVE = CAB.XML_CHAVE AND SIT.D_E_L_E_T_ = ''                                                               " + CRLF
	cQuery += " 		LEFT JOIN SA1070 A1 (NOLOCK) ON A1_CGC = CAB.XML_EMIT AND A1.D_E_L_E_T_ = ''                                                                              " + CRLF
	cQuery += " 		LEFT JOIN SF3010 F3 (NOLOCK) ON F3_NFISCAL = SUBSTRING (XML_NUMNF,4,9) AND F3.D_E_L_E_T_ = '' 	                                                          " + CRLF
	cQuery += " 		LEFT JOIN C00070 C00 (NOLOCK) ON C00_CHVNFE = CAB.XML_CHAVE AND C00_CNPJEM = CAB.XML_EMIT AND C00.D_E_L_E_T_ = ''	                                      " + CRLF
	cQuery += " 	WHERE XML_EMISSA BETWEEN '"+dToS(MV_PAR01)+"' AND '"+dToS(MV_PAR02)+"'                                                                                        " + CRLF
	cQuery += " 		AND CAB.XML_DEST IN  ('13847910000156','13847910000237','13847910000407')                                                                                 " + CRLF
	cQuery += " 		AND XML_CLIFOR = 'C'                                                                                                                                      " + CRLF
	cQuery += " 		AND CAB.D_E_L_E_T_ = ''                                                                                                                                   " + CRLF		

	TCQUERY cQuery ALIAS (cAlias) NEW

	DbSelectArea( cAlias )
	DbGoTop()
	oReport:SetMeter((cAlias)->(RecCount()))
	
	oSecao1:SetHeaderSection(lCabec)	//Nao imprime o cabeçalho da secao
	oSecao1:Init()
	
	While !Eof()
		oSecao1:PrintLine()
		oReport:IncMeter()
		DbSkip()
		//oSecao1:SetHeaderSection(.F.)
		
	EndDo
	
	oSecao1:Finish()

Return Nil
