//------------------------------------------------------------------------------------//
//Empresa...: FABRITECH
//Funcao....: CTBRAZAO
//Autor.....: Fernando Pacheco
//Data......:
//Uso.......: Razao 
//Versao....: 11
//------------------------------------------------------------------------------------//
#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "APWEBSRV.CH"  
#include "tbiconn.ch"

User Function CTBRAZAO()

PRIVATE dDATAIni	   := ctod("") 
PRIVATE dDATAFim	   := ctod("") 

PRIVATE nOPCA	:= 2
PRIVATE aCOLS	:= {}

PRIVATE aSitCTR	:= {"1-Razao Despesa","2-Centro Custo"}
PRIVATE oSitCTR
PRIVATE cSitCTR

PRIVATE cPath       := ""
PRIVATE cFileName   := ""
PRIVATE cTipoEmp    := ""
PRIVATE cDestino    := ""

WHILE .T.

	cPATH:= 'C:\TEMP\'
	cFileName   := "CTBRAZAO_"+SM0->M0_CODIGO+"_"+DTOS(DATE())+"_"+substr(time(),7,2)+".CSV"
	cDestino	:= PADR(cPATH+cFileName, 100)

	nOPCA	:= 2

	@ 10,0 TO 320,360  DIALOG oDlg3  TITLE OemToAnsi("Relatório Contabil - Razao")

	@ 020,010 SAY OemToAnsi("Periodo Inicial: ")  SIZE 055,007
	@ 020,065 GET dDATAIni SIZE 040,007
	@ 035,010 SAY OemToAnsi("Periodo Final  : ")  SIZE 055,007
	@ 035,065 GET dDATAFim SIZE 040,007

	@ 050,010 SAY OemToAnsi("Opcao:")   SIZE 050,007 OF oDlg3 PIXEL
	@ 050,065 COMBOBOX oSitCTR VAR cSitCTR ITEMS aSitCTR SIZE 080,007 OF oDlg3 PIXEL

	@ 100,010 SAY OemToAnsi("Destino: ")  SIZE 055,007
	@ 100,065 GET cDestino SIZE 100,007

	ACTIVATE DIALOG oDlg3 ON INIT EnchoiceBar(oDlg3,{||nOPCA:=1,oDlg3:End() },{||NOPCA:=2,oDlg3:End() }) CENTERED

	IF nOPCA == 2
		Exit
	ENDIF

	PROCESSA({||RELCTR()})   

ENDDO

U_MCERLOG()
RETURN  

STATIC FUNCTION RELCTR()

LOCAL cQUERY	:= ""
LOCAL X			:= 1

If Select("QRY") > 0
   dbCloseArea("QRY")
Endif
   
If substr(cSitCTR,1,1) == "1"

	cQUERY	+= " SELECT * FROM RAZAOCCJUR "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') "
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT * FROM RAZAOCCIMP WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') "
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT * FROM RAZAOCCFRET WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841')  "
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT * FROM RAZAOCCCOMIS WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"' AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') "
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT * FROM RAZAOCCADM WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841')   "
	cQUERY	+= " UNION " 
	cQUERY	+= " SELECT * FROM RAZAOCCCOM WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') "
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT * FROM RAZAOCCPRO WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') "
	cQUERY	+= " ORDER BY CC, SUBCC, DEBITO DESC ,  DESC_CC DESC, DESC_SUBCC "
Else
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCIMP "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC "           
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCADM "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC " 
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCCOM "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC " 
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCPRO "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC " 
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCCOMIS "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC " 
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCFRET "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC " 
	cQUERY	+= " UNION "
	cQUERY	+= " SELECT CC, DESC_CC, SUBCC, DESC_SUBCC, SUM(DEBITO) AS DEBITO, SUM(CREDITO) AS CREDITO, SUM(DEBITO-CREDITO) AS SALDO FROM RAZAOCCJUR "
	cQUERY	+= " WHERE CT2_DATA BETWEEN '"+dToS(dDATAIni)+"'  AND '"+dToS(dDATAFim)+"' AND CT2_LOTE NOT IN ('008840','008841') GROUP BY CC, DESC_CC, SUBCC, DESC_SUBCC " 
	cQUERY	+= " ORDER BY CC, DESC_CC, SUBCC, DESC_SUBCC  "
Endif

cQUERY	:= ChangeQuery(cQUERY)
TcQuery cQUERY ALIAS QRY NEW

TCSetField("QRY","DEBITO","N", 12,2)
TCSetField("QRY","CREDITO","N", 12,2)
If substr(cSitCTR,1,1) == "2"
   TCSetField("QRY","SALDO","N", 12,2)
Endif

cDestino	:= PADR(cPATH+cFileName, 100)

dbSelectArea('QRY') // Referencia ao Alias da Query
COPY TO (cFileName)

// Copia o arquivo do server para a maquina do cliente.
If !U_MLSCpyFile(cFileName,cDestino)         
   MsgStop("Nao foi possivel gerar o arquivo."+CHR(13)+CHR(10)+cDestino+CHR(13)+CHR(10)+" Verifique se está sendo utilizado.")
ELSE
   MsgBox("Foi gerado arquivo com detalhes de nome "+CHR(13)+CHR(10)+cDestino,"Atenção","ALERT")

  	If ApOleClient("MsExcel") 
   	oExcelApp:= MsExcel():New()
  		oExcelApp:WorkBooks:Open(cDestino)
   	oExcelApp:SetVisible(.T.)
  	EndIf

Endif

FERASE(cFileName) // limpa o arquivo do server.

Return

