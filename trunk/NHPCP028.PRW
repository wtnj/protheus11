/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP028  ºAutor  ³João Felipe da Rosa º Data ³  21/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ALERTA DE CRITICIDADE / PARADADE DE LINHA                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±Alteração  ³ Felipe Ciconini                                 26/11/2010 ±±±
±±           ³    Inclusão do Botão Carregar na Inclusão de Alerta        ±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function NHPCP028()

Private cCadastro := "Alerta de Criticidade / Parada de Linha"
Private aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_PCP28(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_PCP28(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_PCP28(4)"   , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_PCP28(5)"   , 0 , 5})
aAdd(aRotina,{ "Imprimir"       ,"U_NHPCP029()" , 0 , 6})
aAdd(aRotina,{ "Calc Prejuizo"	,"U_fCalcPrej()", 0 , 7})
aAdd(aRotina,{ "Legenda" 		,"U_FLegCor"	, 0 , 8})
aAdd(ARotina,{ "Documento"		,"U_fDOC20()"   , 0 , 9})

mBrowse(6,1,22,75,"ZDU",,,,,,fCriaCor())

Return  

//Abre a funcao base de conhecimento
User Function fDOC20()
   MsDocument('ZDU',ZDU->(RECNO()), 4)
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP28(nParam)
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Local aButtons	 := {}

Private nPar 	 := nParam  
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)
Private aCols    := {}
Private aHeader  := {}

Private cNum     := ""
Private dData    := CtoD("  /  /  ")
Private cTipo    := ""
Private _cTipo   := ""
Private aTipo    := {"","C=Alerta de Criticidade","P=Alerta de Parada de Linha","L=Alerta Logistico"}
Private cMat     := Space(6)
Private cNome    := ""
Private cCliFor  := Space(6)
Private cLoja    := Space(2)
Private cProd    := Space(15)
Private cDesProd := ""       
Private  cDesCF  := ""
Private cCF      := ""
Private cProm    := Space(40)
Private cObs     := Space(100)
Private cProbl   := ""
Private cCampo	 := "1"
Private aProbl   := {}
Private aOpcao   := {} 

	Aadd(aHeader,{"Item" 	    , "ZDV_ITEM"    ,"@E 9999"           ,04,0,".F."         ,"" ,"C"  ,"ZDV"})
	Aadd(aHeader,{"Produto"     , "ZDV_PROD"    ,"@!"	             ,15,0,"U_PCP28PRD()","" ,"C"  ,"ZDV"})
	Aadd(aHeader,{"Descrição"   , "B1_DESC"     ,"@!"	             ,30,0,".F."         ,"" ,"C"  ,"SB1"})

	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		aAdd(aButtons,{"MENURUN",{||Processa({||fCarreg()},"Carregando itens... Aguarde")},"Carrega ítens do último release","Carrega"})
		cNum := GetSxENum("ZDU","ZDU_NUM")
		dData := Date()
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,aButtons)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Alerta de Criticidade / Parada de Linha",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Número"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oSay2 := TSay():New(20,50,{||cNum},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(20,160,{||"Data"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(18,200,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"dData")
	
	
	
   	oSay4 := TSay():New(31,10,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	If nPar == 2 .OR. nPar == 5
	   	If cTipo == "L"
		   	@ 029,050 Get "Alerta Logistico" Size 090,08 When .F.
		ElseIf cTipo == "P"
			@ 029,050 Get "Parada de Linha" Size 090,08 When .F.
		Else
			@ 029,050 Get "Alerta de Criticidade" Size 090,08 When .F.
		EndiF
	Else
		oCombo1 := TComboBox():New(29,50,{|u| if(Pcount() > 0,cTipo := u,cTipo)},;
		aTipo,90,10,oDlg,,{|| fValDesc() },,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cTipo")
	EndIf

	oSay13  := TSay():New(31,160,{||"Cometido Por"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(29,200,{|u| if(Pcount() > 0,cCF := u,cCF)},;
		{" ","C=Cliente","F=Fornecedor"},80,10,oDlg,,{|| fAltF3()},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cCF")

	oSay5 := TSay():New(42,10,{||"Aprovisionador"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(40,50,{|u| if(Pcount() > 0, cMat := u,cMat)},oDlg,40,8,"@!",{||fValMat()},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,"QAA","cMat")

	oSay6 := TSay():New(42,160,{||"Nome"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(40,200,{|u| if(Pcount() > 0, cNome := u,cNome)},oDlg,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .F.},,,,,,,"cNome")

/*
	oSay7 := TSay():New(53,10,{||"Referência"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(51,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlg,60,8,"@!",{||fValProd()},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,"SB1","cProd")

	oSay8 := TSay():New(53,160,{||"Desc. Ref."},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(51,200,{|u| if(Pcount() > 0, cDesProd := u,cDesProd)},oDlg,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesProd")

*/  
	oSay9 := TSay():New(53,10,{||"Cli / Forn"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet6 := tGet():New(51,50,{|u| if(Pcount() > 0, cCliFor := u,cCliFor)},oDlg,40,8,"@!",{||fValCF()},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,,"cCliFor")

	oSay10 := TSay():New(53,160,{||"Loja"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet7  := tGet():New(51,200,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg,20,8,"@!",{||fValCF()},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,,"cLoja")

	oSay11 := TSay():New(64,10,{||"Nome Cli / Forn"},oDlg,,,,,,.T.,,)
	oGet8  := tGet():New(62,50,{|u| if(Pcount() > 0, cDesCF := u,cDesCF)},oDlg,200,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"cDesCF")

	oSay12 := TSay():New(75,10,{||"Promessa Forn."},oDlg,,,,,,.T.,,)
	oGet9  := tGet():New(73,50,{|u| if(Pcount() > 0, cProm := u,cProm)},oDlg,200,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,,"cProm")

	oSay13 := TSay():New(86,10,{||"Observação"},oDlg,,,,,,.T.,,)
	oGet10  := tGet():New(84,50,{|u| if(Pcount() > 0, cObs := u,cObs)},oDlg,200,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| nPar==3 .or. nPar==4},,,,,,,"cObs")
    

	If nPar == 2 .OR. nPar == 5
		@ 095,050 Get _cTipo                    Size 200,08 When .F.
	  //	oTipo	:= tGet():New(95,50,{|u| if(pCount() > 0,cCampo := u,cCampo)},oDlg,200,8,"@!",{||.F.},;
		//		   ,,,,,.F.,,,{||},,,,,,,"_cTipo")
	Else
		oSay14  := TSay():New(97,10,{||"Desc. Problema"},oDlg,,,,,,.T.,,)
		oCombo3 := TComboBox():New(95,50,{|u| if(Pcount() > 0,cCampo := u,cCampo)},;
				   aProbl,20,08,oDlg,,{|| fComAl() },,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cCampo")
		oTipo	:= tGet():New(95,75,{|u| if(Pcount() > 0, _cTipo := u,_cTipo)},oDlg,200,8,"@!",{||cCampo == "6"},;
	    	       ,,,,,.T.,,,{||cCampo == "6"},,,,,,,"_cTipo")
	
	EndIf
	If nPar != 2 .AND. nPar != 5
    fValDesc()
    EndIf

    // cria o getDados
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 110  ,; //superior
	                           aPosObj[2,2]     ,; 		//esquerda
	                           aPosObj[2,3]     ,; 		//inferior
	                           aPosObj[2,4]     ,; 		//direita
	                           4                ,; 		// nOpc
	                           "AllwaysTrue"    ,; 		// CLINHAOK
	                           "AllwaysTrue"    ,; 		// CTUDOOK
	                           ""               ,; 		// CINICPOS
	                           .T.              ,; 		// LDELETA
	                           nil              ,; 		// aAlter
	                           nil              ,; 		// uPar1
	                           .F.              ,; 		// LEMPTY
	                           200              ,; 		// nMax
	                           nil              ,; 		// cCampoOk
	                           "AllwaysTrue()"  ,; 		// CSUPERDEL
	                           nil              ,; 		// uPar2
	                           "AllwaysTrue()"  ,; 		// CDELOK
	                           oDlg              ; 		// oWnd
	                          )

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Static Function fValCF()

	If Substr(cCF,1,1)=="C"
		SA1->(dbSetOrder(1))// filial + cod + loja
		If !SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja))
		    Alert("Cliente / Loja não encontrado!")
		    Return .f.
		Else
			cDesCF := SA1->A1_NOME
		EndIf
		
	ElseIF Substr(cCF,1,1)=="F"
		SA2->(dbSetOrder(1)) // FILIAL + COD + LOJA
		If !SA2->(dbSeek(xFilial("SA2")+cCliFor))
			Alert("Fornecedor / Loja não encontrado!")
			REturn .F.
		Else
			cDesCF := SA2->A2_NOME
		EndIF
	ElseIf !Empty(cCliFor) .or. !Empty(cLoja)
		Alert("Informe o campo Cometido Por!")
		Return .f.
	EndIF

	oGet8:Refresh()

Return .T.

Static Function fAltF3()
	If Substr(cCF,1,1)=="C"
		oGet6:cF3 := "SA1"
	ElseIF Substr(cCF,1,1)=="F"
		oGet6:cF3 := "SA2"
	EndIF
	cCliFor := Space(6)
	cLoja   := Space(2)
	cDesCF  := ""
	oGet6:Refresh()
	oGet7:Refresh()
	oGet8:Refresh()

Return

Static Function fValMat()
	QAA->(dbSetOrder(1)) // FILIAL + MAT
	If QAA->(dbSeek(xFilial("QAA")+cMat))
		cNome := QAA->QAA_NOME
		oGet3:Refresh()
	Else
		Alert("Matrícula não encontrada!")
		Return .F.
	EndIf
Return

User Function PCP28PRD()()
Local nPosDesc := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_DESC"})
    
    SB1->(dbSetOrder(1)) // FILIAL + COD
    If SB1->(dbSeek(xFilial("SB1")+M->ZDV_PROD))
    	aCols[n][nPosDesc] := SB1->B1_DESC
    	oGetD:Refresh()
    Else
    	Alert("Produto não encontrado!")
    	Return .f.
    EndIF
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()
	If Empty(cTipo)
		Alert("Informe o tipo!")
		Return .F.
	EndIf
                
	If Empty(cCF)
		Alert("Informe o campo Cometido Por!")
		Return .F.
	EndIf
	
	If Empty(cMat)
		alert("Informe o aprovisionador!")
		Return .F.
	EndIF
	
	If Empty(cCliFor)
		Alert("Informe o cliente / fornecedor!")
		Return .F.
	EndIf
	
	If Empty(cLoja)
		Alert("Informe a loja!")
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
	
	
	RecLock("ZDU",.T.)
		ZDU->ZDU_FILIAL := xFilial("ZDU")
		ZDU->ZDU_NUM    := cNum
		ZDU->ZDU_DATA   := dData
		ZDU->ZDU_TIPO   := cTipo
		ZDU->ZDU_MAT    := cMat
		ZDU->ZDU_CF     := cCF
		ZDU->ZDU_CLIFOR := cCliFor
		ZDU->ZDU_LOJA   := cLoja
		ZDU->ZDU_PROM   := cProm
		ZDU->ZDU_OBS    := cObs
		ZDU->ZDU_PROBL  := _cTipo
	MsUnlock("ZDU")
	
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //--nao pega quando estiver deletado
			RecLock("ZDV",.T.)
				ZDV->ZDV_FILIAL := xFilial("ZDV")
				ZDV->ZDV_NUM    := cNum
				ZDV->ZDV_ITEM   := aCols[x][1]
				ZDV->ZDV_PROD   := aCols[x][2]
			MsUnlock("ZDV")
		EndIf
	Next
	
	ConfirmSx8()
	
	oDlg:End()

Return                                                 

//ÀÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ                                       			
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf

	RecLock("ZDU",.F.)
		ZDU->ZDU_TIPO   := cTipo
		ZDU->ZDU_MAT    := cMat
		ZDU->ZDU_CF     := cCF
		ZDU->ZDU_CLIFOR := cCliFor
		ZDU->ZDU_LOJA   := cLoja
		ZDU->ZDU_PROM   := cProm
		ZDU->ZDU_OBS    := cObs
		ZDU->ZDU_PROBL  := _cTipo
	MsUnlock("ZDU")
	    
	ZDV->(dbSetOrder(1)) // FILIAL + NUM + ITEM
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //--nao pega quando estiver deletado
			If ZDV->(dbSeek(xFilial("ZDV")+cNum+aCols[x][1]))
				RecLock("ZDV",.F.)
					ZDV->ZDV_PROD   := aCols[x][2]
				MsUnlock("ZDV")
			Else
				RecLock("ZDV",.T.)
					ZDV->ZDV_FILIAL := xFilial("ZDV")
					ZDV->ZDV_NUM    := cNum
					ZDV->ZDV_ITEM   := aCols[x][1]
					ZDV->ZDV_PROD   := aCols[x][2]
				MsUnlock("ZDV")
			EndIf
		Else
			If ZDV->(dbSeek(xFilial("ZDV")+cNum+aCols[x][1]))
				RecLock("ZDV",.F.)
					ZDV->(dbDelete())
				MsUnlock("ZDV")
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
		RecLock("ZDU",.F.)
			ZDU->(dbDelete())
		MsUnlock("ZDU")
		If ZDV->(dbSeek(xFilial("ZDV")+cNum))
			WHILE ZDV->(!EOF()) .AND. ZDV->ZDV_NUM==cNum
				RecLock("ZDV",.F.)
					ZDV->(dbDelete())
				MsUnlock("ZDV")
				
				ZDV->(dbSkip())
			ENDDO
		EndIf
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()

	cNum 	:= ZDU->ZDU_NUM
	dData 	:= ZDU->ZDU_DATA
 	cTipo 	:= ZDU->ZDU_TIPO
	cMat	:= ZDU->ZDU_MAT
	cCF		:= ZDU->ZDU_CF
	cCliFor	:= ZDU->ZDU_CLIFOR
	cLoja	:= ZDU->ZDU_LOJA
	cProm	:= ZDU->ZDU_PROM
	cObs	:= ZDU->ZDU_OBS
	_cTipo	:= ZDU->ZDU_PROBL

	QAA->(dbSetOrder(1)) //FILIAL + MAT
	QAA->(dbSeek(xFilial("QAA")+cMat))
	cNome := QAA->QAA_NOME
	
	If Substr(cCF,1,1)=="C"
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja))
		cDesCF := SA1->A1_NOME
	ElseIf Substr(cCF,1,1)=="F"
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+cCliFor+cLoja))
		cDesCF := SA2->A2_NOME
	EndIf
	
	//-- alimenta o acols para visualizacao, alteracao ou exclusao
	ZDV->(dbSetOrder(1)) // FILIAL + NUM + ITEM
	If ZDV->(dbSeek(xFilial("ZDV")+cNum))
		SB1->(dbSetOrder(1))//FILIAL + COD
		WHILE ZDV->(!EOF()) .AND. ZDV->ZDV_NUM==cNum
			SB1->(dbSeek(xFilial("SB1")+ZDV->ZDV_PROD))
			aAdd(aCols,{ZDV->ZDV_ITEM,ZDV->ZDV_PROD,SB1->B1_DESC,.F.})
			ZDV->(dbSkip())
		ENDDO
	EndIf
	
Return



/*

88888888888888888888888888888888|ATUALIZAÇÃO|88888888888888888888888888888888

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP028  ºAutor  ³Felipe Ciconini     º Data ³  21/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de cálculo de prejuízo. Solicitado pela           º±±
±±º          ³Erica de Lima Torres                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Planejamento e Controle de Produção                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

   			//~¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨~
   			//~¨¨¨|TELA DE CALCULO DE PREJUIZO|¨¨¨~
   			//~¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨~

User Function fCalcPrej()
    
    
	SetPrvt("aHeader,aCols,_cNum,_cTipo,_cTipoAl,_nDeb,_cIniOc,_cFimOc,_cResp,_cFornec,_cOper,_cDesc,_cForDesc,aCampos") 			//DEFININDO VARIAVEIS
	
	If ZDU->ZDU_STATUS <> ' '
		fPuxaCalc()
		Return
	EndIf
	
	
	//ATRIBUINDO VARIAVEIS
	aHeader 	:= {}
	aCols		:= {}
	_cNum  		:= ZDU->ZDU_NUM
	_cFornec	:= ZDU->ZDU_CLIFOR+"-"+ZDU->ZDU_LOJA
	_nDeb		:= ZDU->ZDU_NUM+"d"
	_cResp		:= Posicione("QAA",1,xFilial("QAA")+ZDU->ZDU_MAT,"QAA_NOME")
	_cIniOc     := CtoD("  /  /    ")
	_cFimOc		:= CtoD("  /  /    ")
	_cHorIni	:= Space(5)
	_cHorFim	:= Space(5)
	_cOper		:= Space(15)
	_cDesc		:= Space(15)
	_cTipo		:= "PARADA DE LINHA POR FALTA DE MATÉRIA-PRIMA"				//RECEBE O 1º VALOR DO COMBOBOX
	aCampos		:= {"1","2","3","4","5","6"}
	cCampo		:= "1"

	

	If ZDU->ZDU_CF == "F"
		_cForDesc := Posicione("SA2",1,xFilial("SA2")+ZDU->ZDU_CLIFOR+ZDU->ZDU_LOJA,"A2_NOME")
	ElseIf ZDU->ZDU_CF == "C"
		_cForDesc := Posicione("SA1",1,xFilial("SA1")+ZDU->ZDU_CLIFOR+ZDU->ZDU_LOJA,"A1_NOME")
	EndIf
	
	If ZDU->ZDU_TIPO == "P"
		_cTipoAl := "ALERTA DE PARADA DE LINHA"
	ElseIf ZDU->ZDU_TIPO == "C"
		_cTipoAl := "ALERTA DE CRITICIDADE"
	Else
		_cTipoAl := "ALERTA LOGÍSTICO"
	EndIf
			
	Aadd(aHeader,{"Item" 	    , "ZDV_ITEM"    ,"@E 9999"           ,04,0,".F."         ,"" ,"C"  ,"ZDV"})
	Aadd(aHeader,{"Produto"     , "ZDV_PROD"    ,"@!"	             ,15,0,".F."		 ,"" ,"C"  ,"ZDV"})
	Aadd(aHeader,{"Descrição"   , "B1_DESC"     ,"@!"	             ,30,0,".F."         ,"" ,"C"  ,"SB1"})
	
	fChamaAlerta(_cNum)
	
	Define MsDialog oDlg From 0,0 To 550,500 Pixel Title "Cálculo de Prejuízo"
	   //  V , H
		@ 005,005 To  150,248 LABEL "Calculo" Of oDlg Pixel
		@ 015,010 Say "Numero:" Size 030,8
		@ 013,030 Get _cNum 	Size 030,8 When .F.
		@ 015,062 Say "Tipo:" 	Size 020,8
		@ 013,075 ComboBox cCampo	 	Items aCampos 	Size 20,08 Pixel Of oDlg On Change fCombo()
		
		@ 013,100 Get _cTipo Object oTipo 		Size 145,08 When cCampo == "6"
		@ 030,010 Say "Debito Nr:" 				Size 040,08
		@ 028,075 Get _nDeb 					Size 040,08 When .F.
		@ 045,010 Say "Inicio Ocorrencia:" 		Size 050,08
		@ 043,075 Get _cIniOc                   Size 045,08 When .T. Picture "99/99/9999"
		@ 043,120 Get _cHorIni					Size 005,05 When .T. Picture "99:99" Valid ngValHora(_cHorIni)
		@ 060,010 Say "Fim Ocorrencia:" 		Size 045,08
		@ 058,075 Get _cFimOc                   Size 045,08 When .T. Picture "99/99/9999" Valid fValData(_cIniOc,_cFimOc)
		@ 058,120 Get _cHorFim					Size 005,05 When .T. Picture "99:99" Valid fValHr(_cHorIni,_cHorFim,_cIniOc,_cFimOc)
		@ 075,010 Say "Responsavel:" 			Size 040,08
		@ 073,075 Get _cResp                    Size 075,08 When .F.
		@ 090,010 Say "Fornecedor/Cliente" 		Size 050,08
		@ 088,075 Get _cFornec                  Size 040,08 When .F.
		@ 088,120 Get _cForDesc					Size 080,08 When .F.
		@ 105,010 Say "Operacoes Envolvidas" 	Size 055,08
		@ 103,075 Get _cOper                    Size 040,08 When .T.
		@ 120,010 Say "Descricao do Problema" 	Size 060,08
		@ 118,075 Get _cDesc MEMO 				Size 170,25 When .T.
		
		@ 160,005 Say "Produtos Envolvidos:" Size 50,8
		@ 170,005 To  250,248 MultiLine Modify Object oMultiline
		
		@ 255,170 Button "Gerar Calculo"	Size 040,015 Action U_NHPCP034()                    //INCLUI NA ZDZ E GERA O RELATÓRIO
		@ 255,218 Button "Cancelar" 		Size 030,015 Action oDlg:End()
		
	Activate MsDialog oDlg Center

Return 


Static Function fValHr(cHoraIni,cHoraFim,cIniOc,cFimOc)
Local cHrOc := .T.  

	If cHoraIni > cHoraFim .AND. cIniOc == cFimOc
		alert("Hora Final não pode ser menor que a Hora Inicial, verifique!")
		cHrOc := .F.
	Else
		ngValHora(cHoraFim)
		cHrOc := .T.
	EndIf

Return(cHrOc)


Static Function fValData(_cIniOc,_cFimOc)
Local dDtOc := .T.

	If _cIniOc > _cFimOc
	        Msgbox("Data Final não pode ser maior que a inicial, Verifique !!!","Atencao Data","ALERT" )  
			dDtOc := .F.
	EndIf

Return(dDtOc)


Return


Static Function fPuxaCalc()
	Local cQuery
	//SetPrvt("aHeader,aCols,_cNum,_cTipo,_nDeb,_cIniOc,_cFimOc,_cResp,_cFornec,_cOper,_cDesc,_cForDesc,_cHorIni,_cHorFim")
	
	
	aHeader 	:= {}
	aCols		:= {}
	_cNum		:= ZDU->ZDU_NUM
	_cFornec	:= ZDU->ZDU_CLIFOR+"-"+ZDU->ZDU_LOJA
	_cResp		:= Posicione("QAA",1,xFilial("QAA")+ZDU->ZDU_MAT,"QAA_NOME")
	_cDesc		:= Space(15)

	If ZDU->ZDU_CF == "F"
		_cForDesc := Posicione("SA2",1,xFilial("SA2")+ZDU->ZDU_CLIFOR+ZDU->ZDU_LOJA,"A2_NOME")
	ElseIf ZDU->ZDU_CF == "C"
		_cForDesc := Posicione("SA1",1,xFilial("SA1")+ZDU->ZDU_CLIFOR+ZDU->ZDU_LOJA,"A1_NOME")
	EndIf
	
	Aadd(aHeader,{"Item" 	    , "ZDV_ITEM"    ,"@E 9999"           ,04,0,".F."         ,"" ,"C"  ,"ZDV"})
	Aadd(aHeader,{"Produto"     , "ZDV_PROD"    ,"@!"	             ,15,0,".F."		 ,"" ,"C"  ,"ZDV"})
	Aadd(aHeader,{"Descrição"   , "B1_DESC"     ,"@!"	             ,30,0,".F."         ,"" ,"C"  ,"SB1"})
	
	fChamaAlerta(_cNum)
	
	cQuery := "SELECT ZDZ_NUM, ZDZ_TIPO, ZDZ_DEB, ZDZ_DTAINI, ZDZ_HORINI, ZDZ_DTAFIM, ZDZ_HORFIM, ZDZ_OPS, ZDZ_DESCPR "
	cQuery += " FROM "+RetSqlName("ZDZ")
	cQuery += " WHERE ZDZ_NUM = '"+_cNum+"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	cQuery += " AND ZDZ_FILIAL = '"+xFilial("ZDZ")+"'"
//	MemoWrit("C:\TEMP\NHPCP028.SQL",cQuery)
	TCQUERY cQuery NEW ALIAS "TMP1"
	
	ZDU->(DbSetOrder(1))
	If ZDU->(DbSeek(xFilial("ZDU")+TMP1->ZDZ_NUM))
		If ZDU->ZDU_TIPO == "P"
			_cTipoAl := "ALERTA DE PARADA DE LINHA"
		ElseIf ZDU->ZDU_TIPO == "C"
			_cTipoAl := "ALERTA DE CRITICIDADE"
		Else
			_cTipoAl := "ALERTA LOGÍSTICO"
		EndIf
	EndIf
	
	_cTipo		:= TMP1->ZDZ_TIPO
	_nDeb		:= TMP1->ZDZ_DEB
	_cIniOc		:= StoD(TMP1->ZDZ_DTAINI)
	_cFimOc		:= StoD(TMP1->ZDZ_DTAFIM)
	_cHorIni	:= TMP1->ZDZ_HORINI
	_cHorFim	:= TMP1->ZDZ_HORFIM
	_cOper		:= TMP1->ZDZ_OPS
	_cDesc		:= TMP1->ZDZ_DESCPR
	
	//TELA DE ALTERAÇÃO DE CALCULO DE PREJUIZO
		
	
	Define MsDialog oDlg From 0,0 To 550,500 Pixel Title "Cálculo de Prejuízo"
	    // V , H
		@ 005,005 To  150,248 LABEL "Calculo" Of oDlg Pixel
		@ 015,010 Say	 	"Numero:" 					Size 030,8
	   	@ 013,030 Get		_cNum						Size 030,8 When .F.
		@ 015,062 Say 		"Tipo:"    					Size 020,8
//	   	@ 013,075 ComboBox cCampo	 	Items aCampos 	Size 20,08 Pixel Of oDlg On Change fCombo()
		
		@ 013,075 Get _cTipo Object oTipo 		Size 170,08 When .F.
		@ 030,010 Say "Debito Nr:" 				Size 040,08
		@ 028,075 Get _nDeb						Size 040,08 When .F.
		@ 045,010 Say "Inicio Ocorrencia:" 		Size 050,08
		@ 043,075 Get _cIniOc	            	Size 040,08 When .T. Picture "99/99/9999"
		@ 043,120 Get _cHorIni					Size 005,05 When .T. Picture "99:99" Valid ngValHora(_cHorIni)
		@ 060,010 Say "Fim Ocorrencia:" 		Size 045,08
		@ 058,075 Get _cFimOc	            	Size 040,08 When .T. Picture "99/99/9999" Valid fValData(_cIniOc,_cFimOc)
		@ 058,120 Get _cHorFim					Size 005,05 When .T. Picture "99:99" Valid fValHr(_cHorIni,_cHorFim)
		@ 075,010 Say "Responsavel:" 			Size 040,08
		@ 073,075 Get _cResp                    Size 075,08 When .F.
		@ 090,010 Say "Fornecedor/Cliente" 		Size 050,08
		@ 088,075 Get _cFornec                  Size 040,08 When .F.
		@ 088,120 Get _cForDesc					Size 080,08 When .F.
		@ 105,010 Say "Operacoes Envolvidas" 	Size 055,08
		@ 103,075 Get _cOper		            Size 040,08 When .F.
		@ 120,010 Say "Descricao do Problema" 	Size 060,08
		@ 118,075 Get _cDesc MEMO				Size 170,25 When .F.
		
		@ 160,005 Say "Produtos Envolvidos:" Size 70,8
		@ 170,005 To  250,248 MultiLine Modify Object oMultiline
		
		@ 255,170 Button "Gerar Calculo"	Size 040,015 Action U_NHPCP034()                    //INCLUI NA ZDZ E GERA O RELATÓRIO
		@ 255,218 Button "Cancelar" 		Size 030,015 Action oDlg:End()
		TMP1->(DbCloseArea())
		
	Activate MsDialog oDlg Center  

Return



Static Function fComAl()

	_cTipo := aOpcao[oCombo3:nAt-1]
	oTipo:Refresh()

Return


Static Function fValDesc()
    
	If nPar != 2 .OR. nPar != 5
		If oCombo1:nAt == 2 .OR. oCombo1:nAt == 3
			oCombo3:aItems := {"","1","2","3","4","5","6","7"}
			aOpcao := {"ATRASO NO PROGRAMA DE ENTREGAS","PROBLEMAS DE QUALIDADE",;
						 "AUMENTO NO PROGRAMA DE ENTREGAS","ANTECIPAÇÃO DE ENTREGA",;
						 "ITENS ABAIXO DO ESTOQUE MÍNIMO/CRÍTICO","OUTROS"+Space(75),"EXCESSO DE ENTREGAS X PROGRAMADO"}
			oCombo3:Refresh()
		Else
			oCombo3:aItems := {"","1","2","3","4","5","6"}
			aOpcao := {"EMBALAGENS NÃO CONFORME", "QUANTIDADE DESPADRONIZADA POR EMBALAGEM",;
						 "CARGA TOMBADA","USO INCORRETO DAS EMBALAGENS",;
						 "EMBALAGENS DANIFICADAS","OUTROS"+Space(75)}
			oCombo3:Refresh()
		EndIf
		
		_cTipo := " "
		oTipo:Refresh()
	EndIf

Return

Static Function fCombo()

	Do Case
		Case cCampo == "1"
			_cTipo := "PARADA DE LINHA POR FALTA DE MATÉRIA-PRIMA"
			oTipo:Refresh()
		Case cCampo == "2"
			_cTipo := "PARADA DE LINHA POR FALTA DE COMPONENTES"
			oTipo:Refresh()
		Case cCampo == "3"
			_cTipo := "FRETES EXCEDENTES AO PLANEJAMENTO"
			oTipo:Refresh()
		Case cCampo == "4"
			_cTipo := "EMBALAGENS NÃO CONFORME"
			oTipo:Refresh()
		Case cCampo == "5"
			_cTipo := "ATRASO NO PROGRAMA DE ENTREGAS"
			oTipo:Refresh()
		Case cCampo == "6"
			_cTipo := "OUTROS"+Space(75)
			//oTipo:
			oTipo:Refresh()
		Otherwise
			_cTipo := "PARADA DE LINHA POR FALTA DE MATÉRIA-PRIMA"
			oTipo:Refresh()
	EndCase

Return


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++|CHAMA OS DETALHES E CÁLCULO DE PREJUÍZO DO ALERTA SELECIONADO|+++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function fChamaAlerta(_cNum)
    
	aCols := {}

	ZDV->(DbSetOrder(1))			//Filial + Num + Item
		
	If ZDV->(DbSeek(xFilial("ZDV")+_cNum))

		While ZDV->(!EoF()) .AND. ZDV->ZDV_NUM == _cNum
  
			aAdd(aCols,{ZDV->ZDV_ITEM,;
			            ZDV->ZDV_PROD,;
			            Posicione("SB1",1,xFilial("SB1")+ZDV->ZDV_PROD,"B1_DESC"),;
			            .F.})
		ZDV->(DbSkip())
		EndDo	
	
	EndIf
Return

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++|FUNCOES DE COR|+++++++++++++++++++++++++++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


User Function FLegCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Nao Calculada"  },;
  					  {"BR_VERMELHO" , "Calculada"   }}

BrwLegenda(OemToAnsi("Alertas de Criticidade/Parada de Linha"), "Legenda", aLegenda)

Return  

Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   ,  "Nao Calculada"  },;
  					  {"BR_VERMELHO" , "Calculada"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZDU_STATUS = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZDU_STATUS <> " "', aLegenda[2][1] } )
Return(uRetorno)
		
		
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\\
//&&&&&&&&&&&&&&|FUNÇÃO DE CARREGAR OS ITENS DO ULTIMO RELEASE|&&&&&&&&&&&&&&\\
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\\

Static Function fCarreg()
Local cQuery

	If SubStr(cCF,1,1) == "C" .AND. cCliFor <> Space(06) .AND. cLoja <> Space(02)			//CLIENTE
		
        cQuery := " SELECT MAX(ZAO.ZAO_NUM) NUM "
        cQuery += " FROM "+RetSqlName("ZAO")+" ZAO "
        cQuery += " WHERE ZAO.ZAO_CLIENT = '"+cCliFor+"'"
        cQuery += " AND   ZAO.ZAO_LOJA   = '"+cLoja+"'"
        
        cQuery += " AND   ZAO.D_E_L_E_T_ = ''"
        cQuery += " AND   ZAO.ZAO_FILIAL = '"+xFilial("ZAO")+"'"
        MemoWrit("C:\temp\NHPCP028.SQL",cQuery)
        TCQUERY cQuery NEW ALIAS "TRA1"
        
        TRA1->(DbGoTop())
	        
	 	ZAP->(DbSetOrder(1))		//filial+num
		ZAP->(DbSeek(xFilial("ZAP")+TRA1->NUM))
		
		SB1->(DbSetOrder(1))        //filial+cod
		
		nItem := 0
		aCols := {}
		
		While ZAP->ZAP_NUM == TRA1->NUM .AND. ZAP->(!EoF())
		
			nItem++
			
			SB1->(DbSeek(xFilial("ZAP")+ZAP->ZAP_PROD))
			
			aAdd(aCols,{StrZero(nItem,4),;
						ZAP->ZAP_PROD,;
						SB1->B1_DESC,.F.})
						
			ZAP->(DbSkip())
		
		EndDo
  	
  	ElseIf SubStr(cCF,1,1) == "F" .AND. cCliFor <> Space(06) .AND. cLoja <> Space(02)		//FORNECEDOR
  	
  		cQuery := " SELECT MAX(ZA9.ZA9_NUM) NUM "
  		cQuery += " FROM "+RetSqlName("ZA9")+" ZA9 "
  		cQuery += " WHERE ZA9.ZA9_FORNEC = '"+cCliFor+"'"
  		cQuery += " AND   ZA9.ZA9_LOJA   = '"+cLoja+"'"
  		
  		cQuery += " AND   ZA9.D_E_L_E_T_ = ''"
  		cQuery += " AND   ZA9.ZA9_FILIAL = '"+xFilial("ZA9")+"'"
 		MemoWrit("C:\temp\NHPCP028.SQL",cQuery)
  		TCQUERY cQuery NEW ALIAS "TRA1"

  		
  		TRA1->(DbGoTop())
  		
  		ZA0->(DbSetOrder(1))		//filial+num
		ZA0->(DbSeek(xFilial("ZA0")+TRA1->NUM))
		
		SB1->(DbSetOrder(1))        //filial+cod
		
		nItem := 0
		aCols := {}
		
		While ZA0->ZA0_NUM == TRA1->NUM .AND. ZA0->(!EoF())
		
			nItem++
			
			SB1->(DbSeek(xFilial("ZA0")+ZA0->ZA0_PROD))
			
			aAdd(aCols,{StrZero(nItem,4),;
						ZA0->ZA0_PROD,;
						SB1->B1_DESC,.F.})
						
			ZA0->(DbSkip())
		
		EndDo
  	
  	Else
  		
  		alert("Selecione um Fornecedor/Cliente e digite uma Loja!")
  		Return .F. 	
  		
  	EndIf
  	
  	
	oGeTD:Refresh()

	TRA1->(DbCloseArea())
  	
  	
        
        
Return