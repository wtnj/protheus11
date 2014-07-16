
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST192 Autor:José Henrique M Felipetto º Data ³ 10/24/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de Transferências                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EST                                                        º±±
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

User Function NHEST192()   
Local aPergs := {} // Array com as Perguntas
Private lRet := .T.
Private _nPags := 1 // Controle de Páginas 

oPrn := tAvPrinter():New("Protheus") // Instancia oPrn na classe tAvPrinter, para utilização dos métodos da classe.
oPrn:StartPage() // Inicia a Página

	oRelato          := Relatorio():New() // Instancia na variavel oRelato a Classe Relatorio.
	
	oRelato:cPerg := "EST192"
	
	aAdd(aPergs,{"De Produto"  ,"C", 30,0,"G",""      ,""       ,"","","","SB1",""    }) //mv_par01
	aAdd(aPergs,{"Ate Produto" ,"C", 30,0,"G",""      ,""       ,"","","","SB1",""    }) //mv_par02
	aAdd(aPergs,{"De Grupo "        ,"C", 4,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par03
	aAdd(aPergs,{"Ate Grupo "       ,"C", 4,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par04
	aAdd(aPergs,{"Origem "       ,"C", 2,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par05
	aAdd(aPergs,{"Destino "       ,"C", 2,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par06
	aAdd(aPergs,{"De data "       ,"D", 20,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par07
	aAdd(aPergs,{"Ate data "       ,"D", 20,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par08
	
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

	if SELECT("TTRA2") > 0
		TTRA2->(DbCloseArea() )
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


Processa({|| fQuerySaida() }, "Trazendo dados para relatório") // Query que pega tudo o que saiu do armazém origem

ProcRegua(0)

Cabecalho()

While TTRA->( !EOF() )

	IncProc()
	
	if SELECT("TTRA2") > 0
		TTRA2->(DbCloseArea() )
	EndIf
	
	// A cada Iteração do While, ele pega o que entro no armazém destino de acordo com o Produto que está corrente.
	QueryEntrada()
	
	// Se a Query for vazia, ele passa pro próximo passo.
	If TTRA2->(EOF() )
		TTRA->(DbSkip() )
		loop
	EndIf

	/* Se a Query trazer algo, verifica se o armazém ENCONTRADO é diferente do amz destino que o usuário digitou.
	Se Sim, pula pro próximo código, senão escreve os dados no relatório. */
	While TTRA2->(!EOF())
		If TTRA2->D3_LOCAL != mv_par06
			TTRA2->(DbSkip() )
			Loop
		EndIf
		TTRA2->(DbSkip() )
	EndDo

	If nCont <= 42 // Se o número de registros for maior que 35, abre uma nova página, senao escreve na página.
		oPrn:Say(nAlt + 300,nLar,TTRA->D3_COD,oFnt2)
		oPrn:Say(nAlt + 300,nLar + 400,TTRA->B1_DESC,oFnt2)
		oPrn:Say(nAlt + 300,nLar + 1200,TTRA->D3_GRUPO,oFnt2)
		oPrn:Say(nAlt + 300,nLar + 1600,DTOC(TTRA->D3_EMISSAO),oFnt2)
		oPrn:Say(nAlt + 300,nLar + 2150,Alltrim(Str(TTRA->D3_QUANT)),oFnt2,,,,1)
		oPrn:Say(nAlt + 300,nLar + 2400 ,TTRA->D3_DOC,oFnt2)
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
oPrn:Say(nAlt,nLar + 1050,"TRANSFERÊNCIA DE PRODUTOS DE " + DTOC(mv_par07) + " ATE " + DTOC(mv_par08) ,oFnt1)
oPrn:Say(nAlt,nLar + 3090,"Dia: " + DTOC(DATE() ),oFnt1)

oPrn:Say(nAlt + 60, nLar , "Hora: " + Time(), oFnt1)
oPrn:Say(nAlt + 60, nLar + 3100,"Página: " + Alltrim(Str(_nPags)),oFnt1)
oPrn:Say(nAlt + 60, nLar + 1330,"Do Local " + mv_par05 + " para " + mv_par06 )
oPrn:Line(nAlt + 120,0,nAlt + 120,3400)

oPrn:Say(nAlt + 160, nLar,"Cod. Produto",oFnt1)
oPrn:Say(nAlt + 160, nLar + 400,"Descrição ",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1200,"Grupo",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1620,"Data",oFnt1)
oPrn:Say(nAlt + 160, nLar + 2000,"Quantidade",oFnt1)
oPrn:Say(nAlt + 160, nLar + 2400,"Documento",oFnt1)

oPrn:Line(nAlt + 210,0,nAlt + 210,3400)

Return

Static Function fQuerySaida()

// Saida
cQuery := "SELECT D3_COD,B1_DESC,D3_GRUPO,D3_EMISSAO,D3_QUANT,D3_DOC,D3_NUMSEQ FROM SD3FN0 D3 (NOLOCK),SB1FN0 B1(NOLOCK) "
cQuery += " WHERE D3_COD BETWEEN '" + Alltrim(mv_par01) + "' AND '" + Alltrim(mv_par02) + "' "
cQuery += " AND D3_GRUPO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery += " AND D3_EMISSAO BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "' "
cQuery += " AND D3_TM > '500' AND D3_LOCAL = '" + mv_par05 + "' "
cQuery += " AND D3_COD = B1_COD "
cQuery += " AND D3.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
cQuery += " AND D3_CF IN ('RE4','DE4') "
cQuery += " ORDER BY D3_EMISSAO,D3_COD,D3_QUANT "
TCQUERY cQuery NEW ALIAS "TTRA"
TcSetField("TTRA","D3_EMISSAO","D")  // Muda a data de string para date
MemoWrit("D:\Temp\fQuerySaida.sql",cQuery)
TTRA->(DbGoTop() )

Return

Static Function QueryEntrada()

cQuery2 := "SELECT D3_LOCAL FROM SD3FN0 D3 (NOLOCK) "
cQuery2 += " WHERE D3_COD = '" + TTRA->D3_COD + "' "
cQuery2 += " AND D3.D_E_L_E_T_ = '' AND D3_TM < '500' "
cQuery2 += " AND D3_NUMSEQ = '" + TTRA->D3_NUMSEQ + "' "
cQuery2 += " AND D3_CF IN ('RE4','DE4') " // Somente transferencias entre locais
TCQUERY cQuery2 NEW ALIAS "TTRA2" 
MemoWrit("D:\Temp\fQueryEntrada.sql",cQuery2)
TTRA2->(DbGoTop() )

Return      

Static Function fVerVazios()
Local lRet := .T.
	
	if Empty(mv_par05)
		alert("Campo Origem deve ser preenchido! ")
		lRet := .F.
		Return  .F.
	EndIf
	If Empty(mv_par06)
		alert("Campo Destino deve ser preenchido! ")
		lRet := .F.
		Return  .F.
	EndIf
	if Empty(mv_par02)
		alert("Campo até produto deve ser preenchido! ")
		lRet := .F.
		Return .F.
	EndIf
	If Empty(mv_par04)
		alert("Campo até Grupo deve ser preenchido! ")
		lRet := .F.
		Return .F.
	EndIf
		

Return




