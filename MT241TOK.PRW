#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'parmtype.ch'

//////////////////////////////////////////////////////////////////////////////////////|
//Chamado #0822-000226                                                                |
//------------------------------------------------------------------------------------|
//Autor: RENAN FREITAS DE SOUZA    | DATA:09/2022                                     |
//------------------------------------------------------------------------------------|
//Validando a movimentação,se o tipo de produto for diferente da regra entre TM/TIPO  |      
//////////////////////////////////////////////////////////////////////////////////////|  

User Function MT241TOK()

	Local nPosITCTA	:= aScan( aHeader,{ |x| AllTrim(x[2]) == "D3_ITEMCTA"	})
	Local nPosCLVL	:= aScan( aHeader,{ |x| AllTrim(x[2]) == "D3_CLVL"	})
	Local lRet := .T.
	Local nValida := CTM
	Local cTipo := Alltrim(SB1->B1_TIPO)
	Local cText := "MOVIMENTAÇÃO NÃO PERMITIDA PARA ESSE TM!"
	Local cText2 := "O (TIPO) DO PRODUTO É INVALIDO PARA ESSA (TM)!"
	Local cTitle := "Atenção! Verificar o TM e o TIPO"


//validação dos itens	
	If !empty(nValida)

		DbSelectArea("SB1")
		SD3->(DbSetorder(1))
			

		IF nValida $ "701" .and. cTipo $ "ME/MS/PA/RV/MA"
			lRet := .T.
		ELSEIF nValida $ "501" .and. cTipo $ "EP/LI/MC/MM/ES/TM"
			lRet := .T.
		ELSEIF nValida <> "501" .and.  nValida <> "701"
			lRet := .T.
		ELSE
			MsgAlert(cText+ CRLF+ CRLF+ cText2, cTitle)
			lRet := .F.
		ENDIF
	
		DbCloseArea()
	
	ENDIF



Return lRet

/*

//Local nPosITCTA	:= aScan( aHeader,{ |x| AllTrim(x[2]) == "D3_ITEMCTA"	})
//Local nPosCLVL	:= aScan( aHeader,{ |x| AllTrim(x[2]) == "D3_CLVL"	})

//-- Validações do usuário para inclusão do movimento
If !empty(CTM)
	DbSelectarea("SF5")
	SF5->(DbSetorder(1))
	If SF5->(DbSeek(xFilial("SF5") + cTM))
		if CTM $ "202/501/602/605/606/607/610/701"
			For nY := 1 To Len(aCols)
				If !aCols[ nY ][ Len(aHeader) + 1 ]
					If empty(aCols[nY][nPosITCTA]) //Item Obrigatorio
						lRet := .F.
						Alert("Para Tipo de Movimentação: '" + alltrim(SF5->F5_CODIGO) + "'-'" + SF5->F5_TEXTO +"' o Item contábil é obrigatório, verifique linha: " + Alltrim(Str(nY)) + " da Mov.Interna(Mod 2).")
						Exit
					else
						lRet := .T.
					EndIf
					If empty(aCols[nY][nPosCLVL]) //Classe de Valor
						lRet := .F.
						Alert("Para Tipo de Movimentação: '" + alltrim(SF5->F5_CODIGO) + "'-'" + alltrim(SF5->F5_TEXTO) +"' a Classe de Valor é obrigatória, verifique linha: " + Alltrim(Str(nY)) + " da Mov.Interna(Mod 2).")
						Exit
					else
						lRet := .T.
					EndIf
				EndIf
			Next nY
		else
			lRet := .T.
		endif
	EndIf
endif
*/
//U_MCERLOG()
