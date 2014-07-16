#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAV002  � Autor � HANDERSON DUARTE   � Data �  05/01/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o no campo WH4_ASS conforme os par�metros.         ���
���          � WHB_CARGO = indica quais ser�o os cargos que poder�o       ���
���          � aprovar este documento.                                    ���
���          � WHB_DPTO = Indica quais ser�o os departamentos que poder�o ���
���          � aprovar este documento									  ���
�������������������������������������������������������������������������͹��
���Uso       � PPAP - WHB MP 10 R 1.2 MSSQL                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAV002 (cMatr,cRotina)
Local lRet	:=	.F.

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCargo	:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart	:=	"{"+Getmv("WHB_DPTO")+"}"
Private cUser	
Private aUser	
Private aCargo	:=	&cCargo   //Cagos autorizados a aprovar e geras revis�es
Private aDepart	:=	&cDepart//Departamentos autorizados a aprovar e geras revis�es
Private cString := "QAA"
Private aArea	:=	QAA->(GetArea())
If ValType(cRotina)=="C"
	Do Case
		Case cRotina	==  "ZC9"   //Indica quais os usuario (QAA) poderao aprovar o processo de Historicos do Processo
			cUser	:=	"{"+Getmv("WHB_APRHIS")+"}"
			aUser	:=	&cUser//Departamentos autorizados a aprovar e geras revis�es
			dbSelectArea(cString)
			QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
			If QAA->(DBSeek(xFilial(cString)+cMatr))
				If !Empty(AScan(aUser,ALLTRIM(QAA->QAA_MAT)))
					lRet	:=	.T.
				Else
					lRet	:=	.F.
					Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique o par�mentro WHB_APRHIS." ,{"OK"},2)						
				EndIf	
			Else
				lRet	:=	.F.	
				Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique o par�mentro WHB_APRHIS." ,{"OK"},2)										
			EndIf 
			
		Case cRotina	==  "WHB_METRO"   //Indica quais s�o os c�digos dos usu�rios da metrologia que poder�o aprovar o documento.
			cUser	:=	"{"+Getmv("WHB_METRO")+"}"
			aUser	:=	&cUser//Departamentos autorizados a aprovar e geras revis�es
			dbSelectArea(cString)
			QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
			If QAA->(DBSeek(xFilial(cString)+cMatr))
				If !Empty(AScan(aUser,ALLTRIM(QAA->QAA_MAT)))
					lRet	:=	.T.
				Else
					lRet	:=	.F.
					Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique o par�mentro WHB_METRO." ,{"OK"},2)						
				EndIf	
			Else
				lRet	:=	.F.	
				Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique o par�mentro WHB_METRO." ,{"OK"},2)										
			EndIf				
			
		Case cRotina	==  "WHB_ENGEN"   //Indica quais s�o os c�digos dos usu�rios da engenharia que poder�o aprovar o documento.
			cUser	:=	"{"+Getmv("WHB_ENGEN")+"}"
			aUser	:=	&cUser//Departamentos autorizados a aprovar e geras revis�es
			dbSelectArea(cString)
			QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
			If QAA->(DBSeek(xFilial(cString)+cMatr))
				If !Empty(AScan(aUser,ALLTRIM(QAA->QAA_MAT)))
					lRet	:=	.T.
				Else
					lRet	:=	.F.
					Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique o par�mentro WHB_ENGEN." ,{"OK"},2)						
				EndIf	
			Else
				lRet	:=	.F.	
				Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique o par�mentro WHB_ENGEN." ,{"OK"},2)										
			EndIf			
			
		OtherWise
			lRet	:=	.F.
			Aviso("TPPAV002->Atencao!","Rotina sem de controle de al�ada",{"OK"},2)					
	EndCase	

Else
	dbSelectArea(cString)
	QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
	If QAA->(DBSeek(xFilial(cString)+cMatr))
		If !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN)))
			lRet	:=	.T.
		Else
			lRet	:=	.F.
			Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique os par�mentros WHB_CARGO e WHB_DPTO." ,{"OK"},2)						
		EndIf	
	Else
		lRet	:=	.F.	
		Aviso("TPPAV002->Atencao!","O usu�rio n�o tem permiss�o para assinar o documento. Verifique os par�mentros WHB_CARGO e WHB_DPTO." ,{"OK"},2)										
	EndIf 
EndIf	
RestArea(aArea)
Return (lRet)
