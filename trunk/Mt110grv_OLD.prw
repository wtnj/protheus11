/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mt110grv  ºAutor  ³Marcos R Roquitski  º Data ³  12/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos gravacao da SC.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Mt110grv()            

	If Alltrim(SC1->C1_PRODUTO)$"MF25.000725" //O.S. numero 028785 autorizado pelo Roderjan
	   Return(.T.)
	Endif

	ZAA->(DbSetOrder(1))
	If GetMv("MV_MT110G1") == "S"
        SZU->(DbSetOrder(2))
	    SB1->(DbSetOrder(1))
	    SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	    If SB1->(Found())
			// Tabela de validação de Usuarios, Grupos e Local Padrão
			ZAA->(Dbgotop()) // Tabela de validação de Usuarios, Grupos e Local Padrão
			While !ZAA->(Eof())
				// Aprovacao  ZAA_GERA
				// 1 = solicitacao de compras
				// 2 = pedido em aberto
				// 3 = autorizacao de entrega
				
//               If ZAA->ZAA_CONTRA <> "S" // gera aprovaçao para solicitacao de compra
               If ZAA->ZAA_GERA == "1" // gera aprovaçao para solicitacao de compra               
					
					//-- OS Nº: 022646	
					//-- data : 19/09/2011
					//-- autor: João Felipe da Rosa
					//-- desc : Filtro quando estiver preenchido campo C1_NUMOS não gerar aprovação para REINALDO
					If ZAA->ZAA_LOGIN$"REINALDO" .AND. !Empty(SC1->C1_NUMOS)
			   			ZAA->(dbSkip())			
			   			Loop
					EndIf
					//-- Fim OS Nº 022646
					
					If Substr(Alltrim(SC1->C1_CC),2,1) == "7"  .And. Substr(Alltrim(ZAA->ZAA_CC),2,1) == "7" //Centro de custo de inovação      
					
						SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		        	        If !SZU->(Found())
								RecLock("SZU",.T.)
								SZU->ZU_FILIAL := xFilial("SZU")
								SZU->ZU_NUM    := SC1->C1_NUM
								SZU->ZU_ITEM   := SC1->C1_ITEM
								SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
								SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
								SZU->ZU_ORIGEM := "SC1"
								MsUnlock("SZU")
							Endif
					ElseIf Substr(Alltrim(SC1->C1_CONTA),1,8) == "10104006" .AND. ZAA->ZAA_CONTA == "10104006"
						If !Empty(ZAA->ZAA_GRUPO)
							If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Empty(ZAA->ZAA_TIPO) .And. Empty(ZAA->ZAA_CC)
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		        	            If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL := xFilial("SZU")
									SZU->ZU_NUM    := SC1->C1_NUM
									SZU->ZU_ITEM   := SC1->C1_ITEM
									SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
									SZU->ZU_ORIGEM := "SC1"
									MsUnlock("SZU")
								Endif
							Elseif ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Alltrim(ZAA->ZAA_CC) ==  Alltrim(SC1->C1_CC)
							
                                //Nesta opcao força a gravacao no SZU, pois este aprovador é preferencial
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		    		   	        If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL:= xFilial("SZU")
									SZU->ZU_NUM   := SC1->C1_NUM
									SZU->ZU_ITEM  := SC1->C1_ITEM
									SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM:= "SC1"
									MsUnlock("SZU")
								Else
									RecLock("SZU",.F.)
									SZU->ZU_FILIAL:= xFilial("SZU")
									SZU->ZU_NUM   := SC1->C1_NUM
									SZU->ZU_ITEM  := SC1->C1_ITEM
									SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM:= "SC1"
									MsUnlock("SZU")
								
								Endif
							Endif
						Endif
					
					Elseif Substr(Alltrim(SC1->C1_CONTA),1,5) == "10302" .AND. Alltrim(ZAA->ZAA_CONTA) == "10302" // Fernando W. 

						SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
	       	            If !SZU->(Found())
							RecLock("SZU",.T.)
							SZU->ZU_FILIAL := xFilial("SZU")
							SZU->ZU_NUM    := SC1->C1_NUM
							SZU->ZU_ITEM   := SC1->C1_ITEM
							SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
							SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
							SZU->ZU_ORIGEM := "SC1"
							MsUnlock("SZU")
						Endif

					Elseif (Substr(Alltrim(SC1->C1_CONTA),1,8) <> "10104006" .And. ZAA->ZAA_CONTA <> "10104006") 
	
						If Alltrim(SB1->B1_TIPO) $ 'FC/FD'
	
							If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .AND. ZAA->ZAA_TIPO == Alltrim(SB1->B1_TIPO)
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
	    		   	            If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL := xFilial("SZU")
									SZU->ZU_NUM    := SC1->C1_NUM
									SZU->ZU_ITEM   := SC1->C1_ITEM
									SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM := "SC1"								
									MsUnlock("SZU")   
								Endif                     
							Endif
	
						Else
	
							If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Empty(ZAA->ZAA_TIPO) .And. Empty(ZAA->ZAA_CC) 
	
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		    		   	        If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL:= xFilial("SZU")
									SZU->ZU_NUM   := SC1->C1_NUM
									SZU->ZU_ITEM  := SC1->C1_ITEM
									SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM:= "SC1"
									MsUnlock("SZU")
								Endif
	
							Elseif ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Alltrim(ZAA->ZAA_CC) ==  Alltrim(SC1->C1_CC)
							
                                //Nesta opcao força a gravacao no SZU, pois este aprovador é preferencial
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		    		   	        If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL:= xFilial("SZU")
									SZU->ZU_NUM   := SC1->C1_NUM
									SZU->ZU_ITEM  := SC1->C1_ITEM
									SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM:= "SC1"
									MsUnlock("SZU")
								Else
									RecLock("SZU",.F.)
									SZU->ZU_FILIAL:= xFilial("SZU")
									SZU->ZU_NUM   := SC1->C1_NUM
									SZU->ZU_ITEM  := SC1->C1_ITEM
									SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM:= "SC1"
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