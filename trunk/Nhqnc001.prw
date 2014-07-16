/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQNC001  ºAutor  ³Marcos R Roquitski  º Data ³  26/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ficha de Ocorrencias/Nao-conformidade-Grafico/Custos.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QNCR050  ³ Autor ³ Aldo Marini Junior    ³ Data ³ 23.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Ficha de Ocorrencias/Nao-conformidades-Grafico³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QNCR050(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Nhqnc001(nRegImp)

Private nLastKey:= 0
Private cPerg   := "QNR050"
Private Titulo	 := "FICHA DE OCORRENCIAS/NAO-CONFORMIDADES"
Private nLiG    := 2900
Private nPag    := 1
Private lPagPrint := .T.
Default nRegImp := 0

INCLUI := .F.	// Utilizado devido algumas funcoes de retorno de descricao/nome
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Ano De                                   ³
//³ mv_par04        //  Ano Ate             			              ³
//³ mv_par05        //  Codigo FNC De     	                    ³
//³ mv_par06        //  Codigo FNC Ate                           ³
//³ mv_par07        //  Revisao De                               ³
//³ mv_par08        //  Revisao Ate                              ³
//³ mv_par09        //  Tipo 1-N.C.Potencial/2-N.C.Existente/3-Melhoria/4-Ambas ³
//³ mv_par10        //  Plano de Acao Relac. 1-Sim/2-Nao         ³
//³ mv_par11        //  Visualiza antes        1-Sim/2-Nao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nRegImp == 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lOkPrint := pergunte("QNR050",.T.)

	If !lOkPrint
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilDe   := mv_par01
	cFilAte  := mv_par02
	cAnoDe   := mv_par03
	cAnoAte  := mv_par04
	cFNCDe   := mv_par05
	cFNCAte  := mv_par06
	cRevDe   := mv_par07
	cRevAte  := mv_par08
	nTipo    := mv_par09
	nRelac   := mv_par10
	nView    := mv_par11

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("QNR050",.F.)
	cFilDe   := QI2->QI2_FILIAL
	cFilAte  := QI2->QI2_FILIAL
	cAnoDe   := QI2->QI2_ANO
	cAnoAte  := QI2->QI2_ANO
	cFNCDe   := QI2->QI2_FNC
	cFNCAte  := QI2->QI2_FNC
	cRevDe   := QI2->QI2_REV
	cRevAte  := QI2->QI2_REV
	nTipo    := Val(QI2->QI2_TPFIC)
	nRelac   := 1
	nView    := 1
   
Endif

RptStatus({|lEnd| QNCR050Imp(@lEnd)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Volta o registro correspondente a FNC quando a impressao for ³
//³ selecionada via cadastro.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nRegImp > 0
	dbSelectArea("QI2")
	dbSetOrder( 1 )
	dbGoTo(nRegImp)
Endif

dbSelectArea("QI3")
dbSetOrder( 1 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QNCR050Imp³ Autor ³ Aldo Marini Junior    ³ Data ³ 23.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ficha de Ocorrencias/Nao-conformidades                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³QNCR050Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QNCR050                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QNCR050Imp(lEnd)
Local nColT    := 0
Local cTxtDet  := ""
Local nLig1    := 0
Local nLig2    := 0
Local aPlanos := {}
Local aCustos := {}
Local nT
Local nA
Local _cDescQb := Space(50)
Local _nTotCusto := 0

Private oFont08, oFont10, oFont15, oFont10n, oFont20
Private oQPrint
Private lFirst   := .T.
Private aStatus  := {OemtoAnsi("Registrada"),OemToAnsi("Em Analise"),OemToAnsi("Procede"),OemToAnsi("Nao Procede"),OemToAnsi("Cancelada")}	// "Registrada" ### "Em Analise" ### "Procede" ### "Nao Procede" ### "Cancelada"
Private aPriori  := {}
Private lInicial := .F.

Private cFileLogo  := ""
Private cFilOld    := cFilAnt
Private cNomFilial := ""

oFont06	:= TFont():New("Courier New",06,08,,.T.,,,,.T.,.F.)
oFont10	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont10n:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oFont15	:= TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.)
oFont20	:= TFont():New("Courier New",20,20,,.T.,,,,.T.,.F.)
// 5o. Bold
// 9o. Italico
//10o. Underline

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o conteudo do X3_CBOX no array                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QNCCBOX("QI2_PRIORI",@aPriori)

QI9->(dbSetOrder(2))	// Buscar por FNC

dbSelectArea( "QI2" )
dbGoTop()

dbSetOrder( 1 )
dbSeek(IF(Empty(xFilial("QI2")),xFilial("QI2"),cFilDe) + cAnoDe + cFNCDe + cRevDe,.T.)
cInicio  := "QI2->QI2_FILIAL + QI2->QI2_ANO + QI2->QI2_FNC + QI2->QI2_REV"
cFim     := IF(Empty(xFilial("QI2")),xFilial("QI2"),cFilAte) + cAnoAte + cFNCAte + cRevAte

cFileLogo  := "LGRL"+SM0->M0_CODIGO
cFilOld    := QI2->QI2_FILIAL

If Empty(xFilial("QI2"))
	cFileLogo += SM0->M0_CODFIL+".BMP"
Else
	cFileLogo += QI2->QI2_FILIAL+".BMP"
Endif

If !File( cFileLogo )
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua de Processamento                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(QI2->(RecCount()))
SX5->(DbSetOrder(1))

While !EOF() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	( QI2->QI2_ANO < cAnoDe ) .Or. ( QI2->QI2_ANO > cAnoAte ) .Or. ;
		( QI2->QI2_REV < cRevDe ) .Or. ( QI2->QI2_REV > cRevAte ) .Or. ;
	 	( Right(Alltrim(QI2->QI2_FNC),4) + Left(QI2->QI2_FNC,6) < Right(Alltrim(cFNCDe ),4) + Left(cFNCDe ,6) ) .Or. ;
	 	( Right(Alltrim(QI2->QI2_FNC),4) + Left(QI2->QI2_FNC,6) > Right(Alltrim(cFNCAte),4) + Left(cFNCAte,6) )
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Consiste o tipo de Ficha de Ocorrencia/Nao-conformidade      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo <> 4 .And. Val(QI2->QI2_TPFIC) <> nTipo
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Quebra de Pagina e imprime cabecalho                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLig := 2900
	nPag := 1

	cNomFilial := AllTrim(QA_CHKFIL(QI2->QI2_FILIAL,,.T.))
	If !Empty(cFilOld) .And. cFilOld <> QI2->QI2_FILIAL
        cFilOld    := QI2->QI2_FILIAL
		cFileLogo  := "LGRL"+SM0->M0_CODIGO+QI2->QI2_FILIAL+".BMP"
		If !File( cFileLogo )
			cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao Detalhada                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTxtDet  := MSMM(QI2->QI2_DDETA)
	If !Empty(cTxtDet)
		aTxtDet := {}
		Q_MemoArray(cTxtDet, @aTxtDet, 100)

		If Len(aTxtDet) > 0
			QNCR050LIN("T",nLig,30,OemToAnsi("Descricao Detalhada"),oFont10n) // "Descricao Detalhada"
			nLig += 40
			nLig2 := 540+(Len(aTxtDet)*40)+80
			nLig2 := If(nLig2>=2900,2930,nLig2)
			QNCR050LIN("B",,,,,,OemToAnsi("Descricao Detalhada"),nLig,30,nLig2,2350)// "Descricao Detalhada"
			nLig1 := nLig 	// Pula de 40 em 40
			nLig += 20
			nColT := 1
			For nT:=1 to Len(aTxtDet)
				QNCR050LIN("T",nLig,50,aTxtDet[nT],oFont10,Len(aTxtDet)-nT+1,OemToAnsi("Descricao Detalhada")) // "Descricao Detalhada"
	            nLig+=40
			Next
			nLig+=40
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao dos Comentarios                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTxtDet := MSMM(QI2->QI2_COMEN)
	If !Empty(cTxtDet)
		If nLig+110 >= 2900
			nLig := 2900
		Endif

		aTxtDet := {}
		Q_MemoArray(cTxtDet, @aTxtDet, 100)

		If Len(aTxtDet) > 0
			nLig += 50
			QNCR050LIN("T",nLig,30,OemToAnsi("Comentarios"),oFont10n,,OemToAnsi("Comentarios")) // "Comentarios"
			nLig += 40
			nLig2:= nLig+(Len(aTxtDet)*40)+80
			nLig2:= If(nLig2>=2900,2930,nLig2)
			QNCR050LIN("B",,,,,,OemToAnsi("Comentarios"),nLig,30,nLig2,2350) // "Comentarios"
			nLig1 := nLig 	// Pula de 40 em 40
			nLig += 20
			nColT := 1
			For nT:=1 to Len(aTxtDet)
				QNCR050LIN("T",nLig,50,aTxtDet[nT],oFont10,Len(aTxtDet)-nT+1,OemToAnsi("Comentarios")) // "Comentarios"
				nLig+=40
			Next
			nLig+=40
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao da Disposicao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTxtDet := MSMM(QI2->QI2_DISPOS)
	If !Empty(cTxtDet)
		If nLig+110 >= 2900
			nLig := 2900
		Endif

		aTxtDet := {}
		Q_MemoArray(cTxtDet, @aTxtDet, 100)

		If Len(aTxtDet) > 0
			nLig += 50
			QNCR050LIN("T",nLig,30,OemToAnsi("Disposicao"),oFont10n,,OemToAnsi("Disposicao")) // "Disposicao"
			nLig += 40
			nLig2 := nLig+(Len(aTxtDet)*40)+80
			nLig2 := If(nLig2>=2900,2930,nLig2)
			QNCR050LIN("B",,,,,,OemToAnsi("Disposicao"),nLig,30,nLig2,2350) // "Disposicao"
			nLig1 := nLig 	// Pula de 40 em 40
			nLig += 20
			nColT := 1
			For nT:=1 to Len(aTxtDet)
				QNCR050LIN("T",nLig,50,aTxtDet[nT],oFont10,Len(aTxtDet)-nT+1,OemToAnsi("Disposicao")) // "Disposicao"
				nLig+=40
			Next
			nLig+=40
		Endif
	Endif

	nLig += 50

	If nLig+295 >= 2900
		nLig := 2900
	Endif

	QNCR050LIN("T",nLig,30,OemToAnsi("Analise"),oFont10n,,OemToAnsi("Analise"))	// "Analise"
	nLig += 40
	nLig1 := nLig	// 2200
	nLig2 := nLig+255
	QNCR050LIN("B",,,,,,,nLig,30,nLig2,2350)
	nLig += 85	// 2285
	QNCR050LIN("L",,,,,,,nLig,30,nLig,2350)
	nLig += 85	// 2370
	QNCR050LIN("L",,,,,,,nLig,30,nLig,2350)
	QNCR050LIN("L",,,,,,,nLig1,1175,nLig,1175)

	nLig := nLig1+5
	QNCR050LIN("T",nLig,40,OemToAnsi("Disposicao"),oFont06)	// "Disposicao"

	nLig +=40
	QNCR050LIN("T",nLig,40,QI2->QI2_CODDIS+"-"+PADR(FQNCCHKDIS(QI2->QI2_CODDIS),40),oFont10)

	nLig := nLig1+5

	QNCR050LIN("T",nLig,1190,OemToAnsi("Origem"),oFont06)  // "Origem"
	nLig +=40
	QNCR050LIN("T",nLig,1190,QI2->QI2_CODORI+"-"+PADR(FQNCNTAB("3",QI2->QI2_CODORI),40),oFont10)

	nLig1 += 90
	nLig := nLig1
	QNCR050LIN("T",nLig,40,OemToAnsi("Causa"),oFont06)  // "Causa"
	nLig +=40
	QNCR050LIN("T",nLig,40,QI2->QI2_CODCAU+"-"+PADR(FQNCNTAB("1",QI2->QI2_CODCAU),40),oFont10)

	nLig := nLig1
	QNCR050LIN("T",nLig,1190,OemToAnsi("Efeito"),oFont06)  // "Efeito"
	nLig +=40
	QNCR050LIN("T",nLig,1190,QI2->QI2_CODEFE+"-"+PADR(FQNCNTAB("2",QI2->QI2_CODEFE),40),oFont10)

	nLig1 += 90
	nLig := nLig1
	QNCR050LIN("T",nLig,40,OemToAnsi("Categoria FNC"),oFont06)  // "Categoria FNC"
	nLig +=40
	QNCR050LIN("T",nLig,40,QI2->QI2_CODCAT+"-"+PADR(FQNCNTAB("4",QI2->QI2_CODCAT),50),oFont10)
	nLig := nLig2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime os Plano de Acao Relacionadas                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nRelac == 1	// Sim
		
		If QI9->(dbSeek(QI2->QI2_FILIAL + QI2->QI2_FNC + QI2->QI2_REV))
			aPlanos := {}
			While !Eof() .And. QI9->QI9_FILIAL + QI9->QI9_FNC + QI9->QI9_REVFNC == QI2->QI2_FILIAL + QI2->QI2_FNC + QI2->QI2_REV
				IF QI3->(dbSeek(QI9->QI9_FILIAL+Right(QI9->QI9_CODIGO,4)+QI9->QI9_CODIGO+QI9->QI9_REV))
					aAdd(aPlanos,{ QI3->QI3_CODIGO,QI3->QI3_REV,QI3->QI3_FILMAT,QI3->QI3_MAT,QI3->QI3_ABERTU,QI3->QI3_ENCPRE,QI3->QI3_ENCREA })
				Endif
				QI9->(dbSkip())
			Enddo
			If Len(aPlanos) > 0
				nLig += 50
				If nLig+100 >= 2900
					nLig := 2900
				Endif
				QNCR050LIN("T",nLig,30,OemToAnsi("Plano de Acao Relacionados"),oFont10n)	// "Plano de Acao Relacionados"
				nLig += 40
				nLigf := nLig+(40*Len(aPlanos))+80
				nLigf := If(nLigf>=2900,2930,nLigf)
				QNCR050LIN("B",,,,,,,nLig,30,nLigf,2350)

				nLig1 := nLig
				nLig += 20

				QNCR050LIN("T",nLig,  40,OemToAnsi("No.Pl.Acao Rv"),oFont10n)	 // "No.Pl.Acao Rv"
				QNCR050LIN("T",nLig, 370,OemToAnsi("Originador"),oFont10n)	// "Originador"
				QNCR050LIN("T",nLig,1310,OemToAnsi("Dt.Abertura"),oFont10n)	// "Dt.Abertura"
				QNCR050LIN("T",nLig,1660,OemToAnsi("Dt.Encerr.Prev."),oFont10n)	// "Dt.Encerr.Prev."
				QNCR050LIN("T",nLig,2010,OemToAnsi("Dt.Encerr.Real"),oFont10n)	// "Dt.Encerr.Real"
																
				nLig += 40
				QNCR050LIN("L",,,,,,,nLig,30,nLig,2350)

				QNCR050LIN("L",,,,,,,nLig1, 360,nLigf, 360)
				QNCR050LIN("L",,,,,,,nLig1,1300,nLigf,1300)
				QNCR050LIN("L",,,,,,,nLig1,1650,nLigf,1650)
				QNCR050LIN("L",,,,,,,nLig1,2000,nLigf,2000)                   	
																
				nLig1 := nLig 	// Pula de 40 em 40
				nLig += 20
				nColT := 1

				For nA:=1 to Len(aPlanos)

					QNCR050LIN("T",nLig,  40,Transform(aPlanos[nA,1],"@r 999999/9999")+" "+aPlanos[nA,2],oFont10,Len(aPlanos)-nA+1,OemToAnsi("---"),,,,,.T.)
					QNCR050LIN("T",nLig, 370,Padr(QA_NUSR(aPlanos[nA,3],aPlanos[nA,4],.F.),30),oFont10,Len(aPlanos)-nA+1,OemToAnsi("---"),,,,,.T.)
					QNCR050LIN("T",nLig,1310,PADR(DTOC(aPlanos[nA,5]),10),oFont10,,OemToAnsi("---"),Len(aPlanos)-nA+1,,,,.T.)
					QNCR050LIN("T",nLig,1660,PADR(DTOC(aPlanos[nA,6]),10),oFont10,,OemToAnsi("---"),Len(aPlanos)-nA+1,,,,.T.)
					QNCR050LIN("T",nLig,2010,PADR(DTOC(aPlanos[nA,7]),10),oFont10,,OemToAnsi("---"),Len(aPlanos)-nA+1,,,,.T.)
									
					nLig+=40
				Next
			Endif
		Endif
	
	
		// Custos
		If QI9->(dbSeek(QI2->QI2_FILIAL + QI2->QI2_FNC + QI2->QI2_REV))

 			If QI8->(dbSeek(QI9->QI9_FILIAL + QI9->QI9_CODIGO + QI9->QI9_REV))
				aCustos := {}
				While !Eof() .And. QI8->QI8_FILIAL + QI8->QI8_CODIGO + QI8->QI8_REV == QI9->QI9_FILIAL + QI9->QI9_CODIGO + QI9->QI9_REV
					aAdd(aCustos,{ QI8->QI8_CUSTO,QI8->QI8_VLCUST })
					QI8->(dbSkip())
				Enddo
	
				If Len(aCustos) > 0
					nLig += 50
					If nLig+100 >= 2900
						nLig := 2900
					Endif
					QNCR050LIN("T",nLig,30,OemToAnsi("Custos"),oFont10n)
					nLig += 40
					nLigf := nLig+(40*Len(aCustos)+2)+80
					nLigf := If(nLigf>=2900,2930,nLigf)
					QNCR050LIN("B",,,,,,,nLig,30,nLigf,2350)

					nLig1 := nLig
					nLig += 20

					QNCR050LIN("T",nLig,  40,OemToAnsi("Codigo Custo"),oFont10n)
					QNCR050LIN("T",nLig, 370,OemToAnsi("Descricao"),oFont10n)
					QNCR050LIN("T",nLig,2010,OemToAnsi("Valor Custo"),oFont10n)
																
					nLig += 40
					QNCR050LIN("L",,,,,,,nLig,30,nLig,2350)
					QNCR050LIN("L",,,,,,,nLig1, 360,nLigf, 360)
					QNCR050LIN("L",,,,,,,nLig1,2000,nLigf,2000)
														
					nLig1 := nLig 	// Pula de 40 em 40
					nLig += 20
					nColT := 1

					For nA:=1 to Len(aCustos)
						_cDescQb := Space(50)
						SX5->(DbSeek(xFilial("SX5")+"QB")) // 
						While !SX5->(Eof()) .And. Alltrim(SX5->X5_TABELA) == "QB"
							If Alltrim(SX5->X5_CHAVE) == aCustos[nA,1]
                            	_cDescQb := SX5->X5_DESCRI
							Endif
							SX5->(DbSkip())
						Enddo
						QNCR050LIN("T",nLig,  40,aCustos[nA,1],oFont10,,OemToAnsi("---"),Len(aCustos)-nA+1,,,,.T.)
						QNCR050LIN("T",nLig, 370,_cDescQb,oFont10,,OemToAnsi("---"),Len(aCustos)-nA+1,,,,.T.)
						QNCR050LIN("T",nLig,2010,Transform(aCustos[nA,2],"@E 999,999,999.99"),oFont10,,OemToAnsi("---"),Len(aCustos)-nA+1,,,,.T.)
						_nTotCusto += aCustos[nA,2]
						nLig+=40
					Next


					oQPrint:Box(nLig,  030, nLig+80, 2350 )
					oQPrint:Say(nLig+40,050,OemToAnsi("T O T A L"),oFont10 )
					oQPrint:Say(nLig+40,1860,OemToAnsi("       ")+TransForm(_nTotCusto,"@E 999,999,999.99"),oFont10 )

					nLig+=60

				Endif
			Endif
		Endif	

	Endif	
	nLig+=40
	oQPrint:Say(nLig,2200,OemToAnsi("Pag.")+Transform(nPag,"@e 99"),oFont06 )	// "Pag."
	nPag++
	lPagPrint := .F.
	oQPrint:EndPage()
	dbSkip()
Enddo

If oQPrint <> NIL
	oQPrint:EndPage() // Finaliza a pagina
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QI9->(dbSetOrder(1))

dbSelectArea("QI2")
Set Filter to
dbSetOrder(1)
If oQPrint <> NIL
	If nView == 1
		oQPrint:Preview()  // Visualiza antes de imprimir
	Else
	   oQPrint:Print() // Imprime direto na impressora default Protheus
	Endif
Endif

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QNCR050Imp³ Autor ³ Aldo Marini Junior    ³ Data ³ 31.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³QNCR050LIN(cTipo,nLin,nCol,cTexto,oFontT,nBoxTam,cTextCab,  ³±±
±±³          ³nBoxTamLI,nBoxTamCI,nBoxTamLF,nBoxTamCF,lCabec)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1-Caracter definindo "L"-Linha","T"-Texto,"B"-Box      ³±±
±±³          ³ ExpN1-Numerico definindo linha a ser impressa              ³±±
±±³          ³ ExpN2-Numerico definindo coluna a ser impressa             ³±±
±±³          ³ ExpC2-Caracter definindo texto a ser impresso              ³±±
±±³          ³ ExpO1-Objeto contendo o fonte da letra a ser impressa      ³±±
±±³          ³ ExpN3-Numerico definindo No.Linha faltantes para o Box     ³±±
±±³          ³ ExpC3-Caracter definindo o Texto do cabecalho qdo quebrar  ³±±
±±³          ³ ExpN4-Numerico definindo Linha Inicial do Box              ³±±
±±³          ³ ExpN5-Numerico definindo Coluna Inicial do Box             ³±±
±±³          ³ ExpN6-Numerico definindo Linha final do Box                ³±±
±±³          ³ ExpN7-Numerico definindo Coluna final do BOX               ³±±
±±³          ³ ExpL1-Logico definindo se imprime cabecalho do Plano Acao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QNCR050                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QNCR050LIN(cTipo,nLin,nCol,cTexto,oFontT,nBoxTam,cTextCab,nBoxTamLI,nBoxTamCI,nBoxTamLF,nBoxTamCF,lCabec)
Local nLig1      := 0
Local nColEmp    := 550
Default nBoxTam  := 0
Default cTextCab := " "
Default lCabec   := .F.

If !lInicial
	lInicial := .T.
	oQPrint:= TMSPrinter():New( Titulo )
	oQPrint:SetPortrait()
	oQPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...
	nLig := 2900
Endif

If nLig >= 2900
	If !lFirst
		If lPagPrint
			nLig+=40
			oQPrint:Say(nLig,2200,OemToAnsi("Pag.")+Transform(nPag,"@e 99"),oFont06 )	// "Pag."
			nPag++
		Endif
		oQPrint:EndPage()
	Endif
	If lFirst
		lFirst := .F.
	Endif
	lPagPrint := .T.
	oQPrint:StartPage() // Inicia uma nova pagina
	oQPrint:SayBitmap(30,30, cFileLogo,474,117)
	nColEmp := 1175-((Len(cNomFilial)/2)*29.375) // Tamanho de fonte 15
	oQPrint:Say(030,nColEmp,cNomFilial,oFont15 )

	oQPrint:Say(146,30,OemToAnsi("FICHA DE OCORRENCIAS/NAO-CONFORMIDADES"),oFont20 )	// "FICHA DE OCORRENCIAS/NAO-CONFORMIDADES"

	oQPrint:Box(130, 1680, 210, 2350 )
	oQPrint:Say(143,1700,OemToAnsi("No. ")+TransForm(QI2->QI2_FNC,"@R 999999/9999")+"-"+QI2->QI2_REV,oFont15 ) // "No. "

	oQPrint:Line( 225, 30, 225, 2350 )
	oQPrint:Line( 226, 30, 226, 2350 )
	oQPrint:Line( 227, 30, 227, 2350 )
	oQPrint:Line( 228, 30, 228, 2350 )
	oQPrint:Line( 229, 30, 229, 2350 )

	oQPrint:Box(270, 30, 440, 2350 )
	oQPrint:Line( 355, 30, 355, 2350 )

	oQPrint:Line( 270, 430, 355, 430 )
	oQPrint:Line( 270, 830, 355, 830 )
	oQPrint:Line( 270,1240, 440,1240 )
	oQPrint:Line( 270,1640, 440,1640 )
	oQPrint:Say(275,  40,OemToAnsi("Data de Registro"),oFont06 )	// "Data de Registro"
	oQPrint:Say(315,  40,PADR(DTOC(QI2->QI2_REGIST),10),oFont10 )

	oQPrint:Say(275, 440,OemToAnsi("Data de Ocorrencia"),oFont06 )	// "Data de Ocorrencia"
	oQPrint:Say(315, 440,PADR(DTOC(QI2->QI2_OCORRE),10),oFont10 )

	oQPrint:Say(275, 840,OemToAnsi("Data Conclusao Prevista"),oFont06 )	// "Data Conclusao Prevista"
	oQPrint:Say(315, 840,PADR(DTOC(QI2->QI2_CONPRE),10),oFont10 )

	oQPrint:Say(275,1250,OemToAnsi("Data Conclusao Real"),oFont06 ) // "Data Conclusao Real"
	oQPrint:Say(315,1250,PADR(DTOC(QI2->QI2_CONREA),10),oFont10 )

	oQPrint:Say(275,1650,OemToAnsi("Status"),oFont06 )	// "Status"
	oQPrint:Say(315,1650,aStatus[Val(QI2->QI2_STATUS)],oFont10 )

	oQPrint:Say(360, 40,OemToAnsi("Originador"),oFont06 )	// "Originador"
	oQPrint:Say(390, 40,PADR(QA_NUSR(QI2->QI2_FILMAT,QI2->QI2_MAT,.F.),40),oFont10 )

	oQPrint:Say(360,1250,OemToAnsi("Prioridade"),oFont06 )	// "Prioridade"
	oQPrint:Say(390,1250,aPriori[Val(QI2->QI2_PRIORI)],oFont10 )

	oQPrint:Say(360,1650,OemToAnsi("Tipo"),oFont06 )	// "Tipo"
	oQPrint:Say(390,1650,Padr(QA_CBOX("QI2_TPFIC",QI2->QI2_TPFIC),32),oFont10 )

// Seta Linha inicial apos quebra de pagina
	nLig := 500
	nLin := 500	

	If !Empty(AllTrim(cTextCab)) .And. nBoxTam > 0
		oQPrint:Say(nLig,30,cTextCab,oFont10n )
		nLig += 40
		nLig1 := nLig+(nBoxTam*40)+80
		nLig1 := If(nLig1>=2900,2930,nLig1)
		oQPrint:Box(nLig, 30,nLig1, 2350 )
		nLig += 20
		nLin := nLig

		If lCabec
			nLig2 := nLig-20
			oQPrint:Say(nLig,  40,OemToAnsi("No.Pl.Acao Rv"),oFont10n ) // "No.Pl.Acao Rv"
			oQPrint:Say(nLig, 370,OemToAnsi("Originador"),oFont10n ) // "Originador"
			oQPrint:Say(nLig,1310,OemToAnsi("Dt.Abertura"),oFont10n ) // "Dt.Abertura"
			oQPrint:Say(nLig,1660,OemToAnsi("Dt.Encerr.Prev."),oFont10n ) // "Dt.Encerr.Prev."
			oQPrint:Say(nLig,2010,OemToAnsi("Dt.Encerr.Real"),oFont10n ) // "Dt.Encerr.Real"
	         
			nLig += 40
			oQPrint:Line(nLig,  30, nLig, 2350 )

			oQPrint:Line(nLig2, 360, nLig1, 360 )
			oQPrint:Line(nLig2,1300, nLig1, 1300 )
			oQPrint:Line(nLig2,1650, nLig1, 1650 )
			oQPrint:Line(nLig2,2000, nLig1, 2000 )
			nLig += 20
			nLin := nLig
		Endif
	Endif
Endif

If cTipo == "T"
	oQPrint:Say(nLin,nCol,cTexto,oFontT)
ElseIf cTipo == "B"
	oQPrint:Box(nBoxTamLI,nBoxTamCI,nBoxTamLF,nBoxTamCF)
ElseIf cTipo == "L"
	oQPrint:Line(nBoxTamLI,nBoxTamCI,nBoxTamLF,nBoxTamCF)
Endif

Return Nil
