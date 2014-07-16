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

	fGAproMP()

// Exclui
ELSEif paramixb[4]

	SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL                                                                                                                         
   	if SZU->(DbSeek(xFilial("SZU")+ CA120NUM ))

   		while SZU->(!EOF()) .AND. SZU->ZU_NUMPED==CA120NUM
   		
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
	   _cEmail := 'mauriciofo@whbbrasil.com.br;edenilsonas@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'+Alltrim(SY1->Y1_EMAIL)
	   //_cEmail := 'edenilsonas@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'+Alltrim(SY1->Y1_EMAIL)
	Else
	   _cEmail := 'mauriciofo@whbbrasil.com.br;edenilsonas@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'
	   //_cEmail := 'edenilsonas@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'
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
	TEXTO += 'Abaixo os Campos que foram alterados' + chr(13)+chr(10)		
	TEXTO += '------------------------------------------------------------------------------------------------------'+chr(13)+chr(10)
	DBSelectArea("SC7")
     
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
                 TEXTO += 'Condicao de Pgto = '+ TMP->C7_COND + '          '+'     Alterado para = '+ CCONDICAO + chr(13)+chr(10)              
              //   fGeraAp() //Gera pendencia de aprovacao no pedido fechado somente na alteracão            		                 
               //  e_email := .T.
			Endif
           
			TEXTO += chr(13)+chr(10)                            
		
		Endif
 
		For _x:=1 to len(aHeader)
  		    _cAux := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == Alltrim(aHeader[_x][2])})
  		    _cSCY := "TMP->"+Alltrim(aHeader[_x][2])

			If Alltrim(aHeader[_x][2])$"C7_QUANT/C7_PRECO" // somente verifica os campos quant e preco
  		        If Acols[lin_][_cAux] <> &_cSCY              
  		          //  e_email := .T.
            		TEXTO += 'Item = '+ Acols[lin_][_cItem] + '    Campo '+Alltrim(aHeader[_x][1])+ ' = '+Iif(Valtype( &_cSCY)=='N',Transform( &_cSCY,"@E 999,999,999.99"),Iif(Valtype( &_cSCY)=='D',Dtoc( &_cSCY), &_cSCY))+'           Alterado para = '+ Iif(Valtype(Acols[lin_][_cAux])=='N',Transform(Acols[lin_][_cAux],"@E 999,999,999.99"),Iif(Valtype(Acols[lin_][_cAux])=='D',Dtoc(Acols[lin_][_cAux]),Acols[lin_][_cAux]))+ chr(13)+chr(10)
                //	fGeraAp() //Gera pendencia de aprovacao no pedido fechado somente na alteracão            		
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
		oMail:cAssunto := 'PEDIDO DE COMPRA '+ CA120NUM + ' ALTERADO '
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

for _nlin := 1 to len(Acols)
	
	SB1->(DbSeek(xFilial("SB1")+Alltrim(ACols[_nlin][_cProd]) )) // Faz uma pesquisa na tabela de produtos e verifica se o produto tem que passar pro aprovação "S" ou "N"
	
	If SB1->B1_APROVA$"S"    //Verifica se o produto tem que passar aprovacao
		
		/* Monta a query ( SD1- Itens NF de Entrada + SF4- Tipo de Entrada e Saída)pegando como base para aprovação o ultimo custo para validação do preço e gerando ou não aprovação pedido*/
		cQuery := "SELECT TOP 1 SD1.D1_TOTAL/SD1.D1_QUANT as CUSTO FROM " + RetSqlName( 'SD1' ) +" SD1 (NOLOCK) "
		cQuery += "inner join "+ RetSqlName( 'SF4' ) +" SF4 (NOLOCK) "
		cQuery += "on SF4.F4_CODIGO   = SD1.D1_TES "
		cQuery += "and SF4.F4_ESTOQUE = 'S' "
		cQuery += "and SF4.F4_DUPLIC = 'S' "
		cQuery += "and SF4.D_E_L_E_T_ = ' ' "
		cQuery += "where "
		cQuery += " SD1.D1_COD = '" + SB1->B1_COD + "' "
		cQuery += "     and SD1.D1_DTDIGIT <='"+dtos(DA120EMIS)+"'"
		cQuery += "     and SD1.D1_ORIGLAN != 'LF' "
		cQuery += "     and SD1.D1_QUANT   != 0 "
		cQuery += "     and SD1.D1_REMITO   = '         ' "
		cQuery += "     and SD1.D_E_L_E_T_  = ' ' "
		cQuery += "     order by SD1.D1_DTDIGIT DESC,D1_NUMSEQ DESC"
		
		TCQUERY cQuery NEW ALIAS "TMPE"
		
		/*
		Verifica se o ultimo custo é maior que 0
		*/
		If round(TMPE->CUSTO,2) > 0
			
			/*
			Neste ponto é verificado se o preço unitario do custo atual é maior que o ultimo custo
			*/
			If round(ACols[_nlin][_nPreco],2) > round(TMPE->CUSTO,2) //gera pendencia de aprovação para Mauricio/Roderjan
				
				/*
				Verifica se já existe aprovação de pedido.
				*/
				If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem] + "1")) // Pesquisa o Nivel (1: Mauricio)
					
					/*
					Caso não exista aprovação de pedido C78 -> criar pendencia
					*/
					If SZU->ZU_ORIGEM <> 'C78'
						
						RecLock("SZU",.T.)
						SZU->ZU_FILIAL := xFilial("SZU")
						SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
						SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
						SZU->ZU_NUMPED := CA120NUM
						SZU->ZU_ITEMPED:= Acols[_nlin][_cItem]
						SZU->ZU_LOGIN  := "MAURICIOFO"
						SZU->ZU_NIVEL  := "1"
						SZU->ZU_ORIGEM := "C78"
						MsUnlock("SZU")
						
						lEmail := .t.
						
						/*
						Caso exista aprovação de pedido C78-> Fazer consistências abaixo antes de altera-la
						*/
					Elseif SZU->ZU_ORIGEM == 'C78'
						
						/*
						Nesse ponto é feito um dbseek na SC7-Pedido de Compras em busca do pedido para posteriormente comparar o valor do item no pedido
						com com a alteração do mesmo no do array(preço atual) ponto atual.
						*/
						SC7->(dbsetorder(1))
						If SC7->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem]))	//FILIAL+PEDIDO+ITEM+SEQUENCIA
							
							/*
							Se encontrado na SC7 ele faz uma verificação na SZU: Aprovação de Pedido para ver se o item ja está aprovado
							*/
							IF SZU->ZU_STATUS == 'A' .and. .not. empty(SZU->ZU_DATAPR) .and. .not. empty(SZU->ZU_HORAPR)
								
								/*
								Caso o item ja esteja aprovado ele faz a seguinte consistência, verifica se o valor aumentou em relalção a ultima digitação
								do pedido antes de gravar , e se foi alterado aumentando o custo ele retorna .T. e remove a aprovação ja feita deixando   o
								item pendente de aprovação novamente para Mauricio.
								*/
								If (Acols[_nlin][7] > SC7->C7_PRECO)
									
									//-- remove aprovação já feita
									Reclock("SZU",.F.)
									SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
									SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
									SZU->ZU_STATUS := ''
									SZU->ZU_DATAPR := CTOD('  /  /  ')
									SZU->ZU_HORAPR := ''
									MsUnlock('SZU')
									
								Endif
								
								lEmail := .t.
								
							Endif
							
						Endif
						
					Endif
					
				Else
					
					/*
					Caso não exista aprovação de pedido para este item nivel 1: Mauricio->Gerar aprovação de pedido C78 em SZU.
					*/
					RecLock("SZU",.T.)
					SZU->ZU_FILIAL := xFilial("SZU")
					SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
					SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
					SZU->ZU_NUMPED := CA120NUM
					SZU->ZU_ITEMPED:= Acols[_nlin][_cItem]
					SZU->ZU_LOGIN  := "MAURICIOFO"
					SZU->ZU_NIVEL  := "1"
					SZU->ZU_ORIGEM := "C78"
					MsUnlock("SZU")
					
					lEmail := .t.
					
				Endif
				
				/*
				A condição abaixo verifica se grupo do produto nao pertence a nenhum dos grupos listados abaixo, caso não pertença gera aprovação de pedido C78
				na SC7 Nivel:2 Roderjan.
				*/
				If !Subs(Acols[_nlin][_cProd],1,2)$"FE/MM/MX/MQ/MG/MS"
					
					If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem] + "2")) // Pesquisa o Nivel 2: Roderjan
						
						/*
						Caso não exista aprovação de pedido C78 -> criar pendencia
						*/
						IF SZU->ZU_ORIGEM <> 'C78'
							
							RecLock("SZU",.T.)
							SZU->ZU_FILIAL := xFilial("SZU")
							SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
							SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
							SZU->ZU_NUMPED := CA120NUM
							SZU->ZU_ITEMPED:= Acols[_nlin][_cItem]
							SZU->ZU_LOGIN  := "RODERJAN"
							SZU->ZU_NIVEL  := "2"
							SZU->ZU_ORIGEM := "C78"
							MsUnlock("SZU")
							
							lEmail := .t.
							
							/*
							Caso exista aprovação de pedido C78-> Fazer consistências abaixo antes de altera-la
							*/
						Elseif SZU->ZU_ORIGEM == 'C78'
							
							/*
							Nesse ponto é feito um dbseek na SC7-Pedido de Compras em busca do pedido para posteriormente comparar o valor do item no pedido
							com com a alteração do mesmo no do array(preço atual) ponto atual.
							*/
							SC7->(dbsetorder(1))
							If SC7->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem]))	//FILIAL+PEDIDO+ITEM+SEQUENCIA
								
								/*
								Se encontrado na SC7 ele faz uma verificação na SZU: Aprovação de Pedido para ver se o item ja está aprovado
								*/
								IF SZU->ZU_STATUS == 'A' .and. .not. empty(SZU->ZU_DATAPR) .and. .not. empty(SZU->ZU_HORAPR)
									
									/*
									Caso o item ja esteja aprovado ele faz a seguinte consistência, verifica se o valor aumentou em relalção a ultima digitação
									do pedido antes de gravar , e se foi alterado aumentando o custo ele retorna .T. e remove a aprovação ja feita deixando   o
									item pendente de aprovação novamente para Mauricio.
									*/
									
									If (Acols[_nlin][7] > SC7->C7_PRECO)
										
										//-- remove aprovação já feita
										Reclock("SZU",.F.)
										SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
										SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
										SZU->ZU_STATUS := ''
										SZU->ZU_DATAPR := CTOD('  /  /  ')
										SZU->ZU_HORAPR := ''
										MsUnlock('SZU')
										
									Endif
									
									lEmail := .t.
									
								Endif
								
							Endif
							
						Endif
						
					Else
						
						/*
						Caso não exista aprovação de pedido para este item nivel 2: Roderjan->Gerar aprovação de pedido C78 em SZU.
						*/
						RecLock("SZU",.T.)
						SZU->ZU_FILIAL := xFilial("SZU")
						SZU->ZU_NUM    := Acols[_nlin][_nNuSc]
						SZU->ZU_ITEM   := Acols[_nlin][_nitSc]
						SZU->ZU_NUMPED := CA120NUM
						SZU->ZU_ITEMPED:= Acols[_nlin][_cItem]
						SZU->ZU_LOGIN  := "RODERJAN"
						SZU->ZU_NIVEL  := "2"
						SZU->ZU_ORIGEM := "C78"
						MsUnlock("SZU")
						
						lEmail := .t.
						
					Endif
					
				Endif
				
			Else
			
				/*
				Se na alteração o valor da compra atual for menor que o valor da ultima nf de entrada e se existia aprovação para o pedido alterado apaga.
				*/
				If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem] + "1")) // Pesquisa o Nivel 1:Mauricio
					
					If SZU->ZU_ORIGEM == 'C78'
						
						RecLock("SZU",.F.)
						SZu->(DbDelete())
						MsUnlock("SZU")
						
					Endif
					
				Endif
				
				If SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[_nlin][_cItem] + "2")) // Pesquisa o Nivel 2:Roderjan
					
					If SZU->ZU_ORIGEM == 'C78'
						
						RecLock("SZU",.F.)
						SZu->(DbDelete())
						MsUnlock("SZU")
						
					Endif
					
				Endif
				
			Endif
			
		Endif
		
		TMPE->(DBCLOSEAREA())
		
	Endif
	
Next _nLin

if lEmail
	
	/*
	SY1->(DbSetOrder(3))
	If SY1->(DbSeek(xFilial("SY1")+UPPER(SC7->C7_USER)))
	_cNomeUser := AllTrim(SY1->Y1_NOME)
	Else
	_cNomeUser := ''
	Endif
	*/
	
	oMail2          := Email():New()
	oMail2:cMsg     := 'Verificar pendência de aprovação: Pedido de Compras '+CA120NUM+' <BR>Comprador: '+alltrim(cUsername)+'<br><br>Alteração de preço de MP<br><br><a href="http://portal.whbbrasil.com.br/?p=com005&op=pendencias&fil='+SM0->M0_CODIGO+'0'+SM0->M0_CODFIL+'">Clique aqui para aprovar</a>'
	//oMail2:cMsg     := 'Verificar pendência de aprovação: Pedido de Compras '+CA120NUM+' <BR>Comprador: '+_cNomeUser+'<br><br>Alteração de preço de MP<br><br><a href="http://portal.whbbrasil.com.br/?p=com005&op=pendencias&fil='+SM0->M0_CODIGO+'0'+SM0->M0_CODFIL+'">Clique aqui para aprovar</a>'
	oMail2:cAssunto := '*** PEDIDO DE COMPRA - MP - ALTERAÇÃO DE PRECO ***'
	oMail2:cTo      := 'mauriciofo@whbbrasil.com.br;edenilsonas@whbbrasil.com.br;joaofr@whbbrasil.com.br;alexandrerb@whbbrasil.com.br'
	//oMail2:cTo      := 'alexandrerb@whbbrasil.com.br;edenilsonas@whbbrasil.com.br'
	oMail2:Envia()
	
endif

Return(.T.)



Static Function fGeraAp()

// Tabela de validação de Usuarios, Grupos e Local Padrão
ZAA->(Dbgotop()) // Tabela de validação de Usuarios, Grupos e Local Padrão

ZAA->(DbSetOrder(1))
SZU->(DbSetOrder(4))//ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL                                                                                                                         

While !ZAA->(Eof())
				// Aprovacao  ZAA_GERA
				// 1 = solicitacao de compras
				// 2 = pedido em aberto
				// 3 = autorizacao de entrega
				// 4 = pedido fechado (alteracao)

   If ZAA->ZAA_GERA == "4" // gera aprovaçao para pedido de compra alteracao

      SZU->(DbSeek(xFilial("SZU")+ CA120NUM + Acols[lin_][_cItem] + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel

      If !SZU->(Found())
      	 RecLock("SZU",.T.)       
			SZU->ZU_FILIAL := xFilial("SZU")
		    SZU->ZU_NUM    := Acols[lin_][_nNuSc]
			SZU->ZU_ITEM   := Acols[lin_][_nitSc]
		    SZU->ZU_NUMPED := CA120NUM
			SZU->ZU_ITEMPED:= Acols[lin_][_cItem]
   		    SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
			SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
			SZU->ZU_ORIGEM := "C77"
		 MsUnlock("SZU")
	  Else
		 If Alltrim(SZU->ZU_LOGIN) == Alltrim(ZAA->ZAA_LOGIN)
			RecLock("SZU",.F.)
				//SZU->ZU_FILIAL := xFilial("SZU")
			    SZU->ZU_NUM    := Acols[lin_][_nNuSc]
				SZU->ZU_ITEM   := Acols[lin_][_nitSc]
			    SZU->ZU_NUMPED := CA120NUM
				SZU->ZU_ITEMPED:= Acols[lin_][_cItem]
				SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
				SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
				SZU->ZU_ORIGEM := "C77"         
				SZU->ZU_STATUS := " "
				SZU->ZU_DATAPR := Ctod("//")
				SZU->ZU_HORAPR := " "						
		 	MsUnlock("SZU")
		 Else // Grava um novo registro 

		      	 RecLock("SZU",.T.)       
				SZU->ZU_FILIAL := xFilial("SZU")
			    SZU->ZU_NUM    := Acols[lin_][_nNuSc]
				SZU->ZU_ITEM   := Acols[lin_][_nitSc]
			    SZU->ZU_NUMPED := CA120NUM
				SZU->ZU_ITEMPED:= Acols[lin_][_cItem]
	   		    SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
				SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
				SZU->ZU_ORIGEM := "C77"
			 MsUnlock("SZU")

		 Endif	

	  Endif

   Endif

   ZAA->(Dbskip())

Enddo
   
Return(.T.)
