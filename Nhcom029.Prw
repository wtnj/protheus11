 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM029        ³ M¦ Beatriz B Nocera   ³ Data ³ 11.06.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Curva ABC de Fornecedores por Produtos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"       
#INCLUDE "TOPCONN.CH"

User Function Nhcom029()     

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_CARQDBF,_AFIELDS,_NTOTGERAL")
SetPrvt("_NTOTREG,_NPOSICAO,_NVLPRODUTO,_NPRODUTOS,_NQUANTIDADE,_CFORNECEDOR")
SetPrvt("_CPRODUTO,_CLOJA,_DDATA,_CNOMEF,_CDESCPRO,_CTIPOPRO")
SetPrvt("_CGRUPOPRO,_NPRECOU,_NQUANT,_NMEDIAVL,_CARQNTX,_CORDEM")
SetPrvt("_NCONTA,_NCONTB,_NCONTC,_NCONTADOR,_NTOTPARA,_NTOTPARB")
SetPrvt("_NTOTPARC,_NPOS,_CCABEC1,")


cString:="SC7"
cDesc1:= OemToAnsi("Este relatorio tem como objetivo exibir a Curva ABC de Fornecedores")
cDesc2:= OemToAnsi("por Produto e Periodo.")
cDesc3:= OemToAnsi(" ")
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="NHCOM029"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Curva ABC de Fornecedores por Produto e Periodo"
cabec1      :="Curva ABC de Fornecedores por Produto e Periodo"
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

_nPag := 1  //Variavel que acumula numero da pagina

wnrel  :="NHCOM029"        //Nome Default do relatorio em Disco
_cPerg := "NHCO29"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)

/*/
Parametros Utilizados
mv_par01 = Da Data
mv_par02 = Ate a Data
/*/

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

DbSelectArea("TRB")
DbCloseArea("TRB")

Ferase(_cArqDBF+".DBF")

Return

Static Function Gerando()

cQuery := "SELECT * "
cQuery := cQuery + " FROM SC7NH0"         
cQuery := cQuery + " WHERE C7_DATPRF BETWEEN '" + DtoS(Mv_par01) + "' AND '" + DtoS(Mv_par02) + "' "
cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "
cQuery := cQuery + " ORDER BY C7_FORNECE, C7_PRODUTO"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TC7"
DbSelectArea("TC7")

Processa( {|| RptDetail() }, "Aguarde execu‡Æo de c lculos...")
Return


Static Function RptDetail()
ProcRegua(SC7->(RecCount()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
_aFields := {}

AADD(_aFields,{"TR_DATPRF" ,"D", 8,0})         // Data Prevista de Entrega
AADD(_aFields,{"TR_FORNECE","C", 6,0})         // C¢digo do Fornecedor
AADD(_aFields,{"TR_NOME"   ,"C",50,0})         // Nome do Fornecedor
AADD(_aFields,{"TR_PRODUTO","C",15,0})         // C¢digo do Produto
AADD(_aFields,{"TR_DESC"   ,"C",24,0})         // Nome do Produto
AADD(_aFields,{"TR_VALORU" ,"N",12,2})         // Valor Unit rio
AADD(_aFields,{"TR_QUANTID","N",12,2})         // Quantidade
AADD(_aFields,{"TR_VALORT" ,"N",18,6})         // Valor Total 
AADD(_aFields,{"TR_PERCENT","N",18,6})         // Percentual em rela‡Æo ao Total Geral
AADD(_aFields,{"TR_POS"    ,"N",06,0})         // Posi‡Æo
AADD(_aFields,{"TR_CLASSIF","C", 1,0})         // Classifica‡Æo

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"TRB",.F.)

//Cria ¡ndices
SA2->(DbSetOrder(01)) // Fornecedor + Loja
SB1->(DbSetOrder(01)) // Produto

//Vari veis para calcular a Classificacao do Fornecedor
_nTotGeral := 0.000000

//Atualiza a base tempor ria para impressÆo

TC7->(DbGoTop())
ProcRegua(SC7->(RecCount()))

_nTotReg := 0.00


While TC7->(!Eof())
        IncProc("Calculando Total Gerado no Periodo: " + TC7->C7_FORNECE)
        _nTotGeral  := _nTotGeral  + (TC7->C7_QUANT * TC7->C7_PRECO)
        TC7->(DbSkip())
EndDo

TC7->(DbGoTop())

_nPosicao := 1

ProcRegua(SC7->(RecCount()))

While TC7->(!Eof()) 

        _nVlProduto := 0.00000
        _nProdutos  := 0.00000
        _nQuantidade:= 0.00000
        
       IncProc("Atualizando Base: " + TC7->C7_FORNECE)

       _cFornecedor := TC7->C7_FORNECE
       _cProduto    := TC7->C7_PRODUTO
       _cLoja       := TC7->C7_LOJA

       _dData       :=  StoD(TC7->C7_DATPRF)

       SA2->(Dbseek(xFilial("SA2")+_cFornecedor+_cLoja))
       _cNomeF      :=  SA2->A2_NOME

       SB1->(DbSeek(xFilial("SB1")+_cProduto))
       _cDescPro    :=  SB1->B1_DESC
//       _cTipoPro    :=  SB1->B1_TIPO    
//       _cGrupoPro   :=  SB1->B1_GRUPO
       _nPrecoU     :=  TC7->C7_PRECO
       _nQuant      :=  TC7->C7_QUANT

      //Totaliza por Produto dentro de um mesmo Fornecedor
      While _cFornecedor == TC7->C7_FORNECE .And. _cLoja == TC7->C7_LOJA .and. _cProduto == TC7->C7_PRODUTO .and. TC7->(!Eof())
            _nVlProduto    := _nVlProduto + (TC7->C7_QUANT * TC7->C7_PRECO)
            _nProdutos     := _nProdutos + 1
            _nQuantidade   := _nQuantidade + TC7->C7_QUANT
            TC7->(DbSkip())
      EndDo

      If _nProdutos > 1
           _nMediaVl := _nVlProduto/_nProdutos             //M‚dia harm“nica de pre‡os
      Endif

      RecLock("TRB",.t.)

      TRB->TR_DATPRF := _dData
      TRB->TR_FORNECE:= _cFornecedor
      TRB->TR_NOME   := _cNomeF
      TRB->TR_PRODUTO:= _cProduto
//      TRB->TR_TIPO   := _cTipoPro
//      TRB->TR_GRUPO  := _cGrupoPro
      TRB->TR_DESC   := _cDescPro

      If _nProdutos > 1
         TRB->TR_VALORU := _nMediaVl
         TRB->TR_QUANTID:= _nQuantidade
         TRB->TR_VALORT := (-1) * _nVlProduto
         TRB->TR_PERCENT:= (_nVlProduto/_nTotGeral) * 100
      Else
         TRB->TR_VALORU := _nPrecoU
         TRB->TR_QUANTID:= _nQuant
         TRB->TR_VALORT := (-1) * (_nPrecoU * _nQuant)
         TRB->TR_PERCENT:= (-1) * (TRB->TR_VALORT/_nTotGeral) * 100
      Endif
      _nTotReg := _nTotReg + 1
      MsUnLock("TRB")

EndDo

DbSelectArea("TC7")
DbCloseArea("TC7")

//Calcula a Classificacao de cada Fornecedor

TRB->(DbGotop())

_cArqNtx := CriaTrab(NIL,.f.)
_cOrdem  := "TRB->TR_VALORT"

IndRegua("TRB",_cArqNtx,_cOrdem) //"Selecionando Registros..."

TRB->(DbGotop())
While TRB->(!Eof())
        RecLock("TRB",.f.)
          TRB->TR_POS := _nPosicao
        MsUnLock("TRB")
        TRB->(DbSkip())
        _nPosicao := _nPosicao + 1
EndDo

_cArqNtx := CriaTrab(NIL,.f.)
_cOrdem  := "TRB->TR_POS"

IndRegua("TRB",_cArqNtx,_cOrdem) //"Selecionando Registros..."

TRB->(DbGotop())

_nContA    := 0.00
_nContB    := 0.00
_nContC    := 0.00
_nContador := 0.00

_nTotParA := 0.00  //Total de Registros Classificados como A
_nTotParB := 0.00  //Total de Registros Classificados como B
_nTotParC := 0.00  //Total de Registros Classificados como C

_nTotParA := _nTotReg * 0.10
_nTotParB := _nTotReg * 0.30
_nTotParC := _nTotReg * 0.60

_nPos := 0

_nPos := TRB->TR_POS

While TRB->(!Eof()) .And. _nPos <= _nTotParA
        RecLock("TRB",.f.)
          TRB->TR_CLASSIF := "A"
        MsUnLock("TRB")
        TRB->(DbSkip())
        _nContA := _nContA + 1
        _nPos   := TRB->TR_POS
EndDo
_nPos := 1

While TRB->(!Eof()) .And. _nPos <= _nTotParB
        RecLock("TRB",.f.)
          TRB->TR_CLASSIF := "B"
        MsUnLock("TRB")
        TRB->(DbSkip())
        _nContB := _nContB + 1
        _nPos   := _nPos + 1
EndDo

TRB->(DbGoTop())

While TRB->(!Eof())
      If Empty(TRB->TR_CLASSIF)
         RecLock("TRB",.f.)
           TRB->TR_CLASSIF := "C"
          MsUnLock("TRB")
         _nContC := _nContC + 1
      Endif
      TRB->(DbSkip())
EndDo

Imprime() // Rotina para Impressao do dados

Return(nil)  


Static Function imprime()

SetPrc(0,0)

// Criacao de Indice Temporario
_cArqNtx := CriaTrab(NIL,.f.)
_cOrdem  := "TRB->TR_POS"

IndRegua("TRB",_cArqNtx,_cOrdem) //"Selecionando Registros..."

TRB->(DbGoTop())

//               10         20       30         40       50        60         70       80          90     100      110        120       130        140
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
_cCabec1 := "FORNECEDOR                   PRODUTO                              ENTREGA        QUANTIDADE     VALOR UNIT    VALOR TOTAL  %    CLAS"
//           XXXXXX XXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 99/99/9999 999.999.999.99 999.999.999.99 999.999.999.99 99.99   X

Cabecalho()
@ Prow() + 1 , 000 Psay _cCabec1

   While TRB->(!Eof())

       If Prow() > 60
          Eject
          _nPag := _nPag + 1
          Cabecalho()
          @ Prow() + 1 , 000 Psay _cCabec1
        Endif

      // Imprime os Dados

         @ Prow() + 1, 000 Psay TRB->TR_FORNECE
         @ Prow()    , 007 Psay Substr(TRB->TR_NOME, 1, 20)
         @ Prow()    , 029 Psay TRB->TR_PRODUTO
         @ Prow()    , 045 Psay Substr(TRB->TR_DESC, 1, 20)
         @ Prow()    , 066 Psay TRB->TR_DATPRF
         @ Prow()    , 077 Psay TRB->TR_QUANTID PICTURE "@E 999,999,999.99"
         @ Prow()    , 092 Psay TRB->TR_VALORU  PICTURE "@E 999,999,999.99"
         @ Prow()    , 107 Psay ((-1) * TRB->TR_VALORT)  PICTURE "@E 999,999,999.99"
         @ Prow()    , 122 Psay TRB->TR_PERCENT PICTURE "@E 99.99"
         @ Prow()    , 130 Psay TRB->TR_CLASSIF

         TRB->(DbSkip())
   EndDo


//Imprime o total geral do relat¢rio
@ Prow()+2, 001 Psay "TOTAL GERADO NO PERÖODO..: " + Transform(_nTotGeral,"@E 999,999,999.99")

@ Prow()+2, 001 Psay "REGISTROS A  " + Transform(_nTotParA,"@E 999,999,999")
@ Prow()+1, 001 Psay "PERCENTUAL B  " + Transform(_nTotParB,"@E 999,999,999")
@ Prow()+1, 001 Psay "PERCENTUAL C  " + Transform(_nTotParC,"@E 999,999,999")
@ Prow()+1, 001 Psay "TOTAL GERAL  "
@ Prow()  , 020 Psay _nTotParA + _nTotParB + _nTotParC

@ Prow() +1, 020 Psay _nTotReg

Return


Static Function Cabecalho()

@ prow()+1,00 Psay &cCompac+Repli("*",132)
@ prow()+1,00 Psay "*"+SM0->M0_NOMECOM
@ prow(),112 Psay "Folha : "                                                                                                    
@ prow(),124 Psay StrZero(_nPag,5,0)+"  *"
@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
@ prow(),20 Psay PadC(titulo,82)
@ prow(),112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
@ prow()+1,00 Psay "*Hora...: "+Time()
@ prow()  ,30 Psay "Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) 
@ prow(),112 Psay "Emissao: "+Dtoc(Date())+"  *"
@ prow()+1,00 Psay Repli("*",132)
@ prow()+1,00 Psay " "
Return

                                     
