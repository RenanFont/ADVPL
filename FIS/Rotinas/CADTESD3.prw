//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "FWMBROWSE.CH"
#INCLUDE "Rwmake.ch"

#Define ENTER CHR(13)+CHR(10)

//Vari�veis Est�ticas
Static cTitulo := "TES x Movimento Interno"

/*/{Protheus.doc} CADTESD3
@description 	Rotina de Cadastro de Tes para gera��o de D3 para 
ajuste de ICMS
@author			Manoel Nesio Sousa Neto
@since			17/09/2019
@version		1.0
@return			Nil
@type 			Function
/*/
User Function CADTESD3()
	Local aArea   := GetArea()
	Local oBrowse

	Private bCommit  := { || xCommitModel() }
	
	DbSelectArea('Z11')
	dbSetOrder(1)

	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("Z11")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	oBrowse:SetMenuDef( 'CADTESD3' )

	//Legendas
	oBrowse:AddLegend( "Z11_MSBLQL <> '1'", 'GREEN', "Ativo" )
	oBrowse:AddLegend( "Z11_MSBLQL = '1'", "RED"  , "Bloqueado" )

	//Ativa a Browse
	oBrowse:Activate()
	
	U_MCERLOG()
	
	RestArea(aArea)

Return Nil

/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Autor: Manoel Nesio Sousa Neto                                      |
| Data:  09/2020                                                      |
| Desc:  Cria��o do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function MenuDef()

	Private aRot := {}

	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CADTESD3' OPERATION 1   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CADTESD3' OPERATION 3 ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CADTESD3' OPERATION 4 ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CADTESD3' OPERATION 5 ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
| Func:  ModelDef                                                     |
| Autor: Manoel Nesio Sousa Neto                                      |
| Data:  09/2020                                                      |
| Desc:  Cria��o do modelo de dados MVC                               |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil

	//Cria��o da estrutura de dados utilizada na interface
	Local oStZ11 := FWFormStruct(1, "Z11")

	aAux := FwStruTrigger( "Z11_PRODUT" , "Z11_DESPRD" , "SB1->B1_DESC" , .T. , "SB1" , 1 , "xFilial('SB1')+M->Z11_PRODUT" )
	oStZ11:AddTrigger(   aAux[1] , aAux[2] , aAux[3] , aAux[4] )

	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MvcCadtes",/*bPre*/,/*bPos*/,bCommit,/*bCancel*/) 

	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZ11",/*cOwner*/,oStZ11)

	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'Z11_FILIAL','Z11_TES','Z11_PRODUT','Z11_FORNECE','Z11_LOJA'})

	//Adicionando descri��o ao modelo
	oModel:SetDescription(cTitulo)

	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZ11"):SetDescription(cTitulo)

	//oModel:SetVldActivate( { | oModel | xPreValid( oModel ) } )

Return oModel

/*---------------------------------------------------------------------*
| Func:  ViewDef                                                      |
| Autor: Manoel Nesio Sousa Neto                                      |
| Data:  09/2020                                                      |
| Desc:  Cria��o da vis�o MVC                                         |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ViewDef()

	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("CADTESD3")

	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZ11 := FWFormStruct(2, "Z11")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'Z11_NOME|Z11_DTAFAL|'}

	//Criando oView como nulo
	Local oView := Nil

	oStZ11:RemoveField( 'Z11_FILIAL' )
	
	//Grupos
	oStZ11:AddGroup( 'GRUPO01', '', '', 1 )
	oStZ11:AddGroup( 'GRUPO02', 'Produto', '', 2 )
	oStZ11:AddGroup( 'GRUPO03', 'Fornecedor', '', 3 )
	
	oStZ11:SetProperty( 'Z11_TES' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	//oStZ11:SetProperty( 'Z11_MSBLQL' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	oStZ11:SetProperty( 'Z11_PRODUT' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStZ11:SetProperty( 'Z11_DESPRD' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )

	
	oStZ11:SetProperty( 'Z11_FORNEC' , MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStZ11:SetProperty( 'Z11_LOJA' , MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStZ11:SetProperty( 'Z11_NOMFOR' , MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	

	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Atribuindo formul�rios para interface
	oView:AddField("FORMZ11", oStZ11)//, "FORMZ11")
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)

	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('FORMZ11', 'Tes' )  

	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})

	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("FORMZ11","TELA")

Return oView

Static Function xCommitModel()

	Local aArea     := GetArea()
	Local lRet      := .T.
	Local oModel    := FWModelActive()
	
	lRet := fwformcommit(oModel)

	
	RestArea(aArea)

Return lRet
