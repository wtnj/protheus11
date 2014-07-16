/*                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE148  ºAutor  ³Marcos R Roquitski  º Data ³  16/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email pagamento de terceiros PPR.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe148()

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

If MsgBox("Confirma email de pagamentos a terceiros PPR.","Enviar e-mail","YESNO")
	fEnviaEmail()
Endif

Return(.t.)


Static Function fEnviaEmail()
Local lRet := .F.
Local _nTotPro := 0
Local _nTotDes := 0
Local _nZero := 0
Local _cMes := Space(20)

DbSelectArea("ZRA")
ZRA->(DbSetOrder(1))
ZRA->(Dbgotop())

While !ZRA->(Eof())

	If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
	    ZRA->(Dbskip())
	    Loop
	Endif

	If ZRA->ZRA_13CAL == 'N'
	    ZRA->(Dbskip())
	    Loop
	Endif


	lRet   := .F.
	_cMail := ""
	_cMail := ZRA->ZRA_EMAIL
	_cNome := "Sr(a) "+Alltrim(ZRA->ZRA_NOME)

	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title>RECIBO DE PAGAMENTO - PPR</title>' + CRLF
	cMsg += '</head>' + CRLF

    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<b><font size="3" face="Arial">Pagamento do PPR.</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'


	cMsg += '<font size="2" face="Arial">Relacao de Proventos/Descontos.</font>' + CRLF
	cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
	cMsg += '<tr>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Verba</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Descricao</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Provento</font></td>'

	cMsg += '<td width="15%">'
	cMsg += '<font size="2" face="Arial">Desconto</font></td>' 
	cMsg += '</tr>' + CRLF
	e_email = .T.                                   


	ZRP->(DbSeek(xFilial("ZRP")+ZRA->ZRA_MAT))
	While !ZRP->(Eof()) .AND. ZRP->ZRP_MAT == ZRA->ZRA_MAT


		_cMes := Mesextenso(ZRP->ZRP_DATA) + "/"+StrZero(Year(ZRP->ZRP_DATA),4)

		cMsg += '<tr>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + ZRP->ZRP_PD + '</font></td>'

	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + ZRP->ZRP_DESCPD + '</font></td>'

		ZRV->(DbSeek(xFilial("ZRV") + ZRP->ZRP_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. ZRP->ZRP_PD <> "799"
		    
			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRP->ZRP_VALOR,"@E 999,999,999.99") + '</font></td>'

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' +"."+ '</font></td>'

				_nTotpro += ZRP->ZRP_VALOR
			Elseif ZRV->ZRV_TIPOCO == "2" .AND. ZRP->ZRP_PD <> "799"

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'

			    cMsg += '<td width="15%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRP->ZRP_VALOR,"@E 999,999,999.99") + '</font></td>'

				_nTotdes += ZRP->ZRP_VALOR
			Elseif ZRV->ZRV_TIPOCO == "1" .AND. ZRP->ZRP_PD == "799"

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'

			    cMsg += '<td width="15%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRP->ZRP_VALOR,"@E 999,999,999.99") + '</font></td>'
			Endif
		Endif				
		lRet := .T.		
		ZRP->(DbSkip())
	Enddo

	If lRet .and. !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + " *** ATENCAO favor << NAO EMITIR NOTA FISCAL >>"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + " Data de deposito: 23/12/2009"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + "Atenciosamente,"+ '</font></b>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + "Depto Pessoal"+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF

		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To 'marcosr@whbbrasil.com.br'; // Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			SUBJECT 'Pagamento: PPR';
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
Enddo

Msgbox("Processo concluido com sucesso !","Enviar email","ALERT")

Return(.T.)