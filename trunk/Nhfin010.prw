/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN010  �Autor  �Marcos R. Roquitski � Data �  04/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Conta corrente e digito verificador - BRASIL.2RE     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Contas a Receber                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       

User Function Nhfin010()
	cDac := Space(01)
	i := 1
	For i := 1 To 12
		If Substr(SEE->EE_CONTA,i,1) == "-"
			cDac := cDac + Substr(SEE->EE_CONTA,i+1,2)
			Exit
		Endif  
	Next
	cDac   := Alltrim(cDac)
	If Len(cDac) == 1
      cRetorno   := StrZero(Val(Substr(SEE->EE_CONTA,1,AT("-",SEE->EE_CONTA))),12,0)+cDac+" "
	Else
      cRetorno   := StrZero(Val(Substr(SEE->EE_CONTA,1,AT("-",SEE->EE_CONTA))),12,0)+cDac
	Endif

Return(cRetorno)
