
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAFICO    บAutor ณJoใo Felipe da Rosa บ Data ณ  28/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "msobjects.ch"
#INCLUDE "PROTHEUS.CH"
#include "MSGRAPHI.CH"

Class Grafico

	VAR aMat as Array //matriz contendo arrays do tipo {{"titulo da serie",valor}}
	VAR nSerie as Numeric //qual a serie ex.:(1=linha,2=area,3=pontos,4=barras)
	VAR cTitulo as Character //titulo a ser exibido no topo do grafico
	VAR cTit1 as Character //titulo auxiliar exibido no rodape do grafico
	VAR cTit2 as Character //mais um titulo auxiliar exibido no rodape do grafico
	VAR nEspaco as Numeric //espacamento entre as series (colunas), default = 40
	Method New() Constructor
	Method Show() //mostra o grafico na tela
	Method MontaGraf() //atualiza o grafico com uma nova serie

EndClass
      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CONSTRUTOR ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
Method New() Class Grafico
	::nEspaco := 40
	::nSerie  := 1
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ EXECUTA O GRAFICO MOSTRANDO NA TELA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method Show() Class Grafico
Local oBold
Local nX 		 := 0
Local cCbx       := "Linha"
Local cTo 		 := ""
Local cCC 		 := ""
Local aCbx       := { "Linha","มrea","Pontos","Barras","Piramid","Cilindro",;
				      "Barras Horizontal","Piramid Horizontal","Cilindro Horizontal",;
				      "Pizza","Forma","Linha rแpida","Flexas","GANTT","Bolha"}
Private aMat     := ::aMat
Private oDlg
Private oGraphic
Private aSize    := MsAdvSize()
Private nSerie   := 0
Private aTabela  := {{"tit 1", "tit 2",}}

For nX := 1 To Len(aMat)
	Aadd(aTabela,{ aMat[nX,1], aMat[nX,2] })
Next

DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] PIXEL TITLE ::cTitulo
                                                 	
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

// Layout da janela
@ 003, 005 SAY ::cTitulo FONT oBold PIXEL 

@ 014, 05 TO 16 ,(aSize[5]/2)-5 LABEL '' OF oDlg  PIXEL

oSBox := TScrollBox():New(oDlg,020,005,200, (aSize[5]/2)-10,.T.,.T.,.T.)

::MontaGraf(::nSerie) // Monta o grafico

@ 225, (aSize[5]/2)-45  BUTTON "&Salva BMP"      SIZE 40,14 OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) //"&Salva BMP"
@ 225, (aSize[5]/2)-90  BUTTON o3D PROMPT "&2D"  SIZE 40,14 OF oDlg PIXEL ACTION (oGraphic:l3D := !oGraphic:l3D, o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D"))
@ 225, (aSize[5]/2)-135 BUTTON "Rota็ใo &-"      SIZE 40,14 OF oDlg WHEN oGraphic:l3D PIXEL ACTION oGraphic:ChgRotat( nSerie, 1, .T. ) // nRotation tem que estar entre 1 e 30 passos //"Rota็ใo &-"
@ 225, (aSize[5]/2)-180 BUTTON "Rota็ใo &+"      SIZE 40,14 OF oDlg WHEN oGraphic:l3D PIXEL ACTION oGraphic:ChgRotat( nSerie, 1, .F. ) // nRotation tem que estar entre 1 e 30 passos //"Rota็ใo &+"
@ 225, (aSize[5]/2)-225 BUTTON "S&howAxis"       SIZE 40,14 OF oDlg PIXEL ACTION oGraphic:lAxisVisib := !oGraphic:lAxisVisib
@ 218, (aSize[5]/2)-285 TO 242 ,(aSize[5]/2)-230 LABEL 'Zoom' OF oDlg  PIXEL
@ 225, (aSize[5]/2)-280 BUTTON "&In"             SIZE 20,14 OF oDlg PIXEL ACTION oGraphic:ZoomIn()
@ 225, (aSize[5]/2)-255 BUTTON "&Out"            SIZE 20,14 OF oDlg PIXEL ACTION oGraphic:ZoomOut()
@ 225, (aSize[5]/2)-365 MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 075, 120 OF oDlg PIXEL ON CHANGE Eval({||oGraphic:End(), ::MontaGraf(oSer:nAt)})

//@ 202, 050 TO 204 ,400 LABEL '' OF oDlg  PIXEL

If !__lPyme
	@ 244, (aSize[5]/2)-90 BUTTON "&Email" SIZE 40,14 OF oDlg PIXEL ACTION PmsGrafMail(oGraphic,"Fluxo",{"Fluxo" + "Campo3"},cTo,cCC,aTabela,1) // E-Mail
Endif       

@ 244, (aSize[5]/2)-45 BUTTON "&Sair" SIZE 40,14 OF oDlg PIXEL ACTION oDlg:End() //"&Sair"

ACTIVATE MSDIALOG oDlg

Return Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ MONTA O GRAFICO PARA EXIBICAO NA TELA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method MontaGraf(nCbx) Class Grafico

	nTam := 0
	
	For x:=1 to Len(aMat)
		nTam += ::nEspaco
	Next
	
	If nTam < ((aSize[5]/2)-50)
		nTam := ((aSize[5]/2)-50)
	EndIf

	@ 0,0 MSGRAPHIC oGraphic SIZE nTam, 200 OF oSBox PIXEL NOBORDER 

	oGraphic:SetMargins(50,0,0,0)
//	oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posi็ใo x,y em rela็ใo a Dialog 

	MENU oMenu POPUP
		MENUITEM "Consulta dados do grafico" Action ConsDadGraf(aTabela) //"Consulta dados do grafico"
	ENDMENU

	// Habilita a legenda
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
	nSerie  := oGraphic:CreateSerie(nCbx)
	
	If nSerie != GRP_CREATE_ERR
		aEval(aMat,{|e| oGraphic:Add(nSerie ,ROUND(e[2],2),Transform(e[1],"@!"),CLR_HBLUE)})
	Else
		IW_MSGBOX("Nใo foi possํvel criar a s้rie.","Nใo foi possํvel criar a s้rie.","STOP") //"Nใo foi possํvel criar a s้rie."
	Endif
                             
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
	oGraphic:SetTitle( ::cTit1,::cTit2, CLR_HRED , A_LEFTJUST , GRP_TITLE )
	oGraphic:SetTitle( "", ::cTitulo, CLR_GREEN, A_RIGHTJUS , GRP_FOOT  ) //"Datas"
	
Return