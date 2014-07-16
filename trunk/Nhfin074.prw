/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN074  �Autor  �Marcos R. Roquitski � Data �  30/04/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Liberacao de usuario para alteracao de vencimento.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhfin074()
SetPrvt("_cLogin")
_cLogin := GetMv("MV_FIND3")

If Empty(Alltrim(_cLogin))
	_cLogin := Space(15)
Endif
	
@ 200,050 To 350,450 Dialog DlgUsr Title OemToAnsi("Liberacao de Usuario")

@ 011,020 Say OemToAnsi("Login") Size 35,8
    
@ 010,050 Get _cLogin   PICTURE "@!" Size 40,8
     
@ 045,060 BMPBUTTON TYPE 01 ACTION fGrava()
@ 045,110 BMPBUTTON TYPE 02 ACTION Close(DlgUsr)
Activate Dialog DlgUsr CENTERED
	
Return


Static Function fGrava()
	SX6->(DbSeek(xFilial()+"MV_FIND3"))
    RecLock("SX6",.F.)
	   SX6->X6_CONTEUD:= _cLogin //Grava no SX6
	MsUnlock("SX6")
	Close(DlgUsr)
Return(.T.)
