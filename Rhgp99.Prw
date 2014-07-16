#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhgp99()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NREC,_NVALOR,_DDATA,_CCC,")


If MsgYesNo("Cuidado ! ! , Geracao do FGTS"," ")
   Processa( {|| RHGP99A() } )// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>    Processa( {|| Execute(RHGP99A) } )
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHGP99A
Static Function RHGP99A()

DbSelectArea("SRA")
DbSetOrder(1)

DbSelectArea("SRC")
DbSetOrder(3)
SRC->(DbGoTop())
ProcRegua(SRC->(RecCount()))

SRC->(DbSeek("01144",.T.))
Do While SRC->(! Eof()) .and. SRC->RC_PD=="144"
   IncProc()
   SRA->(DbSeek(SRC->RC_FILIAL+SRC->RC_MAT,.T.))
   If SRA->RA_FILIAL==SRC->RC_FILIAL .and. SRA->RA_MAT==SRC->RC_MAT
      If SRA->RA_SITFOLH=="D" .or. SRA->RA_SITFOLH=="T"
         SRC->(DbSkip())
         Loop
      EndIf
      _nRec:=Recno()
      _nValor:=SRC->RC_VALOR
      _dData:=dDataBase
      _cCC:=SRC->RC_CC
      SRC->(DbSeek("01738"+SRA->RA_MAT,.t.))
      If SRC->RC_FILIAL=="01" .AND. SRC->RC_PD=="738" .AND. SRC->RC_MAT==SRA->RA_MAT
         RecLock("SRC",.F.)
         SRC->RC_VALOR:=_nValor
         SRC->RC_DATA:=_dData
         SRC->RC_TIPO2:="P"
         MsUnLock("SRC")
      Else
         RecLock("SRC",.T.)
         SRC->RC_FILIAL:=SRA->RA_FILIAL
         SRC->RC_MAT:=SRA->RA_MAT
         SRC->RC_PD:="738"
         SRC->RC_TIPO1:="V"
         SRC->RC_VALOR:=_nValor
         SRC->RC_DATA:=_dData
         SRC->RC_CC:=_cCC
         SRC->RC_TIPO2:="P"
         MsUnLock("SRC")
      Endif
      SRC->(DbSeek("01739"+SRA->RC_MAT,.t.))
      If SRC->RC_FILIAL=="01" .AND. SRC->RC_PD=="739" .AND. SRC->RC_MAT==SRA->RA_MAT
         RecLock("SRC",.F.)
         SRC->RC_VALOR:=ROUND(_nValor*0.08,2)
         SRC->RC_DATA:=_dData
         SRC->RC_TIPO2:="P"
         MsUnLock("SRC")
      Else
         RecLock("SRC",.T.)
         SRC->RC_FILIAL:=SRA->RA_FILIAL
         SRC->RC_MAT:=SRA->RA_MAT
         SRC->RC_PD:="739"
         SRC->RC_TIPO1:="V"
         SRC->RC_VALOR:=ROUND(_nValor*0.08,2)
         SRC->RC_DATA:=_dData
         SRC->RC_CC:=_cCC
         SRC->RC_TIPO2:="P"
         MsUnLock("SRC")
      EndIf   
      SRC->(DbGoTo(_nRec))
      SRC->(DbSkip())
   EndIf   
EndDo
RetIndex("SRC")
Return   
