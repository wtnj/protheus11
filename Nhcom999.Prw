/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM001        ³ Sergio L Tambosi      ³ Data ³ 10.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da Previsao de Desembolso por Fornecedor        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhcom001()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY")

cString   :="SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Previsao de Desembolso por Fornecedor")
cDesc3    := OemToAnsi("")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHCOM001"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    :="PREVISAO DE DESEMBOLSO POR FORNECEDOR"
Cabec1    :=" CODIGO         DESCRICAO                      DATA INICIO  DATA FINAL   ALMOX 10    ALMOX ORIG   QTDE EMB   ENTREGUE"
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHCOM001"          //Nome Default do relatorio em Disco
_cPerg    := "COM001"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aMatriz   := {}


//Mv_par01 :=	Usuario
//Mv_par02 :=	Centro de Custo (de)
//Mv_par03 :=	Centro de Custo (ate)
//Mv_par04 :=	Grupo (de)
//Mv_par05 :=	Grupo (ate)
//Mv_par06 :=	Data (de)
//Mv_par07 :=	Data (ate)


Pergunte(_cPerg,.f.) //ativa os parametros

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

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer
TMP->(DbGoTop())
If Empty(TMP->C7_NUM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif
//inicio da impressao
Processa( {|| RptDetail() },"Imprimindo...")

Close TMP

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
    
cQuery :="SELECT C7.C7_EMISSAO, C7.C7_NUM,"
cQuery := cQuery + "C7.C7_FORNECE, A2.A2_NOME, C7.C7_TOTAL," 
cQuery := cQuery + "C7.C7_PRODUTO,C7.C7_DATPRF, C7.C7_COND, E4.E4_COND,C7.C7_CC, C7.C7_USER,Y1.Y1_NOME,"   
// CAST = CONVERTE VARIAVEL OU CAMPO
// OBTEM O PRIMEIRO PRAZO DE PAGAMENTO SE HOUVER, SENÃO DEIXA NULL
cQuery := cQuery + "CASE LEN(SUBSTRING(E4.E4_COND,1,2)) WHEN 2 " 
cQuery := cQuery + "THEN CAST(SUBSTRING(E4.E4_COND,1,2) AS INTEGER)+ CAST(C7.C7_DATPRF AS DATETIME) END DTA1,"
// OBTEM O SEGUNDO PRAZO DE PAGAMENTO SE HOUVER, SENÃO DEIXA NULL
cQuery := cQuery + "CASE LEN(SUBSTRING(E4.E4_COND,4,2)) WHEN 2 " 
cQuery := cQuery + "THEN CAST(SUBSTRING(E4.E4_COND,4,2) AS INTEGER)+ CAST(C7.C7_DATPRF AS DATETIME)END DTA2,"
// OBTEM O TERCEIRO PRAZO DE PAGAMENTO SE HOUVER, SENÃO DEIXA NULL
cQuery := cQuery + "CASE LEN(SUBSTRING(E4.E4_COND,7,2)) WHEN 2 " 
cQuery := cQuery + "THEN CAST(SUBSTRING(E4.E4_COND,7,2) AS INTEGER)+ CAST(C7.C7_DATPRF AS DATETIME)ELSE " 
// CASO TENHA TRES DIGITOS TAMBÉM VERIFICA
cQuery := cQuery + "CASE LEN(SUBSTRING(E4.E4_COND,7,3)) WHEN 3 " 
cQuery := cQuery + "THEN CAST(SUBSTRING(E4.E4_COND,7,3) AS INTEGER)+ CAST(C7.C7_DATPRF AS DATETIME)END "
cQuery := cQuery + "END DTA3"
cQuery := cQuery + " FROM " + RetSqlName( 'SC7' ) +" C7, " + RetSqlName( 'SA2' ) +" A2, " 
cQuery := cQuery + RetSqlName( 'SE4' ) +" E4, " + RetSqlName( 'SY1' ) +" Y1 "
cQuery := cQuery + "WHERE A2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "AND C7.D_E_L_E_T_ <> '*' " 
cQuery := cQuery + "AND SUBSTRING(C7.C7_PRODUTO,1,4) BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' " 
cQuery := cQuery + "AND C7.C7_DATPRF BETWEEN '"+ DTOS(Mv_par06) + "'  AND '"+ DTOS(Mv_par07) + "' " 
cQuery := cQuery + "AND C7.C7_CC BETWEEN '"+ Mv_par02 + "' AND '"+ Mv_par03 + "' "
cQuery := cQuery + "AND C7.C7_USER = '"+ Mv_par01 + "' "
cQuery := cQuery + "AND C7.C7_FORNECE = A2.A2_COD "
cQuery := cQuery + "AND C7.C7_LOJA = A2.A2_LOJA " 
cQuery := cQuery + "AND C7.C7_COND = E4.E4_CODIGO "
cQuery := cQuery + "AND C7.C7_USER = Y1.Y1_USER "
cQuery := cQuery + "ORDER BY 2,4"
                                                 
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"  
/*	TcSetField("TMP","C2_DATPRI","D")  // Muda a data de string para date    
	TcSetField("TMP","C2_DATPRF","D")  // Muda a data de string para date    */
Return                                   


Static Function RptDetail()

TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))                         

// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While TMP->(!Eof())

   IncProc("Imprimindo " + cdesc2 + " " + TMP->C7_NUM)

   // DEFINIÇÃO DO RELATÓRIO PERSONALIZADO
   
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif   
   // linha detalhe do relatório
	@ Prow() +1, 001 Psay TMP->C7_EMISSAO
	@ Prow()   , 011 Psay TMP->C7_NUM
	@ Prow()   , 021 Psay TMP->A2_NOME	  	
	@ Prow()   , 061 Psay TMP->C7_TOTAL
	@ Prow()   , 076 Psay TMP->C7_DATPRF
	@ Prow()   , 088 Psay TMP->E4_COND
	@ Prow()   , 102 Psay TMP->DAT1	  	
	@ Prow()   , 114 Psay TMP->DAT2
	@ Prow()   , 126 Psay TMP->DAT3
                                     
   
   TMP->(Dbskip())   
EndDo
      
Return(nil)      
  

