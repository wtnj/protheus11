#INCLUDE "FINA290.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

STATIC lF290OWN		:= ExistBlock("F290OWN")
STATIC lF290FPG 	:= ExistBlock("F290FPG")
STATIC lf290CHK 	:= ExistBlock("F290CHK")
STATIC lF290LIBT	:= ExistBlock("F290LIBT")
STATIC lFA290HPAD	:= ExistBlock("FA290HPAD")
STATIC lF290BTIT  	:= ExistBlock("F290BTIT")
STATIC lF290FORNP	:= EXISTBLOCK("F290FORNP")
STATIC lF290BROW	:= ExistBlock("F290BROW")
STATIC lF290BFIL	:= ExistBlock("F290BFIL")
STATIC lF290PRE		:= ExistBlock("F290PRE")
STATIC lF290Baixa 	:= Existblock("F290BAIXA")
STATIC lPEGrava		:= ExistBlock("FI290GE5")
STATIC lF290FIL 	:= ExistBlock("F290FIL")
STATIC lF290CON		:= ExistBlock("F290CON")
STATIC lFA290		:= ExistBlock("FA290")
STATIC lValidCan	:= ExistBlock("FA290OKC")
STATIC lF290CN2		:= ExistBlock("F290CN2")
STATIC lFA290C 		:= ExistBlock("FA290C")
STATIC lF290CAN		:= ExistBlock("F290CAN")
STATIC lFA290OK		:= ExistBlock("FA290OK")
STATIC lF290Tit		:= ExistBlock("F290TIT")
STATIC lF290TIT		:= ExistBlock("F290TIT")
STATIC lFa290Tok	:= Existblock("FA290TOK")
STATIC lF290Val 	:= ExistBlock("F290VAL")
STATIC lF290Tit 	:= ExistBlock("F290TIT")
STATIC LFIN290NAT	:= ExistBlock("FIN290NAT")
STATIC lFILEMOT 	:= ExistBlock("FILEMOT")
STATIC lPEMostraTela:=ExistBlock("FI290MT")
STATIC lF290CN2	:= ExistBlock("F290CN2")

STATIC lPanelFun 	:= FindFunction("IsPanelFin")
STATIC lRstFin 	:= FindFunction("FVerRstFin")
STATIC lFuncAtuSld:= FindFunction("AtuSldNat")
STATIC lFAVPFunc	:= FindFunction( "FAVPValTit" )
// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FIN290	³ Autor ³ Paulo Boschetti	     ³ Data ³ 27/07/93³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Selecao de titulos para Fatura			  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FIN290()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FIN290(nPosArotina,aFatPag)                                                                                  
Local lPanelFin	:= If (lPanelFun,IsPanelFin(),.F.)
Local   xRet    := ''
Private aRotina := MenuDef()
Private cFatura	:= CRIAVAR("E2_FATURA")
Private cForn	:= CriaVar("A2_COD")
Private cLoja	:= CriaVar("A2_LOJA")
Private cPrefix := CRIAVAR("E2_PREFIXO",.T.)
Private dVencto	:=Ctod(Space(8))
Private dDataDe	:=dDataBase
Private dDataAte:=dDataBase
Private nValor 	:=0
Private nValorFat :=0
Private cNat	:=Space(10)
Private nTotAbat:=0
Private nValCruz:=0
Private aVlCruz	:={}
Private aDupl
Private nValtot	:=0
Private aVenc	:={}
Private nMoeda 	:=1
Private nIndex 	:= 0
Private cFil290
Private cLote
PRIVATE oFatura
Private lFocus 	:= .F.
Private oTipo
Private oNat
//Campos usados para amarracao das faturas geradas com o mesmo prefixo, tipo e numeração, mas para fornecedores e lojas diferentes.
Private lDuplFat := SE2->(FieldPos("E2_FATFOR")) > 0 .And. SE2->(FieldPos("E2_FATLOJ")) > 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de baixas								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro 	:= OemToAnsi(STR0005) //"Aglutina‡„o de Titulos"
Private nMoedaBco	:= 1 // Variavel necessaria para não ocorrer error.log na funcao fa090Correc()
DEFAULT nPosArotina := 0
DEFAULT aFatPag     := {}

Fa290MotBx("FAT","FATURAS   ","ANNS")   

AjustaSx1()

If FunName() <> "FIN750" .And. !lPanelFin .and. Empty(aFatPag)
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbGoTop()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega a funcao pergunte 					    			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI290",.T.)})
Pergunte("AFI290",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada a ser executado antes da browse             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lF290BROW
	ExecBlock("F290BROW",.f.,.f.)
Endif

If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
	dbSelectArea("SE2")
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	xRet   := Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,aFatPag)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a Fun‡„o de BROWSE											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE2",,,,,,Fa040Legenda("SE2"),,,,,,,,IIF(lF290BFIL,ExecBlock("F290BFIL",.f.,.f.),NIL))
Endif	

Set Key VK_F12 to

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(1)

Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fA290Aglu³ Autor ³ Paulo Boschetti		  ³ Data ³ 27/07/93³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marcacao dos titulos para emissao de fatura				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa290Aglu() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fA290Aut(cAlias,cCampo,nOpcE,aFatPag)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin 	:= If (lPanelFun,IsPanelFin(),.F.)
Local cArquivo
Local nTotal		:=0
Local nHdlPrv		:=0
Local lPadrao
Local cPadrao		:="587"
Local nW 			:=1
Local dDatCont 		:=dDatabase
Local cIndex		:= ""
Local nOpca 		:= 2   
Local aBut290 		:= {{"PESQUISA",{||Fa290Pesq(oMark,cAlias)}, STR0070,STR0001}} //###"Pesquisar" ### "Pesquisar..(CTRL-P)"
Local bSet16 		:= SetKey(16,{||Fa290Pesq(oMark,cAlias)})
Local oDlg, oDlg1, oDlg2
Local oValor		:= 0
Local oQtdTit		:= 0
Local oValorFat		:= 0
Local cMarca		:= GetMark()
LOCAL aMoedas		:= {}
LOCAL oCbx
LOCAL cVar,nO
LOCAL aCampos 		:= {}
LOCAL nTamSeq 		:= TamSX3("E5_SEQ")[1]
LOCAL cSequencia 	:= Replicate("0",nTamSeq)
LOCAL nRecSe2 		:= 0
LOCAL cAliasSE2 	:= "SE2"
Local cSetFilter 	:= SE2->(DBFILTER()) // Salva o filtro atual, para restaurar no final da rotina
Local nValTotal 	:= 0
Local lDigita
Local nX := 0
Local lAcreDecre 	:= .F.
Local oTimer
Local nTimeOut  	:= SuperGetMv("MV_FATOUT",,900)*1000 	// Estabelece 15 minutos para que o usuarios selecione os titulos a faturar
Local nTimeMsg  	:= SuperGetMv("MV_MSGTIME",,120)*1000 	// Estabelece 02 minutos para exibir a mensagem para o usuário
                                                      	// informando que a tela fechará automaticamente em XX minutos
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local aChaveLbn := {}
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lBaseSE2 := (	!Empty( SE1->( FieldPos( "E1_BASEPIS" ) ) ) .And.;
							!Empty( SE1->( FieldPos( "E1_BASECOF" ) ) ) .And. ; 
							!Empty( SE1->( FieldPos( "E1_BASECSL" ) ) ) .And. ; 
							!Empty( SE2->( FieldPos( "E2_BASEPIS" ) ) ) .And.;
							!Empty( SE2->( FieldPos( "E2_BASECOF" ) ) ) .And. ; 
							!Empty( SE2->( FieldPos( "E2_BASECSL" ) ) )	)

Local nOldPis 	:= 0
Local nOldCof 	:= 0
Local nOldCsl 	:= 0
Local nTotBase	:= 0
Local nTotPis 	:= 0
Local nTotCof 	:= 0
Local nTotCsl 	:= 0
Local nTotISS 	:= 0
Local nTotIRPJ	:= 0
Local nTtIRFat	:= 0
Local aSize 	:= {}
Local oPanel
Local lNumFat   := .T.
Local lFatAut   := .F.
Local nDecres   := 0
Local nVlDesc   := 0
Local nSlDesc   := 0
Local nAcresc   := 0
Local nVlAcre   := 0
Local nSlAcre   := 0

Local aGrvSe2   	:= {}
Local aDadosBco 	:= {}
Local lExibeLanc	:= .F.
Local lOnLine   	:= .F.
Local nIndSE2 		:= SE2->(IndexOrd())
Local nRecnoSE2		:= SE2->(Recno())
Local lContab530	:= VerPadrao("530") .And. ( mv_par03 == 1 )
Local lMostraTela   :=.T.
Local cKeyTit		:= ""
Local nPCCRet		:= 0
Local nPisRet		:= 0
Local nCofRet		:= 0
Local nCslRet		:= 0
Local lSest 		:= SE2->(FieldPos("E2_SEST"))	> 0  //Verifica campo de SEST
Local lCalcIssBx 	:=	.F.

Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local cCond 		:= Space(3) 
Local nISS  		:= 0
Local nFRetISS 		:= ""
Local nTRetISS 		:= ""
Local aISSFat
Local nISSFat 		:= 0

//Rastreamento
Local lRastro		:= If(lRstFin,FVerRstFin(),.F.)
Local aRastroOri	:= {}
Local aRastroDes	:= {}
Local nValProces	:= 0

//Controle de Contabilizacao
Local aFlagCTB		:= {}
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

//IRPF na baixa
Local lIRPFBaixa	:= .F.
LOCAL lBaseIRPF		:= .F.
Local nIndIrpf		:= 0
Local nTotIRF		:= 0
Local nPropIR		:= 1
Local lUsaBaseIr	:= .F.

Local cHistFat		:= ""
Local lAtuSldNat    := lFuncAtuSld .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios

Local lAWB          := Left(FunName(),7) == 'TMSA920' //Geracao de Titulos AWB
Local nMoedaC 	 	:= 1
Local aArea 	 	:= {}

Private oGet
Private cCondicao	:=Space(3)
Private nValCorr	:= 0
Private nBasePCC	:= 0
Private nPisFat		:= 0
Private nCofFat		:= 0 
Private nCslFat		:= 0 
Private nIrfFat		:= 0 
Private aBaseFat	:= {}
Private aPisFat		:= {}
Private aCofFat		:= {}
Private aCslFat		:= {}
Private aIrfFat		:= {}
Private lInverte	:= .F.
Private aHeader		:= {}
Private aCols		:= {}
Private oValTot		:= 0
Private nValTot		:= 0
Private nUsado 		:= 0
Private cTipo		:= CRIAVAR("E2_TIPOFAT")
Private cFornP		:= CRIAVAR("E2_FORNECE",.F.)
Private cLojaP		:= CRIAVAR("E2_LOJA",.F.)
Private nJur290		:= 0
Private nDesc290	:= 0
Private nBaseIrpf 	:= 0
Private aDocsOri	:= {}
Private aDocsDes	:= {}  
PRIVATE dEmiss		:= SE2->E2_EMIS1

AjustaSx1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se se o processo será contabilizado                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPadrao := VerPadrao(cPadrao) .and. mv_par03 == 1
//verifica se existem os campos de valores de acrescimo e decrescimo no SE5
If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
	lAcreDecre := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa alias alternativo para AS400 para ser utilizado   ³
//³ apenas no momento da grava‡Æo dos novos registos gerados	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If TcSrvType() == "AS/400"
		If Select("SE2_FAT") == 0
			ChkFile("SE2",.F.,"SE2_FAT")
		Else
			dbSelectArea("SE2_FAT")
		Endif
		cAliasSE2 := "SE2_FAT"
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ³
//³                                                                  ³
//³ A fun‡„o SomaAbat reabre o SE2 com outro nome pela ChkFile para  ³
//³ efeito de performance. Se o alias auxiliar para a SumAbat() n„o  ³
//³ estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ³
//³ pois o Filtro do SE1 uptrapassa 255 Caracteres.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SomaAbat("","","","P")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ACIONA A FUNCAO PERGUNTE												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI290",.T.)})
Pergunte("AFI290",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMoedas := FDescMoed()  

dbSelectArea( cAlias )

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E2_PREFIXO")
cPictPref := AllTrim(X3_PICTURE)
dbSetOrder(1)

cForn	:= SPACE(TamSX3("E2_FORNECE")[1])
cLoja	:= SPACE(TamSX3("E2_LOJA")[1])

//-- Tratamento necessario devido os parametros enviados pela MBrowse
If ValType(aFatPag) != "A" .Or. Len(aFatPag) < 13 .Or. ValType(aFatPag[13]) != "A"
	aFatPag := {}
EndIf
//Descricao do Array aFatPag
//[01] - Prefixo
//[02] - Tipo
//[03] - Numero da Fatura (se o numero estiver em branco obtem pelo FIN290)
//[04] - Natureza
//[05] - Data de
//[06] - Data Ate
//[07] - Fornecedor
//[08] - Loja
//[09] - Fornecedor para geracao
//[10] - Loja do fornecedor para geracao
//[11] - Condicao de pagto
//[12] - Moeda
//[13] - ARRAY com os titulos da fatura
//[13,1] Prefixo
//[13,2] Numero
//[13,3] Parcela
//[13,4] Tipo
//[13,5] Título localizado na geracao de fatura (lógico). Iniciar com falso.
//[14] - Valor de decrescimo
//[15] - Valor de acrescimo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont( "FIN" )

nOpca 		:= 2
Do While nOpca == 2
	nOpca 		:= 3
	dbSelectArea(cAlias)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebe dados a serem digitados										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cVar := aMoedas[1]
	If Len(aFatPag) > 0
		lFatAut := .T.
		If !Empty(aFatPag[3])
			lNumFat := .F.
			cFatura := aFatPag[3]
		EndIf
	EndIf
	If lNumFat
		aTam := TamSx3("E2_NUM")
		cFatura	:= Soma1(GetMv("MV_NUMFATP"), aTam[1])
		cFatura	:= Pad(cFatura,aTam[1])
	EndIf
	cFatAnt	:= cFatura
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para inicializacao das vari veis da fatura  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lF290PRE
		ExecBlock("F290PRE",.F.,.F.)
	Endif
	
	If lFatAut
		cPrefix  := aFatPag[01]
		cTipo    := aFatPag[02]
		cNat     := aFatPag[04]
		dDataDe  := Iif(!Empty(aFatPag[05]),aFatPag[05],dDataDe)
		dDataAte := Iif(!Empty(aFatPag[06]),aFatPag[06],dDataAte)
		cForn    := aFatPag[07]
		cLoja    := aFatPag[08]
		cFornP   := aFatPag[09]
		cLojaP   := aFatPag[10]
		nOpca    := 1
		nDecres  := Iif(Len(aFatPag) > 13 .And. ValType(aFatPag[14]) == "N",aFatPag[14],0)
		nAcresc  := Iif(Len(aFatPag) > 14 .And. ValType(aFatPag[15]) == "N",aFatPag[15],0)
	Else
		aSize := MSADVSIZE()
		If lPanelFin  //Chamado pelo Painel Financeiro
			//Espacamento := 45
			dbSelectArea(cAlias)
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
			//³ -------------------------------------------------------------- ³
			//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
			//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
			//³ tracao e redivisao por 2 para a centralizacao. 					 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 218) /2
			nEspLin  := 0
			
		Else
			DEFINE MSDIALOG oDlg FROM	22,9 TO 240,540 TITLE OemToAnsi(STR0009) PIXEL //"Faturas a Pagar"
			nEspLarg := 5
			nEspLin  := 2
		Endif
		
		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT
		
		
		@ 004+nEspLin, nEspLarg TO 036+nEspLin, 218+nEspLarg OF oPanel PIXEL
		@ 038+nEspLin, nEspLarg TO 070+nEspLin, 218+nEspLarg OF oPanel PIXEL
		@ 072+nEspLin, nEspLarg TO 104+nEspLin, 218+nEspLarg OF oPanel PIXEL
		
		nEspLarg := nEspLarg - 7
		
		@ 020+nEspLin, 014+nEspLarg MSGET cPrefix	Pict cPictPref  			 SIZE 10, 11 OF oPanel PIXEL
		@ 020+nEspLin, 040+nEspLarg MSGET oTipo VAR cTipo		F3 "05" Picture "@!" Valid If(nOpca<>0,(!Empty (cTipo) .and. FA290Tipo(@cTipo)),.T.) SIZE 10, 11 OF oPanel PIXEL HASBUTTON
		oTipo:cReadVar := "E2_TIPOFAT"
		
		@ 020+nEspLin, 075+nEspLarg MSGET oFATURA VAR cFatura	Valid If(nOpca<>0,!Empty(cFatura),.T.) SIZE 42, 11 OF oPanel PIXEL
		@ 020+nEspLin, 120+nEspLarg MSGET oNat VAR cNat		F3 "SED" Valid If(nOpca<>0,Fa290Nat(),.T.) SIZE 55, 11 OF oPanel PIXEL HASBUTTON
		@ 020+nEspLin, 175+nEspLarg MSCOMBOBOX oCbx VAR cVar ITEMS aMoedas 		SIZE 46, 55 OF oPanel PIXEL
		
		@ 054+nEspLin, 014+nEspLarg MSGET dDataDe	Valid If(nOpca<>0,!Empty(dDataDe),.T.)		SIZE 50, 11 OF oPanel PIXEL HASBUTTON
		@ 054+nEspLin, 068+nEspLarg MSGET dDataAte	Valid If(nOpca<>0,!Empty(dDataAte) .and. dDataAte >= dDataDe .and. dDataAte <= dDataBase,.T.) SIZE 50, 11 OF oPanel PIXEL HASBUTTON
		@ 054+nEspLin, 120+nEspLarg MSGET nValorFat Picture "@E 9,999,999,999.99"    SIZE 65, 11 OF oPanel PIXEL HASBUTTON
		
		@ 085+nEspLin, 014+nEspLarg MSGET cForn		F3 "FOR" Valid If(nOpca<>0,Fa290For(cForn),.T.)	SIZE 65, 11 OF oPanel PIXEL HASBUTTON
		@ 085+nEspLin, 079+nEspLarg MSGET cLoja		When mv_par01 == 1 Valid If(nOpca<>0,Fa290For(cForn,cLoja),.T.) SIZE 21, 11 OF oPanel PIXEL
		
		@ 085+nEspLin, 120+nEspLarg MSGET cFornP		When mv_par01 == 2 .and. ( Iif( lF290FORNP , EXECBLOCK("F290FORNP",.F.,.F.) , .T. )) F3 "FOR" Valid If(nOpca<>0,Fa290For(cFornP),.T.) SIZE 65, 11 OF oPanel PIXEL HASBUTTON
		@ 085+nEspLin, 185+nEspLarg MSGET cLojaP		When mv_par01 == 2 .and. ( Iif( lF290FORNP , EXECBLOCK("F290FORNP",.F.,.F.) , .T. )) Valid If(nOpca<>0,Fa290For(cFornP,cLojaP),.T.) SIZE 21, 11 OF oPanel PIXEL
		
		@ 010+nEspLin, 014+nEspLarg SAY OemToAnsi(STR0010) SIZE 20, 7 OF oPanel PIXEL //"Prefixo"
		@ 010+nEspLin, 040+nEspLarg SAY OemToAnsi(STR0053) SIZE 12, 7 OF oPanel PIXEL //"Tp"
		@ 010+nEspLin, 075+nEspLarg SAY OemToAnsi(STR0055) SIZE 49, 7 OF oPanel PIXEL //"Nr.Fatura"
		@ 010+nEspLin, 120+nEspLarg SAY OemToAnsi(STR0012) SIZE 25, 7 OF oPanel PIXEL //"Natureza"
		@ 010+nEspLin, 175+nEspLarg SAY OemToAnsi(STR0013) SIZE 25, 7 OF oPanel PIXEL //"Moeda"
		
		@ 044+nEspLin, 014+nEspLarg SAY OemToAnsi(STR0014) SIZE 30, 7 OF oPanel PIXEL //"EmissÆo de"
		@ 044+nEspLin, 068+nEspLarg SAY OemToAnsi(STR0015) SIZE 10, 7 OF oPanel PIXEL //"At‚"
		@ 044+nEspLin, 120+nEspLarg SAY OemToAnsi(STR0016) SIZE 50, 7 OF oPanel PIXEL //"Valor da Fatura"
		
		@ 075+nEspLin, 014+nEspLarg SAY OemToAnsi(STR0017) SIZE 30, 7 OF oPanel PIXEL //"Fornecedor"
		@ 075+nEspLin, 079+nEspLarg SAY OemToAnsi(STR0018) SIZE 30, 7 OF oPanel PIXEL //"Loja"
		@ 075+nEspLin, 120+nEspLarg SAY OemToAnsi(STR0057) SIZE 50, 7 OF oPanel PIXEL //"Gerar p/Fornecedor"
		@ 075+nEspLin, 185+nEspLarg SAY OemToAnsi(STR0018) SIZE 30, 7 OF oPanel PIXEL //"Loja"
		
		
		If lPanelFin  //Chamado pelo Painel Financeiro
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{||nOpca:=0,IF(If(FA290NUM(cFatAnt), FA290Ok() ,.F.),nOpca:=1,nOpca:=2),oDlg:End()},;
			{||nOpca:=0,oDlg:End()})
			
			FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)
			
		Else
			DEFINE SBUTTON FROM 07, 230 TYPE 1 ACTION (nOpca:=0,IF(If(FA290NUM(cFatAnt), FA290Ok() ,.F.),nOpca:=1,nOpca:=2),oDlg:End()) ENABLE OF oDlg
			DEFINE SBUTTON FROM 21, 230 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg
			
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
	Endif
Enddo

If(nOpca<>1,nOpca:=0,.T.)

If nOpca == 0
	FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
	Return
EndIf

If lFatAut .And. !Empty(aFatPag[12])
	nMoeda := aFatPag[12]
Else
	nMoeda := Val(Substr(cVar,1,2))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Execblock a ser executado antes da Indregua                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lF290FIL
	cFil290 := ExecBlock("F290FIL",.f.,.f.)
Else
	cFil290 := ".T."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice condicional												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
cIndex  := CriaTrab(nil,.f.)
cChave  := IndexKey()
IndRegua(cAlias,cIndex,cChave,,Fa290ChecF(),OemToAnsi(STR0019))  //"Selecionando Registros..."
nIndex := RetIndex(cAlias)
dbSelectArea(cAlias)
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
DbGoTop()

If BOF() .and. EOF()
	Help(" ",1,"RECNO")
	Set Filter to
	dbSetOrder(1)
	RetIndex("SE2")
	// Restaura o filtro
	Set Filter To &cSetFilter.
	dbGoTop()
	FErase(cIndex+OrdBagExt())
	FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
	Return(.F.)
Endif

nValor		:= 0	// valor total dos titulos,mostrado no rodape do browse
nValCruz 	:= 0
nQtdTit		:= 0	// quantidade de titulos,mostrado no rodape do browse
aVlCruz		:= {} // Valor na Moeda Nacional correspondente a cada parcela
lIrpfBaixa	:=  !Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ) .and. SA2->A2_CALCIRF == "2" .and. ;
					 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
					 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) )

lCalcIssBx	:= 	IIf( ! Empty( SA2->( FieldPos( "A2_TIPO" ) ) ),SA2->A2_TIPO == "J", .F.) .And.;
				!Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. ;
				!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2" //Retencao do ISS pela emissao (1) ou baixa (2)

nOpcA 		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com capos a serem mostrados na marcacao de titulos ³
//³ Utiliza os capos em uso do SE2 mais o E2_SALDO que apesar de   ³
//³ nao estar em uso deve ser mostrado na tela.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"E2_OK","","  ",""})
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(MsSeek(cAlias))
While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == cAlias)
	IF (X3USO(SX3->X3_USADO) .or. SX3->X3_CAMPO == "E2_SALDO  ") .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT != "V"
		AADD(aCampos,{SX3->X3_CAMPO,"",X3Titulo(),SX3->X3_PICTURE})
	Endif
	SX3->(dbSkip())
Enddo  
dbSelectArea(cAlias)
dbSetOrder(nIndex+1) 


IF lF290BTIT
	aCampos:=ExecBlock("F290BTIT",.f.,.f.,aCampos)
EndIF 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia integracao com Modulo SIGAPCO                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoInilan("000015")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca os titulos ate o valor informado para a fatura 		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If MV_PAR05 == 1 .Or. lFatAut
	Fa290Marca(cAlias,cMarca,nValorFat,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn,aFatPag)
EndIf

nValorF := nValorFat

If lFatAut
	If Ascan(aFatPag[13],{ | e | e[5] == .F. }) > 0
		IW_MSGBOX('Existem títulos que não foram localizados na geração da fatura',,'ATENÇÃO','STOP')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera a Integridade dos dados									  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
		dbSelectArea("SE2")
		RetIndex( "SE2" )
		// Restaura o filtro
		Set Filter To &cSetFilter.
		If !Empty(cIndex)
			fErase(cIndex+OrdBagExt())
			cIndex:=""
		EndIf
		Return(.F.)
	EndIf		
	nOpca := 1
Else  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MSADVSIZE()	
	
	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi(STR0020) From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL //"Fatura a Pagar"
	oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer
	oTimer:Activate()  
	oDlg1:lMaximized := .T.
	
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,40,40,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP
	
	@ 008 , 005		SAY OemToAnsi(STR0021) + cPrefix 					   FONT oDlg1:oFont PIXEL Of oPanel// "Prefixo: "
	@ 017 , 005		Say OemToAnsi(STR0022) + cFatura 					   FONT oDlg1:oFont PIXEL Of oPanel// "N£mero: "
	@ 008 , 080		SAY OemToAnsi(STR0023) + Substr(cNat,1,10)		   FONT oDlg1:oFont PIXEL Of oPanel// "Natureza: "
	@ 017 , 080		SAY OemToAnsi(STR0024) + AllTrim(Str(nMoeda,2,0)) FONT oDlg1:oFont PIXEL Of oPanel// "Moeda: "
	
	@ 008 , 150		Say OemToAnsi(STR0025) FONT oDlg1:oFont PIXEL Of oPanel	//"Valor Fatura"
	@ 008 , 200		Say OemToAnsi(STR0026) FONT oDlg1:oFont PIXEL Of oPanel	//"Valor Selecionado"
	@ 008 , 250		Say OemToAnsi(STR0027) FONT oDlg1:oFont PIXEL Of oPanel	//"T¡t. Selec."
	@ 017 , 150		Say oValorFat VAR nValorF	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
	@ 017 , 200		Say oValor	  VAR nValor	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
	@ 017 , 250		Say oQtdTit   VAR nQtdTit	  Picture "999999"            FONT oDlg1:oFont PIXEL Of oPanel
	
	@ 0.2 , 00.3 To 2.5,17 OF oPanel
	@ 0.2 ,   17 To 2.5,39 OF oPanel
	
	oMark 		:=MsSelect():New(cAlias,"E2_OK","!E2_SALDO",aCampos,@lInverte,@cMarca,{45,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight})
	oMark:bMark := {||Fa290Exibe(cMarca,oValor,oQtdTit,lContrRet,lPccBaixa,lBaseSe2)}
	oMark:bAval	:= {||Fa290bAval(cAlias,cMarca,oValor,oQtdTit,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || Fa290Inverte(cAlias,cMarca,oValor,oQtdTit,.T.,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn)}
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT  
	
	If lF290FPG
      aBut290 := ExecBlock( "F290FPG",.F.,.F., {aBut290})
    EndIf      
	 
	If lPanelFin  //Chamado pelo Painel Financeiro			
	   ACTIVATE MSDIALOG oDlg1 ON INIT FaMyBar(oDlg1,{|| nOpca := 1,;
	   	IIF(Fa290ValOK(),IF(Fa290Soma(),oDlg1:End(),;
			Iif(Fa290Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
			{|| nOpca := 2,oDlg1:End()},aBut290)     
	Else
		ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,;
			IIF(Fa290ValOK(),IF(Fa290Soma(),oDlg1:End(),;
			Iif(Fa290Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
			{|| nOpca := 2,oDlg1:End()},,aBut290)  
	Endif
	SetKey(16,bSet16)
EndIf
	
dbSelectArea("SE2")

If nOpca == 1
	nOpcA := 0
		
	If !lF290CON
		cCond := Iif(lFatAut .And. !Empty(aFatPag[11]),aFatPag[11],Space(3))

		If lFatAut .And. !lAWB
			nOpca := 1		
			cCondicao := cCond
			aVenc := Condicao(nValor,cCondicao,0)
			nDup	:= Len(aVenc)
			aCols := GravaDup(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,lFatAut)
		Else
		aSize := MsAdvSize(,.F.,400)
		DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		oDLg2:lMaximized := .T.
		
		oPanel1 := TPanel():New(0,0,'',oDlg2, oDlg2:oFont, .T., .T.,, ,45,45,.T.,.T. )
		oPanel1:Align := CONTROL_ALIGN_TOP
		
		oPanel2 := TPanel():New(0,0,'',oDlg2, oDlg2:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

		@	003,010 TO 040,125 OF oPanel1 Pixel
		@	003,127 TO 040,500 OF oPanel1 Pixel
		
		@	015,015 	Say STR0052 Of oPanel1 Pixel   //"Condi‡„o: "
		@	015,045	MSGET cCond F3 "SE4" Picture "!!!" Of oPanel1 Pixel Hasbutton Valid If(nOpca<>0,ExistCpo("SE4",cCond) .And.;
																			  Fa290Cond(cCond),.T.)		
		
		DEFINE SBUTTON FROM 015,085	TYPE 1 ACTION (If(!Empty(cCond)	.And.	ExistCpo("SE4",cCond) .And. Fa290Cond(cCond),;
																	nOpca:=F290SelFat(oDlg2,1,@cCond,@nValor,@nValTot,@aVenc,@cPrefix,@cFatura,@cTipo,dDatCont,oPanel2,oPanel1),;
																	nOpca:=0)) ENABLE OF oPanel1
		

		If lPanelFin  //Chamado pelo Painel Financeiro			
			ACTIVATE MSDIALOG oDlg2 ON INIT FaMyBar(oDlg2,;
														{||nOpca:=1, If( valtype(oget)=="O",if(oGet:TudoOk() .And. Len(aCols) > 0,oDlg2:End(),nOpca := 0), nOpca := 0)},;
														{||oDlg2:End()})																												
		Else				
			ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpca:=1, If( valtype(oget)=="O",if(oGet:TudoOk() .And. Len(aCols) > 0,oDlg2:End(),nOpca := 0), nOpca := 0)},{||oDlg2:End()})
		Endif				                                  

		cCondicao := If(nOpca=0,"   ",cCond)
		aVenc := Condicao(nValor,cCondicao,0)
	EndIf
	Else
		aVenc := Execblock("F290CON",.f.,.f.,{nValor,cCondicao,cMarca,nBasePcc,nPisFat,nCofFat,nCslFat})
		nDup	:= Len(aVenc)
		aCols := GravaDup(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc)

		If !Empty(aCols)
			aVlCruz := {}
			aVlCruz := F280VlCruz(nDup,nValCruz)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Mostra tela com os diversos titulos						³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For no:=1 To Len(aCols)
				nValTot += aCols[no][6]
			Next no

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz o calculo automatico de dimensoes de objetos     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lPEMostraTela
				lMostraTela:=ExecBlock("FI290MT",.f.,.f.)
      		If ValType(lMostraTela) # "L"
      			lMostraTela:=.T.
      		EndIf
   		EndIf

			If lMostratela
	
				aSize := MSADVSIZE()	
		
				nOpca := 0
				DEFINE MSDIALOG oDlg2 TITLE STR0028 From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL //"Dados Cont beis Financeiros"
				oDlg2:lMaximized := .T.
				
				oPanel := TPanel():New(0,0,'',oDlg2,, .T., .T.,, ,20,20,.T.,.T. )
				oPanel:Align := CONTROL_ALIGN_TOP
				@ 003 , 005	SAY OemToAnsi(STR0029)	PIXEL OF oPanel //"Data Contabiliza‡„o : "
				@ 003 , 060	Say dDatCont				PIXEL OF oPanel FONT oDlg2:oFont  
				@ 003 , 105	Say OemToAnsi(STR0030)	PIXEL OF oPanel //"Condi‡„o de Pagamento : "
				@ 003 , 170	Say cCondicao				PIXEL OF oPanel
				@ 003 , 215	Say OemToAnsi(STR0031)	PIXEL OF oPanel //"Valor Total:"
				@ 003 , 260	Say oValTot VAR nValTot	PIXEL OF oPanel FONT oDlg2:oFont Picture "@E 9,999,999,999.99" 
				
				oGet:= MSGetDados():New(90,1,172,312,3,"Fa290LinOk","Fa290TudOk","",.T.,,,,,,"",,"Fa290AtuVl(.F.)")
				oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
				ACTIVATE MSDIALOG oDlg2 ON INIT (oGet:oBrowse:Refresh(.T.),EnchoiceBar(oDlg2,{||nOpca:=1,if(oGet:TudoOk(),oDlg2:End(),nOpca := 0)},{||oDlg2:End()}))
			Else
				nOpca := 1		
			EndIf
		Endif

	Endif  		

	If nOpcA == 1
		STRLCTPAD 	:= ""		// para contabilizar o historico do LP
		nTotAbat :=0
		dbSelectArea( "SE2" )
		dbSetOrder(nIndex+1)
		dbGotop()

		// ponto de entrada para customizar um historico a ser gravado
		// em todos os titulos selecionados para gerar a fatura.
		If lFA290HPAD
			cHistFat := ExecBlock( "FA290HPAD", .F., .F. )
		EndIf

		Begin Transaction
		
			While !Eof() .and. E2_FILIAL==cFilial .and. E2_FORNECE==cForn .and. ;
					IIF( mv_par01==1,E2_LOJA==cLoja,.T. )
	
		  	   DbSelectArea("SE2")
				nX:=RecNo()
				dbSkip()
				nRecSe2 := RecNo()
				dbGoto(nX)
	
				If E2_OK == cMarca
					cChave	:=&(IndexKey())
					cNumero	:=E2_NUM
					cPrefixo :=E2_PREFIXO
					cParcela :=E2_PARCELA

					//Atualiza Variavel p/Contabilizacao
					ABATIMENTO := SomaAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,"P",E2_MOEDA,,E2_FORNECE)
					nTotAbat += ABATIMENTO

					//Baixo os titulos de abatimento
					If ABATIMENTO > 0 .and. SE2->E2_TIPO $ MVABATIM
				  	   DbSelectArea("__SE2")
						__SE2->(dbSetOrder(1))
						__SE2->(MsSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)))
						While !EOF() .And. __SE2->E2_FILIAL==xFilial("SE2") .And. __SE2->E2_PREFIXO == SE2->E2_PREFIXO .And.;
								__SE2->E2_NUM == SE2->E2_NUM .And. __SE2->E2_PARCELA == SE2->E2_PARCELA
							IF __SE2->E2_TIPO $ MVABATIM .And. __SE2->E2_FORNECE == SE2->E2_FORNECE
								RecLock("__SE2")
								__SE2->E2_BAIXA		:= dDataBase
								__SE2->E2_VALLIQ		:= __SE2->E2_SALDO
								__SE2->E2_SALDO		:= 0
								__SE2->E2_MOVIMEN		:= dDataBase
								__SE2->E2_FATURA		:= cFatura
								__SE2->E2_FATPREF		:= cPrefix
								__SE2->E2_TIPOFAT		:= cTipo
								__SE2->E2_DTFATUR		:= dDatabase
								__SE2->E2_FLAGFAT		:= "S"
	
								If lDuplFat
									__SE2->E2_FATFOR	:= IIF(mv_par01 == 1,cForn,cFornP)
									__SE2->E2_FATLOJ	:= IIF(mv_par01 == 1,cLoja,cLojaP)
								EndIf
	
								MsUnlock()
								If lAtuSldNat
									// Tira o saldo do vencimento programado do titulo
									AtuSldNat(__SE2->E2_NATUREZ, __SE2->E2_VENCREA, __SE2->E2_MOEDA, "2", "P", __SE2->E2_VALLIQ, xMoeda(__SE2->E2_VALLIQ, __SE2->E2_MOEDA, 1),"+",,FunName(),"__SE2",__SE2->(Recno()),nOpcE)
								Endif	
							Endif
							__SE2->(dbSkip())
						Enddo
					Endif

			  	   DbSelectArea("SE2")
					dbSetOrder(nIndex+1)
					dbGoto(nX)
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza a Baixa do Titulo	  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !(E2_TIPO $ MVABATIM) .and. E2_SALDO > 0
						nJur290	:= SE2->E2_SDACRES
						nDesc290	:= SE2->E2_SDDECRE
						nValCorr:= fa090Correc( ) 
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no Cadastro de Naturezas ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SED->(dbSetOrder(1))
						SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
		
						SA2->(dbSetOrder(1))
						SA2->(MSSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
						
						lIRPFBaixa := IIf(	!Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
												 	!Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And.;
												 	!Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And.;
													!Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And.;
													!Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) )
													
						lCalcIssBx	:= 	IIf( ! Empty( SA2->( FieldPos( "A2_TIPO" ) ) ),SA2->A2_TIPO == "J", .F.) .And.;
										!Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. ;
										!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2" //Retencao do ISS pela emissao (1) ou baixa (2)

													
						lBaseIRPF  := If (FindFunction('F050BIRPF'),F050BIRPF(2),.F.)
                        
						//Tratamento de base e impostos Lei 10925 quando pela baixa
						If lContrRet .and. lPccBaixa .and. (E2_PIS+E2_COFINS+E2_CSLL > 0) 

							nVlrTit := SE2->(E2_VALOR+E2_IRRF+E2_ISS+E2_INSS)
		
							If lSest
								nVlrTit += SE2->E2_SEST
							Endif					
		
							If lCalcIssBx .AND. SA2->A2_TIPO == "J"
								nVlrTit -= SE2->E2_ISS
							EndIf

							//AQUI VERIFICO QUANTO FOI RETIDO E QUANTO FALTA RETER
							nPCCRet	:= 0
							nPisRet	:= 0
							nCofRet	:= 0
							nCslRet	:= 0

							SE5->(DBSetOrder(7))
							If SE5->(MSSEEK(xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
								cKeyTit := xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
								While !(SE5->(EOF())) .AND. cKeyTit = xFilial("SE5")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
									If (Empty( SE5->E5_PRETPIS ) .Or. SE5->E5_PRETPIS == '4' .Or. SE5->E5_PRETPIS == '5') .AND. !(SE5->E5_SITUACA=='C')
										//Armazeno os valores calculados por titulo, retirando os valores retidos
										nPisRet += SE5->E5_VRETPIS
										nCofRet += SE5->E5_VRETCOF 
										nCslRet += SE5->E5_VRETCSL
									Endif
									SE5->(dbSkip())
								Enddo
							Endif
			
							If lBaseSe2   //Utilizo a base dos impostos e nao o saldo do titulo
								nBasePCC += IIF(Empty(E2_BASEPIS), E2_SALDO+E2_INSS+E2_ISS+E2_IRRF,E2_BASEPIS)
							Else
								nBasePCC += E2_SALDO+E2_INSS+E2_ISS+E2_IRRF
							Endif
							If lPABruto
								nBasePCC += PABrtComp()
							Endif					
							nPisFat	+= SE2->E2_PIS - nPisRet		//(E2_PIS * E2_SALDO+nPCCRet) / E2_VALOR
							nCofFat	+= SE2->E2_COFINS - nCofRet		//(E2_COFINS * E2_SALDO+nPCCRet) / E2_VALOR
							nCslFat	+= SE2->E2_CSLL - nCslRet		//(E2_CSLL * E2_SALDO+nPCCRet) / E2_VALOR
			    		EndIf

            			//Tratamento de IRRF na Baixa
						If lIrpfBaixa 

							// Tratamento para o total de IR						
							If SA2->A2_TIPO == "J" 
								nTotIRPJ  += SE2->E2_IRRF
							Endif

							lUsaBaseIr := .F.
							//Verifico se controla a base de Impostos
							If lBaseIrpf
								If SE2->E2_BASEIRF > 0
									nBaseIrpf += SE2->E2_BASEIRF
									lUsaBaseIr := .T.
								Else
									nBaseIrpf += (SE2->E2_SALDO + SE2->E2_INSS)
								Endif
							Else							
								nBaseIrpf += (SE2->E2_SALDO + SE2->E2_INSS)
							Endif	

							//Se nao usou o valor do  
							If !lUsaBaseIr
								If !lCalcIssBx
									nBaseIrpf += SE2->E2_ISS
								EndIf
									
								If !lIRPFBaixa
									nBaseIrpf += SE2->E2_IRRF
								EndIf
							Endif

							//Se for PF, verifica se reduz o INSS da base do IRRF
							nBaseIrpf -= Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "1" .And. SA2->A2_TIPO != "J"),SE2->E2_INSS,0)							
						
						Endif	

						RecLock("SE2")
						SE2->E2_BAIXA	:= dDataBase
						SE2->E2_VALLIQ	:= SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
						SE2->E2_JUROS	:= nJur290
						SE2->E2_DESCONT	:= nDesc290
						SE2->E2_SALDO	:= 0
						SE2->E2_MOVIMEN := dDataBase
						SE2->E2_FATURA  := cFatura
						SE2->E2_FATPREF := cPrefix
						SE2->E2_TIPOFAT := cTipo
						SE2->E2_DTFATUR := dDataBase
						SE2->E2_FLAGFAT := "S"
						SE2->E2_SDACRES := 0
						SE2->E2_SDDECRE := 0
						SE2->E2_CORREC  := 	nValCorr                    
						If lDuplFat
							SE2->E2_FATFOR  := IIF(mv_par01 == 1,cForn,cFornP)
							SE2->E2_FATLOJ  := IIF(mv_par01 == 1,cLoja,cLojaP)
						EndIf
							
						//Zero os impostos para que não sejam contabilizados neste momento
						//Somente o serao na baixa do titulo gerado pela fatura.
						If lPCCBaixa .and. lContrRet
							nOldPis := SE2->E2_PIS
							nOldCof := SE2->E2_COFINS
							nOldCsl := SE2->E2_CSLL
							SE2->E2_PIS := 0
							SE2->E2_COFINS := 0
							SE2->E2_CSLL := 0
						Endif

						If lFA290HPAD .AND. SE2->( FieldPos( "E2_HIST" ) ) > 0
							SE2->E2_HIST := cHistFat
						EndIf

						MsUnlock( )

						If lAtuSldNat 
							// Tira o saldo do vencimento programado do titulo
							AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALLIQ, xMoeda(SE2->E2_VALLIQ, SE2->E2_MOEDA, 1), "-",,FunName(),"SE2",SE2->(Recno()),nOpcE)
						Endif	

						//Rastreamento - Geradores
						If lRastro
							aadd(aRastroOri,{	SE2->E2_FILIAL,;
													SE2->E2_PREFIXO,;
													SE2->E2_NUM,;
													SE2->E2_PARCELA,;
													SE2->E2_TIPO,;
													SE2->E2_FORNECE,;
													SE2->E2_LOJA,;
													SE2->E2_VALLIQ } )
						Endif
	                         
						//Documentos 
						IF AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. lFinVDoc
							If SE2->E2_TEMDOCS = "1"
								aAdd(aDocsOri,{SE2->E2_FILIAL,;
													SE2->E2_PREFIXO,;
													SE2->E2_NUM,;
													SE2->E2_PARCELA,;
													SE2->E2_TIPO,;
													SE2->E2_FORNECE,;
													SE2->E2_LOJA } )
							EndIf
						EndIf

						If SuperGetMV("MV_MRETISS",,"1")=="2" //Retencao do ISS na baixa
							nISSFat  += SE2->E2_ISS
							nFRetISS := SE2->E2_FRETISS
							nTRetISS := SE2->E2_TRETISS
						EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PcoDetLan("000015","02","FIN290")
							
						If lF290Baixa
						 	// Executa PE apos a baixa do titulo que gerou a fatura.
						 	// Pode ser retornado um historico que sera utilizado na
						 	// contabilizacao, atraves da variavel STRLCTPAD
							STRLCTPAD += ExecBlock("F290BAIXA",.F., .F.)
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Gera movimento da Baixa do Titulo	no SE5  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Localiza a sequencia da baixa ( CP,BA,VL,V2,LJ )				  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aTipoDoc := {"CP","BA","VL","V2"}
	
						SE5->(dbSetOrder(2))
						cSequencia := Replicate("0",nTamSeq)
						For nX := 1 to len(aTipoDoc)
							SE5->(dbSeek(cFilial + aTipoDoc[nX] + SE2->E2_PREFIXO + SE2->E2_NUM + ;
								SE2->E2_PARCELA + SE2->E2_TIPO) )
							While !SE5->(Eof())								.And. ;
									SE5->E5_FILIAL  == cFilial			.And. ;
									SE5->E5_TIPODOC == aTipoDoc[nX]     .And. ;
									SE5->E5_PREFIXO == SE2->E2_PREFIXO .And. ;
									SE5->E5_NUMERO  == SE2->E2_NUM		.And. ;
									SE5->E5_PARCELA == SE2->E2_PARCELA .And. ;
									SE5->E5_TIPO	  == SE2->E2_TIPO
	
								If ( SE5->E5_CLIFOR+SE5->E5_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA .And. SE5->E5_RECPAG=="P" )
									If PadL(AllTrim(cSequencia),nTamSeq,"0") < PadL(AllTrim(SE5->E5_SEQ),nTamSeq,"0")
										cSequencia := SE5->E5_SEQ
									Endif
								EndIf
								SE5->(dbSkip())
							EndDo
						Next
						If Len(AllTrim(cSequencia)) < nTamSeq
							cSequencia := PadL(AllTrim(cSequencia),nTamSeq,"0")
						Endif
						cSequencia := Soma1(cSequencia,nTamSeq)
	
						For nX := 1 To 4
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza a Movimenta‡„o Banc ria									  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nX==1
								cCpoTp  := "SE2->E2_VALLIQ"
								cTpDoc  := "BA"
								
							Elseif nX==2
								cCpoTp  := "nJur290"
								cTpDoc  := "JR"
							Elseif nX==3
								cCpoTp  :="nDesc290"
								cTpDoc  :="DC"      
							Elseif nX==4
								cCpoTp  :="nValCorr"
								cTpDoc  :="CM"	
							Endif
			
							If &cCpoTp != 0 .or. nX == 1
	
								RecLock("SE5",.T.)
								SE5->E5_FILIAL		:= xFilial("SE5")
								SE5->E5_DATA		:= dDataBase
								SE5->E5_VALOR		:= Iif (nX==4,&cCpoTp,xMoeda(&cCpoTp,SE2->E2_MOEDA,1,dDataBase))
								SE5->E5_NATUREZ	:= SE2->E2_NATUREZ
								SE5->E5_RECPAG		:= "P"
								SE5->E5_TIPO		:= SE2->E2_TIPO
								SE5->E5_TIPODOC	:= cTpDoc
								SE5->E5_HISTOR		:= Iif(nX <> 4,STR0056+cFatura,STR0069+STR0056+cFatura)  //"Bx.p/Emiss.Fatura "
								SE5->E5_PREFIXO	:= SE2->E2_PREFIXO
								SE5->E5_NUMERO		:= SE2->E2_NUM
								SE5->E5_PARCELA	:= SE2->E2_PARCELA
								SE5->E5_FORNECE	:= SE2->E2_FORNECE
								SE5->E5_CLIFOR		:= SE2->E2_FORNECE
								SE5->E5_LOJA		:= SE2->E2_LOJA
								SE5->E5_DTDIGIT	:= dDataBase
								SE5->E5_MOTBX		:= "FAT"
								SE5->E5_VLMOED2	:= Iif(nX <>4,&cCpoTp ,0)
								SE5->E5_VLCORRE	:= Iif(nX ==1,nValCorr,0)
								SE5->E5_SEQ			:= cSequencia
								SE5->E5_DTDISPO	:= dDataBase
								SE5->E5_BENEF		:= SE2->E2_NOMFOR
								SE5->E5_FILORIG		:= SE2->E2_FILORIG
								
								If lPEGrava
									Execblock("FI290GE5",.F.,.F.)
								EndIf

								If nX == 1  //Baixa Principal
									SE5->E5_VLJUROS	:= nJur290
									SE5->E5_VLDESCO	:= nDesc290
									If lAcredecre
										SE5->E5_VLACRES	:= Round(NoRound(xMoeda(nJur290,SE2->E2_MOEDA,1,,3),3),2)
										SE5->E5_VLDECRE	:= Round(NoRound(xMoeda(nDesc290,SE2->E2_MOEDA,1,,3),3),2)
									Endif							
									// Contabiliza a baixa do titulo
									IF lContab530
										If nHdlPrv <= 0
											nHdlPrv := HeadProva( cLote,;
											                      "FIN290",;
											                      substr( cUsuario, 7, 6 ),;
											                      @cArquivo )
										Endif

										//Contabiliza pela variavel VALOR. Nao necessita de controle de flag.
										//nTotal += DetProva(nHdlPrv,"530","FIN290",cLote)
										nTotal += DetProva( nHdlPrv,;
										                    "530",;
										                    "FIN290" /*cPrograma*/,;
										                    cLote,;
										                    /*nLinha*/,;
										                    /*lExecuta*/,;
										                    /*cCriterio*/,;
										                    /*lRateio*/,;
										                    /*cChaveBusca*/,;
										                    /*aCT5*/,;
										                    /*lPosiciona*/,;
										                    @aFlagCTB,;
										                    /*aTabRecOri*/,;
										                    /*aDadosProva*/ )
									EndIf
								Endif

								If lContab530 .And. nTotal > 0
									If lUsaFlag	// Armazena em aFlagCTB para atualizar no modulo Contabil
										aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
									Else
										SE5->E5_LA := "S"
									EndIf	
								EndIf

                            	SE5->( MsUnlock() )
								ABATIMENTO := 0
								
							Endif
						Next
						//Restauro os valores dos impostos
						If lPCCBaixa .and. lContrRet
							RecLock("SE2")
							SE2->E2_PIS := nOldPis
							SE2->E2_COFINS := nOldCof
							SE2->E2_CSLL := nOldCsl
							MsUnlock()
						Endif
						aArea := GetArea()
						DbSelectArea("SA2")
						SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
						SA2->(RecLock("SA2"))
						nMoedaC 	 := Int(Val(GetMv("MV_MCUSTO")))
						If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
							SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
							SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
						Else
							SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
							SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
						EndIf
						RestArea(aArea)
	
					Endif
				Endif
				dbSelectArea("SE2")
				dbGoto(nRecSe2)
			Enddo

			//Posiciono cadastro de fornecedor e natureza 
			//dos titulo a serem gerados pela fatura
			dbSelectArea("SA2")
			If mv_par01==1
				MsSeek(xFilial("SA2")+cForn+cLoja)			 
			Else
				MsSeek(xFilial("SA2")+cFornp+cLojap)			 
			EndIf
			SED->(MsSeek(xFilial("SED")+cNat))			 

			nValTotal := 0
	
			//Recrio as bases e valores de impostos de acordo com as alteracoes efetuadas
			//nas parcelas da fatura
			aBaseFat := aClone(aCols)
			aPisFat := aClone(aCols)
			aCofFat := aClone(aCols)
			aCslFat := aClone(aCols)
			aIrfFat	:= aClone(aCols)
			aISSFat := aClone(aCols)
			aBaseIR	:= aClone(aCols)


			//Obtenho a base do IR para esta parcela
			//Primeiro calculo o valor de base de IR Total (soma dos titulos que tem IR)
			//Segundo, aplico o redutor de base de IR sobre a base total.
			// Tenho a base total de IR da Fatura.
			// Proporcionalizo o valor de cada parcela
			//Exemplo
			//Titulo		Valor		BaseIR
			//	A			10.000	10.000
			//	B			10.000	 8.000
			//	C			10.000	     0
			//				------	------
			//Totais		30.000	18.000
			//
			// Valor da Fatura = 30.000
			// Valor dos titulos com IR = 20.000 (Soma de A+B (ignoro a base anterior))
			// --------------------------------------------------------
			//Parcelado em 2x com uma natureza com base IR de 80%
			//
			//Base total de IR com redução : (20.000 * 0.8) = 16.000
			//Titulo		Valor		BaseIR
			//	A			15.000	 8.000
			//	B			15.000	 8.000
			//				------	------
			//Totais		30.000	16.000
			// --------------------------------------------------------										
			//Parcelado em 2x com uma natureza com base IR de 100% (sem redutor)
			//
			//Base total de IR = 20.000
			//
			//Titulo		Valor		BaseIR
			//	A			15.000	10.000
			//	B			15.000	10.000
			//				------	------
			//Totais		30.000	20.000
			// -------------------------------------------------------

			//Obtenho o redutor de base do IRPF (natureza da fatura)
			lBaseIRPF  := If (FindFunction('F050BIRPF'),F050BIRPF(3),.F.)
			If lIrpfBaixa .and. ( lBaseIrpf .OR. SA2->A2_TIPO == "J" )

	            If nBaseIrpf < nValor
    	        	nPropIR := nBaseIrpf/nValor
					For nW := 1 to Len(aBaseIR)
						aBaseIR[nW,6]	:= (aBaseIR[nW,6] * nPropIr)
					Next
      			Endif

				nPropIr	:= If (SED->ED_BASEIRF > 0, (SED->ED_BASEIRF/100),1)	
				//Reduzo a base do IR para cada parcela 
				//de acordo com a base de IR da natureza da fatura
				If nPropIR < 1
					nBaseIrpf := nBaseIrpf * nPropIr
					For nW := 1 to Len(aBaseIR)
						aBaseIR[nW,6]	:= (aBaseIR[nW,6] * nPropIr)
					Next
				Endif

			Endif
	
			//Acerto os valores de base e impostos de acordo com a nova configuracao do aCols
			For nW := 1 to Len(aCols)
				nProp := aCols[nW,6] / nValor  //Proporcao entre a parcela e o valor total da fatura

				If nW < Len(aCols)
					aBaseFat[nW,6]	:= nBasePcc * nProp
					aPisFat[nW,6]	:= nPisFat * nProp
					aCofFat[nW,6]	:= nCofFat * nProp
					aCslFat[nW,6]	:= nCslFat * nProp
					aIrfFat[nW,6]	:= nTotIRPJ * nProp
					aBaseIr[nW,6]	:= nBaseIrpf * nProp					
					aISSFat[nW,6]	:= nISSFat * nProp

					nTotBase	+=	aBaseFat[nW,6]							
					nTotPis	+=	aPisFat[nW,6]
					nTotCof	+=	aCofFat[nW,6]
					nTotCsl	+=	aCslFat[nW,6]
					nTotISS	+= aISSFat[nW,6]
					nTtIRFat+= Round(NoRound(aIrfFat[nW,6],3),2)
					nTotIRF	+= Round(NoRound(aBaseIr[nW,6],3),2)			
				Else                                        
					aBaseFat[nW,6] := nBasePcc - nTotBase
					aPisFat[nW,6] := nPisFat - nTotPis
					aCofFat[nW,6] := nCofFat - nTotCof
					aCslFat[nW,6] := nCslFat - nTotCsl
					aISSFat[nW,6] := nISSFat - nTotISS
					aBaseIr[nW,6] := nBaseIrpf - nTotIRF
					aIrfFat[nW,6] := nTotIRPJ - nTtIRFat
				Endif
							
	      Next
	
			//-- Decrescimo
	      nVlDesc := nDecres / Len(aCols)
	      nSlDesc := nDecres
			
			//-- Acrescimo 
	      nVlAcre := nAcresc / Len(aCols)
	      nSlAcre := nAcresc
	      
			For nW:=1 To Len(aCols)
				If ! aCols[nW,8]  // .F. == Ativo  .T. == Deletado
					cPrefix	:= aCols[nW][1]
					cParcela := aCols[nW][3]
					cTipo    := aCols[nW][4]
					cVencmto := aCols[nW][5]
					nValDup	:= aCols[nW][6]
					nValCruz := xMoeda(aCols[nW,6],nMoeda,1)
					cBanco	:= aCols[nW][7]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Implantacao da Fatura			  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RecLock(cAliasSE2,.T.)
					Replace E2_FILIAL 	With  xFilial("SE2")
					Replace E2_NUM 		With  cFatura
					Replace E2_PARCELA	With  cParcela
					Replace E2_PREFIXO	With  cPrefix
					Replace E2_NATUREZ	With  cNat
					Replace E2_VENCTO 	With  cVencmto
					Replace E2_VENCREA	With  DataValida(E2_VENCTO,.T.)
					Replace E2_VENCORI	With  SE2->E2_VENCTO					
					Replace E2_EMISSAO	With  dDatabase
					Replace E2_EMIS1	With  dDatabase
					Replace E2_TIPO		With  cTipo
					Replace E2_FORNECE	With  IIF(mv_par01 == 1,cForn,cFornP)
					Replace E2_LOJA		With  IIF(mv_par01 == 1,cLoja,cLojaP)
					Replace E2_VALOR	With  nValDup
					Replace E2_SALDO	With  nValDup
					Replace E2_MOEDA	With  nMoeda
					Replace E2_PORTADO	With  cBanco
					Replace E2_FATURA 	With  "NOTFAT"
					Replace E2_NOMFOR 	With  SA2->A2_NREDUZ
					Replace E2_VLCRUZ	With  xMoeda(nValDup,nMoeda,1)  // nValCruz
					Replace E2_ORIGEM 	With  "FIN290"
					Replace E2_MULTNAT	With	"2"	   
									
					If SE2->(FieldPos("E2_FILORIG")) > 0
						Replace SE2->E2_FILORIG  With cFilAnt
					EndIf
										
					If SuperGetMV("MV_MRETISS",,"1")=="2" //Retencao do ISS na baixa
						Replace E2_ISS 		With  aISSFat[nW,6]
						Replace E2_FRETISS 	With  nFRetISS
						Replace E2_TRETISS 	With  nTRetISS
					EndIf

					//Gravar campo de base do IRPF
					If lIrpfBaixa .and. lBaseIrpf
						Replace E2_BASEIRF	With aBaseIR[nW,6]
						Replace E2_PRETIRF 	With "1"						
					Endif

					// Grava o valor do IRPJ	
					If lIrpfBaixa .and. SA2->A2_TIPO == "J" .AND. Len(aIrfFat) > 0
						Replace E2_IRRF 	With aIrfFat[nW,6]
						Replace E2_BASEIRF	With aBaseIR[nW,6]
						Replace E2_PRETIRF 	With "1"
					EndIf

					//Impostos Lei 10925 para tratamento na baixa.
					If lPccBaixa .and. lContrRet .and. lBaseSE2 .and. ;
						(Len(aPisFat)+Len(aCofFat)+Len(aCslFat)> 0 ) .and. ;
						(nW <= Len(aPisFat) .and. nW <= Len(aCofFat) .and. nW <= Len(aCslFat)) .and. ;
						(aPisFat[nW,6]+aCofFat[nW,6]+aCslFat[nW,6] > 0)
	
						Replace E2_PIS			With  aPisFat[nW,6]
						Replace E2_COFINS		With  aCofFat[nW,6]
						Replace E2_CSLL		With  aCslFat[nW,6]
						Replace E2_BASEPIS 	With  aBaseFat[nW,6]
						Replace E2_BASECOF 	With  aBaseFat[nW,6]
						Replace E2_BASECSLL	With  aBaseFat[nW,6]
						Replace E2_PRETPIS  	With  "1"
						Replace E2_PRETCOF 	With  "1"
						Replace E2_PRETCSL 	With  "1"
					Endif				
					
					If lPccBaixa
						Replace E2_CODRET With "5952"						
					Endif
					
					If nDecres > 0
						Replace E2_DECRESC   With Iif(nW == Len(aCols),nSlDesc,nVlDesc)
						Replace E2_SDDECRE   With Iif(nW == Len(aCols),nSlDesc,nVlDesc)
						nSlDesc -= nVlDesc
					EndIf

					If nAcresc > 0
						Replace E2_ACRESC    With Iif(nW == Len(aCols),nSlAcre,nVlAcre)
						Replace E2_SDACRES   With Iif(nW == Len(aCols),nSlAcre,nVlAcre)
						nSlAcre -= nVlAcre
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Flag de Lancamento contabil	   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lPadrao 
						If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
							aAdd( aFlagCTB, { "E2_LA", "S", "SE2", SE2->( RecNo() ), 0, 0, 0} )
						Else	
							SE2->E2_LA := "S"
						EndIf
					EndIf

					//Documentos 
					IF AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. lFinVDoc
						If Len(aDocsOri) > 0
							SE2->E2_TEMDOCS := "1"
						EndIf
					EndIf

					MsUnlock()
					
					If lAtuSldNat 
						// Somo o saldo do vencimento programado do titulo
						AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALOR, SE2->E2_VLCRUZ, "+",,FunName(),"SE2",SE2->(Recno()),nOpcE)
					Endif
					aArea := GetArea()
					DbSelectArea("SA2")
					SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
					SA2->(RecLock("SA2"))
					nMoedaC 	 := Int(Val(GetMv("MV_MCUSTO")))
					If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
						SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
						SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
					Else
						SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
						SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
					EndIf
					RestArea(aArea)

					If lFA290
						ExecBlock("FA290",.f.,.f.)
					Endif
		         	nValTotal += xMoeda(nValDup,nMoeda,1)  // nValCruz
					IF lPadrao
						If nHdlPrv <= 0
							nHdlPrv := HeadProva( cLote,;
							                      "FIN290",;
							                      substr( cUsuario, 7, 6 ),;
							                      @cArquivo )
						Endif

						VALOR := 0

						//Contabiliza pela variavel VALOR. Nao necessita de controle de flag.
						nTotal += DetProva( nHdlPrv,;
						                    cPadrao,;
						                    "FIN290" /*cPrograma*/,;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )
					EndIf

					dbSelectArea("SE2")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PcoDetLan("000015","01","FIN290")

					//Rastreamento - Gerados
					If lRastro
						aadd(aRastroDes,{	SE2->E2_FILIAL,;
												SE2->E2_PREFIXO,;
												SE2->E2_NUM,;
												SE2->E2_PARCELA,;
												SE2->E2_TIPO,;
												SE2->E2_FORNECE,;
												SE2->E2_LOJA,;
												SE2->E2_VALOR } )
					Endif
					                         
					//Documentos 
					IF AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. lFinVDoc
						If Len(aDocsOri) > 0
							aAdd(aDocsDes,{SE2->E2_FILIAL,;
												SE2->E2_PREFIXO,;
												SE2->E2_NUM,;
												SE2->E2_PARCELA,;
												SE2->E2_TIPO,;
												SE2->E2_FORNECE,;
												SE2->E2_LOJA } )
						EndIf
					EndIf
					
				Endif
			Next nW
			
			//Gravacao do rastreamento
			If lRastro
				FINRSTGRV(2,"SE2",aRastroOri,aRastroDes,nValTotal) 
			Endif

			If Len(aDocsOri) > 0
				CN062GrvFat(aDocsOri,aDocsDes)
			EndIf

		End Transaction
		
		If nTotal > 0
			dbSelectArea("SE2")
			nRecSe2 := Recno()
			SE2->(DBGoBottom())
			SE2->(dbSkip())
			VALOR := nValTotal

			//Contabiliza pela variavel VALOR. Nao necessita de controle de flag.
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FIN290" /*cPrograma*/,;
			                    cLote,;
			                    /*nLinha*/,;
			                    /*lExecuta*/,;
			                    /*cCriterio*/,;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )

			RodaProva(  nHdlPrv,;
						nTotal )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lancamento Contabil						³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita := IIf( mv_par02 == 1, .T., .F. )
			cA100Incl( cArquivo,;
			           nHdlPrv,;
			           3 /*nOpcx*/,;
			           cLote,;
			           lDigita,;
			           .F.,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           /*aDiario*/ )

			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento


			VALOR := 0        
			dbSelectArea("SE2")
			SE2->(DBGoTo(nRecSe2))			
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no SX6 o numero da ultima fatura gerada. 						  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GetMv("MV_NUMFATP")
		RecLock( "SX6",.F. )
		SX6->X6_CONTEUD := cFatura
		MsUnlock()

	Endif
Else
	DbSelectArea("SE2")
	// Destrava os registros.
	dbGoTop()
	While !EOF()
		SE2->(MsUnlock())
		dbSkip()
	Enddo
Endif
If !Empty(aChaveLbn)
	aEval(aChaveLbn, {|e| UnLockByName(e,.T.,.F.) } ) // Libera Lock
Endif
cFatura	 := CRIAVAR("E2_FATURA")
cForn 	 := CriaVar("A2_COD")
cNat		 := Space(10)
cPrefix 	 := CRIAVAR("E2_PREFIXO",.T.)
cLoja 	 := CriaVar("A2_LOJA")
dDataDe	 := dDatabase
dDataAte  := dDatabase
nValorFat := 0
aVlCruz	 := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

dbSelectArea("SE2")

RetIndex( "SE2" )
// Restaura o filtro
Set Filter To &cSetFilter.
If !Empty(cIndex)
	fErase(cIndex+OrdBagExt())
	cIndex:=""
Endif

// Restaura indice original do SE2 que foi selecionado no Browse

SE2->(dbSetOrder(nIndSE2)) 
SE2->(dbGoto(nRecnoSE2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza integracao com Modulo PCO                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000015")

Return (nOpca == 1)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fa290num ³ Autor ³ Paulo Boschetti		  ³ Data ³ 27/07/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se ja' existe numero do titulo.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290num()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa290num(cFatAnt)

Local aAreaSE2:= SE2->(GetArea())
Local lRet := .T. 
Local cFornLoja := IIF(mv_par01 == 1,cForn+cLoja,cFornp+cLojaP)

If !MayIUseCode( "SE2"+xFilial("SE2")+cPrefix+cFatura+cTipo+cFornLoja)  //verifica se esta na memoria, sendo usado
	// busca o proximo numero disponivel 
	Help(" ",1,"A290EXIST")
	oFatura:SetFocus()
	lFocus := .T.
	lRet := .F.
Else
	dbSelectArea("SE2")
	dbSetOrder(6)
	If dbSeek(xFilial("SE2")+cFornLoja+cPrefix+cFatura)
		While !Eof() .and.SE2->E2_FILIAL == xFilial("SE2") .and. ;
				cFornLoja+cPrefix+cFatura == SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
	
			If (!lDuplFat .And. SE2->E2_TIPO == cTipo) .Or.;
				(lDuplFat .And. SE2->E2_TIPO == cTipo .and. SE2->(E2_FORNECE+E2_LOJA) == cFornLoja)
				Help(" ",1,"A290EXIST")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Retorno .T. para que possa focar o campo do numero da³
				//³ fatura para altera‡Æo e posterior valida‡Æo. A valida³
				//³ ‡Æo neste caso ‚ feita somente no Fornecedor e ao con³
				//³ firmar a opera‡Æo da fatura.                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oFatura:SetFocus()
				lFocus := .T.
				lRet := .F.
				Exit
			Else
				dbSkip()
			Endif
		Enddo
	Else
		If cFatura <> cFatAnt
			FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
		Endif	
		If	!MayIUseCode( "SE2"+xFilial("SE2")+cPrefix+cFatura+cTipo+cFornLoja )
			oFatura:SetFocus()
			lFocus := .T.
			lRet := .F.
		Endif	
	Endif
Endif
RestArea(aAreaSe2)

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA290For ³ Autor ³ Paulo Boschetti		  ³ Data ³ 27/07/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica validade do Fornecedor									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290For()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa290For( cFornecedor, cLoja )

Local aAreaSe2 := SE2->(GetArea())
Local lRet	:= .F.

If !Empty(cFornecedor)
	dbSelectArea("SA2")
	dbSetOrder(1)
	cLoja:=Iif(cLoja == Nil,"",cLoja)
	If dbSeek(xFilial("SA2")+cFornecedor+cLoja)
		lRet := .T.
	Endif
Endif

RestArea(aAreaSe2)

Return ( lRet )

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GravaDup ³ Autor ³ Paulo Boschetti		  ³ Data ³ 12/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Formata Array com os desdobramentos dos titulos 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GravaDup(nDup,cPrefixo,cNumero,nValor,dVencto,aVenc)

Local nTamParcela := TamSx3("E2_PARCELA")[1]  
Local cParcSE2		:= SuperGetMv("MV_1DUP")
Local cParcela		:= Space(nTamParcela)
Local cTmpParcela	:= Space(nTamParcela)
Local nValorTit	:= NoRound((nValor/nDup))
Local nValDup		:= nValor
Local nMaxParc		:= 1
Local nTamBanco	:= TamSx3("A6_COD")[1]
Local ni				:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da matriz aHeader											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aHeader,{ OemToAnsi(STR0032),"E2_PREFIXO"	,"@!"                 ,TamSx3("E2_PREFIXO")[1] ,0,"","û","C","SE2" } )          //"Prf"
AADD(aHeader,{ OemToAnsi(STR0033),"E2_NUM"		,"@!"                 ,TamSx3("E2_NUM")[1],0,"","û","C","SE2" } )     //"N£mero"
AADD(aHeader,{ OemToAnsi(STR0034),"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA"),TamSx3("E2_PARCELA")[1],0,"","û","C","SE2" } ) //"Ord"
AADD(aHeader,{ OemToAnsi(STR0054),"E2_TIPO"		,"@!"                 ,TamSx3("E2_TIPO")[1],0,"","û","C","SE2" } )          //"Tipo"
AADD(aHeader,{ OemToAnsi(STR0035),"E2_DTFATUR"	,"99/99/99"           ,TamSx3("E2_DTFATUR")[1],0,"","û","D","SE2" } )          //"Vencimento"
AADD(aHeader,{ OemToAnsi(STR0036),"E2_VALOR"		,"@E 9,999,999,999.99",TamSx3("E2_VALOR")[1],TamSx3("E2_VALOR")[2],"Fa290AtuVl()","û","N","SE2"})//"Valor Duplicata"
AADD(aHeader,{ OemToAnsi(STR0037),"A6_COD"		,"@!"                 ,TamSx3("A6_COD")[1],0,"","û","C","SA6" })           //"Banco"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava aCols com os valores das duplicatas				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aCOLS[nDup][8]

// Verifica o tamnho da parcela
If nDup > 1
	//Verifica a validade do parametro
	If Len(GetMV("mv_1dup")) >= 1
		cTmpParcela := Substr(GetMV("mv_1dup"),Len(GetMV("mv_1dup"))+1-nTamParcela,nTamParcela)
	Else
		IW_MSGBOX(STR0064 + Str(nMaxParc,2) + CHR(13)+ ;  //"Número máximo de parcelas permitido "
					 STR0065 + Str(nDup,4) + CHR(13)+; //"Número de parcelas da condição de pagto. "
					 STR0066, STR0067,"STOP") //"Verifique parâmetro MV_1DUP."###"Atenção"		
		Return {}
	EndIf
	// Se parcela tiver apenas um digito, ou o parametro tiver apenas um digito, verifica a quantidade maxima de parcelas
	If nTamParcela == 1 .Or. Len(AllTrim(GetMV("mv_1dup"))) == 1
		// Verifica a quantidade maxima de parcelas
		cParcela := cTmpParcela
		For ni := 1 To 63
			cParcela:=Soma1( cParcela,, .T. )
			If AllTrim(cParcela) == "*"
				Exit
			Endif
		   nMaxParc++
		Next
		If nDup > nMaxParc
			IW_MSGBOX(STR0064 + Str(nMaxParc,2) + CHR(13)+ ;  //"Número máximo de parcelas permitido "
						 STR0065 + Str(nDup,4) + CHR(13)+; //"Número de parcelas da condição de pagto. "
						 STR0066, STR0067,"STOP") //"Verifique parâmetro MV_1DUP."###"Atenção"
			Return {}
		Endif
	Endif
EndIf

For ni:=1 To nDup
	cParcSE2 := Right("000"+cParcSE2,nTamParcela)		
	nValorTit	:= aVenc[ni][2]
	cParcela		:= cTmpParcela	
	aCols[ni,1]	:= cPrefixo
	aCols[ni,2]	:= cNumero
	aCols[ni,3]	:= cParcSE2
	aCols[ni,4]	:= cTipo
	aCols[ni,5]	:= aVenc[ni,1]
	aCols[ni,6]	:= IIf(ni<nDup,nValorTit,nValDup)
	aCols[ni,7] := Space(nTamBanco)
	aCols[ni,8]	:= .F.	                       
	
	cParcSE2 := Soma1(cParcSE2,nTamParcela,.T.)
	
	nValDup-=nValortit
NEXT ni
Return(aCols)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Fa290ChecF³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 14/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Selecao para a criacao do indice condicional 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290ChecF()
Local cFiltro := ""		
Local nValmin := 0
LOcal lVerLibTit := .T.
Local lPrjCni 		:= FindFunction("ValidaCNI") .And. ValidaCNI()
IF lF290LIBT
	lVerLibTit :=ExecBlock("F290LIBT",.f.,.f.)
Endif

cFiltro += 'E2_FILIAL=="'+xFilial("SE2") + '"'
cFiltro += '.AND.E2_SALDO>0'
cFiltro += '.AND.E2_FORNECE=="' + cForn + '"'

If lf290OWN
	cFiltro += ExecBlock("F290OWN",.F.,.F.)
Else
	cFiltro += '.AND.DTOS(E2_EMISSAO)>="' + DTOS( dDataDe ) + '"'
	cFiltro += '.AND.DTOS(E2_EMISSAO)<="' + DTOS( dDataAte ) + '"'
Endif

If lVerLibTit
	// controla Liberacao do titulo
	If GetMv("MV_CTLIPAG") 
		nValmin:= GetMV("MV_VLMINPG")	
	 	cFiltro += ".AND. (!(DTOS(SE2->E2_DATALIB) = '        ').or. (DTOS(SE2->E2_DATALIB) = '        '.and.(E2_SALDO+E2_SDACRES-E2_SDDECRE)< " + str(nValmin)+ "))"
	EndIf
EndIf         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ AAF - Titulos originados no SIGAEFF não devem ser alterados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFiltro += ".AND. !('SIGAEFF' $ E2_ORIGEM) "

cFiltro += '.AND.E2_MOEDA=' + AllTrim(Str( nMoeda,2 ))
cFiltro += '.AND.E2_FATURA=="' + Space( Len( E2_FATURA ) ) + '"'   

if lPrjCni
	If SE2->(FieldPos("E2_NUMSOL")) > 0 
		cFiltro += "  .AND. E2_NUMSOL=='"+ Space( Len( E2_NUMSOL ) ) + "'  "
	EndIf
EndIf

cFiltro += '.AND.E2_NUMBOR=="' + Space( Len( E2_NUMBOR ) ) + '"'
cFiltro += '.AND.!(E2_TIPO $"'+MVPAGANT+"/"+MVPROVIS+'")'

IF mv_par01 == 1
	cFiltro += '.And.E2_LOJA=="'+cLoja+'"'
EndIF

cFiltro := '(' + cFiltro + ') .And. (' + cFil290 + ')'
If lf290CHK
	cFiltro := ExecBlock("F290CHK",.F.,.F.,cFiltro)
Endif

Return cFiltro

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA290CAN   ³ Autor ³ Cesar C S Prado		 ³ Data ³ 03/05/94 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marcacao dos titulos para cancelamento de fatura				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA290CAN()													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA290CAN(cAlias,cCampo,nOpcE,aFatPag)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin 	:= If (lPanelFun,IsPanelFin(),.F.)
Local cArquivo
Local nTotal		:=0
Local nHdlPrv		:=0
Local lPadrao
Local cPadrao		:="593"
Local oDlg, nOpca 	:= 0
Local nValor		:= 0
Local l290CalCn		:= .F.
Local cChaveSE2		:= ""
Local nValTotal 	:= 0
Local lAcreDecre 	:= .F.
Local nAcresc 		:= 0
Local nDecresc 		:= 0
Local dBaixa 		:= CTOD("//")
Local lRet   		:=.T.
Local lValidCan		:=ExistBlock("FA290OKC")
Local lContab531 	:= VerPadrao("531") .And. ( mv_par04 == 1 )
Local lFatAut		:= .F.
Local aFatCan		:= {}
Local lDocFat		:= .F.
Local aAreaSe2		:= {}      
Local nAbat			:=	0

//Controle de Rastreamento Financeiro
Local lRastro		:= If(lRstFin,FVerRstFin(),.F.)

//Controle de Contabilizacao
Local aFlagCTB		:= {}
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local lAtuSldNat  	:= lFuncAtuSld .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
Local nMoedaC 	 	:= 1
Local aArea 		:= {}
Private oTitulos,oValorCan
Private cIndex 	 	:= ""
Private cFatCan	 	:= CriaVar("E2_NUM"    , .F.)
Private cPrefCan	:= CriaVar("E2_PREFIXO", .F.)
Private cTipoCan	:= CriaVar("E2_TIPOFAT")
Private cFornCan	:= CriaVar("E2_FORNECE", .F.)
Private cLojaCan	:= CriaVar("E2_LOJA"   , .F.)
Private cLote

DEFAULT aFatPag := {}
AjustaSx1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return .F.
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se se o processo será contabilizado                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPadrao := VerPadrao(cPadrao) .and. mv_par04 == 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont( "FIN" )

//Verifica se o cancelamento da fatura foi feito via rotina semi-automatica
//Necessário que o SE2 esteja posicionado em um dos titulos gerados 
If !Empty(aFatPag)
	lFatAut := .T.
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ACIONA A FUNCAO PERGUNTE												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI290",.T.)})
Pergunte("AFI290",.F.)

//verifica se existem os campos de valores de acrescimo e decrescimo no SE5
If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
	lAcreDecre := .T.
Endif

dbSelectArea("SE2")
cFornCan 	:= SE2->E2_FORNECE
cLojaCan 	:= SE2->E2_LOJA
cFatCan		:= SE2->E2_NUM
cPrefCan 	:= SE2->E2_PREFIXO
cTipoCan	:= SE2->E2_TIPO

nValor		:= 0
nTitulos 	:= 0
nFaturas 	:= 0

FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.F.)


If lFatAut
	nOpca := 1
Else
aSize := MSADVSIZE()
If lPanelFin //Chamado pelo Painel Financeiro				
	dbSelectArea(cAlias)
	oPanelDados := FinWindow:GetVisPanel()
	oPanelDados:FreeChildren()
	aDim := DLGinPANEL(oPanelDados)
	DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
	//³ -------------------------------------------------------------- ³ 		
	//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
	//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
	//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 116) /2		 					
	nEspLin  := 0
		
Else   
  	nEspLarg := 0 
  	nEspLin  := 0
DEFINE MSDIALOG oDlg FROM	15,6 TO 243,345 TITLE OemToAnsi(STR0038) PIXEL // "Cancelamento de Fatura a Pagar"
Endif

oDlg:lMaximized := .F.
oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		


@ 39+nEspLin, 11+nEspLarg TO 068+nEspLin, 127+nEspLarg OF oPanel	PIXEL
@ 72+nEspLin, 11+nEspLarg TO 104+nEspLin, 127+nEspLarg OF oPanel	PIXEL
@ 07+nEspLin, 11+nEspLarg TO 036+nEspLin, 127+nEspLarg OF oPanel	PIXEL

@ 22+nEspLin, 14+nEspLarg MSGET cFornCan Valid Fa290For(cFornCan)	SIZE 70, 08 OF oPanel PIXEL
@ 22+nEspLin, 87+nEspLarg MSGET cLojaCan Valid Fa290For(cFornCan,cLojaCan)	SIZE 20, 08 OF oPanel PIXEL
@ 54+nEspLin, 14+nEspLarg MSGET cPrefCan 								SIZE 21, 08 OF oPanel PIXEL
@ 54+nEspLin, 40+nEspLarg MSGET cTipoCan		F3 "05";
	Picture "@!" 		 ;
	SIZE 12, 08 OF oPanel PIXEL hasbutton ;
	Valid If(nOpca<>0,!Empty (cTipoCan) .and. FA290Tipo(cTipoCan),.T.)
@ 54+nEspLin, 75+nEspLarg MSGET cFatCan Valid If(nOpca<>0,!Empty(cFatCan) .and. ;
	FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.),.T.) ;
	SIZE 49, 08 OF oPanel PIXEL
@ 88+nEspLin, 14+nEspLarg MSGET nTitulos		When .F. SIZE 28, 08 OF oPanel PIXEL
@ 88+nEspLin, 53+nEspLarg MSGET nValor		Picture "@E 999,999,999.99" When .F. SIZE 71, 08 OF oPanel PIXEL
@ 12+nEspLin, 14+nEspLarg SAY OemToAnsi(STR0039) SIZE 70, 7 OF oPanel PIXEL //"Fornecedor"
@ 12+nEspLin, 87+nEspLarg SAY OemToAnsi(STR0040) SIZE 20, 7 OF oPanel PIXEL //"Loja"
@ 44+nEspLin, 14+nEspLarg SAY OemToAnsi(STR0041) SIZE 21, 7 OF oPanel PIXEL //"Prefixo"
@ 44+nEspLin, 43+nEspLarg SAY OemToAnsi(STR0054) SIZE 12, 7 OF oPanel PIXEL //"Tipo"
@ 44+nEspLin, 74+nEspLarg SAY OemToAnsi(STR0042) SIZE 49, 7 OF oPanel PIXEL //"N£mero T¡tulo"
@ 78+nEspLin, 14+nEspLarg SAY OemToAnsi(STR0043) SIZE 35, 7 OF oPanel PIXEL //"Total Notas"
@ 78+nEspLin, 53+nEspLarg SAY OemToAnsi(STR0044) SIZE 53, 7 OF oPanel PIXEL //"Valor da Fatura"


If lPanelFin  //Chamado pelo Painel Financeiro			
		oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
		ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
		{||nOpca:=1,IF(IF(l290CalCn,.T.,Fa290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.)),oDlg:End(),nOpca:=0)},;
		{||oDlg:End()})
		
		FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

Else	
		DEFINE SBUTTON FROM 10, 133 TYPE 1 ACTION (nOpca:=1,;
			IF(IF(l290CalCn,.T.,Fa290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.)),;
			oDlg:End(),nOpca:=0)) ENABLE OF oDlg
		DEFINE SBUTTON FROM 23, 133 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED
Endif
Endif

If nOpcA == 1
	//Posicionando na fatura... 
	aAreaSe2		:= SE2->(GetArea())
	nAbat			:=	0
	If SE2->(dbSeek(xFilial("SE2")+cPrefCan+cFatCan))
		//Encontrando a fatura.... e guardando o campo PARCELA...
		While !EoF() .And. (SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM) == cFilAnt+cPrefCan+cFatCan) 
			If SE2->(E2_TIPO+E2_FORNECE+E2_LOJA) == (cTipoCan+cFornCan+cLojaCan)				
				//Verificando se a Fatura tem algum abatimento...				
				nAbat := SumAbatPag(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_FORNECE, SE2->E2_MOEDA, "V", SE2->E2_BAIXA, SE2->E2_LOJA)							
				Exit  			
			Endif
			SE2->(dbSkip())
		Enddo
	EndIf
	SE2->(RestArea(aAreaSe2))	
	
	//Verifica se há documentos vinculados a fatura e os apaga na tabela FRD
	If AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ApagDocs") .And. lFinVDoc
		aFatCan := {}
		dbSelectArea("SE2")
		dbSetOrder(1)		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		If dbSeek(xFilial("SE2")+cPrefCan+cFatCan)
			If SE2->E2_TEMDOCS == "1"
				lDocFat := .T.
				While !EoF() .And. (SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM) == cFilAnt+cPrefCan+cFatCan) .And. (SE2->(E2_TIPO+E2_FORNECE+E2_LOJA) == cTipoCan+cFornCan+cLojaCan)
					AADD(aFatCan,{SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA})
					SE2->(dbSkip())
				End
			EndIf
		EndIf
	EndIf

	If lFA290C
		ExecBlock("FA290C",.f.,.f.)
	Endif
	If lValidCan
		lRet:=ExecBlock("FA290OKC",.F.,.F.)
		If ValType(lRet) # "L"
			lRet:=.T.
		EndIf
	EndIf
	If lRet 
		dbSelectArea("SE2")
		If nAbat > 0
			MsgAlert(STR0073)	//'Esta fatura possui um abatimento. Favor exclui-lo antes de cancelar a fatura.'		
		Endif		
					
		If Fa290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.) .And. nAbat == 0
			SE2->(dbGoTop())
			nValTotal := 0
			Begin Transaction
				dbSelectArea("SE2")
				While SE2->(!Eof()) .And. SE2->E2_FILIAL == cFilial
					SE2->(dbSkip())
					nRecSe2 := SE2->(RecNo())
					SE2->(dbSkip(-1))
					If	(!lDuplFat .And. SE2->E2_FATURA == cFatCan .and. SE2->E2_TIPOFAT == cTipoCan) .Or.;
						(lDuplFat .And. SE2->E2_FATURA == cFatCan .And. SE2->E2_TIPOFAT == cTipoCan .And.;
						 SE2->E2_FORNECE == cFornCan .And. SE2->E2_LOJA == cLojaCan  .or.;
										  	SE2->E2_FATFOR == cFornCan .And. SE2->E2_FATLOJ == cLojaCan)
						If !lDuplFat
							cChaveSE2 := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
						Else
							cChaveSE2 := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+IIf(mv_par01==1,cFornCan+cLojaCan,E2_FORNECE+E2_LOJA))
						EndIf
						nAcresc := 0
						nDecresc := 0
						dbSelectArea("SE5")
						dbSetOrder(7)
						If dbSeek(xFilial("SE5")+cChaveSE2)
							While !Eof() .and. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveSE2
								If SE5->E5_MOTBX== "FAT" .and. SE5->E5_RECPAG == "P"
									// Verifica movimentacao de AVP
									If lFAVPFunc
										FAVPValTit( "SE2", SE5->( RecNo() ) )
									EndIf

									If lAcreDecre
										nAcresc += SE5->E5_VLACRES
										nDecresc += SE5->E5_VLDECRE
										dBaixa := SE5->E5_DATA
									Endif
									// Contabiliza o cancelamento da baixa do titulo, 
									// somente se o título foi contabilizado anteriormente.
									If lContab531 .And. SE5->E5_LA == "S "
										If nHdlPrv <= 0
											nHdlPrv:=HeadProva(cLote,"FIN290",Substr(cUsuario,7,6),@cArquivo)
										Endif
										nTotal+=DetProva(nHdlPrv,"531","FIN290",cLote)
									Endif
									RecLock("SE5")
									dbDelete()
									MsUnlock()
								Endif
								dbSkip()
							Enddo	
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se for um titulo que gerou a fatura, desfaz o processo		³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lAtuSldNat
							// Volto o saldo da natureza
							AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALLIQ, xMoeda(SE2->E2_VALLIQ, SE2->E2_MOEDA, 1),If(SE2->E2_TIPO$MVABATIM,"-","+"),,FunName(),"SE2",SE2->(Recno()),nOpcE)
						Endif
						dbSelectArea("SE2")
						RecLock("SE2")
						SE2->E2_SALDO		+= E2_VALLIQ - E2_JUROS + E2_DESCONT
						SE2->E2_MOVIMEN	:= dDataBase
						SE2->E2_FATURA		:= " "
						SE2->E2_FATPREF	:= " "
						SE2->E2_TIPOFAT	:= " "
						If lDuplFat
							SE2->E2_FATFOR    := " "
							SE2->E2_FATLOJ    := " "
						EndIf
						SE2->E2_DTFATUR	:= CtoD("  /  /  ")
						SE2->E2_JUROS		:= 0
						SE2->E2_DESCONT	:= 0
						SE2->E2_VALLIQ		:= 0
						SE2->E2_CORREC := 	0                    
						If SE2->E2_SALDO == SE2->E2_VALOR
							SE2->E2_BAIXA	:= CtoD("  /  /  ")
							SE2->E2_SDDECRE := SE2->E2_DECRESC
							SE2->E2_SDACRES := SE2->E2_ACRESC
						ElseIf lAcreDecre 
							SE2->E2_SDACRES := IIF(SE2->E2_SDACRES<>0, Round(NoRound(xMoeda(SE2->E2_ACRESC,1,SE2->E2_MOEDA,dBaixa,3),3),2), SE2->E2_SDACRES)
							SE2->E2_SDDECRE := IIF(SE2->E2_SDDECRE<>0, Round(NoRound(xMoeda(SE2->E2_DECRESC,1,SE2->E2_MOEDA,dBaixa,3),3),2), SE2->E2_SDDECRE)
						Endif
						SE2->E2_FLAGFAT   := Space(Len(SE2->E2_FLAGFAT))
						MsUnlock()

						aArea := GetArea()
						DbSelectArea("SA2")
						SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
						SA2->(RecLock("SA2"))
						nMoedaC 	 := Int(Val(GetMv("MV_MCUSTO")))
						If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
							SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
							SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
						Else
							SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
							SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
						EndIf
						RestArea(aArea)
						
					Else
						nReg := SE2->(RecNo())
						If lPadrao
							If nHdlPrv <= 0
								nHdlPrv:=HeadProva(cLote,"FIN290",Substr(cUsuario,7,6),@cArquivo)
							Endif
							nTotal+=DetProva(nHdlPrv,cPadrao,"FIN290",cLote)
						Endif
						dbSelectArea("SE2")
						nReg:=IIf(RecNo() != nReg, dbGoTo(nReg), nReg)
						nValTotal += SE2->E2_VLCRUZ
						//Ponto de entrada para tratamento especifico de dados do titulo a ser deletado
						IF lF290CN2
							ExecBlock("F290CN2",.F.,.F.)
						Endif

						aArea := GetArea()
						DbSelectArea("SA2")
						SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
						SA2->(RecLock("SA2"))
						nMoedaC 	 := Int(Val(GetMv("MV_MCUSTO")))
						If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
							SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
							SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
						Else
							SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
							SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
						EndIf
						RestArea(aArea)

						If lAtuSldNat
							// Volto o saldo da natureza
							AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALOR, SE2->E2_VLCRUZ,If(SE2->E2_TIPO$MVABATIM,"+","-"),,FunName(),"SE2",SE2->(Recno()),nOpcE)
						Endif
						RecLock("SE2",.F.,.T.)
						dbDelete()
						MsUnlock()
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ PONTO DE ENTRADA F290CAN                                      ³
					//³ Este PE serve para grava‡äes complementares ap¢s cancelamento ³
					//³ do titulo na fatura.                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF lF290CAN
						ExecBlock("F290CAN",.F.,.F.)
					Endif
					dbSelectArea("SE2")
					dbGoto(nRecSe2)
				Enddo 
				
				// Cancelamento do rastreamento(FI7/FI8)
				If lRastro
					FINRSTDEL("SE2",cChaveSe2)
				Endif
			End Transaction
			
			//Apaga o registro da fatura na tabela FRD
			IF lDocFat .And. lFinVDoc		//AliasIndic("FRD") .AND. SE2->(FieldPos("E2_TEMDOCS")) > 0 .And. FindFunction("CN062ApagDocs")
				CN062ApagDocs(aFatCan)
			EndIf
				
			If nTotal > 0
				dbSelectArea("SE2")
				nRecSe1 := Recno()
				SE2->(DBGoBottom())
				SE2->(dbSkip())
				VALOR := nValTotal
				nTotal+=DetProva(nHdlPrv,cPadrao,"FIN290",cLote)
				RodaProva(nHdlPrv,nTotal)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia para Lancamento Contabil							  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lDigita:=IIF(mv_par02==1,.T.,.F.)
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
				VALOR := 0        
				dbSelectArea("SE2")
				SE2->(DBGoTo(nRecSe2))			
			Endif
		EndIf
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
Set Filter to
RetIndex(cAlias)
If	!Empty(cIndex)
	fErase(cIndex+OrdBagExt())
	cIndex := ""
Endif
dbSetOrder(1)
dbSeek(cFilial,.T.)
Return(nOpca == 1)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa290CAlCn  ³ Autor ³ Cesar C S Prado		 ³ Data ³ 27/04/94  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria o indice temporario para o cancelamento da fatura		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa290CalCn()													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290CalCn(nTitulos,nValor,cAlias,nFaturas,l290CalCn,lHelpCan)

Local lBanco := .F.

lHelpCan := IIF(lHelpCan == NIL, .T.,lHelpCan)
l290CalCn := .F.

If Empty(cFatCan)
	Help(" ",1,"INDVAZIO")
	Return .F.
Endif

dbSelectArea( cAlias )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice condicional												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex := CriaTrab(nil,.f.)
cChave := IndexKey()
IndRegua(cAlias,cIndex,cChave,,FA290FCAN(),OemToAnsi(STR0019))  //"Selecionando Registros..."

nIndex := RetIndex(cAlias)
dbSelectArea(cAlias)
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()
If BOF() .and. EOF()
	If lHelpCan
		Help(" ",1,"INDVAZIO")
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura os indices do SE2 e deleta o arquivo de trabalho				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	Set Filter to
	dbSetOrder(1)
	RetIndex("SE2")
	Set Filter to
	dbGoTop()
	FErase(cIndex+OrdBagExt())
	dbSetOrder(1)
	Return .F.
Endif

dbSelectArea("SE2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso tenha ocorrido a baixa de alguma parcela da fatura, nao sera pos- ³
//³ sivel a operacao de cancelamento.													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValor	:= 0
lCancelar:= .T.
lBanco := .F.
While !Eof()
	If ( !lDuplFat .And. SE2->E2_NUM==cFatCan .And. Day(SE2->E2_BAIXA) > 0 .And.;
		cPrefCan ==  SE2->E2_PREFIXO .and. SE2->E2_FATURA = "NOTFAT" .and. SE2->E2_TIPO == cTipoCan ) .Or.;
		( lDuplFat .And. SE2->E2_NUM == cFatCan .And. Day(SE2->E2_BAIXA) > 0 .And.;                   
		cPrefCan ==  SE2->E2_PREFIXO .and. SE2->E2_FATURA = "NOTFAT" .and. SE2->E2_TIPO == cTipoCan )
		lCancelar:=.F.
	ElseIf ( lDuplFat .And. SE2->E2_NUM == cFatCan .And. Day(SE2->E2_BAIXA) > 0 .And.;                   
		cPrefCan ==  SE2->E2_PREFIXO .and. SE2->E2_FATURA = "NOTFAT" .and. SE2->E2_TIPO == cTipoCan  .And.;
		SE2->E2_FATFOR == cFornCan .And. SE2->E2_FATLOJ == cLojaCan )	
		lCancelar:=.F.
	ElseIf !Empty(SE2->E2_NUMBOR)
		lBanco := .T.
	Else
		If SE2->E2_TIPO $ MV_CPNEG +"/"+ MVABATIM
			nValor -= IIF(E2_SALDO == 0 , E2_VALLIQ, 0)
		Else
			nValor += IIF(E2_SALDO == 0 , E2_VALLIQ, 0)
		Endif
		If !(SE2->E2_TIPO $ MVABATIM)
			nTitulos+= IIF(!Empty(E2_TIPOFAT), 1, 0)
		Endif
	Endif
	dbSkip()
Enddo
If !lCancelar .or. lBanco
	If lHelpCan
		If !lCancelar
			Help(" ",1,"FATPJABX") // Nao aceita se ja houve baixa em fatura
		ElseIf lBanco
			Help(" ",1,"TITBCO",,STR0063,1,0) //"Esta fatura possui parcela transferida para banco. Retorne os titulos para carteira antes de cancelar a fatura"
		Endif
	Endif
	dbSelectArea("SE2")
	#IFDEF TOP
		Set Filter to
	#ELSE
		RetIndex(cAlias)
		fErase(cIndex+OrdBagExt())
		cIndex := ""
	#ENDIF
	dbSetOrder(1)
	Return .F.
Endif
l290CalCn := .T.
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA290FCAN  ³ Autor ³ Cesar C S Prado		 ³ Data ³ 03/05/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Selecao para a criacao do indice condicional 					 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA290FCAN()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devera selecionar todos os registros que atendam a seguinte condicao : 	³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ 1. Mesmo fornecedor e loja																³
//³ 2. Prefixo e Numero do Titulo iguais aos selecionados							³
//³ 3. Ou titulos que tenham originado a fatura selecionada 						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFiltro
cFiltro := 'E2_FILIAL=="'  +cFilial + '".And.'
cFiltro += '!Empty(E2_FATURA).And.'
//Titulo de Fatura
cFiltro += '((E2_NUM=="'   +Pad(cFatCan,Len(E2_NUM)) + '".And.'
cFiltro += 'E2_PREFIXO=="' +cPrefCan+ '".And.'
cFiltro += 'E2_FORNECE=="'	+cFornCan+ '".And.'
cFiltro += 'E2_LOJA=="' 	+cLojaCan+ '".And.'
cFiltro += 'E2_FATURA=="'+Pad("NOTFAT",Len(E2_FATURA))+'".And.'
cFiltro += 'E2_TIPO=="'+cTipoCan+'").oR.'
//Titulo gerador da fatura
cFiltro += '(E2_FATURA=="' +Pad(cFatCan,Len(E2_FATURA)) + '".And.'
cFiltro += 'E2_FATPREF=="' +cPrefCan+ '".And.'
If lDuplFat
	cFiltro += 'E2_FATFOR=="' +cFornCan+ '".And.'
	cFiltro += 'E2_FATLOJ=="' +cLojaCan+ '".And.'
Else
	cFiltro += 'E2_FORNECE=="'	+cFornCan+ '".And.'
	cFiltro += 'E2_LOJA=="' 	+cLojaCan+ '".And.'
EndIf	
cFiltro += 'E2_TIPOFAT=="'+cTipoCan+'" ))'

Return cFiltro


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA290Ok	³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 07/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe mensagem de OK para dados digitados da fatura		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA290OK()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa290Ok()
Local lRet := .T.
lFocus := .F.

If !lFocus .and. Empty(cTipo)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorno .T. para que possa focar o campo do numero da³
	//³ fatura para altera‡Æo e posterior valida‡Æo. A valida³
	//³ ‡Æo neste caso ‚ feita somente no Fornecedor e ao con³
	//³ firmar a opera‡Æo da fatura.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"TIPOFAT")
	oTipo:SetFocus()
	lFocus := .T.
Endif

If !lFocus .and. Empty(cNat)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorno .T. para que possa focar o campo de natureza ³
	//³ para altera‡Æo e posterior valida‡Æo. A validacao    ³
	//³ neste caso ‚ feita somente no Fornecedor e ao con    ³
	//³ firmar a opera‡Æo da fatura.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"A290NAT")
	oNat:SetFocus()
	lFocus := .T.
Endif


If	!lFocus .and. !Fa290Nat()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorno .T. para que possa focar o campo de natureza ³
	//³ para altera‡Æo e posterior valida‡Æo. A validacao    ³
	//³ neste caso ‚ feita somente no Fornecedor e ao con    ³
	//³ firmar a opera‡Æo da fatura.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oNat:SetFocus()
	lFocus := .T.
	lRet := .F.
Endif

If lFA290OK
	lRet := Execblock("FA290OK",.F.,.F.)
Endif
	
Return If( lRet, (MsgYesNo(OemToAnsi(STR0045),OemToAnsi(STR0046))), .F.) //"Confirma Dados?"###"Aten‡„o"


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa290Marca³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 21/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata o valor	para marcar e desmarcar item					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290Marca(ExpN1,ExpD1,ExpD2) 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function fa290Marca(cAlias,cMarca,nLimite,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn,aFatPag)
 
LOCAL nRec
Local cAliasAnt := Alias()
Local lMarkTit  := .t.
Local nPosChave:= 0
Local cChaveLbn
Local nAbatim := 0
Local lUser := FieldPos('E2_USERLGA')>0
Local cUserLga := ""

Default aFatPag   := {}
dbSelectArea(cAlias)
nRec := Recno()
While !Eof()
	cChaveLbn := "FAT" + (cAlias)->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PONTO DE ENTRADA F290TIT                                       ³
	//³ Verifica se titulo pode ser marcado para compor a Fatura,      ³
	//³ caso tenha sido alterada a marca‡Æo do titulo, ExecBlock       ³
	//³ dever  retornar .F., para nÆo haver altera‡Æo dos acumuladores ³
	//³ de valores e numero de titulos.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aFatPag) > 0
		lMarkTit := .T.
	EndIf
	If lF290Tit
		lMarkTit := ExecBlock("F290TIT",.F.,.F.,{.T.})
	Endif
	If LockByName(cChaveLbn,.T.,.F.)
		If lUser
			cUserLga := SE2->E2_USERLGA
		EndIf
		If  SE2->(MsRLock()) .And. RecLock(cAlias) // Se conseguir travar o registro          
			If lMarkTit .And. Len(aFatPag) > 0 
				nPosFat := Ascan(aFatPag[13],{ | e | e[1]+e[2]+e[3]+e[4] == (cAlias)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO) })
				If nPosFat > 0
					aFatPag[13,nPosFat,5] := .T.
				Else
					lMarkTit := .F.
				EndIf
			EndIf
			If lMarkTit
				If	(nValor <= nLimite .Or. Empty(nLimite)) .and. (cAlias)->(MsRLock()) // Se conseguir travar o registro
					(cAlias)->E2_OK := cMarca
					If Ascan(aChaveLbn, cChaveLbn) == 0
						Aadd(aChaveLbn,cChaveLbn)
					Endif
					If E2_TIPO $ MV_CPNEG+"/"+MVABATIM
						nValor	-= E2_SALDO+E2_SDACRES-E2_SDDECRE
						nValCruz -= E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2)
						nQtdTit++
					Else
						nAbatim	:= SumAbatPag(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_MOEDA,"S",,E2_LOJA)
//						nAbatim	:= SumAbatPag( cPrefixo, cNum, cParcela, cFornece, SE2->E2_MOEDA, "S", dBaixa, cLoja )
						nValor   += (E2_SALDO+E2_SDACRES-E2_SDDECRE) //- nAbatim
						nValCruz += E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2) //- nAbatim
						nQtdTit++
					EndIf
				Endif
			Endif

			Else
				UnlockByName(cChaveLbn, .T., .F.)
				nPosChave:= Ascan(aChaveLbn, cChaveLbn)
			If nPosChave >0
				aDel(aChaveLbn,nPosChave)
				aSize(aChaveLbn,Len(aChaveLbn)-1)
			Endif
			EndIf
			If lUser
				SE2->E2_UserLga := cUserLga
			EndIf
		EndIf
	dbSkip()
EndDo
dbGoto(nRec)

dbSelectArea(cAliasAnt)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA290Exibe³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 07/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe Totais de titulos selecionados							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA290Exibe()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290Exibe(cMarca,oValor,oQtdTit,lContrRet,lPccBaixa,lBaseSe2)

Local lMarkTit := .t.
Local nAbatim := 0
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PONTO DE ENTRADA F290TIT                                       ³
//³ Verifica se titulo pode ser marcado para compor a Fatura,      ³
//³ caso tenha sido alterada a marca‡Æo do titulo, ExecBlock       ³
//³ dever  retornar .F., para nÆo haver altera‡Æo dos acumuladores ³
//³ de valores e numero de titulos.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF290TIT
	lMarkTit := ExecBlock("F290TIT",.F.,.F.,{.F.})
Endif
If lMarkTit
	If SE2->E2_OK == cMarca
		If E2_TIPO $ MV_CPNEG
			nValor   -= E2_SALDO+E2_SDACRES-E2_SDDECRE
			nValCruz -= E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2)
			nQtdTit++
		Else   
			nAbatim := SomaAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,"P",E2_MOEDA,,E2_FORNECE)
			nValor   += (E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim
			nValCruz += E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2) - nAbatim
			nQtdTit++
		Endif
	Else
		If E2_TIPO $ MV_CPNEG
			nValor	+= E2_SALDO+E2_SDACRES-E2_SDDECRE
			nValCruz += E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2)
			nQtdTit--
		Else
			nAbatim := SomaAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,"P",E2_MOEDA,,E2_FORNECE)
			nValor   -= (E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim
			nValCruz -= E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2) - nAbatim
			nQtdTit--
		Endif
	Endif
Endif
nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
oValor:Refresh()
oQtdTit:Refresh()
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa290Soma ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o valor da fatura ‚ o mesmo dos tit. marcados  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290Soma() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290Soma()

IF Str(nValorF,16,2) != Str(nValor,16,2) .and. nValorF != 0
	Help(" ",1,"VALFAT")
	Return .F.
Endif
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa290Val	³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pede que se digite o valor correto da fatura 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290Val(ExpO1)														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290Val(oValorFat)

Local oDlg
Local nOpca := 0

DEFINE MSDIALOG oDlg FROM 10, 5 TO 17, 33 TITLE OemToAnsi(STR0049) //"Informe valor correto da Fatura"
@	 .3,1 TO 2.3,11.9 OF oDlg
@	1.0,2 	Say OemToAnsi(STR0050) //"Valor : "
@	1.0,4.5	MSGET nValorF Picture "@E 999,999,999.99"

DEFINE SBUTTON FROM 034,042	TYPE 1 ACTION (nOpca := 1,If(!Empty(nValorF),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
DEFINE SBUTTON FROM 034,069.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg
oValorFat:Refresh()

Return .F.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa290PedCd³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pede que se digite a condicao de pagamento					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa290PedCd(ExpO1) 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290PedCd()

Local oDlg
Local nOpca := 0
Local cCond := Space(3)

DEFINE MSDIALOG oDlg FROM 10, 5 TO 17, 33 TITLE OemToAnsi(STR0051) //"Informe Condi‡„o de Pagamento"
@	1.0,2 	Say OemToAnsi(STR0052) //"Condi‡„o: "
@	1.0,5.5	MSGET cCond F3 "SE4" Picture "!!!"  Valid ExistCpo("SE4",cCond) .and. Fa290Cond(cCond) HASBUTTON
@	0.3,1 TO 2.3,11.9 OF oDlg


DEFINE SBUTTON FROM 034,069.1	TYPE 1 ;
	ACTION (nOpca := 1,If(	!Empty(cCond) .and. ;
	ExistCpo("SE4",cCond) .and. ;
	Fa290Cond(cCond),oDlg:End(),nOpca:=0)) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

Return If(nOpca=0,"   ",cCond)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa290LinOk³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confere se a linha digitada esta OK 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa290LinOk()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FuncTion Fa290LinOk()

Local lRet := .T.
Local nX, lDuplicado := .F.
Local aArea 	:= GetArea()
Local aAreaSe2 := SE2->(GetArea())

// Se a linha nao estiver deletada e o prefixo foi alterado
IF !(aCols[n,8]) .And. aCols[n][1] != cPrefix
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite alterar PREFIXO !                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"IGUALPREF")
	lRet := .F.
Endif
// Se a linha nao estiver deletada e o TIPO foi alterado
IF !(aCols[n,8]) .and. aCols[n][4] != cTipo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite alterar PREFIXO !                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"IGUALTIPO",,STR0058,1,0)  //"Nao e permitida alteracao do tipo do titulo."+CHR(13)+"Deve-se manter o tipo definido no inicio da rotina")
	lRet := .F.
Endif
// Se a linha nao estiver deletada e o NUMERO foi alterado
IF !(aCols[n,8]) .and. aCols[n][2] != cFatura
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite alterar NUMERO !                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"IGUALNUM",,STR0059+CHR(13)+STR0060	,1,0)	 //"Nao e permitida alteracao do numero do titulo."###"Deve-se manter o numero definido no inicio da rotina"
	lRet := .F.
Endif
// Verificar o vencimento da parcela
IF (aCols[n,5]) < dDataBase
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ O vencimento deve ser maior que a database           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"NOVENCREA") 
	lRet := .F.
Endif 
// Pesquisa por titulos ja cadastrados
For nX := 1 To Len(aCols)
	// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
	If !aCols[nX][Len(aCols[nX])] .And. aCols[nX][1]+aCols[nX][2]+aCols[nX][3]+aCols[nX][4] == ;
		aCols[n][1]+aCols[n][2]+aCols[n][3]+aCols[n][4] .And. nX != n
		lDuplicado := .T.
		Exit
	Endif	
Next
// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
If !(aCols[n,8]) .And. lDuplicado
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite duplicar o numero !                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"A290EXIST")
Elseif !(aCols[n,8]) .And. !lDuplicado
	DbSelectArea("SE2")
	DbSetOrder(1)
	If Msseek(xFilial("SE2")+aCols[n][1]+aCols[n][2]+aCols[n][3]+aCols[n][4]+;
				 If(mv_par01 == 1,cForn,cFornP)+If(mv_par01 == 1,cLoja,cLojaP))
		lRet := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao permite duplicar o numero !                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Help(" ",1,"A290EXIST")
	Endif
Endif
// Se passou por todas as validacoes, valida o valor
If lRet .And. !(aCols[n,8]) 
	lRet := NaoVazio(aCols[n][6])
Endif	

SE2->(RestArea(aAreaSe2))
RestArea(aArea)

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa290TudOK³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se aCols esta preenchida corretamente				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa290TudOk(ExpO1) 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290TudOk()

Local nX, nValTot := 0
LOCAL lRet := .T.
Local aArea 	:= GetArea()
Local aAreaSe2 := SE2->(GetArea())

For nx:=1 To Len(aCols)
	If !aCols[nx,8]
		nValTot += aCols[nx][6]
		// Verifica se o titulo esta cadastrado
		DbSelectArea("SE2")
		DbSetOrder(1)
		If Msseek(xFilial("SE2")+aCols[nX][1]+aCols[nX][2]+aCols[nX][3]+aCols[nX][4]+;
					 If(mv_par01 == 1,cForn,cFornP)+If(mv_par01 == 1,cLoja,cLojaP))
			lRet := .F.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao permite duplicar o numero !                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Help(" ",1,"A290EXIST")
			Exit
		Endif
	Endif
Next nx

IF Str(nValor,16,2) != Str(nValTot,16,2)
	Help(" ",1,"VALFAT1",,STR0061 + Transform(nValor,"@E 99,999,999,999.99")+chr(13)+; //"Valor das notas "
								  STR0062 + Transform(nValTot,"@E 99,999,999,999.99"),4,0) //"Valor da fatura  "
	lRet := .F.
End

If lFa290TOk .and. lRet
	If !(Execblock("FA290TOK",.F.,.F.))
		lRet := .F.
	Endif
Endif

oValTot:Refresh()
SE2->(RestArea(aAreaSe2))
RestArea(aArea)

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa290AtuVl³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza valor da fatura na tela 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa290AtuVl()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FuncTion Fa290AtuVl(lVldCampo)
Local nx
DEFAULT lVldCampo := .T.
nValTot := 0
For nx:=1 To Len(aCols)
	If !aCols[nx,8]
		If nx == n .and. lVldCampo // Se estiver somando a posicao que alterei
			nValtot+= &(ReadVar())
		Else
			nValTot += aCols[nx][6]
		Endif
	Endif
Next nx

oValTot:Refresh()
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA290Invert³ Autor ³ Wagner Xavier			 ³ Data ³ 12/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca / Desmarca	todos os titulos									 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa290Inverte(cAlias,cMarca,oValor,oQtdTit,lTodos,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn,cChaveLbn,lAbat,cMarkTit)

Local nReg := (cAlias)->(Recno())
Local lMarkTit := .t.
Local nAbatim := 0
Local cTitAnt	:= ""
Local nOrderSe2 := (cAlias)->(IndexOrd())
Local lUser := FieldPos("E2_USERLGA") > 0
Local cUserLga := ""
DEFAULT lTodos  	:= .T.
DEFAULT lAbat		:= .F.
DEFAULT cMarkTit	:= ""


If !lAbat .And. (cAlias)->E2_TIPO $ MVABATIM+"/"+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
	Msginfo(STR0074)	//"Este é um título de abatimento, não pode ser marcado/desmarcado, posicione sobre o titulo principal para esta operação"
	Return
Endif   

dbSelectArea(cAlias)
If lTodos
	dbSeek(cFilial)
Endif
      
nReg := (cAlias)->(Recno())
nOrderSe2 := (cAlias)->(IndexOrd())

While (!lTodos .Or. !Eof()) .and. cFilial == E2_FILIAL
	If (lTodos .And. (cAlias)->(MsRLock())) .Or. !lTodos
		
		cChaveLbn := "FAT" + SE2->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
		
		If (cAlias)->(MsRLock()) .And. ( (lTodos .And. LockByName(cChaveLbn,.T.,.F.)) .Or. !lTodos)
			IF E2_OK == cMarca
				// Valida se o abatimento ja nao foi desmarcado anteriormente e recalcula a base de saldo
				If lAbat .and. cMarkTit == (cAlias)->E2_OK 
					nValor  += Moeda((E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")
					lMarkTit := .F.
				Elseif lAbat .and. !empty(cMarkTit) .and. cMarkTit <> (cAlias)->E2_OK
					nValor  += Moeda((E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")
					lMarkTit := .F.
				Endif
				If lMarkTit
				nAscan := Ascan(aChaveLbn, cChaveLbn )
				If nAscan > 0
					UnLockByName(aChaveLbn[nAscan],.T.,.F.) // Libera Lock
					aDel(aChaveLbn,nAscan)
					aSize(aChaveLbn,Len(aChaveLbn)-1)
				Endif
				If lUser
					cUserLga := SE2->E2_USERLGA
				EndIf
				RecLock(cAlias)
				(cAlias)->E2_OK	:= "  "
				If lUser
					SE2->E2_USERLGA := cUserLga
				EndIf
				(cAlias)->(MsUnlock())
				If !lAbat
					cMarkTit := (cAlias)->E2_OK
				Endif
				If E2_TIPO $ MV_CPNEG
					nValor += Moeda(E2_SALDO+E2_SDACRES-E2_SDDECRE,nMoeda,"P")
				Else
						If !(E2_TIPO $ MVABATIM)
					nAbatim	:= SumAbatPag(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_MOEDA,"S",,E2_LOJA)
		 					nValor  -= Moeda((E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim,nMoeda,"P")
						Endif
				Endif
				nQtdTit--
				Endif  
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ PONTO DE ENTRADA F290TIT                                       ³
				//³ Verifica se titulo pode ser marcado para compor a Fatura,      ³
				//³ caso tenha sido alterada a marca‡Æo do titulo, ExecBlock       ³
				//³ dever  retornar .F., para nÆo haver altera‡Æo dos acumuladores ³
				//³ de valores e numero de titulos.                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lMarkTit := .T.
				If lF290Tit
					lMarkTit := ExecBlock("F290TIT",.F.,.F.,{.F.})
				Endif
				// Valida se o abatimento ja nao foi desmarcado anteriormente e recalcula a base de saldo
				If lAbat .and. cMarkTit == (cAlias)->E2_OK 
					nValor  -= Moeda((E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")
					lMarkTit := .F.
				Endif
				If lMarkTit
					If Ascan(aChaveLbn, cChaveLbn) == 0
						Aadd(aChaveLbn,cChaveLbn)
					Endif
					If lUser
						cUserLga := SE2->E2_USERLGA
					EndIf	
					RecLock(cAlias)
					(cAlias)->E2_OK := cMarca
					If lUser
						SE2->E2_USERLGA := cUserLga
					EndIf
					If !lAbat
						cMarkTit := (cAlias)->E2_OK
					Endif
					If E2_TIPO $ MV_CPNEG
						nValor -= Moeda(E2_SALDO+E2_SDACRES-E2_SDDECRE,nMoeda,"P")
					Else
						If !(E2_TIPO $ MVABATIM)
						nAbatim	:= SumAbatPag(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_MOEDA,"S",,E2_LOJA)
//						nAbatim := SomaAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,"P",E2_MOEDA,,E2_FORNECE)
						nValor += Moeda((E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim,nMoeda,"P")
						Endif					
					Endif
					nQtdTit++
				Else
					If lUser
						cUserLga := SE2->E2_USERLGA
					EndIf
					(cAlias)->E2_OK	:= "  "
					If lUser
						SE2->E2_USERLGA := cUserLga
					EndIf
					(cAlias)->(MsUnlock())
				Endif
			Endif
		Endif
		If lTodos
			(cAlias)->(dbSkip())
		Else
			cChaveLbn := "FAT" + (cAlias)->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
			nReg := (cAlias)->(Recno())
			Exit
		Endif  
	EndIf
Enddo
If !(cAlias)->E2_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
	cChaveLbn := "FAT" + (cAlias)->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	If !lTodos
		nReg := (cAlias)->(Recno())
	EndIf
	#IFNDEF TOP
		(cAlias)->(DbSetOrder(2))
		If (cAlias)->(dbSeek(xFilial("SE2")+(cAlias)->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)))
			cTitAnt := (cAlias)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)
			While (cAlias)->(!Eof()) .And. cTitAnt == (cAlias)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)
				If !(cAlias)->E2_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
					(cAlias)->(dbSkip())
					Loop
				Endif
				(cAlias)->(DbSetOrder(nOrderSe2))
				// Verifica se o registro nao esta sendo utilizado em outro terminal
				If LockByName(cChaveLbn,.T.,.F.)
				   If Ascan(aChaveLbn, cChaveLbn) == 0
						Aadd(aChaveLbn,cChaveLbn)
					Endif	
				   Fa290Inverte(cAlias,cMarca,oValor,oQtdTit,lTodos,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn,cChaveLbn,.T.,cMarkTit)
				Else
					IW_MsgBox(STR0071,STR0061,"STOP") //"Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura"###"Atenção"
				Endif	
				(cAlias)->(dbSkip())
			EndDo
		Endif	
	#ELSE
	 	(cAlias)->(DbSetOrder(6))	 
		If (cAlias)->(MsSeek(xFilial("SE2")+(cAlias)->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)))
			cTitAnt := (cAlias)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)
			While (cAlias)->(!Eof()) .And. cTitAnt == (cAlias)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)
				If !(cAlias)->E2_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
					(cAlias)->(dbSkip())
					Loop
				Endif
				If (cAlias)->(FieldPos("RECNO")) > 0
					DbSelectArea("SE2")
					MsGoto((cAlias)->RECNO)
					DbSelectArea(cAlias)
				Endif	
				// Verifica se o registro nao esta sendo utilizado em outro terminal
				If LockByName(cChaveLbn,.T.,.F.)
					If Ascan(aChaveLbn, cChaveLbn) == 0
						Aadd(aChaveLbn,cChaveLbn)
					Endif
				   Fa290Inverte(cAlias,cMarca,oValor,oQtdTit,lTodos,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn,cChaveLbn,.T.,cMarkTit)
				Else
					IW_MsgBox(STR0007,STR0061,"STOP") //"Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura"###"Atenção"
				Endif	
				(cAlias)->(DbSkip())
			End	
		Endif	
	#ENDIF
	(cAlias)->(DbSetOrder(nOrderSe2))
	(cAlias)->(dbGoto(nReg))
Endif
(cAlias)->(dbGoto(nReg))
oValor:Refresh()
oQtdTit:Refresh()
oMark:oBrowse:Refresh(.t.)
Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa290ValOK³ Autor ³ Mauricio Pequim Junior³ Data ³ 28/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o valor da fatura ‚ v lido (maior que zero)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290ValOK() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fa290ValOK()

IF nValor <= 0
	Help(" ",1,"VLFATNEG")
	Return .F.
Endif
Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA290Tipo ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 19/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checa o Tipo do titulo informado 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA290Tipo() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA290Tipo(cTipoDoc)
LOCAL lRetorna := .T.
dbSelectArea("SX5")
If !dbSeek(cFilial+"05"+cTipoDoc)
	Help(" ",1,"E2_TIPO")
	lRetorna := .F.
Elseif !NewTipCart(cTipoDoc,"2")
	Help(" ",1,"TIPOCART")
	lRetorna := .F.
Else
	If cTipoDoc $ MVRECANT+"/"+MV_CRNEG
		Help(" ",1,"E2_TIPO")
		lRetorna := .F.
	ElseIf cTipoDoc $ MVPAGANT+"/"+MVTAXA+"/"+MV_CPNEG+"/"+MVABATIM
		Help(" ",1,"TIPOFAT")
		lRetorna := .F.
	Endif
Endif
Return lRetorna

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ fa290nat ³ Autor ³ Paulo Boschetti		  ³ Data ³ 27/07/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica validade da natureza.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa290nat()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FIN290																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA290NAT()
Local cAlias		:= Alias()
Local lRet			:= .T.
Local lValidBloq	:= SED->(FieldPos("ED_MSBLQL")) > 0

dbSelectArea("SED")
If !(dbSeek(xFilial("SED")+cNat))
	Help(" ",1,"A290NAT")
	lRet:=.F.
Endif                  

If lRet .and. !FinVldNat( .F., cNat, 2 ) 
	 lRet	:= .F.
EndIf

If lRet .And. lValidBloq
	If SED->ED_MSBLQL == "1"
		Help(" ",1,"EDBLOCKED",,STR0072,1,0)	//"Natureza bloqueada para novas movimentações"
		lRet := .F.
	Endif
EndIf

If lRet .And. lFIN290NAT
	lRet := ExecBlock("FIN290NAT")
Endif

dbSelectArea(cAlias)
Return lRet
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Fa290bAval ³ Autor ³ Mauricio Pequim Jr.  ³ Data ³ 02/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Bloco de marcacoo       			          						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa090bAval()		  													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA090																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa290bAval(cAlias,cMarca,oValor,oQtda,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn)
 
Local lRet 		:= .T.
Local cChaveLbn 

// Verifica se o registro nao esta sendo utilizado em outro terminal
cChaveLbn := "FAT" + (cAlias)->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PONTO DE ENTRADA F290VAL                                       ³
//  Retorna Array contendo os Titulos Marcados.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF290Val
	 ExecBlock("F290VAL",.F.,.F.,{aChaveLbn})
Endif

// Verifica se o registro nao esta sendo utilizado em outro terminal
//-- Parametros da Funcao LockByName() :
//   1o - Nome da Trava
//   2o - usa informacoes da Empresa na chave
//   3o - usa informacoes da Filial na chave 
If (cAlias)->(MsRLock())
	Fa290Inverte(cAlias,cMarca,oValor,oQtda,.F.,oMark,lContrRet,lPccBaixa,lBaseSe2,aChaveLbn,cChaveLbn) // Marca o registro e trava
	lRet := .T.
Else
	IW_MsgBox(STR0068,STR0067,"STOP") //"Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura"###"Atenção"
	lRet := .F.
Endif	
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³AjustaSx1  ³ Autor ³ Cristiano Denardi    ³ Data ³ 15/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta SX1            			          				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1()

Local aArea 	:= GetArea()

PutSx1( "AFI290", "05","Marcar Títulos Aut.?","+Traer marcado aut ?","Display Automatic Marks ?","mv_ch5","N",1,0,1,"C","","","","",;
	"mv_par05","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",,,,".FIN58011.")



RestArea(aArea)
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa290Pesq ³ Autor ³ Paulo Augusto         ³ Data ³07.03.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ tela de pesquisa - WINDOWS 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fa290Pesq(oMark, cAlias)
Local cAliasAnt := Alias()
Local nRecno
Local nOrdInd := IndexOrd()		
		
dbSelectArea(cAlias)
nRecno := Recno()
AxPesqui()

// Se o que foi digitado para pesquisa nao estiver dentro do filtro
// Continua no mesmo registro que estava antes de selecionar CTRL-P
If !&(Fa290ChecF())
	dbGoto(nRecNo)
Endif

DbSelectArea(cAliasAnt)
dbSetOrder(nOrdInd)
oMark:oBrowse:Refresh(.T.)
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³23/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina := { { OemToAnsi(STR0001),"AxPesqui"  , 0 , 1,,.F. },; //"Pesquisar"
	{ OemToAnsi(STR0002),"FA050Visua"  , 0 , 2 },; //"Visualizar"
	{ OemToAnsi(STR0003),"FA290Aut"    , 0 , 3 },; //"Selecionar"
	{ OemToAnsi(STR0004),"FA290Can"    , 0 , 6 },; //"Cancelar"
	{ OemToAnsi(STR0071),"FA040Legenda", 0 , 7,,.F.}}// "Legenda"	
Return(aRotina)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FIN290T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 26.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIN290                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FIN290T(aParam)
	cRotinaExec := "FIN290"
	ReCreateBrow("SE2",FinWindow)      		
	FIN290(aParam[1])
	ReCreateBrow("SE2",FinWindow) 
	dbSelectArea("SE2")
	
	INCLUI := .F.
	ALTERA := .F.	
Return .T.	

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³F290SelPR  ³ Autor ³ Marcelo Celi Marques ³ Data ³ 13.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Markbrowse da Faturas a Receber					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto onde se encaixara a MarkBrowse				  ³±±
±±³			 ³ ExpC1 = Tratamento aplicado a outras moedas (<>1)			  ³±±
±±³			 ³ ExpN1 = Valor dos titulos selecionados							  ³±±
±±³			 ³ ExpN2 = Quantidade de titulos selecionados					  ³±±
±±³			 ³ ExpC2 = Marca (GetMark())				 							  ³±±
±±³			 ³ ExpO2 = Objeto Valor dos titulos selecionados p/ refresh	  ³±±
±±³			 ³ ExpO3 = Objeto Quantidade de titulos selecionados p/refresh³±±
±±³			 ³ ExpN3 = Moeda da Substituicao             					  ³±±
±±³			 ³ ExpO4 = Objeto Painel superior a ser desabilitado			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIN290                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F290SelFat(oDlg,nOpca,cCond,nValor,nValTot,aVenc,cPrefix,cFatura,cTipo,dDatCont,oPanel,oPanel2)
	Local lPanelFin := If (lPanelFun,IsPanelFin(),.F.)   
	Local no        := 0
	Local oFnt 
	Local oFnt2   
	DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD 
	DEFINE FONT oFnt2 NAME "Arial" SIZE 10,14 BOLD
	
	//oPanel2:Disable()
	aCols 	:= If(Type("aCols")=="A",{},aCols)
	aHeader := If(Type("aHeader")=="A",{},aHeader)

	cCondicao := If(nOpca=0,"   ",cCond)
	aVenc := Condicao(nValor,cCondicao,0)												 													 	
	nDup	:= Len(aVenc)
	
	aCols := GravaDup(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,cTipo,"FINA280")
					
	If !Empty(aCols)
		aVlCruz := {}
		aVlCruz := F280VlCruz(nDup,nValCruz)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra tela com os diversos titulos						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For no:=1 To Len(aCols)
			nValTot += aCols[no][6]
		Next
		     
		IF Str(nValor,16,2) != Str(nValTot,16,2)
			nValTot := nValor
		EndIf    
		
		nOpca := 0		
		@ 015,135	SAY STR0029 OF oPanel2 SIZE 80,14 Pixel//"Data Contabiliza‡„o : "
		@ 015,190	Say dDatCont OF oPanel2 SIZE 80,14  Pixel //FONT oDlg2:oFont
		@ 015,248	Say STR0030 OF oPanel2 SIZE 80,14 Pixel //"Condi‡„o de Pagamento : "
		@ 015,315	Say cCondicao OF oPanel2 SIZE 80,14  Pixel
		@ 015,375	Say STR0031 OF oPanel2 Pixel SIZE 80,14 //"Valor Total:"
				
		@ 025,248	Say SE4->E4_DESCRI OF oPanel2 Pixel FONT oFnt2 COLOR CLR_HBLUE		
		@ 015,400 Say oValTot VAR nValTot Picture "@E 9,999,999,999.99" OF oPanel2 PIXEL FONT oFnt COLOR CLR_HBLUE //FONT oDlg2:oFont	
		
		oGet := MSGetDados():New(34,5,128,315,3,"Fa290LinOk","Fa290TudOk","",.T.,,,,,,"",,"Fa290AtuVl(.F.)")				
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT			
   Endif  

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FA290MotBXºAutor  ³Marcelo Celi Marquesº Data ³  23/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao criar automaticamente o motivo de baixa FAT na      º±±
±±º          ³ tabela Mot baixas                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIN290                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                    
Static Function Fa290MotBx(cMot,cNomMot, cConfMot)
	Local aMotbx := ReadMotBx()
	Local nHdlMot, I, cFile := "SIGAADV.MOT"
	
	If lFILEMOT
		cFile := ExecBlock("FILEMOT",.F.,.F.,{cFile})
	Endif
	
	If Ascan(aMotbx, {|x| Substr(x,1,3) == Upper(cMot)}) < 1
		nHdlMot := FOPEN(cFile,FO_READWRITE)
		If nHdlMot <0
			HELP(" ",1,"SIGAADV.MOT")
			Final("SIGAADV.MOT")
		Endif
		
		nTamArq:=FSEEK(nHdlMot,0,2)	// VerIfica tamanho do arquivo
		FSEEK(nHdlMot,0,0)			// Volta para inicio do arquivo

		For I:= 0 to  nTamArq step 19 // Processo para ir para o final do arquivo	
			xBuffer:=Space(19)
			FREAD(nHdlMot,@xBuffer,19)
	    Next		
		
		fWrite(nHdlMot,cMot+cNomMot+cConfMot+chr(13)+chr(10))	
		fClose(nHdlMot)		
	EndIf	
Return