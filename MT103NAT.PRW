/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MT103NAT        � Alexandre R.Bento     � Data �01.04.2004���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para validar a natureza na NFE           ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#include "rwmake.ch"        

User Function MT103NAT()

Private lFlag := .T.

If Empty(paramixb) //paramixb � a natureza
   MsgBox("Aten��o Natureza em branco Redigite !!!","Aten��o","STOP")
   lFlag := .F.
Endif   
//If Alltrim(paramixb) == "30000" //Natureza de servicos tem que alterar
//   Alert("Aten��o esta Natureza tem que ser alterada Redigite !!!","Aten��o","STOP")
//Endif
Return(lFlag)

