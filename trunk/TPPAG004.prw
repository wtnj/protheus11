/*
+-------------------------------------------------------------------------------------------------+
| Programa  : TPPAG004                     | Autor : Handerson Lemos Duarte     | Data: 12.02.09  |
+-------------------------------------------------------------------------------------------------+
| Descrição :Atualização dos campos da Tabela ZC1 ANÁLISE CRÍTICA COMERCIAL     				  |
+-------------------------------------------------------------------------------------------------+
+-------------------------------------------------------------------------------------------------+
| Uso       : WHB                                                                                 |
+-------------------------------------------------------------------------------------------------+
| Revisao   :                                                                                     |
+-------------------------------------------------------------------------------------------------+
*/ 
#Include "RwMake.ch"
User Function TPPAG004(cNumpc,cRev)
Local  aArea 	:= GetArea()
Local  aAreaQK1	:= QK1->(GetArea())
Local  aAreaSA1	:= SA1->(GetArea())
Local  cCodPais	:=""
DBSelectArea("SA1")
DBSelectArea("QK1")	
QK1->(DBSetOrder(1))
QK1->(DBSeek(xFilial("QK1")+ZC7->(cNumpc+cRev)))

M->ZC1_NOMCLI	:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_NOME")
M->ZC1_ENDCLI	:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_END")
M->ZC1_CIDADE	:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_MUN")
M->ZC1_CEP		:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_CEP")
M->ZC1_UF		:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_EST")
cCodPais		:=POSICIONE("SA1",1,XFILIAL("SA1")+QK1->(QK1_CODCLI+QK1_LOJCLI),"A1_PAIS")

RestArea(aAreaSA1)
RestArea(aAreaQK1)
RestArea(aArea)
Return(cCodPais) 
