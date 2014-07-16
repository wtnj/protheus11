#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhacrai()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

DbSelectArea("SR2")
SR2->(DbgoTop())
While SR2->(!Eof())
// 1
   If (SR2->R2_RESCRAI == "0 " .OR. SR2->R2_RESCRAI == "  " .OR.  SR2->R2_RESCRAI == " 0")

       SR2->R2_RESCRAI := "00"
   endif

   SR2->(DbSkip())
Enddo
   MsgInfo("Encerrado")
Return
