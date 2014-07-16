/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP019  ºAutor  ³ João Felipe da Rosaº Data ³  10/07/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CADASTRO DE EMBALAGENS POR PEÇA                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - PCP                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"

User Function NHPCP019()

Private aRotina, cCadastro
        
DbSelectArea('SB1')

cCadastro := "Embalagem x Peça"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visu. Prod."	,"axVisual" 	, 0 , 2})
aAdd(aRotina,{ "Visualizar"	    ,"U_PCP19(2)" 	, 0 , 2})
aAdd(aRotina,{ "Embalagem"		,"U_PCP19(3)" 	, 0 , 3})
aAdd(aRotina,{ "Excluir"        ,"U_PCP19(5)"   , 0 , 5})

mBrowse(6,1,22,75,"SB1",,,,,,/*fCriaCor()*/)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA DO CADASTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP19(nParam) 
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam  
Private aHeader   := {}
Private aCols     := {}
Private cProd     := SB1->B1_COD
Private cDesProd  := SB1->B1_DESC
Private cTe       := Space(3)
Private cTs       := Space(3)
Private nPesLiq   := 0
Private nPesBru   := 0
Private nQtdPad   := 0
Private nQtdPad2  := 0

	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	aAdd(aHeader,{"Embalagem"  , "ZBV_EMBAL"    , "@!"       , 15,00, "U_PCP19EMB()"  ,"","C","ZBV"})
	aAdd(aHeader,{"Descrição"  , "B1_DESC"      , "@!"       , 50,00, ".F."           ,"","C","SB1"})
	aAdd(aHeader,{"Quantidade" , "ZBV_QUANT"    , "@E 99999" , 02,00, ".T."           ,"","N","ZBV"})
	aAdd(aHeader,{"Conjunto"   , "ZBV_CONJUN"   , "@!"       , 01,00, "U_PCP19CJT()"  ,"","C","ZBV"})
	
	If nPar==2     //visualizar
		fCarrega()

	    bOk := {||oDlg:End()}

       	aHeader[1][6] := ".F."
 	  	aHeader[3][6] := ".F."

	ElseIf nPar==3 //embalagem
		fCarrega()		
		bOk   := {|| fEmbal()}
	EndIf 

	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
			
	oDlg  := MsDialog():New(0,0,360,600,"Peças x Embalagens",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay1 := TSay():New(20, 10,{||"Código"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20, 50,{||cProd+' - '+cDesProd},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(32,10,{||"TE Padrão"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(30,50,{|u| if(Pcount() > 0, cTe := u,cTe)},oDlg,20,8,"@!",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,"SF4","cTe")
	
	oSay4 := TSay():New(32,150,{||"Peso Liq."},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(30,190,{|u| if(Pcount() > 0, nPesLiq := u,nPesLiq)},oDlg,50,8,"@E 9,999,999.99",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"nPesLiq")

	oSay5 := TSay():New(44,10,{||"TS Padrão"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(42,50,{|u| if(Pcount() > 0, cTs := u,cTs)},oDlg,20,8,"@!",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,"SF4","cTs")

	oSay6 := TSay():New(44,150,{||"Peso Bru."},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(42,190,{|u| if(Pcount() > 0, nPesBru := u,nPesBru)},oDlg,50,8,"@E 9,999,999.99",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"nPesBru")

	oSay7 := TSay():New(56,010,{||"Quant. Padrão Conj. 1"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(54,070,{|u| if(Pcount() > 0, nQtdPad := u,nQtdPad)},oDlg,50,8,"@E 9,999,999.99",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"nQtdPad")                   
		
	oSay8 := TSay():New(56,150,{||"Quant. Padrão Conj. 2"},oDlg,,,,,,.T.,,)
	oGet6 := tGet():New(54,210,{|u| if(Pcount() > 0, nQtdPad2 := u,nQtdPad2)},oDlg,50,8,"@E 9,999,999.99",/*valid*/,;
		,,,,,.T.,,,{|| nPar==3},,,,,,,"nQtdPad2")	
		
		
    // cria o getDados
	oGeTD := MsGetDados():New( 68              ,; //superior 
	                           5                ,; //esquerda
	                           175              ,; //inferior
	                           297              ,; //direita 	   
	                           4                ,; // nOpc
	                           {||fMulti()}     ,; // CLINHAOK
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

	oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)
	
	SB1->(dbSeek(xFilial("SB1")+cProd))
	
Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ VALIDA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fValida()
Return .T.

//ÚÄÄÄÄÄÄÄÄ¿
//³ EMBALA ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fEmbal()
	
	If !fValida()
		Return
	EndIf
	
	ZBV->(DbSetOrder(1)) //FILIAL + PROD + EMBAL

	For x:=1 to Len(aCols)
		
		If Empty(aCols[x][1])
			Loop   
		Endif
		
		If !Acols[x][len(aHeader)+1] //nao pega quando estiver deletado
			If ZBV->(dbSeek(xFilial("ZBV")+cProd+aCols[x][1]))
				RecLock("ZBV",.F.)
					ZBV->ZBV_QUANT  := aCols[x][3]
					ZBV->ZBV_CONJUN := aCols[x][4]
					ZBV->ZBV_QUANT2  := nQtdPad2
				MsUnlock("ZBV")
			Else
				RecLock("ZBV",.T.)
					ZBV->ZBV_FILIAL := xFilial("ZBV")
					ZBV->ZBV_PROD   := cProd
					ZBV->ZBV_EMBAL  := aCols[x][1]
					ZBV->ZBV_QUANT  := aCols[x][3]
					ZBV->ZBV_CONJUN := aCols[x][4]
					ZBV->ZBV_QUANT2  := nQtdPad2
				MsUnlock("ZBV")
			EndIf
		Else
			If(dbSeek(xFilial("ZBV")+cProd+aCols[x][1]))
				RecLock("ZBV",.F.)
					ZBV->(dbDelete())
				MsUnlock("ZBV")
			EndIf
		EndIf	
	Next
	                
	//exclui os que nao foram encontrados no acols
	ZBV->(dbGoTop())
	ZBV->(dbSeek(xFilial("ZBV")+cProd))
	WHILE ZBV->(!EOF()) .AND. ZBV->ZBV_PROD==cProd
	
		_n := aScan(aCols,{|x| x[1]==ZBV->ZBV_EMBAL})
		If _n==0 
			RecLock("ZBV",.F.)
				ZBV->(dbDelete())
			MsUnlock("ZBV")
		EndIf

	    ZBV->(dbSkip())
	ENDDO
	
	//altera o cadastro do produto
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+cProd))
		RecLock("SB1",.F.)
			SB1->B1_TE     := cTe
			SB1->B1_TS     := cTs
			SB1->B1_PESO   := nPesLiq
			SB1->B1_PESBRU := nPesBru
		MsUnlock("SB1")
	EndIf
	
	SB5->(DbSetOrder(1))
	If SB5->(DbSeek(xFilial("SB5")+cProd))
		RecLock("SB5",.F.)
			SB5->B5_QPA    := nQtdPad
	    MsUnLock("SB5")
	EndIf 
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄ¿
//³ EXCLUI ³
//ÀÄÄÄÄÄÄÄÄÙ
Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")

		ZBV->(dbSetOrder(1)) // FILIAL + PROD + EMBAL
		ZBV->(dbSeek(xFilial("ZBV")+cProd))
		If ZBV->(Found())
			While ZBV->(!EOF()) .AND. ZBV->ZBV_PROD==cProd
		    	RecLock("ZBV",.F.)
		    		ZBV->(dbDelete())
				MsUnLock("ZBV")		
			
			    ZBV->(dbSkip())
			EndDo
		EndIf
	
	EndIf	
	
	oDlg:End()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LINHA NO MULTILINE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fMulti()

	If Empty(aCols[n][1])
		Alert("Informe o código da embalagem!")
		Return .F.
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA AS VARIAVEIS PARA  VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
        
	SB1->(dbSetOrder(1)) // FILIAL + COD
	ZBV->(dbSetOrder(1)) // FILIAL + PROD + EMBAL
	ZBV->(dbSeek(xFilial("ZBV")+cProd))
	If ZBV->(Found())
		While ZBV->(!EOF()) .AND. ZBV->ZBV_PROD==cProd
		
			SB1->(dbSeek(xFilial("SB1")+ZBV->ZBV_EMBAL))
			
			aAdd(aCols,{ZBV->ZBV_EMBAL,SB1->B1_DESC,ZBV->ZBV_QUANT,ZBV->ZBV_CONJUN,.F.}) 
			
			nQtdPad2 := ZBV->ZBV_QUANT2
			
		    ZBV->(dbSkip())

		EndDo
	EndIf

	SB1->(dbSeek(xFilial("SB1")+cProd))
	
	cTe := SB1->B1_TE
	cTs := SB1->B1_TS
	nPesLiq := SB1->B1_PESO
	nPesBru := SB1->B1_PESBRU
	
	SB5->(DbSetOrder(1))
	SB5->(DbSeek(xFilial("SB5")+cProd))

	nQtdPad := SB5->B5_QPA

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O PRODUTO E TRAZ A DESCRICAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function PCP19EMB()
Local nPosConj := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZBV_CONJUN"})
Local nPosProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZBV_EMBAL"})
Local cConjun := ''

	SB1->(dbSetOrder(1)) //FILIAL + COD
	SB1->(dbSeek(xFilial("SB1")+M->ZBV_EMBAL))
	If SB1->(!Found())
		Alert("Produto não encontrado!")
		Return .F.
	Else
	
		cConjun := aCols[n][nPosConj]
		
		//verifica se nao existe duplicado produto + conjunto
		For xE:=1 to Len(aCols)
			If xE!=n
				If aCols[xE][nPosProd]==M->ZBV_EMBAL .AND. aCols[xE][nPosConj]==cConjun
					Alert("Embalagem + Conjunto já digitada!")
					Return .F.
			    EndIf
	        EndIf
		Next
	
		aCols[n][2] := SB1->B1_DESC
		oGetD:Refresh()
	EndIf
	
Return .T.

User Function PCP19CJT()
Local nPosConj := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZBV_CONJUN"})
Local nPosProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZBV_EMBAL"})
Local cProdVal := aCols[n][nPosProd]
		
	//verifica se nao existe duplicado produto + conjunto
	For xE:=1 to Len(aCols)
		If xE!=n
			If aCols[xE][nPosProd]==cProdVal .AND. aCols[xE][nPosConj]==M->ZBV_CONJUN
				Alert("Embalagem + Conjunto já digitada!")
				Return .F.
		    EndIf
        EndIf
	Next
	
Return .T.