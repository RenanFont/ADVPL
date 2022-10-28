//------------------------------------------------------------------------------------//
//Empresa...:
//Projeto...: RELATÓRIOS GERENCIAIS
//Funcao....:
//Autor.....:
//Data......:
//Uso.......: RELATÓRIO DE  FRETE
//Versao....:
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
//#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

*----------------------------------------------------------------------------*
USER FUNCTION GERR003()
*----------------------------------------------------------------------------*
PRIVATE cDATAInicio	:= DATE()
PRIVATE cDATAFim	:= DATE()
PRIVATE dDATA		:= dDATABASE
PRIVATE cUN			:= PADR(" ", 100)
PRIVATE cEQUIPE		:= PADR(" ", 100)
PRIVATE cVENDEDOR	:= PADR(" ", 100)
PRIVATE cZONA		:= PADR(" ", 100)
PRIVATE cPRODUTO	:= PADR(" ", 100)
PRIVATE cCLIENTE	:= PADR(" ", 100)
PRIVATE cCNPJ		:= PADR(" ", 100)
/// mudanca inicio 1
PRIVATE cUFTARG		:= PADR(" ", 100)
PRIVATE cCEPINI		:= PADR(" ", 5)
PRIVATE cCEPFIM		:= PADR("ZZZZZ", 5)
PRIVATE cCODTARG	:= PADR(" ", 100)
/// mudanca final 1
PRIVATE nOPCA	:= 2
PRIVATE aCOLS	:= {}

PRIVATE cPath       := ""
PRIVATE cFileName   := ""
PRIVATE cTipoEmp    := ""
PRIVATE cDestino    := ""
PRIVATE aTpFile		:= {"1-Não Abrir C/ Excel", "2-Abrir Com Excel"}
PRIVATE oTpFile
PRIVATE cTpFile
PRIVATE aTpRel		:= {"1-Sintetico", "2-Analitico"}
PRIVATE cTpRel
PRIVATE oTpRel
PRIVATE aDistr		:= {"1-Omamori","5-GriGri", "6-Talis"}
PRIVATE cDistr
PRIVATE oDistr
PRIVATE aTpRel2		:= {"1-Frete"}
PRIVATE cTpRel2
PRIVATE oTpRel2



WHILE .T.
	
	cPATH:= 'C:\TEMP\'
	IF CEMPANT = '01'
		cTipoEmp:= 'OMA'
	ELSEIF CEMPANT = '02'
		cTipoEmp:= 'CER'
	ELSEIF CEMPANT = '03'
		cTipoEmp:= 'BM'
	ELSEIF CEMPANT = '05'
		cTipoEmp:= 'GR'
	ELSEIF CEMPANT = '06'
		cTipoEmp:= 'TL'
	ELSE
		cTipoEmp:= 'OUT'
	ENDIF
	cFileName   := "VENDAS_GERENCIAL_01_"+TRIM(CUSERNAME)+DTOS(dDATA)+cTipoEmp+".DBF"
	//cDestino	:= PADR(cPATH+cFileName, 100)
	cDestino	:= PADR(cPATH, 100)
	
	nOPCA	:= 2
	
	@ 10,0 TO 320,360  DIALOG oDlg3  TITLE OemToAnsi("Relatório de Frete - Gerencial")
	
	@ 020,010 SAY OemToAnsi("Data de: ")  SIZE 055,007
	@ 020,065 GET cDATAInicio SIZE 040,007
	@ 020,113 SAY OemToAnsi("ate")  SIZE 010,007
	@ 020,125 GET cDATAFim SIZE 040,007
	@ 030,010 SAY OemToAnsi("Distribuidor:")                      SIZE 050,007 OF oDlg3 PIXEL
	@ 030,065 COMBOBOX oDistr VAR cDistr    ITEMS aDistr WHEN .T. SIZE 070,007 OF oDlg3 PIXEL
	//@ 040,010 SAY OemToAnsi("Tipo Relatorio:")                    SIZE 050,007 OF oDlg3 PIXEL
	//@ 040,065 COMBOBOX oTpRel VAR cTpRel   ITEMS aTpRel  WHEN .T. SIZE 070,007 OF oDlg3 PIXEL
	@ 050,010 SAY OemToAnsi("Tipo Dados:")                        SIZE 050,007 OF oDlg3 PIXEL
	@ 050,065 COMBOBOX oTpRel2 VAR cTpRel2 ITEMS aTpRel2 WHEN .T. SIZE 070,007 OF oDlg3 PIXEL
	@ 060,010 SAY OemToAnsi("Abrir Excel:")                       SIZE 050,007 OF oDlg3 PIXEL
	@ 060,065 COMBOBOX oTpFile VAR cTpFile ITEMS aTpFile WHEN(ApOleClient("MsExcel")) SIZE 070,007 OF oDlg3 PIXEL
	@ 070,010 SAY OemToAnsi("Destino: ")                          SIZE 055,007
	@ 070,065 GET cDestino SIZE 100,007   WHEN .F.
	
	//	@ 030,010 SAY OemToAnsi("Unidade Negocio: ")  SIZE 050,007
	//	@ 030,065 GET cUN SIZE 100,007
	//	@ 040,010 SAY OemToAnsi("Equipe: ")  SIZE 050,007
	//	@ 040,065 GET cEQUIPE SIZE 100,007
	//	@ 050,010 SAY OemToAnsi("Vendedor: ")  SIZE 050,007
	//	@ 050,065 GET cVENDEDOR SIZE 100,007
	//	@ 060,010 SAY OemToAnsi("Zona: ")  SIZE 050,007
	//	@ 060,065 GET cZONA SIZE 100,007
	//	@ 070,010 SAY OemToAnsi("Produto: ")  SIZE 050,007
	//	@ 070,065 GET cPRODUTO SIZE 100,007
	//	@ 080,010 SAY OemToAnsi("Cliente: ")  SIZE 050,007
	//	@ 080,065 GET cCLIENTE SIZE 100,007
	//	@ 090,010 SAY OemToAnsi("CNPJ: ")  SIZE 050,007
	//	@ 090,065 GET cCNPJ SIZE 100,007
	
	ACTIVATE DIALOG oDlg3 ON INIT EnchoiceBar(oDlg3,{||nOPCA:=1,oDlg3:End() },{||NOPCA:=2,oDlg3:End() }) CENTERED
	
	IF nOPCA == 2
		Exit
	ENDIF
	
	PROCESSA({||GERR001A()})
	
ENDDO

U_MCERLOG()
RETURN

*----------------------------------------------------------------------------*
STATIC FUNCTION GERR001A()
*----------------------------------------------------------------------------*
LOCAL cQUERY	:= ""
LOCAL X			:= 1

LOCAL cSF1  := SPACE(06)
LOCAL cSD1  := SPACE(06)

DO CASE
	CASE  SUBSTR(cDistr,1,1)=='1' //Omamori
		cSF1      :='SF1010'
		cSD1      :='SD1010'
		cCliente  :=''
		cFileName := "FRETE_GERENCIAL_03_"+TRIM(CUSERNAME)+DTOS(dDATA)+"_OMAMORI"

	CASE  SUBSTR(cDistr,1,1)=='5' //Grigri
		cSF1      :='SF1050'
		cSD1      :='SD1050'
		cCliente  :='041382'
		cFileName := "FRETE_GERENCIAL_03_"+TRIM(CUSERNAME)+DTOS(dDATA)+"_GRIGRI"
	CASE  SUBSTR(cDistr,1,1)=='6' //Talis
		cSF1      :='SF1060'
		cSD1      :='SD1060'
		cCliente  :='043243'
		cFileName   := "FRETE_GERENCIAL_03_"+TRIM(CUSERNAME)+DTOS(dDATA)+"_TALIS"
	CASE  SUBSTR(cDistr,1,1)=='7' //CleanField
		cSF1      :='SF1060'
		cSD1      :='SD1060'
		cCliente  :='043746'
		cFileName   := "FRETE_GERENCIAL_03_"+TRIM(CUSERNAME)+DTOS(dDATA)+"_CLEANFIELD"
ENDCASE
//MSGALERT(cDistr)

/*
DO CASE
	CASE SUBSTR(cTpRel,1,1)=='1'
		cFileName   :=cFileName+"_SINTETICO"
	CASE SUBSTR(cTpRel,1,1)=='2'
		cFileName   :=cFileName+"_ANALITICO"
ENDCASE
*/

DO CASE
	CASE  SUBSTR(cTpRel2,1,1)=='1'
		cFileName   :=cFileName+".DBF"
	CASE  SUBSTR(cTpRel2,1,1)=='2'
		cFileName   :=cFileName+".DBF"
	CASE  SUBSTR(cTpRel2,1,1)=='3'
		cFileName   :=cFileName+".DBF"
ENDCASE


cDestino	:= PADR(cPATH+cFileName, 100)

/*
IF SUBSTR(cTpRel,1,1)=='1'
IF SUBSTR(cTpRel2,1,1)=='1' .or. SUBSTR(cTpRel2,1,1)=='3'
cQUERY	:= "  SELECT F2_TIPO TIPO,F2_DOC NOTA,F2_SERIE SERIE,F2_CLIENTE CLI_FOR,F2_LOJA LOJA_CLI,F2_EMISSAO EMISSAO,F2_DTLANC LANCAMENTO, "
cQUERY	+= "         F2_EST ESTADO ,F2_TIPOCLI TIPO_CLI, "
cQUERY	+= "         F2_VALBRUT VAL_BRUTO,F2_VALMERC VAL_MERC,F2_VALFAT VAL_FAT, "
cQUERY	+= "         F2_VALICM VAL_ICMS,F2_BASEICM BASE_ICMS,F2_VALIPI VAL_IPI,F2_BASEIPI BASE_IPI,F2_ICMSRET ICMS_RET,F2_VALISS VAL_ISS,F2_BASEISS BASE_ISS, "
cQUERY	+= "         F2_BRICMS BRICMS,F2_VALIMP5 VAL_PIS,F2_BASIMP5 BASE_PIS,F2_VALIMP6 VAL_COFINS,F2_BASIMP6 BASE_COF"
cQUERY	+= " FROM    SF2010 F2 "
cQUERY	+= " WHERE    "
cQUERY	+= "         F2_CLIENTE='"+ALLTRIM(cCliente)+"' AND F2_TIPO='N' AND "
cQUERY	+= "         F2_DUPL<>'' AND  " // venda somente com duplicata
cQUERY	+= "         F2_EMISSAO >='"+DTOS(cDATAInicio)+ "' AND F2_EMISSAO <='"+DTOS(cDATAFim)+ "' AND  "
cQUERY	+= "         F2.D_E_L_E_T_<>'*'   "
ENDIF
IF SUBSTR(cTpRel2,1,1)=='3'
cQUERY	+= " UNION ALL (  "
ENDIF
IF SUBSTR(cTpRel2,1,1)=='2' .OR.  SUBSTR(cTpRel2,1,1)=='3'
cQUERY	+= "  SELECT F2_TIPO TIPO,F2_DOC NOTA,F2_SERIE SERIE,F2_CLIENTE CLI_FOR,F2_LOJA LOJA_CLI,F2_EMISSAO EMISSAO,F2_DTLANC LANCAMENTO, "
cQUERY	+= "         F2_EST ESTADO ,F2_TIPOCLI TIPO_CLI, "
cQUERY	+= "         F2_VALBRUT VAL_BRUTO,F2_VALMERC VAL_MERC,F2_VALFAT VAL_FAT, "
cQUERY	+= "         F2_VALICM VAL_ICMS,F2_BASEICM BASE_ICMS,F2_VALIPI VAL_IPI,F2_BASEIPI BASE_IPI,F2_ICMSRET ICMS_RET,F2_VALISS VAL_ISS,F2_BASEISS BASE_ISS, "
cQUERY	+= "         F2_BRICMS BRICMS,F2_VALIMP5 VAL_PIS,F2_BASIMP5 BASE_PIS,F2_VALIMP6 VAL_COFINS,F2_BASIMP6 BASE_COF "
cQUERY	+= " FROM    "+ALLTRIM(cSF2)+" F2  "
cQUERY	+= " WHERE     "
cQUERY	+= "         F2_CLIENTE='000229' AND F2_TIPO='D' AND "
cQUERY	+= "         F2_EMISSAO >='"+DTOS(cDATAInicio)+ "' AND F2_EMISSAO <='"+DTOS(cDATAFim)+ "' AND  "
cQUERY	+= "         F2.D_E_L_E_T_<>'*'     "
ENDIF
IF SUBSTR(cTpRel2,1,1)=='3'
cQUERY	+= " )  "
ENDIF

cQUERY	+= " ORDER BY F2_TIPO,F2_DOC,F2_SERIE "
ELSE
IF SUBSTR(cTpRel2,1,1)=='1' .or. SUBSTR(cTpRel2,1,1)=='3'
*/
cQUERY	:= "  SELECT F1_TIPO TIPO,F1_DOC NOTA,F1_SERIE SERIE ,F1_EMISSAO EMISSAO, "
cQUERY	+= "         D1_CONTA CONTA, "
cQUERY	+= "         D1_ITEM ITEM,D1_COD CODIGO,D1_GRUPO GRUPO,D1_TP TIPO_PRO, "
cQUERY	+= "         D1_QUANT QUANT,D1_UM UM,D1_QTSEGUM QTSEGUM,D1_SEGUM SEGUM, "
cQUERY	+= "         D1_VUNIT VUNIT,D1_TOTAL TOTAL,D1_CUSTO CUSTO, "
cQUERY	+= "         D1_VALIPI VAL_IPI,D1_VALICM VAL_ICMS,D1_PICM P_ICMS,D1_IPI VAL_IPI,D1_TES TES,D1_CF CF, "
cQUERY	+= "         D1_BRICMS,D1_BASEICM,D1_ICMSRET,D1_CLASFIS, "
cQUERY	+= "         D1_BASIMP5 BASE_PIS,D1_ALQIMP5 ALQ_PIS,D1_VALIMP5 VAL_PIS,D1_BASIMP6 BASE_COF,D1_ALQIMP6 ALQ_COD,D1_VALIMP6 VAL_COF, "
cQUERY	+= "         D1_MARGEM MARGEM,D1_ALIQSOL ALQ_SOL "
cQUERY	+= " FROM    "+ALLTRIM(cSF1)+" F1, "+ALLTRIM(cSD1)+" D1 "
cQUERY	+= " WHERE   D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND "
cQUERY	+= "         (F1_ESPECIE IN ('CTR  ','DACTE') OR (D1_COD='930308')) AND "
cQUERY	+= "         F1_EMISSAO >='"+DTOS(cDATAInicio)+ "' AND F1_EMISSAO <='"+DTOS(cDATAFim)+ "' AND  "
cQUERY	+= "         F1.D_E_L_E_T_<>'*'  AND D1.D_E_L_E_T_<>'*'  "
cQUERY	+= " ORDER BY F1_TIPO,F1_DOC,F1_SERIE,D1_ITEM "
/*
ENDIF
IF SUBSTR(cTpRel2,1,1)=='3'
cQUERY	+= " UNION ALL (  "
ENDIF
IF SUBSTR(cTpRel2,1,1)=='2' .OR.  SUBSTR(cTpRel2,1,1)=='3'
cQUERY	+= " SELECT F2_TIPO TIPO,F2_DOC NOTA,F2_SERIE SERIE ,F2_EMISSAO EMISSAO, "
cQUERY	+= "         D2_CONTA CONTA,D2_CCUSTO CCUSTO, "
cQUERY	+= "         D2_ITEM ITEM,D2_COD CODIGO,D2_GRUPO GRUPO,D2_TP TIPO_PRO, "
cQUERY	+= "         D2_QUANT QUANT,D2_UM UM,D2_QTSEGUM QTSEGUM,D2_SEGUM SEGUM, "
cQUERY	+= "         D2_PRCVEN PRCVEN,D2_PRUNIT PRCUNIT,D2_TOTAL TOTAL,D2_VALBRUT VALBRUT,D2_CUSTO1 CUSTO, "
cQUERY	+= "         D2_VALIPI VAL_IPI,D2_VALICM VAL_ICMS,D2_PICM P_ICMS,D2_IPI VAL_IPI,D2_TES TES,D2_CF CF, "
cQUERY	+= "         D2_BRICMS,D2_BASEICM,D2_ICMSRET,D2_CLASFIS, "
cQUERY	+= "         D2_BASIMP5 BASE_PIS,D2_ALQIMP5 ALQ_PIS,D2_VALIMP5 VAL_PIS,D2_BASIMP6 BASE_COF,D2_ALQIMP6 ALQ_COD,D2_VALIMP6 VAL_COF, "
cQUERY	+= "         D2_MARGEM MARGEM,D2_ALIQSOL ALQ_SOL,D2_ALIQTST ALQ_ST,D2_VALTST VAL_ST "
cQUERY	+= " FROM    "+ALLTRIM(cSF2)+" F2, "+ALLTRIM(cSD2)+" D2 "
cQUERY	+= " WHERE   D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND "
cQUERY	+= "         F2_CLIENTE='000229' AND F2_TIPO='D' AND "
cQUERY	+= "         F2_EMISSAO >='"+DTOS(cDATAInicio)+ "' AND F2_EMISSAO <='"+DTOS(cDATAFim)+ "' AND  "
cQUERY	+= "         F2.D_E_L_E_T_<>'*'  AND D2.D_E_L_E_T_<>'*' "
ENDIF
IF SUBSTR(cTpRel2,1,1)=='3'
cQUERY	+= " )  "
ENDIF
*/
//cQUERY	+= " ORDER BY F2_TIPO,F2_DOC,F2_SERIE,D2_ITEM "

//ENDIF

cQUERY	:= ChangeQuery(cQUERY)
TcQuery cQUERY ALIAS QRY NEW

/* IF SUBSTR(cTpRel,1,1)=='1'
	TCSetField("QRY","EMISSAO","D")
	TCSetField("QRY","LANCAMENTO","D")
	TCSetField("QRY","VAL_BRUTO","N", 15, 2)
	TCSetField("QRY","VAL_MERC","N", 15, 2)
	TCSetField("QRY","VAL_FAT","N", 15, 2)
	TCSetField("QRY","VAL_ICMS","N", 15, 2)
	TCSetField("QRY","BASE_ICMS","N", 15, 2)
	TCSetField("QRY","VAL_IPI","N", 15, 2)
	TCSetField("QRY","BASE_IPI","N", 15, 2)
	TCSetField("QRY","ICMS_RET","N", 15, 2)
	TCSetField("QRY","VAL_ISS","N", 15, 2)
	TCSetField("QRY","BASE_ISS","N", 15, 2)
	TCSetField("QRY","BRICMS","N", 15, 2)
	TCSetField("QRY","VAL_PIS","N", 15, 2)
	TCSetField("QRY","BASE_PIS","N", 15, 2)
	TCSetField("QRY","VAL_COFINS","N", 15, 2)
	TCSetField("QRY","BASE_COF","N", 15, 2)
ELSE

	TCSetField("QRY","EMISSAO","D")
	TCSetField("QRY","QUANT","N", 15, 2)
	TCSetField("QRY","QTSEGUM","N", 15, 2)
	TCSetField("QRY","PRCVEN","N", 15, 2)
	TCSetField("QRY","PRCUNIT","N", 15, 2)
	TCSetField("QRY","TOTAL","N", 15, 2)
	TCSetField("QRY","VALBRUT","N", 15, 2)
	TCSetField("QRY","CUSTO","N", 15, 2)
	TCSetField("QRY","VAL_IPI","N", 15, 2)
	TCSetField("QRY","VAL_ICMS","N", 15, 2)
	TCSetField("QRY","P_ICMS","N", 15, 2)
	TCSetField("QRY","D2_BRICMS","N", 15, 2)
	TCSetField("QRY","D2_BASEICM","N", 15, 2)
	TCSetField("QRY","D2_ICMSRET","N", 15, 2)
	TCSetField("QRY","BASE_PIS","N", 15, 2)
	TCSetField("QRY","ALQ_PIS","N", 15, 2)
	TCSetField("QRY","VAL_PIS","N", 15, 2)
	TCSetField("QRY","BASE_COF","N", 15, 2)
	TCSetField("QRY","ALQ_COD","N", 15, 2)
	TCSetField("QRY","VAL_COF","N", 15, 2)
	TCSetField("QRY","MARGEM","N", 15, 2)
	TCSetField("QRY","ALQ_SOL","N", 15, 2)
	TCSetField("QRY","ALQ_ST","N", 15, 2)
	TCSetField("QRY","VAL_ST","N", 15, 2)
	
ENDIF
*/

PROCESSA({||GERR001B()})

QRY->(DBCLOSEAREA())

RETURN


*----------------------------------------------------------------------------*
STATIC FUNCTION GERR001B()
*----------------------------------------------------------------------------*

Local aArea		:= GetArea()

dbSelectArea('QRY') // Referencia ao Alias da Query
COPY TO (cFileName)
RestArea( aArea )

// Copia o arquivo do server para a maquina do cliente.
If !U_MLSCpyFile(cFileName,cDestino)
	MsgStop("Nao foi possivel gerar o arquivo."+CHR(13)+CHR(10)+cDestino+CHR(13)+CHR(10)+" Verifique se está sendo utilizado.")
ELSE
	MsgBox("Foi gerado arquivo com detalhes de nome "+CHR(13)+CHR(10)+cDestino,"Atenção","ALERT")
	
	If ApOleClient("MsExcel") .AND. SUBSTRING(cTpFile,1,1)=='2'
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(cDestino)
		oExcelApp:SetVisible(.T.)
	EndIf
	
Endif

FERASE(cFileName) // limpa o arquivo do server.

RETURN
