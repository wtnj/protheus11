#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR003  º Autor ³ HANDERSON DUARTE   º Data ³  05/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Pedido Interno                                   º±±
±±º          ³ REFERENTE AO FONTE TPPAC006                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR003 ( ) 
Private cBmpLogo	:= "\system\logo_whb.bmp"
	
Private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
Private oFnt22		:= TFont():New("Arial",,22,,.f.,,,,,.f.)
Private oFnt07		:= TFont():New("Arial",,07,,.f.,,,,,.f.)
Private oFnt07n		:= TFont():New("Arial",,07,,.t.,,,,,.f.)
Private oFnt08		:= TFont():New("Arial",,08,,.f.,,,,,.f.)
Private oFnt08n		:= TFont():New("Arial",,08,,.t.,,,,,.f.)
Private oFnt09		:= TFont():New("Arial",,09,,.f.,,,,,.f.)
Private oFnt09n		:= TFont():New("Arial",,09,,.t.,,,,,.f.)
Private oFnt11		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt11n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt14		:= TFont():New("Arial",,14,,.f.,,,,,.f.)
Private oFnt14n		:= TFont():New("Arial",,14,,.t.,,,,,.f.)
Private oFnt16		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt16n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)
	
Private nLinInc		:=	20*10
Private nColInc		:=	20*6
Private aAreaZC0	:=	ZC0->(GetArea())
Private nRecNo		:=	0
Private cNUMPED		:=	ZC0->ZC0_NUMPED
DBSelectArea("ZC0")
ZC0->(DBGoTop())
ZC0->(DBSetOrder(3))//ZC0_FILIAL, ZC0_NUMPED, ZC0_REV, ZC0_APROV
ZC0->(DBSeek(xFilial("ZC0")+cNUMPED))
While ZC0->(!EoF()) .AND. (xFilial("ZC0")+ZC0->ZC0_NUMPED) == (xFilial("ZC0")+cNUMPED)
 If  ZC0->ZC0_APROV=="S" .AND. ZC0->ZC0_STAREV
  nRecNo  := ZC0->(RecNo())
 EndIf
 ZC0->(DBSkip())
EndDo

ZC0->(DBGoTo(nRecNo))

oPrn := TMSPrinter():New("PEDIDO INTERNO")//Cria Objeto para impressao Grafica
oPrn:Setup()//Chama a rotina de Configuracao da impressao                             
oPrn:StartPage()//Cria nova Pagina  
//If ZC0->ZC0_APROV=="S"  .AND. ZC0->ZC0_STAREV
	sfCabec()//Impressao do Cabecalho
	sfBOX01() 
	sfBOX02()								
	sfBOX03()	
	sfBOX04()	
	sfBOX05()
	sfBOX06()	
	sfBOX07()		
	sfBOX08()		
	sfBOX09()
//EndIf	
oPrn:EndPage()//Finaliza a Pagina
oPrn:Preview() 

RestArea(aAreaZC0)
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLinInc,nColInc,nLin*20,nCol*114) //Box do Cabeçalho 
oPrn:SayBitmap(nLinInc+nLin,nColInc+nCol,cBmpLogo,nCol*18,nLin*7)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)      
oPrn:Say (nLin*15,nCol*48,"PEDIDO INTERNO",oFnt16n,100)   
oPrn:Say (nLin*15,nCol*100,AllTrim(ZC0->ZC0_NUMPED),oFnt11n,100)
oPrn:Say (nLin*15,nCol*107,"/",oFnt11n,100)
oPrn:Say (nLin*15,nCol*108,AllTrim(ZC0->ZC0_REV),oFnt11n,100)

Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 IDENTIFICAÇÃO =======================================================
Static Function sfBOX01()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLin*23,nColInc,nLin*31,nCol*114)  

oPrn:Say (nLin*24,nColInc+nCol,"IDENTIFICAÇÃO:",oFnt07,100)
oPrn:Say (nLin*26,nColInc+nCol,"CLIENTE:",oFnt09n,100)
oPrn:Say (nLin*26,nCol*14,Left(AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC0->ZC0_CODCLI+ZC0->ZC0_LOJA,"A1_NOME")),20),oFnt09,100)
oPrn:Say (nLin*29,nColInc+nCol,"DESCRIÇÃO",oFnt09n,100)
oPrn:Say (nLin*29,nCol*16,AllTrim(ZC0->ZC0_DESPEC),oFnt09,100)
//oPrn:Say (nLin*29,nCol*27,AllTrim(ZC0->ZC0_DESC2),oFnt09,100)

oPrn:Say (nLin*26,nCol*64,"PLANTA",oFnt09n,100)
oPrn:Say (nLin*26,nCol*70,AllTrim(ZC0->ZC0_PLANTA),oFnt09,100)
oPrn:Say (nLin*29,nCol*64,"PEÇA Nº",oFnt09n,100)
oPrn:Say (nLin*29,nCol*70,AllTrim(ZC0->ZC0_PECA),oFnt09,100)
//oPrn:Say (nLin*29,nCol*84,AllTrim(ZC0->ZC0_PROD2),oFnt09,100)
Return ( )                                                                                                       
//===============================FIM DO BOX01 IDENTIFICAÇÃO =======================================================
//=====================================BOX02 DADOS CONTRATO ================================================
Static Function sfBOX02()
Local nLin:=20
Local nCol:=20 
oPrn:Box(nLin*33,nColInc,nLin*41,nCol*114) 
oPrn:Say (nLin*34,nColInc+nCol,"DADOS CONTRATO",oFnt07,100)
oPrn:Say (nLin*36,nColInc+nCol,"Nº PEDIDO DE COMPRA FERRAMENTAL:",oFnt09n,100)
oPrn:Say (nLin*36,nCol*33,ZC0->ZC0_PEDFER,oFnt09,100)                   
oPrn:Say (nLin*39,nColInc+nCol,"PRAZO DE ENTREGA AMOSTRAS:",oFnt09n,100)
oPrn:Say (nLin*39,nCol*28,AllTrim(ZC0->ZC0_PRAZO),oFnt09,100)
oPrn:Say (nLin*36,nCol*64,"EMISSÃO:",oFnt09n,100)                 
oPrn:Say (nLin*36,nCol*71,DtoC(ZC0->ZC0_DATAE),oFnt09,100)       

Return ( )
//===============================FIM DO BOX02 DADOS CONTRATO==============================================
//=====================================BOX03 PEDIDO DE COMPRA DA PEÇA=====================================
Static Function sfBOX03()
Local nLin:=20
Local nCol:=20 
oPrn:Box(nLin*43,nColInc,nLin*53,nCol*114) 

oPrn:Say (nLin*45,nColInc+nCol,"Nº PEDIDO DE COMPRA PEÇA:",oFnt09n,100)
oPrn:Say (nLin*45,nCol*28,AllTrim(ZC0->ZC0_PEDPEC),oFnt09,100)                   
oPrn:Say (nLin*48,nColInc+nCol,"PRAZO ENTREGA PRODUÇÃO:",oFnt09n,100)
oPrn:Say (nLin*48,nCol*28,AllTrim(ZC0->ZC0_PRAZPC),oFnt09,100)                 
oPrn:Say (nLin*51,nColInc+nCol,"CUSTO DE PRODUTO VENDIDO (CPV)",oFnt09n,100)
oPrn:Say (nLin*51,nCol*33,AllTrim(ZC0->ZC0_CPV),oFnt09,100)                   
oPrn:Say (nLin*45,nCol*64,"EMISSÃO:",oFnt09n,100)
oPrn:Say (nLin*45,nCol*71,DtoC(ZC0->ZC0_DATAP),oFnt09,100)       

Return ( )

//===============================FIM DO  BOX03 PEDIDO DE COMPRA DA PEÇA=====================================
//=====================================BOX04 VOLUME DO CONTRATADO =======================================================
Static Function sfBOX04()
Local nLin:=20
Local nCol:=20 
oPrn:Box(nLin*56,nColInc,nLin*63,nCol*114) 

oPrn:Say (nLin*58,nColInc+nCol,"VOLUME CONTRATADO:",oFnt09n,100)
oPrn:Say (nLin*58,nCol*23,AllTrim(Transform(ZC0->ZC0_VOL, PesqPict("ZC0","ZC0_VOL"))),oFnt09,100)                   
oPrn:Say (nLin*61,nColInc+nCol,"PRODUTIVIDADE ESPERADA:",oFnt09n,100)
oPrn:Say (nLin*61,nCol*27,AllTrim(ZC0->ZC0_PRODUT),oFnt09,100)
//oPrn:Say (nLin*61,nCol*31,AllTrim(Transform(ZC0->ZC0_PRODUT, PesqPict("ZC0","ZC0_PRODUT"))),oFnt09,100)                   
//oPrn:Say (nLin*61,nCol*41,AllTrim(Transform(ZC0->ZC0_PROD2, PesqPict("ZC0","ZC0_PROD2"))),oFnt09,100)
Return ( )
//==============================FIM DO BOX04 VOLUME DO CONTRATADO =======================================================
//=====================================BOX05 QUALIDADE ==================================================================
Static Function sfBOX05()
Local nLin		:=	20
Local nCol		:=	20
oPrn:Box(nLin*65,nColInc,nLin*80,nCol*114) 

oPrn:Say (nLin*66,nColInc+nCol,"QUALIDADE:",oFnt07,100)
oPrn:Say (nLin*68,nColInc+nCol,"PPM CLIENTE:",oFnt09n,100)                   
oPrn:Say (nLin*68,nCol*17,AllTrim(ZC0->ZC0_PPMCLI),oFnt09,100)                   
oPrn:Say (nLin*71,nColInc+nCol,"ÍNDICE DE REFUGO INTERNO:",oFnt09n,100)                   
oPrn:Say (nLin*71,nCol*28,AllTrim(ZC0->ZC0_REFUGO),oFnt09,100)                   
oPrn:Say (nLin*74,nColInc+nCol,"CAPABILIDADE ESPERADA:",oFnt09n,100)                   
oPrn:Say (nLin*74,nCol*26,AllTrim(ZC0->ZC0_CAPAB),oFnt09,100)                   
oPrn:Say (nLin*77,nColInc+nCol,"REQUISITOS ESPECÍFICOS CLIENTE:",oFnt09n,100)                   
oPrn:Say (nLin*77,nCol*33,AllTrim(ZC0->ZC0_REQUIS),oFnt09,100)                                                                                                                                  
 
Return ( )
//===============================FIM DO BOX05 QUALIDADE ==================================================================
//=====================================BOX06 LOGÍSTICA ==================================================================
Static Function sfBOX06()
Local nLin		:=	20
Local nCol		:=	20
oPrn:Box(nLin*82,nColInc,nLin*94,nCol*114) 

oPrn:Say (nLin*83,nColInc+nCol,"LOGÍSTICA:",oFnt07,100)
oPrn:Say (nLin*85,nColInc+nCol,"PEÇA BRUTA:",oFnt09n,100)                   
oPrn:Say (nLin*85,nCol*17,AllTrim(ZC0->ZC0_BRUTA),oFnt09,100)                   
oPrn:Say (nLin*88,nColInc+nCol,"EMBALAGEM:",oFnt09n,100)                   
oPrn:Say (nLin*88,nCol*17,AllTrim(ZC0->ZC0_EMBAL),oFnt09,100)              
oPrn:Say (nLin*91,nColInc+nCol,"LOCAL ENTREGA:",oFnt09n,100)                   
oPrn:Say (nLin*91,nCol*20,AllTrim(ZC0->ZC0_LOCAL),oFnt09,100)
oPrn:Say (nLin*85,nCol*64,"FRETE:",oFnt09n,100)                   
oPrn:Say (nLin*85,nCol*72,AllTrim(ZC0->ZC0_FRETE),oFnt09,100)                        

Return ( )
//===============================FIM DO BOX06 LOGÍSTICA ==================================================================
//=====================================BOX07 ANÁLISE DA ENGENHARIA CAMPO MEMO ===========================================
Static Function sfBOX07()
Local nLin		:=	20
Local nCol		:=	20 
Local cLinhaObs	:=	""
Local nCont		:=	0
Local nM		:=	0
oPrn:Box(nLin*96,nColInc,nLin*117,nCol*114) 

oPrn:Say (nLin*98,nColInc+nCol,"ANÁLISE ENGENHARIA:",oFnt09n,100)                   
For nM := 1 to MLCount( ZC0->ZC0_ANAENG , 140 )
	cLinhaObs	:=Memoline( ZC0->ZC0_ANAENG ,140, nM ) 
	oPrn:Say (nLin*(101+nCont),nColInc+nCol,cLinhaObs,oFnt08,100) 	       	
	nCont+=2	
Next nM  

Return ( )
//==============================FIM DO BOX07 ANÁLISE DA ENGENHARIA CAMPO MEMO ===========================================
//=====================================BOX08 OBSERVAÇÕES GERAIS CAMPO MEMO===============================================
Static Function sfBOX08()
Local nLin		:=	20
Local nCol		:=	20 
Local cLinhaObs	:=	""
Local nCont		:=	0
Local nM		:=	0
oPrn:Box(nLin*117,nColInc,nLin*144,nCol*114) 

oPrn:Say (nLin*119,nColInc+nCol,"OBSERVAÇÕES:",oFnt09n,100)                   
For nM := 1 to MLCount( ZC0->ZC0_OBS , 140 )
	cLinhaObs	:=Memoline( ZC0->ZC0_OBS ,140, nM ) 
	oPrn:Say (nLin*(121+nCont),nColInc+nCol,cLinhaObs,oFnt08,100) 	       	
	nCont+=2	
Next nM  

Return ( )
//==============================FIM DO BOX08 OBSERVAÇÕES GERAIS CAMPO MEMO===============================================
//=====================================BOX09 APROVAÇÃO ==================================================================
Static Function sfBOX09()
Local nLin		:=	20
Local nCol		:=	20 
Local cLinhaObs	:=	""
Local nCont		:=	0
Local nM		:=	0
oPrn:Box(nLin*148,nColInc,nLin*155,nCol*114)
oPrn:Line(nLin*148,nCol*41,nLin*155,nCol*41) 

oPrn:Say (nLin*150,nColInc+nCol,"DATA:",oFnt09n,100)  
oPrn:Say (nLin*150,nCol*12,DtoC(ZC0->ZC0_DATAF),oFnt09,100)                    

oPrn:Say (nLin*150,nCol*42,"ASSINATURA:",oFnt09n,100)  
oPrn:Say (nLin*150,nCol*51,AllTrim(POSICIONE("QAA",1,xFilial("QAA")+ZC0_ASS,"QAA_NOME")),oFnt09,100)                    

Return ( )
//==============================FIM DO BOX09 APROVAÇÃO ==================================================================
Static Function sfGrafc()
Local nLin:=0
Local nCol:=0
lOCAL nConL:=0
Local nCont:=0 
While nCol < 4000 
	If nConL==5                                
		oPrn:Say(200,nCol,Str(nCont),oFnt08,100)	
		oPrn:Say(280,nCol,Str(nCol),oFnt08,100)
		nConL:=0
	EndIf
	oPrn:Line(0,nCol,4000,nCol) //C
	nConL++
	nCont++
	nCol+=20
EndDo
nConL:=0
nCont:=0
While nLin < 4000
	If nConL==5
		oPrn:Say(nLin,120,Str(nCont),oFnt08,100)
		oPrn:Say(nLin,200,Str(nLin),oFnt08,100)
		nConL:=0
	EndIf
	oPrn:Line(nLin,0,nLin,4000) //C
	nConL++	
	nCont++	
	nLin+=20
EndDo
Return

