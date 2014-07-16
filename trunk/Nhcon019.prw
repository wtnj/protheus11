/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN052  �Autor  �Marcos R Roquitski  � Data �  10/13/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Contabilizacao dos impostos retidos.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

USER FUNCTION Nhcon019()

Local aArea    := GETAREA()
Local cPrefixo := ""
Local cNumero  := ""
Local cParcela := ""
Local cCliente := ""
Local cLoja    := ""
Local nValor   := 0
Local aAreaSE2

DbSelectArea("SE2")
aAreaSE2 := GetArea()

cPrefixo := SF1->F1_SERIE  
cNumero  := SF1->F1_DOC 
cFornece := SF1->F1_FORNECE
cLoja  	 := SF1->F1_LOJA

DbSetOrder(6)
SE2->(DbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNumero))
While !SE2->(Eof()) .and. SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == cFornece+cLoja+cPrefixo+cNumero
	nValor += SE2->E2_VALOR
	SE2->(DbSkip())	
Enddo

RestArea(aAreaSE2)
RestArea(aArea)

Return nValor
