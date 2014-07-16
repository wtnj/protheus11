/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SD1100I         ³ Alexandre R. Bento    ³ Data ³ 07/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de Entrada p/ gravacao automatica do NCM no Produto ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"  
#include "AP5MAIL.CH" 

User Function SD1100I()
Local cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
Local cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'

Local lConectou
Local lEnviado
Local cMensagem := ''       

e_email := .F.                         

If !Empty(SD1->D1_NCM) .And. !SD1->D1_TIPO$"C" .And. Alltrim(SD1->D1_NCM) <> "00000000"
   SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD,.F.))
     
	      RecLock("SB1")
	         SB1->B1_POSIPI := SD1->D1_NCM
   	      MsUnlock("SB1")
Endif  

IF SM0->M0_CODIGO == "NH"  //empresa new hubner	
	If !Empty(SD1->D1_IPI)
	   SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD,.F.))
	      
	      If Empty(SB1->B1_IPI) 
		      RecLock("SB1")
		         SB1->B1_IPI := SD1->D1_IPI
	   	      MsUnlock("SB1")
	   	Endif   
	Endif  
Endif

If Empty(SD1->D1_LOCAL) .Or. Empty(SD1->D1_PESO)
   SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD,.F.))
   
      RecLock("SD1")       
         If Empty(SD1->D1_LOCAL)
            SD1->D1_LOCAL := SB1->B1_LOCPAD
         Endif
         If Empty(SD1->D1_PESO)
            SD1->D1_PESO := SD1->D1_QUANT * SB1->B1_PESO
         Endif
           
      MsUnlock("SD1")
Endif

//If SD1->D1_TES$"193/493" //Limpa o numero do lote pois a tes da nota não alimenta estoque
//   RecLock("SD1")
//       SD1->D1_LOTECTL := "  "
//   MsUnlock("SD1")
//Endif

IF SM0->M0_CODIGO == "NH"  //empresa new hubner	
	If Empty(SD1->D1_LOTECTL) .And. SD1->D1_TIPO$"B/N" 
	   SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD,.F.))
	   // Nao gera lote para os produtos não produtivos
	   If SB1->B1_TIPO$"CC/MC/CP/MP"
	      MsgBox("Nao foi Gerado o Numero do Lote para o Produto Verifique !! "+ SD1->D1_COD+Chr(13)+;
	   	       "Avise Imediatamente a Informatica Ramal 1925" ,"Atencao Falta o Lote","ALERT")
	   Endif	
	Endif	

Endif

If SM0->M0_CODIGO == 'NH' // WHB USINAGEM                                             
	DbSelectArea("SC7")                                 
	SC7->( dbSetOrder( 2 ) ) 
	DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_PEDIDO)

	if SC7->C7_PARADO = 'S'
		e_email = .T.
		TEXTO := 'A NOTA FISCAL ABAIXO COM PRODUTOS PARA CONSERTO DE MAQUINA PARADA ACABOU DE CHEGAR  '+chr(13)+chr(10)
		TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
		TEXTO += ' ' +chr(13)+chr(10)
		TEXTO += 'PEDIDO       = ' + SD1->D1_PEDIDO + chr(13)+chr(10)
		TEXTO += 'FORNECEDOR   = ' + SD1->D1_FORNECE + chr(13)+chr(10)
		TEXTO += 'PRODUTO         DESCRICAO               QUANTIDADE                  PREV.CHEGADA ' + chr(13)+chr(10)
		TEXTO += SD1->D1_COD + ' --- ' + SD1->D1_DESCRI + ' --- ' + SD1->D1_QUANT
	endif

	if e_email =  .T.
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
			If lConectou
				Send Mail from 'protheus@whbbrasil.com.br' To 'lista-almoxarifado@whbbrasil.com.br';
				SUBJECT ' ***** URGENTE *****  NOTA FISCAL  ***** URGENTE ***** ';
				BODY TEXTO;
				RESULT lEnviado 
			
			If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
		  	EndIf
		else
			Alert("Erro ao se conectar no servidor: " + cServer)		
		Endif
	endif
endif

//-- IMPORTACAO PARA CONTROLE DE RECEBIMENTO TABELA ZB8
ZB8->(dbsetorder(1)) // ZB8_FILIAL+ZB8_NFISC+ZB8_SERIE+ZB8_FORNEC+ZB8_LOJA+ZB8_ITEM

//SF4->(dbSetOrder(1)) // F4_FILIAL+F4_CODIGO
//If SF4->(dbSeek(xFilial('SF4')+SD1->D1_TES))

	//If SF4->F4_ESTOQUE=='S'
	
		If !ZB8->(dbSeek(xFilial("ZB8")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM)))
		
			RecLock("ZB8",.T.)
				ZB8->ZB8_FILIAL := xFilial("ZB8")
				ZB8->ZB8_DOC    := SD1->D1_DOC
				ZB8->ZB8_SERIE  := SD1->D1_SERIE
				ZB8->ZB8_FORNEC := SD1->D1_FORNECE
				ZB8->ZB8_LOJA   := SD1->D1_LOJA
				ZB8->ZB8_COD    := SD1->D1_COD
				ZB8->ZB8_ITEM   := SD1->D1_ITEM
				ZB8->ZB8_LOCAL  := SD1->D1_LOCAL
				ZB8->ZB8_HRENTR := time()
				ZB8->ZB8_STATUS := 'P'
			MsUnlock("ZB8")

		EndIf
	//EndIf
//EndIf

//-- FIM IMPORTACAO ZB8 -----------------------------------------------------------	

Return