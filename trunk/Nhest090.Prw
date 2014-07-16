/*                                                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                    
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST090  ³ Autor ³ Fabio Nico             Data ³ 07/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ETIQUETA CODIGO DE BARRAS BLOCO CURSOR 13                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PRODUCAO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"  
#include "colors.ch"
#include "font.ch"

User Function EST090()  
LOCAL _data := date()
SetPrvt("_cParte1,_cParte2,cSequeno,cPorta,_CODBARRA,_cReimp")
                          
_cParte1	:= space(10)
_cSequen	:= 0
_cParte2	:= space(10)
_cTipo		:= 1
cPorta      := "LPT1"                                   
_cReimp		:= space(1)  
_CODBARRA = SPACE(15) 
_imp = .T.                      
aAuxCombo1:= {"A","B"}
                           
_cliente = '900183'
_Tipo = '1' 
_cReimp := .t.
                                    
//-----------------------------------------------------------------------------------

DEFINE FONT oFont NAME "Arial" SIZE 12, -12

@ 000,007 To 400,700 Dialog DlgDadosEmb Title "Impressao de Codigo de Barras"

@ 025,010 Say "Codigo.........: FIAT - FIAT  " Size 300,8 Object ocCodigo 
ocCodigo:Setfont(oFont)
@ 070,010 Say "Parte 1..........:" Size 065,8 Object ocParte1
ocParte1:Setfont(oFont)
@ 085,010 Say "Parte 2..........:" Size 065,8  Object ocParte2
ocParte2:Setfont(oFont)


@ 065,080 Get _cParte1 PICTURE 'A' Size 40,8 valid ValPar1() object oParte1
oParte1:Setfont(oFont)
@ 080,080 Get _cParte2 PICTURE '9999999' Size 60,8 valid ValPar2() object oParte2
oParte2:Setfont(oFont)

@ 150,070 BMPBUTTON TYPE 01 ACTION ImpEtiq()
@ 150,100 BMPBUTTON TYPE 02 ACTION fEnd() 
Activate Dialog DlgDadosEmb CENTERED

Return()


//---------------------------------------------------------
Static Function fEnd() 
   Close(DlgDadosEmb)
Return

//---------------------------------------------------------------------------------------------------
//   IMPRESSAO DA ETIQUETA
//---------------------------------------------------------------------------------------------------
Static Function ImpEtiq()

Processa({|| Valpar1() }, "Valida etiqueta")
Processa({|| Valpar2() }, "Valida etiqueta")

if _imp = .f. 
    _imp = .t.
   	_cParte1		:= space(10)
	_cParte2		:= space(10)
	alert("ATENCAO DADOS INCORRETOS IMPOSSIVEL EFETUAR IMPRESSAO !!!!!!!!!!!!")
	return
endif                   

If !IsPrinter(cPorta)
	alert("erro na porta")
    Return
Endif


if _cParte1 = "A"
		_cParte1 = "AAAAAA"
   else
		_cParte1 = "BBBBBB"
endif

	_CODBARRA := ALLTRIM(_cParte1)+ALLTRIM(_cParte2) //  COMPOSICAO DO CODIGO DE BARRAS
	MSCBPRINTER("S600","LPT1",,20,.f.,,,)   // 20= ALTURA DA ETIQUETA
	MSCBCHKSTATUS(.f.)
	MSCBBEGIN(1,4,20)                                                            
	MSCBSAYBAR(25,05,ALLTRIM(_cParte1),"N","3",8,,,,,1,6,,,,)  // MELHOR ATE AGORA   
	MSCBSAY(07,06,_cParte1,"N","0","055,035",.t.)                  

	MSCBSAYBAR(25,15,ALLTRIM(_cParte2),"N","3",8,,,,,1,6,,,,)  // MELHOR ATE AGORA   
	MSCBSAY(07,16,_cParte2,"N","0","055,035")


MSCBEND()                                                                 
MSCBClosePrinter()      
MS_FLUSH()

if _cReimp = .t.
     	_cParte1		:= space(10)
		_cParte2		:= space(10)
Endif
_cReimp = .t.
_imp = .t.
Return(nil)                                    
              
//----------------------------------------------------------------------
//  VALIDA A DIGITACAO DAS CARACTERISTICAS DO PISTAO
//----------------------------------------------------------------------
Static Function ValPar1()
_imp = .T.  
if _cParte1 = "A" .OR. _cParte1 = "B"
	_imp = .t.
	else
 	Msgbox("Atencao Somente A ou B ","Atencao","ALERT" )  
    _imp = .f. 
endif

return(_imp)	   

//----------------------------------------------------------------------
//  VALIDA A DIGITACAO DAS CARACTERISTICAS DO MANCAL
//----------------------------------------------------------------------

Static Function ValPar2()
_imp = .T.  
for xy = 1 to 7
	if VAL(substr(_cParte2,xy,1)) > 3
        Msgbox("Atencao Valores Invalidos","Atencao","ALERT" )  
        _imp = .f.
	endif
	if val(substr(_cParte2,xy,1)) = 0
        Msgbox("ATENCAO EXISTEM VALORES ZERADOS","Atencao","ALERT" )  
         _imp = .f.
	endif
next  
return(_imp)