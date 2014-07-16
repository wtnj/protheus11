/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT060  ºAutor  ³Guilherme D. Camargo ºData ³ 30/08/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PARADA DE MÁQUINA                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"

User Function NHMNT060()
Private aRotina, cCadastro

cCadastro := "PARADA DE MÁQUINA"
aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"AxVisual" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_MNT060(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"		,"U_MNT060(4)"	, 0 , 4})
aAdd(aRotina,{ "Excluir"		,"U_MNT060(5)"	, 0 , 5})

mBrowse( 6, 1,22,75,"ZF2",,,,,,fCriaCor())
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function MNT060(nParam)
Local nVar := nParam
Local lFunc
	If !u_m60Vld()
		Return .F.
	Endif
	If nVar == 3
		lFunc := u_fInclui()
	Elseif nVar == 4
		lFunc := AxAltera("ZF2",ZF2->(Recno()),4,,,,,,,,,,,)
	Elseif nVar == 5
		lFunc := AxDeleta("ZF2",ZF2->(Recno()),5,,,,,,.T.)
	Endif
Return lFunc

User Function m60Vld()
	If !AllTrim(Upper(cUserName))$"CLAYTONJS/ROBERTOU/FERNANDOMI/MAICONMT/JOAOFR/ALEXANDREFL/DOUGLASSD/JOSEMF/ALEXANDRERP/MARCOSRR/GUILHERMEDC/ADMINISTRADOR/ADMIN"
		Alert("NÃO PERMITIDO!")
		Return .F.
	Endif
Return .T.

User Function fInclui()
	Private oGet1, oGet2
	Private oDlg, oButton, oFont, oSay1, oSay2
	Private cDesc := Space(50), cCod := Space(6)
	Define MSDialog oDlg From 0,0 To 150,430 Pixel Title 'Parada de Máquina!'
	oFont:=TFont():New("Courrier New",,-14,.T.)
	oSay1 := tSay():New(3,10,{||"Descrição da Parada de Máquina."},oDlg,,,,,,.T.,CLR_HBLUE,)					         					
	oSay2 := tSay():New(23,10,{||"Descrição:  "},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(30,10,{|u| if(Pcount() > 0, cDesc := u,cDesc)},oDlg,200,10,"@!",{||.T.},;
						,,,,,.T.,,,{|| .T. },,,,,,,"cDesc")
	oButton := tButton():New(50,140,"Confirmar",oDlg,{||InsereDados()},60,15,,,,.T.)
	Activate MSDialog oDlg Centered
Return .T.

Static Function InsereDados()
cCod := GetSxENum("ZF2","ZF2_CODIGO")
	RecLock("ZF2",.T.)
		ZF2->ZF2_FILIAL := xFilial("ZF2")
		ZF2->ZF2_CODIGO := cCod           
		ZF2->ZF2_DESCRI := cDesc
	MsUnlock("ZF2")
	ConfirmSx8()
   oDlg:End()
Return