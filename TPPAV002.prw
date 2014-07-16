#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAV002  º Autor ³ HANDERSON DUARTE   º Data ³  05/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação no campo WH4_ASS conforme os parâmetros.         º±±
±±º          ³ WHB_CARGO = indica quais serão os cargos que poderão       º±±
±±º          ³ aprovar este documento.                                    º±±
±±º          ³ WHB_DPTO = Indica quais serão os departamentos que poderão º±±
±±º          ³ aprovar este documento									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PPAP - WHB MP 10 R 1.2 MSSQL                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAV002 (cMatr,cRotina)
Local lRet	:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCargo	:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart	:=	"{"+Getmv("WHB_DPTO")+"}"
Private cUser	
Private aUser	
Private aCargo	:=	&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart	:=	&cDepart//Departamentos autorizados a aprovar e geras revisões
Private cString := "QAA"
Private aArea	:=	QAA->(GetArea())
If ValType(cRotina)=="C"
	Do Case
		Case cRotina	==  "ZC9"   //Indica quais os usuario (QAA) poderao aprovar o processo de Historicos do Processo
			cUser	:=	"{"+Getmv("WHB_APRHIS")+"}"
			aUser	:=	&cUser//Departamentos autorizados a aprovar e geras revisões
			dbSelectArea(cString)
			QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
			If QAA->(DBSeek(xFilial(cString)+cMatr))
				If !Empty(AScan(aUser,ALLTRIM(QAA->QAA_MAT)))
					lRet	:=	.T.
				Else
					lRet	:=	.F.
					Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique o parâmentro WHB_APRHIS." ,{"OK"},2)						
				EndIf	
			Else
				lRet	:=	.F.	
				Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique o parâmentro WHB_APRHIS." ,{"OK"},2)										
			EndIf 
			
		Case cRotina	==  "WHB_METRO"   //Indica quais são os códigos dos usuários da metrologia que poderão aprovar o documento.
			cUser	:=	"{"+Getmv("WHB_METRO")+"}"
			aUser	:=	&cUser//Departamentos autorizados a aprovar e geras revisões
			dbSelectArea(cString)
			QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
			If QAA->(DBSeek(xFilial(cString)+cMatr))
				If !Empty(AScan(aUser,ALLTRIM(QAA->QAA_MAT)))
					lRet	:=	.T.
				Else
					lRet	:=	.F.
					Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique o parâmentro WHB_METRO." ,{"OK"},2)						
				EndIf	
			Else
				lRet	:=	.F.	
				Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique o parâmentro WHB_METRO." ,{"OK"},2)										
			EndIf				
			
		Case cRotina	==  "WHB_ENGEN"   //Indica quais são os códigos dos usuários da engenharia que poderão aprovar o documento.
			cUser	:=	"{"+Getmv("WHB_ENGEN")+"}"
			aUser	:=	&cUser//Departamentos autorizados a aprovar e geras revisões
			dbSelectArea(cString)
			QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
			If QAA->(DBSeek(xFilial(cString)+cMatr))
				If !Empty(AScan(aUser,ALLTRIM(QAA->QAA_MAT)))
					lRet	:=	.T.
				Else
					lRet	:=	.F.
					Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique o parâmentro WHB_ENGEN." ,{"OK"},2)						
				EndIf	
			Else
				lRet	:=	.F.	
				Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique o parâmentro WHB_ENGEN." ,{"OK"},2)										
			EndIf			
			
		OtherWise
			lRet	:=	.F.
			Aviso("TPPAV002->Atencao!","Rotina sem de controle de alçada",{"OK"},2)					
	EndCase	

Else
	dbSelectArea(cString)
	QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  
	If QAA->(DBSeek(xFilial(cString)+cMatr))
		If !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN)))
			lRet	:=	.T.
		Else
			lRet	:=	.F.
			Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique os parâmentros WHB_CARGO e WHB_DPTO." ,{"OK"},2)						
		EndIf	
	Else
		lRet	:=	.F.	
		Aviso("TPPAV002->Atencao!","O usuário não tem permissão para assinar o documento. Verifique os parâmentros WHB_CARGO e WHB_DPTO." ,{"OK"},2)										
	EndIf 
EndIf	
RestArea(aArea)
Return (lRet)
