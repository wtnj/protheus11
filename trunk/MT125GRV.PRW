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

#include "rwmake.ch"
#include "topconn.ch"

User Function MT125GRV

Local cQuery := ''

If !Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada

    //Grava campos criados no cabeçalho do pedido
	
	/*
	RecLock("SC3",.F.)
  	   SC3->C3_TRANSP  := Iif(Alltrim(Upper(Funname()))$"NHCOM061",cTransp ,_cTransp)
  	   SC3->C3_DATAREV := Iif(Alltrim(Upper(Funname()))$"NHCOM061",dDataRev,_dDtRev )
  	   SC3->C3_NUMREV  := Iif(Alltrim(Upper(Funname()))$"NHCOM061",cNumRev ,_cNumRev)
   	MsUnlock("SC3")
	*/   	
	
   	//Fecha a solicitação de compras a partir do contrato
   	SC1->(dbSetOrder(1))	
   	SC1->(DbSeek(xFilial("SC1")+SC3->C3_NUMSC+SC3->C3_ITEMSC))
   	If SC1->(Found()) .AND. EMPTY(SC1->C1_GRUPCOM)
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
   					SC7->C7_TOTAL   := SC7->C7_QUANT * SC3->C3_PRECO //SC3->C3_TOTAL
   					SC7->C7_BASEICM := SC7->C7_QUANT * SC3->C3_PRECO //SC3->C3_TOTAL
   					SC7->C7_BASEIPI := SC7->C7_QUANT * SC3->C3_PRECO //SC3->C3_TOTAL
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

	//--------------------------------------------------------------------
	//--------------------------------------------------------------------
	//--  Gera pendencias de aprovacao para o pedido em aberto/contrato --
    //--------------------------------------------------------------------
    //--------------------------------------------------------------------
    
    //-- posiciona no produto
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+SC3->C3_PRODUTO)) 
		ALERT('ERRO, NÃO FOI GERADA PENDENCIA DE APROVACAO. FAVOR ENTRAR EM CONTATO COM TI!')
		Return .f.
	Endif

    //-- Query para trazer os aprovadores
    cQuery := " SELECT * FROM "+RetSqlName("ZAA")
    cQuery += " WHERE ZAA_FILIAL = '"+xFilial("ZAA")+"'"
    cQuery += " AND D_E_L_E_T_ = ' '"
    cQuery += " AND ZAA_GERA   = '2'"

   	cQuery += " AND ( "
   	cQuery += " (ZAA_GRUPO = '' OR ZAA_GRUPO = '"+SB1->B1_GRUPO+"') AND "
   	cQuery += " (ZAA_TIPO  = '' OR ZAA_TIPO  = '"+SB1->B1_TIPO+"' ) AND "   
   	cQuery += " (ZAA_LOCAL = '' OR ZAA_LOCAL = '"+SC1->C1_LOCAL+"') AND "  
   	cQuery += " (ZAA_CC    = '' OR ZAA_CC    = SUBSTRING('"+Alltrim(SC1->C1_CC   )+"',1,LEN(ZAA_CC   ))) AND "
   	cQuery += " (ZAA_CONTA = '' OR ZAA_CONTA = SUBSTRING('"+Alltrim(SC1->C1_CONTA)+"',1,LEN(ZAA_CONTA))) "
   	cQuery += " ) "

    TCQUERY cQuery new Alias "WHBTRA"
	
	SZU->(DbSetOrder(3)) //filial + numero do contrato + item contrato + login + numero da revisao
    While WHBTRA->(!eof())

		//-- INCLUIDO PARA NAO GERAR DUPLICIDADE DE PENDENCIA DE APROVACAO
		If SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUM + SC3->C3_ITEM + ALLTRIM(WHBTRA->ZAA_LOGIN) ))
			WHBTRA->(dbskip())
			Loop
		EndIf

		//-- GRAVA OS APROVADORES
		RecLock("SZU",.T.)
			SZU->ZU_FILIAL := xFilial("SZU")
			SZU->ZU_NUM    := SC3->C3_NUMSC   //num solicitaçao de compra
			SZU->ZU_ITEM   := SC3->C3_ITEMSC  //item da solicitação de compra 
			SZU->ZU_NUMCT  := SC3->C3_NUM     // num do pedido em aberto/contrato
			SZU->ZU_ITEMCT := SC3->C3_ITEM    // item do pedido em aberto/contrato
			SZU->ZU_LOGIN  := WHBTRA->ZAA_LOGIN
			SZU->ZU_NIVEL  := WHBTRA->ZAA_ORDEM
			SZU->ZU_ORIGEM := "SC3"         
			SZU->ZU_NUMREV := SC3->C3_NUMREV  //numero da revisao
			
			//-- os nº: 047000
			If Alltrim(cUserName)==Alltrim(WHBTRA->ZAA_LOGIN)
				SZU->ZU_DATAPR := DATE()
				SZU->ZU_HORAPR := TIME()
				SZU->ZU_STATUS := "A"
			Endif
			//-- fim os: 047000
			
		MsUnlock("SZU")
        
       	WHBTRA->(dbskip())
    Enddo
        
    WHBTRA->(dbclosearea())		
    
Endif
    
Return(.T.)