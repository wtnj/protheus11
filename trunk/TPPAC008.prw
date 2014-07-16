#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC008  º Autor ³ HANDERSON DUARTE   º Data ³  15/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Características Especiais ZC7                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 R 1.2 MSSQL                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC008 () 
Local aCores := {{"	ZC7_STAREV	.AND. Empty(ZC7_APROV)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
                 {"	!ZC7_STAREV"						       ,"BR_PRETO" },;                //Revisão obsoleta
                 {"ZC7_APROV=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC7_APROV=='N'" 						      ,"DISABLE" }}                //Reprovado

Private cCadastro := "Cadastro de Caracteristicas Especiais" 

Private cCargo:="{"+Getmv("WHB_CARGO")+"}"
Private cDepart:="{"+Getmv("WHB_DPTO")+"}"
Private aCargo:=&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart:=&cDepart//Departamentos autorizados a aprovar e geras revisões

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC008A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC008B (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC008E (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC008C (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC008D (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR005 ()"	,0,8},;        		     
        		     {"Legenda		","U_PPAC008H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC7"

dbSelectArea("ZC7")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC008H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC008A (nOpc) 

AxInclui( cString,,,,,,"U_PPAC008F  ("+AllTrim(Str(nOpc))+")",,,)


Return ()
//==========================Fim da Incluisão de Registros==========================================
//===============================Alterar Registros=================================================  
User Function PPAC008B (nOpc) 
Local lRet := ''
If Empty(ZC7->ZC7_APROV) .AND. ZC7->ZC7_STAREV
	lRet := AxAltera(cString,,nOpc,,,,,"U_PPAC008F  ("+AllTrim(Str(nOpc))+")",,,)
Else
	MsgAlert("O registro não pode ser alterado, pois já existe uma data de aprovação ou é uma revisão obsoleta","TPPAC008->PPAC008B("+AllTrim(Str(nOpc))+") Alteração")	
EndIf

Return (lRet)
//==========================Fim da Alteração de Registros==========================================
//===============================Gerar Versão     =================================================  
User Function PPAC008C (nOpc)
Local 	lRet		:=	.F. 
Local 	cTexto		:=	""
Local 	cTitulo		:=	""
Local 	nRecNo		:=	ZC7->(RecNo())
Local	nRecNoAtu	:=	0	
Local 	aAreaZC7	:=	ZC7->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC7->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

If !Empty(ZC7->ZC7_APROV) .AND. ZC7->ZC7_STAREV //Só poderá gerar revisão se não tiver data fim
	dbSelectArea("ZC7")
	ZC7->(DBGoTo(nRecNo)) 
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
		For nCont:=1 to Len(aStru)
			TRB->&(aStru[nCont][1]) := ZC7->&(aStru[nCont][1])
		Next nCont
		TRB->ZC7_REV	:=	sfRevisao (ZC7->ZC7_NUMCAR)//Nova Revisão
		TRB->ZC7_DTENG	:=  StoD(" / / ")
		TRB->ZC7_DTQUAL	:=  StoD(" / / ")
		TRB->ZC7_DTPROD	:=  StoD(" / / ")				
		TRB->ZC7_APROV	:=	""
		TRB->ZC7_STAREV	:=	.T.		
		TRB->ZC7_DTREV	:=	dDataBase		
	TRB->(MsUnLock())
	
	BEGIN TRANSACTION
		TRB->(DBGotop())
		dbSelectArea("ZC7")
		ZC7->(dbSetOrder(1))//ZC7_FILIAL+ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV+ZC7_NUMCAR
		If !ZC7->(DBSeek(xFilial("ZC7")+TRB->ZC7_CODCLI+TRB->ZC7_LOJA+TRB->ZC7_CODWHB+TRB->ZC7_REV+TRB->ZC7_NUMCAR))
			lRet:=RecLock("ZC7",.T.)
				If lRet
					For nCont := 1 TO FCount() 	
						FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
					Next nCont
					ZC7->ZC7_FILIAL := TRB->ZC7_FILIAL					
				EndIf
			nRecNoAtu:=ZC7->(RecNo())
			ZC7->(MsUnLock())  								
			
			dbSelectArea("ZC7") //Atualiza o registro como vesão não atual
			ZC7->(DBGoTo(nRecNo)) 
			lRet:=RecLock("ZC7",.F.)
				If lRet 
					ZC7->ZC7_STAREV	:=	.F.
				EndIf	
			ZC7->(MsUnLock()) 				
							       
		Else
			lRet:=.F.
		EndIf 
		If !lRet
			DisarmTransaction()
			RollBackSX8()
			cTitulo:="TPPAC008->PPAC008C("+AllTrim(Str(nOpc))+") Revisão"
			cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro"
		Else
			cTitulo:="TPPAC008->PPAC008C("+AllTrim(Str(nOpc))+") Revisão"
			cTexto:="Revisão gerada com sucesso"			
		EndIf 
	END TRANSACTION 
	
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else 
		ZC7->(DBGoTo(nRecNoAtu)) 
//		MsgAlert(cTexto,cTitulo)
//			U_PPAC008B (6) //CHAMA A ROTINA DE ALTERAÇÃO PARA REVISÕES		
		If U_PPAC008B(6) == 3		//CHAMA A ROTINA DE ALTERAÇÃO PARA REVISÕES
			RecLock("ZC7",.F.) 
				DbDelete()
			ZC7->(MsUnLock()) 
			
			ZC7->(DBGoTo(nRecNo))    
			RecLock("ZC7",.F.) 
				ZC7->ZC7_STAREV := .T.
			ZC7->(MsUnLock())
		EndIf 
	EndIf
Else
	MsgAlert("Só poderá ser gerada a revisão caso o registro esteja aprovado ou reprovado ou não seja uma revisão obsoleta ","TPPAC008->PPAC008C("+AllTrim(Str(nOpc))+") Revisão")		
EndIf	

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC7)

Return ()
//==========================Fim da Geração de Versão     ==========================================
//===============================Aprovação de Registros ===========================================  
User Function PPAC008D (nOpc)//7
Local nRecNo	:=	ZC7->(RecNo()) 
Local aUser	 	:= {}
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC7->ZC7_APROV) .OR. AllTrim(ZC7->ZC7_APROV)=="N" ) .AND. ZC7->ZC7_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
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
				If !APMsgNoYes("Aprovar o pedido interno","Aprovar?")
					U_PPAC008G	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL) //Reprovar
				Else
					U_PPAC008G	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)	//Aprovar		
				EndIf		
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC008->PPAC008D("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser alterado caso o pedido que ainda não esteja aprovado ou que seja uma revisão atualizada",;
			"TPPAC008->PPAC008D("+AllTrim(Str(nOpc))+") Pedido Aprovado")			
EndIf

RestArea(aAreaQAA)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//===============================Exlcusão de Registros=============================================  
User Function PPAC008E (nOpc)
/* 
Local nRecNo	:=	ZC7->(RecNo()) 
Local lRet		:=	U_PPAC008F  (nOpc)
If lRet
	AxDeleta(cString,nRecNo,nOpc,,,,,)
EndIf
*/

MsgStop("Não é permitito excluir os registros","TPPAC008->PPAC008E("+AllTrim(Str(nOpc))+")")
Return ()
//==========================Fim da Exclusão de Registros ==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
User Function PPAC008G (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC7	:= 	ZC7->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
dbSelectArea("ZC7")
ZC7->(DBGoTo(nRecNo))
Do Case
	Case	ZC7->ZC7_COPRO==cMatr
		If Empty(DtoS(ZC7->ZC7_DTPROD))
			RecLock("ZC7",.F.)
				ZC7->ZC7_DTPROD		:=dDataBase		
			ZC7->(MsUnLock())
		Else 
			lFlag:=.F.
			MsgAlert("O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma",;
					"TPPAC004->PPAC004G("+AllTrim(Str(nOpc))+") Aprovação")			
		EndIf 
		
	Case	ZC7->ZC7_GERQUA==cMatr 
		If Empty(DtoS(ZC7->ZC7_DTQUAL))
			RecLock("ZC7",.F.)
				ZC7->ZC7_DTQUAL		:=dDataBase		
			ZC7->(MsUnLock())
		Else 
			lFlag:=.F.
			MsgAlert("O Registro já foi aprovada pela Qualidade e não poderá ser alterada a data da mesma",;
					"TPPAC004->PPAC004G("+AllTrim(Str(nOpc))+") Aprovação")			
		EndIf 		 
		
	Case	ZC7->ZC7_GERENG==cMatr 
		If Empty(DtoS(ZC7->ZC7_DTENG))
			RecLock("ZC7",.F.)
				ZC7->ZC7_DTENG		:=dDataBase		
			ZC7->(MsUnLock())
		Else 
			lFlag:=.F.		
			MsgAlert("O Registro já foi aprovada pela Engenharia e não poderá ser alterada a data da mesma",;
					"TPPAC004->PPAC004G("+AllTrim(Str(nOpc))+") Aprovação")			
		EndIf 
				
	OtherWise
		lFlag:=.F.
		MsgStop("Usuário não faz parte do documento. A operação não proderá ser gravada.",;
				"TPPAC004->PPAC004G("+AllTrim(Str(nOpc))+") Aprovação")			 		 			
		
EndCase

If lFlag	
	dbSelectArea("ZC7")
	ZC7->(DBGoTo(nRecNo))
	If nOpc==7  //Aprovação
		If !Empty(DtoS(ZC7->ZC7_DTPROD)) .AND. !Empty(DtoS(ZC7->ZC7_DTQUAL)) .AND. !Empty(DtoS(ZC7->ZC7_DTENG))//Se todas as datas estiverem preenchida o registro está aprovado
			RecLock("ZC7",.F.)
				ZC7->ZC7_APROV		:="S"
			ZC7->(MsUnLock()) 	
		EndIf
	ElseIf nOpc==8//Reprovaçào 
		RecLock("ZC7",.F.)
			ZC7->ZC7_APROV		:="N"
		ZC7->(MsUnLock())
		
		While Empty(cMensagem)	 
			Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
			cMensagem:=sfJustif ( )	//chamada da tela de justificativa
		EndDo				
		//Grava na tabela de justificativas
		dbSelectArea("ZC7")
		ZC7->(DBGoTo(nRecNo))		
		RecLock("ZCC",.T.)	
			ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
			ZCC->ZCC_CODDOC	:=	ZC7->ZC7_NUMCAR
			ZCC->ZCC_REV	:=	ZC7->ZC7_REV			
			ZCC->ZCC_TABELA	:=	"ZC7"                   
			ZCC->ZCC_TEXTO	:=	cMensagem						
			ZCC->ZCC_DATA	:=	dDataBase			
			ZCC->ZCC_USUAR	:=	cMatr
		ZCC->(MsUnLock())
				
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_COPRO,"QAA_EMAIL")
		//Chamada da funcão do e-mail
//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprovação Caracteristicas Especiais",ZC7->ZC7_NUMCAR,ZC7->ZC7_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprovação Caracteristicas Especiais"+ZC7->ZC7_NUMCAR ,cEMail,"",)
		EndIf
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERQUA,"QAA_EMAIL")
		//Chamada da funcão do e-mail
//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprovação Caracteristicas Especiais",ZC7->ZC7_NUMCAR,ZC7->ZC7_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprovação Caracteristicas Especiais"+ZC7->ZC7_NUMCAR ,cEMail,"",)
		EndIf
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERENG,"QAA_EMAIL")
		//Chamada da funcão do e-mail
//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprovação Caracteristicas Especiais",ZC7->ZC7_NUMCAR,ZC7->ZC7_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprovação Caracteristicas Especiais"+ZC7->ZC7_NUMCAR ,cEMail,"",)
		EndIf	
		 		
	EndIf
EndIf

RestArea(aAreaZC7)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//=================================================================================================
/*------------------------------------------------------------\
| Validação para Inclusão, Alteração, Excluir dos Registros	  |	
\------------------------------------------------------------*/
User Function PPAC008F (nOpc) 
Local lRet		:=	.T. 
Local nRecNo	:=	IIF((nOpc==4 .OR. nOpc==6),ZC7->(RECNO()),0) //Só para alteração de registro ou Alteração para nova revisão.
Local aAreaZC7	:= 	ZC7->(GetArea())
Local cEMail	:=	"" 
Local aUser		:=	{} 

PswOrder(1)
If PswSeek( __cuserid, .T. )
  aUser := PswRet() // Retorna vetor com informações do usuário
EndIf

Do Case 
	Case nOpc==3//Inclusão
		DBSelectArea("ZC7") 
		ZC7->(DBGoTop())
		DBSetOrder(1)//ZC7_FILIAL+ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV
		If ZC7->(DBSeek(xFilial("ZC7")+M->(ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)))
			lRet:=.F.
			MsgAlert("Já Existe registro para o cliente com o respectivo produto. Registro: "+ZC7->ZC7_NUMCAR,;
						"TPPAC008->PPAC008F("+AllTrim(Str(nOpc))+") Registro já cadastrado")
		Else
			lRet:=.T. 
		EndIf             
		
	Case nOpc==4//Alteração
		If Empty(M->ZC7_APROV) .OR. AllTrim(M->ZC7_APROV)=="N"//Só poderá ser alterado caso ainda não esteja aprovado
			DBSelectArea("ZC7")
			ZC7->(DBGoTop())			
			DBSetOrder(1)//ZC7_FILIAL+ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV 
			If ZC7->(DBSeek(xFilial("ZC7")+M->(ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)))
				Do While ZC7->(!EoF()) .AND. (ZC7->(ZC7_FILIAL+ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)) == ;
						  (xFilial("ZC7")+M->(ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)) .AND. lRet
						 
					If	nRecNo <> ZC7->(RECNO()) 
						lRet:=.F.					 
						MsgAlert("Já Existe registro para o cliente com o respectivo produto. Registro: "+ZC7->ZC7_NUMCAR,;
									"TPPAC008->PPAC008F("+AllTrim(Str(nOpc))+") Registro já cadastrado")					
					Else
						lRet:=.T.
					EndIF 					
					ZC7->(DBSkip())
				EndDo
			Else
				lRet:=.T.					
			EndIf//Fim do DBSeek
		Else 
			lRet:=.F.
			MsgAlert("Só poderá ser alterado caso o registro ainda não esteja aprovado.",;
					"TPPAC008->PPAC008F("+AllTrim(Str(nOpc))+") Registro Aprovado")			
		EndIf
		If lRet//Enviar um e-mail aos responsáveis 
			cMensagem:=sfTexto("Alteração Caracteristicas Especiais",ZC7->ZC7_NUMCAR,ZC7->ZC7_REV,Posicione("QAA",6,aUser[1][2],"QAA_MAT"),"Alteração Caracteristicas Especiais")//Para HTML		
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_COPRO,"QAA_EMAIL")
			If !Empty(cEMail) 
				//Chamada da funcão do e-mail			
		//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)			
				U_TWHBX001 (cMensagem,"Alteração Caracteristicas Especiais"+ZC7->ZC7_NUMCAR ,cEMail,,)
			EndIf
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERQUA,"QAA_EMAIL")
			If !Empty(cEMail) 						
				U_TWHBX001 (cMensagem,"Alteração Caracteristicas Especiais"+ZC7->ZC7_NUMCAR ,cEMail,,)
			EndIf
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERENG,"QAA_EMAIL")
			If !Empty(cEMail) 		
				U_TWHBX001 (cMensagem,"Alteração Caracteristicas Especiais"+ZC7->ZC7_NUMCAR ,cEMail,,)
			EndIf														
		EndIf 
		
	Case nOpc==5//Excluir
		If (Empty(M->ZC7_APROV) .OR. AllTrim(M->ZC7_APROV)=="N") .AND. ZC7->ZC7_REV=="00"
			lRet:=.T.
		Else
			lRet:=.F. 
			MsgAlert("O registro em questão não pode ser excluído, pois há assinatura ou/e a revisão é maior que '00'.",;
						"TPPAC008->PPAC008F("+AllTrim(Str(nOpc))+") Registro não pode ser excluído")			
		EndIf
		
	Case nOpc==6// Gerar Revisão
		If !Empty(M->ZC7_MOTIVO) //Para novas revisão é obrigatório preencher o motivo da revisão
			DBSelectArea("ZC7")
			ZC7->(DBGoTop())			
			DBSetOrder(1)//ZC7_FILIAL+ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV 
			If ZC7->(DBSeek(xFilial("ZC7")+M->(ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)))
				Do While ZC7->(!EoF()) .AND. (ZC7->(ZC7_FILIAL+ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)) == ;
						  (xFilial("ZC7")+M->(ZC7_CODCLI+ZC7_LOJA+ZC7_CODWHB+ZC7_REV)) .AND. lRet
						 
					If	nRecNo <> ZC7->(RECNO()) 
						lRet:=.F.					 
						MsgAlert("Já Existe registro para o cliente com o respectivo produto. Registro: "+ZC7->ZC7_NUMCAR,;
									"TPPAC008->PPAC008F("+AllTrim(Str(nOpc))+") Revisão")					
					Else
						lRet:=.T.
					EndIF 					
					ZC7->(DBSkip())
				EndDo
			Else
				lRet:=.T.					
			EndIf//Fim do DBSeek
		Else
			lRet:=.F.
			MsgAlert("O Campo Motivo da Revisão é obrigatório.",;
					"TPPAC008->PPAC008F("+AllTrim(Str(nOpc))+") Revisão")			
		EndIf					 	
		
EndCase	

RestArea(aAreaZC7)
Return(lRet)
//=================================================================================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cNUMCAR)
Local cRet		:=	""
Local aAreaZC7	:=	ZC7->(GetArea())
DBSelectArea("ZC7")
ZC7->(DBGoTop())
DBSetOrder(2)//ZC7_FILIAL, ZC7_NUMCAR, ZC7_APROV
If ZC7->(DBSeek(xFilial("ZC7")+cNUMCAR))
	Do While ZC7->(!EoF()) .AND. (ZC7->(ZC7_FILIAL+ZC7_NUMCAR)) == ;
			  (xFilial("ZC7")+(cNUMCAR))
		cRet:=ZC7->ZC7_REV			 					
		ZC7->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC7)
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
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||oDlgEmail:End()},037,012,,,,.T.,,"",,,,.F. )

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


