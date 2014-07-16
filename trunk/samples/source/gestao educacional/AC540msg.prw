
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAC540MSG  บAutor  ณJuliano Saggiomo    บ Data ณ  25/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email de notifica็ใo ao responsแvel quando acontece  บฑฑ
ฑฑบ          ณ uma ocorr๊ncia                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ ExpC1 - Nome do Responsแvel                                บฑฑ
ฑฑบ          ณ ExpC2 - Email do Responsแvel                               บฑฑ
ฑฑบ          ณ ExpC3 - Tipo Responsavel                                   บฑฑ
ฑฑบ          ณ ExpC4 - Nome do Aluno                                      บฑฑ
ฑฑบ          ณ ExpC5 - Tipo da Ocorrencia                                 บฑฑ
ฑฑบ          ณ ExpC6 - Motivo da Ocorr๊ncia                               บฑฑ
ฑฑบ          ณ ExpC7 - A็ใo da Ocorr๊ncia                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7 - GESTAO EDUCACIONAL                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function Ac540MSG()
Local lRetorno      := .f.
Local cMsg          := ""
Local cResp       	:= PARAMIXB[1]
Local cEmail 		:= PARAMIXB[2]
Local cTipo 		:= PARAMIXB[3]
Local cAluno 		:= PARAMIXB[4]
Local cAdvert		:= PARAMIXB[5]
Local cMemo			:= PARAMIXB[6]
Local cMemo1		:= PARAMIXB[7]

cAssunto := "Ocorrencia" //Alteracao no local do processo seltivo

cMsg := "Prezado(a)" + "&nbsp" + "responsแvel" + "&nbsp"
If cTipo == '1'
	cMsg += "Academico" + "&nbsp"
ElseIf cTipo == '2'
	cMsg += "Financeiro" + "&nbsp"
ElseIf cTipo == '3'
	cMsg += "Academico/Financeiro" + "&nbsp"
EndIf

cMsg += cResp + "," + "<br>" + "<br>"
cMsg += "informamos que o aluno" + "&nbsp" + "<b>" + cAluno + "</b>" + "&nbsp" + "recebeu uma" + "&nbsp"
cMsg += "<b>" + Tabela( "FA",  cAdvert, .F. ) + "</b>" + "." + "<br>" + "<br>"
// motivo
If MSMM(cMemo) <> ""
	cMsg += "<b>" + "Motivo:" + "</b>" + "<br>" + MSMM(cMemo) + "." + "<br>"
EndIf

// acao
If MSMM(cMemo1) <> ""
	cMsg += "<br>" + "<b>" + "Acao:" + "</b>" + "<br>" + MSMM(cMemo1) + "." + "<br>"
EndIf

cMsg += "<br>" + "Atenciosamente," + "<br>"
cMsg += "Secretaria"

lRetorno := ACSendMail( ,,,, cEmail + Chr(59), cAssunto, cMsg )

Return lRetorno