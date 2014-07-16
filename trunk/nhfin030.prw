/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN030  บAutor  ณMarcos R. Roquitski บ Data ณ  16/09/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Borderos, gera diferenca Cod.Barra com o        ฑฑ
ฑฑบ          ณlancado no SE2->E2_VALOR.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhFin030()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nTotVlr,nTotFat")

cString   := "SE1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir, ")
cDesc2    := OemToAnsi("diferencas do Valor do Titulo / Valor do Cod. Barra.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN030"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.
lDivPed   := .F.
titulo    := "Relatorio de Diferencas Valor do Titulo / Valor do Cod. Barra"
Cabec1    := " Prf Numero   P  Cliente                                    Emissao    Vencto               Valor      Cod.Barra"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN030"
_cPerg    := "FIN030"
nTotVlr   := 0
nTotFat   := 0
                  
AjustaSx1()

If !Pergunte('FIN030',.T.)
   Return(nil)
Endif
titulo    := "Diferenca Valor do Titulo / Valor do Cod. Barra   -  Bordero No. "+mv_par01
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

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Return

Static Function Gerando()
	cQuery := "SELECT E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_EMISSAO,E2.E2_VENCREA,E2.E2_FORNECE,E2.E2_CODBAR,"
   cQuery := cQuery + "E2.E2_VALOR,E2.E2_LOJA,A2.A2_NOME,A2.A2_COD,A2.A2_LOJA,E2.E2_LOJA,E2.E2_NUMBOR,E2.E2_SALDO "
   cQuery := cQuery + " FROM " + RetSqlName( 'SE2' ) + " E2, " + RetSqlName( 'SA2' ) + " A2 "
   cQuery := cQuery + "WHERE E2.D_E_L_E_T_ <> '*' "
   cQuery := cQuery + "AND E2.E2_NUMBOR = '" + Mv_par01 + "' "
   cQuery := cQuery + "AND A2.A2_COD = E2.E2_FORNECE AND A2.A2_LOJA = E2.E2_LOJA AND A2.D_E_L_E_T_ <> '*' "
   cQuery := cQuery + " ORDER BY E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA ASC"
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","E2_EMISSAO","D") // Muda a data de string para date.
	TcSetField("TMP","E2_VENCREA","D") // Muda a data de string para date.
Return
                                                         		
Static Function RptDetail()
Local nSaldos := 0
Local nTotBar := 0
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
   Endif

	If Len(Alltrim(TMP->E2_CODBAR)) == 44
		nSaldos := Val(Substr(TMP->E2_CODBAR,10,10)) / 100
	Else
		If Len(Substr(TMP->E2_CODBAR,34,4)) == 4 .And. Val(Substr(TMP->E2_CODBAR,38,10)) > 0
			nSaldos := Val(Substr(TMP->E2_CODBAR,38,10)) / 100
		Endif
	Endif
	If (nSaldos <> TMP->E2_SALDO)
		If nSaldos > 0 .AND. TMP->E2_SALDO > 0
		   @ Prow() + 1, 001 Psay TMP->E2_PREFIXO
			@ Prow()    , 005 Psay TMP->E2_NUM
			@ Prow()    , 014 Psay TMP->E2_PARCELA
			@ Prow()    , 017 Psay TMP->A2_NOME
			@ Prow()    , 060 Psay TMP->E2_EMISSAO Picture "99/99/9999"
			@ Prow()    , 071 Psay TMP->E2_VENCREA Picture "99/99/9999"
			@ Prow()    , 083 Psay TMP->E2_SALDO   Picture "@E 999,999,999.99"
			@ Prow()    , 098 Psay nSaldos         Picture "@E 999,999,999.99"
			nTotVlr := nTotVlr + TMP->E2_SALDO
			nTotBar := nTotBar + nSaldos
			nSaldos := 0
		Endif
	Endif
	nSaldos := 0
	TMP->(DbSkip())

Enddo
@ Prow()+003, 001 Psay "Total Geral ......................................."
@ Prow()    , 083 Psay nTotVlr   Picture "@E 999,999,999.99"
@ Prow()    , 098 Psay nTotBar   Picture "@E 999,999,999.99"
@ Prow()+001, 001 Psay ""

DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return(nil)



Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "FIN030"
aRegs   := {}

// VERSAO 508
//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
/*
aadd(aRegs,{cPerg,"01","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})        
aadd(aRegs,{cPerg,"02","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
*/

aadd(aRegs,{cPerg,"01","Bordero          ?","Bordero          ?","Bordero          ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
Endif

dbSelectArea(_sAlias)

Return
                           
