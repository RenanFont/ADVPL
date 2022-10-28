#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FISR0010
Impress찾o do Relat처rio.EXPDADOS*
@author FABIANO.AVILA
@since 08/04/2021
@param cQuery, characters, Query.
@type function
/*/
user function FISR0010()
	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	
    Local aParamBox	:= {}
	Private cTitulo 	:= OemToAnsi("Relatorio de Devolu寤es de Clientes - Central XML")

	AADD(aParamBox,{1, "Data De"	   	    ,dDataDe	,""  ,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   	    ,dDataAte	,""  ,"",""	  ,""   ,50         ,.T.})


	lRet := ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)

	If lRet

	dDataDe		:= MV_PAR01
	dDataAte	:= MV_PAR02
	
	Processa({|| FISR0010A1(dDataDe, dDataAte)})

	EndIf
    
    U_MCERLOG()
return

/*/{Protheus.doc} FISR0010A1
Impress찾o do Relat처rio.EXPDADOS*
@author FABIANO.AVILA
@since 04/12/2020
@param cQuery, characters, Query.
@type function
/*/
Static Function FISR0010A1(dDataDe, dDataAte)
	local cQuery := ""

cQuery += "		SELECT * FROM [dbo].[DEVOLUCAO_CENTRAL_XML]('"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"')																												" + CRLF
	
ConOut(cQuery)
	Processa({ || FISR0010A2(cQuery)})
	
return 

/*/{Protheus.doc} FISR0010A2
Impress찾o do Relat처rio.EXPDADOS*
@author FABIANO.AVILA
@since 08/04/2021
@param cQuery, characters, Query.
@type function
/*/
Static Function FISR0010A2(cQuery)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Devolucoes_de_clientes" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := cQuery
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return
