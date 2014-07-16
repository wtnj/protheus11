#include "rwmake.ch"              
#include "AP5MAIL.CH" 
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"

User Function TESTEWMS(cCodEmp,cCodFil)
Local cServer
Local cAccount
Local cPassword
Local lConectou
Local lEnviado
Local CRLFF     := chr(13)+chr(10)   // PULA LINHA  
Local cMsg      := ""  
Local cHorario := Substr(Time(),1,5)
Default cCodEmp := 'FN'
Default cCodFil := '01'  

 If	Select('SX2') == 0
		RPCSetType( 3 )					
		conout(dtoc(date())+'|'+time()+'|'+"Preparando ambiente utilizando empresa " + cCodEmp + " filial " + cCodFil)
		RpcSetEnv(cCodEmp,cCodFil,,,,GetEnvServer(),{ "SM2" })	
  EndIf     
  
  cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
  cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
  cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga' 

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

	cMsg := 'Teste Schedule' + CRLF
	cMsg += 'Data: '+ Dtoc(Date()) + ' Horario: ' + cHorario + CRLF
	
	a_email = 'douglassd@whbbrasil.com.br'

	If lConectou
	    Send Mail from 'protheus@whbbrasil.com.br' To a_email;
	    SUBJECT ' ***** Teste Schedule ***** ';
	    BODY cMsg;                      
	    RESULT lEnviado		         
	Endif

Return "Executado"