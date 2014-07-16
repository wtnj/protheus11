/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
\±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE192  ºAutor  ³Marcos R Roquitski  º Data ³  22/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email pagamento de terceiros.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±     
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe192(nPar)

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome,_nPar")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
QAA->(DbSetOrder(6))
SC1->(DbSetOrder(1))
lEnd := .F.   
e_email = .F.                         
_nPar := nPar
fEnviaEmail()

Return(.t.)


Static Function fEnviaEmail()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)

	lRet   := .F.
	_cMail := "" 
	If _nPar == 1	
		_cMail := "andressamc@whbbrasil.com.br;claudiaas@whbbrasil.com.br"
	Else
		_cMail := "claytong@whbbrasil.com.br;robertose@whbbrasil.com.br;pauloro@whbbrasil.com.br;emersonm@whbbrasil.com.br"
	Endif	
	_cNome := "Matricula: "+SRA->RA_MAT + ' - '+ Alltrim(SRA->RA_NOME)
	e_email = .T.                                   

	If !Empty(_cMail)

		If _nPar == 1	
			cMsg += '</tr>'
			cMsg += '</table>'
			cMsg := '<html>' + CRLF
			cMsg += '<head>' + CRLF
			cMsg += '<title>ESTABILIDADE</title>' + CRLF
			cMsg += '</head>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">Favor verificar situação medica do funcionário,</font></b>' + CRLF
			cMsg += '</tr>' + CRLF
		    cMsg += '<tr>'
			cMsg += '</tr>' + CRLF
			cMsg += '</tr>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
			cMsg += '</tr>' + CRLF
			cMsg += '</tr>' + CRLF
			cMsg += '</tr>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">' + "Atenciosamente,"+ '</font></b>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">' + "Depto Pessoal"+ '</font></b>' + CRLF
			cMsg += '</tr>' + CRLF
			cMsg += '</body>' + CRLF
			cMsg += '</html>' + CRLF
		Else
			cMsg += '</tr>'
			cMsg += '</table>'
			cMsg := '<html>' + CRLF
			cMsg += '<head>' + CRLF
			cMsg += '<title>ESTABILIDADE</title>' + CRLF
			cMsg += '</head>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">Situação medica do funcionário atendida,</font></b>' + CRLF
			cMsg += '</tr>' + CRLF
		    cMsg += '<tr>'
			cMsg += '</tr>' + CRLF
			cMsg += '</tr>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
			cMsg += '</tr>' + CRLF
			cMsg += '</tr>' + CRLF
			cMsg += '</tr>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">' + "Atenciosamente,"+ '</font></b>' + CRLF
		    cMsg += '<b><font size="4" face="Courier">' + "Depto Sesmt"+ '</font></b>' + CRLF
			cMsg += '</tr>' + CRLF
			cMsg += '</body>' + CRLF
			cMsg += '</html>' + CRLF
		Endif
			
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			SUBJECT IIF(_nPar==1,'Estabilidade','Retorno Estabilidade');
			BODY cMsg;
			RESULT lEnviado
			If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
	    	Endif
		Else
			Alert("Erro ao se conectar no servidor: " + cServer)		
		Endif
		lRet := .F.
	Endif	
	ZRA->(DbSkip())


Return(.T.)