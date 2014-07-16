#include "RWMAKE.CH"
#include "BITMAP.CH"
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendMail  บAutor  ณAristiane & Fแbio   บ Data ณ  22/01/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExemplo de envio de e-mail.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Curso de ADVPL2                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SendMail
 	DesenhaJanela()
Return

Static Function DesenhaJanela()
Private cTo			:= Replicate (' ',50)
Private cSubject	:= Replicate (' ',20)
Private cTexto		:= ''  
Private cFile		:= '\sigaaadv\logo.bmp'

@ 200,1 to 460,310 DIALOG oDlg TITLE "Enviar e-mail"
// Y   X
@ 000,050 BITMAP SIZE 150,34 FILE cFile Pixel NOBORDER
@ 020,005 Say 'Para:'
@ 030,00
5 Get cTo F3 'SA1'
@ 040,005 Say 'Assunto'
@ 050,005 Get cSubject
@ 060,005 Say 'Texto'
@ 070,005 Get cTexto Size 100,60 MEMO
@ 110,115 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 110,080 BMPBUTTON TYPE 01 ACTION Envia(oDlg)
Activate Dialog oDlg Centered
Return

Static Function Envia()
Local cServer	:= "smtp.microsiga.com.br"
Local cAccount	:= 'leandro'
Local cPassword := ''
Local lConectou
Local lEnviado
Local cMensagem := '' 

Close (oDlg)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	Send Mail from 'aristiane@ibq.com.br';
	To cTo;
	SUBJECT cSubject;
	BODY cTexto;
	RESULT lEnviado
	                
	If !lEnviado
		Get mail error cMensagem
		Alert(cMensagem)
	EndIf
else
	Alert("Erro ao se conectar no servidor: " + cServer)		
Endif
	
Return
