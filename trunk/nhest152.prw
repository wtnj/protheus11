
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST152  �Autor  �Jo�o Felipe da Rosa � Data �  21/10/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA O CAMPO CP_QUANT                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE CUSTOS                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

User Function NHEST152()
Local nPosProd := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_PRODUTO"})

	If SM0->M0_CODIGO=="FN"

		SB5->(DbSetOrder(1))
		SB5->(DbSeek(xFilial("SB1")+Acols[n][nPosProd]))
		
		If !Empty(SB5->B5_QPA) .AND. M->CP_QUANT%SB5->B5_QPA != 0
			MsgBox("A quantidade deve ser igual ou m�ltipla da quantidade padr�o do produto!"+CHR(13)+CHR(10)+;
				   "Quantidade Padr�o: "+AllTrim(STR(SB5->B5_QPA)),"QUANTIDADE PADR�O","ALERT")
			Return .F.
		EndIf
	
	EndIf

Return .T.