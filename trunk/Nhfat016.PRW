  /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHFAT016  ³ Autor ³ Alexandre R. Bento     Data ³ 10/04/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Pedido do Cliente                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Comercial                                                  ³±±
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
#include "protheus.ch"

User Function nhfat016()
AXCADASTRO("SZS","SZS")
SetPrvt("CCADASTRO,AROTINA,")

//axcadastro("SZQ","SZQ")
//axcadastro("SZR","SZR")
//axcadastro("SZS","SZS")

cCadastro := OemToAnsi("Controle de Pedido do Cliente")
aRotina := {{ "Pesquisa","AxPesqui"     , 0, 1},;
            { "Visualizacao",'U_fPed(2)', 0, 2},;
            { "Inclui"   ,'U_fPed(3)'   , 0, 3},;
            { "Altera"   ,'U_fPed(5)'   , 0, 5},;            
            { "Exclui"   ,'U_fPed(4)'   , 0, 4},;                   
            { "Legenda" ,"U_FLegPe"     , 0, 2}}     

//           { "Exclui"   ,'U_NHEST039(5)',0 , 4},;       
//           { "Imprimir" ,'U_NHEST039(6)',0 , 5},;              
//           { "Frete/Entrega" ,'U_NHEST039(9)',0 , 5},; 
            
mBrowse( 6, 1,22,75,"SZS",,,,,,fCriaCor())
//TMP->(DbCloseArea())
Return


User Function fPed(cPar01)
Local oQtde 
SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser,_lFlag,_cUser,_aF4,_nF4,cQuery1")
SetPrvt("_cDoc,_aTipoN,_cTipon,_cCond,_cCli, _cLoja,_cTpFre,_nPLiqui,_nPBruto,_nVol,_cEsp,_cMens,_cDesCli,_cF3")
SetPrvt("_cCliFor,_cNumPe,_cObs,_dData,_cHora,_cPar,_lExc,_cTpCli,_nMoeda,_aVia, _cVia,_cCodPro,_cDesPro,VK_F4")
SetPrvt("_cNumPe,_cEnce,_aEnce,_dValid,_dInicio,_nQtde,_nQtdeEn,_nSaldo,_nQtdeDe,odInicio,odValid,ocEnce,_cPgto")
SetPrvt("_nPreco, _cCodFor,_cCodCli,oPreco,oPgto")

DEFINE FONT oFont NAME "Arial" SIZE 10, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10

odInicio := NIL
oDialog  := NIL
odValid  := NIL
ocEnce   := NIL
oPreco   := NIL
oPgto    := NIL

_cPar    := cPar01
_cDoc    := Space(06)
_aTipoP  := {"Aberto",OemToAnsi("Fechado")}
_cNumPe  := Space(15)
//_aVia   := {"Aereo","Correio","Maritimo",OemToAnsi("Rodoviario")}
//_cVia   := "Rodoviario"
_cCodPro := Space(15)
_cDesPro := Space(30)
_cTipoP  := "Aberto"   
_cCliFor := "Cliente:"
_cCond   := Space(03)
_cCli    := Space(06)
_cLoja   := Space(02) 
_cDesCli := Space(30) 
_cUser   := Space(06)
_cPgto   := Space(03)              
 _cCodFor:= Space(10)
 _cCodCli:= Space(15)

_nPreco  :=0
_nQtde   :=0
_nQtdeEn :=0
_nSaldo  :=0
_nQtdeDe :=0 

_cNumPe  := Space(15)
_aEnce   := {"Sim",OemToAnsi("Não")}
_cEnce   := OemToAnsi("Não")
_dValid  := Ctod('  /  /  ')                  
_dInicio := Ctod('  /  /  ')
_nPLiqui := 0          
_nPBruto := 0
_nVol    := 0
_cEsp    := "VOL"
_cMens   := Space(100) 
_cObs    := Space(100) 
_cF3     := Space(03)        
_cTpCli  := Space(01)
_nMoeda  := 1

_dData   := date()
_cHora   := time()   
 nMax    := 0                                                       
_lExc    := .F. // Controle para não excluir
_lFlag   := .T.
IF cPar01 == 2 .or. cPar01 == 4 .or. cPar01 == 5 //excluir
   
   If cPar01 == 5//alteracao
      _cPar   :=  5 // visualização
   Elseif _cPar ==  2 // visualização   
      _cPar   :=  2 // visualização
   Else
      _cPar   :=  4 // visualização e exclusao   
      _lExc   := .T. // Controle para não excluir
   Endif  

   lDialog := .T.               
  
   _cDoc   := SZS->ZS_NUM     
   _cCli   := SZS->ZS_CLIENTE 
   _cLoja  := SZS->ZS_LOJA    
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
      _cDesCli := SA1->A1_NOME
   Endif

   _cCodPro := SZS->ZS_PRODUTO 
   SB1->(DbSetOrder(1))
   If SB1->(DbSeek(xFilial("SB1")+SZS->ZS_PRODUTO,Found()))
      _cDesPro := SB1->B1_DESC   
   Endif                                                     

   If SZS->ZS_TIPO$"A"
     _cTipoP  := "Aberto"
   Else
     _cTipoP  := "Fechado"
   Endif    
   _dData   :=  SZS->ZS_EMISSAO 
   _cHora	:=  SZS->ZS_HORA    
   _cNumPe  :=  SZS->ZS_PEDCLI  
   _nQtde   :=  SZS->ZS_QUANT   
   _nQtdeEn :=  SZS->ZS_QUJE    
   _nSaldo	:=  SZS->ZS_SALDO   

   IF SZS->ZS_ENCERRA$"S" 
     _cEnce := OemToAnsi("Sim")
   Else   
     _cEnce := OemToAnsi("Não")
   Endif
   _dValid  :=  Dtoc(SZS->ZS_DTVALID) 
   _dInicio :=  Dtoc(SZS->ZS_DTINICI)
   _nQtdeDe :=  SZS->ZS_QTDEDEV 
   _cObs    :=  SZS->ZS_OBS     
   __cUserId:=  SZS->ZS_USER    
   _nPreco  :=  SZS->ZS_PRECO
   _cCodCli :=  SZS->ZS_CODCLI 
   _cPgto   :=  SZS->ZS_COND 
   _cCodFor	:=	SZS->ZS_CODFOR 
  
Else
  _cPar   := cPar01 // receber visualizaçao ou impressao      
  lDialog := .F.               
Endif

If _cPar == 3

   DbSelectArea("SZS")
   _cDoc       := GetSXENum("SZS","ZS_NUM")   // Traz o novo numero da solicitação de NF
   _cUser := "Solicitante:  " + UsrFullname(__cUserId )
   
Endif         

   
Define MsDialog oDialog Title OemToAnsi("Controle de Pedido do Cliente") From 010,030 To 270,800 Pixel 
@ 013,007 To 0105,380 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,10 Object oNum
@ 027,032 Say _cDoc Size 035,12 Object oDoc            
  oDoc:Setfont(oFont)                        
  
@ 027,080 Say "Tipo Pedido:" Size 30,8 Object oTP
If _cpar == 3 .Or. _cPar == 5                      
   @ 025,115 COMBOBOX _cTipoP ITEMS _aTipoP SIZE 40,10 object oTipoP
Else
   @ 027,116 say  _cTipoP SIZE 50,10 object oTipoP
   oTipoP:Setfont(oFont)                         
Endif

@ 027,180 Say "Cond.Pgto:" Size 30,8 object oPg    
If _cpar == 3 .Or. _cPar == 5                                                  
   @ 025,210 Get _cPgto Picture "@!" F3 "SE4" Size 25,8 Object oPgto           
Else
   @ 027,211 Say _cPgto Size 25,8 Object oPgto   
   oPgto:Setfont(oFont)                                    
Endif   

@ 027,255 Say "Data:" Size 30,8 object oDt                                
@ 025,270 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 027,325 Say "Hora:" Size 30,8 object oHr            
@ 025,340 Get _cHora Picture "99:99:99" When .F. Size 30,8 Object oHora              
@ 040,010 Say _cClifor Size 040,8 Object oCliFor               
@ 038,040 Get _cCli Picture "@!"  When(_cPar == 3) F3 "SA1" Size 30,8 Object oCli            
@ 038,072 Get _cLoja Picture "@!"  When(_cPar == 3) Size 10,8 valid fLoja() Object oLoja            
@ 038,090 Get _cDesCli Picture "@!" When .F. Size 100,8 Object oDesCli            

@ 040,200 Say "Produto :" Size 050,8 object oProd
@ 038,220 Get _cCodPro Size 50,8 F3 "SB1" When(_cPar == 3) Valid fProdu() object oCodPro
@ 038,272 Get _cDesPro Size 103,8 When(.F.) object oDesPro
//-----------------------
@ 053,010 Say OemToAnsi("Preço") Size 030,8 object oPrecop
If _cpar == 3 .Or. _cPar == 5                                                  
   @ 051,040 get _nPreco Picture "@E 999,999,999.999" SIZE 50,10 object oPreco 
Else
   @ 053,042 Get _nPreco Picture "@E 999,999,999.999"  When .F. SIZE 50,10 object oPreco
//      oPreco:Setfont(oFont)                         
Endif

@ 053,120 Say "Cod. WHB no Cliente:" Size 060,8 object oIni           
If _cpar == 3                      
   @ 051,173 get _cCodFor SIZE 60,10 object ocCofFor
Else
   @ 053,172 say  _cCodFor SIZE 60,10 object oCodfor
//   odInicio:Setfont(oFont)                         
Endif

@ 053,270 Say "Cod. Prod. Cliente:" Size 060,8 object oCodCli
If _cpar == 3                      
   @ 051,320 get _cCodCli SIZE 55,10 object oCodClie 
Else
   @ 053,317 say _cCodCli SIZE 55,10 object oCodCli
//     odValid:Setfont(oFont)                         
Endif    

//-----------------------
@ 065,010 Say "Num. Pedido" Size 050,8 object oNumPed
If _cpar == 3                      
   @ 063,040 get _cNumPe SIZE 50,10 object oNumPe 
Else
   @ 065,042 say  _cNumPe SIZE 55,10 object oNumPe
     oNumPe:Setfont(oFont)                         
Endif


@ 065,120 Say "Data Inicio:" Size 040,8 object oIni           
If _cpar == 3                      
   @ 063,150 get _dInicio SIZE 45,10 object odInicio 
Else
   @ 065,149 say  _dInicio SIZE 45,10 object odInicio
   odInicio:Setfont(oFont)                         
Endif


@ 065,227 Say "Validade:" Size 040,8 object oValid           
If _cpar == 3                      
   @ 063,260 get _dValid SIZE 45,10 Valid fDtValid() object odValid 
Else
   @ 065,258 say _dValid SIZE 45,10 object odValid
    odValid:Setfont(oFont)                         
Endif    

@ 065,315 Say "Encerrado :" Size 40,8 object oEncer                                
If _cpar == 3                      
   @ 065,345 say  _cEnce SIZE 30,10 object ocEnce                    
   ocEnce:Setfont(oFont)                         
Else
   @ 063,345 COMBOBOX _cEnce ITEMS _aEnce SIZE 30,10 object ocEnce

Endif
                            
@ 077,010 Say "Quantidade:"   Size 040,8 object oQuant   
If _cpar == 3                                       
   @ 075,040 Get _nQtde Picture "@E 999,999,999.999" Valid fqtde()  Size 50,8 Object oQtde
Else
   @ 075,040 Get _nQtde Picture "@E 999,999,999.999" When(.F.) Size 50,8 Object oQtde
Endif
       
@ 077,110 Say "Qtde Entregue:"   Size 055,8 object oQuanten                    
@ 075,150 Get _nQtdeEn Picture "@E 999,999,999.999" When(.F.) Size 50,8 Object oQtdeen
          
@ 077,220 Say "Qtde Devolução:"   Size 045,8 object oQtdedev                    
@ 075,260 Get _nQtdeDe Picture "@E 999,999,999.999" When(.F.) Size 40,8 Object oQtdede

@ 077,315 Say "Saldo:"   Size 050,8 object oSald                    
@ 075,335 Get _nSaldo Picture "@E 999,999,999.999" When(.F.) Size 40,8 Object oSaldo

@ 089,010 Say OemToAnsi("Observação:")   Size 040,8 object oOb                                        
@ 087,040 Get _cObs Picture "@!" When(_cPar == 3) Size 335,8 Object oObs          


If len(alltrim(_cUser)) > 15
   @ 115,010 Say _cUser Object oUser             
   oUser:Setfont(oFont)                      
Endif   
@ 115,285 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 115,350 BMPBUTTON TYPE 02 ACTION fEnd() 


Activate MsDialog oDialog Center Valid fDialog()
SZS->(DbCloseArea())
//If _cPar == 2
//   TMP->(DbCloseArea())                  
//Endif   

Return           


Static Function fDtValid()
Local _lRet:= .T.

If !Empty(_dvalid)
	If _dvalid < _dinicio
	    Msgbox("Data de Validade nao Pode ser Menor que Data de Inicio, Verifique !!!" ,"Atencao","ALERT" )     
	    _lRet:= .F.
	Endif       
	
	If _dvalid < dDatabase
	    Msgbox("Data de Validade nao Pode ser Menor que Data do Sistema, Verifique !!!" ,"Atencao","ALERT" )     
	    _lRet:= .F.
	Endif       
Endif	

Return(_lRet)                                               


Static Function fqtde()      
Local _lRet := .T.

   If _cTipoP$"Fechado"
      If _nQtde==0
         Msgbox("Qtde do Pedido Fechado nao Pode ser Zero, Verifique !!!" ,"Atencao","ALERT" )     
         _lRet:= .F.
      Endif
      
   Endif                   
   
   If _cPar == 3 //Inclusao
      _nSaldo := _nQtde
      oSaldo:Refresh()
   Endif
      
Return(_lRet)

Static Function fDialog()


   If Empty(_dInicio)
      lDialog := .F.     
      Msgbox("Data Inicial é Obrigatorio Digitar !!!","Atencao","ALERT" )     
   Endif


   If Empty(_cLoja) .or. Empty(_cCli) .or. Empty(_cCodPro) .or. Empty(_cNumPe).or. Empty(_dInicio)
      lDialog := .F.  
   Else
      lDialog := .T.                        
   Endif

   If _cTipoP$"Fechado" .And. _nQtde == 0
      lDialog := .F.     
      Msgbox("Pedido Fechado tem que Digitar a Quantidade !!!","Atencao","ALERT" )     
   Endif
  
Return(lDialog)
   

Static Function fFornece()

If Empty(_cCli) .Or. Len(Alltrim(_cCli)) < 6
   Return(.F.)
Endif

If _cTipoP$"Aberto" 
   oQtde:Refresh()
Endif   

SA1->(DbSetOrder(1))
If !SA1->(DbSeek(xFilial("SA1")+_cCli))
   Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   oDialog:SetFocus(oCli)
   oCli:Refresh()
   Return(.F.)
Endif
        
Return(.T.)


Static Function fProdu()

   SB1->(DbSetOrder(1))
   If SB1->(DbSeek(xFilial("SB1")+_cCodPro,Found()))
      _cDesPro := SB1->B1_DESC   
      ObjectMethod(oDesPro,"Refresh()")               
   Else
      Msgbox("Produto Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
      Return(.f.)
   Endif                                                     

Return


Static Function fLoja()

   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
      _cDesCli := SA1->A1_NOME
      _cLoja   := SA1->A1_LOJA
   Else
      Msgbox("Cliente Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
     // oCli:SetFocus(oCli)
      oDialog:SetFocus(oCli)
      oCli:Refresh()
      Return(.F.)
   Endif
ObjectMethod(oDesCli,"Refresh()")
ObjectMethod(oLoja,"Refresh()")

Return(.T.)

Static Function fEnd() 

   If _cPar == 3 //Opcao incluir
      RollBackSx8() //Volta a numeração da Ordem de Liberação
   Endif   
   Close(oDialog) 
//   lDialog := .T.                        
Return


Static Function fGrvOrd()

   If _cpar == 3 //incluir 
      If SZS->(DbSeek(xFilial("SZS")+_cDoc),Found())
          Msgbox("Sequencial do Controle de Pedido já foi Gravado com Este Numero, Verifique !!!" ,"Atencao","ALERT" )     	   
          //--RollBackSx8() //Volta a numeração da Ordem de Liberação
          Return
      Endif
      Reclock("SZS",.T.) //Incluir   
          
   ElseIf _cpar == 5 // alterar                                                 
	      Reclock("SZS",.F.) // Alterar
   Else
      If _lExc .And. !_cEnce$"S"//permite excluir a solicitação  
         Reclock("SZS",.F.)   
            SZS->(DbDelete())
         MsUnlock("SZS")                                                    
      Else
          Msgbox("Pedido já encerrado não pode ser excluido, Verifique !!!" ,"Atencao","ALERT" )     	   
      Endif   
   Endif //Fim exclusao
  
   If _cpar == 3 .Or. _cpar == 5 // incluir ou alterar
 
	         SZS->ZS_FILIAL  := xFilial("SZS")
		     SZS->ZS_NUM     := _cDoc
		     SZS->ZS_CLIENTE := _cCli
		     SZS->ZS_LOJA    := _cLoja  
		     SZS->ZS_PRODUTO := _cCodPro
		     SZS->ZS_TIPO    := _cTipoP 
		     SZS->ZS_EMISSAO := Date()
		     SZS->ZS_HORA    := Subs(time(),1,5)
		     SZS->ZS_PEDCLI  := _cNumPe
		     SZS->ZS_QUANT   := _nQtde
		     SZS->ZS_QUJE    := _nQtdeEn
		     SZS->ZS_SALDO   := _nSaldo
		     SZS->ZS_ENCERRA := _cEnce
		     SZS->ZS_DTVALID := Iif (ValType(_dValid)=="D",_dValid,Ctod(_dValid))
  		     SZS->ZS_DTINICI := Iif (ValType(_dInicio)=="D",_dValid,Ctod(_dInicio))
		     SZS->ZS_QTDEDEV := _nQtdeDe
             SZS->ZS_OBS     := _cObs
		     SZS->ZS_USER    := __cUserId
		     SZS->ZS_PRECO   := _nPreco
		     SZS->ZS_CODCLI  := _cCodCli
		     SZS->ZS_COND    := _cPgto
		     SZS->ZS_CODFOR  := _cCodFor		     		     
	      MsUnlock("SZS")

   	      If _cpar == 3 
   	         ConfirmSX8()
   	      Endif   
   Endif    

   If ValType(oDialog)=="O"
    // alert(" estou dialog")
      lDialog := .T.                           
      Close(oDialog)	                           
   Endif   

Return(.T.)


User Function FLegPe()       

Local aLegenda :=	{ {"BR_VERDE"    , "Pedido em Aberto"  },;
  					  {"BR_VERMELHO" , "Pedido Encerrado"   }}

BrwLegenda(OemToAnsi("Controle de Pedido do Cliente"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , "Pedido Aberto"  },;
  					  {"BR_VERMELHO" , "Pedido Encerrado"   }}

Local uRetorno := {}

Aadd(uRetorno, { 'ZS_ENCERRA = "N"' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZS_ENCERRA = "S"', aLegenda[2][1] } )
Return(uRetorno)