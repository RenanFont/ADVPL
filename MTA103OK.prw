#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'parmtype.ch'

//////////////////////////////////////////////////////////////////////////////////////|
//Chamado #                                                                           |
//------------------------------------------------------------------------------------|
//Autor: RENAN FREITAS DE SOUZA    | DATA:09/2022                                     |
//------------------------------------------------------------------------------------|
//Validando a utilização de TES/ARMAZEM, caso seja Falso, não permite classificar     |      
//////////////////////////////////////////////////////////////////////////////////////|  

User Function MTA103OK()
	Local aArea := GetArea()
	Local nRet      := .T.
    Local cAlias    := ALLTRIM(SF4->F4_ESTOQUE)
    Local cText := "A TES utilizada movimenta o estoque e o tipo de Armazem não permite fazer movimentação de estoque."
	Local cText2 := "A TES utilizada não movimenta o estoque e o tipo de Armazem tem que a fazer movimentação de estoque."
	Local cTitle := "Atenção! Tipo de armazem não movimenta o estoque."
	Local cTitle2 := "Atenção! Tipo de armazem movimenta o estoque."

	If nRet
        DbSelectArea(aArea)
        SB1->(DbSetorder(1))

		if (SB1->B1_LOCPAD$'MC/SV' .AND. cAlias$'S')
		     MsgAlert(cText,cTitle)
			    nRet := .F.
        ENDIF
		if (SB1->B1_LOCPAD$!'MC/SV' .AND. SF4->F4_ESTOQUE$'N')
            MsgAlert(cText2,cTitle2) 
			nRet := .F.
		else
			nRet := .T.
		ENDIF
		RestArea(aArea)
	ENDIF

Return(nRet)

