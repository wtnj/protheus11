
#include "rwmake.ch"      

User Function Nhint002()    

SetPrvt("_CCTA,")

//Conta a debito do fornecedor
If SE2->E2_PREFIXO == "ADT"  .or. SE2->E2_PREFIXO == "REE"
   // Tratamento Adiantamento e Reembolso de Adto
   If SE2->E2_PREFIXO == "ADT"
      _cCta := "101030020004"
   Else
      If Subs(SE2->E2_CC,1,2) >= "43"
         _cCta := "401010040003"
      ElseIf Subs(SE2->E2_CC,1,1) == "4"
         _cCta := "402010050003"
      ElseIf Subs(SE2->E2_CC,1,1) < "4"
         _cCta := "304010040003"
      Else
         _cCta := ""
      Endif
   Endif
Else
   _cCta := space(20)
   SA2->(DbSetOrder(1))
   SA2->(DbGotop())
   SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
   _cCta := SA2->A2_CONTA

Endif

Return(_cCta)
