/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST013       ³ Antonio Carlos Annies ³ Data ³ 11.07.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³  Gravação de Defeitos do Refugo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±± 
±±³	Alexandre R.B ³ 05/09/03 ³ Incluir Fornecedor e Loja                  ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"      

User Function NHEST13()  

setPrvt("cCodDef,cCodCar,cDescDef,cDescCar,cLocOrig,cOP,cFornece,cLoja,cNomeFor") 
cCodDef  := Space(02)
cCodCar  := Space(03)
cDescDef := Space(70)
cDescCar := Space(70)  
cOP      := Space(03)
cFornece := Space(06)
cLoja    := Space(02)
cNomeFor := Space(50)

SZ6->(dbSetOrder(1))
SZ8->(dbSetOrder(1))

@ 096,042 TO 340,545 DIALOG oDlg TITLE OemToAnsi("Gravação de Defeitos do Refugo")
@ 008,010 TO 084,250
@ 020,014 Say OemToAnsi("Cod.Caracteristica:") Size 50,8
@ 020,065 Get cCodCar  Size 32,10  Picture "999"   F3 "SZ8"  Valid FCar() Object oCodCar
@ 020,100 Get cDescCar Size 140,10 When .F. Object oDescCar
@ 035,014 Say OemToAnsi("Cod.Defeito:") Size 50,8
@ 035,065 Get cCodDef  Size 30,10  Picture "99"    F3 "SZ6"  Valid FDef() Object oCodDef
@ 035,100 Get cDescDef Size 140,10 When .F. Object oDescDef
@ 050,014 Say OemToAnsi("Cod.Operação:") Size 50,8
@ 050,065 Get cOP      Size 030,10 Valid Naovazio(cOP)   Object oOP
@ 065,014 Say OemToAnsi("Fornecedor:") Size 50,8
@ 065,065 Get cFornece  Size 32,10  Picture "@!" F3 "FOR"  Object oFornece
@ 065,095 Get cLoja    Size 10,10  Picture "@!"           Valid fFornece() Object oLoja
@ 065,115 Get cNomeFor  Size 130,10 When .F. Object oNomeFor

@ 095,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 095,205 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ObjectMethod(oDescDef, "Refresh()")
ObjectMethod(oDescCar, "Refresh()")                                   
ACTIVATE DIALOG oDlg CENTER
Return

Static Function FDef()
   If ExistCpo("SZ6",cCodDef)
      SZ6->(DbSeek(xFilial("SZ6")+cCodDef,.T.))
      cDescDef := SZ6->Z6_DESC
      ObjectMethod(oDescDef, "Refresh()")
      Return .T.
   Else
      Return .F.
   Endif
Return

Static Function FCar()
   If ExistCpo("SZ8",cCodCar)
      SZ8->(DbSeek(xFilial("SZ8")+cCodCar,.T.))
      cDescCar := SZ8->Z8_DESC
      ObjectMethod(oDescCar, "Refresh()")
      Return .T.
   Else
      Return .F.
   Endif
Return

Static Function Ffornece()

   If SA2->(DbSeek(xFilial("SA2")+cFornece+cLoja))
      cNomeFor := SA2->A2_NOME
      cLoja    := SA2->A2_LOJA
      ObjectMethod(oNomeFor,"Refresh()")
      ObjectMethod(oLoja,"Refresh()")
      Return (.T.)
   Else
      MsgBox("Fornecedor nao Encontrado, Redigite !!!","Atencao","ALERT")
      Return (.F.)
   Endif
Return



Static Function OKProc()  
//  NUM.SERIE       COD.DEF   CAR.DEF OP  LOC.ORIG    C.CUSTO            Forneced  Loja
	Acols[n,11] := cCodDef + cCodCar+StrZero(Val(cOP),3)+Acols[n,4]+Subs(SB1->B1_CC,1,6)+cFornece+cLoja
	Close(oDlg)
Return



