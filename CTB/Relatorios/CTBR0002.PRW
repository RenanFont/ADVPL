#include 'totvs.ch'
#include 'topconn.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#Include "tbiconn.ch"
#Include "tbicode.ch"

/*/{Protheus.doc} CTBR0002
Impressão do Relatório para auditoria EY.
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
User Function CTBR0002()
    Local aAreaSm0  := SM0->(GetArea())
    Local cParAno	:= cValToChar( Year( Date() ) )
    Local cParMes   := Month( Date() )
	Local aParamBox	:= {}
	Local aMeses 	:= {"01=Janeiro","02=Fevereiro","03=Março","04=Abril","05=Maio","06=Junho","07=Julho","08=Agosto","09=Setembro","10=Outubro","11=Novembro","12=Dezembro"}
    Local lContinua := .T.
    Local aSm0      := FWLoadSM0()
    Local cTitulo   := "Relatório de Auditoria"
    
    Private cCnpj0101 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '01' .And. x[2] == '01'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0102 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '01' .And. x[2] == '02'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0103 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '01' .And. x[2] == '03'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0201 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '02' .And. x[2] == '01'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0601 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '06' .And. x[2] == '01'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0701 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '07' .And. x[2] == '01'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0702 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '07' .And. x[2] == '02'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0703 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '07' .And. x[2] == '03'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0704 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '07' .And. x[2] == '04'} ), 18], "@R 99.999.999/9999-99")
    Private cCnpj0705 := Transform(aSm0[aScan(aSm0,{|x| x[1] == '07' .And. x[2] == '05'} ), 18], "@R 99.999.999/9999-99")
    
    aAdd(aParamBox,{1,"Ano"	            , cParAno, "", "", "", "",50 ,.T.}) 
	aAdd(aParamBox,{2,"Informe o Mês"   , cParMes, aMeses, 50, "", .T.})
    
    Do While lContinua
        If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
            cParAno := MV_PAR01
            cParMes	:= IIF(ValType(MV_PAR02) == "N", StrZero(MV_PAR02,2) ,SubStr(MV_PAR02,1,2))
            Processa({|| CTBR0002X( cEmpAnt, cFilAnt, cParAno, cParMes )}, 'Gerando Relatório...')
        else
            lContinua := .F.
        EndIf
    EndDo

    RestArea(aAreaSm0)
Return

/*/{Protheus.doc} CTBR0002X
Impressão do Relatório.EXPDADOS*
@author Vitor Costa
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002X(cCodEmp, cCodFil, cAno, cMes)
	Local cTipoEmp	:= ""
	Local cFileName	:= ""
    Local cQuery	:= ""
	Local oObjExcel	:= Nil
	
    Private cEmpresa    := ""
    Private cCnpjFil    := ""
	Private cTitulo     := ""

    cTipoEmp	:= AllTrim(Capital(SM0->M0_NOME)) + "_" + AllTrim(Capital(SM0->M0_FILIAL))
    cFileName	:= "Rel_Auditoria_" + cTipoEmp	

    cEmpresa    := AllTrim(Capital(SM0->M0_NOMECOM))
    cCnpjFil    := Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") 
    cTitulo     := "Relatório de Auditoria - " + AllTrim(Capital(SM0->M0_NOME)) + " " + AllTrim(Capital(SM0->M0_FILIAL)) + " - " + cMes + "/" + cAno 
    
    oObjExcel	:= ExportDados():New()
    
    IncProc("Empresa: " + cCodEmp + " -> Iniciando Relatório")
    oObjExcel:OpenGetFile() 
    oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
    oObjExcel:SetTitulo(cTitulo)
    oObjExcel:OpenClasExcel()
    
    cQuery := CTBR0002A()
    If !Empty(cQuery)
        IncProc("Empresa: " + cCodEmp + " -> Plano de Contas")
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Plano de Contas")
        oObjExcel:PrintXml()
    EndIf

    cQuery := CTBR0002B(cAno)
    If !Empty(cQuery)
        IncProc("Empresa: " + cCodEmp + " -> Calendários")
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Calendarios")
        oObjExcel:PrintXml()	
    EndIf

    cQuery := CTBR0002C(cAno, cMes)
    If !Empty(cQuery)
        IncProc("Empresa: " + cCodEmp + " -> Lançamentos Diários")
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Lançamentos Diários")
        oObjExcel:PrintXml()	
    EndIf

    cQuery := CTBR0002D(cAno, cMes)
    If !Empty(cQuery)
        IncProc("Empresa: " + cCodEmp + " -> Balancetes")
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Balancetes")
        oObjExcel:PrintXml()	
    EndIf
    
    cQuery := CTBR0002E(cAno, cMes)
    If !Empty(cQuery)
        IncProc("Empresa: " + cCodEmp + " -> Posição de Estoque")
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Posição de Estoque")
        oObjExcel:PrintXml()
    EndIf

    cQuery := CTBR0002F(cAno, cMes)
    If !Empty(cQuery)
        IncProc("Empresa: " + cCodEmp + " -> Cadastro de Produtos")
        oObjExcel:cQuery := cQuery
        oObjExcel:SetNomePlanilha("Cadastros de Produtos")
        oObjExcel:PrintXml()
    EndIf

    IncProc("Empresa: " + cCodEmp + " -> Salvando Registros em Excel")
    oObjExcel:CloseClasExcel()

Return

/*/{Protheus.doc} CTBR0002A
Plano de Contas
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002A()
    Local cAliasA   := GetNextAlias()
    Local cQueryA   := ""
       
    BeginSql Alias cAliasA
        SELECT 
            %Exp:cEmpresa% Entidade,
            CASE
                WHEN %Exp:cEmpAnt% = '01' AND CT1_FILIAL = '  ' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CT1_FILIAL = '01' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CT1_FILIAL = '02' THEN %Exp:cCnpj0102%
                WHEN %Exp:cEmpAnt% = '01' AND CT1_FILIAL = '03' THEN %Exp:cCnpj0103%
                wHEN %Exp:cEmpAnt% = '02' AND CT1_FILIAL = '  ' THEN %Exp:cCnpj0201%
                wHEN %Exp:cEmpAnt% = '02' AND CT1_FILIAL = '01' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '06' AND CT1_FILIAL = '  ' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '06' AND CT1_FILIAL = '01' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '07' AND CT1_FILIAL = '  ' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CT1_FILIAL = '01' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CT1_FILIAL = '02' THEN %Exp:cCnpj0702%
                WHEN %Exp:cEmpAnt% = '07' AND CT1_FILIAL = '04' THEN %Exp:cCnpj0704%
                WHEN %Exp:cEmpAnt% = '07' AND CT1_FILIAL = '05' THEN %Exp:cCnpj0705%
            END Cnpj,
            CT1_CONTA, 
            CT1_DESC01,
            CASE
                WHEN CT1_NORMAL = '1' THEN 'Devedora'
                WHEN CT1_NORMAL = '2' THEN 'Credora'
                ELSE 'Branco' 
            END AS CONDICAO,
            CT1_NTSPED
        FROM %Table:CT1% (NOLOCK) CT1
        WHERE   %NotDel%
        ORDER BY 1, 2, 3
    EndSql

    If (cAliasA)->(!Eof())
        cQueryA := GetLastQuery()[2]
    EndIf
    
    (cAliasA)->(dbCloseArea())
return cQueryA

/*/{Protheus.doc} CTBR0002B
Calendarios
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002B(cAno)
    Local cAliasB   := GetNextAlias()
    Local cQueryB   := ""
    
    BeginSql Alias cAliasB
        SELECT
            %Exp:cEmpresa% Entidade,
            CASE
                WHEN %Exp:cEmpAnt% = '01' AND CTG_FILIAL = '  ' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CTG_FILIAL = '01' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CTG_FILIAL = '02' THEN %Exp:cCnpj0102%
                WHEN %Exp:cEmpAnt% = '01' AND CTG_FILIAL = '03' THEN %Exp:cCnpj0103%
                WHEN %Exp:cEmpAnt% = '02' AND CTG_FILIAL = '  ' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '02' AND CTG_FILIAL = '01' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '06' AND CTG_FILIAL = '  ' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '06' AND CTG_FILIAL = '01' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '07' AND CTG_FILIAL = '  ' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CTG_FILIAL = '01' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CTG_FILIAL = '02' THEN %Exp:cCnpj0702%
                WHEN %Exp:cEmpAnt% = '07' AND CTG_FILIAL = '04' THEN %Exp:cCnpj0704%
                WHEN %Exp:cEmpAnt% = '07' AND CTG_FILIAL = '05' THEN %Exp:cCnpj0705%
            END Cnpj,
            CTG_FILIAL, 
            CTG_CALEND, 
            CTG_EXERC, 
            CTG_PERIOD,
            CONVERT(DATE,CTG_DTINI) CTG_DTIIN,
            CONVERT(DATE,CTG_DTFIM) CTG_DTFIM
        FROM %Table:CTG%  (NOLOCK) CTG
        WHERE   CTG_EXERC   = %Exp:(cAno)%
            AND CTG.%NotDel%
        ORDER BY 2
	EndSql
    
    If (cAliasB)->(!Eof())
        cQueryB := GetLastQuery()[2]
        ProcRegua(RecCount())
    EndIf
    (cAliasB)->(dbCloseArea())
return cQueryB

/*/{Protheus.doc} CTBR0002C
LanÃ§amentos Contábeis
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002C(cAno, cMes)
    Local cAliasC   := GetNextAlias()
    Local cQueryC   := ""
    
    BeginSql Alias cAliasC
        SELECT
            %Exp:cEmpresa% Entidade,
            CASE
                WHEN %Exp:cEmpAnt% = '01' AND CT2_FILIAL = '  ' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CT2_FILIAL = '01' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CT2_FILIAL = '02' THEN %Exp:cCnpj0102%
                WHEN %Exp:cEmpAnt% = '01' AND CT2_FILIAL = '03' THEN %Exp:cCnpj0103%
                WHEN %Exp:cEmpAnt% = '02' AND CT2_FILIAL = '  ' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '02' AND CT2_FILIAL = '01' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '06' AND CT2_FILIAL = '  ' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '06' AND CT2_FILIAL = '01' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '07' AND CT2_FILIAL = '  ' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CT2_FILIAL = '01' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CT2_FILIAL = '02' THEN %Exp:cCnpj0702%
                WHEN %Exp:cEmpAnt% = '07' AND CT2_FILIAL = '04' THEN %Exp:cCnpj0704%
                WHEN %Exp:cEmpAnt% = '07' AND CT2_FILIAL = '05' THEN %Exp:cCnpj0705%
            END Cnpj,
            CT2_FILIAL+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_DATA 'Lancamento',
            CT2_LINHA, 
            CT2_DEBITO, 
            CT2_CREDIT, 
            CT2_VALOR, 
            CT2_MOEDLC, 
            CTG_EXERC,
            CTG_PERIOD , 
            CONVERT(DATE,CT2_DATA) VIGENCIA, 
            CONVERT(DATE,CT2_DATA) CT2_DATA,
            CT2_HIST,
            SUBSTRING(CT2_USERGA, 11, 1)+ SUBSTRING(CT2_USERGA, 15, 1) + SUBSTRING(CT2_USERGA, 02, 1) + SUBSTRING(CT2_USERGA, 06, 1) + SUBSTRING(CT2_USERGA, 10, 1) + SUBSTRING(CT2_USERGA, 14, 1) + SUBSTRING(CT2_USERGA, 01, 1) +
            SUBSTRING(CT2_USERGA, 5, 1) + SUBSTRING(CT2_USERGA, 09, 1) + SUBSTRING(CT2_USERGA, 13, 1) + SUBSTRING(CT2_USERGA, 17, 1) + SUBSTRING(CT2_USERGA, 04, 1) + SUBSTRING(CT2_USERGA, 08, 1) Usuario, 
            (SELECT ZZF_NOME FROM %Table:ZZF% WHERE ZZF_USER =  
                SUBSTRING(CT2_USERGA, 11, 1)+SUBSTRING(CT2_USERGA, 15, 1) + SUBSTRING(CT2_USERGA, 2, 1)+SUBSTRING(CT2_USERGA, 6, 1) + SUBSTRING(CT2_USERGA, 10, 1) + SUBSTRING(CT2_USERGA, 14, 1) + SUBSTRING(CT2_USERGA, 1, 1) + SUBSTRING(CT2_USERGA, 5, 1) +
                SUBSTRING(CT2_USERGA, 9, 1)+SUBSTRING(CT2_USERGA, 13, 1) + SUBSTRING(CT2_USERGA, 17, 1)+SUBSTRING(CT2_USERGA, 4, 1) + SUBSTRING(CT2_USERGA, 8, 1)) ZZF_NOME, 
            ROW_NUMBER() OVER (ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA) 'Quantidade', 
            CT2_MANUAL
        FROM %Table:CT2% (NOLOCK) CT2 
            INNER JOIN %Table:CTG% (NOLOCK) CTG
                ON  CTG_FILIAL = CT2_FILIAL 
                AND CTG_EXERC = LEFT(CT2_DATA,4) 
                AND CTG_PERIOD = SUBSTRING(CT2_DATA,5,2) 
                AND CTG.%NotDel%
        WHERE   LEFT(CT2_DATA,6) = %Exp:(cAno+cMes)%
            AND CT2.%NotDel%
        ORDER BY 2, 11, 3, 4
	EndSql

    If (cAliasC)->(!Eof())
        cQueryC := GetLastQuery()[2]
        ProcRegua(RecCount())
    EndIf
    (cAliasC)->(dbCloseArea())
return cQueryC

/*/{Protheus.doc} CTBR0002D
Balancetes.
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002D(cAno, cMes)
	Local cAliasD   := GetNextAlias()
    Local cQueryD   := ""
    
    BeginSql Alias cAliasD
        SELECT
            %Exp:cEmpresa% Entidade,
            CASE
                WHEN %Exp:cEmpAnt% = '01' AND CQ0_FILIAL = '  ' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CQ0_FILIAL = '01' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND CQ0_FILIAL = '02' THEN %Exp:cCnpj0102%
                WHEN %Exp:cEmpAnt% = '01' AND CQ0_FILIAL = '03' THEN %Exp:cCnpj0103%
                WHEN %Exp:cEmpAnt% = '02' AND CQ0_FILIAL = '  ' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '02' AND CQ0_FILIAL = '01' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '06' AND CQ0_FILIAL = '  ' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '06' AND CQ0_FILIAL = '01' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '07' AND CQ0_FILIAL = '  ' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CQ0_FILIAL = '01' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND CQ0_FILIAL = '02' THEN %Exp:cCnpj0702%
                WHEN %Exp:cEmpAnt% = '07' AND CQ0_FILIAL = '04' THEN %Exp:cCnpj0704%
                WHEN %Exp:cEmpAnt% = '07' AND CQ0_FILIAL = '05' THEN %Exp:cCnpj0705%
            END Cnpj,
            CQ0_FILIAL, 
            CONVERT(DATE,CQ0_DATA) CQ0_DATA, 
            CQ0_CONTA, 
            CQ0_MOEDA, 
            CQ0_DEBITO, 
            CQ0_CREDIT
        FROM %Table:CQ0% (NOLOCK) CQ0
        WHERE   LEFT(CQ0_DATA,6) = %Exp:(cAno+cMes)% 
            AND %NotDel%
        ORDER BY 2, 3
    EndSql

    If (cAliasD)->(!Eof())
        cQueryD := GetLastQuery()[2]
        ProcRegua(RecCount())
    EndIf
    (cAliasD)->(dbCloseArea())
return cQueryD

/*/{Protheus.doc} CTBR0002E
PosiÃ§Ã£o de Estoques
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002E(cAno, cMes)
	Local cAliasE   := GetNextAlias()
    Local cQueryE   := ""

    BeginSql Alias cAliasE
        SELECT
            %Exp:cEmpresa% Entidade,
            CASE
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '01' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '02' THEN %Exp:cCnpj0102%
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '03' THEN %Exp:cCnpj0103%
                WHEN %Exp:cEmpAnt% = '02' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '02' AND B9_FILIAL = '01' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '06' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '06' AND B9_FILIAL = '01' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '01' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '02' THEN %Exp:cCnpj0702%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '04' THEN %Exp:cCnpj0704%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '05' THEN %Exp:cCnpj0705%
            END Cnpj,
            B9_COD, 
            (SELECT B1_DESC FROM %Table:SB1% WHERE B1_FILIAL = %xFilial:SB1% AND B1_COD = B9_COD AND %NotDel%) B1_DESC, 
            (SELECT B1_TIPO FROM %Table:SB1% WHERE B1_FILIAL = %xFilial:SB1% AND B1_COD = B9_COD AND %NotDel%) B1_TIPO,
            B9_QINI, 
            (SELECT B1_UM FROM %Table:SB1% WHERE B1_FILIAL = %xFilial:SB1% AND B1_COD = B9_COD AND %NotDel%) B1_UM, 
            'N/D' 'Custo_Material_por_Unidade', 
            'N/D' 'Custo_MO_por_Unidade', 
            'N/D' 'Gastos_Ger_Fab_por_Un', 
            CASE
                WHEN B9_VINI1 > 0 THEN (ROUND(B9_VINI1/B9_QINI,5))
                ELSE 0
            END AS 'Custo_Total_por_Un', 
            'N/D' 'Custo_Material', 
            'N/D' 'Custo_de_MO', 
            'N/D' 'Gastos_Ger_Fab',
            CASE
                WHEN B9_VINI1 > 0 THEN B9_VINI1
                ELSE 0
            END AS 'Valor', 
            'N/D' 'Taxa_Hr_MO', 
            'N/D' 'Taxa_Hr_Gastos_Gerais_Fab', 
            'N/D' 'Minutos_Custos_Gerais_Fab_por_Unidade',
            'N/D' 'Data_do_lote', 
            'N/D' 'Data_de_validade', 
            B9_LOCAL 'Local', 
            'N/D' 'Detalhes_do_local', 
            'N/D' 'Nome_Livro_Razao_Aux', 
            'N/D' 'Usu_Def_1', 
            'N/D' 'Usu_Def_2',
            'N/D' 'Usu_Def_3', 
            CONVERT(DATE,B9_DATA) 'Data_Periodo',
            CASE
                WHEN
                    SUBSTRING((	SELECT TOP 1 CONCAT(D2_DOC, D2_ITEM, D2_COD,' - ', D2_PRCVEN) 
                                FROM %Table:SD2% 
                                WHERE D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND LEFT(D2_EMISSAO,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D2_DOC, D2_ITEM, D2_COD DESC),30,100 ) IS NULL 
                    THEN 'N/D'
                ELSE SUBSTRING((SELECT TOP 1 CONCAT(D2_DOC, D2_ITEM, D2_COD,' - ', D2_PRCVEN) 
                                FROM %Table:SD2%
                                WHERE D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND LEFT(D2_EMISSAO,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D2_DOC, D2_ITEM, D2_COD DESC),30,100 )
            END 'Vlr_Unit_Ult_Saida',
            CASE
                WHEN
                    SUBSTRING((	SELECT TOP 1 CONCAT(CONVERT(DATE,D2_EMISSAO),D2_DOC, D2_ITEM, D2_COD,' | ', D2_PRCVEN) 
                                FROM %Table:SD2% 
                                WHERE D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND LEFT(D2_EMISSAO,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D2_DOC, D2_ITEM, D2_COD DESC),1,10 )  IS NULL 
                    THEN 'N/D'
                ELSE SUBSTRING((SELECT TOP 1 CONCAT(CONVERT(DATE,D2_EMISSAO),D2_DOC, D2_ITEM, D2_COD,' | ', D2_PRCVEN) 
                                FROM %Table:SD2% 
                                WHERE D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND LEFT(D2_EMISSAO,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D2_DOC, D2_ITEM, D2_COD DESC),1,10 )
            END 'Dt_Ult_Saida',
            CASE
                WHEN SUBSTRING((SELECT TOP 1 CONCAT(D1_DOC, D1_ITEM, D1_COD,' | ', D1_VUNIT) 
                                FROM %Table:SD1% 
                                WHERE D1_FILIAL = B9_FILIAL AND D1_COD = B9_COD AND LEFT(D1_DTDIGIT,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D1_DOC, D1_ITEM, D1_COD DESC),32,100 ) IS NULL THEN 'N/D'
                ELSE SUBSTRING((SELECT TOP 1 CONCAT(D1_DOC, D1_ITEM, D1_COD,' | ', D1_VUNIT) 
                                FROM %Table:SD1% 
                                WHERE D1_FILIAL = B9_FILIAL AND D1_COD = B9_COD AND LEFT(D1_DTDIGIT,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D1_DOC, D1_ITEM, D1_COD DESC),32,100 )
            END 'Vlr_Unit_Ult_Ent',
            CASE
                WHEN SUBSTRING((SELECT TOP 1 CONCAT(CONVERT(DATE,D1_DTDIGIT),D1_DOC, D1_ITEM, D1_COD,' | ', D1_VUNIT) 
                                FROM %Table:SD1% 
                                WHERE D1_FILIAL = B9_FILIAL AND D1_COD = B9_COD AND LEFT(D1_DTDIGIT,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D1_DOC, D1_ITEM, D1_COD DESC),1,10 ) IS NULL 
                    THEN 'N/D'
                ELSE SUBSTRING((SELECT TOP 1 CONCAT(CONVERT(DATE,D1_DTDIGIT),D1_DOC, D1_ITEM, D1_COD,' | ', D1_VUNIT) 
                                FROM %Table:SD1% 
                                WHERE D1_FILIAL = B9_FILIAL AND D1_COD = B9_COD AND LEFT(D1_DTDIGIT,6) = LEFT(B9_DATA,6) AND %NotDel%
                                ORDER BY D1_DOC, D1_ITEM, D1_COD DESC),1,10 )
            END 'Dt_Ult_Ent'
        FROM %Table:SB9% SB9
        WHERE	LEFT(B9_DATA,6) = %Exp:(cAno+cMes)%  
            AND B9_LOCAL <> ''
            AND B9_QINI <> 0
            AND SB9.%NotDel%
        ORDER BY 8, 10
    EndSql

    If (cAliasE)->(!Eof())
        cQueryE := GetLastQuery()[2]
        ProcRegua(RecCount())
    EndIf
    (cAliasE)->(dbCloseArea())
return cQueryE

/*/{Protheus.doc} CTBR0002F
Cadastros de Produtos
@author Thomas Galvão   
@since 18/02/20
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0002F(cAno, cMes)
	Local cAliasF  := GetNextAlias()
    Local cQueryF   := ""

    BeginSql Alias cAliasF
        SELECT
            %Exp:cEmpresa% Entidade,
            CASE
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '01' THEN %Exp:cCnpj0101%
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '02' THEN %Exp:cCnpj0102%
                WHEN %Exp:cEmpAnt% = '01' AND B9_FILIAL = '03' THEN %Exp:cCnpj0103%
                WHEN %Exp:cEmpAnt% = '02' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '02' AND B9_FILIAL = '01' THEN %Exp:cCnpj0201%
                WHEN %Exp:cEmpAnt% = '06' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '06' AND B9_FILIAL = '01' THEN %Exp:cCnpj0601%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '  ' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '01' THEN %Exp:cCnpj0701%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '02' THEN %Exp:cCnpj0702%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '04' THEN %Exp:cCnpj0704%
                WHEN %Exp:cEmpAnt% = '07' AND B9_FILIAL = '05' THEN %Exp:cCnpj0705%
            END Cnpj,
            B9_COD, 
            (SELECT B1_DESC FROM %Table:SB1% WHERE B1_FILIAL = %xFilial:SB1% AND B1_COD = B9_COD AND %NotDel%) B1_DESC,
            (SELECT B1_GRUPO+' - '+(SELECT BM_DESC FROM %Table:SBM% WHERE BM_FILIAL = %xFilial:SBM% AND BM_GRUPO = B1_GRUPO AND %NotDel%) FROM %Table:SB1% WHERE B1_FILIAL = %xFilial:SB1% AND B1_COD = B9_COD AND %NotDel%) B1_GRUPO,
            'N/D' Categoria,
            (SELECT B1_TIPO FROM %Table:SB1% WHERE B1_FILIAL = %xFilial:SB1% AND B1_COD = B9_COD AND %NotDel%) B1_TIPO,
            'Media_Movimentacao' METODO, 
            'N/D' A2_NOME
        FROM %Table:SB9% (NOLOCK) SB9
        WHERE	LEFT(B9_DATA,6) = %Exp:(cAno+cMes)% 
            AND B9_LOCAL <> ''
            AND B9_QINI <> 0
            AND SB9.%NotDel%
        GROUP BY B9_FILIAL, B9_COD
        ORDER BY 2, 3
    EndSql

    If (cAliasF)->(!Eof())
        cQueryF := GetLastQuery()[2]
        ProcRegua(RecCount())
    EndIf
    
    (cAliasF)->(dbCloseArea())
return cQueryF