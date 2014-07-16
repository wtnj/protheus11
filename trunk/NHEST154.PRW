/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST154  ºAutor  ³João Felipe da Rosa º Data ³  28/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CONTROLE DE DIVERGÊNCIAS                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function NHEST154()
                                                        
Private aRotina, cCadastro

cCadastro := "Controle de Divergência"
aRotina   := {}

aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"         , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"AxVisual" 	    , 0 , 3})
aAdd(aRotina,{ "Solucao"        ,"U_EST154SOL()"    , 0 , 4})
aAdd(aRotina,{ "Imprimir"		,"U_EST136IM(2)" 	, 0 , 4})
aAdd(aRotina,{ "Legenda"        ,"U_EST154LEG()"    , 0 , 4})

mBrowse(6,1,22,75,"ZDE",,,,,,fCriaCor())

Return    

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ LEGENDA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
User Function EST154LEG()

Local aLegenda :=	{ {"BR_VERDE"    , "Pendente"   },;
  					  {"BR_VERMELHO" , "Encerrado"  }}
  					  
BrwLegenda(OemToAnsi("Divergência Recebimento"), "Legenda", aLegenda)

Return

Static Function fCriaCor()       

	Local aLegenda :=	{ {"BR_VERDE"    , "Pendente"    },;
  						  {"BR_VERMELHO" , "Encerrado"   }}

	Local uRetorno := {}
	Aadd(uRetorno, { 'ZDE->ZDE_STATUS == "P"' , aLegenda[1][1] } )
	Aadd(uRetorno, { 'ZDE->ZDE_STATUS == "E"' , aLegenda[2][1] } )
	
Return(uRetorno)          

User Function EST154SOL()
Local bOk         := {||fOk()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}

Local cTransp     := cLojTra := cDesTra := cMotori := cPlaca := ''
Local cChave      := ZDE->(ZDE_DOC+ZDE_SERIE+ZDE_FORNEC+ZDE_LOJA)

Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)

Private cDoc
Private cObs      := ""
Private cSoluc    := ""

	If ZDE->ZDE_STATUS<>'P'
		Alert('Divergência está encerrada!')
		return .f.
	EndIf
	
	//-- C A B E C A L H O 
	//-- Posiciona a tabela de NF
	SF1->(dbsetorder(1))
	SF1->(dbSeek(xFilial("SF1")+cChave))

	cDoc     := ZB8->ZB8_DOC+'/'+ZB8->ZB8_SERIE
	dEmissao := SF1->F1_EMISSAO
	cHrEntr  := ZB8->ZB8_HRENTR
	
	SF8->(dbsetOrder(2)) // F8_FILIAL+F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA
	If SF8->(dbSeek(xFilial("SF8")+cChave))
		SA2->(dbsetorder(1)) // filial + cod + loja
		If SA2->(dbSeek(xFilial("SA2")+SF8->F8_TRANSP + SF8->F8_LOJTRAN))
			cTransp := SA2->A2_COD
			cLojTra := SA2->A2_LOJA
			cDesTra := SA2->A2_NOME
		EndIf
	Endif

	cForn := ZDE->ZDE_FORNEC
	cLoja := ZDE->ZDE_LOJA
	cDesFor := ''
	
	If SF1->F1_TIPO$'N'
		SA2->(dbsetorder(1)) // filial + cod + loja
		If SA2->(dbSeek(xFilial("SA2")+ZDE->ZDE_FORNEC + ZDE->ZDE_LOJA))	
			cDesFor := SA2->A2_NOME
		EndIf
	Else
		SA1->(dbsetorder(1)) // filial + cod + loja
		If SA1->(dbSeek(xFilial("SA1")+ZDE->ZDE_FORNEC + ZDE->ZDE_LOJA))	
			cDesFor := SA1->A1_NOME
		EndIf
	Endif
	
	If !Empty(SF1->F1_CODPLAC) 
		If SO5->(dbSeek(xFilial("SO5")+SF1->F1_CODPLAC))
			cMotori := SO5->O5_DESCRI
			cPlaca  := SO5->O5_PLACA
		Endif
	Endif

    cItem    := ZDE->ZDE_ITEMNF
    cProd    := ZDE->ZDE_COD 
    cDesProd := Posicione('SB1',1,xFilial('SB1')+ZDE->ZDE_COD,'B1_DESC')
    nQtdNF   := Posicione('SD1',1,xFilial('SD1')+cChave+ZDE->(ZDE_COD+ZDE_ITEMNF),'D1_QUANT')
    nQtdDig  := Posicione('ZB8',1,xFilial('ZB8')+cChave+ZDE->ZDE_ITEMNF,'ZB8_QTDDIG')
    cObs     := Posicione('ZB8',1,xFilial('ZB8')+cChave+ZDE->ZDE_ITEMNF,'ZB8_OBS')
	
	//-- I T E N S
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc,,)}

	oDlg := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Divergência de Recebimento - Solução",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	@ 020,010 Say "NF/Serie" Size 40,8 Object olNF
	@ 020,050 Get cDoc When .f. Size 50,8 Object oNF
	@ 020,140 Say "Emissão" Size 30,8 Object olEmissa
	@ 020,170 Get dEmissao Picture "99/99/9999" When .F. Size 40,8 Object oEmissa
	@ 020,260 Say "Hora Entrada" Size 30,8 Object olHora
	@ 020,295 Get cHrEntr Picture "99:99" When .F. Size 25,8 Object oHora

	@ 034,010 Say "Fornecedor" Size 040,8 Object olForn
	@ 032,050 Get cForn   Picture "@!" When .F.  Size 040,8 Object oForn
	@ 032,095 Get cLoja   Picture "@!" When .F.  Size 020,8 Object oLoja
	@ 032,120 Get cDesFor Picture "@!" When .F.  Size 200,8 Object oDForn	

	@ 046,010 Say "Transportadora:" Size 040,8 Object olTransp
	@ 044,050 Get cTransp When .f. Size 040,8 Object oTransp
	@ 044,095 Get cLojTra When .f. Size 020,8 Object oLojTra
	@ 044,120 Get cDesTra When .f. Size 200,8 Object oDesTra	

	@ 058,010 Say "Motorista" Size 40,8 Object olMotori
	@ 056,050 Get cMotori When .f. Size 70,8 Object oMotori
	@ 058,260 Say "Placa" Size 30,8 Object olPlaca
	@ 056,280 Get cPlaca Picture "!!!-9999" When .F. Size 40,8 Object oPlaca

	@ 070,010 Say "Item" Size 40,8 Object olItem
	@ 068,050 Get cItem When .f. Size 30,8 Object oItem
	@ 070,095 Say "Produto" Size 30,8 Object olProd
	@ 068,115 Get cProd Picture "@!" When .F. Size 50,8 Object oProd
	@ 068,170 Get cDesProd Picture "@!" When .F. Size 150,8 Object oDesProd

	@ 082,010 Say "Quant NF" Size 40,8 Object olQtdNF
	@ 080,050 Get nQtdNf When .f. Size 30,8 Object oQtdNF
	@ 082,250 Say "Quant Digitada" Size 40,8 Object olQtdDig
	@ 080,290 Get nQtdDig When .f. Size 30,8 Object oQtdDig
	
	@ 094,010 Say "Observação" Size 40,8 Object olObs
	@ 092,050 Get oOBS VAR cObs When .F. MEMO Size 270,054 PIXEL OF oDlg

	@ 150,010 Say "Solução" Size 40,8 Object olSoluc
	@ 148,050 Get oSoluc VAR cSoluc MEMO Size 270,056 PIXEL OF oDlg

	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
	
Return

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ CANCELA ³
//ÀÄÄÄÄÄÄÄÄÄÙ
Static Function fEnd() 
	oDlg:End()
Return

Static Function fValida()
	If Empty(cSoluc)
		Alert('Informe a solucao!')
		Return .f.
	Endif
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA RECEBIMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fOk()

	If !fValida()
		Return .f.
	Endif
	
	RecLock("ZDE",.F.)
		ZDE->ZDE_SOLUC  := cSoluc
		ZDE->ZDE_USROK  := alltrim(upper(cUserName))
		ZDE->ZDE_HROK   := time()
		ZDE->ZDE_DTOK   := date()
		ZDE->ZDE_STATUS := 'E'
	MsUnLock("ZDE")

	oDlg:End()

Return	