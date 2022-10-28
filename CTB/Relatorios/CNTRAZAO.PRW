#Include "TOPCONN.CH"
#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

/*/{Protheus.doc} CNTRAZAO
Relatório de Razão de Contabilidade
@author thomas.galvao
@since 10/08/2017
@version 1.1
@type function
/*/
User Function CNTRAZAO()
	Local cQuery	:= ""
	Local cPerg		:= "XCNTRAZAO"
	
	CriaPerg(cPerg)
	If Pergunte(cPerg, .T.)	
		
		cQuery	:= "SELECT CONVERT(VARCHAR(10),CONVERT(DATETIME,CT2_DATA),103) AS CT2_DATA, "
		cQuery	+= " 	CT2_DEBITO AS 'Conta_Debito'	, CT2_CREDIT AS 'Conta_Credito'		, CT1_DESC01				, CT2_CCD AS 'CC_Debito'		, CT2_CCC As 'CC_Credito',"
		cQuery	+= " 	CT2_CLVLDB AS 'Classe_Debito'	, CT2_CLVLCR AS 'Classe_Credito'	, CT2_ITEMD AS 'Item_Debito', CT2_ITEMC AS 'Item_Credito'	, CT2_HIST, CT2_VALOR AS 'Debito',"
		cQuery	+= " 	0 As 'Credito'					, CT2_LOTE							, CT2_SBLOTE				, CT2_DOC						, CT2_LINHA, CT2_LP, CT2_SEQLAN, "
		cQuery	+= "	CT2_EMPORI, CT2_FILORI, CT2_ORIGEM"
		cQuery	+= " FROM " + RetSqlName('CT2') + " CT2(NOLOCK)" 
		cQuery	+= " 	INNER JOIN " + RetSqlName('CT1') + " CT1 (NOLOCK) On CT2_DEBITO = CT1_CONTA AND CT1_FILIAL = '" + xFilial("CT1") +"' AND CT1.D_E_L_E_T_='' "
		cQuery	+= " 	LEFT JOIN " + RetSqlName('CTT') + " CTT (NOLOCK) On CT2_CCD = CTT_CUSTO AND CTT_FILIAL = '" + xFilial("CTT") +"' AND CTT.D_E_L_E_T_='' "
		
		If Len(Trim(MV_PAR03))>0
			cQuery	+= " WHERE CT1_CONTA LIKE ('"+StrTran(StrTran(Trim(MV_PAR03), " ", ""),",","', '")+"%') "
		Else
			cQuery	+= " WHERE CT1_CONTA BETWEEN '"+MV_PAR04+"' And '"+MV_PAR05+"'  "
		EndIf
		
		cQuery	+= " AND CT2_CCD BETWEEN '" + MV_PAR08	+ "' AND '" + MV_PAR09 + "'  "
		cQuery	+= " AND CT1_FILIAL = '" + xFilial("CT1") + "' "
		cQuery	+= " AND CT2_FILIAL BETWEEN '" + MV_PAR06	+ "' AND '" + MV_PAR07 + "'  "
		cQuery	+= " AND CT2_DATA 	BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' "
		cQuery	+= " AND CT2.D_E_L_E_T_<>'*'"
		
		cQuery	+= " UNION"
		
		cQuery	+= " SELECT CONVERT(VARCHAR(10),CONVERT(DATETIME,CT2_DATA),103) AS CT2_DATA,"
		cQuery	+= " 	CT2_DEBITO 	As 'Conta_Debito'	, CT2_CREDIT AS 'Conta_Credito'		, CT1_DESC01					, CT2_CCD AS 'CC_Debito'		, CT2_CCC AS 'CC_Credito',"
		cQuery	+= " 	CT2_CLVLDB 	AS 'Classe_Debito'	, CT2_CLVLCR AS 'Classe_Credito'	, CT2_ITEMD AS 'Item_Debito'	, CT2_ITEMC AS 'Item_Credito'	, CT2_HIST, 0 AS 'Debito',"
		cQuery	+= " 	CT2_VALOR 	AS 'Credito'		, CT2_LOTE							, CT2_SBLOTE					, CT2_DOC						, CT2_LINHA, CT2_LP, CT2_SEQLAN, " 
		cQuery	+= " 	CT2_EMPORI, CT2_FILORI,CT2_ORIGEM"
		cQuery	+= " FROM " + RetSqlName('CT2') + " CT2(NOLOCK)"
		cQuery	+= " 	INNER JOIN " + RetSqlName('CT1') + " CT1(NOLOCK) ON CT2_CREDIT = CT1_CONTA AND CT1_FILIAL = '" + xFilial("CT1") + "' AND CT1.D_E_L_E_T_= '' "
		cQuery	+= " 	LEFT JOIN " + RetSqlName('CTT') + " CTT(NOLOCK) On CT2_CCC = CTT_CUSTO AND CTT_FILIAL = '" + xFilial("CTT") +"' AND CTT.D_E_L_E_T_='' "
		
		If Len(AllTrim(MV_PAR03)) > 0
			cQuery	+= " WHERE CT1_CONTA LIKE ('"+StrTran(StrTran(AllTrim(MV_PAR03), " ", ""),",","', '")+"%') "
		Else
			cQuery	+= " WHERE 	CT1_CONTA BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'  "
		EndIf
		
		cQuery	+= " AND CT2_CCC BETWEEN '" + MV_PAR08	+ "' AND '" + MV_PAR09 + "'  "
		cQuery	+= " 	AND CT1_FILIAL	= '" + xFilial("CT1") + "' "
		cQuery	+= " 	AND CT2_FILIAL 	BETWEEN '" + MV_PAR06 + "' AND '"+ MV_PAR07 + "'  "
		cQuery	+= " 	AND CT2_DATA 	BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' "
		cQuery	+= " 	AND CT2.D_E_L_E_T_<>'*'"
		cQuery	+= " ORDER BY CT2_DEBITO, CT2_DATA"
		
		cQuery	:= ChangeQuery(cQuery)
		
		Processa({ || CNTRAZAO2(cQuery)})
	EndIf
	
	U_MCERLOG()	
Return  

/*/{Protheus.doc} CNTRAZAO2
Impressão do Relatório.EXPDADOS*
@author thomas.galvao
@since 10/08/2017
@version 1.1
@param cQuery, characters, Query.
@type function
/*/
Static Function CNTRAZAO2(cQuery)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFiLename	:= "CntRazao_" + cTipoEmp//"C:\TEMP\RAZAO_"+Trim(CUSERNAME)+"_"+DToS(dDATA)+"_"+cTipoEmp+"_"+iif(Empty(MV_PAR03),"DE_"+AllTrim(MV_PAR04)+"_ATE_"+AllTrim(MV_PAR05),AllTrim(MV_PAR03))+".DBF"	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() //oObjExcel:cFile := "C:\TEMP"
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo("Relatório Conta Razão")
	oObjExcel:OpenClasExcel()
	
	//oObjExcel:lTotalNum := .T. //oObjExcel:SetTotNum(.T.)
	oObjExcel:cQuery := cQuery
	oObjExcel:SetNomePlanilha("Conta Razão De " + AllTrim(MV_PAR04) + " Ate " + AllTrim(MV_PAR05))
	oObjExcel:PrintXml()
	
	oObjExcel:CloseClasExcel()
Return  

/*/{Protheus.doc} CriaPertg
Cria Grupo de Perguntas.
@author thomas.galvao
@since 10/08/2017
@version 1.1
@param cPerg, characters, Grupo de Perguntas.
@type function
/*/
Static Function CriaPerg(cPerg)
	PutSx1(cPerg, "01","Data de"			,"Data de"			,"Data de"			,"mv_ch1","D",TamSx3("CT2_DATA"	)[1],0,0,"G","","   ","","","MV_PAR01")
	PutSx1(cPerg, "02","Data Até"			,"Data Até"			,"Data Até"			,"mv_ch2","D",TamSx3("CT2_DATA"	)[1],0,0,"G","","   ","","","MV_PAR02")
	PutSx1(cPerg, "03","Conta Específica"	,"Conta Específica"	,"Conta Específica"	,"mv_ch3","C",TamSx3("CT1_CONTA")[1],0,0,"G","","CT1","","","MV_PAR03")
	PutSx1(cPerg, "04","Conta De"			,"Conta De"			,"Conta De"			,"mv_ch4","C",TamSx3("CT1_CONTA")[1],0,0,"G","","CT1","","","MV_PAR04")
	PutSx1(cPerg, "05","Conta Até"			,"Conta Até"		,"Conta Até"		,"mv_ch5","C",TamSx3("CT1_CONTA")[1],0,0,"G","","CT1","","","MV_PAR05")
	PutSx1(cPerg, "06","Filial de"			,"Filial de"		,"Filial de"		,"mv_ch6","C",TamSx3("CT1_FILIAL")[1],0,0,"G","","SM0","","","MV_PAR06")
	PutSx1(cPerg, "07","Filial Até"			,"Filial Até"		,"Filial Até"		,"mv_ch7","C",TamSx3("CT1_FILIAL")[1],0,0,"G","","SM0","","","MV_PAR07")
	PutSx1(cPerg, "06","Centro Custo de"			,"Centro Custo de"		,"Centro Custo de"		,"mv_ch8","C",TamSx3("CTT_CUSTO")[1],0,0,"G","","CTT","","","MV_PAR08")
	PutSx1(cPerg, "07","Centro Custo Até"			,"Centro Custo Até"		,"Centro Custo Até"		,"mv_ch9","C",TamSx3("CTT_CUSTO")[1],0,0,"G","","CTT","","","MV_PAR09")
Return
