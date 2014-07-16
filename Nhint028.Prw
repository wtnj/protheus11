#include "rwmake.ch"        

User Function Nhint028()      

SetPrvt("_CCONTA,")

DbSelectArea("SED")
SED->(dbSetOrder(1))
SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
_cConta:=SPACE(20)
If SED->ED_DEBITO$"101030020004"
   If SE2->E2_CC>="43"
      _cConta:="401010040002"
   ElseIf SubStr(SE2->E2_CC,1,1) == "4"
          _cConta:="402010050003"
   ElseIf SubStr(SE2->E2_CC,1,1) <= "3"
          _cConta:="304010040003"
   Endif
Else
   _cConta:=SA2->A2_CONTA
Endif

Return(_cConta)   
