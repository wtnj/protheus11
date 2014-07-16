/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mt110grv  ºAutor  ³Marcos R Roquitski  º Data ³  12/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos gravacao do item da SC.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function Mt110grv()            
	//-- os: 046753, 046804

	If altera .AND. !lCopia
		//-- aprovação de SC
		SZUAltSC()
			
	Endif

	//O.S. numero 028785 autorizado pelo Roderjan
	If Alltrim(SC1->C1_PRODUTO)$"MF25.000725" 
	   Return(.T.)
	Endif
    //Fim O.S. 028785
    
	//SOLICITADO POR CRISVALDO PARA NAO GERAR APROVACAO QUANDO FOR SC AUTOMATICA REAFIACAO DE FE
	If !alltrim(Upper(funname()))$"NHCOM063"
	    //-- GERA APROVACAO DE SC
		U_NHSCTOZU()

	Endif
/*
	//Faz a alteração do status da OS quando for SC de Manutencao
//	If !Empty(SC1->C1_ORDSERV)
		If !Empty(SC1->C1_OS)
		STJ->(DbSetOrder(1)) //FILIAL + CODBEM
//		If STJ->(DbSeek(xFilial("STJ")+SC1->C1_ORDSERV))
			If STJ->(DbSeek(xFilial("STJ")+SC1->C1_OS))
			RecLock("STJ",.F.)
				STJ->TJ_STFOLUP := "AGMAT" //Muda status para Aguarda Material
		    MsUnlock("STJ")
	    EndIf
	EndIf
*/
	
Return(.T.)

User Function NHSCTOZU()
Local cQuery
Local aAprov := {} // para guardar os aprovadores e mostrar ao usuario

	If GetMv("MV_MT110G1") == "S"
        
        //-- posiciona no produto
	    SB1->(DbSetOrder(1))
	    If !SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	    	Return .f.
	    Endif

        //-- Query para trazer os aprovadores
        cQuery := " SELECT * FROM "+RetSqlName("ZAA")
        cQuery += " WHERE ZAA_FILIAL = '"+xFilial("ZAA")+"'"
        cQuery += " AND D_E_L_E_T_ = ' '"
        cQuery += " AND ZAA_GERA   = '1'"

    	cQuery += " AND ( "
    	cQuery += " (ZAA_GRUPO = '' OR ZAA_GRUPO = '"+SB1->B1_GRUPO+"') AND "
    	cQuery += " (ZAA_TIPO  = '' OR ZAA_TIPO  = '"+SB1->B1_TIPO+"' ) AND "   
    	cQuery += " (ZAA_LOCAL = '' OR ZAA_LOCAL = '"+SC1->C1_LOCAL+"') AND "  
    	cQuery += " (ZAA_CC    = '' OR ZAA_CC    = SUBSTRING('"+Alltrim(SC1->C1_CC   )+"',1,LEN(ZAA_CC   ))) AND "
    	cQuery += " (ZAA_CONTA = '' OR ZAA_CONTA = SUBSTRING('"+Alltrim(SC1->C1_CONTA)+"',1,LEN(ZAA_CONTA))) "
    	cQuery += " ) "
       
      	TCQUERY cQuery new Alias "WHBTRA"
       	
       	SZU->(DbSetOrder(2)) // ZU_FILIAL+ZU_NUM+ZU_ITEM+ZU_NIVEL
        While WHBTRA->(!eof())

			//-- OS Nº: 022646	
			//-- data : 19/09/2011
			//-- autor: João Felipe da Rosa
			//-- desc : Filtro quando estiver preenchido campo C1_NUMOS não gerar aprovação para REINALDO
			If Alltrim(WHBTRA->ZAA_LOGIN)$"REINALDO" .AND. !Empty(SC1->C1_NUMOS)
	   			WHBTRA->(dbSkip())
	   			Loop
			EndIf
			//-- Fim OS Nº: 022646     
			
			//-- OS: 069050
			If Alltrim(WHBTRA->ZAA_LOGIN)$"CLAUDIOSA" .AND. ALLTRIM(SC1->C1_PRODUTO)$"SA09.000038"
	   			WHBTRA->(dbSkip())
	   			Loop
			EndIf
			//-- FIM OS 069050			
			
			//-- INCLUIDO PARA NAO GERAR DUPLICIDADE DE PENDENCIA DE APROVACAO
			//-- OS Nº: 043864, 043728, 043525
			If SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM))
				
				lExiste := .F. //flag se existe pendencia para o login corrente
				
				While SZU->(!EOF()) .AND. SZU->ZU_NUM==SC1->C1_NUM .AND. SZU->ZU_ITEM==SC1->C1_ITEM
				
					If SZU->ZU_ORIGEM$"SC1"
						If ALLTRIM(SZU->ZU_LOGIN)==ALLTRIM(WHBTRA->ZAA_LOGIN)
							lExiste := .T.
							Exit
						Endif
					Endif
					
					SZU->(dbskip())
				Enddo
				
				If lExiste 
					WHBTRA->(dbskip())
					Loop
				Endif

			EndIf

			//-- GRAVA OS APROVADORES
			RecLock("SZU",.T.)
				SZU->ZU_FILIAL := xFilial("SZU")
				SZU->ZU_NUM    := SC1->C1_NUM
				SZU->ZU_ITEM   := SC1->C1_ITEM
				SZU->ZU_LOGIN  := WHBTRA->ZAA_LOGIN
				SZU->ZU_NIVEL  := WHBTRA->ZAA_ORDEM
				SZU->ZU_ORIGEM := "SC1"
			MsUnlock("SZU")
			 
        	WHBTRA->(dbskip())
        Enddo
        
        WHBTRA->(dbclosearea())		
    
    Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‚
//³ Quando uma SC já aprovada é alterada, sua aprovação é excluída e gerada nova pendencia de aprovação ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function SZUAltSC()
Local aAprov  := {}
Local cNumSC  := SC1->C1_NUM
Local cMsg    := ''
Local cTo     := ''   
Local cAprvdr := ''

	SZU->(dbsetorder(2))//ZU_FILIAL+ZU_NUM+ZU_ITEM+ZU_NIVEL
	
	If SZU->(dbseek(xFilial("SZU")+SC1->C1_NUM+SC1->C1_ITEM))
		
		WHILE szu->(!eof()) .and. SZU->ZU_FILIAL==xFilial("SZU") .AND. SZU->ZU_NUM==SC1->C1_NUM .AND. SZU->ZU_ITEM==SC1->C1_ITEM
		
			If ALLTRIM(SZU->ZU_ORIGEM)=='SC1'
					//-- remove aprovação já feita
					Reclock("SZU",.F.)
					SZU->(DbDelete())
					MsUnlock('SZU')
                    /*
					aAdd(aAprov,{SZU->ZU_ITEM,SZU->ZU_LOGIN,SZU->ZU_NIVEL})
	        
					if !SZU->ZU_LOGIN+CHR(13)+CHR(10)$cAprvdr //-- validacao para nao gerar informacao duplicada
						cAprvdr += SZU->ZU_LOGIN+CHR(13)+CHR(10)
					endif
					*/
			Endif
		
			SZU->(dbskip())
		Enddo
        
	Endif
	
	/*
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
		cMsg += '<p align = "left"><font size = 4><b>ALTERAÇÃO DE SC APROVADA</b></font></p><br>'
		cMsg += 'Caro(a) Sr(a) ' + aInfo[2] + '<br><br>'
		cMsg += 'A SC Nº: '+ALLTRIM(cNumSC)+' foi <u>alterada</u> no sistema Protheus após ter sido aprovada e gerou nova pendência de aprovação em seu nome.<br><br>'
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
		oMail:cAssunto := "*** ALTERAÇÃO DE SC APROVADA ***"
		oMail:cTo      := cTo
		
		If nItens > 0 //-- garantia para nao enviar e-mail sem itens
			oMail:Envia() 
		Endif
	
    Next

	If !Empty(cAprvdr)
		MsgBox("A alteração desta SC gerou pendência de aprovação para as seguintes pessoas:"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cAprvdr+CHR(13)+CHR(10)+;
			   "Não será possível imprimir a SC até que as aprovações sejam concluídas!","Aprovação","INFO")
	Endif	
    */
Return