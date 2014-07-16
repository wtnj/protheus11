#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhinss()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NTTPROS,_NTTDESS,_NTTPROT,_NTTDEST,_CFIL,_CMAT")
SetPrvt("_CDTA,_CDTP,_CMES,_NREC,")

Processa({|| ERH_423() })// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Processa({|| EXECUTE(ERH_423) })


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function ERH_423
Static Function ERH_423()

DbSelectArea("SRC")
DbSetOrder(01)

DbSelectArea("SRD")
DbSetOrder(01)
SRD->(DbGoTop())
SRD->(DbSeek("01"))

SRD->(ProcRegua(LastRec()))

Do While SRD->(! Eof())
   If SRD->RD_DATARQ>="199909" .or. SRD->RD_MAT=="000002"
      SRD->(DbSkip())
      LOOP
   ENDIF
      _nTTProS:=_nTTDesS:=0.00
      _nTTProT:=_nTTDesT:=0.00
      _cFil:=SRD->RD_FILIAL
      _cMat:=SRD->RD_MAT
      _cDtA:=SRD->RD_DATARQ
      _cDtP:=SRD->RD_DATPGT
      _cMes:=SRD->RD_MES
      IncProc("Gravando A Mat/Ano/Mes : " + _cMat + " " + _cDtA )
      Do While srd->(!eof()) .and. SRD->RD_FILIAL==_cFil .and. SRD->RD_MAT==_cMat .and. SRD->RD_DATARQ==_cDtA
         If SRD->RD_PD<"700" 
            SRV->(DbSeek(xFilial()+SRD->RD_PD,.T.))
            If SRD->RD_PD==SRV->RV_COD .and. SRV->RV_INSS=="S"
               If SRD->RD_PD<"400" 
                  If SRD->RD_PD=="146" .or. SRD->RD_PD=="150" .or. SRD->RD_PD=="205"
                     _nTTProT:=_nTTProT+SRD->RD_VALOR
                  Else
                     _nTTProS:=_nTTProS+SRD->RD_VALOR
                  Endif   
               Else
                  If SRD->RD_PD=="452"
                     _nTTDesT:=_nTTDesT+SRD->RD_VALOR
                  Else
                     _nTTDesS:=_nTTDesS+SRD->RD_VALOR
                  Endif   
               EndIf
            Endif
         EndIf
         SRD->(DbSkip())
      EndDo
      _nRec:=SRD->(Recno())
      If _nTTProS>0.00
         RecLock("SRD",.T.)
         SRD->RD_FILIAL:=_cFil
         SRD->RD_MAT   :=_cMat
         SRD->RD_DATARQ:=_cDtA
         SRD->RD_DATPGT:=_cDtP
         SRD->RD_PD    :="715"
         SRD->RD_MES   :=_cMes
         SRD->RD_TIPO1 :="V"
         SRD->RD_TIPO2 :="G"
         SRD->RD_VALOR :=_nTTProS-_nTTDesS
         SRD->RD_STATUS:="A"
         MsUnLock("SRD")
      EndIF
      If _nTTProT>0.00   
         RecLock("SRD",.T.)
         SRD->RD_FILIAL:=_cFil
         SRD->RD_MAT   :=_cMat
         SRD->RD_DATARQ:=_cDtA
         SRD->RD_DATPGT:=_cDtP
         SRD->RD_PD    :="718"
         SRD->RD_MES   :=_cMes
         SRD->RD_TIPO1 :="V"
         SRD->RD_TIPO2 :="G"
         SRD->RD_VALOR :=_nTTProT-_nTTDesT
         SRD->RD_STATUS:="A"
         MsUnLock("SRD")
      EndIf      
   SRD->(DbGoto(_nRec))
EndDo
MsgInfo("ARQUIVOS GERADOS COM SUCESSO")
Return
