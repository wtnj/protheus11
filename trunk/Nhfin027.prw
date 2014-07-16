/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN027  บAutor  ณMarcos R. Roquitski บ Data ณ  23/04/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Faturas geradas a partir de NFs                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhFin027()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nTotVlr,nTotFat")

cString   := "SE1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir, ")
cDesc2    := OemToAnsi("Faturas geradas a partir de Notas Fiscais.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN027"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Relatorio de Faturas/Notas Fiscais"
Cabec1    := " Prf Numero   P  Cliente                                    Emissao    Vencto               Valor"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN027"
_cPerg    := "FIN027"
nTotVlr   := 0
nTotFat   := 0
                  
AjustaSx1()

If !Pergunte('FIN027',.T.)
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

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Return


Static Function Gerando()
	cQuery := "SELECT E1.E1_PREFIXO,E1.E1_NUM,E1.E1_PARCELA,E1.E1_EMISSAO,E1.E1_VENCREA,E1.E1_CLIENTE,"
   cQuery := cQuery + "E1.E1_VALOR,E1.E1_LOJA,A1.A1_NOME,A1.A1_COD,A1.A1_LOJA,E1.E1_LOJA,E1.E1_FATURA"
   cQuery := cQuery + " FROM " + RetSqlName( 'SE1' ) + " E1, " + RetSqlName( 'SA1' ) + " A1 "
   cQuery := cQuery + "WHERE E1.D_E_L_E_T_ <> '*' "
   cQuery := cQuery + "AND E1.E1_EMISSAO BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' "
   cQuery := cQuery + "AND E1.E1_VENCREA BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' "
   cQuery := cQuery + "AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA AND A1.D_E_L_E_T_ <> '*'"
   cQuery := cQuery + "AND E1.E1_FATURA <> '' AND E1.E1_FATURA = 'NOTFAT' "
   cQuery := cQuery + " ORDER BY E1.E1_NUM ASC"

	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","E1_EMISSAO","D") // Muda a data de string para date.
	TcSetField("TMP","E1_VENCREA","D") // Muda a data de string para date.
	
Return                                   


Static Function RptDetail()

SE1->(DbSetOrder(16))

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
   Endif
   @ Prow() + 1, 001 Psay TMP->E1_PREFIXO
	@ Prow()    , 005 Psay TMP->E1_NUM
	@ Prow()    , 014 Psay TMP->E1_PARCELA
	@ Prow()    , 017 Psay TMP->A1_NOME
	@ Prow()    , 060 Psay TMP->E1_EMISSAO Picture "99/99/9999"
	@ Prow()    , 071 Psay TMP->E1_VENCREA Picture "99/99/9999"
	@ Prow()    , 083 Psay TMP->E1_VALOR   Picture "@E 999,999,999.99"

   SE1->(DbSeek(xFilial("SE1")+TMP->E1_NUM))
	While !SE1->(Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_FATURA == TMP->E1_NUM
		If SE1->E1_CLIENTE == TMP->E1_CLIENTE .and. SE1->E1_LOJA == TMP->E1_LOJA
		   @ Prow() + 1, 001 Psay SE1->E1_PREFIXO
			@ Prow()    , 005 Psay SE1->E1_NUM
			@ Prow()    , 014 Psay SE1->E1_PARCELA
			@ Prow()    , 060 Psay SE1->E1_EMISSAO Picture "99/99/9999"
			@ Prow()    , 071 Psay SE1->E1_VENCREA Picture "99/99/9999"
			@ Prow()    , 083 Psay SE1->E1_VALOR   Picture "@E 999,999,999.99"
			nTotFat := nTotFat + SE1->E1_VALOR
      Endif
      SE1->(DbSkip())
	Enddo
	If nTotFat > 0
		@ Prow()+2,083 Psay nTotFat Picture "@E 999,999,999.99"
		@ Prow()+1,001 Psay Replicate("-",232)
		nTotFat := 0
	Endif
	nTotVlr := nTotVlr + TMP->E1_VALOR
	TMP->(DbSkip())
Enddo      
@ Prow()+003, 001 Psay "Total Geral ......................................."
@ Prow()    , 083 Psay nTotVlr   Picture "@E 999,999,999.99"
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

cPerg   := "FIN027"
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

aadd(aRegs,{cPerg,"01","de Emissao       ?","de Emissao       ?","de Emissao       ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","ate Emissao      ?","ate Emissao      ?","ate Emissao      ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","de Vencimento    ?","de Vencimento    ?","de Vencimento    ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","ate Vencimento   ?","ate Vencimento   ?","ate Vencimento   ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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
                           
