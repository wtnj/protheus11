/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT250TOK  ºAutor  ³ João Felipe da Rosaº Data ³  25/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executado na função A250TudoOk(), rotina responsavel por   º±±
±±º          ³ validar os apontamentos de produção simples                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include 'rwmake.ch'

User Function MT250TOK
Local lRet     := ParamIXB //-- Validação do Sistema
Local cQuery   := ''
Local _nDias   := GETMV("MV_DIASMO")

If SM0->M0_CODIGO$"FN/NH"
	/************* TESTE: INVENTARIO *******************/
	//Verifica se produto está bloqueado para inventário
	If !U_E205BLQ(M->D3_COD,M->D3_LOCAL)
		Return .F.
	EndIF
	/***************************************************/
EndIf

//-- FUNDICAO
If SM0->M0_CODIGO=="FN"
	
	If Alltrim(M->D3_CC)$"ALMOXARI"
		
		if Type("MsgRetWMS")=="C"
			//retorna o erro ao coletor
			MsgRetWMS := "Centro de Custo não pode ser ALMOXARI! - P.E. MT250TOK"
		else
			Alert("Centro de Custo não pode ser ALMOXARI!")
		endif
		
		lRet := .F.
	EndIf
	
	SB1->(dbSetOrder(1)) // FILIAL + COD
	SB1->(dbSeek(xFilial("SB1")+M->D3_COD))
	
	If ALLTRIM(SB1->B1_GRUPO)$"PA01" .AND. EMPTY(M->D3_DTFUNDI)
		
		if Type("MsgRetWMS")=="C"
			//retorna o erro ao coletor
			MsgRetWMS := 'Informe a Data de Fusão - P.E. MT250TOK'
		else
			Alert('Informe a Data de Fusão')
		endif
		
		Return .F.
	EndIf
	
	If SM0->M0_CODFIL=="02"                
		If substr(M->D3_LOCAL,0,1) <> "5" .AND. !Alltrim(upper(cUsername))$"ERICALP\ADMIN\JOAOFR\ALEXANDRERB\MARCOSR\HESSLERR"
			
			if Type("MsgRetWMS")=="C"
				//retorna o erro ao coletor
				MsgRetWMS :="Armazem com começo diferente de 5 não pode ser usado na filial Pernambuco ! Verifique !!! MT250TOK"
			else
				MsgBox("Armazem com começo diferente de 5 não pode ser usado na filial Pernambuco !, Verifique !!!","Atencao - MT250TOK","ALERT")
			endif
			
			Return(.F.)
		EndIf
	EndIf
	
	// Adicionado em 29/05/2014 - Douglas Dourado
	If Alltrim(D3_LOCAL)$"32/33" .AND. !Alltrim(upper(cUsername))$"ADMIN\JOAOFR\ALEXANDRERB\MARCOSR\LEANDROJS" .AND. SM0->M0_CODFIL=="01"
			
			if Type("MsgRetWMS")=="C"
				//retorna o erro ao coletor
				MsgRetWMS :="Armazém 32 / 33 não podem ser utilizados para apontamento de produção! - Dúvidas falar com o responsável por estes armazéns  - MT250TOK"
			else
				MsgBox("Armazém 32 / 33 não podem ser utilizados para apontamento de produção! - Dúvidas falar com o responsável por estes armazéns.","Atencao - MT250TOK","ALERT")
			endif
			
			Return(.F.)
	EndIf
	
	//-- USINAGEM
ElseIf SM0->M0_CODIGO=="NH"
	
	If Alltrim(M->D3_CC)$"ALMOXI"
		
		if Type("MsgRetWMS")=="C"
			//retorna o erro ao coletor
			MsgRetWMS :="Centro de Custo não pode ser ALMOXI! - MT250TOK"
		else
			Alert("Centro de Custo não pode ser ALMOXI!")
		endif
		
		
		lRet := .F.
	EndIf
	
EndIf

If SM0->M0_CODIGO$"FN/NH"
	If M->D3_EMISSAO < (Date()- _nDias) .OR. M->D3_EMISSAO < (dDatabase - _nDias)  //Controle de data para não permitir mov. com data retroativa controle paramatro mv_diasmo = numero de dias
		
		if Type("MsgRetWMS")=="C"
			//retorna o erro ao coletor
			MsgRetWMS := "Impossivel Fazer Apontamento com Data Menor que a Permitida Depto Custo! - P.E. - MT250TOK"
		else
			MsgBox( "Impossivel Fazer Apontamento com Data Menor que a Permitida Depto Custo! - P.E. - MT250TOK", "Transferencia", "ALERT" )
		endif
		
		Return(.F.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VALIDAÇÃO EXTRA DE SALDOS           ³
	//³ MOTIVO: O SISTEMA ESTAVA PERMITINDO ³
	//³ APONTAMENTO DE PRODUCAO ONDE        ³
	//³ A MATERIA PRIMA MP04.000026 ESTAVA  ³
	//³ FICANDO NEGATIVO                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//SG1->(dbsetorder(1))//G1_FILIAL+G1_COD+G1_COMP+G1_TRT
	//SG1->(dbseek(xFilial("SG1")+M->D3_COD))
	
	
	
	//-- retirado por motivo de lentidao (joaofr 08/04/2014)
	
	/*
	aSemSaldo := {}
	aSaldo    := {}
	nSaldo    := 0
	nNeces    := 0
	
	SD4->(DBSETORDER(2))//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	SD4->(DBSEEK(XFILIAL("SD4")+M->D3_OP))
	
	WHILE !SD4->(eof()) .and. SD4->D4_FILIAL==xFilial("SD4") .AND. SD4->D4_OP==M->D3_OP
		
		If !substr(SD4->D4_COD,1,3)$'MOD' .AND. SD4->D4_QTDEORI > 0
			
			aSaldo := CalcEst(SD4->D4_COD,SD4->D4_LOCAL,dDatabase+1)
			nSaldo := aSaldo[1]
			nNeces := (SD4->D4_QTDEORI/SC2->C2_QUANT) * M->D3_QUANT
			
			//-- SALDO - QUANTIDADE A CONSUMIR NO APONTAMENTO
			If (nSaldo - nNeces) < 0
				aAdd(aSemSaldo,{SD4->D4_COD,nSaldo,nNeces})
			Endif
			
		EndIf
		
		SD4->(dbskip())
	ENDDO
	
	If Len(aSemSaldo)>0
		
		if Type("MsgRetWMS")=="C"
			MsgRetWMS :=	"Falta de Saldo de Componente(s) para apontamento da OP!     "
		else
			cMsg := "Falta de Saldo de Componente(s) para apontamento da OP!"+CHR(13)+CHR(10)+CHR(13)+CHR(10)
		endif
		
		For xS:=1 to len(aSemSaldo)
			cMsg += aSemSaldo[xS][1]+" Saldo: "+alltrim(str(aSemSaldo[xS][2]))+" Usa: "+alltrim(str(aSemSaldo[xS][3]))+" Falta: "+alltrim(str((aSemSaldo[xS][2]-aSemSaldo[xS][3])*-1))+CHR(13)+CHR(10)
		Next
		
		if Type("MsgRetWMS")=="C"
			MsgRetWMS := "Falta de Saldo - P.E. 250TOK"
		else
			MsgBox(cMsg,"Falta de Saldo","ALERT")
		endif
		
		Return .F.
	Endif
	*/
	
Endif

//-- FUNDICAO E USINAGEM
If Empty(M->D3_CC)
	
	if Type("MsgRetWMS")=="C"
		//retorna o erro ao coletor
		MsgRetWMS := "Informe o Centro de Custo! - MT250TOK"
	else
		Alert("Informe o Centro de Custo!")
	endif
	
	Return .F.
EndIf

Return lRet  //-- (.T.) Valida apontamento de produção
