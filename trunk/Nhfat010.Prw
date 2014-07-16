/*/                   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT010 ³Autor  ³ Alexandre R. Bento    ³ Data ³ 11/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime Etiqueta de Codigo de Barras p/ PSA                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³ 	       "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"       ³±±
±±³          ³ 		  "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"        ³±±
±±³          ³ 02 nRow	  Numero da Linha em centimentros                 ³±±
±±³          ³ 03 nCol	  Numero da coluna em centimentros	              ³±±
±±³          ³ 04 cCode	  String com o conteudo do codigo                 ³±±
±±³          ³ 05 oPr	  Objeto Printer                                  ³±±
±±³          ³ 06 lcheck   Se calcula o digito de controle                ³±±
±±³          ³ 07 Cor 	  Numero  da Cor, utilize a "common.ch"           ³±±
±±³          ³ 08 lHort	  Se imprime na Horizontal                        ³±±
±±³          ³ 09 nWidth   Num do Tamanho da largura da barra em centimet ³±±
±±³          ³ 10 nHeigth  Numero da Altura da barra em milimetros        ³±±
±±³          ³ 11 lBanner  Se imprime o linha em baixo do codigo          ³±±
±±³          ³ 12 cFont	  String com o tipo de fonte                      ³±±
±±³          ³ 13 cMode	  String com o modo do codigo de barras CODE128   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±


/*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHFAT010()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,i,nqtde,netiq,nVol")   
Private cPerg := "FAT010"                                

_cArqDBF:=SPACE(12) 
nPbruto  :=  0
                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//AjustaSx1()

If Pergunte(cPerg,.T.)
	Processa({|| Gerando() }, "Etiqueta de Produto")
EndIf

// close cArq

If File( _cArqDBF )   
   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
Endif   

If SELECT("TMP") > 1
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

If SELECT("ETQ") > 1
	DbSelectArea("ETQ")
	DbCloseArea()
EndIf

//Close TMP
//Close ETQ 
Return

Static Function Gerando()
   
   cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,B1.B1_CODAP5,A1.A1_NOME,A1.A1_END,A1.A1_MUN" 
   cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1,"+ RetSqlName( 'SA1' ) +" A1 "   
   cQuery += " WHERE D2.D2_DOC BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "                                                                                                        
   cQuery += " AND D2.D2_SERIE BETWEEN '" + Mv_par05 + "' AND '" + Mv_par06 + "' "  
   cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE"
   cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
   cQuery += " AND B1.B1_COD = D2.D2_COD"   
   cQuery += " AND D2.D2_CLIENTE = A1.A1_COD"      
   cQuery += " AND D2.D2_LOJA = A1.A1_LOJA"         
   cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ =  ' '" 
   cQuery += " AND A1. D_E_L_E_T_ = ' '"    
   cQuery += " ORDER BY D2.D2_DOC ASC"    
 
 MemoWrit('C:\TEMP\fat010.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

Processa( {|| RptDetail() }, "Aguarde Gerando Arquivo de Etiquetas...")

Return


Static Function RptDetail()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando Arquivo Temporario para posterior impressao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqDBF  := CriaTrab(NIL,.f.)
_cArqDBF += ".DBF"
_aFields := {}

AADD(_aFields,{"OK"      ,"C", 02,0})         // Controle do browse
AADD(_aFields,{"LOCAL"   ,"C", 12,0})         // Local de Utilizacao
AADD(_aFields,{"NOTA"    ,"C", 9,0})         // Numero da Nota
AADD(_aFields,{"EMITENTE","C",32,0})         // Nome do Emitente
AADD(_aFields,{"PLIQUI"  ,"C",06,0})         // Peso Liquido
AADD(_aFields,{"PBRUTO"  ,"C",06,0})         // Peso Bruto
AADD(_aFields,{"CAIXA",   "C",05,0})         // Qtde de caixas em palletes ou rack = UM = Unidade de Manuseio
AADD(_aFields,{"PRODUTO", "C",20,0})         // Codigo do Produto
AADD(_aFields,{"QUANT",   "C",09,0})         // Quantidade do Produto
AADD(_aFields,{"DESC",    "C",22,0})         // Descricao do Produto
AADD(_aFields,{"REFFOR",  "C",22,0})         // Referencia do Fornecedor
AADD(_aFields,{"FORNECE", "C",10,0})         // Codigo do fornecedor
AADD(_aFields,{"DTA",     "C",09,0})         // Data
AADD(_aFields,{"MODIFI",  "C",14,0})         // Indice de modificacao do produto ex. Versao 004
AADD(_aFields,{"ETIQ",    "C",09,0})         // Numero da etiqueta tem que ser seguqncial por um ano (MV_ETQ)
AADD(_aFields,{"LOTE",    "C",12,0})         // Numero do Lote
AADD(_aFields,{"DESTINO", "C",65,0})         // Nome do destinatario
AADD(_aFields,{"EMBALA",  "C",02,0})         // Embalagem = UC = unidade de condicionamento
AADD(_aFields,{"SEGU",    "C",01,0})         // Peca de seguranca

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"ETQ",.F.)

TMP->(DBGotop())            
ProcRegua(TMP->(RecCount())) 

While !TMP->(EOF())
	
   nEtiq := Val(GetMv("MV_ETQ")) //Pega o qtde de etq que já foram enviadas
   nQtde := TMP->D2_QUANT //Pega a qtde do item para calculo do peso
   If TMP->D2_CLIENTE$'900141/000147/900003' .And. TMP->D2_LOJA$'03/01/02'
      nVol  := TMP->C5_VOLUME1 //qtde de volumes cx de cabeçotes           
   Else 
      nVol  := TMP->C5_VOLUME1 * 2 //qtde de volumes de cx p/ frança            
   Endif   
   For i := 1 to nVol //qtde de volumes           
      nEtiq++
	   IncProc("Gerando Arquivo Etiquetas")
	   RecLock("ETQ",.T.)             
	     ETQ->OK        := Space(02)     
		  ETQ->LOCAL     := "  " //Doca de entrega
		  ETQ->NOTA      := TMP->D2_DOC     
		  IF SM0->M0_CODIGO == "NH"  //empresa WHB
		     ETQ->EMITENTE  := "WHB COMP. AUT. S/A CURITIBA-PR"       
		  Elseif SM0->M0_CODIGO == "FN"  //empresa Fundicao
		     ETQ->EMITENTE  := "WHB FUNDICAO S/A CURITIBA-PR"       		  
		  Endif   
	  
		  // Cada pallet fechado vai 50 cabecotes
        /*
        If nQtde > 50
           ETQ->QUANT  := "50"       
           ETQ->PLIQUI := Transform((TMP->B1_PESO * 50),"@e 9999.99") 
           nQtde := nQtde - 50
        Else
           ETQ->QUANT :=  Transform(nQtde,"@E 999999999")
           ETQ->PLIQUI := Transform((TMP->B1_PESO * nQtde),"@e 9999.99") 
        Endif
          */               
          // ALERT(mv_par04)
		  ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + mv_par04,"@E 9999.99")
		  ETQ->CAIXA     := Transform(1,"@E 99999")
		  ETQ->PRODUTO   := TMP->B1_CODAP5                    
		  ETQ->DESC      := Subs(TMP->C6_DESCRI,1,22)      
		  IF SM0->M0_CODIGO == "NH"  //empresa WHB		  
		     ETQ->REFFOR    := "15129UB0" //TMP->D2_CLIENTE + "  "+TMP->D2_LOJA
   		     ETQ->FORNECE   := "15129UB0" //TMP->D2_CLIENTE + "  "+TMP->D2_LOJA
   		  Elseif SM0->M0_CODIGO == "FN"  //empresa WHB	
		     ETQ->REFFOR    := "15822X0101" //TMP->D2_CLIENTE + "  "+TMP->D2_LOJA
   		     ETQ->FORNECE   := "15822X0101" //TMP->D2_CLIENTE + "  "+TMP->D2_LOJA
   		  Endif   
	      ETQ->DTA       := "P"+TMP->D2_EMISSAO
		  ETQ->MODIFI    := Space(14)               
  	      ETQ->ETIQ      := StrZero(nEtiq,9) //,"@e 999999999")
		  ETQ->LOTE      := Space(12)      
//		  IF TMP->D2_CLIENTE == '900141' .And. TMP->D2_LOJA == '03'
	      If TMP->D2_CLIENTE$'900141/000147' .And. TMP->D2_LOJA$'03/01'
		     ETQ->DESTINO   := "PSA PEUGEOT CITROEN DO BRASIL 27570-000 PORTO REAL-RJ 7828M"
		    // Cada pallet fechado vai 50 cabecotes       
		    // Cada pallet fechado vai 144 
		   // mv_par03 qtde por pallet       
		     If nQtde > mv_par03
		        ETQ->QUANT  := Transform(mv_par03,"@E 9999") // Val(StrZero(mv_par03,3))       
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * mv_par03),"@e 9999.99") 
		        nQtde := nQtde - mv_par03
		     Else
		        ETQ->QUANT :=  Transform(nQtde,"@E 999999999")
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * nQtde),"@e 9999.99") 
		     Endif                   
		     //160 PESO da embalagem		                
		     // 88 PESO a embalagem   
		     //mv_par04 peso bruto da embalagem
		     ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + mv_par04,"@E 9999.99")
		  Else //Nota de saida para frança
		     ETQ->DESTINO   := Subs(TMP->A1_NOME,1,29)+ALLTRIM(subs(TMP->A1_END,1,30))+Space(01)+Alltrim(TMP->A1_MUN)
//		     ETQ->DESTINO   := "PEUGEOT CITROEN AUTOMOBILES  78091 YVELINES CEDEX 9 FRANCE    "		  		     
		     // Cada pallet fechado vai 90 pares (admissao e escape) Peças
		     If nQtde > mv_par03
		        ETQ->QUANT  := StrZero(mv_par03,3)       
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * mv_par03),"@e 9999.99") 
		        nQtde := nQtde - mv_par03
		     Else
		        ETQ->QUANT :=  Transform(nQtde,"@E 999999999")
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * nQtde),"@e 9999.99") 
		     Endif 
		     //37.8 PESO da embalagem
             ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + mv_par04,"@E 9999.99")		     
		     
		  Endif   
		  ETQ->EMBALA    := Space(02)
		  ETQ->SEGU      := Space(01)

	   MsUnlock("ETQ")
	   
	Next i
	   
	TMP->(DbSkip())
	
EndDo

cMarca  := GetMark()
aCampos := {}   

Aadd(aCampos,{"OK"        ,"OK"        ,"@!"})
//Aadd(aCampos,{"LOCAL"     ,"Local"     , "@!"})
Aadd(aCampos,{"ETIQ"      ,"Nr.Etiq"   , "@!"})
Aadd(aCampos,{"NOTA"      ,"Nota"      , "@!"})
Aadd(aCampos,{"DTA"       ,"Data"      , "@!"})
//Aadd(aCampos,{"EMITENTE"  ,"Emitente"  , "@!"})
//Aadd(aCampos,{"PLIQUI"    ,"P.Liquido" , "@!"})
//Aadd(aCampos,{"PBRUTO"    ,"P.Bruto"   , "@!"})
//Aadd(aCampos,{"CAIXA"     ,"Qtde Cx"   , "@!"})
Aadd(aCampos,{"PRODUTO"   ,"Produto"   , "@!"})
Aadd(aCampos,{"DESC"      ,"Decricao"  , "@!"})
Aadd(aCampos,{"QUANT"     ,"Quant"     , "@!"})
//Aadd(aCampos,{"REFFOR"    ,"Referencia", "@!"}) 
Aadd(aCampos,{"FORNECE"   ,"Fornecedor", "@!"}) 
//Aadd(aCampos,{"DTA"      ,"Data"      , "@!"})
//Aadd(aCampos,{"MODIFI"    ,"Ind.Modif" , "@!"})
//Aadd(aCampos,{"LOTE"      ,"Lote"      , "@!"})
Aadd(aCampos,{"DESTINO"   ,"Destino"   , "@!"})
//Aadd(aCampos,{"EMBALA"    ,"Emb"       , "@!"})
//Aadd(aCampos,{"SEGU"      ,"Segura"    , "@!"})

ETQ->(DbGoTop())

@ 50,1 TO 555,600 DIALOG oDlg TITLE "Emissao de Etiquetas"

@ 6,5 TO 250,255 BROWSE "ETQ"
@ 6,5 TO 250,255 BROWSE "ETQ" FIELDS aCampos MARK "OK"
@ 50,258 BUTTON "_Imprimir"  SIZE 40,15 ACTION ImpEtiq()
@ 70,258 BUTTON "_Cancelar"  SIZE 40,15 ACTION fDlg()
ACTIVATE DIALOG oDlg CENTERED
               
Return

Static Function fDlg()
    
   Close(oDlg)
Return

Static Function ImpEtiq()

// A fonte para impressao das embalagens pode ser usado as seguintes:
// Arial
// Helvetica negrito
// Times New Roman negrito

	Local aEtiq := {}
    Local nWidth  := 0.0330 //Comprimento do cod.de barras (centimetros)                    
	Local nHeigth := 0.991  //Largura do cod.de barras (milimetros)
//	Local nLinBar := 3.0  //Linha inicial do cod. de barras da etiqueta
//	Local nWidth  := 9.7 //Comprimento do cod.de barras (centimetros)                    
//	Local nHeigth := 1.3  //Largura do cod.de barras (milimetros)//
//
	Local nLinBar := 1.0  //Linha inicial do cod. de barras da etiqueta
	Local nLinTex := 200  //240
	Local nColBar := 1  //Coluna Inicial do cod. de barras
	Local nColTex := 0  //Coluna Inicial do texto da etiqueta
	Local nColAtu := 1  //Numero de colunas da impressas
	Local nLinAtu := 1  //Numero de linhas impressas
	Local nAjust  := 1                       
	
	oFont10  := TFont():New("Arial",,10,,.F.)
	oFont12  := TFont():New("Arial",,12,,.F.)
	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()

	SX6->(DbSeek(xFilial('SX6')+"MV_ETQ"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= Strzero(nEtiq,6) //Grava numero final da etiqueta
	MsUnlock("SX6")

ProcRegua(ETQ->(RecCount()))

ETQ->(DbGoTop())
 
_nSeq := 1 //numero sequencial da etiqueta

While !ETQ->(eof())    

   If MARKED("OK")
      
  	  IncProc("Imprimindo Etiqueta PSA")

		oPr:Line(010,020,010,2350) // Horizontal 1º linha
		oPr:Line(0010,1200,570,1200) // vertical
	  	oPr:Say(040,0050,OemtoAnsi("Destinatário"), oFont12)
		oPr:Say(040,1210,OemtoAnsi("Local de Utilização"), oFont12)

//	  	oPr:Say(110,0050,OemtoAnsi("PSA PEUGEOT CITROEN DO BRASIL"), oFont16N)
//	  	oPr:Say(160,0050,OemtoAnsi("27570-000 PORTO REAL - RJ  7828M"), oFont16N)

		oPr:Say(110,0050,Substr(ETQ->DESTINO,1,29), oFont14N) //////XXXXXXXXX
	  	oPr:Say(160,0050,Substr(ETQ->DESTINO,30,35),oFont14N)
		oPr:Line(240,050,240,2350) // Horizontal 2º linha
		oPr:Say(270,0050,OemtoAnsi("Nº da Nota Fiscal"), oFont12)  	
		oPr:Say(250,1210,OemtoAnsi("Endereço do Expedidor"), oFont12)  	
		oPr:Say(350,0060,OemtoAnsi(ETQ->NOTA), oFont18N)  		
		oPr:Say(310,1210,OemtoAnsi(ETQ->EMITENTE), oFont16N)
		oPr:Line(390,1200,390,2350) // Horizontal 3º linha            
		oPr:Say(420,1210,OemtoAnsi("Peso Liquido (Kg)"), oFont12)
		oPr:Line(0390,1570,570,1570) // vertical	
		oPr:Say(420,1620,OemtoAnsi("Peso Bruto (Kg)"), oFont12)	
		oPr:Line(0390,1950,570,1950) // vertical		
		oPr:Say(420,2000,OemtoAnsi("Nº de Caixas"), oFont12)
		oPr:Say(500,1250,OemtoAnsi(ETQ->PLIQUI), oFont16N)
		oPr:Say(500,1670,OemtoAnsi(ETQ->PBRUTO), oFont16N)	
		oPr:Say(500,2050,OemtoAnsi(ETQ->CAIXA), oFont16N)
		oPr:Line(0570,0050,0570,2350) // Horizontal 4º linha            	
		oPr:Line(0600,0050,0600,2350) // Horizontal 5º linha            		
		oPr:Say(0630,0050,OemtoAnsi("Nº do Produto (P)"), oFont12)  		
		oPr:Say(0620,0500,OemtoAnsi(Alltrim(ETQ->PRODUTO)), oFont18N)
//	    MSBAR("CODE3_9",3.6,0.5,Alltrim(ETQ->PRODUTO),oPr,.F., ,.T.,0.0194,0.6,NIL,oFont18N,"CODE3_9",.F.) //imprime cod. de barra do produto		
//	    MSBAR("CODE3_9",3.0,0.5,UPPER("P")+Alltrim(ETQ->PRODUTO),oPr,.F., ,.T.,     0.0194,0.6,NIL,NIL,NIL      ,.F.,,,.F.) //imprime cod. de barra do produto
// 	    MSBAR("CODE3_9",6.5,1.0,UPPER("P")+Alltrim(ETQ->PRODUTO),oPr,NIL,   NIL,NIL,0.0424,1.2,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra	    
		MSBAR("CODE3_9",6.0,1.0,UPPER("P")+Alltrim(ETQ->PRODUTO),oPr,.F., ,.T.  ,0.0424,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto

//	  	 3.5 = LINHA
//       1.5 = COLUNA
//       0.0594 = ESPACO
//       5.0 = ALTURA
	  	oPr:Line(0910,0050,0910,2350) // Horizontal 6º linha            		
		oPr:Say(0930,0050,OemtoAnsi("Quantidade (Q)"), oFont12)  	
		oPr:Say(0930,1230,OemtoAnsi("Produto"), oFont12)  	
		oPr:Line(0910,1200,1810,1200) // vertical qtde |produto

		oPr:Say(0970,0600,OemtoAnsi(ETQ->QUANT), oFont18N)  	
		oPr:Say(1000,1230,OemtoAnsi(ETQ->DESC), oFont12N)  	
		oPr:Line(1050,1200,1050,2350) // Horizontal 7º linha            
	    oPr:Say(1070,1230,OemtoAnsi("Ref. Fornecedor (30S)"), oFont12)  		
		oPr:Say(1130,1230,OemtoAnsi(ETQ->FORNECE), oFont18N)  	   
//      MSBAR("CODE3_9",5.0,0.5,ETQ->QUANT ,oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFont18N,"CODE3_9",.F.) //imprime cod. de barra da qtde
//      MSBAR("CODE3_9",4.4,0.5,UPPER("Q")+OemToAnsi(ETQ->QUANT),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do produto        
// 	    MSBAR("CODE3_9",9.3,1.0,UPPER("Q")+OemToAnsi(ETQ->QUANT),oPr,NIL,   NIL,NIL,0.0394,1.2,NIL,oFont18N,"CODE3_9",.F.) //imprime cod. de barra	    
		MSBAR("CODE3_9",4.4,1.0,UPPER("Q")+OemToAnsi('10'),oPr,.F., ,.T.  ,0.0394,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto		

		oPr:Line(1250,0020,1250,1200) // Horizontal 8º linha              	                       
		oPr:Say(1280,0050,OemtoAnsi("Fornecedor (V)"), oFont12)    	
		oPr:Say(1270,0350,OemtoAnsi(ETQ->FORNECE), oFont16N)    		       
		oPr:Line(1370,1200,1370,2350) // Horizontal 9º linha            
		oPr:Say(1390,1230,OemtoAnsi("Data"), oFont12)
		oPr:Line(1370,1650,1510,1650) // vertical	data | indice de modificação
		oPr:Say(1390,1700,OemtoAnsi("Indice de Modificação"), oFont12)    	
		oPr:Say(1440,1230,OemtoAnsi(ETQ->DTA), oFont16N)    		       
	
//		MSBAR("CODE3_9",5.5,0.5,UPPER("V")+OemToAnsi(ETQ->FORNECE),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.) //imprime cod. de barra do fornecedor
// 	    MSBAR("CODE3_9",11.8,1.0,UPPER("V")+OemToAnsi(ETQ->FORNECE),oPr,NIL,   NIL,NIL,0.0394,1.2,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra	    
		MSBAR("CODE3_9",11.0,1.0,UPPER("V")+OemToAnsi(ETQ->FORNECE),oPr,.F., ,.T.  ,0.0394,1.2,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra correto

	  	oPr:Line(1510,0050,1510,2350) // Horizontal 10º linha            	
		oPr:Say(1530,0050,OemtoAnsi("Nº da Etiqueta (S)"), oFont12)    		
		oPr:Say(1530,0420,OemtoAnsi(ETQ->ETIQ), oFont14N)
		MSBAR("CODE3_9",13.0,1.0,UPPER("S")+OemToAnsi(ETQ->ETIQ),oPr,.F., ,.T.  ,0.0394,1.2,NIL,NIL,NIL,.F.,,,.F.)
		
		oPr:Say(1530,1230,OemtoAnsi("Nº Seq."), oFont12)    	    		
		oPr:Say(1530,1500,TRANSFORM(_nSeq,"@e 999999999"), oFont14N)    		
		MSBAR("CODE3_9",13.0,12,TRANSFORM(_nSeq,"@e 999999999"),oPr,.F., ,.T.  ,0.0394,1.2,NIL,NIL,NIL,.F.,,,.F.)

		oPr:Say(1760,0070,OemtoAnsi(ETQ->EMITENTE), oFont10)    	    		  	
		oPr:Line(1810,0050,1810,2350) // Horizontal 11º linha            	
		oPr:Line(1840,0050,1840,2350) // Horizontal 12º linha            		
		oPr:Say(1870,0050,OemtoAnsi("Nº da Etiqueta (S)"), oFont12)    	    		  	  	
		oPr:Say(1870,0420,OemtoAnsi(ETQ->ETIQ), oFont14N)	
	 	oPr:Say(1870,1230,OemtoAnsi("Nº do Produto"), oFont12)    		
		oPr:Say(1920,1230,OemtoAnsi(ETQ->PRODUTO), oFont16N)               
		oPr:Line(2060,1200,2060,2350) // Horizontal 13º linha            
//		MSBAR("CODE3_9",8.0,0.5,UPPER("S")+OemToAnsi(ETQ->ETIQ),oPr,.F., ,.T.,0.0194,0.6,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barra c/ numero da etq  	
// 	    MSBAR("CODE3_9",17.0,1.0,UPPER("S")+OemToAnsi(ETQ->ETIQ),oPr,NIL,   NIL,NIL,0.0394,1.2,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra	    
		MSBAR("CODE3_9",15.9,1.0,UPPER("S")+OemToAnsi(ETQ->ETIQ),oPr,.F., ,.T.  ,0.0394,1.2,NIL,NIL,NIL,.F.,,,.F.)

		oPr:Say(2110,0070,OemtoAnsi(ETQ->EMITENTE), oFont10)    	    		  	
		oPr:Line(1840,1200,2420,1200) // vertical	Nº da etq | indice de modificação    	                                                                              
	 	oPr:Say(2070,1230,OemtoAnsi("Produto"), oFont12)    		
		oPr:Say(2120,1230,OemtoAnsi(ETQ->DESC), oFont16N)      
		oPr:Line(2220,1200,2220,2350) // Horizontal 13º linha            
	 	oPr:Say(2250,1230,OemtoAnsi("Quantidade (Q)"), oFont12)    		
		oPr:Say(2300,1300,OemtoAnsi(ETQ->QUANT), oFont16N)               

	 	oPr:Say(2250,1600,OemtoAnsi("Fornecedor (V)"), oFont12)    		
		oPr:Say(2300,1600,OemtoAnsi(ETQ->FORNECE), oFont16N)               
		
	 	oPr:Say(2250,2000,OemtoAnsi("Data"), oFont12)    		
		oPr:Say(2300,2000,OemtoAnsi(ETQ->DTA), oFont16N)               
 
	 	oPr:Line(2220,1580,2420,1580) // vertical	
		oPr:Line(2220,1980,2420,1980) // vertical		
	  
   EndIf
   ETQ->(DbSkip())
   If !Empty(ETQ->NOTA)
	    oPr:EndPage()
	    oPr:StartPage()
	Endif 
	
	_nSeq ++   
EndDo    

oPr:Preview()
oPr:End()

Close(oDlg)

MS_FLUSH()
Return


Static Function AlterQtd()

cProd := ETQ->ETQ_CODIGO
nQTDE := ETQ->ETQ_QUANT

@ 50,1 TO 190,390 DIALOG oDlg1 TITLE "Alteracao de Quantidade"

@ 6,5 TO 40,90 TITLE "Produto"
@ 20,10 SAY cProd
@ 6,100 TO 40,190 TITLE "Quantidade"
@ 20,120 GET nQTDE PICTURE "@E 999,999,999" SIZE 50,80 OBJECT oEdit
@ 56,60 BMPBUTTON TYPE 1 ACTION (Close(oDlg1),AtuEst())
@ 56,100 BMPBUTTON TYPE 2 ACTION Close(oDlg1)                       
oEdit:Refresh()

ACTIVATE DIALOG oDlg1 CENTERED

Return

   

Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
 
cPerg   := "FAT010"

aRegs   := {}


//
//               G        O    P                     P                     P                     V        T   T  D P G   V  V          D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  V  D  D  D  C  F  G
//               R        R    E                     E                     E                     A        I   A  E R S   A  A          E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  A  E  E  E  N  3  R
//               U        D    R                     R                     R                     R        P   M  C E C   L  R          F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  R  F  F  F  T  |  P
//               P        E    G                     S                     E                     I        O   A  I S |   I  0          0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  0  0  S  E  0  |  S
//               O        M    U                     P                     N                     A        |   N  M E |   D  1          1  P  N  1  2  2  P  N  2  3  3  P  N  3  4  4  P  N  4  5  5  P  N  5  |  X
//               |        |    N                     A                     G                     V        |   H  A L |   |  |          |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  |  A  G  |  |  G
//               |        |    T                     |                     |                     L        |   O  L | |   |  |          |  1  1  |  |  |  2  2  |  |  |  3  3  |  |  |  4  4  |  |  |  5  5  |  |  |
//               |        |    |                     |                     |                     |        |   |  | | |   |  |          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
aadd(aRegs,{cPerg,"01","Nota Inicial       ?","Nota Inicial       ?","Nota Inicial       ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Nota Final         ?","Nota Final         ?","Nota Final         ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Qtde por Pallet    ?","Qtde por Pallet    ?","Qtde por Pallet    ?","mv_ch3","N",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Peso Bruto Embalage?","Peso Bruto Embalage?","Peso Bruto Embalage?","mv_ch4","N",07,3,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","Serie Inicial      ?","Serie Inicial      ?","Serie Inicial      ?","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Serie Final        ?","Serie Final        ?","Serie Final        ?","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
cUltPerg := aRegs[Len(aRegs)][2]

If !SX1->(DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->(!EOF()) .AND. SX1->X1_Grupo == cPerg
      RecLock('SX1')
	SX1->(DbDelete())
	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf

dbSelectArea(_sAlias)

Return
                                                                      
///****************

