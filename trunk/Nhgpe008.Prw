#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Nhgpe008()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01


If MsgYesNo("Cuidado ! ! , ATUALIZA DIF 13 SAL NA DIRF"," ")
   Processa( {|| NHGPE008A() } )// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    Processa( {|| Execute(NHGPE008A) } )
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function NHGPE008A
Static Function NHGPE008A()

DbSelectArea("SR4")
DbSetOrder(1)

DbSelectArea("SRD")
DbSetOrder(1)
DbSelectArea("SRA")
DbSetOrder(1)
SRA->(DbGoTop())
ProcRegua(SRA->(RecCount()))

SRA->(DbSeek("01",.T.))
Do While SRA->(! Eof())  
   IncProc()
   SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"199912"+ "150",.T.))
   If SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .AND. SRD->RD_PD == "150" .AND. SRD->RD_DATARQ == "199912"
      SR4->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+SRA->RA_CIC+"0561"+"01"+ "J",.t.))
      If SR4->R4_FILIAL=="01" .AND. SR4->R4_TIPOREN =="J" .AND. SR4->R4_MAT==SRA->RA_MAT .AND. SR4->R4_MES == "01"
         RecLock("SR4",.F.)
         SR4->R4_VALOR:=SRD->RD_VALOR
         MsUnLock("SR4")
      Else
         RecLock("SR4",.T.)
         SR4->R4_FILIAL:=SRA->RA_FILIAL
         SR4->R4_MAT:=SRA->RA_MAT
         SR4->R4_CPFCGC:=SRA->RA_CIC
         SR4->R4_CODRET:="0561"
         SR4->R4_VALOR:=SRD->RD_VALOR
         SR4->R4_MES:="01"
         SR4->R4_TIPOREN:="J"
         MsUnLock("SR4")
      Endif
   EndIf   
   SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"199912"+ "411",.T.))
   If SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .AND. SRD->RD_PD == "411" .AND. SRD->RD_DATARQ == "199912"
      SR4->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+SRA->RA_CIC+"0561"+"01"+ "L",.t.))
      If SR4->R4_FILIAL=="01" .AND. SR4->R4_TIPOREN =="L" .AND. SR4->R4_MAT==SRA->RA_MAT .AND. SR4->R4_MES == "01"
         RecLock("SR4",.F.)
         SR4->R4_VALOR:=SRD->RD_VALOR
         MsUnLock("SR4")
      Else
         RecLock("SR4",.T.)
         SR4->R4_FILIAL:=SRA->RA_FILIAL
         SR4->R4_MAT:=SRA->RA_MAT
         SR4->R4_CPFCGC:=SRA->RA_CIC
         SR4->R4_CODRET:="0561"
         SR4->R4_VALOR:=SRD->RD_VALOR
         SR4->R4_MES:="01"
         SR4->R4_TIPOREN:="L"
         MsUnLock("SR4")
      Endif
   EndIf   
   SRA->(DbSkip())
EndDo
RetIndex("SR4")
Return   
