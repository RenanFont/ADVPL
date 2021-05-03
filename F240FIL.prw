/*/////////////////////////////////////////////////////
|-----------------------------------------------------|
|O ponto de entrada F240FIL sera utilizado para montar| 
|o filtro para Indregua apos preenchimento da tela de |
|dados do bordero. O filtro retornado pelo ponto de   |
|-----------------------------------------------------|
|LinkTotvs: https://tdn.totvs.com/display/public/mp   |
|+/F240FIL+-+Montagem+de+filtro+--+11723              |                                       
|-----------------------------------------------------|
|Empresa: Parafix.                                    |
|Autor:Renan Freitas.                                 | 
|-----------------------------------------------------|
|Objetivo:Esse filtro criado,ao gerar um bordero no CP| 
|usuÃ¡rio deseja filtrar somente os titulos de        | 
|fornecedor desejado.                                 |
|-----------------------------------------------------|
/*/////////////////////////////////////////////////////

#Include 'Protheus.ch'
#Include 'RWMAKE.CH'


//ponto de entrada para criar filtro antes de abrir o browse do bordero
User Function F240FIL()

	//Declarando variaveis publicas
	LOCAL LojIni1   := SPACE(02)
	LOCAL LojFim2   := "99"
	LOCAL oDlg2     := NIL
	LOCAL MyFilter  := ""
	LOCAL Aarea     := GetArea()
	LOCAL AareaE2   := SE2->(GetArea())
	LOCAL AareaA2   := SA2->(GetArea())

	//Declarando variaveis privadas
	PRIVATE Tickt := .T.
	PRIVATE FornIni1 := SPACE(06)
	PRIVATE FornFim2 := "ZZZZZZ"

			//Criando a tela de perguntas para o filtro, INICIANDO
			@ 100,200 TO 330,500 DIALOG oDlg2 Title "Filtro de Fornecedor"
			@ 002,002 TO 110,150 Title "Fornecedor / Loja"
			@ 020,010 SAY "Fornecedor De"
			@ 020,060 GET FornIni1  PICTURE "@!" F3 "SA2" VALID VALFornIni1()
			@ 035,010 SAY "Fornecedor Ate"
			@ 035,060 GET FornFim2  PICTURE "@!" F3 "SA2"           
			@ 050,010 SAY "Loja De"
			@ 050,060 GET LojIni1 PICTURE "@!"
			@ 065,010 SAY "Loja Ate"
			@ 065,060 GET LojFim2 PICTURE "@!"
			@ 080,010 CHECKBOX "Executar Filtro de Modalidade ?" VAR Tickt
			@ 095,110 BMPBUTTON TYPE 01 ACTION Close(oDlg2)

			//ativando as perguntas criadas
			ACTIVATE DIALOG oDlg2 CENTERED

//Criando busca mencionando os campos nas areas das tabelas
	MyFilter := "E2_FORNECE>='"+FornIni1+"'.AND.E2_FORNECE<='"+FornFim2+"'.AND.E2_LOJA>='"+LojIni1+"'.AND.E2_LOJA<='"+LojFim2+"'"

		RestArea(AareaE2)
		RestArea(AareaA2)
		RestArea(Aarea)

return(MyFilter)
//Gatilho para alimentar os campos do fornecedor.

Static Function VALFornIni1()

			IF FornIni1 <> "      "
			   FornFim2 := FornIni1      
			ELSE
	           FornFim2 := "ZZZZZZ"	
			ENDIF	
//retornando o a variavel de iniciaÃ§Ã£o do filtro 'Tickt' 
return (.T.)
