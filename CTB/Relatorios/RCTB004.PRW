#INCLUDE "Protheus.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Totvs.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTB004   º Autor ³ Alvaro L Rocha     º Data ³  21/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprimir Relatório Razão por Centro de Custo p.Dr.Antonio  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERATTI                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RCTB004()

Local oReport := ReportDef()
oReport:PrintDialog()

U_MCERLOG()
Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function ReportDef                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportDef()
Local oSection1	 := Nil
Local oDetalhes	 := Nil
Local cDescr	 := "Este programa irá imprimir Relatório Razão por Centro de Custo"
Local cTitulo	 := "Razão por Centro de Custo Customizado"
Local cAliasRep	 := GetNextAlias()

Private cPerg := "RCTB04"
//Ajusta as Perguntas
CriaPerg(@cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)
oReport:SetLandscape()
oReport:nFontBody := 8
oReport:HideParamPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1 (oSection1)                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,"Razão por Centro de Custo Customizado",{("CT2")},,/*Campos do SX3*/,/*Campos do SIX*/)
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"CC"			,"CT2"	,"Centro Custo"	,/*Mascara*/,12	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"DESCCC"		,"CT2"	,"Desc.CC"		,/*Mascara*/,15	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"SUBCC"		,"CT2"	,"Sub.CC"		,/*Mascara*/,12	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"DESCSUBCC"	,"CT2"	,"Desc.Sub.CC"	,/*Mascara*/,25	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"DEBITO"		,"CT2"	,"Vl.Debito"	,/*Mascara*/,18	,/*lPixel*/	,,"RIGHT",,,,,,,, )
TRCell():New(oSection1,"CREDITO"	,"CT2"	,"Vl.Credito"	,/*Mascara*/,18	,/*lPixel*/	,,"RIGHT",,,,,,,, )
TRCell():New(oSection1,"SALDO"		,"CT2"	,"Saldo"		,/*Mascara*/,18	,/*lPixel*/	,,"RIGHT",,,,,,,, )

Return oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function ReportPrint                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportPrint(oReport,cAliasRep)

Local oSection1	:= oReport:Section(1)
Local _cQuery   := ""
Local _cQry01   := ""
Local _Enter    := chr(13) + chr(10)
&&Private nTotReg	:= 0

&&Processa( {|| u_ContReg()}, "Lendo Resgistros, Por favor aguarde..." )

_cQuery := " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO
_cQuery += " FROM RAZAOCCIMP (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "

_cQuery += " UNION "

_cQuery += " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO "
_cQuery += " FROM RAZAOCCADM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "
_cQuery += " UNION "

_cQuery += " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO "
_cQuery += " FROM RAZAOCCCOM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "

_cQuery += " UNION "

_cQuery += " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO "
_cQuery += " FROM RAZAOCCPRO (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "

_cQuery += " UNION "

_cQuery += " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO "
_cQuery += " FROM RAZAOCCCOMIS (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "

_cQuery += " UNION "

_cQuery += " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO "
_cQuery += " FROM RAZAOCCFRET (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "

_cQuery += " UNION "

_cQuery += " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO "
_cQuery += " FROM RAZAOCCJUR (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
_cQuery += " GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "

_cQuery += " ORDER BY CC, DESC_CC, SUBCC, DESC_SUBCC "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTS", .F., .T.)
	
dbSelectArea("TCTS")
TCTS->(dbGoTop())
oSection1:Init()
&&oSection1:SetMeter(nTotReg)
&&alert("nTotReg:"+cvaltochar(nTotReg))
oSection1:SetMeter(47)
While TCTS->(!Eof())
	
	oReport:IncMeter()
			
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:Cell("CC"):SetValue(TCTS->CC)
	oSection1:Cell("DESCCC"):SetValue(TCTS->DESC_CC)
	oSection1:Cell("SUBCC"):SetValue(TCTS->SUBCC)
	oSection1:Cell("DESCSUBCC"):SetValue(TCTS->DESC_SUBCC)
	oSection1:Cell("DEBITO"):SetValue(TRANSFORM (TCTS->DEBITO,"@E 99,999,999,999.99"))
	oSection1:Cell("CREDITO"):SetValue(TRANSFORM (TCTS->CREDITO,"@E 99,999,999,999.99"))
	oSection1:Cell("SALDO"):SetValue(TRANSFORM (TCTS->SALDO,"@E 99,999,999,999.99"))
	
	oSection1:PrintLine()
	
	oReport:SkipLine()
	
	dbselectarea("TCTS")
	TCTS->(DbSkip())
	
EndDo
oSection1:Finish()
oReport:endpage()
TCTS->(DbCloseArea())

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function CriaPerg (Cria Perguntas no SX1)                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function CriaPerg(cperg)
	
	PutSX1(cPerg,'01','Data Inicial','Data Inicial','Data Inicial','mv_ch1','D',8 ,0,0,'G','',''   ,'','S','mv_par01','','','','','','','','','','','','','','','','')
	PutSX1(cPerg,'02','Data Final  ','Data Final  ','Data Final  ','mv_ch2','D',8 ,0,0,'G','',''   ,'','S','mv_par02','','','','','','','','','','','','','','','','')
	
Return Nil

User Function ContReg()

Local _cQuery := ""

ProcRegua(8)
IncProc("Tabela RAZAOCCIMP...")
_cQuery := " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCIMP (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Tabela RAZAOCCADM...")
_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCADM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Tabela RAZAOCCCOM...")
_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCCOM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Tabela RAZAOCCPRO...")
_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCPRO (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Tabela RAZAOCCCOMIS...")
_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCCOMIS (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Tabela RAZAOCCFRET...")
_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCFRET (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Tabela RAZAOCCJUR...")
_cQuery += " SELECT count(*) as TOTREG "
_cQuery += " FROM RAZAOCCJUR (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
TCTR->(dbGoTop())
While TCTR->(!Eof())
    nTotReg:=nTotReg+1
	TCTR->(DbSkip())
enddo	
TCTR->(DbCloseArea())
IncProc("Encerrando Leitura...")

Return
