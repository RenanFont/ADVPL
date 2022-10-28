#include "rwmake.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBXNFE   ºAutor  ³Edson Shideki Kokado º Data ³  26/06/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reativar contabilização OffLine das Notas Fiscais Entradas º±±
±±º          ³ foram efetuados o processamento dos Lancamentos Padrões    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBXNFE()                                                   

Private _cFiltro
Private cCadastro
Private _cMarcaX
Private aRotina := {{'Reativar', 'U_CTBXNFEA', 0, 1}}


cPerg:= 'CTXNFE    '
Pergunte(cPerg, .T.)
cCadastro:= 'Reativar Contabilizacao OffLine de Notas Fiscais de Entradas'
aac:= {'Abandona', 'Confirma'}
MsgRun(	"Selecionando registros com lançamentos contabil, Aguarde...", ;
		"",{|| CursorWait(), CTBXNFEMNT(70,80) ,CursorArrow()}	)

U_MCERLOG()
Return

STATIC Function CTBXNFEMNT()

_cFiltro:= ' DTOS(F1_DTLANC)=DTOS(F1_DTDIGIT)' ;
		+ ' .AND. DTOS(F1_DTDIGIT) >= "'+DTOS(MV_PAR01)+'" .AND. DTOS(F1_DTDIGIT) <= "'+DTOS(MV_PAR02)+'"' 

lInverte:= .F.
dbSelectArea("SF1")
_cMarcaX:= SF1->(GetMark())
MsFilter(_cFiltro)
MarkBrow( 'SF1', 'F1_OK',,,lInverte, _cMarcaX,'U_MrkAllF1()',,,,'U_MarkF1()' )
Return

USER Function CTBXNFEA()

aAreaFX:= GetArea()

dbSelectArea('SF1')

SF1->(dbSetOrder(1))
SF1->(dbGoTop())
Do While !SF1->(EOF())
	If SF1->(IsMark( 'F1_OK', _cMarcaX ))
		SF1->(RecLock('SF1', .F.))
		SF1->F1_DTLANC:= CTOD(SPACE(8))		
		SF1->(MsUnlock())				
	EndIf 
	SF1->(DbSkip())
EndDo

RestArea(aAreaFX)

U_MCERLOG()
Return

USER Function MarkF1()
If SF1->(IsMark( 'F1_OK', _cMarcaX ))
	SF1->(RecLock( 'SF1', .F. ))
	SF1->F1_OK:=Space(2)
	SF1->(MsUnLock())
Else
	SF1->(RecLock( 'SF1', .F. ))
	SF1->F1_OK:=_cMarcaX
	SF1->(MsUnLock())
EndIf
Return

// Grava marca em todos os registros validos
USER Function MrkAllF1()
	Local nRecno := SF1->(Recno())
	dbSelectArea('SF1')
	SF1->(dbGotop())
	While !SF1->(Eof())
		U_MarkF1()
		SF1->(dbSkip())
	End
	SF1->(dbGoto( nRecno ))
Return
