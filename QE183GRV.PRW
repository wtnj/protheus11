
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  QE183GRV ³ Autor ³  Alexandre R. Bento  ³ Data ³ 27/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia email para aviso de problema na importacao do quality³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Para Controle na digitacao da NF                           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


#include "rwmake.ch"
#include "AP5MAIL.CH"
User Function QE183GRV()
Local cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
Local cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'

Local lConectou
Local lEnviado
Local cMensagem := '' 
Local CRLF := chr(13)+chr(10)   // PULA LINHA  
Local cMSG := ""         
Local _cFor  := Space(06)
Local _cLoja := Space(02)


 
 If QEP->QEP_CODTAB = '2'
//    alert(" nota Entrada ")
                 
//****************************************************************************************************
//  VERIFICACAO DE AMARRACAO PRODUTOS X FORNECEDOR NO QUALITY
//****************************************************************************************************
    If SM0->M0_CODIGO == 'NH' .And. QEP->QEP_FORNEC$"000184" .And. QEP->QEP_LOJFOR$"01"
       _cFor  := "000666" //fornecedor whb fundicao
       _cLoja := "01" //loja
    Else
       _cFor  := QEP->QEP_FORNEC
       _cLoja := QEP->QEP_LOJFOR
    Endif
    
	SA2->(DbSetOrder(1))
	DbSeek(xFilial("SA2")+_cFor + _cLoja)
   
//    DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSeek(xFilial("SB1")+QEP->QEP_PRODUT)
                                                     

	   	   CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

			cMsg += '<html>' + CRLF
			cMsg += '<head>' + CRLF
			cMsg += '<title> E X E M P L O </title>' + CRLF
			cMsg += '</head>' + CRLF
			cMsg += '<b><font size="3" face="Arial">Email enviado atraves do Sistema Protheus</font></b>' + CRLF
			cMsg += '<font size="2" face="Arial">Problema na amarração PRODUTO x FORNECEDOR da Nota: '+ QEP->QEP_NTFISC+'-'+QEP->QEP_SERINF+'</font>' + CRLF
//	    	cMsg += '<font size="2" face="Arial">Favor arrumar o Problema e acessar o modulo inspeção de entrada e reimportar este produto</font>' + CRLF
			cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
			cMsg += '<tr>'
			cMsg += '<td width="15%">'
			cMsg += '<font size="2" face="Arial">Produto</font></td>'
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Arial">Descricao</font></td>'
			cMsg += '<td width="10%">'
			cMsg += '<font size="2" face="Arial">Forn/Loja</font></td>' 
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Arial">Razao Social</font></td>'
			cMsg += '<td width="30%">'
			cMsg += '<font size="2" face="Arial">Problema</font></td>'
			cMsg += '</tr>' + CRLF
		    cMsg += '<tr>'
		    cMsg += '<td width="15%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + QEP->QEP_PRODUT + '</font></td>'
		    cMsg += '<td width="30%">'
	    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SB1->B1_DESC + '</font></td>'
		    cMsg += '<td width="10%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + _cFor  + '-' + _cLoja + '</font></td>'
	    	cMsg += '<td width="30%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SA2->A2_NOME + '</font></td>'
	    	cMsg += '<td width="30%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + QEP->QEP_ERRO + '</font></td>'
		    cMsg += '</tr>' + CRLF
			cMsg += '</table>'
			cMsg += '</body>' + CRLF
			cMsg += '</html>' + CRLF
  	    	              
	 	    If SM0->M0_CODIGO == 'NH' 
		      a_email := 'leandrol@whbusinagem.com.br;suzanasd@whbusinagem.com.br'
    	    else
	 	      If AllTrim(SB1->B1_TIPO)$'MP'
	 	      	a_email := 'julianoc@whbfundicao.com.br;antoniojc@whbfundicao.com.br;eversonco@whbfundicao.com.br'
	 	      Else
	 	      	a_email := ''
	 	      EndIf
//			  a_email := 'alexandrerb@whbbrasil.com.br'
    	    endif

	  	  If lConectou
				Send Mail from 'protheus@whbbrasil.com.br' To a_email;
				SUBJECT '**********   AMARRACAO PRODUTO X FORNECEDOR   ************ ';
				BODY cMsg;   
				RESULT lEnviado
			    If !lEnviado
				   Get mail error cMensagem
				   Alert(cMensagem)
    		    EndIf                             
	  	  else
			 Alert("Erro ao se conectar no servidor: " + cServer)		
		  Endif

 Endif
 
Return(.T.)
                     