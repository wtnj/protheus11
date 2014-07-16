/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM380ZEMP  บAutor  ณJoใo Felipe da Rosa บ Data ณ  25/09/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ

ฑฑบDesc.     ณ Este ponto de entrada tem como objetivo permitir ao usuแrio 
determinar se o processo de zerar o empenho serแ, ou nใo executado quando 
for confirmada a altera็ใo. ษ possํvel  utilizแ-lo para determinar, por 
exemplo, se o usuแrio tem, ou nใo permissใo para zerar o empenho.
LOCALIZAวรO: Ponto de entrada localizado na fun็ใo "A380ZEmp" da rotina 
de ajuste de empenhos. ษ nesta fun็ใo que o usuแrio confirma se o empenho 
serแ, ou nใo zerado.EM QUE PONTO: Serแ executado quando o usuแrio clicar 
no botใo "Zera Empenho Lote/Endere็o" durante a rotina de altera็ใo do empenho. 
UTILIZAวรO: Quando o usuแrio clicar no botใo "Zera Empenho Lote/Endere็o" 
o sistema emite um aviso solicitando ao usuแrio a confirma็ใo para zerar 
o empenho. Se o PE retornar um valor l๓gico falso (.F.) o sistema nใo 
emitirแ o aviso e o processo de zerar empenhos nใo serแ realizado.
PARยMETROS DE ENVIO: Nenhum parโmetro ้ enviado ao ponto de entrada.
PARยMETROS DE RETORNO: Deverแ ser retornado um valor l๓gico 
verdadeiro (.T.) ou falso (.F.) indicando ao sistema se o processo de 
zerar empenhos serแ ou nใo realizado..                                

บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M380ZEMP()

If !alltrim(upper(cusername))$"ANAP/ROGERIO/FERNANDOW/JOAOFR/ALEXANDRERB/ADMIN"
	Alert("Nใo ้ possํvel zerar empenhos! Favor entrar em contato com Controladoria!")
	Return .F.
endif

return .T.