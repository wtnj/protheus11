/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHEEC003  บAutor  ณMarcos R. Roquitski บ Data ณ  25/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ETIQUETA PANDROL                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHEEC003()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,i,nqtde,netiq,nVol")   
Private cPerg := "NHEEC002"                                

nPbruto  :=  0
                           

If Pergunte(cPerg,.T.)

	Processa({|| ImpEtq() }, "Etiqueta de Produto")

Endif


// 
Static Function ImpEtq()

	Local aEtiq := {}
	Local nWidth  := 0.0330 //Comprimento do cod.de barras (centimetros)                    
	Local nHeigth := 0.991  //Largura do cod.de barras (milimetros)
	Local nLinBar := 1.0  //Linha inicial do cod. de barras da etiqueta
	Local nLinTex := 200  //240
	Local nColBar := 1  //Coluna Inicial do cod. de barras
	Local nColTex := 0  //Coluna Inicial do texto da etiqueta
	Local nColAtu := 1  //Numero de colunas da impressas
	Local nLinAtu := 1  //Numero de linhas impressas
	Local nAjust  := 1                       
	Local _cQtde  
	
  
	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()


	IncProc("Imprimindo Etiqueta PANDROL")

	oPr:Line(010,020,010,2350) // Horizontal 1บ linha
	oPr:Line(0010,1200,570,1200) // vertical
  	oPr:Say(040,0050,OemtoAnsi("Destinatแrio / Receiver"), oFont12)
	oPr:Say(040,1210,OemtoAnsi("Emissao da Nota Fiscal / Note-Tax "), oFont12)
	oPr:Say(100,1300,Dtoc(MV_PAR04), oFont18N)  		                                        
	
	oPr:Say(110,0050,'PANDROL UK LIMITED', oFont14N) //////XXXXXXXXX
  	oPr:Say(160,0050,'S81 7AX - GATEFORD ROAD',oFont14N)

	oPr:Line(240,050,240,2350) // Horizontal 2บ linha
	oPr:Say(250,0050,OemtoAnsi("ORDER Nบ"), oFont12)  	
	oPr:Say(240,0300,MV_PAR01, oFont18N)  		                                        
	MSBAR("CODE3_9",1.5,0.5,ALLTRIM(MV_PAR01),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do produto		
//    MSBAR("CODE128",nPol+6.5,10.8,Alltrim(cC25),oPr,.F., ,.T.  ,0.023,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	oPr:Say(250,1210,OemtoAnsi("Endere็o Fornecedor / Supplier Adress."), oFont12)  	
	oPr:Say(310,1210,'WHB FUNDICAO S/A', oFont16N)

	oPr:Line(390,1200,390,2350) // Horizontal 3บ linha            
	oPr:Say(420,1210,OemtoAnsi("P.Liq./Net WT (Kg)"), oFont10)

	oPr:Line(0390,1570,570,1570) // vertical	
	oPr:Say(420,1590,OemtoAnsi("P.Bruto/Gross WT (Kg)"), oFont10)
	oPr:Line(0390,1960,570,1960) // vertical		
	oPr:Say(420,2000,OemtoAnsi("Caixa/Box"), oFont10)
	oPr:Say(500,1250,'', oFont16N)
	oPr:Say(500,1670,'', oFont16N)	
	oPr:Say(500,2050,'', oFont16N)
	
	oPr:Line(0570,0050,0570,2350) // Horizontal 4บ linha            	
	oPr:Line(0600,0050,0600,2350) // Horizontal 5บ linha            		
	oPr:Say(0630,0050,OemtoAnsi("Nบ Referencia / Part Number (P)"), oFont12)  		
	oPr:Say(0620,0800,MV_PAR02, oFont18N)

    MSBAR("CODE3_9",3.0,0.5,MV_PAR02,oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra 
	    
  	oPr:Line(0910,0050,0910,2350) // Horizontal 6บ linha            		
	oPr:Say(0930,0050,OemtoAnsi("Quantidade / Quantity (Q)"), oFont12)  	
	oPr:Say(0930,1230,OemtoAnsi("Descricao / Description "), oFont12)  	
	oPr:Say(0970,1650,mv_par05, oFont16N)  	
	oPr:Line(0910,1200,1810,1200) // vertical qtde |produto

	oPr:Say(0970,0600,OemtoAnsi(TRANSFORM(MV_PAR03,"99999")), oFont18N)  	
	oPr:Say(1000,1230,'', oFont12N)  	
	oPr:Line(1050,1200,1050,2350) // Horizontal 7บ linha            
    oPr:Say(1070,1230,OemtoAnsi("Ref. Embalagem / Box"), oFont12)  		
	oPr:Say(1130,1230,'', oFont18N)  	   
	_cQtde := Alltrim(Str(MV_PAR03))
	MSBAR("CODE3_9",4.4,0.5,_cQtde,oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do produto        

	oPr:Line(1250,0020,1250,1200) // Horizontal 8บ linha              	                       
	oPr:Line(1370,1200,1370,2350) // Horizontal 9บ linha            
	oPr:Say(1390,1230,OemtoAnsi("Data / Date"), oFont12)
	oPr:Line(1370,1650,1510,1650) // vertical	data | indice de modifica็ใo    	
	oPr:Say(1390,1700,OemtoAnsi("Mudanca Eng. /Eng. Change"), oFont12)    	
	oPr:Say(1440,1230,'', oFont16N)    		       

  	oPr:Line(1510,0050,1510,2350) // Horizontal 10บ linha            	
	oPr:Say(1530,1230,OemtoAnsi("Nบ Lote / Charge N. (N)"), oFont12)    	    		

	oPr:Say(1760,0070,'', oFont10)    	    		  	
	oPr:Line(1810,0050,1810,2350) // Horizontal 11บ linha            	
	  
    oPr:EndPage()
    //oPr:StartPage()
	oPr:Preview()
	oPr:End()

	MS_FLUSH()

Return


