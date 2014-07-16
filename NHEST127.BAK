/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST127  ºAutor  ³Felipe Rosa         º Data ³  28/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email das pendencias de produtos a ser retirado no    º±±
±±º          ³almoxarifado.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "topconn.ch"
#include "tbiconn.ch"

User Function Nhest127()

                                           
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome,lEnd,e_email")

PREPARE ENVIRONMENT EMPRESA "NH" FILIAL "01" MODULO "EST" TABLES "QAA","SB1","SCP"

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
//lConectou
//lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
QAA->(DbSetOrder(6))
lEnd := .F.   
e_email = .F.                         

fEnviaEmail() 

RESET ENVIRONMENT

Return(.t.)

Static Function fEnviaEmail()
Local lRet   := .F.
Local cQuery

/*
cQuery := " SELECT SCP.CP_NUM, SCP.CP_ITEM, SCP.CP_PRODUTO, SCP.CP_QUANT, SCP.CP_DATPRF, "
cQuery += " SCP.CP_SOLICIT, QAA.QAA_EMAIL, QAA.QAA_NOME, SCP.CP_QUJE"
cQuery += " FROM "+RetSqlName('SCP')+" SCP, "+RetSqlName('QAA')+" QAA"
cQuery += " WHERE SCP.CP_QUANT <> SCP.CP_QUJE"
cQuery += " AND SCP.CP_STATUS != 'E'" //Filtra as requisicoes já encerradas
cQuery += " AND SCP.D_E_L_E_T_ = ' '"
cQuery += " AND QAA.D_E_L_E_T_ = ' '"
cQuery += " AND SCP.CP_SOLICIT *= QAA_LOGIN"
cQuery += " ORDER BY SCP.CP_NUM"
*/

cQuery := " SELECT SCP.CP_NUM, SCP.CP_ITEM, SCP.CP_PRODUTO, SCP.CP_QUANT, SCP.CP_DATPRF, "
cQuery += " SCP.CP_SOLICIT, QAA.QAA_EMAIL, QAA.QAA_NOME, SCP.CP_QUJE"
cQuery += " FROM " + RetSqlName('SCP') + " SCP (NOLOCK) "

cQyery += " LEFT JOIN " + RetSqlName('QAA') + " QAA (NOLOCK) "
cQuery += " ON  QAA.QAA_FILIAL = '" + xFilial("QAA")+ "' "
cQyery += " AND QAA.QAA_LOGIN  = SCP.CP_SOLICIT "
cQyery += " AND QAA.D_E_L_E_T_ = '' "

cQuery += " WHERE SCP.FILIAL  = '" + xFilial("SCP") +"' "
cQuery += " AND SCP.CP_QUANT  <> SCP.CP_QUJE "
cQuery += " AND SCP.CP_STATUS != 'E' " //Filtra as requisicoes já encerradas
cQuery += " AND SCP.D_E_L_E_T_ = ' ' "

cQuery += " ORDER BY SCP.CP_NUM"

//MemoWrit('C:\TEMP\NHEST109.SQL',cQuery)
TCQUERY cQuery NEW ALIAS 'TRA1'

If	!USED()
	conout(cQuery+'. Query errada')
EndIf

TRA1->(DbGotop())

While !TRA1->(Eof())
	lRet := .F.
	If !Empty(TRA1->QAA_EMAIL)
		_cMail := TRA1->QAA_EMAIL + ';lista-almoxarifado@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'
	Else
		_cMail := 'joaofr@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'
	EndIf
	
	If !Empty(TRA1->QAA_NOME)
		_cNome := "Ola, "+TRA1->QAA_NOME
	Else
		_cNome := "Usuário não encontrado na tabela QAA. Usuário: " + TRA1->CP_SOLICIT
	EndIf
	
//	MsProcTxt(" Enviando email: " +QAA->QAA_EMAIL)

	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> AVISO DE RETIRADA DE MATERIAL</title>' + CRLF
	cMsg += '</head>' + CRLF
    cMsg += '<b><font size="2" face="Arial">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'
	cMsg += '<b><font size="3" face="Arial">Existem materiais a serem retirados no almoxarifado. </font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'
	cMsg += '<font size="2" face="Arial">Relacao de Itens aguardando sua Retirada no Almoxarifado.</font>' + CRLF
	cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
	cMsg += '<tr>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">SA No.</font></td>'

	cMsg += '<td width="7%">'
	cMsg += '<font size="2" face="Arial">Item</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Produto</font></td>'

	cMsg += '<td width="30%">'
	cMsg += '<font size="2" face="Arial">Descricao</font></td>' 

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Quantidade</font></td>'

	cMsg += '<td width="7%">'
	cMsg += '<font size="2" face="Arial">Atraso</font></td>'
	cMsg += '</tr>' + CRLF
	e_email = .T.

	_cLogin := Alltrim(TRA1->CP_SOLICIT)
	While !TRA1->(Eof()) .AND. Alltrim(TRA1->CP_SOLICIT) == _cLogin

		cMsg += '<tr>'
	    cMsg += '<td>'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRA1->CP_NUM + '</font></td>'
	    cMsg += '<td>'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRA1->CP_ITEM + '</font></td>'
	    cMsg += '<td>'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TRA1->CP_PRODUTO + '</font></td>'

    	SB1->(DbSetOrder(1)) //filial + numero
    	SB1->(DbSeek(xFilial('SB1')+TRA1->CP_PRODUTO))

		If SB1->(Found())
   	        cMsg += '<td>'		
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SB1->B1_DESC + '</font></td>'
		Else
     	    cMsg += '<td>'		
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' +"-"+ '</font></td>'
        EndIf
	    cMsg += '<td>'    	
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + AllTrim(STR(TRA1->CP_QUANT - TRA1->CP_QUJE)) + '</font></td>'
	    cMsg += '<td>'	    
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Alltrim(STR(DATE()-STOD(TRA1->CP_DATPRF)))+" Dias "+ '</font></td>'
		cMsg += '</tr>'
		lRet := .T.

		TRA1->(DbSkip())
	Enddo
    
	If lRet .and. !Empty(_cMail)
		cMsg += '</table>'
		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); 
			SUBJECT 'Material Aguardando Retirada No Almoxarifado *** URGENTE *** ';
			BODY cMsg;
			RESULT lEnviado
			If !lEnviado
				Get mail error cMensagem
				conout(cMensagem)

	    	Endif
		Else
			conout("Erro ao se conectar no servidor: " + cServer)		
		Endif
		lRet := .F.
	Endif	
	
Enddo
DbCloseArea('TRA1')
Return(.T.)