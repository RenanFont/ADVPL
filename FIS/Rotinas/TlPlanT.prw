//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} User Function TlPlanT
Planilha de TributaÃ§Ã£o
@author FABIANO DE AVILA
@since 15/04/2021
@version 1.0
@type function
/*/

User Function TlPlanT()
	Local aArea   := GetArea()
	Local oBrowse
	Private aRotina := {}
	Private cCadastro := "Planilha de Tributação"

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZM")
	oBrowse:SetDescription(cCadastro)

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao TlPlanT
@author FABIANO DE AVILA
@since 15/04/2021
@version 1.0
@type function
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	aAdd(aRotina, {"Pesquisar",		"AXPESQUI", 0, 1})
	aAdd(aRotina, {"Visualizar",	"AXVISUAL", 0, 2})
	aAdd(aRotina, {"Incluir",		"AXINCLUI", 0, 3})
	aAdd(aRotina, {"Alterar",		"AXALTERA", 0, 4})
	aAdd(aRotina, {"Excluir",		"AXDELETA", 0, 5})
	aAdd(aRotina, {"Excluir",		"AXDELETA", 0, 6})

Return aRotina
