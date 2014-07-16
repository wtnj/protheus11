#INCLUDE "rwmake.ch" 
#include "JPEG.CH"   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR001  º Autor ³ HANDERSON DUARTE   º Data ³  11/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Descritivo de Embalagem                          º±±
±±º          ³ REFERENTE AO FONTE TPPAC001                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR001 ( ) 
Private cBmpLogo	:= "\system\logo_whb.bmp"
Private cBmpLinha	:= "\system\LinhaVerde.bmp"
Private cBmpAzul	:= "\system\LinhaAzul.bmp"
//Private cBmpFoto	:= AllTrim(GetMV("MV_PPAPFOT"))
Private aFotos		:={}
	
Private oFnt06		:= TFont():New("Arial",,06,,.f.,,,,,.f.)
Private oFnt22		:= TFont():New("Arial",,22,,.f.,,,,,.f.)
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
Private aArea		:=	ZC3->(GetArea())   
Private nRecNo		:=	0
Private cNUMEMB		:=	ZC3->ZC3_NUMEMB
DBSelectArea("ZC3")
ZC3->(DBGoTop())
ZC3->(DBSetOrder(3))//ZC3_FILIAL, ZC3_NUMEMB, ZC3_REV, ZC3_APROV
ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB))
While ZC3->(!EoF()) .AND. (xFilial("ZC3")+ZC3->ZC3_NUMEMB) == (xFilial("ZC3")+cNUMEMB)
	If ZC3->ZC3_STAREV
		nRecNo		:=	ZC3->(RecNo())
	EndIf
	ZC3->(DBSkip())
EndDo

ZC3->(DBGoTo(nRecNo))

oPrn := TMSPrinter():New("DESCRITIVO DE EMBALAGEM")//Cria Objeto para impressao Grafica 
oPrn:Setup()//Chama a rotina de Configuracao da impressao                                       


oPrn:StartPage()//Cria nova Pagina 
If ZC3->ZC3_STAREV 
	sfCabec()//Impressao do Cabecalho
	sfBOX01() 
	sfBOX02()
	sfBOX03() 
	sfBOX04()			
	sfBOX05()
	sfBOX06()
	sfBOX07()
EndIf								
oPrn:EndPage()//Finaliza a Pagina
oPrn:Preview()
RestArea(aArea)
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLinInc,nColInc,nLin*19,nCol*114) //Box do Cabeçalho
oPrn:Box(nLin*19,nColInc,nLin*22,nCol*114) //Box do Cabeçalho
oPrn:Box(nLin*22,nColInc,nLin*29,nCol*114) //Box do Cabeçalho
oPrn:Line(nLin*22,nCol*36,nLin*29,nCol*36) //Coluna do Cabeçalho
oPrn:Line(nLin*22,nCol*86,nLin*29,nCol*86) //Coluna do Cabeçalho 
oPrn:SayBitmap(nLinInc+nLin,nColInc+nCol,cBmpLogo,nCol*18,nLin*7)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)     
oPrn:SayBitmap(nLin*19,nColInc,cBmpLinha,nCol*108,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*14,nCol*43,"DESCRITIVO EMBALAGEM",oFnt16n,100)
oPrn:Say (nLin*14,nCol*103,AllTrim(ZC3->ZC3_NUMEMB),oFnt11n,100)
oPrn:Say (nLin*14,nCol*110,"/",oFnt11n,100)
oPrn:Say (nLin*14,nCol*111,AllTrim(ZC3->ZC3_REV),oFnt11n,100) 
   
oPrn:Say (nLin*20,nCol*48,"DADOS DA PEÇA",oFnt11n,100) 

oPrn:Say (nLin*23,nColInc+nCol,"CLIENTE",oFnt09n,100)
oPrn:Say (nLin*23,nCol*15,Left(AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC3->ZC3_CODCLI+ZC3->ZC3_LOJACL,"A1_NOME")),20),oFnt08,100)
oPrn:Say (nLin*27,nColInc+nCol,"REFEREN",oFnt09n,100)
oPrn:Say (nLin*27,nCol*15,AllTrim(ZC3->ZC3_REFER),oFnt08,100)

oPrn:Say (nLin*23,nCol*37,"NOM.PEÇA",oFnt09n,100)
oPrn:Say (nLin*23,nCol*46,Left(AllTrim(Posicione("SB1",1,xFilial("SB1")+ZC3->ZC3_CODWHB,"B1_DESC")),20),oFnt08,100)
oPrn:Say (nLin*27,nCol*37,"CÓDIGO",oFnt09n,100)
oPrn:Say (nLin*27,nCol*46,AllTrim(ZC3->ZC3_CODWHB),oFnt08,100)

oPrn:Say (nLin*23,nCol*87,"DATA",oFnt09n,100)
oPrn:Say (nLin*23,nCol*97,DtoC(ZC3->ZC3_DATA),oFnt08,100)
oPrn:Say (nLin*27,nCol*87,"PESO UNIT.",oFnt09n,100)
oPrn:Say (nLin*27,nCol*97,AllTrim(Transform(ZC3->ZC3_PESOUN, PesqPict("ZC3","ZC3_PESOUN"))),oFnt08,100)

Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 U.C. =======================================================
Static Function sfBOX01()
Local nLin:=20
Local nCol:=20 
oPrn:Box(nLin*29,nColInc,nLin*30,nCol*114) //Box 1
oPrn:Box(nLin*30,nColInc,nLin*36,nCol*114) //Box 2
oPrn:Box(nLin*36,nColInc,nLin*44,nCol*114) //Box 3
oPrn:Line(nLin*36,nCol*35,nLin*44,nCol*35) //Coluna 1
oPrn:Line(nLin*36,nCol*53,nLin*44,nCol*53) //Coluna 2
oPrn:Line(nLin*36,nCol*73,nLin*44,nCol*73) //Coluna 3
oPrn:Line(nLin*36,nCol*85,nLin*44,nCol*85) //Coluna 4
oPrn:Line(nLin*36,nCol*99,nLin*44,nCol*99) //Coluna 5

oPrn:Say (nLin*31,nCol*15,"U.C.",oFnt09n,100)
oPrn:Say (nLin*34,nCol*10,"Unidade de Acondicinamento",oFnt09n,100)  
oPrn:Say (nLin*37,nColInc+nCol,AllTrim(ZC3->ZC3_UC),oFnt08,100)
oPrn:Say (nLin*39,nColInc+nCol,AllTrim(ZC3->ZC3_UC2),oFnt08,100)
oPrn:Say (nLin*41,nColInc+nCol,AllTrim(ZC3->ZC3_UC3),oFnt08,100)

oPrn:Say (nLin*31,nCol*41,"TIPO ou",oFnt09,100)
oPrn:Say (nLin*34,nCol*41,"Nº da EMB",oFnt09n,100) 
oPrn:Say (nLin*37,nCol*36,AllTrim(ZC3->ZC3_UCTIPO),oFnt08,100)
oPrn:Say (nLin*39,nCol*36,AllTrim(ZC3->ZC3_UCTP2),oFnt08,100)
oPrn:Say (nLin*41,nCol*36,AllTrim(ZC3->ZC3_UCTP3),oFnt08,100)

oPrn:Say (nLin*31,nCol*58,"DIMENSÕES",oFnt09,100)
oPrn:Say (nLin*34,nCol*58,"(C X L X H)",oFnt09n,100)
oPrn:Say (nLin*37,nCol*54,AllTrim(Transform(ZC3->ZC3_UCCOM	,PesqPict("ZC3","ZC3_UCCOM") )),oFnt08,100)
oPrn:Say (nLin*37,nCol*58," X ",oFnt09n,100)
oPrn:Say (nLin*37,nCol*60,AllTrim(Transform(ZC3->ZC3_UCLARG	,PesqPict("ZC3","ZC3_UCLARG") )),oFnt08,100)
oPrn:Say (nLin*37,nCol*64," X ",oFnt09n,100)
oPrn:Say (nLin*37,nCol*67,AllTrim(Transform(ZC3->ZC3_UCALT	,PesqPict("ZC3","ZC3_UCALT") )),oFnt08,100)

oPrn:Say (nLin*39,nCol*54,AllTrim(Transform(ZC3->ZC3_UCCOM2	,PesqPict("ZC3","ZC3_UCCOM2") )),oFnt08,100)
oPrn:Say (nLin*39,nCol*58," X ",oFnt09n,100)
oPrn:Say (nLin*39,nCol*60,AllTrim(Transform(ZC3->ZC3_UCLAR2	,PesqPict("ZC3","ZC3_UCLAR2") )),oFnt08,100)
oPrn:Say (nLin*39,nCol*64," X ",oFnt09n,100)
oPrn:Say (nLin*39,nCol*67,AllTrim(Transform(ZC3->ZC3_UCALT2	,PesqPict("ZC3","ZC3_UCALT2") )),oFnt08,100) 

oPrn:Say (nLin*41,nCol*54,AllTrim(Transform(ZC3->ZC3_UCCOM3	,PesqPict("ZC3","ZC3_UCCOM3") )),oFnt08,100)
oPrn:Say (nLin*41,nCol*58," X ",oFnt09n,100)
oPrn:Say (nLin*41,nCol*60,AllTrim(Transform(ZC3->ZC3_UCLAR3	,PesqPict("ZC3","ZC3_UCLAR3") )),oFnt08,100)
oPrn:Say (nLin*41,nCol*64," X ",oFnt09n,100)
oPrn:Say (nLin*41,nCol*67,AllTrim(Transform(ZC3->ZC3_UCALT3	,PesqPict("ZC3","ZC3_UCALT3") )),oFnt08,100)


oPrn:Say (nLin*31,nCol*74,"Nº de Peças",oFnt09,100)
oPrn:Say (nLin*34,nCol*75,"por U.C.",oFnt09n,100)  
oPrn:Say (nLin*37,nCol*74,AllTrim(Transform(ZC3->ZC3_UCNPC	,PesqPict("ZC3","ZC3_UCNPC") )),oFnt08,100)
oPrn:Say (nLin*39,nCol*74,AllTrim(Transform(ZC3->ZC3_UCPC2	,PesqPict("ZC3","ZC3_UCPC2") )),oFnt08,100)
oPrn:Say (nLin*41,nCol*74,AllTrim(Transform(ZC3->ZC3_UCPC3	,PesqPict("ZC3","ZC3_UCPC3") )),oFnt08,100)

oPrn:Say (nLin*31,nCol*90,"PESO",oFnt09,100)
oPrn:Say (nLin*34,nCol*89,"BRUTO (kg)",oFnt09n,100)
oPrn:Say (nLin*37,nCol*86,AllTrim(Transform(ZC3->ZC3_UCPESO	,PesqPict("ZC3","ZC3_UCPESO") )),oFnt08,100)
oPrn:Say (nLin*39,nCol*86,AllTrim(Transform(ZC3->ZC3_UCPES2	,PesqPict("ZC3","ZC3_UCPES2") )),oFnt08,100)
oPrn:Say (nLin*41,nCol*86,AllTrim(Transform(ZC3->ZC3_UCPES3	,PesqPict("ZC3","ZC3_UCPES3") )),oFnt08,100)

oPrn:Say (nLin*31,nCol*102,"PREÇO POR",oFnt09,100)
oPrn:Say (nLin*34,nCol*102,"EMBALAGEM",oFnt09n,100)
oPrn:Say (nLin*37,nCol*100,AllTrim(Transform(ZC3->ZC3_UCPRE	,PesqPict("ZC3","ZC3_UCPRE") )),oFnt08,100)
oPrn:Say (nLin*39,nCol*100,AllTrim(Transform(ZC3->ZC3_UCPRE2 ,PesqPict("ZC3","ZC3_UCPRE2") )),oFnt08,100)
oPrn:Say (nLin*41,nCol*100,AllTrim(Transform(ZC3->ZC3_UCPRE3 ,PesqPict("ZC3","ZC3_UCPRE3") )),oFnt08,100)

Return ( )                                                                                                       
//===============================FIM DO BOX01 U.C.  ======================================================= 
//=====================================BOX02 U.M.  =======================================================
Static Function sfBOX02()
Local nLin:=20
Local nCol:=20 
oPrn:Box(nLin*44,nColInc,nLin*50,nCol*114) //Box 1 

oPrn:Box(nLin*50,nColInc,nLin*58,nCol*114) //Box 2
oPrn:Line(nLin*50,nCol*35,nLin*58,nCol*35) //Coluna 1
oPrn:Line(nLin*50,nCol*53,nLin*58,nCol*53) //Coluna 2
oPrn:Line(nLin*50,nCol*73,nLin*58,nCol*73) //Coluna 3
oPrn:Line(nLin*50,nCol*85,nLin*58,nCol*85) //Coluna 4
oPrn:Line(nLin*50,nCol*99,nLin*58,nCol*99) //Coluna 5

oPrn:Say (nLin*45,nCol*15,"U.M.",oFnt09n,100)
oPrn:Say (nLin*48,nCol*10,"Unidade de Movimentação",oFnt09n,100)  
oPrn:Say (nLin*51,nColInc+nCol,AllTrim(ZC3->ZC3_UM),oFnt08,100)
oPrn:Say (nLin*53,nColInc+nCol,AllTrim(ZC3->ZC3_UM2),oFnt08,100)
oPrn:Say (nLin*55,nColInc+nCol,AllTrim(ZC3->ZC3_UM3),oFnt08,100)

oPrn:Say (nLin*45,nCol*41,"TIPO ou",oFnt09,100)
oPrn:Say (nLin*48,nCol*41,"Nº da EMB",oFnt09n,100) 
oPrn:Say (nLin*51,nCol*36,AllTrim(ZC3->ZC3_UMTIPO),oFnt08,100)
oPrn:Say (nLin*53,nCol*36,AllTrim(ZC3->ZC3_UMPT2),oFnt08,100)
oPrn:Say (nLin*55,nCol*36,AllTrim(ZC3->ZC3_UMTP3),oFnt08,100)

oPrn:Say (nLin*45,nCol*58,"DIMENSÕES",oFnt09,100)
oPrn:Say (nLin*48,nCol*58,"(C X L X H)",oFnt09n,100)
oPrn:Say (nLin*51,nCol*54,AllTrim(Transform(ZC3->ZC3_UMCOM	,PesqPict("ZC3","ZC3_UMCOM") )),oFnt08,100)
oPrn:Say (nLin*51,nCol*58," X ",oFnt09n,100)
oPrn:Say (nLin*51,nCol*60,AllTrim(Transform(ZC3->ZC3_UMLARG	,PesqPict("ZC3","ZC3_UMLARG") )),oFnt08,100)
oPrn:Say (nLin*51,nCol*64," X ",oFnt09n,100)
oPrn:Say (nLin*51,nCol*67,AllTrim(Transform(ZC3->ZC3_UMALT	,PesqPict("ZC3","ZC3_UMALT") )),oFnt08,100)

oPrn:Say (nLin*53,nCol*54,AllTrim(Transform(ZC3->ZC3_UMCOM2	,PesqPict("ZC3","ZC3_UMCOM2") )),oFnt08,100)
oPrn:Say (nLin*53,nCol*58," X ",oFnt09n,100)
oPrn:Say (nLin*53,nCol*60,AllTrim(Transform(ZC3->ZC3_UMLAR2	,PesqPict("ZC3","ZC3_UMLAR2") )),oFnt08,100)
oPrn:Say (nLin*53,nCol*64," X ",oFnt09n,100)
oPrn:Say (nLin*53,nCol*67,AllTrim(Transform(ZC3->ZC3_UMALT2	,PesqPict("ZC3","ZC3_UMALT2") )),oFnt08,100)   

oPrn:Say (nLin*55,nCol*54,AllTrim(Transform(ZC3->ZC3_UMCOM3	,PesqPict("ZC3","ZC3_UMCOM3") )),oFnt08,100)
oPrn:Say (nLin*55,nCol*58," X ",oFnt09n,100)
oPrn:Say (nLin*55,nCol*60,AllTrim(Transform(ZC3->ZC3_UMLAR3	,PesqPict("ZC3","ZC3_UMLAR3") )),oFnt08,100)
oPrn:Say (nLin*55,nCol*64," X ",oFnt09n,100)
oPrn:Say (nLin*55,nCol*67,AllTrim(Transform(ZC3->ZC3_UMALT3	,PesqPict("ZC3","ZC3_UMALT3") )),oFnt08,100)      

oPrn:Say (nLin*45,nCol*74,"Nº de Peças",oFnt09,100)
oPrn:Say (nLin*48,nCol*75,"por U.M.",oFnt09n,100)  
oPrn:Say (nLin*51,nCol*74,AllTrim(Transform(ZC3->ZC3_UMNPC	,PesqPict("ZC3","ZC3_UMNPC") )),oFnt08,100)
oPrn:Say (nLin*53,nCol*74,AllTrim(Transform(ZC3->ZC3_UMPC2	,PesqPict("ZC3","ZC3_UMPC2") )),oFnt08,100)
oPrn:Say (nLin*55,nCol*74,AllTrim(Transform(ZC3->ZC3_UMPC3	,PesqPict("ZC3","ZC3_UMPC3") )),oFnt08,100)

oPrn:Say (nLin*45,nCol*90,"PESO",oFnt09,100)
oPrn:Say (nLin*48,nCol*89,"BRUTO (kg)",oFnt09n,100)
oPrn:Say (nLin*51,nCol*86,AllTrim(Transform(ZC3->ZC3_UMPESO	,PesqPict("ZC3","ZC3_UMPESO") )),oFnt08,100)
oPrn:Say (nLin*53,nCol*86,AllTrim(Transform(ZC3->ZC3_UMPES2	,PesqPict("ZC3","ZC3_UMPES2") )),oFnt08,100)
oPrn:Say (nLin*55,nCol*86,AllTrim(Transform(ZC3->ZC3_UMPES3	,PesqPict("ZC3","ZC3_UMPES3") )),oFnt08,100)

oPrn:Say (nLin*45,nCol*102,"PREÇO POR",oFnt09,100)
oPrn:Say (nLin*48,nCol*102,"EMBALAGEM",oFnt09n,100)
oPrn:Say (nLin*51,nCol*100,AllTrim(Transform(ZC3->ZC3_UMPRE	,PesqPict("ZC3","ZC3_UMPRE") )),oFnt08,100)
oPrn:Say (nLin*53,nCol*100,AllTrim(Transform(ZC3->ZC3_UMPRE2 ,PesqPict("ZC3","ZC3_UMPRE2") )),oFnt08,100)
oPrn:Say (nLin*55,nCol*100,AllTrim(Transform(ZC3->ZC3_UMPRE3 ,PesqPict("ZC3","ZC3_UMPRE3") )),oFnt08,100)

Return ( )
//===============================FIM DO BOX2 U.M.  =======================================================
//=====================================BOX03 REVESTIMENTO ================================================
Static Function sfBOX03()
Local nLin:=20
Local nCol:=20 
Local nM		:=0
Local cLinhaObs	:=""
Local nCont		:=0

oPrn:Box(nLin*58,nColInc,nLin*64,nCol*114) //Box 1

oPrn:Box(nLin*64,nColInc,nLin*77,nCol*114) //Box 2
oPrn:Line(nLin*64,nCol*40,nLin*77,nCol*40) //Coluna 1
oPrn:Line(nLin*64,nCol*71,nLin*77,nCol*71) //Coluna 2
oPrn:Line(nLin*64,nCol*85,nLin*77,nCol*85) //Coluna 3
oPrn:Line(nLin*64,nCol*99,nLin*77,nCol*99) //Coluna 4

oPrn:Say (nLin*61,nCol*12,"REVESTIMENTO",oFnt09n,100)
For nM := 1 to 6//MLCount( ZC3->ZC3_OBS2 , 160 )
  //	cLinhaObs	:=Memoline( ZC3->ZC3_REVEST ,50, nM ) 
	oPrn:Say (nLin*(65+nCont),nColInc+nCol,cLinhaObs,oFnt08,100) 	       	
	nCont+=2	
Next nM  


oPrn:Say (nLin*61,nCol*50,"DESCRIÇÃO",oFnt09,100)
nCont:=0
For nM := 1 to 6//MLCount( ZC3->ZC3_OBS2 , 160 )
	cLinhaObs	:=Memoline( ZC3->ZC3_REVDES ,45, nM ) 
	oPrn:Say (nLin*(65+nCont),nCol*41,cLinhaObs,oFnt08,100) 	       	
	nCont+=2	
Next nM

oPrn:Say (nLin*59,nCol*76,"Quant.",oFnt09,100)
oPrn:Say (nLin*62,nCol*73,"por Embalagem",oFnt09,100)
oPrn:Say (nLin*65,nCol*72,AllTrim(Transform(ZC3->ZC3_QTDREV	,PesqPict("ZC3","ZC3_QTDREV") )),oFnt08,100)

oPrn:Say (nLin*59,nCol*90,"Preço",oFnt09,100)
oPrn:Say (nLin*62,nCol*90,"Unit.",oFnt09n,100)  
oPrn:Say (nLin*65,nCol*86,AllTrim(Transform(ZC3->ZC3_PRUREV	,PesqPict("ZC3","ZC3_PRUREV") )),oFnt08,100)

oPrn:Say (nLin*59,nCol*102,"PREÇO POR",oFnt09,100)
oPrn:Say (nLin*62,nCol*100,"REVESTIMENTOS",oFnt09n,100)
oPrn:Say (nLin*65,nCol*100,AllTrim(Transform(ZC3->ZC3_PRREV	,PesqPict("ZC3","ZC3_PRREV") )),oFnt08,100)

oPrn:Box(nLin*77,nColInc,nLin*87,nCol*114) //Box 3

oPrn:Box(nLin*77,nCol*52,nLin*80,nCol*114) //Box TOTAL POR EMBALAGEM
oPrn:Box(nLin*80,nCol*52,nLin*83,nCol*114) //Box TOTAL EMBALAGEM POR PEÇA
oPrn:Line(nLin*77,nCol*99,nLin*83,nCol*99) //Coluna 
oPrn:Say (nLin*78,nCol*53,"PREÇO TOTAL POR EMBALAGEM",oFnt09n,100)
oPrn:Say (nLin*78,nCol*100,AllTrim(Transform(ZC3->ZC3_TOTEMB	,PesqPict("ZC3","ZC3_TOTEMB") )),oFnt08n,100)
oPrn:Say (nLin*81,nCol*53,"PREÇO TOTAL EMBALAGEM POR PEÇA",oFnt09n,100)
oPrn:Say (nLin*81,nCol*100,AllTrim(Transform(ZC3->ZC3_TOTPC	,PesqPict("ZC3","ZC3_TOTPC") )),oFnt08n,100)

Return ( )
//===============================FIM DO  BOX03 REVESTIMENTO ================================================
//=====================================BOX04 PROPRIETÁRIO/ CLASSIFICAÇÃO ================================================
Static Function sfBOX04()
Local nLin:=20
Local nCol:=20 
oPrn:Box(nLin*87,nColInc,nLin*90,nCol*114) //Box 1
oPrn:Box(nLin*90,nColInc,nLin*93,nCol*114) //Box 2 
oPrn:Line(nLin*87,nCol*53,nLin*93,nCol*53) //Coluna 
oPrn:Say (nLin*88,nCol*14,"PROPRIETÁRIO DA EMBALAGEM",oFnt08n,100)
Do Case
	Case AllTrim(ZC3->ZC3_PROPRI)=="1"//WHB
		oPrn:SayBitmap(nLin*91,nColInc+nCol*2,cBmpAzul,nCol*8,nLin*2)//WHB
		oPrn:Box(nLin*91,nCol*29,nLin*92+10,nCol*35) //Box Cliente		
		oPrn:Say (nLin*91,nColInc+nCol*11,"WHB",oFnt09,100)		
		oPrn:Say (nLin*91,nCol*39,"CLIENTE",oFnt09,100)				
	Case AllTrim(ZC3->ZC3_PROPRI)=="2"//Cliente                                                                     
		oPrn:Box(nLin*91,nColInc+nCol*2,nLin*92,nColInc+nCol*10) //WHB		
		oPrn:SayBitmap(nLin*91,nCol*29,cBmpAzul,nCol*8,nLin*2)// Cliente			
		oPrn:Say (nLin*91,nColInc+nCol*11,"WHB",oFnt09,100)		
		oPrn:Say (nLin*91,nCol*39,"CLIENTE",oFnt09,100)		
	Otherwise
		oPrn:Box(nLin*91,nColInc+nCol*2,nLin*92,nColInc+nCol*10) //WHB		
		oPrn:Box(nLin*91,nCol*29,nLin*92+10,nCol*35) //Box Cliente				
		oPrn:Say (nLin*91,nColInc+nCol*11,"WHB",oFnt09,100)		
		oPrn:Say (nLin*91,nCol*39,"CLIENTE",oFnt09,100)
EndCase	

oPrn:Say (nLin*88,nCol*72,"CLASSIFICAÇÃO DA EMBALAGEM",oFnt08n,100)
Do Case
	Case AllTrim(ZC3->ZC3_CLASS)=="1"//RETORNÁVEL
		oPrn:SayBitmap(nLin*91,nCol*65,cBmpAzul,nCol*8,nLin*2)
		oPrn:Box(nLin*91,nCol*92,nLin*92+10,nCol*99) 
		oPrn:Say (nLin*91,nCol*74,"RETORNÁVEL",oFnt09,100)		
		oPrn:Say (nLin*91,nCol*101,"DESCARTÁVEL",oFnt09,100)				
	Case AllTrim(ZC3->ZC3_CLASS)=="2"//DESCARTÁVEL                                                                    
		oPrn:Box(nLin*91,nCol*65,nLin*92+10,nCol*73) 
		oPrn:SayBitmap(nLin*91,nCol*92,cBmpAzul,nCol*8,nLin*2)
		oPrn:Say (nLin*91,nCol*74,"RETORNÁVEL",oFnt09,100)		
		oPrn:Say (nLin*91,nCol*101,"DESCARTÁVEL",oFnt09,100)				
	Otherwise
		oPrn:Box(nLin*91,nCol*65,nLin*92+10,nCol*73) 
		oPrn:Box(nLin*91,nCol*92,nLin*92+10,nCol*99) 
		oPrn:Say (nLin*91,nCol*74,"RETORNÁVEL",oFnt09,100)		
		oPrn:Say (nLin*91,nCol*101,"DESCARTÁVEL",oFnt09,100)				
EndCase


Return ( )
//==============================FIM DO BOX04 PROPRIETÁRIO/ CLASSIFICAÇÃO ================================================
/* 
//=====================================BOX05 FOTO/CROQUI DA EMBALAGEM    ================================================
Static Function sfBOX05()
Local nLin		:=	20
Local nCol		:=	20
Local aDimensao	:=	{}

SetPrvt("oBmp")               //    1   2   3   4  5  6       7  8 9 10  11 12  13  14  15   16   17    18   19
oBmp      		:= 	TBitmap():New( 052,084,209,689,,cBmpFoto,.F., , ,  ,   ,.F.,    ,"",    ,   ,   .T.,   ,  .F. )
oBmp:lAutoSize 	:= .T. 
oBmp:lStretch	:= .F. 
aDimensao		:=	sfImagem (30*nLin,(nCol*100)-nColInc,oBmp:nClientHeight,oBmp:nClientWidth)                                                                                        
oPrn:Box(nLin*93,nColInc,nLin*96,nCol*114) //Box 1 
oPrn:SayBitmap(nLin*93,nColInc,cBmpLinha,nCol*108,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*94,nCol*45,"FOTO/CROQUI DA EMBALAGEM",oFnt09n,100)
oPrn:Box(nLin*96,nColInc,nLin*127,nCol*114) //Box 2  
oPrn:SayBitmap(nLin*96,nColInc+nCol,cBmpFoto,aDimensao[2],aDimensao[1])//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)                                                                                                                
 
Return ( )
//===============================FIM DO BOX05 FOTO/CROQUI DA EMBALAGEM    ================================================ 
*/
//=====================================BOX05 FOTO/CROQUI DA EMBALAGEM    ================================================
Static Function sfBOX05()
Local nLin		:=	20
Local nCol		:=	20
Local aDimensao	:=	{}
Local lFile		
Local cBmpPict	:= ""
Local cPath		:= GetSrvProfString("Startpath","")
Local oDlg8
Local oBmp  

oPrn:Box(nLin*93,nColInc,nLin*96,nCol*114) //Box 1 
oPrn:SayBitmap(nLin*93,nColInc,cBmpLinha,nCol*108,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*94,nCol*45,"FOTO/CROQUI DA EMBALAGEM",oFnt09n,100)
oPrn:Box(nLin*96,nColInc,nLin*127,nCol*114) //Box 2  
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega a Foto do Funcionario								   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cBmpPict := Upper( AllTrim( ZC3->ZC3_BITMAP)) 
cPathPict 	:= IIF(File( cPath + cBmpPict+".JPG" ),( cPath + cBmpPict+".JPG" ), ( cPath + cBmpPict+".BMP" ))

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Para impressao da foto eh necessario abrir um dialogo para   ³
³ extracao da foto do repositorio.No entanto na impressao,nao  |
³ ha a necessidade de visualiza-lo( o dialogo).Por esta razao  ³
³ ele sera montado nestas coordenadas fora da Tela             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 

DEFINE MSDIALOG oDlg8   FROM -1000000,-4000000 TO -10000000,-8000000  PIXEL 
@ -10000000, -1000000000000 REPOSITORY oBmp SIZE -6000000000, -7000000000 OF oDlg8  
	oBmp:LoadBmp(cBmpPict)
	IF !Empty( cBmpPict := Upper( AllTrim( ZC3->ZC3_BITMAP ) ) )
		IF !File( cPathPict)
			lFile:=oBmp:Extract(cBmpPict  ,cPathPict,.F.)
			If lFile 
				oBmp:lAutoSize 	:= .T. 
				oBmp:lStretch	:= .F. 				
				aDimensao		:=	sfImagem (30*nLin,(nCol*100)-nColInc,oBmp:nClientHeight,oBmp:nClientWidth)                                                                                        
				oPrn:SayBitmap(nLin*96,nColInc+nCol,cPathPict,aDimensao[2],aDimensao[1],,.T.)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)									
			Endif	
		Else 	
			oBmp:lAutoSize 	:= .T. 
			oBmp:lStretch	:= .F. 							
			aDimensao		:=	sfImagem (30*nLin,(nCol*100)-nColInc,oBmp:nClientHeight,oBmp:nClientWidth)                                                                                        
			oPrn:SayBitmap(nLin*96,nColInc+nCol,cPathPict,aDimensao[2],aDimensao[1],,.T.)				
		EndIF
	EndIF
	aAdd(aFotos,cPathPict)
ACTIVATE MSDIALOG oDlg8 ON INIT (oBmp:lStretch := .T., oDlg8:End())                                                                                               
Return ( )
//===============================FIM DO BOX05 FOTO/CROQUI DA EMBALAGEM    ================================================ 
//=====================================BOX06 OBSERVAÇÕES COMPLEMENTARES  ================================================
Static Function sfBOX06()
Local nLin:=20
Local nCol:=20
Local nM		:=0
Local cLinhaObs	:=""
Local nCont		:=0

oPrn:Box(nLin*127,nColInc,nLin*130,nCol*114) //Box 1 
oPrn:SayBitmap(nLin*127,nColInc,cBmpLinha,nCol*108,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)
oPrn:Say (nLin*128,nCol*45,"OBSERVAÇÕES COMPLEMENTARES",oFnt09n,100) 
oPrn:Box(nLin*130,nColInc,nLin*139,nCol*114) //Box 2
For nM := 1 to 4//MLCount( ZC3->ZC3_OBS , 160 )
	cLinhaObs	:=Memoline( ZC3->ZC3_OBS ,170, nM ) 
	oPrn:Say (nLin*(131+nCont),nColInc+nCol,cLinhaObs,oFnt08,100) 	       	
	nCont+=2	
Next nM 

Return ( )
//===============================FIM DO BOX06 OBSERVAÇÕES COMPLEMENTARES  ================================================
//=====================================BOX07 APROVAÇÃO ==================================================================
Static Function sfBOX07()
Local nLin		:=20
Local nCol		:=20
Local nM		:=0
Local cLinhaObs	:=""
Local nCont		:=0

oPrn:Box(nLin*139,nColInc,nLin*142,nCol*114) //Box 1 
oPrn:SayBitmap(nLin*139,nColInc,cBmpLinha,nCol*108,nLin*3)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)
oPrn:Say (nLin*140,nCol*45,"APROVAÇÃO",oFnt11n,100) 
oPrn:Box(nLin*142,nColInc,nLin*150,nCol*114) //Box 2 
oPrn:SayBitmap(nLin*139,nColInc,cBmpLinha,nCol*4,nLin*11)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)

oPrn:Say (nLin*141,nColInc+nCol,"W",oFnt11n,100) 
oPrn:Say (nLin*143,nColInc+nCol,"H",oFnt11n,100) 
oPrn:Say (nLin*145,nColInc+nCol,"B",oFnt11n,100)
 
oPrn:Say (nLin*143,nCol*10,"ENGENHARIA",oFnt09n,100)
oPrn:Say (nLin*143,nCol*23,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APENG,"QAA_NOME")),oFnt09,100)
oPrn:Say (nLin*143,nCol*56,"QUALIDADE",oFnt09n,100)
oPrn:Say (nLin*143,nCol*66,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APQUA,"QAA_NOME")),oFnt09,100)

oPrn:Say (nLin*145,nCol*10,"PRODUÇÃO",oFnt09n,100)
oPrn:Say (nLin*145,nCol*23,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APPROD,"QAA_NOME")),oFnt09,100)
oPrn:Say (nLin*145,nCol*56,"LOGÍTICA",oFnt09n,100)
oPrn:Say (nLin*145,nCol*66,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APLOG,"QAA_NOME")),oFnt09,100)

oPrn:Box(nLin*150,nColInc,nLin*164,nCol*114) //Box 3

oPrn:SayBitmap(nLin*150,nColInc,cBmpLinha,nCol*4,nLin*14)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)
oPrn:Say (nLin*150,nColInc+nCol,"C",oFnt11n,100) 
oPrn:Say (nLin*152,nColInc+nCol,"L",oFnt11n,100) 
oPrn:Say (nLin*154,nColInc+nCol,"I",oFnt11n,100)
oPrn:Say (nLin*156,nColInc+nCol,"E",oFnt11n,100)
oPrn:Say (nLin*158,nColInc+nCol,"N",oFnt11n,100)
oPrn:Say (nLin*160,nColInc+nCol,"T",oFnt11n,100)
oPrn:Say (nLin*162,nColInc+nCol,"E",oFnt11n,100)

Do Case
	Case AllTrim(ZC3->ZC3_APROV)=="1"//Aprovado
		oPrn:Say (nLin*151,nCol*10,"APROVADA",oFnt09,100)
		oPrn:Say (nLin*153,nCol*10,"APROV. TEMP.",oFnt09,100)		
		oPrn:Say (nLin*155,nCol*10,"REPROVADA",oFnt09,100)		
		oPrn:SayBitmap(nLin*151,nCol*29,cBmpAzul,nCol*8,nLin)
		oPrn:Box(nLin*153,nCol*29,nLin*154,nCol*37)
		oPrn:Box(nLin*155,nCol*29,nLin*156,nCol*37)		
				
	Case AllTrim(ZC3->ZC3_APROV)=="2"//APROVADO TEMP                                                                    
		oPrn:Say (nLin*151,nCol*10,"APROVADA",oFnt09,100)
		oPrn:Say (nLin*153,nCol*10,"APROV. TEMP.",oFnt09,100)		
		oPrn:Say (nLin*155,nCol*10,"REPROVADA",oFnt09,100)		
		oPrn:Box(nLin*151,nCol*29,nLin*152,nCol*37)
		oPrn:SayBitmap(nLin*153,nCol*29,cBmpAzul,nCol*8,nLin)		
		oPrn:Box(nLin*155,nCol*29,nLin*156,nCol*37)
				
	Case AllTrim(ZC3->ZC3_APROV)=="3"//REPROVADO                                                                    
		oPrn:Say (nLin*151,nCol*10,"APROVADA",oFnt09,100)
		oPrn:Say (nLin*153,nCol*10,"APROV. TEMP.",oFnt09,100)		
		oPrn:Say (nLin*155,nCol*10,"REPROVADA",oFnt09,100)		
		oPrn:Box(nLin*151,nCol*29,nLin*152,nCol*37)
		oPrn:Box(nLin*153,nCol*29,nLin*154,nCol*37)				                                      
		oPrn:SayBitmap(nLin*155,nCol*29,cBmpAzul,nCol*8,nLin)				
	Otherwise
		oPrn:Say (nLin*151,nCol*10,"APROVADA",oFnt09,100)
		oPrn:Say (nLin*153,nCol*10,"APROV. TEMP.",oFnt09,100)		
		oPrn:Say (nLin*155,nCol*10,"REPROVADA",oFnt09,100)		
		oPrn:Box(nLin*151,nCol*29,nLin*152,nCol*37)
		oPrn:Box(nLin*153,nCol*29,nLin*154,nCol*37)
		oPrn:Box(nLin*155,nCol*29,nLin*156,nCol*37)		
EndCase

oPrn:Say (nLin*151,nCol*53,"RESP.",oFnt09n,100) 
oPrn:Say (nLin*151,nCol*61,AllTrim(Posicione("SU5",1,xFilial("SU5")+ZC3->ZC3_RESCLI,"U5_CONTAT")),oFnt09,100) 
oPrn:Say (nLin*153,nCol*53,"ASS.",oFnt09n,100) 
oPrn:Say (nLin*153,nCol*61,"_________________________________",oFnt09,100) 
oPrn:Say (nLin*155,nCol*53,"DATA.",oFnt09n,100)
oPrn:Say (nLin*155,nCol*61,DtoC(ZC3->ZC3_DTAPR),oFnt09,100)

oPrn:Say (nLin*158,nCol*10,"OBS.:",oFnt09n,100)

For nM := 1 to 3 //MLCount( ZC3->ZC3_OBS2 , 160 )
	cLinhaObs	:=Memoline( ZC3->ZC3_OBS2 ,155, nM )        	
	oPrn:Say (nLin*(158+nCont),nCol*15,cLinhaObs,oFnt08,100)
	nCont+=2	
Next nM



Return ( )
//==============================FIM DO BOX07 APROVAÇÃO ==================================================================
//===============================Ajuste de Imagem ========================================================================
//Altura Desejada, Largura Desejada , Altura da Imagem , Largura da Imagem 
Static Function sfImagem (nAltDesej,nLarDesej,nAltBMP,nLarBMP)
Local aRet	:={0,0}//{ Altura da Imagem , Largura da Imagem }
Local nPerAlt:=0
Local nPerLar:=0
Do Case
	Case nAltDesej>=nAltBMP .AND. nLarDesej>=nLarBMP //Imagem com dimensões dentro das desejadas
		aRet[1]:=nAltBMP
		aRet[2]:=nLarBMP		
	Case nAltDesej < nAltBMP //Altura fora da desejada
		nPerAlt:=(nAltDesej/nAltBMP)				
		aRet[1]:=nAltBMP*nPerAlt
		aRet[2]:=nLarBMP*nPerAlt		
	Case nLarDesej < nLarBMP  //Largura fora da desejada			
		nPerLar:=(nLarDesej/nLarBMP)
		aRet[1]:=nAltBMP*nPerLar
		aRet[2]:=nLarBMP*nPerLar
EndCase				
Return (aRet)   
//==================================================Fim do Ajuste de Imagem =======================================================


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
