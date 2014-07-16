/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE271  ºAutor  ³Microsiga           º Data ³  30/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao titulos financeiro RC1.              .            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
/***************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/***************************************************************************/
user function Nhgpe271()

  // area atual
  local aArea := getArea()

  private _aGrupo, _clApelido, _clNome   
  // titulo do cadastro
  private cCadastro := "Titulos contas a pagar"

  // funções
  private aRotina := { {"Pesquisar",    "AxPesqui"    ,0,1},;  // botao pesquisar
                       {"Visualizar",   "AxVisual"    ,0,2},;  // botao Visualisa
                       {"Alterar",      "AxAltera"    ,0,3},;  // botao altera
                       {"Incluir",      "U_fgpe271i"  ,0,3}}   // botao inclui

  _aGrupo   :=  {}
  _aGrupo   :=  pswret()                                   	
  _clApelido := _agrupo[1,2 ] // Apelido
  _clNome    := _agrupo[1,4 ] // Nome completo

  // abre o browse com os dados
  dbSelectArea("RC1")
  RC1->(dbSetOrder(1))
  RC1->(dbGoTop())
  SET FILTER TO RC1->RC1_INTEGR == '0'    
  RC1->(dbGoTop())
  
  // abre o browse
  mBrowse(,,,,"RC1", nil, nil, nil, nil, nil,)

  dbSelectArea("RC1")
  SET FILTER TO 
  RC1->(dbGoTop())


return nil


// 
User Function fgpe271i()
	AxInclui("RC1",,,,,,,,,,,,.F.,)
	If Empty(RC1->RC1_EMAILS)
		U_Nhgpe269(1)
	Endif	
Return 

// 
User Function fgpe271a()
	If RC1->RC1_INTEGR == '0' // Nao liberado
		AxAltera("RC1",,,,,,,,,,,,.F.,)
	Endif	
Return 

