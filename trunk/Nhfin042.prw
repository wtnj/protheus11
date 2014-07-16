/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao    ³ Nhfin042 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 07/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alteracao de Naturezas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
#include "rwmake.ch"

User Function NhFin042()

SetPrvt("_cNatureza, _dVencto, _nValor,_cTitulo,")


_cNatureza   := SE2->E2_NATUREZ
_dVencto     := SE2->E2_VENCTO
_nValor      := SE2->E2_VALOR
_cTitulo     := SE2->E2_PREFIXO + " " + SE2->E2_NUM + " " + SE2->E2_PARCELA

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
	RecLock("SE2",.F.)
	SE2->E2_NATUREZ  := _cNatureza
	MsUnlock("SE2")

	SE5->(DbsetOrder(7))
	SE5->(DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
	If SE5->(Found())
		While !SE5->(EOF()) .AND. SE5->E5_PREFIXO == SE2->E2_PREFIXO .AND. SE5->E5_NUMERO == SE2->E2_NUM .AND. ;
							      SE5->E5_PARCELA == SE2->E2_PARCELA .AND. SE5->E5_TIPO == SE2->E2_TIPO .AND. ;
							      SE5->E5_CLIFOR == SE2->E2_FORNECE .AND. SE5->E5_LOJA == SE2->E2_LOJA

			RecLock("SE5",.F.)
			SE5->E5_NATUREZ  := _cNatureza
			MsUnlock("SE5")

			SE5->(Dbskip())
		Enddo
	Endif
	SE5->(DbsetOrder(1))
	Close(DlgNatureza)
Return(.T.)