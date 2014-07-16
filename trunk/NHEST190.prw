
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST190 Autor:José Henrique M Felipetto º Data ³ 10/24/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Ordem de Liberação                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EST                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"
#include "protheus.ch"
#INCLUDE "FIVEWIN.CH"


User Function NHEST190()
cString		:= "ZB8"
cDesc1		:= "Relatório de Ordem de Liberação"
cDesc2      := ""
cDesc3      := ""
tamanho		:= "G"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHEST190"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatório de Ordem de Liberação")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHEST190"
_cPerg		:= "EST190"
nCont		:= 0
Cabec1		:= "Nota Fisc   - Série Fornecedor - Loja                                  Hora Entr.           Local                USR.LANÇA NOTA    Data Portaria        Turno               Login"
Cabec2		:= ""
Private _cTurno := ""

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,,,.F.,,,tamanho)

If nlastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac	:= aDriver[1]

If Pergunte(_cPerg,.T.)
	Processa({||Gerando() },"Gerando Relatório...")
	Processa({||RptDetail() }," Imprimindo Relatório...")
Else
	Return(nil)
EndIf
TTRA->(DbCloseArea() )

set filter to
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

Static Function Gerando()
Local cCondSts := ''
Local cTurnSts := ''


Do Case
	Case mv_par05 == 1 // 1º Turno
		cTurnSts := " AND ZB8_HROK BETWEEN '06:34' AND '14:50' "
		_cTurno := "Primeiro"
	Case mv_par05 == 2 // 2º Turno
		cTurnSts := " AND ZB8_HROK BETWEEN '14:51' AND '22:50' "
		_cTurno := "Segundo"
	Case mv_par05 == 3 // 3º Turno
		cTurnSts := " AND ZB8_HROK BETWEEN '22:51' AND '06:33' "
		_cTurno := "Terceiro"
EndCase

cCondSts := IIF(mv_par01 == 1,"WHERE ZB8_STATUS = 'R' ", "WHERE ZB8_STATUS = 'P' ")

cQuery := "SELECT ZB8_DOC,ZB8_SERIE,ZB8_FORNEC,ZB8_LOJA,ZB8_HRENTR,ZB8_LOCAL,ZB8_DTPORT,D1_USERLGI,D1_DTDIGIT,ZB8_USROK FROM " + RetSqlName("ZB8") + " ZB8 (NOLOCK) , "
cQuery += RetSqlName("SD1") + " SD1 (NOLOCK)"
cQuery += cCondSts
cQuery += " AND ZB8_DTPORT BETWEEN '" + DTOS(mv_par02) + "' AND '" + DTOS(mv_par03) + "' AND ZB8_LOCAL = '" + mv_par04 + "' "
cQuery += " AND D1_DOC = ZB8_DOC AND D1_SERIE = ZB8_SERIE AND ZB8_FORNEC = D1_FORNECE AND ZB8_ITEM = D1_ITEM "
If mv_par05 != 4
	cQuery +=  cTurnSts
EndIf
cQuery += " AND ZB8_LOJA = D1_LOJA AND  SD1.D_E_L_E_T_ = '' AND ZB8.D_E_L_E_T_ = '' "
cQuery += " AND SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND ZB8.ZB8_FILIAL = '" + xFilial("ZB8") + "'"

TCQUERY cQuery NEW ALIAS "TTRA"
MemoWrit("C:\TEMP\EST190.SQL",cQuery)
TcSetField("TTRA","ZB8_DTPORT","D")  // Muda a data de string para date
TTRA->(DbGoTop() )
Return

Static Function RptDetail()

ProcRegua(0)
SF1->(DbSetOrder(1) )
Titulo := OemToAnsi("Relatório de Ordem de Liberação - De: " + Dtoc(mv_par02) + " Até: " + DTOC(mv_par03) + " Local: " + mv_par04)
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

While TTRA->(!EOF())
	If @Prow() > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf

	@Prow() + 1,000 psay TTRA->ZB8_DOC + " - " + TTRA->ZB8_SERIE
	SA2->(DbSeek(xFilial("SA2") + TTRA->ZB8_FORNEC + TTRA->ZB8_LOJA) )
	@Prow(), 020	psay SA2->A2_NOME + " - " + TTRA->ZB8_LOJA
	@prow(), 073	psay TTRA->ZB8_HRENTR
	@prow(), 094 	psay TTRA->ZB8_LOCAL
	SF1->(DbSeek(xFilial("SF1") + TTRA->(ZB8_DOC + ZB8_SERIE + ZB8_FORNEC + ZB8_LOJA) ))
	cLogin := SF1->F1_USER
	@prow(), 114	psay cLogin
	@prow(), 133	psay TTRA->ZB8_DTPORT
	If mv_par05 != 4
		@Prow(), 151	psay _cTurno
	EndIf
	@Prow(), 171    psay TTRA->ZB8_USROK
	TTRA->(DbSkip() )
EndDo
Return