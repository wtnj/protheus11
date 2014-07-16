
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMS006 Autor: José Henrique M Felipetto Data ³  08/09/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Código de barras lidos Carcaça Dianteira					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"

User Function NHWMS006()
Private oDlg , oSay1 , oGet1 , cProd := space(50)

oDlg  := MsDialog():New(0,0,050,350,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1 := TSay():New(08,10,{||"Codigo:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet1 := tGet():New(06,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlg,60,8,"@!",{|| .T. },;
					,,,,,.T.,,,{|| .T. },,,,,,,"cProd")

oBtnParam := tButton():New(06,115,"Gravar",oDlg,{|| fGrava(cProd) } ,60,10,,,,.T.)
oDlg:Activate(,,,.t.,{||.T.},,)
Return

Static Function fGrava(Codigo)

If Empty(Codigo)
	alert("Campo código deve ser preechido!")
	Return .F.
EndIf

RecLock("ZEX",.T.)
	ZEX->ZEX_FILIAL := xFilial("ZEX")
	ZEX->ZEX_COD  	:= Codigo
	ZEX->ZEX_DATA 	:= Date()
	ZEX->ZEX_USER 	:= Alltrim(Upper(cUserName))
MsUnLock("ZEX")

cProd := space(50)	
oDlg:Refresh()
oGet1:SetFocus()
Return