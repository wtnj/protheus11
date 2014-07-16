
USER FUNCTION PODT90

IF SimNao('Confirma Alteracao das Datas ?',,,,,'Questao ?') == "S"

   Processa({|| EXECUTE(AltDt) })

ENDIF

__RETURN(.T.)

Function AltDt

 SW2->(DBGOTOP())
 ProcRegua(SW2->(LASTREC()))

 DO WHILE SW2->(!EOF())

    IncProc("Alterando Datas")
    RecLock("Sw2",.T.)
    SW2->W2_PO_DT:=(SW2->W2_PO_DT-90)
    SW2->(MsUnlock())
    SW2->(DBSKIP())

 ENDDO

RETURN nil 
