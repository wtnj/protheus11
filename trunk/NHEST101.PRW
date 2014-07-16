/*

NAO UTILIZADO  - SUBSTITUIDO PELO NHEST120

*/

/*                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST101        ³ Joao Felipe da Rosa   ³ Data ³ 06/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas de Recebimento para Identificacao do Produto.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaEst                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßDßßßßßßßß*/
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NHEST101()    
SetPrvt("nNumNf,nQtdeEtq,,aEtiq,cPorta,_CODBARRA,_GITEM,_GNFSaida,_GCodigo")
_GNFSaida := Space(9)
_GITEM	  := Space(3)
_GCodigo  := Space(15)              
_Item := space(6)              
      
nQtdeEtq := 0                     
                                                
//If !Pergunte('EST101',.T.)
//   Return(nil)
//Endif                        



Processa({|| EtiqMark() }, "Etiqueta de Produto")
//Processa({|| gerando()  },"Gerando Dados para a Impressao")

Return(nil)
           
Static Function EtiqMark()
   oFonteG1 := TFont():New("Arial",,12,,.t.,,,,,.f.)
   oFonteG2 := TFont():New("Arial",,16,,.F.,,,,,.f.)
   oFonteG3 := TFont():New("Arial",,20,,.t.,,,,,.f.)
   oFonteG4 := TFont():New("Arial",,30,,.t.,,,,,.f.)
   oFonteP  := TFont():New("Arial",,10,,.t.,,,,,.f.)
   oFonteP2 := TFont():New("Helvetic",,07,,.t.,,,,,.f.)
                                                                           
	   @ 150,050 To 400,450 Dialog DlgDadosEmb Title "Informe o Numero da NF de Saida"  
	   @ 020,020 Say OemToAnsi("Numero da NF Saida") Size 50,8
	   @ 020,075 Get _GNFSaida  PICTURE "@!" F3 "SF2" Size 35,8	valid AtuItem() object ONFSaida
   	   @ 040,020 Say OemToAnsi("Item da NF Saida") Size 50,8
	   @ 040,075 Get _GItem  PICTURE "@!" Size 20, 8 object OItem
   	   @ 060,020 Say OemToAnsi("Codigo do Produto") Size 80,8
       @ 060,075 Get _GCodigo  PICTURE "@!"  Size 50, 8  object OCodigo   
	   
	   @ 085,020 Say OemToAnsi("Quantidade Etiqueta ") Size 50,8
	   @ 084,075 Get nQtdeEtq    PICTURE "99999" Size 20,8 Valid(nQtdeEtq >=0) 
	   @ 110,050 BMPBUTTON TYPE 01 ACTION gerando()
	   @ 110,090 BMPBUTTON TYPE 02 ACTION Close(DlgDadosEmb)
	   Activate Dialog DlgDadosEmb CENTERED 

Return

Static Function ImpEtiq()
Local nEtiq
   	oPr := tAvPrinter():New("Protheus")
    TMP->(DbGoTop())
    ProcRegua(TMP->(RecCount()))
	nEtiq := Val(GetMv("MV_ETQVW")) //Pega o qtde de etq que já foram enviadas	  

	  For i := 1 To nQtdeEtq

		nEtiq++    

		oPr:StartPage()

    	oPr:Line(0050,0020,0050,2350) // Horizontal 1º linha 
		oPr:Line(0050,0020,1900,0020) // vertical DIREITA  1
		oPr:Line(0050,2350,1900,2350) // vertical PARTE 1
                                                    
		oPr:Line(0050,1165,0600,1165) // vertical MEIO 1

		oPr:Line(0450,1550,0600,1550) // vertical PEQUENA 1
		oPr:Line(0450,1950,0600,1950) // vertical PEQUENA 2

		oPr:Line(0300,0020,0300,2350) // Horizontal 2º linha 
		oPr:Line(0450,1165,0450,2350) // Horizontal 4º linha 	
		oPr:Line(0600,0020,0600,2350) // Horizontal 4º linha  

   		oPr:Line(0950,0020,0950,2350) 
  		oPr:Line(1300,0020,1300,1165)
		oPr:Line(1600,0020,1600,2350) 
		oPr:Line(1900,0020,1900,2350) 

		oPr:Line(0950,1165,1900,1165) 
		oPr:Line(1100,1165,1100,2350) 
		oPr:Line(1450,1165,1450,2350) 
		oPr:Line(1450,1600,1600,1600) // vertical PEQUENA 1

	    oPr:Say(0060,0050,OemtoAnsi("Destinatario / Receiver"), oFonteP2)
	     oPr:Say(0100,0050,TMP->A1_NOME, oFonteG2)
   	     oPr:Say(0200,0050,TMP->A1_END, oFonteG1)
	    oPr:Say(0060,1200,OemtoAnsi("Emissao da Nota Fiscal / Note-Tax Issuance"), oFonteP2)
		 oPr:Say(0100,1200,DTOC(STOD(TMP->D2_EMISSAO)), oFonteG2)	    
	    oPr:Say(0320,0050,OemtoAnsi("No.Documento / Advice Note NBR (P)"), oFonteP2)
	     oPr:Say(0360,0050,TMP->D2_DOC, oFonteG2)   

//     	 MSBAR("CODE3_9",4.1,1.0,TMP->D2_DOC ,oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra da NF
 		 MSBAR("CODE3_9",3.4,1.0,TMP->D2_DOC ,oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barraS correto
    	oPr:Say(0320,1200,OemtoAnsi("Endereco Fornecedor / Supplier Adress."), oFonteP2)

    	 If SM0->M0_CODIGO == "NH"  //empresa FUNDICAO
		  oPr:Say(0380,1200,"WHB COMPONENTES AUTOMOTIVOS S\A", oFonteG1)
    	 Elseif SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
		  oPr:Say(0380,1200,"WHB FUNDICAO S\A", oFonteG1)
		 EndIf
  	 	oPr:Say(0470,1200,OemtoAnsi("P.Liq./Net WT (KG)                P.Bruto / Grow WT (KG)                Caixa / Boxes "), oFonteP2)    
		oPr:Say(0620,0050,OemtoAnsi("No Referência / Part Number (P)"), oFonteP2)
    	oPr:Say(0660,0050,TMP->B1_CODAP5, oFonteG3)
//     	MSBAR("CODE3_9",7.0,1.0,OemtoAnsi("0000000000"),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
		MSBAR("CODE3_9",6.1,1.0,OemtoAnsi("0000000000"),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
		oPr:Say(0970,0050,OemtoAnsi("Quantidade / Quantity (Q)"), oFonteP2)
    	 oPr:Say(1010,0350, Transform(TMP->F2_VOLUME1,"@e 9999") , oFonteG3)
//     	 MSBAR("CODE3_9",9.9,1.0, Transform(TMP->F2_VOLUME1,"@e 9999"),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
		MSBAR("CODE3_9",8.9,1.0,Transform(TMP->F2_VOLUME1,"@e 9999"),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
		oPr:Say(0970,1200,OemtoAnsi("Descricao / Description"), oFonteP2)   
    	 oPr:Say(1010,1200,TMP->B1_DESC, oFonteG2)
		oPr:Say(1120,1200,OemtoAnsi("Ref. Embalegem / Box"), oFonteP2)
		oPr:Say(1320,0050,OemtoAnsi("Fornecedor / Supplier (V)"), oFonteP2)
		 oPr:Say(1360,0350,OemtoAnsi("P479"), oFonteG2)		 
//     	 MSBAR("CODE3_9",12.6,1.0,OemtoAnsi("P479"),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
	     MSBAR("CODE3_9",11.6,1.0,OemtoAnsi("P479"),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
		oPr:Say(1470,1200,OemtoAnsi("Data / Date                                    Mudanca Eng. / Eng.Change"), oFonteP2)
		 oPr:Say(1510,1200,OemtoAnsi("P"+Space(40)+DTOC(TMP->QDH_DTREDE)), oFonteG2)
		oPr:Say(1620,0050,OemtoAnsi("No. Refer. / Serial (S/M/G)"), oFonteP2)
  		 oPr:Say(1650,0350,StrZero(nEtiq,6), oFonteG2)
//     	 MSBAR("CODE3_9",15.0,1.0,StrZero(nEtiq,6),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFonteG3,"CODE3_9",.F.) //imprime cod. de barra
	     MSBAR("CODE3_9",14.0,1.0,StrZero(nEtiq,6),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barras
 		oPr:Say(1620,1200,OemtoAnsi("No. Lote / Charge N.(H)"), oFonteP2)
	
		oPr:EndPage()
next 
	oPr:End()
	oPr:Preview()

	SX6->(DbSeek(xFilial()+"MV_ETQVW"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD := Strzero(nEtiq,6) //Grava numero final da etiqueta
	MsUnlock("SX6")
	
    MS_FLUSH()
   	TMP->(DbCloseArea())
   	

        
Return

Static Function AtuItem()

//_GNFSaida 	:= SD2->D2_DOC

SD2->(DbSetOrder(3))//filial + doc + serie + ...
SD2->(DbSeek(xFilial("SD2")+_GNFSaida))
If SD2->(Found())
	_GNFSaida   := SD2->D2_DOC
	_GItem 		:= SD2->D2_ITEM
	_GCodigo 	:= SD2->D2_COD
Else
	MsgBox("Nota Fiscal não encontrada!")
EndIf

ObjectMethod(ONFSaida, "Refresh()")
ObjectMethod(OItem, "Refresh()")
ObjectMethod(OCodigo, "Refresh()")

Return(.T.)


//-----------------------------------------------------------------------------------------------------
// Grava sequencial da etiqueta
//-----------------------------------------------------------------------------------------------------

Static Function GravaDados()
	nEtiq := Val(GetMv("MV_ETQVW")) //Pega o qtde de etq que já foram enviadas   
	SX6->(DbSeek(xFilial()+"MV_ETQVW"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= Strzero(nEtiq,6) //Grava numero final da etiqueta
	MsUnlock("SX6")
    Close(DlgDadosEmb)

Return(.T.)


//-----------------------------------------------------------------------------------------------------
// GERANDO DADOS ARQUIVO TMP
//-----------------------------------------------------------------------------------------------------
Static Function Gerando()
	cQuery := "SELECT A1.A1_COD,A1.A1_NOME,A1.A1_END,D2.D2_DOC,D2.D2_SERIE,D2.D2_QUANT, D2.D2_EMISSAO, "
	cQuery += " F2.F2_VOLUME1, F2.F2_PLIQUI, F2.F2_PBRUTO, B1.B1_DESC, B1.B1_CODAP5,QDH.QDH_DTREDE"
	cQuery += " FROM "+RetSqlName("SA1")+" A1,"+RetSqlName("SD2")+" D2,"+RetSqlName("SB1")+" B1,"
	cQuery += RetSqlName("SF2")+" F2, "+ RetSqlName("QDH")+" QDH "
	cQuery += " WHERE B1.B1_COD = D2.D2_COD  "
	cQuery += " AND D2.D2_DOC = F2.F2_DOC"
	cQuery += " AND D2.D2_SERIE = F2.F2_SERIE"
	cQuery += " AND QDH.QDH_PRODUT = D2.D2_COD"
	cQuery += " AND D2.D2_DOC = '" + _GNFSaida + "'"
	cQuery += " AND D2_CLIENTE = A1_COD "
	cQuery += " AND D2_LOJA = A1_LOJA "	
	cQuery += " AND QDH.QDH_DTREDE <> ''"
	cQuery += " AND D2.D2_FILIAL = '" + xFilial("SD2")+ "' AND D2.D_E_L_E_T_ = '' "
	cQuery += " AND B1.B1_FILIAL = '" + xFilial("SB1")+ "' AND B1.D_E_L_E_T_ = '' "
	cQuery += " AND A1.A1_FILIAL = '" + xFilial("SA1")+ "' AND A1.D_E_L_E_T_ = '' "
	cQuery += " AND F2.F2_FILIAL = '" + xFilial("SF2")+ "' AND F2.D_E_L_E_T_ = '' " 
	cQuery += " AND QDH.QDH_FILIAL = '" + xFilial("QDH")+ "' AND QDH.D_E_L_E_T_ = '' " 
	cQuery += " ORDER BY QDH.QDH_DTREDE DESC"
	MemoWrit('C:\TEMP\EST101.SQL',cQuery)		
	TCQUERY cQuery NEW ALIAS "TMP" 

	TCSETFIELD("TMP","QDH_DTREDE","D")
	Close(DlgDadosEmb)
	

	ImpEtiq()

Return


