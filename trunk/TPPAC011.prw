#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAC011  � Autor � Handerso Duarte    � Data �  07/02/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de An�lise Cr�tica T�cnica                        ���
���          � Tabela ZC2                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � WHB MP10 R 1.2 MSSQL                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAC011 ()
Local aCores := {{"	ZC2_STAREV	.AND. Empty(ZC2_STATUS)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revis�o ou aprovacao
                 {"	!ZC2_STAREV"						       ,"BR_PRETO" },;                //Revis�o obsoleta
                 {"ZC2_STATUS=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC2_STATUS=='N'"						      ,"DISABLE" }}                //Reprovado


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persist�ncias forem conclu�das com �xito.
Private cCadastro 	:=	"Cadastro de An�lise Cr�tica T�cnica"
Private cCargo		:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart		:=	"{"+Getmv("WHB_DPTO")+"}"
Private aCargo		:=	&cCargo   //Cagos autorizados a aprovar e geras revis�es
Private aDepart		:=	&cDepart//Departamentos autorizados a aprovar e geras revis�es

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC011A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC011A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC011A (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC011A (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC011A (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR008()"	,0,8},;        		     
        		     {"Legenda		","U_PPAC011H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC2"

dbSelectArea("ZC2")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC011H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC011A (nOpc) 
Local nRecNo	:=	IIF(nOpc<>3,ZC2->(RecNo()),0)
Local lFlag		:=	.T.  
local lRet := ''    
Local cAprovAnt		:= ""
Local cStaRevAnt	:= "" 
Local nRecNoAnt		:= '' 
Do Case
	Case nOpc == 3 //Inclusao
		AxInclui( cString,,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,)
		  
	Case nOpc == 4 //Alteracao
		If Empty(ZC2->ZC2_STATUS) .AND. ZC2->ZC2_STAREV
			AxAltera(cString,,nOpc,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,) 
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Altera��o"	
			cTexto		:=	"O registro n�o pode ser alterado, pois j� foi aprovado/reprovado ou � uma revis�o obsoleta"
		EndIf
		 
	Case nOpc == 5 //Excluir 
		lFlag		:=	.F.
		cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Exclus�o"	
		cTexto		:=	"N�o � permitido efetuar exclus�o dos Registros."
		
	Case nOpc == 6 //Gerar revis�o
		If !Empty(ZC2->ZC2_STATUS) .AND. ZC2->ZC2_STAREV  
			nRecNoAnt   := nRecNo
			cAprovAnt	:= ZC2->ZC2_STATUS
		    cStaRevAnt	:= ZC2->ZC2_STAREV
			nRecNo		:=	sfGerRev(nRecNo,nOpc)
			If lTudoOK
				DBSelectArea("ZC2")
				ZC2->(DBgoto(nRecNo))
				//lRet := AxAltera(cString,,4,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,) 
				
				If AxAltera(cString,,4,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,) == 3		//CHAMA A ROTINA DE ALTERA��O PARA REVIS�ES
					RecLock("ZC2",.F.) 
						DbDelete()
					ZC2->(MsUnLock()) 
					
					ZC2->(DBGoTo(nRecNoAnt))    
					RecLock("ZC2",.F.) 
						ZC2->ZC2_STATUS	:= cAprovAnt
						ZC2->ZC2_STAREV := cStaRevAnt
					ZC2->(MsUnLock())
				EndIf 
		
			EndIf
		Else
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Gerar Revis�o"	
			cTexto		:=	"O registro n�o pode ser alterado, pois n�o foi aprovado/reprovado ou � uma revis�o obsoleta."		
		EndIf		
	Case nOpc == 7 //Aprovar/Reprovar
		If Empty(ZC2->ZC2_STATUS) .AND. ZC2->ZC2_STAREV
			sfAprovar (nRecNo,nOpc)//7	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro n�o pode ser alterado, pois j� foi aprovado/reprovado ou � uma revis�o obsoleta."							
		EndIf	
		
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC011->PPAC011A("+AllTrim(Str(nOpc))+")"
		cTexto:="Opera��o n�o configurada."
				
EndCase
If !lFlag
	MsgAlert(cTexto,cTitulo)			
EndIf
Return (lRet)
//==========================Fim da Incluis�o de Registros==========================================
//==========================Valida��o para Grava��o================================================
User Function PPAC011B (nOpc)
Local lRet		:=	.T.
Local aArea		:=	ZC2->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC2->(REcNo()),0)
Local cMensagem	:=	"H� um documento pendente para an�lise."
Local cEMail	:=	""
cTitulo	:=	""	
cTexto	:=	""

Do Case
	Case nOpc == 3 //Inclusao
		DBselectArea("ZC2")
		ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
		If !ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)))
			ZC2->(DBSetOrder(6))//ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ
			If !ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)))
				lRet:=.T.
			Else
				lRet:=.F.
				cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
				cTexto:="J� existe registro com o mesmo Produto e Projeto. Verifique "+ZC2->ZC2_ACT+" Revis�o "+ZC2->ZC2_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="J� existe registro com a mesma numera��o de controle e revis�o. Verifique "+ZC2->ZC2_ACT+" Revis�o "+ZC2->ZC2_REV
		EndIf
		If lRet .AND. M->ZC2_CARCLI=="1" .AND. Empty(M->ZC2_CARAC)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo Carac. Cliente(ZC2_CARCLI) for sim, ent�o � necess�rio informar o campo Quais (ZC2_CARAC)"								
		EndIf		
		If lRet .AND. M->ZC2_ANATEC=="1" .AND. Empty(M->ZC2_RELAT)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo An�lise T�cnica (ZC2_ANATEC) for sim, ent�o � necess�rio informar o campo Relatar (ZC2_RELAT)"								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situa��o Pendente "+cCadastro,M->ZC2_ACT,M->ZC2_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situa��o Pendente "+cCadastro+" "+M->ZC2_ACT ,cEMail,"",)
			EndIf		
		EndIf
		
	Case nOpc == 4 //Altera�ao
		DBselectArea("ZC2") 
		ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
		ZC2->(DBGotop())		
		If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)))
			Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_ACT+ZC2_REV)==(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)) .AND. lRet
				If ZC2->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC2->(DBSkip())
			EndDo
			If lRet
				ZC2->(DBSetOrder(6))//ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ
				ZC2->(DBGotop())				
				If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)))
					Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ)==(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)) .AND. lRet
						If ZC2->(RecNo())<>nRecNo .AND. ZC2->ZC2_ACT<>M->ZC2_ACT
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC2->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Altera��o"
						cTexto:="J� existe registro com o mesmo Produto e Projeto. Verifique "+ZC2->ZC2_ACT+" Revis�o "+ZC2->ZC2_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Altera��o"
				cTexto:="J� existe registro com a mesma numera��o de controle e revis�o. Verifique "+ZC2->ZC2_ACT+" Revis�o "+ZC2->ZC2_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="N�o h� registro a ser alterado. Erro na opera��o de Altera��o."
		EndIf 
		If lRet .AND. M->ZC2_CARCLI=="1" .AND. Empty(M->ZC2_CARAC)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="Se campo Carac. Cliente(ZC2_CARCLI) for sim, ent�o � necess�rio informar o campo Quais (ZC2_CARAC)"								
		EndIf		
		If lRet .AND. M->ZC2_ANATEC=="1" .AND. Empty(M->ZC2_RELAT)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Altera��o"
			cTexto:="Se campo An�lise T�cnica (ZC2_ANATEC) for sim, ent�o � necess�rio informar o campo Relatar (ZC2_RELAT)"								
		EndIf		 
		
	Case nOpc == 6 //Gerar Revis�o
		DBselectArea("ZC2") 
		ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
		ZC2->(DBGotop())		
		If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)))
			Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_ACT+ZC2_REV)==(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)) .AND. lRet
				If ZC2->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC2->(DBSkip())
			EndDo
			If lRet
				ZC2->(DBSetOrder(6))//ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ
				ZC2->(DBGotop())				
				If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)))
					Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ)==(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)) .AND. lRet
						If ZC2->(RecNo())<>nRecNo .AND. M->ZC2_ACT<>ZC2->ZC2_ACT
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC2->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revis�o"
						cTexto:="J� existe registro com o mesmo Produto e Projeto. Verifique "+ZC2->ZC2_ACT+" Revis�o "+ZC2->ZC2_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revis�o"
				cTexto:="J� existe registro com a mesma numera��o de controle e revis�o. Verifique "+ZC2->ZC2_ACT+" Revis�o "+ZC2->ZC2_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="N�o h� registro a ser alterado. Erro na opera��o de Altera��o."
		EndIf
		If lRet .AND. Empty(M->ZC2_MOTIVO)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="� necess�rio informar o movito da revis�o."								
		EndIf
		If lRet .AND. M->ZC2_CARCLI=="1" .AND. Empty(M->ZC2_CARAC)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="Se campo Carac. Cliente(ZC2_CARCLI) for sim, ent�o � necess�rio informar o campo Quais (ZC2_CARAC)"								
		EndIf		
		If lRet .AND. M->ZC2_ANATEC=="1" .AND. Empty(M->ZC2_RELAT)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revis�o"
			cTexto:="Se campo An�lise T�cnica (ZC2_ANATEC) for sim, ent�o � necess�rio informar o campo Relatar (ZC2_RELAT)"								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situa��o Pendente "+cCadastro,M->ZC2_ACT,M->ZC2_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situa��o Pendente "+cCadastro+" "+M->ZC2_ACT ,cEMail,"",)
			EndIf		
		EndIf						
		
	OtherWise	
		lRet:=.F.
		cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+")"
		cTexto:="Opera��o n�o configurada."
EndCase	

RestArea(aArea)
If !lRet
	MsgAlert(cTexto,cTitulo)	
EndIf
Return(lRet)
//==========================Fim da Valida��o para Grava��o=========================================
//==========================Gera revi�o ===========================================================
Static Function sfGerRev(nRecNo,nOpc)
Local 	lRet		:=	.F. 
Local	nRecNoAtu	:=	0 
Local 	nCont		:=	0	
Local 	aAreaZC2	:=	ZC2->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC2->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

dbSelectArea("ZC2")
ZC2->(DBGoTo(nRecNo)) 
dbSelectArea("TRB")
RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC2->&(aStru[nCont][1])
	Next nCont
	TRB->ZC2_REV	:=	sfRevisao (ZC2->ZC2_ACT)//Nova Revis�o
	TRB->ZC2_APPRO	:=  StoD(" / / ")
	TRB->ZC2_STATUS	:=	""
	TRB->ZC2_STAREV	:=	.T.		
	TRB->ZC2_MOTIVO	:=	""		
	TRB->ZC2_DTREV	:=	dDataBase		
TRB->(MsUnLock())

BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC2")
	ZC2->(dbSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
	If !ZC2->(DBSeek(xFilial("ZC2")+TRB->(ZC2_ACT+ZC2_REV)))
		lRet:=RecLock("ZC2",.T.)
			If lRet
				For nCont := 1 TO FCount() 	
					FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC2->ZC2_FILIAL := TRB->ZC2_FILIAL					
			EndIf
		nRecNoAtu:=ZC2->(RecNo())
		ZC2->(MsUnLock())  								
		
		dbSelectArea("ZC2") //Atualiza o registro como ves�o n�o atual
		ZC2->(DBGoTo(nRecNo)) 
		lRet:=RecLock("ZC2",.F.)
			If lRet 
				ZC2->ZC2_STAREV	:=	.F.
			EndIf	
		ZC2->(MsUnLock()) 				
						       
	Else
		lRet:=.F.
	EndIf 
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC011->PPAC011B->sfGerRev("+AllTrim(Str(nOpc))+") Revis�o"
		cTexto:="Erro ao gerar a revis�o, verifique se h� algum usu�rio realizado altera��es no registro"
	Else
		cTitulo:="TPPAC011->PPAC011B->sfGerRev("+AllTrim(Str(nOpc))+") Revis�o"
		cTexto:="Revis�o gerada com sucesso"			
	EndIf 
END TRANSACTION 

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC2)
lTudoOK:=lRet
Return(nRecNoAtu)
//==========================Fim Gera revis�o======================================== 
//===============================Aprova��o de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC2	:=	ZC2->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC2->ZC2_STATUS) .OR. AllTrim(ZC2->ZC2_STATUS)=="N" ) .AND. ZC2->ZC2_STAREV//S� poder� ser aprovado caso o pedido que ainda n�o esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
	  aUser := PswRet() // Retorna vetor com informa��es do usu�rio
	EndIf
	
	DBSelectArea("QAA") 
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))
		Do While QAA->(!EoF()) .AND. AllTrim(QAA->QAA_LOGIN)==AllTrim(aUser[1][2]) .AND. lFlag
			If !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN)))
				
				lFlag:=.F.
				If !APMsgNoYes("Aprovar o Registro","Aprovar?")
					Processa({||sfAprvRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL)}) //Reprovar
				Else
					Processa({||sfAprvRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)})	//Aprovar		
				EndIf		
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usu�rio sem permiss�o para aprovar o documento.","TPPAC011->PPAC011A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")
	EndIf
Else
	MsgAlert("S� poder� ser Aprovado/Reprovado caso o registro que ainda n�o esteja aprovado ou que seja uma revis�o atualizada",;
			"TPPAC011->PPAC011A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC2)

Return ()
//==========================Fim da Aprova��o de Registros==========================================
//================================APROVA��O OU REPROVA��O DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC2	:= 	ZC2->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cACT	:=	""
Local cREV	:=	""
dbSelectArea("ZC2")
ZC2->(DBSetOrder(1)) //ZC2_FILIAL,ZC2_ACT,ZC2_REV
ZC2->(DBGoTo(nRecNo))
cACT	:=	ZC2->ZC2_ACT
cREV	:=	ZC2->ZC2_REV   
BEGIN TRANSACTION
	Do Case
		Case	ZC2->ZC2_RESP==cMatr
			If ZC2->(DBSeek(xFilial("ZC2")+cACT+cREV))
				lFlag:=RecLock("ZC2",.F.)
					ZC2->ZC2_APPRO		:=dDataBase		
					If nOpc==7  //Aprova��o
						ZC2->ZC2_STATUS		:="S"
					ElseIf nOpc==8//Reprova��o 
						ZC2->ZC2_STATUS		:="N"
					EndIf					
				ZC2->(MsUnLock())
			Else 
				lFlag:=.F.
				cTexto:="O Registro n�o encontrado. Erro na opera��o"
				cTitulo:="TPPAC011->PPAC011A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"
			EndIf 
			 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usu�rio n�o faz parte do documento. A opera��o n�o proder� ser gravada."
			cTitulo:="TPPAC011->PPAC011A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"
			
	EndCase
	
	If  !lFlag  //Desfaz a transa��o se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	MsgStop(cTexto,cTitulo)
EndIf

If lFlag .AND. nOpc==8//Reprova��o 		
	While Empty(cMensagem)	 
		Alert('O preenchimento da Justificativa de Reprova��o � obrigatorio!')	
		cMensagem:=sfJustif ( )	//chamada da tela de justificativa
	EndDo				
	//Grava na tabela de justificativas
	dbSelectArea("ZC2")
	ZC2->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC2->ZC2_ACT
		ZCC->ZCC_REV	:=	ZC2->ZC2_REV			
		ZCC->ZCC_TABELA	:=	"ZC2"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_EMAIL")
	//Chamada da func�o do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprova��o "+cCadastro,ZC2->ZC2_ACT,ZC2->ZC2_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprova��o "+cCadastro+" "+ZC2->ZC2_ACT ,cEMail,"",)})
	EndIf	
EndIf

RestArea(aAreaZC2)
Return( )
//========================FIM DA  APROVA��O OU REPROVA��O =========================================
//================================REVIS�O =========================================================
Static Function sfRevisao (cACT)
Local cRet		:=	""
Local aAreaZC2	:=	ZC2->(GetArea())
DBSelectArea("ZC2")
ZC2->(DBGoTop())
ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
If ZC2->(DBSeek(xFilial("ZC2")+cACT))
	Do While ZC2->(!EoF()) .AND. (ZC2->(ZC2_FILIAL+ZC2_ACT)) == ;
			  (xFilial("ZC2")+(cACT))
		cRet:=ZC2->ZC2_REV			 					
		ZC2->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revis�o
RestArea(aAreaZC2)
Return (cRet)
//================================FIM DA REVIS�O ================================================== 
//================================JUSTIFICATIVA DA REPROVA��O======================================
Static Function sfJustif ( )

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private cGetTexto  := ""

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgEmail","oGetTexto","oBtnEnviar","oGetMemo")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlgEmail  := MSDialog():New( 168,253,451,948,"Justificativa da Reprova��o",,,.F.,,,,,,.T.,,,.T. )
//oGetTexto  := TGet():New( 020,004,{|u| If(PCount()>0,cGetTexto:=u,cGetTexto)},oDlgEmail,336,114,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTexto",,)
@ 020,004 GET cGetTexto MEMO SIZE 336,114 OF oDlgEmail PIXEL HSCROLL
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||oDlgEmail:End()},037,012,,,,.T.,,"",,,,.F. )

oDlgEmail:Activate(,,,.T.)
Return (cGetTexto)
//================================FIM DA REPROVA��O================================================ 
//================================TEXTO JUSTIFICATIVA =============================================
Static Function sfTexto(cTitulo,cNum,cRev,cMatr,cTexto)
Local cHTML		:=	""
Local nCont		:=	0
Local cLinhaObs	:=	""
cHTML	+='<html >'
cHTML	+='<head>'
cHTML	+='<style type="text/css">'
cHTML	+='<!--'
cHTML	+='.style1 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 24px;'
cHTML	+='}'
cHTML	+='.style2 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 14px;'
cHTML	+='}'
cHTML	+='.style3 {font-family: Arial, Helvetica, sans-serif}'
cHTML	+='.style5 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 12px;'
cHTML	+='}'
cHTML	+='.style8 {font-family: Arial, Helvetica, sans-serif; font-size: 10px; }'
cHTML	+='-->'
cHTML	+='</style></head>'

cHTML	+='<body>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><div align="center"><strong><span class="style1">'+cTitulo+' '+cNum+'-'+cRev+'</span></strong></div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="497"><strong><span class="style2">Justificativa:</span></strong></td>'
cHTML	+='  </tr>'
cHTML	+='  <tr>'
cHTML	+='    <td height="142"><div align="left">'
		For nCont := 1 to MLCount( cTexto , 90 )
			cLinhaObs	:=Memoline( cTexto ,90, nCont )
			cHTML	+='      <p class="style3">'+cLinhaObs+'</p>'	  	       		
		Next nCont 
cHTML	+='      <p class="style3">&nbsp;</p>'
cHTML	+='    </div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="508" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="115" class="style5">Respons�vel</td>'
cHTML	+='    <td width="377"><span class="style5">'+Posicione("QAA",1,xFilial("QAA")+cMatr,"QAA_NOME")+' </span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><span class="style8">Mensagem autom�tica do sistema Protheus. Favor n�o responder</span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='</body>'
cHTML	+='</html>'
Return(cHTML)

//================================FIM DO TEXTO JUSTIFICATIVA =============================================
