/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³NHFAT001  ³ Autor ³ Geandre G. Oliveira   ³ Data ³ 14.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Permite incluir a mensagem no pedido apos feito             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteração ³ Alexandre R.Bento Melhorar a inclusão de Mensagem 08/02/05 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  


#include "rwmake.ch"      
#include "Font.ch"
#include "Colors.ch"

User Function Nhfat001()    

DEFINE FONT oFont  NAME "Arial" SIZE 0, -12 BOLD                                           

SetPrvt("_cTmp,_cVar1,_cVar2,_cMensagem")

_cVar1 :=Space(100)
_cVar2 :=Space(100)
_cTmp := Space(200)


   _cTmp  := Iif(!Empty(SC5->C5_MENNOTA),AllTrim(SC5->C5_MENNOTA)+Space(200),Space(200))
   _cVar1 := SubStr(_cTmp,001,100) 
   _cVar2 := SubStr(_cTmp,101,100) 
   _cMensagem :=  "Mensagem da NF: " 
   _cMensagem :=  _cMensagem + Iif(!Empty(Posicione("SC6",1,SC5->C5_FILIAL+SC5->C5_NUM,"C6_NOTA")),Posicione("SC6",1,SC5->C5_FILIAL+SC5->C5_NUM,"C6_NOTA"),"Pedido nao gerou nota")
   _cMensagem :=  _cMensagem  + "   Pedido de Venda: " + SC5->C5_NUM

   @ 050,021 To 245,750 Dialog dlg1 Title OemToAnsi("Altera Mensagem na Nota Fiscal")
   @ 010,015 Say OemToAnsi(_cMensagem) Color CLR_BLUE Size 200,15 object oMsg 
     oMsg:SetFont(oFont)
   @ 018,015 To 065,355 
   @ 028,020 Get _cVar1   Picture "@S100"  Size 330,12 Object ovar1 
   @ 045,020 Get _cVar2   Picture "@S100"  Size 330,12 Object ovar2
   @ 075,025 BUTTON "_Limpar" SIZE 30,15 ACTION _Refresh()
   @ 075,085 BUTTON "_Ok" SIZE 30,15 ACTION _Confirm()
   @ 075,145 BUTTON "_Sair" SIZE 30,15 ACTION Close(Dlg1)

   Activate Dialog dlg1 Center 
Return


Static Function _Refresh()
   _cVar1 := _cVar2 := Space(100)
   _cTmp  := Space(200)
   dlgRefresh(Dlg1)
Return


Static Function _Confirm()
   _cTMP := Alltrim(_cVar1) + Alltrim(_cVar2)
   RecLock("SC5")
      SC5->C5_MENNOTA := _cTMP
   MsUnLock("SC5")
   Close(Dlg1)
Return
