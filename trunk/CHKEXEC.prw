/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHKEXEC   �Autor  �Jo�o Felipe da Rosa � Data �  22/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � ponto de entrada ao clicar em qualquer item do menu        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CHKEXEC()
cFunc := SubStr(ParamIXB, 1, At('(',ParamIXB)-1 )
    
    //-- GRAVA DATA DE ACESSO DO USUARIO A ROTINA
           
	ZET->(dbsetorder(2))//ZET_FILIAL+ZET_MODULO+ZET_FUNCAO                                                                                                                                
	
	IF !EMPTY(oApp:cModName)
		If ZET->(dbseek('01'+PADR(oApp:cModName,8)+cFunc))
			ZEO->(dbSetOrder(1))//ZEO_FILIAL+ZEO_LOGIN+ZEO_CODZET                                                                                                                                 
			If ZEO->(dbSeek('01'+Padr(UPPER(ALLTRIM(cUserName)),25)+ZET->ZET_COD))
				RecLock('ZEO',.F.)
					ZEO->ZEO_ULTACC := date()
				MSUNLOCK('ZEO')
			Endif
		EndIf
	Endif

Return .T.