#include 'totvs.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} CTBR0005
Relatorio de Notas de entrada analitico
@author 	Manoel Nesio - Fabritech
@since 		06/03/2020
@version 	1.0
@return 	return, Nil
/*/
user function CTBR0005()
    Local aParamBox	:= {}
    Local dDataDe	:= FirstDate( MonthSub( Date(), 1 ))
    Local dDataAte	:= LastDate(  MonthSub( Date(), 1 ))
    Private cTitulo := "Relatorio Entradas - Contabilidade"
    Private aNotas  := {}
    Private cAlias 		:= GetNextAlias()

    aAdd(aParamBox,{1, "Data De ?"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.})
    aAdd(aParamBox,{1, "Data Ate?"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})

    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
        Processa({||CTBR002A(MV_PAR01, MV_PAR02) })
    EndIf

    U_MCERLOG()

return

/*/{Protheus.doc} CTBR002A
Execução da impressão do Relatório.
@author 	Manoel Nesio - Fabritech
@since 		06/03/2020
@version 	1.0
@return 	return, Nil
/*/
Static Function CTBR002A(dDataDe, dDataAte)
    Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
    Local cFileName	:= "Relatorio_Notas_Entradas_" + cTipoEmp

    Local oExcel      := FWMSEXCEL():New()
    Local cDirXml     := SuperGetMv('ES_DIRXML' ,,'C:\TEMP\')
    //Local nDrivers	  := GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY
    // Local cNomeArq    := cGetFile('Arquivo *|*.*|Arquivo XML|*.xml','Selecione arquivo...',0,'C:\temp\',.F.,nDrivers,.F.)//"Cad_Refresqueiras" +" - "+dToS(dDataBase)+StrTran(Time(),':','')+".xls"
    Local cArquivo    := ""

    default dDataDe 	:= ""
    default dDataAte	:= ""


    GtQrySD1(dDataDe, dDataAte)

    oExcel:AddworkSheet("ENTRADAS")
    oExcel:AddTable ("ENTRADAS","ENTRADAS_ANALITICO")
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Filial",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Data Emissao",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Data Digit.",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","NF",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Cod. Fornece",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Produto",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Descricao",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Grupo",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Tipo",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Local",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Desc. Local",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","TP",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","TES",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","MUNICÝPIO",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","CFOP",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Desc. CFOP",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Qtde",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Vlr Total",3,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","ICMS",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","ICMS Ret.",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","PIS",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Cofins",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Frete",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","IPI",1,2 )
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Custo Total",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Unid.",3,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","% ICMS",3,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","% Cofins",3,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","% PIS",3,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","% ICMS Sol",3,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Estoque",3,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Ident Pd3",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Terceiros",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Despesas",1,2)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Conta",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Verif",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Chave NF",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Nf Origem",1,1)
    oExcel:AddColumn("ENTRADAS","ENTRADAS_ANALITICO","Chave Origem",1,1)

    For nX := 1 to Len(aNotas)

        oExcel:AddRow("ENTRADAS","ENTRADAS_ANALITICO",{aNotas[nX][1],aNotas[nX][2],aNotas[nX][3],aNotas[nX][4],;
            aNotas[nX][5],aNotas[nX][6],aNotas[nX][7],aNotas[nX][8],aNotas[nX][9],aNotas[nX][10],aNotas[nX][11],;
            aNotas[nX][12],aNotas[nX][13],aNotas[nX][14],aNotas[nX][15],aNotas[nX][16],aNotas[nX][17],aNotas[nX][18],;
            aNotas[nX][19],aNotas[nX][20],aNotas[nX][21],aNotas[nX][22],aNotas[nX][23],aNotas[nX][24],aNotas[nX][25],;
            aNotas[nX][26],aNotas[nX][27],aNotas[nX][28],aNotas[nX][29],aNotas[nX][30],aNotas[nX][31],aNotas[nX][32],;
            aNotas[nX][33],aNotas[nX][34],aNotas[nX][35],aNotas[nX][36],aNotas[nX][37],aNotas[nX][38],aNotas[nX][39]})

    Next nX

    MakeDir(cDirXml)
    cArquivo := cDirXml+cFileName+".xml"

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)

    ShellExecute( "Open", cArquivo , cArquivo, cDirXml,1)

Return

/*/{Protheus.doc} GetVerbCtb
Query do Relatorio
@author 	Manoel Nesio - Fabritech
@since 		06/03/2020
@version 	1.0
@return 	return, Nil
/*/
Static Function GtQrySD1(dDataDe, dDataAte)

    local cQryVer := ""

    default dDataDe 	:= ""
    default dDataAte	:= ""


    cQryVer += " SELECT "
    cQryVer += "	SD1.D1_FILIAL,  "
    cQryVer += "	CONVERT(DATE,SD1.D1_EMISSAO) AS 'DATA2', "
    cQryVer += "	CONVERT(DATE,SD1.D1_DTDIGIT) AS 'DATA1', "
    cQryVer += "	SD1.D1_DOC, "
    cQryVer += "	SD1.D1_FORNECE, "
    cQryVer += "	SD1.D1_COD, "
    cQryVer += "	SD1.D1_DESCRPR , "
    cQryVer += "	SD1.D1_GRUPO,  "
    cQryVer += "	SD1.D1_TP, "
    cQryVer += "	SD1.D1_LOCAL, "
    cQryVer += "	SX5A.X5_DESCRI AS 'LOCAL',"
    cQryVer += "	SD1.D1_TIPO, "
    cQryVer += "	SD1.D1_TES, "
    cQryVer += "	SF4.F4_TEXTO, "
    cQryVer += "	SD1.D1_CF, "
    cQryVer += "	SX5B.X5_DESCRI  AS 'CFOP', "
    cQryVer += "	SD1.D1_QUANT, "
    cQryVer += "	SD1.D1_TOTAL, "
    cQryVer += "	SD1.D1_VALICM, "
    cQryVer += "	SD1.D1_ICMSRET, "
    cQryVer += "	SD1.D1_VALIMP6, "
    cQryVer += "	SD1.D1_VALIMP5, "
    cQryVer += "	SD1.D1_VALFRE, "
    cQryVer += "	SD1.D1_IPI, "
    cQryVer += "	SD1.D1_CUSTO, "
    cQryVer += "	SD1.D1_UM,  "
    cQryVer += "	SD1.D1_PICM, "
    cQryVer += "	SD1.D1_ALQIMP5, "
    cQryVer += "	SD1.D1_ALQIMP6, "
    cQryVer += "	SD1.D1_ALIQSOL, "
    cQryVer += "	SF4.F4_ESTOQUE, "
    cQryVer += "	ISNULL(SD1.D1_IDENTB6,' ') AS 'D1_IDENTB6', "
    cQryVer += "	SF4.F4_PODER3, "
    cQryVer += "	SD1.D1_DESPESA, "
    cQryVer += "	SD1.D1_CONTA, "
    cQryVer += "	CASE "
    cQryVer += "		WHEN SF4.F4_ESTOQUE = 'S' AND SD1.D1_LOCAL IN ('01','02','04','05','06','07','08','09','10','11','16','20','21','40','41','89','98','99','PE') THEN 'Entrada Correta' "
    cQryVer += "		WHEN SF4.F4_ESTOQUE = 'S' AND SD1.D1_LOCAL IN ('MC','SV','00') THEN 'Verificar - Não deve controlar estoque' "
    cQryVer += "		WHEN SF4.F4_ESTOQUE = 'N' AND SD1.D1_LOCAL IN ('01','02','04','05','06','07','08','09','10','11','16','20','21','40','41','89','98','99','PE') THEN 'Verificar - Deve Controlar Estoque' "
    cQryVer += "		WHEN SF4.F4_ESTOQUE = 'N' AND SD1.D1_LOCAL IN ('MC','SV','00') THEN 'Entrada Correta' "
    cQryVer += "		ELSE ''	"
    cQryVer += "	END 'VERIF',	 "
    cQryVer += "	SF1.F1_CHVNFE, "
    cQryVer += "	SD1.D1_NFORI, "
    cQryVer += "	SF2.F2_CHVNFE "
    cQryVer += " FROM "+RetSqlName("SD1") + "  (NOLOCK) SD1 "
    cQryVer += "	INNER JOIN "+RetSqlName("SF1") + "  (NOLOCK) SF1 "
    cQryVer += "	ON	SF1.F1_FILIAL = SD1.D1_FILIAL AND SF1.F1_DOC = SD1.D1_DOC"
    cQryVer += "	AND	SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_SERIE = SD1.D1_SERIE "
    cQryVer += "	AND	SF1.F1_LOJA = SD1.D1_LOJA AND SF1.D_E_L_E_T_ = ' ' "
    cQryVer += "	LEFT JOIN "+RetSqlName("SF2") + " (NOLOCK) SF2 "
    cQryVer += "	ON	SF2.F2_FILIAL = SD1.D1_FILIAL AND SF2.F2_DOC = SD1.D1_NFORI "
    cQryVer += "	AND	SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_SERIE = SD1.D1_SERIORI"
    cQryVer += "	AND	SF2.F2_LOJA = SD1.D1_LOJA AND SF2.D_E_L_E_T_ = ' ' "
    cQryVer += "	LEFT JOIN "+RetSqlName("SF4") + "  (NOLOCK) SF4 "

    IF CEMPANT == "01"

        cQryVer += "		ON	SF4.F4_FILIAL = '' "

    ELSE

        cQryVer += "		ON	SF4.F4_FILIAL = SD1.D1_FILIAL "

    ENDIF

    cQryVer += "		AND SF4.F4_CODIGO  = SD1.D1_TES "
    cQryVer += "		AND SF4.D_E_L_E_T_ = ''	"

    cQryVer += "	LEFT JOIN "+RetSqlName("SX5") + "  (NOLOCK) SX5A "

    IF CEMPANT == "01" .OR. CEMPANT == "06"

        cQryVer += "		ON	SX5A.X5_FILIAL	= '' "

    ELSE

        cQryVer += "		ON	SX5A.X5_FILIAL	= SD1.D1_FILIAL "

    ENDIF

    cQryVer += "		AND SX5A.X5_TABELA	= 'ZZ' "
    cQryVer += "		AND SX5A.X5_CHAVE	= SD1.D1_LOCAL "
    cQryVer += "		AND SX5A.D_E_L_E_T_	= '' "
    cQryVer += "	LEFT JOIN "+RetSqlName("SX5") + "  (NOLOCK) SX5B "

    IF CEMPANT == "01" .OR. CEMPANT == "06"

        cQryVer += "		ON	SX5B.X5_FILIAL	= ' ' "

    ELSE

        cQryVer += "		ON	SX5B.X5_FILIAL	= SD1.D1_FILIAL "

    ENDIF

    cQryVer += "		AND	SX5B.X5_TABELA = '13' "
    cQryVer += "		AND SX5B.X5_CHAVE = SD1.D1_CF "
    cQryVer += "		AND SX5B.D_E_L_E_T_<> '*' "
    cQryVer += " WHERE	D1_DTDIGIT BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "
    cQryVer += "	AND SD1.D_E_L_E_T_ = '' "
    cQryVer += " ORDER BY D1_DTDIGIT "

    If Select((cAlias)) > 0

        (cAlias)->(dbCloseArea())

    EndIf

    TcQuery cQryVer New Alias &cAlias


    Do While (cAlias)->(!Eof())


        aAdd(aNotas,{(cAlias)->D1_FILIAL,(cAlias)->DATA2,(cAlias)->DATA1,(cAlias)->D1_DOC,(cAlias)->D1_FORNECE,;
            (cAlias)->D1_COD,(cAlias)->D1_DESCRPR,(cAlias)->D1_GRUPO ,(cAlias)->D1_TP,(cAlias)->D1_LOCAL,(cAlias)->LOCAL,;
            (cAlias)->D1_TIPO,(cAlias)->D1_TES ,(cAlias)->F4_TEXTO,(cAlias)->D1_CF,(cAlias)->CFOP,;
            (cAlias)->D1_QUANT,(cAlias)->D1_TOTAL,;
            (cAlias)->D1_VALICM,(cAlias)->D1_ICMSRET,;
            (cAlias)->D1_VALIMP6,(cAlias)->D1_VALIMP5,;
            (cAlias)->D1_VALFRE,(cAlias)->D1_IPI,;
            (cAlias)->D1_CUSTO,(cAlias)->D1_UM,(cAlias)->D1_PICM,;
            (cAlias)->D1_ALQIMP5,(cAlias)->D1_ALQIMP6,;
            (cAlias)->D1_ALIQSOL,(cAlias)->F4_ESTOQUE,(cAlias)->D1_IDENTB6,;
            (cAlias)->F4_PODER3,(cAlias)->D1_DESPESA,(cAlias)->D1_CONTA,(cAlias)->VERIF,;
            (cAlias)->F1_CHVNFE,(cAlias)->D1_NFORI,(cAlias)->F2_CHVNFE})


        (cAlias)->(dbSkip())

    EndDo

Return