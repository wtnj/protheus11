#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM050  �Autor  �Jo�o Felipe da Rosa � Data �  08/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Permite a op��o de gerar o relat�rio de Ponto de Pedido   ���
���          �  considerando o saldo de ferramentas reafiadas             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHCOM051() 

If MsgYesNo("Considera Saldo de Ferramentas Reafiadas FE05?")
	SX6->(DbSeek(xFilial()+"MV_REAFI"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= 'T'
	MsUnlock("SX6")
Else
	SX6->(DbSeek(xFilial()+"MV_REAFI"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= 'F'
	MsUnlock("SX6")
EndIf

MATA170()

Return


