/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MA020TOK        � Alexandre R. Bento    � Data �23.04.2008���
������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada p/validar o cgc/insc.estadual do forneced���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#include "rwmake.ch"
User Function MA020TOK() 

Local lExecuta := .T.

If !M->A2_EST$"EX" //Estado diferente de exportacao 
   If !M->A2_TIPO$"FX" //tipo diferente de pessoa fisica
      If Empty(M->A2_CGC) // Valida��es do usu�rio para inclus�o de fornecedor
         MsgBox("Preenchimento Obrigatorio do CGC","Atencao","STOP")
         lExecuta := .F.
      ElseIf (Empty(M->A2_INSCR) .And. Empty(M->A2_INSCRM))   
         MsgBox("Preenchimento Obrigatorio da Insc.Estadual","Atencao","STOP")
         lExecuta := .F.
      Endif
   Endif
Endif
   
Return (lExecuta)

