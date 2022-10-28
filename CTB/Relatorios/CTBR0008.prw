#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} CTBR0008
Impressao do Relatorio de Reconciliação dos Impostos
@author Fabiano de Avila
@since 06/10/2021
@param cQuery, characters, Query.
@type function
/*/
user function CTBR0008()
	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
	Local lRet 		:= .T.
	local aCEmp		:= {"01=Omamori"	, "02=Cidade do Sol"	,	"06=Talis"	,	"07=Clean-Field"}
	Local aParamBox	:= {}
	Private cTitulo 	:= "Relatório Impostos: Entradas e Saídas"
	
	AADD(aParamBox,{1, "Data De"	   ,		dDataDe		,""  ,"",""   ,""   ,80         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,		dDataAte	,""  ,"",""	  ,""   ,80         ,.T.}) 		   
	AADD(aParamBox,{2, "Empresa"	   ,"01",	aCEmp		,80  ,".T."   , .F.                 })
  
	lRet := ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
	
	If lRet

		Processa({|| CTBR0008B(MV_PAR01, MV_PAR02, MV_PAR03)})
	EndIf
	
	U_MCERLOG()
return


/*/{Protheus.doc} CTBR0008B
Impressao do Relatorio de Reconciliação dos Impostos
@author Fabiano de Avila
@since 06/10/2021
@param cQuery, characters, Query.
@type function
/*/
Static Function CTBR0008B(dDataDe, dDataAte, aCEmp)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Reconciliacao_Impostos_" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	Local cQryFat	:= ""
	Local cQryCom	:= ""
	
	cQryCom		:= RetQueryCom(dDataDe, dDataAte, aCEmp)
	cQryFat		:= RetQueryFat(dDataDe, dDataAte, aCEmp)


	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:OpenClasExcel()
	
	//COMPRAS
	oObjExcel:cQuery := cQryCom
	oObjExcel:SetNomePlanilha("ENTRADAS")
	oObjExcel:PrintXml()

	//FATURAMENTO
	oObjExcel:cQuery := cQryFat
	oObjExcel:SetNomePlanilha("SAÍDAS")
	oObjExcel:PrintXml()
	
	
	oObjExcel:CloseClasExcel()

Return

/*/{Protheus.doc} RetQueryFat
Impressao do Relatorio de Reconciliação dos Impostos
@author Fabiano de Avila
@since 06/10/2021
@param cQuery, characters, Query.
@type function
/*/
Static Function RetQueryCom(dDataDe,dDataAte,aCEmp)

local cQuery 	:= ""

	If	aCEmp == '01'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_COM_OMA] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	elseif aCEmp == '02'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_COM_CER] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	elseif aCEmp == '06'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_COM_TAL] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	elseif aCEmp == '07'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_COM_CLE] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	endIf



return cQuery

/*/{Protheus.doc} RetQueryCom
Impressao do Relatorio de Reconciliação dos Impostos
@author Fabiano de Avila
@since 06/10/2021
@param cQuery, characters, Query.
@type function
/*/
Static Function RetQueryFat(dDataDe, dDataAte,aCEmp)
 
	local cQuery 	:= ""
	
	If aCEmp == '01'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_FAT_OMA] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	elseif aCEmp == '02'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_FAT_CER] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	elseif aCEmp == '06'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_FAT_TAL] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	elseif aCEmp == '07'

		cQuery += "	EXEC [dbo].[CTB_CONCILIA_FAT_CLE] '"+dToS(dDataDe)+"' , '"+dToS(dDataAte)+"'	" + CRLF

	endIf
	
	
return cQuery
