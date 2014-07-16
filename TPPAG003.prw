/*
+-------------------------------------------------------------------------------------------------+
| Programa  : TPPAG003                     | Autor : Handerson Lemos Duarte     | Data: 04.02.09  |
+-------------------------------------------------------------------------------------------------+
| Descrição :Atualização dos campos da Tabela ZC7 CARACTERISTICAS ESPECIAIS     				  |
+-------------------------------------------------------------------------------------------------+
+-------------------------------------------------------------------------------------------------+
| Uso       : WHB                                                                                 |
+-------------------------------------------------------------------------------------------------+
| Revisao   :                                                                                     |
+-------------------------------------------------------------------------------------------------+
*/ 
#Include "RwMake.ch"
User Function TPPAG003(cNumpc,cRev)
Local  aArea 	:= GetArea()
Local  aAreaQK1	:= QK1->(GetArea())
Local  aAreaSA1	:= SA1->(GetArea())
Local  cNomePC	:=""
DBSelectArea("SA1")
DBSelectArea("QK1")	
QK1->(DBSetOrder(1))
QK1->(DBSeek(xFilial("QK1")+ZC7->(cNumpc+cRev)))
//			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APRFIM,"QAA_EMAIL")
M->ZC7_PPAP		:=QK1->QK1_PPAP
M->ZC7_CODCLI	:=QK1->QK1_CODCLI 
M->ZC7_LOJA		:=QK1->QK1_LOJCLI 
M->ZC7_NOMCLI	:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_NOME")
M->ZC7_NDES		:=QK1->QK1_NDES
M->ZC7_REVDES	:=QK1->QK1_REVDES
M->ZC7_PROJET	:=QK1->QK1_PROJET 
M->ZC7_CODWHB   :=QK1->QK1_PRODUT
cNomePC			:=QK1->QK1_DESC

//MsgStop(Posicione("SA1",1,xFilial("SA1")+("000002"+"0000"),"A1_NOME"))


RestArea(aAreaSA1)
RestArea(aAreaQK1)
RestArea(aArea)
Return(cNomePC) 
