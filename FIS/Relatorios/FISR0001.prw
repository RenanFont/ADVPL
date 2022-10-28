#include 'totvs.ch'
#include 'parmtype.ch' 
#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} FISR0001
Relatorio de Retencao de impostos analitico
@author 	Manoel Nesio - Fabritech
@since 		06/03/2020
@version 	1.0
@return 	return, Nil
/*/

user function FISR0001()
    Local aParamBox	:= {}
    Local dDataDe	:= FirstDate( MonthSub( Date(), 1 ))
    Local dDataAte	:= LastDate(  MonthSub( Date(), 1 ))
    Local cTitulo := "Relatorio de Retencoes - Fiscal"
    Private aNotas  := {}
    
    Private cNaturezas:= SuperGetMv("MV_YNATRET",.F.,"'INSSSERPG','PGTOPCC','IRRF PAGAR','ISS PAGAR','ISS  PAGAR'")

    aAdd(aParamBox,{1, "Data de Entrada De "	   ,dDataDe		,""  ,"",""   ,""   ,50         ,.T.})
    aAdd(aParamBox,{1, "Data de Entrada Ate"	   ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})

    If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
        Processa({||FISR001A(MV_PAR01, MV_PAR02) })
    EndIf

    U_MCERLOG()

return

/*/{Protheus.doc} FISR001A
Execucao da impressao do Relatorio.
@author 	Manoel Nesio - Fabritech
@since 		10/03/2020
@version 	1.0
@return 	return, Nil
/*/

Static Function FISR001A(dDataDe, dDataAte)

    Local cFileName	:= "Relatorio_Retencoes"// + cTipoEmp
    Local oExcel      := FWMSEXCEL():New()
    Local cDirXml     := SuperGetMv('ES_DIRXML' ,,'C:\TEMP\')
 
    Local cArquivo    := ""

    default dDataDe 	:= ""
    default dDataAte	:= ""

    FISR001B(dDataDe, dDataAte)

    oExcel:AddworkSheet("RENTENCOES")
    oExcel:AddTable ("RENTENCOES","RENTENCOES_ANALITICO")
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Empresa",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Filial",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Codigo",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Loja",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","CNPJ",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Nome",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Titulo",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Prefixo",1,1)    
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Natureza",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Emissao",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Entrada",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Valor",1,1)    
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Vencimento",1,1)
    oExcel:AddColumn("RENTENCOES","RENTENCOES_ANALITICO","Val_Bruto",1,1)
    
    For nX := 1 to Len(aNotas)

        oExcel:AddRow("RENTENCOES","RENTENCOES_ANALITICO",{aNotas[nX][1],aNotas[nX][2],aNotas[nX][3],aNotas[nX][4],aNotas[nX][5],aNotas[nX][6],aNotas[nX][7],aNotas[nX][8],aNotas[nX][9],aNotas[nX][10],;
            aNotas[nX][11],aNotas[nX][12],aNotas[nX][13],aNotas[nX][14]})

    Next nX 

    MakeDir(cDirXml)
    cArquivo := cDirXml+cFileName+".xml"

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)

    ShellExecute( "Open", cArquivo , cArquivo, cDirXml,1)


Return

/*/{Protheus.doc} FISR001B
Query do Relatorio
@author 	Vitor Costa
@since 		12/03/2020
@version 	1.0
@return 	return, Nil
/*/

Static Function FISR001B(dDataDe, dDataAte)

    local cQryVer := ""
	local cAlias 		:= GetNextAlias()
    default dDataDe 	:= ""
    default dDataAte	:= ""

    cQryVer += " SELECT * "
    cQryVer += " FROM ( "
    cQryVer += " 	SELECT	 "
    cQryVer += " 		'OMAMORI' EMPRESA, "
    cQryVer += " 		SE2.E2_FILIAL, "
    cQryVer += " 		SA21.A2_COD, "
    cQryVer += " 		SA21.A2_LOJA, "
    cQryVer += " 		SA21.A2_CGC , "
    cQryVer += " 		SA21.A2_NOME , "
    cQryVer += " 		SE2.E2_NUM, "
    cQryVer += " 		SE2.E2_PREFIXO, "
    cQryVer += " 		SE2.E2_NATUREZ , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMISSAO,103),103) E2_EMISSAO,  "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMIS1,103),103) E2_EMIS1,  "
    cQryVer += " 		SE2.E2_VALOR  , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_VENCTO,103),103) E2_VENCTO, "
    cQryVer += " 		F1_VALBRUT "
    cQryVer += " 	FROM SE2010 SE2 (NOLOCK) "
    cQryVer += " 		INNER JOIN SA2010 SA21 " 
    cQryVer += " 			ON  SA21.A2_FILIAL = '' "
    cQryVer += " 			AND SA21.A2_COD = SUBSTRING(SE2.E2_TITPAI,17,6) "
    cQryVer += " 			AND SA21.A2_LOJA  = SUBSTRING(SE2.E2_TITPAI,23,2) " 
    cQryVer += " 			AND SA21.D_E_L_E_T_ = '' "
    cQryVer += " 		LEFT JOIN SF1010 SF1 (NOLOCK) "
    cQryVer += " 			ON	F1_FILIAL = E2_FILIAL  "
    cQryVer += " 			AND F1_DOC = E2_NUM "
    cQryVer += " 			AND F1_SERIE = E2_PREFIXO "
    cQryVer += " 			AND F1_FORNECE = SA21.A2_COD "
    cQryVer += " 			AND F1_LOJA = SA21.A2_LOJA "
    cQryVer += " 			AND SF1.D_E_L_E_T_ = '' "
    cQryVer += " 	WHERE SE2.E2_NATUREZ  in ("+ cNaturezas +") "
    cQryVer += " 		AND E2_EMIS1 BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "' "
    cQryVer += " 		AND SE2.D_E_L_E_T_ = '' "
    cQryVer += " 	UNION ALL "
    cQryVer += " 	SELECT "
    cQryVer += " 		'CIDADE DO SOL' EMPRESA, "
    cQryVer += " 		SE2.E2_FILIAL, "
    cQryVer += " 		SA21.A2_COD, "
    cQryVer += " 		SA21.A2_LOJA, "
    cQryVer += " 		SA21.A2_CGC , "
    cQryVer += " 		SA21.A2_NOME , "
    cQryVer += " 		SE2.E2_NUM, "
    cQryVer += " 		SE2.E2_PREFIXO, "
    cQryVer += " 		SE2.E2_NATUREZ , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMISSAO,103),103) E2_EMISSAO,  "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMIS1,103),103) E2_EMIS1,  "
    cQryVer += " 		SE2.E2_VALOR  , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_VENCTO,103),103) E2_VENCTO, "
    cQryVer += " 		F1_VALBRUT "
    cQryVer += " 	FROM SE2020 SE2 (NOLOCK) "
    cQryVer += " 		INNER JOIN SA2010 SA21 " 
    cQryVer += " 			ON  SA21.A2_FILIAL = '' "
    cQryVer += " 			AND SA21.A2_COD = SUBSTRING(SE2.E2_TITPAI,17,6) "
    cQryVer += " 			AND SA21.A2_LOJA  = SUBSTRING(SE2.E2_TITPAI,23,2) " 
    cQryVer += " 			AND SA21.D_E_L_E_T_ = '' "
    cQryVer += " 		LEFT JOIN SF1020 SF1 (NOLOCK) "
    cQryVer += " 			ON	F1_FILIAL = E2_FILIAL  "
    cQryVer += " 			AND F1_DOC = E2_NUM "
    cQryVer += " 			AND F1_SERIE = E2_PREFIXO "
    cQryVer += " 			AND F1_FORNECE = SA21.A2_COD "
    cQryVer += " 			AND F1_LOJA = SA21.A2_LOJA "
    cQryVer += " 			AND SF1.D_E_L_E_T_ = '' "
    cQryVer += " 	WHERE SE2.E2_NATUREZ  in ("+ cNaturezas +") "
    cQryVer += " 		AND E2_EMIS1 BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "' "
    cQryVer += " 		AND SE2.D_E_L_E_T_ = '' "
    cQryVer += " 	UNION ALL "
    cQryVer += " 	SELECT "
    cQryVer += " 		'TALIS' EMPRESA, "
    cQryVer += " 		SE2.E2_FILIAL, "
    cQryVer += " 		SA21.A2_COD, "
    cQryVer += " 		SA21.A2_LOJA, "
    cQryVer += " 		SA21.A2_CGC , "
    cQryVer += " 		SA21.A2_NOME , "
    cQryVer += " 		SE2.E2_NUM, "
    cQryVer += " 		SE2.E2_PREFIXO, "
    cQryVer += " 		SE2.E2_NATUREZ , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMISSAO,103),103) E2_EMISSAO,  "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMIS1,103),103) E2_EMIS1,  "
    cQryVer += " 		SE2.E2_VALOR  , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_VENCTO,103),103) E2_VENCTO, "
    cQryVer += " 		F1_VALBRUT "
    cQryVer += " 	FROM SE2060 SE2 (NOLOCK) "
    cQryVer += " 		INNER JOIN SA2010 SA21 " 
    cQryVer += " 			ON  SA21.A2_FILIAL = '' "
    cQryVer += " 			AND SA21.A2_COD = SUBSTRING(SE2.E2_TITPAI,17,6) "
    cQryVer += " 			AND SA21.A2_LOJA  = SUBSTRING(SE2.E2_TITPAI,23,2) " 
    cQryVer += " 			AND SA21.D_E_L_E_T_ = '' "
    cQryVer += " 		LEFT JOIN SF1060 SF1 (NOLOCK) "
    cQryVer += " 			ON	F1_FILIAL = E2_FILIAL  "
    cQryVer += " 			AND F1_DOC = E2_NUM "
    cQryVer += " 			AND F1_SERIE = E2_PREFIXO "
    cQryVer += " 			AND F1_FORNECE = SA21.A2_COD "
    cQryVer += " 			AND F1_LOJA = SA21.A2_LOJA "
    cQryVer += " 			AND SF1.D_E_L_E_T_ = '' "
    cQryVer += " 	WHERE SE2.E2_NATUREZ  in ("+ cNaturezas +") "
    cQryVer += " 		AND E2_EMIS1 BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "' "
    cQryVer += " 		AND SE2.D_E_L_E_T_ = '' "
    cQryVer += " 	UNION ALL "
    cQryVer += " 	SELECT	"
    cQryVer += " 		'CLEAN FIELD' EMPRESA, "
    cQryVer += " 		SE2.E2_FILIAL, "
    cQryVer += " 		SA21.A2_COD, "
    cQryVer += " 		SA21.A2_LOJA, "
    cQryVer += " 		SA21.A2_CGC , "
    cQryVer += " 		SA21.A2_NOME , "
    cQryVer += " 		SE2.E2_NUM, "
    cQryVer += " 		SE2.E2_PREFIXO, "
    cQryVer += " 		SE2.E2_NATUREZ , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMISSAO,103),103) E2_EMISSAO,  "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_EMIS1,103),103) E2_EMIS1,  "
    cQryVer += " 		SE2.E2_VALOR  , "
    cQryVer += " 		CONVERT (CHAR(10),CONVERT(datetime,SE2.E2_VENCTO,103),103) E2_VENCTO, "
    cQryVer += " 		F1_VALBRUT "
    cQryVer += " 	FROM SE2070 SE2 (NOLOCK) "
    cQryVer += " 		INNER JOIN SA2010 SA21 " 
    cQryVer += " 			ON  SA21.A2_FILIAL = '' "
    cQryVer += " 			AND SA21.A2_COD = SUBSTRING(SE2.E2_TITPAI,17,6) "
    cQryVer += " 			AND SA21.A2_LOJA  = SUBSTRING(SE2.E2_TITPAI,23,2) " 
    cQryVer += " 			AND SA21.D_E_L_E_T_ = '' "
    cQryVer += " 		LEFT JOIN SF1070 SF1 (NOLOCK) "
    cQryVer += " 			ON	F1_FILIAL = E2_FILIAL  "
    cQryVer += " 			AND F1_DOC = E2_NUM "
    cQryVer += " 			AND F1_SERIE = E2_PREFIXO "
    cQryVer += " 			AND F1_FORNECE = SA21.A2_COD "
    cQryVer += " 			AND F1_LOJA = SA21.A2_LOJA "
    cQryVer += " 			AND SF1.D_E_L_E_T_ = '' "
    cQryVer += " 	WHERE SE2.E2_NATUREZ  in ("+ cNaturezas +") "
    cQryVer += " 		AND E2_EMIS1 BETWEEN '" + dToS(dDataDe) + "' AND '" + dToS(dDataAte) + "' "
    cQryVer += " 		AND SE2.D_E_L_E_T_ = '' "
    cQryVer += " ) AS TMP "
    cQryVer += " ORDER BY TMP.EMPRESA, TMP.E2_FILIAL, TMP.E2_NUM "

    If Select((cAlias)) > 0

        (cAlias)->(dbCloseArea())

    EndIf

    TcQuery cQryVer New Alias &cAlias


    Do While (cAlias)->(!Eof())


        aAdd(aNotas, {  (cAlias)->EMPRESA,;     //01
                        (cAlias)->E2_FILIAL,;   //02
                        (cAlias)->A2_COD,;      //03
                        (cAlias)->A2_CGC,;      //04
                        (cAlias)->A2_LOJA,;     //05
                        (cAlias)->A2_NOME,;     //06
                        (cAlias)->E2_NUM,;      //07
                        (cAlias)->E2_PREFIXO,;  //08
                        (cAlias)->E2_NATUREZ,;  //09
                        (cAlias)->E2_EMISSAO,;  //10
                        (cAlias)->E2_EMIS1,;    //11
                        (cAlias)->E2_VALOR,;    //12
                        (cAlias)->E2_VENCTO,;   //13
                        (cAlias)->F1_VALBRUT})  //14

        	(cAlias)->(dbSkip())

    EndDo
	(cAlias)->(dbCloseArea())
Return
