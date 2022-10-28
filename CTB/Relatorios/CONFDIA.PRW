//------------------------------------------------------------------------------------//
//Empresa...: CERATTI
//Projeto...: RELATÓRIOS CONTABIL
//Funcao....: CONFDIA
//Autor.....: EDSON SHIDEKI KOKADO	
//Data......: 11/06/2008
//Uso.......: RELATÓRIO DE CONFERENCIA DIARIA CONTABIL
//Versao....: 8.11
//------------------------------------------------------------------------------------//


#INCLUDE "TOPCONN.CH"
//#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


*----------------------------------------------------------------------------*
USER FUNCTION CONFDIA()
*----------------------------------------------------------------------------*
	PRIVATE cDATAInicio	:= DATE()
	PRIVATE cDATAFim	:= DATE()
	PRIVATE dDATA		:= dDATABASE
	PRIVATE cSERIEInicio:= SPACE(3)
	PRIVATE cSERIEFim	:= 'ZZZ'
	PRIVATE cNFInicio	:= SPACE(9)
	PRIVATE cNFFim		:= 'ZZZZZZZZZ'
	PRIVATE nOPCA	:= 2
	PRIVATE aCOLS	:= {}

	PRIVATE cPath       := ""
	PRIVATE cFileName   := ""
	PRIVATE cTipoEmp    := ""
	PRIVATE cDestino    := ""
	PRIVATE aTpFile		:= {"1-Não Abrir C/ Excel", "2-Abrir Com Excel"}
	PRIVATE oTpFile
	PRIVATE cTpFile

	WHILE .T.

		cPATH:= 'C:\TEMP\'
		IF CEMPANT = '01'
			cTipoEmp:= 'OMA'
		ELSEIF CEMPANT = '02'
			cTipoEmp:= 'CER'
		ELSEIF CEMPANT = '03'
			cTipoEmp:= 'BM'
		ELSE
			cTipoEmp:= 'OUT'
		ENDIF
		cFileName   := "CONFDIARIA_"+TRIM(CUSERNAME)+DTOS(dDATA)+cTipoEmp+".DBF"
		cDestino	:= PADR(cPATH+cFileName, 100)

		nOPCA	:= 2
		
		@ 10,0 TO 200,360  DIALOG oDlg3  TITLE OemToAnsi("Relatório de Conferencia Diária - Contábil")
		nLin:= 40
		@ nLin,010 SAY OemToAnsi("Data de: ")  SIZE 055,007
		@ nLin,065 GET cDATAInicio SIZE 040,007
		@ nLin,113 SAY OemToAnsi("ate")  SIZE 010,007
		@ nLin,125 GET cDATAFim SIZE 040,007
		nLin:= nLin+10		
		@ nLin,010 SAY OemToAnsi("Serie de: ")  SIZE 055,007
		@ nLin,065 GET cSERIEInicio SIZE 040,007
		@ nLin,113 SAY OemToAnsi("ate")  SIZE 010,007
		@ nLin,125 GET cSERIEFim SIZE 040,007
		nLin:= nLin+10		
		@ nLin,010 SAY OemToAnsi("Nota Fiscal de: ")  SIZE 055,007
		@ nLin,065 GET cNFInicio SIZE 040,007
		@ nLin,113 SAY OemToAnsi("ate")  SIZE 010,007
		@ nLin,125 GET cNFFim SIZE 040,007
		nLin:= nLin+10		
		@ nLin,010 SAY OemToAnsi("Abrir Excel:")   SIZE 050,007 OF oDlg3 PIXEL
		&&@ nLin,065 COMBOBOX oTpFile VAR cTpFile ITEMS aTpFile WHEN(ApOleClient("MsExcel")) SIZE 050,007 OF oDlg3 PIXEL
		@ nLin,065 COMBOBOX oTpFile VAR cTpFile ITEMS aTpFile SIZE 050,007 OF oDlg3 PIXEL
		nLin:= nLin+10		
		@ nLin,010 SAY OemToAnsi("Destino: ")  SIZE 055,007
		@ nLin,065 GET cDestino SIZE 100,007
	
		ACTIVATE DIALOG oDlg3 ON INIT EnchoiceBar(oDlg3,{||nOPCA:=1,oDlg3:End() },{||NOPCA:=2,oDlg3:End() }) CENTERED
	
		IF nOPCA == 2
			Exit
		ENDIF

//		PROCESSA({CONFD01()})
//		CONFDIA01()
        MsAguarde( { || CONFD01() } , "Aguarde 1/2" )
	
	ENDDO

U_MCERLOG()	
RETURN  // Fim REL_AV_VENDAS

*----------------------------------------------------------------------------*
STATIC FUNCTION CONFD01()
*----------------------------------------------------------------------------*
	LOCAL cQUERY	:= ""
	LOCAL X			:= 1
/*    

    cQUERY	:= " SELECT "
	cQUERY	+= " 	F1_DTDIGIT, F1_RECBMTO, F1_EMISSAO, F1_SERIE, F1_DOC, D1_CF, F1_FORNECE, F1_LOJA,   "
	cQUERY	+= " 	CASE WHEN D1_TP  IN ('PA', 'RV') AND A1_NOME IS NOT NULL THEN A1_NOME ELSE A2_NOME END AS NOME, "   
	                          **********************************************  altercao    15/10/15  CLAUDIO AMBROINI
	cQUERY	+= "	F1_COND, E4_DESCRI, "
	cQUERY  += "  	CASE WHEN SE2.E2_FATURA = '' THEN SE2.E2_VENCTO ELSE SE2F.E2_VENCTO END E2_VENCTO  , "
	cQUERY	+= " 	F1_VALMERC, SUM(D1_VALICM) AS ICMS, SUM(D1_VALIPI) AS IPI,   "
	cQUERY	+= " 	SUM(D1_VALIMP5) AS COFINS, SUM(D1_VALIMP6) AS PIS,  SUM(D1_ICMSRET) AS ICMSRET, "
	cQUERY	+= " 	F1_DESPESA, F1_DESCONT, F1_VALCOFI, F1_VALPIS, F1_VALCSLL, F1_IRRF, F1_INSS, F1_ISS ,  "
	cQUERY	+= " 	F1_VALMERC-F1_DESPESA-F1_VALCOFI-F1_VALPIS-F1_VALCSLL-F1_DESCONT-F1_IRRF-F1_INSS-F1_ISS AS TOTAPAGAR  "
	cQUERY	+= " FROM  "+RetSqlName('SF1')+" SF1 "
	cQUERY	+= " INNER JOIN "+RetSqlName('SD1')+" SD1 ON "
	cQUERY	+= " F1_SERIE=D1_SERIE AND F1_DOC=D1_DOC AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA "
	cQUERY	+= " LEFT JOIN "+RetSqlName('SE2')+" SE2 (NOLOCK) ON "
	cQUERY	+= " F1_SERIE=SE2.E2_PREFIXO AND F1_DOC=SE2.E2_NUM AND F1_FORNECE=SE2.E2_FORNECE AND F1_LOJA=SE2.E2_LOJA AND SE2.E2_PARCELA IN (' ', 'A', '1') "
	cQUERY	+= " LEFT JOIN "+RetSqlName('SA2')+" SA2 (NOLOCK) ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA  "
	cQUERY	+= " LEFT JOIN "+RetSqlName('SA1')+" SA1 (NOLOCK) ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND D1_TP  IN ('PA', 'RV')  "
//	cQUERY	+= " INNER JOIN "+RetSqlName('SA2')+" SA2 ON F1_FORNECE=A2_COD AND F1_LOJA=A2_LOJA "
	cQUERY	+= " INNER JOIN "+RetSqlName('SE4')+" SE4 (NOLOCK) ON F1_COND=E4_CODIGO "
	cQUERY	+= " LEFT JOIN " +RetSqlName("SE2") + "  SE2F (NOLOCK) ON SE2F.D_E_L_E_T_ <> '*' " 
	cQUERY	+= " AND SE2F.E2_FILIAL = SE2.E2_FILIAL 
	cQUERY	+= " AND SE2F.E2_NUM  =  SE2.E2_FATURA AND SE2F.E2_PREFIXO = SE2.E2_FATPREF AND SE2F.E2_FORNECE = SE2.E2_FORNECE AND SE2F.E2_LOJA = SE2.E2_LOJA "
	cQUERY	+= " WHERE SF1.D_E_L_E_T_<>'*' AND SD1.D_E_L_E_T_<>'*' "
	cQUERY	+= " AND ISNULL(SE2.D_E_L_E_T_,' ')<>'*' AND ISNULL(SA2.D_E_L_E_T_,' ')<>'*' "
	cQUERY	+= " AND SE4.D_E_L_E_T_<>'*' AND ISNULL(SA1.D_E_L_E_T_,' ')<>'*' "
	cQUERY	+= " AND F1_DTDIGIT BETWEEN '"+dToS(cDATAInicio)+"' AND '"+dToS(cDATAFim)+"' "
	cQUERY	+= " AND F1_SERIE BETWEEN '"+cSERIEInicio+"' AND '"+cSERIEFim+"' "
	cQUERY	+= " AND F1_DOC BETWEEN '"+cNFInicio+"' AND '"+cNFFim+"' "
	cQUERY	+= " GROUP BY  "
	cQUERY	+= " 	F1_RECBMTO, F1_DTDIGIT, F1_EMISSAO, F1_SERIE, F1_DOC, F1_FORNECE,  "
	cQUERY	+= " 	CASE WHEN D1_TP  IN ('PA', 'RV') AND A1_NOME IS NOT NULL THEN A1_NOME ELSE A2_NOME END, "   
	                          ***********************************************  alteracao CLAUDIO AMBROSINI 15/10/17
	cQUERY	+= " 	F1_LOJA, F1_COND, E4_DESCRI, "                                                                                           
	
	cQUERY	+= " 	CASE WHEN SE2.E2_FATURA = '' THEN SE2.E2_VENCTO ELSE SE2F.E2_VENCTO END , "
	
	cQUERY   += " F1_DESCONT, F1_IRRF, F1_INSS, F1_ISS, D1_CF, F1_VALMERC,  "
	cQUERY	+= " 	F1_VALCOFI, F1_VALPIS, F1_VALCSLL , F1_DESPESA, F1_BASIMP5, F1_BASIMP6, D1_CF "
	cQUERY	+= " ORDER BY  "
	cQUERY	+= " 	F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_SERIE, F1_DOC "
	
	cQUERY	:= ChangeQuery(cQUERY)
	TcQuery cQUERY ALIAS QRY NEW 

*/	
    cQUERY	:= " SELECT "
	cQUERY	+= " 	F1_DTDIGIT, F1_RECBMTO, F1_EMISSAO, F1_SERIE, F1_DOC, D1_CF, F1_FORNECE, F1_LOJA,   "
	cQUERY	+= " 	CASE WHEN D1_TIPO  IN ('B', 'D') THEN A1_NOME ELSE A2_NOME END AS NOME, "
	cQUERY	+= "	F1_COND, E4_DESCRI, "
	cQUERY  += "  	CASE WHEN SE2.E2_FATURA = '' THEN SE2.E2_VENCTO ELSE SE2F.E2_VENCTO END E2_VENCTO  , "
	cQUERY	+= " 	F1_VALMERC, SUM(D1_VALICM) AS ICMS, SUM(D1_VALIPI) AS IPI,   "
	cQUERY	+= " 	SUM(D1_VALIMP5) AS COFINS, SUM(D1_VALIMP6) AS PIS,  SUM(D1_ICMSRET) AS ICMSRET, "
	cQUERY	+= " 	F1_DESPESA, F1_DESCONT, F1_VALCOFI, F1_VALPIS, F1_VALCSLL, F1_IRRF, F1_INSS, F1_ISS ,  "
	cQUERY	+= " 	F1_VALMERC-F1_DESPESA-F1_VALCOFI-F1_VALPIS-F1_VALCSLL-F1_DESCONT-F1_IRRF-F1_INSS-F1_ISS AS TOTAPAGAR  "
	cQUERY	+= " FROM  "+RetSqlName('SF1')+" SF1 "
	cQUERY	+= " INNER JOIN "+RetSqlName('SD1')+" SD1 ON "
	cQUERY	+= " F1_SERIE=D1_SERIE AND F1_DOC=D1_DOC AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA "
	cQUERY	+= " LEFT JOIN "+RetSqlName('SE2')+" SE2 (NOLOCK) ON "
	cQUERY	+= " F1_SERIE=SE2.E2_PREFIXO AND F1_DOC=SE2.E2_NUM AND F1_FORNECE=SE2.E2_FORNECE AND F1_LOJA=SE2.E2_LOJA AND SE2.E2_PARCELA IN (' ', 'A', '1') "
	cQUERY	+= " LEFT JOIN "+RetSqlName('SA2')+" SA2 (NOLOCK) ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA  "
	cQUERY	+= " LEFT JOIN "+RetSqlName('SA1')+" SA1 (NOLOCK) ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND D1_TP  IN ('PA', 'RV')  "
//	cQUERY	+= " INNER JOIN "+RetSqlName('SA2')+" SA2 ON F1_FORNECE=A2_COD AND F1_LOJA=A2_LOJA "
	cQUERY	+= " INNER JOIN "+RetSqlName('SE4')+" SE4 (NOLOCK) ON F1_COND=E4_CODIGO "
	cQUERY	+= " LEFT JOIN " +RetSqlName("SE2") + "  SE2F (NOLOCK) ON SE2F.D_E_L_E_T_ <> '*' " 
	cQUERY	+= " AND SE2F.E2_FILIAL = SE2.E2_FILIAL 
	cQUERY	+= " AND SE2F.E2_NUM  =  SE2.E2_FATURA AND SE2F.E2_PREFIXO = SE2.E2_FATPREF AND SE2F.E2_FORNECE = SE2.E2_FORNECE AND SE2F.E2_LOJA = SE2.E2_LOJA "
	cQUERY	+= " WHERE SF1.D_E_L_E_T_<>'*' AND SD1.D_E_L_E_T_<>'*' "
	cQUERY	+= " AND ISNULL(SE2.D_E_L_E_T_,' ')<>'*' AND ISNULL(SA2.D_E_L_E_T_,' ')<>'*' "
	cQUERY	+= " AND SE4.D_E_L_E_T_<>'*' AND ISNULL(SA1.D_E_L_E_T_,' ')<>'*' "
	cQUERY	+= " AND F1_DTDIGIT BETWEEN '"+dToS(cDATAInicio)+"' AND '"+dToS(cDATAFim)+"' "
	cQUERY	+= " AND F1_SERIE BETWEEN '"+cSERIEInicio+"' AND '"+cSERIEFim+"' "
	cQUERY	+= " AND F1_DOC BETWEEN '"+cNFInicio+"' AND '"+cNFFim+"' "
	cQUERY	+= " GROUP BY  "
	cQUERY	+= " 	F1_RECBMTO, F1_DTDIGIT, F1_EMISSAO, F1_SERIE, F1_DOC, F1_FORNECE,  "
	cQUERY	+= " 	CASE WHEN D1_TIPO  IN ('B', 'D') THEN A1_NOME ELSE A2_NOME END, "
	cQUERY	+= " 	F1_LOJA, F1_COND, E4_DESCRI, "                                                                                           
	
	cQUERY	+= " 	CASE WHEN SE2.E2_FATURA = '' THEN SE2.E2_VENCTO ELSE SE2F.E2_VENCTO END , "
	
	cQUERY   += " F1_DESCONT, F1_IRRF, F1_INSS, F1_ISS, D1_CF, F1_VALMERC,  "
	cQUERY	+= " 	F1_VALCOFI, F1_VALPIS, F1_VALCSLL , F1_DESPESA, F1_BASIMP5, F1_BASIMP6, D1_CF "
	cQUERY	+= " ORDER BY  "
	cQUERY	+= " 	F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_SERIE, F1_DOC "
	
	cQUERY	:= ChangeQuery(cQUERY)
	TcQuery cQUERY ALIAS QRY NEW

	TCSetField("QRY","F1_DTDIGIT","D")
	TCSetField("QRY","F1_RECBMTO","D")
	TCSetField("QRY","F1_EMISSAO","D")
	TCSetField("QRY","E2_VENCTO","D")
	TCSetField("QRY","F1_VALMERC","N", 15,2)
	TCSetField("QRY","ICMS","N", 15,2)
	TCSetField("QRY","IPI","N", 15,2)
	TCSetField("QRY","COFINS","N", 15,2)
	TCSetField("QRY","PIS","N", 15, 2)
	TCSetField("QRY","ICMSRET","N", 15, 2)
	TCSetField("QRY","F1_DESPESA","N", 15, 2)
	TCSetField("QRY","F1_DESCONT","N", 15, 2)
	TCSetField("QRY","F1_VALCOFI","N", 15, 2)
	TCSetField("QRY","F1_VALPIS","N", 15, 2)
	TCSetField("QRY","F1_VALCSLL","N", 15, 2)
	TCSetField("QRY","F1_IRRF","N", 15, 2)
	TCSetField("QRY","F1_INSS","N", 15, 2)
	TCSetField("QRY","F1_ISS","N", 15, 2)
	TCSetField("QRY","TOTAPAGAR","N", 15, 2)
	
//	PROCESSA({CONFD02()})
    
    MsAguarde( { || CONFD03(cQUERY) } , "Aguarde 2/2" )
	
	QRY->(DBCLOSEAREA())
	
RETURN   // GERAR_REL_AV_VENDAS

*----------------------------------------------------------------------------*
STATIC FUNCTION CONFD02()
*----------------------------------------------------------------------------*

Local aArea		:= GetArea()

dbSelectArea('QRY') // Referencia ao Alias da Query
COPY TO (cFileName)
RestArea( aArea )

// Copia o arquivo do server para a maquina do cliente.
If !U_MLSCpyFile(cFileName,cDestino)         
	MsgStop("Nao foi possivel gerar o arquivo."+CHR(13)+CHR(10)+cDestino+CHR(13)+CHR(10)+" Verifique se está sendo utilizado.")
ELSE                                                            
	MsgBox("Foi gerado arquivo com detalhes de nome "+CHR(13)+CHR(10)+cDestino,"Atenção","ALERT")    
	
    
	If ApOleClient("MsExcel") .AND. SUBSTRING(cTpFile,1,1)=='2'
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(cDestino) 
		oExcelApp:SetVisible(.T.)
	EndIf                             
	
Endif                                 


FERASE(cFileName) // limpa o arquivo do server.

RETURN  // GERADBF1
    

Static Function CONFD03(cQuery)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFiLename	:= "RELATÓRIO DE CONFERENCIA DIARIA CONTABIL  " + cTipoEmp
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo("RELATÓRIO DE CONFERENCIA DIARIA CONTABIL")
	oObjExcel:OpenClasExcel()
	
	//oObjExcel:lTotalNum := .T. //oObjExcel:SetTotNum(.T.)
	oObjExcel:cQuery := cQuery
	oObjExcel:SetNomePlanilha("RELATÓRIO DE CONFERENCIA DIARIA CONTABIL" )
	oObjExcel:PrintXml()
	
	oObjExcel:CloseClasExcel()
Return  
