#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR005  º Autor ³ HANDERSON DUARTE   º Data ³  19/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Lista de Características Especiais               º±±
±±º          ³ REFERENTE AO FONTE TPPAC008                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR005 ( ) 
Local 	nLin		:=20
Local 	nCol		:=20
Private cBmpLogo	:= "\system\logo_whb.bmp" 
Private cBmpLinha	:= "\system\LinhaVerde.bmp"
	
Private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
Private oFnt22		:= TFont():New("Arial",,22,,.f.,,,,,.f.)
Private oFnt07		:= TFont():New("Arial",,07,,.f.,,,,,.f.)
Private oFnt07n		:= TFont():New("Arial",,07,,.t.,,,,,.f.)
Private oFnt08		:= TFont():New("Arial",,08,,.f.,,,,,.f.)
Private oFnt08n		:= TFont():New("Arial",,08,,.t.,,,,,.f.)
Private oFnt09		:= TFont():New("Arial",,09,,.f.,,,,,.f.)
Private oFnt09n		:= TFont():New("Arial",,09,,.t.,,,,,.f.)
Private oFnt10		:= TFont():New("Arial",,10,,.f.,,,,,.f.)
Private oFnt10n		:= TFont():New("Arial",,10,,.t.,,,,,.f.)
Private oFnt11		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt11n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt12		:= TFont():New("Arial",,12,,.f.,,,,,.f.)
Private oFnt12n		:= TFont():New("Arial",,12,,.t.,,,,,.f.)
Private oFnt13		:= TFont():New("Arial",,13,,.f.,,,,,.f.)
Private oFnt13n		:= TFont():New("Arial",,13,,.t.,,,,,.f.)
Private oFnt14		:= TFont():New("Arial",,14,,.f.,,,,,.f.)
Private oFnt14n		:= TFont():New("Arial",,14,,.t.,,,,,.f.)
Private oFnt16		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt16n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)

Private nLinCon		:=	34	
Private nColCon		:=	0
Private nLinInc		:=	20*10
Private nColInc		:=	20*6
Private aAreaZC7	:=	ZC7->(GetArea())
Private nRecNo		:=	0
Private cCARESP		:=	ZC7->ZC7_CARESP 
Private aAreaZCH	:=	ZCH->(GetArea())

DBSelectArea("ZC7")
ZC7->(DBGoTop())
ZC7->(DBSetOrder(1))//ZC7_FILIAL, ZC7_CARESP, ZC7_REV, R_E_C_N_O_, D_E_L_E_T_
ZC7->(DBSeek(xFilial("ZC7")+cCARESP))
While ZC7->(!EoF()) .AND. (xFilial("ZC7")+ZC7->ZC7_CARESP) == (xFilial("ZC7")+cCARESP)
	If ZC7->ZC7_STAREV
		nRecNo		:=	ZC7->(RecNo())
	EndIf
	ZC7->(DBSkip())
EndDo

ZC7->(DBGoTo(nRecNo))

oPrn := TMSPrinter():New("Lista de Características Especiais")//Cria Objeto para impressao Grafica  
oPrn:Setup()//Chama a rotina de Configuracao da impressao                             
oPrn:StartPage()//Cria nova Pagina
If ZC7->ZC7_STAREV
	//Impressão do Box 1-------------------------------------------------------------------------------------	
	sfCabec()//Impressao do Cabecalho		
	sfBOX01() 
	DBSelectArea("ZCH")
	ZCH->(DbGoTop())
	ZCH->(DBSetOrder(2))  //ZCH_FILIAL, ZCH_CARESP, ZCH_REVCAR, ZCH_TIPOCA, ZCH_PROCES, ZCH_DESC, R_E_C_N_O_, D_E_L_E_T_
	If ZCH->(DBSeek(xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)+"1"))
		Do While ZCH->(!EoF()).AND. (xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)+"1")==(ZCH->(ZCH_FILIAL+ZCH_CARESP+ZCH_REVCAR+ZCH_TIPOCA)) 
			oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+3),nCol*114) //Box da Linha
			oPrn:Line(nLin*nLinCon,nCol*93,nLin*(nLinCon+3),nCol*93)//Linha 1
			oPrn:Line(nLin*nLinCon,nCol*100,nLin*(nLinCon+3),nCol*100)//Linha 2
			oPrn:Line(nLin*nLinCon,nCol*107,nLin*(nLinCon+3),nCol*107)//Linha 3		
			oPrn:Say (nLin*(nLinCon+1),nColInc+nCol,AllTrim(ZCH->ZCH_DESC),oFnt11,100)
			Do Case
				Case ZCH->ZCH_PROCES=="1"
					oPrn:Say (nLin*(nLinCon+1),nCol*96," X",oFnt12,100)
				Case ZCH->ZCH_PROCES=="2"
					oPrn:Say (nLin*(nLinCon+1),nCol*103," X",oFnt12,100)
				Case ZCH->ZCH_PROCES=="3"
					oPrn:Say (nLin*(nLinCon+1),nCol*110," X",oFnt12,100)								
			EndCase				
			nLinCon		:=	nLinCon+3
			//Private nColCon		:=	0
			If	nLinCon >= 155
				oPrn:EndPage()//Finaliza a Pagina				                             
				oPrn:StartPage()//Cria nova Pagina 
				sfCabec()//Impressao do Cabecalho		
				nLinCon:=34				
				sfBOX01()					
			EndIf						
			ZCH->(DBSkip())
		EndDo
	EndIf
	//fim da Impressão do Box 1-------------------------------------------------------------------------------------	
	
	//Impressão do Box 2--------------------------------------------------------------------------------------------		
	If	(nLinCon+7) >= 155
		oPrn:EndPage()//Finaliza a Pagina				                             
		oPrn:StartPage()//Cria nova Pagina 
		sfCabec()//Impressao do Cabecalho		
		nLinCon:=34		
		sfBOX02()					
	Else
		sfBOX02()					
	EndIf						
	DBSelectArea("ZCH")
	ZCH->(DbGoTop())	
	ZCH->(DBSetOrder(2))  //ZCH_FILIAL, ZCH_CARESP, ZCH_REVCAR, ZCH_TIPOCA, ZCH_PROCES, ZCH_DESC, R_E_C_N_O_, D_E_L_E_T_
	If ZCH->(DBSeek(xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)+"2"))
		Do While ZCH->(!EoF()).AND. (xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)+"2")==(ZCH->(ZCH_FILIAL+ZCH_CARESP+ZCH_REVCAR+ZCH_TIPOCA)) 
			oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+3),nCol*114) //Box da Linha  
			oPrn:Line(nLin*nLinCon,nCol*93,nLin*(nLinCon+3),nCol*93)//Linha 1
			oPrn:Line(nLin*nLinCon,nCol*100,nLin*(nLinCon+3),nCol*100)//Linha 2
			oPrn:Line(nLin*nLinCon,nCol*107,nLin*(nLinCon+3),nCol*107)//Linha 3		
			oPrn:Say (nLin*(nLinCon+1),nColInc+nCol,AllTrim(ZCH->ZCH_DESC),oFnt11,100)
			Do Case
				Case ZCH->ZCH_PROCES=="1"
					oPrn:Say (nLin*(nLinCon+1),nCol*96," X",oFnt12,100)
				Case ZCH->ZCH_PROCES=="2"
					oPrn:Say (nLin*(nLinCon+1),nCol*103," X",oFnt12,100)
				Case ZCH->ZCH_PROCES=="3"
					oPrn:Say (nLin*(nLinCon+1),nCol*110," X",oFnt12,100)								
			EndCase				
			nLinCon		:=	nLinCon+3
			//Private nColCon		:=	0
			If	nLinCon >= 155
				oPrn:EndPage()//Finaliza a Pagina				                             
				oPrn:StartPage()//Cria nova Pagina 
				nLinCon:=34
				sfCabec()//Impressao do Cabecalho		
				sfBOX02()					
			EndIf						
			ZCH->(DBSkip())
		EndDo
	EndIf	
	//fim da Impressão do Box 2-------------------------------------------------------------------------------------			
	//Impressão do Box 3 e 4--------------------------------------------------------------------------------------------		
	If	(nLinCon+33) >= 155
		oPrn:EndPage()//Finaliza a Pagina				                             
		oPrn:StartPage()//Cria nova Pagina 
		sfCabec()//Impressao do Cabecalho		                                                                            
		nLinCon:=34		
		oPrn:SayBitmap(nLin*nLinCon,nColInc,cBmpLinha,nCol*108,nLin*4)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)		
		sfBOX03()
		sfBOX04()					
	Else
		oPrn:SayBitmap(nLin*nLinCon,nColInc,cBmpLinha,nCol*108,nLin*4)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)		
		sfBOX03()
		sfBOX04()					
	EndIf
	//fim da Impressão do Box 3 e 4 -------------------------------------------------------------------------------------					
	
	//Impressão do Box 5--------------------------------------------------------------------------------------------		
	If	(nLinCon+15) >= 155
		oPrn:EndPage()//Finaliza a Pagina				                             
		oPrn:StartPage()//Cria nova Pagina 
		sfCabec()//Impressao do Cabecalho		 						 
		nLinCon:=34
		sfBOX05()					
	Else
		sfBOX05()					
	EndIf 

	//fim da Impressão do Box 5 -------------------------------------------------------------------------------------					
	//Impressão do Box 6--------------------------------------------------------------------------------------------		
	If	(nLinCon+10) >= 155
		oPrn:EndPage()//Finaliza a Pagina				                             
		oPrn:StartPage()//Cria nova Pagina 
		sfCabec()//Impressao do Cabecalho		
		nLinCon:=34
		sfBOX06()					
	Else 
		sfBOX06()					
	EndIf
	//fim da Impressão do Box 6 -------------------------------------------------------------------------------------						
	
	oPrn:EndPage()//Finaliza a Pagina	
EndIf	
oPrn:Preview() 

RestArea(aAreaZC7)
RestArea(aAreaZCH)
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLinInc,nColInc,nLin*18,nCol*114) //Box do Cabeçalho 
oPrn:SayBitmap(nLinInc+nLin,nColInc+nCol,cBmpLogo,nCol*12,nLin*6)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)      
oPrn:Say (nLin*13,nCol*35,"LISTA DE CARACTERÍSTICAS ESPECIAIS",oFnt16n,100)
oPrn:Say (nLin*13,nCol*105,AllTrim(ZC7->ZC7_CARESP),oFnt11n,100)
oPrn:Say (nLin*13,nCol*115,"/",oFnt11n,100)
oPrn:Say (nLin*13,nCol*116,AllTrim(ZC7->ZC7_REV),oFnt11n,100)

oPrn:Say (nLin*13,nCol*98,"Impresso: "+DtoC(dDataBase),oFnt10n,100)
   
oPrn:Box(nLin*18,nColInc,nLin*26,nCol*114) //Dados do Cliente/Peça
oPrn:Box(nLin*18,nColInc,nLin*22,nCol*114) //Dados do Cliente/Peça
oPrn:Say (nLin*20,nColInc+nCol,"Nome Peça:",oFnt09n,100) 
oPrn:Say (nLin*20,nCol*15,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC7->(ZC7_NUMPC+ZC7_REVPEC),"QK1_DESC")),oFnt09,100) 

oPrn:Line(nLin*18,nCol*63,nLin*22,nCol*63)
oPrn:Say (nLin*20,nCol*64,"Cliente:",oFnt09n,100) 
oPrn:Say (nLin*20,nCol*70,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC7->ZC7_CODCLI+ZC7->ZC7_LOJA,"A1_NOME")),oFnt09,100) 

oPrn:Say (nLin*24,nColInc+nCol,"Nº da Peça:",oFnt09n,100) 
oPrn:Say (nLin*24,nCol*15,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC7->(ZC7_NUMPC+ZC7_REVPEC),"QK1_PECA")),oFnt09,100) 

oPrn:Line(nLin*22,nCol*33,nLin*26,nCol*33)
oPrn:Say (nLin*24,nCol*34,"Revisão Desenho:",oFnt09n,100) 
oPrn:Say (nLin*24,nCol*46,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC7->(ZC7_NUMPC+ZC7_REVPEC),"QK1_REVDES")),oFnt09,100) 

oPrn:Line(nLin*22,nCol*63,nLin*26,nCol*63)
oPrn:Say (nLin*24,nCol*64,"Programa:",oFnt09n,100) 
oPrn:Say (nLin*24,nCol*71,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC7->(ZC7_NUMPC+ZC7_REVPEC),"QK1_PROJET")),oFnt09,100) 

oPrn:Line(nLin*22,nCol*87,nLin*26,nCol*87)
oPrn:Say (nLin*24,nCol*88,"Emissão:",oFnt09n,100) 
oPrn:Say (nLin*24,nCol*95,DtoC(ZC7->ZC7_EMISSA),oFnt09,100) 

oPrn:Box(nLin*26,nColInc,nLin*30,nCol*114) //Legenda
oPrn:Say (nLin*28,nColInc+nCol,"CP - Crítica de Produto",oFnt11n,100) 

oPrn:Line(nLin*26,nCol*33,nLin*30,nCol*33)
oPrn:Say (nLin*28,nCol*34,"PP - Parâmetro de Processo",oFnt11n,100) 

oPrn:Line(nLin*26,nCol*63,nLin*30,nCol*63)
oPrn:Say (nLin*28,nCol*64,"MP - Monitorização do Processo",oFnt11n,100) 

Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 CARACTERÍSTICAS CRÍTICAS ============================================
Static Function sfBOX01()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLin*30,nColInc,nLin*34,nCol*114) 
oPrn:SayBitmap(nLin*30,nColInc,cBmpLinha,nCol*108,nLin*4+5)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 			 

oPrn:Say (nLin*31,nColInc+nCol,"Características Críticas:",oFnt12n,100)

oPrn:Line(nLin*30,nCol*93,nLin*34,nCol*93)
oPrn:Say (nLin*31,nCol*95,"CP",oFnt12n,100)  

oPrn:Line(nLin*30,nCol*100,nLin*34,nCol*100)
oPrn:Say (nLin*31,nCol*102,"PP",oFnt12n,100)

oPrn:Line(nLin*30,nCol*107,nLin*34,nCol*107)
oPrn:Say (nLin*31,nCol*109,"PP",oFnt12n,100) 

Return ( )                                                                                                       
//=============================FIM DO  BOX01 CARACTERÍSTICAS CRÍTICAS ============================================
//=====================================BOX02 CARACTERÍSTICAS SIGNIFICATIVAS ======================================
Static Function sfBOX02()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+4),nCol*114)
oPrn:SayBitmap(nLin*nLinCon,nColInc,cBmpLinha,nCol*108,nLin*4+5)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 			   

oPrn:Say (nLin*(nLinCon+1),nColInc+nCol,"Características Significativas:",oFnt12n,100)

oPrn:Line(nLin*nLinCon,nCol*93,nLin*(nLinCon+4),nCol*93)
oPrn:Say (nLin*(nLinCon+1),nCol*95,"CP",oFnt12n,100)  

oPrn:Line(nLin*nLinCon,nCol*100,nLin*(nLinCon+4),nCol*100)
oPrn:Say (nLin*(nLinCon+1),nCol*102,"PP",oFnt12n,100)

oPrn:Line(nLin*nLinCon,nCol*107,nLin*(nLinCon+4),nCol*107)
oPrn:Say (nLin*(nLinCon+1),nCol*109,"PP",oFnt12n,100)

nLinCon		:=	nLinCon+4

Return ( )                                                                                                       
//=============================FIM DO  BOX02 CARACTERÍSTICAS SIGNIFICATIVAS ======================================
//=====================================BOX03 ESPECIFICAÇÕES DE ENGENHARIA ========================================
Static Function sfBOX03()
Local nLin:=20
Local nCol:=20 
Local nM		:=0
Local nCont		:=0
Local cLinhaObs	:=""

oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+4),nCol*57) 

oPrn:Say (nLin*(nLinCon+1),nColInc+nCol,"Especificação de Engenharia:",oFnt12n,100)

oPrn:Box(nLin*(nLinCon+4),nColInc,nLin*(nLinCon+30),nCol*57)

For nM := 1 to 9
	cLinhaObs	:=Memoline( ZC7->ZC7_ENG ,65, nM ) 
	oPrn:Say (nLin*((nLinCon+4)+nCont),nColInc+nCol,cLinhaObs,oFnt10,100) 	       	
	nCont+=3	
Next nM 

Return ( )                                                                                                       
//=============================FIM DO  BOX03 ESPECIFICAÇÕES DE ENGENHARIA ========================================
//=====================================BOX04 ANÁLISE DE INSTRUMENTO DE CONTROLE===================================
Static Function sfBOX04()
Local nLin:=20
Local nCol:=20
Local nM		:=0
Local nCont		:=0
Local cLinhaObs	:=""
 
oPrn:Box(nLin*nLinCon,nCol*57,nLin*(nLinCon+4),nCol*114)   						 

oPrn:Say (nLin*(nLinCon+1),nCol*58,"Análise de Instrumentos de Controle:",oFnt12n,100)

oPrn:Box(nLin*(nLinCon+4),nCol*57,nLin*(nLinCon+30),nCol*114)

For nM := 1 to 9
	cLinhaObs	:=Memoline( ZC7->ZC7_CONTR ,70, nM ) 
	oPrn:Say (nLin*((nLinCon+4)+nCont),nCol*58,cLinhaObs,oFnt10,100) 	       	
	nCont+=3 
Next nM 
nLinCon		:=	nLinCon+nCont
Return ( )                                                                                                       
//=============================FIM DO  BOX04 ANÁLISE DE INSTRUMENTO DE CONTROLE====================================
//=====================================BOX05 OBSERVAÇÕES =========================================================
Static Function sfBOX05()
Local nLin		:=20
Local nCol		:=20 
Local nM		:=0
Local nCont		:=0
Local cLinhaObs	:=""

oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+4),nCol*114) 
oPrn:SayBitmap(nLin*nLinCon,nColInc,cBmpLinha,nCol*108,nLin*4)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 						 

oPrn:Say (nLin*(nLinCon+1),nColInc+nCol,"Observações:",oFnt12n,100)

oPrn:Box(nLin*(nLinCon+4),nColInc,nLin*(nLinCon+15),nCol*114)

For nM := 1 to 4//MLCount( ZC0->ZC0_OBS , 140 )
	cLinhaObs	:=Memoline( ZC7->ZC7_OBS ,145, nM ) 
	oPrn:Say (nLin*((nLinCon+4)+nCont),nColInc+nCol,cLinhaObs,oFnt10,100) 	       	
	nCont+=3		
Next nM 
nLinCon		:=	nLinCon+nCont
Return ( )                                                                                                       
//=============================FIM DO  BOX05 OBSERVAÇÕES =========================================================
//=====================================BOX06 APROVAÇÃO ===========================================================
Static Function sfBOX06()
Local nLin:=20
Local nCol:=20
//Contém 3 linha de 3 
oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+4),nCol*114) 
oPrn:Box(nLin*nLinCon,nColInc,nLin*(nLinCon+12),nCol*114) 
oPrn:SayBitmap(nLin*nLinCon,nColInc,cBmpLinha,nCol*108,nLin*4)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 						  
oPrn:Say (nLin*(nLinCon+1),nColInc+nCol,"Aprovação:",oFnt12n,100)

oPrn:Say (nLin*(nLinCon+4),nColInc+nCol,"Coord. Projeto: "+AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_COPRO,"QAA_NOME")),oFnt10,100)
oPrn:Say (nLin*(nLinCon+7),nColInc+nCol,"Ger. Qualidade: "+AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERQUA,"QAA_NOME")),oFnt10,100)
oPrn:Say (nLin*(nLinCon+10),nColInc+nCol,"Ger. Engenharia: "+AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERENG,"QAA_NOME")),oFnt10,100)

Return ( )                                                                                                       
//=============================FIM DO  BOX06 APROVAÇÃO ===========================================================


