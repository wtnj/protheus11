/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST128  ºAutor  ³Felipe Rosa         º Data ³  28/01/08   º±±
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

User Function Nhest128()

/*
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

//fEnviaEmail() 
fEmailNDC("")

RESET ENVIRONMENT

Return(.t.)

Static Function fEmailNDC(_cPar)

cQuery := "	SELECT * FROM "+RetSqlName("ZA8")
cQuery += " WHERE ZA8_PROCED = ' '"
cQuery += " AND D_E_L_E_T_ = ' ' AND ZA8_FILIAL = '"+xFilial("ZA8")+"'"


TCQUERY cQuery NEW ALIAS 'TRA1'

If	!USED()
	conout(cQuery+'. Query errada')
EndIf

While TRA1->(!EOF())

	cFornece := TRA1->ZA8_CLIENT
	cLoja    := TRA1->ZA8_LOJA
	cDoc     := TRA1->ZA8_DOC
	cSerie   := TRA1->ZA8_SERIE
	cVencto  := DTOC(TRA1->ZA8_VENCTO)
	cValBrut := "R$ " +Transform(TRA1->ZA8_VALOR,"@e 999,999,999.99")
	cNFOri   := ""
	_cNivel	 := ""
	_cCondic := ""
	_cStatus := ""
	_mot1	 := TRA1->ZA8_MOT1
	_mot2	 := TRA1->ZA8_MOT2
	_mot3	 := TRA1->ZA8_MOT3
	_cLanc   := Subs(EMBARALHA(TRA1->ZA8_USERGI,1),1,AT(" ",EMBARALHA(TRA1->ZA8_USERGI,1)))
	
	_cAprovador := "-pendente-"
	If !Empty(TRA1->ZA8_APROVA)
		_cAprovador := TRA1->ZA8_APROVA
	EndIf
	
	if !empty(TRA1->ZA8_ANALIS)
		_cAnalis := TRA1->ZA8_ANALIS
	else
		_cAnalis := "-pendente-"
	endif
	
	_cGrupo  := TRA1->ZA8_GRUPO
	
	SA2->(DBSETORDER(1))
	SA1->(DBSETORDER(1))
	
	IF SA2->(DbSeek(xFilial("SA2") + cFornece + cLoja))
		If SA2->(Found())
			_Razao := SA2->A2_NOME
		Endif
	else
		SA1->(DbSeek(xFilial("SA1") + cFornece + cLoja))
		If SA1->(Found())
			_Razao := SA1->A1_NOME
		Endif
	endif
	
	SD1->(DBSETORDER(1))
	IF SD1->(DBSEEK(XFILIAL("SD1")+cDoc+cSerie))
		cNFOri := SD1->D1_NFORI
	ENDIF
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	   
	cMsg := '<html>'// + CRLF
	cMsg += '<head>'// + CRLF
   	cMsg += '<title>NOTA FISCAL DE DEBITO</title>'// + CRLF
   	cMsg += '</head>' //+ CRLF
    cMsg += '<strong><font size="5" face="Times New Roman">Registro de Ocorrencia de Debitos ('+_cPar+')</font></strong>'+ CRLF
	cMsg += '<strong><font size="3" face="Arial"> Email Enviado Automaticamente pelo Sistema Protheus</font></strong>' + CRLF+CRLF
	
	If _cPar == "Aprovacao"
		cMsg += '<font size="3" face="Arial"> Status :<strong> ' + UPPER(_cStatus)		+ '</strong></font>' + CRLF + CRLF
	else
		cMsg += CRLF
	EndIf
	
	cMsg += '<font size="2" face="Arial"> Codigo Cliente  : ' + cFornece 			+ '-' 		+ cLoja + '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Razao Social    : ' + _Razao 				+ '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Nota de Debito  : ' + cDoc 				+ '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Data Entrega    : ' + Dtoc(ddatabase) 	+ '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Total da NF     : ' + cValBrut            +'</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> NF Origem       : ' + cNFOri		 		+ '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Data Vencimento : ' + cVencto             + '</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Motivo(s) :     </font>' + CRLF
	cMsg += '<font size="2" face="Arial"> ' + _mot1 + '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> ' + _mot2 + '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> ' + _mot3 + '</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Análise :     </font>' + CRLF
	cMsg += '<font size="2" face="Arial"> ' + _cAcao + '</font>' + CRLF
	cMsg += CRLF
	cMsg += '<font size="2" face="Arial"> Lançado Por   :   ' + Upper(_cLanc) + '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Analisado Por : ' + _cAnalis      + '</font>' + CRLF
	cMsg += '<font size="2" face="Arial"> Aprovado Por  :  ' + _cAprovador   +'</font>'+ CRLF
	//Fecha Tabela
	cMsg += '</table>'
	cMsg += '</body>'// + CRLF
	cMsg += '</html>'// + CRLF
	
	a_email := ''
	
	DbSelectArea("ZAY")
	DbSetOrder(1)//FILIAL + GRUPO + NIVEL
	QAA->(DbSetOrder(6)) // LOGIN
	
	If _cPar == "Aprovacao"
		_cNivel := "3"
	ElseIf _cPar == "Analise"
		_cNivel := "1"
	ELSE
		_cNivel := ""
	EndIf
	
	DbSeek(xFilial("ZAY")+_cGrupo+_cNivel) //NIVEL 1 SOMENTE PARA APROVADORES
	
	If _cNivel == ""
		_cCondic := ".T."
	Else
		_cCondic := "ZAY->ZAY_NIVEL == _cNivel"
	EndIf
	
	While ZAY->ZAY_GRUPO == _cGrupo .AND. &(_cCondic)
		
		If QAA->(DbSeek(ALLTRIM(ZAY->ZAY_LOGIN)))
			If !Empty(QAA->QAA_EMAIL)
				a_email += "joaofr@whbbrasil.com.br;"//ALLTRIM(QAA->QAA_EMAIL) + ';'
//			Else
				//MsgBox("Email não cadastrado para: "+QAA->QAA_LOGIN+".","Atencao","ALERT")
			EndIf
		EndIf
		ZAY->(DbSkip())
	EndDo
	
	If lConectou
		Send Mail from 'protheus@whbbrasil.com.br' To a_email;
		SUBJECT ' ***** AVISO DE DEBITO DE CLIENTE ('+UPPER(_cPar)+') ***** ';
		BODY cMsg;
		RESULT lEnviado
		If !lEnviado
			Get mail error cMensagem
//			Alert(cMensagem)
		EndIf
	else
//		Alert("Erro ao se conectar no servidor: " + cServer)
	Endif
	
	TRA1->(DbSkip())
			
EndDo

DbCloseArea('TRA1')

*/
Return(.T.)
