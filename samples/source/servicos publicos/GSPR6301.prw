#Include "RwMake.ch"

//Ponto de Entradas GSPR6301
//Informar campos adicionais do cadastro de Imóveis para Impressão
	
User Function GSPR6301() 
	Local aCampos := {}
	aAdd( aCampos, { "PR_NUMIMO" , N01->N01_Numero , "", "Numero do Imovel"} )
Return( aCampos )	
