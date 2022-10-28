#include "rwmake.ch"
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o  	 ³ CRTGAUDT ³ Autor ³  Edson Shideki Kokado ³ Data ³ 28.02.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório Gerencial Auditoria            	 	         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CRTGAUDT()  			     								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum      												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico          				  		  			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum		       										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                          
USER FUNCTION CRTGAUDI()
   PRIVATE   aOrd         := {}
   PRIVATE   cDesc1       := "Este programa tem como objetivo imprimir relatorio "
   PRIVATE   cDesc2       := "de Gerencial Auditoria de Contas a Receber ou Pagar."
   PRIVATE   cDesc3       := ""
   PRIVATE   titulo       := "RELATÓRIO DE GERENCIAL AUDITORIA"
   PRIVATE   Cabec1       := ""
   PRIVATE   Cabec2       := ""
   PRIVATE   nMeses       := 0

   PRIVATE lEnd           := .F.
   PRIVATE lAbortPrint    := .F.
   PRIVATE CbTxt          := ""
   PRIVATE limite         := 220        // 80, 132 ou 220
   PRIVATE tamanho        := "G"        //  P,   M ou G
   PRIVATE nomeprog       := "CRTGAUDT" // Coloque aqui o nome do programa para impressao no cabecalho
   PRIVATE nTipo          := 18         // 18 normal, 15 comprimido
   PRIVATE aReturn        := { "Zebrado", 1, "Administração", 2, 2, 1, "", 1 }
   PRIVATE nLastKey       := 0
   PRIVATE cbtxt          := Space( 50 )
   PRIVATE cbcont         := 00
   PRIVATE CONTFL         := 01
   PRIVATE m_pag          := 01
   PRIVATE wnrel          := "CRTGAUDT" // Coloque aqui o nome do arquivo usado para impressao em disco
   PRIVATE cempresa       := "010"        
                           
   // Monta a interface padrao com o usuario...
   Pergunte( "CRTGAUD", .F. )        // CRIAR UM NOVO NOME DA PERGUNTA
   wnrel := SetPrint( nil, NomeProg, "CRTGAUD", @titulo, cDesc1, cDesc2, cDesc3, .T., aOrd, .T., Tamanho, , .T. )
   IF nLastKey == 27
      RETURN                        
   ENDIF

   SetDefault( aReturn, "" )

   IF nLastKey == 27
      RETURN
   ENDIF
   nTipo := IF( aReturn[4] == 1, 15, 18 )


   // Processamento. RPTSTATUS monta janela com a regua de processamento.
   RptStatus( {|| RunReport( Cabec1, Cabec2, Titulo ) }, Titulo )
   
   U_MCERLOG()
Return

/************************************************************************
* Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS
* monta a janela com a regua de processamento.
************************************************************************/
STATIC FUNCTION RunReport( Cabec1, Cabec2, Titulo )
   LOCAL aaux         := {}
   Private cNumero    := ''
   PRIVATE   nLin         := 80
   Private arows        := {}  
   Private aSubTotal    := {0,0,0,0,0,0}
   Private aTotal       := {0,0,0,0,0,0}
   Public aKeyBxAux:= {}                                                           
                                                            

   IF MV_PAR05 == 1   
	   aRows:= getNotas(MV_PAR01, MV_PAR02, 'R', MV_PAR09, MV_PAR10, MV_PAR03, MV_PAR04)
		Titulo+= " ( Contas a Receber ) "
   ELSE
	   aRows:= getNotas(MV_PAR01, MV_PAR02, 'P', MV_PAR07, MV_PAR08, MV_PAR03, MV_PAR04)
      Titulo+= " ( Contas a Pagar ) "
   ENDIF                 
   
   IF Len(aRows) > 0
   
      // Ordena conforme o parâmetro 06
      IF MV_PAR06 == 1
         arows := aSort( arows,,, { |x, y| x[15] < y[15] } )
      ELSEIF MV_PAR06 == 2
         arows := aSort( arows,,, { |x, y| x[16] < y[16] } )
      ENDIF
   
   ENDIF

	   // Enquanto nao for o fim do cursor... executa.
   SetRegua( Len( arows ) )
   FOR nInc := 1 TO Len( arows )
      // Verifica o cancelamento pelo usuario...
		IF lAbortPrint
        	@nLin, 00 PSAY "*** CANCELADO PELO OPERADOR ***"
  			EXIT
      	ENDIF
      	// Impressao do cabecalho do relatorio. . .
      	IF nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			ImpCabec()
      	ENDIF
		                    
		IF (arows[nInc,17] > 0) .OR. (arows[nInc,19] > 0) .OR.(arows[nInc,12] <> arows[nInc,11])

   		   // Imprime o Detalhe		
		   ImpDet()

		   // Acumula Sub-Total
		   AcumSubT()
		
		   // Acumula Total-Geral
		   AcumTotG()

		   // Imprime Sub-Total
           IF nLin > 59 // Salto de Página. Neste caso o formulario tem 55 linhas...
			   ImpSubT()
         	   // Zera os subtotais
              aSubTotal := { 0, 0, 0, 0, 0, 0 }
		   ENDIF


		ENDIF		

		IncRegua()
   NEXT

	// Imprime Total-Geral
	IF nLin > 0 .AND. nLin < 80
		ImpTotG()
	ENDIF

   // Finaliza a execucao do relatorio...
   SET DEVICE TO SCREEN

   // Se impressao em disco, chama o gerenciador de impressao...
   IF aReturn[5] == 1
      SET PRINTER TO
      OurSpool( wnrel )
   ENDIF

   MS_FLUSH()
RETURN
                                                                       

STATIC FUNCTION getNotas(dDtProc,  dDtBase, cTipo, cCliForDe, cCliForAte, dContabDe, dContabAte  )
   LOCAL cQuery1   := ""
   LOCAL cQuery2   := ""
   LOCAL cQuery3   := ""
   LOCAL cQuery4   := ""
   LOCAL cQuery5   := ""
   LOCAL cQuery6   := ""
   Local nSaldoFin := 0
   Local nSaldoFDb := 0                     
   Local nSaldoFCr := 0                     
   Local nSaldoBai := 0
   Local nSaldoBDb := 0                     
   Local nSaldoBCr := 0                     
   Local nSaldo1Pc := 0
   Local cKeyNota  := ""
   Local cKeyInc   := ""
   Local cKeyInc1A   := ""
   Local cKeyInc1B   := ""
   Local cKeyBx    := ""        
   Local cKeyBx1   := ""        
   Local aRetorno:= {}     
   Local aKeyBx:= {}                                                   
   Local aAux:= {}
   Private nSldCtbAnt := 0                     
   Private nSldCtbMes := 0                     
   Private nSldCtbPos := 0  
                      

  IF cTipo == "R"
   //Adiciona os titulos a receber a partir da data de processamento
      cQuery1 := "SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, D2_EMISSAO, D2_TOTAL, A1_NREDUZ "
      cQuery1 += "FROM "+RetSqlName("SD2")+" SD2 "
      cQuery1 += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA  "      
      cQuery1 += "WHERE SD2.D_E_L_E_T_<>'*' AND D2_EMISSAO >= '"+DTOS(dDtProc)+"' AND D2_EMISSAO <= '"+DTOS(dDtBase)+"' "   
      cQuery1 += "AND D2_FILIAL = '"+xFILIAL("SD2")+"' "  
      cQuery1 += "AND D2_CLIENTE >= '"+cCliForDe+"' AND D2_CLIENTE <= '"+cCliForAte+"' "  
      cQuery1 += "ORDER BY D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA "

      // Executa a query
      TCQUERY cQuery1 NEW ALIAS 'OR1'             
      
      TCSetField("OR1","D2_EMISSAO","D", 8, 0)
      TCSetField("OR1","D2_TOTAL","N", 15, 2 )
                           
      // Seleciona o alias da pesquisa e manda o
      // cursor para o inicio
      DbSelectArea( 'OR1' )
      OR1->( DbGoTop() )
//   SetRegua( OR1->( RecCount() ) )

      // Enquanto nao for o fim do cursor... executa.
      WHILE OR1->( !Eof() ) 
	      cKeyNota:= OR1->D2_FILIAL+OR1->D2_DOC+OR1->D2_SERIE+OR1->D2_CLIENTE+OR1->D2_LOJA
	      nSaldoFin:=  0
	      nSaldoCtb:=  0
	      nSldCtbAnt:= 0
	      nSldCtbMes:= 0
	      nSldCtbPos:= 0
	      PrimVez:= .T.
          aAdd( aRetorno, ;
            {OR1->D2_EMISSAO, '', OR1->D2_SERIE, OR1->D2_DOC, '', OR1->D2_CLIENTE, OR1->D2_LOJA, OR1->A1_NREDUZ, ;
            '', '', 0, 0, "R", CTOD(SPACE(8)), DTOS(OR1->D2_EMISSAO)+OR1->A1_NREDUZ, OR1->A1_NREDUZ+DTOS(OR1->D2_EMISSAO), ;
            0, 0, 0, cKEYInc, cKEYInc1A, cKEYInc1B, aKEYBx } )

	      WHILE OR1->( !Eof() ) .AND. cKeyNota == OR1->D2_FILIAL+OR1->D2_DOC+OR1->D2_SERIE+OR1->D2_CLIENTE+OR1->D2_LOJA                                                 
	         // Chave para localiza a contabilizacao do item da nota
    	     cKeyInc:=  OR1->D2_FILIAL+OR1->D2_DOC+OR1->D2_SERIE+OR1->D2_CLIENTE+OR1->D2_LOJA+OR1->D2_COD+OR1->D2_ITEM
        	 nSaldoFin+= OR1->D2_TOTAL

            // Query que busca a contabilizacao DEBITO do item da nota fiscal
		 	cQuery2 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			cQuery2 += "FROM "+RetSqlName("CTK")+" "
			cQuery2 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	        cQuery2 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			cQuery2 += "AND CTK_KEY = '"+ALLTRIM(cKeyInc)+"' "
			cQuery2 += "AND CTK_LP IN ('520', '521', '523', '524', '530', '532') "
			cQuery2 += "AND CTK_VLR01 <> 0 "
			cQuery2 += "AND CTK_RECORI<>' ' "
			cQuery2 += "AND CTK_DEBITO IN ( "
			cQuery2 += "SELECT CT1_CONTA "
			cQuery2 += "FROM "+RetSqlName("CT1")+" "
			cQuery2 += "WHERE D_E_L_E_T_<>'*'  "
			cQuery2 += "AND CT1_CTASUP IN ('1120', '1121', '1122') ) "
	        TCQUERY cQuery2 NEW ALIAS 'OR2'

	        TCSetField("OR2","CTK_DATA","D", 8, 0 )
	        TCSetField("OR2","CTK_VLR01","N", 15, 2 )

			  // Acumula a contabilizacao da nota fiscal
		    WHILE OR2->( !Eof() )
		 	   nSaldoCtb += OR2->CTK_VLR01                     
		       If Substr(DTOS(OR2->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			      nSldCtbAnt += OR2->CTK_VLR01		
		       ElseIf Substr(DTOS(OR2->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			      nSldCtbMes += OR2->CTK_VLR01		
		       ElseIf Substr(DTOS(OR2->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			      nSldCtbPos += OR2->CTK_VLR01		
			   EndIf
		       OR2->( DbSkip() )   
		    ENDDO                                                  

            // Query que busca a contabilizacao CREDITO do item da nota fiscal
		 	cQuery3 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			cQuery3 += "FROM "+RetSqlName("CTK")+" "
			cQuery3 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	        cQuery3 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			cQuery3 += "AND CTK_KEY = '"+ALLTRIM(cKeyInc)+"' "
			cQuery3 += "AND CTK_LP IN ('520', '521', '523', '524', '530', '532') "
			cQuery3 += "AND CTK_VLR01 <> 0 "
			cQuery3 += "AND CTK_RECORI<>' ' "
			cQuery3 += "AND CTK_CREDIT IN ( "
			cQuery3 += "SELECT CT1_CONTA "
			cQuery3 += "FROM "+RetSqlName("CT1")+" "
			cQuery3 += "WHERE D_E_L_E_T_<>'*'  "
			cQuery3 += "AND CT1_CTASUP IN ('1120', '1121', '1122') )"
	        TCQUERY cQuery3 NEW ALIAS 'OR3'

	        TCSetField("OR3","CTK_DATA","D", 8, 0 )
	        TCSetField("OR3","CTK_VLR01","N", 15, 2 )

			// Acumula a contabilizacao da nota fiscal
		    WHILE OR3->( !Eof() )
		 	   nSaldoCtb -= OR3->CTK_VLR01                     
		       If Substr(DTOS(OR3->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			      nSldCtbAnt -= OR3->CTK_VLR01		
		       ElseIf Substr(DTOS(OR3->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			      nSldCtbMes -= OR3->CTK_VLR01		
		       ElseIf Substr(DTOS(OR3->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			      nSldCtbPos -= OR3->CTK_VLR01		
			   EndIf
		       OR3->( DbSkip() )   
		    ENDDO                                                  

            If PrimVez
               PrimVez:= .F.			
			   cQuery4 := "SELECT *  "
         	   cQuery4 += "FROM "+RetSqlName("SE5")+" SE5 "
         	   cQuery4 += "INNER JOIN "+RetSqlName("SE1")+" SE1 "
         	   cQuery4 += "	ON E5_FILIAL=E1_FILIAL AND E5_NUMERO=E1_NUM AND E5_PREFIXO=E1_PREFIXO AND E5_PARCELA=E1_PARCELA "
         	   cQuery4 += "WHERE SE5.D_E_L_E_T_<>'*' AND SE1.D_E_L_E_T_<>'*' "
         	   cQuery4 += "AND E5_FILIAL='"+xFILIAL("SE5")+"' "
         	   cQuery4 += "AND E5_NUMERO='"+OR1->D2_DOC+"' "
         	   cQuery4 += "AND E5_PREFIXO='"+OR1->D2_SERIE+"' "
         	   cQuery4 += "AND E5_CLIFOR='"+OR1->D2_CLIENTE+"' "
         	   cQuery4 += "AND E5_LOJA='"+OR1->D2_LOJA+"' "
         	   cQuery4 += "AND E5_DATA>='"+DTOS(dDtProc)+"' AND E5_DATA<='"+DTOS(dDtBase)+"' "
         	   cQuery4 += "AND E5_TIPODOC IN ('BA', 'VL', 'ES', 'CP', 'RA', 'PA') "
         	   cQuery4 += "AND E5_TIPO='NF' "
         	   cQuery4 += "AND E5_SITUACA<>'C' "

         	   TCQUERY cQuery4 NEW ALIAS 'OR4'

	           TCSetField("OR4","E5_DATA","D", 8, 0 )

               DbSelectArea( 'OR4' )
               OR4->( DbGotop() )
            
               WHILE OR4->( !EOF() )           

                  cKeyBx := ; 
                     OR4->E5_FILIAL+OR4->E5_TIPODOC+OR4->E5_PREFIXO+OR4->E5_NUMERO+OR4->E5_PARCELA+;
                     OR4->E5_TIPO+DTOS(OR4->E5_DATA)+OR4->E5_CLIFOR+OR4->E5_LOJA+OR4->E5_SEQ 

                  nSaldoBai+= (OR4->E5_VALOR-OR4->E5_VLMULTA-OR4->E5_VLJUROS+OR4->E5_VLDESCO)

		 	      cQuery5 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			      cQuery5 += "FROM "+RetSqlName("CTK")+" "
			      cQuery5 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
		          cQuery5 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			      cQuery5 += "AND CTK_KEY = '"+ALLTRIM(cKeyBx)+"' "
			      cQuery5 += "AND CTK_LP IN ('610', '640', '650', '655') "
			      cQuery5 += "AND CTK_VLR01 <> 0 "
			      cQuery5 += "AND CTK_RECORI<>' ' "
			      cQuery5 += "AND CTK_DEBITO IN ( "
			      cQuery5 += "SELECT CT1_CONTA "
			      cQuery5 += "FROM "+RetSqlName("CT1")+" "
			      cQuery5 += "WHERE D_E_L_E_T_<>'*'  "
			      cQuery5 += "AND CT1_CTASUP IN ('1120', '1121', '1122') ) "

	              TCQUERY cQuery5 NEW ALIAS 'OR5'
			      // Acumula a contabilizacao da Baixa da nota fiscal 
			   
	              TCSetField("OR5","CTK_DATA","D", 8, 0 )
	              TCSetField("OR5","CTK_VLR01","N", 15, 2 )

		          WHILE OR5->( !Eof() )
		 	         nSaldoCtb += OR5->CTK_VLR01                     
		             If Substr(DTOS(OR5->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			            nSldCtbAnt += OR5->CTK_VLR01		
		             ElseIf Substr(DTOS(OR5->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			            nSldCtbMes += OR5->CTK_VLR01		
		             ElseIf Substr(DTOS(OR5->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			            nSldCtbPos += OR5->CTK_VLR01		
			         EndIf
		             OR5->( DbSkip() )   
		          ENDDO                                                  

		 	      cQuery6 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			      cQuery6 += "FROM "+RetSqlName("CTK")+" "
			      cQuery6 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	              cQuery6 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			      cQuery6 += "AND CTK_KEY = '"+ALLTRIM(cKeyBx)+"' "
			      cQuery6 += "AND CTK_LP IN ('610', '640', '650', '655') "
			      cQuery6 += "AND CTK_VLR01 <> 0 "
			      cQuery6 += "AND CTK_RECORI<>' ' "
			      cQuery6 += "AND CTK_CREDIT IN ( "
			      cQuery6 += "SELECT CT1_CONTA "
			      cQuery6 += "FROM "+RetSqlName("CT1")+" "
			      cQuery6 += "WHERE D_E_L_E_T_<>'*'  "
			      cQuery6 += "AND CT1_CTASUP IN ('1120', '1121', '1122') ) "

	              TCQUERY cQuery6 NEW ALIAS 'OR6'

	              TCSetField("OR6","CTK_DATA","D", 8, 0 )
 	              TCSetField("OR6","CTK_VLR01","N", 15, 2 )
	           
			      // Acumula a contabilizacao da Baixa da nota fiscal 
		          WHILE OR6->( !Eof() )
		 	         nSaldoCtb -= OR6->CTK_VLR01                     
		             If Substr(DTOS(OR6->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			            nSldCtbAnt -= OR6->CTK_VLR01		
		             ElseIf Substr(DTOS(OR6->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			            nSldCtbMes -= OR6->CTK_VLR01		
		             ElseIf Substr(DTOS(OR6->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			            nSldCtbPos -= OR6->CTK_VLR01		
			         EndIf
		             OR6->( DbSkip() )   
		          ENDDO
	              OR5->( DbCloseArea() )
	              OR6->( DbCloseArea() )
		          OR4->( DbSkip() )
               ENDDO
            EndIf   
            OR2->( DbCloseArea() )
            OR3->( DbCloseArea() )
            OR4->( DbCloseArea() )
       	    OR1->( DbSkip() )   
         ENDDO
         nlItem:= Len(aRetorno)
//         IF (nSldCtbAnt > 0) .OR. (nSldCtbPos > 0) .OR. (nSaldoFin <> nSaldoCtb)
            aRetorno[nlItem,11]:= nSaldoCtb
            aRetorno[nlItem,12]:= nSaldoFin
            aRetorno[nlItem,17]:= nSldCtbAnt
            aRetorno[nlItem,18]:= nSldCtbMes
            aRetorno[nlItem,19]:= nSldCtbPos
//         ELSE 
//            ADEL(aRetorno, nlItem)
//            nlItem--
//         ENDIF
//         IF nlItem == 0
//         	aRetorno := {}
//         ENDIF
//      cQuery1 := "SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, D2_EMISSAO, D2_TOTAL "
//         IF (nSldCtbAnt > 0) .OR. (nSldCtbPos > 0) .OR. (nSaldoFin <> nSaldoCtb)
//            aAdd( aRetorno, ;
//               {OR4->E1_EMISSAO, OR4->E1_TIPO, OR4->E1_PREFIXO, OR4->E1_NUM, OR4->E1_PARCELA, OR4->E1_CLIENTE, OR4->E1_LOJA, OR4->E1_NOMCLI, ;
//               OR4->E1_BAIXA, OR4->E1_NATUREZ, nSaldoCtb, nSaldoFin, "R", OR4->E1_VENCTO, DTOS(OR4->E1_EMISSAO)+OR4->E1_NOMCLI, OR4->E1_NOMCLI+DTOS(OR4->E1_EMISSAO), ;
//               nSldCtbAnt, nSldCtbMes, nSldCtbPos, cKEYInc, cKEYInc1A, cKEYInc1B, aKEYBx } )
//         ENDIF

      ENDDO
   ELSE
   //Adiciona os titulos a receber a partir da data de processamento
      cQuery1 := "SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_DTDIGIT, (D1_TOTAL-D1_VALDESC-D1_VALIRR) AS D1_TOTAL, A2_NREDUZ "
      cQuery1 += "FROM "+RetSqlName("SD1")+" SD1 "
      cQuery1 += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.D_E_L_E_T_<>'*' AND A2_COD=D1_FORNECE AND A2_LOJA=D1_LOJA  "      
      cQuery1 += "WHERE SD1.D_E_L_E_T_<>'*' AND D1_DTDIGIT >= '"+DTOS(dDtProc)+"' AND D1_DTDIGIT <= '"+DTOS(dDtBase)+"' "   
      cQuery1 += "AND D1_FILIAL = '"+xFILIAL("SD1")+"' "  
      cQuery1 += "AND D1_FORNECE >= '"+cCliForDe+"' AND D1_FORNECE <= '"+cCliForAte+"' "  
      cQuery1 += "ORDER BY D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA "

      // Executa a query
      TCQUERY cQuery1 NEW ALIAS 'OR1'

      TCSetField("OR1","D1_DTDIGIT","D", 8, 0 )
      TCSetField("OR1","D1_TOTAL","N", 15, 2 )

      // Seleciona o alias da pesquisa e manda o
      // cursor para o inicio
      DbSelectArea( 'OR1' )
      OR1->( DbGoTop() )
//   SetRegua( OR1->( RecCount() ) )

      // Enquanto nao for o fim do cursor... executa.
      WHILE OR1->( !Eof() ) 
	      cKeyNota:= OR1->D1_FILIAL+OR1->D1_DOC+OR1->D1_SERIE+OR1->D1_FORNECE+OR1->D1_LOJA
	      nSaldoFin:=  0
	      nSaldoCtb:=  0
	      nSldCtbAnt:= 0
	      nSldCtbMes:= 0
	      nSldCtbPos:= 0

          aAdd( aRetorno, ;
            {OR1->D1_DTDIGIT, '', OR1->D1_SERIE, OR1->D1_DOC, '', OR1->D1_FORNECE, OR1->D1_LOJA, OR1->A2_NREDUZ, ;
            '', '', 0, 0, "P", CTOD(SPACE(8)), DTOS(OR1->D1_DTDIGIT)+OR1->A2_NREDUZ, OR1->A2_NREDUZ+DTOS(OR1->D1_DTDIGIT), ;
            0, 0, 0, cKEYInc, cKEYInc1A, cKEYInc1B, aKEYBx } )

	      WHILE OR1->( !Eof() ) .AND. cKeyNota == OR1->D1_FILIAL+OR1->D1_DOC+OR1->D1_SERIE+OR1->D1_FORNECE+OR1->D1_LOJA                                                 
	         // Chave para localiza a contabilizacao do item da nota
    	     cKeyInc:=  OR1->D1_FILIAL+OR1->D1_DOC+OR1->D1_SERIE+OR1->D1_FORNECE+OR1->D1_LOJA+OR1->D1_COD+OR1->D1_ITEM
        	 nSaldoFin+= OR1->D1_TOTAL

            // Query que busca a contabilizacao DEBITO do item da nota fiscal
		 	cQuery2 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			cQuery2 += "FROM "+RetSqlName("CTK")+" "
			cQuery2 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	        cQuery2 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			cQuery2 += "AND CTK_KEY = '"+ALLTRIM(cKeyInc)+"' "
			cQuery2 += "AND CTK_LP IN ('610', '640', '650', '655') "
			cQuery2 += "AND CTK_VLR01 <> 0 "
			cQuery2 += "AND CTK_RECORI<>' ' "
			cQuery2 += "AND ( CTK_DEBITO IN ( "
			cQuery2 += "SELECT CT1_CONTA "
			cQuery2 += "FROM "+RetSqlName("CT1")+" "
			cQuery2 += "WHERE D_E_L_E_T_<>'*'  "
			cQuery2 += "AND CT1_CTASUP IN ('2110', '2111', '2112') ) "
			cQuery2 += "OR (CTK_CREDIT = '42300014') ) "
	        TCQUERY cQuery2 NEW ALIAS 'OR2'

	        TCSetField("OR2","CTK_DATA","D", 8, 0 )
	        TCSetField("OR2","CTK_VLR01","N", 15, 2 )

			  // Acumula a contabilizacao da nota fiscal
		    WHILE OR2->( !Eof() )
		 	   nSaldoCtb -= OR2->CTK_VLR01                     
		       If Substr(DTOS(OR2->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			      nSldCtbAnt -= OR2->CTK_VLR01		
		       ElseIf Substr(DTOS(OR2->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			      nSldCtbMes -= OR2->CTK_VLR01		
		       ElseIf Substr(DTOS(OR2->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			      nSldCtbPos -= OR2->CTK_VLR01		
			   EndIf
		       OR2->( DbSkip() )   
		    ENDDO                                                  

            // Query que busca a contabilizacao CREDITO do item da nota fiscal
		 	cQuery3 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			cQuery3 += "FROM "+RetSqlName("CTK")+" "
			cQuery3 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	        cQuery3 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			cQuery3 += "AND CTK_KEY = '"+ALLTRIM(cKeyInc)+"' "
			cQuery3 += "AND CTK_LP IN ('610', '640', '650', '655') "
			cQuery3 += "AND CTK_VLR01 <> 0 "
			cQuery3 += "AND CTK_RECORI<>' ' "
			cQuery3 += "AND ( CTK_CREDIT IN ( "
			cQuery3 += "SELECT CT1_CONTA "
			cQuery3 += "FROM "+RetSqlName("CT1")+" "
			cQuery3 += "WHERE D_E_L_E_T_<>'*'  "
			cQuery3 += "AND CT1_CTASUP IN ('2110', '2111', '2112') ) "
			cQuery3 += "OR (CTK_DEBITO = '42300014') ) "
	        TCQUERY cQuery3 NEW ALIAS 'OR3'

	        TCSetField("OR3","CTK_DATA","D", 8, 0 )
	        TCSetField("OR3","CTK_VLR01","N", 15, 2 )

			// Acumula a contabilizacao da nota fiscal
		    WHILE OR3->( !Eof() )
		 	   nSaldoCtb += OR3->CTK_VLR01                     
		       If Substr(DTOS(OR3->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			      nSldCtbAnt += OR3->CTK_VLR01		
		       ElseIf Substr(DTOS(OR3->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			      nSldCtbMes += OR3->CTK_VLR01		
		       ElseIf Substr(DTOS(OR3->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			      nSldCtbPos += OR3->CTK_VLR01		
			   EndIf
		       OR3->( DbSkip() )   
		    ENDDO                                                  

			
			cQuery4 := "SELECT *  "
         	cQuery4 += "FROM "+RetSqlName("SE5")+" SE5 "
         	cQuery4 += "INNER JOIN "+RetSqlName("SE2")+" SE2 "
         	cQuery4 += "	ON E5_FILIAL=E2_FILIAL AND E5_NUMERO=E2_NUM AND E5_PREFIXO=E2_PREFIXO AND E5_PARCELA=E2_PARCELA "
         	cQuery4 += "	AND E5_CLIFOR=E2_FORNECE AND E5_LOJA=E2_LOJA "
         	cQuery4 += "WHERE SE5.D_E_L_E_T_<>'*' AND SE2.D_E_L_E_T_<>'*' "
         	cQuery4 += "AND E5_FILIAL='"+xFILIAL("SE5")+"' "
         	cQuery4 += "AND E5_NUMERO='"+OR1->D1_DOC+"' "
         	cQuery4 += "AND E5_PREFIXO='"+OR1->D1_SERIE+"' "
         	cQuery4 += "AND E5_CLIFOR='"+OR1->D1_FORNECE+"' "
         	cQuery4 += "AND E5_LOJA='"+OR1->D1_LOJA+"' "
         	cQuery4 += "AND E5_DATA>='"+DTOS(dDtProc)+"' AND E5_DATA<='"+DTOS(dDtBase)+"' "
         	cQuery4 += "AND E5_TIPODOC IN ('BA', 'VL', 'ES', 'CP', 'RA', 'PA') "
         	cQuery4 += "AND E5_TIPO='NF' "
         	cQuery4 += "AND E5_SITUACA<>'C' "

         	TCQUERY cQuery4 NEW ALIAS 'OR4'

	        TCSetField("OR4","E5_DATA","D", 8, 0 )

            DbSelectArea( 'OR4' )
            OR4->( DbGotop() )
            
            WHILE OR4->( !EOF() )           

               cKeyBx := ; 
                  OR4->E5_FILIAL+OR4->E5_TIPODOC+OR4->E5_PREFIXO+OR4->E5_NUMERO+OR4->E5_PARCELA+;
                  OR4->E5_TIPO+DTOS(OR4->E5_DATA)+OR4->E5_CLIFOR+OR4->E5_LOJA+OR4->E5_SEQ 

               nSaldoBai+= (OR4->E5_VALOR-OR4->E5_VLMULTA-OR4->E5_VLJUROS+OR4->E5_VLDESCO)

		 	   cQuery5 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			   cQuery5 += "FROM "+RetSqlName("CTK")+" "
			   cQuery5 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	           cQuery5 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			   cQuery5 += "AND CTK_KEY = '"+ALLTRIM(cKeyBx)+"' "
			   cQuery5 += "AND CTK_LP IN ('610', '640', '650', '655') "
			   cQuery5 += "AND CTK_VLR01 <> 0 "
			   cQuery5 += "AND CTK_RECORI<>' ' "
			   cQuery5 += "AND ( CTK_DEBITO IN ( "
			   cQuery5 += "SELECT CT1_CONTA "
			   cQuery5 += "FROM "+RetSqlName("CT1")+" "
			   cQuery5 += "WHERE D_E_L_E_T_<>'*'  "
			   cQuery5 += "AND CT1_CTASUP IN ('2110', '2111', '2112') ) "
			   cQuery5 += "OR (CTK_CREDIT = '42300014') ) "

	           TCQUERY cQuery5 NEW ALIAS 'OR5'

  	           TCSetField("OR5","CTK_DATA","D", 8, 0 )
	           TCSetField("OR5","CTK_VLR01","N", 15, 2 )

			   // Acumula a contabilizacao da Baixa da nota fiscal 
		       WHILE OR5->( !Eof() )
		 	      nSaldoCtb - OR5->CTK_VLR01                     
		          If Substr(DTOS(OR5->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			         nSldCtbAnt -= OR5->CTK_VLR01		
		          ElseIf Substr(DTOS(OR5->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			         nSldCtbMes -= OR5->CTK_VLR01		
		          ElseIf Substr(DTOS(OR5->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			         nSldCtbPos -= OR5->CTK_VLR01		
			      EndIf
		          OR5->( DbSkip() )   
		       ENDDO                                                  


		 	   cQuery6 := "SELECT DISTINCT CTK_FILIAL, CTK_LP, CTK_VLR01, CTK_RECORI, CTK_DATA, CTK_DEBITO, CTK_KEY "	
			   cQuery6 += "FROM "+RetSqlName("CTK")+" "
			   cQuery6 += "WHERE D_E_L_E_T_<>'*' AND CTK_FILIAL='"+XFILIAL("CTK")+"' "
	           cQuery6 += "AND CTK_DATA >= '"+DTOS(dContabDe)+"' AND CTK_DATA <= '"+DTOS(dContabAte)+"' "   
			   cQuery6 += "AND CTK_KEY = '"+ALLTRIM(cKeyBx)+"' "
			   cQuery6 += "AND CTK_LP IN ('610', '640', '650', '655') "
			   cQuery6 += "AND CTK_VLR01 <> 0 "
			   cQuery6 += "AND CTK_RECORI<>' ' "
			   cQuery6 += "AND ( CTK_CREDIT IN ( "
			   cQuery6 += "SELECT CT1_CONTA "
			   cQuery6 += "FROM "+RetSqlName("CT1")+" "
			   cQuery6 += "WHERE D_E_L_E_T_<>'*'  "
			   cQuery6 += "AND CT1_CTASUP IN ('2110', '2111', '2112') ) "
			   cQuery6 += "OR (CTK_DEBITO = '42300014') ) "

	           TCQUERY cQuery6 NEW ALIAS 'OR6'
   	           TCSetField("OR6","CTK_DATA","D", 8, 0 )
	           TCSetField("OR6","CTK_VLR01","N", 15, 2 )
			   // Acumula a contabilizacao da Baixa da nota fiscal 
		       WHILE OR6->( !Eof() )
		 	      nSaldoCtb += OR6->CTK_VLR01                     
		          If Substr(DTOS(OR6->CTK_DATA),1,6) < Substr(Dtos(dDtBase),1,6)
			         nSldCtbAnt += OR6->CTK_VLR01		
		          ElseIf Substr(DTOS(OR6->CTK_DATA),1,6) = Substr(Dtos(dDtBase),1,6)
			         nSldCtbMes += OR6->CTK_VLR01		
		          ElseIf Substr(DTOS(OR6->CTK_DATA),1,6) > Substr(Dtos(dDtBase),1,6)
			         nSldCtbPos += OR6->CTK_VLR01		
			      EndIf
		          OR6->( DbSkip() )   
		       ENDDO

	           OR5->( DbCloseArea() )
	           OR6->( DbCloseArea() )
		       OR4->( DbSkip() )
            ENDDO   
            OR2->( DbCloseArea() )
            OR3->( DbCloseArea() )
            OR4->( DbCloseArea() )

       	    OR1->( DbSkip() )   
         ENDDO
//      cQuery1 := "SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_DTDIGIT, D1_TOTAL, A2_NREDUZ "

         nlItem:= Len(aRetorno)
//         IF (nSldCtbAnt > 0) .OR. (nSldCtbPos > 0) .OR. (nSaldoFin <> nSaldoCtb)
            aRetorno[nlItem,11]:= nSaldoCtb
            aRetorno[nlItem,12]:= nSaldoFin
            aRetorno[nlItem,17]:= nSldCtbAnt
            aRetorno[nlItem,18]:= nSldCtbMes
            aRetorno[nlItem,19]:= nSldCtbPos
//         ELSE 
//            ADEL(aRetorno, nlItem)
//            nlItem--
//         ENDIF      
//         IF nlItem == 0
//         	aRetorno := {}
//         ENDIF


//         IF (nSldCtbAnt > 0) .OR. (nSldCtbPos > 0) .OR. (nSaldoFin <> nSaldoCtb)
//            aAdd( aRetorno, ;
//            {OR1->D1_DTDIGIT, OR4->E2_TIPO, OR4->E2_PREFIXO, OR4->E2_NUM, OR4->E2_PARCELA, OR4->E2_FORNECE, OR4->E2_LOJA, OR4->E2_NOMFOR, ;
//            OR4->E2_BAIXA, OR4->E2_NATUREZ, nSaldoCtb, nSaldoFin, "P", OR4->E2_VENCTO, DTOS(OR1->D1_DTDIGIT)+OR4->E2_NOMFOR, OR4->E2_NOMFOR+DTOS(OR1->D1_DTDIGIT), ;
//            nSldCtbAnt, nSldCtbMes, nSldCtbPos, cKEYInc, cKEYInc1A, cKEYInc1B, aKEYBx } )
//         ENDIF
      ENDDO
      OR1->( DbCloseArea() )
   ENDIF
Return(aRetorno)
/************************************************************************
* Funcao para transformar a data para o formato SQL
************************************************************************/
STATIC FUNCTION formataData( dData )
   LOCAL cReturn := ""

   IF !Empty( dData )
      cReturn += Str( Year( dData ), 4 )
      cReturn += StrZero( Month( dData ), 2 )
      cReturn += StrZero( Day( dData ),   2 )
   ENDIF
RETURN cReturn

/************************************************************************
* Funcao para transformar a data da base de dados na forma tradicional.
* De 20050520 para 20/05/2005 (básico)
************************************************************************/
STATIC FUNCTION getData( sdata )
   IF Empty( sdata )
      RETURN "  /  /"
   ENDIF
RETURN substr( sdata, 7, 2 ) + "/" + substr( sdata, 5, 2 ) + "/" +  substr( sdata, 0, 4 )
STATIC FUNCTION ImpCabec()
	// Define a referência de datas no relatório.
   Cabec1 := "Data Financeiro : " + DTOC(MV_PAR01)+" Ate "+DTOC(MV_PAR02)+"  /  Data Contabil : " + DTOC(MV_PAR03)+" Ate "+DTOC(MV_PAR04)
   IF MV_PAR05 == 1   
	   Cabec2 := "Cliente : " + MV_PAR09+" Ate "+MV_PAR10+"  /  "+IIF(MV_PAR06=1,"Ordem por Emissao / Cliente", "Ordem por Cliente / Emissao")
   ELSE
	   Cabec2 := "Fornecedor : " + MV_PAR07+" Ate "+MV_PAR08+"  /  "+IIF(MV_PAR06=1,"Ordem por Emissao / Fornecedor", "Ordem por Fornecedor / Emissao")
   ENDIF
   Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )

   nLin := 9
   IF MV_PAR05 == 1   
   		cbc := "|   DATA    |   VENCTO  |NUMERO TITULO         |CLIENTE                                      | VALOR CTB ANT    | VALOR CTB MES    | VALOR CTB POS    | VALOR CONTÁBIL   |  VALOR FINANCEIRO | VALOR DA DIFERENÇA |"
	ELSE
   		cbc := "|   DATA    |   VENCTO  |NUMERO TITULO         |FORNECEDOR                                   | VALOR CTB ANT    | VALOR CTB MES    | VALOR CTB POS    | VALOR CONTÁBIL   |  VALOR FINANCEIRO | VALOR DA DIFERENÇA |"
   ENDIF
        // |   DATA    |   VENCTO  |NUMERO TITULO         |CLIENTE                                      | VALOR CTB ANT    | VALOR CTB MES    | VALOR CTB POS    | VALOR CONTÁBIL   |  VALOR FINANCEIRO | VALOR DA DIFERENÇA |                          
        // |99/99/9999 |99/99/9999 |XXX/XXX-XXXXXXXXX-XXX |XXXXXX/XX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | 999.999.999,99 D | 999.999.999,99 D | 999.999.999,99 D | 999.999.999,99 D |  999.999.999,99 D |  999.999.999,99 D  |                                  
        // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        //           10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
        //                      1          2         3         4          5          6         7         8         9         10         11 12
        // aAdd( paTitulos, {E1_EMISSAO, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_BAIXA, E1_NATUREZ, 0, 0} )

   @nLin++, 00 PSAY cbc
   @nLin++, 00 PSAY Replicate( "-", 220 )
   nLin++
RETURN NIL

STATIC FUNCTION ImpDet()
//   @nLin, 000 PSAY  "|"+getData(arows[nInc][1])
//   @nLin, 010 PSAY  "|"+getData(arows[nInc][14])
   @nLin, 000 PSAY  "|"+DTOC(arows[nInc][1])
   @nLin, 010 PSAY  "|"+DTOC(arows[nInc][14])
   @nLin, 020 PSAY  "|"+arows[nInc][2]+"/"+arows[nInc][3]+"-"+arows[nInc][4]+"-"+arows[nInc][5]
   @nLin, 043 PSAY  "|"+arows[nInc][6]+"/"+arows[nInc][7]+"-"+arows[nInc][8]
   If cNumero <> arows[nInc, 4]
	   @nLin, 093 PSAY  "| "+Transform( arows[nInc][17], "@ez 999,999,999.99" )
   Else
	   @nLin, 093 PSAY  "| "
   Endif
   IF MV_PAR05 == 1
      IF arows[nInc][17] > 0
         @nLin, 110 PSAY  "D"
      ELSE
         @nLin, 110 PSAY  "C"
      ENDIF
   ELSE
      IF arows[nInc][17] < 0
         @nLin, 110 PSAY  "D"
      ELSE
         @nLin, 110 PSAY  "C"
      ENDIF
   ENDIF                   
   If cNumero <> arows[nInc, 4]
	   @nLin, 112 PSAY  "| "+Transform( arows[nInc][18], "@ez 999,999,999.99" )
   Else
	   @nLin, 112 PSAY  "| "
   EndIf
   IF MV_PAR05 == 1
      IF arows[nInc][18] > 0
         @nLin, 129 PSAY  "D"
      ELSE
         @nLin, 129 PSAY  "C"
      ENDIF
   ELSE
      IF arows[nInc][18] < 0
         @nLin, 129 PSAY  "D"
      ELSE
         @nLin, 129 PSAY  "C"
      ENDIF
   ENDIF   
   If cNumero <> arows[nInc, 4]
	   @nLin, 131 PSAY  "| "+Transform( arows[nInc][19], "@ez 999,999,999.99" )
   Else
	   @nLin, 131 PSAY  "| "
   Endif
   IF MV_PAR05 == 1
      IF arows[nInc][19] > 0
         @nLin, 148 PSAY  "D"
      ELSE
         @nLin, 148 PSAY  "C"
      ENDIF
   ELSE
      IF arows[nInc][19] < 0
         @nLin, 148 PSAY  "D"
      ELSE
         @nLin, 148 PSAY  "C"
      ENDIF
   ENDIF   
   If cNumero <> arows[nInc, 4]
	   @nLin, 150 PSAY  "| "+Transform( arows[nInc][11], "@ez 999,999,999.99" )
   Else
	   @nLin, 150 PSAY  "| "
   Endif
   IF MV_PAR05 == 1
      IF arows[nInc][11] > 0
         @nLin, 167 PSAY  "D"
      ELSE
         @nLin, 167 PSAY  "C"
      ENDIF
   ELSE
      IF arows[nInc][11] < 0
         @nLin, 167 PSAY  "D"
      ELSE
         @nLin, 167 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 169 PSAY  "| "+Transform( arows[nInc][12], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF arows[nInc][12] > 0
         @nLin, 187 PSAY  "D"
      ELSE
         @nLin, 187 PSAY  "C"
      ENDIF
   ELSE
      IF arows[nInc][12] < 0
         @nLin, 187 PSAY  "D"
      ELSE
         @nLin, 187 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 189 PSAY  "| "+Transform( arows[nInc][11]-arows[nInc][12], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF arows[nInc][11]-arows[nInc][12] > 0
         @nLin, 207 PSAY  "D |"
      ELSE
         @nLin, 207 PSAY  "C |"
      ENDIF
   ELSE
      IF arows[nInc][11]-arows[nInc][12] < 0
         @nLin, 207 PSAY  "D |"
      ELSE
         @nLin, 207 PSAY  "C |"
      ENDIF
   ENDIF   
	
	cNumero:= arows[nInc, 4]

   nLin++
RETURN NIL

// Acumula Sub-Total
STATIC FUNCTION AcumSubT()
   aSubTotal[1]+= arows[nInc][11]
   aSubTotal[2]+= arows[nInc][12]
   aSubTotal[3]+= arows[nInc][11]-arows[nInc][12]
   aSubTotal[4]+= arows[nInc][17]
   aSubTotal[5]+= arows[nInc][18]
   aSubTotal[6]+= arows[nInc][19]
RETURN NIL

// Acumula Total-Geral
STATIC FUNCTION AcumTotG()
   aTotal[1]+= arows[nInc][11]
   aTotal[2]+= arows[nInc][12]
   aTotal[3]+= arows[nInc][11]-arows[nInc][12]
   aTotal[4]+= arows[nInc][17]
   aTotal[5]+= arows[nInc][18]
   aTotal[6]+= arows[nInc][19]
RETURN NIL

STATIC FUNCTION ImpSubT()
   @nLin++,  00 PSAY Replicate( "-", 220 )
   @nLin,    00 PSAY "SUB-TOTAL"

   @nLin, 093 PSAY  "| "+Transform( aSubTotal[4], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aSubTotal[4] > 0
         @nLin, 110 PSAY  "D"
      ELSE
         @nLin, 110 PSAY  "C"
      ENDIF
   ELSE
      IF aSubTotal[4] < 0
         @nLin, 110 PSAY  "D"
      ELSE
         @nLin, 110 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 112 PSAY  "| "+Transform( aSubTotal[5], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aSubTotal[5] > 0
         @nLin, 129 PSAY  "D"
      ELSE
         @nLin, 129 PSAY  "C"
      ENDIF
   ELSE
      IF aSubTotal[5] < 0
         @nLin, 129 PSAY  "D"
      ELSE
         @nLin, 129 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 131 PSAY  "| "+Transform( aSubTotal[6], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aSubTotal[6] > 0
         @nLin, 144 PSAY  "D"
      ELSE
         @nLin, 144 PSAY  "C"
      ENDIF
   ELSE
      IF aSubTotal[6] < 0
         @nLin, 144 PSAY  "D"
      ELSE
         @nLin, 144 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 150 PSAY  "| "+Transform( aSubTotal[1], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aSubTotal[1] > 0
         @nLin, 167 PSAY  "D"
      ELSE
         @nLin, 167 PSAY  "C"
      ENDIF
   ELSE
      IF aSubTotal[1] < 0
         @nLin, 167 PSAY  "D"
      ELSE
         @nLin, 167 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 169 PSAY  "| "+Transform( aSubTotal[2], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aSubTotal[2] > 0
         @nLin, 187 PSAY  "D"
      ELSE
         @nLin, 187 PSAY  "C"
      ENDIF
   ELSE
      IF aSubTotal[2] < 0
         @nLin, 187 PSAY  "D"
      ELSE
         @nLin, 187 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 189 PSAY  "| "+Transform( aSubTotal[3], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aSubTotal[3] > 0
         @nLin, 207 PSAY  "D |"
      ELSE
         @nLin, 207 PSAY  "C |"
      ENDIF
   ELSE
      IF aSubTotal[3] < 0
         @nLin, 207 PSAY  "D |"
      ELSE
         @nLin, 207 PSAY  "C |"
      ENDIF
   ENDIF   

   nLin++
   @nLin++,  00 PSAY Replicate( "-", 220 )
RETURN NIL

STATIC FUNCTION ImpTotG()
   @nLin++,  00 PSAY Replicate( "-", 220 )
   @nLin,    00 PSAY "TOTAL GERAL"
   @nLin, 093 PSAY  "| "+Transform( aTotal[4], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aTotal[4] > 0
         @nLin, 110 PSAY  "D"
      ELSE
         @nLin, 110 PSAY  "C"
      ENDIF
   ELSE
      IF aTotal[4] < 0
         @nLin, 110 PSAY  "D"
      ELSE
         @nLin, 110 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 112 PSAY  "| "+Transform( aTotal[5], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aTotal[5] > 0
         @nLin, 129 PSAY  "D"
      ELSE
         @nLin, 129 PSAY  "C"
      ENDIF
   ELSE
      IF aTotal[5] < 0
         @nLin, 129 PSAY  "D"
      ELSE
         @nLin, 129 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 131 PSAY  "| "+Transform( aTotal[6], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aTotal[6] > 0
         @nLin, 148 PSAY  "D"
      ELSE
         @nLin, 148 PSAY  "C"
      ENDIF
   ELSE
      IF aTotal[6] < 0
         @nLin, 148 PSAY  "D"
      ELSE
         @nLin, 148 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 150 PSAY  "| "+Transform( aTotal[1], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aTotal[1] > 0
         @nLin, 167 PSAY  "D"
      ELSE
         @nLin, 167 PSAY  "C"
      ENDIF
   ELSE
      IF aTotal[1] < 0
         @nLin, 167 PSAY  "D"
      ELSE
         @nLin, 167 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 169 PSAY  "| "+Transform( aTotal[2], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aTotal[2] > 0
         @nLin, 187 PSAY  "D"
      ELSE
         @nLin, 187 PSAY  "C"
      ENDIF
   ELSE
      IF aTotal[2] < 0
         @nLin, 187 PSAY  "D"
      ELSE
         @nLin, 187 PSAY  "C"
      ENDIF
   ENDIF   
   @nLin, 189 PSAY  "| "+Transform( aTotal[3], "@ez 999,999,999.99" )
   IF MV_PAR05 == 1
      IF aTotal[3] > 0
         @nLin, 207 PSAY  "D |"
      ELSE
         @nLin, 207 PSAY  "C |"
      ENDIF
   ELSE
      IF aTotal[3] < 0
         @nLin, 207 PSAY  "D |"
      ELSE
         @nLin, 207 PSAY  "C |"
      ENDIF
   ENDIF   

   nLin++
   @nLin++, 00 PSAY Replicate( "-", 220 )
RETURN NIL
           
