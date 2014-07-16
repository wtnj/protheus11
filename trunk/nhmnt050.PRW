/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT050 ºAutor  ³ João Felipe da Rosaº Data ³  05/03/2010 º±±
      10/06/2011 José Henrique M Felipetto - Melhoria.
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ORDEM DE SERVICO - FERRAMENTAIS (FUNDICAO)                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"

User Function NHMNT050()

Private aRotina, cCadastro

cCadastro := "O.S. Ferramental"
aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_MNT50(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_MNT50(3)" 	, 0 , 3})
aAdd(aRotina,{ "Excluir"        ,"U_MNT50(5)"   , 0 , 4})
aAdd(aRotina,{ "Finalizar"      ,"U_MNT50(6)"   , 0 , 4})
aAdd(aRotina,{ "Insumos"        ,"U_MNT50(7)"   , 0 , 3})
aAdd(aRotina,{ "Imprimir"       ,"U_NHMNT054()" , 0,  4})
aAdd(aRotina,{ "Anexo"          ,"U_MNTD50()"   , 0,  4})
aAdd(aRotina,{ "Aprovar"        ,"U_MNT50(8)"   , 0,  4})
aAdd(aRotina,{ "Legenda"        ,"U_MNT50LEG()" , 0 , 4})


mBrowse( 6, 1,22,75,"ZDN",,,,,,fCriaCor())

Return

//Abre a funcao base de conhecimento
User Function MNTD50()
	If ZDN->ZDN_STATUS!="E"
		MsDocument('ZDN',ZDN->(RECNO()), 4)
	Else
		Alert("OS já está finalizada!")
	EndIf
return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT50(nParam)

Private aSize     := MsAdvSize()
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private aTipo     := {}
Private aTipoFun  := {"1=Modelo","2=Caixa de Macho","3=Máscara","4=Dispositivo"}	
Private aTipoFor  := {"1=Usinar Bloco Padrão","2=Usinar Gravura","3=Rebaixar","4=Gravar código","5=Ajuste / Polimento","6=Montagem","7=Outros"}
Private aHeader	  := {}
Private aCols	  := {}

Private b2Canc 	  := {||oDlg2:End()}
Private b2Ok      := {||}
Private bOk       := {||}
Private bCanc     := {||oDlg:End()}
Private bEnchoice := {||}
Private bEnchoice2:= {||}

Private cOrdem    := ""	
Private cCodWHB   := Space(15)
Private cDesCWHB  := ""
Private cSolic    := Space(6)
Private cNomSoli  := ""
Private cCC       := Space(9)
Private cDescCC   := ""
Private cHora     := Space(5)
Private cTipo     := ""
Private cCenTrab  := Space(6)
Private cDesc     := ""
Private cStatus   := ""
Private cHoraFim  := ""            
Private cRespFim  := Space(6)
Private cNomResp  := ""
Private cSoluc    := ""
Private cLetra    := Space(1)
Private cRefAtu   := Space(18)
Private cPeca     := space(10)
Private cCodC 	  := space(10)
Private cCli      := space(6)
Private cDesc     := space(50)
Private cQuant    := 0
Private cFAE      := space(10)
Private cDat      := Date(dDatabase) 
Private cRespPro  := SPACE(8)
Private c2RespPro := Space(50)
Private c2Proc    := SPACE(50)
Private cProc     := SPACE(8)
Private cLoja     := SPACE(2)
Private cOrdem2   := space(06)
Private cDesP 
Private cNomeCli

Private dDatPr    := CtoD("  /  /  ")
Private dData     := CtoD("  /  /  ")
Private	dDataFim  := CtoD("  /  /  ")
Private dDataA    := space(10)

Private nPar      := nParam
			
	Aadd(aHeader,{"Item" 	    	  , "ZE7_ITEM"    	,"@E 9999" ,04,0 ,".F."          ,"" ,"C"  ,"ZE7"})
	Aadd(aHeader,{"Produto"     , "ZDP_PROD"    	,"@!"	     ,15,0 ,"U_MNT050PRD()","" ,"C"  ,"ZE7"})
	Aadd(aHeader,{"Letra"   	  , "ZDP_LETRA"    ,"@!"	     ,10,0 ,"U_MNT050LETRA()"          ,"" ,"C"  ,"ZDP"})

	
	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir 
		cOrdem   := GetSxeNum("ZDN","ZDN_ORDEM")
		dData    := date()
		cHora    := time()
    	
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	
	ElseIf nPar==6 //Finalizar
		fCarrega()
		bOk := {|| fFinal()}
		If cStatus == "E"
			Alert("O.S. já finalizada!")
			Return .F.
		EndIf
	ElseIf nPar==7 //Insumos
		fInsumo()
		Return
	
	ElseIf nPar==8 //Aprovar
		b2Canc := {}
		b2Ok := {}
		aHeader := {}
		aCols := {}
		cOrdem2 := ZDN->ZDN_ORDEM
		fAprova()
	 	Return
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Serviço - Ferramental",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"O.S."},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||cOrdem},oDlg,,oFont1,,,,.T.,,)
	
    oSay3 := TSay():New(32,10,{||"Data"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(30,50,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,45,8,"99/99/99",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"dData")

    oSay4 := TSay():New(32,160,{||"Hora"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(30,200,{|u| if(Pcount() > 0, cHora := u,cHora)},oDlg,40,8,"99:99",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cHora")

    oSay9   := TSay():New(44,10,{||"Centro Trab."},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(42,50,{|u| if(Pcount() > 0, cCenTrab := u,cCenTrab)},oDlg,45,8,"@!",{||fValCTrb(.T.)},;
		,,,,,.T.,,,{||nPar==3},,,,,,"SHB","cCenTrab")
   
		oSayX := TSay():New(44,160,{||"Refugo Atual"},oDlg,,,,,,.T.,,)
	oGetX := tGet():New(42,200,{|u| if(Pcount() > 0, cRefAtu := u,cRefAtu)},oDlg,40,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||.T.},,,,,,,"cRef") 

       /*	oSay5 := TSay():New(56,10,{||"Código Fer."},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(54,50,{|u| if(Pcount() > 0, cCodWHB := u,cCodWHB)},oDlg,70,8,"@!",{||fValFerr()},;
		,,,,,.T.,,,{||nPar==3},,,,,,"ZDP","cCodWHB")
		
	oGet5 := tGet():New(54,125,{|u| if(Pcount() > 0, cLetra := u,cLetra)},oDlg,10,8,"@!",{||fValLetra()},;
		,,,,,.T.,,,{||nPar==3 .and. !cCenTrab$"FAB-04/UTI-04"},,,,,,,"cLetra")*/

	oSay5 := TSay():New(56,160,{||"Desc. Fer."},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(54,200,{|u| if(Pcount() > 0, cDesCWHB := u,cDesCWHB)},oDlg,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesCWHB")

	oSay6 := TSay():New(56,10,{||"C.Custo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet7 := tGet():New(54,50,{|u| if(Pcount() > 0, cCC := u,cCC)},oDlg,40,8,"@!",{||fValCC()},;
		,,,,,.T.,,,{||nPar==3},,,,,,"CTT","cCC")
	
	oSay7 := TSay():New(68,160,{||"Desc. C.Custo"},oDlg,,,,,,.T.,,)
	oGet8 := tGet():New(66,200,{|u| if(Pcount() > 0, cDescCC := u,cDescCC)},oDlg,180,8,"@!",,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescCC")

	oSay6 := TSay():New(68,10,{||"Solicitante"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet9 := tGet():New(66,50,{|u| if(Pcount() > 0, cSolic := u,cSolic)},oDlg,40,8,"@!",{||fValSoli()},;
		,,,,,.T.,,,{||nPar==3},,,,,,"QAA","cSolic")
	
	oSay7 := TSay():New(80,160,{||"Nome Solic."},oDlg,,,,,,.T.,,)
	oGet10 := tGet():New(78,200,{|u| if(Pcount() > 0, cNomSoli := u,cNomSoli)},oDlg,180,8,"@!",,;
		,,,,,.T.,,,{||.F.},,,,,,,"cNomSoli")

    oSay8 := TSay():New(80,10,{||"Prazo p/ Exec."},oDlg,,,,,,.T.,,)
	oGet11 := tGet():New(78,50,{|u| if(Pcount() > 0, dDatPr := u,dDatPr)},oDlg,45,8,"99/99/99",/*valid*/,;
		,,,,,.T.,,,{||nPar==3},,,,,,,"dDatPrv")

    oSay10  := TSay():New(92,160,{||"Tipo"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(90,200,{|u| if(Pcount() > 0,cTipo := u,cTipo)},;
		aTipo,70,10,oDlg,,{||},,,,.T.,,,,{||nPar==3},,,,,"cTipo")
		
	oSay11 := TSay():New(104,10,{||"Desc. Serviço"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oMemo1 := tMultiget():New(102,50,{|u|if(Pcount()>0,cDesc:=u,cDesc)},;
		oDlg,250,40,,,,,,.T.,,,{||nPar==3}) 
	
	oGroup := tGroup():New(141,005,185,400,"FAE",oDlg,,,.T.)

 	oSayX := TSay():New(150,10,{||"Peça"},oDlg,,,,,,.T.,,)
	oGet17 := tGet():New(148,50,{|u| if(Pcount() > 0, cPeca := u,cPeca)},oDlg,62,8,"@!",{||fValPeca(.T.)},;
		,,,,,.T.,,,{||.T.},,,,,,"SB1","cPeca") 
	
	oSayX := TSay():New(162,10,{||"Cód. do Cliente"},oDlg,,,,,,.T.,,)
	oGet18 := tGet():New(160,50,{|u| if(Pcount() > 0, cCodC := u,cCodC)},oDlg,45,8,"@!",/*Valid*/,;
		,,,,,.T.,,,{||.T.},,,,,,,"cCodC")    
		
	oSayX := TSay():New(174,10,{||"Cliente/Loja"},oDlg,,,,,,.T.,,)
	oGet19 := tGet():New(172,50,{|u| if(Pcount() > 0, cCli := u,cCli)},oDlg,45,8,"@!",{||fValCli(.T.)},;
		,,,,,.T.,,,{||.T.},,,,,,"SA1","cCli") 
			
	oGet20 := tGet():New(172,95,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlg,24,4,"@!",/*valid*/,;
		,,,,,.T.,,,{||.T.},,,,,,,"cLoja")
		
	oSayX := TSay():New(150,160,{||"Desc.Peça"},oDlg,,,,,,.T.,,)
	oGet21 := tGet():New(148,200,{|u| if(Pcount() > 0, cDesP := u,cDesP)},oDlg,180,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cDesP")
		
	oSayX := TSay():New(162,160,{||"Quant."},oDlg,,,,,,.T.,,)
	oGet22 := tGet():New(160,200,{|u| if(Pcount() > 0, cQuant := u,cQuant)},oDlg,45,8,"@E 99",/*valid*/,;
		,,,,,.T.,,,{||.T.},,,,,,,"cQuant")
		
	oSayX := TSay():New(174,160,{||"Nome do Cliente"},oDlg,,,,,,.T.,,)
	oGet23 := tGet():New(172,200,{|u| if(Pcount() > 0, cNomeCli := u,cNomeCli)},oDlg,180,8,"@!",/*valid*/,;
		,,,,,.T.,,,{||.F.},,,,,,,"cNomeCli")
	
	oSay12 := TSay():New(190,10,{||"Código Fer."},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 190     ,; //superior
                           50     			,; //esquerda
                           240			    ,; //inferior
                           280				,; //direita
                           Iif(nPar==3,4,2) ,; // nOpc
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

	
	If nPar==6 .or. nPar==2  //finalizar ou visualizar
                                           
	    oSay12 := TSay():New(250,10,{||"Data Final"},oDlg,,,,,,.T.,,)
		oGet12 := tGet():New(248,50,{|u| if(Pcount() > 0, dDataFim := u,dDataFim)},oDlg,45,8,"99/99/99",/*valid*/,;
			,,,,,.T.,,,{||.F.},,,,,,,"dDataFim")
	
	    oSay13 := TSay():New(250,160,{||"Hora Fim"},oDlg,,,,,,.T.,,)
		oGet13 := tGet():New(248,200,{|u| if(Pcount() > 0, cHoraFim := u,cHoraFim)},oDlg,40,8,"99:99",/*valid*/,;
			,,,,,.T.,,,{||.F.},,,,,,,"cHoraFim")
	
		oSay14 := TSay():New(262,10,{||"Resp. Final"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oGet14 := tGet():New(260,50,{|u| if(Pcount() > 0, cRespFim := u,cRespFim)},oDlg,40,8,"@!",{||fValResp()},;
			,,,,,.T.,,,{||nPar==6},,,,,,"QAA","cRespFim")
		
		oSay15 := TSay():New(262,160,{||"Nome Resp."},oDlg,,,,,,.T.,,)
		oGet15 := tGet():New(260,200,{|u| if(Pcount() > 0, cNomResp := u,cNomResp)},oDlg,180,8,"@!",,;
			,,,,,.T.,,,{||.F.},,,,,,,"cNomResp")

		oSay16 := TSay():New(274,10,{||"Solução"},oDlg,,,,,,.T.,CLR_HBLUE,)
		oMemo2 := tMultiget():New(272,50,{|u|if(Pcount()>0,cSoluc:=u,cSoluc)},;
			oDlg,250,40,,,,,,.T.,,,{||nPar==6})
		
	EndIf
	If nPar!=3
		fValCTrb(.F.)
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

Static Function fAprova()  
	
	If ZDN->ZDN_STATUS == "A"
		Alert("A OS já foi aprovada!.")
		Return
	EndIf

	b2Ok   := {||fGrava()} 
	b2Canc := {||oDlg2:End()}
	
	Aadd(aHeader,{"Item" 	       			, "ZEC_ITEM"  	,"@E 9999"   		 ,04,0,".F."			,""	,"C" 		,"ZEC"})
	Aadd(aHeader,{"Matrícula" 	    	, "ZEC_MATRIC"  	,"@E 999999"         ,06,0,"U_MNT050VNOM()"	,"" ,"C" 	,"ZEC"})
	Aadd(aHeader,{"Nome"     	       		, "QAA_NOME"    	,"@!"	            	 ,30,0,".F."			,""	,"C" 		,"QAA"})
	Aadd(aHeader,{"Data"   			, "ZDN_DTA"    	,"@99/99/99"	 ,30,0,".F."			,""	,"D" 		,"ZDN"})
	Aadd(aHeader,{"Setor"   	       		, "ZEC_SETOR"   	,"@!"	     		 ,30,0,".T."			,""	,"C" 		,"ZEC"})
	Aadd(aHeader,{"Ações"           		, "ZEC_ACOES"   	,""          		 	 ,10,0,".T."			,""	,"M" 	,"ZEC"})
		
	bEnchoice2 := {||EnchoiceBar(oDlg2,b2Ok,b2Canc)}

	oDlg2  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Ordem de Serviço - Ferramental",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

			oSay1 := TSay():New(20,10,{||"FAE Nº: "},oDlg2,,,,,,.T.,,)
			oGet1 := tGet():New(18,50,{|u| if(Pcount() > 0, cOrdem2 := u,cOrdem2)},oDlg2,45,8,"@!",/*valid*/,;
			,,,,,.T.,,,{||.F.},,,,,,,"cOrdem2")
		
		
			oSay2 := TSay():New(32,10,{||"Data "},oDlg2,,,,,,.T.,,)
			oGet2 := tGet():New(30,50,{|u| if(Pcount() > 0, cDat := u,cDat)},oDlg2,45,8,"@99/99/99",/*valid*/,;
			,,,,,.T.,,,{||.F.},,,,,,,"cDat")
	
			oSay3 := TSay():New(20,130,{||"Responsável pelo Projeto: "},oDlg2,,,,,,.T.,,)
   			oGet3 := tGet():New(18,195,{|u| if(Pcount() > 0, cRespPro := u,cRespPro)},oDlg2,30,8,"@!",{||fValRep()},;
			,,,,,.T.,,,{||.T.},,,,,,"QAA","cRespPro") 
			oGet4 := tGet():New(18,230,{|u| if(Pcount() > 0, c2RespPro := u,c2RespPro)},oDlg2,160,8,"@!",/*valid*/,;
			,,,,,.T.,,,{||.F.},,,,,,,"c2RespPro")  
	
			oSay4 := TSay():New(32,130,{||"Processista: "},oDlg2,,,,,,.T.,,)
			oGet5 := tGet():New(30,195,{|u| if(Pcount() > 0, cProc := u,cProc)},oDlg2,30,8,"@!",{||fValProc()},;
			,,,,,.T.,,,{||.T.},,,,,,"QAA","cProc") 
   			oGet6 := tGet():New(30,230,{|u| if(Pcount() > 0, c2Proc := u,c2Proc)},oDlg2,160,8,"@!",/*valid*/,;
			,,,,,.T.,,,{||.F.},,,,,,,"c2Proc") 
	
			oSay5 := TSay():New(44,10,{||"Participantes"},oDlg2,,,,,,.T.,,)
   			oGeTD := MsGetDados():New( /*aPosObj[2,1]*/ 42     ,; //superior
                           50     			,; //esquerda
                           200			    ,; //inferior
                           450				,; //direita
                           4 				,; // nOpc
                           "AllwaysTrue"    ,; // CLINHAOK
                           "AllwaysTrue"    ,; // CTUDOOK
                           ""               ,; // CINICPOS
                           .T.              ,; // LDELETA
                           nil              ,; // aAlter
                           nil              ,; // uPar1
                           .T.              ,; // LEMPTY
                           200              ,; // nMax
                           nil              ,; // cCampoOk
                           "AllwaysTrue()"  ,; // CSUPERDEL
                           nil              ,; // uPar2
                           "AllwaysTrue()"  ,; // CDELOK
                           oDlg2              ; // oWnd
                          )  

	oDlg2:Activate(,,,.F.,{||.T.},,bEnchoice2)
Return

Static Function fValCTrb(lMsg)

	SHB->(dbSetOrder(1)) //filial + cod
	If !SHB->(dbSeek(xFilial("SHB")+cCenTrab))
		If lMsg
			Alert("Centro de Trabalho não encontrado!")
			Return .F.
		EndIF
	Else                                    
		//forjaria
		If AllTrim(cCentrab)$"FAB-04/UTI-04"
			oCombo1:aItems := aTipoFor
//			oGet4:cF3 := "SB1"
			cLetra := Space(2)
			oGet5:Refresh()
		Else
			oCombo1:aItems := aTipoFun
			cDescWHB := ""
			oGet6:Refresh()
			//oGet4:cF3 := "ZDP"
		EndIf
		
		oCombo1:Refresh()
	
	EndIf

Return .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO FERRAMENTAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValFerr()
		
	If Empty(cCodWHB)
		RETURN .T.
	EndIf
	
	
	If AllTrim(cCentrab)$"FAB-04/UTI-04"
		SB1->(dbSetOrder(1)) // FILIAL + COD
		If !SB1->(dbSeek(xFilial("SB1")+cCodWHB))
			Alert("Produto não encontrado!")
			Return .F.
		Else
			
			If !SB1->B1_TIPO$"FE/FJ"
				Alert("Tipo do produto deve ser FE ou FJ!")
				Return .F.
			Else
				cDesCWHB := SB1->B1_DESC
				oGet6:Refresh()
			EndIf
		EndIF

	Else
		ZDP->(dbSetOrder(1))
		If !ZDP->(dbSeek(xFilial("ZDP")+cCodWHB))
			Alert("Código Ferramental não encontrado!")
			Return .F.
		EndIf
	EndIf	
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO FERRAMENTAL COM A LETRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValLetra()
		
	If Empty(cLetra)
		RETURN .T.
	EndIf
	
	ZDP->(dbSetOrder(1))
	If !ZDP->(dbSeek(xFilial("SB1")+cCodWHB+cLetra))
		Alert("Código Ferramental / Letra não encontrado!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CENTRO DE CUSTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCC()
Local _cLogin
Local _lRet := .F.

	If Empty(cCC)
		Return .T.
	EndIf
	
	CTT->(DbSetOrder(1)) // FILIAL + CC
	CTT->(DbSeek(xFilial("CTT")+cCC))
    If CTT->(!Found()) .AND. !Empty(cCC)
    	Alert("Centro de custo não encontrado!")
    	Return .F.
    Else
    	cDescCC := CTT->CTT_DESC01
    	oGet8:Refresh()
    EndIf
    
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O SOLICITANTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValSoli()
	
	If Empty(cSolic)
		REturn .T.
	EndIf
	
	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+cSolic))
	If QAA->(!Found())
		Alert("Funcionário não encontrado!")
		Return .F.
	Else
		cNomSoli := QAA->QAA_NOME
		oGet10:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O RESPONSAVEL FINAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValResp()
	
	If Empty(cRespFim)
		REturn .T.
	EndIf
	
	QAA->(DbSetOrder(1)) //FILIAL + MAT
	QAA->(DbSeek(xFilial("QAA")+cRespFim))
	If QAA->(!Found())
		Alert("Funcionário não encontrado!")
		Return .F.
	Else
		cNomResp := QAA->QAA_NOME
		oGet14:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS DADOS NAS VARIAVEIS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()

	cOrdem  := ZDN->ZDN_ORDEM
	dData   := ZDN->ZDN_DATA
	cHora   := ZDN->ZDN_HORA
	dDatPr  := ZDN->ZDN_DATPR
	cSolic  := ZDN->ZDN_SOLIC
	cPeca   := ZDN->ZDN_PECA   // TABELA DA PEÇA
   	cCodC   := ZDN->ZDN_CODCLI // Código do Cliente 
	cQuant  := ZDN->ZDN_QUANT  // Quantidade
   	cCli    := ZDN->ZDN_CLIENT // Cliente
   	cLoja	:= ZDN->ZDN_LOJA   // Loja
	
         ZE7->(DbsetOrder(1))
	 ZE7->(DbSeek(xFilial("ZE7")+ZDN->ZDN_ORDEM )) //ZDP_FILIAL+ZDP_COD+ZDP_LETRA
	 Do While ZE7->(!EOF() .AND. ZDN->ZDN_ORDEM == ZE7->ZE7_NUM) 
	 	aAdd(aCols,{ZE7->ZE7_ITEM,ZE7->ZE7_PROD,ZE7->ZE7_LETRA,.F.})
	 	ZE7->(DbSkip() )
	 EndDo
	 
	 QAA->(DbSetOrder(1)) // filial + mat
	If QAA->(DbSeek(xFilial("QAA")+cSolic))
		cNomSoli := QAA->QAA_NOME
	EndIf

	cCC     := ZDN->ZDN_CC
	CTT->(dbSetOrder(1)) //FILIAL + CC
	If CTT->(dbSeek(xFilial("CTT")+cCC))
		cDescCC := CTT->CTT_DESC01
	EndIf

	cCenTrab := ZDN->ZDN_CTRAB
	
	//cCodWHB := ZDN->ZDN_COD
	//cLetra := ZDN->ZDN_LETRA	
		
	If AllTrim(cCentrab)$"FAB-04/UTI-04"

		SB1->(DbSetOrder(1)) // filial + cod
		If SB1->(DbSeek(xFilial("ST1")+cCodWHB))
			cDesCWHB := SB1->B1_DESC
		EndIf
	EndIF

	cTipo   := ZDN->ZDN_TIPO
	cDesc   := ZDN->ZDN_DESC
	
	cStatus := ZDN->ZDN_STATUS
	
	If nPar==6 //Finalizar
		dDataFim := date()
		cHoraFim := Substr(Time(),1,5)
	Else
		dDataFim := ZDN->ZDN_DATFIM
		cHoraFim := ZDN->ZDN_HORFIM
		cRespFim := ZDN->ZDN_RESFIM
	
		If QAA->(DbSeek(xFilial("QAA")+cRespFim))
			cNomResp := QAA->QAA_NOME
		EndIf
		
		cSoluc := ZDN->ZDN_SOLUC
	
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()
Local lVazio := .T.

	For x:=1 to Len(aCols)
		If !Empty(aCols[x][2])
			lVazio := .F.
		EndIf
	Next
	
	If lVazio
		Alert("Informe pelo menos um Código Ferramental!")
		Return .F.
	EndIf
	
	If Empty(cCC)
		Alert("Informe o C.Custo!")
		Return .F.
	EndIF
	
	If Empty(cSolic)
		Alert("Informe o solicitante!")
		Return .F.
	EndIf
	
	If Empty(cCenTrab)
		Alert("Informe o Centro de Trabalho!")
		Return .F.
	EndIf

	If Empty(cTipo)
		Alert("Informe o Tipo!")
		Return .F.
	EndIf
	
	If Empty(cDesc)
		Alert("Informe a Descrição do Serviço!")
		Return .F.
	EndIf 
          
	If nPar==6 //Finalizar
	
		If Empty(cRespFim) 
			Alert("Informe o Responsável pela Finalização!")
			Return .F.
		EndIf
		
		If Empty(cSoluc)
			Alert("Informe a solução!")
			Return .F.
		EndIf
	
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()
    
    ZDN->(DbSetOrder(1))
    If ZDN->(DbSeek(xFilial("ZDN") + cOrdem))
   		Alert("Esta ordem já existe! Consulte o depto. de Informática.")
   		Return
    Endif
	
	If !fValida()
		Return
	EndIf 
	
	RecLock("ZDN",.T.)
		ZDN->ZDN_FILIAL := xFilial("ZDN")
		ZDN->ZDN_ORDEM  := cOrdem
		ZDN->ZDN_DATA   := dData
		ZDN->ZDN_HORA   := cHora
		ZDN->ZDN_DATPR  := dDatPr 
		ZDN->ZDN_SOLIC  := cSolic
		ZDN->ZDN_CC     := cCC
		//ZDN->ZDN_COD    := cCodWHB
		//ZDN->ZDN_LETRA  := cLetra
		ZDN->ZDN_CTRAB  := cCenTrab
		ZDN->ZDN_Tipo   := Substr(cTipo,1,1)
		ZDN->ZDN_DESC   := cDesc
		ZDN->ZDN_STATUS := "P"
		ZDN->ZDN_PECA 	:= cPeca// TABELA DA PEÇA
   		ZDN->ZDN_CODCLI := cCodC// Código do Cliente 
		ZDN->ZDN_QUANT  := cQuant// Quantidade
   		ZDN->ZDN_CLIENT := cCli // Cliente
   		ZDN->ZDN_LOJA   := cLoja // Loja
   		ZDN->ZDN_LOGIN  := UPPER(Alltrim(cUsername))
	MsUnlock("ZDN")
	 	
	For x := 1 to Len(aCols)
		If !aCols[x][Len(aHeader ) + 1]    // Verifica se a linha não está deletada.
			RecLock("ZE7",.T.)
				ZE7->ZE7_FILIAL := xFilial("ZE7")
		       	ZE7->ZE7_NUM   	:= cOrdem
				ZE7->ZE7_ITEM   := aCols[x][1]
				ZE7->ZE7_PROD   := aCols[x][2]
				ZE7->ZE7_LETRA  := aCols[x][3]
			MsUnlock("ZE7")
		EndIf
	Next x
			
	ConfirmSx8()
	
	fEmail("ABERTURA")
	
	oDlg:End()                                             		
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI A OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fExclui()
	
	If MsgYesNo("Tem certeza de que deseja excluir a OS: "+cOrdem+"?")
		RecLock("ZDN",.F.)
			ZDN->(DbDelete())
		MsUnlock("ZDN")
	EndIf
	
	oDlg:End()

Return         

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³ FINALIZA ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
Static Function fFinal() 

	If !fValida()
		Return
	EndIf 
	
	RecLock("ZDN",.F.)
		ZDN->ZDN_STATUS := "E"
		ZDN->ZDN_DATFIM := dDataFim
		ZDN->ZDN_HORFIM := cHoraFim
		ZDN->ZDN_RESFIM := cRespFim
		ZDN->ZDN_SOLUC  := cSoluc
	MsUnLock("ZDN")
	
	fEmail("ENCERRAMENTO")
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ APROVACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Static Function fAprova()

	RecLock("ZDN",.F.)
		ZDN->ZDN_STATUS := "E"
	MsUnlock("ZDN")
	
	oDlg:End()
	

Return
*/
//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function MNT50LEG()

Local aLegenda :=	{ {"BR_VERMELHO", OemToAnsi("Aberta")     },;
                      {"BR_AMARELO" , OemToAnsi("Finalizada") },;
                      {"BR_VERDE"   , OemToAnsi("Aprovada")   }}

BrwLegenda(OemToAnsi("Ordem de Serviço Ferramental"), "Legenda", aLegenda)

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A LEGENDA DO BROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()

Local aLegenda :=	{ {"BR_VERMELHO", OemToAnsi("Aberta")      },;
					  {"BR_AMARELO" , OemToAnsi("Finalizada")  },;
                      {"BR_VERDE"   , OemToAnsi("Aprovada")    }}

Local uRetorno := {}
	Aadd(uRetorno, { 'ZDN_STATUS=="P"' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZDN_STATUS=="E"' , aLegenda[2][1] } )
	Aadd(uRetorno, { 'ZDN_STATUS=="A"' , aLegenda[3][1] } )

Return(uRetorno)


//ÚÄÄÄÄÄÄÄÄÄ¿
//³ INSUMOS ³
//ÀÄÄÄÄÄÄÄÄÄÙ
Static Function fInsumo()

	DbSelectArea("ZDO")
	Set Filter To &("ZDO->ZDO_ORDEM == '"+ZDN->ZDN_ORDEM+"'")

   	aRotOld := aClone(aRotina)
	   	
   	cCadastro := "Insumos da O.S. de Ferramentaria"
	aRotina   := {}
	aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
	aAdd(aRotina,{ "Visualizar"	    ,"U_MNT50I(2)" 	, 0 , 2})
	aAdd(aRotina,{ "Incluir"		,"U_MNT50I(3)" 	, 0 , 3})
	aAdd(aRotina,{ "Alterar"		,"U_MNT50I(4)" 	, 0 , 4})
	aAdd(aRotina,{ "Excluir"		,"U_MNT50I(5)" 	, 0 , 5})
			
	mBrowse( 6, 1,22,75,"ZDO",,,,,,)
		
	aRotina := aClone(aRotOld)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DOS INSUMOS DE FERRAMENTARIA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT50I(nParam)
Local aTipo     := {"","P=Produto","M=Mao de Obra"}
Local bOk       := {||}
Private nPar    := nParam
Private cTipo   := Space(1)  
Private cCodigo := Space(15)
Private cDesCod := ""
Private nQuant  := 0
Private dDatIni := CtoD("  /  /  ")
Private cHorIni := Space(5)
Private dDatFim := CtoD("  /  /  ")
Private cHorFim := Space(5)
Private cDesc   := ""

	//para OS finalizada somente eh permitido visualizar
	If ZDN->ZDN_STATUS=="E" .and. nPar!=2
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
		fICarrega()
		bOk := {||fIExclui()}  
	EndIf

	// TELA
	
	oDlg  := MsDialog():New(0,0,282,600,"Lançamento de Insumo",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

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
	oGet7 := tGet():New(56,160,{|u| if(Pcount() > 0, cHorFim := u,cHorFim)},oDlg,40,8,"99:99",{||.T.},;
		,,,,,.T.,,,{||cTipo=="M" .AND. (nPar==3 .Or. nPar==4)},,,,,,"","cHorFim")

	oSay14  := TSay():New(70,10,{||"Descrição"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oMemo1  := tMultiget():New(68,50,{|u|if(Pcount()>0,cDesc:=u,cDesc)},;
	oDlg,240,40,,,,,,.T.,,,{|| nPar==3 .Or. nPar==4 })

	oGroup := tGroup():New(118,05,120,295,,oDlg,,,.T.)

	oBtn1 := tButton():New(126,230,"Ok",oDlg,bOk,30,10,,,,.T.)
	oBtn2 := tButton():New(126,265,"Cancelar",oDlg,{||oDlg:End()},30,10,,,,.T.)
	
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
		
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fIInclui()

	If !fIValida()
	    Return
	EndIf 
	
	RecLock("ZDO",.T.)
		ZDO->ZDO_FILIAL := xFilial("ZDO")
		ZDO->ZDO_ORDEM  := ZDN->ZDN_ORDEM
		ZDO->ZDO_TIPO   := cTipo 
		ZDO->ZDO_CODIGO := cCodigo
		ZDO->ZDO_QUANT  := nQuant
		ZDO->ZDO_DATINI := dDatIni
		ZDO->ZDO_HORINI := cHorIni
		ZDO->ZDO_DATFIM := dDatFim
		ZDO->ZDO_HORFIM := cHorFim
		ZDO->ZDO_DESC   := cDesc
	MsUnlock("ZDO") 
	
	oDlg:End()

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIAltera()

	If !fIValida()
		Return
	EndIf
	
	RecLock("ZDO",.F.)
		ZDO->ZDO_TIPO   := cTipo 
		ZDO->ZDO_CODIGO := cCodigo
		ZDO->ZDO_QUANT  := nQuant
		ZDO->ZDO_DATINI := dDatIni
		ZDO->ZDO_HORINI := cHorIni
		ZDO->ZDO_DATFIM := dDatFim
		ZDO->ZDO_HORFIM := cHorFim
		ZDO->ZDO_DESC   := cDesc
	MsUnLock("ZDO")
	
	oDlg:End()

Return    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXCLUI O INSUMO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fIExclui()
	
	If MsgYesNo("Tem certeza de que deseja excluir este insumo?")
		RecLock("ZDO",.F.)
			ZDO->(DbDelete())
		MsUnLock("ZDO")
	EndIf

	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA AS VARIAVEIS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fICarrega()
	
	cTipo   := ZDO->ZDO_TIPO
	cCodigo := ZDO->ZDO_CODIGO

	If cTipo=="P"
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+cCodigo))
		cDesCod := SB1->B1_DESC
	ElseIf cTipo=="M"
		QAA->(DbSetOrder(1))
		QAA->(DbSeek(xFilial("QAA")+cCodigo))
		cDesCod := QAA->QAA_NOME
	EndIf
	
	nQuant  := ZDO->ZDO_QUANT
	dDatIni := ZDO->ZDO_DATINI
	cHorIni := ZDO->ZDO_HORINI
	dDatFim := ZDO->ZDO_DATFIM
	cHorFim := ZDO->ZDO_HORFIM
	cDesc   := ZDO->ZDO_DESC
	
Return

User Function MNT050VNOM()
Local _nNome	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "QAA_NOME"})
	
	QAA->(DbSetOrder(1)) // QAA_FILIAL + QAA_MAT
	If QAA->(DbSeek(xFilial("QAA")+M->ZEC_MATRIC))
		aCols[n][_nNome] := QAA->QAA_NOME
		oGeTD:Refresh()
	Else
		alert("Funcionário não encontrado!")
		Return .F.
	EndIf
	
Return .T.

Static Function fValPeca()

	SB1->(dbSetOrder(1)) //filial + cPeca
	If SB1->(dbSeek(xFilial("SB1")+cPeca))
		cDesP := SB1->B1_DESC
		oGet17:Refresh()
	Else	
		alert("Peça não encontrada!.")
		Return 
	EndIf
			
Return 

Static Function fValCli()

	SA1->(DbSetOrder(1)) // FILIAL + cCli 
	If SA1->(DbSeek(xFilial("SA1")+ALLTRIM(cCli))) == .T.
		cNomeCli := SA1->A1_NOME
		oGet19:Refresh()
	Else
		Alert("Cliente não encontrado!.")
		Return .F.
	EndIf
Return .T.

Static Function fGrava()

RecLock("ZDN",.F.)
	ZDN->ZDN_STATUS := "A"
	ZDN->ZDN_RESP1 := cRespPro
	ZDN->ZDN_RESP2 := c2RespPro
	ZDN->ZDN_DTA   := cDat
	ZDN->ZDN_PROC1 := cProc
	ZDN->ZDN_PROC2 := c2Proc
MsUnLock("ZDN")

For xC :=1 to Len(aCols)
    RecLock("ZEC",.T.)
		ZEC->ZEC_ORDEM  :=  cOrdem2
		ZEC->ZEC_ITEM   :=  aCols[xC][1]
		ZEC->ZEC_MATRIC :=  aCols[xC][2]
		ZEC->ZEC_SETOR  :=  aCols[xC][5]
		ZEC->ZEC_ACOES  :=  aCols[xC][6]
	MsUnLock("ZEC")
Next 
oDlg2:End()
Return

Static Function fValRep()

	QAA->(dbSetOrder(1)) //filial + cPeca
	If QAA->(dbSeek(xFilial("QAA")+cRespPro))
		c2RespPro := QAA->QAA_NOME
		oGet4:Refresh()
	Else	
		alert("Responsável não encontrado!.")
		Return .F.
	EndIf
			
Return .T.

Static Function fValProc()

	QAA->(dbSetOrder(1)) // filial + cProc
	If QAA->(DbSeek(xFilial("QAA")+cProc))
		c2Proc := QAA->QAA_NOME
		oGet6:Refresh()
	Else
		alert("Processista não encontrado!")
		Return .F.
	EndIf

Return .T.

User Function MNT050PRD()
	
	ZDP->(dbsetorder(1)) //-- ZDP_FILIAL+ZDP_COD+ZDP_LETRA
	If ZDP->(DbSeek(xFilial("ZDP")+M->ZDP_PROD))
		Return .T.	
	Else
		alert("Produto não encontrado!")
		Return .F.
	EndIf
	
Return .T.

User Function MNT050LETRA()
Local _nPosCod := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZDP_PROD"})

        ZDP->(DbSetOrder(1) )  //-- ZDP_FILIAL+ZDP_COD+ZDP_LETRA
        If ZDP->(DbSeek(xFilial("ZDP")+Acols[n][_nPosCod]+M->ZDP_LETRA))
        	Return .T.
        Else
        	alert("Letra não encontrada!")
        	Return .F.
        EndIf
Return 

//ÚÄÄÄÄÄÄÄ¿
//³ EMAIL ³
//ÀÄÄÄÄÄÄÄÙ
Static Function fEmail(cAcao)
Local cMsg

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="100%" border="1">'

	cMsg += '  <tr style="background:#ccc">'
	cMsg += '    <td colspan="4">'
	cMsg += '      '+cAcao+' DE ORDEM DE SERVIÇO'
	cMsg += '    </td>'
	cMsg += '  </tr>'
	
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Número</td>'
	cMsg += '    <td>'+ZDN->ZDN_ORDEM+'</td>'
	cMsg += '    <td style="background:#abc">Data</td>'
	cMsg += '    <td>'+DtoC(ZDN->ZDN_DATA)+'</td>'
	cMsg += '  </tr>'

	ZE7->(dbsetorder(1))
	ZE7->(dbSeek(xFilial("ZE7")+ZDN->ZDN_ORDEM))
	
	WHILE ZE7->(!EOF()) .AND. ZE7->ZE7_NUM==ZDN->ZDN_ORDEM
	     
		cMsg += '  <tr>'
		cMsg += '    <td style="background:#abc">Código Ferramental</td>'
		cMsg += '    <td>'+ZE7->ZE7_PROD+'</td>'
		cMsg += '    <td style="background:#abc">Letra</td>'
		cMsg += '    <td>'+ZE7->ZE7_LETRA+'</td>'
		cMsg += '  </tr>'
	
		ZE7->(dbskip())
	ENDDO

/*
	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Código Ferramental</td>'
	cMsg += '    <td>'+ZDN->ZDN_COD+'</td>'
	cMsg += '    <td style="background:#abc">Letra</td>'
	cMsg += '    <td>'+ZDN->ZDN_LETRA+'</td>'
	cMsg += '  </tr>'
*/ 

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Centro de Custo</td>'
	cMsg += '    <td>'+ZDN->ZDN_CC+'</td>'   
	cMsg += '    <td style="background:#abc">Descrição CC</td>'
	CTT->(DbSetOrder(1))
	CTT->(DbSeek(xFilial("CTT")+ZDN->ZDN_CC))
	cMsg += '    <td>'+CTT->CTT_DESC01+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Solicitante</td>'
	cMsg += '    <td>'+ZDN->ZDN_SOLIC+'</td>'
	cMsg += '    <td style="background:#abc">Nome</td>'
	QAA->(dbSetOrder(1))
	QAA->(dbSeek(xFilial("QAA")+ZDN->ZDN_SOLIC))
	cMsg += '    <td>'+QAA->QAA_NOME+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Tipo</td>'
	If AllTrim(ZDN->ZDN_CTRAB)$"FAB-04/UTI-04"
		cMsg += '    <td>'+aTipoFor[Val(ZDN->ZDN_TIPO)]+'</td>'
	Else
		cMsg += '    <td>'+aTipoFun[Val(ZDN->ZDN_TIPO)]+'</td>'
	EndIf
	cMsg += '    <td style="background:#abc">C.Trabalho</td>'
	cMsg += '    <td>'+ZDN->ZDN_CTRAB+'</td>'
	cMsg += '  </tr>'

	cMsg += '  <tr>'
	cMsg += '    <td style="background:#abc">Descrição do Serviço</td>'
	cMsg += '    <td colspan="3">'+ZDN->ZDN_DESC+'</td>'
	cMsg += '  </tr>'
	
	If cAcao=="ENCERRAMENTO"
	
		cMsg += '  <tr>'
		cMsg += '    <td style="background:#abc">Data Fechamento</td>'
		cMsg += '    <td colspan="3">'+DtoC(ZDN->ZDN_DATFIM)+'</td>'
		cMsg += '    <td style="background:#abc">Hora Fechamento</td>'
		cMsg += '    <td colspan="3">'+ZDN->ZDN_HORFIM+'</td>'
		cMsg += '  </tr>'

		cMsg += '  <tr>'
		cMsg += '    <td style="background:#abc">Resp. Fechamento</td>'
		cMsg += '    <td>'+ZDN->ZDN_RESFIM+'</td>'
		cMsg += '    <td style="background:#abc">Nome</td>'
		QAA->(dbSetOrder(1))
		QAA->(dbSeek(xFilial("QAA")+ZDN->ZDN_RESFIM))
		cMsg += '    <td>'+QAA->QAA_NOME+'</td>'
		cMsg += '  </tr>'
	
		cMsg += '  <tr>'
		cMsg += '    <td style="background:#abc">Solução</td>'
		cMsg += '    <td colspan="3">'+ZDN->ZDN_SOLUC+'</td>'
		cMsg += '  </tr>'
	
	EndIf

	cMsg += '</table><br />'
	cMsg += '</body>'
	cMsg += '</html>

	cTo := ''
	
	If AllTrim(ZDN->ZDN_CTRAB)$"FAB-04/UTI-04"

		If(cAcao=="ABERTURA")
			cTo += 'robertou@whbfundicao.com.br;'
			cTo += 'carlosas@whbfundicao.com.br;'
			cTo += 'luciol@whbfundicao.com.br;'
			cTo += 'aciolirs@whbfundicao.com.br;'
			cTo += 'fabioam@whbbrasil.com.br;'
			cTo += 'wilsonrr@whbusinagem.com.br;'
			cTo += 'rodrigom@whbusinagem.com.br;'
		 //	cTo += ''
			
		ElseIf(cAcao=="ENCERRAMENTO")
		
    	EndIf

   	Else
   	
   		cTo := 'fabricioQ@whbfundicao.com.br;'
		cTo += 'rogeriop@whbfundicao.com.br;'
//		cTo += 'ismaelp@whbbrasil.com.br;'
		cTo += 'jhonnyv@whbusinagem.com.br;'
//		cTo += 'marcelofm@whbbrasil.com.br;'
		cTo += 'vagnerm@whbfundicao.com.br;'
//		cTo += 'ailtonm@whbfundicao.com.br;'

		//-- incluidos com o chamado 018995 do portal
//		cTo += 'rafaelaab@whbbrasil.com.br;'
//		cTo += 'mariocp@whbbrasil.com.br;'
		cTo += 'jessefc@whbbrasil.com.br;'
		cTo += 'aroldor@whbbrasil.com.br;'
		cTo += 'devanirlo@whbbrasil.com.br;'
//		cTo += 'douglasfs@whbfundicao.com.br;'
//		cTo += 'reginasm@whbfundicao.com.br;'
//		cTo += 'geandroo@whbfundicao.com.br;'
		cTo += 'josesp@whbfundicao.com.br;'
		cTo += 'fabiolc@whbfundicao.com.br;'
//		cTo += 'adrianoan@whbfundicao.com.br;'
		cTo += 'leonardoos@whbfundicao.com.br;'
		cTo += 'ademarfl@whbfundicao.com.br;'

 
		If(cAcao=="ABERTURA")
//E-MAILS ADICIONADOS A PEDIDO DA FABIANA PAIXAO (CHAMADO Nº 14086)
			cTo += 'rodolfosl@whbbrasil.com.br;'
//			cTo += 'adautopj@whbfundicao.com.br;'
			cTo += 'marcelodm@whbbrasil.com.br;'
			cTo += 'diegoah@whbfundicao.com.br;'
//			cTo += 'elvisfm@whbfundicao.com.br;'
			cTo += 'wagnersf@whbfundicao.com.br;'
			cTo += 'andresd@whbfundicao.com.br;'
//			cTo += 'douglasm@whbfundicao.com.br;'
//			cTo += 'tiagomm@whbfundicao.com.br;'			
//_________________________________________________________________
			cTo += 'robertojs@whbfundicao.com.br;'
//			cTo += 'leandrops@whbbrasil.com.br;'
//			cTo += 'neimarrt@whbbrasil.com.br;'
			cTo += 'SandroLO@whbbrasil.com.br;'
			cTo += 'lucianoe@whbbrasil.com.br;'
			cTo += 'MarceloNG@whbbrasil.com.br;'
			cTo += 'laersonjr@whbbrasil.com.br;'
			cTo += 'welitonrl@whbfundicao.com.br;'
			cTo += 'Neslongr@whbbrasil.com.br;'
			cTo += 'elielbersr@whbbrasil.com.br;'
			cTo += 'carlosmm@whbbrasil.com.br;'
			cTo += 'amadoxonr@whbbrasil.com.br'
			
		ElseIf(cAcao=="ENCERRAMENTO")
			//amadoxo - nao tem cadastro
			//antonio carlos b - nao tem no cadastro
			//claudinei do rocio - nao tem no cadastro
			//jose paulo - nao tem no cadastro
			//rogeriop - já está recebendo
			//cleber renato pereira - nao tem no cadastro
			//marcelo henrique - nao tem no cadastro
		EndIf   
   	EndIf
			
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** "+cAcao+" ORDEM DE SERVIÇO DE FERRAMENTAL - "+ZDN->ZDN_ORDEM+" ***"
	oMail:cTo      := cTo

	oMail:Envia()


Return