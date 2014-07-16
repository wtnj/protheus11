/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAVALMMAILºAutor  ³ João Felipe da Rosa º Data ³  10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

Descrição: 
Esse ponto de entrada está localizado na Function MEnviaMail e tem como 
objetivo o envio de emails de eventos pré-cadastrados do M-Messenger.
É chamado no início da função, antes da query que obtém os usuários 
destinatários dos e-mails conforme o evento disparado. Também é usado 
para continuar ou não o processo de envio do e-mail, conforme avaliação 
do usuário.

±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MAVALMMAIL()

lEnvia        := .T.
cEvento       := paramixb[1] // Código do evento a ser disparado
aDados        := paramixb[2] // Array com os dados relativos ao evento
cParUsuario   := paramixb[3] // String com usuários a serem considerados
cParGrUsuario := paramixb[4] // String com grupos de usuários a serem considerados
cParEmails    := paramixb[5] // String com e-mails a serem considerados
lEvRH         := paramixb[6] // .T. => se o formato mensagem for HTML / .F. => se o formato não for HTML

//-- OS Nº: 032064
If cEvento=="033" // inclusao de produtos
	If ALLTRIM(aDados[7])$"ANAPP" .AND. !ALLTRIM(aDados[4])$"PA"
		lEnvia := .F.
	Endif
Endif
//-- Fim OS Nº: 032064

Return lEnvia