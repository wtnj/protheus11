/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE130  �Autor  �Marcos R. Roquitski � Data �  25/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula DSR sobre Adic. Noturno Rescisao de Contrato       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhgpe130()

Local _nPerc := _nDsr := _nPerc := _nRecno := _nRcPd := 0 
Local _cRcMat := _nValLiq := _nx := 0

_nRecRc := SRC->(Recno())
_nRecno := SRX->(Recno())
_cRcMat := SRA->RA_MAT
SRX->(DbSeek(xFilial("SRX")+"19"+Space(02)+Substr(Dtos(dDataBase),1,6)))
If SRX->(Found())
	_nHoras := Val(Substr(SRX->RX_TXT,1,6))
	_nDsr   := Val(Substr(SRX->RX_TXT,8,6))
	_nPerc  := ((_nDsr / _nHoras)*100) 

    _nx := Ascan(aPd,{ |X| X[1] == '113' } )                             
    If _nx <> 0
        _nRcPd := aPd[_nx][5]
    Endif
	If _nRcpd > 0
	    fGeraVerba("121",((_nRcPd*_nPerc)/100),,,,,,,,,.T.)	
	Endif	    

Endif
SRX->(Dbgoto(_nRecno))

Return(.T.)
