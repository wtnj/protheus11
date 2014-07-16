/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCON012        ³ Marcos R. Roquitski   ³ Data ³ 23/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera uma Nova Conta, com Base na conta Origem IB_CCC.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaCon                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhCon012()
	
	SetPrvt("cQuery,lEnd")

	lEnd := .F.   

	If !Pergunte('CON004',.T.)
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
	cQuery := cQuery + " WHERE CTQ_CCPAR  = '" + mv_par01 + "'"
	cQuery := cQuery + " AND CTQ_CTORI  = '" + mv_par04 + "'"
    cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "
    cQuery := cQuery + " ORDER BY CTQ_CTORI "
    
   //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  

Return

Static Function fGravaDb()
Local nReg := 0, _nSequen := 0, _cTori
	DBSELECTAREA("CTQ")
	CTQ->(DbSetOrder(1))
	CTQ->(DbGobottom())
	_nRateio := Val(CTQ->CTQ_RATEIO) + 1

	DBSELECTAREA("TMP")
	TMP->(DbGotop())
	While !Eof()
		_cTori := TMP->CTQ_CTORI
		nReg++
		_nSequen++
		MsProcTxt(" Processando ..: " + mv_par02 + "/"+Transform(nReg,"999999"))
		DBSELECTAREA("CTQ")
		RecLock("CTQ",.T.)
		CTQ->CTQ_RATEIO  := StrZero(_nRateio,6)
		CTQ->CTQ_DESC    := mv_par03
		CTQ->CTQ_FILIAL  := TMP->CTQ_FILIAL
		CTQ->CTQ_TIPO    := TMP->CTQ_TIPO
		CTQ->CTQ_CTORI   := TMP->CTQ_CTORI
		CTQ->CTQ_CTPAR   := TMP->CTQ_CTPAR
		CTQ->CTQ_CTCPAR  := TMP->CTQ_CTCPAR
		CTQ->CTQ_CCPAR   := mv_par02
		CTQ->CTQ_CCCPAR  := TMP->CTQ_CCCPAR
		CTQ->CTQ_PERCEN  := TMP->CTQ_PERCEN
		CTQ->CTQ_CCORI   := mv_par02
		CTQ->CTQ_SEQUEN  := StrZero(_nSequen,3)
		CTQ->CTQ_PERBAS  := 100
		MsUnlock("CTQ")
		DBSELECTAREA("TMP")
		TMP->(DbSkip())
		If TMP->CTQ_CTORI <> _cTori
			_nSequen := 0
			_nRateio++
		Endif
	Enddo
Return(nil)
