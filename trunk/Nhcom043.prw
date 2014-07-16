/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM043  ºAutor  ³Marcos R Roquitski  º Data ³  28/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email das pendencias para os responsaveis que estao   º±±
±±º          ³com SC abertas.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"

User Function Nhcom043()

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

MsAguarde ( {|lEnd| fEnviaEmail() },"Aguarde", "Enviando e-mail", .T.)

Return(.t.)


Static Function fEnviaEmail()
Local lRet := .F.
DbSelectArea("SZU")
SZU->(DbSetOrder(1))
SZU->(Dbgotop())
While !SZU->(Eof())
	lRet := .F.
	_cMail := ""
	_cNome := "Ola, "

	QAA->(DbSeek(SZU->ZU_LOGIN))
	If QAA->(Found())
		_cMail := QAA->QAA_EMAIL
		_cNome := "Ola, "+QAA->QAA_NOME
	Endif
	MsProcTxt(" Enviando email: " +QAA->QAA_EMAIL)

	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> APROVACAO ELETRONICA DE SC</title>' + CRLF
	cMsg += '</head>' + CRLF
    cMsg += '<b><font size="2" face="Arial">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'
	cMsg += '<b><font size="3" face="Arial">Existe solicitacoes de compras aguardando a sua aprovacao. </font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'
	cMsg += '<font size="2" face="Arial">Relacao de Itens aguardando aprovacao. Favor entrar no sistema Protheus para liberar suas pendencias.</font>' + CRLF
	cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
	cMsg += '<tr>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">SC Nr.</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Item</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Emissao</font></td>'

	cMsg += '<td width="15%">'
	cMsg += '<font size="2" face="Arial">Produto</font></td>' 

	cMsg += '<td width="30%">'
	cMsg += '<font size="2" face="Arial">Descricao</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Atraso</font></td>'
	cMsg += '</tr>' + CRLF
	e_email = .T.


	_cLogin := Alltrim(SZU->ZU_LOGIN)
	While !SZU->(Eof()) .AND. Alltrim(SZU->ZU_LOGIN) == _cLogin   
		If Empty(SZU->ZU_STATUS)

			_cOk := 'S'
			_nRecno := SZU->(Recno())
			_cNumSc := SZU->ZU_NUM+SZU->ZU_ITEM
			_cNivel := SZU->ZU_NIVEL

			SZU->(DbSetOrder(2))
			SZU->(DbSeek(xFilial("SZU")+_cNumSc))
			While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == _cNumSc
				If (SZU->ZU_STATUS $ "B/C" .And. Alltrim(SZU->ZU_LOGIN) <> Alltrim(_cLogin) )
					_cOk := "N"
					Exit
				Else
					If (Empty(SZU->ZU_STATUS) .AND. SZU->ZU_NIVEL < _cNivel)
							_cOk := "N"
						Exit
					Endif
				Endif
				SZU->(DbSkip())
			Enddo
			SZU->(DbSetOrder(1))
			SZU->(DbGoto(_nRecno))

			SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
			If SC1->(Found()) .AND. _cOk == 'S'
				cMsg += '<tr>'
			    cMsg += '<td width="06%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_NUM + '</font></td>'

			    cMsg += '<td width="06%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_ITEM + '</font></td>'

			    cMsg += '<td width="06%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + DTOC(SC1->C1_EMISSAO) + '</font></td>'

			    cMsg += '<td width="18%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_PRODUTO + '</font></td>'
		    	cMsg += '<td width="30%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_DESCRI + '</font></td>'

		    	cMsg += '<td width="30%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Alltrim(STR(DATE()-SC1->C1_EMISSAO))+" Dias "+ '</font></td>'
				cMsg += '</tr>'
				lRet := .T.
			Endif
		Endif
		SZU->(DbSkip())
	Enddo

	If lRet .and. !Empty(_cMail)
		cMsg += '</table>'
		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			SUBJECT 'SOLICITACOES AGUARDANDO APROVACAO *** URGENTE *** ';
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
Enddo

Return(.T.)