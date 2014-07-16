/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor ³ João Felipe da Rosa º Data ³  30/04/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CLASSE DISPOSITIVO                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "msobjects.ch"
#INCLUDE "protheus.ch"

Class Dispositivo
	
	var cCod     as Character //codigo do dispositivo 				 	ZBN_COD
	var cDesc    as Character //Descricao do dispositivo 			 	ZBN_DESC
	var cLetra   as Character //letra identificadora do dispositivo  	ZBN_LETRA
	var cOp      as Character //operacao que o dispositivo pertence  	ZBN_OP
	var cCC      as Character //C.Custo do dispositivo 				 	ZBN_CC
	var cCTrab   as Character //Centro de Trabalho 					 	ZBN_CTRAB
	var cAtivo   as Character //Dispositivo Ativo (S/N)				 	ZBN_ATIVO
	var cCodBem  as Character //Bem ao qual o dispositivo pertence   	ZBN_CODBEM
	var cProd    as Character //Produto que é feito pelo dispositivo 	ZBN_PROD
	var cCli     as Character //Cliente da peca                      	ZBN_CLI
	var cLoja    as Character //Loja do cliente da peca	             	ZBN_LOJA
	var cPrpCli  as Character //Propriedade do cliente (S/N)         	ZBN_PRPCLI
//	var cCliPrp  as Character //Cliente proprietario do disp. se houver ZBN_CLIPRP
//	var cLojPrp  as Character //Loja do cliente proprietároop        	ZBN_LOJPRP
	   
	Method New(cCod,cLetra) Constructor
	Method Tela(nParam)
	Method ValCC()
	Method ValBem()
	Method ValCTrab()
	Method ValProd()	
	Method ValCli()
	Method ValLoja()
	Method PrpCli()	
//	Method ValCliPrp()
//	Method ValLojPrp()
	Method Valida()
	Method Inclui()
	Method Altera()
	Method Exclui()

EndClass                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONSTRUTOR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method New(cCod,cLetra) Class Dispositivo

	if Empty(cCod) .And. Empty(cLetra)
		::cCod     := Space(15)
		::cDesc    := Space(100)
		::cLetra   := Space(1)
		::cOp      := Space(6)
		::cCC      := Space(6)
		::cCTrab   := Space(6)
		::cAtivo   := "S"
		::cCodBem  := Space(15)
		::cProd    := Space(15)
		::cCli     := Space(6)
		::cLoja    := Space(2)
		::cPrpCli  := "N"
//		::cCliPrp  := Space(6)
//		::cLojPrp  := Space(2)
    Else
    	ZBN->(DbSetOrder(1)) //FILIAL + CODIGO + LETRA
    	ZBN->(DbSeek(xFilial("ZBN")+cCod+cLetra))
    	If ZBN->(!Found())
    		Alert("Dispositivo não encontrado!")
    		Return 
    	EndIf
    	
    	::cCod 	   := ZBN->ZBN_COD
		::cDesc    := ZBN->ZBN_DESC
		::cLetra   := ZBN->ZBN_LETRA
		::cOp      := ZBN->ZBN_OP
		::cCC      := ZBN->ZBN_CC
		::cCTrab   := ZBN->ZBN_CTRAB
		::cAtivo   := ZBN->ZBN_ATIVO
		::cCodBem  := ZBN->ZBN_CODBEM
		::cProd    := ZBN->ZBN_PROD
		::cCli     := ZBN->ZBN_CLI
		::cLoja    := ZBN->ZBN_LOJA
		::cPrpCli  := ZBN->ZBN_PRPCLI
//		::cCliPrp  := ZBN->ZBN_CLIPRP
//		::cLojPrp  := ZBN->ZBN_LOJPRP
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA A TELA DO DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Tela(nParam) Class Dispositivo
Local aSize       := MsAdvSize()
Local bOk         := {||}
Local bEnchoice   := {||}
Private nPar      := nParam
Private cDescBem  := ""
Private cDescProd := ""	
Private cDescCli  := ""
Private cDescClp  := ""

	If nPar==2     //visualizar 
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk := {|| ::Inclui()}
	ElseIf nPar==4 //alterar
		bOk := {|| ::Altera()}
	ElseIf nPar==5 //excluir
		bOk := {|| ::Exclui()}
	EndIF
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,{||oDlg:End()}) }
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Dispositivo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay1 := TSay():New(20,10,{||"Cód. Dispositivo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, ::cCod := u,::cCod)},oDlg,70,8,"@!",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"::cCod")
	oGet2 := tGet():New(18,122,{|u| if(Pcount() > 0, ::cLetra := u,::cLetra)},oDlg,15,8,"@!",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"::cLetra")

	oSay2 := TSay():New(20,155,{||"Op"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(18,170,{|u| if(Pcount() > 0, ::cOp := u,::cOp)},oDlg,40,8,"@!",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,,"::cOp")
	
	oSay3 := TSay():New(20,225,{||"C.Custo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(18,250,{|u| if(Pcount() > 0, ::cCC := u,::cCC)},oDlg,40,8,"@!",{||::ValCC()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,"CTT","::cCC")

	oSay4 := TSay():New(35,15,{||"Descrição"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(33,50,{|u| if(Pcount() > 0, ::cDesc := u,::cDesc)},oDlg,180,8,"@!",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,,"::cDesc")

	oSay5 := TSay():New(50,15,{||"C.Trabalho"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet6 := tGet():New(48,50,{|u| if(Pcount() > 0, ::cCTrab := u,::cCTrab)},oDlg,40,8,"@!",{||::ValCTrab()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,"SHB","::cCTrab")
	
	oSay6 := TSay():New(50,140,{||"Disp. Ativo"},oDlg,,,,,,.T.,,)
	oCombo1 := TComboBox():New(48,170,{|u| if(Pcount() > 0,::cAtivo := u,::cAtivo)},;
		{"S=Sim","N=Não"},30,20,oDlg,,{||},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cAtivo")

	oSay7 := TSay():New(65,20,{||"Máquina"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet7 := tGet():New(63,50,{|u| if(Pcount() > 0, ::cCodBem := u,::cCodBem)},oDlg,60,8,"@!",{||::ValBem()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,"ST9","::cCodBem")
	oGet8 := tGet():New(63,112,{|u| if(Pcount() > 0, cDescBem := u,cDescBem)},oDlg,150,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescBem")

	oSay8 := TSay():New(80,15,{||"Cód. Produto"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet9 := tGet():New(78,50,{|u| if(Pcount() > 0, ::cProd := u,::cProd)},oDlg,60,8,"@!",{||::ValProd()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,"SB1","::cProd")
	oGet10 := tGet():New(78,112,{|u| if(Pcount() > 0, cDescProd := u,cDescProd)},oDlg,150,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescProd")

	oSay8 := TSay():New(95,20,{||"Cliente"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet11 := tGet():New(93,50,{|u| if(Pcount() > 0, ::cCli := u,::cCli)},oDlg,40,8,"@!",{||::ValCli()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,"SA1","::cCli")

	oGet15 := tGet():New(93,93,{|u| if(Pcount() > 0, ::cLoja := u,::cLoja)},oDlg,10,8,"@!",{||::ValLoja()},;
		,,,,,.T.,,,{|| nPar==3 .Or. nPar==4},,,,,,,"::cLoja")

	oGet12 := tGet():New(93,112,{|u| if(Pcount() > 0, cDescCli := u,cDescCli)},oDlg,150,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescCli")

	oSay6 := TSay():New(110,10,{||"Prop. Cliente"},oDlg,,,,,,.T.,,)
	oCombo2 := TComboBox():New(108,50,{|u| if(Pcount() > 0,::cPrpCli := u,::cPrpCli)},;
		{"S=Sim","N=Não"},30,20,oDlg,,{||/*::PrpCli()*/.T.},,,,.T.,,,,{|| nPar==3 .Or. nPar==4},,,,,"::cPrpCli")

/*
	oSay8  := TSay():New(110,100,{||"Cliente Prop."},oDlg,,,,,,.T.,,)
	oGet13 := tGet():New(108,130,{|u| if(Pcount() > 0, ::cCliPrp := u,::cCliPrp)},oDlg,40,8,"@!",{||::ValCliPrp()},;
		,,,,,.T.,,,{|| (nPar==3 .Or. nPar==4) .And. ::cPrpCli=="S"},,,,,,"SA1","::cCli")
	oGet15 := tGet():New(108,173,{|u| if(Pcount() > 0, ::cLojPrp := u,::cLojPrp)},oDlg,10,8,"@!",{||::ValLojPrp()},;
		,,,,,.T.,,,{|| (nPar==3 .Or. nPar==4) .And. ::cPrpCli=="S"},,,,,,,"::cLojPrp")
		

	oGet14 := tGet():New(108,192,{|u| if(Pcount() > 0, cDescClp := u,cDescClP)},oDlg,150,8,"@!",,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescClp")
*/
	If nPar!=3 //diferente de visualizar
		::ValBem()  //traz a descricao do bem
		::ValProd() //traz a descricao do produto
		::ValLoja() //traz a descricao do cliente
		If ::cPrpCli=="S"
//			::ValLojPrp() //traz a descricao do cliente proprietario
		EndIf
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCC() Class Dispositivo
	CTT->(DbSetOrder(1)) // FILIAL + CC
	CTT->(DbSeek(xFilial("CTT")+::cCC))
    If CTT->(!Found())
    	Alert("Centro de custo não encontrado!")
    	Return .F.
    EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE TRABALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCTrab() Class Dispositivo
	SHB->(DbSetOrder(1)) // FILIAL + CENTRAB
	SHB->(DbSeek(xFilial("SHB")+::cCTrab))
	If SHB->(!Found())
		Alert("Centro de Trabalho não encontrado!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O BEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValBem() Class Dispositivo
    ST9->(DbSetOrder(1)) // FILIAL + CODBEM
    ST9->(DbSeek(xFilial("ST9")+::cCodBem))
    If ST9->(!Found())
    	Alert("Bem não encontrado!")
    	Return .F.
	Else
		cDescBem := ST9->T9_NOME
		oGet8:Refresh()
    EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O PRODUTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValProd() Class Dispositivo
	SB1->(DbSetOrder(1)) // FILIAL + COD
	SB1->(DbSeek(xFilial("SB1")+::cProd))
	If SB1->(!Found())
		Alert("Produto não encontrado!")
		Return .F.
	Else
		cDescProd := SB1->B1_DESC
		oGet10:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCli() Class Dispositivo
	SA1->(DbSetOrder(1)) // filial + cod
	SA1->(DbSeek(xFilial("SA1")+::cCli))
	If SA1->(!Found())
		Alert("Cliente não encontrado!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA DO CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValLoja() Class Dispositivo
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+::cCli+::cLoja))
	If SA1->(!Found())
		Alert("Loja do Cliente não encontrada!")
		Return .F.
	Else
		cDescCli := SA1->A1_NOME
		oGet12:Refresh()
	EndIf
Return .T.

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA CAMPO PROPCLI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method PrpCli() Class Dispositivo
	If ::cPrpCli == "N"
		::cCliPrp := Space(6)
		::cLojPrp := Space(2)
		cDescClp := ""
		oGet13:Refresh() //ccliprp
		oGet14:Refresh() //cdescclp
		oGet15:Refresh() //clojprp
	EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CLIENTE PROPRIETARIO DO DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValCliPrp() Class Dispositivo
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+::cCliPrp))
	If SA1->(!Found())
		Alert("Cliente não encontrado!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA DO CLIENTE PROPRIETARIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValLojPrp() Class Dispositivo
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+::cCliPrp+::cLojPrp))
	If SA1->(!Found())
		Alert("Loja do Cliente proprietário não encontrada!")
		Return .F.
	Else
		cDescClp := SA1->A1_NOME
		oGet14:Refresh()
	EndIf
Return .T.
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Valida() Class Dispositivo

	If Empty(::cCod)
		Alert("Código do dispositivo não informado!")
		Return .F.
	EndIf
	
	If Empty(::cCC)
		Alert("Centro de Custo não informado!")
		Return .F.
	EndIf
	
	If Empty(::cCTrab)
		Alert("Centro de Trabalho não informado!")
		Return .F.
	EndIf
	
	If Empty(::cCodBem)
		Alert("Máquina não informada!")
		Return .F.
	EndIf
	
	If Empty(::cProd)
		Alert("Produto não informado!")
		Return .F.
	EndIf
	
	If Empty(::cCli)
		Alert("Cliente não informado!")
		Return .F.
	EndIf
	
/*
	If ::cPrpCli=="S" .AND. Empty(::cCliPrp)
		Alert("Cliente Proprietário do instrumento não informado!")
		Return .F.
	EndIf
*/
	
	If nPar==3 //incluir
		//verifica se já não existe dispositivo cadastrado com este código
		ZBN->(DbSetOrder(1)) // FILIAL + CODIGO + LETRA
		ZBN->(DbSeek(xFilial("ZBN")+::cCod+::cLetra))
		If ZBN->(Found())
			Alert("Dispositivo já cadastrado com este código!")
		    Return .F.
		EndIf
	EndIf
		
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUI O DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Inclui() Class Dispositivo
	
	If !::Valida()
		Return
	EndIf
	
	RecLock("ZBN",.T.)
		ZBN->ZBN_FILIAL := xFilial("ZBN")
		ZBN->ZBN_COD    := ::cCod
		ZBN->ZBN_LETRA  := ::cLetra
		ZBN->ZBN_DESC   := ::cDesc
		ZBN->ZBN_OP     := ::cOp
		ZBN->ZBN_CC     := ::cCC
		ZBN->ZBN_CTRAB  := ::cCTrab
		ZBN->ZBN_ATIVO  := ::cAtivo
		ZBN->ZBN_CODBEM := ::cCodBem
		ZBN->ZBN_PROD   := ::cProd
		ZBN->ZBN_CLI    := ::cCli   
		ZBN->ZBN_LOJA   := ::cLoja
		ZBN->ZBN_PRPCLI := ::cPrpCli //propriedade do cliente?
//		ZBN->ZBN_CLIPRP := ::cCliPrp
//		ZBN->ZBN_LOJPRP := ::cLojPrp //cliente proprietario
	MsUnLock("ZBN")

	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Altera() Class Dispositivo

	If !::Valida()
		Return
	EndIf
	
	ZBN->(DbSetOrder(1)) //FILIAL + CODIGO + LETRA
	ZBN->(DbSeek(xFilial("ZBN")+::cCod+::cLetra))
	
	RecLock("ZBN",.F.)
		ZBN->ZBN_DESC   := ::cDesc
		ZBN->ZBN_OP     := ::cOp
		ZBN->ZBN_CC     := ::cCC
		ZBN->ZBN_CTRAB  := ::cCTrab
		ZBN->ZBN_ATIVO  := ::cAtivo
		ZBN->ZBN_CODBEM := ::cCodBem
		ZBN->ZBN_PROD   := ::cProd
		ZBN->ZBN_CLI    := ::cCli  
		ZBN->ZBN_LOJA   := ::cLoja
		ZBN->ZBN_PRPCLI := ::cPrpCli
//		ZBN->ZBN_CLIPRP := ::cCliPrp
//		ZBN->ZBN_LOJPRP := ::cLojPrp
	MsUnLock("ZBN")

	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI O DISPOSITIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Exclui() Class Dispositivo
	
	ZBN->(DbSetOrder(1)) //FILIAL + CODIGO + LETRA
	ZBN->(DbSeek(xFilial("ZBN")+::cCod+::cLetra))
	
	If MsgYesNo("Tem certeza que deseja excluir este dispositivo?")
		RecLock("ZBN",.F.)
			ZBN->(DbDelete())
		MsUnLock("ZBN")
    EndIf
    
	oDlg:End()

Return