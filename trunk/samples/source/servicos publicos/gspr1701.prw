#INCLUDE "Gspr1701.ch"
#Include "RwMake.ch"
/*
    GSPR150   -  Roberto
	Descricao - Impressao de Guia de Arrecadacao - Via Papel Timbrado
	*/
	
user Function GSPR170()

Titulo  := STR0001 //"GUIA DE ARRECADACAO"
Tamanho :="M"
CDESC1  :=OemToAnsi(STR0002) //"EMISSSAO DA GUIA DE ARRECADACAO"
Cdesc2  :=OemToAnsi("")
Cdesc3  :=OemToAnsi("") 
areturn :={STR0003,1,STR0004,2,2,1,"",1 } //"Zebrado"###"Administracao"
aLinha  :={ }
nomeprog:="GSPR170"
nLASTKEY:= 0
cstring :="N01"
wnrel   :="GSPR17"

aPerg :={}
cGrupo:= "GSPR17"
//..             Grupo    Ordem    Perguntas    Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { "01", "Do Código............?", "mv_ch1", "C", 12 , 0 ,"MV_PAR01","G" ,"N01", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_COD"      ,">=" }) 
aAdd( aPerg , { "02", "Ate o Código.........?", "mv_ch2", "C", 12 , 0 ,"MV_PAR02","G" ,"N01", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_COD"      ,"<=" })
aAdd( aPerg , { "03", "Do Logradouro........?", "mv_ch3", "C",  6 , 0 ,"MV_PAR03","G" ,"N02", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_LOGRAD"   ,">=" })
aAdd( aPerg , { "04", "Ate o Logradouro.....?", "mv_ch4", "C",  6 , 0 ,"MV_PAR04","G" ,"N02", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_LOGRAD"   ,"<=" })
aAdd( aPerg , { "05", "Do Distrito..........?", "mv_ch5", "C",  2 , 0 ,"MV_PAR05","G" ,"N1 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_DISTRI"   ,">=" })
aAdd( aPerg , { "06", "Ate o Distrito.......?", "mv_ch6", "C",  2 , 0 ,"MV_PAR06","G" ,"N1 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_DISTRI"   ,"<=" })
aAdd( aPerg , { "07", "Do Setor.............?", "mv_ch7", "C",  2 , 0 ,"MV_PAR07","G" ,"N2 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_SETOR"    ,">=" })
aAdd( aPerg , { "08", "Ate o Setor..........?", "mv_ch8", "C",  2 , 0 ,"MV_PAR08","G" ,"N2 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_SETOR"    ,"<=" })
aAdd( aPerg , { "09", "Da Quadra............?", "mv_ch9", "C",  2 , 0 ,"MV_PAR09","G" ,"N3 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_QUADRA"   ,">=" })
aAdd( aPerg , { "10", "Ate o Quadr..........?", "mv_chA", "C",  2 , 0 ,"MV_PAR10","G" ,"N3 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_QUADRA"   ,"<=" })
aAdd( aPerg , { "11", "Do Lote..............?", "mv_chB", "C",  2 , 0 ,"MV_PAR11","G" ,"N4 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_LOTE"     ,">=" })
aAdd( aPerg , { "12", "Ate o Lote...........?", "mv_chC", "C",  2 , 0 ,"MV_PAR12","G" ,"N4 ", "   "     ,"   "       ,"   ","   ","    "," "            ,"N01_LOTE"     ,"<=" })
aAdd( aPerg , { "13", "Imprimir.............?", "mv_chC", "N",  1 , 0 ,"MV_PAR13","C" ,"   ", "So Novos","Re-Impressao"," ","   ","    "," "            ,""     ,"" })
aAdd( aPerg , { "14", "% Acrescimo..........?", "mv_chd", "N",  5 , 2 ,"MV_PAR14","G" ,"   ", "   "     ,"   "       ,"   ","   ","    "," "            ,""     ,"" })
aAdd( aPerg , { "15", "Numero Dias Atraso...?", "mv_che", "N",  3 , 0 ,"MV_PAR15","G" ,"   ", "   "     ,"    "      ,"   ","   ","    "," "            ,""     ,"" })
aAdd( aPerg , { "16", "Mensagem 1...........?", "mv_chf", "C", 70 , 0 ,"MV_PAR16","G" ,"   ", "   "     ,"    "      ,"   ","   ","    "," "            ,""     ,"" })
aAdd( aPerg , { "17", "Mensagem 2...........?", "mv_chg", "C", 70 , 0 ,"MV_PAR17","G" ,"   ", "   "     ,"    "      ,"   ","   ","    "," "            ,""     ,"" })

DbSelectArea("SX1"); DbSetOrder(1)
For nn := 1 to Len( aPerg )
	If !DbSeek(cGrupo + aPerg[nn,1] )
		RecLock("SX1",.T.)
		Replace X1_GRUPO   With cGrupo      , X1_ORDEM   With aPerg[nn,01],;
		X1_PERGUNT With aPerg[nn,02], X1_VARIAVL With aPerg[nn,03],;
		X1_TIPO    With aPerg[nn,04], X1_TAMANHO With aPerg[nn,05],;
		X1_DECIMAL With aPerg[nn,06], X1_VAR01   With aPerg[nn,07],;
		X1_GSC     With aPerg[nn,08], X1_F3      With aPerg[nn,09],;
		X1_Def01   With aPerg[nn,10], X1_Def02   With aPerg[nn,11],;
		X1_Def03   With aPerg[nn,12], X1_Def04   With aPerg[nn,13],;
		X1_Def05   With aPerg[nn,14]
		MsUnlock()
	End
Next

Pergunte(cGrupo,.f.)

wnrel:=setprint(cstring,wnrel,cGrupo,titulo,cdesc1,cdesc2,cdesc3,.T.)
If nLastKey == 27
    Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
    Return
Endif

DbSelectArea("SD2") ;  DbSetOrder(3)
DbSelectArea("SB1") ;  DbSetOrder(1)
DbSelectArea("SF4") ;  DbSetOrder(1)
DbSelectArea("N01") ;  DbSetOrder(1)

RptStatus({|| FImpre() },STR0005,STR0006 ) //"Imprimindo.. "###"Aguarde.."

If aReturn[5] == 1
   Set Printer To
   dbCommit()
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return

Static Function FImpre()

SetRegua(RecCount()) //Ajusta numero de elementos da regua de relatorios
       
cCodFebra:= GetMv("MV_CFEBRAN")
                      
@ Prow(),0 PSay Chr(15)            
While .T.
     @ Prow() , 00 PSay "....." 
     If MsgBox(Trim( SubStr(cUsuario,7,13) ) + ", "+STR0007 ,STR0008,"YESNO")
        Exit
     End
EndDo        

cN01Filtro := GSPFMonFil(aPerg)       
If RDDName() <> "TOPCONN"
	cN01Filtro := cN01Filtro + If( Empty(cN01Filtro) ,"" , " .And. ") + If(Mv_par13==1, "N01_IMPRES == 0", "N01_IMPRES > 0" ) 
Else
	cN01Filtro := cN01Filtro + If( Empty(cN01Filtro) ,"" , " AND ") + If(Mv_par13==1, "N01_IMPRES == 0", "N01_IMPRES > 0" ) 
EndIf
Set Filter To &cN01Filtro
DbGotop()         
aCliente := {}
While !Eof() 
	  SA1->( DbSeek( xFilial("SA1") + N01->N01_PROPRI) )
	  aAdd( aCliente ,{ SA1->A1_NOME , Recno() } )
	  DbSkip()
EndDo
	   
aSort( aCliente )

For nAS := 1 to Len( aCliente )
    	DbSelectArea("N01")
    	DbGoto( aCliente[nAS,2] )
        SA1->( DbSeek( xFilial("SA1") + N01->N01_PROPRI) )
		
		DbSelectArea("SE1")                                          
		DbSetOrder(1)
	   	DbSeek( xFilial("SE1") + N01->N01_Prefix + N01->N01_Titulo)                      
		dEmissao := Se1->E1_Emissao
		nValDup := 0
		aCamCab := {}
		While !Eof() .And. E1_Prefixo == N01->N01_Prefix .And. E1_Num == N01->N01_Titulo 
	      	aAdd( aCamCab, {E1_parcela   ,SE1->E1_VENCREA  , SE1->E1_VALOR} ) 
			nValDup += SE1->E1_VALOR
			DbSkip()
		EndDo	
		
		DbSelectArea("SE1")                                          
		DbSetOrder(17)
	   	DbSeek( xFilial("SE1") + N01->N01_Cod)                      
		aPendentes := {}
		aValPen    := {}
		While !Eof() .And. E1_CodImov == N01->N01_Cod 
		    If (nAno := Year( E1_VencRea )) < Year( dEmissao )
		       IF ( nPAno := Ascan( aPendentes, Str( nAno ,4) )) == 0
		          aAdd( aPendentes , Str( nAno ,4) )
		          aAdd( aValPen    , Se1->E1_Saldo )
		       Else
		          aValPen[ nPAno] += Se1->E1_Saldo
		       EndIf
		    EndIf
		    DbSkip()
		EndDo          
		    
		aProdutos := {}
		DbSelectArea("SD2")                                          
	   	DbSeek( xFilial("SD2") + N01->N01_Titulo + N01->N01_Prefix)                      
	   	nBase := 0
		While !Eof() .And. D2_Serie == N01->N01_Prefix .And. D2_Doc == N01->N01_Titulo 
		     Sb1->( DbSeek( xFilial('SB1') + Sd2->D2_Cod ))
		     Sf4->( DbSeek( xFilial('SF4') + Sd2->D2_Tes ))
		     If Sf4->F4_Duplic == "S"
		    	aAdd( aProdutos , { Sb1->B1_Desc , D2_PrcVen , D2_BaseOri , D2_Peso } )
		    	nBase += D2_BaseOri
		     EndIf
		     DbSkip()
		EndDo     	
        
        nPer := Round( (nValDup / nBase) * 100  , 3)
		For nPar := 1 to Len( aCamCab )
		
			cValor := Strzero( Int(aCamCab[nPar,3]*100), 11 )
			
			cCodBar := cValor     //.. Valor 
			cCodBar += cCodFebra  //.. Codigo da Febrabam - Parametro

			cLetras := "ABCDEFGHIJKLMNOPQRSTUVXYWZ"
			//... 25 Posicoes livre para o Cliente
			cCodBar += If ( At(SubStr(N01->N01_Prefix,1,1) ,cLetras )<>0, StrZero( At(SubStr(N01->N01_Prefix,1,1) ,cLetras ) , 2 ) , "9" + SubStr(N01->N01_Prefix,1,1)  )  + ;
					   If ( At(SubStr(N01->N01_Prefix,2,1) ,cLetras )<>0, StrZero( At(SubStr(N01->N01_Prefix,2,1) ,cLetras ) , 2 ) , "9" + SubStr(N01->N01_Prefix,2,1)  )  + ;
					   If ( At(SubStr(N01->N01_Prefix,3,1) ,cLetras )<>0, StrZero( At(SubStr(N01->N01_Prefix,3,1) ,cLetras ) , 2 ) , "9" + SubStr(N01->N01_Prefix,3,1)  )  
			cCodBar += N01->N01_Titulo     //.. Numero do Titulo
			cCodBar += If ( At(aCamCab[nPar,1] ,cLetras )<>0, StrZero( At(aCamCab[nPar,1],cLetras ) , 2 ) , "9" + aCamCab[nPar,1]  )   //.. Parcela 
			cCodBar += Sa1->A1_Cod //.. Codigo do Cliente
			cCodBar += Sa1->A1_Loja    //.. Codigo da Loja
			cCodBar += "000"      //... Complemento com Zeros ate os 25 caracteres
			cDigBar := GSPCdBarBC(cCodBar) //.. Digito Verificado Geral 
 
			cCodBar1:= "8"  //...  Identificacao do Produto  - 8 Arrecadacao
			cCodBar1+= "1"  //...  Identificacao do segmento - 1 Prefeituras
			cCodBar1+= "7"  //...  Codigo do Valor 6 = Reais e 7=Qtde de Moeda
			
			cCodBar := cCodBar1 + cDigBar + cCodBar   
			  
			cDigBar1:= GSPCdBarBC( SubStr(cCodBar,1,11) )  //.. Digito Verificador da 11 Primeiras Posicoes
			cDigBar2:= GSPCdBarBC( SubStr(cCodBar,12,11) ) //.. Digito Verificador da 11 Segundas Posicoes
			cDigBar3:= GSPCdBarBC( SubStr(cCodBar,23,11) ) //.. Digito Verificador da 11 Terceiras Posicoes
			cDigBar4:= GSPCdBarBC( SubStr(cCodBar,34,11) ) //.. Digito Verificador da 11 Quartas Posicoes
			
			cCBarDg := SubStr(cCodBar, 1,11) + "-" + cDigBar1 + "  " + ;
					   SubStr(cCodBar,12,11) + "-" + cDigBar2 + "  " + ;
					   SubStr(cCodBar,23,11) + "-" + cDigBar3 + "  " + ;
					   SubStr(cCodBar,34,11) + "-" + cDigBar4 					   
			//... Impressao do cabecalho
		    
		    @ Prow()   , 000 PSay Sm0->M0_NomeCom        //..Favorecido
		    @ Prow()   , 050 PSay Se1->E1_Num            //..Numero do Titulo
		    @ Prow()   , 081 PSay Sm0->M0_NomeCom        //..Favorecido
		    @ Prow()   , 130 PSay Se1->E1_Num            //..Numero do Titulo
		    @ Prow()   , 173 PSay Se1->E1_Num            //..Numero do Titulo
		    
		    @ Prow()+1 , 000 PSay N01->N01_Cod           //..Numero da Inscrecao do Imovel
		    @ Prow()   , 040 PSay "IPTU"                 //..Tipo de Divida
		    @ Prow()   , 046 PSay Year(dEmissao)         //..Ano da Divida
		    @ Prow()   , 056 PSay aCamCab[nPar,1]        //..Parcela
		    @ Prow()   , 080 PSay N01->N01_Cod           //..Numero da Inscrecao do Imovel
		    @ Prow()   , 120 PSay "IPTU"                 //..Tipo de Divida
		    @ Prow()   , 126 PSay Year(dEmissao)         //..Ano da Divida
		    @ Prow()   , 136 PSay aCamCab[nPar,1]        //..Parcela
		    
		    If Len( aProdutos ) > 0
		       @ Prow()+1 , 000 PSay Left( aProdutos[1,1],20)  //..Descricao do produto Faturados
		       @ Prow()   , 056 PSay aCamCab[nPar,2]         //..Vencimento da parcela
		       @ Prow()   , 068 PSay aCamCab[nPar,3] Picture "@e 999,999.99"  //..Valor da parcela
		       @ Prow()   , 080 PSay Left( aProdutos[1,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1 , 056 PSay aCamCab[nPar,2]         //..Vencimento da parcela
		       @ Prow()   , 068 PSay aCamCab[nPar,3] Picture "@e 999,999.99"  //..Valor da parcela
		    EndIf   
		    @ Prow()   , 136 PSay aCamCab[nPar,2]         //..Vencimento da parcela
		    @ Prow()   , 148 PSay aCamCab[nPar,3] Picture "@e 999,999.99"  //..Valor da parcela
		    @ Prow()   , 165 PSay aCamCab[nPar,3] Picture "@e 999,999.99"  //..Valor da parcela
		    
		    If Len( aProdutos ) > 1
		       @ Prow()+1 , 000 PSay Left( aProdutos[2,1],20)  //..Descricao do produto Faturados
		       @ Prow()   , 080 PSay Left( aProdutos[2,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1 , 000 PSay ""
		    EndIf   
		    
		    If Len( aProdutos ) > 2
		       @ Prow()+1 , 000 PSay Left( aProdutos[3,1],20)  //..Descricao do produto Faturados
		       @ Prow()   , 030 PSay nBase  Picture "@e 99999,999.99"      //..Valor da Base Proporcional
		       @ Prow()   , 056 PSay aCamCab[nPar,2] + Mv_par15
		       @ Prow()   , 068 PSay aCamCab[nPar,3] + ( aCamCab[nPar,3] * Mv_par14 /100 )  Picture "@e 999,999.99" 
		       @ Prow()   , 080 PSay Left( aProdutos[3,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1 , 030 PSay nBase  Picture "@e 99999,999.99"      //..Valor da Base Proporcional
		       @ Prow()   , 056 PSay aCamCab[nPar,2] + Mv_par15
		       @ Prow()   , 068 PSay aCamCab[nPar,3] + ( aCamCab[nPar,3] * Mv_par14 /100 )  Picture "@e 999,999.99" 
		    EndIf   
		    
		    @ Prow()   , 110 PSay nBase  Picture "@e 99999,999.99"      //..Valor da Base Proporcional
		    @ Prow()   , 136 PSay aCamCab[nPar,2] + Mv_par15
		    @ Prow()   , 148 PSay aCamCab[nPar,3] + ( aCamCab[nPar,3] * Mv_par14 /100 )  Picture "@e 999,999.99" 
		    @ Prow()   , 165 PSay aCamCab[nPar,3] + ( aCamCab[nPar,3] * Mv_par14 /100 )  Picture "@e 999,999.99" 
		    
		    If Len( aProdutos ) > 3
		       @ Prow()+1 , 000 PSay Left( aProdutos[4,1],20)  //..Descricao do produto Faturados
		       @ Prow()+1 , 080 PSay Left( aProdutos[4,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1 , 000 PSay ""
		    EndIf   
		    
		    If Len( aProdutos ) > 4
		       @ Prow()+1 , 000 PSay Left( aProdutos[5,1],20)    //..Descricao do produto Faturados
		       @ Prow()   , 030 PSay nPer  Picture "@e 999.99%"  //..Percentual da parcela na Base
		       @ Prow()   , 080 PSay Left( aProdutos[5,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1 , 030 PSay nPer  Picture "@e 999.99%"  //..Percentual da parcela na Base
		    EndIf   
		    
		    @ Prow()   , 110 PSay nPer  Picture "@e 999.99%"  //..Percentual da parcela na Base
		    
		    If Len( aProdutos ) > 5
		       @ Prow()+1 , 000 PSay Left( aProdutos[6,1],20)  //..Descricao do produto Faturados
		       @ Prow()+1 , 080 PSay Left( aProdutos[6,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1 , 000 PSay ""
		    EndIf   
		    
		    If Len( aProdutos ) > 6
		       @ Prow()+1 , 000 PSay Left( aProdutos[7,1],20)    //..Descricao do produto Faturados
		       @ Prow()   , 030 PSay nValDup Picture "@e 99999,999.99"  //..Valor todal de Duplicatas
		       @ Prow()   , 080 PSay Left( aProdutos[7,1],20)  //..Descricao do produto Faturados
		    Else
		       @ Prow()+1  , 030 PSay nValDup Picture "@e 99999,999.99"  //..Valor todal de Duplicatas
		    EndIf   
		    
		    @ Prow()   , 110 PSay nValDup Picture "@e 99999,999.99"  //..Valor todal de Duplicatas
		    
		    @ Prow()+1 , 000 PSay Trim(Sa1->A1_Nome) + "(" + Sa1->A1_Cod + ")"
		    @ Prow()   , 080 PSay Trim(Sa1->A1_Nome) + "(" + Sa1->A1_Cod + ")"
		    @ Prow()+1 , 000 PSay Sa1->A1_End 
		    @ Prow()   , 080 PSay Sa1->A1_End 
		    @ Prow()+1 , 000 PSay Sa1->A1_Bairro + "Cep: " + Sa1->A1_Cep
		    @ Prow()   , 080 PSay Sa1->A1_Bairro + "Cep: " + Sa1->A1_Cep
		     
		    @ Prow()+3 , 000 PSay "Codigo do Imovel: " + N01->N01_Cod
		    @ Prow()   , 080 PSay "Codigo do Imovel: " + N01->N01_Cod
		                  
		    nLinha := 0
		    For nPAno := 1 to len( aPendentes )
		        If nPAno > 3
		           Exit
		        EndIf   
		        nLinha ++
		        @ Prow()+1 , 000 PSay "Debito do Ano: " + aPendentes[nPAno] + " Valor de R$ " + Transform(aValPen[nPAno], "@e 99999,999.99") 
		        @ Prow()   , 080 PSay "Debito do Ano: " + aPendentes[nPAno] + " Valor de R$ " + Transform(aValPen[nPAno], "@e 99999,999.99") 
		    Next
		          
		    @ Prow() + (5 - nLinha) , 0 PSay Mv_Par16
		    @ Prow() + 1            , 0 PSay Mv_Par17
		    
		    @ Prow() + 7 , 0 Psay ""
		     
		Next    
		   
	    DbSelectArea("N01") 
	    If N01->N01_Impres < 9
	       RecLock("N01",.f.)
	       N01->N01_Impres := N01->N01_Impres + 1
		   N01->N01_DtEmis := dDataBase
		   MsUnLock()
		EndIf   
Next	
SET FILTER TO 

Return( NIL )
