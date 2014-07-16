/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHEST048  บAutor  ณSandroval           บ Data ณ  17/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Inventแrio                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB usinagem                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบAltera็ใo ณ Alexandre R. Bento 04/10/06 colocar a opera็ใo             บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest048()

SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")

cString   := "SZB"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Lista de Normas")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST048"
aLinha    := { }
nLastKey  := 0
titulo    := "RELATำRIO DE INVENTมRIO"
Cabec1    := "COD PRODUTO    COD.CLIENTE    DESCRIวรO DO PRODUTO   ETIQ    DOC   ALM LOCALIZ  LOTE  OPER        QTDE 1        QTDE 2        QTDE 3"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST048"
_cPerg    := "EST048" 
aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '

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

if aReturn[8] == 2 //ordem por etiqueta
   Cabec1    := "COD PRODUTO    COD.CLIENTE   DESCRIวรO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
Endif   

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
	cQuery :="SELECT SZB.*,SB1.B1_CODAP5 "
   cQuery += " FROM " + RetSqlName( 'SZB' ) +" SZB, " + RetSqlName( 'SB1' ) +" SB1"        
   cQuery += " WHERE SZB.ZB_FILIAL = '" + xFilial("SZB")+ "'"
   cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
   cQuery += " AND SZB.ZB_ETIQ BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
   cQuery += " AND SZB.ZB_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
   cQuery += " AND SZB.ZB_LOCAL BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"   
   cQuery += " AND SZB.ZB_DOC BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"   
   cQuery += " AND SZB.ZB_DATA BETWEEN '" + Dtos(mv_par11) + "' AND '" + Dtos(mv_par12) + "'"      
   cQuery += " AND SZB.ZB_COD = SB1.B1_COD"
   //para imprimir somente a primeira contagem
   If UPPER(mv_par04) == "S"
      cQuery += " AND SZB.ZB_QTDE2 = 0 AND SZB.ZB_QTDE1 = SZB.ZB_QTDE3"      
   Endif
   // para imprimir somente a diverg๊ncia 
   If UPPER(mv_par03) == "S"
      cQuery += " AND SZB.ZB_QTDE1 <> SZB.ZB_QTDE2 AND SZB.ZB_QTDE3 = 0"           
   Endif
   
   cQuery += " AND SZB.D_E_L_E_T_ = ' ' "  
   cQuery += " AND SB1.D_E_L_E_T_ = ' ' "  
   If aReturn[8] == 2 //ordem por etiqueta
      cQuery += " ORDER BY SZB.ZB_ETIQ ASC" 
   Else //ordem por Produto
      cQuery += " ORDER BY SZB.ZB_COD ASC" 
   Endif      
   
	TCQUERY cQuery NEW ALIAS "TMP"  
  
Return                                   


Static Function RptDetail()

NQTDE1 := 0
NQTDE2 := 0
NQTDE3 := 0 
nEtq   := 0
       

DBSELECTAREA("TMP")

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())

  
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif
   @ Prow() + 1, 000 Psay Subs(TMP->ZB_COD,1,15)
   @ Prow()    , 017 Psay Alltrim(TMP->B1_CODAP5)
   @ ProW()    , 030 Psay subs(TMP->ZB_DESC,1,23)
   @ Prow()    , 054 Psay TMP->ZB_ETIQ 
   @ Prow()    , 060 Psay TMP->ZB_DOC 	
   @ Prow()    , 067 Psay TMP->ZB_LOCAL
   @ Prow()    , 070 Psay Subs(TMP->ZB_LOCALIZ,1,8) 
   @ Prow()    , 079 Psay Subs(TMP->ZB_LOTE,1,6)     
   @ Prow()    , 086 Psay Subs(TMP->ZB_OPERACA,1,3)        
   If aReturn[8] == 2 //ordem por etiqueta
      @ Prow()    , 090 Psay "______________"
   Else
      @ Prow()    , 090 Psay TMP->ZB_QTDE1    Picture "@E 999,999,999.99"
      @ Prow()    , 104 Psay TMP->ZB_QTDE2    Picture "@E 999,999,999.99"
      @ Prow()    , 118 Psay TMP->ZB_QTDE3    Picture "@E 999,999,999.99"

    	// ACUMULA
	  NQTDE1 := NQTDE1+TMP->ZB_QTDE1
   	  NQTDE2 := NQTDE2+TMP->ZB_QTDE2
	  NQTDE3 := NQTDE3+TMP->ZB_QTDE3	
   Endif
   	  
	nEtq += 1  // Guarda o totais de etiquetas
	
	TMP->(DbSkip())  
 
Enddo

// IMPRIME

@ Prow() +2 , 058 Psay nEtq      Picture "@E 999,999"
If aReturn[8] == 1 //ordem por Produto
   @ Prow()    , 090 Psay NQTDE1    Picture "@E 999,999,999.99"
   @ Prow()    , 104 Psay NQTDE2    Picture "@E 999,999,999.99"
   @ Prow()    , 118 Psay NQTDE3    Picture "@E 999,999,999.99"
Endif   
     
Return(nil) 


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "EST048"+Space(04)
aRegs   := {}

aadd(aRegs,{cPerg,"01","Da Etiqueta      ?","da Etiqueta      ?","da Etiqueta      ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","At้ Etiqueta     ?","at้ Etiqueta     ?","at้ Etiqueta     ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Diverg๊ncia      ?","Diverg๊ncia      ?","Diverg๊ncia      ?","mv_ch3","C",01,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","1ช Contagem      ?","1ช Contagem      ?","1ช Contagem      ?","mv_ch4","C",01,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Do Produto       ?","do Produto       ?","do Produto       ?","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","At้ Produto      ?","at้ Produto      ?","at้ Produto      ?","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Do Local         ?","do Local         ?","do Local         ?","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","At้ Local        ?","at้ Local        ?","at้ Local        ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"09","Do Documento     ?","da Documento     ?","da Documento     ?","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"10","At้ Documento    ?","at้ Documento    ?","at้ Documento    ?","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"11","Da Data          ?","da Data          ?","da Data          ?","mv_chb","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"12","At้ Data         ?","at้ Data         ?","at้ Data         ?","mv_chc","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
                           

