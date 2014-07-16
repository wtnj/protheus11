/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT015  ³ Autor ³ Alexandre R. Bento     Data ³ 27/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera pedido de venda apartir da solicitação de NF Saida    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento WHB                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    

User Function nhfat015()

SetPrvt("CCADASTRO,AROTINA,")

DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  
DEFINE FONT oFont12 NAME "Arial" SIZE 10, -12                                                                  

cCadastro := OemToAnsi("Gera Pedido de Nota Fiscal de Saida")
aRotina := {{ "Pesquisa","AxPesqui"     ,  0 , 1},;
            { "Visualizacao",'U_fGpedido()', 0 , 2},;
            { "Gera Pedido" ,'U_fGerPed()' , 0,3},;
            { "Legenda" ,"U_FLegPed",0,2}}     
            
mBrowse( 6, 1,22,75,"SZQ",,,,,,fCriaCor())

Return


User Function fGPedido()

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser")  
SetPrvt("_cDoc,_aTipoN,_cTipon,_cCond,_cCli, _cLoja,_cTpFre,_nPLiqui,_nPBruto,_nVol,_cEsp,_cMens,_cDesCli,_cF3")
SetPrvt("_cCliFor,_cTiFre,_aTiFre,_cObs,_dData,_cHora,_cPar,_cTpCli,_nMoeda,_aVia, _cVia,_cCodTra,_cDesTra")

DEFINE FONT oFont12 NAME "Arial" SIZE 12, -12                                                                  

lDialog  := .F.               
_cDoc    := Space(06)
_aTipon  := {"Venda",OemToAnsi("Dev.Compra"),"Util.Fornecedor"}
_aTiFre  := {"C=CIF","F=FOB"}
_cTiFre  := ""
_cTipon  := "Venda"   
_cCliFor := "Cliente:"
_cCond   := Space(03)
_cCli    := Space(06)
_cLoja   := Space(02) 
_cDesCli := Space(30) 
_cTpFre  := Space(10)  
_nPLiqui := 0          
_nPBruto := 0
_nVol    := 0
_cEsp    := "VOL"
_cMens   := Space(100) 
_cObs    := Space(100) 
_cF3     := Space(03)        
aHeader  := {}        
aCols    := {}
_dData   := date()
_cHora   := time()   
 nMax    := 0                                                       
 _cVia   := Space(15)
_cCodTra := Space(06)
_cDesTra := Space(40)
_cUser   := Space(06)

	If SZQ->ZQ_STATUS$'P' //Pendente de aprovacao de nf de amostra
		Alert('NF de Amostra pendente de aprovação!')
		Return
	Endif
	
	If SZQ->ZQ_STATUS$'A' //Pendente de aprovacao de nf (Hessler)
		Alert('NF pendente de aprovação logistica filial Pernambuco !')
		Return
	Endif
    
   Aadd(aHeader,{"Item"       , "UM"       ,  "@!"              ,02, 0,".F.","","C","SZR"}) //03
   Aadd(aHeader,{"Produto"    , "UM"       ,Repli("!",15)       ,15, 0,".F.","","C","SZR"}) //03
   Aadd(aHeader,{"Descricao"  , "UM"       ,Repli("!",30)       ,30, 0,".F.","","C","SZR"}) //03
   Aadd(aHeader,{"Quantidade" , "ZR_QTDE"  ,"@E 999,999,999.99" ,12, 2,".F.","","C","SZR"}) //03
   Aadd(aHeader,{"Preco"      , "ZR_PRECO" ,"@E 9,999,999.9999" ,14, 4,".F.","","C","SZR"}) //03
   Aadd(aHeader,{"Total"      , "ZR_TOTAL" ,"@E 9,999,999.9999" ,14, 4,".F.","","C","SZR"}) //03
   Aadd(aHeader,{"Local"      , "UM"       ,"!!"                ,02, 0,".F.","","C","SZR"}) //03

//fQuery()   
Processa( {|| fQuery() },"Selecionando Dados")

Define MsDialog oDialog Title OemToAnsi("Solicitação de Nota Fiscal de Saida") From 010,030 To 458,860 Pixel 
@ 013,007 To 090,410 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8            
@ 027,032 Say _cDoc Size 035,10 Object oDoc            
 oDoc:Setfont(oFont12)                      
@ 027,090 Say "Tipo Nota:" Size 30,8          
@ 027,116 say  _cTipon SIZE 70,10 object oTipon
   oTipon:Setfont(oFont12)                         
@ 027,190 Say "Cond. Pgto:" Size 30,8            
@ 025,225 Get _cCond Picture "@!" When(_cPar == 3) F3 "SE4" Size 25,8 Object oCond           
@ 027,280 Say "Data:" Size 30,8            
@ 025,295 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 027,350 Say "Hora:" Size 30,8            
@ 025,370 Get _cHora Picture "99:99:99" When .F. Size 35,8 Object oHora              
@ 040,010 Say _cClifor Size 040,8 Object oCliFor               
@ 038,040 Get _cCli Picture "@!"  When(.F.) F3 fRetF3() Size 30,8 Object oCli            
@ 038,072 Get _cLoja Picture "@!"  When(.F.) Size 10,8 Object oLoja            
@ 038,090 Get _cDesCli Picture "@!" When .F. Size 100,8 Object oDesCli            
@ 040,200 Say "Transportadora:" Size 050,8 object oTransp
@ 038,240 Get _cCodTra  Size 25,8 F3 "SA4" When(.F.) object oCodTra
@ 038,272 Get _cDesTra  Size 133,8 When(.F.) object oDesTra           

@ 053,010 Say "Tipo Frete:" Size 030,8 object oTpFrete           
@ 053,040 say  _cTiFre SIZE 35,10 object oTiFre
   oTiFre:Setfont(oFont12)                         
@ 053,080 Say "Via:" Size 010,8 object oTpFrete           
@ 053,93 say  _cVia SIZE 50,10 object oVia
     oVia:Setfont(oFont12)                         
@ 053,160 Say "Peso Liq.:" Size 050,8 object oPesoL  
@ 051,190 Get _nPLiqui Picture "@E 9,999,999.99" When(.F.) Size 40,8 Object oPLiqui             

@ 053,250 Say OemToAnsi("Peso Bruto:") Size 050,8                    
@ 051,280 Get _nPBruto Picture "@E 999,999.99" When(.F.) Size 050,8  Object oPbruto
@ 053,355 Say OemToAnsi("Volume :") Size 050,8
@ 051,380 Get _nVol Picture "@E 99999" When(.F.) Size 025,8 Object oVol                                 

@ 065,340 Say "Especie :"  Size 050,8            
@ 063,365 Get _cEsp  Picture "@!" When(.F.) Size 40,8 Object oEsp             
@ 065,010 Say "Mensagem:"   Size 040,8                    
@ 063,040 Get _cMens Picture "@!" When(.F.) Size 295,8 Object oMens          
@ 077,010 Say OemToAnsi("Observação:")   Size 040,8                    
@ 075,040 Get _cObs Picture "@!" When(.F.) Size 365,8 Object oObs          

@ 095,006 To 200,410 Title OemToAnsi("  Informações ")  
@ 105,006 TO 190,410 MULTILINE MODIFY OBJECT oMultiline
If len(alltrim(_cUser)) > 15
   @ 205,010 Say _cUser Object oUser             
   oUser:Setfont(oFont12)                      
Endif   
@ 205,285 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 205,350 BMPBUTTON TYPE 02 ACTION fEnd() 
oTipon:bChange:={|| fCli() }
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog oDialog Center Valid fDialog()
SZR->(DbCloseArea())
TMP->(DbCloseArea())                  
Return           


Static Function fQuery()
Local cQuery

cQuery := "SELECT * "
cQuery += "FROM " +  RetSqlName( 'SZQ' ) +" SZQ, " +  RetSqlName( 'SZR' ) +" SZR "
cQuery += "WHERE SZQ.ZQ_FILIAL = '" + xFilial("SZQ")+ "'"    
cQuery += "AND SZR.ZR_FILIAL = '" + xFilial("SZR")+ "'"    
cQuery += "AND SZR.D_E_L_E_T_ = ' ' "
cQuery += "AND SZQ.D_E_L_E_T_ = ' ' "
cQuery += "AND SZQ.ZQ_NUM = SZR.ZR_NUM "
cQuery += "AND SZQ.ZQ_EMISSAO = SZR.ZR_EMISSAO "
cQuery += "AND SZQ.ZQ_NUM BETWEEN '" + SZQ->ZQ_NUM + "' AND '" + SZQ->ZQ_NUM + "' "                                                                                                           
cQuery += "order by SZR.ZR_NUM,SZR.ZR_ITEM"
   
MemoWrit('C:\TEMP\FAT015.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","ZQ_EMISSAO","D")  // Muda a data de string para date    
DbSelectArea("TMP")
TMP->(DBGOTOP())
If Empty(TMP->ZQ_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   TMP->(DbCloseArea())                  
   return
Endif    
//Atribui variaveis para consulta
_cDoc     := TMP->ZQ_NUM     
_cCli     := TMP->ZQ_CLIENTE 
_cLoja    := TMP->ZQ_LOJA  
_cTipon	  := IIf(TMP->ZQ_TIPO$"N","Venda",IIf(TMP->ZQ_TIPO$"D","Dev.Compra","Util.Fornecedor"))  //Cliente         

If(_ctipon$"Venda")  
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

_dData    := Dtoc(TMP->ZQ_EMISSAO) 
_cTiFre   := Iif(TMP->ZQ_TIPOFRE=="C","CIF","FOB")
_nPBruto  := TMP->ZR_PESOB 
_nPLiqui  := TMP->ZR_PESOL   
_nVol	  := TMP->ZR_VOLUME  
_cEsp     := TMP->ZQ_ESPECIE 
_cCond	  := TMP->ZQ_CONDPG 
_cMens    := TMP->ZQ_MENS 
_cObs     := TMP->ZQ_OBS   
_cCodTra  := TMP->ZQ_TRANSP   
_cVia     := TMP->ZQ_VIA
//_cUser    := TMP->ZQ_USER
_cUser    := "Solicitante:  " + UsrFullname(TMP->ZQ_USER )   

SA4->(DbSetOrder(1))
SA4->(DbSeek(xFilial("SA4")+_cCodTra))
    _cDesTra := SA4->A4_NOME

DbSelectArea("SZR")
While (!TMP->(EOF()))

   Aadd(aCols,{TMP->ZR_ITEM,TMP->ZR_PRODUTO,TMP->ZR_DESCRI,TMP->ZR_QTDE,TMP->ZR_PRECO,TMP->ZR_TOTAL,TMP->ZR_LOCAL})
   
   TMP->(Dbskip())
Enddo
nMax:= len(aCols)
//TMP->(DbCloseArea())
Return


Static Function fDialog()


    lDialog := .F.                        

Return(lDialog)

Static Function fFornece()

If Empty(_cCli) .Or. Len(Alltrim(_cCli)) < 6
   Return(.F.)
Endif
          
Return(.T.)

Static Function fCli()

If(_ctipon$"Venda")  //Cliente
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
ObjectMethod(oCliFor,"SetText(_cCliFor)")
          
Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA A CONSULTA DO CAMPO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fRetF3()
	If(_ctipon$"Venda")  
	   _cF3:= "SA1" //Cadastro de Cliente
	else
	   _cF3:= "SA2" // Cadastro de fornecedores
	endif
return(_cF3) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fLoja()

If(_ctipon$"Venda")  
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
      _cDesCli := SA1->A1_NOME
      _cLoja   := SA1->A1_LOJA
   Else
      Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      oCli:SetFocus(oCli)
      oCli:Refresh()
      Return(.F.)
   Endif
Else                    
   SA2->(DbSetOrder(1))
   If SA2->(DbSeek(xFilial("SA2")+_cCli+_cLoja))
      _cDesCli := SA2->A2_NOME
      _cLoja    := SA2->A2_LOJA
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
   	Close(oDialog) 
   	lDialog := .T.                        
Return

Static Function fGrvOrd()
    Close(oDialog)	  
    lDialog := .T.                        
Return

User Function FLegPed()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"   },;
  					  {"BR_VERMELHO" , "Fechada"  },;
  					  {"BR_PRETO"    , "Pendente de Aprovação"},;
   					  {"BR_AZUL"     , "Pendente de Aprovação Pernambuco"},;
   					  {"BR_CANCEL"   , "Rejeitado pela logistica"}}

BrwLegenda(OemToAnsi("Solicitação de Nota Fiscal"), "Legenda", aLegenda)

Return  

Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"   },;
  					  {"BR_VERMELHO" , "Fechada"  },;
  					  {"BR_PRETO"    , "Pendente de Aprovação"},;
   					  {"BR_AZUL"     , "Pendente de Aprovação Pernambuco"},;
   					  {"BR_CANCEL"   , "Rejeitado pela logistica"}}
   					  
Local uRetorno := {}
Aadd(uRetorno, { 'ZQ_STATUS == " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "S"' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "P"' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZQ_STATUS == "A"' , aLegenda[4][1] } ) // ADICIONADO EM 11/12/13
Aadd(uRetorno, { 'ZQ_STATUS == "R"' , aLegenda[5][1] } ) // ADICIONADO EM 11/12/13

Return(uRetorno)


User Function fGerPed()
Local cQuery1                          
Local _cEst     := GetMv("MV_ESTADO")
Local _nItem    := 0
Local _nx       := 0      
Local _nRecno   := 0
Local _nVolu    := 0
Local _nPl      := 0 
Local _nPb      := 0 
Local _cUser
Local _cOBS    


Private aCabPV  := {}
Private aItemPV := {}
Private aItemPA := {}  // Matriz para produto Acabado
Private _cCFO   := Space(06) 
Private _cTes   := Space(03) 
Private _cDTes  := Space(30) 
Private _cDCfo  := Space(30) 

cQuery1 := "SELECT SZR.R_E_C_N_O_ AS 'ZR_RECNO', SZQ.R_E_C_N_O_ AS 'ZQ_RECNO',* "
cQuery1 += "FROM " +  RetSqlName( 'SZQ' ) +" SZQ, " +  RetSqlName( 'SZR' ) +" SZR "
cQuery1 += "WHERE SZQ.ZQ_FILIAL = '" + xFilial("SZQ")+ "'"    
cQuery1 += "AND SZR.ZR_FILIAL = '" + xFilial("SZR")+ "'"    
cQuery1 += "AND SZR.D_E_L_E_T_ = ' ' "
cQuery1 += "AND SZQ.D_E_L_E_T_ = ' ' "
cQuery1 += "AND SZQ.ZQ_NUM = SZR.ZR_NUM "
cQuery1 += "AND SZQ.ZQ_EMISSAO = SZR.ZR_EMISSAO "
//cQuery1 += "AND SZR.ZR_PEDIDO = ' ' AND SZQ.ZQ_STATUS = ' ' " 
cQuery1 += "AND SZQ.ZQ_NUM BETWEEN '" + SZQ->ZQ_NUM + "' AND '" + SZQ->ZQ_NUM + "' "                                                                                                           
cQuery1 += "ORDER BY SZR.ZR_FILIAL,SZR.ZR_NUM,SZR.ZR_ITEM"

   
//MemoWrit('C:\TEMP\EST068.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery1 NEW ALIAS "TRB"      
TcSetField("TRB","ZQ_EMISSAO","D")  // Muda a data de string para date    
//DbSelectArea("TRB")
TRB->(DBGOTOP())
If Empty(TRB->ZQ_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   TRB->(DbCloseArea())
   return
Endif    

If Alltrim(TRB->ZQ_STATUS)$"S"//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Atenção Para Esta Solicitação ja foi Gerado Pedido, Verifique !!!" ,"Atencao","ALERT" )     
   TRB->(DbCloseArea())
   return
Endif    

//
// Adicionado em 16/12/13 - Aprovação Logistica Pernambuco (Hessler)
If Alltrim(TRB->ZQ_STATUS)$"A"
   Msgbox("Solicitação está pendente para aprovação da logistica Pernambuco !!!" ,"Atencao","ALERT" )     
   TRB->(DbCloseArea())
   return
Endif

// Adicionado em 16/12/13 - Aprovação Logistica Pernambuco (Hessler)
If Alltrim(TRB->ZQ_STATUS)$"R"
   Msgbox("Solicitação foi rejeitada pela logística !!!" ,"Atencao","ALERT" )     
   TRB->(DbCloseArea())
   return
Endif


_cUser  := "Solicitante:  " + ALLTRIM(UsrFullname(TRB->ZQ_USER ) ) +"    Ramal: "+  StrZero(TRB->ZQ_RAMAL,4)
_cOBS   := TRB->ZQ_OBS

_nRecno := TRB->ZQ_RECNO //Guarda o numero do Recno para fechar a solicitação de NF
//Cabecalho
   aCabPV :={{"C5_FILIAL" ,xFilial("SC5")   ,Nil},; // Filial
		     {"C5_TIPO"    ,TRB->ZQ_TIPO    ,Nil},; // Tipo de pedido (REMESSA PRA TROCA)		   
		     {"C5_CLIENTE" ,TRB->ZQ_CLIENTE ,Nil},; // Codigo do cliente  				    
		     {"C5_LOJAENT" ,TRB->ZQ_LOJA    ,Nil},; // Loja para entrada		   
		     {"C5_LOJACLI" ,TRB->ZQ_LOJA    ,Nil},; // Loja do cliente
		     {"C5_TIPOCLI" ,TRB->ZQ_TIPOCLI ,Nil},; // TIPO DO CLIENTE
		     {"C5_CONDPAG" ,TRB->ZQ_CONDPG  ,Nil},; // Codigo da condicao de pagamanto*		   		   
		     {"C5_TABELA"  ,"   "           ,Nil},; // Tipo de Liberacao                   
		     {"C5_TPFRETE"  ,TRB->ZQ_TIPOFRE,Nil},; // Tipo de Frete
		     {"C5_EMISSAO"  ,dDataBase      ,Nil},; // Tipo de Liberacao		   		   
		     {"C5_MOEDA"  ,TRB->ZQ_MOEDA    ,Nil},; // Tipo de Liberacao		   		   		   
		     {"C5_MENNOTA" ,TRB->ZQ_MENS    ,Nil},; // Liberacao Total		   
         	 {"C5_TRANSP"  ,TRB->ZQ_TRANSP  ,Nil},; // Transportadora
		     {"C5_TIPLIB"  ,"1"             ,Nil}} // Tipo de Liberacao
		     

SB1->(DbSetOrder(1))
SA1->(DbSetOrder(1))   
SA2->(DbSetOrder(1))
SF4->(DbSetOrder(1))

aHead := {}
aCol  := {}
aColAux := {}

aAdd(aHead,{'Produto'   ,"ZR_PRODUTO", PesqPict("SZR","ZR_PRODUTO") ,15,0,'.F.','.t.','C','','R'})
aAdd(aHead,{'Descrição' ,"ZR_DESCRI" , PesqPict("SZR","ZR_DESCRI") 	,30,0,'.F.','.t.','C','','R'})
aAdd(aHead,{'TES'       ,"ZR_TES"    , PesqPict("SZR","ZR_TES") 	,03,0,'U_FAT15Tes()','.t.','C','','R'})	
aAdd(aHead,{'Desc. TES' ,"F4_TEXTO"  , PesqPict("SF4","F4_TEXTO") 	,06,0,'.F.','.t.','C','','R'})
aAdd(aHead,{'CFO'       ,"ZR_CF"     , PesqPict("SZR","ZR_CF")  	,13,3,'U_FAT15CFO()','.t.','C','','R'})	

While (!TRB->(Eof()))
                 
   SF4->(DbSeek(xFilial("SF4")+TRB->ZR_TES),.T.)

   aAdd(aCol,{ Alltrim(TRB->ZR_PRODUTO),;  
  			   TRB->ZR_DESCRI,;
			   TRB->ZR_TES,;
			   SF4->F4_TEXTO,;
			   TRB->ZR_CF,.f.})
				
	aAdd(aColAux,{TRB->ZR_QTDE,;
				  TRB->ZR_PRECO,;
				  TRB->ZR_LOCAL,;
				  TRB->ZQ_CLIENTE,;
				  TRB->ZQ_LOJA,;
				  TRB->ZR_NFORI,;
				  TRB->ZR_SERIORI,;
				  TRB->ZR_ITEMORI,;
				  TRB->ZR_IDENTB6,;
				  TRB->ZR_LOTECTL,;
				  TRB->ZR_LOCALIZ,;
	  			  TRB->ZR_VOLUME ,;
  				  TRB->ZR_PESOL  ,;
    			  TRB->ZR_PESOB  ,;
    			  TRB->ZR_RECNO})
				
	TRB->(DbSkip())

ENDDO

	TRB->(DBGOTOP())

  	If (TRB->ZQ_TIPO$"N") //Pedido normal ou seja, VENDA               
      	SA1->(DbSeek(xFilial("SA1")+TRB->ZQ_CLIENTE+TRB->ZQ_LOJA))         
   	Else
      	SA2->(DbSeek(xFilial("SA2")+TRB->ZQ_CLIENTE+TRB->ZQ_LOJA))            
   	Endif
      
   	@ 0,0 To 500,800 Dialog DlgTes Title OemToAnsi("Arruma a TES")
   	//@ 005,008 To 90,260 
   	@ 010,010 Say OemToAnsi("Tipo do Pedido :")  Size 090,8
   	@ 010,050 Say IIf(TRB->ZQ_TIPO$"N","Venda",IIf(TRB->ZQ_TIPO$"D","Dev.Compra","Util.Fornecedor")) Size 70,8  object oTipo
    oTipo:Setfont(oFont12)                      

   	@ 020,010 Say IIf(TRB->ZQ_TIPO$"N","Cliente :","Fornecedor :")  Size 090,8   
   	@ 020,050 Say IIf(TRB->ZQ_TIPO$"N", SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME+ " ESTADO: "+SA1->A1_EST,SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME+ " ESTADO: "+SA1->A1_EST) Size 250,8      

   	@ 030,010 Say OemToAnsi("Obs: ") Size 45,8
   	@ 030,050 Get _cOBS Picture "@!" Size 190,8 Object oOBS

   	@ 040,010 Say _cUser Color CLR_HBLUE Object oUser             
    oUser:Setfont(oFont10)                      

/*
   @ 025,020 Say OemToAnsi("Produto :")  Size 090,8   
   @ 025,060 Say Alltrim(TRB->ZR_PRODUTO)+" - "+TRB->ZR_DESCRI Size 220,8      

  
   @ 050,020 Say OemToAnsi("Digite a TES ")   Size 45,8
   @ 050,060 Get _cTes   Picture "@!" F3 "SF4" Size 35,8 Valid fTes() Object oTes
   @ 050,100 Get _cDTes  Picture "@!" When .F. Size 150,8 Object oDTes
   @ 061,020 Say OemToAnsi("Digite o CFO ")   Size 45,8
   @ 060,060 Get _cCfo   Picture "@!" F3 "13" Size 35,8 Valid fCfo() Object oCfo
   @ 060,100 Get _cDCfo  Picture "@!" When .F. Size 150,8 Object oDCfo   
*/
	oGetD  := MsNewGetDados():New(055 ,10,230,395,3,{|| .T. },"AllwaysTrue()",/*+ITEM*/,,0,400,"AllwaysTrue()",'',"AllwaysTrue()",DlgTes,aHead,aCol)
	OGETD:LDELETE := .F.
	OGETD:NMAX := LEN(ACOL)

   	@ 235,350 BMPBUTTON TYPE 01 ACTION Close(DlgTes)
   	
   	Activate Dialog DlgTes Center


For xT:=1 to len(oGetD:aCols)
   
   	SB1->(DbSeek(xFilial("SB1")+oGetD:aCols[xT][1]))   

	aArr := {}
	
	aAdd(aArr,{"C6_FILIAL"  ,xFilial("SC6")     ,Nil}) // Filial
	aAdd(aArr,{"C6_ITEM"    ,StrZero(Len(aItemPV)+1,2) ,Nil})
	aAdd(aArr,{"C6_PRODUTO" ,oGetD:aCols[xT][1] ,Nil})
	aAdd(aArr,{"C6_DESCRI"  ,Alltrim(oGetD:aCols[xT][2]),Nil})
	aAdd(aArr,{"C6_NCM"     ,Iif(Empty(SB1->B1_POSIPI),"9999",SB1->B1_POSIPI) ,Nil})
	aAdd(aArr,{"C6_UM"      ,SB1->B1_UM		    ,Nil})
	aAdd(aArr,{"C6_QTDVEN"  ,aColAux[xT][1]     ,Nil})
	aAdd(aArr,{"C6_PRUNIT"  ,aColAux[xT][2]	    ,Nil})
	aAdd(aArr,{"C6_PRCVEN"  ,aColAux[xT][2]     ,Nil})
	aAdd(aArr,{"C6_VALOR"   ,aColAux[xT][1]*aColAux[xT][2] ,Nil})
	aAdd(aArr,{"C6_TES"     ,oGetD:aCols[xT][3] ,Nil})
	aAdd(aArr,{"C6_CFO"     ,oGetD:aCols[xT][4] ,Nil})
	aAdd(aArr,{"C6_LOCAL"   ,aColAux[xT][3]  	,Nil})
	aAdd(aArr,{"C6_ENTREG"  ,dDataBase 	     	,Nil})
	aAdd(aArr,{"C6_CLI"     ,aColAux[xT][4]  	,Nil})
	aAdd(aArr,{"C6_LOJA"    ,aColAux[xT][5]  	,Nil})
	aAdd(aArr,{"C6_NFORI"   ,aColAux[xT][6]  	,Nil})
	aAdd(aArr,{"C6_SERIORI" ,aColAux[xT][7]  	,Nil})
	aAdd(aArr,{"C6_ITEMORI" ,aColAux[xT][8]  	,Nil})
	aAdd(aArr,{"C6_IDENTB6" ,aColAux[xT][9]  	,Nil})

	If ALLTRIM(Posicione("SB1",1,xFilial("SB1")+oGetD:aCols[xT][1],"B1_LOCALIZ")) $ "S"
		aAdd(aArr,{"C6_LOCALIZ" ,aColAux[xT][11]  	,Nil})
	EndIf

	If ALLTRIM(Posicione("SB1",1,xFilial("SB1")+oGetD:aCols[xT][1],"B1_RASTRO" )) $ "L"
		aAdd(aArr,{"C6_LOTECTL" ,aColAux[xT][10] 	,Nil})
	EndIf
	
	Aadd(aItemPV, aArr)

	_nVolu += aColAux[xT][12]
	_nPl   += aColAux[xT][13]
	_nPb   += aColAux[xT][14]
	
	SZR->(Dbgoto(aColAux[xT][15])) // zr recno
	Reclock("SZR",.F.)
		SZR->ZR_PEDIDO  := "PEDIDO" //Marcação inicial para posterior gravação final na solicitação de NF
	MsUnlock("SZR")

next

If len(aItemPV) > 0 //Somente gera o pedido se tiver dados na matriz dos itens do pedido

//   _nItem      := aScan(aItemPV,{|x|UPPER(Alltrim(x[2])) == "C6_ITEM"})         
//     nI := Ascan(aItemPV, {|x| x[1]+x[3]+x[6] == TMP->D3_COD+TMP->D3_CARDEF+TMP->D3_DEFEITO+TMP->D3_LOCAL})
//   ARRUMAR O PESO

   Aadd(aCabPV, {"C5_VOLUME1" ,_nVolu   ,Nil}) // Filial
   Aadd(aCabPV, {"C5_PESOL" ,_nPl     ,Nil}) // Filial
   Aadd(aCabPV, {"C5_PBRUTO" ,_nPb     ,Nil}) // Filial   
   
   DbSelectArea("SC5")
   SC5->(DbSetOrder(1))
//   _nItem      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C6_ITEM"})         
   lMSErroAuto := .F.
   lMSHelpAuto := .F.
                                      
   SB6->(DbSetOrder(6))//filial + doc + serie + ident + produto + clifor + loja
   //Retira a qtde de empenho no B6_QULIB, pois senão retirar da erro na geração automatica do pedido
   For _nx:=1 to Len(aItemPV) 
	  If SB6->(DbSeek(xFilial("SB6")+aItemPV[_nx][16][2]+aItemPV[_nx][17][2]+aItemPV[_nx][19][2]+aItemPV[_nx][3][2],Found()))
 //	       ALERT(" ENCONTREI O SB6")
  			Reclock("SB6",.F.)                                                          
  			   SB6->B6_QULIB-=aItemPV[_nx][7][2] //Diminui qtde liberada na Solicitação da NF no poder de terceiro
  		    MsUnlock("SB6")  			    
//	       ALERT(" DIMINUI O SB6")  		    
	  Endif   
   Next _nx
   
   //Matriz aItemPV Carrega produtos não acabados   
   Processa( {|| MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)  },"Aguarde Gerando Pedido ....")
   If lMsErroAuto
      TRB->(DbCloseArea())                  
      Mostraerro()
      DisarmTransaction()
       break
   Endif
   If !lMSErroAuto
      TRB->(Dbgotop())                                                              

      While (!TRB->(Eof()))    
      
         SZR->(Dbgoto(TRB->ZR_RECNO))
         If SZR->ZR_PEDIDO$"PEDIDO" 
            Reclock("SZR",.F.)   
               SZR->ZR_PEDIDO  := SC5->C5_NUM //numero do pedido gerado pela solicitação de NF
	        MsUnlock("SZR") 
	     Endif   
	     
         TRB->(Dbskip())
      Enddo
      
      MsgBox('Pedido '+SC5->C5_NUM+' Gerado com Sucesso!','Gera Pedido de Venda','INFO')
   Endif
Endif             

If !lMSErroAuto
   //Fecha a solicitação de NF
   SZQ->(Dbgoto(_nRecno))
   Reclock("SZQ",.F.)   
      SZQ->ZQ_STATUS := "S" //Controle para fechar a solicitação de NF
   MsUnlock("SZQ") 
Endif   

If Select("TRB") > 0 //verifica se o alias esta aberto
//    alert(" alias aberto ")
   TRB->(DbCloseArea())
Endif   

/*
MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.T.,.T.,.F.,.T.,,)
// Geracao de SC9 Liberacao do Pedido / Item
Parametros³ExpN1: Registro do SC6                                      ³±±
±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
±±³          ³       apenas avalia ).                                     ³±±
±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
*/ 

Return(.t.)

User function FAT15Tes()
Local lRet := .F.
                                          
   If SF4->(DbSeek(xFilial("SF4")+M->ZR_TES))
      oGetD:aCols[oGetD:nAt][GdFieldPos("F4_TEXTO",oGetd:aHeader)] := SF4->F4_TEXTO
      oGetD:aCols[oGetD:nAt][GdFieldPos("ZR_CF",oGetd:aHeader)] := SF4->F4_CF
      
      //_cCFO := SF4->F4_CF
      //_cDTes:= SF4->F4_TEXTO
      lRet := .T.
   Else
      oGetD:aCols[oGetD:nAt][GdFieldPos("F4_TEXTO",oGetd:aHeader)] := SPACE(30)
      oGetD:aCols[oGetD:nAt][GdFieldPos("ZR_CF",oGetd:aHeader)] := space(03)
      
      //_cCFO := Space(03)
      //_cDTes:= Space(30)
      lRet := .F.
   Endif
   //oCFO :Refresh()                    
   //oDTes:Refresh()   
   oGetD:Refresh()

Return(lRet)

User Function FAT15Cfo()
Local lRet := .F.

SX5->(Dbgotop())       
SX5->(DbSetOrder(1)) //filial+cod
SX5->(DbSeek(xFilial("SX5")+"13")) //tabelas de CFO´S
While SX5->(!Eof()) .And. SX5->X5_TABELA == '13' 
   If Subs(SX5->X5_CHAVE,1,4)== Subs(M->ZR_CF,1,4)
      //_cDCfo := SX5->X5_DESCRI
      //oDCfo:Refresh()                  
      lRet := .T.
      Exit //
   Endif                       
   SX5->(Dbskip())
Enddo

IF !lRet
	Alert("CFO não encontrada!")
Endif
                     
Return(lRet)