******************************************************


******************************************************
/* NAO UTILIZADA - SUBSTITUIDA PELA ROTINA NHMNT042 */
******************************************************


******************************************************


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST077  ³ Autor ³ Alexandre R. Bento     Data ³ 31/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Ordem de Servico p/ Dispositivos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#Include "prtopdef.ch"    
#Include "FiveWin.ch"
#Include "Folder.ch"  
#include "Topconn.ch"

User Function NhEST077()
                                           
//AXCADASTRO("ZA5","ZA5")
SetPrvt("CCADASTRO,AROTINA")
cCadastro := OemToAnsi("Ordem de Serviço de Dispositivos")
aRotina := {{ "Pesquisar"  ,"AxPesqui"       , 0 , 1},;
            { "Visualizar" ,"U_fIncDis(2)"   , 0 , 2},;   
            { "Incluir"    ,"U_fIncDis(3)"   , 0 , 3},;            
            { "Alterar"    ,"U_fIncDis(4)"   , 0 , 3},;                        
            { "Excluir"    ,"U_fIncDis(5)"   , 0 , 3},;                                    
            { "Aprovar"    ,"U_fIncDis(6)"   , 0 , 3},;                                                
            { "Imprimir"   ,"U_fIncImp()"    , 0 , 3},;                                                            
            { "Legenda"    ,"U_FLegDis"      , 0 , 2}}     

mBrowse( 6, 1,22,75,"SZW",,,,,,fCriaCor())

Return

User Function fincDis(_cPar)
Local oRadio             
Local oDlgHis                          
Local aSize := MsAdvSize()
SetPrvt("_cItem,_cResp,_cStatus,_aStatus,_lPar,_cDisp,_aOpcoes,_nPos,_cDocume,lSaida,_cDesc,_cBem,_cBemDesc")
SetPrvt("_dData,_cHora,_cProb,_cAcao,_cSolic,_dPrevi,_cHrini1,_cHrfim1,_cHrini2,_cHrfim2,_cServ,_aOS,_cOS,_cServ,_aServ,_cNome,oDesc")
SetPrvt("aCols,aHeader,_cResp1,_cNome1,_cSolNo,_cStsBem,_aStsBem,_cCC")

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  
_aStatus := {OemToAnsi("1-Parado "), OemToAnsi("2-Trabalhando Deficiente"),OemToAnsi("3-Aguardando Ferramentaria"),OemToAnsi("4-Aguardando Compra PC"),OemToAnsi("5-Pronto e Entregue") }
_aOS     := {OemToAnsi("Corretiva"), OemToAnsi("Preventiva"), OemToAnsi("Programada") }
_aServ   := {OemToAnsi("Serviço OK"), OemToAnsi("Em Andamento") }
_aStsBem := {OemToAnsi("P-Parada"),    OemToAnsi("D-Deficiente") }

/*---------------------------*/
_lPar   := _cPar 
_nPos   := 0                   
aCols   := {}
aHeader := {}
If _lPar == 3 //inclusao
   _cItem  := Space(06)                                                
   _dData  := date()
   _cHora  := Time()
   _cCC    := Space(06)
   _cBem   := Space(15)
   _cProb  := Space(100)         
   _cAcao  := Space(100)                 
   _cSolic := Space(06)       
   _cOS    := Space(01)          
   _dPrevi := Ctod("  /  /  ")                                         
   _cDesc  := Space(30) 
   _cHrini1:= "00:00"
   _cHrfim1:= "00:00"   
   _cHrini2:= "00:00"
   _cHrfim2:= "00:00"   

   _cServ  := OemToAnsi("Em Andamento")
   _cNome  := Space(30)
   _cResp  := Space(15)
   _cNome1 := Space(30)
   _cSolNo := Space(30)
   _cResp1 := Space(15)
   _cStatus:= Space(01)
   _cDisp  := Space(15)
   _citem:= GetSXENum("SZW","ZW_NUM")  // Variaveis do Cabecalho do Cadastro   
   Aadd(aCols,{"0001", Space(08),Space(15),Space(60),Space(01),0,.F. })   
ElseIf _lPar == 2 .or. _lPar == 4 .or. _lPar == 5 .or. _lPar == 6   //2= visualizacao  4= altera 5 = exclui  6 = APROVA
    If _lPar == 4 .or. _lPar == 5 .or._lPar == 6                                       
       If SZW->ZW_SERVICO$"S"
          MsgBox(OemToAnsi("O.S. Ja Esta Aprovada, Verifique !!!"),OemToAnsi("Atenção"),"INFO")      
          Return
       Endif   
    Endif
   _cItem  := SZW->ZW_NUM
   _cDisp  := SZW->ZW_CODDISP 
   _cBem   := SZW->ZW_BEM
   fBem()  // Atualiza a descrição do bem
   fDisp() // Atualiza a descrição do produto
   _cHora  := SZW->ZW_HORA
   _dData  := SZW->ZW_DATA 
   _cProb  := SZW->ZW_PROBLEM  
   _cAcao  := SZW->ZW_ACAO    
   _cSolic := SZW->ZW_SOLICIT          

   fSNome() //busca o nome do Solicitante
   If SZW->ZW_STATUS == '1'  
      _cStatus:= OemToAnsi("1-Parado ")
   Elseif SZW->ZW_STATUS == '2'
      _cStatus:= OemToAnsi("2-Trabalhando Deficiente")
   Elseif SZW->ZW_STATUS == '3'
      _cStatus:= OemToAnsi("3-Aguardando Ferramentaria")
   Elseif SZW->ZW_STATUS == '4'
      _cStatus:= OemToAnsi("4-Aguardando Compra PC")
   Elseif SZW->ZW_STATUS == '5'                                
      _cStatus:= OemToAnsi("5-Pronto e Entregue") 
   Elseif SZW->ZW_STATUS == '6'                                
      _cStatus:= OemToAnsi("6-Aprovada") 
   Endif         

   _cResp   := SZW->ZW_RESPONS
   _cResp1  := SZW->ZW_RESP
   
   fNome()  //busca o nome do resonsavel
   fNome1() //busca o nome do resonsavel
   _dPrevi  := SZW->ZW_DTPREVI
   _cHrini1 := SZW->ZW_HRINI1
   _cHrfim1 := SZW->ZW_HRFIM1
   _cHrini2 := SZW->ZW_HRINI2
   _cHrfim2 := SZW->ZW_HRFIM2
   _cServ   := Iif(SZW->ZW_SERVICO=="E","Em Andamento",OemToAnsi("Servico OK"))     
   _cOS     := Iif(SZW->ZW_TIPO=="P","Preventiva","Corretiva")     
   _cStsBem := Iif(SZW->ZW_STSBEM=="P","P-Parada","D-Deficiente")
   _cCC     :=  SZW->ZW_CC
   
   fItens() //atualiza itens
Endif  
 
Aadd(aHeader,{"Item"       , "ZA5_ITEM",   "@!"              ,04,0,".F.","","C","ZA5"}) //03
Aadd(aHeader,{"Data"       , "ZA5_DATA" ,  "99/99/99"        ,08,0,".T.","","C","ZA5"}) //06
Aadd(aHeader,{"Produto"    , "ZA5_COD"     ,Repli("!",15)    ,15,0,".T.","","C","ZA5"}) //03  
Aadd(aHeader,{"Descricao"  , "ZA5_DESCRI"  ,Repli("!",60)    ,60,0,".F.","","C","ZA5"}) //03
Aadd(aHeader,{"Almox"      , "ZA5_ALMOX"   ,"@!"             ,01,0,".T.","","C","ZA5"}) //03
Aadd(aHeader,{"Qtde"       , "ZA5_QUANT"   ,"@E 999999999.99",12,2,".T.","","N","ZA5"}) //03

Define MsDialog oDialog Title OemToAnsi("Ordem de Serviço de Dispositivos") From 0,0 TO aSize[6]-70,aSize[5] PIXEL

@ 005,005 To 148,(aSize[5]/2)-2 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 015,010 Say "Item :" Size 020,8 Object oItemn                      
@ 015,025 Say _cItem Size 035,12 Object oItem            
 oItem:Setfont(oFont)                                                   
@ 015,085 Say OemToAnsi("O.S.") Size 15,8 Object oOS                         
If _lPar==3 .Or. _lPar== 4                
   @ 013,100 COMBOBOX _cOS ITEMS _aOS SIZE 60,10 object oOrdServ         
Else
   @ 015,100 Say _cOS Color CLR_HRED SIZE 50,10 object oOrdServ         
   oOrdServ:setfont(oFont)            
Endif

@ 015,170 Say OemToAnsi("C.Custo:") Size 20,8 Object olCC
@ 013,195 Get _cCC Picture "@!" F3 "CTT" Size 35,8 When (_lPar==3 .or._lPar==4) Object oCC

@ 015,260 Say "Data:" Size 30,8 Object oData
@ 013,275 Get _dData Picture "99/99/9999" When .F. Size 35,8 Object odData

@ 030,010 Say OemToAnsi("Dispositivo:") Size 50,8 Object oIden          
@ 028,040 Get _cDisp  Picture "@!" F3 "QDH" When (_lPar==3 .or._lPar==4) Size 52,8 Valid fDisp() Object oProd
@ 028,095 Get _cDesc Picture "@!" When (.F.) Size 095,8 Object oDesc             

@ 030,200 Say OemToAnsi("Status Disp:") Size 030,8 object oStatu
If _lPar==3 .Or. _lPar== 4
   @ 028,230 COMBOBOX _cStatus ITEMS _aStatus SIZE 70,10 object oStatus
Else
   @ 030,230 Say _cStatus SIZE 110,10 Color CLR_HRED object oStatus
   oStatus:setfont(oFont10)
Endif   

@ 015,325 Say "Hora:" Size 30,8 Object oData                       
@ 013,340 Get _cHora When .F. Size 35,8 Object odData            

@ 045,010 Say OemToAnsi("Bem:") Size 50,8 Object olBem
@ 043,040 Get _cBem Picture "@!" F3 "ST9" When (_lPar==3 .or._lPar==4) Size 52,8 Valid fBem() Object oBem
@ 043,095 Get _cBemDesc Picture "@!" When (.F.) Size 095,8 Object oDescBem

@ 045,200 Say OemToAnsi("Status Bem:") Size 30,8 Object oOS                         
If _lPar==3 .Or. _lPar== 4                
   @ 043,230 COMBOBOX _cStsBem ITEMS _aStsBem SIZE 70,10 object oStsBem
Else
   @ 045,230 Say _cStsBem Color CLR_HRED SIZE 50,10 object oStsBem
   oStsBem:setfont(oFont10)
Endif

@ 060,010 Say OemToAnsi("Problema :") Size 050,8 Object oDes                         
@ 058,040 Get _cProb Picture "@!" When (_lPar==3 .or._lPar==4) Size 335,8 Valid fvazio(_cProb) Object oProb             

@ 075,010 Say OemToAnsi("Ação :") Size 050,8 object oAcao
@ 073,040 Get ocAcao VAR _cAcao MEMO When (_lPar==3 .or._lPar==4) Size 335,25 PIXEL OF oDialog

@ 105,010 Say OemToAnsi("Solicitante :") Size 050,8 Object oSolic                         

If _lPar==3 .Or. _lPar== 4                
   @ 103,040 Get _cSolic Picture "@!" F3 "QAA" Size 30,8 Valid fSnome() .and. fvazio(_cSolic) Object oSResp             
   @ 103,070 Get _cSolNo Picture "@!" When (.F.) Size 120,8 Object oSNome             
Else
   @ 103,040 Get _cSolic Picture "@!" When (.F.) Size 30,8  Object oSResp             
   @ 103,070 Get _cSolNo Picture "@!" When (.F.) Size 120,8 Object oSNome             
Endif

@ 105,210 Say OemToAnsi("Previsão:") Size 030,8 Object oPrev                         
@ 103,235 Get _dPrevi Picture "99/99/99" When (_lPar==3 .or._lPar==4) Size 40,8 Object odPrevi             
@ 105,295 Say OemToAnsi("Serviço:") Size 040,8 Object oServ                         
If _lPar==3 .Or. _lPar== 4                
   @ 105,317 Say _cServ SIZE 65,10 object oServi            
   oServi:setfont(oFont10)               
Else
   @ 105,317 Say _cServ SIZE 65,10 object oServi         
   oServi:setfont(oFont10)            
Endif   

@ 120,10 Say OemToAnsi("Responsáv.:") Size 050,8 Object oRes
If _lPar==3 .Or. _lPar== 4                
   @ 118,040 Get _cResp Picture "@!" F3 "QAA" Size 30,8 Valid fnome() .and. fvazio(_cResp) Object oResp             
   @ 118,070 Get _cNome Picture "@!" When (.F.) Size 120,8 Object oNome             
Else
   @ 118,040 Get _cResp Picture "@!" When (.F.) Size 30,8  Object oResp             
   @ 118,070 Get _cNome Picture "@!" When (.F.) Size 120,8 Object oNome             
Endif
@ 120,220 Say OemToAnsi("Hora Inicial:") Size 050,8 Object oHorai                         
@ 118,250 Get _chrini1 Picture "99:99" When (_lPar==3 .or._lPar==4) Size 15,8 Object ocHrini1             
@ 120,323 Say OemToAnsi("Hora Final:") Size 045,8 Object oHoraf            
@ 118,350 Get _cHrfim1 Picture "99:99" When (_lPar==3 .or._lPar==4) Size 15,8 Object ocHrfim1

@ 135,10 Say OemToAnsi("Responsáv.:") Size 050,8 Object oRes
If _lPar==3 .Or. _lPar== 4                
   @ 133,040 Get _cResp1 Picture "@!" F3 "QAA" Size 30,8 Valid fnome1() Object oResp1             
   @ 133,070 Get _cNome1 Picture "@!" When (.F.) Size 120,8 Object oNome1             
Else
   @ 133,040 Get _cResp1 Picture "@!" When (.F.) Size 30,8  Object oResp1             
   @ 133,070 Get _cNome1 Picture "@!" When (.F.) Size 120,8 Object oNome1             
Endif
@ 135,220 Say OemToAnsi("Hora Inicial:") Size 050,8 Object oHorai                         
@ 133,250 Get _chrini2 Picture "99:99" When (_lPar==3 .or._lPar==4) Size 15,8 Object ocHrini2             
@ 135,323 Say OemToAnsi("Hora Final:") Size 045,8 Object oHoraf            
@ 133,350 Get _cHrfim2 Picture "99:99" When (_lPar==3 .or._lPar==4) Size 15,8 Object ocHrfim2

DBSELECTAREA("ZA5")
@ 150,005 To (aSize[6]/2)-55,(aSize[5]/2)-2 Title OemToAnsi("  Informações ")                      
@ 160,010 TO (aSize[6]/2)-60,(aSize[5]/2)-7 MULTILINE MODIFY DELETE OBJECT oMultiline

@ (aSize[6]/2)-50,(aSize[5]/2)-87 BUTTON "Ok"       SIZE 040,010 ACTION fGrvDis() OBJECT oBt1
@ (aSize[6]/2)-50,(aSize[5]/2)-42 BUTTON "Cancelar" SIZE 040,010 ACTION fEnd()    OBJECT oBt2
  
Activate MsDialog oDialog Centered Valid fSaida()
If Chkfile("TMP")
   TMP->(DbCloseArea())   
Endif   
Return

User Function FOSCod()
Local lRet := .F.
   SB1->(DbsetOrder(1)) //filial+codigo produto
   If SB1->(DbSeek(xFilial("SB1")+M->ZA5_COD),Found())	
   	  lRet := .T.
   	  acols[n][4]:= SB1->B1_DESC                                  
   Else
      MsgBox(OemToAnsi("Produto não Encontrado"),OemToAnsi("Atenção"),"INFO")
	  lRet := .F.
   Endif

Return(lRet)


Static Function fItens()
Local cQuery

//Query  dos itens de mao de obra do OS
cQuery := "SELECT * "
cQuery += "FROM " +  RetSqlName( 'ZA5' )
cQuery += " WHERE ZA5_FILIAL = '" + xFilial("ZA5")+ "'"    
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND ZA5_NUM = '" + SZW->ZW_NUM + "' "   
cQuery += " ORDER BY ZA5_NUM,ZA5_ITEM"                                                                                        
   
 MemoWrit('C:\TEMP\EST077.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","ZA5_DATA","D")  // Muda a data de string para date    

TMP->(DBGOTOP())
If Empty(TMP->ZA5_NUM)//Verifica se não encontrou a solicitação de nota na visualização
   Aadd(aCols,{"0001", Space(08),Space(15),Space(60),Space(01),0,.F. })   
   TMP->(DbCloseArea())
   return
Endif 

While TMP->(!Eof())
//   Aadd(aCols,{"0001", Space(10),Space(15),Space(60),Space(01),0,.F. })   

   Aadd(aCols,{TMP->ZA5_ITEM,DTOC(TMP->ZA5_DATA),TMP->ZA5_COD,TMP->ZA5_DESCRI,TMP->ZA5_ALMOX,TMP->ZA5_QUANT,.F.})
   TMP->(Dbskip())
Enddo

Return

Static Function fvazio(_cparam)
Local _lRet := .T.
   
   If Empty(_cParam)
      MsgBox(OemToAnsi("Campos Obrigatórios em Branco"),OemToAnsi("Atenção"),"INFO")   
      _lRet := .F.
   Endif

Return(_lRet)
                          

Static Function fSNome()
Local _lRet := .T.
   QAA->(DbSetOrder(1)) //filial matricula
   If QAA->(DbSeek(xFilial("QAA")+ Alltrim(_cSolic)))
      _cSolNo := QAA->QAA_NOME                  
  	  If _lPar == 3
         ObjectMethod(oSNome, "Refresh()")         
      Endif   
   Else
      MsgBox(OemToAnsi("Matricula Não Encontrada"),OemToAnsi("Atenção"),"INFO")   
      _cSolNo := Space(30)
      _lRet := .F.
   Endif


Return(_lRet)


Static Function fNome()
Local _lRet := .T.
   QAA->(DbSetOrder(1)) //filial matricula
   If QAA->(DbSeek(xFilial("QAA")+ Alltrim(_cResp)))
      _cNome := QAA->QAA_NOME                  
  	  If _lPar == 3
         ObjectMethod(oNome, "Refresh()")         
      Endif   
   Else
      MsgBox(OemToAnsi("Matricula Não Encontrada"),OemToAnsi("Atenção"),"INFO")   
      _cNome := Space(30)      
      _lRet := .F.
   Endif


Return(_lRet)

Static Function fNome1()
Local _lRet := .T.

   If !Empty(Alltrim(_cResp1))
      QAA->(DbSetOrder(1)) //filial matricula
      If QAA->(DbSeek(xFilial("QAA")+ Alltrim(_cResp1)))
         _cNome1 := QAA->QAA_NOME                  
     	 If _lPar == 3
            ObjectMethod(oNome1, "Refresh()")         
         Endif   
      Else
         MsgBox(OemToAnsi("Matricula Não Encontrada"),OemToAnsi("Atenção"),"INFO")   
         _cNome1 := Space(30)
         _lRet := .F.
      Endif
   Endif

Return(_lRet)


Static Function fGrvHist()

   Define MsDialog oDlgHis Title OemToAnsi("Historico das Lições Aprendidas") From 100,050 To 310,570 Pixel 
   @ 110,055 To 010,245                                     
   @ 015,010 Say OemToAnsi("Vai Utilizar esta Informação em Algum Documento?") Color CLR_BLUE Size 450,8 Object oItem                        
      oItem:Setfont(oFont)                      
   @ 030,100 Say OemToAnsi("ESCOLHA UMA OPÇÃO")   Size 180,8 Object oOpcao 
   @ 045,120 Radio oRadio VAR _nPos ITEMS OemToAnsi("SIM"),OemToAnsi("NÃO") 3D SIZE 50,10 OF oDlgHis PIXEL ON Change frad() // "&Remessa" ### "R&etorno"   
   @ 090,200 BMPBUTTON TYPE 01 ACTION Close(oDlgHis)
   Activate msDialog oDlgHis Centered Valid fSaida()

   Reclock("SZP",.T.)                  
      SZP->ZP_FILIAL  := xFilial("SZP")
      SZP->ZP_ITEM    := SZO->ZO_ITEM
      SZP->ZP_DATA    := Date()
      SZP->ZP_HORA    := Time()
      SZP->ZP_LOGIN   := __cUserid	      
      If _nPos == 1
         SZP->ZP_INFORMA := "SIM"
	  Else   	                
 	     SZP->ZP_INFORMA := "NAO"
 	  Endif  
	  SZP->ZP_DOCUME  := _cDocume

		               
   MsUnlock("SZP")               	   
   Close(oDialog)

Return           


Static Function fSaida()
Local lret := .T.

   If lSaida 
      lRet := .T.
   Else
      lRet := .F.
   Endif 
   
Return(lRet)


Static Function frad()
Local lretp := .F.

   If _nPos == 1
      _nPos:= 1
      @ 067,070 Say OemToAnsi("Qual Documento :") Size 050,8 Object oDocume            
      @ 065,120 Get _cDocume Picture "@!" When (_nPos == 1) Size 70,8 Valid fDocume() Object oDocume 
      lretp := .T.            
   ElseIf _nPos == 2 
      _nPos:= 2
      @ 067,070 Say Space(200) Size 200,8 Object oSpaco
      lretp := .T.                              
      lSaida := .T. //permite fechar o dialogo
   Endif   

Return(lRetp)

Static Function fDocume()
Local lRt := .T.
   If _nPos == 1 .and. Empty(_cDocume)   
      lRt := .F.
   Else
      lSaida := .T. //permite fechar o dialogo      
   Endif   
   
Return(lRt)

Static Function fDisp()
Local lRet := .F.

	QDH->(DbSetOrder(1))
	If QDH->(DbSeek(xFilial("QDH")+_cDisp))
		lRet := .T.
		_cDesc := QDH->QDH_TITULO
		If _lPar == 3
	         ObjectMethod(oDesc, "Refresh()")         
    	Endif   
	Else
      MsgBox(OemToAnsi("Dispositivo não Encontrado"),OemToAnsi("Atenção"),"INFO")
	  lRet := .F.
	EndIf
	
	If !fVazio(_cDisp)
		Return .F.
	EndIf
	
Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ A DESCRICAO DO BEM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fBem()
	
	ST9->(DbSetOrder(1)) //filial + bem
	IF ST9->(DbSeek(xFilial("ST9")+_cBem))
		_cBemDesc := ST9->T9_NOME
		If _lPar == 3
	         ObjectMethod(oDescBem, "Refresh()")         
    	Endif
  	Else
  		MsgBox(OemToAnsi("Bem não encontrado"),OemToAnsi("Atenção"),"INFO")
  		Return .F.
  	EndIf

Return .T.

Static Function fEnd() 

	lSaida := .T. //permite fechar o dialogo

    If _lPar==3 // INCLUIR
      	RollBackSx8() //Volta a numeração da Ordem de Liberação
   	Endif                  
   
   	Close(oDialog) 

Return

Static Function fGrvDis()
       If _lPar==3	  
	      Reclock("SZW",.T.)
	         SZW->ZW_FILIAL  := xFilial("SZW")
		     SZW->ZW_NUM     := _cItem    
		     SZW->ZW_CODDISP := _cDisp
			 SZW->ZW_DATA    := _dData 		     
	         SZW->ZW_PROBLEM := _cProb
		     SZW->ZW_ACAO    := _cAcao	   
		     SZW->ZW_SOLICIT := _cSolic      
		     SZW->ZW_STATUS  := _cStatus
		     SZW->ZW_RESPONS := _cResp
		     SZW->ZW_RESP    := _cResp1		     
		     SZW->ZW_DTPREVI := _dPrevi
		     SZW->ZW_HRINI1  := _cHrini1
	   	     SZW->ZW_HRFIM1  := _cHrfim1
		     SZW->ZW_HRINI2  := _cHrini2
	   	     SZW->ZW_HRFIM2  := _cHrfim2	   	     
		     SZW->ZW_SERVICO := _cServ
		     SZW->ZW_TIPO    := _cOS
		     SZW->ZW_BEM     := _cBem
		     SZW->ZW_HORA    := _cHora
		     SZW->ZW_STSBEM  := _cStsBem
		     SZW->ZW_CC      := _cCC
	      MsUnlock("SZW")     
          For x:= 1 to Len(Acols)        
           //nao pega quando a linha esta deletada
               If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2]) .And. !Empty(Acols[x][3]) .And. !Empty(Acols[x][5])          
                  Reclock("ZA5",.T.)   
                  ZA5->ZA5_FILIAL  := xFilial("ZA5")
			      ZA5->ZA5_NUM     := _cItem           
 	              ZA5->ZA5_ITEM    := Strzero(x,4)			   
  		          ZA5->ZA5_DATA    := Iif( valtype( Acols[x][2] ) == 'C', CtoD(Acols[x][2]),Acols[x][2])
 	  			  ZA5->ZA5_COD     := Acols[x][3]
 	  			  ZA5->ZA5_DESCRI  := Acols[x][4] 	  			  
    	          ZA5->ZA5_ALMOX   := Acols[x][5]
    	          ZA5->ZA5_QUANT   := Acols[x][6]    	          
                  MsUnlock("ZA5")                                                    
               Endif    
         Next x
	      
	      ConfirmSX8()  
//          lSaida := .T. //permite fechar o dialogo	      
	   Elseif _lPar == 4
		    Reclock("SZW",.F.)
	         SZW->ZW_FILIAL  := xFilial("SZW")
		     SZW->ZW_NUM     := _cItem    		     
		     SZW->ZW_CODDISP := _cDisp
			 SZW->ZW_DATA    := _dData 		     
	         SZW->ZW_PROBLEM := _cProb
		     SZW->ZW_ACAO    := _cAcao	   
		     SZW->ZW_SOLICIT := _cSolic      
		     SZW->ZW_STATUS  := _cStatus
		     SZW->ZW_RESPONS := _cResp
		     SZW->ZW_RESP    := _cResp1		     		     
		     SZW->ZW_DTPREVI := _dPrevi
		     SZW->ZW_HRINI1  := _cHrini1
	   	     SZW->ZW_HRFIM1  := _cHrfim1
		     SZW->ZW_HRINI2  := _cHrini2
	   	     SZW->ZW_HRFIM2  := _cHrfim2	   	     
		     SZW->ZW_SERVICO := _cServ
		     SZW->ZW_TIPO    := _cOS
		     SZW->ZW_BEM     := _cBem
		     SZW->ZW_HORA    := _cHora
		     SZW->ZW_STSBEM  := _cStsBem
			 SZW->ZW_CC      := _cCC
	        MsUnlock("SZW")     
	        
	        For x:= 1 to Len(Acols)        
           //nao pega quando a linha esta deletada
            
               If ZA5->(DbSeek(xFilial("ZA5")+_cItem+Acols[x][1]))
                  Reclock("ZA5",.F.)   
                     ZA5->(DbDelete())
                  MsUnlock("ZA5")                                                    
               Endif
               
               If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][2]) .And. !Empty(Acols[x][3]) .And. !Empty(Acols[x][4]).And. !Empty(Acols[x][5])          
                  Reclock("ZA5",.T.)   
                  ZA5->ZA5_FILIAL  := xFilial("ZA5")
			      ZA5->ZA5_NUM     := _cItem           
 	              ZA5->ZA5_ITEM    := Strzero(x,4)			   
  		          ZA5->ZA5_DATA    := Iif( valtype( Acols[x][2] ) == 'C', CtoD(Acols[x][2]),Acols[x][2])
 	  			  ZA5->ZA5_COD     := Acols[x][3]
 	  			  ZA5->ZA5_DESCRI  := Acols[x][4] 	  			   	  			  
    	          ZA5->ZA5_ALMOX   := Acols[x][5]
    	          ZA5->ZA5_QUANT   := Acols[x][6]    	          
                  MsUnlock("ZA5")                                                    
               Endif    
            Next x
            

//            lSaida := .T. //permite fechar o dialogo	      
	   Elseif _lPar == 5          
	        If MsgBox(OemToAnsi("Confirma a Exclusão"),OemToAnsi("Atenção"),"YESNO")
		       Reclock("SZW",.F.)                                
		          SZW->(DbDelete())
	           MsUnlock("SZW")     
    	       For x:= 1 to Len(Acols)        
                   If ZA5->(DbSeek(xFilial("ZA5")+_cItem+Acols[x][1]))
                      Reclock("ZA5",.F.)   
                         ZA5->(DbDelete())
                      MsUnlock("ZA5")                                                    
                   Endif
               Next x
	        Endif
	   Elseif _lPar == 6                                       
	   	      	   	      
	          If SZW->ZW_STATUS = '5' .And. SZW->ZW_SERVICO$"E"
        	     QAA->(DbSetOrder(6))//lOGIN DO usuario
			     QAA->(DbSeek(alltrim(upper(cUserName))))//pega o login do usuario logado no momento
			     If QAA->(Found())//
                    If Alltrim(QAA->QAA_MAT) == Alltrim(SZW->ZW_SOLICIT) //verifica se o solicitante é igual ao aprovado
	          	       Reclock("SZW",.F.)
		                  SZW->ZW_DTAPRO  := Date()
		                  SZW->ZW_HRAPRO  := time()                  
		                  SZW->ZW_SERVICO := "S"         
		                  SZW->ZW_STATUS  := '6' // os aprovada pelo solicitante 
	                   MsUnlock("SZW")         
	                   alert(" aprovado")
	                Else
                       MsgBox(OemToAnsi("O.S. Não Pode Ser Aprovada pois o Usuário não foi o Solicitante da O.S."),OemToAnsi("Atenção"),"INFO")      	                
	                Endif  
	             Else
                    MsgBox(OemToAnsi("O.S. Não Pode Ser Aprovada pois o Usuário não esta Cadastrado no QAA Avise a Informatica"),OemToAnsi("Atenção"),"INFO")      	                	                
	             Endif    
              Else
                 MsgBox(OemToAnsi("O.S. Não Pode Ser Aprovada pois não Esta Pronta e Entregue"),OemToAnsi("Atenção"),"INFO")      
              Endif
	   
       Endif           
       lSaida := .T. //permite fechar o dialogo	      		    
       Close(oDialog)
Return
              

User Function FLegDis()       

Local aLegenda :=	{ {"BR_PRETO"   , OemToAnsi("Parado ")  },;
                      {"BR_AMARELO" , OemToAnsi("Trabalhando Deficiente") },;
                      {"BR_AZUL"    , OemToAnsi("Aguardando Ferramentaria") },;
                      {"BR_VERDE"   , OemToAnsi("Aguardando Compra PC") },;
  					  {"BR_VERMELHO", OemToAnsi("Pronto e Entregue")   },;
  					  {"BR_LARANJA", OemToAnsi("Aprovada pelo Solicitante")   }}
  					  
BrwLegenda(OemToAnsi("Ordem de Serviço de Dispositivos"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_PRETO"    , OemToAnsi("Parado")  },;
                      {"BR_AMARELO"  , OemToAnsi("Trabalhando Deficiente") },;
                      {"BR_AZUL"     , OemToAnsi("Aguardando Ferramentaria") },;
                      {"BR_VERDE"    , OemToAnsi("Aguardando Compra PC") },;
  					  {"BR_VERMELHO" , OemToAnsi("Pronto e Entregue")   },;
  					  {"BR_LARANJA"  , OemToAnsi("Aprovada pelo Solicitante")   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZW_STATUS == "1" ' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZW_STATUS == "2" ' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZW_STATUS == "3" ' , aLegenda[3][1] } )
Aadd(uRetorno, { 'ZW_STATUS == "4" ' , aLegenda[4][1] } )
Aadd(uRetorno, { 'ZW_STATUS == "5" ' , aLegenda[5][1] } )
Aadd(uRetorno, { 'ZW_STATUS == "6" ' , aLegenda[6][1] } )
Return(uRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fIncImp   ºAutor ³João Felipe da Rosa º Data ³  26/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime a OS De Dispositivos                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos / Setor de dispositivos                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fIncImp()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols    := {}                  
cString   := "SZW"
cDesc1    := OemToAnsi("Este relatório tem por objetivo")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST077"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE OS DE DISPOSISTIVOS ")                
cabec1    := OemToAnsi(" Número  Tipo       Dispositivo                                       Data       Serviço        Data Prev.  Status ")
cabec2    := ""
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST077"
_cPerg    := "EST077" 

//_nTotal   := 0  
//_nTotcol01 := 0  
//_nTotcol02 := 0  
          
// mv_ch01 -> Dt Inicio
// mv_ch02 -> Dt Fim                       
// mv_ch05 -> CC Inicio
// mv_ch06 -> CC Fim
// mv_ch03 -> Conta Inicio
// mv_ch04 -> Conta Fim 
// mv_ch07 -> Tipo Analitico / Sintetico.

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

//Pergunte(_cPerg,.F.) 


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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()
		//-----------------------------------------------------------------------
		//  monta a query para o SZW
		//-----------------------------------------------------------------------		

		cQuery := " SELECT CONVERT(TEXT,CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),SZW.ZW_ACAO))) AS 'ACAO',*,"
  		cQuery += " SZW.ZW_CODDISP, SB1.B1_DESC, QAA.QAA_MAT, QAA.QAA_NOME,SZW.R_E_C_N_O_ AS ZW_RECNO"
  		cQuery += " FROM "  +  RetSqlName( 'SZW ' ) + " SZW, " + RetSqlName( 'SB1 ' ) + " SB1, " + RetSqlName( 'QAA ' ) + " QAA "     
  		
 		cQuery += " WHERE SZW.D_E_L_E_T_ = ''"
 	 	cQuery += " AND SB1.D_E_L_E_T_ = ''" 
 	 	cQuery += " AND SZW.ZW_NUM = '"+ SZW->ZW_NUM + "'"
  		cQuery += " AND SZW.ZW_CODDISP = SB1.B1_COD"    
   		cQuery += " AND QAA.QAA_MAT = SZW.ZW_SOLICIT"
   	 	cQuery += " ORDER BY SZW.ZW_NUM" 
   		   		
   		
		MemoWrit('C:\TEMP\NHEST999.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
 	    TcSetField("TRA1","ZW_DATA","D")  // Muda a data de string para date    
 	    TcSetField("TRA1","ZW_DTPREVI","D")  // Muda a data de string para date     	    
Return



Static Function RptDetail()  
Local _nLinha

Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    

DbSelectArea('TRA1')
QAA->(DbSetOrder(1)) //filial matricula
While TRA1->( ! Eof() )
	
	if Prow() > 60
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo) 
	Endif

	 	@ Prow()+1 , 001 Psay TRA1->ZW_NUM
	 	@ Prow()   , 009 Psay Iif(SZW->ZW_TIPO=="P","Preventiva","Corretiva")
	 	@ Prow()   , 020 Psay TRA1->ZW_CODDISP  
	 	@ Prow()   , 036 Psay TRA1->B1_DESC
	 	@ Prow()   , 070 Psay DtoC(TRA1->ZW_DATA)  
		@ Prow()   , 081 Psay Iif(SZW->ZW_SERVICO=="E","Em Andamento",OemToAnsi("Serviço OK"))  
		@ Prow()   , 096 Psay DtoC(TRA1->ZW_DTPREVI)

 		If SZW->ZW_STATUS == '1'  
          @ Prow() , 108 Psay OemToAnsi("1-Parado ")
	    Elseif SZW->ZW_STATUS == '2'   
          @ Prow() , 108 Psay OemToAnsi("2-Trabalhando Deficiente")
 	    Elseif SZW->ZW_STATUS == '3'
          @ Prow() , 108 Psay OemToAnsi("3-Aguardando Ferramentaria")
        Elseif SZW->ZW_STATUS == '4'
          @ Prow() , 108 Psay OemToAnsi("4-Aguardando Compra PC")
	    Elseif SZW->ZW_STATUS == '5'
          @ Prow() , 108 Psay OemToAnsi("5-Pronto e Entregue") 
	    Elseif SZW->ZW_STATUS == '6'
          @ Prow() , 108 Psay OemToAnsi("6-Aprovada") 
        Endif      
    	@ Prow()+1 , 001 Psay "Problema:" 
	 	@ Prow()   , 011 Psay Subs(TRA1->ZW_PROBLEM,1,105)
	 	SZW->(Dbgoto(TRA1->ZW_RECNO))
		_nLinha = MlCount(Lower(Alltrim(SZW->ZW_ACAO)))

		for i:=1  to _nLinha                                           
		   If i == 1
    	      @ Prow()+1 , 001 Psay "Acao:"                                  		
    		  @ Prow()   , 006 Psay OemToAnsi(MemoLine(SZW->ZW_ACAO,100,i)) 
    	   Else
    		  @ Prow()+1   , 006 Psay OemToAnsi(MemoLine(SZW->ZW_ACAO,100,i))     	   
    	   Endif	  
		next i 	 		 	
	 	@ Prow()+1, 001 Psay "Solicitante: " +TRA1->ZW_SOLICIT
	 	@ Prow()  , 022 Psay TRA1->QAA_NOME
        @ Prow()+1, 001 Psay OemToAnsi("Responsável 1: ") 
        
        QAA->(DbSetOrder(1)) //filial matricula
   		If QAA->(DbSeek(xFilial("QAA")+ TRA1->ZW_RESPONS))
        @ Prow()   , 16 Psay QAA->QAA_MAT                 
      	Endif  
        @ Prow()  , 024 Psay OemToAnsi("Nome: ") + QAA->QAA_NOME  
        @ Prow()  , 061 Psay OemToAnsi("Hora Ini: ") + TRA1->ZW_HRINI1
	 	@ Prow()  , 078 Psay OemToAnsi("Hora Fim: ") + TRA1->ZW_HRFIM1
        @ Prow()+1, 001 Psay OemToAnsi("Responsável 2: ") 
		QAA->(DbSeek(xFilial("QAA")+ TRA1->ZW_RESP))
        @ Prow()  , 024 Psay OemToAnsi("Nome: ") + QAA->QAA_NOME  
        @ Prow()  , 061 Psay OemToAnsi("Hora Ini: ") + TRA1->ZW_HRINI2
	 	@ Prow()  , 078 Psay OemToAnsi("Hora Fim: ") + TRA1->ZW_HRFIM2
       	If ZA5->(DbSeek(xFilial("ZA5")+ TRA1->ZW_NUM))
       	      @ Prow()+1, 0001 Psay OemtoAnsi("Item") 
       	      @ Prow()  , 0008 Psay OemtoAnsi("Data") 
       	      @ Prow()  , 0020 Psay OemtoAnsi("Produto")
       	      @ Prow()  , 0036 Psay OemtoAnsi("Descrição")
       	      @ Prow()  , 0070 Psay OemtoAnsi("Almox")
       	      @ Prow()  , 0080 Psay OemtoAnsi("Qtde")
       	   While(!ZA5->(Eof()) .And. ZA5->ZA5_NUM == TRA1->ZW_NUM)
       	      @ Prow()+1, 0001 Psay ZA5->ZA5_ITEM
       	      @ Prow()  , 0008 Psay Dtoc(ZA5->ZA5_DATA)
      	      @ Prow()  , 0020 Psay ZA5->ZA5_COD
      	      @ Prow()  , 0036 Psay ZA5->ZA5_DESCRI
       	      @ Prow()  , 0072 Psay IIF(ZA5->ZA5_ALMOX$"S","SIM","NAO")       	             	             	             	      
      	      @ Prow()  , 0077 Psay Transform(ZA5->ZA5_QUANT,"@e 99999999")       	             	             	             	             	      
       	      ZA5->(DbSkip())
       	   Enddo  
       	Endif
	@ Prow()+1,000 PSAY __PrtThinLine()

    TRA1->(DbSkip())
end

Return(nil)


