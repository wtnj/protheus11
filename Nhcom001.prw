/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM001        ³ Alexandre R. Bento    ³ Data ³ 11.07.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do historico de alterações do pedidos de compra ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhcom001()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,lQtde,lPreco,lData,cTipo")

cString   :="SZ2"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o  ")
cDesc2    := OemToAnsi("Historico de Alterações de pedidos de compra ")
cDesc3    := OemToAnsi("")
tamanho   :="G"
limite    := 250
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHCOM001"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    :="HISTORICO DE ALTERAÇÕES DE PEDIDOS DE COMPRA"
Cabec1    :=" PEDIDO  FORNECEDOR                                PRODUTO         DESCRICAO                       DATA ALT.  TP        DE             PARA       JUSTIFICATIVA"
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHCOM001"          //Nome Default do relatorio em Disco
_cPerg    := "COM001"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
lQtde     := .F.
lPreco    := .F.
lData     := .F.   


//Mv_par01 :=	Ctod("01/02/03")
//Mv_par02 :=	Ctod("07/02/03")


Pergunte(_cPerg,.f.) //ativa os parƒmetros

// Parametros Utilizados
// mv_par01 = Produto Inicial da op
// mv_par02 = Produto final   da op


SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

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
                                            
cTipo := "('" + Subs(Mv_par04,1,2) + "','"+ Subs(Mv_par04,3,2) + "','" + Subs(Mv_par04,5,2) + "')"

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->Z2_PEDIDO)
   MsgBox("Historico de Pedido nao Encontrado","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| RptDetail() },"Imprimindo Historico Pedidos...")
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
                                                
	cQuery :="SELECT SZ2.Z2_PEDIDO,SZ2.Z2_DQUANT,SZ2.Z2_PQUANT,SZ2.Z2_DPRECO,SZ2.Z2_PPRECO, SZ2.Z2_DDATA,"
   cQuery := cQuery + "SZ2.Z2_PDATA,SZ2.Z2_EMISSAO,SA2.A2_COD,SA2.A2_NOME,SB1.B1_COD,SB1.B1_DESC,SZ2.Z2_STATUS,"	
   cQuery := cQuery + "SC7.C7_PRECO,SC7.C7_QUANT,SC7.C7_DATPRF,SC7.C7_JUSTIFI,SB1.B1_TIPO"	   
	cQuery := cQuery + " FROM " + RetSqlName( 'SC7' ) +" SC7, " + RetSqlName( 'SZ2' ) +" SZ2, " 
   cQuery := cQuery + RetSqlName( 'SB1' ) +" SB1, " + RetSqlName( 'SA2' ) +" SA2 "
	cQuery := cQuery + " WHERE SZ2.D_E_L_E_T_ <> '*'" 
	cQuery := cQuery + " AND SZ2.Z2_EMISSAO >= '" + Dtos(Mv_par01) + "' AND SZ2.Z2_EMISSAO  <= '"+ Dtos(Mv_par02) + "' "
   If Mv_par03 == 1
	   cQuery := cQuery + " AND SZ2.Z2_STATUS = 'ALTERADO'"
   Elseif Mv_par03 == 2
	   cQuery := cQuery + " AND SZ2.Z2_STATUS = 'EXCLUIDO'"   
	Endif
	
	If !Empty(cTipo)
		cQuery := cQuery + " AND SB1.B1_TIPO IN " + cTipo + " "
	Endif
		
	cQuery := cQuery + " AND SA2.A2_COD >= '" + Mv_par05 + "' AND SA2.A2_COD  <= '"+ Mv_par06 + "' "
	cQuery := cQuery + " AND SZ2.Z2_PRODUTO >= '" + Mv_par07 + "' AND SZ2.Z2_PRODUTO  <= '"+ Mv_par08 + "' "
	cQuery := cQuery + " AND SB1.B1_GRUPO >='" + Mv_par09 + "' AND SB1.B1_GRUPO <= '"+ Mv_par10 + "' "
	cQuery := cQuery + " AND SB1.D_E_L_E_T_ <> '*' AND  SA2.D_E_L_E_T_ <> '*'" 
	cQuery := cQuery + " AND SZ2.Z2_PEDIDO = SC7.C7_NUM AND SZ2.Z2_PRODUTO = SC7.C7_PRODUTO"
	cQuery := cQuery + " AND SZ2.Z2_ITEM = SC7.C7_ITEM AND SC7.C7_FORNECE = SA2.A2_COD"
	cQuery := cQuery + " AND SC7.C7_LOJA = SA2.A2_LOJA AND SB1.B1_COD = SZ2.Z2_PRODUTO"
	cQuery := cQuery + " ORDER BY SZ2.Z2_PEDIDO,SZ2.Z2_PRODUTO,SZ2.Z2_ITEM,SZ2.Z2_EMISSAO"
                                                 
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","Z2_DDATA","D")  // Muda a data de string para date de    
	TcSetField("TMP","Z2_PDATA","D")  // Muda a data de string para date para   	
	TcSetField("TMP","Z2_EMISSAO","D")  // Muda a data de string para date    	
	TcSetField("TMP","C7_DATPRF","D")  // Muda a data de string para date    
Return                                   


Static Function RptDetail()

TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)


//SB2->(DbSetOrder(1)) //filial + codigo + local
//SA5->(DbSetOrder(2)) //filial + produto + fornecedor + loja
//SA1->(DbSetOrder(1)) //filial + fornecedor + loja

While TMP->(!Eof())

   IncProc("Imprimindo Historicos de Pedidos Alterados... " + TMP->Z2_PEDIDO)
      
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif                  

	If TMP->Z2_STATUS = "ALTERADO"   	
		If TMP->Z2_DQUANT <> TMP->Z2_PQUANT
			@ Prow() + 1, 001 Psay TMP->Z2_PEDIDO
			@ Prow()    , 009 Psay TMP->A2_COD +  " - " + Subs(TMP->A2_NOME,1,30)
			@ Prow()    , 051 Psay Alltrim(TMP->B1_COD) + " - " + TMP->B1_DESC
			@ Prow()    , 099 Psay Dtoc(TMP->Z2_EMISSAO)  
			@ Prow()    , 110 Psay "Q"
			@ Prow()    , 111 Psay Transform(TMP->Z2_DQUANT,"@E 999,999,999.999") // Quantidade de
		   @ Prow()    , 125 Psay Transform(TMP->Z2_PQUANT,"@E 999,999,999.999") // Quantidade para		
	   	@ Prow()    , 143 Psay Subs(C7_JUSTIFI,1,50)
		Endif                            
		If TMP->Z2_DPRECO <> TMP->Z2_PPRECO
			@ Prow() + 1, 001 Psay TMP->Z2_PEDIDO
			@ Prow()    , 009 Psay TMP->A2_COD +  " - " + Subs(TMP->A2_NOME,1,30)
			@ Prow()    , 051 Psay Alltrim(TMP->B1_COD) + " - " + TMP->B1_DESC
			@ Prow()    , 099 Psay Dtoc(TMP->Z2_EMISSAO)  
			@ Prow()    , 110 Psay "P"			
			@ Prow()    , 111 Psay Transform(TMP->Z2_DPRECO,"@E 999,999,999.999") // preco de
	      @ Prow()    , 125 Psay Transform(TMP->Z2_PPRECO,"@E 999,999,999.999") // preco para
	   	@ Prow()    , 143 Psay Subs(C7_JUSTIFI,1,50)	      
		Endif
		   
		If TMP->Z2_DDATA <> TMP->Z2_PDATA
			@ Prow() + 1, 001 Psay TMP->Z2_PEDIDO
			@ Prow()    , 009 Psay TMP->A2_COD +  " - " + Subs(TMP->A2_NOME,1,30)
			@ Prow()    , 051 Psay Alltrim(TMP->B1_COD) + " - " + TMP->B1_DESC
			@ Prow()    , 099 Psay Dtoc(TMP->Z2_EMISSAO)  
			@ Prow()    , 110 Psay "D"			
			@ Prow()    , 119 Psay Dtoc(TMP->Z2_DDATA) // Data de 
	      @ Prow()    , 133 Psay Dtoc(TMP->Z2_PDATA) // Data para
	   	@ Prow()    , 144 Psay Subs(C7_JUSTIFI,1,50)	      
	   Endif                         
			   
	Else
		@ Prow() + 1, 001 Psay TMP->Z2_PEDIDO
		@ Prow()    , 009 Psay TMP->A2_COD +  " - " + Subs(TMP->A2_NOME,1,30)
		@ Prow()    , 051 Psay Alltrim(TMP->B1_COD) + " - " + TMP->B1_DESC
		@ Prow()    , 099 Psay Dtoc(TMP->Z2_EMISSAO)  
		@ Prow()    , 110 Psay "E"					
		@ Prow()    , 120 Psay "ATIVO        "+Subs(TMP->Z2_STATUS,1,8) // Alterado ou excluido
   	@ Prow()    , 144 Psay Subs(C7_JUSTIFI,1,50)   
   Endif

   TMP->(Dbskip())
   
Enddo   
@ Prow()+2    , 2 Psay OemToAnsi("D = Data      E = Excluído     P = Preço     Q = Quantidade")
Roda(0,0)
Return(nil)      
  
