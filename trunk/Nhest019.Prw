/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST019        ³ Alexandre R. Bento    ³ Data ³ 02.11.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao Acompanhamento de refugo de usinagem            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Nova versao com totais

#include "Rwmake.ch"      
#include "Topconn.ch"

User Function NhEst019()  

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,cQuery,cQuery1,cMes,lCol,nUltDia,nParam")
SetPrvt("dDataIni,dDataFim,x,nI,M_PAG,nMes,cMes1,cMes2,cMes3,cMes4,cMes5")
SetPrvt("cAno1,cAno2,cAno3,cAno4,cAno5,aRef,_cAlmox")
cString   :="SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os ")
cDesc2    := OemToAnsi("Acompanhamento de Refugo de Usinagem")
cDesc3    := OemToAnsi(" ")
tamanho   :="G"
limite    := 260
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST019"
nLastKey  := 0
titulo    :="ACOMPANHAMENTO DE REFUGO DE USINAGEM" 
Cabec1    :=""
cabec2    :=""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST019"          //Nome Default do relatorio em Disco
_cPerg    := "EST019"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
cDia      := " "
aRef      := {}               
cLocal    := " "                                            
_cAlmox   := Space(02)

lCol      := .F. 
//Matriz de totalização na horizontal                                     

// Parametros Utilizados
// mv_par01 = codigo do produto inicial
// mv_par02 = codigo do produto final
// mv_par03 = Almoxarifado   usinagem ; fundido
// mv_par04 = Produto  Bruto  Todos
// mv_par05 = Data de geração do relatório

// AjustaSX1() // Verifica os parametros

Pergunte('EST019',.T.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]                   

if Empty(mv_par05)
	mv_par05 := dDataBase
EndIf

//Pega a data inicial e final para o filtro do relatorio de 5 meses
nMes := Month(mv_par05)
If (nMes - 4 ) == 0 
   dDataIni := StrZero(Year(mv_par05)-1,4)+"1201"
ElseIf (nMes - 4 ) == -1 
   dDataIni := StrZero(Year(mv_par05)-1,4)+"1101"
ElseIf (nMes - 4 ) == -2 
   dDataIni := StrZero(Year(mv_par05)-1,4)+"1001"
ElseIf (nMes - 4 ) == -3 
   dDataIni := StrZero(Year(mv_par05)-1,4)+"0901"
ElseIf (nMes - 4 ) == -4 
   dDataIni := StrZero(Year(mv_par05)-1,4)+"0801"
Else                                            
   dDataIni := StrZero(Year(mv_par05),4)+StrZero(nMes-4,2)+ "01"
Endif   
                                                          
dDataFim := StrZero(Year(mv_par05),4)+StrZero(nMes,2)+ "31"

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")

Processa( {|| fGera() },"Selecionando Dados para a Impressao")

Processa( {|| RptDetail() },"Imprimindo...")
DbSelectArea("TMP")
DbCloseArea()

DbSelectArea("TEMP")
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

   	cQuery := "SELECT SD3.D3_COD,SB1.B1_DESC,SD3.D3_LOCAL,MONTH(SD3.D3_EMISSAO) 'MES',YEAR(SD3.D3_EMISSAO) 'ANO', SUM(SD3.D3_QUANT ) 'REFUGO' "
   	cQuery += "FROM " + RetSqlName( 'SD3' ) +" SD3," + RetSqlName( 'SB1' ) +" SB1 " 
   	cQuery += "WHERE SD3.D3_FILIAL = '" + xFilial("SD3")+ "' " 
   	cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "' "
   	cQuery += "AND SD3.D3_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
   	cQuery += "AND SD3.D3_EMISSAO BETWEEN '" + dDataIni + "' AND '" + dDataFim + "' "   
   
   	If mv_par06==1 //Fundicao
	  	cLocal := "'30','39'"
   	ElseIf mv_par06==2 //Usinagem
   		If Mv_par03 == 3 //almoxarifado de Retrabalho
	   	  	cLocal := "'00','99','97'"		
	   	Else
	   	  	cLocal := "'00','99'"
	   	EndIf
   	ElseIf mv_par06==3 //Forjaria
	  	cLocal := "'40','49'"   
   	ElseIf mv_par06==4 //Virabrequim
   	  	cLocal := "'50','59'"
   	EndIf

	cQuery += "AND SD3.D3_LOCAL IN ("+cLocal+") "

/*
   If Mv_par03 == 3 //almoxarifado de Retrabalho
      cQuery += "AND SD3.D3_LOCAL IN ('00','99','97') " 
   Else // almoxarifado de usinagem e Fundido
      cQuery += "AND SD3.D3_LOCAL IN ('00','99') " 
   Endif         
*/
   cQuery += "AND SD3.D3_COD = SB1.B1_COD "
   cQuery += "AND SD3.D3_ESTORNO <> 'S' AND SD3.D3_LOCORIG NOT IN ('02','03') " 
   cQuery += "AND SD3.D3_TM IN ('499','002') AND SD3.D_E_L_E_T_  = ' ' "
   cQuery += "AND SB1.D_E_L_E_T_  = ' ' " 
   cQuery += "GROUP BY SD3.D3_COD,SB1.B1_DESC,SD3.D3_LOCAL,MONTH(SD3.D3_EMISSAO),YEAR(SD3.D3_EMISSAO) "
   cQuery += "ORDER BY SD3.D3_COD,MONTH(SD3.D3_EMISSAO),YEAR(SD3.D3_EMISSAO)"

   MemoWrit('C:\TEMP\EST019.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"     

// Query que traz as produções digitadas   
   cQuery1 := "SELECT SZ9.Z9_COD,SB1.B1_DESC,MONTH(SZ9.Z9_DATA) 'MES',YEAR(SZ9.Z9_DATA) 'ANO',SUM(SZ9.Z9_QUANT ) 'PRODUCAO' "
   cQuery1 += "FROM " + RetSqlName( 'SZ9' ) +" SZ9," + RetSqlName( 'SB1' ) +" SB1 " 
   cQuery1 += "WHERE SZ9.Z9_FILIAL = '" + xFilial("SZ9")+ "' " 
   cQuery1 += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "' "   
   cQuery1 += "AND SZ9.Z9_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
   cQuery1 += "AND SZ9.Z9_DATA BETWEEN '" + dDataIni + "' AND '" + dDataFim + "' "   
   cQuery1 += "AND SZ9.Z9_COD = SB1.B1_COD "
   cQuery1 += "AND SZ9.D_E_L_E_T_  = ' ' AND SB1.D_E_L_E_T_ = ' ' "  
   cQuery1 += "GROUP BY SZ9.Z9_COD,SB1.B1_DESC,MONTH(SZ9.Z9_DATA),YEAR(SZ9.Z9_DATA) "
   cQuery1 += "ORDER BY SZ9.Z9_COD,MONTH(SZ9.Z9_DATA),YEAR(SZ9.Z9_DATA)"

//   MemoWrit('C:\TEMP\EST019A.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery1 NEW ALIAS "TEMP"     

Return

Static Function fGera()
                                
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

cMes5   := Val(Subs(dDataFim,5,2))     
cAno5   := Subs(dDataFim,3,2)     

If Val(Subs(dDataFim,5,2))-1 < 1       
   cMes4 := 12                    
   cAno4 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
Else
   cMes4 := Val(Subs(dDataFim,5,2))-1       
   cAno4 := Subs(dDataFim,3,2)     
Endif

If Val(Subs(dDataFim,5,2))-2 < 1       
   If cMes4 == 12
      cMes3 := 11                                    
      cAno3 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Else
      cMes3 := 12
      cAno3 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Endif
Else
   cMes3 := Val(Subs(dDataFim,5,2))-2       
   cAno3   := Subs(dDataFim,3,2)     
Endif      

If Val(Subs(dDataFim,5,2))-3 < 1       
   If cMes3 == 12
      cMes2 := 11
      cAno2 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Elseif cMes3 == 11        
      cMes2 := 10   
      cAno2 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Else
      cMes2 := 12
      cAno2 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Endif
Else
   cMes2 := Val(Subs(dDataFim,5,2))-3       
   cAno2 := Subs(dDataFim,3,2)     
Endif      

If Val(Subs(dDataFim,5,2))-4 < 1       
   If cMes2 == 12
      cMes1 := 11
      cAno1 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Elseif cMes2 == 11              
      cMes1 := 10
      cAno1 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Elseif cMes2 == 10              
      cMes1 := 09
      cAno1 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Else
      cMes1 := 12
      cAno1 := StrZero(Val(Subs(dDataFim,3,2))-1,2)     
   Endif
Else
   cMes1 := Val(Subs(dDataFim,5,2))-4       
   cAno1   := Subs(dDataFim,3,2)     
Endif      

If mv_par03==2 //almox de usinado
	If mv_par06==1 //Fundicao
		_cAlmox := "39"
	ElseIf mv_par06==2 //Usinagem
		_cAlmox := "09"
	ElseIf mv_par06==3 //Forjaria
		_cAlmox := "49"
	ElseIf mv_par06==4 //Virabrequim
		_cAlmox := "59"
	EndIf
ElseIf mv_par03==1 //almox de fundido
	If mv_par06==1 //Fundicao
		_cAlmox := "30"
	ElseIf mv_par06==2 //Usinagem
		_cAlmox := "00"
	ElseIf mv_par06==3 //Forjaria
		_cAlmox := "40"
	ElseIf mv_par06==4 //Virabrequim
		_cAlmox := "50"
	EndIf
ElseIf mv_par03==3 // retrabalho
	If SM0->M0_CODIGO=="NH"
		_cAlmox := "97"
	Else
		Alert("Empresa inválida! Corrija os parâmetros.")
		Return
	EndIf
EndIf

While TMP->(!Eof())
   
   	IncProc("Processando Produtos com Refugo/Retrabalho... " + TMP->D3_COD)    

   	// Filtra os componentes menos o PG01.5
   	If Mv_par04 == 1
      	If Subs(TMP->D3_COD,1,6) <> "PG01.5"  .And. Subs(TMP->D3_COD,6,1) == "5" 
         	DbselectArea("TMP")
         	TMP->(Dbskip())
         	Loop
      	Endif
	Endif

/*
   If Mv_par03 == 1 //almoxarifado de fundido
     // filtra somente o almoxarifado 00
      _cAlmox := "00"
   ElseIf Mv_par03 == 2 //almoxarifado de fundido      
      _cAlmox := "99"
   ElseIf Mv_par03 == 3 //almoxarifado de retrabalho      
      _cAlmox := "97"   
   Endif   
*/     
     
      If TMP->D3_LOCAL == _cAlmox  
      
         nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})          
		 If nI == 0
  	        Aadd(aRef,{TMP->D3_COD,TMP->B1_DESC,0,0,0,0,0,0,0,0,0,0})   
  	        
            nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})    
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] := Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do primeiro mes para somar na produção depois Menos retrabalho  
               aRef [nI][4] := TMP->REFUGO //Total de Refugo do primeiro mes  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] := Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do Segundo mes para somar na produção depois Menos retrabalho  
               aRef [nI][6] := TMP->REFUGO //Total de Refugo do Segundo mes  
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] := Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do terceiro mes para somar na produção depois Menos retrabalho     
		       aRef [nI][8] := TMP->REFUGO //Total de Refugo do terceiro mes  
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] := Iif(_cAlmox =="97",0,TMP->REFUGO)  //Total de Refugo do quarto mes para somar na produção depois Menos retrabalho     
	           aRef [nI][10] := TMP->REFUGO //Total de Refugo do quarto mes  	           
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] := Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do quinto mes para somar na produção depois Menos retrabalho     
		       aRef [nI][12] := TMP->REFUGO //Total de Refugo do quinto mes  		       
	        Endif   
	     Else // Entra aqui quando ja existe o produto e atualiza outro mes de produção ou refugo
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] += Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do primeiro mes para somar na produção depois Menos retrabalho   
               aRef [nI][4] += TMP->REFUGO //Total de Refugo do primeiro mes  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] += Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do Segundo mes para somar na produção depois Menos retrabalho     
               aRef [nI][6] += TMP->REFUGO //Total de Refugo do Segundo mes  
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] += Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do terceiro mes para somar na produção depois Menos retrabalho     
		       aRef [nI][8] += TMP->REFUGO //Total de Refugo do terceiro mes  
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] += Iif(_cAlmox =="97",0,TMP->REFUGO)  //Total de Refugo do quarto mes para somar na produção depois Menos retrabalho     
	           aRef [nI][10] += TMP->REFUGO //Total de Refugo do quarto mes  	           
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] += Iif(_cAlmox =="97",0,TMP->REFUGO) //Total de Refugo do quinto mes para somar na produção depois Menos retrabalho     
		       aRef [nI][12] += TMP->REFUGO //Total de Refugo do quinto mes  		       
	        Endif   
	     Endif
      Else //Quando é o outro almoxarifado adiciona a qtde de refugo na produção
         nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})          
		 If nI == 0
  	        Aadd(aRef,{TMP->D3_COD,TMP->B1_DESC,0,0,0,0,0,0,0,0,0,0})   
            nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})    
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] := TMP->REFUGO //Total de Refugo do primeiro mes para somar na produção depois  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] := TMP->REFUGO //Total de Refugo do Segundo mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] := TMP->REFUGO //Total de Refugo do terceiro mes para somar na produção depois    
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] := TMP->REFUGO  //Total de Refugo do quarto mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] := TMP->REFUGO //Total de Refugo do quinto mes para somar na produção depois    
	        Endif   
	     Else // Entra aqui quando ja existe o produto e atualiza outro mes de produção ou refugo
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] += TMP->REFUGO //Total de Refugo do primeiro mes para somar na produção depois  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] += TMP->REFUGO //Total de Refugo do Segundo mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] += TMP->REFUGO //Total de Refugo do terceiro mes para somar na produção depois    
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] += TMP->REFUGO  //Total de Refugo do quarto mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] += TMP->REFUGO //Total de Refugo do quinto mes para somar na produção depois    
	        Endif   
	     Endif
      Endif
/*
   Elseif Mv_par03 == 2 // almoxarifado de usinagem
      // filtra somente o almoxarifado 99
      If TMP->D3_LOCAL == "99"  // D3_LOCAL = '99'  
         nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})          
		 If nI == 0
  	        Aadd(aRef,{TMP->D3_COD,TMP->B1_DESC,0,0,0,0,0,0,0,0,0,0})   
            nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})    
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] := TMP->REFUGO //Total de Refugo do primeiro mes para somar na produção depois  
               aRef [nI][4] := TMP->REFUGO //Total de Refugo do primeiro mes  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] := TMP->REFUGO //Total de Refugo do Segundo mes para somar na produção depois    
               aRef [nI][6] := TMP->REFUGO //Total de Refugo do Segundo mes  
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] := TMP->REFUGO //Total de Refugo do terceiro mes para somar na produção depois    
		       aRef [nI][8] := TMP->REFUGO //Total de Refugo do terceiro mes  
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] := TMP->REFUGO  //Total de Refugo do quarto mes para somar na produção depois    
	           aRef [nI][10] := TMP->REFUGO //Total de Refugo do quarto mes  	           
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] := TMP->REFUGO //Total de Refugo do quinto mes para somar na produção depois    
		       aRef [nI][12] := TMP->REFUGO //Total de Refugo do quinto mes  		       
	        Endif   
	     Else // Entra aqui quando ja existe o produto e atualiza outro mes de produção ou refugo
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] += TMP->REFUGO //Total de Refugo do primeiro mes para somar na produção depois  
               aRef [nI][4] += TMP->REFUGO //Total de Refugo do primeiro mes  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] += TMP->REFUGO //Total de Refugo do Segundo mes para somar na produção depois    
               aRef [nI][6] += TMP->REFUGO //Total de Refugo do Segundo mes  
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] += TMP->REFUGO //Total de Refugo do terceiro mes para somar na produção depois    
		       aRef [nI][8] += TMP->REFUGO //Total de Refugo do terceiro mes  
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] += TMP->REFUGO  //Total de Refugo do quarto mes para somar na produção depois    
	           aRef [nI][10] += TMP->REFUGO //Total de Refugo do quarto mes  	           
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] += TMP->REFUGO //Total de Refugo do quinto mes para somar na produção depois    
		       aRef [nI][12] += TMP->REFUGO //Total de Refugo do quinto mes  		       
	        Endif   
	     Endif   
      Else //Quando é o outro almoxarifado adiciona a qtde de refugo na produção
         nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})          
		 If nI == 0
  	        Aadd(aRef,{TMP->D3_COD,TMP->B1_DESC,0,0,0,0,0,0,0,0,0,0})   
            nI := Ascan(aRef, {|x| x[1] == TMP->D3_COD})    
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] := TMP->REFUGO //Total de Refugo do primeiro mes para somar na produção depois  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] := TMP->REFUGO //Total de Refugo do Segundo mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] := TMP->REFUGO //Total de Refugo do terceiro mes para somar na produção depois    
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] := TMP->REFUGO  //Total de Refugo do quarto mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] := TMP->REFUGO //Total de Refugo do quinto mes para somar na produção depois    
	        Endif   
	     Else // Entra aqui quando ja existe o produto e atualiza outro mes de produção ou refugo
            If TMP->MES == cMes1 //primeiro mes de refugo
               aRef [nI][3] += TMP->REFUGO //Total de Refugo do primeiro mes para somar na produção depois  
            ElseIf  TMP->MES == cMes2 //segundo mes de refugo                 
               aRef [nI][5] += TMP->REFUGO //Total de Refugo do Segundo mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes3 //segundo mes de refugo
		       aRef [nI][7] += TMP->REFUGO //Total de Refugo do terceiro mes para somar na produção depois    
			ElseIf  TMP->MES == cMes4 //segundo mes de refugo
	           aRef [nI][9] += TMP->REFUGO  //Total de Refugo do quarto mes para somar na produção depois    
		    ElseIf  TMP->MES == cMes5 //segundo mes de refugo
		       aRef [nI][11] += TMP->REFUGO //Total de Refugo do quinto mes para somar na produção depois    
	        Endif   
	     Endif
      Endif   
   Endif         
  */  
   TMP->(Dbskip())
Enddo

TEMP->(DbGoTop())
ProcRegua(TEMP->(RecCount()))

While TEMP->(!Eof())
   
   IncProc("Processando Produtos .. " + TEMP->Z9_COD)     
   // Filtra os componentes menos o PG01.5
   If Mv_par04 == 1
      If Subs(TEMP->Z9_COD,1,6) <> "PG01.5"  .And. Subs(TEMP->Z9_COD,6,1) == "5" 
         TEMP->(Dbskip())
         Loop
      Endif
   Endif
  
   nI := Ascan(aRef, {|x| x[1] == TEMP->Z9_COD})          

   If nI == 0
      Aadd(aRef,{TEMP->Z9_COD,TEMP->B1_DESC,0,0,0,0,0,0,0,0,0,0})   
      nI := Ascan(aRef, {|x| x[1] == TEMP->Z9_COD})    
      If TEMP->MES == cMes1 //primeiro mes de refugo
         aRef [nI][3] := TEMP->PRODUCAO //Total de Refugo do primeiro mes  
      ElseIf  TEMP->MES == cMes2 //segundo mes de refugo
         aRef [nI][5] := TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes3 //segundo mes de refugo
         aRef [nI][7] := TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes4 //segundo mes de refugo
         aRef [nI][9] := TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes5 //segundo mes de refugo
         aRef [nI][11] := TEMP->PRODUCAO //Total de Refugo do primeiro mes  
      Endif   
   Else
      If TEMP->MES == cMes1 //primeiro mes de refugo
         aRef [nI][3] += TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes2 //segundo mes de refugo
         aRef [nI][5] += TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes3 //segundo mes de refugo
         aRef [nI][7] += TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes4 //segundo mes de refugo
         aRef [nI][9] += TEMP->PRODUCAO //Total de Refugo do primeiro mes  
	  ElseIf  TEMP->MES == cMes5 //segundo mes de refugo
         aRef [nI][11] += TEMP->PRODUCAO //Total de Refugo do primeiro mes  
      Endif   
   Endif


   TEMP->(Dbskip())
Enddo

Return

Static Function RptDetail()       
                                    
//For x:=1 to nUltDia //31
//   cdia := cdia +Space(3)+StrZero(x,2)
//next x
ProcRegua(Len(aRef))                               
titulo    := Iif(mv_par03==3,"ACOMPANHAMENTO DE RETRABALHO DE USINAGEM","ACOMPANHAMENTO DE REFUGO DE USINAGEM" ) 

Titulo := Titulo + Iif(mv_par03==1," DO ALMOXARIFADO DE FUNDIDO",Iif(mv_par03==2," DO ALMOXARIFADO DE USINAGEM",Iif(mv_par03==3," DO ALMOXARIFADO DE RETRABALHO"," ")))
Cabec1 := Space(54) + Subs(MesExtenso(cMes1),1,3)+"-"+cAno1 + Space(20) + Subs(MesExtenso(cMes2),1,3)+"-"+cAno2
Cabec1 := "  MESES"+ Cabec1+ Space(20) + Subs(MesExtenso(cMes3),1,3)+"-"+cAno3 + Space(20) + Subs(MesExtenso(cMes4),1,3)+"-"+cAno4 + Space(20) + Subs(MesExtenso(cMes5),1,3)+"-"+cAno5
//If (mv_par03 == 3)
//    Cabec2 := Cabec2 + "  PRODUTO"+Space(44) +" Prod     Ret      %  |    Prod     Ret      %  |    Prod     Ret      %  |    Prod     Ret      %  |    Prod     Ret      %  |"
//Else 
    Cabec2 := Cabec2 + "  PRODUTO"+Space(44) +" Prod     Ref      %  |    Prod     Ref      %  |    Prod     Ref      %  |    Prod     Ref      %  |    Prod     Ref      %  |"
//Endif    
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

For x:= 1 to len(aRef)
   
   IncProc("Imprimindo Relatorio de Refugo/Retrabalho... " + aRef[x][1])     
     
   If Prow() > 58
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)        
   Endif

   @ Prow() + 1, 001 Psay Subs(Alltrim(aRef[x][1]),1,15)
   @ Prow()    , 017 Psay aRef[x][2]
   @ Prow()    , 051 Psay Transform(aRef[x][3],"@E 999,999") //produção
   @ Prow()    , 059 Psay Transform(aRef[x][4],"@E 999,999") // refugo
   
   If (aRef[x][4]/aRef[x][3]) == 0
      @ Prow()    , 067 Psay Transform(0,"@E 999999")+"%"    //percentual
   Else
      @ Prow()    , 067 Psay Transform((aRef[x][4]/aRef[x][3])*100,"@E 999.99")+"%"  //percentual         
   Endif                                                                            
   @ Prow()    , 075 Psay "|"
   @ Prow()    , 077 Psay Transform(aRef[x][5],"@E 999,999")//produção
   @ Prow()    , 085 Psay Transform(aRef[x][6],"@E 999,999")// refugo
   If (aRef[x][6]/aRef[x][5]) == 0
      @ Prow()    , 093 Psay Transform(0,"@E 999999")+"%" //percentual       
   Else
      @ Prow()    , 093 Psay Transform((aRef[x][6]/aRef[x][5])*100,"@E 999.99")+"%" //percentual            
   Endif
   @ Prow()    , 101 Psay "|"  
   @ Prow()    , 103 Psay Transform(aRef[x][7],"@E 999,999")//produção
   @ Prow()    , 111 Psay Transform(aRef[x][8],"@E 999,999")// refugo
                                                                 
   If (aRef[x][8]/aRef[x][7]) == 0
      @ Prow()    , 119 Psay Transform(0,"@E 999999")+"%" //percentual       
   Else
      @ Prow()    , 119 Psay Transform((aRef[x][8]/aRef[x][7])*100,"@E 999.99")+"%" //percentual           
   Endif   
   @ Prow()    , 127 Psay "|"  
   @ Prow()    , 129 Psay Transform(aRef[x][9],"@E 999,999")//produção
   @ Prow()    , 137 Psay Transform(aRef[x][10],"@E 999,999")// refugo
   If (aRef[x][10]/aRef[x][9]) == 0
      @ Prow()    , 145 Psay Transform(0,"@E 999999")+"%"  //percentual       
   Else
      @ Prow()    , 145 Psay Transform((aRef[x][10]/aRef[x][9])*100,"@E 999.99")+"%" //percentual          
   Endif                  
   @ Prow()    , 153 Psay "|"    
   @ Prow()    , 155 Psay Transform(aRef[x][11],"@E 999,999")//produção
   @ Prow()    , 163 Psay Transform(aRef[x][12],"@E 999,999")// refugo
   If (aRef[x][12]/aRef[x][11]) == 0
      @ Prow()    , 171 Psay Transform(0,"@E 999999")+"%" //percentual        
   Else 
      @ Prow()    , 171 Psay Transform((aRef[x][12]/aRef[x][11])*100,"@E 999.99")+"%" //percentual                   
   Endif                         
   @ Prow()    , 179 Psay "|"    
Next x
     
Return      
