/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST032  ºAutor  ³Fabio Nico          º Data ³  12/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relacao de passagem de produtos pelas pistolas             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"


User Function NhTER005()        
cString   := ""
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Rastreabilidade de Peças")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHTER005"
nLastKey  := 0
titulo    := "RELATÓRIO TOTALIZADOR POR OPERACAO / PRODUTO"
Cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHTER005"
_cPerg    := "TER005" 
_codproduto := space(15)
//aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '

//AjustaSx1() 
DbSelectArea("SX1")
DbSetOrder(1)
If !Dbseek("TER005")          
   fCriaSX1()
Endif

Pergunte(_cPerg,.F.)

If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

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

//if aReturn[8] == 2 //ordem por etiqueta
//   Cabec1    := "COD PRODUTO    COD.CLIENTE    DESCRIÇÃO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
//Endif   

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

//Close TMP

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return


Static Function Gerando()  
    Mv_Par06 := Mv_Par06 +':99'
	cQuery := "SELECT SZE.ZE_PRODUTO,SB1.B1_DESC,SB1.B1_CODAP5,SZF.ZF_OPERACA, SZF.ZF_DESC, COUNT(*) AS 'QTDE' "
	cQuery += "FROM " +  RetSqlName( 'SZE' ) + " SZE, " +  RetSqlName( 'SZF' ) + " SZF, " +  RetSqlName( 'SB1' ) + " SB1 " 
	cQuery += "WHERE SZE.ZE_FILIAL = '" + xFilial("SZE")+ "' "
	cQuery += "AND SZF.ZF_FILIAL = '" + xFilial("SZF")+ "' "
	cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "' "
	cQuery += "AND SZE.ZE_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += "AND SZE.ZE_DATA+SZE.ZE_HORA BETWEEN '" + Dtos(Mv_par03) + Mv_par05 + "' AND '" + Dtos(Mv_par04) + Mv_par06 + "' "
	cQuery += "AND SZE.ZE_MAQUINA = SZF.ZF_COD "
	cQuery += "AND SZE.ZE_PRODUTO = SB1.B1_COD "
	cQuery += "AND SZE.D_E_L_E_T_ = ' ' "
	cQuery += "AND SZF.D_E_L_E_T_ = ' ' "
	cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY SZE.ZE_PRODUTO,SB1.B1_DESC,SB1.B1_CODAP5,SZF.ZF_OPERACA,SZF.ZF_DESC "
	cQuery += "ORDER BY 3 "

//    MemoWrit('C:\TEMP\NHEST032.SQL',cQuery)
//   TCQuery Abre uma workarea com o resultado da query


   TCQUERY cQuery NEW ALIAS "TMP"                      
 //  TcSetField("TMP","ZE_OPERACA","N")  // Muda a data de string para date    

Return


Static Function RptDetail()

TMP->(Dbgotop())

If Empty(TMP->ZE_PRODUTO)
   MsgBox("Nenhum Produto Encontrado","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea()
   Return(.F.)
Endif

Cabec1    := "Periodo de : " +Dtoc(Mv_par03) + " ate " + Dtoc(Mv_par04) + "        Horario : " + Mv_Par05 + " as " + Mv_Par06
Cabec2    := "OPERACAO       DESCRICAO                            QTDE LEITURA"
//Cabec2    := "Produto : " +Mv_Par01 + TMP->B1_DESC + " Codigo Cliente : " + TMP->B1_CODAP5 // +" - "+_cDesc+"      Cod.Cliente : "+_cCodCli+"         Serial : " +_cSerial
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
//@ Prow() +1, 000 Psay "OPERACAO       DESCRICAO                            QTDE LEITURA"

_codproduto = TMP->ZE_PRODUTO  
@ Prow() + 1, 000 Psay "Produto : " + TMP->ZE_PRODUTO + TMP->B1_DESC + " Codigo Cliente : " + TMP->B1_CODAP5
@ Prow() + 1, 000 Psay __PrtThinLine()

While !TMP->(eof())    
   If Prow() > 56
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
//      @ Prow() + 1, 000 Psay "OPERACAO       DESCRICAO                            QTDE LEITURA"
   Endif         

  if _codproduto = TMP->ZE_PRODUTO
      If TMP->QTDE <> 0 //mostra somente os seriais com problemas de leitura
         @ Prow() + 1, 000 Psay TMP->ZF_OPERACA
         @ Prow()    , 015 Psay TMP->ZF_DESC      
         @ Prow()    , 055 Psay TMP->QTDE   
      Endif   
      else
         @ Prow() + 2, 000 Psay "Produto : " + TMP->ZE_PRODUTO + TMP->B1_DESC  + " Codigo Cliente : " + TMP->B1_CODAP5
         @ Prow() + 1, 000 Psay __PrtThinLine()
         @ Prow() + 1, 000 Psay TMP->ZF_OPERACA
         @ Prow()    , 015 Psay TMP->ZF_DESC      
         @ Prow()    , 055 Psay TMP->QTDE   
         _codproduto = TMP->ZE_PRODUTO  
  endif
  
   TMP->(Dbskip())
Enddo
DbSelectArea("TMP")
DbCloseArea()


Return(nil) 
                                                    

Static FuncTion fCriaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Help a ser incluido no SX1 - Nao traduzir                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aHelp       := {}  


//SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

dbSelectArea("SX1")
dbSetOrder(1)

SX1->(DbSeek(_cPerg))

   While SX1->X1_Grupo == _cPerg
      RecLock('SX1')
      SX1->(DbDelete())
    	SX1->(DbSkip())
      MsUnLock('SX1')
   End

//Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui parametros de consulta                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd( aHelp, "Informe o Codigo do Produto " )
aAdd( aHelp, "Acabado para Pesquisa" )
PutSx1( "TER005","01", "Produto", "Produto", "Produto","mv_chl","C",15,0,0,"G","","",;
	"","","mv_par01","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,NIL,aHelp, aHelp,Nil)	
aHelp   := {}  

aAdd( aHelp, "Informe o Codigo do Produto " )
aAdd( aHelp, "Acabado para Pesquisa" )
PutSx1( "TER005","02", "Produto", "Produto", "Produto","mv_chl","C",15,0,0,"G","","",;
	"","","mv_par02","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,NIL,aHelp, aHelp,Nil)	
aHelp   := {}  



aAdd( aHelp, "Informe a Data de Inicio " )
aAdd( aHelp, "para Pesquisa" )
PutSx1( "TER005","03", "Data Inicial", "Data Inicial", "Data Inicial","mv_ch2","D",8,0,0,"G","","",;
	"","","mv_par03","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	

aHelp   := {}  
aAdd( aHelp, "Informe a Data Final " )
aAdd( aHelp, "para Pesquisa" )

PutSx1( "TER005","04", "Data Final", "Data Final", "Data Final","mv_ch3","D",8,0,0,"G","","",;
	"","","mv_par04","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	

aHelp   := {}  
aAdd( aHelp, "Informe a Hora Inicial " )
aAdd( aHelp, "para Pesquisa Ex: 99:99" )

PutSx1( "TER005","05", "Hora Inicial", "Hora Inicial", "Hora Inicial","mv_ch4","C",5,0,0,"G","","",;
	"","","mv_par05","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	

aHelp   := {}  
aAdd( aHelp, "Informe a Hora Final " )
aAdd( aHelp, "para Pesquisa Ex: 99:99" )
PutSx1( "TER005","06", "Hora Final", "Hora Final", "Hora Final","mv_ch5","C",5,0,0,"G","","",;
	"","","mv_par06","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	


//PutSx1( "TER004","03", "Embarque/Reposicao", "Embarque/Reposicao", "Embarque/Reposicao","mv_ch3","N",01,0,0,"C","","",;
//	"","","mv_par03","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil )	

ReTurn

               