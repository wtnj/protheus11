/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA120G2  ºAutor  ³Marcos R Roquitski  º Data ³  30/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos gravacao do pedido de compra.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/     
// nTipoped == 1 //1= pedido de compras 2 = autorizaçao de entrega

#include "rwmake.ch"
#include "topconn.ch"

//***********************************************************************************************************
User Function MTA120G2()

	Private	_nVlrPa
	Private	_cCondPg
	Private _nVlPed
	Private _aGrupo
	Private _cLogin
	_aGrupo := pswret() // Retorna vetor com dados do usuario
	_cLogin := _agrupo[1,2] // Apelido
    
    If nTipoped == 1 //1= pedido de compras 2 = autorizaçao de entrega
	   fGravaSZU()

	   If Alltrim(GetMv("MV_GERAPA")) == 'S'
	     	If MsgBox("Gera Adiantamento para o PEDIDO No. "+SC7->C7_NUM,"GERA FINANCEIRO","YESNO")
		    	fDados()
		    Endif	
	   Endif	
    Else //2 = autorizaçao de entrega
       fGeraSZU() //para aprovação de autorização de entrega
    Endif
Return(.t.)

Static Function fDados()
Local k

	_nVlPed := 0
	_nVlrPa := 0
	For k := 1 To Len(Acols)
		_nVlrPa += Acols[k][6] * Acols[k][7]
    Next
	_nVlPed := _nVlrPa
	_cCondPg := Space(03)

	@ 200,050 To 400,400 Dialog DlgDados Title OemToAnsi("Geracao de Pagamentos Antecipados")

	@ 011,020 Say OemToAnsi("Valor PA     ") Size 35,8
	@ 025,020 Say OemToAnsi("Cond. Pagto  ") Size 35,8
     
	@ 010,070 Get _nVlrPa   PICTURE "@E 999,999,999.99" Valid(_nVlrPa > 0 .and. _nVlrPa <= _nVlPed) Size 65,8
	@ 024,070 Get _cCondPg  PICTURE "@!" F3 "SE4" Valid(!Vazio() .AND. Existcpo("SE4")) Size 45,8
      
	@ 075,050 BMPBUTTON TYPE 01 ACTION fGravaFin()
	@ 075,090 BMPBUTTON TYPE 02 ACTION Close(DlgDados)
	Activate Dialog DlgDados CENTERED

Return(.T.)    


Static Function fGravaFin()
Local lReturn := .T., m, l,aVenc, _cNomFor, _cNaturez

	Close(DlgDados)

	_cNomFor  := Space(30)
	_cNaturez := Space(15)
	aVenc := Condicao(_nVlrPa,SE4->E4_CODIGO,,dDataBase)

	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") +  SC7->C7_FORNECE + SC7->C7_LOJA))
	If SA2->(Found())
		_cNomFor  := SA2->A2_NREDUZ
		_cNaturez := SA2->A2_NATUREZ
	Endif

	For l := 1 To Len(aVenc)
         RecLock("SE2",.T.)
         SE2->E2_FILIAL    := xFilial("SE2")
         SE2->E2_PREFIXO   := "1"
         SE2->E2_NUM       := SC7->C7_NUM
         SE2->E2_PARCELA   := Strzero(l,1)
         SE2->E2_TIPO      := "PA"
         SE2->E2_NATUREZ   := _cNaturez
         SE2->E2_FORNECE   := SC7->C7_FORNECE
         SE2->E2_LOJA      := SC7->C7_LOJA
         SE2->E2_NOMFOR    := _cNomFor
         SE2->E2_EMISSAO   := dDataBase               
         SE2->E2_VENCTO    := aVenc[l][1]
         SE2->E2_VENCREA   := aVenc[l][1]
         SE2->E2_VENCORI   := aVenc[l][1]
         SE2->E2_VALOR     := aVenc[l][2]
         SE2->E2_EMIS1     := dDataBase
         SE2->E2_SALDO     := 0
		 SE2->E2_BAIXA     := dDataBase
         SE2->E2_MOEDA     := 1
         SE2->E2_FATURA    := ""
         SE2->E2_VLCRUZ    := aVenc[l][2]
         SE2->E2_ORIGEM    := "MTA120"
         SE2->E2_CC        := SC7->C7_CC
		 SE2->E2_PEDIDO    := SC7->C7_NUM
		 SE2->E2_FLUXO     := "S"
		 SE2->E2_FILORIG   := xFilial("SE2")
		 SE2->E2_DESDOBR   := "N"
		 SE2->E2_RATEIO    := "N"
         MsUnlock("SE2")
	Next l

	Close(DlgDados)

Return(lReturn)


Static Function fGravaSZU()
	SZU->(DbSetOrder(2))
	SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
	While !SZU->(Eof()) .AND. SZU->ZU_NUM+SZU->ZU_ITEM == SC7->C7_NUMSC+SC7->C7_ITEMSC
		If SZU->ZU_NIVEL == '9' // SZU->ZU_LOGIN == _cLogin
		    //efetua aprovaçao automatica do comprador na solicitaçao SC1 apos incluir o pedido de compras
			If Empty(Alltrim(SZU->ZU_STATUS)) .And. SZU->ZU_ORIGEM$"SC1"
				RecLock("SZU",.F.)
				SZU->ZU_LOGIN  := _cLogin
				SZU->ZU_DATAPR := DATE()
				SZU->ZU_HORAPR := TIME()
				SZU->ZU_STATUS := "A"
				MsUnlock("SZU")
			Endif	
		Endif
		SZU->(DbSkip())
	Enddo
Return


Static Function fGeraSZU() //gera aprovação no SZU para autorizacao de entrega
Local cQuery := ''

	If GetMv("MV_MT110G1") == "S"

        //-- posiciona no produto
	    SB1->(DbSetOrder(1))
	    If !SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
	    	Return .f.
	    Endif

        //-- Query para trazer os aprovadores
        cQuery := " SELECT * FROM "+RetSqlName("ZAA")
        cQuery += " WHERE ZAA_FILIAL = '"+xFilial("ZAA")+"'"
        cQuery += " AND D_E_L_E_T_ = ' '"
        cQuery += " AND ZAA_GERA   = '3'"

    	cQuery += " AND ( "
    	cQuery += " (ZAA_GRUPO = '' OR ZAA_GRUPO = '"+SB1->B1_GRUPO+"') AND "
    	cQuery += " (ZAA_TIPO  = '' OR ZAA_TIPO  = '"+SB1->B1_TIPO+"' ) AND "   
    	cQuery += " (ZAA_LOCAL = '' OR ZAA_LOCAL = '"+SC7->C7_LOCAL+"') AND "  
    	cQuery += " (ZAA_CC    = '' OR ZAA_CC    = SUBSTRING('"+Alltrim(SC7->C7_CC   )+"',1,LEN(ZAA_CC   ))) AND "
    	cQuery += " (ZAA_CONTA = '' OR ZAA_CONTA = SUBSTRING('"+Alltrim(SC7->C7_CONTA)+"',1,LEN(ZAA_CONTA))) "
    	cQuery += " ) "  
    		
     	TCQUERY cQuery new Alias "WHBTRA"
					
       	SZU->(DbSetOrder(4)) //ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL
       	SC3->(DbSetOrder(1))
       	
        While WHBTRA->(!eof())

			//-- GRAVA OS APROVADORES
			//SC3->(DbSeek(xFilial("SC3")+SC7->C7_NUMSC + SC7->C7_ITEMSC)) // Pesquisa o numero do SC no contrato
			//If !SZU->(DbSeek(xFilial("SZU")+SC3->C3_NUMSC + SC3->C3_ITEMSC + WHBTRA->ZAA_ORDEM))
			//If !SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM + WHBTRA->ZAA_ORDEM))

			//-- INCLUIDO PARA NAO GERAR DUPLICIDADE DE PENDENCIA DE APROVACAO
			If SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM))
				
				lExiste := .F. //flag se existe pendencia para o login corrente
				
				While SZU->(!EOF()) .AND. SZU->ZU_NUMPED==SC7->C7_NUM .AND. SZU->ZU_ITEMPED==SC7->C7_ITEM
				
					If ALLTRIM(SZU->ZU_LOGIN)==ALLTRIM(WHBTRA->ZAA_LOGIN)
						lExiste := .T.
						Exit
					Endif
					
					SZU->(dbskip())
				Enddo
				
				If lExiste 
					WHBTRA->(dbskip())
					Loop
				Endif

			EndIf

			RecLock("SZU",.T.)
				SZU->ZU_FILIAL  := xFilial("SZU")                   
				SZU->ZU_NUM     := SC3->C3_NUMSC  //numero da solicitaçao de compras do contrato
				SZU->ZU_ITEM    := SC3->C3_ITEMSC //item da solicitaçao de compras do contrato
				SZU->ZU_NUMCT   := SC7->C7_NUMSC  //numero do contrato
				SZU->ZU_ITEMCT  := SC7->C7_ITEMSC //item do contrato
				SZU->ZU_LOGIN   := WHBTRA->ZAA_LOGIN
				SZU->ZU_NUMPED  := SC7->C7_NUM    //numero da autorizacao de entrega
				SZU->ZU_ITEMPED := SC7->C7_ITEM   //item da autorizacao de entrega
				SZU->ZU_NIVEL   := WHBTRA->ZAA_ORDEM
				SZU->ZU_ORIGEM  := "SC7"
			MsUnlock("SZU")

			//Else
			//	RecLock("SZU",.F.)
			//		SZU->ZU_LOGIN  := WHBTRA->ZAA_LOGIN
  			//		SZU->ZU_ORIGEM := "SC7"
			//	MsUnlock("SZU")
			//Endif
        
        	WHBTRA->(dbskip())
        Enddo
        
        WHBTRA->(dbclosearea())

	Endif		
Return(.T.)
