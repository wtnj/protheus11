/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MT120LOK ³ Autor ³  Alexandre R. Bento  ³ Data ³ 31/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ VALIDACAO ADICIONAL PARA ITEM PEDIDO DE COMPRAS            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Para Controle na digitacao do pedido de compras            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function MT120LOK()

Local _nCod   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRODUTO"})
Local _nConta := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_CONTA"})
Local _nCC    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_CC"})
Local _nQtde  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_QUANT"})
Local _nVlr   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRECO"})
Local _nPreOr := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRECOOR"})
Local _nNumSC := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_NUMSC"})
Local _nItemSC:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_ITEMSC"})
Local _nOS    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_NUMOS"})
Local _lRet   := .T.
Local _nQuant := 0
Local _nx
Local _nRecSC1
Local _nIndSC1
Local _nRecSB1
Local _nIndSB1
Local _cBloqAlm := "" //produtos bloqueados para ccusto ALMOXI
Local _nVlrGst := 0
Local _nTotAprv := 0

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada
	
	/**
	* Chamado 007916 do helpdesk
	*/
	If !U_NHEST165(aCols[n][_nCC],aCols[n][_nConta],aCols[n][_nCod])
		Return .F.
	EndIf
	
	//-- chamado 043129
	If Inclui
		
		SZU->(DbSetOrder(2))
		If SZU->(DbSeek(xFilial("SZU")+aCols[n][_nNumSC]+aCols[n][_nItemSC]))
			
			While SZU->(!EOF()) .AND. SZU->ZU_NUM==aCols[n][_nNumSC] .AND. SZU->ZU_ITEM==aCols[n][_nItemSC]
				
				If SZU->ZU_ORIGEM=='SC1'
					
					If SZU->ZU_STATUS == " " .and. SZU->ZU_NIVEL<'9'  //-- nivel 9 == comprador, nao aprova
						Alert("SC Nº:"+aCols[n][_nNumSC]+" Ítem: "+aCols[n][_nItemSC]+" FALTA APROVAÇÃO - Aprovador: " + Alltrim(SZU->ZU_LOGIN))
						Return .f.
					ElseIf SZU->ZU_STATUS$"C/B"
						Alert("SC Nº:"+aCols[n][_nNumSC]+" Ítem: "+aCols[n][_nItemSC]+" CANCELADO PELO APROVADOR"+Alltrim(SZU->ZU_LOGIN))
						Return .f.
					Endif
				EndIf
				
				SZU->(dbskip())
				
			ENDDO
		Endif
	EndIf
	//-- fim chamado 043129
	
	If Subs(Acols[n][_nCod],1,3)$"MOD"
		Msgbox(" O Produto Selecionado Nao Pode ser Comprado!","Usuário não autorizado","ALERT")
		_lRet   := .F.
	Endif
	
	If SM0->M0_CODIGO == "NH"
		
		_nRecSB1 := SB1->(RECNO())
		_nIndSB1 := SB1->(IndexOrd())
		SB1->(DbSeek(xFilial("SB1")+Acols[n][_nCod]))
		
		If ALLTRIM(SB1->B1_GRUPO)$"SA98"
			Msgbox("Produto Destinado a Venda e Nao pode ser Comprado!","Usuário não autorizado","ALERT")
			_lRet   := .F.
		EndIf
		
		If Subs(Acols[n][_nCC],1,1)$"5" //Usinagem cc inicando com 5
			If !SB1->B1_TIPO$"PA"
				MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
				_lRet   := .F.
			Endif
		Endif
		
		//OS: 004204
		//C.C. IMOBIL só deverá estar liberado para produtos IM15
		If AllTrim(Acols[n][_nCC])$"IMOBIL" .AND. !AllTrim(SB1->B1_GRUPO)$"IM15"
			Alert("Somente produtos do grupo IM15 podem ter pedidos feitos no C.Custo IMOBIL!")
			Return .F.
		EndIF
		
		SB1->(DbGoTo(_nRecSB1))       // Volta para o Ponto inicial
		SB1->(DbSetOrder(_nIndSB1)) // Volta para o indice anterior
		
		_cBloqAlm := "ML01.000013/"
		_cBloqAlm += "ML01.000012/"
		_cBloqAlm += "MS02.000051/"
		_cBloqAlm += "MX01.000033/" //cartões de visita
		_cBloqAlm += "FE01.000000/"
		_cBloqAlm += "MX01.000207/" //genérico
		_cBloqAlm += "MA01.000001/"
		_cBloqAlm += "MX01.000087/"
		_cBloqAlm += "MX02.000039/"
		_cBloqAlm += "MM02.003263/"
		_cBloqAlm += "MS02.000001/"
		_cBloqAlm += "MX02.000047/" //memoria
		_cBloqAlm += "MX02.000053/" //materiais aplicados
		_cBloqAlm += "MM02.003263/" // SERVIÇOS
		_cBloqAlm += "FE01.000000"
		
		If Alltrim(Acols[n][_nCC])$"ALMOXI" .AND. ALLTRIM(Acols[n][_nCod])$_cBloqAlm
			Alert("C.Custo não pode ser ALMOXI para este produto!")
			_lRet   := .F.
		EndIf
		
	ElseIf SM0->M0_CODIGO == "FN"
		
		//OS:003797
		//Bloqueia os produtos genérico e imobilizado para o C.Custo ALMOXI
		_nRecSB1 := SB1->(RECNO())
		_nIndSB1 := SB1->(IndexOrd())
		
		SB1->(dbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+Acols[n][_nCod]))
		
		If ALLTRIM(SB1->B1_GRUPO)$"SA98"
			Msgbox("Produto Destinado a Venda e Nao pode ser Comprado!","Usuário não autorizado","ALERT")
			_lRet   := .F.
		EndIf
		
		If Alltrim(Acols[n][_nCC])$"ALMOXARI"
			If AllTrim(SB1->B1_TIPO)=="IM"
				Alert("C.Custo não pode ser ALMOXARI para produtos do tipo IMOBILIZADO!")
				_lRet   := .F.
			EndIf
			
			If "GENERICO"$SB1->B1_DESC
				Alert("C.Custo não pode ser ALMOXARI para produtos GENÉRICOS!")
				_lRet   := .F.
			EndIf
		EndIf
		
		If Alltrim(Acols[n][_nCC])$"ALMOXARI" .And. SB1->B1_TIPO$"SA"
			MsgBox("Informe o Centro de Custo onde Será Efetuado o Servico, pois Servicos não Podem ser Estocados no Almoxarifado","Atencao","ALERT")
			_lRet   := .F.
			
		Endif
		
		//OS: 004204
		//C.C. IMOBIL só deverá estar liberado para produtos IM19
		If AllTrim(Acols[n][_nCC])$"IMOBILIZ" .AND. !AllTrim(SB1->B1_GRUPO)$"IM19"
			Alert("Somente produtos do grupo IM19 podem ter pedidos feitos no C.Custo IMOBILIZ!")
			Return .F.
		EndIF
		
		
		SB1->(DbGoTo(_nRecSB1))       // Volta para o Ponto inicial
		SB1->(DbSetOrder(_nIndSB1)) // Volta para o indice anterior
		
		If Subs(Acols[n][_nCC],2,1)$"5" .And. !Alltrim(Acols[n][_nCod])$"SA10.000005/SA10.000001" //fundicao cc iniciando com 4 ou 5
			_nRecSB1 := SB1->(RECNO())
			_nIndSB1 := SB1->(IndexOrd())
			SB1->(DbSeek(xFilial("SB1")+Acols[n][_nCod]))
			If !SB1->B1_TIPO$"PA/BN/FR"
				MsgBox("Este Centro de Custo não Pode ser Utilizado, Favor entrar em Contato com o Depto de Custos","Atencao","ALERT")
				_lRet   := .F.
			Endif
			SB1->(DbGoTo(_nRecSB1))       // Volta para o Ponto inicial
			SB1->(DbSetOrder(_nIndSB1)) // Volta para o indice anterior
			
		Endif
	Endif
	
	
	If nTipoped == 1 // so executa no pedido de compras
		_nRecSC1 := SC1->(RECNO())
		_nIndSC1 := SC1->(IndexOrd())
		SC1->(DbSetOrder(1)) // Filial + pedido + item
		If SC1->(DbSeek(xFilial("SC1")+Acols[n][_nNumSC]+Acols[n][_nItemSC]))
			
			If Acols[n][_nConta] <> SC1->C1_CONTA .Or. Acols[n][_nCC] <> SC1->C1_CC
				MsgBox("Atenção: A Conta Contabil ou Centro de Custo nao Podem Ser Alterados diferentes da SC!","Atencao","ALERT")
				Acols[n][_nConta] := SC1->C1_CONTA //Volta a conta da SC
				Acols[n][_nCC] := SC1->C1_CC	//Volta o CC da SC
				_lRet   := .F.
			Endif
		Endif
		SC1->(DbGoTo(_nRecSC1))       // Volta para o Ponto inicial
		SC1->(DbSetOrder(_nIndSC1)) // Volta para o indice anterior
		
	Endif
	//foi inserido a pedido do rogerio da contabilidade em 31/05/07
	If Alltrim(Acols[n][_nConta])$"103020050001" .And. Subs(Alltrim(Acols[n][_nCod]),1,2)$"MX"
		Msgbox("Para Este Produto nao Pode-se Utilizar Esta Conta de IMOBILIZADO ","Pedido de Compra","ALERT" )
		_lRet := .F.
	Endif
	
	If Subs(Alltrim(Acols[n][_nConta]),1,6)$"104020" .And.  Empty(Acols[n][_nNumSC])
		Msgbox("Para Esta Conta Contabil, Favor Selecionar uma Solicitação de Compra ","Pedido de Compra","ALERT" )
		_lRet := .F.
	Endif
	
	
	If nTipoped == 1 // so executa no pedido de compras
		If Acols[n][_nPreOr] <=0 .and. !ALLTRIM(UPPER(FunName()))$"MATA410/MATA460/MATA461/MATA460A/NHCOM063"
			Msgbox("O Preco Orçado é Obrigatório ","Pedido de Compra","ALERT" )
			_lRet := .F.
		Endif
	Endif

	/* Número Chamado: 076772/076779 - Solicitante:Cristovão Luiz Gomes */	
	If SM0->M0_CODIGO=='FN' .and. ALLTRIM(UPPER(FunName()))$"MATA122"
		//If !Alltrim(cUserName)$"ANDERSONRI/LUIZMB/IOHANSSONOD/JONATHAGS" .and. Alltrim(Acols[n][_nCC])$"23005001/ALMOXARI" //.and. !ALLTRIM(SB1->B1_COD)$"SA08.000001/SA16.000001"			
		If !Alltrim(cUserName)$"ANDERSONRI/LUIZMB/IOHANSSONOD/JONATHAGS" .and. Alltrim(Acols[n][_nCC])$"23005001" //.and. !ALLTRIM(SB1->B1_COD)$"SA08.000001/SA16.000001"		
			Alert("Para o centro de custo 23005001, somente autorizado para ANDERSONRI / LUIZMB / IOHANSSONOD / JONATHAGS ! - P.E. MT120LOK")
			_lRet:= .F.
		Endif

		If !Alltrim(cUserName)$"THIAGOL/SILVETEAC/CRISTOVAOLG/FABIORM" .and. Alltrim(Acols[n][_nCC])$"23005002"
			Alert("Para o centro de custo 23005002, somente autorizado para THIAGOL / SILVETEAC / CRISTOVAOLG / FABIORM ! -  P.E. MT120LOK")
			_lRet:= .F.
		Endif
	Endif
	
	/*
	If nTipoped == 2 // so executa na autorizacao de entrega
	_nQuant := 0
	For _nx:=1 to Len(acols)
	If !Acols[_nx][len(aHeader)+1]  //nao pega quando a linha esta deletada
	_nQuant += Acols[_nx][_nQtde]
	Endif
	Next
	If _nQuant > (SC3->C3_QUANT - SC3->C3_QUJE)
	Msgbox("A Qtde Total na A.E. é  maior que a Disponivel no Pedido em Aberto ","Autorizacao de Entrega","ALERT" )
	_lRet := .F.
	Endif
	Endif
	*/
	
	
Endif

Return(_lRet)
