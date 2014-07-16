/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT103VPC        ³ Alexandre R. Bento    ³ Data ³03.08.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada p/validar Se ja foi aprovada a A.Entrega ³±±
±±³          ³ na busca do pedido via F5/F6 na entrada da N.F.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#Include "rwmake.ch"    

User Function  MT103VPC()
Local _lRet := .T.				

/*
SZU->(DbSetOrder(4))//Filial + num autorizacao entrega + item da auto de entrega + nivel
SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM )) // Verifica se já existe aprovacao para autorizacao de entrega
If SZU->(Found())   
   While SZU->(!Eof()) .And. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == SC7->C7_NUM+SC7->C7_ITEM
      If !SZU->ZU_STATUS$"A" //autorizacao de entrega sem aprovação
         _lRet := .F.
         Exit //Forca a saida pois nao foi totalmente aprovada a autorizacao de entrega
      Else
         _lRet := .T.         
      Endif
      SZU->(DbSkip())
   Enddo   
Endif
//ALERT("MT103VPC4 " ) 
  */
Return(_lRet)

