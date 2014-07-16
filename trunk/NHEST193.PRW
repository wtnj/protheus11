
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST193 Autor  José Henrique M Felipetto  Data ³  01/26/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EST                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function NHEST193()
Local aPergs := {} // Array com as Perguntas
Private _nPags := 1 // Controle de Páginas
Private aParam := {}

oPrn := tAvPrinter():New("Protheus") // Instancia oPrn na classe tAvPrinter, para utilização dos métodos da classe.
oPrn:SetPortrait() // ou SetLandScape
oPrn:StartPage() // Inicia a Página

oRelato          := Relatorio():New() // Instancia na variavel oRelato a Classe Relatorio.

oRelato:cPerg := "EST193"

aAdd(aPergs,{"De Produto "        ,"C", 15,0,"G",""      ,""       ,"","","","SB1"   ,""    }) //mv_par01
aAdd(aPergs,{"Ate Produto "       ,"C", 15,0,"G",""      ,""       ,"","","","SB1"   ,""    }) //mv_par02
aAdd(aPergs,{"De Cor. WHB "       ,"C", 05,0,"G",""      ,""       ,"","","",""      ,""    }) //mv_par03
aAdd(aPergs,{"Ate Cor. WHB "      ,"C", 05,0,"G",""      ,""       ,"","","",""      ,""    }) //mv_par04
aAdd(aPergs,{"De data "           ,"D", 20,0,"G",""      ,""       ,"","","",""      ,""    }) //mv_par05
aAdd(aPergs,{"Ate data "          ,"D", 20,0,"G",""      ,""       ,"","","",""      ,""    }) //mv_par06
aAdd(aPergs,{"Plantas "           ,"N", 01,0,"C","1=Forjaria/Usinagem","2=Fundição/Usinagem"       ,"","","",""      ,""    }) //mv_par07


oRelato:AjustaSx1(aPergs) // Funcao que pega o Array aPergs e cadastra as perguntas no SX1

If Pergunte(oRelato:cPerg,.T.)
	Processa({|| Imprime()} , "Imprimindo relatório...")
Else
	Return .F.
EndIf


TTRA->(DbCloseArea() )
oPrn:End() //Termina

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local cVar
Local nCont := 1 // Variável que controla o número de registros escritos
Local cConfirm := .T.
nAlt := 20
nLar := 20

oFnt1 		:= TFont():New("Arial"		,,11,,.T.,,,,,.F.) // Instancia da Classe tFont
oFnt2 		:= TFont():New("Arial"		,,11,,.F.,,,,,.F.)


Processa({|| Query() }, "Trazendo dados para relatório") // Query que pega tudo o que saiu do armazém origem

ProcRegua(0)

Cabecalho()
cCod := TTRA->ZBB_COD
oPrn:Say(nAlt + 300,nLar - 05,"Produto: " + Alltrim(TTRA->ZBB_COD) + " - Descrição: " + Alltrim(TTRA->B1_DESC),oFnt2)
nAlt += 60

nQuant := 0 
While TTRA->(!EOF() )
	If nCont <= 42
		If cCod == TTRA->ZBB_COD
			oPrn:Say(nAlt + 300,nLar,TTRA->ZBA_NUM,oFnt2,,,,1)
			oPrn:Say(nAlt + 300,nLar + 350,DTOC(STOD(TTRA->ZBA_DATA)),oFnt2,,,,1)
			//oPrn:Say(nAlt + 300,nLar + 420,Alltrim(TTRA->ZBB_COD),oFnt2)
			//oPrn:Say(nAlt + 300,nLar + 800,Alltrim(Substr(TTRA->B1_DESC,1,20)),oFnt2)
			oPrn:Say(nAlt + 300,nLar + 630,Alltrim(Str(TTRA->ZBB_VOLUME)),oFnt2,,,,1)
			oPrn:Say(nAlt + 300,nLar + 1056,Alltrim(Str(TTRA->ZBB_QUANT)),oFnt2,,,,1)
			oPrn:Say(nAlt + 300,nLar + 1470,Alltrim(TTRA->ZBB_CORPRD),oFnt2,,,,1)
			oPrn:Say(nAlt + 300,nLar + 1810,Alltrim(TTRA->ZBB_CORMP),oFnt2,,,,1)
			nCont++
			nAlt += 60
			nQuant += TTRA->ZBB_QUANT
		Else
			oPrn:Say(nAlt + 300,nLar + 916,"Total: " + Alltrim(Str(nQuant)),oFnt2)
			oPrn:Line(nAlt + 350,0,nAlt + 350,3400)
			nAlt += 60
			
			oPrn:Say(nAlt + 300,nLar,"Produto: " + Alltrim(TTRA->ZBB_COD) + " - Descrição: " + Alltrim(TTRA->B1_DESC),oFnt2)
			nAlt += 60
			
			nQuant := 0
			TTRA->(DbSkip() )
			cCod := TTRA->ZBB_COD
			Loop
		EndIf
	Else
		nAlt := 60
		nCont := 1
		oPrn:EndPage()
		oPrn:StartPage()
		_nPags++ // Soma um a cada nova página aberta
		Cabecalho()
	EndIf
	cCod := TTRA->ZBB_COD
	TTRA->(DbSkip() )
	SB1->(DbSkip() )
EndDo

oPrn:Preview()
oPrn:EndPage()

Return(nil)

Static Function Cabecalho()
Local _cEmpr := ""

If SM0->M0_CODIGO == "FN"
	_cEmpr := "Fundição"
Elseif SM0->M0_CODIGO == "NH"
	_cEmpr := "Usinagem"
EndIf

oPrn:Say(nAlt,nLar , "Empresa: " + _cEmpr, oFnt1)
If mv_par07 == 1
	oPrn:Say(nAlt,nLar + 350,"    TRANSFERÊNCIA DE PEÇAS FORJARIA/USINAGEM - DE  " + DTOC(mv_par05) + " ATÉ " + DTOC(mv_par06) ,oFnt1)
Elseif mv_par07 == 2
	oPrn:Say(nAlt,nLar + 350,"    TRANSFERÊNCIA DE PEÇAS FUNDIÇÃO/USINAGEM - DE  " + DTOC(mv_par05) + " ATÉ " + DTOC(mv_par06) ,oFnt1)
EndIf
oPrn:Say(nAlt,nLar + 2070,"Dia: " + DTOC(DATE() ),oFnt1)

oPrn:Say(nAlt + 60, nLar , "Hora: " + Time(), oFnt1)
oPrn:Say(nAlt + 60, nLar + 2070,"Página: " + Alltrim(Str(_nPags)),oFnt1)
oPrn:Line(nAlt + 120,0,nAlt + 120,3400)

oPrn:Say(nAlt + 160, nLar,"Num",oFnt1)
oPrn:Say(nAlt + 160, nLar + 240,"Data ",oFnt1)
/*oPrn:Say(nAlt + 160, nLar + 415,"Produto",oFnt1)
oPrn:Say(nAlt + 160, nLar + 800,"Descrição",oFnt1)*/
oPrn:Say(nAlt + 160, nLar + 597,"Vol.",oFnt1)
oPrn:Say(nAlt + 160, nLar + 980,"Quant",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1360,"Cor. WHB",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1690,"Cor. MP",oFnt1)
oPrn:Line(nAlt + 210,0,nAlt + 210,3400)

Return

Static Function Query()
Local cQuery := ""

cQuery := "SELECT ZBA_NUM,ZBA_DATA,ZBB_COD,B1_DESC,ZBB_VOLUME,ZBB_QUANT, ZBB_CORPRD ,ZBB_CORMP
cQuery += " FROM  " + RetSqlName("ZBA") + " BA , " + RetSqlName("ZBB") + " BB, " + RetSqlName("SB1") + " B1 "
cQuery += " WHERE BA.ZBA_NUM = BB.ZBB_NUM "
If mv_par07 == 1 // Forjaria/Usinagem
	cQuery += " AND B1.B1_GRUPO = 'PA04' "
ElseIf mv_par07 == 2 // Fundição/Usinagem
	cQuery += " AND B1.B1_GRUPO = 'PA01' "
EndIf
cQuery += " AND BB.ZBB_COD Between '" + mv_par01 + "' AND '" + mv_par02 + "' "
cQuery += " AND BB.ZBB_CORPRD BetWeen '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery += " AND BA.ZBA_DATA BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "           
cQuery += " AND B1.B1_COD = BB.ZBB_COD " 
cQuery += " AND BB.ZBB_FILIAL = '" + xFilial("ZBB") + "' AND BA.ZBA_FILIAL = '" + xFilial("ZBA") + "' "
cQuery += " AND B1.B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += " AND BA.D_E_L_E_T_ = '' AND BB.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY BB.ZBB_COD,BA.ZBA_DATA "

TCQUERY cQuery NEW ALIAS "TTRA"
MemoWrit("D:\Temp\fQueryRelatorio.sql",cQuery)
TTRA->(DbGoTop() )

SG1->(DbSetOrder(1) )



Return      
