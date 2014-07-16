/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT043  ºAutor  ³João Felipe da Rosa º Data ³  02/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ORDEM DE SERVICO DE FERRAMENTARIA                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                        
#INCLUDE "protheus.ch"

User Function NHMNT043()

Private aRotina, cCadastro

cCadastro := "O.S. Ferramentaria"
aRotina   := {} 

aAdd(aRotina,{ " Pesquisa   ", "AxPesqui"     , 0 , 1})
aAdd(aRotina,{ " Visualizar ", "U_MNT43(2)"   , 0 , 2})
aAdd(aRotina,{ " Incluir    ", "U_MNT43(3)"   , 0 , 3})
aAdd(aRotina,{ " Excluir    ", "U_MNT43(5)"   , 0 , 4})
aAdd(aRotina,{ " Finalizar  ", "U_MNT43(6)"   , 0 , 4})
aAdd(aRotina,{ " Alterar    ", "U_MNT43(4)"   , 0 , 4})
aAdd(aRotina,{ " Imprimir   ", "U_MNT43PRN()" , 0 , 6})
aAdd(aRotina,{ " Legenda    ", "U_MNT43LEG()" , 0 , 4})
aAdd(aRotina,{ " Reabrir    ", "U_MNT43(9)"   , 0 , 5})
aAdd(aRotina,{ " Insumos    ", "U_MNT43(7)"   , 0 , 3})


mBrowse( 6, 1,22,75,"ZBT",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT43(nParam)
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar      := nParam
Private aSize     := MsAdvSize()
Private cOrdem    := ""	
Private dDatIni   := CtoD("  /  /  ")
Private cHorIni   := Space(5)
Private dDatPrv   := CtoD("  /  /  ")
Private cSolic    := Space(6)
Private cNomSolic := ""
Private cCC       := Space(6)
Private cCaldei	  := ""
Private nQuant    := 0
Private cCodBem   := Space(15)
Private cDescBem  := ""
Private cDisp     := Space(15)
Private cLetra    := Space(1)
Private cDesDisp  := ""
Private cSituac	  := 0
Private aSituac   := {"1=Máq. Parada",;
                      "2=Máq. Deficiente",;
					  "3=Processo Normal",;
					  "4=Reposição Estoque",;
					  "5=Prioridade"}

Private aCaldei   := {"","1=Caldeiraria","2=Usinagem"}
					  
Private aServRe   := {"1=Desenho",;
					  "2=Amostra",;
					  "3=Outros"}
					  
Private cServRe   := "0"
Private cDesc     := ""
Private cCodDes   := Space(20)
Private cDesServ  := Space(50)
Private dDatFim   := CtoD("  /  /  ")
Private cHorFim   := Space(5)
Private cSoluc    := ""
Private cTermino  := ""
Private cFabr     := 0
Private aFabr     := {"WHB I = Usinagem","WHB II = Fundição","WHB III = Usinagem","WHB IV = Forjaria","WHB V = Virabrequim"}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir 
		cOrdem   := GetSxeNum("ZBT","ZBT_ORDEM")
		dDatIni  := date()
		cHorIni  := time()
    	cTermino := "N"
    	
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar

		fCarrega()
		
		If cTermino=="S"
			Alert("O.S. já finalizada!")
			Return .F.
		EndIf

		If !fRestricao()
			Return
		EndIf
		
		bOk := {|| fAltera()}

	ElseIf nPar==5 //excluir
	           
		If !AllTrim(Upper(cUserName))$"MARCIOJF/GLEISONJP/SILMARAM/EDUARDOLC"
			Alert("Usuário sem permissão! Favor entrar em contato com o setor de Ferramentaria")
			Return
		EndIF
	
		fCarrega()
		bOk := {|| fExclui()}

	ElseIf nPar==6 //Finalizar
	
		If !fRestricao()
			Return
		EndIf

		fCarrega()
		bOk := {|| fFinal()}
		
		If cTermino=="S"
			Alert("O.S. já finalizada!")
			Return .F.
		EndIf

	ElseIf nPar==7 //Insumos

		fInsumo()		
		Return

	ElseIf nPar==9 //Reabrir 

		If ZBT->ZBT_TERMIN<>"S"
			Alert("O.S. não finalizada!")
			Return .F.
		EndIf

		If !fRestricao()
			Return
		EndIf
	
		fReabre()
		Return
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Serviço - Dispositivo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"O.S."},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||cOrdem},oDlg,,oFont1,,,,.T.,,)
	
    oSay3 := TSay():New(20,150,{||"Data Abertura"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,200,{|u| if(Pcount() > 0, dDatIni := u,dDatIni)},oDlg,45,8,"99/99/99",/*valid*/,;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"dDatIni")

    oSay4 := TSay():New(32,10,{||"Hora Abertura"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(30,50,{|u| if(Pcount() > 0, cHorIni := u,cHorIni)},oDlg,40,8,"99:99",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cHorIni")
	
    oSay3 := TSay():New(32,150,{||"Prev. Entrega"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(30,200,{|u| if(Pcount() > 0, dDatPrv := u,dDatPrv)},oDlg,45,8,"99/99/99",/*valid*/,;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"dDatPrv")
		                                       
    oSay4 := TSay():New(44,10,{||"Solicitante"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(42,50,{|u| if(Pcount() > 0, cSolic := u,cSolic)},oDlg,40,8,"@!",{||fValSolic()},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,"QAA","cSolic")

	oGet5 := tGet():New(42,95,{|u| if(Pcount() > 0, cNomSolic := u,cNomSolic)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cNomSolic")

	oSay5 := TSay():New(56,10,{||"C.Custo"},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(54,50,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,40,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,"CTT","cCC")
		
	oSay6 := TSay():New(56,150,{||"Quantidade"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet7 := tGet():New(54,200,{|u| if(Pcount() > 0, nQuant := u, nQuant)},oDlg,40,8,"@e 9999",{||.T.},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nQuant")
		
	oSay7 := TSay():New(68,10,{||"Máquina"},oDlg,,,,,,.T.,,)
	oGet8 := tGet():New(66,50,{|u| if(Pcount() > 0, cCodBem := u,cCodBem)},oDlg,70,8,"@!",{||fValBem()},;
		,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,"ST9","cCodBem")
	oGet9 := tGet():New(66,125,{|u| if(Pcount() > 0, cDescBem := u,cDescBem)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescBem")

	oSay8  := TSay():New(80,10,{||"Cód. Dispositivo"},oDlg,,,,,,.T.,,)
	oGet10 := tGet():New(78,50,{|u| if(Pcount() > 0, cDisp := u,cDisp)},oDlg,70,8,"@!",{||fValDisp()},;
		,,,,,.T.,,,{|| nPar==3 .OR. nPar==4},,,,,,"ZBN","cDisp")
	oGet11 := tGet():New(78,122,{|u| if(Pcount() > 0, cLetra := u,cLetra)},oDlg,15,8,"@!",{||fValLetra()},;
		,,,,,.T.,,,{|| nPar==3 .OR. nPar==4},,,,,,,"cLetra")
	oGet12 := tGet():New(78,140,{|u| if(Pcount() > 0, cDesDisp := u,cDesDisp)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesDisp")
		
    oSay9   := TSay():New(92,10,{||"Situação"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(90,50,{|u| if(Pcount() > 0,cSituac := u,cSituac)},;
		aSituac,70,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .OR. nPar==4},,,,,"cSituac")
		
	oSay20   := TSay():New(104,10,{||"Origem OS"},oDlg,,,,,,.T.,CLR_HBLUE,)                         // CAMPO ADICIONADO POR FELIPE C. REFERENTE AO CHAMADO Nº 0011799 (25/10/10)
	oCombo5 := TComboBox():New(102,50,{|u| if(Pcount() > 0,cCaldei := u,cCaldei)},;
		aCaldei,70,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .OR. nPar==4},,,,,"cCaldei")
		
    oSay10  := TSay():New(92,130,{||"Serviço realizado através"},oDlg,,,,,,.T.,,)
	oCombo2 := TComboBox():New(90,200,{|u| if(Pcount() > 0,cServRe := u,cServRe)},;
		aServRe,70,10,oDlg,,{|| },,,,.T.,,,,{||nPar==3 .OR. nPar==4},,,,,"cServRe")

	oSay11  := TSay():New(104,150,{||"Cód. Desenho"},oDlg,,,,,,.T.,,)	
	oGet13 := tGet():New(102,200,{|u| if(Pcount() > 0, cCodDes := u,cCodDes)},oDlg,80,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(cServRe,1,1)=="1" .and. (nPar==3 .OR. nPar==4)},,,,,,,"cCodDes")

	oSay12  := TSay():New(116,150,{||"Descrição"},oDlg,,,,,,.T.,,)
	oGet14 := tGet():New(114,200,{|u| if(Pcount() > 0, cDesServ := u,cDesServ)},oDlg,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(cServRe,1,1)=="3" .and. (nPar==3 .OR. nPar==4)},,,,,,,"cDesServ")

    oSay17   := TSay():New(128,10,{||"Fabrica"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo3 := TComboBox():New(126,50,{|u| if(Pcount() > 0,cFabr := u,cFabr)},;
		aFabr,70,10,oDlg,,{||},,,,.T.,,,,{||nPar==3 .OR. nPar==4},,,,,"cFabr")
	
	oSay13 := TSay():New(140,10,{||"Desc. Serviço"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oMemo1 := tMultiget():New(138,50,{|u|if(Pcount()>0,cDesc:=u,cDesc)},;
		oDlg,250,40,,,,,,.T.,,,{||nPar==3 .OR. nPar==4})
		
	If nPar==6 .Or. nPar==2//Finalizar ou Visualizar

	    oSay14 := TSay():New(182,10,{||"Data Entrega"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet15 := tGet():New(180,50,{|u| if(Pcount() > 0, dDatFim := u,dDatFim)},oDlg,45,8,"99/99/99",/*valid*/,;
			,,,,,.T.,,,{||nPar==6},,,,,,,"dDatFim")
	
	    oSay15 := TSay():New(182,150,{||"Hora Entrega"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet16 := tGet():New(180,200,{|u| if(Pcount() > 0, cHorFim := u,cHorFim)},oDlg,35,8,"99:99",/*valid*/,;
			,,,,,.T.,,,{||nPar==6},,,,,,,"cHorFim")
			
		oSay16 := TSay():New(194,10,{||"Solução"},oDlg,,,,,,.T.,,)
		oMemo2 := tMultiget():New(192,50,{|u|if(Pcount()>0,cSoluc:=u,cSoluc)},;
			oDlg,250,40,,,,,,.T.,,,{||nPar==6})
	
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Static Function fRestricao()
    
	//-- EDUARDOCL ADICIONADO PELA OS 048128
	If !AllTrim(Upper(cUserName))$"ADAIRJS/MARCIOJF/CLAYTONJS/SERGIOPS/MARCOSY/GLEISONJP/SILMARAM/TIAGOCO/JOAOFR/EDUARDOLC/EDENILSONAS/1"
		Alert("Usuário sem permissão! Favor entrar em contato com o setor de Ferramentaria")
		Return.f.
	EndIF

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O SOLICITANTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValSolic()
	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+cSolic))
	If QAA->(!Found())
		Alert("Funcionário não encontrado!")
		Return .F.
	Else
		cNomSolic := QAA->QAA_NOME
		cCC := QAA->QAA_CC
		oGet4:Refresh()
		oGet6:Refresh()
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCC()
Local _cLogin
Local _lRet := .F.

	CTT->(DbSetOrder(1)) // FILIAL + CC
	CTT->(DbSeek(xFilial("CTT")+cCC))
    If CTT->(!Found()) .AND. !Empty(cCC)
    	Alert("Centro de custo não encontrado!")
    	Return .F.
    EndIf
    
//-- retirado pelo chamado 009962 do helpdesk    
    
/*
    If Empty(cSolic)
    	Alert("Informe o solicitante!")
    	cCC:=Space(9)
    	oGet6:Refresh()
    	oGet4:SetFocus()
    	Return .T.
    EndIf

	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+cSolic))
	If !Empty(QAA->QAA_LOGIN)
		_cLogin := AllTrim(QAA->QAA_LOGIN)
		
		//Verifica se o usuario tem acesso ao centro de custo
		ZRJ->(DbSetOrder(1))
		ZRJ->(DbSeek(xFilial("ZRJ")+_cLogin))

		While !ZRJ->(Eof()) .AND. Alltrim(ZRJ->ZRJ_LOGIN) == _cLogin

			If Alltrim(ZRJ->ZRJ_CC) == "<todos>"
				_lRet := .T.
				Exit
			Endif

			If Alltrim(ZRJ->ZRJ_CC) == Alltrim(cCC)
				_lRet := .T.
				Exit
			Endif
	
			ZRJ->(DbSkip())

		Enddo
	EndIf                                   

	//verifica o C.Custo do funcionario na tabela qaa
	If !_lRet
 		If Alltrim(cCC) <> Alltrim(QAA->QAA_CC)
	     	Alert("ATENCAO: Centro de Custo "+ Alltrim(cCC) +" é Diferente do Centro de Custo " +Alltrim(QAA->QAA_CC)+" Do Cadastro do funcionario !!!!!!!!")
		 	cCC := Space(09)
		 	oGet6:Refresh()
         	Return .F.
	  	Endif
   Endif
*/
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O BEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValBem()
    ST9->(DbSetOrder(1)) // FILIAL + CODBEM
    ST9->(DbSeek(xFilial("ST9")+cCodBem))
    If ST9->(!Found()) .AND. !Empty(cCodBem)
    	Alert("Bem não encontrado!")
    	Return .F.
	Else
	
		If ALLTRIM(UPPER(ST9->T9_CENTRAB))$"FAB-04/UTI-04"
			Alert("Atenção, Para Máquinas da Forjaria, favor utilizar outra rotina (OS Ferram. Forjaria)!")
			Return .f.
		Endif
	
		cDescBem := ST9->T9_NOME
		oGet9:Refresh()
    EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValDisp()
	ZBN->(DbSetOrder(1)) // FILIAL + CODDISP + LETRA
	ZBN->(DbSeek(xFilial("ZBN")+cDisp))
	If ZBN->(!Found())
		If !EMPTY(cDisp)
			Alert("Dispositivo não encontrado")
			Return .F.
		EndIf
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O DISPOSITIVO E A LETRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValLetra()
	ZBN->(DbSetOrder(1)) // FILIAL + CODDISP + LETRA
	ZBN->(DbSeek(xFilial("ZBN")+cDisp+cLetra))
	If ZBN->(!Found())
		If !Empty(cDisp) .or. !Empty(cLetra)
			Alert("Letra do Dispositivo não encontrado")
			Return .F.
		EndIf
	Else
		cDesDisp := ZBN->ZBN_DESC
		oGet12:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CHAMADO NO MOMENTO DA MUDANCA DO COMBOBOX 2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fSrvChange()
	If Substr(cServRe,1,1)=="1"
		cDesServ := Space(50)
	ElseIf Substr(cServRe,1,1)=="3"
		cCodDes := Space(20)
	Else
		cDesServ := Space(50)
		cCodDes := Space(20)
	EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS DADOS NAS VARIAVEIS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
	
	cOrdem   := ZBT->ZBT_ORDEM
	dDatIni  := ZBT->ZBT_DATINI
	cHorIni  := ZBT->ZBT_HORINI
	dDatFim  := ZBT->ZBT_DATFIM
	cHorFim  := ZBT->ZBT_HORFIM
	dDatPrv  := ZBT->ZBT_DATPRV
	cSolic   := ZBT->ZBT_SOLIC
	cCaldei	 := ZBT->ZBT_CALDEI
                            
	QAA->(DbSetOrder(1)) // filial + mat
	If QAA->(DbSeek(xFilial("QAA")+cSolic))
		cNomSolic := QAA->QAA_NOME
	EndIf

	cCC      := ZBT->ZBT_CC
	nQuant   := ZBT->ZBT_QUANT
	cCodBem  := ZBT->ZBT_CODBEM
	
	ST9->(DbSetOrder(1)) // filial + codbem
	If ST9->(DbSeek(xFilial("ST9")+cCodBem))
		cDescBem := ST9->T9_NOME
	EndIf
	
	cDisp    := ZBT->ZBT_DISP
	cLetra   := ZBT->ZBT_LETRA

	ZBN->(DBsetOrder(1)) //FILIAL + DISP + LETRA
	If ZBN->(DbSeek(xFilial("ZBN")+cDisp+cLetra))
		cDesDisp := ZBN->ZBN_DESC
	EndIf

	cSituac  := ZBT->ZBT_MAQSIT
	cServRe  := ZBT->ZBT_SERVRE
	cCodDes  := ZBT->ZBT_CODDES
	cDesServ := ZBT->ZBT_DESSRV
	cDesc    := ZBT->ZBT_DESC
	cSoluc   := ZBT->ZBT_SOLUC
	cTermino := ZBT->ZBT_TERMIN
	cFabr    := Val(ZBT->ZBT_FABRIC)
	
Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()

	If Empty(cSolic)
		Alert("Informe o solicitante!")
		Return .F.
	EndIf
	
	If Empty(nQuant)
		Alert("Informe a quantidade!")
		Return .F.
	EndIf
	
	If Empty(cSituac)
		Alert("Informe a situação!")
		Return .F.
	EndIf
	
	If Empty(cCaldei)
		Alert("Informe a Origem da OS!")
		Return .F.
	EndIf
	
	If Substr(cSituac,1,1)$"1/2" .AND. (AllTrim(cCodBem)=="020/000" .OR. Empty(cCodBem))
		Alert("O campo Máquina não pode ser em branco ou igual a 020/000 para esta situação!")
		Return .F.
	EndIf
	
	If Empty(cCodBem)
	    Alert("Informe a máquina!")
	    Return .F.
	EndIf
	
	If Empty(cDesc)
		Alert("Informe a descrição do serviço!")
		Return .F.
	EndIf
	
	If Empty(cFabr)
		Alert("Informe a Fábrica!")
		Return .F.
	EndIf
	
	If Empty(cSituac)
		alert("Informe a Situação da Máquina!")
		Return .F.
	EndIf

	If Empty(cServRe)
		Alert("Informe Serviço realizado através!")
		Return .F.
	EndIf
	
	If nPar==6 //Finaliza
		
		If Empty(dDatFim)
			Alert("Informe a data de entrega!")
			Return .F.
		EndIf
		
		If Empty(cHorFim) .or. ;
		   AllTrim(cHorFim)==":" .or. ;
		   Len(Alltrim(cHorFim))!=5 .or. ;
		   Substr(cHorFim,1,2) > "24" .or. ;
		   Substr(cHorFim,4,2) > "59"
		   
			Alert("Informe a hora de entrega corretamente!")
			Return .F.
		EndIf    
		
		If dDatFim < dDatIni
			Alert("Data final não pode ser menor que a data inicial!")
			Return .F.
		EndIf
		
		If dDatFim > dDatabase
			Alert("Data final não pode ser maior que a data atual!")
			Return .F.
		EndIf
		
		If dDatFim==Date() .and. cHorFim > Time()
			Alert("Hora final não pode ser maior que a hora atual!")
			Return .F.
		EndIf
		
		If dDatFim == dDatIni .and. cHorIni > cHorFim
			Alert("Hora final inválida!")
			Return .F.
		EndIf
	
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()

	If !fValida()
		Return
	EndIf 
	
	RecLock("ZBT",.T.)
		ZBT->ZBT_FILIAL := xFilial("ZBT")
		ZBT->ZBT_ORDEM  := cOrdem
		ZBT->ZBT_DATINI := dDatIni
		ZBT->ZBT_HORINI := cHorIni
		ZBT->ZBT_DATFIM := CTOD("  /  /  ")
		ZBT->ZBT_HORFIM := ""
		ZBT->ZBT_DATPRV := dDatPrv
		ZBT->ZBT_SOLIC  := cSolic
		ZBT->ZBT_CC     := cCC
		ZBT->ZBT_QUANT  := nQuant
		ZBT->ZBT_CODBEM := cCodBem
		ZBT->ZBT_DISP   := cDisp
		ZBT->ZBT_LETRA  := cLetra
		ZBT->ZBT_MAQSIT := Substr(cSituac,1,1)
		ZBT->ZBT_CALDEI := SubStr(cCaldei,1,1)
		ZBT->ZBT_SERVRE := Substr(cServRe,1,1)
		ZBT->ZBT_CODDES := cCodDes
		ZBT->ZBT_DESSRV := cDesServ
		ZBT->ZBT_DESC   := cDesc
		ZBT->ZBT_SOLUC  := ""
		ZBT->ZBT_TERMIN := cTermino
		ZBT->ZBT_FABRIC := StrZero(oCombo3:nAt,1)//Substr(cFabr,1,1)
	MsUnlock("ZBT")
	
	ConfirmSx8()
	
	// Adicionado em 20/02/2013 - OS 41356 		
	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+cSolic))
	If QAA->(Found())
	   If AllTrim(QAA->QAA_CC) == '33003003'	   
	   	  oMail := Email():New()

		  // HTML
		  oMail:cMsg := ' <html><head> <style> .tit_cpo{ background:#eeeeee; font-weight:bold;text-decoration:underline;} '
		  oMail:cMsg += ' .tab_dados td{color:#444444;font-size:15px;font-family:arial;text-align:center;}'		  
  		  oMail:cMsg += ' </style><table border="0" bgcolor="FFFFFF" cellspacing="0" cellpadding="11"> ' 		  
		  oMail:cMsg += ' <tr><td style="background:#777777" width="30">&nbsp;</td><td>&nbsp;</td> '  		  
  		  oMail:cMsg += ' <td style="font-weight:bold">*** AVISO DE ABERTURA DE OS NA FERRAMENTARIA ***</td></tr> '
  		  oMail:cMsg += ' </table><br><br> '
  		  oMail:cMsg += ' <table class="tab_dados" border="3" cellspacing="0" cellpadding="12"> '
  		  oMail:cMsg += ' <tr><td class="tit_cpo">Ordem de Serviço:</td> '
  		  oMail:cMsg += ' <td> '+cOrdem+' </td><td class="tit_cpo">Dispositivo/Letra:</td> '
  		  oMail:cMsg += ' <td> '+cDisp+'/ '+cLetra+' </td></tr><tr> '
  		  oMail:cMsg += ' <td class="tit_cpo">Previsão de Entrega:</td> '
  		  oMail:cMsg += ' <td> '+DtoC(dDatPrv)+' </td> '
  		  oMail:cMsg += ' <td class="tit_cpo">Fábrica:</td> '
   		  oMail:cMsg += ' <td> '+cFabr+' </td> </tr> '
   		  oMail:cMsg += ' <tr><td class="tit_cpo">Solicitante:</td> '
   		  oMail:cMsg += ' <td> '+AllTrim(QAA->QAA_NOME)+' </td> '
   		  oMail:cMsg += ' <td class="tit_cpo" rowspan="2">Desc:</td> '
   		  oMail:cMsg += ' <td rowspan="2"> '+AllTrim(cDesc)+' </td></tr> '
   		  oMail:cMsg += ' <tr><td class="tit_cpo">Maquina:</td><td> '+AllTrim(cCodBem)+' </td></tr></table> '
   		  oMail:cMsg += ' <br><br> '
   		  
		  oMail:cAssunto := '*** AVISO DE ABERTURA DE OS NA FERRAMENTARIA ***'  
		  oMail:cTo := 'romulodb@whbbrasil.com.br'
		  oMail:Envia()
	   EndIf
	EndIf
	
	oDlg:End()                      		

	U_MNT43PRN()
	
Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()

	If !fValida()
		Return
	EndIf 
	
	RecLock("ZBT",.F.)
		ZBT->ZBT_DATINI := dDatIni
		ZBT->ZBT_HORINI := cHorIni
		ZBT->ZBT_DATFIM := CTOD("  /  /  ")
		ZBT->ZBT_HORFIM := ""
		ZBT->ZBT_DATPRV := dDatPrv
		ZBT->ZBT_SOLIC  := cSolic
		ZBT->ZBT_CC     := cCC
		ZBT->ZBT_QUANT  := nQuant
		ZBT->ZBT_CODBEM := cCodBem
		ZBT->ZBT_DISP   := cDisp
		ZBT->ZBT_LETRA  := cLetra
		ZBT->ZBT_MAQSIT := Substr(cSituac,1,1)
		ZBT->ZBT_CALDEI := SubStr(cCaldei,1,1)
		ZBT->ZBT_SERVRE := Substr(cServRe,1,1)
		ZBT->ZBT_CODDES := cCodDes
		ZBT->ZBT_DESSRV := cDesServ
		ZBT->ZBT_DESC   := cDesc
		ZBT->ZBT_FABRIC := StrZero(oCombo3:nAt,1)//Substr(cFabr,1,1)
	MsUnlock("ZBT")
	
	oDlg:End()                                             		

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI A OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fExclui()
	
	If MsgYesNo("Tem certeza de que deseja excluir a OS: "+cOrdem+"?")
		RecLock("ZBT",.F.)
			ZBT->(DbDelete())
		MsUnlock("ZBT")
	EndIf
	
	// EXCLUI OS INSUMOS DA OS
	ZBU->(DbSetOrder(1)) // FILIAL + ORDEM
	If ZBU->(DbSeek(xFilial("ZBU")+cOrdem))

		WHILE ZBU->(!EoF()) .AND. ZBU->ZBU_ORDEM==cOrdem
			
			RecLock("ZBU",.F.)
				ZBU->(DbDelete())
			MsUnlock("ZBU")
		     
			ZBU->(Dbskip())
		ENDDO

	EndIf

	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FINALIZA A OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fFinal()
	
	If !fValida()
		Return
	EndIf
	
	RecLock("ZBT",.F.)
		ZBT->ZBT_DATFIM := dDatFim
		ZBT->ZBT_HORFIM := cHorFim
		ZBT->ZBT_SOLUC  := cSoluc
		ZBT->ZBT_TERMIN := "S"
	MsUnLock("ZBT")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REABRE A OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fReabre()
	If MsgYesNo("Tem certeza de que deseja reabrir a OS "+ZBT->ZBT_ORDEM+"?")

		RecLock("ZBT",.F.)
			ZBT->ZBT_DATFIM := CtoD("  /  /  ")
			ZBT->ZBT_HORFIM := Space(5)
			ZBT->ZBT_SOLUC  := ""
			ZBT->ZBT_TERMIN := "N"
		MsUnLock("ZBT")
	
	EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ 

/*

ALTERAÇÃO REALIZADA EM 21/10/2010 REFERENTE AO CHAMADO Nº: 009959 (GLEISON RIDAN JURKEVITCH PEREIRA).
"No modulo manutenção de ativos / ordem de serviço ferramentaria criar algo que permita à ferramentaria distinguir visualmente a situação de 
MÁQUINA PARADA e tambem a atividade especifica de CÉLULA DE SOLDA. Sugestão: existem 2 cores hoje verde(o.s. aberta); vermelho(o.s. finalizada) - 
poderiamos ter outras 2 cores: amarelo(máquina parada) e azul(célula de solda)

REALIZADA POR FELIPE CICONINI

*/

//===============================================//
// Configuração do Ambiente para Impressão Cupom //
//===============================================//
User Function NHPRN043()

Local 	lFlag		:=	.T.
Private cBmpLogo	:= "\system\logo_whb.bmp"
Private cBmpLinha	:= "\system\LinhaVerde.bmp"

Private oFnt02      := TFont():New("Arial"		,,10,,.F.,,,,,.F.) 
Private oFnt02n     := TFont():New("Arial"		,,10,,.T.,,,,,.F.) 
Private oFnt06		:= TFont():New("Courier New",,06,,.f.,,,,,.f.)
Private oFnt06n  	:= TFont():New("Courier New",,06,,.t.,,,,,.f.)
Private oFnt07		:= TFont():New("Courier New",,07,,.f.,,,,,.f.)
Private oFnt07n		:= TFont():New("Courier New",,07,,.t.,,,,,.f.)
Private oFnt08		:= TFont():New("Courier New",,08,,.f.,,,,,.f.)
Private oFnt08n		:= TFont():New("Courier New",,08,,.t.,,,,,.f.)
Private oFnt09		:= TFont():New("Courier New",,09,,.f.,,,,,.f.)
Private oFnt09n		:= TFont():New("Courier New",,09,,.t.,,,,,.f.)
Private oFnt10		:= TFont():New("Courier New",,10,,.f.,,,,,.f.)
Private oFnt10n		:= TFont():New("Courier New",,10,,.t.,,,,,.f.)
Private oFnt11		:= TFont():New("Courier New",,11,,.f.,,,,,.f.)
Private oFnt11n		:= TFont():New("Courier New",,11,,.t.,,,,,.f.)
Private oFnt12		:= TFont():New("Courier New",,12,,.f.,,,,,.f.)
Private oFnt12n		:= TFont():New("Courier New",,12,,.t.,,,,,.f.)
Private oFnt13		:= TFont():New("Courier New",,13,,.f.,,,,,.f.)
Private oFnt13n		:= TFont():New("Courier New",,13,,.t.,,,,,.f.)
Private oFnt14		:= TFont():New("Courier New",,14,,.f.,,,,,.f.)
Private oFnt14n		:= TFont():New("Courier New",,14,,.t.,,,,,.f.)
Private oFnt15		:= TFont():New("Courier New",,15,,.f.,,,,,.f.)
Private oFnt15n		:= TFont():New("Courier New",,15,,.t.,,,,,.f.)
Private oFnt16		:= TFont():New("Courier New",,16,,.f.,,,,,.f.)
Private oFnt16n		:= TFont():New("Courier New",,16,,.t.,,,,,.f.)
Private oFnt17		:= TFont():New("Courier New",,17,,.f.,,,,,.f.)
Private oFnt17n		:= TFont():New("Courier New",,17,,.t.,,,,,.f.)
Private oFnt18		:= TFont():New("Courier New",,18,,.f.,,,,,.f.)
Private oFnt18n		:= TFont():New("Courier New",,18,,.t.,,,,,.f.)
Private oFnt19		:= TFont():New("Courier New",,19,,.f.,,,,,.f.)
Private oFnt19n		:= TFont():New("Courier New",,19,,.t.,,,,,.f.)
Private oFnt20		:= TFont():New("Courier New",,20,,.f.,,,,,.f.)
Private oFnt20n		:= TFont():New("Courier New",,20,,.t.,,,,,.f.)
Private oFnt22		:= TFont():New("Courier New",,22,,.f.,,,,,.f.)
Private oFnt22n		:= TFont():New("Courier New",,22,,.t.,,,,,.f.)
Private nLinInc		:= 02*5
Private nColInc		:= 02*6
Private nRecNo		:= 0
Private nMaxItem	:= 40
Private nLin        := 03
Private nCol        := 03
Private aSituac     := {"Máq. Parada",;
"Máq. Deficiente",;
"Processo Normal",;
"Reposição Estoque",;
"Prioridade"}

Private aServRe     := {"Desenho",;
"Amostra",;
"Outros"}

oPrn:= TMSPrinter():New("ORDEM DE SERVIÇO PARA FERRAMENTARIA")//Cria Objeto para impressao Grafica
oPrn:Setup()        //Chama a rotina de Configuracao da impressao
	oPrn:StartPage() //Cria nova Pagina
		sfCabec()        //Impressao do Cabecalho
		sfDados()        //Dados do Box01
	oPrn:EndPage()   //Finaliza a Pagina
oPrn:End()
oPrn:Print()

Return NIL

//=================================//
// Impressão do Cabeçalho do Cupom //
//================================//
Static Function sfCabec()

oPrn:Box(nLinInc,nColInc,nLin*45,nCol*270) //Box do Cabeçalho
oPrn:SayBitmap(nLin*10,nColInc+nCol,cBmpLogo,nCol*18,nLin*7)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)

oPrn:Say (nLin*008,nCol*03, padc(Substr(Alltrim(SM0->M0_NOME),1,12) + "/Filial:" + SubStr(Alltrim(SM0->M0_FILIAL),1,12),42)              , oFnt02n, 100)
oPrn:Say (nLin*020,nCol*03, padc('ORDEM DE SERVIÇO PARA FERRAMENTARIA',40)                                                               , oFnt10n, 100)
oPrn:Say (nLin*030,nCol*05,' Hora:'+ Time()+'      Emissão:'+Dtoc(Date())                                                                , oFnt10n, 100)

oPrn:Say (nLin*045,nCol*05,'Número....................: ' + ZBT->ZBT_ORDEM                                                                      , oFnt02n, 100)
oPrn:Say (nLin*060,nCol*05,'Data Pedido.....: ' + Dtoc(ZBT->ZBT_DATINI)                                                                  , oFnt08n, 100)
oPrn:Say (nLin*070,nCol*05,'Prazo de Entrega: ' + Dtoc(ZBT->ZBT_DATPRV)                                                                  , oFnt08n, 100)

oPrn:Say (nLin*080,nCol*05,'Solicitante................: ' + Posicione("QAA",1,xFilial("QAA")+ZBT->ZBT_SOLIC,"QAA_NOME")                 , oFnt02n, 100)
oPrn:Say (nLin*094,nCol*05,'Matricula.......: ' + ZBT->ZBT_SOLIC                                                                         , oFnt08n, 100)
oPrn:Say (nLin*104,nCol*05,'Centro de Custo.: ' + ZBT->ZBT_CC                                                                            , oFnt08n, 100)
oPrn:Say (nLin*114,nCol*05,'Setor...........: ' + Posicione("CTT",1,xFilial("CTT")+ZBT->ZBT_CC,"CTT_DESC01")                             , oFnt08n, 100)
oPrn:Say (nLin*124,nCol*05,'Quantidade......: ' + AllTrim(Str(ZBT->ZBT_QUANT)) + ' Máquina: '+ZBT->ZBT_CODBEM                            , oFnt08n, 100)
oPrn:Say (nLin*136,nCol*05,'Situação..................: ' + aSituac[Val(ZBT->ZBT_MAQSIT)]                                                , oFnt02n, 100)
oPrn:Say (nLin*150,nCol*05,'Servico.........: ' + aServRe[Val(ZBT->ZBT_SERVRE)]                                                          , oFnt08n, 100)
oPrn:Say (nLin*160,nCol*05,'------------------ Descricao -------------------'                                                            , oFnt08n, 100)
                                                       
nLin := nLin*170

For x:=1 To MlCount(ALLTRIM(ZBT->ZBT_DESC),45)
	
	oPrn:Say (nLin,nCol*5,MemoLine(ZBT->ZBT_DESC,45,x),oFnt08n)
	nLin += 25
	
Next

nLin += 25

If ZBT->ZBT_TERMIN=="S"
	
	oPrn:Say (nLin,nCol*05,'------------------- Solucao --------------------'                                                            , oFnt08n, 100)
	
	nLin += 25
	
	For x:=1 To MlCount(ALLTRIM(ZBT->ZBT_SOLUC),045)
		
		oPrn:Say (nLin,nCol*5,MemoLine(ZBT->ZBT_SOLUC,045,x),oFnt08n)
		nLin += 25
		
	Next
	
Endif

Return
                  
//================================================//
//Impressão da Lista de Itens da Ordem de Serviço //
//================================================//
Static Function sfDados()
Local nCont		:=	000
Local lFlag		:=	.T.

ZBU->(DBSetOrder(1)) //Filal + Ordem
ZBU->( DbGoTop() )
If ZBU->(dbSeek(xFilial("ZBU")+ZBT->ZBT_ORDEM))
	oPrn:Say (nLin,nCol*03,'------------------------------------------------' , oFnt10n, 100)
	nLin += 25
	oPrn:Say (nLin,nCol*03,'Insumos                                         ' , oFnt10n, 100)
	nLin += 25
	oPrn:Say (nLin,nCol*03,'Inicio            Fim              Duração      ' , oFnt10n, 100)
	nLin += 25
	oPrn:Say (nLin,nCol*03,'Observação                                      ' , oFnt10n, 100)
	nLin += 20
	oPrn:Say (nLin,nCol*03,'------------------------------------------------' , oFnt10n, 100)
	nLin += 20
	
	Do While ZBU->(!EoF()) .And. ZBU->ZBU_ORDEM==ZBT->ZBT_ORDEM
		
		If ZBU->ZBU_TIPO=="M"
			
			QAA->(dbSetOrder(1))
			If QAA->(dbSeek(xFilial("QAA")+ZBU->ZBU_CODIGO))
				
				oPrn:Say (nLin,nCol*05,ZBU->ZBU_TIPO + ' ' + ZBU->ZBU_CODIGO + ' ' + SubStr(QAA->QAA_NOME,1,30) , oFnt08n, 100)
				nLin += 25
				
			EndIf
			
			oPrn:Say (nLin,nCol*05,Dtoc(ZBU->ZBU_DATINI) + ' ' + AllTrim(ZBU->ZBU_HORINI) + '  ' + Dtoc(ZBU->ZBU_DATFIM) + ' ';
			+ AllTrim(ZBU->ZBU_HORFIM) + '  '  + fDuracao(ZBU->ZBU_DATINI,ZBU->ZBU_DATFIM,ZBU->ZBU_HORINI,ZBU->ZBU_HORFIM), oFnt08n, 100)
			
		ElseIf ZBU->ZBU_TIPO=="P"
			
			SB1->(dbSetOrder(1))
			
			If SB1->(dbSeek(xFilial("SB1")+ZBU->ZBU_CODIGO))
				
				oPrn:Say (nLin,nCol*05,ZBU->ZBU_TIPO + ' ' + ZBU->ZBU_CODIGO + ' ' + SubStr(SB1->B1_DESC,1,30) + ' Quantidade: ' + ALLTRIM(STR(ZBU->ZBU_QUANT)), oFnt08n, 100)
				
			EndIf
			
		EndIf
		
		nLin += 25
		
		For x:=1 To MlCount(ALLTRIM(ZBU->ZBU_DESC),45)
			
			oPrn:Say (nLin,nCol*5,MemoLine(ZBU->ZBU_DESC,45,x),oFnt08n)
			nLin += 25
			
		Next
		
		ZBU->(DBSkip())
		
		nLin += 25
		
		If	(nLin) >= 2500
			oPrn:EndPage()   //Finaliza a Pagina
			oPrn:StartPage( )//Cria nova Pagina
			nLin:= 00
		EndIf
		
	EndDo
	
EndIf

Return

User Function MNT43LEG()

Local aLegenda :=	{ {"BR_VERMELHO", OemToAnsi("Fechada") },;
                      {"BR_VERDE"   , OemToAnsi("Aberta")},;
                      {"BR_AMARELO" , OemToAnsi("Maquina Parada")},;
                      {"BR_AZUL"	, OemToAnsi("Celula de Solda")}}

BrwLegenda(OemToAnsi("Ordem de Serviço de Ferramentaria"), "Legenda", aLegenda)

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A LEGENDA DO BROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()

Local aLegenda :=	{ {"BR_VERMELHO", OemToAnsi("Fechada") },;
                      {"BR_VERDE"   , OemToAnsi("Aberta")},;
                      {"BR_AMARELO" , OemToAnsi("Maquina Parada")},;
                      {"BR_AZUL"	, OemToAnsi("Celula de Solda")}}

Local uRetorno := {}
	Aadd(uRetorno, { 'ZBT_TERMIN=="S"' , aLegenda[1][1] } )
	aAdd(uRetorno, { 'ZBT_CALDEI=="1"' , aLegenda[4][1] } )
	aAdd(uRetorno, { 'ZBT_MAQSIT=="1"' , aLegenda[3][1] } )
	Aadd(uRetorno, { 'ZBT_TERMIN=="N"' , aLegenda[2][1] } )
Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ INSUMOS ³
//ÀÄÄÄÄÄÄÄÄÄÙ
Static Function fInsumo()

	DbSelectArea("ZBU")
	Set Filter To &("ZBU->ZBU_ORDEM == '"+ZBT->ZBT_ORDEM+"'")

   	aRotOld := aClone(aRotina)
	   	
   	cCadastro := "Insumos da O.S. de Ferramentaria"
	aRotina   := {}
	aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
	aAdd(aRotina,{ "Visualizar"	    ,"U_MNT43I(2)" 	, 0 , 2})
	aAdd(aRotina,{ "Incluir"		,"U_MNT43I(3)" 	, 0 , 3})
	aAdd(aRotina,{ "Alterar"		,"U_MNT43I(4)" 	, 0 , 4})
	aAdd(aRotina,{ "Excluir"		,"U_MNT43I(5)" 	, 0 , 5})
			
	mBrowse( 6, 1,22,75,"ZBU",,,,,,)
		
	aRotina := aClone(aRotOld)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DOS INSUMOS DE FERRAMENTARIA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT43I(nParam)
Local aTipo     := {"","P=Produto","M=Mao de Obra"}
Local bOk       := {||}
Local aAguarda  := {"","1=Material",;
					"2=Enviado p/ Terceiro",;
					"3=Disp. de Máquina",;
					"4=Outros"}
Private nPar    := nParam
Private cTipo   := Space(1)  
Private cCodigo := Space(15)
Private cDesCod := ""
Private nQuant  := 0
Private dDatIni := CtoD("  /  /  ")
Private cHorIni := Space(5)
Private dDatFim := CtoD("  /  /  ")
Private cHorFim := Space(5)
Private cAguard := Space(1)
Private cFornec := Space(6)
Private cLoja   := Space(2)
Private cDesFor := ""
Private dDatSai := CtoD("  /  /  ")
Private dDatRet := CtoD("  /  /  ")
Private cAgDesc := Space(50)
Private cDesc   := ""
Private cSC     := Space(6)

	//para OS finalizada somente eh permitido visualizar
	If ZBT->ZBT_TERMIN=="S" .and. nPar!=2
		Alert("O.S. já finalizada!")
		Return
	EndIf
	
	If nPar==2     //visualizar
		fICarrega()
		bOk   := {||oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk   := {||fIInclui()} 
	ElseIf nPar==4 //alterar 
		fICarrega()
		bOk := {||fIAltera()}
	ElseIf nPar==5 //excluir

		If !fRestricao()
			Return
		EndIf

		fICarrega()
		bOk := {||fIExclui()}  
	EndIf

	// TELA
	
	oDlg  := MsDialog():New(0,0,378,600,"Lançamento de Insumo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(8,50,{|u| if(Pcount() > 0,cTipo := u,cTipo)},;
		aTipo,50,20,oDlg,,{||fAltF3()},{||.T.},,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"cTipo")

	oSay2 := TSay():New(22,10,{||"Código"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(20,50,{|u| if(Pcount() > 0, cCodigo := u,cCodigo)},oDlg,70,8,"@!",{||fValCod()},;
		,,,,,.T.,,,{||nPar==3 .Or. nPar==4},,,,,,"","cCodigo")   
	oGet2 := tGet():New(20,121,{|u| if(Pcount() > 0, cDesCod := u,cDesCod)},oDlg,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,"","cDesCod")

	oSay3 := TSay():New(34,10,{||"Quant"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(32,50,{|u| if(Pcount() > 0, nQuant := u,nQuant)},oDlg,50,8,"@e 9,999.99",{||.T.},;
		,,,,,.T.,,,{||cTipo=="P" .and. (nPar==3 .Or. nPar==4)},,,,,,"","nQuant")
		
	oSay4 := TSay():New(46,10,{||"Data Inicial"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(44,50,{|u| if(Pcount() > 0, dDatIni := u,dDatIni)},oDlg,50,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","dDatIni")

	oSay5 := TSay():New(46,120,{||"Hora Inicial"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(44,160,{|u| if(Pcount() > 0, cHorIni := u,cHorIni)},oDlg,40,8,"99:99",{||.T.},;
		,,,,,.T.,,,{||cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","cHorIni")

	oSay6 := TSay():New(58,10,{||"Data Final"},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(56,50,{|u| if(Pcount() > 0, dDatFim := u,dDatFim)},oDlg,50,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","dDatFim")

	oSay7 := TSay():New(58,120,{||"Hora Final"},oDlg,,,,,,.T.,,)
	oGet7 := tGet():New(56,160,{|u| if(Pcount() > 0, cHorFim := u,cHorFim)},oDlg,50,8,"99:99",{||.T.},;
		,,,,,.T.,,,{||cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","cHorFim")

	oSay8 := TSay():New(70,10,{||"Aguarda"},oDlg,,,,,,.T.,,)
	oCombo2 := TComboBox():New(68,50,{|u| if(Pcount() > 0,cAguard := u,cAguard)},;
		aAguarda,60,20,oDlg,,{||.T.},{||fAltAg()},,,.T.,,,,{||cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,"cAguard")

	oSay9 := TSay():New(70,120,{||"S.C."},oDlg,,,,,,.T.,,)
	oGet8  := tGet():New(68,160,{|u| if(Pcount() > 0, cSC := u,cSC)},oDlg,50,8,"@!",{||fValSC()},;
		,,,,,.T.,,,{||Substr(cAguard,1,1)=="1" .AND. (nPar==3 .Or. nPar==4)},,,,,,"SC1","cSC")

	oSay10 := TSay():New(82,10,{||"Fornecedor"},oDlg,,,,,,.T.,,)
	oGet9  := tGet():New(80,50,{|u| if(Pcount() > 0, cFornec := u,cFornec)},oDlg,40,8,"@!",{||fIForn()},;
		,,,,,.T.,,,{||Substr(cAguard,1,1)=="2" .AND. (nPar==3 .Or. nPar==4)},,,,,,"SA2","cFornec")
	oGet10 := tGet():New(80,91,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg,10,8,"@!",{||fILoja()},;
		,,,,,.T.,,,{||Substr(cAguard,1,1)=="2" .AND. (nPar==3 .Or. nPar==4)},,,,,,,"cLoja")
	oGet11 := tGet():New(80,104,{|u| if(Pcount() > 0, cDesFor := u,cDesFor)},oDlg,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,"","cDesFor")

	oSay11 := TSay():New(94,10,{||"Data Saida"},oDlg,,,,,,.T.,,)
	oGet12 := tGet():New(92,50,{|u| if(Pcount() > 0, dDatSai := u,dDatSai)},oDlg,50,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(cAguard,1,1)=="2" .AND. (nPar==3 .Or. nPar==4)},,,,,,,"dDatSai")

	oSay12 := TSay():New(94,120,{||"Prev. Retorno"},oDlg,,,,,,.T.,,)
	oGet13 := tGet():New(92,160,{|u| if(Pcount() > 0, dDatRet := u,dDatRet)},oDlg,50,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(cAguard,1,1)=="2" .AND. (nPar==3 .Or. nPar==4)},,,,,,,"dDatRet")
	
	oSay13 := TSay():New(106,10,{||"Desc. Aguarda"},oDlg,,,,,,.T.,,)
	oGet14 := tGet():New(104,50,{|u| if(Pcount() > 0, cAgDesc := u,cAgDesc)},oDlg,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||Substr(cAguard,1,1)=="4" .AND. (nPar==3 .Or. nPar==4)},,,,,,,"cAgDesc")

	oSay14  := TSay():New(118,10,{||"Descrição"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oMemo1  := tMultiget():New(116,50,{|u|if(Pcount()>0,cDesc:=u,cDesc)},;
	oDlg,240,40,,,,,,.T.,,,{|| nPar==3 .Or. nPar==4 })

	oGroup := tGroup():New(166,05,168,295,,oDlg,,,.T.)

	oBtn1 := tButton():New(174,230,"Ok",oDlg,bOk,30,10,,,,.T.)
	oBtn2 := tButton():New(174,265,"Cancelar",oDlg,{||oDlg:End()},30,10,,,,.T.)
	
	If nPar==4 //alterar
		If Substr(cTipo,1,1)=="P"
			oGet1:cF3 := "SB1"
		ElseIf Substr(cTipo,1,1)=="M"
			oGet1:cF3 := "QAA"
		EndIf
		
		oGet1:Refresh()
	EndIf
	
	oDlg:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O F3 DO CAMPO CODIGO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAltF3()
	
	If Substr(cTipo,1,1)=="P"
		dDatIni := CtoD("  /  /  ")
		cHorIni := Space(8)
		dDatFim := CtoD("  /  /  ")
		cHorFim := Space(8)
		cAguard := "S"
		cCodigo := Space(15)
		oGet1:cF3 := "SB1"
	ElseIf Substr(cTipo,1,1)=="M"
		nQuant  := 0
		cCodigo := Space(6)
		oGet1:cF3 := "QAA"
	EndIf
	
	oGet1:Refresh()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DO CODIGO DO INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCod()

	If cTipo=="P"
		SB1->(DbSetOrder(1))//filial + cod
		SB1->(DbSeek(xFilial("SB1")+cCodigo))
		If SB1->(!Found())
			Alert("Produto não encontrado!")
			Return .F.
		Else
			cDesCod := SB1->B1_DESC
			oGet2:Refresh()
		EndIf
	EndIf
	
	If cTipo=="M"
		QAA->(DbSetOrder(1))
		QAA->(DbSeek(xFilial("QAA")+cCodigo))
		If QAA->(!Found())
			Alert("Funcionario não encontrado!")
			Return .F.
		Else
			cDesCod := QAA->QAA_NOME
			oGet2:Refresh()
		EndIf
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIForn()
	
	If SA2->A2_COD!=cFornec
		SA2->(DbSetOrder(1)) // FILIAL + FORN + LOJA
		SA2->(DbSeek(xFilial("SA2")+cFornec))
		If SA2->(!Found())
			Alert("Fornecedor não encontrado!")
			Return .F.
		Else
			cLoja := SA2->A2_LOJA
			oGet10:Refresh()
		EndIF
	EndIf
	
	cLoja := SA2->A2_LOJA
	oGet10:Refresh()

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA E TRAZ A DESCRICAO DO FORNECEDOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fILoja()
	SA2->(DbSetOrder(1)) // FILIAL + FORN + LOJA
	SA2->(DbSeek(xFilial("SA2")+cFornec+cLoja))
	
	If SA2->(!Found())
		Alert("Loja não encontrada!")
		Return .F.
	Else
		cDesFor := SA2->A2_NOME
		oGet11:Refresh()
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIValida()

	If Empty(cTipo)
		Alert("Informe o tipo do insumo!")
		Return .F.
	EndIf

	If Empty(cCodigo)
		Alert("Informe o insumo!")
		Return .F.
	EndIf

	If cTipo=="P"
		If Empty(nQuant)
			Alert("Informe a quantidade do insumo!")
			Return .F.
		EndIf
	EndIf
	
	If Empty(cDesc)
		Alert("Informe a descrição!")
		Return .F.
	EndIf
	
	If cTipo=="M"
		If Empty(dDatIni)
			Alert("Informe a data inicial do insumo!")
			Return .F.
		EndIf
		
		If Empty(dDatFim)
			Alert("Informe a data final do insumo!")
			Return .F.
		EndIf
	
		If Empty(cHorIni)
			Alert("Informe a hora inicial do insumo!")
			Return .F.
		EndIf
	
		If Empty(cHorFim)
			Alert("Informe a hora final do insumo!")
			Return .F.
		EndIf
	
		If dDatFim < dDatIni
			Alert("Data final não pode ser inferior a data inicial!")
			Return .F.
		EndIf
		
		If dDatFim==dDatIni .AND. cHorFim < cHorIni
			Alert("Data e hora final não podem ser inferiores a data e hora inicial!")
			Return .F.
		EndIf
		
		//Aguarda
		If Substr(cAguard,1,1)=="1" //Aguarda Material
			If Empty(cSC)
				Alert("Informe a SC!")
				Return .F.
			EndIf
		ElseIf Substr(cAguard,1,1)=="2" //Enviado p/ Terceiro

			If Empty(cFornec) .Or. Empty(cLoja)
				Alert("Informe o fornecedor e a loja!")
				Return .F.						
			EndIf
			
			If Empty(dDatSai)
				Alert("Informe a data de saída!")
				Return .F.
			EndIf
			
			If Empty(dDatRet)
				Alert("Informe a previsão de retorno!")
				Return .F.
			EndIf
			
			If dDatSai > dDatRet
				Alert("Previsão de retorno não pode ser inferior a data de saída!")
				Return .F.
			EndIf

		ElseIf Substr(cAguard,1,1)=="4" //Aguardando disp. de maquina
			If Empty(cAgDesc)
				Alert("Informe a descrição do aguardo!")
				Return .F.
			EndIf
		EndIf
		
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fIInclui()

	If !fIValida()
	    Return
	EndIf 
	
	RecLock("ZBU",.T.)
		ZBU->ZBU_FILIAL := xFilial("ZBU")
		ZBU->ZBU_ORDEM  := ZBT->ZBT_ORDEM
		ZBU->ZBU_TIPO   := cTipo 
		ZBU->ZBU_CODIGO := cCodigo
		ZBU->ZBU_QUANT  := nQuant
		ZBU->ZBU_DATINI := dDatIni
		ZBU->ZBU_HORINI := cHorIni
		ZBU->ZBU_DATFIM := dDatFim
		ZBU->ZBU_HORFIM := cHorFim
		ZBU->ZBU_AGUARD := cAguard
		ZBU->ZBU_FORNEC := cFornec
		ZBU->ZBU_LOJA   := cLoja
		ZBU->ZBU_NUMSC  := cSC
		ZBU->ZBU_DATSAI := dDatSai
		ZBU->ZBU_DATRET := dDatRet
		ZBU->ZBU_AGDESC := cAgDesc
		ZBU->ZBU_DESC   := cDesc
	MsUnlock("ZBU") 
	
	oDlg:End()

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIAltera()

	If !fIValida()
		Return
	EndIf
	
	RecLock("ZBU",.F.)
		ZBU->ZBU_TIPO   := cTipo 
		ZBU->ZBU_CODIGO := cCodigo
		ZBU->ZBU_QUANT  := nQuant
		ZBU->ZBU_DATINI := dDatIni
		ZBU->ZBU_HORINI := cHorIni
		ZBU->ZBU_DATFIM := dDatFim
		ZBU->ZBU_HORFIM := cHorFim
		ZBU->ZBU_AGUARD := cAguard
		ZBU->ZBU_FORNEC := cFornec
		ZBU->ZBU_LOJA   := cLoja
		ZBU->ZBU_NUMSC  := cSC
		ZBU->ZBU_DATSAI := dDatSai
		ZBU->ZBU_DATRET := dDatRet
		ZBU->ZBU_AGDESC := cAgDesc
		ZBU->ZBU_DESC   := cDesc
	MsUnLock("ZBU")
	
	oDlg:End()

Return    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIExclui()
	
	If MsgYesNo("Tem certeza de que deseja excluir este insumo?")
		RecLock("ZBU",.F.)
			ZBU->(DbDelete())
		MsUnLock("ZBU")
	EndIf

	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A SOLICITACAO DE COMPRAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValSC()

	SC1->(DbSetOrder(1)) // FILIAL + NUMSC
	SC1->(DbSeek(xFilial("SC1")+cSC))
	
	If SC1->(!Found())
		Alert("Solicitação de Compras não encontrada!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ APAGA AS VARIAVEIS CONTROLADAS PELO CAMPO AGUARDA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAltAg()

	cSC := Space(6)
	oGet8:Refresh()

	cFornec := Space(6)
	oGet9:Refresh()
	cLoja := Space(2)
	oGet10:Refresh()
	cDesFor := ""
	oGet11:Refresh()

	dDatSai := CtoD("  /  /  ")
	oGet12:Refresh()

	dDatRet := CtoD("  /  /  ")
	oGet13:Refresh()
	
	cAgDesc := space(50)
	oGet14:Refresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA AS VARIAVEIS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fICarrega()
	
	cTipo   := ZBU->ZBU_TIPO
	cCodigo := ZBU->ZBU_CODIGO

	If cTipo=="P"
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+cCodigo))
		cDesCod := SB1->B1_DESC
	ElseIf cTipo=="M"
		QAA->(DbSetOrder(1))
		QAA->(DbSeek(xFilial("QAA")+cCodigo))
		cDesCod := QAA->QAA_NOME
	EndIf
	
	nQuant  := ZBU->ZBU_QUANT
	dDatIni := ZBU->ZBU_DATINI
	cHorIni := ZBU->ZBU_HORINI
	dDatFim := ZBU->ZBU_DATFIM
	cHorFim := ZBU->ZBU_HORFIM
	cAguard := ZBU->ZBU_AGUARD
	cFornec := ZBU->ZBU_FORNEC
	cLoja   := ZBU->ZBU_LOJA
	
	If Substr(cAguard,1,1)=="2"
		SA2->(DbSetOrder(1)) // FILIAL + FORN + LOJA
		SA2->(DbSeek(xFilial("SA2")+cFornec+cLoja))
		
		cDesFor := SA2->A2_NOME
	EndIf

	cSC     := ZBU->ZBU_NUMSC
	dDatSai := ZBU->ZBU_DATSAI
	dDatRet := ZBU->ZBU_DATRET
	cAgDesc := ZBU->ZBU_AGDESC
	cDesc   := ZBU->ZBU_DESC
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IMPRESSÃO DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT43IMP()
Private oRelato 

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZBT"
    oRelato:cPerg    := "MNT043"
	oRelato:cNomePrg := "NHMNT043"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "M"

	//descricao
	oRelato:cDesc1   := "Este relatório apresenta as Ordens de Serviço "
	oRelato:cDesc2   := "de Ferramentas. "
	oRelato:cDesc3   := ""

	//titulo
	oRelato:cTitulo  := "ORDEM DE SERVIÇO PARA FERRAMENTARIA"

	//cabecalho
	oRelato:cCabec1  := ""
    oRelato:cCabec2  := ""
		    
	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Private aSituac   := {"Máq. Parada",;
                      "Máq. Deficiente",;
					  "Processo Normal",;
					  "Reposição Estoque",;
					  "Prioridade"}

Private aServRe   := {"Desenho",;
					  "Amostra",;
					  "Outros"}

	oRelato:Cabec()
	
	@Prow() +1,001 psay "Número: "+ZBT->ZBT_ORDEM
	
	@Prow() +1,001 psay "Data pedido: "+DtoC(ZBT->ZBT_DATINI)
	@Prow()   ,060 psay "Prazo de Entrega: "+DtoC(ZBT->ZBT_DATPRV)

	@Prow() +1,001 psay "Solicitante: "+Posicione("QAA",1,xFilial("QAA")+ZBT->ZBT_SOLIC,"QAA_NOME")
	@Prow()   ,060 psay "Matrícula: "+ZBT->ZBT_SOLIC
	                                                
	@Prow() +1,001 psay "C.Custo: "+ZBT->ZBT_CC
	@Prow()   ,060 psay "Setor: "+Posicione("CTT",1,xFilial("CTT")+ZBT->ZBT_CC,"CTT_DESC01")
	
	@Prow() +1,001 psay "Quantidade: "+Alltrim(Str(ZBT->ZBT_QUANT))
	@Prow()   ,060 psay "Máquina: "+ZBT->ZBT_CODBEM
	
	@Prow() +1,001 psay "Situação: "+aSituac[Val(ZBT->ZBT_MAQSIT)]
	@Prow()   ,060 psay "Serviço: "+aServRe[Val(ZBT->ZBT_SERVRE)]

	@Prow() +2,001 psay "Descrição: "
	For x:=1 To MlCount(ALLTRIM(ZBT->ZBT_DESC),100)
  		@Prow()+Iif(x==1,0,1) , 12 Psay MemoLine(ZBT->ZBT_DESC,100,x)
	Next

	If ZBT->ZBT_TERMIN=="S"
		@Prow()+2, 001 Psay "Solução: "
		For x:=1 To MlCount(ALLTRIM(ZBT->ZBT_SOLUC),100)
  			@Prow()+Iif(x==1,0,1) , 012 Psay MemoLine(ZBT->ZBT_SOLUC,100,x)
		Next
	EndIf
		    
	/**********
	* INSUMOS *
	**********/
	ZBU->(dbSetOrder(1))// filial + ordem
	If ZBU->(dbSeek(xFilial("ZBU")+ZBT->ZBT_ORDEM))
	
		@Prow()+2 , 001 Psay "INSUMOS "+Repli("-",48)+"inicio"+Repli("-",13)+"fim"+Repli("-",10)+"duração"+Repli("-",37)
		
		While ZBU->(!EOF()) .AND. ZBU->ZBU_ORDEM==ZBT->ZBT_ORDEM

			If Prow() > 65
				oRelato:Cabec()
			EndIf

			@Prow()+1 , 001 Psay ZBU->ZBU_TIPO
			@Prow()   , 003 Psay ZBU->ZBU_CODIGO
			
			If ZBU->ZBU_TIPO=="M"

				QAA->(dbSetOrder(1))
				If QAA->(dbSeek(xFilial("QAA")+ZBU->ZBU_CODIGO))
					@Prow()   , 020 Psay SUBSTR(QAA->QAA_NOME,1,30)
				EndIf
				
				@Prow()   , 052 Psay ZBU->ZBU_DATINI
				@Prow()   , 063 Psay AllTrim(ZBU->ZBU_HORINI)
				@Prow()   , 071 Psay ZBU->ZBU_DATFIM
				@Prow()   , 082 Psay AllTrim(ZBU->ZBU_HORFIM)
				@Prow()   , 090 Psay fDuracao(ZBU->ZBU_DATINI,ZBU->ZBU_DATFIM,ZBU->ZBU_HORINI,ZBU->ZBU_HORFIM)
				
			ElseIf ZBU->ZBU_TIPO=="P"
				SB1->(dbSetOrder(1))
	
				If SB1->(dbSeek(xFilial("SB1")+ZBU->ZBU_CODIGO))
					@Prow()   , 020 Psay SUBSTR(SB1->B1_DESC,1,30)
				EndIf
				
				@Prow()   , 052 Psay "Quantidade:"+ALLTRIM(STR(ZBU->ZBU_QUANT))

			EndIf

			For x:=1 To MlCount(ALLTRIM(ZBU->ZBU_DESC),35)
		  		@Prow()+Iif(x==1,0,1) , 098 Psay MemoLine(ZBU->ZBU_DESC,35,x)
			Next
		
			ZBU->(dbSkip())
		EndDo
	
	EndIf
	
	@Prow() +1,000 psay __PrtThinLine()

Return
    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA A DURACAO DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fDuracao(dDtIni,dDtFim,cHrIni,cHrFim)
Local nDuracao := 0
Local cDuracao := ""
Local nTamanho := 0

	If Empty(dDtFim)
		nDuracao := (Date() - dDtIni) * 24
	Else
		nDuracao := (dDtFim - dDtIni) * 24
	EndIf
	
	If Empty(cHrFim)
		nDuracao += (HoraToInt(Substr(Time(),1,5)) - HoraToInt(Substr(cHrIni,1,5)))
	Else
		nDuracao += (HoraToInt(Substr(cHrFim,1,5)) - HoraToInt(Substr(cHrIni,1,5)))
	EndIf

	nTamanho := Len(AllTrim(Str(Int(nDuracao))))
	nTamanho := Iif(nTamanho==1,2,nTamanho)
	cDuracao := IntToHora(nDuracao,nTamanho)
	cDuracao := AllTrim(cDuracao)

//RETORNA EM CARACTERES FORMATO HORA 99:99
Return cDuracao


//-- usado no sx3 tabela ZBU campo ZBU_NOME
//-- inicializador do browse
User Function MNT43NOM()
Local cNome := ""

	If ZBU->ZBU_TIPO=="M"
		cNome := Posicione("QAA",1,xFilial("QAA")+ZBU->ZBU_CODIGO,"QAA_NOME")
	ElseIf ZBU->ZBU_TIPO=="P"
		cNome := Posicione("SB1",1,xFilial("SB1")+ZBU->ZBU_CODIGO,"B1_DESC")
	EndIf

Return cNome    

User Function MNT43PRN()

	If MsgYesNo("Possui impressora térmica?")
		U_NHPRN043()
	Else
		U_MNT43IMP()	
	EndIf
    
Return
