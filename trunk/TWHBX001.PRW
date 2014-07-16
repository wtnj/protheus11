#Include "RwMake.ch"
#Include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTWHBX001  บ Autor ณ Gustavo Schepp     บ Data ณ  06/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para enviar e-mail.                                 บฑฑ
ฑฑบ          ณ Fun็ใo utilizada no Sistema                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB MP10 R 1.2 MSSQL                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function  TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
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
		conout("Mensagem do U_TWHBX001: "+ cMensagem)
	Else
		conout("E-mail enviado para "+Alltrim(cDestinat))
	Endif

	DISCONNECT SMTP SERVER Result lDisConectou
	If lDisConectou
		conout("Desconectado com servidor de E-Mail - " + cServer)
	Endif

Return(lEnviado)
