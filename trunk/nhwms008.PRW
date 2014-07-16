/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMS008 Autor:José Henrique M Felipetto   Data:12/12/12      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch" 
#INCLUDE "PROTHEUS.CH"

User Function NHWMS008()
Private _cProd,_cLote
getOp()
Return

Static Function getOp()
lOp := .T.
_cOp := Space(Len(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN))
oDlgOp  := MsDialog():New(0,0,50,400,"Digite a OP:",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"OP:"},oDlgOp,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,30,{|u| if(Pcount() > 0, _cOp := u,_cOp)},oDlgOp,60,8,"@!",{||OpValid()},;
					,,,,,.T.,,,{|| .T. },,,,,,"SC2","_cOp")

	oBtnPec := tButton():New(06,110,"Avançar",oDlgOp,{||getPar(_cProd)} ,60,10,,,,.T.)
oDlgOp:Activate(,,,.t.,{||.T.},,)
Return

Static Function getPar(cProd) 
_cSerie := Space(Len(SD1->D1_SERIE))
Private _nQuant := 0

oDlgParam  := MsDialog():New(0,0,250,280,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Op:"},oDlgParam,,,,,,.T.,,)
	oGet1 := tGet():New(06,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .F. },,,,,,,"cProd")

	oSay2 := TSay():New(28,10,{||"Quantidade:"},oDlgParam,,,,,,.T.,,)
	oGet2 := tGet():New(26,50,{|u| if(Pcount() > 0, _nQuant := u,_nQuant)},oDlgParam,60,8,"99999",{||fValQtde(_nQuant)},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQuant")

	oSay4 := TSay():New(48,10,{||"Lote:"},oDlgParam,,,,,,.T.,,)
	oGet4 := tGet():New(46,50,{|u| if(Pcount() > 0, _cLote := u,_cLote)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_cLote")
					
	oBtnParam := tButton():New(108,50,"Avançar",oDlgParam,{||fImpLocal()} ,60,10,,,,.T.)
oDlgParam:Activate(,,,.t.,{||.T.},,)

Return

Static Function fImpLocal()
_cLocal   := CB5->CB5_CODIGO

oDlgLocal  := MsDialog():New(0,0,50,400,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Local:"},oDlgLocal,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,30,{|u| if(Pcount() > 0, _cLocal := u,_cLocal)},oDlgLocal,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"CB5","_cLocal")

	oBtnLocal := tButton():New(06,110,"Avançar",oDlgLocal,{|| Processa({|| doBarCod() },"Gerando Etiqueta...")} ,60,10,,,,.T.)
oDlgLocal:Activate(,,,.t.,{||.T.},,)
Return

Static Function fValQtde(Quantidade)
If Quantidade <= 0
	alert("Quantide de Etiquetas deve ser maior que 0! Favor verifique!")
	Return .F.
EndIf
Return

Static Function doBarCod()

If CB5->(DbSeek(xFilial("CB5") + Alltrim(_cLocal) ))
	If CB5->CB5_PORTA == '0'
		_cPorta := "LPT"+CB5->CB5_LPT
	Endif
Else
	alert("Impressora não configurada ou não cadastrada no sistema. Verifique!")
	Return .F.
EndIf

MSCBPRINTER("S4M",_cPorta,,,.F.,NIL,NIL,NIL,NIL,NIL,.T.)
MSCBCHKStatus(.T.)

For x := 1 to _nQuant
	MSCBBEGIN(1,6)
	
	MSCBBOX(40,00,40,10.7,3) // Linha Vertical
	MSCBBOX(02,10.7,106,10.7) // Segunda Linha Horizontal(acima de Descrição)
	MSCBBOX(02,30,106,30) // última linha horizontal da etiqueta(acima do código de barras)
	MSCBSAY(04,02,"WHB","N","0","044,045")
	MSCBSAY(43,01,"CODIGO","N","A","012,008")
	MSCBSAY(43,04, AllTrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN), "N", "0", "032,035")
	MSCBSAY(03,12,"PRODUTO","N","A","012,008")
	MSCBSAY(03,14,Alltrim(SB1->B1_COD) + "   " + Alltrim(SB1->B1_DESC),"N", "0", "020,030")
	MSCBSAY(03,17,"Lote " + _cLote, "N", "0", "020,030")
	//MSCBSAY(45,17,"  Qtd.Padr - "  ,"N", "0" , "020,030")
	//MSCBSAY(53,15,"Local Fisico - " + Alltrim(SB1->B1_LOCAFIS),"N","A","012,008")
	//MSCBSAY(72,17,Alltrim(Str(_nQtdPadr)),"N", "0", "049,052")
	MSCBSAYBAR(03,20,Alltrim(SB1->B1_COD),"N","MB07",6.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	MSCBSAYBAR(06,33,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,"N","MB07",7.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	MSCBInfoEti("Produto","30X100")
	MSCBEND()
Next x
MSCBCLOSEPRINTER()
MS_FLUSH()

MsgInfo("Impressão Finalizada com Sucesso!")
oDlgLocal:End()
oDlgParam:End()
IIF(lOp,oDlgOp:End(),oDlgProd:End() )
oDlgDet:End()

Return

Static Function OpValid()
	If !SC2->(DbSeek(xFilial("SC2") + Alltrim(_cOp) ))
		alert("Ordem de Produção não encontrada!")
		Return .F.
	EndIf
	If !SB1->(DbSeek(xFilial("SB1") + Alltrim(SC2->C2_PRODUTO) ))
		alert("Peca da Op não encontrada! Verifique se o produto está cadatrado certo na OP!")
		Return .F.
	EndIf
	_cProd := _cOp
	_cLote := U_NHEST002()
Return