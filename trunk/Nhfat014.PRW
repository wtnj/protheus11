/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT014  ³ Autor ³ Alexandre R. Bento     Data ³ 10/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Solicitação de Nota Fiscal de Saida                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Expedição/ PCP / Manutençao / Informatica / Eng            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±Alteração ³ Felipe Ciconini                                   26/11/10  ±±
±±±          ³        Inclusão do Botão para Carregar Itens no Grid        ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß      
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function nhfat014()
                                                                                         
Local lAprova := .f.

/* //retirado pela os 073259

//-- verifica se o usuário é aprovador de nf de amostra
ZEP->(dbsetorder(1)) // FILIAL + LOGIN + AREA
If ZEP->(dbSeek(xFilial('ZEP')+ALLTRIM(UPPER(cUserName))))
	lAprova := .t.
Endif
*/
cCadastro := OemToAnsi("Solicitação de Nota Fiscal de Saida")
aRotina := {}
aAdd(aRotina,{ "Pesquisa","AxPesqui"     ,0 ,1})
aAdd(aRotina,{ "Visualizacao",'U_fSol(2)',0 ,2})
aAdd(aRotina,{ "Inclui"   ,'U_fSol(3)'   ,0 ,3})
aAdd(aRotina,{ "Altera"   ,'U_fSol(5)'   ,0 ,4})
aAdd(aRotina,{ "Exclui"   ,'U_fSol(4)'   ,0 ,5})

/* //retirado pela os 073259

If lAprova
	aAdd(aRotina,{"Aprova",'U_fSol(6)' , 0, 5})
Endif

*/

aAdd(aRotina,{ "Picking"  ,'U_fRoma()'   ,0 ,4})
aAdd(aRotina,{ "Legenda"  ,"U_FLegSol"   ,0 ,2})
            
mBrowse( 6, 1,22,75,"SZQ",,,,,,fCriaCor())

Return

User Function fSol(cPar01)

Local bOk         := {||fGrvOrd()}
Local bCanc       := {||fEnd()}
Local bEnchoice   := {||}
Local aButtons    := {}
Private aSize     := MsAdvSize()
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.)
Private aDtFusao  :={}

SetPrvt("aHeader,aCols,oMultiline,oDialog,lDialog,_lFlag,_cUser,_aF4,_nF4,cQuery1,aHead, aCol")
SetPrvt("_cDoc,_aTipoN,_cTipon,_cCond,_cCli, _cLoja,_cTpFre,_nPLiqui,_nPBruto,_nVol,_cEsp,_cMens,_cDesCli,_cF3")
SetPrvt("_cCliFor,_cTiFre,_aTiFre,_cObs,_dData,_cHora,_cPar,_lExc,_cTpCli,_nMoeda,_aVia, _cVia,_cCodTra,_cDesTra,VK_F4")
SetPrvt("_cRamal,_aGet,_cDCond,_cFab,_aFab")


DEFINE FONT oFont NAME "Arial" SIZE 10, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10

VK_F4     := 115
_lFlag    := .T. 
_lApr     := .F.

IF cPar01 == 4 //excluir
	_cPar   := 2 // visualização
  	_lExc   := .T. //Controle para excluir
  	lDialog := .T.               

/* //retirado pela os 073259

ElseIf cPar01==6 // aprovar

	If !SZQ->ZQ_STATUS$"P"
		Alert('Solicitação não está pendente de aprovação!')
		return
	Endif
	
	//-- verifica se o usuário é aprovador de nf de amostra da planta
	lAprova := .f.
	ZEP->(dbsetorder(1)) // FILIAL + LOGIN
	If ZEP->(dbSeek(xFilial('ZEP')+ALLTRIM(UPPER(cUserName))))
		
		WHILE ZEP->(!EOF()) .AND. ALLTRIM(ZEP->ZEP_LOGIN)==ALLTRIM(UPPER(cUserName))
		
			If ZEP->ZEP_PLANTA==SZQ->ZQ_FABRICA .OR. ZEP->ZEP_PLANTA=='T'
				lAprova := .t.
				exit
			Endif			
			ZEP->(dbskip())
		ENDDO
		
	Endif
			      
	If !lAprova
		Alert('Usuário não permitido para aprovar dados desta planta!')
		Return
	Endif

  	_cPar   := 2 // visual
  	_lExc   := .F.
  	_lApr   := .T.
  	lDialog := .T. 
*/

Elseif cPar01==7  // Embalagem
	_cPar   := 3
  	_lExc   := .F.
  	lDialog := .T.
Else
  	_cPar   := cPar01 // receber visualizaçao ou impressao ou alteracao     
  	_lExc   := .F.    // Controle para não excluir
  	lDialog := .F.               
Endif

if cPar01 <> 7

	_cDoc   := Space(06)                                                 
	
	If SM0->M0_CODFIL=='02' // pernambuco
		_aFab   := {"P=Pernambuco"}
	Else
		_aFab   := {"","2=FUNDICAO","3=USINAGEM","4=FORJARIA","5=VIRABREQUIM","6=ALUMINIO"}
	Endif	
	
	_aTipon := {"N=Normal",OemToAnsi("D=Dev.Compra"),"B=Util.Fornecedor"}
	_aTiFre := {"","C=CIF","F=FOB"}
	_aVia   := {"Aereo","Correio","Maritimo",OemToAnsi("Rodoviario")}
	_cVia   := "Rodoviario"
	_cCodTra:= Space(06)
	_cDesTra:= Space(40)
	_cTiFre := "C=CIF"
	_cTipon := "Normal"   
	_cFab   := "2"
	_cCliFor:= "Cliente:"
	_cCond  := Space(03)
	_cCli   := Space(06)
	_cLoja  := Space(02) 
	_cDesCli:= Space(30)          
	_cDCond := Space(20)
	_cTpFre := Space(10)  
	_cUser  := Space(06)
	_cRamal := Space(04)
	_nPLiqui:= 0          
	_nPBruto:= 0
	_nVol   := 0
	_cEsp   := "VOL"
	_cMens  := Space(100) 
	_cObs   := Space(100) 
	_cF3    := Space(03)        
	aHeader := {}        
	aCols   := {}
	_cTpCli := Space(01)
	_nMoeda := 1
//	_cAmost := ''
	_dData   := date()
	
EndIf

_cHora   := time()   	 
Aadd(aHeader,{"Item"         , "ZR_ITEM"    ,"@E 99"             ,02, 0,".F."          ,"","C","SZR"}) //01
Aadd(aHeader,{"Produto"      , "ZR_PRODUTO" ,Repli("!",15)       ,15, 0,"U_fProd()"    ,"","C","SZR"}) //02
Aadd(aHeader,{"Descrição"    , "ZR_DESCRI"  ,Repli("!",30)       ,30, 0,".T."          ,"","C","SZR"}) //03

Aadd(aHeader,{"Local"        , "ZR_LOCAL"   ,"!!"                ,02, 0,".T."          ,"","C","SZR"}) //04 -- 12

Aadd(aHeader,{"TES"          , "ZR_TES"     ,"@!"                ,03, 0,"U_Ftes()"     ,"","C","SZR"}) //05

Aadd(aHeader,{"Quantidade"   , "ZR_QTDE"    ,"@E 999,999,999.99" ,12, 2,"U_fQtde()"    ,"","N","SZR"}) //06

Aadd(aHeader,{"Localização"  , "ZR_LOCALIZ" ,Repli("!",15)       ,15, 0,"U_fSldLclz()" ,"","C","SZR"}) //07
Aadd(aHeader,{"Lote"         , "ZR_LOTECTL" ,Repli("!",10)       ,10, 0,"U_fSldLote()" ,"","C","SZR"}) //08

Aadd(aHeader,{"Preco"        , "ZR_PRECO"   ,"@E 9,999,999.9999" ,14, 4,"U_fPreco()"   ,"","N","SZR"}) //09
Aadd(aHeader,{"Total"        , "ZR_TOTAL"   ,"@E 9,999,999.9999" ,14, 4,".F."          ,"","N","SZR"}) //10
Aadd(aHeader,{"Volume"       , "ZR_VOLUME"  ,"@E 999999"         ,06, 0,".T."          ,"","N","SZR"}) //11
Aadd(aHeader,{"CFO"          , "ZR_CF"      ,"@!"                ,05, 0,".T."          ,"","C","SZR"}) //12 -- 11

Aadd(aHeader,{"P.Líquido"    , "ZR_PESOL"   ,"@E 999,999,999.99" ,14, 2,".F."          ,"","N","SZR"}) //13
Aadd(aHeader,{"P.Bruto"      , "ZR_PESOB"   ,"@E 999,999,999.99" ,14, 2,".T."          ,"","N","SZR"}) //14
Aadd(aHeader,{"N.F Orig"     , "ZR_NFORI"   ,"!!!!!!"            ,06, 0,".T."          ,"","C","SZR"}) //15
Aadd(aHeader,{"Série Orig"   , "ZR_SERIORI" ,"!!!!"              ,03, 0,".T."          ,"","C","SZR"}) //16
Aadd(aHeader,{"Item N.F Orig", "ZR_ITEMORI" ,"!!!!"              ,04, 0,".T."          ,"","C","SZR"}) //17
Aadd(aHeader,{"IdentB6"      , "ZR_IDENTB6" ,"!!!!!!"            ,06, 0,".T."          ,"","C","SZR"}) //18
//Aadd(aHeader,{"Fusão"        , "ZR_FUSAO"   ,"@!"       		 ,10, 0,"U_f14Fusao(_cPar)" ,"","C","SZR"}) //19

If _cPar==2 .or. _cPar==5 // VISUALIZA ou ALTERA
	Aadd(aHeader,{"Pedido"       , "ZR_PEDIDO"  ,"!!!!!!"            ,06, 0,".F.",         "","C","SZR"}) //20               	   
	Aadd(aHeader,{"Nota"         , "D2_DOC"     ,Repli("!",10)       ,10, 0,".F.",         "","C","SZR"}) //21
	
	
	For x:=1 to Len(aHeader)
		aHeader[x][6] := ".F."
	Next
	
	//aHeader[19][6] := "U_f14Fusao(_cPar)"             
	
	If _cPar==5 // ALTERA
		aHeader[3][6] := ".T."
		aHeader[8][6] := ".T."
	Endif
	
   fQuery()
   If !_lFlag  
      Return //retorna para browse
   Endif

	_cUser := "Solicitante:  " + UsrFullname(_cUser )

ElseIf _cPar==3 // INCLUSAO
   	_cDoc   := GetSXENum("SZQ","ZQ_NUM")   // Traz o novo numero da solicitação de NF
   	_cRamal := Iif( Empty(Subs(U_Nhcfg001("06"),6,4)),Space(04),Subs(U_Nhcfg001("06"),6,4)) 
	_cUser := "Solicitante:  " + UsrFullname(__cUserId )   
Endif     

	
   
_aGet := GetArea()

//*************************************************************\\
//***********************MONTANDO A TELA***********************\\
//*************************************************************\\

aAdd(aButtons,{"Carregar",{||fCarrega()},"Carregar ítens do release","Carregar"})

bEnchoice := {||EnchoiceBar(oDialog,bOk,bCanc,,aButtons)}
			
oDialog  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],OemToAnsi("Solicitação de Nota Fiscal de Saida"),,,,,CLR_BLACK,CLR_WHITE,,,.T.)

//Define MsDialog oDialog Title OemToAnsi("Solicitação de Nota Fiscal de Saida") From 010,030 To 458,860 Pixel 

@ 013,007 To 105,aPosObj[2,4]  Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8 Object oNum
@ 027,032 Say _cDoc Size 035,10 Object oDoc            
 oDoc:Setfont(oFont)                      
@ 027,090 Say "Tipo Nota:" Size 30,8 Object oTP
If _cpar == 3                      
   @ 025,120 COMBOBOX _cTipon ITEMS _aTipon SIZE 55,10 object oTipon
Else
   @ 027,116 say  _cTipon SIZE 70,10 object oTipon
   oTipon:Setfont(oFont)                         
Endif

@ 027,190 Say "Fab.:" Size 30,8 Object oTP
oFab := TComboBox():New(025,210,{|u| if(Pcount() > 0,_cFab := u,_cFab)},;
	_aFab,55,10,oDialog,,{||},,,,.T.,,,,{||_cPar == 3},,,,,"_cFab")

@ 027,280 Say "Data:" Size 30,8 object oDt                                
@ 025,295 Get _dData Picture "99/99/9999" When .F. Size 40,8 Object oData            
@ 027,350 Say "Hora:" Size 30,8 object oHr            
@ 025,370 Get _cHora Picture "99:99:99" When .F. Size 35,8 Object oHora              
@ 040,010 Say _cClifor Size 040,8 Object oCliFor               
@ 038,040 Get _cCli Picture "@!"  When(_cPar == 3 .Or. _cPar == 5) F3 fRetF3() Size 30,8 valid fFornece() Object oCli            
@ 038,072 Get _cLoja Picture "@!"  When(_cPar == 3 .Or. _cPar == 5) Size 10,8 valid fLoja() Object oLoja            
@ 038,090 Get _cDesCli Picture "@!" When .F. Size 100,8 Object oDesCli            
@ 040,200 Say "Transportadora:" Size 050,8 object oTransp
@ 038,240 Get _cCodTra  Size 30,8 F3 "SA4" When(_cPar == 3 .Or. _cPar == 5) valid fTransp() object oCodTra
@ 038,272 Get _cDesTra  Size 133,8 When(.F.) object oDesTra           

@ 053,010 Say "Tipo Frete:" Size 030,8 object oTpFrete           
If _cpar == 3                      
   @ 051,040 COMBOBOX _cTiFre ITEMS _aTifre SIZE 25,10 object oTiFre 
Else
   @ 053,040 say  _cTiFre SIZE 35,10 object oTiFre
   oTiFre:Setfont(oFont)                         
Endif

@ 053,070 Say "Via:" Size 010,8 object oTpFrete           
If _cpar == 3                      
   @ 051,085 COMBOBOX _cVia ITEMS _aVia SIZE 45,10 object oVia 
Else
   @ 053,083 say  _cVia SIZE 45,10 object oVia
     oVia:Setfont(oFont)                         
Endif
          
/* //retirado pela os 073259
@ 053,135 Say "Amostra:" Size 30,8 Object olAmostra
olAmostra := TComboBox():New(051,160,{|u| if(Pcount() > 0,_cAmost := u,_cAmost)},;
   {'','S=Sim','N=Não'},30,10,oDialog,,{||},,,,.T.,,,,{||_cPar == 3},,,,,"_cAmost")
*/

@ 053,200 Say "Cond. Pgto:" Size 30,8 object oCP                                
@ 051,230 Get _cCond Picture "@!" When(_cPar == 3 .Or. _cPar == 5) F3 "SE4"  Valid fCond() Size 25,8 Object oCond           
@ 051,260 Get _cDCond  Picture "@!" When .F. Size 70,8 Object oDCond             

@ 053,340 Say "Especie :"  Size 050,8 object oEspe            
@ 051,365 Get _cEsp  Picture "@!" When(_cPar == 3 .Or. _cPar == 5) Size 40,8 Object oEsp             
@ 065,010 Say "Mensagem:"   Size 040,8 object oMensa                    
@ 063,040 Get _cMens Picture "@!" When(_cPar == 3 .Or. _cPar == 5) Size 365,8 Object oMens          
@ 077,010 Say OemToAnsi("Observação:")   Size 040,8 object oOb                                        
@ 075,040 Get _cObs Picture "@!" When(_cPar == 3 .Or. _cPar == 5) Size 365,8 Object oObs          

If len(alltrim(_cUser)) > 15
   @ 090,010 Say _cUser Object oUser             
   oUser:Setfont(oFont)                      
Endif   

@ 090,210 Say OemToAnsi("Ramal:")   Size 030,8 object oRama                                        
@ 088,230 Get _cRamal Picture "@!" When(_cPar == 3 .Or. _cPar == 5) Size 20,8 valid fRamal() Object oRamal          

@ 110,006 To aPosObj[2,3],aPosObj[2,4] Title OemToAnsi("  Informações ")  

dbselectarea("SZR")

@ 120,aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] MULTILINE MODIFY DELETE VALID fMulti(.t.) OBJECT oMultiline

SetKey( VK_F4 , { || ShowF4() /*U_fNFori()*/ } ) // função que busca a nota original de campra
//@ 205,300 BUTTON "Carregar" SIZE 30,12 ACTION fCarrega() OBJECT oBt

//@ 205,350 BMPBUTTON TYPE 01 ACTION fGrvOrd()
//@ 205,380 BMPBUTTON TYPE 02 ACTION fEnd() 

oTipon:bChange:={|| fCli() }

If _cPar == 2 .Or. _cPar == 5
   oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Endif   

oDialog:Activate(,,,.F.,{||.T.},,bEnchoice)
//Activate MsDialog oDialog Center Valid fDialog()

SZR->(DbCloseArea())
If _cPar == 2 .Or. _cPar == 5
   TMP->(DbCloseArea())                  
Endif   
Set Key VK_F4 To //Desabilita a tecla F4
Return           

/***********************************************************
 * Cria um grid para digitar a data e a quantidade da Fusão *
 ***********************************************************/
User Function f14Fusao(nOpc)
Local _nCod		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRODUTO"})
Local _nItem	:= aScan(aHeader,{|x|UPPER(AllTrim(x[2])) == "ZR_ITEM"})
Local _nTes		:= aScan(aHeader,{|x|UPPER(AllTrim(x[2])) == "ZR_TES"})
aHead	:= {}
aCol	:= {}

	SB1->(DbSetOrder(1))
   	SB1->(DbSeek(xFilial("SB1")+aCols[n][_nCod]))
	If !SB1->B1_GRUPO$"PA01"
		Alert("Para digitar data de fusão, o grupo do produto deve ser PA01!")  //*************************************************************************************
   		Return .F.
	Endif
	If !aCols[n][_nTes]$"572/576/602"
		Alert("Para digitar data de fusão, TES deve ser 572, 576 ou 602!")
		Return .F.
	Endif

	For x:=1 to Len(aDtfusao)
		If aDtFusao[x][2] == aCols[n][_nItem]
			aAdd(aCol,{;
				aDtFusao[x][3],;
				aDtFusao[x][4],;
				aDtFusao[x][5],;
				aDtFusao[x][6];
			})
		Endif
	Next
	
	aAdd(aHead,{'Item'       ,"ZF3_ITEM"   , PesqPict("ZF3","ZF3_ITEM")   	, 4,0,'.F.','.t.','C','','R'})
	aAdd(aHead,{'Data'       ,"ZF3_DATA"   , '@!'   						,10,0,'.T.','.t.','C','','R'})
	aAdd(aHead,{'Quantidade' ,"ZF3_QUANTI" , PesqPict("ZF3","ZF3_QUANTI") 	,13,3,'.T.','.t.','N','','R'})
  
	If Empty(aCol)
		aAdd(aCol,{'0001',Space(10),0,.f.})
	Endif
	
	Define MsDialog oDlg Title "Fusão - Data e Quantidade" OF oDialog Pixel From 0,0 To 260,300
	oGetD  := MsNewGetDados():New(05 ,05,100,150,3,{|| F14FusLin() },"AllwaysTrue()",'+ZF3_ITEM',,0,99,"AllwaysTrue()",'',"AllwaysTrue()",oDlg,aHead,aCol)
	OGETD:LDELETE := .T.
    tButton():New(110,60,"&Confirmar"  ,oDlg,{||f14Grv(n, _nItem),},40,10,,,,.T.)
    tButton():New(110,105,"&Cancelar",oDlg,{||oDlg:End()},40,10,,,,.T.)
	Activate MsDialog oDlg Centered
Return .T.

/*********************************************************
 ** Verifica se o usuário deixou alguma linha em branco **
 **                     ## Chamada na função f14Grv()   **
 *********************************************************/
Static Function F14FusTok(_nLinha)
Local _nSoma
_nSoma := 0
	For _x:=1 To Len(oGetD:aCols)
			If Empty(oGetd:aCols[_x][3]) .And. !oGetD:aCols[_x][4]
				Alert("Não é permitido adicionar um registro em branco!")
				Return .F.
			Endif
		If(!oGetD:aCols[_x][4])//Posição 4 do aCol indica se o campo está deletado ou não (.T./.F.)
			_nSoma := _nSoma + Int(oGetD:aCols[_x][3])
		Endif
	Next
	_nx := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "ZR_QTDE"})
	If(_nSoma <> aCols[_nLinha][_nx])
		Alert("A soma das peças não corresponde à quantidade informada!")
		Return .F.
	Endif
Return .T.

/***************************************************************
 ** Verifica se o usuário deixou quantidade em branco **
 ***************************************************************/
Static function F14FusLin()
		
	If Empty(oGetd:aCols[n][3])
		Alert('Informe a quantidade!')
		Return .f.
	Endif	

Return .t.

/*******************************************************************************
 * Verifica se o registro já existe e preenche o aDtFusao com os dados do aCol *
 *******************************************************************************/
Static Function f14Grv(_nLinha, _nItem)
	If !F14FusTok(_nLinha)
		Return .F.
	Endif
	For y:=1 to Len(oGetD:aCols)
		_nx:=aScan(aDtFusao,{|x|	UPPER(AllTrim(x[1])) == _cDoc .AND.;
	 								UPPER(AllTrim(x[2])) == aCols[_nLinha][_nItem] .AND.;
									UPPER(AllTrim(x[3])) == oGetD:aCols[y][1]})
		If(_nx == 0)
			aAdd(aDtFusao,{_cDoc,aCols[_nLinha][_nItem],oGetD:aCols[y][1],oGetD:aCols[y][2],oGetD:aCols[y][3],oGetD:aCols[y][4]})
		Else
			aDtFusao[_nx][4] := oGetD:aCols[y][2]
			aDtFusao[_nx][5] := oGetD:aCols[y][3]
			aDtFusao[_nx][6] := oGetD:aCols[y][4]
		Endif
	Next
	oDlg:End()
Return .T.

Static Function fRamal()
If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
   Msgbox("Favor Preencher o Ramal do Solicitante Corretamente 123, Verifique !!!" ,"Atencao","ALERT" )     
   _cRamal := Space(04)
   Return(.F.)
Endif
Return(.T.)

fDialog() //Verifica validações

User Function fNFori()

Local _cCod    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRODUTO"})         
Local _nNFOri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_NFORI"}) 
Local _nSerOri:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_SERIORI"}) 
Local _nItOri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_ITEMORI"}) 
Local _nQtde  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"}) 
Local _nLocal := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCAL"}) 
Local _nIdent := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_IDENTB6"}) 
Local oDlg     := Nil
Local _cDesc   := Space(30)
Local _cFor    := Space(40)                                
Local nOpcA    := 0
Local _nTot    := 0 
Local _nPos    := 0 
Local _lMatriz := .F. 
Local _aF4Bkp  := {} 
Private oLbx   := Nil
Private _cNota := Space(06)
_aF4  := {}
_nF4  := 0

  //nao pega quando a linha esta deletada
If Len(aCols) == 0
   Msgbox("Falta Preencher Os Itens, Verifique !!!" ,"Atencao","ALERT" )     
   Return(.T.)   
Endif

If !Acols[n][len(aHeader)+1] .And. !_ctipon$"Dev.Compra" .And. Empty(_cCli) .And.;
   Empty(_cLoja) .And.  Empty(Acols[n][_cCod])
   Msgbox("Falta Preencher Alguns Campos, Verifique !!!" ,"Atencao","ALERT" )     
   Return(.T.)   
Endif

cQuery1 := "SELECT SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SA2.A2_NOME,SD1.D1_LOJA,SD1.D1_TIPO,SD1.D1_ITEM,SD1.D1_COD,SD1.D1_UM,"
cQuery1 += "SD1.D1_QUANT,SD1.D1_VUNIT,SD1.D1_TOTAL,SD1.D1_TES,SD1.D1_CF,SD1.D1_LOCAL,SD1.D1_EMISSAO,SB1.B1_DESC,SD1.D1_IDENTB6,SB6.B6_SALDO-SB6.B6_QULIB AS B6_SALDO "
cQuery1 += "FROM " +  RetSqlName( 'SD1' ) +" SD1, " +  RetSqlName( 'SA2' ) +" SA2, " +  RetSqlName( 'SB1' ) +" SB1, " +  RetSqlName( 'SB6' ) +" SB6 "
cQuery1 += "WHERE SD1.D1_FILIAL = '" + xFilial("SD1")+ "'"    
cQuery1 += "AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"    
cQuery1 += "AND SA2.A2_FILIAL = '" + xFilial("SA2")+ "'"    
cQuery1 += "AND SB6.B6_FILIAL = '" + xFilial("SB6")+ "'"    
cQuery1 += "AND SD1.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB6.D_E_L_E_T_ = ' ' "
cQuery1 += "AND SD1.D1_COD ='"+ Acols[n][_cCod] +"' "
//--cQuery1 += "AND SD1.D1_FORNECE ='"+ _cCli +"' "
//--cQuery1 += "AND SD1.D1_LOJA ='"+ _cLoja +"' "
cQuery1 += "AND SD1.D1_COD = SB6.B6_PRODUTO "
cQuery1 += "AND SD1.D1_COD = SB1.B1_COD "
cQuery1 += "AND SD1.D1_FORNECE = SA2.A2_COD "
cQuery1 += "AND SD1.D1_LOJA = SA2.A2_LOJA "     
cQuery1 += "AND SD1.D1_FORNECE = SB6.B6_CLIFOR "
cQuery1 += "AND SD1.D1_LOJA = SB6.B6_LOJA "
cQuery1 += "AND SD1.D1_IDENTB6 = SB6.B6_IDENT "                                           
cQuery1 += "AND SD1.D1_LOCAL = SB6.B6_LOCAL "
cQuery1 += "AND SD1.D1_DOC = SB6.B6_DOC "
cQuery1 += "AND SD1.D1_SERIE = SB6.B6_SERIE "
cQuery1 += "AND SD1.D1_TES = SB6.B6_TES "
cQuery1 += "AND (SB6.B6_SALDO-SB6.B6_QULIB) > 0 "
cQuery1 += "AND SB6.B6_TES < 500 "
cQuery1 += "AND SD1.D1_QUANT <> SD1.D1_QTDEDEV "
cQuery1 += "ORDER BY SD1.R_E_C_N_O_ " 

//MemoWrit('C:\TEMP\fat014F4.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery1 NEW ALIAS "TRB"      
TcSetField("TRB","D1_EMISSAO","D")  // Muda a data de string para date    

TRB->(DBGOTOP())
If Empty(TRB->D1_DOC)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Nenhuma Nota de Entrada Encontrada com o Produto " +Acols[n][_cCod] + ", Verifique !!!" ,"Atencao","ALERT" )     
   TRB->(DbCloseArea())
   return(.T.)
Endif    

_cDesc := Alltrim(TRB->D1_COD) +" - " + TRB->B1_DESC   //Carrega o nome do produto p/ mostrar no cabecalho
_cFor  := TRB->D1_FORNECE+"/"+TRB->D1_LOJA+" - "+TRB->A2_NOME // carrega o fornecedor p/ mostrar no cabecalho

While (!TRB->(EOF()))

   Aadd(_aF4,{TRB->D1_DOC,TRB->D1_SERIE,TRB->D1_TIPO,TRB->D1_ITEM,TRB->D1_UM,TRB->B6_SALDO,TRB->D1_VUNIT,TRB->D1_LOCAL,TRB->D1_IDENTB6,.F.})

   TRB->(Dbskip())
Enddo     

_nTot := len(aCols)-1
If len(aCols) > 1
   For _nx:=1 to _nTot

      _npos := Ascan(_aF4, {|x| x[1]+x[2]+x[4]+x[8]+x[9] == aCols[_nx][_nNFOri]+aCols[_nx][_nSerOri]+aCols[_nx][_nItOri]+aCols[_nx][_nLocal]+aCols[_nx][_nIdent]})        

      If _npos <> 0
         _aF4[_npos][6] -= aCols[_nx][_nQtde] //Diminui a qtde já utilizada no acols p/ formar o saldo do poder de terceiro 
         If _aF4[_npos][6] == 0
            _lMatriz := .T.
         Endif   
      Endif
   Next _nx
Endif

If _lMatriz

   _aF4Bkp := aClone(_aF4) 
   _aF4    := {}
   For _nx:=1 to len(_aF4Bkp)
      If _aF4Bkp[_nx][6] <> 0
         Aadd(_aF4,{_aF4Bkp[_nx][1],_aF4Bkp[_nx][2],_aF4Bkp[_nx][3],_aF4Bkp[_nx][4],_aF4Bkp[_nx][5],_aF4Bkp[_nx][6],_aF4Bkp[_nx][7],_aF4Bkp[_nx][8],_aF4Bkp[_nx][9],.F.})
      Endif
   next _nx
   _lMatriz := .F.
Endif

TRB->(DbCloseArea())

//+-----------------------------------------------+
//| Monta a tela para usuario Visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE "Consulta" FROM 0,0 TO 500,730 PIXEL

@ 40,10 LISTBOX oLbx FIELDS HEADER ;
   "Nota Fiscal", "Serie", "Tipo", "Item", "Unid.", "Quantidade","Vlr Unit","Local","IdentB6" ;
   SIZE 350,180 OF oDlg PIXEL ON DBLCLICK( u_EdList(oLbx:nAt),oDlg:End())

  
oLbx:SetArray( _aF4 )
//oLbx:bLine := {||{_aF4[oLbx:nAt]}}    

oLbx:bLine := {|| {_aF4[oLbx:nAt,1],; //Nota fiscal
                   _aF4[oLbx:nAt,2],; // Serie
                   _aF4[oLbx:nAt,3],; // Tipo
                   _aF4[oLbx:nAt,4],; // Item
                   _aF4[oLbx:nAt,5],; // Unidade
                   _aF4[oLbx:nAt,6],; // Qtde
                   _aF4[oLbx:nAt,7],; // Vlr Unitario
                   _aF4[oLbx:nAt,8],; // Local
                   _aF4[oLbx:nAt,9]}} // IdentB6
oLbx:Refresh()                   
@ 15,10 SAY "Codigo:" SIZE 60,008 PIXEL OF oDlg
@ 15,35 SAY _cDesc SIZE 260,008 PIXEL OF oDlg FONT oFont COLOR CLR_BLACK //Object oDes
@ 26,10 SAY "Fornecedor/Loja:" SIZE 60,008 PIXEL OF oDlg
@ 26,55 SAY _cFor SIZE 260,008 PIXEL OF oDlg FONT oFont COLOR CLR_BLACK 	                    

@ 225,10 SAY "Pesquisa Por:  Numero da NF" SIZE 100,008 PIXEL OF oDlg 
@ 235,10 SAY "Localizar : " SIZE 060,008 PIXEL OF oDlg 
@ 235,45 Get _cNota  Picture "@!" SIZE 060,008 PIXEL OF oDlg VALID fNota() 

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||U_EdList(oLbx:nAt),nOpcA:=1,oDlg:End(),.T.},{||oDlg:End()})
                              
If nOpcA == 1      
    oMultiline:Refresh()
Endif
Return .T.

Static Function fNota()

   Local _nNF := Ascan(_af4, {|x| x[1] == _cNota}) //LOCALIZA a nota na matriz     
   oLbx:nAt :=_nNF //posiciona o registro na matriz
   oLbx:Refresh(.f.) // atualiza a matriz p/ mostrar em tela
Return(.T.)

User Function Edlist(_nPos)

Local _nNFOri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_NFORI"}) 
Local _nSerOri:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_SERIORI"}) 
Local _nItOri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_ITEMORI"}) 
Local _nPreco := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRECO"}) 
Local _nQtde  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"}) 
Local _nTot   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TOTAL"}) 
Local _nIdent := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_IDENTB6"}) 
dbSelectArea("SZR")

//Alert( " estou aqui EDLIST" )
If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
    Acols[n][_nIdent] := _aF4[_nPos,9]
    Acols[n][_nPreco] := _aF4[_nPos,7]
    Acols[n][_nQtde]  := _aF4[_nPos,6]    
    Acols[n][_nNFOri] := _aF4[_nPos,1]    
    Acols[n][_nSerOri]:= _aF4[_nPos,2]            
    Acols[n][_nItOri] := _aF4[_nPos,4]        
    Acols[n][_nTot]   := Acols[n][_nQtde] * Acols[n][_nPreco]
Endif      
oLbx:Refresh() // atualiza a matriz p/ mostrar em tela
oMultiline:Refresh()
Return(.T.)
                
User Function fPreco()
Local _lRet  := .T.
Local _nPreco:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRECO"})
Local _nQtde := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"})
Local _nTot  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TOTAL"}) 

	If Acols[n][_nPreco] > 1 .And. !_ctipon$"B"                        
	   Msgbox("Nao Pode Alterar o Preco do Produto, Verifique !!!" ,"Atencao","ALERT" )     
	   _lRet := .F.
	Else
		Acols[n][_nTot] := aCols[n][_nQtde] * M->ZR_PRECO//Acols[n][_nPrc]
		oMultiline:Refresh()
	Endif

	

Return(_lRet)



User Function fTes()

Local _nCFO  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_CF"}) 
Local _nTES  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TES"}) 
Local nPosLclz  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCALIZ"}) 
Local nPosLote  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOTECTL"}) 

Local _cEst  := GetMv("MV_ESTADO")
Local _cCFO  := Space(05)

If !Empty(M->ZR_TES)
//Empty(Acols[n][_nTES])
   SF4->(DbSetOrder(1))
   If SF4->(DbSeek(xFilial("SF4")+M->ZR_TES))   

	   If (_ctipon$ "DB")
	       Acols[n][_nCFO] := Iif(SA2->A2_TIPO!="X",If(SA2->A2_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))
	   Else
	       Acols[n][_nCFO] := Iif(SA1->A1_TIPO!="X",If(SA1->A1_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))
	   EndIf
	   
		If !ALLTRIM(SF4->F4_ESTOQUE)$'S'
	 		aCols[n][nPosLclz] := space(15)
	 		aCols[n][nPosLote] := space(10)
	    Endif
	   
   Endif	   
Endif
oMultiline:Refresh()  

Return(.T.)


Static Function fQuery()
Local cQuery

cQuery := "SELECT SZQ.R_E_C_N_O_ AS 'ZQ_RECNO',SZR.R_E_C_N_O_ AS 'ZR_RECNO',*,"
cQuery += "'NOTA' = "
cQuery += "CASE WHEN SZR.ZR_PEDIDO <> ' ' THEN " //se existir pedido busca a NF gerada
cQuery += " (SELECT TOP 1 D2_DOC+'-'+D2_SERIE "
cQuery += "  FROM "+RetSqlName("SD2")
cQuery += "  WHERE D_E_L_E_T_ = ' ' AND SZR.ZR_PEDIDO = D2_PEDIDO "
cQuery += "  AND D2_COD = SZR.ZR_PRODUTO) "
cQuery += "  END "
cQuery += "FROM " +  RetSqlName( 'SZQ' ) +" SZQ, " +  RetSqlName( 'SZR' ) +" SZR "
cQuery += "WHERE SZQ.ZQ_FILIAL = '" + xFilial("SZQ")+ "'"    
cQuery += "AND SZR.ZR_FILIAL = '" + xFilial("SZR")+ "'"    
cQuery += "AND SZR.D_E_L_E_T_ = ' ' "
cQuery += "AND SZQ.D_E_L_E_T_ = ' ' "
cQuery += "AND SZQ.ZQ_NUM = SZR.ZR_NUM "
cQuery += "AND SZQ.ZQ_EMISSAO = SZR.ZR_EMISSAO "
//If _lExc //SE for exclusão da solicitação não pode estar gerada pedido
//   cQuery += "AND SZR.ZR_PEDIDO = ' ' AND SZQ.ZQ_STATUS = ' ' "
//Endif
cQuery += "AND SZQ.ZQ_NUM BETWEEN '" + SZQ->ZQ_NUM + "' AND '" + SZQ->ZQ_NUM + "' "                                                                                                           
cQuery += "order by SZR.ZR_NUM,SZR.ZR_ITEM"

   
// MemoWrit('C:\TEMP\fat014.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","ZQ_EMISSAO","D")  // Muda a data de string para date    

//DbSelectArea("TMP")
TMP->(DBGOTOP())
If Empty(TMP->ZQ_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   TMP->(DbCloseArea())
   return
Endif    

/* 
If _lExc //SE for exclusão da solicitação não pode estar gerada pedido
   If !Empty(TMP->ZR_PEDIDO)
      Msgbox("Solicitação Nao Pode ser Excluida, pois possui Pedido gerado !!!"+chr(13)+;
             " Numero "+TMP->ZR_PEDIDO + " Favor Excluir Antes o Pedido ","Atencao","ALERT" )     
      TMP->(DbCloseArea())
      _lFlag  := .F.
      return
   Endif
Endif
*/

//Atribui variaveis para consulta

_cDoc     := TMP->ZQ_NUM     
_cCli     := TMP->ZQ_CLIENTE 
_cLoja    := TMP->ZQ_LOJA  
_cTipon	  := IIf(TMP->ZQ_TIPO$"N","Normal",IIf(TMP->ZQ_TIPO$"D","Dev.Compra","Util.Fornecedor"))  //Cliente         
_cFab     := TMP->ZQ_FABRICA //IIf(TMP->ZQ_FABRICA$"2","FUNDICAO",IIf(TMP->ZQ_FABRICA$"3","USINAGEM",IIf(TMP->ZQ_FABRICA$"4","FORJARIA",IIf(TMP->ZQ_FABRICA$"5","VIRABREQUIM",""))))  //Fabrica
//_cAmost   := TMP->ZQ_AMOSTRA

If(_ctipon$"Normal")  
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
      _cDesCli := SA1->A1_NOME
   Endif
Else                    
   SA2->(DbSetOrder(1))
   If SA2->(DbSeek(xFilial("SA2")+_cCli+_cLoja))
      _cDesCli := SA2->A2_NOME
   Endif
 
Endif

//ObjectMethod(oDesCli,"Refresh()")

_cHora    := TMP->ZQ_HORA   
_dData    := Dtoc(TMP->ZQ_EMISSAO) 
_cTiFre   := Iif(TMP->ZQ_TIPOFRE=="C","CIF","FOB")
_cEsp     := TMP->ZQ_ESPECIE 
_cCond	  := TMP->ZQ_CONDPG 
_cMens    := TMP->ZQ_MENS 
_cObs     := TMP->ZQ_OBS   
_cCodTra  := TMP->ZQ_TRANSP   
_cVia     := TMP->ZQ_VIA
_cUser    := TMP->ZQ_USER
_cRamal   := StrZero(TMP->ZQ_RAMAL,4)

SE4->(DbSetOrder(1))
If SE4->(DbSeek(xFilial("SE4")+_cCond))
   _cDCond := SE4->E4_DESCRI 
//    ObjectMethod(oCond,"Refresh()")
//    ObjectMethod(oDCond,"Refresh()")
Endif   
 

SA4->(DbSetOrder(1))
SA4->(DbSeek(xFilial("SA4")+_cCodTra))
    _cDesTra := SA4->A4_NOME

DbSelectArea("SZR")
While (!TMP->(EOF()))

  
   If _cPar == 2 .OR. _cPar == 5 //Visualização
      Aadd(aCols,{TMP->ZR_ITEM, TMP->ZR_PRODUTO,TMP->ZR_DESCRI,TMP->ZR_LOCAL,TMP->ZR_TES,TMP->ZR_QTDE, TMP->ZR_LOCALIZ,TMP->ZR_LOTECTL,TMP->ZR_PRECO,TMP->ZR_TOTAL,TMP->ZR_VOLUME,TMP->ZR_CF,  TMP->ZR_PESOL,  TMP->ZR_PESOB,TMP->ZR_NFORI, TMP->ZR_SERIORI, TMP->ZR_ITEMORI,TMP->ZR_IDENTB6,/*Space(1),*/TMP->ZR_PEDIDO,Iif(TMP->NOTA$"NULL","",TMP->NOTA),.F.})
   Else
      Aadd(aCols,{TMP->ZR_ITEM, TMP->ZR_PRODUTO,TMP->ZR_DESCRI,TMP->ZR_LOCAL,TMP->ZR_TES,TMP->ZR_QTDE, TMP->ZR_LOCALIZ,TMP->ZR_LOTECTL,TMP->ZR_PRECO,TMP->ZR_TOTAL,TMP->ZR_VOLUME,TMP->ZR_CF,  TMP->ZR_PESOL,  TMP->ZR_PESOB,TMP->ZR_NFORI, TMP->ZR_SERIORI, TMP->ZR_ITEMORI,TMP->ZR_IDENTB6,/*Space(1),*/.F.})
   Endif   
   
   TMP->(Dbskip())
Enddo

//Preenche o array que irá alimentar o grid da data de Fusão
	ZF3->(DbSetOrder(1))
	ZF3->(DbSeek(xFilial("ZF3")+_cDoc,.T.))
	While(!ZF3->(Eof()) .AND. ZF3->ZF3_NUMERO == _cDoc)
		aAdd(aDtFusao,{;
			ZF3->ZF3_NUMERO,;
		    ZF3->ZF3_ZRITEM,;
			ZF3->ZF3_ITEM,;
			ZF3->ZF3_DATA,;
			ZF3->ZF3_QUANTI,;
			.F.;
		})
		
		ZF3->(DbSkip())
	Enddo

Return


Static Function fCond()
Local lRet := .T.

   SE4->(DbSetOrder(1))
   If SE4->(DbSeek(xFilial("SE4")+_cCond))
      _cDCond := SE4->E4_DESCRI
   Else
      Msgbox("Condicao de Pagamento Nao Encontrada, Verifique !!!" ,"Atencao","ALERT" )     
      lRet := .F.
   Endif
   oDCond:Refresh()
Return(lRet)


Static Function fDialog()

   If Empty(_cTipon) .Or. Empty(_cTiFre) .or. Empty(_cCond) .or.;
      Empty(_cCli) .or. Empty(_cLoja) .or. Empty(_cRamal) .Or. ; 
      Empty(_cEsp) .or. Len(aCols) == 0 .or. Empty(_cCodTra) /*  .or. Empty(_cAmost)*/
      lDialog := .F.  
   Else
      lDialog := .T.                        
   Endif        
   lDialog := fMulti(.f.) // Verifica o acols se foi preenchido todos os campos
   
Return(lDialog)

Static Function fFornece()

If Empty(_cCli) .Or. Len(Alltrim(_cCli)) < 6
   Return(.F.)
Endif

If(_ctipon$"Normal")  
   SA1->(DbSetOrder(1))
   If !SA1->(DbSeek(xFilial("SA1")+_cCli,.T.))
      Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      oCli:SetFocus(oCli)
      ObjectMethod(oCli,"Refresh()")
      Return(.F.)
     
   Endif
Else                    
   SA2->(DbSetOrder(1))
   If !SA2->(DbSeek(xFilial("SA2")+_cCli,.T.))
      Msgbox("Fornecedor Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      oCli:SetFocus(oCli)      
      oCli:Refresh()
      Return(.F.)
   Endif     
   
Endif

If Empty(_cLoja)
	_cLoja := "01" //traz a loja padrao
EndIf

oLoja:Refresh()

If(_ctipon$"B")  
   _cCond := "AV"
   _cDCond := "A VISTA"
   
   oDCond:Refresh()
   oCond:Refresh()   
Endif
          
Return(.T.)


User Function fProd()
Local _nDescri:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_DESCRI"}) 
Local _nLocal := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCAL"}) 
Local _nPreco := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRECO"}) 
Local _nPLiq  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PESOL"})      
Local _nTes   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TES"})      
Local _nCfo   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_CF"})      
Local _nQtde  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"})      
Local _cLocal := Space(02)
Local _cEst   := GetMv("MV_ESTADO")

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada

	SB1->(DbSetOrder(1))
   	If SB1->(DbSeek(xFilial("SB1")+M->ZR_PRODUTO))
   	   If SB1->B1_MSBLQL == '1'
          Msgbox("Produto Bloqueado para Uso, Verifique !!!" ,"Atencao","ALERT" )     
      	  Return .F.   	   
   	   Endif
      	Acols[n][_nDescri] := SB1->B1_DESC
      	Acols[n][_nQtde] := 0

      	IF SM0->M0_CODIGO == "FN" .and. SB1->B1_GRUPO$"PA01" //empresa Fundicao      
           	Acols[n][_nLocal] := "27" //almox prod acabado nao é local padrao
       	Else
			Acols[n][_nLocal] := SB1->B1_LOCPAD                 
		Endif
     
      	If(_ctipon$"Normal")  //Cliente         
         	Acols[n][_nPreco] := SB1->B1_PRV1      
      	Else 
         	Acols[n][_nPreco] := SB1->B1_UPRC      
      	EndIf
      
      	Acols[n][_nPreco]  := Iif(Acols[n][_nPreco]==0,1,Acols[n][_nPreco]) //verifica se carregou o preco de venda senão coloca 1

      	Acols[n][_nTes]    := SB1->B1_TS  //Traz a TES
      	
      	If !Empty(Acols[n][_nTes])
    	  	SF4->(DbSetOrder(1))
	      	If SF4->(DbSeek(xFilial("SF4")+Acols[n][_nTes]))   
             	
			 	If(_ctipon$"Normal")  
					SA1->(DbSetOrder(1))
					If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
			      		Acols[n][_nCfo] := Iif(SA1->A1_TIPOCLI!="X",If(SA1->A1_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))   
			    	Endif
			 	Else                    
                	SA2->(DbSetOrder(1))
                	If SA2->(DbSeek(xFilial("SA2")+_cCli+_cLoja))
                   		Acols[n][_nCfo] := Iif(SA2->A2_TIPO!="X",If(SA2->A2_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))            
                	Endif
             	Endif
	      	Endif
	  	Endif    
   	Else
      	Msgbox("Produto Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      	Return .F.
   	Endif
Endif                 

Return .T.  


Static Function fCli()

If(_ctipon$"Normal")  //Cliente
   _cCliFor:= "Cliente:"
   oCli:cF3:= "SA1"     

else //Fornecedor (_ctipon$"Dev.Compra/Util.") 
   _cCliFor:= "Fornece:"
   oCli:cF3:= "SA2"
endif

_cCli   := Space(06) 
_cLoja  := Space(02) 
_cDesCli:= Space(30) 

oCli:Refresh()
oLoja:Refresh() 
oDesCli:Refresh() 
ObjectMethod(oCliFor,"SetText(_cCliFor)") //Muda conteudo para cliente ou fornecedor
          
Return()

Static Function fRetF3()

If(_ctipon$"Normal")  
   _cF3:= "SA1" //Cadastro de Cliente
else //IF (_ctipon$"Dev.Compra/Util.") 
   _cF3:= "SA2" // Cadastro de fornecedores
endif
return(_cF3) 

Static Function fTransp()

   SA4->(DbSetOrder(1))
   If SA4->(DbSeek(xFilial("SA4")+_cCodTra))
      _cDesTra := SA4->A4_NOME
   Else
      Msgbox("Transportadora Nao Encontrada, Verifique !!!" ,"Atencao","ALERT" )     
      Return(.F.)
   Endif
   oDesTra:Refresh()
Return(.T.)


Static Function fLoja()

If(_ctipon$"Normal")  
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))

       If SA1->A1_MSBLQL== "1" //bloqueado sim
          Msgbox("Clienter Bloqueado para Uso, Verifique !!!" ,"Atencao","ALERT" )     
		  _cCli   := Space(06) 
		  _cLoja  := Space(02) 
		  _cDesCli:= Space(30) 
		  oCli:Refresh()
		  oLoja:Refresh() 
	  	  oDesCli:Refresh() 
          oCli:show()
          oCli:SetFocus()      
          oCli:Refresh()
          Return(.T.)
       Endif

      _cDesCli := SA1->A1_NOME
      _cLoja   := SA1->A1_LOJA 
      _cTpCli  := Iif(SA1->A1_TIPO$"R/S/F",SA1->A1_TIPO,"F")
      _nMoeda  := SA1->A1_MOEDA
      _cTiFre  := SA1->A1_TPFRET
      _cCond   := Iif(!_ctipon$"B",Iif(!Empty(SA1->A1_COND),SA1->A1_COND,"APR"),_cCond)
      If !Empty(_cCond )     
         SE4->(DbSetOrder(1))
         If SE4->(DbSeek(xFilial("SE4")+_cCond))
            _cDCond := SE4->E4_DESCRI 
           ObjectMethod(oCond,"Refresh()")
           ObjectMethod(oDCond,"Refresh()")
         Endif   
      Endif         

      _cCodTra := SA1->A1_TRANSP
      _cDesTra := Space(30)
      oDesTra:Refresh()
      If !Empty(_cCodTra )     
         SA4->(DbSetOrder(1))
         If SA4->(DbSeek(xFilial("SA4")+_cCodTra))
            _cDesTra := SA4->A4_NOME   
           ObjectMethod(oCodTra,"Refresh()")
           ObjectMethod(oDesTra,"Refresh()")
         Endif   
      Endif         
   Else
      Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      oCli:SetFocus(oCli)
      ObjectMethod(oCli,"Refresh()")
      oCli:Refresh()     
      DlgRefresh(oDialog)
      Return(.T.)                                       	
   Endif
Else                    
   SA2->(DbSetOrder(1))
   If SA2->(DbSeek(xFilial("SA2")+_cCli+_cLoja))
   
      If SA2->A2_MSBLQL== "1" //bloqueado sim
         Msgbox("Fornecedor Bloqueado para Uso, Verifique !!!" ,"Atencao","ALERT" )     
         
		 _cCli   := Space(06) 
		 _cLoja  := Space(02) 
		 _cDesCli:= Space(30) 
		 oCli:Refresh()
		 oLoja:Refresh() 
	  	 oDesCli:Refresh() 

         oCli:show()
         oCli:SetFocus()      
         oCli:Refresh()
         Return(.F.)
      Endif
   
   
      _cDesCli := SA2->A2_NOME
      _cLoja   := SA2->A2_LOJA
      _cTpCli  := Iif(SA2->A2_TIPO$"R/S/F",SA2->A2_TIPO,"F")      
      _nMoeda  := 1
//      _cCond   := Iif(!Empty(SA2->A2_COND),SA2->A2_COND,"APR")      
      _cCond   := Iif(!_ctipon$"B",Iif(!Empty(SA2->A2_COND),SA2->A2_COND,"APR"),_cCond)
      _cCodTra := SA2->A2_TRANSP
      If !Empty(_cCodTra )     
         SA4->(DbSetOrder(1))
         If SA4->(DbSeek(xFilial("SA4")+_cCodTra))
            _cDesTra := SA4->A4_NOME   
           ObjectMethod(oCodTra,"Refresh()")
           ObjectMethod(oDesTra,"Refresh()")
         Endif   
      Endif         
   Else
      Msgbox("Fornecedor Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      oCli:SetFocus(oCli)      
      oCli:Refresh()
      Return(.F.)
   Endif
 
Endif

ObjectMethod(oDesCli,"Refresh()")
ObjectMethod(oLoja,"Refresh()")

Return(.T.)

Static Function fEnd() 

   If _cPar == 3 //Opcao incluir
      RollBackSx8() //Volta a numeração da Ordem de Liberação
   Endif   
   Close(oDialog)                        

Return


Static Function fGrvOrd()
//Local lAmostra := .F. 
Local laprov := .F.  
Local lProdPa := .F.
Local _lGravou := .F.
Local cQuery2

Local aEmbalagem
Local cMensa := ""
Local _nProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRODUTO"}) 
Local _nTes	 := aScan(aHeader,{|x|UPPER(AllTrim(x[2])) == "ZR_TES"})	

	//-- VALIDACAO
   
	SB6->(DbSetOrder(6))//filial + doc + serie + ident + produto + clifor + loja
   	If _cPar == 3 .OR. _cPar == 5 //incluir ou alterar
   	
		For _x:=1 to Len(aCols)  
         	If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
		   		//if Alltrim(Acols[_x][_nProd])$"WBR23.1.0094.00/WBR23.1.0095.00/WBR25.1.0093.00/CNH35.1.0310.00/CNH35.1.0311.00" .and. !(_cCli+_cLoja)$"00918601"
		   		//	Alert("Para o produto "+Alltrim(Acols[_x][_nProd])+" somente permitido utilizar fornecedor 009186 loja 01!")
		   		//	Return .f.
		   		//ENDIF
		   		
		   		// RETIRADO 17/04/2014 - JOAOFR (a pedido de Fabio do Compras)
		   		/*
		   		if Acols[_x][_nTes]$"593" .and. Alltrim(Acols[_x][_nProd])$"SCA01.1.0377.00" .and. !(_cCli+_cLoja)$"00562102"
		   			Alert("Para o produto "+Alltrim(Acols[_x][_nProd])+" e TES 593 somente permitido utilizar fornecedor 005621 loja 02!")
		   			Return .f.
		   		ENDIF
		   		*/
			ENDIF
		Next
   
      	If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
         	Msgbox("Favor Preencher o Ramal do Solicitante Corretamente gravada, Verifique !!!" ,"Atencao","ALERT" )     
         	Return(.F.)
      	Endif       
      
		If !fDialog()  //Verifica as validações
			Msgbox("Falta Preencher algum Campo Obrigatorio, Verifique !!!" ,"Atencao","ALERT" )
			Return(.F.)
		Endif
		
		If !fMulti(.f.)  //Verifica as validações
			Return(.F.)
		Endif
		
	Endif
	
   	If _cPar == 3 // incluir	

		If SZQ->(DbSeek(xFilial("SZQ")+_cDoc),Found())
			Msgbox("Solicitação já foi Gravada com Este Numero, Verifique !!!" ,"Atencao","ALERT" )
			RETURN .F.
		Endif
			      
	    //Begin Transaction                 
	    
		Reclock("SZQ",.T.)
			SZQ->ZQ_FILIAL  := xFilial("SZQ")
			SZQ->ZQ_NUM     := _cDoc
			SZQ->ZQ_CLIENTE := _cCli
			SZQ->ZQ_LOJA    := _cLoja
			SZQ->ZQ_TIPO    := IIf(_ctipon$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente
			SZQ->ZQ_FABRICA := _cFab //IIf(_cFab$"WHB II","2",IIf(_cFab$"WHB III","3",IIf(_cFab$"WHB IV","4",IIf(_cFab$"WHB V","5",""))))  //Fabrica
			SZQ->ZQ_EMISSAO := Date()
			SZQ->ZQ_HORA    := time()
			SZQ->ZQ_TIPOFRE := _cTiFre
			SZQ->ZQ_ESPECIE := _cEsp
			SZQ->ZQ_CONDPG  := _cCond
			SZQ->ZQ_MENS    := _cMens
			SZQ->ZQ_OBS     := _cObs
			SZQ->ZQ_TIPOCLI := Iif(Empty(_cTpCli),IIf(_ctipon$"Normal","F","R"),_cTpCli)
			SZQ->ZQ_MOEDA   := Iif(_nMoeda==0,1,_nMoeda)
			SZQ->ZQ_VIA     := _cVia
			SZQ->ZQ_TRANSP  :=	_cCodTra
			SZQ->ZQ_USER    := __cUserId
			SZQ->ZQ_RAMAL   := Val(_cRamal)
//			SZQ->ZQ_AMOSTRA := _cAmost 
			SZQ->ZQ_SOLIC 	:= Alltrim(UsrFullName(__cUserId))
		MsUnlock("SZQ")
		
		ConfirmSX8()                 
		      
		For _x:=1 to Len(aCols)  
          	If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
          	
          		 Reclock("SZQ",.F.)
		     		SZQ->ZQ_TESBASE := Acols[_x][5]
		     	 MsUnlock("SZQ")

				 Reclock("SZR",.T.)   
				    SZR->ZR_FILIAL  := xFilial("SZR")
				    SZR->ZR_NUM     := _cDoc
				    SZR->ZR_PRODUTO := Acols[_x][2] //produto
				    SZR->ZR_ITEM    := Acols[_x][1] //item do produto
				    SZR->ZR_DESCRI  := Acols[_x][3] //descricao do produto
				    SZR->ZR_LOCAL   := Acols[_x][4] //almoxarifado do produto
		  		    SZR->ZR_TES     := Acols[_x][5] //TES
				    SZR->ZR_QTDE    := Acols[_x][6] //quantidade
	  		        SZR->ZR_LOCALIZ := Acols[_x][7]
		  		    SZR->ZR_LOTECTL := Acols[_x][8]
				    SZR->ZR_PRECO   := Acols[_x][9] //preco	            
				    SZR->ZR_TOTAL   := Acols[_x][10] //preco total
		  		    SZR->ZR_VOLUME  := Acols[_x][11] //volume			    

		  		    SZR->ZR_CF      := Acols[_x][12] //CFO		            		            
		   	        SZR->ZR_PESOL   := Acols[_x][13] // peso liquido
		            SZR->ZR_PESOB   := Acols[_x][14] //Peso bruto   	    	        
		  		    SZR->ZR_NFORI   := Acols[_x][15] //nota fiscal original  		            
		  		    SZR->ZR_SERIORI := Acols[_x][16] //Seria da nota fiscal original  		            
		  		    SZR->ZR_ITEMORI := Acols[_x][17] //Item da nota fiscal original
		  		    SZR->ZR_IDENTB6 := Acols[_x][18] //Identificação do SB6	  		    
				    SZR->ZR_EMISSAO := Date()        //Valor por item da NF		            
			     MsUnlock("SZR")
		        
		        /* //retirado pela os 073259

		     	//-- SOMENTE FN E NH
		     	If SM0->M0_CODIGO$"NH/FN"
			     	//-- verifica se algum item da solicitacao é para amostra
				    If _cAmost=='S' //Acols[_x][8]$"528/529/527/530/532"
			     		lAmostra := .T.
			     		If SZQ->(DbSeek(xFilial("SZQ")+_cDoc))
			     	
					     	Msgbox("A NF de Amostra será emitida somente após aprovação dos responsáveis!" ,"Atencao","INFO" )     
				     	
				     		Reclock("SZQ",.F.)
					     		SZQ->ZQ_STATUS := 'P'
					     	MsUnlock("SZQ")
			     		Endif
			     	Endif
				Endif
				
				*/

			  	// Adicionado em 10/12/2013 - OS 57660
				//-- FN PERNAMBUCO --------------------
		     	If SM0->M0_CODIGO$"FN" .AND. SM0->M0_CODFIL$"02"
			     	//-- verifica se algum item da solicitacao possui TES que NÃO seja de venda
				    If val(Acols[_x][5]) <> 576
			     		laprov := .T.
			     		If SZQ->(DbSeek(xFilial("SZQ")+_cDoc))
			     	
					     	//Msgbox("A NF será emitida somente após aprovação dos responsáveis da logistica!" ,"Pendente Aprovação PE","INFO" )     
				     	
				     		Reclock("SZQ",.F.)
					     		SZQ->ZQ_STATUS := 'A'
					     	MsUnlock("SZQ")
					     	
			     		Endif
			     	Endif
				Endif				 
				// ------------------------------------				
						       
		     	If SB6->(DbSeek(xFilial("SB6")+Acols[_x][15]+Acols[_x][16]+Acols[_x][18]+Acols[_x][2],Found()))
  			    	Reclock("SB6",.F.)                                                                                           
  			       		SB6->B6_QULIB+=Acols[_x][6] //Reserva/libera a qtde no poder de terceiro
  		         	MsUnlock("SB6")  			    
			 	Endif  
			 	      
			 	/*
			 	if SM0->M0_CODIGO$'FN'
				 	// Verifica se o produto é um PA
				 	SB1->(DbSetOrder(1))//filial + cod         			 	
				 	If SB1->(DbSeek(xFilial("SB1")+Acols[_x][2]))
				 	   If substr(Alltrim(SB1->B1_GRUPO),1,2)$"PA"
				 	   	  aEmbalagem :=  fBuscaEmb(SZR->ZR_PRODUTO)
				 	   	  lProdPa := .T.
				 	   EndIf	
				 	EndIf
				 endif
			 	 */ 
	  		Endif   
		Next _x
       
       /* //retirado pela os 073259
       
	  	If lAmostra
	  		Processa({|| fMailAmostra() },'Gerando Solicitação de NF de Amostra')
	  	Endif
	  	*/
	  	// Adicionado em 10/12/2013 - OS 57660
	  	If laprov
	  		Processa({|| fMailAprov(_cDoc) },'Gerando Pendencia de Aprovação de NF')
	  	Endif
	         
        //ZF3->(DbSetOrder(1))
        For _x:=1 To Len(aDtFusao)
        	If !aDtFusao[_x][6]
        			Reclock("ZF3",.T.)
        				ZF3->ZF3_FILIAL 	:= xFilial("ZF3")
        				ZF3->ZF3_NUMERO 	:= aDtFusao[_x][1]
        				ZF3->ZF3_ZRITEM 	:= aDtFusao[_x][2]
        				ZF3->ZF3_ITEM 		:= aDtFusao[_x][3]
        				ZF3->ZF3_DATA 		:= aDtFusao[_x][4]
        				ZF3->ZF3_QUANTI 	:= aDtFusao[_x][5]
        			MsUnlock("ZF3")
        	Endif
        Next 
		
      
	       
   	ElseIf _cPar == 5 //Alterar

     	TMP->(DbGotop())
     	While (!TMP->(EOF()))
     
 			If SB6->(DbSeek(xFilial("SB6")+TMP->ZR_NFORI+TMP->ZR_SERIORI+TMP->ZR_IDENTB6+TMP->ZR_PRODUTO,Found()))
  		   		Reclock("SB6",.F.)
  		      		SB6->B6_QULIB -= TMP->ZR_QTDE //Na alteração diminui qtde no poder de terceiro
  		   		MsUnlock("SB6")  			    
  	   		Endif   
  		
  		   	TMP->(Dbskip())
  		Enddo   
  		       
		Reclock("SZQ",.F.)
			SZQ->ZQ_FILIAL  := xFilial("SZQ")
			SZQ->ZQ_NUM     := _cDoc
			SZQ->ZQ_CLIENTE := _cCli
			SZQ->ZQ_LOJA    := _cLoja
			SZQ->ZQ_TIPO    := IIf(_ctipon$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente
			SZQ->ZQ_FABRICA := _cFab//IIf(_cFab$"FUNDICAO","2",IIf(_cFab$"USINAGEM","3",IIf(_cFab$"FORJARIA","4",IIf(_cFab$"VIRABREQUIM","5",Iif(_cFab$"ALUMINIO","6","")))))  //Fabrica
			SZQ->ZQ_EMISSAO := Date()
			SZQ->ZQ_HORA    := time()
			SZQ->ZQ_TIPOFRE := _cTiFre
			SZQ->ZQ_ESPECIE := _cEsp
			SZQ->ZQ_CONDPG  := _cCond
			SZQ->ZQ_MENS    := _cMens
			SZQ->ZQ_OBS     := _cObs
			SZQ->ZQ_TIPOCLI := Iif(Empty(_cTpCli),IIf(_ctipon$"Normal","F","R"),_cTpCli)
			SZQ->ZQ_MOEDA   := Iif(_nMoeda==0,1,_nMoeda)
			SZQ->ZQ_VIA     := _cVia
			SZQ->ZQ_TRANSP  :=	_cCodTra
			SZQ->ZQ_USER    := __cUserId
			SZQ->ZQ_RAMAL   := Val(_cRamal)
		//	SZQ->ZQ_AMOSTRA := _cAmost
		MsUnlock("SZQ")
				 
	 	cQuery2 := " DELETE " +  RetSqlName( 'SZR' )  
        cQuery2 += " WHERE ZR_FILIAL = '" + xFilial("SZR")+ "'"    
        cQuery2 += " AND D_E_L_E_T_ = ' ' "
        cQuery2 += " AND ZR_NUM = '" + _cDoc+ "' "                                                                                                           
   
        // MemoWrit('C:\TEMP\fat014.SQL',cQuery)
 		If TCSQLExec(cQuery2) < 0 //Executa a query
			cErro := TCSQLERROR()
			ALERT(cErro)
	 	Endif   

        For _x:=1 to Len(aCols)  
           
           	If !Empty(Acols[_x][1]) .And. !Acols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
             
        		_nPLiqui := 0
	      		// Begin Transaction  
			   	Reclock("SZR",.T.)   
			      	SZR->ZR_FILIAL  := xFilial("SZR")
			      	SZR->ZR_NUM     := _cDoc
					SZR->ZR_ITEM    := Acols[_x][1]  //item do produto
					SZR->ZR_PRODUTO := Acols[_x][2]  //produto
					SZR->ZR_DESCRI  := Acols[_x][3]  //descricao do produto
					SZR->ZR_LOCAL   := Acols[_x][4]  //almoxarifado do produto
					SZR->ZR_TES     := Acols[_x][5] //TES
					SZR->ZR_QTDE    := Acols[_x][6]  //quantidade
					SZR->ZR_LOCALIZ := Acols[_x][7]
					SZR->ZR_LOTECTL := Acols[_x][8]
					SZR->ZR_PRECO   := Acols[_x][9]  //preco
					SZR->ZR_TOTAL   := Acols[_x][10]  //preco total
					SZR->ZR_VOLUME  := Acols[_x][11] //volume

					SZR->ZR_CF      := Acols[_x][12] //CFO
					SZR->ZR_PESOL   := Acols[_x][13] // peso liquido
					SZR->ZR_PESOB   := Acols[_x][14] //Peso bruto
					SZR->ZR_NFORI   := Acols[_x][15] //nota fiscal original
					SZR->ZR_SERIORI := Acols[_x][16] //Seria da nota fiscal original
					SZR->ZR_ITEMORI := Acols[_x][17] //Item da nota fiscal original
					SZR->ZR_IDENTB6 := Acols[_x][18] //Item da nota fiscal original
					SZR->ZR_EMISSAO := Date()        //Valor por item da NF
				MsUnlock("SZR")
					
	       		If SB6->(DbSeek(xFilial("SB6")+Acols[_x][15]+Acols[_x][16]+Acols[_x][18]+Acols[_x][2],Found()))
  			      	Reclock("SB6",.F.)   
  			         	SB6->B6_QULIB+=Acols[_x][6] //Reserva/libera a qtde no poder de terceiro
  		          	MsUnlock("SB6")  			    
	      	 	Endif
	  		Endif   
	   
		    /* //retirado pela os 073259
     		//-- verifica se algum item da solicitacao é para amostra
     		If _cAmost=='S' //Acols[_x][8]$"528/529/527/530/532"
     			lAmostra := .T.
		     	If SZQ->(DbSeek(xFilial("SZQ")+_cDoc))
		     		Reclock("SZQ",.F.)
			     		SZQ->ZQ_STATUS := 'P'
			     	MsUnlock("SZQ")
		     	Endif
		  	Endif  
	        */
     	Next _x
		
		/* //retirado pela os 073259
	 	If lAmostra
	  		Processa({|| fMailAmostra() },'Gerando Solicitação de NF de Amostra')
	 	Endif   
   		*/
   		       
        ZF3->(DbSetOrder(1))
        For _x:=1 To Len(aDtFusao)
        	If !aDtFusao[_x][6]
        		If ZF3->(DbSeek(xFilial("ZF3")+aDtFusao[_x][1]+aDtFusao[_x][2]+aDtFusao[_x][3]))
        			Reclock("ZF3",.F.)
        				ZF3->ZF3_DATA 		:= aDtFusao[_x][4]
        				ZF3->ZF3_QUANTI 	:= aDtFusao[_x][5]
        			MsUnlock("ZF3")
        		Else
        			Reclock("ZF3",.T.)
        				ZF3->ZF3_FILIAL 	:= xFilial("ZF3")
        				ZF3->ZF3_NUMERO 	:= aDtFusao[_x][1]
        				ZF3->ZF3_ZRITEM 	:= aDtFusao[_x][2]
        				ZF3->ZF3_ITEM 		:= aDtFusao[_x][3]
        				ZF3->ZF3_DATA 		:= aDtFusao[_x][4]
        				ZF3->ZF3_QUANTI 	:= aDtFusao[_x][5]
        			MsUnlock("ZF3")
        		Endif
        	Else
        		If ZF3->(DbSeek(xFilial("ZF3")+aDtFusao[_x][1]+aDtFusao[_x][2]+aDtFusao[_x][3]))
        			Reclock("ZF3",.F.)
        				ZF3->(DbDelete())
        			MsUnlock("ZF3")
        		Endif
        	Endif
        Next
   	
        lDialog := .T.                           
        Close(oDialog)

   	ElseIf _lExc //permite excluir a solicitação  

       	//Deleta o cabecalho da solicitação de nota fiscal
       	TMP->(Dbgotop()) //Posiciona registro para excluir
       	SZQ->(Dbgoto(TMP->ZQ_RECNO)) //Posiciona registro para excluir
       	Reclock("SZQ",.F.)   
           	SZQ->(DbDelete())
       	MsUnlock("SZQ")                                                    

        While (!TMP->(EOF()))
        	//Deleta itens da solicitação de nota fiscal de saida
            SZR->(Dbgoto(TMP->ZR_RECNO)) //Posiciona registro para excluir
                                                                                                  
            If SB6->(DbSeek(xFilial("SB6")+TMP->ZR_NFORI+TMP->ZR_SERIORI+TMP->ZR_IDENTB6+TMP->ZR_PRODUTO,Found()))
				Reclock("SB6",.F.)   
	  		   		SB6->B6_QULIB -=TMP->ZR_QTDE //Diminui a qtde de Reserva/libera no poder de terceiro
	  			MsUnlock("SB6")  			    
			Endif

           	Reclock("SZR",.F.)   
              	SZR->(DbDelete())
           	MsUnlock("SZR")                                                    
  
           	TMP->(Dbskip())
    	Enddo
    	
    	ZF3->(DbSetOrder(1))
    	ZF3->(DbSeek(xFilial("ZF3")+_cDoc))
    	While (ZF3->ZF3_NUMERO == _cDoc)
    		Reclock("ZF3",.F.)
    			ZF3->(DbDelete())
    		MsUnlock("ZF3")
    		ZF3->(DbSkip())
    	Enddo
  
    /* //retirado pela os 073259
   	ElseIf _lApr

		lAprEng := (!EMPTY(SZQ->ZQ_APRVENG) .and. !EMPTY(SZQ->ZQ_DTAPENG))
		lAprQua := (!EMPTY(SZQ->ZQ_APRVQUA) .and. !EMPTY(SZQ->ZQ_DTAPQUA))
		
		oDlgAmos := MsDialog():New(0,0,140,320,"Aprovação de NF de Amostra",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		oGroup := tGroup():New(10,10,50,150,,oDlgAmos,,,.T.)
		
		oChkEng := tCheckBox():New(20,20,"Engenharia",{|u|if(pcount()>0,lAprEng:=u,lAprEng)};
		,oDlgAmos,40,8,,{||},,,,,,.T.,,,{|| EMPTY(SZQ->ZQ_APRVENG) .AND. EMPTY(SZQ->ZQ_DTAPENG)} )

		oSay1 := TSay():New(32,20,{||ALLTRIM(SZQ->ZQ_APRVENG)+' ('+DTOC(SZQ->ZQ_DTAPENG)+')' },oDlgAmos,,,,,,.T.,CLR_GREEN)

		oChkQua := tCheckBox():New(20,100,"Qualidade",{|u|if(pcount()>0,lAprQua:=u,lAprQua)};
		,oDlgAmos,40,8,,{||},,,,,,.T.,,,{|| EMPTY(SZQ->ZQ_APRVQUA) .AND. EMPTY(SZQ->ZQ_DTAPQUA)} )

		oSay2 := TSay():New(32,100,{||ALLTRIM(SZQ->ZQ_APRVQUA)+' ('+DTOC(SZQ->ZQ_DTAPQUA)+')' },oDlgAmos,,,,,,.T.,CLR_GREEN)
		
    	oBtn1 := tButton():New(55,065,"Ok"      ,oDlgAmos,{|| oDlgAmos:End()},40,10,,,,.T.)
   		oBtn2 := tButton():New(55,110,"Cancelar",oDlgAmos,{||_lApr:=.f.,oDlgAmos:End() },40,10,,,,.T.)

		oDlgAmos:Activate(,,,.T.,{||.T.},,{||})

        If !_lApr
        	Close(oDialog)
        	Return
        Endif
      	
		//-- validacao
		//-- verifica se o usuário é aprovador de nf de amostra da area

		ZEP->(dbsetorder(1)) // ZEP_FILIAL+ZEP_LOGIN+ZEP_AREA
		If lAprEng .AND. EMPTY(SZQ->ZQ_APRVENG) .AND. EMPTY(SZQ->ZQ_DTAPENG)//!(SZQ->ZQ_STATUS=='E' .or. SZQ->ZQ_STATUS=='')
			If !ZEP->(dbSeek(xFilial('ZEP')+PADR(UPPER(cUserName),25)+'E'))
				Alert('Responsável não autorizado para aprovar pela Engenharia!')
				_lApr := .f.
			Endif
		Endif
		      
		If lAprQua .AND. EMPTY(SZQ->ZQ_APRVQUA) .AND. EMPTY(SZQ->ZQ_DTAPQUA)// !(SZQ->ZQ_STATUS=='Q' .or. SZQ->ZQ_STATUS=='')
			If !ZEP->(dbSeek(xFilial('ZEP')+PADR(UPPER(cUserName),25)+'Q'))
				Alert('Responsável não autorizado para aprovar pela Qualidade!')
				_lApr := .f.
			Endif
		Endif

        If !_lApr  
	        Close(oDialog)
        	Return
        Endif
      	
        //aprova solicitação de nota fiscal
    	TMP->(Dbgotop()) //Posiciona registro para aprovar
        SZQ->(Dbgoto(TMP->ZQ_RECNO)) //Posiciona registro para aprovar
    	    
   	    Reclock("SZQ",.F.)   
    	    
    	    If lAprEng //-- aprova somente engenharia
        	   	SZQ->ZQ_APRVENG := ALLTRIM(UPPER(cUserName))
        	   	SZQ->ZQ_DTAPENG := DATE()
        	EndIf
        	
        	If lAprQua //-- aprova somente qualidade
        	   	SZQ->ZQ_APRVQUA := ALLTRIM(UPPER(cUserName))
        	   	SZQ->ZQ_DTAPQUA := DATE()
			EndIf
				       
	        If lAprEng .and. lAprQua //-- aprova qualidade e engenharia
	        	SZQ->ZQ_STATUS := ''
	        Endif

        MsUnlock("SZQ")
		*/
      
	Endif //Fim

   	lDialog := .T.                           
   	Close(oDialog)
   	
	// Se exister ao menos 1 produto PA, pergunta se deseja solicitar a nota de embalagem        
	/*
	If lProdPa .and. _cPar == 3      
	
		aCols := {}
	    
		For _y:=1 To Len(aEmbalagem) 
		
			SB1->(DbSeek(xFilial("SB1")+aEmbalagem[_y][1]))
		
			aAdd(aCols,{StrZero(_y,2),;						//1         STR
					aEmbalagem[_y][1],;     						//2         STR
					SB1->B1_DESC,;     						//3         STR
					SB1->B1_LOCPAD,;					    //4         LOCAL   
					"","",;                                 //5,6
					aEmbalagem[_y][2],;   					//7         FLOAT
					SB1->B1_UPRC,;      		                //8         FLOAT
					SB1->B1_UPRC*aEmbalagem[_y][2],;   				//TOTAL				//9         FLOAT
				  	aEmbalagem[_y][3],;   //VOLUME          	//10        FLOAT
				  	SB1->B1_TS,;		//TES				//11        STR
				  	cCfo,;				//CFO         	    //12        STR
				  	ZDA->ZDA_QUANT*SB1->B1_PESO,;					//PESO LIQ			//11        FLOAT
				  	ZDA->ZDA_QUANT*SB1->B1_PESBRU,;     //PESO BRUTO        //12        FLOAT
				  	"","","","",.F.})                 //13,14,15,16,17,18    STR
		         
		Next
		  
	        If MsgYesNo("Deseja solicitar NF de embalagem para este produto ?")
	               
		       // Chama nova inclusão
		       U_fSol(7)   
		       
	        EndIf 
	        
	EndIF  	                           
	*/
Return    

// Busca as embalagens do produto para fazer a nota de embalagens

Static Function fBuscaEmb(cProdPai)
Local aEmbalag := {}  
Local cQuery

cQuery := "SELECT ZBV_PROD,ZBV_EMBAL,ZBV_QUANT,ZBV_CONJUN "
cQuery += "FROM " +  RetSqlName( 'ZBV' ) +" ZBV "
cQuery += "WHERE ZBV.ZBV_FILIAL = '" + xFilial("ZBV")+ "' "       
cQuery += "AND ZBV.D_E_L_E_T_ = ' ' "
cQuery += "AND ZBV.ZBV_PROD = '"+Alltrim(cProdPai)+"' "
   
MemoWrit('C:\TEMP\fat014embalag.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "EMBALAG"      

EMBALAG->(DBGOTOP())                    

While EMBALAG->(!EoF())

	aAdd(aEmbalag,{	  EMBALAG->ZBV_EMBAL,;   // EMBALAGEM
		              EMBALAG->ZBV_QUANT,;   // QUANTIDADE
		              EMBALAG->ZBV_CONJUN }) // CONJUNTO
		              
	EMBALAG->(Dbskip())		              
	              
EndDo 

EMBALAG->(DbCloseArea())  

Return aEmbalag


Static Function fMulti(lLinha)
Local lret := .T.
Local nPosLote	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOTECTL"}) 
Local nPosLclz	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCALIZ"}) 
Local nPosTes   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TES"})

SB6->(DbSetOrder(6))//filial + doc + serie + ident + produto + clifor + loja
SZR->(DbSetOrder(1))//filial + doc + item 
SB1->(DbSetOrder(1))//filial + cod
SF4->(DbSetOrder(1))//F4_FILIAL+F4_CODIGO

For x:= 1 to Len(aCols)

	If lLinha .and. n<>x
		Loop
	Endif

	If !aCols[x][Len(aheader)+1]

		If Empty(aCols[x][2])
			Alert('Informe o produto!')
			Return .F.
		Endif
		
		If Empty(aCols[x][nPosTes])
			alert('Informe a TES!')
			return .F.
		Endif
		
		// os: 063262
		
		If aCols[x][nPosTes]$"648/650/651/652/653/657" .and. _cCli<>"900109"
			Alert("Utilizar as TES de transferencia somente entre matriz x filial!!!!")
			Return .f.
		Endif         
		
		// fim os 063262
		
		
		//-- verifica controle de lote e localizacao
		If SB1->(dbSeek(xFilial("SB1")+aCols[x][2]))

			//-- Verifica se foi digitada a quantidade e data de fusão
			
			/*If SB1->B1_GRUPO$"PA01" .And. aCols[x][nPosTes]$"572/576/602"
				If aScan(aDtFusao,{|y| AllTrim(y[2]) == aCols[x][1]})==0
					Alert("Campo Fusão é obrigatório!")
					Return .F.
				Endif
			Endif*/
                  
			If SF4->(dbseek(xFilial("SF4")+aCols[x][nPosTes]))
				If ALLTRIM(SF4->F4_ESTOQUE)$'S'

					//-- verifica controle de lote e localizacao
					If SB1->B1_RASTRO=='L'
						If Empty(aCols[x][nPosLote])
							Alert('Campo Lote deve ser informado para produtos que controlam Lote!')
							RETURN .F.
						EndIf
					EndIf          
					
					If SB1->B1_LOCALIZ=='S' .AND. Empty(aCols[x][nPosLclz])
						Alert('Campo Localizacao deve ser informado para produtos que controlam Localizacao!')
						RETURN .F.
					EndIf
				Endif
			Else 
				Alert('TES não encontrada!')
				Return .f.
			Endif
		Else 
			alert('Produto não encontrado!')
			lret := .F.
		Endif
		
		If Empty(aCols[x][6])
			alert('Informe a quantidade!')
			return .F.
		Endif
		
		If Empty(aCols[x][9])
			alert('Informe o preço!')
			return .F.
		Endif

		If Empty(aCols[x][10])
			alert('Informe o total!')
			return .F.
		Endif


		If Empty(_cFab) 
		   	Alert('Informe a Fábrica!')
			Return .f.
		Endif
		
	    If !Empty(Acols[x][15]) // se tiver nota de retorno
	
	        If SB6->(DbSeek(xFilial("SB6")+Acols[x][15]+Acols[x][16]+Acols[x][18]+Acols[x][2],found()))             
	           If _cPar == 3 //incluir           
	              If Acols[x][6] > (SB6->B6_QUANT - SB6->B6_QULIB) // Valida eirifica se existe
	             	 lret := .F.
	                 Msgbox("Produto "+Acols[x][2]+" Tem Qtde "+ Transform((SB6->B6_QUANT - SB6->B6_QULIB),"@E 9,999,999.99")+"  Disponivel no SB6, Verifique !!!" ,"Atencao","ALERT" )                
				  Endif            		   
	           ElseIf _cPar == 5 //alteração
	                  If SZR->(DbSeek(xFilial("SZR")+_cDoc + Acols[x][1],found()))//filial + documento + item
	                     If Acols[x][6] > (SB6->B6_QUANT - SB6->B6_QULIB)+SZR->ZR_QTDE // Valida eirifica se existe
	             	        lret := .F.
	                        Msgbox("Produto  "+Acols[x][2]+" Tem Qtde "+ Transform((SB6->B6_QUANT - SB6->B6_QULIB)+SZR->ZR_QTDE,"@E 9,999,999.99")+"  Disponivel no SB6, Verifique !!!" ,"Atencao","ALERT" )                
				         Endif            		                                                                            
	                  Else
	             	      lret := .F.
	                      Msgbox("Produto  "+Acols[x][2]+" Não foi Encontrado na Tabela SZR, Favor avisar a Informatica, Verifique !!!" ,"Atencao","ALERT" )                
	                  Endif
	           Endif
		  	Endif   
		
		Endif
		 
		/* //retirado pela os 073259
		
		//-- verifica se é amostra
		If Acols[x][5]$"528/529/527/530/532" .and. _cAmost!='S'
			Alert('Para utilização da TES '+aCols[x][5]+' o campo Amostra deve ser Sim')
			Return .f.
		Endif
		
		*/
		
	endif	    
	
	//-- chamado 025633 do portal
	//-- removido a pedido do lupercio 05/09/2013
	/*
	If _ctipon$"Normal" .and. alltrim(upper(aCols[x][2]))$"PSA01.1.0317.00" .and. alltrim(_cCli)!='900023'
		Alert('Para produto '+alltrim(aCols[x][2])+' deve ser utilizado Cliente 900023 - 01!')
		Return .f.
	Endif
    */
    
    /*
	If !_ctipon$"Normal" .and. alltrim(upper(aCols[x][2]))$"GMB01.1.0201.00/VWB01.1.0210.00" .and. alltrim(_cCli)!='002899'
		Alert('Para produto '+alltrim(aCols[x][2])+' deve ser utilizado Fornecedor 002899 - 01!')
		Return .f.
	Endif
	*/
	//-- fim chamado 025633 

	
Next x
oMultiline:Refresh()  

Return(lRet)

User Function FLegSol()       
Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"   },;
  					  {"BR_VERMELHO" , "Fechada"  },;
  					  /*{"BR_PRETO"    , "Pendente de Aprovação Amostra"},*/;
  					  {"BR_AZUL"     , "Pendente de Aprovação Pernambuco"},;
   					  {"BR_CANCEL"   , "Rejeitado pela logística"}}

BrwLegenda(OemToAnsi("Solicitação de Nota Fiscal"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       
Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"   },;
  					  {"BR_VERMELHO" , "Fechada"  },;
  					  {"BR_PRETO"    , "Pendente de Aprovação"},;
  					  {"BR_AZUL" 	 , "Pendente de Aprovação Pernambuco"  },;
   					  {"BR_CANCEL"   , "Rejeitado pela logística"}}
  					  
Local uRetorno := {}
Aadd(uRetorno, { 'ZQ_STATUS == " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "S"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "P"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "A"' , aLegenda[4][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "R"' , aLegenda[5][1] } )

Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A QUANTIDADE NA TELA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fQtde()
Local _lRet  := .T.
Local _nQtde := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"}) 
Local _nPli  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PESOL"}) 
Local _nPBr  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PESOB"}) 
Local _nProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRODUTO"})
Local _nTot  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TOTAL"})
Local _nPrc  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_PRECO"})
Local _nTes  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TES"})
Local _nCF   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_CF"})
Local _nLocal := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCAL"})

Local cLocal := aCols[n][_nLocal]
Local lLocaliz := lLote := .F.
Local aLote := {}

	aArea := getArea() // GUARDA A AREA SELECIONADA

	If empty(acols[n][_nTes])
		Alert("Informe a TES")
		Return .f.
	Endif
	
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+Acols[n][_nProd]))
	
		//os 005552 - helpdesk
		IF SB1->B1_TIPO=="PA" .AND. SB1->B1_GRUPO$"PA01/PA02"
			
			If SM0->M0_CODIGO=="FN" .and. SM0->M0_CODFIL=='01'
				/*If SB1->B1_GRUPO=="PA01"
		        	aCols[n][_nLocal] := "27"
				ElseIf SB1->B1_GRUPO=="PA02"
					aCols[n][_nLocal] := "37"
				EndIf
                */
			Endif

			cLocal := aCols[n][_nLocal]
				
			SB2->(dbSetOrder(1)) //B2_FILIAL + B2_COD + B2_LOCAL
			If SB2->(dbSeek(xFilial("SB2")+aCols[n][_nProd]+cLocal))

				If M->ZR_QTDE > SB2->B2_QATU - SB2->B2_QEMP - SB2->B2_QEMPSA	
					MsgInfo("Saldo Insuficiente no armazém "+cLocal+"!"+CHR(10)+CHR(13)+;
							"Saldo atual: "+AllTrim(Str(SB2->B2_QATU - SB2->B2_QEMP - SB2->B2_QEMPSA))+CHR(10)+CHR(13)+;
							"Qtd. Empenhada: "+AllTrim(Str(SB2->B2_QEMP))+CHR(10)+CHR(13)+;
							"Qtd. Empenhada (SA): "+AllTrim(Str(SB2->B2_QEMPSA))+CHR(10)+CHR(13))

				EndIf
			
			EndIf
			
		EndIf

		Acols[n][_nPli] := M->ZR_QTDE * SB1->B1_PESO	  
		Acols[n][_nPBr] := M->ZR_QTDE * SB1->B1_PESBRU
		Acols[n][_nTot] := M->ZR_QTDE * Acols[n][_nPrc]
		
		SF4->(DbSetOrder(1)) //F4_FILIAL+F4_CODIGO	  
		If SF4->(dbseek(xFilial("SF4")+aCols[n][_nTes]))
			If ALLTRIM(SF4->F4_ESTOQUE)$'S'
		
				// E N D E R E C O
				
				if alltrim(SB1->B1_LOCALIZ)$'S' 
					//If !U_fSldLclz()
					//	return .f.
					//Else
						lLocaliz := .T.
					
					   	SBF->(DbSetOrder(2)) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
					    If SBF->(DbSeek(xFilial("SBF")+aCols[n][_nProd]+cLocal))
					    	While SBF->(!Eof()) .And. SBF->BF_PRODUTO==aCols[n][_nProd] .AND. SBF->BF_LOCAL==cLocal
			
								If SBF->BF_QUANT > 0
									_n := aScan(aLote,{|x| x[1]==SBF->BF_PRODUTO .and. x[5]==SBF->BF_LOCALIZ .AND. x[3]==SBF->BF_LOTECTL })
					
									If _n==0
										aAdd(aLote,{SBF->BF_PRODUTO,CTOD('  /  /  '),SBF->BF_LOTECTL,SBF->BF_QUANT,SBF->BF_LOCALIZ})
									Else
									    aLote[_n][4] += SBF->BF_QUANT
									EndIf
								EndIf
				
								SBF->(Dbskip())
							Enddo	    	
						Else
							Alert('Produto não tem saldo por endereço! Verifique se existem saldos a Distribuir/Endereçar!')
							Return .F.
						Endif
								
					//Endif
				endif 	
				  
				//-- L O T E 
				
				if alltrim(SB1->B1_RASTRO)$'L'
				
					//If !U_fSldLote()
					// 	return .f.
					//Else

						lLote := .T.
						
						If !empty(aCols[n][8]) // lote
							Alert("Não é possível alterar a quantidade, lote já informado! Informe primeiro a quantidade depois o lote!")
							Return .f.
						Endif
						
						SB8->(DbSetOrder(1)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE
						If SB8->(DbSeek(xFilial("SB8")+aCols[n][_nProd]+cLocal))
				
							While SB8->(!EOF()) .AND. SB8->B8_PRODUTO==aCols[n][_nProd] .AND. SB8->B8_LOCAL==cLocal
								If SB8->B8_SALDO > 0
								
									If lLocaliz
										
										cAl := getNextAlias()
										
										//-- verifica se nao existem quantidades a endereçar
										beginSQl Alias cAl
											SELECT COALESCE(SUM(DA_SALDO),0) AS QUANT 
											FROM %Table:SDA%
											WHERE %NotDel%
											AND DA_FILIAL = %xFilial:SDA%
											AND DA_PRODUTO = %Exp:SB8->B8_PRODUTO%
											AND DA_LOCAL = %Exp:SB8->B8_LOCAL%
											AND DA_SALDO > 0
										endSql
										
										If (cAl)->(!eof()) .AND. (cAl)->QUANT > 0
											Alert('Existe um saldo de '+alltrim(str((cAl)->QUANT))+' a endereçar! Favor executar endereçamento do produto:'+SB8->B8_PRODUTO+'!')
											(cAl)->(dbclosearea())								    								
											Return .F.								
										Endif							
										(cAl)->(dbclosearea())								    								
										
										//-- se nao tem nada a endereçar
										nSaldoB8 := SB8->B8_SALDO
				
										While nSaldoB8 > 0
						
											//!!!!!!!!! Tratativa para iniciar o ascan a partir da posicao que parou se o lote existir em 2 ou mais endereços da tabela SBF
											_n := aScan(aLote,{|x| x[1]==SB8->B8_PRODUTO .and. x[3]==SB8->B8_LOTECTL},Iif(_n<>0 .and. ALOTE[_N][3]==SB8->B8_LOTECTL,_n+1,1))
											                       
											If _n==0
												
												Alert('D I V E R G Ê N C I A !'+CHR(13)+CHR(10)+;
												      'Produto possui saldo por lote (SB8) que não corresponde ao saldos por endereço (SBF).'+CHR(13)+CHR(10)+;
													  'Produto: ' + SB8->B8_PRODUTO + CHR(13)+CHR(10)+;
													  'Local: ' + SB8->B8_LOCAL + CHR(13)+CHR(10)+;
													  'Lote: ' + SB8->B8_LOTECTL)
												Return .F.								
											Else
												If nSaldoB8 < aLote[_n][4]
				
													Alert('D I V E R G Ê N C I A !'+CHR(13)+CHR(10)+;
												          'Produto possui saldo no lote '+ALLTRIM(SB8->B8_LOTECTL)+' (SB8) menor que as quantidades encontradas nos saldos por endereço (SBF)!'+CHR(13)+CHR(10)+;
													  	  'Produto: ' + SB8->B8_PRODUTO + CHR(13)+CHR(10)+;
													  	  'Local: ' + SB8->B8_LOCAL)
													Return .F.
												Else
											    	nSaldoB8 -= aLote[_n][4]
										    	    aLote[_n][2] := SB8->B8_DATA
												EndIf
											EndIf
											
										Enddo
									Else
										_n := aScan(aLote,{|x| x[1]==SB8->B8_PRODUTO .and. x[3]==SB8->B8_LOTECTL })
											                       
										If _n==0
											aAdd(aLote,{SB8->B8_PRODUTO,SB8->B8_DATA,SB8->B8_LOTECTL,SB8->B8_SALDO,""})
										Else
											aLote[_n][4] += SB8->B8_SALDO
										Endif
									
									Endif
								Endif
								SB8->(DBskip())
							EndDo
						Else
							Alert("Produto não possui saldo em nenhum lote!")
							Return .F.
						EndIf

						//-- os: 048334, 048320
					
						//-- verifica nas transferencias abertas quais lotes / endereco já estão utilizandos para não duplicar
						
						cAl := getnextalias()
						
						beginSql Alias cAl
							SELECT ZR_PRODUTO, ZR_QTDE, ZR_LOTECTL, ZR_LOCALIZ
							FROM %Table:SZQ% SZQ (NOLOCK) 
							INNER JOIN %Table:SZR% SZR (NOLOCK) ON
								ZQ_FILIAL = ZR_FILIAL
							AND	ZQ_NUM=ZR_NUM
							AND SZR.%NotDel%
							AND ZR_PRODUTO = %Exp:aCols[n][_nProd]%
							AND ZR_LOCAL = %Exp:cLocal%
							WHERE ZQ_STATUS <> 'S'
							AND SZQ.ZQ_FILIAL = %xFilial:SZQ%
							AND SZQ.%NotDel%
						endSql
						
						While (cAl)->(!eof())
							_n := aScan(aLote,{|x| x[3]==(cAl)->ZR_LOTECTL .AND. x[5]==(cAl)->ZR_LOCALIZ })
								                       
							If _n!=0
								If (cAl)->ZR_QTDE >= aLote[_n][4]
									aLote[_n][5] := 'INVALIDO'
								Else
									aLote[_n][4] -= (cAl)->ZR_QTDE
								Endif
							Endif
						
							(cAl)->(dbskip())
						Enddo
						
						(cAl)->(dbclosearea())
					
						RestArea(aArea) //-- RETORNA A AREA SELECIONADA
						
						//-- FIM CHAMADO 035028
							
						nSldAdd := 0 //saldo adicionado ao acols
						xL      := 1
						lPrim   := .T.
						nQtdDig := M->ZR_QTDE
					
						aSort(aLote,,,{|x,y| dtos(x[2])+x[3] < dtos(y[2])+y[3]}) //ordena por data + lote decrescente
						
						If lLote .or. lLocaliz
						
							WHILE nQtdDig > nSldAdd .AND. xL <= Len(aLote)
									
								If aLote[xL][5]!="INVALIDO"
									If lPrim //se for a primeira  vez nao inclui linha, apenas atualiza a quantidade, lote e localizacao
										aCols[n][8]  := aLote[xL][3] //lote
										aCols[n][7]  := aLote[xL][5] //localizacao
										aCols[n][_nTot]  := aLote[xL][4] * Iif(_ctipon$"N",SB1->B1_PRV1,SB1->B1_UPRC)  // total
										aCols[n][_nPli] := aLote[xL][4]*SB1->B1_PESO	      //PESO LIQ		  //13        FLOAT
										aCols[n][_nPbr] := aLote[xL][4]*SB1->B1_PESBRU     //PESO BRUTO        //14        FLOAT
										
							
										If nQtdDig >= aLote[xL][4] //quantidade digitada maior ou igual ao saldo do lote
											aCols[n][6] := M->ZR_QTDE := aLote[xL][4] //muda a quantidade digitada para o saldo do primeiro lote mais antigo
											nSldAdd += aLote[xL][4] //incrementa a quantidade que ja foi incluida no acols
										Else
										    nSldAdd += nQtdDig
										EndIf
										
										lPrim := .F.
									Else
										If nQtdDig >= (aLote[xL][4]+nSldAdd) //se a quantidade digitada for maior ou igual ao qtd do lote + o q ja foi adicionado no acols
										
											aAdd(aCols,{STRZERO(Len(aCols)+1,4),; 						//1         STR
														aCols[n][_nProd],;     						//2         STR
														SB1->B1_DESC,;     						//3         STR
														cLocal,;					    //4         LOCAL   
													  	aCols[n][_nTes],;		//TES				//11        STR
														aLote[xL][4],;   						//5 quant         FLOAT
														aLote[xL][5],;  //6- localiz
														aLote[xL][3],;                                 //7 - lote
														Iif(_ctipon$"N",SB1->B1_PRV1,SB1->B1_UPRC),;      		                //8         FLOAT
														Iif(_ctipon$"N",SB1->B1_PRV1,SB1->B1_UPRC)*aLote[xL][4],;  			//TOTAL				//9         FLOAT
													  	1,;   //VOLUME          	//10        FLOAT
													  	aCols[n][_nCF],;				//CFO         	    //12        STR
													    aLote[xL][4]*SB1->B1_PESO,;					//PESO LIQ			//13        FLOAT
													  	aLote[xL][4]*SB1->B1_PESBRU,;     //PESO BRUTO        //14        FLOAT
													  	"","","","",.F.})                 //15,16,17,18    STR
																			
											nSldAdd += aLote[xL][4] //incrementa a quantidade que ja foi adicionada no acols
										Else //senao
											aAdd(aCols,{STRZERO(Len(aCols)+1,4),; 						//1         STR
														aCols[n][_nProd],;     						//2         STR
														SB1->B1_DESC,;     						//3         STR
														cLocal,;					    //4         LOCAL   
														aCols[n][_nTes],;		//TES				//11        STR														
														(nQtdDig-nSldAdd),;   			// 5 qtd        FLOAT
														aLote[xL][5],;					// 6 localiz
														aLote[xL][3],;                  // 7 lote
														Iif(_ctipon$"N",SB1->B1_PRV1,SB1->B1_UPRC),;      		                //8         FLOAT
														Iif(_ctipon$"N",SB1->B1_PRV1,SB1->B1_UPRC)*(nQtdDig-nSldAdd),;  			//TOTAL				//9         FLOAT
													  	1,;   //VOLUME          	//10        FLOAT
													  	aCols[n][_nCF],;				//CFO         	    //12        STR
													    (nQtdDig-nSldAdd)*SB1->B1_PESO,;					//PESO LIQ			//13        FLOAT
													  	(nQtdDig-nSldAdd)*SB1->B1_PESBRU,;     //PESO BRUTO        //14        FLOAT
													  	"","","","",.F.})                 //15,16,17,18    STR
										
											nSldAdd += (nQtdDig-nSldAdd)  //incrementa a quantidade que falta para atingir a quantidade digitada no que ja foi adicionado no acols
										EndIf
									EndIf
								EndIf
										
							    xL++
							ENDDO 
						
							If nQtdDig > nSldAdd
								Alert("Não existe saldo suficiente por lote!")
								Alert("Realizar Transferencia (Mod. 2)!")
								Return .F.
							EndIf
						EndIf
					
						//-- fim os: 048334, 048320
					
					//Endif
				endif
			Endif
		Endif
		
		
		oMultiline:Refresh()
	Else
		alert('produto nao encontrado!')
		return .f.
	ENDIF
	
Return(_lRet)

User Function fRoma()
Local cQuery

IF SM0->M0_CODIGO <> 'FN'
   Msgbox(" Disponivel Somente Para a Fundicao !!!" ,"Atencao","ALERT" )     
   Return
Endif

cQuery := "SELECT SZQ.R_E_C_N_O_ AS 'ZQ_RECNO',SZR.R_E_C_N_O_ AS 'ZR_RECNO',*,"
cQuery += "'NOTA' = "
cQuery += "CASE WHEN SZR.ZR_PEDIDO <> ' ' THEN " //se existir pedido busca a NF gerada
cQuery += " (SELECT TOP 1 D2_DOC+'-'+D2_SERIE "
cQuery += "  FROM "+RetSqlName("SD2")
cQuery += "  WHERE D_E_L_E_T_ = ' ' AND SZR.ZR_PEDIDO = D2_PEDIDO "
cQuery += "  AND D2_COD = SZR.ZR_PRODUTO) "
cQuery += "  END "
cQuery += "FROM " +  RetSqlName( 'SZQ' ) +" SZQ, " +  RetSqlName( 'SZR' ) +" SZR "
cQuery += "WHERE SZQ.ZQ_FILIAL = '" + xFilial("SZQ")+ "'"    
cQuery += "AND SZR.ZR_FILIAL = '" + xFilial("SZR")+ "'"    
cQuery += "AND SZR.D_E_L_E_T_ = ' ' "
cQuery += "AND SZQ.D_E_L_E_T_ = ' ' "
cQuery += "AND SZQ.ZQ_NUM = SZR.ZR_NUM "
cQuery += "AND SZQ.ZQ_EMISSAO = SZR.ZR_EMISSAO "
//If _lExc //SE for exclusão da solicitação não pode estar gerada pedido
//   cQuery += "AND SZR.ZR_PEDIDO = ' ' AND SZQ.ZQ_STATUS = ' ' "
//Endif
cQuery += "AND SZQ.ZQ_NUM BETWEEN '" + SZQ->ZQ_NUM + "' AND '" + SZQ->ZQ_NUM + "' "                                                                                                           
cQuery += "order by SZR.ZR_NUM,SZR.ZR_ITEM"

   
// MemoWrit('C:\TEMP\fat014.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TRB"      
TcSetField("TRB","ZQ_EMISSAO","D")  // Muda a data de string para date    

//DbSelectArea("TMP")
TRB->(DBGOTOP())
If Empty(TRB->ZQ_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   TRB->(DbCloseArea())
   return
Endif    
//*************************************************************/
cString   := "SZQ"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o ")
cDesc2    := OemToAnsi("Picking-List da Solicitação de NF de saida")           	
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFAT014"
nLastKey  := 0
titulo    := "PICKING-LIST DE PRODUTOS"
Cabec1    := ""
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHFAT014"
_cPerg    := "FAT014" 
//aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '
/*************************************************************/
//AjustaSx1()                                                               
                     
/*
If !Pergunte(_cPerg,.T.)
    Return(nil)
Endif   
*/
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]


Processa( {|| RptDetail() },"Imprimindo...")

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()
Local _lVerif := .F.
Local _nVol   := 0 //inicializa o total de volumes
Local _nQuant := 0
Local _lFlag  := .T.

TRB->(Dbgotop())

_cDoc     := TRB->ZQ_NUM     
_cCli     := TRB->ZQ_CLIENTE 
_cLoja    := TRB->ZQ_LOJA  
_cTipon	  := IIf(TRB->ZQ_TIPO$"N","Normal",IIf(TRB->ZQ_TIPO$"D","Dev.Compra","Util.Fornecedor"))  //Cliente         

If(_ctipon$"Normal")  
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
      _cDesCli := SA1->A1_NOME
   Endif
Else                    
   SA2->(DbSetOrder(1))
   If SA2->(DbSeek(xFilial("SA2")+_cCli+_cLoja))
      _cDesCli := SA2->A2_NOME
   Endif
 
Endif

//_cRamal   := StrZero(TMP->ZQ_RAMAL,4)

SE4->(DbSetOrder(1))
SE4->(DbSeek(xFilial("SE4")+TRB->ZQ_CONDPG))

SA4->(DbSetOrder(1))
SA4->(DbSeek(xFilial("SA4")+TRB->ZQ_TRANSP))

Cabec(Titulo,Cabec1,"",NomeProg, Tamanho,nTipo)

@ Prow() + 1, 000 Psay OemToAnsi("Num.Solicitacao : ")+TRB->ZQ_NUM 
@ Prow()    , 030 Psay OemToAnsi("Tipo Nota : ")+  IIf(TRB->ZQ_TIPO$"N","Normal",IIf(TRB->ZQ_TIPO$"D","Dev.Compra","Util.Fornecedor"))  //Cliente         
@ Prow()    , 070 Psay OemToAnsi("Data : ")+Dtoc(TRB->ZQ_EMISSAO)
@ Prow()    , 110 Psay OemToAnsi("Hora : ")+TRB->ZQ_HORA

@ Prow() + 1, 000 Psay OemToAnsi("Cliente : ")+TRB->ZQ_CLIENTE+"-"+TRB->ZQ_LOJA+"-"+Iif( Empty(_cDesCli),TRB->CLIENTE,_cDesCli ) 
@ Prow()    , 060 Psay OemToAnsi("Transportadora : ")+TRB->ZQ_TRANSP+"-"+SA4->A4_NOME

//+TMP->ZM_TRANSP+"-"+TMP->A4_NOME+Space(10)+"Data Entrada:"+DtoC(TMP->ZM_DATAENT)+"    Hora Entrada:"+TMP->ZM_HORAENT

@ Prow() + 1, 000 Psay OemToAnsi("Tipo de Frete : ")+Iif(TRB->ZQ_TIPOFRE=="C","CIF","FOB")
@ Prow()    , 025 Psay OemToAnsi("Via : ")+TRB->ZQ_VIA
@ Prow()    , 050 Psay OemToAnsi("Cond Pagto : ")+TRB->ZQ_CONDPG+"-"+SE4->E4_DESCRI
@ Prow()    , 110 Psay OemToAnsi("Especie : ")+TRB->ZQ_ESPECIE
@ Prow() + 1, 000 Psay OemToAnsi("Mensagem : ")+TRB->ZQ_MENS


//_cExpNom := UsrFullName(TMP->ZM_EXPEDI) 

@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
@ Prow() + 1, 000 Psay OemToAnsi(" ITEM    PRODUTO                                             QUANTIDADE        VOLUME       LOCALIZACAO       LOTE")
          
//_Linha = 13

_cUser := "Solicitante da Nota:  " + UsrFullname(TRB->ZQ_USER ) + "    Ramal : "+StrZero(TRB->ZQ_RAMAL,4)
ZAV->(DbSetOrder(1)) //filial + produto + data + localizacao 
While !TRB->(EOF())
   if Prow() > 60
       Cabec(Titulo,Cabec1,"",NomeProg, Tamanho,nTipo)
       @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
       @ Prow() + 1, 000 Psay OemToAnsi(" ITEM    PRODUTO                                             QUANTIDADE        VOLUME       LOCALIZACAO       LOTE")       
       @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
   endif

   @ Prow() + 1, 001 Psay TRB->ZR_ITEM
   @ Prow()    , 010 Psay Alltrim(TRB->ZR_PRODUTO)+" - "+ TRB->ZR_DESCRI

   If ZAV->(Dbseek(xFilial("ZAV")+TRB->ZR_PRODUTO))
	   While ZAV->(!Eof()) .And. ZAV->ZAV_COD == TRB->ZR_PRODUTO
	      
	      If TRB->ZQ_CLIENTE+TRB->ZQ_LOJA == ZAV->ZAV_CLIENT+ZAV->ZAV_LOJA .And. ZAV->ZAV_QUANT <> 0  
	         If _lFlag
		         If ZAV->ZAV_QUANT >= TRB->ZR_QTDE                        
		            @ Prow()    , 060 Psay Transform(TRB->ZR_QTDE,"@E 9999999.99")
		            @ Prow()    , 092 Psay ZAV->ZAV_LOCALI 
	    	        Exit // força a saida do while
		         Else   
		            @ Prow()    , 060 Psay Transform(ZAV->ZAV_QUANT,"@E 9999999.99")
		            @ Prow()    , 092 Psay ZAV->ZAV_LOCALI 
		            _nQuant   := TRB->ZR_QTDE - ZAV->ZAV_QUANT
		            _lFlag    :=.F.
		         Endif        
		     Else
	            If ZAV->ZAV_QUANT >= _nQuant 
	               @ Prow() + 1, 001 Psay TRB->ZR_ITEM
				   @ Prow()    , 010 Psay Alltrim(TRB->ZR_PRODUTO)+" - "+ TRB->ZR_DESCRI
				   @ Prow()    , 060 Psay Transform(_nQuant,"@E 9999999.99")
		           @ Prow()    , 092 Psay ZAV->ZAV_LOCALI 			   
				   _lFlag := .T.           
		           Exit // força a saida do while
	            Endif
	         Endif
	      Endif
	      ZAV->(DbSkip())
	   Enddo	
   Else
      @ Prow()    , 060 Psay Transform(TRB->ZR_QTDE,"@E 9999999.99")
      @ Prow()    , 078 Psay Transform(TRB->ZR_VOLUME,"@E 9999")
      @ Prow()    , 092 Psay Iif(Empty(TRB->ZR_LOCALIZ)," SEM LOCALIZACAO",TRB->ZR_LOCALIZ)
      @ Prow()    , 110 Psay Iif(Empty(TRB->ZR_LOTECTL)," SEM LOTE",TRB->ZR_LOTECTL)
         
   Endif 	
   TRB->(DbSkip())
EndDo
TRB->(DbSkip(-1))
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha 
@ Prow() + 1, 001 Psay _cUser

Return(nil)


//============FUNÇÃO PARA CARREGAR OS ITENS DE CARREGAMENTO============\\

Static Function fCarrega()
Local cQuery
Local cAl
Local aPlanta   := {"","1=Usinagem","2=Fundição","3=Usinagem","4=Forjaria","5=Virabrequim"}

If SM0->M0_CODFIL=='02'
	aPlanta := {"P=Pernambuco"}
Endif

	If Empty(_cCli) .OR. Empty(_cLoja)
		Alert("Digite um Cliente/Loja!")
		Return .F.
	EndIf
	
	If Empty(_cTipon)
		Alert('Informe o tipo da NF!')
		Return .F.
	Endif

	aCarreg := {}

	cAl := getNextAlias()
	
	beginSql Alias cAl
		SELECT ZD9_NUM,ZD9_CARGA,ZD9_SEQUEN,ZD9_JANCAR,ZD9_JANENT,ZD9_DATA,ZD9_DATAEN,ZD9_PLANTA,ZD9_PARA
		FROM %Table:ZD9%
		WHERE ZD9_CLIENT=%Exp:_cCli%
		AND %NotDel%
		AND ZD9_FILIAL=%xFilial:ZD9%
		AND ZD9_LOJA=%Exp:_cLoja%
		AND ZD9_STATUS='P'
		AND ZD9_PARA = %Exp:Iif(_cTipon$'N','C','F')%
		ORDER BY ZD9_NUM DESC
	endSql

	While (cAl)->(!Eof())
		aAdd(aCarreg,{(cAl)->ZD9_NUM,;
		              (cAl)->ZD9_CARGA,;
		              (cAl)->ZD9_SEQUEN,;
		              (cAl)->ZD9_JANCAR,;
		              (cAl)->ZD9_JANENT,;
		              STOD((cAl)->ZD9_DATA),;
		              STOD((cAl)->ZD9_DATAEN),;
		              aPlanta[VAL((cAl)->ZD9_PLANTA)]})

		(cAl)->(Dbskip())
	Enddo	    	

	If _cTipon$'N'
		_cDesCli := Posicione('SA1',1,xFilial('SA1')+_cCli+_cLoja,'A1_NOME')
	Else
		_cDesCli := Posicione('SA2',1,xFilial('SA2')+_cCli+_cLoja,'A2_NOME')
	Endif
	
	oDlgCarreg := MsDialog():New(0,0,300,500,"Escolha o Carregamento",,,,,,,,,.T.)
	
	@ 010,010 Say Iif(_cTipon$'N',"Cliente","Fornecedor")+"/Loja"      SIZE 040,008 Object olCli
	@ 008,040 Get (_cCli+'/'+_cLoja) SIZE 040,008 When .F. Object oCliEF
	@ 008,085 Get _cDesCli SIZE 120,008 When .F. Object oDesCliEF
	
	@ 020,005 LISTBOX oLbx FIELDS HEADER "Número","Carga","Seq. Entrega","Jan. Carreg.","Jan. Entrega","Data","Data Entrega","Planta" ;
	SIZE 247,110 PIXEL OF oDlgCarreg  //ON DBLCLICK( u_fDet(oLbx:nAt))//,oDlg:End())
	
	oLbx:SetArray( aCarreg )
	
	If Empty(aCarreg)
		aAdd(aCarreg,{"","","","","","","",""})
	EndIf
	
	oLbx:bLine := {|| {aCarreg[oLbx:nAt,1],;  // numero
					   aCarreg[oLbx:nAt,2],;  // CARGA
		               aCarreg[oLbx:nAt,3],;  // SEQ CARGA
		               aCarreg[oLbx:nAt,4],;  // JAN CARREG
		               aCarreg[oLbx:nAt,5],;  // JAN ENTREGA
		               aCarreg[oLbx:nAt,6],;  // DATA
		               aCarreg[oLbx:nAt,7],;  // FATA ENTREGA
		               aCarreg[oLbx:nAt,8]}}  // PLANTA

	oLbx:Refresh()                  
	
    oBt1 := tButton():New(135,182,"Ok",oDlgCarreg,{||fOkCarrega()},30,10,,,,.T.)      
    oBt2 := tButton():New(135,218,"Cancelar",oDlgCarreg,{||oDlgCarreg:End()},30,10,,,,.T.)

	oDlgCarreg:Activate(,,,.T.,{||.T.},,)
	
Return .T.

Static Function fOkCarrega()
Local nPrecoProd := 0
Local _cEst := GETMV('MV_ESTADO')
Local cCfo := ''

	If Empty(oLbx:AARRAY[oLbx:nAt][1])
		Return .F.
	ENDIF
	
	ZDA->(DbSetOrder(1))		//filial+num
	ZDA->(DbSeek(xFilial("ZD9")+oLbx:AARRAY[oLbx:nAt][1]))
	
	SB1->(DbSetOrder(1))        //filial+cod
	
	nItem := 0
	aCols := {}
	
	While ZDA->(!EoF()) .AND. ZDA->ZDA_NUM == oLbx:AARRAY[oLbx:nAt][1]
	
		nItem++
		
		SB1->(DbSeek(xFilial("SB1")+ZDA->ZDA_COD))
	
	   	nPrecoProd := Iif(ZDA->ZDA_PRECO<>0,ZDA->ZDA_PRECO,Iif(_ctipon$"N",SB1->B1_PRV1,SB1->B1_UPRC))

	   	SF4->(DbSetOrder(1))
	   	If SF4->(DbSeek(xFilial("SF4")+SB1->B1_TS))   
	
		   	If (_ctipon$ "DB")
		       	cCfo := Iif(SA2->A2_TIPO!="X",If(SA2->A2_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))
		   	Else
		       	cCfo := Iif(SA1->A1_TIPO!="X",If(SA1->A1_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))
		   	EndIf   
	   	Endif	   
			
		aAdd(aCols,{StrZero(nItem,2),; 						//1         STR
					ZDA->ZDA_COD,;     						//2         STR
					SB1->B1_DESC,;     						//3         STR
					SB1->B1_LOCPAD,;					    //4         LOCAL   
				  	SB1->B1_TS,;		//TES				//11        STR
					ZDA->ZDA_QUANT,;   						//5         FLOAT
					"","",;                                 //6,7
					nPrecoProd,;      		                //8         FLOAT
					nPrecoProd*ZDA->ZDA_QUANT,;  			//TOTAL				//9         FLOAT
				  	ZDA->ZDA_VOLUME,;   //VOLUME          	//10        FLOAT
				  	cCfo,;				//CFO         	    //12        STR
				  	ZDA->ZDA_QUANT*SB1->B1_PESO,;					//PESO LIQ			//11        FLOAT
				  	ZDA->ZDA_QUANT*SB1->B1_PESBRU,;     //PESO BRUTO        //12        FLOAT
				  	"","","","",.F.})                 //13,14,15,16,17,18    STR
        
		ZDA->(DbSkip())
		
	EndDo
	
	oMultiline:Refresh()
	oDlgCarreg:End()
	
Return 

//-- valida o saldo por lote
User Function fSldLote()
Local oldArea := getArea()
Local nPosLote := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOTECTL"}) 
Local nPosQtde := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"}) 
Local nPosLoca := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCAL"}) 
Local nPosLclz := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCALIZ"}) 
Local cLote := Iif(AllTrim(Upper(ReadVar())) $ 'M->ZR_LOTECTL',M->ZR_LOTECTL,Acols[n][nPosLote])
Local nquant := Iif(AllTrim(Upper(ReadVar())) $ 'M->ZR_QTDE',M->ZR_QTDE,aCols[n][nPosQtde])

Local cAl  := getNextAlias()
Local nSld := 0

	beginSql Alias cAl
	    SELECT SUM(B8_SALDO) AS SALDO
	    FROM %Table:SB8% B8
	    WHERE B8_PRODUTO = %Exp:aCols[n][2]%
	    AND B8_LOCAL = %Exp:aCols[n][nPosLoca]%
	    AND B8_LOTECTL = %Exp:cLote%
	    AND B8.%NotDel%
	endSql

	If (cAl)->(!eof())
		nSld := (cAl)->SALDO                                                    
	Endif
	
	for xC:=1 to Len(aCols)
		
		If xC!=n .and. aCols[xC][nPosLoca]==aCols[n][nPosLoca]
			If aCols[xC][nPosLote]==aCols[n][nPosLote]
				nSld -= aCols[xC][nPosQtde]
			Endif
		EndIf
	next

	(cAl)->(dbCloseArea())
	
	restarea(oldArea)
	If nSld < nquant
		Alert("Saldo do lote insuficiente!")
		return .f.
	EndIf
	
Return .t.

//-- valida o saldo da localizacao
User Function fSldLclz()
Local oldArea := getArea()
Local nPosLclz := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCALIZ"}) 
Local nPosQtde := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"}) 
Local nPosLoca := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOCAL"}) 
Local _nTES    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TES"}) 
//Local nPosLote := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_LOTECTL"}) XXXXXXX
Local cAl  := getNextAlias()
Local nSld := 0
Local cLocaliz := Iif(AllTrim(Upper(ReadVar())) $ 'M->ZR_LOCALIZ',M->ZR_LOCALIZ,aCols[n][nPosLclz])
Local nquant := Iif(AllTrim(Upper(ReadVar())) $ 'M->ZR_QTDE',M->ZR_QTDE,aCols[n][nPosQtde])

SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+Acols[n][_nTes]))   

   If Alltrim(SF4->F4_ESTOQUE)$"S"

		if empty(aCols[n][nPosLclz])
			alert("Informe o campo Localizacao!")
			return .f.
		endif

		beginSql Alias cAl
		    SELECT SUM(BF_QUANT) AS SALDO
		    FROM %Table:SBF% BF
		    WHERE BF_PRODUTO = %Exp:aCols[n][2]%
		    AND BF_LOCAL = %Exp:aCols[n][nPosLoca]%
		    AND BF_LOCALIZ = %Exp:cLocaliz%
		    AND BF.%NotDel%
		endSql
	
		If (cAl)->(!eof())
			nSld := (cAl)->SALDO
		Endif
		
		for xC:=1 to Len(aCols)
			
			If xC!=n .and. aCols[xC][nPosLoca]==aCols[n][nPosLoca]
				If aCols[xC][nPosLclz]==aCols[n][nPosLclz]
					nSld -= aCols[xC][nPosQtde]
				Endif
			EndIf
		next
	
		(cAl)->(dbCloseArea())
		restarea(oldArea)	
		If nSld < nquant
			Alert("Não existe saldo suficiente para este endereço!")
			return .f.
		EndIf
   	Else
   		If AllTrim(Upper(ReadVar())) $ 'M->ZR_LOCALIZ'
   	   		M->ZR_LOCALIZ := space(15)
   	 	Endif
 		aCols[n][nPosLclz] := space(15)
   Endif	
   
Return .t.

Static Function ShowF4()
Local _nTES    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_TES"}) 

	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+Acols[n][_nTes]))
   	If Alltrim(SF4->F4_ESTOQUE)$"S"

		If Alltrim(ReadVar())$"M->ZR_LOCALIZ"
			F4Localiz()
		ElseIf Alltrim(ReadVar())$"M->ZR_LOTECTL"
			F4Lote()
		Else
			Return
		Endif

	else
		Alert("Tes nao baixa estoque!")
		return
	endif
	
Return

Static Function F4LOCALIZ()
nProd    := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_PRODUTO"})
nLocal   := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_LOCAL"})
nLocaliz := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_LOCALIZ"})
nLotectl := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_LOTECTL"})

aSaldoBF := {}

	If Empty(aCols[n][nProd])
		Alert('Informe o produto!')
		return .f.
	Endif
	
	If Empty(aCols[n][nLocal])
		Alert('Informe o local!')
		return .f.
	Endif
	
	SB1->(dbsetorder(1))
	SB1->(dbSeek(xFilial('SB1')+ACOLS[n][nProd]))

	If SB1->B1_LOCALIZ=='S' //-- controla localizacao
	
	   	SBF->(DbSetOrder(2)) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
	    If SBF->(DbSeek(xFilial("SBF")+aCols[n][nProd]+aCols[n][nLocal]))
	    	While SBF->(!Eof()) .And. SBF->BF_PRODUTO==aCols[n][nProd] .AND. SBF->BF_LOCAL==aCols[n][nLocal]

				If SBF->BF_QUANT > 0
				
					dDtValid := CtoD("  /  /  ")
				
					If !Empty(SBF->BF_LOTECTL)
						SB8->(dbsetorder(3))//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
						If SB8->(dbSeek(xFilial("SB8")+aCols[n][nProd]+aCols[n][nLocal]+SBF->BF_LOTECTL))
						 	dDtValid := SB8->B8_DTVALID
						Else
							Alert('Erro ao encontrar o lote na tabela SB8!'+chr(13)+chr(10)+;
								  'Produto:' + aCols[n][nProd] +chr(13)+chr(10)+ ;
								  'Local: ' + aCols[n][nLocal] +chr(13)+chr(10)+ ;
								  'Localiz: '+ SBF->BF_LOCALIZ +chr(13)+chr(10)+;
								  'Lote: '+ SBF->BF_LOTECTL	)
							return .f.
						Endif
					Endif
					
					aAdd(aSaldoBF,{SBF->BF_LOCALIZ,SBF->BF_QUANT,SBF->BF_LOTECTL,dDtValid})
				
				EndIf

				SBF->(Dbskip())
			Enddo	    	
		Else
			Alert('Produto não tem saldo por endereço! Verifique se existem saldos a Distribuir/Endereçar!')
			Return .F.
		Endif
	   
    eLSE
    	Alert('Produto não controla localizacao!')
    	Return
	Endif

	oDlgSalEnd  := MsDialog():New(0,0,300,400,"Saldo por Localização",,,,,,,,,.T.)
	
	@ 010,010 Say "Produto:"      SIZE 040,008 Object olProd
	@ 008,040 Get aCols[n][nProd] SIZE 060,008 When .F. Object oProd
	
	@ 010,140 Say "Local:"         SIZE 040,008 Object olLocal
	@ 008,170 Get aCols[n][nLocal] SIZE 020,008 When .F. Object oLocal
	
	@ 020,005 LISTBOX oLbx FIELDS HEADER "Endereço","Saldo","Lote","Data Validade" ;
	SIZE 192,110 PIXEL OF oDlgSalEnd  //ON DBLCLICK( u_fDet(oLbx:nAt))//,oDlg:End())
	
	oLbx:SetArray( aSaldoBF )
	
	If Empty(aSaldoBF)
		aAdd(aSaldoBF,{"",0,"",""})
	EndIf
	
	oLbx:bLine := {|| {aSaldoBF[oLbx:nAt,1],;  // ENDERECO
					   aSaldoBF[oLbx:nAt,2],;  // SALDO
		               aSaldoBF[oLbx:nAt,3],;  // LOTE
	   		           aSaldoBF[oLbx:nAt,4]}}  // DATA VALIDADE
	
	oLbx:Refresh()                  
	
    oBt1 := tButton():New(135,132,"Ok",oDlgSalEnd,{||fOkSalEnd()},30,10,,,,.T.)      
    oBt2 := tButton():New(135,168,"Cancelar",oDlgSalEnd,{||oDlgSalEnd:End()},30,10,,,,.T.)

	oDlgSalEnd:Activate(,,,.T.,{||.T.},,)
	
Return .T.

Static Function fOkSalEnd()
	
	oDlgSalEnd:End()

	aCols[n][nLocaliz] := M->ZR_LOCALIZ := oLbx:AARRAY[oLbx:nAt][1] 
	
	If !U_fSldLclz()
		aCols[n][nLocaliz] := M->ZR_LOCALIZ := SPACE(15)
		Return .F.
	Endif
	
	SB1->(dbsetorder(1))
	SB1->(dbSeek(xFilial('SB1')+ACOLS[n][nProd]))

	If SB1->B1_RASTRO=='L'
		aCols[n][nLotectl] := M->ZR_LOTECTL := oLbx:AARRAY[oLbx:nAt][3] 
		
		If !U_fSldLote()
			aCols[n][nLotectl] := M->ZR_LOTECTL := Space(15)
			Return .F.
		Endif
	Endif
	
Return

Static Function F4LOTE()
nProd    := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_PRODUTO"})
nLocal   := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_LOCAL"})
nLotectl := aScan(aHeader,{|x| UPPER(ALLTRIM(x[2]))=="ZR_LOTECTL"})

aSaldoB8 := {}

	If Empty(aCols[n][nProd])
		Alert('Informe o produto!')
		return .f.
	Endif
	
	If Empty(aCols[n][nLocal])
		Alert('Informe o local!')
		return .f.
	Endif
	
	SB1->(dbsetorder(1))
	SB1->(dbSeek(xFilial('SB1')+ACOLS[n][nProd]))

	If SB1->B1_RASTRO=='L' //-- controla lote
	
	   	SB8->(DbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	    If SB8->(DbSeek(xFilial("SB8")+aCols[n][nProd]+aCols[n][nLocal]))
	    	While SB8->(!Eof()) .And. SB8->B8_PRODUTO==aCols[n][nProd] .AND. SB8->B8_LOCAL==aCols[n][nLocal]

				If SB8->B8_SALDO > 0
					aAdd(aSaldoB8,{SB8->B8_LOTECTL,SB8->B8_SALDO,SB8->B8_DTVALID})
				EndIf

				SB8->(Dbskip())
			Enddo	    	
		Else
			Alert('Saldo por lote vazio!')
			Return .F.
		Endif

    eLSE
    	Alert('Produto não controla lote!')
    	Return
	Endif

	oDlgSalLot  := MsDialog():New(0,0,300,400,"Saldo por Lote",,,,,,,,,.T.)
	
	@ 010,010 Say "Produto:"      SIZE 040,008 Object olProd
	@ 008,040 Get aCols[n][nProd] SIZE 060,008 When .F. Object oProd
	
	@ 010,140 Say "Local:"         SIZE 040,008 Object olLocal
	@ 008,170 Get aCols[n][nLocal] SIZE 020,008 When .F. Object oLocal
	
	@ 020,005 LISTBOX oLbx FIELDS HEADER "Lote","Saldo","Data Validade" ;
	SIZE 192,110 PIXEL OF oDlgSalLot  //ON DBLCLICK( u_fDet(oLbx:nAt))//,oDlg:End())
	
	oLbx:SetArray( aSaldoB8 )
	
	If Empty(aSaldoB8)
		aAdd(aSaldoB8,{"",0,""})
	EndIf
	
	oLbx:bLine := {|| {aSaldoB8[oLbx:nAt,1],;  // LOTE
					   aSaldoB8[oLbx:nAt,2],;  // SALDO
		               aSaldoB8[oLbx:nAt,3]}}  // DATA VALIDADE

	oLbx:Refresh()                  
	
    oBt1 := tButton():New(135,132,"Ok",oDlgSalLot,{||fOkSalLot()},30,10,,,,.T.)      
    oBt2 := tButton():New(135,168,"Cancelar",oDlgSalLot,{||oDlgSalLot:End()},30,10,,,,.T.)

	oDlgSalLot:Activate(,,,.T.,{||.T.},,)
	
Return .T.

Static Function fOkSalLot()

	aCols[n][nLotectl] := M->ZR_LOTECTL := oLbx:AARRAY[oLbx:nAt][1] 
	oDlgSalLot:End()
	
Return
                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EMAIL DE AVISO DE AMOSTRA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/* //retirado pela os 073259
		
Static Function fMailAmostra()
Local cMsg := ''
Local cMailUsr := ''
Local cMailRsp := ''
Local cEmpAux := ''
Local cToApr := ''
Local nPosQtde  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"}) 

	ProcRegua(3)

	//--------------------------------------------------------------//
	//-- ENVIA E-MAIL AO SOLICITANTE INFORMANDO SOBRE A APROVAçãO --//
	//--------------------------------------------------------------//
	
	IncProc('Passo 1/3')
	
	//-- verifica se existe e-mail cadastrado na tabela QAA
	QAA->(dbsetorder(6)) // login
	If QAA->(dbSeek(Alltrim(upper(cUsername))))
	
		If !empty(QAA->QAA_EMAIL)
			cMailUsr := QAA->QAA_EMAIL
		Else
			//-- senao pega o e-mail do configurador
			cMailUsr := U_Nhcfg001("05")
		Endif
	
	Endif
	
	IncProc('Passo 2/3')	

	If !Empty(cMailUsr)
	
		cMsg := '<style type="text/css">'  
		cMsg += '.consumo{ border-collapse:collapse;  font-family:arial } '
		cMsg += '.consumo th{ background:#cccccc } '		
		cMsg += '.planta{ font-weight:bold; font-size:14px;}'
		cMsg += '</style>'              
	
		cMsg += '<h3>AVISO AO SOLICITANTE DE NF DE AMOSTRA</h3><br />'
	
		cMsg += 'A NF rerefente a Solicitação Nº:'+_cDoc+' só será emitida após aprovação da Qualidade/Engenharia. Favor providenciar a aprovação junto aos responsáveis.<BR /><BR />'
		
		ZEP->(dbsetorder(2)) // ZEP_FILIAL+ZEP_PLANTA+ZEP_AREA 
		//ZEP->(dbseek(xFilial("ZEP")+SZQ->ZQ_FABRICA))
	
		cMsg += '<table class="consumo" border="1" cellpadding="5">'
		cEmpAux := ''
		  
		ZEP->(dbgotop())
		
		While ZEP->(!EOF())
		    
		    If cEmpAux != ZEP->ZEP_PLANTA .AND. ZEP->ZEP_PLANTA!='T'
		    	cMsg += '<tr><th colspan="2" class="planta" align="left">'+Substr(_aFab[val(ZEP->ZEP_PLANTA)],3,len(_aFab[val(ZEP->ZEP_PLANTA)])-2)+'</th></tr>'
		    	cEmpAux := ZEP->ZEP_PLANTA
		    Endif   
		    
			//-- verifica se existe e-mail cadastrado na tabela QAA
			cMailRsp := ''
			QAA->(dbsetorder(6)) // login
			If QAA->(dbSeek(ZEP->ZEP_LOGIN))
			
				cNomeRsp := QAA->QAA_NOME
				If !empty(QAA->QAA_EMAIL)
					cMailRsp := QAA->QAA_EMAIL
				Endif
			
			Endif
		
        	If empty(cMailRsp) .or. empty(cNomeRsp)

				PswOrder(2) // Pesquisa por usuario
				PswSeek(alltrim(upper(ZEP->ZEP_LOGIN)),.T.)
				aUser := PswRet(1)
				cIDUsr := aUser[1][1] // ID do usuario.
				
				If empty(cNomeRsp)
					cNomeRsp := aUser[1][4]
				endif
				
				If empty(cMailRsp)
					cMailRsp := aUser[1][14]
				endif
			
			Endif	    
			
			//-- guarda os e-mails dos aprovadores
		    If ZEP->ZEP_AREA$"E/Q/S" .AND. (ZEP->ZEP_PLANTA==_cFab .or. ZEP->ZEP_PLANTA=='T')
				cToApr += cMailRsp + ';'
			Endif
			
			If ZEP->ZEP_AREA$"E/Q" .AND. ZEP->ZEP_PLANTA <> 'T'
			    cMsg += '<tr><td>'+cNomeRsp+ '</td><td style="color:#003366">'+lower(cMailRsp)+'</td></tr>' 
			Endif
		
			ZEP->(dbSkip())
		Enddo
		
		cMsg += '</table><BR />'

		oMail := Email():New()
		oMail:cMsg := cMsg
		oMail:cAssunto := '*** AVISO AO SOLICITANTE DE NF DE AMOSTRA ***'  
		oMail:cTo := cMailUsr
		 
		if !empty(oMail:cTo)
			oMail:Envia()
		endif
	
	Endif
	
	//----------------------------------------------------------------//
	//-- ENVIA E-MAIL AOS RESPONSÁVEIS PARA APROVAREM A SOLICITAÇÃO --//
	//----------------------------------------------------------------//

	IncProc('Passo 3/3')

	cMsg := '<style type="text/css">'
	cMsg += '.consumo{ border-collapse:collapse;  font-family:arial } '
	cMsg += '.consumo th{ background:#cccccc } '
	cMsg += '.total{ background:#efefef }'
	cMsg += '</style>'              

	cMsg += '<h3>AVISO SOLICITAÇÃO DE NOTA FISCAL DE AMOSTRA</h3><br/>'

	cMsg += 'Comunico que se encontra em processo de faturamento a amostra do(s) produto(s): <BR /><BR />'
	
	cMsg += '<table class="consumo" border="1" cellpadding="5">'
	cMsg += '<tr><th>Código</th><th>Descrição</th><th>Quantidade</th>'
	
	for xA:=1 to len(aCols)
		cMsg += '<tr>'
	 	//If Acols[xA][8]$"528/529/527/530/532"
			cMsg += '<td align="center">'+aCols[xA][2]+'</td>'
			cMsg += '<td align="left"  >'+aCols[xA][3]+'</td>'
			cMsg += '<td align="right" >'+ALLTRIM(STR(aCols[xA][nPosQtde]))+'</td>'
		//endif
		cMsg += '</tr>'
	next
	
	cMsg += '</table><br /><br />'
	
	If(_ctipon$"Normal")
		cMsg += 'Cliente/Loja: '+ _cCli+'/'+_cLoja+' - '+Posicione('SA1',1,xFilial('SA1')+_cCli+_cLoja,'A1_NOME')
	Else
		cMsg += 'Fornecedor/Loja: '+ _cCli+'/'+_cLoja+' - '+Posicione('SA2',1,xFilial('SA2')+_cCli+_cLoja,'A2_NOME')
	Endif

	cMsg += '<br />Solicitante:  ' + UsrFullname(__cUserId ) + '<br />'
	If !Empty(Subs(U_Nhcfg001("06"),6,4))
		cMsg += 'Ramal: '+ Subs(U_Nhcfg001("06"),6,4)+'<br />'
	Endif
	             
	cMsg += '<br /><div style="color:#ff0000;font-weight:bold">O Processo ficará bloqueado até a sua aprovação e liberação no sistema Protheus.</div><br />'

	oMail := Email():New()
	oMail:cMsg := cMsg
	oMail:cAssunto := '*** AVISO DE SOLICITAÇÃO DE NF DE AMOSTRA ***'  
	oMail:cTo := cToApr
	
	if !empty(oMail:cTo)
		oMail:Envia()
	endif

Return                         
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EMAIL DE AVISO DE APROVAÇÃO PERNAMBUCO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fMailAprov(_numSol)

SetPrvt("cServ,cAc,cPas,lOk,lEnvia,cMens,cMsg,a_mail")
cServ := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
cAc  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
cPas := Alltrim(GETMV("MV_RELPSW"))  //'siga'
lOk
lEnvia
cMsg := ''
cMens := 'Erro ao se conectar no servidor: ' 

CONNECT SMTP SERVER cServ ACCOUNT cAc PASSWORD cPas Result lOk
	
	    cMsg := '<html><body><div style="background:#ffffff;font-family:arial;font-size:12px;margin:0px">
		cMsg += '<table cellpadding="0" cellspacing="5" width="100%" style="font-family:arial;font-size:12px;margin:0px">'
		cMsg += '<tr><td bgcolor="#cccccc" width="10">&nbsp;</td><td bgcolor="#efefef" style="color:#666666;font-size:18px"'
		cMsg += 'height="30" valign="middle">&nbsp;&nbsp;SOLICITAÇÃO NF DE SAÍDA</td></tr><tr><td colspan="3" class="conteudo">
		cMsg += '<br>O usuario '
		cMsg += Upper(cUserName)
		cMsg += ' gerou a solicitação de NF de saída ' + _numSol + ' e necessita sua aprovação.<br></td></tr></table><hr></div></body></html>'
	
	 	a_mail := 'hesslerr@whbbrasil.com.br;' 	 
	  	a_mail += 'ericalp@whbbrasil.com.br' 
	
		If lOk
			Send Mail from 'protheus@whbbrasil.com.br' To a_mail;
			SUBJECT '***** APROVAÇÃO DE SOLICITAÇÃO DE NOTA FISCAL DE SAÍDA - '+_numSol+' ***** ';
			BODY cMsg;                      
			RESULT lEnvia
		    If !lEnvia
				Get mail error cMens
			  	   Alert(cMens)
	    	EndIf                             
		 else
			Alert("Erro ao se conectar no servidor: " + cServ)		
		 Endif
Return


