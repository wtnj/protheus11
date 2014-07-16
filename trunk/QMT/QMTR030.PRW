#INCLUDE "QMTR030.CH"
#INCLUDE "PROTHEUS.CH"


#DEFINE Confirma 1
#DEFINE Redigita 2
#DEFINE Abandona 3

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QMTR030  ³ Autor ³ Wanderley Goncalves   ³ Data ³ 13.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de Calibracao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQmt                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Antonio A.    ³03/08/99³  --	 ³ Incluido a coluna Precisao relativas   ³±±
±±³              ³        ³      ³  as Escalas (QMR_PREC)                 ³±±
±±³Denis Martins ³18/02/02³Melhor³ Nao permitir impressao do campo data de³±±
±±³              ³        ³      ³ validade quando o mesmo nao apresentar ³±±
±±³              ³        ³      ³ valores no cadastro(Escala Tipo Soma). ³±±
±±³Denis Martins ³20/02/02³Melhor³ Acerto na impressao dos valores de in- ³±±
±±³              ³        ³      ³ certeza do Tipo B.                     ³±±
±±³Denis Martins ³27/03/02³014528³ Impressao dos dados cadastrais de clien³±±
±±³              ³        ³      ³ tes(Endereco/Cidade/Telefone).         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Qmtr030(aImpCer)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea
Local nOpc:=1, oDlg,cTitulo:="",cText1:=""
Local cNomNovo
Local nx := 1
Local cNomeArq

Private lEnd:=.F.
Private lEdit := .t.	// Para editar os textos
Private cCERT
Private aMedicoes := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para montar Get.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aListBox:={},aMsg:={},aSel:={},aValid:={},aConteudo:={}
Private cPerg1:= "QMR031"
Private lCertif := .F.
Private Inclui	:= .F.
Private Altera	:= .F.
Private cSeql	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:=OemToAnsi(STR0001)		//"Certificado de Calibracao"
cText1:=OemToAnsi(STR0002)			//"Neste relat¢rio ser  impresso o Certificado de Calibracao"
dbSelectArea("QM6")
dbSetOrder(1)
aArea :={Alias(),IndexOrd()}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Permitir criar arquivos textos por filial³ 
//³Nomenclatura do(s) arquivo(s) textos:    ³
//³R30XYYZZ - Nome do Arquivo               ³
//³R30  - Fonte Origem                      ³
//³X    - Identificador                     ³ 
//³YY   - Empresa Corrente(Sigamat.emp)     ³
//³ZZ   - Filial Corrente(Sigamat.emp)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nx := 1 To 4
	cNomeArq := "QMR030"+Str(nx,1)+".TXT"

	If File(cNomeArq)
		cNomNovo := "R30"+Str(nx,1)+cEmpAnt+cFilAnt+".TXT"
		Rename &cNomeArq To &cNomNovo
		FERASE(cNomeArq)
	Endif
Next nx

Do While .T.

	If __cInternet != "AUTOMATICO"
		DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo) FROM  165,115 TO 315,525 PIXEL OF oMainWnd
		@ 03, 10 TO 43, 195 LABEL "" OF oDlg  PIXEL
		@ 10, 15 SAY OemToAnsi(cText1) SIZE 160, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 50, 112 TYPE 5 ACTION (nOpc:=2,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50, 141 TYPE 1 ACTION (nOpc:=1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50, 170 TYPE 2 ACTION (nOpc:=3,oDlg:End()) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg
	Endif
	Do Case
		Case nOpc==1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Relat¢rio de Certificado de Calibracao                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			R030IMP(aImpCer)
			Exit
		Case nOpc==2
			R030Processa(aImpCer)
		Case nOpc==3
			Exit
	EndCase
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura area                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aArea[1]);dbSetOrder(aArea[2])
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030Processa ³ Autor ³Wanderley Goncalves³ Data ³ 13/05/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do QMTR030                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R030Processa(aImpCer)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta tela para digitacao de itens.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A030Mont(aImpCer)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³   A030Mont   ³ Autor ³Wanderley Goncalves³ Data ³ 13/05/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta Tela para digitacao dos textos.                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a030Mont(aImpCer)

Local oListBox,oDlgGet

aListBox := {}
AADD(aListBox," ")
AADD(aListBox,OemToAnsi(STR0003))		//" Texto Final do Certificado "
AADD(aListBox,OemToAnsi(STR0013))		//" Informa‡”es Complementares "
AADD(aListBox,OemToAnsi(STR0146)) 		//" Analise das Ultimas Pecas Produzidas"
AADD(aListBox,OemToAnsi(STR0004))		//" Impress„o "
AADD(aListBox," ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa ListBox com opcoes para o array da configuracao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgGet TITLE OemtoAnsi(STR0001) FROM  180,110 TO 450,520 PIXEL OF oMainWnd		//"Certificado de Calibracao"
@ 10, 20 SAY Oemtoansi(STR0006)	SIZE 300, 07 OF oDlgGet PIXEL		//"Itens de Configuracao"
@ 26, 18 TO 112, 188 LABEL "" OF oDlgGet PIXEL

@ 33,22 LISTBOX oListBox VAR cVar FIELDS HEADER "" ON DBLCLICK (R030GetList(oListBox)) SIZE 164,76 PIXEL

oListBox:SetArray(aListBox)
oListBox:bLine := { ||{aListBox[oListBox:nAt]}}

DEFINE SBUTTON FROM 115, 132 TYPE 1 ACTION (oDlgGet:End()) ENABLE OF oDlgGet
DEFINE SBUTTON FROM 115, 160 TYPE 2 ACTION (oDlgGet:End()) ENABLE OF oDlgGet

ACTIVATE MSDIALOG oDlgGet CENTERED

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030GetList ³Autor³ Wanderley Goncalves   ³ Data ³ 05.07.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Get para edicao de Elemento relacionado ao ListBox    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QMTR030                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R030GetList(oListBox,aImpCer)
Local nAt

nAt:=oListBox:nAt

If nAt == 2 .Or. nAt == 3 .Or. nAt == 4
	R030TEXT(oListBox,aImpCer)
ElseIf nAt == 5
	Pergunte(cPerg1,.T.)
Endif

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030Text    ³Autor³Wanderley Goncalves    ³ Data ³ 13/05/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Tela para preenchimento do conteudo relacionado com o ³±±
±±³          ³ListBox.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QMTR030                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R030Text(oListBox,aImpCer)

Local cTexto := ""
Local nOpca:=2
Local oFontMet   := TFont():New("Courier New",6,0)
Local oDlgGet2,oTexto
Local oFontDialog:= TFont():New("Arial",6,15,,.T.)
Local cNomeArq 
Local oListB

cNomeArq := "X"
nHdl:=MSFCREATE(cNomeArq,0)
If nHdl <= -1
	HELP(" ",1,"NODIRCQ")
	Return .T.
Else
	If File(cNomeArq)
		FCLOSE(nHdl)
		FERASE(cNomeArq)
	Endif
Endif

nAt:=oListBox:nAt

cNomeArq := "R30"+Str(nAt,1)+cEmpAnt+cFilAnt+".TXT"

While .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le arquivo                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTexto:=MemoRead(cNomeArq)

	DEFINE MSDIALOG oDlgGet2 FROM	62,100 TO 345,610 TITLE  OemToAnsi(STR0008) PIXEL FONT oFontDialog		//"Itens de Configura‡„o"
	@ 003, 004 TO 027, 250 LABEL "" 	OF oDlgGet2 PIXEL
	@ 040, 004 TO 110, 250				OF oDlgGet2 PIXEL
	@ 013, 010 MSGET oListB VAR aListBox[nAt]	SIZE 235, 010 OF oDlgGet2 PIXEL
	oListB:lReadOnly:= .T.

	@ 050, 010 GET oTexto VAR cTexto MEMO WHEN lEdit SIZE 235, 051 OF oDlgGet2 PIXEL

	oTexto:oFont := oFontMet

	DEFINE SBUTTON FROM 120,190 TYPE 1 ACTION (nOpca := 1,oDlgGet2:End()) ENABLE OF oDlgGet2
	DEFINE SBUTTON FROM 120,220 TYPE 2 ACTION (nOpca := 2,oDlgGet2:End()) ENABLE OF oDlgGet2

	ACTIVATE MSDIALOG oDlgGet2 CENTERED
	Exit
EndDo

If nOpca == Confirma
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua gravacao do arquivo                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MemoWrit( cNomeArq,cTexto )
EndIf

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030Imp  ³ Autor ³ Wanderley Goncalves   ³ Data ³ 13.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de calibra‡„o                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030IMP(aImpCer)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1		:=OemToAnsi(STR0007) // "Este programa ira emitir a rela‡ao de"
Local cDesc2		:=OemToAnsi(STR0020) // "Certificados de Calibra‡„o de acordo com os"
Local cDesc3		:=OemToAnsi(STR0009) // "Parƒmetros selecionados."
Local cString		:="QM6"
Local wnrel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis para impressao de textos gerais             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nTxtFin 		// Imprime Texto Final
Local nInfCom 		// Imprime Informacoes Complementares
Local nInfCIn 		// Imprime Informacoes Complementares do Instrumento
Local nINCs   		// Imprime Nao Conformidades
Local nIOBS   		// Imprime Observacoes
Local nILaudo 		// Imprime Laudo Final do Instrumento
Local nIResum 		// Imprime Resumo de Valores
Local nIItb			// Imprime Legenda Incerteza Tipo B

Private titulo		:= OemToAnsi(STR0010) //"CERTIFICADO DE CALIBRACAO "
Private cabec1		:= ""
Private cabec2		:= ""
Private aReturn	:= { OemToAnsi(STR0011), 1,OemToAnsi(STR0012), 1, 2, 1, "",1 } // "Zebrado"###"Administra‡„o"
Private nomeprog	:="QMTR030"
Private nLastKey	:= 0
Private cPerg		:="QMR030"
Private cTamanho := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Privates para efetuar os calculos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cMtInstr	:= ''
Private cMtRevIns := ''
Private dMtData
Private cMtResp	:= ''
Private cMtTotHr	:= ''
Private cMtRepRepr:= ''

Private nPosEsc	:= 01
Private nPosPad	:= 02
Private nPosEsp	:= 03
Private nPosMed	:= 04
Private nPosObs	:= 05
Private nPosSec	:= 06
Private nPosIns	:= 07
Private nPosNco	:= 08
Private nPosITB	:= 09
Private nPosCar	:= 10
Private nPosExt	:= 11
Private nPosGer	:= 12
Private nPosTp5	:= 13

Private cResIni := ' '   	// Guarda Resultado da medicao inicial (se houver)
Private nCond   := 0     	// Opcao escolhida no menu de Condi‡ao de Recebimento
Private nFreqGrav := 0   	// Frequencia a ser gravada
Private nLaudoFim := 0   	// Guarda laudo final do Instrumento
Private nDec := 0        	// Numero de casas decimais para tipo soma(5)
Private lForaEsp := .f.  	// Verifica se houve alguma medicao fora do especificado
								 	// para sugerir Avaria.
Private dData
Private lTamSom	:= GetMv("MV_QMTPCES",.F.,"2")=="1"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Pergunte("QMR031",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ nTxtFin := mv_par01 // Imprime Texto Final:    1-Sim 2-Nao   ³
//³ nInfCom := mv_par02 // Imprime Inf.Compl.:     1-Sim 2-Nao   ³
//³ nInfCIn := mv_par03 // Imp.Inf.Compl.Instr.:   1-Sim 2-Nao   ³
//³ nIncs   := mv_par04 // Imp.Nao Conformid.  :   1-Sim 2-Nao   ³
//³ nIOBS   := mv_par05 // Imp.Observacoes     :   1-Sim 2-Nao   ³
//³ nILaudo := mv_par06 // Imp.Laudo           :   1-Sim 2-Nao   ³
//³ nIResum := mv_par07 // Imp.Resumo de Vlrs  :   1-Sim 2-Nao   ³
//³ nIItb	:= mv_par08 // Imp.Leg.Inc.Tipo B  :   1-Sim 2-Nao	 |	
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTxtFin := mv_par01
nInfCom := mv_par02
nInfCIn := mv_par03
nIncs   := mv_par04
nIOBS   := mv_par05
nILaudo := mv_par06
nIResum := mv_par07
nIItb	:= mv_par08
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("QMR030",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                ³
//³ mv_par01 : Instrumento Inicial                      ³
//³ mv_par02 : Instrumento Final                        ³
//³ mv_par03 : Periodo Inicial                          ³
//³ mv_par04 : Periodo Final                            ³
//³ mv_par05 : Departamento Inicial                     ³
//³ mv_par06 : Departamento Final                       ³
//³ mv_par07 : Orgao Calibrador Todos/Interno/Externo   ³
//³ mv_par08 : Orgao Calibrador interno de              ³
//³ mv_par09 : Orgao Calibrador interno ate             ³
//³ mv_par10 : Orgao Calibrador externo de              ³
//³ mv_par11 : Orgao Calibrador externo ate             ³
//³ mv_par12 : Familia de                               ³
//³ mv_par13 : Familia ate                              ³
//³ mv_par14 : Fabricante de                            ³
//³ mv_par15 : Fabricante ate                           ³
//³ mv_par16 : Usu rio de                               ³
//³ mv_par17 : Usu rio ate                              ³
//³ mv_par18 : Imprime Anal.Ult.Pecas Prod.?            ³
//³ mv_par19 : Imprime Padrao p/Calibracao ?(Subjetivo) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aImpCer <> NIL
	cPerg:=""
Endif
	
wnrel:="QMTR030"            //Nome Default do relatorio em Disco
wnrel:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,cTamanho)

cPerg		:="QMR030" //Atribui valor ao cPerg,qdo o certif. for impresso pela Rotina de Medicao.

If nLastKey = 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
   Return
Endif

RptStatus({|lEnd| MTR030Imp(@lEnd,wnRel,cString,nTxtFin, nInfCom,;
										 nInfCIn,nIncs,nIOBS,nILaudo,aImpCer,nIResum,nIItb)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Mtr030Imp³ Autor ³ Alessandro B. Freire  ³ Data ³ 08.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Certificado de Calibra‡„o                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  MTR030IMP(void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd     -> Parametro do relatorio	                      ³±±
±±³          ³ wnRel    -> Nome default do arquivo em disco               ³±±
±±³          ³ cString  -> Parametro do relatorio                         ³±±
±±³          ³ nTxtFin  -> Imprime textos finais                          ³±±
±±³          ³ nInfCom  -> Imprime informacoes complementares gerais      ³±±
±±³          ³ nInfCIn  -> Imprime informacoes complementares do instr.   ³±±
±±³          ³ nINCs    -> Imprime nao conformidades                      ³±±
±±³          ³ nIOBS    -> Imprime observacao                             ³±±
±±³          ³ nLaudo   -> Imprime Laudo Final do Instrumento             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuri Seto ³ 20/06/00 ³ Alteracoes para calibrar Tipo de Calibracao Re- ³±±
±±³          ³          ³ logio.                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Mtr030Imp(	lEnd, wnRel, cString, nTxtFin,;
				  	nInfCom, nInfCIn, nIncs, nIOBS, nILaudo,aImpCer,nIResum,nIItb)

Local Tamanho		:= " "
Local cEscala		:= ""
Local cPadraoQMA	:= ""		
Local lImpDados		:= .T.
Local lImpCabec		:= .T.
Local nCntFor		:= 0
Local nCntFor2		:= 0
Local nCntFor3		:= 0
Local nCntForM		:= 0
Local nCntForM2		:= 0
Local nCont			:= 0
Local cStat			:= ''
Local aArray 		:= {}
Local lCab 			:= .f.
Local cPonto		:= ''
Local nRec			:= 0
Local lAchou 		:= .f.
Local cChave 		:= ''
Local nIncert		:= 0
Local nLimMin		:= 0
Local nLimMax		:= 0
Local cText 		:= ''
Local lDuplica		:= .t.
Local nRecQM7		:= 0  // Guardo numero do registro atual
Local nVezes 		:= 0
Local cInsEsc		:= " "
Local lMalha		:= .F.
Local aRelResu		:= {}
Local dDataQM3		:= ctod("  /  /  ")
Local lImpJust		:= .F.
Local cTipTol
Local cTolMaxQMA
Local cTolerQMA
Local lImp := .F.
Local cSeqlQM6 := "00"
Local lImpSub		:= .T.
Local cTextRet		:= ""
Local axTex			:= {}
Local ni			:= 1
Local nIncerMed		:= 0
Local nIncerTot		:= 0
Local nErrTots		:= 0
Local cValor		:= ""
Local nNumDec		:= 0
Local aRetorno		:= {}
Local nCnt			:= 0
Local nErrMa		:= 0
Local nx			:= 1
Local cRevisa		:= ""
Local nRQM6 		:= 0
Local lImpOk		:= .F.
Private lTitb		:= .F.	
Private aItbBox		:= {}
Private aResult		:= {}
Private lProcs		:= .F.
Private cNomDep		:= ""
Private	cNomResp	:= ""
li     := 80
m_pag  := 1
cbCont := 0
cbTXT  := ""     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso impressão seja seguida da calibracao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aImpCer <> NIL
    lCertif := .T.
	mv_par01  := aImpCer[1][1]
	mv_par02  := aImpCer[1][1]
	mv_par03  := aImpCer[1][2]
	mv_par04  := aImpCer[1][2]
  	mv_par05  := Space(9)
	mv_par06  := "zzzzzzzzz"				
	mv_par07  := 1	
	mv_par08  := Space(9)	
	mv_par09  := "zzzzzzzzz"					
	mv_par10  := Space(16)				 
	mv_par11  := "zzzzzzzzzzzzzzzz"
	mv_par12  := Space(16)				
	mv_par13  := "zzzzzzzzzzzzzzzz"
	mv_par14  := Space(16)				
	mv_par15  := "zzzzzzzzzzzzzzzz"
	mv_par16  := Space(6)
	mv_par17  := "zzzzzz" 
	mv_par18  := aImpCer[1][7]	
	mv_par19  := aImpCer[1][8]	
	cRevisa   := aImpCer[1][4]
Endif

dbSelectArea( "QM6" )
dbSetOrder(1)
dbSeek( xFilial() + mv_par01 , .T. )

Do While QM6->(!Eof()) .and. QM6_FILIAL == xFilial("QM6") .and. QM6->QM6_INSTR <= mv_par02
	//Quando eh chamado direto da rotina de calibracoes
	If aImpCer <> Nil
		If ( QM6->QM6_REVINS < cRevisa .or. QM6->QM6_REVINS > cRevisa )
			dbSkip()
			Loop
		Endif
		If ( QM6->QM6_CSEQ < aImpCer[1][9] .or. QM6->QM6_CSEQ > aImpCer[1][9] )
			dbSkip()
			Loop
		EndIf
		cSeql := aImpCer[1][9]
	Else
		cSeql := QM6->QM6_CSEQ
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se n„o est  entre os periodos informados, n„o imprime.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( QM6->QM6_DATA < mv_par03 .or. QM6->QM6_DATA > mv_par04 )
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura o instrumento relacionado com o cabe‡alho               ³
	//³ e posiciona os arquivos relacionados.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "QM2" )
	dbSetOrder(1)
	dbSeek( xFilial() + QM6->QM6_INSTR + Inverte(QM6->QM6_REVINS) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura o DEPARTAMENTO no QAD.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "QAD" )
	dbSetOrder(1)
	If dbSeek( xFilial() + QM2->QM2_DEPTO )
		cNomDep := QAD->QAD_DESC
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura o RESPONSAVEL NO QAA.                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QAA")
	dbSetOrder(1)
	If dbSeek( QM2->QM2_FILRES + QM2->QM2_RESP )
		cNomResp := QAA->QAA_NOME
	Endif
	
	dbSelectArea( "QM6" )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se n„o est  entre os departamentos informados, n„o imprime.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( QM2->QM2_DEPTO < mv_par05 .or. QM2->QM2_DEPTO > mv_par06 )
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifico O.C. interno e externo                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 1
		If ! Calibrador(0,mv_par08,mv_par09,mv_par10,mv_par11)
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2
		If ! Calibrador(1,mv_par08,mv_par09)
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 3
		If ! Calibrador(2,,,mv_par10,mv_par11)
			dbSkip()
			Loop
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se n„o ‚ a familia selecionada n„o Imprime.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( QM2->QM2_TIPO < mv_par12 .or. QM2->QM2_TIPO > mv_par13 )
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ N„o ‚ o fabricante selecionado.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( QM2->QM2_FABR < mv_par14 .or. QM2->QM2_FABR > mv_par15 )
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ N„o ‚ o usu rio selecionado.                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( QM2->QM2_RESP < mv_par16 .or. QM2->QM2_RESP > mv_par17 )
		dbSkip()
		Loop
	EndIf

	DbSelectArea("QM7")
 	DbSetOrder(1)
 	If !QM7->(DbSeek(xFilial()+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)))
		dbSelectArea("QM6")
		dbSkip() 		
		Loop
 	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciono na familia e revisao referentes a data do QM6.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "QM1" )
	dbSetOrder(1)
	dbSeek( xFilial() + QM2->QM2_TIPO )
	While QM1->(!Eof()) .And. QM1->QM1_TIPO == QM2->QM2_TIPO
		If xFilial() != QM1->QM1_FILIAL
			Exit
		EndIf
		If QM1->QM1_DATREV <= QM6->QM6_DATA
		// Para garantir a impressao do ultimo registro, de qualquer forma
		// Necessario para os casos de importacao, onde a data da revisao ‚ a
		// data da importacao. Desta forma, nao funcionaria o "IF" anterior.
			nRec := recno()
			Exit
		EndIf
		nRec := recno()
		dbSkip()
	EndDo
	If nRec >  0
		DbGoto(nRec)
	EndIf

	If ExistBlock("QMR030R")
		ExecBlock("QMR030R",.F.,.F.,{nTxtFin,nInfCom,nInfCIn,nIncs,nIOBS,nILaudo,nIResum,nIItb})
	Else
		m_pag  := 1
		Cabec1		:= OemToAnsi(QaTit("QM2_INSTR",16,.t.)) + QM2->QM2_INSTR +; // Instrumento
		' - ' + QM2->QM2_REVINS +;
		space(57) + '-------->> ' +;
		OemToAnsi(QaTit("QM6_VALDAF",16,.t.)) + DtoC(QM6->QM6_VALDAF)   // Validade da Afericao
     	Cabec2 := OemToAnsi(STR0131)+SubsTr(cUsuario,7,15)+Space(69) + "-------->> " + STR0023 + Repl(".", 14 - Len(STR0023))+":    "+ RetSem(QM6->QM6_VALDAF) // Semana :
		
		lImpDados	:= .T.

		If li > 55
			QM7->(DbSetOrder(1))
			QM7->(DbSeek(xFilial()+QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+cSeql))
			cCert := QM7->QM7_NRCERT
			Cabec( Titulo+OemToAnsi(STR0014)+' '+cCert, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18)) // "No." ,,.T.
				If !Empty(QM2->QM2_CLIE)
					dbSelectArea("SA1")
					dbSetOrder(01)
					If dbSeek(xFilial("SA1")+QM2->QM2_CLIE+QM2->QM2_LOJA)
						@ li,004 PSAY OemToAnsi(QaTit("QM2_CLIE",22,.t.)) + ; // Cliente							
						SA1->A1_NOME + " - " + SA1->A1_NREDUZ 
						li++     
						If li > 55
							Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
							li+=2
						EndIf

						@ li,004 PSAY OemToAnsi(STR0133)+ SA1->A1_END + " - " + A1_MUN + " - " + A1_EST
						li++

						If li > 55
							Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
							li+=2
						EndIf

						@ li,004 PSAY OemToAnsi(STR0134)+ SA1->A1_CEP + " - " + A1_BAIRRO
						li++

						If li > 55
							Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
							li+=2
						EndIf

						@ li,004 PSAY OemToAnsi(STR0135)+ SA1->A1_TEL
						li++
						
						If li > 55
							Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
							li+=2
						EndIf
                        li++
                        li++
					Endif
				Endif	
			@ li,004 PSAY OemToAnsi(QaTit("QM1_TIPO",22,.t.)) + ; // Familia
			Trim(QM1->QM1_TIPO) + " - " + QM6->QM6_REVTIP + " - " + QM1->QM1_DESCR 
			li++

			If lImpDados

 				@ li,004 PSAY OemToAnsi(QaTit("QM2_DEPTO",22,.t.)) + ; // Departamento
				Trim(QM2->QM2_DEPTO) + " - " + QAD->QAD_DESC

 				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM2_LOCAL",22,.t.)) + ; // Localizacao
				Trim(QM2->QM2_LOCAL)

 				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM2_RESP",22,.t.)) + ; // Responsavel
				Trim(QM2->QM2_RESP) + " - " + QAA->QAA_NOME


				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM2_NUMFAB",22,.t.)) + ; // Cod.Fabricante
				Left(QM2->QM2_NUMFAB,16)
				@ li,043 PSAY OemToAnsi(QaTit("QM2_FABR",22,.t.)) + ; // Fabricante
				Trim(QM2->QM2_FABR)

				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM2_TALIM",22,.t.)) + ; // Tensao Aliment
				QM2->QM2_TALIM
				@ li,043 PSAY OemToAnsi(QaTit("QM2_LEIT",22,.t.)) + ; // Leitura
				QM2->QM2_LEIT
				@ li,086 PSAY OemToAnsi(QaTit("QM2_NSEFAB",22,.t.)) + ; // Num.Serie
				QM2->QM2_NSEFAB

				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM2_POT",22,.t.)) + ; // Potencia
				QM2->QM2_POT
				@ li,043 PSAY OemToAnsi(QaTit("QM2_CUSTO",22,.t.)) + ; // Custo
				QM2->QM2_CUSTO
				@ li,086 PSAY OemToAnsi(QaTit("QM2_USOINI",22,.t.)) + ; // Uso Inicial
				DtoC( QM2->QM2_USOINI )

				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM2_FREQAF",22,.t.)) + ; // Freq.Calib.
				StrZero(QM2->QM2_FREQAF,4) + OemToAnsi(STR0130) //" Dias"
				@ li,043 PSAY OemToAnsi(QaTit("QM2_RESOL",22,.t.)) + ; // Erro de Resolucao
				QM2->QM2_RESOL

 				li++
				// Procura descricao do Status
				QMP->(DbSetOrder(1))
				QMP->(DbSeek(xFilial("QMP")+QM2->QM2_STATUS))
				@ li,004 PSAY OemToAnsi(QaTit("QM2_STATUS",22,.t.)) + ; // Status
				If(QMP->(Found()),QMP->QMP_DESCR,space(36))
				li++
 				@ li,004 PSAY OemToAnsi(QaTit("QM6_CSEQ",22,.t.)) + ; // 
				QM6->QM6_CSEQ
 				@ li,043 PSAY OemToAnsi(QaTit("QM2_DESCR",22,.t.)) + ; // 
				QM2->QM2_DESCR
			EndIf


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciono no Procedimento de Calibracao do QA5.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            lProcs := .F.
			QA5->(dbSetOrder(1))
			If QA5->(dbSeek(xFilial("QA5") + "C" + QM1->QM1_PROCAL))
				//Localizar o procedimento utilizado na data da calibracao. . .
				While QA5->(!Eof()) .and. QA5->QA5_FILIAL+QA5->QA5_CODTAB+QA5->QA5_NORMA ==;
					xFilial("QA5")+"C"+QM1->QM1_PROCAL 
				    If QA5->QA5_DATA <= QM6->QM6_DATA
			    		lProcs := .T.
			    		Exit
				    Endif	
					QA5->(dbSkip())
				Enddo
            Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existem tolerancias de processo e redutores para    ³
			//³ serem impressos (se escala for confirma‡ao metrologica)         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 			aArray := {}
 			lMalha := .F.
 			cInsEsc := " "
			QMR->(DbSetOrder(1))
			If QMR->(DbSeek(xFilial("QMR")+QM6->QM6_INSTR+QM6->QM6_REVINS))
				cChave := xFilial("QMR")+QMR->QMR_INSTR+QMR->QMR_REVINS
				Do while cChave ==;
					xFilial("QMR")+QMR->QMR_INSTR+QMR->QMR_REVINS
					If QMR->QMR_CAOBRI = "S"
						cInsEsc := R030InsEsc(QMR->QMR_INSTR,QMR->QMR_ESCALA)
						If !Empty(cInsEsc)
							lMalha := .T.	
							// E instrumento Malha, entao imprime o codigo do instrumento filho na junto com 
							// as escalas, tolerancia e redutor
						EndIf
						aadd(aArray,{QMR->QMR_ESCALA,QMR->QMR_TOLPRO,QMR->QMR_REDUT,QMR->QMR_INPERM,QMR->QMR_PREC,cInsEsc})
					EndIf
					QMR->(DbSkip())
				EndDo
			EndIf

			If !lMalha	// Nao eh instrumento Malha
				// 11 - Posicao Inicial						     			 Posicao Final - 97
	            //          2         3         4         5         6         7         8         9        10        11        12
				// 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				// =======================================================================================================
				//	|         Escala         |   Tolerancia do Processo   |  Redutor  | Inc.Permitida | 0123456789012     |
				//	-------------------------------------------------------------------------------------------------------
				//	|    1234567890123456    |         1234567890         |     99    |	9999999999	 | 01234567890123456 |
				//	-------------------------------------------------------------------------------------------------------
	
				li++
				lCab := .t.
				If !empty(aArray)
					@ li  ,000 PSAY __PrtFatLine()					
					li++
					@ li  ,004 PSAY Upper(OemToAnsi(QaTit("QMR_ESCALA",12,.f.)))		// Escala
					@ li  ,039 PSAY space(4)+Upper(OemToAnsi(QaTit("QMR_TOLPRO",12)))	// Tolerancia do Processo
					@ li  ,066 PSAY Space(3)+Upper(OemToAnsi(QaTit("QMR_REDUT",12)))	// Redutor
					@ li  ,089 PSAY Space(3)+Upper(OemToAnsi(QaTit("QMR_INPERM",12)))	// Inc.Permit.
					@ li  ,118 PSAY Space(2)+Upper(OemToAnsi(QaTit("QMR_PREC",12)))	// Precisao
                    li++
					@li,00 PSAY __PrtFatLine()
					lCab := .f.					
					li++
					For nCntFor := 1 to Len(aArray)
						If li > 55 
							If li > 55
								R030Cab()
							EndIf
							li+= 2
//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//    ESCALA                                 TOLERANCIA                REDUTOR                INC.PERMITIDA               PRECISAO
						EndIf          
	
						@ li  ,004 PSAY aArray[nCntFor,1]
						@ li  ,043 PSAY aArray[nCntFor,2] 
						@ li  ,069 PSAY aArray[nCntFor,3]
						@ li  ,092 PSAY aArray[nCntFor,4]
						@ li  ,120 PSAY aArray[nCntFor,5]
						li++
					Next nCntFor
				EndIf
	        Else    
				// 01 - Posicao Inicial						     			 Posicao Final - 129
	            //          1         2         3         4         5         6         7         8         9        10        11        12         13
				// 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
				// =================================================================================================================================
				// |  Escala                |      Instrumento       |   Tolerancia do Processo   |  Redutor  |  Inc.Permitida | Precisao          |
				// ---------------------------------------------------------------------------------------------------------------------------------
				// |  1234567890123456      |    1234567890123456    |         1234567890         |     99    |   9999999999   | 01234567890123456 |
				// ---------------------------------------------------------------------------------------------------------------------------------
	
				lCab := .t.
				If !empty(aArray)
//					For nCntFor := 1 to Len(aArray)
						If li > 55 .or. lCab
							If li > 55
								R030Cab()
							EndIf
							li+= 2
							@ li  ,000 PSAY __PrtFatLine()
							li++
							@ li  ,000 PSAY "|"
							@ li  ,004 PSAY OemToAnsi(QaTit("QMR_ESCALA",12,.f.)) // Escala
							@ li  ,026 PSAY "|"
							@ li  ,033 PSAY OemToAnsi(QaTit("QMR_INSTR",12)) // Instrumento
							@ li  ,051 PSAY "|"
							@ li  ,055 PSAY OemToAnsi(QaTit("QMR_TOLPRO",12)) // Tolerancia do Processo
							@ li  ,080 PSAY "|"
							@ li  ,083 PSAY OemToAnsi(QaTit("QMR_REDUT",12)) // Redutor
							@ li  ,092 PSAY "|"
							@ li  ,095 PSAY OemToAnsi(QaTit("QMR_INPERM",12)) // Inc.Permit.
							@ li  ,109 PSAY "|"
							@ li  ,111 PSAY OemToAnsi(QaTit("QMR_PREC",12)) // Precisao
							@ li  ,131 PSAY "|"
							li++
							@ li  ,000 PSAY __PrtFatLine()
							lCab := .f.
						EndIf
					For nCntFor := 1 to Len(aArray)
						li++
						@ li  ,000 PSAY "|"
						@ li  ,004 PSAY aArray[nCntFor,1]
						@ li  ,026 PSAY "|"
						@ li  ,031 PSAY aArray[nCntFor,6]
						@ li  ,051 PSAY "|"
						@ li  ,061 PSAY aArray[nCntFor,2]
						@ li  ,080 PSAY "|"
						@ li  ,086 PSAY aArray[nCntFor,3]
						@ li  ,092 PSAY "|"
						@ li  ,096 PSAY aArray[nCntFor,4]
						@ li  ,109 PSAY "|"
						@ li  ,111 PSAY aArray[nCntFor,5]
						@ li  ,131 PSAY "|"
						li++
					Next nCntFor
					@ li  ,001 PSAY __PrtThinLine()
				EndIf
			EndIf
		
		EndIf
	
 		li++

 		DbSelectArea("QM7")
		QM7->(DbSetOrder(1))
		QM7->(DbSeek(xFilial()+QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+cSeql))

		li++
		@ li,000 PSAY __PrtFatLine()
		li++
		@ li,000 PSAY __PrtCenter(Upper(OemToAnsi(STR0015)))	
		li++
		@ li,000 PSAY __PrtFatLine()

		li++

		Do while !QM7->(Eof()) .and. QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+cSeql ==;
				 			  QM7->QM7_INSTR+QM7->QM7_REVINS+DtoS(QM7->QM7_DATA)+QM7->QM7_CSEQ
			If li > 55
				R030Cab()
				lImpCabec := .T.
				Loop
			Endif

			If lImpCabec
				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM7_ESCALA",22,.t.)) + ;
				alltrim(QM7->QM7_ESCALA) + ' - ' + QM7->QM7_REVESC

				li++
				@ li,004 PSAY OemToAnsi(QaTit("QM1_PROCAL",22,.t.))  + ; // "Procedimento Cal.
				If(lProcs,alltrim(QA5->QA5_NORMA) + "-" + QA5->QA5_REVPRO+" - " + QA5->QA5_DESCRI,QM1->QM1_PROCAL)
				li++
				QM9->(DbSetOrder(1))
				QM9->(DbSeek(xFilial("QM9")+QM7->QM7_ESCALA+Inverte(QM7->QM7_REVESC)))
				@ li,004 PSAY OemToAnsi(QaTit("QM9_TIPAFE",22,.t.))+; // "Destino Calib.
				If(QM9->QM9_ORGAFE=="E", OemToAnsi(STR0016) + " - " + QM9->QM9_LABOR,; // "Externo"
												 OemToAnsi(STR0017) + " - " + QM9->QM9_DEPTO)  // "Interno"
				li+=2
			Endif
			@li,000 PSAY __PrtFatLine()
			li++
			
			QM9->(DbSetOrder(1))
			QM9->(DbSeek(xFilial("QM9")+QM7->QM7_ESCALA+Inverte(QM7->QM7_REVESC)))

	 		cChave := QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+QM6->QM6_CSEQ+;
						 QM7->QM7_ESCALA+QM7->QM7_REVESC

			lCab := .t.

			If QM9->QM9_TIPAFE $ "1,2,3,9"
				// ALTERADO DE QM6 PARA QM7 NA LINHA ABAIXO PARA INSTRUMENTO E REVISAO
				Do while cChave == QM7->QM7_INSTR+QM7->QM7_REVINS+dtos(QM7->QM7_DATA)+QM7->QM7_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC

					If li > 55
						R030Cab()
						li++
						lCab := .t.
					EndIf
					
					lImpSub := .T.
					
					QM3->(DbSetOrder(1))
					QM3->(DbSeek(xFilial("QM3")+QM7->QM7_PONTO+Inverte(QM7->QM7_REVPAD)))
					
					If mv_par19 == 2 //Nao Impr. Informacoes Pontos Subjetivos
						If Alltrim(QM3->QM3_TIPPAD) == "S"
							lCab	:= .F.						
							lImpSub	:= .F.	
						Endif
                    Endif    
					If lCab
//          10        20        30        40        50        60        70        80        90        100       110       120       130
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
//    Padrao - Revisao       Especificado Toler.Mi   Toler.Ma   T.Tol. Unid.Med  Num.Certi Padrao Util.          Val.Ca    Incerteza
//
						@ li,004 PSAY Upper(OemToAnsi(QaTit("QM3_PADRAO",6))) + ' - ' +;  // Padrao
										Upper(OemToAnsi(QaTit("QA9_REV",8)))	// Rev
						@ li,027 PSAY Upper(OemToAnsi(QaTit("QM3_ESPEC",12)))		// Especificado
						@ li,040 PSAY Upper(OemToAnsi(QaTit("QM3_TOLMIN",8)))		// Tol.Min. 
						@ li,051 PSAY Upper(OemToAnsi(QaTit("QM3_TOLER",8)))		// Tol.Max.  
						@ li,062 PSAY Upper(OemToAnsi(STR0132)) 					// T.Tol.						  
						@ li,069 PSAY Upper(OemToAnsi(QaTit("QM3_UNIMED",8)))		// Unid.Med    
						@ li,079 PSAY Upper(OemToAnsi(QaTit("QM3_CERTIF",9)))		// Certificado  
						@ li,089 PSAY Upper(OemToAnsi(QaTit("QM3_PADUT",12)))		// Padrao Utilizado  
  						@ li,111 PSAY Upper(OemToAnsi(QaTit("QM3_VALDAF",8)))		// Val.Cal.  
						@ li,121 PSAY Upper(OemToAnsi(QaTit("QM3_INCERT",9)))		// Incerteza  
						li++
						@li,000 PSAY __PrtFatLine()
						li++
						lCab := .F.
					EndIf
//          10        20        30        40        50        60        70        80        90
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//    X                      X            Y          Y          Z         Z         A
					If lImpSub
						@ li,004 PSAY alltrim(QM7->QM7_PONTO) + ' - ' + QM7->QM7_REVPAD
						@ li,027 PSAY QM7->QM7_ESPEC

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pego tolerancia informada no QMC. A do padrao serviu como suges-³
					//³ tao no momento da amarracao do padrao com a escala.             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						QMC->(DbSetOrder(1))
						If QMC->(DbSeek(xFilial("QMC")+QM7->QM7_ESCALA+Inverte(QM7->QM7_REVESC)+QM7->QM7_PONTO))
							@ li,040 PSAY QMC->QMC_TOLMIN
							@ li,051 PSAY QMC->QMC_TOLER						
							cTipTol := QMC->QMC_TIPTOL
						Else
							@ li,040 PSAY QM3->QM3_TOLMIN
							@ li,051 PSAY QM3->QM3_TOLER
							cTipTol := QM3->QM3_TIPTOL						
						EndIf
						If cTipTol <> "1"
							@ li,063 PSAY "%"
						Endif				

						SAH->(DbSetOrder(1))
						@ li,069 PSAY If(SAH->(DbSeek(xFilial("SAH")+QM3->QM3_UNIMED)),SAH->AH_UMRES,space(9))
						@ li,079 PSAY Left(QM3->QM3_CERTIF,8)
						@ li,089 PSAY Left(QM3->QM3_PADUT,20)
						@ li,111 PSAY DtoC(QM3->QM3_VALDAF)
						@ li,121 PSAY Left(QM3->QM3_INCERT,10)
						li++
						@ li,004 PSAY QM3->QM3_DESCRI
						li++
					Endif
					dbSelectArea( "QM7" )
					dbSkip()

				EndDo
				cChave := QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+QM6->QM6_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC

			ElseIf QM9->QM9_TIPAFE $ "4,8"

/*
 	       Ponto          Nominal        LIE          LSE       Unid.Med            Escala            Tipo Calc.Tolerancia
 	  ================   ==========   ==========   ==========   =========   =======================   =====================
 	  1234567890123456   1234567890   1234567890   1234567890   12345678    1234567890 a 1234567890         1234567890

*/
				cChave := QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+QM6->QM6_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC

				lCab := .T.

				QMG->(DbSetOrder(1))

				// ALTERADO DE QM6 PARA QM7 NA LINHA ABAIXO PARA INSTRUMENTO E REVISAO
				Do while cChave == QM7->QM7_INSTR+QM7->QM7_REVINS+dtos(QM7->QM7_DATA)+QM7->QM7_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC

					If QMG->(DbSeek(xFilial("QMG")+QM6->QM6_INSTR+QM6->QM6_REVINS+QM7->QM7_PONTO))
						If li > 55
							R030Cab()
							li++
							lCab := .t.
						EndIf

						If lCab
//          1         2         3         4         5         6         7         8         9         0          1        2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//    PONTO               NOMINAL          LIE              LSE               T.TOL             UNID.MED.            ESCALA  
//    xxxxxxxxxxxxxxxxxxx yyyyyyyyyyyy     YYYYYYYYYYY      YYYYYYYYYYY         %               YYYYYYYYY   XXXXXXXXXXX a XXXXXXXXXXX
							@ li,004 PSAY Upper(OemToAnsi(STR0053))//"Ponto"
							@ li,024 PSAY Upper(OemToAnsi(STR0074))//"Nominal"
							@ li,041 PSAY Upper(OemToAnsi(STR0076))//"LIE"
							@ li,058 PSAY Upper(OemToAnsi(STR0075))//"LSE"     
							@ li,076 PSAY Upper(OemToAnsi(STR0132))//"T.Tol"	
							@ li,094 PSAY Upper(OemToAnsi(STR0077))//"Unid.Med"
							@ li,115 PSAY Upper(OemToAnsi(STR0078))//"Escala"

							li++
							lCab := .F.
                            @li,000 PSAY __PrtFatLine()
                            li++
						EndIf
//           10        20        30        40        50        60        70        80        90        100       110       120       130
//01234567789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//    xxxxxxxxxxxxxxxxxxx yyyyyyyyyyyy     YYYYYYYYYYY         YYYYYYYYYYY         XXXXXXXXXXX YYYYYYYYY   XXXXXXXXXXX a XXXXXXXXXXX
						@ li  ,004 PSAY QM7->QM7_PONTO
						@ li  ,024 PSAY QM7->QM7_ESPEC
						@ li  ,041 PSAY QMG->QMG_LIE
						@ li  ,058 PSAY QMG->QMG_LSE
						If QMG->QMG_TIPTOL <> "1"
							@ li  ,078 PSAY "%"
						Endif
						@ li  ,094 PSAY If(SAH->(DbSeek(xFilial("SAH")+QMG->QMG_UNIMED)),SAH->AH_UMRES,space(9))
						@ li  ,106 PSAY QMG->QMG_ESCALI
						@ li  ,118 PSAY "a"
						@ li  ,120 PSAY QMG->QMG_ESCALF
						//Busca o conteudo do Cbox ja respeitando o idioma
						li++
					EndIf
					DbSelectArea("QM7")
					QM7->(DbSkip())
				EndDo
				cChave := QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+QM6->QM6_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC

 			ElseIf QM9->QM9_TIPAFE == "5"
/*
        Faixa         Especificado    Tolerancia  Unid.Med   Incerteza    Dt.Calib   Tipo Toler.
   ================   =============   ==========  ========   ==========   ========== ===========
   1234567890123456      1234567890   1234567890  12345678   1234567890   99/99/99   1234567890

*/

				cChave := QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+QM6->QM6_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC

				QMT->(DbSetOrder(1))

				// ALTERADO DE QM6 PARA QM7 NA LINHA ABAIXO PARA INSTRUMENTO E REVISAO
				Do while cChave == QM7->QM7_INSTR+QM7->QM7_REVINS+dtos(QM7->QM7_DATA)+QM7->QM7_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC
                    QMA->(DbSetOrder(1))
					If QMA->(DbSeek(xFilial("QMA")+QM7->QM7_ESCALA+QM7->QM7_REVESC+;
															 QM7->QM7_PONTO))

						If li > 55
							R030Cab()
							li++
							lCab := .t.
						EndIf
//          1         2         3         4         5         6         7        8          9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//    FAIXA              ESPECIFICADO       TOLER.MIN.       TOLER.MAX.      TP.TOLER.       UNID.MED      INCERTEZA      DT.CALIB.
						If lCab
                            @li,000 PSAY __PrtFatLine()
                            li++
							@ li,004 PSAY Upper(OemToAnsi(STR0080))//"Faixa"
							@ li,023 PSAY Upper(OemToAnsi(STR0081))//"Especificado"
							@ li,042 PSAY Upper(OemToAnsi(QaTit("QMA_TOLMIN",9)))//"Tol.Min."
							@ li,059 PSAY Upper(OemToAnsi(QaTit("QMA_TOLER",9)))//"Tol.Max."
							@ li,075 PSAY Upper(OemToAnsi(STR0132))//"Tp.Tol."							
							@ li,091 PSAY Upper(OemToAnsi(STR0083))//"Unid.Med"
							@ li,105 PSAY Upper(OemToAnsi(STR0084))//"Incerteza"
							@ li,120 PSAY Upper(OemToAnsi(STR0085))//"Dt.Calib."
							li++
							@li,000 PSAY __PrtFatLine()
							li++
							lCab := .F.
						EndIf

						nIncert := 0
                                                     
						dData := ctod("31/12/2050","DDMMYY")
						QM3->(DbSetOrder(1))
                        Do while QMA->QMA_FILIAL+QMA->QMA_ESCALA+QMA->QMA_REVESC+QMA->QMA_FAIXA ==;
									QM7->QM7_FILIAL+QM7->QM7_ESCALA+QM7->QM7_REVESC+QM7->QM7_PONTO

							QM3->(DbSeek(xFilial("QM3")+QMA->QMA_PADRAO))    
							If lTamSom
								If !Empty(QM9->QM9_ESCALI)
									cPadraoQMA := QMA->QMA_PADRAO
									cTolerQMA  := Alltrim(Str(SuperVal(QMA->QMA_TOLMIN),TamSX3("QMA_TOLMIN")[1],QA_NUMDEC(QMA->QMA_TOLMIN)))
									cTolMaxQMA := Alltrim(Str(SuperVal(QMA->QMA_TOLER),TamSX3("QMA_TOLER")[1],QA_NUMDEC(QMA->QMA_TOLER)))
									cTolerQMA  := StrTran(cTolerQMA,".",",")
									cTolMaxQMA := StrTran(cTolMaxQMA,".",",")
									cTipTol	   := QMA->QMA_TIPTOL	
								Else
									cPadraoQMA := QMA->QMA_PADRAO
									cTolerQMA  := QMA->QMA_TOLMIN	
									cTolMaxQMA := QMA->QMA_TOLER	
									cTipTol	   := QMA->QMA_TIPTOL	
								Endif	
							Else
								cPadraoQMA := QMA->QMA_PADRAO
								cTolerQMA  := QMA->QMA_TOLMIN	
								cTolMaxQMA := QMA->QMA_TOLER	
								cTipTol	   := QMA->QMA_TIPTOL	
							Endif								
							Do While QM3->(!Eof()) 
								If QM3->QM3_FILIAL+QM3->QM3_PADRAO == xFilial("QMA")+cPadraoQMA
									If QM7->QM7_DATA >= QM3->QM3_DATREV
										If dDataQM3 <= QM3->QM3_DATREV
											nRec := QM3->(RecNo())
											dDataQM3 := QM3->QM3_DATREV
											lImp := .T.
										Endif	
									Else
										lImp := .F.
									Endif	 
								Endif
								dbSelectArea("QM3")	
								QM3->(dbSkip())
							Enddo	      
							
							QM3->(dbGoTo(nRec))         
							
							dDataQM3 := ctod("  /  /  ")
							nIncert += SuperVal(QM3->QM3_INCERT)
							If !Empty(QM3->QM3_VALDAF)
								If(QM3->QM3_VALDAF < dData,dData := QM3->QM3_VALDAF,Nil)
							Else
								dData := ctod("  /  /  ")
							Endif	
							QMA->(DbSkip())
						EndDo
						If lImp
							@ li  ,004 PSAY QM7->QM7_PONTO
							@ li  ,023 PSAY QM7->QM7_ESPEC
							@ li  ,042 PSAY cTolMaxQMA 
							@ li  ,059 PSAY cTolerQMA						
							If cTipTol <> "1"
								@ li  ,079 PSAY "%"
							Endif
							@ li  ,091 PSAY If(SAH->(DbSeek(xFilial("SAH")+QM3->QM3_UNIMED)),SAH->AH_UMRES,space(9))
							@ li  ,105 PSAY Alltrim(Str(nIncert))
							@ li  ,120 PSAY dtoc(dData)
							li++
						Endif	
					EndIf
					DbSelectArea("QM7")
					QM7->(DbSkip())
				EndDo
				cChave := QM6->QM6_INSTR+QM6->QM6_REVINS+dtos(QM6->QM6_DATA)+QM6->QM6_CSEQ+;
							 QM7->QM7_ESCALA+QM7->QM7_REVESC
							 
				li++
				@li,000 PSAY __PrtThinLine()			 
				li++
			Else
				DbSelectArea("QM7")
				QM7->(DbSkip())
			EndIf
			lImpCabec := .T.
		EndDo

		li+=2
		
		@li,00 PSAY __PrtFatLine()
		li++
        @ li,000 PSAY __PrtCenter(Upper(Padc(OemToAnsi(STR0029),22)))
		li++                       
		@li,00 PSAY __PrtFatLine()		
		li+=2
      QAA->(DbSetOrder(1))
      QAA->(DbSeek(QM6->QM6_FILRES + QM6->QM6_RESP))
 	  @ li,004 PSAY OemToAnsi(STR0030)+DtoC(QM6->QM6_DATA)+space(20)+; //"Data: "
			  		 	OemToAnsi(STR0031)+QM6->QM6_TOTHOR+space(20)+; //"Tot.Horas: "
						 	OemToAnsi(STR0032)+QM6->QM6_RESP +; // "Metrologista: "
							" - " + Iif(!Empty(QAA->QAA_APELID),QAA->QAA_APELID,SubStr(QAA->QAA_NOME,1,15))
		// Se inclui valor de R&R na calculo de Incerteza, imprimir
		If GetMV("MV_QINCRR") == "S"
			@ li,090 PSAY OemToAnsi("R&R: ")+QM6->QM6_REPEPR
		EndIf
		//Somente imprimir status do instrumento na medicao quando a mesma
		//estiver preenchida
		
		If !Empty(QM6->QM6_STATUS)
			li+=2
			dbSelectArea("QMP")
			dbSetOrder(1)
			QMP->(DbSeek(xFilial("QMP")+QM6->QM6_STATUS))
			@ li,004 PSAY OemToAnsi(STR0136) + ; // Status na Medicao 
			If(QMP->(Found()),QMP->QMP_DESCR+space(15),space(51))+STR0145+QM6->QM6_CSEQ
		Endif	                                               
		li+=2

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime as medicoes                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
   ============================================================================================================================
   |	Escala: XXXXXXXXXXXXXXXX-99                              Valores Inicial Subida                 								|
   |  Valor Mínimo: 9999999999    Valor Maximo: 9999999999                                    Unidade de Medida: XXXXXXXXX    |
   ============================================================================================================================
   |					|			  	      |	 Media	 |  Desvio  |  Desvio  |Incerteza |Incerteza |   Erro   |             |
   |Padrao              | Valores Encontrados | Leituras |  Medio   |  Padrao  |Medicao   |  Total   |   Total  |  Status     |
   ----------------------------------------------------------------------------------------------------------------------------
   |12345678901234567890|1234567890|1234567890|1234567890|1234567890|1234567890|1234567890|1234567890|1234567890|1234567890123|
   |1234567890 UUUUMMMM |          |          |          |          |          |          |          |          |             |
   |        Observacao : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx					      |
   |              		 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                          |
   ----------------------------------------------------------------------------------------------------------------------------

*/

		lCab := .t.
 		DbSelectArea("QM7")
 		DbSetOrder(1)
 		QM7->(DbSeek(xFilial()+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)+cSeql))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta aMedicoes                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 		aResult := MTR030Carg(@aRelResu,aImpCer)
 	    cEscala := aMedicoes[1,nPosEsc]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o numero de colunas 1-simples, 2-completo, 4-pressao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotCol := R030NumCol(1)

		nCntFor := 1

		While nCntFor <= Len(aMedicoes)

			lCab := .T.
			nAuxCntFor := nCntFor		// Guarda o indice da primeira escala

			For nCntForM := 1 to nTotCol
			    If nCntForM <= nTotCol
  				nCntFor := nAuxCntFor
				lCab := .T.

				While nCntFor <= Len(aMedicoes) .and. ;
					  cEscala == aMedicoes[nCntFor,nPosEsc]			
					  
					cText := ""

					If aMedicoes[nCntFor,nPosGer,1,2] $ "2,5,8,3,9" .and. aMedicoes[nCntFor,nPosGer,1,6] $ "1|2"
    	
	 					If nTotCol == 4
							If nCntForM == 1 
								cText := If(aMedicoes[nCntFor,nPosGer,1,2] = "3",Upper(STR0033),If(aMedicoes[nCntFor,nPosGer,1,2] = "9",Upper(STR0115)," "))	//"Inicial Subida"	//"Inicial Crescente"
							ElseIf nCntForM == 2
								cText := If(aMedicoes[nCntFor,nPosGer,1,2] = "3",Upper(STR0035),If(aMedicoes[nCntFor,nPosGer,1,2] = "9",Upper(STR0116)," "))  //"Final Subida"     //"Final Crescente"
							ElseIf nCntForM == 3
								cText := If(aMedicoes[nCntFor,nPosGer,1,2] = "3",Upper(STR0034),If(aMedicoes[nCntFor,nPosGer,1,2] = "9",Upper(STR0117)," "))	//"Inicial Descida"	 //"Inicial Descrescente"
							Else
								cText := If(aMedicoes[nCntFor,nPosGer,1,2] = "3",Upper(STR0036),If(aMedicoes[nCntFor,nPosGer,1,2] = "9",Upper(STR0118)," "))   //"Final Descida"    //"Final Descrescente"
							EndIf
						ElseIf nTotCol > 1 .and. aMedicoes[nCntFor,nPosGer,1,3] <> "A"
							If nCntForM == 1
								cText := Upper(STR0037)   // "Iniciais"
							Else
								cText := Upper(STR0038)   // "Finais"
							EndIf
						ElseIf aMedicoes[nCntFor,nPosGer,1,3] == "A"	
							cText := Upper(STR0038)   // "Finais"						
						Else
							cText := ""
						EndIf
					EndIf
		
					If aMedicoes[nCntFor,nPosGer,1,6] $ "1|2" // Se houver medicoes com incerteza

						If li > 55
							R030Cab()
							li++
							lCab := .t.
						EndIf
	
                  		If lCab
                     		If li > 49  
		                        R030Cab()
        		                li++
                		        MTR030CInc(cText,nCntFor)  // Imprime cabecalho de
											             // Medicoes com Incerteza
		                    Else
        		                If nCntForM == 1
                		           MTR030CInc(cText,nCntFor)  // Imprime cabecalho de 
                        			                         // Medicoes com Incerteza
		                        EndIf
        		            EndIf
                		    If li > 53
		                        R030CAB()
        		                li++
                		        MTR030CInc(cText,nCntFor)  // Imprime cabecalho de 
	                      			                       // Medicoes com Incerteza
    		                    li++   	
            	        	    MTR030SubCab(cText,nCntFor)  // Imprime o SubCabecalho
                		        li++
		                        lCab := .f.
        		            Else
                		        MTR030SubCab(cText,nCntFor)  // Imprime o SubCabecalho
		                        li++
        		                lCab := .f.
		                        If li > 55
        		                   R030CAB()
                		           li++
		                           MTR030CInc(cText,nCntFor)  // Imprime cabecalho de 
        			                                           // Medicoes com Incerteza
                    		       li++
		                           MTR030SubCab(cText,nCntFor)  // Imprime o SubCabecalho
        		                   li++
                		        EndIf
		                    EndIf
						EndIf

						@li,000 PSAY '|'
						
						@li,004 PSAY alltrim(aMedicoes[nCntFor,nPosPad])
	
						@li,025 PSAY '|'
						If ntotcol > 0 .and. aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M" // Tipo do padrao ‚ Mensuravel
							@li,026 PSAY If(!empty(aMedicoes[nCntFor,nPosMed,1,nCntForM]),;
												aMedicoes[nCntFor,nPosMed,1,nCntForM],'')
						ElseIf aMedicoes[nCntFor,nPosGer,1,3] == "A" // Tipo do padrao ‚ Atributo
							// Senao ‚ tipo Atributo (imprime Aprovado ou Reprovado)
							@li,026 PSAY If(aMedicoes[nCntFor,nPosMed,1,nCntForM]=="A",;
												GetMv("MV_QAPROV"),;
											 If(aMedicoes[nCntFor,nPosMed,1,nCntForM]=="R",;
											   GetMv("MV_QREPRO"),""))
						EndIf
						@li,036 PSAY '|'
						If aMedicoes[nCntFor,nPosGer,1,1] > 1 // Verifica se Escala tem mais de uma medicao
							If nTotCol > 0 .and.;
								aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M" // Tipo do padrao ‚ Mensuravel
 								@li,037 PSAY If(!empty(aMedicoes[nCntFor,nPosMed,2,nCntForM]),;
													aMedicoes[nCntFor,nPosMed,2,nCntForM],'')
							EndIf
						EndIf
						@li,047 PSAY '|'
	
						If nTotCol > 0 .and.; //Media das Leituras
							aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M" // Tipo do padrao ‚ Mensuravel
							@li,048 PSAY aResult[nCntFor,nCntForM,1] PICTURE QMT140Pics("aResult[nCntFor,nCntForM,1]",;
											aMedicoes[nCntFor,nPosMed,1,nCntForM],.t.)
						Endif
	
						@li,058 PSAY '|'
	
						If aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M"  .or.; //Desv.Medio
							(aMedicoes[nCntFor,nPosGer,1,4] == "E" .and.;
							aMedicoes[nCntFor,nPosGer,1,1] == 0)
							If ValType(aResult[nCntFor,nCntForM,2]) == "C"
								@li,059 PSAY 	 PADL(AllTrim(aResult[nCntFor,nCntForM,2]),10," ")
							Else
								@li,059 PSAY 	 aResult[nCntFor,nCntForM,2] PICTURE QMT140Pics("aResult[nCntFor,nCntForM,2]",;
												 aMedicoes[nCntFor,nPosMed,1,nCntForM],.t.)
												 
							EndIf
	 					EndIf
	
	 					@li,069 PSAY '|'
	
						If aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M" .or.; //Desv Padrao
								(aMedicoes[nCntFor,nPosGer,1,4] == "E" .and.;
								aMedicoes[nCntFor,nPosGer,1,1] == 0)
								@li,070 PSAY aResult[nCntFor,nCntForM,3] PICTURE QMT140Pics("aResult[nCntFor,nCntForM,3]",;
											  aMedicoes[nCntFor,nPosMed,1,nCntForM],.t.)
						EndIf
	
		 				@li,080 PSAY '|'
	
						If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M" //Inc Med
							@li,081 PSAY	 aResult[nCntFor,nCntForM,4] PICTURE QMT140Pics("aResult[nCntFor,nCntForM,4]",;
												 aMedicoes[nCntFor,nPosMed,1,nCntForM],.t.)
						EndIf
	
			 			@li,091 PSAY '|'
	
						If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M"  .or.;  //Inc Tot
							(aMedicoes[nCntFor,nPosGer,1,4] == "E" .and.;
							aMedicoes[nCntFor,nPosGer,1,1] == 0)
							If ValType(aResult[nCntFor,nCntForM,5]) == "C"
								@li,092 PSAY PADL(AllTrim(aResult[nCntFor,nCntForM,5]),10," ")
							Else
								@li,092 PSAY aResult[nCntFor,nCntForM,5] PICTURE QMT140Pics("aResult[nCntFor,nCntForM,5]",;
													 aMedicoes[nCntFor,nPosMed,1,nCntForM],.t.)
							EndIf
						EndIf
	
						@li,102 PSAY '|'
	
						If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M"
							If ExistBlock("qmt140EI")
								nErrMa := ExecBlock("qmt140EI",.F.,.F.,{aResult[nCntFor,nCntForM,5],aResult[nCntfor,nCntForM,2]})
								@li,103	PSAY nErrMa PICTURE QMT140Pics("aMedicoes[nCntFor,nPosMed,1,1]",aMedicoes[nCntFor,nPosMed,1,1],.t.)
							Else
								If GetMv("MV_QCALINC") == '1' // Soma Algebrica
									@li,103	PSAY aResult[nCntFor,nCntForM,5]+aResult[nCntfor,nCntForM,2] ;
											PICTURE QMT140Pics("aMedicoes[nCntFor,nPosMed,1,1]",aMedicoes[nCntFor,nPosMed,1,1],.t.)
								Else
									@li,103 PSAY Sqrt(aResult[nCntfor,nCntForM,5]^2+aResult[nCntFor,nCntForM,2]^2) ;
									PICTURE QMT140Pics("aMedicoes[nCntFor,nPosMed,1,1",aMedicoes[nCntFor,nPosMed,1,1],.t.)
								EndIf 
							Endif	
						Else
							If aMedicoes[nCntFor,nPosGer,1,4] == "E" .and.;	//Externo sem medicao
								aMedicoes[nCntFor,nPosGer,1,1] == 0 			// Incerteza e desvio são digitados
								If ExistBlock("qmt140EI")
									nErrMa := ExecBlock("qmt140EI",.F.,.F.,{aResult[nCntFor,nCntForM,5],aResult[nCntfor,nCntForM,2]})
									@li,103	PSAY nErrMa PICTURE QMT140Pics("aResult[nCntfor,nCntForM,5]",aResult[nCntfor,nCntForM,5],.t.)
								Else
									If GetMv("MV_QCALINC") == '1' // Soma Algebrica
										@li,103 PSAY SuperVal(aResult[nCntFor,nCntForM,5])+SuperVal(aResult[nCntfor,nCntForM,2]);
										PICTURE QMT140Pics("aResult[nCntfor,nCntForM,5]",aResult[nCntfor,nCntForM,5],.f.)
									Else
										@li,103 PSAY Sqrt(SuperVal(aResult[nCntfor,nCntForM,5])^2+SuperVal(aResult[nCntFor,nCntForM,2])^2);
										PICTURE QMT140Pics("aResult[nCntfor,nCntForM,5]",aResult[nCntfor,nCntForM,5],.f.)
									EndIf
								Endif	
							EndIf
						EndIf
	
	 					@li,113 PSAY '|'
	
						If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M"
							@li,114 PSAY 	If(aResult[nCntFor,nCntForM,10] == "A" .and. !Empty(aResult[nCntFor,nCntForM,1]),GetMv("MV_QAPROV"),;
												If(aResult[nCntFor,nCntForM,10] == "R" .and. !Empty(aResult[nCntFor,nCntForM,1]),GetMv("MV_QREPRO"),;
											 	"(*)N/A"))
							@li,131 PSAY "|"												 	 
	 					Else
							@li,131 PSAY "|"												 	 	 					
	 					EndIf
						li++
		                If li > 54
		                   @li,000 PSAY __PrtThinLine()
		                   R030CAB()
		                   li++
		                   MTR030CInc(cText,nCntFor)	// Imprime cabecalho de 
		                                               	// Medicoes com Incerteza
		                   MTR030SubCab(cText,nCntFor)	// Imprime o SubCabecalho
		                   li++
		                EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Imprime a segunda linha com o nominal e, se houver mais medicoes³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						@li,000 PSAY "|"
						@li,005 PSAY aMedicoes[nCntFor,nPosEsp]
						@li,025 PSAY '|'
						
						nCont := 3
	
						If nCont <= aMedicoes[nCntFor,nPosGer,1,1] .and.;
							aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M" // Tipo do padrao ‚ Mensuravel
	
							Do while nCont <= aMedicoes[nCntFor,nPosGer,1,1] .and.;
								aMedicoes[nCntFor,nPosGer,1,3] $ "O,S,M" // Tipo do padrao ‚ Mensuravel
								If nCont > 4
									@li,000 PSAY '|'
									@li,025 PSAY '|'
								EndIf							
								@li,026 PSAY aMedicoes[nCntFor,nPosMed,nCont,nCntForM]
								@li,036 PSAY '|'
								nCont++
								If nCont <= aMedicoes[nCntFor,nPosGer,1,1]
									@li,037 PSAY aMedicoes[nCntFor,nPosMed,nCont,nCntForM]
									nCont++
								EndIf
	
								@li,047 PSAY '|'
								@li,058 PSAY '|'
								@li,069 PSAY '|'
								@li,080 PSAY '|'
								@li,091 PSAY '|'
								@li,102 PSAY '|'
								@li,113 PSAY '|'
	
								If aMedicoes[nCntFor,nPosGer,1,6] == '1' // Se for Confirmacao Metrologica
									If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M"
										cStat := If(!aResult[nCntFor,nCntForM,7] .and. !Empty(aResult[nCntFor,nCntForM,1]),"Ext,","")+;
													If(!aResult[nCntFor,nCntForM,8] .and. !Empty(aResult[nCntFor,nCntForM,1]),"Ace,","")+;
													If(!aResult[nCntFor,nCntForM,9] .and. !Empty(aResult[nCntFor,nCntForM,1]),"Adq","")
									EndIf
									If Subs(cStat,len(cStat),1) == ","
										cStat := Subs(cStat,1,len(cStat)-1)
									EndIf
									If Empty(cStat) 
										cStat := " "
										@li,114 PSAY cStat									
									Else
										@li,118 PSAY Alltrim(cStat)
									Endif
								EndIf
								@li,131 PSAY "|"
								li++
                		        If li > 54 .and. ; 
		                           nCont <= aMedicoes[nCntFor,nPosGer,1,1] .and.;
        	        	           aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M" 
	
								   @li,000 PSAY __PrtThinLine()
                		           R030CAB()
                        		   li++
		                           MTR030CInc(cText,nCntFor)  // Imprime cabecalho de 
        		                                            // Medicoes com Incerteza
                		           MTR030SubCab(cText,nCntFor)  // Imprime o SubCabecalho
		                           li++
        		                EndIf

							EndDo
						Else
							If nCont > 4
								@li,000 PSAY '|'
								@li,025 PSAY '|'
							EndIf
							@li,036 PSAY '|'
							@li,047 PSAY '|'
							@li,058 PSAY '|'
							@li,069 PSAY '|'
							@li,080 PSAY '|'
							@li,091 PSAY '|'
							@li,102 PSAY '|'
							@li,113 PSAY '|' 

							If aMedicoes[nCntFor,nPosGer,1,6] == '1' // Se for Confirmacao Metrologica
								If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M"
									cStat := If(!aResult[nCntFor,nCntForM,7] .and. !Empty(aResult[nCntFor,nCntForM,1]),"Ext,","")+;
												If(!aResult[nCntFor,nCntForM,8] .and. !Empty(aResult[nCntFor,nCntForM,1]),"Ace,","")+;
												If(!aResult[nCntFor,nCntForM,9] .and. !Empty(aResult[nCntFor,nCntForM,1]),"Adq","")
								EndIf
								If Subs(cStat,len(cStat),1) == ","
									cStat := Subs(cStat,1,len(cStat)-1)
								EndIf
								
								If Empty(cStat) 
									cStat := " "		   
									@li,114 PSAY cStat
								Else
									@li,118 PSAY Alltrim(cStat)															
								Endif
							EndIf
							@li,131 PSAY '|'
							li++
							@li,000 PSAY "|"
							@li,131 PSAY "|"							
						EndIf
	
	 				Else  // Medicoes em relacao ao especificado/limite
						If li > 55
							R030CAB()
							li++
							lCab := .t.
						EndIf
						If lCab
							MTR030CEsp(nCntFor,nCntForM) // Imprime cabecalho de Medicoes sem Incerteza
							lCab := .f.
		                    If li > 55
		                       R030CAB()
		                       li++
		                       MTR030CEsp(nCntFor,nCntforM) // Imprime cabecalho de Medicoes sem Incerteza
		                    EndIf
	 					EndIf

						@ li  ,000 PSAY "|"
						@ li  ,004 PSAY aMedicoes[nCntFor,nPosEsc]
						@ li  ,022 PSAY "|"
						@ li  ,023 PSAY aMedicoes[nCntFor,nPosGer,1,11]
						@ li  ,026 PSAY "|"
						@ li  ,027 PSAY aMedicoes[nCntFor,nPosPad]
						@ li  ,045 PSAY "|"
						@ li  ,049 PSAY aMedicoes[nCntFor,nPosGer,1,12]
							
						nLimMin := SuperVal(aMedicoes[nCntFor,nPosEsp]) -;
									  SuperVal(aMedicoes[nCntFor,nPosGer,1,7,2])
						nLimMax := SuperVal(aMedicoes[nCntFor,nPosEsp]) +;
									  SuperVal(aMedicoes[nCntFor,nPosGer,1,7,1])
	
						For nCntFor3 := 1 to aMedicoes[nCntFor,nPosGer,1,1]
							If li > 55
								R030CAB()
								li++
								lCab := .t.
							EndIf
							If lCab
								MTR030CEsp(nCntFor,nCntForM) // Imprime cabecalho de Medicoes sem Incerteza
								lCab := .f.
		                        If li > 55
		                           R030CAB()
		                           li++
		                           MTR030CEsp(nCntFor,nCntforM) // Imprime cabecalho de Medicoes sem Incerteza
		                        EndIf
							EndIf
	
							If nTotCol == 4
								nVezes++
								If ncntForm < 3 .and. nVezes <=Len(aMedicoes)
									nCntForM2 := 1
								Else
									nCntForM2 := 3
								EndIf
							Elseif nTotCol == 2 //nCntForm < 3 .and. nVezes <= Len(aMedicoes)
								nCntforM2 := 1
							Else
								nCntForM2 := nCntForM
							EndIf
	
							If aMedicoes[nCntFor,nPosGer,1,3] $ "O$S$M"
								@ li  ,055 PSAY "|"
								@ li  ,056 PSAY aMedicoes[nCntFor,nPosMed,nCntFor3,nCntForM2]	
								@ li  ,070 PSAY "|"
								@ li  ,071 PSAY R030Dif (SuperVal(aMedicoes[nCntFor,nPosMed,nCntFor3,nCntForM2]),;
																nCntFor,nLimMin,nLimMax);
																PICTURE QMT140Pics("aMedicoes[nCntFor,nPosEsp]",aMedicoes[nCntFor,nPosEsp],.f.)
								@ li  ,082 PSAY "|"
								@ li  ,083 PSAY R030PerDif(SuperVal(aMedicoes[nCntFor,nPosMed,nCntFor3,nCntForM2]),;
																nCntFor,nLimMin,nLimMax);
																PICTURE QMT140Pics("aMedicoes[nCntFor,nPosEsp]",aMedicoes[nCntFor,nPosEsp],.f.)

								If nTotCol > 1
                                    @ li  ,093 PSAY "|"
									@ li  ,094 PSAY aMedicoes[nCntFor,nPosMed,nCntFor3,nCntForM2+1]
                                    @ li  ,106 PSAY "|"
									@ li  ,107 PSAY R030Dif (SuperVal(aMedicoes[nCntFor,nPosMed,nCntFor3,nCntForM2+1]),;
															nCntFor,nLimMin,nLimMax);
															PICTURE QMT140Pics("aMedicoes[nCntFor,nPosEsp]",aMedicoes[nCntFor,nPosEsp],.f.)
									@ li  ,116 PSAY "|"
									@ li  ,117 PSAY R030PerDif(SuperVal(aMedicoes[nCntFor,nPosMed,nCntFor3,nCntForM2+1]),;
															nCntFor,nLimMin,nLimMax);
															PICTURE QMT140Pics("aMedicoes[nCntFor,nPosEsp]",aMedicoes[nCntFor,nPosEsp],.f.)
									@ li  ,130 PSAY "|"															
	
								EndIf
							ElseIf aMedicoes[nCntFor,nPosGer,1,3] == "A" // Tipo do padrao ‚ Atributo
							// Senao ‚ tipo Atributo (imprime Aprovado ou Reprovado)
								@li,056 PSAY If(aMedicoes[nCntFor,nPosMed,1,nCntForM2]=="A",;
												GetMv("MV_QAPROV"),;
											 If(aMedicoes[nCntFor,nPosMed,1,nCntForM2]=="R",;
											   GetMv("MV_QREPRO"),""))
								@li,131 PSAY "|"											   
							EndIf
							li++
	                        @li, 000 PSAY "|"
			 			Next nCntFor3
	
						If (nTotCol == 2 .or. nTotCol == 4) .and. nCntForM ==1
							nCntForM := 2
						ElseIf nTotCol == 4 .and. nCntForM == 3
							nCntForM := 4
						EndIf
	
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime observacao de medicao, se houver  (QA2)                 ³
	 				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		 			nRecQM7 := QM7->(recno())
	
					If nIOBS == 1 // Se impressao de Texto Final == Sim
						QA2->(DbSetOrder(1))
						QM7->(DbSetOrder(1))
						If QM7->(DbSeek(xFilial("QM7")+cMtInstr+cMtRevIns+dtos(dMtData)+cSeql+;
									aMedicoes[nCntFor,nPosEsc]+aMedicoes[nCntFor,nPosGer,1,11]+;
									aMedicoes[nCntFor,nPosPad]+aMedicoes[nCntFor,nPosGer,1,12]))
							cChave := QM7->QM7_CHAVE
						Else
							cChave := CriaVar("QM7_CHAVE")
						EndIf
	
						axTex := {}
						cTextRet := QA_Rectxt(cChave,"QMTA140O",1,TamSX3("QA2_TEXTO")[1],"QA2")
            			Q_MemoArray(cTextRet,axTex,130)
            			
						If Len(axTex) > 0
							li++   
							@ li  ,000 PSAY "|"
							@ li  ,131 PSAY "|"								

					 		li++ 
							@ li  ,000 PSAY "|"
							@ li  ,013 PSAY OemToAnsi(STR0039)    //"Observacao : "
							@ li  ,026 PSAY axTex[1]//QA2->QA2_TEXTO
							@ li  ,131 PSAY "|"

							li++
                        	If aMedicoes[nCntFor,nPosGer,1,6] $ "1|2" // Se houver medicoes com incerteza
                           		If li > 54
									@li,000 PSAY __PrtThinLine()
                              		R030CAB()
                              		li++
                              		If nCntForM == 1 
                                  		MTR030CInc(cText,nCntFor)  // Imprime cabecalho de 
                                        		                   // Medicoes com Incerteza
                              		EndIf
                              		MTR030SubCab(cText,nCntFor)  // Imprime o SubCabecalho
                              		li++
                           		EndIf
							Else
                           		If li > 56
			                       R030CAB()
	    			               li++
	                		       MTR030CEsp(nCntFor,nCntforM) // Imprime cabecalho de Medicoes sem Incerteza
 								EndIf
							EndIf
	               		EndIf

						For nx := 2 To Len(axTex)
							If !empty(axTex[nx]) // para garantir nÆo imprimir uma linha em branco
								@ li  ,000 PSAY "|"
								@ li  ,026 PSAY axTex[nx]//QA2->QA2_TEXTO
								@ li  ,131 PSAY "|"
								li++
  		                            If aMedicoes[nCntFor,nPosGer,1,6] $ "1|2" // Se houver medicoes com incerteza
	                              If li > 55
									@li,000 PSAY __PrtThinLine()
                		                R030CAB()
                        		        li++
	                                If nCntForM == 1 
        		                            MTR030CInc(cText,nCntFor)  // Imprime cabecalho de 
                		                                             // Medicoes com Incerteza
                        		        EndIf
	                                MTR030SubCab(cText,nCntFor)  // Imprime o SubCabecalho
        		                        li++
								  Else
										If li > 55
					                       R030CAB()
	    					               li++
	                				       MTR030CEsp(nCntFor,nCntforM) // Imprime cabecalho de Medicoes sem Incerteza
		 								EndIf
                		              EndIf
                        		   EndIf
							EndIf
						Next nx
					EndIf
	
					QM7->(DbGoto(nRecQM7))
	
					If aMedicoes[nCntFor,nPosGer,1,2] $ "1,4" .or. aMedicoes[nCntFor,nPosGer,1,6] $ "3,4"
						lDuplica := .f.
					EndIf

					If Empty(aMedicoes[nCntFor,nPosMed,1,nCntForM])
					   lImpJust := .T.
					Endif

					If aMedicoes[nCntFor,nPosGer,1,3] == "A"        
						nTotCol := 1
					Endif		               	
	               	nCntFor++
				EndDo	// nCntFor
				Endif
 			Next nCntForM

 			@li,000 PSAY __PrtThinLine()
 			li++
            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quando muda de Escala, imprime rodape e cabecalho           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nCntFor <= Len(aMedicoes)
				If cEscala <> aMedicoes[nCntFor,nPosEsc]
					If aMedicoes[If(nCntFor>1,nCntFor-1,1),nPosGer,1,2] = "3" // Imprime o Rodape da Escala para Tipo de Calibracao = Pressao (3)
						If li > 52
							R030Cab()
							li++
						EndIf
						MTR030REsP(aRelResu,cEscala,If(nCntFor>1,nCntFor-1,1))
					ElseIf aMedicoes[If(nCntFor>1,nCntFor-1,1),nPosGer,1,2] = "9" // Imprime o Rodape da Escala para Tipo de Calibracao = Relogio (9)
						If li > 45
							R030Cab()
							li++
						EndIf
						MTR030REsc(aRelResu,cEscala,If(nCntFor>1,nCntFor-1,1))
					EndIf   					
					lCab      := .T.
					cEscala   := aMedicoes[nCntFor,nPosEsc]
					nTotCol   := r030NumCol(nCntFor)
				EndIf
			Else
				If aMedicoes[If(nCntFor>1,nCntFor-1,1),nPosGer,1,2] = "3"
					// Imprime o Rodape da Escala para Tipo de Calibracao = Pressao (3)
					If li > 52
						R030Cab()
						li++
					EndIf
					MTR030REsP(aRelResu,cEscala,If(nCntFor>1,nCntFor-1,1))
				ElseIf aMedicoes[If(nCntFor>1,nCntFor-1,1),nPosGer,1,2] = "9"
					// Imprime o Rodape da Escala para Tipo de Calibracao = Relogio (9)
					If li > 45
						R030Cab()
						li++
					EndIf
					MTR030REsc(aRelResu,cEscala,If(nCntFor>1,nCntFor-1,1))
				EndIf   					
			EndIf

		EndDo	//nCntFor
		li++

		If lImpJust
			cChave := QM6->QM6_CHAVE
			axTex	:= {}		
			cTextRet:= ""
			dbSelectArea("QA3")
			dbSetOrder(01)
			cTextRet := QA_Rectxt(cChave,"QMTA140L",1,TamSX3("QA3_TEXTO")[1],"QA3")
            Q_MemoArray(cTextRet,axTex,130)
			
			lFirst := .T.
			
			For ni := 1 To Len(axTex)	
				If li > 55
					R030Cab()
					li++
				Endif
					If lFirst
						li++
						@ li  ,000 PSAY "|"	
						@ li  ,005 PSAY OemToAnsi(STR0129) //Justificativa / Medicao			
						@ li  ,131 PSAY "|"							

						li++
						@ li  ,000 PSAY "|"							
						@ li  ,131 PSAY "|"													

						li++
						@ li  ,000 PSAY "|"							
						If li > 55
							R030Cab()
		   	      		Endif 	
						@ li  ,005 PSAY "(*)N/A - "
						lFirst := .F.
					Endif
					If li > 55
						R030Cab()
   	    		  	Endif

					If lFirst
						lFirst := .F.
					Else
						@ li  ,000 PSAY "|"												
					Endif	
				@ li  ,015 PSAY axTex[ni]
					@ li  ,131 PSAY "|"													
					li++
			Next ni

			Endif		

		cTextRet:= ""
		axTex	:= {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver instrumentos utilizados, imprimir    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//|      ESCALA        |        PONTO       |  INSTRUMENTO UTIL.  |  VALIDADE  |  INCERTEZA  |  CERTIFICADO  |      LABORATORIO     |

		lCab := .t.
		For nCntFor := 1 to Len(aMedicoes)
			If !Empty(aMedicoes[nCntFor,nPosIns,1,1])
				cEscala := " "
				cPonto  := " "
				For nCntFor2 := 1 to len(aMedicoes[nCntFor,nPosIns])
					If li > 55
						R030Cab()
						li++
						lCab := .t.
					EndIf
					If lCab
						CabPadInst("I") // Imprime cabecalho de instrumento utilizado
						lCab := .f.
					EndIf
					li++
					@ li  ,000 PSAY "|"
					If aMedicoes[nCntFor,nPosEsc] <> cESCALA
						@ li  ,005 PSAY aMedicoes[nCntFor,nPosEsc]
						cEscala := aMedicoes[nCntFor,nPosEsc]
					EndIf
					@ li  ,021 PSAY "|"
					If aMedicoes[nCntFor,NposPad] <> cPONTO
						@ li  ,022 PSAY aMedicoes[nCntFor,nPosPad]

					cPonto := aMedicoes[nCntFor,nPosPad]
					EndIf
					dData := QM6->QM6_DATA
					// Posiciono na medicao em que o instrumento utilizado foi aprovado e
					// dentro do periodo procurado
					nRecQM6 := QM6->(recno())           
					lImpOk := .T.
					dbSelectArea("QMI")
					dbSetOrder(1)
					If dbSeek(xFilial()+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)+cSeql)
						If !Empty(QMI->QMI_CSEQPR) .and. !Empty(QMI->QMI_REVQPR) .and. !Empty(QMI->QMI_DATQPR) 								
							While QMI->(!Eof()) .and. QMI->QMI_INSTR+QMI->QMI_REVINS+DtoS(QMI->QMI_DATA) ==;
								  QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)
								  If Alltrim(aMedicoes[nCntFor,nPosIns,nCntFor2,1]) == Alltrim(QMI->QMI_INSUT)	
									  //Sequencia como ultimo campo no indice de padroes secundarios	 
									  If QMI->QMI_CSEQ == QM6->QM6_CSEQ
											lImpOk := .T.
											Exit
									  Endif
								  Endif										  
								  dbSelectArea("QMI") 
								  dbSkip()
							Enddo								  								  	
							If lImpOk
							dbSelectArea("QM6")
							dbSetOrder(4)
							If DbSeek(xFilial("QM6")+aMedicoes[nCntFor,nPosIns,nCntFor2,1]+Inverte(QMI->QMI_REVQPR)) 
								nRQM6 := QM6->(RecNo())
								While !QM6->(Eof()) .and. xFilial("QM6")+aMedicoes[nCntFor,nPosIns,nCntFor2,1]+QMI->QMI_REVQPR ==;
									QM6->QM6_FILIAL+QM6_INSTR+QM6_REVINS
									If DtoS(QM6->QM6_DATA) <= DtoS(QMS->QMS_DATQPR) 
										nRQM6 := QM6->(RecNo())    
										Exit
									Endif
									dbSelectArea("QM6")
									QM6->(dbSkip())
								Enddo	
								QM6->(dbGoTo(nRQM6))
								lAchou := .f.
								If QM6->QM6_DATA <= dData .and. dData <= QM6->QM6_VALDAF .and.;
									QM6->QM6_LAUDO == "A" .and. !QM6->(Eof())               
									// Posiciono no QM7 para descobrir o numero do certificado e laboratorio
									// ATENCAO: Prevalecera numero e laboratorio da PRIMEIRA ESCALA
									nRecQM7 := QM7->(Recno())
									QM7->(DbSeek(xFilial("QM7")+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)+QM6->QM6_CSEQ))
									@ li  ,042 PSAY "|"
									@ li  ,043 PSAY aMedicoes[nCntFor,nPosIns,nCntFor2,1]
									@ li  ,064 PSAY "|"
									@ li  ,066 PSAY QM6->QM6_VALDAF
									@ li  ,077 PSAY "|"
									@ li  ,079 PSAY aMedicoes[nCntFor,nPosIns,nCntFor2,3]
									@ li  ,091 PSAY "|"
									@ li  ,093 PSAY QM7->QM7_NRCERT
									@ li  ,107 PSAY "|"
									@ li  ,108 PSAY QM7->QM7_LABOR
									@ li  ,131 PSAY "|"
									lAchou := .t.
									QM7->(DbGoto(nRecQM7))
								Endif
							Else
								@ li  ,042 PSAY "|"+ OemToAnsi(STR0041) //"Medi‡„o exclu¡da"
								@ li  ,131 PSAY "|"
							EndIf
							If !lAchou
								@ li  ,042 PSAY "|"+ OemToAnsi(STR0040)//"Medicao com status diferente de Ativo"
								@ li  ,131 PSAY "|"
							EndIf
							Endif
						Else
							dbSelectArea("QM6")
							dbSetOrder(2)
							If QM6->(DbSeek(xFilial("QM6")+aMedicoes[nCntFor,nPosIns,nCntFor2,1]))
								lAchou := .f.
								Do while aMedicoes[nCntFor,nPosIns,nCntFor2,1] == QM6->QM6_INSTR
									If QM6->QM6_DATA <= dData .and. dData <= QM6->QM6_VALDAF .and.;
										QM6->QM6_LAUDO == "A" .and.	!QM6->(Eof())
        		            	    	        cSeqlQM6 := QM6->QM6_CSEQ
										// Posiciono no QM7 para descobrir o numero do certificado e laboratorio
										// ATENCAO: Prevalecera numero e laboratorio da PRIMEIRA ESCALA
										nRecQM7 := QM7->(Recno())
										QM7->(DbSeek(xFilial("QM7")+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)+cSeqlQM6))
										@ li  ,042 PSAY "|" 
										@ li  ,043 PSAY aMedicoes[nCntFor,nPosIns,nCntFor2,1]
										@ li  ,064 PSAY "|" 
										@ li  ,066 PSAY QM6->QM6_VALDAF
										@ li  ,077 PSAY "|" 								
										@ li  ,079 PSAY  aMedicoes[nCntFor,nPosIns,nCntFor2,3]
										@ li  ,091 PSAY "|" 								
										@ li  ,093 PSAY QM7->QM7_NRCERT
										@ li  ,107 PSAY "|" 								
										@ li  ,108 PSAY QM7->QM7_LABOR
										@ li  ,131 PSAY "|" 
										lAchou := .t.
										QM7->(DbGoto(nRecQM7))
										exit
									EndIf
									QM6->(DbSkip())
								EndDo
								If !lAchou
									@ li  ,042 PSAY "|"
									@ li  ,043 PSAY OemToAnsi(STR0040)//"Medicao com status diferente de Ativo" 
									@ li  ,131 PSAY "|" 
								EndIf
							Else
								@ li  ,042 PSAY "|"
								@ li  ,043 PSAY OemToAnsi(STR0041) //"Medi‡„o exclu¡da"
								@ li  ,131 PSAY "|" 
							EndIf								
						Endif
					Else
						@ li  ,042 PSAY "|"+ OemToAnsi(STR0041) //"Medi‡„o exclu¡da"
						@ li  ,131 PSAY "|"
					Endif
					li++
					@ li  ,000 PSAY __PrtThinLine()
					QM6->(DbGoto(nRecQM6))
 				Next nCntFor2
 			EndIf
		Next nCntFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver incerteza tipo B, imprime.           ³                            	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		r030ITB()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver padroes secundarios, imprimir  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
   ================================================================================================================
   |                                            PADROES SECUNDARIOS                                               |
   ================================================================================================================
   |     ESCALA     |        PONTO       |PADRAO SECUNDARIO| VALIDADE | INCERTEZA | CERTIFICADO  |   LABORATORIO  |
   |--------------------------------------------------------------------------------------------------------------|
   |1234567890123456|1234567890123456 - S|1234567890123456 |99/99/9999|1234567890 | 123456789012 |1234567890123456|
   |--------------------------------------------------------------------------------------------------------------|
*/
 		lCab := .t.

 		For nCntFor := 1 to len(aMedicoes)
			If !empty(aMedicoes[nCntFor,nPosSec,1,1]) //File(cArqQMS)
				cEscala := " "
				cPonto  := " "
				For nCntFor2 := 1 to len(aMedicoes[nCntFor,nPosSec])
					If li > 53
						R030Cab()
						li++
						lCab := .t.
					EndIf
					If lCab
						CabPadInst("S") // Imprime cabecalho de padroes secundarios
						lCab := .f.
						If li > 53
							r030Cab()
							li++
							CabPadInst("S") 
						EndIf
					EndIf
					li++
					@ li  ,000 PSAY "|"
					If aMedicoes[nCntFor,nPosEsc] <> cEscala
						@ li  ,005 PSAY aMedicoes[nCntFor,nPosEsc]
						cEscala := aMedicoes[nCntFor,nPosEsc]
					EndIf
					@ li  ,021 PSAY "|"
					If aMedicoes[nCntFor,nPosPad] <> cPONTO
						@ li  ,022 PSAY aMedicoes[nCntFor,nPosPad]
						cPonto := aMedicoes[nCntFor,nPosPad]
					EndIf
					dData := QM6->QM6_DATA
					// Posiciono na medicao em que o padrao secundario foi aprovado e
					// dentro do periodo procurado
					nRecQM6 := QM6->(recno())
					lImpOk := .F.
					dbSelectArea("QMS")
					dbSetOrder(1)
					If dbSeek(xFilial()+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA))
						If !Empty(QMS->QMS_CSEQPR) .and. !Empty(QMS->QMS_REVQPR) .and. !Empty(QMS_DATQPR)							
							While QMS->(!Eof()) .and. QMS->QMS_INSTR+QMS->QMS_REVINS+DtoS(QMS->QMS_DATA) ==;
								  QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)
								  If Alltrim(aMedicoes[nCntFor,nPosSec,nCntFor2,1]) == Alltrim(QMS->QMS_PADSEC)	
									  //Sequencia como ultimo campo no indice de padroes secundarios	 
									  If QMS->QMS_CSEQ == QM6->QM6_CSEQ
											lImpOk := .T.
											Exit
									  Endif
								  Endif										  
								  dbSelectArea("QMS") 
								  dbSkip()
							Enddo								  								  	
							If lImpOk
							dbSelectArea("QM6")
							dbSetOrder(4)
							If DbSeek(xFilial("QM6")+aMedicoes[nCntFor,nPosSec,nCntFor2,1]+Inverte(QMS->QMS_REVQPR)) //+DtoS(QMS->QMS_DATQPR)+QMS->QMS_CSEQPR
								nRQM6 := QM6->(RecNo())
								While !QM6->(Eof()) .and. xFilial("QM6")+aMedicoes[nCntFor,nPosSec,nCntFor2,1]+QMS->QMS_REVQPR ==;
									QM6->QM6_FILIAL+QM6_INSTR+QM6_REVINS
									If DtoS(QM6->QM6_DATA) <= DtoS(QMS->QMS_DATQPR) 
										nRQM6 := QM6->(RecNo())    
										Exit
									Endif
									dbSelectArea("QM6")
									QM6->(dbSkip())
								Enddo	
								QM6->(dbGoTo(nRQM6))
								lAchou := .f.
								If QM6->QM6_DATA <= dData .and. dData <= QM6->QM6_VALDAF .and.;
									QM6->QM6_LAUDO == "A" .and. !QM6->(Eof())               
									// Posiciono no QM7 para descobrir o numero do certificado e laboratorio
									// ATENCAO: Prevalecera numero e laboratorio da PRIMEIRA ESCALA
									nRecQM7 := QM7->(Recno())
									QM7->(DbSeek(xFilial("QM7")+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)+QM6->QM6_CSEQ))
									@ li  ,042 PSAY "|"
									@ li  ,043 PSAY aMedicoes[nCntFor,nPosSec,nCntFor2,1]
									@ li  ,064 PSAY "|"
									@ li  ,066 PSAY QM6->QM6_VALDAF
									@ li  ,077 PSAY "|"
									@ li  ,079 PSAY aMedicoes[nCntFor,nPosSec,nCntFor2,3]
									@ li  ,091 PSAY "|"
									@ li  ,093 PSAY QM7->QM7_NRCERT
									@ li  ,107 PSAY "|"
									@ li  ,108 PSAY QM7->QM7_LABOR
									@ li  ,131 PSAY "|"
									lAchou := .t.
									QM7->(DbGoto(nRecQM7))
								Endif
							Else
								@ li  ,042 PSAY "|"+ OemToAnsi(STR0041) //"Medi‡„o exclu¡da"
								@ li  ,131 PSAY "|"
							EndIf
							If !lAchou
								@ li  ,042 PSAY "|"+ OemToAnsi(STR0040)//"Medicao com status diferente de Ativo"
								@ li  ,131 PSAY "|"
							EndIf
							Endif
						Else
							dbSelectArea("QM6")
							dbSetOrder(2)
							If DbSeek(xFilial("QM6")+aMedicoes[nCntFor,nPosSec,nCntFor2,1])
								lAchou := .f.
								Do while aMedicoes[nCntFor,nPosSec,nCntFor2,1] == QM6->QM6_INSTR
									If QM6->QM6_DATA <= dData .and. dData <= QM6->QM6_VALDAF .and.;
										QM6->QM6_LAUDO == "A" .and.	!QM6->(Eof())               
										cSeqlQM6 := QM6->QM6_CSEQ
										// Posiciono no QM7 para descobrir o numero do certificado e laboratorio
										// ATENCAO: Prevalecera numero e laboratorio da PRIMEIRA ESCALA
										nRecQM7 := QM7->(Recno())	
										QM7->(DbSeek(xFilial("QM7")+QM6->QM6_INSTR+QM6->QM6_REVINS+DtoS(QM6->QM6_DATA)+cSeqlQM6))
										@ li  ,042 PSAY "|"
										@ li  ,043 PSAY aMedicoes[nCntFor,nPosSec,nCntFor2,1]
										@ li  ,064 PSAY "|"
										@ li  ,066 PSAY QM6->QM6_VALDAF
										@ li  ,077 PSAY "|"
										@ li  ,079 PSAY aMedicoes[nCntFor,nPosSec,nCntFor2,3]
										@ li  ,091 PSAY "|"
										@ li  ,093 PSAY QM7->QM7_NRCERT
										@ li  ,107 PSAY "|"
										@ li  ,108 PSAY QM7->QM7_LABOR
										@ li  ,131 PSAY "|"
										lAchou := .t.
										QM7->(DbGoto(nRecQM7))
										exit
									EndIf
									QM6->(DbSkip())
								EndDo
								If !lAchou
									@ li  ,042 PSAY "|"+ OemToAnsi(STR0040)//"Medicao com status diferente de Ativo"
									@ li  ,131 PSAY "|"
								EndIf
							Else
								@ li  ,042 PSAY "|"+ OemToAnsi(STR0041) //"Medi‡„o exclu¡da"
								@ li  ,131 PSAY "|"
							EndIf
						Endif						
					Else
						@ li  ,042 PSAY "|"+ OemToAnsi(STR0041) //"Medi‡„o exclu¡da"
						@ li  ,131 PSAY "|"
					Endif								
					li++
					@ li, 000 PSAY __PrtThinLine()
					QM6->(DbGoto(nRecQM6))
				Next nCntFor2
 			EndIf
		Next nCntFor

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver nao conformidades, imprimir   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
   ================================================================================================================
   |                                             NAO CONFORMIDADES                                                |
   ================================================================================================================
   |     ESCALA     |        PONTO       |   N/C    |                DESCRICAO                 |   CLASSIFICACAO  |
   |--------------------------------------------------------------------------------------------------------------|
   |1234567890123456|1234567890123456 - S| 12345678 | 1234567890123456789012345678901234567890 |  Muito GRave     |
   |--------------------------------------------------------------------------------------------------------------|
*/
		lCab := .t.
 		For nCntFor := 1 to Len(aMedicoes)
 			If !empty(aMedicoes[nCntFor,nPosNco,1,1])				// File(cArqQMJ)
 				If nINCs == 1 // Se impressao de Nao Conformidades == Sim
					cEscala := " "
 					cPonto  := " "
 					For nCntFor2 := 1 to Len(aMedicoes[nCntFor,nPosNco])
						If li > 55
							R030Cab()
							li++
							lCab := .t.
						EndIf
						If lCab
							CabNaoConf() // Imprime cabecalho de Nao Conformidade
							lCab := .f.
							If li > 55
								R030Cab()
								li++
								lCab := .t.
							EndIf
						EndIf
						li++
						@ li  ,000 PSAY "|"
						If aMedicoes[nCntFor,nPosEsc] <> cESCALA
							@ li  ,005 PSAY aMedicoes[nCntFor,nPosEsc]
							cEscala := aMedicoes[nCntFor,nPosEsc]
						EndIf
						@ li  ,021 PSAY "|"
						If aMedicoes[nCntFor,nPosPad] <> cPONTO
							@ li  ,022 PSAY aMedicoes[nCntFor,NposPad]
							cPonto := aMedicoes[nCntFor,nPosPad]
						EndIf
//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//|   ESCALA           |       PONTO        |   N/C    |                DESCRICAO				  |           CLASSIFICACAO          |

						@ li  ,042 PSAY "|"
						@ li  ,044 PSAY aMedicoes[nCntFor,nPosNco,nCntFor2,1]
						@ li  ,053 PSAY "|"
						@ li  ,055 PSAY aMedicoes[nCntFor,nPosNco,nCntFor2,2]
						@ li  ,096 PSAY "|"
						@ li  ,099 PSAY If(aMedicoes[nCntFor,nPosNco,nCntFor2,3] == "M",OemToAnsi(STR0042),; //"Muito Grave"
											 If(aMedicoes[nCntFor,nPosNco,nCntFor2,3] == "G",OemToAnsi(STR0043), OemToAnsi(STR0044))) //"Grave","Nao Grave"
						@ li  ,131 PSAY "|"

						li++
                        @ li  ,000 PSAY __PrtThinLine() 
					Next nCntFor2
				EndIf
	 		EndIf
		Next nCntFor

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Confirmacao Metrologica por Escala (se houver)       	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		R030CM()
		If nIResum == 1 //Imprime Resumo de Valores
			
			nCntFor2 := 1
			aResult := {}
			
			Do while nCntFor2<= Len(aMedicoes)
				aRetorno := a140Calc(nCntFor2,.t.)
				If Len(aRetorno) == 2
					Aadd( aResult, aRetorno[2] )
				Elseif Len(aRetorno) == 4
					Aadd( aResult, aRetorno[2] )
					Aadd( aResult, aRetorno[4] )
				Else
					Aadd( aResult, aRetorno[1] )
				EndIf
				nCntFor2++
			EndDo
			If Len(aResult) > 0
				nIncerMed	:= QmtNum(aResult[1,5])
				nIncerTot	:= QmtNum(aResult[1,2])
				nErrTots	:= QmtNum(aResult[1,6])
				For nCntFor := 1 to Len(aResult)
					nIncerMed := If(QmtNum(aResult[nCntFor,5]) > nIncerMed, QmtNum(aResult[nCntFor,5]), nIncerMed)
					nIncerTot := If(QmtNum(aResult[nCntFor,2]) > nIncerTot, QmtNum(aResult[nCntFor,2]), nIncerTot)
					nErrTots  := If(QmtNum(aResult[nCntFor,6]) > nErrTots, QmtNum(aResult[nCntFor,6]), nErrTots)
				Next
				
				// Procura valor nominal com maior numero de casas decimais na escala
				nNumDec := 0
				For nCntFor := 1 to len(aMedicoes)
					If QA_NumDec(aMedicoes[nCntFor,nPosEsp]) >= nNumDec
						nNumDec := QA_NumDec(aMedicoes[nCntFor,nPosEsp])
						cValor := aMedicoes[nCntFor,nPosEsp]
					EndIf
				Next nCntFor
				
				li++
				
				If li >= 55
					Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				Endif
				
				@ li  ,000 PSAY __PrtFatLine()
				li++
				@ li,000 PSAY __PrtCenter(Upper(STR0142))
				li++
				@ li  ,000 PSAY __PrtFatLine()
				li++
				@ li  ,001 PSAY __PrtThinLine()
				li++
				If li >= 55
					Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				Endif
				@ li,0 PSAY "|"
				@ li,4 PSAY STR0140		//"Maior Incerteza do Instrumento"
				@ li,57 PSAY STR0065	//"Erro Sistematico"
				@ li,109 PSAY STR0141	//"Erro Maximo/Total"
				@ li,131 PSAY "|"
				li++
				@ li  ,001 PSAY __PrtThinLine()
				li++
				If li >= 55
					Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				Endif
				@ li,0 PSAY "|"
				@ li,10 PSAY nIncerMed PICTURE QMT140Pics("nIncerMed",cValor,.t.)
				@ li,59 PSAY nIncerTot PICTURE QMT140Pics("nIncerTot",cValor,.t.)
				@ li,111 PSAY nErrTots PICTURE QMT140Pics("nErrTots",cValor,.t.)
				@ li,131 PSAY "|"
				li++
				@ li  ,001 PSAY __PrtThinLine()
			EndIf
		Endif

		If nIItb == 1
			li+= 2
			If li > 53
				r030Cab()
				li+= 2
			EndIf
			nCnt := ( 120 - Len(STR0143)) / 2 //Legenda Incerteza do Tipo B
			@ li,4 PSAY repl("=",112)
			li++
			If li > 53
				r030Cab()
				li+= 2
			EndIf
			@ li,4 PSAY "|"
			@ li,nCnt PSAY Upper(STR0143) //"LEGENDA INCERTEZA DO TIPO 'B'"
			@ li,115 PSAY "|"
			li++
			If li > 53
				r030Cab()
				li+= 2
			EndIf
				
			@ li,4 PSAY repl("=",112)

			li++
			If li > 53
				r030Cab()
				li+= 2
			EndIf

			@ li,4 PSAY "|"
			@ li,6 PSAY STR0144 //"*=Infinito ou >100"
			@ li,115 PSAY "|"
		
			aItbBox := RetSx3Box( Posicione("SX3", 2, "QMV_DISTR", "X3CBox()" ),,, 1 )
		
			For nx := 1 To Len(aItbBox)
				If !Empty(aItbBox[nx][1])
					li++            
					If li > 53
						r030Cab()
						li+= 2
					EndIf
					@ li,4 PSAY "|"
					@ li,6 PSAY Alltrim(aItbBox[nx][1])
					@ li,115 PSAY "|"
				Endif
			Next nx	
			li++
			@ li,4 PSAY  Repl("=",112)
			li++	
		Endif		
		li+=2

		If nILaudo == 1 // Se impressao do laudo == sim
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime laudo (e justificativa, se houver)                   	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If li > 55
				R030Cab()
 				li+=2
 			EndIf

			@	li  ,004 PSAY OemToAnsi(STR0045)+" : " +; // "LAUDO "
														 If(QM6->QM6_LAUDO=="A",GetMv("MV_QAPROV"),;
														 If(QM6->QM6_LAUDO=="R",GetMv("MV_QREPRO"),;
																						GetMv("MV_QAPCON")))
			li++
			cChave := QM6->QM6_CHAVE
			QA3->(DbSetOrder(1))
			
			cTextRet := ""
			axTex	:= {}
					
			cTextRet := QA_Rectxt(cChave,"QMTA140M",1,TamSX3("QA3_TEXTO")[1],"QA3")
            Q_MemoArray(cTextRet,axTex,130)            

			For ni := 1 To Len(axTex)
				If li > 55
					Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
					li+=2
				EndIf

				@ li  ,004 PSAY axTex[ni]
				li++
			Next ni	

			li++
 		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Condicao de Recebimento (se houver)                  	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If GetMv("MV_QFREQAF") == "S"
			If !empty(QM6->QM6_COND)
				@ li  ,004 PSAY OemToAnsi(STR0046)+" : " +; //"CONDICAO DE RECEBIMENTO "
									If(QM6->QM6_COND =="A",OemToAnsi(STR0047),;  //"AVARIA"
									If(QM6->QM6_COND =="C",OemToAnsi(STR0048),;  //"CONFORME"
																  OemToAnsi(STR0049)))  //"NAO CONFORME"
				li+=2
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver inf.compl.do instr.(de acordo com param. de impressao)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nInfCIn == 1 // Se impressao da inform.compl.instr. == 1
			If li > 55
				R030Cab()
				li+=2
			EndIf

			QA2->(DbSetOrder(1))
			cChave := QM2->QM2_CHAVE
			If QA2->(DbSeek(xFilial("QA2")+"QMTA010I"+cChave))
				@ li  ,004 PSAY OemToAnsi(STR0019)+" :" // "Informacoes Complementares do Instrumento"
				li++
				axTex := {}
				cTextRet := QA_Rectxt(cChave,"QMTA010I",1,TamSX3("QA2_TEXTO")[1],"QA2")
   				Q_MemoArray(cTextRet,axTex,130)
				
				For nx := 1 To Len(axTex)
					@ li  ,004 PSAY axTex[nx] //QA2->QA2_TEXTO
					li++
				Next nx				
			EndIf
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver inf.compl.  (de acordo com parametro de impressao)    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nInfCom == 1 // Se impressao de Inf.Compl. == Sim
			If li > 55
				R030Cab()
				li+=2
			EndIf
			cArqTxt := "R303"+cEmpAnt+cFilAnt+".TXT"
			R030IMPTXT(cArqTxt,1)
			li++
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver texto final (de acordo com parametro de impressao)    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nTxtFin == 1 // Se impressao de Texto Final == Sim
			If li > 55
				R030Cab()
				li+=2
			EndIf
			cArqTxt := "R302"+cEmpAnt+cFilAnt+".TXT"
			R030IMPTXT(cArqTxt,1)
			li++
 		EndIf

		lImpCabec := .T.

 		dbSelectArea( "QM6" )

		// Imrprime Analise das ultimas pecas produzidas se
 		// parametro 18 = "S" e Laudo for reprovado.

		If mv_par18 == 1 .and. QM6->QM6_LAUDO == "R"
			m_pag := 1
			li := 100
			R030AnaUP()
		EndIf
	EndIf

		li++
		li++
		If !Empty(QM2->QM2_CLIE)
			dbSelectArea("SM0")
			dbSeek(cEmpAnt)
			
			If li > 55
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				li+=2
			EndIf

			@ li,004 PSAY OemToAnsi(STR0059)+".........: " + ;	// Laboratorio: 
			Alltrim(SM0->M0_NOME) + " - " + SM0->M0_NOMECOM
			li++

			If li > 55
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				li+=2
			EndIf

			@ li,004 PSAY OemToAnsi(STR0133) + ;// Endereco							
			Alltrim(SM0->M0_ENDENT) + " - " + SM0->M0_CIDENT
			li++

			If li > 55
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				li+=2
			EndIf

			@ li,004 PSAY OemToAnsi(STR0134) + ;// Cep
			Alltrim(SM0->M0_CEPENT) + " - " + SM0->M0_BAIRENT
			li++

			If li > 55
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
				li+=2
			EndIf

			@ li,004 PSAY OemToAnsi(STR0135) + ;// Telefone
			Alltrim(SM0->M0_TEL) 
			li++

		Endif
  	li := 60	
	DbSelectArea("QM6")
	dbSetOrder(1)
	dbSkip()
EndDo

Roda( cbCont, cbTxt, Tamanho )

Set Device To Screen
Set Filter To

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
End
MS_FLUSH()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR030Carg³ Autor ³ Wanderley Goncalves Jr³ Data ³ 12.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega aMedicoes, para calculo dos resultados para impres-³±±
±±³          ³ sao.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR030Carg()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuri Seto ³ 20/06/00 ³ Alteracoes para calibrar Tipo de Calibracao Re- ³±±
±±³          ³          ³ logio.                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MTR030Carg(aRelResu,aImpCer)
Local 	nRelResu
Local	aArea := GetArea()
Local   nCntFor2 := 1
Private nPosGer	:= 0 //Posicao na String para referencia no dbTree
Private Inclui		:= .F.
Private cEscala	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRelResu : contem os dados para impressao dos Parametros       ³
//³            de Analise para o Tipo de Calibracao Relogio e      ³
//³            Histerese para Pressao                              ³
//³ Conteudo :                                                     ³
//³ Posicao 													   ³
//³ 1		- Escala                                               ³
//³ 2		- Maior Erro de Indicacao Crescente                    ³
//³ 3		- Menor Erro de Indicacao Crescente                    ³
//³ 4		- Maior Erro de Indicacao Total (Crescente/Decrescente)³
//³ 5		- Menor Erro de Indicacao Total (Crescente/Decrescente)³
//³ 6		- Desvio Maximo no sentido Crescente                   ³
//³ 7		- Desvio Total (Crescente/Decrescente)                 ³
//³ 8		- Erro de Retorno                                      ³
//³ 9		- Diferenca do mesmo ponto Crescente e Decrescente     ³
//³ 10		- Histerese											   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lCertif
	cMtInstr	:= QM6->QM6_INSTR
	cMtRevIns	:= QM6->QM6_REVINS
	dMtData		:= QM6->QM6_DATA
	cMtResp		:= QM6->QM6_RESP
	cMtTotHr	:= QM6->QM6_TOTHOR
	cMtRepRepr	:= QM6->QM6_REPEPR
Else 
	cMtInstr	:= aImpCer[1][1]
	cMtRevIns	:= aImpCer[1][4]
	dMtData		:= aImpCer[1][2]
	cMtResp		:= aImpCer[1][3]
	cMtTotHr	:= aImpCer[1][5]
	cMtRepRepr	:= aImpCer[1][6]
Endif	

dbSelectArea("QM6")

aMedicoes := {}

cSeql := QM6->QM6_CSEQ //Seguencia de calibracao em uma mesma data

a140CarMed()

aResult := {}
nRelResu := 0

For nCntFor2 := 1 To len(aMedicoes)
	aadd(aResult, a140Calc(nCntFor2,.t.))
	If aMedicoes[nCntFor2,nPosGer,1,2] $ "3,9"
		If aMedicoes[nCntFor2,nPosGer,1,3] <> "A"	 
			If cEscala <> aMedicoes[nCntFor2,nPosEsc]	
		  		cEscala   	:= aMedicoes[nCntFor2,nPosEsc]	
				AADD(aRelResu,{cEscala,;					//  1- Escala
		 				QmtNum(aResult[nCntFor2,2,11]),;	//  2- Maior Erro de Indicacao Crescente
						QmtNum(aResult[nCntFor2,2,11]),;	//  3- Menor Erro de Indicacao Crescente
						QmtNum(aResult[nCntFor2,2,11]),;	//  4- Maior Erro de Indicacao Total (Crescente/Decrescente)
						QmtNum(aResult[nCntFor2,2,11]),;	//  5- Menor Erro de Indicacao Total (Crescente/Decrescente)
						QmtNum(aResult[nCntFor2,2,11]),;	//  6- Desvio Maximo no sentido Crescente
						QmtNum(aResult[nCntFor2,2,11]),;	//  7- Desvio Total (Crescente/Decrescente)
						0,;									//  8- Erro de Retorno
						QmtNum(aResult[nCntFor2,2,11]),;	//  9- Diferenca do mesmo ponto Crescente e Decrescente                                            		
						0})									// 10- Histerese                                           		
				nRelResu++
			Else
				aRelResu[nRelResu,2] := Iif(QmtNum(aResult[nCntFor2,2,11]) > aRelResu[nRelResu,2], QmtNum(aResult[nCntFor2,2,11]), aRelResu[nRelResu,2])
				aRelResu[nRelResu,3] := Iif(QmtNum(aResult[nCntFor2,2,11]) < aRelResu[nRelResu,3], QmtNum(aResult[nCntFor2,2,11]), aRelResu[nRelResu,3])
				aRelResu[nRelResu,6] := ABS(aRelResu[nRelResu,2]-aRelResu[nRelResu,3])
				aRelResu[nRelResu,4] := Iif(QmtNum(aResult[nCntFor2,2,11]) > aRelResu[nRelResu,4], QmtNum(aResult[nCntFor2,2,11]), aRelResu[nRelResu,4])
				aRelResu[nRelResu,5] := Iif(QmtNum(aResult[nCntFor2,2,11]) < aRelResu[nRelResu,5], QmtNum(aResult[nCntFor2,2,11]), aRelResu[nRelResu,5])
				aRelResu[nRelResu,7] := ABS(aRelResu[nRelResu,4]-aRelResu[nRelResu,5])
				aRelResu[nRelResu,9] := QmtNum(aResult[nCntFor2,2,11])
			EndIf			
			aRelResu[nRelResu, 4] := Iif(QmtNum(aResult[nCntFor2,4,11]) > aRelResu[nRelResu,4], QmtNum(aResult[nCntFor2,4,11]), aRelResu[nRelResu,4])
			aRelResu[nRelResu, 5] := Iif(QmtNum(aResult[nCntFor2,4,11]) < aRelResu[nRelResu,5], QmtNum(aResult[nCntFor2,4,11]), aRelResu[nRelResu,5])
			aRelResu[nRelResu, 6] := ABS(aRelResu[nRelResu,4] - aRelResu[nRelResu,5])	
			aRelResu[nRelResu, 9] := ABS(aRelResu[nRelResu,9] - QmtNum(aResult[nCntFor2,4,11]))
			If aRelResu[nRelResu,9] > aRelResu[nRelResu,8]
				aRelResu[nRelResu, 8] := aRelResu[nRelResu,9]
				If aMedicoes[nCntFor2,nPosGer,1,2] == "3"
					aRelResu[nRelResu,10] := (aRelResu[nRelResu,8]/QmtNum(aResult[nCntFor2,4,12])) * 100
				Else			
					aRelResu[nRelResu,10] := aRelResu[nRelResu,8] / Sqrt(12)
				EndIf			
			EndIf	
		Else
			If cEscala <> aMedicoes[nCntFor2,nPosEsc]	
		  		cEscala   	:= aMedicoes[nCntFor2,nPosEsc]	
				AADD(aRelResu,{cEscala,;					//  1- Escala
		 				QmtNum(aResult[nCntFor2,1,11]),;	//  2- Maior Erro de Indicacao Crescente
						QmtNum(aResult[nCntFor2,1,11]),;	//  3- Menor Erro de Indicacao Crescente
						QmtNum(aResult[nCntFor2,1,11]),;	//  4- Maior Erro de Indicacao Total (Crescente/Decrescente)
						QmtNum(aResult[nCntFor2,1,11]),;	//  5- Menor Erro de Indicacao Total (Crescente/Decrescente)
						QmtNum(aResult[nCntFor2,1,11]),;	//  6- Desvio Maximo no sentido Crescente
						QmtNum(aResult[nCntFor2,1,11]),;	//  7- Desvio Total (Crescente/Decrescente)
						0,;									//  8- Erro de Retorno
						QmtNum(aResult[nCntFor2,1,11]),;	//  9- Diferenca do mesmo ponto Crescente e Decrescente                                            		
						0})									// 10- Histerese                                           		
				nRelResu++
			Else
				aRelResu[nRelResu,2] := Iif(QmtNum(aResult[nCntFor2,1,11]) > aRelResu[nRelResu,2], QmtNum(aResult[nCntFor2,1,11]), aRelResu[nRelResu,2])
				aRelResu[nRelResu,3] := Iif(QmtNum(aResult[nCntFor2,1,11]) < aRelResu[nRelResu,3], QmtNum(aResult[nCntFor2,1,11]), aRelResu[nRelResu,3])
				aRelResu[nRelResu,6] := ABS(aRelResu[nRelResu,2]-aRelResu[nRelResu,3])
				aRelResu[nRelResu,4] := Iif(QmtNum(aResult[nCntFor2,1,11]) > aRelResu[nRelResu,4], QmtNum(aResult[nCntFor2,1,11]), aRelResu[nRelResu,4])
				aRelResu[nRelResu,5] := Iif(QmtNum(aResult[nCntFor2,1,11]) < aRelResu[nRelResu,5], QmtNum(aResult[nCntFor2,1,11]), aRelResu[nRelResu,5])
				aRelResu[nRelResu,7] := ABS(aRelResu[nRelResu,4]-aRelResu[nRelResu,5])
				aRelResu[nRelResu,9] := QmtNum(aResult[nCntFor2,1,11])
			EndIf			
			aRelResu[nRelResu, 4] := Iif(QmtNum(aResult[nCntFor2,1,11]) > aRelResu[nRelResu,4], QmtNum(aResult[nCntFor2,1,11]), aRelResu[nRelResu,4])
			aRelResu[nRelResu, 5] := Iif(QmtNum(aResult[nCntFor2,1,11]) < aRelResu[nRelResu,5], QmtNum(aResult[nCntFor2,1,11]), aRelResu[nRelResu,5])
			aRelResu[nRelResu, 6] := ABS(aRelResu[nRelResu,4] - aRelResu[nRelResu,5])	
			aRelResu[nRelResu, 9] := ABS(aRelResu[nRelResu,9] - QmtNum(aResult[nCntFor2,1,11]))
			If aRelResu[nRelResu,9] > aRelResu[nRelResu,8]
				aRelResu[nRelResu, 8] := aRelResu[nRelResu,9]
				If aMedicoes[nCntFor2,nPosGer,1,2] == "3"
					aRelResu[nRelResu,10] := (aRelResu[nRelResu,8]/QmtNum(aResult[nCntFor2,1,12])) * 100
				Else			
					aRelResu[nRelResu,10] := aRelResu[nRelResu,8] / Sqrt(12)
				EndIf			
			EndIf	
		EndIf
	Endif
Next nCntFor2
RestArea(aArea)
Return(aResult)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030IMPTXT³ Autor ³ Wanderley Goncalves Jr³ Data ³ 14.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Texto do arquivo TXT passado como parametro        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030IMPTXT(cArq,nTipo)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cArq := Arquivo a ser impresso                             ³±±
±±³          ³ nTipo:= Tipo de cabecalho (1-Certificado, 2-Analise de pp) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030IMPTXT(cArq,nTipo)

Local Tamanho := " "
Local nCntFor
Local nCount
Local cAcentos  := "€ú‡úúú…ú†úƒú úúˆú‚ú¡ú“ú”ú¢ú™ú£ú"
Local cAcSubst  := "C,c,A~A'a`a~a^a'E'e^e'i'o^o~o'O~U'"

If File(cArq)
	cTexto:=MemoRead(cArq)
	For nCntFor := 1 To MLCOUNT(cTexto,130)
		aLinha := MEMOLINE(cTexto,130,nCntFor)
		cImpTxt   := ""
		cImpLinha := ""
		For nCount := 1 To Len(aLinha)
			cImpTxt := Substr(aLinha,nCount,1)
			If AT(cImpTxt,cAcentos)>0
				cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
			EndIf
			cImpLinha := cImpLinha+cImpTxt
		Next nCount
		@Li,04 PSAY cImpLinha
		Li++
		If li > 55
			If nTipo == 1
				Cabec( Titulo+"No. "+cCert, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
			Else
			   Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
			EndIf

		EndIf
	Next nCntFor
EndIf

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030CAB   ³ Autor ³ Wanderley Goncalves Jr³ Data ³ 15.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho na quebra de pagina                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030CAB()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030CAB()

Local Tamanho := " "

Cabec( Titulo+"No. "+cCert, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
@ li,004 PSAY OemToAnsi( STR0127 ) + ;//"Familia............: "
Trim(QM1->QM1_TIPO) + " - " + QM6->QM6_REVTIP + " - " + QM1->QM1_DESCR

li++
@ li,004 PSAY OemToAnsi( STR0128 )	+ ;//"Procedimento.......: "
Iif(!lProcs,Trim(QM1->QM1_PROCAL),Trim(QA5->QA5_NORMA) + "-" + QA5->QA5_REVPRO + " - " + QA5->QA5_DESCRI)

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CabPadInst³ Autor ³ Wanderley Goncalves Jr³ Data ³ 15.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho de Instrumentos ou Padrao Sec.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CabPadInst(cpoc)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cOpc == "I" - Instrumento Utilizado / "P" - Padrao Secund. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CabPadInst(cOpc)

li++
@li,00 PSAY __PrtFatLine()

li++
If cOpc == "I"
	@ li  ,00 PSAY __PrtCenter(OemToAnsi(STR0050)) //"INSTRUMENTOS UTILIZADOS"
Else
	@ li  ,00 PSAY __PrtCenter(OemToAnsi(STR0051)) //"PADRAO SECUNDARIO"
EndIf
li++
@li,00 PSAY __PrtFatLine()

li++                              
@li,00 PSAY __PrtThinLine()
li++
//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//|      ESCALA        |        PONTO       |  INSTRUMENTO UTIL.  |  VALIDADE  |  INCERTEZA  |  CERTIFICADO  |      LABORATORIO     |

@ li  ,000 PSAY "|    "		+ OemToAnsi(STR0052) //"Escala"
@ li  ,021 PSAY "|        "	+ OemToAnsi(STR0053) //"Ponto"
If cOpc == "I"
	@ li  ,042 PSAY "|  "	+ OemToAnsi(STR0054)  //"Instrumento Util."
Else
	@ li  ,042 PSAY "|  "	+ OemToAnsi(STR0055) //"Padrao Secundario"
EndIf
@ li  ,064 PSAY "|  " 		+ OemToAnsi(STR0056) //"Validade"
@ li  ,077 PSAY "|  " 		+ OemToAnsi(STR0057) //"Incerteza"
@ li  ,091 PSAY "|  " 		+ OemToAnsi(STR0058) //"Certificado"
@ li  ,107 PSAY "|      "	+ OemToAnsi(STR0059) //"Laboratorio"
@ li  ,131 PSAY "|"
li++
@li,00 PSAY __PrtThinLine()

Return(Nil)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CabNaoConf³ Autor ³ Wanderley Goncalves Jr³ Data ³ 18.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho de Nao Conformidades                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CabNaoConf()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CabNaoConf()

//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//|   ESCALA           |       PONTO        |   N/C    |                DESCRICAO				  |           CLASSIFICACAO          |
li++
@ li  ,000 PSAY __PrtFatLine() 
li++
@ li  ,000 PSAY __PrtCenter(OemToAnsi(STR0060))  //"NAO CONFORMIDADES"
li++
@ li  ,000 PSAY __PrtFatLine() 
li++
@ li  ,000 PSAY "|   " 	    + OemToAnsi(STR0052)  //"Escala"
@ li  ,021 PSAY "|       " 	    + OemToAnsi(STR0053)  //"Ponto"
@ li  ,042 PSAY "|   "	 	    + OemToAnsi(STR0061)  //"N/C"
@ li  ,053 PSAY "|" +Space(16)	+ OemToAnsi(STR0062)  //"Descricao"
@ li  ,096 PSAY "|           "	+ OemToAnsi(STR0063)  //"Classificacao"
@ li  ,131 PSAY "|"
li++

@ li  ,000 PSAY __PrtThinLine()

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CabConfMet³ Autor ³ Wanderley Goncalves Jr³ Data ³ 19.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho de Confirmacao Metrologica por Escala    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CabConfMet()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CabConfMet()

li++
@li,000 PSAY __PrtFatLine()
li++

@li,000 PSAY __PrtCenter(OemToAnsi(STR0064))
li++

@li,000 PSAY __PrtFatLine()
li++

@li,000 PSAY __PrtThinLine()
li++                      

//          1         2         3         4         5         6        7          8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//       ESCALA                 INCERTEZA          ERRO SISTEMATICO         EXATIDAO           ADEQUACAO          ACEITABILIDADE
//       MMMMMMMMMMMMMMMM  |  9999999999999   |                        |                 |                   |                       |
@ li  ,00 PSAY "|"
@ li  ,007 PSAY Upper(OemToAnsi(STR0052))  //"Escala"
@ li  ,25 PSAY "|"
@ li  ,030 PSAY Upper(OemToAnsi(STR0057))  //"Incerteza"
@ li  ,44 PSAY "|"
@ li  ,049 PSAY Upper(OemToAnsi(STR0065))  //"Erro Sistematico"
@ li  ,69 PSAY "|"
@ li  ,074 PSAY Upper(OemToAnsi(STR0066))  //"Exatidao"
@ li  ,87 PSAY "|"
@ li  ,093 PSAY Upper(OemToAnsi(STR0067))  //"Adequacao"
@ li  ,107 PSAY "|"
@ li  ,112 PSAY Upper(OemToAnsi(STR0068))  //"Aceitabilidade"
@ li  ,131 PSAY "|"
li++
@li,000 PSAY __PrtThinLine()

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030CM()  ³ Autor ³ Wanderley Goncalves Jr³ Data ³ 19.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Resultado Confirma‡ao Metrologica por Escala       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030CM()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030CM()

/*
   ================================================================================================================
   |                                           CONFIRMACAO METROLOGICA                                            |
   ================================================================================================================
   |       ESCALA       |   INCERTEZA    | ERRO SISTEMATICO |    EXATIDAO     |    ADEQUACAO    | ACEITABILIDADE  |
   |--------------------------------------------------------------------------------------------------------------|
   |  1234567890123456  |   1234567890   |   1234567890     |  Rejeitado      |   Rejeitado     |  Rejeitado      |
   |--------------------------------------------------------------------------------------------------------------|
*/

Local nCntFor := 0, nCntFor2 := 0        // Contadores
Local nIncTotEsc := 0
Local nErrSisEsc := 0
Local lExatEsc := .t.
Local lAceiEsc := .t.
Local lAdeqEsc := .t.
Local nNumDec := 0    // Numero de casas para exibir os valores.
Local cValor          // Nominal com maior numero de casas decimais na Escala
Local aResEsc := {}
Local aRetorno := {}

If !lCertif
	M->QM6_INSTR := QM6->QM6_INSTR
	M->QM6_REVINS := QM6->QM6_REVINS
	M->QM6_DATA  := QM6->QM6_DATA
	M->QM6_REPEPR := QM6->QM6_REPEPR
Endif	

nCntFor2 := 1
cEscala := aMedicoes[nCntFor2,nPosEsc]
lCab := .t.

Do while nCntFor2 <= Len(aMedicoes)
	If aMedicoes[nCntFor2,nPosGer,1,6] == "1"
		aResult := {}
		Do while nCntFor2<= Len(aMedicoes)
			If cEscala == aMedicoes[nCntFor2,nPosEsc]
			    aRetorno := a140Calc(nCntFor2,.t.)
       			If Len(aRetorno) == 2
               		Aadd( aResult, aRetorno[2] )
       			Elseif Len(aRetorno) == 4
               		Aadd( aResult, aRetorno[2] )
               		Aadd( aResult, aRetorno[4] )
       			Else
               		Aadd( aResult, aRetorno[1] )
       			EndIf
				nCntFor2++
			Else
            	exit
			EndIf
		EndDo
		If len(aResult) > 0
			nIncTotEsc := QmtNum(aResult[1,5]) // Incerteza Total do Primeiro Ponto
			nErrSisEsc := QmtNum(aResult[1,2]) // Desvio M‚dio do Primeiro Ponto
			lExatEsc := aResult[1,7] // Exatid„o do Primeiro Ponto
			lAceiEsc := aResult[1,8] // Aceita‡„o do Primeiro Ponto
			lAdeqEsc := aResult[1,9] // Adequa‡„o ao Uso do Primeiro Ponto
			For nCntFor := 1 to Len(aResult)
				nIncTotEsc := If(QmtNum(aResult[nCntFor,5]) > nIncTotEsc, QmtNum(aResult[nCntFor,5]), nIncTotEsc)
				nErrSisEsc := If(QmtNum(aResult[nCntFor,2]) > nErrSisEsc, QmtNum(aResult[nCntFor,2]), nErrSisEsc)
				lExatEsc := If(lExatEsc,If(aResult[nCntFor,7],.t.,.f.),.f.)
				lAceiEsc := If(lAceiEsc,If(aResult[nCntFor,8],.t.,.f.),.f.)
				lAdeqEsc := If(lAdeqEsc,If(aResult[nCntFor,9],.t.,.f.),.f.)
			Next

			// Procura valor nominal com maior numero de casas decimais na escala
			nNumDec := 0
			For nCntFor := 1 to len(aMedicoes)
				If cEscala == aMedicoes[nCntFor,nPosEsc]
					If QA_NumDec(aMedicoes[nCntFor,nPosEsp]) >= nNumDec
						nNumDec := QA_NumDec(aMedicoes[nCntFor,nPosEsp])
						cValor := aMedicoes[nCntFor,nPosEsp]
					EndIf
				EndIf
			Next nCntFor

			If li > 55
				R030Cab()
				li++
				lCab := .t.
			EndIf
			If lCab
				CabConfMet() // Imprime cabecalho de Confirmacao Metrologica
				lCab := .f.
			EndIf
			li++
			@ li  ,000 PSAY "|"
			@ li  ,007 PSAY cEscala
			@ li  ,025 PSAY "|"
			If cValor <> NIL
				@ li  ,029 PSAY nIncTotEsc PICTURE QMT140Pics("nIncTotEsc",cValor,.t.)
			Endif
			@ li  ,044 PSAY "|"
			If cValor <> NIL
				@ li  ,049 PSAY nErrSisEsc PICTURE QMT140Pics("nErrSisEsc",cValor,.t.)
			Endif	
			@ li  ,069 PSAY "|"
			@ li  ,074 PSAY If(lExatEsc,OemToAnsi(STR0070),OemToAnsi(STR0071))//ACEITO - REJEITADO
			@ li  ,087 PSAY "|"
			@ li  ,093 PSAY If(lAdeqEsc,OemToAnsi(STR0070),OemToAnsi(STR0071))
			@ li  ,107 PSAY "|"
			@ li  ,112 PSAY If(lAceiEsc,OemToAnsi(STR0070),OemToAnsi(STR0071))
			@ li  ,131 PSAY "|"
			li++
//			@ li  ,004 PSAY repl("-",112)
			aadd(aResEsc,{nIncTotEsc,nErrSisEsc,lExatEsc,lAdeqEsc,lAceiEsc})
		EndIf
		@ li  ,000 PSAY "|"
		@ li  ,025 PSAY "|"
		@ li  ,044 PSAY "|"
		@ li  ,069 PSAY "|"
		@ li  ,087 PSAY "|"		
		@ li  ,107 PSAY "|"	
		@ li  ,131 PSAY "|"	
	Else
        nCntFor2++
	EndIf
	If nCntFor2 <= Len(aMedicoes)
       cEscala := aMedicoes[nCntFor2,nPosEsc]
 	EndIf
EndDo

// Imprime a Confirmacao Metrologica do Instrumento

If len(aResEsc) > 0
	nIncTotEsc := 0
	nErrSisEsc := 0
	lExatEsc := .t.
	lAceiEsc := .t.
	lAdeqEsc := .t.
	For nCntFor := 1 to Len(aResEsc)
		nIncTotEsc := If(aResEsc[nCntFor,1] > nIncTotEsc, aResEsc[nCntFor,1], nIncTotEsc)
		nErrSisEsc := If(aResEsc[nCntFor,2] > nErrSisEsc, aResEsc[nCntFor,2], nErrSisEsc)
		lExatEsc := If(lExatEsc,If(aResEsc[nCntFor,3],.t.,.f.),.f.)
                lAdeqEsc := If(lAdeqEsc,If(aResEsc[nCntFor,4],.t.,.f.),.f.)
                lAceiEsc := If(lAceiEsc,If(aResEsc[nCntFor,5],.t.,.f.),.f.)
	Next

	li++
	@ li  ,000 PSAY "|"
	@ li  ,007 PSAY OemToAnsi(STR0072)//"CONF. INSTRUMENTO"
	@ li  ,025 PSAY "|"
//	@ li  ,029 PSAY nIncTotEsc PICTURE QMT140Pics("nIncTotEsc",cValor,.t.)
	@ li  ,044 PSAY "|"
//	@ li  ,046 PSAY nErrSisEsc PICTURE QMT140Pics("nErrSisEsc",cValor,.t.)
	@ li  ,069 PSAY "|"
	@ li  ,074 PSAY If(lExatEsc,OemToAnsi(STR0070),OemToAnsi(STR0071))//ACEITO - REJEITADO
	@ li  ,087 PSAY "|"
	@ li  ,093 PSAY If(lAdeqEsc,OemToAnsi(STR0070),OemToAnsi(STR0071))
	@ li  ,107 PSAY "|"
	@ li  ,112 PSAY If(lAceiEsc,OemToAnsi(STR0070),OemToAnsi(STR0071))
	@ li  ,131 PSAY "|"
	li++
	@li,000 PSAY __PrtThinLine()
//	@ li  ,004 PSAY repl("-",112)
	li++
EndIf

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR030CInc³ Autor ³ Wanderley Goncalves Jr³ Data ³ 20.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho de Medicoes com Incerteza                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR030CINC()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cText                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MTR030CInc(cText,nLin)

Local nOrd := 0

If cText == Nil
	cText := " "
EndIf

@ li,004 PSAY STR0105+" : " + ;  // "Escala"
         	AllTrim( aMedicoes[nLin,nPosEsc] ) + ;
          	" - " + ;
         	AllTrim( aMedicoes[nLin,nPosGer,1,11] )
li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Unidade de madida, valor minimo e maximo da escala    ³
//³    Valor Minimo: 9999999999    Valor Maximo: 9999999999       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nRec := QM9->(recno())
nOrd := QM9->(IndexOrd())
QM9->(dbSetOrder(1))
If QM9->(dbSeek(xFilial("QM9")+aMedicoes[nLin,nPosEsc] + Inverte(aMedicoes[nLin,nPosGer,1,11])))
	@ li,004 PSAY STR0112+" : "+QM9->QM9_ESCALI  // "Valor Minimo"
	@ li,035 PSAY STR0113+" : "+QM9->QM9_ESCALF  // "Valor Maximo"
	@ li,094 PSAY STR0114+" : "+;                // "Unidade de Medida"
						IIf(SAH->(dbSeek(xFilial("SAH")+QM9->QM9_UNIMED)),;
							AllTrim(SAH->AH_UMRES),;
							Space(9) )
	li++
EndIf
QM9->(dbGoto(nRec))
QM9->(dbSetOrder(nOrd))

@li,00 PSAY __PrtThinLine()

li++          
@ li,000 PSAY "|"
@ li,025 PSAY "|"
@ li,047 PSAY "|"
@ li,048 PSAY Upper(Padc(STR0086,10))+"|"  // Media
@ li,059 PSAY Upper(Padc(STR0087,10))+"|"	// Desvio
@ li,070 PSAY Upper(Padc(STR0087,10))+"|"	// Desvio
@ li,081 PSAY Upper(Padc(STR0088,10))+"|"  // Incerteza
@ li,092 PSAY Upper(Padc(STR0088,10))+"|"	// Incerteza 
@ li,103 PSAY Upper(Padc(STR0089,10))+"|"  // Erro
@ li,131 PSAY "|"

li++
@ li,000 PSAY "|"
@ li,004 PSAY Upper(STR0090)			// Padrao 
@ li,025 PSAY "|"
@ li,027 PSAY Upper(STR0091)			// Valores Encontrados
@ li,047 PSAY "|"
@ li,048 PSAY Upper(Padc(STR0092,10))+"|"  // Leituras
@ li,059 PSAY Upper(Padc(STR0093,10))+"|"  // Medio
@ li,070 PSAY Upper(Padc(STR0090,10))+"|"  // Padrao
@ li,081 PSAY Upper(Padc(STR0095,10))+"|"	// Medicao
@ li,092 PSAY Upper(Padc(STR0096,10))+"|"	// Total
@ li,103 PSAY Upper(Padc(STR0096,10))+"|"	// Total
@ li,119 PSAY Upper(STR0097)+"      |"			// Status

li++
@li,00 PSAY __PrtThinLine()

If QM9->QM9_TIPAFE $ "4|8"
	li++
	@li,00 PSAY __PrtThinLine()
Endif

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR030CEsp³ Autor ³ Wanderley Goncalves Jr³ Data ³ 20.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho de Medicoes em relacao a valores         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR030CEsp()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuri Seto ³ 20/06/00 ³ Alteracoes para calibrar Tipo de Calibracao Re- ³±±
±±³          ³          ³ logio.                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MTR030CEsp(nLin,nCntForM)

/*
   Escala            Rev  Padrao            Rev       V.Inicial      Dif.         %        V.Final       Dif.         %
   ================  ===  ================  ===       ==========  ==========  ==========  ==========  ==========  ==========
   1234567890123456  00   1234567890123456  00        9999999999  9999999999  9999999999  9999999999  9999999999  9999999999
*/

li++
@li,000 PSAY __PrtThinLine()
li++
//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//|   ESCALA            |REV|      PADRAO      |   REV   |  V.Inicial   |Dif.       |%         |V.Final     |Dif.     |%           |

@ li  ,000 PSAY "|"
@ li  ,004 PSAY OemToAnsi(STR0052)//"Escala"
@ li  ,022 PSAY "|"
@ li  ,023 PSAY OemToAnsi(STR0106)//"Rev"
@ li  ,026 PSAY "|"
@ li  ,033 PSAY OemToAnsi(STR0090)//"Padrao"
@ li  ,045 PSAY "|"
@ li  ,049 PSAY OemToAnsi(STR0106)//"REV"
@ li  ,055 PSAY "|"
@ li  ,058 PSAY OemToAnsi(STR0108)//V.Inicial
@ li  ,070 PSAY "|"
@ li  ,071 PSAY OemToAnsi(STR0109)//"Dif."
@ li  ,082 PSAY "|"
@ li  ,083 PSAY OemToAnsi("%")
If aMedicoes[nLin,nPosGer,1,2] $ "2,5,3,8,9"  // Se nao for tipo simples ou calibrador, imprime final
	@ li  ,093 PSAY "|"
	@ li  ,094 PSAY OemToAnsi(STR0110)//"V.Final"
	@ li  ,106 PSAY "|"
	@ li  ,107 PSAY OemToAnsi(STR0109)//"Dif."
	@ li  ,117 PSAY "|"
	@ li  ,118 PSAY OemToAnsi("%")
	@ li  ,131 PSAY "|"	
EndIf

li++
@li,000 PSAY __PrtThinLine()

li++
If nTotCol == 4
	If nCntForM <= 2
		@ li   , 000 PSAY "|"
		@ li   , 004 PSAY STR0021 // "Subida"
		@ li   , 022 PSAY "|"
		@ li   , 026 PSAY "|"
		@ li   , 045 PSAY "|"
		@ li   , 055 PSAY "|"
		@ li   , 070 PSAY "|"								
		@ li   , 082 PSAY "|"
		@ li   , 093 PSAY "|"
		@ li   , 106 PSAY "|"		
		@ li   , 117 PSAY "|"				
		@ li   , 131 PSAY "|"
	Else                     
		@ li   , 000 PSAY "|"	
		@ li   , 004 PSAY STR0022 // "Descida"
		@ li   , 022 PSAY "|"
		@ li   , 026 PSAY "|"
		@ li   , 045 PSAY "|"
		@ li   , 055 PSAY "|"
		@ li   , 070 PSAY "|"								
		@ li   , 082 PSAY "|"
		@ li   , 093 PSAY "|"
		@ li   , 106 PSAY "|"		
		@ li   , 117 PSAY "|"				
		@ li   , 131 PSAY "|"
	EndIf
	li++
EndIf

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030Min   ³ Autor ³ Wanderley Goncalves Jr³ Data ³ 20.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Valor Minimo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Min(nLin)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nLin -> Linha no aMedicoes                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuri Seto ³ 20/06/00 ³ Alteracoes para calibrar Tipo de Calibracao Re- ³±±
±±³          ³          ³ logio.                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030Min(nLin)

Local nVal := 0

If aMedicoes[nLin,nPosGer,1,2] $ "1,2,3,9"
	QM3->(DbSetOrder(1))
	If QM3->(DbSeek(xFilial("QM3")+aMedicoes[nLin,nPosPad]+Inverte(aMedicoes[nLin,nPosGer,1,12])))
		nVal := SuperVal(QM3->QM3_ESPEC) - SuperVal(QM3->QM3_TOLER)
	Else
		nVal := 0
	EndIf
ElseIf aMedicoes[nLin,nPosGer,1,2] $ "4,8"
	QMG->(DbSetOrder(1))
	If QMG->(DbSeek(xFilial("QMG")+QM6->QM6_INSTR+QM6->QM6_REVINS+aMedicoes[nLin,nPosPad]))
		nVal := SuperVal(QMG->QMG_LIE)
	Else
		nVal := 0
	EndIf
ElseIf aMedicoes[nLin,nPosGer,1,2] $ "5"
	QMA->(DbSetOrder(1))
	If QMA->(xFilial("QMA")+aMedicoes[nLin,nPosEsc]+aMedicoes[nLin,nPosGer,1,11]+aMedicoes[nLin,nPosPad])
		nVal := SuperVal(aMedicoes[nLin,nPosEsp]) - SuperVal(QMA->QMA_TOLER)
	Else
		nVal := 0
	EndIf
EndIf

Return(nVal)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030Max   ³ Autor ³ Wanderley Goncalves Jr³ Data ³ 20.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Valor Minimo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Max(nLin)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nLin -> Linha no aMedicoes                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuri Seto ³ 20/06/00 ³ Alteracoes para calibrar Tipo de Calibracao Re- ³±±
±±³          ³          ³ logio.                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030Max(nLin)

Local nVal := 0

If aMedicoes[nLin,nPosGer,1,2] $ "1,2,3,9"
	QM3->(DbSetOrder(1))
	If QM3->(DbSeek(xFilial("QM3")+aMedicoes[nLin,nPosPad]+Inverte(aMedicoes[nLin,nPosGer,1,12])))
		nVal := SuperVal(QM3->QM3_ESPEC) + SuperVal(QM3->QM3_TOLER)
	Else
		nVal := 0
	EndIf
ElseIf aMedicoes[nLin,nPosGer,1,2] $ "4,8"
	QMG->(DbSetOrder(1))
	If QMG->(DbSeek(xFilial("QMG")+QM6->QM6_INSTR+QM6->QM6_REVINS+aMedicoes[nLin,nPosPad]))
		nVal := SuperVal(QMG->QMG_LSE)
	Else
		nVal := 0
	EndIf
ElseIf aMedicoes[nLin,nPosGer,1,2] $ "5"
	QMA->(DbSetOrder(1))
	If QMA->(xFilial("QMA")+aMedicoes[nLin,nPosEsc]+aMedicoes[nLin,nPosGer,1,11]+aMedicoes[nLin,nPosPad])
		nVal := SuperVal(aMedicoes[nLin,nPosEsp]) + SuperVal(QMA->QMA_TOLER)
	Else
		nVal := 0
	EndIf
EndIf

Return(nVal)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030Dif   ³ Autor ³ Wanderley Goncalves Jr³ Data ³ 20.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Diferenca entre Valor Encontrado e Nominal ou      ³±±
±±³          ³ limites                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Dif(nLin,nMin,nMax)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nVal -> Valor Informado na Medicao                         ³±±
±±³          ³ nLin -> Linha de posicao no aMedicoes                      ³±±
±±³          ³ nMin -> Limite Minimo (para calculo c/relacao aos limites) ³±±
±±³          ³ nMax -> Limite Maximo (para calculo c/relacao aos limites) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030Dif(nVal,nLin,nMin,nMax)

Local nValor    := 0
Local nRegistro := QM9->(recno())
Local nOrdem    := QM9->(IndexOrd())

QM9->(DbSetOrder(1))
QM9->(DbSeek(xFilial("QM9")+aMedicoes[nLin,nPosEsc]+Inverte(aMedicoes[nLin,nPosGer,1,11])))

If QM9->QM9_PERRO == '1'   && % Erro em relacao ao especificado
   Do Case
   Case SuperVal(aMedicoes[nLin,nPosEsp]) == 0
		nValor := 0
   Otherwise
      nValor := Abs(nVal - SuperVal(aMedicoes[nLin,nPosEsp]))
   EndCase
Else                           && % Erro em relacao ao especificado +/- Tolerancia
   Do Case
   Case nVal >= nMin .and. nVal <= nMax
        nValor := 0
   otherwise
        If nVal < nMin
           nValor := Abs(Abs(nMin) - abs(nVal))
        ElseIf nVal > nMax
           nValor := Abs(Abs(nVal) - Abs(nMax))
        EndIf
   EndCase
EndIf

QM9->(DbSetOrder(nOrdem))
QM9->(DbGoto(nRegistro))

return(nValor)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030PerDif³ Autor ³ Wanderley Goncalves Jr³ Data ³ 20.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Diferenca entre Valor Encontrado e Nominal ou      ³±±
±±³          ³ limites em percentual                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030PerDif(nVal,nLin,nMin,nMax)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nVal -> Valor Informado na Medicao                         ³±±
±±³          ³ nLin -> Linha de posicao no aMedicoes                      ³±±
±±³          ³ nMin -> Limite Minimo (para calculo c/relacao aos limites) ³±±
±±³          ³ nMax -> Limite Maximo (para calculo c/relacao aos limites) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030PerDif(nVal,nLin,nMin,nMax)

Local nValor := 0
Local nOrdem := QM9->(Indexord())
Local nRegistro := QM9->(recno())

QM9->(DbSetOrder(1))
QM9->(DbSeek(xFilial("QM9")+aMedicoes[nLin,nPosEsc]+Inverte(aMedicoes[nLin,nPosGer,1,11])))
If QM9->QM9_PERRO == '1'   && % Erro em relacao ao especificado
   Do Case
   Case SuperVal(aMedicoes[nLin,nPosEsp]) == 0
		nValor := 0
   Otherwise
      nValor := ( (nVal - SuperVal(aMedicoes[nLin,nPosEsp])) / SuperVal(aMedicoes[nLin,nPosEsp]) ) * 100
   EndCase
Else  // % Erro em relacao ao especificado +/- Tolerancia
   Do Case
   Case nVal >= nMin .and. nVal <= nMax
        lc_valor := 0
   otherwise
        If nVal < nMin
           nValor := Abs(Abs(nMin) - abs(nVal)) / abs(nMin) * 100
        ElseIf nVal > nMax
           nValor := Abs(Abs(nVal) - Abs(nMax)) / abs(nMax) * 100
        EndIf
   EndCase
EndIf

QM9->(DbSetOrder(nOrdem))
QM9->(DbGoto(nRegistro))

return(nValor)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030NumCol³ Autor ³ Wanderley Goncalves Jr³ Data ³ 22.08.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna numero de colunas de medições                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030NumCol()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nCntFor -> Linha da array aMedicoes posicionada            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuri Seto ³ 20/06/00 ³ Alteracoes para calibrar Tipo de Calibracao Re- ³±±
±±³          ³          ³ logio.                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030NumCol(nCntFor)

Local nTotCol := 1

If aMedicoes[nCntFor,nPosGer,1,2] $ "1,4"
	nTotCol := 1
Elseif aMedicoes[nCntFor,nPosGer,1,2] $ "2,5,8" 
   If aMedicoes[nCntFor,nPosGer,1,3] <> "A"
		nTotCol := 2
	Else 
		nTotCol := 1	
	Endif	
Elseif aMedicoes[nCntFor,nPosGer,1,2] $ "3,9"
    If aMedicoes[nCntFor,nPosGer,1,3] <> "A"
		nTotCol := 4
	Else 
		nTotCol := 1
	Endif	
EndIf

Return(nTotCol)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R030AnaUP ³ Autor ³ Wanderley Goncalves Jr³ Data ³ 03.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Analise das Ultimas Pecas Produzidas          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030AnaUP()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030AnaUP()

Local cArqTxt := "R304"+cEmpAnt+cFilAnt+".TXT"
Local cTitulo := TITULO
Local Tamanho := " "

TITULO := OemToAnsi(STR0069)//"ANALISE DAS ULTIMAS PECAS PRODUZIDAS"

If li > 55
   Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, IIF(aReturn[4]==1,15,18))
	li+=2
EndIf

@ li,004 PSAY OemToAnsi(QaTit("QM2_TIPO",16,.t.)) + QM2->QM2_TIPO + " - " + QM1->QM1_DESCR
li++
@ li,004 PSAY OemToAnsi(QaTit("QM1_PROCAL",16,.t.))  + ; // "Procedimento Cal.
				If(lProcs,alltrim(QA5->QA5_NORMA) + "-" + QA5->QA5_REVPRO+" - " + QA5->QA5_DESCRI,QM1->QM1_PROCAL)
li++
@ li,004 PSAY OemToAnsi(QaTit("QM2_RESP",16,.t.)) + Alltrim(cNomResp) 
li++
@ li,004 PSAY OemToAnsi(QaTit("QM2_DEPTO",16,.t.)) + Alltrim(cNomDep)
li++
@ li,004 PSAY OemToAnsi(QaTit("QM2_LOCAL",16,.t.)) + Alltrim(QM2->QM2_LOCAL)
li++
@ li,004 PSAY OemToAnsi(QaTit("QM2_FREQAF",16,.t.)) + Alltrim(StrZero(QM2->QM2_FREQAF,4))
li++                    
@ li,004 PSAY OemToAnsi(QaTit("QM2_FABR",16,.t.)) + Alltrim(QM2->QM2_FABR)
li+=2                    

R030IMPTXT(cArqTxt,2)

TITULO := cTitulo

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³r030ITB   ³ Autor ³ Antonio Aurelio       ³ Data ³ 03.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o item Incerteza do Tipo B relacionado com o instr.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ r030ITB()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function r030ITB()

Local nUi := 0
Local nUc := 0
Local nUa := 0
Local nUaTot := 0
Local nUcTot := 0		
Local nUiTot := 0
Local nVeffTot := 0
Local aVeff    := {}
Local nCnt     := 0
Local nCntFor  := 1
Local nCntFor2 := 0
Local cEscala := " "
Local cPonto  := " "	
/*
	       1         2         3         4         5         6         7         8         9        10        11        12        13      
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
====================================================================================================================================
|                                          INCERTEZA TIPO B                                                                        |
====================================================================================================================================
| Cod. Incerteza | Simbolo  | Fonte                        |Valor Incert.|Distr.| Divisor  |Coef.Sensib.| Incer.Calc. |Graus Liber.|
------------------------------------------------------------------------------------------------------------------------------------
|1234567890123456|1234567890|123456789012345678901234567890|1234567890   |  X   |1234567890|1234567890  | 1234567890  | 1234567890 |
|----------------------------------------------------------------------------------------------------------------------------------|
*/		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nPosITB, declarada como Private na fun‡Æo chamadora.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aMedicoes[nCntFor,nPosITB,1,1]) //File(cArqQMS)
	For nCntFor := 1 to Len(aMedicoes) // [nCntFor,nPosITB])
		li+= 2
		lCab := .T.
		nUi := 0
		nUc := 0
		nUa := 0
		nUaTot := 0
		nUcTot := 0		
		nUiTot := 0
		nVeffTot := 0
		nVeUi	:= 0
		aVeff    := {}
		For nCntFor2 := 1 to Len(aMedicoes[nCntFor,nPosITB])
			If Empty(aMedicoes[nCntFor,nPosITB,nCntFor2,1])
				Loop
			EndIf
			
			li++
			If li > 55
				r030Cab()
				lCab := .T.
				li+= 2
			EndIf
			
			If lCab
				@li,00 PSAY __PrtFatLine()
				
				li++
				@li,00 PSAY __PrtCenter(STR0100)
				
				li++
				@li,00 PSAY __PrtFatLine()
				
				li++
				@li,00 PSAY __PrtThinLine()
				
				li++

            Endif
//          1         2         3         4         5         6         7         8         9         0         1         2         3
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//  Cod. Incertid.   Simbolo    Fuente                        Valor Incert. Distr.  Divisor   Coef.Sensib.  Incer.Calc.  Grados Liber.
//                   Uc         Inc. Estand.Combinada                       Nor               "
//                   U          Inc. Expandida                              Nor K             "
//                   Ui         Inc. Expandida                              Nor Kp                                      "

			If aMedicoes[nCntFor,nPosEsc] <> cEscala .or.;
			   aMedicoes[nCntFor,nPosPad] <> cPonto
				@ li ,003 PSAY __PrtCenter(STR0052+" : " + aMedicoes[nCntFor,nPosEsc] + "     " +;
				               STR0053+" : " + aMedicoes[nCntFor,nPosPad])  //"Escala"  //"Ponto"
				cEscala := aMedicoes[nCntFor,nPosEsc]
				cPonto := aMedicoes[nCntFor,nPosPad]
//				@ li,131  PSAY "|"
				li++
				@li,00 PSAY __PrtThinLine()
				li++
				
				@li,00 PSAY __PrtThinLine()
				li++				
/*				@ li,00 PSAY repl("-",132)
				li++*/
			EndIf
			If lCab
				@ li,00 PSAY STR0101 // "| Cod. Incerteza | Simbolo  | Fonte                        |Valor Incert.|Distr.| Divisor  |Coef.Sensib.| Incer.Calc. |Graus Liber.|"
				
				li++
				@li,00 PSAY __PrtThinLine()
				
				li++                     
				@li,00 PSAY __PrtThinLine()
				
				li++
				lCab := .F.
			EndIf          

			@ li, 00 PSAY "|"
			@ li, 01 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,1],16) // Cod. Incerteza
			@ li, 17 PSAY "|"
			@ li, 18 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,2],10) // Simbolo
			@ li, 28 PSAY "|"
			@ li, 29 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,3],30) // Fonte
			@ li, 59 PSAY "|"
			@ li, 60 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,4],10) // Vl. Inc.
			@ li, 73 PSAY "|"
			@ li, 76 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,5],01) // Distrib.
			@ li, 80 PSAY "|"
			@ li, 81 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,6],10) // Divisor
			@ li, 91 PSAY "|"
			@ li, 92 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,7],10) // Coef. Sensib.
			@ li,104 PSAY "|"
			@ li,106 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,8],10) // Incert. Calc.
			@ li,118 PSAY "|"
			If Empty(aMedicoes[nCntFor,nPosITB,nCntFor2,9])			
				@ li,120 PSAY "*"
			Else
				@ li,120 PSAY PadR(aMedicoes[nCntFor,nPosITB,nCntFor2,9],10) // Graus Liber.
			Endif	
			@ li,131 PSAY "|"
			If li > 55
				r030Cab()
				lCab := .T.
				li+= 2
			EndIf
			nUi := aMedicoes[nCntFor,nPosITB,nCntFor2,8] // Coef. Sensib.
			If At(aMedicoes[nCntFor,nPosITB,nCntFor2,8],".") == 0
				aMedicoes[nCntFor,nPosITB,nCntFor2,8] := StrTran(aMedicoes[nCntFor,nPosITB,nCntFor2,8],".",",")			
			Endif
			If Valtype(nUi) == "C"
				nUi := SuperVal(nUi)**2 
			Else
				nUi := Val(nUi)**2 
			Endif
			nUiTot := nUiTot + nUi
			If SuperVal(aMedicoes[nCntFor,nPosITB,nCntFor2,9]) <> 0 // Grau Liber.
				nUaTot := nUaTot + nUi
				aAdd(aVeff, ;
				{ Val(Str(SuperVal(aMedicoes[nCntFor,nPosITB,nCntFor2,8]))), ; // Coef. Sensib.
				Val(Str(SuperVal(aMedicoes[nCntFor,nPosITB,nCntFor2,9]))) }) // Grau Liber.
			EndIf
			If nCntFor2 == Len(aMedicoes[nCntFor,nPosITB])
				nUc := SQRT(nUiTot)
				nUa := StrTran(aMedicoes[nCntFor,12,1,17,2],".",",")//SQRT(nUaTot)
				If SuperVal(nUa) > (nUc / 2)
					nVeffTot := 0
					For nCnt := 1 To Len(aVeff)
						If aVeff[nCnt,2] > 0
							nVeffTot := nVeffTot +	(	(aVeff[nCnt,1]**4)*((10)**10) / aVeff[nCnt,2]*((10)**10) )
						EndIf
					Next
					If nVeffTot > 0
						nVeffTot := (nUc^4)*((10)**10) / nVeffTot*((10)**10)
					EndIf
				EndIf
				li++
				If li > 53
					r030Cab()
					li+= 2
				EndIf
				@li,00 PSAY __PrtThinLine()

				li++
				@li,00  PSAY STR0102+Padr(AllTrim(Str(nUc)),12) // "|                | Uc       | Inc. Padrao Combinada        |             |Nor   |          |"
                @li,104 PSAY "|"
                @li,118 PSAY "|"                                
                @li,131 PSAY "|"                                                
                
				li++
				@li,00 PSAY __PrtThinLine()

				li++
				@li,00  PSAY STR0103+Padr(AllTrim(Str(nUc*2)),12) //  "|                | U        | Inc. Expandida               |             |Nor K |          |"
                @li,104 PSAY "|"
                @li,118 PSAY "|"                                
                @li,131 PSAY "|"                                                

				li++
				@li,00 PSAY __PrtThinLine()

				li++
				If nCntFor2 <> 1 .and. SuperVal(aMedicoes[nCntFor,nPosITB,nCntFor2,9]) <> 1
					@li,00  PSAY  STR0104+Padr(AllTrim(Str(nVeffTot)),12)  // "|                | Ui       | Inc. Expandida               |             |Nor Kp|          |            |             |"
					@li,131 PSAY "|"
					li++				
				Endif	
				@li,00 PSAY __PrtThinLine()
			EndIf
		Next
	Next
EndIf

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³r030Traco ³ Autor ³ XXXXXXXXXXXXXXXXXXXXXX³ Data ³ 99.99.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centraliza o titulo na pag. e preenche com tra‡o a linha.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*Static Function r030Traco(cTitulo, nTam)
Local nLen
Local nPos
Default cTitulo := ""
Default nTam    := 132

nLen  := Len(">>  " + cTitulo + "  <<")
nPos  := (nTam - nLen) / 2
@ li,00   PSAY repl("-",nPos )
@ li,nPos PSAY ">>  " + cTitulo + "  <<"
nPos := nPos + nLen
@ li,nPos PSAY Repl("-",nTam - nPos )

Return NIL
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR030SubCab³ Autora³ Iuri Seto            ³ Data ³ 05/06/00³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime SubCabecalho de Medicoes com Incerteza para Ins-   ³±±
±±³          ³ trumentos.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³   r030SubCab()                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cText                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MTR030SubCab(cText,nLin)

If cText == Nil
	cText := " "
EndIf

@li,000 PSAY __PrtThinLine()

li++
@ li,004 PSAY Upper(STR0111) + ;  // "Valores"
            " " + ;
         	cText
li++
@li,000 PSAY __PrtThinLine()

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³R030InsMal³ Autora³ Iuri Seto           	³ Data ³ 15/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o Codigo do Instrumento que se refere a Malha      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Codigo do Instrumento Malha     					  ³±±
±±³          ³ ExpC2 : Escala do Instrumento Malha     					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ ExpC1 : Código do Instrumento Filho                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QMTR030													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function R030InsEsc(cInstr,cEscala)
Local cOldAlias := Select()
Local nOrdem := IndexOrd()
Local nRegistro := Recno()
Local nQM2Ord := QM2->(IndexOrd())
Local nQM2Reg := QM2->(Recno())
Local cInsEsc

cInsEsc := " "

dbSelectArea("QM2")
dbSetOrder(7)
If QM2->(dbSeek(xFilial("QM2")+"0"+cInstr+cEscala))
	cInsEsc := QM2->QM2_INSTR	
EndIf
dbSetOrder(nQM2Ord)
dbGoto(nQM2Reg)

dbSelectArea(cOldAlias)
dbSetOrder(nOrdem)
dbGoto(nRegistro)

Return(cInsEsc)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR030REsc³Autora ³ Iuri Seto             ³ Data ³ 21/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Rodape para Tipo de Calibracao Relogio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR030REsc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nCntFor, nCntForM                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MTR030REsc(aRelResu,cEscala,nCntFor)
Local nIndice

If !EMPTY(cEscala)
/*       1         2         3         4         5         6         7         8         9       110       120        
   456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
   ==================================================================================================================
   |                                                Parametros de Analise                                           |
   ==================================================================================================================
   | fe   | Desvio Maximo no sentido crescente              								       |  1234567890    |
   | fges | Desvio Total ( crescente / decrescente )                                               |  1234567890    |
   | fu   | Erro de Retorno                                                                        |  1234567890    |
   ==================================================================================================================
   | Histerese                                                                                     |  1234567890    |
   ==================================================================================================================
*/
	nIndice := ASCAN(aRelResu,{ |x| x[1] == cEscala})

	li++	
	@li,000 PSAY __PrtThinLine()

	li++
	@ li,053 PSAY STR0119	//"Parametros de Analise"

	li++
	@li,000 PSAY __PrtThinLine()

	li++
	@ li,006 PSAY STR0120	//"fe"
	@ li,013 PSAY STR0121  //"Desvio Maximo no sentido crescente"
	@ li,113 PSAY aRelResu[nIndice,6] PICTURE QMT140Pics("aRelResu[nIndice,6]",;
														 aMedicoes[nCntFor,nPosEsp],.t.)
	li++
	@ li,006 PSAY STR0122	//"fges"
	@ li,013 PSAY STR0123  //"Desvio Total ( crescente / decrescente )"
	@ li,113 PSAY aRelResu[nIndice,7] PICTURE QMT140Pics("aRelResu[nIndice,7]",;
														 aMedicoes[nCntFor,nPosEsp],.t.)
	li++
	@ li,006 PSAY STR0124	//"fu"
	@ li,013 PSAY STR0125  //"Erro de Retorno"
	@ li,113 PSAY aRelResu[nIndice,8] PICTURE QMT140Pics("aRelResu[nIndice,8]",;
														 aMedicoes[nCntFor,nPosEsp],.t.)
	li++	
	@li,000 PSAY __PrtThinLine()

	li++	
	@li,000 PSAY __PrtThinLine()	

	li++
	@ li,006 PSAY STR0126  //"Histerese"
	@ li,113 PSAY aRelResu[nIndice,10] PICTURE QMT140Pics("aRelResu[nIndice,10]",;
														 aMedicoes[nCntFor,nPosEsp],.t.)
	li++	
	@li,000 PSAY __PrtThinLine()

	li+=2
EndIf
	
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR030REsP³Autora ³ Iuri Seto             ³ Data ³ 21/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Rodape para Tipo de Calibracao Pressao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR030REsP()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nCntFor, nCntForM                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QMTR030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MTR030REsP(aRelResu,cEscala,nCntFor)
Local nIndice

If !EMPTY(cEscala)
/*       1         2         3         4         5         6         7         8         9       110       120        
   456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
   ==================================================================================================================
   | Histerese                                                                                     |  1234567890    |
   ==================================================================================================================
*/
	nIndice := ASCAN(aRelResu,{ |x| x[1] == cEscala})

	li++	
	@li,000 PSAY __PrtThinLine()
	li++	
	@ li,006 PSAY STR0126  //"Histerese"
	@ li,113 PSAY aRelResu[nIndice,10] PICTURE QMT140Pics("aRelResu[nIndice,10]",;
														 aMedicoes[nCntFor,nPosEsp],.t.)
	li++	
	@li,000 PSAY __PrtThinLine()
	li+=2

EndIf
	
Return(Nil)
