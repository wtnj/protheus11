/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMPINST  �Autor  �Jo�o Felipe da Rosa � Data �  25/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ultilizado na grava��o de dados complementares no          ���
���          � instrumento.                                               ���
���          � Ponto de Chamada											  ���
���          � Acionado no Bot�o OK,  ap�s a grava��o  padr�o de Dados    ���
�������������������������������������������������������������������������͹��
���Uso       � METROLOGIA                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COMPINST()
	If SM0->M0_CODIGO=="NH"
		QAA->(dbSetOrder(6)) // LOGIN
		If QAA->(dbSeek(AllTrim(upper(cUsername))))
			RecLock("QM2",.F.)
				QM2->QM2_RESPME := QAA->QAA_MAT
			MsUnlock("QM2")
		EndIf		
		
		If !QM2->QM2_STATUS$"A/R"
			RecLock("QM2",.F.)
				QM2->QM2_VALDAF := CTOD("  /  /  ")
			MsUnlock("QM2")
		EndIf
	EndIf
Return