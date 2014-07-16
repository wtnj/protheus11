/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT049 ºAutor  ³ João Felipe da Rosaº Data ³  06/04/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO FERRAMENTAL                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                 
#include "colors.ch"

User Function NHMNT049()

Private cCadastro := "Cadastro Ferramental"
Private aRotina   := {}

aAdd(aRotina,{ "Pesquisa"   ,"AxPesqui"    , 0 , 1})
aAdd(aRotina,{ "Visualizar"	,"U_MNT49(2)"  , 0 , 2})
aAdd(aRotina,{ "Incluir"	,"U_MNT49(3)"  , 0 , 3})
aAdd(aRotina,{ "Alterar"    ,"U_MNT49(4)"  , 0 , 4})
aAdd(aRotina,{ "Excluir"    ,"U_MNT49(5)"  , 0 , 5})
aAdd(aRotina,{ "Anexo"      ,"U_MNTD49()"  , 0,  4})

mBrowse(6,1,22,75,"ZDP",,,,,,fCriaCor())

Return

//Abre a funcao base de conhecimento
User Function MNTD49()
	MsDocument('ZDP',ZDP->(RECNO()), 4)
return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT49(nParam) 
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Private nPar 	 := nParam  
Private aSize    := MsAdvSize()

Private cCod     := ""
Private cLetra   := ""
Private cCenTrab := space(6)
Private cProd    := space(15)
Private cDesProd := ""
Private cTipo    
Private cMaq     := space(15)
Private cDesMaq  := ""
Private cAtivo   
Private cCli     := space(6)
Private cLoja    := space(2)
Private cDesCli  := ""
Private cPropCli 
Private aTipo := {"1=Modelo","2=Caixa de Macho","3=Dispositivo"}

	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk := {|| fInclui()}
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
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"CADASTRO FERRAMENTAL",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Código"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, cCod := u,cCod)},oDlg,60,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cCod")

	oSay2 := TSay():New(20,160,{||"Letra"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(18,200,{|u| if(Pcount() > 0, cLetra := u,cLetra)},oDlg,10,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cLetra")

	oSay3 := TSay():New(31,10,{||"Centro Trab"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(29,50,{|u| if(Pcount() > 0, cCenTrab := u,cCenTrab)},oDlg,40,8,"@!",{||fValCTrb(.T.)},;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,"SHB","cCenTrab")
		
	oSay4 := TSay():New(31,160,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(29,200,{|u| if(Pcount() > 0,cTipo := u,cTipo)},;
		aTipo,60,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cTipo")

	oSay5 := TSay():New(42,10,{||"Produto"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(40,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlg,60,8,"@!",{||fValProd()},;
		,,,,,.T.,,,{||nPar==3},,,,,,"SB1","cProd")

	oSay6 := TSay():New(42,160,{||"Desc. Prod."},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(40,200,{|u| if(Pcount() > 0, cDesProd := u,cDesProd)},oDlg,150,8,"@!",{||},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesProd")
		
	oSay7 := TSay():New(53,10,{||"Máquina"},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(51,50,{|u| if(Pcount() > 0, cMaq := u,cMaq)},oDlg,60,8,"@!",{||fValMaq()},;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,"ST9","cMaq")

	oSay8 := TSay():New(53,160,{||"Desc. Maq."},oDlg,,,,,,.T.,,)
	oGet7 := tGet():New(51,200,{|u| if(Pcount() > 0, cDesMaq := u,cDesMaq)},oDlg,150,8,"@!",{||},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesMaq")

	oSay9 := TSay():New(64,10,{||"Ativo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo2 := TComboBox():New(62,50,{|u| if(Pcount() > 0,cAtivo := u,cAtivo)},;
		{"S=Sim","N=Nao"},40,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cAtivo")

	oSay10 := TSay():New(64,160,{||"Propr. Cliente"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo3 := TComboBox():New(62,200,{|u| if(Pcount() > 0,cPropCli := u,cPropCli)},;
		{"S=Sim","N=Nao"},40,10,oDlg,,{||fLimpCli()},,,,.T.,,,,{||nPar==3 .or. nPar==4},,,,,"cPropCli")

	oSay11 := TSay():New(75,10,{||"Cliente"},oDlg,,,,,,.T.,,)
	oGet7 := tGet():New(73,50,{|u| if(Pcount() > 0, cCli := u,cCli)},oDlg,40,8,"@!",{||fValCli()},;
		,,,,,.T.,,,{||cPropCli=="S" .and. (nPar==3 .Or. nPar==4)},,,,,,"SA1","cCli")
	oGet8  := tGet():New(73,100,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg,10,8,"@!",{||fValLoja()},;
		,,,,,.T.,,,{||cPropCli=="S" .and. (nPar==3 .Or. nPar==4)},,,,,,,"cLoja")

	oSay12 := TSay():New(75,160,{||"Nome Cli."},oDlg,,,,,,.T.,,)
	oGet9  := tGet():New(73,200,{|u| if(Pcount() > 0, cDesCli := u,cDesCli)},oDlg,150,8,"@!",{||},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesCli")

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return
       
Static Function fLimpCli()
	If cPropCli=="N"
		cCli    := Space(6)
		cLoja   := Space(2)
		cDesCli := ""
		oGet7:Refresh()
		oGet8:Refresh()
		oGet9:Refresh()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O PRODUTO           ³
//³ MONTA O CODIGO FERRAMENTAL ³
//³ TRAZ A LETRA               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValProd() 
Local aAlfab := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
Local lAchou, xA

	If !empty(cProd)
		SB1->(dbSetOrder(1)) //FILIAL + COD
		If SB1->(dbSeek(xFilial("SB1")+cProd))
			
			//Traz a descricao do produto
			cDesProd := SB1->B1_DESC
			oGet5:Refresh()
			
			//Monta o código do ferramental
			cCod := Substr(cProd,1,6)+"F"+Substr(cProd,8,8)
			oGet1:Refresh()
			
			//Caso tenha mais de um ferramental com o mesmo cCod, traz a letra subsequente do alfabeto
			xA:=1
			
			ZDP->(dbSetOrder(1)) //FILIAL + COD + LETRA
			While .T.
				If !ZDP->(dbSeek(xFilial("ZDP")+cCod+aAlfab[xA]))
					lAchou := .F.
					cLetra := aAlfab[xA]
					oGet2:Refresh()
					exit
				EndIf
				xA++
				
				If xA>len(aAlfab)
					Alert("Alfabeto não possui mais letras para cadastrar este ferramental!")
					Return .F.
				EndIf
			EndDo
			
		Else
			Alert("Produto não encontrado!")
			Return .F.
		EndIf
	EndIf
Return .T.       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A MAQUINA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValMaq()
	If !Empty(cMaq)
		ST9->(dbSetOrder(1)) // FILIAL + COD
		If ST9->(dbSeek(xFilial("ST9")+cMaq))
			cDesMaq := ST9->T9_NOME
			oGet7:Refresh()
		Else
			Alert("Código da Máquina não encontrado!")
			Return .F.
		EndIf
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCli()
	If !Empty(cCli)
		SA1->(dbSetOrder(1)) // FILIAL + COD + LOJA
		If !SA1->(dbSeek(xFilial("SA1")+cCli))
			Alert("Código de Cliente não encontrado!")
			Return .F.		
		EndIf
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA DO CLIENTE E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValLoja()
	If !Empty(cLoja)
		SA1->(dbSetOrder(1)) // FILIAL + COD + LOJA
		If SA1->(dbSeek(xFilial("SA1")+cCli+cLoja))
			cDesCli := SA1->A1_NOME
			oGet9:Refresh()
		Else
			Alert("Cliente/Loja não encontrado!")
			Return .F.		
		EndIf
	EndIf
Return .T.
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE TRABALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCTrb(lMsg)

	If !empty(cCenTrab)
		SHB->(dbSetOrder(1)) //filial + cod
		If !SHB->(dbSeek(xFilial("SHB")+cCenTrab))
			If lMsg
				Alert("Centro de Trabalho não encontrado!")
				Return .F.
			EndIf
		EndIf
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()

	If Empty(cCod)
		Alert("O código ferramental é obrigatório!")
		Return .F.
	EndIF
	
	If Empty(cLetra)
		Alert("A letra do código ferramental é obrigatória!")
		Return .F.
	EndIf
	
	If Empty(cCenTrab)
		Alert("O Centro de Trabalho é campo obrigatório!")
		Return .F.
	EndIf
	
	If Empty(cProd)
		Alert("O produto é campo obrigatório!")
		Return .F.
	EndIf
	
	If cPropCli=="S" .And. (Empty(cCli) .or. Empty(cLoja))
		alert("Informe o código do cliente e loja para ferramental do cliente!")
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
	
	RecLock("ZDP",.T.)
		ZDP->ZDP_FILIAL := xFilial("ZDP")
		ZDP->ZDP_COD    := cCod
		ZDP->ZDP_LETRA  := cLetra
		ZDP->ZDP_CTRAB  := cCenTrab
		ZDP->ZDP_PROD   := cProd
		ZDP->ZDP_TIPO   := cTipo
		ZDP->ZDP_BEM    := cMaq
		ZDP->ZDP_ATIVO  := cAtivo
		ZDP->ZDP_PROPCL := cPropCli
		ZDP->ZDP_CLI    := cCli
		ZDP->ZDP_LOJA   := cLoja
	MsUnlock("ZDP")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	ZDP->(dbSetOrder(1)) // FILIAL + COD + LETRA
	If ZDP->(dbSeek(xFilial("ZDP")+cCod+cLetra))
		RecLock("ZDP",.F.)
			ZDP->ZDP_CTRAB  := cCenTrab
			ZDP->ZDP_TIPO   := cTipo
			ZDP->ZDP_BEM    := cMaq
			ZDP->ZDP_ATIVO  := cAtivo
			ZDP->ZDP_PROPCL := cPropCli
			ZDP->ZDP_CLI    := cCli
			ZDP->ZDP_LOJA   := cLoja
		MsUnlock("ZDP")
	Else
		Alert("Erro ao alterar!")
	EndIf
			
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")
		ZDP->(dbSetOrder(1)) // FILIAL + COD + LETRA
		If ZDP->(dbSeek(xFilial("ZDP")+cCod+cLetra))
			RecLock("ZDP",.F.)
				ZDP->(dbDelete())
			MsUnlock("ZDP")
		Else
			Alert("Erro ao excluir!")
		EndIf
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()

	cCod     := ZDP->ZDP_COD
	cLetra   := ZDP->ZDP_LETRA
	cCenTrab := ZDP->ZDP_CTRAB  
	cProd    := ZDP->ZDP_PROD
	
	SB1->(dbSetOrder(1)) // FILIAL + COD
	SB1->(dbSeek(xFilial("SB1")+cProd))
	
	cDesProd := SB1->B1_DESC
	cTipo    := ZDP->ZDP_TIPO
	
	cMaq     := ZDP->ZDP_BEM
	ST9->(dbSetOrder(1)) // FILIAL + COD
	ST9->(dbSeek(xFilial("ST9")+cMaq))
	cDesMaq  := ST9->T9_NOME
	
	cAtivo   := ZDP->ZDP_ATIVO
	cPropCli := ZDP->ZDP_PROPCL
	cCli     := ZDP->ZDP_CLI
	cLoja    := ZDP->ZDP_LOJA
	
	SA1->(dbSetOrder(1)) // FILIAL + COD + LOJA
	SA1->(dbSeek(xFilial("SA1")+cCli+cLoja))
	cDesCli  := SA1->A1_NOME

Return