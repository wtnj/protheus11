/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN036  ºAutor  ³Microsiga           º Data ³  10/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Troca o Nr. do Cheque.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhfin036() 

SetPrvt("M->EF_NOVO,M->EF_NUM,M->EF_BANCO,M->EF_AGENCIA,M->EF_CONTA,LOK")
SetPrvt("LCONFIRMA,NREGSEF,")

If Empty(SEF->EF_NUM)
   MsgBox("Numero em Branco, Nao pode ser Alterado!","Renumeracao","INFO")
   Return
Endif


@ 135,002 To 310,570 Dialog dlgTitulos Title "Troca Numero do Cheque"
@ 012,010 Say OemToAnsi("Cheque Numero") Size 35,8
@ 027,010 Say OemToAnsi("Valor") Size 25,8
@ 042,010 Say OemToAnsi("Beneficiario") Size 35,8
@ 057,010 Say OemToAnsi("Historico") Size 25,8

M->EF_NOVO    := SEF->EF_NUM
M->EF_NUM     := SEF->EF_NUM
M->EF_BANCO   := SEF->EF_BANCO
M->EF_AGENCIA := SEF->EF_AGENCIA
M->EF_CONTA   := SEF->EF_CONTA

@ 10,60 Get M->EF_NOVO VALID ValCheque() Size 45,8
@ 25,60 Get SEF->EF_VALOR PICT "@E 999,999,999.99" WHEN .F. Size 45,8
@ 40,60 Get SEF->EF_BENEF WHEN .F. Size 160,8
@ 55,60 Get SEF->EF_HIST WHEN .F. Size 160,8

@ 070,200 BMPBUTTON TYPE 01 ACTION Renumerar()
@ 070,237 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)

Activate Dialog dlgTitulos CENTERED

Return


Static Function ValCheque()
   lOk := .T.
   If M->EF_NOVO==SEF->EF_NUM
      MsgBox("Numero do cheque informado, igual ao anterior","Renumerar","INFO")
      lOk := .F.
   Endif
Return lOk


Static Function Renumerar()
   lConfirma := MsgBox("Confirma renumeracao","Renumerar","YESNO")
   If lConfirma 
      While .T.
         nRegSEF := SEF->(recNo())
         SEF->(dbSetOrder(1))
         If SEF->(dbSeek(xFilial("SEF")+M->EF_BANCO+M->EF_AGENCIA+M->EF_CONTA+M->EF_NOVO))
            MsgBox("Esse Numero ja existe!","Renumeracao de Cheques","INFO")
            SEF->(dbGoto(nRegSEF))
            Exit
         Endif
         SEF->(dbSetOrder(1))
         While SEF->(dbSeek(xFilial("SEF")+M->EF_BANCO+M->EF_AGENCIA+M->EF_CONTA+M->EF_NUM))
            // Cheque
            Reclock("SEF")
            SEF->EF_NUM := M->EF_NOVO
            MsUnlock("SEF")
            // Titulo
            If !Empty(SEF->EF_TITULO)
               SE2->(dbSetOrder(1))
               SE2->(dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA))
               RecLock("SE2")
               SE2->E2_NUMBCO:=M->EF_NOVO
               MsUnLock("SE2")
            Endif
   
         Enddo
         // Atualiza o movimento bancario
         SE5->(dbSetOrder(13))
         While SE5->(dbSeek(xFilial("SE5")+M->EF_BANCO+M->EF_AGENCIA+M->EF_CONTA+M->EF_NUM))
            RecLock("SE5")
            SE5->E5_NUMCHEQ :=M->EF_NOVO
            MsUnLock("SE5")
         Enddo
         SEF->(dbGoto(NRegSEF))
         Exit
      Enddo
   Endif
   Close(DlgTitulos)
Return
