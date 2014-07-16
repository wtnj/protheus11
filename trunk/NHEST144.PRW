/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST144  ºAutor  ³João Felipe        º Data ³  17/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO DE FATURAMENTO DA TRANSFERÊNCIA WHBIII P/ WHBII  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / FATURAMENTO                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "topconn.ch"

User Function NHEST144()
Private oRelato 

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZBI"
    oRelato:cPerg    := "EST144"
	oRelato:cNomePrg := "NHEST144"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este   relatório   apresenta  o  faturamento"
	oRelato:cDesc2   := "dos produtos que são TRA1nsferidos da empresa"
	oRelato:cDesc3   := "WHB II para a WHB III."

	//titulo
	oRelato:cTitulo  := "Relatório de Faturamento Diário - TRA1nsferência WHB II / WHB III"

	//cabecalho      
	oRelato:cCabec1  := "WHB FUNDICAO S/A                                       * (C) = Complemento de Valor "
    oRelato:cCabec2  := "PECA                  DESCRICAO                   QUANTIDADE    VALOR MEDIO     TOTAL S/IPI   % IPI    VALOR IPI         VALOR TOTAL"
		    
	oRelato:Run({||Imprime()})
	
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local nTQuant := 0
Local nTVal   := 0
Local nTTotal := 0

	Processa({|| Gerando()},"Gerando Dados p/ Impressão...")
	
	oRelato:cTitulo += " De "+ Dtoc(Mv_par01) +" Ate " + Dtoc(Mv_par02)

	oRelato:Cabec()
	
	While TRA1->(!EOF())
	
		If Prow() > 65
			oRelato:Cabec()
		EndIf
		
		@Prow()+1, 001 psay TRA1->ZBB_COD
		@Prow()  , 022 psay Left(TRA1->B1_DESC,25)
		@Prow()  , 049 psay TRA1->QUANT Picture "@E 999,999.999"
		nTQuant += TRA1->QUANT

		@Prow()  , 062 psay TRA1->ZBB_UPRC Picture "@E 99,999,999.99"

		nTVal += TRA1->ZBB_UPRC
		@Prow()  , 078 psay TRA1->QUANT * (TRA1->ZBB_UPRC) Picture "@E 99,999,999.99" 
		@Prow()  , 094 psay (TRA1->B1_IPI/100) Picture "@E 99.99"
		@Prow()  , 103 psay TRA1->B1_VLR_IPI Picture "@E 999,999.99"
		@Prow()  , 115 psay (TRA1->QUANT*TRA1->ZBB_UPRC)+TRA1->B1_VLR_IPI Picture "@E 99,999,999,999.99"		
		nTTotal += (TRA1->QUANT*TRA1->ZBB_UPRC)+TRA1->B1_VLR_IPI
	     
		TRA1->(DbSkip())
	ENDDO

	@Prow() +1,000 psay __PrtThinLine()
	@Prow() +1,000 psay "Total:--->"

	@Prow()  , 047 psay nTQuant Picture "@E 9,999,999.999"	
	@Prow()  , 063 psay nTVal   Picture "@E 9,999,999.99"
	@Prow()  , 116 psay nTTotal Picture "@E 9,999,999,999.99"		

	TRA1->(DbCloseArea())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA OS DADOS PARA IMPRESSÃO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery 

	If Select("TRA1") > 0
		TRA1->(dbCloseArea())
	EndIf

	cQuery := "SELECT ZBB.ZBB_COD, SUM(ZBB.ZBB_QUANT) AS QUANT, B1.B1_GRUPO, "
	cQuery += " B1.B1_DESC, B1.B1_PRV1, B1.B1_IPI, B1.B1_VLR_IPI, ZBB.ZBB_UPRC"
	cQuery += " FROM "+RetSqlName("ZBA")+" ZBA, "+RetSqlName("ZBB")+" ZBB, "+RetSqlName("SB1")+" B1"
	cQuery += " WHERE ZBA.ZBA_NUM 	= ZBB.ZBB_NUM"
	cQuery += " AND ZBB.ZBB_COD 	= B1.B1_COD"
	cQuery += " AND ZBA.ZBA_DATA 	BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"'"
	cQuery += " AND ZBB.ZBB_COD 	BETWEEN '"+mv_par03+"' 		 AND '"+mv_par04+"'" 
	cQuery += " AND B1.B1_GRUPO 	BETWEEN '"+mv_par05+"' 		 AND '"+mv_par06+"'"
	cQuery += " AND ZBA.D_E_L_E_T_ 	= '' 	AND ZBA.ZBA_FILIAL 	 = '"+xFilial("ZBA")+"'"
	cQuery += " AND ZBB.D_E_L_E_T_ 	= '' 	AND ZBB.ZBB_FILIAL 	 = '"+xFilial("ZBB")+"'"
	cQuery += " AND B1.D_E_L_E_T_ 	= ''	AND B1.B1_FILIAL 	 = '"+xFilial("SB1")+"'"
	cQuery += " GROUP BY ZBB.ZBB_COD,B1.B1_GRUPO, B1.B1_DESC, B1.B1_PRV1, B1.B1_IPI, B1.B1_VLR_IPI, ZBB_UPRC"
	cQuery += " ORDER BY ZBB.ZBB_COD"
	
	@Prow()+1,001 PSAY cQuery
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DbGoTop())

Return
