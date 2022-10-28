#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} DocEntrOFM
Documento de entrada

@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class DocEntrOFM
    data OPC_INCLUI
    data OPC_ALTERA
    data OPC_DELETE

    data P_PEDIDO
    data P_ITEPED

    data oDocEntr
    data oParser

    data aCabec
    data aItAuto
    data aItens

    data aPedido

    data cWarning
    data cError
    data nOpc
    data lTemItens
    data nSF1Recno

    data oJson
    data aDados
    data aJDados
    data aJItens

    method new_DocEntrOFM() constructor 
    method vldCab_DocEntrOFM()
    method vldItens_DocEntrOFM()
    method vldRegis_DocEntrOFM()
    method manRegis_DocEntrOFM()
    method vldGeral_DocEntrOFM()
    method execManRegis_DocEntrOFM()
    method setValues_DocEntrOFM()
    method buscCondPgto_DocEntrOFM()
    method qryCondPgto_DocEntrOFM()
    method qryPedCom_DocEntrOFM()
    method buscPedCom_DocEntrOFM()
    method ajuTes_DocEntrOFM()
endClass

/*/{Protheus.doc} new_DocEntrOFM
Metodo construtor
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method new_DocEntrOFM() class DocEntrOFM
    ::OPC_INCLUI    := 3
    ::OPC_ALTERA    := 4
    ::OPC_DELETE    := 5

    ::P_PEDIDO    := 1
    ::P_ITEPED    := 2

    ::cWarning      := ""
    ::cError        := ""
    ::lTemItens     := .F.
    ::nSF1Recno     := 0
    ::aPedido       := {}

    ::oDocEntr      := DocEntrada():new_DocEntrada()
return

/*/{Protheus.doc} manRegis_DocEntrOFM
Metodo para gravar os regiistros
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method manRegis_DocEntrOFM() class DocEntrOFM

    if( Empty(::cError) )
        ::vldRegis_DocEntrOFM()
    endIf

    if( Empty(::cError) )
        ::setValues_DocEntrOFM()
    endIf

    if( Empty(::cError) )
        ::execManRegis_DocEntrOFM()
    endIf
    
    if( Empty(::cError) )
        ::ajuTes_DocEntrOFM()
    endIf

return

/*/{Protheus.doc} ajuTes_DocEntrOFM
Metodo para ajustar a TES
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method ajuTes_DocEntrOFM() class DocEntrOFM
    local nI := 1

    SD1->( DbSetOrder(1) )
    for nI := 1 to Len( ::oDocEntr:aItens )
        if( SD1->( DbSeek( xFilial("SD1") + PadR( ::oDocEntr:cDocumen               , TamSx3("D1_DOC"       )[1]) +; 
                                            PadR( ::oDocEntr:cSerie                 , TamSx3("D1_SERIE"     )[1]) +; 
                                            PadR( ::oDocEntr:cFornece               , TamSx3("D1_FORNECE"   )[1]) +; 
                                            PadR( ::oDocEntr:cLoja                  , TamSx3("D1_LOJA"      )[1]) +; 
                                            PadR( ::oDocEntr:aItens[nI]:cCodProod   , TamSx3("D1_COD"       )[1]) +; 
                                            PadR( ::oDocEntr:aItens[nI]:cItem       , TamSx3("D1_ITEM"      )[1]) ) ) )

            if( Empty(SD1->D1_TES) )
                SD1->( RecLock("SD1", .F.) ) 
                    SD1->D1_TES := ::oDocEntr:aItens[nI]:cTes
                SD1->( MsUnlock() )
            endIf
        endIf
    next

return

/*/{Protheus.doc} execManRegis_DocEntrOFM
Metodo para salvar os registros
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method execManRegis_DocEntrOFM() class DocEntrOFM  
    
    ::oDocEntr:execManRegis_DocEntrada()
    ::cError    := ::oDocEntr:cError
    ::nSF1Recno := ::oDocEntr:nSF1Recno

return

/*/{Protheus.doc} setValues_DocEntrOFM
Metodo para setar os valores
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method setValues_DocEntrOFM() class DocEntrOFM  
    
    if( Empty(::cError) )
        ::buscCondPgto_DocEntrOFM()
    endIf

    if( Empty(::cError) )
        ::buscPedCom_DocEntrOFM()
    endIf

return

/*/{Protheus.doc} vldRegis_DocEntrOFM
Metodo para validacao dos registros
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method vldRegis_DocEntrOFM() class DocEntrOFM
    
    ::vldCab_DocEntrOFM()
    ::vldItens_DocEntrOFM()
    ::vldGeral_DocEntrOFM()

return

/*/{Protheus.doc} vldGeral_DocEntrOFM
Metodo para validacao do cabecalho
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method vldGeral_DocEntrOFM() class DocEntrOFM
    local cFilParam	:= GetMv("ZZ_FLPROFM", .F., "01")
    local cFilMan   := ""

    if( Empty(::cError) )    
        ::cError := u_vlEmpOFM(::oParser:cCodEmp)
    endIf

	if( Empty(::cError) )

        if( Empty(::oParser:cFilDoc) )
            cFilMan := cFilParam
        else
            cFilMan := ::oParser:cFilDoc
        endIf

		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv( ::oParser:cCodEmp, ::oParser:cFilDoc, , "FAT")
    endIf

return

/*/{Protheus.doc} vldCab_DocEntrOFM
Metodo para validacao do cabecalho
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method vldCab_DocEntrOFM() class DocEntrOFM
    local cLojPar := GetMV("ZZ_LJPROF", .F., "01")

    if( !AttIsMemberOf(::oParser, "cCodEmp") )
        ::cError += "Sem o campo cCodEmp" + CRLF    
    endIf

    if( !AttIsMemberOf(::oParser, "cFilDoc") )
        ::cError += "Sem o campo cCodEmp" + CRLF
    endIf

    if( !AttIsMemberOf(::oParser, "cSerie") )            
        ::cError += "Sem o campo cSerie" + CRLF
    else
        ::oDocEntr:cSerie := ::oParser:cSerie
    endIf

    if( !AttIsMemberOf(::oParser, "cDocumen") )
        ::cError += "Sem o campo cDocumen" + CRLF
    else
        ::oDocEntr:cDocumen := ::oParser:cDocumen
    endIf

    if( !AttIsMemberOf(::oParser, "cFornece") )
        ::cError += "Sem o campo cFornece" + CRLF
    else    
        ::oDocEntr:cFornece := ::oParser:cFornece
    endIf

    if( !AttIsMemberOf(::oParser, "cLoja") )
        ::cError += "Sem o campo cLoja" + CRLF

    elseIf( Empty(::oParser:cLoja) )
        ::oDocEntr:cLoja := cLojPar
        
    else
        ::oDocEntr:cLoja := ::oParser:cLoja
    endIf

    if( !AttIsMemberOf(::oParser, "cTipo") )
        ::cError += "Sem o campo cTipo" + CRLF
    else
        ::oDocEntr:cTipo := ::oParser:cTipo
    endIf
    
    if( !AttIsMemberOf(::oParser, "cEspecie" ) )
        ::cError += "Sem o campo cEspecie" + CRLF
    else
        ::oDocEntr:cEspecie := ::oParser:cEspecie        
    endIf

    if( AttIsMemberOf(::oParser, "cCondPgto" ) )         
        ::oDocEntr:cCondPgto := ::oParser:cCondPgto
    endIf

    if( !AttIsMemberOf(::oParser, "dEmissao" ) )
        ::cError += "Sem o campo dEmissao" + CRLF
    else
        //Fabio - Teste para forçar a data de hoje
        ::oDocEntr:dEmissao := dDataBase
        //::oDocEntr:dEmissao := StoD(::oParser:dEmissao)
    endIf
    
    if( AttIsMemberOf(::oParser, "dDtLanc" ) .AND. !Empty(::oParser:dDtLanc) )
        ::oDocEntr:dDtLanc := ::oParser:dDtLanc
    else
        ::oDocEntr:dDtLanc := dDataBase
    endIf

    if( AttIsMemberOf(::oParser, "cChaveNfe" ) .AND. !Empty(::oParser:cChaveNfe) )
        //Fabio - Teste para forçar a data de hoje
        //::oDocEntr:cChaveNfe := ::oParser:cChaveNfe
    endIf

    if( AttIsMemberOf(::oParser, "nPesLiq" ) .AND. !Empty(::oParser:nPesLiq) )
        ::oDocEntr:nPesLiq := ::oParser:nPesLiq        
    endIf

    if( AttIsMemberOf(::oParser, "nPesBrut" ) .AND. !Empty(::oParser:nPesBrut) )
        ::oDocEntr:nPesBrut := ::oParser:nPesBrut        
    endIf

    if( AttIsMemberOf(::oParser, "nValFrte" ) .AND. !Empty(::oParser:nValFrte) )
        ::oDocEntr:nValFrte := ::oParser:nValFrte
    endIf

    if( AttIsMemberOf(::oParser, "nValDesp" ) .AND. !Empty(::oParser:nValDesp) )
        ::oDocEntr:nValDesp := ::oParser:nValDesp        
    endIf

    if( AttIsMemberOf(::oParser, "cVolEspec" ) .AND. !Empty(::oParser:cVolEspec) )
        ::oDocEntr:cVolEspec := ::oParser:cVolEspec        
    endIf

    if( AttIsMemberOf(::oParser, "nVolume" ) .AND. !Empty(::oParser:nVolume) )
        ::oDocEntr:nVolume := ::oParser:nVolume        
    endIf
    
    if( AttIsMemberOf(::oParser, "cTpFrete" ) )
        if( Alltrim( Upper( ValType( ::oParser:cTpFrete ) ) ) == "C" )

            if( Alltrim( Upper(::oParser:cTpFrete) ) == "0" )
                ::oDocEntr:cTpFrete := "C" //C - CIF

            elseIf( Alltrim( Upper(::oParser:cTpFrete) ) == "1" )
                ::oDocEntr:cTpFrete := "F" //F - FOB

            elseIf( Alltrim( Upper(::oParser:cTpFrete) ) == "2" )
                ::oDocEntr:cTpFrete := "T" //T - Por conta de terceiros

            elseIf( Alltrim( Upper(::oParser:cTpFrete) ) == "3" )
                ::oDocEntr:cTpFrete := "R" //R - Por conta remetente

            elseIf( Alltrim( Upper(::oParser:cTpFrete) ) == "4" )
                ::oDocEntr:cTpFrete := "D" //D - Por conta destinatário

            elseIf( Alltrim( Upper(::oParser:cTpFrete) ) == "9" )
                ::oDocEntr:cTpFrete := "S" //S - Sem frete

            endIf
        else
            if( ::oParser:cTpFrete == 0 )
                ::oDocEntr:cTpFrete := "C" //C - CIF

            elseIf( ::oParser:cTpFrete == 1 )
                ::oDocEntr:cTpFrete := "F" //F - FOB

            elseIf( ::oParser:cTpFrete == 2 )
                ::oDocEntr:cTpFrete := "T" //T - Por conta de terceiros

            elseIf( ::oParser:cTpFrete == 3 )
                ::oDocEntr:cTpFrete := "R" //R - Por conta remetente

            elseIf( ::oParser:cTpFrete == 4 )
                ::oDocEntr:cTpFrete := "D" //D - Por conta destinatário

            elseIf( ::oParser:cTpFrete == 9 )
                ::oDocEntr:cTpFrete := "S" //S - Sem frete

            endIf
        endIf

    endIf

    if( !AttIsMemberOf(::oParser, "cNatureza" ) )
        ::cError += "Sem o campo cNatureza" + CRLF
    else
        ::oDocEntr:cNatureza := ::oParser:cNatureza
    endIf

    if( !AttIsMemberOf(::oParser, "aItens" ) )
        ::cError += "Sem o campo aItens" + CRLF

    elseIf( Empty(::oParser:aItens) )
        ::cError += "Sem itens aItens" + CRLF

    else
        ::lTemItens := .T.
    endIf

return

/*/{Protheus.doc} vldCab_DocEntrOFM
Metodo para validacao do cabecalho
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method vldItens_DocEntrOFM() class DocEntrOFM
    local nI            := 1
    local oDocItEntrada := nil
    local lSomTot       := GetMv("ZZ_SMVLTT", .F., .T.)
    local lPrClas       := GetMv("ZZ_CLVLOF", .F., .F.)
    local lPedCom       := GetMv("ZZ_PDCMOF", .F., .F.)
    local lGrvImp       := GetMv("ZZ_GRIMPO", .F., .F.)
    
    if( ::lTemItens )

        for nI := 1 to Len( ::oParser:aItens )
            oDocItEntrada   := nil
            oDocItEntrada   := DocItEntrada():new_DocItEntrada()

            oDocItEntrada:cItem := StrZero(nI, TamSx3("D1_ITEM")[1])

            if( !AttIsMemberOf(::oParser:aItens[nI], "cCodProod") )
                ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cCodProod" + CRLF
            else
                oDocItEntrada:cCodProod := ::oParser:aItens[nI]:cCodProod
            endIf
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "nQuant") )
                ::cError += "O item "+ CValToChar(nI) +" esta sem o campo nQuant" + CRLF
            else
                oDocItEntrada:nQuant := ::oParser:aItens[nI]:nQuant
            endIf
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "nVlUnit") )
                ::cError += "O item "+ CValToChar(nI) +" esta sem o campo nVlUnit" + CRLF
            else
                oDocItEntrada:nVlUnit := ::oParser:aItens[nI]:nVlUnit
            endIf

            if(lSomTot)
                oDocItEntrada:nVlTot := ::oParser:aItens[nI]:nVlUnit * ::oParser:aItens[nI]:nQuant

            elseIf( !AttIsMemberOf(::oParser:aItens[nI], "nVlTot") )
                ::cError += "O item "+ CValToChar(nI) +" esta sem o campo nVlTot" + CRLF

            else 
                oDocItEntrada:nVlTot := ::oParser:aItens[nI]:nVlTot
            endIf
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "cTES") )
                ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cTES" + CRLF
            else
                oDocItEntrada:cTES := ::oParser:aItens[nI]:cTES
            endIf

            if( ::oDocEntr:cTipo == 'D' )
                if( !AttIsMemberOf(::oParser:aItens[nI], "cNFOri") )
                    ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cNFOri" + CRLF
                else
                    oDocItEntrada:cNFOri := ::oParser:aItens[nI]:cNFOri
                endIf

                if( !AttIsMemberOf(::oParser:aItens[nI], "cSerOri") )
                    ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cSerOri" + CRLF
                else
                    oDocItEntrada:cSerOri := ::oParser:aItens[nI]:cSerOri
                endIf
            endIf
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "cItemCta") )
                if( lPrClas )
                    ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cItemCta" + CRLF
                endIf
            else
                oDocItEntrada:cItemCta := ::oParser:aItens[nI]:cItemCta
            endIf            
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "cClVl") )
                if( lPrClas )
                    ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cClVl" + CRLF
                endIf
            else
                oDocItEntrada:cClVl := ::oParser:aItens[nI]:cClVl
            endIf
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "cNumPed") )
                if(lPedCom)
                    ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cNumPed" + CRLF
                endif
            else
                oDocItEntrada:cNumPed := ::oParser:aItens[nI]:cNumPed
            endIf
            
            if( !AttIsMemberOf(::oParser:aItens[nI], "cItePed") )
                if(lPedCom)
                    ::cError += "O item "+ CValToChar(nI) +" esta sem o campo cItePed" + CRLF
                endif
            else
                oDocItEntrada:cItePed := ::oParser:aItens[nI]:cItePed
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nValSol") )
                oDocItEntrada:nValSol := ::oParser:aItens[nI]:nValSol
                oDocItEntrada:lValSol := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nBasReduz") )
                oDocItEntrada:nBasReduz := ::oParser:aItens[nI]:nBasReduz
                oDocItEntrada:lBasReduz := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nBasICMS") )
                oDocItEntrada:nBasICMS := ::oParser:aItens[nI]:nBasICMS
                oDocItEntrada:lBasICMS := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nAliqICMS") )
                oDocItEntrada:nAliqICMS := ::oParser:aItens[nI]:nAliqICMS
                oDocItEntrada:lAliqICMS := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nValICMS") )
                oDocItEntrada:nValICMS := ::oParser:aItens[nI]:nValICMS
                oDocItEntrada:lValICMS := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nValCofins") )
                oDocItEntrada:nValCofins := ::oParser:aItens[nI]:nValCofins
                oDocItEntrada:lValCofins := lGrvImp
            endIf
            
            if( AttIsMemberOf(::oParser:aItens[nI], "nValPis") )
                oDocItEntrada:nValPis := ::oParser:aItens[nI]:nValPis
                oDocItEntrada:lValPis := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nAliqIpi") )
                oDocItEntrada:nAliqIpi := ::oParser:aItens[nI]:nAliqIpi
                oDocItEntrada:lAliqIpi := lGrvImp
            endIf

            if( AttIsMemberOf(::oParser:aItens[nI], "nValIpi") )
                oDocItEntrada:nValIpi := ::oParser:aItens[nI]:nValIpi
                oDocItEntrada:lValIpi := lGrvImp
            endIf                        
            
            if( Empty(::cError) )
                AAdd( ::oDocEntr:aItens, oDocItEntrada )
            endif

        next

    endIf

return

/*/{Protheus.doc} buscPedCom_DocEntrOFM
Metodo para buscar os pedidos de compras
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method buscPedCom_DocEntrOFM() class DocEntrOFM
    local nI        := 0
    local cForn     := ::oDocEntr:cFornece
    local cLoja     := ::oDocEntr:cLoja
    local cCodProd  := ""
    local nQuant    := 0
    local cAliasQry := ""    
    local lAchou    := .F.
    local cAuxPed   := ""
    local cAuxIte   := ""
    local nPos      := 0
    
    for nI := 1 to Len(::oDocEntr:aItens)
        lAchou      := .F.
        cCodProd    := ::oDocEntr:aItens[nI]:cCodProod
        nQuant      := ::oDocEntr:aItens[nI]:nQuant
        cAuxPed     := ""
        cAuxIte     := ""
        nPos        := 0

        if( Empty( ::oDocEntr:aItens[nI]:cNumPed ) )
            
            if( !lAchou )
                cAliasQry := ::qryPedCom_DocEntrOFM(cForn, cLoja, cCodProd, nQuant, .T.)

                while( !(cAliasQry)->( Eof() ) )
                    cAuxPed := Alltrim( (cAliasQry)->C7_NUM  )
                    cAuxIte := Alltrim( (cAliasQry)->C7_ITEM )
                
                    nPos    := AScan( ::aPedido, {|x| Alltrim(x[::P_PEDIDO]) == cAuxPed .AND. Alltrim(x[::P_ITEPED]) == cAuxIte } )

                    if( nPos <= 0 .AND. !Empty( (cAliasQry)->C7_NUM ))                        
                        ::oDocEntr:aItens[nI]:cNumPed   := cAuxPed
                        ::oDocEntr:aItens[nI]:cItePed   := cAuxIte
                        lAchou                          := .T.    
                        AAdd(::aPedido, { cAuxPed, cAuxIte } )

                        exit                                    
                    endIf

                    (cAliasQry)->( DbSkip() )
                endDo
                    
                if( Select(cAliasQry) > 0 )                    
                    (cAliasQry)->( DbCloseArea() )
                endIf
            endIf

            if( !lAchou )
                cAliasQry := ::qryPedCom_DocEntrOFM(cForn, cLoja, cCodProd, nQuant, .F.)

                while( !(cAliasQry)->( Eof() ) )
                    cAuxPed := Alltrim( (cAliasQry)->C7_NUM  )
                    cAuxIte := Alltrim( (cAliasQry)->C7_ITEM )
                
                    nPos    := AScan( ::aPedido, {|x| Alltrim(x[::P_PEDIDO]) == cAuxPed .AND. Alltrim(x[::P_ITEPED]) == cAuxIte } )

                    if( nPos <= 0 .AND. !Empty( (cAliasQry)->C7_NUM ))                        
                        ::oDocEntr:aItens[nI]:cNumPed   := cAuxPed
                        ::oDocEntr:aItens[nI]:cItePed   := cAuxIte
                        lAchou                          := .T.     
                        AAdd(::aPedido, { cAuxPed, cAuxIte } )  

                        exit
                    endIf

                    (cAliasQry)->( DbSkip() )
                endDo
                    
                if( Select(cAliasQry) > 0 )                    
                    (cAliasQry)->( DbCloseArea() )
                endIf

            endIf            
        endIf
    next

    //Faz a busca de cond pgto 
    if( !Empty(cAuxPed) .AND. !Empty(cAuxIte) )
        cAliasQry := ::qryCondPgto_DocEntrOFM(cAuxPed, cAuxIte)

        ::oDocEntr:cCondPgto := (cAliasQry)->C7_COND

        (cAliasQry)->( DbCloseArea() )
    endIf

return

/*/{Protheus.doc} qryPedCom_DocEntrOFMbuscPedCom_DocEntrOFM
Metodo para query do pedido de compras
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method qryPedCom_DocEntrOFM(cForn, cLoja, cCodProd, nQuant, lExato) class DocEntrOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()

    default lExato  := .T.
 
    cQuery += CRLF + "  SELECT  C7_FILIAL, C7_NUM, C7_ITEM,  C7_FORNECE, C7_LOJA, 		"
    cQuery += CRLF + "          C7_PRODUTO, C7_QUANT, C7_QUJE, C7_QUANT - C7_QUJE SALDO "
    cQuery += CRLF + "  FROM "+ RetSqlName("SC7") +" SC7                                "
    cQuery += CRLF + "  WHERE                                                           "
    cQuery += CRLF + "          SC7.C7_FILIAL   = '"+ xFilial("SC7") +"'                "
    cQuery += CRLF + "      AND SC7.C7_FORNECE  = '"+ cForn +"'                         "
    cQuery += CRLF + "      AND SC7.C7_LOJA     = '"+ cLoja +"'                         "
    cQuery += CRLF + "      AND SC7.C7_PRODUTO  = '"+ cCodProd +"'                      "
    cQuery += CRLF + "      AND SC7.C7_CONAPRO  = 'L'                                   "
    
    if( lExato )
        cQuery += CRLF + "      AND SC7.C7_QUANT - SC7.C7_QUJE = "+ CValToChar(nQuant) +"   "
    else
        cQuery += CRLF + "      AND SC7.C7_QUANT - SC7.C7_QUJE > "+ CValToChar(nQuant) +"   "
    endIf

    cQuery += CRLF + "      AND SC7.D_E_L_E_T_  = ''                                    "
    cQuery += CRLF + "  ORDER BY SC7.C7_EMISSAO DESC, SC7.R_E_C_N_O_ DESC               "

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry


/*/{Protheus.doc} buscCondPgto_DocEntrOFM
Metodo para buscar 
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method buscCondPgto_DocEntrOFM() class DocEntrOFM
    local cAliasQry := ""
    local cNumPed   := ""
    local cItePed   := ""
    local nI        := 1

    if( Empty(::oDocEntr:cCondPgto) )
        if( ::lTemItens )

            for nI := 1 to Len( ::oParser:aItens )

                if( ( AttIsMemberOf(::oParser:aItens[nI], "cNumPed") .AND. !Empty(::oParser:aItens[nI]:cNumPed) ) .AND.;
                    ( AttIsMemberOf(::oParser:aItens[nI], "cItePed") .AND. !Empty(::oParser:aItens[nI]:cItePed) ) )

                    cNumPed := ::oParser:aItens[nI]:cNumPed
                    cItePed := ::oParser:aItens[nI]:cItePed
                    exit
                endIf               
            next    
        endIf

        if( !Empty(cNumPed) .AND. !Empty(cItePed) )
            cAliasQry := ::qryCondPgto_DocEntrOFM(cNumPed, cItePed)

            ::oDocEntr:cCondPgto := (cAliasQry)->C7_COND
            
        endIf
        
    endIf

return

/*/{Protheus.doc} qryCondPgto_DocEntrOFM
Metodo para query da condicao de pagamento
@author    Fabio Hayama - Geeker Company
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method qryCondPgto_DocEntrOFM(cNumPed, cItePed) class DocEntrOFM
    local cQuery    := ""
    local cAliasQry := GetNextAlias()
 
    cQuery += CRLF + " SELECT C7_COND
    cQuery += CRLF + " FROM "+ RetSqlName("SC7") +" SC7
    cQuery += CRLF + " WHERE
    cQuery += CRLF + "         SC7.C7_FILIAL   = '"+ xFilial("SC7") +"'
    cQuery += CRLF + "     AND SC7.C7_NUM      = '"+ cNumPed        +"'
    cQuery += CRLF + "     AND SC7.C7_ITEM     = '"+ cItePed        +"'
    cQuery += CRLF + "     AND SC7.D_E_L_E_T_  = ''

    TcQuery cQuery New Alias (cAliasQry)

return cAliasQry
