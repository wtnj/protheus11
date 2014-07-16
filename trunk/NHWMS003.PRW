/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMS003 Autor:José Henrique M Felipetto    Data:03/23/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Mercedes                                          º±±
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
#INCLUDE "RWMAKE2.CH"

User Function NHWMS003()
Private aComboX	   := {}
Private aComboD	   := {}
Private _nInicial  := 0
Private _nQuant    := 0
Private _cLocal    := space(Len(CB5->CB5_CODIGO))
Private _dData 	   := Date()
Private nRadio , nRadio2
Private _cProd     := space(15)
Private _nL
Private nCont := 0

ZEV->( DbSetOrder(2) ) // ZEV_FILIAL+ZEV_CODWHB
ZEV->( DbGoTop() )

While ZEV->( !eof() )
	_nL := aScan(aComboX,{|x| x == ZEV->ZEV_CODWHB} )
		
	If _nL == 0
		aAdd(aComboX,ZEV->ZEV_CODWHB)
	EndIf
	ZEV->( DbSkip() )
EndDo

_cProd := space(15)
// ----------------------------------------------------------------------------------------------------------------------
oDlg  := MsDialog():New(0,0,280,350,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1 := TSay():New(08,10,{||"Modelo:"},oDlg,,,,,,.T.,CLR_HBLUE,)
/*olProd := TComboBox():New(06,50,{|u| if(Pcount() > 0,_cProd := u,_cProd)},;
		  aCombo,60,50,oDlg,,{||},,,,.T.,,,,{|| .T. },,,,,"_cProd")*/

@006,050 COMBOBOX _cProd ITEMS aCombox SIZE 80,50 PIXEL OF oDlg

/*
olProd := TComboBox():New(06,112,{|u| if(Pcount() > 0,_cProd := u,_cProd)},;
		  aComboT,60,50,oDlg,,{||},,,,.T.,,,,{|| .T. },,,,,"_cProd")
*/

oSay2 := TSay():New(28,10,{||"Quantidade:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet1 := tGet():New(26,50,{|u| if(Pcount() > 0, _nQuant := u,_nQuant)},oDlg,60,8,"999999",{||.T.},;
,,,,,.T.,,,{|| .T. },,,,,,,"_nQuant")

oSay3 := TSay():New(48,10,{||"Data:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet2 := tGet():New(46,50,{|u| if(Pcount() > 0, _dData := u,_dData)},oDlg,60,8,"99/99/9999",{||.T.},;
,,,,,.T.,,,{|| .T. },,,,,,,"_dData")

oSay4 := TSay():New(68,10,{||" Máquina: "},oDlg,,,,,,.T.,CLR_HBLUE,)
oGroup := tGroup():New(059,050,114,100,"  Dianteira  ",oDlg,,,.T.) // Y , X , Y , X
oRadio := tRadMenu():New(064,060,{"  ","540","798","810","811"},{|u| If( pCount() > 0, nRadio := u , nRadio )},oDlg,,{|| },,,,,,100,30,,,,.T.)

/*
oGroup2 := tGroup():New(059,112,092,162," Traseira ",oDlg,,,.T.) // Y , X , Y , X
oRadio2 := tRadMenu():New(064,122,{"  ","810","811"},{|u| If( pCount() > 0, nRadio2 := u , nRadio2 )},oDlg,,{|| fSequen(_cProd,_dData,nRadio2,"T") },,,,,,100,30,,,,.T.)
*/

oSay5 := TSay():New(113,10,{||"Sequencial:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet3 := tGet():New(111,50,{|u| if(Pcount() > 0, _nInicial := u,_nInicial)},oDlg,60,8,"99",{||.T.},;
,,,,,.T.,,,{|| .T. },,,,,,,"_nInicial")

oBtnNf := tButton():New(123,30,"Avançar",oDlg,{|| fImpLocal() } ,60,10,,,,.T.)
oBtnNf := tButton():New(123,100,"Incluir Produto",oDlg,{|| fContAcesso() } ,60,10,,,,.T.)

oDlg:Activate(,,,.t.,{||.T.},,)
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PEGA O LOCAL DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImpLocal()

	If !fValida()
		Return .F.
	EndIf
	
	_cLocal   := CB5->CB5_CODIGO

	oDlgLocal  := MsDialog():New(0,0,50,400,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay6 := TSay():New(08,10,{||"Local:"},oDlgLocal,,,,,,.T.,CLR_HBLUE,)
	oGet4 := tGet():New(06,30,{|u| if(Pcount() > 0, _cLocal := u,_cLocal)},oDlgLocal,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"CB5","_cLocal")

	oBtnLocal := tButton():New(06,110,"Avançar",oDlgLocal,{|| Processa({|| doBarCod() },"Gerando Etiqueta...")} ,60,10,,,,.T.)
	oDlgLocal:Activate(,,,.t.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IMPRIME A ETIQUETA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function doBarCod()
Local _cCodMer := ""
Local _cQStand := ""
Local _cZGS	   := ""
Local _nCont   := 0
Local _cMaq    := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a Impressiora selecionada existe ou está configurada!³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CB5->(DbSeek(xFilial("CB5") + Alltrim(_cLocal) ))
	If CB5->CB5_PORTA == '0'
		_cPorta := "LPT"+CB5->CB5_LPT
	Endif
Else
	alert("Impressora não configurada ou não cadastrada no sistema. Verifique!")
	Return .F.
EndIf


//-- sequencial da etiqueta
//ZEV->(DbSetOrder(3) )//ZEV_FILIAL+ZEV_CODWHB+ZEV_DATA+ZEV_MAQ                                                                                                                          
//ZEV->(DbSeek(xFilial("ZEV") + _cProd + DTOS(_dData) + Alltrim(_cMaq)))
//While ZEV->(!EOF()) .AND. ZEV->ZEV_FILIAL+ZEV->ZEV_CODWHB+DTOS(ZEV->ZEV_DATA)+ZEV->ZEV_MAQ ==_cProd + DTOS(_dData) + Alltrim(_cMaq)
//	_mInicial := ZEV->ZEV_SEQ
//	ZEV->(DBSKIP())
//ENDDO

//_nInicial ++

ZEV->( DbSetOrder(2) ) // ZEV_FILIAL+ZEV_CODWHB
ZEV->(dbseek(xFilial("ZEV")+_cProd))
      
_cCodMer 	:= ZEV->ZEV_CODMER
_cQStand 	:= ZEV->ZEV_QSTAND
_cZGS	 	:= ZEV->ZEV_ZGS

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera o código de barras!³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDddt 		:= getRData()
_cCodBar 	:= Alltrim(_cCodMer)
_cCodBar 	+= substr(strzero(year(_dData),4),3,2) +  Alltrim(Strzero(cDddt,3))
_cCodBar 	+= Strzero(_nInicial,2)

/* Verificação temporária */
If nRadio == 2
	_cMaq := "540"
Elseif nRadio == 3
	_cMaq := "798"
ElseIf nRadio == 1
	Return
ElseIf nRadio == 4
	_cMaq := "810"
ElseIf nRadio == 5
	_cMaq := "811"
EndIf

_cCodBar += _cMaq

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MSCBPRINTER("S4M",_cPorta,,,.F.,NIL,NIL,NIL,NIL,NIL,.T.)
MSCBCHKStatus(.T.)

//MB01 = Interleaved 2 of 5
//MB02 = Code 39
//MB03 = EAN 8
//MB04 = EAN 13
//MB05 = UPC A
//MB06 = UPC E
//MB07 = CODE 128

For xE := 1 to _nQuant   




	MSCBBEGIN(1,4)
	MSCBSAY(07,02,"MERCEDES-BENZ DO BRASIL LTDA","N","0","041,042")
	MSCBBOX(05,08.7,119,08.7) // Primeira Linha Horizontal
	MSCBSAYBAR(20,12,Alltrim(_cCodBar),"N","MB07",15.36,.F.,.T.,.F.,,2,3,.F.,.F.,"1",.T.)
	MSCBBOX(05,34,119,34) // Segunda linha horizontal da etiqueta
	MSCBSAY(09,45,"WHB","N","0","048,049")
	MSCBBOX(40,34,40,65.7,3) // Linha Vertical
	MSCBSAY(45,39,"PART NUMBER WHB","N","0","025,035")
	MSCBSAY(45,49,Alltrim(_cProd),"N","0","025,035")
	MSCBBOX(40,44,119,44) // Terceira linha horizontal da etiqueta
	MSCBBOX(40,54,119,54) // Quarta linha horizontal da etiqueta
	MSCBSAY(45,59,"Q-STAND: " + Alltrim(_cQStand),"N","0","020,030")
	MSCBBOX(80,54,80,65.7,3) // Linha Vertical
	MSCBSAY(85,59,"ZGS: " + Alltrim(_cZGS),"N","0","020,030")
	MSCBBOX(05,65.7,119,65.7) // última linha horizontal da etiqueta
	MSCBInfoEti("Produto","30X100")
	MSCBEND()
	
	RecLock("ZEV",.T.)
		ZEV->ZEV_FILIAL := xFilial("ZEV")
		ZEV->ZEV_CODMER := Alltrim(_cCodMer)
		ZEV->ZEV_CODWHB := _cProd
		ZEV->ZEV_QSTAND := _cQStand
		ZEV->ZEV_ZGS    := _cZGS
		ZEV->ZEV_DATA   := _dData
		ZEV->ZEV_SEQ	:= _nInicial
		ZEV->ZEV_MAQ    := _cMaq
		ZEV->ZEV_PARTE	:= "D"
	MsUnLock("ZEV")
	
	//alert(_cqstand)
	_nInicial++
	_cCodBar := Alltrim(_cCodMer)
	_cCodBar += substr(strzero(year(_dData),4),3,2) +  Alltrim(Strzero(cDddt,3))
	_cCodBar += StrZero(_nInicial,2)
	_cCodBar += _cMaq


Next

MSCBCLOSEPRINTER()
MS_FLUSH()

nRadio := 1

MsgInfo("Impressão Finalizada com Sucesso!")
oDlgLocal:End()
//oDlg:End()
Return

Static Function getRData()
Local dDtIni := cToD("01/01/" + ALLTRIM(Str( year(_dData) )))
Local nCont  := 1 // Deve-se começar por 1, pois a contagem do dia 1/1 não será feita dentro do loop.

	While dDtIni < _dData
		nCont++
		dDtIni++
	EndDo

Return nCont

Static Function fValida()

If Empty(_nQuant) .or. Empty(_dData) .or. Empty(_nInicial)
	alert("Há campos obrigatórios que devem ser preechindos!")
	Return .F.
EndIf

If nRadio == 1
	alert("Deve se selecionada a máquina que a peça foi produzida(Traseira ou dianteira)!")
	Return .F.
EndIf

Return .T.	

Static Function fContAcesso()
Private cSenha   := Space(10)

@ 067,020 To 169,312 Dialog Senhadlg Title OemToAnsi("Liberação de Acesso")
@ 015,005 Say OemToAnsi("Informe a senha para o acesso: ") Size 80,8
@ 015,089 Get cSenha Size 50,10 Password
@ 037,106 BmpButton Type 1 Action fOK()
@ 037,055 BmpButton Type 2 Action Close(Senhadlg)
Activate Dialog Senhadlg CENTERED

Return

Static Function fOk()
	
	If cSenha != "ETIQUETA"
		alert("Usuário não autorizado a utilizar a função!")
		Close(Senhadlg)
	Else
		AxCadastro("ZEV")
		Close(Senhadlg)
	EndIf
Return