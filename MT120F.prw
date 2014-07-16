/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120F ºAutor  ³João Felipe da Rosa  º Data ³  01/02/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. APOS INCLUSAO DO PEDIDO DE COMPRAS                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120F()
Local cPedido  := PARAMIXB


//-- REMOVIDO POR PEDIDO DO MAURICIO O


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL AO SOLICITANTE INFORMANDO QUE O PC FOI GERADO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aMat     := {}
Local aInfo    := {}
Local cLogAux  := ""
Local xM       := 0
Local cForn    := ""

	dBselectArea('SC7')
	dbSetOrder(1)
	dbSeek(cPedido)
	
	cForn := SC7->C7_FORNECE+'/'+SC7->C7_LOJA+' - '+Alltrim(Posicione('SA2',1,xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA,'A2_NOME'))
	     
    SC1->(dbsetorder(1)) // FILIAL + NUM + ITEM

    While SC7->(!EOF()) .AND. SC7->C7_FILIAL+SC7->C7_NUM==cPedido
    
    	IF SC7->C7_LOCAL$'41' .AND. SM0->M0_CODIGO$"FN" .AND. SM0->M0_CODFIL$"01" //-- OS:072852 (APROVADA POR MAURICIOFO)
    	
	    	IF SC1->(DBSEEK(XFILIAL('SC1')+SC7->C7_NUMSC+SC7->C7_ITEMSC))
		    	aAdd(aMat,{ALLTRIM(SC1->C1_SOLICIT),SC7->C7_NUMSC,SC7->C7_ITEMSC,SC7->C7_ITEM,SC7->C7_PRODUTO, SC7->C7_DESCRI,;
	    				   SC1->C1_QUANT, SC7->C7_QUANT,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_PRECO,SC7->C7_OBS})
    		ENDIF
    	ENDIF
    	
    	SC7->(dbskip())
    Enddo
	    	
	if len(aMat)==0
		SC7->(dbSeek(cPedido))
		return
	endif

	/*
	aMat := ASort(aMat,,, { |x, y| x[1] < y[1]})  //Ordena a matriz pelo LOGIN DO SOLICITANTE

	For xM:=1 to len(aMat) 
	
		cLogAux := aMat[xM][1]

		aInfo := U_MailLogin(aMat[xM][1])
	   	cTo   := aInfo[1]
    */
    
	    cMsg := '<html>'
		cMsg += '<body>'
		cMsg += '<p align="left"><font size = 4><b>INCLUSÃO DE PEDIDO DE COMPRA</b></font></p><br><br>'

		cMsg += 'Foi emitido no Sistema Protheus o Pedido de Compra Nº: '+Substr(cPedido,3,6)+'.<br>'
		cMsg += 'Fornecedor/Loja: '+cForn+'<BR><BR>'
		cMsg += '<table border="1"><tr BGCOLOR="#AABBCC"><th>SC</th><th>Item SC</th><th>Produto</th><th>Descrição</th><th>Qtde SC</th>'
		cMsg += '<th>Item PC</th><th>Qtde PC</th><th>V. Unit.</th><th>V.Total</th><th>Solicit.</th><th>Obs</th><th>Atendimento</th></tr>'

		nItens    := 0		
		//While xM <= Len(aMat) .and. cLogAux==aMat[xM][1]
		For xM:=1 to Len(aMat)

			cMsg += '<tr><td>'+ALLTRIM(aMat[xM][2])+'</td>' //sc
			cMsg += '<td>'+aMat[xM][3]+'</td>' //item sc
			cMsg += '<td>'+aMat[xM][5]+'</td>'     // produto
			cMsg += '<td>'+aMat[xM][6]+'</td>'     // descr
			cMsg += '<td align="right">'+ALLTRIM(Transform(aMat[xM][7]             ,"@E 9,999,999.99"))+'</td>' // quant sc
			cMsg += '<td>'+aMat[xM][4]+'</td>'     //item pc
			cMsg += '<td align="right">'+ALLTRIM(Transform(aMat[xM][8]             ,"@E 9,999,999.99"))+'</td>' // quant pc
			cMsg += '<td align="right">'+ALLTRIM(Transform(aMat[xM][11]            ,"@E 9,999,999.99"))+'</td>' // v unit
			cMsg += '<td align="right">'+Alltrim(Transform(aMat[xM][11]*aMat[xM][8],"@E 9,999,999.99"))+'</td>' // v total
			cMsg += '<td>'+aMat[xM][1]+'</td>'   //solicitante
			cMsg += '<td>'+aMat[xM][12]+'</td>'   //obs
			cMsg += '<td>'+Iif(aMat[xM][8] < aMat[xM][7],'Parcial','Total')+'</td></tr>'  //atendimento
	
			nItens++			
			//xM++
	     
	  	Next
	  	
		//Enddo
		
		//xM-- //-- senao pula um registro a mais
             
		cMsg += '</table><br><br>'
		cMsg += 'Comprador: '+UsrFullname(__cUserId )+ Iif(Empty(Subs(U_Nhcfg001("06"),6,4)),'',' - Ramal: '+Subs(U_Nhcfg001("06"),6,4)) 
		
		cMsg += '<hr align="left" width="850" size="2" color="#696969"><br>'

		oMail          := Email():New()
		oMail:cMsg     := cMsg
		oMail:cAssunto := "*** INCLUSÃO DE PEDIDO DE COMPRA ***"
		
		oMail:cTo := "edersonsf@whbfundicao.com.br;"+;
		       "angelamh@whbfundicao.com.br;"+;
		       "mariocp@whbbrasil.com.br;"		       

		If nItens > 0 //-- garantia para nao enviar e-mail sem itens
			oMail:Envia() 
		Endif     

	//Next
	
	SC7->(dbSeek(cPedido))

Return