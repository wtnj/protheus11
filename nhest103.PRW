/*                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST103       ³ Fabio William Nico     ³ Data ³ 05/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas de envio para FIAT / PEQUENA                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaEst                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NHEST103()    
Local cPermite := ""

	//-- OS Nº: 038868
	//-- OS Nº: 041566
	cPermite := "ANGELACS/GILBERTOSF/ANTONIORP/CLODOALDOSS/TONIR/SIDNEIC/AGUINALDOAS/JULIANOCM/LEANDROCA/EZEQUIELM/EDIVALSP/ALEXANDRMT/CLAUDIOSL/FRANCISCOPS/ARTHURCE"
	//-- FIM OS Nº: 041566
	
	If !AllTrim(Upper(cUserName))$cPermite+"/JOAOFR/ADMIN/ALEXANDRERB/MARCOSR/GUILHERMEDC/DOUGLASSD" //KARINARL"
		Alert("Usuário não permitido! Somente permitido para: "+cPermite)
		Return .f.
	Endif
	
	DBSELECTAREA('SB1')
	
	//SET FILTER TO SUBSTR(SB1->B1_COD,1,7)$'FIA03.4.'
	SET FILTER TO ALLTRIM(SB1->B1_COD)$"FIA03.4.0240.00/FIA03.4.0238.00/FIA03.4.0258.00"
	
	//-- FIM OS 038868

	If !Pergunte('EST103',.T.)
	   Return
	Endif
		
	If !SUBSTR(mv_par01,1,7)$'FIA03.4.'
		Alert('Produto inválido! Produto deve iniciar com FIA03.4.!')
		Return
	Endif
		
	Processa({|| Etiqueta() }, "Etiqueta de Produto")

	SET FILTER TO
	
Return
           
Static Function Etiqueta() 
Private cStartPath 	:= GetSrvProfString("Startpath","") 

	/*
	IF SM0->M0_CODIGO == "NH"  //empresa USINAGEM
		if mv_par01 == 1
			cProd := 'FI03.4.250.01' //BIELA 1.0
		ElseIf mv_par01 == 2
			cProd := 'FI03.4.250.00' //BIELA 1.4
		EndIf  
	EndIf
	
	IF SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
		If MV_PAR01 == 1
			cProd := 'FIA03.4.0240.00' // BIELA 1.4 (WHB)
		ElseIf mv_par01 == 2
			cProd := 'FIA03.4.0110.00' // BIELA 1.4 L- FIAT (FORJAS)    
		ElseIf mv_par01 == 3
			cProd := 'FIA03.4.0238.00' // BIELA FIAT 1.0 - MONTADA (WHB)
		ElseIf mv_par01 == 4
			cProd := 'FIA03.4.0202.00' // BIELA LF FIAT (FORJAS)
		ElseIf mv_par01 == 5
			cProd := 'FIA03.4.0258.00' // BIELA 1.0 LF (WHB)
		EndIf  
	EndIF
    */
    
	SB1->(dbsetorder(1)) // FILIAL + COD
	SB1->(dbseek(xFilial('SB1')+mv_par01))
        
	oFont06  := TFont():New("Arial",,6,,.F.)	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont06N := TFont():New("Arial",,06,,.T.)	
	oFont08N := TFont():New("Arial",,08,,.T.)	
	oFont10N := TFont():New("Arial",,10,,.T.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	
   	oPr := tAvPrinter():New("Protheus")
   	oPr:StartPage()
    
	_line := 100
    _imp := 1
    _linbar = 2.75
    _classe := '11'
                                        
    if mv_par03 = 1
		_classe := '11'
  	elseif mv_par03 = 2
    	_classe := '12'
    elseif mv_par03 = 3
    	_classe := '21'
    else
    	_classe := '22'
    endif

   	For m := 1 to mv_par02  STEP 2

	    _codap5 = len(alltrim(SB1->B1_CODAP5))
	    _cod2   = Replicate("0",11-_codap5)+SB1->B1_CODAP5
		_CodBar := substr(_cod2,0,11)+'00008FZA19424'

		IncProc("Imprimindo Etiqueta FIAT")

	    //  CAIXA 001
		oPr:Line(_line,0020,_line,1170) // Horizontal 1º linha
		oPr:Line(_line,0020,_line+0845,0020) // vertical ESQUERDA
		oPr:Line(_line,1170,_line+0845,1170) // vertical DIREITA
		oPr:Line(_line,0400,_line+170,0400) // vertical
		oPr:Line(_line,0800,_line+170,0800) // vertical

	    //  CAIXA 002
		oPr:Line(_line,1200,_line,2350) // Horizontal 1º linha
		oPr:Line(_line,1200,_line+0845,1200) // vertical ESQUERDA
		oPr:Line(_line,2350,_line+0845,2350) // vertical DIREITA
		oPr:Line(_line,1600,_line+170,1600) // vertical
		oPr:Line(_line,2000,_line+170,2000) // vertical
	
	    oPr:Say(_line,0810,OemtoAnsi("Cod. Fornecedor:"), oFont06)    
	    oPr:Say(_line,2010,OemtoAnsi("Cod. Fornecedor:"), oFont06)    

		oPr:SayBitmap(_line+10,050, cStartPath+"\fiat.bmp",340,170)	
		_line :=  _line + 20   // 120             
	    //oPr:Say(_line+20,0100,OemtoAnsi("LOGO 1 "), oFont12N)
	    //oPr:Say(_line,1300,OemtoAnsi("LOGO 11"), oFont12N)
	    
	    oPr:Say(_line,0910,OemtoAnsi("19424"),oFont10N)    
	    oPr:Say(_line,2110,OemtoAnsi("19424"),oFont10N)
	    
		_line :=  _line + 20   //  150
	    oPr:Say(_line,0450,OemtoAnsi("WHB FUNDIÇÃO S.A."), oFont08N)    
	    oPr:Say(_line,1650,OemtoAnsi("WHB FUNDIÇÃO S.A."), oFont08N)   
	    
	    
	    oPr:SayBitmap(_line-30,1240, cStartPath+"\fiat.bmp",340,170)
	      
		_line :=  _line + 30   // 180 		
	    //oPr:Say(_line+20,0060,OemtoAnsi("LOGO 2"), oFont06N)
	    //oPr:Say(_line,1260,OemtoAnsi("LOGO 22"), oFont06N)
		
		_line :=  _line + 20   //  200
		oPr:Line(_line,0800,_line,1170) // Horizontal 1º linha  CX1
		oPr:Line(_line,2000,_line,2350) // Horizontal 1º linha  CX1
	
		_line :=  _line + 10     // 210 
	    oPr:Say(_line,0810,OemtoAnsi("Data:"), oFont06)    
	    oPr:Say(_line,2010,OemtoAnsi("Data:"), oFont06)    
	
		_line :=  _line + 10
	    oPr:Say(_line,0910,OemtoAnsi(DTOC(Date())),oFont10N)    
	    oPr:Say(_line,2110,OemtoAnsi(DTOC(Date())),oFont10N)        
		
		_line :=  _line + 60 //  300                                                           
		oPr:Line(_line,0020,_line,1170) // Horizontal 1º linha  CX1
		oPr:Line(_line,1200,_line,2350) // Horizontal 1º linha  CX1	
		
		_line :=  _line + 10 //  310	
	    oPr:Say(_line,0040,OemtoAnsi("Desenho:"), oFont06)    
	    oPr:Say(_line,1240,OemtoAnsi("Desenho:"), oFont06)    
	
		_line :=  _line + 05 //  310	                                    
	    oPr:Say(_line,0450,SB1->B1_CODAP5,oFont10N)
	    oPr:Say(_line,1650,SB1->B1_CODAP5,oFont10N)
	
		MSBAR("CODE128",_linbar,1.0 ,Alltrim(_CodBar),oPr,.F., ,.T.  ,0.0224,0.85,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barraS correto
		MSBAR("CODE128",_linbar,11.0,Alltrim(_CodBar),oPr,.F., ,.T.  ,0.0224,0.85,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barraS correto
	
	  	if _linbar > 17
			_linbar = 2.75       
	  	else	  	
	  	  	_linbar := _linbar + 7.7
		endif
	  	
		_line :=  _line + 160 //  310	                                    
	    oPr:Say(_line,0400,_CodBar,oFont08N)    
	    oPr:Say(_line,1600,_CodBar,oFont08N)    
	
		_line :=  _line + 50   // 600
		oPr:Line(_line,0020,_line,1170) // Horizontal 1º linha  CX1
		oPr:Line(_line,0900,_line+450,0900) // vertical 
	
		oPr:Line(_line,1200,_line,2350) // Horizontal 1º linha  CX1
		oPr:Line(_line,2100,_line+450,2100) // vertical 
	
		_line :=  _line + 10  // 610
		oPr:Say(_line,0040,OemtoAnsi("Denominacao:"), oFont06)    
	    oPr:Say(_line,0910,OemtoAnsi("Qtde da Embalagem:"), oFont06)    
		oPr:Say(_line,1240,OemtoAnsi("Denominacao:"), oFont06)    
	    oPr:Say(_line,2110,OemtoAnsi("Qtde da Embalagem:"), oFont06)    
	
		_line :=  _line + 20 //  310	                                                        
	    oPr:Say(_line,0080,SB1->B1_DESC,oFont10N)    // DENOMINACAO DO PRODUTO
	    oPr:Say(_line,1280,SB1->B1_DESC,oFont10N)    // DENOMINACAO DO PRODUTO    
	    oPr:Say(_line,1000,'00024',oFont10)    
	    oPr:Say(_line,2200,'00024',oFont10)    
	
		_line :=  _line + 60  // 700
		oPr:Line(_line,0020,_line,1170) // Horizontal 1º linha  CX1
		oPr:Line(_line,1200,_line,2350) // Horizontal 1º linha  CX1
			
		oPr:Line(_line,0300,_line+360,0300) // vertical 
		oPr:Line(_line,0600,_line+360,0600) // vertical 
		
		oPr:Line(_line,1500,_line+360,1500) // vertical 
		oPr:Line(_line,1800,_line+360,1800) // vertical 
		
		_line :=  _line + 10	//710
	    oPr:Say(_line,0040,OemtoAnsi("Classe: "), oFont06)    
   	    oPr:Say(_line,1240,OemtoAnsi("Classe: "), oFont06) 
	    oPr:Say(_line,0310,OemtoAnsi("Aplicacao:"), oFont06)    
   	    oPr:Say(_line,1510,OemtoAnsi("Aplicacao:"), oFont06)    
	    oPr:Say(_line,0610,OemtoAnsi("Ponto de Entrega:"), oFont06)    
   	    oPr:Say(_line,1810,OemtoAnsi("Ponto de Entrega:"), oFont06)    
	    oPr:Say(_line,0910,OemtoAnsi("Cod. Embalagem:"), oFont06)    
   	  	oPr:Say(_line,2110,OemtoAnsi("Cod. Embalagem:"), oFont06)    
	
		_line :=  _line + 30	//710
	    oPr:Say(_line,0080,_classe,oFont12N)             
	    oPr:Say(_line,1280,_classe,oFont12N)             
	        
	    oPr:Say(_line,0650,OemtoAnsi("G.08-FILE"),oFont10)    
	    oPr:Say(_line,1000,OemtoAnsi("FZA"),oFont10)    
	    oPr:Say(_line,1850,OemtoAnsi("G.08-FILE"),oFont10)    
	    oPr:Say(_line,2200,OemtoAnsi("FZA"),oFont10)    
	
		_line :=  _line + 50   // 800			
		oPr:Line(_line,0020,_line,1170) // Horizontal 1º linha  CX1
		oPr:Line(_line,1200,_line,2350) // Horizontal 1º linha  CX1
	
		_line :=  _line + 10	//810
	    oPr:Say(_line,0040,OemtoAnsi("No. do Lote:"), oFont06)    
	    oPr:Say(_line,1240,OemtoAnsi("No. do Lote:"), oFont06) 
	    oPr:Say(_line,0310,OemtoAnsi("Data Fab do Lote:"), oFont06)    
	    oPr:Say(_line,1510,OemtoAnsi("Data Fab do Lote:"), oFont06)        
	    oPr:Say(_line,0610,OemtoAnsi("Quant do Lote:"), oFont06)    
	    oPr:Say(_line,1810,OemtoAnsi("Quant do Lote:"), oFont06)        
	    oPr:Say(_line,0910,OemtoAnsi("Controle Int. Fornecedor"), oFont06)    
	    oPr:Say(_line,2110,OemtoAnsi("Controle Int. Fornecedor"), oFont06)        
	
		_line :=  _line + 80  // 900		
		oPr:Line(_line,0020,_line,0900) // Horizontal 1º linha  CX1
		oPr:Line(_line,1200,_line,2100) // Horizontal 1º linha  CX1
	                                                                   
		_line :=  _line + 10	//910
	    oPr:Say(_line,0040,OemtoAnsi("Classe Funcional:"), oFont06)    
	    oPr:Say(_line,1240,OemtoAnsi("Classe Funcional:"), oFont06)        
	    oPr:Say(_line,0310,OemtoAnsi("Vinculo:"), oFont06)    
	    oPr:Say(_line,1510,OemtoAnsi("Vinculo:"), oFont06)        
	    oPr:Say(_line,0610,OemtoAnsi("Indicacao Suplementar:"), oFont06) 
	    oPr:Say(_line,1810,OemtoAnsi("Indicacao Suplementar:"), oFont06) 
	    
	   	_line :=  _line + 30	//910
	    oPr:Say(_line,0170,OemtoAnsi("1"),oFont10)    
	    oPr:Say(_line,0350,OemtoAnsi("W"),oFont10)           
	    oPr:Say(_line,1370,OemtoAnsi("1"),oFont10)    
	    oPr:Say(_line,1550,OemtoAnsi("W"),oFont10)           
	
		_line :=  _line + 10
		oPr:Line(_line,0900,_line,1170) // Horizontal 1º linha  CX1
		oPr:Line(_line,2100,_line,2350) // Horizontal 1º linha  CX1	
	
		_line :=  _line + 10	//910
	    oPr:Say(_line,0910,OemtoAnsi("Controle Oper. Logistico:"), oFont06)    
	    oPr:Say(_line,2110,OemtoAnsi("Controle Oper. Logistico:"), oFont06)    
	    
		_line :=  _line + 30	
		oPr:Line(_line,0020,_line,0900) // Horizontal 1º linha  CX1
		oPr:Line(_line,1200,_line,2100) // Horizontal 1º linha  CX1	
		
		_line :=  _line + 10
	    oPr:Say(_line,0040,OemtoAnsi("Embarque controlado:"), oFont06)    
	    oPr:Say(_line,0310,OemtoAnsi("Lote sob Desvio:"), oFont06)    
	    oPr:Say(_line,0610,OemtoAnsi("DUM:"), oFont06)    
	    oPr:Say(_line,1240,OemtoAnsi("Embarque controlado:"), oFont06)    
	    oPr:Say(_line,1510,OemtoAnsi("Lote sob Desvio:"), oFont06)    
	    oPr:Say(_line,1810,OemtoAnsi("DUM:"), oFont06)    
	                        
		_line :=  _line + 30
	
		oPr:Say(_line,0170,OemtoAnsi(MV_PAR04),oFont10)//embarque controlado
	   	oPr:Say(_line,1370,OemtoAnsi(MV_PAR04),oFont10)//embarque controlado 
	
	    oPr:Say(_line,0310,OemtoAnsi("FPT 1104/1"),oFont10)//embarque controlado (fixo = 1)
	    oPr:Say(_line,1510,OemtoAnsi("FPT 1104/1"),oFont10)//embarque controlado (fixo = 1)    
	
	    oPr:Say(_line,0650,OemtoAnsi("13092006"),oFont10)
	   	oPr:Say(_line,1850,OemtoAnsi("13092006"),oFont10)
	
		_line :=  _line + 50
		oPr:Line(_line,0020,_line,1170) // Horizontal ULTIMA LINHA
		oPr:Line(_line,1200,_line,2350) // Horizontal ULTIMA LINHA	
	
		_line :=  _line + 100
	
	    if _imp = 3
			oPr:EndPage()
			oPr:StartPage()
	    	_line := 100 
	    	_imp := 1
		else
			_imp++
	    endif
	
	NEXT	
	                                                      
	oPr:Preview()
	oPr:End()
          
Return(.T.)