#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rh_423()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

Processa({|| ERH_423() })// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Processa({|| EXECUTE(ERH_423) })


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function ERH_423
Static Function ERH_423()

DbSelectArea("SRD")
DbSetOrder(01)

DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())

SRA->(ProcRegua(LastRec()))

Do While SRA->(! Eof())
   SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"199812",.T.))
   Do While SRD->(! eOF()) .AND. SRD->RD_FILIAL==SRA->RA_FILIAL .AND. SRD->RD_MAT==SRA->RA_MAT .AND. SRD->RD_DATARQ=="199812"
      If SRD->RD_PD=="146" .OR. SRD->RD_PD=="405" .OR. SRD->RD_PD=="411" .OR. SRD->RD_PD=="446" .OR. SRD->RD_PD=="739"
         RecLock("SRD")
         SRD->RD_DATPGT:=CTOD("20/12/98")
         MsUnLock("SRD")
      EndIf   
      SRD->(DbSkip())
   Enddo      
   SRA->(DbSkip())
EndDo
MsgInfo("ARQUIVOS GERADOS COM SUCESSO")
Return
