#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} CTBR0004
Relatorio de despesas contabeis
@author 	Manoel Nesio - Fabritech
@since 		10/03/2020
@version 	1.0 
@return 	return, Nil
/*/
user function CTBR0004()
    
    Local aParamBox	:= {}
    Local aDespesas := {}
    Local dDataDe	:= FirstDate( MonthSub( Date(), 1 ))
    Local dDataAte	:= LastDate(  MonthSub( Date(), 1 ))
    Private cTitulo := "Relatorio Despesas Contabeis"
    Private cAlias 		:= GetNextAlias()


    aAdd(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.})
    aAdd(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})

    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)

        Processa({|| GetQuery(@aDespesas,MV_PAR01, MV_PAR02)  },"Carregando Dados a Imprimir...")
        Processa({|| PrintExcel(aDespesas) },"Imprimindo Relatorio em Excel...")

    Endif
    U_MCERLOG()

Return()
//-------------------------------------------------------------------
/*/{Protheus.doc} function
Query do relatorio
@author 	Manoel Nesio - Fabritech
@since 		10/03/2020
@version version
/*/
//-------------------------------------------------------------------                   
Static Function GetQuery(aDespesas,dDataDe, dDataAte)

    Local cAlias 	:= GetNextAlias()
    Local lFirst 	:= .T.

    Local cQryVer	:= ""


    cQryVer+=" SELECT "
    cQryVer+=" 	CASE WHEN CT2_CREDIT = '' THEN CT2_DEBITO ELSE CT2_CREDIT END AS CONTA, "
    cQryVer+=" 	CASE WHEN CT2_CREDIT = '' THEN 'D' ELSE 'C' END AS TIPO, "
    cQryVer+=" 	CT2_EMPORI,EMPRESA,CT2_FILORI, "
    cQryVer+=" 	CASE  "
    cQryVer+=" 		WHEN CT2_EMPORI = '01' AND CT2_FILORI = '01' THEN 'MATRIZ' "
    cQryVer+=" 		WHEN CT2_EMPORI = '01' AND CT2_FILORI = '02' THEN 'VINHEDO' "
    cQryVer+=" 		WHEN CT2_EMPORI = '02' AND CT2_FILORI = '01' THEN 'MATRIZ' "
    cQryVer+=" 		WHEN CT2_EMPORI = '06' AND CT2_FILORI = '01' THEN 'VALINHOS' "
    cQryVer+=" 		WHEN CT2_EMPORI = '07' AND CT2_FILORI = '01' THEN 'SAO PAULO' "
    cQryVer+=" 		WHEN CT2_EMPORI = '07' AND CT2_FILORI = '02' THEN 'RIO DE JANEIRO' "
    cQryVer+=" 		WHEN CT2_EMPORI = '07' AND CT2_FILORI = '03' THEN 'RIO DE JANEIRO 1' "
    cQryVer+=" 		WHEN CT2_EMPORI = '07' AND CT2_FILORI = '04' THEN 'PARANA' "
    cQryVer+=" 		ELSE CT2_FILORI "
    cQryVer+=" 	END NOME_FILIAL, "
    cQryVer+=" 	ANO,MES,DIA,CT2_LOTE,CT2_DOC,CT2_DEBITO,CT2_CREDIT, DEBITO,CREDITO, "
    cQryVer+=" 	CASE WHEN CT2_CREDIT = '' THEN DEBITO ELSE  CREDITO END AS VLR_DC , "
    cQryVer+=" 	CT2_HIST,CT2_CCD ,CT2_CCC "
    cQryVer+=" FROM (	"
    cQryVer+=" 	SELECT  'OMAMORI' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,'' CT2_DEBITO,CT2_CREDIT,  "
    cQryVer+=" 		CASE  "
    cQryVer+=" 			WHEN LEFT(CT2_CREDIT,1) IN ('3') THEN CT2_VALOR "
    cQryVer+=" 			ELSE CT2_VALOR * -1 "
    cQryVer+=" 		END 'CREDITO', "
    cQryVer+=" 		0 'DEBITO',	"
    cQryVer+=" 		CT2_HIST ,CT2_CCD	 ,CT2_CCC "
    cQryVer+=" 	FROM CT2010 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_CREDIT BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_CREDIT <> '' "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'OMAMORI' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA,"
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,CT2_DEBITO,'' CT2_CREDIT, "
    cQryVer+=" 		0 'CREDITO',  "
    cQryVer+=" 		CASE "
    cQryVer+=" 			WHEN LEFT(CT2_DEBITO,1) IN ('3') THEN CT2_VALOR * - 1 "
    cQryVer+=" 			ELSE CT2_VALOR  "
    cQryVer+=" 		END 'DEBITO', "
    cQryVer+=" 		CT2_HIST ,CT2_CCD,CT2_CCC "
    cQryVer+=" 	FROM CT2010 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_DEBITO BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_DEBITO <> '' "
    cQryVer+=" 		AND CT2_CREDIT > 0 "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'CERATTI' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,'' CT2_DEBITO,CT2_CREDIT,  "
    cQryVer+=" 		CASE  "
    cQryVer+=" 			WHEN LEFT(CT2_CREDIT,1) IN ('3') THEN CT2_VALOR "
    cQryVer+=" 			ELSE CT2_VALOR * -1 "
    cQryVer+=" 		END 'CREDITO', "
    cQryVer+=" 		0 'DEBITO',		"
    cQryVer+=" 		CT2_HIST ,CT2_CCD	 ,CT2_CCC "
    cQryVer+=" 	FROM CT2020 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_CREDIT BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_CREDIT <> '' "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'CERATTI' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,CT2_DEBITO,'' CT2_CREDIT, "
    cQryVer+=" 		0 'CREDITO', "
    cQryVer+=" 		CASE "
    cQryVer+=" 			WHEN LEFT(CT2_DEBITO,1) IN ('3') THEN CT2_VALOR * - 1 "
    cQryVer+=" 			ELSE CT2_VALOR  "
    cQryVer+=" 		END 'DEBITO',  "
    cQryVer+=" 		CT2_HIST ,CT2_CCD,CT2_CCC "
    cQryVer+=" 	FROM CT2020 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_DEBITO BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_DEBITO <> '' "
    cQryVer+=" 		AND CT2_CREDIT > 0 "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'TALIS' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,'' CT2_DEBITO,CT2_CREDIT, "
    cQryVer+=" 		CASE  "
    cQryVer+=" 			WHEN LEFT(CT2_CREDIT,1) IN ('3') THEN CT2_VALOR "
    cQryVer+=" 			ELSE CT2_VALOR * -1  "
    cQryVer+=" 		END 'CREDITO', "
    cQryVer+=" 		0 'DEBITO', "
    cQryVer+=" 		CT2_HIST ,CT2_CCD	 ,CT2_CCC "
    cQryVer+=" 	FROM CT2060 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_CREDIT BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_CREDIT <> '' "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'TALIS' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,CT2_DEBITO,'' CT2_CREDIT, "
    cQryVer+=" 		0 'CREDITO', "
    cQryVer+=" 		CASE "
    cQryVer+=" 			WHEN LEFT(CT2_DEBITO,1) IN ('3') THEN CT2_VALOR * - 1 "
    cQryVer+=" 			ELSE CT2_VALOR  "
    cQryVer+=" 		END 'DEBITO',  "
    cQryVer+=" 		CT2_HIST ,CT2_CCD,CT2_CCC "
    cQryVer+=" 	FROM CT2060 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_DEBITO BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_DEBITO <> '' "
    cQryVer+=" 		AND CT2_CREDIT > 0 "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'CLEAN FIELD' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,'' CT2_DEBITO,CT2_CREDIT,  "
    cQryVer+=" 		CASE "
    cQryVer+=" 			WHEN LEFT(CT2_CREDIT,1) IN ('3') THEN CT2_VALOR "
    cQryVer+=" 			ELSE CT2_VALOR * -1  "
    cQryVer+=" 		END 'CREDITO', "
    cQryVer+=" 		0 'DEBITO',		"
    cQryVer+=" 		CT2_HIST ,CT2_CCD	 ,CT2_CCC "
    cQryVer+=" 	FROM CT2070 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_CREDIT BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_CREDIT <> '' "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" 	UNION ALL "
    cQryVer+=" 	SELECT  'CLEAN FIELD' EMPRESA,CT2_EMPORI,CT2_FILORI,SUBSTRING(CT2_DATA,1,4 ) ANO, SUBSTRING(CT2_DATA,5,2 ) MES, SUBSTRING(CT2_DATA,7,4 ) DIA, "
    cQryVer+=" 		CT2_LOTE ,CT2_DOC	 ,CT2_DEBITO,'' CT2_CREDIT, "
    cQryVer+=" 		0 'CREDITO', "
    cQryVer+=" 		CASE  "
    cQryVer+=" 			WHEN LEFT(CT2_DEBITO,1) IN ('3') THEN CT2_VALOR * - 1 "
    cQryVer+=" 			ELSE CT2_VALOR  "
    cQryVer+=" 		END 'DEBITO', "
    cQryVer+=" 		CT2_HIST ,CT2_CCD,CT2_CCC "
    cQryVer+=" 	FROM CT2070 (NOLOCK) CT2 "
    cQryVer+=" 	WHERE CT2_DATA BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer+=" 		AND CT2_DEBITO BETWEEN '3' AND '555' "
    cQryVer+=" 		AND CT2_DEBITO <> '' "
    cQryVer+=" 		AND CT2_CREDIT > 0 "
    cQryVer+=" 		AND CT2.D_E_L_E_T_ = ' ' "
    cQryVer+=" ) AS TMP "
    cQryVer+=" ORDER BY CT2_EMPORI, CT2_FILORI, CONTA, VLR_DC, TIPO "

    If Select((cAlias)) > 0

        (cAlias)->(dbCloseArea())

    EndIf

    TcQuery cQryVer New Alias &cAlias

    (cAlias)->(dbGoTop())

    Do While (cAlias)->(!Eof())

        If lFirst

            aAdd(aDespesas,{'Conta','Tipo','Cod. Emp. Ori.','Empresa','Cod. Filial','Desc.Filial','Ano',;
                'Mes','Dia','Lote','Doc','Cta. Debito','Cta. Credito','Debito','Credito','Historico',;
                'Centro Debito','Centro Credito'})

            lFirst := .F.

        EndIf

        aAdd(aDespesas, {(cAlias)->CONTA,(cAlias)->TIPO ,(cAlias)->CT2_EMPORI,(cAlias)->EMPRESA, ;
            (cAlias)->CT2_FILORI,(cAlias)->NOME_FILIAL ,(cAlias)->ANO,(cAlias)->MES,(cAlias)->DIA, ;
            (cAlias)->CT2_LOTE,(cAlias)->CT2_DOC ,(cAlias)->CT2_DEBITO,(cAlias)->CT2_CREDIT, ;
            Transform((cAlias)->DEBITO,'@E 999,999,999.99'),Transform((cAlias)->CREDITO,'@E 999,999,999.99'),;
            Transform((cAlias)->VLR_DC,'@E 999,999,999.99'),(cAlias)->CT2_HIST,(cAlias)->CT2_CCD ,(cAlias)->CT2_CCC,})


        (cAlias)->(dbSkip())

    EndDo


Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
Impressao execel de cadastro de tabela de Preço
@author 	Manoel Nesio - Fabritech
@since 		05/03/2020
@version version
/*/
//-------------------------------------------------------------------                             
Static Function PrintExcel(aDespesas)
    Local nJ		:= 0
    Local cString	:= ""
    Local cArquivo	:= cGetFile("Documentos Excel|*.csv",OemToAnsi("Salvar Arquivo Como..."),0,"C:\",.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE)

    If Empty(cArquivo)
        Return nil
    EndIf

    nPosExt := At(".CSV",UPPER(cArquivo))

    If nPosExt == 0
        cArquivo := Alltrim(cArquivo) + ".CSV"
    EndIf

    nHandle := fCreate(cArquivo)

    If nHandle <= 0
        MsgInfo("Nao foi possível criar o arquivo temporário")
        Return
    Endif

    ProcRegua(Len(aDespesas))

    For nJ := 1 To Len(aDespesas)
        cString := aDespesas[nJ,01]+";"
        cString += aDespesas[nJ,02]+";"
        cString += aDespesas[nJ,03]+";"
        cString += aDespesas[nJ,04]+";"
        cString += aDespesas[nJ,05]+";"
        cString += aDespesas[nJ,06]+";"
        cString += aDespesas[nJ,07]+";"
        cString += aDespesas[nJ,08]+";"
        cString += aDespesas[nJ,09]+";"
        cString += aDespesas[nJ,10]+";"
        cString += aDespesas[nJ,11]+";"
        cString += aDespesas[nJ,12]+";"
        cString += aDespesas[nJ,13]+";"
        cString += aDespesas[nJ,14]+";"
        cString += aDespesas[nJ,15]+";"
        cString += aDespesas[nJ,16]+";"
        cString += aDespesas[nJ,17]+";"
        cString += aDespesas[nJ,18]

        IncProc(aDespesas[nJ,03]+' - '+aDespesas[nJ,04])
        FWrite(nHandle,cString + CRLF)
    Next nJ

    cString := ""
    FClose(nHandle)
    If !ApOleClient('MsExcel')
        MsgAlert('O arquivo foi gerado com sucesso, porém o MSEXCEL nao está instalado.')
        Return
    Endif

    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cArquivo)
    oExcelApp:SetVisible(.T.)

Return Nil