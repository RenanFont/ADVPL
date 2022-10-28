#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINX010   ºAutor  ³Edson Shideki Kokado º Data ³  11/25/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reativar contabilização de financeiro OffLine dos          º±±
±±º          ³ Movimentos Bacarios que foram efetuados o processamento    º±±
±±º          ³ dos Lancamentos Padrões                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FINX010()

	Private _cFiltro
	Private cCadastro
	Private _cMarca
	Private aRotina := {{'Reativar', 'U_FINX010A', 0, 1}}

	cPerg:= 'FX010    '
	Pergunte(cPerg, .T.)
	cCadastro:= 'Reativar Contabilizacao de Financeiro OffLine'
	aac:= {'Abandona', 'Confirma'}
	MsgRun(	"Selecionando registros Baixas, Aguarde...", ;
		"",{|| CursorWait(), FINX010MNT(70,80) ,CursorArrow()}	)

	aRotina := {{'Reativar', 'U_FINX010B', 0, 1}}
//If MV_PAR01 == 1
	MsgRun(	"Selecionando registros Provisao, Aguarde...", ;
		"",{|| CursorWait(), FINX01EMNT(70,80) ,CursorArrow()}	)
//EndIF

	U_MCERLOG()
Return

STATIC Function FINX010MNT()

	_cFiltro:= 	'E5_LA="S" .AND. DTOS(E5_DATA) >= "'+DTOS(MV_PAR02)+'" .AND. DTOS(E5_DATA) <= "'+DTOS(MV_PAR03)+'"' ;
		+ ' .AND. E5_BANCO >= "'+MV_PAR04+'" .AND. E5_BANCO <= "'+MV_PAR05+'"'


	If MV_PAR01 == 1
		_cFiltro:= _cFiltro + ' .AND. E5_RECPAG="R"'
	Else
		_cFiltro:= _cFiltro + ' .AND. E5_RECPAG="P"'
	EndIf

	lInverte:= .F.
	dbSelectArea("SE5")
	_cMarca:= GetMark()
	MsFilter(_cFiltro)
	MarkBrow( 'SE5', 'E5_OK',,,lInverte, _cMarca,'U_MrkAllE5()',,,,'U_MarkE5()' )
Return

USER Function FINX010A()

	aAreaFX:= GetArea()

	dbSelectArea('SE5')

	SE5->(dbSetOrder(1))
	SE5->(dbGoTop())
	Do While !SE5->(EOF())
		If SE5->(IsMark( 'E5_OK', _cMarca ))
			SE5->(RecLock('SE5', .F.))
			SE5->E5_LA:= ' '
			SE5->(MsUnlock())
		EndIf
		SE5->(DbSkip())
	EndDo

	RestArea(aAreaFX)

Return

USER Function MarkE5()
	If SE5->(IsMark( 'E5_OK', _cMarca ))
		SE5->(RecLock( 'SE5', .F. ))
		SE5->E5_OK:=Space(2)
		SE5->(MsUnLock())
	Else
		SE5->(RecLock( 'SE5', .F. ))
		SE5->E5_OK:=_cMarca
		SE5->(MsUnLock())
	EndIf
Return

// Grava marca em todos os registros validos
USER Function MrkAllE5()
	Local nRecno := SE5->(Recno())
	dbSelectArea('SE5')
	SE5->(dbGotop())
	While !SE5->(Eof())
		U_MarkE5()
		SE5->(dbSkip())
	End
	SE5->(dbGoto( nRecno ))
Return

STATIC Function FINX01EMNT()

	If MV_PAR01 == 1
		_cFiltro:= 'E1_LA="S" .AND. DTOS(E1_EMISSAO) >= "'+DTOS(MV_PAR02)+'" .AND. DTOS(E1_EMISSAO) <= "'+DTOS(MV_PAR03)+'"' ;
			+ ' .AND. SUBSTR(E1_ORIGEM,1,4) = "FINA" '
		lInverte:= .F.
		dbSelectArea("SE1")
		_cMarca:= GetMark()
		MsFilter(_cFiltro)
		MarkBrow( 'SE1', 'E1_OK',,,lInverte, _cMarca,'U_MrkAllE12()',,,,'U_MarkE12()' )
	Else
		_cFiltro:= 'E2_LA="S" .AND. DTOS(E2_EMISSAO) >= "'+DTOS(MV_PAR02)+'" .AND. DTOS(E2_EMISSAO) <= "'+DTOS(MV_PAR03)+'"' ;
			+ ' .AND. SUBSTR(E2_ORIGEM,1,4) = "FINA" '
		lInverte:= .F.
		dbSelectArea("SE2")
		_cMarca:= GetMark()
		MsFilter(_cFiltro)
		MarkBrow( 'SE2', 'E2_OK',,,lInverte, _cMarca,'U_MrkAllE12()',,,,'U_MarkE12()' )
	EndIf


Return

USER Function FINX010B()

	aAreaFX:= GetArea()

	If MV_PAR01 == 1
		dbSelectArea('SE1')

		SE1->(dbSetOrder(1))
		SE1->(dbGoTop())
		Do While !SE1->(EOF())
			If SE1->(IsMark( 'E1_OK', _cMarca ))
				SE1->(RecLock('SE1', .F.))
				SE1->E1_LA:= ' '
				SE1->(MsUnlock())
			EndIf
			SE1->(DbSkip())
		EndDo

	Else

		dbSelectArea('SE2')
		SE2->(dbSetOrder(1))
		SE2->(dbGoTop())
		Do While !SE2->(EOF())
			If SE2->(IsMark( 'E2_OK', _cMarca ))
				SE2->(RecLock('SE2', .F.))
				SE2->E2_LA:= ' '
				SE2->(MsUnlock())
			EndIf
			SE2->(DbSkip())
		EndDo

	EndIF
	RestArea(aAreaFX)

Return

USER Function MarkE12()

	If MV_PAR01 == 1

		If SE1->(IsMark( 'E1_OK', _cMarca ))
			SE1->(RecLock( 'SE1', .F. ))
			SE1->E1_OK:=Space(2)
			SE1->(MsUnLock())
		Else
			SE1->(RecLock( 'SE1', .F. ))
			SE1->E1_OK:=_cMarca
			SE1->(MsUnLock())
		EndIf

	Else

		If SE2->(IsMark( 'E2_OK', _cMarca ))
			SE2->(RecLock( 'SE2', .F. ))
			SE2->E2_OK:=Space(2)
			SE2->(MsUnLock())
		Else
			SE2->(RecLock( 'SE2', .F. ))
			SE2->E2_OK:=_cMarca
			SE2->(MsUnLock())
		EndIf

	EndIf

Return

// Grava marca em todos os registros validos
USER Function MrkAllE12()
	Local nRecno := 0

	If MV_PAR01 == 1
		nRecno := SE1->(Recno())
		dbSelectArea('SE1')
		SE1->(dbGotop())
		While !SE1->(Eof())
			U_MarkE12()
			SE1->(dbSkip())
		End
		SE1->(dbGoto( nRecno ))

	Else

		nRecno := SE2->(Recno())
		dbSelectArea('SE2')
		SE2->(dbGotop())
		While !SE2->(Eof())
			U_MarkE12()
			SE2->(dbSkip())
		End
		SE2->(dbGoto( nRecno ))

	EndIF

Return
