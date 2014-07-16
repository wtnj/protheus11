/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNTA4006  �Autor  �Jo�o Felipe da Rosa � Data �  18/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � CRIA UM FILTRO PARA A TABELA STJ NO RETORNO DE OS          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch" 
#INCLUDE "topconn.ch"   


User Function MNTA4006()

	//Adiciona o bot�o no browse do retorno de os
	aAdd(aRotina,{"Sol. Compras","Processa({||U_MNT420SC()},'Solicita��o de Compras')",0,3})

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

//�����������������������������Ŀ
//� CRIA O FILTRO NA TABELA STJ �
//�������������������������������
Static Function FiltraTJ()

	If _cCombo == "Geral"
	    _aCampos:= ""
   	Else     
		_aCampos:= " .and. STJ->TJ_CENTRAB = '"+_cCombo+"' "
	EndIf
	
	Close(oDlg)

Return()                    