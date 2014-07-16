/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EMAIL บAutor Joใo Felipe da Rosa      บ Data ณ  22/04/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CLASSE EMAIL                                               บฑฑ
ฑฑบ          ณ CLASSE UTILIZADA PARA ENVIO DE EMAILS NO AP11              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB USINAGEM / FUNDIวรO 						              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "ap5mail.ch"
#include "msobjects.ch" 
#include "TOPCONN.CH"

Class Email

//	export:	
		var cMsg      as Character
		var cTo       as Character
		var cAssunto  as Character
		var cFrom     as Character 
		var cMsgFim   as Character
		
		Method New() Constructor
		Method Envia()
		Method BuscaEmail(grupo)
	
//	hidden:
		var cServer   as Character
		var cAccount  as Character
		var cPassword as Character
		
EndClass

Method New() Class Email

	::cServer   := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
	::cAccount  := Alltrim(GETMV("MV_RELACNT")) //'protheus'
	::cPassword := Alltrim(GETMV("MV_RELPSW"))  //'siga'
	::cMsg      := ""
	::cMsgFim   := ""
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
	
	//-- usado para incluir conte๚do ap๓s o fim da mensagem
	If !Empty(::cMsgFim)
		::cMsg += ::cMsgFim
	Endif
	
	
	If !Empty(::cTo)
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
	Endif

Return           

// Retorna os e-mails que tem em determinado grupo

Method BuscaEmail(grupo,lArray) Class Email
Local _cMail := ''		
Default lArray := .f. //-- l๓gico retorno se array ou string concatenada com ponto e vํrgula

 	cQuery := " SELECT ZG2_EMAIL" 	 
	cQuery += " FROM "+RetSqlName("ZG1")+" ZG1, " +RetSqlName("ZG2")+" ZG2" 
	cQuery += " WHERE ZG1_COD = '"+grupo+"' " 
	cQuery += " AND ZG2_CODROT = ZG1_COD "		
	cQuery += " AND ZG1.ZG1_FILIAL = '"+xFilial("ZG1")+"' "			
	cQuery += " AND ZG2.ZG2_FILIAL = '"+xFilial("ZG2")+"' "
	cQuery += " AND ZG1.D_E_L_E_T_ = ' '"		
	cQuery += " AND ZG2.D_E_L_E_T_ = ' '"			
	cQuery += " ORDER BY ZG2_ITEM ASC"  

	TcQuery cQuery NEW ALIAS "EMAILS" 
		
	EMAILS->(dbGoTop())  

		While !EMAILS->(Eof())
		
  			_cMail += (AllTrim(EMAILS->ZG2_EMAIL) + ';')
  			
  			EMAILS->(DbSkip())		
  			
  		EndDo 
  		
  	EMAILS->(DbCloseArea())			


Return (iif(lArray,StrTokArr(_cMail,';'),_cMail))