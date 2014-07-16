/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST070  ºAutor  ³Alexadre R. Bento    º Data ³  18/04/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Requisição de Material RM                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest070()

SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")
SetPrvt("_cCC,_nTotal")

cString   := "SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Requisição de Material")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST070"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE REQUISIÇÃO DE MATERIAL RM")
cabec1    := "                                                      Periodo de "
Cabec2    := "Centro de Custo:"
//Cabec2    := "COD PRODUTO    DESCRIÇÃO DO PRODUTO              DOC      DATA            QTDE     VLR UNIT        TOTAL"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST070"
_cPerg    := "EST070" 
aOrd      := {OemToAnsi("Por C.Custo + Produto"),OemToAnsi("Por Centro de Custo")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '
_nTotal   := 0
AjustaSx1()                                                               

Pergunte(_cPerg,.F.)
/*
If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   
*/
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,tamanho)

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

// aReturn[8] == 2 //ordem por etiqueta
//   Cabec1    := "COD PRODUTO    COD.CLIENTE    DESCRIÇÃO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
//Endif   

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

TMP->(DbCloseArea())

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

  If Mv_par07== 1
     cQuery :="SELECT SD3.D3_COD,SB1.B1_DESC,SD3.D3_CC,SB1.B1_UPRC, "
	 cQuery += " SUM(SD3.D3_QUANT) AS D3_QUANT,CTT.CTT_DESC01 "
     cQuery += " FROM " + RetSqlName( 'SD3' ) +" SD3, " + RetSqlName( 'SB1' ) +" SB1," + RetSqlName( 'CTT' ) +" CTT"                
     cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "'"
     cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
     cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"     
     cQuery += " AND SD3.D3_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
     cQuery += " AND SD3.D3_EMISSAO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"      
     cQuery += " AND SD3.D3_CC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"   
     cQuery += " AND SD3.D3_COD = SB1.B1_COD"
     cQuery += " AND SD3.D3_CC = CTT.CTT_CUSTO"     
//     cQuery += " AND SI3.I3_CONTA = ' '"          
     cQuery += " AND SD3.D_E_L_E_T_ = ' ' "  
     cQuery += " AND SB1.D_E_L_E_T_ = ' ' "  
     cQuery += " AND CTT.D_E_L_E_T_ = ' ' "        
     cQuery += " GROUP BY SD3.D3_COD,SB1.B1_DESC,SD3.D3_CC,CTT.CTT_DESC01,SB1.B1_UPRC"     
     If aReturn[8] == 1 //ordem por CC + PRODUTO
        cQuery += " ORDER BY SD3.D3_CC,SD3.D3_COD ASC" 
     Else //ordem por Produto
        cQuery += " ORDER BY SD3.D3_CC ASC" 
     Endif      

  Else
	 cQuery := " SELECT SD3.D3_CC,CTT.CTT_DESC01,SUM(SB1.B1_UPRC*SD3.D3_QUANT) AS 'TOTAL' "
     cQuery += " FROM " + RetSqlName( 'SD3' ) +" SD3, " + RetSqlName( 'CTT' ) +" CTT,"+ RetSqlName( 'SB1' ) +" SB1"                
     cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "'"
     cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"     
     cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"     
     cQuery += " AND SD3.D3_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
     cQuery += " AND SD3.D3_EMISSAO BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'"      
     cQuery += " AND SD3.D3_CC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"   
     cQuery += " AND SD3.D3_CC = CTT.CTT_CUSTO"        
     cQuery += " AND SD3.D3_COD = SB1.B1_COD"     
     cQuery += " AND SD3.D_E_L_E_T_ = ' ' "  
     cQuery += " AND CTT.D_E_L_E_T_ = ' ' "       
     cQuery += " GROUP BY SD3.D3_CC,CTT.CTT_DESC01"
     cQuery += " ORDER BY SD3.D3_CC ASC" 

   Endif
   
   MemoWrit('C:\TEMP\EST070.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"     
   IF Mv_par07 == 1
      TcSetField("TMP","D3_EMISSAO","D")  // Muda a data de string para date    
   Endif   
  
Return                                   


Static Function RptDetail()
      
DBSELECTAREA("TMP")
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
Cabec1 := Cabec1 + Dtoc(Mv_par03) + ' Ate '+ Dtoc(Mv_par04)
If mv_par07 == 1
   Cabec2 := Cabec2 + TMP->D3_CC+" - "+ TMP->CTT_DESC01
Else
   Cabec2 := ""
Endif   
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
_cCC := TMP->D3_CC
If mv_par07 == 1
  @ Prow() + 1, 000 Psay "COD PRODUTO    DESCRIÇÃO DO PRODUTO                                       QTDE     VLR UNIT        TOTAL"
Else
  @ Prow() + 1, 000 Psay "CENTRO DE CUSTO                                                                                  TOTAL"
Endif

While TMP->(!Eof())
   If Prow() > 65
      _nPag  := _nPag + 1   
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
      If mv_par07 == 1    
         Cabec2 := "Centro de Custo: " + TMP->D3_CC+" - "+ TMP->CTT_DESC01
         @ Prow() + 1, 000 Psay "COD PRODUTO    DESCRIÇÃO DO PRODUTO                                       QTDE     VLR UNIT        TOTAL"
      Else 
         @ Prow() + 1, 000 Psay "CENTRO DE CUSTO                                                                                  TOTAL"
      Endif  
   Endif
   
   If mv_par07 == 1    
	   If _cCC <> TMP->D3_CC                                                                   
   	      @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
	      @ Prow() + 1, 055 Psay "Total Geral da Requisição : " 
	      @ Prow()    , 084 Psay _nTotal picture "@E 99,999,999,999,999.99"   
	      @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina   
   	      _cCC   := TMP->D3_CC
          Cabec2 := "Centro de Custo: " + TMP->D3_CC+" - "+ TMP->CTT_DESC01
	      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 	      
//	      @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina            
	      @ Prow() + 1, 000 Psay "COD PRODUTO    DESCRIÇÃO DO PRODUTO                                       QTDE     VLR UNIT        TOTAL"
	      _nTotal   := 0 // Zera total
	   Endif
   
	   @ Prow() + 1, 000 Psay Subs(TMP->D3_COD,1,13)
	   @ Prow()    , 015 Psay TMP->B1_DESC
	   @ Prow()    , 065 Psay TMP->D3_QUANT Picture "@E 999,999,999.99" 	
	   @ Prow()    , 077 Psay TMP->B1_UPRC Picture "@E 999,999,999.99"
	   @ Prow()    , 092 Psay TMP->D3_QUANT * TMP->B1_UPRC Picture "@E 999,999,999.99"
	   _nTotal += (TMP->D3_QUANT * TMP->B1_UPRC) // Guarda o totais de Centro de Custo
   Else
   
   	   @ Prow() + 1, 000 Psay TMP->D3_CC
	   @ Prow()    , 015 Psay TMP->CTT_DESC01
	   @ ProW()    , 084 Psay TMP->TOTAL picture "@E 99,999,999,999,999.99"   
   	   _nTotal += TMP->TOTAL // Guarda o totais de Centro de Custo
   Endif  
                    
	
   TMP->(DbSkip())  
 
Enddo

//@ Prow() + 1, 055 Psay "Total Geral da Requisição : " 
//@ Prow()    , 084 Psay _nTotal picture "@E 99,999,999,999,999.99"   

     
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "EST070"+Space(04)
aRegs   := {}
                                                      	
aadd(aRegs,{cPerg,"01","Do Produto       ?","do Produto       ?","do Produto       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Até Produto      ?","até Produto      ?","até Produto      ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Da Data          ?","da Data          ?","da Data          ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Até Data         ?","até Data         ?","até Data         ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Do Centro Custo  ?","Do Centro Custo  ?","Do Centro Custo  ?","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Até Centro Custo ?","até Centro Custo ?","até Centro Custo ?","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Tipo Relatorio    ?","Tipo Relatorio  ?","Tipo Relatorio   ?","mv_ch7","C",01,0,0,"C","","mv_par07","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
      MsUnLock('SX1')
      SX1->(DbSkip())
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
                           

