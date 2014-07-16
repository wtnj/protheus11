/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN044  ºAutor  ³Marcos R Roquitski  º Data ³  19/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera Natureza no Contas a Receber SE1.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhFin044()

SetPrvt("_cNatureza, _dVencto, _nValor,_cTitulo,")

_cNatureza   := SE1->E1_NATUREZ
_dVencto     := SE1->E1_VENCTO
_nValor      := SE1->E1_VALOR
_cTitulo     := SE1->E1_PREFIXO + " " + SE1->E1_NUM + " " + SE1->E1_PARCELA

@ 200,050 To 400,400 Dialog DlgNatureza Title OemToAnsi("Alteracao de Naturezas")

@ 010,020 Say OemToAnsi("Pref./No. Tit. ") Size 35,8
@ 025,020 Say OemToAnsi("Valor          ") Size 35,8
@ 040,020 Say OemToAnsi("Vencimento     ") Size 35,8
@ 055,020 Say OemToAnsi("Naturezas      ") Size 35,8

@ 009,070 Get _cTitulo   PICTURE "@!" When .F. Size 65,8
@ 024,070 Get _nValor    PICTURE "@E 999,999,999.99" When .F. Size 65,8
@ 039,070 Get _dVencto   PICTURE "99/99/99" When .F. Size 45,8
@ 054,070 Get _cNatureza PICTURE "@!" F3 "SED" Valid Existcpo("SED") Size 40,8
      
@ 075,050 BMPBUTTON TYPE 01 ACTION GravaDados()
@ 075,090 BMPBUTTON TYPE 02 ACTION Close(DlgNatureza)
Activate Dialog DlgNatureza CENTERED


Return

Static Function GravaDados()
	RecLock("SE1",.F.)
	SE1->E1_NATUREZ  := _cNatureza
	MsUnlock("SE1")

	SE5->(DbsetOrder(7))
	SE5->(DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA))
	If SE5->(Found())
		While !SE5->(EOF()) .AND. SE5->E5_PREFIXO == SE1->E1_PREFIXO .AND. SE5->E5_NUMERO == SE1->E1_NUM .AND. ;
							      SE5->E5_PARCELA == SE1->E1_PARCELA .AND. SE5->E5_TIPO == SE1->E1_TIPO .AND. ;
							      SE5->E5_CLIFOR == SE1->E1_CLIENTE .AND. SE5->E5_LOJA == SE1->E1_LOJA

			RecLock("SE5",.F.)
			SE5->E5_NATUREZ  := _cNatureza
			MsUnlock("SE5")

			SE5->(Dbskip())
		Enddo
	Endif
	SE5->(DbsetOrder(1))
	Close(DlgNatureza)
Return(.T.)
