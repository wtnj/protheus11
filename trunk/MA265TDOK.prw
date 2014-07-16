/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA265TDOK �Autor  �Jo�o Felipe da Rosa � Data �  06/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � LOCALIZA��O : Function A265TudoOK - Fun��o de Valida��o da ���
��� 		 �				 digita��o da distribui��o de produtos.       ���
���          �                                                            ���
���			 �	EM QUE PONTO: Na valida��o ap�s a confirma��o, antes da   ���
���			 �				  grava��o da distribui��o, deve ser utilizado���
���			 �				  para valida��es adicionais para a INCLUS�O  ���
���			 �				  da distribui��o do produto, ou atualizar    ���
���			 �				  algum dado no array aCols utilizado         ���
���			 �				  no Browse.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA265TDOK()
Local nPosData := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DB_DATA"}) 
Local nPosEstorno := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DB_ESTORNO"}) 
Local nPosCorrida := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DB_CORRIDA"}) 

	for xD:=1 to len(aCols)
	
		If !aCols[xD][len(aheader)+1] .AND. aCols[xD][nPosEstorno]!='S'//nao pega quando deletado nem quando estornado
			If Month(aCols[xD][nPosData]) <> Month(M->DA_DATA)
				Alert('N�o � permitida distribui��o de produtos fora do m�s da entrada da NF! Por favor, altere a data do �tem '+strzero(xD,4)+'!')
				Return .F.
			EndIf
		EndIf 
		
		if substr(M->DA_PRODUTO,1,4)$"MP04" .AND. Empty(AllTrim(aCols[xD][nPosCorrida])) .AND. SM0->M0_CODIGO == "FN" .AND. SM0->M0_CODFIL=='01'
			Alert('Para materia prima da forjaria � obrigatorio preencher o campo CORRIDA !')
			Return .F.			
		endif 
		
		//Incluir Valida��o da Aprova��o Laboratorio
		if substr(M->DA_PRODUTO,1,4)$"MP04" .AND. Empty(M->DA_LIBOK) .AND. SM0->M0_CODIGO == "FN" .AND. SM0->M0_CODFIL=='01' .AND. Alltrim(M->DA_LOCAL)=='42'
			Alert('Material est� pendente para aprova��o da qualidade ! N�o � possivel endere�ar sem aprova��o !')
			Return .F.			
		endif 
		//------------------------------------------
		
		//Incluir Valida��o da Aprova��o Laboratorio
		if substr(M->DA_PRODUTO,1,4)$"MP04" .AND. Alltrim(M->DA_LIBOK)=='N' .AND. SM0->M0_CODIGO == "FN" .AND. SM0->M0_CODFIL=='01' .AND. Alltrim(M->DA_LOCAL)=='42'
			Alert('Material foi reprovado pela qualidade !')
			Return .F.			
		endif 
		//------------------------------------------

	next

Return .T.