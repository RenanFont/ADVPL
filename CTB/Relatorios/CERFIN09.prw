#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"      
/*/{Protheus.doc} CERFIN09
Rotina para geracao de relatorio de comissao de vendedor,
passada pelo Fabiano em 27/06/2018, para uso do Bruno - Contabilidade.
@author Junior
@since 03/05/2018
@type function
/*/
User Function CERFIN09()

	Private cAlias 		:= GetNextAlias()
	Private aPerg		:= {}
	Private aRet 		:= {}
	Private aParam		:= {;
							dDataBase ,;
							Space(6) ;
							}
	Private aTipo		:=	{;
							"1-Sintetico",;
							"2-Analitico";
							}

	Aadd(aPerg,{1,"NF DT. Emissao De" ,aParam[01]	,"@!"	,""		,""		,""	,55,.T.})
	Aadd(aPerg,{1,"NF DT. Emissao De" ,aParam[01]	,"@!"	,""		,""		,""	,55,.T.})
	Aadd(aPerg,{1,"Do Vendedor"       ,aParam[02]	,"@!"	,""		,"SA3"	,""	,55,.F.})
	Aadd(aPerg,{1,"Ate Vendedor"      ,aParam[02]	,"@!"	,""		,"SA3"	,""	,55,.F.})
	//Aadd(aPerg,{1,"Da Inadimplencia"  ,aParam[01]	,"@!"	,""		,""		,""	,55,.T.})
	//Aadd(aPerg,{1,"Ate Inadimplencia" ,aParam[01]	,"@!"	,""		,""		,""	,55,.T.})
	aAdd(aPerg,{2,"Tipo de Relatório" ,"1"			, aTipo ,50		,'.T.'  ,.T.})

	If ParamBox(aPerg,"Comissao Vendedor Unid. Negocio",@aRet)
		aRet[5] := Substr(aRet[5],1,1)
		oReport := ReportDef(cAlias)
		oReport:printDialog()
	EndIf

U_MCERLOG()
Return()
/*
Funcao ReportDef
*/
Static Function ReportDef(cAlias, cGrupo)

	Local cTitle  := "Comissao Vendedor Unid. Negocio"
	Local cHelp   := "Gera comissão de Vendedor Unid. Negocio"
	Local oReport
	Local oSection1
	Local oSection2
	Local oBreak

	If aRet[5] == "1" //Sintetico

		oReport := TReport():New('COMISV03',cTitle,,{|oReport| RptPrtV3(oReport,cAlias)},cHelp)

		//Primeira seção
		oSection1 := TRSection():New(oReport,"COMISSAO",{cAlias}) 

		TRCell():New(oSection1,"F2_VEND1"					,	cAlias, "Vendedor", "", TamSX3("A3_COD")[1] ,,        { || (cAlias)->VEND     } )
		TRCell():New(oSection1,"A3_NOME"					,	cAlias, "Nome do Vendedor", "", TamSX3("A3_NOME")[1],,{ || (cAlias)->NOMEVEND } )

		oSection2 := TRSection():New(oReport,"COMISSAO",{cAlias})
		TRCell():New(oSection2,"B1_GRUPO"					,	cAlias, "Unid.Neg"		, Nil						 , Nil , /*lPixel*/	, { || (cAlias)->GRUPO    } )
		TRCell():New(oSection2,"TOTAL"						,	cAlias, "Vlr Total"		, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	, { || (cAlias)->TOTAL    } )
		TRCell():New(oSection2,"XPCOMIS"					,	cAlias, "%Comissao"		, PesqPict("SA3", "A3_COM01"), 05  , /*lPixel*/	, { || (cAlias)->XPCOMIS  } )
		TRCell():New(oSection2,"VLCOMIS"					,	cAlias, "Comissao"		, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	, { || (cAlias)->VLCOMIS  } )
		
		oBreak := TRBreak():New(oSection2,"VEND","Total Comissao")
		TRFunction():New(oSection2:Cell("VLCOMIS")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)
		TRFunction():New(oSection2:Cell("TOTAL")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)

	Else

		//ANALITICO
		oReport := TReport():New('COMISV02',cTitle,,{|oReport| RptPrtV2(oReport,cAlias)},cHelp)
		//Primeira seção
		oSection1 := TRSection():New(oReport,"COMISSAO",{cAlias}) 

		TRCell():New(oSection1,"F2_VEND1"					,	cAlias, "Vendedor", "", TamSX3("A3_COD")[1] ,,        { || (cAlias)->VEND     } )
		TRCell():New(oSection1,"A3_NOME"					,	cAlias, "Nome do Vendedor", "", TamSX3("A3_NOME")[1],,{ || (cAlias)->NOMEVEND } )

		//Segunda seção
		oSection2 := TRSection():New(oReport,"COMISSAO",{cAlias}) 
		TRCell():New(oSection2,"F2_EMISSAO"					,  	cAlias, "Data Emissao"  , Nil						 , 11  , /*lPixel*/ , { || (cAlias)->EMISSAO  } )
		TRCell():New(oSection2,"DOCSERIE"					,  	cAlias, "NF"			, Nil						 , 11  , /*lPixel*/ , { || (cAlias)->DOCSERIE } )
		TRCell():New(oSection2,"CLIENTE"					,	cAlias, "CLIENTE"		, Nil						 , 50  , /*lPixel*/ , { || (cAlias)->CLIENTE  } )
		TRCell():New(oSection2,"A3_XPCOMIS"					,	cAlias, "%Comissao"		, PesqPict("SA3", "A3_COM01"), 05  , /*lPixel*/	, { || (cAlias)->XPCOMIS  } )
		TRCell():New(oSection2,"VLCOMIS"					,	cAlias, "Comissao"		, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	, { || (cAlias)->VLCOMIS  } )
		TRCell():New(oSection2,"D2_TOTAL"					,	cAlias, "Total Item"	, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	, { || (cAlias)->TOTAL    } )
		TRCell():New(oSection2,PadL("D2_COD", 8)			,	cAlias, "Produto"		, Nil						 , 08  , /*lPixel*/	, { || (cAlias)->PRODUTO  } )
		TRCell():New(oSection2,"B1_DESC"					,	cAlias, "Desc.Prod"		, Nil						 , 40  , /*lPixel*/	, { || (cAlias)->DESCRI   } )
		TRCell():New(oSection2,"B1_GRUPO"					,	cAlias, "Unid.Neg"		, Nil						 , Nil , /*lPixel*/	, { || (cAlias)->GRUPO    } )

		oBreak := TRBreak():New(oSection2,"VEND","Total Comissao")
		TRFunction():New(oSection2:Cell("VLCOMIS")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)
		TRFunction():New(oSection2:Cell("D2_TOTAL")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)

	Endif

Return(oReport)
/*
Funcao Reportprint
Monta a query e executa a impresso
*/

Static Function RptPrtV3( oReport, cAlias )

	Local lRet 		:= .T.
	Local oSecao1 	:= oReport:Section(1)
	Local oSecao2 	:= oReport:Section(2)
	Local cCodVend	:= ''
	Local lCabec	:= .T.
	Local cQuery 	:= ""
	Local cEol 		:= CHR(13) + CHR(10)

	_dData1	:=	aRet[1]
	_dData2 :=	aRet[2]
	_cVend1 :=	aRet[3]
	_cVend2 :=	aRet[4]
	_nTipo  :=	aRet[5]
	//_dTit1 	:=	aRet[5]
	//_dTit2	:=	aRet[6]

	//Soma os dados por unidade de negócio
	cQuery := "SELECT F2_VEND1 VEND, A3_NOME NOMEVEND , B1_GRUPO GRUPO , SUM(D2_TOTAL) TOTAL, "
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol 
	cQuery += "			THEN A3_COM01 " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN A3_COM02 " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN A3_COM03 " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN A3_COM04 " + cEol
	cQuery += "					ELSE  " + cEol
	cQuery += "						Case B1_GRUPO WHEN 'UNCA' " + cEol 
	cQuery += "							THEN A3_COM05 " + cEol
	cQuery += "						END "  + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "	AS XPCOMIS , "  + cEol
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol
	cQuery += "			THEN SUM(D2_TOTAL*(A3_COM01/100)) " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN SUM(D2_TOTAL*(A3_COM02/100)) " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN SUM(D2_TOTAL*(A3_COM03/100)) " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN SUM(D2_TOTAL*(A3_COM04/100)) " + cEol
	cQuery += "					ELSE"
	cQuery += "						Case B1_GRUPO WHEN 'UNCA' " + cEol 
	cQuery += "							THEN SUM(D2_TOTAL*(A3_COM05/100)) " + cEol
	cQuery += "						END "  + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "	AS VLCOMIS " + cEol
	cQuery += " FROM " + RetSqlName("SF2") + " F2, " + RetSqlName("SD2") + " D2, " + cEol
	cQuery += RetSqlName("SA3") + " A3, " + RetSqlName("SB1") + " B1, "  + RetSqlName("SA1") + " A1 " + cEol
	cQuery += "		WHERE F2_DUPL <>'' AND " + cEol
	//cQuery += "		 F2_FILIAL = '" + xFilial("SF2") + "' AND F2_FILIAL = D2_FILIAL AND " + cEol
	cQuery += "		 F2_FILIAL = D2_FILIAL AND " + cEol
	cQuery += "      F2_EMISSAO >='"+DTOS(_dData1)+"' AND F2_EMISSAO <='"+DTOS(_dData2)+"' AND " + cEol
	cQuery += "      F2_VEND1   >='"+_cVend1+"'      AND F2_VEND1    <='"+_cVend2+"'       AND " + cEol
	cQuery += "      A3_COD=F2_VEND1 AND " + cEol
	cQuery += "      D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND " + cEol
	cQuery += "      F2.D_E_L_E_T_<>'*'  AND A3.D_E_L_E_T_<>'*' AND D2.D_E_L_E_T_<>'*' AND B1.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND " + cEol
	cQuery += "      F2_TIPO='N' AND "  + cEol
	//	cQuery += "      A3_XMAT <>'' AND "  + cEol
	cQuery += "      D2_COD = B1_COD AND "  + cEol
	cQuery += "      F2_CLIENTE = A1_COD AND " + cEol
	cQuery += "      F2_LOJA = A1_LOJA AND " + cEol
	cQuery += "      F2_CLIENTE = D2_CLIENTE AND " + cEol
	cQuery += "      F2_LOJA = D2_LOJA " + cEol
	cQuery += "      GROUP BY F2_VEND1, A3_NOME, B1_GRUPO , A3_COM01 , A3_COM02 , A3_COM03 , A3_COM04 , A3_COM05" + cEol

	cQuery += "UNION ALL" + cEol
	cQuery += "SELECT F2_VEND1, A3_NOME, B1_GRUPO, SUM(D1_TOTAL*-1) TOTIT,  " + cEol 
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol 
	cQuery += "			THEN A3_COM01 " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN A3_COM02 " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN A3_COM03 " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN A3_COM04 " + cEol
	cQuery += "					ELSE  " + cEol
	cQuery += "						Case B1_GRUPO WHEN 'UNCA'  " + cEol
	cQuery += "							THEN A3_COM05  " + cEol
	cQuery += "						END  " + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "	AS A3_XPCOMIS , "  + cEol
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol
	cQuery += "			THEN SUM((D1_TOTAL*(A3_COM01/100))*-1) " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN SUM((D1_TOTAL*(A3_COM02/100))*-1) " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN SUM((D1_TOTAL*(A3_COM03/100))*-1) " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN SUM((D1_TOTAL*(A3_COM04/100))*-1) " + cEol
	cQuery += "					ELSE  " + cEol
	cQuery += "						Case B1_GRUPO WHEN 'UNCA' " + cEol 
	cQuery += "							THEN SUM((D1_TOTAL*(A3_COM05/100))*-1) " + cEol
	cQuery += "						END "  + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "	AS VLCOMIS " + cEol
	cQuery += "FROM "+RetSqlName('SD1')+" SD1 " + cEol
	cQuery += "		INNER JOIN "+RetSqlName('SF2')+" SF2 ON F2_DOC = D1_NFORI AND F2_SERIE = D1_SERIORI " + cEol 
	cQuery += "		INNER JOIN "+RetSqlName('SF1')+" SF1 ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA " + cEol 
	cQuery += "		INNER JOIN "+RetSqlName('SA3')+" SA3 ON A3_COD = F2_VEND1" + cEol
	cQuery += "		INNER JOIN "+RetSqlName('SB1')+" SB1 ON B1_COD = D1_COD " + cEol
	cQuery += "		INNER JOIN "+RetSqlName('SA1')+" SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA" + cEol
	cQuery += "  	WHERE D1_DTDIGIT >='"+DTOS(_dData1)+"' AND D1_DTDIGIT <= '"+DTOS(_dData2)+"' " + cEol
	cQuery += "  	AND SD1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' AND SF1.D_E_L_E_T_<>'*' " + cEol
	cQuery += "     AND F2_VEND1   >='"+_cVend1+"'      AND F2_VEND1    <='"+_cVend2+"' " + cEol
	cQuery += "  	AND F1_TIPO = 'D' " + cEol
	cQuery += "  	AND D1_TP IN('PA','RV') " + cEol
	cQuery += "  	AND D1_NFORI <> ' ' " + cEol
	cQuery += "  	AND A3_COD = F2_VEND1 " + cEol
	cQuery += "     GROUP BY F2_VEND1, A3_XPCOMIS , A3_NOME, B1_GRUPO , A3_COM01 , A3_COM02 , A3_COM03 , A3_COM04 , A3_COM05" + cEol
	cQuery += "  	ORDER BY F2_VEND1, B1_GRUPO "
	
	memowrit("CERFIN09V3.sql",cquery)
	
	TCQUERY cQuery ALIAS (cAlias) NEW

	DbSelectArea( cAlias )
	DbGoTop()
	oReport:SetMeter((cAlias)->(RecCount()))
	While !Eof()
		cCodVend := (cAlias)->VEND
		oSecao1:SetHeaderSection(lCabec)	//Nao imprime o cabeçalho da secao
		oSecao1:Init()
		oSecao1:PrintLine()
		oSecao1:Finish()
		oSecao2:Init()
		While !Eof() .AND. cCodVend == (cAlias)->VEND
			oSecao2:SetHeaderSection(lCabec)	//Nao imprime o cabeçalho da secao
			lCabec := .F.
			oSecao2:PrintLine()	
			oReport:IncMeter()
			DbSkip()
		EndDo

		oSecao2:Finish()
		oReport:SkipLine()
		oReport:ThinLine()
	EndDo

Return Nil
/*/{Protheus.doc} COMISV02
//TODO Descrição auto-gerada.
@author Junior
@since 03/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function RptPrtV2( oReport, cAlias)

	Local lRet 		:= .T.
	Local oSecao1 	:= oReport:Section(1)
	Local oSecao2 	:= oReport:Section(2)

	Local cCodVend	:= ''
	Local lCabec	:= .T.
	Local cQuery 	:= ""
	Local cEol 		:= CHR(13) + CHR(10)

	_dData1	:=	aRet[1]
	_dData2 :=	aRet[2]
	_cVend1 :=	aRet[3]
	_cVend2 :=	aRet[4]
	_nTipo  :=	aRet[5]
	//_dTit1 	:=	aRet[5]
	//_dTit2	:=	aRet[6]

	// Faz a selecao dos dados por item
	cQuery := "SELECT  F2_VEND1 VEND , A3_XMAT XMAT, A3_NOME NOMEVEND ,F2_EMISSAO EMISSAO, " + cEol
	cQuery += " 	(F2_DOC + '-' + F2_SERIE) DOCSERIE,D2_COD PRODUTO, " + cEol
	cQuery += " 	B1_DESC DESCRI, (F2_CLIENTE + ' ' + A1_NREDUZ) CLIENTE, " + cEol
	cQuery += " 	B1_GRUPO GRUPO , " + cEol
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol 
	cQuery += "			THEN A3_COM01 " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN A3_COM02 " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN A3_COM03 " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN A3_COM04 " + cEol
	cQuery += "					ELSE  " + cEol
	cQuery += "						Case B1_GRUPO WHEN 'UNCA' " + cEol 
	cQuery += "							THEN A3_COM05 " + cEol
	cQuery += "						END "  + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "	AS XPCOMIS,D2_TOTAL TOTAL, "
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol 
	cQuery += "			THEN (D2_TOTAL*(A3_COM01/100)) " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN (D2_TOTAL*(A3_COM02/100)) " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN (D2_TOTAL*(A3_COM03/100)) " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN (D2_TOTAL*(A3_COM04/100)) " + cEol
	cQuery += "					ELSE " + cEol
	cQuery += "						Case B1_GRUPO WHEN 'UNCA' " + cEol 
	cQuery += "							THEN (D2_TOTAL*(A3_COM05/100)) " + cEol
	cQuery += "						END "  + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "AS VLCOMIS " + cEol
	cQuery += " FROM " + RetSqlName("SF2") + " F2, " + RetSqlName("SD2") + " D2, " + cEol
	cQuery += RetSqlName("SA3") + " A3, " + RetSqlName("SB1") + " B1, "  + RetSqlName("SA1") + " A1 " + cEol
	cQuery += "		WHERE F2_DUPL <>'' AND " + cEol
	//cQuery += "		 F2_FILIAL = '" + xFilial("SF2") + "' AND F2_FILIAL = D2_FILIAL AND " + cEol
	cQuery += "		 F2_FILIAL = D2_FILIAL AND " + cEol
	cQuery += "      F2_EMISSAO >='"+DTOS(_dData1)+"' AND F2_EMISSAO <='"+DTOS(_dData2)+"' AND " + cEol
	cQuery += "      F2_VEND1   >='"+_cVend1+"'      AND F2_VEND1    <='"+_cVend2+"'       AND " + cEol
	cQuery += "      A3_COD=F2_VEND1 AND " + cEol
	cQuery += "      D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND " + cEol
	cQuery += "      F2.D_E_L_E_T_<>'*'  AND A3.D_E_L_E_T_<>'*' AND D2.D_E_L_E_T_<>'*' AND B1.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND " + cEol
	cQuery += "      F2_TIPO='N' AND "  + cEol
	//	cQuery += "      A3_XMAT <>'' AND "  + cEol
	cQuery += "      D2_COD = B1_COD AND "  + cEol
	cQuery += "      F2_CLIENTE = A1_COD AND " + cEol
	cQuery += "      F2_LOJA = A1_LOJA AND " + cEol
	cQuery += "      F2_CLIENTE = D2_CLIENTE AND " + cEol
	cQuery += "      F2_LOJA = D2_LOJA " + cEol

	cQuery += "UNION ALL" + cEol

	cQuery += "SELECT F2_VEND1, A3_XMAT, A3_NOME, F1_DTDIGIT F2_EMISSAO, " + cEol
	cQuery += "		(F1_DOC + "-" + F1_SERIE) DOCSERIE, D1_COD D2_COD, " + cEol
	cQuery += "  	B1_DESC, (F1_FORNECE + ' ' + A1_NREDUZ) CLIENTE, " + cEol
	cQuery += "  	B1_GRUPO, " 
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol 
	cQuery += "			THEN A3_COM01 " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN A3_COM02 " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN A3_COM03 " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN A3_COM04 " + cEol
	cQuery += "					ELSE  " + cEol
	cQuery += "						Case B1_GRUPO WHEN 'UNCA'  " + cEol
	cQuery += "							THEN A3_COM05  " + cEol
	cQuery += "						END  " + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "	AS A3_XPCOMIS, (D1_TOTAL*-1) D2_TOTAL, " + cEol 
	cQuery += "		Case B1_GRUPO WHEN 'UNCE' " + cEol 
	cQuery += "			THEN (D1_TOTAL*(A3_COM01/100))*-1 " + cEol
	cQuery += "		ELSE "  + cEol
	cQuery += "			Case B1_GRUPO WHEN 'UNBB' "  + cEol 
	cQuery += "				THEN (D1_TOTAL*(A3_COM02/100))*-1 " + cEol
	cQuery += "			ELSE "  + cEol
	cQuery += "				Case B1_GRUPO WHEN 'UNRN' " + cEol 
	cQuery += "					THEN (D1_TOTAL*(A3_COM03/100))*-1 " + cEol
	cQuery += "				ELSE "  + cEol
	cQuery += "					Case B1_GRUPO WHEN 'UNRI' " + cEol 
	cQuery += "						THEN (D1_TOTAL*(A3_COM04/100))*-1 " + cEol
	cQuery += "					ELSE  " + cEol	
	cQuery += "						Case B1_GRUPO WHEN 'UNCA' " + cEol 
	cQuery += "							THEN (D1_TOTAL*(A3_COM05/100))*-1 " + cEol
	cQuery += "						END "  + cEol
	cQuery += "					END "  + cEol
	cQuery += "				END "  + cEol
	cQuery += "			END "  + cEol
	cQuery += "		END "  + cEol
	cQuery += "AS VLCOMIS " + cEol
	cQuery += "FROM "+RetSqlName('SD1')+" SD1 " + cEol
	cQuery += "		INNER JOIN "+RetSqlName('SF2')+" SF2 ON F2_DOC = D1_NFORI AND F2_SERIE = D1_SERIORI " + cEol 
	cQuery += "		INNER JOIN "+RetSqlName('SF1')+" SF1 ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA " + cEol 
	cQuery += "		INNER JOIN "+RetSqlName('SA3')+" SA3 ON A3_COD = F2_VEND1" + cEol
	cQuery += "		INNER JOIN "+RetSqlName('SB1')+" SB1 ON B1_COD = D1_COD " + cEol
	cQuery += "		INNER JOIN "+RetSqlName('SA1')+" SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA" + cEol
	cQuery += "  	WHERE D1_DTDIGIT >='"+DTOS(_dData1)+"' AND D1_DTDIGIT <= '"+DTOS(_dData2)+"' " + cEol
	cQuery += "  	AND SD1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' AND SF1.D_E_L_E_T_<>'*' " + cEol
	cQuery += "     AND F2_VEND1   >='"+_cVend1+"'      AND F2_VEND1    <='"+_cVend2+"' " + cEol
	cQuery += "  	AND F1_TIPO = 'D' " + cEol
	cQuery += "  	AND D1_TP IN('PA','RV') " + cEol
	cQuery += "  	AND D1_NFORI <> ' ' " + cEol
	cQuery += "  	AND A3_COD = F2_VEND1 " + cEol
	cQuery += "  	ORDER BY B1_GRUPO, F2_VEND1,F2_EMISSAO  " + cEol
	
	memowrit("CERFIN09V2.sql",cquery)
	
	TCQUERY cQuery ALIAS (cAlias) NEW
	TCSetField( (cAlias), "F2_EMISSAO", "D",  8, 0 )

	DbSelectArea( cAlias )
	DbGoTop()
	oReport:SetMeter((cAlias)->(RecCount()))
	While !Eof()
		cCodVend := (cAlias)->VEND
		oSecao1:SetHeaderSection(lCabec)	//Nao imprime o cabeçalho da secao
		oSecao1:Init()
		oSecao1:PrintLine()
		oSecao1:Finish()
		oSecao2:Init()
		While !Eof() .AND. cCodVend == (cAlias)->VEND
			oSecao2:SetHeaderSection(lCabec)	//Nao imprime o cabeçalho da secao
			lCabec := .F.
			oSecao2:PrintLine()	
			oReport:IncMeter()
			DbSkip()
		EndDo

		oSecao2:Finish()
		oReport:SkipLine()
		oReport:ThinLine()
	EndDo

Return Nil