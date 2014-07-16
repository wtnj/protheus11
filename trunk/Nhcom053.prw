/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM053  �Autor  �Marcos R Roquitski  � Data �  01/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida campo C1_PRODUTO, treinamento somente funcionario   ���
���          � do RH inclui.                                              ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhcom053()

If SM0->M0_CODIGO == 'NH'
	If Alltrim(M->C1_PRODUTO) == 'SA16.000001' .OR. Alltrim(M->C1_PRODUTO) == 'MX01.000208'
		If !Alltrim(UPPER(cUserName)) $ 'ANDREIARB/SIMARARO'
			MsgBox("Somente funcionarios do Depto Pessoal (Andreia / Simara) incluem este tipo de Produto","ALERT","Produto treinamento")
			Return .F.
		Endif
	Endif
Elseif 	SM0->M0_CODIGO == 'FN'
	If Alltrim(M->C1_PRODUTO) == 'SA16.000001' 
		If !Alltrim(UPPER(cUserName)) $ 'ANDREIARB/SIMARARO'
			MsgBox("Somente funcionarios do Depto Pessoal (Andreia / Simara) incluem este tipo de Produto","ALERT","Produto treinamento")
			Return .F.
		Endif
	Endif
Endif

Return .T.