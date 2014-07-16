#include "rwmake.ch"              
#include "AP5MAIL.CH" 
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"

User Function NHEST224(_aMail)
Local cServer
Local cAccount
Local cPassword
Local lConectou
Local lEnviado 
Local cTitulo
Local CRLFF     := chr(13)+chr(10)   // PULA LINHA  
Local cHorario := Substr(Time(),1,5)  
Local cMsg := ""                      
Local cEmail := "douglassd@whbbrasil.com.br"
/*
Local cEmail := "douglassd@whbbrasil.com.br;leandrojs@whbusinagem.com.br;almirantec@whbusinagem.com.br;josemarsp@whb.interno;"+; 
				"adrianosd@whbbrasil.com.br;elenitaou@whbusinagem.com.br;tiagoms@whbbrasil.com.br;ElibertoSO@whbbrasil.com.br;"+; 
				"IvanildoB@whbbrasil.com.br;fabianea@whbusinagem.com.br;MatheusB@whbfundicao.com.br;marcelom@whbusinagem.com.br" 
*/				 
Default cTitulo := '*** AVISO DE TRANSFERENCIA DE MATERIAL P/ QUALIDADE ***' 
  
  cServer	:= Alltrim(GETMV("MV_RELSERV")) //"192.168.1.4"
  cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
  cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga' 

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	
		/* ADICIONADO NO MTA261TOK
		
		Aadd(_aMail,{Substr(Acols[_x][3],18,28),; // Descricao do produto
						Substr(Acols[_x][1],1,9),;   // nota fiscal
						Substr(Acols[_x][1],11,3),;  // serie
						Acols[_x][4],;               // quantidade
						Substr(Acols[_x][3],2,15),;  // código do produto whb
						cCodProd,;      	          // código do produto cliente/fornecedor
						Acols[_x][7]})               // data fusao
		
		*/

		cMsg := '<html><head><title>Aviso de Embarque</title></head><body>'
		cMsg += '<TABLE WIDTH="100%" style="font-family:arial" border="1">'
		cMsg += '<TR style="background:#666666;color:#eeeeee">'
		cMsg += '<TD colspan="7" align="center">Aviso de Transferência de Material / Qualidade</TD>'
		cMsg += '</TR>'
		
		cMsg += '<TR style="background:#aabbcc;font-size:12px;font-weight:bold">'
		cMsg += '<TD width="20%" align="center" >Nº. Documento: </TD>'
		cMsg += '<TD width="20%" align="center" colspan="2">Usuário: '+Alltrim(cUserName)+'</TD>'
		cMsg += '<TD width="15%" align="center">Data da Saída: '+DtoC(Date())+'</TD>'
		cMsg += '<TD width="20%" align="center" colspan="3">Hora de Saída:  '+time()+'</TD>'
		cMsg += '</TR>'
		
		cMsg += '<TR style="background:#aabbcc;font-size:12px;font-weight:bold">'
		cMsg += '<TD width="20%" align="center">Item</TD>'
		cMsg += '<TD width="40%" align="center" colspan="2">Produto</TD>'
		cMsg += '<TD width="40%" align="center">Descrição</TD>'
		cMsg += '<TD width="20%" align="center">Quantidade</TD>'
		cMsg += '<TD width="20%" align="center">Armazem</TD>'
		cMsg += '<TD width="20%" align="center">Lote</TD>'
		cMsg += '</TR>'
        
		For _x:=1 to Len(_aMail)
			
			cMsg += '<TR style="background:'+Iif(_x%2==0,'#eeeeee','#ffffff')+';font-size:12">'
			cMsg += '<TD width="20%" align="center">'+str(_aMail[_x][1])+'</TD>' // Item
			cMsg += '<TD width="40%" align="center" colspan="2">'+ _aMail[_x][2] + '</TD>' // Produto			
			
			SB1->(DBSETORDER(1)) // FILIAL + COD    
		    If SB1->(DbSeek(xFilial("SB1")+_aMail[_x][2]))		  	
			  	cMsg += '<TD width="40%" align="center">'+ Alltrim(SB1->B1_DESC) + '</TD>'  // descrição
			else 
				cMsg += '<TD width="40%" align="center">&nbsp</TD>'  // descrição				
			endif			
			
			cMsg += '<TD width="20%" align="center">'+ str(_aMail[_x][3]) + '</TD>' // Quantidade    
			
			cMsg += '<TD width="20%" align="center">'+ (_aMail[_x][5]) + '</TD>' //Armazem
			
			cMsg += '<TD width="20%" align="center">'+ (_aMail[_x][4]) + '</TD></TR>' //Lote
			
		Next
		 
		cMsg += '</TABLE>'
		cMsg += CRLF

		cMsg += CRLF + CRLF
		cMsg += '<font size="2"> Para informações adicionais entrar em contato com:</font>' + CRLF + CRLF
		cMsg += '<font size="2">Leandro Jose Santos - (41) 3341-1946 - leandrojs@whbusinagem.com.br</font>' + CRLF
		cMsg += '<font size="2">Almirante De Carvalho (41) 3341-1992 - almirantec@whbusinagem.com.br</font>' + CRLF
		cMsg += '<font size="2">Josemar Sousa da Paz (41) 3341-1992 - josemarsp@whb.interno</font>' + CRLF+ CRLF

		cMsg += '</body></html>'
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := cTitulo
	oMail:cTo      := cEmail

	oMail:Envia()
Return