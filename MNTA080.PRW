#include "rwmake.ch"       
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTA080   ºAutor  ³João Felipe da Rosa º Data ³  12/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±	     	 ³                                                            º±±
±±ºDesc.     ³ PONTO DE ENTRADA DA ROTINA MNTA080 CHAMADO APOS A          º±±
±±º          ³ CONFIRMACAO DA INCLUSAO DE BENS                            º±±
±±º          ³ DESC: ENVIA E-MAILS DE AVISO DE INCLUSAO DE BENS           º±±
±±	     	 ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNTA080()
/*

Local cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
Local cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
Local lConectou
Local lEnviado
Local cTexto    := ""
Local CRLF      := chr(13)+chr(10)   // PULA LINHA
Local cTo := ""

IF SM0->M0_CODIGO == "NH" .AND. INCLUI  //empresa USINAGEM

	cTo += "claudiosa@whbusinagem.com.br;"
	cTo += "edinapn@whbusinagem.com.br;"

//	cTo += "marciliom@whbusinagem.com.br;"
//	cTo += "paulomg@whbusinagem.com.br;"
//	cTo += "samanthanp@whbusinagem.com.br;"
//	cTo += "edemirjs@whbusinagem.com.br;"
//	cTo += "gilbertot@whbusinagem.com.br;"
//	cTo += "fernandoej@whbbrasil.com.br;"
//	cTo += "geraldoz@whbusinagem.com.br;"
//	cTo += "rogeriofm@whbbrasil.com.br;"
//	cTo += "jeanmr@whbusinagem.com.br;"
//	cTo += "fernandow@whbbrasil.com.br;"
//	cTo += "andersonk@whbbrasil.com.br;"
//	cTo += "felipest@whbbrasil.com.br;"
//	cTo += "claudiosa@whbusinagem.com.br;"
//	cTo += "edsonlm@whbusinagem.com.br;"
//	cTo += "glalberez@whbbrasil.com.br;"
//	cTo += "edsontp@whbusinagem.com.br;"
//	cTo += "antoniobb@whbusinagem.com.br;"
//	cTo += "jclaudio@whbusinagem.com.br"

	
	cTexto += "<hr />"
	cTexto += "<table style='font-family:Arial;font-size:12px' border='1' cellpadding='0' cellspacing='0'>"
	cTexto += "<tr><td style='background:#aabbcc'>Bem:</td><td>"+M->T9_CODBEM+"</td></tr>"
	cTexto += "<tr><td style='background:#aabbcc'>Descrição:</td><td>"+M->T9_NOME+"</td></tr>"
	cTexto += "<tr><td style='background:#aabbcc'>Modelo:</td><td>"+M->T9_MODELO+"</td></tr>"
	cTexto += "<tr><td style='background:#aabbcc'>C.Custo:</td><td>"+M->T9_CCUSTO+"</td></tr>"
	cTexto += "<tr><td style='background:#aabbcc'>Data da Compra:</td><td>"+DTOC(M->T9_DTCOMPR)+"</td></tr>"
	cTexto += "</table>"
	cTexto += "<hr />"
	cTexto += "<span style='font-family:Arial;font-size:12px'>Mensagem automática. Favor não responder.</span>"
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
	If lConectou
		
		Send Mail from "protheus@whbbrasil.com.br";
		To cTo;
		SUBJECT "****** NOVO BEM CADASTRADO ******";
		BODY cTexto;
		RESULT lEnviado
		                
		If !lEnviado
			Get mail error cMensagem
			Alert(cMensagem)
		EndIf

	Else
		Alert("Erro ao se conectar no servidor: " + cServer)		
	Endif 
	
EndIf
*/	
Return
