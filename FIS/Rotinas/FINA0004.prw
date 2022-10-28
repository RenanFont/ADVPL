#Include 'Protheus.ch'
#Include "FWMVCDEF.ch"
#include 'FINA0004.ch'

/*/{Protheus.doc} FINA0004
Compensa��o Intercompany
@type function
@version 12.1.25
@author Paulo Apolin�rio - Geeker Company
@since 06/09/2021
/*/ 
User Function FINA0004()
    Local cTipoCmp   := Alltrim( GetMV('ZZ_ICIATIP', .F., 'PA') )
    Local cCodOma    := Alltrim( GetMV('ZZ_ICIAFOR', .F., '000229/003345/') )
    Local oTlCmpICia := TlCmpIntercia():New()
    Local aTituloOma := {}
    Local nTamArray  := 0
	
	private oBrwMid		:= nil
	private aDados		:= {}
	private aOrder		:= {}
	private aHeadCol	:= {}
	private bOrder		:= {}
		
    If !(cEmpAnt $ "06/07")
        Help(,,"Compensa��o Intercompany",, "Essa rotina s� pode ser executada nas Distribuidoras", 1, 0)
        Return
    Endif

    If !( Alltrim( SE2->E2_TIPO ) $ cTipoCmp )
        Help(,,"Compensa��o Intercompany",, "Essa rotina s� pode ser executada a partir de t�tulos de Pagamento Antecipado!", 1, 0)
        Return
    Endif

    If !( Alltrim( SE2->E2_FORNECE ) $ cCodOma )
        Help(,, "Compensa��o Intercompany",, 'Fornecedor inv�lido!', 1, 0,,,,,,{'Selecione T�tulos a Pagar do fornecedor OMAMORI'})
        Return
    Endif

    oTlCmpICia:aTitPagPA := {	SE2->( Recno() )    ,;
                                SE2->E2_FILIAL      ,;
                                SE2->E2_PREFIXO     ,;
                                SE2->E2_NUM 	    ,;
                                SE2->E2_PARCELA     ,;
                                SE2->E2_TIPO 	    ,;
                                SE2->E2_FORNECE     ,;
                                SE2->E2_LOJA	    ,;
                                SE2->E2_EMISSAO	    ,;
                                SE2->E2_VENCTO	    ,;
                                SE2->E2_VENCREA	    ,;
                                SE2->E2_VALOR	    ,;
                                SE2->E2_SALDO	     }

    aTituloOma := oTlCmpICia:getInfoTitOMA( 	'02'					,;
								            	'RA'        	        ,;
								            	SE2->E2_NUM	            ,;
								            	SE2->E2_PARCELA	        ,;
								            	oTlCmpICia:cCliente		,;
								            	oTlCmpICia:cLoja		,;
								            	"RA"                	)

	nTamArray := Len( aTituloOma )
    If nTamArray > 0

        AAdd( oTlCmpICia:aTitRecPA, {	aTituloOma[P_RECNO] 	,;
                                        aTituloOma[P_FILIAL]  	,;
                                        aTituloOma[P_PREFIXO] 	,;
                                        aTituloOma[P_NUMERO] 	,;
                                        aTituloOma[P_PARCELA] 	,;
                                        aTituloOma[P_TIPO] 	    ,;
                                        aTituloOma[P_CLIFOR] 	,;
                                        aTituloOma[P_LOJA]		,;
                                        aTituloOma[P_SALDO]	    })

    	oTlCmpICia:montaTela()
    Else
        Help(,,"FINA0004",, "T�tulo correspodente n�o encontrado na Omamori. N�o � poss�vel continuar...", 1, 0)
    Endif

Return 
