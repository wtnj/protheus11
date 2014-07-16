/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FNATF001  ³ Autor ³ Osmar Schimitberger   ³ Data ³ 28.07.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gatilho que Cria o codigo de Ativo Automaticamente          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Fundicao New Hubner                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualiz. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "rwmake.ch"

User Function FNATF001()
Public lFlag    := .F.
Public cGrupo   := Alltrim(M->N1_GRUPO)  // Variavel que guarda o Grupo do Ativo
Public cCod     := " "
Public nRegSN1  := SN1->(Recno())
Public cCodSeq  := Space(06)
Public lAchou   := .F.


cCodSeq := "000001"

SN1->(DbSetOrder(1)) //FILIAL+CODIGO BASE+ITEM
If !SN1->(DbSeek(xFilial("SN1")+Subs(cGrupo,1,4)+"000001"+"0001"))
	cCod := Subs(cGrupo,1,4)+"000001"  //Monta  o primeiro codigo Protheus
Else
	
	While !lAchou .and. Subs(cGrupo,1,2)<>"OS"
		cCodSeq := StrZero(Val(cCodSeq)+1,6)
		If !SN1->(DbSeek(xFilial("SN1")+Subs(cGrupo,1,4)+cCodSeq))
			cCod := Subs(cGrupo,1,4)+cCodSeq  //Monta codigo sequencial Protheus
			lAchou := .T.
		Endif
	Enddo
	
Endif

If Subs(cGrupo,1,2)=="OS"
	cCod := Subs(cGrupo,1,4)+"000001" // Retorna o Codigo Ordem de Serviço
Endif
SN1->(DbGoto(nRegSN1))  // Volta a posicao do registro no SN1


Acols[1,6]   := SNG->NG_CCONTAB
Acols[1,8]   := SNG->NG_CDEPREC
Acols[1,10]  := SNG->NG_CCDEPR
Acols[1,11]  := SNG->NG_CCORREC
Acols[1,12]  := SNG->NG_CCORREC

Acols[1,16] := SNG->NG_TXDEPR1
Acols[1,18] := SNG->NG_TXDEPR2
Acols[1,20] := SNG->NG_TXDEPR3
Acols[1,22] := SNG->NG_TXDEPR4
//Acols[1,24] := SNG->NG_TXDEPR5
__oGet:Refresh()
M->N1_CBASE  := cCod  // Retorna o Codigo Sequencial


Return(cCod)

