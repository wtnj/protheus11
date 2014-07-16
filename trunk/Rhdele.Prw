#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhdele()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

DbSelectArea("SRC")
DbSetOrde(3)
SRC->(DbGoTop())
SRC->(DbSeek("01144",.t.))
Do While SRC->(! Eof()) .and. SRC->RC_PD=="144"
   RecLock("SRC",.f.)
   SRC->RC_DATA:=dDataBase
   MsUnLock("SRC")
   SRC->(DbSkip())
Enddo
SRC->(DbSeek("01446",.t.))
Do While SRC->(! Eof()) .and. SRC->RC_PD=="446"
   RecLock("SRC",.f.)
   SRC->RC_DATA:=dDataBase
   MsUnLock("SRC")
   SRC->(DbSkip())
Enddo
MsgInfo("ARQUIVOS GERADOS COM SUCESSO")
Return
