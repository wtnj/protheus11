#INCLUDE "TBICONN.CH"
Function FG_TROCAOR
Local oDlg,oSay1,oSay2,oGet3,oGet4,oSBtn1,oSBtn2,oSay5,oSay6,oGet7,oGet8
Local nOpca := 0
Private cDesGrupo := "Cod. Grupo  "
Private cDesItem  := "Cod. Produto"
Private cEmpOpen  := "99"
Private cFilOpen  := "01"

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Troca ordem"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 178
oDlg:nHeight := 180
oDlg:lCentered := .T.

oSay1 := TSAY():Create(oDlg)
oSay1:cName := "oSay1"
oSay1:cCaption := "Grupo.:"
oSay1:nLeft := 5
oSay1:nTop := 10
oSay1:nWidth := 35
oSay1:nHeight := 17
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Item..:"
oSay2:nLeft := 5
oSay2:nTop := 40
oSay2:nWidth := 35
oSay2:nHeight := 17
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oGet3 := TGET():Create(oDlg)
oGet3:cName := "oGet3"
oGet3:cCaption := "oGet3"
oGet3:nLeft := 45
oGet3:nTop := 10
oGet3:nWidth := 115
oGet3:nHeight := 21
oGet3:lReadOnly := .F.
oGet3:Align := 0
oGet3:cVariable := "cDesGrupo"
oGet3:bSetGet := {|u| If(PCount()>0,cDesGrupo:=u,cDesGrupo) }
oGet3:lVisibleControl := .T.
oGet3:lPassword := .F.
oGet3:lHasButton := .F.

oGet4 := TGET():Create(oDlg)
oGet4:cName := "oGet4"
oGet4:cCaption := "oGet4"
oGet4:nLeft := 45
oGet4:nTop := 40
oGet4:nWidth := 115
oGet4:nHeight := 21
oGet4:lReadOnly := .F.
oGet4:Align := 0
oGet4:cVariable := "cDesItem"
oGet4:bSetGet := {|u| If(PCount()>0,cDesItem:=u,cDesItem) }
oGet4:lVisibleControl := .T.
oGet4:lPassword := .F.
oGet4:lHasButton := .F.

oSay5 := TSAY():Create(oDlg)
oSay5:cName := "oSay5"
oSay5:cCaption := "Empresa.:"
oSay5:nLeft := 5
oSay5:nTop := 70
oSay5:nWidth := 50
oSay5:nHeight := 17
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.

oSay6 := TSAY():Create(oDlg)
oSay6:cName := "oSay6"
oSay6:cCaption := "Filial.:"
oSay6:nLeft := 5
oSay6:nTop := 100
oSay6:nWidth := 50
oSay6:nHeight := 17
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .F.

oGet7 := TGET():Create(oDlg)
oGet7:cName := "oGet7"
oGet7:cCaption := "oGet7"
oGet7:nLeft := 60
oGet7:nTop := 70
oGet7:nWidth := 115
oGet7:nHeight := 21
oGet7:lReadOnly := .F.
oGet7:Align := 0
oGet7:cVariable := "cEmpOpen"
oGet7:bSetGet := {|u| If(PCount()>0,cEmpOpen:=u,cEmpOpen) }
oGet7:lVisibleControl := .T.
oGet7:lPassword := .F.
oGet7:lHasButton := .F.

oGet8 := TGET():Create(oDlg)
oGet8:cName := "oGet8"
oGet8:cCaption := "oGet8"
oGet8:nLeft := 60
oGet8:nTop := 100
oGet8:nWidth := 115
oGet8:nHeight := 21
oGet8:lReadOnly := .F.
oGet8:Align := 0
oGet8:cVariable := "cFilOpen"
oGet8:bSetGet := {|u| If(PCount()>0,cFilOpen:=u,cFilOpen) }
oGet8:lVisibleControl := .T.
oGet8:lPassword := .F.
oGet8:lHasButton := .F.

oSBtn1 := SBUTTON():Create(oDlg)
oSBtn1:cName := "oSBtn1"
oSBtn1:cCaption := "oSBtn1"
oSBtn1:nLeft := 55
oSBtn1:nTop := 125
oSBtn1:nWidth := 52
oSBtn1:nHeight := 22
oSBtn1:lReadOnly := .F.
oSBtn1:Align := 0
oSBtn1:lVisibleControl := .T.
oSBtn1:nType := 1
oSBtn1:bAction := {|| nOpca:= 1,oDlg:End() }

oSBtn2 := SBUTTON():Create(oDlg)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "oSBtn2"
oSBtn2:nLeft := 113
oSBtn2:nTop := 125
oSBtn2:nWidth := 52
oSBtn2:nHeight := 22
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 2
oSBtn2:bAction := {|| nOpca:= 0,oDlg:End() }


oDlg:Activate()

If nOpca == 1
	Processa({ || FG_TRG1() })
EndIf
Return

Function FG_TRG1()
Local cOrdem
Local cIte,cGrp
Local aCampos:= {"A5_PRODUTO","A7_PRODUTO","B2_COD","B3_COD","B5_COD","B7_COD",;
		           "B8_PRODUTO","B9_COD","C0_PRODUTO","C1_PRODUTO","C7_PRODUTO",;
       		     "C8_PRODUTO","C9_PRODUTO","D1_COD","D2_COD","D3_COD",;
            	  "D5_PRODUTO","D7_PRODUTO","L2_PRODUTO","L3_PRODUTO","DF_PRODUTO"}

If Select("SX3") == 0
	PREPARE ENVIRONMENT EMPRESA cEmpOpen FILIAL cFilOpen  MODULO "CFG"
EndIf
DbSelectArea("SX3")
DbSetOrder(2)
ProcRegua(Len(aCampos)+1)
For nX:=1 to Len(aCampos)
	IncProc("Atualizando "+aCampos[nX])
   If DbSeek(aCampos[nX])

	   cOrdem:=SX3->X3_ORDEM
		RecLock("SX3",.F.)
		X3_ORDEM:="ZZ"
		MsUnlock()
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Codigo Aux. 1              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If DbSeek(Left(aCampos[nX],3)+"CODGRP")
			If SX3->X3_ORDEM > cOrdem
				RecLock("SX3",.F.)
				X3_ORDEM:=cOrdem
   		   X3_TITULO:=cDesGrupo
	      	X3_USADO :="€€€€€€€€€€€€€€ "
				MsUnlock()
			EndIf
      EndIf
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Codigo Aux. 2              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If DbSeek(Left(aCampos[nX],3)+"CODITE")
			If SX3->X3_ORDEM > cOrdem
				RecLock("SX3",.F.)
				X3_ORDEM:=cOrdem 
	      	X3_TITULO:=cDesItem
		      X3_USADO :="€€€€€€€€€€€€€€ "
				MsUnlock()
			EndIf				
		EndIf
	EndIf
Next

IncProc("Atualizando SB1")
DbSeek("B1_CODITE")
cIte:=SX3->X3_ORDEM
DbSeek("B1_GRUPO")
cGrp:=SX3->X3_ORDEM
If cIte < cGrp
	DbSeek("B1_CODITE")
	RecLock("SX3",.F.)
	SX3->X3_ORDEM := cGrp

	DbSeek("B1_GRUPO")
	RecLock("SX3",.F.)
	SX3->X3_ORDEM := cIte
	MsUnlock()
EndIf

MsgAlert("Processo finalizado com sucesso","Atenção")

Return