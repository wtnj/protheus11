/*
Programa......: EECFAT2_RDM.PRW
Autor.........: Alessandro Porta (AJP)
Data/Hora.....: 19/10/2006 - 10H05
Objetivo......: Ajuste na integracao do Export x Faturamento para a WHB
*/


User Function EECFAT2()
Local cParam := ""

If ValType(ParamIXB) == "A"
   cParam := ParamIXB[1]
Else
   cParam := ParamIXB
EndIf


Do Case 
   Case cParam == "PE_GRVCAPA"    
      aAdd(aCab,{"C5_MENNOTA",M->EE7_MENNOT,nil})
      aAdd(aCab,{"C5_VOLUME1",M->EE7_VOLUME,nil})
End Case

Return Nil