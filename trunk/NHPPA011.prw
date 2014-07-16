
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPPA011  ºAutor  ³FELIPE CICONINI     º Data ³  30/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TELA DE CADASTRO DE MODIFICAÇÕES DO CLIENTE (COMERCIAL)     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³COMERCIAL,PPAP                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

~>CRIADO TABELA ZE5 PARA CONTROLAR E-MAILS PARA ENVIO, DIVIDIDO POR PLANTA E SETORES.

PLANTAS:
1-Usinagem
2-Fundicao
3-Forjaria
4-Virabrequim

SETORES:
1-Compras
2-Controladoria
3-Manutencao
4-Qualidade
5-PRE-SET
6-Informatica
7-Producao
8-Logistica
9-Engenharia

*/
#include "AP5MAIL.CH"
#include "FONT.CH"
#Include "PRTOPDEF.CH"    
#Include "FIVEWIN.CH"
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
Private cInicia := "2"
Private cIniciad:= "N"

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
Private cQuaF   := "Não"
Private cProF   := "N/A"
Private cConF   := "Sim"
Private cPreF   := "Não"
Private cLogF   := "N/A"
Private cManF   := "Sim"
Private cInfF   := "Não"
Private cEngF   := "Sim"

Private cMemo   := Space(350)

Private aCampos := {"NÃO","SIM"}

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
ElseIf nPar == 6		//INICIA
	fCarrega()
EndIf

Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

Static Function fCarrega()
Local nCusTot := 0
Local nLin 	:= 10
Local xL	:= 1
Local cSta	:= ""
Local nTam	:= 0

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
		cApCli := Iif(ZE1->ZE1_APCLI=="S","SIM","NÃO")
		cIniciad:= Iif(ZE1->ZE1_INICIA=="S","S","N")
			
		If ZE1->ZE1_STATUS == "A"
			cStatus	:= "ABERTA"
		ElseIf ZE1->ZE1_STATUS == "P"
			cStatus	:= "PENDENTE"
		ElseIf ZE1->ZE1_STATUS == "F"
			cStatus	:= "FINALIZADO"
		ElseIf ZE1->ZE1_STATUS == "I"
			cStatus := "INICIADO"
		EndIf
		
		ZE2->(DbSelectArea(1))		//filial+num
		If ZE2->(DbSeek(xFilial("ZE2")+cNum))
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
//	ElseIf nPar == 3
//		cNum := GetSxENum("ZE1","ZE1_NUM")
	EndIf


    nTam := Iif(nPar==3,450,850)
    
	Define MsDialog oDlg From 0,0 To 490,nTam Pixel Title "GERENCIADOR DE MODIFICAÇÃO"			//TELA DE CADASTRO
		@ 005,005 To  218,225 LABEL "" Of oDlg Pixel
//	      LIN,COL
		@ 012,010 Say "Número"		Size 35,8 Object oNm
		@ 012,035 Say cNum			Size 45,8 Object oNum
	   
		@ 012,070 Say "Nº Alteração Cliente" Color CLR_HBLUE								Size 060,08 Object oWo
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
		
		@ 092,010 Say "Descrição Necessidade"									Size 055,08 Object oNece
		@ 100,010 GET cMemo			MEMO	Size 210,60 Of oDlg Pixel HSCROLL When nPar==3
		
//--------------------------------------------------------------------------------------------------------------\\
		
		@ 178,010 Say "Engenharias:" Object oSets
		
		@ 192,030 CheckBox oChk1 	 Var lChk1 Prompt "" When nPar==3 Size 010,08 Pixel Of oDlg
		@ 193,040 Say "Usinagem" 	 Object oCh1
		
		@ 192,095 CheckBox oChk2 	 Var lChk2 Prompt "" When nPar==3 Size 040,08 Pixel Of oDlg
		@ 193,105 Say "Fundição" 	 Object oCh2
		
		@ 192,160 CheckBox oChk3 	 Var lChk3 Prompt "" When nPar==3 Size 040,08 Pixel Of oDlg
		@ 193,170 Say "Forjaria" 	 Object oCh3
		
		@ 206,030 CheckBox oChk4 	 Var lChk4 Prompt "" When nPar==3 Size 040,08 Pixel Of oDlg
		@ 207,040 Say "Virabrequim"  Object oCh4
		
//--------------------------------------------------------------------------------------------------------------\\
		
		@ 005,230 To 218,425 LABEL "Custo por Setor" Of oDlg Pixel
		
		If nPar<>3			//SE ESTIVER EM ANDAMENTO
		
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
						cSta := "NÃO APLICA"
					ElseIf ZE2->ZE2_STATUS == "F"
						cSta := "FINALIZADO"
					ElseIf ZE2->ZE2_STATUS == "I"
						cSta := "INICIADO"
					EndIf
					
					aAdd(aCols,{ZE2->ZE2_SETOR,ZE2->ZE2_PLANTA,cSta,ZE2->ZE2_CUSTO})
					
					nCusTot += ZE2->ZE2_CUSTO
					
					ZE2->(DbSkip())
				EndDo
				
				aAdd(aCols,{"","","TOTAL",nCusTot})
			EndIf
			nCusTot := 0
			
			IF nPar <> 3 //apenas visualização
				oMultiline:nMax := len(aCols) //nao deixa o usuario adicionar mais uma linha no multiline
			EndIf
				
		EndIf
				
		@ 224,010 BMPButton Type 01 Action fOk()
		@ 224,040 BMPButton Type 02 Action fCancela()
		If ZE1->ZE1_STATUS <> "A" .AND. cIniciad <> "S"
			@ 224,380 Button "Iniciar" Size 40,11 Action fInicia() Object obt1
		Else
			@ 224,380 Button "Finalizar" Size 40,11 Action fFinal() Object obt1
		EndIf
		
	Activate MsDialog oDlg Center
	
Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

Static Function fCancela()

	RollbackSX8()
	Close(oDlg)

Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

Static Function fOk()

If nPar == 3
	fInclui()
ElseIf nPar == 4
	fAltera()
ElseIf nPar == 5
	fExclui()
EndIf

Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

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
		ZE1->ZE1_DESC	:= AllTrim(Upper(cMemo))
		ZE1->ZE1_STATUS := cStatus
		ZE1->ZE1_APCLI	:= "N"				//aprovação do cliente sempre N quando Inclui
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
			
			If ZE2->(DbSeek(xFilial("ZE2")+cNum))			//pegando ultimo item, se já existe com o mesmo numero
				While cNum == ZE2->ZE2_NUM
					xD++
					ZE2->(DbSkip())
				EndDo
			EndIf
			
			ZE2->(DbSetOrder(2))		//FILIAL + NUM + PLANTA + SETOR
			If !ZE2->(DbSeek(xFilial("ZE2")+cNum+cPlanta+"ENGENHARIA"))
				RecLock("ZE2",.T.)
					ZE2->ZE2_FILIAL := xFilial("ZE2")
					ZE2->ZE2_NUM	:= cNum
					ZE2->ZE2_ITEM	:= AllTrim(StrZero(xD,4))
					ZE2->ZE2_STATUS	:= "A"			//STATUS: ABERTO
					ZE2->ZE2_SETOR	:= "ENGENHARIA"
					ZE2->ZE2_PLANTA := cPlanta
				MsUnlock("ZE2")
			EndIf
		EndIf
		nX++
	EndDo
	
	ConfirmSX8()
	
	fEnviaEmail()	//ENVIA EMAIL
	
	oDlg:End()

Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

//VALIDAÇÃO DE CENTRO DE CUSTO

Static Function fValCC()

CTT->(DbSetOrder(1))

If !CTT->(DbSeek(xFilial("CTT")+cSetor))
	Alert("Setor (Centro de Custo) não encontrado, verifique!")
	Return .F.
EndIf

Return .T.

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

//VALIDAÇÃO DE PRODUTO

Static Function fValProd()
SB1->(DbSetOrder(1))		//filial+cod
If !Empty(cProd)
	If SB1->(DbSeek(xFilial("SB1")+cProd))
		cPrDesc := SB1->B1_DESC
	Else
		alert("Código do Produto Inválido!")
		Return .F.
	EndIf
Else
	Alert("Digite um Código de Produto!")
	Return .F.
EndIf


Return .T.

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

//VALIDAÇÃO DE CLIENTE

Static Function fValCli()
SA1->(DbSetOrder(1))		//filial+cod+LOJA

If Empty(cLoja)
	cLoja := "01"
EndIf

If !Empty(cCli)
	If SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
		cClDesc := SA1->A1_NOME
	Else
		alert("Código do Cliente Inválido!")
		Return .F.
	EndIf
Else
	Alert("Digite um Código de Cliente!")
	Return .F.
EndIf


Return .T.

//--------------------------------------------------------------------------------------------------------------\\
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

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

Static Function fEnviaEmail()
Local cMsg
Local cQuery
Local Nx := 1
Local cTo2 := ""
Local nD := 0
	
	//MONTANDO EMAIL
	oMail := Email():New()
	oMail:cAssunto := "*** SOLICITAÇÃO DE ALTERAÇÃO Nº "+cNum+" ***"
	
	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="50%" border="1" cellpadding="1" align="center">'
	
	cMsg += '<tr>'
	cMsg += '<td colspan="4" style="background:#ccc">'
	cMsg += '<CENTER><b>NUMERO DE ALTERAÇÃO DO CLIENTE '+cWoCli+'</b></CENTER>'
	cMsg += '</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Produto</td>'
	cMsg += '<td>'+cProd+'</td>'
	cMsg += '<td style="background:#abc">Descrição</td>'
	cMsg += '<td>'+cPrDesc+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Cliente/Loja</td>'
	cMsg += '<td>'+cCli+'/'+cLoja+'</td>'
	cMsg += '<td style="background:#abc">Razão Social</td>'
	cMsg += '<td>'+cClDesc+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Responsável</td>'
	
	cMsg += '<td>'+cResp+'</td>'
	cMsg += '<td style="background:#abc">Data</td>'
	cMsg += '<td>'+DtoC(dData)+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Resumo</td>'
	cMsg += '<td colspan="3">'+cResu+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Descrição da Mudança</td>'
	cMsg += '<td colspan="3">'+cMemo+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Plantas</td>'
	cPlanta := ""
	nD := 0
	While nX <= 4
		If &("lChk"+AllTrim(Str(nX,1))+" == .T.")
			If nD <> 0
				cPlanta += ", "
				nD++
			Else
				nD++
			EndIf
			If nX == 1
				cPlanta += "USINAGEM"
			ElseIf nX == 2
				cPlanta += "FUNDIÇÃO"
			ElseIf nX == 3
				cPlanta += "FORJARIA"
			Else
				cPlanta += "VIRABREQUIM"
			EndIf
		EndIf
		nX++
	EndDo
	cMsg += '<td colspan="3">'+cPlanta+'</td>'
	cMsg += '</tr>'
	
	cMsg += '</table><br />'
	
    cQuery := "SELECT QAA_EMAIL"
    cQuery += " FROM "+RetSqlName("ZE5")+" ZE5, "+RetSqlName("QAA")+" QAA "
    cQuery += " WHERE ZE5_LOGIN = QAA_LOGIN"
    cQuery += " AND ZE5.D_E_L_E_T_ = ''"
    cQuery += " AND QAA.D_E_L_E_T_ = ''"
    cQuery += " AND ZE5.ZE5_FILIAL = '"+xFilial("ZE5")+"'"
    cQuery += " AND QAA.QAA_FILIAL = '"+xFilial("QAA")+"'"
    cQuery += " AND ZE5.ZE5_SETOR = 9"
    cQuery += " AND ZE5.ZE5_PLANTA IN ("

	//ADICIONANDO DESTINATÁRIOS
	nX := 1
	nD := 0
	While nX <= 4
		If &("lChk"+AllTrim(Str(nX,1))+" == .T.")
		
			If nD <> 0
				cQuery += ","
				nD++
			Else
				nD++
			EndIf
		
			If nX == 1		//ENGENHARIA USINAGEM
				cQuery += "1"
								
			ElseIf nX == 2	//ENGENHARIA FUNDIÇÃO
				cQuery += "2"
				
			ElseIf nX == 3	//ENGENHARIA FORJARIA
				cQuery += "3"
				
			Else			//ENGENHARIA VIRABREQUIM
				cQuery += "4"
			EndIf
		EndIf
		nX++
	EndDo 
	
	cQuery += ")"
    MemoWrit("C:\TEMP\NHPPA011.SQL",cQuery)
	TCQUERY cQuery NEW ALIAS "TMP1"

	TMP1->(DbGoTop())
	While TMP1->(!EoF())		//MONTANDO LISTA DE DISTRIBUIÇÃO
		cTo += TMP1->QAA_EMAIL+"; "
		TMP1->(DbSkip())
	EndDo
	
    cMsg += '<br/>'
	cMsg += '</body>'
	cMsg += '</html>'	
	oMail:cMsg := cMsg
	oMail:cTo := cTo
	
	oMail:Envia()
	
	TMP1->(DbCloseArea())
	
Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

Static Function fInicia()
Local cAprov

	If ZE2->(DbSeek(xFilial("ZE2")+cNum))
		While ZE2->ZE2_NUM == cNum
			If ZE2->ZE2_STATUS <> "F" .AND. ZE2->ZE2_STATUS <> "N"
				Alert("Há Setores com Situação Pendente!")
				Return .F.
			EndIf
			ZE2->(DbSkip())
		EndDo
	EndIf
	
	If ZE1->ZE1_INICIA == "S"
		Alert("Já iniciado!")
		Return .F.
	EndIf
    
	If ZE1->ZE1_STATUS == "F"
		Alert("Já Finalizado!")
		Return .F.
	EndIf
	
	If !MsgBox("Cliente Aprovou?","Aprovação","YESNO")
		cAprov := "N"
	Else
		cAprov := "S"
	EndIf
	
	RecLock("ZE1",.F.)
		ZE1->ZE1_RESUMO := cResu
		ZE1->ZE1_DATA	:= Date()
		ZE1->ZE1_HORA	:= SubStr(Time(),1,5) 
		ZE1->ZE1_RESP	:= cResp
		ZE1->ZE1_DESC	:= AllTrim(Upper(cMemo))
		ZE1->ZE1_STATUS := "I"
		ZE1->ZE1_APCLI	:= cAprov
		ZE1->ZE1_INICIA := "S"
	MsUnlock("ZE1")
	
	If ZE2->(DbSeek(xFilial("ZE2")+cNum))
		While ZE2->ZE2_NUM == cNum
			RecLock("ZE2",.F.)
				ZE2->ZE2_CUSTO	:= 0
				ZE2->ZE2_HORA	:= ""
				ZE2->ZE2_PRAZO	:= Date()
				ZE2->ZE2_RESP	:= ""
				ZE2->ZE2_DATA	:= Date()
				ZE2->ZE2_STATUS := "I"
			MsUnlock("ZE2")
			If ZE6->(DbSeek(xFilial("ZE6")+ZE2->ZE2_NUM+ZE2->ZE2_ITEM))
				While ZE6->ZE6_NUMMOD+ZE6->ZE6_ITEMMD == ZE2->ZE2_NUM+ZE2->ZE2_ITEM
					RecLock("ZE6",.F.)
						ZE6->(DbDelete())
					MsUnlock("ZE6")
					ZE6->(DbSkip())
				EndDo
			EndIf
			ZE2->(DbSkip())
		EndDo
	EndIf
	
	oDlg:End()
					
Return

Static Function fFinal()
Local cAprov

	If ZE2->(DbSeek(xFilial("ZE2")+cNum))
		While ZE2->ZE2_NUM == cNum
			If ZE2->ZE2_STATUS <> "F" .AND. ZE2->ZE2_STATUS <> "N"
				Alert("Há Setores com Situação Pendente!")
				Return .F.
			EndIf
			ZE2->(DbSkip())
		EndDo
	EndIf
	
	If !MsgBox("Cliente Aprovou?","Aprovação","YESNO")
		cAprov := "N"
	Else
		cAprov := "S"
	EndIf
	
	RecLock("ZE1",.F.)
		ZE1->ZE1_STATUS := "F"
	MsUnlock("ZE1")
	
	oDlg:End()
	
Return