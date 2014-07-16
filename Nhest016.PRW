/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST016        ³ Alexandre R. Bento    ³ Data ³ 23.09.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do Cadastro de Peças                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst016()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,cQuery,nTotal,aTotal,nTotGer")
SetPrvt("cCod,M_PAG,aRefugo,nI,cQtde,y,x,cDia,nDia")

cString   :="SZ9"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Totais de Peças Cortatas por Dia")
cDesc3    := OemToAnsi(" ")
tamanho   :="G"
limite    := 260
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST016"
nLastKey  := 0
titulo    :="LISTA DE PEÇAS USINADAS" 
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST016"          //Nome Default do relatorio em Disco
_cPerg    := "EST016"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
cDia      := " "
aRefugo   := {}           
aTotal    := {}               
nTotGer   := 0
//Matriz de totalização na horizontal                                     

AaDD(aRefugo,{" "," "," "," "," ",;
               " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0})

AaDD(aTotal,{" "," "," "," "," ",;
               " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0})

// Parametros Utilizados
// mv_par01 = Data de emisao inicial
// mv_par02 = Data de emisao final
// mv_par03 = codigo do produto inicial
// mv_par04 = codigo do produto final
// mv_par05 = Forncedor inicial
// mv_par06 = Fornecedor final
// mv_par07 = Loja inicial
// mv_par08 = Loja Final


// AjustaSX1() // Verifica os parametros

Pergunte('EST016',.T.)

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

If Month(mv_par01) <> Month(mv_par02)
   MsgBox(OemToAnsi("Atenção Relatório só pode sair dentro do mês","Peças Produzidas","STOP"))
   Return
Endif

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->Z9_COD)
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif     

Processa( {|| fGera() },"Slecionando Dados para a Impressao")
If Len(aRefugo) == 1
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif     

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

   cQuery := "SELECT SZ9.Z9_DATA,SZ9.Z9_COD,SZ9.Z9_QUANT,SZ9.Z9_FORNECE,SZ9.Z9_LOJA,SB1.B1_DESC,SA2.A2_NOME"
   cQuery += " FROM " + RetSqlName( 'SZ9' ) +" SZ9 (NOLOCK) " 
   cQuery += " INNER JOIN " +RetSqlName('SB1') +" SB1 (NOLOCK) ON "          
   cQuery += "       SZ9.Z9_COD = SB1.B1_COD" 
   cQuery += " AND SB1.B1_FILIAL  = '" + xFilial("SB1")+ "'"
   cQuery += " AND SB1.D_E_L_E_T_ = ''"
   cQuery += " LEFT JOIN  " +RetSqlName('SA2') +" SA2 (NOLOCK) ON "          
   cQuery += "      SZ9.Z9_FORNECE = SA2.A2_COD" 
   cQuery += " AND SZ9.Z9_LOJA   = SA2.A2_LOJA"
   cQuery += " AND SA2.A2_FILIAL  = '" + xFilial("SA2")+ "'"
   cQuery += " AND SA2.D_E_L_E_T_ = ''"
   cQuery += " WHERE SZ9.Z9_DATA >= '" + Dtos(mv_par01) + "' AND SZ9.Z9_DATA <= '" + Dtos(mv_par02) +"'"
   cQuery += " AND SZ9.Z9_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
   cQuery += " AND SZ9.Z9_FORNECE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
   cQuery += " AND SZ9.Z9_LOJA BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"   
   cQuery += " AND SZ9.Z9_FILIAL = '" + xFilial("SZ9")+ "'"   
   cQuery += " AND SZ9.D_E_L_E_T_ = ' '"
   cQuery += " ORDER BY SZ9.Z9_DATA,SZ9.Z9_COD ASC" 

//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"     
//	TcSetField("TMP","D3_EMISSAO","D")  // Muda a data de string para date    


Return

Static Function fGera()
                                
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

While TMP->(!Eof())
   
   IncProc("Processando Produtos .. " + TMP->Z9_COD)     
   
   nI := Ascan(aRefugo, {|x| x[1]+x[2] == Subs(TMP->Z9_DATA,1,6)+TMP->Z9_COD})
	If nI <> 0
      nDia := 5 + Val(Subs(TMP->Z9_DATA,7,2))*2
      aRefugo [nI][nDia-1] := TMP->Z9_DATA   
      cQtde := StrZero(TMP->Z9_QUANT,6)
      aRefugo [nI][nDia]   += Val(cQtde)         
	Else
	   Aadd(aRefugo,{Subs(TMP->Z9_DATA,1,6),TMP->Z9_COD,TMP->B1_DESC,TMP->Z9_FORNECE,TMP->Z9_LOJA,;
	                 " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
   	                 " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
   	                 " ",0," ",0," ",0," ",0," ",0," "})
      nI := Ascan(aRefugo, {|x| x[1]+x[2] == Subs(TMP->Z9_DATA,1,6)+TMP->Z9_COD})
      If nI <> 0      
         nDia := 5 + Val(Subs(TMP->Z9_DATA,7,2))*2
         aRefugo [nI][nDia-1] := TMP->Z9_DATA
         cQtde := StrZero(TMP->Z9_QUANT,6)
         aRefugo [nI][nDia]   := Val(cQtde)
      Else 
         Alert("Problema na gravacao da Data, Avise a informatica !!")
      Endif   
	   
   Endif
   TMP->(Dbskip())
Enddo

Return

Static Function RptDetail()       

For x:=1 to 31
   cdia := cdia +Space(3)+StrZero(x,2)
next x

//aRefugo := ASort(aRefugo,,, { |x, y| x[69] > y[69]})
aDel(aRefugo,1) // exclui o item do matriz       
TMP->(DbGoTop())
ProcRegua(Len(aRefugo))
Titulo := Titulo + " DO MES DE " + UPPER(MesExtenso(Month(Mv_par01))) +" DE " + StrZero(Year(Mv_par01),4) // + " DO ALMOXARIFADO " + Subs(mv_par09,1,2)
Cabec1 := Cabec1 + Iif(mv_par05 == mv_par06 .And. !Empty(mv_par05),Subs(TMP->Z9_FORNECE+" - "+TMP->A2_NOME,1,46), Space(46)) + cDia + "      Total"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
//@ Prow() + 1, 001 Psay Alltrim(aRefugo[1][1])+" - " + Alltrim(aRefugo[1][2])

Col    := 47               
nTotal := 0    
cCod   := aRefugo[1][2]
For x:=1 to Len(arefugo)-1
   
   IncProc("Imprimindo Produtos " + TMP->Z9_COD)
     
   If Prow() > 58
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
//      @ Prow() + 1, 001 Psay "CARACTERISTICA DO DEFEITO "+Space(24) + cDia                                                           
   Endif
   
   If aRefugo[x][2] == cCod // se o produto for igual 
      nTotal := 0                         
      @ Prow()+1  , 1 Psay Subs(aRefugo[x][2],1,13)+" - "+Subs(aRefugo[x][3],1,30)
  	  For y:= 7 to 67 Step 2 //pega 31 dias somente a qtde
 		 If aRefugo[x][y] > 0
		   	@ Prow()  , Col Psay Transform(aRefugo[x][y],"@E 99999")//Qtde de refugo
			nTotal+= aRefugo[x][y] //soma as qtde p/ fazer o total na vertical  
   			aTotal[1][y]+= aRefugo[x][y] //soma as qtde p/ fazer o total na horizontal
		 Else
			 @ Prow()  , Col Psay "    -"
	     Endif	 
	     Col +=5
	  Next y     
	  
   Elseif aRefugo[x][2] <> cCod   //Se produto diferente
  		  cCod := aRefugo[x][2]
          @ Prow()+1  , 1 Psay Subs(aRefugo[x][2],1,13)+" - "+Subs(aRefugo[x][3],1,30)
	   	  nTotal := 0    
		  For y:= 7 to 67 Step 2   //pega 31 dias somente a qtde
 			 If aRefugo[x][y] > 0
			 	@ Prow()  , Col Psay Transform(aRefugo[x][y],"@E 99999")
			    nTotal+= aRefugo[x][y] //soma as qtde p/ fazer o total			 	         
   			    aTotal[1][y]+= aRefugo[x][y] //soma as qtde p/ fazer o total na horizontal			    	 
			 Else
				@ Prow()  , Col Psay "    -"
			 Endif   
			 Col +=5
		  Next y
   Endif                                                
   @ Prow()  , Col+5 Psay Transform(nTotal,"@E 99,999") //Imprime Total produzido
   Col    := 47
   nTotal := 0    
   
next x   

//Para Imprimir o Ultimo da Matriz
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina
//Imprime o total na horizontal                                                        
Col    := 47   //Inicializa a coluna p/impressao do total            
@ Prow() + 1, 001 Psay "TOTAL GERAL DE USINAGEM POR DIA "
For y:= 7 to 67 Step 2 // pega 31 dias dos totais
   If aTotal[1][y] > 0
	  @ Prow() , Col Psay Transform(aTotal[1][y],"@E 99999")//Qtde de refugo
	  nTotGer+= aTotal[1][y]
		//aTotal[1][y] := 0 //Zera p/ o proximo produto
   Else
	  @ Prow()  , Col Psay "    -"
   Endif	 
	Col +=5
Next y        
@ Prow()  , Col+4 Psay Transform(nTotGer,"@E 999,999") //Imprime Total geral do mes
@ Prow()+1, Col Psay " "
     
Return(nil)      
  