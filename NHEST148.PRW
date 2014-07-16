
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHEST148  บAutor  ณJoใo Felipe da Rosa บ Data ณ  01/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATORIO DE NOTAS FISCAIS DE VENDA COM NUMERO DO PEDIDO   บฑฑ
ฑฑบ          ณ DO CLIENTE                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - ESTOQUE / CUSTOS                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#INCLUDE "topconn.ch"

User Function NHEST148()

//mv_par01 -> de cliente
//mv_par02 -> ate cliente
//mv_par03 -> de emissao
//mv_par04 -> ate emissao
//mv_par05 -> de produto
//mv_par06 -> ate produto
//mv_par07 -> de pedido
//mv_par08 -> ate pedido
//mv_par09 -> de grupo
//mv_par10 -> ate grupo  
//mv_par11 -> de TES
//mv_par12 -> ate TES

	//instancia um novo objeto do tipo relatorio
	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SF2"
	oRelato:cPerg    := "EST148"
	oRelato:cNomePrg := "NHEST148"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "M"
	
	//descricao
	oRelato:cDesc1   := "Este relat๓rio apresenta as  Notas  Fiscais "
	oRelato:cDesc2   := "de Venda e seus Pedidos de Venda do Cliente"
	oRelato:cDesc3   := ""
	
	//titulo
	oRelato:cTitulo  := " NOTAS FISCAIS X PEDIDOS DE VENDA "
	
	//cabecalho
	oRelato:cCabec1  := "Cliente"
	oRelato:cCabec2  := "Produto           Descri็ใo                            NF   Serie       Emissใo    Volume        Quant.           Pedido"
	
	oRelato:Run({||Imprime()})

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCAO DE IMPRESSAO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function Imprime()
Local cCli    := "" 
Local cLoja   := ""
Local lPrim   := .T.    
Local cDesCli := ""
Local cProd   := ""
Local nTotQtd := 0
Local nTotGer := 0

	Processa({||Gerando()},"Gerando dados para impressใo...")
	
	oRelato:Cabec()
	
	SA1->(dbSetOrder(1)) // FILIAL + CLI + LOJA 
	
	WHILE TRA1->(!EOF())
	
		If Prow() > 55
			oRelato:Cabec()
		EndIf
		
//		If cCli != TRA1->F2_CLIENTE .OR. cLoja != TRA1->F2_LOJA
		
	    	If TRA1->F2_TIPO=="B"
	    		SA2->(DbSetOrder(1)) // FILIAL + COD + LOJA
    			SA2->(DbSeek(xFilial("SA2")+TRA1->F2_CLIENTE+TRA1->F2_LOJA))

    			cDesCli := SA2->A2_NOME
    		Else
				SA1->(DbSetOrder(1)) //FILIAL + COD + LOJA
				SA1->(DbSeek(xFilial("SA1")+TRA1->F2_CLIENTE+TRA1->F2_LOJA))
				
				cDesCli := SA1->A1_NOME
			EndIf
		
			If lPrim
				@Prow()+1 , 001 psay TRA1->F2_CLIENTE + " - " + TRA1->F2_LOJA + " " + cDesCli
				lPrim := .F.
			Else
				@Prow()+1 , 000 psay __PrtThinLine()
				@Prow()+1 , 001 psay TRA1->F2_CLIENTE + " - " + TRA1->F2_LOJA + " " + cDesCli
			EndIf
			
			cCli  := TRA1->F2_CLIENTE 
			cLoja := TRA1->F2_LOJA
			
//		EndIf

		While(cCli==TRA1->F2_CLIENTE .AND. cLoja == TRA1->F2_LOJA)

			If Prow() > 55
				oRelato:Cabec()
			EndIf

			If cProd!=TRA1->D2_COD
				@Prow()+1 , 001 psay "" //pula linha
				cProd := TRA1->D2_COD
			EndIf
		
			@Prow()+1 , 001 psay TRA1->D2_COD + "  " + Substr(TRA1->B1_DESC,1,45)
			@Prow()   , 052 psay TRA1->F2_DOC + " - " + TRA1->F2_SERIE
			@Prow()   , 070 psay DtoC(StoD(TRA1->F2_EMISSAO))
			@Prow()   , 082 psay TRA1->F2_VOLUME1 Picture "9,999"
			@Prow()   , 093 psay TRA1->D2_QUANT Picture "999,999.99"
			nTotQtd += TRA1->D2_QUANT
			@Prow()   , 110 psay TRA1->F2_PCCLI
		
			TRA1->(DbSkip())
			
		EndDo
             
		@Prow()+1 , 001 psay "TOTAL"
		@Prow()   , 089 psay nTotQtd Picture "999,999,999.99"
		
		nTotGer += nTotQtd
		nTotQtd := 0
			
	ENDDO
	
	@Prow()+1 , 000 psay __PrtThinLine()
	@Prow()+2 , 001 psay "TOTAL GERAL"
	@Prow()   , 089 psay nTotGer Picture "999,999,999.99"

	TRA1->(DbCloseArea())
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ GERA DADOS PARA IMPRESSAO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function Gerando()
Local cQuery
	
	cQuery := " SELECT F2.* , D2.* , B1.B1_DESC "
	cQuery += " FROM "+RetSqlName("SF2")+" F2, "+RetSqlName("SD2")+" D2, "+RetSqlName("SB1")+" B1 "
	cQuery += " WHERE B1.B1_COD = D2.D2_COD "
	cQuery += " AND F2.F2_DOC = D2.D2_DOC "
	cQuery += " AND F2.F2_SERIE = D2.D2_SERIE "
	cQuery += " AND D2.D2_TES BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
	cQuery += " AND F2.F2_TIPO = 'N'"
	cQuery += " AND F2.F2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND F2.F2_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"'"
	cQuery += " AND D2.D2_COD     BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND F2.F2_PCCLI BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND B1.B1_GRUPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	cQuery += " AND F2.F2_FILIAL = '"+xFilial("SF2")+"' AND F2.D_E_L_E_T_ = ''"
	cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ = ''"
	cQuery += " ORDER BY F2.F2_CLIENTE, F2.F2_LOJA, F2.F2_EMISSAO, F2.F2_DOC, F2.F2_SERIE"

	TCQUERY cQuery NEW ALIAS "TRA1"
	
Return