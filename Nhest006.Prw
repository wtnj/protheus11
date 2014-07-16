/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST006 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 26/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Mostra os dados da pesquisa do SC1,SC7 E SD1               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"   
#include "Font.ch"
#include "Colors.ch"


User Function NHEST006( ) 

DEFINE FONT oFont  NAME "Arial" SIZE 0, -12 BOLD                                           
SetPrvt(" cQuery,dEmissao,cDoc,cLoja,cFornece,cSerie,nQtdeReg,aHeader")
SetPrvt(" cPedido,cHora,cTipo,cTxtMsg,acols,cCodFor,cLoja,cNomFor,cTipoNF,cSitPed")
SetPrvt(" aAuxCombo1,aCombo1,nVlrTot,nVlrMer,dEmissao,dDigi,nQtdJE,nQtdPed,nQtdSal")

nVlrMer    := 0
aAuxCombo1 := {"N","D","B","I","P","C"}
aCombo1	  := {"Normal","Devoluçao" ,"Beneficiamento","Compl.  ICMS","Compl.  IPI","Compl. Preco/frete"}
cDoc       := SC7->C7_NUM
cFornece   := SC7->C7_FORNECE 
cLoja      := SC7->C7_LOJA          
cHora      := " "

Processa({|| Gerando() }, "Selecionando Dados do Pedido")
DbSelectArea("TMP")
DbCloseArea()

Return

Static Function Gerando() 
Local _cFuncao
                          
	cQuery := "SELECT SD1.D1_DOC,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_DTDIGIT,SD1.D1_LOTECTL,"
	cQuery += "SD1.D1_QUANT,SD1.D1_PEDIDO,SD1.D1_SERIE,SD1.D1_EMISSAO,SD1.D1_TOTAL,SD1.D1_EXPORT,SC1.C1_SOLICIT," 
	cQuery += "SD1.D1_DESCRI,SD1.D1_VUNIT,SD1.D1_LOCAL,SD1.D1_UM,SD1.D1_CF,SD1.D1_TES,SD1.D1_TIPO,SD1.D1_ITEM,"
	cQuery += "SA2.A2_NOME, SC7.C7_ITEM,SD1.D1_ITEMPC,SC7.C7_NUMSC,SC7.C7_ITEMSC,SC7.C7_QUANT,SC7.C7_QUJE"	
	
	cQuery += " FROM " + RetSqlName( 'SD1' ) + " SD1 (NOLOCK)  " 
	
	cQuery += " INNER JOIN " + RetSqlName( 'SB1' ) + " SB1 (NOLOCK) ON "
	cQuery += " 	SB1.B1_FILIAL  = '" + xFilial("SB1")+ "'"
	cQuery += " AND SB1.B1_COD     = SD1.D1_COD "  
	cQuery += " AND SB1.D_E_L_E_T_ = ' '"
	
	cQuery += " INNER JOIN " + RetSqlName( 'SA2' ) +" SA2 (NOLOCK) ON " 
    cQuery += " 	SA2.A2_FILIAL  = '" + xFilial("SA2")+ "' "
	cQuery += " AND SD1.D1_FORNECE = SA2.A2_COD "
	cQuery += " AND SD1.D1_LOJA    = SA2.A2_LOJA "	
	cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
	 
	cQuery += " INNER JOIN " + RetSqlName( 'SC7' ) +" SC7 (NOLOCK) ON "
	cQuery += " 	SC7.C7_FILIAL  = SD1.D1_FILIAL "
	cQuery += " AND SC7.C7_PRODUTO = SD1.D1_COD " 
	cQuery += "	AND SC7.C7_NUM     = SD1.D1_PEDIDO "
	cQuery += " AND SC7.C7_ITEM    = SD1.D1_ITEMPC " 
	cQuery += "	AND SC7.C7_FORNECE = SD1.D1_FORNECE" 
	cQuery += " AND SC7.C7_LOJA    = SD1.D1_LOJA " 
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN " + RetSqlName( 'SC1' ) +" SC1 (NOLOCK) ON "	
    cQuery += "     SC7.C7_FILIAL  = SC1.C1_FILIAL "
	cQuery += " AND SC7.C7_FORNECE = SC1.C1_FORNECE "
	cQuery += " AND SC7.C7_LOJA    = SC1.C1_LOJA "
	cQuery += " AND SC7.C7_NUMSC   = SC1.C1_NUM "
	cQuery += " AND SC7.C7_ITEMSC  = SC1.C1_ITEM "
    cQuery += " AND SC1.D_E_L_E_T_ = ' ' "  
    
    cQuery += " WHERE "
    cQuery += " 	SD1.D1_FILIAL =  '" + xFilial("SD1")+ "'"        
	cQuery += " AND SD1.D1_PEDIDO =  '" + cDoc + "' "
	cQuery += " AND SD1.D1_LOJA =    '" + cLoja + "' "
	cQuery += " AND SD1.D1_FORNECE = '" + cFornece + "' " 
	cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
 
	cQuery += " ORDER BY SD1.D1_DOC,SD1.D1_ITEM ASC"    

    MemoWrit('C:\TEMP\EST006.SQL',cQuery)
	
	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"
    
    TcSetField("TMP","D1_EMISSAO","D")  // Muda a data de Emissao de string para date    
    TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de digitaçao de string para date    

	TMP->(DBGotop())            
	If Empty(TMP->D1_DOC)
	   MsgBox("Atencao Pedido "+ cDoc +" Totalmente em Aberto","Atencao","STOP")
	   Return
	Endif               
	
	aHeader     := {}                       
	aCols       := {} 
	
	Aadd(aHeader,{"Nota"        , "D1_DOC"    ,"@!"               ,06,0,".F.","","C","SD1"})                   //01
	Aadd(aHeader,{"Serie"       , "D1_SERIE"  ,"@!"               ,03,0,".F.","","C","SD1"})                   //01
	Aadd(aHeader,{"Codigo"      , "D1_COD"    ,"@!"               ,15,0,".F.","","C","SD1"})                   //01
	Aadd(aHeader,{"Item"        , "D1_ITEM"   ,"@!"               ,04,0,".F.","","C","SD1"})                   //01	
    Aadd(aHeader,{"Produto"     , "D1_DESCRI",Repli("!",30)       ,30,0,".F.","","C","SD1"})                   //03
    Aadd(aHeader,{"Unid."       , "D1_UM"     ,"!!"               , 3,0,".F.","","C","SD1"})                   //04
    Aadd(aHeader,{"Quantidade"  , "D1_QUANT"  ,"@E 999,999.9999"  ,11,4,".F.","","N","SD1"})                   //05
    Aadd(aHeader,{"Vlr Unit"    , "D1_VUNIT"  ,"@E 999,999.9999"  ,10,3,".F.","","N","SD1"})                   //13
    Aadd(aHeader,{"Total"       , "D1_TOTAL"  ,"@E 999,999,999.99",12,2,".F.","","N","SD1"})//10
    Aadd(aHeader,{"Local"       , "D1_LOCAL"  ,"99"               , 2,0,".F.","","C","SD1"})                   //02
    Aadd(aHeader,{"Lote"        , "D1_LOTECTL" ,"@!"              ,10,0,".F.","","C","SD1"})                   //02
    Aadd(aHeader,{"Tipo Entrada", "D1_TES"     ,"@!"              , 3,0,".F.","","C","SD1"})                   //02
    Aadd(aHeader,{"Cod.Fiscal"  , "D1_CF"      ,"@!"              , 5,0,".F.","","C","SD1"})                   //02
	Aadd(aHeader,{"Solicitacao" , "C7_NUMSC"   ,"@!"              ,06,0,".F.","","C","SC7"})                   //01
	Aadd(aHeader,{"ItemSC"      , "C7_ITEMSC"  ,"@!"              ,02,0,".F.","","C","SC7"})                   //01
	Aadd(aHeader,{"Solicitante" , "C1_SOLICIT" ,"@!"              ,15,0,".F.","","C","SC1"})                   //01	
	Aadd(aHeader,{"Funcao"       , "RJ_DESC"    ,"@!"              ,20,0,".F.","","C","SRJ"})                   //01	
    
    TMP->(DBGotop())           
    QAA->(DbSetOrder(6))    
	
	While !TMP->(EOF())

	      QAA->(DbSeek(Upper(TMP->C1_SOLICIT)))
	      If QAA->(Found())
	     	  SRJ->(DbSeek(xFilial("SRJ")+QAA->QAA_CODFUN))
	    	  If SRJ->(Found())
	    	 	 _cFuncao := Subs(SRJ->RJ_DESC,1,20)
	    	  Endif
	      Endif


      Aadd(aCols,{TMP->D1_DOC,;      // Numero da nf
      				TMP->D1_SERIE,;      // codigo do produto
      				TMP->D1_COD,;      // codigo do produto
      				TMP->D1_ITEM,;      // numero do item
					   TMP->D1_DESCRI,;   // descricao do produto
					   TMP->D1_UM,;       // unidade do produto
					   TMP->D1_QUANT,;    // qtde do produto
					   TMP->D1_VUNIT,;    // valor unitario do produto
					   TMP->D1_TOTAL,;    // valor total do produto
					   TMP->D1_LOCAL,;    // local do produto
					   TMP->D1_LOTECTL,;  // lote do produto
					   TMP->D1_TES,;      // TES do produto
					   TMP->D1_CF,;       // Codigo fiscal do produto
					   TMP->C7_NUMSC,;    // Numero da solicitacao de compra
					   TMP->C7_ITEMSC,;   // Item da solicitacao de compra
					   TMP->C1_SOLICIT,;   //Solicitante
					   _cFuncao,;   //Funcao
                  .F. })        // controle de delecao .f.=nao deletado   .t.=deletado

      nVlrMer := nVlrMer + TMP->D1_TOTAL

      If Len(aCols) == 1                        
     		IF SF1->(DbSeek(xFilial("SF1")+TMP->D1_DOC+TMP->D1_SERIE+TMP->D1_FORNECE+TMP->D1_LOJA+TMP->D1_TIPO))
       		cHora   := Alltrim(SF1->F1_HORA)    
     		Endif
         cTipo   := TMP->D1_TIPO 
         cFornece:= TMP->D1_FORNECE+" - " +TMP->D1_LOJA+" "+TMP->A2_NOME
       	cTipoNF := aCombo1[aScan(aAuxCombo1,TMP->D1_TIPO)]
       	cPedido := TMP->D1_PEDIDO                           
       	dEmissao:= TMP->D1_EMISSAO 
       	dDigit  := TMP->D1_DTDIGIT

       	nQtdJE  := TMP->C7_QUJE
       	nQtdPed := TMP->C7_QUANT       
       	nQtdSal := TMP->C7_QUANT - TMP->C7_QUJE       
       	If nQtdSal > 0
       	   cSitPed := "Aberto"
       	Else                  
       	   cSitPed := "Fechado"
       	Endif 
      Endif            
      
      TMP->(dbSkip())                            
   Enddo

   If Len(aCols) == 0
      cTxtMsg := "Nao existe Nota Fiscal para os parametros informados"
      MsgBox(cTxtMsg,"Estoque","STOP")
      Return
   Endif
   
   @ 260,100 To 650,750 Dialog dlgnf Title "Consulta Nota Fiscal de Entrada"
   @ 012,007 Say "Pedido"          Size  45,08
   @ 012,065 Say OemToAnsi(cSitPed) Color CLR_BLUE Size 50,10 object oSitPed 
     oSitPed:SetFont(oFont)
   @ 012,100 Say "Fornecedor"      Size  40,08
   @ 027,007 Say "Emissao NF"      Size  45,08
   @ 027,095 Say "Digitacao NF"    Size  45,08
   @ 027,175 Say "Tipo"            Size  40,08
   @ 027,255 Say "Hora Entrada"    Size  40,08
   @ 157,007 Say "Qtde Pedido"     Size  60,08
   @ 157,220 Say "Total dos Itens" Size  60,08
   @ 172,007 Say "Qtde Entregue"   Size  60,08
   @ 187,007 Say "Saldo"           Size  60,08
   @ 010,030 Get cPedido           Size  30,10 When .F. Object oDoc    
   @ 010,130 Get cFornece          Size 150,10 When .F. Object oFornece
   @ 025,040 Get Dtoc(dEmissao)    Size  30,10 When .F. Object oEmissao
   @ 025,130 Get Dtoc(dDigit)      Size  30,10 When .F. Object oDigit
   @ 025,190 Get cTipoNF           Size  50,10 When .F. Object oTipoNF
   @ 025,290 Get cHora             Size  15,10 When .F. Object oHora
   @ 155,045 Get nQtdPed           Size  50,10 When .F. Picture "9,999,999,999.99" Object oQtdPed
   @ 155,260 Get nVlrMer           Size  50,10 When .F. Picture "9,999,999,999.99" Object oVlrMer
   @ 168,045 Get nQtdJE            Size  50,10 When .F. Picture "9,999,999,999.99" Object oQtdJE
   @ 183,045 Get nQtdSal           Size  50,10 When .F. Picture "9,999,999,999.99" Object oQtdSal
     oQtdSal:SetFont(oFont)  //Mostra fonte em negrito
   @ 045,006 To 150,320 MultiLine Modify Valid fRodPed()OBJECT oMultiline
//   @ 170,260 BmpButton Type 1 Action Close(dlgnf)
   @ 175,285 BmpButton Type 2 Action Close(dlgnf)
   oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
   Activate Dialog dlgnf Centered

Return         

Static Function fRodPed()
   
   SF1->(DbSetOrder(2))//filial + fornece + loja + doc     
   IF SF1->(DbSeek(xFilial("SF1")+Subs(cFornece,1,6)+Subs(cFornece,10,2)+aCols[n,1]))
      cHora   := Alltrim(SF1->F1_HORA)    
   Else
      cHora   := Space(05)
   Endif
   ObjectMethod(oHora, "Refresh()") //atualiza hora na tela        
   
   SD1->(DbSetOrder(1))//filial + fornece + loja + doc     
   IF SD1->(DbSeek(xFilial("SD1")+ aCols[n,1] + aCols[n,2] + Subs(cFornece,1,6)+Subs(cFornece,10,2)+aCols[n,3]+aCols[n,4]))
      SC7->(DbSetOrder(1))//filial + fornece + loja + doc     
      IF SC7->(DbSeek(xFilial("SC7")+ SD1->D1_PEDIDO + SD1->D1_ITEMPC))
    
         nQtdJE  := SC7->C7_QUJE
       	 nQtdPed := SC7->C7_QUANT       
       	 nQtdSal := SC7->C7_QUANT - SC7->C7_QUJE       
       	 If nQtdSal > 0
       	    cSitPed := "Aberto"
       	 Else                  
       	    cSitPed := "Fechado"
       	 Endif
         ObjectMethod(oQtdPed, "Refresh()")
         ObjectMethod(oQtdJE,  "Refresh()")         
         ObjectMethod(oQtdSal, "Refresh()")         
         oSitPed:SetFont(oFont)
         ObjectMethod(oSitPed, "Refresh()")                  
         dlgRefresh(dlgnf) 
      Endif                                                  
      
   Endif

Return(.T.)
