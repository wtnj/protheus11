#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR008  º Autor ³ HANDERSON DUARTE   º Data ³  09/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Análise Crítica de Contrato - USINAGEM           º±±
±±º          ³ REFERENTE AO FONTE TPPAC011                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR008 ( )
Private cBmpLogo	:= "\system\logo_whb.bmp"
Private cBmpLinha	:= "\system\LinhaVerde.bmp"
	
Private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
Private oFnt22		:= TFont():New("Arial",,22,,.f.,,,,,.f.)
Private oFnt08		:= TFont():New("Arial",,08,,.f.,,,,,.f.)
Private oFnt08n		:= TFont():New("Arial",,08,,.t.,,,,,.f.)
Private oFnt09		:= TFont():New("Arial",,09,,.f.,,,,,.f.)
Private oFnt09n		:= TFont():New("Arial",,09,,.t.,,,,,.f.)
Private oFnt10		:= TFont():New("Arial",,10,,.f.,,,,,.f.)
Private oFnt10n		:= TFont():New("Arial",,10,,.t.,,,,,.f.)
Private oFnt11		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt11n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt14		:= TFont():New("Arial",,14,,.f.,,,,,.f.)
Private oFnt14n		:= TFont():New("Arial",,14,,.t.,,,,,.f.)
Private oFnt16		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt16n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)
Private oFnt18		:= TFont():New("Arial",,18,,.f.,,,,,.f.)
Private oFnt18n		:= TFont():New("Arial",,18,,.t.,,,,,.f.)
	
Private nLinInc		:=	20*5
Private nColInc		:=	20*6
Private aAreaZC2	:=	ZC2->(GetArea())
Private nRecNo		:=	0
Private cACT		:=	ZC2->ZC2_ACT  
 
DBSelectArea("ZC2")
ZC2->(DBGotop())
ZC2->(DBSetOrder(1))//ZC2_FILIAL, ZC2_ACT, ZC2_REV, R_E_C_N_O_, D_E_L_E_T_
ZC2->(DBSeek(xFilial("ZC2")+cACT))
While ZC2->(!EoF()) .AND. (ZC2->ZC2_FILIAL+ZC2->ZC2_ACT) == (xFilial("ZC2")+cACT)
	If ZC2->ZC2_STAREV .AND. ZC2->ZC2_STATUS="S"
		nRecNo		:=	ZC2->(RecNo())
	EndIf
	ZC2->(DBSkip())
EndDo

ZC2->(DBGoTo(nRecNo))

oPrn := TMSPrinter():New("Análise Crítica de Contrato ")//Cria Objeto para impressao Grafica
oPrn:Setup()//Chama a rotina de Configuracao da impressao
//oPrn:SetLandScape()
oPrn:SetPortrait()

oPrn:StartPage()//Cria nova Pagina 
If ZC2->ZC2_STAREV .AND. ZC2->ZC2_STATUS="S"
	sfCabec()//Impressao do Cabecalho			
 	sfBOX01()
EndIf														
oPrn:EndPage()//Finaliza a Pagina

//	MsgAlert("Relatório vazio")

oPrn:Preview() 
RestArea(aAreaZC2) 
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLinInc,nColInc,nLin*15,nCol*114) //Box do Cabeçalho 
oPrn:SayBitmap(nLinInc+nLin,nColInc+nCol,cBmpLogo,nCol*18,nLin*7)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)      
oPrn:Say (nLinInc+nLin,nCol*42,"ANÁLISE CRÍTICA DE CONTRATO",oFnt18n,100) 
oPrn:Say (nLinInc+nLin,nCol*95,AllTrim(ZC2->ZC2_ACT),oFnt11n,100)
oPrn:Say (nLinInc+nLin,nCol*103,"/",oFnt11n,100)
oPrn:Say (nLinInc+nLin,nCol*104,AllTrim(ZC2->ZC2_REV),oFnt11n,100) 

If ZC2->ZC2_TPANA=="1" //Introdução de Peça Nova
	oPrn:Say (nLin*10,nCol*42,"X",oFnt11n,100)
Else  //Modificação                                         
	oPrn:Say (nLin*10,nCol*85,"X",oFnt11n,100)
EndIf
oPrn:Box(nLin*10,nCol*41,nLin*12,nCol*45) //Box da Introdução
oPrn:Say (nLin*10,nCol*47,"Introdução de Peça Nova",oFnt11n,100)   
oPrn:Box(nLin*10,nCol*84,nLin*12,nCol*88) //Box da Modificacao
oPrn:Say (nLin*10,nCol*90,"Modificação",oFnt11n,100)
  
oPrn:Box(nLin*15,nColInc,nLin*19,nCol*114) //2 - Box do Cabeçalho 
oPrn:Say (nLin*16,nColInc+nCol,"Nº Peça:",oFnt09n,100)
oPrn:Say (nLin*16,nCol*14,AllTrim(ZC2->ZC2_NUMPC),oFnt09,100)
oPrn:Say (nLin*16,nCol*45,"Revisão:",oFnt09n,100)
oPrn:Say (nLin*16,nCol*52,AllTrim(ZC2->ZC2_REVPC),oFnt09,100)
oPrn:Say (nLin*16,nCol*90,"Data:",oFnt09n,100)
oPrn:Say (nLin*16,nCol*95,AllTrim(DtoC(ZC2->ZC2_DATA)),oFnt09,100)

oPrn:Box(nLin*19,nColInc,nLin*23,nCol*114) //3 - Box do Cabeçalho 
oPrn:Say (nLin*20,nColInc+nCol,"Denominação da Peça:",oFnt09n,100)
oPrn:Say (nLin*20,nCol*23,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC2->(ZC2_NUMPC+ZC2_REVPC),"QK1_DESC")),oFnt09,100)
oPrn:Say (nLin*20,nCol*90,"Cliente:",oFnt09n,100)
oPrn:Say (nLin*20,nCol*96,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC2->(ZC2_CODCLI+ZC2_LOJA),"A1_NREDUZ")),oFnt09,100)

oPrn:Box(nLin*23,nColInc,nLin*27,nCol*114) //4 - Box do Cabeçalho 
oPrn:Say (nLin*24,nColInc+nCol,"Desenvolvimento Nº:",oFnt09n,100)
oPrn:Say (nLin*24,nCol*21,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC2->(ZC2_NUMPC+ZC2_REVPC),"QK1_PPAP")),oFnt09,100)
oPrn:Say (nLin*24,nCol*55,"Solic. Orçam.:",oFnt09n,100)
oPrn:Say (nLin*24,nCol*65,AllTrim(ZC2->ZC2_SO),oFnt09,100)
oPrn:Say (nLin*24,nCol*75,"Projeto:",oFnt09n,100)
oPrn:Say (nLin*24,nCol*81,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC2->(ZC2_NUMPC+ZC2_REVPC),"QK1_PROJET")),oFnt09,100)


oPrn:Box(nLin*27,nColInc,nLin*31,nCol*114) //5 - Box do Cabeçalho 
oPrn:SayBitmap(nLin*27,nColInc,cBmpLinha,nCol*108,nLin*4)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*28,nCol*50,"ANÁLISE CRÍTICA TÉCNICA",oFnt16n,100)


Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 IDENTIFICAÇÃO =======================================================
Static Function sfBOX01()
Local nLin		:=20
Local nCol		:=20
Local cCuidad	:=""
Local cLinhaObs	:=""
Local nM		:=0
Local nCont		:=0
//---------------------B1---------------------------------------------
oPrn:Box(nLin*31,nColInc,nLin*34,nCol*114)  
oPrn:Line(nLin*31,nColInc+(nCol*3),nLin*34,nColInc+(nCol*3))                               
oPrn:Say (nLin*32,nColInc+nCol,"B1",oFnt09n,100)
oPrn:Say (nLin*32,nColInc+(nCol*4),"Equipe Multidisciplinar e contatos do Cliente:",oFnt09n,100)
oPrn:Say (nLin*32,nCol*45,"Conforme cronograma APQP",oFnt09,100)
//---------------------B2---------------------------------------------
oPrn:Box(nLin*34,nColInc,nLin*37,nCol*114)  
oPrn:Line(nLin*34,nColInc+(nCol*3),nLin*37,nColInc+(nCol*3))                               
oPrn:Say (nLin*35,nColInc+nCol,"B2",oFnt09n,100)
oPrn:Say (nLin*35,nColInc+(nCol*4),"Normas, especificações, legislações, referente à peça constantes no desenho e/ou informações adicionais do cliente:",oFnt09n,100)
//--------------------Gred do B2---------------------------------------
oPrn:Box(nLin*37,nColInc,nLin*40,nCol*114)
oPrn:Line(nLin*37,nCol*64,nLin*40,nCol*64)//coluna 1
oPrn:Line(nLin*37,nCol*94,nLin*40,nCol*94)//coluna 2
oPrn:Say (nLin*38,nColInc+nCol,"Desenho, norma, legislação, alteração e especificação de Engenharia",oFnt09n,100)  
oPrn:Say (nLin*38,nCol*65,"Responsável Análise",oFnt09n,100)  
oPrn:Say (nLin*38,nCol*95,"Atendimento possível?",oFnt09n,100)
oPrn:Box(nLin*40,nColInc,nLin*43,nCol*114)
oPrn:Box(nLin*43,nColInc,nLin*46,nCol*114)
oPrn:Box(nLin*46,nColInc,nLin*49,nCol*114)
oPrn:Box(nLin*49,nColInc,nLin*52,nCol*114)
oPrn:Box(nLin*52,nColInc,nLin*55,nCol*114)
oPrn:Line(nLin*40,nCol*64,nLin*55,nCol*64)//coluna 1
oPrn:Line(nLin*40,nCol*94,nLin*55,nCol*94)//coluna 2

oPrn:Say (nLin*41,nColInc+nCol,AllTrim(ZC2->ZC2_NORMA1),oFnt09,100)  
oPrn:Say (nLin*41,nCol*65,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP1,"QAA_NOME")),oFnt09,100)  
oPrn:Say (nLin*41,nCol*95,IIF(Empty(ZC2->ZC2_ATEND1),"",IIF(ZC2->ZC2_ATEND1=="1","SIM","NÃO")),oFnt09,100)

oPrn:Say (nLin*44,nColInc+nCol,AllTrim(ZC2->ZC2_NORMA2),oFnt09,100)  
oPrn:Say (nLin*44,nCol*65,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP2,"QAA_NOME")),oFnt09,100)  
oPrn:Say (nLin*44,nCol*95,IIF(Empty(ZC2->ZC2_ATEND2),"",IIF(ZC2->ZC2_ATEND2=="1","SIM","NÃO")),oFnt09,100)

oPrn:Say (nLin*47,nColInc+nCol,AllTrim(ZC2->ZC2_NORMA3),oFnt09,100)  
oPrn:Say (nLin*47,nCol*65,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP3,"QAA_NOME")),oFnt09,100)  
oPrn:Say (nLin*47,nCol*95,IIF(Empty(ZC2->ZC2_ATEND3),"",IIF(ZC2->ZC2_ATEND3=="1","SIM","NÃO")),oFnt09,100)

oPrn:Say (nLin*50,nColInc+nCol,AllTrim(ZC2->ZC2_NORMA4),oFnt09,100)  
oPrn:Say (nLin*50,nCol*65,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP4,"QAA_NOME")),oFnt09,100)  
oPrn:Say (nLin*50,nCol*95,IIF(Empty(ZC2->ZC2_ATEND4),"",IIF(ZC2->ZC2_ATEND4=="1","SIM","NÃO")),oFnt09,100)

oPrn:Say (nLin*53,nColInc+nCol,AllTrim(ZC2->ZC2_NORMA5),oFnt09,100)  
oPrn:Say (nLin*53,nCol*65,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP5,"QAA_NOME")),oFnt09,100)  
oPrn:Say (nLin*53,nCol*95,IIF(Empty(ZC2->ZC2_ATEND5),"",IIF(ZC2->ZC2_ATEND5=="1","SIM","NÃO")),oFnt09,100)

oPrn:Box(nLin*55,nColInc,nLin*58,nCol*114)
oPrn:Say(nLin*56,nColInc+nCol,"Observações Adicionais:",oFnt09n,100)  
oPrn:Say(nLin*56,nCol*25,AllTrim(ZC2->ZC2_OBS),oFnt09n,100)
//---------------------B3---------------------------------------------
oPrn:Box(nLin*58,nColInc,nLin*61,nCol*114)  
oPrn:Line(nLin*58,nColInc+(nCol*3),nLin*61,nColInc+(nCol*3))                               
oPrn:Say (nLin*59,nColInc+nCol,"B3",oFnt09n,100)
oPrn:Say (nLin*59,nColInc+(nCol*4),"O Cliente adota simbologia própria para característica especial?",oFnt09n,100)
oPrn:Line(nLin*58,nCol*64,nLin*61,nCol*64)//coluna 1
oPrn:Say (nLin*59,nCol*65,IIF(Empty(ZC2->ZC2_SIMBOL),"",IIF(ZC2->ZC2_SIMBOL=="1","SIM","NÃO")),oFnt09n,100)
oPrn:Line(nLin*58,nCol*70,nLin*61,nCol*70)//coluna 1
oPrn:Say (nLin*59,nCol*71,"Obs.:",oFnt09n,100)
oPrn:Say (nLin*59,nCol*75,AllTrim(ZC2->ZC2_OBS),oFnt09,100)
//---------------------B4---------------------------------------------
oPrn:Box(nLin*61,nColInc,nLin*64,nCol*114)  
oPrn:Line(nLin*61,nColInc+(nCol*3),nLin*64,nColInc+(nCol*3))                               
oPrn:Say (nLin*62,nColInc+nCol,"B4",oFnt09n,100)
oPrn:Say (nLin*62,nColInc+(nCol*4),"Características especiais designadas pelo cliente:",oFnt09n,100)
oPrn:Line(nLin*61,nCol*64,nLin*64,nCol*64)//coluna 1
oPrn:Say (nLin*62,nCol*65,IIF(Empty(ZC2->ZC2_CARCLI),"",IIF(ZC2->ZC2_CARCLI=="1","SIM","NÃO")),oFnt09n,100)
oPrn:Line(nLin*61,nCol*70,nLin*64,nCol*70)//coluna 1
oPrn:Say (nLin*62,nCol*71,"Quais?",oFnt09n,100)
oPrn:Say (nLin*62,nCol*76,AllTrim(ZC2->ZC2_CARAC),oFnt09,100)
//---------------------B5---------------------------------------------
oPrn:Box(nLin*64,nColInc,nLin*73,nCol*114)  
oPrn:Line(nLin*64,nColInc+(nCol*3),nLin*73,nColInc+(nCol*3))                               
oPrn:Say (nLin*68,nColInc+nCol,"B5",oFnt09n,100)
oPrn:SayBitmap(nLin*64,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*65,nColInc+(nCol*4),"Material:",oFnt09n,100)

oPrn:Box(nLin*67,nColInc+(nCol*3),nLin*70,nCol*114)
oPrn:Say (nLin*68,nColInc+(nCol*4),"Normas: "+AllTrim(ZC2->ZC2_NORMA),oFnt09n,100)
oPrn:Line(nLin*67,nCol*44,nLin*70,nCol*44) 
oPrn:Say (nLin*68,nCol*45,"Dureza: "+AllTrim(ZC2->ZC2_DUREZA),oFnt09n,100)
oPrn:Line(nLin*67,nCol*80,nLin*70,nCol*80) 
oPrn:Say (nLin*68,nCol*81,"Peça Amostra: "+AllTrim(ZC2->ZC2_AMOST),oFnt09n,100)   

oPrn:Box(nLin*70,nColInc+(nCol*3),nLin*73,nCol*114)
oPrn:Say (nLin*71,nColInc+(nCol*4),"Especificações Adicionais Necessárias:",oFnt09n,100)
oPrn:Say (nLin*71,nCol*38,+AllTrim(ZC2->ZC2_ESPADI),oFnt09,100)
//---------------------B6---------------------------------------------
oPrn:Box(nLin*73,nColInc,nLin*82,nCol*114)  
oPrn:Line(nLin*73,nColInc+(nCol*3),nLin*82,nColInc+(nCol*3))                               
oPrn:Say (nLin*77,nColInc+nCol,"B6",oFnt09n,100)
oPrn:SayBitmap(nLin*73,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*74,nColInc+(nCol*4),"Dimensional:",oFnt09n,100)

oPrn:Box(nLin*76,nColInc+(nCol*3),nLin*79,nCol*114)
oPrn:Say (nLin*77,nColInc+(nCol*4),"Conforme Desenho:",oFnt09n,100)
oPrn:Line(nLin*76,nCol*25,nLin*79,nCol*25) 
oPrn:Say (nLin*77,nCol*26,IIF(Empty(ZC2->ZC2_CONDES),"",IIF(ZC2->ZC2_CONDES=="1","SIM","NÃO")),oFnt09n,100)
oPrn:Say (nLin*77,nCol*35,"Qual Especificação?",oFnt09n,100)   
oPrn:Say (nLin*77,nCol*50,AllTrim(ZC2->ZC2_QUAL),oFnt09,100)   

oPrn:Box(nLin*79,nColInc+(nCol*3),nLin*82,nCol*114)
oPrn:Say (nLin*80,nColInc+(nCol*4),"Observações sobre tolerâncias:",oFnt09n,100)
oPrn:Say (nLin*80,nCol*31,AllTrim(ZC2->ZC2_OBSTOL),oFnt09,100)
oPrn:Line(nLin*79,nCol*65,nLin*82,nCol*65)
oPrn:Say (nLin*80,nCol*66,"Observações Adicionais:",oFnt09n,100)
oPrn:Say (nLin*80,nCol*82,Left(AllTrim(ZC2->ZC2_OBSADI),27),oFnt09,100)
//---------------------B7---------------------------------------------
oPrn:Box(nLin*82,nColInc,nLin*88,nCol*114)  
oPrn:Line(nLin*82,nColInc+(nCol*3),nLin*88,nColInc+(nCol*3))                               
oPrn:Say (nLin*84,nColInc+nCol,"B7",oFnt09n,100)
oPrn:SayBitmap(nLin*82,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*83,nColInc+(nCol*4),"Proteção Superficial:",oFnt09n,100)

oPrn:Box(nLin*85,nColInc+(nCol*3),nLin*88,nCol*114)
oPrn:Box(nLin*86,nCol*23,nLin*87+10,nCol*25)//Box Desenho da Peça
If ZC2->ZC2_DESPC=="1"
	oPrn:Say (nLin*86,nCol*24,"X",oFnt09n,100) 
EndIf
oPrn:Say (nLin*86,nColInc+(nCol*4),"Desenho da Peça:",oFnt09n,100) 

oPrn:Box(nLin*86,nCol*42,nLin*87+10,nCol*44)//Especificação/Norma
If ZC2->ZC2_DESNOR=="1"
	oPrn:Say (nLin*86,nCol*43,"X",oFnt09n,100) 
EndIf
oPrn:Say (nLin*86,nCol*27,"Especificação/Norma:",oFnt09n,100) 

oPrn:Say (nLin*86,nCol*46,"Qual?",oFnt09n,100) 
oPrn:Say (nLin*86,nCol*50,Left(AllTrim(ZC2->ZC2_QUAL1),22),oFnt09,100)
 
oPrn:Line(nLin*85,nCol*75,nLin*88,nCol*75) 

oPrn:Say (nLin*86,nCol*76,"Tipo de Proteção:",oFnt09n,100) 
oPrn:Say (nLin*86,nCol*88,Left(AllTrim(ZC2->ZC2_TIPO),23),oFnt09,100) 
//---------------------B8---------------------------------------------
oPrn:Box(nLin*88,nColInc,nLin*94,nCol*114)  
oPrn:Line(nLin*88,nColInc+(nCol*3),nLin*94,nColInc+(nCol*3))                               
oPrn:Say (nLin*91,nColInc+nCol,"B8",oFnt09n,100)
oPrn:SayBitmap(nLin*88,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*89,nColInc+(nCol*4),"Ensaios/testes exigidos:",oFnt09n,100)

oPrn:Box(nLin*91,nColInc+(nCol*3),nLin*94,nCol*114)
oPrn:Box(nLin*92,nCol*18,nLin*93+10,nCol*20)//Box Destrutivo
If ZC2->ZC2_ENSAIO=="1"
	oPrn:Say (nLin*92,nCol*19,"X",oFnt09n,100) 
EndIf
oPrn:Say (nLin*92,nColInc+(nCol*4),"Destrutivo:",oFnt09n,100) 

oPrn:Box(nLin*92,nCol*33,nLin*93+10,nCol*35)//Box Não Destrutivo
If ZC2->ZC2_ENSAIO=="2"
	oPrn:Say (nLin*92,nCol*34,"X",oFnt09n,100) 
EndIf
oPrn:Say (nLin*92,nCol*22,"Não Destrutivo:",oFnt09n,100) 

oPrn:Line(nLin*91,nCol*37,nLin*94,nCol*37) 

oPrn:Say (nLin*92,nCol*38,"Qual?",oFnt09n,100) 
oPrn:Say (nLin*92,nCol*42,Left(AllTrim(ZC2->ZC2_QUAL2),37),oFnt09,100)
 
oPrn:Line(nLin*91,nCol*85,nLin*94,nCol*85) 

oPrn:Say (nLin*92,nCol*86,"Frequen./Especif.:",oFnt09n,100) 
oPrn:Say (nLin*92,nCol*98,Left(AllTrim(ZC2->ZC2_FREQ),14),oFnt09,100) 
//---------------------B9---------------------------------------------
oPrn:Box(nLin*94,nColInc,nLin*103,nCol*114)  
oPrn:Line(nLin*94,nColInc+(nCol*3),nLin*103,nColInc+(nCol*3))                               
oPrn:Say (nLin*98,nColInc+nCol,"B9",oFnt09n,100)
oPrn:SayBitmap(nLin*94,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*95,nColInc+(nCol*4),"Controle:",oFnt09n,100)

oPrn:Box(nLin*97,nColInc+(nCol*3),nLin*100,nCol*114)
oPrn:Say (nLin*98,nColInc+(nCol*4),"Necessidade de aquisição de dispositivos de controle:",oFnt09n,100) 
oPrn:Say (nLin*98,nCol*46,IIF(Empty(ZC2->ZC2_CONTR),"",IIF(ZC2->ZC2_CONTR=="1","SIM","NÃO")),oFnt09,100) 

oPrn:Line(nLin*97,nCol*64,nLin*100,nCol*64) 

oPrn:Say (nLin*98,nCol*65,"Equip. de Inspeção/Ensaios:",oFnt09n,100) 
oPrn:Say (nLin*98,nCol*86,IIF(Empty(ZC2->ZC2_EQUIP),"",IIF(ZC2->ZC2_EQUIP=="1","SIM","NÃO")),oFnt09,100)
 
oPrn:Box(nLin*100,nColInc+(nCol*3),nLin*103,nCol*114)
oPrn:Say (nLin*101,nColInc+(nCol*4),"Qual?",oFnt09n,100) 
oPrn:Say (nLin*101,nColInc+(nCol*9),AllTrim(ZC2->ZC2_QUAL3),oFnt09,100) 

oPrn:Line(nLin*100,nCol*64,nLin*103,nCol*64) 

oPrn:Say (nLin*101,nCol*65,"Investimento:",oFnt09n,100) 
oPrn:Say (nLin*101,nCol*74,Left(AllTrim(ZC2->ZC2_INVEST),35),oFnt09,100)
//---------------------B10---------------------------------------------
oPrn:Box(nLin*103,nColInc,nLin*106,nCol*114)  
oPrn:Line(nLin*103,nColInc+(nCol*3),nLin*106,nColInc+(nCol*3))                               
oPrn:Say (nLin*104,nColInc+10,"B10",oFnt09n,100)
oPrn:Say (nLin*103+4,nColInc+(nCol*4),"Acabamento da Peça:",oFnt09n,100)
oPrn:Say (nLin*104+10,nColInc+(nCol*4),"(rebarbas,ressaltos permissíveis, etc.)",oFnt08,100)

oPrn:Line(nLin*103,nCol*35,nLin*106,nCol*35)

oPrn:Say (nLin*104,nCol*36,AllTrim(ZC2->ZC2_ACAB),oFnt09,100)
//---------------------B11---------------------------------------------
oPrn:Box(nLin*106,nColInc,nLin*112,nCol*114)  
oPrn:Line(nLin*106,nColInc+(nCol*3),nLin*112,nColInc+(nCol*3))                               
oPrn:Say (nLin*109,nColInc+10,"B11",oFnt09n,100) 
oPrn:SayBitmap(nLin*106,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*107,nColInc+(nCol*4),"Espeficicações de embalagem:",oFnt09n,100)

oPrn:Box(nLin*109,nColInc+(nCol*3),nLin*112,nCol*114)
oPrn:Say (nLin*110,nColInc+(nCol*4),"Cuidados a Serem Observados:",oFnt09n,100)
Do Case
	Case ZC2->ZC2_CUIDAD=="1"
		cCuidad:="Oxidação"
	Case ZC2->ZC2_CUIDAD=="2"
		cCuidad:="Contato"	 
	Case ZC2->ZC2_CUIDAD=="3"
		cCuidad:="Impacto"					
	Case ZC2->ZC2_CUIDAD=="4"
		cCuidad:="Oxidação/Contato/Impacto"
	Case ZC2->ZC2_CUIDAD=="5"
		cCuidad:="Outros"		
	OtherWise
		cCuidad:=""
EndCase	
oPrn:Say (nLin*110,nCol*31,cCuidad,oFnt09,100)//Oxidação/Contato/Impacto/Ambos
oPrn:Say (nLin*110,nCol*50,"Obs.:",oFnt09n,100)
oPrn:Say (nLin*110,nCol*55,AllTrim(ZC2->ZC2_OBS2),oFnt09,100)
//---------------------B12---------------------------------------------
oPrn:Box(nLin*112,nColInc,nLin*121,nCol*114)  
oPrn:Line(nLin*112,nColInc+(nCol*3),nLin*121,nColInc+(nCol*3))                               
oPrn:Say (nLin*115,nColInc+10,"B12",oFnt09n,100) 
oPrn:SayBitmap(nLin*112,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*113,nColInc+(nCol*4),"Requisitos da documentação de Aprovação e Desempenho da Qualidade",oFnt09n,100)

oPrn:Box(nLin*115,nColInc+(nCol*3),nLin*118,nCol*114)
oPrn:Say (nLin*116,nColInc+(nCol*4),"Processo de Aprovação requerido pelo Cliente:",oFnt09n,100)
oPrn:Say (nLin*116,nCol*41,AllTrim(ZC2->ZC2_APRCLI),oFnt09,100)

oPrn:Line(nLin*115,nCol*65,nLin*118,nCol*65)

oPrn:Say (nLin*116,nCol*66,"Quantidade de amostras:",oFnt09n,100)
oPrn:Say (nLin*116,nCol*83,AllTrim(ZC2->ZC2_QTDAMO),oFnt09,100)

oPrn:Box(nLin*118,nColInc+(nCol*3),nLin*121,nCol*114)
oPrn:Say (nLin*119,nColInc+(nCol*4),"Capabilidade requerida:",oFnt09n,100)
oPrn:Say (nLin*119,nCol*26,AllTrim(ZC2->ZC2_CAPAB),oFnt09,100)

oPrn:Line(nLin*118,nCol*65,nLin*121,nCol*65)

oPrn:Say (nLin*119,nCol*66,"Desempenho acordado (PPM):",oFnt09n,100)
oPrn:Say (nLin*119,nCol*86,AllTrim(ZC2->ZC2_PPM),oFnt09,100)
//---------------------B13---------------------------------------------

oPrn:Box(nLin*121,nColInc,nLin*130,nCol*114)  
oPrn:Line(nLin*121,nColInc+(nCol*3),nLin*130,nColInc+(nCol*3))                               
oPrn:Say (nLin*124,nColInc+10,"B13",oFnt09n,100) 
oPrn:SayBitmap(nLin*121,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*122,nColInc+(nCol*4),"Prazo de desenvolvimento (Aprovação Inicial)",oFnt09n,100)

oPrn:Box(nLin*124,nColInc+(nCol*3),nLin*127,nCol*114)
oPrn:Say (nLin*125,nColInc+(nCol*4),"Ferramental -> Projeto:",oFnt09n,100)
oPrn:Say (nLin*125,nCol*26,AllTrim(ZC2->ZC2_FERRAM),oFnt09,100)

oPrn:Line(nLin*124,nCol*65,nLin*127,nCol*65)

oPrn:Say (nLin*125,nCol*66,"Equipamento -> Projeto:",oFnt09n,100)
oPrn:Say (nLin*125,nCol*82,AllTrim(ZC2->ZC2_EQUIP2),oFnt09,100)

oPrn:Box(nLin*127,nColInc+(nCol*3),nLin*130,nCol*114)
oPrn:Say (nLin*128,nColInc+(nCol*4),"Dispositivo -> Projeto:",oFnt09n,100)
oPrn:Say (nLin*128,nCol*26,AllTrim(ZC2->ZC2_DISPCO),oFnt09,100)

oPrn:Line(nLin*127,nCol*65,nLin*130,nCol*65)

oPrn:Say (nLin*128,nCol*66,"Pré-série -> Projeto:",oFnt09n,100)
oPrn:Say (nLin*128,nCol*81,AllTrim(ZC2->ZC2_PRESE),oFnt09,100)
//---------------------B14---------------------------------------------

oPrn:Box(nLin*130,nColInc,nLin*145,nCol*114)  
oPrn:Line(nLin*130,nColInc+(nCol*3),nLin*145,nColInc+(nCol*3))                               
oPrn:Say (nLin*137,nColInc+10,"B14",oFnt09n,100) 
oPrn:SayBitmap(nLin*130,nColInc+(nCol*3),cBmpLinha,nCol*105,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*131,nColInc+(nCol*4),"Análise Técnica: Existe diferença significativa entre versões que impacte em custo?",oFnt09n,100)
oPrn:Say (nLin*131,nCol*66,IIF(Empty(ZC2->ZC2_ANATEC),"",IIF(ZC2->ZC2_ANATEC=="1","SIM","NÃO")),oFnt09n,100)
oPrn:Line(nLin*130,nCol*85,nLin*133,nCol*85)                                                                
oPrn:Say (nLin*131,nCol*86,"Sim, Relatar abaixo:",oFnt09n,100)

oPrn:Box(nLin*133,nColInc+(nCol*3),nLin*136,nCol*114)
oPrn:Box(nLin*136,nColInc+(nCol*3),nLin*139,nCol*114)
oPrn:Box(nLin*139,nColInc+(nCol*3),nLin*142,nCol*114)
oPrn:Box(nLin*142,nColInc+(nCol*3),nLin*145,nCol*114)

For nM := 1 to 4
	cLinhaObs	:=Memoline( ZC2->ZC2_RELAT ,160, nM ) 
	oPrn:Say (nLin*(134+nCont),nColInc+(nCol*4),cLinhaObs,oFnt09,100) 	       	
	nCont+=3	
Next nM

//---------------------Assinatura---------------------------------------------

oPrn:Box(nLin*145,nColInc,nLin*148,nCol*114)  
oPrn:Line(nLin*145,nCol*85,nLin*148,nCol*85)                                 
oPrn:Say (nLin*146,nColInc+nCol,"Análise Crítica Técnica Realizada por:",oFnt09n,100) 
oPrn:Say (nLin*146,nCol*35,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_EMITEN,"QAA_NOME")),oFnt09,100) 
oPrn:Say (nLin*146,nCol*60,"Aprovada por:",oFnt09n,100)
oPrn:Say (nLin*146,nCol*70,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_NOME")),oFnt09,100)
oPrn:Say (nLin*146,nCol*86,"Data Aprovação:",oFnt09n,100) 
oPrn:Say (nLin*146,nCol*99,AllTrim(DtoC(ZC2->ZC2_APPRO)),oFnt09,100)

Return ( )                                                                                                       
//===============================FIM DO BOX01 IDENTIFICAÇÃO =======================================================
