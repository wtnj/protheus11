 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NHTER004 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 28/04/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de problemas encontrados na linha de produção     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ NHTER004                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MICRO-TERMINAL                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "Topconn.ch"

User Function NHTER004()

//SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")

cString   := "SZE"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Rastreabilidade de Peças")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHTER004"
nLastKey  := 0
titulo    := "RELATÓRIO DE PROBLEMAS NA RASTREABILIDADE"
Cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHTER004"
_cPerg    := "TER004" 
//aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '

//AjustaSx1()           
fCriaSX1()

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
   Mv_Par05 := Mv_Par05 +':99' //para pegar até os ultimos segundos de produção
   cQuery := "  SELECT ZE_SERIAL,ZE_PRODUTO,COUNT(*) AS 'LEITURA' "
   cQuery += " FROM " +  RetSqlName( 'SZE' ) +" SZE "   
   cQuery += " WHERE ZE_FILIAL = '" + xFilial("SZE")+ "'"   
   cQuery += " AND ZE_PRODUTO = '" + mv_par01 + "'"   
   cQuery += " AND ZE_DATA BETWEEN '" + Dtos(Mv_par02) + "' AND '" + Dtos(Mv_par03) + "' " 
   cQuery += " AND ZE_HORA BETWEEN '" + Mv_par04 + "' AND '" + Mv_par05+ "'" 
   cQuery += " AND D_E_L_E_T_ = ' '"                          
   cQuery += " GROUP BY ZE_SERIAL,ZE_PRODUTO"
   cQuery += " ORDER BY 1,2"  

//   MemoWrit('C:\TEMP\NHTER004.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"                      
   TcSetField("TMP","ZE_DATA","D")  // Muda a data de string para date    

Return


Static Function RptDetail()

TMP->(Dbgotop())

If Empty(TMP->ZE_SERIAL)
   MsgBox("Nenhum Produto Encontrado","Atençao","ALERT") 
   Return(.F.)
Endif

Cabec1    := "Produto : " +Mv_Par01  // +" - "+_cDesc+"      Cod.Cliente : "+_cCodCli+"         Serial : " +_cSerial
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
@ Prow() +1, 000 Psay "SERIAL        QTDE LEITURA"

While !TMP->(eof())    

   If Prow() > 56
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
      @ Prow() + 1, 000 Psay "SERIAL        QTDE LEITURA"
   Endif         
   
   If TMP->LEITURA <> 3 //mostra somente os seriais com problemas de leitura
      @ Prow() + 1, 000 Psay TMP->ZE_SERIAL
//      @ Prow()    , 015 Psay TMP->ZE_PRODUTO  
      @ Prow()    , 017 Psay Strzero(TMP->LEITURA,1)   
   Endif   
   
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


aAdd( aHelp, "Informe o Codigo do Produto " )
aAdd( aHelp, "Acabado para Pesquisa" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui parametros de consulta                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1( "TER004","01", "Produto", "Produto", "Produto","mv_chl","C",15,0,0,"G","","",;
	"","","mv_par01","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	
aHelp   := {}  
aAdd( aHelp, "Informe a Data de Inicio " )
aAdd( aHelp, "para Pesquisa" )

PutSx1( "TER004","02", "Data Inicial", "Data Inicial", "Data Inicial","mv_ch2","D",8,0,0,"G","","",;
	"","","mv_par02","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	

aHelp   := {}  
aAdd( aHelp, "Informe a Data Final " )
aAdd( aHelp, "para Pesquisa" )

PutSx1( "TER004","03", "Data Final", "Data Final", "Data Final","mv_ch3","D",8,0,0,"G","","",;
	"","","mv_par03","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	

aHelp   := {}  
aAdd( aHelp, "Informe a Hora Inicial " )
aAdd( aHelp, "para Pesquisa Ex: 99:99" )

PutSx1( "TER004","04", "Hora Inicial", "Hora Inicial", "Hora Inicial","mv_ch4","C",5,0,0,"G","","",;
	"","","mv_par04","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	

aHelp   := {}  
aAdd( aHelp, "Informe a Hora Final " )
aAdd( aHelp, "para Pesquisa Ex: 99:99" )
PutSx1( "TER004","05", "Hora Final", "Hora Final", "Hora Final","mv_ch5","C",5,0,0,"G","","",;
	"","","mv_par05","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,aHelp, aHelp, Nil )	


//PutSx1( "TER004","03", "Embarque/Reposicao", "Embarque/Reposicao", "Embarque/Reposicao","mv_ch3","N",01,0,0,"C","","",;
//	"","","mv_par03","","","","","","","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil )	

ReTurn