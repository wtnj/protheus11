/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ EST0137  ³  Autor ³ João Felipe da Rosa    Data ³ 11/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controle de Orderm de Liberação de Recebimento             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Expedição/ PCP / Controladoria / Portaria                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"

User Function nhest137()

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Ordem de Liberação de Recebimento Pela Portaria")
aRotina := {{ "Pesquisa"    ,"AxPesqui"    ,  0 , 1},;
            { "Visualizacao",'U_EST137(2)'  , 0 , 2},;
            { "Portaria"    ,'U_EST137(8)' , 0,3}}

mBrowse( 6, 1,22,75,"ZB8",,,,,,fCriaCor())
Return

Static Function fCriaCor()       

Local aLegenda :=	{	{"BR_VERMELHO", "Fechado"  },;
  						{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZB8_HRPORT <> " "', aLegenda[1][1] } )
Aadd(uRetorno, { 'ZB8_HRPORT =  " "', aLegenda[2][1] } )

Return(uRetorno)

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"

User Function EST137(cPar01)
SetPrvt("_cDoc,_cCli,_dData,_cHora,_cTransp,_cMot,_cRG,_cPCam,_cPCar,_x,_lPrim,_dDataEn,_cHoraEn,_cNFExc")
SetPrvt("nMax,aHeader,aCols,oMultiline,cQuery,cQuery1,oBtMed,aMed,nLdlg,nCdlg,_SolNor,nI,_aPri,_cPri")  
SetPrvt("_cPar,_cConNom,_dConDat,_cConHor,_cPorNom,_dPorDat,_cPorHor,_cObs,_lNFExc")
SetPrvt("_cTPCarg,_cFrete,_nValFre,_nValPed,_nValICM,_dDtEntr,_cHrEntr,_cLacre,_Linha,_cObsexp,_cHrJan,_cDesCli")

ALERT('NAO UTILIZAR') 

RETURN

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  
_lNFExc  := .F.
 nMax    := 1        
 _cDoc   := ZB8->ZB8_DOC
_cCli    := Space(37)
_cDesCli := Space(30)
_cNFExc  := Space(20)
_dData   := date()
_cHora   := time()   
_cTransp := Space(30)
_cMot    := Space(30)
_cRG     := Space(10)
_cPCam   := Space(08)
_cPCar   := Space(08)
_cDesc   := Space(30)
_cProd   := Space(15)  

_dConDat := Space(08)
_cConHor := Space(05)  
_cConNom := Space(30)
_cObs    := Space(100)
_dPorDat := Space(08)
_cPorHor := Space(05)  
_cPorNom := Space(30)
_dDataEn := Space(08)
_cHoraEn := Space(05)               
_cTPCarg := Space(10)
_cFrete  := Space(06)
_nValFre := 0        
_nValPed := 0                             
_nValICM := 0        
_dDtEntr := Space(08)
_cHrEntr := Space(05)  
_cLacre  := Space(50)
_cHrJan  := Space(05)
_cObsexp := Space(100)
_cPar    := cPar01 // receber visualizaçao ou impressao      
_lPrim   := .F.
_aPri    := {" ","1","2" ,"3","4","5","6","7","8","9","10","11","12"}
_cPri    := " "

Private nOpc   := 0
Private bOk    := {||nOpc:=1,_SolNor:End()}
Private bCancel:= {||nOpc:=0,_SolNor:End()} 
Private cPerg := "EST021"                                

Processa({|| Gerando1() }, OemToAnsi("Ordem de Liberação"))

   TMP->(DbCloseArea())

Return

Static Function Gerando1()
	cQuery := "SELECT A4_NOME, B1.B1_DESC, ZB8.*, ZB9.*, A2.A2_NOME"
	cQuery += " FROM "+RetSqlName('ZB8')+" ZB8, "+RetSqlName("ZB9")+" ZB9, "
	cQuery += RetSqlName("SA4")+" A4,"+RetSqlName("SA2")+" A2, "+RetSqlName("SB1")+" B1"
	cQuery += " WHERE ZB8.ZB8_DOC = '"+ _cDoc +"' "
	cQuery += " AND ZB8.ZB8_TRANSP = A4.A4_COD"
	cQuery += " AND A2.A2_COD = ZB8.ZB8_FORNEC"
	cQuery += " AND ZB8.ZB8_DOC = ZB9.ZB9_DOC"
    cQuery += " AND ZB9.ZB9_COD = B1.B1_COD"
    cquery += " AND A2.A2_LOJA = ZB8.ZB8_LOJA"
	cQuery += " AND ZB8.D_E_L_E_T_ = '' AND ZB8.ZB8_FILIAL = '"+xFilial("ZB8")+"'"
	cQuery += " AND ZB9.D_E_L_E_T_ = '' AND ZB9.ZB9_FILIAL = '"+xFilial("ZB9")+"'"
	cQuery += " AND A4.D_E_L_E_T_  = '' AND A4.A4_FILIAL   = '"+xFilial("SA4")+"'"
	cQuery += " AND A2.D_E_L_E_T_  = '' AND A2.A2_FILIAL   = '"+xFilial("SA2")+"'"
	cQuery += " AND B1.D_E_L_E_T_  = '' AND B1.B1_FILIAL   = '"+xFilial("SB1")+"'"
	cQuery += " ORDER BY ZB8.ZB8_FILIAL,ZB8.ZB8_DOC ASC"    

	//TCQuery Abre uma workarea com o resultado da query
	MemoWrit('C:\TEMP\EST137.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"      
	TcSetField("TMP","ZB8_DATAEN","D")  // Muda a data de string para date    
	TcSetField("TMP","ZB8_DTCONF","D")  // Muda a data de string para date    
	TcSetField("TMP","ZB8_DTPORT","D")  // Muda a data de string para date    
	TcSetField("TMP","ZB8_DTENTR","D")  // Muda a data de string para date    

DbSelectArea("TMP")
TMP->(DBGotop())
If Empty(TMP->ZB8_DOC)
   TMP->(DbCloseArea()) //Fecha a area da consulta
   DbClearFil(NIL)
   IF ZB8->(Dbseek(xFilial("ZB8")+_cDoc))
      SA2->(DbSetOrder(1))
      If SA2->(DbSeek(xFilial("SA2")+ZB8->ZB8_FORNEC+ZB8->ZB8_LOJA))
         _cDesCli := SA2->A2_NOME
      Endif

      fGerNFEx()
      _lNFExc := .T.
   Else
      MsgBox("Nenhuma Ordem de Liberação Encontrada","Atençao","ALERT") 
      DbSelectArea("TMP")
      DbCloseArea()
      return
   Endif   
Endif

//Alert("nhEST039  "+Strzero(paramixb,1))
If _cPar == 2 .Or. _cPar == 5 .Or. _cPar == 9 //visualização ou exclusão ou frete/entrega
   Processa( {|| fRptDet() }, "Aguarde Pesquisando...")
Elseif _cPar == 6   
   Processa( {|| fRelOrd() }, "Aguarde Imprimindo...")
Elseif _cPar == 8   
   Processa( {|| fPortari() }, "Aguarde Gravando...")      
Endif   

Return


Static Function fGerNFEx() 
//Local cQuery1   

   cQuery1 := "SELECT SA4.A4_NOME,SB1.B1_DESC,ZB8.*,ZB9.* "
   cQuery1 += "FROM " +  RetSqlName( 'ZB8' ) +" ZB8, " +  RetSqlName( 'ZB9' ) +" ZB9, "+ RetSqlName( 'SB1' ) +" SB1, "
   cQuery1 += RetSqlName( 'SA4' ) +" SA4 "
   cQuery1 += " WHERE ZB8.ZB8_FILIAL = '" + xFilial("ZB8")+ "'" 
   cQuery1 += " AND ZB9.ZB9_FILIAL = '" + xFilial("ZB9")+ "'" 
   cQuery1 += " AND SB1.B1_FILIAL = '" + xFilial("SB1")+ "'"    
   cQuery1 += " AND SA4.A4_FILIAL = '" + xFilial("SA4")+ "'"    
   cQuery1 += " AND ZB8.ZB8_DOC = '" + _cDoc + "' "                                                                                                   
   cQuery1 += " AND ZB8.ZB8_DOC = ZB9.ZB9_DOC" 
   cQuery1 += " AND ZB9.ZB9_COD = SB1.B1_COD"
   cQuery1 += " AND ZB8.ZB8_TRANSP = SA4.A4_COD"
   cQuery1 += " AND ZB8. D_E_L_E_T_ = ' ' AND ZB9. D_E_L_E_T_ = ' '" 
   cQuery1 += " AND SB1. D_E_L_E_T_ = ' '" 
   cQuery1 += " AND SA4. D_E_L_E_T_ = ' '" 
   cQuery1 += " ORDER BY ZB8.ZB8_FILIAL,ZB8.ZB8_DOC ASC"    


//TCQuery Abre uma workarea com o resultado da query
//MemoWrit('C:\TEMP\EST137a.SQL',cQuery1)
TCQUERY cQuery1 NEW ALIAS "TMP"      
TcSetField("TMP","ZB8_DATAEN","D")  // Muda a data de string para date    
TcSetField("TMP","ZB8_DTCONF","D")  // Muda a data de string para date    
TcSetField("TMP","ZB8_DTPORT","D")  // Muda a data de string para date    
TcSetField("TMP","ZB8_DTENTR","D")  // Muda a data de string para date    

Return

Static Function fRptDet()
aHeader     := {}
aCols       := {}
_cCli       := Space(40)
_lPrim      := .F.

Aadd(aHeader,{"Nota"       , "UM",  "@!"                 ,10,0,".F.","","C",""}) //03
Aadd(aHeader,{"Emissao"    , "ZN_EMISSAO"  ,"99/99/9999" ,10,0,".F.","","C","ZB9"}) //06
Aadd(aHeader,{"Produto"    , "UM"  ,Repli("!",40)        ,40,0,".F.","","C",""}) //03
Aadd(aHeader,{"Quantidade" , "UM"  ,"@! 999999999999"    ,12,0,".F.","","N",""}) //03
//Aadd(aHeader,{"Volume"     , "UM",  "@!"               ,02,0,".F.","","C",""}) //03
//Aadd(aHeader,{"NF Remessa" , "ZB9_NFRET", "@!"          ,41,0,".F.","","C","ZB9"}) //03
TMP->(DBGotop())       

While !TMP->(EOF())
	  
   If !_lPrim 
	  _cDoc     := TMP->ZB8_DOC
      _cCli     := TMP->ZB8_FORNEC+"-"+TMP->ZB8_LOJA+"-"+ Iif( Empty(_cDesCli),TMP->A2_NOME,_cDesCli)

      _cTransp  := TMP->ZB8_TRANSP+"-"+TMP->A4_NOME
      _cMot     := TMP->ZB8_MOTORI
      _cRG      := TMP->ZB8_RGMOTO
      _cPCam    := TMP->ZB8_PLACCM
      _cPCar    := TMP->ZB8_PLACCR
	  _dConDat  := TMP->ZB8_DTCONF
	  _cConHor  := TMP->ZB8_HRCONF
	  _cConNom  := TMP->ZB8_CONFER
	  _dPorDat  := TMP->ZB8_DTPORT
	  _cPorHor  := TMP->ZB8_HRPORT
	  _cPorNom  := TMP->ZB8_PORTAR
	  _cObs     := TMP->ZB8_OBS
	  _cObsExp  := TMP->ZB8_OBSEXP	  
	  _dDataEn  := DtoC(TMP->ZB8_DATAEN)
      _cHoraEn  := TMP->ZB8_HORAEN
      _cPri     := TMP->ZB8_PRIORI  
      _cTPCarg  := TMP->ZB8_TPCARG
      _cFrete   := TMP->ZB8_FRETE
      _nValFre  := TMP->ZB8_VALFRE
      
      _nValPed  := TMP->ZB8_VALPED
      _nValICM  := TMP->ZB8_VALICM      
      
      _dDtEntr  := TMP->ZB8_DTENTR
      _cHrEntr  := TMP->ZB8_HRENTR  
      _cLacre   := TMP->ZB8_LACRE
      _cHrJan   := TMP->ZB8_HRJAN
	  _lPrim := .T.
   Endif 
   Aadd(aCols,{TMP->ZB9_NFISC+"-"+TMP->ZB9_SERIE,;
               DTOC(TMP->ZB8_DTCONF),;
               " "+Subs(TMP->ZB9_COD,1,15)+"-"+TMP->B1_DESC,;
               TMP->ZB9_QUANT,.F.})
   If _lNFExc
      If Alltrim(TMP->ZB9_OBS)$"EXCLUIDA"
         If !TMP->ZB9_NFISC$_cNFExc
            _cNFExc := Iif(Empty(Alltrim(_cNFExc)),TMP->ZB9_NFISC,_cNFExc+"-"+TMP->ZB9_NFISC)
         Endif
      Endif
   Endif
   TMP->(DbSkip())
	
EndDo

nMax := Len(aCols)
 
Define MsDialog _SolNor Title OemToAnsi("Ordem de Liberação de Materiais") From 015,015 To 550,750 Pixel 
@ 018,006 To 107,362 Title OemToAnsi("  Dados ") //Color CLR_HBLUE
@ 027,010 Say "Numero :" Size 030,8            
@ 025,030 Get _cDoc Picture "@!"  When .F. Size 030,8 Object oDoc            
//oDoc:SetFont(oFont)

@ 027,070 Say "Cliente:" Size 30,8            
@ 025,090 Get _cCli  Picture "@!" When .F.  Size 170,8 Object oCli

@ 027,270 Say "Data:" Size 30,8            

@ 040,010 Say "Transportadora:" Size 050,8            
@ 038,050 Get _cTransp Picture "@!" When .F. Size 120,8 Object oTransp             

@ 040,180 Say "Dt Entrada:" Size 030,8 object oDtEntrada  
@ 038,210 Get _dDataEn Picture "99/99/9999" When .F. Size 40,8 Object oDataEn
@ 040,255 Say "Hr Entrada:" Size 030,8 object oHrEntrada            
@ 038,285 Get _cHoraEn Picture "@!" When .F. Size 25,8 Object oHoraEn

@ 053,010 Say "Motorista :" Color CLR_HBLUE  Size 050,8            
@ 051,050 Get _cMot Picture "@!" When .F. Size 100,8 Object oMot             
@ 053,160 Say "RG :" Color CLR_HBLUE  Size 010,8                    
@ 051,175 Get _cRG Picture "@!" When .F. Size 050,8 Object oRG  

@ 053,230 Say "Prioridade:" Size 050,8 object oTPri  
  oTPri:Setfont(oFont10)                                          
@ 051,275 Get _cPri Picture "@!" When .F. Size 010,8 Object oPri  

@ 053,303 Say "Hr.Janela:" Size 040,8 object oHrja             
@ 051,330 Get _cHrJan Picture "99:99" When .F. Size 15,8 Object oHrJan             

@ 065,010 Say OemToAnsi("Placa Caminhão:") Color CLR_HBLUE  Size 050,8                    
@ 063,050 Get _cPCam Picture "!!!-!!!!" When .F. Size 050,8 Object oPCam             
@ 065,135 Say OemToAnsi("Placa Carreta :") Color CLR_HBLUE  Size 050,8
@ 063,175 Get _cPCar Picture "!!!-!!!!" When .F. Size 050,8 Object oPCar                                 

@ 065,255 Say "Tipo Carga:" Size 050,8 
@ 063,285 Get _cTPCarg Picture "@!" When .F. Size 040,8 Object oTPCarg  

@ 077,010 Say OemToAnsi("Num Frete :")  Size 050,8
@ 075,050 Get _cFrete Picture "@!" When(_cPar == 9) Size 035,8 Object oFrete
             
@ 077,95 Say OemToAnsi("Valor Frete :") Size 050,8
@ 075,125 Get _nValFre Picture "999,999.99" When(_cPar == 9) Size 050,8 Object oValFre

@ 077,185 Say OemToAnsi("Valor Pedagio :") Size 050,8
@ 075,220 Get _nValPed Picture "999,999.99" When(_cPar == 9) Size 050,8 Object oValPed

@ 077,280 Say OemToAnsi("Valor ICMS :") Size 050,8
@ 075,310 Get _nValICM Picture "999,999.99" When(_cPar == 9) Size 050,8 Object oValICM

@ 089,010 Say OemToAnsi("Num Lacre :") Size 050,8
@ 087,050 Get _cLacre Picture "@!" Size 125,8 Object oLacre

@ 089,180 Say OemToAnsi("Obs Exp:") Size 050,8
@ 087,210 Get _cObsexp Picture "@!" Size 150,8 Object oObsexp

@ 110,006 To 190,362 Title OemToAnsi("  Informações ")  
@ 120,015 TO 185,355 MULTILINE MODIFY OBJECT oMultiline
                   
If !Empty(_cConNom) //mostra somente se já foi lirado pelo conferente
   @ 210,010 Say "Conferente:" Color CLR_GREEN  Size 050,8            
   @ 210,050 Get UsrFullName(_cConNom) Picture "@!" When .F. Size 140,8 Object oConNom             
   @ 210,200 Say "Hora:" Color CLR_GREEN  Size 020,8            
   @ 210,220 Get _cConHor Picture "@!" When .F. Size 40,8 Object oConHor
   @ 210,290 Say "Data:" Color CLR_GREEN  Size 020,8            
   @ 210,310 Get _dConDat Picture "@!" When .F. Size 40,8 Object oConDat
Endif   

If !Empty(_cPorNom)//mostra somente se já foi lirado pela portaria
   @ 225,010 Say "Portaria :" Color CLR_GREEN  Size 050,8            
   @ 225,050 Get UsrFullName(_cPorNom) Picture "@!" When .F. Size 140,8 Object oPorNom             
   @ 225,200 Say "Hora:" Color CLR_GREEN  Size 020,8            
   @ 225,220 Get _cPorHor Picture "@!" When .F. Size 40,8 Object oPorHor
   @ 225,290 Say "Data:" Color CLR_GREEN  Size 020,8            
   @ 225,310 Get _dPorDat Picture "@!" When .F. Size 40,8 Object oPorDat
Endif   
                              
If !Empty(_cObs)//mostra somente se existe Observaçao na Ordem de liberação
   @ 240,010 Say "Obs :" Color CLR_GREEN  Size 050,8            
   @ 240,030 Get _cObs Picture "@!" When .F. Size 320,8 Object oOBS             
Endif   

oMultiline:nMax := Len(aCols) //não deixa o usuario adicionar mais uma linha no multiline
Activate MsDialog _SolNor On Init EnchoiceBar(_SolNor,bOk,bCancel,,) Centered

If _lNFExc // Verifica se a Nota amarrada a Ordem de Solicitação foi excluida

   MsgBox("A Nota  " + _cNFExc + "  Foi Excluida desta Ordem de Liberacao ","Atençao","STOP") 
   If nopc == 1 .And. _cPar <> 9 // se nao for A opcao de  Frete/entrega sai fora
      return  
   Endif   
Endif

If nopc == 1 .And. _cPar == 5 //exclusão

   ZB8->(DbsetOrder(1)) //filial+doc
   SD1->(DbsetOrder(3)) //filial+doc+serie+cliente+loja+codigo+item
   If ZB8->(Dbseek(xFilial("ZB8")+_cDoc))
      ZB9->(Dbseek(xFilial("ZB9")+_cDoc))
      If Empty(ZB8->ZB8_PORTAR)
      
            While ZB9->ZB9_DOC == _cDoc
               SD1->(Dbseek(xFilial("SD1")+ZB9->ZB9_NFISC+ZB9->ZB9_SERIE+ZB8->ZB8_FORNEC+ZB8->ZB8_LOJA+ZB9->ZB9_COD))                                
               While SD1->(!EOF()) .And. SD1->D1_DOC == ZB9->ZB9_NFISC
                  If !Empty(SD1->D1_ORDLIB) .And. SD1->D1_QUANT == ZB9->ZB9_QUANT
                     RecLock("SD1",.F.)
                        SD1->D1_ORDLIB = ' ' //libera a nota para gerar outra ordem de liberação
                     MsUnlock("SD1")       
                  Endif   
                  SD1->(Dbskip())
               Enddo   

               RecLock("ZB9",.F.)
                  ZB9->(Dbdelete())
               MsUnlock("ZB9")   
            
               ZB9->(Dbskip())
            Enddo 

            RecLock("ZB8",.F.)
               ZB8->(Dbdelete())
            MsUnlock("ZB8")   

      Endif   
   Endif   

ElseIf nopc == 1 .And. _cPar == 9 //Frete data entrega
   ZB8->(DbsetOrder(1)) //filial+doc
   If ZB8->(Dbseek(xFilial("ZB8")+_cDoc))
      Begin Transaction  
         RecLock("ZB8",.F.)
      	   ZB8->ZB8_FRETE  := _cFrete 
	       ZB8->ZB8_VALFRE := _nValFre  
	       ZB8->ZB8_VALPED := _nValPed  
	       ZB8->ZB8_VALICM := _nValICM  	       	       
	       ZB8->ZB8_DTENTR := _dDtEntr
           ZB8->ZB8_HRENTR := _cHrEntr
        MsUnlock("ZB8")   
     End Transaction
   Endif                
Endif

Return

//Gravaçao da Portaria
Static Function fPortari()
   ZB8->(DbsetOrder(1)) //filial+doc
   If ZB8->(Dbseek(xFilial("ZB8")+_cDoc))                                                                
   //verifica se realmente esta em aberto a ord. de liberação pela portaria e já foi fechada pelo conferente  
      If Empty(ZB8->ZB8_HRPORT) .And. Empty(ZB8->ZB8_HRCONF)
         If MsgBox("Ordem de Liberação numero "+ZB8->ZB8_DOC +" Nao foi Liberada pelo Conferente"+Chr(13)+;
                   "Confirma a Liberacao Mesmo Assim","Atençao","YESNO") 

	         Begin Transaction  
	            RecLock("ZB8",.F.)
	         	   ZB8->ZB8_PORTAR := __cUserID 
		           ZB8->ZB8_HRPORT := Time()
		           ZB8->ZB8_DTPORT := Date()
	            MsUnlock("ZB8")                         
			    SO5->(DbSetOrder(4))
                SO5->(Dbseek(xFilial("SO5")+TMP->ZB8_PLACCM))
                While !SO5->(EOF()) .And. TMP->ZB8_PLACCM == SO5->O5_PLACA
        
                   If Empty(SO5->O5_HORASAI)
	                  RecLock("SO5",.F.)
	  	                 SO5->O5_DTSAIDA := Date() //Data de saida do veiculo
    		             SO5->O5_HORASAI := Time() // hora de saida do veiculo         	     
	                  MsUnlock("SO5")     
                   Endif
                   exit //se achou força a saida do loop
                   SO5->(Dbskip())
                Enddo   
	         End Transaction  
	     Else
            MsgBox("Ordem de Liberação numero "+ZB8->ZB8_DOC +" Nao foi Liberada","Atençao","ALERT") 
         Endif   
      Elseif Empty(ZB8->ZB8_HRPORT)
	        
	         Begin Transaction
	            RecLock("ZB8",.F.)
	         	   ZB8->ZB8_PORTAR := __cUserID 
		           ZB8->ZB8_HRPORT := Time()
		           ZB8->ZB8_DTPORT := Date()
	            MsUnlock("ZB8")   
	         
			    SO5->(DbSetOrder(4))
                SO5->(Dbseek(xFilial("SO5")+TMP->ZB8_PLACCM))
                While !SO5->(EOF()) .And. TMP->ZB8_PLACCM == SO5->O5_PLACA
        
                   If Empty(SO5->O5_HORASAI)             
	                  RecLock("SO5",.F.)
	  	                 SO5->O5_DTSAIDA := Date() //Data de saida do veiculo
    		             SO5->O5_HORASAI := Time() // hora de saida do veiculo         	     
	                  MsUnlock("SO5")     
                      exit //se achou força a saida do loop	                  
                   Endif
                   SO5->(Dbskip())
                Enddo   
	         End Transaction  
      Endif   
   Endif                
   
Return   

Static Function fRelOrd()

//SetPrvt("NQTDE1,NQTDE2,NQTDE3,nEtq")

cString   := "ZB8"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Ordem de Liberação de Recebimento")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST137"
nLastKey  := 0
titulo    := "ORDEM DE LIBERAÇÃO DE RECEBIMENTO"
Cabec1    := " "
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1  
wnrel     := "NHEST137"
_cPerg    := "EST137" 
//aOrd      := {OemToAnsi("Por Produto"),OemToAnsi("Por Etiqueta")} // ' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '

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

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

//if aReturn[8] == 2 //ordem por etiqueta
//   Cabec1    := "COD PRODUTO    COD.CLIENTE    DESCRIÇÃO DO PRODUTO            ETIQ    DOC    ALM LOCALIZ      QTDE "
//Endif   


Processa( {|| RptDetail() },"Imprimindo...")

//Close TMP

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
Local _nVol := 0 //inicializa o total de volumes

TMP->(Dbgotop())

Cabec1 := "Num.Liberacao : "+TMP->ZB8_DOC +Space(03)+"Fornecedor : "+TMP->ZB8_FORNEC+"-"+TMP->ZB8_LOJA+"-"+Iif( Empty(_cDesCli),TMP->A2_NOME,_cDesCli ) +Space(20)+TMP->ZB8_HRCONF+Space(07)+Dtoc(TMP->ZB8_DTCONF)
Cabec(Titulo,Cabec1,"",NomeProg, Tamanho,nTipo)

@ Prow() + 1, 000 Psay OemToAnsi("Transportadora : ")+TMP->ZB8_TRANSP+"-"+TMP->A4_NOME+Space(10)+"Data Entrada:"+DtoC(TMP->ZB8_DATAEN)+"    Hora Entrada:"+TMP->ZB8_HORAEN
@ Prow() + 1, 000 Psay OemToAnsi("Placa Caminhão : ")+TMP->ZB8_PLACCM+Space(20)+" Placa Carreta :"+TMP->ZB8_PLACCR

If !Empty(TMP->ZB8_LACRE)
   @ Prow() + 1, 000 Psay OemToAnsi("Num Lacre : ")+TMP->ZB8_LACRE
Endif                                                            
If !Empty(TMP->ZB8_OBSEXP)
   @ Prow() + 1, 000 Psay OemToAnsi("Obs Expedidor: ")+TMP->ZB8_OBSEXP
Endif                                                            


_cMot    := TMP->ZB8_MOTORI
_cRG     := TMP->ZB8_RGMOTO                                                   
_dConDat := Dtoc(TMP->ZB8_DTCONF)
_cConHor := TMP->ZB8_HRCONF
_cConNom := UsrFullName(TMP->ZB8_CONFER)
_dPorDat := Dtoc(TMP->ZB8_DTPORT)
_cPorHor := TMP->ZB8_HRPORT
_cPorNom := UsrFullName(TMP->ZB8_PORTAR)
_cObs    := Alltrim(TMP->ZB8_OBS)
_cObsexp := Alltrim(TMP->ZB8_OBSEXP)

@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
@ Prow() + 1, 000 Psay OemToAnsi(" NOTA        EMISSAO       PRODUTO                                         QTDE   VOL   NF S.REMESSA")
          
_Linha = 13
While !TMP->(EOF())
if Prow() > 60
       Cabec(Titulo,Cabec1,"",NomeProg, Tamanho,nTipo)
       @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
       @ Prow() + 1, 000 Psay OemToAnsi(" NOTA        EMISSAO       PRODUTO                                         QTDE   VOL   NF S.REMESSA")
       @ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
endif
   If TMP->ZB9_COD == 'IVE18.4.0133.01' .Or. ;
      TMP->ZB9_COD == 'IVE18.4.0133.00'
		_lVerif := .T.		
   EndIf

   @ Prow() + 1, 000 Psay TMP->ZB9_NFISC+"-"+TMP->ZB9_SERIE
   @ Prow()    , 012 Psay DTOC(TMP->ZB8_DTCONF) 
   @ Prow()    , 023 Psay Subs(TMP->ZB9_COD,1,15)+"-"+TMP->B1_DESC
   @ Prow()    , 070 Psay Transform(TMP->ZB9_QUANT,"@E 9999999.99")
//   @ Prow()    , 083 Psay Transform(TMP->ZB9_VOLUME,"@E 99")   
//   @ Prow()    , 088 Psay Alltrim(TMP->ZB9_NFRET)
//   _nVol += TMP->ZB9_VOLUME //Soma todos os volumes            

   TMP->(DbSkip())
EndDo
@ Prow() + 1, 001 Psay __PrtThinLine() // Linha antes da Medição
@ Prow() + 1, 060 Psay OemToAnsi("  Total de Volumes é : ")+Strzero(_nVol,2)
@ Prow() + 1, 000 Psay OemToAnsi("Motorista : ")+Alltrim(_cMot)+Space(01)+"RG :"+_cRG
@ Prow() + 2, 000 Psay OemToAnsi("Ass. Motorista ____________________________ ")

If !Empty(_cConNom)
   @ Prow() + 2, 000 Psay OemToAnsi("Conferente:")+_cConNom
   @ Prow()    , 050 Psay OemToAnsi("Hora :")+_cConHor
   @ Prow()    , 070 Psay OemToAnsi("Data :")+_dConDat        
   If !Empty(_cObs)
      @ Prow() + 1, 000 Psay OemToAnsi("OBS :")+_cObs   
   Endif   
Endif       

If !Empty(_cPorNom)
   @ Prow() + 2, 000 Psay OemToAnsi("Portaria:")+_cPorNom
   @ Prow()    , 050 Psay OemToAnsi("Hora :")+_cPorHor
   @ Prow()    , 070 Psay OemToAnsi("Data :")+_dPorDat
Endif
If _lVerif 
	@ Prow()+2  , 000 Psay OemToAnsi("Empilhamento máximo 2        (   )")
	@ Prow()+1  , 000 Psay OemToAnsi("Cintamento da Carga/Caminhão (   )")
EndIf
  
Return(nil) 


