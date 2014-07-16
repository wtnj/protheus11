/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST170        ³ Alexandre R. Bento    ³ Data ³ 30.01.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do Boletim de Entrada apartir da NF Entrada     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst170()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_CARQDBF,_AFIELDS,_NTGERAL")
SetPrvt("_NTPARCIAL,_CFORNECE,_CLOJA,_NTOTALF,_NAUX,_CNOMEF,_cNaturez,_cRel,_cOrd")
SetPrvt("_DDATA,_CARQNTX,_CORDEM,_NPER,_NPOS,_CCABEC1,M_PAG,_cCla,_ca,_cb,_cc,cTipoNF")
SetPrvt("aAuxCombo1,aCombo1,cPedido")


cString   :="SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Itens que vieram na nota fiscal de Entrada e tambem acusar")
cDesc3    := OemToAnsi("as divergencias com o Pedido de Compras.")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST170"
aLinha    := { }
nLastKey  := 0
lEnd      := .f.
titulo    :="Boletim de Entrada" 
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"

_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1

wnrel  :="NHCOM027"          //Nome Default do relatorio em Disco
_cPerg := "EST170"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)

aAuxCombo1 := {"N","D","B","I","P","C"}
aCombo1	  := {"Normal",;	//"Normal"
   						  "Devolucao",;	//"Devoluçao"
							  "Beneficiamento",;	//"Beneficiamento"
							  "C.ICMS",;	//"Compl.  ICMS"
   						  "C.IPI",;	//"Compl.  IPI"
						     "C.Preco/Frete"}	//"Compl. Preco/frete"



// Parametros Utilizados
// mv_par01 = Da Data
// mv_par02 = Ate a Data
// mv_par03 = regime de caixa ou competencia
// mv_par04 = natureza inicial
// mv_par05 = natureza final          
// mv_par06 = sim 1-analitico   nao 2-Sintetico 
// mv_par07 = 1- Ordem por natureza   2-Ordem por fornecedor

// AjustaSX1() // Verifica os parametros

Pergunte(_cPerg,.f.) //ativa os parƒmetros
 

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

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

Processa( {|| Gerando() },"Gerando Dados para a Impressao")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

//Ferase(_cArqDBF+".DBF")
//Ferase(_cArqNtx+OrdbagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Gerando         ³ M¦ Beatriz B Nocera   ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Executa a Query                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function Gerando()
                                      
   cQuery := "SELECT D1.D1_DOC,D1.D1_SERIE,D1.D1_EMISSAO,D1.D1_FORNECE,D1.D1_CC,D1.D1_DTDIGIT,D1.D1_PEDIDO,"
   cQuery := cQuery + "D1.D1_LOJA,D1.D1_COD,D1.D1_UM,D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL,D1.D1_DESCRI,D1.D1_LOTECTL,"
   cQuery := cQuery + "F1.F1_HORA,F1.F1_TIPO,F1.F1_ESPECIE,F1.F1_BASEICM,F1.F1_VALICM,"
   cQuery := cQuery + "F1.F1_VALIPI,F1.F1_BRICMS,F1.F1_ICMSRET,F1.F1_VALMERC,F1.F1_DESCONT,"
   cQuery := cQuery + "F1.F1_FRETE,F1.F1_SEGURO,F1.F1_DESPESA,F1.F1_VALIPI,F1.F1_VALBRUT,"
   cQuery := cQuery + "A2.A2_NOME,A2.A2_END,A2.A2_MUN,A2.A2_EST,A2.A2_CGC"
   cQuery := cQuery + " FROM " + RetSqlName( 'SD1' ) +" D1, " + RetSqlName( 'SF1' ) +" F1, " + RetSqlName( 'SA2' ) +" A2 "
   cQuery := cQuery + " WHERE F1.F1_DTDIGIT BETWEEN '" + DtoS(Mv_par01) + "' AND '" + DtoS(Mv_par02) + "' AND F1.D_E_L_E_T_ <> '*' "  
   cQuery := cQuery + " AND D1.D1_DOC BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' AND D1.D_E_L_E_T_ <> '*' "
   cQuery := cQuery + " AND D1.D1_FORNECE = A2.A2_COD AND D1.D1_LOJA = A2.A2_LOJA AND A2.D_E_L_E_T_ <> '*' "
   cQuery := cQuery + " AND F1.F1_DOC = D1.D1_DOC AND F1.F1_SERIE = D1.D1_SERIE" 
   cQuery := cQuery + " ORDER BY D1.D1_PEDIDO,D1.D1_ITEMPC ASC" 

//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  

//ndexTMP  := CriaTrab(NIL,.f.)
//nOrderTMP  := "TMP->C5_FILIAL + SC5->C5_PEDCOM"
//IndRegua("SC5",cIndexSC5,dIndexSC5,"Selecionando Registros..." )
// nIndexSC5 := RetIndex("SC5")
// dbSetIndex(cIndexSC5+OrdBagExt())
//TMP->(DbSetOrder(nOrderTMP))                             
	Processa( {|| fPedido() },"Gerando Dados para a Impressao")

Return

Static Function fPedido()
   
   TMP->(Dbgotop())
   cPedido := TMP->D1_PEDIDO
   
   If !Empty(cPedido ) //se nao tiver pedido nao busca o pedido ne a solicitacao de compra
      cQuery := "SELECT C7.C7_QUANT,C7.C7_QUJE,C7.C7_REAJUST,C7.C7_PRECO,C7.C7_DATPRF,"
   	cQuery := cQuery + "C7.C7_NUM,C7.C7_ITEM,C7.C7_DESCRI,C7.C7_EMISSAO,C7.C7_NUMSC,C7.C7_ITEMSC,"
	   cQuery := cQuery + "C1.C1_SOLICIT,C1.C1_CC,C1.C1_NUM"  
	   cQuery := cQuery + " FROM "  + RetSqlName( 'SC7' ) +" C7, " + RetSqlName( 'SD1' ) +" D1, " + RetSqlName( 'SC1' ) +" C1 "
	   cQuery := cQuery + " WHERE D1.D1_PEDIDO = C7.C7_NUM AND D1.D1_FORNECE = C7.C7_FORNECE AND C7.D_E_L_E_T_ <> '*' "
	   cQuery := cQuery + " AND D1.D1_LOJA = C7.C7_LOJA AND C7.C7_NUMSC *= C1.C1_NUM AND C1.D_E_L_E_T_ <> '*' "
	   cQuery := cQuery + " AND D1.D1_LOJA = C7.C7_LOJA AND C7.C7_NUMSC *= C1.C1_NUM AND D1.D_E_L_E_T_ <> '*' "
	   cQuery := cQuery + " ORDER BY C7.C7_NUM,C7.C7_ITEM ASC" 

		TCQUERY cQuery NEW ALIAS "TRB"

	   indexTRB  := CriaTrab(NIL,.f.)
	   nOrderTRB := "TRB->C7_NUM + TRB->C7_ITEM"
   	IndRegua("TRB",cIndexTRB,nOrderTRB,"Selecionando Registros..." )
	// nIndexSC5 := RetIndex("SC5")
	// dbSetIndex(cIndexSC5+OrdBagExt())
//	   TMP->(DbSetOrder(nOrderTMP))                             

   Endif 
   
	Processa( {|| RptDetail() }, "Aguarde Processando ...")
	
Return



Static Function RptDetail()

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

cTipoNF	:= aCombo1[aScan(aAuxCombo1,TMP->F1_TIPO)]  // Tipo da nota fiscal

Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
@ Prow() + 1, 001 Psay "Dados do Fornecedor                                                    Nota Fiscal   Especie   Tipo da Nota          Emissao"
@ Prow() + 1, 001 Psay Repli("-",132)
@ Prow() + 1, 001 Psay TMP->D1_FORNECE +" / " + TMP->D1_LOJA + " - " + TMP->A2_NOME+ Space(17)+TMP->D1_DOC+"-"+TMP->D1_SERIE+"       "+TMP->F1_ESPECIE+"  "+CtipoNF+Space(08)+Subs(TMP->D1_EMISSAO,7,2)+"/"+Subs(TMP->D1_EMISSAO,5,2)+"/"+Subs(TMP->D1_EMISSAO,1,4)
@ Prow() + 1, 001 Psay TMP->A2_END+"                               Valor Total: " + Transform(TMP->F1_VALBRUT,"@E 9,999,999,99")
@ Prow() + 1, 001 Psay TMP->A2_MUN +"  "+TMP->A2_EST +"  CNPJ/CGC: "+transform(TMP->A2_CGC,PesqPict("SA1","A1_CGC"))
@ Prow() + 1, 001 Psay "------------------------------------------------------- DADOS DA NOTA FISCAL -------------------------------------------------------"
@ Prow() + 1, 001 Psay "Cod.Produto    Unid.    Descricao Produto                 Quantidade   Qtde Fisica   Vlr.Unit   Valor Total   C.Custo  Lote"

While TMP->(!Eof())
   
   IncProc("Imprimindo Boletim de Entrada... " + TMP->D1_DOC)
      
//   If Prow() > 60
//      _nPag := _nPag + 1
//      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
//     	@ Prow() + 1, 001 Psay "Cod.Produto    Unid.    Descricao Produto        Quantidade   Vlr.Unit   Valor Total   Centro Custo"
//   Endif
                                             
	@ Prow() + 1, 001 Psay Subs(TMP->D1_COD,1,13) 
	@ Prow()    , 017 Psay TMP->D1_UM  
	@ Prow()    , 025 Psay TMP->D1_DESCRI  	
	@ Prow()    , 056 Psay Transform(TMP->D1_QUANT,"@E 9,999,999,999")
	@ Prow()    , 080 Psay Transform(TMP->D1_VUNIT,"@E 9,999,999,9999")
	@ Prow()    , 095 Psay Transform(TMP->D1_TOTAL,"@E 9,999,999,999")
	@ Prow()    , 112 Psay TMP->D1_CC
	@ Prow()    , 120 Psay TMP->D1_LOTECTL

   TMP->(Dbskip())   
EndDo
DbSelectArea("TMP")
DbCloseArea()


If !Empty(cPedido)
	TRB->(DbGoTop())
	ProcRegua(TRB->(RecCount()))
	IF TRB->(!Eof())
	  	@ Prow() + 1, 000 Psay __PrtThinLine()  //Imprime uma linha em negrito         
		@ Prow() + 1, 001 Psay "------------------------------------------------DIVERGENCIAS COM O PEDIDO DE COMPRAS --------------------------------------------"
		@ Prow() + 1, 001 Psay "Diverg. Numero  Descricao do Produto                   Quantidade   Vlr.Unit   Valor Total   C.Custo  Lote"
		TRB->(DbsetOrder(1)) //Indice temp. numero+item do pedido
	Endif

	TMP->(DbGoTop())
	While TMP->(!Eof())

	   TRB->(Dbseek(TMP->D1_PEDIDO+TMP->D1_ITEM))
	  	@ Prow() + 1, 000 Psay TRB->C1_NUM +"-"+TRB->C1_TEMSC
   
	Enddo
   

Endif

Return(nil)      


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "NHCO27"

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
aadd(aRegs,{cPerg,"01","Data Inicial   ?","Data Inicial  ?","Data Inicial  ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Data Final     ?","Data final    ?","Data final    ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Regime         ?","Regime        ?","Regime        ?","mv_ch3","N",01,0,1,"C","","mv_par03","Caixa","","","","","Competencia","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Natureza Inicial ?","Natureza Inicial ?","Natureza Inicial ?","mv_ch4","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Natureza Final   ?","Natureza Final   ?","Natureza Final   ?","mv_ch5","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Relatorio        ?","Relatorio        ?","Relatorio        ?","mv_ch6","N",01,0,1,"C","","mv_par06","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Ordem            ?","Ordem            ?","Ordem             ?","mv_ch7","N",01,0,1,"C","","mv_par07","Natureza","","","","","Fornecedor","","","","","","","","","","","","","","","","","","","",""})

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
                                     
