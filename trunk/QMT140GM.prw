
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QMT140GM  �Autor  �Jo�o Felipe da Rosa � Data �  02/12/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � Utilizado para atualizacoes apos a gravacao de dados       ���
���          � efetuada pelo padrao.									  ���
���			 � Ponto de Chamada											  ���
���			 � Executado ap�s a atualiza��o dos dados de Calibra��o       ���
�������������������������������������������������������������������������͹��
���Uso       � METROLOGIA                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                             

User Function QMT140GM() 
	If SM0->M0_CODIGO=="NH"
		If !QM2->QM2_STATUS$"A/R"
			RecLock("QM2",.F.)
				QM2->QM2_VALDAF := CTOD("  /  /  ")
			MsUnlock("QM2")
		EndIf
	EndIf
Return