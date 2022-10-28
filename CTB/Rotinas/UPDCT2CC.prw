#INCLUDE "FONT.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AVPRINT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

/*/{Protheus.doc} UPDCT2CC
//Processamento para bkp e update de tabela CT2, CT2_CCC e CT2_CCD
@author Manoel Nésio
@since 27/08/2019
@version undefined
@example
(examples)
@see (links_or_references)
/*/
user function UPDCT2CC()

	Local cContaDe	:= SUPERGETMV("MV_YCT2UP1", .F., "1") 
	Local cContaTe	:= SUPERGETMV("MV_YCT2UP2", .F., "3")
	Local cFilDe	:=	Space(TamSX3("CT2_FILIAL")[1]) //Bruno Tamanaka - Chamado 0422-000048
	Local cFilaTe	:=	Space(TamSX3("CT2_FILIAL")[1]) 
	Private aRet02 := {}
	Private aPergs := {}

	aAdd( aPergs ,{1,"Filial De"	,cFilDe			,""  ,"",""   ,""   ,2         ,.F.}) 
    aAdd( aPergs ,{1,"Filial Ate"	,cFilaTe		,""  ,"",""   ,""   ,2         ,.T.}) 
	aAdd( aPergs ,{1,"Data Inicio:"	,Ctod(Space(8))	,"",".T.","",'.T.',8,.T.})
	aAdd( aPergs ,{1,"Data Fim:"	,Ctod(Space(8))	,"",".T.","",'.T.',8,.T.})
	aAdd( aPergs ,{1,"Conta de:  "	,cContaDe,X3Picture("CT2_DEBITO"),".T.",GetSx3Cache("CT2_DEBITO","X3_F3"),'.F.',20,.F.}) 
	aAdd( aPergs ,{1,"Conta Ate:  "	,cContaTe,X3Picture("CT2_DEBITO"),".T.",GetSx3Cache("CT2_DEBITO","X3_F3"),'.F.',20,.F.})


	If ParamBox(aPergs,"Atualização de Conta Contabil",aRet02,)//,,,,,,"FECHACTB",.T.,.T.)

		Processa({|| AtuCT2(aRet02)  },"Atualizando registros da Tabela CT2...")
		
		MsgInfo("Processamento Concluido!")
	Endif

U_MCERLOG()
return

/*/{Protheus.doc} AtuCT2
//função de processamento para atualizar CT2
@author Manoel Nésio
@since 27/08/2019
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function AtuCT2(aRet02)
	
	Begin Transaction
		
			cQuery := " UPDATE "+RETSQLNAME("CT2")+" SET CT2_CCC = ' ' "
			cQuery += " WHERE D_E_L_E_T_ = ' ' "
			cQuery += " AND CT2_FILIAL BETWEEN '"+ALLTRIM(aRet02[1])+"' AND '"+ALLTRIM(aRet02[2])+"' "
			cQuery += " AND CT2_DATA BETWEEN '"+DTOS(aRet02[3])+"' AND '"+DTOS(aRet02[4])+"' "
			cQuery += " AND (CT2_CREDIT BETWEEN '"+ALLTRIM(aRet02[5])+"' AND '"+ALLTRIM(aRet02[6])+"') AND CT2_CCC <> '' "
		
			If TcSqlExec(cQuery) < 0

				Alert(TcSqlError())

				DisarmTransaction()
			EndIf

			cQuery := " UPDATE "+RETSQLNAME("CT2")+" SET CT2_CCD = ' ' "
			cQuery += " WHERE D_E_L_E_T_ = ' ' "
			cQuery += " AND CT2_FILIAL BETWEEN '"+ALLTRIM(aRet02[1])+"' AND '"+ALLTRIM(aRet02[2])+"' "
			cQuery += " AND CT2_DATA BETWEEN '"+DTOS(aRet02[3])+"' AND '"+DTOS(aRet02[4])+"' "
			cQuery += " AND (CT2_DEBITO BETWEEN '"+ALLTRIM(aRet02[5])+"' AND '"+ALLTRIM(aRet02[6])+"') AND CT2_CCD <> '' "

			If TcSqlExec(cQuery) < 0

				Alert(TcSqlError())

				DisarmTransaction()
			EndIf	

	End Transaction

Return
