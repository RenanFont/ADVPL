
#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#INCLUDE 'TOPCONN.CH'

/*==========================================================================
Funcao.......: RCLICOMP
Descricao....: Relatorio de clientes e complemento                                              
Autor........: Leonardo Robes       
Data.........: 14/07/2021                                                    
Parametros...: Nil
Retorno......: Nil
==========================================================================*/
 
User Function RCLICOMP() 

    Local oReport	:= Nil

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return Nil

/*/{Protheus.doc} ReprtDef
    @description 	Definicoes do Relatorio
    @author 		Leonardo Robes
    @type 			Function
/*/
Static Function ReportDef()

	Local cDescr	 	:= "Este programa irá imprimir o relatorio listagem de clientes"
	Local cTitulo	 	:= "Listagem Clientes"
	Local cAliasRep	 	:= GetNextAlias()
	Local cPerg			:= "LISCLI"
	Local oCliente		:= Nil
	
	//Ajusta as Perguntas
	CriaPerg(@cPerg)
	Pergunte(cPerg,.F.)

	oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)
	oReport:SetLandscape()
	oReport:HideParamPage()

	oCliente := TRSection():New(oReport,"Clientes",{"SA1","ZZL"},,/*Campos do SX3*/,/*Campos do SIX*/)
	oCliente:SetTotalInLine(.F.)
    
    TRCell():New(oCliente,"A1_FGINTE"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
	TRCell():New(oCliente,"A1_COD"		,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)	
	TRCell():New(oCliente,"A1_PESSOA"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)	
	TRCell():New(oCliente,"A1_LOJA"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
	TRCell():New(oCliente,"A1_CODOLD"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
	TRCell():New(oCliente,"A1_NOME"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
	TRCell():New(oCliente,"A1_NREDUZ"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
	TRCell():New(oCliente,"A1_RISCO"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_STFIN"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_STCOM"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_COND"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_LC"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_TABPRE"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_DESC"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_EST"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_MUN"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_TIPO"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_CGC"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_INSCR"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_VEND"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_BCO1"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_BCO2"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_BCO3"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_BCO4"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_BCO5"	    ,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_EMAIL"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"A1_XONEMO"	,"SA1"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"ZZL_STSINT"	,"ZZL"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)    
    TRCell():New(oCliente,"ZZL_STRECF"	,"ZZL"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"ZZL_APTOVV"	,"ZZL"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"ZZL_VVISTA"	,"ZZL"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"ZZL_TABVV"	,"ZZL"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
    TRCell():New(oCliente,"ZZL_CONDVV"	,"ZZL"		,/*Titulo*/		,/*Mascara*/	,/*Tamanho*/	,/*lPixel*/	,		)
   		
Return oReport

/*/{Protheus.doc} ReportPrint    
    @author 		Leonardo Robes
    @type 			Function
/*/
Static Function ReportPrint(oReport, cAliasRep)

	Local oSection1		:= oReport:Section(1)

    SA1->(DbSelectArea("SA1"))
    SA1->(dbSetOrder(1))

    ZZL->(dbSelectArea("ZZL"))
    ZZL->(dbSetOrder(1))
        
    If SA1->(dbSeek(xFilial("SA1")+MV_PAR01))
        While !SA1->(Eof()) .And. SA1->(A1_COD+A1_LOJA) <= MV_PAR02

            If !ZZL->(dbSeek(xFilial("ZZL")+SA1->(A1_COD+A1_LOJA)))

                oSection1:Init()
                
                oSection1:Cell("A1_FGINTE"	):SetValue( SA1->A1_FGINTE          )			
                oSection1:Cell("A1_COD"		):SetValue( SA1->A1_COD			    )
                oSection1:Cell("A1_PESSOA"	):SetValue( SA1->A1_PESSOA			)
                oSection1:Cell("A1_LOJA"	):SetValue( SA1->A1_LOJA   			)
                oSection1:Cell("A1_CODOLD"	):SetValue( SA1->A1_CODOLD			)
                oSection1:Cell("A1_NOME"	):SetValue( SA1->A1_NOME		    )
                oSection1:Cell("A1_NREDUZ"  ):SetValue( SA1->A1_NREDUZ		    )
                oSection1:Cell("A1_RISCO"	):SetValue( SA1->A1_RISCO      		)
                oSection1:Cell("A1_STFIN"	):SetValue( SA1->A1_STFIN      		)
                oSection1:Cell("A1_STCOM"	):SetValue( SA1->A1_STCOM      		)
                oSection1:Cell("A1_COND"	):SetValue( SA1->A1_COND      		)
                oSection1:Cell("A1_LC"	    ):SetValue( SA1->A1_LC      		)
                oSection1:Cell("A1_TABPRE"	):SetValue( SA1->A1_TABPRE      	)            
                oSection1:Cell("A1_DESC"	):SetValue( SA1->A1_DESC      		)
                oSection1:Cell("A1_EST"	    ):SetValue( SA1->A1_EST      		)
                oSection1:Cell("A1_MUN"	    ):SetValue( SA1->A1_MUN      		)
                oSection1:Cell("A1_TIPO"	):SetValue( SA1->A1_TIPO      		)
                oSection1:Cell("A1_CGC"	    ):SetValue( SA1->A1_CGC      		)
                oSection1:Cell("A1_INSCR"	):SetValue( SA1->A1_INSCR      		)
                oSection1:Cell("A1_VEND"	):SetValue( SA1->A1_VEND      		)
                oSection1:Cell("A1_BCO1"	):SetValue( SA1->A1_BCO1      		)
                oSection1:Cell("A1_BCO2"	):SetValue( SA1->A1_BCO2      		)
                oSection1:Cell("A1_BCO3"	):SetValue( SA1->A1_BCO3      		)
                oSection1:Cell("A1_BCO4"	):SetValue( SA1->A1_BCO4      		)
                oSection1:Cell("A1_BCO5"	):SetValue( SA1->A1_BCO5      		)
                oSection1:Cell("A1_EMAIL"	):SetValue( SA1->A1_EMAIL      		)
                oSection1:Cell("A1_XONEMO"	):SetValue( SA1->A1_XONEMO      	)

                oSection1:PrintLine()	

            Else

                oSection1:Init()
                
                oSection1:Cell("A1_FGINTE"	):SetValue( X3COMBO("A1_FGINTE",SA1->A1_FGINTE)     )			
                oSection1:Cell("A1_COD"		):SetValue( SA1->A1_COD			                    )
                oSection1:Cell("A1_PESSOA"	):SetValue( X3COMBO("A1_PESSOA",SA1->A1_PESSOA)		)
                oSection1:Cell("A1_LOJA"	):SetValue( SA1->A1_LOJA   			                )
                oSection1:Cell("A1_CODOLD"	):SetValue( SA1->A1_CODOLD			                )
                oSection1:Cell("A1_NOME"	):SetValue( SA1->A1_NOME		    	            )
                oSection1:Cell("A1_NREDUZ"  ):SetValue( SA1->A1_NREDUZ		    	            )
                oSection1:Cell("A1_RISCO"	):SetValue( SA1->A1_RISCO     		                )
                oSection1:Cell("A1_STFIN"	):SetValue( X3COMBO("A1_STFIN",SA1->A1_STFIN)      	)
                oSection1:Cell("A1_STCOM"	):SetValue(X3COMBO("A1_STCOM",SA1->A1_STCOM)       	)
                oSection1:Cell("A1_COND"	):SetValue( SA1->A1_COND      		                )
                oSection1:Cell("A1_LC"	    ):SetValue( SA1->A1_LC      		                )
                oSection1:Cell("A1_TABPRE"	):SetValue( SA1->A1_TABPRE      		            )            
                oSection1:Cell("A1_DESC"	):SetValue( SA1->A1_DESC      		                )
                oSection1:Cell("A1_EST"	    ):SetValue( SA1->A1_EST      		                )
                oSection1:Cell("A1_MUN"	    ):SetValue( SA1->A1_MUN      		                )
                oSection1:Cell("A1_TIPO"	):SetValue( X3COMBO("A1_TIPO",SA1->A1_TIPO)       	)
                oSection1:Cell("A1_CGC"	    ):SetValue( SA1->A1_CGC      		                )
                oSection1:Cell("A1_INSCR"	):SetValue( SA1->A1_INSCR      		                )
                oSection1:Cell("A1_VEND"	):SetValue( SA1->A1_VEND      		                )
                oSection1:Cell("A1_BCO1"	):SetValue( SA1->A1_BCO1      		                )
                oSection1:Cell("A1_BCO2"	):SetValue( SA1->A1_BCO2      		                )
                oSection1:Cell("A1_BCO3"	):SetValue( SA1->A1_BCO3      		                )
                oSection1:Cell("A1_BCO4"	):SetValue( SA1->A1_BCO4      		                )
                oSection1:Cell("A1_BCO5"	):SetValue( SA1->A1_BCO5      		                )
                oSection1:Cell("A1_EMAIL"	):SetValue( SA1->A1_EMAIL      		                )
                oSection1:Cell("ZZL_STSINT"	):SetValue( ZZL->ZZL_STSINT       		            )
                oSection1:Cell("ZZL_STRECF"	):SetValue( ZZL->ZZL_STRECF      		            )
                oSection1:Cell("ZZL_APTOVV"	):SetValue( X3COMBO("ZZL_APTOVV",ZZL->ZZL_APTOVV )  )
                oSection1:Cell("ZZL_VVISTA"	):SetValue( X3COMBO("ZZL_VVISTA",ZZL->ZZL_VVISTA )  )
                oSection1:Cell("ZZL_TABVV"	):SetValue( ZZL->ZZL_TABVV      		            )
                oSection1:Cell("ZZL_CONDVV"	):SetValue( ZZL->ZZL_CONDVV      		            )

                oSection1:PrintLine()	

            EndIf

            SA1->(dbSkip())
        EndDo
    EndIf
 
    oSection1:Finish()

	SA1->( DbCloseArea() )
    ZZL->( DbCloseArea() )

Return Nil

/*/{Protheus.doc} CriaPerg
@description 	Cria perguntas do relatorio
@author 		Leonardo Robes
@version		1.0
@return			Nil
@type 			Function
/*/
Static Function CriaPerg( cPerg )

	Local cPerg	:= PadR( cPerg, 10 )
	Local aPerg	:= {}
	Local lLock	:= .F.
	Local nX	:= 0

	DbSelectArea("SX1")
	DbSetOrder(1)

	Aadd( aPerg, {"Codigo+Loja de ?"			, "C", 08, 00, "G", ""				, ""		, "", "", "", ""	} )
	Aadd( aPerg, {"Codigo+Loja Ate ?"			, "C", 08, 00, "G", ""				, ""		, "", "", "", ""	} )
	
	For nX := 1 To Len(aPerg)

		lLock := !SX1->(Dbseek(cPerg + StrZero(nX, 2)))

		Reclock("SX1", lLock)
		SX1->X1_GRUPO 		:= cPerg
		SX1->X1_ORDEM		:= StrZero(nX, 2)
		SX1->X1_VARIAVL		:= "mv_ch" + Chr( nX + 96 )
		SX1->X1_VAR01		:= "mv_par" + StrZero(nX,2)
		SX1->X1_PRESEL		:= 1
		SX1->X1_PERGUNT		:= aPerg[ nX , 01 ]
		SX1->X1_TIPO 		:= aPerg[ nX , 02 ]
		SX1->X1_TAMANHO		:= aPerg[ nX , 03 ]
		SX1->X1_DECIMAL		:= aPerg[ nX , 04 ]
		SX1->X1_GSC  		:= aPerg[ nX , 05 ]
		SX1->X1_DEF01		:= aPerg[ nX , 06 ]
		SX1->X1_DEF02		:= aPerg[ nX , 07 ]
		SX1->X1_DEF03		:= aPerg[ nX , 08 ]
		SX1->X1_DEF04		:= aPerg[ nX , 09 ]
		SX1->X1_DEF05		:= aPerg[ nX , 10 ]
		SX1->X1_F3   		:= aPerg[ nX , 11 ]
		MsUnlock()
	Next nX

Return Nil
