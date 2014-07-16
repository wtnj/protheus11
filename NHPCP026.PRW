/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP026  ºAutor  ³João Felipe da Rosa º Data ³  03/02/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PROGRAMA DE PRODUCAO                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                

#INCLUDE "protheus.ch"   
#INCLUDE "topconn.ch"

User Function NHPCP026()

cCadastro := "PROGRAMA DE PRODUÇÃO"
aRotina := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_PCP26(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_PCP26(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_PCP26(4)"   , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_PCP26(5)"   , 0 , 5})
aAdd(aRotina,{ "Revisao"		,"U_PCP26(6)" 	, 0 , 5})
aAdd(aRotina,{ "Legenda"        ,"U_PCP26LEG()" , 0 , 6})
//aAdd(aRotina,{ "Atu. Emin"      ,"U_PCP26EMI()" , 0 , 6})

mBrowse(6,1,22,75,"ZDK",,,,,,fCriaCor())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP26(nParam) 
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Local aButtons   := {}
Private nPar 	 := nParam  
Private aSize    := MsAdvSize()
Private aObjects := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj  := MsObjSize( aInfo, aObjects, .T.)

//variaveis do cadastro
Private cNum, cRev, dDtDigit,;
	    cMes    := "",;
	    cAno    := Space(4)

//variaveis auxiliares
Private aMes    := {},;
        aHeader := {},;
        aCols   := {},;
		aItens  := {}
Private	cPlanta 

	If SM0->M0_CODIGO=="IT"
		aItens  := {"","1=Itesapar"}				
	Else
		aItens  := {"","1=Usinagem","2=Fundição Ferro","4=Forjaria","5=Virabrequim","6=Aluminio"}		
	Endif

	aAdd(aHeader,{"Item"        , "ZDL_ITEM"    , PesqPict("ZDL","ZDL_ITEM")   , 04,00, ".F."             ,"","C","ZDL"})
	aAdd(aHeader,{"Produto"     , "ZDL_COD"     , PesqPict("ZDL","ZDL_COD")    , 15,00, "U_PCP26PRD()"    ,"","C","ZDL"})
	aAdd(aHeader,{"Descrição"   , "B1_DESC"     , PesqPict("SB1","B1_DESC")    , 50,00, ".F."             ,"","C","SB1"})
	aAdd(aHeader,{"Cliente"     , "ZDL_CLIENT"  , PesqPict("ZDL","ZDL_CLIENT") , 06,00, "U_PCP26CLI(.F.)" ,"","C","ZDL"})
	aAdd(aHeader,{"Loja"        , "ZDL_LOJA"    , PesqPict("ZDL","ZDL_LOJA")   , 02,00, "U_PCP26CLI(.T.)" ,"","C","ZDL"})
	aAdd(aHeader,{"Nome Cliente", "ZDL_DESCLI"  , PesqPict("ZDL","ZDL_DESCLI") , 40,00, ".F."             ,"","C","ZDL"})
	aAdd(aHeader,{"Tipo"        , "ZDL_TIPO"    , PesqPict("ZDL","ZDL_TIPO")   , 20,00, ".T."             ,"","C","ZDL"})
	aAdd(aHeader,{"Turno"       , "ZDL_TURNO"   , PesqPict("ZDL","ZDL_TURNO")  , 01,00, ".T."             ,"","C","ZDL"})
	aAdd(aHeader,{"Saldo Exp."  , "B2_QATU"     , PesqPict("SB2","B2_QATU")    , 09,00, ".F."             ,"","N","SB2"}) // 9 
	aAdd(aHeader,{"Total"       , "ZDL_MES01"   , PesqPict("ZDL","ZDL_MES01")  , 08,00, ".F."             ,"","N","ZDL"})
	For x:=1 to 31
		aAdd(aHeader,{"Dia "+StrZero(x,2)  , "ZDL_PREV"+StrZero(x,2) , PesqPict("ZDL","ZDL_PREV"+Strzero(x,2)) , 06,00, "U_PCP26TOT("+AllTrim(Str(x))+")" ,"","N","ZDL"})
	Next
	aAdd(aHeader,{"Mês 01"    , "ZDL_MES01"    , PesqPict("ZDL","ZDL_MES01")  , 08,00, ".T."           ,"","N","ZDL"})
	aAdd(aHeader,{"Mês 02"    , "ZDL_MES02"    , PesqPict("ZDL","ZDL_MES02")  , 08,00, ".T."           ,"","N","ZDL"})
	aAdd(aHeader,{"Mês 03"    , "ZDL_MES03"    , PesqPict("ZDL","ZDL_MES03")  , 08,00, ".T."           ,"","N","ZDL"})

	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
	
		cRev := "00"
		dDtDigit := date()
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
		aAdd(aButtons,{"MENURUN",{||Processa({||fCarreg()},"Carregando ítens... Aguarde")},"Carrega ítens da última programação","Carrega"})
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
		aAdd(aButtons,{"MENURUN",{||Processa({||fGeraPV()},"Gerando Programa de Produção... Aguarde")},"Gera a Programa de Produção","Gera"})
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	ElseIf nPar==6 //revisao
		If ZDK->ZDK_STATUS!="E"
			Alert("Programa ainda não foi Gerado!")
			Return
		EndIf
		fCarrega()
		cRev := fUltRev(cNum)
		cRev := StrZero(Val(cRev)+1,2)
		bOk := {|| fInclui()}
	
	EndIf

	// Cria um array com os valores {"Janeiro","Fevereiro",...}
	For x:=1 to 12
		aAdd(aMes,MesExtenso(x))
	Next
	                                               
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,aButtons)}

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
			
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Programa de Produção",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Número"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,50,{||cNum},oDlg,,oFont1,,,,.T.,,)
	
	oSay3 := TSay():New(20,130,{||"Revisão"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(18,170,{|u| If(Pcount() > 0, cRev := u,cRev)},oDlg,15,8,"@e 99",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"cRev")


	oSay4 := TSay():New(32,10,{||"Data"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(30,50,{|u| if(Pcount() > 0, dDtDigit := u,dDtDigit)},oDlg,45,8,"@e 99/99/9999",{||.T.},;
		,,,,,.T.,,,{|| .F. },,,,,,,"dDtDigit")

	oSay5 := TSay():New(32,130,{||"Mês"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oCombo1 := TComboBox():New(30,170,{|u| if(Pcount() > 0,cMes := u,cMes)},;
	aMes,40,20,oDlg,,{||},,,,.T.,,,,{||.T.},,,,,"cMes")

	oSay6 := TSay():New(44,10,{||"Ano"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(42,50,{|u| if(Pcount() > 0, cAno := u,cAno)},oDlg,30,8,"@e 9999",{||fValAno()},;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"cAno")
	
	oSay7 := TSay():New(44,130,{||"Empresa"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oPlanta := TComboBox():New(42,170,{|u| if(Pcount() > 0,cPlanta := u,cPlanta)},;
		aItens,50,10,oDlg,,/*VALID*/,,,,.T.,,,,/*{||nPar==3 .or. nPar==4}*/,,,,,"cPlanta")

    // cria o getDados
	oGeTD := MsGetDados():New( 56               ,; //superior
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

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()  
Local nItens := 0

	If nPar==4 .or. nPar==5 //alterar , excluir
		If ZDK->ZDK_STATUS=="E"
			Alert("Programa de Produção já foi Gerado!")
			Return .F.
		EndIf
	EndIf
	
	If Empty(cMes)
		Alert("Mês não informado!")
		Return .F.
	EndIf
	
	If Empty(cAno)
		Alert("Ano não informado!")
		Return .F.
	EndIf
	
	For x:=1 to Len(aCols)
		If !Empty(aCols[x][2])
			nItens++
		EndIf
	Next
	
	If nItens<1
		Alert("Pelo menos um item deve ser informado!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ INCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fInclui()

	If nPar = 3	
		If Alltrim(cPlanta) = '1'
		   	cNum := GetSxENum("ZDK","ZDK_NUM")
		else
		    cNum := strzero(Val(GetSxENum("ZDK","ZDK_NUM"))+900000,6)
		EndIf  
	EndIF		
	
	
	If !fValida()
		Return
	EndIf
	
	//GRAVA O CABECALHO
	RECLOCK("ZDK",.T.)
		ZDK->ZDK_FILIAL := xFilial("ZDK")
		ZDK->ZDK_NUM    := cNum
		ZDK->ZDK_REV    := cRev
		ZDK->ZDK_DTDIGI := dDtDigit
		ZDK->ZDK_MES    := StrZero(oCombo1:nAt,2)
		ZDK->ZDK_ANO    := cAno
		ZDK->ZDK_STATUS := "P"
		ZDK->ZDK_PLANTA	:= cPlanta
	MSUNLOCK("ZDK")
	    
	//GRAVA OS ITENS DO CABECALHO
	For x:=1 to Len(aCols)
		If !aCols[x][Len(aHeader)+1] //nao pega quando estiver deletado
			RECLOCK("ZDL",.T.)
				ZDL->ZDL_FILIAL := xFilial("ZDL")
				ZDL->ZDL_NUM    := cNum       
				ZDL->ZDL_REV    := cRev
				ZDL->ZDL_ITEM   := aCols[x][1]
				ZDL->ZDL_COD    := aCols[x][2]
				ZDL->ZDL_CLIENT := aCols[x][4]
				ZDL->ZDL_LOJA   := aCols[x][5]
				ZDL->ZDL_TIPO   := aCols[x][7]
				ZDL->ZDL_TURNO  := Substr(aCols[x][8],1,1)
				For y:=1 to 31
					cField := "ZDL->ZDL_PREV"+StrZero(y,2)
					&(cField) := aCols[x][y+10]
				Next
				ZDL->ZDL_MES01 := aCols[x][42]
				ZDL->ZDL_MES02 := aCols[x][43]
				ZDL->ZDL_MES03 := aCols[x][44]
			MSUNLOCK("ZDL")
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
                      
	ZDK->(dbSetOrder(1)) // FILIAL + NUM + REV
	ZDK->(dbSeek(xFilial("ZDK")+cNum+cRev))
	
	//GRAVA O CABECALHO
	RECLOCK("ZDK",.F.)
		ZDK->ZDK_MES    := StrZero(oCombo1:nAt,2)
		ZDK->ZDK_ANO    := cAno
	MSUNLOCK("ZDK")
	    
	//GRAVA OS ITENS DO CABECALHO
	ZDL->(dbSetOrder(1)) //FILIAL + NUM + REV + ITEM
	For x:=1 to Len(aCols)
		If !aCols[x][Len(aHeader)+1] //nao pega quando estiver deletado
		
			If ZDL->(dbSeek(xFilial("ZDL")+cNum+cRev+aCols[x][1]))
				RecLock("ZDL",.F.)
					ZDL->ZDL_COD    := aCols[x][2]                                       
					ZDL->ZDL_CLIENT := aCols[x][4]
					ZDL->ZDL_LOJA   := aCols[x][5]
					ZDL->ZDL_TIPO   := aCols[x][7]
					ZDL->ZDL_TURNO  := Substr(aCols[x][8],1,1)
					For _y:=1 to 31
						cField := "ZDL->ZDL_PREV"+StrZero(_y,2)
						&(cField) := aCols[x][_y+10]
					Next _y
					ZDL->ZDL_MES01 := aCols[x][42]
					ZDL->ZDL_MES02 := aCols[x][43]
					ZDL->ZDL_MES03 := aCols[x][44]
				MsUnlock("ZDL")
			Else
				RecLock("ZDL",.T.)
					ZDL->ZDL_FILIAL := xFilial("ZDL")
					ZDL->ZDL_NUM    := cNum       
					ZDL->ZDL_REV    := cRev
					ZDL->ZDL_ITEM   := aCols[x][1]
					ZDL->ZDL_COD    := aCols[x][2]
					ZDL->ZDL_CLIENT := aCols[x][4]
					ZDL->ZDL_LOJA   := aCols[x][5]
					ZDL->ZDL_TIPO   := aCols[x][7]					
					ZDL->ZDL_TURNO  := Substr(aCols[x][8],1,1)
					For _y:=1 to 31
						cField := "ZDL->ZDL_PREV"+StrZero(_y,2)
						&(cField) := aCols[x][_y+10]
					Next _y
					ZDL->ZDL_MES01 := aCols[x][42]
					ZDL->ZDL_MES02 := aCols[x][43]
					ZDL->ZDL_MES03 := aCols[x][44]
				MsUnLock("ZDL")
			EndIf
		Else
			If ZDL->(dbSeek(xFilial("ZDL")+cNum+cRev+aCols[x][1]))
				RECLOCK("ZDL",.F.)
					ZDL->(dbDelete())
				MSUNLOCK("ZDL")
			EndIf
		EndIf
	Next
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

	If !fValida()
		Return
	EndIf

	If MsgYesNo("Tem certeza de que deseja excluir?")

		ZDK->(dbSetOrder(1)) // FILIAL + NUM + REV
		ZDK->(dbSeek(xFilial("ZDK")+cNum+cRev))
		
		//APAGA O CABECALHO
		RECLOCK("ZDK",.F.)
			ZDK->(dbDelete())
		MSUNLOCK("ZDK")
		    
		//APAGA OS ITENS DO CABECALHO
		ZDL->(dbSetOrder(1)) //FILIAL + NUM + REV + ITEM
		For x:=1 to Len(aCols)
			If ZDL->(dbSeek(xFilial("ZDL")+cNum+cRev+aCols[x][1]))
				RECLOCK("ZDL",.F.)
					ZDL->(dbDelete())
				MSUNLOCK("ZDL")
			EndIf
		Next
	
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS DADOS PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
Local aArray := {}
Local cField := ""
Local nTotal := 0

	//RECUPERA O CABECALHO
	cNum     := ZDK->ZDK_NUM
	cRev     := ZDK->ZDK_REV
	dDtDigit := ZDK->ZDK_DTDIGI
	cMes     := Val(ZDK->ZDK_MES)
	cAno     := ZDK->ZDK_ANO
	cPlanta	 := ZDK->ZDK_PLANTA
	    
	SB1->(dbSetOrder(1)) //FILIAL + COD
	SA1->(dbSetOrder(1)) //FILIAL + CLI + LOJA
	ZDL->(dbSetOrder(1)) //FILIAL + COD + REV + ITEM
	ZDL->(dbSeek(xFilial("ZDL")+cNum+cRev))

	WHILE ZDL->(!EOF()) .AND. ZDL->ZDL_NUM==cNum .AND. ZDL->ZDL_REV==cRev
		
		aArray := {}
		
		SB1->(dbSeek(xFilial("SB1")+ZDL->ZDL_COD))
		SA1->(dbSeek(xFilial("SA1")+ZDL->ZDL_CLIENT+ZDL->ZDL_LOJA))
		
		aAdd(aArray,ZDL->ZDL_ITEM)
		aAdd(aArray,ZDL->ZDL_COD)
		aAdd(aArray,SB1->B1_DESC)
		aAdd(aArray,ZDL->ZDL_CLIENT)
		aAdd(aArray,ZDL->ZDL_LOJA)
		aAdd(aArray,Substr(SA1->A1_NOME,1,40))
		aAdd(aArray,ZDL->ZDL_TIPO)
		aAdd(aArray,ZDL->ZDL_TURNO)
		aAdd(aArray,U_PRDSALEX(ZDL->ZDL_COD))
		
        aAdd(aArray,0)
        
		nTotal := 0
		For x:=1 to 31
			cField := "ZDL->ZDL_PREV"+StrZero(x,2)
			aAdd(aArray,&(cField))
			nTotal += &(cField)
		Next
		aArray[10] := nTotal
		
		aAdd(aArray,ZDL->ZDL_MES01)
		aAdd(aArray,ZDL->ZDL_MES02)
		aAdd(aArray,ZDL->ZDL_MES03)
		aAdd(aArray,.F.)
		
		aAdd(aCols,aArray)
	
		ZDL->(dbSkip())
	ENDDO

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP26CLI(lLoja)
Local cCli, cLoja

	If lLoja
		cCli  := aCols[n][4]
		cLoja := M->ZDL_LOJA
	Else
		cCli  := M->ZDL_CLIENT
		cLoja := Iif(Empty(aCols[n][5]),"",aCols[n][5])
	EndIf

	SA1->(dbSetOrder(1)) //A1_FILIAL + A1_COD + A1_LOJA
	If !SA1->(dbSeek(xFilial("SA1")+cCli+cLoja))
		Alert("Cliente/Loja não encontrado!")
		Return .F.
	Else
		If !Empty(cLoja)
			aCols[n][6] := SA1->A1_NOME
			oGetD:Refresh()
		EndIf
	Endif

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O ANO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValAno()

	cAno := AllTrim(cAno)
	             
	If Len(cAno)!=4
		If Len(cAno)==1
			cAno := "200"+cAno
		ElseIf Len(cAno)==2
			cAno := "20"+cAno
		ElseIf Len(cAno)==3
			cAno := "2"+cAno
		Else 
			cAno := Space(4)
		EndIf
	EndIf
			
	oGet3:Refresh()
	
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CODIGO DO PRODUTO E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP26PRD()

	/* Retirado em 17/09/2013 , pois a Fundição necessita incluir mesmo códigos com cliente diferente
	For x:=1 to Len(aCols)
		If x!=n .and. M->ZDL_COD==aCols[x][2]
			Alert("Produto já digitado!")
			Return .F.
		EndIf
	Next
    */  
    
	SB1->(dbSetOrder(1)) // FILIAL + COD
	If SB1->(dbSeek(xFilial("SB1")+M->ZDL_COD))
		aCols[n][3] := SB1->B1_DESC
		aCols[n][9] := U_PRDSALEX(M->ZDL_COD)
		oGetD:Refresh()
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf
	
	

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIALIZA O CAMPO ITEM NO GETDADOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ZDLITM()
Local nItem := 0
	
    DbSelectArea("ZDL")
    DbSetOrder(1)
    If DbSeek(xFilial("ZDL")+cNum)
    	While !Eof() .And. ZDL->ZDL_NUM == cNum
    		nItem := Val(ZDL->ZDL_ITEM)
    	    ZDL->(DBSKIP())
    	EndDo
    EndIf

	nItem := Iif(++nItem >= n,nItem,n)
	
Return (StrZero(nItem,4))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MOSTRA LEGENDA PARA O USUARIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP26LEG()

Local aLegenda :=	{ {"BR_VERDE"    , "Pendente" },;
  					  {"BR_VERMELHO" , "Programa Gerado"   }}

BrwLegenda("Programa de Produção", "Legenda", aLegenda)

Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A LEGENDA NO MBROWSE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCriaCor()

Local aLegenda :=	{ {"BR_VERDE"    , "Pendente" },;
  					  {"BR_VERMELHO" , "Programa Gerado"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZDK_STATUS == "P"', aLegenda[1][1] } )
Aadd(uRetorno, { 'ZDK_STATUS == "E"', aLegenda[2][1] } )

Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA A PROGRAMA DE PRODUCAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGeraPV()
Local aDados := {}
Local nX := 0
Local cLocal
Local cField
Local dDtPV

PRIVATE lMsErroAuto := .F.
PRIVATE lAutoErrNoFile := .T.

	ProcRegua(0)

	fAltera()
	
	ZDK->(dbSetOrder(2)) // FILIAL + NUM + REV
	ZDK->(dbSeek(xFilial("ZDK")+cNum+cRev))
	
	ZDL->(dbSetOrder(1)) //FILIAL + COD + REV + ITEM
	ZDL->(dbSeek(xFilial("ZDL")+cNum+cRev))
	
	SB1->(dbSetOrder(1)) // FILIAL + COD

	cQuery := " SELECT R_E_C_N_O_ AS HC_REC FROM "+RetSqlName("SHC")
	cQuery += " WHERE HC_DOC = '"+cNum+"'"
	cQuery += " AND MONTH(HC_DATA) = '"+ZDK->ZDK_MES+"'"
	cQuery += " AND YEAR(HC_DATA) = '"+ZDK->ZDK_ANO+"'"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(dbGoTop())
	
	//-- Apaga todas as previsoes da SHC com este numero para este mes/ano
	WHILE TRA1->(!EOF())
		
		SHC->(dbGoTo(TRA1->HC_REC))
		RecLock("SHC",.F.)
			SHC->(dbDelete())
		MsUnlock("SHC")
		
		TRA1->(dbskip())
	ENDDO
	
	TRA1->(dbCloseArea())

	WHILE ZDL->(!EOF()) .AND. ZDL->ZDL_NUM==cNum .AND. ZDL->ZDL_REV==cRev
		
		IncProc()
		
		nHCQuant := 0
		dDtPV := CtoD("01/"+ZDK->ZDK_MES+"/"+ZDK->ZDK_ANO)
		
		//-- Grava todas as previsoes na SHC novamente
		For x:=1 to 31
			
			cField := "ZDL->ZDL_PREV"+StrZero(x,2)
			//dDtPV := CtoD(StrZero(x,2)+"/"+ZDK->ZDK_MES+"/"+ZDK->ZDK_ANO)
			
			If &(cField) > 0
				nHCQuant += &(cField)
			Endif
		Next
		
		
		SB1->(dbSeek(xFilial("SB1")+ZDL->ZDL_COD))
		RecLock("SHC",.T.)
			HC_FILIAL := xFilial("SHC")
			HC_PRODUTO := ZDL->ZDL_COD
			HC_DATA    := dDtPV
			HC_QUANT   := nHCQuant//&(cField)
			HC_DOC     := cNum
		Msunlock("SHC")

		
		ZDL->(dbSkip())
	EndDo
                 
	/**
	 * Grava o status como encerrado
	 */
	RecLock("ZDK",.F.)
		ZDK->ZDK_STATUS := 'E'
	MsUnlock("ZDK")

	MsgInfo("Programa de Produção gerado com sucesso!")
	
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CALCULA O TOTAL DAS PREVISOES NO ACOLS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP26TOT(nMem)
Local nTotal   := 0
Local cField  
Local nPosPrev := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="ZDL_PREV01" })
Local dDtRef   

	//Verifica se o campo não se refere a uma data ultrapassada
	dDtRef := StoD(cAno+StrZero(oCombo1:nAt,2)+StrZero(nMem,2))

	For x:=1 to 31
		If x != nMem
			nTotal += aCols[n][x+nPosPrev-1]
		EndIf
	Next
	cField := "M->ZDL_PREV"+StrZero(nMem,2)
	nTotal += &(cField)
	
	aCols[n][10] := nTotal
	oGetD:Refresh()

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A ULTIMA REVISAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fUltRev(cNumero) 
Local cUltRev

	ZDK->(dbSetOrder(1)) // FILIAL + NUM + REV
	ZDK->(dbSeek(xFilial("ZDK")+cNumero))
	
	While ZDK->ZDK_NUM == cNumero
		cUltRev := ZDK->ZDK_REV
		ZDK->(dbSkip())
	EndDo

Return cUltRev

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS ITENS DA ULTIMA PROGRAMACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarreg()
Local nZDKRec := ZDK->(Recno()) //Guarda a posicao da tabela ZDK
Local nItem

	If Empty(cPlanta)
		alert("Informe a Planta.")
		Return .F.
	EndIf

	cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC,* FROM " + RetSqlName("ZDK") + " ZDK1"
	cQuery += " WHERE ZDK_PLANTA = '" + cPlanta + "'"
	cQuery += " AND ZDK1.D_E_L_E_T_ = ' '"
	cQuery += " AND ZDK_REV = (SELECT MAX(ZDK_REV) FROM " + RetSqlName("ZDK") + " ZDK2 "
	cQuery += " WHERE ZDK2.ZDK_NUM = ZDK1.ZDK_NUM AND D_E_L_E_T_ = ' ' AND ZDK2.ZDK_PLANTA='" + cPlanta + "')"
	cQuery += " ORDER BY 1 DESC "
	TcQuery cQuery New Alias "TMP1"
	
	If TMP1->(!EOF() )
		ZDK->(DbGoTo(TMP1->REC))
	Else
		//posiciona no último registro da tabela ZDK
		ZDK->(dbGoBottom())
	EndIf
	TMP1->(DbCloseArea() ) 

	ZDL->(DbSetOrder(1)) //ZDL_FILIAL+ZDL_NUM+ZDL_REV+ZDL_ITEM                                                                                                                             
	ZDL->(DbSeek(xFilial("ZDL")+ZDK->(ZDK_NUM+ZDK_REV)))
	    
	SB1->(DbSetOrder(1)) // filial + cod
	SA7->(DbSetOrder(2)) // filial + cod
	
	nItem := 0  //-- comecamos o item com zero
	aCols := {} //-- limpa o acols
	    
	ProcRegua(0)
	
	//percorre todos os itens da ultima programacao
	WHILE ZDL->(!EOF()) .AND. ZDL->(ZDL_NUM+ZDL_REV) == ZDK->(ZDK_NUM+ZDK_REV)

		IncProc(ZDL->ZDL_COD)
		
		nItem++
		
		aArray := {}
		
		SB1->(dbSeek(xFilial("SB1")+ZDL->ZDL_COD)) 
		SA7->(dbSeek(xFilial("SA7")+ZDL->ZDL_COD)) 
		SA1->(dbSeek(xFilial("SA1")+SA7->A7_CLIENTE+SA7->A7_LOJA))
		
		aAdd(aArray,StrZero(nItem,4)) //item   
		aAdd(aArray,ZDL->ZDL_COD)     //produto
		aAdd(aArray,SB1->B1_DESC)     //descricao
		aAdd(aArray,iif(!Empty(SA7->A7_CLIENTE),SA7->A7_CLIENTE,'900109'))  //cliente
		aAdd(aArray,iif(!Empty(SA7->A7_LOJA),SA7->A7_LOJA,'01'))    //loja
		aAdd(aArray,iif(!Empty(SA7->A7_CLIENTE),Substr(SA1->A1_NOME,1,40),'WHB FUNDICAO S/A')) //nome do cliente
		aAdd(aArray,ZDL->ZDL_TIPO)    //tipo da programacao
		aAdd(aArray,ZDL->ZDL_TURNO)   //turno
		aAdd(aArray,U_PRDSALEX(ZDL->ZDL_COD))  //saldo na expedicao
        aAdd(aArray,0) //total zerado
        
		For x:=1 to 31
			aAdd(aArray,0) //previsoes zeradas
		Next
		
		aAdd(aArray,0) //mes 1 zerado
		aAdd(aArray,0) //mes 2 zerado
		aAdd(aArray,0) //mes 3 zerado
		aAdd(aArray,.F.) //flag da linha não deletada

		aAdd(aCols,aArray)

		ZDL->(DbSkip())

	ENDDO
	
	oGetD:Refresh()
	
	ZDK->(dbGoTo(nZDKRec))//-- retorna a posicao da tabela ZDK

Return