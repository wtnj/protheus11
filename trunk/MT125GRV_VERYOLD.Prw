/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT125GRV ºAutor  ³Alexandre R. Bento  º Data ³  04/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos confirmacao da inclusao do contrato   º±±
±±º          ³de parceria p/ baixar a solicitação de compras              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "Topconn.ch"
#include "rwmake.ch"

User Function MT125GRV

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada

    //Grava campos criados no cabeçalho do pedido
	RecLock("SC3",.F.)
  	   SC3->C3_TRANSP  := _cTransp
  	   SC3->C3_DATAREV := _dDtRev
  	   SC3->C3_NUMREV  := _cNumRev
   	MsUnlock("SC3")
   	
   	//Fecha a solicitação de compras a partir do contrato
   	SC1->(dbSetOrder(1))	
   	SC1->(DbSeek(xFilial("SC1")+SC3->C3_NUMSC+SC3->C3_ITEMSC))
   	If SC1->(Found()) .AND. EMPTY(SC1->C1_GRUPCOM)
//      If (SC1->C1_QUANT - SC1->C1_QUJE) <= SC3->C3_QUANT
	  	RecLock("SC1",.F.)
		 	SC1->C1_LOGAPR := __cUserID //Codigo do usuario interno
		 	SC1->C1_QUJE   := SC3->C3_QUANT
	 	MsUnlock("SC1")
   	Endif
    
   	//-- Atualiza a quantidade das autorizações de entrega
   	SC7->(dbSetOrder(22)) //C7_FILIAL+C7_NUMSC+C7_ITEMSC
   	SC7->(dbSeek(xFilial("SC7")+SC3->C3_NUM+SC3->C3_ITEM))
   	If SC7->(Found())
   	
   		While SC7->(!Eof()) .AND. SC7->C7_NUMSC==SC3->C3_NUM .AND. SC7->C7_ITEMSC==SC3->C3_ITEM

   			If SC7->C7_QUJE < SC7->C7_QUANT .AND. SC7->C7_RESIDUO<>'S' .AND. ; //somente pedidos em aberto
   			   SC7->C7_FORNECE+SC7->C7_LOJA==SC3->C3_FORNECE+SC3->C3_LOJA .AND. ; //somente mesmo fornecedor e loja
   			   SC7->C7_TIPO==2 //somente autorizacao de entrega
   			   
		   		RecLock("SC7",.F.)
		   			SC7->C7_PRECO   := SC3->C3_PRECO
   					SC7->C7_TOTAL   := SC3->C3_TOTAL
   					SC7->C7_BASEICM := SC3->C3_TOTAL
   					SC7->C7_BASEIPI := SC3->C3_TOTAL
		   			SC7->C7_VALICM  := (SC7->C7_PICM/100) * SC3->C3_TOTAL
   					SC7->C7_VALIPI  := (SC7->C7_IPI /100) * SC3->C3_TOTAL
   				MsUnlock("SC7")
   				
   			EndIf
   		
   			SC7->(dbSkip())

   		EndDo
   		
   	EndIf
   
    // Fecha a pendencia do comprador na solicitação de compra, apos ter incluido o pedido em aberto/contrato de parceria
   	
   	SZU->(DbSetOrder(2)) //filial + num SC + item SC
   	SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUMSC+SC3->C3_ITEMSC))
   	While !SZU->(Eof()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM == SC3->C3_NUMSC+SC3->C3_ITEMSC
      	If Alltrim(SZU->ZU_LOGIN) == Alltrim(cUserName)
		 	If Empty(Alltrim(SZU->ZU_STATUS)) .And. SZU->ZU_ORIGEM$"SC1"
				RecLock("SZU",.F.)
				SZU->ZU_DATAPR := DATE()
				SZU->ZU_HORAPR := TIME()
				SZU->ZU_STATUS := "A"
				MsUnlock("SZU")
		 	Endif	
	  	Endif
	  	SZU->(DbSkip())
  	Enddo

	//--  Grava as pendencias para o pedido em aberto/contrato
    
    SZU->(DbSetOrder(3)) //filial + numero do contrato + item contrato + login + numero da revisao
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SC3->C3_PRODUTO))
	If SB1->(Found())
		// Tabela de validação de Usuarios, Grupos e Local Padrão
	   ZAA->(Dbgotop()) // Tabela de validação de Usuarios, Grupos e Local Padrão
	   While !ZAA->(Eof())
				// Aprovacao  ZAA_GERA
				// 1 = solicitacao de compras
				// 2 = pedido em aberto
				// 3 = autorizacao de entrega
				
//          If ZAA->ZAA_CONTRA $ "S" //verifica se é para gerar aprovaçao do pedido em aberto/contrato
          If ZAA->ZAA_GERA == "2" //verifica se é para gerar aprovaçao do pedido em aberto/contrato          
			 If (Substr(Alltrim(SC3->C3_CONTA),1,8) == "10104006" .AND. Substr(ZAA->ZAA_CONTA,1,8) == "10104006")
				If !Empty(ZAA->ZAA_GRUPO) // Gera pendencia para Grupo
					If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) // .AND. Upper(AllTrim(Substr(SX5->X5_DESCRI,21,2))) == Alltrim(SB1->B1_TIPO)
					   SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + ZAA->ZAA_ORDEM + SC3->C3_NUMREV))  // Pesquisa o Nivel
//					   SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + SC3->C3_NUMREV +ZAA->ZAA_ORDEM))  // Pesquisa o Nivel					   

	        	       If !SZU->(Found()) 
							RecLock("SZU",.T.)
							SZU->ZU_FILIAL := xFilial("SZU")
							SZU->ZU_NUM   := SC3->C3_NUMSC   //num solicitaçao de compra
							SZU->ZU_ITEM  := SC3->C3_ITEMSC  //item da solicitação de compra 
							SZU->ZU_NUMCT := SC3->C3_NUM     // num do pedido em aberto/contrato
							SZU->ZU_ITEMCT:= SC3->C3_ITEM    // item do pedido em aberto/contrato
							SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
							SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
							SZU->ZU_ORIGEM:= "SC3"         
							SZU->ZU_NUMREV:= SC3->C3_NUMREV  //numero da revisao
							MsUnlock("SZU")
					   Endif
					Endif
				Endif
				
			 Elseif (Substr(Alltrim(SC3->C3_CONTA),1,8) <> "10104006" .AND. Substr(ZAA->ZAA_CONTA,1,8) <> "10104006") 
			 
					If Alltrim(SB1->B1_TIPO) $ 'FC/FD'

						If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .AND. ZAA->ZAA_TIPO == Alltrim(SB1->B1_TIPO)
							SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + ZAA->ZAA_ORDEM + SC3->C3_NUMREV)) // Pesquisa o Nivel
//					        SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + SC3->C3_NUMREV +ZAA->ZAA_ORDEM))  // Pesquisa o Nivel					   							
    		   	            If !SZU->(Found()) 
								RecLock("SZU",.T.)
								SZU->ZU_FILIAL := xFilial("SZU")
								SZU->ZU_NUM   := SC3->C3_NUMSC   //num solicitaçao de compra
								SZU->ZU_ITEM  := SC3->C3_ITEMSC  //item da solicitação de compra 
								SZU->ZU_NUMCT := SC3->C3_NUM     // num do pedido em aberto/contrato
								SZU->ZU_ITEMCT:= SC3->C3_ITEM    // item do pedido em aberto/contrato
								SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
								SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
								SZU->ZU_ORIGEM:= "SC3"								
    							SZU->ZU_NUMREV:= SC3->C3_NUMREV  //numero da revisao								
								MsUnlock("SZU")   
							Endif                     
						Endif

					Else

						If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Empty(ZAA->ZAA_TIPO)
							SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + ZAA->ZAA_ORDEM + SC3->C3_NUMREV)) // Pesquisa o Nivel
//					        SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + SC3->C3_NUMREV +ZAA->ZAA_ORDEM))  // Pesquisa o Nivel					   							
	    		   	        If !SZU->(Found())
								RecLock("SZU",.T.)              
								SZU->ZU_FILIAL := xFilial("SZU")
								SZU->ZU_NUM   := SC3->C3_NUMSC   //num solicitaçao de compra
								SZU->ZU_ITEM  := SC3->C3_ITEMSC  //item da solicitação de compra 
								SZU->ZU_NUMCT := SC3->C3_NUM     // num do pedido em aberto/contrato
								SZU->ZU_ITEMCT:= SC3->C3_ITEM    // item do pedido em aberto/contrato
								SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
								SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
								SZU->ZU_ORIGEM:= "SC3"								
				     			SZU->ZU_NUMREV:= SC3->C3_NUMREV  //numero da revisao								
								MsUnlock("SZU")
							Endif
						Endif

					Endif					

			 Endif	
		  Endif	 
	      ZAA->(DbSkip())
	   Enddo

	Endif
	

Endif	

Return(.T.)