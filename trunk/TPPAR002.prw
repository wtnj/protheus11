#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR002  º Autor ³ HANDERSON DUARTE   º Data ³  17/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Matriz de Correlação do Processo                 º±±
±±º          ³ REFERENTE AO FONTE TPPAC001
	Manutenção : José Henrique Medeiros Felipetto
	|----- Implementação do Loop que escreve as Características e Operações                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================

User Function TPPAR002 ( )

Local 	alRet		:=	{.T.,.T.} 
Local 	nPagOP		:=	0 
Local   nPagNOP     	:= 	" "
Local 	nContPag	:=	1
Local 	ContCol		:=	1
Private cLogo			:= 	"\system\WHBL.bmp"
Private nContLin		:=	0 
Private nContCol		:=	0
Private cBmpLogo		:= 	"\system\logo_whb.bmp"
Private nRecNo		:=	ZC5->(RecNo())
Private nAlt			:= 	280
	
Private oFnt06		:= 	TFont():New("Arial",,06,,.f.,,,,,.f.)
Private oFnt22		:= 	TFont():New("Arial",,22,,.f.,,,,,.f.)
Private oFnt08		:= 	TFont():New("Arial",,08,,.f.,,,,,.f.)
Private oFnt08n		:= 	TFont():New("Arial",,08,,.t.,,,,,.f.)
Private oFnt09		:= 	TFont():New("Arial",,09,,.f.,,,,,.f.)
Private oFnt09n		:= 	TFont():New("Arial",,09,,.t.,,,,,.f.)
Private oFnt11		:= 	TFont():New("Arial",,11,,.f.,,,,,.f.)
Private oFnt11n		:= 	TFont():New("Arial",,11,,.t.,,,,,.f.)
Private oFnt14		:= 	TFont():New("Arial",,14,,.f.,,,,,.f.)
Private oFnt14n		:= 	TFont():New("Arial",,14,,.t.,,,,,.f.)
Private oFnt16		:= 	TFont():New("Arial",,16,,.f.,,,,,.f.)
Private oFnt16n		:=	TFont():New("Arial",,16,,.t.,,,,,.f.)
Private oFnt17n		:= 	TFont():New("Arial",,09,,.T.,,,,,.F.) 
Private oFnt18n		:= 	TFont():New("Arial",,06,,.F.,,,,,.F.)
Private oFnt19n     	:=     TFont():New("Arial",,16,,.T.,,,,,.F.)
	
Private nLinInc		:=	20*5
Private nColInc		:=	20*6
Private aDados		:=	{}
Private aOperac		:=	{}
Private aCaract		:=	{}
Private aNcarac     	:= 	{}
Private aNoper		:=  	{}  
Private _aCar 			:= 	{}
Private nCont2 		:=     1	
Private nCol			:=	20
Private nLin			:=	20
Private nAlt2			:=   	240

oPrn := TMSPrinter():New("MATRIZ DE CORRELAÇÃO DO PROCESSO")//Cria Objeto para impressao Grafica
oPrn:Setup()//Chama a rotina de Configuracao da impressao
oPrn:SetLandScape()//SetPortrait()

lRel:=sfDados() 
If lRel
	nPagOP:=IIF( Len(aOperac)/15 <=1,1,Int(Len(aOperac)/15)+IIF((Len(aOperac)%15)>0,1,0))
	Do While nContPag<=nPagOP //.AND. (alRet[1] .OR. (!alRet[1] .AND. alRet[2]) )
		oPrn:StartPage()//Cria nova Pagina 
			sfCabec()//Impressao do Cabecalho			
			sfBOX01()
			alRet:=sfDadosGr(nContPag,ContCol)
//			nContPag:=IIF((alRet[1] .AND.!alRet[2]).OR.(!alRet[1] .AND.!alRet[2]) ,nContPag+1,nContPag)							
			nContPag:=IIF(!alRet[2] ,nContPag+1,nContPag)							
			ContCol	:=IIF(alRet[2],ContCol+1,1)														
		oPrn:EndPage()//Finaliza a Pagina
	EndDo
Else 
	MsgAlert("Relatório vazio")
EndIf
nCont := 1
oPrn:StartPage()
oPrn:SayBitmap(nLinInc+10,nColInc+10,cLogo,nCol*10,10+nLin*3)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)     
oPrn:Say(110,380,"Lista de descrição das características.",oFnt19n)
For nCont := 1 to Len(_aCar)
	//oPrn:Line(240,100,240,180)
	//oPrn:Line(nAlt2,100,nAlt2,180)
	oPrn:Say(nAlt,100,_aCar[nCont][1],oFnt16n)
	oPrn:Say(nAlt,180,_aCar[nCont][2],oFnt16n)
	nAlt += 80 
	//nAlt2 += 100
Next nCont  
oPrn:EndPage()
oPrn:Preview()

Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//==========================DADOS PARA A GRADE =====================================
Static Function sfDadosGr(nPag,nColPag)
Local nLin		:=20
Local nCol		:=20 
Local nCont		:=0
Local nContL	:=0
Local nContC	:=0
Local nConItem	:=0
Local alRet		:={.F.,.F.} //Flag para linha e coluna {lPágina,lColuna}. O primeiro sinaliza para contar a página e o segunto só para as colunas sem contar as páginas
Local nMaxCol	:=28
Local nMaxLin	:=15 
Local nColCont	:=	0
Local nLinCont	:=	0 
Local cTemp		:=""

//==============Faz os títulos das operações e características
For nCont := IIF(nPag==1,1,((nPag-1)*nMaxLin)+1) to nMaxLin*nPag                      
	If nCont>Len(aOperac)
		nCont:=nMaxLin*nPag	
    Else
    	cTemp:=AllTrim(Posicione("ZCF",1,xFilial("ZCF")+aOperac[nCont],"ZCF_NOPE"))
		oPrn:Say (nLin*(36+nConItem),nCol+nColInc,Left(cTemp,12),oFnt08n,100)//Linhas
		oPrn:Say (nLin*(38+nConItem),nCol+nColInc,Substr(cTemp,13,Len(cTemp)),oFnt08n,100)//Linhas		
		nConItem+=5
		nContLin++//Controle de linhas
	EndIf	
Next nCont 

nConItem:=0

For nCont:=IIF(nColPag==1,1,((nColPag-1)*nMaxCol)+1) to nMaxCol*nColPag
	If nCont>Len(aCaract)
		nCont:=nMaxCol*nColPag
	Else
    	cTemp:=AllTrim(Posicione("ZCF",1,xFilial("ZCF")+aCaract[nCont],"ZCF_NCARAC"))	
		oPrn:Say (nLin*23,nCol*(20+nConItem),Substr(cTemp,1,4),oFnt08n,100)//Colunas
		oPrn:Say (nLin*25,nCol*(20+nConItem),Substr(cTemp,5,4),oFnt08n,100)//Colunas
		oPrn:Say (nLin*27,nCol*(20+nConItem),Substr(cTemp,9,4),oFnt08n,100)//Colunas
		oPrn:Say (nLin*29,nCol*(20+nConItem),Substr(cTemp,13,4),oFnt08n,100)//Colunas			
		oPrn:Say (nLin*31,nCol*(20+nConItem),Substr(cTemp,17,3),oFnt08n,100)//Colunas		
		nConItem+=5	
		nContCol++//Controle de colunas
	EndIf
Next nCont
// ===============fim dos títulos

For nContL:=IIF(nPag==1,1,((nPag-1)*nMaxLin)+1) to nContLin 
	For nContC:=IIF(nColPag==1,1,((nColPag-1)*nMaxCol)+1) to nContCol
		If (aScan(aDados,{|aVal| (aVal[3]==nContL .AND. aVal[4]==nContC) }))<>0		     
			oPrn:Say (nLin*(37+nLinCont),nCol*(21+nColCont),"XX",oFnt09n,100)//Colunas	     
		EndIf
		nColCont+=5
	Next nContC
	nLinCont+=5
	nColCont:=0
Next nContL

alRet[1]:=IIF(Len(aOperac)>nMaxLin*(nPag),.T.,.F.) //Verifica se irá para a próxima página
alRet[2]:=IIF(Len(aCaract)>nMaxCol*(nColPag),.T.,.F.) //Se for inserido mais uma página de coluna, a página não será incrementada

Return (alRet) 
//==========================FIM DOS DADOS PARA A GRADE =====================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin	:=	20
Local nCol	:=	20
Local cNota	:=	""
Local aAreaZC5	:= ZC5->(GetArea()) 
DBSelectArea("ZC5")
ZC5->(DBGoTo(nRecNo))

oPrn:Box(nLinInc,nColInc,nLin*9,nCol*160) //Box 1 do Cabeçalho 
oPrn:Box(nLin*9,nColInc,nLin*12,nCol*160) //Box 2 do Cabeçalho 
oPrn:Box(nLin*12,nColInc,nLin*15,nCol*160) //Box 3 do Cabeçalho 
oPrn:Box(nLin*15,nColInc,nLin*18,nCol*160) //Box 4 do Cabeçalho 
oPrn:Line(nLin*9,nCol*100,nLin*12,nCol*100) //Coluna do Cabeçalho
oPrn:Line(nLin*12,nCol*113,nLin*15,nCol*113) //Coluna do Cabeçalho
oPrn:Box(nLin*18,nColInc,nLin*22,nCol*160) //Box 5 do Cabeçalho 
oPrn:SayBitmap(nLinInc+10,nColInc+10,cBmpLogo,nCol*10,10+nLin*3)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)     
oPrn:Say (nLinInc+nLin,nCol*50,"MATRIZ DE CORRELAÇÃO DO PROCESSO",oFnt16n,100) 
oPrn:Say (nLinInc+nLin,nCol*108,AllTrim(ZC5->ZC5_CODMAT),oFnt11n,100)  
oPrn:Say (nLinInc+nLin,nCol*116,"/",oFnt11n,100)
oPrn:Say (nLinInc+nLin,nCol*117,AllTrim(ZC5->ZC5_REV),oFnt11n,100) 

oPrn:Say (nLin*10,nColInc+nCol,"CLIENTE",oFnt09n,100)
oPrn:Say (nLin*10,nCol*15,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC5->ZC5_CODCLI+ZC5->ZC5_LOJA,"A1_NOME")),oFnt08,100)
oPrn:Say (nLin*10,nCol*101,"CÓD. PRODUTO",oFnt09n,100)
oPrn:Say (nLin*10,nCol*115,AllTrim(ZC5->ZC5_CODPRO),oFnt08,100)

oPrn:Say (nLin*13,nColInc+nCol,"DESC.PRODUTO",oFnt09n,100)
oPrn:Say (nLin*13,nCol*21,AllTrim(Posicione("SB1",1,xFilial("SB1")+ZC5->ZC5_CODPRO,"B1_DESC")),oFnt08,100)
oPrn:Say (nLin*13,nCol*114,"REV. DESENHO",oFnt09n,100)
oPrn:Say (nLin*13,nCol*127,AllTrim(ZC5->ZC5_REV),oFnt08,100)

oPrn:Say (nLin*16,nColInc+nCol,"EQUIPE",oFnt09n,100)
oPrn:Say (nLin*16,nCol*15,AllTrim(ZC5->ZC5_EQUIPE),oFnt08,100)
cNota:="Nota: A Lista de Correlação deve incluir os seguintes itens: "
cNota+="Especificações de Desenho; Características indicadas pelo Cliente e Características de Processo (definição WHB) "
oPrn:Say (nLin*20,nColInc+nCol,cNota,oFnt09n,100)

RestArea(aAreaZC5)
Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 GRADE DE IMPRESSÃO =======================================================
Static Function sfBOX01()
Local nLin:=20
Local nCol:=20 
Local nCont:=0
Local nConItem:=0   
Local nLar := 420 
Local nDesc
Local nAlt := 100

oPrn:Box(nLin*22,nColInc,nLin*35,nCol*160) //Box 1 do Cabeçalho 
oPrn:Box(nLin*35,nColInc,nLin*113,nCol*160) //Box 2 do Cabeçalho 
oPrn:Line(nLin*22,nCol*20,nLin*113,nCol*20) //Coluna
oPrn:Line(nLin*22,nCol*20,nLin*35,nColInc) //Linha da Operaçao / Característica
oPrn:Say (nLin*23,nColInc,"CARACTERÍSTICAS",oFnt08n,100)
oPrn:Say (nLin*33,nColInc+nCol*2,"OPERAÇÕES",oFnt08n,100)
For nCont:=1 to 15
	oPrn:Line(nLin*(35+nConItem),nColInc,nLin*(35+nConItem),nCol*160) //Linhas
	nConItem+=5
Next nCont 
nConItem:=0
For nCont:=1 to 28 
	oPrn:Line(nLin*22,nCol*(20+nConItem),nLin*113,nCol*(20+nConItem)) //Colunas
	nConItem+=5
Next nCont  
 
nCont := 0

ZCF->(DbSetOrder(3) )//ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2
ZCF->(DbSeek(xFilial("ZCF")+ ZC5->ZC5_CODMAT + ZC5->ZC5_REV2))                                                                                                                                  
QKK->(DbSetOrder(2) ) // QKK_FILIAL+QKK_PECA+QKK_REV+QKK_NOPE  
Do While ( ZCF->(!EOF() .AND. ZCF->ZCF_CODMAT ==  ZC5->ZC5_CODMAT .AND. ZC5->ZC5_REV2 = ZCF->ZCF_REV2 ))
	QKK->(DbSeek(xFilial("QKK")+ ZCF->ZCF_CODPRO + ZCF->ZCF_REV + ZCF->ZCF_CODOP))
	If nCont <= 15
	   	oPrn:Say(nLar + 300,160,QKK->QKK_DESC,oFnt17n) // Descrição da Característica
	EndIf
	If nCont <= 28
		oPrn:Say(530,nLar,ZCF->ZCF_CODCAR,oFnt17n) // Código da Característica
	EndIf
	Aadd(_aCar,{ZCF->ZCF_CODCAR,ZCF->ZCF_NCARAC})
	ZCF->(DbSkip() )
	nLar += 100
	nCont += 1
EndDo    
Return ( ) 
//=====================================DADOS PARA MATRIZ ===============================================================
Static Function	sfDados()
Local aAreaZCF	:=	ZCF->(GetArea())
Local aAreaZC5	:=	ZC5->(GetArea())
Local cMatriz		:=	ZC5->ZC5_CODMAT
Local cRevisao	:=	ZC5->ZC5_REV2
Local lRet		:=	.F. 
Local cCodOP		:=	"" 
Local cCodCAR	:=	""
Local cCodNOP   :=  ""
Local cCodNCAR  :=  ""

DBSelectArea("ZC5")
ZC5->(DBSetOrder(2))  //ZC5_FILIAL, ZC5_CODMAT, ZC5_REV2
ZC5->(DBSeek(xFilial("ZC5")+cMatriz))
While ZC5->(!EoF()) .AND. (xFilial("ZC5")+cMatriz) == (xFilial("ZC5")+ZC5->ZC5_CODMAT)
	cRevisao	:=	ZC5->ZC5_REV2
	nRecNo		:=	ZC5->(RecNo())	
	ZC5->(DBSkip())
EndDo

ZC5->(DBGoto(nRecNo))

If ZC5->ZC5_APROV=="S" .AND. ZC5->ZC5_STAREV
	DBSelectArea("ZCF")
	ZCF->(DBSetOrder(1))//ZCF_FILIAL, ZCF_CODMAT, ZCF_CODOP, ZCF_CODCAR
	ZCF->(DBgoTop())
	If ZCF->(DBSeek(xFilial("ZCF")+cMatriz+cRevisao))
		cCodOP:=ZCF->ZCF_CODOP
		cCodNOP:=ZCF->ZCF_NOPE
		aAdd(aOperac,ZCF->ZCF_CODOP) //Todas as Operações	
		Do While ZCF->(!EoF()) .AND. ZCF->ZCF_FILIAL=xFilial("ZCF") .AND. cMatriz=ZCF->ZCF_CODMAT .AND. cRevisao=ZCF->ZCF_REV2
			If cCodOP<>ZCF->ZCF_CODOP
				cCodOP:=ZCF->ZCF_CODOP
				cCodNOP:=ZCF->ZCF_NOPE
				aAdd(aOperac,ZCF->ZCF_CODOP) //Todas as Operações			
			EndIf
			ZCF->(DBSkip())
		EndDo	
	EndIf
	
	ZCF->(DBSetOrder(2))//ZCF_FILIAL, ZCF_CODMAT, ZCF_CODCAR, ZCF_CODOP
	ZCF->(DBgoTop())
	If ZCF->(DBSeek(xFilial("ZCF")+cMatriz+cRevisao))
		cCodCAR:=ZCF->ZCF_CODCAR
		cCodNCAR:=ZCF->ZCF_NCARAC
		aAdd(aCaract,ZCF->ZCF_CODCAR) //Totas as características	
		Do While ZCF->(!EoF()) .AND. ZCF->ZCF_FILIAL=xFilial("ZCF") .AND. cMatriz=ZCF->ZCF_CODMAT .AND. cRevisao=ZCF->ZCF_REV2
			If cCodCAR<>ZCF->ZCF_CODCAR
				cCodCAR:=ZCF->ZCF_CODCAR  
				cCodNCAR:=ZCF->ZCF_NCARAC
				aAdd(aCaract,ZCF->ZCF_CODCAR) //Totas as características			
			EndIf	
		    aAdd(aDados,{ZCF->ZCF_CODOP,ZCF->ZCF_CODCAR,AScan(aOperac,ZCF->ZCF_CODOP),AScan(aCaract,ZCF->ZCF_CODCAR)})   //Matriz de Correlação
			ZCF->(DBSkip())
		EndDo	
	EndIf
EndIf

RestArea(aAreaZCF)
RestArea(aAreaZC5)
lRet:=IIF(Empty(aDados),.F.,.T.)
Return(lRet)
//=====================================FIM DOS DADOS PARA MATRIZ =======================================================                                                                                                      
//=====================================FIM DO BOX01 GRADE DE IMPRESSÃO =================================================

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


