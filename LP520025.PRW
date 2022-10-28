#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

//////////////////////////////////////////////////////////////////////////////////////|
//Chamado #1221-000032                                                                |
//------------------------------------------------------------------------------------|
//Autor: RENAN FREITAS DE SOUZA    | DATA:09/2022                                  |
//------------------------------------------------------------------------------------|
//LP520/025 de recuperação de perda do tipo 'REP' 'CLIENTE  RECUPERADO'               |
//////////////////////////////////////////////////////////////////////////////////////| 

User Function LP520025DB() //Local  //If cCodEmp == '02'
	Local aArea		:= GetArea()
	Local cReturn	:= ""
	Local nBco  := (SE5->E5_BANCO)='341'
	Local nAg   := (SE5->E5_AGENCIA)='0194'
	Local nCont := (SE5->E5_CONTA)='76714-1'
    Local cCodEmp   := FWCodEmp()

    If cCodEmp == '01'
        IF(ALLTRIM(SE1->E1_NATUREZ)$'RECUP PERD')
            IF(ALLTRIM(SE5->E5_MOTBX)$'REP'.AND. nBco .AND. nAg .AND. nCont ) //validando em qual banco foi feito a baixa
                cReturn := (ALLTRIM(SA6->A6_CONTA)) 
            Else
                cReturn := ""
            Endif
        Endif
    Endif
    RestArea(aArea)

U_MCERLOG()
Return cReturn
