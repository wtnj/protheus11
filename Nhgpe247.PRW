/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHGPE247 �Autor  �Marcos R Roquitski  � Data �  22/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Trava calculo de Adiantamento.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "Font.ch"
#include "Colors.ch"


User Function Nhgpe247()

	SetPrvt("_cMvGpem010,_aGrupo,_cLogin")

	_aGrupo := pswret()
	_cLogin := _agrupo[1,2]
		
	_cMvGpem010 := Alltrim(GETMV("MV_GPEM010")) 
	
	If Alltrim(_cMvGpem010) == 'N'
		GPEM010()
 
	Else
		MsgBox("Rotina Bloqueada, Verifique com Administrador da Folha de Pagameto.","Bloqueio Adiantamento","STOP")
	
	Endif	
		 				
Return(.T.)

// Rua alvaro maravalhas, 594 - CIC - PARQUE DO SOFTWARE