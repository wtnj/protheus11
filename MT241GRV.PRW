/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT241GRV  ºAutor  ³João Felipe da Rosa º Data ³  05/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no momento da gravação da movimentação    º±±
±±º          ³ interna Mod. 2 (MATA241)                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS 										  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT241GRV()
Local _cDoc
Local oldArea := GetArea() //-- guarda a area
Local _cHora 
Local _cTurno
         
	IF !UPPER(ALLTRIM(FUNNAME()))$"MATA241/MATA185/NHEST161/NHEST164"
		Return
	EndIf

	_cDoc    := SD3->D3_DOC //Pega o número do documento
	_cHora   := Substr(time(),1,5) //hora da baixa

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DESCOBRE QUAL TURNO OCORREU A BAIXA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _cHora >= "06:34" .AND. _cHora <= "14:51"
		_cTurno := "1"
	ElseIf _cHora > "14:51" .AND. _cHora <= "22:59"
		_cTurno := "2"
	ElseIf (_cHora > "22:59" .AND. _cHora <=   "24:00") .OR. (_cHora >= "00:00" .AND. _cHora < "06:34")
		_cTurno := "3"
	EndIf
	                       
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVA O NUMERO DO DOCUMENTO NA TABELA ZDC QUANDO FOR SOLICITACAO DE EPI ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZDC->(dbSetOrder(2)) //FILIAL + NUMSA
	If ZDC->(dbSeek(xFilial("ZDC")+SCP->CP_NUM))
		
		SRA->(dbSetOrder(1)) // FILIAL + MAT
		CTT->(dbSetOrder(1)) // FILIAL + CC
		SB1->(dbSetOrder(1)) // FILIAL + COD
		
		cMatric := ""
		
		WHILE ZDC->(!EOF()) .AND. ZDC->ZDC_NUMSA==SCP->CP_NUM
		
			If cMatric<>ZDC->ZDC_MAT
		    	_cNumero := GetSXENum("SZ7","Z7_NUMERO")
		 		cMatric  := ZDC->ZDC_MAT
		 	EndIf
		 	
		    RecLock("ZDC",.F.)
		    	ZDC->ZDC_DOC := _cDoc
			MsUnLock("ZDC")

			SRA->(dbSeek(xFilial("SRA")+ZDC->ZDC_MAT))
			CTT->(dbSeek(xFilial("CTT")+ZDC->ZDC_CC))
			SB1->(dbSeek(xFilial("SB1")+ZDC->ZDC_PROD))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ GERA A BAIXA DO EPI NA TABELA SZ7 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SZ7",.T.)
				SZ7->Z7_FILIAL  := xFilial("SZ7")
				SZ7->Z7_NUMERO  := _cNumero
				SZ7->Z7_ITEM    := Right(ZDC->ZDC_ITEM,2)
				SZ7->Z7_MATR    := ZDC->ZDC_MAT
				SZ7->Z7_NOME    := SRA->RA_NOME
				SZ7->Z7_DATA    := date()
				SZ7->Z7_CC      := ZDC->ZDC_CC
				SZ7->Z7_DESCRCC := CTT->CTT_DESC01
				SZ7->Z7_PRODUTO := ZDC->ZDC_PROD
				SZ7->Z7_DESC    := SB1->B1_DESC
				SZ7->Z7_QUANT   := 1
				SZ7->Z7_CCOLD   := ""
				SZ7->Z7_LOCAL   := SB1->B1_LOCPAD
			MsUnLock("SZ7")

			ZDC->(dbSkip())
		ENDDO
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVA A MATRICULA DO SOLICITANTE NO CAMPO D3_SOLICIT ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SD3->(DBSETORDER(2))//D3_FILIAL+D3_DOC+D3_COD
	SD3->(DBSEEK(XFILIAL("SD3")+_cDoc))

	While SD3->(!EOF()) .AND. SD3->D3_DOC == _cDoc
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³OBS.: VARIAVEL _cMat VEM DO PONTO DE ENTRADA MT241CAB ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SD3",.F.)
			If Empty(SD3->D3_SOLICIT) .and. !Empty(_cMat)
				Replace SD3->D3_SOLICIT WITH _cMat   //GRAVA A MATRICULA NO ITEM DA MOVIMENTACAO
			EndIf
			Replace SD3->D3_HORAFIM WITH _cHora  //GRAVA A HORA DA BAIXA
			Replace SD3->D3_TURNO   WITH _cTurno //GRAVA O TURNO
		MsUnLock("SD3")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE A FERRAMENTA ESTÁ SENDO REQUISITADA A MAIS DO QUE O PREVISTO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//-- chamado 026798 do Portal - adicionado cc 34001002 e 34005001  
		//-- A T E N C A O !!! Alterar também os CC's no fonte MTA105LIN
		If ALLTRIM(SD3->D3_TIPO)$'FE' .AND. ALLTRIM(SD3->D3_CC)$'34002003/34001002/34005001/34004002/34003005' // CARCAÇA GM a pedido de edsonh
			U_FE241PRV(SD3->D3_COD,SD3->D3_CC,SD3->D3_SOLICIT,.t.)
		EndIf
        
		//-- OS N 038798
		If Alltrim(SD3->D3_COD)$"MD25.000735"
			
			cMsg := "Foi efetuada baixa do ítem "+ALLTRIM(SD3->D3_COD)+" <br> "
			cMsg += " Armazém: "+ALLTRIM(SD3->D3_LOCAL)+"<br> "
			cMsg += " Quantidade: "+ALLTRIM(STR(SD3->D3_QUANT))+"<br> "
			cMsg += " Saldo Atual: "+Alltrim(Str(Posicione("SB2",1,xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL,"B2_QATU")))+"<br>"
			cMsg += " Nº Solicitação: "+SCP->CP_NUM

		    oMail := Email():New()
			oMail:cMsg := cMsg
			oMail:cAssunto := '*** ITEM BAIXADO DO ESTOQUE (INSERTO DE CASTANHAS) ***'
		   
			oMail:cTo := 'shyrleyps@whbbrasil.com.br'
			oMail:cTo += ';joaofr@whbbrasil.com.br'
			
			oMail:Envia()
		Endif				
		//-- FIM OS 038798

		SD3->(DBSKIP())

 	ENDDO
 		
	RestArea(oldArea)       
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE A FERRAMENTA ESTÁ SENDO REQUISITADA A MAIS DO QUE O PREVISTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function FE241PRV(cProd,cCC,cMat,lEmail)
Local cAl := GetNextAlias()
Local dti := StrZero(year(date()),4)+StrZero(Month(date()),2)+'01'
Local dtf := DtoS(ultimodia(StoD(dti)))
Local nPrv    := 0
Local nPrvDia := 0
Local aSemana := {}
Local xAux    := 1
Local dPrim   := StoD(dti)
Local dUlt    := CtoD('  /  /  ')
Local nDias   := 0

	//-- Este For monta um array contendo as semanas do mes, cada posicao com a data inicial e final de cada semana.
	For xD := StoD(dti) to StoD(dtf)
		
		nDias++

		//-- guarda a posicao do array que está o dia de hoje
		If xD == date()
			nAux := len(aSemana) + 1
		EndIf
		
		If Dow(xD) == 1 //se for o primeiro dia da semana
			dPrim := xD
		Endif
		
		If DoW(xD) == 7 .or. xD==StoD(dtf)// se for o ultimo dia da semana
			dUlt := xD
			aAdd(aSemana,{dPrim,dUlt,nDias})
			nDias := 0
		EndIf
		
	Next

	beginSql Alias cAl
	
		SELECT   
			ZDJ_PROD prod,
			ZDJ_FERRAM fer,
			ZDJ_OP op, 
			ZDJ_VUMONT vutil,
			quant,
			SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6) cc,
			prev = SUM(ROUND (
				CASE
					WHEN SUBSTRING(ZDJ.ZDJ_FERRAM,1,4)='FE33' THEN
						quant / ROUND((ZDJ.ZDJ_VUMONT * (ZDJ.ZDJ_QTREAF+1) * ZDJ.ZDJ_ARESTA) / ZDJ.ZDJ_FMONT ,2)
					ELSE
						quant / ROUND((ZDJ.ZDJ_VUMONT * (ZDJ.ZDJ_QTREAF+1)),2)
				END
			,2))
		
			, consumon = (
				SELECT 
					SUM(D3_QUANT)
				FROM 
					%Table:SD3% D3 (NOLOCK)
				WHERE
					D3.D_E_L_E_T_ = ' '
					AND D3.D3_COD = ZDJ.ZDJ_FERRAM	
					AND D3.D3_CC = SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6)
					AND D3.D3_EMISSAO BETWEEN %Exp:dti% and %Exp:DtoS(aSemana[nAux][2])%
					AND D3.D3_TM > 500
					AND D3.D3_ESTORNO != 'S'
			) 
			, consumor = (
				SELECT 
					SUM(D3_QUANT)
				FROM 
					%Table:SD3% D3 (NOLOCK)
				WHERE
					D3.D_E_L_E_T_ = ' '
					AND D3.D3_COD = SUBSTRING(ZDJ.ZDJ_FERRAM,1,3)+'5'+SUBSTRING(ZDJ.ZDJ_FERRAM,5,11)
					AND D3.D3_CC = SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6)
					AND D3.D3_EMISSAO BETWEEN %Exp:dti% and %Exp:DtoS(aSemana[nAux][2])%
					AND D3.D3_TM > 500
					AND D3.D3_ESTORNO != 'S'
			) 
		
		FROM
			%table:ZDJ% ZDJ (NOLOCK),
			(
				SELECT
					HC_PRODUTO prod,
					SUM(HC_QUANT) quant
				FROM
					%table:SHC% HC (NOLOCK)
				WHERE
					HC_DATA BETWEEN %Exp:dti% AND %Exp:dtf%
					AND HC.D_E_L_E_T_ = ' '
				GROUP BY HC_PRODUTO
			) QTD
		
		WHERE QTD.prod = ZDJ_PROD
			and ZDJ.D_E_L_E_T_ = ' '
			and ZDJ.ZDJ_FERRAM = %Exp:cProd%
			and ZDJ.ZDJ_CC = %Exp:cCC%
		GROUP BY  
			ZDJ_PROD,
			ZDJ_FERRAM,
			ZDJ_OP,
			ZDJ_VUMONT,
			quant,
			SUBSTRING(ZDJ_CC,1,1)+'4'+SUBSTRING(ZDJ_CC,3,6)
		ORDER BY ZDJ_PROD, ZDJ_OP
	endSql
	   
	If (cAl)->(!Eof())
		//-- previsao de consumo
		aDados   := {0,;                // 1 previsao de consumo do mes
					 0,;                // 2 previsao de consumo por dia
					 0,; 			 	// 3 previsao de consumo até o periodo
					 (cAl)->consumon,;  // 4 consumo nova
			 	     (cAl)->consumor,;  // 5 consumo reafiada
			 	     0,;                // 6 quantidade a produzir
			 	     {}}                // 7 array com as vidas uteis por operacao
		
		//-- existem casos em que um mesmo cc possui 2 peças ou mais, caso biela 1.0 e 1.4 e outros
		//-- entao temos que somar as quantidades a produzir quando a peca for diferente
		cPecaAux := ''
		
		While (cAl)->(!eof())
		
			//-- se tiver mais de uma peca no mesmo cc, soma as quantidades a produzir
			If cPecaAux<>(cAl)->prod
				aDados[6] += (cAl)->quant
				cPecaAux := (cAl)->prod
			Endif
		
			//-- alimenta o array com a vida util por op
			aAdd(aDados[7],{(cAl)->op, (cAl)->vutil, (cAl)->prod})
	
			//-- acumula a previsao de consumo por op
			aDados[1] += (cAl)->prev
			
			(cAl)->(dbskip())
		Enddo
	
		//-- divide o consumo mensal pelos dias do mes para obter a previsao de consumo por dia
		aDados[2] := aDados[1] / Day(StoD(dtf))
		//-- multiplica o consumo diário previsto pelo numero de dias do início do mes até o dia atual para obter o consumo previsto até o dia de hoje
		aDados[3] := Round(aDados[2] * Day(aSemana[nAux][2]),0)
	
	   	//-- verifica se o consumo excede o previsto até o dia de hoje, então envia e-mail
	   	If aDados[4] + aDados[5] > aDados[3]
	   		
	   		If lEmail
				fPrvMail(cProd,cCC,aDados[1],aDados[2],aDados[4],aDados[5],cMat,aSemana[nAux],aDados[7],aDados[6])
			Endif
		
			(cAl)->(dbCloseArea())

			return .t.	
	  	EndIf
	
	EndIf

	(cAl)->(dbCloseArea())
	
Return .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
//³ ENVIA E-MAIL AVISANDO DE ESTOURO DA PREVISAO DA FERRAMENTA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ                       
Static Function fPrvMail(cFer,cCC,nPrvMes,nPrvDia,nConN,nConR,cSolic,aSem,avutil,nquant)
Local cMsg := ''
Local cDtUm := '01/'+StrZero(Month(date()),2)+'/'+StrZero(Year(date()),4)

	cMsg += '<style type="text/css">'
	cMsg += '.consumo{ border-collapse:collapse;  font-family:arial } '
	cMsg += '.consumo caption{ background:#abc; border-left:1px solid #000; border-right:1px solid #000;border-top:1px solid #000; } '
	cMsg += '.consumo td{ text-align:center } '
	cMsg += '.consumo th{ text-align:left } '
	cMsg += '.total{ background:#efefef } '
	cMsg += '</style>'              

	cMsg += '<h3>AVISO DE LIMITE DE CONSUMO DE FERRAMENTA EXCEDIDO</h3><br />'

	cMsg += 'A Ferramenta <b>'+AllTrim(cFer)+'</b> excedeu o limite de consumo.<br /><br />'
	cMsg += 'Consumo Previsto do Mês: '+AllTrim(Transform(nPrvMes,"@e 9999.99"))+'<br />'
	cMsg += 'Consumo Previsto da Semana: '+AllTrim(Transform(nPrvDia * aSem[3],"@e 9999.99"))+'<br />'
	cMsg += 'Período Considerado: '+DtoC(aSem[1])+' - '+DtoC(aSem[2])+'<br />'
	cMsg += 'Consumo Previsto Diário: '+AllTrim(Transform(nPrvDia,"@e 9999.99"))+'<br />'
	cMsg += 'Consumo Previsto Até o Fim da Semana: '+AllTrim(Transform(nPrvDia * Day(aSem[2]),"@e 9999.99"))+'<br />'

	If len(avutil) > 0
		cMsg += '<br /><table border="1">'
		cMsg += '<tr bgcolor="#cccccc"><th align="center">Operação</th><th align="left">Produto</th><th align="center">Vida útil</th></tr>'

		for xVU:=1 to len(avutil)
			cMsg += '<tr><td align="center">'+avutil[xVu,1]+'</td><td>'+Posicione('SB1',1,xFilial('SB1')+avutil[xVU,3],'B1_DESC')+'</td><td align="right">'+alltrim(str(avutil[xVU,2]))+'</td></tr>'
		next
		cMsg += '</table><br />'
	Endif
	
	cMsg += 'Produção Prevista: '+alltrim(str(nquant))+'<br />'
	
	//cMsg += 'Total de Dias Considerados: '+AllTrim(Str(aSem[3]))+'<br />'
	cMsg += 'Solicitante: '+cSolic+' - '+Posicione('SRA',1,xFilial('SRA')+cSolic,'RA_NOME')+'<br />'
	cMsg += 'Centro de Custo: '+cCC+' - '+Posicione('CTT',1,xFilial('CTT')+cCC,'CTT_DESC01')+'<br /><br />
	
	cMsg += '<table class="consumo" border="1">'
	cMsg += '<caption>Consumo Real de '+cDtUm+' até '+DtoC(date())+'</caption>'
	cMsg += '<tr><th>Nova</th><td>'     + AllTrim(Str(nConN)) + '</td></tr>'
	cMsg += '<tr><th>Reafiada</th><td>' + AllTrim(Str(nConR)) + '</td></tr>'
	cMsg += '<tr class="total"><th>Total</th><td>' + AllTrim(Str(nConN+nConR)) + '</td></tr>'

	cMsg += '</table><br />'

	oMail := Email():New()
	
	oMail:cMsg := cMsg
	oMail:cAssunto := '*** LIMITE DE CONSUMO DE FERRAMENTA EXCEDIDO ('+AllTrim(cFer)+') ***'
   
	//-- chamado 32443
	oMail:cTo := 'DIOGOAN@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'PAULOHP@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'SAMUELDO@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'JEFERSONP@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'KLEBERSONO@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'ENEIASC@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'GEAZISP@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'CRISTOPHERVW@WHBBRASIL.COM.BR;'
	oMail:cTo += 'MARCELOPS@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'ADRIANOS@WHBUSINAGEM.COM.BR;'
	oMail:cTo += 'ALEXANDRETL@WHBFUNDICAO.COM.BR;'

	If Alltrim(cCC)$"34015001/34003003/34001009/34016001/34002003/34003002/34005002/34003005/34004002"

		oMail:cTo += 'AMAURIRR@WHB.INTERNO;'
		oMail:cTo += 'GELSONTF@WHBBRASIL.COM.BR;'
		oMail:cTo += 'VALDIRBJ@WHB.INTERNO;'
		oMail:cTo += 'MARCOSPR@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'IVANJM@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'GERSONRS@WHBBRASIL.COM.BR;'
		oMail:cTo += 'ENEIASJR@WHBFUNDICAO.COM.BR;'
		oMail:cTo += 'JULIOFB@WHBUSINAGEM.COM.BR;'

	ElseIf alltrim(cCC)$"34001002/34005001/34001001"
		
		oMail:cTo += 'REINALDO@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'JOSEFG@WHBBRASIL.COM.BR;'
		oMail:cTo += 'TONIR@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'JOSESN@WHBBRASIL.COM.BR;'
		oMail:cTo += 'MARCIOAF@WHBBRASIL.COM.BR;'
		oMail:cTo += 'CELSOC@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'AGUINALDOS@WHB.INTERNO;'
		oMail:cTo += 'PEDROC@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'LEANDROG@WHBUSINAGEM.COM.BR;'
		oMail:cTo += 'MARCIOM@WHBUSINAGEM.COM.BR;'	

	endif

	//-- fim chamado 32443	
	
	/*
	oMail:cTo := 'eloisp@whbbrasil.com.br;'  
	oMail:cTo += 'reinaldo@whbbrasil.com.br;'
	oMail:cTo += 'marciom@whbbrasil.com.br;'
	oMail:cTo += 'samueldo@whbbrasil.com.br;'
	oMail:cTo += 'diogoan@whbbrasil.com.br;'
	oMail:cTo += 'paulohp@whbbrasil.com.br;'
	oMail:cTo += 'marcelops@whbbrasil.com.br;'
	oMail:cTo += 'geazisp@whbbrasil.com.br;'
	oMail:cTo += 'eneiasc@whbbrasil.com.br;'
	oMail:cTo += 'jefersonp@whbbrasil.com.br;'
	oMail:cTo += 'cristophervw@whbbrasil.com.br;'
	oMail:cTo += 'crisvaldo@whbbrasil.com.br;'
	oMail:cTo += 'gersonrs@whbbrasil.com.br;'
	oMail:cTo += 'eneiasjr@whbbrasil.com.br;'
	oMail:cTo += 'juliofb@whbbrasil.com.br;'
	oMail:cTo += 'tonir@whbbrasil.com.br;'
	oMail:cTo += 'leandrog@whbbrasil.com.br;'
	oMail:cTo += 'andreof@whbbrasil.com.br;'
	*/
	                                            
	//oMail:cTo := 'joaofr@whbbrasil.com.br'	                                            
	oMail:Envia()

Return