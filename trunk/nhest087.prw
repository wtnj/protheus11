/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST087  ³ Autor ³ FABIO NICO             Data ³ 28/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±                                              
±±³Descri‡…o ³ BAIXA DO  ESTOQUE PELA ETIQUETAS                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESTOQUE / ESPECIFICOS WHB                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"  

User Function nhest087()

                                                                 
_cBarras		:= Space(50)
_cCodigo		:= space(15)
_cLote			:= space(10)
_cLocaliz		:= space(10)
_cQuant			:= space(10)
_cDescri		:= Space(30)
_cCC			:= Space(6)
_cOpera			:= Space(3)
_cAlmoxa		:= Space(3)
_cUM			:= space(3)


DEFINE FONT oFont NAME "Arial" SIZE 12, -12

@ 000,007 To 400,700 Dialog DlgDadosEmb Title "Codigo de Barras"
@ 027,010 Say "Codigo de Barras :" Size 060,8  Object ocBarra
@ 025,060 Get _cBarras Size 180,14 Object oBarra valid CodBarras()
oBarra:Setfont(oFont)

@ 040,010 Say "Codigo do Produto:" Size 060,8  Object ocCodigo
@ 055,010 Say "Lote.............:" Size 060,8  Object ocCodigo
@ 070,010 Say "Localizacao......:" Size 060,8  Object ocCodigo
@ 085,010 Say "Almoxarifado.....:" Size 060,8  Object ocCodigo
@ 100,010 Say "Quantidade.......:" Size 060,8  Object ocCodigo
@ 115,010 Say "Centro de Custo..:" Size 060,8  Object ocCodigo
@ 130,010 Say "Operacao.........:" Size 060,8  Object ocCodigo

@ 040,060 Get _cCodigo 	Size 090,8 When .F. object oCodigo
oCodigo:Setfont(oFont)
@ 040,150 Get _cDescri 	Size 180,8 When .F. object oDescri
oDescri:Setfont(oFont)
@ 055,060 Get _cLote 	Size 60,8 When .F. object oLote
oLote:Setfont(oFont)
@ 070,060 Get _cLocaliz Size 60,8 When .F. object oLocaliz
oLocaliz:Setfont(oFont)
@ 085,060 Get _cAlmoxa Size 60,8 When .F. object oAlmoxa
oAlmoxa:Setfont(oFont)
@ 100,060 Get _cQuant 	Size 60,8 When .F. object oQuant
oQuant:Setfont(oFont)
@ 115,060 Get _cCC	 	Size 60,8 object oCC
oCC:Setfont(oFont)
@ 130,060 Get _cOpera	 	Size 60,8 object oOpera
oOpera:Setfont(oFont)

@ 150,070 BMPBUTTON TYPE 01 ACTION fConfirma()
@ 150,100 BMPBUTTON TYPE 02 ACTION fEnd() //FCancela()]

Activate Dialog DlgDadosEmb CENTERED

Return

Static Function fEnd() 
   Close(DlgDadosEmb) 
Return
           


//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------                       
Static Function fConfirma()

Local _aCab1 := {}
Local _aItem := {}
Local _atotitem:={}
Private lMsHelpAuto := .t.  // se .t. direciona as mensagens de help
Private lMsErroAuto := .f.  //necessario a criacao, pois sera
Private inclui:=.T.
                                          
_aCab1 :={ {"D3_TM",_cOpera,NIL},; 
           {"D3_CC", SUBSTR(_cCC,1,6),NIL},;
	       {"D3_EMISSAO",ddatabase,NIL}}
	       
_aItem:={{"D3_COD"		, _cCodigo	,NIL},;
		 {"D3_LOTECTL"	, _cLote	,NIL},; 
       	 {"D3_LOCAL"	, _cAlmoxa	,NIL},;  
         {"D3_CC"		, SUBSTR(_cCC,1,6)		,NIL},;       	 
         {"D3_UM"		, _cUM		,NIL},;       	 
         {"D3_LOCALIZ"	, _cLocaliz ,NIL},;       	 
   		 {"D3_QUANT"	, val(_cQuant)	,NIL}}
 		 aadd(_atotitem,_aitem)
		_aitem:={}

MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

If lMsErroAuto
  	Mostraerro()
  	DisarmTransaction()
	break
EndIf


ALERT("PASSEI")
Return

//---------------------------------------------------------------------------
// DESMENBRA A VARIAVEL COM O CODIGO DE BARRAS
//---------------------------------------------------------------------------                       
Static Function CodBarras()
local _CBAR := UPPER(_CBARRAS)
_cBarras := UPPER(_CBARRAS)
_cCodigo:= substr(_cBar,1,at(" ",_cbar))

_CBAR := substr(_cBar,len(alltrim(_cCodigo))+2,30)
_cLOTE:= substr(_cBar,1,at(" ",_cbar))

_CBAR := substr(_cBar,len(alltrim(_cLOTE))+2,30)
_cLocaliz:= substr(_cBar,1,at(" ",_cbar))

_CBAR := substr(_cBar,len(alltrim(_clocaliz))+2,30)
_cAlmoxa:= substr(_cBar,1,at(" ",_cbar))

_CBAR := substr(_cBar,len(alltrim(_cAlmoxa))+2,30)
_cquant:= substr(_cBar,1,at(" ",_cbar))



SB1->(DbSeek(xFilial("SB1")+_cCodigo,.T.))
_cDescri := SB1->B1_DESC
_cCC := SB1->B1_CC
_cUM := SB1->B1_UM

IF SB1->B1_TIPO = 'EB'
		_cOpera = '501'
	else 
		_cOpera = '502'
endif 

Return

