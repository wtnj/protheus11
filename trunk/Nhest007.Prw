/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST007        ³ Alexandre R. Bento    ³ Data ³ 30.01.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da lista de faltas simplificada P/ Almoxarifado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEst007()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,nPos,nSaldoB2,x,nFaltas,nConsumo")

cString   :="SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Lista de faltas de produtos ")
cDesc3    := OemToAnsi("")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST007"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    :="LISTA DE FALTAS SIMPLIFICADAS"
Cabec1    :=" CODIGO         DESCRICAO                      DATA INICIO  DATA FINAL   ALMOX 10    ALMOX ORIG   QTDE EMB   ENTREGUE"
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST007"          //Nome Default do relatorio em Disco
_cPerg    := "EST007"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aMatriz   := {}
AADD(aMatriz,{"","","","",0,0})

//Mv_par01 :=	Ctod("01/02/03")
//Mv_par02 :=	Ctod("07/02/03")


Pergunte(_cPerg,.f.) //ativa os parƒmetros

// Parametros Utilizados
// mv_par01 = Produto Inicial da op
// mv_par02 = Produto final   da op


SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

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
TMP->(DbGoTop())
If Empty(TMP->D4_OP)
   MsgBox("Ordem de Producao nao Encontrada","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

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

	cQuery :="SELECT C2.C2_NUM,C2.C2_PRODUTO,C2.C2_DATPRI,C2.C2_DATPRF,B1.B1_LOCPAD,"
	cQuery := cQuery + "D4.D4_COD,D4.D4_LOCAL,D4.D4_OP,D4.D4_QUANT,D4.D4_QTDEORI,B1.B1_DESC,B1.B1_TIPO,"
   cQuery := cQuery + "B2.B2_QATU,B2.B2_LOCAL,B2.B2_QEMP,B5.B5_QE1,B5.B5_QE2"   
   cQuery := cQuery + " FROM " + RetSqlName( 'SD4' ) +" D4, " + RetSqlName( 'SB1' ) +" B1, " 
   cQuery := cQuery + RetSqlName( 'SC2' ) +" C2, " + RetSqlName( 'SB2' ) +" B2 ,"+ RetSqlName( 'SB5' ) +" B5 "
   cQuery := cQuery + " WHERE B1.B1_COD = D4.D4_COD AND B2.B2_COD = D4.D4_COD" 
   cQuery := cQuery + " AND D4.D4_COD = B5.B5_COD AND B5.D_E_L_E_T_ <> '*'" 
   cQuery := cQuery + " AND D4.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*'" 
   cQuery := cQuery + " AND C2.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*'"
//   cQuery := cQuery + " AND SUBSTRING(D4.D4_OP,1,6) = 'AC0112'"
   cQuery := cQuery + " AND D4.D4_COD >= '" + Mv_par01 + "' AND D4.D4_COD  <= '"+ Mv_par02 + "' "
   cQuery := cQuery + " AND '" + DtoS(Ddatabase) + "' >= C2.C2_DATPRI AND '" + DtoS(Ddatabase) + "' <= C2.C2_DATPRF "
// cQuery := cQuery + " AND D4.D4_OP  BETWEEN  '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' "   
   cQuery := cQuery + " AND D4.D4_OP  = C2.C2_NUM+C2.C2_ITEM+C2.C2_SEQUEN"
   cQuery := cQuery + " AND D4.D4_QUANT <> 0 AND D4.D4_LOCAL = B2.B2_LOCAL"    
   cQuery := cQuery + " AND B1.B1_TIPO IN ('CC','MC','CP','MP')"
   cQuery := cQuery + " ORDER BY B2.B2_QATU - B2.B2_QEMP ASC" 
                                                 
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  
	TcSetField("TMP","C2_DATPRI","D")  // Muda a data de string para date    
	TcSetField("TMP","C2_DATPRF","D")  // Muda a data de string para date    
Return                                   


Static Function RptDetail()

TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))

SB2->(DbSetOrder(1)) //filial + codigo + local
While TMP->(!Eof())

   IncProc("Imprimindo Lista de Falta... " + TMP->D4_OP)
      
   nSaldoB2 := 0                                      
   nFalta   := 0
   nConsumo := 0
   If SB2->(DbSeek(xFilial("SB2")+TMP->D4_COD+TMP->B1_LOCPAD)) // Tabela de validação de Usuarios, Grupos e Local Padrão                  
   	nSaldoB2 :=  SB2->B2_QATU 
	Endif

   nConsumo := TMP->D4_QTDEORI/(TMP->C2_DATPRF - TMP->C2_DATPRI) //Consumo por dia de produção
   If (nConsumo - TMP->B2_QATU) > 0
       If (nConsumo - TMP->B2_QATU) > TMP->D4_QUANT  //Neste caso pesga o saldo da OP, pq o saldo é menor que o consumo
          nFalta := TMP->D4_QUANT 
       Else         
          nFalta := (nConsumo - TMP->B2_QATU)  // consumo menos o saldo atual do 10
       Endif   
   Endif
   
   If nFalta <> 0  // adiciona na matriz somente qdo tiver falta de produto
	   nPos:=Ascan(aMatriz,{|X|X[1] == TMP->D4_COD})  //Substr(aEntradas[xni,1],1,1)})
		If nPos == 0
	      AADD(aMatriz,{TMP->D4_COD,TMP->B1_DESC,DTOC(TMP->C2_DATPRI),DTOC(TMP->C2_DATPRF),;
						  Round(nFalta,0) , nSaldoB2, TMP->B5_QE1,TMP->B5_QE2})
	
	   Else                     
	      aMatriz[nPos,5]:= Round(aMatriz[nPos,5] + nFalta,0)
	   Endif                                          
	Endif
		   
   TMP->(Dbskip())   
EndDo

If Len(aMatriz) == 1
   MsgBox("Nenhum Produto foi Selecionado","Atencao","STOP")
   Return
Endif

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

For x:= 2 to Len(aMatriz)
   
   If Prow() > 60
      _nPag := _nPag + 1
//      Cabec1 := " "
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif   

   @ Prow() + 1, 001 Psay aMatriz[x][1]
	@ Prow()    , 016 Psay aMatriz[x][2]
	@ Prow()    , 049 Psay aMatriz[x][3]
	@ Prow()    , 061 Psay aMatriz[x][4]
	@ Prow()    , 071 Psay Transform(aMatriz[x][5],"@E 9,999,999")  	
	@ Prow()    , 085 Psay Transform(aMatriz[x][6],"@E 9,999,999")  	
   If aMatriz[x][8] == 0
      @ Prow()    , 093  Psay Transform((aMatriz[x][5]/ aMatriz[x][7]),"@E 9,999,999")  	
   Else                                                                                   
      @ Prow()    , 093  Psay Transform((aMatriz[x][5]/ aMatriz[x][8]),"@E 9,999,999")  	
   Endif
   @ Prow()    , 107 Psay "........................."

Next
      
Return(nil)      
  

