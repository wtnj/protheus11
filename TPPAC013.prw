#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC013  º Autor ³ Handerso Duarte    º Data ³  16/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Poka Yoke                                      º±±
±±º          ³ Tabela ZC4                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 R 1.2 MSSQL                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC013 ()
Local aCores := {{"	ZC4_STAREV	.AND. Empty(ZC4_STATUS)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
                 {"	!ZC4_STAREV"						       ,"BR_PRETO" },;                //Revisão obsoleta
                 {"ZC4_STATUS=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC4_STATUS=='N'"						      ,"DISABLE" }}                //Reprovado


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persistências forem concluídas com êxito.
Private cCadastro 	:=	"Cadastro de Poka Yoke"
Private cCargo		:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart		:=	"{"+Getmv("WHB_DPTO")+"}"
Private aCargo		:=	&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart		:=	&cDepart//Departamentos autorizados a aprovar e geras revisões

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC013A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC013A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC013A (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC013A (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC013A (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR010"	,0,8},;        		     
        		     {"Legenda		","U_PPAC013H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC4"

dbSelectArea("ZC4")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC013H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC013A (nOpc) 
Local nRecNo	:=	IIF(nOpc<>3,ZC4->(RecNo()),0)
Local lFlag		:=	.T.  
Local cAprovAnt		:= ""
Local cStaRevAnt	:= "" 
Local nRecNoAnt		:= '' 

Do Case
	Case nOpc == 3 //Inclusao
		AxInclui( cString,,,,,,"U_PPAC013B  ("+AllTrim(Str(nOpc))+")",,,)
		  
	Case nOpc == 4 //Alteracao
		If Empty(ZC4->ZC4_STATUS) .AND. ZC4->ZC4_STAREV
			AxAltera(cString,,nOpc,,,,,"U_PPAC013B  ("+AllTrim(Str(nOpc))+")",,,) 
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC013->PPAC013A("+AllTrim(Str(nOpc))+") Alteração"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta"
		EndIf
		 
	Case nOpc == 5 //Excluir 
		lFlag		:=	.F.
		cTitulo		:=	"TPPAC013->PPAC013A("+AllTrim(Str(nOpc))+") Exclusão"	
		cTexto		:=	"Não é permitido efetuar exclusão dos Registros."
		
	Case nOpc == 6 //Gerar revisão
		If !Empty(ZC4->ZC4_STATUS) .AND. ZC4->ZC4_STAREV   
		
			DBSelectArea("ZC4")
			ZC4->(DBgoto(nRecNo))    
			cAprovAnt	:= ZC4->ZC4_STATUS
			cStaRevAnt	:= ZC4->ZC4_STAREV
			nRecNoAnt	:= nRecNo
			
			nRecNo		:=	sfGerRev(nRecNo,nOpc)
			If nRecNo<>0
				DBSelectArea("ZC4")
				ZC4->(DBgoto(nRecNo))
				If AxAltera(cString,,4,,,,,"U_PPAC013B  ("+AllTrim(Str(nOpc))+")",,,) = 3 
								
					RecLock("ZC4",.F.) 
						DbDelete()
					ZC4->(MsUnLock())
					
					ZC4->(DBGoTo(nRecNoAnt))    
					RecLock("ZC4",.F.) 
						ZC4->ZC4_STATUS	:= cAprovAnt
						ZC4->ZC4_STAREV := cStaRevAnt
					ZC4->(MsUnLock())
			
				EndIf 
			EndIf
		Else
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC013->PPAC013A("+AllTrim(Str(nOpc))+") Gerar Revisão"	
			cTexto		:=	"O registro não pode ser alterado, pois não foi aprovado/reprovado ou é uma revisão obsoleta."		
		EndIf		
	Case nOpc == 7 //Aprovar/Reprovar
		If Empty(ZC4->ZC4_STATUS) .AND. ZC4->ZC4_STAREV
			sfAprovar (nRecNo,nOpc)//7	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC013->PPAC013A("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta."							
		EndIf	
		
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC013->PPAC013A("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."
				
EndCase
If !lFlag
	MsgAlert(cTexto,cTitulo)			
EndIf
Return ()
//==========================Fim da Incluisão de Registros==========================================
//==========================Validação para Gravação================================================
User Function PPAC013B (nOpc)
Local lRet		:=	.T.
Local aArea		:=	ZC4->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC4->(REcNo()),0)
Local cMensagem	:=	"Há um documento pendente para análise."
Local cEMail	:=	""
cTitulo	:=	""	
cTexto	:=	""

Do Case
	Case nOpc == 3 //Inclusao 
		DBselectArea("ZC4")
		ZC4->(DBSetOrder(1))//ZC4_FILIAL, ZC4_PKYK, ZC4_REV, R_E_C_N_O_, D_E_L_E_T_
		If !ZC4->(DBSeek(xFilial("ZC4")+M->(ZC4_PKYK+ZC4_REV)))
			lRet:=.T.
		Else
			lRet:=.F.
			cTitulo:="TPPAC013->PPAC013A->PPAC013B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC4->ZC4_PKYK+" Revisão "+ZC4->ZC4_REV
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC4->ZC4_COORD,"QAA_EMAIL")
			cMensagem:=sfTexto("Situação Pendente "+cCadastro,M->ZC4_PKYK,M->ZC4_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situação Pendente "+cCadastro+" "+M->ZC4_PKYK ,cEMail,"",)
			EndIf		
		EndIf
		
	Case nOpc == 4 //Alteraçao
		DBselectArea("ZC4") 
		ZC4->(DBSetOrder(1))//ZC4_FILIAL, ZC4_PKYK, ZC4_REV, R_E_C_N_O_, D_E_L_E_T_
		ZC4->(DBGotop())		
		If ZC4->(DBSeek(xFilial("ZC4")+M->(ZC4_PKYK+ZC4_REV)))
			Do While ZC4->(!EoF()) .AND. ZC4->(ZC4_FILIAL+ZC4_PKYK+ZC4_REV)==(xFilial("ZC4")+M->(ZC4_PKYK+ZC4_REV)) .AND. lRet
				If ZC4->(RecNo())<>nRecNo  
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC4->(DBSkip())
			EndDo
		Else
			lRet:=.F.
			cTitulo:="TPPAC013->PPAC013A->PPAC013B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Não há registro a ser alterado. Erro na operação de Alteração."
		EndIf 
		 
		
	Case nOpc == 6 //Gerar Revisão
		DBselectArea("ZC4") 
		ZC4->(DBSetOrder(1))//ZC4_FILIAL+ZC4_PKYK+ZC4_REV
		ZC4->(DBGotop())		
		If ZC4->(DBSeek(xFilial("ZC4")+M->(ZC4_PKYK+ZC4_REV)))
			Do While ZC4->(!EoF()) .AND. ZC4->(ZC4_FILIAL+ZC4_PKYK+ZC4_REV)==(xFilial("ZC4")+M->(ZC4_PKYK+ZC4_REV)) .AND. lRet
				If ZC4->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC4->(DBSkip())
			EndDo
		Else
			lRet:=.F.
			cTitulo:="TPPAC013->PPAC013A->PPAC013B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Não há registro a ser alterado. Erro na operação de Alteração."
		EndIf
		If lRet .AND. Empty(M->ZC4_MOTIVO)
			lRet:=.F.
			cTitulo:="TPPAC013->PPAC013A->PPAC013B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="É necessário informar o movito da revisão."								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC4->ZC4_COORD,"QAA_EMAIL")
			cMensagem:=sfTexto("Situação Pendente "+cCadastro,M->ZC4_PKYK,M->ZC4_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situação Pendente "+cCadastro+" "+M->ZC4_PKYK ,cEMail,"",)
			EndIf		
		EndIf						
		
	OtherWise	
		lRet:=.F.
		cTitulo:="TPPAC013->PPAC013A->PPAC013B("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."
EndCase	

RestArea(aArea)
If !lRet
	MsgAlert(cTexto,cTitulo)	
EndIf
Return(lRet)
//==========================Fim da Validação para Gravação=========================================
//==========================Gera revião ===========================================================
Static Function sfGerRev(nRecNo,nOpc)
Local 	lRet		:=	.F. 
Local	nRecNoAtu	:=	0 
Local 	nCont		:=	0	
Local 	aAreaZC4	:=	ZC4->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC4->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

dbSelectArea("ZC4")
ZC4->(DBGoTo(nRecNo)) 
dbSelectArea("TRB")
RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC4->&(aStru[nCont][1])
	Next nCont
	TRB->ZC4_REV	:=	sfRevisao (ZC4->ZC4_PKYK)//Nova Revisão
	TRB->ZC4_APCOR 	:=  StoD(" / / ")
	TRB->ZC4_STATUS	:=	""
	TRB->ZC4_STAREV	:=	.T.		
	TRB->ZC4_MOTIVO	:=	""		
	TRB->ZC4_DTREV	:=	dDataBase		
TRB->(MsUnLock())

BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC4")
	ZC4->(dbSetOrder(1))//ZC4_FILIAL+ZC4_PKYK+ZC4_REV
	If !ZC4->(DBSeek(xFilial("ZC4")+TRB->(ZC4_PKYK+ZC4_REV)))
		lRet:=RecLock("ZC4",.T.)
			If lRet
				For nCont := 1 TO FCount() 	
					FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC4->ZC4_FILIAL := TRB->ZC4_FILIAL					
			EndIf
		nRecNoAtu:=ZC4->(RecNo())
		ZC4->(MsUnLock())  								
		
		dbSelectArea("ZC4") //Atualiza o registro como vesão não atual
		ZC4->(DBGoTo(nRecNo)) 
		lRet:=RecLock("ZC4",.F.)
			If lRet 
				ZC4->ZC4_STAREV	:=	.F.
			EndIf	
		ZC4->(MsUnLock()) 				
						       
	Else
		lRet:=.F.
	EndIf 
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC013->PPAC013B->sfGerRev("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro"
	Else
		cTitulo:="TPPAC013->PPAC013B->sfGerRev("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Revisão gerada com sucesso"			
	EndIf 
END TRANSACTION 

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC4)
lTudoOK:=lRet
Return(nRecNoAtu)
//==========================Fim Gera revisão======================================== 
//===============================Aprovação de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC4	:=	ZC4->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC4->ZC4_STATUS) .OR. AllTrim(ZC4->ZC4_STATUS)=="N" ) .AND. ZC4->ZC4_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
	  aUser := PswRet() // Retorna vetor com informações do usuário
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
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC013->PPAC013A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser Aprovado/Reprovado caso o registro que ainda não esteja aprovado ou que seja uma revisão atualizada",;
			"TPPAC013->PPAC013A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC4)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC4	:= 	ZC4->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cPKYK	:=	""
Local cREV	:=	""
dbSelectArea("ZC4")
ZC4->(DBSetOrder(1)) //ZC4_FILIAL,ZC4_PKYK,ZC4_REV
ZC4->(DBGoTo(nRecNo))
cPKYK	:=	ZC4->ZC4_PKYK
cREV	:=	ZC4->ZC4_REV   
BEGIN TRANSACTION
	Do Case
		Case	ZC4->ZC4_COORD==cMatr
			If ZC4->(DBSeek(xFilial("ZC4")+cPKYK+cREV))
				lFlag:=RecLock("ZC4",.F.)
					ZC4->ZC4_APCOR 		:=dDataBase		
					If nOpc==7  //Aprovação
						ZC4->ZC4_STATUS		:="S"
					ElseIf nOpc==8//Reprovaçào 
						ZC4->ZC4_STATUS		:="N"
					EndIf					
				ZC4->(MsUnLock())
			Else 
				lFlag:=.F.
				cTexto:="O Registro não encontrado. Erro na operação"
				cTitulo:="TPPAC013->PPAC013A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf 
			 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
			cTitulo:="TPPAC013->PPAC013A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			
	EndCase
	
	If  !lFlag  //Desfaz a transação se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	MsgStop(cTexto,cTitulo)
EndIf

If lFlag .AND. nOpc==8//Reprovaçào 		
	While Empty(cMensagem)	 
		Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
		cMensagem:=sfJustif ( )	//chamada da tela de justificativa
	EndDo				
	//Grava na tabela de justificativas
	dbSelectArea("ZC4")
	ZC4->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC4->ZC4_PKYK
		ZCC->ZCC_REV	:=	ZC4->ZC4_REV			
		ZCC->ZCC_TABELA	:=	"ZC4"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC4->ZC4_COORD,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprovação "+cCadastro,ZC4->ZC4_PKYK,ZC4->ZC4_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC4->ZC4_PKYK ,cEMail,"",)})
	EndIf	
EndIf
If lFlag .AND. nOpc==7//Aprovado
	cMensagem:="O registro da Rotina "+cCadastro+" Numero de Controle "+ZC4->ZC4_PKYK+"-"+ZC4->ZC4_REV+" foi aprovado."
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC4->ZC4_COORD,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Registro Aprovado"+cCadastro,ZC4->ZC4_PKYK,ZC4->ZC4_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Registro Aprovado"+cCadastro+" "+ZC4->ZC4_PKYK ,cEMail,"",)})
	EndIf	
EndIf

RestArea(aAreaZC4)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cPKYK)
Local cRet		:=	""
Local aAreaZC4	:=	ZC4->(GetArea())
DBSelectArea("ZC4")
ZC4->(DBGoTop())
ZC4->(DBSetOrder(1))//ZC4_FILIAL+ZC4_PKYK+ZC4_REV
If ZC4->(DBSeek(xFilial("ZC4")+cPKYK))
	Do While ZC4->(!EoF()) .AND. (ZC4->(ZC4_FILIAL+ZC4_PKYK)) == ;
			  (xFilial("ZC4")+(cPKYK))
		cRet:=ZC4->ZC4_REV			 					
		ZC4->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC4)
Return (cRet)
//================================FIM DA REVISÃO ================================================== 
//================================JUSTIFICATIVA DA REPROVAÇÃO======================================
Static Function sfJustif ( )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetTexto  := ""

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgEmail","oGetTexto","oBtnEnviar","oGetMemo")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgEmail  := MSDialog():New( 168,253,451,948,"Justificativa da Reprovação",,,.F.,,,,,,.T.,,,.T. )
//oGetTexto  := TGet():New( 020,004,{|u| If(PCount()>0,cGetTexto:=u,cGetTexto)},oDlgEmail,336,114,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTexto",,)
@ 020,004 GET cGetTexto MEMO SIZE 336,114 OF oDlgEmail PIXEL HSCROLL
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||IIF(Empty(AllTrim(cGetTexto)),,oDlgEmail:End())},037,012,,,,.T.,,"",,,,.F. )

oDlgEmail:Activate(,,,.T.)
Return (cGetTexto)
//================================FIM DA REPROVAÇÃO================================================ 
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
cHTML	+='    <td width="115" class="style5">Responsável</td>'
cHTML	+='    <td width="377"><span class="style5">'+Posicione("QAA",1,xFilial("QAA")+cMatr,"QAA_NOME")+' </span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><span class="style8">Mensagem automática do sistema Protheus. Favor não responder</span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='</body>'
cHTML	+='</html>'
Return(cHTML)

//================================FIM DO TEXTO JUSTIFICATIVA =============================================