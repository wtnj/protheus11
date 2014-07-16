/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHPCP001        ³ Alexandre R. Bento    ³ Data ³ 30.01.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricão ³ Impressao da lista Critica de produtos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhpcp001()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,aMatriz,nPos,nSaldoB2,x,cForne,cForAux,nSalB2q,cTipo,cProd")

cString   :="SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Lista de faltas de produtos ")
cDesc3    := OemToAnsi("")
tamanho   :="G"
limite    := 250
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHPCP001"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    :="LISTA CRITICAS DE PRODUTOS"
Cabec1    :=" CODIGO CLI     CODIGO        FORNECEDOR          PRODUTO                      CONSUMO   ESTOQUE  DIAS/EST  EST.SEGUR  PROCESSO  RETRAB    1-DIA     2-DIA     3-DIA     4-DIA     5-DIA     6-DIA   OBSERVACAO"
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHPCP001"          //Nome Default do relatorio em Disco
_cPerg    := "PCP001"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aMatriz   := {}
AADD(aMatriz,{"","","","","",0,0,0,0,0})

//Mv_par01 :=	Ctod("01/02/03")
//Mv_par02 :=	Ctod("07/02/03")


Pergunte(_cPerg,.f.) //ativa os parƒmetros

// Parametros Utilizados
// mv_par01 = Produto Inicial da op
// mv_par02 = Produto final   da op
// mv_par03 = tipo  ( 1=todos,2=consignados,3=comprados )
// mv_par04 = produtos ( 1=todos, 2=componentes, 3=brutos, )
// mv_par05 = Ordena por ( 1=consumo, 2=produto )

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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->D4_OP)
   MsgBox("Nenhum Produto foi Encontrado","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()

   Return
Endif

Processa( {|| RptDetail() },"Imprimindo Lista Critica...")

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

	cQuery :="SELECT C2.C2_NUM,C2.C2_PRODUTO,C2.C2_DATPRI,C2.C2_DATPRF,B1.B1_LOCPAD,B1.B1_ESTSEG,"
	cQuery += "D4.D4_COD,D4.D4_LOCAL,D4.D4_OP,D4.D4_QUANT,D4.D4_QTDEORI,B1.B1_DESC,B1.B1_TIPO,B1.B1_CODAP5,"
	cQuery += "B2.B2_QATU,B2.B2_LOCAL,B2.B2_QEMP,B5.B5_QE1,B5.B5_QE2,B1.B1_PE," //A5.A5_NOMEFOR,"
//	cQuery := cQuery + "(D4.D4_QTDEORI /  (DATEDIFF ( DAY , C2.C2_DATPRI , C2.C2_DATPRF )+1) AS CONSU"   
//Query := cQuery + "(D4.D4_QTDEORI /((DATEDIFF ( DAY , C2.C2_DATPRI , C2.C2_DATPRF)+(1)) AS CONSU"   	
	cQuery += "(D4.D4_QTDEORI /((DATEDIFF ( DAY , C2.C2_DATPRI , C2.C2_DATPRF)+1))) AS CONSU "	
    cQuery +=  "FROM " + RetSqlName( 'SD4' ) +" D4, " + RetSqlName( 'SB1' ) +" B1, " // + RetSqlName( 'SC4' ) +" C4," 
    cQuery +=  RetSqlName( 'SC2' ) +" C2, " + RetSqlName( 'SB2' ) +" B2, "
    cQuery +=  RetSqlName( 'SB5' ) +" B5 " // + RetSqlName( 'SA5' ) +" A5 "
    cQuery +=  "WHERE B1.B1_FILIAL = '" + xFilial("SB1")+ "' "   
    cQuery += "AND D4.D4_FILIAL = '" + xFilial("SD4")+ "' "   
    cQuery += "AND C2.C2_FILIAL = '" + xFilial("SC2")+ "' "   
    cQuery += "AND B2.B2_FILIAL = '" + xFilial("SB2")+ "' "   
    cQuery += "AND B5.B5_FILIAL = '" + xFilial("SB5")+ "' "            
    cQuery += "AND D4.D4_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
    cQuery += "AND '" + DtoS(Ddatabase) + "' >= C2.C2_DATPRI AND '" + DtoS(Ddatabase) + "' <= C2.C2_DATPRF "
    If Mv_par03 == 1 //tipo dos produtos consignados e comprados
       cQuery += "AND B1.B1_TIPO IN ('CC','MC','CP','MP','EB','EC') "   
       cTipo = " Todos "
    Elseif Mv_par03 == 2 // consignados
       cQuery += "AND B1.B1_TIPO IN ('CC','MC','EC') "   
       cTipo = " Consiganados "       
    Elseif Mv_par03 == 3 // comprados
       cQuery += "AND B1.B1_TIPO IN ('CP','MP','EB') "   
       cTipo = " Comprados "
    Endif                            
    
    If Mv_par04 == 2 // componentes
       cQuery += "AND SUBSTRING(B1.B1_COD,6,1) <> '1' AND SUBSTRING(B1.B1_COD,6,1) <> '0'  "
       cProd := " Componentes "
    Elseif Mv_par04 == 3 // Brutos
       cQuery += "AND SUBSTRING(B1.B1_COD,6,1) = '1'  "
       cProd := " Brutos "           
    Elseif Mv_par04 == 1 // Todos
       cProd := " Todos "
    Endif                            
    
    cQuery += "AND D4.D4_COD = B1.B1_COD AND D4.D4_COD = B2.B2_COD " // AND A5.A5_PRODUTO = D4.D4_COD "
    cQuery += "AND D4.D4_COD = B5.B5_COD AND B5.D_E_L_E_T_ <> '*' " // AND C4.D_E_L_E_T_ <> '*'"
    cQuery += "AND D4.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' " //AND A5.D_E_L_E_T_ <> '*' "
    cQuery += "AND C2.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*' " // AND C4.C4_PRODUTO = C2.C2_PRODUTO"
    cQuery += "AND SUBSTRING(D4.D4_OP,1,6) = C2.C2_NUM "
    cQuery += "AND D4.D4_QUANT <> 0 AND D4.D4_LOCAL = B2.B2_LOCAL "    
//  cQuery += "AND B1.B1_TIPO IN ('CC','MC','CP','MP') "   
//  cQuery := cQuery + " AND (B2.B2_QATU - B2.B2_QEMP) < 0"
    cQuery += "ORDER BY CONSU ASC" 

//    MemoWrit('C:\TEMP\PCP001.SQL',cQuery)                                                 
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"
//	TcSetField("TMP","C2_DATPRI","D")  // Muda a data de string para date    

Return                                   


Static Function RptDetail()

TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))


titulo += cTipo + cProd

Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)


SB2->(DbSetOrder(1)) //filial + codigo + local
SA5->(DbSetOrder(2)) //filial + produto + fornecedor + loja
SA1->(DbSetOrder(1)) //filial + fornecedor + loja

While TMP->(!Eof())

   IncProc("Imprimindo Lista Critica... " + TMP->D4_OP)
      
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec1 := " "
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif                  
   
// nConsu := TMP->D4_QTDEORI /(TMP->C2_DATPRF - TMP->C2_DATPRI) +1  //If ATEDIFF ( DAY , C2.C2_DATPRI , C2.C2_DATPRF
   
   cForne := Space(10)
   If SA5->(DbSeek(xFilial("SA5")+TMP->D4_COD)) // Tabela de saldos em estoque por Local 
   	While SA5->(!Eof()) .And. SA5->A5_PRODUTO == TMP->D4_COD
      	cForAux:= Space(04)
	   	If SA2->(DbSeek(xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA)) // Tabela de saldos em estoque por Local 
	   	   	If(Empty(cForne))
	   	   	   cForne := Subs(SA2->A2_NREDUZ,1,AT(" ", Subs(SA2->A2_NREDUZ,1,4))) //Acha o espaco na palvra
  	   	   	   If(Empty(cForne))
	   	   	      cForne:= Subs(SA2->A2_NREDUZ,1,4)
 	   	   	   Endif
 	   	   	Else 
 	   	   	   cForAux:= Subs(SA2->A2_NREDUZ,1,AT(" ", Subs(SA2->A2_NREDUZ,1,4)))
 	   	   	   If(Empty(cForAux))
 	   	   	      cForAux:= Subs(SA2->A2_NREDUZ,1,4)
 	   	   	   Endif
 	   	   	   cForne := Alltrim(cForne) + "/"+ cForAux
	   	   	Endif   
	   	Endif   	
	   	SA5->(Dbskip())
	   Enddo	
	Endif
  
   nSaldoB2 := 0
   nSalB2q  := 0   
   If SB2->(DbSeek(xFilial("SB2")+TMP->D4_COD+TMP->B1_LOCPAD)) // Tabela de saldos em estoque por Local 
      While SB2->(!EOF()) .And. TMP->D4_COD == SB2->B2_COD
   		 If SB2->B2_LOCAL == TMP->B1_LOCPAD                             
//   		    If TMP->D4_COD = 'VW01.1.182.00'
//   		       ALERT("LEITURA SB2 : " +SB2->B2_QATU
  // 		       ALERT("SB2 : " +TMP->B2_QATU
//     	       Endif
     	          nSaldoB2 :=  SB2->B2_QATU   // Saldo do almoxarifado padrao
     	          
         Endif   
   	     If SB2->B2_LOCAL$"96/97"
	       	nSalB2q := nSalB2q + SB2->B2_QATU   // saldo do 96 e 97
	     Endif 	
	     SB2->(Dbskip())
	  Enddo   
   Endif

   nPos:=Ascan(aMatriz,{|X|X[2] == TMP->D4_COD})  
	If nPos == 0
      AADD(aMatriz,{TMP->B1_CODAP5,TMP->D4_COD,TMP->B1_ESTSEG,SUBS(cForne,1,20),;
                    TMP->B1_DESC,TMP->CONSU,nSaldoB2,nSaldoB2/TMP->CONSU,TMP->B2_QATU,nSalB2q,TMP->B1_PE})
   Else
      aMatriz[nPos,6]:= Round(aMatriz[nPos,6] + TMP->CONSU,0)
      aMatriz[nPos,8]:= Round((nSaldoB2/aMatriz[nPos,6]),0)
   Endif                                          
		   
   TMP->(Dbskip())   
EndDo

If Mv_par05 = 1
   aMatriz := ASORT(aMatriz,,, { |x, y| x[8]< y[8]}) // ordena por consumo
Else   
   aMatriz := ASORT(aMatriz,,, { |x, y| x[2]< y[2]}) //ordena por produto
Endif
   
For x:= 1 to Len(aMatriz)
    
   If !Empty(aMatriz[x][1])
	   If Prow() > 60
	      _nPag := _nPag + 1
	      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
	   Endif   
	
	   @ Prow() + 1, 001 Psay Alltrim(aMatriz[x][1])    // codigo ap5
		@ Prow()    , 016 Psay Subs(aMatriz[x][2],1,13)  // codigo ap6
	//	@ Prow()    , 033 Psay aMatriz[x][3]             // codigo cliente
		@ Prow()    , 030 Psay Subs(aMatriz[x][4],1,19)  // nome do forncedor
		@ Prow()    , 050 Psay Subs(aMatriz[x][5],1,25)  // descrição do produto
		@ Prow()    , 076 Psay Transform(aMatriz[x][6],"@E 9,999,999") // dias de consumo  	
		@ Prow()    , 087 Psay Transform(aMatriz[x][7],"@E 9,999,999") // Saldo atual  		
		@ Prow()    , 096 Psay Transform(aMatriz[x][8],"@E 9,999,999") // nSaldoB2/TMP->CONSU  ->DIAS EST 			
        @ Prow()    , 106 Psay Transform(aMatriz[x][3],"@E 9,999,999") //Estoque seguraça 			
        @ Prow()    , 118 Psay Transform(aMatriz[x][9],"@E 9,999,999") //Processo 			
		@ Prow()    , 126 Psay Transform(aMatriz[x][10],"@E 999,999") //saldo retrabalho almx 96 e 97 					
//		@ Prow()    , 118 Psay "......"
//		@ Prow()    , 126 Psay "......"
//		@ Prow()    , 134 Psay "......"                                         
	   @ Prow()    , 134 Psay Transform(aMatriz[x][7]-aMatriz[x][6],"@E 9,999,999") // 1 DIA DE CONSUMO 			
	   @ Prow()    , 144 Psay Transform(aMatriz[x][7]-(aMatriz[x][6]*2),"@E 9,999,999") // 2 DIA DE CONSUMO 			
	   @ Prow()    , 154 Psay Transform(aMatriz[x][7]-(aMatriz[x][6]*3),"@E 9,999,999") // 3 DIA DE CONSUMO 			   
	   @ Prow()    , 164 Psay Transform(aMatriz[x][7]-(aMatriz[x][6]*4),"@E 9,999,999") // 4 DIA DE CONSUMO 			   
	   @ Prow()    , 174 Psay Transform(aMatriz[x][7]-(aMatriz[x][6]*5),"@E 9,999,999") // 5 DIA DE CONSUMO 			      	
	   @ Prow()    , 184 Psay Transform(aMatriz[x][7]-(aMatriz[x][6]*6),"@E 9,999,999") // 6 DIA DE CONSUMO 			      
		@ Prow()    ,195 Psay "........................."                               
	Endif
Next
      
Return(nil)      
  
