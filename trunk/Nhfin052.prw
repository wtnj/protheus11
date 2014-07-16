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

USER FUNCTION Nhfin052(cImpRet)

Local aArea := GETAREA()
Local aAreaSE1 

Local cPrefixo := ""
Local cNumero  := ""
Local cParcela := ""
Local cTipo    := If(ValType(cImpRet)!= "U",cImpRet,"")
Local cCliente := ""
Local cLoja    := ""

Local nValor := 0

DbSelectArea("SE1")
aAreaSE1 := GetArea()

cPrefixo := SE1->E1_PREFIXO
cNumero  := SE1->E1_NUM
cParcela := SE1->E1_PARCELA
cCliente := SE1->E1_CLIENTE
cLoja  	 := SE1->E1_LOJA
_nSaldo  := SE1->E1_SALDO

DbSetOrder(1)
IF DbSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela+cTipo+cCliente+cLoja)
    If SE1->E1_SALDO == 0
		nValor := SE1->E1_VALOR
	Endif		

Endif	

RestArea(aAreaSE1)
RestArea(aArea)

Return nValor