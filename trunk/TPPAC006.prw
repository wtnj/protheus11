
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  TPPAC006   º Autor ³ Handerson Duarte   º Data ³  30/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Pedido Interno                                 º±±
±±º          ³ Tabela ZC0                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 MSSQL                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC006() 
Local aCores := {{"	ZC0_STAREV	.AND. Empty(ZC0_APROV)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
                 {"	!ZC0_STAREV"						       ,"BR_PRETO" },;                //Revisão obsoleta
                 {"ZC0_APROV=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC0_APROV=='N'" 						      ,"DISABLE" }}                //Reprovado
                                               

Private cCadastro := "Cadastro de Pedido Interno"

Private cCargo:="{"+Getmv("WHB_CARGO")+"}"
Private cDepart:="{"+Getmv("WHB_DPTO")+"}"
Private aCargo:=&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart:=&cDepart//Departamentos autorizados a aprovar e geras revisões

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ³
//³ MBROWSE sera identica a da AXCADASTRO:                              ³
//³                                                                     ³
//³ cDelFunc  := ".T."                                                  ³
//³ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ³
//³                { "Visualizar"   ,"AxVisual" , 0, 2},;               ³
//³                { "Incluir"      ,"AxInclui" , 0, 3},;               ³
//³                { "Alterar"      ,"AxAltera" , 0, 4},;               ³
//³                { "Excluir"      ,"AxDeleta" , 0, 5} }               ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC006A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC006B (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC006E (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC006C (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC006D (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR003 ()"	,0,8},;        		     
        		     {"Legenda		","U_PPAC006H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC0"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return 
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC006H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC006A (nOpc) 

AxInclui( cString,,,,,,"U_PPAC006F  ("+AllTrim(Str(nOpc))+")",,,)  


Return ()
//==========================Fim da Incluisão de Registros==========================================
//===============================Alterar Registros=================================================  
User Function PPAC006B (nOpc) 
Local lRet := ''
If Empty(DtoS(ZC0->ZC0_DATAF)) .AND. ZC0->ZC0_STAREV
	lRet := AxAltera(cString,,nOpc,,,,,"U_PPAC006F  ("+AllTrim(Str(nOpc))+")",,,) 
Else
	MsgAlert("O registro não pode ser alterado, pois já existe uma data fim ou é uma revisão obsoleta","TPPAC006->PPAC006B("+AllTrim(Str(nOpc))+") Alteração")	
EndIf

Return (lRet)
//==========================Fim da Alteração de Registros==========================================
//===============================Gerar Versão     =================================================  
User Function PPAC006C (nOpc)
Local 	lRet		:=	.F. 
Local 	cTexto		:=	""
Local 	cTitulo		:=	""
Local 	nRecNo		:=	ZC0->(RecNo())
Local	nRecNoAtu	:=	0	
Local 	aAreaZC0	:=	ZC0->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC0->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

If !Empty (DtoS(ZC0->ZC0_DATAF)) .AND. ZC0->ZC0_STAREV //Só poderá gerar revisão se tiver data fim
	dbSelectArea("ZC0")
	ZC0->(DBGoTo(nRecNo)) 
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
		For nCont:=1 to Len(aStru)
			TRB->&(aStru[nCont][1]) := ZC0->&(aStru[nCont][1])
		Next nCont
		TRB->ZC0_REV	:=	sfRevisao (ZC0->ZC0_NUMPED)//Nova Revisão
		TRB->ZC0_DATAF	:=  StoD(" / / ")
		TRB->ZC0_APROV	:=	""
		TRB->ZC0_STAREV	:=	.T.
		TRB->ZC0_ASS	:=	""		
		TRB->ZC0_DTREV	:=	dDataBase 
		TRB->ZC0_MOTIVO := " "		
	TRB->(MsUnLock())
	
	BEGIN TRANSACTION
		TRB->(DBGotop())
		dbSelectArea("ZC0")
		ZC0->(dbSetOrder(1))//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV+ZC0_NUMPED
		If !ZC0->(DBSeek(xFilial("ZC0")+TRB->ZC0_CODCLI+TRB->ZC0_LOJA+TRB->ZC0_PECA+TRB->ZC0_REV+TRB->ZC0_NUMPED))
			lRet:=RecLock("ZC0",.T.)
				If lRet
					For nCont := 1 TO FCount() 	
						FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
					Next nCont
					ZC0->ZC0_FILIAL := TRB->ZC0_FILIAL					
				EndIf
			nRecNoAtu:=ZC0->(RecNo())
			ZC0->(MsUnLock())  								
			
			dbSelectArea("ZC0") //Atualiza o registro como vesão não atual
			ZC0->(DBGoTo(nRecNo)) 
			lRet:=RecLock("ZC0",.F.)
				If lRet 
					ZC0->ZC0_STAREV	:=	.F.
				EndIf	
			ZC0->(MsUnLock()) 				
							       
		Else
			lRet:=.F.
		EndIf 
		If !lRet
			DisarmTransaction()
			RollBackSX8()
			cTitulo:="TPPAC006->PPAC006C("+AllTrim(Str(nOpc))+") Revisão"
			cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro"
		Else
			cTitulo:="TPPAC006->PPAC006C("+AllTrim(Str(nOpc))+") Revisão"
			cTexto:="Revisão gerada com sucesso"			
		EndIf 
	END TRANSACTION 
	
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else 
		//ZC0->(DBGoTo(nRecNoAtu)) 
//		MsgAlert(cTexto,cTitulo)		
		//Exclui a nova revisão arrumar
/*
		If U_PPAC006B (6) == 0		//CHAMA A ROTINA DE ALTERAÇÃO PARA REVISÕES
			RecLock("ZC0",.F.)
				DbDelete()
			ZC0->(MsUnLock())  
		Else
			RecLock("ZC0",.F.) 
				DbDelete()
			ZC0->(MsUnLock()) 
*/			
			ZC0->(DBGoTo(nRecNo))    
			RecLock("ZC0",.F.) 
				ZC0->ZC0_STAREV := .T.
			ZC0->(MsUnLock())
//		EndIf 
	EndIf
Else
	MsgAlert("Só poderá ser gerada a revisão caso tenha da fim ou não seja uma revisão obsoleta ","TPPAC006->PPAC006C("+AllTrim(Str(nOpc))+") Revisão")		
EndIf	

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC0)

Return ()
//==========================Fim da Geração de Versão     ==========================================
//===============================Aprovação de Registros ===========================================  
User Function PPAC006D (nOpc)//7
Local nRecNo	:=	ZC0->(RecNo()) 
Local aUser	 	:= {}
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC0->ZC0_APROV) .OR. AllTrim(ZC0->ZC0_APROV)=="N" ) .AND. ZC0->ZC0_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
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
				If !APMsgNoYes("Aprovar o pedido interno?","Aprovar?")
				   	U_PPAC006G	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL) //Reprovar
				Else
				   	U_PPAC006G	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)	//Aprovar
							
				EndIf		
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC006->PPAC006D("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser alterado caso o pedido que ainda não esteja aprovado ou que seja uma revisão atualizada",;
			"TPPAC006->PPAC006D("+AllTrim(Str(nOpc))+") Pedido Aprovado")			
EndIf

RestArea(aAreaQAA)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//===============================Exlcusão de Registros=============================================  
User Function PPAC006E (nOpc)
/* 
Local nRecNo	:=	ZC0->(RecNo()) 
Local lRet		:=	U_PPAC006F  (nOpc)
If lRet
	AxDeleta(cString,nRecNo,nOpc,,,,,)
EndIf
*/

MsgStop("Não é permitito excluir os registros","TPPAC006->PPAC006E("+AllTrim(Str(nOpc))+")")
Return ()
//==========================Fim da Exclusão de Registros ==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
User Function PPAC006G (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC0	:= 	ZC0->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	"" 
Do Case 
   	Case nOpc==7//Aprocação
		dbSelectArea("ZC0")
		ZC0->(DBGoTo(nRecNo)) 
		RecLock("ZC0",.F.)
			ZC0->ZC0_DATAF 		:=dDataBase		
			ZC0->ZC0_APROV		:="S" 
		ZC0->(MsUnLock()) 		         

	Case nOpc==8//Reprovaçào
		dbSelectArea("ZC0")
		ZC0->(DBGoTo(nRecNo))		
		RecLock("ZC0",.F.)	
			ZC0->ZC0_DATAF 		:=dDataBase		
			ZC0->ZC0_APROV		:="N" 
		ZC0->(MsUnLock()) 
		While Empty(cMensagem)	 
			Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
			cMensagem:=sfJustif ( )	//chamada da tela de justificativa
		EndDo				
		//Grava na tabela de justificativas
		dbSelectArea("ZC0")
		ZC0->(DBGoTo(nRecNo))		
		RecLock("ZCC",.T.)	
			ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
			ZCC->ZCC_CODDOC	:=	ZC0->ZC0_NUMPED
			ZCC->ZCC_REV	:=	ZC0->ZC0_REV			
			ZCC->ZCC_TABELA	:=	"ZC0"                   
			ZCC->ZCC_TEXTO	:=	cMensagem						
			ZCC->ZCC_DATA	:=	dDataBase			
			ZCC->ZCC_USUAR	:=	ZC0->ZC0_ASS
		ZCC->(MsUnLock())
		
			     
				
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC0->ZC0_ASS,"QAA_EMAIL")
		//Chamada da funcão do e-mail
//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprovação Pedido Interno",ZC0->ZC0_NUMPED,ZC0->ZC0_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprovação Pedido Interno "+ZC0->ZC0_NUMPED ,cEMail,cEMailRem,)
		EndIf

		
EndCase	

RestArea(aAreaZC0)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
//=================================================================================================
/*------------------------------------------------------------\
| Validação para Inclusão, Alteração, Excluir dos Registros	  |	
\------------------------------------------------------------*/
User Function PPAC006F (nOpc) 
Local lRet		:=	.T. 
Local nRecNo	:=	IIF((nOpc==4 .OR. nOpc==6),ZC0->(RECNO()),0) //Só para alteração de registro ou Alteração para nova revisão.
Local aAreaZC0	:= 	ZC0->(GetArea())
Local nContReg	:=	0//Contador de Registros
Local cEMail	:=	"" 
Local aUser		:=	{} 

PswOrder(1)
If PswSeek( __cuserid, .T. )
  aUser := PswRet() // Retorna vetor com informações do usuário
EndIf

Do Case 
	Case nOpc==3//Inclusão
		DBSelectArea("ZC0") 
		ZC0->(DBGoTop())
		DBSetOrder(1)//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV
		If ZC0->(DBSeek(xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)))
			lRet:=.F.
			MsgAlert("Já Existe pedido para o cliente com a respectiva peça. Pedido: "+ZC0->ZC0_NUMPED,;
						"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido já cadastrado")
		Else
			lRet:=.T. 
		EndIf             
		
	Case nOpc==4//Alteração
		If Empty(M->ZC0_APROV) .OR. AllTrim(M->ZC0_APROV)=="N"//Só poderá ser alterado caso o pedido que ainda não esteja aprovado
			DBSelectArea("ZC0")
			ZC0->(DBGoTop())			
			DBSetOrder(1)//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV 
			If ZC0->(DBSeek(xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)))
				Do While ZC0->(!EoF()) .AND. (ZC0->(ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) == ;
						  (xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) .AND. lRet
						 
					If	nRecNo <> ZC0->(RECNO()) 
						lRet:=.F.					 
						MsgAlert("Já Existe pedido para o cliente com a respectiva peça. Pedido: "+ZC0->ZC0_NUMPED,;
									"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido já cadastrado")					
					Else
						lRet:=.T.
					EndIF 					
					ZC0->(DBSkip())
				EndDo
			Else
				lRet:=.T.					
			EndIf//Fim do DBSeek
		Else 
			lRet:=.F.
			MsgAlert("Só poderá ser alterado caso o pedido que ainda não esteja aprovado.",;
					"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido Aprovado")			
		EndIf
		If lRet//Enviar um e-mail ao responsável
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC0->ZC0_ASS,"QAA_EMAIL")
			cMensagem:=sfTexto("Alteração Pedido Interno",ZC0->ZC0_NUMPED,ZC0->ZC0_REV,Posicione("QAA",6,aUser[1][2],"QAA_MAT"),"Alteração do Pedido Interno")//Para HTML
			If !Empty(cEMail) 
				//Chamada da funcão do e-mail			
		//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)			
				U_TWHBX001 (cMensagem,"Alteração Pedido Interno "+ZC0->ZC0_NUMPED ,cEMail,,)
			EndIf								
		EndIf 
		
	Case nOpc==5//Excluir
		If Empty(ZC0->ZC0_ASS) .AND. ZC0->ZC0_REV=="00"
			lRet:=.T.
		Else
			lRet:=.F. 
			MsgAlert("O pedido em questão não pode ser excluído, pois há assinatura ou/e a revisão é maior que '00'.",;
						"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido não pode ser excluído")			
		EndIf
		
	Case nOpc==6// Gerar Revisão
	If !Empty(M->ZC0_MOTIVO) //Para novas revisão é obrigatório preencher o motivo da revisão
		If Empty(M->ZC0_APROV) .OR. AllTrim(M->ZC0_APROV)=="N"//Só poderá ser alterado caso o pedido que ainda não esteja aprovado
			DBSelectArea("ZC0")
			ZC0->(DBGoTop())			
			DBSetOrder(1)//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV 
			If ZC0->(DBSeek(xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)))
				Do While ZC0->(!EoF()) .AND. (ZC0->(ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) == ;
						  (xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) .AND. lRet
						 
					If	nRecNo <> ZC0->(RECNO()) 
						lRet:=.F.					 
						MsgAlert("Já Existe pedido para o cliente com a respectiva peça. Pedido: "+ZC0->ZC0_NUMPED,;
									"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Revisão")					
					Else
						lRet:=.T.
					EndIF 					
					ZC0->(DBSkip())
				EndDo
			Else
				lRet:=.T.					
			EndIf//Fim do DBSeek
		Else 
			lRet:=.F.
			MsgAlert("Só poderá ser alterado caso o pedido que ainda não esteja aprovado.",;
					"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Revisão")			
		EndIf
	Else
		lRet:=.F.
		MsgAlert("O Campo Motivo da Revisão é obrigatório.",;
				"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Revisão")			
	EndIf					 	
		
EndCase	

RestArea(aAreaZC0)
Return(lRet)
//=================================================================================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cNUMPED)
Local cRet		:=	""
Local aAreaZC0	:=	ZC0->(GetArea())
DBSelectArea("ZC0")
ZC0->(DBGoTop())
DBSetOrder(3)//ZC0_FILIAL, ZC0_NUMPED, ZC0_APROV
If ZC0->(DBSeek(xFilial("ZC0")+cNUMPED))
	Do While ZC0->(!EoF()) .AND. (ZC0->(ZC0_FILIAL+ZC0_NUMPED)) == ;
			  (xFilial("ZC0")+(cNUMPED))
		cRet:=ZC0->ZC0_REV			 					
		ZC0->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC0)
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

