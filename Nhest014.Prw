/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST014        ³ Alexandre R. Bento    ³ Data ³ 21.07.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao dos Defeitos de Refugo, Usinagem e Retrabalho   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Nova versao com totais

#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst014()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,nTotRef,nTotUsi,cErro,cQuery1")
SetPrvt("CCOMPAC,CNORMAL,cQuery,cLocal,nTotal,aTotal,nTotGer,aProduto,lCol,nUltDia,nParam")
SetPrvt("cCod,M_PAG,aRefugo,nI,cDescDef,cQtde,y,x,cDia,nDia,aLocal,cTotal,i,nQtdeZ9")




cString   :="SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Defeitos de Refugo e Usinagem ou Retrabalho")
cDesc3    := OemToAnsi(" ")
tamanho   :="G"
limite    := 260
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST014"
nLastKey  := 0
titulo    :="LISTA DE " 
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST014"          //Nome Default do relatorio em Disco
_cPerg    := "EST014"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
cDia      := " "
aRefugo   := {}           
aTotal    := {}               
aLocal    := {}                                                      
aProduto  := {}
cLocal    := " "                                            
nTotGer   := 0
lCol      := .F. 
//Matriz de totalização na horizontal                                     

For x:=1 to 2
	AaDD(aTotal,{" "," "," "," "," "," "," ",0," ",0," ",0," ",0," ",0," ",0,;
		           " ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
		           " ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
		           " ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
		           " ",0," ",0," ",0," ",0})
Next x		           

//codigo,descricao,defeito,descricao defeito,       
AaDD(aRefugo,{" "," "," "," "," "," "," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
	           " ",0," ",0," ",0," ",0,"999999"})
	           
                                                                  
AaDD(aLocal,{"01",0,"02",0,"03",0,"04",0,"05",0,"06",0,;
	           "07",0,"08",0,"09",0,"10",0,"11",0,"12",0,"13",0,;
	           "14",0,"15",0,"16",0,"17",0,"18",0,"19",0,"20",0,;
	           "21",0,"22",0,"23",0,"24",0,"25",0,"26",0,"27",0,;
	           "28",0,"29",0,"30",0,"31",0})

// Parametros Utilizados
// mv_par01 = Data de emisao inicial
// mv_par02 = Data de emisao final
// mv_par03 = codigo do produto inicial
// mv_par04 = codigo do produto final
// mv_par05 = codigo do defeito inicial
// mv_par06 = codigo do defeito final
// mv_par07 = codigo cacteristica defeito inicial
// mv_par08 = codigo cacteristica defeito final


// AjustaSX1() // Verifica os parametros

Pergunte('EST014',.T.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
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
   MsgBox(OemToAnsi("Atenção Relatório só pode sair dentro do mês","Refugo","STOP"))
   Return
Endif

nUltDia := Day(UltimoDia(mv_par02))                                                                   
If nUltdia == 31
   nParam := 68
Else 
   nParam := 67
Endif

For x:= 1 to len(Alltrim(mv_par09)) step 2
    If x == 1
       cLocal := "'" + Subs(Mv_par09,x,2) 
    Else 
	    cLocal := cLocal + "/" + Subs(Mv_par09,x,2) 
    Endif   
Next x                      

if !Empty(mv_par09)
	cLocal := cLocal + "'"
Endif	

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->D3_COD)
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   TMP->(DbCloseArea())

   Return
Endif     

Processa( {|| fGera() },"Slecionando Dados para a Impressao")
If Len(aRefugo) == 1
   MsgBox("Nenhum produto foi encontrado","Atencao","STOP")
   TMP->(DbCloseArea())
   Return
Endif     

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

   cQuery := "SELECT SD3.D3_COD,SD3.D3_TM,SD3.D3_EMISSAO,SD3.D3_DEFEITO,SD3.D3_LOCAL,SZ6.Z6_DESC,SD3.D3_CARDEF,SZ8.Z8_DESC,SB1.B1_DESC,SUM(SD3.D3_QUANT) AS 'QTDE'"
   cQuery += " FROM " + RetSqlName( 'SD3' ) +" SD3, " + RetSqlName( 'SZ6' ) +" SZ6, " + RetSqlName( 'SZ8' ) +" SZ8, " + RetSqlName( 'SB1' ) +" SB1 "     
   cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "'"
   cQuery += " AND SZ6.Z6_FILIAL = '" + xFilial("SZ6")+ "'"
   cQuery += " AND SZ8.Z8_FILIAL = '" + xFilial("SZ8")+ "'"
   cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"
   cQuery += " AND SD3.D3_FILIAL = SZ6.Z6_FILIAL"
   cQuery += " AND SD3.D3_DEFEITO = SZ6.Z6_COD"
   cQuery += " AND SD3.D3_FILIAL = SZ8.Z8_FILIAL"
   cQuery += " AND SD3.D3_CARDEF = SZ8.Z8_COD"
   cQuery += " AND SD3.D3_COD = SB1.B1_COD"   
   If SM0->M0_CODIGO=="NH"                            
      cQuery += " AND SD3.D3_TM IN ('499','002')"  
      If Mv_par09 == "97"
         cQuery += " AND SD3.D3_LOCAL IN ('99','00','97')" 
      Else   
         cQuery += " AND SD3.D3_LOCAL IN ('99','00')" 
      Endif   
   ElseIf SM0->M0_CODIGO=="FN"
      cQuery += " AND SD3.D3_TM IN ('499','002')"     
      If Mv_par09 == "36"
         cQuery += " AND SD3.D3_LOCAL IN ('30','39','36','40','49','50','59')" 
      Else   
         cQuery += " AND SD3.D3_LOCAL IN ('30','39','40','49','50','59')" 
      Endif         
   Endif   
   cQuery += " AND SD3.D3_EMISSAO >= '" + Dtos(mv_par01) + "' AND SD3.D3_EMISSAO <= '" + Dtos(mv_par02) +"'"
   cQuery += " AND SD3.D3_COD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
   cQuery += " AND SD3.D3_DEFEITO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
   cQuery += " AND SD3.D3_CARDEF BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'" 
   cQuery += " AND SD3.D3_OPERACA BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'" 
   cQuery += " AND SD3.D3_FORNECE BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'" 
   cQuery += " AND SD3.D3_LOJA BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "'" 
   cQuery += " AND SD3.D3_ESTORNO <> 'S' AND SD3.D3_LOCORIG NOT IN ('02','03')" 
   cQuery += " AND SD3.D_E_L_E_T_ = ' '"
   cQuery += " AND SZ6.D_E_L_E_T_ = ' '"
   cQuery += " AND SZ8.D_E_L_E_T_ = ' '"          
   cQuery += " AND SB1.D_E_L_E_T_ = ' '"             
   cQuery += " GROUP BY SD3.D3_COD,SD3.D3_TM,SD3.D3_EMISSAO,SD3.D3_DEFEITO,SD3.D3_LOCAL,SZ6.Z6_DESC,SD3.D3_CARDEF,SZ8.Z8_DESC,SB1.B1_DESC"     
   cQuery += " ORDER BY SD3.D3_COD,SD3.D3_EMISSAO,SD3.D3_CARDEF,SD3.D3_DEFEITO,SD3.D3_LOCAL ASC" 
//   cQuery += " AND CAST(SD3.D3_OPERACA AS NUMERIC(3)) BETWEEN " + Str(mv_par10,3) + " AND " + Str(mv_par11,3)+" " 


//  MemoWrit('C:\TEMP\EST014.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMP"     
//	TcSetField("TMP","D3_EMISSAO","D")  // Muda a data de string para date    


Return

Static Function fGera()
                                
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

While TMP->(!Eof())
   
   IncProc("Processando Produtos ... " + TMP->D3_COD)     
//   Alert (" D3_LOCAL "+ TMP->D3_LOCAL+"  cLocal : "+cLocal)
   If !TMP->D3_LOCAL$cLocal
      nDia := Val(Subs(TMP->D3_EMISSAO,7,2))*2
//      alert ("ndia "+ strzero(ndia,2))
      cQtde := StrZero(TMP->QTDE,4)
//      alert ("cqtde  "+ cqtde)
      aLocal [1][nDia] += Val(cQtde)
//      alert ("cqtde TOTAL  "+ aLocal [1][nDia])
      TMP->(DbSkip())
   	  DbSelectArea("TMP")
   	  Loop
   Endif
 
   nI := Ascan(aRefugo, {|x| x[1]+x[3]+x[6] == TMP->D3_COD+TMP->D3_CARDEF+TMP->D3_DEFEITO+TMP->D3_LOCAL})
   
	If nI <> 0
      nDia := 6 + Val(Subs(TMP->D3_EMISSAO,7,2))*2
      aRefugo [nI][nDia-1] := TMP->D3_EMISSAO
      cQtde := StrZero(TMP->QTDE,4)
      aRefugo [nI][nDia] += Val(cQtde)         
      cTotal := Val(aRefugo [nI][69]) + Val(cQtde)
      aRefugo [nI][69] := StrZero(cTotal,4) //Total do dia  
	Else
	   cDescDef := Alltrim(TMP->Z8_DESC) + " " + Alltrim(TMP->Z6_DESC)
	   Aadd(aRefugo,{TMP->D3_COD,TMP->B1_DESC,TMP->D3_CARDEF+TMP->D3_DEFEITO,cDescDef,TMP->D3_EMISSAO,TMP->D3_LOCAL,;
	                 " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
   	                 " ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0," ",0,;
   	                 " ",0," ",0," ",0," ",0," ",0," "})
      nI := Ascan(aRefugo, {|x| x[1]+x[3]+x[5]+x[6] == TMP->D3_COD+TMP->D3_CARDEF+TMP->D3_DEFEITO+TMP->D3_EMISSAO+TMP->D3_LOCAL})
    
      If nI <> 0      
         nDia := 6 + Val(Subs(TMP->D3_EMISSAO,7,2))*2
         aRefugo [nI][nDia-1] := TMP->D3_EMISSAO
         cQtde := StrZero(TMP->QTDE,4)
         aRefugo [nI][nDia]   := Val(cQtde)
         cTotal := Val(aRefugo [nI][69]) + Val(cQtde)
         aRefugo [nI][69] := StrZero(cTotal,4) //Total do dia  
      Else 
         Alert("Problema na gravacao da Data, Avise a informatica !!")
      Endif   
	   
   Endif
   TMP->(Dbskip())
Enddo

Return

Static Function RptDetail()       

For x:=1 to nUltDia //31
   cdia := cdia +Space(3)+StrZero(x,2)
next x

aRefugo := ASort(aRefugo,,, { |x, y| x[69] > y[69]})  //nico
aDel(aRefugo,1) // exclui o item do matriz       
TMP->(DbGoTop())
ProcRegua(Len(aRefugo))
Titulo := Titulo+IIF(Mv_par09=="97","RETRABALHO","REFUGO") + " DO MES DE " + UPPER(MesExtenso(Month(Mv_par01))) +" DE " + StrZero(Year(Mv_par01),4)+ " DO ALMOXARIFADO " + Subs(mv_par09,1,2)
Cabec1 := Cabec1 + " CARACTERISTICA DO DEFEITO "+Space(28) + cDia + "    Total"
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
If Mv_par12 == Mv_par13 .And. !Empty(mv_par12)
   SA2->(Dbseek(xFilial('SA2')+ Mv_par12))
   @ Prow() +1, 001 Psay Alltrim(aRefugo[1][1])+"  -  " + Alltrim(aRefugo[1][2])+ "  " +SA2->A2_NOME
Else
   @ Prow() + 1, 001 Psay Alltrim(aRefugo[1][1])+" - " + Alltrim(aRefugo[1][2])
Endif

Col    := 58               
nTotal := 0    
cCod   := aRefugo[1][1]
cDef   := aRefugo[1][3]
Aadd(aProduto,{aRefugo[1][1]})
For x:=1 to Len(arefugo)-1
   
   IncProc("Imprimindo Produtos .... " + TMP->D3_COD)
     
   If Prow() > 58
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
//      @ Prow() + 1, 001 Psay "CARACTERISTICA DO DEFEITO "+Space(24) + cDia                                                           
   Endif

   If aRefugo[x][1] == cCod // se o produto for igual 
		If aRefugo[x][3] == cDef   //Se defeito 
	   	   @ Prow() + 1, 001 Psay Alltrim(aRefugo[x][3])+ " - " + Subs(Alltrim(aRefugo[x][4]),1,49)
			For y:= 8 to nParam Step 2 //pega 31 dias somente a qtde
 			  //  @ Prow()  , Col Psay aRefugo[1][y] // Qtde na Data 
			 	 If aRefugo[x][y] > 0
			    	 @ Prow()  , Col Psay Transform(aRefugo[x][y],"@E 9999")//Qtde de refugo
			    	 nTotal+= aRefugo[x][y] //soma as qtde p/ fazer o total na vertical  
			    	 aTotal[1][y]+= aRefugo[x][y] //soma as qtde p/ fazer o total na horizontal
			    Else
					 @ Prow()  , Col Psay "  -"
			    Endif	 
			 	 Col +=5
			Next y     
//	@ Prow()  , Col+4 Psay Transform(nTotal,"@E 9,999") //Total por defeito aRefugo[x][7] // almoxarifado
		Elseif aRefugo[x][3] <> cDef   //Se defeito diferente
  		   cDef   := aRefugo[x][3]
	   	@ Prow() + 1, 001 Psay Alltrim(aRefugo[x][3])+ " - " + Subs(Alltrim(aRefugo[x][4]),1,49)
			For y:= 8 to nParam Step 2   //pega 31 dias somente a qtde
 			  //  @ Prow()  , Col Psay aRefugo[1][y] // Qtde na Data 
 			  	 If aRefugo[x][y] > 0
			 	    @ Prow()  , Col Psay Transform(aRefugo[x][y],"@E 9999")
			    	 nTotal+= aRefugo[x][y] //soma as qtde p/ fazer o total			 	         
			    	 aTotal[1][y]+= aRefugo[x][y] //soma as qtde p/ fazer o total na horizontal			    	 
			    Else
					 @ Prow()  , Col Psay "  -"
			    	 
			 	 Endif   
			 	 Col +=5
			Next y
//			@ Prow()  , Col Psay aRefugo[x][7] // almoxarifado			                                                  
//			@ Prow()  , Col+4 Psay Transform(nTotal,"@E 9,999") //Total por defeito 
		Endif                                                
		@ Prow()  , Col+2 Psay Transform(nTotal,"@E 9,999") //Imprime Total por defeito 		
//  	   @ Prow()  , Col+8 Psay aRefugo[x][6] //Imprime o almoxarifado
 
		Col    := 58
		nTotal := 0    
	ElseIf aRefugo[x][1] <> cCod // se o produto for igual 
          Aadd(aProduto,{aRefugo[x][1]})  // adiciona o produto para imprimir o total produzido SZ9
          @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina
          //Imprime o total na horizontal                                                        
          Col    := 58   //Inicializa a coluna p/impressao do total            
          @ Prow() + 1, 001 Psay "TOTAL GERAL DE "+IIF(Mv_par09=="97","RETRABALHO","REFUGO") +" REFUGO POR DIA "
          For y:= 8 to nParam Step 2 // pega 31 dias dos totais
			 	 If aTotal[1][y] > 0
			    	 @ Prow() , Col Psay Transform(aTotal[1][y],"@E 9999")//Qtde de refugo
			    	 nTotGer+= aTotal[1][y]
			    	 aTotal[1][y] := 0 //Zera p/ o proximo produto
			    Else
					 @ Prow()  , Col Psay "  -"
			    Endif	 
			 	 Col +=5
			Next y 
			@ Prow()  , Col+2 Psay Transform(nTotGer,"@E 9,999") //Imprime Total geral do mes    
			nTotRef := nTotGer //Guarda total de refugo do mes
			nTotGer := 0    // Limpa Total geral
          Col    := 58   //Inicializa a coluna p/impressao 
         _nPag := _nPag + 1                             
         Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
	      cCod   := aRefugo[x][1]  
  		   cDef   := aRefugo[x][3]	      
//	  		@ Prow() + 1, 001 Psay __PrtThinLine()
			@ Prow() + 1, 001 Psay Alltrim(aRefugo[x][1])+" - " + Alltrim(aRefugo[x][2])	 
			If aRefugo[x][3] == cDef   //Se defeito 
		   	@ Prow() + 1, 001 Psay Alltrim(aRefugo[x][3])+ " - " + Subs(Alltrim(aRefugo[x][4]),1,49)
				For y:= 8 to nParam Step 2  //pega 31 dias
	 			  //  @ Prow()  , Col Psay aRefugo[1][y] // Qtde na Data 
 			  	   If aRefugo[x][y] > 0	 			  
				 	   @ Prow()  , Col Psay Transform(aRefugo[x][y],"@E 9999")
   			    	nTotal+= aRefugo[x][y] //soma as qtde p/ fazer o total                  
  			    	   aTotal[1][y]+= aRefugo[x][y] //soma as qtde p/ fazer o total na horizontal   			    	
			      Else
					   @ Prow()  , Col Psay "  -"
				 	Endif   
				 	Col +=5
				Next y
			    @ Prow()  , Col+2 Psay Transform(nTotal,"@E 9,999") //Total por defeito 
			Elseif aRefugo[x][3] <> cDef   //Se defeito diferente
			  	cDef   := aRefugo[x][3]
		   	@ Prow() + 1, 001 Psay Alltrim(aRefugo[x][3])+ " - " + Subs(Alltrim(aRefugo[x][4]),1,49)
				For y:= 8 to nParam Step 2  //pega 31 dias
	 			  //  @ Prow()  , Col Psay aRefugo[1][y] // Qtde na Data 
 			   	If aRefugo[x][y] > 0	 			  
				 	   @ Prow()  , Col Psay Transform(aRefugo[x][y],"@E 9999")
   			    	nTotal+= aRefugo[x][y] //soma as qtde p/ fazer o total
			    	   aTotal[1][y]+= aRefugo[x][y] //soma as qtde p/ fazer o total na horizontal   			    	
			      Else
					   @ Prow()  , Col Psay "  -"
				 	Endif   
				 	Col +=5
				Next y
 		  		@ Prow()  , Col+2 Psay Transform(nTotal,"@E 9,999") //Imprime Total por defeito 		
			Endif
            Col := 58	
     		nTotal := 0    						
	Endif
next x   
//Para Imprimir o Ultimo da Matriz
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes do total do rodape da pagina
//Imprime o total na horizontal                                                        
Col    := 58   //Inicializa a coluna p/impressao do total            
@ Prow() + 1, 001 Psay "TOTAL GERAL DE "+ IIF(Mv_par09=="97","RETRABALHO","REFUGO")+" POR DIA "
For y:= 8 to nParam Step 2 // pega 31 dias dos totais
   If aTotal[1][y] > 0
		@ Prow() , Col Psay Transform(aTotal[1][y],"@E 9999")//Qtde de refugo
		nTotGer+= aTotal[1][y]
		//aTotal[1][y] := 0 //Zera p/ o proximo produto
	Else
	    @ Prow()  , Col+1 Psay " -"
	Endif	 
	Col +=5
Next y        
@ Prow()  , Col+2 Psay Transform(nTotGer,"@E 9,999") //Imprime Total geral do mes
nTotRef := nTotGer //Guarda total de refugo do mes
@ Prow()+1, Col Psay " "
//Imprime o total produzido usinado horizontal                                                        
Col    := 56   //Inicializa a coluna p/impressao do total            
SZ9->(DbSetOrder(1))
@ Prow() + 1, 001 Psay "TOTAL PRODUZIDO USINADO POR DIA "
   i:= 0     
   nTotGer := 0    
   For x:= 2 to 62 Step 2 // pega 31 dias totais  
      nQtdeZ9 := 0
      i+=1
      If i <= Day(Mv_par02)
	      IF x+6 <= nParam  //<
	         If SZ9->(DbSeek(xFilial("SZ9")+StrZero(Year(mv_par01),4)+StrZero(Month(mv_par01),2)+StrZero((i),2)+aProduto[1][1]))    
	         While SZ9->(!EOF()) .And.  (Dtos(SZ9->Z9_DATA) == StrZero(Year(mv_par01),4)+StrZero(Month(mv_par01),2)+StrZero((i),2) .And.;
	               SZ9->Z9_COD == aProduto[1][1]) 
               
               If SZ9->Z9_FORNECE >= Mv_par12 .And. SZ9->Z9_FORNECE <= Mv_par13 .And.;
                  SZ9->Z9_LOJA >= Mv_par14 .And. SZ9->Z9_LOJA <= Mv_par15 
             	               
	               nQtdeZ9 += SZ9->Z9_QUANT    // Soma mai de uma qtde de produção no mesmo dia
	            Endif   
	            
	            SZ9->(Dbskip())
	         Enddo
	            // Codição p/ atender qdo o valor for maior 9999
	            If (aTotal[1][x+6]+aLocal[1][x]+nQtdeZ9) > 9999
	               col += 1
	               lcol := .T.
	            Elseif lCol       
	                   Col -= 1
	                   lCol := .F.
	            Endif   
	            If (aTotal[1][x+6]+aLocal[1][x]+nQtdeZ9) > 0
	     		    @ Prow() , Col Psay Transform(aTotal[1][x+6]+aLocal[1][x]+nQtdeZ9,"@E 99999")//Qtde de refugo fundido + usinado + qtde produzido
//	     		    Alert("SZ9 QTDE z9 "+ Transform(nQtdeZ9,"@E 99999"))
//	     		    ALERT("Almox z9 "+clocal + "  " + Transform(aLocal[1][x],"@E 99999"))
//	     		    alert("total z9 " + Transform(aTotal[1][x+6],"@E 99999"))
	     		Else 
	     		    @ Prow() , Col Psay "   -"  //Qdo for valor igual a 0
	     		Endif    
	  		    nTotGer+= aTotal[1][x+6]+aLocal[1][x]+nQtdeZ9
			    aTotal[2][x+6] := (aTotal[1][x+6] / (aTotal[1][x+6]+aLocal[1][x]+nQtdeZ9))*100 //Guarda as Medias FU+FF/Total(FU+FF+TP)
			 Else 
			    If (aTotal[1][x+6]+aLocal[1][x]) > 0
	     		    @ Prow() , Col Psay Transform(aTotal[1][x+6]+aLocal[1][x],"@E 99999")//Qtde de refugo fundido + usinado 
//    		    ALERT("Almox >0 "+clocal + "  " + Transform(aLocal[1][x],"@E 99999"))
//	     		    alert("total >0 " + Transform(aTotal[1][x+6],"@E 99999"))
	     		Else 
	     		    @ Prow() , Col Psay "    -"  //Qdo for valor igual a 0
	     		Endif    
		        nTotGer+= aTotal[1][x+6]+aLocal[1][x]                                                             
			    aTotal[2][x+6] := (aTotal[1][x+6] / (aTotal[1][x+6]+aLocal[1][x]))*100 //Guarda as Medias FU+FF/Total(FU+FF+TP)	        
		     Endif
		     Col +=5        
		  Endif   
	  Else
	     If i < 31
	        @ Prow() , Col Psay "   -"  //Qdo for valor igual a 0	  	     
	        Col +=5
	     Endif           
	  Endif 	
   Next x	
                                         
@ Prow()  , Col+2 Psay Transform(nTotGer,"@E 999,999") //Imprime Total produzido e usinado geral do mes
nTotUsi := nTotGer //Guarda total Usinado do mes
@ Prow() + 1, 001 Psay " "

//Imprime as Medias 
nTotGer := i := 0
Col     := 56   //Inicializa a coluna p/impressao das medias
lCol    := .F. 
@ Prow() + 1, 001 Psay "MEDIAS GERAL DE "+IIF(Mv_par09=="97","RETRABALHO","REFUGO")+" POR DIA EM %"
For y:= 8 to nParam Step 2 // pega 31 dias das Medias
    
//   If y == 16
//      Col -= 1
//   Endif   

   If aTotal[2][y] > 0                        
      If aTotal[2][y] > 99                        
	     @ Prow() , Col Psay Transform(aTotal[2][y],"@E 99999")//Medias de refugo
	  Else 
	  	 @ Prow() , Col Psay Transform(aTotal[2][y],"@E 99.99")//Medias de refugo
	  Endif
	  // Verifica a qtde de media c/ valor p/ fazer a media geral 
	  If aTotal[2][y] > 0    
	     nTotGer+= aTotal[2][y]
//    i+=1
	  Endif   
   Else
	  @ Prow()  , Col Psay "    -"
   Endif	 
   Col +=5
Next y        

@ Prow()  , Col+2 Psay Transform((nTotRef/nTotUsi)*100,"@E 999.99") //Imprime Total geral das medias
@ Prow() + 1, 001 Psay " "
      
Return(nil)      
  