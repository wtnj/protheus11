
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT045  �Autor  �Jo�o Felipe da Rosa � Data �  22/07/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA O CAMPO C1_OS NA SOLICITACAO DE COMPRAS             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS / MANUTENCAO DE ATIVOS                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHMNT045()

	If SM0->M0_CODIGO=="NH" //Empresa Usinagem
	
		If !AllTrim(UPPER(cUserName))$"ALTEVIRMS/CRISTIANEM/VILSONJ/CLAUDIOSA/JOAOFR/ADMINISTRADOR"
			Alert("Campo liberado apenas para o setor de Manuten��o!")
			Return .F.
	    EndIf
	    
    EndIf
        
    //Localiza o n�mero da OS na tabela STJ
 	STJ->(DbSetOrder(1)) // FILIAL + ORDEM
 	If STJ->(DbSeek(xFilial("STJ")+M->C1_OS))
 		If STJ->TJ_TERMINO=="S"
 			Alert("Ordem de Servi�o j� finalizada!")
 			Return .F.
 		EndIf
	Else
		Alert("Ordem de Servi�o n�o encontrada!")
		Return .F.
	EndIf


Return .T.
