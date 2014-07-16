#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR	16
#DEFINE TAM_CONTA  17

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCON018  ºAutor  ³Felipe Ciconini     º Data ³  04/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ HISTORICO DE COMPRAS                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Nhcon018(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
					cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
					lClVl, cClvlIni, cClvlFim,lSaltLin,cMoedaDesc )

Local oReport          

Local aArea := GetArea()
Local aCtbMoeda		:= {}

Local cArqTmp		:= ""

Local lOk := .T.
Local lExterno		:= cContaIni <> Nil

DEFAULT lCusto		:= .F.
DEFAULT lItem		:= .F.
DEFAULT lCLVL		:= .F.
DEFAULT lSaltLin	:= .T.

DEFAULT cMoedaDesc  := cMoeda // RFC - 18/01/07 | BOPS 103653

PRIVATE cTipoAnt	:= ""
PRIVATE cPerg	 	:= "CTR400"
PRIVATE nomeProg  	:= "NHCON018"  
PRIVATE nSldATransp	:= 0 // Esta variavel eh utilizada para calcular o valor de transporte
PRIVATE nSldDTransp	:= 0

If FindFunction("TRepInUse") .And. TRepInUse()
		
	If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
		lOk := .F.
	EndIf
		
	If lOk
        // ajusta o sx1
		// AjusteSX1()

		Pergunte("CTR400", .F.)

		// AjCTR400MV9() //// AJUSTA O SX1 (PERGUNTA 09) PARA IMPRIMIR S/ MOVIMENTO COM SALDO ANTERIOR.
	EndIf
	
	If !lExterno .And. lOk
		If ! Pergunte("CTR400", .T.)
			lOk := .F.
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
	//³ Gerencial -> montagem especifica para impressao)			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ct040Valid(mv_par07) // Set Of Books
		lOk := .F.
	EndIf 

	If lOk
		aCtbMoeda  	:= CtbMoeda(mv_par05) // Moeda?
	    If Empty(aCtbMoeda[1])
			Help(" ",1,"NOMOEDA")
		    lOk := .F.
		Endif
	Endif 

	If lOk
		//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC400
		If !lExterno
			lCusto	:= Iif(mv_par12 == 1,.T.,.F.)
			lItem	:= Iif(mv_par15 == 1,.T.,.F.)
			lCLVL	:= Iif(mv_par18 == 1,.T.,.F.)
		Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
			mv_par01 := cContaIni
			mv_par02 := cContaFim
			mv_par03 := dDataIni
			mv_par04 := dDataFim
			mv_par05 := cMoeda
			mv_par06 := cSaldos
			mv_par07 := cBook
			mv_par12 := If(lCusto =.T.,1,2)
			mv_par13 := cCustoIni
			mv_par14 := cCustoFim
			mv_par15 := If(lItem =.T.,1,2)
			mv_par16 := cItemIni
			mv_par17 := cItemFim
			mv_par18 := If(lClVl =.T.,1,2)
			mv_par19 := cClVlIni
			mv_par20 := cClVlFim
			mv_par31 := If(lSaltLin==.T.,1,2)
			mv_par34 := cMoedaDesc
		Endif
	
		oReport := ReportDef(aCtbMoeda,lCusto,lItem,lCLVL,@cArqTmp)
		oReport:PrintDialog()
             
		If Select("cArqTmp") > 0
			dbSelectArea("cArqTmp")
			Set Filter To
			dbCloseArea()
			If Select("cArqTmp") == 0
				FErase(cArqTmp+GetDBExtension())
				FErase(cArqTmp+OrdBagExt())
			EndIf
		EndIf	
	
	EndIf
Else
	CTBR400R3( 	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
				cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
				lClVl, cClvlIni, cClvlFim,lSaltLin,cMoedaDesc ) // Executa versão anterior do fonte
Endif

RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Cicero J. Silva    º Data ³  01/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda  - Matriz ref. a moeda                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef(aCtbMoeda,lCusto,lItem,lCLVL,cArqTmp)

Local oReport
Local oSection1
Local oSection2 
Local oSection3 

Local cDesc1		:= "Este programa ira imprimir o Razao Contabil,"
Local cDesc2		:= "de acordo com os parametros solicitados pelo"
Local cDesc3		:= "usuario."
Local titulo		:= "Emissao do Razao Contabil"
Local cNormal		:= ""

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO")
Local nTamConta	:= Len(CriaVar("CT1_CONTA"))
Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamCLVL	:= Len(CriaVar("CTH_CLVL"))

Local lAnalitico	:= Iif(mv_par08==1,.T.,.F.)// Analitico ou Resumido dia (resumo)
Local lSalLin		:= IIf(mv_par31==1,.T.,.F.)//"Salta linha entre contas?"
Local lPrintZero	:= IIf(mv_par30==1,.T.,.F.)// Imprime valor 0.00    ?
Local lSalto		:= Iif(mv_par21==1,.T.,.F.)// Salto de pagina                       ³

Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")

Local nDigitAte		:= 0
Local aSetOfBook := CTBSetOf(mv_par07)// Set Of Books	
Local cPicture 		:= aSetOfBook[4]
Local cDescMoeda 	:= aCtbMoeda[2]
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par05)// Moeda

If mv_par11 == 3 						//// SE O PARAMETRO DO CODIGO ESTIVER PARA IMPRESSAO
	nTamConta := Len(CT1->CT1_CODIMP)	//// USA O TAMANHO DO CAMPO CODIGO DE IMPRESSAO
Endif

If lAnalitico .And. (lCusto .Or. lItem .Or. lCLVL)
	nTamConta := 30						// Tamanho disponivel no relatorio para imprimir
EndIf		

oReport := TReport():New(nomeProg,titulo,cPerg, {|oReport| ;
			ReportPrint(oReport,aCtbMoeda,aSetOfBook,cPicture,cDescMoeda,nDecimais,nTamConta,lAnalitico,lCusto,lItem,lCLVL,cArqTmp)},cDesc1+cDesc2+cDesc3)
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)

If lAnalitico
	oReport:SetLandScape(.T.)
Else
	oReport:SetPortrait(.T.)
EndIf
	
// oSection1
oSection1 := TRSection():New(oReport,"Conta",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Conta"

If lSalto
	oSection1:SetPageBreak(.T.)
EndIf

TRCell():New(oSection1,"CONTA"	,"cArqTmp","CONTA",/*Picture*/,aTamConta[1],/*lPixel*/,/*{|| }*/)	//"CONTA"
TRCell():New(oSection1,"DESCCC"	,"cArqTmp","DESCRICAO",/*Picture*/,nTamConta,/*lPixel*/,/*{|| }*/)		//"DESCRICAO"

oSection1:OnPrintLine( {|| IIf(lSalLin,oReport:SkipLine(),NIL) } )

// oSection2
oSection2 := TRSection():New(oReport,"Custo",{"cArqTmp","CT2"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Custo"
oSection2:SetTotalInLine(.F.)
oSection2:SetHeaderPage(.T.)

TRCell():New(oSection2,"DATAL"		,"cArqTmp","DATA",/*Picture*/,10,/*lPixel*/,/*{|| }*/)	// "DATA"
TRCell():New(oSection2,"DOCUMENTO"	,""       ,"LOTE/SUB/DOC/LINHA",/*Picture*/,18,/*lPixel*/,{|| cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA })// "LOTE/SUB/DOC/LINHA"
TRCell():New(oSection2,"HISTORICO"	,"cArqTmp","HISTORICO",/*Picture*/,nTamHist	,/*lPixel*/,{|| Subs(cArqTmp->HISTORICO,1,30) })// "HISTORICO"	
TRCell():New(oSection2,"XPARTIDA"	,"cArqTmp","XPARTIDA",/*Picture*/,aTamConta[1]	,/*lPixel*/,/*{|| }*/)// "XPARTIDA"
TRCell():New(oSection2,"CCUSTO"		,"cArqTmp",Upper(cSayCusto),/*Picture*/,aTamCusto[1],/*lPixel*/,/*{|| }*/)// Centro de Custo
TRCell():New(oSection2,"ITEM"		,"cArqTmp",Upper(cSayItem) ,/*Picture*/,nTamItem,/*lPixel*/,/*{|| }*/)// Item Contabil
TRCell():New(oSection2,"CLVL"		,"cArqTmp",Upper(cSayClVl) ,/*Picture*/,nTamCLVL,/*lPixel*/,/*{|| }*/)// Classe de Valor
TRCell():New(oSection2,"LANCDEB"	,"cArqTmp","DEBITO",/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCDEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },"RIGHT",,"RIGHT")// "DEBITO"
TRCell():New(oSection2,"LANCCRD"	,"cArqTmp","CREDITO",/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCCRD,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },"RIGHT",,"RIGHT")// "CREDITO"
TRCell():New(oSection2,"TPSLDATU"	,"cArqTmp","SALDO ATUAL",/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| }*/,"RIGHT",,"RIGHT")// "SALDO ATUAL"

If cPaisLoc = "CHI"
	TRCell():New(oSection2,"SEGOFI"	,"cArqTmp","SEGOFI",/*Picture*/,TamSx3("CT2_SEGOFI")[1],/*lPixel*/,/*{|| }*/) //"SEGOFI"
EndIf

If lAnalitico 
	If !lCusto
		oSection2:Cell("CCUSTO"):Hide()
		oSection2:Cell("CCUSTO"):HideHeader() 
	EndIf
	If !lItem
		oSection2:Cell("ITEM"):Hide()
		oSection2:Cell("ITEM"	):HideHeader() 
	EndIf
	If !lCLVL
		oSection2:Cell("CLVL"):Hide()
		oSection2:Cell("CLVL"	):HideHeader() 
	EndIf
Else // Resumido
	oSection2:Cell("CCUSTO"):Hide()
	oSection2:Cell("CCUSTO"):HideHeader() 
	oSection2:Cell("ITEM"):Hide()
	oSection2:Cell("ITEM"):HideHeader() 
	oSection2:Cell("CLVL"):Hide()
	oSection2:Cell("CLVL"):HideHeader() 

	oSection2:Cell("HISTORICO"):Disable()
	oSection2:Cell("DOCUMENTO"):Hide()
	oSection2:Cell("DOCUMENTO"):HideHeader() 
	oSection2:Cell("XPARTIDA"):Hide()
	oSection2:Cell("XPARTIDA"):HideHeader() 
EndIf

// oSection3 - Totais das sessoes	
oSection3 := TRSection():New( oReport,"Totais",,, .F., .F. )	//"Totais"
TRCell():New(oSection3,"TOT"			,"","DESCRICAO",/*Picture*/,17+IIF(lAnalitico,nTamHist,0)+aTamConta[1]+aTamCusto[1]+nTamItem+nTamCLVL,/*lPixel*/,/*{|| code-block de impressao }*/)	//"DESCRICAO"
TRCell():New(oSection3,"TOT_ANT"		,"","SALDO ANTERIOR:",/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/)	// "SALDO ANTERIOR:"
TRCell():New(oSection3,"TOT_DEBITO"		,"","DEBITO",/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// "DEBITO"
TRCell():New(oSection3,"TOT_CREDITO"	,"","CREDITO",/*Picture*/,TAM_VALOR,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// "CREDITO"
TRCell():New(oSection3,"TOT_ATU"		,"","SALDO ATUAL",/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")	// "SALDO ATUAL"

oSection3:Cell("TOT_ANT"):HideHeader()
oSection3:Cell("TOT_DEBITO"):HideHeader()
oSection3:Cell("TOT_CREDITO"):HideHeader()
oSection3:Cell("TOT_ATU"):HideHeader()

// oSection4 - Complemento
oSection4 := TRSection():New( oReport,"Complemento",,, .F., .F. )	//"Complemento"
TRCell():New(oSection4,"COMP","","COMPLEMENTO",/*Picture*/,17+IIF(lAnalitico,nTamHist,0)+aTamConta[1]+aTamCusto[1]+nTamItem+nTamCLVL,/*lPixel*/,/*{|| code-block de impressao }*/)	//"COMPLEMENTO"

oSection4:Cell("COMP"):HideHeader()

oReport:ParamReadOnly() 

TRPosition():New( oSection2, "CT2", 1,;
	{|| xFilial("CT2")+cArqTmp->(DtoS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+mv_par06+EMPORI+FILORI+mv_par05) } )

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintº Autor ³ Cicero J. Silva    º Data ³  14/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportPrint(oReport,aCtbMoeda,aSetOfBook,cPicture,cDescMoeda,nDecimais,nTamConta,lAnalitico,lCusto,lItem,lCLVL,cArqTmp)

Local oSection1 	:= oReport:Section(1)
Local oSection2		:= oReport:Section(2)
Local oSection3		:= oReport:Section(3)

Local cFiltro	:= oSection2:GetAdvplExp()

Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")

Local aSaldo		:= {}
Local aSaldoAnt		:= {}

Local cContaIni		:= mv_par01 // da conta
Local cContaFIm		:= mv_par02 // ate a conta 
Local cMoeda		:= mv_par05 // Moeda
Local cSaldo		:= mv_par06 // Saldos
Local cCustoIni		:= mv_par13 // Do Centro de Custo
Local cCustoFim		:= mv_par14 // At‚ o Centro de Custo
Local cItemIni		:= mv_par16 // Do Item 
Local cItemFim		:= mv_par17 // Ate Item 
Local cCLVLIni		:= mv_par19 // Imprime Classe de Valor?
Local cCLVLFim		:= mv_par20 // Ate a Classe de Valor
Local cContaAnt		:= ""
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResCLVL		:= ""
Local cDescSint		:= ""
Local cContaSint	:= ""
Local cNormal 		:= ""

Local xConta		:= ""

Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cMascara1		:= ""
Local cMascara2		:= ""
Local cMascara3		:= ""
Local cMascara4		:= ""

Local dDataAnt		:= CTOD("  /  /  ")
Local dDataIni		:= mv_par03 // da data
Local dDataFim		:= mv_par04 // Ate a data

Local nPagIni		:= mv_par22 // Pagina Inicial 
Local nReinicia 	:= mv_par24 // Numero da Pag p/ Reiniciar 
Local nPagFim		:= mv_par23 // Pagina Final 
Local nMaxLin   	:= mv_par32 // Num.linhas p/ o Razao?

Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local nCont			:= 0

Local lNoMov		:= Iif(mv_par09==1,.T.,.F.) // Imprime conta sem movimento?
Local lSldAnt		:= Iif(mv_par09==3,.T.,.F.) // Imprime conta sem movimento?
Local lJunta		:= Iif(mv_par10==1,.T.,.F.) // Junta Contas com mesmo C.Custo?
Local lPrintZero	:= Iif(mv_par30==1,.T.,.F.) // Imprime valor 0.00    ?
Local lImpLivro		:= .t.
Local lImpTermos	:= .f.
Local lEmissUnica	:= If(GetNewPar("MV_CTBQBPG","M") == "M",.T.,.F.)			/// U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lSldAntCta	:= Iif(mv_par33 == 1, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntCC		:= Iif(mv_par33 == 2, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntIt  	:= Iif(mv_par33 == 3, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntCv  	:= Iif(mv_par33 == 4, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr

Local cMoedaDesc	:= iif( Empty( mv_par34 ) , cMoeda , mv_par34 ) // RFC - 18/01/07 | BOPS 103653

// Mascara da Conta
cMascara1 := IIf (Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSepara1) )

If lCusto .Or. lItem .Or. lCLVL
	// Mascara do Centro de Custo
	cMascara2 := IIf ( Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSepara2) )
	// Mascara do Item Contabil
	dbSelectArea("CTD")
	cMascara3 := IIf ( Empty(aSetOfBook[7]),ALLTRIM(STR(Len(CTD->CTD_ITEM))) , RetMasCtb(aSetOfBook[7],@cSepara3) )
	// Mascara da Classe de Valor
	dbSelectArea("CTH")
	cMascara4 := IIf ( Empty(aSetOfBook[8]) , ALLTRIM(STR(Len(CTH->CTH_CLVL))) , RetMasCtb(aSetOfBook[8],@cSepara4) )
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par29==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par29==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par29==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")== "U"
	IF lAnalitico
		Titulo	:=	"RAZAO ANALITICO EM "
	Else
		Titulo	:=	"RAZAO SINTETICO EM "
	EndIf
	Titulo += 	cDescMoeda + " DE " + DTOC(dDataIni) +;	// "DE"
				" ATE " + DTOC(dDataFim) + CtbTitSaldo(mv_par06)	// "ATE"
Else
	Titulo := NewHead
EndIf

oReport:SetTitle(Titulo)
oReport:SetPageNumber(mv_par22) //mv_par22	-	Pagina Inicial
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,oReport:Title(),,,,,oReport) } )

If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(	oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
							cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
							aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,cFiltro,lSldAnt)},;
				"Criando Arquivo Tempor rio...",;		// "Criando Arquivo Tempor rio..."
				"Emissao do Razao")						// "Emissao do Razao"

	dbSelectArea("cArqTmp")
	dbGoTop()

	oReport:SetMeter( RecCount() )
	oReport:NoUserFilter()
Endif

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If lImpLivro
	If cArqTmp->(EoF())              
		// Atencao ### "Nao existem dados para os parâmetros especificados."
		Aviso("Atencao ###","Nao existem dados para os parâmetros especificados.",{"Ok"})
		oReport:CancelPrint()
		Return
	Else
		While lImpLivro .And. cArqTmp->(!Eof()) .And. !oReport:Cancel()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA 1a SECAO             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    If oReport:Cancel()
		    	Exit
		    EndIf        
		   
			If lSldAntCC
				aSaldo    := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
				aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
			ElseIf lSldAntIt
				aSaldo    := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
				aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
			ElseIf lSldAntCv
				aSaldo    := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
				aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
			Else 
				aSaldo 		:= SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
				aSaldoAnt	:= SaldoCT7(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR400")
			EndIf

			If f180Fil(lNoMov,aSaldo,dDataIni,dDataFim)
				dbSkip()
				Loop
			EndIf

			nSaldoAtu:= 0
			nTotDeb	:= 0
			nTotCrd	:= 0                              

			// Conta Sintetica	
			cContaSint := Ctr400Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes,cMoedaDesc)
			cNormal := CT1->CT1_NORMAL
			
			If mv_par11 == 3
				oSection1:Cell("CONTA" ):SetBlock( { || EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
				oSection1:Cell("DESCCC"):SetBlock( { || " - " + cDescSint } )
			Else
				oSection1:Cell("CONTA" ):SetBlock( { || EntidadeCTB(cContaSint,0,0,Len(cContaSint),.F.,cMascara1,cSepara1,,,,,.F.) } )
				oSection1:Cell("DESCCC"):SetBlock( { || " - " + cDescSint } )
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA IMPRESSAO DA 1A SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	 	oSection1:Init()       
	     	oSection1:PrintLine()
		    oSection1:Finish()        

			xConta := "CONTA - "	

			If mv_par11 == 1							// Imprime Cod Normal
				xConta += EntidadeCTB(cArqTmp->CONTA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
			Else
				dbSelectArea("CT1")
				dbSetOrder(1)
				MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)
				If mv_par11 == 3						// Imprime Codigo de Impressao
					xConta += EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
				Else										// Caso contrário usa codigo reduzido
					xConta += EntidadeCTB(CT1->CT1_RES,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
				EndIf
			
				cDescConta := &("CT1->CT1_DESC" + cMoedaDesc )
			Endif
			If !lAnalitico 
				xConta +=  " - " + Left(cDescConta,30)	
			Else
				xConta +=  " - " + Left(cDescConta,38)
			Endif
			
			// A TRANSPORTAR :  	
			oReport:SetPageFooter( 5 , {|| IIF(oSection2:Printing() .Or. oSection3:Printing() ,oReport:PrintText("A TRANSPORTAR : " + ValorCTB(nSldATransp,,,TAM_VALOR,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) ),nil) } )

			//"DE TRANSPORTE : "
			oReport:OnPageBreak( {|| IIF(oSection2:Printing() .Or. oSection3:Printing() , (oReport:PrintText(xConta + "DE TRANSPORTE : " + ValorCTB(nSldDTransp,,,TAM_VALOR,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.),oReport:Row(),10),oReport:Skipline()),nil) } )

			 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Impressao do Saldo Anterior do Centro de Custo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oReport:PrintText(xConta + "SALDO ANTERIOR: " + ValorCTB(aSaldoAnt[6],,,TAM_VALOR,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) )//"SALDO ANTERIOR: "
		
			nSaldoAtu := aSaldoAnt[6]                                           
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FIM DA 1a SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA 2a SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("cArqTmp")
			cContaAnt:= cArqTmp->CONTA
			dDataAnt	:= CTOD("  /  /  ")

   			oSection3:Init() // oSection3 - Totalizadora
			oSection2:Init()                            
			
			Do While cArqTmp->(!Eof() .And. CONTA == cContaAnt ) .And. !oReport:Cancel()

			    If oReport:Cancel()
			    	Exit
			    EndIf        

				If dDataAnt <> cArqTmp->DATAL 
					If (cArqTmp->LANCDEB <> 0 .Or. cArqTmp->LANCCRD <> 0)
						oSection2:Cell("DATAL"):SetBlock( { || dDataAnt } )
					Endif	
					dDataAnt := cArqTmp->DATAL    
				EndIf	
   					
   					If lAnalitico //Se for relatorio analitico
   						
   						nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
					nTotDeb		+= cArqTmp->LANCDEB
					nTotCrd		+= cArqTmp->LANCCRD
					nTotGerDeb	+= cArqTmp->LANCDEB
					nTotGerCrd	+= cArqTmp->LANCCRD			
					
					dbSelectArea("cArqTmp")
					If cPaisLoc == "CHI"
						oSection2:Cell("DOCUMENTO"):SetBlock( { || cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA+" "+cArqTmp->SEGOFI } )
						oSection2:Cell("HISTORICO"):SetBlock( { || Subs(cArqTmp->HISTORICO,1,30) } )
					EndIf									   
		
					If mv_par11 == 1 // Impr Cod (Normal/Reduzida/Cod.Impress)
						oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(cArqTmp->XPARTIDA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
					ElseIf mv_par11 == 3
						oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
					Else
						oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(CT1->CT1_RES,0,0,TAM_CONTA,.F.,cMascara1,cSepara1,,,,,.F.) } )
					Endif
					
					If lCusto
						If mv_par25 == 1 //Imprime Cod. Centro de Custo Normal 
							oSection2:Cell("CCUSTO"):SetBlock( { || EntidadeCTB(cArqTmp->CCUSTO,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
						Else 
							dbSelectArea("CTT")
							dbSetOrder(1)
							dbSeek(xFilial("CTT")+cArqTmp->CCUSTO)				
							cResCC := CTT->CTT_RES
							oSection2:Cell("CCUSTO"):SetBlock( { || EntidadeCTB(cResCC,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
							dbSelectArea("cArqTmp")
						Endif                                                       
					Endif
					If lItem 						//Se imprime item 
						If mv_par26 == 1 //Imprime Codigo Normal Item Contabl
							oSection2:Cell("ITEM"):SetBlock( { || EntidadeCTB(cArqTmp->ITEM,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
						Else
							dbSelectArea("CTD")
							dbSetOrder(1)
							dbSeek(xFilial("CTD")+cArqTmp->ITEM)				
							cResItem := CTD->CTD_RES
							oSection2:Cell("ITEM"):SetBlock( { || EntidadeCTB(cResItem,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
							dbSelectArea("cArqTmp")					
						Endif
					Endif
					If lCLVL //Se imprime classe de valor
						If mv_par27 == 1 //Imprime Cod. Normal Classe de Valor
							oSection2:Cell("CLVL"):SetBlock( { || EntidadeCTB(cArqTmp->CLVL,0,0,TAM_CONTA,.F.,cMascara4,cSepara4,,,,,.F.) } )
						Else
							dbSelectArea("CTH")
							dbSetOrder(1)
							dbSeek(xFilial("CTH")+cArqTmp->CLVL)				
							cResClVl := CTH->CTH_RES						
							oSection2:Cell("CLVL"):SetBlock( { || EntidadeCTB(cResClVl,0,0,TAM_CONTA,.F.,cMascara4,cSepara4,,,,,.F.) } )
							dbSelectArea("cArqTmp")					
						Endif			
					Endif

					oSection2:Cell("TPSLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )

					nSldATransp := nSaldoAtu // Valor a Transportar - 1

			     	oSection2:PrintLine()
				    oReport:IncMeter()

					nSldDTransp := nSaldoAtu // Valor de Transporte - 2

					// Procura complemento de historico e imprime
					ImpCompl(oReport)
					@Prow()+1,001 psay "teste"
			        ImpPed()
			        
					dbSkip()
			
				Else // !lAnalitico	 -- Se for resumido.                               			
					
					dbSelectArea("cArqTmp")
					
					While dDataAnt == cArqTmp->DATAL .And. cContaAnt == cArqTmp->CONTA
						nVlrDeb	+= cArqTmp->LANCDEB		                                         
						nVlrCrd	+= cArqTmp->LANCCRD		                                         
						nTotGerDeb	+= cArqTmp->LANCDEB
						nTotGerCrd	+= cArqTmp->LANCCRD			
						dbSkip()
					EndDo
					
					nSaldoAtu	:= nSaldoAtu - nVlrDeb + nVlrCrd
					oSection2:Cell("LANCDEB"):SetBlock( { || ValorCTB(nVlrDeb,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) })// Debito
					oSection2:Cell("LANCCRD"):SetBlock( { || ValorCTB(nVlrCrd,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) })// Credito
					oSection2:Cell("TPSLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) })// Sinal do Saldo Atual => Consulta Razao			

					//Imprime Section(1) - resumida.
					
					nSldATransp := nSaldoAtu // Valor a Transportar  (nSld-A-Transp)

			     	oSection2:PrintLine()
				    oReport:IncMeter()

					nSldDTransp := nSaldoAtu // Valor de Transporte (nSld-D-Transp)

					nTotDeb		+= nVlrDeb
					nTotCrd		+= nVlrCrd         
					nVlrDeb	:= 0
					nVlrCrd	:= 0
				Endif // lAnalitico		   			
			EndDo //cArqTmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt
   				oSection2:Finish()        
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FIM DA 2a SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA 3a SECAO - Totais da Conta ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection3:Cell("TOT"):SetTitle(OemToAnsi("T o t a i s  d a  C o n t a  ==> "))//"T o t a i s  d a  C o n t a  ==> " 	    
			oSection3:Cell("TOT_DEBITO"	):SetBlock(	{ || ValorCTB(nTotDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
			oSection3:Cell("TOT_CREDITO" ):SetBlock(	{ || ValorCTB(nTotCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
			oSection3:Cell("TOT_ATU"	):SetBlock(		{ || ValorCTB(nSaldoAtu,,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )

			// Imprime totalizado

			oSection3:PrintLine()         
			
			oSection3:Finish()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FIM DA 3a SECAO - Totais da Conta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		EndDo //lImpLivro .And. !cArqTmp->(Eof())

		If lImpLivro .And. mv_par28 == 1	//Imprime total Geral
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA 3a SECAO - Total Geral     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			oSection3:Cell("TOT"):SetTitle(OemToAnsi("T O T A L  G E R A L  ==> "))//"T O T A L  G E R A L  ==> "
			oSection3:Cell("TOT_ATU"):Disable()

			If lAnalitico .And. (lCusto .Or. lItem .Or. lClVl)
				oSection3:Cell("TOT_DEBITO"	):SetBlock(		{ || ValorCTB(nTotGerDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
				oSection3:Cell("TOT_CREDITO" ):SetBlock(	{ || ValorCTB(nTotGerCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
			Else
				oSection3:Cell("TOT_DEBITO"	):SetBlock(		{ || ValorCTB(nTotGerDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
				oSection3:Cell("TOT_CREDITO" ):SetBlock(	{ || ValorCTB(nTotGerCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
			Endif
			
			// Imprime totalizado
			oSection3:Init()
			oSection3:PrintLine()
			oSection3:Finish()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FIM DA 3a SECAO - Total Geral    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Endif

	EndIf //!(cArqTmp->(RecCount()) == 0 .And. !Empty(aSetOfBook[5]))
EndIf // lImpLivro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Termos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpTermos 							// Impressao dos Termos
	
	oSection2:SetHeaderPage(.F.) // Desabilita a impressao 
	
	cArqAbert:=GetNewPar("MV_LRAZABE","")
	cArqEncer:=GetNewPar("MV_LRAZENC","")
	
    If Empty(cArqAbert)
		ApMsgAlert(	"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. Utilize como base o parametro MV_LDIARAB.")
	Endif
Endif

If lImpTermos .And. ! Empty(cArqAbert)	
	dbSelectArea("SM0")
	aVariaveis:={}

	For nCont:=1 to FCount()	
		If FieldName(nCont)=="M0_CGC"
			AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
		Else
            If FieldName(nCont)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
		Endif
	Next

	dbSelectArea("SX1")
	dbSeek("CTR400"+"01")

	While SX1->X1_GRUPO=="CTR400"
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	End

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		oReport:EndPage()
		ImpTerm2(cArqAbert,aVariaveis,,,,oReport)
	Endif
	If cArqEncer#NIL
		oReport:EndPage()
		ImpTerm2(cArqEncer,aVariaveis,,,,oReport)
	Endif	 
Endif

dbselectArea("CT2")
If !Empty(dbFilter())
	dbClearFilter()
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpCompl  ºAutor  ³Cicero J. Silva     º Data ³  27/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a descricao, da conta contabil, item, centro de     º±±
±±º          ³custo ou classe valor                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpCompl(oReport)
	
	Local oSection4 := oReport:Section(4)

	oSection4:Cell("COMP"):SetBlock({|| Space(15)+CT2->CT2_LINHA,Subs(CT2->CT2_HIST,1,40) } )
	
	// Procura pelo complemento de historico
	dbSelectArea("CT2")
	dbSetOrder(10)
	If MsSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
		dbSkip()
		If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
			oSection4:Init()
			While !CT2->(Eof()) .And.;
					CT2->CT2_FILIAL == xFilial("CT2") .And.;
					 CT2->CT2_LOTE == cArqTMP->LOTE .And.;
					  CT2->CT2_SBLOTE == cArqTMP->SUBLOTE .And.;
					   CT2->CT2_DOC == cArqTmp->DOC .And.;
						CT2->CT2_SEQLAN == cArqTmp->SEQLAN .And.;
						 CT2->CT2_EMPORI == cArqTmp->EMPORI .And.;
						  CT2->CT2_FILORI == cArqTmp->FILORI .And.;
						   CT2->CT2_DC == "4" .And.;
				    	    DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)
				oSection4:Printline()
				CT2->(dbSkip())			
			EndDo	
			oSection4:Finish()
		EndIf
	EndIf                  

	dbSelectArea("cArqTmp")

Return 


/*********************************************
************ALTERAÇÃO: 05/08/2010*************
***************FELIPE CICONINI****************
******IMPRESSÃO DA OBS E DESC DOS ITENS*******
*********************************************/

Static Function ImpPed()
	
   	CV3->(DbSetOrder(1))
	If CV3->(DbSeek(xFilial("CV3")+DtoS(CT2->CT2_DATA)+CT2->CT2_SEQUEN))
		SF1->(DbGoTo(CV3->CV3_RECORI))
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			SC7->(DbSetOrder(1))
			If SC7->(DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
			    @Prow()+2,000 psay __PrtThinLine()
				@Prow()+1,002 psay SC7->C7_OBS
				@Prow()+3,002 psay SC7->C7_DESC
			EndIf
		EndIf
	Endif
	
Return 







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f180Fil   ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f180Fil(lNoMov,aSaldo,dDataIni,dDataFim)

Local lDeixa	:= .F.

	If !lNoMov //Se imprime conta sem movimento
		If aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
			lDeixa	:= .T.
		Endif	
	Endif             
	
	If lNoMov .And. aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
		If CtbExDtFim("CT1") 			
			dbSelectArea("CT1") 
			dbSetOrder(1) 
			If MsSeek(xFilial()+cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",dDataIni) 		
					lDeixa	:= .T.
	            EndIf                                   
	            
	            If !CtbVlDtIni("CT1",dDataFim)
					lDeixa	:= .T.
	            EndIf                                   

		    EndIf
		EndIf
	EndIf

	dbSelectArea("cArqTmp")

Return (lDeixa)

/*

------------------------------------------------------- RELEASE 4 ---------------------------------------------------------------

*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR400R3³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR400R3()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR400R3(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
					cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
					lClVl, cClvlIni, cClvlFim,lSaltLin,cMoedaDesc )

Local aCtbMoeda	:= {}
Local WnRel			:= "CTBR400"
Local cDesc1		:= "Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2		:= "de acordo com os parametros solicitados pelo"
Local cDesc3		:= "usuario."
Local cString		:= "CT2"
Local titulo		:= "Emissao do Razao Contabil"
Local lAnalitico 	:= .T.
Local lRet			:= .T.
Local lExterno		:= cContaIni <> Nil
Local nTamLinha		:= 220
Local nTamConta		:= Len(CriaVar ("CT1_CONTA"))
Local cSepara1		:= ""

DEFAULT lCusto		:= .F.
DEFAULT lItem		:= .F.
DEFAULT lCLVL		:= .F.
DEFAULT lSaltLin	:= .T.
DEFAULT cMoedaDesc  := cMoeda

Private aReturn	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1 }  //"Zebrado"###"Administracao"
Private nomeprog	:= "NHCON018"
Private aLinha		:= {}
Private nLastKey	:= 0
Private cPerg		:= "CTR400"
Private Tamanho 	:= "G"
Private lSalLin		:= .T.

                                            
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

// AjusteSX1()
Pergunte("CTR400", .F.)

AjCTR400MV9()									//// AJUSTA O SX1 (PERGUNTA 09) PARA IMPRIMIR S/ MOVIMENTO COM SALDO ANTERIOR.
If ! lExterno
	If ! Pergunte("CTR400", .T.)
		Return
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // da conta                              ³
//³ mv_par02            // ate a conta                           ³
//³ mv_par03            // da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Moeda			                          ³   
//³ mv_par06            // Saldos		                          ³   
//³ mv_par07            // Set Of Books                          ³
//³ mv_par08            // Analitico ou Resumido dia (resumo)    ³
//³ mv_par09            // Imprime conta sem movimento?          ³
//³ mv_par10            // Junta Contas com mesmo C.Custo?       ³
//³ mv_par11            // Impr Cod (Normal/Reduzida/Cod.Impress)³ /// VER CT1_CODIMP
//³ mv_par12            // Imprime C.Custo?                      ³
//³ mv_par13            // Do Centro de Custo                    ³
//³ mv_par14            // At‚ o Centro de Custo                 ³
//³ mv_par15            // Imprime Item?	                       ³	
//³ mv_par16            // Do Item                               ³
//³ mv_par17            // Ate Item                              ³
//³ mv_par18            // Imprime Classe de Valor?              ³	
//³ mv_par19            // Da Classe de Valor                    ³
//³ mv_par20            // Ate a Classe de Valor                 ³
//³ mv_par21            // Salto de pagina                       ³
//³ mv_par22            // Pagina Inicial                        ³
//³ mv_par23            // Pagina Final                          ³
//³ mv_par24            // Numero da Pag p/ Reiniciar            ³	   
//³ mv_par25            // Imprime Cod C.Custo(Normal / Reduzido)³
//³ mv_par26            // Imprime Cod Item (Normal / Reduzido)  ³
//³ mv_par27            // Imprime Cod Cl.Valor(Normal /Reduzida)³
//³ mv_par28            // Imprime Total Geral (Sim/Nao)         ³
//³ mv_par29            // So Livro/Livro e Termos/So Termos     ³
//³ mv_par30		  		// Imprime valor 0.00    ?		      	  ³
//³ mv_par31		  		//"Salta linha entre contas?"
//³ mv_par32            // Num.linhas p/ o Razao?				 ³ 
//³ mv_par33            // Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr	 ³
//³ mv_par33            // Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr	 ³
//³ mv_par34            // Descrição na moeda					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)
nTamLinha	:= If( lAnalitico, 220, 132)  

If !lExterno
	lCusto 		:= Iif(mv_par12 == 1,.T.,.F.)
	lItem		:= Iif(mv_par15 == 1,.T.,.F.)
	lCLVL		:= Iif(mv_par18 == 1,.T.,.F.)
EndIf

aSetOfBook	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par07)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par07)
EndIf      

If !lRet
	Set Filter To
	Return
Endif

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1	:= RetMasCtb(aSetOfBook[2],@cSepara1)
	//A mascara sera considerada no tamanho da conta somente com a mascara da configuracao de livros. 
	//Quando nao tiver configuracao de livros, o relatorio podera ser impresso em formato retrato e, caso 
	//nao haja espaco para a impressao do codigo da conta (contra-partida), esse codigo sera truncado.
	nTamConta	:= nTamConta+Len(ALLTRIM(cSepara1))	
EndIf               

If (lAnalitico .And. (!lCusto .And. !lItem .And. !lCLVL) .And. nTamConta <= 22) .Or. ! lAnalitico 
	Tamanho := "M"
	nTamLinha := 132
EndIf	

wnrel := SetPrint(cString,wnrel,If(! lExterno, cPerg,),@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC400
If ! lExterno
	lCusto 	:= Iif(mv_par12 == 1,.T.,.F.)
	lItem		:= Iif(mv_par15 == 1,.T.,.F.)
	lCLVL		:= Iif(mv_par18 == 1,.T.,.F.)
	cMoedaDesc	:= mv_par34
Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
	mv_par01 := cContaIni
	mv_par02 := cContaFim
	mv_par03 := dDataIni
	mv_par04 := dDataFim
	mv_par05 := cMoeda
	mv_par06 := cSaldos
	mv_par07 := cBook
	mv_par12 := If(lCusto =.T.,1,2)
	mv_par13 := cCustoIni
	mv_par14 := cCustoFim
	mv_par15 := If(lItem =.T.,1,2)
	mv_par16 := cItemIni
	mv_par17 := cItemFim
	mv_par18 := If(lClVl =.T.,1,2)
	mv_par19 := cClVlIni
	mv_par20 := cClVlFim
	mv_par31 := If(lSaltLin==.T.,1,2)
	mv_par34 := cMoedaDesc
Endif

lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)
nTamLinha	:= If( lAnalitico, 220, 132)

If (lAnalitico .And. (!lCusto .And. !lItem .And. !lCLVL).And. nTamConta<= 22) .Or. ! lAnalitico
	Tamanho := "M"
	nTamLinha := 132
EndIf	

If nLastKey = 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par07)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par07)
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par05)
   If Empty(aCtbMoeda[1])
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet	
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR400Imp(@lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,;
	   	lAnalitico,Titulo,nTamlinha,aCtbMoeda, nTamConta)})
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTR400Imp ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Razao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³Ctr400Imp(lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,;      ³±±
±±³           ³          lCLVL,Titulo,nTamLinha,aCtbMoeda)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd       - A‡ao do Codeblock                             ³±±
±±³           ³ wnRel      - Nome do Relatorio                             ³±±
±±³           ³ cString    - Mensagem                                      ³±±
±±³           ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³           ³ lCusto     - Imprime Centro de Custo?                      ³±±
±±³           ³ lItem      - Imprime Item Contabil?                        ³±±
±±³           ³ lCLVL      - Imprime Classe de Valor?                      ³±± 
±±³           ³ Titulo     - Titulo do Relatorio                           ³±±
±±³           ³ nTamLinha  - Tamanho da linha a ser impressa               ³±± 
±±³           ³ aCtbMoeda  - Moeda                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR400Imp(lEnd,WnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,lAnalitico,Titulo,nTamlinha,;
						aCtbMoeda,nTamConta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSaldo		:= {}
Local aSaldoAnt		:= {}
Local aColunas 

Local cArqTmp
Local cSayCusto	:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")

Local cDescMoeda
Local cMascara1
Local cMascara2
Local cMascara3
Local cMascara4
Local cPicture
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cSaldo		:= mv_par06
Local cContaIni		:= mv_par01
Local cContaFIm		:= mv_par02
Local cCustoIni		:= mv_par13
Local cCustoFim		:= mv_par14
Local cItemIni		:= mv_par16
Local cItemFim		:= mv_par17
Local cCLVLIni		:= mv_par19
Local cCLVLFim		:= mv_par20
Local cContaAnt		:= ""
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResCLVL		:= ""
Local cDescSint		:= ""
Local cMoeda		:= mv_par05
Local cContaSint	:= ""
Local cNormal 		:= ""

Local dDataAnt		:= CTOD("  /  /  ")
Local dDataIni		:= mv_par03
Local dDataFim		:= mv_par04

Local lNoMov		:= Iif(mv_par09==1,.T.,.F.)
Local lSldAnt		:= Iif(mv_par09==3,.T.,.F.)
Local lJunta		:= Iif(mv_par10==1,.T.,.F.)
Local lSalto		:= Iif(mv_par21==1,.T.,.F.)
Local lFirst		:= .T.
Local lImpLivro		:= .t.
Local lImpTermos	:= .f.
Local lPrintZero	:= Iif(mv_par30==1,.T.,.F.)

Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nPagIni		:= mv_par22
Local nReinicia 	:= mv_par24
Local nPagFim		:= mv_par23
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local nCont			:= 0
Local l1StQb 		:= .T.
Local lQbPg			:= .F.
Local lEmissUnica	:= If(GetNewPar("MV_CTBQBPG","M") == "M",.T.,.F.)			/// U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lNewPAGFIM	:= If(nReinicia > nPagFim,.T.,.F.)
Local LIMITE		:= If(TAMANHO=="G",220,If(TAMANHO=="M",132,80))
Local nInutLin		:= 1
Local nMaxLin   	:= mv_par32

Local nBloco		:= 0
Local nBlCount		:= 0

Local lSldAntCta	:= Iif(mv_par33 == 1, .T.,.F.)
Local lSldAntCC		:= Iif(mv_par33 == 2, .T.,.F.)
Local lSldAntIt  	:= Iif(mv_par33 == 3, .T.,.F.)
Local lSldAntCv  	:= Iif(mv_par33 == 4, .T.,.F.)

Local cMoedaDesc	:= iif( Empty( mv_par34 ) , cMoeda , mv_par34)

lSalLin		:= If(mv_par31 ==1 ,.T.,.F.)
m_pag    := 1

If lEmissUnica
	CtbQbPg(.T.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par29==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par29==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par29==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf               

If lCusto .Or. lItem .Or. lCLVL
	// Mascara do Centro de Custo
	If Empty(aSetOfBook[6])
		cMascara2 := GetMv("MV_MASCCUS")
	Else
		cMascara2	:= RetMasCtb(aSetOfBook[6],@cSepara2)
	EndIf                                                

	// Mascara do Item Contabil
	If Empty(aSetOfBook[7])
		dbSelectArea("CTD")
		cMascara3 := ALLTRIM(STR(Len(CTD->CTD_ITEM)))
	Else
		cMascara3 := RetMasCtb(aSetOfBook[7],@cSepara3)
	EndIf

	// Mascara da Classe de Valor
	If Empty(aSetOfBook[8])
		dbSelectArea("CTH")
		cMascara4 := ALLTRIM(STR(Len(CTH->CTH_CLVL)))
	Else
		cMascara4 := RetMasCtb(aSetOfBook[8],@cSepara4)
	EndIf
EndIf	

cPicture 	:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")== "U"
	IF lAnalitico
		Titulo	:=	"RAZAO ANALITICO EM "
	Else
		Titulo	:=	"RAZAO SINTETICO EM "
	EndIf
	Titulo += 	cDescMoeda + " DE " + DTOC(dDataIni) +;	// "DE"
				" ATE " + DTOC(dDataFim) + CtbTitSaldo(mv_par06)	// "ATE"
Else
	Titulo := NewHead
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resumido                                  						         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA                         					                                DEBITO               CREDITO            SALDO ATUAL
// XX/XX/XXXX 			                                 		     99,999,999,999,999.99 99,999,999,999,999.99 99,999,999,999,999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabe‡alho Conta                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA
// LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL"
// XX/XX/XXXX         
// XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 9999999999999.99 9999999999999.99 9999999999999.99D
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabe‡alho Conta + CCusto + Item + Classe de Valor								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA
// LOTE/SUB/DOC/LINHA  H I S T O R I C O                        C/PARTIDA                      CENTRO CUSTO         ITEM                 CLASSE DE VALOR                     DEBITO               CREDITO           SALDO ATUAL"
// XX/XX/XXXX 
// XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 99,999,999,999,999.99 99,999,999,999,999.99 99,999,999,999,999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22

#DEFINE 	COL_NUMERO 			1
#DEFINE 	COL_HISTORICO		2
#DEFINE 	COL_CONTRA_PARTIDA	3
#DEFINE 	COL_CENTRO_CUSTO 	4
#DEFINE 	COL_ITEM_CONTABIL 	5
#DEFINE 	COL_CLASSE_VALOR  	6 
#DEFINE 	COL_VLR_DEBITO		7
#DEFINE 	COL_VLR_CREDITO		8
#DEFINE 	COL_VLR_SALDO  		9
#DEFINE 	TAMANHO_TM       	10
#DEFINE 	COL_VLR_TRANSPORTE  11

If mv_par11 == 3 						//// SE O PARAMETRO DO CODIGO ESTIVER PARA IMPRESSAO
	nTamConta := Len(CT1->CT1_CODIMP)	//// USA O TAMANHO DO CAMPO CODIGO DE IMPRESSAO
Endif
If lAnalitico .And. (lCusto .Or. lItem .Or. lCLVL)
	nTamConta := 30						// Tamanho disponivel no relatorio para imprimir
EndIf		
If ! lAnalitico
	aColunas := { 000, 019,    ,    ,    ,    , 068, 090, 111, 19, 091 }
Else
	If cPaisLoc == "CHI"
		If ((!lCusto .And. !lItem .And. !lCLVL) .And. nTamConta<= 22)
  			aColunas := { 000, 030, 060,    ,    ,    , 84, 100, 115, 15, 097}
		Else
			aColunas := { 000, 030, 060, 092, 113, 134, 156, 178, 198, 20 ,178 }
		Endif
	Else
	   If ((!lCusto .And. !lItem .And. !lCLVL) .And. nTamConta<=22)
	  		aColunas := { 000, 019, 060,    ,    ,    , 84, 100, 115, 15, 097}
	   Else
			aColunas := { 000, 019, 060, 092, 113, 134, 156, 178, 198, 20 ,178 }
	   Endif
	EndIf
Endif
If lAnalitico							   	// Relatorio Analitico
	Cabec1 := "DATA"
	Cabec2 := ""
	If (!lCusto .And. !lItem .And. !lCLVL)
		If nTamConta <= 22
			Cabec2:= "LOTE/SUB/DOC/LINHA H I S T O R I C O                          C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL"
		Else 
		   Cabec2 := "LOTE/SUB/DOC/LINHA H I S T O R I C O                          C/PARTIDA                      													                                                                             DEBITO               CREDITO         SALDO ATUAL"
	    EndIf
	Else
	 	Cabec2 := "LOTE/SUB/DOC/LINHA  H I S T O R I C O                    C/PARTIDA            CENTRO CUSTO         ITEM                 CLASSE DE VALOR                     DEBITO               CREDITO           SALDO ATUAL"
		Cabec2 += Upper(cSayCusto) +Space(11)+Upper(cSayItem)+Space(11)+Upper(cSayClVl)+Space(26)
		//Cabec2 += 
   EndIf
Else                
	lCusto := .F.
	lItem  := .F.
	lCLVL  := .F.
	Cabec1 := "DATA					                              					              	 DEBITO               CREDITO          	SALDO ATUAL"
	Cabec2 := ""
EndIf	

m_pag := mv_par22

If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,aReturn[7],lSldAnt)},;
				"Criando Arquivo Temporario...",;		// "Criando Arquivo Tempor rio..."
				"Emissao do Razao")		// "Emissao do Razao"

	dbSelectArea("CT2") 
	If !Empty(dbFilter())
		dbClearFilter()
	Endif
	dbSelectArea("cArqTmp")
	SetRegua(RecCount())
	dbGoTop()
Endif

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If lImpLivro
	If cArqTmp->(RecCount()) == 0 .And. !Empty(aSetOfBook[5])                                       
		dbCloseArea()
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())	
		Return
	EndIf
Endif

While lImpLivro .And. !cArqTmp->(Eof())

	IF lEnd
		@Prow()+1,0 PSAY "***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()
                                                                    
	If lSldAntCC
		aSaldo    := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
		aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
	ElseIf lSldAntIt
		aSaldo    := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
		aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
	ElseIf lSldAntCv
		aSaldo    := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
		aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
	Else 
		aSaldo 		:= SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)	
		aSaldoAnt	:= SaldoCT7(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR400")
	EndIf
	
	If !lNoMov //Se imprime conta sem movimento
		If aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		Endif	
	Endif             
	
	If lNomov .And. aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
		If CtbExDtFim("CT1") 			
			dbSelectArea("CT1") 
			dbSetOrder(1) 
			If MsSeek(xFilial()+cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",dDataIni) 		
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop								
	            EndIf                                   
	            
	            If !CtbVlDtIni("CT1",dDataFim)
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop								
	            EndIf                                   

		    EndIf
		    dbSelectArea("cArqTmp")
		EndIf
	EndIf

	If li > nMaxLin .Or. lSalto              
		If lEmissUnica
			CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
		Else
			If m_pag > nPagFim
				If lNewPAGFIM
					nPagFim := m_pag+nPagFim		
					If l1StQb							//// SE FOR A 1ª QUEBRA
						m_pag := nReinicia
						l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
					Endif
				Else
					m_pag := nReinicia
				Endif
			EndIf	
		Endif
		CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
		If !lFirst
			lQbPg	:= .T.
		Else
			lFirst := .F.
		Endif
	EndIf

	nSaldoAtu:= 0
	nTotDeb	:= 0
	nTotCrd	:= 0                              
	
	// Conta Sintetica	
	cContaSint := Ctr400Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes,cMoedaDesc)
	cNormal := CT1->CT1_NORMAL
	If mv_par11 == 3
		EntidadeCTB(CT1->CT1_CODIMP,li,000,nTamConta,.F.,cMascara1,cSepara1)
		@li,Len(CT1->CT1_CODIMP) PSAY " - " + cDescSint
	Else
		EntidadeCTB(cContaSint,li,000,Len(cContaSint),.F.,cMascara1,cSepara1)
		@li,Len(cContaSint) PSAY " - " + cDescSint
	Endif
	If lSalLin
		li+=2
	Else
		li+=1
	EndIf
	// Conta Analitica

	@li,001 PSAY "CONTA - "	

	If mv_par11 == 1							// Imprime Cod Normal
		EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
	Else
		dbSelectArea("CT1")
		dbSetOrder(1)
		MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)
		If mv_par11 == 3						// Imprime Codigo de Impressao
			EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
		Else										// Caso contrário usa codigo reduzido
			EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
		EndIf

        msgalert( cMoedaDesc )
        
		cDescConta := &("CT1->CT1_DESC" + cMoedaDesc )
	Endif
	If !lAnalitico 
		@ li, 9+nTamConta PSAY "- " + Left(cDescConta,30)	
	Else
		@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)
	Endif
	
	@li,aColunas[COL_VLR_TRANSPORTE] - Len("SALDO ANTERIOR: ") - 1;
		 PSAY "SALDO ANTERIOR: "	
	
	// Impressao do Saldo Anterior do Centro de Custo
	ValorCTB(aSaldoAnt[6],li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,;
							         .T.,cPicture, , , , , , ,lPrintZero)

	nSaldoAtu := aSaldoAnt[6]                                           
	If lSalLin
		li+=2
	Else
		li += 1         
	EndIf
	dbSelectArea("cArqTmp")
	cContaAnt:= cArqTmp->CONTA
	dDataAnt	:= CTOD("  /  /  ")
	While cArqTmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt
	
		If li > nMaxLin
			If lSalLin
				li++
			EndIf
			
			@li,aColunas[COL_VLR_TRANSPORTE] - Len("A TRANSPORTAR : ") - 1;
						 PSAY "A TRANSPORTAR : "
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
					   aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal , , , , , ,lPrintZero)
			
			If lEmissUnica
				CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
			Else
				If m_pag > nPagFim
					If lNewPAGFIM
						nPagFim := m_pag+nPagFim
						If l1StQb							//// SE FOR A 1ª QUEBRA
							m_pag := nReinicia
							l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
						Endif
					Else
						m_pag := nReinicia
					Endif
				EndIf	
			Endif
			CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
			lQbPg := .T.
			
			@li,001 PSAY "CONTA - "	

			If mv_par11 == 1							// Imprime Cod Normal
				EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
			Else
				dbSelectArea("CT1")
				dbSetOrder(1)
				MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)
				If mv_par11 == 3						// Imprime Codigo de Impressao
					EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
				Else										// Caso contrário usa codigo reduzido
					EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
				EndIf
				cDescConta := &("CT1->CT1_DESC" + cMoedaDesc)
			Endif
			@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)			
			
			@li,aColunas[COL_VLR_TRANSPORTE] - Len("DE TRANSPORTE : ") - 1 PSAY "DE TRANSPORTE : "
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal , , , , , ,lPrintZero)
			li+= 2
		EndIf
	
		// Imprime os lancamentos para a conta                          
		
		If dDataAnt != cArqTmp->DATAL 
			If (cArqTmp->LANCDEB <> 0 .Or. cArqTmp->LANCCRD <> 0)
				If lAnalitico
					@li,000 PSAY cArqTmp->DATAL
					li++                       
				Else
					@li,000 PSAY cArqTmp->DATAL
				Endif		
			Endif	
			dDataAnt := cArqTmp->DATAL    
			lQbPg := .F.			
		ElseIf lQbPg
			@li,000 PSAY dDataAnt
			li++                       		
			lQbPg := .F.
		EndIf	
		
		If lAnalitico		//Se for relatorio analitico
			nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
			nTotDeb		+= cArqTmp->LANCDEB
			nTotCrd		+= cArqTmp->LANCCRD
			nTotGerDeb	+= cArqTmp->LANCDEB
			nTotGerCrd	+= cArqTmp->LANCCRD			
			
			dbSelectArea("CT1")
			dbSetOrder(1)
			MsSeek(xFilial("CT1")+cArqTmp->XPARTIDA)
			cCodRes := CT1->CT1_RES
			dbSelectArea("cArqTmp")

			If cPaisLoc == "CHI"
				@li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA+" "+cArqTmp->SEGOFI 
				@li,aColunas[COL_HISTORICO] PSAY Subs(cArqTmp->HISTORICO,1,30)
			Else
				@li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA
				@li,aColunas[COL_HISTORICO] PSAY Subs(cArqTmp->HISTORICO,1,40)
			EndIf									   

			If mv_par11 == 1
				EntidadeCTB(cArqTmp->XPARTIDA,li,aColunas[COL_CONTRA_PARTIDA], nTamConta ,.F.,cMascara1 ,cSepara1)
			ElseIf mv_par11 == 3
				EntidadeCTB(CT1->CT1_CODIMP,li,aColunas[COL_CONTRA_PARTIDA],nTamConta,.F., cMascara1 ,cSepara1)				
			Else
				EntidadeCTB(CT1->CT1_RES,li,aColunas[COL_CONTRA_PARTIDA],17,.F., cMascara1 ,cSepara1)				
			Endif                              

			If lCusto
				If mv_par25 == 1 //Imprime Cod. Centro de Custo Normal 
					EntidadeCTB(cArqTmp->CCUSTO,li,aColunas[COL_CENTRO_CUSTO],17,.F.,cMascara2,cSepara2)
				Else 
					dbSelectArea("CTT")
					dbSetOrder(1)
					dbSeek(xFilial("CTT")+cArqTmp->CCUSTO)				
					cResCC := CTT->CTT_RES
					EntidadeCTB(cResCC,li,aColunas[COL_CENTRO_CUSTO],17,.F.,cMascara2,cSepara2)
					dbSelectArea("cArqTmp")
				Endif                                                       
			Endif

			If lItem 						//Se imprime item 
				If mv_par26 == 1 //Imprime Codigo Normal Item Contabl
					EntidadeCTB(cArqTmp->ITEM,li,aColunas[COL_ITEM_CONTABIL],17,.F.,cMascara3,cSepara3)
				Else
					dbSelectArea("CTD")
					dbSetOrder(1)
					dbSeek(xFilial("CTD")+cArqTmp->ITEM)				
					cResItem := CTD->CTD_RES
					EntidadeCTB(cResItem,li,aColunas[COL_ITEM_CONTABIL],17,.F.,cMascara3,cSepara3)						
					dbSelectArea("cArqTmp")					
				Endif
			Endif
				
			If lCLVL						//Se imprime classe de valor
				If mv_par27 == 1 //Imprime Cod. Normal Classe de Valor
					EntidadeCTB(cArqTmp->CLVL,li,aColunas[COL_CLASSE_VALOR],17,.F.,cMascara4,cSepara4)
				Else
					dbSelectArea("CTH")
					dbSetOrder(1)
					dbSeek(xFilial("CTH")+cArqTmp->CLVL)				
					cResClVl := CTH->CTH_RES						
					EntidadeCTB(cResClVl,li,aColunas[COL_CLASSE_VALOR],17,.F.,cMascara4,cSepara4)
					dbSelectArea("cArqTmp")					
				Endif			
			Endif
			
			ValorCTB(cArqTmp->LANCDEB,li,aColunas[COL_VLR_DEBITO],;
			  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			ValorCTB(cArqTmp->LANCCRD,li,aColunas[COL_VLR_CREDITO],;
			  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
			   aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal, , , , , ,lPrintZero)

			// Procura pelo complemento de historico
			dbSelectArea("CT2")
			dbSetOrder(10)
			If MsSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
				//MsSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN),.F.)
				dbSkip()
				If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
					While !CT2->(Eof()) .And. CT2->CT2_FILIAL == xFilial("CT2") 			.And.;
										CT2->CT2_LOTE == cArqTMP->LOTE 		.And.;
										CT2->CT2_SBLOTE == cArqTMP->SUBLOTE 	.And.;
										CT2->CT2_DOC == cArqTmp->DOC 			.And.;
										CT2->CT2_SEQLAN == cArqTmp->SEQLAN 	.And.;
										CT2->CT2_EMPORI == cArqTmp->EMPORI	.And.;
										CT2->CT2_FILORI == cArqTmp->FILORI	.And.;
										CT2->CT2_DC == "4" 					.And.;
								   DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)                        
						li++
						If li > nMaxLin
							//// VALOR A TRANSPORTAR NA QUEBRA DE PAGINA    
							
							If lSalLin
								li++
							EndIf
							
							@li,aColunas[COL_VLR_TRANSPORTE] - Len("A TRANSPORTAR : ") - 1 PSAY "A TRANSPORTAR : "
							ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal, , , , , ,lPrintZero)
						    //// FIM DO TRATAMENTO PARA QUEBRA DO VALORA A TRANSPORTAR
						              
							If lEmissUnica
								CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
							Else
								If m_pag > nPagFim
									If lNewPAGFIM
										nPagFim := m_pag+nPagFim
										If l1StQb							//// SE FOR A 1ª QUEBRA
											m_pag := nReinicia
											l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
										Endif
									Else
										m_pag := nReinicia
									Endif
								EndIf	
							Endif
							CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)

							//// VALOR DE TRANSPORTE NA QUEBRA DE PÁGINA
							@li,001 PSAY "CONTA - "	
	
							If mv_par11 == 1							// Imprime Cod Normal
								EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
							Else
								dbSelectArea("CT1")
								dbSetOrder(1)
								MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)											
								If mv_par11 == 3						// Imprime Codigo de Impressao
									EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
								Else										// Caso contrário usa codigo reduzido
									EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
								Endif
								cDescConta := &("CT1->CT1_DESC" + cMoedaDesc)
								dbSelectArea("CT2")
							EndIf
							@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)			
			
							@li,aColunas[COL_VLR_TRANSPORTE] - Len("DE TRANSPORTE : ") - 1 PSAY "DE TRANSPORTE : "
							ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal , , , , , ,lPrintZero)
							li+= 2
							//// FINAL DO TRATAMENTO PARA O VALOR DE TRANSPORTE NA QUEBRA DE PAGINA
							
							If !lFirst
								@li,000 PSAY dDataAnt
								li++
							Else
								lFirst := .F.
							Endif
						
						EndIf
						@li,aColunas[COL_NUMERO] 	 PSAY Space(15)+CT2->CT2_LINHA
						@li,aColunas[COL_HISTORICO] PSAY Subs(CT2->CT2_HIST,1,40)
						CT2->(dbSkip())
					EndDo	
				EndIf	
			EndIf	
			dbSelectArea("cArqTmp")
			dbSkip()			
		Else		// Se for resumido.                               			
			dbSelectArea("cArqTmp")
			While dDataAnt == cArqTmp->DATAL .And. cContaAnt == cArqTmp->CONTA
				nVlrDeb	+= cArqTmp->LANCDEB		                                         
				nVlrCrd	+= cArqTmp->LANCCRD		                                         
				nTotGerDeb	+= cArqTmp->LANCDEB
				nTotGerCrd	+= cArqTmp->LANCCRD			
				dbSkip()                                                                    				
			End			                                                                    
			nSaldoAtu	:= nSaldoAtu - nVlrDeb + nVlrCrd
			ValorCTB(nVlrDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],;
				nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			ValorCTB(nVlrCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],;
				nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],;
				nDecimais,.T.,cPicture,cNormal, , , , , ,lPrintZero)
			nTotDeb		+= nVlrDeb
			nTotCrd		+= nVlrCrd         
			nVlrDeb	:= 0
			nVlrCrd	:= 0
		Endif
		dbSelectArea("cArqTmp")
		//dbSkip()  
		li++
	EndDo

   	If lSalLin
		li+=2
	EndIf
	If li > nMaxLin
		If lSalLin
			li++
		EndIf
	
		@li,aColunas[COL_VLR_TRANSPORTE] - Len("A TRANSPORTAR : ") - 1;
					 PSAY "A TRANSPORTAR : "
		ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
		   aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal, , , , , ,lPrintZero)

		If lEmissUnica
			CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
		Else
			If m_pag > nPagFim
				If lNewPAGFIM
					nPagFim := m_pag+nPagFim
					If l1StQb							//// SE FOR A 1ª QUEBRA
						m_pag := nReinicia
						l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
					Endif
				Else
					m_pag := nReinicia
				Endif
			EndIf	
		Endif
		CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
		If !lFirst
			lQbPg := .T.
		Else
			lFirst := .F.                                
		Endif
		
		@li,001 PSAY "CONTA - "	

		If Empty(cContaAnt) .or. cArqTMP->CONTA == cContaAnt			//// SE O REG NO COMECO DA PAGINA FOR DA MESMA CONTA DA PG ANTERIOR
			If mv_par11 == 1							// Imprime Cod Normal
				EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
			Else
				dbSelectArea("CT1")
				dbSetOrder(1)
				MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)			
				If mv_par11 == 3						// Imprime Codigo de Impressao
					EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
				Else										// Caso contrário usa codigo reduzido
					EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
				EndIf
			Endif
		Else									//// SE NAO FOR DA MESMA CONTA
			dbSelectArea("CT1")
			dbSetOrder(1)
			If MsSeek(xFilial("CT1")+cContaAnt,.F.)		/// IMPRIME OS DADOS DA CONTA ANTERIOR
				If mv_par11 == 1							// Imprime Cod Normal
					EntidadeCTB(cContaAnt,li,9,nTamConta,.F.,cMascara1,cSepara1)
				ElseIf mv_par11 == 3						// Imprime Codigo de Impressao
					EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
				Else										// Caso contrário usa codigo reduzido
					EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
				EndIf
			Endif
		Endif
		cDescConta := &("CT1->CT1_DESC" + cMoedaDesc)
		@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)				
	
		@li,aColunas[COL_VLR_TRANSPORTE] - Len("DE TRANSPORTE ") - 1 PSAY "DE TRANSPORTE "
		ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal, , , , , ,lPrintZero)
		
		If lSalLin
			li+=2
		Else
			li+= 1
		EndIf
		
		If lQbPg
			If cArqtmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt		
				@li,000 PSAY dDataAnt
			EndIf
			li++
			lQbPg := .F.
		Endif
   EndIf
    
	@li,aColunas[If(lAnalitico,COL_HISTORICO,COL_NUMERO)] PSAY "T o t a i s  d a  C o n t a  ==> "

	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,"1", , , , , ,lPrintZero)
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,"2", , , , , ,lPrintZero)
	ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,;
			 .T.,cPicture,cNormal, , , , , ,lPrintZero)
    
	li++
	@li, 00 PSAY Replicate("-",nTamLinha)
	li++
	dbSelectArea("cArqTMP")
EndDo	 
          
If li != 80 .And. lImpLivro .And. mv_par28 == 1	//Imprime total Geral
    @li, 30 PSAY "T O T A L  G E R A L  ==> " 
	If lAnalitico .And. (lCusto .Or. lItem .Or. lClVl)
		ValorCTB(nTotGerDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
		ValorCTB(nTotGerCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
		li++
		@li, 00 PSAY Replicate("-",nTamLinha)
	Else
		ValorCTB(nTotGerDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
		ValorCTB(nTotGerCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
		li++
		@li, 00 PSAY Replicate("-",nTamLinha)
	Endif
Endif



nLinAst := GetNewPar("MV_INUTLIN",0)
If li < nMaxLin .and. nLinAst <> 0 .and. !lEnd
	For nInutLin := 1 to nLinAst
		li++
		@li,00 PSAY REPLICATE("*",LIMITE)	
		If li == nMaxLin
			Exit
		EndIf
	Next
EndIf

If li <= nMaxLin .and. !lEnd .and. !lImpTermos
	Roda(cbCont,cbTxt,Tamanho)
EndIf

If lImpTermos 							// Impressao dos Termos

	cArqAbert:=GetNewPar("MV_LRAZABE","")
	cArqEncer:=GetNewPar("MV_LRAZENC","")
	
    If Empty(cArqAbert)
		ApMsgAlert(	"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. " +; //"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. "
						"Utilize como base o parametro MV_LDIARAB.") //"Utilize como base o parametro MV_LDIARAB."
	Endif
Endif

If lImpTermos .And. ! Empty(cArqAbert)	// Impressao dos Termos
	li+=2
	dbSelectArea("SM0")
	aVariaveis:={}

	For nCont:=1 to FCount()	
		If FieldName(nCont)=="M0_CGC"
			AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
		Else
            If FieldName(nCont)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
		Endif
	Next

	dbSelectArea("SX1")
	dbSeek("CTR400"+"01")

	While SX1->X1_GRUPO=="CTR400"
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	End

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		ImpTerm(cArqAbert,aVariaveis,AvalImp(132))
	Endif

	If cArqEncer#NIL
		ImpTerm(cArqEncer,aVariaveis,AvalImp(132))
	Endif	 
Endif

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End

If lImpLivro
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIf	
Endif

dbselectArea("CT2")

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGerRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Razao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim³±±
±±³			  ³cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,    ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo,lAnalit)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
						cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
						aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
						nTipo,cUFilter,lSldAnt)

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO") 
Local aTamVal	:= TAMSX3("CT2_VALOR")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()                       
Local aCampos

Local cChave

Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamCLVL	:= Len(CriaVar("CTH_CLVL"))
Local nDecimais	:= 0    
Local cMensagem		:= "O plano gerencial nao esta disponivel nesse relatorio."

DEFAULT c2Moeda := ""
DEFAULT nTipo	:= 1
DEFAULT cUFilter:= ""
DEFAULT lSldAnt		:= .F.
#IFDEF TOP
	If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL"		
		DEFAULT cUFilter	:= ".T."		
    Else
#ENDIF
	DEFAULT cUFilter	:= ""			    	
#IFDEF TOP
	Endif
#ENDIF
// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
                
aCampos :={	{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
			{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;		// Contra Partida
			{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
			{ "LANCDEB"		, "N", aTamVal[1]+2, nDecimais },; // Debito
			{ "LANCCRD"		, "N", aTamVal[1]+2	, nDecimais },; // Credito
			{ "SALDOSCR"	, "N", aTamVal[1]+2, nDecimais },; 			// Saldo
			{ "TPSLDANT"	, "C", 01, 0 },; 					// Sinal do Saldo Anterior => Consulta Razao
			{ "TPSLDATU"	, "C", 01, 0 },; 					// Sinal do Saldo Atual => Consulta Razao			
			{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico
			{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
			{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
			{ "CLVL"		, "C", nTamCLVL		, 0 },;			// Classe de Valor
			{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
			{ "LOTE" 		, "C", 06			, 0 },;			// Lote
			{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
			{ "DOC" 		, "C", 06			, 0 },;			// Documento
			{ "LINHA"		, "C", 03			, 0 },;			// Linha
			{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
			{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
			{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
			{ "FILORI"		, "C", 02			, 0 },;			// Filial Original
			{ "NOMOV"		, "L", 01			, 0 }}			// Conta Sem Movimento

If cPaisLoc = "CHI"
	Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
EndIf
If ! Empty(c2Moeda)
	Aadd(aCampos, { "LANCDEB_1"	, "N", aTamVal[1]+2, nDecimais }) // Debito
	Aadd(aCampos, { "LANCCRD_1"	, "N", aTamVal[1]+2, nDecimais }) // Credito
	Aadd(aCampos, { "TXDEBITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Debito
	Aadd(aCampos, { "TXCREDITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Credito
Endif
																	
cArqTmp := CriaTrab(aCampos, .T.)
If ( Select ( "cArqTmp" ) <> 0 )
	dbSelectArea ( "cArqTmp" )
	dbCloseArea ()
Endif

dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"			// Razao por Conta
    If FunName() <> "CTBC400"
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Else
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
	EndIf
ElseIf cTipo == "2"		// Razao por Centro de Custo                   
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC440"
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		EndIf
	Else                                                                  
		cChave 	:= "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "3" 		//Razao por Item Contabil      
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC480"
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		Endif
	Else                                                                  
		cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "4"		//Razao por Classe de Valor	
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC490"	
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
		EndIf
	Else                                                                  
		cChave 	:= "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif	
EndIf

IndRegua("cArqTmp",cArqTmp,cChave,,,"Selecionando Registros...")  //"Selecionando Registros..."
dbSelectArea("cArqTmp")
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)
                                                                                        
If !Empty(aSetOfBook[5])
	MsgAlert(cMensagem)	
	Return
EndIf                   

//CT2->(dbGotop())
#IFDEF TOP
	If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL"		
		CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)	
	Else
#ENDIF
	// Monta Arquivo para gerar o Razao
	CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
			cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
			aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt)
#IFDEF TOP
	EndIf
#ENDIF	

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbRazao  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,		   ³±±
±±³			  ³cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,   ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					  	cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
					  	aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt)

Local cCpoChave	:= ""
Local cTmpChave	:= ""
Local cContaI	:= ""
Local cContaF	:= ""
Local cCustoI	:= ""
Local cCustoF	:= ""
Local cItemI	:= ""
Local cItemF	:= ""
Local cClVlI	:= ""
Local cClVlF	:= ""
Local cVldEnt	:= ""
Local cAlias	:= ""
Local lUFilter	:= !Empty(cUFilter)			//// SE O FILTRO DE USUÁRIO NÃO ESTIVER VAZIO - TEM FILTRO DE USUÁRIO
Local cFilMoeda	:= "" 							
Local cAliasCT2	:= "CT2"	
Local bCond		:= {||.T.}

#IFDEF TOP
	Local cQuery	:= ""
	Local cOrderBy	:= ""
	Local nI	:= 0
	Local aStru	:= {}
#ENDIF

DEFAULT cUFilter := ".T."
DEFAULT lSldAnt	 := .F.

cCustoI	:= CCUSTOINI
cCustoF := CCUSTOFIM
cContaI	:= CCONTAINI
cContaF := CCONTAFIM
cItemI	:= CITEMINI      
cItemF 	:= CITEMFIM
cClvlI	:= CCLVLINI
cClVlF 	:= CCLVLFIM

#IFDEF TOP
	If TcSrvType() != "AS/400"
		If !Empty(c2Moeda) 			
			cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' OR "		
			cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
		Else
			cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
		EndIf
	Else
#ENDIF 
	If !Empty(c2Moeda) 			
		cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' .Or. "		
		cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
	Else
		cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
	EndIf
#IFDEF TOP
	EndIf
#ENDIF 

oMeter:nTotal := CT1->(RecCount())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os d‚bitos ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTipo <> "1"
	If cTipo = "2" .And. Empty(cCustoIni)
		CTT->(DbSeek(xFilial("CTT")))
		cCustoIni := CTT->CTT_CUSTO
	Endif
	If cTipo = "3" .And. Empty(cItemIni)
		CTD->(DbSeek(xFilial("CTD")))
		cItemIni := CTD->CTD_ITEM
	Endif
	If cTipo = "4" .And. Empty(cClVlIni)
		CTH->(DbSeek(xFilial("CTH")))
		cClVlIni := CTH->CTH_CLVL
	Endif
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400"

		If cTipo == "1"
			dbSelectArea("CT2")
			dbSetOrder(2)
			cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' AND " +;
						"CT2_DEBITO<='" + cContaFim + "'"
			cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' AND " +;
						"CT2_CCD<='" + cCustoFim + "' AND " +;
						"CT2_ITEMD>='" + cItemIni + "' AND " +;
						"CT2_ITEMD<='" + cItemFim + "' AND " +;
						"CT2_CLVLDB>='" + cClVlIni + "' AND " +;
						"CT2_CLVLDB<='" + cClVlFim + "'"						
			cOrderBy:= " CT2_FILIAL, CT2_DEBITO, CT2_DATA "
		ElseIf cTipo == "2"
			dbSelectArea("CT2")
			dbSetOrder(4)
			cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'"
			cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'  AND  " +;
						"CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLDB <= '" + cClVlFim + "'" 
			cOrderBy:= " CT2_FILIAL, CT2_CCD, CT2_DATA "						
		ElseIf cTipo == "3"
			dbSelectArea("CT2")
			dbSetOrder(6)
			cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'"
			cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
						"CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLDB <= '" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_ITEMD, CT2_DATA "												
		ElseIf cTipo == "4"
			dbSelectArea("CT2")
			dbSetOrder(8)
			cValid 	:= 	"CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLDB <= '" + cClVlFim + "'"
			cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
						"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CLVLDB, CT2_DATA "												
		EndIf                                           

		cAliasCT2	:= "cAliasCT2"
		
		cQuery	:= " SELECT * "
		cQuery	+= " FROM " + RetSqlName("CT2")  
		cQuery	+= " WHERE CT2_FILIAL = '"+ xFilial("CT2") + "' AND "
		cQuery	+= cValid + " AND "
		cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
		cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
		cQuery	+= cVldEnt+ " AND " 
		cQuery	+= cFilMoeda + " AND " 
		cQuery	+= " CT2_TPSALD = '"+ cSaldo + "'"
		cQuery	+= " AND (CT2_DC = '1' OR CT2_DC = '3')"
		cQuery   += " AND CT2_VALOR <> 0 "
		cQuery	+= " AND D_E_L_E_T_ = ' ' " 
		cQuery	+= " ORDER BY "+ cOrderBy
		cQuery := ChangeQuery(cQuery)

		If ( Select ( "cAliasCT2" ) <> 0 )
			dbSelectArea ( "cAliasCT2" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next ni		

		If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
			If !Empty(cVldEnt)
				cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"				
				cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
			EndIf		
		EndIf	
		                                     
		If (!lUFilter) .or. Empty(cUFilter)
			cUFilter := ".T."
		EndIf			
		
		dbSelectArea(cAliasCT2)				
		While !Eof()
			If &cUFilter
				CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo)
				dbSelectArea(cAliasCT2)
			EndIf
			dbSkip()
		EndDo			
		
    Else    
#ENDIF    
	If cTipo == "1"
		dbSelectArea("CT2")                              
		dbSetOrder(2)
		cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' .And. " +;
					"CT2_DEBITO<='" + cContaFim + "'"
		cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' .And. " +;
					"CT2_CCD<='" + cCustoFim + "' .And. " +;
					"CT2_ITEMD>='" + cItemIni + "' .And. " +;
					"CT2_ITEMD<='" + cItemFim + "' .And. " +;
					"CT2_CLVLDB>='" + cClVlIni + "' .And. " +;
					"CT2_CLVLDB<='" + cClVlFim + "'"
		bCond 	:= { ||CT2->CT2_DEBITO >= cContaIni .And. CT2->CT2_DEBITO <= cContaFim}
	ElseIf cTipo == "2"
		dbSelectArea("CT2")
		dbSetOrder(4)
		cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'"
		cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'  .And.  " +;
					"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
	ElseIf cTipo == "3"
		dbSelectArea("CT2")
		dbSetOrder(6)
		cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
	ElseIf cTipo == "4"
		dbSelectArea("CT2")
		dbSetOrder(8)
		cValid 	:= 	"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
	EndIf
		
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
		
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO

		dbSelectArea("CT2")
		dbSetOrder(2)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DEBITO == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim
		        
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
		
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCD == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(4)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMD == CTD->CTD_ITEM}			
			dbSetOrder(6)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cCLVLIni
			bCond 	:= { || CT2->CT2_CLVLDB == CTH->CTH_CLVL}					
			dbSetOrder(8)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    			
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - DEBITOS
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
		
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf

				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	Endif
		
#IFDEF TOP
	EndIf
#ENDIF


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os creditos³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"
	dbSelectArea("CT2")
	dbSetOrder(3)
ElseIf cTipo == "2"
	dbSelectArea("CT2")
	dbSetOrder(5)
ElseIf cTipo == "3"
	dbSelectArea("CT2")
	dbSetOrder(7)
ElseIf cTipo == "4"		
	dbSelectArea("CT2")
	dbSetOrder(9)
EndIf

#IFDEF TOP
	If TcSrvType() != "AS/400"                          
		If cTipo == "1"
			cValid	:= 	"CT2_CREDIT>='" + cContaIni + "' AND " +;
						"CT2_CREDIT<='" + cContaFim + "'"
			cVldEnt :=	"CT2_CCC>='" + cCustoIni + "' AND " +;
						"CT2_CCC<='" + cCustoFim + "' AND " +;
						"CT2_ITEMC>='" + cItemIni + "' AND " +;
						"CT2_ITEMC<='" + cItemFim + "' AND " +;
						"CT2_CLVLCR>='" + cClVlIni + "' AND " +;
						"CT2_CLVLCR<='" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CREDIT, CT2_DATA "																	
		ElseIf cTipo == "2"
			cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'"
			cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'  AND  " +;
						"CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLCR <= '" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CCC, CT2_DATA "																	
		ElseIf cTipo == "3"
			cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'"
			cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
						"CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLCR <= '" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_ITEMC, CT2_DATA "																	
		ElseIf cTipo == "4"		
			cValid 	:= 	"CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLCR <= '" + cClVlFim + "'"
			cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
						"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CLVLCR, CT2_DATA "																						
		EndIf	                    
		
		cAliasCT2	:= "cAliasCT2"		
		
		cQuery	:= " SELECT * "
		cQuery	+= " FROM " + RetSqlName("CT2")  
		cQuery	+= " WHERE CT2_FILIAL = '"+ xFilial("CT2") + "' AND "
		cQuery	+= cValid + " AND "
		cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
		cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
		cQuery	+= cVldEnt+ " AND " 
		cQuery	+= cFilMoeda + " AND " 
		cQuery	+= " CT2_TPSALD = '"+ cSaldo + "' AND "  
		cQuery	+= " (CT2_DC = '2' OR CT2_DC = '3') AND "
		cQuery	+= " CT2_VALOR <> 0 AND "
		cQuery	+= " D_E_L_E_T_ = ' ' " 
		cQuery	+= " ORDER BY "+ cOrderBy
		cQuery := ChangeQuery(cQuery)

		If ( Select ( "cAliasCT2" ) <> 0 )
			dbSelectArea ( "cAliasCT2" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
		
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next ni		
		

		If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
			If !Empty(cVldEnt)
				cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"				
				cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
			EndIf		
		EndIf	
		
		If (!lUFilter) .or. Empty(cUFilter)
			cUFilter := ".T."
		EndIf			
		
		dbSelectArea(cAliasCT2)				
		While !Eof()
			If &cUFilter
				CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo)
				dbSelectArea(cAliasCT2)
		    EndIf
			dbSkip()
		EndDo			
		
	Else
#ENDIF
	bCond	:= {||.T.}

	If cTipo == "1"
		cValid	:= 	"CT2_CREDIT>='" + cContaIni + "'.And." +;
					"CT2_CREDIT<='" + cContaFim + "'"
		cVldEnt :=	"CT2_CCC>='" + cCustoIni + "'.And." +;
					"CT2_CCC<='" + cCustoFim + "'.And." +;
					"CT2_ITEMC>='" + cItemIni + "'.And." +;
					"CT2_ITEMC<='" + cItemFim + "'.And." +;
					"CT2_CLVLCR>='" + cClVlIni + "'.And." +;
					"CT2_CLVLCR<='" + cClVlFim + "'"
		bCond 	:= { ||CT2->CT2_CREDIT >= cContaIni .And. CT2->CT2_CREDIT <= cContaFim}
	ElseIf cTipo == "2"
		cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "'"
		cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "' .And. " +;
					"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
	ElseIf cTipo == "3"
		cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
	ElseIf cTipo == "4"		
		cValid 	:= 	"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
	EndIf	
	
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
	
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO
		dbSelectArea("CT2")
		dbSetOrder(3)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_CREDIT == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim

				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
	
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					If Empty(c2Moeda)			
						If CT2->CT2_MOEDLC <> cMoeda
							dbSkip()
							Loop
						EndIF
					Else
						If !(&(cFilMoeda))
							dbSkip()
							Loop
						EndIf			
					EndIf			
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo			
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCC == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(5)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMC == CTD->CTD_ITEM}			
			dbSetOrder(7)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cCLVLIni
			bCond 	:= { || CT2->CT2_CLVLCR == CTH->CTH_CLVL}					
			dbSetOrder(9)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    	
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - CREDITO
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim

				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
		
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	EndIf

#IFDEF TOP
	EndIf
#ENDIF

If lNoMov .or. lSldAnt
	If cTipo == "1"
		dbSelectArea("CT1")
		dbSetOrder(3)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CT1_FILIAL == '" + xFilial("CT1") + "' .And. CT1_CONTA >= '"+cContaI+ "' .And. CT1_CONTA <= '" +;
						cContaF + "' .And. CT1_CLASSE = '2'","....")
		cCpoChave := "CT1_CONTA"
		cTmpChave := "CONTA"
	ElseIf cTipo == "2"
		dbSelectArea("CTT")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTT_FILIAL == '" + xFilial("CTT") + "' .And. CTT_CUSTO >= '"+cCustoI+"' .And. CTT_CUSTO <= '" +;
						cCUSTOF + "' .And. CTT_CLASSE == '2'","....")
		cCpoChave := "CTT_CUSTO"
		cTmpChave := "CCUSTO"
	ElseIf ctipo == "3"
		dbSelectArea("CTD")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTD_FILIAL == '" + xFilial("CTD") + "' .And. CTD_ITEM >= '"+cItemI+"' .And. CTD_ITEM <= '" +;
						cITEMF + "' .And. CTD_CLASSE == '2'","....")
		cCpoChave := "CTD_ITEM"
		cTmpChave := "ITEM"
	ElseIf ctipo == "4"
		dbSelectArea("CTH")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTH_FILIAL == '" + xFilial("CTH") + "' .And. CTH_CLVL >= '"+cClVlI+"' .And. CTH_CLVL <= '" +;
						cCLVLF + "' .And. CTH_CLASSE == '2'","....")
		cCpoChave := "CTH_CLVL"
		cTmpChave := "CLVL"
	EndIf

	cAlias := Alias()

	While ! Eof()
		dbSelectArea("cArqTmp")
		cKey2Seek	:= &(cAlias + "->" + cCpoChave)
		If !DbSeek(cKey2Seek)
			If lNoMov		
				CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
			ElseIf cTipo == "1"		/// SOMENTE PARA O RAZAO POR CONTA
				/// TRATA OS DADOS PARA A PERGUNTA "IMPRIME CONTA SEM MOVIMENTO" = "NAO C/ SLD.ANT."
				If SaldoCT7(cKey2Seek,dDataIni,cMoeda,cSaldo,'CTBR400')[6] <> 0 .and. cArqTMP->CONTA <> cKey2Seek
					/// SE TIVER SALDO ANTERIOR E NÃO TIVER MOVIMENTO GRAVADO
					CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
				Endif
			EndIf
		Endif
		DbSelectArea(cAlias)
		DbSkip()
	EndDo

	DbSelectArea(cAlias)
	DbClearFil()
	RetIndex(cAlias)
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario - Razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvRaz(lJunta,cMoeda,cSaldo,cTipo)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Se Junta CC ou nao                                 ³±±
±±³           ³ ExpC1 = Moeda                                              ³±±
±±³           ³ ExpC2 = Tipo de saldo                                      ³±±
±±            ³ ExpC3 = Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cAliasQry = Alias com o conteudo selecionado do CT2        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvRAZ(lJunta,cMoeda,cSaldo,cTipo,c2Moeda,cAliasCT2,nTipo)

Local cConta
Local cContra
Local cCusto
Local cItem
Local cCLVL
Local cChave   	:= ""
Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.

DEFAULT cAliasCT2	:= "CT2"

If !Empty(c2Moeda)
	If cTipo == "1"
		cChave	:=	(cAliasCT2)->(CT2_DEBITO+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
	Else
    	cChave	:=	(cAliasCT2)->(CT2_CREDIT+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
 	EndIf
EndIf


If cTipo == "1"
	cConta 	:= (cAliasCT2)->CT2_DEBITO
	cContra	:= (cAliasCT2)->CT2_CREDIT
	cCusto	:= (cAliasCT2)->CT2_CCD
	cItem	:= (cAliasCT2)->CT2_ITEMD
	cCLVL	:= (cAliasCT2)->CT2_CLVLDB
EndIf	
If cTipo == "2"
	cConta 	:= (cAliasCT2)->CT2_CREDIT
	cContra := (cAliasCT2)->CT2_DEBITO
	cCusto	:= (cAliasCT2)->CT2_CCC
	cItem	:= (cAliasCT2)->CT2_ITEMC
	cCLVL	:= (cAliasCT2)->CT2_CLVLCR
EndIf		           

dbSelectArea("cArqTmp")
dbSetOrder(1)	
If !Empty(c2Moeda) 
	If MsSeek(cChave,.F.)
		Reclock("cArqTmp",.F.)
	Else
		RecLock("cArqTmp",.T.)		
	EndIf
Else
	RecLock("cArqTmp",.T.)
EndIf

Replace DATAL		With (cAliasCT2)->CT2_DATA
Replace TIPO		With cTipo
Replace LOTE		With (cAliasCT2)->CT2_LOTE
Replace SUBLOTE		With (cAliasCT2)->CT2_SBLOTE
Replace DOC			With (cAliasCT2)->CT2_DOC
Replace LINHA		With (cAliasCT2)->CT2_LINHA
Replace CONTA		With cConta

If lImpCPartida
	Replace XPARTIDA	With cContra
EndIf

Replace CCUSTO		With cCusto
Replace ITEM		With cItem
Replace CLVL		With cCLVL
Replace HISTORICO	With (cAliasCT2)->CT2_HIST
Replace EMPORI		With (cAliasCT2)->CT2_EMPORI
Replace FILORI		With (cAliasCT2)->CT2_FILORI
Replace SEQHIST		With (cAliasCT2)->CT2_SEQHIST
Replace SEQLAN		With (cAliasCT2)->CT2_SEQLAN
Replace NOMOV		With .F.							// Conta com movimento

If cPaisLoc == "CHI"
	Replace SEGOFI With (cAliasCT2)->CT2_SEGOFI// Correlativo para Chile
EndIf

If Empty(c2Moeda)	//Se nao for Razao em 2 Moedas
	If cTipo == "1"
		Replace LANCDEB	With LANCDEB + (cAliasCT2)->CT2_VALOR
	EndIf	
	If cTipo == "2"
		Replace LANCCRD	With LANCCRD + (cAliasCT2)->CT2_VALOR
	EndIf	    
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf		
Else	//Se for Razao em 2 Moedas
	If (nTipo = 1 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = cMoeda //Se Imprime Valor na Moeda ou ambos
		If cTipo == "1"
			Replace LANCDEB With (cAliasCT2)->CT2_VALOR	
		Else			
			Replace LANCCRD With (cAliasCT2)->CT2_VALOR	
		EndIf
	EndIf
    If (nTipo = 2 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = c2Moeda	//Se Imprime Moeda Corrente ou Ambas
		If cTipo == "1"
			Replace LANCDEB_1	With (cAliasCT2)->CT2_VALOR
		Else
			Replace LANCCRD_1	With (cAliasCT2)->CT2_VALOR
		Endif
	EndIf
	If LANCDEB_1 <> 0 .And. LANCDEB <> 0 
		Replace TXDEBITO  	With LANCDEB_1 / LANCDEB		
	Endif                                               
	If LANCCRD_1 <> 0 .And. LANCCRD <> 0
		Replace TXCREDITO 	With LANCCRD_1 / LANCCRD
	EndIf	
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf			
EndIf

If nTipo = 1 .And. (LANCDEB + LANCCRD) = 0
	DbDelete()
ElseIf nTipo = 2 .And. (LANCDEB_1 + LANCCRD_1) = 0
	DbDelete()
Endif
If ! Empty(c2Moeda) .And. LANCDEB + LANCDEB_1 + LANCCRD + LANCCRD_1 = 0
	DbDelete()
Endif
MsUnlock()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvNoMov ³ Autor ³ Pilar S. Albaladejo ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario sem movimento.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvNoMov(cConta)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ cConteudo = Conteudo a ser gravado no campo chave de acordo³±±
±±³           ³             com o razao impresso                           ³±±
±±³           ³ dDataL = Data para verificacao do movimento da conta       ³±±
±±³           ³ cCpoChave = Nome do campo para gravacao no temporario      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvNoMov(cConteudo,dDataL,cCpoTmp)

dbSelectArea("cArqTmp")
dbSetOrder(1)	

RecLock("cArqTmp",.T.)
Replace &(cCpoTmp)	With cConteudo
If cCpoTmp = "CONTA"
	Replace HISTORICO		With "CONTA SEM MOVIMENTO NO PERIODO"
ElseIf cCpoTmp = "CCUSTO"
	Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTT"))) + " "  + "SEM MOVIMENTO NO PERIODO"
ElseIf cCpoTmp = "ITEM"
	Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTD"))) + " "  + "SEM MOVIMENTO NO PERIODO"
ElseIf cCpoTmp = "CLVL"
	Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTH"))) + " "  + "SEM MOVIMENTO NO PERIODO"
Endif
Replace DATAL 			WITH dDataL 
MsUnlock()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³Ctr400Sint³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Imprime conta sintetica da conta do razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³Ctr400Sint( cConta,cDescSint,cMoeda,cDescConta,cCodRes	   ³±±
±±³		      |		   	 , cMoedaDesc)									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Conta Sintetic		                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpC1 = Conta                                              ³±±
±±³           ³ ExpC2 = Descricao da Conta Sintetica                       ³±±
±±³           ³ ExpC3 = Moeda                                              ³±±
±±³           ³ ExpC4 = Descricao da Conta                                 ³±±
±±³           ³ ExpC5 = Codigo reduzido                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctr400Sint(cConta,cDescSint,cMoeda,cDescConta,cCodRes,cMoedaDesc)

Local aSaveArea := GetArea()

Local nPosCT1					//Guarda a posicao no CT1
Local cContaPai	:= ""
Local cContaSint	:= ""

// seta o default da descrição da moeda para a moeda corrente
Default cMoedaDesc := cMoeda

dbSelectArea("CT1")
dbSetOrder(1)
If dbSeek(xFilial("CT1")+cConta)
	nPosCT1 	:= Recno()
	cDescConta  := &("CT1->CT1_DESC" + cMoedaDesc )

	If Empty( cDescConta )
		cDescConta  := CT1->CT1_DESC01
	Endif

	cCodRes		:= CT1->CT1_RES
	cContaPai	:= CT1->CT1_CTASUP

	If dbSeek(xFilial("CT1")+cContaPai)
		cContaSint 	:= CT1->CT1_CONTA
		cDescSint	:= &("CT1->CT1_DESC" + cMoedaDesc )

		If Empty(cDescSint)
			cDescSint := CT1->CT1_DESC01
		Endif
	EndIf	

	dbGoto(nPosCT1)
EndIf	

RestArea(aSaveArea)

Return cContaSint

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbQryRaz ³ Autor ³ Simone Mie Sato       ³ Data ³ 22/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ³±±
±±³			  ³	cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,  ³±±
±±³			  ³	cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,  ³±±
±±³			  ³	cTipo)                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				  cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				  aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)

Local aSaveArea := GetArea()
Local nMeter	:= 0
Local cQuery	:= ""
Local aTamVlr	:= TAMSX3("CT2_VALOR")     
Local lNoMovim	:= .F.
Local cContaAnt	:= ""
Local cCampUSU	:= ""
local aStrSTRU	:= {}
Local nStr		:= 0

Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.

DEFAULT lSldAnt := .F.

oMeter:SetTotal(CT2->(RecCount()))
oMeter:Set(0)

cQuery	:= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, ISNULL(CT2_CLVLDB,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "	
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN, "	
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"       
If cPaisLoc == "CHI"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf
cQuery	+= " FROM "+ RetSqlName("CT1") + " CT1 LEFT JOIN " + RetSqlName("CT2") + " CT2 "
cQuery	+= " ON CT2.CT2_FILIAL = '"+xFilial("CT2")+"' "
cQuery	+= " AND CT2.CT2_DEBITO = CT1.CT1_CONTA"  
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCD >= '" + cCustoIni + "' AND CT2.CT2_CCD <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMD >= '" + cItemIni + "' AND CT2.CT2_ITEMD <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_CLVLDB >= '" + cClvlIni + "' AND CT2.CT2_CLVLDB <= '" + cClVlFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') "
cQuery  += " AND CT2_VALOR <> 0 "
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "	
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = '' "
cQuery	+= " UNION "
cQuery	+= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, ISNULL(CT2_CLVLCR,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "	
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, "	
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"              
If cPaisLoc == "CHI"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf
cQuery	+= " FROM "+RetSqlName("CT1")+ ' CT1 LEFT JOIN '+ RetSqlName("CT2") + ' CT2 '
cQuery	+= " ON CT2.CT2_FILIAL = '"+xFilial("CT2")+"' "
cQuery	+= " AND CT2.CT2_CREDIT =  CT1.CT1_CONTA "
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCC >= '" + cCustoIni + "' AND CT2.CT2_CCC <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMC >= '" + cItemIni + "' AND CT2.CT2_ITEMC <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_CLVLCR >= '" + cClvlIni + "' AND CT2.CT2_CLVLCR <= '" + cClVlFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') "
cQuery  += " AND CT2_VALOR <> 0 "
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "	
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = ''"	            
cQuery := ChangeQuery(cQuery)		   
If Select("cArqCT2") > 0
	dbSelectArea("cArqCT2")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)
TcSetField("cArqCT2","CT2_VLR"+cMoeda,"N",aTamVlr[1],aTamVlr[2])
TcSetField("cArqCT2","DDATA","D",8,0)

If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
			TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
		EndIf
	Next
Endif
 			
dbSelectarea("cArqCT2")

dbSelectarea("cArqCT2")
If Empty(cUFilter)
	cUFilter := ".T."
Endif						

While !Eof()                                              
	If Empty(cArqCT2->DDATA) //Se nao existe movimento 
		cContaAnt	:= cArqCT2->CONTA	
		dbSkip()
		If Empty(cArqCT2->DDATA) .And. cContaAnt == cArqCT2->CONTA
			lNoMovim	:= .T.
		EndIf
	Endif        
	
	If &("cArqCT2->("+cUFilter+")")						
		If lNoMovim
			If lNoMov  
				If CtbExDtFim("CT1")							
					dbSelectArea("CT1")
					dbSetOrder(1) 
					If MsSeek(xFilial()+cArqCT2->CONTA)
						If CtbVlDtFim("CT1",dDataIni) 
							CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo 									
						EndIf												//chamada somente para o CTBR400
					EndIf				
				Else
					CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo 				
				EndIf												//chamada somente para o CTBR400
			ElseIf lSldAnt 
				If SaldoCT7(cArqCT2->CONTA,dDataIni,cMoeda,cSaldo,'CTBR400')[6] <> 0 .and. cArqTMP->CONTA <> cArqCT2->CONTA																							
					CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	
				Endif			
			EndIf
		Else
			RecLock("cArqTmp",.T.)		    	
		    Replace DATAL		With cArqCT2->DDATA
			Replace TIPO		With cArqCT2->DC
			Replace LOTE		With cArqCT2->LOTE
			Replace SUBLOTE		With cArqCT2->SUBLOTE
			Replace DOC			With cArqCT2->DOC
			Replace LINHA		With cArqCT2->LINHA
			Replace CONTA		With cArqCT2->CONTA			
			Replace CCUSTO		With cArqCT2->CUSTO
			Replace ITEM		With cArqCT2->ITEM
			Replace CLVL		With cArqCT2->CLVL
			If lImpCPartida
				Replace XPARTIDA	With cArqCT2->XPARTIDA
			EndIf		
			Replace HISTORICO	With cArqCT2->HIST
			Replace EMPORI		With cArqCT2->EMPORI
			Replace FILORI		With cArqCT2->FILORI
			Replace SEQHIST		With cArqCT2->SEQHIS
			Replace SEQLAN		With cArqCT2->SEQLAN

			If cPaisLoc == "CHI"
				Replace SEGOFI With cArqCT2->SEGOFI// Correlativo para Chile
			EndIf
	
			If cArqCT2->TIPOLAN = '1'
				Replace LANCDEB	With LANCDEB + cArqCT2->VALOR
			EndIf
			If cArqCT2->TIPOLAN = '2'
				Replace LANCCRD	With LANCCRD + cArqCT2->VALOR
			EndIf	
			MsUnlock()
		Endif         
	EndIf
	lNoMovim	:= .F.	
	dbSelectArea("cArqCT2")	
	dbSkip()
	nMeter++
	oMeter:Set(nMeter)		
Enddo	

RestArea(aSaveArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbQbPg   ºAutor  ³Marcos S. Lobo      º Data ³  12/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controla a quebra de pagina dos relatorios SIGACTB          º±±
±±º          ³quando possuem os parametros de PAG.INICAL-FINAL-REINICIAR  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro1³ lNewVars  = (.T.=Inicializa variaveis/.F.=Trata Quebra)    º±±
±±º         2³ nPagIni 	 = Pagina Inicial do relatorio.               	  º±±
±±º         3³ nPagFim 	 = Pagina Final do relatorio               	 	  º±±
±±º         4³ nReinicia = Pagina ao Reiniciar do relatorio               º±±
±±º         5³ m_pag 	 = Numero da pagina usada na Cabec()              º±±
±±º         6³ nBloco    = Bloco de paginas (intervalo de quebra)		  º±±
±±º         7³ nBlCount  = Contador de páginas (zerado na qebra de bloco) º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbQbPg(lNewVars,nPagIni,nPagFim,nReinicia,m_pag,nBloco,nBlCount)

DEFAULT lNewVars := .F.

If lNewVars					/// INICIALIZA AS VARIAVEIS
	nBloco		:= (nPagFim+1) - nPagIni				/// (PAG. FIM + 1) - PAG. INICIAL - BLOCO DE PAG. PARA IMPRESSAO
	nBlCount	:= 0
	m_pag		:= nPagIni
Else						/// NAO INICIALIZA - TRATA A QUEBRA DE PAGINA
	nBlCount++
	If nBlCount > nBloco 							/// SE A QUANTIDADE DE PAGINAS IMPRESSAO FOR IGUAL AO BLOCO DEFINIDO
		If nReinicia > nPagFim						/// SE A PAG. DE REINICIO FOR MAIOR QUE A PAGINA FINAL (ATUAL)
			nUltPg	  := m_pag						/// GUARDA A ULTIMA PAG. IMPRESSA
			m_pag 	  := nReinicia					/// REINICIA A NUMERACAO DE PAG. (m_pag atual ainda não foi)
			nPagFim   := nReinicia+nBloco 			/// DEFINE O NOVO NUMERO DA PAGINA FIM
			nReinicia := nPagFim+(nReinicia-nUltPg)	/// DEFINE A PROX. PAG. AO REINICIAR PELA DIFERENCA COM  FINAL
		Else										/// SE A PAG. DE REINICIO FOR MENOR OU IGUAL A PAGINA FINAL                                                                
			m_pag := nReinicia						/// SO REINICIA A NUMERACAO DE PAG.
		Endif
		nBlCount := 1
	EndIf	
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjCTR400MVºAutor  ³Marcos S. Lobo      º Data ³  08/30/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona opcao de Imprissao da Conta Sem Movimento com Saldoº±±
±±º          ³Adiciona opcao na pergunta 09 do grupo CTR400               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - RAZAO CONTABIL                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjCTR400MV9()
    
dbSelectArea("SX1")
dbSetOrder(1)
If !MsSeek("CTR40009",.F.)							/// SE A PERGUNTA NAO EXISTIR
	Return
EndIf

If Empty(SX1->X1_DEF03)
	RecLock("SX1",.F.)
	Field->X1_DEF03 	:= "Nao c/ Sld.Ant."
	Field->X1_DEFSPA3	:= "No c/ Sld.Ant."
	Field->X1_DEFENG3	:= "No wh Prev.Bal."
	SX1->(MsUnlock())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTR110SX1    ³Autor ³  Simone Mie Sato     ³Data³ 05/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria nova pergunta para o relatorio.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjusteSX1()

Local aSaveArea 	:= GetArea()
Local aPergs		:= {}
Local aHelpPor		:= {}
Local aHelpEng		:= {}
Local aHelpSpa		:= {}

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

// Parâmetro 31

Aadd(aHelpPor,"Informe se imprime linhas entre")			
Aadd(aHelpPor,"as contas.")

Aadd(aHelpEng,"Enter whether to print blank ")
Aadd(aHelpEng,"lines between accounts.")

Aadd(aHelpSpa,"Informe si imprime lineas en")                    
Aadd(aHelpSpa,"blanco entre las cuentas.")

Aadd(aPergs,{"Salta linha entre contas?","¨Salta linea entre cuentas?","Skip line between accounts?","mv_chx","N",1,0,1,"C",,"mv_par31","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

AjustaSx1("CTR400",aPergs)   
           

// Parâmetro 32

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe a quantidade de linhas ")			
Aadd(aHelpPor,"que serao impressas em cada pag.")
Aadd(aHelpPor,"do Razao.")

Aadd(aHelpEng,"Enter the number of rows to ")
Aadd(aHelpEng,"be printed in each Ledger ")
Aadd(aHelpEng,"page.")

Aadd(aHelpSpa,"Indique la cantidad de lineas ")
Aadd(aHelpSpa,"que imprimiran en cada pag. ")
Aadd(aHelpspa,"del Mayor.")                             

Aadd(aPergs,{"Num.linhas p/ o Razao?","¨Num.lineas p/ Mayor?","No.of rows for the Ledger?","mv_chy","N",2,0,0,"G",,"mv_par32","56","","","56","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

// Parâmetro 33 - Saldo Ant. no nivel? Conta / C.Custo / Item / Cl.Valor
aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe se deseja considerar o ")			
Aadd(aHelpPor,"saldo anterior no nivel de conta,")
Aadd(aHelpPor,"centro de custo, item ou cl.valor.")

Aadd(aHelpEng,"Enter if you wish to consider ")
Aadd(aHelpEng,"the previous balance in the ")
Aadd(aHelpEng,"account, cost center, item ")
Aadd(aHelpEng,"or value classa levels.")

Aadd(aHelpSpa,"Informe si desea considerar el")
Aadd(aHelpSpa,"saldo anterior a nivel de cuenta,")
Aadd(aHelpspa,"centro de costo, item o clase de ")
Aadd(aHelpspa,"valor.")

Aadd(aPergs,{"Sld.Ant.Nivel?","¨Salta linea entre cuentas?","Skip line between accounts?","mv_chz","N",1,0,1,"C",,"mv_par33","Conta","Cuenta","Account","","","C.Custo","C,Costo","Cost Center","","","Item","Item","Item","","","Cl.Valor","Cl.Valor","Value Class","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

AjustaSx1("CTR400",aPergs)   

// RFC - adicionado a pergunta da moeda
Aadd(aPergs,{"Descricao na Moeda?" , "¨Descripc.en Moneda?" , "Descr.in Currency?" , "mv_chw" , "C",2,0,0,"G","","mv_par34","","","","","","","","","","","","","","","","","","","","","","","","","CTO","","S",""})

AjustaSx1("CTR400",aPergs)   

RestArea(aSaveArea)

Return

