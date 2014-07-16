
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MT100TOK ³ Autor ³  Alexandre R. Bento  ³ Data ³ 11/03/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Na inclusão da nota fiscal de entrada do tipo FE/MM        ³±±
±±³          ³ Verificar saldo disponivel do orcamento do mesmo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "AP5MAIL.CH"
//***********************************************************************************************************
//
//***********************************************************************************************************
User Function SD1100E()

     ZAK->(DbSetOrder(1))//filial + mesano + tipo
     SF4->(DbSeek(xFilial("SF4")+ SD1->D1_TES)) 
     If SF4->F4_DUPLIC$"S" 
	    If Subs(Alltrim(SD1->D1_CONTA),1,6) <> "104020"  //nao pega conta de novos projetos       		   
	       If Subs(Alltrim(SD1->D1_CONTA),1,8) <> "10104006"  //nao pega conta de novos projetos       		   	    
		      If ZAK->(Dbseek(xFilial("ZAK")+Strzero(Month(SD1->D1_DTDIGIT),2) + "/"+Strzero(Year(SD1->D1_DTDIGIT),4)+ SD1->D1_TP ))  
			     Reclock("ZAK",.F.)
			 	   ZAK->ZAK_SLD   += SD1->D1_TOTAL
			     MsUnlock("ZAK")     
			  Endif   
	       Endif
		Endif
     Endif
Return(.T.) 
                       
