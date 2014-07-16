/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHEST034 บAutor  ณMarcos R Roquitski  บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Custo de EPI por Centro de Custo.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst034()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,cFilterUser")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,nPos,nSaldoB2,x,nFaltas,nConsumo")

cString   := "SZ7"
cDesc1    := OemToAnsi("RELATORIO DE CUSTOS DE EPI")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST034"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "RELATORIO DE EPI POR CENTRO DE CUSTO"
Cabec1    := " C.CUSTO PRODUTO         DESCRICAO                                      QTDE                  V.UNITARIO             V.TOTAL" 
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST034"
_cPerg    := ""

If !Pergunte('NHES31',.T.)
	Return(nil)
Endif   

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver     := ReadDriver()
cCompac     := aDriver[1]
cNormal     := aDriver[2]
cFilterUser := aReturn[7]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros:                                                  ณ
//ณ mv_par01     Da Ficha                                        ณ
//ณ mv_par02     Ate a Ficha                                     ณ
//ณ mv_par03     Do Funcionario                                  ณ
//ณ mv_par04     Ate Funcionario                                 ณ
//ณ mv_par05     Da Data                                         ณ
//ณ mv_par06     Ate a Data                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



Static Function Gerando()

	cQuery := "SELECT Z7_CC,Z7_PRODUTO,SUM(Z7_QUANT) AS QUANT FROM " + RetSqlName( 'SZ7' )
	cQuery += " WHERE Z7_CC BETWEEN '" + Mv_par09 + "' AND '" + Mv_par10 + "' "
	cQuery += " AND Z7_DATA BETWEEN '" + Dtos(Mv_par05) + "' AND '" + Dtos(Mv_par06) + "' AND D_E_L_E_T_ <> '*' "
	cQuery += " GROUP BY Z7_CC,Z7_PRODUTO,Z7_QUANT"
    cQuery += " ORDER BY Z7_CC,Z7_PRODUTO,Z7_QUANT"

	TCQUERY cQuery NEW ALIAS "TMP"

	TcSetField("TMP","Z7_DATA","D") // Muda a data de string para date.

Return

Static Function RptDetail()
Local _cCod   := Space(15),;
      _lRet   := .T.,;
      _nSub   := 0,;
      _nTot   := 0,;
      _nVunit := 0,;
	  _B1Desc := Space(40),;
	  _I3Desc := Space(30)

SI3->(DbSetOrder(1))
SB1->(DbSetOrder(1))
SD1->(DbSetOrder(7))
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
titulo += " DO PERIODO DE " +Dtoc(Mv_par05) + " ATE " + Dtoc(Mv_Par06)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
	
	If _lRet
		@ Prow() + 1, 001 Psay TMP->Z7_CC
		_lRet := .F.
	Endif
	_nVunit := 0
	_B1Desc := Space(40)
	_I3Desc := Space(30)
	SB1->(Dbseek(xFilial("SB1") + TMP->Z7_PRODUTO))
	If SB1->(Found())
		_B1Desc := SB1->B1_DESC
	Endif
	SI3->(Dbseek(xFilial("SI3") + TMP->Z7_CC))
	If SI3->(Found())
		_I3Desc := SI3->I3_DESC
	Endif
	@ Prow() + 1, 001 Psay Alltrim(TMP->Z7_CC) + "  " + TMP->Z7_PRODUTO + " " + _B1Desc
	@ Prow()    , 070 Psay TMP->QUANT Picture "999999"
	SD1->(DbSeek(xFilial("SD1") + TMP->Z7_PRODUTO))
	While !SD1->(Eof()) .and. SD1->D1_COD == TMP->Z7_PRODUTO
		_nVunit := SD1->D1_VUNIT
		If _nVunit > 0
			Exit
		Endif			
		SD1->(DbSkip())	
	Enddo
	@ Prow()    , 090 Psay _nVunit Picture "@E 999,999,999.99"
	@ Prow()    , 110 Psay TMP->QUANT * _nVunit Picture "@E 999,999,999.99"
	_nSub  += TMP->QUANT * _nVunit
	_nTot  += TMP->QUANT * _nVunit
	_cCod  := TMP->Z7_CC

	TMP->(DbSkip())

	If TMP->Z7_CC <> _cCod
		_lRet := .T.
		@ Prow() + 1, 001 Psay __PrtThinLine()
		@ Prow() + 1, 001 Psay "TOTAL DO C. CUSTO "+Alltrim(_cCod)+ " - "+_I3Desc
		@ Prow()    , 110 Psay _nSub Picture "@E 999,999,999.99"
		@ Prow() + 1, 001 Psay __PrtThinLine()
		_nSub := 0
	Endif

Enddo
@ Prow() + 1, 001 Psay "TOTAL GERAL"
@ Prow()    , 110 Psay _nTot Picture "@E 999,999,999.99"
@ Prow() + 1, 001 Psay __PrtThinLine()

Return(nil)
