#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*--------------------------------------------------------------------------------|
| APTUS X C.CUSTO   | centro de custo do fornecedor                               |
|---------------------------------------------|-----------------------------------|                                                                                 
|Desenvolvido para Ceratti                    | Desenvolvedor: RENAN FREITAS      |
|---------------------------------------------|-----------------------------------*/

User Function APTUS0001()
//Declarando objeto
	Local oReport := NIL
	Local cAlias := getNextAlias()
	Local cPerg := "APTUSCC"   //GOING a pergunta da sx1

	Pergunte(cPerg,.T.) //.t. exibe parametros START, .f., CLOSE  parametros 
	
	oReport := RptStruc(cAlias) //declarando objeto nO RptStruc
	oReport:printDialog() //PRINTING

Return

//PRINT query SQL
Static Function RPrint(oReport,cAlias)

	Local oSecao1 := oReport:Section(1) //variavel local declarando 1 seessao

	oSecao1:BeginQuery()

BeginSQL Alias cAlias

    SELECT  DISTINCT '01' EMPRESA, 'OMAMORI' DESCRICAO,
            SF1.F1_FILIAL, 
            SF1.F1_DOC,
            SF1.F1_SERIE,
            SF1.F1_EMISSAO,
            SF1.F1_DTDIGIT,
            SF1.F1_FORNECE,
            SF1.F1_LOJA,
            SA2.A2_NOME,
            SF1.F1_VALMERC,
            SF1.F1_VALBRUT,
            SF1.F1_XIDRD,
            SD1.D1_CC, 
            CTT.CTT_DESC01
    FROM %Table:SF1010% (NOLOCK) SF1
            
    INNER JOIN %Table:SA2010% SA2 ON  SA2.A2_FILIAL = '' AND SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.%notDel%

    INNER JOIN %Table:SD1010% SD1 ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D1_FILIAL = SF1.F1_FILIAL AND SD1.%notDel%

    INNER JOIN %Table:CTT010% CTT ON CTT_CUSTO = SD1.D1_CC  AND CTT.%notDel% 

    WHERE 
            SF1.%notDel%
        AND SF1.F1_XIDRD    <> ''
        AND SF1.F1_XIDRD    <> 'N'
        AND SA2.A2_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND SF1.F1_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 

	UNION ALL
	
	SELECT	DISTINCT '07' EMPRESA, 'CLEAN FIELD' DESCRICAO,
			SF1.F1_FILIAL, 
    		SF1.F1_DOC,
            SF1.F1_SERIE,
            SF1.F1_EMISSAO,
            SF1.F1_DTDIGIT,
            SF1.F1_FORNECE,
            SF1.F1_LOJA,
            SA2.A2_NOME,
            SF1.F1_VALMERC,
            SF1.F1_VALBRUT,
            SF1.F1_XIDRD,
            SD1.D1_CC, 
            CTT.CTT_DESC01
    FROM %Table:SF1070% (NOLOCK) SF1
            
    INNER JOIN %Table:SA2010% SA2 ON  SA2.A2_FILIAL = '' AND SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.%notDel%

    INNER JOIN %Table:SD1070% SD1 ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D1_FILIAL = SF1.F1_FILIAL AND SD1.%notDel%

    INNER JOIN %Table:CTT070% CTT ON CTT_CUSTO = SD1.D1_CC  AND CTT.%notDel% 

    WHERE 
            SF1.%notDel%
        AND SF1.F1_XIDRD    <> ''
        AND SF1.F1_XIDRD    <> 'N'
        AND SA2.A2_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND SF1.F1_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 

        
EndSQL

    oSecao1:EndQuery() //CLOSE Query

    oReport:SetMeter((cAlias)->(RecCount()))//(PRINT DATE LOADING...)

    oSecao1:Print() //PRINT query


Return

//CHmando FUNCTION RptStruc

Static Function RptStruc(cAlias)

	Local cTitulo 	:= "APTUS X C.CUSTO"
	Local cHelp 	:= "RELATORIO DE CENTRO DE CUSTO DO FORNECEDOR"
	Local oReport
	Local oSection1


//Instanciando OBJETO TReport:

	oReport := TReport():New('APTUS0001',cTitulo,,{|oReport|RPrint(oReport, cAlias)},cHelp)
	oReport:SetLandscape(.T.)

	//SECTION 
	oSection1 := TRSection():New(oReport, "CENTRO DE CUSTO DO FORNECEDOR", {cAlias} )

	//tabelaAIB (TAB PREÇO)
	TRCell():New(oSection1,	"DISTINCT",		cAlias,	"EMPRESA")
	TRCell():New(oSection1,	"DISTINCT",		cAlias,	"DESCRICAO")
	TRCell():New(oSection1,	"F1_FILIAL",	cAlias,	"FILIAL")
	TRCell():New(oSection1,	"F1_DOC",		cAlias,	"DOC")
	TRCell():New(oSection1,	"F1_SERIE",	    cAlias,	"SERIE")
	TRCell():New(oSection1,	"F1_EMISSAO",	cAlias,	"DT.EMISSAO")
	TRCell():New(oSection1,	"F1_DTDIGIT",	cAlias,	"DT.DIGITACAO" )
	TRCell():New(oSection1,	"F1_FORNECE",	cAlias,	"COD.FORNECEDOR")
	TRCell():New(oSection1,	"F1_LOJA",		cAlias,	"LOJA")
	TRCell():New(oSection1,	"A2_NOME",	    cAlias,	"NOME")
	TRcell():New(oSection1,	"F1_VALMERC",	cAlias,	"TOTAL_MERC")
	TRCell():New(oSection1,	"F1_VALBRUT",	cAlias,	"TOTAL_BRUTO")
	TRCell():New(oSection1,	"F1_XIDRD",	    cAlias,	"ID_RD")
	TRCell():New(oSection1,	"D1_CC",	    cAlias,	"C_CUSTO")
	TRCell():New(oSection1,	"CTT_DESC01",	cAlias,	"Desc.")

	
Return (oReport)




