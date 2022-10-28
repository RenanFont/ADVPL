#Include 'Protheus.ch'
#Include 'Totvs.ch'
#Include "rwmake.ch"


//////////////////////////////////////////////////////////////////////////////////////|
//Chamado # 0822-00025                                                                |
//------------------------------------------------------------------------------------|
//Autor: RENAN FREITAS DE SOUZA    | DATA:09/2022                                     |
//------------------------------------------------------------------------------------|
//P.E. MT103DRF com objetiVo de preencher o campo gera dirf = 1-SIM +    RETENÇÃO     |      
//////////////////////////////////////////////////////////////////////////////////////|  

/*/{Protheus.doc} 
User Function MT103DRF()

@author RENAN FREITAS
@since 21/09/2022
@Chamado ##0822-00025 
/*/

User Function MT103DRF()

	Local aRet 		:= {}
	Local nValor	:= PARAMIXB[1]
	Local cCodRet	:= PARAMIXB[2]
	Local oValor	:= PARAMIXB[3]
	Local oCodRet	:= PARAMIXB[4]
	//Local cCodSB1	:= ALLTRIM(SB1->B1_COD)
	Local cCodSA2	:= ALLTRIM(SA2->A2_NATUREZ)

	nValor  := 1
	cCodRet := "0000"

	IF 	cCodSA2 $ 'ADTOREPRES'//cCodSB1 $ 'DESPREPRECOM' .AND. 
		aadd(aRet,{"IRR",nValor,"8045"})
	ELSE
		aadd(aRet,{"IRR",nValor,"1708"})
		aadd(aRet,{"PIS",nValor,"5952"})
		aadd(aRet,{"COF",nValor,"5952"})
		aadd(aRet,{"CSL",nValor,"5952"})
	ENDIF


Return aRet
