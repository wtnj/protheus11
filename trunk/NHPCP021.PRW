/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHPCP021  ºAutor  ³João Felipe da Rosa º Data ³  10/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATÓRIO DIÁRIO RELEASE X A EXPEDIR                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "topconn.ch"
  
User Function NHPCP021()

Private oRelato 

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "ZA0"
    oRelato:cPerg    := "PCP021"
	oRelato:cNomePrg := "NHPCP021"
	oRelato:wnrel    := oRelato:cNomePrg

	//descricao
	oRelato:cDesc1   := "Este relatório apresenta as quantidades a  serem "
	oRelato:cDesc2   := "expedidas no dia e no dia seguinte de acordo com "
	oRelato:cDesc3   := "o release."

	//titulo
	oRelato:cTitulo  := "Relatório Diário Release x a Expedir"

	//cabecalho      
	oRelato:cCabec1  := "CLIENTE LOJA"                                                                                                          
    oRelato:cCabec2  := "PRODUTO           DESC.                                   ATRASO    %%/%%/INI%   %%/%%/FIM%     SALDO       ENTREGUE       RELEASE"
		    
	oRelato:Run({||Imprime()})
	
Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE IMPRESSAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local nAtraso  := 0
Local cField2  := ""
Local cField3  := ""
Local nRelease := 0 
Local nSaldo   := 0
Local nEntr    := 0

	Processa({|| Gerando()},"Gerando Dados p/ Impressão...")
	
	oRelato:cCabec2 := StrTran(oRelato:cCabec2,"%%/%%/INI%",DtoC(mv_par01))
	oRelato:cCabec2 := StrTran(oRelato:cCabec2,"%%/%%/FIM%",DtoC(mv_par01+1))
	
	oRelato:Cabec()
	
	While TRA1->(!EOF())
	
//		IncProc(TRA1->ZAO_CLIENT+" - "+TRA1->ZAO_LOJA)
	
		If Prow() > 65
			oRelato:Cabec()
		EndIf
		
		SA1->(dbSetOrder(1)) // FILIAL + COD + LOJA
		SA1->(dbSeek(xFilial("SA1")+TRA1->ZAO_CLIENT+TRA1->ZAO_LOJA))
		
		@Prow()+1, 001 psay TRA1->ZAO_RELCLI
		@Prow()+2, 001 psay TRA1->ZAO_CLIENT+" - "+TRA1->ZAO_LOJA+"   "+SA1->A1_NOME
		
		ZAO->(dbSetOrder(1)) //FILIAL + NUM
		ZAP->(dbSetOrder(1)) //FILIAL + NUM + ITEM

		//percorre a query enquanto for o mesmo cliente
		While TRA1->ZAO_CLIENT==SA1->A1_COD .AND. TRA1->ZAO_LOJA==SA1->A1_LOJA
		
			ZAO->(dbSeek(xFilial("ZAO")+TRA1->ZAO_NUM))
			ZAP->(dbSeek(xFilial("ZAP")+TRA1->ZAP_NUM+TRA1->ZAP_ITEM))
			
			//cField1 := "TRA1->ZAP_PREV"+StrZero(Day(mv_par01-1),2)
			cField2 := "TRA1->ZAP_PREV"+StrZero(Day(mv_par01),2)
			cField3 := "TRA1->ZAP_PREV"+StrZero(Day(mv_par01+1),2)
			
			@Prow()+1, 001 psay TRA1->ZAP_PROD+Space(2)+SUBSTR(TRA1->B1_DESC,1,40)
			
			//TRA1Z O ATRASO
			nAtraso := 0
			For x:=1 to (Day(mv_par01-1))
				nAtraso += fEntr(CtoD(StrZero(x,2)+"/"+;
				                 StrZero(Month(mv_par01),2)+"/"+;
				                 StrZero(Year(mv_par01),4)))
			Next

			//TRAZ O QUE ENTREGOU ATE O DIA ANTERIOR AO DIA DO PARAMETRO
			nEntr := 0
			For x:=1 to (Day(mv_par01-1))
				nEntr += &("TRA1->ZAP_PREV"+StrZero(x,2))
			Next
            
			nAtraso := (nEntr - nAtraso) * -1

			//TRAZ O RELEASE
			nRelease := 0
			For x:=1 to 31
				nRelease += &("TRA1->ZAP_PREV"+StrZero(x,2))
			Next

			//TRAZ O SALDO
			nSaldo := 0
			For x:=1 to 31
				nSaldo += fEntr( CtoD(StrZero(x,2)+"/"+;
				                 StrZero(Month(mv_par01),2)+"/"+;
				                 StrZero(Year(mv_par01),4)))
			Next
			
			nSaldo := nRelease - nSaldo
			                           
			@Prow()  , 056 psay nAtraso         picture "@e 999,999"
			@Prow()  , 067 psay &(cField2)      picture "@e 999,999"
			@Prow()  , 080 psay &(cField3)      picture "@e 999,999"
			@Prow()  , 092 psay nSaldo          picture "@e 9,999,999"			                           
			@Prow()  , 107 psay nRelease-nSaldo picture "@e 9,999,999"
			@Prow()  , 121 psay nRelease        picture "@e 9,999,999"
		
			TRA1->(dbSkip())
		EndDo
		
		@Prow() +1 , 000 psay __PrtThinLine()
		@Prow() +1 , 001 psay ""
	     
	ENDDO

	TRA1->(DbCloseArea())
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GERA OS DADOS PARA IMPRESSÃO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery 

	cQuery := "SELECT"
	
	For x:=1 to 31
		cQuery += " ZAP.ZAP_PREV"+StrZero(x,2)+" ,"
	Next
	
	cQuery += " ZAO.ZAO_CLIENT, ZAO.ZAO_LOJA, ZAP.ZAP_PROD, B1.B1_DESC, ZAP.ZAP_ITEM, ZAO_NUM ,ZAP_NUM, ZAO_RELCLI "
	cQuery += " FROM "+RetSqlName("ZAO")+" ZAO, "+RetSqlName("ZAP")+" ZAP, "+RetSqlName("SB1")+" B1"
	cQuery += " WHERE ZAP.ZAP_NUM = ZAO.ZAO_NUM"
	cQuery += " AND B1.B1_COD = ZAP.ZAP_PROD"
	cQuery += " AND MONTH(ZAO_DTINI) = '"+StrZero(Month(mv_par01),2)+"'"
	cQuery += " AND YEAR(ZAO_DTINI) = '"+StrZero(Year(mv_par01),4)+"'"
	cQuery += " AND B1.B1_GRUPO BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND ZAO.ZAO_CLIENT BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	cQuery += " AND ZAO.ZAO_LOJA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	cQuery += " AND ZAP.D_E_L_E_T_ = '' AND ZAP.ZAP_FILIAL = '"+xFilial("ZAP")+"'"
	cQuery += " AND ZAO.D_E_L_E_T_ = '' AND ZAO.ZAO_FILIAL = '"+xFilial("ZAO")+"'"
	cQuery += " AND B1.D_E_L_E_T_  = '' AND B1.B1_FILIAL   = '"+xFilial("SB1")+"'"
	cQuery += " ORDER BY ZAO.ZAO_CLIENT+ZAO.ZAO_LOJA"

	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DBGOTOP())

Return

//*****************************************************//
// Funcao que traz a quantidade  de  pecas  que  foram //
// entregues E acumula o total de pecas entregues,     //
// usando a data da entrega como parametro             //
//*****************************************************//
Static Function fEntr(_dData)
Local _dData
Local cQuery 
Local _nQuant := 0
	
	If Select("TMR") > 0 
		TMR->(DbCloseArea())
	EndIf
	
	//VERIFICA O QUE SAIU DE PRODUTO
	cQuery := " SELECT D2.D2_DOC, SUM(D2_QUANT) AS QUANT "//FROM "+RetSqlName("SD2")+" D2 "
	cQuery += " FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SF2")+" F2 "
	cQuery += " WHERE F2.F2_DOC = D2.D2_DOC "
	cQuery += " AND F2.F2_SERIE = D2.D2_SERIE "
	cQuery += " AND F2.F2_CLIENTE = D2.D2_CLIENTE "
	cQuery += " AND F2.F2_LOJA = D2.D2_LOJA "
	cQuery += " AND D2.D2_CLIENTE = '"+ZAO->ZAO_CLIENT+"'"
	cQuery += " AND D2.D2_LOJA = '"+ZAO->ZAO_LOJA+"'"
	cQuery += " AND D2.D2_COD = '"+ZAP->ZAP_PROD+"'"
	
	If !Empty(ALLTRIM(ZAP->ZAP_PEDCLI))
		cQuery += " AND F2.F2_PCCLI = '"+ZAP->ZAP_PEDCLI+"'"
	EndIf
	
	cQuery += " AND D2.D2_EMISSAO = '"+DTOS(_dData)+"'"
	cQuery += " AND D2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND D2.D_E_L_E_T_ = ' '"
	cQuery += "	GROUP BY D2.D2_DOC"

	TCQUERY cQuery NEW ALIAS "TMR"
	  
	TMR->(DBGOTOP())
	
	WHILE TMR->(!EOF())
		
		_nQuant += TMR->QUANT
                     
    	IF SM0->M0_CODIGO == "FN"  //empresa FUNDICAO
    		
			IF !(ZAO->ZAO_CLIENT$"900004" .AND. ZAO->ZAO_LOJA$"02") .AND. ;
			   !(ZAO->ZAO_CLIENT$"900003" .AND. ZAO->ZAO_LOJA$"02") .AND. ;
			   !(ZAO->ZAO_CLIENT$"900025" .AND. ZAO->ZAO_LOJA$"02") .AND. ;
			   !(ZAO->ZAO_CLIENT$"900022" .AND. ZAO->ZAO_LOJA$"01") .AND. ;
			   !(ZAO->ZAO_CLIENT$"000012" .AND. (ZAO->ZAO_LOJA$"02" .OR. ZAO->ZAO_LOJA$"03"))

				IF Select("TMT") > 0
					TMT->(DbCloseArea("TMT"))
				ENDIF
				
				//VERIFICA O QUE HOUVE DE DEVOLUÇÃO DO PRODUTO
				cQuery2 := " SELECT SUM(D1_QUANT) AS QUANT FROM "+RetSqlName("SD1")+" D1 "
				cQuery2 += " WHERE D1.D1_TIPO = 'D' "//DEVOLUCAO
				cQuery2 += " AND D1.D1_FORMUL = 'S' "// ENTRADA COM A PRÓPRIA NOTA				
				cQuery2 += " AND D1.D1_FORNECE = '"+ZAO->ZAO_CLIENT+"'"
				cQuery2 += " AND D1.D1_LOJA = '"+ZAO->ZAO_LOJA+"'"
				cQuery2 += " AND D1.D1_COD = '"+ZAP->ZAP_PROD+"'"
				cQuery2 += " AND D1.D1_NFORI = '"+TMR->D2_DOC+"'"
				cQuery2 += " AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"
				cQuery2 += " AND D1.D_E_L_E_T_ = ' '"
			
				TCQUERY cQuery2 NEW ALIAS "TMT"
		
				If !Empty(TMT->QUANT)
					_nQuant -= TMT->QUANT
				EndIf	
			EndIf	
		EndIf	
		TMR->(DBSKIP())
	ENDDO

Return(_nQuant)