
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

Private cStatus := ""

Private dDta    := Date()
Private dPrazo  := Date()
Private dData   := Date()
Private cHora   := Time()
Private obt1
Private obt2
Private obt3
Private obt4

Private cMemo2  := Space(350)

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

Return

//--------------------------------------------------------------------------------------------------------------\\

	//**********************************************\\
	//******TELA DE ACOMPANHAMENTO DOS SETORES******\\
	//**********************************************\\

Static Function fAcompanha()


	Define MsDialog oDlgAc From 0,0 To 310,460 Pixel Title "ACOMPANHAMENTO - "+AllTrim(cSetor)+" - "+cPlanta
//	      LIN,COL
		@ 012,010 Say "Número"		 Size 35,8 Object oNm
		@ 012,035 Say SubStr(cNum,2,5)+"/"+SubStr(cItem,2,3)				Size 45,8 Object oNum
	   
		@ 012,065 Say "Responsável"	 Color CLR_HBLUE				  		Size 45,08 Object oRes
		@ 010,100 Get cResp			 Picture "@!" 		 	 When .F. 		Size 55,08 Object oResp
	   
		@ 012,165 Say "Data" 		 								  		Size 35,08 Object oDta
		@ 010,180 Get dDta			 Picture "99/99/9999" 	 When .F. 		Size 40,08 Object oData
	   
		@ 030,010 Say "Custo"		 						 		  		Size 35,08 Object oCus
		@ 028,035 Get nCusto		 Picture "@e 999,999.99" When fValOp() 	Size 45,08 Object oCusto
		
		@ 030,090 Say "Planta"		 								  		Size 20,08 Object oPla
		@ 028,110 Get cPlanta	 	 Picture "@!"			 When .F. 		Size 35,08 Object oPlan
				
		@ 030,165 Say "Hora"		 Color CLR_HBLUE				  		Size 45,08 Object oHr
		@ 028,180 Get cHora			 Picture "99:99"		 When .F. 		Size 20,08 Object oHora
		
		@ 048,010 Say "Prazo"		 Color CLR_HBLUE				  		Size 35,08 Object oPra
		@ 046,035 Get dPrazo		 Picture "99/99/9999" 	 When fValOp() 	Size 45,08 Object oPrazo
	
		@ 066,010 Say "Descrição"											 Size 35,08 Object oDescr
		@ 074,010 GET cMemo2	MEMO When fValOp() Size 210,60 Of oDlgAc Pixel HSCROLL
		
		@ 140,010 BMPButton Type 01 Action GravaAcomp(1)
		@ 140,040 BMPButton Type 02 Action oDlgAc:End()
		@ 140,145 Button "Finalizar" 	 Size 30,11 Action fFinal(1) Object obt1
		@ 140,180 Button "Não se Aplica" Size 40,11 Action fNApl(1) Object obt2
		
		If cStatus == "F" .OR. cStatus == "N"
			obt1:Disable()
			obt2:Disable()
		EndIf
		
	Activate MsDialog oDlgAc Center 

Return

//--------------------------------------------------------------------------------------------------------------\\

	//************************************************\\
	//******TELA DE ACOMPANHAMENTO DA ENGENHARIA******\\
	//************************************************\\

Static Function fEngenharia()

	Define MsDialog oDlgEn From 0,0 To 450,460 Pixel Title "ACOMPANHAMENTO - ENGENHARIA - "+cPlanta
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
		
		@ 066,010 Say "Descrição"		Size 35,08 Object oDescr
		@ 074,010 GET cMemo2	MEMO	When fValOp() Size 210,60 Of oDlgEn Pixel HSCROLL
		
		//-----------------------------------------------------------------------------------------------------\\
		
		@ 140,010 To 197,220 LABEL "Setores" Of oDlgEn Pixel
		
		@ 154,030 CheckBox oChq1 		Var lChq1 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 155,040 Say "Compras" 		Object oCh1
		
		@ 154,095 CheckBox oChq2 		Var lChq2 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 155,105 Say "Controladoria" 	Object oCh2
		
		@ 154,160 CheckBox oChq3 		Var lChq3 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 155,170 Say "Manutenção"		Object oCh3
		
		@ 168,030 CheckBox oChq4 		Var lChq4 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 169,040 Say "Qualidade" 		Object oCh4
		
		@ 168,095 CheckBox oChq5 		Var lChq5 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 169,105 Say "PRESET"			Object oCh5
		
		@ 168,160 CheckBox oChq6 		Var lChq6 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 169,170 Say "Informática" 	Object oCh6
		
		@ 182,030 CheckBox oChq7 		Var lChq7 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 183,040 Say "Produção" 		Object oCh7
		
		@ 182,095 CheckBox oChq8 		Var lChq8 Prompt "" When fValOp() Size 040,08 Pixel Of oDlgEn
		@ 183,105 Say "Logística"  		Object oCh8
		
		@ 210,010 BMPButton Type 01 Action GravaAcomp(2)
		@ 210,040 BMPButton Type 02 Action oDlgEn:End()
		@ 210,145 Button "Finalizar" 	 Size 030,11	Action fFinal(2) Object obt3
		@ 210,180 Button "Não se Aplica" Size 040,11	Action fNApl(2) Object obt4
		
		If cStatus == "F" .OR. cStatus == "N"
			obt3:Disable()
			obt4:Disable()
		EndIf
		
	Activate MsDialog oDlgEn Center
	
Return

//-----------------------------------------------------------------------------------------------------\\

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
	    		Return .F.	    
	    	EndIf
	    	TMP1->(DbSkip())
	    EndDo
	    
	    TMP1->(DbCloseArea())		
	
	EndIf
	
    If MsgBox("Tem Certeza?","Finalizar","YESNO")
    	If Empty(cMemo2)
    		Alert("Digite uma observação!")
    		Return .F.
    	EndIf
		RecLock("ZE2",.F.)
			ZE2->ZE2_STATUS := "F"		   		//STATUS: FINALIZADO
			ZE2->ZE2_CUSTO	:= nCusto
			ZE2->ZE2_RESP	:= cResp
			ZE2->ZE2_DATA	:= dData
			ZE2->ZE2_HORA	:= cHora
			ZE2->ZE2_DESC	:= Upper(cMemo2)
		MsUnlock("ZE2")
		If nX == 1
			oDlgAc:End()
		Else
			oDlgEn:End()
		EndIf
	EndIf
	
Return

//-----------------------------------------------------------------------------------------------------\\

//BOTAO NÃO SE APLICA

Static Function fNApl(nX)
Local cQuery
	
	If MsgBox("Tem Certeza?","Não se Aplica","YESNO")
		If Empty(cMemo2)
    		Alert("Digite uma observação!")
    		Return .F.
    	EndIf
		RecLock("ZE2",.F.)
			ZE2->ZE2_STATUS := "N"				//STATUS: NAO SE APLICA
			ZE2->ZE2_RESP	:= cResp
			ZE2->ZE2_DATA	:= dData
			ZE2->ZE2_HORA	:= cHora
			ZE2->ZE2_DESC	:= Upper(cMemo2)
		MsUnlock("ZE2")
		If nX == 1
			oDlgAc:End()
		Else
			oDlgEn:End()
		EndIf
	EndIf
		
Return

//-----------------------------------------------------------------------------------------------------\\

	//*********************************\\
	//********GRAVANDO OS DADOS********\\
	//*********************************\\

Static Function GravaAcomp(xD)
Local xN := 1
Local cPlanta := ZE2->ZE2_PLANTA
Private nItem := fProcItem(ZE2->ZE2_NUM)

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
		ZE2->ZE2_DESC	:= Upper(cMemo2)
	MsUnlock("ZE2")
	
	If xD == 2
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
			xN++
		EndDo
		oDlgEn:End()
	Else
		oDlgAc:End()
	EndIf
		
Return

//-----------------------------------------------------------------------------------------------------\\

Static Function fProcItem(nNum)
Local nIt
Local cQuery
	
	cQuery := "SELECT MAX(ZE2_ITEM) NUM"
	cQuery += " FROM "+RetSqlName("ZE2")
	cQuery += " WHERE ZE2_NUM = '"+nNum+"'"
	cQuery += " AND D_E_L_E_T_ = ''"
	cQuery += " AND ZE2_FILIAL = '"+xFilial("ZE2")+"'"
	
	TCQUERY cQuery NEW ALIAS "TMP1"

	nIt := Val(TMP1->NUM) + 1
	
	TMP1->(DbCloseArea())
		
Return nIt

//-----------------------------------------------------------------------------------------------------\\

Static Function fCarrega()
Local cQuery
    
    cStatus	:= ZE2->ZE2_STATUS
    
    If cStatus <> "A" 
	    cStatus	:= ZE2->ZE2_STATUS
		cNum 	:= ZE2->ZE2_NUM
		cItem	:= ZE2->ZE2_ITEM
		cResp	:= ZE2->ZE2_RESP
		dDta	:= ZE2->ZE2_DATA
		nCusto	:= ZE2->ZE2_CUSTO
		cPlanta	:= ZE2->ZE2_PLANTA
		cHora	:= ZE2->ZE2_HORA
		dPrazo	:= ZE2->ZE2_PRAZO
		cMemo2	:= ZE2->ZE2_DESC
		cSetor	:= ZE2->ZE2_SETOR
	
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
		cStatus	:= ZE2->ZE2_STATUS
		cSetor	:= ZE2->ZE2_SETOR
	EndIf
		
		
Return

Static Function fValOp()

If cStatus == "F"			//NÃO SE APLICA OU FINALIZADO
	Return .F.
EndIf

If cStatus == "N"
	Return .F.
EndIf

Return .T.