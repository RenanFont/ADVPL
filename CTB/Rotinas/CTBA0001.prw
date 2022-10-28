#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CTBA0001
Rotina de Importação de Lançamentos Contabeis
@author thomas.galvao
@since 11/05/2017
@version 11.8
@type function
/*/
User Function CTBA0001()
	Local oRegua
	Local lEnd 		:= .T.
	Local aSay    	:= {}
	Local aButton 	:= {}
	Local nOpc    	:= 0
	Local cTitulo	:= "Importação Aut. Lanç. Padrões"
	Local cDesc1  	:= " Essa rotina tem como objetivo, importar automaticamente"
	Local cDesc2  	:= " lançamentos padrões via arquivo *.csv, para tal, o arquivo"
	Local cDesc3	:= " deverá estar conforme padrão acertado."
	
	Aadd( aSay, cDesc1 )
	Aadd( aSay, cDesc2 )
	Aadd( aSay, cDesc3 )
	
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc == 1
		oRegua := MsNewProcess():New({|lEnd| GravaCTB(oRegua,@lEnd) },"Processando","",.T.)
		oRegua:Activate()
	EndIf
	
	U_MCERLOG()
	
Return

/*/{Protheus.doc} GravaCTB
Grava dados via Rotina Automatica.
@author thomas.galvao
@since 11/05/2017
@version 11.8
@param oObj, object, descricao
@param lEnd, logical, descricao
@type function
/*/
Static Function GravaCTB(oObj,lEnd)
	Local oDlg
	Local oDoc
	Local oLote  
	Local oSubLote  
	Local oInf, oInfLot, oHistLote
	Local cCodSeq		:= ""
	Local CTF_LOCK		:= 0
	Local lContinua 	:= .F.
	Local cTitulo		:= OemToAnsi("Capa de Lote: Lançamentos Contabeis")
	Local nTotInf 		:= nTotInfLot := 0
	Local lDigita		:= .T.
	Local l102Inclui	:= .T.
	Local nPosAut		:= 0
	Local aCT102ACAP 	:= {}
	Local lSeqCorr 		:= FindFunction("UsaSeqCor") .AND. UsaSeqCor("CT2/CTK/CT5") // Controle do Correlativo
	Local lUseDocHis	:= (cPaisLoc == "ARG") .And. X3USADO("CTC_DOCHIS")
	Local cHistLote		:= Space(80)
	Local aAreaCTF		:= CTF->(GetArea())
	Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
	Local dDataLanc		:= dDataBase
	Local cLote			:= CriaVar("CT2_LOTE")
	Local cDoc			:= CriaVar("CT2_DOC")
	Local cPadrao		:= CriaVar("CT2_LP")
	Local aCab 			:= {}
	Local aItem 		:= {}
	Local aItemCT2 		:= {}
	Local aDados		:= {}
	Local aArquivos		:= {}
	Local cFile			:= ""
	Local cDirLocal		:= AllTrim(SuperGetMv("OM_DIRARQX",,"C:\lanc_Padroes"))
	Local cDirImpor		:= AllTrim(SuperGetMv("OM_DIRARQI",,"\importado"))
	Local cDirErro		:= AllTrim(SuperGetMv("OM_DIRARQE",,"\erro"))
	Local aFiles		:= {}
	Local cMsgErro		:= ""
	Private lMsErroAuto	:= .F.
	Private lMsHelpAuto	:= .T.
	Private nOpc		:= 3
	Private cAlias		:= "CT2"
	Private cLoteSub 	:= GetMv("MV_SUBLOTE")
	Private cSubLote 	:= cLoteSub
	Private lSubLote 	:= Empty(cSubLote)
	
	//Cria pasta local
	MakeDir(cDirLocal)
	MakeDir(cDirLocal + cDirImpor)
	MakeDir(cDirLocal + cDirErro)
	
	If !Empty(cDirLocal)
		aFiles := Directory (cDirLocal + "\*.csv")
		If Len(aFiles) == 0
			MsgAlert("na pasta [" + cDirLocal + "] não contém arquivos","Consistência")
			Return nil
		Else
			For nI := 1 to len(aFiles)
				aadd( aArquivos, cDirLocal + "\" + AllTrim(aFiles[nI][1]))
			Next nI
		Endif
	Else
		Return
	EndIf
	
	//Para cada Arquivo, uma importação e configuração de Lote.
	For nJ := 1 To Len(aArquivos)
		
		//Importação dos arquivos no diretorio.
		aDados	:= {}
		aDados 	:= u_fImptArq(.T., aArquivos[nJ] )
		
		Default aDados := {}
		
		If Len(aDados) == 0
			cMsgErro += "Arquivo " + aArquivos[nJ] + " não contem dados para importação!" + CRLF
			Loop
		EndIf
	
		oObj:SetRegua1(5)
		oObj:IncRegua1("Importando o Arquivo: " + aArquivos[nJ])
		oObj:SetRegua1(Len(aDados))
		
		cSubLote		:= If(lSubLote, CriaVar("CT2_SBLOTE"), cLoteSub )
		If lSeqCorr
			cCodSeq		:= CtbRdia()
		EndIf
		
	    If ! Empty( cSubLote ) .AND. Len( alltrim( cSubLote )) < 3
	    	cSubLote := StrZero( cSubLote , 3 )
	    Endif
	
		//Ponto de entrada para preenchimento do lote/sublote  
		If ExistBlock("CT102ACAP")
			aCT102ACAP := ExecBlock( "CT102ACAP", .F., .F. )
			If ValType(aCT102ACAP) == "A" .and. Len(aCT102ACAP) > 0
	
				If !Empty(aCT102ACAP[1])
					cLote := aCT102ACAP[1]
				Endif
	
				If Len(aCT102ACAP) > 1
					If !Empty(aCT102ACAP[2])
						cSubLote := aCT102ACAP[2]
					Endif
				Endif
			Endif
		Endif        
		
		__lCusto	:= CtbMovSaldo("CTT")
		__lItem		:= CtbMovSaldo("CTD")
		__lCLVL		:= CtbMovSaldo("CTH")
		
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 33,25 TO If(lUseDocHis,320,300),If(lUseDocHis,569,309) PIXEL  //"Capa de Lote - Lan‡amentos Cont beis"
	
			@ 001,005 TO 032, 140 OF oDlg PIXEL
			@ 035,005 TO 066, 140 OF oDlg PIXEL
	
			@ 004,008 	SAY OemToAnsi("Data") SIZE 55, 7 OF oDlg PIXEL  
			@ 014,008 	MSGET oDataLanc VAR dDataLanc Picture "99/99/99" When lDigita Valid NaoVazio(dDataLanc) .And. ;
								CtbValiDt(nOpc,dDataLanc) .And.;
								If(Empty(cLote),C050Next(dDataLanc,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,nOpc,1),.T.) .And.;
								CtbMedias(dDataLanc) ;
								SIZE 50, 11 OF oDlg PIXEL HASBUTTON       					
								
			@ 038,008 	SAY OemToAnsi("Lote") SIZE 18, 7 OF oDlg PIXEL  
			@ 048,008 	MSGET oLote VAR cLote Picture "@!" When lDigita ;
							Valid NaoVazio(cLote) .And.;
							C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)  .And.;
							Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
							SIZE 32, 11 OF oDlg PIXEL
			
			@ 038,041   SAY OemToAnsi("Sub-Lote") SIZE 25, 7 OF oDlg PIXEL  
			@ 048,041   MSGET oSubLote VAR cSubLote Picture "!!!"  F3 "SB";
							WHEN lDigita .And. lSubLote;
							VALID NaoVazio(cSubLote) .And.;
								  C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)  .And.;
								  Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
							SIZE 20, 11 OF oDlg PIXEL
			
			@ 038,068   SAY OemToAnsi("Docto") SIZE 34, 7 OF oDlg PIXEL
			@ 048,068   MSGET oDoc VAR cDoc Picture "999999" ;
								When lDigita;            					
								Valid NaoVazio(cDoc) .And.;
								Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,nOpc) .And.;
								Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
								SIZE 34, 11 OF oDlg PIXEL
								
			@ 038,104   SAY OemToAnsi("Lcto Padrão") SIZE 37, 7 OF oDlg PIXEL  
		   	@ 048,104   MSGET oPadrao VAR cPadrao Pict "!!!" Valid ValidaLP(cPadrao) .And. CapValLP( cPadrao ) ;
			            F3 "CT5" SIZE 34, 11 OF oDlg PIXEL HASBUTTON When lDigita
		
			@ 074,005 	SAY OemToAnsi("Total Informado Docto") SIZE 60, 7 OF oDlg PIXEL 
			@ 070,075 	MSGET oInf VAR nTotInf  Picture cPictVal;
			    			When (l102Inclui .Or. l102Altera .Or. l102Estorno .Or. l102Copia);
				    				SIZE 80, 11 OF oDlg PIXEL HASBUTTON                 	 
							
			@ 089,005 	SAY OemToAnsi("Total Informado Lote") SIZE 60, 7 OF oDlg PIXEL
			@ 085,075 	MSGET oInfLot VAR nTotInfLot Picture cPictVal;
			    			When .F. SIZE 80, 11 OF oDlg PIXEL HASBUTTON      
			    			
			@ 104,005 	SAY OemToAnsi("Arquivo Importado:     " + aArquivos[nJ] ) SIZE 300, 7 OF oDlg PIXEL
			
			DEFINE SBUTTON FROM 120, 077 TYPE 1 ACTION (lContinua := .T., oDlg:End()) ENABLE OF oDlg
			DEFINE SBUTTON FROM 120, 112 TYPE 2 ACTION (lContinua := .F., oDlg:End()) ENABLE OF oDlg
				
		ACTIVATE MSDIALOg oDlg CENTERED
		
		If lContinua .And. !Empty(cLote)
			aCab := {}
			aAdd(aCab,  {'DDATALANC'     ,dDataLanc        	,NIL} )
			aAdd(aCab,  {'CLOTE'         ,cLote	        	,NIL} )
			aAdd(aCab,  {'CSUBLOTE'      ,cSubLote        	,NIL} )
			aAdd(aCab,  {'CDOC'          ,cDoc	         	,NIL} )
			aAdd(aCab,  {'CPADRAO'       ,cPadrao         	,NIL} )
			aAdd(aCab,  {'NTOTINF'       ,nTotInf           ,NIL} )
			aAdd(aCab,  {'NTOTINFLOT'    ,nTotInfLot        ,NIL} )
			
			aItemCT2 := {}
			For nX:=1 To Len(aDados)
				If lEnd
					Exit
				EndIf
				
				oObj:IncRegua2("Documento " + cValToChar(nX) + " de "+ cValToChar(Len(aDados)))
				
				aItem := {}
				aAdd(aItem,{'CT2_FILIAL'	,xFilial("CT2") 	, NIL})
				aAdd(aItem,{'CT2_LINHA'		, StrZero(nX,3) 	, NIL})
				aAdd(aItem,{'CT2_MOEDLC'	,'01'           	, NIL})
				aAdd(aItem,{'CT2_DC'		,aDados[nX,01] 	 	, NIL})
				aAdd(aItem,{'CT2_DEBITO'	,aDados[nX,02]  	, NIL})
				aAdd(aItem,{'CT2_CREDIT'	,aDados[nX,03]  	, NIL})
				aAdd(aItem,{'CT2_VALOR'		,Val(aDados[nX,04])	, NIL})
				aAdd(aItem,{'CT2_ORIGEM'	,'MSEXECAUT'    	, NIL})
				aAdd(aItem,{'CT2_HP'		,'' 		    	, NIL})
				aAdd(aItem,{'CT2_HIST'		,aDados[nX,05]  	, NIL})
				aAdd(aItem,{'CT2_CCD'		,aDados[nX,06]  	, NIL})
				aAdd(aItem,{'CT2_CCC'		,aDados[nX,07]  	, NIL})
				aAdd(aItem,{'CT2_ITEMD'		,aDados[nX,08]  	, NIL})
				aAdd(aItem,{'CT2_ITEMC'		,aDados[nX,09]  	, NIL})					
				aAdd(aItem,{'CT2_CLVLDB'	,aDados[nX,10]  	, NIL})					
				aAdd(aItem,{'CT2_CLVLCR'	,aDados[nX,11] 		, NIL})					
				aAdd(aItem,{'CT2_INTERC'	,'1'    			, NIL})					
				aAdd(aItem,{'CT2_TPSALD'	,'1'    			, NIL})					
				
				aAdd(aItemCT2, aClone(aItem))
				
			Next nX
			
			MSExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItemCT2, 3)  
			
			If lMsErroAuto
				cMsgErro += "Arquivo " + aArquivos[nJ] + " Erro de Rotina Automatica!" + CRLF
				DisarmTransaction()
				If AvCpyFile(aArquivos[nJ], "C:\" + cDirLocal + cDirErro)
					FErase(aArquivos[nJ])
				EndIf
				MostraErro()
			Else
				cMsgErro += "Arquivo " + aArquivos[nJ] + " Importado com Sucesso!" + CRLF
				If AvCpyFile(aArquivos[nJ], "C:\" + cDirLocal + cDirImpor)
					FErase(aArquivos[nJ])
				EndIf
			Endif   
		
		EndIf
	Next nJ
	
	Aviso("Importação", cMsgErro, {"OK"},3)
Return 