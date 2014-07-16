/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN067  �Autor  �Marcos R Roquitski  � Data �  02/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloqueia entrada de titulos tipo NF na tabela SE2, o usuario���
���          �devera possuir acesso de cadastro tipo NF.                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "topconn.ch"

User Function Nhfin067()
Local lRet := .T.
If Alltrim(M->E2_TIPO) == "NF"
	If Alltrim(cUserName) $ "RICARDOW"
		lRet := .T.
	Else
		MsgBox("Para o tipo NF, Utilize rotina de Entrada de N.F no Modulo Estoque/Custo com o Depto. Fiscal.","Cadastro tipo NF","ALERT")
		lRet := .f.	
	Endif
Endif
Return(lRet)