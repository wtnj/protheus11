/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN065  �Autor  �Marcos R Roquitski  � Data �  26/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna CNPJ/CPF do Fornecedor.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"       
#include "topconn.ch"

User Function Nhfin065(nPar)
Local cRet := ""
 
If nPar == "1"
	If SA2->A2_FOLTER == "1"
		cRet := "1"
	Else
		If LEN(Alltrim(SA2->A2_CGC)) < 14
			cRet := "1"
		Else
			cRet := "2"
		Endif	
	Endif	
Elseif nPar == "2"
	If SA2->A2_FOLTER == "1"
		cRet := Strzero(Val(SA2->A2_CPFTER),14)
	Else
		cRet := Strzero(Val(SA2->A2_CGC),14)
	Endif
Elseif nPar == "3"
	If SA2->A2_FOLTER == "1"
		cRet := Substr(SA2->A2_REPRES,1,30)
	Else
		cRet := Substr(SA2->A2_NOME,1,30)
	Endif	
Endif                                                            


Return(cRet)

