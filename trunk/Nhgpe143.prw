/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE143  �Autor  �Marcos R Roquitski  � Data �  03/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia email pagamento de terceiros 13o. Salario. 1a. Parcela���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���     ``
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe143()

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

If MsgBox("Confirma email de pagamentos a terceiros 13o. Salario 1a. Parcela","Enviar e-mail","YESNO")
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
	cMsg += '<title>RECIBO DE PAGAMENTO - 13o. SALARIO 1a. PARCELA</title>' + CRLF
	cMsg += '</head>' + CRLF

    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<b><font size="3" face="Arial">Pagamentos 13o. Salario - 1a. Parcela</font></b>' + CRLF
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


	ZRE->(DbSeek(xFilial("ZRE")+ZRA->ZRA_MAT))
	While !ZRE->(Eof()) .AND. ZRE->ZRE_MAT == ZRA->ZRA_MAT


		_cMes := Mesextenso(ZRE->ZRE_DATA) + "/"+StrZero(Year(ZRE->ZRE_DATA),4)

		cMsg += '<tr>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + ZRE->ZRE_PD + '</font></td>'

	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + ZRE->ZRE_DESCPD + '</font></td>'

		ZRV->(DbSeek(xFilial("ZRV") + ZRE->ZRE_PD))
		If ZRV->(Found())
			If ZRV->ZRV_TIPOCO == "1" .AND. ZRE->ZRE_PD <> "799"
		    
			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRE->ZRE_VALOR,"@E 999,999,999.99") + '</font></td>'

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' +"."+ '</font></td>'

				_nTotpro += ZRE->ZRE_VALOR
			Elseif ZRV->ZRV_TIPOCO == "2" .AND. ZRE->ZRE_PD <> "799"

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'

			    cMsg += '<td width="15%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRE->ZRE_VALOR,"@E 999,999,999.99") + '</font></td>'

				_nTotdes += ZRE->ZRE_VALOR
			Elseif ZRV->ZRV_TIPOCO == "1" .AND. ZRE->ZRE_PD == "799"

			    cMsg += '<td width="15%">'
    			cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'

			    cMsg += '<td width="15%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZRE->ZRE_VALOR,"@E 999,999,999.99") + '</font></td>'
			Endif
		Endif				
		lRet := .T.		
		ZRE->(DbSkip())
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
	    cMsg += '<b><font size="4" face="Courier">' + " Data de deposito: 30/11/2009"+ '</font></b>' + CRLF
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
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			SUBJECT 'Pagamento: 13o. Salario - 1a. Parcela';
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