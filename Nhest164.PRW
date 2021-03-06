/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST164  �Autor  �Marcos R. Roquitski � Data �  07/05/2010 ���
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

User Function  Nhest164()

Private _cFilPro := Alltrim(GETMV("MV_NHET161"))
Private _cFil1, _cFil2

Pergunte("NHEST164",.T.)

_cFil1 := Alltrim(mv_par01)
_cFil2 := Alltrim(mv_par02)

If !Empty(_cFil1) .AND. !Empty(_cFil2) 
	DbSelectArea("SCP")
	Set Filter to (!(Substr(SCP->CP_PRODUTO,1,2) $ _cFil1)) .AND. SCP->CP_STATUS <> "E" .AND. SCP->CP_LOCAL $ _cFil2
	SCP->(DbGotop())

Elseif !Empty(_cFil1) .AND. Empty(_cFil2) 
	DbSelectArea("SCP")
	Set Filter to (!(Substr(SCP->CP_PRODUTO,1,2) $ _cFil1)) .AND. SCP->CP_STATUS <> "E"
	SCP->(DbGotop())

ElseIf !Empty(_cFil2) .AND. Empty(_cFil1) 
	DbSelectArea("SCP")
	Set Filter to SCP->CP_STATUS <> "E" .AND. SCP->CP_LOCAL $ _cFil2
	SCP->(DbGotop())

Else
	DbSelectArea("SCP")
	Set Filter to SCP->CP_STATUS <> "E" 
	SCP->(DbGotop())

Endif

MATA185() 

DbSelectArea("SCP")
Set Filter to
SCP->(DbGotop())

Return(nil)