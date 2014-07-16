/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCP025   ºAutor  ³João Felipe da Rosa º Data ³  26/11/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CONTROLE DE REMESSA P/ RETRABALHO                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "protheus.ch" 
#include "colors.ch"
#include "AP5MAIL.CH" 
#include "topconn.ch"

User Function NHPCP025()

Private aRotina, cCadastro

cCadastro := "Peças p/ Retrabalho"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_PCP25(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_PCP25(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_PCP25(4)"   , 0 , 4})
aAdd(aRotina,{ "Imprimir"       ,"U_PCP25Imp()" , 0 , 6})
aAdd(aRotina,{ "Excluir"        ,"U_PCP25(5)"   , 0 , 5})
aAdd(aRotina,{ "Devolução"      ,"U_PCP25(6)"   , 0 , 4})
aAdd(aRotina,{ "E-mails"        ,"U_PCP25(10)"  , 0 , 3})                        
aAdd(aRotina,{ "Legenda"        ,"U_PCP25Leg()" , 0 , 5})

mBrowse(6,1,22,75,"ZDG",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP25(nParam) 
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Private nPar 	 := nParam  
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)

Private cNum
Private cTM
Private dData  := CtoD("  /  /  ")
Private dData  := CtoD("  /  /  ")
Private cHora  := Space(5)
Private cPlaca := Space(8)
Private cMot   := Space(80)
Private cExp   := Space(6)
Private cNome  := ""
Private cObs   := ""
Private aArray := {}
Private lMsErroAuto := .F.

Private aHeader := {}
Private aCols   := {}

	//-- entra no cadastro de e-mails
	If nPar==10
		fCadEmail()
		Return
	EndIf
	
	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		cNum  := GetSxENum("ZDG","ZDG_NUM")
		dData := Date()
		cTM   := "E"
		cHora := Substr(Time(),1,5)
		fTrazMat(@cExp,@cNome)

		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		fCarrega()
		
		//guarda a posicao da tabela ZDG
		nRecZDG := ZDG->(Recno())
		
		ZDG->(dbSetOrder(1)) // FILIAL + NUM + TM
		If ZDG->(dbSeek(xFilial("ZDG")+cNum+"D"))
			Alert("Esta remessa já possui Devolução!")
			ZDG->(dbGoTo(nRecZDG))
			Return .F.
		EndIf
		
		//retorna a posicao da tabela ZDG
		ZDG->(dbGoTo(nRecZDG))
		
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	ElseIf nPar==6 //devolver
		fCarrega()
		dData := Date()
		cTM   := "D"
		cHora := Substr(Time(),1,5)
		fTrazMat(@cExp,@cNome)

		bOk := {|| fInclui()}
	EndIf

	aAdd(aHeader,{"Item"      , "ZDH_ITEM"    , PesqPict("ZDH","ZDH_ITEM")   , 04,00, ".F."           ,"","C","ZDH"}) // 1
	aAdd(aHeader,{"Produto"   , "ZDH_PROD"    , PesqPict("ZDH","ZDH_PROD")   , 15,00, "U_pcp25PROD()" ,"","C","ZDH"}) // 2
	aAdd(aHeader,{"Descrição" , "B1_DESC"     , PesqPict("SB1","B1_DESC")    , 50,00, ".F."           ,"","C","SB1"}) // 3
	aAdd(aHeader,{"Vol Envio" , "ZDH_VOLUME"  , PesqPict("ZDH","ZDH_VOLUME") , 06,00, ".T."           ,"","N","ZDH"}) // 4
	aAdd(aHeader,{"Qtd Envio" , "ZDH_QUANT"   , PesqPict("ZDH","ZDH_QUANT")  , 09,00, ".T."           ,"","N","ZDH"}) // 5
	aAdd(aHeader,{"Vol Devol" , "ZDH_VOLUME"  , PesqPict("ZDH","ZDH_VOLUME") , 06,00, ".F."           ,"","N","ZDH"}) // 6
	aAdd(aHeader,{"Qtd Devol" , "ZDH_QUANT"   , PesqPict("ZDH","ZDH_QUANT")  , 09,00, ".F."           ,"","N","ZDH"}) // 7
	aAdd(aHeader,{"Vol Saldo" , "ZDH_VOLUME"  , PesqPict("ZDH","ZDH_VOLUME") , 06,00, ".F."           ,"","N","ZDH"}) // 8
	aAdd(aHeader,{"Qtd Saldo" , "ZDH_QUANT"   , PesqPict("ZDH","ZDH_QUANT")  , 09,00, ".F."           ,"","N","ZDH"}) // 9

	If nPar==6 // DEVOLVER
		aHeader[2][6] := ".F."
		aHeader[4][6] := ".F."
		aHeader[5][6] := ".F."
		aHeader[6][6] := ".T."
		aHeader[7][6] := ".T."
	EndIf	
	
	If nPar==2 .or. nPar==5
		For x:=1 to Len(aHeader)
			aHeader[x][6] := ".F."
		Next
	EndIf	
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg   := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Peças p/ Retrabalho",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1  := TSay():New(20,10,{||"Número"},oDlg,,,,,,.T.,,)
	oSay2  := TSay():New(20,50,{||cNum},oDlg,,oFont1,,,,.T.,,)
	
    /********
    * ENVIO *  
    ********/
    oGroup1 := tGroup():New(30,5,110,305,"Informe os Dados",oDlg,,,.T.)

	oSay3 := TSay():New(40,10,{||"Data"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(38,50,{|u| if(Pcount() > 0, dData := u,dData)},oDlg,50,8,"99/99/99",{||},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4 .or. nPar==6},,,,,,,"dData")

	oSay4 := TSay():New(40,120,{||"Hora"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(38,155,{|u| if(Pcount() > 0, cHora := u,cHora)},oDlg,50,8,"99:99",{||},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4 .or. nPar==6},,,,,,,"cHora")

	oSay6 := TSay():New(40,220, {||"Placa"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(38,250,{|u| if(Pcount() > 0, cPlaca := u,cPlaca)},oDlg,50,8,"!!!-9999",{|| fValPlaca(cPlaca)},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4 .or. nPar==6},,,,,,,"cPlaca")

	oSay7 := TSay():New(52,10, {||"Motorista"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet5 := tGet():New(50,50,{|u| if(Pcount() > 0, cMot := u,cMot)},oDlg,250,8,"@!",{||},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4 .or. nPar==6},,,,,,,"cMot")

	oSay8 := TSay():New(64,10, {||"Expedidor"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet6 := tGet():New(62,50,{|u| if(Pcount() > 0, cExp := u,cExp)},oDlg,50,8,"@!",{|| fExpedi(@cExp,@cNome)},;
		,,,,,.T.,,,{||nPar==3 .or. nPar==4},,,,,,"QAA","cExp")
	oGet7 := tGet():New(62,105,{|u| if(Pcount() > 0, cNome := u,cNome)},oDlg,195,8,"@!",{||},;
		,,,,,.T.,,,{||.F.},,,,,,,"cNome")

	oSay9  := TSay():New(76,10,{||"Obs"},oDlg,,,,,,.T.,,)
	oMemo1 := tMultiget():New(74,50,{|u|if(Pcount()>0,cObs:=u,cObs)},;
	oDlg,250,30,,,,,,.T.,,,{|| nPar==3 .Or. nPar==4 .or. nPar==6})

    // cria o getDados
	oGeTD := MsGetDados():New( 120                ,; // superior
	                           aPosObj[2,2]       ,; // esquerda
	                           aPosObj[2,3]       ,; // inferior
	                           aPosObj[2,4]       ,; // direita
	                           4                  ,; // nOpc
	                           "U_PCP25LOK"       ,; // CLINHAOK
	                           "AllwaysTrue"      ,; // CTUDOOK
	                           ""                 ,; // CINICPOS
	                           .T.                ,; // LDELETA
	                           nil                ,; // aAlter
	                           nil                ,; // uPar1
	                           .F.                ,; // LEMPTY
	                           200                ,; // nMax
	                           nil                ,; // cCampoOk
	                           "AllwaysTrue()"    ,; // CSUPERDEL
	                           nil                ,; // uPar2
	                           "AllwaysTrue()"    ,; // CDELOK
	                           oDlg                ; // oWnd
	                          )
	                          
	If nPar==6
		oGetD:cDelOk := ".F."
	EndIf

	If nPar==2 .or. nPar==5 .or. nPar==6 //visualizar ou excluir
		oGetD:nMax := len(aCols) //nao deixa adicionar mais uma linha no acols
	EndIf

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return 

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()

	If nPar==4 //altera 
		//guarda a posicao da tabela ZDG
		nRecZDG := ZDG->(Recno())
		
		ZDG->(dbSetOrder(1)) // FILIAL + NUM + TM
		If ZDG->(dbSeek(xFilial("ZDG")+cNum+"D"))
			Alert("Esta remessa já possui Devolução!")
			Return .F.
		EndIf
		
		//retorna a posicao da tabela ZDG
		ZDG->(dbGoTo(nRecZDG))
	EndIf
	
	If Empty(dData)
		Alert("Informe a Data!")
		REturn .F.
	EndIF 
	     
	If Empty(cHora)
		alert("Informe a hora!")
		REturn .F.
	Endif
	
	If Empty(cPlaca)
		Alert("Informe a placa!")
		REturn .F.
	EndIf
	
	If Empty(cMot)
		Alert("Informa o Motorista!")
		Return .F.
	EndIf 
	
	If Empty(cExp)
		Alert("Informe o Expedidor!")
		Return .F.
	EndIf
	
	If len(aCols) <= 1 .and. Empty(aCols[1][2])
		Alert("Pelo menos um produto deve ser informado!")
		Return .F.
	Endif
	
	If nPar==6 //devol
	    
		If ZDG->ZDG_STATUS=="E"
			Alert("Já encerrado!")
			REturn .F.
		endIf
		
		For x:=1 to Len(aCols)
			If (aCols[x][8]-aCols[x][6]) < 0
				Alert("Volume Devolvido não pode ser maior que o Saldo!")
				Return .F.
			EndIf
			
			If (aCols[x][9]-aCols[x][7]) < 0
				Alert("Quantidade de Devolução não pode ser maior que o Saldo!")
				Return .F.
			EndIf
		Next
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()
Local cNumSeq := Iif(cTM=="E","01",fNumSeq())
	
	If !fValida()
		Return
	EndIf
	
   /*	DbSelectArea("SD3")
	_cDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc
	
	aArray := {{_cDoc,;		// 01.Numero do Documento
				Date()}}	// 02.Data da Transferencia	
	
	For x:= 1 to Len(aCols)
	
		If SB1->(DbSeek(xFilial("SB1")+aCols[x][2]))
		    
			aAdd(aArray,{SB1->B1_COD,;					// 01.Produto Origem
						 SB1->B1_DESC,;  				// 02.Descricao
						 SB1->B1_UM,; 	                // 03.Unidade de Medida
						 Iif(cTM=="E","32","25"),;		// 27.Local Origem
						 CriaVar("D3_LOCALIZ",.F.),;	// 05.Endereco Origem
						 SB1->B1_COD,;					// 06.Produto Destino
						 SB1->B1_DESC,;					// 07.Descricao
						 SB1->B1_UM,;					// 08.Unidade de Medida
						 Iif(cTM=="E","25","32"),;		// 09.Armazem Destino
						 CriaVar("D3_LOCALIZ",.F.),;	// 10.Endereco Destino
						 CriaVar("D3_NUMSERI",.F.),;	// 11.Numero de Serie
						 CriaVar("D3_LOTECTL",.F.),;	// 12.Lote Origem
7						 CriaVar("D3_NUMLOTE",.F.),;	// 13.Sublote
						 CriaVar("D3_DTVALID",.F.),;	// 14.Data de Validade
						 CriaVar("D3_POTENCI",.F.),;	// 15.Potencia do Lote
						 Iif(cTM=="E",aCols[x][5],aCols[x][7]),;// 16.Quantidade
						 CriaVar("D3_QTSEGUM",.F.),;	// 17.Quantidade na 2 UM             	
						 CriaVar("D3_ESTORNO",.F.),;	// 18.Estorno
						 CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq
						 CriaVar("D3_LOTECTL",.F.),;	// 20.Lote Destino
						 CRIAVAR("D3_DTVALID",.F.),;    // 21.Data Validade
						 CRIAVAR("D3_ITEMGRD",.F.),;    // 22.Item da grade
						 CRIAVAR("D3_CARDEF",.F.),;
						 CRIAVAR("D3_DEFEITO",.F.),;
						 CRIAVAR("D3_OPERACA",.F.),;
						 CRIAVAR("D3_FORNECE",.F.),;
						 CRIAVAR("D3_LOJA",.F.),;
						 CRIAVAR("D3_LOCORIG",.F.),;
						 SB1->B1_CC,;
						 CRIAVAR("D3_TURNO",.F.),;
						 CRIAVAR("D3_MAQUINA",.F.),;
						 CRIAVAR("D3_LINHA",.F.)})
		
		EndIf	
		
	Next
	
	Begin Transaction
	
	Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo...") //inclusão
	
	If lMsErroAuto
		mostraerro()
		DisarmTransaction()
		Return
	EndIf*/
	
	Reclock("ZDG",.T.)
		ZDG->ZDG_FILIAL := xFilial("ZDG")
		ZDG->ZDG_NUM    := cNum
		ZDG->ZDG_DATA   := dData
		ZDG->ZDG_HORA   := cHora
		ZDG->ZDG_PLACA  := cPlaca
		ZDG->ZDG_MOT    := cMot
		ZDG->ZDG_EXP    := cExp
		ZDG->ZDG_OBS    := cObs
		ZDG->ZDG_TM     := cTM
		ZDG->ZDG_STATUS := Iif(cTM=="E","A","")
		ZDG->ZDG_NUMSEQ := cNumSeq
	MsUnlock("ZDG")
	
	lEncerra := .T.
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado

			RecLock("ZDH",.T.)
				ZDH->ZDH_FILIAL := xFilial("ZDH")
				ZDH->ZDH_NUM    := cNum
				ZDH->ZDH_TM     := cTM
				ZDH->ZDH_ITEM   := aCols[x][1]
				ZDH->ZDH_PROD   := aCols[x][2]
				ZDH->ZDH_VOLUME := Iif(cTM=="E",aCols[x][4],aCols[x][6])
				ZDH->ZDH_QUANT  := Iif(cTM=="E",aCols[x][5],aCols[x][7])
				ZDH->ZDH_NUMSEQ := cNumSeq
			MsUnLock("ZDH")
			 
			//verufifica se o saldo ficou maior que zero
			If ((aCols[x][8]-aCols[x][6]) > 0 .or. ;
				(aCols[x][9]-aCols[x][7]) > 0)
				lEncerra := .F.
			EndIf

	    EndIf
	Next
	
	//Altera o status do envio para encerrado
	If cTM=="D" 
	        
		cRecZDG := ZDG->(Recno())//Guarda a posicao da tabela ZDG
		
		ZDG->(dbSetOrder(1)) //FILIAL + NUM + TM
		ZDG->(dbGoTop())
		If ZDG->(dbSeek(xFilial("ZDG")+cNum+"E"))
			RecLock("ZDG",.F.)
				ZDG->ZDG_STATUS := Iif(lEncerra,"E","P")
			MsUnlock("ZDG")
		EndIf
		
		ZDG->(dbGoTo(cRecZDG))//Retorna a posicao da tabela ZDG
	
	Else
		ConfirmSx8()
	EndIf

	If !MsgYesNo("Deseja enviar aviso de embarque?","Aviso de Embarque")
		oDlg:End()
	Else
		fEmail(cTM)	//envia email de aviso
	EndIf
	
	
//	End Transaction
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ retorna o último numseq da movimentacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fNumSeq()
Local nNumSeq
Local cAl := getnextalias()

	beginSql Alias cAl
		SELECT MAX(ZDG_NUMSEQ) NSEQ
		FROM %Table:ZDG%
		WHERE ZDG_NUM  = %Exp:ZDG->ZDG_NUM%
		AND ZDG_FILIAL = %xFilial:ZDG%
		AND %NotDel%
	EndSql		

   	nNumSeq := Iif(!Empty((cAl)->NSEQ),StrZero(Val((cAl)->NSEQ) + 1,2),"01")
   	
   	(cAl)->(dbCloseArea())

return nNumSeq

//ÚÄÄÄÄÄÄÄÄ¿
//³ ALTERA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fAltera()
	
	If !fValida()
		Return
	EndIf
	
	ZDG->(dbSetOrder(1))//FILIAL + NUM + TM 
	ZDH->(dbSetOrder(1))//FILIAL + NUM + TM + ITEM
	
	RecLock("ZDG",.F.)
		ZDG->ZDG_DATA  := dData
		ZDG->ZDG_HORA  := cHora
		ZDG->ZDG_PLACA := cPlaca
		ZDG->ZDG_MOT   := cMot
		ZDG->ZDG_EXP   := cExp
		ZDG->ZDG_OBS   := cObs
	MsUnLock("ZDG")
	
	For x:=1 to Len(aCols)
		If !aCols[x][len(aHeader)+1] //nao pega quando estiver deletado
			If ZDH->(dbSeek(xFilial("ZDH")+cNum+cTM+aCols[x][1]))
				RecLock("ZDH",.F.)
					ZDH->ZDH_PROD   := aCols[x][2]
					ZDH->ZDH_VOLUME := aCols[x][4]
					ZDH->ZDH_QUANT  := aCols[x][5]
				MsUnLock("ZDH")
			Else
				RecLock("ZDH",.T.)
					ZDH->ZDH_FILIAL := xFilial("ZDH")
					ZDH->ZDH_NUM    := cNum
					ZDH->ZDH_TM     := cTM
					ZDH->ZDH_ITEM   := aCols[x][1]
					ZDH->ZDH_PROD   := aCols[x][2]
					ZDH->ZDH_VOLUME := aCols[x][4]
					ZDH->ZDH_QUANT  := aCols[x][5]
					ZDH->ZDH_NUMSEQ := ZDG->ZDG_NUMSEQ
				MsUnLock("ZDH")
			EndIf
		Else
			If ZDH->(dbSeek(xFilial("ZDH")+cNum+cTM+aCols[x][1]))
				RecLock("ZDH",.F.)
					ZDH->(dbDelete())
				MsUnlock("ZDH")
			EndIf
	    EndIf
	Next

	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()
Local nZDGRec := ZDG->(Recno())
                                                     
	ZDH->(dbSetOrder(1))//FILIAL + NUM + ITEM
	
	If MsgYesNo("Tem certeza de que deseja excluir?")
	
		ZDG->(dbSetOrdeR(1))
		ZDG->(dbGoTop())
		If ZDG->(dbSeek(xFilial("ZDG")+cNum+"D"))
			ZDG->(dbGoTo(nZDGRec))
			Alert("Remessa já existe Devolução!")
			Return
		Else
			
			ZDG->(dbGoTo(nZDGRec))

			RecLock("ZDG",.F.)
				ZDG->(dbDelete())
			MsUnLock("ZDG")
	
			If ZDH->(dbSeek(xFilial("ZDH")+cNum))
				WHILE ZDH->(EOF()) .and. ZDH->ZDH_NUM==cNum
					
					RecLock("ZDH",.F.)
						ZDH->(dbDelete())
					MsUnLock("ZDH")
					
					ZDH->(dbSkip())
				ENDDO
			EndIf
			
		EndIf
		
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()

cNum   := ZDG->ZDG_NUM

If nPar!=6 //nao devolucao

	cTM    := ZDG->ZDG_TM
	dData  := ZDG->ZDG_DATA
	cHora  := ZDG->ZDG_HORA
	cPlaca := ZDG->ZDG_PLACA
	cMot   := ZDG->ZDG_MOT
	cExp   := ZDG->ZDG_EXP
	cObs   := ZDG->ZDG_OBS
	cNome  := Posicione("QAA",1,xFilial("QAA")+cExp,"QAA_NOME")

EndIf	

ZDH->(dbSetOrder(1))

If ZDH->(dbSeek(xFilial("ZDH")+cNum))
	While ZDH->(!EOF()) .AND. ZDH->ZDH_NUM==cNum
		
		If ZDH->ZDH_TM=="E"

			aAdd(aCols,{ZDH->ZDH_ITEM,;
   		    			ZDH->ZDH_PROD,;
         			    Posicione("SB1",1,xFilial("SB1")+ZDH->ZDH_PROD,"B1_DESC"),;
     	     		    ZDH->ZDH_VOLUME,; //envio
	             	    ZDH->ZDH_QUANT,;  //envio
	             	    0,; //devol
	            	    0,; //devol
     	    		    ZDH->ZDH_VOLUME,; //saldo
	            	    ZDH->ZDH_QUANT,;  //saldo
	            	    .F.})
	  	EndIf
	            	   
		ZDH->(dbSkip())
    EndDo
    
EndIf

If ZDH->(dbSeek(xFilial("ZDH")+cNum))
	While ZDH->(!EOF()) .AND. ZDH->ZDH_NUM==cNum

	  	If ZDH->ZDH_TM=="D"

	    	_n := aScan(aCols,{|x| x[1]==ZDH->ZDH_ITEM .and. x[2]==ZDH->ZDH_PROD })
	    	If _n<>0
		    	If nPar==2 //visual
			    	aCols[_n][6] += ZDH->ZDH_VOLUME //devol
		    		aCols[_n][7] += ZDH->ZDH_QUANT	//devol
		    	EndIf
	    		aCols[_n][8] -= ZDH->ZDH_VOLUME //saldo
	    		aCols[_n][9] -= ZDH->ZDH_QUANT  //saldo
	    	EndIf

	  	EndIf

		ZDH->(dbSkip())
    EndDo
    
EndIf


Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIALIZA O ITEM NO ACOLS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ZDH_ITEM()
Local cItem := ""
Local nItem := n

    For x:=1 to Len(aCols)-1
    	If Val(aCols[x][1]) >= nItem
	    	nItem := Val(aCols[x][1])+1
	    EndIf
	Next    

	cItem := StrZero(nItem,4)

Return cItem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O PRODUTO E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function pcp25PROD()
Local nDesc := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="B1_DESC"})

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+M->ZDH_PROD))

		/*If SB1->B1_LOCALIZ <> "N"
			Alert("Produto controlado por local!")
			Return .F.
		EndIf
		If SB1->B1_RASTRO <> "N"
			Alert("Produto controlado por lote!")
			Return .F.
		EndIf*/
		
		aCols[n][nDesc] := SB1->B1_DESC
		
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf
	
	oGetD:Refresh()

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA ALINHA DO MULTILINE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP25LOK()
	
	If Empty(aCols[n][2])
		Alert("Informe o produto!")
		REturn .F.
	EndIf
	
	If Empty(aCols[n][4])
		Alert("Informe a quantidade!")
		REturn .F.
	EndIf
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DE LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP25Leg()
Local aLegenda :=	{	{"BR_VERDE"   , "Aberto"     },;
						{"BR_AMARELO" , "Parcial"    },;
  						{"BR_VERMELHO", "Devolvido"  },;
  						{"BR_CINZA"   , "Devolução"  }}
  						
BrwLegenda("Peças p/ Retrabalho", "Legenda", aLegenda)

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A LEGENDA DO BROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()
Local aLegenda :=	{	{"BR_VERDE"   , "Aberto"     },;
						{"BR_AMARELO" , "Parcial"    },;
  						{"BR_VERMELHO", "Devolvido"  },;
  						{"BR_CINZA"   , "Devolução"  }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZDG_TM=="E" .AND. ZDG_STATUS=="A"' , aLegenda[1][1] })
Aadd(uRetorno, { 'ZDG_TM=="E" .AND. ZDG_STATUS=="P"' , aLegenda[2][1] })
Aadd(uRetorno, { 'ZDG_TM=="E" .AND. ZDG_STATUS=="E"' , aLegenda[3][1] })
Aadd(uRetorno, { 'ZDG_TM=="D"'						 , aLegenda[4][1] })

Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A MATRICULA DO EXPEDIDOR E TRAZ O NOME ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fExpedi(cExp,cNome)

	QAA->(dbsetorder(1))
	If QAA->(dbseek(xFilial("QAA")+cExp))
		cNome := QAA->QAA_NOME
	Else
		Alert("Funcionário não encontrado!")
		Return .f.
	EndIf

Return .t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A PLACA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValPlaca(cPlaca)

	If !Empty(cPlaca)
	
	   If Len(Alltrim(cPlaca)) <> 8
	      Alert("Placa Digitada Errada, Verifique !!!" +chr(13)+;
	             "A Placa so Pode conter LETRAS E NUMEROS.")  
	      Return(.F.)       
	   Endif
	
	   For _nNum:= 1 to 3
	      _lFlag := Entre("A","Z",Subs(cPlaca,_nNum,1))   
	      If !_lFlag
	         Alert("Placa Digitada Errada, Verifique !!!" +chr(13)+;
	             "A Placa so Pode conter LETRAS E NUMEROS.")  
	         Return(.F.)       
	      Endif      
	   Next
	
	   For _nNum:=5 to 8
	      _lFlag := Entre("0","9",Subs(cPlaca,_nNum,1))   
	      If !_lFlag
	         Alert("Placa Digitada Errada, Verifique !!!" +chr(13)+;
	             "A Placa so Pode conter LETRAS E NUMEROS.")  
	         Return(.F.)       
	      Endif      
	   Next 
	
	Endif
	
Return .T.

Static Function fTrazMat(cMat,cNome)

	QAA->(dbSetOrder(6)) // login
	If QAA->(dbSeek(UPPER(ALLTRIM(cUserName))))
		cMat  := QAA->QAA_MAT
		cNome := QAA->QAA_NOME
	Else
		Alert("Favor cadastrar o usuário "+UPPER(ALLTRIM(cUserName))+" no cadastro de usuários para trazer a matrícula!")
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA O AVISO DE INCLUSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEmail(cTM)
Local aArr := {}
Local nItens := 0
Local aPlanta := {"","FUNDIÇÃO","","FORJARIA",""}
Local cNPlanta

	SB1->(dbsetorder(1))
	If SB1->(DbSeek(xFilial("SB1")+aCols[1][2]))			//pega o primeiro produto para checar o destino da peça (forjaria ou fundição)
		If SB1->B1_GRUPO == "PA01"
			nPlanta := 2
		Else
			nPlanta := 4
		EndIf
	Else
		Return
	EndIf

	If cTM=="E"
		aAdd(aArr,ZDG->ZDG_NUM+" - ENVIO DE PEÇAS PARA RETRABALHO NA "+aPlanta[nPlanta])
	Else
		aAdd(aArr,ZDG->ZDG_NUM+" - RETORNO APÓS RETRABALHO DE PEÇAS NA "+aPlanta[nPlanta])
	EndIf

	aAdd(aArr,DtoC(ZDG->ZDG_DATA))
	aAdd(aArr,ZDG->ZDG_HORA)
	aAdd(aArr,ZDG->ZDG_MOT)
	aAdd(aArr,ZDG->ZDG_OBS)

	cMsg := '<style type="text/css">'
	cMsg += 'table{font-family:Arial;font-size:12px;'
	cMsg += 'border-collapse:collapse;'
	cMsg += 'border-color:#666666;
	cMsg += 'color:#333333}'
	cMsg += '</style>'

	cMsg += '<table border="1" width="100%">'
	
	cMsg += '<tr>'
	cMsg += '<td bgcolor="#cccccc" colspan="4" align="center">'+aArr[1]+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td bgcolor="#CCCCCC" width="120">Data</td>'
	cMsg += '<td>'+aArr[2]+'</td>'
	cMsg += '<td bgcolor="#CCCCCC">Hora</td>'
	cMsg += '<td>'+aArr[3]+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td bgcolor="#CCCCCC">Obs.</td>'
	cMsg += '<td colspan="3">'+aArr[5]+'</td>'
	cMsg += '</tr>'

	cMsg += '</table><br />'
	
	//Peças
	cMsg += '<table border="1" width="100%">'	

	cMsg += '<tr>'
	cMsg += '<td bgcolor="#CCCCCC" align="center" width="150">Peça</td>'
	cMsg += '<td bgcolor="#CCCCCC">Descrição</td>'
	cMsg += '<td bgcolor="#CCCCCC" align="center">Volume</td>'
	cMsg += '<td bgcolor="#CCCCCC" align="center">Quant</td>'
	cMsg += '</tr>'

	For x:=1 to Len(aCols)

		If (cTM=="D" .AND. (aCols[x][6]!=0 .or. aCols[x][7]!=0)) .or. cTM=="E"
			cMsg += '<tr>'
			cMsg += '<td align="center">'+aCols[x][2]+'</td>'
			cMsg += '<td>'+aCols[x][3]+'</td>'
			cMsg += '<td align="center">'+AllTrim(Str(Iif(cTM=="E",aCols[x][4],aCols[x][6])))+'</td>'
			cMsg += '<td align="center">'+AllTrim(Str(Iif(cTM=="E",aCols[x][5],aCols[x][7])))+'</td>'
			cMsg += '</tr>'
			
			nItens++
    	EndIf

    Next
    
	cTo := ""
    
    cAl := getnextalias()
    
    beginSql alias cAl
        SELECT * FROM %Table:ZEI%
        WHERE ZEI_FILIAL = %xFilial:ZEI%
        AND ZEI_PLANTA = %Exp:nPlanta%
        AND %NotDel%
    endSql
                          
    
    While (cAl)->(!eof())
    	cTo += (cAl)->ZEI_EMAIL + ';'
    	(cAl)->(dbskip())
    Enddo

	cMsg += '</table><br><br>'
	
	oMail := Email():New()
	oMail:cAssunto := "*** "+aArr[1]+" ***"
	
	oMail:cTo := cTo
	/*
	oMail:cTo := "mariocp@whbusinagem.com.br;"
	oMail:cTo += "lucianoc@whbfundicao.com.br;"
	oMail:cTo += "brunorf@whbfundicao.com.br;"
	oMail:cTo += "evaldomc@whbfundicao.com.br;"
	oMail:cTo += "luizfr@whbbrasil.com.br;"
	oMail:cTo += "luizgb@whbbrasil.com.br;"
	oMail:cTo += "geandroo@whbbrasil.com.br;"
	oMail:cTo += "antoniocd@whbbrasil.com.br;"
	oMail:cTo += "gustavolv@whbbrasil.com.br;"
	oMail:cTo += "ericalp@whbbrasil.com.br;"
	oMail:cTo += "hesslerr@whbbrasil.com.br;"
	oMail:cTo += "emersondp@whbbrasil.com.br;"
	oMail:cTo += "adilsonmj@whbbrasil.com.br;"
	oMail:cTo += "alexsm@whbbrasil.com.br;"
	oMail:cTo += "marciols@whbbrasil.com.br;"   
	oMail:cTo += "fabiof@whbbrasil.com.br;"
	oMail:cTo += "carlosps@whbbrasil.com.br;"
	oMail:cTo += "custodiofs@whbbrasil.com.br;"
	oMail:cTo += "lilianeg@whbbrasil.com.br;"
	oMail:cTo += "olaird@whbbrasil.com.br;"
	oMail:cTo += "gilvanios@whbbrasil.com.br;"
	oMail:cTo += "josinaldosp@whb.interno;"
	oMail:cTo += "rafaelaab@whbbrasil.com.br;"
	oMail:cTo += "andrsonsc@whbbrasil.com.br;"	
	oMail:cTo += "custodiofs@whbbrasil.com.br;"	
	oMail:cTo += "custodiocs@whbbrasil.com.br;"
	oMail:cTo += "edersonsf@whb.interno;"	
	oMail:cTo += "jeancs@whbbrasil.com.br;"
	oMail:cTo += "mateushd@whbbrasil.com.br;"	
	oMail:cTo += "diogoba@whbbrasil.com.br;"	
	oMail:cTo += "rodrigopv@whbbrasil.com.br;"	
	oMail:cTo += "fabiolm@whbbrasil.com.br;"	 	
	*/

	oMail:cMsg := cMsg
	
	If nItens==0
		Return
	Else
		oMail:Envia()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCP25Imp ºAutor  ³ João Felipe da Rosaº Data ³ 16/09/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO DE CARREGAMENTO                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOGÍSTICA / PCP                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PCP25Imp()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZDG"
    oRelato:cPerg    := "PCP025"
	oRelato:cNomePrg := "NHPCP25"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Apresenta os ítens que são enviados para a Fundição"
	oRelato:cDesc2   := "pare serem retrabalhados"

	//titulo
	oRelato:cTitulo  := "REMESSA PARA RETRABALHO"

	//cabecalho
	oRelato:cCabec1  := "Num. Controle: "+ZDG->ZDG_NUM
    oRelato:cCabec2  := ""
    
/*
	aAdd(aPergs,{"De  Grupo ?"         ,"C", 6,0,"G","","","","","","SBM",""})
	aAdd(aPergs,{"Ate Grupo ?"         ,"C", 6,0,"G","","","","","","SBM",""})
	aAdd(aPergs,{"De  Data ?"          ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"Ate Data ?"          ,"D", 8,0,"G","","","","","","","99/99/9999"})
	aAdd(aPergs,{"De  Cliente ?"       ,"C", 6,0,"G","","","","","","SA1",""})
	aAdd(aPergs,{"Ate Cliente ?"       ,"C", 6,0,"G","","","","","","SA1",""})
	aAdd(aPergs,{"De  Loja ?"          ,"C", 2,0,"G","","","","","","",""})
	aAdd(aPergs,{"Ate Loja ?"          ,"C", 2,0,"G","","","","","","",""})
	aAdd(aPergs,{"Status ?"            ,"N", 1,0,"C","Pendentes","Encerrados","Ambos","","","",""})
	aAdd(aPergs,{"Frete Emergencial ?" ,"N", 1,0,"C","Sim","Nao","Ambos","","","",""})

	oRelato:AjustaSx1(aPergs)
*/
		    
	oRelato:Run({||Imprime()})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local cNum := ZDG->ZDG_NUM                                                              

	//-- E N V I O 
	
	ZDG->(dbSetOrder(1)) // FILIAL + NUM + TM
	ZDG->(dbGoTop())
	ZDG->(dbSeek(xFilial("ZDG")+cNum+"E"))
    
	If !ZDG->(Found())
		Alert("Não encontrado!")
		return .f.
	EndIf

	oRelato:Cabec()

	fImpRet("E")	

	//-- D E V O L U Ç Õ E S

	ZDG->(dbGoTop())
	ZDG->(dbSeek(xFilial("ZDG")+cNum+"D"))

	While ZDG->(!EOF()) .AND. ZDG->ZDG_NUM==cNum
		If ZDG->ZDG_TM<>"D"
			ZDG->(dbSkip())
			Loop
		EndIF
		
		oRelato:Cabec()
		fImpRet("D")	
		
		ZDG->(dbSkip())
	EndDo

Return


Static Function fImpRet(cTM)

	@Prow()+1,001 psay Iif(cTM=="D","DEVOLUÇÃO","ENVIO") + Repli("-",180)
	
	@ prow()+1,000 PSAY ""
	
	@Prow()+1 , 001 psay "Motorista: "+ZDG->ZDG_MOT
	@Prow()   , 080 psay "Data: "+DtoC(ZDG->ZDG_DATA)
	@Prow()+1 , 001 psay "Placa: "+ZDG->ZDG_PLACA
	@Prow()   , 080 psay "Hora: "+ZDG->ZDG_HORA
	@Prow()+1 , 001 psay "Expedidor: " + Posicione("QAA",1,xFilial("QAA")+ZDG->ZDG_EXP,"QAA_NOME")
	@Prow()+1 , 001 psay "Obs.:: " + ZDG->ZDG_OBS
	
	@ prow()+1,000 PSAY ""
   
	@Prow()+1 , 001 psay "ITEM     PRODUTO           DESCRICAO                                                         VOLUME    QUANTIDADE   QUANT.RECEBIDA"
	@Prow()+1 , 001 psay ""
		
	ZDH->(dbSetOrder(1)) //FILIAL + NUM + TM + ITEM
	ZDH->(dbSeek(xFilial("ZDH")+ZDG->ZDG_NUM+cTM))
	
	_nTVol := 0
		
	While ZDH->(!EOF()) .AND. ZDH->ZDH_NUM == ZDG->ZDG_NUM
		
		If ZDH->ZDH_TM<>cTM .OR. ZDH->ZDH_NUMSEQ <> ZDG->ZDG_NUMSEQ
			ZDH->(dbSkip())
			Loop
		EndIf
		
		If Prow() > 65
			oRelato:Cabec()
		EndIf	
		
		@Prow()+1, 001 psay ZDH->ZDH_ITEM
		@Prow()  , 010 psay ZDH->ZDH_PROD
		
		@Prow()  , 028 psay Posicione("SB1",1,xFilial("SB1")+ZDH->ZDH_PROD,"B1_DESC")
			
		@Prow()  , 094 psay ZDH->ZDH_VOLUME picture "@e 99999"
		@Prow()  , 107 psay ZDH->ZDH_QUANT picture "@e 99999"
		@Prow()  , 120 psay "___________"
				
		_nTVol += ZDH->ZDH_VOLUME
			
		ZDH->(DbSkip())

	EndDo
	
	@Prow()+2 , 070 psay "Total de volumes: "
	@Prow()   , 094 psay _nTVol picture "@e 99999"
		 
	@Prow()+5 , 005 psay "_______________________________________   _______________________________________   _______________________________________"
	@Prow()+1 , 005 psay "               Expedidor                                 Motorista                                 Recebimento"

Return

Static Function	fCadEmail()
	axCadastro("ZEI")
Return
