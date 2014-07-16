/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ NHEST207  ºAutor ³ Guilherme D. Camargo  ºData ³ 27/08/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³          CADASTRO DE PERMISSÕES DE                         º±±
±±º          ³         MOVIMENTAÇÃO ENTRE ARMAZÉNS                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³             ESTOQUE / CUSTOS                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.ch"

User Function NHEST207()
Private cQuery := ''
Private aRotina, cCadastro
cCadastro := "Movimentação Armazéns."
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"AxVisual" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"        ,"u_e207Inc"    , 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"u_e207Alt"  	, 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"u_e207Del"  	, 0 , 5})
mBrowse(6,1,22,75,"ZEQ",,,,,,)
Return

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßß        Função de Inclusão        ßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function e207Inc()
Local nOpca := 0
Private cCadastro := "Movimentação Armazéns."

dbSelectArea("ZEQ")
nOpca := AxInclui("ZEQ",ZEQ->(Recno()),3,,"u_e207Grv",,"U_E207TOK()",.F.,,,,,,.T.,,,,,)
Return nOpca

User Function e207Grv()

RecLock("ZEQ",.F.)
	ZEQ->ZEQ_USRINC := AllTrim(Upper(cUserName))
MsUnlock("ZEQ")

Return

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßß        Função de Deleção        ßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function e207Del()
Local nOpca := 0
Private cCadastro := "Movimentação Armazéns."

dbSelectArea("ZEQ")

If u_E207TOK(5)
	nOpca := AxDeleta("ZEQ",ZEQ->(Recno()),5,,,,,,.T.)	
Else
	nOpca = .F.
Endif

Return nOpca

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßß       Função de Alteração        ßßßßßßß
ßßßßßßß       ** NÃO HABILITADA **       ßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function e207Alt
	Alert("Operação não Disponível!")
Return .F.

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßß   Função que verifica o tipo da movimentação e    ßßßßßßß
ßßßßßßß   se o usuário possui permissão para realizá-la.  ßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function E207TOK(nParam)
Local nMovim
Local nLocal
Local nLocalD
If nParam == 5
	nMovim = ZEQ_MOVIM
	nLocal = ZEQ_LOCAL
	nLocalD = ZEQ_LOCALD
Else
	nMovim = M->ZEQ_MOVIM
	nLocal = M->ZEQ_LOCAL
	nLocalD = M->ZEQ_LOCALD
Endif
	If nMovim == 'T'
		ZF0->(DbSetOrder(1))
		If !alltrim(Upper(cUserName))$'JOAOFR/ALEXANDRERB/MARCOSR/ADMIN/ADMINISTRADOR/JOSEMF/DOUGLASSD/GUILHERMEDC/EDENILSONAS/JOSEMAB/PAULORL'
			If !ZF0->(DbSeek(xFilial("ZF0") + PadR(Upper(cUserName),20) + nLocal)) .AND.;
			!ZF0->(DbSeek(xFilial("ZF0") + PadR(Upper(cUserName),20) + nLocalD))
				Alert("Você deve ser reponsável por, pelo menos, um dos armazéns para editar as permissões!")
				Return .F.
   			Endif
   		Endif   		
  	Elseif nMovim == 'B'
		ZF0->(DbSetOrder(1))
		If !alltrim(Upper(cUserName))$'JOAOFR/ALEXANDRERB/MARCOSR/ADMIN/ADMINISTRADOR/JOSEMF/DOUGLASSD/GUILHERMEDC/EDENILSONAS/JOSEMAB/PAULORL'
			If !ZF0->(DbSeek(xFilial("ZF0") + PadR(Upper(cUserName),20) + nLocal))
				Alert ("Somente o responsável pelo Armazém pode editar as permissões!")
				Return .F.
			Endif
		Endif
	Endif
Return .T.