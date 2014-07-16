
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIM   �Autor  �Jo�o Felipe da Rosa � Data �  23/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA CHAMADO NO FINAL DA INCLUSAO DA NF DE     ���
���          � SAIDA                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 - FATURAMENTO                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
    	
		cMsg2 := "O Usu�rio " + _cUser2 + " n�o possui e-mail cadastrado no Configurador, sendo assim, seu e-mail de confirma��o de NF foi mandando para Inform�tica"
    EndIf
    
    cMsg := '<html>'
	cMsg += '<body >'
	cMsg += cMsg2
	cMsg += '<p align = "left"><font size = 4><b>Solicita��o de Nota Fiscal Conclu�da</b></font></p><br>'
	cMsg += 'Caro(a) Sr(a) ' + _cUser2 + '<br>'
	cMsg += 'Sua solicita��o de Nota Fiscal N�: '+ _cSol +  ' gerou a Nota Fiscal N�: ' + SF2->F2_DOC +' Serie: '+SF2->F2_SERIE+' no sistema Protheus.<br>'
	cMsg += '<hr align="left" width="850" size="2" color="#696969"><br>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** Solicita��o de Nota Fiscal Conclu�da ***"
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
	
		cMsg += 'Comunicamos que a NF de Amostra N�: '+SF2->F2_DOC+' Serie: '+SF2->F2_SERIE+' foi faturada para o cliente: <BR>'
		cMsg += SF2->F2_CLIENTE+'/'+SF2->F2_LOJA+' - '+Posicione('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NOME')+'<br><br>'
		
		cMsg += '<table class="consumo" border="1" cellpadding="5">'
		cMsg += '<tr><th>C�digo</th><th>Descri��o</th><th>Quantidade</th>'
		
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

Return(.T.)

