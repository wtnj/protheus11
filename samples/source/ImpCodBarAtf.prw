#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpCodBarAtf³ Autor ³ Microsiga Soft S.A. ³ Data ³ 01.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de Etiquetas de codigos de barras de ativos fixos³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SigaAtf					 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ImpCodBarAtf
Local cString:= "SN1"
Local wnRel  := "ATFR99" //Nome Default do relatorio em Disco
Local cPerg	 := "AFR099"
Local titulo := "Etiquetas de Ativos Fixos"
Local cDesc1 := "Imprime Etiquetas de Ativos fixos, com seu respectivo código de barras"
Local cDesc2 :=""
Local cDesc3 :=""

Private aReturn := { "Zebrado", 1, "Administração", 1, 2, 1, "",1 }
Private nomeprog:="ImpCodBarAtf"
Private nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cbtxt 	:= ""
cbcont	:= 0
li 		:= 0
m_pag 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aPergs := {}    
Aadd(aPergs,{ "Do Codigo ?","¿De Grupo?","From Code ?","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SN1","S","","" })
Aadd(aPergs,{ "Ate Codigo ?","¿Ate Grupo?","To Code ?","mv_ch2","C",10,0,0,"G","","mv_par02","","","","ZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SN1","S","","" })
Aadd(aPergs,{ "Do Item ?","¿Do Item?","From Item ?","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","S","","" })
Aadd(aPergs,{ "Ate o Item ?","¿Ate o Item ?","To Item ?","mv_ch4","C",10,0,0,"G","","mv_par04","","","","ZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","S","","" })
Aadd(aPergs,{ "Impressora ?","¿Impressora?","Printer ?","mv_ch5","N",1,0,1,"C","","mv_par05","Zebra","Zebra","Zebra","","","Allegro","Allegro","Allegro","","","Eltron","Eltron","Eltron","","","","","","","","","","","","","S","","" })
AjustaSx1(cPerg, aPergs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros  ³
//³ mv_par01	  // Do Codigo            |
//³ mv_par02	  // Ate' o Codigo        |
//³ mv_par03	  // Do Item              |
//³ mv_par04	  // Ate' o Item          |
//³ mv_par05	  // Impressora           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Pergunte(cPerg,.T.)
	RptStatus({|lEnd| ImpCodBar2(@lEnd,wnRel,cString)},Titulo)
EndiF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpCodBar2³ Autor ³ Microsiga Soft S.A.   ³ Data ³ 01.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de Etiquetas de codigos de barras de ativos fixos³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SigaAtf					 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function ImpCodBar2(lEnd,wnRel,cString)
Local nX
Local cPorta
Local cModelo := ""
Local cLogo := ""

cPorta := "COM2:9600,n,8,2"

Do Case
Case MV_PAR05 == 1 // Zebra
	cModelo := "S500-8"
	cLogo := "SIGA.GRF"
Case MV_PAR05 == 2 // Allegro
	cModelo := "ALLEGRO"
	cLogo := "SIGA.BMP"
Case MV_PAR05 == 3 // Eltron
	cModelo := "ELTRON"
	cLogo := "SIGA.PCX"
EndCase

MSCBPRINTER( cModelo, cPorta,,,.F.,,,,,"Ativo")

If MV_PAR05 == 3 // Eltron
	MSCBCHKStatus(.f.)
Endif	

MSCBLOADGRF(cLogo)

// Localiza o primeiro bem a ser impresso
DbSelectArea("SN1")
DbSetOrder(1)
MsSeek(xFilial("SN1")+mv_par01,.T.)
While SN1->(!Eof()) .And. SN1->N1_FILIAL==xFilial("SN1") .And.;
		SN1->N1_CBASE <= mv_par02
	// Se os itens estiverem no intervalo solicitado	
	If SN1->N1_ITEM >= mv_par03 .And. SN1->N1_ITEM <= mv_par04
		MSCBBEGIN(1,6)          // Inicio da formacao da imagem da etiqueta
		Do Case
		Case MV_PAR05 == 1 // Zebra
			MSCBBOX(02,01,76,35)    // Quadro
			MSCBLineH(30,05,76,3)   // Linha Horizontal
			MSCBLineH(02,13,76,3,"B")	 // Linha Horizontal
			MSCBLineH(02,20,76,3,"B")	 // Linha Horizontal
			MSCBLineV(30,01,13)			 // Linha Vertical
			MSCBGRAFIC(2,3,"SIGA")		 // Imprime logotipo
			MSCBSAY(33,02,"Ativo fixo","N","0","025,035")  
			MSCBSAY(33,06,"Codigo base/item","N","A","015,008")
			MSCBSAY(33,09, SN1->N1_CBASE + "/" + SN1->N1_ITEM, "N", "0", "032,035")
			MSCBSAY(05,14,"Descricao","N","A","015,008")
			MSCBSAY(05,17, SN1->N1_DESCRIC,"N","0","020,40")
			MSCBSAYBAR(23,22,SN1->(N1_CODBAR),"N","C",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.) // Imprime codigo de barras
		Case MV_PAR05 == 2 // Allegro
			MSCBBOX(02,01,76,34,1)    
			MSCBLineH(30,30,76,1) 
			MSCBLineH(02,23,76,1) 
			MSCBLineH(02,15,76,1) 
			MSCBLineV(30,23,34,1)
			MSCBGRAFIC(2,26,"SIGA")                   
			MSCBSAY(33,31,"Ativo Fixo","N","2","01,01") 
			MSCBSAY(33,27,"Codigo Base/Item","N","2","01,01")
			MSCBSAY(33,24, SN1->N1_CBASE+"/"+SN1->N1_ITEM, "N", "2", "01,01") 
			MSCBSAY(05,20,"Descricao","N","2","01,01")
			MSCBSAY(05,16,SN1->N1_DESCRIC,"N", "2", "01,01")
			MSCBSAYBAR(22,03,SN1->N1_CODBAR,"N","E",8.36,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
   Case MV_PAR05 == 3 // Eltron
      	MSCBGRAFIC(04,02,"SIGA")                   
			MSCBBOX(05,01,76,30,2)
			MSCBLineH(30,06,71,2) 
			MSCBLineH(05,12,71,2) 
			MSCBLineH(05,18,71,2) 
			MSCBSAY(33,02,"Ativo Fixo","N","2","1,2") 
			MSCBSAY(33,07,"Codigo Base/Item", "N", "1", "1,1") 
			MSCBSAY(33,09,SN1->N1_CBASE+"/"+SN1->N1_ITEM, "N", "1", "1,2") 
			MSCBSAY(07,13,"Descricao","N","1","1,1")
			MSCBSAY(07,15,SN1->N1_DESCRIC,"N", "1", "1,2")
			MSCBSAYBAR(28,19,SN1->N1_CODBAR,'N','1',50,.T.,,,,2,2,,,,)
		EndCase	
		MSCBEND() // Finaliza a formacao da imagem da etiqueta
	Endif
	DbSkip()		
End		

MSCBCLOSEPRINTER()
dbSelectArea("SN1")
dbSetOrder(1)

Return