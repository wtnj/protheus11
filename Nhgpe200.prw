/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE200  ºAutor  ³Marcos R Roquitski  º Data ³  05/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email pagamento de terceiros Individual               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±     
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe200()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")

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

If MsgBox("Confirma email de pagamentos a terceiros","Enviar e-mail","YESNO")
	fEnviaEmail()	
Endif

Return(.t.)


Static Function fEnviaEmail()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)


If Empty(Alltrim(ZRA->ZRA_SITFOLH))

	lRet   := .F.
	_cMail := ""
	_cMail := ZRA->ZRA_EMAIL
	_cNome := "Sr(a) "+Alltrim(ZRA->ZRA_NOME)

	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title>RECIBO DE PAGAMENTO</title>' + CRLF
	cMsg += '</head>' //+ CRLF

    cMsg += '<b><font size="4" face="Calibri">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

   
	cMsg += '<font size="2" face="Calibri">Relação de Proventos e Descontos.</font>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<table border="1" width="50%">'// bgcolor="#0080C0">'

	//cMsg += '<table width="70%" bgcolor="#BBFFFF">' // #BBFFFF
	//cMsg += '<tr>'

	cMsg += '<td width="5%">'
	cMsg += '<font size="3" face="Calibri"><b>Verbas</b></font></td>' // #9C9C9C

	cMsg += '<td width="10%">'
	cMsg += '<font size="3" face="Calibri"><b>Descrição</b></font></td>'

	cMsg += '<td width="5%" align="right">'
	cMsg += '<font size="3" face="Calibri"><b>Proventos</b></font></td>'

	cMsg += '<td width="5%" align="right" >'
	cMsg += '<font size="3" face="Calibri"><b>Descontos</b></font></td>' 
	 
	e_email = .T.                                   


	ZRC->(DbSeek(xFilial("ZRC")+ZRA->ZRA_MAT))
	While !ZRC->(Eof()) .AND. ZRC->ZRC_MAT == ZRA->ZRA_MAT


		_cMes := Mesextenso(ZRC->ZRC_DATA) + "/"+StrZero(Year(ZRC->ZRC_DATA),4)

		If ZRC->ZRC_PD == "799"

			cMsg += '<tr>'
		    cMsg += '<td width="5%">'
		    cMsg += '<font size="2" face="Calibri">' +""+ '</font></td>'
		    cMsg += '<td width="10%">'
	    	cMsg += '<font size="2" face="Calibri"><b>' + ZRC->ZRC_DESCPD + '</b></font></td>'

		Else

			cMsg += '<tr>'
		    cMsg += '<td width="5%">'
		    cMsg += '<font size="2" face="Calibri">' + ZRC->ZRC_PD + '</font></td>'
		    cMsg += '<td width="10%">'
	    	cMsg += '<font size="2" face="Calibri">' + ZRC->ZRC_DESCPD + '</font></td>'
		
		
		Endif	    	

		ZRV->(DbSeek(xFilial("ZRV") + ZRC->ZRC_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. ZRC->ZRC_PD <> "799"

			    cMsg += '<td width="5%" align="right">'
    			cMsg += '<font size="2" face="Calibri">' + TRANSFORM(ZRC->ZRC_VALOR,"@E 999,999,999.99") + '</font></td>' // #E0FFFF

			    cMsg += '<td width="5%">'
    			cMsg += '<font size="2" face="Calibri">' +" "+ '</font></td>'

				_nTotpro += ZRC->ZRC_VALOR

			Elseif ZRV->ZRV_TIPOCO == "2" .AND. ZRC->ZRC_PD <> "799"


			    cMsg += '<td width="5%">'
    			cMsg += '<font size="2" face="Calibri">' + " " + '</font></td>'

			    cMsg += '<td width="5%" align="right">'
		    	cMsg += '<font size="2" face="Calibri">' + TRANSFORM(ZRC->ZRC_VALOR,"@E 999,999,999.99") + '</font></td>'

				//<td align="right" valign="top">Célula 1</td>
                 
				_nTotdes += ZRC->ZRC_VALOR
			Elseif ZRV->ZRV_TIPOCO == "1" .AND. ZRC->ZRC_PD == "799"


			    cMsg += '<td width="5%">'
    			cMsg += '<font size="2" face="Calibri">' + " " + '</font></td>'

			    cMsg += '<td width="5%" align="right">'
		    	cMsg += '<font size="2" face="Calibri"><b>' + TRANSFORM(ZRC->ZRC_VALOR,"@E 999,999,999.99") + '</b></font></td>'

		    	
			Endif
		Endif				
		lRet := .T.		
		ZRC->(DbSkip())
	Enddo

	If lRet .and. !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'

		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + _cNome + ", seu pagamento esta condicionado a entrega da Nota Fiscal à área de Gestão de Pessoas."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

	    cMsg += '<b><font size="2" face="Calibri">' + "Atenção a data da Emissão da Nota Fiscal deverá ser sempre o primeiro dia útil do mës."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


	    cMsg += '<b><font size="2" face="Calibri">' + "Nota Fiscal deverá ser encaminhada ao Sr. CARLOS EDUARDO DE CARVALHO  - Renumeração WHB."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="2" face="Calibri">' + "Gestão de Pessoas"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To 'carlosec@whbbrasil.com.br'; // Alltrim(_cMail)+';marciol@whbbrasil.com.br'; //'marcosr@whbbrasil.com.br';
			SUBJECT 'Pagamento do Período: '+_cMes;
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

	Msgbox("Processo concluido com sucesso !","Enviar email","ALERT") 

Else

	Msgbox("Erro no envio do E-MAIL! Verifique situacao cadastral.","Enviar email","ALERT")

Endif
Return(.T.) 



Static Function fEnvia2()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)


If Empty(Alltrim(ZRA->ZRA_SITFOLH))

	lRet   := .F.
	_cMail := ""
	_cMail := ZRA->ZRA_EMAIL
	_cNome := "Sr(a) "+Alltrim(ZRA->ZRA_NOME)


			cMsg += '<html>' + CRLF
			cMsg += '<head>' + CRLF
			cMsg += '<title> E X E M P L O </title>' + CRLF
			cMsg += '</head>' + CRLF
			cMsg += '<b><font size="3" face="Calibri">Email enviado atraves do Sistema Protheus</font></b>' + CRLF
			cMsg += '<font size="2" face="Calibri">Problema na amarração PRODUTO x FORNECEDOR da Nota: '+ QEP->QEP_NTFISC+'-'+QEP->QEP_SERINF+'</font>' + CRLF
	    	cMsg += '<font size="2" face="Calibri">Favor arrumar o Problema e acessar o modulo inspeção de entrada e reimportar este produto</font>' + CRLF
			cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	

			cMsg += '<tr>'
			cMsg += '<td width="15%">'
			cMsg += '<font size="2" face="Calibri">Produto</font></td>'
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Calibri">Descricao</font></td>'
			cMsg += '<td width="10%">'
			cMsg += '<font size="2" face="Calibri">Forn/Loja</font></td>' 
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Calibri">Razao Social</font></td>'
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Calibri">Problema</font></td>'
			cMsg += '</tr>' + CRLF
		    cMsg += '<tr>'

		    cMsg += '<td width="15%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Calibri">' + QEP->QEP_PRODUT + '</font></td>'
		    cMsg += '<td width="30%">'
	    	cMsg += '<font size="2" Color="#FFFFFF" face="Calibri">' + SB1->B1_DESC + '</font></td>'
		    cMsg += '<td width="10%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Calibri">' + SRA->RA_NOME  + '</font></td>'
	    	cMsg += '<td width="30%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Calibri">' + SRA->RA_NOME + '</font></td>'
	    	cMsg += '<td width="30%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Calibri">' + SRA->RA_NOME + '</font></td>'
		    cMsg += '</tr>' + CRLF
			cMsg += '</table>'
			cMsg += '</body>' + CRLF
			cMsg += '</html>' + CRLF

		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To 'marcosr@whbbrasil.com.br'; //'carlosec@whbbrasil.com.br'; // Alltrim(_cMail)+';marciol@whbbrasil.com.br'; //'marcosr@whbbrasil.com.br';
			SUBJECT 'Pagamento do Período: '+_cMes;
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


	Msgbox("Processo concluido com sucesso !","Enviar email","ALERT") 
Endif
Return(.T.)
