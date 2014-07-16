/*/        
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EMP650   ³ Autor ³ Alexandre R. Bento    ³ Data ³ 03/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para Gerar o Empenho das Op's             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico WHB                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa Posicao do Acols que esta o Almoxarifado para Alteracao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      
#include "rwmake.ch" 

User Function Emp650() 

Local _nLocal  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_LOCAL"})
Local _nQuant  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_QUANT"})
Local _nProd   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "G1_COMP"})
Local _cCodPro := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "G1_COD"})
SetPrvt("N,ACOLS,")

dbSelectArea("SB1")
SB1->(DbSetOrder(1))

For n:=1 To Len(aCols)
                        
 ALERT(acols[n][_cCodPro])   
 ALERT(acols[n][_nProd])
 
   	SB1->(DbSeek(xFilial("SB1")+acols[n][_nProd]))
   
	IF SM0->M0_CODIGO=="IT" 
	   If Substr(Alltrim(SB1->B1_COD),7,1)$"3/4" .And. Substr(Alltrim(SB1->B1_COD),1,3) <> "MOD"   
	      acols[n][_nlocal] := "34"//Almoxarifado de processo para produtos com apropriacao diretas                  
	   Else   
      	  acols[n][_nlocal] := "64"//Almoxarifado de processo para produtos com apropriacao diretas                  
       Endif  
	Else
	    IF SM0->M0_CODFIL == "01" //Trata somente a WHB Curitiba
			If SB1->B1_TIPO$"CC/MC" 
				If SM0->M0_CODIGO == "FN" //Empresa Fundicao
			      	acols[n][_nlocal] := "24"//Almoxarifado de processo para produtos com apropriacao diretas                  
			 	Else
		    		acols[n][_nlocal] := "10"//Almoxarifado de processo para produtos com apropriacao diretas                  
		   		EndIf
		   	// NUMERO DO CHAMADO DO MARIO...
		   	ElseIf SB1->B1_TIPO $ "MP" .AND. SB1->B1_GRUPO $ "MP04" // MP FORJARIA
		   		If SM0->M0_CODIGO == "FN" //Empresa Fundicao
					aCols[n][_nlocal] := "44"
				EndIf
			Else                    
		 		If SM0->M0_CODIGO == "FN" //Empresa Fundicao
		    	  	If SB1->B1_TIPO$"PI"
		    	  		//-- os 045857
		     	    	If ALLTRIM(SB1->B1_COD)$"GMB18.5.0027.01/GMB18.5.0027.02/GMB31.2.0285.01"
				      	  	acols[n][_nlocal] := "34"//
			      	  	Else	
			      	  		acols[n][_nlocal] := "20"//Almoxarifado de Macho para produtos com apropriacao diretas                  
			      	  	EndIf
			      	  	
			       Else
		     	      If Substr(SB1->B1_COD,1,2)=="RT" 
		     	         acols[n][_nlocal] := "22"//Almoxarifado de processo para produtos RT (retorno)
		     	      Else
		     	       	 acols[n][_nlocal] := Alltrim(GETMV("MV_LOCPROC"))//Almoxarifado de processo para produtos com apropriacao diretas                     		              
		     	      Endif 
			       Endif	  
			 	Else   	
		   		   acols[n][_nlocal] := Alltrim(GETMV("MV_LOCPROC"))//Almoxarifado de processo para produtos com apropriacao diretas                     	
		   		Endif   
		   	Endif   
		
	
		    If Alltrim(acols[n][_nProd])$"MP01.000004" // Só funciona para a forjaria
		       If acols[n][_nQuant] < 0 // quantidade de empenho negativa       
		            acols[n][_nlocal] := "49"//Almoxarifado de refugo conforme solicitação da O.S. 017128
		       Endif   
		    Endif
		Endif
	    
	    //-- OS Nº: 020717
	    //-- Data: 06/02/2011
	    //-- autor: João Felipe da Rosa
	    If ALLTRIM(UPPER(SB1->B1_UM))$'PC'
			acols[n][_nQuant] := Ceiling(acols[n][_nQuant])
	    EndIf
	    //-- Fim OS Nº: 020717
	Endif
			
Next n

IF SM0->M0_CODIGO == "FN"  //empresa Fundicao
   DbSelectArea("SB1")
   SB1->(DbSetOrder(1))
   SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
   If SB1->B1_GRUPO$"PA02/CP01" 

      For n:=1 To Len(aCols)

         If !Substr(acols[n][_nProd],1,3)$"MOD" //Se o produto for diferente de MOD Altera o Almoxarifado de processo da WHB3                  
	        acols[n][_nlocal] := "34"//Almoxarifado de processo para WHB3                  
	     Endif   
	     
	  Next n
   ElseIf SB1->B1_GRUPO$"PA03" //produto do virabrequim   

      For n:=1 To Len(aCols)

         If !Substr(acols[n][_nProd],1,3)$"MOD" //Se o produto for diferente de MOD Altera o Almoxarifado de processo da WHB3                  
	        acols[n][_nlocal] := "54"//Almoxarifado de processo para WHB5                  
	     Endif   
	     
	  Next n

   ElseIf SB1->B1_GRUPO$"PA06" //produto do virabrequim   

      For n:=1 To Len(aCols)

         If !Substr(acols[n][_nProd],1,3)$"MOD"
         	If Substr(acols[n][_nProd],1,4)$"MP06/RT06" //Se o produto for diferente de MOD Altera o Almoxarifado de processo da WHB3                  
         		acols[n][_nlocal] := "62"//Almoxarifado de processo para WHB5                  
	        Else
	        	acols[n][_nlocal] := "64"//Almoxarifado de processo para WHB5                  
	        Endif
	     Endif
	     
	  Next n

   ElseIf SB1->B1_GRUPO$"PA04/TR04" //produto do forjaria

      For n:=1 To Len(aCols)

         If !Substr(acols[n][_nProd],1,3)$"MOD" //Se o produto for diferente de MOD Altera o Almoxarifado de processo da WHB3                  
	        acols[n][_nlocal] := "44"//Almoxarifado de processo para WHB4                  
	     Endif   
	     
	  Next n
   
   Endif  
Endif

Return
