/*                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE145  ºAutor  ³Marcos R Roquitski  º Data ³  16/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email pagamento de terceiros 13o. Salario. 2a. Parcelaº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe145()

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

If MsgBox("Confirma email de pagamentos a terceiros 13o. Salario 2a. Parcela","Enviar e-mail","YESNO")
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
	cMsg += '<title>RECIBO DE PAGAMENTO - 13o. SALARIO 2a. PARCELA</title>' + CRLF
	cMsg += '</head>' + CRLF

    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<b><font size="3" face="Arial">Pagamentos 13o. Salario - 2a. Parcela</font></b>' + CRLF
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


	ZRF->(DbSeek(xFilial("ZRF")+ZRA->ZRA_MAT))
	While !ZRF->(Eof()) .AND. ZRF->ZRF_MAT == ZRA->ZRA_MAT


		_cMes := Mesextenso(ZRF->ZRF_DATA) + "/"+StrZero(Year(ZRF->ZRF_DATA),4)

		cMsg += '<tr>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + ZRF->ZRF_PD + '</font></td>'

	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + ZRF->ZRF_DESCPD + '</font></td>'

		ZRV->(DbSeek(xFilial("ZRV") + ZRF->ZRF_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. ZRF->ZRF_PD <> "799"
		    
			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRF->ZRF_VALOR,"@E 999,999,999.99") + '</font></td>'

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' +"."+ '</font></td>'

				_nTotpro += ZRF->ZRF_VALOR
			Elseif ZRV->ZRV_TIPOCO == "2" .AND. ZRF->ZRF_PD <> "799"

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'

			    cMsg += '<td width="15%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRF->ZRF_VALOR,"@E 999,999,999.99") + '</font></td>'

				_nTotdes += ZRF->ZRF_VALOR
			Elseif ZRV->ZRV_TIPOCO == "1" .AND. ZRF->ZRF_PD == "799"

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'

			    cMsg += '<td width="15%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRF->ZRF_VALOR,"@E 999,999,999.99") + '</font></td>'
			Endif
		Endif				
		lRet := .T.		
		ZRF->(DbSkip())
	Enddo

	If lRet .and. !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + _cNome + ", seu pagamento esta condicionado a entrega da Nota Fiscal ao Depto Pessoal."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + "Favor emitir a nota fiscal do décimo terceiro salário com data do dia 14/12/09."+ '</font></b>' + CRLF
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
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail) ;
			SUBJECT 'Pagamento: 13o. Salario - 2a. Parcela';
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