
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MT120GRV ³ Autor ³  Alexandre R. Bento  ³ Data ³ 27/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Na inclusão do pedido de compras                           ³±±
±±³          ³ Manda um email de urgente qdo a maquina esta parada        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "AP5MAIL.CH"
//***********************************************************************************************************
//
//***********************************************************************************************************
User Function MT120GRV()

Local cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
Local cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
Local cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
Local lConectou
Local lEnviado
Local cMensagem := '' 
Local CRLF := chr(13)+chr(10)   // PULA LINHA  
Local cMSG := ""        
Local _cParado := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PARADO"})                   
Local _cProd   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRODUTO"})                   
Local _cDescri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_DESCRI"})                   
Local _nQuant  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_QUANT"})                   
Local _dData   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_DATPRF"})                   
Local _cTotal  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_TOTAL"})      
Local _lExclui := Paramixb[4] // exclusao             

e_email = .F.                         


If nTipoped == 2 // so executa na autorizacao de entrega
   If SB1->(Dbseek(xFilial("SB1")+Acols[1][_cProd] ))
       RecLock("SB1",.F.)
	     SB1->B1_CONTRAT := "N"
	   MsUnlock("SB1")  
   Endif                 

Endif   

If inclui

	If SM0->M0_CODIGO == 'NH' // WHB USINAGEM                                             
		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		DbSeek(xFilial("SA2")+CA120FORN+CA120LOJ)
		a_Nome := A2_NOME 
	
		TEXTO := 'Favor Receber Este Pedido Em Prioridade Alta e Encaminhar ao Setor Responsavel '+chr(13)+chr(10)
		TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
		TEXTO += ' ' +chr(13)+chr(10)
		TEXTO += 'Pedido      = ' + CA120NUM + chr(13)+chr(10)
		TEXTO += 'Fornecedor  = ' + CA120FORN+"-"+CA120LOJ + chr(13)+chr(10)
		TEXTO += 'Razao Social = ' + a_Nome + chr(13)+chr(10)
		TEXTO += "PRODUTO"+Space(10)+"DESCRICAO                             QUANTIDADE                          PREV.CHEGADA " + chr(13)+chr(10)
	
		for lin_ := 1 to len(Acols)
		  if ACols[lin_][_cParado]$"S"
	    	 e_email := .T.
			 TEXTO += Acols[lin_][_cProd] + ' --- ' + Acols[lin_][_cDescri] + ' --- ' + Str(Acols[lin_][_nQuant])
		     TEXTO += ' --- ' + Substr(Dtos(Acols[lin_][_dData]),7,2)+"/"+Substr(Dtos(Acols[lin_][_dData]),5,2)+"/"+Substr(Dtos(Acols[lin_][_dData]),1,4) +chr(13)+chr(10)
		  endif
		next
	
		if e_email :=  .T.
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			    Send Mail from 'protheus@whbbrasil.com.br' To 'lista-fiscal@whbbrasil.com.br';
				SUBJECT 'PEDIDO DE COMPRA  ***** URGENTE ***** ';
				BODY TEXTO;
				RESULT lEnviado
			If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
	    	EndIf
		else
			Alert("Erro ao se conectar no servidor: " + cServer)		
		Endif
	  endif
	ENDIF
Endif	
//****************************************************************************************************
//  VERIFICACAO DE AMARRACAO PRODUTOS X FORNECEDOR NO QUALITY
//****************************************************************************************************

for lin_ := 1 to len(Acols)
  
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	DbSeek(xFilial("SA2")+CA120FORN+CA120LOJ)
	a_Nome := A2_NOME
	a_Loja := A2_LOJA
    _produto := ACols[lin_][_cProd] 
    
    DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSeek(xFilial("SB1")+_produto)

	
    If SB1->B1_TIPO$"CC/CP/MP/MC"
	    dbSelectArea("SA5")
	    dbSetOrder(1)
	    dbSeek(xFilial()+CA120FORN+a_Loja+_produto)
    
    	if EMPTY(A5_FORNECE)        
	   	   CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

			cMsg := '<html>' + CRLF
			cMsg += '<head>' + CRLF
			cMsg += '<title> E X E M P L O </title>' + CRLF
			cMsg += '</head>' + CRLF
			cMsg += '<b><font size="3" face="Arial">Email enviado atraves do Ap8</font></b>' + CRLF
			cMsg += '<font size="2" face="Arial">Falta amarração PRODUTO x FORNECEDOR.</font>' + CRLF
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
			cMsg += '</tr>' + CRLF
		    cMsg += '<tr>'
		    cMsg += '<td width="15%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Acols[lin_][_cProd] + '</font></td>'
		    cMsg += '<td width="30%">'
	    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Acols[lin_][_cDescri] + '</font></td>'
		    cMsg += '<td width="10%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + CA120FORN + '-' + CA120LOJ + '</font></td>'
	    	cMsg += '<td width="30%">'
		    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + a_Nome + '</font></td>'
		    cMsg += '</tr>' + CRLF
			cMsg += '</table>'
			cMsg += '</body>' + CRLF
			cMsg += '</html>' + CRLF
  	    	              
	 	    If SM0->M0_CODIGO == 'NH' 
 		      a_email := 'leandrol@whbusinagem.com.br;suzanasd@whbusinagem.com.br'
 	        else
	 	      a_email := 'julianoc@whbfundicao.com.br;antoniojc@whbfundicao.com.br;eversonco@whbfundicao.com.br'
 		    endif
	  	    If lConectou
				Send Mail from 'protheus@whbbrasil.com.br' To a_email;
				SUBJECT '***** NAO EXISTE *****   AMARRACAO PRODUTO X FORNECEDOR   ***** NAO EXISTE ***** ';
				BODY cMsg;   
				RESULT lEnviado
			  If !lEnviado
				Get mail error cMensagem
				Alert(cMensagem)
    		  EndIf                             
	  	    else
			  Alert("Erro ao se conectar no servidor: " + cServer)		
		    Endif
	    endif
    endif   
    
    If _lExclui //Exclusao p/ baixar o saldo do orcamento ZAK
	    If nTipoped == 1 // so executa no pedido de compras
	    
	       If Subs(Alltrim(Acols[lin_][_cProd]),1,2)$"FE/MM"
		      ZAK->(DbSetOrder(1))//filial + mesano
		      If ZAK->(Dbseek(xFilial("ZAK")+Strzero(Month(Acols[lin_][_dData]),2) + "/"+Strzero(Year(Acols[lin_][_dData]),4)))  
		         If Subs(Alltrim(Acols[lin_][_cProd]),1,2)$"FE"         
	            	Reclock("ZAK",.F.)
					   ZAK->ZAK_SLDFE   += Acols[lin_][_cTotal]
					MsUnlock("ZAK")     
			     ElseIf Subs(Alltrim(Acols[lin_][_cProd]),1,2)$"MM"         
		            	Reclock("ZAK",.F.)
					       ZAK->ZAK_SLDMM   += Acols[lin_][_cTotal]
					    MsUnlock("ZAK")     
	    	     Endif   
	    	  Endif
	       Endif
	    Endif   	     
	Endif  
next          

Return(.T.)