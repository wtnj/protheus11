/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTA4006  ºAutor  ³João Felipe da Rosa º Data ³  18/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CRIA UM FILTRO PARA A TABELA STJ NO RETORNO DE OS          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch" 
#INCLUDE "topconn.ch"   


User Function MNTA4006()

	//Adiciona o botão no browse do retorno de os
	aAdd(aRotina,{"Sol. Compras","Processa({||U_MNT420SC()},'Solicitação de Compras')",0,3})

	SetPrvt("_cCombo,_aCombo")

	_aCombo := {"Geral"}
	
	SHB->(DBGOTOP())
	WHILE SHB->(!EOF())
		aAdd(_aCombo,SHB->HB_COD)
		SHB->(DBSKIP())
	ENDDO
	
	_cCombo  := ""
	_aCampos := ""

	@ 000,000 To 060,210 Dialog oDlg Title OemToAnsi("Escolha o grupo de O.S. ")
	@ 010,010 COMBOBOX _cCombo ITEMS _aCombo SIZE 50,10 object oCombo   
	@ 010,070 BMPBUTTON TYPE 01 ACTION FiltraTJ()
	Activate Dialog oDlg CENTERED

Return(_aCampos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA O FILTRO NA TABELA STJ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FiltraTJ()

	If _cCombo == "Geral"
	    _aCampos:= ""
   	Else     
		_aCampos:= " .and. STJ->TJ_CENTRAB = '"+_cCombo+"' "
	EndIf
	
	Close(oDlg)

Return()                    