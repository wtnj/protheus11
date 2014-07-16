
#include 'topconn.ch'
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHCOM015 ºAutor ³João Felipe da Rosa º Data ³  06/08/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressao dos aprovadores                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHCOM015()


cString   := "ZAA"
cDesc1    := OemToAnsi("Este relatório tem por objetivo")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM015"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE APROVADORES ")
cabec1    := OemToAnsi(" Grupo  Descrição                      Tipo  C/Contabil C.Custo   Local Aprovador  Nome do Usuário                Aprova                    Ordem")
cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHCOM015"
_cPerg    := "COM015"
aOrd      := {OemToAnsi("Por Usuario"),OemToAnsi("Por Grupo"),OemToAnsi("Por Tipo")}

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,tamanho)

Pergunte(_cPerg,.F.)

if nlastKey ==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

set filter to
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()
//-----------------------------------------------------------------------
//  monta a query para o ZAA
//-----------------------------------------------------------------------

cQuery := " SELECT * FROM " + RetSqlName('ZAA ')
cQuery += " WHERE D_E_L_E_T_ = ''"
cQuery += " AND ZAA_LOGIN BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND ZAA_GRUPO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
If aReturn[8] == 1
	cQuery += " ORDER BY ZAA_LOGIN"  //ordena por aprovador
Elseif aReturn[8] == 2
	cQuery += " ORDER BY ZAA_GRUPO"  //ordena por grupo
Elseif aReturn[8] == 3
	cQuery += " ORDER BY ZAA_TIPO"  //ordena por tipo
Endif

MemoWrit('C:\TEMP\NHCOM015.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TRA1'

If	! USED()
	MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

Return
Static Function RptDetail()

Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
SBM->(DbSetOrder(1))

DbSelectArea('TRA1')
While TRA1->( ! Eof() )
	if Prow() > 60
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
	Endif
	if SBM->(DbSeek(xFilial("SBM")+ TRA1->ZAA_GRUPO))
		@ Prow ()+1,001 Psay  TRA1->ZAA_GRUPO // Grupo
		@ Prow ()  ,008 Psay SBM->BM_DESC
		@ Prow ()  ,039 Psay TRA1->ZAA_TIPO   // Tipo
		@ Prow ()  ,045 Psay TRA1->ZAA_CONTA // Conta Contabil
		@ Prow ()  ,057 Psay TRA1->ZAA_CC    // Centro de Custo
		@ Prow ()  ,067 Psay TRA1->ZAA_lOCAL // Local
		@ Prow ()  ,073 Psay TRA1->ZAA_LOGIN // Login
		@ Prow ()  ,084 Psay fNameUser(TRA1->ZAA_LOGIN) // Login
		//    	@ Prow ()  ,075 Psay Iif (TRA1->ZAA_CONTRA =="S","Sim",OemToAnsi("Não")) // Contrato S=SIM/N=NAO
		@ Prow ()  ,115 Psay Iif (TRA1->ZAA_GERA$"1",OemToAnsi("Solicitação de Compra"),Iif(TRA1->ZAA_GERA$"2",OemToAnsi("Pedido em Aberto"),Iif(TRA1->ZAA_GERA$"3",OemToAnsi("Autorização de Entrega")," ")))
		@ Prow ()  ,141 Psay  TRA1->ZAA_ORDEM // Ordem
	Endif
	
	TRA1->(DbSkip())
ENDDO
@ Prow()+2,000 PSAY __PrtThinLine()
Return(nil)

Static Function fNameUser(cUsuario)
Local aArray := {}
/*
Ordem Chave
1     ID
2     Nome
3     Senha
*/
PswOrder(2)
If PswSeek( cUsuario, .T. )
	aArray  := PswRet()
	cRetorno:= aArray[1,4 ] // Nome completo
EndIf
Return(cRetorno)
