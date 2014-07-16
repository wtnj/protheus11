#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHPCP052 Autor ณDouglas de Sousa Dourado  Data ณ 06/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ C๓digo de Barras com filtro na ordem de produ็ใo           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CONTROLE FISICO DA FORJARIA                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       


               
User Function NHPCP052
Private cCompo := ""

oFnt1 := TFont():New("Arial"		,,12,,.T.,,,,,.F.)
oFnt2 := TFont():New("Arial"		,,18,,.T.,,,,,.F.)
oFnt3 := TFont():New("Arial"		,,30,,.T.,,,,,.F.)

If !Pergunte("PCP052",.T.)
	Return .F.
EndIf
oPrn:= tmsPrinter():New("Protheus")
oPrn:StartPage()
Cabecalho()
oPrn:EndPage()
oPrn:Preview()
Return (.T.)   

Static Function fEstrutura(cProd)  
Private cQuery := ""

   cQuery := "SELECT TOP 1 SG1.G1_COMP"
   cQuery += " FROM " + RetSqlName( 'SG1' ) +" SG1 (NOLOCK),"+ RetSqlName( 'SB1' ) +" SB1 (NOLOCK)"
   cQuery += " WHERE G1_FILIAL = '" + xFilial("SG1")+ "'"   
   cQuery += " AND B1_FILIAL = '" + xFilial("SB1")+ "'"         
   cQuery += " AND SG1.G1_INI <='" + Dtos(Ddatabase) + "' AND SG1.G1_FIM >= '"+Dtos(Ddatabase)+ "'"
   cQuery += " AND SG1.G1_COD = '" + cProd + "'"       
   cQuery += " AND SG1.G1_COMP = SB1.B1_COD"  
   cQuery += " AND SB1.B1_DESC NOT LIKE '%CUSTO%'"                		
   cQuery += " AND SUBSTRING(SG1.G1_COMP,7,1) <> '6'"
   cQuery += " AND SUBSTRING(SG1.G1_COMP,1,3) <> 'MOD' AND SG1.G1_QUANT > 0"        
   cQuery += " AND SG1.D_E_L_E_T_ = ' ' "   
   cQuery += " AND SB1.D_E_L_E_T_ = ' ' "      
   cQuery += " ORDER BY SG1.G1_COMP ASC" 

   MemoWrit('C:\TEMP\NHPCP052.SQL',cQuery)

   TCQUERY cQuery NEW ALIAS "TMPP"
   
   TMPP->(Dbgotop())
		   
   // Caso nใo traga nenhum componente
   If TMPP->(Eof())  
   	  cCompo := ''
   ELSE                    
	  cCompo := AllTrim(TMPP->G1_COMP)	
   EndIf 

TMPP->(DbCloseArea())	 
                                                     
Return cCompo   

Static Function getTonMp(cCorrida)
Local nTon := 0, cQuery2 := ""
		
	cQuery2 := " SELECT SUM(DB_QUANT) AS 'DB_QUANT' FROM "+ RetSqlName( 'SDB' ) +" (NOLOCK)" 
	cQuery2 += " WHERE DB_PRODUTO = '"+cCompo+"' "
	cQuery2 += " AND DB_CORRIDA ='"+substr(cCorrida,1,8)+"' "
	cQuery2 += " AND DB_FILIAL = '"+ xFilial("SDB")+ "' "
	cQuery2 += " AND D_E_L_E_T_ = '' "
	cQuery2 += " AND DB_CORRIDA <> '' "				

	MemoWrit('C:\TEMP\NHPCP052MP.SQL',cQuery2)

    TCQUERY cQuery2 NEW ALIAS "TMPMP"
   
    TMPMP->(Dbgotop())
		   
    // Caso nใo traga nenhum componente
    If TMPMP->(Eof())  
   	   nTon := 0
    ELSE                    
	   nTon := TMPMP->DB_QUANT
    EndIf 

	TMPMP->(DbCloseArea())	 

Return nTon   



Static Function Cabecalho()

Private cStartPath 	:= GetSrvProfString("Startpath","")
nAlt := 0
nAltBar := 3.7
nCont := 1

SC2->(DbSetOrder(1) )
SC2->(DbSeek(xFilial("SC2") + mv_par01))
SB1->(DbSetOrder(1) )
SB1->(DbSeek(xFilial("SB1") + SC2->C2_PRODUTO) )
SA1->(DbSetOrder(1) )
SA1->(DbSeek(xFilial("SA1") + Alltrim(SC2->C2_CODCLI) + Alltrim(SC2->C2_LOJA) ))
SA7->(DbSetOrder(2) )
SA7->(DbSeek(xFilial("SA7") + Alltrim(SC2->C2_PRODUTO) + Alltrim(SC2->C2_CODCLI) + Alltrim(SC2->C2_LOJA) ))

SB5->(DbSeek(xFilial("SB5") + SC2->C2_PRODUTO) )

// Come็a a fazer a etiqueta

	oPrn:SayBitmap(30,1250, cStartPath+"\Whbl.bmp",340,170)	
	oPrn:Say(020,20,"WHB - Forjaria",oFnt1)
	oPrn:Say(120,20,"ORDEM DE PRODUวรO:  " + mv_par01,oFnt1)
	oPrn:Say(220,20,"MATERIA PRIMA:  " + fEstrutura(SC2->C2_PRODUTO)+"            Ton. MP.:  "+STR(getTonMp(Alltrim(SC2->C2_CORRIDA))),oFnt1)
	oPrn:Say(310,20,"EMISSรO OP:  " + DTOC(SC2->C2_EMISSAO) + "            Qtde Orig OP.:      " + Transform(SC2->C2_QUANT,"@e 999999"),oFnt1)
	
	oPrn:Line(650,20,650,2500) 
	
    MSBAR("CODE128",nAltBar,0.2,mv_par01,oPrn,.F., ,.T.  ,0.0690,1.0,NIL,NIL,NIL,.F.,,,.F.)// imprime cod. de barra correto
	oPrn:Say(690,20,"PN WHB:  ",oFnt2)
	oPrn:Say(690,330,SC2->C2_PRODUTO,oFnt2) 
	
	oPrn:Say(810,20,"Embalagem Padrใo: ",oFnt2)
	oPrn:Say(810,750,Alltrim(Str(SB5->B5_QPA)),oFnt2)
	
	// Descri็ใo da pe็a	
	oPrn:Say(720,960,Substr(SB1->B1_DESC,1,20),oFnt3)
	                    

	oPrn:Say(940,20,"Data Inicio OP: "+DTOC(SC2->C2_DATPRI),oFnt2)
	oPrn:Say(1080,20,"Data Fim OP: "+DTOC(SC2->C2_DATPRF),oFnt2)
	
	oPrn:Say(1210,20,"Corrida Gerdau:  "+SC2->C2_CORRIDA,oFnt2)
	oPrn:Say(1210,1250,"Corrida WHB:    "+Alltrim(SC2->C2_CORRWHB),oFnt2)
	
	oPrn:Say(1340,20,"Realizado:________________________",oFnt2)
	oPrn:Say(1340,1250,"Perca de MP(Kg):____________________",oFnt2)
	
	//oPrn:Say(1170,20,"Data embalagem:   ____/____/______ ",oFnt1)
	//oPrn:Say(1300,20,"Turno:   1บ (  )   2บ (  )   3บ (  )         Resp.: __________________________________________ " ,oFnt1)
	//oPrn:Say(nAlt + 1430,20,"C.Custo:  " + SC2->C2_CC,oFnt1)
		
	oPrn:Line(nAlt + 1600,20,nAlt + 1600,2500)

Return




	
	
	

    

