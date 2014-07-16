#Include "RwMake.ch"
#Include "ap5mail.ch"

//Funcao para Gravar a Justificativa da Reprovacao de Documentos
User Function FtGrvJust(mv_Tabela,mv_Codigo,mv_Revisao,mv_Justif)
	dbSelectArea("ZCC")
	RecLock("ZCC",.T.)
		ZCC->ZCC_FILIAL	:= xFilial("ZCC")
		ZCC->ZCC_TABELA	:= mv_Tabela
		ZCC->ZCC_CODDOC	:= mv_Codigo
		ZCC->ZCC_REV	:= mv_Revisao
		ZCC->ZCC_TEXTO	:= mv_Justif
		ZCC->ZCC_USUAR	:= __cUserId
		ZCC->ZCC_DATA	:= Date()
	ZCC->(MsUnLock())  
Return

//Funcao que valida se o Usuario 
User Function FtVldUser(mv_CodUser)
	Local lRet		:= .F.
	Local aAreaQAA	:= QAA->(GetArea())
	Local aCargo	:= Separa(AllTrim(Getmv("WHB_CARGO")))	//Cagos autorizados a aprovar e geras revisões
	Local aDepart	:= Separa(AllTrim(Getmv("WHB_DPTO")))	//Departamentos autorizados a aprovar e geras revisões
	
	dbSelectArea("QAA")
	QAA->(dbSetOrder(1))//QAA_FILIAL, QAA_MAT  

	If QAA->(DBSeek( xFilial("AQQ")+mv_CodUser ))
		If aScan(aDepart,QAA->QAA_CC) > 0 .and. aScan(aCargo,QAA->QAA_CODFUN) > 0
			lRet := .T.
		Else
			Aviso("FtVldUser->Atencao!","O usuário não tem permissão para assinar o documento. Verifique os parâmentros WHB_CARGO e WHB_DPTO." ,{"OK"},2)
		EndIf	
	Else
		Aviso("FtVldUser->Atencao!","O usuário "+AllTrim(mv_CodUser)+" não encontrado no cadastro (QAA)" ,{"OK"},2)										
	EndIf 

	RestArea(aAreaQAA)

Return lRet

//Funcao para envio de e-mail
User Function FtMail(cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	Local cServer   := getmv('MV_RELSERV')
	Local cAccount  := getmv('MV_RELACNT')
	Local cPassword := getmv('MV_RELAPSW')
	Local cMailFrom := getmv('MV_RELFROM')
	Local cEnvia	:= If( Empty(cRemetente) , cMailFrom , cRemetente )
	
	cDestinat := Alltrim(cDestinat)
	
	//Inicia Conexao com o Servidor de e-mails
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

	If lConectou
		conout("Conectado com servidor de E-Mail - " + cServer)
	Else
		conout("Erro Envio e-mail: " + __cUserID +" "+ FunName() +" ("+cDestinat+")")
	Endif

	If Empty(cArquivos)
		Send Mail From cEnvia To cDestinat Subject cTitulo Body cMensagem Result lEnviado
	Else
		Send Mail From cEnvia To cDestinat Subject cTitulo Body cMensagem ATTACHMENT cArquivos Result lEnviado
	Endif
	cMensagem := ""

	Get Mail Error cMensagem

	If !Empty(cMensagem)
		conout("Mensagem do U_FtMail: "+ cMensagem)
	Else
		conout("E-mail enviado para "+Alltrim(cDestinat))
	Endif

	DISCONNECT SMTP SERVER Result lDisConectou
	If lDisConectou
		conout("Desconectado com servidor de E-Mail - " + cServer)
	Endif

Return(lEnviado)