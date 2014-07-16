/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN039  บAutor  ณMarcos R. Roquitski บ Data ณ  31/05/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Titulos Pagos por Produto.                      ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhFin039()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nTotVlr,nTotFat,nVlItem,nQtItem")

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
Cabec1    := " Prf Numero   P  Produto         Descricao Produto                              Cliente   Nome                                       Qtde       T.Produto  Vencto      Dt.Pagto          Vl.Fatura          Vl.Pago   Tipo"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHFIN039"
_cPerg    := "FIN039"
nTotVlr   := 0
nTotFat   := 0
                 
//AjustaSx1()

If !Pergunte('FIN039',.T.)
   Return(nil)
Endif
titulo    := "Titulos pagos por Produto De: "+mv_par01 +"  ate   "+mv_par02
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
   
   /*
	cQuery := "SELECT E1.E1_VENCTO,E1.E1_VENCREA, E1.E1_VALOR, E1.E1_NUM, E1.E1_PREFIXO,E5.E5_PREFIXO,E5.E5_NUMERO,"
	cQuery += "E5.E5_CLIFOR, E5.E5_VALOR,A1.A1_COD,A1.A1_DESC,B1.B1_COD,B1.B1_DESC,E5.E5_TIPODOC,A1.A1_LOJA,A1.A1_NOME,D2.D2_DOC,"
	cQuery += "E5.E5_RECPAG,D2.D2_COD,D2.D2_QUANT,D2.D2_TOTAL,D2.D2_LOJA,D2.D2_CLIENTE,D2.D2_SERIE,E1.E1_PARCELA,E1.E1_EMISSAO,E5.E5_DATA "
	cQuery += "FROM " + RetSqlName('SE5') + " E5, " + RetSqlName( 'SE1') + " E1," + RetSqlName( 'SD2') +  " D2, " + RetSqlName( 'SA1') +  " A1," + RetSqlName( 'SB1') +  " B1 "
   cQuery += "WHERE E1.E1_VENCREA BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' AND E1.D_E_L_E_T_ <> '*' "
   cQuery += "AND E5.E5_FILIAL = '" + xFilial("SE5")+ "' "
   cQuery += "AND D2.D2_FILIAL = '" + xFilial("SD2")+ "' "
	cQuery += "AND D2.D2_DOC      *= E5.E5_NUMERO "
	cQuery += "AND D2.D2_SERIE    *= E5.E5_PREFIXO "
	cQuery += "AND D2.D2_CLIENTE  *= E5.E5_CLIFOR "
	cQuery += "AND D2.D2_LOJA     *= E5.E5_LOJA "
	cQuery += "AND D2.D2_DOC       = E1.E1_NUM "
	cQuery += "AND D2.D2_CLIENTE   = E1.E1_CLIENTE "
	cQuery += "AND D2.D2_LOJA      = E1.E1_LOJA "
	cQuery += "AND D2.D2_SERIE     = E1.E1_PREFIXO "
	cQuery += "AND D2.D2_CLIENTE   = A1.A1_COD "
	cQuery += "AND D2.D2_LOJA      = A1.A1_LOJA "
	cQuery += "AND D2.D2_COD       = B1.B1_COD "
	cQuery += "AND E5.D_E_L_E_T_ <> '*' "
	cQuery += "AND A1.D_E_L_E_T_ <> '*' "
	cQuery += "AND D2.D2_COD  BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' AND D2.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY E1.E1_NUM ASC "
	TCQUERY cQuery NEW ALIAS "TMP"
	*/
	
	cQuery := "SELECT E1.E1_VENCTO, E1.E1_VENCREA, E1.E1_VALOR, E1.E1_NUM, E1.E1_PREFIXO, E5.E5_PREFIXO, E5.E5_NUMERO, E5.E5_CLIFOR,E5.E5_VALOR, A1.A1_COD, A1.A1_DESC, B1.B1_COD,"
   cQuery += "B1.B1_DESC, E5.E5_TIPODOC, A1.A1_LOJA, A1.A1_NOME, D2.D2_DOC, E5.E5_RECPAG, D2.D2_COD, D2.D2_QUANT, D2.D2_TOTAL, D2.D2_LOJA, D2.D2_CLIENTE, D2.D2_SERIE, E1.E1_PARCELA,"
   cQuery += "E1.E1_EMISSAO, E5.E5_DATA"

	cQuery += " FROM "+ RetSqlName( 'SD2') +  " D2 (NOLOCK) "

	cQuery += " INNER JOIN " + RetSqlName('SE1') + " E1 (NOLOCK) "
	cQuery += " ON  E1.E1_NUM	   = D2.D2_DOC "
	cQuery += " AND E1.E1_CLIENTE = D2.D2_CLIENTE "
	cQuery += " AND E1.E1_LOJA	   = D2.D2_LOJA "
	cQuery += " AND E1.E1_PREFIXO = D2.D2_SERIE "
	cQuery += " AND E1.E1_FILIAL  = D2.D2_FILIAL "
	cQuery += " AND E1.D_E_L_E_T_ = '' "
	cQuery += " AND E1.E1_VENCREA BETWEEN '" + Dtos(Mv_par03) + "' AND '" + Dtos(Mv_par04) + "' "

	cQuery += " INNER JOIN " + RetSqlName('SA1') + " A1 (NOLOCK) "
	cQuery += " ON	A1.A1_COD	    = D2.D2_CLIENTE "
	cQuery += " AND A1.A1_LOJA	    = D2.D2_LOJA "
	cQuery += " AND A1.A1_FILIAL   = '" + xFilial("SA1")+ "' "
	cQuery += " AND A1.D_E_L_E_T_  = '' "

	cQuery += " INNER JOIN " + RetSqlName('SB1') + " B1 (NOLOCK) "
	cQuery += " ON  B1.B1_COD	   = D2.D2_COD "
	cQuery += " AND B1.B1_FILIAL  = '" + xFilial("SB1")+ "' "
	cQuery += " AND B1.D_E_L_E_T_ = '' "

	cQuery += " LEFT JOIN " + RetSqlName('SE5') + " E5 (NOLOCK) "
	cQuery += " ON	E5.E5_NUMERO   = D2.D2_DOC "
	cQuery += " AND E5.E5_PREFIXO = D2.D2_SERIE "
	cQuery += " AND E5.E5_CLIFOR  = D2.D2_CLIENTE "
	cQuery += " AND E5.E5_LOJA	   = D2.D2_LOJA "
	cQuery += " AND E5.E5_FILIAL  = D2.D2_FILIAL "
	cQuery += " AND E5.D_E_L_E_T_ = '' "

	cQuery += " WHERE	D2.D2_FILIAL     = '" + xFilial("SD2")+ "' "
	cQuery += " AND D2.D2_COD BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "
	cQuery += " AND D2.D_E_L_E_T_	    = '' "
	cQuery += " ORDER  BY E1.E1_NUM  ASC "
	
	TCQUERY cQuery NEW ALIAS "TMP"	
	
	TcSetField("TMP","E1_VENCTO","D")  // Muda a data de string para date.
	TcSetField("TMP","E1_VENCREA","D") // Muda a data de string para date.
	TcSetField("TMP","E1_EMISSAO","D") // Muda a data de string para date.
	TcSetField("TMP","E5_DATA","D")    // Muda a data de string para date.
Return
                                                         		
Static Function RptDetail()
Local nTotBco := 0
Local nTotQtd := 0
Local nTotBar := 0               
Local cE1_Num := Space(6)
Local lRet := .T.

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If lRet 
		GeraProd()
		@ Prow() + 1, 001 Psay TMP->E1_PREFIXO
		@ Prow()    , 005 Psay TMP->E1_NUM
		@ Prow()    , 014 Psay TMP->E1_PARCELA
		@ Prow()    , 017 Psay TMP->D2_COD
		@ Prow()    , 033 Psay Substr(TMP->B1_DESC,1,40)
		@ Prow()    , 080 Psay TMP->A1_COD+" "+TMP->A1_LOJA
		@ Prow()    , 090 Psay Substr(TMP->A1_NOME,1,30)
		@ Prow()    , 125 Psay nQtItem              Picture "@E 999,999.9999"
		@ Prow()    , 140 Psay nVlItem              Picture "@E 99,999,999.99"
		@ Prow()    , 155 Psay TMP->E1_EMISSAO      Picture "99/99/9999"
		@ Prow()    , 167 Psay TMP->E5_DATA         Picture "99/99/9999"
		@ Prow()    , 180 Psay TMP->E1_VALOR        Picture "@E 999,999,999.99"
		lRet := .F.
	Endif		
	@ Prow()    , 198 Psay TMP->E5_VALOR   Picture "@E 999,999,999.99"
	@ Prow()    , 214 Psay TMP->E5_TIPODOC Picture "@!"

	nTotVlr += TMP->E1_VALOR
	nTotBco += TMP->E5_VALOR
	nTotQtd += nQtItem
	cE1_Num := TMP->E1_NUM
    nVlItem := 0
	nQtItem := 0

	TMP->(DbSkip())

	    
	If TMP->E1_NUM <> cE1_Num
		@ Prow() + 1, 001 Psay Replicate("-",limite)
		lRet := .T.
	Else
		@ Prow() + 1, 001 Psay Space(01)		
	Endif		
    
    
Enddo
@ Prow()+003, 001 Psay "Total Geral ......................................."
@ Prow()    , 125 Psay nTotQtd  Picture "@E 999,999.9999"
@ Prow()    , 180 Psay nTotVlr  Picture "@E 999,999,999.99"
@ Prow()    , 198 Psay nTotBco  Picture "@E 999,999,999.99"
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


Static Function GeraProd()
	nVlItem := 0
	nQtItem := 0

	// DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+TMP->D2_DOC + TMP->D2_SERIE + TMP->D2_CLIENTE + TMP->D2_LOJA + TMP->D2_COD))
	While !SD2->(Eof()) .And. SD2->D2_DOC == TMP->D2_DOC ;
					    .And. SD2->D2_SERIE == TMP->D2_SERIE ;
					    .And. SD2->D2_CLIENTE == TMP->D2_CLIENTE ;
					    .And. SD2->D2_LOJA == TMP->D2_LOJA ;
   					    .And. SD2->D2_COD == TMP->D2_COD

		nVlItem += SD2->D2_TOTAL
		nQtItem += SD2->D2_QUANT
		SD2->(DbSkip())	
	Enddo
	
Return

Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "FIN039"
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

aadd(aRegs,{cPerg,"01","Produto de       ?","Produto de       ?","Produto de       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Produto ate      ?","Produto ate      ?","Produto Ate      ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Vencto de        ?","Vencto de        ?","Vencto de        ?","mv_ch2","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Vencto ate       ?","Vencto ate       ?","Vencto ate       ?","mv_ch3","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
