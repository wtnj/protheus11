/*/                   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT027 ³Autor  ³ João Felipe da Rosa   ³ Data ³ 26/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime Etiqueta de Codigo de Barras p/ Suspensys          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
³±±																		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

/*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHFAT027()


//mv_par01 NF ?
//mv_par02 Lote ?
//mv_par03 Ordem de Compra ?
//mv_par04 Peca ?
//mv_par05 Quantidade ?
//mv_par06 Volume ?
//mv_par07 Data e Fab.

If !Pergunte('FAT027',.T.)
	Return(nil)
Endif   

//-----------------------------------------------------------------------------------------------------
//  verifica se tem o bmp para impressao.
//-----------------------------------------------------------------------------------------------------
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

If !File(cStartPath+"WHBL.BMP")
	MsgAlert("Bitmaps nao encontrados, baixar arquivo do FTP !","Atencao !")
	Return Nil
Endif


Processa({|| EtiqMark() }, "Etiqueta de Produto")

Return(nil)

Static Function EtiqMark()

Local nEtiq  := 1           
Local nxBar := 4.9

Local NLIN 	  := 100
    oFonteG1 := TFont():New("Arial",,8,,.t.,,,,,.f.)
    oFonteG2 := TFont():New("Arial",,15,,.t.,,,,,.f.)
    oFonteG3 := TFont():New("Arial",,40,,.t.,,,,,.f.)
    oFonteG4 := TFont():New("Arial",,30,,.t.,,,,,.f.)
    oFonteP1 := TFont():New("Arial",,10,,.t.,,,,,.f.)
    oFonteP2 := TFont():New("Arial",,12,,.t.,,,,,.f.)
    oPr := tAvPrinter():New("Protheus")
    oPr:StartPage()
	oPr:SetPortrait()       

//    aEtiq := {}
	
	For i:= 1 to mv_par06

		oPr:Line(nLin+040,050,nLin+040,2350)   // Horizontal 1º linha 
		oPr:Line(nLin+300,050,nLin+300,2350)   // Horizontal 2º linha 
		oPr:Line(nLin+1140,050,nLin+1140,2350) // Horizontal 3º linha 
		oPr:Line(nLin+040,050,nLin+1140,050)   // Vertical 1º linha 
		oPr:Line(nLin+040,2350,nLin+1140,2350) // Vertical 2º linha 
	
	    oPr:Say(nLin+100,100, "Cód Fornecedor:",oFonteP2)
	    oPr:Say(nLin+100,450,OemToAnsi("4055"),oFonteG2)
	                         
	    oPr:Say(nLin+100,800,"Fornecedor:",oFonteP2)
//		SA1->(DbSetOrder(1))//filial + cod + loja
//		SA1->(DbSeek(xFilial("SA1")+mv_par01+mv_par02))
//		If SA1->(Found())
	   	oPr:Say(nLin+100,1100,OemtoAnsi("WHB FUNDIÇÃO S\A"),oFonteG2)
//	    eNDiF
	    oPr:Say(nLin+200,100,"NF nº:",oFonteP2)
	    oPr:Say(nLin+200,300,mv_par01,oFonteG2)
		    
	    oPr:Say(nLin+200,650,"Lote nº:",oFonteP2)
	    oPr:Say(nLin+200,900,mv_par02,oFonteG2)
	
	    oPr:Say(nLin+200,1300,"Ordem de Compra nº:",oFonteP2)
	    oPr:Say(nLin+200,1800,mv_par03,oFonteG2)
	
	    oPr:Say(nLin+400,100,"Código e Descricao",oFonteP2)
	    oPr:Say(nLin+450,100,mv_par04,oFonteG3)
	
		oPr:SayBitmap(nLin+350,1600,cStartPath+"WHBL.BMP",400,160)    
	
	    SB1->(DbSetOrder(9))//xfilial + codAP5
	    SB1->(DbSeek(xFilial("SB1")+AllTrim(mv_par04)))
	    IF SB1->(Found())
		    oPr:Say(nLin+620,100,SB1->B1_DESC,oFonteG2)
	    EndIf
	
	    oPr:Say(nLin+750,100,"Quantidade:",oFonteP2)
	   	oPr:Say(nLin+750,400,Transform(mv_par05,"@e 999,999"),oFonteG2)    
	   	
	    oPr:Say(nLin+550,1600,"Data de Fabricacao",oFonteP2)
	   	oPr:Say(nLin+580,1600,Transform(mv_par07,"99/99/99"),oFonteG4)    
	
	    oPr:Say(nLin+720,1600,"Sequencia de Volumes",oFonteP2)
	   	oPr:Say(nLin+750,1600,StrZero(nEtiq,3)+"/"+StrZero(mv_par06,3),oFonteG4)
	   	
   		oPr:Line(nLin+900,050,nLin+900,2350) // Horizontal DO CODIGO DE BARRAS
//		oPr:Line(nLin+1000,1600,nLin+1140,1600)   // Vertical DO CODIGO DE BARRAS
	    
	    MSBAR("CODE3_9",nxBar,0.8,Alltrim(mv_par04)+"@"+StrZero(mv_par05,4)+"@"+"4055"+"@"+AllTrim(mv_par02);
	   						 ,oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFonteG1,"CODE3_9",.F.) //imprime cod. de barra da qtde
	
//		oPr:Say(nLin+1400,500,Alltrim(mv_par06)+"@"+StrZero(mv_par07,4)+"@"+AllTrim(mv_par01)+"@"+AllTrim(mv_par04),oFonteP2) 
	
		
	    If nEtiq%2 == 0
	    	oPr:EndPage()
	    	nxBar := 4.9	    	
//	    	nEtiq := 1
	    	nLin  := 100
	    	nEtiq++
	    Else
	    	nEtiq++
	    	nxBar += 6.3
	    	nLin+= 1500
	    EndIf
	    
		

Next

    oPr:Preview()
    oPr:End()
   
    MS_FLUSH()

Return(nil)
         
                                     