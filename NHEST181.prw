
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST181  ºAutor  ³Felipe Ciconini     º Data ³  13/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Browse e Telas de Inclusao da ZE3 - Divergencias de Preços º±±
±±º          ³ de Nota Fiscal/Pedido de Compras - Chamado 3948            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiscal/Estoque                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function NHEST181()

Private cCadastro := "Alerta de Criticidade / Parada de Linha"
Private aRotina   := {}
Private aFixos	  := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"      , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_EST181(2)" 	 , 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST181(3)" 	 , 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_EST181(4)"   , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_EST181(5)"   , 0 , 5})
aAdd(aRotina,{ "Imprimir"       ,"U_NHEST182(1)" , 0 , 6})
aAdd(aRotina,{ "Carta"	        ,"U_NHEST182(2)" , 0 , 6})

aFixos := {{"Número"         , "ZE3_NUM"   	},;
		   {"Número Pedido"  , "ZE3_NUMPED"	},;
		   {"Produto"		 , "ZE3_PROD"	},;
		   {"Número NF"		 , "ZE3_NUMNF"	},;
		   {"Data"			 , "ZE3_DATA"	},;
		   {"Fornecedor"	 , "ZE3_FORDSC"	}}

mBrowse(6,1,22,75,"ZE3",aFixos,,,,,)

Return

User Function EST181(nParam)
Local bOk        := {||}
Local bCanc      := {||oDlg:End()}
Local bEnchoice  := {||}
Local aButtons	 := {}
Local nLin		 := 0
Local nLin2		 := 0 

Private nPar	 := nParam
Private aSize    := MsAdvSize()
Private aObjects := {{100,100,.T.,.T.},{300,300,.T.,.T.}}
Private aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],5,5,5,5}
Private aPosObj  := MsObjSize(aInfo,aObjects,.T.)
Private aCols    := {}
Private aHeader  := {}

Private cNum 	:= 0
Private dData	:= CtoD("  /  /  ")
Private cFor	:= Space(06)
Private cLoja	:= Space(02)
Private cForn	:= ""
Private cNota	:= Space(09)
Private cPedi	:= Space(06)
Private cProd	:= Space(15)
Private cPro	:= ""
Private nPrPe	:= 0
Private nPrFa	:= 0
Private nIcms	:= 0
Private nIPI	:= 0
Private nQtd	:= 0
Private nDive	:= 0
Private cBase	:= ""
Private aBase	:= {"","SIM","NÃO"}

    If nPar == 2			//VISUALIZA
    	fCarrega()
    	bOk		:= {||oDlg:End()}
	ElseIf nPar == 3		//INCLUI
		cNum 	:= GetSxeNum("ZE3","ZE3_NUM")
		dData 	:= Date()
		bOk		:= {||fInclui()}
		bCanc 	:= {||RollBackSx8(), oDlg:End()}
	ElseIf nPar == 4		//ALTERA
		fCarrega()
		bOk 	:= {||fAltera()}
	ElseIf nPar == 5		//EXCLUI
		fCarrega()
		bOk 	:= {||fExclui()}
	EndIf
	
	bEnchoice 	:= {||EnchoiceBar(oDlg,bOk,bCanc,,aButtons)}
	
	oFont1 	:= TFont():New("Arial",,18,,.T.,,,,,.F.)
	nLin	:= 39
	nLin2	:= 37
	
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Divergências de Preços de Nota Fiscal",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay1 := tSay():New(020,010,{||"Número"},oDlg,,oFont1,,,,.T.,CLR_BLUE,)
	oSay2 := tSay():New(020,050,{||cNum},oDlg,,oFont1,,,,.T.,CLR_BLUE,)
	
	oSay3 := tSay():New(nLin,010,{||"Fornecedor"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(nLin2,055,{|u| If(pCount() > 0, cFor := u,cFor)},oDlg,40,08,"@e 999999",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,"SA2","cFor")
	oGet2 := tGet():New(nLin2,097,{|u| If(pCount() > 0, cLoja := u,cLoja)},oDlg,10,08,"@e 99",{||fValFor()},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"cLoja")
   	oGet3 := tGet():New(nLin2,112,{|u| If(pCount() > 0, cForn := u,cForn)},oDlg,100,08,"@!",{||},,,,,,.T.,,,{||.F.},,,,,,,"cForn")
   	
   	oSay4 := tSay():New(nLin+13,010,{||"Nº Nota"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGet4 := tGet():New(nLin2+13,055,{|u| If(pCount() > 0, cNota := u,cNota)},oDlg,025,08,"@e 999999999",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"cNota")
   	
   	oSay5 := tSay():New(nLin+26,010,{||"Pedido Compra"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGet5 := tGet():New(nLin2+26,055,{|u| If(pCount() > 0, cPedi := u,cPedi)},oDlg,025,08,"@e 999999",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"cPedi")
   	
   	oSay6 := tSay():New(nLin+39,010,{||"Produto"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGet6 := tGet():New(nLin2+39,055,{|u| If(pCount() > 0, cProd := u,cProd)},oDlg,060,08,"@!",{||fValProd()},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,"SB1","cProd")
   	oGetB := tGet():New(nLin2+39,120,{|u| If(pCount() > 0, cPro := u,cPro)},oDlg,100,08,"@!",{||},,,,,,.T.,,,{||.F.},,,,,,,"cPro")
   	
   	oSay7 := tSay():New(nLin+51,010,{||"Preço Unit Pedido"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGet7 := tGet():New(nLin2+51,055,{|u| If(pCount() > 0, nPrPe := u,nPrPe)},oDlg,050,08,"@e 999,999.9999",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nPrPe")
   	
   	oSay8 := tSay():New(nLin+64,010,{||"Preço Unit Fatura"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGet8 := tGet():New(nLin2+64,055,{|u| If(pCount() > 0, nPrFa := u,nPrFa)},oDlg,050,08,"@e 999,999.9999",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nPrFa")
   	
   	oSay9 := tSay():New(nLin+77,010,{||"Quantidade"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGet9 := tGet():New(nLin2+77,055,{|u| If(pCount() > 0, nQtd := u,nQtd)},oDlg,050,08,"@e 999999.9999",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nQtd")
   	
   	oSayA := tSay():New(nLin+90,010,{||"Aliquota ICMS (%)"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGetA := tGet():New(nLin2+90,055,{|u| If(pCount() > 0, nIcms := u,nIcms)},oDlg,020,08,"@e 99.99",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nIcms")
   	
   	oSayC := tSay():New(nLin+103,010,{||"Aliquota IPI (%)"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oGetC := tGet():New(nLin2+103,055,{|u| If(pCount() > 0, nIPI := u,nIPI)},oDlg,020,08,"@e 99.99",{||},,,,,,.T.,,,{||nPar==3 .OR. nPar==4},,,,,,,"nIPI")
   	
   	oSayD := tSay():New(nLin+116,010,{||"IPI na Base"},oDlg,,,,,,.T.,CLR_HBLUE,)
   	oCom1 := tComboBox():New(nLin2+116,055,{|u| If(pCount() > 0, cBase := u,cBase)},aBase,25,08,oDlg,,{||},,,,.T.,,,,{||nPar==3 .OR. nPar==4},,,,,"cBase")

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)


Return

Static Function fValFor()

	SA2->(DbSetOrder(1)) // FILIAL + COD + LOJA
	If Empty(cLoja)
		cLoja := "01"
		oGet2:Refresh()
	EndIf
	If SA2->(DbSeek(xFilial("SA2")+cFor+cLoja))
		cForn := SA2->A2_NOME
		oGet3:Refresh()
	Else
		Alert("Fornecedor não encontrado!")
		Return .F.
	EndIf

Return

Static Function fValProd()

	SB1->(DbSetOrder(1)) // FILIAL + COD
	If SB1->(DbSeek(xFilial("SB1")+cProd))
		cPro := SB1->B1_DESC
		oGetB:Refresh()
	Else
		Alert("Produto não encontrado!")
		Return .F.
	EndIf

Return

Static Function fValida()
Local nCont := 0

If Empty(cForn)
	alert("Insira o Fornecedor!")
	nCont := 1
EndIf

If Empty(cNota)
	alert("Insira o Numero da Nota!")
	nCont := 1
EndIf

If Empty(cPedi)
	alert("Insira o Numero do Pedido de Compra!")
	nCont := 1
EndIf

If Empty(cProd)
	alert("Insira o Produto!")
	nCont := 1
EndIf

If Empty(nPrPe)
	alert("Insira o Preço Unitario do Pedido de Compra!")
	nCont := 1
EndIf

If Empty(nPrFa)
	alert("Insira o Preço Unitario da Fatura!")
	nCont := 1
EndIf

If Empty(cBase)
	alert("Selecione a Base IPI!")
	nCont := 1
EndIf

If nCont > 0
	Return .F.
EndIf

Return .T.

Static Function fInclui()

	If !fValida()
		Return
	EndIf
	
	fCalc()					//CALCULAR DIVERGÊNCIA
	
	RecLock("ZE3",.T.)
		ZE3->ZE3_FILIAL := xFilial("ZE3")
		ZE3->ZE3_NUM	:= cNum
		ZE3->ZE3_NUMPED	:= cPedi
		ZE3->ZE3_PROD	:= cProd
		ZE3->ZE3_NUMNF	:= cNota
		ZE3->ZE3_FORNEC	:= cFor
		ZE3->ZE3_LOJA	:= cLoja
		ZE3->ZE3_PRPED	:= nPrPe
		ZE3->ZE3_PRFAT	:= nPrFa
		ZE3->ZE3_QUANT	:= nQtd
		ZE3->ZE3_ICMS	:= nIcms
		ZE3->ZE3_IPI	:= nIPI
		ZE3->ZE3_DIVERG	:= nDive
		ZE3->ZE3_DATA	:= dData
		ZE3->ZE3_BASE	:= SubStr(cBase,1,1)
	MsUnlock("ZE3")
	
	ConfirmSx8()
	
	oDlg:End()

Return

Static Function fCalc()
Local nDirveg := 0

	nDiverg := nPrFa - nPrPe
	nDiverg *= nQtd
	nDive := nDiverg

Return

Static Function fCarrega()

	cNum	:= ZE3->ZE3_NUM
	cPedi	:= ZE3->ZE3_NUMPED
	cProd	:= ZE3->ZE3_PROD
	cNota 	:= ZE3->ZE3_NUMNF
	cFor 	:= ZE3->ZE3_FORNEC
	cLoja	:= ZE3->ZE3_LOJA
	nPrPe	:= ZE3->ZE3_PRPED
	nPrFa	:= ZE3->ZE3_PRFAT
	nQtd	:= ZE3->ZE3_QUANT
	nIcms	:= ZE3->ZE3_ICMS
	nIPI	:= ZE3->ZE3_IPI
	nDive	:= ZE3->ZE3_DIVERG
	dData	:= ZE3->ZE3_DATA
	If ZE3->ZE3_BASE == "S"
		cBase := "SIM"
	Else
		cBase := "NÃO"
	EndIf

	SB1->(DbSetOrder(1)) //FILIAL + COD
	SB1->(DbSeek(xFilial("SB1")+cProd))
	cPro := SB1->B1_DESC

	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+cFor+cLoja))
	cForn := SA2->A2_NOME

Return

Static Function fAltera()

	If !fValida()
		Return
	EndIf
	
	fCalc()
	
	RecLock("ZE3",.F.)
		ZE3->ZE3_NUMPED	:= cPedi
		ZE3->ZE3_PROD	:= cProd
		ZE3->ZE3_NUMNF	:= cNota
		ZE3->ZE3_FORNEC	:= cFor
		ZE3->ZE3_LOJA	:= cLoja
		ZE3->ZE3_PRPED	:= nPrPe
		ZE3->ZE3_PRFAT	:= nPrFa
		ZE3->ZE3_QUANT	:= nQtd
		ZE3->ZE3_ICMS	:= nIcms
		ZE3->ZE3_IPI	:= nIPI
		ZE3->ZE3_DIVERG	:= nDive
		ZE3->ZE3_BASE	:= SubStr(cBase,1,1)
	MsUnlock("ZE3")
	
	ConfirmSx8()
	
	oDlg:End()

Return

Static Function fExclui()

	If MsgYesNo("Tem certeza de que deseja excluir?")
		RecLock("ZE3",.F.)
			ZE3->(dbDelete())
		MsUnlock("ZE3")
	EndIf
	
	oDlg:End()

Return