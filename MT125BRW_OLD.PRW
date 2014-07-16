
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT125BRW  ºAutor  ³João Felipe da Rosa º Data ³  02/08/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ No inicio da função após a definição do aRotina e antes da º±±
±±º          ³ execução da Mbrowse do Contrato, utilizado para adicionar  º±±
±±º          ³ mais opções no aRotina ou outra utilidade que precise      º±±
±±º          ³ acontecer antes da montagem do browse                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COPMPRAS                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "rwmake.ch"

User Function MT125BRW()

	aAdd(aRotina,{"Revisão","Processa({||U_M125Rev()},'Gerando Revisão ...')",0,3})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA REVISAO DO PEDIDO EM ABERTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function M125Rev()
Local _nRev   := 1
Local _cNum   := SC3->C3_NUM
Local _aPedAb := {}

If !MsgYesNo("Deseja gerar uma revisão?")
	Return
EndIf
		
//Numero da Revisao
If !empty(SC3->C3_NUMREV)
	_nRev := VAL(SC3->C3_NUMREV) + 1
endif

nSC3Rec := SC3->(Recno()) //guarda a posicao do sc3
                          
SC3->(DbSetOrder(1)) //filial + num + item

//Grava histórico de Pedido Aberto
SC3->(DbSeek(xFilial("SC3")+_cNum))

While SC3->(!EOF()) .AND. SC3->C3_NUM==_cNum

	RecLock("ZB2",.T.) 
	
		ZB2->ZB2_FILIAL 	 := SC3->C3_FILIAL
		ZB2->ZB2_NUM    	 := SC3->C3_NUM
		ZB2->ZB2_FORNEC      := SC3->C3_FORNECE
		ZB2->ZB2_LOJA        := SC3->C3_LOJA
		ZB2->ZB2_ITEM        := SC3->C3_ITEM
		ZB2->ZB2_PRODUT      := SC3->C3_PRODUTO
		ZB2->ZB2_DESCRI      := SC3->C3_DESCRI
		ZB2->ZB2_QUANT       := SC3->C3_QUANT
		ZB2->ZB2_UM          := SC3->C3_UM
		ZB2->ZB2_DATPRI      := SC3->C3_DATPRI
		ZB2->ZB2_DATPRF      := SC3->C3_DATPRF
		ZB2->ZB2_PRECO       := SC3->C3_PRECO
		ZB2->ZB2_SIGLA       := SC3->C3_SIGLA
		ZB2->ZB2_COND        := SC3->C3_COND
		ZB2->ZB2_CONTAT      := SC3->C3_CONTATO
		ZB2->ZB2_FILENT      := SC3->C3_FILENT
		ZB2->ZB2_EMISSA      := SC3->C3_EMISSAO
		ZB2->ZB2_TOTAL       := SC3->C3_TOTAL
		ZB2->ZB2_IPI         := SC3->C3_IPI
		ZB2->ZB2_LOCAL       := SC3->C3_LOCAL
		ZB2->ZB2_RESIDU      := SC3->C3_RESIDUO
		ZB2->ZB2_MSG         := SC3->C3_MSG
		ZB2->ZB2_ENCER       := SC3->C3_ENCER
		ZB2->ZB2_FRETE       := SC3->C3_FRETE
		ZB2->ZB2_EMITID      := SC3->C3_EMITIDO
	    ZB2->ZB2_OK          := SC3->C3_OK
		ZB2->ZB2_OBS         := SC3->C3_OBS
		ZB2->ZB2_QUJE        := SC3->C3_QUJE
		ZB2->ZB2_REAJUS      := SC3->C3_REAJUST
		ZB2->ZB2_TPFRET      := SC3->C3_TPFRETE
		ZB2->ZB2_MOEDA       := SC3->C3_MOEDA
		ZB2->ZB2_VALFRE      := SC3->C3_VALFRE
		ZB2->ZB2_NUMSC       := SC3->C3_NUMSC
		ZB2->ZB2_ITEMSC      := SC3->C3_ITEMSC
		ZB2->ZB2_TRANSP      := SC3->C3_TRANSP
		ZB2->ZB2_ENTREG      := SC3->C3_ENTREGA
		ZB2->ZB2_NUMREV      := SC3->C3_NUMREV
		ZB2->ZB2_TXMOED      := SC3->C3_TXMOEDA
		ZB2->ZB2_CC          := SC3->C3_CC
		ZB2->ZB2_DATARE      := SC3->C3_DATAREV
		ZB2->ZB2_USER        := SC3->C3_USER
		ZB2->ZB2_APROV       := SC3->C3_APROV
		ZB2->ZB2_GRUPCO      := SC3->C3_GRUPCOM
		ZB2->ZB2_CONAPR      := SC3->C3_CONAPRO
		ZB2->ZB2_CONTA       := SC3->C3_CONTA
		ZB2->ZB2_GRADE       := SC3->C3_GRADE
		ZB2->ZB2_ITEMGR      := SC3->C3_ITEMGRD
		ZB2->ZB2_SEGUM       := SC3->C3_SEGUM
		ZB2->ZB2_AVISTA      := SC3->C3_AVISTA
		ZB2->ZB2_QTSEGU      := SC3->C3_QTSEGUM
		ZB2->ZB2_QTIMP       := SC3->C3_QTIMP
		
	MsUnLock("ZB2")
	 
	RecLock("SC3",.F.)
		If (SC3->C3_QUANT - SC3->C3_QUJE) > 0
			SC3->C3_QUANT -= SC3->C3_QUJE
			SC3->C3_QUJE  := 0
		EndIf
		
		SC3->C3_TOTAL   := SC3->C3_QUANT * SC3->C3_PRECO
		SC3->C3_NUMREV  := STRZERO(_nRev,2)
		SC3->C3_DATAREV := Date()
	MsUnLock("SC3")
	
	SC3->(dbSkip())

ENDDO

MsgBox("Revisão gerada com sucesso!","Revisao gerada","INFO")

SC3->(dbGoTo(nSC3Rec)) // retorna a posicao do sc3

Return 
 