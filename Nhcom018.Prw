/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM018        ³ Jose Roberto Gorski   ³ Data ³ 11.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Performance de Fornecedores Analitico                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alterado  ³ Versão SQL Por Alexandre R. Bento       ³ Data ³ 22.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"       
#INCLUDE "TOPCONN.CH"

User Function Nhcom018()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_CARQDBF,_AFIELDS,_CNUMPED")
SetPrvt("_CTEMNOTA,_DENTRADA,_CARQNTX,_CORDEM,_CCABEC1,_LPRIMEIRO")
SetPrvt("_CFORNECE,_NMEDIAFOR,_NMEDIA,_NCONT,_CPED,_NDIAS")
//SetPrvt("_DDATA,_NPERFORMANCE,_CMEDIA,_nMedPer,_nCount,_cProd")
//SetPrvt("_nQtde,_nQtdeJE, _cDesc, _cDoc, _dDta, _cItem")
SetPrvt("aPerfor,_nPer,Lin,_cFor,aOrd")

_cFor    := Space(08)
cString  :="SC7"
cDesc1   := OemToAnsi("Este relatorio tem como objetivo demostrar a            ")
cDesc2   := OemToAnsi("performance dos fornecedores baseando-se pela data      ")
cDesc3   := OemToAnsi("prevista de entrega.                                   ")
tamanho  :="M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog :="NHCOM018"
aLinha   := { }
nLastKey := 0
lEnd     := .f.                              
Lin      := 0
titulo   :="Performance dos Fornecedores pela Data Prevista de Entrega"
cabec1   :="Performance dos Fornecedores pela Data Prevista de Entrega"
cabec2   :=""
cCancel  := "***** CANCELADO PELO OPERADOR *****"
_nMedPer := 0
_nCount  := 0
_nPag    := 1  //Variavel que acumula numero da pagina
m_pag    := 1
                                                 
wnrel    :="NHCOM018"          //Nome Default do relatorio em Disco
_cPerg   := "COM018"
aOrd     := {OemToAnsi("Por Fornecedor"),OemToAnsi("Por Produto")} 

/*/
Parametros Utilizados
mv_par01 = Da Data
mv_par02 = Ate a Data
mv_par03 = Do Fornecedor
mv_par04 = Ate o Fornecedor
mv_par05 = Qualificação =S/N
mv_par06 = Analitico/Sintetico
/*/                         


Pergunte(_cPerg,.f.)
//SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,tamanho)

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

Processa( {|| Gerando() },"Gerando Base para o Relatorio...")


If mv_par06 == 2
	Processa( {|| RptDetail() } )
Else
	Processa( {|| RptDet2() } )
Endif



Roda(0,"","M")
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
DbSelectArea("TMP")
DbCloseArea()

Return


Static Function Gerando()

//QUERY REFEITA - JOAOFR 01/04/2014

cQuery := "SELECT SC7.C7_FORNECE,SC7.C7_LOJA,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_QUJE,SC7.C7_RESIDUO,SC7.C7_NUM, "
cQuery += " SC7.C7_DATPRF,SA2.A2_COD,SA2.A2_LOJA,SA2.A2_NOME,SD1.D1_DTDIGIT,SD1.D1_QUANT,SD1.D1_DOC,SC7.C7_ITEM,SA2.A2_QUALIF"
cQuery += " FROM " + RetSqlName('SC7') + " SC7 INNER JOIN "
cQuery += RetSqlName('SA2') + " SA2 (NOLOCK) ON "
cQuery += " SC7.C7_FORNECE = SA2.A2_COD "
cQuery += " AND SC7.C7_LOJA = SA2.A2_LOJA "
cQuery += " AND SA2.D_E_L_E_T_ = ' ' AND SA2.A2_FILIAL='"+xFilial('SA2')+"'" 

If mv_par05$"s/S"    
   cQuery +=  " AND SA2.A2_QUALIF = 'S'"
Endif   

cQuery += " LEFT JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK) ON"
cQuery += "	    SC7.C7_NUM = SD1.D1_PEDIDO "
cQuery += " AND SC7.C7_PRODUTO = SD1.D1_COD "
cQuery += " AND SC7.C7_ITEM = SD1.D1_ITEMPC  "
cQuery += " AND SC7.C7_FORNECE = SD1.D1_FORNECE"
cQuery += " AND SC7.C7_LOJA = SD1.D1_LOJA"
cQuery += " AND SD1.D_E_L_E_T_ = ' ' AND SD1.D1_FILIAL='"+xFilial('SD1')+"'"            
cQuery += " WHERE SC7.C7_DATPRF BETWEEN '" + DtoS(Mv_par01) + "' AND '" + DtoS(Mv_par02) + "'"
cQuery += " AND SC7.C7_FORNECE BETWEEN '" + mv_par03 + "' And '" +  mv_par04 + "'"
cQuery += " AND SC7.D_E_L_E_T_ = ' ' AND SC7.C7_FILIAL='"+xFilial('SC7')+"'"            
cQuery += " ORDER BY SC7.C7_FORNECE,SC7.C7_LOJA,SC7.C7_PRODUTO"

 MemoWrit('C:\TEMP\COM018.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de digitaçao de string para date    
TcSetField("TMP","C7_DATPRF","D") // Muda a data de preferencia de string para date

Return

Static Function RptDetail()
Local _ni
Local _nix
Local _nDiasAt := 0   
Local _nqtdeAt := 0      
Local _nItemNE := 0    
Local _nqtdeEn := 0    
Local _nqtdeRe := 0   //Qtde restante a entregar
Local _cCod    := Space(15)
Local _cNumPed := Space(10)
Local _nMedia  := 0
Local _cPedItem
 aPerfor := {}


ProcRegua(TMP->(RecCount()))

TMP->(DbGoTop())

//               10         20       30         40       50        60         70       80          90     100      110        120       130        140
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

If aReturn[8] == 1 //ordem por Fornecedor
   _cCabec1 := "FORNECEDOR                                         QTDE ENTREGUE     QTDE EM ATRASO    QTDE TOTAL   ITENS ATRASO PERFORMA MEDIA/DIA"
Else
   _cCabec1 := "PRODUTO         DESCRICAO                          QTDE ENTREGUE     QTDE EM ATRASO    QTDE TOTAL   ITENS ATRASO PERFORMA MEDIA/DIA"                
Endif

If Empty(TMP->C7_FORNECE)
   Return  // Se não encontrou nada retorna sem imprimir nada
Endif    
         
DbSelectArea("TMP")
While TMP->(!Eof())

   If TMP->C7_QUJE == 0 .And. TMP->C7_RESIDUO == 'S'
      TMP->(Dbskip())
      Loop
   Endif

   _cPedItem := TMP->C7_NUM + TMP->C7_ITEM
   _nDiasAt  := 0   
   _nqtdeAt  := 0      
   _nItemNE  := 0    //qtde nao entregue
   _nqtdeEn  := 0   //qtde entregue dentro do periodo
   _nqtdeTO  := 0   //Qtde total entrgue
   _nqtdeRe  := 0   //Qtde restante a entregar
   	
   If aReturn[8] == 1 //ordem por Fornecedor
      _ni  := Ascan(aPerfor, {|x| x[1]+x[2] == TMP->C7_FORNECE+TMP->C7_LOJA})
      If _cCod <> TMP->C7_PRODUTO
         //_nItemNE := 1 //soma um nos itens nao entregue                     
         _cCod := TMP->C7_PRODUTO
      Endif
   Else //por item
      _ni := Ascan(aPerfor, {|x| x[1]+x[2]+x[3] == TMP->C7_FORNECE+TMP->C7_LOJA+TMP->C7_PRODUTO})   
      //If _ni == 0      
      //   _nItemNE := 1 //soma um nos itens nao entregue                     
      //Endif
   Endif   
   

   // Calcula o dia     
   _nDiasAt := 0
   If !Empty(TMP->D1_DTDIGIT)     

      _nDiasAt := TMP->D1_DTDIGIT - TMP->C7_DATPRF

      If Month(TMP->D1_DTDIGIT) > Month(TMP->C7_DATPRF)//verifica se foi entregue fora do mes
         _nqtdeTO := TMP->D1_QUANT     
         _nqtdeAt := TMP->D1_QUANT // qtde entregue em atraso fora do mes                   
      Else                             
         _nqtdeTO := TMP->D1_QUANT     
	     If (_nDiasAt > 0) //qtde recebida em atraso
             _nItemNE := 1 //soma um nos itens nao entregue                     
	         _nqtdeAt := TMP->D1_QUANT // qtde entregue em atraso          
	     Else
	          _nqtdeEn := TMP->D1_QUANT //qtde entregue ate data do pedido          
	     Endif   
	  Endif   
	  If TMP->C7_QUANT <> TMP->C7_QUJE
	     If _cNumPed <> TMP->C7_NUM+TMP->C7_ITEM
            _cNumPed := TMP->C7_NUM+TMP->C7_ITEM	     
            _nqtdeRe := TMP->C7_QUANT - TMP->C7_QUJE  //Qtde restante a entregar           
	     Endif
	  Endif
   Else  // Nao foi entregue
      _nqtdeAt := TMP->C7_QUANT - TMP->C7_QUJE //qtde a ser entregue pelo fornecedor
      _nqtdeTO := TMP->C7_QUANT - TMP->C7_QUJE //qtde total a ser entregue pelo fornecedor
   Endif       
   
   If _ni <> 0
      aPerfor [_ni][5]  += _nqtdeEn
      aPerfor [_ni][6]  += _nqtdeAt + _nqtdeRe
      aPerfor [_ni][7]  += _nItemNE
      aPerfor [_ni][9]  += _nqtdeTO + _nqtdeRe
      aPerfor [_ni][10] += _nDiasAt
   Else
	   Aadd(aPerfor,{TMP->C7_FORNECE,;
			         TMP->C7_LOJA,;
					 TMP->C7_PRODUTO,;
				   	 TMP->C7_DESCRI,;
				     _nqtdeEn,;
			   	     _nqtdeAt+_nqtdeRe,;
 				     _nItemNE,;
 				     TMP->A2_NOME,;
				     _nqtdeTO+_nqtdeRe,;
				     _nDiasAt})
   Endif

   TMP->(Dbskip())
   If _cPedItem == TMP->C7_NUM + TMP->C7_ITEM
	   TMP->(Dbskip())      
   Endif

Enddo

   
Cabecalho()

_lPrimeiro := .t.

If aReturn[8] == 1 //ordem por Fornecedor
   aPerfor := ASort(aPerfor,,, { |x, y| x[1]+x[2] < y[1]+y[2]})  //orderna a matriz
Else
   aPerfor := ASort(aPerfor,,, { |x, y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3]})  //orderna a matriz
Endif   

For _ni:= 1 to len(aPerfor)
   _nPer := 0
   
   If aReturn[8] == 2 //ordem por Item
      If _cFor <> aPerfor[_ni][1]+ aPerfor[_ni][2]
         If !Empty(_cFor)
            Lin := Lin + 1
         Endif
         _cFor := AllTrim(aPerfor[_ni][1])+ AllTrim(aPerfor[_ni][2]) //fornecedor + loja
         @ Lin + 1 , 001 Psay "FORNECEDOR: " + AllTrim(aPerfor[_ni][1])+"-"+ AllTrim(aPerfor[_ni][2]) + " - "  + AllTrim(aPerfor[_ni][8])
         Lin := Lin + 1
      Endif   
   Endif
   
   If Lin > 60
      Lin := 0
      _nPag := _nPag + 1
      Cabecalho()
   Endif                                                 

   _nMedia := (aPerfor[_ni][10]/aPerfor[_ni][07])
   _nPer := ( 1- ( (aPerfor[_ni][7]+aPerfor[_ni][6]+_nMedia) / (aPerfor[_ni][5] + aPerfor[_ni][6]) ))*100   

   If _nPer < 0
       _nPer := 0
   Endif    

   // Imprime os Dados
   Lin := Lin + 1    
   If aReturn[8] == 1 //imprime por Fornecedor
      @ Lin    , 001 Psay AllTrim(aPerfor[_ni][1])+"-"+ AllTrim(aPerfor[_ni][2]) + " - "  + AllTrim(Subs(aPerfor[_ni][8],1,35))      
      @ Lin    , 052 Psay aPerfor[_ni][5]   Picture "@E 999,999.99"
      @ Lin    , 070 Psay aPerfor[_ni][6]  Picture "@E 999,999.99"    
      @ Lin    , 088 Psay aPerfor[_ni][9]  Picture "@E 999,999.99"          
      @ Lin    , 105 Psay aPerfor[_ni][7] Picture "@E 999"         
      @ Lin    , 118 Psay Iif(_nPer==0,"  0%",Transform(_nPer,"@E 999") +"%")
      @ Lin    , 124 Psay _nMedia Picture "@E 999"
   Else //imprime por item
      @ Lin    , 001 Psay Alltrim(aPerfor[_ni][3])
      @ Lin    , 016 Psay Subs(aPerfor[_ni][4],1,30)
      @ Lin    , 052 Psay aPerfor[_ni][5]   Picture "@E 999,999.99"
      @ Lin    , 070 Psay aPerfor[_ni][6]  Picture "@E 999,999.99"    
      @ Lin    , 088 Psay aPerfor[_ni][9]  Picture "@E 999,999.99"          
      @ Lin    , 105 Psay aPerfor[_ni][7] Picture "@E 999"         
      @ Lin    , 118 Psay Iif(_nPer==0,"  0%",Transform(_nPer,"@E 999") +"%")
      @ Lin    , 124 Psay _nMedia Picture "@E 999"
   Endif   

Next _ni         

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Cabecalhos³  Autor³ Jose Roberto Gorski   ³ Data ³ 27.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cabecalho do Relatorio                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function Cabecalho()

aDriver := ReadDriver()

If ( Tamanho == 'P' )
    @ 0,0 PSAY &(aDriver[1])
ElseIf ( Tamanho == 'G' )
    @ 0,0 PSAY &(aDriver[5])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 1 ) 
    @ 0,0 PSAY &(aDriver[3])
ElseIf ( Tamanho == 'M' ) .And. ( aReturn[4] == 2 ) 
    @ 0,0 PSAY &(aDriver[4])
EndIf 

@ Lin+1,00   Psay Repli("*",132)
Lin := Lin + 1
@ Lin+1,00   Psay "*"+SM0->M0_NOMECOM
@ Lin+1,112  Psay "Folha : "                                                                                                    
@ Lin+1,124  Psay StrZero(_nPag,5,0)+"  *"
@ Lin+2,00   Psay "*S.I.G.A. / "+nomeprog
@ Lin+2,20   Psay PadC(titulo,82)
@ Lin+2,112  Psay "DT.Ref.: "+Dtoc(dDataBase)+"*"
@ Lin+2+1,00 Psay "*Hora...: "+Time()
@ Lin+3  ,41 Psay "Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) +"  "+Iif(aReturn[8] == 1,"Por Fornecedor"," Por Produto")
@ Lin+3,112  Psay "Emissao: "+Dtoc(Date())+"*"
@ Lin+4 ,00  Psay Repli("*",132)
@ Lin+5,00   Psay " "
lin:=Lin+5
@ Lin + 1 , 001 Psay _cCabec1       
Lin := Lin + 1         

Return
                                  


Static Function RptDet2()
Local _ni
Local _nix
Local _nDiasAt := 0   
Local _nqtdeAt := 0      
Local _nItemNE := 0    
Local _nqtdeEn := 0    
Local _nqtdeRe := 0   //Qtde restante a entregar
Local _cCod    := Space(15)
Local _cNumPed := Space(10)
Local _PedItem
aPerfor := {}
tamanho :="G"

ProcRegua(TMP->(RecCount()))



TMP->(DbGoTop())
//               10         20       30         40       50        60         70       80          90     100      110        120       130        140
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Cabec1 := "Produto         Descricao                        Qt. Entregue     Qtde Atraso          Qtde total  Iten(s) em Atraso     Performa            Nr.Pedido    Item           Dt.Prevista    Dt.Entrega  Dias atraso"

Titulo += " Periodo de: " + DtoC(mv_par01) + " Ate: " + DtoC(mv_par02) 


If Empty(TMP->C7_FORNECE)
   Return  // Se não encontrou nada retorna sem imprimir nada
Endif    
         
DbSelectArea("TMP")
While TMP->(!Eof())

   If TMP->C7_QUJE == 0 .And. TMP->C7_RESIDUO == 'S'
      TMP->(Dbskip())
      Loop
   Endif

   _cPedItem := TMP->C7_NUM + TMP->C7_ITEM
   _nDiasAt  := 0   
   _nqtdeAt  := 0      
   _nItemNE  := 0    //qtde nao entregue
   _nqtdeEn  := 0   //qtde entregue dentro do periodo
   _nqtdeTO  := 0   //Qtde total entrgue
   _nqtdeRe  := 0   //Qtde restante a entregar

   	
   If aReturn[8] == 1 //ordem por Fornecedor
      _ni  := Ascan(aPerfor, {|x| x[1]+x[2] == TMP->C7_FORNECE+TMP->C7_LOJA})
      If _cCod <> TMP->C7_PRODUTO
         //_nItemNE := 1 //soma um nos itens nao entregue                     
         _cCod := TMP->C7_PRODUTO
      Endif
   Else //por item
      _ni := Ascan(aPerfor, {|x| x[1]+x[2]+x[3] == TMP->C7_FORNECE+TMP->C7_LOJA+TMP->C7_PRODUTO})   
      //If _ni == 0      
      //   _nItemNE := 1 //soma um nos itens nao entregue                     
      //Endif
   Endif   
   
   /*	
   _ni := Ascan(aPerfor, {|x| x[1]+x[2]+x[3] == TMP->C7_FORNECE+TMP->C7_LOJA+TMP->C7_PRODUTO})   
   If _ni == 0      
      _nItemNE := 1 //soma um nos itens nao entregue                     
   Endif   
   */
   
   // Calcula o dia
   _nDiasAt := 0
   If !Empty(TMP->D1_DTDIGIT)
      // If TMP->D1_DTDIGIT <= TMP->C7_DATPRF
         _nDiasAt := TMP->D1_DTDIGIT - TMP->C7_DATPRF
	  // Endif	

      If Month(TMP->D1_DTDIGIT) > Month(TMP->C7_DATPRF)//verifica se foi entregue fora do mes
         _nqtdeTO := TMP->D1_QUANT 
         _nqtdeAt := TMP->D1_QUANT // qtde entregue em atraso fora do mes
      Else
         _nqtdeTO := TMP->D1_QUANT
	     If (_nDiasAt > 0) //qtde recebida em atraso
	         _nqtdeAt := TMP->D1_QUANT // qtde entregue em atraso
	         _nItemNE := 1 //soma um nos itens nao entregue                     
	     Else
	          _nqtdeEn := TMP->D1_QUANT //qtde entregue ate data do pedido 
	     Endif
	  Endif
	  If TMP->C7_QUANT <> TMP->C7_QUJE 
	     If _cNumPed <> TMP->C7_NUM+TMP->C7_ITEM 
            _cNumPed := TMP->C7_NUM+TMP->C7_ITEM
            _nqtdeRe := TMP->C7_QUANT - TMP->C7_QUJE  //Qtde restante a entregar           
	     Endif
	  Endif
   Else  // Nao foi entregue
      _nqtdeAt := TMP->C7_QUANT - TMP->C7_QUJE //qtde a ser entregue pelo fornecedor
      _nqtdeTO := TMP->C7_QUANT - TMP->C7_QUJE //qtde total a ser entregue pelo fornecedor
   Endif       
   
   Aadd(aPerfor,{TMP->C7_FORNECE,;
                 TMP->C7_LOJA,;
                 TMP->C7_PRODUTO,;
                 TMP->C7_DESCRI,;
                 _nqtdeEn,;
                 _nqtdeAt+_nqtdeRe,;
                 _nItemNE,;
                 TMP->A2_NOME,;
                 _nqtdeTO+_nqtdeRe,;
                 TMP->C7_NUM,;
                 TMP->C7_ITEM,;
                 TMP->C7_DATPRF,;
                 TMP->D1_DTDIGIT,;
                 TMP->D1_QUANT,;
                 _nDiasAt })
             
   TMP->(Dbskip())
   If _cPedItem == TMP->C7_NUM + TMP->C7_ITEM
	   TMP->(Dbskip())      
   Endif

Enddo
   

// Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho)

_lPrimeiro := .t.

aPerfor := ASort(aPerfor,,, { |x, y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3]})  //orderna a matriz
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho)

For _ni:= 1 to len(aPerfor)
   _nPer := 0
   
   If Prow() > 60
      Lin := 0
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho)
   Endif
   
   If _cFor <> aPerfor[_ni][1]+ aPerfor[_ni][2]
      _cFor := AllTrim(aPerfor[_ni][1])+ AllTrim(aPerfor[_ni][2]) //fornecedor + loja
      @ Prow() + 1 , 001 Psay "FORNECEDOR: " + AllTrim(aPerfor[_ni][1])+"-"+ AllTrim(aPerfor[_ni][2]) + " - "  + AllTrim(aPerfor[_ni][8])
   Endif

//   If aPerfor[_ni][5] == aPerfor[_ni][6] // qtde igual entrega e atraso gera performance de 50%
//      _nPer := 50      
//   Else
      _nPer := (1-((aPerfor[_ni][7]+aPerfor[_ni][6])/ (aPerfor[_ni][5] + aPerfor[_ni][6] + aPerfor[_ni][15])))*100   
//   Endif

   If _nPer < 0
       _nPer := 0
   Endif

   // Imprime os Dados
   @ Prow()+001, 001 Psay Alltrim(aPerfor[_ni][3])
   @ Prow()    , 016 Psay Subs(aPerfor[_ni][4],1,30)
   @ Prow()    , 052 Psay aPerfor[_ni][5]   Picture "@E 999,999.99"
   @ Prow()    , 070 Psay aPerfor[_ni][6]   Picture "@E 999,999.99"
   @ Prow()    , 088 Psay aPerfor[_ni][9]   Picture "@E 999,999.99"
   @ Prow()    , 109 Psay aPerfor[_ni][7]   Picture "@E 999"
   @ Prow()    , 124 Psay Iif(_nPer==0,"  0%",Transform(_nPer,"@E 999") +"%")
   @ Prow()    , 144 Psay aPerfor[_ni][10]
   @ Prow()    , 154 Psay aPerfor[_ni][11]
   @ Prow()    , 170 Psay aPerfor[_ni][12]
   @ Prow()    , 184 Psay aPerfor[_ni][13]
   @ Prow()    , 198 Psay aPerfor[_ni][15]   Picture "@E 999"

Next _ni         

Return
