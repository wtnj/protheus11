/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM027        ³ M¦ Beatriz B Nocera   ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Curva ABC de Fornecedores (por valor gerado)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³ Alexandre R. Bento                      | Data | 27.09.02 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhcom027()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_CARQDBF,_AFIELDS,_NTGERAL")
SetPrvt("_NTPARCIAL,_CFORNECE,_CLOJA,_NTOTALF,_NAUX,_CNOMEF,_cNaturez,_cRel,_cOrd")
SetPrvt("_DDATA,_CARQNTX,_CORDEM,_NPER,_NPOS,_CCABEC1,M_PAG,_cCla,_ca,_cb,_cc")

_cRel     := Space(12)
_cOrd     := Space(20)
_cNaturez := Space(10)
cString   :="SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo exibir a ")
cDesc2    := OemToAnsi("Curva ABC dos Fornecedores, permitindo informar ")
cDesc3    := OemToAnsi("per¡odo e quantidade de fornecedores a imprimir.")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHCOM027"
aLinha    := { }
nLastKey  := 0
lEnd      := .f.
titulo    :="Curva ABC de Fornecedores(Regime de Caixa) - por Valor"       
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"

_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1

wnrel  :="NHCOM027"          //Nome Default do relatorio em Disco
_cPerg := "NHCO27"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)

// Parametros Utilizados
// mv_par01 = Da Data
// mv_par02 = Ate a Data
// mv_par03 = regime de caixa ou competencia
// mv_par04 = natureza inicial
// mv_par05 = natureza final          
// mv_par06 = sim 1-analitico   nao 2-Sintetico 
// mv_par07 = 1- Ordem por natureza   2-Ordem por fornecedor  3-Ordem por valor

// AjustaSX1() // Verifica os parametros

Pergunte(_cPerg,.f.) //ativa os parƒmetros
 

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

If MV_PAR06 = 1
   _cRel   :=" ANALITICO "
Elseif MV_PAR06 = 2
   _cRel   :=" SINTETICO "
Endif   

If MV_PAR07 = 1
   _cOrd   :=" ORDEM POR NATUREZA "
Elseif MV_PAR07 = 2
   _cOrd   :=" ORDEM POR FORNECEDOR "
Elseif MV_PAR07 = 3
   _cOrd   :=" ORDEM POR VALOR      "   
Endif   



If MV_PAR03 = 1
   titulo   :="Curva ABC de Fornecedores(Regime de Caixa) - por Valor  " 
Elseif MV_PAR03 = 2
   titulo   :="Curva ABC de Fornecedores(Regime de Competencia) - por Valor  "
Endif   

cabec1      :=" Parametro Data de "+ Dtoc(MV_PAR01) + " Ate "+Dtoc(MV_PAR02) + "     Da Natureza: " + mv_par04 + " Ate " + mv_par05  +"    "+ Alltrim(_cRel)  +"   "+ Alltrim(_cOrd)           

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

DbSelectArea("TRB")
DbCloseArea("TRB")
Ferase(_cArqDBF+".DBF")
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
                                      
// TUDO O QUE FOI PAGO- TOTAL OU PARCIAL  REGIME DE CAIXA
If mv_par03 = 1  .And. mv_par07 <> 3  //regime de caixa
   If mv_par06 = 1 // analitico
      cQuery := "SELECT E2_NATUREZ,E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO) AS MES,YEAR(E2_EMISSAO) AS ANO, STR(SUM(E2_VALOR-E2_SALDO),14,2) AS VALOR" 
   Else  // Sintetico
      cQuery := "SELECT E2_NATUREZ,E2_FORNECE, E2_LOJA, STR(SUM(E2_VALOR-E2_SALDO),14,2) AS VALOR"    
   Endif   

Elseif mv_par03 = 2 .And. mv_par07 <> 3  // regime de competencia 
   If mv_par06 = 1 // analitico
      cQuery := "SELECT E2_NATUREZ, E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO) AS MES,YEAR(E2_EMISSAO) AS ANO, STR(SUM(E2_VALOR),14,2) AS VALOR" 
   Else  // Sintetico
      cQuery := "SELECT E2_NATUREZ, E2_FORNECE, E2_LOJA, STR(SUM(E2_VALOR),14,2) AS VALOR"    
   Endif     

Elseif mv_par03 = 1  .And. mv_par07 = 3  // regime de competencia e ordem por valor  
   If mv_par06 = 1 // analitico
      cQuery := "SELECT E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO) AS MES,YEAR(E2_EMISSAO) AS ANO, STR(SUM(E2_VALOR-E2_SALDO),14,2) AS VALOR" 
   Else  // Sintetico
      cQuery := "SELECT E2_FORNECE, E2_LOJA, STR(SUM(E2_VALOR-E2_SALDO),14,2) AS VALOR"    
   Endif     

Elseif mv_par03 = 2  .And. mv_par07 = 3  // regime de competencia e ordem por valor  
   If mv_par06 = 1 // analitico
      cQuery := "SELECT E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO) AS MES,YEAR(E2_EMISSAO) AS ANO, STR(SUM(E2_VALOR),14,2) AS VALOR" 
   Else  // Sintetico
      cQuery := "SELECT E2_FORNECE, E2_LOJA, STR(SUM(E2_VALOR),14,2) AS VALOR"    
   Endif     
   
Endif   

cQuery := cQuery + " FROM " + RetSqlName( 'SE2' ) +" SE2 "
cQuery := cQuery + " WHERE E2_EMISSAO BETWEEN '" + DtoS(Mv_par01) + "' AND '" + DtoS(Mv_par02) + "' AND D_E_L_E_T_ <> '*' "                                                                                                        
cQuery := cQuery + " AND E2_NATUREZ BETWEEN '" + Mv_par04 + "' AND '" + Mv_par05 + "' "                                                                                                        
If mv_par03 = 1  //regime de caixa
   cQuery := cQuery + " AND E2_VALOR <> E2_SALDO"
Endif                             
If mv_par06 = 1 // analitico
   If mv_par07 = 1 // por ordem de natureza
	  cQuery := cQuery + " GROUP BY E2_NATUREZ,E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO),YEAR(E2_EMISSAO)" 
	  cQuery := cQuery + " ORDER BY E2_NATUREZ,E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO),YEAR(E2_EMISSAO) ASC" 
   Elseif mv_par07 = 2  // por ordem de fornecedor
	  cQuery := cQuery + " GROUP BY E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO),YEAR(E2_EMISSAO),E2_NATUREZ" 
	  cQuery := cQuery + " ORDER BY E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO),YEAR(E2_EMISSAO),E2_NATUREZ ASC" 
   Elseif mv_par07 = 3  // por ordem de fornecedor
      cQuery := cQuery + " GROUP BY E2_FORNECE, E2_LOJA, MONTH(E2_EMISSAO),YEAR(E2_EMISSAO)" 
	  cQuery := cQuery + " ORDER BY 5 DESC" 
   Endif
   
Else // sintetico                          
   If mv_par07 = 1 // por ordem de natureza
      cQuery := cQuery + " GROUP BY E2_NATUREZ, E2_FORNECE, E2_LOJA" 
      cQuery := cQuery + " ORDER BY E2_NATUREZ, E2_FORNECE, E2_LOJA ASC" 
   Elseif mv_par07 =2 // por ordem de fornecedor
      cQuery := cQuery + " GROUP BY E2_FORNECE, E2_LOJA, E2_NATUREZ" 
      cQuery := cQuery + " ORDER BY E2_FORNECE, E2_LOJA, E2_NATUREZ ASC"    
   Elseif mv_par07 =3 // por ordem de Valor
      cQuery := cQuery + " GROUP BY E2_FORNECE, E2_LOJA" 
      cQuery := cQuery + " ORDER BY 3 DESC"    
   Endif   
Endif   

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TE2"
DbSelectArea("TE2")

Processa( {|| RptDetail() }, "Aguarde execu‡Æo de c lculos...")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ M¦ Beatriz B Nocera   ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao do Arquivo Temporario                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function RptDetail()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
_aFields := {}

AADD(_aFields,{"TR_DATPRF" ,"N", 02,0})         // Data Prevista de Entrega (MES)
AADD(_aFields,{"TR_FORNECE","C", 6,0})         // Fornecedor
AADD(_aFields,{"TR_NOME"   ,"C",50,0})         // Nome do Fornecedor
AADD(_aFields,{"TR_VALORT" ,"N",18,6})         // Valor Total
AADD(_aFields,{"TR_PERCENT","N",18,6})         // Percentual em rela‡Æo ao Total Geral
AADD(_aFields,{"TR_CLASSIF","C", 1,0})         // Classifica‡Æo
AADD(_aFields,{"TR_ANO"    ,"N", 4,0})         // Ano          
AADD(_aFields,{"TR_NATUREZ","C",10,0})         // Classifica‡Æo

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"TRB",.F.)

//Cria ¡ndices
SA2->(DbSetOrder(01)) // Fornecedor + Loja

_nTGeral  := 0.000000                               //Controla o total geral dos pedidos
_nTParcial:= 0.000000                               //Permite calcular o total parcial

//Calcula o total geral de Valores para obter o % e Classifica‡Æo

TE2->(DbGoTop())
ProcRegua(TE2->(RecCount()))

While TE2->(!Eof())
        IncProc("Calculando Totais por Fornecedor: " + TE2->E2_FORNECE)
        _nTGeral  := _nTGeral  + Val(TE2->VALOR)
        TE2->(DbSkip())
EndDo

TE2->(DbGoTop())


While TE2->(!Eof())
      IncProc("Atualizando Base para Impressao: " + TE2->E2_FORNECE)

      _cFornece := TE2->E2_FORNECE
      _cLoja    := TE2->E2_LOJA
      _nTotalF  := 0.000000
      _nAux     := 0.000000

      SA2->(Dbseek(xFilial("SA2")+_cFornece+_cLoja))     //Posiciona no arquivo de Fornecedores
      _cNomeF   := SA2->A2_NOME                    //Nome do Fornecedor
      _nTotalF := Val(TE2->VALOR)    // _nTotalF * (-1)

      // Grava os Dados no Arquivo Temporario

      RecLock("TRB",.t.)

        TRB->TR_FORNECE := _cFornece
        TRB->TR_NOME    := _cNomeF
        TRB->TR_VALORT  := _nTotalF
        _nAux            := _nTotalF /_nTGeral * 100
        TRB->TR_PERCENT := _nAux //* (-1)
    	If mv_par06 = 1 // analitico                                        
          _dData         := TE2->MES       //Mes previsto de entrega
          TRB->TR_ANO   := TE2->ANO
        Else  // Sintetico  
          _dData    := 0      //Mes previsto de entrega
  	    Endif                         
        If mv_par07 <> 3                   
           TRB->TR_NATUREZ := TE2->E2_NATUREZ
        Else                                   
           TRB->TR_NATUREZ := " " 
        Endif
 	    
        TRB->TR_DATPRF  := _dData

      MsUnLock("TRB")       

      TE2->(DbSkip())
      
EndDo

DbSelectArea("TE2")
DbCloseArea("TE2")

//_cArqNtx := CriaTrab(NIL,.f.)
//_cOrdem  := "TRB->TR_VALORT"

//IndRegua("TRB",_cArqNtx,_cOrdem) //"Selecionando Registros..."

TRB->(DbGotop())

_nPer := 0.000000
_cCla := Space(01)
_ca   := _cb := _cc := 0
_nPos := TRB->(Recno())
While TRB->(!Eof())

   If TRB->TR_PERCENT <= 30
      _cCla := "C"                 
      _cc   := _cc + 1
   Elseif TRB->TR_PERCENT > 30 .And. TRB->TR_PERCENT <= 60 
      _cCla := "B"    
      _cb   := _cb + 1
   Elseif TRB->TR_PERCENT > 60 
      _cCla := "A"    
      _ca   := _ca + 1
   Endif   
 
   RecLock("TRB",.f.)
      TRB->TR_CLASSIF := _cCla
   MsUnLock("TRB")
  
  _nPer := _nPer + TRB->TR_PERCENT

  TRB->(DbSkip())

EndDo

Imprime() // Rotina para Impressao do dados

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Imprime   ³ Autor ³ M¦ Beatriz B Nocera   ³ Data ³ 14.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  


Return(nil)      


Static Function imprime()

// Criacao de Indice Temporario
//_cArqNtx := CriaTrab(NIL,.f.)
//_cOrdem  := "TRB->TR_VALORT"

//IndRegua("TRB",_cArqNtx,_cOrdem) //"Selecionando Registros..."

TRB->(DbGoTop())

//               10         20       30         40       50        60         70       80          90     100      110        120       130        140
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

If MV_PAR06 = 1
   _cCabec1 := "FORNECEDOR                                                      MES "+Iif(mv_par07=2," NATUREZA","         ")+"       VALOR TOTAL   PERCENT  CLASSIFICACAO"   
Elseif MV_PAR06 = 2
   _cCabec1 := "FORNECEDOR                                                          "+Iif(mv_par07=2," NATUREZA","         ")+"       VALOR TOTAL   PERCENT  CLASSIFICACAO"   
Endif   
//           xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx        99/99/99        999.999.999.99    99.99          X                                                   

// @ prow()+1,00 Psay &cCompac  + Replicate("*",132)

// Cabecalho()

Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)

@ Prow() + 1 , 001 Psay _cCabec1

While TRB->(!Eof())

       If Prow() > 60
        //  Eject
          _nPag := _nPag + 1
        //  Cabecalho()                               
		    Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
          @ Prow() + 1 , 001 Psay _cCabec1
        Endif
                                                               
      // Imprime os Dados                      
         If mv_par07 = 1 // imprime natureza quando a ordem for pela natureza
             If _cNaturez <> TRB->TR_NATUREZ
	            _cNaturez := TRB->TR_NATUREZ                         
	             SED->(DbSeek(xFilial("SED")+TRB->TR_NATUREZ))
	            
	            @ Prow() + 2, 001 Psay "Natureza : "+TRB->TR_NATUREZ + " - " + SED->ED_DESCRIC
	         Endif      
	     Endif    
	         

         @ Prow() + 1, 001 Psay TRB->TR_FORNECE
         @ Prow()    , 009 Psay TRB->TR_NOME
         If mv_par06 = 1 // imprime mes/ano quando for analitico
            @ Prow()    , 061 Psay TransForm(TRB->TR_DATPRF,"@e 99") + "/"+Transform(TRB->TR_ANO, "@E 9999")
         Endif                
         if mv_par07 = 2 // ordem por fornecedor imprime natureza
            @ Prow(), 73 Psay SubStr(TRB->TR_NATUREZ,1,9) 
         Endif
         
         @ Prow()    , 082 Psay TRB->TR_VALORT PICTURE "@E 999,999,999.99"
         @ Prow()    , 099 Psay TRB->TR_PERCENT       PICTURE "@E 99.99" +" "+ "%"
         @ Prow()    , 114 Psay TRB->TR_CLASSIF


         TRB->(DbSkip())
EndDo

//Imprime o total geral do relat¢rio
@ Prow()+2, 054 Psay "TOTAL GERADO NO PERIODO..:  " + Transform(_nTGeral,"@E 999,999,999.99") + "  "+ Transform(_nPer,"@E 999.99") +" %"
@ Prow()+2, 025 Psay "Classificacao: A-Acima de 60%   B- Entre 30% a 60%   C-Entre 0% a 30% "
@ Prow()+1,  42 Psay  Transform(_ca, "@E 9,999") + "               " +Transform(_cb, "@E 9,999")+"               " + Transform(_cc, "@E 9,999") 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Cabecalhos³  Autor³ M¦ Beatriz B Nocera   ³ Data ³ 14.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cabecalho do Relatorio                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  


Static Function Cabecalho()

@ prow()+1,01 Psay &cCompac+Repli("*",132)
@ prow()+1,01 Psay "*"+SM0->M0_NOMECOM
@ prow(),112 Psay "Folha : "                                                                                                    
@ prow(),124 Psay StrZero(_nPag,5,0)+"  *"
@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
@ prow(),20 Psay PadC(titulo,82)
@ prow(),112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"*"
@ prow()+1,00 Psay "*Hora...: "+Time()
@ prow()  ,30 Psay "Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) 
@ prow(),112 Psay "Emissao: "+Dtoc(Date())+"*"
@ prow()+1,00 Psay Repli("*",132)
@ prow()+1,00 Psay " "
Return

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
                                     
