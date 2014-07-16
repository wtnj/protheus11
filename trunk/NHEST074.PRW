/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST074  ºAutor  ³                     º Data ³  17/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este relatorio tem como objetivo Imprimir a                º±±
±±º          ³ Requisição de Material                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±     Alteracao: Adicionado o campo "Ponto de pedido" no relatório        ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhest074()

SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq,_qtde")
SetPrvt("_cCC,_nTotal")

cString   := "SB1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Requisição de Material")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST074"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE MATERIAL POR LOCALIZACAO")
cabec1    := "Codigo              Descricao                             Almox       Saldo    Localizacao     Ult.Preco.Compra     Ponto de Pedido"
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST074"
_cPerg    := "EST074" 
aOrd      := {OemToAnsi("Localizacao Fisica"),OemToAnsi("Codigo do Produto")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '
_nTotal   := 0
_qtde     := 0
mv_par07 := '='

Pergunte(_cPerg,.T.)
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
                                                     
    _qtde := ALLTRIM(mv_par08)


    cQuery :="SELECT B2.B2_COD, B2.B2_LOCAL, B2.B2_QATU, SB1.B1_DESC, SB1.B1_LOCAFIS , SB1.B1_UPRC,B2.B2_CM1 , SB1.B1_EMIN "
    cQuery += " FROM " + RetSqlName( 'SB2' ) +" B2, " + RetSqlName( 'SB1' ) +" SB1 "                
    cQuery += " WHERE B2.B2_COD = SB1.B1_COD "
//  cQuery += " AND B2.B2_FILIAL  	= SB1.B1_FILIAL"
    cQuery += " AND B2.B2_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    cQuery += " AND B2.B2_LOCAL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "  
    cQuery += " AND SB1.B1_LOCAFIS BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
    If	mv_par07 == 1      
    	cQuery += " AND B2.B2_QATU 	>= '" + _qtde +  "' "
	ElseIf 	mv_par07 == 2
		cQuery += " AND B2.B2_QATU 	<= '" + _qtde +  "' "
	ElseIf 	mv_par07 == 3
		cQuery += " AND B2.B2_QATU 	=  '" + _qtde +  "' " 
	ElseIf 	mv_par07 == 4
		cQuery += " AND B2.B2_QATU 	<  '" + _qtde +  "' "
	Else
		cQuery += " AND B2.B2_QATU 	>  '" + _qtde +  "' "
	EndIf
	cQuery += " AND B2.D_E_L_E_T_ 	= ' ' "  
	cQuery += " AND B2.B2_FILIAL = '"+xFilial("SB2")+"' "
	cQuery += " AND SB1.D_E_L_E_T_ 	= ' ' "  
	cQuery += " ORDER BY SB1.B1_LOCAFIS " 
  
   
	MemoWrit('C:\TEMP\EST074.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"     
  
Return                                   


Static Function RptDetail()
      
DBSELECTAREA("TMP")
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
Cabec2 := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())
   If Prow() > 65
      _nPag  := _nPag + 1   
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif
   
   	@ Prow()+1  , 001 Psay TMP->B2_COD
   	@ Prow()    , 020 Psay TMP->B1_DESC
   	@ Prow()    , 060 Psay TMP->B2_LOCAL
   	@ Prow()    , 063 Psay TMP->B2_QATU   picture "@E 9,999,999.99"         
   	@ Prow()    , 080 Psay TMP->B1_LOCAFIS
   	@ Prow()    , 099 Psay TMP->B2_CM1    picture "@E 9,999,999.99" 
	@ Prow()    , 119 Psay TMP->B1_EMIN   picture "@E 9,999,999.99"
		
   TMP->(DbSkip())  
 
Enddo
     
Return(nil) 
