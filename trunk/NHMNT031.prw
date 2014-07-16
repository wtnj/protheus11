#INCLUDE 'rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT031     �Autor  �JOAO FELIPE DA ROSA� Data �  05/09/08 ���
�������������������������������������������������������������������������͹��
���Desc.     �  VALIDA O CAMPO D3_ORDEM NA BAIXA DA O.S.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION NHMNT031()

IF UPPER(FUNNAME())$'MATA241'
	DBSELECTAREA('STJ')
	DBSETORDER(1)//FILIAL + ORDEM
	IF DBSEEK(XFILIAL('STJ')+M->D3_ORDEM)
		
		IF ALLTRIM(STJ->TJ_CCUSTO) == Iif(SM0->M0_CODIGO=="FN","IMOBILIZ","IMOBIL")
			MsgBox("Centro de custo para o Bem desta OS n�o pode ser "+Iif(SM0->M0_CODIGO=="FN","IMOBILIZ","IMOBIL"),"C.Custo Inv�lido","INFO")
			Return .F.
		ENDIF
		
		CTT->(DBSETORDER(1)) //FILIAL + CCUSTO
		IF CTT->(DBSEEK(XFILIAL('CTT')+STJ->TJ_CCUSTO))
			IF CTT->CTT_BLOQ == '1'
				MsgBox('Centro de custo para o Bem desta OS est� bloqueado no cadastro','C.Custo Inv�lido','INFO')
				Return .F.
			ENDIF
			
		ELSE
			MsgBox('Centro de Custo para o Bem desta OS n�o existe no cadastro','C.Custo Inv�lido','INFO')
			Return .F.
		ENDIF
	ELSE
		MsgBox("Ordem de Servico n�o existe no cadastro. Verifique!","OS n�o existe","INFO")    	
		Return .F.
	ENDIF
ENDIF

RETURN .T.