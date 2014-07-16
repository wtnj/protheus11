/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE269  ºAutor  ³Marcos R Roquitski  º Data ³  29/08/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email aprovacao de pagamento                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±     
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe269(_cPar)

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome,_nVar")

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
	_nVar := _cPar

    If !Empty(RC1->RC1_NUMTIT)

		fEnviaEmail()	

	Endif		

Return(.t.)


Static Function fEnviaEmail()
Local lRet 		:= .F.
Local _nTotPro  := 0
Local _nTotDes  := 0
Local _nZero    := 0
Local _cMes     := Space(20)


	lRet   := .F.

	If _nVar==1 // Solicitacao de aprovacao

		_cMail := "" 
		_cNome := "Sra. Rafaele Neumann,"                

		cMsg   := '<html>' + CRLF 
		cMsg   += '<head>' + CRLF 
		cMsg   += '<title>Pagamento pendentes para aprovação</title>' + CRLF 
		cMsg   += '</head>' //+ CRLF 

	    cMsg   += '<b><font size="4" face="Calibri">' + _cNome + '</font></b>' + CRLF 
		cMsg   += '</tr>' + CRLF 
	    cMsg   += '<tr>' 
   
		cMsg   += '<font size="2" face="Calibri">Titulos aguardando aprovação.</font>' + CRLF 
		cMsg   += '</tr>' + CRLF 
	    cMsg   += '<tr>' 

		If SX6->(DbSeek(xFilial()+"MV_GPE269S")) 
			_cMail := Alltrim(SX6->X6_CONTEUD) 
		Else 
		    _cMail := 'rafaelen@whbbrasil.com.br' 
		Endif    

	Else // Aprovacao

		_cMail := ""
		_cNome := "A/C Depto Financeiro"

		cMsg := '<html>' + CRLF
		cMsg += '<head>' + CRLF
		cMsg += '<title>AUTORIZACAO DE PAGAMENTO</title>' + CRLF
		cMsg += '</head>' //+ CRLF

	    cMsg += '<b><font size="4" face="Calibri">' + _cNome + '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<tr>'

   
		cMsg += '<font size="2" face="Calibri">Autorizo pagamentos dos titulos relacionados abaixo.</font>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<tr>'

		If SX6->(DbSeek(xFilial()+"MV_GPE269F")) 
			_cMail := Alltrim(SX6->X6_CONTEUD) 
		Else 
		    _cMail := 'rafaelen@whbbrasil.com.br;contasapagar@itesapar.com.br;gustavocr@whbbrasil.com.br' 
		Endif 


	Endif


	cMsg += '<table border="1" width="50%">'
	
	cMsg += '<td width="5%">'
	cMsg += '<font size="3" face="Calibri"><b>Titulo</b></font></td>' // #9C9C9C

	cMsg += '<td width="10%">'
	cMsg += '<font size="3" face="Calibri"><b>Descrição</b></font></td>'

	cMsg += '<td width="5%" align="right">'
	cMsg += '<font size="3" face="Calibri"><b>Valor</b></font></td>'

	cMsg += '<td width="5%" align="right" >'
	cMsg += '<font size="3" face="Calibri"><b>Vencimento</b></font></td>' 


	If _nVar==2
	
		cMsg += '<td width="5% align="right">'
		cMsg += '<font size="3" face="Calibri"><b>Aprovador</b></font></td>'

		cMsg += '<td width="5%" align="right">'
		cMsg += '<font size="3" face="Calibri"><b>Data</b></font></td>'

		cMsg += '<td width="5%" align="right">'
		cMsg += '<font size="3" face="Calibri"><b>Hora</b></font></td>' 
	
	Endif

	 
	e_email = .T.                                   


	cMsg += '<tr>'
    cMsg += '<td width="5%">'
    cMsg += '<font size="2" face="Calibri">' + RC1->RC1_NUMTIT + '</font></td>'

    cMsg += '<td width="10%">'
   	cMsg += '<font size="2" face="Calibri">' + RC1->RC1_DESCRI + '</font></td>'

    cMsg += '<td width="5%" align="right">'
	cMsg += '<font size="2" face="Calibri">' + TRANSFORM(RC1->RC1_VALOR,"@E 999,999,999.99") + '</font></td>' // #E0FFFF

    cMsg += '<td width="5%" align="right">'
	cMsg += '<font size="2" face="Calibri">' +DTOC(RC1->RC1_VENREA)+ '</font></td>'

	If _nVar==2
	    cMsg += '<td width="5%" align="right">'
		cMsg += '<font size="2" face="Calibri">' +RC1->RC1_APROVA+ '</font></td>'

	    cMsg += '<td width="5%" align="right">'
		cMsg += '<font size="2" face="Calibri">' +DTOC(RC1->RC1_DTAPRO)+ '</font></td>'

	    cMsg += '<td width="5%" align="right">'
		cMsg += '<font size="2" face="Calibri">' +RC1->RC1_HAPROV+ '</font></td>'
	
	Endif
	cMsg += '</tr>'
	cMsg += '</table>'

	If _nVar==1
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Recursos Humanos - Itesapar"+ '</font></b>' + CRLF	    
		cMsg += '</tr>' + CRLF
	Else
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Rafaele Neumann"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Recursos Humanos"+ '</font></b>' + CRLF	    
		cMsg += '</tr>' + CRLF	
	Endif			

	cMsg += '</body>' + CRLF
	cMsg += '</html>' + CRLF

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

	If _nVar==1
		_cSub := 'Titulos Aguardando Aprovação';

	Else
		_cSub := 'Autorização de Pagamento';			

	Endif	


	If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' to Alltrim(_cMail); //'marcosr@whbbrasil.com.br'; //rafaelen@whbbrasil.com.br'; // Alltrim(_cMail)+';marciol@whbbrasil.com.br'; //'marcosr@whbbrasil.com.br';
		SUBJECT _cSub;
		BODY cMsg;
		RESULT lEnviado

		If !lEnviado
			Get mail error cMensagem
			Alert(cMensagem)
    	Endif

		If _nVar==1 // Solicitacao de aprovacao

			DbSelectArea("RC1")
			Reclock("RC1",.F.)
			RC1->RC1_EMAILS := "S"
			RC1->RC1_INTEGR := "0"		
			MsUnlock("RC1")

		Else
		
			DbSelectArea("RC1")
			Reclock("RC1",.F.)
			RC1->RC1_EMAILF := "S"
			MsUnlock("RC1")

		Endif	


	Else

		Alert("Erro ao se conectar no servidor: " + cServer)		

	Endif

	lRet := .F.


	Msgbox("Processo concluido com sucesso !","Enviar email","ALERT") 


Return(.T.) 

