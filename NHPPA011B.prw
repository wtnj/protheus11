
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHPPA011  บAutor  ณFELIPE CICONINI     บ Data ณ  30/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTELA DE CADASTRO DE MODIFICAวีES DO CLIENTE (COMERCIAL)     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCOMERCIAL,PPAP                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"

User Function NHPPA011(nParam)

Private nPar := nParam
Private aCols   := {}
Private aHeader := {}

Private cProd   := Space(15)
Private cPrDesc := ""
Private cCli	:= Space(06)
Private cLoja	:= Space(02)
Private cClDesc := ""
Private cNum    := ""
Private cResp   := UsrFullname(__cUserId )
Private cResu   := Space(150)
Private cSetor  := Space(09)
Private cApCli  := ""
Private cWoCli  := Space(06)
Private cPlanta := " "
Private cPla	:= " "
Private aHeader := {}
Private aCols	:= {}

Private cStatus := "ABERTA"

Private cBt := ""

Private dData   := Date()
Private cHora   := Time()

Private nCom    := 10
Private nQua    := 10
Private nPro    := 10
Private nCon    := 10
Private nPre    := 10
Private nLog    := 10
Private nMan    := 10
Private nInf    := 10
Private nEng    := 10

Private cComF   := "Sim"
Private cQuaF   := "Nใo"
Private cProF   := "N/A"
Private cConF   := "Sim"
Private cPreF   := "Nใo"
Private cLogF   := "N/A"
Private cManF   := "Sim"
Private cInfF   := "Nใo"
Private cEngF   := "Sim"

Private cMemo   := Space(350)

Private aCampos := {"NรO","SIM"}

Private lChk1,lChk2,lChk3,lChk4

lChk1 := .F.
lChk2 := .F.
lChk3 := .F.
lChk4 := .F.

If nPar == 3			//INCLUIR
	cNum := GetSxENum("ZE1","ZE1_NUM")
	fCarrega()
ElseIf nPar == 4
	fCarrega()
ElseIf nPar == 5		//EXCLUIR
	fCarrega()
EndIf

Return

Static Function fCarrega()
Local nCusTot := 0
Local nLin 	:= 10
Local xL	:= 1
Local cSta	:= ""

aAdd(aHeader,{"Setor"	, "ZE2_SETOR"	,"@!"				 ,13,0,".F.","","C","ZE2"})
aAdd(aHeader,{"Planta"	, "ZE2_PLANTA"	,"@!"				 ,10,0,".F.","","C","ZE2"})
aAdd(aHeader,{"Status"	, "ZE2_STATUS"	,"@!"				 ,08,0,".F.","","C","ZE2"})
aAdd(aHeader,{"Custo"	, "ZE2_CUSTO"	,"@E 999,999,999.99" ,10,0,".F.","","N","ZE2"})

If nPar <> 3										//CARREGANDO DADOS
	cNum 	:= ZE1->ZE1_NUM
	cWoCli	:= ZE1->ZE1_NUMCLI
	dData	:= ZE1->ZE1_DATA
	cCli	:= ZE1->ZE1_CLI
	cLoja	:= ZE1->ZE1_LOJA
	cClDesc	:= Posicione("SA1",1,xFilial("SA1")+ZE1->ZE1_CLI+ZE1->ZE1_LOJA,"A1_NOME")
	cProd	:= ZE1->ZE1_PROD
	cPrDesc	:= Posicione("SB1",1,xFilial("SB1")+ZE1->ZE1_PROD,"B1_DESC")
	cSetor	:= ZE1->ZE1_SETOR
	cResu	:= ZE1->ZE1_RESUMO
	cMemo	:= ZE1->ZE1_DESC
	cApCli := Iif(ZE1->ZE1_APCLI=="S","SIM","NรO")
		
	If ZE1->ZE1_STATUS == "A"
		cStatus	:= "ABERTA"
	ElseIf ZE1->ZE1_STATUS == "P"
		cStatus	:= "PENDENTE"
	ElseIf ZE1->ZE1_STATUS == "F"
		cStatus	:= "FINALIZADO"
	EndIf
	
	ZE2->(DbSelectArea(1))		//filial+num
	If ZE2->(DbSeek(xFilial("ZE2")+ZE1->ZE1_NUM))
		While ZE2->ZE2_NUM == cNum
			If AllTrim(ZE2->ZE2_PLANTA) == "USINAGEM"
				lChk1 := .T.
			ElseIf AllTrim(ZE2->ZE2_PLANTA) == "FUNDICAO"
				lChk2 := .T.
			ElseIf AllTrim(ZE2->ZE2_PLANTA) == "FORJARIA"
				lChk3 := .T.
			ElseIf AllTrim(ZE2->ZE2_PLANTA) == "VIRABREQUIM"
				lChk4 := .T.
			EndIf
			ZE2->(DbSkip())
		EndDo
	EndIf
Else
	cNum := GetSxENum("ZE1","ZE1_NUM")
EndIf



Define MsDialog oDlg From 0,0 To 490,850 Pixel Title "GERENCIADOR DE MUDANวA"			//TELA DE CADASTRO
		@ 005,005 To  218,225 LABEL "" Of oDlg Pixel
//	      LIN,COL
		@ 012,010 Say "N๚mero"		Size 35,8 Object oNm
		@ 012,035 Say cNum			Size 45,8 Object oNum
	   
		@ 012,070 Say "Nบ Altera็ใo Cliente" Color CLR_HBLUE								Size 060,08 Object oWo
		@ 010,120 Get cWoCli				Picture "@e" 		 When nPar==3 .OR. nPar==4	Size 030,08 Valid !Empty(cWoCli) Object oWoCli
	   
		@ 012,160 Say "Data" 																Size 035,08 Object oDT
		@ 010,175 Get dData					Picture "99/99/9999" When .F.	 				Size 045,08 Object oData
		
		@ 027,010 Say "Cliente"				Color CLR_HBLUE									Size 035,08 Object oCl
		@ 025,035 Get cCli					Picture "@!"		 When nPar==3				Size 040,08 Valid fValCli() F3 "SA1" Object oClie
		@ 025,080 Get cLoja					Picture "@!"		 When nPar==3 				Size 010,08 Valid fValCli() Object oLj
		@ 025,095 Get cClDesc				Picture "@!"		 When .F.					Size 125,08 Object oCliDesc
	   
		@ 045,010 Say "Produto"				Color CLR_HBLUE			 						Size 035,08 Object oPd
		@ 043,035 Get cProd					Picture "@!" 		 When nPar==3 				Size 055,08	Valid fValProd() F3 "SB1" Object oProd
		@ 043,095 Get cPrDesc				Picture "@!"		 When .F.	  				Size 125,08 Object oProdDesc
	   
		@ 063,010 Say "Setor"				Color CLR_HBLUE					  				Size 035,08 Object oSet
		@ 061,035 Get cSetor				Picture "@e 999999999" When nPar==3				Size 035,08 Valid fValCC() F3 "CTT" Object oSetor
		
		@ 063,085 Say "Aprov Cliente"		Color CLR_HBLUE					 				Size 045,08 Object oApr
		@ 061,120 Get cApCli	 			Picture "@!"		 When .F.					Size 025,08 Object oApCli
		
		@ 063,165 Say "Status"				Color CLR_HBLUE					   				Size 035,08 Object oSta
		@ 061,185 Get cStatus				Picture "@!"		 When .F.	   				Size 035,08 Object oStat
				
		@ 081,010 Say "Resumo"				Color CLR_HBLUE									Size 035,08 Object oRes
		@ 079,035 Get cResu					Picture "@!"		 When nPar==3				Size 185,08 Object oResu
		
		@ 092,010 Say "Descri็ใo Necessidade"									Size 055,08 Object oNece
		@ 100,010 GET cMemo			MEMO	Size 210,60 Of oDlg Pixel HSCROLL When nPar==3
		
//--------------------------------------------------------------------------------------------------------------\\
		
		@ 178,010 Say "Engenharias:" Object oSets
		
		@ 192,030 CheckBox oChk1 	 Var lChk1 Prompt "" When nPar==3 Size 010,08 Pixel Of oDlg
		@ 193,040 Say "Usinagem" 	 Object oCh1
		
		@ 192,095 CheckBox oChk2 	 Var lChk2 Prompt "" When nPar==3 Size 040,08 Pixel Of oDlg
		@ 193,105 Say "Fundi็ใo" 	 Object oCh2
		
		@ 192,160 CheckBox oChk3 	 Var lChk3 Prompt "" When nPar==3 Size 040,08 Pixel Of oDlg
		@ 193,170 Say "Forjaria" 	 Object oCh3
		
		@ 206,030 CheckBox oChk4 	 Var lChk4 Prompt "" When nPar==3 Size 040,08 Pixel Of oDlg
		@ 207,040 Say "Virabrequim"  Object oCh4
		
//--------------------------------------------------------------------------------------------------------------\\
		
		@ 005,230 To 218,425 LABEL "Custo por Setor" Of oDlg Pixel
		
		If nPar<>3
		
			DbSelectArea('ZE2')
			@ 015,235 TO 210,420 MULTILINE OBJECT oMultiline
			
			ZE2->(DbSelectArea(1))
			If ZE2->(DbSeek(xFilial("ZE2")+cNum))
				nLin := 10
				While cNum == ZE2->ZE2_NUM
					
					If ZE2->ZE2_STATUS == "A"
						cSta := "ABERTO"
					ElseIf ZE2->ZE2_STATUS == "P"
						cSta := "PENDENTE"
					ElseIf ZE2->ZE2_STATUS == "N"
						cSta := "NรO APLICA"
					ElseIf ZE2->ZE2_STATUS == "F"
						cSta := "FINALIZADO"
					EndIf
					
					aAdd(aCols,{ZE2->ZE2_SETOR,ZE2->ZE2_PLANTA,cSta,ZE2->ZE2_CUSTO})
					
					nCusTot += ZE2->ZE2_CUSTO
					
					ZE2->(DbSkip())
				EndDo
				
				aAdd(aCols,{"","","TOTAL",nCusTot})
			EndIf
			nCusTot := 0
			
			IF nPar <> 3 //apenas visualiza็ใo
				oMultiline:nMax := len(aCols) //nao deixa o usuario adicionar mais uma linha no multiline
			EndIf
				
		EndIf
				
		@ 224,010 BMPButton Type 01 Action fOk()
		@ 224,040 BMPButton Type 02 Action oDlg:End()
		
	Activate MsDialog oDlg Center
	
Return

//-----------------------------------------------------------------------------------------------------\\

Static Function fOk()

If nPar == 3
	fInclui()
ElseIf nPar == 4
	fAltera()
ElseIf nPar == 5
	fExclui()
EndIf

Return

//-----------------------------------------------------------------------------------------------------\\

	//*********************************\\
	//********GRAVANDO OS DADOS********\\
	//*********************************\\

Static Function fInclui()
Local nX := 1
Local xD := 1

	RecLock("ZE1",.T.)
		ZE1->ZE1_FILIAL := xFilial("ZE1")
		ZE1->ZE1_NUM 	:= cNum
		ZE1->ZE1_NUMCLI := cWOCli
		ZE1->ZE1_PROD	:= cProd
		ZE1->ZE1_RESUMO := cResu
		ZE1->ZE1_DATA	:= dData
		ZE1->ZE1_HORA	:= cHora 
		ZE1->ZE1_RESP	:= cResp
		ZE1->ZE1_SETOR	:= cSetor
		ZE1->ZE1_DESC	:= Upper(cMemo)
		ZE1->ZE1_STATUS := cStatus
		ZE1->ZE1_APCLI	:= "N"				//aprova็ใo do cliente sempre N quando Inclui
		ZE1->ZE1_CLI	:= cCli
		ZE1->ZE1_LOJA	:= cLoja
	MsUnlock("ZE1")
	
	While nX <= 4
		If &("lChk"+AllTrim(Str(nX,1))+" == .T.")
		
			If nX == 1
				cPlanta := "USINAGEM"
			ElseIf nX == 2
				cPlanta := "FUNDICAO"
			ElseIf nX == 3
				cPlanta := "FORJARIA"
			Else
				cPlanta := "VIRABREQUIM"
			EndIf
			
			RecLock("ZE2",.T.)
				ZE2->ZE2_FILIAL := xFilial("ZE2")
				ZE2->ZE2_NUM	:= cNum
				ZE2->ZE2_ITEM	:= AllTrim(StrZero(xD,4))
				ZE2->ZE2_STATUS	:= "A"			//STATUS: ABERTO
				ZE2->ZE2_SETOR	:= "ENGENHARIA"
				ZE2->ZE2_PLANTA := cPlanta
			MsUnlock("ZE2") 
			xD++
		EndIf
		nX++
	EndDo
	
	oDlg:End()

Return

//--------------------------------------------------------------------------------------------------------------\\

//VALIDAวรO DE CENTRO DE CUSTO

Static Function fValCC()

CTT->(DbSetOrder(1))

If !CTT->(DbSeek(xFilial("CTT")+cSetor))
	Alert("Setor (Centro de Custo) nใo encontrado, verifique!")
	Return .F.
EndIf

Return .T.

//--------------------------------------------------------------------------------------------------------------\\

//VALIDAวรO DE PRODUTO

Static Function fValProd()
SB1->(DbSetOrder(1))		//filial+cod
If !Empty(cProd)
	If SB1->(DbSeek(xFilial("SB1")+cProd))
		cPrDesc := SB1->B1_DESC
	Else
		alert("C๓digo do Produto Invแlido!")
		Return .F.
	EndIf
Else
	Alert("Digite um C๓digo de Produto!")
	Return .F.
EndIf


Return .T.

//--------------------------------------------------------------------------------------------------------------\\

//VALIDAวรO DE CLIENTE

Static Function fValCli()
SA1->(DbSetOrder(1))		//filial+cod+LOJA

If Empty(cLoja)
	cLoja := "01"
EndIf

If !Empty(cCli)
	If SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
		cClDesc := SA1->A1_NOME
	Else
		alert("C๓digo do Cliente Invแlido!")
		Return .F.
	EndIf
Else
	Alert("Digite um C๓digo de Cliente!")
	Return .F.
EndIf


Return .T.

//--------------------------------------------------------------------------------------------------------------\\

Static Function fExclui()
		
	If MsgYesNo("Tem certeza de que deseja excluir?")
		RecLock("ZE1",.F.)
			ZE1->(DbDelete())
		MsUnlock("ZE1")
		If ZE2->(DbSeek(xFilial("ZE2")+cNum))
			While ZE2->(!EoF()) .AND. ZE2->ZE2_NUM==cNum
				RecLock("ZE2",.F.)
					ZE2->(DbDelete())
				MsUnlock("ZE2")
				
				ZE2->(DbSkip())
			EndDo
		EndIf
	EndIf	
	
	oDlg:End()

Return