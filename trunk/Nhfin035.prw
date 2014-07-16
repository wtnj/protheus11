/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN035  ºAutor  ³Microsiga           º Data ³  10/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Libera cheque para impressao.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhfin035()

SetPrvt("LOK,")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If SEF->EF_IMPRESS==[S]
   @ 135,002 To 310,560 Dialog dlgTitulos Title "Liberacao para Re-Impressao"
   @ 012,010 Say OemToAnsi("Cheque Numero") Size 45,8
   @ 027,010 Say OemToAnsi("Valor") Size 25,8
   @ 042,010 Say OemToAnsi("Beneficiario") Size 40,8
   @ 057,010 Say OemToAnsi("Historico") Size 35,8

   @ 10,60 Get SEF->EF_NUM WHEN .F. Size 35,8
   @ 25,60 Get SEF->EF_VALOR PICT "@E 999,999,999.99" WHEN .F. Size 55,8
   @ 40,60 Get SEF->EF_BENEF WHEN .F. Size 160,8
   @ 55,60 Get SEF->EF_HIST WHEN .F. Size 110,8
 
   @ 070,200 BMPBUTTON TYPE 01 ACTION Liberacao()
   @ 070,237 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)
   Activate Dialog dlgTitulos CENTERED

Else
   MsgBox("Cheque Nao foi Impresso","Re-Impressao","INFO")
Endif

Return


Static Function Liberacao()
   lOk := MsgBox("Confirma liberacao ?","Re-Impressao","YESNO")
   If lOk
      Reclock("SEF")
      SEF->EF_IMPRESS :=" "
      MsUnlock("SEF")
   Endif
   Close(DlgTitulos)
Return
