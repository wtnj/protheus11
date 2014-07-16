/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCON013        ³ Marcos R. Roquitski   ³ Data ³ 23/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualização da tabela de rateios "SIB".                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaCon                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhCon013()

	SetPrvt("cQuery,nReg")

	nReg := 0
   
	If !Pergunte('CON002',.T.)
		Return
	Endif      	

	Processa({|| SelGerado() },"Filtrando Dados.....")
	
	If nReg > 0 
		If MsgBox("Filtrados :"+Transform(nReg,"999999")+"    Confirme a Alteracao !","Atualizando % de C.Custo","YESNO")
			Processa({|| Gerando() },"Filtrando Dados.....")
		Endif
	Else
		MsgBox("Não foi Filtrado Nenhum Registro, Verifique os Parametros","Atualizando % de C.Custo","INFO")
	Endif	
    DbSelectArea("TMP")
    DbCloseArea()

Return(nil)


Static Function Gerando()
LOCAL nTotReg := 0
	cQuery := "UPDATE " + RetSqlName( 'CTQ' ) 
	cQuery := cQuery + " SET CTQ_PERCEN =  '" + STR(mv_par03) +"'"
	cQuery := cQuery + " WHERE CTQ_CCCPAR = '" + mv_par01 +"'"
	cQuery := cQuery + " AND CTQ_PERCEN = '" + STR(mv_par02) +"'"
	cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "
	TCSQLExec(cQuery)
Return

Static Function SelGerado()
LOCAL nTotReg := 0

	cQuery := "SELECT * FROM " + RetSqlName( 'CTQ' ) +" CTQ "
	cQuery := cQuery + " WHERE CTQ_CCCPAR = '" + mv_par01 + "'"
	cQuery := cQuery + " AND CTQ_PERCEN = '" + STR(mv_par02) +"'"
	cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "

	 //Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  

	DBSELECTAREA("TMP")
	TMP->(DbGoTop())
	While !Eof()
		nReg := nReg + 1
		TMP->(DbSkip())
	Enddo
   
Return
                                     