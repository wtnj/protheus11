
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  TPPAC006   � Autor � Handerson Duarte   � Data �  30/12/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Pedido Interno                                 ���
���          � Tabela ZC0                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � WHB MP10 MSSQL                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAC006() 
Local aCores := {{"	ZC0_STAREV	.AND. Empty(ZC0_APROV)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revis�o ou aprovacao
                 {"	!ZC0_STAREV"						       ,"BR_PRETO" },;                //Revis�o obsoleta
                 {"ZC0_APROV=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC0_APROV=='N'" 						      ,"DISABLE" }}                //Reprovado
                                               

Private cCadastro := "Cadastro de Pedido Interno"

Private cCargo:="{"+Getmv("WHB_CARGO")+"}"
Private cDepart:="{"+Getmv("WHB_DPTO")+"}"
Private aCargo:=&cCargo   //Cagos autorizados a aprovar e geras revis�es
Private aDepart:=&cDepart//Departamentos autorizados a aprovar e geras revis�es

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������

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
//==========================Fim da Incluis�o de Registros==========================================
//===============================Alterar Registros=================================================  
User Function PPAC006B (nOpc) 
Local lRet := ''
If Empty(DtoS(ZC0->ZC0_DATAF)) .AND. ZC0->ZC0_STAREV
	lRet := AxAltera(cString,,nOpc,,,,,"U_PPAC006F  ("+AllTrim(Str(nOpc))+")",,,) 
Else
	MsgAlert("O registro n�o pode ser alterado, pois j� existe uma data fim ou � uma revis�o obsoleta","TPPAC006->PPAC006B("+AllTrim(Str(nOpc))+") Altera��o")	
EndIf

Return (lRet)
//==========================Fim da Altera��o de Registros==========================================
//===============================Gerar Vers�o     =================================================  
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

If !Empty (DtoS(ZC0->ZC0_DATAF)) .AND. ZC0->ZC0_STAREV //S� poder� gerar revis�o se tiver data fim
	dbSelectArea("ZC0")
	ZC0->(DBGoTo(nRecNo)) 
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
		For nCont:=1 to Len(aStru)
			TRB->&(aStru[nCont][1]) := ZC0->&(aStru[nCont][1])
		Next nCont
		TRB->ZC0_REV	:=	sfRevisao (ZC0->ZC0_NUMPED)//Nova Revis�o
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
			
			dbSelectArea("ZC0") //Atualiza o registro como ves�o n�o atual
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
			cTitulo:="TPPAC006->PPAC006C("+AllTrim(Str(nOpc))+") Revis�o"
			cTexto:="Erro ao gerar a revis�o, verifique se h� algum usu�rio realizado altera��es no registro"
		Else
			cTitulo:="TPPAC006->PPAC006C("+AllTrim(Str(nOpc))+") Revis�o"
			cTexto:="Revis�o gerada com sucesso"			
		EndIf 
	END TRANSACTION 
	
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else 
		//ZC0->(DBGoTo(nRecNoAtu)) 
//		MsgAlert(cTexto,cTitulo)		
		//Exclui a nova revis�o arrumar
/*
		If U_PPAC006B (6) == 0		//CHAMA A ROTINA DE ALTERA��O PARA REVIS�ES
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
	MsgAlert("S� poder� ser gerada a revis�o caso tenha da fim ou n�o seja uma revis�o obsoleta ","TPPAC006->PPAC006C("+AllTrim(Str(nOpc))+") Revis�o")		
EndIf	

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC0)

Return ()
//==========================Fim da Gera��o de Vers�o     ==========================================
//===============================Aprova��o de Registros ===========================================  
User Function PPAC006D (nOpc)//7
Local nRecNo	:=	ZC0->(RecNo()) 
Local aUser	 	:= {}
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC0->ZC0_APROV) .OR. AllTrim(ZC0->ZC0_APROV)=="N" ) .AND. ZC0->ZC0_STAREV//S� poder� ser aprovado caso o pedido que ainda n�o esteja aprovado
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
				If !APMsgNoYes("Aprovar o pedido interno?","Aprovar?")
				   	U_PPAC006G	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL) //Reprovar
				Else
				   	U_PPAC006G	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)	//Aprovar
							
				EndIf		
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usu�rio sem permiss�o para aprovar o documento.","TPPAC006->PPAC006D("+AllTrim(Str(nOpc))+") Aprova��o")
	EndIf
Else
	MsgAlert("S� poder� ser alterado caso o pedido que ainda n�o esteja aprovado ou que seja uma revis�o atualizada",;
			"TPPAC006->PPAC006D("+AllTrim(Str(nOpc))+") Pedido Aprovado")			
EndIf

RestArea(aAreaQAA)

Return ()
//==========================Fim da Aprova��o de Registros==========================================
//===============================Exlcus�o de Registros=============================================  
User Function PPAC006E (nOpc)
/* 
Local nRecNo	:=	ZC0->(RecNo()) 
Local lRet		:=	U_PPAC006F  (nOpc)
If lRet
	AxDeleta(cString,nRecNo,nOpc,,,,,)
EndIf
*/

MsgStop("N�o � permitito excluir os registros","TPPAC006->PPAC006E("+AllTrim(Str(nOpc))+")")
Return ()
//==========================Fim da Exclus�o de Registros ==========================================
//================================APROVA��O OU REPROVA��O DO PEDIDO================================
User Function PPAC006G (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC0	:= 	ZC0->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	"" 
Do Case 
   	Case nOpc==7//Aproca��o
		dbSelectArea("ZC0")
		ZC0->(DBGoTo(nRecNo)) 
		RecLock("ZC0",.F.)
			ZC0->ZC0_DATAF 		:=dDataBase		
			ZC0->ZC0_APROV		:="S" 
		ZC0->(MsUnLock()) 		         

	Case nOpc==8//Reprova��o
		dbSelectArea("ZC0")
		ZC0->(DBGoTo(nRecNo))		
		RecLock("ZC0",.F.)	
			ZC0->ZC0_DATAF 		:=dDataBase		
			ZC0->ZC0_APROV		:="N" 
		ZC0->(MsUnLock()) 
		While Empty(cMensagem)	 
			Alert('O preenchimento da Justificativa de Reprova��o � obrigatorio!')	
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
		//Chamada da func�o do e-mail
//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprova��o Pedido Interno",ZC0->ZC0_NUMPED,ZC0->ZC0_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprova��o Pedido Interno "+ZC0->ZC0_NUMPED ,cEMail,cEMailRem,)
		EndIf

		
EndCase	

RestArea(aAreaZC0)
Return( )
//========================FIM DA  APROVA��O OU REPROVA��O DO PEDIDO================================
//=================================================================================================
/*------------------------------------------------------------\
| Valida��o para Inclus�o, Altera��o, Excluir dos Registros	  |	
\------------------------------------------------------------*/
User Function PPAC006F (nOpc) 
Local lRet		:=	.T. 
Local nRecNo	:=	IIF((nOpc==4 .OR. nOpc==6),ZC0->(RECNO()),0) //S� para altera��o de registro ou Altera��o para nova revis�o.
Local aAreaZC0	:= 	ZC0->(GetArea())
Local nContReg	:=	0//Contador de Registros
Local cEMail	:=	"" 
Local aUser		:=	{} 

PswOrder(1)
If PswSeek( __cuserid, .T. )
  aUser := PswRet() // Retorna vetor com informa��es do usu�rio
EndIf

Do Case 
	Case nOpc==3//Inclus�o
		DBSelectArea("ZC0") 
		ZC0->(DBGoTop())
		DBSetOrder(1)//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV
		If ZC0->(DBSeek(xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)))
			lRet:=.F.
			MsgAlert("J� Existe pedido para o cliente com a respectiva pe�a. Pedido: "+ZC0->ZC0_NUMPED,;
						"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido j� cadastrado")
		Else
			lRet:=.T. 
		EndIf             
		
	Case nOpc==4//Altera��o
		If Empty(M->ZC0_APROV) .OR. AllTrim(M->ZC0_APROV)=="N"//S� poder� ser alterado caso o pedido que ainda n�o esteja aprovado
			DBSelectArea("ZC0")
			ZC0->(DBGoTop())			
			DBSetOrder(1)//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV 
			If ZC0->(DBSeek(xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)))
				Do While ZC0->(!EoF()) .AND. (ZC0->(ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) == ;
						  (xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) .AND. lRet
						 
					If	nRecNo <> ZC0->(RECNO()) 
						lRet:=.F.					 
						MsgAlert("J� Existe pedido para o cliente com a respectiva pe�a. Pedido: "+ZC0->ZC0_NUMPED,;
									"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido j� cadastrado")					
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
			MsgAlert("S� poder� ser alterado caso o pedido que ainda n�o esteja aprovado.",;
					"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido Aprovado")			
		EndIf
		If lRet//Enviar um e-mail ao respons�vel
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC0->ZC0_ASS,"QAA_EMAIL")
			cMensagem:=sfTexto("Altera��o Pedido Interno",ZC0->ZC0_NUMPED,ZC0->ZC0_REV,Posicione("QAA",6,aUser[1][2],"QAA_MAT"),"Altera��o do Pedido Interno")//Para HTML
			If !Empty(cEMail) 
				//Chamada da func�o do e-mail			
		//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)			
				U_TWHBX001 (cMensagem,"Altera��o Pedido Interno "+ZC0->ZC0_NUMPED ,cEMail,,)
			EndIf								
		EndIf 
		
	Case nOpc==5//Excluir
		If Empty(ZC0->ZC0_ASS) .AND. ZC0->ZC0_REV=="00"
			lRet:=.T.
		Else
			lRet:=.F. 
			MsgAlert("O pedido em quest�o n�o pode ser exclu�do, pois h� assinatura ou/e a revis�o � maior que '00'.",;
						"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Pedido n�o pode ser exclu�do")			
		EndIf
		
	Case nOpc==6// Gerar Revis�o
	If !Empty(M->ZC0_MOTIVO) //Para novas revis�o � obrigat�rio preencher o motivo da revis�o
		If Empty(M->ZC0_APROV) .OR. AllTrim(M->ZC0_APROV)=="N"//S� poder� ser alterado caso o pedido que ainda n�o esteja aprovado
			DBSelectArea("ZC0")
			ZC0->(DBGoTop())			
			DBSetOrder(1)//ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV 
			If ZC0->(DBSeek(xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)))
				Do While ZC0->(!EoF()) .AND. (ZC0->(ZC0_FILIAL+ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) == ;
						  (xFilial("ZC0")+M->(ZC0_CODCLI+ZC0_LOJA+ZC0_PECA+ZC0_REV)) .AND. lRet
						 
					If	nRecNo <> ZC0->(RECNO()) 
						lRet:=.F.					 
						MsgAlert("J� Existe pedido para o cliente com a respectiva pe�a. Pedido: "+ZC0->ZC0_NUMPED,;
									"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Revis�o")					
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
			MsgAlert("S� poder� ser alterado caso o pedido que ainda n�o esteja aprovado.",;
					"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Revis�o")			
		EndIf
	Else
		lRet:=.F.
		MsgAlert("O Campo Motivo da Revis�o � obrigat�rio.",;
				"TPPAC006->PPAC006F("+AllTrim(Str(nOpc))+") Revis�o")			
	EndIf					 	
		
EndCase	

RestArea(aAreaZC0)
Return(lRet)
//=================================================================================================
//================================REVIS�O =========================================================
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
cRet:=StrZero(Val(cRet)+1,2)//Nova Revis�o
RestArea(aAreaZC0)
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

