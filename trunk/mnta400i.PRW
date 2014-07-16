#include "rwmake.ch" 
#INCLUDE "topconn.ch"   

User Function MNTA400I      //--
Local aRot :=  aClone(ParamIXB[1])
	
	IF ALLTRIM(UPPER(FUNNAME()))$"MNTA400"
	
		aAdd(aRot,{"Filtro Planta","U_MNT400FP()" ,0,4,,.F.})
	
	ENDIF

RETURN aRot

User function MNT400FP()
	
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
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA O FILTRO NA TABELA STJ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FiltraTJ()
Local oBrowse := GetMBrowse()

	If _cCombo != "Geral"

		If AT("AND TJ_CENTRAB = '",oBrowse:CFILTERDEFAULT)>0
			oBrowse:SetFilterDefault(SUBSTR(oBrowse:CFILTERDEFAULT,0,AT("AND TJ_CENTRAB = '",oBrowse:CFILTERDEFAULT)-1)+"AND TJ_CENTRAB = '"+_cCombo+"' ")
		else
			oBrowse:SetFilterDefault(oBrowse:CFILTERDEFAULT+"AND TJ_CENTRAB = '"+_cCombo+"' ")
		Endif

		If TMP1->(!EOF())
			STJ->(dbgoto(OBROWSE:NAT))
		Endif

	EndIf

	Close(oDlg)

Return()    