#include "rwmake.ch"       
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTA470C()   ºAutor  ³João Felipe      º Data ³  25/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA NA CONFIRMAÇÃO DA MOVIMENTAÇÃO DE BENS    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MNTA4701()

cTRAANT := ""
cTRADEP := "" 
	
RETURN .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PONTO DE ENTRADA CHAMADO APOS CLICAR NO BOTAO OK NA MOVIMENTACAO DE BENS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
USER FUNCTION MNTA470C()
Local _cOldAlias
Local   _lNaoFim := .F.
Private _cNewCC
Private _cNewCTrab  
Private _cBem := ST9->T9_CODBEM
Private _cSolici
Private _cItem 

	_cOldAlias := GetArea()	//Guarda o alias corrente
                  
	If ST9->T9_CENTRAB$"UTI-03/UTI-01/FAB-01/FAB-03/DISPOS"

//	If SM0->M0_CODIGO == "NH" //EMPRESA USINAGEM
		
/*
		_cSolici := TPN->TPN_SOLICI
		_cItem   := TPN->TPN_ITEM
		
		//-----------------------------------------------------------------------------------------
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ GRAVA O STATUS DA SOLICITACAO DE MOVIMENTACAO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If !EMPTY(TPN->TPN_SOLICI)
			
			ZB4->(DbSetOrder(1))//filial + num + item
			ZB4->(DBSEEK(XFILIAL("ZB4")+TPN->TPN_SOLICI+ACOLS[n][1]))
			IF ZB4->(Found())
				RecLock("ZB4",.F.)
					ZB4->ZB4_STATUS := "E"
				MsUnLock("ZB4")
			EndIf
	
			ZB4->(DbGoTop())
		            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ENCERRA O ITEM DA SOLICITACAO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	     
			ZB4->(DBSETORDER(1))
			ZB4->(DBSEEK(XFILIAL("ZB4")+TPN->TPN_SOLICI))
			WHILE ZB4->(!EOF()) .AND. ZB4->ZB4_NUM == TPN->TPN_SOLICI
				IF ZB4->ZB4_STATUS <> 'E'
					_lNaoFim := .T.
				EndIf
				
				ZB4->(DBSKIP())
			ENDDO
			
		    If !_lNaoFim
		    	ZB3->(dBSETORDER(1))
		    	ZB3->(DbSeek(xFilial('ZB3')+TPN->TPN_SOLICI))
		    	
		        RecLock('ZB3',.F.)
		        	ZB3->ZB3_STATUS := 'E'
		        MsUnlock('ZB3')
		    
		    EndIf
	
		ENDIF	
*/	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GRAVA O C.CUSTO, CTRAB E QUADRANTE PARA OS BENS FILHOS ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cBem := SUBSTR(ST9->T9_CODBEM,1,7)
		
		DbSelectArea("ST9")
		DbSetOrder(1) //T9_FILIAL+T9_CODBEM
		DbSeek(xFilial("ST9")+_cBem)
	
		_cNewCC    := ST9->T9_CCUSTO
		_cNewCTrab := ST9->T9_CENTRAB
	   
		IF UPPER(FUNNAME())$"NHMNT037"
			RecLock("ST9",.F.)
				ST9->T9_POSX := Acols[n][_nQd1]
				ST9->T9_POSY := Acols[n][_nQd2]
			MsUnlock("ST9")
		ENDIF
	
		DbSelectArea("STC")
		DbSetOrder(1) //TC_FILIAL+TC_CODBEM+TC_COMPONE+TC_TIPOEST+TC_LOCALIZ
		
		If DbSeek(xFilial("STC")+_cBem)
			//Percorre a tabela da Estrutura de Bens
			WHILE alltrim(_cBem) == alltrim(STC->TC_CODBEM)
				
	        	If ST9->(DbSeek(xFilial("ST9")+STC->TC_COMPONE))
					//Grava novo centro de custo para os bens filhos E OS QUADRANTES X E Y
	        		RecLock("ST9",.F.)
	        			ST9->T9_CCUSTO  := _cNewCC
	        			ST9->T9_CENTRAB := _cNewCTrab  
						IF UPPER(FUNNAME())$"NHMNT037"
							ST9->T9_POSX := Acols[n][_nQd1]
							ST9->T9_POSY := Acols[n][_nQd2]
						ENDIF
	        		MsUnLock("ST9")
	        	EndIf
	
	        	STC->(DBSKIP())
	
			ENDDO
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ALTERA O C.CUSTO E CENTRO DE TRABALHO DAS ORDENS DE SERVICO POSTERIORES A DATA DA MOVIMENTACAO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    DbSelectArea("STJ")
		DbGoTop() 
	    DbSetOrder(17) //TJ_FILIAL+TJ_CODBEM+TJ_SERVICO
		DbSeek(xFilial("STJ")+_cBem)

		_cOrdens := ""
		
		While STJ->(!Eof()) .AND. AllTrim(STJ->TJ_CODBEM) == _cBem
			If STJ->TJ_DTORIGI >= TPN->TPN_DTINIC .AND. STJ->TJ_HRDIGIT >= TPN->TPN_HRINIC
			    
				RecLock("STJ",.F.)
					STJ->TJ_CENTRAB := _cNewCTrab
					STJ->TJ_CCUSTO  := _cNewCC
				MsUnlock("STJ")
			
				_cOrdens += STJ->TJ_ORDEM+", "
		
			EndIf 

		
			STJ->(DbSkip())
	    EndDo                  	

	EndIf
	
	fEmailMov()

	DbSelectArea(_cOldAlias)
	
RETURN NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA EMAIL INFORMANDO DA MOVIMENTACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEmailMov()
Local cMsg     := ""
Local cTo      := ""
Local _cDesCC  := ""
Local _cDesBem := ""

	//cTo += "edinapn@whbusinagem.com.br;"
	cTo += "andersonk@whbbrasil.com.br;"
	//cTo += "jeanmr@whbusinagem.com.br;"
	cTo += "fernandow@whbbrasil.com.br;"
	//cTo += "felipest@whbbrasil.com.br;"
	cTo += "adaltoxc@whbbrasil.com.br"

	cMsg += '<table style="font-family:Arial;font-size:12px" border="1" cellpadding="0" cellspacing="0">'
	cMsg += '<colgroup style="background:#aabbcc"></colgroup>'

	ST9->(dbSetOrder(1))
	ST9->(dbSeek(xFilial("ST9")+_cBem))
	_cDesBem := ST9->T9_NOME
	cMsg += '<tr><td>Bem:</td><td>'+_cBem +' - '+_cDesBem+'</td></tr>'
	
	CTT->(dbSetOrder(1))
	CTT->(dbSeek(xFilial("ST9")+cCusBem))
	_cDesCC := CTT->CTT_DESC01                                                             
	cMsg += '<tr><td>C.Custo Origem:    </td><td>'+cCusBem+' - '+_cDesCC+'</td></tr>'

	CTT->(dbSeek(xFilial("ST9")+TPN->TPN_CCUSTO))
	_cDesCC := CTT->CTT_DESC01
	cMsg += '<tr><td>C.Custo Destino:   </td><td>'+TPN->TPN_CCUSTO+' - '+_cDesCC+'</td></tr>'
	
	cMsg += '<tr><td>C.Trabalho Origem: </td><td>'+cTRABEM+'</td></tr>'
	cMsg += '<tr><td>C.Trabalho Destino:</td><td>'+TPN->TPN_CTRAB+'</td></tr>'
	cMsg += '</table>'
	cMsg += '<hr />'

	oMail          := Email():New()
	oMail:cMsg     := cMsg
	oMail:cAssunto := "*** MOVIMENTACAO DE BEM ***"
	oMail:cTo      := cTo
	
	oMail:Envia()
		
Return