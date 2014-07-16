/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT019 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 14/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiqueta TRW                                               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHFAT019()    

SetPrvt("_cQuant,_cSID,_cMSN,_cPON,_cRev,_cEtiq,_cCodPeca,_cPSN,_cSLN,_Sequ")
_cQuant := space(05)
_cSID   := space(20)
_cMSN   := space(20)
_cPON   := space(20)
_cPSN   := space(20)
_cSLN   := space(20)
_cRev   := "A"
_cEtiq  := 0
_cCodPeca := space(15)
_cDesPro := space(50)
_cCodAp5 := space(20)


ZA6->(DbSeek(xFilial("ZA6")+"9001841"))
_cMSN := ALLTRIM(STR(VAL(ZA6->ZA6_SEQUEN)+1))
_cSID := '42004'


@ 010,005 TO 600,1000 DIALOG oDlg TITLE "Impressao ETIQUETA TRW" 
@ 030,030 Say "Codigo Peça          : " 
@ 045,030 Say "Quantidade           : " 
@ 060,030 Say "Supplier ID NUMBER   : " 
@ 075,030 Say "Master Serial NUMBER : " 
@ 090,030 Say "Purchase Order Number: " 
@ 105,030 Say "Revision             : " 
@ 120,030 Say "Packing              : "             
@ 135,030 Say "Lot Number           : "             
@ 150,030 Say "Qtde Etiquetas       : "
                            
@ 030,100 Get _cCodPeca  Size 50,8 F3 "SB1" valid fProduto()   
@ 030,150 Get _cDesPro   Size 133,8 When(.F.) object oDesPro
@ 030,285 Get _cCodAp5   Size 65,8 When(.F.) object oCodAp5
@ 045,100 get _cQuant 	picture "99999" Size 40,8
@ 060,100 get _cSID 	picture "99999999999999999999" Size 65,8
@ 075,100 get _cMSN 	picture "99999999999999999999" Size 65,8
@ 090,100 get _cPON 	picture "@!" Size 65,8
@ 105,100 get _cRev 	picture "@!"   
@ 120,100 get _cPSN 	picture "99999999999999999999" Size 65,8
@ 135,100 get _cSLN 	picture "99999999999999999999" Size 65,8
@ 150,100 get _cEtiq 	picture "999"

@ 165,085 BUTTON "_Imprimir"  SIZE 40,15 ACTION  fImprime()
@ 185,085 BUTTON "_Cancela"   SIZE 40,15 ACTION  fEnd()
ACTIVATE MsDialog oDlg CENTER

Return      


Static Function fEnd() 
   Close(oDlg) 
Return


Static Function fImprime()
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
	Local _Sequ   := 0                      

	oFont08  := TFont():New("Arial",,8,,.F.)	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont20  := TFont():New("Arial",,20,,.F.)
	oFont36  := TFont():New("Arial",,36,,.F.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)

	//Inicia página
	oPr:= tAvPrinter():New("Protheus")
	oPr:SetPortrait()       
	oPr:StartPage()

	_Sequ := val(_cMSN)-1

for x = 1 to _cEtiq       

		_Sequ := _Sequ + 1
		IncProc("Imprimindo Etiqueta TRW")                   
		//--------------------------------------------------------------
		// ETIQUETA 001 DA A4
		//--------------------------------------------------------------
		oPr:Line(0010,0020,0010,2350) // Horizontal 1º linha   
		oPr:Line(0010,0020,1500,0020) // vertical DIREITA
		oPr:Line(0010,2350,1500,2350) // vertical ESQUERDA
	  	oPr:Say(0040,0700,OemtoAnsi("MASTER LABEL"), oFont36)
   	    oPr:Line(0210,0020,0210,2350) // Horizontal 2º linha 
   	    oPr:Say(0220,0025,OemtoAnsi("FROM:"), oFont08)
		oPr:Say(0220,1155,OemtoAnsi("TO:"), oFont08)
		oPr:Say(0260,0035,OemtoAnsi("WHB COMPONENTES AUTOMOTIVOS S.A."), oFont12)
		oPr:Say(0300,0035,OemtoAnsi("STREET WIEGANDO OLSEN, N.1000"), oFont12)
		oPr:Say(0340,0035,OemtoAnsi("CURITIBA - BRASIL "), oFont12)
		oPr:Say(0260,1170,OemtoAnsi("TRW Automotive "), oFont12)
		oPr:Say(0300,1170,OemtoAnsi("La Griega, 101 Parque Industrial"), oFont12)
		oPr:Say(0340,1170,OemtoAnsi("Santa Rosa Jauregui México 76220 "), oFont12)
		oPr:Line(0210,1150,0400,1150) // vertical            
   	    oPr:Line(0400,0020,0400,2350) // Horizontal 3º linha                      
   		
   		oPr:Say(0420,0025,OemtoAnsi("PARTER NUMBER (P)"), oFont08)
   		oPr:Say(0430,0300,OemtoAnsi(_cCodAp5), oFont20)

// 	    MSBAR("CODE128",2.6,0.7,ALLTRIM(_cCodPeca),oPr,NIL,NIL,NIL,0.0210,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde
		MSBAR("CODE128",4.2,1.7,ALLTRIM(_cCodPeca),oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto

   		oPr:Say(0420,1650,OemtoAnsi("REVISON (2P)"), oFont08) 
   		oPr:Say(0430,1850,OemtoAnsi(_cRev), oFont20)
// 	    MSBAR("CODE128",2.6,8,_cRev ,oPr,NIL,NIL,NIL,0.0210,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde   	    
		MSBAR("CODE128",4.2,15,_cRev ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
   		oPr:Line(0400,1600,0670,1600) // vertical            
   	    oPr:Line(0670,0020,0670,2350) // Horizontal 4º linha 

   		oPr:Say(0690,0025,OemtoAnsi("QUANTITY(Q)"), oFont08)
   		oPr:Say(0700,0360,OemtoAnsi(_cQuant), oFont20)
// 	    MSBAR("CODE128",3.7,0.7,ALLTRIM(_cQuant) ,oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde
		MSBAR("CODE128",6.4,1.7,ALLTRIM(_cQuant) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
   		oPr:Say(0690,1200,OemtoAnsi("PO NUMBER (K)"), oFont08)
   		oPr:Say(0700,1450,OemtoAnsi(_cPON), oFont20)
        if ALLTRIM(_cPON) <> ""
//    	    MSBAR("CODE128",3.7,6,ALLTRIM(_cPON) ,oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde   	    
			MSBAR("CODE128",6.4,11,ALLTRIM(_cPON) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
		endif

   		oPr:Line(0670,1150,1500,1150) // vertical            
   	    oPr:Line(0950,0020,0950,2350) // Horizontal 4º linha 

   		oPr:Say(0960,0025,OemtoAnsi("SUPPLIER NUMBER (V)"), oFont08)
   		oPr:Say(0970,0360,OemtoAnsi(_cSID), oFont20)
// 	    MSBAR("CODE128",4.9,0.7,alltrim(_cQuant) ,oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde
		MSBAR("CODE128",8.6,1.7,ALLTRIM(_cQuant) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
   		oPr:Say(0960,1200,OemtoAnsi("PACKING SLIP (11K)"), oFont08)  	    
   		oPr:Say(0970,1450,OemtoAnsi(_cPSN), oFont20)
   		if ALLTRIM(_cPSN) <> ""
// 	  	    MSBAR("CODE128",4.9,6,ALLTRIM(_cPSN) ,oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde   	    
			MSBAR("CODE128",8.6,11,ALLTRIM(_cPSN) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
 	  	endif

   	    oPr:Line(1250,0020,1250,2350) // Horizontal 4º linha 
   		oPr:Say(1260,0025,OemtoAnsi("PKD ID-MASTER (4S)"), oFont08)
   		oPr:Say(1270,0360,OemtoAnsi(str(_Sequ)), oFont20)
// 	    MSBAR("CODE128",6.1,0.7,alltrim(str(_Sequ)) ,oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde
		MSBAR("CODE128",11.1,1.7,ALLTRIM(str(_Sequ)) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
			
   		oPr:Say(1260,1200,OemtoAnsi("LOT NUMBER (1T)"), oFont08)  	    
   		oPr:Say(1270,1450,OemtoAnsi(_cSLN), oFont20)
        if ALLTRIM(_cSLN) <> ""
// 	    	MSBAR("CODE128",6.1,6,alltrim(_cSLN) ,oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE128",.F.) //imprime cod. de barra da qtde   	    
			MSBAR("CODE128",11.1,11,ALLTRIM(_cSLN) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
  	    endif
   	    oPr:Line(1500,0020,1500,2350) // Horizontal 4º linha 

  		//--------------------------------------------------------------
		// ETIQUETA 002 DA A4
		//--------------------------------------------------------------
		oPr:Line(1600,0020,1600,2350) // Horizontal 1º linha   
		oPr:Line(1600,0020,3100,0020) // vertical DIREITA
		oPr:Line(1600,2350,3100,2350) // vertical ESQUERDA
	  	oPr:Say(1630,0700,OemtoAnsi("MASTER LABEL"), oFont36)
   	    oPr:Line(1810,0020,1810,2350) // Horizontal 2º linha 
   	    oPr:Say(1820,0025,OemtoAnsi("FROM:"), oFont08)
		oPr:Say(1820,1155,OemtoAnsi("TO:"), oFont08)
		oPr:Say(1860,0035,OemtoAnsi("WHB COMPONENTES AUTOMOTIVOS S.A."), oFont12)
		oPr:Say(1900,0035,OemtoAnsi("STREET WIEGANDO OLSEN, N.1000"), oFont12)
		oPr:Say(1940,0035,OemtoAnsi("CURITIBA - BRASIL "), oFont12)
		oPr:Say(1860,1170,OemtoAnsi("TRW Automotive "), oFont12)
		oPr:Say(1900,1170,OemtoAnsi("La Griega, 101 Parque Industrial"), oFont12)
		oPr:Say(1940,1170,OemtoAnsi("Santa Rosa Jauregui México 76220 "), oFont12)
		oPr:Line(1810,1150,2000,1150) // vertical            
   	    oPr:Line(2000,0020,2000,2350) // Horizontal 3º linha                      
   		
   		oPr:Say(2020,0025,OemtoAnsi("PARTER NUMBER (P)"), oFont08)
   		oPr:Say(2030,0300,OemtoAnsi(_cCodAp5), oFont20)
		MSBAR("CODE128",17.2,1.7,ALLTRIM(_cCodPeca) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
   		oPr:Say(2020,1650,OemtoAnsi("REVISON (2P)"), oFont08) 
   		oPr:Say(2030,1850,OemtoAnsi(_cRev), oFont20)
		MSBAR("CODE128",17.2,15,_cRev ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
   		oPr:Line(2000,1600,2270,1600) // vertical            
   	    oPr:Line(2270,0020,2270,2350) // Horizontal 4º linha 

   		oPr:Say(2290,0025,OemtoAnsi("QUANTITY(Q)"), oFont08)
   		oPr:Say(2300,0360,OemtoAnsi(_cQuant), oFont20)
		MSBAR("CODE128",19.4,1.7,ALLTRIM(_cQuant) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto

   		oPr:Say(2290,1200,OemtoAnsi("PO NUMBER (K)"), oFont08)
   		oPr:Say(2300,1450,OemtoAnsi(_cPON), oFont20)
        if ALLTRIM(_cPON) <> ""
			MSBAR("CODE128",19.4,11,ALLTRIM(_cPON) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
		endif

   		oPr:Line(2270,1150,3100,1150) // vertical            
   	    oPr:Line(2550,0020,2550,2350) // Horizontal 4º linha 

   		oPr:Say(2560,0025,OemtoAnsi("SUPPLIER NUMBER (V)"), oFont08)
   		oPr:Say(2570,0360,OemtoAnsi(_cSID), oFont20)
		MSBAR("CODE128",21.6,1.7,ALLTRIM(_cQuant) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
   		oPr:Say(2560,1200,OemtoAnsi("PACKING SLIP (11K)"), oFont08)  	    
   		oPr:Say(2570,1450,OemtoAnsi(_cPSN), oFont20)
   		if ALLTRIM(_cPSN) <> ""
			MSBAR("CODE128",21.6,11,ALLTRIM(_cPSN) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
 	  	endif

   	    oPr:Line(2850,0020,2850,2350) // Horizontal 4º linha 
   		oPr:Say(2860,0025,OemtoAnsi("PKD ID-MASTER (4S)"), oFont08)
   		oPr:Say(2870,0360,OemtoAnsi(str(_Sequ)), oFont20)
		MSBAR("CODE128",24.1,1.7,ALLTRIM(str(_Sequ)) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto

   		oPr:Say(2860,1200,OemtoAnsi("LOT NUMBER (1T)"), oFont08)  	    
   		oPr:Say(2870,1450,OemtoAnsi(_cSLN), oFont20)
        if ALLTRIM(_cSLN) <> ""
			MSBAR("CODE128",24.1,11,ALLTRIM(_cSLN) ,oPr,.F., ,.T.  ,0.0394,1.0,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto
  	    endif
   	    oPr:Line(3100,0020,3100,2350) // Horizontal 4º linha 
    	oPr:EndPage()
next		
oPr:Preview()     
oPr:End()
RecLock("ZA6")
    ZA6->ZA6_SEQUEN	:= ALLTRIM(STR(_Sequ))
MsUnLock("ZA6")
_cMSN := ALLTRIM(STR(VAL(ZA6->ZA6_SEQUEN)+1))
oDesPro:Refresh()

Return

//------------------------------------------------------------------------------------------------
//  VERIFICA A EXISTENCIA DO PRODUTO NO CADASTRO.
//------------------------------------------------------------------------------------------------
Static Function fProduto()
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+_cCodPeca))
      _cDesPro := SB1->B1_DESC
      _cCodAp5 := SB1->B1_CODAP5
  Else
      Msgbox("Codigo de produto NAO Encontrada, Verifique !!!" ,"Atencao","ALERT" )
      Return(.F.)
Endif              

if _cCodPeca = 'TW23.4.245.00'
     _cPON := '6Q150133'
   else
     _cPON := '6Q150135'
endif
oDesPro:Refresh()
Return(.T.)