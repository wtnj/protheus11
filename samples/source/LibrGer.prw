#INCLUDE "LibrGer.ch"
#include "SIGAWIN.CH"        
#include "RWMAKE.CH"

//Posicoes do array aRegSF3
#DEFINE _DATA	    1
#DEFINE _ESPECIE	2
#DEFINE _SERIE	    3
#DEFINE _DOCUMENTO	4
#DEFINE _VALOR    	5
#DEFINE _TES    	6
#DEFINE _TIPO    	7
#DEFINE _TIPOMOV   	8
#DEFINE _DTCANC   	9
#DEFINE _FSIGNO   	10  //Determina se o documento eh normal(1) ou devolucao(-1)

//Posicoes do array aRelImps
#DEFINE _CODIMP  	1
#DEFINE _CPOIMP  	2
#DEFINE _BASEIMP  	3
#DEFINE _VALIMP   	4

//Posicoes do array aLinha, aLinhaBase
#DEFINE _COLUNA    1
#DEFINE _IMPOSTO   2

//Posicoes do array aSintSF3
#DEFINE _SDATA    1
#DEFINE _SVALOR   2
#DEFINE _SIMPS    3
#DEFINE _STIPOMOV 4

//Posicoes do array aImprImps
#DEFINE _INDCPO   1
#DEFINE _ICODIMP  2
#DEFINE _ICOORD   3

//Posicoes do array aTotalGeral
#DEFINE _TCODIMP   1
#DEFINE _TBASIMP   2
#DEFINE _TVALIMP   3
#DEFINE _TGCOMPRAS 1
#DEFINE _TGVENDAS  2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ FUNCAO   ³ LIBRGER  ³ AUTOR ³ Fernando Machima      ³ DATA ³ 16.10.02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DESCRICAO³ Programa generico de impressao do Livro Fiscal(Localizacoes) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ Generico - Localizacoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Machima       ³16/10/02³xxxxxx³Inicio do desenvolvimento                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LibrGer()

Local   Titulo    := STR0001 //"Relatorio de Impostos"
Local   cCabec1   := STR0002 //"Este programa emite uma relacao dos impostos registrados no Livro Fiscal"
Local   cPerg     := "LIBGER" 
Local   cString   := "SF3"
Private nLastKey  :=0
Private Limite    := 220
Private Tamanho   :="G"
Private lEnd      :=.F.
Private aReturn   :={ STR0003 , 1,STR0004, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private m_pag	  := 1

AjustaSX1(cPerg)

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros                         ³
//³mv_par01             // Data Inicial                         ³
//³mv_par02             // Data Final                           ³
//³mv_par03             // Livro de 1-Compras 2-Vendas 3-Ambos  ³
//³mv_par04             // Considera Anuladas 1-Sim 2-Nao       ³
//³mv_par05             // Tipo 1-Analitico 2-Sintetico         ³
//³mv_par06             // Considera Isentos 1-Sim 2-Nao        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "LIBRGER"   // nome default do relatorio em disco
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cCabec1,,,.F.,"",,Tamanho)
If nLastKey==27
   DbClearFilter()
   Return
Endif       
SetDefault(aReturn,cString)
If nLastKey==27
   DbClearFilter()
   Return
Endif       

RptStatus({|lEnd| LibrImprime(@lEnd,Titulo)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LibrImprimºAutor  ³ Fernando Machima   º Data ³  16/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de impressao do livro fiscal                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGER                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibrImprime(lEnd,Titulo)

Local NomeProg  := "LIBRGER"
Local Cabec1    := ""
Local Cabec2    := ""
Local cbtxt     :=Space(10)
Local cbcont    := 0
Local nX, nY, nZ
Local nIndice
Local nCnt      := 0
Local nPosImps  := 0
Local nPosicao  := 0
Local nCoordImps:= 0
Local nColuna   := 0
Local nPosTotalDia := 0
Local nIndTipo  := 1
Local nSigno    := 1      //Determina se o valor do registro soma(Tipo = (N)ormal) ou subtrai(Tipo = (D)evolucao) 
Local lQuery    := .F.
Local lMultiLinha := .F.  //Define se imprime impostos em 2 linhas, isso ocorre quando o numero de impostos for maior que 5
                           //Neste caso, a base eh impressa acima do valor   
Local lAmbos    := .F.    //Define se deve imprimir registros de Compras E Vendas
Local lAnalitico:= .F.    //Define se o relatorio desejado eh analitico
Local lIsentos  := .F.    //Define se deve mostrar registros isentos de impostos
Local dDataMov  := CTOD("  /  /  ")
Local cQuery    := ""
Local cFiltro   := ""
Local cChave    := ""
Local cIndexSF3 := ""
Local cAliasSF3 := "SF3"
Local cAliasTRB := "SF3TRB"
Local cNomeArq  := ""
Local cCpoLvro  := ""
Local cCampoVlr := ""
Local cCampoBas := ""
Local cTipoMov  := ""
Local cTipoMovim:= ""
Local cPictDev   := "@E 999,999,999.99"     //Picture especial para devolucao devido ao uso do "(" ")"
Local cPictDevTot:= "@E 9,999,999,999.99"   //Picture especial para devolucao devido ao uso do "(" ")"
Local cPictValor := "@E 99,999,999,999.99"
Local cPictTotal := "@E 999,999,999,999.99"
Local aStruSF3    := {}
Local aLinha    := {}    //Usado para impressao ordenada dos impostos 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ *******  Descric„o do ARRAY aLinha   ********* ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   1        ³ Coluna de impressao do imposto    ³
³   2        ³ Base ou valor do imposto          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Local aLinhaBase:= {}    //Usado para impressao ordenada das bases dos impostos(Multi-linha e Sintetico) 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ ******  Descric„o do ARRAY aLinhaBase  ******* ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   1        ³ Coluna de impressao do imposto    ³
³   2        ³ Base do imposto                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Local aRegSF3     := {}  //Contem os registros a serem impressos no relatorio
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ *******  Descric„o do ARRAY aRegSF3  ********* ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   n,1      ³ Data de Entrada                   ³
³   n,2      ³ Especie                           ³
³   n,3      ³ Serie                             ³
³   n,4      ³ Numero da Nota Fiscal             ³
³   n,5      ³ Valor                             ³
³   n,6      ³ TES                               ³
³   n,7      ³ Tipo:(N)ormal,(D)evolucao         ³
³   n,8      ³ Tipo do movimento:(C)ompra,(V)enda³
³   n,9      ³ Data de Cancelamento              ³
³   n,10     ³ Sinal(1:(N)ormal/-1:(D)evolucao)  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local aRelImps  := {}  //Contem as caracteristicas dos impostos(base, codigo, valor etc) associados a NF
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ *******  Descric„o do ARRAY aRelImps  ******** ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   n,1      ³ Serie                             ³
³   n,2      ³ Numero da Nota Fiscal             ³
³   n,3,x,1  ³ Codigo do imposto                 ³
³   n,3,x,2  ³ Campo de gravacao dos impostos    ³
³   n,3,x,3  ³ Base do imposto                   ³
³   n,3,x,4  ³ Valor do imposto                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local aImpostos := {}  //Contem os impostos relacionados com o TES(passado como parametro)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ *******  Descric„o do ARRAY aImpostos ******** ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   1        ³ Codigo do imposto                 ³
³   2        ³ Campo do SD1/SD2 onde eh gravado o³
³            ³ valor do imposto                  ³
³   3        ³ Determina se o valor incide na NF ³
³   4        ³ Determina se o valor incide no ti-³
³            ³ tulo                              ³
³   5        ³ Determina se o valor deve ser cre-³
³            ³ ditado no custo                   ³
³   6        ³ Campo do SF1/SF2 onde eh gravado o³
³            ³ valor do imposto                  ³
³   7        ³ Campo do SD1/SD2 onde eh gravada a³
³            ³ base do imposto                   ³
³   8        ³ Campo do SF1/SF2 onde eh gravada a³
³            ³ base do imposto                   ³
³   9        ³ Aliquota do imposto               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local aImprImps := {}  //Define quais impostos, considerando todos os documentos, devem ser impressos
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ *******  Descric„o do ARRAY aImprImps ******** ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   n,1      ³ Indice do campo onde eh gravado o ³
³            ³ imposto(1..9)                     ³
³   n,2      ³ Codigo do imposto                 ³
³   n,3      ³ Coordenada(coluna) onde serao im- ³
³            ³ pressos os dados do imposto(base/ ³
³            ³ valor). A impressao dos impostos  ³
³            ³ eh dinamica, sendo que a ordem de ³
³            ³ impressao eh determinada pelo in- ³
³            ³ dice do campo(FB_CPOLVRO)         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local aSintSF3  := {}  //Usado para impressao do relatorio sintetico, agrupado por data
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ *******  Descric„o do ARRAY aSintSF3  ******** ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   n,1      ³ Data de Entrada                   ³
³   n,2      ³ Valor                             ³
³   n,3,x,1  ³ Codigo do imposto                 ³
³   n,3,x,2  ³ Campo de gravacao dos impostos    ³
³   n,3,x,3  ³ Base do imposto                   ³
³   n,3,x,4  ³ Valor do imposto                  ³
³   n,4      ³ Tipo do movimento:(C)ompra,(V)enda³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Local aTotalGeral  := {}   //Armazena os totalizadores gerais 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ ******  Descric„o do ARRAY aTotalGeral  ****** ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Dimensoes  ³ Descricao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   n,1      ³ Valor total                       ³
³   n,2,x,1  ³ Codigo do imposto                 ³
³   n,2,x,2  ³ Soma da Base dos impostos         ³
³   n,2,x,3  ³ Soma do Valor dos impostos        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

li := 80

Aadd(aTotalGeral,{0,{}})  //Compras
Aadd(aTotalGeral,{0,{}})  //Vendas

lAmbos     := (mv_par03 == 3)
lAnalitico := (mv_par05 == 1)
lIsentos   := (mv_par06 == 1)

If lAnalitico
   Titulo  := STR0005 //"Relatorio Analitico de Impostos -"
Else
   Titulo  := STR0006 //"Relatorio Sintetico de Impostos -"
EndIf

If mv_par03 == 1
   Titulo += STR0007 //" Compras - "
Elseif mv_par03 == 2
   Titulo += STR0008 //" Vendas - "
EndIf
Titulo += STR0009+DTOC(mv_par01)+STR0010+DTOC(mv_par02) //" Periodo "###" a "

DbSelectArea("SF3")
DbSetOrder(1)
#IFDEF TOP
   If TcSrvType() != "AS/400"
      aStruSF3  := dbStruct()
      cAliasSF3 := "SF3TMP"
      lQuery := .T.
      cQuery := "SELECT F3_FILIAL,F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,"
      cQuery += "F3_VALCONT,F3_TIPO,F3_ESPECIE,F3_TIPOMOV,F3_DTCANC,F3_TES,F3_EXENTAS,"      
      cQuery += "F3_BASIMP1,F3_VALIMP1,F3_BASIMP2,F3_VALIMP2,F3_BASIMP3,F3_VALIMP3,"      
      cQuery += "F3_BASIMP4,F3_VALIMP4,F3_BASIMP5,F3_VALIMP5,F3_BASIMP6,F3_VALIMP6 "            
      cQuery += "FROM "+RetSqlName("SF3")+" "					
      cQuery += "WHERE "
      cQuery += "F3_FILIAL = '"+xFilial("SF3")+"' AND "
      cQuery += "F3_ENTRADA  >= '"+DTOS(mv_par01)+"' AND "
      cQuery += "F3_ENTRADA  <= '"+DTOS(mv_par02)+"' AND "      
      If mv_par03 == 1  //Compras
         cQuery += "F3_TIPOMOV = 'C' AND " 
      ElseIf mv_par03 == 2  //Vendas
         cQuery += "F3_TIPOMOV = 'V' AND "    
      EndIf      
      If mv_par04 == 2   //Nao considera anuladas
         cQuery += "F3_DTCANC = '' AND "      
      EndIf   
      If !lIsentos    //Nao considerar registros isentos de impostos
         cQuery += "F3_EXENTAS = 0 AND "         
      EndIf
      
      cQuery += "D_E_L_E_T_<>'*' "
      If lAmbos
         cQuery += "ORDER BY F3_FILIAL,F3_TIPOMOV+F3_ENTRADA+F3_SERIE+F3_NFISCAL"      
      Else
         cQuery += "ORDER BY F3_FILIAL,F3_ENTRADA,F3_SERIE,F3_NFISCAL"
      EndIf      
      cQuery := ChangeQuery(cQuery)
      dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)
      For nX := 1 To Len(aStruSF3)
         If aStruSF3[nX,2] != "C"
	        TcSetField(cAliasTRB,aStruSF3[nX,1],aStruSF3[nX,2],aStruSF3[nX,3],aStruSF3[nX,4])
	     EndIf
      Next nX
      Processa( {|lEnd| LibCriaTmp(@cNomeArq, aStruSF3, cAliasSF3, cAliasTRB)},,STR0011)       //"Organizando registros..."
   Else      
      MsSeek(xFilial()+DTOS(mv_par01))      
   EndIf
#ELSE
   cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.And. DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+"'.And. DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"'"
   If mv_par03 == 1  //Compras
      cFiltro += " .And. F3_TIPOMOV == 'C'" 
   ElseIf mv_par03 == 2  //Vendas
      cFiltro += " .And. F3_TIPOMOV == 'V'"    
   EndIf
   If mv_par04 == 2   //Nao considera anuladas
      cFiltro += " .And. F3_DTCANC = ''"      
   EndIf   
   If !lIsentos    //Nao considerar registros isentos de impostos
      cFiltro += " .And. F3_EXENTAS == 0"         
   EndIf
   
   If lAmbos
      cChave    := "F3_FILIAL+F3_TIPOMOV+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL"
   Else 
      cChave    := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL"
   EndIf   
   cIndexSF3 := CriaTrab(NIL,.F.)
   
   IndRegua(cAliasSF3,cIndexSF3,cChave,,cFiltro,STR0012)  //"Filtrando registros..."
   nIndice	:=	RetIndex(cAliasSF3)	
   dbSetIndex(cIndexSF3+OrdBagExt())	
   DbSetOrder(nIndice+1)		
#ENDIF						           
SetRegua(RecCount())

DbSelectArea(cAliasSF3)
DbGoTop()
While !Eof() 
   nCnt++
   aImpostos := TesImpInf((cAliasSF3)->F3_TES)
   nIndTipo  := IIf((cAliasSF3)->F3_TIPOMOV == "C",_TGCOMPRAS,_TGVENDAS)
   nSigno    := IIf((cAliasSF3)->F3_TIPO == "N",1,-1)
   //Ordena os impostos de acordo com o nome do campo de gravacao do valor(ex: D2_VALIMP1, D2_VALIMP2, etc)
   //para que os de menor indice(1..9) aparecam primeiro no relatorio
   ASort(aImpostos,,,{|x,y| x[2]< y[2]})         
   If Len(aImpostos) == 0  //TES nao possui impostos relacionados
      Aadd(aRelImps,{(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_NFISCAL,{}})            
   Else
      Aadd(aRelImps,{(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_NFISCAL,{}})            
      For nX := 1 to Len(aImpostos)
         //Indice do campo de gravacao do valor do imposto
         cCpoLvro := Substr(aImpostos[nX][2],10)                                             
         //Nome do campo de gravacao do valor do imposto
         cCampoVlr:= (cAliasSF3)+"->"+Substr((cAliasSF3),2,2)+"_VALIMP"+cCpoLvro             
         //Nome do campo de gravacao da base do imposto            
         cCampoBas:= (cAliasSF3)+"->"+Substr((cAliasSF3),2,2)+"_BASIMP"+cCpoLvro         
         If &(cCampoVlr) > 0  
            Aadd(aRelImps[nCnt][3],{aImpostos[nX][1],cCpoLvro,&(cCampoBas),&(cCampoVlr)})            
            nPosImps  := aScan(aImprImps,{|x| x[2] == aImpostos[nX][1]})
            If nPosImps == 0
               AAdd(aImprImps,{cCpoLvro,aImpostos[nX][1],0})
            EndIf
            nPosImps  := aScan(aTotalGeral[nIndTipo][2],{|x| x[_TCODIMP] == aImpostos[nX][1]})
            If nPosImps == 0
               Aadd(aTotalGeral[nIndTipo][2],{aImpostos[nX][1],&(cCampoBas)*nSigno,&(cCampoVlr)*nSigno})
            Else            
               aTotalGeral[nIndTipo][2][nPosImps][_TBASIMP] += &(cCampoBas)*nSigno
               aTotalGeral[nIndTipo][2][nPosImps][_TVALIMP] += &(cCampoVlr)*nSigno                
            EndIf   
         EndIf
      Next nX      
   EndIf   
   Aadd(aRegSF3,{(cAliasSF3)->F3_ENTRADA,(cAliasSF3)->F3_ESPECIE,(cAliasSF3)->F3_SERIE,;
                  (cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_VALCONT,(cAliasSF3)->F3_TES,;
                  (cAliasSF3)->F3_TIPO,(cAliasSF3)->F3_TIPOMOV,(cAliasSF3)->F3_DTCANC,;
                  nSigno})                                    
   aTotalGeral[nIndTipo][1] += (cAliasSF3)->F3_VALCONT*nSigno                        
   dbSkip()  	   
End              

If lAnalitico 
   cabec1  := STR0013 //" ENTRADA TIPO SERIE  NUM.DOCUMENTO         TOTAL"
Else              //Sintetico, agrupado por data
   cabec1  := STR0014 //" ENTRADA           TOTAL  "
EndIf   
//Calcula os valores sinteticos agrupados por data
For nX := 1 to Len(aRegSF3)
   nSigno  := aRegSF3[nX][_FSIGNO]
   If dDataMov != aRegSF3[nX][_DATA] .Or. cTipoMov != aRegSF3[nX][_TIPOMOV]                            
      Aadd(aSintSF3,{aRegSF3[nX][_DATA],aRegSF3[nX][_VALOR]*nSigno,aClone(aRelImps[nX][3]),aRegSF3[nX][_TIPOMOV]})
      //Caso o documento seja de devolucao, deve considerar o sinal negativo
      For nY := 1 to Len(aSintSF3[Len(aSintSF3)][_SIMPS])
         aSintSF3[Len(aSintSF3)][_SIMPS][nY][_BASEIMP] := aRelImps[nX][3][nY][_BASEIMP]*nSigno
         aSintSF3[Len(aSintSF3)][_SIMPS][nY][_VALIMP] := aRelImps[nX][3][nY][_VALIMP]*nSigno                  
      Next nY   
   Else
      aSintSF3[Len(aSintSF3)][_SVALOR] += aRegSF3[nX][_VALOR]*nSigno
      For nY := 1 to Len(aRelImps[nX][3])
         nPosImps  := aScan(aSintSF3[Len(aSintSF3)][_SIMPS],{|x| x[1] == aRelImps[nX][3][nY][_CODIMP]})         
         If nPosImps > 0
            aSintSF3[Len(aSintSF3)][_SIMPS][nPosImps][_BASEIMP] += aRelImps[nX][3][nY][_BASEIMP]*nSigno
            aSintSF3[Len(aSintSF3)][_SIMPS][nPosImps][_VALIMP]  += aRelImps[nX][3][nY][_VALIMP]*nSigno
         Else
            Aadd(aSintSF3[len(aSintSF3)][_SIMPS],aClone(aRelImps[nX][3][nY]))               
            //Caso o documento seja de devolucao, deve considerar o sinal negativo
            aSintSF3[Len(aSintSF3)][_SIMPS][Len(aSintSF3[Len(aSintSF3)][_SIMPS])][_BASEIMP] := aRelImps[nX][3][nY][_BASEIMP]*nSigno
            aSintSF3[Len(aSintSF3)][_SIMPS][Len(aSintSF3[Len(aSintSF3)][_SIMPS])][_VALIMP] := aRelImps[nX][3][nY][_VALIMP]*nSigno            
         EndIf
      Next nY
   EndIf
   dDataMov := aRegSF3[nX][_DATA]      
   cTipoMov := aRegSF3[nX][_TIPOMOV]            
Next nX
//Ordena os impostos de acordo com o indice do campo de gravacao, logo os impostos gravados
//em campos de indice 1(D2_VALIMP1) aparecem em primeiro, de indice 2(D2_VALIMP2) vem em segundo 
//e assim por diante
ASort(aImprImps,,,{|x,y| x[1]< y[1]})
//Determina se a base e o valor do imposto sao mostrados em 2 linhas, sendo o valor abaixo da base
lMultiLinha := Len(aImprImps) > 5
For nX := 1 to Len(aImprImps)
   cCpoImp  := aImprImps[nX][_INDCPO]
   If lMultiLinha
      If !lAnalitico
         cabec1  += STR0015+aImprImps[nX][_ICODIMP]       //"         BASE "
      EndIf   
      If nX ==1 
         If lAnalitico
            cabec1  += STR0016+aImprImps[nX][_ICODIMP]          //"            BASE "
            cabec2  += STR0017+aImprImps[nX][_ICODIMP]       //"                                                            VALOR "
         Else 
            cabec2  += STR0018+aImprImps[nX][_ICODIMP]                //"                                   VALOR "
         EndIf   
      Else
         If lAnalitico
            cabec1  += STR0015+aImprImps[nX][_ICODIMP]      //"         BASE "
         EndIf
         cabec2  += STR0019+aImprImps[nX][_ICODIMP] //"        VALOR "
      EndIf   
      //Coordenadas usadas no calculo da coluna para mostrar no relatorio
      aImprImps[nX][_ICOORD] := nX * 17      //A distancia entre os dados de um imposto e outro serah 17
   Else      
      cabec1  += STR0015+aImprImps[nX][_ICODIMP]+STR0019+aImprImps[nX][_ICODIMP]  //"         BASE "###"        VALOR "
      //Coordenadas usadas no calculo da coluna para mostrar no relatorio
      If lAnalitico      
         aImprImps[nX][_ICOORD] := (2*nX-1) * 17  
      Else  
         aImprImps[nX][_ICOORD] := (2*nX-2) * 17
      EndIf      
   EndIf   
Next nX

cTipoMov   := ""
cTipoMovim := ""
dDataMov   := CTOD("  /  /  ")
If lAnalitico
   For nX := 1 to Len(aRegSF3)
      li++
	  If lEnd
		 @PROW()+1,001 PSAY STR0020 //"CANCELADO PELO OPERADOR"
		 Exit
	  Endif

      IncRegua()
   
      If li > 60
	     cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
	  Endif                               
	  
	  //Imprime totalizadores por dia
	  If (dDataMov != aRegSF3[nX][_DATA] .Or. cTipoMovim != aRegSF3[nX][_TIPOMOV]) .And.;
	     dDataMov  != CTOD("  /  /  ")   
	     //Imprime os sub-totais por dia
	     ImprimeSub(aSintSF3,aImprImps,cTipoMovim,dDataMov,lMultiLinha,cPictValor,cPictTotal,cPictDev,cPictDevTot)         
      EndIf   
      dDataMov   := aRegSF3[nX][_DATA]
      cTipoMovim := aRegSF3[nX][_TIPOMOV]
      nSigno     := aRegSF3[nX][_FSIGNO]
      If cTipoMov != aRegSF3[nX][_TIPOMOV]
         li++
         If aRegSF3[nX][_TIPOMOV] == "C"
            @ li,001 PSAY STR0021 //"C O M P R A S"
         ElseIf aRegSF3[nX][_TIPOMOV] == "V"
            //Imprime totais gerais de compra
            If lAmbos .And. aTotalGeral[_TGCOMPRAS][1] > 0            
               ImprimeTot(aTotalGeral,aImprImps,_TGCOMPRAS,lAnalitico,lMultiLinha,cPictValor,cPictTotal,cPictDev,cPictDevTot)         
               li := li + 2
            EndIf   
            @ li,001 PSAY STR0022        //"V E N D A S"
         EndIf   
         li := li + 2
      EndIf
      cTipoMov  := aRegSF3[nX][_TIPOMOV]    
            
      @ li,001 PSAY aRegSF3[nX][_DATA]
	  @ li,010 PSAY aRegSF3[nX][_ESPECIE]
      @ li,015 PSAY aRegSF3[nX][_SERIE]
	  @ li,022 PSAY aRegSF3[nX][_DOCUMENTO]
      If !Empty(aRegSF3[nX][_DTCANC])  
	     @ li,039 PSAY STR0023        //"A N U L A D A"
      Else	  
         If nSigno == 1
	        @ li,033 PSAY Transform(aRegSF3[nX][_VALOR],cPictValor)
	     Else
	        @ li,033 PSAY Space(15-Len(AllTrim(Transform(aRegSF3[nX][_VALOR],cPictDev))))+"("+AllTrim(Transform(aRegSF3[nX][_VALOR],cPictDev))+")"       	     
	     EndIf   
	     If lMultiLinha
            aLinha  := {}	
	        For nY := 1 to Len(aImprImps)
	           nPosicao := aScan(aRelImps[nX][3],{|x| x[1] == aImprImps[nY][_ICODIMP]})	           
	           nCoordImps := aImprImps[nY][_ICOORD]	           
	           //Mostra valor 0(zero) quando o imposto nao eh calculado	           
	           If nPosicao == 0
	              @ li,036+nCoordImps PSAY Transform(0,cPictValor)
	              Aadd(aLinha,{036+nCoordImps,0})	           
	           Else
	              //Imprime base dos impostos
	              If nSigno == 1
	                 @ li,036+nCoordImps PSAY Transform(aRelImps[nX][3][nPosicao][_BASEIMP],cPictValor)
	              Else
	                 @ li,036+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aRelImps[nX][3][nPosicao][_BASEIMP],cPictDev))))+"("+AllTrim(Transform(aRelImps[nX][3][nPosicao][_BASEIMP],cPictDev))+")"
	              EndIf   
	              //Armazena a coluna de impressao e o valor do imposto para posterior impressao
                  Aadd(aLinha,{036+nCoordImps,aRelImps[nX][3][nPosicao][_VALIMP]})
               EndIf   
	        Next nY		               
	     Else 
            //Imprime base e valor dos impostos	  	     
	        For nY := 1 to Len(aImprImps)
	           nPosicao := aScan(aRelImps[nX][3],{|x| x[1] == aImprImps[nY][_ICODIMP]})	           
	           nCoordImps := aImprImps[nY][_ICOORD]	              	           
	           //Mostra valor 0(zero) quando o imposto nao eh calculado
	           If nPosicao == 0  
	              @ li,033+nCoordImps PSAY Transform(0,cPictValor)
                  @ li,050+nCoordImps PSAY Transform(0,cPictValor)
               Else
	              If nSigno == 1	                             
	                 @ li,033+nCoordImps PSAY Transform(aRelImps[nX][3][nPosicao][_BASEIMP],cPictValor)
                     @ li,050+nCoordImps PSAY Transform(aRelImps[nX][3][nPosicao][_VALIMP],cPictValor)
                  Else
	                 @ li,033+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aRelImps[nX][3][nPosicao][_BASEIMP],cPictDev))))+"("+AllTrim(Transform(aRelImps[nX][3][nPosicao][_BASEIMP],cPictDev))+")"
                     @ li,050+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aRelImps[nX][3][nPosicao][_VALIMP],cPictDev))))+"("+AllTrim(Transform(aRelImps[nX][3][nPosicao][_VALIMP],cPictDev))+")"                                    
                  EndIf   
	           EndIf
	        Next nY	     
 	     EndIf   
         //Imprime os valores dos impostos nos casos de multi-linha(mais de 6 impostos a serem impressos)
         If Len(aLinha) > 0
            li++
            ASort(aLinha,,,{|x,y| x[1]< y[1]})               
            For nZ := 1 to Len(aLinha)
               If nSigno == 1 .Or. aLinha[nZ][_IMPOSTO] == 0
                  @ li,aLinha[nZ][_COLUNA] PSAY Transform(aLinha[nZ][_IMPOSTO],cPictValor)
               Else
                  @ li,aLinha[nZ][_COLUNA] PSAY Space(15-Len(AllTrim(Transform(aLinha[nZ][_IMPOSTO],cPictDev))))+"("+AllTrim(Transform(aLinha[nZ][_IMPOSTO],cPictDev))+")"               
               EndIf   
            Next nZ
         EndIf	
      EndIf   
   Next nX
   li++	        	     
   //Imprime os sub-totais por dia
   ImprimeSub(aSintSF3,aImprImps,cTipoMovim,dDataMov,lMultiLinha,cPictValor,cPictTotal,cPictDev,cPictDevTot)            
ElseIf Len(aSintSF3) > 0    //Sintetico
   For nX := 1 to Len(aSintSF3)
      li++
	  If lEnd
		 @PROW()+1,001 PSAY STR0020 //"CANCELADO PELO OPERADOR"
		 Exit
	  Endif

      IncRegua()
   
      If li > 60
	     cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
	  Endif
	  
      If cTipoMov != aSintSF3[nX][_STIPOMOV]
         li++
         If aSintSF3[nX][_STIPOMOV] == "C"
            @ li,001 PSAY STR0021 //"C O M P R A S"
         ElseIf aSintSF3[nX][_STIPOMOV] == "V"
            //Imprime totais gerais de compra
            If lAmbos .And. aTotalGeral[_TGCOMPRAS][1] > 0                        
               ImprimeTot(aTotalGeral,aImprImps,_TGCOMPRAS,lAnalitico,lMultiLinha,cPictValor,cPictTotal,cPictDev,cPictDevTot)         
               li := li + 2
            EndIf   
            @ li,001 PSAY STR0022        //"V E N D A S"
         EndIf   
         li := li + 2
      EndIf
      cTipoMov  := aSintSF3[nX][_STIPOMOV]

      @ li,001 PSAY aSintSF3[nX][_SDATA]
      If aSintSF3[nX][_SVALOR] >= 0
	     @ li,010 PSAY Transform(aSintSF3[nX][_SVALOR],cPictValor)
	  Else
	     @ li,010 PSAY Space(15-Len(AllTrim(Transform(aSintSF3[nX][_SVALOR]*(-1),cPictDev))))+"("+AllTrim(Transform(aSintSF3[nX][_SVALOR]*(-1),cPictDev))+")"	  
	  EndIf   
      
	  aLinhaBase:= {}	     	  
	  aLinha    := {}	     
	  If lMultiLinha         
	     For nY := 1 to Len(aImprImps)
	        nPosicao := aScan(aSintSF3[nX][_SIMPS],{|x| x[1] == aImprImps[nY][_ICODIMP]})
	        nCoordImps := aImprImps[nY][_ICOORD]	        
	        nColuna    := 10+nCoordImps	        
	        If nPosicao == 0
	           Aadd(aLinhaBase,{nColuna,0})	           
	           Aadd(aLinha,{nColuna,0})	        
	        Else
	           //Armazena a coluna e o valor do imposto a ser impresso
	           Aadd(aLinhaBase,{nColuna,aSintSF3[nX][_SIMPS][nPosicao][_BASEIMP]})	           
	           //Armazena a coluna e a base do imposto a ser impresso	           
	           Aadd(aLinha,{nColuna,aSintSF3[nX][_SIMPS][nPosicao][_VALIMP]})
            EndIf   
	     Next nY		  	  	  	  	  
	  Else      
         //Imprime base e valor dos impostos         
	     For nY := 1 to Len(aImprImps)
	        nPosicao := aScan(aSintSF3[nX][_SIMPS],{|x| x[1] == aImprImps[nY][_ICODIMP]})
	        nCoordImps := aImprImps[nY][_ICOORD]	        
	        If nPosicao == 0  
	           @ li,027+nCoordImps PSAY Transform(0,cPictValor)
               @ li,044+nCoordImps PSAY Transform(0,cPictValor)
	        Else
	           If aSintSF3[nX][_SIMPS][nPosicao][_BASEIMP] >= 0
	              @ li,027+nCoordImps PSAY Transform(aSintSF3[nX][_SIMPS][nPosicao][_BASEIMP],cPictValor)
                  @ li,044+nCoordImps PSAY Transform(aSintSF3[nX][_SIMPS][nPosicao][_VALIMP],cPictValor)
               Else
	              @ li,027+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aSintSF3[nX][_SIMPS][nPosicao][_BASEIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aSintSF3[nX][_SIMPS][nPosicao][_BASEIMP]*(-1),cPictDev))+")"
                  @ li,044+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aSintSF3[nX][_SIMPS][nPosicao][_VALIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aSintSF3[nX][_SIMPS][nPosicao][_VALIMP]*(-1),cPictDev))+")"               
               EndIf   
            EndIf   
	     Next nY		  	  	  
	  EndIf   
      //Imprime base/valor dos impostos nos casos de multi-linha(mais de 6 impostos a serem impressos)
      If Len(aLinha) > 0
         //Ordena de acordo com a coluna de impressao da base
         ASort(aLinhaBase,,,{|x,y| x[1]< y[1]})               
         //Imprime a base dos impostos
         For nZ := 1 to Len(aLinhaBase)
            If aLinhaBase[nZ][_IMPOSTO] >= 0
               @ li,aLinhaBase[nZ][_COLUNA] PSAY Transform(aLinhaBase[nZ][_IMPOSTO],cPictValor)
            Else 
               @ li,aLinhaBase[nZ][_COLUNA] PSAY Space(15-Len(AllTrim(Transform(aLinhaBase[nZ][_IMPOSTO]*(-1),cPictDev))))+"("+AllTrim(Transform(aLinhaBase[nZ][_IMPOSTO]*(-1),cPictDev))+")"            
            EndIf      
         Next nZ      
         li++
         //Ordena de acordo com a coluna de impressao do valor         
         ASort(aLinha,,,{|x,y| x[1]< y[1]})               
         //Imprime o valor dos impostos         
         For nZ := 1 to Len(aLinha)
            If aLinha[nZ][_IMPOSTO] >= 0         
               @ li,aLinha[nZ][_COLUNA] PSAY Transform(aLinha[nZ][_IMPOSTO],cPictValor)
            Else 
               @ li,aLinha[nZ][_COLUNA] PSAY Space(15-Len(AllTrim(Transform(aLinha[nZ][_IMPOSTO]*(-1),cPictDev))))+"("+AllTrim(Transform(aLinha[nZ][_IMPOSTO]*(-1),cPictDev))+")"            
            EndIf  
         Next nZ
      EndIf		  
   Next nX
   li++
EndIf

If mv_par03 == 1 .Or. (mv_par03 == 3 .And. aTotalGeral[_TGVENDAS][1] == 0) //Compras ou Ambos
   If aTotalGeral[_TGCOMPRAS][1] > 0                        
      li++
      ImprimeTot(aTotalGeral,aImprImps,_TGCOMPRAS,lAnalitico,lMultiLinha,cPictValor,cPictTotal,cPictDev,cPictDevTot)         
   EndIf   
Elseif mv_par03 == 2 .Or. mv_par03 == 3  //Vendas ou Ambos
   If aTotalGeral[_TGVENDAS][1] > 0            
      li++   
      ImprimeTot(aTotalGeral,aImprImps,_TGVENDAS,lAnalitico,lMultiLinha,cPictValor,cPictTotal,cPictDev,cPictDevTot)               
   EndIf   
EndIf   

If lQuery 
	dbSelectArea(cAliasSF3)
	dbCloseArea()
	dbSelectArea("SF3")
Else
	dbSelectArea(cAliasSF3)
	dbClearFilter()
	RetIndex("SF3")
	Ferase(cIndexSF3+OrdBagExt())
EndIf

If li != 80
	Roda(cbcont,cbtxt,Tamanho)
EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³ Fernando Machima   º Data ³  16/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria as perguntas caso nao existam                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGER                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","Data Inicial       ?","Fecha Inicial      ?","Initial Date       ?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","01/01/02","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data Final         ?","Fecha Final        ?","Final Date         ?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","31/12/05","","","","","","","","","","","","")
PutSx1(cPerg,"03","Livro de           ?","Libro de           ?","From Fiscal Books  ?","mv_ch3","N",1,0,1,"C","","","","",;
"mv_par03","Compras","Compras","Purchase","","Vendas","Ventas","Sales","Ambos","Ambos","Both","","","","","","")   
PutSx1(cPerg,"04","Considera Anuladas ?","Considera Anuladas ?","Consider Cancelled ?","mv_ch4","N",1,0,1,"C","","","","",;
"mv_par04","Sim","Si","Yes","","Nao","No","No","","","","","","","","","")   
PutSx1(cPerg,"05","Tipo               ?","Tipo               ?","Tipo               ?","mv_ch5","N",1,0,1,"C","","","","",;
"mv_par05","Analitico","Analitico","Detailed","","Sintetico","Sintetico","Summarized","","","","","","","","","")   
PutSx1(cPerg,"06","Considera Isentos  ?","Considera Exentos  ?","Consider Exempts   ?","mv_ch6","N",1,0,1,"C","","","","",;
"mv_par06","Sim","Si","Yes","","Nao","No","No","","","","","","","","","")   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprimeSubºAutor  ³ Fernando Machima   º Data ³  30/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime os sub-totais por dia para o relatorio analitico   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGER                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprimeSub(aSintSF3,aImprImps,cTipoMovim,dDataMov,lMultiLinha,cPictValor,;
                           cPictTotal,cPictDev,cPictDevTot)

Local nPosTotalDia  := 0
Local nZ, nX
Local nPosicao      := 0
Local nCoordImps    := 0
Local aLinha        := {}

@ li,001 PSAY STR0024+DTOC(dDataMov)+":"          //"SUB-TOTAL EM "
nPosTotalDia  := aScan(aSintSF3,{|x| x[_SDATA] == dDataMov .And. x[_STIPOMOV] == cTipoMovim})
If nPosTotalDia > 0    
   If aSintSF3[nPosTotalDia][_SVALOR] >= 0
      @ li,032 PSAY Transform(aSintSF3[nPosTotalDia][_SVALOR],cPictTotal)
   Else
      @ li,032 PSAY Space(16-Len(AllTrim(Transform(aSintSF3[nPosTotalDia][_SVALOR]*(-1),cPictDevTot))))+"("+AllTrim(Transform(aSintSF3[nPosTotalDia][_SVALOR]*(-1),cPictDevTot))+")"   
   EndIf   
   For nZ := 1 to Len(aImprImps)
      nPosicao := aScan(aSintSF3[nPosTotalDia][_SIMPS],{|x| x[1] == aImprImps[nZ][_ICODIMP]})               
	  nCoordImps := aImprImps[nZ][_ICOORD]	        
	  If nPosicao == 0
	     If lMultiLinha
	        @ li,036+nCoordImps PSAY Transform(0,cPictValor)
	        Aadd(aLinha,{036+nCoordImps,0})	        	     
	     Else	  
	        @ li,033+nCoordImps PSAY Transform(0,cPictValor)
            @ li,050+nCoordImps PSAY Transform(0,cPictValor)
         EndIf      
	  Else
	     If lMultiLinha
	        If aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP] >= 0
	           @ li,036+nCoordImps PSAY Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP],cPictValor)
	        Else
	           @ li,036+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP]*(-1),cPictDev))+")"	        
	        EndIf   
	        //Armazena a coluna de impressao e o valor do imposto para posterior impressao
	        Aadd(aLinha,{036+nCoordImps,aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_VALIMP]})	        
	     Else
            If aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP] >= 0
	           @ li,033+nCoordImps PSAY Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP],cPictValor)
               @ li,050+nCoordImps PSAY Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_VALIMP],cPictValor)
            Else 
	           @ li,033+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_BASEIMP]*(-1),cPictDev))+")"
               @ li,050+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_VALIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aSintSF3[nPosTotalDia][_SIMPS][nPosicao][_VALIMP]*(-1),cPictDev))+")"            
            EndIf      
         EndIf   
	  EndIf
   Next nZ
   //Imprime os valores dos impostos nos casos de multi-linha(mais de 6 impostos a serem impressos)
   If Len(aLinha) > 0
      li++
      ASort(aLinha,,,{|x,y| x[1]< y[1]})               
      For nX := 1 to Len(aLinha)                           
         If aLinha[nX][_IMPOSTO] >= 0
            @ li,aLinha[nX][_COLUNA] PSAY Transform(aLinha[nX][_IMPOSTO],cPictValor)
         Else
            @ li,aLinha[nX][_COLUNA] PSAY Space(15-Len(AllTrim(Transform(aLinha[nX][_IMPOSTO]*(-1),cPictDev))))+"("+AllTrim(Transform(aLinha[nX][_IMPOSTO]*(-1),cPictDev))+")"         
         EndIf      
      Next nX
   EndIf	            
   li := li + 2
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprimeTotºAutor  ³ Fernando Machima   º Data ³  30/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime os totais gerais de compra / venda                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBRGER                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprimeTot(aTotalGeral,aImprImps,nIndTipo,lAnalitico,lMultiLinha,cPictValor,;
                           cPictTotal,cPictDev,cPictDevTot)

Local nPosicao   := 0
Local nX, nZ
Local nCoordImps := 0
Local aLinha     := {}

@ li,001 PSAY STR0025 //"TOTAL:"
If lAnalitico
   If aTotalGeral[nIndTipo][1] >= 0
      @ li,032 PSAY Transform(aTotalGeral[nIndTipo][1],cPictTotal)
   Else
      @ li,032 PSAY Space(17-Len(AllTrim(Transform(aTotalGeral[nIndTipo][1],cPictDevTot))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][1],cPictDevTot))+")"   
   EndIf     
Else
   If aTotalGeral[nIndTipo][1] >= 0
      @ li,009 PSAY Transform(aTotalGeral[nIndTipo][1],cPictTotal)
   Else
      @ li,009 PSAY Space(17-Len(AllTrim(Transform(aTotalGeral[nIndTipo][1]*(-1),cPictDevTot))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][1]*(-1),cPictDevTot))+")"   
   EndIf      
EndIf
aLinha  := {}	   
For nX := 1 to Len(aImprImps)
   nPosicao  := aScan(aTotalGeral[nIndTipo][2],{|x| x[_TCODIMP] == aImprImps[nX][_ICODIMP]})
   If nPosicao > 0
      nCoordImps := aImprImps[nX][_ICOORD]   
      If lAnalitico
         If lMultiLinha
            If aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP] >= 0
               @ li,036+nCoordImps PSAY Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP],cPictValor)
            Else
               @ li,036+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))+")"            
            EndIf   
            Aadd(aLinha,{036+nCoordImps,aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP]})
         Else                                                                      
            If aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP] >= 0         
               @ li,033+nCoordImps PSAY Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP],cPictValor)
               @ li,050+nCoordImps PSAY Transform(aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP],cPictValor)
            Else 
               @ li,033+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))+")"
               @ li,050+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP]*(-1),cPictDev))+")"            
            EndIf      
         EndIf   
      Else
         If lMultiLinha
            If aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP] >= 0        
               @ li,010+nCoordImps PSAY Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP],cPictValor)
            Else 
               @ li,010+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))+")"            
            EndIf   
            Aadd(aLinha,{010+nCoordImps,aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP]})
         Else         
            If aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP] >= 0         
               @ li,027+nCoordImps PSAY Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP],cPictValor)
               @ li,044+nCoordImps PSAY Transform(aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP],cPictValor)
            Else
               @ li,027+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TBASIMP]*(-1),cPictDev))+")"
               @ li,044+nCoordImps PSAY Space(15-Len(AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP]*(-1),cPictDev))))+"("+AllTrim(Transform(aTotalGeral[nIndTipo][2][nPosicao][_TVALIMP]*(-1),cPictDev))+")"            
            EndIf      
         EndIf
      EndIf   
   EndIf   
Next nX                   
If Len(aLinha) > 0       
   li++      
   //Ordena de acordo com a coluna de impressao do valor         
   ASort(aLinha,,,{|x,y| x[1]< y[1]})               
   //Imprime o valor dos impostos         
   For nZ := 1 to Len(aLinha)
      If aLinha[nZ][_IMPOSTO] >= 0 
         @ li,aLinha[nZ][_COLUNA] PSAY Transform(aLinha[nZ][_IMPOSTO],cPictValor)
      Else 
         @ li,aLinha[nZ][_COLUNA] PSAY Space(15-Len(AllTrim(Transform(aLinha[nZ][_IMPOSTO]*(-1),cPictDev))))+"("+AllTrim(Transform(aLinha[nZ][_IMPOSTO]*(-1),cPictDev))+")"      
      EndIf   
   Next nZ      
EndIf   

#IFDEF TOP
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³LibCriaTemp³ Autor ³Fernando Machima       ³ Data ³ 31/10/02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Cria temporario a partir da selecao dos registros(TOP)       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³LIBRGER(TOPCONNECT)                                          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	Static Function LibCriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
	Local nI, nF
	Local nPosOrig
	Local nPosDest
	Local nTotalRec := 0
	
	nTotalRec := SF3->(RecCount())
	
	nF := (cAlias)->(FCount())
	
	cArqTmp := CriaTrab(aStruTmp,.T.)
	DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
	
	(cAlias)->(DbGoTop())
	
	ProcRegua( nTotalRec )
	
	While !(cAlias)->(Eof())
		
		IncProc()
		
		(cAliasTmp)->(DbAppend())
		For nI := 1 To Len(aStruTmp)
			nPosDest := (cAliasTmp)->(FieldPos(aStruTmp[nI,1]))
			nPosOrig := (cAlias)->(FieldPos(aStruTmp[nI,1]))
			If nPosDest > 0 .And. nPosOrig > 0
				(cAliasTmp)->(FieldPut(nPosDest,(cAlias)->(FieldGet(nPosOrig))))
			EndIf
		Next nI
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
	DbSelectArea(cAliasTmp)
	Return(NIL)
#ENDIF

/*
Coordenadas de Impressao dos impostos(Analitico)
li, 050 - base
li, 067 - valor

li, 084 - base
li, 101 - valor

li, 118 - base
li, 135 - valor

li, 152 - base
li, 169 - valor

li, 186 - base
li, 203 - valor
*/	

/*
Coordenadas de Impressao dos impostos(Analitico e Multi-Linha)
li, 053 - base
li+1, 053 - valor

li, 070 - base
li+1, 070 - valor

li, 087 - base
li+1, 087 - valor

li, 104 - base
li+1, 104 - valor

li, 121 - base
li+1, 121 - valor

li, 138 - base
li+1, 138 - valor

li, 155 - base
li+1, 155 - valor

li, 172 - base
li+1, 172 - valor
...
*/	

/*
Coordenadas de Impressao dos impostos(Sintetico)
li, 027 - base
li, 044 - valor

li, 061 - base
li, 078 - valor

li, 095 - base
li, 112 - valor

li, 129 - base
li, 146 - valor

li, 163 - base
li, 180 - valor
*/	

/*
Coordenadas de Impressao dos impostos(Sintetico e Multi-Linha)
li, 027 - base
li, 027 - valor

li, 044 - base
li, 044 - valor

li, 061 - base
li, 061 - valor

li, 078 - base
li, 078 - valor

li, 095 - base
li, 095 - valor

li, 112 - base
li, 112 - valor

li, 129 - base
li, 129 - valor

li, 146 - base
li, 146 - valor
...
*/	

