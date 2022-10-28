#include "rwmake.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBXNFS   ºAutor  ³Edson Shideki Kokado º Data ³  11/25/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reativar contabilização OffLine das Notas Fiscais de Saidasº±±
±±º          ³ foram efetuados o processamento dos Lancamentos Padrões    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºOBSERVACAO³ É utilizado o campo F2_MARK no lugar do campo F2_OK        º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBXNFS()

Private _cFiltro
Private cCadastro
Private _cMarcaX
Private aRotina := {{'Reativar', 'U_CTBXNFSA', 0, 1}}


cPerg:= 'CTXNFS    '
Pergunte(cPerg, .T.)
cCadastro:= 'Reativar Contabilizacao OffLine de Notas Fiscais de Saidas'
aac:= {'Abandona', 'Confirma'}
MsgRun(	"Selecionando registros com lançamentos contabil, Aguarde...", ;
		"",{|| CursorWait(), CTBXNFSMNT(70,80) ,CursorArrow()}	)


U_MCERLOG()
Return

STATIC Function CTBXNFSMNT()

_cFiltro:= ' DTOS(F2_DTLANC)=DTOS(F2_EMISSAO)' ;
		+ ' .AND. DTOS(F2_EMISSAO) >= "'+DTOS(MV_PAR01)+'" .AND. DTOS(F2_EMISSAO) <= "'+DTOS(MV_PAR02)+'"' 

lInverte:= .F.
dbSelectArea("SF2")
_cMarcaX:= '00'+SF2->(GetMark())
MsFilter(_cFiltro)
MarkBrow( 'SF2', 'F2_OK',,,lInverte, _cMarcaX,'U_MrkAllF2()',,,,'U_MarkF2()' )
Return

USER Function CTBXNFSA()

aAreaFX:= GetArea()

dbSelectArea('SF2')

SF2->(dbSetOrder(1))
SF2->(dbGoTop())
Do While !SF2->(EOF())
	If SF2->(IsMark( 'F2_OK', _cMarcaX ))
		SF2->(RecLock('SF2', .F.))
		SF2->F2_DTLANC:= CTOD(SPACE(8))			
		SF2->(MsUnlock())				
	EndIf 
	SF2->(DbSkip())
EndDo

U_MCERLOG()
RestArea(aAreaFX)

Return

USER Function MarkF2()
If SF2->(IsMark( 'F2_OK', _cMarcaX ))
	SF2->(RecLock( 'SF2', .F. ))
	SF2->F2_OK:=Space(4)
	SF2->(MsUnLock())
Else
	SF2->(RecLock( 'SF2', .F. ))
	SF2->F2_OK:=_cMarcaX
	SF2->(MsUnLock())
EndIf
Return

// Grava marca em todos os registros validos
USER Function MrkAllF2()
	Local nRecno := SF2->(Recno())
	dbSelectArea('SF2')
	SF2->(dbGotop())
	While !SF2->(Eof())
		U_MarkF2()
		SF2->(dbSkip())
	End
	SF2->(dbGoto( nRecno ))
Return
