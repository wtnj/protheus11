
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT125EXC ºAutor  ³Alexandre R. Bento  º Data ³  29/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos  exclusao do contrato                 º±±
±±º          ³de parceria p/ baixar a solicitação de compras e Aprovacoes º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function MT125EXC

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada

   //Fecha a solicitação de compras a partir do contrato
   SC1->(dbSetOrder(1))	
   SC1->(DbSeek(xFilial("SC1")+SC3->C3_NUMSC+SC3->C3_ITEMSC))
   If SC1->(Found())        
	  RecLock("SC1",.F.)
		 SC1->C1_QUJE   := 0
	  MsUnlock("SC1")
   Endif
    // Abre a pendencia do comprador na solicitação de compra, apos ter incluido o pedido em aberto/contrato de parceria
   SZU->(DbSetOrder(2)) //filial + num SC item SC
   SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUMSC+SC3->C3_ITEMSC))
   While !SZU->(Eof()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM == SC3->C3_NUMSC+SC3->C3_ITEMSC
      If Alltrim(SZU->ZU_LOGIN) == Alltrim(cUserName)
		 If SZU->ZU_ORIGEM$"SC1"
				RecLock("SZU",.F.)
				   SZU->ZU_DATAPR := ctod("  /  /  ")
				   SZU->ZU_HORAPR := " "
				   SZU->ZU_STATUS := " "
				MsUnlock("SZU")
		 Endif	
	  Endif
	  SZU->(DbSkip())
   Enddo

/////////////  Tira as pendencias para o pedido em aberto/contrato
   SZU->(DbSetOrder(3)) //filial + numero do contrato + item contrato + login

   SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM ))  // Pesquisa o Nivel
// SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + SC3->C3_NUMREV ))  // Pesquisa o Nivel   
   If SZU->(Found())
      While SZU->(!EOF()) .And. SZU->ZU_NUMCT+SZU->ZU_ITEMCT ==SC3->C3_NUM+SC3->C3_ITEM
//      While SZU->(!EOF()) .And. SZU->ZU_NUMCT+SZU->ZU_ITEMCT+SZU->ZU_NUMREV ==SC3->C3_NUM+SC3->C3_ITEM+SC3->C3_NUMREV      
         If SZU->ZU_ORIGEM$"SC3"
   		    RecLock("SZU",.F.)
 		       SZU->(DbDelete())
	        MsUnlock("SZU")   
		 Endif
		 SZU->(Dbskip())
	  Enddo 	 
   Endif
   
Endif	

Return(.T.)
