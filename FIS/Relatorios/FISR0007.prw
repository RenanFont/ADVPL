#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0007
Cadastro de Produtos
@author Vitor Costa
@since 18/03/20
@type function
/*/
user function FISR0007()

	Private cTitulo 	:= OemToAnsi("Cadastro de Produtos")
    
		Processa({|| FISR0007B()})
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0007A
Cadastro de Produtos
@author Vitor Costa
@since 18/03/20
@type function
/*/
Static Function FISR0007A()
	
    local cQuery := ""

    cQuery += " SELECT                                                                                 		" + CRLF
    cQuery += " 	B1_FILIAL,B1_COD,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD,B1_GRUPO,B1_CONTA,B1_CC,B1_APROPRI,    " + CRLF
    cQuery += " CASE                                                                                   		" + CRLF
    cQuery += " 	WHEN B1_MSBLQL = '1' THEN 'BLOQUEADO' ELSE 'ATIVO' END B1_MSBLQL,                  		" + CRLF
    cQuery += " 	B1_GRTRIB,B1_POSIPI,B1_CLASFIS,B1_CEST,B1_CODBAR,B1_SEGUM,B1_ORIGEM,X5_DESCRI      		" + CRLF
    cQuery += " FROM "+ RetSqlName("SB1")+" SB1(NOLOCK)                                                		" + CRLF
    cQuery += " 	LEFT JOIN SX5010 X5 (NOLOCK) ON                                                  		" + CRLF
    cQuery += " 		--X5_FILIAL = B1_FILIAL                                                        		" + CRLF
    cQuery += " 		X5_TABELA = 'S0'                                                              		" + CRLF
    cQuery += " 		AND X5_CHAVE = B1_ORIGEM                                                       		" + CRLF
    cQuery += " 	WHERE SB1.D_E_L_E_T_ = '' AND B1_FILIAL <> 'ZZ'                                    		" + CRLF
    cQuery += " ORDER BY B1_COD,B1_FILIAL                                                                   " + CRLF

return cQuery

/*/{Protheus.doc} FISR0007B
Cadastro de Produtos
@author Vitor Costa
@since 18/03/20
@type function
/*/
Static Function FISR0007B()
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= OemToAnsi("Cadastro de Produtos_" + cTipoEmp)	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := FISR0007A()
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return
