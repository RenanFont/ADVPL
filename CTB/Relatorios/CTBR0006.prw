#include 'totvs.ch'
#include 'topConn.ch'

/*/{Protheus.doc} CTBR0006
Relatório de Reversao de Impostos
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, Nil
/*/
User Function CTBR0006()
	Local aParamBox	:= {}
    Local dDataDe	:= FirstDate( MonthSub( Date(), 1 ))
	Local dDataAte	:= LastDate(  MonthSub( Date(), 1 ))
	Private cTitulo := "Relatório de Reversao de Impostos"
	
	aAdd(aParamBox,{1, "Data De ?"	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.}) 
	aAdd(aParamBox,{1, "Data Ate?"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.}) 	 
	
	If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({||CTBR0006A(MV_PAR01, MV_PAR02) })
	EndIf
	
	U_MCERLOG()
	
return

/*/{Protheus.doc} CTBR0006A
Execução da impressão do Relatório.
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, Nil
/*/
Static Function CTBR0006A(dDataDe,dDataAte)
	Local cTipoEmp	:= AllTrim(Capital(SM0->M0_NOME)) + "_" + AllTrim(Capital(SM0->M0_FILIAL))
	Local cFileName	:= "Rel_Reversao_Impostos_" + cTipoEmp
    Local cQuery	:= ""
	Local oObjExcel	:= Nil
	
    oObjExcel	:= ExportDados():New()
    
    oObjExcel:OpenGetFile() 
    oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
    oObjExcel:SetTitulo(cTitulo)
    oObjExcel:OpenClasExcel()
    
    cQuery := DevComCFSP(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Devolução Com. CFSP")
        oObjExcel:PrintXml()
    EndIf

    cQuery := DevComCFRJ(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Devolução Com. CFRJ")
        oObjExcel:PrintXml()
    EndIf

    cQuery := DevComTalis(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Devolução Com. Talis")
        oObjExcel:PrintXml()
    EndIf

    cQuery := EntClenSP(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Entradas Clean Field SP")
        oObjExcel:PrintXml()
    EndIf

    cQuery := EntClenRJ(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Entradas Clean Field RJ")
        oObjExcel:PrintXml()
    EndIf

    cQuery := EntTalis(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Entradas Talis")
        oObjExcel:PrintXml()
    EndIf

    cQuery := VdsOmaCFSP(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Vendas Omamori x Clean Field SP")
        oObjExcel:PrintXml()
    EndIf

    cQuery := VdsOmaCFRJ(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Vendas Omamori x Clean Field RJ")
        oObjExcel:PrintXml()
    EndIf

    cQuery := VdsOmaTalis(dDataDe, dDataAte)
    If !Empty(cQuery)
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Vendas Omamori x Talis")
        oObjExcel:PrintXml()
    EndIf

    oObjExcel:CloseClasExcel()

Return

/*/{Protheus.doc} DevComCFSP
Devoluções Comp. Clean SP
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function DevComCFSP(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias
        SELECT 
            SD2.D2_CF , 
            RTRIM (SD2.D2_COD) D2_COD, 
            SD2.D2_GRUPO, 
            SUM (SD2.D2_QUANT) AS D2_QUANT, 
            SUM (SD2.D2_TOTAL) AS D2_TOTAL, 
            SUM (SD2.D2_VALICM) AS ICMS , 
            SUM (SD2.D2_VALIMP6) AS PIS, 
            SUM (SD2.D2_VALIMP5) AS COFINS, 
            SUM (SD2.D2_ICMSRET) AS D2_ICMSRET, 
            SD2.D2_TP AS D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO)) AS MES_ANO
        FROM SD2070 SD2
        WHERE	SD2.D2_FILIAL   IN ('01')
            AND SD2.D2_TP       IN ('PA','RV')
            AND SD2.D2_TIPO     IN ('D')
            AND SD2.D2_CF       NOT IN ( '5910','5949' )
            AND CONVERT(DATETIME, SD2.D2_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD2.D_E_L_E_T_ <> '*'
        GROUP BY
            SD2.D2_CF, 
            SD2.D2_COD, 
            SD2.D2_GRUPO, 
            SD2.D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO))

    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} DevComCFRJ
Devoluções Comp. Clean RJ
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function DevComCFRJ(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias
        SELECT 
            SD2.D2_CF , 
            RTRIM (SD2.D2_COD) D2_COD, 
            SD2.D2_GRUPO, 
            SUM (SD2.D2_QUANT) AS D2_QUANT, 
            SUM (SD2.D2_TOTAL) AS D2_TOTAL, 
            SUM (SD2.D2_VALICM) AS ICMS , 
            SUM (SD2.D2_VALIMP6) AS PIS, 
            SUM (SD2.D2_VALIMP5) AS COFINS, 
            SUM (SD2.D2_ICMSRET) AS D2_ICMSRET, 
            SD2.D2_TP AS D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO)) AS MES_ANO
        FROM SD2070 SD2
        WHERE	SD2.D2_FILIAL   IN ('02')
            AND SD2.D2_TP       IN ('PA','RV')
            AND SD2.D2_TIPO     IN ('D')
            AND SD2.D2_CF       NOT IN ( '6910','6949' )
            AND CONVERT(DATETIME, SD2.D2_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD2.D_E_L_E_T_ <> '*'
        GROUP BY
            SD2.D2_CF, 
            SD2.D2_COD, 
            SD2.D2_GRUPO, 
            SD2.D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery


/*/{Protheus.doc} DevComTalis
Devoluções Comp. Talis
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function DevComTalis(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias
        SELECT 
            SD2.D2_CF , 
            RTRIM (SD2.D2_COD) D2_COD, 
            SD2.D2_GRUPO, 
            SUM (SD2.D2_QUANT) AS D2_QUANT, 
            SUM (SD2.D2_TOTAL) AS D2_TOTAL, 
            SUM (SD2.D2_VALICM) AS ICMS , 
            SUM (SD2.D2_VALIMP6) AS PIS, 
            SUM (SD2.D2_VALIMP5) AS COFINS, 
            SUM (SD2.D2_ICMSRET) AS D2_ICMSRET, 
            SD2.D2_TP AS D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO)) AS MES_ANO
        FROM SD2060 SD2
        WHERE	SD2.D2_FILIAL   IN ('01')
            AND SD2.D2_TP       IN ('PA','RV')
            AND SD2.D2_TIPO     IN ('D')
            AND SD2.D2_CF       NOT IN ( '5910','5949' )
            AND CONVERT(DATETIME, SD2.D2_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD2.D_E_L_E_T_ <> '*'
        GROUP BY
            SD2.D2_CF, 
            SD2.D2_COD, 
            SD2.D2_GRUPO, 
            SD2.D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} EntClenSP
Entradas Clean SP
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function EntClenSP(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias
        SELECT 
            SD1.D1_CF , 
            RTRIM (SD1.D1_COD) D1_COD, 
            SD1.D1_GRUPO, 
            SUM (SD1.D1_QUANT) AS D1_QUANT, 
            SUM (SD1.D1_TOTAL) AS D1_TOTAL, 
            SUM (SD1.D1_VALICM) AS ICMS , 
            SUM (SD1.D1_VALIMP6) AS PIS, 
            SUM (SD1.D1_VALIMP5) AS COFINS, 
            SUM (SD1.D1_ICMSRET) AS D1_ICMSRET, 
            SD1.D1_TP AS D1_TP,
            CONVERT(VARCHAR,MONTH(SD1.D1_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD1.D1_EMISSAO)) AS MES_ANO
        FROM SD1070 SD1
        WHERE	SD1.D1_FILIAL	IN ('01')
            AND SD1.D1_FORNECE	= '000229'
            AND SD1.D1_TP		IN ('RV')
            AND SD1.D1_CF		IN ('1102','1411' , '2102', '2411' , '1403' )
            AND CONVERT(DATETIME,D1_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD1.D_E_L_E_T_ <> '*'
        GROUP BY
            SD1.D1_CF, 
            SD1.D1_COD, 
            SD1.D1_GRUPO, 
            SD1.D1_TP,
            CONVERT(VARCHAR,MONTH(SD1.D1_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD1.D1_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} EntClenRJ
Entradas Clean RJ
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function EntClenRJ(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias
        SELECT 
            SD1.D1_CF , 
            RTRIM (SD1.D1_COD) D1_COD, 
            SD1.D1_GRUPO, 
            SUM (SD1.D1_QUANT) AS D1_QUANT, 
            SUM (SD1.D1_TOTAL) AS D1_TOTAL, 
            SUM (SD1.D1_VALICM) AS ICMS , 
            SUM (SD1.D1_VALIMP6) AS PIS, 
            SUM (SD1.D1_VALIMP5) AS COFINS, 
            SUM (SD1.D1_ICMSRET) AS D1_ICMSRET, 
            SD1.D1_TP AS D1_TP,
            CONVERT(VARCHAR,MONTH(SD1.D1_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD1.D1_EMISSAO)) AS MES_ANO
        FROM SD1070 SD1
        WHERE	SD1.D1_FILIAL	IN ('02')
            AND SD1.D1_FORNECE	= '000229'
            AND SD1.D1_TP		IN ('RV')
            AND SD1.D1_CF		IN ( '2102' , '2403' )
            AND CONVERT(DATETIME,D1_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD1.D_E_L_E_T_ <> '*'
        GROUP BY
            SD1.D1_CF, 
            SD1.D1_COD, 
            SD1.D1_GRUPO, 
            SD1.D1_TP,
            CONVERT(VARCHAR,MONTH(SD1.D1_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD1.D1_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} EntTalis
Entradas Talis
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function EntTalis(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias
        SELECT 
            SD1.D1_CF , 
            RTRIM (SD1.D1_COD) D1_COD, 
            SD1.D1_GRUPO, 
            SUM (SD1.D1_QUANT) AS D1_QUANT, 
            SUM (SD1.D1_TOTAL) AS D1_TOTAL, 
            SUM (SD1.D1_VALICM) AS ICMS , 
            SUM (SD1.D1_VALIMP6) AS PIS, 
            SUM (SD1.D1_VALIMP5) AS COFINS, 
            SUM (SD1.D1_ICMSRET) AS D1_ICMSRET, 
            SD1.D1_TP AS D1_TP,
            CONVERT(VARCHAR,MONTH(SD1.D1_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD1.D1_EMISSAO)) AS MES_ANO
        FROM SD1070 SD1
        WHERE	SD1.D1_FILIAL	IN ('01')
            AND SD1.D1_FORNECE	= '000229'
            AND SD1.D1_TP		IN ('RV')
            AND SD1.D1_CF		IN ('1102','1411', '1403' )
            AND CONVERT(DATETIME,D1_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD1.D_E_L_E_T_ <> '*'
        GROUP BY
            SD1.D1_CF, 
            SD1.D1_COD, 
            SD1.D1_GRUPO, 
            SD1.D1_TP,
            CONVERT(VARCHAR,MONTH(SD1.D1_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD1.D1_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} VdsOmaCFSP
Vendas Oma x Clean Field SP
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function VdsOmaCFSP(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias

        SELECT 
            SD2.D2_CF , 
            RTRIM (SD2.D2_COD) D2_COD, 
            SD2.D2_GRUPO, 
            SUM (SD2.D2_QUANT) AS D2_QUANT, 
            SUM (SD2.D2_TOTAL) AS D2_TOTAL, 
            SUM (SD2.D2_VALICM) AS ICMS , 
            SUM (SD2.D2_VALIMP6) AS PIS, 
            SUM (SD2.D2_VALIMP5) AS COFINS, 
            SUM (SD2.D2_ICMSRET) AS D2_ICMSRET, 
            SD2.D2_TP AS D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO)) AS MES_ANO
        FROM SD2010 SD2
        WHERE   SD2.D2_CLIENTE IN ('043746')
            AND SD2.D2_TP IN ('PA' , 'RV' )
            AND SD2.D2_CF NOT IN ( '5910' , '5949' )
            AND CONVERT(DATETIME,SD2.D2_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD2.D_E_L_E_T_<>'*'
        GROUP BY
            SD2.D2_CF, 
            SD2.D2_COD, 
            SD2.D2_GRUPO, 
            SD2.D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} VdsOmaCFRJ
Vendas Oma x Clean Field RJ
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function VdsOmaCFRJ(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias

        SELECT 
            SD2.D2_CF , 
            RTRIM (SD2.D2_COD) D2_COD, 
            SD2.D2_GRUPO, 
            SUM (SD2.D2_QUANT) AS D2_QUANT, 
            SUM (SD2.D2_TOTAL) AS D2_TOTAL, 
            SUM (SD2.D2_VALICM) AS ICMS , 
            SUM (SD2.D2_VALIMP6) AS PIS, 
            SUM (SD2.D2_VALIMP5) AS COFINS, 
            SUM (SD2.D2_ICMSRET) AS D2_ICMSRET, 
            SD2.D2_TP AS D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO)) AS MES_ANO
        FROM SD2010 SD2
        WHERE   SD2.D2_CLIENTE IN ('058494')
            AND SD2.D2_TP IN ('PA' , 'RV' )
            AND SD2.D2_CF NOT IN ( '6910' , '6949' )
            AND CONVERT(DATETIME,SD2.D2_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD2.D_E_L_E_T_<>'*'
        GROUP BY
            SD2.D2_CF, 
            SD2.D2_COD, 
            SD2.D2_GRUPO, 
            SD2.D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery

/*/{Protheus.doc} VdsOmaTalis
Vendas Oma x Talis
@author 	Thomas Galvão
@since 		23/03/2020
@version 	1.0
@return 	return, cQuery
/*/
Static Function VdsOmaTalis(dDataDe, dDataAte)
	Local cAlias := getNextAlias()
    Local cQuery := ""

    BeginSql Alias cALias

        SELECT 
            SD2.D2_CF , 
            RTRIM (SD2.D2_COD) D2_COD, 
            SD2.D2_GRUPO, 
            SUM (SD2.D2_QUANT) AS D2_QUANT, 
            SUM (SD2.D2_TOTAL) AS D2_TOTAL, 
            SUM (SD2.D2_VALICM) AS ICMS , 
            SUM (SD2.D2_VALIMP6) AS PIS, 
            SUM (SD2.D2_VALIMP5) AS COFINS, 
            SUM (SD2.D2_ICMSRET) AS D2_ICMSRET, 
            SD2.D2_TP AS D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO)) AS MES_ANO
        FROM SD2010 SD2
        WHERE   SD2.D2_CLIENTE IN ('043746')
            AND SD2.D2_TP IN ('PA' , 'RV' )
            AND SD2.D2_CF NOT IN ( '5910' , '5949' )
            AND CONVERT(DATETIME,SD2.D2_EMISSAO) BETWEEN %Exp:dDataDe% AND %Exp:dDataAte%
            AND SD2.D_E_L_E_T_<>'*'
        GROUP BY
            SD2.D2_CF, 
            SD2.D2_COD, 
            SD2.D2_GRUPO, 
            SD2.D2_TP,
            CONVERT(VARCHAR,MONTH(SD2.D2_EMISSAO)) + '\' + CONVERT(VARCHAR,YEAR(SD2.D2_EMISSAO))
    EndSql
    
    If (cAlias)->(!Eof())
        cQuery := GetLastQuery()[2]
    EndIf
    
    (cAlias)->(dbCloseArea())
return cQuery