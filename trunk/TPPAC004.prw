#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC004  º Autor ³ HANDERSON DUARTE   º Data ³  23/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CADASTRO DA MATRIZ DE CORRELAÇÃO DO PROCESSO.              º±±
±±º          ³ TABELAS ZC5,ZCD,ZCE,ZCF MSSQL                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 - WHB                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/
User Function  TPPAC004() 
Local aCores := {{"ZC5_STAREV .AND. Empty(ZC5_APROV) "	       ,"BR_AMARELO" },;  //Pendente
                 {"!ZC5_STAREV "							   ,"BR_PRETO" },;    //Obsoleto
				 {"ZC5_APROV=='S'"  						   ,"BR_VERDE"},;     //Aprovado
				 {"ZC5_APROV=='N'"  						   ,"DISABLE"}}      //Reprovado


Private cCadastro	:= "Matriz de Correlação do Processo"
Private aCampo		:={}//Nome e Tipo do campo  

Private aRotina := { {"Pesquisar"	,"AxPesqui"				,0,1} ,;
					 {"Visualizar"	,"U_PPAC004E (2)"		,0,2} ,;
      				 {"Incluir"		,"U_PPAC004A (3)"		,0,3} ,;
      			     {"Alterar"		,"U_PPAC004B (4)"		,0,4} ,; //Verificar com a Débora. Foi mandado um e-mail 29/12/08				 					      			           			     
             		 {"Excluir"		,"U_PPAC004F (5)"		,0,5} ,;//Verificar com a Débora. Foi mandado um e-mail 29/12/08
             		 {"Imprimir"	,"U_TPPAR002"			,0,6},; //Verificar com a Débora. Foi mandado um e-mail 29/12/08
             		 {"Gerar Revisao","U_PPAC004G (7)"		,0,7},;//Verificar com a Débora. Foi mandado um e-mail 29/12/08
             		 {"Aprovar/Reprovar","U_PPAC004H (8)"	,0,8},;//Verificar com a Débora. Foi mandado um e-mail 29/12/08            		 
             		 {"Legenda"		,"U_PPAC004I"			,0,9} } 


Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock


Private cString := "ZC5"

dbSelectArea(cString)
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)



Return 
//=====================================================
//Funcao que Monta a Legenda
User Function PPAC004I() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//=====================================================
//===============================Aprovação de Registros ===========================================  
User Function PPAC004H (nOpc)
Local nRecNo	:=	ZC5->(RecNo()) 
Local aAreaQAA	:=	QAA->(GetArea()) 
Local aUser		:=	{}

If ZC5->ZC5_STAREV//Status da Revisão. Só poderá ser aprovado se a revisão for a atualizada.
	If Empty(ZC5->ZC5_APROV)//Só poderá ser aprovado ou reprovado se ainda não foi executado a mesmo operação
		PswOrder(1)
		If PswSeek( __cuserid, .T. )
		  aUser := PswRet() // Retorna vetor com informações do usuário
		EndIf	
		DBSelectArea("QAA") 
		QAA->(DBSetOrder(6))//QAA->QAA_LOGIN
		If QAA->(DBSeek(aUser[1][2])) //Verifica se o usuário está cadastrado no QAA, cadastro de usuário 
			If QAA->QAA_MAT == ZC5->ZC5_PRODU .OR. QAA->QAA_MAT == ZC5->ZC5_QUALI //O usuário logado tem que ser igual ao um dos usuário cadastrados na matriz
				If !APMsgNoYes("Aprovar a Matriz de Correlação","Aprovar?")
					sfAprRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL) //Reprovar
				Else
					sfAprRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)	//Aprovar		
				EndIf
			Else
				MsgStop("O usuário do sistema tem que ser o mesmo usuário do campo ZC5_PRODU ou ZC5_QUALI",;
						"TPPAC004->PPAC004H("+AllTrim(Str(nOpc))+") Aprovação")	
			EndIf
		Else
			MsgStop("Usuário sem permissão","TPPAC004->PPAC004H("+AllTrim(Str(nOpc))+") Aprovação")	
		EndIf
	Else
		MsgAlert("A matriz em questão já foi Aprovado ou reprovada e não poderá executada a mesmo operação",;
	 			"TPPAC004->PPAC004H("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser aprovado ou reprovado as Revisões mais Recentes",;
	 			"TPPAC004->PPAC004H("+AllTrim(Str(nOpc))+") Aprovação")	
EndIf	

RestArea(aAreaQAA)
Return ()
//==========================Fim da Aprovação de Registros==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprRep (nRecNo,nOpc,cMat,cEMailRem)  
Local aAreaZC5	:= 	ZC5->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Do Case 
	Case nOpc==7//Aprocação
		dbSelectArea("ZC5")
		ZC5->(DBGoTo(nRecNo))
		Do Case
			Case ZC5->ZC5_PRODU==cMat //Aprovação pela Produção
				If Empty(DtoS(ZC5->ZC5_DTPROD)) //Se a data de aprovação pela produção estiver preenchida, não poderá ser reaprovada
					If Empty(DtoS(ZC5->ZC5_DTQUAL)) //Se a data de aprovação não estiver preenchida, a matriz não poderá ser aprovada por completo. Só poderá ser aprovada por completo se o dois resposáveis à aprovarem
						RecLock("ZC5",.F.)
							ZC5->ZC5_DTPROD 	:=	dDataBase		
						ZC5->(MsUnLock())
					Else
						RecLock("ZC5",.F.)
							ZC5->ZC5_APROV		:=	"S"//Flag de aprovação
							ZC5->ZC5_DATAF 		:=	dDataBase
							ZC5->ZC5_DTPROD		:=	dDataBase		
						ZC5->(MsUnLock())					
					EndIf
				Else
					MsgStop("A Matriz já foi aprovada pela Produção e não poderá ser alterada a data da mesma",;
							"TPPAC004->PPAC004H("+AllTrim(Str(nOpc))+")->sfAprRep Aprovação")
				EndIf
			
			Case ZC5->ZC5_QUALI==cMat // Aprovação pela Qualidade
				If Empty(DtoS(ZC5->ZC5_DTQUAL)) //Se a data de aprovação pela Qualidade estiver preenchida, não poderá ser reaprovada
					If Empty(DtoS(ZC5->ZC5_DTPROD)) //Se a data de aprovação não estiver preenchida, a matriz não poderá ser aprovada por completo. Só poderá ser aprovada por completo se o dois resposáveis  à aprovarem
						RecLock("ZC5",.F.)
							ZC5->ZC5_DTQUAL 	:=	dDataBase		
						ZC5->(MsUnLock())
					Else
						RecLock("ZC5",.F.)
							ZC5->ZC5_APROV		:=	"S"//Flag de aprovação
							ZC5->ZC5_DATAF 		:=	dDataBase
							ZC5->ZC5_DTQUAL		:=	dDataBase		
						ZC5->(MsUnLock())					
					EndIf
				Else
					MsgStop("A Matriz já foi aprovada pela Qualidade e não poderá ser alterada a data da mesma",;
							"TPPAC004->PPAC004H("+AllTrim(Str(nOpc))+")->sfAprRep Aprovação")
				EndIf
		EndCase	         
		
	Case nOpc==8//Reprovaçào
		dbSelectArea("ZC5")
		ZC5->(DBGoTo(nRecNo))
		Do Case
			Case ZC5->ZC5_QUALI==cMat
				RecLock("ZC5",.F.)	
					ZC5->ZC5_DATAF 		:=	dDataBase
					ZC5->ZC5_DTQUAL		:=	dDataBase		
					ZC5->ZC5_APROV		:="N" 
				ZC5->(MsUnLock()) 
					         		 	
			Case ZC5->ZC5_PRODU==cMat
				RecLock("ZC5",.F.)	
					ZC5->ZC5_DATAF 		:=	dDataBase
					ZC5->ZC5_DTPROD		:=	dDataBase		
					ZC5->ZC5_APROV		:="N" 
				ZC5->(MsUnLock())
				
		EndCase
		
		While Empty(cMensagem)	 
			Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
			cMensagem:=sfJustif ( )	//chamada da tela de justificativa
		EndDo				
		//Grava na tabela de justificativas
		dbSelectArea("ZC5")
		ZC5->(DBGoTo(nRecNo))		
		RecLock("ZCC",.T.)	
			ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
			ZCC->ZCC_CODDOC	:=	ZC5->ZC5_CODMAT
			ZCC->ZCC_REV	:=	ZC5->ZC5_REV2
			ZCC->ZCC_TABELA	:=	"ZC5"                   
			ZCC->ZCC_TEXTO	:=	cMensagem						
			ZCC->ZCC_DATA	:=	dDataBase			
			ZCC->ZCC_USUAR	:=	ZC5->ZC5_EMIT
		ZCC->(MsUnLock())
				
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC5->ZC5_EMIT,"QAA_EMAIL")
		//Chamada da funcão do e-mail
//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprovação Matriz de Correlação",ZC5->ZC5_CODMAT,ZC5->ZC5_REV2,cMat,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprovação Matriz de Correlação"+ZC5->ZC5_CODMAT ,cEMail,cEMailRem,)
		EndIf							         		 	
		
		
EndCase	

RestArea(aAreaZC5)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
//===============================Gerar Versão     =================================================  
User Function PPAC004G (nOpc)
Local 	lRet		:=	.F. 
Local 	cTexto		:=	""
Local 	cTitulo		:=	""
Local 	cRevisao	:=	""
Local 	cChave		:=	""
Local 	nRecNo		:=	ZC5->(RecNo())	
Local 	nRecNoAtu	:=	0
Local 	aAreaZC5	:=	ZC5->(GetArea())
Local 	aAreaZCF	:=	ZCF->(GetArea())
Local 	bCampo  	:= 	{ |nCPO| Field(nCPO) }  
Private	aStruZC5	:=	ZC5->(DbStruct())
Private	cNomArqH9 	:=	""
cNomArqH9 			:=	CriaTrab(aStruZC5,.T.)
Private	aStruZCF	:=	ZCF->(DbStruct())
Private	cNomArqHD 	:=	""
cNomArqHD 			:=	CriaTrab(aStruZCF,.T.)  

If (Select("TRBZC5") <> 0)
	dbSelectArea("TRBZC5")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArqH9,"TRBZC5",.F.,.F.) 
If (Select("TRBZCF") <> 0)
	dbSelectArea("TRBZCF")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArqHD,"TRBZCF",.F.,.F.) 
dbClearIndex()     

If !Empty (DtoS(ZC5->ZC5_DATAF)) .AND. ZC5->ZC5_STAREV //Só pederá gerar revisão se tiver Data Final e o Status da revisão for .T.
	dbSelectArea("ZC5")
	ZC5->(DBGoTo(nRecNo))
	cChave:=ZC5->ZC5_FILIAL+ZC5->ZC5_CODMAT+ZC5->ZC5_REV2
	dbSelectArea("TRBZC5")
	RecLock("TRBZC5",.T.)
		For nCont:=1 to Len(aStruZC5)
			TRBZC5->&(aStruZC5[nCont][1]) := ZC5->&(aStruZC5[nCont][1])
		Next nCont
		cRevisao			:= 	sfRevisao (ZC5->ZC5_CODMAT)//Nova Revisão
		TRBZC5->ZC5_REV2	:=	cRevisao
		TRBZC5->ZC5_DATAF	:=  StoD(" / / ")
		TRBZC5->ZC5_STAREV	:=	.T.
		TRBZC5->ZC5_APROV	:=	""		
		TRBZC5->ZC5_DTREV	:=	dDataBase		
		TRBZC5->ZC5_DTPROD	:=	StoD(" / / ")		
		TRBZC5->ZC5_DTQUAL	:=	StoD(" / / ")  
		TRBZC5->ZC5_MOTIVO	:= ""			
	TRBZC5->(MsUnLock()) 
	
	dbSelectArea("ZC5")
	ZC5->(DBGoTo(nRecNo)) 
	dbSelectArea("TRBZCF")
	dbSelectArea("ZCF")	
	ZCF->(DBSetOrder(3))//ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2
	If ZCF->(DBSeek(cChave))
		Do While ZCF->(!EoF()) .AND. (cChave == (xFilial("ZCF")+ZCF->ZCF_CODMAT+ZCF->ZCF_REV2))
			RecLock("TRBZCF",.T.)
				For nCont:=1 to Len(aStruZCF)
					TRBZCF->&(aStruZCF[nCont][1]) := ZCF->&(aStruZCF[nCont][1])
				Next nCont
				TRBZCF->ZCF_REV2:=cRevisao							
			TRBZCF->(MsUnLock())
			ZCF->(DBSkip())
		EndDo
	EndIf	
	BEGIN TRANSACTION
		dbSelectArea("TRBZC5")	
		TRBZC5->(DBGotop())
		dbSelectArea("ZC5")
		ZC5->(dbSetOrder(2))//ZC5_FILIAL+ZC5_CODMAT+ZC5_REV2
		If !ZC5->(DBSeek(xFilial("ZC5")+TRBZC5->ZC5_CODMAT+TRBZC5->ZC5_REV2))
			lRet:=RecLock("ZC5",.T.)
				If lRet
					For nCont := 1 TO FCount()
						FieldPut(nCont,TRBZC5->&(EVAL(bCampo,nCont)))
//						ZC5->&(aStruZC5[nCont][1]) := TRBZC5->&(aStruZC5[nCont][1])
					Next nCont
				 	ZC5->ZC5_FILIAL := TRBZC5->ZC5_FILIAL					
				Else
					cTexto:=" Erro RecLock(ZC5)" 		
				EndIf	
			ZC5->(MsUnLock())
			nRecNoAtu:=ZC5->(RecNo())			
			If lRet			
				dbSelectArea("ZC5") //Atualiza o registro como vesão não atual
				ZC5->(DBGoTo(nRecNo)) 
				lRet:=RecLock("ZC5",.F.)
					If lRet 
						ZC5->ZC5_STAREV	:=	.F.
					Else
						cTexto:=" Erro RecLock(ZC5)	ZC5->ZC5_STAREV	:=	.F. "						
					EndIf	
				ZC5->(MsUnLock())											
			EndIf
			
			If lRet
				DbSelectArea("TRBZCF")				
				TRBZCF->(DBGoTop())
				DBSelectArea("ZCF")
				ZCF->(DBSetOrder(1))
				Do While TRBZCF->(!EoF()) .AND. lRet
					If !ZCF->(DBSeek(xFilial("ZCF")+TRBZCF->(ZCF_CODMAT+ZCF_REV2+ZCF_CODOP+ZCF_CODCAR)))
						lRet:=RecLock("ZCF",.T.)
							If lRet
								For nCont := 1  TO FCount()
//									ZCF->&(aStruZCF[nCont][1]) := TRBZCF->&(aStruZCF[nCont][1])								 	
									FieldPut(nCont,TRBZCF->&(EVAL(bCampo,nCont)))
								Next nCont
								ZCF->ZCF_FILIAL := TRBZCF->ZCF_FILIAL					
							Else
								cTexto:=" Erro RecLock(ZCF)"								
							EndIf	
						ZCF->(MsUnLock()) 					
					Else
						cTexto:="Registro Duplicado DBSeek(ZCF)RECNO "+Str(ZCF->(Recno()))
						lRet:=.F.
					EndIf
					TRBZCF->(DBSkip())
				EndDo
			EndIf 				
							       
		Else
			cTexto:="Registro Duplicado DBSeek(ZC5)RECNO "+Str(ZC5->(Recno()))
			lRet:=.F.
		EndIf 
		If !lRet
			DisarmTransaction()
			RollBackSX8()
			cTitulo:="TPPAC004->PPAC004G("+AllTrim(Str(nOpc))+") Revisão"
			cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro. "+cTexto
		Else
			cTitulo:="TPPAC004->PPAC004C("+AllTrim(Str(nOpc))+") Revisão"
			cTexto:="Revisão gerada com sucesso"			
		EndIf 
	END TRANSACTION 
	
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else
		MsgAlert(cTexto,cTitulo)		
	EndIf
Else
	MsgAlert("Só poderá ser gerada a revisão caso a matriz tenha uma data final. ","TPPAC004->PPAC004C("+AllTrim(Str(nOpc))+") Revisão")		
EndIf	

If(Select("TRBZC5")<>0)
	dbSelectArea("TRBZC5")
	dbCloseArea()
EndIf
If(Select("TRBZCF")<>0)
	dbSelectArea("TRBZCF")
	dbCloseArea()
EndIf
FeRase(cNomArqHD+GetdbExtension()) 
FeRase(cNomArqH9+GetdbExtension()) 
RestArea(aAreaZCF)
RestArea(aAreaZC5)
If lRet
	DBSelectArea("ZC5")
	ZC5->(DBGoto(nRecNoAtu))  
	U_PPAC004B (7)
	/*
	If U_PPAC004B (7) == 0		//CHAMA A ROTINA DE ALTERAÇÃO PARA REVISÕES
		RecLock("ZC5",.F.)
			DbDelete()
		ZC5->(MsUnLock())
	EndIf  
	*/
EndIf

Return ()
//==========================Fim da Geração de Versão     ==========================================  
//================================REVISÃO =========================================================
Static Function sfRevisao (cCODMAT)
Local cRet		:=	""
Local aAreaZC5	:=	ZC5->(GetArea())
DBSelectArea("ZC5")
ZC5->(DBGoTop())
DBSetOrder(2)//ZC5_FILIAL+ZC5_CODMAT+ZC5_REV2
If ZC5->(DBSeek(xFilial("ZC5")+cCODMAT))
	Do While ZC5->(!EoF()) .AND. (ZC5->(ZC5_FILIAL+ZC5_CODMAT)) == ;
			  (xFilial("ZC5")+(cCODMAT))
		cRet:=ZC5->ZC5_REV2
		ZC5->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC5)
Return (cRet)
//================================FIM DA REVISÃO ==================================================
//================Chama a Validação de Inclução========
User Function PPAC004A (nOpc)  
Local 	lRet		:=	.F. 
Private	aStru		:=	ZCF->(DbStruct())
Private	cNomArq 	:=	""   
INCLUI:=.T.
Aadd(aStru, {"RECNO_","N",10,0})
Aadd(aStru, {"DELET_","C",1,0})
cNomArq 	:=	CriaTrab(aStru,.T.)

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) //Cria o arquivo
dbClearIndex() 

dbSelectArea("ZC5")
ZC5->(dbSetOrder(1))  
RegToMemory( "ZC5", .T., .F. )  

lRet:=sfModelo2 (nOpc)

If lRet
	aAreaZC5	:=	(ZC5->(GetArea())) 
	DBSelectArea("ZC5")	
	ZC5->(DBSetOrder(1))
   	If !ZC5->(DBSeek(xFilial("ZC5")+M->ZC5_CODCLI+M->ZC5_LOJA+M->ZC5_REV2+M->ZC5_CODPRO))//Verifica sa há registros duplicados na tabela de Matrizes (ZC5)
		sfSalvar(nOpc)	
	Else
		Aviso("Atencao!","A operação não poderá ser finalizada, pois já existe um registro relacionado. Matriz "+ZC5->ZC5_CODMAT ,{"OK"},2)			
	EndIf//Fim da Verificação de registros duplicados na tabela ZC5
	ZC5->(RestArea(aAreaZC5))
EndIf

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension())

Return () 
//================Chama a Validação da Alteraçao======================================================================
User Function PPAC004B(nOpc)  
Local 	lRet		:=	.F. 	
Private	aStru		:=	ZCF->(DbStruct())
Private	cNomArq 	:=	"" 
INCLUI:=.F.
Aadd(aStru, {"RECNO_","N",10,0})
Aadd(aStru, {"DELET_","C",1,0})
cNomArq 	:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) //Cria o arquivo
dbClearIndex()
  
dbSelectArea("ZC5")
ZC5->(dbSetOrder(1))
RegToMemory( "ZC5", .T., .F. ) 

If	Empty(DtoS(ZC5->ZC5_DATAF)) .AND. ZC5->ZC5_STAREV //Só poderá ser alterado se a data fim estiver vazia e se for uma revisão atual
	lRet:=sfModelo2 (nOpc)  
	If lRet
		sfSalvar(nOpc)
	EndIf
Else
	Aviso("Atencao!","A Matriz não pode ser alterada. Já existe uma data fim para este registro ou se trata de uma revisão desatualizada.",{"OK"},2)	
EndIf

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 


Return ()
//================Chama a Função para visualização========
User Function PPAC004E (nOpc) 
Local 	lRet		:=	.F. 
Private	aStru		:=	ZCF->(DbStruct())
Private	cNomArq 	:=	""
Aadd(aStru, {"RECNO_","N",10,0})
Aadd(aStru, {"DELET_","C",1,0})
cNomArq 	:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) //Cria o arquivo
dbClearIndex()
  
lRet:=sfModelo2 (nOpc) 

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension())

Return () 
//================Chama a Função para deletar o registro=================================================================
User Function PPAC004F (nOpc) 
	Aviso("Atencao!","Não é permitido excluir o registro",{"OK"},2)		
Return()
/*
User Function PPAC004F (nOpc)  
Local 	lRet		:=	.F. 
Private	aStru		:=	ZCF->(DbStruct())
Private	cNomArq 	:=	"" 
Aadd(aStru, {"RECNO_","N",10,0})
Aadd(aStru, {"DELET_","C",1,0})
cNomArq 	:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) //Cria o arquivo
dbClearIndex() 
  
dbSelectArea("ZC5")
ZC5->(dbSetOrder(1))  
RegToMemory( "ZC5", .T., .F. )   

If Empty(DtoS(ZC5->ZC5_DATAF)) .OR. (ZC5->ZC5_REV2 == "00")//Critério para Deletar o registro
	lRet:=sfModelo2 (nOpc) 
	If lRet
		sfSalvar(nOpc)
	EndIf
Else
	Aviso("Atencao!","Só poderá ser excluído se o registro ainda tiver data final ou se a revisão for '00' ",{"OK"},2)	
EndIf

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 


Return ()
*/
 
//======================SALVAR REGISTROS====================================================================================
Static Function sfSalvar(nOpc) 
Local lRet		:=	.F.
Local aAreaZC5	:=	(ZC5->(GetArea()))  
Local aAreaZCF	:=	(ZCF->(GetArea()))
Local bCampo   	:= 	{ |nCPO| Field(nCPO) }                                                                                       
Local nCont	    :=	1
Local cTexto	:=	""
Local lFlag		:=	.T. 
BEGIN TRANSACTION                                                                                             
Do Case
	Case nOpc==3  //Incluir
		dbSelectArea("ZC5")
		ZC5->(dbSetOrder(2))//ZC5_FILIAL+ZC5_CODCLI+ZC5_LOJA+ZC5_REV2+ZC5_CODPRO 
		If !ZC5->(dbSeek(xFilial("ZC5")+M->ZC5_CODMAT+M->ZC5_REV2))
			lRet:=RecLock("ZC5",.T.)
			If lRet
				For nCont := 1 TO FCount()
					FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC5->ZC5_FILIAL := xFilial("ZC5")					
			Else
				cTexto:="Erro na operação de gravação (RecLock->ZC5)"			
			EndIf
			ZC5->(MsUnLock())
		Else
			cTexto:="Registro duplicado (dbSeek->ZC5) RECNO "+Str(ZC5->(RecNo()))
			lRet:=.F.	
		EndIf		
		If lRet 
			dbSelectArea("TRB")	
			TRB->(DBgoTop())
			dbSelectArea("ZCF")
			ZCF->(dbSetOrder(1))//ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2+ZCF_CODOP+ZCF_CODCAR
			Do While TRB->(!EoF()) .AND. lRet
				If !ZCF->(dbSeek(TRB->(ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2+ZCF_CODOP+ZCF_CODCAR))) .AND. Empty(TRB->DELET_)
					lRet:=RecLock("ZCF",.T.)
					If lRet
						ZCF->ZCF_FILIAL := 	TRB->ZCF_FILIAL					
						ZCF->ZCF_CODMAT	:=	TRB->ZCF_CODMAT					
						ZCF->ZCF_CODOP	:=	TRB->ZCF_CODOP					
						ZCF->ZCF_CODCAR	:=	TRB->ZCF_CODCAR	
						ZCF->ZCF_REV 	:= 	TRB->ZCF_REV 										
						ZCF->ZCF_REV2 	:= 	TRB->ZCF_REV2 																
						ZCF->ZCF_CODCLI	:= 	TRB->ZCF_CODCLI 
						ZCF->ZCF_LOJA 	:= 	TRB->ZCF_LOJA 
						ZCF->ZCF_CODPRO	:= 	TRB->ZCF_CODPRO 																		
					Else
						cTexto:="Erro na operação de gravação (RecLock->ZCF)"		
					EndIf
					ZCF->(MsUnLock())
				Else
					lRet:=.F.
					cTexto:="Registro duplicado (dbSeek->ZCF) RECNO "+Str(ZCF->(RecNo()))
				EndIf	
				TRB->(DBSkip())
			EndDo
		EndIf
		If !lRet
			DisarmTransaction()
			RollBackSX8() 
		Else
			ConfirmSX8()	
		EndIf
		
	Case nOpc==4 .OR. nOpc==7 //Alterar ou alteração da nova revisão
		dbSelectArea("ZC5")
		ZC5->(dbSetOrder(2))//ZC5_FILIAL+ZC5_CODMAT+ZC5_REV2  
		If ZC5->(dbSeek(xFilial("ZC5")+M->ZC5_CODMAT+M->ZC5_REV2))
			lRet:=RecLock("ZC5",.F.)
			If lRet
				For nCont := 1 TO FCount()
					FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC5->ZC5_FILIAL := xFilial("ZC5")					
			EndIf
			ZC5->(MsUnLock())
		EndIf		
		If lRet 
			dbSelectArea("TRB")	
			TRB->(DBgoTop())
			dbSelectArea("ZCF")			
			Do While TRB->(!EoF()) .AND. lRet
				ZCF->(DBGoto(TRB->RECNO_))
				lFlag:=IIF(ZCF->(RecNo())==TRB->RECNO_,.F.,.T.)//Se encontrar o RecNo, só atualiza
				If Empty(TRB->DELET_)
					lRet:=RecLock("ZCF",lFlag)
					If lRet
						ZCF->ZCF_FILIAL := 	TRB->ZCF_FILIAL					
						ZCF->ZCF_CODMAT	:=	TRB->ZCF_CODMAT					
						ZCF->ZCF_CODOP	:=	TRB->ZCF_CODOP					
						ZCF->ZCF_CODCAR	:=	TRB->ZCF_CODCAR	
						ZCF->ZCF_REV 	:= 	TRB->ZCF_REV 										
						ZCF->ZCF_REV2 	:= 	TRB->ZCF_REV2									
					EndIf
					ZCF->(MsUnLock())
				ElseIf !Empty(TRB->DELET_) .AND.(ZCF->(RecNo())==TRB->RECNO_)
					lRet:=RecLock("ZCF",.F.)
					If lRet
						DBDELETE()
					EndIf
					ZCF->(MsUnLock())						
				EndIf
				TRB->(DBSkip())
			EndDo
		EndIf
		If !lRet
			DisarmTransaction()
			RollBackSX8() 
			cTexto:="Erro na Gravação"
		EndIf 	
		 		
	Case nOpc==5  //Deletar
		dbSelectArea("ZC5")
		ZC5->(dbSetOrder(2))//ZC5_FILIAL+ZC5_CODMAT+ZC5_REV2
		If ZC5->(dbSeek(xFilial("ZC5")+M->ZC5_CODMAT+M->ZC5_REV2))
			lRet:=RecLock("ZC5",.F.)
			If lRet
				DBDELETE() 									
			EndIf
			ZC5->(MsUnLock())
		EndIf		
		If lRet 
			dbSelectArea("TRB")	
			TRB->(DBgoTop())
			dbSelectArea("ZCF")
			ZCF->(dbSetOrder(3))//ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2
			If ZCF->(dbSeek(TRB->(ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2)))
				Do While ZCF->(!EoF()) .AND. (TRB->(ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2) == ZCF->(ZCF_FILIAL+ZCF_CODMAT+ZCF_REV2))
					RecLock("ZCF",.F.)
						DBDELETE() 
					ZCF->(MsUnLock())
					ZCF->(DBSkip())
				EndDo
			EndIf
		EndIf
		If !lRet
			DisarmTransaction()
			RollBackSX8()
			cTexto:="Erro na Gravação"
		EndIf 
				
EndCase			
			 		
END TRANSACTION 
If ! lRet
	MsgStop(cTexto,"Erro Geral")
EndIf	
ZC5->(RestArea(aAreaZC5))
ZCF->(RestArea(aAreaZCF))
Return()
//======================FIM DA FUNÇÃO PARA SALVAR OS REGISTROS====
//==============Validação para Inclusão/Alteração================
Static Function sfModelo2 (nOpc) 
Local cInicial	:=	""//Valor inicial dos campos
Local nLin		:=	15 //Linha do Cabeçalho
Local aAreaZC5	:=	(ZC5->(GetArea()))  
Local aAreaZCF	:=	(ZCF->(GetArea()))
Local nCont		:=	1 
Local cVisual	:="R"//Determina se o campo será visual ou não
Local cUser		:=	""
cUser:=U_TPPAX001( )//Usuário logado Return(QAA_MAT)
//+-----------------------------------------------+
//¦ Opcao de acesso para o Modelo 2               ¦
//+-----------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza    
/*
Private aRotina := { {"Pesquisar","AxPesqui"		,0,1} ,;
					 {"Visualizar","U_PPAC004E (2)"	,0,2} ,;
      				 {"Incluir","U_PPAC004A (3)"	,0,3} ,;
      			     {"Alterar","U_PPAC004B (4)"	,0,4} ,; 				 					      			           			     
             		 {"Excluir","U_PPAC004F (5)"	,0,5} ,;
             		 {"Imprimir","U_TPPAR002"		,0,6},; 
             		 {"Gerar Revisao","U_PPAC004G (7)",0,7},;
             		 {"Aprovar","U_PPAC004H (8)",0,8}}    
*/

//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
aC:={}
aR:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"

// aC[n,2] = Array com coordenadas do Get [x,y], em
//           Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.


DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZC5")
While !Eof() .and. SX3->X3_ARQUIVO == "ZC5"
	If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL 
   		cCampo	:=	AllTrim(SX3->X3_CAMPO)     
   		If AllTrim(SX3->X3_OBRIGAT)=="€"
	   		aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})
   		EndIf
   		If nOpc==7 .AND. cCampo == "ZC5_MOTIVO"//Se for a chamada da alteração para a nova revisão, o campo ZC5_MOTIVO se torna obrigatório
	   		aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})
   		EndIf 
		cVisual	:=	SX3->X3_VISUAL   		  		
		
   		Do Case
   			Case nOpc==4 .OR. nOpc==2 .OR. nOpc==5 .OR. nOpc==7 //Visualizar=2; Alterar=4; Excluir=5; Alteração da revisão=7 			
   				If cCampo="ZC5_NOMCLI"  
   					&cCampo	:=	Posicione("SA1",1,xFilial("SA1")+M->ZC5_CODCLI+M->ZC5_LOJA,"A1_NOME")				   					
   				ElseIf cCampo="ZC5_DESPRO"
   					&cCampo	:=	Posicione("SB1",1,xFilial("SB1")+M->ZC5_CODPRO,"B1_DESC")   					
   				ElseIf cCampo="ZC5_PRODU"
	   				&cCampo	:=	ZC5->&(cCampo)
   					cVisual	:=	"V" 					
   				ElseIf cCampo="ZC5_QUALI"
	   				&cCampo	:=	ZC5->&(cCampo)
   					cVisual	:=	"V"  					   					   					
   				Else 
	   				&cCampo	:=	ZC5->&(cCampo)			
   				EndIf
   				   				
   			Case nOpc==3//Incluir    			  		
		   		Do Case
		   			Case AllTrim(SX3->X3_TIPO)	== "C" .OR. AllTrim(SX3->X3_TIPO) == "M"  		
		   				If "ZC5_CODMAT" == cCampo   				
						   //	&cCampo := GETSXENUM("ZC5","ZC5_CODMAT")  //ConfirmSX8()
							&cCampo := GETSX8NUM("ZC5","ZC5_CODMAT")							
		   				ElseIf "ZC5_NOMCLI" == cCampo   				
							&cCampo :=	Space(SX3->X3_TAMANHO) 
		   				ElseIf "ZC5_DESPRO" == cCampo   				
							&cCampo :=	Space(SX3->X3_TAMANHO)
		   				ElseIf "ZC5_REV2" == cCampo 
							&cCampo :=	Space(SX3->X3_TAMANHO)		   				  				
							&cCampo :=	"00"
		   				ElseIf "ZC5_EMIT" == cCampo   				
						   	//&cCampo :=	Space(SX3->X3_TAMANHO)		   				
				  			&cCampo :=	IIF(Empty(AllTrim(cUser)),Space(SX3->X3_TAMANHO),cUser)
			            Else
			   				cInicial:=AllTrim(SX3->X3_RELACAO) 			            
			                &cCampo :=IIF(Empty(SX3->X3_RELACAO),Space(SX3->X3_TAMANHO),&cInicial)					            	    
		                EndIf
									   			
		   			Case AllTrim(SX3->X3_TIPO)	== "N" 
		   				cInicial:=AllTrim(SX3->X3_RELACAO)   						
						&cCampo	:=IIF(Empty(SX3->X3_RELACAO),0,&cInicial) 
										    							
		   			Case AllTrim(SX3->X3_TIPO)	== "D"
			   			If "ZC5_DTREV" == cCampo .OR. "ZC5_DATA" == cCampo
							&cCampo	:= dDataBase			   				
			   			Else   
			   				cInicial:=AllTrim(SX3->X3_RELACAO)   			
							&cCampo	:=IIF(Empty(SX3->X3_RELACAO),StoD(" / / "),&cInicial)
						EndIf
									
		   			Case AllTrim(SX3->X3_TIPO)	== "L"
		   				cInicial:=AllTrim(SX3->X3_RELACAO)   			
						&cCampo	:=IIF(Empty(SX3->X3_RELACAO),.F.,&cInicial)
						  				    				  			 			  				
		   		EndCase		   		
		EndCase 
//		            1        2                   3                4                 5                         6                                   7
 		AADD(aC,{cCampo ,{nLin,10} ,AllTrim(SX3->X3_TITULO),SX3->X3_PICTURE,&('SX3->X3_VLDUSER'),IIF(Empty(SX3->X3_F3),NIL,SX3->X3_F3),IIF(cVisual=="V",.F.,.T.)}) 
   		nLin+=14		
	EndIf   
	DbSkip()
EndDo
//+-----------------------------------------------+
//¦ Montando aHeader                              ¦
//+-----------------------------------------------+  
dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("ZCF")
nUsado:=0
aHeader:={}
While SX3->(!Eof()) .And. (x3_arquivo == "ZCF")
    IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
    	cValid:="'"+SX3->X3_VLDUSER+"'"
        nUsado++
        AADD(aHeader,{ TRIM(x3_titulo),;
        	x3_campo,;
           	x3_picture,;
           	x3_tamanho,;
           	x3_decimal,;
           	&cValid,;
           	x3_usado,;
           	x3_tipo,;
           	x3_arquivo,;
           	x3_context } )
    Endif
    SX3->(dbSkip())
EndDo
nUsado++//RecNo

        AADD(aHeader,{ "RecNo",;
        	"RECNO_",;
           	"",;
           	10,;
           	0,;
           	".F.",;
           	"ÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇ",;
           	"N",;
           	"",;
           	"V" } ) 
          	
          	
//+-----------------------------------------------+
//¦ Montando aCols                                ¦
//+-----------------------------------------------+
nCont:=0
Do Case
	Case  nOpc==4 .OR. nOpc==2 .OR. nOpc==5 .OR. nOpc==7 //Visualizar=2; Alterar=4; Excluir=5; Alteração para nova revisão
		DBSelectArea("ZCF")	
		ZCF->(DBSetOrder(3))
		ZCF->(DBSeek(xFilial("ZCF")+ZC5->ZC5_CODMAT+ZC5->ZC5_REV2))
		Do While ZCF->(!EoF()) .AND. ((ZCF->ZCF_FILIAL+ZCF->ZCF_CODMAT+ZCF->ZCF_REV2) == (xFilial("ZCF")+ZC5->ZC5_CODMAT+ZC5->ZC5_REV2))	
			nCont++   //Verifica o tamanho do aCols
			ZCF->(DBSkip())
		EndDo	 
		aCols:=Array(nCont,nUsado+1)
		nUsado:=0
		nCont:=1
		DBSelectArea("ZCF")	
		ZCF->(DBSetOrder(3))
		ZCF->(DBSeek(xFilial("ZCF")+ZC5->ZC5_CODMAT+ZC5->ZC5_REV2))
		Do While ZCF->(!EoF()) .AND. ((ZCF->ZCF_FILIAL+ZCF->ZCF_CODMAT+ZCF->ZCF_REV2) == (xFilial("ZCF")+ZC5->ZC5_CODMAT+ZC5->ZC5_REV2))
			dbSelectArea("Sx3")
			SX3->(dbSeek("ZCF"))
			While SX3->(!Eof()) .And. (x3_arquivo == "ZCF")
				IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
					nUsado++ 			
	    	        aCOLS[nCont][nUsado] :=ZCF->&(SX3->X3_CAMPO)		    
			   	Endif
				SX3->(dbSkip())
			EndDo
			nUsado++			
			aCOLS[nCont][nUsado] := ZCF->(RecNo())	
			aCOLS[nCont][nUsado+1] := .F.			
			nCont++ 
			nUsado:=0
			ZCF->(DBSkip())
		EndDo
	
	Case nOpc==3   //Incluir
		aCols:=Array(1,nUsado+1)
		nUsado:=0
		dbSelectArea("Sx3")
		dbSeek("ZCF")
		While SX3->(!Eof()) .And. (x3_arquivo == "ZCF")
			IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
				nUsado++
				Do case
					Case x3_tipo == "C" .or. x3_tipo == "M" 
		   				cInicial:=AllTrim(SX3->X3_RELACAO)			
		    	        aCOLS[1][nUsado] :=IIF(Empty(SX3->X3_RELACAO),Space(SX3->X3_TAMANHO),&cInicial) 
		    	        	
		       		Case x3_tipo == "N"
		   				cInicial:=AllTrim(SX3->X3_RELACAO)	             
		    	  		aCOLS[1][nUsado] :=IIF(Empty(SX3->X3_RELACAO),0,&cInicial) 
		    	         	
		        	Case x3_tipo == "D"                  
		   				cInicial:=AllTrim(SX3->X3_RELACAO)	             
		                aCOLS[1][nUsado] := IIF(Empty(SX3->X3_RELACAO),StoD(" / / "),&cInicial) 
		                
		            case x3_tipo == "L"                  
		   				cInicial:=AllTrim(SX3->X3_RELACAO)	             
		    	        aCOLS[1][nUsado] :=IIF(Empty(SX3->X3_RELACAO),.F.,&cInicial) 
		       EndCase
		   Endif
		   SX3->(dbSkip())
		EndDo 
		nUsado++			
		aCOLS[1][nUsado] 	:= 0	
		aCOLS[1][nUsado+1] 	:= .F.					
			
EndCase
//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
cTitulo:="MATRIZ DE CORRELAÇÃO"
//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
aCGD:={250,5,118,315}

//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+
cLinhaOk :="ExecBlock('PPAC004C',.f.,.f.)"
cTudoOk  := "ExecBlock('PPAC004D',.f.,.f.)"
//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou
nOpc:=IIF(nOpc==7,4,nOpc)
lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpc,cLinhaOk,cTudoOk)
// No Windows existe a funcao de apoio CallMOd2Obj() que
// retorna o objeto Getdados Corrente 
ZC5->(RestArea(aAreaZC5))
ZCF->(RestArea(aAreaZCF))
Return (lRet)
//==================================Validação da Linha=============================
User Function PPAC004C ( )
Local lRet		:=	.T.
Local nCont		:=	0
Local nCont2	:=	0
Local nPosOP	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCF_CODOP"})
Local nPosCAR	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCF_CODCAR"})
Local nChave	:=	"" 
Local cTexto	:=	""
For nCont:=1 to Len(aCols)
	If !(aCols[nCont][Len(aHeader)+1])
		nChave	:=	aCols[nCont][nPosOP]+aCols[nCont][nPosCAR] //Verifica se há registro duplicado
		nCont2	:=	1	
		For nCont2:=nCont2+nCont to Len(aCols) 
			If !(aCols[nCont2][Len(aHeader)+1])		
				If nChave == aCols[nCont2][nPosOP]+aCols[nCont2][nPosCAR] //Verifica linha a linha se há duplicidade
					nCont	:=	Len(aCols)	
					nCont2	:=	Len(aCols)
					lRet	:=	.F.			
				Else
					lRet	:=	.T.		
				EndIf
			EndIf
		Next nCont2
	EndIf	
Next nCont
cTexto:="Há registros duplicados"
If !lRet
	Aviso("Atencao!",cTexto,{"OK"},2)
EndIf
Return(lRet)
//============================fim da validação da Linha=============================  
//==================================Validação de Tudo=============================
User Function PPAC004D ( ) 
Local lRet		:=	.T.
Local nCont		:=	0
Local nCont2	:=	0
Local nPosOP	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCF_CODOP"})
Local nPosCAR	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCF_CODCAR"}) 
Local nPosMAT	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCF_CODMAT"})
Local nPosREC	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "RECNO_"})
Local nChave	:=	"" 
Local cTexto	:=	""

For nCont:=1 to Len(aCols) 
	If !(aCols[nCont][Len(aHeader)+1])
		nChave	:=	aCols[nCont][nPosOP]+aCols[nCont][nPosCAR] //Verifica se há registro duplicado
		nCont2	:=	1	
		For nCont2:=nCont2+nCont to Len(aCols) 
			If !(aCols[nCont2][Len(aHeader)+1])		
				If nChave == aCols[nCont2][nPosOP]+aCols[nCont2][nPosCAR] //Verifica linha a linha se há duplicidade
					nCont	:=	Len(aCols)	
					nCont2	:=	Len(aCols)
					lRet	:=	.F.			
				Else
					lRet	:=	.T.		
				EndIf
			EndIf
		Next nCont2
	EndIf		
Next nCont
If !lRet
	cTexto:="Há registros duplicados"+CHR(13)+CHR(10)
EndIf
If M->ZC5_PRODU==M->ZC5_QUALI
	lRet:=.F.
	cTexto:="Os Aprovadores da Matriz não podem ser a mesma pessoa, verifique os campos ZC5_PRODU e ZC5_QUALI."+CHR(13)+CHR(10)	
EndIf
//Campos obrigatório do cabeçalho  
For nCont:=1 to Len(aCampo)
	Do case
		Case aCampo[nCont][2] == "C" .or. aCampo[nCont][2] == "M" 
			If  Empty(M->&(aCampo[nCont][1]))
				lRet	:=	.F.				
				cTexto+="Campo Obrigatório "+aCampo[nCont][3]+CHR(13)+CHR(10)
			EndIf
	    	        	
		Case aCampo[nCont][2] == "N"
			If  (M->&(aCampo[nCont][1]))==0
				lRet	:=	.F.				
				cTexto+="Campo Obrigatório "+aCampo[nCont][3]+CHR(13)+CHR(10)
			EndIf
	    	         	
		Case aCampo[nCont][2] == "D"                  
			If  Empty(DtoS((M->&(aCampo[nCont][1]))))
				lRet	:=	.F.				
				cTexto+="Campo Obrigatório "+aCampo[nCont][3]+CHR(13)+CHR(10)
			EndIf
	                
	    Case aCampo[nCont][2] == "L"                  
			If  Empty(M->&(aCampo[nCont][1])) 
				lRet	:=	.F.				
				cTexto+="Campo Obrigatório "+aCampo[nCont][3]+CHR(13)+CHR(10)
			EndIf
	EndCase	
Next nCont
If !lRet
	Aviso("Atencao!",cTexto,{"OK"},2)
Else 
	lRet:=.F.
	For nCont:=1 to Len(aCols)  //Verifica se há pelo menos um registro no ZCF
		If !(aCols[nCont][Len(aHeader)+1]) .AND. !Empty(aCols[nCont][nPosOP]) .AND. !Empty(aCols[nCont][nPosCAR])
			lRet:=.T. 
			nCont:=Len(aCols)	
		Else
			lRet:=.F.
		EndIf		
	Next nCont 
	If !lRet
		Aviso("Atencao!","Informe as operações e características",{"OK"},2)
	Else
		dbSelectArea("TRB")
		For nCont:=1 to Len(aCols)
	   //		If !(aCols[nCont][Len(aHeader)+1])	
				RecLock("TRB",.T.)
					TRB->ZCF_FILIAL := xFilial("ZCF")		
					TRB->ZCF_CODMAT := M->ZC5_CODMAT
					TRB->ZCF_CODCAR := aCols[nCont][nPosCAR]
					TRB->ZCF_CODOP 	:= aCols[nCont][nPosOP]					
					TRB->ZCF_CODCAR := aCols[nCont][nPosCAR]
					TRB->ZCF_REV 	:= M->ZC5_REV					
					TRB->ZCF_REV2 	:= M->ZC5_REV2					
					TRB->ZCF_CODCLI	:= M->ZC5_CODCLI					
					TRB->ZCF_LOJA 	:= M->ZC5_LOJA
					TRB->ZCF_CODPRO	:= M->ZC5_CODPRO															
 					TRB->RECNO_		:=aCols[nCont][nPosREC]//A penúltima posição será o RecNo					
 					TRB->DELET_		:=IIF(!(aCols[nCont][Len(aHeader)+1])," ","*")//A penúltima posição será o RecNo					 					
				TRB->(MsUnLock())
	   //		EndIf
		Next nCont						
	EndIf
EndIf
Return(lRet)
//============================fim da validação Tudo ============================= 
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
