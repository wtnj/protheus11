/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST099  ³ Autor ³ Alexandre R. Bento     Data ³ 20/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Solicitação de Abertura de O.S. para Projeto                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geral                       				                  ³±±
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
#INCLUDE "FIVEWIN.CH"

User Function nhest099()

SetPrvt("CCADASTRO,AROTINA,_aTipoN,_cTipon,_dDtini,_dDtfim,_cConta,_nVlr,_cOS,_nSaldo,_nSalTot")

//axcadastro("ZA1","ZA1")

cCadastro := OemToAnsi("Solicitação de Abertura de O.S. ")
aRotina := {{ "Pesquisa","AxPesqui"     ,  0 , 1},;
            { "Visualizacao",'U_fsolici1(2)', 0 , 2},;
            { "Inclui"   ,'U_fsolici1(3)'   , 0,3},;
            { "Altera"   ,'U_fsolici1(8)'   , 0,8},;            
            { "Exclui"   ,'U_fsolici1(4)',0 , 4},;                   
            { "O.S. Complemen"   ,'U_fsolici1(5)',0 , 5},;                               
            {OemToAnsi("Aprovação O.S.")   ,'U_fsolici1(6)',0 , 6},;                                           
            {OemToAnsi("Lança M.Obra") ,'U_fsolici1(7)',0 , 7},;                                                       
            {OemToAnsi("Imprimir") ,'U_fSolimp2( )',0 , 7},;
            {OemToAnsi("Detalhes") ,'U_fSolDet2( )',0 , 7},;
            { "Legenda" ,"U_FLegSol1",0,2}}     

            
mBrowse( 6, 1,22,75,"ZA1",,,,,,fCriaCor())
//TMP->(DbCloseArea())
Return


User Function fsolici1(cPar01)

SetPrvt("nMax,aHeader,aCols,oMultiline,oDialog,_nId,lDialog,_cUser,_lFlag,_cUser,_aF4,_nF4,cQuery1")
SetPrvt("_cDoc,_aTipoN,_cTipon,_cCond,_cCli, _cLoja,_cTpFre,_nPLiqui,_nPBruto,_nVol,_cEsp,_cMens,_cDesCli,_cF3")
SetPrvt("_cCliFor,_aTiFre,_cObs,_dData,_cHora,_cPar,_lExc,_cTpCli,_nMoeda,_aVia, _cVia,_cCodTra,_cDesTra,VK_F4")
SetPrvt("_cRamal,_aGet,_lMo,_lAlt")
SetPrvt("_cConta,_cCentro,_cDesCon,_cDesCC,_dDataI,_dDataF, _cResp,_cDesRes,_nVlrEst,_nVlrApr,_aAprova,_aOSComp,_cAprova,_cOSComp")
SetPrvt("_cDescSe,oDescSe,_ncVlrEs,_ncVlrAp,_dcData,_ccAprov,ocData,_lCOS,_lApOS,_cTitle,aCols,aHeader")
SetPrvt("_nVlrEMO,_nVlrAMO,_nVlrEMa,_nVlrAMa,_cEncera")
SetPrvt("_ncVlrEM,_ncVlrAM,_ncVlrEO,_ncVlrAO")      
SetPrvt("_nTVlrEM,_nTVlrAM,_nTVlrEO,_nTVlrAO")
SetPrvt("_nTVlrEs,_nTVlrAp,_cCombo,oCombo")


DEFINE FONT oFont NAME "Arial" SIZE 10, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10
//Local oCombo
_cTitle := OemToAnsi("Solicitação de Abertura de O.S.")
_cDescSe := ""
_cConta  := space(20)
_cCentro := space(09)
_cDesCon := space(20)
_cDesCC  := space(20)
_dDataI  := Ctod("//")
_dDataF  := Ctod("//")
_dcData  := Ctod("//")
 _cResp  := space(06)
 _cDesRes:= space(20)
_cDoc    := Space(06)      
_cCombo  := Space(06)      
aCols    := {}
aHeader  := {}
_nVlrEst := 0
_nVlrApr := 0
_ncVlrEs := 0
_ncVlrAp := 0
_nTVlrEs := 0
_nTVlrAp := 0

_nVlrEMO:=_nVlrAMO:=_nVlrEMa:=_nVlrAMa:=0
_ncVlrEM:=_ncVlrAM:=_ncVlrEO:=_ncVlrAO:=0
_nTVlrEM:=_nTVlrAM:=_nTVlrEO:=_nTVlrAO:=0

_dData   := date()
_cHora   := time()   

_lFlag   := .T.
_lCOS    := .F.
_lApOS   := .F.        
_lMo     := .F.        
_lAlt    := .F.

//If cPar01 <> 3 
//   alert(" Encerrada ")
//Endif

IF cPar01 == 4 //excluir
  _cTitle += OemToAnsi(" Exclusão")
  _cPar   := 2 // visualização
  _lExc   := .T. //Controle para excluir
  lDialog := .T.               
Else            
   If cPar01 == 6      
//      _cTitle += OemToAnsi(" Aprovação O.S.")
      _cPar   := 2 // visualização   
      _lApOS  := .T. //Aprovação de valor de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.   
      _lMo    := .F. //Lança mao de obra                    
   ElseIf cPar01 == 5
//      _cTitle += OemToAnsi(" Complemento de O.S.")
      _cPar   := 2 // visualização   
      _lCOS   := .T. //Complemento de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.                             
      _lMo    := .F. //Lança mao de obra                          
   ElseIf cPar01 == 7
      _cPar   := 2 // visualização   
      _lCOS   := .F. //Complemento de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.                                        
      _lMo    := .T. //Lança mao de obra                          
   ElseIf cPar01 == 8
      _cPar   := 2 // visualização   
      _lCOS   := .F. //Complemento de OS
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.                                        
      _lMo    := .F. //Lança mao de obra                          
      _lAlt   := .T. //permite alterar
   Else
      _cPar   := cPar01 // receber visualizaçao ou impressao      
      _lExc   := .F. // Controle para não excluir
      lDialog := .F.           
      _lMo    := .F. //Lança mao de obra                          
   Endif         
Endif
_cDoc   := Space(06)
_aTipon := {"A=Ativo Diferido - Gastos Pre-Operacionais",;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma")}

_aAprova:= {"SIM","NAO"}
_aOSComp:= {"SIM","NAO"}//{"Aereo","Correio","Maritimo",OemToAnsi("Rodoviario")}
_cAprova:= "NAO" 
_ccAprov:= "NAO" 
_cEncera:= "NAO" 
_cOSComp:= Iif(cPar01==3,"NAO","SIM")
_cCodTra:= Space(06)
_cDesTra:= Space(40)
_cTipon := "Normal"   
_cCliFor:= "Cliente:"
_cCond  := Space(03)
_cCli   := Space(06)
_cLoja  := Space(02) 
_cDesCli:= Space(30) 
_cTpFre := Space(10)  
_cUser  := Space(06)
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

 nMax    := 0                                                       

If _cPar == 3
   _cTitle += OemToAnsi(" Inclusão")
      
  // _cDoc       := GetSXENum("SZQ","ZQ_NUM")   // Traz o novo numero da solicitação de NF
   _cUser := "Solicitante:  " + UsrFullname(__cUserId )
   _cRamal   := U_Nhcfg001("06")
   
ElseIf _cPar == 2

   
   fQuery()
   fMostra()
   If !_lFlag  
      Return //retorna para browse
   Endif
   _cUser := "Solicitante:  " + UsrFullname(_cUser )   
Endif         

//DbSelectArea("ZA2")
Aadd(aHeader,{"Item"       , "ZA2_ITEM",   "@!"              ,04,0,".F.","","C","ZA2"}) //03
Aadd(aHeader,{"Data"       , "ZA2_DATA" ,   "99/99/99"       ,08,0,".T.","","C","ZA2"}) //06
Aadd(aHeader,{"Descricao"  , "ZA2_DESCRI"  ,Repli("!",60)    ,60,0,".T.","","C","ZA2"}) //03
Aadd(aHeader,{"Valor"      , "ZA2_VALOR"   ,"@E 999999999.99",12,2,".T.","","N","ZA2"}) //03

Define MsDialog oDialog Title _cTitle From 010,030 To 550,860 Pixel 

@ 013,007 To 125,410 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8 Object oNum
@ 027,032 Get _cDoc Picture "@!" When(.F.) Size 035,10 Object oDoc            
//@ 027,032 Get _cDoc Picture "@!" When(_cPar == 3) Size 035,10 Object oDoc            
//@ 027,032 Say _cDoc Size 035,10 Object oDoc            
// oDoc:Setfont(oFont)                      
@ 027,80 Say "Tipo :" Size 30,8 Object oTP
If _cpar == 3                      
//  @ 025,095 COMBOBOX _cTipon ITEMS _aTipon SIZE 185,10 object oTipon  
	@ 025,095 MSCOMBOBOX oCombo1 VAR _cTipon ITEMS _aTipon SIZE 185 ,10 OF oDialog PIXEL VALID (fNumber())
   
   
Else
   If Len(alltrim(_cTipon)) > 45
      @ 020,100 say  _cTipon SIZE 180,20 object oTipon
      oTipon:Setfont(oFont)                         
   
   Else
      @ 027,100 say  _cTipon SIZE 180,10 object oTipon
      oTipon:Setfont(oFont)                         
   Endif   
Endif
@ 027,285 Say "Data:" Size 25,8 object oDt                                
@ 025,305 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object oData            
@ 027,350 Say "Hora:" Size 30,8 object oHr            
@ 025,370 Get _cHora Picture "99:99" When .F. Size 35,8 Object oHora              

@ 040,10 Say "Conta Contabil:" Size 050,8 object oConta
@ 038,50 Get _cConta  Size 55,8 F3 "CT1" When(cPar01 == 6 .or. cPar01 == 8) Valid fConta() object ocConta
@ 038,108 Get _cDesCon Picture "@!" When .F. Size 105,8 Object oDesCont            

@ 040,225 Say "Centro Custo:" Size 050,8 object oCentro
@ 038,260 Get _cCentro  Size 15,8 F3 "CTT" When(_cPar == 3 .Or. cPar01 == 8) Valid fCC() object ocCentro       
@ 038,305 Get _cDesCC Picture "@!" When .F. Size 100,8 Object oDesCC            

@ 053,010 Say "Data Inicio:" Size 030,8 object oDatai           
If _cpar == 3 .Or. cPar01 == 8                      
   @ 051,040 Get _dDataI Picture "99/99/99" SIZE 35,10 Valid fDataI() object odDatai 
Else
   @ 053,040 say  Dtoc(_dDataI) Picture "@!" SIZE 45,10 object odDatai 
   odDatai :Setfont(oFont)                         
Endif

@ 053,100 Say "Data Termino:" Size 040,8 object oDataF           
If _cpar == 3 .Or. cPar01 == 8                     
   @ 051,145 Get _dDataf Picture "99/99/99" SIZE 35,10 Valid fDataF() object odDataf 
Else
   @ 053,135 Say  Dtoc(_dDataf) Picture "@!" SIZE 45,10 object odDataf 
   odDataf :Setfont(oFont)                            

Endif

@ 053,205 Say OemToAnsi("Responsável:") Size 35,8 object oResp                                
@ 051,245 Get _cResp Picture "@!" F3 "QAA" When(_cPar == 3) Size 40,8 Valid fResp() Object ocResp           
@ 051,290 Get _cDesRes Picture "@!" When (.F.) Size 115,8 Object ocDesRes             

@ 065,010 Say OemToAnsi("Valor Estimado Mat.:") Size 050,8 object oValEma
@ 063,060 Get _nVlrEma Picture "9,999,999,999.99" When(_cPar == 3) Size 050,8 Valid fValorma() Object onVlrEma

@ 065,130 Say OemToAnsi("Valor Aprovado Mat.:") Size 055,8 object oValAma
@ 063,185 Get _nVlrAma Picture "9,999,999,999.99" When(cPar01 == 6) Size 050,8 Valid fValorma() Object onVlrAma

@ 065,255 Say "Aprovado:" Size 30,8 Object oAPv
//If cPar01 == 6                      
//   @ 063,285 COMBOBOX _cAprova ITEMS _aAprova SIZE 25,8 object oAprova
//Else
   @ 065,285 say  _cAprova SIZE 25,8 object oAprova
   oAprova:Setfont(oFont)                         
//Endif

@ 065,330 Say "O.S. Complementar:" Size 50,8 Object oOS
If _cpar == 3                      
//   @ 063,380 COMBOBOX _cOSComp ITEMS _aOSComp SIZE 25,8 object oOSComp
   @ 065,380 say  Iif(Subs(_cOSComp,1,1)=="S","SIM","NAO") SIZE 25,8 object oOSComp
Else
   @ 065,380 say  Iif(Subs(_cOSComp,1,1)=="S","SIM","NAO") SIZE 25,8 object oOSComp
Endif
 oOSComp:Setfont(oFont)                         

@ 077,010 Say OemToAnsi("Valor Estimado M.O.:") Size 050,8 object oValEmo
@ 075,060 Get _nVlrEmo Picture "9,999,999,999.99" When(_cPar == 3) Size 050,8 Valid fValormo() Object onVlrEmo

@ 077,130 Say OemToAnsi("Valor Aprovado M.O.:") Size 055,8 object oValAmo
@ 075,185 Get _nVlrAmo Picture "9,999,999,999.99" When(cPar01 == 6) Size 050,8 Valid fValormo() Object onVlrAmo

@ 077,255 Say "O.S.Encerrada:" Size 35,8 Object oEnce
If cPar01 == 6                      
   @ 075,293 COMBOBOX _cEncera ITEMS _aAprova SIZE 25,8 object oEncerra
Else
   @ 077,294 say  _cEncera SIZE 25,8 object oEncera
   oEncera:Setfont(oFont)                         
Endif
  
@ 087,010 Say OemToAnsi("Descrição do Serviço") Size 060,8 object oDS
@ 095, 010 GET oDescSe VAR _cDescSe MEMO When(_cPar == 3 .Or. _lApOS) SIZE 395,25 PIXEL OF oDialog 


@ 130,006 To 165,400 Title OemToAnsi(" O.S. Complementar ") Object oOSc


@ 140,010 Say OemToAnsi("Valor Estimado Mat.:") Size 055,8 object oValEst
@ 138,060 Get _ncVlrEM Picture "9,999,999,999.99" When(cPar01==5 .and. _cAprova$"SIM") Size 050,8 Valid fcValorm() Object oncVlrEm

@ 140,130 Say OemToAnsi("Valor Aprovado Mat.:") Size 055,8 object oValApr
@ 138,185 Get _ncVlrAM Picture "9,999,999,999.99" When(cPar01==6 .and. _cAprova$"SIM" .And. _ncVlrEM >0) Size 050,8 Valid fcValorm() Object oncVlrAm

@ 140,255 Say "Aprovado:" Size 30,8 Object oAP
If _lCOS .and. Subs(_cAprova,1,1)$"S" .And. cPar01==6              
   @ 138,285 COMBOBOX _ccAprov ITEMS _aAprova SIZE 25,8 object ocAprova
     _dcData  := date()

Else
   @ 140,285 say  Iif(Subs(_ccAprov,1,1)=="N","Nao","Sim") SIZE 25,8 object ocAprova
   ocAprova:Setfont(oFont)                    
   if Subs(_cAprova,1,1)=="N" .And. cPar01==5 
      Msgbox("O.S. Principal nao Esta Aprovada, Verifique !!!" ,"Atencao","ALERT" )                
   Endif     
Endif

@ 140,320 Say "Data:" Size 25,8 object ocDt
@ 140,343 Say Iif (ValType(_dcData)=="D",Dtoc(_dcData),_dcData) Picture "@!" Size 35,8 Object ocData
ocData :Setfont(oFont) 

@ 152,010 Say OemToAnsi("Valor Estimado M.O.:") Size 055,8 object oValEo
@ 150,060 Get _ncVlrEO Picture "9,999,999,999.99" When(cPar01==5 .and. _cAprova$"SIM") Size 050,8 Valid fcValoro() Object oncVlrEo

@ 152,130 Say OemToAnsi("Valor Aprovado M.O.:") Size 055,8 object oValAo
@ 150,185 Get _ncVlrAO Picture "9,999,999,999.99" When(cPar01==6 .and. _cAprova$"SIM" .And. _ncVlrEO > 0) Size 050,8 Valid fcValoro() Object oncVlrAo
  
@ 167,006 To 228,410 Title OemToAnsi("  Informações ")  
@ 175,008 TO 225,405 MULTILINE MODIFY DELETE OBJECT oMultiline
If cPar01 <> 7 
   oMultiline:Disable()
Endif   

@ 233,005 Say OemToAnsi("Vlr Tot Estimado Mat:") Size 055,8 object oTValEm
@ 231,060 Get _nTVlrEm Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrEm

@ 243,005 Say OemToAnsi("Vlr Tot Estimado M.O.:") Size 055,8 object oTValEo
@ 241,060 Get _nTVlrEo Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrEo

@ 233,125 Say OemToAnsi("Vlr Tot Aprovado Mat:") Size 055,8 object oTValAm
@ 231,180 Get _nTVlrAm Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrAm

@ 243,125 Say OemToAnsi("Vlr Tot Aprovado M.O.:") Size 057,8 object oTValAo
@ 241,180 Get _nTVlrAo Picture "9,999,999,999.99" When(.F.) Size 050,8 Object onTVlrAo


If len(alltrim(_cUser)) > 15
   @ 257,010 Say _cUser Object oUser             
   oUser:Setfont(oFont)                      
Endif   

@ 257,210 Say OemToAnsi("Ramal:")   Size 030,8 object oRama                                        
@ 255,230 Get _cRamal Picture "@!" When(_cPar == 3) Size 20,8 valid fRamal() Object oRamal          

@ 250,285 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 250,350 BMPBUTTON TYPE 02 ACTION fEnd() 

Activate MsDialog oDialog Center Valid fDialog()
SZR->(DbCloseArea())
If _cPar == 2
   TMP->(DbCloseArea())                  
   TRB->(DbCloseArea())                     
Endif   

Return           

Static Function fNumber()

   _cCombo := IIf(_ctipon$"A/F","DF","IM")
   ZA1->(DbSetOrder(1))
   ZA1->(Dbseek(xFilial("ZA1")+_cCombo))
   While ZA1->(!Eof()) .And. Subs(ZA1->ZA1_NUM,1,2) ==  Subs(_cCombo,1,2)
      _cCombo := ZA1->ZA1_NUM
      ZA1->(Dbskip())
   Enddo
   _cDoc := Subs(_cCombo,1,2) +  StrZero(Val(Subs(_cCombo,3,4))+1,4)
   oDoc:Refresh()
Return(.t.)

Static Function fDataI()
Local _lRet := .T.

If Empty(_dDataI) //.or. Empty(_dDataf)
   Msgbox("Data Inicial em Branco, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
Endif

Return(_lRet)

Static Function fDataF()
Local _lRet := .T.

If Empty(_dDataF) //.or. Empty(_dDataf)
   Msgbox("Data Final em Branco, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
Endif

If  _dDataf < _dDataI
   Msgbox("Data Final Menor que Data Inicial, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
Endif


Return(_lRet)

    
Static Function  fValorma()    
Local _lRet := .T.
                      
If _nVlrEMa == 0
   Msgbox("Valor Estimado nao Pode ser Zero, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
   onVlrEma:SetFocus()
Endif


If _nVlrAMa > _nVlrEMa   //_nVlrApr > _nVlrEst
   Msgbox("Valor Aprovado nao Pode Maior que Valor Estimado, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
   onVlrAma:SetFocus()
Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)

Static Function  fValormo()    
Local _lRet := .T.


If _nVlrAMO > _nVlrEMO  //_nVlrAMa > _nVlrEMa   //_nVlrApr > _nVlrEst
   Msgbox("Valor Aprovado nao Pode Maior que Valor Mao de Obra, Verifique !!!" ,"Atencao","ALERT" )        
   _lRet := .F.
   onVlrAmo:SetFocus()
Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)

Static Function  fcValorm()    
Local _lRet := .T.

//If _lcos
                                    
	If _ncVlrEM == 0
	   Msgbox("Valor Estimado dos Materiais nao Pode ser Zero, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlrEm:SetFocus()
	Endif

	If _ncVlrAM > _ncVlrEM   //_nVlrApr > _nVlrEst
	   Msgbox("Valor Estimado Aprovado nao Pode Maior que Valor Estipulado, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlram:SetFocus()
	Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)

Static Function  fcValoro()    
Local _lRet := .T.

	
	If _ncVlrAO > _ncVlrEO  //_nVlrAMa > _nVlrEMa   //_nVlrApr > _nVlrEst
	   Msgbox("Valor Aprovado da Mao de Obra nao Pode Maior que Valor Estimado, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlrAo:SetFocus()
	Endif
fTotal() //totaliza os valores de materiais e mao de obra
Return(_lRet)	
/*
------------------------------------
	If _ncVlrEs == 0
	   Msgbox("Valor Estipulado nao Pode ser Zero, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlrEs:SetFocus()
	  
	Endif
	
	If _ncVlrAp > _ncVlrEs
	   Msgbox("Valor Aprovado nao Pode Maior que Valor Estipulado, Verifique !!!" ,"Atencao","ALERT" )        
	   _lRet := .F.
	   oncVlrEs:SetFocus()
	Endif
*/	
//Endif


//Return(_lRet)

Static Function fTotal()

_nTVlrEM := _nVlrEMa + _ncVlrEM
_nTVlrAM := _nVlrAMa + _ncVlrAM
_nTVlrEO := _nVlrEMO + _ncVlrEO
_nTVlrAO := _nVlrAMO + _ncVlrAO

onTVlrEm:Refresh()
onTVlrEo:Refresh()
onTVlrAm:Refresh()
onTVlrAo:Refresh()

Return

Static Function fResp()
Local _lRet := .T.

QAA->(DbSetOrder(1)) //filial+cod
QAA->(DbSeek(xFilial("QAA") + _cResp))
If QAA->(Found())
   _cDesRes :=	QAA->QAA_NOME 
   ObjectMethod(ocDesRes,"Refresh()")
Else
   Msgbox("Responsavel nao Cadastrada, Verifique !!!" ,"Atencao","ALERT" )        
    _lRet := .F.
Endif

Return(_lRet)     
                

Static Function fCC()
Local _lRet := .T.

CTT->(DbSetOrder(1)) //filial+cod
CTT->(DbSeek(xFilial("CTT") + _cCentro))
If CTT->(Found())
   _cDesCC :=	CTT->CTT_DESC01 
   ObjectMethod(oDesCC,"Refresh()")
Else
   Msgbox("Centro de Custo nao Cadastrada, Verifique !!!" ,"Atencao","ALERT" )        
    _lRet := .F.
Endif

Return(_lRet)     


Static Function fConta()
Local _lRet := .T.

CT1->(DbSetOrder(1)) //filial+cod
CT1->(DbSeek(xFilial("CT1") + _cConta))
If CT1->(Found())
   _cDesCon :=	CT1->CT1_DESC01 
   ObjectMethod(oDesCont,"Refresh()")
Else
   Msgbox("Conta Contabil nao Cadastrada, Verifique !!!" ,"Atencao","ALERT" )        
    _lRet := .F.
Endif

Return(_lRet)     


Return()

Static Function fRamal()

If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
   Msgbox("Favor Preencher o Ramal do Solicitante Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
   Return(.F.)
Endif

Return(.T.)

Static Function fQuery()
Local cQuery
Local cQuery1

cQuery := "SELECT CONVERT(TEXT,CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZA1_DESC))) AS 'DESC',"
cQuery += "ZA1.R_E_C_N_O_ AS 'ZA1_RECNO',* "
cQuery += "FROM " +  RetSqlName( 'ZA1' ) +" ZA1 "
cQuery += "WHERE ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "'"    
cQuery += "AND ZA1.D_E_L_E_T_ = ' ' "
cQuery += "AND ZA1.ZA1_NUM = '" + ZA1->ZA1_NUM + "' "                                                                                                           
   
// MemoWrit('C:\TEMP\EST081.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","ZA1_DATA","D")  // Muda a data de string para date    
TcSetField("TMP","ZA1_CDATA","D")  // Muda a data de string para date    
TcSetField("TMP","ZA1_DTINI","D")  // Muda a data de string para date    
TcSetField("TMP","ZA1_DTFIM","D")  // Muda a data de string para date    

//Query  dos itens de mao de obra do OS
cQuery1:= "SELECT * "
cQuery1 += "FROM " +  RetSqlName( 'ZA2' )
cQuery1 += " WHERE ZA2_FILIAL = '" + xFilial("ZA2")+ "'"    
cQuery1 += " AND D_E_L_E_T_ = ' ' "
cQuery1 += " AND ZA2_NUM = '" + ZA1->ZA1_NUM + "' "                                                                                                           
   
// MemoWrit('C:\TEMP\EST081A.SQL',cQuery1)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery1 NEW ALIAS "TRB"      
TcSetField("TRB","ZA2_DATA","D")  // Muda a data de string para date    

TMP->(DBGOTOP())
If Empty(TMP->ZA1_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Msgbox("Numero de Solicitação Nao Encontrado, Verifique !!!" ,"Atencao","ALERT" )     
   TMP->(DbCloseArea())
   return
Endif 
   
Return

Static Function fMostra()
Local i
Local _nLinha

//Atribui variaveis para consulta
_cDoc   := TMP->ZA1_NUM
_ctipon := IIf(TMP->ZA1_TIPO$"A",_aTipon[1],IIf(TMP->ZA1_TIPO$"C",_aTipon[2],IIf(TMP->ZA1_TIPO$"F",_aTipon[3],IIf(TMP->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         
_cConta	:= TMP->ZA1_CONTA 
CT1->(DbSetOrder(1)) //filial+cod
CT1->(DbSeek(xFilial("CT1") + _cConta))
If CT1->(Found())
   _cDesCon :=	CT1->CT1_DESC01 
Endif                     

If _lApOS  //Aprovação de valor de OS
   _cAprova:= "SIM"
Else
   _cAprova:= Iif(TMP->ZA1_OSLIB=="S","SIM","NAO") 
Endif
_cOSComp:= TMP->ZA1_OSCOMP
_cResp  := TMP->ZA1_RESP  //IIf(_ctipon$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente         
_dData  := TMP->ZA1_DATA   
_cCentro:= TMP->ZA1_CC     
CTT->(DbSetOrder(1)) //filial+cod
CTT->(DbSeek(xFilial("CTT") + _cCentro))
If CTT->(Found())
   _cDesCC :=	CTT->CTT_DESC01 
Endif

_cHora  := TMP->ZA1_HORA
_cResp  := TMP->ZA1_RESP    
QAA->(DbSetOrder(1)) //filial+cod
QAA->(DbSeek(xFilial("QAA") + _cResp))
If QAA->(Found())
   _cDesRes :=	QAA->QAA_NOME 
Endif
_dDataI := TMP->ZA1_DTINI   
_dDataf := TMP->ZA1_DTFIM    
// _cDescSe:= lower(TMP->DESC) 	//memo	            
ZA1->(Dbgoto(TMP->ZA1_RECNO))         
_nLinha = MlCount(Lower(Alltrim(ZA1->ZA1_DESC)))
for i:= 1 to _nLinha
    _cDescSe +=  OemToAnsi(MemoLine(ZA1->ZA1_DESC,90,i))
next i 

//--------------------------
_nVlrEMa := TMP->ZA1_VLESMA
_ncVlrEM := TMP->ZA1_VLCEMA

_nVlrAMa := TMP->ZA1_VLAPMA
_ncVlrAM := TMP->ZA1_VLCAMA
_nVlrEMO := TMP->ZA1_VLESMO
_ncVlrEO := TMP->ZA1_VLCEMO
_nVlrAMO := TMP->ZA1_VLAPMO
_ncVlrAO := TMP->ZA1_VLCAMO
// ------------------------
//_nVlrEst := TMP->ZA1_VLREST   
//_nVlrApr := TMP->ZA1_VLRAPR  
//_ncVlrEs := TMP->ZA1_CVLREST 
//_ncVlrAp := TMP->ZA1_CVLRAP  
//------------------------------
_dcData  := TMP->ZA1_CDATA   
_cUser   := TMP->ZA1_USER  
_cRamal  := TMP->ZA1_RAMAL   
                                       
_ccAprov:= Iif(TMP->ZA1_COSLIB=="S","SIM","NAO") 
_cEncera := Iif(TMP->ZA1_ENCERA=="S","SIM","NAO") 
		
// _nTVlrEs := _nVlrEst + _ncVlrEs
// _nTVlrAp := _nVlrApr + _ncVlrAp
 
_nTVlrEM := _nVlrEMa + _ncVlrEM
_nTVlrAM := _nVlrAMa + _ncVlrAM
_nTVlrEO := _nVlrEMO + _ncVlrEO
_nTVlrAO := _nVlrAMO + _ncVlrAO


TRB->(DBGOTOP()) // Itens da solicitação de OS.
If !Empty(TRB->ZA2_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   While TRB->(!EOF())
       
      Aadd(Acols,{TRB->ZA2_ITEM,TRB->ZA2_DATA,TRB->ZA2_DESCRI,TRB->ZA2_VALOR,.F.})  
      TRB->(Dbskip())
   Enddo
Endif    
//TRB->(DbCloseArea())

Return


Static Function fDialog()
   DlgRefresh(oDialog)
   If Empty(_cTipon) .Or. Empty(_cDoc) .or. Empty(_cRamal) 

      lDialog := .F.  
   Else
      lDialog := .T.                        
   Endif
Return(lDialog)


Static Function fEnd() 

   If _cPar == 3 //Opcao incluir
      RollBackSx8() //Volta a numeração da Ordem de Liberação
   Endif   
   Close(oDialog) 
//   lDialog := .T.                        
Return


Static Function fGrvOrd()
Local _lGravou := .F.  
local x          
Local _nx := 1
   
   If Empty(_cRamal) .Or. Len(Alltrim(_cRamal)) <> 4
      Msgbox("Favor Preencher o Ramal do Solicitante Corretamente, Verifique !!!" ,"Atencao","ALERT" )     
      Return(.F.)
   Endif

   If Empty(_cDescSe)
      Msgbox("Favor Preencher a Descricao do Servico, Verifique !!!" ,"Atencao","ALERT" )     
      Return(.F.)
   Endif
   
   If _cPar == 3 //incluir
	  //Begin Transaction                   
             
      If ZA1->(DbSeek(xFilial("ZA1")+_cDoc),Found())
  	     Msgbox("Solicitação já foi Gravada com Este Numero, Verifique !!!" ,"Atencao","ALERT" )     	   
	  Else
		 Reclock("ZA1",.T.)
		    ZA1->ZA1_FILIAL  := xFilial("ZA1")
			ZA1->ZA1_NUM     := _cDoc         
  	        ZA1->ZA1_TIPO    := _ctipon //$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente         			
			ZA1->ZA1_CONTA   := _cConta
			ZA1->ZA1_DCONTA  := _cDesCon
    	    ZA1->ZA1_OSCOMP  := _cOSComp
 	        ZA1->ZA1_RESP    := _cResp //IIf(_ctipon$"Normal","N",IIf(_ctipon$"Dev.Compra","D","B"))  //Cliente         
  		    ZA1->ZA1_DATA    := Date() 	        
  		    ZA1->ZA1_CC      := _cCentro
 	        ZA1->ZA1_HORA    := time()   
 	 		ZA1->ZA1_RESP    := _cResp
		    ZA1->ZA1_DTINI   := _dDataI
	        ZA1->ZA1_DTFIM   := _dDataf 
		    ZA1->ZA1_DESC    := _cDescSe 	//memo	            
		    
		//  ZA1->ZA1_VLREST  := _nVlrEst              
		//  ZA1->ZA1_VLRAPR  := _nVlrApr    
		//  ZA1->ZA1_CVLREST := _ncVlrEs
		//	ZA1->ZA1_CVLRAP  := _ncVlrAp

		    ZA1->ZA1_VLESMA  := _nVlrEMa
			ZA1->ZA1_VLESMO  := _nVlrEMO 
									
//			ZA1->ZA1_CDATA   :=	ctod(_dcData)
			ZA1->ZA1_USER    := __cUserId
			ZA1->ZA1_RAMAL   := _cRamal		     
//			ZA1->ZA1_OSLIB   := _cAprova
	     MsUnlock("ZA1")     
              	     // End Transaction   	  
     Endif
	          
	  //If _lGravou  //Faz a verificação se gravou os itens da solicitação da nota senão exclui o cabeçalho
//	     ConfirmSX8()   
//   	     fLimpa()
//   	  Else                                               
//   	     RollBackSx8() //Volta a numeração da Ordem de Liberação
//	  Endif
	       
   Else
      
      IF _lApOS //atualiza a conta contabil e vlr aprovado e o.s. aprovada
   		 Reclock("ZA1",.F.)
			ZA1->ZA1_OSLIB   := "S" //coloca como aprovada a O.S. principal.
			ZA1->ZA1_CONTA   := _cConta 
			ZA1->ZA1_DCONTA  := _cDesCon			
			ZA1->ZA1_VLAPMO  := _nVlrAMO 
			ZA1->ZA1_VLAPMA  := _nVlrAMa 			
		    ZA1->ZA1_DESC    := _cDescSe 	//memo	            			
		    ZA1->ZA1_ENCERA  := _cEncera   // OS ENCERADA SIM OU NAO
           
            // Aprocaçao de valores
            If _cOSComp$"S"
			   ZA1->ZA1_VLCAMA  := _ncVlrAM  
		  	   ZA1->ZA1_VLCAMO  := _ncVlrAO 			
			   ZA1->ZA1_COSLIB  := "S" //_ccAprov
			Endif
	     MsUnlock("ZA1")     
      Endif
      
      If _lCOS // Atualiza OS complementar ZA1->ZA1_OSLIB
         If ZA1->ZA1_OSCOMP$"N" // nao permite regravar o valor da os complementar
   		    Reclock("ZA1",.F.)
   		   	ZA1->ZA1_VLCEMO  := _ncVlrEO 		
			ZA1->ZA1_VLCEMA  := _ncVlrEM 
			ZA1->ZA1_CDATA   :=	Date() //Iif (ValType(_dcData)=="C",CtoD(_dcData),_dcData)
   	        ZA1->ZA1_OSCOMP  := "S"  //OS complementar sim			
	        MsUnlock("ZA1")     
	     Endif  
      Endif
      if _lExc //permite excluir a solicitação  
         //Deleta o cabecalho da solicitação de nota fiscal
         TMP->(Dbgotop()) //Posiciona registro para excluir
         ZA1->(Dbgoto(TMP->ZA1_RECNO)) //Posiciona registro para excluir
         Reclock("ZA1",.F.)   
            ZA1->(DbDelete())
         MsUnlock("ZA1")                                                    

      Endif //Fim exclusao
      
      If _lAlt                
         Reclock("ZA1",.F.)         
 		    ZA1->ZA1_CONTA   := _cConta
			ZA1->ZA1_DCONTA  := _cDesCon
  		    ZA1->ZA1_CC      := _cCentro
		    ZA1->ZA1_DTINI   := _dDataI
	        ZA1->ZA1_DTFIM   := _dDataf 
         MsUnlock("ZA1")                                                          
      Endif
      
      If _lMo //Lança mao de obra
         _nx := 1 // refaz a numeração do item
         For x:= 1 to Len(Acols)        
           //nao pega quando a linha esta deletada
            
               If ZA2->(DbSeek(xFilial("ZA2")+_cDoc+Acols[x][1]))
                  Reclock("ZA2",.F.)   
                     ZA2->(DbDelete())
                  MsUnlock("ZA2")                                                    
               Endif
               
               If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2]) .And. !Empty(Acols[x][3]) .And. !Empty(Acols[x][4])     
                  Reclock("ZA2",.T.)   
                  ZA2->ZA2_FILIAL  := xFilial("ZA2")
			      ZA2->ZA2_NUM     := _cDoc            
 	              ZA2->ZA2_ITEM    := Strzero(_nx,4)			   
  		          ZA2->ZA2_DATA    := Iif( valtype( Acols[x][2] ) == 'C', CtoD(Acols[x][2]),Acols[x][2])
 	  			  ZA2->ZA2_DESCRI  := Acols[x][3]
    	          ZA2->ZA2_VALOR   := Acols[x][4]
                  MsUnlock("ZA2")                                                    
                  _nx+=1
               Endif    
         Next x
      Endif   
      lDialog := .T.                           
      Close(oDialog)	                           

   Endif   


   lDialog := .T.                           
   Close(oDialog)	                           

Return


User Function FLegSol2()       

Local aLegenda :=	{ {"BR_VERDE"    , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

BrwLegenda(OemToAnsi("Solicitação de Abertura de O.S. "), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , "Aberta"  },;
  					  {"BR_VERMELHO" , "Fechada"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZA1_TIPO == " "' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZA1_TIPO <> " "', aLegenda[2][1] } )
Return(uRetorno)

Static Function fLimpa()

_cDoc   := Space(06)
_aTipon := {"N=Normal",OemToAnsi("D=Dev.Compra"),"B=Util.Fornecedor"}
_aTiFre := {"C=CIF","F=FOB"}
_aVia   := {"Aereo","Correio","Maritimo",OemToAnsi("Rodoviario")}
_cVia   := "Rodoviario"
_cCodTra:= Space(06)
_cDesTra:= Space(40)
_cTiFre := ""
_cTipon := "Normal"   
_cCliFor:= "Cliente:"
_cCond  := Space(03)
_cCli   := Space(06)
_cLoja  := Space(02) 
_cDesCli:= Space(30) 
_cTpFre := Space(10)  
_cUser  := Space(06)
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
// n      := 0
_dData  := date()
_cHora  := time()   
 nMax   := 0                                                       
RestArea(_aGet)   
//Inicializa o acols
Aadd(aCols,{"01", Space(15),Space(30),0,0,0,Space(03),Space(04), Space(02), 0, 0, 0, Space(06), Space(03), Space(02),.F. })
   dbSelectArea("SX3")
   SX3->(dbSetOrder(1))
   SX3->(MsSeek("SZR"))
   While ( !SX3->(Eof()) .And. (SX3->X3_ARQUIVO == "SZR") )
    
      If ( X3USO(SX3->X3_USADO) .And.;
			!(	Trim(SX3->X3_CAMPO) == "ZR_NUM" ) 	.And.;
			Trim(SX3->X3_CAMPO) <> "ZR_EMISSAO" 	.And.;
			Trim(SX3->X3_CAMPO) <> "ZR_PEDIDO"   	.And.;			
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
				SX3->X3_CONTEXT})
      Endif
      SX3->(dbSkip())
   EndDo
                                                    		
DbSelectArea("SZQ")

_cDoc       := GetSXENum("SZQ","ZQ_NUM")   // Traz o novo numero da solicitação de NF
_cUser := "Solicitante:  " + UsrFullname(__cUserId )
_cRamal   := U_Nhcfg001("06")            

ObjectMethod(oDoc,"SetText(_cdoc)")
oMultiline:oBrowse:ncolpos := 1 //Atualiza o focu para primeira posicao
//oGet:ForceRefresh()
oMultiline:Refresh()  
ObjectMethod(oCli,"Refresh()")
oTipon:Refresh()       
oTipon:SetFocus()      
oDoc:Setfont(oFont)                      
DlgRefresh(oDialog)
ZA1->(DBGOBOTTOM())
Return
                                         

User Function fSolImp2()

//oPrint	:= TMSPrinter():New(OemToAnsi("SOLITAÇÃO DE ABERTURA DE OS")) 

//oPrint:SetPortrait()

//colocar consulta
Processa( {|| fGera()   },"Gerando Dados para a Impressao")

Return Nil

Static Function fGera()
   cQuery := "SELECT CONVERT(TEXT,CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZA1_DESC))) AS 'DESC',ZA1.R_E_C_N_O_,* "
   cQuery += " FROM " +  RetSqlName( 'ZA1' ) +" ZA1, " +  RetSqlName( 'ZA2' ) +" ZA2, " +   RetSqlName( 'QAA' ) +" QAA,"  +   RetSqlName( 'CT1' ) +" CT1, "  +   RetSqlName( 'CTT' ) +" CTT "
   cQuery += " WHERE ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "'"    
   cQuery += " AND ZA2.ZA2_FILIAL = '" + xFilial("ZA2")+ "'" 
   cQuery += " AND QAA.QAA_FILIAL = '" + xFilial("QAA")+ "'"    
   cQuery += " AND CT1.CT1_FILIAL = '" + xFilial("CT1")+ "'"       
   cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"          
   cQuery += " AND ZA1.ZA1_NUM = '" + ZA1->ZA1_NUM +"' " 
   cQuery += " AND ZA1.ZA1_CC  = CTT.CTT_CUSTO "
   cQuery += " AND ZA1.ZA1_NUM *= ZA2.ZA2_NUM "
   cQuery += " AND ZA1.ZA1_RESP *= QAA.QAA_MAT "   
   cQuery += " AND ZA1.ZA1_CONTA *= CT1.CT1_CONTA "      
   cQuery += " AND ZA1. D_E_L_E_T_ = ' ' AND ZA2. D_E_L_E_T_ = ' ' "
   cQuery += " AND CTT. D_E_L_E_T_ = ' ' AND QAA. D_E_L_E_T_ = ' ' AND CT1. D_E_L_E_T_ = ' '"               
   cQuery += " ORDER BY ZA1.ZA1_FILIAL,ZA1.ZA1_NUM ASC"    

//   MemoWrit('C:\TEMP\EST081B.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMA"      
   TcSetField("TMA","ZA1_DATA","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA1_CDATA","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA1_DTINI","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA1_DTFIM","D")  // Muda a data de string para date    
   TcSetField("TMA","ZA2_DATA","D")  // Muda a data de string para date    


Processa( {|| fRptDet() }, "Aguarde Imprimindo...")

Return
   

Static Function fRptDet()
Local oPrint
Local i 			
Local lin 			:= 500
Local _cDescSe
Local _nLinha

_aTipon := {"A=Ativo Diferido - Gastos Pre-Operacionais",;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma")}


Private oFont16, oFont08, oFont10,oFont12, oFontCou08
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif


oFont05		:= TFont():New("Arial" ,06,06,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial" ,08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial" ,12,12,,.F.,,,,.T.,.F.)
oFont12B	:= TFont():New("Arial" ,12,12,,.T.,,,,.T.,.F.)
oFont16		:= TFont():New("Arial" ,16,16,,.T.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

oPrint := TMSPrinter():New( "SOLICITACAO DE ABERTURA DE OS") 
oPrint:SetPortrait()
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...
oPrint:StartPage() 		// Inicia uma nova pagina


oPrint:SayBitmap(150,1050, cStartPath+"\Whbl.bmp",340,170)
oPrint:Say(320,800,"WHB COMPONENTES AUTOMOTIVOS S/A",oFont12B)

oPrint:Say(470,700,OemToAnsi("SOLICITAÇÃO DE ABERTURA DE OS"),oFont16) //OemToAnsi("SOLICITAÇÃO DE ABERTURA DE OS")
TMA->(Dbgotop())
_ctipon := IIf(TMA->ZA1_TIPO$"A",_aTipon[1],IIf(TMA->ZA1_TIPO$"C",_aTipon[2],IIf(TMA->ZA1_TIPO$"F",_aTipon[3],IIf(TMA->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         

While TMA->(!EOF())

	If lin > 2720
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 500
	Endif
	
	lin += 90

    oPrint:Line( 450, 01900, 450, 2300 )   	// horizontal para diretoria
    oPrint:Line( 450, 1900, 550, 1900 )   	// vertical  
    oPrint:Line( 550, 1900, 550, 2300 )   	// horizontal
    oPrint:Line( 450, 02300, 550, 2300 )    // vertical
	
	oPrint:Say(400,1950,"Numero OS",oFont12)

  	oPrint:Say(470,2030,TMA->ZA1_NUM,oFont12B)	
	//Box Itens
   // oPrint:Box( 550, 1900, 450, 2300 )
   	lin += 150
	oPrint:Say(lin,350,Subs(_ctipon,3,len(_cTipon)),oFont12B)
    lin += 100                                             	
  	oPrint:Say(lin,350,OemToAnsi("Conta Contabil:"),oFont12)
  	If !Empty(TMA->ZA1_CONTA)
  	   oPrint:Say(lin,650,OemToAnsi(TMA->ZA1_CONTA),oFont12)
  	   oPrint:Say(lin,0980,OemToAnsi(TMA->CT1_DESC01),oFont12)
  	   
    Endif
	lin += 90
  	oPrint:Say(lin,350,OemToAnsi("Responsável:"),oFont12)
  	oPrint:Say(lin,650,TMA->ZA1_RESP+" " + TMA->QAA_NOME,oFont12)  	
	lin += 90

  	oPrint:Say(lin,350,OemToAnsi("Data Inicio:"),oFont12)
    oPrint:Say(lin,650,Dtoc(TMA->ZA1_DTINI),oFont12)  	
 	oPrint:Say(lin,1500,OemToAnsi("Previsão Término:"),oFont12)
    oPrint:Say(lin,1900,Dtoc(TMA->ZA1_DTFIM),oFont12) 	
	lin += 90

 	oPrint:Say(lin,350,OemToAnsi("Centro de Custo:"),oFont12)
 	oPrint:Say(lin,0700,OemToAnsi(Alltrim(TMA->ZA1_CC)),oFont12) 	
 	oPrint:Say(lin,0880,OemToAnsi(TMA->CTT_DESC01),oFont12) 	
 	
	lin += 100   
  	oPrint:Say(lin,350,OemToAnsi("Descrição da O.S."),oFont12B)
  	oPrint:Say(lin,1500,OemToAnsi("Data Solicitação da O.S.:"),oFont12)
  	oPrint:Say(lin,2000,Dtoc(TMA->ZA1_DATA),oFont12B)   
  	
  	ZA1->(Dbgoto(TMA->R_E_C_N_O_))         
	_nLinha = MlCount(Lower(Alltrim(ZA1->ZA1_DESC)))
                                                 
		for i:= 1 to _nLinha
		   lin += 70
             	oPrint:Say(lin,350,OemToAnsi(MemoLine(ZA1->ZA1_DESC,90,i)),oFont12)
       next i 

 	
	lin += 160
	
 	oPrint:Say(lin,350,OemToAnsi("Valor Estipulado Mat:"),oFont12)
 	oPrint:Say(lin,750,Transform(TMA->ZA1_VLESMA, "@E 9,999,999,999.99"),oFont12) 	
	oPrint:Say(lin,1500,OemToAnsi("Valor Aprovado Mat:"),oFont12)           
	If TMA->ZA1_VLAPMA > 0            
       oPrint:Say(lin,1900,Transform(TMA->ZA1_VLAPMA, "@E 9,999,999,999.99"),oFont12) 			
    Else   
	    oPrint:Line( lin+50, 1900, lin+50, 2350 )   	// horizontal para diretoria
	Endif    

	lin += 90
 	oPrint:Say(lin,350,OemToAnsi("Valor Estipulado M.O:"),oFont12)
 	oPrint:Say(lin,750,Transform(TMA->ZA1_VLESMO, "@E 9,999,999,999.99"),oFont12) 	 	
	oPrint:Say(lin,1500,OemToAnsi("Valor Aprovado M.O.:"),oFont12)
    If TMA->ZA1_VLAPMO > 0            	
 	   oPrint:Say(lin,1900,Transform(TMA->ZA1_VLAPMO, "@E 9,999,999,999.99"),oFont12) 		
 	Else
	    oPrint:Line( lin+50, 1900, lin+50, 2350 )   	// horizontal para diretoria 	
 	Endif   
//---------------------------------------------     
	
    If TMA->ZA1_OSCOMP$"S"  //OS complementar sim			
       lin += 150
	   oPrint:Say(lin,0200,OemToAnsi("O.S. COMPLEMENTAR"),oFont12B)
       oPrint:Say(lin,1300,OemToAnsi("Data Solicitação O.S. Complementar:"),oFont12)
  	   oPrint:Say(lin,2050,Dtoc(TMA->ZA1_CDATA),oFont12B)

	   
       oPrint:Box( 1950, 0150, 2300, 2300 )                                            
	   lin += 130    
       oPrint:Say(lin,350,OemToAnsi("Valor Estipulado Mat:"),oFont12)
 	   oPrint:Say(lin,750,Transform(TMA->ZA1_VLCEMA, "@E 9,999,999,999.99"),oFont12) 	
	   oPrint:Say(lin,1500,OemToAnsi("Valor Aprovado Mat:"),oFont12)           
	   If TMA->ZA1_VLCAMA > 0            
          oPrint:Say(lin,1900,Transform(TMA->ZA1_VLCAMA, "@E 9,999,999,999.99"),oFont12) 			
       Else   
	      oPrint:Line( lin+50, 1900, lin+50, 2250 )   	// horizontal para diretoria
	   Endif    

	   lin += 90
 	   oPrint:Say(lin,350,OemToAnsi("Valor Estipulado M.O:"),oFont12)
 	   oPrint:Say(lin,750,Transform(TMA->ZA1_VLCEMO, "@E 9,999,999,999.99"),oFont12) 	 	
	   oPrint:Say(lin,1500,OemToAnsi("Valor Aprovado M.O.:"),oFont12)
       If TMA->ZA1_VLCAMO > 0            	
 	      oPrint:Say(lin,1900,Transform(TMA->ZA1_VLCAMO, "@E 9,999,999,999.99"),oFont12) 		
 	   Else
	      oPrint:Line( lin+50, 1900, lin+50, 2250 )   	// horizontal para diretoria 	
 	   Endif   
    Endif
    
//----------------------------------------------
    If TMA->ZA1_OSCOMP$"S"  //OS complementar sim			
       lin += 670    
    Else
	   lin += 1000
	Endif   
    oPrint:Line( lin, 0200, lin, 1100 )   	// horizontal para gerencia
    oPrint:Line( lin, 01300, lin, 2200 )   	// horizontal para diretoria
   	lin += 10
 	oPrint:Say(lin,500,OemToAnsi("Gerência"),oFont12)    
	oPrint:Say(lin,1700,OemToAnsi("Diretoria"),oFont12)
	lin += 90

	TMA->(DbSkip())

Enddo
  TMA->(DbCloseArea())                  
  oPrint:EndPage() 		// Finaliza a pagina              
  oPrint:Preview()  		// Visualiza antes de imprimir  
Return Nil


Static Function Cabecalho(oPrint,i)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina

Return
//*************************************
//*************************************
//*************************************
//*************************************
/// Imprime detalhes da O.S.
User Function fSolDet2()

//oPrint	:= TMSPrinter():New(OemToAnsi("SOLITAÇÃO DE ABERTURA DE OS")) 

//oPrint:SetPortrait()

//colocar consulta
Processa( {|| fGera1()   },"Gerando Dados para a Impressao")

Return Nil

Static Function fGera1()
   cQuery := "SELECT ZA1.R_E_C_N_O_,ZA2.*,ZA1.*,QAA.QAA_NOME,CTT.CTT_DESC01,SC1.C1_NUM,SC1.C1_ITEM "
   cQuery += " FROM " +  RetSqlName( 'ZA1' ) +" ZA1, " +  RetSqlName( 'ZA2' ) +" ZA2, " +   RetSqlName( 'QAA' ) +" QAA,"  +   RetSqlName( 'SC1' ) +" SC1, "  +   RetSqlName( 'CTT' ) +" CTT "
   cQuery += " WHERE ZA1.ZA1_FILIAL = '" + xFilial("ZA1")+ "'"    
   cQuery += " AND ZA2.ZA2_FILIAL = '" + xFilial("ZA2")+ "'" 
   cQuery += " AND QAA.QAA_FILIAL = '" + xFilial("QAA")+ "'"    
   cQuery += " AND SC1.C1_FILIAL = '" + xFilial("SC1")+ "'"       
   cQuery += " AND CTT.CTT_FILIAL = '" + xFilial("CTT")+ "'"          
   cQuery += " AND ZA1.ZA1_NUM = '" + ZA1->ZA1_NUM +"' " 
   cQuery += " AND ZA1.ZA1_CC  = CTT.CTT_CUSTO "
   cQuery += " AND ZA1.ZA1_NUM *= ZA2.ZA2_NUM "
   cQuery += " AND ZA1.ZA1_RESP = QAA.QAA_MAT "   
   cQuery += " AND ZA1.ZA1_NUM = SC1.C1_NUMOS "      
   cQuery += " AND ZA1. D_E_L_E_T_ = ' ' AND ZA2. D_E_L_E_T_ = ' ' AND SC1. D_E_L_E_T_ = ' ' "
   cQuery += " AND CTT. D_E_L_E_T_ = ' ' AND QAA. D_E_L_E_T_ = ' ' "               
   cQuery += " ORDER BY SC1.C1_FILIAL,SC1.C1_NUM,SC1.C1_ITEM ASC"    

//   MemoWrit('C:\TEMP\EST081C.SQL',cQuery)
   //TCQuery Abre uma workarea com o resultado da query
   TCQUERY cQuery NEW ALIAS "TMB"      
   TcSetField("TMB","ZA1_DATA","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA1_CDATA","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA1_DTINI","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA1_DTFIM","D")  // Muda a data de string para date    
   TcSetField("TMB","ZA2_DATA","D")  // Muda a data de string para date    


Processa( {|| fRptDet1() }, "Aguarde Imprimindo...")

Return
   

Static Function fRptDet1()
Local oPrint
Local i 			:= 1
Local lin 			:= 500
Local _cDescSe
Local _nLinha
Local _nx
Local _aOSAtiv      := {}
_nSaldo := 0
_cConta := Space(50)
_aTipon := {"A=Ativo Diferido - Gastos Pre-Operacionais",;
             OemToAnsi("C=Compra de Material - Construções"),;
             OemToAnsi("F=Ferramental - Faturado p/ cliente"),;
             OemToAnsi("I=Instalações de Novas Máquinas"),;             
             OemToAnsi("P=Projeto de Melhoria,Ampliação Produção, Adequação da Linha, Reforma")}


Private oFont16, oFont08, oFont10,oFont12, oFontCou08
Private cStartPath 	:= GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif


oFont05		:= TFont():New("Arial" ,06,06,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial" ,08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial" ,12,12,,.F.,,,,.T.,.F.)
oFont12B	:= TFont():New("Arial" ,12,12,,.T.,,,,.T.,.F.)
oFont16		:= TFont():New("Arial" ,16,16,,.T.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)

oPrint := TMSPrinter():New( "Detalhes da Ordem de Sevico do Ativo") 
oPrint:SetPortrait()
oPrint:Setup()//chama janela para escolher impressora, orientacao da pagina etc...
oPrint:StartPage() 		// Inicia uma nova pagina

TMB->(Dbgotop())
oPrint:SayBitmap(015,0015, cStartPath+"\Whbl.bmp",328,082)
//oPrint:Say(320,800,"WHB COMPONENTES AUTOMOTIVOS S/A",oFont12B)
oPrint:Say(070,2120,"Pag:",oFont10 ) //"Pagina :"
oPrint:Say(070,2220,StrZero(i,3),oFont10)
oPrint:Say(170,040,"Data:",oFont12)
oPrint:Say(170,140,Dtoc(dDatabase),oFont12) 
oPrint:Say(170,700,OemToAnsi("DETALHES DA ORDEM DE SERVIÇO DO ATIVO"),oFont12B)
oPrint:Say(170,2070,"Hora:",oFont12 ) //"Pagina :"
oPrint:Say(170,2165,Subs(Time(),1,5),oFont12)

oPrint:Say(310,040,OemToAnsi("Data Inicio:"),oFont12B)
oPrint:Say(310,280,Dtoc(TMB->ZA1_DTINI),oFont12)  	
oPrint:Say(310,500,OemToAnsi("Previsão Término:"),oFont12B)
oPrint:Say(310,880,Dtoc(TMB->ZA1_DTFIM),oFont12) 	
oPrint:Say(310,1500,"Valor Total OS :"+Transform(TMB->ZA1_VLAPMA+TMB->ZA1_VLCAMA + TMB->ZA1_VLAPMO+TMB->ZA1_VLCAMO,"@e 9,999,999,999.99"),oFont12B)
_nSaldo  := TMB->ZA1_VLAPMA+TMB->ZA1_VLCAMA + TMB->ZA1_VLAPMO+TMB->ZA1_VLCAMO
_nSalTot := _nSaldo
_ctipon := IIf(TMB->ZA1_TIPO$"A",_aTipon[1],IIf(TMB->ZA1_TIPO$"C",_aTipon[2],IIf(TMB->ZA1_TIPO$"F",_aTipon[3],IIf(TMB->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         

oPrint:Say(400,050,"Numero OS:",oFont12)        
oPrint:Say(400,300,TMB->ZA1_NUM,oFont12B)	
oPrint:Say(400,750,OemToAnsi("Conta Contabil:"),oFont12)
If !Empty(TMB->ZA1_CONTA)
 	oPrint:Say(400,1060,OemToAnsi(Alltrim(TMB->ZA1_CONTA)+"-"+Subs(TMB->ZA1_DCONTA,1,40) ),oFont12B)
   _cConta  := OemToAnsi(Alltrim(TMB->ZA1_CONTA)+"-"+Subs(TMB->ZA1_DCONTA,1,40)) 	
Endif
_dDtini  := Dtoc(TMB->ZA1_DTINI)
_dDtfim  := Dtoc(TMB->ZA1_DTFIM)
//_nVlr    :=
_cOS     := TMB->ZA1_NUM
oPrint:Box( 460, 0030, 3000, 2300 )
oPrint:Say(490,040,OemToAnsi("Dt Digitação  Nota          Fornecedor                                                                                                           Valor"),oFont12B)
                         
Lin := 490
SC7->(DbsetOrder(22))//C7_FILIAL+C7_NUMSC+C7_ITEMSC
SD1->(DbsetOrder(13))

While TMB->(!EOF())

//    oPrint:Line( 450, 01900, 450, 2300 )   	// horizontal para diretoria
//    oPrint:Line( 450, 1900, 550, 1900 )   	// vertical  
//    oPrint:Line( 550, 1900, 550, 2300 )   	// horizontal
//    oPrint:Line( 450, 02300, 550, 2300 )    // vertical
	
	//Box Itens
   // oPrint:Box( 550, 1900, 450, 2300 )
   
    If !Empty(TMB->C1_NUM)
       
       If SC7->(Dbseek(xFilial("SC7")+TMB->C1_NUM+TMB->C1_ITEM)) //filial + num SC + Item SC

          If SD1->(Dbseek(xFilial("SD1")+SC7->C7_NUM+SC7->C7_ITEM)) //Filial + num pedido + item pedido       
        
             _nx := Ascan(_aOSAtiv, {|x| x[1]== SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA})
          	 If _nx <> 0
                _aOSAtiv[_nx][4] += (SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM
             Else 
                Aadd(_aOSAtiv,{SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,Dtoc(SD1->D1_DTDIGIT),"N",(SD1->D1_TOTAL+SD1->D1_VALIPI)-SD1->D1_VALICM,.F.})               
             Endif   

          Else
             _nx := Ascan(_aOSAtiv, {|x| x[1]== SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA})
          	 If _nx <> 0
                _aOSAtiv[_nx][4] += SC7->C7_TOTAL   
             Else 
                Aadd(_aOSAtiv,{SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA,Dtoc(SC7->C7_EMISSAO),"P",SC7->C7_TOTAL,.F.})          	 
             Endif
          
          Endif
       
       Endif 
    Endif
    
	TMB->(DbSkip())

Enddo      

For _nx:= 1 to Len(_aOSAtiv)

	If lin > 2920
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho1(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 490
	Endif
    lin += 70
    oPrint:Say(lin,060,_aOSAtiv[_nx][2],oFont12)
    oPrint:Say(lin,280,_aOSAtiv[_nx][3],oFont12B)                     	 
    If _aOSAtiv[_nx][3]$"N"
       oPrint:Say(lin,310,Subs(_aOSAtiv[_nx][1],1,6)+"-"+Subs(_aOSAtiv[_nx][1],7,3),oFont12)                     	 
       If SA2->(Dbseek(xFilial("SA2")+Subs(_aOSAtiv[_nx][1],10,8))) //Filial + fornece + loja
          oPrint:Say(lin,520,SA2->A2_NOME,oFont12)             
       Endif 
    Else
       oPrint:Say(lin,310,Subs(_aOSAtiv[_nx][1],1,6),oFont12)                     	 
       If SA2->(Dbseek(xFilial("SA2")+Subs(_aOSAtiv[_nx][1],7,8))) //Filial + fornece + loja
          oPrint:Say(lin,520,SA2->A2_NOME,oFont12)             
       Endif 
    
    Endif		   
    oPrint:Say(lin,1950,Transform(_aOSAtiv[_nx][4],"@e 9,999,999,999.99"),oFont12)
    _nSaldo -= _aOSAtiv[_nx][4] // diminui as entradas referentes a OS

Next _nx
  
lin += 100
oPrint:Say(lin,0520,"O Saldo da O.S. é : "+Transform(_nSaldo,"@e 9,999,999,999.99"),oFont12B)
TMB->(DbCloseArea())                  
oPrint:EndPage() 		// Finaliza a pagina              
oPrint:Preview()  		// Visualiza antes de imprimir  

Return Nil


Static Function Cabecalho1(oPrint,i)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina
//oPrint:Say(171,1800,"Pag:",oFont08 ) //"Pagina :"
//oPrint:Say(171,1950,StrZero(i,3),oFont08)
oPrint:SayBitmap(015,0015, cStartPath+"\Whbl.bmp",328,082)
//oPrint:Say(320,800,"WHB COMPONENTES AUTOMOTIVOS S/A",oFont12B)
oPrint:Say(070,2120,"Pag:",oFont10 ) //"Pagina :"
oPrint:Say(070,2220,StrZero(i,3),oFont10)
oPrint:Say(170,040,"Data:",oFont12)
oPrint:Say(170,140,Dtoc(dDatabase),oFont12) 
oPrint:Say(170,700,OemToAnsi("DETALHES DA ORDEM DE SERVIÇO DO ATIVO"),oFont12B)
oPrint:Say(170,2070,"Hora:",oFont12 ) //"Pagina :"
oPrint:Say(170,2165,Subs(Time(),1,5),oFont12)

oPrint:Say(310,040,OemToAnsi("Data Inicio:"),oFont12B)
oPrint:Say(310,280,_dDtini,oFont12)  	
oPrint:Say(310,500,OemToAnsi("Previsão Término:"),oFont12B)
oPrint:Say(310,880,_dDtfim,oFont12) 	
oPrint:Say(310,1500,"Valor Total OS :"+Transform(_nSalTot,"@e 9,999,999,999.99"),oFont12B)
//_nSaldo := TMB->ZA1_VLAPMA+TMB->ZA1_VLCAMA
_ctipon := IIf(TMB->ZA1_TIPO$"A",_aTipon[1],IIf(TMB->ZA1_TIPO$"C",_aTipon[2],IIf(TMB->ZA1_TIPO$"F",_aTipon[3],IIf(TMB->ZA1_TIPO$"I",_aTipon[4],_aTipon[5]))))  //Cliente         

oPrint:Say(400,050,"Numero OS:",oFont12)        
oPrint:Say(400,300,_cOS,oFont12B)	
oPrint:Say(400,750,OemToAnsi("Conta Contabil:"),oFont12)
If !Empty(_cConta)
 	oPrint:Say(400,1060,_cConta,oFont12B)
Endif
oPrint:Box( 460, 0030, 3000, 2300 )
oPrint:Say(490,040,OemToAnsi("Dt Digitação  Nota          Fornecedor                                                                       Valor"),oFont12B)


Return

