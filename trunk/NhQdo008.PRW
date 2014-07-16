/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHQDO008  ³ Autor ³ Alexandre R. Bento     Data ³ 22/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Liçoes Aprendidas                                          ³±±
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

User Function NhQDO008()

If date() <= ctod('01/01/2012')
    MsgBox('ATENÇÃO: A lista de e-mail das Lições Aprendidas pode ser configurada através da opção "E-mail" existente na tela principal desta rotina! Por favor, verifique se o cadastro está correto de acordo com cada planta!  Este aviso expira em: 01/01/2012','Atenção','INFO')
Endif

SetPrvt("CCADASTRO,AROTINA")
cCadastro := OemToAnsi("Lições Aprendidas")
aRotina := {{ "Pesquisa","AxPesqui"         , 0 , 1},;
            { "Visualizacao","U_fIncLic(2)" , 0 , 2},;   
            { "Inclui"   ,"U_fIncLic(3)"    , 0 , 3},;            
            { "Altera"   ,"U_fIncLic(4)"    , 0 , 3},;                        
            { "E-mails"  ,"U_fIncLic(10)"   , 0 , 3},;                        
            { "Legenda"  ,"U_FLegLic"       , 0 , 2}}     
                                           
mBrowse( 6, 1,22,75,"SZO",,,,,,fCriaCor())

Return

User Function fincLic(nPar)
Local oRadio             
Local oDlgHis                          
SetPrvt("_cItem,_cIdent,_cDesc,_cCausa,_cAcao,_cResp,_cArea,_dDataab,_dDatafe,_cFmea,_cPla,_cFluxo,_cPcont,_cStatus,_aStatus,_aOpcao,_aOpPla,_lPar,_cProd")
SetPrvt("_aOpcoes,_nPos,_cDocume,lSaida,_cDesc1,_cCausa1,_cAcao1,_cDesc2,_cCausa2,_cAcao2")

//-- entra no cadastro de e-mails
If nPar==10
	fCadEmail()
	Return
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
_lPar := nPar 
_aOpcoes := {" SIM   "," NAO   "}
_nPos    := 0                   
_cDocume := Space(20)
_cCausa1 := Space(100)
_cCausa2 := Space(100)
_cAcao1  := Space(100)
_cAcao2  := Space(100)
_cDesc1  := Space(100)
_cDesc2  := Space(100)

_aOpcao := {"S=Sim","N=Nao"}
_aOpPla := {"","1=WHB I","2=WHB II","3=WHB III","4=WHB IV","5=WHB V","A=Alumínio"}
_cPla   := ""
  
If _lPar == 3 //inclusao
   _cNResp := ''
   _cDProd := ''
   _cIdent := Space(20)                                                
   _cDesc  := Space(300)                                                                         
   _cCausa := Space(300)
   _cAcao  := Space(300)
   _cResp  := Space(15)
   _cArea  := Space(10) 
   _dDataab:= Ddatabase
   _dDatafe:= Ddatabase
   _cFmea  := Space(01)
   _cFluxo := Space(01)
   _cPcont := Space(01)
   _cStatus:= Space(01)
   _cProd  := Space(15)
   _aOpcao := {"S=Sim","N=Nao"}

   _cItem  := GetSXENum("SZO","ZO_ITEM")  // Variaveis do Cabecalho do Cadastro   
ElseIf _lPar == 2 .or. _lPar == 4 //2= visualizacao  4= altera
   
   _cItem  := SZO->ZO_ITEM
   _cIdent := SZO->ZO_IDENTIF
   _cResp  := SZO->ZO_RESP
   _cNResp := Posicione("QAA",1,xFilial("QAA")+alltrim(_cResp),'QAA_NOME')
   _cArea  := SZO->ZO_AREA
   _dDataab:= SZO->ZO_DTABERT
   _dDatafe:= SZO->ZO_DTREAL
   _cFmea  := SZO->ZO_FMEA //=="S",1,
   _cFluxo := SZO->ZO_FLUXO
   _cPcont := SZO->ZO_PCONTRO
   _cStatus:= SZO->ZO_STATUS
   _cProd  := SZO->ZO_COD    
   _cDProd := Posicione("SB1",1,xFilial('SB1')+_cProd,'B1_DESC')
   
   _cPla   := SZO->ZO_PLANTA

   If _lPar == 4
      _cDesc  := SZO->ZO_DESCRI        
      _cCausa := SZO->ZO_CAUSA
      _cAcao  := SZO->ZO_ACAO
   Else
	  _cDesc  := SubS(SZO->ZO_DESCRI,1,100)
      _cDesc1 := SubS(SZO->ZO_DESCRI,101,100)
      _cDesc2 := SubS(SZO->ZO_DESCRI,201,100)
   
      _cCausa := Subs(SZO->ZO_CAUSA,1,100)
      _cCausa1:= Subs(SZO->ZO_CAUSA,101,100)
      _cCausa2:= Subs(SZO->ZO_CAUSA,201,100)
   
      _cAcao  := Subs(SZO->ZO_ACAO,1,100)
      _cAcao1 := Subs(SZO->ZO_ACAO,101,100)
      _cAcao2 := Subs(SZO->ZO_ACAO,201,100)
   Endif
   
Endif   
_aStatus:= {OemToAnsi("1=Ação Eficaz"),OemToAnsi("2=Ação não Implementada"),OemToAnsi("3=Ação Ineficaz")}

Define MsDialog oDialog Title OemToAnsi("Lições Aprendidas") From 010,020 To 440,800 Pixel 
@ 010,007 To 207,385 Title OemToAnsi("  Digite os Dados ") //Color CLR_HBLUE
@ 027,015 Say "Item :" Size 020,8 Object oIte
@ 027,040 Say _cItem Size 035,8 Object oItem
 oItem:Setfont(oFont)                      
@ 027,070 Say OemToAnsi("Identificação:") Size 30,8 Object oIden          
@ 025,105 Get _cIdent  Picture "@!" When (_lPar==3 .or._lPar==4) Size 85,8 Valid fvazio(_cIdent) Object oIdent

@ 027,200 Say OemToAnsi("Produto:") Size 30,8 Object oPro            
@ 025,223 Get _cProd  Picture "@!" F3 "SB1" When (_lPar==3 .or._lPar==4) Size 62,8 Valid fCodPro() Object oProd
@ 025,290 Get _cDProd Picture "@!" When .F. Size 85,8 Object oDProd

@ 040,015 Say OemToAnsi("Descrição :") Size 050,8 Object oDes                         
@ 040,050 Get _cDesc Picture "@!" When (_lPar==3 .or._lPar==4) Size 325,8 Valid fvazio(_cDesc) Object oDesc             
If nPar==2
   @ 050,050 Get _cDesc1 Picture "@!" When (.F.) Size 325,8 Valid fvazio(_cDesc1) Object oDesc1             
   @ 060,050 Get _cDesc2 Picture "@!" When (.F.) Size 325,8 Valid fvazio(_cDesc2) Object oDesc2             
Endif
   
@ 075,015 Say OemToAnsi("Causa :") Size 050,8 Object oCaus            
@ 073,050 Get _cCausa Picture "@!" When (_lPar==3 .or._lPar==4) Size 325,8 Valid fvazio(_cCausa) Object oCausa
If nPar ==2
   @ 083,050 Get _cCausa1 Picture "@!" When (.F.) Size 325,8 Valid fvazio(_cCausa1) Object oCausa1
   @ 093,050 Get _cCausa2 Picture "@!" When (.F.) Size 325,8 Valid fvazio(_cCausa2) Object oCausa2
Endif

@ 108,015 Say OemToAnsi("Ação :") Size 050,8 Object oAca                         
@ 106,050 Get _cAcao Picture "@!" When (_lPar==3 .or._lPar==4) Size 325,8 Valid fvazio(_cAcao) Object oAcao             
If nPar==2
   @ 116,050 Get _cAcao1 Picture "@!" When (.F.) Size 325,8 Valid fvazio(_cAcao1) Object oAcao1             
   @ 126,050 Get _cAcao2 Picture "@!" When (.F.) Size 325,8 Valid fvazio(_cAcao2) Object oAcao2             
Endif	   

@ 142,015 Say OemToAnsi("Responsável :") Size 050,8 Object oRes
@ 140,050 Get _cResp Picture "@!" When (_lPar==3 .Or. _lPar== 4) F3 "QAA" Size 40,8 Valid fValResp() Object oResp             
@ 140,095 Get _cNResp Picture "@!" When .f. Size 160,8 Object oNResp

@ 156,015 Say OemToAnsi("Planta: ") Size 050,08 Object oPla
oComPla := TComboBox():New(154,050,{|u| if(Pcount() > 0,_cPla := u,_cPla)},;
	_aOpPla,30,20,oDialog,,{||.T.},,,,.T.,,,,{|| _lPar==3 .Or. _lPar== 4},,,,,"_cPla")

@ 156,095 Say OemToAnsi("Area do Resp:") Size 050,8 Object oAre                         
@ 154,135 Get _cArea Picture "@!" When (_lPar==3 .or._lPar==4) Size 50,8 Valid fvazio(_cArea) Object oArea             

@ 156,195 Say OemToAnsi("Dta Abertura:") Size 050,8 Object oDataa                         
@ 154,230 Get _dDataab Picture "99/99/9999" When (_lPar==3 .or._lPar==4) Size 40,8 Valid fvazio(_dDataab) Object oDataab             

@ 156,290 Say OemToAnsi("Dta Fechamento:") Size 045,8 Object oDataf            
@ 154,335 Get _dDatafe Picture "99/99/9999" When (_lPar==3 .or._lPar==4) Size 40,8 Valid fvazio(_dDatafe) Object oDatafe

@ 170,015 Say OemToAnsi("FMEA:") Size 050,8 object ofme                 

oComFmea := TComboBox():New(168,050,{|u| if(Pcount() > 0,_cFmea := u,_cFmea)},;
	_aOpcao,30,10,oDialog,,{||.T.},,,,.T.,,,,{|| _lPar!=2},,,,,"_cFmea")
   
@ 170,095 Say OemToAnsi("Fluxo:") Size 050,8 object oFlux                 
oComFlux := TComboBox():New(168,135,{|u| if(Pcount() > 0,_cFluxo := u,_cFluxo)},;
	_aOpcao,30,10,oDialog,,{||.T.},,,,.T.,,,,{|| _lPar!=2},,,,,"_cFluxo")

@ 170,195 Say OemToAnsi("P.Controle:") Size 050,8 object oPcon                             
oComPcon := TComboBox():New(168,230,{|u| if(Pcount() > 0,_cPcont := u,_cPcont)},;
	_aOpcao,30,10,oDialog,,{||.T.},,,,.T.,,,,{|| _lPar!=2},,,,,"_cPcont")

@ 184,015 Say OemToAnsi("Status:") Size 015,8 object oStatu                 
oComFlux := TComboBox():New(182,050,{|u| if(Pcount() > 0,_cStatus := u,_cStatus)},;
	_aStatus,80,10,oDialog,,{||.T.},,,,.T.,,,,{|| _lPar!=2},,,,,"_cStatus")

@ 190,320 BMPBUTTON TYPE 01 ACTION fGrvLic()
@ 190,350 BMPBUTTON TYPE 02 ACTION fEnd()
  
Activate MsDialog oDialog Centered Valid fSaida()

Return

Static Function fvazio(_cparam)
Local _lRet := .T.
   
   If Empty(_cParam)
      MsgBox(OemToAnsi("Campos Obrigatórios em Branco"),OemToAnsi("Atenção"),"INFO")   
      _lRet := .F.
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
   If lSaida 
      Return(.T.)
   Else
      Return(.F.)
   Endif 
Return


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

Static Function fCodpro()

   SB1->(DbsetOrder(1)) //filial+codigo produto
   If !SB1->(DbSeek(xFilial("SB1")+_cProd),Found())	
      MsgBox(OemToAnsi("Produto não Encontrado"),OemToAnsi("Atenção"),"INFO")
	  Return .f.
   Else
      _cDProd := SB1->B1_DESC
      oDProd:Refresh()
   Endif

Return .t.


Static Function fEnd() 
   If _lPar==2 .or._lPar==4
      RollBackSx8() //Volta a numeração da Ordem de Liberação
   Else              
     If Empty(_cIdent) .And.  _lPar==3
        RollBackSx8() //Volta a numeração da Ordem de Liberação     
     Else
       fGrvHist()
     Endif  
   Endif                  
   Close(oDialog) 

Return

Static Function fGrvLic()

	If empty(_cPla)
		alert('informe a planta!')
		return .f.
	endif


       If _lPar==3	  //inclusao
	      Reclock("SZO",.T.)
	         SZO->ZO_FILIAL  := xFilial("SZO")
		     SZO->ZO_ITEM    := _cItem
		     SZO->ZO_STATUS  := _cStatus
		     SZO->ZO_IDENTIF := _cIdent
		     SZO->ZO_DESCRI  := _cDesc
		     SZO->ZO_ACAO    := _cAcao
	   	     SZO->ZO_AREA    := _cArea
		     SZO->ZO_DTABERT := _dDataab
		     SZO->ZO_DTREAL  := _dDatafe
		     SZO->ZO_FMEA    := _cFmea 
		     SZO->ZO_PCONTRO := _cPcont
		     SZO->ZO_CAUSA   := _cCausa
		     SZO->ZO_RESP    := _cResp
		     SZO->ZO_FLUXO   := _cFluxo
             SZO->ZO_COD     := _cProd 
             SZO->ZO_DATA    := Date()  //data da inclusão           
             SZO->ZO_PLANTA	 := SubStr(_cPla,1,1)
	      MsUnlock("SZO")     

	      ConfirmSX8()  
          lSaida := .T. //permite fechar o dialogo	      
	   Elseif _lPar == 4
		    Reclock("SZO",.F.)
	         SZO->ZO_FILIAL  := xFilial("SZO")
		     SZO->ZO_ITEM    := _cItem
		     SZO->ZO_STATUS  := _cStatus
		     SZO->ZO_IDENTIF := _cIdent
		     SZO->ZO_DESCRI  := _cDesc
		     SZO->ZO_ACAO    := _cAcao
	   	     SZO->ZO_AREA    := _cArea
		     SZO->ZO_DTABERT := _dDataab
		     SZO->ZO_DTREAL  := _dDatafe
		     SZO->ZO_FMEA    := _cFmea 
		     SZO->ZO_PCONTRO := _cPcont
		     SZO->ZO_CAUSA   := _cCausa
		     SZO->ZO_RESP    := _cResp
		     SZO->ZO_FLUXO   := _cFluxo
             SZO->ZO_COD     := _cProd
             SZO->ZO_PLANTA  := SubStr(_cPla,1,1)
	        MsUnlock("SZO")     
            lSaida := .T. //permite fechar o dialogo	      
	   Else               
   	     fGrvHist() //Grava historicos
       Endif
       
       If _lPar==4 .Or. _lPar==3
	       fLAMail()//ENVIA EMAIL
	   EndIf

       Close(oDialog)
Return
              

User Function FLegLic()       

Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Ação Implementada com Sucesso") },;
                      {"BR_LARANJA" , OemToAnsi("Ação não Implementada") },;                      
  					  {"BR_AZUL"    , OemToAnsi("Ação Ineficaz")   }}

BrwLegenda(OemToAnsi("Lições Aprendidas"), "Legenda", aLegenda)

Return  


Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE"   , OemToAnsi("Ação Implementada com Sucesso")  },;
                      {"BR_LARANJA" , OemToAnsi("Ação não Implementada") },;                      
  					  {"BR_AZUL"    , OemToAnsi("Ação Ineficaz")   }}

Local uRetorno := {}
Aadd(uRetorno, { 'ZO_STATUS == "1" ' , aLegenda[1][1] } )
Aadd(uRetorno, { 'ZO_STATUS == "2" ' , aLegenda[2][1] } )
Aadd(uRetorno, { 'ZO_STATUS == "3" ' , aLegenda[3][1] } )
Return(uRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL INFORMANDO DA INCLUSAO OU ALTERAÇÃO DA LICAO APRENDIDA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fLAMail()
Local cMsg
Local cPla := ""

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="100%" border="1">'

	cMsg += '<tr>'
	cMsg += '<td colspan="4" style="background:#ccc">'
	          
	If _lPar==3 //inclusao
		cMsg += 'LIÇÕES APRENDIDAS - INCLUSÃO - '+SZO->ZO_ITEM
	ElseIf _lPar==4 //alteracao
		cMsg += 'LIÇÕES APRENDIDAS - ALTERAÇÃO - '+SZO->ZO_ITEM
	EndIf 
	
	cMsg += '</td>'
	cMsg += '</tr>
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Número</td>'
	cMsg += '<td>'+SZO->ZO_ITEM+'</td>'
	cMsg += '<td style="background:#abc">Identificação</td>'
	cMsg += '<td>'+SZO->ZO_IDENTIF+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Produto</td>'
	cMsg += '<td>'+SZO->ZO_COD+'</td>'

    SB1->(dbSetOrder(1))
    SB1->(dbSeek(xFilial('SB1')+SZO->ZO_COD))
	
	cMsg += '<td style="background:#abc">Descrição</td>'
	cMsg += '<td>'+SB1->B1_DESC+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Descrição</td>'
	cMsg += '<td colspan="3">'+SZO->ZO_DESCRI+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Causa</td>'
	cMsg += '<td colspan="3">'+SZO->ZO_CAUSA+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Ação</td>'
	cMsg += '<td colspan="3">'+SZO->ZO_ACAO+'</td>'
	cMsg += '</tr>'
	
	If SZO->ZO_PLANTA == "1"
		cPla := "WHB I"
	ElseIf SZO->ZO_PLANTA == "2"
		cPla := "WHB II"
	ElseIf SZO->ZO_PLANTA == "3"
		cPla := "WHB III"
	ElseIf SZO->ZO_PLANTA == "4"
		cPla := "WHB IV"
	ElseIf SZO->ZO_PLANTA == "5"
		cPla := "WHB V"
	EndIf
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Planta</td>'
	cMsg += '<td colspan="3">'+cPla+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Responsável</td>'
	cMsg += '<td>'+SZO->ZO_RESP+'</td>'
	
	QAA->(DbSetOrder(1))
	QAA->(DbSeek(xFilial("QAA")+SZO->ZO_RESP))
	
	cMsg += '<td style="background:#abc">Nome</td>'
	cMsg += '<td>'+QAA->QAA_NOME+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Área</td>'
	cMsg += '<td>'+SZO->ZO_AREA+'</td>'
	cMsg += '<td style="background:#abc">Dt. Abertura</td>'
	cMsg += '<td>'+DTOC(SZO->ZO_DTABERT)+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Dt. Real</td>'
	cMsg += '<td>'+DTOC(SZO->ZO_DTREAL)+'</td>'
	cMsg += '<td style="background:#abc">Fmea</td>'
	cMsg += '<td>'+Iif(SZO->ZO_FMEA=="S","Sim","Não")+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Fluxo</td>'
	cMsg += '<td>'+Iif(SZO->ZO_FLUXO=="S","Sim","Não")+'</td>'
	cMsg += '<td style="background:#abc">Pl. Controle</td>'
	cMsg += '<td>'+Iif(SZO->ZO_PCONTRO=="S","Sim","Não")+'</td>'
	cMsg += '</tr>'

	cMsg += '</table><br />'
	cMsg += '</body>'
	cMsg += '</html>
		
	cTo := ""
    
    cAl := getnextalias()
    
    beginSql alias cAl
        SELECT * FROM %Table:ZEF%
        WHERE ZEF_FILIAL = %xFilial:ZEF%
        AND ZEF_PLANTA = %Exp:SZO->ZO_PLANTA%
        AND %NotDel%
    endSql
    
    While (cAl)->(!eof())
    	cTo += (cAl)->ZEF_EMAIL + ';'
    	(cAl)->(dbskip())
    Enddo
	 
	If Empty(cTo)
		Return
	Endif
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := '*** LIÇÕES APRENDIDAS - '+ Iif(_lPar==3,'INCLUSÃO',Iif(_lPar==4,'ALTERAÇÃO',''))+' - '+SZO->ZO_ITEM+' ***'
	oMail:cTo      := cTo
	
	oMail:Envia()

Return

Static Function fValResp()

	QAA->(dbsetorder(1))
	If !QAA->(dbseek(xFilial("QAA")+ALLTRIM(_cResp)))
		Alert('Matrícula não encontrada no cadastro de usuários (QAA)!')
		Return .f.
	Else
		_cNResp := QAA->QAA_NOME
		oNResp:Refresh()
	Endif

Return .T.

Static Function	fCadEmail()
	axCadastro("ZEF")
Return                                                             	

User Function QDO8VEMAIL()

	cEmail := &(ReadVar()) 
	
	If At("Ç",cEmail) > 0
		alert('Não utilize Ç!')
		return .f.
	Endif 

	If At("Ã",cEmail) > 0
		alert('Não utilize acento Ã!')
		return .f.
	Endif 
	
	If At("@",cEmail) < 2 .or. At(".",cEmail) < 2
		alert('O e-mail deve ser preenchido corretamente! Exemplo: nome@whbbrasil.com.br')
		return .f.
	Endif

	If !IsEmail(ALLTRIM(cEmail))
		Alert('Email inválido! Digite o endereço de e-mail corretamente!')
		Return .f.
	Endif
    
Return .T.