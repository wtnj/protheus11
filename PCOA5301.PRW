/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualizacao                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Compras/PCO                                             !
+------------------+---------------------------------------------------------+
!Nome              ! GL_PE_PCOA530                                           !
+------------------+---------------------------------------------------------+
!Descricao         ! PONTO DE ENTRADA                                        !
!                  ! Tratamento do processo de contingencia na inclusão de SC!
!                  ! no momento da integracao com o PCO                      !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO SERGIO SALVADOR                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 02/06/2014                                              !
+------------------+---------------------------------------------------------+

PCOA5301
Ponto de entrada utilizado para inclusao de funcoes de usuarios na preparacao 
do texto a ser exibido no email / html dados do bloqueio
Parametros : cTxtBlq
Retorno    : cTxtBlq (texto manipulado)                                

P530EWF
Ponto de entrada para customizar e enviar novo email.

*/

#include "rwmake.ch"
#Include "PROTHEUS.CH"
#Include "AP5MAIL.CH"                           
#Include "SIGAWF.CH"

User Function PCOA5301() 

	Local cTxtAlt := ""

	// DADOS DO ACOLS (SC1) POSICIONADO NA LINHA DA SC
	Local cNumSC 			:= Alltrim(CA110Num)
	Local cItemSC 		:= Alltrim(GDFieldGet('C1_ITEM'))
	Local cProduto 		:= Alltrim(GDFieldGet('C1_PRODUTO'))
	Local cDescPro 		:= Alltrim(GDFieldGet('C1_DESCRI'))
	Local cTipoPro 		:= Posicione("CT1",1,xFilial("CT1")+GDFieldGet('C1_PRODUTO'),"CT1_DESC01")
	Local cLocalPro  	:= Alltrim(GDFieldGet('C1_LOCAL'))
	Local cQuantPro 	:= Alltrim(Str(GDFieldGet('C1_QUANT'),12,2))
	Local cVlUnitPro 	:= Alltrim(Str(GDFieldGet('C1_PRCUNI'),12,2))
	Local cVlTotPro 	:= Alltrim(Str(GDFieldGet('C1_PRCORC'),12,2))
	Local cContaPro 	:= GDFieldGet('C1_CONTA')
	Local cPrevEnt 		:= Dtoc(GDFieldGet('C1_DATPRF'))
	Local cObsPro 		:= Alltrim(GDFieldGet('C1_OBS'))  

	// MODIFICACAO DO TEXTO DA MENSAGEM A SER ENVIADA POR EMAIL
	cTxtAlt := "Os saldos atuais do Planejamento e Controle Orçamentário são insuficientes para completar esta operação no periodo de "+Dtoc(ParamIxb[2,9,1])+" - "+Dtoc(ParamIxb[2,9,2])+"."+CRLF
	cTxtAlt += "Tipo de Bloqueio : "+AllTrim(AKJ->AKJ_DESCRI)+CRLF
	cTxtAlt += "Processo         : "+Alltrim(AK8->AK8_DESCRI)+CRLF
	cTxtAlt += "Cubo             : "+ParamIxb[2,8]+CRLF
	cTxtAlt += "Filtro           :"+ParamIxb[2,4]+CRLF
	cTxtAlt += "Saldo Previsto   : "+Alltrim(Str(ParamIxb[2,3],12,2))+" Vs Saldo Realizado : "+Alltrim(Str(ParamIxb[2,2],12,2))+CRLF
	cTxtAlt += "Valor da Solicitação de Contingência: "+Alltrim(Str(ParamIxb[2,2]-ParamIxb[2,3],12,2))+CHR(13)+CRLF
	//cTxtAlt += "Solicitacao de Compra --> "+cNumSC+"-"+cItemSC+CRLF
	cTxtAlt += "Produto               --> "+cProduto+"-"+cDescPro+CRLF
	cTxtAlt += "Tipo                  --> "+cTipoPro+" Almoxarifado --> "+cLocalPro+CRLF
	cTxtAlt += "Quantidade            --> "+cQuantPro+" Valor Unitario --> "+cVlUnitPro+" Valor Total do Item --> "+cVlTotPro+CRLF
	cTxtAlt += "Conta Contabil        --> "+Alltrim(cContaPro)+"-"+Posicione("CT1",1,xFilial("CT1")+cContaPro,"CT1_DESC01")+CRLF
	cTxtAlt += "Data da Necessidade   --> "+cPrevEnt+CRLF
	cTxtAlt += "Observacao do Item    --> "+cObsPro+CRLF

Return(cTxtAlt)
                           
User Function P530EWF()

	Local cConting := ALI->ALI_CDCNTG   
	Local cAprov   := ALI->ALI_USER // CODIGO DO APROVADOR
	Local cSolici  := ALI->ALI_SOLIC // CODIGO DO SOLICITANTE
	
	Local cMail			:= Lower(ParamIxb[2,1])
	Local lEditaTxt := .T.
	Local cTxtBlq		:= ParamIxb[3]
	Local cMensagem	:= ParamIxb[4]
	Local lWf				:= .F.                                 
	Local aAprov    := Nil
	Local cRamal    := Nil  
	
	If Empty(Alltrim(cTxtBlq))
		cConting 	:= ALJ->ALJ_CDCNTG   
		cAprov  	:= ALJ->ALJ_USER // CODIGO DO APROVADOR
		cSolici 	:= Posicione("ALI",2,xFilial("ALI")+ALJ->(ALJ_LOTEID+ALJ_USER),"ALI_SOLIC") //CODIGO DO SOLICITANTE
	Endif
	                                       
	// AJUSTE NO CORPO DA MENSAGEM DO EMAIL QUANDO A SOLICITAAO É INCLUIDA
	If !Empty(Alltrim(cTxtBlq))
		cMensagem := "Prezado(a) Senhor(a) "+UsrFullName(cAprov)+CRLF
		cMensagem += "Solicito liberação de verba orçamentária para a SOLICITAÇÃO DE CONTINGÊNCIA número "+cConting+CRLF
		cMensagem += "conforme dados dados abaixo."+CRLF+CRLF
		cMensagem += "Nesse espaço o solicitante deve JUSTIFICAR o motivo da solicitação, de forma resumida,"+CRLF
		cMensagem += "mas de maneira a facilitar e agilizar o entendimento por parte do aprovador."+CRLF+CRLF
		cMensagem += "Atenciosamente,"+CRLF+CRLF
		cMensagem += UsrFullName(cSolici)+CRLF+CRLF // UsrRetName(cSolici)+CRLF
	Endif

	EPCOBLQ(cMail,lEditaTxt,cTxtBlq,cMensagem,lWF,cConting,cSolici,cAprov)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³   EPCOBLQ    ºAutor  ³Salvador   º Data ³ 03/06/14         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia email de bloqueio para aprovador da solicitacao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EPCOBLQ(cMail,lEditaTxt,cTxtBlq,cMensagem,lWF,cConting,cSolici,cAprov) 
Local cTO					:= Padr(UsrRetMail(cSolici),200)
Local cCC					:= Padr(UsrRetMail(cAprov),200)
Local cAssunto		:=	Padr("Solicitacao de liberacao orcamentaria",200)
Local cMailConta	:=SUPERGETMV("MV_RELACNT",.F.,"")
Local cMailServer	:=SUPERGETMV("MV_RELSERV",.F.,"")
Local cMailSenha	:=SUPERGETMV("MV_RELPSW",.F.,"")
Local oDLg                                                                                    
Local lDlgOk
Local cMsg5302

DEFAULT cTxtBLQ	:=	""
DEFAULT lWF		:=	.F.

If !Empty(Alltrim(cTxtBlq))
	cTO				:= Padr(cMail,200)
	cCC				:= Padr(UsrRetMail(cSolici),200)
	cAssunto	:=	Padr("Solicitacao de liberacao orcamentaria >>>> "+cConting,200)
Endif

lDlgOk	:= lWF // Caso seja aprovação por workflow força ok do Dialog

Private cError  := ""
Private lOk    	:=	.F.
Private lSendOk	:=	.T.  

lMudaEmail 	:=	Empty(cMail)

If !EMPTY(cTxtBlq)
	cMensagem	+=	"_Dados do bloqueio____________________"+CRLF+CRLF
	cMensagem	+=	cTxtBlq
Endif

If ExistBlock("PCOA5302")

	//P_EÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//P_E³ Ponto de entrada utilizado alterar o texto envaido no email informado  ³
	//P_E³ que a contingencia foi aprovada.                                       ³
	//P_E³ Parametros : Nenhum                                                    ³
	//P_E³ Retorno    : Caracter (Texto a ser enviado no email)                   ³
	//P_E³  Ex. :  User Function PCOA5302                                         ³
	//P_E³         Return ( " Contingencia aprovada " )                           ³
	//P_EÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cMsg5302	:= ExecBlock("PCOA5302",.F.,.F.,{cMensagem})
	cMensagem 	:= If(VALTYPE(cMsg5302)="C",cMsg5302,cMensagem)

EndIf

If lEditaTXT .And. !lWF
	DEFINE MSDIALOG oDLg from 110,013 To 539,696 Title OemToAnsi("Envio de email") PIXEL of oMainWnd
	@ 002,002 To 50,334 PIXEL of oDlg
	@ 009,006 Say OemToAnsi("Para") 			Size 32,8 PIXEL of oDlg
	@ 022,006 Say OemToAnsi("Com copia") 	Size 29,8 PIXEL of oDlg
	@ 035,006 Say OemToAnsi("Assunto") 		Size 33,8 PIXEL of oDlg
	@ 009,039 MSGet cTo 		Size 294,10 PIXEL of oDlg
	@ 022,039 MSGet cCC 		Size 294,10 PIXEL of oDlg
	@ 035,039 MSGet cAssunto 	Size 294,10 PIXEL of oDlg
	@ 052,003 Get cMensagem MEMO Size 332,142 PIXEL of oDlg

	@ 196,299 Button OemToAnsi("&Enviar") Size 36,16 Action (lDlgOk := .T. ,oDlg:End()) PIXEL of oDlg
	Activate Dialog oDlg
	cMensagem+=	"______________________________________"+CRLF
Endif                     

If lDlgOk
	If !Empty(cMailServer) 
		// Conecta uma vez com o servidor de e-mails
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
	EndIf
	If lOk
		SEND MAIL FROM cMailConta/*UsrRetMail(__cUserID)*/ To cTo BCC cCC  SUBJECT cAssunto BODY cMensagem  RESULT lSendOk
		If !lSendOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError                                
			If !lWF
				Aviso("Erro no envio do e-Mail",cError,{"Fechar"},2)  
			Else
				CONOUT("Erro no envio do e-Mail: "+cError) 		 
			EndIf
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		If !Empty(cMailServer) 
			GET MAIL ERROR cError
		Endif
	
		If !lWF
			Aviso("Erro no envio do e-Mail",cError,{"Fechar"},2)
		Else
			CONOUT("Erro no envio do e-Mail: "+cError)
		EndIf
	EndIf    
	
	If lOk
		DISCONNECT SMTP SERVER
	EndIf
EndIf

Return .T.