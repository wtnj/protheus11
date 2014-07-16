/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST111  ³ Autor ³ João Felipe            Data ³ 13/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ALTERA GRUPO DE PRODUTOS                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento WHB                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    

User Function nhest111()

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Produtos")
aRotina := {{ "Pesquisa"		,"AxPesqui"     , 0 , 1},;
			{ "Visualizacao"	,"AxVisual" 	, 0 , 2},;
			{ "Altera"   		,"U_fEST111()"  , 0 , 5}}


mBrowse( 6, 1,22,75,"SB1",,,,,,)
Return

User Function fEst111()

_cProd  := Space(15)
_cDesc  := Space(20)
_cGrupo := Space(20)

	Define MsDialog oDialog Title OemToAnsi("Produtos") From 000,000 To 140,320 Pixel 
	
	_cProd := SB1->B1_COD
	_cDesc := SB1->B1_DESC
	_cGrupo := SB1->B1_GRPPROD
	
	@ 005,005 Say "Produto: " Size 040,8 
	@ 020,005 Say "Descricao: " Size 040,8 	
	@ 035,005 Say "Grupo: " Size 040,8
	@ 005,040 Get _cProd Picture "@!" F3 "SB1" Size 60,8 Valid fProd()
	@ 020,040 Get _cDesc Picture "@!" Size 110,8 Object oDesc
	@ 035,040 Get _cGrupo Picture "@!" F3 "ZAQ" Size 110,8 valid(VAZIO() .OR. existcpo("ZAQ"))
	
	@ 052,085 BMPBUTTON TYPE 01 ACTION fOk()
	@ 052,119 BMPBUTTON TYPE 02 ACTION fEnd() 
	
	Activate MsDialog oDialog Center Valid fDialog()

Return

Static Function fProd()
    SB1->(DbSetOrder(1)) //filial + cod
    SB1->(DbSeek(xFilial("SB1")+_cProd))
    If SB1->(Found())
		_cDesc := SB1->B1_DESC
		oDesc:Refresh()
    EndIf
Return(.T.)

Static Function fOK()
	If fDialog()
    	RecLock("SB1",.F.)
    		SB1->B1_GRPPROD := UPPER(_cGrupo)
    	MsUnlock("SB1")
	EndIf
	Close(oDialog)
Return

Static Function fEnd() 

   	Close(oDialog) 
   	lDialog := .T.

Return

Static Function fDialog()
	SB1->(DbSetOrder(1)) //filial + cod
    SB1->(DbSeek(xFilial("SB1")+_cProd))
    If SB1->(!Found())	
    	MsgAlert("Produto nao encontrado. Verifique!")
    	Return(.F.)
    EndIf
    
Return(.T.)


                                           
