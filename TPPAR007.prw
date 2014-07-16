#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR007  º Autor ³ HANDERSON DUARTE   º Data ³  26/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Confirmação da Qualificação do Processo          º±±
±±º          ³ REFERENTE AO FONTE TPPAC009                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR007 ( )
Private cBmpLogo	:= "\system\logo_whb.bmp"
	
Private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
Private oFnt22		:= TFont():New("Arial",,22,,.f.,,,,,.f.)
Private oFnt08		:= TFont():New("Arial",,08,,.f.,,,,,.f.)
Private oFnt08n		:= TFont():New("Arial",,08,,.t.,,,,,.f.)
Private oFnt09		:= TFont():New("Arial",,09,,.f.,,,,,.f.)
Private oFnt09n		:= TFont():New("Arial",,09,,.t.,,,,,.f.)
Private oFnt11		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt11n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt10		:= TFont():New("Arial",,10,,.f.,,,,,.f.)
Private oFnt10n		:= TFont():New("Arial",,10,,.t.,,,,,.f.)
Private oFnt14		:= TFont():New("Arial",,14,,.f.,,,,,.f.)
Private oFnt14n		:= TFont():New("Arial",,14,,.t.,,,,,.f.)
Private oFnt16		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt16n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)
Private oFnt18		:= TFont():New("Arial",,18,,.f.,,,,,.f.)
Private oFnt18n		:= TFont():New("Arial",,18,,.t.,,,,,.f.)
	
Private nLinInc		:=	20*5
Private nColInc		:=	20*6
Private aAreaZC8	:=	ZC8->(GetArea())
Private nRecNo		:=	0
Private nRecTela	:=	ZC8->(Recno())
Private cNUMQUA		:=	ZC8->ZC8_NUMQUA 
Private cRev		:=	"" 
Private cFiltro 	:= 'ZC8_QUESTA == "01"'

Set Filter To

DBSelectArea("ZC8")
ZC8->(DBGotop())
ZC8->(DBSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA, R_E_C_N_O_, D_E_L_E_T_
ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA))
While ZC8->(!EoF()) .AND. (xFilial("ZC8")+ZC8->ZC8_NUMQUA) == (xFilial("ZC8")+cNUMQUA)
	If ZC8->ZC8_STAREV .AND. ZC8->ZC8_QUESTA="01"
		nRecNo		:=	ZC8->(RecNo())
	EndIf
	ZC8->(DBSkip())
EndDo

ZC8->(DBGoTo(nRecNo))
cRev:=ZC8->ZC8_REV

oPrn := TMSPrinter():New("CONFIRMAÇÃO DA QUALIFICAÇÃO DO PROCESSO")//Cria Objeto para impressao Grafica
oPrn:Setup()//Chama a rotina de Configuracao da impressao
oPrn:SetLandScape()//SetPortrait()

oPrn:StartPage()//Cria nova Pagina 
If ZC8->ZC8_STAREV .AND. ZC8->ZC8_QUESTA="01"
//sfGrafc()
	sfCabec()//Impressao do Cabecalho			
	sfBOX01()
EndIf														
oPrn:EndPage()//Finaliza a Pagina

//	MsgAlert("Relatório vazio")

oPrn:Preview() 
RestArea(aAreaZC8) 
Set Filter To &cFiltro
ZC8->(DBGoto(nRecTela))
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin	:=	20
Local nCol	:=	20   

oPrn:Box(nLinInc,nColInc,nLin*18,nCol*160) //Box 1 do Cabeçalho
oPrn:Box(nLinInc,nColInc,nLin*12,nCol*135) //
oPrn:Box(nLinInc,nCol*135,nLin*9,nCol*160) //
oPrn:Box(nLinInc,nCol*135,nLin*12,nCol*160) //
oPrn:Box(nLinInc,nColInc,nLin*15,nCol*160) //
oPrn:Box(nLinInc,nColInc,nLin*18,nCol*160) // 
oPrn:Line(nLinInc,nCol*21,nLin*12,nCol*21) //Coluna do Cabeçalho
oPrn:SayBitmap(nLinInc+10,nColInc+10,cBmpLogo,nCol*14,nLin*6)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)     

oPrn:Say (nLin*10,nCol*136,"Falha:",oFnt09n,100)   
oPrn:Say (nLinInc+nLin,nCol*136,"Falha:",oFnt09n,100)   

oPrn:Say (nLinInc+(nLin*2),nCol*56,"CONFIRMAÇÃO DA QUALIFICAÇÃO DO PROCESSO",oFnt18n,100)   
oPrn:Say (nLin*12,nColInc+nCol,"Cliente:",oFnt09n,100)
oPrn:Say (nLin*12,nCol*13,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC8->(ZC8_CODCLI+ZC8_LOJA),"A1_NOME")),oFnt09,100)   
oPrn:Say (nLin*12,nCol*65,"Unidade:",oFnt09n,100)   
//oPrn:Say (nLin*12,nCol*75,AllTrim(Transform(ZC8->ZC8_UNID, PesqPict("ZC8","ZC8_UNID") )),oFnt09,100)   
oPrn:Say (nLin*12,nCol*110,"Cood. APQP:",oFnt09n,100)   
oPrn:Say (nLin*12,nCol*119,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_COOR ,"QAA_NOME")),oFnt09,100)   

oPrn:Say (nLin*15,nColInc+nCol,"Desc. Produto:",oFnt09n,100) 
oPrn:Say (nLin*15,nCol*17,AllTrim(Posicione("SB1",1,xFilial("SB1")+ZC8->ZC8_CODPRO ,"B1_DESC")),oFnt09,100)     
oPrn:Say (nLin*15,nCol*65,"Cod. Produto:",oFnt09n,100)   
oPrn:Say (nLin*15,nCol*75,AllTrim(ZC8->ZC8_CODPRO),oFnt09,100)     
oPrn:Say (nLin*15,nCol*110,"Rev. Des.:",oFnt09n,100) 
oPrn:Say (nLin*15,nCol*118,AllTrim(ZC8->ZC8_REVDOC),oFnt09,100)     

Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 GRADE DE IMPRESSÃO =======================================================
Static Function sfBOX01()
Local aArea		:=	ZC8->(GetArea())
Local nLin		:=20
Local nCol		:=20
Local nCont		:=0
Local nContLin	:=0 
Local cResp		:=""//Sequência de responsáveis
Local cACOES	:=""
Local cRESP 	:=""
Local cDTPRZ 	:=""
Local cSTAT  	:=""
Local aPlano	:={"Capacidade Produtiva PQS/ANO","Maquina (Qtde)","Dispositivos (Qtde)",;
				   "Técnicas Utilizadas","Meios de Controle","Embalagem",;  
				   "Rastreabilidade","Poka Yoke (Qtde)","Peça Homem/Hora","Tempo (Análise de Gargalo)"}
				   
Local aFator	:={"Lay-out Area Produção Metros Quadrados","Equipamentos Ergonômicos",;
				   "Número de operações / Turno","Turnos Previstos"}
				     
Local aNivel	:={"Área de recebimento","Área para expedição"}

Local aObjetivo	:={"PPM do Cliente","CPK","Eficiência do Processo","PPM Interno","Performance de Entrega",;
					"Reclamação do Cliente","  ","  "," "}

DBSelectArea("ZC8")
ZC8->(DBSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA, R_E_C_N_O_, D_E_L_E_T_				   
				   
oPrn:Box(nLin*18,nColInc,nLin*23,nCol*160) //
oPrn:Box(nLin*18,nColInc,nLin*21,nCol*102) //
oPrn:Box(nLin*18,nColInc,nLin*23,nCol*102) //

oPrn:Box(nLin*18,nCol*102,nLin*23,nCol*109) //Adequado
oPrn:Box(nLin*18,nCol*109,nLin*23,nCol*116) //Ñ adequado
oPrn:Box(nLin*18,nCol*116,nLin*23,nCol*123) //Ñ Aplicável
oPrn:Box(nLin*18,nCol*123,nLin*23,nCol*160) //Pendências

oPrn:Line(nLin*18,nCol*40,nLin*21,nCol*40) //
oPrn:Line(nLin*18,nCol*73,nLin*21,nCol*73) // 

oPrn:Say ((nLin*18)+10,nColInc+nCol,"Aspectos que Requerem Avalição",oFnt11n,100) 
oPrn:Say ((nLin*18)+10,nCol*50,"Planejado",oFnt11n,100) 
oPrn:Say ((nLin*18)+10,nCol*83,"Obtido",oFnt11n,100) 

oPrn:Say (nLin*19,nCol*103,"Adequado",oFnt08n,100)

oPrn:Say (nLin*19,nCol*112,"Não",oFnt08n,100)
oPrn:Say (nLin*21,nCol*110,"Adequado",oFnt08n,100)

oPrn:Say (nLin*19,nCol*119,"Não",oFnt08n,100)
oPrn:Say (nLin*21,nCol*117,"Aplicável",oFnt08n,100)

oPrn:Say (nLin*19,nCol*135,"Pendências",oFnt11n,100)

//----------------Plano Global de Trabalho--------------------------
oPrn:Say ((nLin*21)+10,nColInc+nCol,"PLANO GLOBAL DE TRABALHO",oFnt10n,100)
For nCont:=1 to 10
	oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
	oPrn:Line(nLin*(23+nContLin),nCol*40,nLin*(25+nContLin),nCol*40) // 
	oPrn:Line(nLin*(23+nContLin),nCol*73,nLin*(25+nContLin),nCol*73) // 	
	oPrn:Line(nLin*(23+nContLin),nCol*102,nLin*(25+nContLin),nCol*102) //
	oPrn:Line(nLin*(23+nContLin),nCol*109,nLin*(25+nContLin),nCol*109) //
	oPrn:Line(nLin*(23+nContLin),nCol*116,nLin*(25+nContLin),nCol*116) //	
	oPrn:Line(nLin*(23+nContLin),nCol*123,nLin*(25+nContLin),nCol*123) //		
	oPrn:Say (nLin*(23+nContLin),nColInc+nCol,aPlano[nCont],oFnt08n,100)	 
	If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cRev+StrZero(nCont,2)))
		oPrn:Say (nLin*(23+nContLin),nCol*41,AllTrim(ZC8->ZC8_PLAN),oFnt08,100) 	
		oPrn:Say (nLin*(23+nContLin),nCol*74,AllTrim(ZC8->ZC8_OBTIDO),oFnt08,100) 			
		oPrn:Say (nLin*(23+nContLin),nCol*124,AllTrim(ZC8->ZC8_PENDEN),oFnt08,100)		
		Do Case
			Case ZC8->ZC8_RPOSTA=="1"
				oPrn:Say (nLin*(23+nContLin),nCol*105,"X",oFnt08n,100)			
			Case ZC8->ZC8_RPOSTA=="2"
				oPrn:Say (nLin*(23+nContLin),nCol*112,"X",oFnt08n,100)							
			Case ZC8->ZC8_RPOSTA=="3"
				oPrn:Say (nLin*(23+nContLin),nCol*119,"X",oFnt08n,100)															
		EndCase
	EndIf
	nContLin:=nContLin+2
Next nCont
//----------------Fim do Plano Global de Trabalho-------------------

//----------------Fatores Ergonômicos e Humanos--------------------------
oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
oPrn:Say ((nLin*(23+nContLin))+10,nColInc+nCol,"FATORES ERGONÔMICOS E HUMANOS",oFnt10n,100)
nContLin:=nContLin+2
For nCont:=1 to 4
	oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
	oPrn:Line(nLin*(23+nContLin),nCol*40,nLin*(25+nContLin),nCol*40) // 
	oPrn:Line(nLin*(23+nContLin),nCol*73,nLin*(25+nContLin),nCol*73) // 	
	oPrn:Line(nLin*(23+nContLin),nCol*102,nLin*(25+nContLin),nCol*102) //
	oPrn:Line(nLin*(23+nContLin),nCol*109,nLin*(25+nContLin),nCol*109) //
	oPrn:Line(nLin*(23+nContLin),nCol*116,nLin*(25+nContLin),nCol*116) //	
	oPrn:Line(nLin*(23+nContLin),nCol*123,nLin*(25+nContLin),nCol*123) //		
	oPrn:Say (nLin*(23+nContLin),nColInc+nCol,aFator[nCont],oFnt08n,100)
	If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cRev+StrZero(nCont+10,2)))
		oPrn:Say (nLin*(23+nContLin),nCol*41,AllTrim(ZC8->ZC8_PLAN),oFnt08,100) 	
		oPrn:Say (nLin*(23+nContLin),nCol*74,AllTrim(ZC8->ZC8_OBTIDO),oFnt08,100) 			
		oPrn:Say (nLin*(23+nContLin),nCol*124,AllTrim(ZC8->ZC8_PENDEN),oFnt08,100)				
		Do Case
			Case ZC8->ZC8_RPOSTA=="1"
				oPrn:Say (nLin*(23+nContLin),nCol*105,"X",oFnt08n,100)			
			Case ZC8->ZC8_RPOSTA=="2"
				oPrn:Say (nLin*(23+nContLin),nCol*112,"X",oFnt08n,100)							
			Case ZC8->ZC8_RPOSTA=="3"
				oPrn:Say (nLin*(23+nContLin),nCol*119,"X",oFnt08n,100)															
		EndCase
	EndIf	 
	nContLin:=nContLin+2
Next nCont
//----------------Fim do Fatores Ergonômicos e Humanos-------------------

//----------------Níveis Inventário de Armazenamento--------------------------
oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
oPrn:Say ((nLin*(23+nContLin))+10,nColInc+nCol,"NÍVEIS DE INVENTÁRIO DE ARMAZENAMENTO",oFnt10n,100)
nContLin:=nContLin+2
For nCont:=1 to 2
	oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
	oPrn:Line(nLin*(23+nContLin),nCol*40,nLin*(25+nContLin),nCol*40) // 
	oPrn:Line(nLin*(23+nContLin),nCol*73,nLin*(25+nContLin),nCol*73) // 	
	oPrn:Line(nLin*(23+nContLin),nCol*102,nLin*(25+nContLin),nCol*102) //
	oPrn:Line(nLin*(23+nContLin),nCol*109,nLin*(25+nContLin),nCol*109) //
	oPrn:Line(nLin*(23+nContLin),nCol*116,nLin*(25+nContLin),nCol*116) //	
	oPrn:Line(nLin*(23+nContLin),nCol*123,nLin*(25+nContLin),nCol*123) //		
	oPrn:Say (nLin*(23+nContLin),nColInc+nCol,aNivel[nCont],oFnt08n,100) 
	If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cRev+StrZero(nCont+14,2)))
		oPrn:Say (nLin*(23+nContLin),nCol*41,AllTrim(ZC8->ZC8_PLAN),oFnt08,100) 	
		oPrn:Say (nLin*(23+nContLin),nCol*74,AllTrim(ZC8->ZC8_OBTIDO),oFnt08,100) 			
		oPrn:Say (nLin*(23+nContLin),nCol*124,AllTrim(ZC8->ZC8_PENDEN),oFnt08,100)				
		Do Case
			Case ZC8->ZC8_RPOSTA=="1"
				oPrn:Say (nLin*(23+nContLin),nCol*105,"X",oFnt08n,100)			
			Case ZC8->ZC8_RPOSTA=="2"
				oPrn:Say (nLin*(23+nContLin),nCol*112,"X",oFnt08n,100)							
			Case ZC8->ZC8_RPOSTA=="3"
				oPrn:Say (nLin*(23+nContLin),nCol*119,"X",oFnt08n,100)															
		EndCase
	EndIf	
	nContLin:=nContLin+2
Next nCont
//----------------Fim do Níveis Inventário de Armazenamento-------------------

//----------------Objetivos para a Qualidade--------------------------
oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
oPrn:Say ((nLin*(23+nContLin))+5,nColInc+nCol,"OBJETIVOS PARA A QUALIDADE",oFnt10n,100)
nContLin:=nContLin+2
For nCont:=1 to 6  //9
	oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
	oPrn:Line(nLin*(23+nContLin),nCol*40,nLin*(25+nContLin),nCol*40) // 
	oPrn:Line(nLin*(23+nContLin),nCol*73,nLin*(25+nContLin),nCol*73) // 	
	oPrn:Line(nLin*(23+nContLin),nCol*102,nLin*(25+nContLin),nCol*102) //
	oPrn:Line(nLin*(23+nContLin),nCol*109,nLin*(25+nContLin),nCol*109) //
	oPrn:Line(nLin*(23+nContLin),nCol*116,nLin*(25+nContLin),nCol*116) //	
	oPrn:Line(nLin*(23+nContLin),nCol*123,nLin*(25+nContLin),nCol*123) //		
	oPrn:Say (nLin*(23+nContLin),nColInc+nCol,aObjetivo[nCont],oFnt08n,100) 
	If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cRev+StrZero(nCont+16,2)))
		oPrn:Say (nLin*(23+nContLin),nCol*41,AllTrim(ZC8->ZC8_PLAN),oFnt08,100) 	
		oPrn:Say (nLin*(23+nContLin),nCol*74,AllTrim(ZC8->ZC8_OBTIDO),oFnt08,100) 			
		oPrn:Say (nLin*(23+nContLin),nCol*124,AllTrim(ZC8->ZC8_PENDEN),oFnt08,100)				
		Do Case
			Case ZC8->ZC8_RPOSTA=="1"
				oPrn:Say (nLin*(23+nContLin),nCol*105,"X",oFnt08n,100)			
			Case ZC8->ZC8_RPOSTA=="2"
				oPrn:Say (nLin*(23+nContLin),nCol*112,"X",oFnt08n,100)							
			Case ZC8->ZC8_RPOSTA=="3"
				oPrn:Say (nLin*(23+nContLin),nCol*119,"X",oFnt08n,100)															
		EndCase
	EndIf	
	nContLin:=nContLin+2
Next nCont
//----------------Fim do Objetivos para a Qualidade-------------------

//----------------Ações Necessárias --------------------------
nContLin:=nContLin+2
oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)
oPrn:Line(nLin*(23+nContLin),nCol*123,nLin*(25+nContLin),nCol*123) //		
oPrn:Line(nLin*(23+nContLin),nCol*134,nLin*(25+nContLin),nCol*134) //	
oPrn:Line(nLin*(23+nContLin),nCol*143,nLin*(25+nContLin),nCol*143) //
oPrn:Say ((nLin*(23+nContLin))+5,nColInc+nCol,"Ações Necessárias",oFnt10n,100)
oPrn:Say ((nLin*(23+nContLin))+5,nCol*124,"Responsável",oFnt10n,100)
oPrn:Say ((nLin*(23+nContLin))+5,nCol*135,"Prazo",oFnt10n,100)
oPrn:Say ((nLin*(23+nContLin))+5,nCol*145,"Status",oFnt10n,100)
nContLin:=nContLin+2
ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cRev))
For nCont:=1 to 5
	oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin),nCol*160)	
	oPrn:Line(nLin*(23+nContLin),nCol*123,nLin*(25+nContLin),nCol*123) //		
	oPrn:Line(nLin*(23+nContLin),nCol*134,nLin*(25+nContLin),nCol*134) //	
	oPrn:Line(nLin*(23+nContLin),nCol*143,nLin*(25+nContLin),nCol*143) //	 	
	
	If nCont<=3
		cResp	:=Alltrim(Str(nCont))
		cACOES	:="ZC8_ACOES"+Alltrim(Str(nCont))
	 	cRESP 	:="ZC8_RESP"+Alltrim(Str(nCont))
	 	cDTPRZ 	:="ZC8_DTPRZ"+Alltrim(Str(nCont))
		cSTAT  	:="ZC8_STAT"+Alltrim(Str(nCont))
		
		oPrn:Say ((nLin*(23+nContLin))+5,nColInc+nCol,AllTrim(ZC8->&(cACOES)),oFnt08,100) 	
		oPrn:Say ((nLin*(23+nContLin))+5,nCol*124,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC8->&(cRESP) ,"QAA_APELID")),oFnt08,100) 			
		oPrn:Say ((nLin*(23+nContLin))+5,nCol*135,AllTrim(DtoC(ZC8->&(cDTPRZ))),oFnt08,100)				
		Do Case
			Case ZC8->&(cSTAT)=="1"
				oPrn:Say ((nLin*(23+nContLin))+5,nCol*145,"Pendente",oFnt08n,100)			
			Case ZC8->&(cSTAT)=="2"
				oPrn:Say ((nLin*(23+nContLin))+5,nCol*145,"Em Andamento",oFnt08n,100)							
			Case ZC8->&(cSTAT)=="3"
				oPrn:Say ((nLin*(23+nContLin))+5,nCol*145,"Concluido",oFnt08n,100)															
		EndCase
	EndIf
	nContLin:=nContLin+2
Next nCont
//----------------Fim da Ações Necessárias------------------

//----------------Assinaturaras CIENTES --------------------------
oPrn:Box(nLin*(23+nContLin),nColInc,nLin*(25+nContLin+4),nCol*160)
oPrn:Say ((nLin*(23+nContLin))+5,nColInc+nCol,"Cientes:",oFnt10n,100)
nContLin:=nContLin+2
oPrn:Say ((nLin*(23+nContLin))+5,nColInc+nCol,"Produção: "+AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_PRODUC ,"QAA_NOME")),oFnt11,100)
oPrn:Say ((nLin*(23+nContLin))+5,nCol*55,"Engenharia: "+AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_ENG ,"QAA_NOME")),oFnt11,100)
oPrn:Say ((nLin*(23+nContLin))+5,nCol*105,"Qualidade: "+AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_QUAL ,"QAA_NOME")),oFnt11,100)

//----------------Fim das Assinaturaras CIENTES ------------------

RestArea(aArea)
Return ( )                                                                                                       
//=====================================FIM DO BOX01 GRADE DE IMPRESSÃO =================================================

Static Function sfGrafc()
Local nLin:=0
Local nCol:=0
lOCAL nConL:=0
Local nCont:=0
Local LFLAG:=.T. 
While nCol < 4000 
	If nConL==1 .AND. LFLAG                               
		oPrn:Say(200,nCol,Str(nCont),oFnt08,100)	
		oPrn:Say(280,nCol,Str(nCol),oFnt08,100)
		LFLAG:=.F.
	EndIf
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
LFLAG:=.T.
While nLin < 4000
	If nConL==1 .AND. LFLAG 
		oPrn:Say(nLin,120,Str(nCont),oFnt08,100)
		oPrn:Say(nLin,200,Str(nLin),oFnt08,100)
		LFLAG:=.F.		
	EndIf
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



