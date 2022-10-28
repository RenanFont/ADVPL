#include 'totvs.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} CTBR0003
Relatorio de Notas de saidas analitico
@author 	Manoel Nesio - Fabritech
@since 		06/03/2020
@version 	1.0
@return 	return, Nil
/*/
user function CTBR0003()
    Local aParamBox	:= {}
    Local dDataDe	:= FirstDate( MonthSub( Date(), 1 ))
    Local dDataAte	:= LastDate(  MonthSub( Date(), 1 ))
    Private cTitulo := "Relatorio de Saidas - Contabilidade"
    Private aNotas  := {}
    Private cAlias 		:= GetNextAlias()

    aAdd(aParamBox,{1, "Data De"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.})
    aAdd(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})
    aAdd( aParamBox ,{2,"Tipo Nota","Normal",{"Normal", "Devolucao","Ambas" },60,"",.T.})

    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
        Processa({||CTBR003A(MV_PAR01, MV_PAR02,MV_PAR03) })
    EndIf

    U_MCERLOG()

return

/*/{Protheus.doc} CTBR0003A
Execução da impressão do Relatório.
@author 	Manoel Nesio - Fabritech
@since 		06/03/2020
@version 	1.0
@return 	return, Nil
/*/
Static Function CTBR003A(dDataDe, dDataAte,cTipo)
    Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
    Local cFileName	:= "Relatorio_Notas_Saidas_" + cTipoEmp

    Local oExcel      := FWMSEXCEL():New()
    Local cDirXml     := SuperGetMv('ES_DIRXML' ,,'C:\TEMP\')
    //Local nDrivers	  := GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY
    // Local cNomeArq    := cGetFile('Arquivo *|*.*|Arquivo XML|*.xml','Selecione arquivo...',0,'C:\temp\',.F.,nDrivers,.F.)//"Cad_Refresqueiras" +" - "+dToS(dDataBase)+StrTran(Time(),':','')+".xls"
    Local cArquivo    := ""

    default dDataDe 	:= ""
    default dDataAte	:= ""
    default cTipo	    := "Normal"

    cTipo:= ALLTRIM(cTipo)
    cTipo:= Iif(cTipo == "Normal","N",Iif(cTipo == "Devolucao","D","A"))
    
    GetVerbCtb(dDataDe, dDataAte,cTipo)

    oExcel:AddworkSheet("SAIDAS")
    oExcel:AddTable ("SAIDAS","SAIDAS_ANALITICO")
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Filial",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Emissao",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Cliente",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","NF",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Grupo",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Tipo",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Produto",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Descricao",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","TES",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Desc. Tes",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","CFOP",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Local",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Tipo NF",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Estoque",3,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Terceiros",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Ident Pd3",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","UF",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Conta",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Nf Original",1,1)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Qtde",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Vlr Total",3,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","ICMS",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","ICMS Ret.",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","PIS",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Cofins",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","CST Total",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Vlr Bruto",1,2)
    oExcel:AddColumn("SAIDAS","SAIDAS_ANALITICO","Chave NF",1,1)


    For nX := 1 to Len(aNotas)

        oExcel:AddRow("SAIDAS","SAIDAS_ANALITICO",{aNotas[nX][1],aNotas[nX][2],aNotas[nX][3],aNotas[nX][4],aNotas[nX][5],aNotas[nX][6],aNotas[nX][7],aNotas[nX][8],aNotas[nX][9],aNotas[nX][10],;
            aNotas[nX][11],aNotas[nX][12],aNotas[nX][13],aNotas[nX][14],aNotas[nX][15],aNotas[nX][16],aNotas[nX][17],aNotas[nX][18],aNotas[nX][19],aNotas[nX][20],aNotas[nX][21],aNotas[nX][22],aNotas[nX][23],;
            aNotas[nX][24],aNotas[nX][25],aNotas[nX][26],aNotas[nX][27],aNotas[nX][28]})

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
Static Function GetVerbCtb(dDataDe, dDataAte,cTipo)

    local cQryVer := ""

    default dDataDe 	:= ""
    default dDataAte	:= ""
    default cTipo   	:= "A"

    cQryVer += " SELECT "
    cQryVer += " 	SD2.D2_FILIAL, "
    cQryVer += " 	CONVERT(DATE,SD2.D2_EMISSAO) AS 'EMISSAO', "
    cQryVer += " 	SD2.D2_CLIENTE, "
    cQryVer += " 	SD2.D2_DOC , "
    cQryVer += " 	SD2.D2_GRUPO, "
    cQryVer += " 	SD2.D2_TP , "
    cQryVer += " 	SD2.D2_COD ,  "
    cQryVer += " 	SB1.B1_DESC, "
    cQryVer += " 	SD2.D2_TES , "
    cQryVer += " 	F4_FINALID, "
    cQryVer += " 	SD2.D2_CF , "
    cQryVer += " 	SD2.D2_LOCAL, "
    cQryVer += " 	SD2.D2_TIPO, "
    cQryVer += " 	SF4.F4_ESTOQUE, "
    cQryVer += " 	SF4.F4_PODER3, "
    cQryVer += " 	SD2.D2_IDENTB6, "
    cQryVer += " 	SD2.D2_EST, "
    cQryVer += " 	SD2.D2_CONTA , "
    cQryVer += " 	SD2.D2_NFORI, "
    cQryVer += " 	SUM(SD2.D2_QUANT) AS 'QTD', "
    cQryVer += " 	SUM(SD2.D2_TOTAL)AS 'TOTAL', "
    cQryVer += " 	SUM(SD2.D2_VALICM) AS 'ICMS', "
    cQryVer += " 	SUM(SD2.D2_ICMSRET) AS 'ICMS_RET', "
    cQryVer += " 	SUM(SD2.D2_VALIMP6) AS 'PIS', "
    cQryVer += " 	SUM(SD2.D2_VALIMP5) AS 'COFINS', "
    cQryVer += " 	SUM(SD2.D2_CUSTO1) AS 'CST_TOTAL', "
    cQryVer += " 	SUM(SD2.D2_VALBRUT) AS 'VlR_BRUTO', "
    cQryVer += " 	SF2.F2_CHVNFE "
    cQryVer += " FROM "+RetSqlName("SD2") + "  (NOLOCK)  SD2 "
    cQryVer += "	INNER JOIN "+RetSqlName("SF2") + "  (NOLOCK) SF2 "
    cQryVer += "	ON	SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC"
    cQryVer += "	AND	SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_SERIE = SD2.D2_SERIE "
    cQryVer += "	AND	SF2.F2_LOJA = SD2.D2_LOJA AND SF2.D_E_L_E_T_ = ' ' "
    cQryVer += " 	INNER JOIN "+RetSqlName("SB1") + " (NOLOCK) SB1 "

    IF CEMPANT == "01"

        cQryVer += "		ON	SB1.B1_FILIAL = '' "

    ELSE

        cQryVer += "		ON	SB1.B1_FILIAL = SD2.D2_FILIAL "

    ENDIF

    cQryVer += " 		AND SB1.B1_COD = SD2.D2_COD "
    cQryVer += " 		AND SB1.D_E_L_E_T_ = '' "
    cQryVer += " 	LEFT JOIN "+RetSqlName("SF4") + "  (NOLOCK)  SF4 "

    IF CEMPANT == "01"

        cQryVer += "		ON	SF4.F4_FILIAL = '' "

    ELSE

        cQryVer += "		ON	SF4.F4_FILIAL = SD2.D2_FILIAL "

    ENDIF

    cQryVer += " 		AND SF4.F4_CODIGO = SD2.D2_TES "
    cQryVer += " 		AND SF4.D_E_L_E_T_ = '' "
    cQryVer += " WHERE	SD2.D2_EMISSAO BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "'  "

    IF cTipo <> "A"

        cQryVer += " 	AND SD2.D2_TIPO = '"+ALLTRIM(cTipo)+ "' "

    ENDIF

    cQryVer += " 	AND SD2.D_E_L_E_T_ = ''"
    cQryVer += " GROUP BY SD2.D2_EMISSAO, "
    cQryVer += " 	SD2.D2_FILIAL, "
    cQryVer += " 	SD2.D2_CLIENTE, "
    cQryVer += " 	SD2.D2_DOC, "
    cQryVer += " 	SD2.D2_GRUPO, "
    cQryVer += " 	SD2.D2_TP , "
    cQryVer += " 	SD2.D2_COD, "
    cQryVer += " 	SB1.B1_DESC,"
    cQryVer += " 	SD2.D2_TES, "
    cQryVer += " 	SD2.D2_CF, "
    cQryVer += " 	SD2.D2_LOCAL, "
    cQryVer += " 	SD2.D2_TIPO, "
    cQryVer += " 	SF4.F4_ESTOQUE, "
    cQryVer += " 	SF4.F4_PODER3, "
    cQryVer += " 	SD2.D2_IDENTB6, "
    cQryVer += " 	SD2.D2_EST,"
    cQryVer += " 	SD2.D2_CONTA,"
    cQryVer += " 	SD2.D2_NFORI,"
    cQryVer += " 	F4_FINALID,"
    cQryVer += " 	SD2.D2_QUANT, "
    cQryVer += " 	SD2.D2_TOTAL, "
    cQryVer += " 	SD2.D2_VALICM, "
    cQryVer += " 	SD2.D2_ICMSRET, "
    cQryVer += " 	SD2.D2_VALIMP6, "
    cQryVer += " 	SD2.D2_VALIMP5, "
    cQryVer += " 	SD2.D2_CUSTO1, "
    cQryVer += " 	SD2.D2_VALBRUT, "
    cQryVer += " 	SF2.F2_CHVNFE "
    cQryVer += " ORDER BY SD2.D2_EMISSAO, SD2.D2_COD "

    If Select((cAlias)) > 0

        (cAlias)->(dbCloseArea())

    EndIf

    TcQuery cQryVer New Alias &cAlias


    Do While (cAlias)->(!Eof())

        /*
        If lFirst

			aAdd(aNotas,{'ID Tabela','ID Condicao','Cod Produto','Desc. Produto','Valor','Flag','Cnpj',})    

			lFirst := .F.

        EndIf
        */

        aAdd(aNotas, {(cAlias)->D2_FILIAL,(cAlias)->EMISSAO,(cAlias)->D2_CLIENTE ,(cAlias)->D2_DOC,(cAlias)->D2_GRUPO,;
            (cAlias)->D2_TP,(cAlias)->D2_COD,(cAlias)->B1_DESC ,(cAlias)->D2_TES,(cAlias)->F4_FINALID,(cAlias)->D2_CF,;
            (cAlias)->D2_LOCAL,(cAlias)->D2_TIPO ,(cAlias)->F4_ESTOQUE,(cAlias)->F4_PODER3,(cAlias)->D2_IDENTB6,;
            (cAlias)->D2_EST,(cAlias)->D2_CONTA,(cAlias)->D2_NFORI,(cAlias)->QTD,;
            (cAlias)->TOTAL,(cAlias)->ICMS,(cAlias)->ICMS_RET,(cAlias)->PIS,;
            (cAlias)->COFINS,(cAlias)->CST_TOTAL,(cAlias)->VlR_BRUTO,(cAlias)->F2_CHVNFE})


        (cAlias)->(dbSkip())

    EndDo

Return