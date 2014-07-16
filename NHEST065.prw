#INCLUDE "QPPR150.CH"
#INCLUDE "FIVEWIN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST065 ³ Autor ³Fabio Nico             ³ Data ³04/12/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ CARACTERISTICAS DE DEFEITOS                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±     
±±³ Uso      ³ ESTOQUE                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function NHEST065()

Local oPrint

Private cPecaRev := ""
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

oPrint	:= TMSPrinter():New(STR0001) 
oPrint:SetPortrait()
oPrint:Setup()

DbSelectArea("SZ8")
DbSetOrder(1)
DbGotop()

MsgRun(STR0002,"",{|| CursorWait(), MontaRel(oPrint) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."

oPrint:Preview()  		// Visualiza antes de imprimir

Return Nil

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(oPrint)

Local i 			:= 1
Local lin 			:= 240

Private oFont16, oFont08, oFont10, oFontCou08

oFont05		:= TFont():New("Arial" ,06,06,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial" ,08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFont16		:= TFont():New("Arial" ,16,16,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

Cabecalho(oPrint,i)


Do While !Eof()
	If lin > 3000
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 240
	Endif
	lin += 40
	oPrint:Say(lin,080,SZ8->Z8_COD,oFont05)
	oPrint:Say(lin,150,SZ8->Z8_DESC,oFont05)
	DbSkip()                  
	oPrint:Say(lin,680,SZ8->Z8_COD,oFont05)
	oPrint:Say(lin,750,SZ8->Z8_DESC,oFont05)
	DbSkip()                  
	oPrint:Say(lin,1280,SZ8->Z8_COD,oFont05)
	oPrint:Say(lin,1350,SZ8->Z8_DESC,oFont05)
	DbSkip()                  
	oPrint:Say(lin,1880,SZ8->Z8_COD,oFont05)
	oPrint:Say(lin,1950,SZ8->Z8_DESC,oFont05)
	DbSkip()                  
Enddo

Return Nil

//*************************************************************************************************************
// CABECALHO                                                
//*************************************************************************************************************

Static Function Cabecalho(oPrint,i)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:SayBitmap(05,0005, cStartPath+"\Whb.bmp",237,58)
oPrint:Say(040,850,'Características de defeitos ',oFont16) 
oPrint:Say(090,2000,'Pagina :',oFont08 )  //"Pagina :"
oPrint:Say(090,2200,StrZero(i,3),oFont08)      

oPrint:Say(120,50,'Hora :',oFont08 )  //"Pagina :"
oPrint:Say(120,120,Time(),oFont08)      


oPrint:Say(120,2000,'Data :',oFont08 )  //"Pagina :"
oPrint:Say(120,2200,DTOC(DATE()),oFont08)      

oPrint:Box( 150, 30, 3100, 2400 )
oPrint:Line( 150, 600, 3100, 600 )   	// vertical
oPrint:Line( 150, 1200, 3100, 1200 )   	// vertical
oPrint:Line( 150, 1800, 3100, 1800 )   	// vertical

oPrint:Say(180,0050,'Codigo    Descrição',oFont10 )
oPrint:Say(180,0650,'Codigo    Descrição',oFont10 )
oPrint:Say(180,1250,'Codigo    Descrição',oFont10 )
oPrint:Say(180,1850,'Codigo    Descrição',oFont10 )
oPrint:Line( 220, 0030, 220, 2350 )                                      

Return Nil
