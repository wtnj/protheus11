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
	If GetMv("MV_MT110G1") == "S"
        SC3->(DbSetOrder(1)) //Filial + num contrato + item contrato
        SZU->(DbSetOrder(4))//Filial + num autorizacao entrega + item da auto de entrega + nivel
	    SB1->(DbSetOrder(1))
	    SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
	    If SB1->(Found())
			// Tabela de validação de Usuarios, Grupos e Local Padrão
			
	       ZAA->(Dbgotop()) // Tabela de validação de Usuarios, Grupos e Local Padrão
	       While !ZAA->(Eof())			

				// Aprovacao  ZAA_GERA
				// 1 = solicitacao de compras
				// 2 = pedido em aberto
				// 3 = autorizacao de entrega                                                   
				
//              If !ZAA->ZAA_CONTRA$"S" // Nao Gera pendencia para Grupo de contrato igual a sim
              If ZAA->ZAA_GERA == "3" // Gera pendencia para autorizacao de entrega
				If Substr(Alltrim(SC7->C7_CONTA),1,8) == "10104006" .AND. ZAA->ZAA_CONTA == "10104006"
					If !Empty(ZAA->ZAA_GRUPO) // Gera pendencia para Grupo
						If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO)
							SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM + ZAA->ZAA_ORDEM))
							SC3->(DbSeek(xFilial("SC3")+SC7->C7_NUMSC + SC7->C7_ITEMSC)) // Pesquisa o numero do SC no contrato
	        	            If !SZU->(Found())
								RecLock("SZU",.T.)
								SZU->ZU_FILIAL  := xFilial("SZU")                   
								SZU->ZU_NUM     := SC3->C3_NUMSC //numero da solicitaçao de compras do contrato
								SZU->ZU_ITEM    := SC3->C3_ITEMSC //item da solicitaçao de compras do contrato
								SZU->ZU_NUMCT   := SC7->C7_NUMSC //numero do contrato
								SZU->ZU_ITEMCT  := SC7->C7_ITEMSC //item do contrato
								SZU->ZU_LOGIN   := ZAA->ZAA_LOGIN
								SZU->ZU_NUMPED  := SC7->C7_NUM  //numero da autorizacao de entrega
								SZU->ZU_ITEMPED := SC7->C7_ITEM //item da autorizacao de entrega
								SZU->ZU_NIVEL   := ZAA->ZAA_ORDEM
								SZU->ZU_ORIGEM  := "SC7"
								MsUnlock("SZU")
							Endif
						Endif
					Endif
				
				Elseif Substr(Alltrim(SC7->C7_CONTA),1,8) <> "10104006" .AND. Substr(ZAA->ZAA_CONTA,1,8) <> "10104006"

					If Alltrim(SB1->B1_TIPO) $ 'FC/FD'

						If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .AND. ZAA->ZAA_TIPO == Alltrim(SB1->B1_TIPO)
							SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
    						SC3->(DbSeek(xFilial("SC3")+SC7->C7_NUMSC + SC7->C7_ITEMSC)) // Pesquisa o numero do SC no contrato
    		   	            If !SZU->(Found())
								RecLock("SZU",.T.)
								SZU->ZU_FILIAL := xFilial("SZU")                   
								SZU->ZU_NUM    := SC3->C3_NUMSC //numero da solicitaçao de compras do contrato
								SZU->ZU_ITEM   := SC3->C3_ITEMSC //item da solicitaçao de compras do contrato
								SZU->ZU_NUMCT  := SC7->C7_NUMSC //numero do contrato
								SZU->ZU_ITEMCT := SC7->C7_ITEMSC //item do contrato
								SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
								SZU->ZU_NUMPED := SC7->C7_NUM  //numero da autorizacao de entrega
								SZU->ZU_ITEMPED:= SC7->C7_ITEM //item da autorizacao de entrega
   								SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
								SZU->ZU_ORIGEM := "SC7"								
								MsUnlock("SZU")   
							Endif                     
						Endif

					Else

						If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Empty(ZAA->ZAA_TIPO)

							SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM + SC7->C7_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
							SC3->(DbSeek(xFilial("SC3")+SC7->C7_NUMSC + SC7->C7_ITEMSC)) // Pesquisa o numero do SC no contrato							
	    		   	        If !SZU->(Found())
								RecLock("SZU",.T.)              
								SZU->ZU_FILIAL := xFilial("SZU")                   
								SZU->ZU_NUM    := SC3->C3_NUMSC //numero da solicitaçao de compras do contrato
								SZU->ZU_ITEM   := SC3->C3_ITEMSC //item da solicitaçao de compras do contrato
								SZU->ZU_NUMCT  := SC7->C7_NUMSC //numero do contrato
								SZU->ZU_ITEMCT := SC7->C7_ITEMSC //item do contrato
								SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
								SZU->ZU_NUMPED := SC7->C7_NUM  //numero da autorizacao de entrega
								SZU->ZU_ITEMPED:= SC7->C7_ITEM //item da autorizacao de entrega
								SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
								SZU->ZU_ORIGEM := "SC7"								
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
