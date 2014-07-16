
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST162  ºAutor  ³João Felipe da Rosa º Data ³  18/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ APONTAMENTO DE FERRAMENTAS AVARIADAS						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"

User Function NHEST162()

Private cCadastro := "Apontamento de Ferramentas Avariadas"
Private aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_EST162(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST162(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_EST162(4)"  , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_EST162(5)"  , 0 , 5})

mBrowse(6,1,22,75,"ZDR",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST162(nParam) 
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Private lAltUsr  := .F.
Private nPar 	 := nParam  
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)

//-- variaveis de campo
Private cNum	 := Space(6)
Private dData    := CtoD("  /  /  ")
Private cCC      := Space(9)
Private cDescCC  := ""
Private cTurno   := ""
Private cPlanta  := ""
Private aHeader  := {}
Private aCols    := {}
Private aTurno   := {"1=1","2=2","3=3"}
Private aPlanta  := {"1=WHB I","2=WHB II","3=WHB III","4=WHB IV","5=WHB V"}

	aAdd(aHeader,{"Item"          , "ZDS_ITEM"    , PesqPict("ZDS","ZDS_ITEM")   , 04,00, ".F."             ,"","C","ZDS"})
	aAdd(aHeader,{"Codigo"        , "ZDS_COD"     , PesqPict("ZDS","ZDS_COD")    , 15,00, "U_EST162PRD()"   ,"","C","ZDS"})
	aAdd(aHeader,{"Descrição"     , "B1_DESC"     , PesqPict("SB1","B1_DESC")    , 50,00, ".F."             ,"","C","SB1"})
	aAdd(aHeader,{"Máquina"       , "ZDS_CODBEM"  , PesqPict("ZDS","ZDS_CODBEM") , 15,00, "U_EST162BEM()"   ,"","C","ZDS"})
	aAdd(aHeader,{"Desc. Máquina" , "T9_NOME"     , PesqPict("ST9","T9_NOME")    , 50,00, ".T."             ,"","C","ST9"})
	aAdd(aHeader,{"Matrícula"     , "ZDS_MAT"     , PesqPict("ZDS","ZDS_MAT")    , 06,00, "U_EST162MAT()"   ,"","C","ZDS"})
	aAdd(aHeader,{"Nome"          , "QAA_NOME"    , PesqPict("QAA","QAA_NOME")   , 40,00, ".F."             ,"","C","QAA"})
	aAdd(aHeader,{"Motivo"        , "ZDS_CODMOT"  , PesqPict("ZDS","ZDS_CODMOT") , 15,00, "U_EST162MOT()"   ,"","C","ZDS"})	
	aAdd(aHeader,{"Desc. Motivo"  , "ZDT_DESC"    , PesqPict("ZDT","ZDT_DESC")   , 50,00, ".F."             ,"","C","ZDT"})	
	aAdd(aHeader,{"Setor Respons.", "ZDT_RESP"    , PesqPict("ZDT","ZDT_RESP")   , 20,00, ".F."             ,"","C","ZDT"})
	aAdd(aHeader,{"Nº Fuso"       , "ZDS_NFUSO"   , PesqPict("ZDS","ZDS_NFUSO")  , 02,00, ".T."             ,"","N","ZDS"})
	aAdd(aHeader,{"Quant"         , "ZDS_QUANT"   , PesqPict("ZDS","ZDS_QUANT")  , 02,00, "U_EST16CLC()"    ,"","N","ZDS"})
	aAdd(aHeader,{"Reafiavel"     , "ZDS_REAFI"   , PesqPict("ZDS","ZDS_REAFI")  , 01,00, "U_EST16CLC()"    ,"","C","ZDS"})
	aAdd(aHeader,{"Nº Afiação"    , "ZDS_NAFIAC"  , PesqPict("ZDS","ZDS_NAFIAC") , 02,00, "U_EST16CLC()"    ,"","N","ZDS"})
	aAdd(aHeader,{"Vlr. Unit."    , "ZDS_VUNIT"   , PesqPict("ZDS","ZDS_VUNIT")  , 08,02, ".F."             ,"","N","ZDS"})
	aAdd(aHeader,{"V.U. Estim."   , "ZDS_VUEST"   , PesqPict("ZDS","ZDS_VUEST")  , 04,00, "U_EST16CLC()"    ,"","N","ZDS"})
	aAdd(aHeader,{"V.U. Real"     , "ZDS_VUREAL"  , PesqPict("ZDS","ZDS_VUREAL") , 04,00, "U_EST16CLC()"    ,"","N","ZDS"})
	aAdd(aHeader,{"Total Avaria"  , "B1_UPRC"     , PesqPict("SB1","B1_UPRC")    , 08,02, ".F."             ,"","N","SB1"})
	aAdd(aHeader,{"% Avaria"      , "B2_COD"      , PesqPict("SB2","B2_COD")     , 10,02, ".F."             ,"","C","SB2"})
	
	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		cNum  := GetSxENum("ZDR","ZDR_NUM")
		dData := Date()
		bOk   := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	EndIf

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Apontamento de Ferramentas Avariadas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Número"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||cNum},oDlg,,oFont1,,,,.T.,,)
	
	oSay2 := TSay():New(20,160,{||"Data"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(18,200,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4},,,,,,,"dData")

	oSay3 := TSay():New(31,10,{||"Turno"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(29,50,{|u| if(Pcount() > 0,cTurno := u,cTurno)},;
		aTurno,30,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cTurno")

	oSay4 := TSay():New(31,160,{||"Planta"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(29,200,{|u| if(Pcount() > 0,cPlanta := u,cPlanta)},;
		aPlanta,40,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cPlanta")

	oSay5 := TSay():New(42,10,{||"C. Custo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(40,50,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,50,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4},,,,,,"CTT","cCC")

	oSay5 := TSay():New(42,160,{||"Desc C.C."},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(40,200,{|u| if(Pcount() > 0, cDescCC := u,cDescCC)},oDlg,200,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescCC")
              
	DBSELECTAREA("ZDS")
	
    // cria o getDados
	oGeTD := MsGetDados():New( 53               ,; //superior
	                           aPosObj[2,2]     ,; //esquerda
	                           aPosObj[2,3]     ,; //inferior
	                           aPosObj[2,4]     ,; //direita
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .T.              ,; // LDELETA
	                           nil              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           200              ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd
	                          )

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA O PREJUIZO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST16CLC()

//-- variaveis de posicao iniciadas por nPos
Local nPosReaf := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_REAFI"})
Local nPosQtde := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_QUANT"})
Local nPosNAfi := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_NAFIAC"})
Local nPosVUni := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_VUNIT"})
Local nPosVUEs := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_VUEST"})
Local nPosVURe := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_VUREAL"})
Local nPosVTot := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_UPRC"})
Local nPosPerc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B2_COD"})

Local nCol     := oGetD:OBrowse:ColPos//retorna a coluna em que o cursor está focando

//-- reafiavel s / n
Local cReaf := Substr(aCols[n][nPosReaf],1,1)

//-- valor unitário da ferramenta que vem do B1_UPRC
Local nVUnit := aCols[n][nPosVUni]

//-- quantidade de ferramentas que sofreram avaria
Local nQuant := aCols[n][nPosQtde]

//-- se o número de reafiações for maior que 5
//-- consideramos sempre 5 como o número de reafiações
Local nReafi := Iif(aCols[n][nPosNAfi]>5,5,aCols[n][nPosNAfi])

//-- vida útil estimada da ferramenta
Local nVUEst := aCols[n][nPosVUEs]

//-- vida útil realizado pela ferramenta até sofrer a avaria
Local nVUReal := aCols[n][nPosVURe]

If cReaf=="N" //reafiavel = nao
	aCols[n][nPosNAfi] := 0
	oGetD:Refresh()
EndIf


If nCol==nPosVUni
	nVUnit := M->ZDS_VUNIT
ElseIf nCol==nPosQtde
	nQuant := M->ZDS_QUANT
ElseIf nCol==nPosNAfi
	
	If cReaf=="N" //reafiavel = nao
		Return .F.
	EndIf

	nReafi := Iif(M->ZDS_NAFIAC>5,5,M->ZDS_NAFIAC)	
	
ElseIf nCol==nPosVUEs
	nVUEst := M->ZDS_VUEST
ElseIf nCol==nPosVURe
	nVUReal := M->ZDS_VUREAL
	
	If M->ZDS_VUREAL > nVUEst
		Alert("Valor Real não pode ser maior que o estimado!")
		Return .F.
	EndIf
	
ElseIf nCol==nPosReaf
	aCols[n][nPosNAfi] := 0
	oGetD:Refresh()
EndIf
	
	aPrej = CalcPrej(cReaf,nReafi,nVUnit,nQuant,nVUEst,nVUReal)
	
	aCols[n][nPosVTot] := aPrej[1]
	aCols[n][nPosPerc] := Transform(aPrej[2],"@e 999.99") + "%"
	oGetD:Refresh()

Return .T.

Static Function CalcPrej(cReaf,nReafi,nVUnit,nQuant,nVUEst,nVUReal)
Local nValorRe := 0 //-- valor realizado
Local nValorEs := 0 //-- valor estimado
Local nPerc    := 0 //-- percentual
Local nProdEs  := 0 //-- quant de peças produzidas estimado
Local nProdRe  := 0 //-- quant de peças produzidas real

	If Empty(nVUnit) .or. Empty(nQuant) .or. Empty(nVUEst) .or. Empty(nVUReal)
	   	Return {0,0}
	EndIf

	If cReaf=="S" //Reafiável = sim
		nProdEs := 5 * nVUEst
		nProdRe	:= (nReafi * nVUEst) + nVUReal
	Else
		nProdEs := nVUEst
		nProdRe := nVUReal
	EndIf
	
	nProdRe := Iif(nProdRe > nProdEs, nProdEs, nProdRe)
		
	nValorRe := (nVUnit / nProdEs) * nProdRe
	nValorRe *= nQuant //multiplica pela quantidade de ferramentas avariadas
	
	nValorEs := nQuant * nVUnit

	nValorRe := nValorEs - nValorRe

	nPerc := (nValorRe / nValorEs) * 100 

Return {nValorRe,nPerc}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO MOTIVO E TRAZ A DESCRICAO E O RESPONSAVEL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST162MAT()
Local nNome := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "QAA_NOME"})

	If !Empty(M->ZDS_MAT)
		QAA->(dbSetOrder(1)) // FILIAL + MAT
		If QAA->(dbSeek(xFilial("QAA")+M->ZDS_MAT))
			aCols[n][nNome] := QAA->QAA_NOME
			oGetD:Refresh()
		Else
			Alert("Matricula não encontrada!")
			return .F.
		EndIf
	EndIf		

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO MOTIVO E TRAZ A DESCRICAO E O RESPONSAVEL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST162MOT()
Local nDescMot := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDT_DESC"})
Local nRespMot := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDT_RESP"})

	ZDT->(dbSetOrder(1)) // FILIAL + CODIGO
	If !ZDT->(dbSeek(xFilial("ZDT")+M->ZDS_CODMOT))
		Alert("Código do motivo não encontrado!")
		Return .F.
	Else
		aCols[n][nDescMot] := ZDT->ZDT_DESC
		aCols[n][nRespMot] := ZDT->ZDT_RESP
		oGetD:Refresh()
	EndIf

Return .T.
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A MÁQUINA E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST162BEM()
Local nDescBem := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "T9_NOME"})

	ST9->(dbSetOrder(1)) // FILIAL + COD
	If ST9->(dbSeek(xFilial("ST9")+M->ZDS_CODBEM))
		aCols[n][nDescBem] := ST9->T9_NOME
		oGetD:Refresh()
//	Else
//		Alert("Máquina não encontrada!")
//		Return .f.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O PRODUTO E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST162PRD()
Local nDescCod := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_DESC"})
Local nVUnit := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_VUNIT"})
Local aArea := GetArea();

	SB1->(dbSetOrder(1)) 
	If SB1->(dbSeek(xFilial("SB1")+M->ZDS_COD))
		aCols[n][nDescCod] := SB1->B1_DESC
		
		beginSql Alias "TMP"
			SELECT TOP 1 D1_CUSTO, D1_QUANT
			FROM %Table:SD1% D1
			WHERE D1_COD = %Exp:M->ZDS_COD%
			AND D_E_L_E_T_ = %Exp:''% 
			AND D1_QUANT <> 0
			ORDER BY R_E_C_N_O_ DESC
		endSql

		If TMP->(!EOF())
			aCols[n][nVUnit] := TMP->D1_CUSTO / TMP->D1_QUANT
			oGetD:Refresh()
		EndIf
		
	Else
		Alert("Produto não encontrado!")
		Return .f.
	EndIf
	
  	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	RestArea(aArea)
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ valida o centro de custo e traz a descricao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCC() 

	If !empty(cCC)
		CTT->(dbSetOrder(1)) // FILIAL + CC
		If CTT->(dbSeek(xFilial("CTT")+cCC))
			cDescCC := CTT->CTT_DESC01
			oGet3:Refresh()
		Else
			Alert("C.Custo não encontrado!")
			Return .F.
		EndIf
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()
Local lVazio 
Local nCod := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDS_COD"}) 

	If Empty(cCC)
		alert("Informe o Centro de Custo!")
		return .f.
	EndIf
	
	IF Empty(cTurno)
		Alert("Informe o turno!")
		Return .F.
	EndIf
	
	If Empty(cPlanta)
		Alert("Informe a Planta!")
		REturn .F.
	EndIf
	
	If Empty(dData)
		Alert("Informe a data!")
		return .F.
	EndIf
	
	lVazio := .T.
	
	For x:=1 to Len(aCols)
		If !Empty(aCols[x][nCod])
			lVazio := .F.
		EndIf
	Next
	
	If lVazio
		Alert("Informe pelo menos um ítem!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()
	
	If !fValida()
		Return
	EndIf
	
	RecLock("ZDR",.T.)
		ZDR->ZDR_FILIAL := xFilial("ZDR")
		ZDR->ZDR_NUM    := cNum
		ZDR->ZDR_DATA   := dData
		ZDR->ZDR_TURNO  := cTurno
		ZDR->ZDR_PLANTA := cPlanta
		ZDR->ZDR_CC     := cCC
	MsUnlock("ZDR")	
	
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] // nao pega quanod estiver deletado

			RecLock("ZDS",.T.)
				ZDS->ZDS_FILIAL := xFilial("ZDS")
				ZDS->ZDS_NUM    := cNum
				ZDS->ZDS_ITEM   := aCols[x][1]
				ZDS->ZDS_COD    := aCols[x][2]
				ZDS->ZDS_CODBEM := aCols[x][4]
				ZDS->ZDS_MAT    := aCols[x][6]
				ZDS->ZDS_CODMOT := aCols[x][8]
				ZDS->ZDS_NFUSO  := aCols[x][11]
				ZDS->ZDS_QUANT  := aCols[x][12]
				ZDS->ZDS_REAFI  := aCols[x][13]
				ZDS->ZDS_NAFIAC := aCols[x][14]
				ZDS->ZDS_VUNIT  := aCols[x][15]
				ZDS->ZDS_VUEST  := aCols[x][16]
				ZDS->ZDS_VUREAL := aCols[x][17]
			MsUnlock("ZDS")

		EndIf
	Next
	ConfirmSx8()
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	ZDR->(dbSetOrder(1)) 
	ZDR->(dbSeek(xFilial("ZDR")+cNum))

	RecLock("ZDR",.F.)
		ZDR->ZDR_DATA   := dData
		ZDR->ZDR_TURNO  := cTurno
		ZDR->ZDR_PLANTA := cPlanta
		ZDR->ZDR_CC     := cCC
	MsUnlock("ZDR")	
	
	ZDS->(dbSetOrder(1)) // FILIAL + NUM + ITEM
	
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] // nao pega quanod estiver deletado
		
			If ZDS->(dbSeek(xFilial("ZDS")+cNum+aCols[x][1]))
				RecLock("ZDS",.f.)
					ZDS->ZDS_COD    := aCols[x][2]
					ZDS->ZDS_CODBEM := aCols[x][4]
					ZDS->ZDS_MAT    := aCols[x][6]
					ZDS->ZDS_CODMOT := aCols[x][8]
					ZDS->ZDS_NFUSO  := aCols[x][11]
					ZDS->ZDS_QUANT  := aCols[x][12]
					ZDS->ZDS_REAFI  := aCols[x][13]
					ZDS->ZDS_NAFIAC := aCols[x][14]
					ZDS->ZDS_VUNIT  := aCols[x][15]
					ZDS->ZDS_VUEST  := aCols[x][16]
					ZDS->ZDS_VUREAL := aCols[x][17]
				MsUnlock("ZDS")
			ELSE
				RecLock("ZDS",.T.)
					ZDS->ZDS_FILIAL := xFilial("ZDS")
					ZDS->ZDS_NUM    := cNum
					ZDS->ZDS_ITEM   := aCols[x][1]
					ZDS->ZDS_COD    := aCols[x][2]
					ZDS->ZDS_CODBEM := aCols[x][4]
					ZDS->ZDS_MAT    := aCols[x][6]
					ZDS->ZDS_CODMOT := aCols[x][8]
					ZDS->ZDS_NFUSO  := aCols[x][11]
					ZDS->ZDS_QUANT  := aCols[x][12]
					ZDS->ZDS_REAFI  := aCols[x][13]
					ZDS->ZDS_NAFIAC := aCols[x][14]
					ZDS->ZDS_VUNIT  := aCols[x][15]
					ZDS->ZDS_VUEST  := aCols[x][16]
					ZDS->ZDS_VUREAL := aCols[x][17]
				MsUnlock("ZDS")
			EndIf
		Else
			If ZDS->(dbSeek(xFilial("ZDS")+cNum+aCols[x][1]))
				RecLock("ZDS",.F.)
					ZDS->(dbDelete())
				MsUnlock("ZDS")
			EndIf
		EndIf
	Next

	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")

		//-- deleta o cabecalho
		ZDR->(dbSetOrder(1)) // FILIAL + NUM
		ZDR->(dbSeek(xFilial("ZDR")+cNum))
		RecLock("ZDR",.F.)
			ZDR->(dbDelete())
		MsUnlock("ZDR")	
		
		//-- deleta os itens
		ZDS->(dbSetOrder(1)) // FILIAL + NUM + ITEM
		ZDS->(dbSeek(xFilial("ZDS")+cNum))
		WHILE ZDS->(!EOF()) .AND. ZDS->ZDS_NUM==cNum
			RecLock("ZDS",.F.)
				ZDS->(dbDelete())
			MsUnlock("ZDS")

			ZDS->(dbSkip())
		ENDDO
	
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
Local aPrej := {}

	cNum    :=	ZDR->ZDR_NUM
	dData   := ZDR->ZDR_DATA
	cTurno  := ZDR->ZDR_TURNO
	cPlanta := ZDR->ZDR_PLANTA
	cCC     := ZDR->ZDR_CC
	
	CTT->(dbSetOrder(1)) // FILIAL + CC
	CTT->(dbSeek(xFilial("CTT")+cCC))
	
	cDescCC := CTT->CTT_DESC01
	    
	SB1->(dbSetOrder(1)) // FILIAL + COD
	ST9->(dbSetOrder(1)) // FILIAL + CODBEM
	QAA->(dbSetOrder(1)) // FILIAL + MAT
	ZDT->(dbSetOrder(1)) // FILIAL + NUM
	
	ZDS->(dbSetOrder(1)) // FILIAL + NUM + ITEM
	ZDS->(dbSeek(xFilial("ZDS")+cNum))
              
	

	WHILE ZDS->(!EOF()) .AND. ZDS->ZDS_NUM==cNum
		SB1->(dbSeek(xFilial("SB1")+ZDS->ZDS_COD))
		ST9->(dbSeek(xFilial("ST9")+ZDS->ZDS_CODBEM))
		QAA->(dbSeek(xFilial("QAA")+ZDS->ZDS_MAT))
		ZDT->(dbSeek(xFilial("ZDT")+ZDS->ZDS_CODMOT))
		
		aPrej := CalcPrej(ZDS->ZDS_REAFI,;
						  Iif(ZDS->ZDS_NAFIAC>5,5,ZDS->ZDS_NAFIAC),;
						  ZDS->ZDS_VUNIT,;
						  ZDS->ZDS_QUANT,;
						  ZDS->ZDS_VUEST,;
						  ZDS->ZDS_VUREAL)
		
		aAdd(aCols,{ZDS->ZDS_ITEM,;
					ZDS->ZDS_COD,;
					SB1->B1_DESC,;
					ZDS->ZDS_CODBEM,;
					ST9->T9_NOME,;
					ZDS->ZDS_MAT,;
					If(QAA->(found()),QAA->QAA_NOME,""),;
					ZDS->ZDS_CODMOT,;
					ZDT->ZDT_DESC,;
					ZDT->ZDT_RESP,;
					ZDS->ZDS_NFUSO,;
					ZDS->ZDS_QUANT,;
					ZDS->ZDS_REAFI,;
					ZDS->ZDS_NAFIAC,;
					ZDS->ZDS_VUNIT,;
					ZDS->ZDS_VUEST,;
					ZDS->ZDS_VUREAL,;
					aPrej[1],;
					Transform(aPrej[2],"@e 999.99") + "%",;
					.F.})					

		ZDS->(dbSkip())
	ENDDO

Return