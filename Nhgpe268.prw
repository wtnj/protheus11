/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE268  ºAutor  ³Microsiga           º Data ³  29/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprovacao titulos para integrar com financeiro.            º±±
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
user function Nhgpe268()

  // area atual
  local aArea := getArea()

  private _aGrupo, _clApelido, _clNome   
  // titulo do cadastro
  private cCadastro := "Plano de Recuperação de Produção Horas Extras"

  // funções
  private aRotina := { {"Pesquisar",    "AxPesqui"   ,0,1},;  // botao pesquisar
                       {"Visualizar",   "AxVisual"   ,0,2},;  // botao Visualisa
                       {"Aprovar",      "U_fgpe268a" ,0,3}}  // botao aprovacao 
                       //{"Aprova Todos", "U_fgpe268t" ,0,4}}   // botao aprovacao todos 

  _aGrupo   :=  {}
  _aGrupo   :=  pswret()                                   	
  _clApelido := _agrupo[1,2 ] // Apelido
  _clNome    := _agrupo[1,4 ] // Nome completo

  // abre o browse com os dados
  dbSelectArea("RC1")
  RC1->(dbSetOrder(1))
  RC1->(dbGoTop())
    
  set filter to Empty(RC1->RC1_STATUS)
  RC1->(dbGoTop())

  // abre o browse
  mBrowse(,,,,"RC1", nil, nil, nil, nil, nil,)

  set filter to 
  RC1->(dbGoTop())
  
  // restaura a area
  restArea(aArea)

return nil


//
Static Function fEnd() 
   Close(oDialog) 

Return

// 
User Function fgpe268a()

If MsgBox("Aprova Pagamento do Titulo ","Aprovar","YESNO")
  
	DbSelectArea("RC1")
	
	Reclock("RC1",.F.)
	RC1->RC1_STATUS  := "A" 
	RC1->RC1_APROVA  := _clApelido
	RC1->RC1_INTEGR  := "1"		
	RC1->RC1_DTAPRO  := DATE()
	RC1->RC1_HAPROV  := TIME()
	MsUnlock("RC1")

	_fGravaSe2()
	U_Nhgpe269(2)
	
	COMMIT
	RC1->(dbGotop())
	
Endif

Return 

 
// 
User Function fgpe268t()

If MsgBox("Aprova Pagamento do Titulo ","Aprovacao","YESNO")
  
	DbSelectArea("RC1")
	RC1->(dbGotop())
	While !RC1->(Eof())
		Reclock("RC1",.F.)
		RC1->RC1_STATUS  := "A" 
		RC1->RC1_APROVA  := _clApelido
		RC1->RC1_INTEGR  := "2"		
		MsUnlock("RC1")
		RC1->(dbSkip())			
	Enddo
	COMMIT
	U_Nhgpe269()
	RC1->(dbGotop())

Endif

Return 



// 
Static Function _fGravaSe2()
Local aTitulo, nOpc, lMsErroAuto

	dbSelectArea("SA2")
	dbSetOrder(1)
	If dbSeek(xFilial()+RC1->RC1_FORNEC+RC1->RC1_LOJA)

		aTitulo := { {"E2_PREFIXO"	, RC1->RC1_PREFIX,    Nil},;
		              {"E2_NUM"		, RC1->RC1_NUMTIT,    Nil},;
				      {"E2_PARCELA"	, '',			      Nil},;
				      {"E2_TIPO"	, RC1->RC1_TIPO,      Nil},;
				      {"E2_NATUREZ"	, RC1->RC1_NATURE,    Nil},;
				      {"E2_FORNECE"	, RC1->RC1_FORNEC,    Nil},;
				      {"E2_LOJA"	, RC1->RC1_LOJA,      Nil},;
				      {"E2_EMISSAO"	, RC1->RC1_EMISSA,    NIL},;
				      {"E2_VENCTO"	, RC1->RC1_VENCTO,    NIL},;
				      {"E2_VENCREA"	, RC1->RC1_VENREA,    NIL},;
				      {"E2_ORIGEM"	, 'NHGPE268',         NIL},;
				      {"E2_VALOR"	, RC1->RC1_VALOR,     Nil}}
				      
		lMsErroAuto := .F.
		nOpc        := 3    // Inclusao
		MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,nOpc)

	Endif		


Return(.t.)
