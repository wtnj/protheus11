/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Nhfin081 �Autor  �Marcos R Roquitski  � Data �  13/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueia funcionarios do financeiro para nao incluir       ���
���          � lancamentos no contas a pagar.                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"  

User Function Nhfin081()
Local lRet   := .T.
Local _cUser := Alltrim(GetMv("MV_FIND4")) + Alltrim(GetMv("MV_FIND5")) 

If Alltrim(cUserName) $  _cUser
	MsgBox("** Voce nao esta autorizado a incluir lancamentos no Contas a Pagar.","Atencao","ALERT")
	lRet := .F.
Endif

Return(lRet)
