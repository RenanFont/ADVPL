#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MAURICIO LIMA DE SOUZA                  ³ Data ³ 19/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada Validacao cadastro plano de contas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CTB020VLD

Local   _aArea	 := GetArea()
PRIVATE _cRET    :=.T.
PRIVATE cUSRLOJI :=GetMV("OM_USRCTB ")
Private cUserSys := RetCodUsr()

//Alvaro L Rocha - Empresa 90 foi excluida dessa validacao
if alltrim(cempant) = "90" .and. alltrim(cfilant) = "01"
	return .T.
endif

IF cUserSys $ cUSRLOJI
	_cRET :=.T.
else
	_cRET :=.F.
	MSGALERT('Usuario: '+alltrim(UsrFullName(RetCodUsr()))+' Não permitido alteração no Plano de Contas ')
ENDIF

U_MCERLOG()
RestArea(_aArea)
Return _cRET

/*
If lCtb020Vld
If !ExecBlock("CTB020VLD", .F., .F.,nOpc)
Return
EndIf
EndIf

Local aRotina := {	{ OemToAnsi(STR0001),"AxPesqui"	  ,0 , 1,,.F.},;  //"Pesquisar"
{ OemToAnsi(STR0002),"Ctba020Vis",0 , 2},;  //"Visualizar"
{ OemToAnsi(STR0003),"Ctba020Inc",0 , 3},;  //"Incluir"
{ OemToAnsi(STR0004),"Ctba020Alt",0 , 4},;  //"Alterar"
{ OemToAnsi(STR0005),"Ctba020Del",0 , 5},;  //"Excluir"
{ OemToAnsi(STR0034),"Ctba020Imp",0 , 3},;  //"Importar"
{ OemToAnsi(STR0035),"Ctba020Exp",0 , 4},;  //"Exportar"
{ OemToAnsi(STR0011),"Ctba020leg",0 , 6,,.F.} }  //"Legenda"


*/
