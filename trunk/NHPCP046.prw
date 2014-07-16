
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCP046 Autor:Jos� Henrique M Felipetto Data: 28/12/11       ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Inclui Bibliotecas de fun��es do Protheus
#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#include "protheus.ch"        



User Function NHPCP046()
Local aPergs := {} // Array com as Perguntas
Private lRet := .T.
Private _nPags := 1 // Controle de P�ginas 

oPrn := tAvPrinter():New("Protheus") // Instancia oPrn na classe tAvPrinter, para utiliza��o dos m�todos da classe.
oPrn:StartPage() // Inicia a P�gina

	oRelato          := Relatorio():New() // Instancia na variavel oRelato a Classe Relatorio.
	
	oRelato:cPerg := "PCP046"
	
	aAdd(aPergs,{"De data "       ,"D", 20,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par01
	aAdd(aPergs,{"Ate data "       ,"D", 20,0,"G",""      ,""       ,"","","",""   ,""    }) //mv_par02
	//aAdd(aPergs,{"Opera��o "       ,"C", 02,0,"G",""      ,""       ,"","","","ZEK"   ,""    }) //mv_par03
	
	oRelato:AjustaSx1(aPergs) // Funcao que pega o Array aPergs e cadastra as perguntas no SX1		    
	
	If Pergunte(oRelato:cPerg,.T.)
		fVerVazios() // Fun��o que verifica campos obrigat�rios vazios que o usu�rio digitou
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

//���������������������Ŀ
//� FUNCAO DE IMPRESSAO �
//�����������������������
Static Function Imprime()
Local cVar
Local nCont := 1 // Vari�vel que controla o n�mero de registros escritos
Local cConfirm := .T.
nAlt := 20 
nLar := 20 

oFnt1 		:= TFont():New("Arial"		,,11,,.T.,,,,,.F.) // Instancia da Classe tFont
oFnt2 		:= TFont():New("Arial"		,,11,,.F.,,,,,.F.)


Processa({|| Query() }, "Trazendo dados para relat�rio") // Query que pega tudo o que saiu do armaz�m origem

ProcRegua(0)

Cabecalho()

While TTRA->( !EOF() ) 

	IncProc()
	If nCont <= 42 // Se o n�mero de registros for maior que 35, abre uma nova p�gina, senao escreve na p�gina.
		oPrn:Say(nAlt + 300,nLar,TTRA->ZEJ_COD,oFnt2)
		oPrn:Say(nAlt + 300,nLar + 400,Str(TTRA->ZEJ_OPERA),oFnt2)
		oPrn:Say(nAlt + 300,nLar + 800,TTRA->ZEJ_OP,oFnt2)
		oPrn:Say(nAlt + 300,nLar + 1220,Alltrim(Str(TTRA->ZEJ_QUANT)),oFnt2)
		//oPrn:Say(nAlt + 300,nLar + 2150,Alltrim(Str(TTRA->D3_QUANT)),oFnt2,,,,1)
		//oPrn:Say(nAlt + 300,nLar + 2400 ,TTRA->D3_DOC,oFnt2)
		//oPrint:Say(100,200,"TEXTO",oFont12,, CLR_HRED,,1)                    
		nCont++
		nAlt += 60
	Else
		nAlt := 60
		nCont := 1
		oPrn:EndPage()
		oPrn:StartPage()
		_nPags++ // Soma um a cada nova p�gina aberta
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
	_cEmpr := "Fundi��o"
Elseif SM0->M0_CODIGO == "NH"
	_cEmpr := "Usinagem"
EndIf

oPrn:Say(nAlt,nLar , "Empresa: " + _cEmpr, oFnt1) 
oPrn:Say(nAlt,nLar + 1050,"APONTAMENTO DE PRODU��O DE  " + DTOC(mv_par01) + " AT� " + DTOC(mv_par02) ,oFnt1)
oPrn:Say(nAlt,nLar + 3090,"Dia: " + DTOC(DATE() ),oFnt1)

oPrn:Say(nAlt + 60, nLar , "Hora: " + Time(), oFnt1)
oPrn:Say(nAlt + 60, nLar + 3100,"P�gina: " + Alltrim(Str(_nPags)),oFnt1)
oPrn:Line(nAlt + 120,0,nAlt + 120,3400)

oPrn:Say(nAlt + 160, nLar,"Produto",oFnt1)
oPrn:Say(nAlt + 160, nLar + 390,"Opera��o ",oFnt1)
oPrn:Say(nAlt + 160, nLar + 785,"Ordem de Produ��o",oFnt1)
oPrn:Say(nAlt + 160, nLar + 1205,"Quantidade",oFnt1)
oPrn:Line(nAlt + 210,0,nAlt + 210,3400)

Return

Static Function Query()

cQuery := " SELECT ZEJ_COD,ZEJ_OPERA,ZEJ_OP,ZEJ_QUANT FROM  " + RetSqlname("ZEJ") + " ZG "
cQuery += " WHERE ZG.ZEJ_DATA BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "' "
cQuery += " AND ZG.ZEJ_FILIAL = '" + xFilial("ZEJ") + "' AND ZG.D_E_L_E_T_ = '' "
cQuery += " ORDER BY ZEJ_OPERA "
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




