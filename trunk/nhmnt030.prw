
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT030  �Autor  �Jo�o Felipe da Rosa � Data �  08/25/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � BLOQUEIO DO CAMPO TJ_DTORIGI NA ABERTURA DE OS CORRETIVA   ���
���          � SERVICO = '000000'                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "protheus.ch"  

User Function NHMNT030()

If M->TJ_SERVICO == '000000' //OS CORRETIVA
	M->TJ_DTORIGI := dDataBase
EndIf 

//Na usinagem 
If SM0->M0_CODIGO == "NH"
	//-- o login MANUTENCAO s� pode abrir OS corretiva (servi�o = '000000/000300/000019')
	If ("MANUTENCAO"$ALLTRIM(UPPER(cUserName))) .AND. !M->TJ_SERVICO$'000000/000300/000019'
		Alert("Somente permitido abrir OS Corretiva!")
		Return .F.
	EndIf

	//-- se for OS programada (servico = '000001') a situacao da OS deve ser pendente
	If M->TJ_SERVICO == '000001' .AND. !("MANUTENCAO"$ALLTRIM(UPPER(cUserName)))
		M->TJ_SITUACA := "P"
	Else
		M->TJ_SITUACA := "L"
	EndIf
EndIf

//Na fundicao
If SM0->M0_CODIGO == "FN"
/*
	If M->TJ_SERVICO == "000001" .or. ;//CORRETIVA PROGRAMADA
	   M->TJ_SERVICO == "000029" .or. ;
	   M->TJ_SERVICO == "000031" .or. ;
	   M->TJ_SERVICO == "000032" .or. ;
	   M->TJ_SERVICO == "000033" 
	   
		M->TJ_SITUACA := "P"
	Else
		M->TJ_SITUACA := "L"
	EndIf
*/
EndIf

Return(.T.)