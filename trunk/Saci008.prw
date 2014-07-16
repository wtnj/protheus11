/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SACI008   �Autor  �Marcos R. Roquitski � Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada                                           ���
���          � O ponto de entrada SACI008 sera executado apos gravar todos 
  			   os dados da baixa a receber. Neste momento todos os 
  			   registros j� foram atualizados e destravados e a 
  			   contabilizacao efetuada..                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "rwmake.ch"

User Function SACI008()
Local _nImpostos := 0   
Local _cTipos    := Alltrim(GETMV("MV_TIPOS")) 
Local cTitAnt    := (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)

If Alltrim(GETMV("MV_FA070TI")) == 'S' .AND. SE1->E1_SALDO > 0

	nSalvRec:=Recno()

	//������������������������������������������������������������������Ŀ
	//�Verifica se h� abatimentos para voltar a carteira                 �
	//��������������������������������������������������������������������
	SE1->(DbSetOrder(2))

	// Soma Impostos 	
	If DbSeek(xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
		While !Eof() .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			If 	Alltrim(SE1->E1_TIPO) $ _cTipos
				_nImpostos += SE1->E1_VALOR
			Endif	
			SE1->(dbSkip())
		EndDo
	Endif   
	DbGoto(nSalvRec)

	// Pesquisa NF. abate Saldo.
	If DbSeek(xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
		While !Eof() .and. cTitAnt == (SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			If 	Alltrim(SE1->E1_TIPO) == 'NF'
				RecLock("SE1",.F.)
				SE1->E1_SALDO  := (SE1->E1_SALDO - _nImpostos)
				MsUnlock("SE1")				
				Exit
			Endif	
			SE1->(dbSkip())
		EndDo
	Endif   
	DbGoto(nSalvRec)
	
Endif

Return(.T.)
