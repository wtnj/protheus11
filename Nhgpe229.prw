/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE229  ºAutor  ³Marcos R Roquitski  º Data ³  05/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email pagamento extras de terceiros Individual        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±     
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

User Function Nhgpe229()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
ZR1->(DbSetOrder(1))
ZRA->(DbSetOrder(1))
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
        
DbSelectArea("ZRA")
ZRA->(DbSetOrder(1))
ZRA->(Dbgotop())

While !ZRA->(Eof())

	If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
	    ZRA->(Dbskip())
	    Loop
	Endif

	lRet   := .F.
	_cMail := ""
	_cMail := ZRA->ZRA_EMAIL
	_cNome := "Sr(a) "+Alltrim(ZRA->ZRA_NOME)

	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title>RECIBO DE PAGAMENTO</title>' + CRLF
	cMsg += '</head>' + CRLF

    cMsg += '<b><font size="4" face="Courier">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'

	cMsg += '<b><font size="3" face="Arial">Pagamentos</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'


	cMsg += '<font size="2" face="Arial">Relacao de Proventos</font>' + CRLF
	cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
	cMsg += '<tr>'

	cMsg += '<td width="06%">'
	cMsg += '<font size="2" face="Arial">Verba</font></td>'

	cMsg += '<td width="06%">'
	cMsg += '<font size="2" face="Arial">Descricao</font></td>'
        
	/*
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Provento</font></td>'
    */
    
	cMsg += '<td width="08%">'
	cMsg += '<font size="2" face="Arial">Valor</font></td>' 
	cMsg += '</tr>' + CRLF
	e_email = .T.                                   


	ZR1->(DbSeek(xFilial("ZR1")+ZRA->ZRA_MAT+DTOS(dDataBase)))
	While !ZR1->(Eof()) .AND. ZR1->ZR1_MAT+DTOS(dDataBase) == ZRA->ZRA_MAT + Dtos(dDataBase)

		_cVerba  := '000'
		_cDescri := 'DIFERENCA ABONO'

		_cMes := Mesextenso(ZR1->ZR1_DATA) + "/"+StrZero(Year(ZR1->ZR1_DATA),4)

		cMsg += '<tr>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + _cVerba + '</font></td>'

	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' +  _cDescri + '</font></td>'

		/*
	    cMsg += '<td width="15%">'
		cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + "." + '</font></td>'
        */
        
	    cMsg += '<td width="08%">'
	   	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRANSFORM(ZR1->ZR1_VALOR,"@E 999,999,999.99") + '</font></td>'

		lRet := .T.		

		ZR1->(DbSkip())

	Enddo

	If lRet .and. !Empty(_cMail)

		cMsg += '</tr>'
		cMsg += '</table>'

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + _cNome + ", seu pagamento esta condicionado a entrega da Nota Fiscal ao Depto Pessoal."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF


		/*
		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + " *** ATENCAO a data da Emissao da Nota Fiscal devera ser sempre o PRIMEIRO dia util do MES."+ '</font></b>' + CRLF
		cMsg += '</tr>' + CRLF
        */
        

		cMsg += '</tr>' + CRLF
		cMsg += '</tr>' + CRLF
	    cMsg += '<b><font size="4" face="Courier">' + " *** Nota Fiscal devera ser encaminhada ao Sr. CARLOS EDUARDO DE CARVALHO  - RH Usinagem *** "+ '</font></b>' + CRLF
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
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); 
			SUBJECT 'Pagamento Complementar';
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

Msgbox("Processo concluido .... !","Enviar email","ALERT") 


Return(.T.)