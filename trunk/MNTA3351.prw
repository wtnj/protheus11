
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNTA3351  �Autor  �Jo�o Felipe da Rosa � Data �  13/07/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA PARA INCLUSAO DE NOVOS ITENS NO AROTINA   ���
				Ponto de entrada chamado na montagem dos bot�es do menu no 
				programa de altera��o de Status da O.S, permitindo a 
				manipula��o da array aRotina e a inclus�o de novos itens, 
				tal como chamadas de fun��es espec�ficas..
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 - MANUTENCAO DE ATIVOS                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MNTA3351()
//-- Sao passados os seguintes parametros:
//-- ParamIXB[1] = aRotina

aRot := ACLONE(ParamIXB[1])
aAdd(aRot,{"Sol. Compras","Processa({||U_MNT420SC()},'Solicita��o de Compras')",0,4})

Return aRot