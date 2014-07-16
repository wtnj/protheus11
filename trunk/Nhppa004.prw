#INCLUDE "QPPR180.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QPPR180  ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 21.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³PPAP Resultados Dimensionais                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QPPR180(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PPAP                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Robson Ramiro³01.08.01³      ³ Inclusao dos dados na moldura          ³±±
±±³ Robson Ramiro³11.10.02³      ³ Compatiblizacao das alteracoes efetuada³±±
±±³              ³        ³      ³ na 710, e impressao a partir da mBrowse³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Nhppa004(lBrow,cPecaAuto,cJPEG)

Local oPrint
Local lPergunte := .F.
Local cFiltro	:= ""
Local aArea		:= GetArea()
Local cGrupo

Private	aAreaQKB 	:= {}
Private cPecaRev 	:= ""
Private cStartPath 	:= GetSrvProfString("Startpath","")
Private lSeq 		:= QKB->(FieldPos("QKB_SEQ")) <> 0
Private cCondW		:= ""
Private	lImpCd		:= .F.
Default lBrow 		:= .F.
Default cPecaAuto	:= ""
Default cJPEG       := ""

If !Empty(cPecaAuto)
	cPecaRev := cPecaAuto
Endif

If lSeq
	cCondW := "QKB->QKB_PECA+QKB->QKB_REV+QKB->QKB_SEQ == cPecaRev"
Else
	cCondW := "QKB->QKB_PECA+QKB->QKB_REV == cPecaRev"
Endif

cGrupo := Iif(lSeq,"ESTSEQ","PPR180")

oPrint	:= TMSPrinter():New( STR0002 ) //"Resultados Dimensionais"
oPrint:SetPortrait()
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros							³
//³ mv_par01				// Peca       							³
//³ mv_par02				// Revisao        						³
//³ mv_par03				// Impressora / Tela          			³
//³ mv_par04				// Imprime Caracteristica?     			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjusteSx1(lBrow)

If lBrow
	If MsgYesNo(OemToAnsi(STR0026),OemToAnsi(STR0027)) //"Imprime Descricao/Caracteristica?" ### "Impressao"		
		lImpCd := .T.
	Else                                                                                                     
		lImpCd := .F.
	Endif
Endif

If Empty(cPecaAuto)
	If AllTrim(FunName()) == "QPPA180"
		If lSeq
			cPecaRev := Iif(!lBrow, M->QKB_PECA + M->QKB_REV + M->QKB_SEQ, QKB->QKB_PECA + QKB->QKB_REV + QKB->QKB_SEQ)
		Else
			cPecaRev := Iif(!lBrow, M->QKB_PECA + M->QKB_REV , QKB->QKB_PECA + QKB->QKB_REV)
		Endif
	Else
		lPergunte := Pergunte(cGrupo,.T.)

		If lPergunte
			If lSeq
				cPecaRev := mv_par01 + mv_par02	+ mv_par03
			Else
				cPecaRev := mv_par01 + mv_par02	
			Endif
		Else
			Return Nil
		Endif
	Endif
Endif
	
DbSelectArea("QK1")
DbSetOrder(1)
DbSeek(xFilial()+Subs(cPecaRev,1,42))

DbSelectArea("QK2")
DbSetOrder(2)
DbSeek(xFilial()+Subs(cPecaRev,1,42))

DbSelectArea("QKB")

cFiltro := DbFilter()

If !Empty(cFiltro)
	Set Filter To
Endif

DbSetOrder(1)
If DbSeek(xFilial()+cPecaRev)

	aAreaQKB := GetArea()
	
	If Empty(cPecaAuto)
		MsgRun(STR0001,"",{|| CursorWait(), MontaRel(oPrint,lBrow) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."
	Else
		MontaRel(oPrint,lBrow)
	Endif

	If (lPergunte .and. (Iif(lSeq, mv_par04 == 1, mv_par03 == 1))) .or. !Empty(cPecaAuto)
		If !Empty(cJPEG)
			oPrint:SaveAllAsJPEG(cStartPath+cJPEG,875,1100,140)
		Else 
			oPrint:Print()
		EndIF
	Else
		oPrint:Preview()  		// Visualiza antes de imprimir
	Endif

Endif

If !Empty(cFiltro)
	Set Filter To &cFiltro
Endif

If !lPergunte
	RestArea(aArea)
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MontaRel ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 21.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Resultados Dimensionais                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MontaRel(ExpO1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR180                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(oPrint,lBrow)

Local i 	:= 1
Local lin 	:= 530
Local cCdCar:= ""
Private oFont16, oFont08, oFont10, oFontCou08

oFont16		:= TFont():New("Arial" ,16,16,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial" ,08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

Cabecalho(oPrint,i,lBrow)  			// Funcao que monta o cabecalho

DbSelectArea("QKB")

Do While !Eof() .and. xFilial("QKB") == QKB->QKB_FILIAL .and. &cCondW
	cCdCar := ""
	If lin > 2280		
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i,lBrow)  	// Funcao que monta o cabecalho
		lin := 530
	Endif
	
	lin += 40
	oPrint:Say(lin,050,QKB->QKB_ITEM,oFontCou08)
	oPrint:Say(lin,140,QKB->QKB_DESC,oFontCou08)

	If QK2->(DbSeek(xFilial("QK2")+Subs(cPecaRev,1,42)+QKB->QKB_CARAC))
		PPAPBMP(QK2->QK2_SIMB+".BMP", cStartPath)
		oPrint:SayBitmap(lin,1110,cStartPath+QK2->QK2_SIMB+".BMP",40,40)
		cCdCar := Alltrim(QK2->QK2_CODCAR)+" - "+Alltrim(SubStr(QK2->QK2_DESC,1,TamSx3("QK2_DESC")[1]-4))
	Endif

	Iif(QKB->QKB_FLOK == "1",	oPrint:Say(lin,2160,"X",oFontCou08),;
								oPrint:Say(lin,2270,"X",oFontCou08))	
	

	oPrint:Say(lin,1190,QKB->QKB_RESFOR,oFontCou08)
	oPrint:Say(lin,1665,QKB->QKB_RESCLI,oFontCou08)

	If lBrow 
		If lImpCd
	    	lin += 40
			oPrint:Say(lin,140,cCdCar,oFontCou08)    	
        Endif
	Else
		If mv_par04 == 1
	    	lin += 40
			oPrint:Say(lin,140,cCdCar,oFontCou08)    			
		Endif
	Endif        
	lin += 40
	DbSelectArea("QKB")
	DbSetOrder(1)

	DbSkip()

Enddo


Foot(oPrint)			// Funcao que monta o rodape

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Cabecalho³ Autor ³ Robson Ramiro A. Olive³ Data ³ 21.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cabecalho do relatorio                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cabecalho(ExpO1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR180                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cabecalho(oPrint,i,lBrow)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina

// oPrint:SayBitmap(05,0005, cFileLogo,328,82)  // Tem que estar abaixo do RootPath
oPrint:SayBitmap(05,0005, cStartPath+"\Whb.bmp",328,82)
oPrint:SayBitmap(05,2100, cStartPath+"\Logo.bmp",237,58)


oPrint:Say(040,750,STR0003,oFont16 ) //"Aprovacao de Peca de Producao"
oPrint:Say(090,750,STR0004,oFont16 ) //"   Resultados Dimensionais   "

oPrint:Say(171,30,STR0005,oFont08 ) //"PPAP No."
oPrint:Say(171,160,QK1->QK1_PPAP,oFont08)

oPrint:Say(171,1800,STR0021,oFont08 ) //"Pagina :"
oPrint:Say(171,1950,StrZero(i,3),oFont08)

If lSeq
	oPrint:Say(171,1300,STR0024,oFont08)	//"Sequencia :"
	oPrint:Say(171,1500,QKB->QKB_SEQ,oFont08)
Endif

//Box Cabecalho
oPrint:Box( 210, 30, 370, 2350 )

//Box Itens
oPrint:Box( 390, 30, 2890, 2350 )

// Construcao da Grade cabecalho
oPrint:Line( 290, 0030, 290, 2350 )   	// horizontal

oPrint:Line( 210, 1400, 370, 1400 )   	// vertical
                                                 
oPrint:Line( 210, 1875, 290, 1875 )   	// vertical

oPrint:Line( 290, 685, 370, 685 )   	// vertical  

// Construcao da Grade itens
oPrint:Line( 530, 0030, 530, 2350 )   	// horizontal

oPrint:Line( 390, 130, 2890, 130 )   	// vertical

oPrint:Line( 390, 1080, 2890, 1080 )   // vertical

oPrint:Line( 390, 1180, 2890, 1180 )   // vertical

oPrint:Line( 530, 1655, 2890, 1655 )   // vertical

oPrint:Line( 390, 2130, 2890, 2130 )   // vertical

oPrint:Line( 390, 2240, 2890, 2240 )   // vertical

// Descricao do Cabecalho
oPrint:Say(210,0040,STR0006,oFont08 ) //"Fornecedor"
oPrint:Say(250,0040,SM0->M0_NOMECOM,oFontCou08)

oPrint:Say(210,1410,STR0007,oFont08 ) //"Numero da Peca(Cliente)"
oPrint:Say(250,1410,Subs(QK1->QK1_PCCLI,1,26),oFontCou08)

oPrint:Say(210,1885,STR0008,oFont08 ) //"Revisao/Data Desenho"
oPrint:Say(250,1885,AllTrim(QK1->QK1_REVDES)+Space(01)+DtoC(QK1->QK1_DTRDES),oFontCou08)

oPrint:Say(290,0040,STR0009,oFont08 ) //"Local da Inspecao"
oPrint:Say(330,0045,Subs(QKB->QKB_LINSP,1,35),oFontCou08)

oPrint:Say(290,0695,STR0010,oFont08 ) //"Numero/Rev Peca(Fornecedor)"
oPrint:Say(330,0695,AllTrim(Subs(QK1->QK1_PRODUT,1,36))+"/"+ QK1->QK1_REVI,oFontCou08)

oPrint:Say(290,1410,STR0011,oFont08 ) //"Nome da Peca"
oPrint:Say(330,1410,Subs(QK1->QK1_DESC,1,50),oFontCou08)

// Descricao dos itens
oPrint:Say(445,0050,STR0012,oFont08 ) //"Item"
oPrint:Say(445,0430,STR0013,oFont08 ) //"Dimensao/Especificacao"
If lBrow 
	If lImpCd
		oPrint:Say(475,0455,OemToAnsi(STR0025),oFont08 ) //"Codigo/Descricao"
	Endif
Else
	If mv_par04 == 1
		oPrint:Say(475,0455,OemToAnsi(STR0025),oFont08 ) //"Codigo/Descricao"
	Endif
Endif
oPrint:Say(440,1090,STR0014,oFont08 ) //"Carac."
oPrint:Say(470,1090,STR0015,oFont08 ) //" Esp  "
oPrint:Say(470,1300,STR0006,oFont08 ) //"Fornecedor"
oPrint:Say(445,1494,STR0016,oFont08 )	//"Resultados das Medicoes" 
oPrint:Say(470,1775,STR0022,oFont08 ) //"Cliente"
oPrint:Say(445,2150,STR0017,oFont08 ) //"Ok"
oPrint:Say(445,2257,STR0018,oFont08 ) //"Nao"
oPrint:Say(470,2260,STR0017,oFont08 ) //"Ok"

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Foot     ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 21.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rodape do relatorio                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Foot(ExpO1,ExpN1, ExpN2)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR180                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Foot(oPrint)

//Box 
oPrint:Box( 2890, 030, 2970, 2350 )

oPrint:Line( 2890, 1080, 2970, 1080 )		// horizontal
oPrint:Line( 2890, 2130, 2970, 2130 )   	// vertical

oPrint:Say(2900,0050,STR0023,oFont08 ) //"Assinatura do Cliente"

RestArea(aAreaQKB)

oPrint:Say(2900,1090,STR0019,oFont08 ) //"Assinatura do Fornecedor"
oPrint:Say(2940,1090,QKB->QKB_ASSFOR,oFontCou08)

oPrint:Say(2900,2140,STR0020,oFont08 ) //"Data"
oPrint:Say(2940,2140,DtoC(QKB->QKB_DTAPR),oFontCou08)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjusteSx1 ºAutor  ³Denis Martins       º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria perguntas para impressao de Codigo / Descricao de      º±±
±±º          ³Caracteristicas.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QPPR180                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjusteSx1(lBrow)
Local aHelpPor	:= {"Imprimi o Codigo/Caracteristica"}
Local aHelpSpa	:= {"Impression del Codigo/Caracteristica"}
Local aHelpEng	:= {"Print Code/Characterists"}

If !lBrow
	If lSeq
		PutSx1("ESTSEQ","04","Impr.Caracteristica?","¨Impr.Caracterist.?","Print characteris ?","mv_ch4","N",1,0,0,"C","","","","S","mv_par04","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpSpa,aHelpEng,"")	
	Else
		PutSx1("PPR180","04","Impr.Caracteristica?","¨Impr.Caracterist.?","Print characteris ?","mv_ch4","N",1,0,0,"C","","","","S","mv_par04","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpSpa,aHelpEng,"")
	Endif
Endif

Return Nil