#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhgp17()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NSALARIO,_CTIPO,APD,")

If (Month(dDataBase)==12 .and. Year(dDataBase)==1999) .or. (Month(dDataBase)==5 .and. Year(dDataBase)==2000)
   If SRA->RA_MENSALI=="C" .and. SRA->RA_SITFOLH<>"D"
      If SRA->RA_CATFUNC=="M"
         _nSalario:=SRA->RA_SALARIO
      Else
         _nSalario:=SRA->RA_SALARIO*SRA->RA_HRSMES
      Endif
      If fBuscaPD("421")>0.00
         _cTipo:=aPD[fLocaliaPD("421"),7]
      Else
         _cTipo:=Space(01)
      EndIf      
      If _cTipo<>"I"
         fGeraVerba("421",_nSalario*5/100,5,,,,,,,,.T.)
         aPD[fLocaliaPD("421"),7]:="I"
      EndIf   
   EndIf
EndIf   
return
