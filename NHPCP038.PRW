
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHPCP038  �Autor  �Jo�o Felipe da Rosa � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para habilitar campos C2_CORRIDA e C2_CORRWHB      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHPCP038()
Return AllTrim(Upper(Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_GRUPO")))$"PA04"

User Function NHPCP38A()
Local cRet := M->C2_CORRIDA
	If !AllTrim(Upper(Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_GRUPO")))$"PA04"
		cRet := ""
	EndIf
Return cRet

User Function NHPCP38B()
Local cRet := M->C2_CORRWHB
	If !AllTrim(Upper(Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_GRUPO")))$"PA04"
		cRet := ""
	EndIf
Return cRet