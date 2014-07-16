#INCLUDE "Loja170.CH"
#INCLUDE "FIVEWIN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ LojA170	³ Autor ³ Fernando Godoy	     ³ Data ³ 16/10/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Leitura X                  			            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ Alteracao realizada dia 29/07/2003 para impressao da reducao³±±
±±³ Alteracao³ "X" via modulo Faturamento na impressora fical Bematech     ³±±
±±³ Alteracao³ Analista Claudio M. Ouverney                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function leitura()

LOCAL nOpca := 0
LOCAL oDlg
Local _cImpressora:= GetMv("MV_IMPFIS")
Local _cPorta     := GetMv("MV_PORTFIS")
Private cCadastro   := OemToAnsi(STR0001)


//If !lFiscal
	//Para Emitir a Leitura X da Impressora fiscal, deve-se
	//estar cadastrado como usu rio fiscal e com os parƒmetros da impressora corretos.
	//Aten‡„o
//	MsgStop(Oemtoansi(STR0002)+;
//	Oemtoansi(STR0003),;
//	Oemtoansi(STR0004))
//	Return .F.
//EndIf

DEFINE MSDIALOG oDlg FROM 39,85 TO 210,340 TITLE OemToAnsi(cCadastro) PIXEL OF oMainWnd
DEFINE FONT oFont NAME "Ms Sans Serif" BOLD
// Objetivo do Programa
@ 7, 4 TO 60, 121 LABEL STR0005 OF oDlg PIXEL

// Este programa tem como
// objetivo efetuar	a	impress„o	do
// cupom de leitura impressora fiscal
@ 19, 15 SAY OemToAnsi(STR0006 +STR0007 +STR0008 + _cImpressora + ".") SIZE 100, 40 OF oDlg PIXEL FONT oFont
DEFINE SBUTTON FROM 65, 65 TYPE 1;
ACTION (nOpca := 1,IF(MsgYesNo( OemToAnsi(STR0010),OemToAnsi(STR0011) ),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
DEFINE SBUTTON FROM 65, 94 TYPE 2;
ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If Type("nHdlECF") == "U"
	Public nHdlECF
	nHdlECF := IFAbrir( _cImpressora,_cPorta )
EndIf

If nOpca == 1
	Processa({|lEnd| IFLeituraX( nHdlECF )})
Endif

oFont:End()

Return .T.
