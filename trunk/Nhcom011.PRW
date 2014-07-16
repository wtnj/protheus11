/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM011  ºAutor  ³Alexandre R. Bento  º Data ³  28/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email dos fornecedores com data a expirar do certifica-±±
±±º          ³do de qualidade p/ os compradores                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "topconn.ch"

User Function Nhcom011()

SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")

//PREPARE ENVIRONMENT EMPRESA "NH" FILIAL "01" MODULO "COM" TABLES "QAA","SC1","SZU"

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
lConectou
lEnviado
cMensagem := '' 
CRLF := chr(13)+chr(10)
cMSG := ""
lEnd := .F.   
e_email = .F.                         

fGer_For()
//Alert("enviando e-mail")
TMP->(DbCloseArea())
//RESET ENVIRONMENT
Return(.t.)


Static Function fGer_For()
Local lRet := .F.
Local cQuery
_cMail := ""
_cNome := "Ola, "

     
cQuery :=" SELECT A2_DTEXPQ,A2_HOMOQUA,A2_ORIQUA,* "
cQuery += " FROM " +  RetSqlName( 'SA2' ) 
cQuery += " WHERE A2_FILIAL =  '" + xFilial("SA2")+ "'"    
cQuery += " AND A2_DTEXPQ <= '" + Dtos(dDatabase+30) + "' "                                                                                                           
cQuery += " AND A2_DTEXPQ <> ' ' "
cQuery += " AND A2_EEMAIL <> 'S' "
cQuery += " AND D_E_L_E_T_ = ' '"
cQuery += " ORDER BY A2_DTEXPQ"
  
MemoWrit('C:\TEMP\COM011.SQL',cQuery)
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TMP"      
TcSetField("TMP","A2_DTEXPQ","D")  // Muda a data de string para date    
DbSelectArea("TMP")
 
TMP->(DbGotop())
If Empty(TMP->A2_COD) 
   TMP->(DbCloseArea())
   Return  // sai fora
Endif


	cMsg := '<html>' + CRLF
	cMsg += '<head>' + CRLF
	cMsg += '<title> RELAÇÃO DE FORNECEDORES COM CERTIFICADO DE QUALIDADE EXPIRADO</title>' + CRLF
	cMsg += '</head>' + CRLF
    cMsg += '<b><font size="2" face="Arial">' + _cNome + '</font></b>' + CRLF
	cMsg += '</tr>' + CRLF
    cMsg += '<tr>'
	cMsg += '<b><font size="3" face="Arial">Existe Fornecedores com Data Expirada do Certificado de Qualidade. </font></b>' + CRLF
	cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
	cMsg += '</tr>' + CRLF

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Codigo</font></td>'

	cMsg += '<td width="30%">'
	cMsg += '<font size="2" face="Arial">Nome</font></td>'

	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Data Certificado</font></td>'
	cMsg += '</tr>' + CRLF
	e_email = .T.


	While !TMP->(Eof()) 

	
				cMsg += '<tr>'
			    cMsg += '<td width="10%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TMP->A2_COD +'-'+TMP->A2_LOJA+ '</font></td>'

			    cMsg += '<td width="30%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + TMP->A2_NOME + '</font></td>'

			    cMsg += '<td width="10%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + DTOC(TMP->A2_DTEXPQ) + '</font></td>'

//			    cMsg += '<td width="18%">'
//			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_PRODUTO + '</font></td>'
//		    	cMsg += '<td width="30%">'
//			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_DESCRI + '</font></td>'

//		    	cMsg += '<td width="30%">'
//			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Alltrim(STR(DATE()-SC1->C1_EMISSAO))+" Dias "+ '</font></td>'
				cMsg += '</tr>'
				lRet := .T.
	
	
		TMP->(DbSkip())
	Enddo


		cMsg += '</table>'
		cMsg += '</body>' + CRLF
		cMsg += '</html>' + CRLF
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
//			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';
			Send Mail from 'protheus@whbbrasil.com.br' To 'alexandrerb@whbbrasil.com.br';
			SUBJECT 'FORNECEDORES COM DATA EXPIRADA DO CERTIFICADO DE QUALIDADE ';
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
	


Return(.T.)