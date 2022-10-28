#INCLUDE "FIVEWIN.CH"

USER FUNCTION FechParam()

PRIVATE dDATAATE :=GetMV("MV_DATAATE")   //Data fim de competência para digitação dos lançamentos. Válido para Contabilidade.
PRIVATE dDATADE  :=GetMV("MV_DATADE")    //Data início competência para digitação dos lançamentos. Válido para contabilidade.
PRIVATE dDATAFIN :=GetMV("MV_DATAFIN")   //Data limite para realização de operações financeiras.
PRIVATE dULMES   :=GetMV("MV_ULMES")     //Data Fechamento Estoque
Private dDtFis	 :=GetMV("MV_DATAFIS")
Private dDtBloq	 :=GetMV('MV_DBLQMOV')
Private dDtRecC  :=GetMV('MV_DATAREC')

PRIVATE cUSRFCH2 :=GetMV("OM_USRFCH2")     //Data Fechamento Estoque
PRIVATE cUSRFCH1 :=GetMV("OM_USRFCH1")

PRIVATE cUSRFECH :=GetMV("OM_USRFECH")
PRIVATE cUSRQMOV :=GetMV("OM_USRQMOV")

Private cUserSys := RetCodUsr()
PRIVATE nOpca    :=0
PRIVATE oDlg
PRIVATE lMsg:=.F.



IF cUserSys $ cUSRFECH
	lUSRFECH :=.T.
else
	lUSRFECH:=.F.
ENDIF

IF cUserSys $ cUSRQMOV
	lUSRQMOV :=.T.
else
	lUSRQMOV:=.F.
ENDIF

DEFINE MSDIALOG oDlg FROM  100,4 TO 515,510 TITLE OemToAnsi('Parametros Fechamento Movimentações') PIXEL
@ 03, 4 TO 046,250 LABEL "" OF oDlg  PIXEL
@ 52, 4 TO 191,250 LABEL "" OF oDlg  PIXEL

IF lUSRQMOV
	@ 055,045 MSGET dDtBloq  Picture "@D" SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL 
	//	@ 103,045 MSGET dULMES   Picture "@D" SIZE 40, 10 Valid NaoVazio(dULMES)    OF oDlg PIXEL WHEN lMsg      //#FAP20150316
Endif

IF lUSRFECH
	@ 071,045 MSGET dDATAATE Picture "@D" SIZE 40, 10 Valid NaoVazio(dDATAATE)  OF oDlg PIXEL 
	@ 087,045 MSGET dDATAFIN Picture "@D" SIZE 40, 10 Valid NaoVazio(dDATAFIN)  OF oDlg PIXEL 
	@ 119,045 MSGET dDtFis   Picture "@D" SIZE 40, 10 Valid NaoVazio(dDtFis)    OF oDlg PIXEL 
	@ 135,045 MSGET dDATADE  Picture "@D" SIZE 40, 10 Valid NaoVazio(dDATADE)   OF oDlg PIXEL 
	@ 151,045 MSGET dDtRecC  Picture "@D" SIZE 40, 10 Valid NaoVazio(dDtRecC)   OF oDlg PIXEL 
Endif

@ 008,006 SAY OemToAnsi('Parametros de Fechamento Movimentações')   SIZE 300, 24 OF oDlg PIXEL
@ 018,006 SAY OemToAnsi('Usuarios Permitido, definido no parametro OM_USRFECH')   SIZE 300, 20 OF oDlg PIXEL

IF lUSRQMOV
	@ 055,006 SAY OemToAnsi('MV_DBLQMOV')     SIZE  48, 10 OF oDlg PIXEL
	//	@ 103,006 SAY OemToAnsi('MV_ULMES')     SIZE  48, 10 OF oDlg PIXEL    //#FAP20150316
Endif
IF lUSRFECH
	@ 071,006 SAY OemToAnsi('MV_DATAATE')   SIZE  48, 10 OF oDlg PIXEL
	@ 087,006 SAY OemToAnsi('MV_DATAFIN')   SIZE  48, 10 OF oDlg PIXEL
	@ 119,006 SAY OemToAnsi('MV_DATAFIS')     SIZE  48, 10 OF oDlg PIXEL
	@ 135,006 SAY OemToAnsi('MV_DATADE')    SIZE  48, 10 OF oDlg PIXEL
	@ 151,006 SAY OemToAnsi('MV_DATAREC')     SIZE  48, 10 OF oDlg PIXEL
Endif
IF lUSRQMOV
	@ 055,088 SAY OemToAnsi('Data para bloqueio de movimentos')   		SIZE  150, 10 OF oDlg PIXEL
	@ 170,006 MSGET cUSRFCH1  Picture "@!" SIZE 190, 10   OF oDlg PIXEL WHEN .F.
	
Endif
IF lUSRFECH
	@ 071,088 SAY OemToAnsi('Data fim de competencia para digitacao dos lctos. ') SIZE  150, 10 OF oDlg PIXEL
	@ 087,088 SAY OemToAnsi('Data limite p/ realizacao de operacoes financeiras')         SIZE  150, 10 OF oDlg PIXEL
	//@ 103,088 SAY OemToAnsi('Fechamento Estoque.')                      SIZE  100, 10 OF oDlg PIXEL       //#FAP20150316
	@ 119,088 SAY OemToAnsi('Ultima data de encerramento de operacoes fiscais ')                       SIZE  150, 10 OF oDlg PIXEL
	@ 135,088 SAY OemToAnsi('Data inicio competencia para digitacao dos lanctos')					SIZE  150, 10 OF oDlg PIXEL
	@ 151,088 SAY OemToAnsi('Data limite para realizacao de Reconciliacao Banc.')SIZE  150, 10 OF oDlg PIXEL
	@ 170,006 MSGET cUSRFCH2  Picture "@!" SIZE 190, 10   OF oDlg PIXEL WHEN .F.
	
Endif


DEFINE SBUTTON FROM 194, 140 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 194, 170 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg Center

IF nOpca == 1 .and. (lUSRQMOV .or. lUSRFECH)
	IF lUSRQMOV
		cUSRFCH1 :=ALLTRIM(SUBSTR(cUSUARIO,7,15))+ '  ' + DTOC(DATE())+ ' ' + TIME()
		PutMV("OM_USRFCH1",cUSRFCH2)
		PutMV("MV_DBLQMOV" ,dDtBloq)
	Endif
	
	IF lUSRFECH
		cUSRFCH2 :=ALLTRIM(SUBSTR(cUSUARIO,7,15))+ '  ' + DTOC(DATE())+ ' ' + TIME()
		PutMV("OM_USRFCH2",cUSRFCH2)
	
	PutMV("MV_DATADE" ,dDATADE)
	PutMV("MV_DATAATE",dDATAATE)
	PutMV("MV_DATAFIN",dDATAFIN)
	//	PutMV("MV_ULMES"  ,dULMES)         //#FAP20150316
	PutMV('MV_DATAFIS',dDtFis)
	PutMV('MV_DATAREC',dDtRecC)
	Endif      

	MSGALERT('Parametros alterado.')
else
	MSGALERT('Nenhuma alteração efetuada.')
ENDIF

U_MCERLOG()
RETURN
