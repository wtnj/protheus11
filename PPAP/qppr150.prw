#INCLUDE "QPPR150.CH"
#INCLUDE "FIVEWIN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QPPR150  ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 27.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Diagrama de Fluxo                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QPPR150(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PPAP                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Robson Ramiro³15.10.02³      ³ Inclusao de legenda, impressao das     ³±±
±±³              ³        ³      ³ observacoes e impressao na mBrowse     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function QPPR150(lBrow)

Local oPrint
Local lPergunte	:= .F.
Local cFiltro	:= ""
Local aArea		:= GetArea()

Private cPecaRev 	:= ""
Private cStartPath 	:= GetSrvProfString("Startpath","")

Default lBrow := .F.

oPrint	:= TMSPrinter():New(STR0001) //"Diagrama de Fluxo"

oPrint:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros							³
//³ mv_par01				// Peca       							³
//³ mv_par02				// Revisao        						³
//³ mv_par03				// Impressora / Tela          			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If AllTrim(FunName()) == "QPPA150"
	cPecaRev := Iif(!lBrow, M->QKN_PECA + M->QKN_REV, QKN->QKN_PECA + QKN->QKN_REV)
Else
	lPergunte := Pergunte("PPR180",.T.)

	If lPergunte
		cPecaRev := mv_par01 + mv_par02	
	Else
		Return Nil
	Endif
Endif
	
DbSelectArea("QK1")
DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

DbSelectArea("QKN")

cFiltro := DbFilter()

If !Empty(cFiltro)
	Set Filter To
Endif

DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

MsgRun(STR0002,"",{|| CursorWait(), MontaRel(oPrint) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."

If lPergunte .and. mv_par03 == 1
	oPrint:Print()
Else
	oPrint:Preview()  		// Visualiza antes de imprimir
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
±±³Descricao ³Digrama de Fluxo                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MontaRel(ExpO1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(oPrint)

Local i 			:= 1
Local lin 			:= 500

Private oFont16, oFont08, oFont10, oFontCou08

oFont16		:= TFont():New("Arial" ,16,16,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial" ,08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

Cabecalho(oPrint,i)  			// Funcao que monta o cabecalho

DbSelectArea("QKN")

Do While !Eof() .and. QKN->QKN_PECA+QKN->QKN_REV == cPecaRev

	If lin > 2720
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 500
	Endif
	
	lin += 90
	oPrint:SayBitmap(lin,050, cStartPath+QKN->QKN_SIMB1+".BMP",80,80)
	If !Empty(QKN->QKN_SIMB2)
		oPrint:SayBitmap(lin,150, cStartPath+QKN->QKN_SIMB2+".BMP",80,80)
	Endif
	
	oPrint:Say(lin,0260,QKN->QKN_NOPE,oFont10)
	oPrint:Say(lin,0340,Subs(QKN->QKN_DESC,1,30),oFont10)

	If Len(QKN->QKN_DESC) > 30
		oPrint:Say(lin+40,0340,Subs(QKN->QKN_DESC,30,20),oFont10)
	Endif

	DbSelectArea("QKO")
	DbSetOrder(1)
	If DbSeek(xFilial("QKO")+"QPPA150 " + QKN->QKN_CHAVE)
		Do While !Eof() .and. xFilial("QKO") == QKO->QKO_FILIAL .and. ;
					QKO->QKO_CHAVE == QKN->QKN_CHAVE .and.;
					QKO->QKO_ESPEC == "QPPA150 "

			If !Empty(QKO->QKO_TEXTO)
				oPrint:Say(lin,1050,QKO->QKO_TEXTO,oFontCou08)
				lin += 40
				If lin > 2720
					i++
					oPrint:EndPage() 		// Finaliza a pagina
					Cabecalho(oPrint)  		// Funcao que monta o cabecalho
					lin := 500
				Endif
			Endif	

			DbSkip()
		Enddo
	Endif	

	DbSelectArea("QKN")

	DbSkip()

Enddo

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Cabecalho³ Autor ³ Robson Ramiro A. Olive³ Data ³ 27.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cabecalho do relatorio                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cabecalho(ExpO1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cabecalho(oPrint,i)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina

oPrint:SayBitmap(05,0005, cFileLogo,328,82)             // Tem que estar abaixo do RootPath
oPrint:SayBitmap(05,2100, cStartPath+"\Logo.bmp",237,58)

oPrint:Say(040,700,STR0003,oFont16) //"DIAGRAMA DE FLUXO DO PROCESSO"

oPrint:Say(040,1800,STR0014,oFont08 )  //"PPAP No."
oPrint:Say(040,1950,QK1->QK1_PPAP,oFont08)

oPrint:Say(090,1800,STR0004,oFont08 )  //"Pagina :"
oPrint:Say(090,1950,StrZero(i,3),oFont08)

//Box Cabecalho
oPrint:Box( 150, 30, 310, 2350 )

//Box Itens
oPrint:Box( 330, 30, 2890, 2350 )

// Construcao da Grade cabecalho
oPrint:Line( 230, 0030, 230, 2350 )   	// horizontal

oPrint:Line( 150, 1400, 310, 1400 )   	// vertical
                                                 
oPrint:Line( 150, 1875, 230, 1875 )   	// vertical

oPrint:Line( 230, 685, 310, 685 )   	// vertical  

// Construcao da Grade itens
oPrint:Line( 430, 0030, 430, 2350 )    // horizontal

oPrint:Line( 530, 0030, 530, 2350 )    // horizontal

// Descricao do Cabecalho
oPrint:Say(160,0040,STR0005,oFont08 )  //"Fornecedor"
oPrint:Say(200,0040,SM0->M0_NOMECOM,oFontCou08)

oPrint:Say(160,1410,STR0006,oFont08 )  //"Numero da Peca(Cliente)"
oPrint:Say(200,1410,Subs(QK1->QK1_PCCLI,1,27),oFontCou08)

oPrint:Say(160,1885,STR0007,oFont08 )  //"Revisao/Data Desenho"
oPrint:Say(200,1885,AllTrim(QK1->QK1_REVDES)+" / "+DtoC(QK1->QK1_DTRDES),oFontCou08)
                                                     
oPrint:Say(240,0040,STR0008,oFont08 ) //"Aprovado Por / Data"
oPrint:Say(280,0045,AllTrim(QKN->QKN_APRPOR) +" / "+ DtoC(QKN->QKN_DTAPR),oFontCou08)

oPrint:Say(240,0695,STR0009,oFont08 ) //"Numero/Rev Peca(Fornecedor)"
oPrint:Say(280,0695,AllTrim(QK1->QK1_PECA)+"/"+ QK1->QK1_REV,oFontCou08)

oPrint:Say(240,1410,STR0010,oFont08 ) //"Nome da Peca"
oPrint:Say(280,1410,Subs(QK1->QK1_DESC,1,50),oFontCou08)

// Legenda
oPrint:SayBitmap(360,0040,cStartPath+"A3.BMP",60,60)
oPrint:SayBitmap(360,0425,cStartPath+"F1.BMP",60,60)
oPrint:SayBitmap(360,0810,cStartPath+"B4.BMP",60,60)
oPrint:SayBitmap(360,1195,cStartPath+"C7.BMP",60,60)
oPrint:SayBitmap(360,1580,cStartPath+"E8.BMP",60,60)
oPrint:SayBitmap(360,1965,cStartPath+"D9.BMP",60,60)

oPrint:Say(375,0110,STR0015,oFont08) //"Operacao"
oPrint:Say(375,0495,STR0016,oFont08) //"Operacao c/ Inspecao"
oPrint:Say(375,0880,STR0017,oFont08) //"Inspecao"
oPrint:Say(375,1265,STR0018,oFont08) //"Estocagem"
oPrint:Say(375,1650,STR0019,oFont08) //"Transporte"
oPrint:Say(375,2035,STR0020,oFont08) //"Decisao"

// Descricao dos itens
oPrint:Say(470,0050,STR0011,oFont10) //"Fluxo"
oPrint:Say(470,0260,STR0012,oFont10) //"No."
oPrint:Say(470,0450,STR0013,oFont10) //"Descricao da Operacao"
oPrint:Say(470,1500,STR0021,oFont10) //"Observacoes"

Return Nil