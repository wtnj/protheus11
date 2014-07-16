/*
+-------------------------------------------------------------------------------------------------+
| Programa  : TPPAG001                     | Autor : Handerson Lemos Duarte     | Data: 11.12.08  |
+-------------------------------------------------------------------------------------------------+
| Descrição :Seleciona o nome do cliente ou Produto da tela de cadastro de especificações da emba-|
|			  lagem. Atualiza os campos WH1_CODCLI e WH1_CODWHB.             	                  |
+-------------------------------------------------------------------------------------------------+
| Observação : Os campos ZC3_CODCLI e ZC3_CODWHB são variáveis visuais, no Browser tem que ser    |
|			   tratada constantemente.                                                            |
|			   Inicializador do Browser nos campos. Ex.: para ZC3_CODCLI: TPPAG001("ZC3_CODCLI")  |
+-------------------------------------------------------------------------------------------------+
| Uso       : WHB                                                                                 |
+-------------------------------------------------------------------------------------------------+
| Revisao   :                                                                                     |
+-------------------------------------------------------------------------------------------------+
*/
//U_TPPAG001("ZC3_CODCLI")//Atualiza o nome do cliente 
//U_TPPAG001("ZC0_CODCLI")//Atualiza o nome do cliente  
//U_TPPAG001("ZC3_CODWHB")//Atualiza a descrição do produto  
//U_TPPAG001("WH9_CODCLI")//Atualiza o nome do cliente   
//U_TPPAG001("WH9_CODPRO")//Atualiza a descrição do produto 
//U_TPPAG001("ZC0_CODCLI")//Atualiza o nome do cliente   
//U_TPPAG001("ZC0_CODPRO")//Atualiza a descrição do produto 
//U_TPPAG001("ZC7_CODCLI")//Atualiza o nome do cliente   
//U_TPPAG001("ZC7_CODWHB")//Atualiza a descrição do produto 

#Include "RwMake.ch"
User Function TPPAG001(cCampo)
Local  aArea 	:= GetArea()
Local cNome		:=""
Do Case
	Case 	cCampo=="ZC3_CODCLI" //Atualiza o nome do cliente
		cNome:=sfCliZC3()	
	Case	cCampo=="ZC3_CODWHB" //Atualiza a descrição do produto
		cNome:=sfProdZC3()
	Case 	cCampo=="WH9_CODCLI" //Atualiza o nome do cliente
		cNome:=sfCliWH9()	
	Case	cCampo=="WH9_CODPRO" //Atualiza a descrição do produto
		cNome:=sfProdWH9()
	Case 	cCampo=="ZC0_CODCLI" //Atualiza o nome do cliente
		cNome:=sfCliZC0()	
	Case	cCampo=="ZC0_CODPRO" //Atualiza a descrição do produto
		cNome:=sfProdZC0()
	Case 	cCampo=="ZC7_CODCLI" //Atualiza o nome do cliente
		cNome:=sfCliZC7()	
	Case	cCampo=="ZC7_CODWHB" //Atualiza a descrição do produto
		cNome:=sfProdZC7()
	Case 	cCampo=="ZC5_CODCLI" //Atualiza o nome do cliente
		cNome:=sfCliZC5()	
	Case	cCampo=="ZC5_CODPRO" //Atualiza a descrição do produto
		cNome:=sfProdZC5()
	Case cCampo=="ZC0_CODCLI" //Atualiza o nome do cliente
		cNome:=sfCliZC0()							
EndCase	
RestArea(aArea)
Return(cNome) 
//===========================Cliente========================================
Static Function sfCliZC3()
Local cNome:=""
Local aAreaSA1	:= SA1->(GetArea())
SA1->(DBSETORDER(1))
SA1->(DBSEEK(XFILIAL("SA1") + ZC3->ZC3_CODCLI + ZC3->ZC3_LOJACL))
cNome:=SA1->A1_NOME
SA1->(RestArea(aAreaSA1))
Return(cNome)
//===========================Produto========================================
Static Function sfProdZC3()
Local cNome:=""
Local aAreaSB1	:= SB1->(GetArea())
SB1->(DBSETORDER(1))
SB1->(DBSEEK(XFILIAL("SB1") + ZC3->ZC3_CODWHB ))
cNome:=SB1->B1_DESC
SB1->(RestArea(aAreaSB1))
Return(cNome) 
//===========================Cliente========================================
Static Function sfCliWH9()
Local cNome:=""
Local aAreaSA1	:= SA1->(GetArea())
SA1->(DBSETORDER(1))
SA1->(DBSEEK(XFILIAL("SA1") + WH9->WH9_CODCLI + WH9->WH9_LOJA))
cNome:=SA1->A1_NOME
SA1->(RestArea(aAreaSA1))
Return(cNome)
//===========================Produto========================================
Static Function sfProdWH9()
Local cNome:=""
Local aAreaSB1	:= SB1->(GetArea())
SB1->(DBSETORDER(1))
SB1->(DBSEEK(XFILIAL("SB1") + WH9->WH9_CODPRO ))
cNome:=SB1->B1_DESC
SB1->(RestArea(aAreaSB1))
Return(cNome)
//===========================Cliente========================================
Static Function sfCliZC0()
Local cNome:=""
Local aAreaSA1	:= SA1->(GetArea())
SA1->(DBSETORDER(1))
SA1->(DBSEEK(XFILIAL("SA1") + ZC0->ZC0_CODCLI + ZC0->ZC0_LOJA))
cNome:=SA1->A1_NOME
SA1->(RestArea(aAreaSA1))
Return(cNome)
//===========================Produto========================================
Static Function sfProdZC0()
Local cNome:=""
Local aAreaSB1	:= SB1->(GetArea())
SB1->(DBSETORDER(1))
SB1->(DBSEEK(XFILIAL("SB1") + ZC0->ZC0_CODPRO ))
cNome:=SB1->B1_DESC
SB1->(RestArea(aAreaSB1))
Return(cNome) 
//===========================Cliente========================================
Static Function sfCliZC7()
Local cNome:=""
Local aAreaSA1	:= SA1->(GetArea())
SA1->(DBSETORDER(1))
SA1->(DBSEEK(XFILIAL("SA1") + ZC7->ZC7_CODCLI + ZC7->ZC7_LOJA))
cNome:=SA1->A1_NOME
SA1->(RestArea(aAreaSA1))
Return(cNome)
//===========================Produto========================================
Static Function sfProdZC7()
Local cNome:=""
Local aAreaSB1	:= SB1->(GetArea())
SB1->(DBSETORDER(1))
SB1->(DBSEEK(XFILIAL("SB1") + ZC7->ZC7_CODWHB ))
cNome:=SB1->B1_DESC
SB1->(RestArea(aAreaSB1))
Return(cNome)  
//===========================Cliente========================================
Static Function sfCliZC5()
Local cNome:=""
Local aAreaSA1	:= SA1->(GetArea())
SA1->(DBSETORDER(1))
SA1->(DBSEEK(XFILIAL("SA1") + ZC5->ZC5_CODCLI + ZC5->ZC5_LOJA))
cNome:=SA1->A1_NOME
SA1->(RestArea(aAreaSA1))
Return(cNome)
//===========================Produto========================================
Static Function sfProdZC5()
Local cNome:=""
Local aAreaSB1	:= SB1->(GetArea())
SB1->(DBSETORDER(1))
SB1->(DBSEEK(XFILIAL("SB1") + ZC5->ZC5_CODPRO ))
cNome:=SB1->B1_DESC
SB1->(RestArea(aAreaSB1))
Return(cNome)         
//===========================Cliente========================================
Static Function sfCliZCO()
Local cNome:=""
Local aAreaSA1	:= SA1->(GetArea())
SA1->(DBSETORDER(1))
SA1->(DBSEEK(XFILIAL("SA1") + ZC0->ZC0_CODCLI + ZC0->ZC0_LOJA))
cNome:=SA1->A1_NOME
SA1->(RestArea(aAreaSA1))
Return(cNome)