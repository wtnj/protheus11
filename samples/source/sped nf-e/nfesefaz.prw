#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XmlNFeSef ³ Autor ³ Eduardo Riera         ³ Data ³13.02.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para geracao da Nota Fiscal Eletronica do ³±±
±±³          ³SEFAZ - Versao 2.00                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³String da Nota Fiscal Eletronica                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo da NF                                           ³±±
±±³          ³       [0] Entrada                                          ³±±
±±³          ³       [1] Saida                                            ³±±
±±³          ³ExpC2: Serie da NF                                          ³±±
±±³          ³ExpC3: Numero da nota fiscal                                ³±±
±±³          ³ExpC4: Codigo do cliente ou fornecedor                      ³±±
±±³          ³ExpC5: Loja do cliente ou fornecedor                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function XmlNfeSef(cTipo,cSerie,cNota,cClieFor,cLoja)

Local nX        := 0

Local oWSNfe   

Local cString   := ""
Local cAliasSE1 := "SE1"
Local cAliasSD1 := "SD1"
Local cAliasSD2 := "SD2"
Local cNatOper  := ""
Local cModFrete := ""
Local cScan     := ""
Local cEspecie  := ""
Local cMensCli  := ""
Local cMensFis  := ""
Local cNFe      := ""

Local lQuery    := .F.

Local aNota     := {}
Local aDupl     := {}
Local aDest     := {}
Local aEntrega  := {}
Local aProd     := {}
Local aICMS     := {}
Local aICMSST   := {}
Local aIPI      := {}
Local aTotal    := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local aISS      := {}
Local aTransp   := {}
Local aImp      := {}
Local aVeiculo  := {}
Local aReboque  := {}
Local aEspVol   := {}
Local aNfVinc   := {}
Local aOldReg   := {}
Local aOldReg2  := {}

Private aUF     := {}

DEFAULT cTipo   := PARAMIXB[1]
DEFAULT cSerie  := PARAMIXB[2]
DEFAULT cNota   := PARAMIXB[3]
DEFAULT cClieFor:= PARAMIXB[4]
DEFAULT cLoja   := PARAMIXB[5]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})

If cTipo == "1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona NF                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(1)
	MsSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)	
	aadd(aNota,SF2->F2_SERIE)
	aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_DOC)
	aadd(aNota,SF2->F2_EMISSAO)
	aadd(aNota,cTipo)
	aadd(aNota,SF2->F2_TIPO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona cliente ou fornecedor                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If !SF2->F2_TIPO $ "DB" 
	    dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		
		aadd(aDest,AllTrim(SA1->A1_CGC))
		aadd(aDest,AllTrim(SA1->A1_NOME))
		aadd(aDest,AllTrim(FisGetEnd(SA1->A1_END)[1]))
		aadd(aDest,Convtype(FisGetEnd(SA1->A1_END)[2]))
		aadd(aDest,AllTrim(FisGetEnd(SA1->A1_END)[4]))
		aadd(aDest,AllTrim(SA1->A1_BAIRRO))
		aadd(aDest,SA1->A1_COD_MUN)
		aadd(aDest,AllTrim(SA1->A1_MUN))
		aadd(aDest,Upper(SA1->A1_EST))
		aadd(aDest,SA1->A1_CEP)
		aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
		aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR")))
		aadd(aDest,AllTrim(SA1->A1_TEL))
		aadd(aDest,VldIE(SA1->A1_INSCR))
		aadd(aDest,SA1->A1_SUFRAMA)
		
		If SF2->(FieldPos("F2_CLIENT"))<>0 .And. !Empty(SF2->F2_CLIENT+SF2->F2_LOJENT) .And. SF2->F2_CLIENT+SF2->F2_LOJENT<>SF2->F2_CLIENTE+SF2->F2_LOJA
		    dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT)
			
			aadd(aEntrega,SA1->A1_CGC)
			aadd(aEntrega,AllTrim(FisGetEnd(SA1->A1_END)[1]))
			aadd(aEntrega,Convtype(FisGetEnd(SA1->A1_END)[2]))
			aadd(aEntrega,AllTrim(FisGetEnd(SA1->A1_END)[4]))
			aadd(aEntrega,AllTrim(SA1->A1_BAIRRO))
			aadd(aEntrega,SA1->A1_COD_MUN)
			aadd(aEntrega,AllTrim(SA1->A1_MUN))
			aadd(aEntrega,Upper(SA1->A1_EST))
			
		EndIf
				
	Else
	    dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)	

		aadd(aDest,AllTrim(SA2->A2_CGC))
		aadd(aDest,SA2->A2_NOME)
		aadd(aDest,AllTrim(FisGetEnd(SA2->A2_END)[1]))
		aadd(aDest,ConvType(FisGetEnd(SA2->A2_END)[2]))
		aadd(aDest,AllTrim(FisGetEnd(SA2->A2_END)[4]))
		aadd(aDest,SA2->A2_BAIRRO)
		aadd(aDest,SA2->A2_COD_MUN)
		aadd(aDest,SA2->A2_MUN)
		aadd(aDest,Upper(SA2->A2_EST))
		aadd(aDest,SA2->A2_CEP)
		aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
		aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
		aadd(aDest,SA2->A2_TEL)
		aadd(aDest,VldIE(SA2->A2_INSCR))
		aadd(aDest,"")//SA2->A2_SUFRAMA

	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona transportador                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SF2->F2_TRANSP)
		dbSelectArea("SA4")
		dbSetOrder(1)
		MsSeek(xFilial("SA4")+SF2->F2_TRANSP)
		
		aadd(aTransp,SA4->A4_CGC)
		aadd(aTransp,SA4->A4_NOME)
		aadd(aTransp,SA4->A4_INSEST)
		aadd(aTransp,SA4->A4_END)
		aadd(aTransp,SA4->A4_MUN)
		aadd(aTransp,Upper(SA4->A4_EST)	)

		If !Empty(SF2->F2_VEICUL1)
			dbSelectArea("DA3")
			dbSetOrder(1)
			MsSeek(xFilial("DA3")+SF2->F2_VEICUL1)
			
			aadd(aVeiculo,DA3->DA3_PLACA)
			aadd(aVeiculo,DA3->DA3_ESTPLA)
			aadd(aVeiculo,"")
			
			If !Empty(SF2->F2_VEICUL2)
			
				dbSelectArea("DA3")
				dbSetOrder(1)
				MsSeek(xFilial("DA3")+SF2->F2_VEICUL2)
			
				aadd(aReboque,DA3->DA3_PLACA)
				aadd(aReboque,DA3->DA3_ESTPLA)
				aadd(aReboque,"")
				
			EndIf					
		EndIf
	EndIf
	dbSelectArea("SF2")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Volumes                                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cScan := "1"
	While ( !Empty(cScan) )
		cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
		If !Empty(cEspecie)
			nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
			If ( nScan==0 )
				aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
			Else
				aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
			EndIf
		EndIf
		cScan := Soma1(cScan,1)
		If ( FieldPos("F2_ESPECI"+cScan) == 0 )
			cScan := ""
		EndIf
	EndDo	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Procura duplicatas                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SF2->F2_DUPL)	
		dbSelectArea("SE1")
		dbSetOrder(1)	
		#IFDEF TOP
			lQuery  := .T.
			cAliasSE1 := GetNextAlias()
			BeginSql Alias cAliasSE1
				COLUMN E1_VENCORI AS DATE
				SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR
				FROM %Table:SE1% SE1
				WHERE
				SE1.E1_FILIAL = %xFilial:SE1% AND
				SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
				SE1.E1_NUM = %Exp:SF2->F2_DOC% AND 
				SE1.E1_TIPO = %Exp:MVNOTAFIS% AND 
				SE1.%NotDel%
				ORDER BY %Order:SE1%
			EndSql
			
		#ELSE
			MsSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
		#ENDIF
		While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
			SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
			SF2->F2_DOC == (cAliasSE1)->E1_NUM
			If (cAliasSE1)->E1_TIPO == MVNOTAFIS
			
				aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI,(cAliasSE1)->E1_VALOR})
			
			EndIf
			dbSelectArea(cAliasSE1)
			dbSkip()
	    EndDo
	    If lQuery
	    	dbSelectArea(cAliasSE1)
	    	dbCloseArea()
	    	dbSelectArea("SE1")
	    EndIf	    
	Else
		aDupl := {}
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa itens de nota                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	dbSelectArea("SD2")
	dbSetOrder(3)	
	#IFDEF TOP
		lQuery  := .T.
		cAliasSD2 := GetNextAlias()
		BeginSql Alias cAliasSD2
			SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
				D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_DESCON,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT
			FROM %Table:SD2% SD2
			WHERE
			SD2.D2_FILIAL = %xFilial:SD2% AND
			SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
			SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
			SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
			SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
			SD2.%NotDel%
			ORDER BY %Order:SD2%
		EndSql
			
	#ELSE
		MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	#ENDIF
		While !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
			SF2->F2_DOC == (cAliasSD2)->D2_DOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica a natureza da operacao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(cNatOper)
				dbSelectArea("SF4")
				dbSetOrder(1)
				If MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)				
					cNatOper := SF4->F4_TEXTO
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((cAliasSD2)->D2_NFORI) 
				If (cAliasSD2)->D2_TIPO $ "DB"
					dbSelectArea("SD1")
					dbSetOrder(1)
					If MsSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",SA1->A1_CGC,SA2->A2_CGC),SF1->F1_EST,SF1->F1_NFELETR})
					EndIf
				Else
					aOldReg  := SD2->(GetArea())
					aOldReg2 := SF2->(GetArea())
					dbSelectArea("SD2")
					dbSetOrder(3)
					If MsSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,IIF(SD2->D2_TIPO $ "DB",SA1->A1_CGC,SA2->A2_CGC),SF2->F2_EST,SF2->F2_NFELETR})
					EndIf					
					RestArea(aOldReg)
					RestArea(aOldReg2)
				EndIf				
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem os dados do produto                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
			
			dbSelectArea("SB5")
			dbSetOrder(1)
			MsSeek(xFilial("SB5")+(cAliasSD2)->D2_COD)
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)			
			
			dbSelectArea("SC5")                         
			dbSetOrder(1)
			MsSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
			
			If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
				cMensCli += AllTrim(SC5->C5_MENNOTA)
			EndIf
			If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
				cMensFis += AllTrim(FORMULA(SC5->C5_MENPAD))
			EndIf
						
			cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")
						
			aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD2)->D2_COD,;
							IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
							IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),;
							SB1->B1_POSIPI,;
							SB1->B1_EX_NCM,;
							(cAliasSD2)->D2_CF,;
							SB1->B1_UM,;
							(cAliasSD2)->D2_QUANT,;
							(cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON,;
							IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
							IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD2)->D2_QUANT,SB5->B5_CONVDIPI*(cAliasSD2)->D2_QUANT),;
							(cAliasSD2)->D2_VALFRE,;
							(cAliasSD2)->D2_SEGURO,;
							(cAliasSD2)->D2_DESCON})

			aadd(aICMS,{})
			aadd(aIPI,{})
			aadd(aICMSST,{})
			
			dbSelectArea("LF2")
			dbSetOrder(1)
			MsSeek(xFilial("LF2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR((cAliasSD2)->D2_ITEM,4)+(cAliasSD2)->D2_COD)
			While !Eof() .And. xFilial("LF2") == LF2->LF2_FILIAL .And.;
				"S" == LF2->LF2_TPMOV .And.;
				SF2->F2_SERIE == LF2->LF2_SERIE .And.;
				SF2->F2_DOC == LF2->LF2_DOC .And.;
				SF2->F2_CLIENTE == LF2->LF2_CODCLI .And.;
				SF2->F2_LOJA == LF2->LF2_LOJCLI .And.;
				(cAliasSD2)->D2_ITEM == SubStr(LF2->LF2_ITEM,1,Len((cAliasSD2)->D2_ITEM)) .And.;
				(cAliasSD2)->D2_COD == LF2->LF2_CODPRO
				
				Do Case
					Case AllTrim(LF2->LF2_IMP) == "ICM"
						aTail(aICMS) := {LF2->LF2_ORIGEM,LF2->LF2_CST,LF2->LF2_MODBC,LF2->LF2_PREDBC,LF2->LF2_BC,LF2->LF2_ALIQ,LF2->LF2_VLTRIB,0}
						aTotal[01]   += LF2->LF2_BC
						aTotal[02]   += LF2->LF2_VLTRIB
					Case AllTrim(LF2->LF2_IMP) == "SOL"
						aTail(aICMSST) := {LF2->LF2_ORIGEM,LF2->LF2_CST,LF2->LF2_MODBC,LF2->LF2_PREDBC,LF2->LF2_BC,LF2->LF2_ALIQ,LF2->LF2_VLTRIB,LF2->LF2_MVA}
						aTotal[03]   += LF2->LF2_BC
						aTotal[04]   += LF2->LF2_VLTRIB
					Case AllTrim(LF2->LF2_IMP) == "IPI"
						aTail(aIPI) := {"","",0,"999",LF2->LF2_CST,LF2->LF2_BC,LF2->LF2_QTRIB,LF2->LF2_PAUTA,LF2->LF2_ALIQ,LF2->LF2_VLTRIB}
						aTotal[09] += LF2->LF2_VLTRIB
					Case LF2->LF2_IMP == "ISS"
						If Empty(aISS)
							aISS := {0,0,0,0,0}
						EndIf
						aISS[01] += (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
						aISS[02] += LF2->LF2_BC
						aISS[03] += LF2->LF2_VLTRIB					
					Case LF2->LF2_IMP == "PS2"
						aTotal[10] += LF2->LF2_VLTRIB
					Case LF2->LF2_IMP == "CF2"
						aTotal[11] += LF2->LF2_VLTRIB
				EndCase			
				
				dbSelectArea("LF2")
				dbSkip()
			EndDo
									
			aTotal[05] += (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
			aTotal[06] += (cAliasSD2)->D2_VALFRE
			aTotal[07] += (cAliasSD2)->D2_SEGURO
			aTotal[08] += (cAliasSD2)->D2_DESCON
			aTotal[12] += (cAliasSD2)->D2_DESPESA
			aTotal[13] += (cAliasSD2)->D2_VALBRUT	

			dbSelectArea(cAliasSD2)
			dbSkip()
	    EndDo	
	    If lQuery
	    	dbSelectArea(cAliasSD2)
	    	dbCloseArea()
	    	dbSelectArea("SD2")
	    EndIf
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	MsSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
	
	aadd(aNota,SF1->F1_SERIE)
	aadd(aNota,IIF(Len(SF1->F1_DOC)==6,"000","")+SF1->F1_DOC)
	aadd(aNota,SF1->F1_EMISSAO)
	aadd(aNota,cTipo)
	aadd(aNota,SF1->F1_TIPO)
	
	aadd(aDest,AllTrim(SM0->M0_CGC))
	aadd(aDest,SM0->M0_NOMECOM)
	aadd(aDest,AllTrim(FisGetEnd(SM0->M0_ENDCOB)[1]))
	aadd(aDest,ConvType(FisGetEnd(SM0->M0_ENDCOB)[2]))
	aadd(aDest,AllTrim(FisGetEnd(SM0->M0_ENDCOB)[4]))
	aadd(aDest,SM0->M0_BAIRCOB)
	aadd(aDest,SM0->M0_CODMUN)                                                                                                                 
	aadd(aDest,SM0->M0_CIDCOB)
	aadd(aDest,SM0->M0_ESTCOB)
	aadd(aDest,SM0->M0_CEPCOB)
	aadd(aDest,"1058")
	aadd(aDest,"BRASIL")
	aadd(aDest,SM0->M0_TEL)
	aadd(aDest,VldIE(SM0->M0_INSC))
	aadd(aDest,SM0->M0_INS_SUF)	
	
	If SF1->F1_TIPO $ "DB" 
	    dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)	
	Else
	    dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)	
	EndIf

	dbSelectArea("SD1")
	dbSetOrder(1)	
	#IFDEF TOP
		lQuery  := .T.
		cAliasSD1 := GetNextAlias()
		BeginSql Alias cAliasSD1
			SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_CODIGO,D1_TES
			FROM %Table:SD1% SD1
			WHERE
			SD1.D1_FILIAL = %xFilial:SD1% AND
			SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND 
			SD1.D1_DOC = %Exp:SF1->F1_DOC% AND 
			SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND 
			SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND 
			SD1.D1_FORMUL = 'S' AND 
			SD1.%NotDel%
			ORDER BY %Order:SD1%
		EndSql
			
	#ELSE
		MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	#ENDIF
		While !Eof() .And. xFilial("SD1") == (cAliasSD1)->D1_FILIAL .And.;
			SF1->F1_SERIE == (cAliasSD1)->D1_SERIE .And.;
			SF1->F1_DOC == (cAliasSD1)->D1_DOC .And.;
			SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
			SF1->F1_LOJA ==  (cAliasSD1)->D1_LOJA
			
			If Empty(cNatOper)
				dbSelectArea("SF4")
				dbSetOrder(1)
				If MsSeek(xFilial("SF4")+(cAliasSD1)->D1_TES)				
					cNatOper := SF4->F4_TEXTO					
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica as notas vinculadas                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !Empty((cAliasSD1)->D1_NFORI) 
				If !(cAliasSD1)->D1_TIPO $ "DB"
					aOldReg  := SD1->(GetArea())
					aOldReg2 := SF1->(GetArea())
					dbSelectArea("SD1")
					dbSetOrder(1)
					If MsSeek(xFilial("SD1")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
						dbSelectArea("SF1")
						dbSetOrder(1)
						MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
						If SD1->D1_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",SA1->A1_CGC,SA2->A2_CGC),SF1->F1_EST,SF1->F1_NFELETR})
					EndIf
					RestArea(aOldReg)
					RestArea(aOldReg2)
				Else					
					dbSelectArea("SD2")
					dbSetOrder(3)
					If MsSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEMORI)
						dbSelectArea("SF2")
						dbSetOrder(1)
						MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						If !SD2->D2_TIPO $ "DB"
							dbSelectArea("SA1")
							dbSetOrder(1)
							MsSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						Else
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
						EndIf
						
						aadd(aNfVinc,{SD2->D2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,IIF(SD2->D2_TIPO $ "DB",SA1->A1_CGC,SA2->A2_CGC),SM0->M0_ESTCOB,SF2->F2_NFELETR})
						
					EndIf
				EndIf
				
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Obtem os dados do produto                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+(cAliasSD1)->D1_COD)
			
			dbSelectArea("SB5")
			dbSetOrder(1)
			MsSeek(xFilial("SB5")+(cAliasSD1)->D1_COD)
								
			cModFrete := IIF(SF1->F1_FRETE>0,"0","1")
						
			aadd(aProd,	{Len(aProd)+1,;
							(cAliasSD1)->D1_COD,;
							IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
							SB1->B1_DESCRI,;
							SB1->B1_POSIPI,;
							SB1->B1_EX_NCM,;
							(cAliasSD1)->D1_CF,;
							SB1->B1_UM,;
							(cAliasSD1)->D1_QUANT,;
							(cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_VALDESC,;
							IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
							IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD1)->D1_QUANT,SB5->B5_CONVDIPI*(cAliasSD1)->D1_QUANT),;
							(cAliasSD1)->D1_VALFRE,;
							(cAliasSD1)->D1_SEGURO,;
							(cAliasSD1)->D1_VALDESC})

			aadd(aICMS,{})
			aadd(aIPI,{})
			aadd(aICMSST,{})
			
			dbSelectArea("LF2")
			dbSetOrder(2)
			MsSeek(xFilial("LF2")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+PadR((cAliasSD1)->D1_ITEM,4)+(cAliasSD1)->D1_COD)
			While !Eof() .And. xFilial("LF2") == LF2->LF2_FILIAL .And.;
				"E" == LF2->LF2_TPMOV .And.;
				SF1->F1_SERIE == LF2->LF2_SERIE .And.;
				SF1->F1_DOC == LF2->LF2_DOC .And.;
				SF1->F1_FORNECE == LF2->LF2_CODFOR .And.;
				SF1->F1_LOJA == LF2->LF2_LOJFOR .And.;
				(cAliasSD1)->D1_ITEM == SubStr(LF2->LF2_ITEM,1,Len((cAliasSD1)->D1_ITEM)) .And.;
				(cAliasSD1)->D1_COD == LF2->LF2_CODPRO
				
				Do Case
					Case AllTrim(LF2->LF2_IMP) == "ICM"
						aTail(aICMS) := {LF2->LF2_ORIGEM,LF2->LF2_CST,LF2->LF2_MODBC,LF2->LF2_PREDBC,LF2->LF2_BC,LF2->LF2_ALIQ,LF2->LF2_VLTRIB,0}
						aTotal[01]   += LF2->LF2_BC
						aTotal[02]   += LF2->LF2_VLTRIB
					Case AllTrim(LF2->LF2_IMP) == "SOL"
						aTail(aICMSST) := {LF2->LF2_ORIGEM,LF2->LF2_CST,LF2->LF2_MODBC,LF2->LF2_PREDBC,LF2->LF2_BC,LF2->LF2_ALIQ,LF2->LF2_VLTRIB,LF2->LF2_MVA}
						aTotal[03]   += LF2->LF2_BC
						aTotal[04]   += LF2->LF2_VLTRIB
					Case AllTrim(LF2->LF2_IMP) == "IPI"
						aTail(aIPI) := {"","",0,"999",LF2->LF2_CST,LF2->LF2_BC,LF2->LF2_QTRIB,LF2->LF2_PAUTA,LF2->LF2_ALIQ,LF2->LF2_VLTRIB}
						aTotal[09] += LF2->LF2_VLTRIB
					Case LF2->LF2_IMP == "ISS"
						If Empty(aISS)
							aISS := {0,0,0,0,0}
						EndIf
						aISS[01] += (cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_VALDESC
						aISS[02] += LF2->LF2_BC
						aISS[03] += LF2->LF2_VLTRIB					
					Case LF2->LF2_IMP == "PS2"
						aTotal[10] += LF2->LF2_VLTRIB
					Case LF2->LF2_IMP == "CF2"
						aTotal[11] += LF2->LF2_VLTRIB
				EndCase			
				dbSelectArea("LF2")
				dbSkip()
			EndDo						

			aTotal[05] += (cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_VALDESC
			aTotal[06] += (cAliasSD1)->D1_VALFRE
			aTotal[07] += (cAliasSD1)->D1_SEGURO
			aTotal[08] += (cAliasSD1)->D1_VALDESC
			aTotal[12] += (cAliasSD1)->D1_DESPESA
			aTotal[13] += (cAliasSD1)->D1_TOTAL+(cAliasSD1)->D1_VALFRE+(cAliasSD1)->D1_SEGURO+(cAliasSD1)->D1_DESPESA+(cAliasSD1)->D1_VALIPI+(cAliasSD1)->D1_ICMSRET
				
			dbSelectArea(cAliasSD1)
			dbSkip()
	    EndDo	
	    If lQuery
	    	dbSelectArea(cAliasSD1)
	    	dbCloseArea()
	    	dbSelectArea("SD1")
	    EndIf		

EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do arquivo XML                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := ""
cString += NfeIde(@cNFe,aNota,cNatOper,aDupl)
cString += NfeEmit()
cString += NfeDest(aDest)
cString += NfeLocalEntrega(aEntrega)
For nX := 1 To Len(aProd)
	cString += NfeItem(aProd[nX],aICMS[nX],aICMSST[nX],aIPI[nX])
Next nX
cString += NfeTotal(aTotal,aISS)
cString += NfeTransp(cModFrete,aTransp,aImp,aVeiculo,aReboque,aEspVol)
cString += NfeCob(aDupl)
cString += NfeInfAd(cMensCli,cMensFis)
cString += "</infNFe>"
//cString += NfeRSA(cNFE)
cString := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'+cString
cString += "</NFe>"

oWsNfe := WSService():New()
oWsNfe:cargXml := cString

If oWsNfe:AssinaXML()
	cString := oWsNfe:cAssinaXMLResult
Else
	UserException("Erro durante a assinatura")
EndIf

MemoWrit("\nfe\"+cNfe+".xml",cString)

Return({cNfe,cString})


Static Function NfeIde(cChave,aNota,cNatOper,aDupl,aNfVinc)

Local cString:= ""
Local lAvista:= Len(aDupl)==1 .And. aDupl[01][02]<=DataValida(aNota[03]+1,.T.)
Local nX     := 0

cChave := aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02]+FsDateConv(aNota[03],"YYMM")+SM0->M0_CGC+"55"+StrZero(Val(aNota[01]),3)+StrZero(Val(aNota[02]),9)+Inverte(StrZero(Val(aNota[02]),Len(aNota[02])))

cString += '<infNFe versao="1.07" Id="NFe'+cChave+ConvType(Modulo11(cChave),1)+'">'
cString += '<ide>'
cString += '<cUF>'+aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02]+'</cUF>'
cString += '<cNF>'+Inverte(StrZero(Val(aNota[02]),Len(aNota[02])))+'</cNF>'
cString += '<natOp>'+ConvType(cNatOper)+'</natOp>'
cString += '<indPag>'+IIF(lAVista,"0",IIf(Len(aDupl)==0,"2","1"))+'</indPag>'
cString += '<mod>55</mod>'
cString += '<serie>'+ConvType(Val(aNota[01]),3)+'</serie>'
cString += '<nNF>'+ConvType(Val(aNota[02]),9)+'</nNF>'
cString += '<dEmi>'+ConvType(aNota[03])+'</dEmi>
cString += NfeTag('<dSaiEnt>',ConvType(aNota[03]))
cString += '<tpNF>'+aNota[04]+'</tpNF>'
cString += '<cMunFG>'+aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02]+SM0->M0_CODMUN+'</cMunFG>'
If !Empty(aNfVinc)
	For nX := 1 To Len(aNfVinc)
		If !Empty(aNfVinc[nX][06])
			cString += '<refNfe>'+aNfVin[nX][06]+'</refNfe>'
		Else
			cString += '<refNf>'
			cString += '<cUF>'+aUF[aScan(aUF,{|x| x[1] == aNfVin[nX][05]})][02]+'</cUF>'
			cString += '<AAMM>'+FsDateConv(aNfVin[nX][01],"YYMM")+'</AAMM>'
			cString += '<CNPJ>'+aNfVin[nX][04]+'</CNPJ>'
			cString += '<mod>'+AModNot(aNfVin[nX][02])+'</mod>'
			cString += '<serie>'+aNfVin[nX][02]+'</serie>'
			cString += '<nNF>'+aNfVin[nX][03]+'</nNF>'
			cString += '</refNf>'		
		EndIf
	Next nX
EndIf
cString += '<tpImp>1</tpImp>'
cString += '<tpEmis>N</tpEmis>'
cString += '<cDV>'+ConvType(Modulo11(cChave),1)+'</cDV>'
//cString += '<tpAmb>1</tpAmb>'
//cString += '<tpNFe>'+IIF(aNota[05]$"CPI","2","1")+'</tpNFe>'
cString += '</ide>'

Return( cString )

Static Function NfeEmit()

Local cString:= ""

cString := '<emit>'
cString += '<CNPJ>'+SM0->M0_CGC+'</CNPJ>
cString += '<xNome>'+ConvType(SM0->M0_NOMECOM)+'</xNome>'
cString += NfeTag('<xFant>',ConvType(SM0->M0_NOME))
cString += '<enderEmit>'
cString += '<xLgr>'+ConvType(AllTrim(FisGetEnd(SM0->M0_ENDCOB)[1]))+'</xLgr>'
cString += '<nro>'+ConvType(FisGetEnd(SM0->M0_ENDCOB)[2])+'</nro>'
cString += NfeTag('<xCpl>',ConvType(AllTrim(FisGetEnd(SM0->M0_ENDCOB)[4])))
cString += '<xBairro>'+ConvType(SM0->M0_BAIRCOB)+'</xBairro>'
cString += '<cMun>'+aUF[aScan(aUF,{|x| x[1] == SM0->M0_ESTCOB})][02]+ConvType(SM0->M0_CODMUN)+'</cMun>'
cString += '<xMun>'+ConvType(SM0->M0_CIDCOB)+'</xMun>'
cString += '<UF>'+ConvType(SM0->M0_ESTCOB)+'</UF>'
cString += NfeTag('<CEP>',ConvType(SM0->M0_CEPCOB))
cString += NfeTag('<cPais>',"1058")
cString += NfeTag('<xPais>',"BRASIL")
cString += NfeTag('<fone>',FisGetTel(SM0->M0_TEL)[3])
cString += '</enderEmit>'
cString += '<IE>'+ConvType(VldIE(SM0->M0_INSC))+'</IE>'
cString += NfeTag('<IEST>',"")
cString += NfeTag('<IM>',VldIE(SM0->M0_INSCM))
//cString += NfeTag('<CNAE>',ConvType(SM0->M0_CNAE))
cString += '</emit>'
Return(cString)

Static Function NfeDest(aDest)

Local cString:= ""

cString := '<dest>'
If Len(aDest[01])==14
	cString += '<CNPJ>'   +aDest[01]+'</CNPJ>'
ElseIf Len(aDest[01])<>0
	cString += '<CPF>'   +aDest[01]+'</CPF>'
EndIf
cString += '<xNome>'  +aDest[02]+'</xNome>'
cString += '<enderDest>'
cString += '<xLgr>'   +aDest[03]+'</xLgr>'
cString += '<nro>'    +aDest[04]+'</nro>'
cString += NfeTag('<xCpl>',aDest[05])
cString += '<xBairro>'+aDest[06]+'</xBairro>'
cString += '<cMun>'   +aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07]+'</cMun>'
cString += '<xMun>'   +aDest[08]+'</xMun>'
cString += '<UF>'     +aDest[09]+'</UF>'
cString += NfeTag('<CEP>',aDest[10])
cString += NfeTag('<cPais>',aDest[11])
cString += NfeTag('<xPais>',aDest[12])
cString += NfeTag('<fone>',FisGetTel(aDest[13])[3])
cString += '</enderDest>'
cString += '<IE>'     +aDest[14]+'</IE>'
cString += NfeTag('<ISUF>',aDest[15])
cString += '</dest>'
Return(cString)

Static Function NfeLocalEntrega(aEntrega)

Local cString:= ""

If !Empty(aEntrega)
	cString := '<entrega>'
	If Len(aEntrega[01])==14
		cString += '<CNPJ>'   +aEntrega[01]+'</CNPJ>'
	ElseIf Len(aEntrega[01])<>0
		cString += '<CPF>'   +aEntrega[01]+'</CPF>'
	EndIf
	cString += '<xLgr>'   +aEntrega[02]+'</xLgr>'
	cString += '<nro>'    +aEntrega[03]+'</nro>'
	cString += NfeTag('<xCpl>',aEntrega[04])
	cString += '<xBairro>'+aEntrega[05]+'</xBairro>'
	cString += '<cMun>'   +aUF[aScan(aUF,{|x| x[1] == aEntrega[08]})][02]+aEntrega[06]+'</cMun>'
	cString += '<xMun>'   +aEntrega[07]+'</xMun>'
	cString += '<UF>'     +aEntrega[08]+'</UF>'
	cString += '</entrega>'
EndIf
Return(cString)

Static Function NfeItem(aProd,aICMS,aICMSST,aIPI,aPIS,aPISST,aCOFINS,aCOFINSST,aISSQN)

Local cString    := ""
Local cGrupoICM  := ""
DEFAULT aICMS    := {}
DEFAULT aICMSST  := {}
DEFAULT aIPI     := {}
DEFAULT aPIS     := {}
DEFAULT aPISST   := {}
DEFAULT aCOFINS  := {}
DEFAULT aCOFINSST:= {}
DEFAULT aISSQN   := {}

cString += '<det nItem="'+ConvType(aProd[01])+'">'
cString += '<prod>'
cString += '<cProd>' +ConvType(aProd[02])+'</cProd>'
cString += '<cEAN>'  +ConvType(aProd[03])+'</cEAN>'
cString += '<xProd>' +ConvType(aProd[04])+'</xProd>'
cString += NfeTag('<NCM>',ConvType(aProd[05]))
cString += NfeTag('<EXTIPI>',ConvType(aProd[06]))
cString += NfeTag('<genero>',SubStr(ConvType(aProd[05]),1,2))
cString += '<CFOP>'  +Convtype(aProd[07])+'</CFOP>'
cString += '<uTrib>' +ConvType(aProd[11])+'</uTrib>'
cString += '<uCom>'  +ConvType(aProd[08])+'</uCom>'
cString += '<qTrib>' +ConvType(aProd[12],11,3)+'</qTrib>'
cString += '<qCom>'  +ConvType(aProd[09],11,3)+'</qCom>'
cString += '<vProd>' +ConvType(aProd[10],15,2)+'</vProd>'
cString += NfeTag('<vFrete>',ConvType(aProd[13],15,2))
cString += NfeTag('<vSeg>'  ,ConvType(aProd[14],15,2))
cString += NfeTag('<vDesc>' ,ConvType(aProd[15],15,2))
cString += '</prod>'

cString += '<imposto>'
cString += '<ICMS>'
If Len(aIcms)>0	
	cGrupoICM := Convtype(aICMS[02])	
	Do Case
		Case cGrupoICM $ "41,50"
			cGrupoICM := "40"
	EndCase
	cString += '<ICMS'    +cGrupoICM+'>'
	cString += '<orig>'   +ConvType(aICMS[01])+'</orig>'
	cString += '<CST>'    +ConvType(aICMS[02])+'</CST>'	
	If aICMS[02]$"00,10,20,51,70,90"
		cString += '<modBC>'  +ConvType(aICMS[03])+'</modBC>'
	EndIf
	If aICMS[02]$"20,51,70,90"
		cString += '<pRedBC>'+ConvType(aICMS[04],5,2)+'</vBC>'
	EndIf
	If aICMS[02]$"00,10,20,51,70,90"
		cString += '<vBC>'    +ConvType(aICMS[05],15,2)+'</vBC>'
		cString += '<pICMS>'  +ConvType(aICMS[06],5,2)+'</pICMS>'
		cString += '<vICMS>'  +ConvType(aICMS[07],15,2)+'</vICMS>'
	EndIf
	If aICMS[02]$"10,30,70,90"
		cString += '<modBCST>'+ConvType(aICMSST[03])+'</modBCST>'
		cString += NfeTag('<pMVAST>'  ,ConvType(aICMSST[08],5,2))
		cString += NfeTag('<pRedBCST>',ConvType(aICMSST[04],15,2))
	EndIf
	If aICMS[02]$"10,30,60,70,90"
		cString += '<vBCST>'  +ConvType(aICMSST[05],15,2)+'</vBCST>'
	EndIf
	If aICMS[02]$"10,30,70,90"
		cString += '<pICMSST>'+ConvType(aICMSST[06],5,2)+'</pICMSST>'
	EndIf
	If aICMS[02]$"10,30,60,70,90"
		cString += '<vICMSST>'+ConvType(aICMS[07],15,2)+'</vICMSST>'
	EndIf
	cString += '</ICMS'   +cGrupoICM+'>'
Else
	cString += '<ICMS40>'
	cString += '<orig>0</orig>'
	cString += '<CST>50</CST>'	
	cString += '</ICMS40>'
EndIf
cString += '</ICMS>'
If Len(aIPI)>0 
	cString += '<IPI>'
	cString += NfeTag('<clEnq>',ConvType(AIPI[01]))
	cString += NfeTag('<cSelo>',ConvType(AIPI[02]))
	cString += NfeTag('<qSelo>',ConvType(AIPI[03]))
	cString += NfeTag('<cEnq>' ,ConvType(AIPI[04]))
	If AIPI[05] $ "00,49,50,99"
		cString += '<IPITrib>'
		cString += '<CST>'  +ConvType(AIPI[05])+'</CST>'
		cString += '<vBC>'  +ConvType(AIPI[06],15,2)+'</vBC>'
		cString += NfeTag('<qUnid>',ConvType(AIPI[07],15,3))
		cString += NfeTag('<vUnid>',ConvType(AIPI[08],15,4))
		cString += NfeTag('<pIPI>' ,ConvType(AIPI[09],5,2))
		cString += NfeTag('<vIPI>' ,ConvType(AIPI[10],15,2))
		cString += '</IPITrib>'
	Else
		cString += '<IPINT>'
		cString += '<CST>'+AIPI[05]+'</CST>'
		cString += '</IPINT>'	
	EndIf
	cString += '</IPI>'
EndIf
cString += '<PIS>'
If Len(aPIS)>0
	If aPIS[01] $ "01"
		cString += '<PISAliq>'
		cString += '<CST>'    +aPIS[01]+'</CST>'
		cString += '<vBC>'    +aPIS[02]+'</vBC>'
		cString += '<pPIS>'   +aPIS[03]+'</pPIS>'
		cString += '<vPIS>'   +aPIS[04]+'</vPIS>'
		cString += '</PISAliq>'
	EndIf
	If aPIS[01] $ "03"
		cString += '<PISQtde>'
		cString += '<CST>'    +aPIS[01]+'</CST>'
		cString += '<qBCProd>'    +aPIS[05]+'</qBCProd>'
		cString += '<vAliqProd>'  +aPIS[06]+'</vAliqProd>'
		cString += '<vPIS>'   +aPIS[04]+'</vPIS>'
		cString += '</PISQtde>'
	EndIf
	If aPIS[01] $ "04,06,07,08,09"
		cString += '<PISNT>'
		cString += '<CST>'    +aPIS[01]+'</CST>'
		cString += '</PISNT>'
	EndIf
	If aPIS[01] $ "99"
		cString += '<PISOutr>'
		cString += '<CST>'    +aPIS[01]+'</CST>'		
		If !Empty(aPIS[02])
			cString += '<vBC>'      +aPIS[02]+'</vBC>'
			cString += '<pPIS>'     +aPIS[03]+'</pPIS>'
		Else
			cString += '<qBCProd>'  +aPIS[05]+'</vBC>'
			cString += '<vAliqProd>'+aPIS[06]+'</vAliqProd>		
		EndIf
		cString += '<vPIS>'   +aPIS[06]+'</vPIS>'		
		cString += '</PISOutr>'
	EndIf

Else
	cString += '<PISNT>'
	cString += '<CST>08</CST>'
	cString += '</PISNT>'	
EndIf
cString += '</PIS>'
If Len(aPISST)>0
	cString += '<PISST>'
	If !Empty(aPISST[01])
		cString += '<vBC>'    +aPISST[01]+'</vBC>'
		cString += '<pPIS>'   +aPISST[02]+'</pPIS>'
	Else
		cString += '<qBCProd>'+aPISST[03]+'</vBC>'
		cString += '<vAliqProd>'   +aPISST[04]+'</vAliqProd>		
	EndIf
	cString += '<vPIS>'   +aPISST[05]+'</vPIS>'			
	cString += '</PISST>'
EndIf
cString += '<COFINS>'
If Len(aCOFINS)>0
	If aCOFINS[01] $ "01,02"
		cString += '<COFINSAliq>'
		cString += '<CST>'       +aCOFINS[01]+'</CST>'
		cString += '<vBC>'       +aCOFINS[02]+'</vBC>'
		cString += '<pCOFINS>'   +aCOFINS[03]+'</pCOFINS>'
		cString += '<vCOFINS>'   +aCOFINS[04]+'</vCOFINS>'
		cString += '</COFINSAliq>'
	EndIf
	If aCOFINS[01] $ "03"
		cString += '<COFINSQtde>'
		cString += '<CST>'    +aCOFINS[01]+'</CST>'
		cString += '<qBCProd>'    +aCOFINS[05]+'</qBCProd>'
		cString += '<vAliqProd>'  +aCOFINS[06]+'</vAliqProd>'
		cString += '<vCOFINS>'   +aCOFINS[04]+'</vCOFINS>'
		cString += '</COFINSQtde>'
	EndIf
	If aCOFINS[01] $ "04,06,07,08,09"
		cString += '<COFINSNT>'
		cString += '<CST>'    +aCOFINS[01]+'</CST>'
		cString += '</COFINSNT>'
	EndIf
	If aCOFINS[01] $ "99"
		cString += '<COFINSOutr>'
		cString += '<CST>'    +aCOFINS[01]+'</CST>'		
		If !Empty(aCOFINS[02])
			cString += '<vBC>'      +aCOFINS[02]+'</vBC>'
			cString += '<pCOFINS>'  +aCOFINS[03]+'</pCOFINS>'
		Else
			cString += '<qBCProd>'  +aCOFINS[05]+'</vBC>'
			cString += '<vAliqProd>'+aCOFINS[06]+'</vAliqProd>		
		EndIf
		cString += '<vCOFINS>'   +aCOFINS[06]+'</vCOFINS>'		
		cString += '</COFINSOutr>'
	EndIf
Else
	cString += '<COFINSNT>'
	cString += '<CST>08</CST>'
	cString += '</COFINSNT>'
EndIf
cString += '</COFINS>'
If Len(aCOFINSST)>0
	cString += '<COFINSST>'
	If !Empty(aCOFINSST[01])
		cString += '<vBC>'       +aCOFINSST[01]+'</vBC>'
		cString += '<pCOFINS>'   +aCOFINSST[02]+'</pCOFINS>'
	Else
		cString += '<qBCProd>'   +aCOFINSST[03]+'</vBC>'
		cString += '<vAliqProd>' +aCOFINSST[04]+'</vAliqProd>		
	EndIf
	cString += '<vCOFINS>'       +aCOFINSST[05]+'</vCOFINS>'
	cString += '</COFINSST>'
EndIf
If Len(aISSQN)>0
	cString += '<ISSQN>'
	cString += '<vBC>'      +aISSQN[01]+'</vBC>'
	cString += '<vAliq>'    +aISSQN[02]+'</vAliq>'
	cString += '<vISSQN>'   +aISSQN[03]+'</vISSQN>'
	cString += '<cMunFG>'   +aISSQN[04]+'</cMunFG>'
	cString += '<cListServ>'+aISSQN[05]+'</cListServ>'
	cString += '</ISSQN>'
EndIf
cString += '</imposto>'
cString += '</det>'

Static Function NfeTotal(aTotal,aISS,aRet)

Local cString:=""
DEFAULT aISS := {}
DEFAULT aRet := {}

cString += '<total>'
cString += '<ICMSTot>'
cString += '<vBC>'    +ConvType(aTotal[01],15,2)+'</vBC>'
cString += '<vICMS>'  +ConvType(aTotal[02],15,2)+'</vICMS>'
cString += '<vBCST>'  +ConvType(aTotal[03],15,2)+'</vBCST>'
cString += '<vST>'    +ConvType(aTotal[04],15,2)+'</vST>'
cString += '<vProd>'  +ConvType(aTotal[05],15,2)+'</vProd>'
cString += '<vFrete>' +ConvType(aTotal[06],15,2)+'</vFrete>'
cString += '<vSeg>'   +ConvType(aTotal[07],15,2)+'</vSeg>'
cString += '<vDesc>'  +ConvType(aTotal[08],15,2)+'</vDesc>'
cString += '<vII>'    +ConvType(aTotal[14],15,2)+'</vII>'
cString += '<vIPI>'   +ConvType(aTotal[09],15,2)+'</vIPI>'
cString += '<vPIS>'   +ConvType(aTotal[10],15,2)+'</vPIS>'
cString += '<vCOFINS>'+ConvType(aTotal[11],15,2)+'</vCOFINS>'
cString += '<vOutro>' +ConvType(aTotal[12],15,2)+'</vOutro>'
cString += '<vNF>'    +ConvType(aTotal[13],15,2)+'</vNF>'
If Len(aISS)>0
	cString += '<ISSQNtot>'
		cString += NfeTag('<vServ>'  ,ConvType(aISS[01],15,2))
		cString += NfeTag('<vBC>'    ,ConvType(aISS[02],15,2))
		cString += NfeTag('<vISS>'   ,ConvType(aISS[03],15,2))
		cString += NfeTag('<vPIS>'   ,ConvType(aISS[04],15,2))
		cString += NfeTag('<vCOFINS>',ConvType(aISS[05],15,2))
	cString += '</ISSQNtot>'
EndIf
If Len(aRet)>0
	cString += '<retTrib>'
	cString += NfeTag('<vRetPIS>'   ,ConvType(aRet[01],15,2))
	cString += NfeTag('<vRetCOFINS>',ConvType(aRet[02],15,2))
	cString += NfeTag('<vRetCSLL>'  ,ConvType(aRet[03],15,2))
	cString += NfeTag('<vBCIRRF>'   ,ConvType(aRet[04],15,2))
	cString += NfeTag('<vIRRF>'     ,ConvType(aRet[05],15,2))
	cString += NfeTag('<vBCRetPrev>',ConvType(aRet[06],15,2))
	cString += NfeTag('<vRetPrev>'  ,ConvType(aRet[07],15,2))
	cString += '</retTrib>'
EndIf
cString += '</ICMSTot>'
cString += '</total>'
Return(cString)

Static Function NfeTransp(cModFrete,aTransp,aImp,aVeiculo,aReboque,aVol)
           
Local nX := 0
Local cString := ""

DEFAULT aTransp := {}
DEFAULT aImp    := {}
DEFAULT aVeiculo:= {}
DEFAULT aReboque:= {}
DEFAULT aVol    := {}

cString += '<transp>'
cString += '<modFrete>'+cModFrete+'</modFrete>'
If Len(aTransp)>0
	cString += '<transporta>'
		If Len(aTransp[01])==14
			cString += NfeTag('<CNPJ>',aTransp[01])
		ElseIf Len(aTransp[01])<>0
			cString += NfeTag('<CPF>',aTransp[01])
		EndIf
		cString += NfeTag('<xNome>' ,Convtype(aTransp[02]))
		cString += NfeTag('<IE>'    ,aTransp[03])
		cString += NfeTag('<xEnder>',Convtype(aTransp[04]))
		cString += NfeTag('<xMun>'  ,Convtype(aTransp[05]))
		cString += NfeTag('<UF>'    ,Convtype(aTransp[06]))
	cString += '</transporta>'
	If Len(aImp)>0
		cString += '<retTransp>'
			cString += '<vServ>'   +aImp[01]+'</vServ>'
			cString += '<vBCRet>'  +aImp[02]+'</vBCRet>'
			cString += '<pICMSRet>'+aImp[03]+'</pICMSRet>'
			cString += '<vICMSRet>'+aImp[04]+'</vICMSRet>'
			cString += '<CFOP>'    +ConvType(aImp[05])+'</CFOP>'
			cString += '<cMunFG>'  +aImp[06]+'</cMunFG>'
		cString += '</retTransp>'
	EndIf
	If Len(aVeiculo)>0
		cString += '<veicTransp>'
			cString += '<placa>'+Convtype(aVeiculo[01])+'</placa>'
			cString += '<UF>'   +Convtype(aVeiculo[02])+'</UF>'
			cString += NfeTag('<RNTC>',Convtype(aVeiculo[03]))
		cString += '</veicTransp>'
	EndIf
	If Len(aReboque)>0
		cString += '<reboque>'
			cString += '<placa>'+Convtype(aReboque[01])+'</placa>'
			cString += '<UF>'   +Convtype(aReboque[02])+'</UF>'
			cString += NfeTag('<RNTC>',Convtype(aReboque[03]))
		cString += '</reboque>'
	EndIf	
	For nX := 1 To Len(aVol)		
		cString += '<vol>'
			cString += NfeTag('<qVol>',Convtype(aVol[nX][01],15,0))
			cString += NfeTag('<esp>' ,Convtype(aVol[nX][02]))
			//cString += '<marca>' +aVol[03]+'</marca>'
			//cString += '<nVol>'  +aVol[04]+'</nVol>'
			cString += NfeTag('<pesoL>' ,Convtype(aVol[nX][03],15,3))
			cString += NfeTag('<pesoB>' ,Convtype(aVol[nX][04],15,3))
			//cString += '<nLacre>'+aVol[07]+'</nLacre>'
		cString += '</vol>
	Next nX
EndIf
cString += '</transp>'
Return(cString)

Static Function NfeCob(aDupl)

Local cString := ""

Local nX := 0                  
If Len(aDupl)>0
	cString += '<cobr>'
	For nX := 1 To Len(aDupl)
		cString += '<dup>'
		cString += '<nDup>'+ConvType(aDupl[nX][01])+'</nDup>'
		cString += '<dVenc>'+ConvType(aDupl[nX][02])+'</dVenc>'
		cString += '<vDup>'+ConvType(aDupl[nX][03],15,2)+'</vDup>'
		cString += '</dup>'
	Next nX	
	cString += '</cobr>'
EndIf

Return(cString)

Static Function NfeInfAd(cMsgFis,cMsgCli)

Local cString := ""

If Len(cMsgFis)>0 .Or. Len(cMsgCli)>0
	cString += '<infAdic>'
	If Len(cMsgFis)>0
		cString += '<infAdFisco>'+ConvType(cMsgFis)+'</infAdFisco>'
	EndIf
	If Len(cMsgCli)>0
		cString += '<infCpl>'+ConvType(cMsgCli)+'</infCpl>'
	EndIf
	cString += '</infAdic>'
EndIf
Return(cString)

Static Function NfeRSA(cNfe)

Local cString      := ""
Local cCertificado := ""
Local cArquivo     := &(SuperGetMv("MV_CFDDIRS",,""))+SuperGetMv("MV_CFDARQS",,"eCNPJ-A1.pem")
Local cLinha       := ""
Local lcertificado := .F.

If File(cArquivo)

	FT_FUse(cArquivo)
	FT_FGotop()
	
	While !FT_FEOF()	
		cLinha := FT_FReadLn()	
		If "-----BEGIN CERTIFICATE-----"==cLinha
			lCertificado := .T.
		ElseIf "-----END CERTIFICATE-----"==cLinha
			lCertificado := .F.		
		ElseIf lCertificado
			cCertificado += cLinha
		EndIf		
		FT_FSkip()
	EndDo
	FT_FUse()
EndIf

cString += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
cString += '<SignedInfo>'
cString += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />'
cString += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />'
cString += '<Reference URI="#NFe'+cNFe+'">'
cString += '<Transforms>'
cString += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />'
cString += '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />'
cString += '</Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />'
cString += '<DigestValue>'
cString += Encode64(cNfe)
cString += '</DigestValue>'
cString += '</Reference>'
cString += '</SignedInfo>'
cString += '<SignatureValue>'
cString += Encode64(PrivSignRSA(cArquivo,cNfe,2))
cString += '</SignatureValue>
cString += '<KeyInfo>'
cString += '<X509Data>'
cString += '<X509Certificate>'+cCertificado+'</X509Certificate>'
cString += '</X509Data>'
cString += '</KeyInfo>'
cString += '</Signature>'

Return(cString)

Static Function ConvType(xValor,nTam,nDec)

Local cNovo := ""
DEFAULT nDec := 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(AllTrim(xValor),1,nTam))))
EndCase
Return(cNovo)

Static Function Inverte(uCpo)

Local cCpo	:= uCpo
Local cRet	:= ""
Local cByte	:= ""
Local nAsc	:= 0
Local nI		:= 0
Local aChar	:= {}
Local nDiv	:= 0


Aadd(aChar,	{"0", "9"})
Aadd(aChar,	{"1", "8"})
Aadd(aChar,	{"2", "7"})
Aadd(aChar,	{"3", "6"})
Aadd(aChar,	{"4", "5"})
Aadd(aChar,	{"5", "4"})
Aadd(aChar,	{"6", "3"})
Aadd(aChar,	{"7", "2"})
Aadd(aChar,	{"8", "1"})
Aadd(aChar,	{"9", "0"})

For nI:= 1 to Len(cCpo)
   cByte := Upper(Subs(cCpo,nI,1))
   If (Asc(cByte) >= 48 .And. Asc(cByte) <= 57) .Or. ;	// 0 a 9
   		(Asc(cByte) >= 65 .And. Asc(cByte) <= 90) .Or. ;	// A a Z
   		Empty(cByte)	// " "
	   nAsc	:= Ascan(aChar,{|x| x[1] == cByte})
   	If nAsc > 0
   		cRet := cRet + aChar[nAsc,2]	// Funcao Inverte e chamada pelo rdmake de conversao
	   EndIf
	Else
		// Caracteres <> letras e numeros: mantem o caracter
		cRet := cRet + cByte
	EndIf
Next
Return(cRet)

Static Function NfeTag(cTag,cConteudo)

Local cRetorno := ""
If !Empty(AllTrim(cConteudo)) .And. !AllTrim(cConteudo)=="0"
	cRetorno := cTag+AllTrim(cConteudo)+SubStr(cTag,1,1)+"/"+SubStr(cTag,2)
EndIf
Return(cRetorno)

Static Function VldIE(cInsc)

Local cRet	:=	""
Local nI	:=	1
For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
cRet := AllTrim(cRet)
If "ISENT"$Upper(cRet)
	cRet := ""
EndIf
Return(cRet)
