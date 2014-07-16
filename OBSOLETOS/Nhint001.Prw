#include "rwmake.ch"    

User Function Nhint001()  

SetPrvt("_CCTA,")

// Conta a debito do fornecedor
If SE2->E2_PREFIXO == "ADT"  .or. SE2->E2_PREFIXO == "REE"
        // Implementacao Piske
        // Tratamento Adiantamento e Reembolso de Adto
        If SE2->E2_PREFIXO == "ADT"
              _cCta := "101030020004"
        Else
              If Subs(SE2->E2_CC,1,2) >= "43"
                  _cCta := "401010040002"
              ElseIf Subs(SE2->E2_CC,1,1) == "4"
                  _cCta := "402010050003"
              ElseIf Subs(SE2->E2_CC,1,1) < "4"
                  _cCta := "304010040003"
              Else
                 _cCta := ""
              Endif
        Endif
Else
        // Rotina do Vilela
        _cCta := space(20)
        SA2->(DbSetOrder(1))
        SA2->(DbGotop())
        SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

        /*/
        Alteracao feita por Jose Roberto em 29/01/01
        SED->(DbSetOrder(1))
        SED->(DbGotop()) 
        SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
        If SE2->E2_TIPO<>"NF ".and. SED->(Found())
           IF !EMPTY(SED->ED_DEBITO)
              _cCta := SED->ED_DEBITO
           Else
              _cCta := SED->ED_CREDITO
           Endif
        Else
        /*/

        _cCta := SA2->A2_CONTA

        // Endif
Endif

Return(_cCta)    
