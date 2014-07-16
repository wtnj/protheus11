
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMNT051  ºAutor  ³João Felipe da Rosa º Data ³  10/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteração das datas das OSs                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"

User Function NHMNT051()

Private cCadastro := "Ordens de Servico de Manutencao"
Private aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"AxVisual" 	, 0 , 2})
aAdd(aRotina,{ "Alt. Datas"     ,"U_MNT051(4)"  , 0 , 4})

mBrowse(6,1,22,75,"STJ",,,,,,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT051(nParam)
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam  

Private dDtOrigi
Private dDtPRI
Private dDtPRF
Private dDtMRI
Private dDtMRF
Private cNum 

	If nPar==4 // alterar datas
		
		If !upper(AllTrim(cUserName))$"ADMIN/LEANDROJS/ALINEBM/JOAOFR"
			Alert("Usuario sem permissão!")
			Return
		EndIf
	
		fCarData()
		bOk := {|| fAltData() }
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}

	oDlg  := MsDialog():New(0,0,160,600,"OS de Manutencao",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(20,10,{||"Número:"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(20,70,{||cNum},oDlg,,,,,,.T.,,)
	
	oSay3 := TSay():New(31,10,{||"Dt Original:"},oDlg,,,,,,.T.,,)
	oGet1 := tGet():New(30,70,{|u| if(Pcount() > 0, dDtOrigi := u,dDtOrigi)},oDlg,40,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nPar==4 .and. !empty(dDtOrigi)},,,,,,,"dDtOrigi")

	oSay4 := TSay():New(42,10,{||"Dt Parada Real Inicial:"},oDlg,,,,,,.T.,,)
	oGet2 := tGet():New(41,70,{|u| if(Pcount() > 0, dDtPRI := u,dDtPRI)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||nPar==4 .and. !empty(dDtPRI)},,,,,,,"dDtPRI")

	oSay5 := TSay():New(42,180,{||"Dt Parada Real Final:"},oDlg,,,,,,.T.,,)
	oGet3 := tGet():New(41,240,{|u| if(Pcount() > 0, dDtPRF := u,dDtPRF)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||nPar==4 .and. !empty(dDtPRF)},,,,,,,"dDtPRF")

	oSay6 := TSay():New(53,10,{||"Dt Manut Real Inicial:"},oDlg,,,,,,.T.,,)
	oGet4 := tGet():New(52,070,{|u| if(Pcount() > 0, dDtMRI := u,dDtMRI)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||nPar==4 .and. !empty(dDtMRI)},,,,,,,"dDtMRI")

	oSay7 := TSay():New(53,180,{||"Dt Manut Real Final:"},oDlg,,,,,,.T.,,)
	oGet5 := tGet():New(52,240,{|u| if(Pcount() > 0, dDtMRF := u,dDtMRF)},oDlg,40,8,"99/99/99",{||.T.},;
		,,,,,.T.,,,{||nPar==4 .and. !empty(dDtMRF)},,,,,,,"dDtMRF")

	oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CARREGA OS VALORES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarData()
	cNum     := STJ->TJ_ORDEM
	dDtOrigi := STJ->TJ_DTORIGI
	dDtPRI   := STJ->TJ_DTPRINI
	dDtPRF   := STJ->TJ_DTPRFIM
	dDtMRI   := STJ->TJ_DTMRINI
	dDtMRF   := STJ->TJ_DTMRFIM
Return

Static Function fAltData()
	
	RecLock("STJ",.F.)
		STJ->TJ_DTORIGI := dDtOrigi 
		STJ->TJ_DTPRINI := dDtPRI
		STJ->TJ_DTPRFIM	:= dDtPRF
		STJ->TJ_DTMRINI := dDtMRI
		STJ->TJ_DTMRFIM := dDtMRF
	MSunlock("STJ")
	
	oDlg:End()
	
Return