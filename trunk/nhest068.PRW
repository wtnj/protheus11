/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST068  ³ Autor ³ Alexandre R. Bento     Data ³ 27/02/06 ³±±
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

User Function nhest068()

SetPrvt("CCADASTRO,AROTINA,")

//axcadastro("SZQ","SZQ")
//axcadastro("SZR","SZR")

cCadastro := OemToAnsi("Gera Pedido de Nota Fiscal de Saida")
aRotina := {{ "Pesquisa","AxPesqui"     ,  0 , 1},;
            { "Visualizacao",'U_fGpedido()', 0 , 2},;
            { "Gera Pedido" ,'U_fGerPed()' , 0,3},;
            { "Legenda" ,"U_FLegPed",0,2}}     

//           { "Exclui"   ,'U_NHEST039(5)',0 , 4},;       
//           { "Imprimir" ,'U_NHEST039(6)',0 , 5},;              
//           { "Frete/Entrega" ,'U_NHEST039(9)',0 , 5},; 
            
mBrowse( 6, 1,22,75,"SZQ",,,,,,fCriaCor())

Return


User Function fGPedido()

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog")  
SetPrvt("_cDoc,_aTipoN,_cTipon,_cCond,_cCli, _cLoja,_cTpFre,_nPLiqui,_nPBruto,_nVol,_cEsp,_cMens,_cDesCli,_cF3")
SetPrvt("_cCliFor,_cTiFre,_aTiFre,_cObs,_dData,_cHora,_cPar")

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  

lDialog := .F.               
_cDoc   := Space(06)
_aTipon := {"Venda",OemToAnsi("Dev.Compra"),"Util.Fornecedor"}
_aTiFre := {"C=CIF","F=FOB"}
_cTiFre := ""
_cTipon := "Venda"   
_cCliFor:= "Cliente:"
_cCond  := Space(03)
_cCli   := Space(06)
_cLoja  := Space(02) 
_cDesCli:= Space(30) 
_cTpFre := Space(10)  
_nPLiqui:= 0          
_nPBruto:= 0
_nVol   := 0
_cEsp   := "VOL"
_cMens  := Space(100) 
_cObs   := Space(100) 
_cF3    := Space(03)        
aHeader := {}        
aCols   := {}

_dData   := date()
_cHora   := time()   
 nMax    := 0                                                       

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(MsSeek("SZR"))
While ( !SX3->(Eof()) .And. (SX3->X3_ARQUIVO == "SZR") )
    
   If ( X3USO(SX3->X3_USADO) .And.;
			!(	Trim(SX3->X3_CAMPO) == "ZR_NUM" ) 	.And.;
			Trim(SX3->X3_CAMPO) <> "ZR_EMISSAO" 	.And.;
			Trim(SX3->X3_CAMPO) <> "ZR_PEDIDO" 	.And.;			
			Trim(SX3->X3_CAMPO) <> "ZR_FILIAL" )
			dbSelectArea("SZR")
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
   Endif
   SX3->(dbSkip())
EndDo

//fQuery()   
Processa( {|| fQuery() },"Selecionando Dados")

Define MsDialog oDialog Title OemToAnsi("Solicitação de Nota Fiscal de Saida") From 010,030 To 458,860 Pixel 
@ 013,007 To 090,410 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8            
@ 027,030 Say _cDoc Size 035,10 Object oDoc            
 oDoc:Setfont(oFont)                      
@ 027,090 Say "Tipo Nota:" Size 30,8          
@ 027,118 say  _cTipon SIZE 55,10 object oTipon
oTipon:Setfont(oFont)                         
@ 027,190 Say "Cond. Pgto:" Size 30,8            
@ 025,225 Get _cCond Picture "@!" When(.F.) F3 "SE4" Size 25,8 Object oCond           
@ 027,280 Say "Data:" Size 30,8            
@ 025,295 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 027,350 Say "Hora:" Size 30,8            
@ 025,365 Get _cHora Picture "99:99:99" When .F. Size 25,8 Object oHora              
@ 040,010 Say _cClifor Size 040,8 Object oCliFor               
@ 038,040 Get _cCli Picture "@!"  When(.F.) Size 30,8  Object oCli            
@ 038,072 Get _cLoja Picture "@!"  When(.F.) Size 10,8 Object oLoja            
@ 038,090 Get _cDesCli Picture "@!" When .F. Size 160,8 Object oDesCli            
@ 040,265 Say "Tipo Frete:" Size 030,8 object oTpFrete           
@ 040,295 say  _cTiFre SIZE 35,10 object oTiFre
oTiFre:Setfont(oFont)                            
@ 053,010 Say "Peso Liq.:" Size 050,8 object oPesoL  
@ 051,040 Get _nPLiqui Picture "@E 999,999.99" When(.F.) Size 40,8 Object oPLiqui             
@ 053,100 Say OemToAnsi("Peso Bruto:") Size 050,8                    
@ 051,130 Get _nPBruto Picture "@E 999,999.99" When(.F.) Size 050,8  Object oPbruto
@ 053,200 Say OemToAnsi("Volume :") Size 050,8
@ 051,225 Get _nVol Picture "@E 99999" When(.F.) Size 025,8 Object oVol                                 
@ 053,290 Say "Especie :"  Size 050,8            
@ 051,315 Get _cEsp  Picture "@!" When(.F.) Size 40,8 Object oEsp             
@ 065,010 Say "Mensagem:"   Size 040,8                    
@ 063,040 Get _cMens Picture "@!" When(.F.) Size 315,8 Object oMens          
@ 077,010 Say OemToAnsi("Observação:")   Size 040,8                    
@ 075,040 Get _cObs Picture "@!" When(.F.) Size 315,8 Object oObs          

@ 095,006 To 200,410 Title OemToAnsi("  Informações ")  
@ 105,006 TO 190,410 MULTILINE MODIFY OBJECT oMultiline
@ 205,285 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 205,350 BMPBUTTON TYPE 02 ACTION fEnd() 
oTipon:bChange:={|| fCli() }
oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog oDialog Center Valid fDialog()
SZR->(DbCloseArea())
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

   
MemoWrit('C:\TEMP\EST062A.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","ZQ_EMISSAO","D")  // Muda a data de string para date    
DbSelectArea("TMP")
TMP->(DBGOTOP())
If Empty(TMP->ZQ_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
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
//ObjectMethod(oDesCli,"Refresh()")

_dData    := Dtoc(TMP->ZQ_EMISSAO) 
_cTiFre   := Iif(Alltrim(TMP->ZQ_TIPOFRE)=="C","CIF","FOB")
_nPBbruto := TMP->ZQ_PESOB 
_nPLiqui  := TMP->ZQ_PESOL   
_nVol	  := TMP->ZQ_VOLUME  
_cEsp     := TMP->ZQ_ESPECIE 
_cCond	  := TMP->ZQ_CONDPG 
_cMens    := TMP->ZQ_MENS 
_cObs     := TMP->ZQ_OBS   
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

Static Function fRetF3()

If(_ctipon$"Venda")  
   _cF3:= "SA1" //Cadastro de Cliente
//   _cCliFor:= "Cliente:"
else //IF (_ctipon$"Dev.Compra/Util.") 
   _cF3:= "SA2" // Cadastro de fornecedores

endif
//ObjectMethod(oCliFor,"SetText(_cCliFor)")
// oCliFor:Refresh()                
//ObjectMethod(oCliFor,"Refresh()")
//DlgRefresh(oDialog)
return(_cF3) 


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

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

BrwLegenda(OemToAnsi("Solicitação de Nota Fiscal"), "Legenda", aLegenda)

Return  

Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZQ_STATUS = " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZQ_STATUS <> " "', aLegenda[2][1] } )
Return(uRetorno)


User Function fGerPed()
Local cQuery1                          
Local _cCFO     := Space(05) 
Local _cEst     := GetMv("MV_ESTADO")
Private aCabPV  := {}
Private aReg    := {}					
Private aItemPV := {}


cQuery1 := "SELECT * "
cQuery1 += "FROM " +  RetSqlName( 'SZQ' ) +" SZQ, " +  RetSqlName( 'SZR' ) +" SZR "
cQuery1 += "WHERE SZQ.ZQ_FILIAL = '" + xFilial("SZQ")+ "'"    
cQuery1 += "AND SZR.ZR_FILIAL = '" + xFilial("SZR")+ "'"    
cQuery1 += "AND SZR.D_E_L_E_T_ = ' ' "
cQuery1 += "AND SZQ.D_E_L_E_T_ = ' ' "
cQuery1 += "AND SZQ.ZQ_NUM = SZR.ZR_NUM "
cQuery1 += "AND SZQ.ZQ_EMISSAO = SZR.ZR_EMISSAO "
cQuery1 += "AND SZR.ZR_PEDIDO = ' ' AND SZQ.ZQ_STATUS = ' ' " 
cQuery1 += "AND SZQ.ZQ_NUM BETWEEN '" + SZQ->ZQ_NUM + "' AND '" + SZQ->ZQ_NUM + "' "                                                                                                           
cQuery1 += "order by SZR.ZR_NUM,SZR.ZR_ITEM"

   
MemoWrit('C:\TEMP\EST068.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery1 NEW ALIAS "TRB"      
TcSetField("TRB","ZQ_EMISSAO","D")  // Muda a data de string para date    
DbSelectArea("TRB")
TRB->(DBGOTOP())
If Empty(TRB->ZQ_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   return
Endif    

If !Empty(TRB->ZQ_STATUS)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Atenção Para Esta Solicitação ja foi Gerado Pedido, Verifique !!!" ,"Atencao","ALERT" )     
   return
Endif    

//Cabecalho
   aCabPV:={}
   /*
   AAdd(aCabPV,{"C5_FILIAL"  ,xFilial("SC5")    ,Nil}) // Filial
   AAdd(aCabPV,{"C5_NUM"     ,"987777"          ,Nil})   
   AAdd(aCabPV,{"C5_CLIENTE" ,TRB->ZQ_CLIENTE   ,Nil}) // Codigo do cliente  				    
   AAdd(aCabPV,{"C5_LOJACLI" ,TRB->ZQ_LOJA      ,Nil}) // Loja do cliente
   AAdd(aCabPV,{"C5_CLIENT"  ,TRB->ZQ_CLIENTE   ,Nil}) // Codigo do cliente  				       
   AAdd(aCabPV,{"C5_LOJAENT" ,TRB->ZQ_LOJA      ,Nil}) // Loja para entrada
   AAdd(aCabPV,{"C5_CONDPAG" ,TRB->ZQ_CONDPG    ,Nil}) // Codigo da condicao de pagamanto*
   AAdd(aCabPV,{"C5_TIPOCLI" ,TRB->ZQ_TIPOCLI      ,Nil}) // TIPO DO CLIENTE
   AAdd(aCabPV,{"C5_TIPO"    ,TRB->ZQ_TIPO      ,Nil}) // Tipo de pedido (REMESSA PRA TROCA)
   AAdd(aCabPV,{"C5_MENNOTA" ,TRB->ZQ_MENS      ,Nil}) // Mensagem da nota
   AAdd(aCabPV,{"C5_LIBEROK" ,"S"               ,Nil}) // Liberacao Total
   AAdd(aCabPV,{"C5_TIPLIB"  ,"2"               ,Nil}) // Tipo de Liberacao
   AAdd(aCabPV,{"C5_EMISSAO"  ,dDataBase        ,Nil}) // Tipo de Liberacao
*/

//   AAdd(aCabPV,{"C5_NUM"     ,"987777"          ,Nil})   
   AAdd(aCabPV,{"C5_CLIENTE" ,"900001"   ,Nil}) // Codigo do cliente  				    
   AAdd(aCabPV,{"C5_LOJACLI" ,"03"      ,Nil}) // Loja do cliente
   AAdd(aCabPV,{"C5_CLIENT"  ,"900001"   ,Nil}) // Codigo do cliente  				       
   AAdd(aCabPV,{"C5_LOJAENT" ,"01"      ,Nil}) // Loja para entrada
   AAdd(aCabPV,{"C5_CONDPAG" ,"APR"    ,Nil}) // Codigo da condicao de pagamanto*
   AAdd(aCabPV,{"C5_TIPOCLI" ,"F"      ,Nil}) // TIPO DO CLIENTE
   AAdd(aCabPV,{"C5_TIPO"    ,"N"      ,Nil}) // Tipo de pedido (REMESSA PRA TROCA)
   AAdd(aCabPV,{"C5_MENNOTA" ,"OLA"    ,Nil}) // Mensagem da nota
   AAdd(aCabPV,{"C5_LIBEROK" ,"S"               ,Nil}) // Liberacao Total
   AAdd(aCabPV,{"C5_TIPLIB"  ,"2"               ,Nil}) // Tipo de Liberacao
   AAdd(aCabPV,{"C5_EMISSAO"  ,dDataBase        ,Nil}) // Tipo de Liberacao

SB1->(DbSetOrder(1))
SA1->(DbSetOrder(1))   
SA2->(DbSetOrder(1))
SF4->(DbSetOrder(1))
//While (!TRB->(Eof()))
                 
   SB1->(DbSeek(xFilial("SB1")+TRB->ZR_PRODUTO))
   SF4->(DbSeek(xFilial("SF4")+SB1->B1_TS,.T.))


   If (TRB->ZQ_TIPO$"N") //Pedido normal ou seja, VENDA
      SA1->(DbSeek(xFilial("SA1")+TRB->ZQ_CLIENTE+TRB->ZQ_LOJA))
      _cMoeda := SA1->A1_MOEDA                               
      _cCFO := Iif(TRB->ZQ_TIPOCLI!="X",If(SA1->A1_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))
   Else                    
      SA2->(DbSeek(xFilial("SA2")+TRB->ZQ_CLIENTE+TRB->ZQ_LOJA))
      _cDesCli := SA2->A2_NOME                               
      _cCFO := Iif(TRB->ZQ_TIPOCLI!="X",If(SA2->A2_EST==_cEst,"5"+substr(SF4->F4_CF,2,3),"6"+Subs(SF4->F4_CF,2,3)),"7"+Subs(SF4->F4_CF,2,3))         
   Endif    
   
   aReg:= {}                                       
 /*AAdd(aReg, {"C6_NUM","987777"             ,Nil})
   AAdd(aReg, {"C6_ITEM",TRB->ZR_ITEM        ,Nil})
   AAdd(aReg, {"C6_PRODUTO",TRB->ZR_PRODUTO  ,Nil})
   AAdd(aReg, {"C6_UM"     ,SB1->B1_UM       ,Nil})
   AAdd(aReg, {"C6_QTDVEN" ,TRB->ZR_QTDE     ,Nil})
   AAdd(aReg, {"C6_PRCVEN" ,TRB->ZR_PRECO    ,Nil})
   AAdd(aReg, {"C6_VALOR"  ,TRB->ZR_TOTAL    ,Nil})
   AAdd(aReg, {"C6_QTDLIB" ,TRB->ZR_QTDE     ,Nil})
   AAdd(aReg, {"C6_TES"    ,SB1->B1_TS       ,Nil})
   AAdd(aReg, {"C6_CF"     ,_cCFO            ,Nil}) 
   AAdd(aReg, {"C6_LOCAL"  ,TRB->ZR_LOCAL    ,Nil})
   AAdd(aReg, {"C6_QTDEMP" ,TRB->ZR_QTDE     ,Nil})
   AAdd(aReg, {"C6_CLI"    ,TRB->ZQ_CLIENTE  ,Nil})
   AAdd(aReg, {"C6_ENTREG" ,dDataBase        ,Nil})
   AAdd(aReg, {"C6_LOJA"   ,TRB->ZQ_LOJA     ,Nil})
   AAdd(aReg, {"C6_PRUNIT" ,TRB->ZR_PRECO    ,Nil})
   AAdd(aReg, {"C6_OP"     ,Iif(Subs(TRB->ZR_PRODUTO,6,1) =="4","02",""),Nil})
*/
  // AAdd(aReg, {"C6_NUM","987777"             ,Nil})
   AAdd(aReg, {"C6_ITEM",   "01"        ,Nil})
   AAdd(aReg, {"C6_PRODUTO","VW01.4.183.00"  ,Nil})
   AAdd(aReg, {"C6_UM"     ,"PC"        ,Nil})
   AAdd(aReg, {"C6_QTDVEN" ,100         ,Nil})
   AAdd(aReg, {"C6_PRCVEN" ,2           ,Nil})
   AAdd(aReg, {"C6_VALOR"  ,1000        ,Nil})
   AAdd(aReg, {"C6_QTDLIB" ,100         ,Nil})
   AAdd(aReg, {"C6_TES"    ,"613"       ,Nil})
   AAdd(aReg, {"C6_CF"     ,"6124"      ,Nil}) 
   AAdd(aReg, {"C6_LOCAL"  ,"04"        ,Nil})
   AAdd(aReg, {"C6_QTDEMP" ,100         ,Nil})
   AAdd(aReg, {"C6_CLI"    ,"900001"    ,Nil})
   AAdd(aReg, {"C6_ENTREG" ,dDataBase        ,Nil})
   AAdd(aReg, {"C6_LOJA"   ,"01"     ,Nil})
   AAdd(aReg, {"C6_PRUNIT" ,2        ,Nil})
//   AAdd(aReg, {"C6_OP"     ,Iif(Subs(TRB->ZR_PRODUTO,6,1) =="4","02",""),Nil})

   aAdd(aItemPV,aReg)			

//   TRB->(DbSkip())
//Enddo

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
        
lMSErroAuto := .F.
lMSHelpAuto := .F.

Begin Transaction

   MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)
   If lMsErroAuto
   	  Mostraerro()
	  DisarmTransaction()
	  break
   Endif

End Transaction

If !lMSErroAuto
   LibCred(SC5->C5_NUM)
   MsgBox('Pedido '+SC5->C5_NUM+' Gerado com Sucesso!','Gera Pedido de Venda','INFO')
Endif
TRB->(DbCloseArea())
Return .t.



//****************************************************************************************************
/*
For nArqXml := 1 To Len(_aItems)            

	

		cOcorrencia := StrZero(Val(oXML:_Ocorrencia:_CabDaOcorrencia[1]:_OC_COD:TEXT))

		//Cabecalho
		aCabPV:={}
		AAdd(aCabPV,{"C5_FILIAL"  ,"01"        ,Nil}) // Filial
		AAdd(aCabPV,{"C5_CLIENTE" ,cCodCli	   ,Nil}) // Codigo do cliente  				    
		AAdd(aCabPV,{"C5_LOJACLI" ,"01"        ,Nil}) // Loja do cliente
		AAdd(aCabPV,{"C5_LOJAENT" ,"01"        ,Nil}) // Loja para entrada
		AAdd(aCabPV,{"C5_CONDPAG" ,SA1->A1_COND,Nil}) // Codigo da condicao de pagamanto*
		AAdd(aCabPV,{"C5_TIPOCLI" ,SA1->A1_TIPO,Nil}) // TIPO DO CLIENTE
		AAdd(aCabPV,{"C5_TIPO"    ,"N"         ,Nil}) // Tipo de pedido (REMESSA PRA TROCA)
		AAdd(aCabPV,{"C5_REQCLI"  ,cArqXml		,Nil}) // nOME DO ARQUIVO
//		AAdd(aCabPV,{"C5_MENNOTA" ,"Oc.: " + cOcorrencia + " REF N/NOTA FISCAL "+oXML:_Ocorrencia:_CabDaOcorrencia[1]:_OC_NF:TEXT+" - " + oXML:_Ocorrencia:_CabDaOcorrencia[1]:_TO_DESC:TEXT,Nil}) // TIPO DO CLIENTE 				 
		AAdd(aCabPV,{"C5_MENNOTA" ,"TESTESTESTESTESTES   Oc.: " + cOcorrencia + " REF N/NOTA FISCAL "+oXML:_Ocorrencia:_CabDaOcorrencia[1]:_OC_NF:TEXT+" - " + oXML:_Ocorrencia:_CabDaOcorrencia[1]:_TO_DESC:TEXT,Nil}) // TIPO DO CLIENTE 				 
		AAdd(aCabPV,{"C5_LIBEROK" ,"S"         ,Nil}) // Liberacao Total
		AAdd(aCabPV,{"C5_TIPLIB"  ,"2"         ,Nil}) // Tipo de Liberacao

		nTotL := len(oXML:_Ocorrencia:_ItensDaOcorrencia)
		For nL := 1 to nTotL
            aReg := {}
			_cPrdes := Posicione('SB1',1,xFilial('SB1')+RTRIM((oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_PRODUTO:TEXT)),'B1_DESC')

			AAdd(aReg, {"C6_ITEM",StrZero(nL,2),Nil})
			AAdd(aReg, {"C6_PRODUTO",SB1->B1_COD,Nil})
			AAdd(aReg, {"C6_UM"     ,(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_UN:TEXT),Nil})
			AAdd(aReg, {"C6_QTDVEN" ,(Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_QTDE:TEXT)),Nil})
			AAdd(aReg, {"C6_PRCVEN" ,(Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_PRECO:TEXT)),Nil})
			AAdd(aReg, {"C6_VALOR"  ,(Round((Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_QTDE:TEXT)*Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_PRECO:TEXT)),2)),Nil})
			AAdd(aReg, {"C6_QTDLIB" ,Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_QTDE:TEXT),Nil})
			AAdd(aReg, {"C6_TES"    ,(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_TO_TESSAIDA:TEXT),Nil})
			AAdd(aReg, {"C6_CF"     ,_cCFO,Nil})
			AAdd(aReg, {"C6_LOCAL"  ,"01"              ,Nil})
			AAdd(aReg, {"C6_QTDEMP" ,Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_QTDE:TEXT),Nil})
			AAdd(aReg, {"C6_CLI"    ,cCodCli,Nil})
			AAdd(aReg, {"C6_ENTREG" ,dDataBase         ,Nil})
			AAdd(aReg, {"C6_LOJA"   ,"01"              ,Nil})
			AAdd(aReg, {"C6_NFORI"   ,(oXML:_Ocorrencia:_CabDaOcorrencia[1]:_OC_NF:TEXT),Nil})
			AAdd(aReg, {"C6_SERIORI"  ,(oXML:_Ocorrencia:_CabDaOcorrencia[1]:_OC_NFSERIE:TEXT),Nil})
			AAdd(aReg, {"C6_PRUNIT" ,(Val(oXML:_Ocorrencia:_ItensDaOcorrencia[nL]:_OI_PRECO:TEXT)),Nil})
			AAdd(aReg, {"C6_OP"     ,"02"              ,Nil})

			aAdd(aItemPV,aReg)			

		Next nL

        dbSelectArea("SC5")
        dbSetOrder(1)
        
        
		lMSErroAuto := .F.
		lMSHelpAuto := .F.

Begin Transaction

		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)

		If lMsErroAuto
			Mostraerro()
			DisarmTransaction()
	          break
	  	Endif

End Transaction

		If !lMSErroAuto
			LibCred(SC5->C5_NUM)
			MsgBox('Pedido '+SC5->C5_NUM+' Gerado com Sucesso!','Gera Pedido de Venda','INFO')
			FERase(cArqXml)
		Endif
    Endif
Next nArqXml
Return .t.


  */
                                           
