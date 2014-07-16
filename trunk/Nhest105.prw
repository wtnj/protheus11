
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST105  �Autor  �Fabio Nico          � Data �  17/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Informa se produto j� existe em outros cadastros            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

User Function Nhest105()


DbSelectArea("TPY")
TPY->(DbSetOrder(2)) //filial+PROD 
TPY->(Dbgotop())       
if TPY->(DbSeek(xFilial("TPY")+M->B1_COD))
		MsgBox("ATENCAO PRODUTO JA EXISTE NA ESTRUTURA DE PRODUTOS ","Atencao","STOP")
		MsgBox("FAVOR AVISAR O DEPARTAMENTO RESPONSAVEL PELO GRUPO ","Atencao","STOP")
  	   
		If MsgYesNo("Confirma Alteracao da Descricao","Altera B1_DESC")
				MsgBox("A DESCRICAO SERA ALTERADA NA CONFIRMACAO ","Atencao","STOP")
			else
				M->B1_DESC := SB1->B1_DESC
		Endif
  	   
endif
DbSelectArea("SB1")

Return(.T.)
