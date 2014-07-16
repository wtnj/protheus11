
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPPA008  ºAutor  ³FELIPE CICONINI     º Data ³  12/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TELA DE CADASTRO DE REQUISITO DO CLIENTE                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

~>CRIADO TABELA ZE5 PARA CONTROLAR E-MAILS PARA ENVIO, DIVIDIDO POR PLANTA E SETORES.
~>CRIADO TABELA ZE6 PARA CONTROLAR OBSERVAÇÕES DA TELA DE ACOMPANHAMENTO.

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

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"

User Function NHPPA008(nParam)
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
Private cSetor  := Space(09)
Private cWoCli  := Space(06)
Private nCusto  := 0
Private cPlanta := " "
Private cItem	:= ""
Private cPla	:= 0
Private cObs	:= Space(350)
Private cObsNum := 1
Private cStatus := ""
Private aMat	:= {}
Private aObs	:= {}

Private dDta    := Date()
Private dPrazo  := Date()
Private dData   := Date()
Private cHora   := Time()
Private obt1
Private obt2
Private obt3
Private obt4

Private lChq1,lChq2,lChq3,lChq4,lChq5,lChq6,lChq7,lChq8,lChq9
lChq1 := .F.
lChq2 := .F.
lChq3 := .F.
lChq4 := .F.
lChq5 := .F.
lChq6 := .F.
lChq7 := .F.
lChq8 := .F.
lChq9 := .F.

oLbx  := Nil

//--------------------------------------------------------------------------------------------------------------\\

If nPar == 2		//ACOMPANHAMENTO ENGENHARIA
	If SubStr(ZE2->ZE2_SETOR,1,1) <> "E"
		Alert("Setor incorreto!")
		Return .F.
	EndIf
	fCarrega()
	fEngenharia()
ElseIf nPar == 3		//ACOMPANHAMENTO SETORES
	If SubStr(ZE2->ZE2_SETOR,1,1) == "E"
		Alert("Setor incorreto!")
		Return .F.
	EndIf
	fCarrega()
	fAcompanha()
EndIf

Return .T.

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

	//**********************************************\\
	//******TELA DE ACOMPANHAMENTO DOS SETORES******\\
	//**********************************************\\

Static Function fAcompanha()


	Define MsDialog oDlgAc From 0,0 To 360,460 Pixel Title "ACOMPANHAMENTO - "+AllTrim(cSetor)+" - "+AllTrim(cPlanta)
//	      LIN,COL
		@ 012,010 Say "Número"		 Size 35,8 Object oNm
		@ 012,035 Say SubStr(cNum,2,5)+"/"+SubStr(cItem,2,3)				Size 45,8 Object oNum
	   
		@ 012,065 Say "Responsável"	 								  		Size 45,08 Object oRes
		@ 010,100 Get cResp			 Picture "@!" 		 	 When .F. 		Size 55,08 Object oResp
	   
		@ 012,165 Say "Data" 		 								  		Size 35,08 Object oDta
		@ 010,180 Get dDta			 Picture "99/99/9999" 	 When .F. 		Size 40,08 Object oData
	   
		@ 030,010 Say "Custo"		 						 		  		Size 35,08 Object oCus
		@ 028,035 Get nCusto		 Picture "@e 999,999.99" When fValOp() 	Size 45,08 Object oCusto
		
		@ 030,090 Say "Planta"		 								  		Size 20,08 Object oPla
		@ 028,110 Get cPlanta	 	 Picture "@!"			 When .F. 		Size 35,08 Object oPlan
				
		@ 030,165 Say "Hora"		 								  		Size 45,08 Object oHr
		@ 028,180 Get cHora			 Picture "99:99"		 When .F. 		Size 20,08 Object oHora
		
		@ 048,010 Say "Prazo"		 Color CLR_HBLUE				  		Size 35,08 Object oPra
		@ 046,035 Get dPrazo		 Picture "99/99/9999" 	 When fValOp() 	Size 45,08 Object oPrazo
	
		@ 066,005 To 150,225 Label "Descrição" Of oDlgAc Pixel
		@ 074,010 ListBox oLbx Fields HEADER "Numero","Data","Hora","Responsavel" Size 210,060 Of oDlgAc Pixel On DBLCLICK( fAddObs(2,oLbx:nAt))
		
		If ZE2->ZE2_STATUS <> "A"
			fCarrList()
		EndIf

	    aAdd(aMat,{" "," "," "," "})
	    
	    oLbx:SetArray( aMat )
		oLbx:bLine := {|| {aMat[oLbx:nAt,1],;	// NUMERO
						   aMat[oLbx:nAt,2],;	// DATA
						   aMat[oLbx:nAt,3],;	// HORA
						   aMat[oLbx:nAt,4]}}	// RESPONSAVEL
		oLbx:Refresh()
		
		
		@ 135,145 Button "Adicionar OBS" Size 40,11 Action fAddOBS(1) Object obt3
		@ 135,190 Button "Visualizar" 	 Size 30,11 Action fAddOBS(2,oLbx:nAt) Object obt4
		
		If cStatus <> "F" .AND. cStatus <> "N"
			@ 155,010 BMPButton Type 01 Action GravaAcomp(1)
		EndIf
		@ 155,040 BMPButton Type 02 Action oDlgAc:End()
		@ 155,145 Button "Finalizar" 	 Size 30,11 Action fFinal(1) Object obt1
		@ 155,180 Button "Não se Aplica" Size 40,11 Action fNApl(1) Object obt2
		
		If cStatus == "F" .OR. cStatus == "N"
			obt1:Disable()
			obt2:Disable()
		EndIf
		
	Activate MsDialog oDlgAc Center 

Return

//--------------------------------------------------------------------------------------------------------------\\
//--------------------------------------------------------------------------------------------------------------\\

	//************************************************\\
	//******TELA DE ACOMPANHAMENTO DA ENGENHARIA******\\
	//************************************************\\

Static Function fEngenharia()

	Define MsDialog oDlgEn From 0,0 To 470,460 Pixel Title "ACOMPANHAMENTO - ENGENHARIA - "+AllTrim(cPlanta)
//	      LIN,COL
		@ 012,010 Say "Número"		Size 35,8 Object oNm
		@ 012,035 Say SubStr(cNum,2,5)+"/"+SubStr(cItem,2,3)			Size 45,8 Object oNum
	   
		@ 012,065 Say "Responsável"										 		Size 45,08 Object oRes
		@ 010,100 Get cResp				Picture "@!" 		 	When .F. 		Size 55,08 Object oResp
	   
		@ 012,165 Say "Data" 											 		Size 35,08 Object oDta
		@ 010,180 Get dDta				Picture "99/99/9999" 	When .F. 		Size 40,08 Object oData
	   
		@ 030,010 Say "Custo"									 		 		Size 35,08 Object oCus
		@ 028,035 Get nCusto			Picture "@e 999,999.99" When fValOp() 	Size 45,08 Object oCusto
		
		@ 030,090 Say "Planta"											 		Size 20,08 Object oPla
		@ 028,110 Get cPlanta			Picture "@!"			When .F. 		Size 35,08 Object oPlan
		
		@ 030,165 Say "Hora"											 		Size 45,08 Object oHr
		@ 028,180 Get cHora				Picture "99:99"		 	When .F. 		Size 20,08 Object oHora
		
		@ 048,010 Say "Prazo"			Color CLR_HBLUE					 		Size 35,08 Object oPra
		@ 046,035 Get dPrazo			Picture "99/99/9999"	When fValOp()	Size 45,08 Object oPrazo
		
		@ 066,005 To 150,225 Label "Descrição" Of oDlgEn Pixel
		@ 074,010 ListBox oLbx Fields HEADER "Numero","Data","Hora","Responsavel" Size 210,060 Of oDlgEn Pixel On DBLCLICK( fAddOBS(2,oLbx:nAt))
		
		If ZE2->ZE2_STATUS <> "A"
			fCarrList()
		EndIf

	    aAdd(aMat,{" "," "," "," "})
	    
	    oLbx:SetArray( aMat )
		oLbx:bLine := {|| {aMat[oLbx:nAt,1],;	// NUMERO
						   aMat[oLbx:nAt,2],;	// DATA
						   aMat[oLbx:nAt,3],;	// HORA
						   aMat[oLbx:nAt,4]}}	// RESPONSAVEL
		oLbx:Refresh()
	
		@ 135,145 Button "Adicionar OBS" Size 40,11 Action fAddOBS(1) Object obt3
		@ 135,190 Button "Visualizar" 	 Size 30,11 Action fAddOBS(2,oLbx:nAt) Object obt4
		
		//-------------------------***SELEÇÃO DE SETORES***----------------------------------------------------\\
		
		@ 160,010 To 217,220 LABEL "Setores" Of oDlgEn Pixel
		
		@ 174,030 CheckBox oChq1 		Var lChq1 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 175,040 Say "Compras" 		Object oCh1
		
		@ 174,095 CheckBox oChq2 		Var lChq2 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 175,105 Say "Controladoria" 	Object oCh2
		
		@ 174,160 CheckBox oChq3 		Var lChq3 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 175,170 Say "Manutenção"		Object oCh3
		
		@ 188,030 CheckBox oChq4 		Var lChq4 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 189,040 Say "Qualidade" 		Object oCh4
		
		@ 188,095 CheckBox oChq5 		Var lChq5 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 189,105 Say "PRESET"			Object oCh5
		
		@ 188,160 CheckBox oChq6 		Var lChq6 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 189,170 Say "Informática" 	Object oCh6
		
		@ 202,030 CheckBox oChq7 		Var lChq7 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 203,040 Say "Produção" 		Object oCh7
		
		@ 202,095 CheckBox oChq8 		Var lChq8 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 203,105 Say "Logística"  		Object oCh8
		
		@ 220,010 BMPButton Type 01 Action GravaAcomp(2)
		@ 220,040 BMPButton Type 02 Action oDlgEn:End()
		@ 220,145 Button "Finalizar" 	 Size 030,11	Action fFinal(2) Object obt3
		@ 220,180 Button "Não se Aplica" Size 040,11	Action fNApl(2) Object obt4
		
		If cStatus == "F" .OR. cStatus == "N"
			obt3:Disable()
			obt4:Disable()
		EndIf
		
	Activate MsDialog oDlgEn Center
	
Return

//-----------------------------------------------------------------------------------------------------\\
//---------------------------FUNÇÃO BOTÃO FINALIZAR----------------------------------------------------\\

//BOTAO FINALIZAR

Static Function fFinal(nX)

	If nPar == 2
		cQuery := "SELECT *"
		cQuery += " FROM "+RetSqlName("ZE2")
		cQuery += " WHERE 	ZE2_NUM 	=  '"+cNum+"'"
		cQuery += " AND 	ZE2_SETOR	<> 'ENGENHARIA'"
		cQuery += " AND		ZE2_PLANTA	= '"+AllTrim(cPlanta)+"'"
		cQuery += " AND		D_E_L_E_T_  = ''"
		cQuery += " AND		ZE2_FILIAL	= '"+xFilial("ZE2")+"'"
	
	    TCQUERY cQuery NEW ALIAS "TMP1"	
	    
	    TMP1->(DbGoTop())
	    
	    While TMP1->(!EoF())
	    	If TMP1->ZE2_STATUS == "A" .OR. TMP1->ZE2_STATUS == "P"
	       		Alert("Há setores que ainda não finalizaram!")
	       		TMP1->(DbCloseArea())
	    		Return .F.	    
	    	EndIf
	    	TMP1->(DbSkip())
	    EndDo
	    
	    TMP1->(DbCloseArea())		
	
	EndIf
	
    If MsgBox("Tem Certeza?","Finalizar","YESNO")
    	If len(aMat) <= 0
    		Alert("Digite uma observação!")
    		Return .F.
    	EndIf
		RecLock("ZE2",.F.)
			ZE2->ZE2_STATUS := "F"		   		//STATUS: FINALIZADO
			ZE2->ZE2_CUSTO	:= nCusto
			ZE2->ZE2_RESP	:= cResp
			ZE2->ZE2_DATA	:= dData
			ZE2->ZE2_HORA	:= cHora
		MsUnlock("ZE2")
		
		For xD:=1 to Len(aObs)
			RecLock("ZE6",.T.)
				ZE6->ZE6_FILIAL := xFilial("ZE6")
				ZE6->ZE6_NUMMOD	:= aObs[xD][1]
				ZE6->ZE6_ITEMMD := aObs[xD][2]
				ZE6->ZE6_NUMOBS := aObs[xD][3]
				ZE6->ZE6_OBS	:= Upper(aObs[xD][4])
				ZE6->ZE6_DATA	:= aObs[xD][5]
				ZE6->ZE6_HORA	:= aObs[xD][6]
				ZE6->ZE6_RESP	:= aObs[xD][7]
			MsUnlock("ZE6")
		Next
		
		fEnviaEmail()
		
		If nX == 1
			oDlgAc:End()
		Else
			oDlgEn:End()
		EndIf
	EndIf
	
Return

//-----------------------------------------------------------------------------------------------------\\
//-------------------------------FUNÇÃO BOTÃO NÃO SE APLICA--------------------------------------------\\

//BOTAO NÃO SE APLICA

Static Function fNApl(nX)
Local cQuery
Local xD
	
	If len(aMat) <= 0
 		Alert("Digite uma observação!")
    	Return .F.
 	EndIf
	
	If MsgBox("Tem Certeza?","Não se Aplica","YESNO")
		RecLock("ZE2",.F.)
			ZE2->ZE2_STATUS := "N"				//STATUS: NAO SE APLICA
			ZE2->ZE2_RESP	:= cResp
			ZE2->ZE2_DATA	:= dData
			ZE2->ZE2_HORA	:= cHora
		MsUnlock("ZE2")
		
		For xD:=1 to Len(aObs)
			RecLock("ZE6",.T.)
				ZE6->ZE6_FILIAL := xFilial("ZE6")
				ZE6->ZE6_NUMMOD	:= aObs[xD][1]
				ZE6->ZE6_ITEMMD := aObs[xD][2]
				ZE6->ZE6_NUMOBS := aObs[xD][3]
				ZE6->ZE6_OBS	:= Upper(aObs[xD][4])
				ZE6->ZE6_DATA	:= aObs[xD][5]
				ZE6->ZE6_HORA	:= aObs[xD][6]
				ZE6->ZE6_RESP	:= aObs[xD][7]
			MsUnlock("ZE6")
		Next
		
//		fEnviaEmail()
		
		If nX == 1
			oDlgAc:End()
		Else
			oDlgEn:End()
		EndIf
	EndIf
		
Return

//-----------------------------------------------------------------------------------------------------\\
//---------------------------------GRAVAÇÃO DE DADOS---------------------------------------------------\\

	//*********************************\\
	//********GRAVANDO OS DADOS********\\
	//*********************************\\

Static Function GravaAcomp(xD)
Local xN := 1
Local xO
Local cPlanta := ZE2->ZE2_PLANTA
Local nItem := 1
    
	If !fValida()
		Return .F.
	EndIf

    If ZE1->(DbSeek(xFilial("ZE1")+ZE2->ZE2_NUM))
    	RecLock("ZE1",.F.)
    		ZE1->ZE1_STATUS := "P"
    	MsUnlock("ZE1")
    EndIf

	RecLock("ZE2",.F.)
		ZE2->ZE2_STATUS := "P"					//STATUS: PENDENTE
		ZE2->ZE2_PRAZO	:= dPrazo
		ZE2->ZE2_CUSTO	:= nCusto
		ZE2->ZE2_RESP	:= cResp
		ZE2->ZE2_DATA	:= dData
		ZE2->ZE2_HORA	:= cHora
	MsUnlock("ZE2")
	
	If fVerifObs()				//FUNÇÃO DE VERIFICAR O QUE JÁ ESTÁ GRAVADO DE OBSERVAÇÕES
		For xO:=1 to len(aObs)
			If !Empty(aObs[xO][1])
				RecLock("ZE6",.T.)
					ZE6->ZE6_FILIAL := xFilial("ZE6")
					ZE6->ZE6_NUMMOD := aObs[xO][1]
					ZE6->ZE6_ITEMMD := aObs[xO][2]
					ZE6->ZE6_NUMOBS	:= aObs[xO][3]
					ZE6->ZE6_OBS	:= Upper(aObs[xO][4])
					ZE6->ZE6_DATA	:= aObs[xO][5]
					ZE6->ZE6_HORA	:= aObs[xO][6]
					ZE6->ZE6_RESP	:= aObs[xO][7]
				MsUnlock("ZE6")
			EndIf
		Next
	EndIf
	
	If xD == 2					//ENGENHARIA
		
		If ZE2->(DbSeek(xFilial("ZE2")+cNum))			//pegando ultimo item, se já existe com o mesmo numero
			While cNum == ZE2->ZE2_NUM
				nItem++
				ZE2->(DbSkip())
			EndDo
		EndIf
		
		While xN <= 9
			If &("lChq"+AllTrim(Str(xN,1))+" == .T.")
			
				If xN == 1
					cSetor := "COMPRAS"
				ElseIf xN == 2
					cSetor := "CONTROLADORIA"
				ElseIf xN == 3
					cSetor := "MANUTENCAO"
				ElseIf xN == 4
					cSetor := "QUALIDADE"
				ElseIf xN == 5
					cSetor := "PRESET"
				ElseIf xN == 6
					cSetor := "INFORMATICA"
				ElseIf xN == 7
					cSetor := "PRODUCAO"
				ElseIf xN == 8
					cSetor := "LOGISTICA"
				EndIf
				
				ZE2->(DbSetOrder(2))		//FILIAL + NUM + PLANTA + SETOR
				If !ZE2->(DbSeek(xFilial("ZE2")+cNum+cPlanta+cSetor))
					RecLock("ZE2",.T.)
						ZE2->ZE2_FILIAL := xFilial("ZE2")
						ZE2->ZE2_NUM	:= cNum
						ZE2->ZE2_ITEM	:= AllTrim(StrZero(nItem,4))
						ZE2->ZE2_STATUS	:= "A"			//STATUS: ABERTO
						ZE2->ZE2_PLANTA := cPlanta
						ZE2->ZE2_SETOR	:= cSetor				
					MsUnlock("ZE2")
					nItem++
				EndIf
			EndIf
			xN++
		EndDo
		
		fEnviaEmail()
		oDlgEn:End()
	Else
		
		fEnviaEmail()
		oDlgAc:End()
	EndIf
		
Return

//-----------------------------------------------------------------------------------------------------\\
//---------------------------------VALIDA OS DADOS-----------------------------------------------------\\

Static Function fvalida()

If !fValOp()
	Return .F.
EndIf

If len(aObs) > 0
	If aObs[1][1] == " "
		Alert("Adicione uma observação!")
		Return .F.
	EndIf
Else
	Alert("Adicione uma observação!")
	Return .F.
EndIf

Return .T.

//-----------------------------------------------------------------------------------------------------\\
//---------------------------------CARREGA DADOS-------------------------------------------------------\\

Static Function fCarrega()
Local cQuery
    
    cStatus	:= ZE2->ZE2_STATUS
    
    If cStatus <> "A" 
	    cStatus	:= ZE2->ZE2_STATUS
		cNum 	:= ZE2->ZE2_NUM
		cItem	:= ZE2->ZE2_ITEM
		If !Empty(ZE2->ZE2_RESP)
			cResp	:= ZE2->ZE2_RESP
		Else
			cResp	:= UsrFullname(__cUserId )
		EndIf
		dDta	:= ZE2->ZE2_DATA
		nCusto	:= ZE2->ZE2_CUSTO
		cPlanta	:= ZE2->ZE2_PLANTA
		cHora	:= ZE2->ZE2_HORA
		dPrazo	:= ZE2->ZE2_PRAZO
		cSetor	:= ZE2->ZE2_SETOR
		
		If ZE6->(DbSeek(xFilial("ZE6")+cNum+cItem))
			While cNum+cItem == ZE6->ZE6_NUMMOD+AllTrim(ZE6->ZE6_ITEMMD)
				aAdd(aObs,{ZE6->ZE6_NUMMOD,ZE6->ZE6_ITEMMD,ZE6->ZE6_NUMOBS,ZE6->ZE6_OBS,ZE6->ZE6_DATA,ZE6->ZE6_HORA,ZE6->ZE6_RESP})
				ZE6->(DbSkip())
			EndDo
		EndIf
	
		If nPar==2			//TELA ENGENHARIA
		
			cQuery := "SELECT *"
			cQuery += " FROM "+RetSqlName("ZE2")
			cQuery += " WHERE 	ZE2_NUM 	=  '"+cNum+"'"
			cQuery += " AND 	ZE2_SETOR	<> 'ENGENHARIA'"
			cQuery += " AND		ZE2_PLANTA	= '"+AllTrim(cPlanta)+"'"
			
			cQuery += " AND		D_E_L_E_T_  = ''"
			cQuery += " AND		ZE2_FILIAL	= '"+xFilial("ZE2")+"'"
		   //FCV	MemoWrit("C:\TEMP\NHPPA008.SQL",cQuery)
		
		    TCQUERY cQuery NEW ALIAS "TMP1"	
		    
			While TMP1->ZE2_NUM == cNum
				If 	   AllTrim(TMP1->ZE2_SETOR) == "COMPRAS"
					lChq1 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "CONTROLADORIA"
					lChq2 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "MANUTENCAO'"
					lChq3 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "QUALIDADE"
					lChq4 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "PRESET"
					lChq5 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "INFORMATICA"
					lChq6 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "PRODUCAO"
					lChq7 := .T.
				ElseIf AllTrim(TMP1->ZE2_SETOR) == "LOGISTICA"
					lChq8 := .T.
				EndIf
				TMP1->(DbSkip())
			EndDo
			TMP1->(DbCloseArea())
	
		EndIf
	Else
		cStatus	:= ZE2->ZE2_STATUS
		cNum 	:= ZE2->ZE2_NUM
		cItem	:= ZE2->ZE2_ITEM
		cResp	:= UsrFullname(__cUserId )
		dDta	:= Date()
		cPlanta	:= ZE2->ZE2_PLANTA
		cHora	:= Time()
		cSetor	:= ZE2->ZE2_SETOR
		
		If ZE6->(DbSeek(xFilial("ZE6")+cNum+cItem))
			While ZE6->ZE6_NUMMOD+ZE6->ZE6_ITEMMD == cNum+cItem
			
				ZE6->(DbSkip())
			
			EndDo
		EndIf
	EndIf
	
	If cPlanta == "USINAGEM"
		cPla := 1
	ElseIf cPlanta == "FUNDICAO"
		cPla := 2
	ElseIf cPlanta == "FORJARIA"
		cPla := 3
	Else
		cPla := 4
	EndIf
		
		
Return

//-----------------------------------------------------------------------------------------------------\\
//---------------------------------VALIDAÇÃO-----------------------------------------------------------\\

Static Function fValOp()

If cStatus == "F"			//NÃO SE APLICA OU FINALIZADO
	Return .F.
EndIf

If cStatus == "N"
	Return .F.
EndIf

Return .T.

//-----------------------------------------------------------------------------------------------------\\
//-------------------------FUNÇÃO DE ENVIAR EMAILS-----------------------------------------------------\\

Static Function fEnviaEmail()
Local cMsg
Local nD := 0
Local xN := 1
Local xD
Private cTo2 := ""
	
	aMat := {}
	
    If ZE6->(DbSeek(xFilial("ZE6")+cNum+cItem))
    	While AllTrim(ZE6->ZE6_NUMMOD)+AllTrim(ZE6->ZE6_ITEMMD) == AllTrim(cNum)+AllTrim(cItem)
    		aAdd(aMat,{ZE6->ZE6_NUMMOD,ZE6->ZE6_ITEMMD,ZE6->ZE6_NUMOBS,ZE6->ZE6_OBS,ZE6->ZE6_DATA,ZE6->ZE6_HORA,ZE6->ZE6_RESP})
    		ZE6->(DbSkip())
    	EndDo
    EndIf
	
	oMail := Email():New()
	oMail:cAssunto := "*** ACOMPANHAMENTO ALTERAÇÃO Nº "+cNum+" ***"
	
	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="70%" border="1" cellpadding="3">'
	
	If ZE2->ZE2_STATUS == "N"
		cMsg += '<tr>'
		cMsg += '<td colspan="4" style="background:#ccc">'
		cMsg += '<CENTER><b>NÃO SE APLICA - '+AllTrim(Iif(nPar==2,"ENGENHARIA",cSetor))+'/'+cPlanta+' </b></CENTER>'
		cMsg += '</td>'
		cMsg += '</tr>'
	ElseIf ZE2->ZE2_STATUS == "F"
		cMsg += '<tr>'
		cMsg += '<td colspan="4" style="background:#ccc">'
		cMsg += '<CENTER><b>FINALIZADO - '+AllTrim(Iif(nPar==2,"ENGENHARIA",cSetor))+'/'+cPlanta+' </b></CENTER>'
		cMsg += '</td>'
		cMsg += '</tr>'
	Else
		cMsg += '<tr>'
		cMsg += '<td colspan="4" style="background:#ccc">'
		cMsg += '<CENTER><b>ACOMPANHAMENTO - '+AllTrim(Iif(nPar==2,"ENGENHARIA",cSetor))+'/'+cPlanta+' </b></CENTER>'
		cMsg += '</td>'
		cMsg += '</tr>'
	EndIf
	
	If ZE1->(DbSeek(xFilial("ZE1")+cNum))	
		cMsg += '<tr>'
		cMsg += '<td style="background:#abc">Produto</td>'
		cMsg += '<td>'+ZE1->ZE1_PROD+'</td>'
		cMsg += '<td style="background:#abc">Descrição</td>'
	
		If SB1->(DbSeek(xFilial("SB1")+ZE1->ZE1_PROD))
			cMsg += '<td>'+SB1->B1_DESC+'</td>'
		EndIf
	EndIf
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Cliente</td>'
	cMsg += '<td>'+ZE1->ZE1_CLI+'/'+ZE1->ZE1_LOJA+'</td>'
	cMsg += '<td style="background:#abc">Razão Social</td>'
	If SA1->(DbSeek(xFilial("SA1")+ZE1->ZE1_CLI+ZE1->ZE1_LOJA))
		cMsg += '<td>'+SA1->A1_NOME+'</td>'
	EndIf
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Responsavel</td>'
	cMsg += '<td>'+cResp+'</td>'
	cMsg += '<td style="background:#abc">Data</td>'
	cMsg += '<td>'+DtoC(dData)+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Prazo</td>'
	cMsg += '<td colspan="3">'+DtoC(dPrazo)+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Custo</td>'
	cMsg += '<td colspan="3">R$ '+AllTrim(Str(nCusto,10,2))+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Descricao</td>'
	cMsg += '<td colspan="3"><ul>'
	For xD:=1 to Len(aMat)
		cMsg += '<li>'+Upper(aMat[xD][4])+'</li>'
	Next
	
	cMsg += '</ul></td>'
	cMsg += '</tr>'
	
	If nPar == 2
		
		cMsg += '<tr>'
		cMsg += '<td colspan="4" style="background:#ccc"><center><b>SETORES</b></center></td>'
		cMsg += '</tr>'
		
		cMsg += '<tr>'
		cMsg += '<td colspan="2" style="background:#abc"><center>Planta</center></td>'
		cMsg += '<td colspan="2" style="background:#abc"><center>Setor</center></td>'
		cMsg += '</tr>'
		
		cQuery := "SELECT QAA_EMAIL"
		cQuery += " FROM "+RetSqlName("ZE5")+" ZE5, "+RetSqlName("QAA")+" QAA"
		cQuery += " WHERE ZE5_LOGIN = QAA_LOGIN "
		cQuery += " AND ZE5.D_E_L_E_T_ = ''"
		cQuery += " AND QAA.D_E_L_E_T_ = ''"
		cQuery += " AND ZE5_FILIAL = '"+xFilial("ZE5")+"'"
		cQuery += " AND QAA_FILIAL = '"+xFilial("QAA")+"'" 
		cQuery += " AND ZE5_PLANTA = "+Str(cPla,1)
		cQuery += " AND ZE5_SETOR IN ("
		
		While xN <= 9
			If &("lChq"+AllTrim(Str(xN,1))+" == .T.")
			    
				If nD <> 0
					cQuery += ", "
					nD++
				Else
					nD++
				Endif
			
				If xN == 1
					cQuery += "1"
					cSetor := "COMPRAS"
				ElseIf xN == 2
					cQuery += "2"
					cSetor := "CONTROLADORIA"
				ElseIf xN == 3
					cQuery += "3"
					cSetor := "MANUTENCAO"
				ElseIf xN == 4
					cQuery += "4"
					cSetor := "QUALIDADE"
				ElseIf xN == 5
					cQuery += "5"
					cSetor := "PRE-SET"
				ElseIf xN == 6
					cQuery += "6"
					cSetor := "INFORMATICA"
				ElseIf xN == 7
					cQuery += "7"
					cSetor := "PRODUCAO"
				ElseIf xN == 8
					cQuery += "8"
					cSetor := "LOGISTICA"
				EndIf
				
				cMsg += '<tr>'
				cMsg += '<td colspan="2">'+cPlanta+'</td>'
				cMsg += '<td colspan="2">'+cSetor+'</td>'
				cMsg += '</tr>'
			EndIf	
			xN++
		EndDo
		
		cQuery += ")"
	EndIf
			
	TCQUERY cQuery NEW ALIAS "TMP1"

	cMsg += '</table><br />'

	If nPar == 2

		TMP1->(DbGoTop())
		While TMP1->(!EoF())		//ADICIONANDO LISTA DE DISTRIBUIÇÃO
			cTo += TMP1->QAA_EMAIL+"; "			
			TMP1->(DbSkip())
		EndDo
	
	Else
	
		fCarEmail()				//carrega emails para distribuição quando algum setor relacionado faz uma alteração.

	EndIf

    cMsg += '<br/>'
	cMsg += '</body>'
	cMsg += '</html>'
	oMail:cTo := cTo	
	oMail:cMsg := cMsg
	
	oMail:Envia()
	
	TMP1->(DbCloseArea())
	
Return

//-----------------------------------------------------------------------------------------------------\\
//--------------------------FUNÇÃO DE CARREGAR ENDEREÇOS PARA ENVIO DE EMAIL---------------------------\\

Static Function fCarEmail()
Local cQuery
Local cQuery2
Local nD := 0
	
	cQuery2 := "SELECT ZE2_SETOR"
	cQuery2 += " FROM "+RetSqlName("ZE2")+" ZE2"
	cQuery2 += " WHERE ZE2_PLANTA = '"+cPlanta+"'"
	cQuery2 += " AND ZE2_NUM = '"+cNum+"'"
	cQuery2 += " AND D_E_L_E_T_ = ''"
	cQuery2 += " AND ZE2_FILIAL = '"+xFilial("ZE2")+"'"
	
	//MemoWrit("C:\TEMP\NHPPA0081.SQL",cQuery2)
	TCQUERY cQuery2 NEW ALIAS "TMP1"
	
	If AllTrim(cPlanta) == "USINAGEM"
		cPla := 1
	ElseIf AllTrim(cPlanta) == "FUNDICAO"
		cPla := 2
	ElseIf AllTrim(cPlanta) == "FORJARIA"
		cPla := 3
	ElseIf AllTrim(cPlanta) == "VIRABREQUIM"
		cPla := 4
	EndIf
	
	cQuery := "SELECT QAA_EMAIL"
	cQuery += " FROM "+RetSqlName("ZE5")+" ZE5, "+RetSqlName("QAA")+" QAA"
	cQuery += " WHERE	ZE5_PLANTA 	= '"+Str(cPla,1)+"'"
	cQuery += " AND		ZE5_LOGIN	= QAA_LOGIN"
	cQuery += " AND		ZE5.D_E_L_E_T_	= ''"
	cQuery += " AND		QAA.D_E_L_E_T_	= ''"
	cQuery += " AND 	ZE5_FILIAL = '"+xFilial("ZE5")+"'"
	cQuery += " AND		QAA_FILIAL = '"+xFilial("QAA")+"'"
	
	cQuery += " AND		ZE5_SETOR IN ("
	
	While TMP1->(!EoF())
		
		If nD > 0
			cQuery += ","
		Else
			nD++
		EndIf
		
		If AllTrim(TMP1->ZE2_SETOR) == "COMPRAS"
			cQuery += "1"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "CONTROLADORIA"
			cQuery += "2"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "MANUTENCAO"
			cQuery += "3"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "QUALIDADE"
			cQuery += "4"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "PRESET"
			cQuery += "5"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "INFORMATICA"
			cQuery += "6"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "PRODUCAO"
			cQuery += "7"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "LOGISTICA"
			cQuery += "8"
		ElseIf AllTrim(TMP1->ZE2_SETOR) == "ENGENHARIA"
			cQuery += "9"
		EndIf
		
		TMP1->(DbSkip())
		
	EndDo
	
	cQuery += ")"
	//MemoWrit('C:\TEMP\NHPPA0082.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP2"
	
	cTo2 := ""
	While TMP2->(!EoF())
		cTo2 += TMP2->QAA_EMAIL+"; "	
		TMP2->(DbSkip())
	EndDo

	TMP2->(DbCloseArea())
Return

//-----------------------------------------------------------------------------------------------------\\
//------------------------------FUNÇÃO DE ALIMENTAR MULTILINE DE OBSERVAÇAO----------------------------\\

Static Function fAddOBS(nPara,cPos)
Local cNuItem := cNum+"/"+cItem
Local cQuery
    
    If nPara == 1
		cHora := SubStr(Time(),1,5)
		dData := Date()
	
		If len(aObs) > 0
		
			For _x:=1 to len(aObs)
			
				cObsNum := aObs[_x][3]
			
			Next
		
		Else
		
			cQuery := "SELECT MAX(ZE6_NUMOBS) MAX"
			cQuery += " FROM "+RetSqlName("ZE6")+" ZE6"
			cQuery += " WHERE ZE6_NUMMOD = '"+cNum+"'"
			cQuery += " AND ZE6_ITEMMD = '"+cItem+"'"
			MemoWrit('c:\TEMP\NHPPA00008.SQL',cQuery)
			TCQUERY cQuery NEW ALIAS "TMP1"
			
			TMP1->(DbGoTop())
			
			cObsNum := TMP1->MAX
			
			TMP1->(DbCloseArea())
		
		EndIf
		
		cObsNum := StrZero(++Val(cObsNum),3)
	Else	
		
		cQuery := "SELECT TOP 1 *" 
		cQuery += " FROM "+RetSqlName("ZE6")+" ZE6"
		cQuery += " WHERE ZE6_NUMMOD = '"+cNum+"'"
		cQuery += " AND ZE6_ITEMMD = '"+cItem+"'"
		cQuery += " AND ZE6_NUMOBS = '"+aMat[cPos][1]+"'"
		cQuery += " AND D_E_L_E_T_ = ''"
		cQuery += " AND ZE6_FILIAL = '"+xFilial("ZE6")+"'"
		
		TCQUERY cQuery NEW ALIAS "TMP1"
		
		cObs	:= TMP1->ZE6_OBS
		dData	:= StoD(TMP1->ZE6_DATA)
		cHora	:= TMP1->ZE6_HORA
		If !Empty(TMP1->ZE6_RESP)
			cResp	:= TMP1->ZE6_RESP
		Else
			cResp	:= UsrFullname(__cUserId )
		EndIf
		cObsNum := TMP1->ZE6_NUMOBS
		
		TMP1->(DbCloseArea())

	EndIf

	Define MsDialog oDlgObs From 0,0 To 240,465 Pixel Title "ADICIONAR OBSERVAÇÃO"
//	      LIN,COL
	    @ 010,010 Say "Numero/Item"		Size 035,08 Object oNumIte
	    @ 008,045 Get cNuItem			When .F. Size 050,08 Object oNumm
	    @ 010,100 Say "OBS Numero"		Size 040,08 Object oObsNum
	    @ 008,130 Get cObsNum			When .F. Size 020,08 Object oObsNum
	    @ 025,010 Say "Responsável"		Size 035,08 Object oRespo
	    @ 023,045 Get cResp				When .F. Size 040,08 Object oRespon
	    @ 025,090 Say "Data"			Size 030,08 Object oDatas
	    @ 023,105 Get dData				When .F. Size 038,08 Object oData
	    @ 025,150 Say "Hora"			Size 030,08 Object oHoras
	    @ 023,165 Get cHora				When .F. Size 020,08 Object oHora
	    @ 035,010 Say "Observação"		Size 030,08 Object oDscObs
	    @ 043,010 Get cObs	MEMO		When nPara==1 Size 210,060 Of oDlgObs Pixel HSCROLL
	    
	    If nPara==1
			@ 105,010 BMPButton Type 01 Action GravaOBS()
		EndIf
		@ 105,040 BMPButton Type 02 Action fCancelObs()
		
	Activate MsDialog oDlgObs Center

Return

Static function fCancelObs()
//	OLBX:BLINE := {|| {} }
	oDlgObs:End()
Return

//-----------------------------------------------------------------------------------------------------\\
//------------------------------FUNÇÃO DE GRAVAR MULTILINE DE OBSERVAÇAO-------------------------------\\

Static Function GravaOBS()
    
	If Empty(cObs)
	
		Alert("Digite uma Observação!")
		Return .F.
		
	EndIf

	aAdd(aObs,{cNum,cItem,cObsNum,cObs,dData,cHora,cResp})			//adicionando na matriz de observações
	
	cObs  := ""
	 
	fCarrList()
	 
	oDlgObs:End()
	
Return

//-----------------------------------------------------------------------------------------------------\\
//-------------------------------CARREGANDO LISTBOX----------------------------------------------------\\

Static Function fCarrList()
Local cQuery
Local xD

	If len(aObs) > 0
		For xD:=1 to len(aObs)
			If aScan(aMat,{|x| x[1]==aObs[xD][3] }) == 0
				aAdd(aMat,{aObs[xD][3],aObs[xD][5],aObs[xD][6],aObs[xD][7]})
			EndIf
		Next
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE O ARRAY ESTÁ VAZIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAEmpty(aArray)
	For _x := 1 to Len(aArray)
		If !Empty(aArray[1][_x])
			Return .F. //array não vazio
		EndIf
	Next
Return .T. //array vazio


                                                                                                         
Static Function fVerifObs()
Local xD

	aMat := {}

	If ZE6->(DbSeek(xFilial("ZE6")+cNum+cItem))
		For xD:=1 to len(aObs)
			If ZE6->ZE6_NUMOBS <> aObs[xD][3]
				aAdd(aMat,{aObs[xD][1],aObs[xD][2],aObs[xD][3],aObs[xD][4],aObs[xD][5],aObs[xD][6],aObs[xD][7]})
			EndIf
		Next
	Else
		For xD:=1 to len(aObs)
			aAdd(aMat,{aObs[xD][1],aObs[xD][2],aObs[xD][3],aObs[xD][4],aObs[xD][5],aObs[xD][6],aObs[xD][7]})
		Next
	EndIf
	
	aObs := aClone(aMat)
	
Return .T.
