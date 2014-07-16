/*                                                              
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                    
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST091  ³ Autor ³ Fabio Nico             Data ³ 07/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ETIQUETA CODIGO DE BARRAS IVECO...                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fusão                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"  
#include "colors.ch"
#include "font.ch"

User Function NHEST091()  
LOCAL _data := date()
SetPrvt("_cParte1,_cParte2,cSequeno,cPorta,_CODBARRA,_cReimp")
                          
_cParte1	:= space(05)
_cSequen	:= 0
_cParte2	:= space(05)
_cTipo		:= 1
cPorta      := "LPT1"                                   
_cReimp		:= space(1)  
_CODBARRA = SPACE(15) 
_imp = .T.            
                           
_cliente = '900183'
_Tipo = '1' 
_cReimp := .t.
UltSequen()

                                    
//-----------------------------------------------------------------------------------

DEFINE FONT oFont NAME "Arial" SIZE 12, -12

@ 000,007 To 400,700 Dialog DlgDadosEmb Title "Impressao de Codigo de Barras"

@ 025,010 Say "Codigo.........: IV18.4.247.00 - BLOCO IVECO DAILY 8140 " Size 300,8 Object ocCodigo 
ocCodigo:Setfont(oFont)
@ 055,010 Say "Sequencial...:" Size 065,8  Object ocSequen
ocSequen:Setfont(oFont)
@ 070,010 Say "Pistao..........:" Size 065,8 Object ocParte1
ocParte1:Setfont(oFont)
@ 085,010 Say "Mancal.........:" Size 065,8  Object ocParte2
ocParte2:Setfont(oFont)
@ 100,010 Say "Tipo Etiqueta..:" Size 065,8  Object ocTipoe
ocParte2:Setfont(oFont)
@ 100,150 Say "1-Pequena / 2-Grande " Size 065,8  Object ocTipoe
ocParte2:Setfont(oFont)


@ 050,080 Get _cSequen PICTURE '99999' Size 60,8 valid sequenc() object oSequen
oSequen:Setfont(oFont)
@ 065,080 Get _cParte1 PICTURE '9999' Size 60,8 valid ValPar1() object oParte1
oParte1:Setfont(oFont)
@ 080,080 Get _cParte2 PICTURE '99999' Size 60,8 valid ValPar2() object oParte2
oParte2:Setfont(oFont)
@ 100,080 Get _cTipo PICTURE '9' Size 60,8 object oTipo
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

if _cTipo = 1
		_CODBARRA := ALLTRIM(_cParte1)+ALLTRIM(_cSequen)+ALLTRIM(_cParte2) //  COMPOSICAO DO CODIGO DE BARRAS
		MSCBPRINTER("S600","LPT1",,20,.f.,,,)   // 20= ALTURA DA ETIQUETA
		MSCBCHKSTATUS(.f.)
		MSCBBEGIN(1,4,20)                                                            
		MSCBSAYBAR(04,3,_CODBARRA,"N","2",10,,,,,1.5,1,,,,)  
		MSCBSAY(05,14,_cParte1,"N","0","030,020",.t.)                  
		MSCBSAY(11,14,_cSequen,"N","0","030,020")
		MSCBSAY(20,14,_cParte2,"N","0","030,020")

	else
		_CODBARRA := ALLTRIM(_cParte1)+ALLTRIM(_cSequen)+ALLTRIM(_cParte2) //  COMPOSICAO DO CODIGO DE BARRAS
		MSCBPRINTER("S600","LPT1",,20,.f.,,,)   // 20= ALTURA DA ETIQUETA
		MSCBCHKSTATUS(.f.)
		MSCBBEGIN(1,4,20)                                                            
		MSCBSAYBAR(05,5,_CODBARRA,"N","2",10,,,,,2,6,,,,)  // MELHOR ATE AGORA   
		MSCBSAY(07,18,_cParte1,"N","0","055,035",.t.)                  
		MSCBSAY(17,18,_cSequen,"N","0","055,035")
		MSCBSAY(30,18,_cParte2,"N","0","055,035")
endif                                             

MSCBEND()                                                                 
MSCBClosePrinter()      
MS_FLUSH()

if _cReimp = .t.
    	 GravaReg()
     	_cParte1		:= space(10)
		_cParte2		:= space(10)
Endif
_cReimp = .t.
_imp = .t.
//UltSequen()

Return(nil)                                    

//---------------------------------------------------------------------------------------------------
// ADICIONA 1 NO SEQUENCIAL DO CLIENTE
//---------------------------------------------------------------------------------------------------
      
Static Function GravaReg()
RecLock("SZE",.T.)
    SZE->ZE_FILIAL  := xFilial("SZE")
    SZE->ZE_SERIAL  := _cSequen
    SZE->ZE_PRODUTO := 'IV18.4.247.00'
    SZE->ZE_DATA    := Ddatabase
    SZE->ZE_HORA    := Subs(Time(),1,8)
    SZE->ZE_BLOCO	:= ALLTRIM(_cParte1) + ALLTRIM(_cParte2)
MsUnLock("SZE")
  
UltSequen()
_cParte1		:= space(05)
_cParte2		:= space(05)

Return


              
//----------------------------------------------------------------------
//  VALIDA A DIGITACAO DAS CARACTERISTICAS DO PISTAO
//----------------------------------------------------------------------
Static Function ValPar1()
_imp = .T.  
for xy = 1 to 4
	if VAL(substr(_cParte1,xy,1)) > 3
        Msgbox("Atencao Valores Invalidos","Atencao","ALERT" )  
        _imp = .f.
	endif
	if val(substr(_cParte1,xy,1)) = 0
        Msgbox("ATENCAO EXISTEM VALORES ZERADOS","Atencao","ALERT" )  
        _imp = .f.
	endif
next  
return(_imp)	   

//----------------------------------------------------------------------
//  VALIDA A DIGITACAO DAS CARACTERISTICAS DO MANCAL
//----------------------------------------------------------------------

Static Function ValPar2()
_imp = .T.  
for xy = 1 to 5
	if VAL(substr(_cParte2,xy,1)) > 9
        Msgbox("Atencao Valores Invalidos","Atencao","ALERT" )  
        _imp = .f.
	endif
	if val(substr(_cParte2,xy,1)) = 0
        Msgbox("ATENCAO EXISTEM VALORES ZERADOS","Atencao","ALERT" )  
         _imp = .f.
	endif
next  
return(_imp)	   


//----------------------------------------------------------------------
//  VALIDA A DIGITACAO DA SEQUENCIA QUANDO REIMPRESSAO.
//----------------------------------------------------------------------

Static Function sequenc()
DbSelectArea("SZE")
SZE->(DbSetOrder(2))
SZE->(Dbgotop()) 
If SZE->(dbSeek(xFilial("SZE")+'IV18.4.247.00  '+_cSequen+'   '))
   		MSGBOX("Atencao REIMPRESSAO DE ETIQUETA ","Atencao","ALERT") 
   		_cParte1 := substr(SZE->ZE_BLOCO,1,4)
   		_cParte2 := substr(SZE->ZE_BLOCO,5,5)
  		_cReimp := .f.
   		return
	else
   		_cReimp := .t.
Endif
return


//-----------------------------------------------------------------------------------
// PEGA O ULTIMO REGISTRO DO PRODUTO
//-----------------------------------------------------------------------------------
Static Function UltSequen()


cQuery := " SELECT TOP 1 * "                                                                          
cQuery += " FROM " + RetSqlName( 'SZE' ) +" SZE "
cQuery += " WHERE SZE.ZE_PRODUTO = 'IV18.4.247.00' "   
cQuery += " AND SZE.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY SZE.R_E_C_N_O_ DESC"     
//cQuery += " ORDER BY SZE.ZE_SERIAL DESC" 

MemoWrit('C:\TEMP\EST091.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP"
TMP->(DBGotop())     

_cSequen := ALLTRIM(STRZERO(VAL(TMP->ZE_SERIAL)+1,6))
TMP->(DbCloseArea())

Return
