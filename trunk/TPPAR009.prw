#INCLUDE "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAR009  º Autor ³ HANDERSON DUARTE   º Data ³  12/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão Análise Crítica Comercal    - USINAGEM           º±±
±±º          ³ REFERENTE AO FONTE TPPAC012                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MSQL e MP10 1.2                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//================PROGRAMA PRINCIPAL=================================================
User Function TPPAR009 ( )
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
Private aAreaZC1	:=	ZC1->(GetArea())
Private nRecNo		:=	0
Private cACC		:=	ZC1->ZC1_ACC 
 
DBSelectArea("ZC1")
ZC1->(DBGotop())
ZC1->(DBSetOrder(1))//ZC1_FILIAL, ZC1_ACC, ZC1_REV, R_E_C_N_O_, D_E_L_E_T_
ZC1->(DBSeek(xFilial("ZC1")+cACC))
While ZC1->(!EoF()) .AND. (ZC1->ZC1_FILIAL+ZC1->ZC1_ACC) == (xFilial("ZC1")+cACC)
	If ZC1->ZC1_STAREV .AND. ZC1->ZC1_STATUS="S"
		nRecNo		:=	ZC1->(RecNo())
	EndIf
	ZC1->(DBSkip())
EndDo

ZC1->(DBGoTo(nRecNo))

oPrn := TMSPrinter():New("Análise Crítica Comercial ")//Cria Objeto para impressao Grafica
oPrn:Setup()//Chama a rotina de Configuracao da impressao
//oPrn:SetLandScape()
oPrn:SetPortrait()

oPrn:StartPage()//Cria nova Pagina 
If ZC1->ZC1_STAREV .AND. ZC1->ZC1_STATUS="S"
	sfCabec()//Impressao do Cabecalho			
 	sfBOX01()
EndIf														
oPrn:EndPage()//Finaliza a Pagina

//	MsgAlert("Relatório vazio")

oPrn:Preview() 
RestArea(aAreaZC1) 
Return ( )
//================FIM DO PROGRAMA PRINCIPAL==========================================
//=====================================Impressão do Cabeçalho===================================================
Static Function sfCabec()
Local nLin:=20
Local nCol:=20

oPrn:Box(nLinInc,nColInc,nLin*15,nCol*114) //Box do Cabeçalho 
oPrn:SayBitmap(nLinInc+nLin,nColInc+nCol,cBmpLogo,nCol*18,nLin*7)//Logo Marga ->SayBitmap(Linha,Coluna,Figura,Coluna,Linha)      
oPrn:Say (nLinInc+nLin,nCol*42,"ANÁLISE CRÍTICA DE CONTRATO",oFnt18n,100)
oPrn:Say (nLinInc+nLin,nCol*92,AllTrim(ZC1->ZC1_ACC),oFnt11n,100)
oPrn:Say (nLinInc+nLin,nCol*100,"/",oFnt11n,100)
oPrn:Say (nLinInc+nLin,nCol*101,AllTrim(ZC1->ZC1_REV),oFnt11n,100) 

If ZC1->ZC1_TPANA=="1" //Introdução de Peça Nova
	oPrn:Say (nLin*10,nCol*43,"X",oFnt11n,100)
Else  //Modificação                                         
	oPrn:Say (nLin*10,nCol*85,"X",oFnt11n,100)
EndIf
oPrn:Box(nLin*10,nCol*41,nLin*12,nCol*45) //Box da Introdução
oPrn:Say (nLin*10,nCol*47,"Introdução de Peça Nova",oFnt11n,100)   
oPrn:Box(nLin*10,nCol*84,nLin*12,nCol*88) //Box da Modificacao
oPrn:Say (nLin*10,nCol*90,"Modificação",oFnt11n,100)
  
oPrn:Box(nLin*15,nColInc,nLin*19,nCol*114) //2 - Box do Cabeçalho 
oPrn:Say (nLin*16,nColInc+nCol,"Nº Peça:",oFnt09n,100)
oPrn:Say (nLin*16,nCol*24,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC1->(ZC1_CODPRO+ZC1_REVPEC),"QK1_PRODUT")),oFnt09,100)
oPrn:Say (nLin*16,nCol*45,"Revisão:",oFnt09n,100)
oPrn:Say (nLin*16,nCol*52,AllTrim(ZC1->ZC1_REVPEC),oFnt09,100)
oPrn:Say (nLin*16,nCol*90,"Data:",oFnt09n,100)
oPrn:Say (nLin*16,nCol*95,AllTrim(DtoC(ZC1->ZC1_DATA)),oFnt09,100)
oPrn:Box(nLin*19,nColInc,nLin*23,nCol*114) //3 - Box do Cabeçalho 
oPrn:Say (nLin*20,nColInc+nCol,"Denominação da Peça:",oFnt09n,100)
oPrn:Say (nLin*20,nCol*26,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC1->(ZC1_CODPRO+ZC1_REVPEC),"QK1_DESC")),oFnt09,100)
oPrn:Say (nLin*20,nCol*90,"Cliente:",oFnt09n,100)
oPrn:Say (nLin*20,nCol*96,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC1->(ZC1_CODCLI+ZC1_LOJA),"A1_NREDUZ")),oFnt09,100)
oPrn:Box(nLin*23,nColInc,nLin*27,nCol*114) //4 - Box do Cabeçalho 
oPrn:Say (nLin*24,nColInc+nCol,"Desenvolvimento:",oFnt09n,100)
oPrn:Say (nLin*24,nCol*22,AllTrim(ZC1->ZC1_CODPRO),oFnt09,100) 
oPrn:Say (nLin*24,nCol*55,"Solic. Orçam.:",oFnt09n,100)
oPrn:Say (nLin*24,nCol*65,AllTrim(ZC1->ZC1_SO),oFnt09,100)
oPrn:Say (nLin*24,nCol*75,"Projeto:",oFnt09n,100)
oPrn:Say (nLin*24,nCol*81,AllTrim(Posicione("QK1",1,xFilial("QK1")+ZC1->(ZC1_CODPRO+ZC1_REVPEC),"QK1_PROJET")),oFnt09,100)


oPrn:Box(nLin*27,nColInc,nLin*31,nCol*114) //5 - Box do Cabeçalho 
oPrn:SayBitmap(nLin*27,nColInc,cBmpLinha,nCol*108,nLin*4)//->SayBitmap(Linha,Coluna,Figura,Coluna,Linha) 
oPrn:Say (nLin*28,nCol*50,"ANÁLISE CRÍTICA COMERCIAL",oFnt16n,100)


Return ( )

//=====================================Fim da Impressão do Cabeçalho============================================
//=====================================BOX01 IDENTIFICAÇÃO =======================================================
Static Function sfBOX01()
Local nLin		:=20
Local nCol		:=20
Local cCondFo	:=""
Local cLinhaObs	:=""
Local nM		:=0
Local nCont		:=0 
Local cMoeda	:=""
//---------------------A1---------------------------------------------
oPrn:Box(nLin*31,nColInc,nLin*34,nCol*114)  
oPrn:Line(nLin*31,nColInc+(nCol*3),nLin*34,nColInc+(nCol*3))                               
oPrn:Say (nLin*32,nColInc+nCol,"A1",oFnt09n,100)
oPrn:Say (nLin*32,nColInc+(nCol*4),"Autorização para desenvolvimento doc.Nº:",oFnt09n,100)
oPrn:Say (nLin*32,nCol*40,"(anexar pedido de compra da peça e ferramental)",oFnt09,100)
oPrn:Line(nLin*31,nCol*79,nLin*34,nCol*79) 
//oPrn:Say (nLin*32,nCol*80,ZC1->ZC1_ACC+" - "+ZC1->ZC1_REV,oFnt09n,100)
oPrn:Say (nLin*32,nCol*80,ZC1->ZC1_AUTDES,oFnt09n,100)

//---------------------A2---------------------------------------------
oPrn:Box(nLin*34,nColInc,nLin*37,nCol*114)  
oPrn:Line(nLin*34,nColInc+(nCol*3),nLin*37,nColInc+(nCol*3))                               
oPrn:Say (nLin*35,nColInc+nCol,"A2",oFnt09n,100)
oPrn:Say (nLin*35,nColInc+(nCol*4),"Endereço do Cliente:",oFnt09n,100)
oPrn:Say (nLin*35,nCol*25,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC1->(ZC1_CODCLI+ZC1_LOJA),"A1_END")),oFnt09,100)

oPrn:Box(nLin*37,nColInc,nLin*40,nCol*114)                                 
oPrn:Say (nLin*38,nColInc+nCol,"Cidade:",oFnt09n,100)
oPrn:Say (nLin*38,nCol*13,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC1->(ZC1_CODCLI+ZC1_LOJA),"A1_MUN")),oFnt09,100)
oPrn:Line(nLin*37,nCol*40,nLin*40,nCol*40) 
oPrn:Say (nLin*38,nCol*41,"UF:",oFnt09n,100)
oPrn:Say (nLin*38,nCol*44,AllTrim(Posicione("SA1",1,xFilial("SA1")+ZC1->(ZC1_CODCLI+ZC1_LOJA),"A1_EST")),oFnt09,100)
oPrn:Line(nLin*37,nCol*55,nLin*40,nCol*55) 
oPrn:Say (nLin*38,nCol*56,"País:",oFnt09n,100)

oPrn:Say (nLin*38,nCol*60,AllTrim(Posicione("SYA",1,Xfilial("SYA")+Posicione("SA1",1,xFilial("SA1")+ZC1->(ZC1_CODCLI+ZC1_LOJA),"A1_PAIS"),"YA_DESCR")),oFnt09,100)
oPrn:Line(nLin*37,nCol*80,nLin*40,nCol*80) 
oPrn:Say (nLin*38,nCol*81,"CEP:",oFnt09n,100)
oPrn:Say (nLin*38,nCol*85,Transform(Posicione("SA1",1,xFilial("SA1")+ZC1->(ZC1_CODCLI+ZC1_LOJA),"A1_CEP"), PesqPict("ZC1","ZC1_CEP")),oFnt09,100)

//---------------------A3---------------------------------------------
oPrn:Box(nLin*40,nColInc,nLin*46,nCol*114)  
oPrn:Line(nLin*40,nColInc+(nCol*3),nLin*46,nColInc+(nCol*3))                               
oPrn:Say (nLin*43,nColInc+nCol,"A3",oFnt09n,100)
oPrn:Say (nLin*41,nColInc+(nCol*4),"Localidade da planta do cliente é restrição para fornecimento:",oFnt09n,100)
oPrn:Say (nLin*41,nCol*55,IIF(Empty(ZC1->ZC1_RESTRI),"",IIF(ZC1->ZC1_RESTRI=="1","SIM","NÃO")),oFnt09,100)

oPrn:Box(nLin*43,nColInc+(nCol*3),nLin*46,nCol*114)                                 
oPrn:Say (nLin*44,nColInc+(nCol*4),"Qual?",oFnt09n,100)
oPrn:Say (nLin*44,nColInc+(nCol*8),AllTrim(ZC1->ZC1_QUAL),oFnt09,100)
//---------------------A4---------------------------------------------
oPrn:Box(nLin*46,nColInc,nLin*52,nCol*114)  
oPrn:Line(nLin*46,nColInc+(nCol*3),nLin*52,nColInc+(nCol*3))                               
oPrn:Say (nLin*49,nColInc+nCol,"A4",oFnt09n,100)

oPrn:Box(nLin*46,nColInc+(nCol*3),nLin*49,nCol*114)                                 
oPrn:Say (nLin*47,nColInc+(nCol*4),"Peça Bruta ",oFnt09n,100)
oPrn:Say (nLin*47,nColInc+(nCol*15),IIF(Empty(ZC1->ZC1_PB),"",IIF(ZC1->ZC1_PB=="1","Consignada","Comprada")),oFnt09,100)
oPrn:Line(nLin*46,nCol*62,nLin*49,nCol*62) 
oPrn:Say (nLin*47,nCol*63,"Subfornecedor:",oFnt09n,100)
oPrn:Say (nLin*47,nCol*74,ZC1->ZC1_PBFOR,oFnt09n,100)
//oPrn:Say (nLin*47,nCol*74,AllTrim(posicione("SA2",1,xFilial("SA2")+ZC1->(ZC1_FOR1+ZC1_LOJA1),"A2_NREDUZ")),oFnt09,100)

oPrn:Box(nLin*49,nColInc+(nCol*3),nLin*52,nCol*114)                                 
oPrn:Say (nLin*50,nColInc+(nCol*4),"Componente: ",oFnt09n,100)
//oPrn:Say (nLin*50,nColInc+(nCol*15),IIF(Empty(ZC1->ZC1_COMP),"",IIF(ZC1->ZC1_COMP=="1","Consignada","Comprada")),oFnt09,100)
Do Case
	Case ZC1->ZC1_COMP=="1"
		cCondFo:="Consiguinado"
	Case ZC1->ZC1_COMP=="2"
		cCondFo:="Comprado"
	Case ZC1->ZC1_COMP=="3"
		cCondFo:="Não Aplicável"		
EndCase	

oPrn:Line(nLin*49,nCol*62,nLin*52,nCol*62) 
oPrn:Say (nLin*50,nCol*63,"Subfornecedor:",oFnt09n,100)
oPrn:Say (nLin*50,nCol*74,ZC1->ZC1_COMFOR,oFnt09n,100)
//oPrn:Say (nLin*50,nCol*74,AllTrim(posicione("SA2",1,xFilial("SA2")+ZC1->(ZC1_FOR2+ZC1_LOJA2),"A2_NREDUZ")),oFnt09,100)
//---------------------A5---------------------------------------------
oPrn:Box(nLin*52,nColInc,nLin*55,nCol*114)  
oPrn:Line(nLin*52,nColInc+(nCol*3),nLin*55,nColInc+(nCol*3))                               
oPrn:Say (nLin*53,nColInc+nCol,"A5",oFnt09n,100)
oPrn:Say (nLin*53,nColInc+(nCol*4),"Condições de fornecimento: ",oFnt09n,100)
Do Case
	Case ZC1->ZC1_CONDFO=="1"
		cCondFo:="Usinagem"
	Case ZC1->ZC1_CONDFO=="2"
		cCondFo:="Montagem"
	Case ZC1->ZC1_CONDFO=="3"
		cCondFo:="Usinagem e Montagem"		
	Case ZC1->ZC1_CONDFO=="4"
		cCondFo:="Outras"
	Case ZC1->ZC1_CONDFO=="5"
		cCondFo:="Fundido"
	Case ZC1->ZC1_CONDFO=="6"
		cCondFo:="Fundido e Usinado"
	Case ZC1->ZC1_CONDFO=="7" 
		cCondFo:="Fundido,Usinado e Montado"  
EndCase	
oPrn:Say (nLin*53,nColInc+(nCol*24),cCondFo,oFnt09,100)
oPrn:Line(nLin*52,nCol*60,nLin*55,nCol*60)
oPrn:Say (nLin*53,nCol*61,"Qual?",oFnt09n,100)
oPrn:Say (nLin*53,nCol*66,AllTrim(ZC1->ZC1_OUTROS),oFnt09,100)

//---------------------A6---------------------------------------------
oPrn:Box(nLin*55,nColInc,nLin*58,nCol*114)  
oPrn:Line(nLin*55,nColInc+(nCol*3),nLin*58,nColInc+(nCol*3))                               
oPrn:Say (nLin*56,nColInc+nCol,"A6",oFnt09n,100)
oPrn:Say (nLin*56,nColInc+(nCol*4),"Demanda ",oFnt09n,100)
//oPrn:Say (nLin*56,nColInc+(nCol*12),Transform(ZC1->ZC1_PCMES, PesqPict("ZC1","ZC1_DEMAN") ),oFnt09,100)
oPrn:Say (nLin*56,nColInc+(nCol*25),"Peças/Mês: ",oFnt09n,100)
oPrn:Say (nLin*56,nColInc+(nCol*35),Transform(ZC1->ZC1_PCMES, PesqPict("ZC1","ZC1_PCMES") ),oFnt09,100)
oPrn:Say (nLin*56,nColInc+(nCol*48),"Peças/Ano: ",oFnt09n,100)
oPrn:Say (nLin*56,nColInc+(nCol*55),Transform(ZC1->ZC1_PCANO, PesqPict("ZC1","ZC1_PCANO") ),oFnt09,100)

oPrn:Line(nLin*55,nCol*70,nLin*58,nCol*70)
oPrn:Say (nLin*56,nCol*71,"Aplicação peça: ",oFnt09n,100)
oPrn:Say (nLin*56,nCol*82,IIF(Empty(ZC1->ZC1_APLIC),"",IIF(ZC1->ZC1_APLIC=="1","Sistemica","Montada")),oFnt09,100)
//---------------------A7---------------------------------------------
oPrn:Box(nLin*58,nColInc,nLin*61,nCol*114)  
oPrn:Line(nLin*58,nColInc+(nCol*3),nLin*61,nColInc+(nCol*3))                               
oPrn:Say (nLin*59,nColInc+nCol,"A7",oFnt09n,100)

oPrn:Say (nLin*59,nColInc+(nCol*4),"Peso da Peça: ",oFnt09n,100)
oPrn:Say (nLin*59,nColInc+(nCol*15),Transform(ZC1->ZC1_PESOPC, PesqPict("ZC1","ZC1_PESOPC") ),oFnt09,100)

oPrn:Line(nLin*58,nCol*45,nLin*61,nCol*45)
oPrn:Say (nLin*59,nCol*46,"Classificação Fiscal (%IPI): ",oFnt09n,100)
oPrn:Say (nLin*59,nCol*65,Transform(ZC1->ZC1_CLASS, PesqPict("ZC1","ZC1_CLASS") ),oFnt09,100)

oPrn:Line(nLin*58,nCol*75,nLin*61,nCol*75)
oPrn:Say (nLin*59,nCol*76,"Código NCM.:",oFnt09n,100)
oPrn:Say (nLin*59,nCol*86,Transform(ZC1->ZC1_NCM, PesqPict("ZC1","ZC1_NCM") ),oFnt09,100)
//---------------------A8---------------------------------------------
oPrn:Box(nLin*61,nColInc,nLin*64,nCol*114)  
oPrn:Line(nLin*61,nColInc+(nCol*3),nLin*64,nColInc+(nCol*3))                               
oPrn:Say (nLin*62,nColInc+nCol,"A8",oFnt09n,100)

oPrn:Say (nLin*62,nColInc+(nCol*4),"Peça sujeita a documentação: ",oFnt09n,100)
oPrn:Say (nLin*62,nColInc+(nCol*25),IIF(Empty(ZC1->ZC1_DOC),"",IIF(ZC1->ZC1_DOC=="1","Sim","Não")),oFnt09,100)

oPrn:Line(nLin*61,nCol*45,nLin*64,nCol*45)
oPrn:Say (nLin*62,nCol*46,"Quantos Anos? ",oFnt09n,100)
oPrn:Say (nLin*62,nCol*56,Transform(ZC1->ZC1_ANOS, PesqPict("ZC1","ZC1_ANOS") ),oFnt09,100)

oPrn:Line(nLin*61,nCol*80,nLin*64,nCol*80)
oPrn:Say (nLin*62,nCol*81,"Peça de Segurança? ",oFnt09n,100)
//oPrn:Say (nLin*62,nCol*96,Transform(ZC1->ZC1_SEGUR, PesqPict("ZC1","ZC1_SEGUR") ),oFnt09,100)
oPrn:Say (nLin*62,nColInc+(nCol*96),IIF(Empty(ZC1->ZC1_SEGUR),"",IIF(ZC1->ZC1_SEGUR=="1","Sim","Não")),oFnt09,100)

//---------------------A9---------------------------------------------
oPrn:Box(nLin*64,nColInc,nLin*67,nCol*114)  
oPrn:Line(nLin*64,nColInc+(nCol*3),nLin*67,nColInc+(nCol*3))                               
oPrn:Say (nLin*65,nColInc+nCol,"A9",oFnt09n,100)

oPrn:Say (nLin*65,nColInc+(nCol*4),"Existe Legislação aplicada ao produto: ",oFnt09n,100)
oPrn:Say (nLin*65,nColInc+(nCol*30),IIF(Empty(ZC1->ZC1_LEGIS),"",IIF(ZC1->ZC1_LEGIS=="1","Sim","Não")),oFnt09,100)

oPrn:Line(nLin*64,nCol*45,nLin*67,nCol*45)
oPrn:Say (nLin*65,nCol*46,"Peça de Regulamentação? ",oFnt09n,100)
//oPrn:Say (nLin*65,nCol*66,AllTrim(ZC1->ZC1_REGUL),oFnt09,100)
oPrn:Say (nLin*65,nColInc+(nCol*66),IIF(Empty(ZC1->ZC1_REGUL),"",IIF(ZC1->ZC1_REGUL=="1","Sim","Não")),oFnt09,100)
//---------------------A10---------------------------------------------
oPrn:Box(nLin*67,nColInc,nLin*76,nCol*114)  
oPrn:Line(nLin*67,nColInc+(nCol*3),nLin*76,nColInc+(nCol*3))                               
oPrn:Say (nLin*70,nColInc+10,"A10",oFnt09n,100)

oPrn:Say (nLin*68,nColInc+(nCol*4),"Os desenhos estão no mesmo nível de engenharia orçado?",oFnt09n,100)
oPrn:Say (nLin*68,nColInc+(nCol*45),IIF(Empty(ZC1->ZC1_DESNIV),"",IIF(ZC1->ZC1_DESNIV=="1","Sim","Não")),oFnt09,100)
oPrn:Line(nLin*67,nCol*80,nLin*70,nCol*80)
oPrn:Say (nLin*68,nCol*81,"Novo Nível:",oFnt09n,100)
oPrn:Say (nLin*68,nCol*89,AllTrim(ZC1->ZC1_NOVADT),oFnt09,100)
//oPrn:Say (nLin*68,nCol*89,DtoC(ZC1->ZC1_NOVADT),oFnt09,100)

oPrn:Box(nLin*70,nColInc+(nCol*3),nLin*73,nCol*114)
oPrn:Say (nLin*71,nColInc+(nCol*4),"Em caso negativo, foram enviadas as alterações adicionais. Quais?",oFnt09n,100)
oPrn:Say (nLin*71,nCol*56,AllTrim(ZC1->ZC1_ALTER),oFnt09,100)

oPrn:Box(nLin*73,nColInc+(nCol*3),nLin*76,nCol*114)
oPrn:Say (nLin*74,nColInc+(nCol*4),"Existe diferença significativa do orçamento que impacte no custo?",oFnt09n,100)
oPrn:Say (nLin*74,nColInc+(nCol*48),IIF(Empty(ZC1->ZC1_CUSTO),"",IIF(ZC1->ZC1_CUSTO=="1","Sim","Não")),oFnt09,100)
oPrn:Say (nLin*74,nCol*60,"Relatar:",oFnt09n,100)
//oPrn:Say (nLin*74,nCol*63,AllTrim(ZC1->ZC1_CUSTO),oFnt09,100) 
oPrn:Say (nLin*74,nCol*70,AllTrim(ZC1->ZC1_RELATA),oFnt09,100)                                                     
//---------------------A11---------------------------------------------
oPrn:Box(nLin*76,nColInc,nLin*79,nCol*114)  
oPrn:Line(nLin*76,nColInc+(nCol*3),nLin*79,nColInc+(nCol*3))                               
oPrn:Say (nLin*77,nColInc+10,"A11",oFnt09n,100)

oPrn:Say (nLin*77,nColInc+(nCol*4),"Prazo objetivo para amostras:",oFnt09n,100)
oPrn:Say (nLin*77,nColInc+(nCol*28),DtoC(ZC1->ZC1_PRAZO),oFnt09,100)
oPrn:Line(nLin*76,nCol*56,nLin*79,nCol*56)
oPrn:Say (nLin*77,nCol*57,"Previsão para início de Produção:",oFnt09n,100)
oPrn:Say (nLin*77,nCol*80,DtoC(ZC1->ZC1_PREV),oFnt09,100)
//---------------------A12---------------------------------------------
oPrn:Box(nLin*79,nColInc,nLin*85,nCol*114)  
oPrn:Line(nLin*79,nColInc+(nCol*3),nLin*85,nColInc+(nCol*3))                               
oPrn:Say (nLin*81,nColInc+10,"A12",oFnt09n,100)

oPrn:Say (nLin*80,nColInc+(nCol*4),"Ferramental de propriedade do cliente?",oFnt09n,100)
oPrn:Say (nLin*80,nColInc+(nCol*33),IIF(Empty(ZC1->ZC1_FERR),"",IIF(ZC1->ZC1_FERR=="1","Sim","Não")),oFnt09,100)
oPrn:Line(nLin*79,nCol*56,nLin*82,nCol*56)
oPrn:Say (nLin*80,nCol*57,"Vida útil:",oFnt09n,100)
oPrn:Say (nLin*80,nCol*65,Transform(ZC1->ZC1_VIDA, PesqPict("ZC1","ZC1_VIDA") ),oFnt09,100)

oPrn:Box(nLin*82,nColInc+(nCol*3),nLin*85,nCol*114)                                                      
oPrn:Say (nLin*83,nColInc+(nCol*4),"Condições de pagamento do Ferramental:",oFnt09n,100)
//oPrn:Say (nLin*83,nColInc+(nCol*32),AllTrim(Posicione("SE4",1,xFilial("SE4")+ZC1->ZC1_PGTO,"E4_DESCRI")),oFnt09,100)
oPrn:Say (nLin*83,nCol*42,AllTrim(ZC1->ZC1_PGTO),oFnt09,100)
oPrn:Line(nLin*82,nCol*74,nLin*85,nCol*74)
oPrn:Say (nLin*83,nCol*75,"Inf. Adicionais:",oFnt09n,100)
oPrn:Say (nLin*83,nCol*85,AllTrim(ZC1->ZC1_ADIC),oFnt09,100)
//---------------------A13---------------------------------------------
oPrn:Box(nLin*85,nColInc,nLin*88,nCol*114)  
oPrn:Line(nLin*85,nColInc+(nCol*3),nLin*88,nColInc+(nCol*3))                               
oPrn:Say (nLin*86,nColInc+10,"A13",oFnt09n,100)

oPrn:Say (nLin*86,nColInc+(nCol*4),"Valores negociados estão de acordo com o objetivo WHB?",oFnt09n,100)
oPrn:Say (nLin*86,nCol*56,AllTrim(ZC1->ZC1_CONWHB),oFnt09,100)
//---------------------A14---------------------------------------------
oPrn:Box(nLin*88,nColInc,nLin*94,nCol*114)  
oPrn:Line(nLin*88,nColInc+(nCol*3),nLin*94,nColInc+(nCol*3))                               
oPrn:Say (nLin*91,nColInc+10,"A14",oFnt09n,100)

oPrn:Say (nLin*89,nColInc+(nCol*4),"Moeda:",oFnt09n,100)
Do Case
	Case ZC1->ZC1_MOEDA=="1"
		cMoeda:="Real"
	Case ZC1->ZC1_MOEDA=="2"
		cMoeda:="Dolar"
	Case ZC1->ZC1_MOEDA=="3"
		cMoeda:="Euro"
	OtherWise
		cMoeda:=""								
EndCase	
oPrn:Say (nLin*89,nColInc+(nCol*10),cMoeda,oFnt09,100)
oPrn:Line(nLin*88,nCol*20,nLin*91,nCol*20)

oPrn:Say (nLin*89,nCol*21,"Preço Bruto:",oFnt09n,100)
oPrn:Say (nLin*89,nCol*26,Transform(ZC1->ZC1_PRECO, PesqPict("ZC1","ZC1_PRECO") ),oFnt09,100) 
oPrn:Say (nLin*89,nCol*40,"Preço Usinado:",oFnt09n,100)
oPrn:Say (nLin*89,nCol*50,Transform(ZC1->ZC1_PRECO, PesqPict("ZC1","ZC1_PREUSI") ),oFnt09,100) 

oPrn:Line(nLin*88,nCol*66,nLin*91,nCol*66)

oPrn:Say (nLin*89,nCol*67,"Prazo Pagamento:",oFnt09n,100)
//oPrn:Say (nLin*89,nCol*55,AllTrim(Posicione("SE4",1,xFilial("SE4")+ZC1->ZC1_PRAZPG,"E4_DESCRI")),oFnt09,100)
oPrn:Say (nLin*89,nCol*83,AllTrim(ZC1->ZC1_PRAZPG),oFnt09,100)

oPrn:Box(nLin*91,nColInc+(nCol*3),nLin*94,nCol*114)  
oPrn:Say (nLin*92,nColInc+(nCol*4),"Condições de entrega:",oFnt09n,100)
oPrn:Say (nLin*92,nColInc+(nCol*20),AllTrim(ZC1->ZC1_ENTREG),oFnt09,100)
//---------------------A15---------------------------------------------
oPrn:Box(nLin*94,nColInc,nLin*100,nCol*114)  
oPrn:Line(nLin*94,nColInc+(nCol*3),nLin*100,nColInc+(nCol*3))                               
oPrn:Say (nLin*96+10,nColInc+10,"A15",oFnt09n,100)  

oPrn:Say (nLin*95,nColInc+(nCol*4),"Foram aceitas pelo cliente as condições técnicas do orçamento?",oFnt09n,100)
//oPrn:Box(nLin*97,nColInc+(nCol*3),nLin*100,nCol*114) 
oPrn:Say (nLin*98,nColInc+(nCol*4),AllTrim(ZC1->ZC1_ACEITA),oFnt09,100)
//---------------------A16---------------------------------------------
oPrn:Box(nLin*100,nColInc,nLin*103,nCol*114)  
oPrn:Line(nLin*100,nColInc+(nCol*3),nLin*103,nColInc+(nCol*3))                               
oPrn:Say (nLin*101,nColInc+10,"A16",oFnt09n,100)  

oPrn:Say (nLin*101,nColInc+(nCol*4),"A WHB possui todos os documentos necessários para o desenvolvimento?",oFnt09n,100)
oPrn:Say (nLin*101,nCol*66,IIF(Empty(ZC1->ZC1_DOCDES),"",IIF(ZC1->ZC1_DOCDES=="1","Sim","Não")),oFnt09,100)
//---------------------A17---------------------------------------------
oPrn:Box(nLin*103,nColInc,nLin*148,nCol*114)  
oPrn:Line(nLin*103,nColInc+(nCol*3),nLin*148,nColInc+(nCol*3))                               
oPrn:Say (nLin*122+10,nColInc+10,"A17",oFnt09n,100)  
oPrn:Box(nLin*103,nColInc+(nCol*3),nLin*106,nCol*114) 
oPrn:Say (nLin*104,nColInc+(nCol*4),"Documentos enviados pelo Cliente que compõem a análise crítica:",oFnt09n,100)
For nM := 1 to 15
	cLinhaObs	:=Memoline( ZC1->ZC1_OBSCLI ,160, nM ) 
	oPrn:Say (nLin*(107+nCont),nColInc+(nCol*4),cLinhaObs,oFnt09,100) 	       	
	nCont+=3	
Next nM

//---------------------Assinatura---------------------------------------------

oPrn:Box(nLin*148,nColInc,nLin*151,nCol*114)  
oPrn:Line(nLin*148,nCol*85,nLin*151,nCol*85)                                 
oPrn:Say (nLin*149,nColInc+nCol,"Análise Crítica Comercial Realizada por:",oFnt09n,100) 
oPrn:Say (nLin*149,nCol*35,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_EMITEN,"QAA_NOME")),oFnt09,100)
oPrn:Say (nLin*149,nCol*60,"Aprovada por:",oFnt09n,100)
oPrn:Say (nLin*149,nCol*70,AllTrim(Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_NOME")),oFnt09,100)
oPrn:Say (nLin*149,nCol*86,"Data Aprovação:",oFnt09n,100) 
oPrn:Say (nLin*149,nCol*99,AllTrim(DtoC(ZC1->ZC1_APPRO)),oFnt09,100) 

Return ( )                                                                                                       
//===============================FIM DO BOX01 IDENTIFICAÇÃO =======================================================