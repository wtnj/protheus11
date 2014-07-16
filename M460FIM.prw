
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³João Felipe da Rosa º Data ³  23/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA CHAMADO NO FINAL DA INCLUSAO DA NF DE     º±±
±±º          ³ SAIDA                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - FATURAMENTO                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()      

	//Grava o pedido do cliente na tabela SF2
	SA7->(DbSetOrder(1)) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
	SA7->(DbSeek(xFilial("SA7")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD))

	If SA7->(Found()) .AND. !Empty(SA7->A7_PCCLI)
		RecLock("SF2",.F.)
			SF2->F2_PCCLI := SA7->A7_PCCLI
		MsUnLock("SF2")
	EndIF
	fMail()
	
Return

Static Function fMail()
Local cMsg
Local cMsg2
Local _nCont
Local _nTotal
Private _cSol
Private _cUser2
Private _cMail
Private _cNumPed := SF2->F2_DOC
Private _lAmostra := .f.

SZR->(DbSetOrder(2) ) // ZR_FILIAL+ZR_PEDIDO
SZQ->(DbSetOrder(1) ) // ZQ_FILIAL+ZQ_NUM

If SZR->(DbSeek(xFilial("SZR") + Alltrim(SC5->C5_NUM)))
	SZQ->(DbSeek(xFilial("SZQ") + SZR->ZR_NUM))

	_lAmostra := SZQ->ZQ_AMOSTRA=='S'
	_cMsgNF   := SZQ->ZQ_MENS
	_cSol 	  := SZR->ZR_NUM
	_cUser2   := UsrFullName(SZQ->ZQ_USER)
	_cMail    := UsrRetMail(SZQ->ZQ_USER)
Else
	return .F.
EndIf

	If !Empty(_cMail)
    	cTo := _cMail
    	cMsg2 := ""
    Else
    	cTo := "joaofr@whbbrasil.com.br;"
    	cTo += "caiocl@whbbrasil.com.br;"
    	cTo += "josemf@whbbrasil.com.br;"
    	cTo += "douglassd@whb.interno;"
    	cTo += "guilhermedc@whb.interno;"
    	
    	
		cMsg2 := "O Usuário " + _cUser2 + " não possui e-mail cadastrado no Configurador, sendo assim, seu e-mail de confirmação de NF foi mandando para Informática"
    EndIf
    
    cMsg := '<html>'
	cMsg += '<body >'
	cMsg += cMsg2
	cMsg += '<p align = "left"><font size = 4><b>Solicitação de Nota Fiscal Concluída</b></font></p><br>'
	cMsg += 'Caro(a) Sr(a) ' + _cUser2 + '<br>'
	cMsg += 'Sua solicitação de Nota Fiscal Nº: '+ _cSol +  ' gerou a Nota Fiscal Nº: ' + SF2->F2_DOC +' Serie: '+SF2->F2_SERIE+' no sistema Protheus.<br>'
	cMsg += '<hr align="left" width="850" size="2" color="#696969"><br>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** Solicitação de Nota Fiscal Concluída ***"
	oMail:cTo      := cTo
	oMail:Envia() 
	
	//-- envia email de notificacao do faturamento da nf de amostra
	If _lAmostra
	
		cMsg := '<style type="text/css">'  
		cMsg += '.consumo{ border-collapse:collapse;  font-family:arial } '
		cMsg += '.consumo th{ background:#cccccc } '		
		cMsg += '.planta{ font-weight:bold; font-size:14px;}'
		cMsg += '</style>'              
	
		cMsg += '<h3>AVISO DE FATURAMENTO DE NF DE AMOSTRA</h3><br />'
	
		cMsg += 'Comunicamos que a NF de Amostra Nº: '+SF2->F2_DOC+' Serie: '+SF2->F2_SERIE+' foi faturada para o cliente: <BR>'
		cMsg += SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' - '+Posicione('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NOME')+'<br><br>'
		
		cMsg += '<table class="consumo" border="1" cellpadding="5">'
		cMsg += '<tr><th>Código</th><th>Descrição</th><th>Quantidade</th>'
		
		SD2->(dbsetorder(3)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		SD2->(dbseek(xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		
		While SD2->(!EOF()) .AND. SD2->D2_FILIAL==xFilial('SD2') .AND. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA==SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA 
			cMsg += '<tr>'
			cMsg += '<td align="center">'+SD2->D2_COD+'</td>'
			cMsg += '<td align="left"  >'+Posicione('SB1',1,xFilial('SB1')+SD2->D2_COD,'B1_DESC')+'</td>'
			cMsg += '<td align="right" >'+ALLTRIM(STR(SD2->D2_QUANT))+'</td>'
			cMsg += '</tr>'
			
			SD2->(dbskip())
		EndDo
		
		cMsg += '</table><br />'
		cMsg += '<br />Mensagem: '+_cMsgNF+'</br><br/>'
		cMsg += '<br />Solicitante: ' + _cUser2 + '<br />'
	             
		//-- destinatarios

		cAl := getnextalias()
		
		beginSql Alias cAl
			SELECT * FROM %Table:ZEP%
			WHERE ZEP_FILIAL = %xFilial:ZEP%
			AND %NotDel%
			AND ZEP_AREA='N'		
		endSql
		
		cToApr := ''
		
		While (cAl)->(!EOF())
		    
			//-- verifica se existe e-mail cadastrado na tabela QAA
			cMailRsp := ''
			QAA->(dbsetorder(6)) // login
			If QAA->(dbSeek((cAl)->ZEP_LOGIN))
			
				If !empty(QAA->QAA_EMAIL)
					cMailRsp := QAA->QAA_EMAIL
				Endif
			
			Endif
		
        	If empty(cMailRsp)

				PswOrder(2) // Pesquisa por usuario
				PswSeek(alltrim(upper((cAl)->ZEP_LOGIN)),.T.)
				aUser := PswRet(1)
				cMailRsp := aUser[1][14]
			
			Endif
			
			//-- guarda os e-mails dos aprovadores
			If !empty(cMailRsp)
				cToApr += ALLTRIM(cMailRsp) + ';'
			Endif
			
			(cAl)->(dbSkip())
		Enddo
		
		//-- envio		
		
		
		oMail := Email():New()
		oMail:cMsg := cMsg
		oMail:cAssunto := '*** AVISO DE FATURAMENTO DE NF DE AMOSTRA ***'  
		oMail:cTo := cToApr
	
		if !empty(oMail:cTo)
			oMail:Envia()
		endif
	
	Endif


	//-- envia e-mail de solicitação de emissão de certificado
	ZF3->(DbSetOrder(1))
	If ZF3->(DbSeek(xFilial("ZF3")+_cSol))
		cTo := 'yasserna@whbfundicao.com.br;'
		cTo += 'eliom@whbfundicao.com.br;'
		cTo += 'diegoah@whbfundicao.com.br;'
		cTo += 'josiass@whbfundicao.com.br;'
		cTo += 'uandersonn@whbfundicao.com.br;'
		cTo += 'romildoan@whbfundicao.com.br;'
		cTo += 'claudenirpp@whbfundicao.com.br;'
		cTo += 'joarezsb@whbfundicao.com.br;'
		cTo += 'eversonco@whbbrasil.com.br;'

	
		cMsg := '<style>'
		cMsg += '.cabec td{font-weight:bold;text-align:center;background-color: #CCC}'
		cMsg += '.linhas td{text-align:center;}'
		cMsg += '<style>'
		cMsg += '<table border="1" width="900"><tr class="cabec">'
		cMsg += '<td width="80%" align="center"><h1>SOLICITAÇÃO</h1></td><td width="18%"><h1>Nº '+_cSol+'</h1></td>'
		cMsg += '</tr></table>'
		cMsg += '<table width="900" border="1">'
		cMsg += '<tr class="cabec"><td align="left">CLIENTE:</td><td align="left">SOLICITANTE:</td></tr>'

		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))
		cMsg += '<tr class="linhas" style="font-weight:bold;"><td>'+ SA1->A1_NOME +'</td><td>'+ _cUser2 +'</td></tr>'
		cMsg += '</table>'
	
		cMsg += '<table width="900" border="1"><tr class="cabec"><td>PEÇA</td><td>DATA DE FUSÃO</td><td>QUANTIDADE</td><td>Nº NF</td><td>DATA (SOLICITAÇÃO)</td><td>HORA</td></tr>'
	
		_nCont := 0
		_nTotal:= 0
	
		//PESQUISA A PEÇA NA TABELA SZR DE ACORDO COM O Nº DA SOLICITAÇÃO
		SZR->(DbSetOrder(1))                                                                                 
		SB1->(DbSetOrder(1))
		SZR->(DbSeek(xFilial("SZR")+_cSol))
		While SZR->(!EOF()) .AND. SZR->ZR_NUM == _cSol
			If SB1->(DbSeek(xFilial("SB1")+SZR->ZR_PRODUTO))
			    If SB1->B1_GRUPO$"PA01" .And. SZR->ZR_TES$"572/576/602"
					cMsg += '<tr class="linhas"><td rowspan="%NUMROWS%">' + SZR->ZR_PRODUTO + '</td>'
					//PESQUISA A QUANTIDADE E A DATA DE FUSÃO DAS PEÇAS DE ACORDO COM O Nº DA SOLICITAÇÃO
					ZF3->(DbSetOrder(1))
					If ZF3->(DbSeek(xFilial("ZF3")+_cSol+SZR->ZR_ITEM))
						_nCont := 0
						While(ZF3->ZF3_NUMERO == _cSol .AND. ZF3->ZF3_ZRITEM == SZR->ZR_ITEM)
							cMsg += Iif(_nCont==0,'','<tr class="linhas">')
							cMsg += '<td>' + Iif(Empty(ZF3->ZF3_DATA),'0',ZF3->ZF3_DATA) + '</td>'
							cMsg += '<td>' + Str(ZF3->ZF3_QUANTI) + '</td>'
							cMsg += Iif(_nCont==0,'<td rowspan="%NUMROWS%">' + SF2->F2_DOC + '</td>','')
							cMsg += Iif(_nCont==0,'<td rowspan="%NUMROWS%">' + dToC(Date()) + '</td>','')
							cMsg += Iif(_nCont==0,'<td rowspan="%NUMROWS%">' + Time() + '</td>','')
							cMsg += '</tr>'
							ZF3->(DbSkip())
							_nCont++
						Enddo
						cMsg := StrTran(cMsg,'%NUMROWS%',AllTrim(Str(_nCont)))
					
					Endif
					_nTotal += SZR->ZR_QTDE
				Endif
			Endif
			SZR->(DbSkip())
		Enddo
		cMsg += '<tr class="cabec"><td colspan="6">TOTAL: '+ Str(_nTotal) +'</td></tr>'
		cMsg += '</table>'
		
		
		oMail          := Email():New()
		oMail:cMsg     := cMsg
		oMail:cAssunto := "*** Solicitação de emissão de Certificado ***"
		oMail:cTo      := cTo
		oMail:Envia()
	Endif
Return(.T.)