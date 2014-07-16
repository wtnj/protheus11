/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCP047 Autor:José Henrique M Felipetto Data: 29/12/11       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Inclui Bibliotecas de funções do Protheus
#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#include "protheus.ch"        



User Function NHPCP047()
Local aPergs := {} // Array com as Perguntas
Private lRet := .T.
Private _nPags := 1 // Controle de Páginas 

oPrn := tAvPrinter():New("Protheus") // Instancia oPrn na classe tAvPrinter, para utilização dos métodos da classe.
oPrn:StartPage() // Inicia a Página

	oRelato          := Relatorio():New() // Instancia na variavel oRelato a Classe Relatorio.
	
	oRelato:cPerg := "PCP047"
	
	aAdd(aPergs,{"De data "       ,"D", 20,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par01
	aAdd(aPergs,{"Ate data "       ,"D", 20,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par02
//	aAdd(aPergs,{"De Produto "       ,"C", 15,0,"G",""      ,""       ,"","","","KKK"   ,""    }) //mv_par02
	//aAdd(aPergs,{"Operação "       ,"C", 02,0,"G",""      ,""       ,"","","","ZEK"   ,""    }) //mv_par03
	
	oRelato:AjustaSx1(aPergs) // Funcao que pega o Array aPergs e cadastra as perguntas no SX1		    
	
	If Pergunte(oRelato:cPerg,.T.)
		fVerVazios() // Função que verifica campos obrigatórios vazios que o usuário digitou
		if lRet
			Processa({||Imprime()},"Imprimindo...")
		Else
			Return .F.			
		EndIf
	Else
		Return .F.
	EndIf
	

	TTRA->(DbCloseArea() )
	oPrn:End()   // Termina
	
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

cOp := TTRA->D3_OP 
While TTRA->( !EOF() )
	If cOp == TTRA->D3_OP
		IncProc()
		If nCont <= 42 // Se o número de registros for maior que 35, abre uma nova página, senao escreve na página.
			oPrn:Say(nAlt + 300,nLar,TTRA->D3_COD,oFnt2)
			oPrn:Say(nAlt + 300,nLar + 400,TTRA->D3_OP,oFnt2)
			oPrn:Say(nAlt + 300,nLar + 800,Alltrim(Str(TTRA->D3_QUANT)),oFnt2)
			oPrn:Say(nAlt + 300,nLar + 1220,TTRA->D3_GRUPO,oFnt2)
			oPrn:Say(nAlt + 300,nLar + 1615,TTRA->D3_LOCAL,oFnt2,,,,1)
			If TTRA->D3_TM == '101'
				oPrn:Say(nAlt + 300,nLar + 1970 ,TTRA->D3_TM + " <-- Ap. Produção ",oFnt2)
			ElseIf TTRA->D3_TM > '500'
				oPrn:Say(nAlt + 300,nLar + 1970 ,TTRA->D3_TM + " <-- Saída ",oFnt2)
			elseIf TTRA->D3_TM < '500'
				oPrn:Say(nAlt + 300,nLar + 1970 ,TTRA->D3_TM + " <-- Entrada ",oFnt2)
			EndIf
			//oPrint:Say(100,200,"TEXTO",oFont12,, CLR_HRED,,1)                    
			nCont++
			nAlt += 60
		Else
			nAlt := 60
			nCont := 1
			oPrn:EndPage()
			oPrn:StartPage()
			_nPags++ // Soma um a cada nova página aberta
			Cabecalho()
		EndIf
		TTRA->(DbSkip() )	
		cOp := TTRA->D3_OP
	Else
		oPrn:Line(nAlt + 300,10,nAlt + 300,2000)
		TTRA->(DbSkip() )
		cOp := TTRA->D3_OP
	EndIf
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
oPrn:Say(nAlt,nLar + 1050,"MOVIMENTAÇÃO DE PRODUÇÃO DE  " + DTOC(mv_par01) + " ATÉ " + DTOC(mv_par02) ,oFnt1)
oPrn:Say(nAlt,nLar + 3090,"Dia: " + DTOC(DATE() ),oFnt1)

oPrn:Say(nAlt + 60, nLar , "Hora: " + Time(), oFnt1)
oPrn:Say(nAlt + 60, nLar + 3100,"Página: " + Alltrim(Str(_nPags)),oFnt1)
oPrn:Line(nAlt + 120,0,nAlt + 120,3400)

oPrn:Say(nAlt + 160, nLar,"Produto",oFnt1)
oPrn:Say(nAlt + 160, nLar + 390,"Ordem de Produção ",oFnt1)
oPrn:Say(nAlt + 160, nLar + 785,"Quantidade",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1205,"Grupo",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1580,"Local",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1950,"Tp.Mv",oFnt1)
oPrn:Line(nAlt + 210,0,nAlt + 210,3400)

Return

Static Function Query()

cQuery := "SELECT D3_COD,D3_OP,D3_QUANT,D3_GRUPO,D3_LOCAL,D3_TM FROM " + RetSqlName("SD3") + " D3 "
cQuery += " WHERE D3.D3_LOCAL BETWEEN '40' AND '50' "
cQuery += " AND D3.D3_EMISSAO BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "' "
cQuery += " AND D3.D3_FILIAL = '" + xFilial("SD3") + "' AND D3.D_E_L_E_T_ = '' "
cQuery += " AND D3.D3_ESTORNO <> 'S' "
TCQUERY cQuery NEW ALIAS "TTRA" 
MemoWrit("D:\Temp\fQueryRelatorio.sql",cQuery)
TTRA->(DbGoTop() )

Return      

Static Function fVerVazios()
Local lRet := .T.
	
	if Empty(mv_par01)
		alert("Campo Origem deve ser preenchido! ")
		lRet := .F.
		Return  .F.
	EndIf
	If Empty(mv_par02)
		alert("Campo Destino deve ser preenchido! ")
		lRet := .F.
		Return  .F.
	EndIf
	
Return





