/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT021 ³Autor  ³ Marcos R. Roquitski   ³ Data ³ 11/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime Etiqueta de Codigo de Barras p/ PSA                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³ 	       "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"         ³±±
±±³          ³ 		  "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"         ³±±
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


User Function NHFAT021()

SetPrvt("_cArqDbf, cQuery,_aFields,aCampos,cMarca,cNovaLinha,cARQEXP ,cARQ,nPbruto,i,nqtde,netiq,nVol")   
Private cPerg := "FAT010"                             

//-----------------------------------------------------------------------------------------------------
//  verifica se tem o bmp para impressao.
//-----------------------------------------------------------------------------------------------------
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

If !File(cStartPath+"IMG003.BMP")
	MsgAlert("Bitmaps nao encontrados, baixar arquivo do FTP !","Atencao !")
	Return Nil
Endif

   

_cArqDBF:=SPACE(12) 
nPbruto  :=  0
                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Nota ?                                    ³
//³ mv_par02     // Ate a Nota ?                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//AjustaSx1()

If Pergunte(cPerg,.T.)
	Processa({|| Gerando2() }, "Etiqueta de Produto")

	If File( _cArqDBF )   
	   fErase(_cArqDBF)  // Deleta arquivo de dados temporario
	Endif   

	DbSelectArea("TMP")
	DbCloseArea()

	DbSelectArea("ETQ")
	DbCloseArea()

Endif 
Return

Static Function Gerando2()
   
   cQuery := "SELECT D2.D2_DOC,D2.D2_COD,D2.D2_EMISSAO,D2.D2_QUANT,D2.D2_CLIENTE,D2.D2_LOJA,B1.B1_PESO,C5.C5_PBRUTO,C5.C5_VOLUME1,C6.C6_DESCRI,B1.B1_CODAP5,A1.A1_NOME,A1.A1_END,A1.A1_MUN"
   cQuery += " FROM " +  RetSqlName( 'SD2' ) +" D2, " +  RetSqlName( 'SC5' ) +" C5, "+ RetSqlName( 'SC6' ) +" C6, "+ RetSqlName( 'SB1' ) +" B1,"+ RetSqlName( 'SA1' ) +" A1 "   
   cQuery += " WHERE D2.D2_DOC BETWEEN '" + Mv_par01 + "' AND '" + Mv_par02 + "' "                                                                                                        
   cQuery += " AND C5.C5_NOTA = D2.D2_DOC AND C5.C5_SERIE = D2.D2_SERIE"
   cQuery += " AND C6.C6_NOTA = D2.D2_DOC AND C6.C6_SERIE = D2.D2_SERIE"
   cQuery += " AND B1.B1_COD = D2.D2_COD"   
   cQuery += " AND D2.D2_CLIENTE = A1.A1_COD"      
   cQuery += " AND D2.D2_LOJA = A1.A1_LOJA"         
   cQuery += " AND D2. D_E_L_E_T_ = ' ' AND C5. D_E_L_E_T_ = ' ' AND C6. D_E_L_E_T_ = ' ' AND B1. D_E_L_E_T_ =  ' '" 
   cQuery += " AND A1. D_E_L_E_T_ = ' '"    
   cQuery += " ORDER BY D2.D2_DOC ASC"    
 
 MemoWrit('C:\TEMP\fat021.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")

Processa( {|| RptDe2() }, "Aguarde Gerando Arquivo de Etiquetas...")

Return


Static Function RptDe2()

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
AADD(_aFields,{"DTA",   "C",09,0})         // Data
AADD(_aFields,{"MODIFI",  "C",14,0})         // Indice de modificacao do produto ex. Versao 004
AADD(_aFields,{"ETIQ",    "C",09,0})         // Numero da etiqueta tem que ser seguqncial por um ano (MV_ETQ)
AADD(_aFields,{"LOTE",    "C",12,0})         // Numero do Lote
AADD(_aFields,{"DESTINO", "C",65,0})         // Nome do destinatario
AADD(_aFields,{"EMBALA",  "C",02,0})         // Embalagem = UC = unidade de condicionamento
AADD(_aFields,{"SEGU",    "C",01,0})         // Peca de seguranca


AADD(_aFields,{"NOME",    "C",30,0})         // Peca de seguranca
AADD(_aFields,{"ENDE",    "C",30,0})         // Peca de seguranca
AADD(_aFields,{"MUN",     "C",30,0})         // Peca de seguranca

DbCreate(_cArqDBF,_aFields)
DbUseArea(.T.,,_cArqDBF,"ETQ",.F.)

TMP->(DBGotop())            
ProcRegua(TMP->(RecCount()))
While !TMP->(EOF())
	
   nEtiq := Val(GetMv("MV_ETQ")) //Pega o qtde de etq que já foram enviadas
   nQtde := TMP->D2_QUANT //Pega a qtde do item para calculo do peso
   If TMP->D2_CLIENTE == '900141' .And. TMP->D2_LOJA == '03'
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
		  ETQ->EMITENTE  := "WHB COMP. AUT. S/A CURITIBA-PR" 
		  
		  ETQ->NOME := TMP->A1_NOME
  		  ETQ->ENDE := TMP->A1_END
		  ETQ->MUN  := TMP->A1_MUN
	  
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
		  ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + 160,"@E 9999.99")
		  ETQ->CAIXA     := Transform(1,"@E 99999")
		  ETQ->PRODUTO   := TMP->B1_CODAP5
		  ETQ->DESC      := " " //TMP->B1_DESCFRA
		  ETQ->REFFOR    := "15129UB0B0" //TMP->D2_CLIENTE + "  "+TMP->D2_LOJA
		  ETQ->FORNECE   := "15129UB0B0" //TMP->D2_CLIENTE + "  "+TMP->D2_LOJA
	      ETQ->DTA       := "P"+TMP->D2_EMISSAO
		  ETQ->MODIFI    := Space(14)               
  	      ETQ->ETIQ      := StrZero(nEtiq,9) //,"@e 999999999")
		  ETQ->LOTE      := Space(12)      

		  IF TMP->D2_CLIENTE == '900141' .And. TMP->D2_LOJA == '03'
		     ETQ->DESTINO   := " "//TMP->B1_ENDENT
		    // Cada pallet fechado vai 50 cabecotes
		     If nQtde > 50
		        ETQ->QUANT  := "50"       
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * 50),"@e 9999.99") 
		        nQtde := nQtde - 50
		     Else
		        ETQ->QUANT :=  Transform(nQtde,"@E 999999999")
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * nQtde),"@e 9999.99") 
		     Endif                   
		     //160 PESO da embalagem		     
		     ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + 160,"@E 9999.99")
		  Else //Nota de saida para frança
		     ETQ->DESTINO   := " " //TMP->B1_ENDENT
		     // Cada pallet fechado vai 90 pares (admissao e escape) Peças
		     If nQtde > 168
		        ETQ->QUANT  := "168"       
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * 168),"@e 9999.99") 
		        nQtde := nQtde - 168
		     Else
		        ETQ->QUANT :=  Transform(nQtde,"@E 999999999")
		        ETQ->PLIQUI := Transform((TMP->B1_PESO * nQtde),"@e 9999.99") 
		     Endif 
		     //37.8 PESO da embalagem
             ETQ->PBRUTO    := Transform(Val(ETQ->PLIQUI) + 18.9,"@E 9999.99")		     
		     
		  Endif   
		  ETQ->EMBALA    := Space(02)
		  ETQ->SEGU      := Space(01)

	   MsUnlock("ETQ")
	   
	Next i
	   
	SX6->(DbSeek(xFilial()+"MV_ETQ"))
      RecLock("SX6",.F.)
	      SX6->X6_CONTEUD:= ETQ->ETIQ
	   MsUnlock()

   
	TMP->(DbSkip())
	
EndDo

cMarca  := GetMark()
aCampos := {}   

Aadd(aCampos,{"OK"        ,"OK"        ,"@!"})
Aadd(aCampos,{"ETIQ"      ,"Nr.Etiq"   , "@!"})
Aadd(aCampos,{"NOTA"      ,"Nota"      , "@!"})
Aadd(aCampos,{"DTA"       ,"Data"      , "@!"})
Aadd(aCampos,{"PRODUTO"   ,"Produto"   , "@!"})
Aadd(aCampos,{"DESC"      ,"Decricao"  , "@!"})
Aadd(aCampos,{"QUANT"     ,"Quant"     , "@!"})
Aadd(aCampos,{"FORNECE"   ,"Fornecedor", "@!"}) 
Aadd(aCampos,{"DESTINO"   ,"Destino"   , "@!"})

ETQ->(DbGoTop())

@ 50,1 TO 555,600 DIALOG oDlg TITLE "Emissao de Etiquetas"

@ 6,5 TO 250,255 BROWSE "ETQ"
@ 6,5 TO 250,255 BROWSE "ETQ" FIELDS aCampos MARK "OK"
@ 50,258 BUTTON "_Imprimir"  SIZE 40,15 ACTION ImpEtiq()
@ 70,258 BUTTON "_Cancelar"  SIZE 40,15 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED
               
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
	oFont18  := TFont():New("Arial",,18,,.F.)
	oFont22  := TFont():New("Arial",,22,,.F.)
	oFont34  := TFont():New("Arial",,34,,.F.)
	oFont44  := TFont():New("Arial",,44,,.F.)

	oFont12N := TFont():New("Arial",,12,,.T.)                  
	oFont14N := TFont():New("Arial",,14,,.T.)	
	oFont16N := TFont():New("Arial",,16,,.T.)
	oFont18N := TFont():New("Arial",,18,,.T.)
	oPr:= tAvPrinter():New("Protheus")
	oPr:StartPage()

   
ProcRegua(ETQ->(RecCount()))

ETQ->(DbGoTop())


While !ETQ->(eof())    


   If MARKED("OK")
      
  	  IncProc("Imprimindo Etiqueta PSA")

		oPr:Line(020,020,020,2350) // Horizontal 1º linha
		oPr:Line(0020,1200,570,1200) // vertical
	  	oPr:Say(040,0050,OemtoAnsi("Destinataire"), oFont12)
		oPr:Say(070,0050,OemtoAnsi(ETQ->NOME), oFont18)
	  	oPr:Say(120,0050,OemtoAnsi(ETQ->ENDE), oFont18)
	  	oPr:Say(170,0050,OemtoAnsi(ETQ->MUN),  oFont18)

		oPr:Say(040,1210,OemtoAnsi("Lieu de Livraison"), oFont12)
		oPr:Say(110,0050,Substr(ETQ->DESTINO,1,29), oFont18)
	  	oPr:Say(160,0050,Substr(ETQ->DESTINO,30,35),oFont18)

		oPr:Line(240,050,240,2350) // Horizontal 2º linha
		oPr:Say(270,0050,OemtoAnsi("Nº document"), oFont12)
		oPr:Say(250,1210,OemtoAnsi("Adresse expediteur"), oFont12)
		oPr:Say(350,0060,OemtoAnsi(ETQ->NOTA), oFont22)
		oPr:Say(310,1210,OemtoAnsi(ETQ->EMITENTE), oFont18)
	
		oPr:Line(390,1200,390,2350) // Horizontal 3º linha
		oPr:Say(420,1210,OemtoAnsi("Poinds net"), oFont12)
		oPr:Line(0390,1570,570,1570) // vertical
		oPr:Say(420,1620,OemtoAnsi("Poinds brut (Kg)"), oFont12)
	
		oPr:Line(0390,1950,570,1950) // vertical
		oPr:Say(420,2000,OemtoAnsi("Nº boites"), oFont12)
		oPr:Say(500,1250,OemtoAnsi(ETQ->PLIQUI), oFont22)
		oPr:Say(500,1670,OemtoAnsi(ETQ->PBRUTO), oFont22)	
		oPr:Say(500,2050,OemtoAnsi(ETQ->CAIXA), oFont22)
	
		oPr:Line(0570,0050,0570,2350) // Horizontal 4º linha            	
		oPr:Line(0600,0050,0600,2350) // Horizontal 5º linha            		

/*
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³ 	       "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"         ³±±
±±³          ³ 		  "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"         ³±±
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
*/

		oPr:Say(0630,0050,OemtoAnsi("Nº produit (P)"), oFont12)
		oPr:Say(0610,0500,OemtoAnsi(Alltrim(ETQ->PRODUTO)), oFont34)
		MSBAR("CODE3_9",3.6,0.7,Alltrim(ETQ->PRODUTO),oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFont12,,.F.) //imprime cod. de barra do produto
		oPr:SayBitmap(640,2000,cStartPath+"IMG003.BMP",250,250)
	    
	    //MSBAR("CODE3_9",6.9,1.1,Alltrim(ETQ->PRODUTO),oPr,NIL,NIL,NIL,0.0395,1.1,NIL,oFont12,,.F.) //imprime cod. de barra do produto

	  	oPr:Line(0910,0050,0910,2350) // Horizontal 6º linha
		oPr:Say(0930,0050,OemtoAnsi("Quantite (Q)"), oFont12)
		oPr:Say(0930,1230,OemtoAnsi("Produit"), oFont12)
		oPr:Line(0910,1200,1810,1200) // vertical qtde |produto

		oPr:Say(0920,0600,OemtoAnsi(Alltrim(ETQ->QUANT)), oFont44)
		oPr:Say(1000,1230,OemtoAnsi(ETQ->DESC), oFont12N)

		oPr:Line(1050,1200,1050,2350) // Horizontal 7º linha 
  	    oPr:Say(1060,1230,OemtoAnsi("Ref. fournisseur (30S)"), oFont12)
		oPr:Say(1080,1630,OemtoAnsi(ETQ->FORNECE), oFont34)
		MSBAR("CODE3_9",5.0,0.7,Alltrim(ETQ->QUANT),oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra da qtde
    

		oPr:Line(1250,0020,1250,1200) // Horizontal 8º linha 
		oPr:Say(1280,0050,OemtoAnsi("Fournisseur (V)"), oFont12) 
		oPr:Say(1270,0350,OemtoAnsi(ETQ->FORNECE), oFont16N) 
		
		MSBAR("CODE3_9",5.6,5.7,Alltrim(ETQ->FORNECE) ,oPr,NIL,   NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra do fornecedor	    
		
		oPr:Line(1390,1200,1390,2350) // Horizontal 9º linha 
		oPr:Say(1410,1230,OemtoAnsi("Date"), oFont12)

		oPr:Line(1390,1650,1540,1650) // vertical	data | indice de modificação    	
		oPr:Say(1410,1700,OemtoAnsi("Indice modification"), oFont12)
		oPr:Say(1460,1230,OemtoAnsi(ETQ->DTA), oFont16N)    		       
		MSBAR("CODE3_9",6.1,0.7,Alltrim(ETQ->FORNECE),oPr,NIL,NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra do fornecedor
		//MSBAR("CODE3_9",12.1,0.7,ETQ->FORNECE ,oPr,NIL,   NIL,NIL,0.0395,1.1,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra do fornecedor

	  	oPr:Line(1540,0050,1540,2350) // Horizontal 10º linha            	
		oPr:Say(1560,0050,OemtoAnsi("Nº etiquette"), oFont12)    		
		oPr:Say(1550,0350,OemtoAnsi(ETQ->ETIQ), oFont14N)
		oPr:Say(1560,1230,OemtoAnsi("Nº Lot (H)"), oFont12)    	    		

		//MSBAR("CODE3_9",14.2,0.7,ETQ->ETIQ,oPr,NIL,   NIL,NIL,0.0395,1.1,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra c/ numero da etq  	
		MSBAR("CODE3_9",7.2,0.7,Alltrim(ETQ->ETIQ),oPr,NIL, NIL,NIL,0.0194,0.6,NIL,oFont12,"CODE3_9",.F.) //imprime cod. de barra c/ numero da etq  	
		oPr:Say(1760,0070,OemtoAnsi(ETQ->EMITENTE), oFont10)    	    		  	
		oPr:Line(1810,0050,1810,2350) // Horizontal 11º linha            	
	  
   Endif
   ETQ->(DbSkip())
   If !Empty(ETQ->NOTA)
	    oPr:EndPage()
	    oPr:StartPage()
	Endif    
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
aadd(aRegs,{cPerg,"01","Nota Inicial       ?","Nota Inicial       ?","Nota Inicial       ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Nota Final         ?","Nota Final         ?","Nota Final         ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

cUltPerg := aRegs[Len(aRegs)][2]

If !SX1->(DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
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
