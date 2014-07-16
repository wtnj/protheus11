/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNTA2807  บAutor  ณJoใo Felipe da Rosa บ Data ณ  22/07/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PONTO DE ENTRADA NA CONFIRMAวรO DA ROTINA MNTA280          บฑฑ
ฑฑบ          ณ (SOLICITAวรO DE SERVIวO)                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENวรO DE ATIVOS                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MNTA2807()
Local cMsg

	cMsg := '<html>'
	cMsg += '<body style="font-family:arial">'
	cMsg += '<p></p>'
	cMsg += '<table width="100%" border="1">'

	cMsg += '<tr>'
	cMsg += '<td colspan="4" style="background:#ccc">NOVA SOLICITAวรO DE SERVIวO - '+TQB->TQB_SOLICI+'</td>'
	cMsg += '</tr>
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Solicita็ใo</td>'
	cMsg += '<td>'+TQB->TQB_SOLICI+'</td>'
	cMsg += '<td style="background:#abc">Bem/Localiz</td>'
	cMsg += '<td>'+TQB->TQB_CODBEM+'</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Usuแrio</td>'
	cMsg += '<td>'+TQB->TQB_USUARI+'</td>'
	cMsg += '<td style="background:#abc">Ramal</td>'
	cMsg += '<td>'+TQB->TQB_RAMAL+'</td>'
	cMsg += '</tr>'

	SYP->(dbSetOrder(1)) //YP_FILIAL+YP_CHAVE+YP_SEQ
	SYP->(dbSeek(xFilial("SYP")+TQB->TQB_CODMSS))
	
	cMsg += '<tr>'
	cMsg += '<td style="background:#abc">Servi็o</td>'
	cMsg += '<td colspan="3">'+SYP->YP_TEXTO+'</td>'
	cMsg += '</tr>
	
	cMsg += '</table><br />'
	cMsg += '</body>'
	cMsg += '</html>'
		
	cTo := "altevirms@whbusinagem.com.br" //POR GARANTIA DE QUE NAO VAI DAR ERRO

	If SM0->M0_CODIGO=="FN" //EMPRESA FUNDICAO
	
		ST9->(dbSetOrder(1)) //FILIAL + CODBEM
		If ST9->(dbSeek(xFilial("ST9")+TQB->TQB_CODBEM))
			If AllTrim(ST9->T9_CENTRAB)=='FAB-05' //VIRABREQUIM
				cTo := "lista-manutencao-virabrequim@whbbrasil.com.br"
			ElseIf AllTrim(ST9->T9_CENTRAB)=='FAB-02' //FUNDICAO
				cTo := "fabioca@whbfundicao.com.br;"
				cTo += "edson@whbfundicao.com.br;"
				cTo += "jaimebg@whbfundicao.com.br;"
				cTo += "francisvb@whbfundicao.com.br;"
				cTo += "guilhermecm@whbfundicao.com.br;"
				cTo += "jonathags@whbfundicao.com.br;"
				cTo += "nivaldoal@whbfundicao.com.br;"
				cTo += "ricardoa@whbfundicao.com.br;"
				cTo += "ricardocs@whbfundicao.com.br;"
				cTo += "luizmb@whbfundicao.com.br;"
				cTo += "ruicr@whbfundicao.com.br;"
				cTo += "rubensd@whbfundicao.com.br"
			EndIf
		EndIF
		
	ElseIf SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM
		cTo := "altevirms@whbusinagem.com.br;"
		cTo += "josiasas@whbusinagem.com.br;"
	EndIf
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** NOVA SOLICITAวรO DE SERVIวO - "+TQB->TQB_SOLICI+" ***"
	oMail:cTo      := cTo
	
	oMail:Envia()

Return .t.