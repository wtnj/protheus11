/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EMAIL บAutor Joใo Felipe da Rosa      บ Data ณ  22/04/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CLASSE EMAIL                                               บฑฑ
ฑฑบ          ณ CLASSE UTILIZADA PARA ENVIO DE EMAILS NO AP10              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB USINAGEM / FUNDIวรO 						              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "ap5mail.ch"
#include "msobjects.ch"

Class Email

//	export:	
		var cMsg      as Character
		var cTo       as Character
		var cAssunto  as Character
		var cFrom     as Character 
		
		Method New() Constructor
		Method Envia()
	
//	hidden:
		var cServer   as Character
		var cAccount  as Character
		var cPassword as Character
		
EndClass

Method New() Class Email

	::cServer   := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
	::cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
	::cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
	::cMsg      := ""
	::cTo       := ""
	::cAssunto  := ""
	::cFrom     := "protheus@whbbrasil.com.br"
	
Return		
		
Method Envia() Class Email
Local cErro
Local cRodape
Local lConectou := .F.
Local lEnviado  := .F.

	cRodape := '<table style="font-family:arial; font-size:12px" width="100%">
	cRodape += '<tr><td>
	cRodape += 'Mensagem Processada automaticamente. Favor nao responder este email.<br />'	 
	cRodape += '</td></tr>'
	cRodape += '</table>
	
	::cMsg += cRodape
	
	CONNECT SMTP SERVER ::cServer ACCOUNT ::cAccount PASSWORD ::cPassword Result lConectou
	If lConectou
		Send Mail from ::cFrom To ::cTo;
		SUBJECT ::cAssunto;
		BODY ::cMsg;
		RESULT lEnviado
		If !lEnviado
			Get mail error cErro
    		Alert(cErro)
		EndIf
	Else
    	Alert("Erro ao se conectar no servidor: " + ::cServer)
	Endif  
	
	DISCONNECT SMTP SERVER

Return