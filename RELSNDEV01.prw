#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*--------------------------------------------------------------------------------|
| Relatorio de Senha de devolucao (OmaoriFild)                					  |
|---------------------------------------------|-----------------------------------|                                                                                 
|Desenvolvido para Ceratti                    | Desenvolvedor: RENAN FREITAS      |
|---------------------------------------------|-----------------------------------*/

User Function RELSNDEV01()

	Local oReport := NIL
	Private cAlias := getNextAlias()
	Private cPerg := "SENHA00001"   //sx1

	questPerg(cPerg)
		If Pergunte(cPerg,.T.) //.t. exibe Cperg, .f. close Cperg
			oReport := RMenuDef(cAlias)
			oReport:printDialog()
		ENDIF	
Return

Static Function questPerg(cPerg)

	local aAlias := GetArea()
	local aList := {}
	local i,j 

	cPerg := PadR(cPerg,Len(SX1->X1_GRUPO)," ")

	aaDD(aList,{cPerg,"01","data de?","","","mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@E",""})
	aaDD(aList,{cPerg,"02","data ate?","","","mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@E",""})
	aaDD(aList,{cPerg,"03","Cliente de?","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","CLI","","","","@!",""})
	aaDD(aList,{cPerg,"04","Cliente ate?","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","CLI","","","","@!",""})
	aaDD(aList,{cPerg,"05","Vendedor de?","","","mv_ch5","C",6,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","@!",""})
	aaDD(aList,{cPerg,"06","Vendedor ate?","","","mv_ch6","C",6,0,0,"G","","MV_PAR06","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA3","","","","@!",""})

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
		For i := 1 to len(aList)
			If	!DbSeek(cPerg+aList[i,2])
				RecLock("SX1", .T.)
				For j := 1 to FCount()
					FIELDPUT(j,aList[i,j])
				NEXT
				MsUnlock()
			EndIF
		NEXT
	RestArea(aAlias)


Return

//PRINT query SQL
Static Function QuerySQL(oReport,cAlias)

	Local oSecao1 := oReport:Section(1) //variavel local declarando 1 seessao
	//Local cMsg := "Extraindo dados, aguarde!"
	
	oSecao1:BeginQuery()

BeginSQL Alias cAlias
	
	select 
		
		ZAD.ZAD_SENHA,
		ZAD.ZAD_DATA,
		ZAD.ZAD_HORA,
		ZAD.ZAD_FILIAL,
		ZAD.ZAD_SERIE,
		ZAD.ZAD_NFISCA,
		ZAD.ZAD_DTREC,
		ZAD.ZAD_CLIENT,
		ZAD.ZAD_LOJA,
		A1.A1_NOME,
		A1.A1_BAIRRO,
		A1.A1_MUN,
		A1.A1_EST,
		ZAD.ZAD_TRANSP,
		ZAD.ZAD_CARRO,
		ZAD.ZAD_OCORRE,
		ZAD.ZAD_DETALH,
		ZAD.ZAD_PESO,
		ZAD.ZAD_VALOR, 
		ZAD.ZAD_NDP,
		ZAD.ZAD_PESOP,
		ZAD.ZAD_VALORP,
		ZAD.ZAD_USER,
		ZAD.ZAD_NOMUSR,
		A3.A3_NOME

	from %table:ZAD010% ZAD

		INNER JOIN %table:SA1010% A1 ON (A1.A1_COD = ZAD.ZAD_CLIENT)
		INNER JOIN %table:SA3010% A3 ON (A3.A3_COD = A1.A1_VEND)

	WHERE 	
			 ZAD.%notDel% 
		AND  A1.%notDel% 
		AND  A3.%notDel%
		AND ZAD.ZAD_DATA BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
		AND A1.A1_COD    BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%
		AND A3.A3_COD    BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%

		ORDER BY ZAD.ZAD_DATA;

EndSQL


    oSecao1:EndQuery() //CLOSE Query
		
	oReport:SetMeter((cAlias)->(LASTREC()))//(PRINT DATE LOADING...)

    oSecao1:Print() //PRINT query


Return

Static Function RMenuDef(cAlias)

	Local cTitulo 	:= "Relatorio de Senha de devolucao"
	Local cHelp 	:= "Relatorio para informações referente a inclusão de Senha de devolucao"
	Local oReport	:= NIL
	Local oSection1	:= NIL

	//Instanciando OBJETO TReport
	oReport := TReport():New('RELSNDEV01',cTitulo,cPerg,{|oReport|QuerySQL(oReport,cAlias)},cHelp)
	oReport:SetLandscape(.T.)
	
	//SECTION 
	oSection1 := TRSection():New(oReport, "Senha de devolucao", {cAlias} )

	//TABELS
	TRCell():New(oSection1,	"ZAD_SENHA",	cAlias,	"Senha"		)
	TRCell():New(oSection1,	"ZAD_DATA",		cAlias,	"DataDev"	)
	TRCell():New(oSection1,	"ZAD_HORA",	    cAlias,	"Hora"		)
	TRCell():New(oSection1,	"ZAD_FILIAL",	cAlias,	"Filial"	)
	TRCell():New(oSection1,	"ZAD_SERIE",	cAlias,	"Serie" 	)
	TRCell():New(oSection1,	"ZAD_NFISCA",	cAlias,	"NFe"		)
	TRCell():New(oSection1,	"ZAD_DTREC",	cAlias,	"DtReceb "	)
	TRCell():New(oSection1,	"ZAD_CLIENT",	cAlias,	"CodCliente")
	TRcell():New(oSection1,	"ZAD_LOJA",		cAlias,	"Loja"		)
	TRCell():New(oSection1,	"A1_NOME",		cAlias,	"Cliente"	)
	TRCell():New(oSection1,	"A1_BAIRRO",	cAlias,	"Bairro"	)
	TRCell():New(oSection1,	"A1_MUN",	    cAlias,	"Cidade"	)
	TRCell():New(oSection1,	"A1_EST",		cAlias,	"UF"		)
	TRCell():New(oSection1,	"ZAD_TRANSP",	cAlias,	"Transp"	)
	TRCell():New(oSection1,	"ZAD_CARRO",	cAlias,	"Carro"		)
	TRCell():New(oSection1,	"ZAD_OCORRE",	cAlias,	"Ocorrencia")
	TRCell():New(oSection1,	"ZAD_DETALH",	cAlias,	"Detalhe"	)
	TRCell():New(oSection1,	"ZAD_PESO",		cAlias,	"Peso"		)
	TRCell():New(oSection1,	"ZAD_VALOR",	cAlias,	"Valor"		)
	TRCell():New(oSection1,	"ZAD_NDP",		cAlias,	"NFDParc"	)
	TRCell():New(oSection1,	"ZAD_PESOP",	cAlias,	"PesoParc"	)
	TRCell():New(oSection1,	"ZAD_VALORP",	cAlias,	"ValParc"	)
	TRCell():New(oSection1,	"ZAD_USER",		cAlias,	"CodUser"	)
	TRCell():New(oSection1,	"ZAD_NOMUSR",	cAlias,	"Usuário"	)
	TRCell():New(oSection1,	"A3_NOME",		cAlias,	"Responsavel")

	
Return (oReport)
