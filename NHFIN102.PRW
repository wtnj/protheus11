/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN102  �Autor �Guilherme D. Camargo � Data �  21/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho, atualiza campo Z3_NOME, com o nome do Usuario,    ���
���          � caso n�o exista pendencia de acerto de viagem              ���
�������������������������������������������������������������������������͹��
���Uso       � FINANCEIRO - ADIANTAMENTO/ACERTO DE VIAGENS                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function NHFIN102()
Local _cMat := ''
SZ3->(DbSetOrder(2)) // FILIAL+MATRICULA+STATUS DE ATENDIMENTO                                
SZ3->(DbGoTop())
_cMat := M->Z3_MATR
If SZ3->(DbSeek(xFilial("SZ3")+M->Z3_MATR))
	If SZ3->Z3_STATUS == 'A'
		Alert('N�o � poss�vel incluir, pois h� pend�ncia de Acerto de Viagem para esta matr�cula.')
		_cMat := ''
	EndIf
EndIf
Return(_cMat)      