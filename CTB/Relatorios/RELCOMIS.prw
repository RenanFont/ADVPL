#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"      
/*/{Protheus.doc} RELCOMISS
Rotina para geracao de relatorio de comissao de vendedor,
@author Manoel Nésio
@since 30/08/2019
@type function
/*/
User Function RELCOMIS()

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

	Private aTipoVen	:=	{;
	"1-Parceiros",;
	"2-Vendedores",;
	"3-Ambos";
	}

	Private aTipoCla	:=	{;
	"2-Não",;
	"1-Sim";
	}

	Private aTipoPrd	:=	{;
	"2-Não",;
	"1-Sim";
	}
	
	Private aParam2		:= {;
	"01;07;06" ,;
	Space(6) ;
	}
	
	Aadd(aPerg,{1,"Emissao De" 			,aParam[01]	,"@!"			,""		,""		,""	,55,.T.})
	Aadd(aPerg,{1,"Emissao Até" 		,aParam[01]	,"@!"			,""		,""		,""	,55,.T.})
	Aadd(aPerg,{1,"Do Vendedor"       	,"      "	,"@!"			,""		,"SA3"	,""	,55,.F.})
	Aadd(aPerg,{1,"Ate Vendedor"      	,"ZZZZZZ"	,"@!"			,""		,"SA3"	,""	,55,.F.})
	aAdd(aPerg,{2,"Tipo de Relatório" 	,"1"		, aTipo 		,50		,'.T.'  ,.T.})
	aAdd(aPerg,{2,"Tipo de Vendedor" 	,"1"		, aTipoVen 		,50		,'.T.'  ,.T.})
	Aadd(aPerg,{1,"Aliquota IR %"      	,1.5		,"@E 99.99"		,""		,""	,""	,55	,.T.})
	aAdd(aPerg,{2,"Por Classe?" 		,"1"		, aTipoCla 		,50		,'.T.'  ,.T.})
	aAdd(aPerg,{2,"Por Produto?" 		,"1"		, aTipoPrd 		,50		,'.T.'  ,.T.})
	aAdd(aPerg,{1,"Empresas?" 			,aParam2[01], "" 			,""		,""		,""	,55,.T.})
	//Aadd(aPerg,{1,"Aliquota IR %"     ,1.5		,"@E 99.99"		,""		,""		,""	,55,.T.})

	If ParamBox(aPerg,"Comissao Vendedor Unid. Negocio",@aRet)

		aRet[5] := Substr(aRet[5],1,1)
		aRet[6] := Substr(aRet[6],1,1)
		aRet[8] := Substr(aRet[8],1,1)
		aRet[9] := Substr(aRet[9],1,1)

		IF ALLTRIM(aRet[10]) == "" 

			Alert("Campo de empresas invalido!")

		ELSE

			oReport := ReportDef(cAlias)
			oReport:printDialog()

		ENDIF

	EndIf
U_MCERLOG()
Return
/*
Funcao ReportDef
*/
Static Function ReportDef(cAlias, cGrupo)

	Local cTitle  := "Comissao Vendedor"
	Local cHelp   := "Gera comissão de Vendedor"
	Local oReport
	Local oSection1
	Local oSection2
	Local oBreak

	If aRet[5] == "1" //Sintetico

		oReport := TReport():New('COMISV03',cTitle,,{|oReport| RptPrtV3(oReport,cAlias)},cHelp)

		//Primeira seção
		oSection1 := TRSection():New(oReport,"COMISSAO",{cAlias}) 

		//TRCell():New(oSection1,"EMPRESA"					,	cAlias, "Empre", "", TamSX3("A3_COD")[1] ,,        { || (cAlias)->VEND     } )
		//oSecao1:Cell("F2_EMISSAO"):SetValue(STOD(cEmissao))
		TRCell():New(oSection1,"F2_EMISSAO"					,	cAlias, "Emissao", ""			, 11,,         )
		TRCell():New(oSection1,"F2_VEND1"					,	cAlias, "Vendedor", ""			, TamSX3("A3_COD")[1] ,,         )
		TRCell():New(oSection1,"A3_NOME"					,	cAlias, "Nome do Vendedor", ""	, TamSX3("A3_NOME")[1],, )
		TRCell():New(oSection1,"A3_FORNECE"					,	cAlias, "Codigo Fornecedor", ""	, TamSX3("A3_FORNECE")[1],, )
		TRCell():New(oSection1,"A3_LOJA"					,	cAlias, "Loja", ""				, TamSX3("A3_LOJA")[1],, )
		TRCell():New(oSection1,"TOTAL"						,	cAlias, "Vlr Total"				, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	,  )
		//TRCell():New(oSection1,"VLIR"						,	cAlias, "Vlr. IR"				, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	, { || (cAlias)->VLIR  } )
		//TRCell():New(oSection1,"XPCOMIS"					,	cAlias, "%Comissao"				, PesqPict("SA3", "A3_COM01"), 05  , /*lPixel*/	, { || (cAlias)->XPCOMIS  } )
		TRCell():New(oSection1,"VLCOMIS"					,	cAlias, "Comissao"				, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	,  )
		TRCell():New(oSection1,"VLIR"						,	cAlias, "Vlr. IR"				, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	,)
		TRCell():New(oSection1,"VLLIQ"						,	cAlias, "Vlr. Liquido"			, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	,)

		oBreak := TRBreak():New(oSection1,oSection1:Cell("F2_VEND1"),"Total Comissao")
		TRFunction():New(oSection1:Cell("VLCOMIS")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)
		TRFunction():New(oSection1:Cell("TOTAL")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)

	Else

		//ANALITICO
		oReport := TReport():New('COMISV02',cTitle,,{|oReport| RptPrtV2(oReport,cAlias)},cHelp)

		//Primeira seção
		oSection1 := TRSection():New(oReport,"COMISSAO",{cAlias}) 
		//oSecao1:Cell("F2_EMISSAO"):SetValue(STOD(cEmissao))
		TRCell():New(oSection1,"F2_EMISSAO"					,	cAlias, "Emissao", ""			, 11,,         )
		//TRCell():New(oSecao1:Cell("F2_EMISSAO"):SetValue(STOD(cEmissao))						,	cAlias, "Emissao", "", 11,,         )
		TRCell():New(oSection1,"EMPRESA"					,	cAlias, "Empresa", ""			, TamSX3("A3_FILIAL")[1] ,,  )
		TRCell():New(oSection1,"FILIAL"						,	cAlias, "Filial", ""			, TamSX3("A3_FILIAL")[1] ,,  )
		TRCell():New(oSection1,"F2_V7END1"					,	cAlias, "Vendedor", ""			, TamSX3("A3_COD")[1] ,,      )
		TRCell():New(oSection1,"A3_NOME"					,	cAlias, "Nome do Vendedor", ""	, TamSX3("A3_NOME")[1],, )
		TRCell():New(oSection1,"A3_FORNECE"					,	cAlias, "Codigo Fornecedor", ""	, TamSX3("A3_FORNECE")[1],, )
		TRCell():New(oSection1,"A3_LOJA"					,	cAlias, "Loja", ""				, TamSX3("A3_LOJA")[1],, )
		TRCell():New(oSection1,"DOCSERIE"					,  	cAlias, "NF"					, Nil						 , 11  , /*lPixel*/ ,  )
		//TRCell():New(oSection1,"F2_EMISSAO"				,  	cAlias, "Data Emissao"  , Nil	, 11  , /*lPixel*/ , )
		//TRCell():New(oSection1,"CLIENTE"					,	cAlias, "CLIENTE"		, Nil	, 50  , /*lPixel*/ ,  )

		If aRet[8] == "1" //Classe

			TRCell():New(oSection1,"B1_GRUPO"				,	cAlias, "Unid.Neg"				, Nil						 , Nil , /*lPixel*/	,  )

			If aRet[9] == "1" //Produto
				TRCell():New(oSection1,"D2_COD"			,	cAlias, "Produto"		, Nil						 , 08  , /*lPixel*/	,  )
				TRCell():New(oSection1,"B1_DESC"		,	cAlias, "Desc.Prod"		, Nil						 , 40  , /*lPixel*/	,  )

			Endif

		Endif

		TRCell():New(oSection1,"D2_TOTAL"					,	cAlias, "Total Item"	, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	,  )
		TRCell():New(oSection1,"A3_XPCOMIS"					,	cAlias, "%Comissao"		, PesqPict("SA3", "A3_COM01"), 05  , /*lPixel*/	,  )
		TRCell():New(oSection1,"VLCOMIS"					,	cAlias, "Comissao"		, PesqPict("SD2", "D2_TOTAL"), 14  , /*lPixel*/	,  )


		oBreak := TRBreak():New(oSection1,oSection1:Cell("F2_V7END1"),"Total Comissao")
		TRFunction():New(oSection1:Cell("VLCOMIS")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)
		TRFunction():New(oSection1:Cell("D2_TOTAL")	,NIL,"SUM",oBreak, Nil, Nil, Nil, .F., .T., .F.)

	Endif

Return(oReport)
/*
Funcao Reportprint
Monta a query e executa a impresso
*/

Static Function RptPrtV3( oReport, cAlias )

	Local lRet 		:= .T.
	Local oSecao1 	:= oReport:Section(1)
	//Local oSecao2 	:= oReport:Section(2)
	Local cCodVend	:= ''
	Local lCabec	:= .T.
	Local cQuery 	:= ""
	Local cEol 		:= CHR(13) + CHR(10)

	aEmps	:= Strtokarr2(aRet[10] , ";" , .T.)
	_dData1	:=	aRet[1]
	_dData2 :=	aRet[2]
	_cVend1 :=	aRet[3]
	_cVend2 :=	aRet[4]
	_nTipo  :=	aRet[5]

	_nIr  	:= aRet[7]
	//_dTit1 	:=	aRet[5]
	//_dTit2	:=	aRet[6]

	cQuery := ""

	For i:=1 to len (aEmps)
		//Soma os dados por unidade de negócio

		IF i > 1

			cQuery += "UNION ALL" + cEol

		Endif

	cQuery += " SELECT                                                                                                                                                                                                              " + CRLF
	cQuery += " 	F2_EMISSAO EMISSAO,F2_VEND1 VEND, A3_NOME NOMEVEND , B1_GRUPO GRUPO ,A3_FORNECE, A3_LOJA, SUM(D2_TOTAL) TOTAL,                                                                                                  " + CRLF

	cQuery += " 		CASE                                                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN A3_COM01                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN A3_COM02                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN A3_COM03                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN A3_COM04                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN A3_COM05                                                                                                                                                                   " + CRLF
	cQuery += " 		END AS XPCOMIS,		                                                                                                                                                                                       " + CRLF
	cQuery += " 		CASE                                                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN SUM(D2_TOTAL*(A3_COM01/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN SUM(D2_TOTAL*(A3_COM02/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN SUM(D2_TOTAL*(A3_COM03/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN SUM(D2_TOTAL*(A3_COM04/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN SUM(D2_TOTAL*(A3_COM05/100))                                                                                                                                                  " + CRLF
	cQuery += " 		END AS VLCOMIS                                                                                                                                                                                             " + CRLF
	cQuery += " FROM SF2"+STRZERO(VAL(aEmps[i]),2)+"0 SF2 (NOLOCK)                                                                                                                                                                 " + CRLF
	cQuery += " 		LEFT JOIN SD2"+STRZERO(VAL(aEmps[i]),2)+"0 SD2 (NOLOCK) ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.D_E_L_E_T_ = ''     " + CRLF
	cQuery += " 		LEFT JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''                                                                                      " + CRLF
	cQuery += " 		LEFT JOIN " + RetSqlName("SA3") + " SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = ''                                                                                                              " + CRLF
	cQuery += " 		LEFT JOIN SB1"+STRZERO(VAL(aEmps[i]),2)+"0 SB1 (NOLOCK) ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ''                                                                               						   " + CRLF
	cQuery += " WHERE F2_EMISSAO BETWEEN '"+DTOS(_dData1)+"' AND '"+DTOS(_dData2)+"'                                                                                                                                               " + CRLF
	cQuery += " 	AND F2_VEND1 BETWEEN '"+_cVend1+"' AND '"+_cVend2+"'                                                                                                                                                           " + CRLF
	cQuery += "     AND F2_DUPL <> ''                                                                                                                                                                                              " + CRLF
	cQuery += " 	AND F2_TIPO = 'N'                                                                                                                                                                                              " + CRLF
	cQuery += " 	AND F2_CLIENTE <> '062686'                                                                                                                                                                                     " + CRLF

	If STRZERO(VAL(aEmps[i]),2) <> "01"

		cQuery += " AND F2_FILIAL = B1_FILIAL  " + CRLF

	ENDIF

	IF aRet[6] == "1"

		cQuery += "	AND A3_TIPO = 'P' " + CRLF

	ELSEIF aRet[6] == "2"

		cQuery += "	AND A3_TIPO <> 'P' " + CRLF

	ENDIF
	cQuery += " AND SF2.D_E_L_E_T_ = ''                                                                                                                      " + CRLF
	cQuery += " GROUP BY F2_EMISSAO,F2_VEND1, A3_NOME, B1_GRUPO ,A3_FORNECE, A3_LOJA , A3_COM01 , A3_COM02 , A3_COM03 , A3_COM04 , A3_COM05                                                                                                                      " + CRLF
	cQuery += " UNION ALL                                                                                                                                                                                                          " + CRLF
	cQuery += " SELECT                                                                                                                                                                                                                 " + CRLF
	cQuery += " 	F2_EMISSAO,F2_VEND1, A3_NOME, B1_GRUPO ,A3_FORNECE, A3_LOJA , SUM(D1_TOTAL*-1) TOTIT,                                                                                 " + CRLF
	cQuery += " 		CASE                                                                                                                                                                                                           " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN A3_COM01                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN A3_COM02                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN A3_COM03                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN A3_COM04                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN A3_COM05                                                                                                                                                                       " + CRLF
	cQuery += " 		END AS A3_XPCOMIS,                                                                                                                                                                                             " + CRLF
	cQuery += " 		CASE	                                                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN SUM((D1_TOTAL*(A3_COM01/100))*-1)                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN SUM((D1_TOTAL*(A3_COM02/100))*-1)                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN SUM((D1_TOTAL*(A3_COM03/100))*-1)                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN SUM((D1_TOTAL*(A3_COM04/100))*-1)                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN SUM((D1_TOTAL*(A3_COM05/100))*-1)                                                                                                                                                   " + CRLF
	cQuery += " 		END AS VLCOMIS                                                                                                                                                                                                 " + CRLF
	cQuery += " FROM SD1"+STRZERO(VAL(aEmps[i]),2)+"0 SD1 (NOLOCK)                                                                                                                                                                     " + CRLF
	cQuery += " 		INNER JOIN SF2"+STRZERO(VAL(aEmps[i]),2)+"0 SF2 (NOLOCK) ON F2_DOC = D1_NFORI AND F2_SERIE = D1_SERIORI AND F2_FILIAL = D1_FILIAL AND SF2.D_E_L_E_T_ = ''                                                      " + CRLF
	cQuery += " 		INNER JOIN SF1"+STRZERO(VAL(aEmps[i]),2)+"0 SF1 (NOLOCK) ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND D1_FILIAL = D1_FILIAL AND SF1.D_E_L_E_T_ =''         " + CRLF
	cQuery += " 		INNER JOIN "+RetSqlName('SA3')+" SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = ''                                                                                                                     " + CRLF
	cQuery += " 		INNER JOIN SB1"+STRZERO(VAL(aEmps[i]),2)+"0 SB1 (NOLOCK) ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ = ''                                                                                                            " + CRLF
	cQuery += " 		INNER JOIN "+RetSqlName('SA1')+" SA1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''                                                                                             " + CRLF
	cQuery += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(_dData1)+"' AND '"+DTOS(_dData2)+"'                                                                                                                                                   " + CRLF
	cQuery += "   	AND F2_VEND1 BETWEEN '"+_cVend1+"' AND '"+_cVend2+"'                                                                                                                                                               " + CRLF
	cQuery += "   	AND F2_CLIENTE <> '062686' 																																														   " + CRLF //Não considera comissão para Magisfood
	cQuery += "   	AND F1_FORNECE <> '062686' 																																														   " + CRLF //Não considera comissão para Magisfood
	cQuery += " 	AND F1_TIPO = 'D'                                                                                                                                                                                                  " + CRLF
	cQuery += "   	AND D1_TP IN('PA','RV')                                                                                                                                                                                            " + CRLF
	cQuery += "   	AND D1_NFORI <> ' '                                                                                                                                                                                                " + CRLF
	cQuery += " 	AND F1_DUPL <> ''                                                                                                                                                                                                  " + CRLF

	If STRZERO(VAL(aEmps[i]),2) <> "01"

	cQuery += " 	AND F2_FILIAL = B1_FILIAL 																																														   " + CRLF

	ENDIF

	IF aRet[6] == "1"

	cQuery += "   	AND  A3_TIPO = 'P' 																																																   " + CRLF

	ELSEIF aRet[6] == "2"

	cQuery += "   	AND  A3_TIPO <> 'P' 																																															   " + CRLF

	ENDIF

	cQuery += "		AND SD1.D_E_L_E_T_ = ''      


	cQuery += " GROUP BY F2_EMISSAO,F2_VEND1, A3_XPCOMIS , A3_NOME, B1_GRUPO ,A3_FORNECE, A3_LOJA , A3_COM01 , A3_COM02 , A3_COM03 , A3_COM04 , A3_COM05                                                                           " + CRLF

	Next

	cQuery += " ORDER BY F2_VEND1, B1_GRUPO	                                                                                                                                                                                        " + CRLF

	memowrit("CERFIN09V3.sql",cquery)

	TCQUERY cQuery ALIAS (cAlias) NEW

	DbSelectArea( cAlias )
	DbGoTop()
	oReport:SetMeter((cAlias)->(RecCount()))
	
	cEmissao := (cAlias)->EMISSAO
	cCodVend := (cAlias)->VEND
	cDesVEn	 := (cAlias)->NOMEVEND
	cCodFor := (cAlias)->A3_FORNECE
	cCodLoj := (cAlias)->A3_LOJA
	nIr		 := 0
	nTot	 := 0
	nCom	 := 0

	cIrF	 := POSICIONE("SA2",1,XFILIAL("SA2")+(cAlias)->A3_FORNECE+(cAlias)->A3_LOJA,"A2_CALCIRF")

	oSecao1:Init()

	While !Eof()

		IF cCodVend <> (cAlias)->VEND
			//oSecao1:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao
			//oSecao1:Init()

			IF ALLTRIM(cIrF) == "1"

				nIr		 += IIF(nCom*(_nIr/100)<11,0,nCom*(_nIr/100) )

			ENDIF
			
			oSecao1:Cell("F2_EMISSAO"):SetValue(STOD(cEmissao))
			//oSecao1:Cell("F2_EMISSAO"):SetValue(cEmissao)
			oSecao1:Cell("F2_VEND1"):SetValue(cCodVend)
			oSecao1:Cell("A3_NOME"):SetValue(cDesVEn)
			oSecao1:Cell("A3_FORNECE"):SetValue(cCodFor)
			oSecao1:Cell("A3_LOJA"):SetValue(cCodLoj)
			oSecao1:Cell("TOTAL"):SetValue(nTot)
			oSecao1:Cell("VLCOMIS"):SetValue(nCom)
			oSecao1:Cell("VLIR"):SetValue(nIr)
			oSecao1:Cell("VLLIQ"):SetValue(nCom-nIr)

			oSecao1:PrintLine()
			//oSecao1:Finish()

			nIr		 := 0
			nTot	 := 0
			nCom	 := 0
			cEmissao := (cAlias)->EMISSAO
			cCodVend := (cAlias)->VEND
			cDesVEn	 := (cAlias)->NOMEVEND
			cCodFor := (cAlias)->A3_FORNECE
			cCodLoj := (cAlias)->A3_LOJA
			cIrF	 := POSICIONE("SA2",1,XFILIAL("SA2")+(cAlias)->A3_FORNECE+(cAlias)->A3_LOJA,"A2_CALCIRF")

		ENDIF

		IF cCodVend == (cAlias)->VEND

			nTot	 += (cAlias)->TOTAL
			nCom	 += (cAlias)->VLCOMIS

		ENDIF
		
		cEmissao := (cAlias)->EMISSAO
		cCodVend := (cAlias)->VEND
		cDesVEn	 := (cAlias)->NOMEVEND
		cCodFor := (cAlias)->A3_FORNECE
		cCodLoj := (cAlias)->A3_LOJA
		DbSkip()

		IF Eof()

			IF ALLTRIM(cIrF) == "1"

				nIr		 += IIF(nCom*(_nIr/100)<11,0,nCom*(_nIr/100) )

			ENDIF
			oSecao1:Cell("F2_EMISSAO"):SetValue(STOD(cEmissao))
			//oSecao1:Cell("F2_EMISSAO"):SetValue(cEmissao)
			oSecao1:Cell("F2_VEND1"):SetValue(cCodVend)
			oSecao1:Cell("A3_NOME"):SetValue(cDesVEn)
			oSecao1:Cell("A3_FORNECE"):SetValue(cCodFor)
			oSecao1:Cell("A3_LOJA"):SetValue(cCodLoj)
			oSecao1:Cell("TOTAL"):SetValue(nTot)
			oSecao1:Cell("VLCOMIS"):SetValue(nCom)
			oSecao1:Cell("VLIR"):SetValue(nIr)
			oSecao1:Cell("VLLIQ"):SetValue(nCom-nIr)

			oSecao1:PrintLine()
			//oSecao1:Finish()

			nIr		 := 0
			nTot	 := 0
			nCom	 := 0
			cEmissao := (cAlias)->EMISSAO
			cCodVend := (cAlias)->VEND
			cDesVEn	 := (cAlias)->NOMEVEND
			cCodFor := (cAlias)->A3_FORNECE
			cCodLoj := (cAlias)->A3_LOJA
			cIrF	 := POSICIONE("SA2",1,XFILIAL("SA2")+(cAlias)->A3_FORNECE+(cAlias)->A3_LOJA,"A2_CALCIRF")

		ENDIF


	EndDo

	(cAlias)->(DbCloseArea())


	oSecao1:Finish()


Return Nil
/*/{Protheus.doc} COMISV02
//TODO Descrição auto-gerada.
@author Manoel Nésio
@since 02/09/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function RptPrtV2( oReport, cAlias)

	Local lRet 		:= .T.
	Local oSecao1 	:= oReport:Section(1)
	//Local oSecao2 	:= oReport:Section(2)

	Local cCodVend	:= ''
	Local lCabec	:= .T.
	Local cQuery 	:= ""
	Local cEol 		:= CHR(13) + CHR(10)

	Local _cClass  :=	ALLTRIM(aRet[8])
	Local _cProd   :=	ALLTRIM(aRet[9])

	aEmps	:= Strtokarr2(aRet[10] , ";" , .T.)

	_dData1	:=	aRet[1]
	_dData2 :=	aRet[2]
	_cVend1 :=	aRet[3]
	_cVend2 :=	aRet[4]
	_nTipo  :=	aRet[5]
	//_dTit1 	:=	aRet[5]
	//_dTit2	:=	aRet[6]

	cQuery := ""

	For i:=1 to len (aEmps)
		//Soma os dados por unidade de negócio

		IF i > 1

			cQuery += "UNION ALL" + cEol

		Endif

	cQuery += " SELECT                                                                                                                                                                                                             " + CRLF
	cQuery += " 	"+STRZERO(VAL(aEmps[i]),2)+" EMPRESA, F2_EMISSAO,F2_FILIAL,F2_VEND1 VEND , A3_XMAT XMAT, A3_NOME NOMEVEND,A3_FORNECE, A3_LOJA ,F2_EMISSAO EMISSAO,                                                             " + CRLF
	cQuery += " 	(F2_DOC + '-' + F2_SERIE) DOCSERIE,D2_COD PRODUTO, B1_DESC DESCRI, (F2_CLIENTE + ' ' + A1_NREDUZ) CLIENTE, B1_GRUPO GRUPO ,                                                                                    " + CRLF
	cQuery += " 		CASE                                                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN A3_COM01                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN A3_COM02                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN A3_COM03                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN A3_COM04                                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN A3_COM05                                                                                                                                                                   " + CRLF
	cQuery += " 		END AS XPCOMIS,		                                                                                                                                                                                       " + CRLF
	cQuery += " 	D2_TOTAL TOTAL,                                                                                                                                                                                                " + CRLF
	cQuery += " 		CASE                                                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN (D2_TOTAL*(A3_COM01/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN (D2_TOTAL*(A3_COM02/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN (D2_TOTAL*(A3_COM03/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN (D2_TOTAL*(A3_COM04/100))                                                                                                                                                  " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN (D2_TOTAL*(A3_COM05/100))                                                                                                                                                  " + CRLF
	cQuery += " 		END AS VLCOMIS                                                                                                                                                                                             " + CRLF
	cQuery += " FROM SF2"+STRZERO(VAL(aEmps[i]),2)+"0 SF2 (NOLOCK)                                                                                                                                                                 " + CRLF
	cQuery += " 		LEFT JOIN SD2"+STRZERO(VAL(aEmps[i]),2)+"0 SD2 (NOLOCK) ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND SD2.D_E_L_E_T_ = ''     " + CRLF
	cQuery += " 		LEFT JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''                                                                                      " + CRLF
	cQuery += " 		LEFT JOIN " + RetSqlName("SA3") + " SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = ''                                                                                                              " + CRLF
	cQuery += " 		LEFT JOIN SB1"+STRZERO(VAL(aEmps[i]),2)+"0 SB1 (NOLOCK) ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ''                                                                               						   " + CRLF
	cQuery += " WHERE F2_EMISSAO BETWEEN '"+DTOS(_dData1)+"' AND '"+DTOS(_dData2)+"'                                                                                                                                               " + CRLF
	cQuery += " 	AND F2_VEND1 BETWEEN '"+_cVend1+"' AND '"+_cVend2+"'                                                                                                                                                           " + CRLF
	cQuery += "     AND F2_DUPL <> ''                                                                                                                                                                                              " + CRLF
	cQuery += " 	AND F2_TIPO = 'N'                                                                                                                                                                                              " + CRLF
	cQuery += " 	AND F2_CLIENTE <> '062686'                                                                                                                                                                                     " + CRLF

	If STRZERO(VAL(aEmps[i]),2) <> "01"

	cQuery += " AND F2_FILIAL = B1_FILIAL  " + CRLF

	ENDIF

	IF aRet[6] == "1"

	cQuery += "	AND A3_TIPO = 'P' " + CRLF

	ELSEIF aRet[6] == "2"

	cQuery += "	AND A3_TIPO <> 'P' " + CRLF

	ENDIF
	cQuery += "	AND SF2.D_E_L_E_T_ = '' " + CRLF
	cQuery += " GROUP BY F2_EMISSAO,F2_FILIAL,F2_VEND1 , A3_XMAT , A3_NOME ,A3_FORNECE, A3_LOJA ,F2_EMISSAO ,                                                                                                                      " + CRLF
	cQuery += " 	F2_DOC + '-' + F2_SERIE,D2_COD, B1_DESC, F2_CLIENTE + ' ' + A1_NREDUZ, B1_GRUPO ,                                                                                                                              " + CRLF	
	cQuery += " 	B1_GRUPO,A3_COM01,A3_COM02,A3_COM03,A3_COM04,A3_COM05,D2_TOTAL                                                                                                                                                 " + CRLF
	cQuery += " UNION ALL                                                                                                                                                                                                          " + CRLF
	cQuery += " SELECT                                                                                                                                                                                                                 " + CRLF
	cQuery += " 	"+STRZERO(VAL(aEmps[i]),2)+" EMPRESA, F2_EMISSAO,F2_FILIAL, F2_VEND1, A3_XMAT, A3_NOME,A3_FORNECE, A3_LOJA, F1_DTDIGIT F2_EMISSAO,                                                                                 " + CRLF
	cQuery += " 	(F1_DOC +'-' + F1_SERIE) DOCSERIE, D1_COD D2_COD, B1_DESC, (F1_FORNECE + ' ' + A1_NREDUZ) CLIENTE, B1_GRUPO, 		                                                                                               " + CRLF
	cQuery += " 		CASE                                                                                                                                                                                                           " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN A3_COM01                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN A3_COM02                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN A3_COM03                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN A3_COM04                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN A3_COM05                                                                                                                                                                       " + CRLF
	cQuery += " 		END AS A3_XPCOMIS,                                                                                                                                                                                             " + CRLF
	cQuery += " 	(D1_TOTAL*-1) D2_TOTAL,                                                                                                                                                                                            " + CRLF
	cQuery += " 		CASE	                                                                                                                                                                                                       " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCE' THEN (D1_TOTAL*(A3_COM01/100))*-1                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNBB' THEN (D1_TOTAL*(A3_COM02/100))*-1                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRN' THEN (D1_TOTAL*(A3_COM03/100))*-1                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNRI' THEN (D1_TOTAL*(A3_COM04/100))*-1                                                                                                                                                   " + CRLF
	cQuery += " 			WHEN B1_GRUPO = 'UNCA' THEN (D1_TOTAL*(A3_COM05/100))*-1                                                                                                                                                   " + CRLF
	cQuery += " 		END AS VLCOMIS                                                                                                                                                                                                 " + CRLF
	cQuery += " FROM SD1"+STRZERO(VAL(aEmps[i]),2)+"0 SD1 (NOLOCK)                                                                                                                                                                     " + CRLF
	cQuery += " 		INNER JOIN SF2"+STRZERO(VAL(aEmps[i]),2)+"0 SF2 (NOLOCK) ON F2_DOC = D1_NFORI AND F2_SERIE = D1_SERIORI AND F2_FILIAL = D1_FILIAL AND SF2.D_E_L_E_T_ = ''                                                      " + CRLF
	cQuery += " 		INNER JOIN SF1"+STRZERO(VAL(aEmps[i]),2)+"0 SF1 (NOLOCK) ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND D1_FILIAL = D1_FILIAL AND SF1.D_E_L_E_T_ =''         " + CRLF
	cQuery += " 		INNER JOIN "+RetSqlName('SA3')+" SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = ''                                                                                                                     " + CRLF
	cQuery += " 		INNER JOIN SB1"+STRZERO(VAL(aEmps[i]),2)+"0 SB1 (NOLOCK) ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ = ''                                                                                                            " + CRLF
	cQuery += " 		INNER JOIN "+RetSqlName('SA1')+" SA1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''                                                                                             " + CRLF
	cQuery += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(_dData1)+"' AND '"+DTOS(_dData2)+"'                                                                                                                                                   " + CRLF
	cQuery += "   	AND F2_VEND1 BETWEEN '"+_cVend1+"' AND '"+_cVend2+"'                                                                                                                                                               " + CRLF
	cQuery += "   	AND F2_CLIENTE <> '062686' 																																														   " + CRLF //Não considera comissão para Magisfood
	cQuery += "   	AND F1_FORNECE <> '062686' 																																														   " + CRLF //Não considera comissão para Magisfood
	cQuery += " 	AND F1_TIPO = 'D'                                                                                                                                                                                                  " + CRLF
	cQuery += "   	AND D1_TP IN('PA','RV')                                                                                                                                                                                            " + CRLF
	cQuery += "   	AND D1_NFORI <> ' '                                                                                                                                                                                                " + CRLF
	cQuery += " 	AND F1_DUPL <> ''                                                                                                                                                                                                  " + CRLF

	If STRZERO(VAL(aEmps[i]),2) <> "01"

	cQuery += " 	AND F2_FILIAL = B1_FILIAL 																																														   " + CRLF

	ENDIF

	IF aRet[6] == "1"

	cQuery += "   	AND  A3_TIPO = 'P' 																																																   " + CRLF

	ELSEIF aRet[6] == "2"

	cQuery += "   	AND  A3_TIPO <> 'P' 																																															   " + CRLF

	ENDIF

	Next

	cQuery += "		AND SD1.D_E_L_E_T_ = ''                                                                                                                                                                                            " + CRLF
	cQuery += "	ORDER BY B1_GRUPO, F2_VEND1,F2_EMISSAO                                                                                                                                                                                 " + CRLF

	memowrit("CERFIN09V2.sql",cquery)

	TCQUERY cQuery ALIAS (cAlias) NEW

	TCSetField( (cAlias), "F2_EMISSAO", "D",  8, 0 )

	DbSelectArea( cAlias )
	DbGoTop()
	oReport:SetMeter((cAlias)->(RecCount()))

	oSecao1:Init()

	While !Eof()

		oSecao1:Cell("EMPRESA"):SetValue(STRZERO((cAlias)->EMPRESA,2))
		oSecao1:Cell("FILIAL"):SetValue((cAlias)->F2_FILIAL)
		oSecao1:Cell("F2_V7END1"):SetValue((cAlias)->VEND)
		oSecao1:Cell("A3_NOME"):SetValue((cAlias)->NOMEVEND)
		oSecao1:Cell("A3_FORNECE"):SetValue((cAlias)->A3_FORNECE)
		oSecao1:Cell("A3_LOJA"):SetValue((cAlias)->A3_LOJA)
		oSecao1:Cell("DOCSERIE"):SetValue((cAlias)->DOCSERIE)

		If _cClass == "1" //Classe

			oSecao1:Cell("B1_GRUPO"):SetValue((cAlias)->GRUPO)

			If _cProd == "1" //Produto

				oSecao1:Cell("D2_COD"):SetValue((cAlias)->PRODUTO)
				oSecao1:Cell("B1_DESC"):SetValue((cAlias)->DESCRI)

			Endif

		Endif

		oSecao1:Cell("D2_TOTAL"):SetValue((cAlias)->TOTAL)
		oSecao1:Cell("A3_XPCOMIS"):SetValue((cAlias)->XPCOMIS)
		oSecao1:Cell("VLCOMIS"):SetValue((cAlias)->VLCOMIS)

		oSecao1:PrintLine()

		DbSkip()

	EndDo

	(cAlias)->(DbCloseArea())


	oSecao1:Finish()

Return Nil
