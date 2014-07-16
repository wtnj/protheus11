/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! FIN - Financeiro                                              !
+------------------+---------------------------------------------------------------+
!Nome              ! NHFAT031.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Controle  de débitos aos fornecedores                         +
+------------------+---------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                           !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 25/02/2010                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
! Melhorias para exibição no grid           !Gustavocr      !Edenilsonas!03/02/2014!
+-------------------------------------------+---------------+-----------+----------+
*/

#include "rwmake.ch"
#INCLUDE "protheus.ch"   
#include "colors.ch"

User Function NHFAT031()

Private aRotina, cCadastro

cCadastro := "Débitos aos Fornecedores"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"     ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	,"U_FAT031(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_FAT031(3)" 	, 0 , 3})
aAdd(aRotina,{ "Imprimir"     ,"U_NHFAT032()" , 0 , 4})
//aAdd(aRotina,{ "Alterar"      ,"U_FAT031(4)"  , 0 , 4})
//aAdd(aRotina,{ "Excluir"      ,"U_FAT031(5)"  , 0 , 5})
aAdd(aRotina,{ "Legenda"		,"U_FAT31LEG()"	, 0 , 3})

Processa({||fAtualiza()},"Aguarde, atualizando débitos...")

mBrowse(6,1,22,75,"ZDM",,,,,,fCriaCor())

Return     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ atualiza os debitos em abertos que podem estar baixados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAtualiza()
Local nRecZDM := ZDM->(Recno())
 	
 	ZDM->(dbGoTop())
 	//SET FILTER TO ZDM->ZDM_STATUS=="A"
 	
 	While ZDM->(!EOF())// .AND. ZDM->ZDM_STATUS=="A"
		
// 		dBaixa := Posicione("SE1",2,xFilial("SE1")+ZDM->ZDM_CLI+ ZDM->ZDM_LOJCLI+ ZDM->ZDM_SERIE+ ZDM->ZDM_DOC,"E1_BAIXA")

		DbSelectAr("SE1")
		SE1->(DbSetOrder(2))
		If SE1->(DbSeek(xFilial("SE1")+ZDM->ZDM_CLI+ ZDM->ZDM_LOJCLI+ ZDM->ZDM_SERIE+ ZDM->ZDM_DOC))
// 		If !empty(dBaixa)
 		If !empty(SE1->E1_BAIXA)
 			RecLock("ZDM",.F.)
 				ZDM->ZDM_STATUS := 'E'
 			MsUnlock("ZDM")
 		Else
 			RecLock("ZDM",.F.)
 				ZDM->ZDM_STATUS := 'A'
 			MsUnlock("ZDM")
 		EndIF
 		ElseIf !SE1->(DbSeek(xFilial("SE1")+ZDM->ZDM_CLI+ ZDM->ZDM_LOJCLI+ ZDM->ZDM_SERIE+ ZDM->ZDM_DOC))
 			RecLock("ZDM",.F.)
 				ZDM->ZDM_STATUS := 'N'
 			MsUnlock("ZDM")
 		Endif
		ZDM->(dbSkip()) 	
 	EndDo

//	SET FILTER TO
	ZDM->(dbGoTo(nRecZDM))
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function FAT031(nParam) 
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam  
Private aSize     := MsAdvSize()

Private cNum, cCli, cLojCli, dDtDigi, dDtEmis, dDtVenc, cNf, cSerie, ;
		cDesFor   := ""        , ;
		cDCC      := ""        , ;
		cForn     := Space(6)  , ;
		cLojFor   := Space(2)  , ;
		cNFOri    := Space(9)  , ;
		cSerOri   := Space(3)  , ;
		cSolic    := Space(40) , ;
		cMotivo   := Space(200), ;
		cMotivo2  := Space(200), ;
		cCC       := Space(9)

	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		cNum     := GetSxENum("ZDM","ZDM_NUM")
		cCli     := SF2->F2_CLIENTE
		cLojCli  := SF2->F2_LOJA
		cNf      := SF2->F2_DOC
		cSerie   := SF2->F2_SERIE
		dDtEmis  := SF2->F2_EMISSAO
		
		dDtDigi := Date()
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
/*	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
*/	EndIf

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Débito ao Fornecedor",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Número"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||cNum},oDlg,,oFont1,,,,.T.,,)
	
	oSay1 := TSay():New(20,160,{||"Data"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,200,{||dDtDigi},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(32,10,{||"Cliente:"},oDlg,,,,,,.T.,,)
	oSay4 := TSay():New(32,50,{||cCli+" - "+cLojCli+" - "+Posicione("SA1",1,xFilial("SA1")+cCli+cLojCli,"A1_NOME")},oDlg,,oFont1,,,,.T.,,)

	oSay5 := TSay():New(44,10,{||"Nota Fiscal:"},oDlg,,,,,,.T.,,)
	oSay6 := TSay():New(42,50,{||cNF+" - "+cSerie},oDlg,,oFont1,,,,.T.,,)

	oSay7 := TSay():New(56,10,{||"Emissão:"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(54,50,{|u| if(Pcount() > 0, dDtEmis := u,dDtEmis)},oDlg,35,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"dDtEmis")

	oSay8 := TSay():New(56,160,{||"Vencimento:"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(54,200,{|u| if(Pcount() > 0, dDtVenc := u,dDtVenc)},oDlg,35,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"dDtVenc")

	oSay5 := TSay():New(68,10,{||"NF. Origem"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet5 := tGet():New(66,50,{|u| if(Pcount() > 0, cNFOri := u,cNFOri)},oDlg,40,8,"@!",{||fValNF()},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,"SDN","cNFOri")
	
	oSay6 := TSay():New(68,160,{||"Serie Origem"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet6 := tGet():New(66,200,{|u| if(Pcount() > 0, cSerOri := u,cSerOri)},oDlg,15,8,"@!",{||fValSerie()},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,,"cSerOri")

	oSay7 := TSay():New(80,10,{||"Fornecedor"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet7 := tGet():New(78,50,{|u| if(Pcount() > 0, cForn := u,cForn)},oDlg,40,8,"@!",{||fValForn()},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,"SA2","cForn")
	
	oSay8 := TSay():New(80,160,{||"Loja"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet8 := tGet():New(78,200,{|u| if(Pcount() > 0, cLojFor := u,cLojFor)},oDlg,15,8,"@!",{||fValLoja()},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,,"cLojFor")

	oSay9 := TSay():New(92,10,{||"Nome Forn."},oDlg,,,,,,.T.,,)
	oGet9 := tGet():New(90,50,{|u| if(Pcount() > 0, cDesFor := u,cDesFor)},oDlg,140,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"cDesFor")

	oSay10 := TSay():New(104,10,{||"Solicitante"},oDlg,,,,,,.T.,,)
	oGet10 := tGet():New(102,50,{|u| if(Pcount() > 0, cSolic := u,cSolic)},oDlg,140,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,,"cSolic")

	oSay11 := TSay():New(116,10,{||"C.Custo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet11 := tGet():New(114,50,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,50,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,"CTT","cCC")

	oGet12 := tGet():New(114,105,{|u| if(Pcount() > 0, cDCC := u,cDCC)},oDlg,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"cDCC")

	oSay12 := TSay():New(128,10,{||"Motivo"},oDlg,,,,,,.T.,,)
	oGet13 := tGet():New(126,50,{|u| if(Pcount() > 0, cMotivo := u,cMotivo)},oDlg,240,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,,"cMotivo")

	oSay13 := TSay():New(140,10,{||"Motivo"},oDlg,,,,,,.T.,,)
	oGet14 := tGet():New(138,50,{|u| if(Pcount() > 0, cMotivo2 := u,cMotivo2)},oDlg,240,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| nPar==3 },,,,,,,"cMotivo2")
		
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Static Function fValCC(lAlert)

Default lAlert := .T.

	CTT->(dbSetOrder(1)) //FILIAL + CC
	If !CTT->(dbSeek(xFilial("CTT")+cCC))
		If lAlert
			Alert("C.Custo não existe!")
			Return .F.
		EndIf
	Else
		cDCC := CTT->CTT_DESC01
		If lAlert
			oGet12:Refresh()
		EndIf
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()
	
	If Empty(cCC)
		Alert("Informe o Centro de Custo!")
		Return .F.
	EndIf

	If Empty(cNfOri) .or. Empty(cSerOri)
		Alert("Nota Fiscal de Origem ou Serie de Origem não informadas!")
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
	 
/* removido pelo chamado 012442

	// a pagar      
	SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If SE2->(dbSeek(xFilial("SE2")+cForn+cLojFor+cSerOri+cNFOri))
		If !Empty(SE2->E2_BAIXA)

			If !MsgYesNo( "O titulo a pagar já se encontra baixado total ou parcialmente! Verifique no financeiro!"+ CHR(13)+CHR(10) +; 
				         "Deseja continuar assim mesmo?")
				Return
			EndIf
		EndIf
	EndIf
*/			

	RecLock("ZDM",.T.)
		ZDM->ZDM_FILIAL := xFilial("ZDM")
		ZDM->ZDM_NUM    := cNum
		ZDM->ZDM_DOC    := cNf
		ZDM->ZDM_SERIE  := cSerie
		ZDM->ZDM_CLI    := cCli
		ZDM->ZDM_LOJCLI := cLojCli 
		ZDM->ZDM_DOCORI := cNfOri
		ZDM->ZDM_SERORI := cSerOri
		ZDM->ZDM_FORNEC := cForn
		ZDM->ZDM_LOJFOR := cLojFor
		ZDM->ZDM_SOLIC  := cSolic
		ZDM->ZDM_CC     := cCC
		ZDM->ZDM_MOTIVO := cMotivo
		ZDM->ZDM_MOTIV2 := cMotivo2
		ZDM->ZDM_DTDIGI := dDtDigi
		ZDM->ZDM_STATUS := "A"
	MsUnlock("ZDM")
	
	//removido pelo chamado 012442
	// fCompCart() 
	
	ConfirmSx8()
	
	If MsgYesNo("Deseja imprimir?")
		U_NHFAT032(cNum)
	EndIf
	
	oDlg:End()

Return

/**
 * Gera a compensação da carteira
 */
//removido pelo chamado 012442
/*
Static function fCompCart()
	
Local cNumComp := Soma1(GetMv("MV_NUMCOMP"),6)
Local cMarca   := GetMark()
	
	SE1->(dbSetOrder(2))
	If SE1->(dbSeek(xFilial("SE1")+cCli+cLojCli+cSerie+cNF))
		
		RecLock("SE1",.F.)
			SE1->E1_IDENTEE := cNumComp
//			SE1->E1_LA      := "S"
			SE1->E1_SALDO   := 0
			SE1->E1_BAIXA   := dDataBase
			SE1->E1_MOVIMEN := dDataBase
			SE1->E1_VALLIQ  := SE1->E1_VALOR
			SE1->E1_STATUS  := 'B'
			SE1->E1_OK      := cMarca
		MsUnlock("SE1")
	
		// GRAVA MOVIMENTACAO BANCARIA NA SE5
		Reclock( "SE5" , .T. )
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_DATA    := dDataBase
			SE5->E5_TIPO    := SE1->E1_TIPO
			SE5->E5_MOEDA   := "01" 
			SE5->E5_VALOR   := SF2->F2_VALBRUT
			SE5->E5_NATUREZ := SE1->E1_NATUREZ
			SE5->E5_RECPAG  := "R"
			SE5->E5_BENEF   := SE1->E1_NOMCLI
			SE5->E5_HISTOR  := "Valor recebido por compensacao"
			SE5->E5_TIPODOC := "BA"
			SE5->E5_VLMOED2 := SF2->F2_VALBRUT
//			SE5->E5_LA      := "S"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := SE1->E1_NUM
			SE5->E5_CLIFOR  := SE1->E1_CLIENTE
			SE5->E5_LOJA    := SE1->E1_LOJA
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_MOTBX   := "CEC" 
			SE5->E5_SEQ     := "01"
			SE5->E5_DTDISPO := dDataBase
			SE5->E5_IDENTEE := cNumComp
			SE5->E5_FILORIG := xFilial("SE1")   
			SE5->E5_SITCOB  := SE1->E1_SITUACA
			SE5->E5_CLIENTE := SE1->E1_CLIENTE
			SE5->E5_VRETISS := SE1->E1_VRETISS
			SE5->E5_VRETIRF := SE1->E1_VRETIRF
			
		MsUnlock("SE5")
	
    EndIf

	SF2->(dbSetOrder(1))
	SF2->(dbSeek(xFilial("SF2")+cNf+cSerie+cCli+cLojCli))
	
	//GRAVA TA TABELA DE TITULOS A PAGAR UMA OBSERVACAO QUE EXISTE DEBITO PARA O FORNECEDOR
	SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If SE2->(dbSeek(xFilial("SE2")+cForn+cLojFor+cSerOri+cNFOri))

		If !Empty(SE2->E2_BAIXA)
			Alert("O titulo a pagar já se encontra baixado total ou parcialmente! Verifique no financeiro!")
			Return
		EndIf

		RecLock("SE2",.F.)
			SE2->E2_OBS     := ALLTRIM(SE2->E2_OBS) + 'ND ' + cNF + "-" + cSerie + " R$ " + ALLTRIM(STR(SF2->F2_VALBRUT))
			SE2->E2_SALDO   := SE2->E2_SALDO - SF2->F2_VALBRUT
			SE2->E2_IDENTEE := cNumComp
//			SE2->E2_LA      := "S"
			SE2->E2_BAIXA   := dDataBase
			SE2->E2_VALLIQ  := SF2->F2_VALBRUT
		MsUnlock("SE2")

		// GRAVA MOVIMENTACAO BANCARIA NA SE5
		Reclock( "SE5" , .T. )
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_DATA    := dDataBase
			SE5->E5_TIPO    := SE2->E2_TIPO
			SE5->E5_MOEDA   := "01" 
			SE5->E5_VALOR   := SF2->F2_VALBRUT
			SE5->E5_NATUREZ := SE2->E2_NATUREZ
			SE5->E5_RECPAG  := "P"
			SE5->E5_BENEF   := SE2->E2_NOMFOR
			SE5->E5_HISTOR  := "Valor pago por compensacao"
			SE5->E5_TIPODOC := "BA"
			SE5->E5_VLMOED2 := SF2->F2_VALBRUT
//			SE5->E5_LA      := "S"
			SE5->E5_PREFIXO := SE2->E2_PREFIXO
			SE5->E5_NUMERO  := SE2->E2_NUM
			SE5->E5_CLIFOR  := SE2->E2_FORNECE
			SE5->E5_LOJA    := SE2->E2_LOJA
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_MOTBX   := "CEC" 
			SE5->E5_SEQ     := "01"
			SE5->E5_DTDISPO := dDataBase
			SE5->E5_IDENTEE := cNumComp
			SE5->E5_FILORIG := xFilial("SE2")
			SE5->E5_FORNECE := SE2->E2_FORNECE   
			SE5->E5_VRETPIS := SE2->E2_VRETPIS
			SE5->E5_VRETCOF := SE2->E2_VRETCOF
			SE5->E5_VRETISS := SE2->E2_VRETISS
			SE5->E5_VRETCSL := SE2->E2_VRETCSL
			SE5->E5_VRETIRF := SE2->E2_VRETIRF
			SE5->E5_PRETCOF := SE2->E2_PRETCOF
			SE5->E5_PRETCSL := SE2->E2_PRETCSL
			SE5->E5_PRETIRF := SE2->E2_PRETIRF
			SE5->E5_PRETPIS := SE2->E2_PRETPIS

		MsUnlock("SE5")

	EndIf
    
Return 
*/


/*
//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")
	
	EndIf	
	
	oDlg:End()

Return
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()

	cNum     := ZDM->ZDM_NUM
	cNf      := ZDM->ZDM_DOC
	cSerie   := ZDM->ZDM_SERIE
	cCli     := ZDM->ZDM_CLI
	cLojCli  := ZDM->ZDM_LOJCLI
	dDtDigi  := ZDM->ZDM_DTDIGI
	cNFOri   := ZDM->ZDM_DOCORI
	cSerOri  := ZDM->ZDM_SERORI
	cForn    := ZDM->ZDM_FORNEC
	cLojFor  := ZDM->ZDM_LOJFOR
	cSolic   := ZDM->ZDM_SOLIC
	cCC      := ZDM->ZDM_CC

	fValCC(.F.)
	
	cMotivo  := ZDM->ZDM_MOTIVO  
	cMotivo2 := ZDM->ZDM_MOTIV2

	//Busca as informações da nota fiscal
	SF2->(dbSetOrder(1)) //filial + doc + serie + fornece + loja
	If SF2->(dbSeek(xFilial("SF2")+cNF+cSerie+cCli+cLojCli))
		dDtEmis  := SF2->F2_EMISSAO
	EndIf

	//busca a data de vencimento
	SE2->(dbSetOrder(2)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	If SE2->(dbSeek(xFilial("SE2")+cForn+cLojFor+cSerOri+cNFOri))
		dDtVenc := SE2->E2_VENCTO
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A NOTA FISCAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValNF()

	SF1->(dbSetOrder(1)) //filial + doc + serie + fornece + loja
	IF !SF1->(dbSeek(xFilial("SF1")+cNFOri)) .AND. !EMPTY(cNFOri)
		Alert("Número de Nota Fiscal não encontrado!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A NOTA FISCAL E A SERIE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValSerie()

	SF1->(dbSetOrder(1)) //filial + doc + serie + fornece + loja
	If !SF1->(dbSeek(xFilial("SF1")+cNFOri+cSerOri)) .AND. !EMPTY(cSerOri)
		Alert("Nota Fiscal / Serie não encontrada!")
		Return .F.
	EndIf
	
	If !Empty(cForn) .and. !Empty(cLojFor)
		fValLoja()
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValForn()

	SA2->(dbSetOrder(1))// FILIAL + COD + LOJA
	If !SA2->(dbSeek(xFilial("SA2")+cForn)) .AND. !Empty(cForn)
		Alert("Fornecedor não encontrado!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA DO FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValLoja()
	If Empty(cLojFor)
		Return .T.
	EndIf
	
	SA2->(dbSetOrder(1))// FILIAL + COD + LOJA
	If !SA2->(dbSeek(xFilial("SA2")+cForn+cLojFor)) .AND. !Empty(cLojFor)
		Alert("Fornecedor / Loja não encontrado!")
		Return .F.
	Else
		cDesFor := SA2->A2_NOME
		oGet9:Refresh()
	EndIf
	
	SF1->(dbSetOrder(1)) //filial + doc + serie + fornece + loja
	If !SF1->(dbSeek(xFilial("SF1")+cNFOri+cSerOri+cForn+cLojFor))
		Alert("Nota Fiscal / Serie / Fornecedor / Loja não encontrado!")

		cNfOri  := Space(9)
		cLojOri := Space(3)
		cForn   := Space(6)
		cLojFor := Space(2)
		cDesFor := ""
		oGet5:Refresh()
		oGet6:Refresh()
		oGet7:Refresh()
		oGet8:Refresh()
		oGet9:Refresh()
		
		Return .F.
	Else

		//busca a data de vencimento do titulo da nota de origem
		SE2->(dbSetOrder(6)) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If SE2->(dbSeek(xFilial("SE2")+cForn+cLojFor+cSerOri+cNFOri))
			dDtVenc := SE2->E2_VENCTO
			oGet4:Refresh()
		EndIf
	
	
	EndIf

Return .T.	

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function FAT31LEG()       

/*
Local aLegenda :=	{{"BR_VERMELHO", "Fechado"},;
  						 {"BR_VERDE"   , "Aberto" }}
*/
Local aLegenda :=	{{"BR_VERMELHO", "Titulo baixado"},;
  						 {"BR_AMARELO" , "Débito sem lançamento financeiro"},;
 						 {"BR_VERDE"   , "Titulo em aberto" }}

BrwLegenda("Débitos aos Fornecedores", "Legenda", aLegenda)

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A COR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()

Local aLegenda :=	{{"BR_VERMELHO", "Titulo baixado"},;
  						 {"BR_AMARELO" , "Débito sem lançamento financeiro"},;
  						 {"BR_VERDE"   , "Titulo em aberto" }}

Local uRetorno := {}

Aadd(uRetorno, { 'ZDM->ZDM_STATUS == "E"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZDM->ZDM_STATUS == "N"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZDM->ZDM_STATUS == "A"' , aLegenda[3][1] } )

Return(uRetorno)

//User Function FAT31LEG()       

//Local aLegenda :=	{	{"BR_VERMELHO", "Fechado"  },;
//  						{"BR_VERDE"   , "Aberto"   }}

//BrwLegenda("Débitos aos Fornecedores", "Legenda", aLegenda)

//Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A COR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Static Function fCriaCor()

//Local aLegenda :=	{	{"BR_VERMELHO", "Fechado"  },;
//  						{"BR_VERDE"   , "Aberto"   }}

//Local uRetorno := {}

//Aadd(uRetorno, { 'ZDM->ZDM_STATUS == "A"' , aLegenda[1][1] } )
//Aadd(uRetorno, { 'ZDM->ZDM_STATUS == "E"' , aLegenda[2][1] } )

//Return(uRetorno)
