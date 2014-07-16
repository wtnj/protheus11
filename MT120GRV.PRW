/*                                                           
+---------------------------------------------------------------------------------+
!                          FICHA TECNICA DO PROGRAMA                              !
+---------------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                                !
+------------------+--------------------------------------------------------------+
!Modulo            ! Compras                                                      !
+------------------+--------------------------------------------------------------+
!Nome              ! MT120GRV.PRW                                                 !
+------------------+--------------------------------------------------------------+
!Descricao         ! Ponto de Entrada MT120GRV na inclusão do pedido de compras   !
!                  ! Manda um email de urgente qdo a maquina esta parada.         !
+------------------+--------------------------------------------------------------+
!Autor             ! Alexandre Rodizo Bento                                       !
+------------------+--------------------------------------------------------------+
!Data de Criacao   ! 25/06/2013                                                    !
+------------------+--------------------------------------------------------------+
!   ATUALIZACOES                                                                  !
+----------------------------------------------+-----------+-----------+----------+
!   Descricao detalhada da atualizacao         !Nome do    ! Analista  !Data da   !
!                                              !Solicitante! Respons.  !Atualiz.  !
+----------------------------------------------+-----------+-----------+----------+
!                                              !MAURICIOFO !Edenilson  !05/07/2013!
!                                              !           !           !          !
+----------------------------------------------+-----------+-----------+----------+ 
*/
#include "rwmake.ch"
#include "AP5MAIL.CH"
#include "Topconn.ch"
/*
	Parametros Status de Aprovação MP: 
	A-Aprovadas
	B-Aguardando
	C-Rejeitadas
*/

User Function MT120GRV()
Local CRLF := chr(13)+chr(10)   // PULA LINHA  
Local cMSG := ""        
Local _cParado := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PARADO"})
Local _cDescri := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_DESCRI"})
Local _nQuant  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_QUANT"}) 
Local _dData   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_DATPRF"})
Local _cAux
Local _cSC7
Local _nTotSC7 := 0
Local _nTotAco := 0     
Local _cQuery
Local a_email := ""
Local _lEmailP := ""

Private _cProd   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRODUTO"})                   
Private _cItem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_ITEM"})                   
Private _nTotal  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_TOTAL"})
Private _nItSc   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_ITEMSC"})
Private _nNuSc   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_NUMSC"})
Private _nPreco  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRECO"})
Private Lin_
Private _cEmail

e_email = .F.

If  altera .or. inclui

	If nTipoped == 1 // so executa no pedido e nao na autorizacao de entrega
		fGAproMP()
	Endif

// Exclui
ELSEif paramixb[4]

	SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL                                                                                                                         
   	if SZU->(DbSeek(xFilial("SZU")+ CA120NUM ))

   		while SZU->(!EOF()) .and. xFilial("SZU") == SZU->ZU_FILIAL .and. SZU->ZU_NUMPED==CA120NUM
   		
	   		IF alltrim(SZU->ZU_ORIGEM)$"C77/C78"
   		
 		    	 RecLock("SZU",.F.)       
    		 	 	SZU->(DBDELETE())
				 MsUnlock("SZU")

			ENDIF

			SZU->(DBSKIP())
		enddo
	ENDIF

endif

If nTipoped == 2 // so executa na autorizacao de entrega
  
   For _nx=1 to len (acols)
      If SB1->(Dbseek(xFilial("SB1")+Acols[_nx][_cProd] ))
         RecLock("SB1",.F.)
	        SB1->B1_CONTRAT := "N"
	     MsUnlock("SB1")  
      Endif                 	     
   Next _nx 

Endif   

If inclui

	If SM0->M0_CODIGO == 'NH' // WHB USINAGEM                                             
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+CA120FORN+CA120LOJ))
		a_Nome := SA2->A2_NOME 
	
		TEXTO := 'Favor Receber Este Pedido Em Prioridade Alta e Encaminhar ao Setor Responsavel '+chr(13)+chr(10)
		TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
		TEXTO += ' ' +chr(13)+chr(10)
		TEXTO += 'Pedido      = ' + CA120NUM + chr(13)+chr(10)
		TEXTO += 'Fornecedor  = ' + CA120FORN+"-"+CA120LOJ + chr(13)+chr(10)
		TEXTO += 'Razao Social = ' + a_Nome + chr(13)+chr(10)
		TEXTO += "PRODUTO"+Space(10)+"DESCRICAO                             QUANTIDADE                          PREV.CHEGADA " + chr(13)+chr(10)
	
		for lin_ := 1 to len(Acols)
		  if ACols[lin_][_cParado]$"S"
	    	 e_email := .T.
			 TEXTO += Acols[lin_][_cProd] + ' --- ' + Acols[lin_][_cDescri] + ' --- ' + Str(Acols[lin_][_nQuant])
		     TEXTO += ' --- ' + Substr(Dtos(Acols[lin_][_dData]),7,2)+"/"+Substr(Dtos(Acols[lin_][_dData]),5,2)+"/"+Substr(Dtos(Acols[lin_][_dData]),1,4) +chr(13)+chr(10)
		  endif
		next

		if e_email 
			oMail          := Email():New()
			oMail:cMsg     := TEXTO
			oMail:cAssunto := 'PEDIDO DE COMPRA ***** URGENTE *****'
			oMail:cTo      := 'lista-fiscal@whbbrasil.com.br'
			oMail:Envia() 
	  	Endif
	ENDIF

	//****************************************************************************************************
	//  VERIFICACAO DE AMARRACAO PRODUTOS X FORNECEDOR NO QUALITY
	//****************************************************************************************************
    SA5->(dbSetOrder(1))
	SB1->(DBSETORDER(1))
	    
	for lin_ := 1 to len(Acols)
	  
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+CA120FORN+CA120LOJ))
		a_Nome := SA2->A2_NOME
		a_Loja := SA2->A2_LOJA
	    _produto := ACols[lin_][_cProd] 
	    
		SB1->(DbSeek(xFilial("SB1")+_produto))
	
		If SB1->B1_TIPO$"CC/CP/MP/MC"

		    If !SA5->(dbSeek(xFilial('SA5')+CA120FORN+a_Loja+_produto))
	
				cMsg := '<html>' + CRLF
				cMsg += '<head>' + CRLF
				cMsg += '<title> E X E M P L O </title>' + CRLF
				cMsg += '</head>' + CRLF
				cMsg += '<b><font size="3" face="Arial">Email enviado atraves do Protheus</font></b>' + CRLF
				cMsg += '<font size="2" face="Arial">Falta amarração PRODUTO x FORNECEDOR.</font>' + CRLF
				cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
				cMsg += '<tr>'
				cMsg += '<td width="15%">'
				cMsg += '<font size="2" face="Arial">Produto</font></td>'
				cMsg += '<td width="30%">'
				cMsg += '<font size="2" face="Arial">Descricao</font></td>'
				cMsg += '<td width="10%">'
				cMsg += '<font size="2" face="Arial">Forn/Loja</font></td>' 
				cMsg += '<td width="30%">'
				cMsg += '<font size="2" face="Arial">Razao Social</font></td>'
				cMsg += '</tr>' + CRLF
			    cMsg += '<tr>'
			    cMsg += '<td width="15%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Acols[lin_][_cProd] + '</font></td>'
			    cMsg += '<td width="30%">'
		    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + Acols[lin_][_cDescri] + '</font></td>'
			    cMsg += '<td width="10%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + CA120FORN + '-' + CA120LOJ + '</font></td>'
		    	cMsg += '<td width="30%">'
			    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + a_Nome + '</font></td>'
			    cMsg += '</tr>' + CRLF
				cMsg += '</table>'
				cMsg += '</body>' + CRLF
				cMsg += '</html>' + CRLF
	  	    	              
		 		If SM0->M0_CODIGO == 'NH' 
		 			a_email := 'leandrol@whbusinagem.com.br' 		       		      
				else
			 	    IF SB1->(DBSEEK(XFILIAL("SB1")+ALLTRIM(Acols[lin_][_cProd])))
			 	      	IF ALLTRIM(SB1->B1_TIPO)$"MP"
				 	      	a_email := 'julianoc@whbfundicao.com.br;'
				 	      	a_email += 'antoniojc@whbfundicao.com.br;'
				 	      	a_email += 'eversonco@whbfundicao.com.br;'
				 	      	a_email += 'adrianofs@whbfundicao.com.br;'
						ENDIF
					ENDIF
			  	endif
		  	
				oMail          := Email():New()
				oMail:cMsg     := cMsg
				oMail:cAssunto := '***** NAO EXISTE AMARRACAO PRODUTO X FORNECEDOR *****'
				oMail:cTo      := a_email
				
				// Adicionado em 15/07/2013 p/ evitar erro na inclusão do pedido.
				IF !EMPTY(a_email)				
					oMail:Envia() 
				ENDIF	
				
			endif
	  	endif
	next          
	
Endif	

//verifica se foi alterado o pedido de compras
If altera .And. nTipoped == 1 // so executa em pedido de compras
	SY1->(DbSetOrder(3))
	//Imprime nome do comprador
	If SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
		_cEmail := 'mauriciofo@whbbrasil.com.br;edenilsonas@whbbrasil.com.br;'+Alltrim(SY1->Y1_EMAIL)
		//_cEmail := 'edenilsonas@whbbrasil.com.br;alexandrerb@whbbrasil.com.br;'+Alltrim(SY1->Y1_EMAIL)
		//_cEmail := 'edenilsonas@whbbrasil.com.br'
	Else
		_cEmail := 'mauriciofo@whbbrasil.com.br;edenilsonas@whbbrasil.com.br'
		//_cEmail := 'edenilsonas@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'
		//_cEmail := 'edenilsonas@whbbrasil.com.br'		
	Endif
	
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+CA120FORN+CA120LOJ))
	a_Nome := SA2->A2_NOME
	
	TEXTO := 'Este Pedido foi alterado por '+ cUserName + chr(13)+chr(10)
	TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
	TEXTO += ' ' +chr(13)+chr(10)
	TEXTO += 'Pedido      = ' + CA120NUM + chr(13)+chr(10)
	TEXTO += 'Fornecedor  = ' + CA120FORN+"-"+CA120LOJ + chr(13)+chr(10)
	TEXTO += 'Razao Social = ' + a_Nome + chr(13)+chr(10)
	TEXTO += chr(13)+chr(10)
	TEXTO += 'Abaixo os Campos que foram alterados e/ou incluidos' + chr(13)+chr(10)
	TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
	DBSelectArea("SC7")
	
	cSZULog := ''
	
	for lin_ := 1 to len(Acols)
		
		cQuery := "SELECT TOP 1 * FROM " + RetSqlName( 'SC7' )
		cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7")+ "'"
		cQuery += " AND C7_NUM = '" + CA120NUM +  "'"
		cQuery += " AND C7_ITEM = '" + Acols[lin_][_cItem] +  "'"
		cQuery += " AND D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY C7_NUM ASC"
		
		TCQUERY cQuery NEW ALIAS "TMP"
		TcSetField("TMP","C7_DATPRF","D")  // Muda a data de string para date
		TcSetField("TMP","C7_EMISSAO","D")  // Muda a data de string para date
		
		_nTotSC7 += TMP->C7_TOTAL //soma o total do pedido no arquivo
		_nTotAco += Acols[lin_][_nTotal] //soma o total do pedido no acols
		
		If lin_ == 1 // verifica alteracao na cond pagto, moeda e contato
			if CCONDICAO <> TMP->C7_COND
				cSZULog := 'Condicao de Pgto = '+ TMP->C7_COND + '          '+'     Alterado para = '+ CCONDICAO
				TEXTO += cSZULog + chr(13)+chr(10)
				
				if fGeraAp(cSZULog) //Gera pendencia de aprovacao no pedido fechado somente na alteracão se tiver regra
					e_email := .T.
				endif
				
			Endif
			TEXTO += chr(13)+chr(10)
		Endif
		
		For _x:=1 to len(aHeader)
			If Alltrim(aHeader[_x][2])$"C7_QUANT/C7_PRECO/C7_PRODUTO" // somente verifica os campos quant e preco
				_cAux := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == Alltrim(aHeader[_x][2])})
				_cSCY := "TMP->"+Alltrim(aHeader[_x][2])
				
				If Acols[lin_][_cAux] <> &_cSCY
					//e_email := .T.
					If !Empty(&_cSCY) // Item alterado
						cSZULog := 'Item Alterado = '+ Acols[lin_][_cItem] + ' Campo '+Alltrim(aHeader[_x][1])+ ' = '+Iif(Valtype( &_cSCY)=='N',Transform( &_cSCY,"@E 999,999,999.99"),Iif(Valtype( &_cSCY)=='D',Dtoc( &_cSCY), &_cSCY))+'   Alterado para = '+ Iif(Valtype(Acols[lin_][_cAux])=='N',Transform(Acols[lin_][_cAux],"@E 999,999,999.99"),Iif(Valtype(Acols[lin_][_cAux])=='D',Dtoc(Acols[lin_][_cAux]),Acols[lin_][_cAux]))
					Else              // Item incluido
						cSZULog := 'Item Incluido = '+ Acols[lin_][_cItem] + ' '+Alltrim(aHeader[_x][1])+ ' = '+ Iif(Valtype(Acols[lin_][_cAux])=='N',Transform(Acols[lin_][_cAux],"@E 999,999,999.99"),Iif(Valtype(Acols[lin_][_cAux])=='D',Dtoc(Acols[lin_][_cAux]),Acols[lin_][_cAux]))
					Endif
					
					TEXTO += cSZULog + chr(13)+chr(10)
					
					if fGeraAp(cSZULog) //Gera pendencia de aprovacao no pedido fechado somente na alteracão se tiver regra
						e_email := .T.					
					endif 
				Endif
			Endif
		Next
		TMP->(DbCloseArea())
	next
	
	TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
	TEXTO += 'Total Geral do Pedido =  '+ Transform( _nTotSC7,"@E 9,999,999,999.99")+'           Alterado para = '+ Transform( _nTotAco,"@E 9,999,999,999.99") +chr(13)+chr(10)
	
	if e_email
		oMail          := Email():New()
		oMail:cMsg     := TEXTO
		oMail:cAssunto := '*** PEDIDO DE COMPRA '+ CA120NUM + ' ALTERADO ***'
		oMail:cTo      := _cEmail
		oMail:Envia()
	Endif
Endif

Return(.T.)


Static Function fGAproMP()
Local _nLin := 1
Local lEmail := .f.

SB1->(DBSETORDER(1))
SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL
SC7->(dbsetorder(1))

for _nlin := 1 to len(Acols)
	/*
	Verifica se o item está deletado no browse, caso retorne .T. verifica em se existe pendência no SZU e apaga.
	*/
	If acols[_nLin][len(aHeader)+1]
		If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem]))
			While SZU->(!Eof()) .and. xFilial("SZU") == SZU->ZU_FILIAL .and. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == CA120NUM + Acols[_nlin][_cItem]			

				RecLock("SZU",.F.)
					SZU->ZU_LOG := alltrim(SZU->ZU_LOG) + 'Exc.('+ALLTRIM(UPPER(CUSERNAME))+'-'+DTOS(date())+')0'
				MsUnlock("SZU")
				
				RecLock("SZU",.F.)
					SZu->(DbDelete())
				MsUnlock("SZU")
				
				SZU->(DbSkip())
			Enddo
		Endif
		Loop
	Endif
	
	//-- NAO CONSIDERA ITENS ATENDIDOS COMPLETAMENTE OU ELIMINADO RESIDUO
	If SC7->(DbSeek(xFilial("SC7")+ CA120NUM + Acols[_nlin][_cItem]))	//FILIAL+PEDIDO+ITEM+SEQUENCIA
		If SC7->C7_QUJE == SC7->C7_QUANT .OR. SC7->C7_RESIDUO$"S"
			Loop
		Endif
	Endif
		
	IF SB1->(DbSeek(xFilial("SB1")+Alltrim(ACols[_nlin][_cProd]) )) // Faz uma pesquisa na tabela de produtos e verifica se o produto tem que passar pro aprovação "S" ou "N"
		If SB1->B1_APROVA$"S"    //Verifica se o produto tem que passar aprovacao
			/*
			Monta a query ( SD1- Itens NF de Entrada + SF4- Tipo de Entrada e Saída)pegando como base para aprovação o ultimo VALOR para validação do preço e gerando ou não aprovação pedido
			atendendo a condição dos valores.
			*/
			cQuery := "SELECT TOP 1 SD1.D1_DOC,SD1.D1_SERIE, SD1.D1_DTDIGIT, SD1.D1_VUNIT FROM " + RetSqlName( 'SD1' ) +" SD1 (NOLOCK) "
			cQuery += "inner join "+ RetSqlName( 'SF4' ) +" SF4 (NOLOCK) "
			cQuery += "on SF4.F4_CODIGO   = SD1.D1_TES "
			/*
			cQuery += "and SF4.F4_ESTOQUE = 'S' "
			*/
			cQuery += "and SF4.F4_DUPLIC = 'S' "
			cQuery += "and SF4.D_E_L_E_T_ = ' ' "
			cQuery += "AND SF4.F4_FILIAL = SD1.D1_FILIAL "
			cQuery += "where "
			cQuery += " SD1.D1_COD = '" + SB1->B1_COD + "' "
			cQuery += "     and SD1.D1_DTDIGIT <='"+dtos(DDATABASE)+"'"
			cQuery += "     and SD1.D1_ORIGLAN != 'LF' "
			cQuery += "     and SD1.D1_QUANT   != 0 "
			cQuery += "     and SD1.D1_CF NOT LIKE '3%' "
			cQuery += "     and SD1.D1_REMITO   = '         ' "
			cQuery += "     and SD1.D_E_L_E_T_  = ' ' "
			cQuery += "     and SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
			cQuery += "     order by SD1.D1_DTDIGIT DESC,D1_NUMSEQ DESC"
			
			TCQUERY cQuery NEW ALIAS "TMPE"
			/*
			Verifica se o ultimo VALOR UNITARIO é maior que 0
			*/
			If TMPE->(!EOF()) .AND. TMPE->D1_VUNIT > 0
				/*
				Neste ponto é verificado se o preço unitario do VALOR UNIT atual é maior que o ultimo VALOR
				*/
				If ROUND(ACols[_nlin][_nPreco],4) > ROUND(TMPE->D1_VUNIT,4) //gera pendencia de aprovação para Mauricio/Roderjan
				
					aAprvdr := {'MAURICIOFO','RODERJAN'}
					
					For xA:=1 to len(aAprvdr)
					
						//Para grupos abaixo não gera aprovação para Roderjan
						If xA==2 .and. (Subs(Acols[_nlin][_cProd],1,2)$"FE/MM/MX/MQ/MG/MS/MF/MA" .or. Subs(Acols[_nlin][_cProd],1,4)$"MP06")
							LOOP
						ENDIF
					
						lExistC78 := .F.
				
						//Verifica se já existe aprovação de pedido.
						If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem] + Alltrim(Str(xA)))) // Pesquisa o Nivel (1: Mauricio, 2:Roderjan)
						
							While SZU->(!Eof()) .and. xFilial("SZU") == SZU->ZU_FILIAL .and. SZU->ZU_NUMPED+SZU->ZU_ITEMPED+SZU->ZU_NIVEL == CA120NUM + Acols[_nlin][_cItem]+Alltrim(Str(xA))
							
								//somente pendencias de aprovacao de alteração de preco mp (C78)
								If SZU->ZU_ORIGEM == 'C78'
									
									lExistC78 := .T.

									//-- verifica se o preço do pedido foi alterado para maior
									If SC7->(DbSeek(xFilial("SC7")+ CA120NUM + Acols[_nlin][_cItem]))	//FILIAL+PEDIDO+ITEM+SEQUENCIA

										//caso o preço tenha sido alterado para maior, libera para aprovar novamente.
										//Se encontrado na SC7 ele faz uma verificação na SZU: Aprovação de Pedido para ver se o item ja está aprovado
										If ACols[_nlin][_nPreco] > SC7->C7_PRECO .and.  SZU->ZU_STATUS == 'A'

											//-- remove aprovação já feita
											/*
											Reclock("SZU",.F.)
												SZU->ZU_STATUS := ''
												SZU->ZU_DATAPR := CTOD('  /  /  ')
												SZU->ZU_HORAPR := ''
												SZU->ZU_LOG    := TMPE->D1_DOC+'-'+TMPE->D1_SERIE+'-'+cValtoChar(D1_VUNIT)
											MsUnlock('SZU')
                                 			*/
                                 			
											RecLock("SZU",.F.)
												SZU->ZU_LOG := alltrim(SZU->ZU_LOG) + 'Exc.('+ALLTRIM(UPPER(CUSERNAME))+'-'+DTOS(date())+')1'
											MsUnlock("SZU")
											
											RecLock("SZU",.F.)
												SZu->(DbDelete())
											MsUnlock("SZU")
			                                 
											Reclock("SZU",.T.)
												SZU->ZU_FILIAL := xFilial("SZU")
												SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
												SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
												SZU->ZU_NUMPED := CA120NUM
												SZU->ZU_ITEMPED:= Acols[_nlin][_cItem]
												SZU->ZU_LOGIN  := aAprvdr[xA]
												SZU->ZU_NIVEL  := alltrim(str(xA))
												SZU->ZU_ORIGEM := "C78"
												SZU->ZU_LOG    := 'NF:'+alltrim(TMPE->D1_DOC)+'-'+alltrim(TMPE->D1_SERIE)+' Aprv. Ger.:'+Dtoc(DDatabase)+'-'+SubStr(Time(),1,5)+' De R$: '+AllTrim(cValtoChar(Transform( SC7->C7_PRECO, "@E 999,999,999.99" )))+' Para R$: '+AllTrim(cValtoChar(Transform( ACols[_nlin][_nPreco], "@E 999,999,999.99" )))
											MsUnlock('SZU')

											lEmail := .t.
										Endif
									Endif
								Endif
							
								SZU->(dbskip())
							Enddo
						Endif
	
						//Caso não exista pendencia de aprovação inclui
						If !lExistC78
							RecLock("SZU",.T.)
								SZU->ZU_FILIAL := xFilial("SZU")
								SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
								SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
								SZU->ZU_NUMPED := CA120NUM
								SZU->ZU_ITEMPED:= Acols[_nlin][_cItem]
								SZU->ZU_LOGIN  := aAprvdr[xA]
								SZU->ZU_NIVEL  := alltrim(str(xA))
								SZU->ZU_ORIGEM := "C78"
								SZU->ZU_LOG    := 'NF:'+alltrim(TMPE->D1_DOC)+'-'+alltrim(TMPE->D1_SERIE)+' Aprv. Ger.:'+Dtoc(DDatabase)+'-'+SubStr(Time(),1,5)+' De R$: '+AllTrim(cValtoChar(Transform( SC7->C7_PRECO, "@E 999,999,999.99" )))+' Para R$: '+AllTrim(cValtoChar(Transform( ACols[_nlin][_nPreco], "@E 999,999,999.99" )))
							MsUnlock("SZU")
							lEmail := .t.
						Endif
					Next					
				Else
					
					//Se o preço for menor que a última nf, apaga qualquer pendencia de aprovacao C78
					If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem] )) // Pesquisa o Nivel 1:Mauricio
						While SZU->(!Eof())  .and. xFilial("SZU") == SZU->ZU_FILIAL .and. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == CA120NUM + Acols[_nlin][_cItem]
							If SZU->ZU_ORIGEM == 'C78'
								RecLock("SZU",.F.)
									SZU->ZU_LOG := alltrim(SZU->ZU_LOG) + 'Exc.('+ALLTRIM(UPPER(CUSERNAME))+'-'+DTOS(date())+')2'
								MsUnlock("SZU")
								
								RecLock("SZU",.F.)
									SZu->(DbDelete())
								MsUnlock("SZU")
							Endif
							SZU->(DbSkip())
						Enddo
					Endif
				Endif
			Endif
			
			TMPE->(DBCLOSEAREA())
			
		Endif
	Endif
	
Next _nLin

if lEmail
	
	SY1->(DbSetOrder(3)) // Y1_FILIAL+Y1_USER
	SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
	oMail2          := Email():New()
	
	//oMail2:cMsg     := 'Verificar pendência de aprovação: Pedido de Compras '+CA120NUM+' <BR>Comprador: '+alltrim(cUsername)+'<br><br>Alteração de preço de MP<br><br><a href="http://portal.whbbrasil.com.br/?p=com005&op=pendencias&fil='+SM0->M0_CODIGO+'0'+SM0->M0_CODFIL+'">Clique aqui para aprovar</a>'
	oMail2:cMsg     := 'Verificar pendência de aprovação: Pedido de Compras '+CA120NUM+' <BR>Comprador: '+AllTrim(SY1->Y1_NOME)+'<br><br>Alteração de preço de MP<br><br><a href="http://portal.whbbrasil.com.br/?p=com005&op=pendencias&fil='+SM0->M0_CODIGO+'0'+SM0->M0_CODFIL+'">Clique aqui para aprovar</a>'
	oMail2:cAssunto := '*** PEDIDO DE COMPRA - MP - ALTERAÇÃO DE PRECO ***'
	oMail2:cTo      := 'mauriciofo@whbbrasil.com.br;edenilsonas@whbbrasil.com.br'
	//oMail2:cTo      := 'alexandrerb@whbbrasil.com.br;edenilsonas@whbbrasil.com.br'
	//oMail2:cTo      := 'edenilsonas@whbbrasil.com.br'	
	oMail2:Envia()
	
endif

Return(.T.)

Static Function fGeraAp(cPSZULog)

Local TemRegra:= .F.

//-- Query para trazer os aprovadores
cQuery := " SELECT * FROM "+RetSqlName("ZAA")
cQuery += " WHERE ZAA_FILIAL = '"+xFilial("ZAA")+"'"
cQuery += " AND D_E_L_E_T_ = ' '"
cQuery += " AND ZAA_GERA   = '4'"

cQuery += " AND ( "
cQuery += " (ZAA_GRUPO = '' OR ZAA_GRUPO = '"+SB1->B1_GRUPO+"') AND "
cQuery += " (ZAA_TIPO  = '' OR ZAA_TIPO  = '"+SB1->B1_TIPO+"' ) AND "
cQuery += " (ZAA_LOCAL = '' OR ZAA_LOCAL = '"+SC1->C1_LOCAL+"') AND "
cQuery += " (ZAA_CC    = '' OR ZAA_CC    = SUBSTRING('"+Alltrim(SC1->C1_CC   )+"',1,LEN(ZAA_CC   ))) AND "
cQuery += " (ZAA_CONTA = '' OR ZAA_CONTA = SUBSTRING('"+Alltrim(SC1->C1_CONTA)+"',1,LEN(ZAA_CONTA))) "
cQuery += " ) "

TCQUERY cQuery new Alias "WHBTRA"

Count To nRec

If nRec > 0
	TemRegra:= .T.
Else
	TemRegra:= .F.
	WHBTRA->(DbCloseArea())	
	Return
Endif

// Tabela de validação de Usuarios, Grupos e Local Padrão
SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL
WHBTRA->(DbGoTop())
While WHBTRA->(!eof())
	// Aprovacao ZAA_GERA
	// 1 = solicitacao de compras
	// 2 = pedido em aberto
	// 3 = autorizacao de entrega
	// 4 = pedido fechado (alteracao)
	
	//-- INCLUIDO PARA NAO GERAR DUPLICIDADE DE PENDENCIA DE APROVACAO
	//-- OS Nº: 043864, 043728, 043525
	If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[lin_][_cItem])) // Pesquisa o Nivel
					
		lExiste := .F. //flag se existe pendencia para o login corrente
				
		While SZU->(!EOF()) .and. xFilial("SZU") == SZU->ZU_FILIAL .and. SZU->ZU_NUMPED==CA120NUM .and. SZU->ZU_ITEMPED==Acols[lin_][_cItem]
				
			If SZU->ZU_ORIGEM$"C77"
				If ALLTRIM(SZU->ZU_LOGIN)==ALLTRIM(WHBTRA->ZAA_LOGIN)
					lExiste := .T.
					Exit
				Endif
			Endif
						
			SZU->(dbskip())
		Enddo
				
		If lExiste 

			RecLock("SZU",.F.)
				SZU->ZU_STATUS := " "
				SZU->ZU_DATAPR := Ctod("//")
				SZU->ZU_HORAPR := " "
				SZU->ZU_LOG    := ALLTRIM(cPSZULog)
			MsUnlock("SZU")

			WHBTRA->(dbskip())

			Loop
		Endif

	EndIf

	//-- GRAVA OS APROVADORES
	RecLock("SZU",.T.)
		SZU->ZU_FILIAL := xFilial("SZU")
		SZU->ZU_NUM    := Acols[lin_][_nNuSc]
		SZU->ZU_ITEM   := Acols[lin_][_nitSc]
		SZU->ZU_NUMPED := CA120NUM
		SZU->ZU_ITEMPED:= Acols[lin_][_cItem]
		SZU->ZU_LOGIN  := WHBTRA->ZAA_LOGIN
		SZU->ZU_NIVEL  := WHBTRA->ZAA_ORDEM
		SZU->ZU_ORIGEM := "C77"
		SZU->ZU_LOG    := ALLTRIM(cPSZULog)
	MsUnlock("SZU")
	
  	WHBTRA->(dbskip())
   	
Enddo
	
WHBTRA->(DbCloseArea())

Return TemRegra //(.T.)           