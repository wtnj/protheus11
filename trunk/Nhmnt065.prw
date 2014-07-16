/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT065  �Autor  �DOUGLAS DOURADO � Data �  01/11/2013	  ���
�������������������������������������������������������������������������͹��
���Desc.     � ETIQUETA MP		                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch" 
#INCLUDE "PROTHEUS.CH"

User Function NHMNT065(_cod)

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP,cARQ,nPbruto,i,nqtde,netiq,nVol")   

Private cPerg := "MNT065"  
Default _cod := ""                              

nPbruto  :=  0

If empty(_cod)            
	If !Pergunte(cPerg,.T.)
	    return
	EndIF
Else
	MV_PAR01 := _cod
EndIf	
	
Processa({|| ImpEtq() }, "Etiqueta")
//Processa({|| ETQTA001() }, "Etiqueta")
	
	
/*
Static Function ETQTA001()
Local nX      
Local cPorta := "LPT1" 

//MsgStop("In�cio!!! Teste Impress�o MSCBPrinter","Impressora Zebra")
alert('Vai come�ar a impressao ...')
MSCBPRINTER("TLP 2844",cPorta,,,.F.)
//MSCBPRINTER("S4M",cPorta,,,.F.,NIL,NIL,NIL,NIL,NIL,.T.)
//MSCBCHKStatus(.T.)

//For nx:=1 to 5   

   MSCBINFOETI("Exemplo 1","MODELO 1")
   MSCBBEGIN(1,6)   
       	MSCBSAY(04,02,"WHB","N","0","044,045")
		MSCBSAY(43,01,"CODIGO","N","A","012,008")
   MSCBEND()               

MSCBINFOETI("Exemplo 1","MODELO 1")
MSCBBEGIN(1,6)
		MSCBBOX(40,00,40,10.7,3) // Linha Vertical
		MSCBBOX(02,10.7,106,10.7) // Segunda Linha Horizontal(acima de Descri��o)
		MSCBBOX(02,30,106,30) // �ltima linha horizontal da etiqueta(acima do c�digo de barras)
		MSCBSAY(04,02,"WHB","N","0","044,045")
		MSCBSAY(43,01,"CODIGO","N","A","012,008")
MSCBEND()           

//Next     

MSCBCLOSEPRINTER()
MS_FLUSH()                                               

Return
*/
   
Static Function ImpEtq()

	Local aEtiq := {}
	Local nWidth  := 0.0330 //Comprimento do cod.de barras (centimetros)                    
	Local nHeigth := 0.991  //Largura do cod.de barras (milimetros)
	Local nLinBar := 1.0    //Linha inicial do cod. de barras da etiqueta
	Local nLinTex := 200    //240
	Local nColBar := 1      //Coluna Inicial do cod. de barras
	Local nColTex := 0      //Coluna Inicial do texto da etiqueta
	Local nColAtu := 1      //Numero de colunas da impressas
	Local nLinAtu := 1      //Numero de linhas impressas
	Local nAjust  := 1                       
	Local _cQtde  
	Local cQuery
	Local _cDimensoes 

	
	cQuery := " SELECT ZG5_COD, ZG5_DATA, ZG5_MATE, ZG5_DIMENX, ZG5_DIMENY, ZG5_DIMENZ, ZG5_REGQL, A2_NOME FROM "+RetSqlName("ZG5")+" (NOLOCK) , "+RetSqlName("SA2")+" (NOLOCK) " 
	cQuery += " WHERE ZG5_COD = '"+MV_PAR01+"' AND ZG5FN0.D_E_L_E_T_ = '' AND ZG5_FILIAL = '"+xFilial("ZF5")+"' AND A2_COD = ZG5_FORN AND A2_LOJA = ZG5_LOJA "	
	TcQuery cQuery NEW ALIAS "ITENS" 			
	TcSetField("ITENS","ZG5_DATA","D")
	ITENS->(dbGoTop())  
	
	_cDimensoes := AllTrim(str(ITENS->ZG5_DIMENX))+' x '+Alltrim(str(ITENS->ZG5_DIMENY))+' x '+Alltrim(str(ITENS->ZG5_DIMENZ))
	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)           	
	oFont18N := TFont():New("Arial",,18,,.T.)
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()


	IncProc("Imprimindo Etiqueta...")

	//oPr:Line(010,020,010,1200) // Horizontal 1� linha	
  	oPr:Say(030,0200,OemtoAnsi("Ferramentaria WHB IV - Forjaria"), oFont14N)
	//oPr:Line(010,020,440,020) // 1� vertical
	//oPr:Line(0110,0380,440,0380) // 2� vertical
	//oPr:Line(0110,0730,440,0730) // 3� vertical	
	//oPr:Line(010,1200,440,1200) // 4� vertical
	
	// **************** Primeira Linha *******************
	//oPr:Line(110,020,110,1200) // Horizontal 2� linha	
  	oPr:Say(160,0050,OemtoAnsi("N� Sequencial WHB"), oFont10)
	oPr:Say(220,0050,MV_PAR01, oFont10) //////XXXXXXXXX                        	  	
	oPr:Say(160,0410,OemtoAnsi("Data Recebimento"), oFont10)                        
	oPr:Say(220,0410,DTOC(ITENS->ZG5_DATA), oFont10)  		                
	oPr:Say(160,0760,OemtoAnsi("N� Certif. de Qualidade"), oFont10)
	oPr:Say(220,0760,ITENS->ZG5_REGQL, oFont10)	
	//oPr:Line(270,020,270,1200) // Horizontal 3� linha     
	// ***************************************************
	
	// **************** Segunda Linha ********************
	oPr:Say(330,0050,OemtoAnsi("Dimens�es"), oFont10)                        
	oPr:Say(390,0050,_cDimensoes, oFont10)  		                
	oPr:Say(330,0410,OemtoAnsi("Fornecedor"), oFont10)
	oPr:Say(390,0410,ITENS->A2_NOME, oFont10)	
	//oPr:Line(440,020,440,1200) // Horizontal 3� linha     
	// ***************************************************
	
	// **************** Segunda Linha ********************
  	oPr:Say(490,0050,OemtoAnsi("A�o"), oFont10)
	oPr:Say(550,0050,ITENS->ZG5_MATE, oFont10) //////XXXXXXXXX                        	  	  
	// ***************************************************

	/*	
  	oPr:Say(160,0050,'S81 7AX - GATEFORD ROAD',oFont14N)

	oPr:Line(240,050,240,2350) // Horizontal 2� linha
	oPr:Say(250,0050,OemtoAnsi("ORDER N�"), oFont12)  	
	oPr:Say(240,0300,MV_PAR01, oFont18N)  		                                        
	MSBAR("CODE3_9",1.5,0.5,ALLTRIM(MV_PAR01),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do produto		
    MSBAR("CODE128",nPol+6.5,10.8,Alltrim(cC25),oPr,.F., ,.T.  ,0.023,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
	oPr:Say(250,1210,OemtoAnsi("Endere�o Fornecedor / Supplier Adress."), oFont12)  	
	oPr:Say(310,1210,'WHB FUNDICAO S/A', oFont16N)

	oPr:Line(390,1200,390,2350) // Horizontal 3� linha            
	oPr:Say(420,1210,OemtoAnsi("P.Liq./Net WT (Kg)"), oFont10)

	oPr:Line(0390,1570,570,1570) // vertical	
	oPr:Say(420,1590,OemtoAnsi("P.Bruto/Gross WT (Kg)"), oFont10)
	oPr:Line(0390,1960,570,1960) // vertical		
	oPr:Say(420,2000,OemtoAnsi("Caixa/Box"), oFont10)
	oPr:Say(500,1250,'', oFont16N)
	oPr:Say(500,1670,'', oFont16N)	
	oPr:Say(500,2050,'', oFont16N)
	
	oPr:Line(0570,0050,0570,2350) // Horizontal 4� linha            	
	oPr:Line(0600,0050,0600,2350) // Horizontal 5� linha            		
	oPr:Say(0630,0050,OemtoAnsi("N� Referencia / Part Number (P)"), oFont12)  		
	oPr:Say(0620,0800,MV_PAR02, oFont18N)

    MSBAR("CODE3_9",3.0,0.5,MV_PAR02,oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra 
	    
  	oPr:Line(0910,0050,0910,2350) // Horizontal 6� linha            		
	oPr:Say(0930,0050,OemtoAnsi("Quantidade / Quantity (Q)"), oFont12)  	
	oPr:Say(0930,1230,OemtoAnsi("Descricao / Description "), oFont12)  	
	oPr:Say(0970,1650,mv_par05, oFont16N)  	
	oPr:Line(0910,1200,1810,1200) // vertical qtde |produto

	oPr:Say(0970,0600,OemtoAnsi(TRANSFORM(MV_PAR03,"99999")), oFont18N)  	
	oPr:Say(1000,1230,'', oFont12N)  	
	oPr:Line(1050,1200,1050,2350) // Horizontal 7� linha            
    oPr:Say(1070,1230,OemtoAnsi("Ref. Embalagem / Box"), oFont12)  		
	oPr:Say(1130,1230,'', oFont18N)  	   
	_cQtde := Alltrim(Str(MV_PAR03))
	MSBAR("CODE3_9",4.4,0.5,_cQtde,oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do produto        

	oPr:Line(1250,0020,1250,1200) // Horizontal 8� linha              	                       
	oPr:Line(1370,1200,1370,2350) // Horizontal 9� linha            
	oPr:Say(1390,1230,OemtoAnsi("Data / Date"), oFont12)
	oPr:Line(1370,1650,1510,1650) // vertical	data | indice de modifica��o    	
	oPr:Say(1390,1700,OemtoAnsi("Mudanca Eng. /Eng. Change"), oFont12)    	
	oPr:Say(1440,1230,'', oFont16N)    		       

  	oPr:Line(1510,0050,1510,2350) // Horizontal 10� linha            	
	oPr:Say(1530,1230,OemtoAnsi("N� Lote / Charge N. (N)"), oFont12)    	    		

	oPr:Say(1760,0070,'', oFont10)    	    		  	
	oPr:Line(1810,0050,1810,2350) // Horizontal 11� linha            	
	*/

   	ITENS->(DbCloseArea())  
    oPr:EndPage()
    //oPr:StartPage()
	oPr:Preview()
	oPr:End()

	MS_FLUSH()

       
Return


