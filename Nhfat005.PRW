/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT005 ³ Autor ³ Alexandre R. Bento    ³ Data ³ 07/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inclui Pedido de retorno no pedido de fatura    (SC5)       ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Depto Fiscal                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SC5                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"      


User Function Nhfat005()   

   SetPrvt("cCadastro,aRotina")
   
   cCadastro := OemToAnsi("Inclui Pedido Venda de Retorno")
   aRotina := {{ "Pesquisa"   ,"Axpesqui",0,1},;
               { "Pedido Retorno" ,'U_fPedRet()',0,2}}

   DbSelectArea("SC5")
   SC5->(DbSetOrder(1))
   DbGoTop()
	            
   mBrowse(06,01,22,75,"SC5",,)                           
Return

   
User Function fPedRet()
   Public cNum := SC5->C5_PEDCOM
   
   @ 100,050 To 300,370 Dialog DlgItem Title OemToAnsi("Inclui Pedido de Retorno")
   @ 005,008 To 075,150                                     
   @ 020,020 Say OemToAnsi("Pedido de Fatura:")   Size 100,8
   @ 020,080 Get SC5->C5_NUM Size 030,8 When .F. Object oPedido
   @ 040,020 Say OemToAnsi("Numero do Pedido de Retorno:") Size 120,8
   @ 040,100 Get cNum Size 030,8 Object oPedido
   @ 080,080 BMPBUTTON TYPE 01 ACTION fOK()
   @ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgItem)
   Activate Dialog DlgItem Centered

Return

Static Function fOK()
      
   Reclock("SC5",.F.)
      SC5->C5_PEDCOM = cNum
   MsUnlock("SC5")
   Close(DlgItem)
Return
