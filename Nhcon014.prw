/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCON014        ³ Marcos R. Roquitski   ³ Data ³ 28/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera uma Nova Conta, com Base na conta Origem.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaCon                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhCon014()

	SetPrvt("cQuery,lEnd")

	lEnd := .F.

	If !Pergunte('CON003',.T.)
		Return
	Endif		   	   

	Processa({|| Gerando() },"Criando Arquivo Temporario")

	If MsgBox("Confirme o Processamento !","Criando Nova Conta","YESNO")
		MsAguarde ( {|lEnd| fGravaDb() },"Aguarde", "Gravando Dados", .T.)
	Endif
    DbSelectArea("TMP")
    DbCloseArea()

	
Return(nil)


Static Function Gerando()
LOCAL nTotReg := 0

	cQuery := "SELECT * FROM " + RetSqlName( 'CTQ' ) +" CTQ "
	cQuery := cQuery + " WHERE CTQ_CTORI = '" + mv_par01 + "'"
	cQuery := cQuery + " AND CTQ_CTCPAR = '" + mv_par06 + "'"
	cQuery := cQuery + " AND CTQ_CTPAR = '" + mv_par04 + "'"
    cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "
    cQuery := cQuery + " ORDER BY CTQ_CCORI "
   //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  

Return



Static Function fGravaDb()
Local nReg := 0, _nSequen := 0, _cCori

	DBSELECTAREA("CTQ")
	CTQ->(DbSetOrder(1))
	CTQ->(DbGobottom())
	_nRateio := Val(CTQ->CTQ_RATEIO) + 1


	DBSELECTAREA("TMP")
	TMP->(DbGotop())

	While !Eof()

		_cCori := TMP->CTQ_CCORI
		nReg++
		_nSequen++
		MsProcTxt(" Processando ..: " + mv_par02 + "/"+Transform(nReg,"999999"))

		DBSELECTAREA("CTQ")
		RecLock("CTQ",.T.)
		CTQ->CTQ_FILIAL  := TMP->CTQ_FILIAL
		CTQ->CTQ_RATEIO  := StrZero(_nRateio,6)
		CTQ->CTQ_DESC    := mv_par03
		CTQ->CTQ_TIPO    := TMP->CTQ_TIPO
		CTQ->CTQ_CTORI   := mv_par02
		CTQ->CTQ_CTPAR   := mv_par05
		CTQ->CTQ_CTCPAR  := mv_par07
		CTQ->CTQ_CCPAR   := TMP->CTQ_CCPAR
		CTQ->CTQ_CCCPAR  := TMP->CTQ_CCCPAR
		CTQ->CTQ_PERCEN  := TMP->CTQ_PERCEN
		CTQ->CTQ_CCORI   := TMP->CTQ_CCORI
		CTQ->CTQ_SEQUEN  := StrZero(_nSequen,3)
		CTQ->CTQ_PERBAS  := 100
		MsUnlock("CTQ")
		DBSELECTAREA("TMP")
		TMP->(DbSkip())
		
		If TMP->CTQ_CCORI <> _cCori
			_nSequen := 0
			_nRateio++
		Endif
		
	Enddo

Return(nil)
