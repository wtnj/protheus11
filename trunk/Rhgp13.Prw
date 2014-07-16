#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function Rhgp13()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NRECANT,_NRECPOS,")

If MsgYesNo("Cuidado ! ! , Esta Rotina Elimina a Ultima Integracao com o ForPonto, Confirma ? ? ?","ELIMINACAO DA INTEGRACAO COM O PONTO")
   If MsgYesNo("C O N F I M A  ? ?","ELIMINACAO DA INTERGRACAO COM O PONTO")
      _nRecAnt:=GetMv("MV_RECANT")
      _nRecPos:=GetMv("MV_RECPOS")
      If _nRecAnt<_nRecPos
         DbSelectArea("SRC")
         DbSetOrder(0)
         SRC->(DbGoto(_nRecAnt))
         Do While SRC->(Recno())>=_nRecAnt .and. SRC->(Recno())<=_nRecPos
            RecLock("SRC",.F.)
            SRC->(DbDelete())
            MsUnLock("SRC")
            SRC->(DbSkip())
         EndDo
         GetMv("MV_RECPOS")
         RecLock("SX6",.F.)
         SX6->X6_CONTEUD:=Str(_nRecAnt)
         MsUnLock("SX6")
         MsgInfo("REGISTRO EXCLUIDOS COM SUCESSO ! !")
      Else                   
         MsgInfo("NAO REGISTRO A SER EXCLUIDO ! !")
      EndIf
   EndIf
EndIf
Return
