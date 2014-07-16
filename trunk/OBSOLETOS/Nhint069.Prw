/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³NHINT069  ³ Autor ³ Jose Roberto          ³ Data ³ 30.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Nota Fiscal de Entrada Itens                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#include "rwmake.ch"     

User Function nhint069() 

SetPrvt("_NVALOR,_CPAR,_NPOS,_NALIQ,_NVALICM,")

_nvalor:=0

If SD1->D1_TES == "291"

   _cPar   := GetMv("MV_ESTICM")
   _nPos   := Rat(SF1->F1_EST,_cPar)
   _nAliq  := Val(SubStr(_cPar,_nPos+2,2))
   _nvalIcm:= (SD1->D1_TOTAL * _nAliq) / 100

   _nvalor := IIF(SF1->F1_TIPO<>"D" .AND. SF4->F4_CONTAB == "S",SD1->D1_TOTAL-_nvalIcm+IIF(SF4->F4_CREDIPI=="S",0,SD1->D1_VALIPI)+SD1->D1_VALDESC,0)

Else
   _nvalor := IIF(SF1->F1_TIPO<>"D" .AND. SF4->F4_CONTAB == "S",SD1->D1_TOTAL-SD1->D1_VALICM+IIF(SF4->F4_CREDIPI=="S",0,SD1->D1_VALIPI)+SD1->D1_VALDESC,0)
Endif


Return(_nvalor)    
