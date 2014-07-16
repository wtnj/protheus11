#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR014  º Autor ³ HANDERSON DUARTE   º Data ³  01/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Relação dos Meios de Controle                    º±±
±±º          ³ REFERENTE AO FONTE TPPAC015                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR014 ( )
Local 	lFlag		:=	.T.
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
Private oFnt11		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt11n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt12		:= TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt12n		:= TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt14		:= TFont():New("Arial",,14,,.f.,,,,,.f.)
Private oFnt14n		:= TFont():New("Arial",,14,,.t.,,,,,.f.)
Private oFnt16		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt16n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)
Private oFnt20		:= TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt20n		:= TFont():New("Arial",,16,,.t.,,,,,.f.)
	
Private nLinInc		:=	20*5
Private nColInc		:=	20*6
Private aAreaZCA	:=	ZCA->(GetArea())
Private aAreaZCI	:=	ZCI->(GetArea())
Private nRecNo		:=	0
Private cMEIOS		:=	ZCA->ZCA_MEIOS 
Private nMaxItem	:=	40
Private nContItem	:=	1
Private nItem		:=	1
 
DBSelectArea("ZCA")
ZCA->(DBGotop())
ZCA->(DBSetOrder(1))//ZCA_FILIAL, ZCA_ACC, ZCA_REV, R_E_C_N_O_, D_E_L_E_T_
ZCA->(DBSeek(xFilial("ZCA")+cMEIOS))
While ZCA->(!EoF()) .AND. (ZCA->ZCA_FILIAL+ZCA->ZCA_MEIOS) == (xFilial("ZCA")+cMEIOS)
	If ZCA->ZCA_STAREV .AND. ZCA->ZCA_STATUS="S"
		nRecNo		:=	ZCA->(RecNo())
	EndIf
	ZCA->(DBSkip())
EndDo

ZCA->(DBGoTo(nRecNo))

oPrn := TMSPrinter():New("Relação dos Meios de Controle")//Cria Objeto para impressao Grafica
oPrn:Setup()//Chama a rotina de Configuracao da impressao
//oPrn:SetLandScape()
oPrn:SetPortrait()
If ZCA->ZCA_STAREV .AND. ZCA->ZCA_STATUS="S"
	DbSelectArea("ZCI")
	ZCI->(DBSetOrder(1))//ZCI_FILIAL, ZCI_MEIOS, ZCI_REV, ZCI_ITEM, R_E_C_N_O_, D_E_L_E_T_
	If ZCI->(DBseek(xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)+StrZero(nItem,2)))
		Do While ZCI->(!EoF()) .AND. lFlag
			oPrn:StartPage()//Cria nova Pagina 
				sfCabec()//Impressao do Cabecalho							
				sfBOX01()
				sfDados()//Dados do Box01
				If ZCI->(DBseek(xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)+StrZero(nItem,2)))
					lFlag:=.T.
				Else
					lFlag:=.F.
					sfRodaPe()
				EndIf					
			oPrn:EndPage()//Finaliza a Pagina                                      
		EndDo
	EndIf
EndIf
oPrn:Preview()
RestArea(aAreaZCA)
RestArea(aAreaZCI)
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLinInc,nColInc,nLin*23,nCol*114) //Box do Cabeçalho
oPrn:SayBitmap(nLin*10,nColInc+nCol,cBmpLogo,nCol*18,nLin*7)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)     
oPrn:Say (nLin*10,nCol*45,"RELAÇÃO DE MEIOS DE CONTROLE",oFnt20n,100)
oPrn:Say (nLin*10,nCol*95,AllTrim(ZCA->ZCA_MEIOS),oFnt12,100) 
oPrn:Say (nLin*10,nCol*105,"/",oFnt20n,100)
oPrn:Say (nLin*10,nCol*106,AllTrim(ZCA->ZCA_REV),oFnt12,100)
  
oPrn:Say (nLin*18,nColInc+nCol,"Descrição do Desenvolvimento:",oFnt12n,100) 
oPrn:Say (nLin*18,nCol*33,AllTrim(ZCA->ZCA_APQP),oFnt12,100) 

oPrn:Say (nLin*20,nColInc+nCol,"Produto/Cod:",oFnt12n,100) 
oPrn:Say (nLin*20,nCol*18,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZCA->(ZCA_PROD+ZCA_REVPC),"QK1_DESC"))+" / "+AllTrim(ZCA->ZCA_PROD)+"-"+AllTrim(ZCA->ZCA_REVPC),oFnt12,100) 

oPrn:Say (nLin*18,nCol*87,"Nº APQP:",oFnt12n,100) 
oPrn:Say (nLin*18,nCol*95,AllTrim(ZCA->ZCA_APQP),oFnt12,100) 

Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX 01 Impressão do Cabeçalho e Lista de Itens==========================
Static Function sfBOX01()
Local nLin:=20
Local nCol:=20
Local nCont:=0
Local nContLin:=3

oPrn:Box(nLin*23,nColInc,nLin*26,nCol*114) //Box do Cabeçalho
oPrn:Box(nLin*23,nColInc,nLin*146,nCol*114) //Box dos Itens
oPrn:Line(nLin*23,nColInc+(nCol*5),nLin*146,nColInc+(nCol*5)) //Coluna 1
oPrn:Line(nLin*23,nCol*32,nLin*146,nCol*32) //Coluna 2
oPrn:Line(nLin*23,nCol*37,nLin*146,nCol*37) //Coluna 3
oPrn:Line(nLin*23,nCol*57,nLin*146,nCol*57) //Coluna 4
oPrn:Line(nLin*23,nCol*83,nLin*146,nCol*83) //Coluna 5
oPrn:Line(nLin*23,nCol*92,nLin*146,nCol*92) //Coluna 6

For nCont:=1 to  nMaxItem
	oPrn:Line(nLin*(23+nContLin),nColInc,nLin*(23+nContLin),nCol*114) //linha  	
	nContLin:=nContLin+3	
Next nCont 

oPrn:Say (nLin*24,nColInc+nCol,"Nº",oFnt12n,100) 
oPrn:Say (nLin*24,nCol*15,"DESCRIÇÃO",oFnt12n,100) 
oPrn:Say (nLin*24,nCol*33,"OP",oFnt12n,100)  //2
oPrn:Say (nLin*24,nCol*38,"LOCALIZAÇÃO",oFnt12n,100) //3
oPrn:Say (nLin*24,nCol*58,"CODIGO P/ GRAVAÇÃO",oFnt12n,100) //4
oPrn:Say (nLin*24,nCol*84,"RBC",oFnt12n,100)    //5
oPrn:Say (nLin*24,nCol*100,"OBS",oFnt12n,100)    //6

Return ( )

//=====================================Fim do BOX 01 Impressão do Cabeçalho e Lista de Itens===================
//=====================================Dados dos Box01 ========================================================
Static Function sfDados()
Local nLin		:=	20
Local nCol		:=	20
Local nCont		:=	0
Local nContLin	:=	3
Local lFlag		:=	.T.
Local aArea		:=	ZCI->(GetArea())

DbSelectArea("ZCI")
ZCI->(DBSetOrder(1))//ZCI_FILIAL, ZCI_MEIOS, ZCI_REV, ZCI_ITEM, R_E_C_N_O_, D_E_L_E_T_
If ZCI->(DBseek(xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)+StrZero(nItem,2)))
	Do While ZCI->(!EoF()) .AND. ZCI->(ZCI_FILIAL+ZCI_MEIOS+ZCI_REV+ZCI_ITEM) == (xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)+StrZero(nItem,2)) .AND. lFlag
		oPrn:Say (nLin*(24+nContLin),nColInc+nCol,AllTrim(ZCI->ZCI_ITEM),oFnt07,100) 
		oPrn:Say (nLin*(23+nContLin)+5,nColInc+(nCol*5),Left(allTrim(ZCI->ZCI_DESCR),20),oFnt07,100) 
		oPrn:Say (nLin*(24+nContLin)+10,nColInc+(nCol*5),Left(SubStr(allTrim(ZCI->ZCI_DESCR),21,Len(allTrim(ZCI->ZCI_DESCR))),20),oFnt07,100) 
		oPrn:Say (nLin*(24+nContLin),nCol*32,allTrim(ZCI->ZCI_NOPE),oFnt07,100)  //2
		oPrn:Say (nLin*(24+nContLin),nCol*38,Left(allTrim(Posicione("QKK",2,xFilial("QKK")+ZCA->(ZCA_PROD+ZCA_REVPC)+ZCI->ZCI_NOPE,"QKK_DESC")),30),oFnt07,100) //3
		oPrn:Say (nLin*(24+nContLin),nCol*58,allTrim(ZCI->ZCI_CODINS),oFnt07,100) //4
		oPrn:Say (nLin*(24+nContLin),nCol*84,allTrim(IIF(ZCI->ZCI_RBC=="S","SIM",IIF(ZCI->ZCI_RBC=="N","NAO",""))),oFnt07,100)    //5
		oPrn:Say (nLin*(23+nContLin)+5,nCol*92,Left(allTrim(ZCI->ZCI_OBS),20),oFnt07,100)    //6
		oPrn:Say (nLin*(24+nContLin)+10,nCol*92,Left(SubStr(allTrim(ZCI->ZCI_OBS),21,Len(allTrim(ZCI->ZCI_OBS))),20),oFnt07,100)    //6		
		ZCI->(DBSkip())
		nContItem++
		nItem++
		nContLin:=nContLin+3
		If nContItem>nMaxItem
			lFlag		:=	.F.
			nContItem   :=	1
			nContLin	:=	0
		EndIf
	EndDo
EndIf
RestArea(aArea)
Return ( )

//=====================================Dados dos Box01 ========================================================
//=====================================Rodapé do relatório com as assinaturas =================================
Static Function sfRodaPe()
Local nLin:=20
Local nCol:=20

oPrn:Say (nLin*149,nColInc+nCol,"Nome do Elaborador da Engenharia:",oFnt12,100) 
oPrn:Line(nLin*157,nColInc+nCol,nLin*157,nCol*50) //Linha
oPrn:Say (nLin*158,nColInc+nCol,"Assinatura - "+AllTrim(Posicione("QAA",1,xfilial("QAA")+ZCA->ZCA_EMIENG,"QAA_NOME")),oFnt12n,100)

oPrn:Say (nLin*149,nCol*57,"Nome do Resp. da Qualidade pela Analise:",oFnt12,100)
oPrn:Line(nLin*157,nCol*57,nLin*157,nCol*107) //linha
oPrn:Say (nLin*158,nCol*57,"Assinatura - "+AllTrim(Posicione("QAA",1,xfilial("QAA")+ZCA->ZCA_RESMET,"QAA_NOME")),oFnt12n,100)

Return ( )

//=====================================Rodapé do relatório com as assinaturas =================================
