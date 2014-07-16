/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHEST025  บAutor  ณAlexandre R. Bento  บ Data ณ  28/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Inventแrio por Local                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest025()

SetPrvt("_cCod,nTotal,nTipo")

cString   := "SZB"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Lista de Normas")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST025"
nLastKey  := 0
titulo    := "RELATำRIO DE INVENTมRIO"
Cabec1    := "COD PRODUTO    COD.CLIENTE          LOCAL 00       LOCAL 01       LOCAL 02       LOCAL 03       LOCAL 04       LOCAL 10       LOCAL 50       LOCAL 95       LOCAL 96       LOCAL 97       LOCAL 99          TOTAL"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST025"
_cPerg    := "" 
_cCod     := Space(06)

AjustaSx1()                                                               

If !Pergunte('EST025',.T.)
    Return(nil)
Endif   

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

if nlastKey ==27
    Set Filter to
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
   cQuery := "SELECT SZB.ZB_COD,SB1.B1_CODAP5,SZB.ZB_LOCAL,SUM(SZB.ZB_QTDE3) AS TOTAL "
   cQuery += " FROM " + RetSqlName( 'SZB' ) +" SZB, " + RetSqlName( 'SB1' ) +" SB1"        
   cQuery += " WHERE SZB.ZB_FILIAL = '" + xFilial("SZB")+ "'"
   cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
   cQuery += " AND SZB.ZB_ETIQ BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
   cQuery += " AND SZB.ZB_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"   
   cQuery += " AND SZB.ZB_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
   cQuery += " AND SZB.ZB_LOCAL BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"   
   cQuery += " AND SZB.ZB_DATA BETWEEN '" + Dtos(mv_par09) + "' AND '" + Dtos(mv_par10) + "'"      
   cQuery += " AND SZB.ZB_COD = SB1.B1_COD"
   cQuery += " AND SZB.D_E_L_E_T_ <> '*' "  
   cQuery += " AND SB1.D_E_L_E_T_ <> '*' "  
   cQuery += " GROUP BY SZB.ZB_COD,SB1.B1_CODAP5,SZB.ZB_LOCAL" 
   cQuery += " ORDER BY SZB.ZB_COD,SZB.ZB_LOCAL ASC" 

   TCQUERY cQuery NEW ALIAS "TMP"  
  
Return                                   


Static Function RptDetail()

nTotal := 0

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Titulo += " DO DIA "+ Dtoc(mv_par09)

If SM0->M0_CODIGO = 'NH' 
	Cabec1    := "COD PRODUTO    COD.CLIENTE          LOCAL 00       LOCAL 01       LOCAL 02       LOCAL 03       LOCAL 04       LOCAL 10       LOCAL 50       LOCAL 95       LOCAL 96       LOCAL 97       LOCAL 99          TOTAL"
Elseif SM0->M0_CODIGO = 'FN' 
	Cabec1    := "COD PRODUTO    COD.CLIENTE          LOCAL 30       LOCAL 32       LOCAL 33       LOCAL 34       LOCAL 35       LOCAL 36       LOCAL 37       LOCAL 38       LOCAL 39                                        TOTAL"
Endif
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

While TMP->(!Eof())

   If Prow() > 60 .And. _cCod <> TMP->ZB_COD      
      //  Imprime a qtde na ultima linha antes de saltar a pagina
      @ Prow() , 195 Psay nTotal Picture "@E 999,999,999.99"  //Imprime o total quando salta a pagina                                                       
      _nPag := _nPag + 1
       Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif
   
   If _cCod <> TMP->ZB_COD
      
      If !Empty(_cCod)
         @ Prow()    , 195 Psay nTotal Picture "@E 999,999,999.99"         
         nTotal := 0  // Zera Totalizador
      Endif
      _cCod := TMP->ZB_COD
      @ Prow() + 1, 000 Psay Subs(TMP->ZB_COD,1,15)
      @ Prow()    , 017 Psay TMP->B1_CODAP5

      If SM0->M0_CODIGO = 'NH' 
         If TMP->ZB_LOCAL == "00"
           @ Prow()    , 030 Psay TMP->TOTAL Picture "@E 999,999,999.99"
         Elseif TMP->ZB_LOCAL == "01"    
           @ Prow()    , 045 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "02"    
           @ Prow()    , 060 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "03"    
           @ Prow()    , 075 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "04"    
           @ Prow()    , 090 Psay TMP->TOTAL Picture "@E 999,999,999.99"                 
         Elseif TMP->ZB_LOCAL == "10"    
           @ Prow()    , 105 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "50"    
      	    @ Prow()    , 120 Psay TMP->TOTAL Picture "@E 999,999,999.99"
	     Elseif TMP->ZB_LOCAL == "95"    
            @ Prow()    , 135 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "96"    
            @ Prow()    , 150 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "97"    
            @ Prow()    , 165 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "99" 
            @ Prow()    , 180 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Endif   
      Elseif SM0->M0_CODIGO = 'FN' 
		 If TMP->ZB_LOCAL == "30"    
      	    @ Prow()    , 030 Psay TMP->TOTAL Picture "@E 999,999,999.99"
	     Elseif TMP->ZB_LOCAL == "32"    
            @ Prow()    , 045 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
	     Elseif TMP->ZB_LOCAL == "33"    
            @ Prow()    , 060 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "34"    
            @ Prow()    , 075 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "35"    
            @ Prow()    , 090 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "36"    
            @ Prow()    , 105 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "37"    
            @ Prow()    , 120 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "38"    
            @ Prow()    , 135 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "39"    
            @ Prow()    , 150 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Endif   
	  Endif

   Else

      If SM0->M0_CODIGO = 'NH'    
         If TMP->ZB_LOCAL == "00"
	         @ Prow()    , 030 Psay TMP->TOTAL Picture "@E 999,999,999.99"
	     Elseif TMP->ZB_LOCAL == "01"    
	         @ Prow()    , 045 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "02"    
             @ Prow()    , 060 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "03"    
             @ Prow()    , 075 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "04"    
             @ Prow()    , 090 Psay TMP->TOTAL Picture "@E 999,999,999.99"                 
         Elseif TMP->ZB_LOCAL == "10"    
             @ Prow()    , 105 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "50"    
       	     @ Prow()    , 120 Psay TMP->TOTAL Picture "@E 999,999,999.99"
         Elseif TMP->ZB_LOCAL == "95"    
             @ Prow()    , 135 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "96"    
             @ Prow()    , 150 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "97"    
             @ Prow()    , 165 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "99" 
             @ Prow()    , 180 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Endif   
      Elseif SM0->M0_CODIGO = 'FN' 
		 If TMP->ZB_LOCAL == "30"    
      	    @ Prow()    , 030 Psay TMP->TOTAL Picture "@E 999,999,999.99"
	     Elseif TMP->ZB_LOCAL == "32"    
            @ Prow()    , 045 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
	     Elseif TMP->ZB_LOCAL == "33"    
            @ Prow()    , 060 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "34"    
            @ Prow()    , 075 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "35"    
            @ Prow()    , 090 Psay TMP->TOTAL Picture "@E 999,999,999.99"         
         Elseif TMP->ZB_LOCAL == "36"    
            @ Prow()    , 105 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "37"    
            @ Prow()    , 120 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "38"    
            @ Prow()    , 135 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Elseif TMP->ZB_LOCAL == "39"    
            @ Prow()    , 150 Psay TMP->TOTAL Picture "@E 999,999,999.99"        
         Endif   
	  Endif

   Endif
	
	// ACUMULA
   nTotal += TMP->TOTAL

	TMP->(DbSkip())  
 
Enddo
@ Prow()    , 195 Psay nTotal Picture "@E 999,999,999.99"  //Imprime o ultimo codigo do produto       
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := Space(10)
cPerg   := "EST025    "
aRegs   := {}

aadd(aRegs,{cPerg,"01","Da Etiqueta      ?","da Etiqueta      ?","da Etiqueta      ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","At้ Etiqueta     ?","at้ Etiqueta     ?","at้ Etiqueta     ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Do Documento     ?","da Documento     ?","da Documento     ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","At้ Documento    ?","at้ Documento    ?","at้ Documento    ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Do Produto       ?","do Produto       ?","do Produto       ?","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","At้ Produto      ?","at้ Produto      ?","at้ Produto      ?","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Do Local         ?","do Local         ?","do Local         ?","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","At้ Local        ?","at้ Local        ?","at้ Local        ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"09","Da Data          ?","da Data          ?","da Data          ?","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"10","At้ Data         ?","at้ Data         ?","at้ Data         ?","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})


cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock("SX1")
      SX1->(DbDelete())
      MsUnLock("SX1")
      SX1->(DbSkip())
   Enddo

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock("SX1")

   Next
EndIf                   

dbSelectArea(_sAlias)

Return
                           

