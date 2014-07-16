#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAX001  � Autor � Handerson Duarte   � Data �  07/01/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna a Matr�cula do usu�rio (QAA) conforme o usu�rio do ���
���          � sistema                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � WHB - MP10 R 1.2 MSSQL                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAX001 ()
Local cMat	:=""
Local aUser	:={}
Local aArea	:=	QAA->(GetArea())

PswOrder(1)
If PswSeek( __cuserid, .T. )
  aUser := PswRet() // Retorna vetor com informa��es do usu�rio
EndIf	
DBSelectArea("QAA") 
QAA->(DBSetOrder(6))//QAA_LOGIN

If QAA->(DBSeek(aUser[1][2])) //Verifica se o usu�rio est� cadastrado no QAA, cadastro de usu�rio
	cMat:=	QAA->QAA_MAT
EndIf 


RestArea(aArea)
Return (cMat)
