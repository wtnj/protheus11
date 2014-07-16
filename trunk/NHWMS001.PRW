/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHWMS001  ºAutor:José Henrique M Felipetto Data:01/18/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch" 
#INCLUDE "PROTHEUS.CH"

User Function NHWMS001()
SetPrvt("oRelato,oDldDet,oRadio,oBtn,nRadio,_cProd,_cProd2,_cPorta,_cLote,_nQuant,_nQtdPadr,_cSerie")
SetPrvt("bNe,oDlgProd,oBtnOpc,oDlgParam,oBtnPec,oBtnParam,oBtnLocal,oDlgLocal,_cLocal,_cOp,oDlgOp,lOp,oDlgNF,oBtnNF,_cNF,_cForn,_cLoja")
SetPrvt("_nNF,oDlgNf,_nSerie,_cForn,_cLoja,oDlgNf,oBtnNf,aHeader,aCols")
aHeader := {}
aCols := {}
lOp := .F.
	
oDlgDet  := MsDialog():New(0,0,280,200,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	oRadio := tRadMenu():New(22,25,{"Produto.","Ordem de Produção.","Nota Fiscal","Endereço","Transporte","Operadores","Recurso Prd","Transação Prd","Mercedes","Etq. Recebimento","Produto - Grande"},;
							   {|u| iF(PCount()>0,nRadio:=u,nRadio)},oDlgDet,,{||.T.},,,,,,100,30,,,,.T.)
	oBtnOpc := tButton():New(125,20,"Avançar",oDlgDet,{|| getRadio(nRadio)  } ,60,10,,,,.T.)
oDlgDet:Activate(,,,.t.,{||.T.},,)
	
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega a Opção Digitada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function getRadio(Rad)

	If Rad == 1
		getProd()
	ElseIf Rad == 2
		U_NHWMS008()
	ElseIf Rad == 3
		U_NHWMS002()
	ElseIf Rad == 4
		U_NHWMS004()
	ElseIf Rad == 5
		T_ACDI050()
	ElseIf Rad == 6
		T_ACDI060()
	ElseIf Rad == 7
		T_ACDI070()
	ElseIf Rad == 8
		T_ACDI080()
	ElseIf Rad == 9
		U_NHWMS003()
	ElseIf Rad == 10
		U_NHWMS005()
	ElseIf Rad == 11
		U_NHWMS007()
	EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA O NÚMERO DA OP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA O PRODUTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function getProd()
_cProd := Space(Len(SB1->B1_COD))
_cProd2 := Space(Len(SB1->B1_COD))

oDlgProd  := MsDialog():New(0,0,85,400,"Digite o Produto:",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"De Peça:"},oDlgProd,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,35,{|u| if(Pcount() > 0, _cProd := u,_cProd)},oDlgProd,60,8,"@!",{||/*PartValid(_cProd)*/.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"SB1","_cProd")

	oSay1 := TSay():New(20,10,{||"Até Peça:"},oDlgProd,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(18,35,{|u| if(Pcount() > 0, _cProd2 := u,_cProd2)},oDlgProd,60,8,"@!",{||/*PartValid(_cProd2)*/.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"SB1","_cProd2")


	oBtnPec := tButton():New(18,110,"Avançar",oDlgProd,{||getPar(_cProd,_cProd2)} ,60,10,,,,.T.)
oDlgProd:Activate(,,,.t.,{||.T.},,)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A PECA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function PartValid(cprd)
SB1->(DbSetOrder(1) )
If !SB1->(DbSeek(xFilial("SB1") + Alltrim(cPrd) ))
	alert("Produto não encontrado!. Favor digite novamente! ")
	Return .F.
EndIf
_cLote := U_NHEST002()
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A OP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function OpValid()
	If !SC2->(DbSeek(xFilial("SC2") + Alltrim(_cOp) ))
		alert("Ordem de Produção não encontrada!")
		Return .F.
	EndIf
	If !SB1->(DbSeek(xFilial("SB1") + Alltrim(SC2->C2_PRODUTO) ))
		alert("Peca da Op não encontrada! Verifique se o produto está cadatrado certo na OP!")
		Return .F.
	EndIf
	_cProd := SC2->C2_PRODUTO
	_cLote := U_NHEST002()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA OS PARAMETROS PARA IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function getPar(cProd,cprod2) 
_cSerie := Space(Len(SD1->D1_SERIE))
_nQuant := 0
_nQtdPadr := 0
  
	If cprod==cprod2 .and. SB5->(DbSeek(xFilial("SB5") + Alltrim(cProd) ))
		_nQtdPadr := SB5->B5_QPA
	EndIf

	oDlgParam  := MsDialog():New(0,0,320,280,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"De Peca:"},oDlgParam,,,,,,.T.,,)
	oGet1 := tGet():New(06,50,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .F. },,,,,,,"cProd")

	oSay1 := TSay():New(28,10,{||"Ate Peca:"},oDlgParam,,,,,,.T.,,)
	oGet1 := tGet():New(26,50,{|u| if(Pcount() > 0, cProd2 := u,cProd2)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .F. },,,,,,,"cProd2")

	oSay2 := TSay():New(48,10,{||"Quantidade:"},oDlgParam,,,,,,.T.,,)
	oGet2 := tGet():New(46,50,{|u| if(Pcount() > 0, _nQuant := u,_nQuant)},oDlgParam,60,8,"99999",{||fValQtde(_nQuant)},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQuant")

	oSay3 := TSay():New(68,10,{||"Qtd. por Emb:"},oDlgParam,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(66,50,{|u| if(Pcount() > 0, _nQtdPadr := u,_nQtdPadr)},oDlgParam,60,8,"999999",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQtdPadr")

	oSay4 := TSay():New(88,10,{||"Lote:"},oDlgParam,,,,,,.T.,,)
	oGet4 := tGet():New(86,50,{|u| if(Pcount() > 0, _cLote := u,_cLote)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_cLote")

	oSay5 := TSay():New(108,10,{||"Serie:"},oDlgParam,,,,,,.T.,,)
	oGet5 := tGet():New(106,50,{|u| if(Pcount() > 0, _cSerie := u,_cSerie)},oDlgParam,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .F. },,,,,,,"_cSerie")

	oBtnParam := tButton():New(128,50,"Avançar",oDlgParam,{||fImpLocal()} ,60,10,,,,.T.)

	oDlgParam:Activate(,,,.t.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A QUANTIDADE DE ETIOQUETAS DIGITADA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValQtde(Quantidade)
If Quantidade <= 0
	alert("Quantide de Etiquetas deve ser maior que 0! Favor verifique!")
	Return .F.
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA O LOCAL DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImpLocal()
//_cLocal := Space(Len(CB5->CB5_CODIGO))
_cLocal   := CB5->CB5_CODIGO

oDlgLocal  := MsDialog():New(0,0,50,400,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Local:"},oDlgLocal,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,30,{|u| if(Pcount() > 0, _cLocal := u,_cLocal)},oDlgLocal,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"CB5","_cLocal")

	oBtnLocal := tButton():New(06,110,"Avançar",oDlgLocal,{|| Processa({|| doBarCod() },"Gerando Etiqueta...")} ,60,10,,,,.T.)
oDlgLocal:Activate(,,,.t.,{||.T.},,)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME A ETIQUETA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

SB1->(dbsetorder(1))
SB1->(dbseek(xfilial('SB1')+_cProd ))

While SB1->(!EOF()) .AND. SB1->B1_COD <= _cProd2

	For x := 1 to _nQuant
		MSCBBEGIN(1,6)
		
		MSCBBOX(40,00,40,10.7,3) // Linha Vertical
		MSCBBOX(02,10.7,106,10.7) // Segunda Linha Horizontal(acima de Descrição)
		MSCBBOX(02,30,106,30) // última linha horizontal da etiqueta(acima do código de barras)
		MSCBSAY(04,02,"WHB","N","0","044,045")
		MSCBSAY(43,01,"CODIGO","N","A","012,008")
		MSCBSAY(43,04, AllTrim(SB1->B1_COD), "N", "0", "032,035")
		MSCBSAY(03,12,"DESCRICAO","N","A","012,008")
		MSCBSAY(03,14,SB1->B1_DESC,"N", "0", "020,030")
		MSCBSAY(03,17,"Lote " + _cLote, "N", "0", "020,030")
		MSCBSAY(45,17,"  Qtd.Padr - "  ,"N", "0" , "020,030")
		MSCBSAY(53,15,"Local Fisico - " + Alltrim(SB1->B1_LOCAFIS),"N","A","012,008")
		MSCBSAY(72,17,Alltrim(Str(_nQtdPadr)),"N", "0", "049,052")
		MSCBSAYBAR(03,20,_cLote,"N","MB07",6.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		MSCBSAYBAR(06,33,_cProd,"N","MB07",7.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
		MSCBInfoEti("Produto","30X100")
		MSCBEND()
	Next x

	SB1->(dbskip())
Enddo

MSCBCLOSEPRINTER()
MS_FLUSH()

MsgInfo("Impressão Finalizada com Sucesso!")
oDlgLocal:End()
oDlgParam:End()
IIF(lOp,oDlgOp:End(),oDlgProd:End() )
oDlgDet:End()

Return