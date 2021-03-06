
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHCLASS001 �Autor � Jo�o Felipe da Rosa � 13/01/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Classe RotinaAutomatica                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "tbiconn.ch"
#include "msobjects.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "topconn.ch"

Class RotinaAutomatica
		         
	var cEmpresa as Character
	var cCodFil  as Character
	var cModulox as Character
	var aTabelas as Array
	var cTabelas as Character
	
	method New(cEmpresa,cCodFil,cModulox,aTabelas) Constructor
	method Executa(bFuncao)

EndClass

Method New(cEmpresa,cCodFil,cModulox,aTabelas) Class RotinaAutomatica

	::cEmpresa := cEmpresa
	::cCodFil := cCodFil
	::cModulox := cModulox
	::aTabelas := aTabelas
	::cTabelas := ""

	For x:=1 to Len(aTabelas)
		::cTabelas += '"'+aTabelas[x]+'",'
	Next
	
	If Right(::cTabelas,1)==","
		::cTabelas := Substr(::cTabelas,1,Len(::cTabelas)-1)
	EndIf

Return

Method Executa(bFuncao) Class RotinaAutomatica
Local cPrepare := ""	
	
//cPrepare := 'PREPARE ENVIRONMENT EMPRESA "NH" FILIAL "01" MODULO "COM" TABLES "SC1","SC7"'
//&(cPrepare)
//	PREPARE ENVIRONMENT EMPRESA ::cEmpresa FILIAL ::cCodFil MODULO ::cModulox TABLES "SC1"

	RPCSetEnv(::cEmpresa,::cCodFil,"","","","",::aTabelas)
	
	Eval(bFuncao)

	RESET ENVIRONMENT

Return