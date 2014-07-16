#INCLUDE "QPPR220.CH"
#INCLUDE "PROTHEUS.CH"
                
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QPPR220  ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 26.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Certificado de Submissao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QPPR220(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PPAP                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Robson Ramiro³19.08.01³      ³  Inclusao dos dados na moldura         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Nhppa003(lBrow,cPecaAuto,cJPEG)

Local oPrint
Local lPergunte := .F.
Local cStartPath 	:= GetSrvProfString("Startpath","")

Private cPecaRev := ""

Default lBrow 		:= .F.
Default cPecaAuto 	:= ""
Default cJPEG       := ""

If !Empty(cPecaAuto)
	cPecaRev := cPecaAuto
Endif

oPrint	:= TMSPrinter():New(STR0001) //"Certificado de Submissao"
oPrint:SetPortrait()
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros							³
//³ mv_par01				// Peca       							³
//³ mv_par02				// Revisao        						³
//³ mv_par03				// Impressora / Tela          			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Empty(cPecaAuto)
	If AllTrim(FunName()) == "QPPA220"
		cPecaRev := Iif(!lBrow,M->QKI_PECA + M->QKI_REV, QKI->QKI_PECA + QKI->QKI_REV)
	Else
		lPergunte := Pergunte("PPR180",.T.)

		If lPergunte
			cPecaRev := mv_par01 + mv_par02	
		Else
			Return Nil
		Endif
	Endif
Endif
	
DbSelectArea("QK1")
DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + QK1->QK1_CODCLI + QK1->QK1_LOJCLI)

DbSelectArea("QKI")
DbSetOrder(1)
If DbSeek(xFilial()+cPecaRev)

	If Empty(cPecaAuto)
		MsgRun(STR0002,"",{|| CursorWait(), MontaRel(oPrint) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."
	Else
		MontaRel(oPrint)
	Endif

	If (lPergunte .and. mv_par03 == 1) .or. !Empty(cPecaAuto)
		If !Empty(cJPEG)
		   oPrint:SaveAllAsJPEG(cStartPath+cJPEG,865,1110,140)
		Else 
			oPrint:Print()
		EndIF
	Else
		oPrint:Preview()  		// Visualiza antes de imprimir
	Endif
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MontaRel ³ Autor ³ Robson Ramiro A. Olive³ Data ³ 26.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Certificado de Submissao                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MotaRel(ExpO1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QPPR220                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(oPrint)

Local cStartPath := GetSrvProfString("Startpath","")
Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
Local cLogoPad
Local nWeight, nWidth

Private oFont16, oFont08, oFont10, oFont12, oFontCou08

oFont16		:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina

//oPrint:SayBitmap(05,0005, cFileLogo,328,82)             // Tem que estar abaixo do RootPath
oPrint:SayBitmap(05,0005, cStartPath+"\whb.bmp",328,82)
Do Case
	Case QK1->QK1_TPLOGO == "1" 
		cLogoPad	:= "BIG3.BMP"
		nWeight		:= 370
		nWidth		:= 70
	Case QK1->QK1_TPLOGO == "2" 
		cLogoPad 	:= "CHRYSLER.BMP"
		nWeight		:= 370
		nWidth		:= 70
	Case QK1->QK1_TPLOGO == "3" 
		cLogoPad 	:= "FORD.BMP"
		nWeight		:= 160
		nWidth		:= 80
	Case QK1->QK1_TPLOGO == "4" 
		cLogoPad := "GM.BMP"
		nWeight		:= 80
		nWidth		:= 80
	Case QK1->QK1_TPLOGO == "5" 
		cLogoPad 	:= ""
		nWeight		:= 0
		nWidth		:= 0
	OtherWise
		cLogoPad	:= "BIG3.BMP"
		nWeight		:= 370 
		nWidth		:= 70
Endcase

PPAPBMP(cLogoPad, cStartPath)
oPrint:SayBitmap(80,0080, cStartPath+cLogoPad,nWeight,nWidth)
oPrint:SayBitmap(05,2100, cStartPath+"\Logo.bmp",237,58)

oPrint:Say(40,700,STR0003,oFont16 ) //"Certificado de Submissao de Peca de Producao"

oPrint:Box(160,80,2940,2300)

oPrint:Say(200,0090,STR0004,oFont10) //"Nome da Peca"
oPrint:Say(200,0340,Subs(QK1->QK1_DESC,1,55),oFontCou08 )

oPrint:Say(200,1450,STR0005,oFont10) //"Numero da Peca"
oPrint:Say(200,1740,Subs(QK1->QK1_PCCLI,1,32),oFontCou08 )

oPrint:Say(280,0090,STR0006,oFont10) //"Item de Seguranca e/ou"
oPrint:Say(330,0090,STR0007,oFont10) //"Regulamentacao Governamental"

oPrint:Say(330,0090,STR0007,oFont10) //"Regulamentacao Governamental"

oPrint:Box(330,650,380,700)
oPrint:Say(330,0670,Iif(QKI->QKI_ITSEG == "1","X"," "),oFontCou08)
oPrint:Say(330,0710,STR0008,oFontCou08) //"SIM"

oPrint:Box(330,850,380,900)
oPrint:Say(330,0870,Iif(QKI->QKI_ITSEG == "2","X"," "),oFontCou08)
oPrint:Say(330,0910,STR0009,oFontCou08) //"NAO"

oPrint:Say(330,1000,STR0010,oFont08) //"Nivel de Alteracao de Desenho de Engenharia"
oPrint:Say(330,1600,Subs(QK1->QK1_ALTENG,1,29),oFontCou08 )

oPrint:Say(330,2000,STR0011,oFont10) //"Data"
oPrint:Say(330,2090,DtoC(QK1->QK1_DTENG),oFontCou08 )

oPrint:Say(410,0090,STR0012,oFont10) //"Alteracoes Adicionais de Engenharia"
oPrint:Say(410,0680,Subs(QKI->QKI_ADENG,1,72),oFontCou08 )

oPrint:Say(410,2000,STR0011,oFont10) //"Data"
oPrint:Say(410,2090,DtoC(QKI->QKI_DTADEN),oFontCou08 )

oPrint:Say(490,0090,STR0013,oFont10) //"Exposto no Desenho No."
oPrint:Say(490,0480,QK1->QK1_NDES,oFontCou08 )

oPrint:Say(490,1000,STR0014,oFont10) //"No. Pedido de Compra"
oPrint:Say(490,1400,SubStr(QKI->QKI_PEDCOM,1,28),oFontCou08 )

oPrint:Say(490,1900,STR0015,oFont10) //"Peso"
oPrint:Say(490,1990,Alltrim(QKI->QKI_PESO)+"  Kg",oFontCou08 )

oPrint:Say(570,0090,STR0016,oFont10) //"Auxilio para Verificacao No."
oPrint:Say(570,0520,QKI->QKI_AUXVER,oFontCou08 )

oPrint:Say(570,0850,STR0085,oFont08)   // "Nivel de Alteracao de Engenharia"
oPrint:Say(570,1300,Subs(QKI->QKI_ALDMEN,1,40),oFontCou08 )

oPrint:Say(570,2000,STR0011,oFont10) //"Data"
oPrint:Say(570,2090,DtoC(QKI->QKI_DTDIME),oFontCou08 )

// Lado esquerdo
oPrint:Say(650,0090,STR0017,oFont12) //"INFORMACOES DO FORNECEDOR"

oPrint:Say(745,090,SM0->M0_NOMECOM,oFontCou08 )
oPrint:Line(770,90,770,1050) // horizontal
oPrint:Say(780,0090,STR0018,oFont10) //"Nome do Fornecedor"

oPrint:Say(780,0700,STR0019,oFont10) //"Codigo do Fornecedor"

oPrint:Say(905,090,SM0->M0_ENDCOB,oFontCou08 )
oPrint:Line(930,90,930,1050) // horizontal
oPrint:Say(940,90,STR0020,oFont10) //"Endereco"

oPrint:Say(1065,090,SM0->M0_CIDCOB+" "+SM0->M0_ESTCOB+" "+SM0->M0_CEPCOB,oFontCou08 )
oPrint:Line(1090,90,1090,1050) // horizontal
oPrint:Say(1100,90,STR0021,oFont10) //"Cidade/Estado/CEP"

// Lado direito
oPrint:Say(650,1110,STR0022,oFont12) //"INFORMACOES DA SUBMISSAO"

oPrint:Box(750,1410,800,1460)
oPrint:Say(750,1430,Iif(QKI->QKI_SUBDIM == "1","X"," "),oFontCou08)
oPrint:Say(750,1200,STR0023,oFont10) //"Dimensional"

oPrint:Box(750,1920,800,1970)
oPrint:Say(750,1940,Iif(QKI->QKI_SUBMAT == "1","X"," "),oFontCou08)
oPrint:Say(750,1600,STR0024,oFont10) //"Materiais/Funcional"

oPrint:Box(750,2170,800,2220)
oPrint:Say(750,2190,Iif(QKI->QKI_SUBAPA == "1","X"," "),oFontCou08)
oPrint:Say(750,2000,STR0025,oFont10) //"Aparencia"
                                                        
oPrint:Say(880,1110,STR0026,oFont10) //"Nome do Cliente /Divisao"
oPrint:Say(880,1520,SA1->A1_NOME,oFontCou08 )

oPrint:Say(960,1110,STR0027,oFont10) //"Comprador/Codigo do Comprador"
oPrint:Say(960,1660,Subs(QKI->QKI_COMPRA,1,36),oFontCou08 )

oPrint:Say(1040,1110,STR0028,oFont10) //"Aplicacao"
oPrint:Say(1040,1300,QKI->QKI_APLIC,oFontCou08 )

oPrint:Say(1150,090,STR0029,oFont10) //"Nota :"
oPrint:Say(1150,200,STR0030,oFont10) //"Esta peca contem alguma substancia de uso restrito ou reportavel"
oPrint:Say(1200,200,STR0031,oFont10) //"As peca plasticas sao identificadas com os codigos adequados de marcacao ISO"

oPrint:Box(1100,1700,1150,1750)
oPrint:Say(1100,1720,Iif(QKI->QKI_FLNT1 == "1","X"," "),oFontCou08)
oPrint:Say(1100,1760,STR0008,oFontCou08) //"SIM"

oPrint:Box(1100,1900,1150,1950)
oPrint:Say(1100,1920,Iif(QKI->QKI_FLNT1 == "2","X"," "),oFontCou08)
oPrint:Say(1100,1960,STR0009,oFontCou08) //"NAO"

oPrint:Box(1200,1700,1250,1750)
oPrint:Say(1200,1720,Iif(QKI->QKI_FLNT2 == "1","X"," "),oFontCou08)
oPrint:Say(1200,1760,STR0008,oFontCou08) //"SIM"

oPrint:Box(1200,1900,1250,1950)
oPrint:Say(1200,1920,Iif(QKI->QKI_FLNT2 == "2","X"," "),oFontCou08)
oPrint:Say(1200,1960,STR0009,oFontCou08) //"NAO"

oPrint:Say(1300,90,STR0032,oFont12) //"RAZAO PARA SUBMISSAO"

oPrint:Say(1360,0200,STR0033,oFont10) //"Submissao Inicial"
oPrint:Say(1360,1300,STR0034,oFont10) //"Alteracao de Material ou Construcao Opcional"

oPrint:Say(1410,0200,STR0035,oFont10) //"Alteracoes da Engenharia"
oPrint:Say(1410,1300,STR0036,oFont10) //"Alteracao do Subfornecedor ou Fonte do Material"

oPrint:Say(1460,0200,STR0037,oFont10) //"Ferramental: Transferencia, Reposicao, Reparo ou Adicional"
oPrint:Say(1460,1300,STR0038,oFont10) //"Alteracao do Processo de Fabricacao da Peca"

oPrint:Say(1510,0200,STR0039,oFont10) //"Correcao de Discrepancia"
oPrint:Say(1510,1300,STR0040,oFont10) //"Pecas Produzidas em outra Localidade"
                                                                     
oPrint:Say(1560,0200,STR0041,oFont10) //"Ferramental Inativo por mais de 1 ano"
oPrint:Say(1560,1300,STR0042,oFont10) //"Outros - Especifique:"

oPrint:Box(1360,130,1610,180)	// Box das questoes lado esquerdo
oPrint:Line(1410,130,1410,180)	// horizontal
oPrint:Line(1460,130,1460,180)	// horizontal
oPrint:Line(1510,130,1510,180)	// horizontal
oPrint:Line(1560,130,1560,180)	// horizontal

oPrint:Box(1360,1230,1610,1280)	// Box das questoes lado direito
oPrint:Line(1410,1230,1410,1280)	// horizontal
oPrint:Line(1460,1230,1460,1280)	// horizontal
oPrint:Line(1510,1230,1510,1280)	// horizontal
oPrint:Line(1560,1230,1560,1280)	// horizontal


If !Empty(QKI->QKI_FLRZSU)
	Do Case
		Case QKI->QKI_FLRZSU == "A"
			oPrint:Say(1360,150,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "B"
			oPrint:Say(1410,150,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "C"
			oPrint:Say(1460,150,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "D"
			oPrint:Say(1510,150,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "E"
			oPrint:Say(1560,150,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "F"
			oPrint:Say(1360,1250,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "G"
			oPrint:Say(1410,1250,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "H"
			oPrint:Say(1460,1250,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "I"
			oPrint:Say(1510,1250,"X",oFontCou08)
		Case QKI->QKI_FLRZSU == "J"
			oPrint:Say(1560,1250,"X",oFontCou08)
			oPrint:Say(1560,1680,Subs(QKI->QKI_OUTRO1,1,32),oFontCou08)
	Endcase
Endif

oPrint:Say(1660,90,STR0043,oFont12) //"NIVEL DE SUBMISSAO (Marque um)"

oPrint:Say(1710,200,STR0044,oFont08) //"Nivel 1 - Certificado apenas(e para itens de aparencia designados, um Relatorio de Aprovacao de Aparencia) submetidos ao cliente"
oPrint:Say(1760,200,STR0045,oFont08) //"Nivel 2 - Certificado com amostras do produto e dados limitados de suporte submetidos ao cliente"
oPrint:Say(1810,200,STR0046,oFont08) //"Nivel 3 - Certificado com amostras do produto e todos os dados de suporte submetidos ao cliente"
oPrint:Say(1860,200,STR0047,oFont08) //"Nivel 4 - Certificado e outros requisitos conforme definido pelo cliente"
oPrint:Say(1910,200,STR0048,oFont08) //"Nivel 5 - Certificado com amostras do produto e todos os dados de suporte verificados na localidade de manufatura do fornecedor"

oPrint:Box(1710,130,1960,180)	// Box do Nivel 
oPrint:Line(1760,130,1760,180)	// horizontal
oPrint:Line(1810,130,1810,180)	// horizontal
oPrint:Line(1860,130,1860,180)	// horizontal
oPrint:Line(1910,130,1910,180)	// horizontal


If !Empty(QKI->QKI_FLNISU)
	Do Case
		Case QKI->QKI_FLNISU == "1"
			oPrint:Say(1710,150,"X",oFontCou08)
		Case QKI->QKI_FLNISU == "2"
			oPrint:Say(1760,150,"X",oFontCou08)
		Case QKI->QKI_FLNISU == "3"
			oPrint:Say(1810,150,"X",oFontCou08)
		Case QKI->QKI_FLNISU == "4"
			oPrint:Say(1860,150,"X",oFontCou08)                         
		Case QKI->QKI_FLNISU == "5"
			oPrint:Say(1910,150,"X",oFontCou08)
	Endcase
Endif

oPrint:Say(2010,90,STR0049,oFont12) //"RESULTADOS DA SUBMISSAO"

oPrint:Say(2070,100,STR0050,oFont08)	//"Os resultados de "

oPrint:Box(2060,320,2110,370)			// Box dos Check 1
oPrint:Say(2070,380,STR0051,oFont08)	// "medicoes dimensionais "

oPrint:Box(2060,690,2110,740)			// Box dos Check 2
oPrint:Say(2070,750,STR0052,oFont08)	//" ensaios de materiais e funcionias "

oPrint:Box(2060,1190,2110,1240)		// Box dos Check 3
oPrint:Say(2070,1250,STR0053,oFont08)	//" criterios de aparencia  "

oPrint:Box(2060,1540,2110,1590)		// Box dos Check 4
oPrint:Say(2070,1600,STR0054,oFont08)	//" dados estatisticos "

oPrint:Say(2070,0340,Iif(QKI->QKI_RESDIM == "1","X"," "),oFontCou08)
oPrint:Say(2070,0710,Iif(QKI->QKI_RESMAT == "1","X"," "),oFontCou08)
oPrint:Say(2070,1210,Iif(QKI->QKI_RESAPA == "1","X"," "),oFontCou08)
oPrint:Say(2070,1560,Iif(QKI->QKI_RESEST == "1","X"," "),oFontCou08)

oPrint:Say(2120,0100,STR0055,oFont08) 	//"Estes resultados atendem a todos os requisitos do desenho e de especificacoes:   "

oPrint:Box(2120,1150,2170,1200)		// Box sim
oPrint:Say(2120,1200,STR0056,oFont08) 	//" SIM "
oPrint:Say(2120,1170,Iif(QKI->QKI_REQUIS == "1","X"," "),oFontCou08)

oPrint:Box(2120,1350,2170,1400)		// Box nao
oPrint:Say(2120,1400,STR0057,oFont08) 	//" NAO "
oPrint:Say(2120,1370,Iif(QKI->QKI_REQUIS == "2","X"," "),oFontCou08)

oPrint:Say(2120,1500,STR0084,oFont08) 	//'  (Se "NAO" - Explicar abaixo)'

oPrint:Say(2170,100,STR0058,oFont08) //"Moldes / Cavidades / Processo de Producao :"
oPrint:Say(2170,700,QKI->QKI_MOLDE,oFontCou08 )

oPrint:Say(2250,90,STR0059,oFont12) //"DECLARACAO"

oPrint:Say(2300,100,STR0060,oFont08) //"Por meio deste afirmo que as amostras representadas por este certificado sao representativas das nossas pecas e foram fabricadas conforme os"
oPrint:Say(2350,100,STR0061,oFont08) //"requisitos aplicaveis do Manual do Processo de Aprovacao de Producao 3a. edicao. Alem disso certifico que estas amostras foram"
oPrint:Say(2400,100,STR0062+AllTrim(QKI->QKI_TXPROD)+STR0063,oFont08) //"produzidas a uma taxa de producao de  "###" / 8 horas. Eu anotei qualquer desvio desta declaracao abaixo:"

oPrint:Say(2460,100,STR0064,oFont08) //"Explicacoes/Comentarios"
oPrint:Say(2460,500,SubStr(QKI->QKI_COMENT,1,100),oFontCou08 )

oPrint:Say(2520,100,STR0065,oFont08) //"Nome"
oPrint:Say(2520,200,QKI->QKI_NOMAPR,oFontCou08 )

oPrint:Say(2520,1000,STR0066,oFont08) //"Cargo"
oPrint:Say(2520,1100,SubStr(QKI->QKI_CARAPR,1,34),oFontCou08 )

oPrint:Say(2520,1700,STR0067,oFont08) //"Telefone"
oPrint:Say(2520,1850,QKI->QKI_TELAPR,oFontCou08 )

oPrint:Say(2580,0100,STR0068,oFont08) //"Assinatura Autorizada do Fornecedor"
oPrint:Say(2580,2000,STR0011,oFont08) //"Data"
oPrint:Say(2580,2090,DtoC(QKI->QKI_DTAPR),oFontCou08 )

oPrint:Line(2630,80,2630,2300) // horizontal

oPrint:Say(2650,700,STR0069,oFont12) //"PARA USO DO CLIENTE APENAS (SE APLICAVEL)"

oPrint:Say(2700,0090,STR0070,oFont10) //"Disposicao do Certificado da Peca:"

oPrint:Say(2700,0700,STR0071,oFont10) //"Aprovado"
oPrint:Say(2700,1000,STR0072,oFont10) //"Rejeitado"
oPrint:Say(2760,0700,STR0073,oFont10) //"Outros"

oPrint:Box(2700,640,2810,690)		// Box Disposicao
oPrint:Box(2700,930,2750,980)
oPrint:Line(2750,640,2750,690)		// horizontal


If !Empty(QKI->QKI_DISCLI)
	If	QKI->QKI_DISCLI == "1"
		oPrint:Say(2700,0650,"X",oFontCou08)
	Elseif	QKI->QKI_DISCLI == "2"
		oPrint:Say(2700,0950,"X",oFontCou08)
	Elseif	QKI->QKI_DISCLI == "3"
		oPrint:Say(2760,0650,"X",oFontCou08)
		oPrint:Say(2760,0850,QKI->QKI_OUTRO2,oFontCou08)
	Endif
Endif

oPrint:Say(2700,1350,STR0074,oFont10) //"Aprovacao Funcional da Peca:"

oPrint:Say(2700,1900,STR0071,oFont10) //"Aprovado"
oPrint:Say(2760,1900,STR0075,oFont10) //"Dispensado"

oPrint:Box(2700,1840,2810,1890)		// Box Disposicao
oPrint:Line(2750,1840,2750,1890)		// horizontal


If !Empty(QKI->QKI_APRFUN)
	If	QKI->QKI_APRFUN == "1"
		oPrint:Say(2700,1850,"X",oFontCou08)
	Elseif	QKI->QKI_APRFUN == "2"
		oPrint:Say(2760,1850,"X",oFontCou08)
	Endif
Endif
	 
			
oPrint:Line(2700,1300,2750,1300) // vertical

oPrint:Say(2860,090,STR0076,oFont10) //"Repres. Cliente"
oPrint:Say(2860,400,QKI->QKI_REPCLI,oFontCou08 )

oPrint:Say(2860,1100,STR0077,oFont10)   //"Assinatura do Cliente"

oPrint:Say(2860,2000,STR0011,oFont10) //"Data"
oPrint:Say(2860,2090,DtoC(QKI->QKI_DTRCLI),oFontCou08 )

oPrint:Say(2950,90,STR0078,oFont08) //"Julho"
oPrint:Say(2990,90,"1999",oFont08)

oPrint:Say(2980,200,STR0079,oFont10) //"CFG-1001"

oPrint:Say(2950,700,STR0080, oFont08) //"A copia original desse documento deve permanecer nas instalacoes"
oPrint:Say(2980,700,STR0081, oFont08) //"do fornecedor enquanto a peca estiver ativa (veja Glossario)"

oPrint:Say(2950,1800,STR0082, oFont08) //"Opcional: Numero de Rastreamento"
oPrint:Say(2980,1800,STR0083, oFont08) //"do Cliente:#"
oPrint:Say(2980,1970,Subs(QK1->QK1_PPAP,1,10), oFont08)

oPrint:EndPage() 		// Finaliza a pagina     

Return Nil
