#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*/{Protheus.doc} LP650212
Contabilização do LP LP650212 para ler a tabela Z11, e pegar as regras de TES para contabilização.
@author Manoel Nesio - Fabritech
@since 21/09/2020
@version 1.0
/*/
user function LP650212()

    local aArea     := GetArea()
    Local nRet      := 0

    dbSelectArea("Z11")
    dbSetOrder(1)
    iF Z11->(dbSeek(xFilial("Z11")+SD1->D1_TES))
        WHILE Z11->(!EOF()) .AND. Z11->Z11_FILIAL == xFilial("Z11") .AND. Z11->Z11_TES == SD1->D1_TES
            IF (ALLTRIM(SD1->D1_COD) == ALLTRIM(Z11->Z11_PRODUT) .OR. ALLTRIM(Z11->Z11_PRODUT) == "" );
                    .AND. (ALLTRIM(SD1->D1_FORNECE) == ALLTRIM(Z11->Z11_FORNEC) .OR. ALLTRIM(Z11->Z11_FORNEC) == "" );
                    .AND. (ALLTRIM(SD1->D1_LOJA) == ALLTRIM(Z11->Z11_LOJA) .OR. ALLTRIM(Z11->Z11_LOJA) == "" );
                    .AND. Z11->Z11_MSBLQL <> '1'

                nRet    := NoRound((SD1->D1_VALICM - (((SD1->D1_BASEICM * 7 )/100))),2)

                Exit

            Endif

            Z11->(dbSkip())

        EndDo

    EndIF

    RestArea(aArea)

return nRet
