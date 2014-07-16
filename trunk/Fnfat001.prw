/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FNFAT001  � Autor � Osmar Schimitberger   � Data � 13.10.04 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Gatilho que Retorna C.Custo NFE-Devolu��o de Compras LP:610 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Fundicao New Hubner                                         ���
�������������������������������������������������������������������������Ĵ��
��� Atualiz. �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#Include "rwmake.ch"

User Function FNFAT001()

SetPrvt("aHeader,_nCC,_CCUSTO,cD1_COD,cD1_DOC,cD1_SERIE,cD1_FORNECE")


cD1_COD     := SD2->D2_COD
cD1_FORNECE := SD2->D2_CLIENTE
cD1_LOJA    := SD2->D2_LOJA
cD1_DOC     := SD2->D2_NFORI
cD1_SERIE   := SD2->D2_SERIORI
_cCusto     := Space(09)

_cArea := GetArea()

DbSelectArea("SD1")
SD1->(DbSetOrder(2))
DbSeek(xFilial("SD1")+cD1_COD+cD1_DOC+cD1_SERIE+cD1_FORNECE+cD1_LOJA)
While !Eof() .and. (SD1->D1_COD + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE +SD1->D1_LOJA == cD1_COD + cD1_DOC + cD1_SERIE + cD1_FORNECE + cD1_LOJA)
	If !Empty(SD1->D1_CC)
		_cCusto := alltrim(SD1->D1_CC)
		Exit
	Endif
	SD1->(DbSkip())
Enddo
RestArea(_cArea)


Return(_cCusto)
