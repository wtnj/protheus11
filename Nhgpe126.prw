/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE126  บAutor  ณMarcos R. Roquitski บ Data ณ  08/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail ao Financeiro dos arquivos.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe126()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome,_cTempo")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
_cMail    := Alltrim(GETMV("MV_MAILRH"))//'Lista de e-mail Rh/Financeiro 
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
lEnd := .F.   
e_email = .F.                         


fEnvEmaila()

Return(.t.)

Static Function fEnvEmaila()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)
Local _aFile := {}
Local _nEnvia := 0
Local _aFile3 := {}


For i := 1 To 3

	lRet   := .T.
	//_cMail := "marcosr@whbbrasil.com.br;emersonlm@whbbrasil.com.br;maurocs@whbbrasil.com.br"
                                       
	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title>.</title>' + CRLF
	cMsg += '</head>' + CRLF


	If i == 1
		cMsg += '<b><font size="3" face="Arial">Segue anexo o arquivo para enviar ao Banco: DEPOSITO  </font></b>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<tr>'

	Elseif i == 2
		cMsg += '<b><font size="3" face="Arial">Segue anexo o arquivo para enviar ao Banco: TED </font></b>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<tr>'

	Elseif i == 3
		cMsg += '<b><font size="3" face="Arial">Segue anexo o arquivo para enviar ao Banco: DOC </font></b>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<tr>'
	Endif    

	cMsg += '<b><font size="3" face="Arial"> Quaisquer d๚vida estamos ao seu dispor.</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'


	e_email = .T.                                   


	If lRet .and. !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'
		cMsg += '</tr>' + CRLF

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Arial">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="4" face="Arial">' + "Carlos Eduardo de Carvalho, Gestao de Pessoas - WHB"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="1" face="Arriel">' + "OBSERVACAO:"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="1" face="Arriel">' + "Nใo responda a esta mensagem, pois foi enviada de um endere็o de e-mail nใo monitorado as mensagens enviadas a este endere็o nใo podem ser respondidas."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF      

		If i == 1
			If SM0->M0_CODIGO == "FN"
		        aadd(_aFile, "\SYSTEM\FNBD"+Substr(Dtos(dDataBase),5,4)+".REM")
		    Else
		        aadd(_aFile, "\SYSTEM\NHBD"+Substr(Dtos(dDataBase),5,4)+".REM")		    
		    Endif    
	    Elseif i == 2    
			If SM0->M0_CODIGO == "FN"
		        aadd(_aFile, "\SYSTEM\FNBT"+Substr(Dtos(dDataBase),5,4)+".REM")
		    Else
		        aadd(_aFile, "\SYSTEM\NHBT"+Substr(Dtos(dDataBase),5,4)+".REM")		    
		    Endif    
	    Elseif i == 3    
			If SM0->M0_CODIGO == "FN"
		        aadd(_aFile, "\SYSTEM\FNBC"+Substr(Dtos(dDataBase),5,4)+".REM")
			Else
		        aadd(_aFile, "\SYSTEM\NHBC"+Substr(Dtos(dDataBase),5,4)+".REM")			
			Endif		        
	    Endif    

       
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To 'carlosec@whbbrasil.com.br';
			SUBJECT ' Arquivo de pagamentos Terceiros';
			BODY cMsg;
	        ATTACHMENT _aFile[1];
			RESULT lEnviado

		Endif
		lRet := .F.
		_aFile := {}
	Endif	

Next
// emersonlm@whbbrasil.com.br;maurocs@whbbrasil.com.br';
// Send Mail from 'protheus@whbbrasil.com.br' To "marcosr@whbbrasil.com.br;emersonlm@whbbrasil.com.br;maurocs@whbbrasil.com.br";
Msgbox("Processo concluido com sucesso !","Enviar email","ALERT")

Return(.T.)