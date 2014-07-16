#INCLUDE "RWMAKE.CH"

User Function FI089TO
If E1_OK ==cMarcaRDM
	nValorSel:= nValorSel + E1_VALOR
Else
	nValorSel:= nValorSel - E1_VALOR	
EndIf
Return(nValorSel)
