
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M185GRV �Autor  �Alexandre R. Bento  � Data �  26/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos confirmacao da baixa da pre-requisicao���
���          �atualiza automaticamente o SD3-Mov.Internos Modelo 2       ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"

User Function M185GRV

	//������������������������������������Ŀ
	//� Grava SD3 - Mov. Internos modelo 2 �
	//��������������������������������������
	SD3->D3_ORDEM := SCP->CP_ORDEM //grava o numero da ordem de servico digitado pela manutencao na solicitacao ao almoxarifado
	SD3->D3_PECA  := SCP->CP_PECA  //grava a peca para a qual a ferramenta foi requisitada. 
Return
