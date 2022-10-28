//------------------------------------------------------------------------------------//
//Empresa...: MSoftConsultoria - OMAMORI / CERATTI
//Funcao....: ATUCHVNFE
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 01/2008
//Uso.......: ATUALIZA CHAVE NFE
//Versao....: 8.11
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
//#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#Include "FONT.CH"

*----------------------------------------------------------------------------------------
USER FUNCTION ATUCHVNFE()
*----------------------------------------------------------------------------------------

PRIVATE nOPC1     := 2
PRIVATE oFont   

Private cCNPJ0101 :='05205107000190'  // OMAMORI INDUSTRIA DE ALIMENTOS LTDA
Private cCNPJ0102 :='05205107000270'  // OMAMORI INDUSTRIA DE ALIMENTOS LTDA. FILIAL 02
Private cCNPJ0501 :='12229680000107' //  GRIGRI DISTRIBUIDORA DE ALIMENTOS LTDA
Private cCNPJ0601 :='13479490000100' //  TALIS DISTRIBUIDORA DE ALIMENTOS LTDA.
Private cCNPJ0701 :='13847910000156' //  CLEAN FIELD INDUSTRIA E COMERCIO DE PRODUTOS ALIMENTICIOS LT


IF ALLTRIM(SM0->M0_CODIGO)<>'01'
	msgalert('Empresa '+ SM0->M0_NOME+'              ' )
	msgalert('Executar essa rotina na Empresa  OMAMORI')
	RETURN
ENDIF

DEFINE FONT oFont     NAME "Arial" SIZE 0,-20 BOLD

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Atualizaçõa Chave NFe Empresa OMAMORI")  From 135,0 To 445,700 OF oMainWnd PIXEL

@ 20,018 Say OEMTOANSI(" Este programa faz a atualização da "            )OF oDlg PIXEL COLOR CLR_RED  FONT oFont
@ 35,018 Say OEMTOANSI(" Chave NFe Nas tabelas de Entrada/saida/fiscal " )OF oDlg PIXEL COLOR CLR_RED  FONT oFont
//@ 65,018 Say OEMTOANSI(" Ultimo Fechamento "+cFdata   )                                  OF oDlg PIXEL COLOR CLR_BLUE FONT oFont
//@ 80,018 Say OEMTOANSI(" Usuario "+cFusuario)                                            OF oDlg PIXEL COLOR CLR_BLUE FONT oFont

ACTIVATE DIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOPC1:=1,oDlg:End() },{||NOPC1:=2,oDlg:End() }) CENTERED

IF nOPC1==2
	RETURN
ENDIF

IF nOPC1==1  
	alert("dDatabase:"+DTOS(dDatabase))
//	MsAguarde( { || U_ATUCHV1() } , "Aguarde 01/04 (SF1) NF Entrada...          "  )
//	MsAguarde( { || U_ATUCHV2() } , "Aguarde 02/04 (SF2) NF Saida...            "  )
	MsAguarde( { || U_ATUCHV3() } , "Aguarde 03/04 (SF3) Livros Fiscais CAB...  "  )
	MsAguarde( { || U_ATUCHV4() } , "Aguarde 04/04 (SFT) Livros Fiscais ITENS..."  )
	
	MSGALERT('Fim processamento 04/04 ')
ENDIF

U_MCERLOG()

RETURN

*----------------------------------------------------------------------------------------
USER FUNCTION ATUCHV1()
*----------------------------------------------------------------------------------------

LOCAL CQUERY1 :=""

cQuery1 := " UPDATE SF1010 SET F1_CHVNFE=  "
cQuery1 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2 '
cQuery1 += " WHERE F1_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
cQuery1 += " WHERE  F1_ESPECIE='SPED' AND F1_CHVNFE='' AND F1_SERIE='1  ' AND F1_FORMUL='S' AND F1_EMISSAO >='"+DTOS(dDatabase)+"' "
cQuery1 += " AND EXISTS "
cQuery1 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery1 += " WHERE F1_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
//cQUERY1 += "  AND TX_emit_CNPJ    ='"+ALLTRIM(cCNPJ0101)+"'  "

TcSqlExec(cQuery1)

cQuery1 := " UPDATE SF1060 SET F1_CHVNFE=  "
cQuery1 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2 '
cQuery1 += " WHERE F1_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
cQuery1 += " WHERE  F1_ESPECIE='SPED' AND F1_CHVNFE='' AND F1_SERIE='1  ' AND F1_FORMUL='S' AND F1_EMISSAO >='"+DTOS(dDatabase)+"' "
cQuery1 += " AND EXISTS "
cQuery1 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery1 += " WHERE F1_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "

TcSqlExec(cQuery1)

cQuery1 := " UPDATE SF1070 SET F1_CHVNFE=  "
cQuery1 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2 '
cQuery1 += " WHERE F1_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
cQuery1 += " WHERE  F1_ESPECIE='SPED' AND F1_CHVNFE='' AND F1_SERIE='1  ' AND F1_FORMUL='S' AND F1_EMISSAO >='"+DTOS(dDatabase)+"' "
cQuery1 += " AND EXISTS "
cQuery1 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery1 += " WHERE F1_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "

TcSqlExec(cQuery1)

RETURN

*----------------------------------------------------------------------------------------
USER FUNCTION ATUCHV2()
*----------------------------------------------------------------------------------------

LOCAL CQUERY2 :=""

cQuery2 := " UPDATE SF2010 SET F2_CHVNFE= "
cQuery2 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery2 += " WHERE F2_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
cQuery2 += " WHERE  F2_CHVNFE='' AND  F2_SERIE='1  ' AND F2_EMISSAO >='"+DTOS(dDatabase)+"' AND EXISTS "
cQuery2 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery2 += " WHERE F2_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "

TcSqlExec(cQuery2)

cQuery2 := " UPDATE SF2060 SET F2_CHVNFE= "
cQuery2 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery2 += " WHERE F2_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
cQuery2 += " WHERE  F2_CHVNFE='' AND  F2_SERIE='1  ' AND F2_EMISSAO >='"+DTOS(dDatabase)+"' AND EXISTS "
cQuery2 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery2 += " WHERE F2_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "

TcSqlExec(cQuery2)

cQuery2 := " UPDATE SF2070 SET F2_CHVNFE= "
cQuery2 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery2 += " WHERE F2_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "
cQuery2 += " WHERE  F2_CHVNFE='' AND  F2_SERIE='1  ' AND F2_EMISSAO >='"+DTOS(dDatabase)+"' AND EXISTS "
cQuery2 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery2 += " WHERE F2_DOC=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) "

TcSqlExec(cQuery2)

RETURN

*----------------------------------------------------------------------------------------
USER FUNCTION ATUCHV3()
*----------------------------------------------------------------------------------------

LOCAL CQUERY3 :=""

cQuery3 := " UPDATE SF3010 SET F3_CHVNFE= "
cQuery3 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery3 += " WHERE F3_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0102)+"')  "
cQuery3 += " WHERE  F3_CHVNFE='' AND  F3_SERIE='1  ' and F3_ESPECIE='SPED' AND F3_ENTRADA >='"+DTOS(dDatabase)+"' AND EXISTS "
cQuery3 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery3 += " WHERE F3_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin ) AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0102)+"')  "

TcSqlExec(cQuery3)

cQuery3 := " UPDATE SF3060 SET F3_CHVNFE= "
cQuery3 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery3 += " WHERE F3_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0601)+"')  "
cQuery3 += " WHERE  F3_CHVNFE='' AND  F3_SERIE='1  ' and F3_ESPECIE='SPED' AND F3_ENTRADA >='"+DTOS(dDatabase)+"' AND EXISTS "
cQuery3 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery3 += " WHERE F3_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0601)+"')  "

TcSqlExec(cQuery3)

cQuery3 := " UPDATE SF3070 SET F3_CHVNFE= "
cQuery3 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery3 += " WHERE F3_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0701)+"')  "
cQuery3 += " WHERE  F3_CHVNFE='' AND  F3_SERIE='1  ' and F3_ESPECIE='SPED' AND F3_ENTRADA >='"+DTOS(dDatabase)+"' AND EXISTS "
cQuery3 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery3 += " WHERE F3_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0701)+"')  "

TcSqlExec(cQuery3)

RETURN

*----------------------------------------------------------------------------------------
USER FUNCTION ATUCHV4()
*----------------------------------------------------------------------------------------

LOCAL CQUERY4 :=""

cQuery4 := " UPDATE SFT010 SET FT_CHVNFE= "
cQuery4 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery4 += " WHERE FT_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0102)+"')  "
cQuery4 += " WHERE  FT_CHVNFE='' AND  FT_SERIE='1  ' and FT_ESPECIE='SPED'  AND FT_ENTRADA >='"+DTOS(dDatabase)+"' AND EXISTS          "
cQuery4 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery4 += " WHERE FT_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0102)+"')  "

TcSqlExec(cQuery4)

cQuery4 := " UPDATE SFT060 SET FT_CHVNFE= "
cQuery4 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery4 += " WHERE FT_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0601)+"')  "
cQuery4 += " WHERE  FT_CHVNFE='' AND  FT_SERIE='1  ' and FT_ESPECIE='SPED' AND FT_ENTRADA >='"+DTOS(dDatabase)+"' AND EXISTS          "
cQuery4 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery4 += " WHERE FT_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0601)+"')  "

TcSqlExec(cQuery4)

cQuery4 := " UPDATE SFT070 SET FT_CHVNFE= "
cQuery4 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery4 += " WHERE FT_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0701)+"')  "
cQuery4 += " WHERE  FT_CHVNFE='' AND  FT_SERIE='1  ' and FT_ESPECIE='SPED' AND FT_ENTRADA >='"+DTOS(dDatabase)+"' AND EXISTS          "
cQuery4 += ' (select TOP 1 TX_CHAVE_NOTA COLLATE Latin1_General_Bin from "192.168.101.19".NFe_3.dbo.vNFeMicrosiga2  '
cQuery4 += " WHERE FT_NFISCAL=TX_NUMERO_NOTA COLLATE Latin1_General_Bin  AND TX_emit_CNPJ ='"+ALLTRIM(cCNPJ0701)+"')  "

TcSqlExec(cQuery4)

return

*----------------------------------------------------------------------------------------
//FIM  ATUCHVNFE()
*----------------------------------------------------------------------------------------
