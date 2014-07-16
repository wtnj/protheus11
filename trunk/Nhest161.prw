/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST161  �Autor  �Marcos R. Roquitski � Data �  07/05/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra produtos conforme parametro MV_NHEST161.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function  Nhest161()

Private _cFilPro := Alltrim(GETMV("MV_NHET161"))
Private _cFil1,_cFil2
Private nSCPRec := SCP->(Recno())
Private oldArea := GetArea()
Pergunte("NHEST161",.T.)

_cFil1 := Alltrim(mv_par01)
_cFil2 := Alltrim(mv_par02)

DbSelectArea("SCP")

If !Empty(_cFil1) .AND. !Empty(_cFil2) 
	Set Filter to Substr(SCP->CP_PRODUTO,1,2) == _cFil1 .AND. SCP->CP_STATUS <> "E" .AND. SCP->CP_LOCAL $ _cFil2
Elseif !Empty(_cFil1) .AND. Empty(_cFil2) 
	Set Filter to Substr(SCP->CP_PRODUTO,1,2) == _cFil1 .AND. SCP->CP_STATUS <> "E" 
ElseIf !Empty(_cFil2) .AND. Empty(_cFil1) 
	Set Filter to SCP->CP_STATUS <> "E" .AND. SCP->CP_LOCAL $ _cFil2
Else
	Set Filter to SCP->CP_STATUS <> "E" 
Endif


RestArea(oldArea)

SCP->(dbGotop())

MATA185() 

DbSelectArea("SCP")
Set Filter to
SCP->(DbGotop())

Return(nil)