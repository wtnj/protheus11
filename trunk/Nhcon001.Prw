/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ nhcon001         ³ Osmar Schimitberger  ³ Data ³21.01.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho p/gravar conta no Fornecedor e no Plano de Contas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#Include "rwmake.ch"
#Include "prtopdef.ch"

User Function  nhcon001()
Local cCod    := Substr(M->A2_COD,3,6)
Local cCodC   := " "
Local cNome   := M->A2_NOME

If SM0->M0_CODIGO == "NH"
	If M->A2_EST=="EX"
	   cCodC:="20101002"
	Else
	   cCodC:="20101001"
	Endif  
Else
	If M->A2_EST=="EX"
           cCodC:="20101002" 
	Else
           cCodC:="20101001"
	Endif  
Endif

DbSelectArea("SI1")
SI1->(DbSetOrder(1)) //filial+cod
SI1->(DbSeek(xFilial("SI1") + cCodc + cCod))
If !SI1->(Found())
	RecLock("SI1",.T.)
	   SI1->I1_FILIAL   := xFilial("SI1")
	   SI1->I1_CODIGO   := cCodC+cCod
	   SI1->I1_DESC     := cNome
	   SI1->I1_CLASSE   := "A"
	   SI1->I1_NIVEL    := "5"
	If M->A2_EST=="EX"
	   SI1->I1_RES      := "FI"+cCod
	Else
	   SI1->I1_RES      := "FN"+cCod
	Endif
	   SI1->I1_NORMAL   := "C"
	MsUnLock("SI1")
Endif	
Return(cCodC+cCod)     
