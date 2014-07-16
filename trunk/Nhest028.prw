/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHEST028  บAutor  ณMarcos R Roquitski  บ Data ณ  28/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Refugos.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst028()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,cFilterUser,aImpRel")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,nPos,nSaldoB2,x,nFaltas,nConsumo")

cString   := "SD3"
cDesc1    := OemToAnsi("LISTA DE REFUGOS DO ALMOXARIFADO")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST028"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "LISTA DE REFUGO DO ALMOXARIFADO "
Cabec1    := "CARACTERISTICA DO DEFEITO                                                                                                      Total"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST028"
_cPerg    := ""
aImpRel   := {}

AjustaSx1()

If !Pergunte('EST028',.T.)
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

Static Function Gerando()

	cQuery := "SELECT D3.D3_DEFEITO,Z6.Z6_DESC,D3.D3_CARDEF,Z8.Z8_DESC,STR(SUM(D3.D3_QUANT),12,2) AS 'QTDE' "
	cQuery += "FROM " + RetSqlName( 'SD3' ) +" D3, " + RetSqlName( 'SZ6' ) +" Z6, " + RetSqlName( 'SZ8' ) +" Z8, " + RetSqlName( 'SB1' ) +" B1 "
	cQuery += "WHERE D3.D3_FILIAL = '" + xFilial("SD3")+ "' "
	cQuery += "AND Z6.Z6_FILIAL = '" + xFilial("SZ6")+ "' "
	cQuery += "AND Z8.Z8_FILIAL = '" + xFilial("SZ8")+ "' "
	cQuery += "AND B1.B1_FILIAL = '" + xFilial("SB1")+ "' "
	cQuery += "AND D3.D3_FILIAL = Z6.Z6_FILIAL AND D3.D3_DEFEITO = Z6.Z6_COD AND D3.D3_FILIAL = Z8.Z8_FILIAL "
	cQuery += "AND D3.D3_CARDEF = Z8.Z8_COD AND D3.D3_COD = B1.B1_COD AND D3.D3_TM IN ('499','002') "
	cQuery += "AND D3.D3_EMISSAO BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' AND D3.D_E_L_E_T_ = ' ' "  
	cQuery += "AND D3.D3_COD BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' "
	cQuery += "AND D3.D3_DEFEITO <> ' ' "
	cQuery += "AND D3.D3_CARDEF <> ' ' "
	cQuery += "AND D3.D3_ESTORNO <> 'S' "
    cQuery += "AND D3.D3_LOCAL = '" + Mv_par05 + "' "
	cQuery += "AND D3.D3_LOCORIG NOT IN ('02','03') AND D3.D_E_L_E_T_ = ' ' AND Z6.D_E_L_E_T_ = ' ' AND Z8.D_E_L_E_T_ = ' ' "
	cQuery += "AND B1.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY D3.D3_DEFEITO,Z6.Z6_DESC,D3.D3_CARDEF,Z8.Z8_DESC "
	cQuery += "ORDER BY 5 DESC "

	TCQUERY cQuery NEW ALIAS "TMP"  

Return

Static Function RptDetail()
Local _nTot := 0, i := 0

titulo += Mv_Par05 + " DO PERIODO "+Dtoc(mv_par01) + " A " + Dtoc(mv_par02)

Cabec1 := Space(40) + "PRODUTO DE " + Alltrim(Mv_Par03) + " ATE " + Mv_Par04
Cabec2 := "CARACTERISTICA DO DEFEITO                                                                                                      Total"
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
TMP->(DbGoTop())
While TMP->(!Eof())
	ProcRegua(TMP->(RecCount()))
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
    @ Prow()  +01 , 001 pSay Alltrim(TMP->D3_CARDEF) + Alltrim(TMP->D3_DEFEITO) + " - " + Alltrim(TMP->Z8_DESC) + " " + Alltrim(TMP->Z6_DESC)
	@ Prow()      , 125 pSay Val(TMP->QTDE) Picture "999999"
	_nTot  += Val(TMP->QTDE)
	TMP->(DbSkip())
Enddo
@ Prow() + 1, 001 Psay __PrtThinLine()
@ Prow() + 1, 001 Psay "TOTAL GERAL"
@ Prow()    , 125 Psay _nTot Picture "999999"
@ Prow() + 1, 001 Psay __PrtThinLine()


Return(nil)




Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := Space(10)
cPerg   := "EST028    "
aRegs   := {}

aadd(aRegs,{cPerg,"01","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","do Produto       ?","do Produto       ?","do Produto       ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegs,{cPerg,"04","ate Produto      ?","ate Produto      ?","ate Produto      ?","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegs,{cPerg,"05","Almoxarifado     ?","Almoxarifado     ?","Almoxarifado     ?","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf                   

dbSelectArea(_sAlias)

Return
