#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CONP0001
Mostra dados do fechamento.
@author Thomas Galvão
@since 20/10/2016
@version 11.8
@type function
/*/
User Function CONP0001()
	Local dULMES   	:= GetMV("MV_ULMES")     
	Local dDtBloq	:= GetMV('MV_DBLQMOV')
	Local nOpca    	:=0
	Local oDlg
	Local lMsg		:= .F. 
	Local nLin		:= 0
	Local nSpace	:= 15
	Local nI		:= 0
	Local aFech		:= {}  
	Local cExerc01 	:= ""
	Local cExerc02 	:= ""
	Local cExerc03 	:= ""
	Local cPerio01 	:= ""
	Local cPerio02 	:= ""
	Local cPerio03 	:= "" 
	Local cStatu01	:= ""
	Local cStatu02	:= ""
	Local cStatu03	:= ""
	Local aSizeAut	:= MsAdvSize(,.F.)
    Local aObjects	:= {}
	Local aInfo 	:= {}
	Local aPosGet	:= {}
	Local aPosObj	:= {}     
         
	AAdd( aObjects, { 0,    25, .T., .F. })
	AAdd( aObjects, { 100, 100, .T., .T. })
	AAdd( aObjects, { 0,    3, .T., .F. })
		
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})
	
	aFech := P0001Fecha() 
	
	For nI := 1 To Len(aFech)   
		Do Case 
			Case nI == 1
	  			cExerc01 	:= aFech[nI,01]      
	  			cPerio01 	:= aFech[nI,02]
				cStatu01	:= aFech[nI,03]
			Case nI == 2 	  				
	  			cExerc02 	:= aFech[nI,01]        
	  			cPerio02 	:= aFech[nI,02]
				cStatu02	:= aFech[nI,03]
			Case nI == 3 	  				
	  			cExerc03 	:= aFech[nI,01]
	  			cPerio03 	:= aFech[nI,02]
				cStatu03	:= aFech[nI,03]
		EndCase
	Next nI
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi('Parametros Fechamento Movimentações') From aSizeAut[7],0 TO aSizeAut[6]-20,aSizeAut[5] +aSizeAut[2]-20  OF oMainWnd PIXEL                  
	
		nLin := 8
		@ nLin,006 SAY OemToAnsi('Parâmetros Fechamento')					SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_ULMES')   	SIZE 48, 10 OF oDlg PIXEL   
		@ nLin,045 MSGET dULMES   Picture "@D" 	SIZE 40, 10 Valid NaoVazio(dULMES)    OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Fechamento Estoque.')                      SIZE  100, 10 OF oDlg PIXEL      
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_DBLQMOV')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET dDtBloq  Picture "@D" 	SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Fechamento Movimentacao.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_CUSFIL')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_CUSFIL')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Custo Filial.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_SEQ300')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET If(GetMV('MV_SEQ300'),'T','F')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Sequencial 300.')				SIZE  100, 10 OF oDlg PIXEL

		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_ESTNEG')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_ESTNEG')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Estoque Negativo.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_CUSMED')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_CUSMED')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Custo Médio.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_CUSFIFO')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET If(GetMV('MV_CUSFIFO'),'T','F')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Custo FIFO.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_MOEDACM')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_MOEDACM')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Moeda Custo Medio.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_PRODPR0')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_PRODPR0')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Produção.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_CUSTEXC')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_CUSTEXC')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Custo Exclusivo.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_LOCPROC')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_LOCPROC')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Local Padrão.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_NEGESTR')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET If(GetMV('MV_NEGESTR'),'T','F')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Estrutura Negativa.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_PRODMNT')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_PRODMNT')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Produção Mnt.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_PROCQE6')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET If(GetMV('MV_PROCQE6'),'T','F')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Liberação CQ.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_CUSZERO')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_CUSZERO')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Custo Zerado.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_M330JCM')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_M330JCM')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Threads Movimentos.')				SIZE  100, 10 OF oDlg PIXEL
				
		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_M330THR')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_M330THR')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Threads Recalculo CM.')				SIZE  100, 10 OF oDlg PIXEL

		nLin += nSpace
		@ nLin,006 SAY OemToAnsi('MV_M330TCF')   SIZE 48, 10 OF oDlg PIXEL	
		@ nLin,045 MSGET GetMV('MV_M330TCF')  SIZE 40, 10 Valid NaoVazio(dDtBloq)   OF oDlg PIXEL WHEN lMsg
		@ nLin,088 SAY OemToAnsi('Ordem Sequencial.')				SIZE  100, 10 OF oDlg PIXEL
		
		nLin := 8
		@ nLin,300 SAY OemToAnsi('Informações Calendario.')					SIZE  100, 10 OF oDlg PIXEL
		
		nLin += nSpace 
		@ nLin,300 SAY OemToAnsi("    Mês/Ano: ")   SIZE 48, 10 OF oDlg PIXEL	; nLin += nSpace
		
		If Empty(cPerio01) .And. Empty(cPerio02) .And.  Empty(cPerio02)
			@ nLin,300 SAY OemToAnsi("    Não foi encontrado mês em Aberto!")   SIZE 150, 10 OF oDlg PIXEL
		Else
			If ! Empty(cPerio01)
				@ nLin,300 SAY OemToAnsi("    " + cPerio01 + "/" + cExerc01 + "          ----->   " + cStatu01 )   SIZE 150, 10 OF oDlg PIXEL	
				nLin += nSpace
			EndIf
			
			If ! Empty(cPerio02)
				@ nLin,300 SAY OemToAnsi("    " + cPerio02 + "/" + cExerc02 + "          ----->   " + cStatu02 )   SIZE 150, 10 OF oDlg PIXEL
				nLin += nSpace
			EndIf
			
			If ! Empty(cPerio03) 
				@ nLin,300 SAY OemToAnsi("    " + cPerio03 + "/" + cExerc03 + "          ----->   " + cStatu03 )   SIZE 150, 10 OF oDlg PIXEL
			EndIf	
		EndIf
		
		DEFINE SBUTTON FROM 270, 300 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 270, 330 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg Center

U_MCERLOG()
Return

/*/{Protheus.doc} P0001Fecha
Carrega todos os meses em aberto.
@author Thomas Galvão
@since 20/10/2016
@version 11.8
@type function
/*/
Static Function P0001Fecha()
	Local aRet := {}
	Local cAlias := GetNextAlias()
	
	BeginSql Alias cAlias
		SELECT TOP 3 CTG_EXERC, CTG_PERIOD
		FROM %Table:CTG% CTG 
		WHERE CTG_FILIAL = %xFilial:CTG% 
			AND CTG_STATUS = '1'
			AND CTG.%NotDel%	
	EndSql
	
	Do While (cAlias)->(! Eof() )
		aAdd(aRet, {(cAlias)->CTG_EXERC,;
					(cAlias)->CTG_PERIOD,;
					"ABERTO"	})
		(cAlias)->(dbSkip())
	EndDo
	 
	(cAlias)->(dbCloseArea())
Return aRet
