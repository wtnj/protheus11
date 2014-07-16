
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMS004  ºAutor:José Henrique M Felipetto Data:05/22/12      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function NHWMS004()

Private oDlg , oBtn ,  _cAlmOri := Space(2) , _cAlmDes := Space(2), _cEndOri := Space(Len(SBE->BE_LOCALIZ)) , _cEndDes := space(Len(SBE->BE_LOCALIZ)) , _cLocal  := Space(Len(CB5->CB5_CODIGO)) , _cPorta := ""

oDlg  := MsDialog():New(0,0, /* Altura */ 250, /* Largura */ 350,"Digite os parâmetros:",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"de Almoxarifado:"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,60,{|u| if(Pcount() > 0, _cAlmOri := u,_cAlmOri)},oDlg,60,8,"@!",{|| .T. },;
					,,,,,.T.,,,{|| .T. },,,,,,"ALM","_cAlmOri")
	
	oSay2 := TSay():New(28,10,{||"ate Almoxarifado:"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(26,60,{|u| if(Pcount() > 0, _cAlmDes := u,_cAlmDes)},oDlg,60,8,"@!",{|| .T. },;
					,,,,,.T.,,,{|| .T. },,,,,,"ALM","_cAlmDes")
	
	oSay3 := TSay():New(48,10,{||"do Endereço:"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(46,60,{|u| if(Pcount() > 0, _cEndOri := u,_cEndOri)},oDlg,60,8,"@!",{|| .T. },;
					,,,,,.T.,,,{|| .T. },,,,,,"SBE","_cEndOri")
	
	oSay3 := TSay():New(68,10,{||"ate Endereço:"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(66,60,{|u| if(Pcount() > 0, _cEndDes := u,_cEndDes)},oDlg,60,8,"@!",{|| .T. },;
					,,,,,.T.,,,{|| .T. },,,,,,"SBE","_cEndDes")
	
	oSay3 := TSay():New(88,10,{||"Local Impressão:"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet3 := tGet():New(86,60,{|u| if(Pcount() > 0, _cLocal := u,_cLocal)},oDlg,60,8,"@!",{|| .T. },;
					,,,,,.T.,,,{|| .T. },,,,,,"CB5","_cLocal")

	oBtn  := tButton():New(100,60,"Avançar",oDlg,{|| Chama() } ,60,10,,,,.T.)
oDlg:Activate(,,,.t.,{||.T.},,)

Return

Static Function TestPrint(Locall)

If CB5->(DbSeek(xFilial("CB5") + Alltrim(Locall) )) 
	If CB5->CB5_PORTA == "0"
		_cPorta := "LPT" + CB5->CB5_LPT
	EndIf
Else
	alert("Impressora não configurada ou não cadastrada no sistema! Favor verifique. ")
	Return .F.
EndIf

Return .T.

Return

Static Function buscaDados(AlmOrigem,AlmDestino,EndOrigem,EndDestino)
Local cQuery := ""

If !TestPrint(_cLocal)
	Return .F.
EndIf
 
cQuery := " SELECT BE_LOCALIZ,BE_DESCRIC FROM " + RetSqlName("SBE") + " BE "
cQuery += " WHERE  BE_LOCAL   BetWeen '" + AlmOrigem + "' AND '" + AlmDestino + "' " 
cQuery += " AND    BE_LOCALIZ BetWeen '" + EndOrigem + "' AND '" + EndDestino + "' "

cQuery += " AND    BE_FILIAL = '" + xFilial("SBE") + "' "
cQuery += " AND    BE.D_E_L_E_T_ = '' "

TCQUERY cQuery NEW ALIAS "TRA"
TRA->(DbGoTop() )

Return

Static Function PrintTicket()

MSCBPRINTER("S4M",_cPorta,,,.F.,NIL,NIL,NIL,NIL,NIL,.T.)
MSCBCHKStatus(.T.)

While TRA->(!Eof() )
	MSCBBEGIN(1,6)
	
	MSCBBOX(40,00,40,10.7,3) // Linha Vertical
	MSCBBOX(02,10.7,106,10.7) // Segunda Linha Horizontal(acima de Descrição)
	MSCBBOX(02,30,106,30) // última linha horizontal da etiqueta(acima do código de barras)
	MSCBSAY(04,02,"ENDERECO","N","0","034,035")
	MSCBSAY(43,01,"CODIGO","N","A","012,008")
	MSCBSAY(43,04, AllTrim(TRA->BE_LOCALIZ), "N", "0", "032,035")
	MSCBSAY(03,16,"DESCRICAO","N","A","012,008")
	MSCBSAY(03,18,Alltrim(TRA->BE_DESCRIC),"N", "0", "020,030")
	//MSCBSAY(03,17,"Lote " + _cLote, "N", "0", "020,030")
	//MSCBSAY(45,17,"  Qtd.Padr - "  ,"N", "0" , "020,030")
	//MSCBSAY(72,17,Alltrim(Str(_nQtdPadr)),"N", "0", "049,052")
	//MSCBSAYBAR(03,20,_cLote,"N","MB07",6.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	MSCBSAYBAR(06,33,TRA->BE_LOCALIZ,"N","MB07",7.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
	MSCBInfoEti("Endereco","30X100")
	MSCBEND()
	TRA->(DbSkip() )
EndDo
	
MSCBCLOSEPRINTER()
MS_FLUSH()
TRA->(DbCloseArea() )

Return

Static Function Chama()

Processa({|| buscaDados(_cAlmOri,_cAlmDes,_cEndOri,_cEndDes) },"Trazendo Dados...")
Processa({|| PrintTicket() },"Imprimindo...")
MsgInfo("Impressão finalizada com sucesso! ")
oDlg:End()



Return