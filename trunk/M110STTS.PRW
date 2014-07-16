/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M110STTS  ºAutor  ³João Felipe da Rosa º Data ³  17/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. APOS INCLUSAO DA SC                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE 'rwmake.ch'

User Function M110STTS()
Local cNumSC	:= Paramixb[1]
Local nOpt		:= Paramixb[2]


//-- NOPC==1 // INCLUSAO
//-- NOPC==2 // ALTERACAO
//-- NOPC==3 // EXCLUSAO 

Local aAprov := {}
Local cMsg  := ''
Local cTo   := ''

	If Inclui .or. Altera

		SC1->(dbsetorder(1))
		SZU->(DbSetOrder(2)) // ZU_FILIAL+ZU_NUM+ZU_ITEM+ZU_NIVEL
	
		If SZU->(DbSeek(xFilial("SZU")+cNumSC))
		
			While SZU->(!EOF()) .AND. SZU->ZU_NUM==cNumSC
				
				//-- ordem 9 = comprador, não envia e-mail de aprovação
				If SZU->ZU_NIVEL<'9' .AND. ALLTRIM(SZU->ZU_STATUS)==''
					aAdd(aAprov,{SZU->ZU_ITEM,SZU->ZU_LOGIN,SZU->ZU_NIVEL})
				Endif
	        
				SZU->(dbskip())
			Enddo
			
		    cMsgAprov := "" 
		    cHtmAprov := ""
		    cMsgMail  := ""
		    cTo       := ""
			    
			aAprov := ASort(aAprov,,, { |x, y| x[2]+x[1] < y[2]+y[1]})  //Ordena a matriz pelo LOGIN DO APROVADOR + ITEM DA SC
			    
		    For xA:=1 to len(aAprov)
			    
		    	aInfo := U_MailLogin(aAprov[xA][2])	
			
			   	cTo := aInfo[1]
			   	
			   	cMsgAprov += aAprov[xA][2] + CHR(13)+CHR(10)     
			   	cHtmAprov += '<tr><td>'+aAprov[xA][2]+'</td></tr>'
			   	
			    cMsg := '<html>'
				cMsg += '<body>'
				cMsg += '<p align = "left"><font size = 4><b>PENDÊNCIA DE APROVAÇÃO DE SC</b></font></p><br>'
				cMsg += 'Caro(a) Sr(a) ' + aInfo[2] + '<br><br>'
				cMsg += 'A SC Nº: '+ALLTRIM(cNumSC)+' foi incluída no sistema Protheus e gerou uma pendência de aprovação em seu nome.<br><br>'
				cMsg += '<table border="1"><tr BGCOLOR="#AABBCC"><th>Item</th><th>Produto</th><th>Descrição</th><th>Qtde</th><th>V.Unit</th><th>V.Total</th><th>C.Custo</th><th>Obs</th><th>Solicitante</th></tr>'
		
				nItens    := 0
			   	cAuxAprov := aAProv[xA][2]
			   	
		   		While xA <= Len(aAprov) .and. aAProv[xA][2]==cAuxAprov
		   		
			   		If SC1->(dbseek(xFilial('SC1')+cNumSC+aAprov[xA][1]))
						cMsg += '<tr><td>'+SC1->C1_ITEM+'</td><td>'+SC1->C1_PRODUTO+'</td><td>'+SC1->C1_DESCRI+'</td><td>'+ALLTRIM(STR(SC1->C1_QUANT))+'</td>'
						cMsg += '<td>'+ALLTRIM(STR(SC1->C1_VUNIT))+'</td><td>'+ALLTRIM(STR(SC1->C1_QUANT * SC1->C1_VUNIT))+'</td><td>'+SC1->C1_CC+'</td><td>'+SC1->C1_OBS+'</td><td>'+SC1->C1_SOLICIT+'</td></tr>'
						nItens++
					Endif
					
					xA++
					
				Enddo
				
				xA-- //-- senao pula um registro a mais
				
				cMsg += '</table><br><br>'
				cMsg += 'Para <b>aprovar / cancelar</b> esta SC favor acessar o módulo Compras, menu Atualizações => Específicos WHB => Aprovação.<br><br>'
				cMsg += 'Caso esta aprovação não deva ser gerada para seu nome, favor entrar em contato com o setor Compras para regularizar o cadastro de Aprovadores.<br><br>'
				cMsg += 'Obs.: A SC não poderá ser impressa enquanto não for aprovada eletronicamente.<br>'
				cMsg += '<hr align="left" width="850" size="2" color="#696969"><br>'
					
				oMail          := Email():New()
				oMail:cMsg     := cMsg
				oMail:cAssunto := "*** PENDÊNCIA DE APROVAÇÃO DE SC ***"
				oMail:cTo      := cTo
				
				If !empty(cTo) .and. nItens > 0 //-- garantia para nao enviar e-mail sem itens
					oMail:Envia() 
				Endif
			
		    Next
			    
		   	If Len(aAprov) > 0
			   	
			   	aInfo := U_MailLogin(upper(alltrim(cUserName)))	
			
			   	cTo := aInfo[1]
				
			    cMsg := '<html>'
				cMsg += '<body >'
				cMsg += '<p align = "left"><font size = 4><b>INCLUSÃO DE SC</b></font></p><br>'
				cMsg += 'Caro(a) Sr(a) ' + aInfo[2] + '<br><br>'
				
				cMsg += 'A SC Nº: '+ALLTRIM(cNumSC)+'<br>'
				cMsg += '<table border="1"><tr BGCOLOR="#AABBCC"><th>Item</th><th>Produto</th><th>Descrição</th><th>Qtde</th><th>V.Unit</th><th>V.Total</th><th>C.Custo</th><th>Obs</th></tr>'
	
				nItens := 0
				If SC1->(dbseek(xFilial('SC1')+cNumSC))
					While SC1->(!EOF()) .AND. SC1->C1_NUM==cNumSC
					
						cMsg += '<tr><td>'+SC1->C1_ITEM+'</td><td>'+SC1->C1_PRODUTO+'</td><td>'+SC1->C1_DESCRI+'</td><td>'+ALLTRIM(STR(SC1->C1_QUANT))+'</td>'
						cMsg += '<td>'+ALLTRIM(STR(SC1->C1_VUNIT))+'</td><td>'+ALLTRIM(STR(SC1->C1_QUANT * SC1->C1_VUNIT))+'</td><td>'+SC1->C1_CC+'</td><td>'+SC1->C1_OBS+'</td></tr>'
						nItens++
	
						SC1->(dbskip())
					EndDo
				Endif
	
				cMsg += '</table><br>'
				cMsg += 'Foi incluída no sistema Protheus e gerou uma pendência de aprovação para as seguintes pessoas:<br><br>'
				cMsg += '<table border="1">'
				cMsg += '<tr bgcolor="#aabbcc"><th>Aprovador</th></tr>'
				cMsg += cHtmAprov
				cMsg += '</table><br>'
					  
				cMsg += 'Obs.: A SC não poderá ser impressa enquanto não for aprovada eletronicamente.<br>'
				cMsg += '<hr align="left" width="850" size="2" color="#696969"><br><BR>'
			
				oMail          := Email():New()
				oMail:cMsg     := cMsg
				oMail:cAssunto := "*** INCLUSÃO DE SC ***"
				oMail:cTo      := cTo
				
				If !EMPTY(cTo) .and. nItens > 0 //-- garantia para nao enviar e-mail sem itens
					oMail:Envia() 
				Endif     
				
			Endif
				    
		    If !Empty(cMsgAprov)
				MsgBox("Sua SC gerou pendência de aprovação para as seguintes pessoas:"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cMsgAprov+CHR(13)+CHR(10)+;
					   "Não será possível imprimir a SC até que as aprovações sejam concluídas!","Aprovação","INFO")
			Endif
		
		Endif
	Endif	
	
	//-- RETORNA POSICIONAMENTO DO BROWSE
	SC1->(dbseek(xFilial('SC1')+cNumSC))
	
Return

User Function mailLogin(cLogin)
Local cMail := ""
Local cNome := "" 
Local aUser := {}

	//-- verifica se existe e-mail cadastrado na tabela QAA
	QAA->(dbsetorder(6)) // login
	If QAA->(dbSeek(cLogin))	
	
		If !empty(QAA->QAA_EMAIL)
			cMail := QAA->QAA_EMAIL
			cNome := QAA->QAA_NOME
		Endif

	Endif

   	If Empty(cMail)
	
		PswOrder(2) // Pesquisa por usuario
		PswSeek(alltrim(upper(cLogin)),.T.)
		aUser := PswRet(1)
		cMail := aUser[1][14]
		cNome := aUser[1][4]

	Endif
	
	//-- guarda os e-mails dos aprovadores
	If empty(cMail)

    	cTo := "joaofr@whbbrasil.com.br;"
    	cTo += "douglassd@whbbrasil.com.br"
    	
	    cMsg := '<html>'
		cMsg += '<body >'
		cMsg += "O Usuário " + cLogin + " não possui e-mail cadastrado no Configurador nem na tabela QAA!"
		
		oMail          := Email():New()
		oMail:cMsg     := cMsg
		oMail:cAssunto := "*** FALTA E-MAIL DE USUARIO ***"
		oMail:cTo      := cTo
		oMail:Envia() 
			
	Endif

Return {cMail,cNome}

User Function SZVNomeado(cLogin)
Local  aNomeado := {}

	SZV->(DbSetOrder(1))//FILIAL + LOGOR
	SZV->(DbSeek(xFilial("SZV")+alltrim(cLogin)))
	While !SZV->(Eof()) .and. Alltrim(cLogin)==Alltrim(SZV->ZV_LOGOR)

		If (DATE() >= SZV->ZV_DATDE .AND. DATE() <= SZV->ZV_DATAT)
	    	aAdd(aNomeado,ALLTRIM(SZV->ZV_LOGDE))
		Endif
		
		SZV->(dbskip())	
		
	ENDDO

Return aNomeado