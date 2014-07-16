/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MA035INC  ³ Autor ³ Alexandre R. Bento    ³ Data ³ 26.03.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Envia email com o novo grupo que foi criado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³WHB                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualiz. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "rwmake.ch"
                        

#include "rwmake.ch"              
#include "AP5MAIL.CH" 
#include "colors.ch"
#include "font.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"

User Function MA035INC()
Local  cErro    := ""
Local cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
Local cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
Local lConectou
Local lEnviado
Local cMensagem := 'Erro ao se conectar no servidor: ' 
Local CRLFF     := chr(13)+chr(10)   // PULA LINHA  
Local cMSG      := ""
                                             

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

cMsg := '<html>' + CRLF
cMsg += '<head>' + CRLF
cMsg += '<title> Grupo </title>' + CRLF
cMsg += '</head>' + CRLF
cMsg += '<b><font size="5" face="Times New Roman">'+CRLF+'          Novo Grupo</font></b>'+ CRLF	 
cMsg += CRLF	        
cMsg += '<b><font size="3" face="Arial"> Email Enviado Automaticamente pelo Sistema Protheus</font></b>' + CRLF+CRLF
cMsg += '<font size="2" face="Arial"> Foi criado o Grupo '+SBM->BM_GRUPO+'-'+SBM->BM_DESC  + '    na data: '+Dtoc(ddatabase)+ '</font>' + CRLF
cMsg += CRLF	 
cMsg += '<font size="2" face="Arial"> Grupo Criado Por '+ UsrFullName(__cUserID)+'   Na Empresa '+Iif(SM0->M0_CODIGO == "NH"," WHB USINAGEM S.A."," WHB FUNDIÇÃO S.A.") +' </font>' + CRLF	 
cMsg += '</body>' + CRLF
cMsg += '</html>' + CRLF
a_email = 'Bernyh@whbbrasil.com.br'

If lConectou
   Send Mail from 'protheus@whbbrasil.com.br' To a_email;
   SUBJECT ' ***** Novo Grupo Criado ***** ';
   BODY cMsg;                      
   RESULT lEnviado
   If !lEnviado
  	   Get mail error cMensagem
	   Alert(cMensagem)
   EndIf                             
else
    Alert("Erro ao se conectar no servidor: " + cServer)		
Endif

Return
               