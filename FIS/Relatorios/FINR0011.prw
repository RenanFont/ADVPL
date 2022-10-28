#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} FINR0011
Impressao Relatório Consulta Cliente
@author Vitor Costa
@since 01/10/20
@param cQuery, characters, Query.
@type function
/*/
user function FINR0011()
	Local dDataDe	:= Date()
	Local dDataAte	:= Date()
    Local cCliente  := Space(TamSX3("A1_COD")[1])
	Local aStatus   := {'A=Aberto', 'P=Pago', 'T=Todos'}
	Local cStatus   := 'A'

	Local aParamBox	:= {}
	Private cTitulo 	:= "Consulta Financeira Cliente"
	
	AADD(aParamBox,{1, "Data De"	   ,dDataDe		,""  		,"",""   ,""   ,50         ,.T.}) 
	AADD(aParamBox,{1, "Data Ate"	   ,dDataAte	,""  		,"",""	  ,""   ,50         ,.T.})
	AADD(aParamBox,{1, "Cliente"	   ,cCliente	,""  		,"","SA1",""   ,50         ,.T.})    
	AAdd(aParamBox,{2, "Status "       ,cStatus     ,aStatus	,70	,".T.",.T.,".T."} )


	If ParamBox(aParamBox, cTitulo,,,, .T.,,,,,.T.,.T.)
		Processa({|| FINR0011B( MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04 ) } )
	EndIf
	
	U_MCERLOG()
return

/*/{Protheus.doc} FINR0011A
Impressao Relatório Consulta Cliente
@author Vitor Costa
@since 01/10/20
@param cQuery, characters, Query.
@type function
/*/
Static Function FINR0011A(dDataDe, dDataAte,cCliente, cStatus)
	local cQuery 	:= ""

	cQuery += " SELECT 'OMAMORI' EMPRESA,                                                                              " +CRLF
	cQuery += " 	E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VEND1,E1_VALOR,E1_SALDO,                " +CRLF
	cQuery += " 	CONVERT(DATE, E1_EMISSAO, 103) E1_EMISSAO,                                                         " +CRLF
	cQuery += " 	CONVERT(DATE, E1_VENCREA, 103) E1_VENCREA,                                                         " +CRLF
	cQuery += " 	CASE WHEN E1_BAIXA = '' THEN NULL ELSE CONVERT(DATE, E1_BAIXA, 103) END  E1_BAIXA,                   " +CRLF
	cQuery += " 	E5_MOTBX,                                                                                          " +CRLF
	cQuery += " 			CASE																					   " +CRLF	 
	cQuery += " 			WHEN E1_BAIXA = '' THEN DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),GETDATE()) ELSE	   " +CRLF	 
	cQuery += " 			DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),CONVERT(DATE, E1_BAIXA, 103)) END DIAS,	   " +CRLF	 
	cQuery += " 	E1_HIST                                                                                            " +CRLF
	cQuery += " FROM SE1010 SE1 (NOLOCK)                                                                               " +CRLF         
	cQuery += " 	LEFT JOIN SE5010 SE5 (NOLOCK) ON                                                                   " +CRLF         
	cQuery += " 		E5_FILIAL = E1_FILIAL                                                                          " +CRLF         
	cQuery += " 		AND E5_NUMERO = E1_NUM                                                                         " +CRLF         
	cQuery += " 		AND E5_PREFIXO = E1_PREFIXO                                                                    " +CRLF         
	cQuery += " 		AND E5_TIPO = E1_TIPO                                                                          " +CRLF         
	cQuery += " 		AND E5_CLIENTE = E1_CLIENTE                                                                    " +CRLF         
	cQuery += " 		AND E5_LOJA = E1_LOJA                                                                          " +CRLF         
	cQuery += " 		AND SE5.D_E_L_E_T_ = ''                                                                        " +CRLF         
	cQuery += " WHERE E1_CLIENTE	= '"+ cCliente +"'	                                                               " +CRLF
	cQuery += " 	AND E1_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                " +CRLF
	cQuery += " 	AND SE1.D_E_L_E_T_ = ''                                                                            " +CRLF
	If cStatus == 'A'
		cQuery+= "	AND SE1.E1_SALDO > 0                                                                               " + CRLF
	ElseIf cStatus == 'P'
		cQuery+= "	AND SE1.E1_SALDO = 0                                                                               " + CRLF
	Endif
	cQuery += "                                                                                                        " +CRLF
	cQuery += " UNION                                                                                                  " +CRLF
	cQuery += "                                                                                                        " +CRLF
	cQuery += " SELECT 'CERATTI' EMPRESA,                                                                              " +CRLF
	cQuery += " 	E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VEND1,E1_VALOR,E1_SALDO,                " +CRLF
	cQuery += " 	CONVERT(DATE, E1_EMISSAO, 103) E1_EMISSAO,                                                         " +CRLF
	cQuery += " 	CONVERT(DATE, E1_VENCREA, 103) E1_VENCREA,                                                         " +CRLF
	cQuery += " 	CASE WHEN E1_BAIXA = '' THEN NULL ELSE CONVERT(DATE, E1_BAIXA, 103) END  E1_BAIXA,                   " +CRLF
	cQuery += " 	E5_MOTBX,                                                                                          " +CRLF
	cQuery += " 			CASE																					   " +CRLF	 
	cQuery += " 			WHEN E1_BAIXA = '' THEN DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),GETDATE()) ELSE	   " +CRLF	 
	cQuery += " 			DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),CONVERT(DATE, E1_BAIXA, 103)) END DIAS,	   " +CRLF	 
	cQuery += " 	E1_HIST                                                                                            " +CRLF
	cQuery += " FROM SE1020 SE1 (NOLOCK)                                                                               " +CRLF         
	cQuery += " 	LEFT JOIN SE5020 SE5 (NOLOCK) ON                                                                   " +CRLF         
	cQuery += " 		E5_FILIAL = E1_FILIAL                                                                          " +CRLF         
	cQuery += " 		AND E5_NUMERO = E1_NUM                                                                         " +CRLF         
	cQuery += " 		AND E5_PREFIXO = E1_PREFIXO                                                                    " +CRLF         
	cQuery += " 		AND E5_TIPO = E1_TIPO                                                                          " +CRLF         
	cQuery += " 		AND E5_CLIENTE = E1_CLIENTE                                                                    " +CRLF         
	cQuery += " 		AND E5_LOJA = E1_LOJA                                                                          " +CRLF         
	cQuery += " 		AND SE5.D_E_L_E_T_ = ''                                                                        " +CRLF         
	cQuery += " WHERE E1_CLIENTE	= '"+ cCliente +"'	                                                               " +CRLF
	cQuery += " 	AND E1_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                " +CRLF
	cQuery += " 	AND SE1.D_E_L_E_T_ = ''                                                                            " +CRLF
	If cStatus == 'A'
		cQuery+= "	AND SE1.E1_SALDO > 0                                                                               " + CRLF
	ElseIf cStatus == 'P'
		cQuery+= "	AND SE1.E1_SALDO = 0                                                                               " + CRLF
	Endif
	cQuery += " 	                                                                                                   " +CRLF
	cQuery += " UNION                                                                                                  " +CRLF
	cQuery += "                                                                                                        " +CRLF
	cQuery += " SELECT 'TALIS' EMPRESA,                                                                                 " +CRLF
	cQuery += " 	E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VEND1,E1_VALOR,E1_SALDO,                " +CRLF
	cQuery += " 	CONVERT(DATE, E1_EMISSAO, 103) E1_EMISSAO,                                                         " +CRLF
	cQuery += " 	CONVERT(DATE, E1_VENCREA, 103) E1_VENCREA,                                                         " +CRLF
	cQuery += " 	CASE WHEN E1_BAIXA = '' THEN NULL ELSE CONVERT(DATE, E1_BAIXA, 103) END  E1_BAIXA,                   " +CRLF
	cQuery += " 	E5_MOTBX,                                                                                          " +CRLF
	cQuery += " 			CASE																					   " +CRLF	 
	cQuery += " 			WHEN E1_BAIXA = '' THEN DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),GETDATE()) ELSE	   " +CRLF	 
	cQuery += " 			DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),CONVERT(DATE, E1_BAIXA, 103)) END DIAS,	   " +CRLF	 
	cQuery += " 	E1_HIST                                                                                            " +CRLF
	cQuery += " FROM SE1060 SE1 (NOLOCK)                                                                               " +CRLF         
	cQuery += " 	LEFT JOIN SE5060 SE5 (NOLOCK) ON                                                                   " +CRLF         
	cQuery += " 		E5_FILIAL = E1_FILIAL                                                                          " +CRLF         
	cQuery += " 		AND E5_NUMERO = E1_NUM                                                                         " +CRLF         
	cQuery += " 		AND E5_PREFIXO = E1_PREFIXO                                                                    " +CRLF         
	cQuery += " 		AND E5_TIPO = E1_TIPO                                                                          " +CRLF         
	cQuery += " 		AND E5_CLIENTE = E1_CLIENTE                                                                    " +CRLF         
	cQuery += " 		AND E5_LOJA = E1_LOJA                                                                          " +CRLF         
	cQuery += " 		AND SE5.D_E_L_E_T_ = ''                                                                        " +CRLF         
	cQuery += " WHERE E1_CLIENTE	= '"+ cCliente +"'	                                                               " +CRLF
	cQuery += " 	AND E1_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                " +CRLF
	cQuery += " 	AND SE1.D_E_L_E_T_ = ''                                                                            " +CRLF
	If cStatus == 'A'
		cQuery+= "	AND SE1.E1_SALDO > 0                                                                               " + CRLF
	ElseIf cStatus == 'P'
		cQuery+= "	AND SE1.E1_SALDO = 0                                                                               " + CRLF
	Endif
	cQuery += "                                                                                                        " +CRLF
	cQuery += " UNION                                                                                                  " +CRLF
	cQuery += "                                                                                                        " +CRLF
	cQuery += " SELECT 'CLEAN FIELD' EMPRESA,                                                                          " +CRLF
	cQuery += " 	E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VEND1,E1_VALOR,E1_SALDO,                " +CRLF
	cQuery += " 	CONVERT(DATE, E1_EMISSAO, 103) E1_EMISSAO,                                                         " +CRLF
	cQuery += " 	CONVERT(DATE, E1_VENCREA, 103) E1_VENCREA,                                                         " +CRLF
	cQuery += " 	CASE WHEN E1_BAIXA = '' THEN NULL ELSE CONVERT(DATE, E1_BAIXA, 103) END  E1_BAIXA,                   " +CRLF
	cQuery += " 	E5_MOTBX,                                                                                          " +CRLF
	cQuery += " 			CASE																					   " +CRLF	 
	cQuery += " 			WHEN E1_BAIXA = '' THEN DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),GETDATE()) ELSE	   " +CRLF	 
	cQuery += " 			DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),CONVERT(DATE, E1_BAIXA, 103)) END DIAS,	   " +CRLF	 
	cQuery += " 	E1_HIST                                                                                            " +CRLF
	cQuery += " FROM SE1070 SE1 (NOLOCK)                                                                               " +CRLF         
	cQuery += " 	LEFT JOIN SE5070 SE5 (NOLOCK) ON                                                                   " +CRLF         
	cQuery += " 		E5_FILIAL = E1_FILIAL                                                                          " +CRLF         
	cQuery += " 		AND E5_NUMERO = E1_NUM                                                                         " +CRLF         
	cQuery += " 		AND E5_PREFIXO = E1_PREFIXO                                                                    " +CRLF         
	cQuery += " 		AND E5_TIPO = E1_TIPO                                                                          " +CRLF         
	cQuery += " 		AND E5_CLIENTE = E1_CLIENTE                                                                    " +CRLF         
	cQuery += " 		AND E5_LOJA = E1_LOJA                                                                          " +CRLF         
	cQuery += " 		AND SE5.D_E_L_E_T_ = ''                                                                        " +CRLF         
	cQuery += " WHERE E1_CLIENTE	= '"+ cCliente +"'	                                                               " +CRLF
	cQuery += " 	AND E1_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                " +CRLF
	cQuery += " 	AND SE1.D_E_L_E_T_ = ''                                                                            " +CRLF
	If cStatus == 'A'
		cQuery+= "	AND SE1.E1_SALDO > 0                                                                               " + CRLF
	ElseIf cStatus == 'P'
		cQuery+= "	AND SE1.E1_SALDO = 0                                                                               " + CRLF
	Endif
	cQuery += "                                                                                                        " +CRLF
	cQuery += " UNION                                                                                                  " +CRLF
	cQuery += "                                                                                                        " +CRLF
	cQuery += " SELECT 'GRIGRI' EMPRESA,                                                                               " +CRLF
	cQuery += " 	E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VEND1,E1_VALOR,E1_SALDO,                " +CRLF
	cQuery += " 	CONVERT(DATE, E1_EMISSAO, 103) E1_EMISSAO,                                                         " +CRLF
	cQuery += " 	CONVERT(DATE, E1_VENCREA, 103) E1_VENCREA,                                                         " +CRLF
	cQuery += " 	CASE WHEN E1_BAIXA = '' THEN NULL ELSE CONVERT(DATE, E1_BAIXA, 103) END  E1_BAIXA,                   " +CRLF
	cQuery += " 	E5_MOTBX,                                                                                          " +CRLF
	cQuery += " 			CASE																					   " +CRLF	 
	cQuery += " 			WHEN E1_BAIXA = '' THEN DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),GETDATE()) ELSE	   " +CRLF	 
	cQuery += " 			DATEDIFF (day,CONVERT(DATE, E1_VENCREA, 103),CONVERT(DATE, E1_BAIXA, 103)) END DIAS,	   " +CRLF	 
	cQuery += " 	E1_HIST                                                                                            " +CRLF
	cQuery += " FROM SE1050 SE1 (NOLOCK)                                                                               " +CRLF         
	cQuery += " 	LEFT JOIN SE5050 SE5 (NOLOCK) ON                                                                   " +CRLF         
	cQuery += " 		E5_FILIAL = E1_FILIAL                                                                          " +CRLF         
	cQuery += " 		AND E5_NUMERO = E1_NUM                                                                         " +CRLF         
	cQuery += " 		AND E5_PREFIXO = E1_PREFIXO                                                                    " +CRLF         
	cQuery += " 		AND E5_TIPO = E1_TIPO                                                                          " +CRLF         
	cQuery += " 		AND E5_CLIENTE = E1_CLIENTE                                                                    " +CRLF         
	cQuery += " 		AND E5_LOJA = E1_LOJA                                                                          " +CRLF         
	cQuery += " 		AND SE5.D_E_L_E_T_ = ''                                                                        " +CRLF         
	cQuery += " WHERE E1_CLIENTE	= '"+ cCliente +"'	                                                               " +CRLF
	cQuery += " 	AND E1_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"'                                " +CRLF
	cQuery += " 	AND SE1.D_E_L_E_T_ = ''                                                                            " +CRLF
	If cStatus == 'A'
		cQuery+= "	AND SE1.E1_SALDO > 0                                                                               " + CRLF
	ElseIf cStatus == 'P'
		cQuery+= "	AND SE1.E1_SALDO = 0                                                                               " + CRLF
	Endif
	cQuery += " ORDER BY E1_EMISSAO                                                                                    " +CRLF

	
return cQuery

/*/{Protheus.doc} FINR0011B
Impressao Relatório Consulta Cliente
@author Vitor Costa
@since 01/10/20
@param cQuery, characters, Query.
@type function
/*/
Static Function FINR0011B(dDataDe, dDataAte,cCliente,cStatus)
	Local cTipoEmp	:= AllTrim(SM0->M0_NOME) + "_" + AllTrim(SM0->M0_CODFIL)
	Local cFileName	:= "Consulta Financeira Cliente" + cTipoEmp	
	Local oObjExcel	:= ExportDados():New()
	
	oObjExcel:OpenGetFile() 
	oObjExcel:SetNomeArquivo(cFileName, .T., .T.)
	oObjExcel:SetTitulo(cTitulo)
	oObjExcel:OpenClasExcel()
	oObjExcel:cQuery := FINR0011A(dDataDe, dDataAte,cCliente,cStatus)
	oObjExcel:SetNomePlanilha(cTitulo)
	oObjExcel:PrintXml()	
	oObjExcel:CloseClasExcel()
Return
