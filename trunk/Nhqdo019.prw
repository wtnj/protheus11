/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQDO018  �Autor  �Marcos R. Roquitski � Data �  18/03/2003 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera��o Automatica do Nr. do Documento.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Controle de Documentos.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function NhQdo019()
Local _lRet := .T.

	If Alltrim(M->QDH_CODTP) == 'FM' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'IT' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'PR' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'FP' .OR. ; 
		       Alltrim(M->QDH_CODTP) == 'TB' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'MQ' .OR. ;
		       Alltrim(M->QDH_CODTP) == 'DG' .OR. ; 		       
		       Alltrim(M->QDH_CODTP) == 'RQ' .OR. ; 		       	
		       Alltrim(M->QDH_CODTP) == 'NT'  		       

		If M->QDH_PLANTA <> '1' 

			Alert("ATENCAO, para os tipo de documento " + Alltrim(M->QDH_CODTP) + " Obrigatorio lancar em Integrado.") 

			_lRet := .F.
			
		Else 
			_lRet := .T.

		Endif 

	Else

		If M->QDH_PLANTA == '1' 

			Alert("ATENCAO, para os tipo de documento. " + Alltrim(M->QDH_CODTP) + " nao e um tipo de documento Integrado.") 

			_lRet := .F.
			
		Else 
			_lRet := .T.

		Endif 
	Endif

Return(_lRet) 

