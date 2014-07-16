#INCLUDE "Rtmsr08.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR08  ³ Autor ³Patricia A. Salomao    ³ Data ³18.03.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da AWB                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR08                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestao de Transporte                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR08()
Local titulo   := STR0001 //"Impressao da AWB"
Local cString  := "DTV"
Local wnrel    := "RTMSR08"
Local cDesc1   := STR0002 //"Este programa ira emitir a AWB."
Local cDesc2   := ""
Local cDesc3   := ""
Local tamanho  := "P"

Private NomeProg := "RTMSR08"
Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg    := "RTMR08"
Private nLastKey := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De AWB       ?	                          ³
//³ mv_par02        	// Ate AWB      ?     	                 	  ³
//³ mv_par03        	// Tipo de LayOut     	                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("RTMR08",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR08Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR08Imp³ Autor ³Patricia A. Salomao    ³ Data ³18.03.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR08Imp(lEnd,wnRel,titulo,tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cNomAge  := GetMv("MV_AGENOM")  // Nome Agente
Local cCodIATA := GetMv("MV_AGEIAT") // Cod. IATA
Local cNumMat  := GetMv("MV_AGEMAT")  // Matricula
Local aNotas   := {}
Local aArray   := {}
Local Li       := 10
Local nLinha:=nBegin:=0
Local cCliente:=cLoja:=cForInscr:=cForCGC:=cMens:= ""
Local aAreaSA2 := SA2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local nBegin   := 0

Inclui := .F.
AADD(aArray, { SM0->M0_NOME, SM0->M0_CGC, SM0->M0_INSC, SM0->M0_ENDCOB, SM0->M0_BAIRCOB, SM0->M0_CIDCOB,;
SM0->M0_CEPCOB, SM0->M0_ESTCOB ,SM0->M0_TEL ,SM0->M0_FAX })

dbSelectArea("DTV")
dbSetOrder(1)
dbSeek(xFilial()+mv_par01, .T.)
SetRegua(LastRec())

Do While !Eof() .And. DTV_FILIAL == xFilial() .And. DTV_NUMAWB <= mv_par02
	aNotas := {}
	
	SA2->(dbSetOrder(1))
	If SA2->(MsSeek(xFilial("SA2")+DTV->DTV_CODCIA+DTV->DTV_LOJCIA)) .And. SA2->A2_TIPAWB <> mv_par03
		DTV->(dbSkip())
		Loop
	Else
		cForInscr := SA2->A2_INSCR
		cForCGC   := SA2->A2_CGC
	EndIf
	
	DTX->(dbSetOrder(4))
	DTX->(MsSeek(xFilial("DTX")+ DTV->DTV_NUMAWB) )
	Do While DTX->(!Eof()) .And. DTX->DTX_FILIAL+DTX->DTX_NUMAWB == xFilial("DTX") + DTV->DTV_NUMAWB		
		DUD->(dbSetOrder(2))
		DUD->(MsSeek(xFilial("DUD")+ DTX->DTX_FILORI + DTX->DTX_VIAGEM))		
		Do While !DUD->(Eof()) .And. DUD->DUD_FILIAL+DUD->DUD_FILORI+DUD->DUD_VIAGEM == xFilial("DUD")+ DTX->DTX_FILORI + DTX->DTX_VIAGEM
			DTC->(dbSetOrder(3))
			DTC->(MsSeek(xFilial("DTC")+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))			
			Do While !DTC->(Eof()) .And. DTC->DTC_FILIAL+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE ==xFilial("DUD")+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE
				AADD(aNotas, {DTC->DTC_NUMNFC} )
				DTC->(dbSkip())
			EndDo			
			DUD->(dbSkip())
		EndDo		
		DTX->(dbSkip())		
	EndDo   
	
	If mv_par03 == StrZero(1,Len(SA2->A2_TIPAWB))
		IncRegua()
		If Interrupcao(@lEnd)
			Exit
		Endif		
		//-- Imprime Dados do Expedidor
		@Li,010 PSay aArray[1][1] Picture PesqPict("SA1","A1_NOME")
		Imp_nota(Li,aNotas)
		VerLin(@Li,1)
		@Li,010 PSay aArray[1][2] Picture PesqPict("SA1","A1_CGC")
		VerLin(@Li,1)
		@Li,010 PSay aArray[1][3] Picture PesqPict("SA1","A1_INSCR")
		VerLin(@Li,1)
		@Li,010 PSay aArray[1][4] Picture PesqPict("SA1","A1_END")
		VerLin(@Li,1)
		@Li,010 PSay aArray[1][5] Picture PesqPict("SA1","A1_BAIRRO")
		@Li,035 PSay aArray[1][6] Picture PesqPict("SA1","A1_MUN")
		VerLin(@Li,1)
		@Li,010 PSay aArray[1][7] Picture PesqPict("SA1","A1_CEP")
		@Li,030 PSay aArray[1][8] Picture PesqPict("SA1","A1_EST")
		@Li,035 PSay aArray[1][9] Picture PesqPict("SA1","A1_TEL")
		VerLin(@Li,1)
		@Li,010 PSay aArray[1][10] Picture PesqPict("SA1","A1_FAX")
		VerLin(@Li,2)

/*		
		//-- Imprime Dados do Destinatario
		SA1->(MsSeek(xFilial()+DTV->DTV_CLIDES+DTV->DTV_LOJDES) )
		@Li,010 PSay SA1->A1_NOME Picture PesqPict("SA1","A1_NOME")
		VerLin(@Li,1)
		@Li,010 PSay SA1->A1_CGC Picture PesqPict("SA1","A1_CGC")
		VerLin(@Li,1)
		@Li,010 PSay SA1->A1_INSCR Picture PesqPict("SA1","A1_INSCR")
		@Li,070 PSay DTV->DTV_NUMAWB
		VerLin(@Li,1)
		@Li,010 PSay SA1->A1_END Picture PesqPict("SA1","A1_END")
		VerLin(@Li,1)
		@Li,010 PSay SA1->A1_BAIRRO Picture PesqPict("SA1","A1_BAIRRO")
		@Li,035 PSay SA1->A1_MUN  Picture PesqPict("SA1","A1_MUN")
		@Li,045 PSay cForInscr Picture PesqPict("SA2","A2_INSCR") // Inscricao Estadual VarigLog
		@Li,068 PSay cForCGC   Picture PesqPict("SA2","A2_CGC")   // CNPJ
		VerLin(@Li,1)
		@Li,010 PSay SA1->A1_CEP Picture PesqPict("SA1","A1_CEP")
		@Li,030 PSay SA1->A1_EST Picture PesqPict("SA1","A1_EST")
		@Li,040 PSay SA1->A1_TEL Picture PesqPict("SA1","A1_TEL")
		VerLin(@Li,1)
		@Li,010 PSay SA1->A1_FAX Picture PesqPict("SA1","A1_FAX")
*/
		//-- Imprime Dados do Destinatario
		SM0->(MsSeek(cEmpAnt+DTV->DTV_FILDES))
		@Li,010 PSay SM0->M0_NOME		Picture PesqPict('SA1','A1_NOME')
		VerLin(@Li,1)
		@Li,010 PSay SM0->M0_CGC		Picture PesqPict('SA1','A1_CGC')
		VerLin(@Li,1)
		@Li,010 PSay SM0->M0_INSC		Picture PesqPict('SA1','A1_INSCR')
		@Li,070 PSay DTV->DTV_NUMAWB
		VerLin(@Li,1)
		@Li,010 PSay SM0->M0_ENDCOB	Picture PesqPict('SA1','A1_END')
		VerLin(@Li,1)
		@Li,010 PSay SM0->M0_BAIRCOB	Picture PesqPict('SA1','A1_BAIRRO')
		@Li,035 PSay SM0->M0_CIDCOB	Picture PesqPict('SA1','A1_MUN')
		@Li,045 PSay cForInscr			Picture PesqPict('SA2','A2_INSCR') // Inscricao Estadual VarigLog
		@Li,068 PSay cForCGC				Picture PesqPict('SA2','A2_CGC')   // CNPJ
		VerLin(@Li,1)
		@Li,010 PSay SM0->M0_CEPCOB	Picture PesqPict('SA1','A1_CEP')
		@Li,030 PSay SM0->M0_ESTCOB	Picture PesqPict('SA1','A1_EST')
		@Li,040 PSay SM0->M0_TEL		Picture PesqPict('SA1','A1_TEL')
		VerLin(@Li,1)
		@Li,010 PSay SM0->M0_FAX		Picture PesqPict('SA1','A1_FAX')
		
		
		@Li,040 PSay STR0005 	 //"SEGURO PROPRIO"
		VerLin(@Li,2)
		@Li,010 PSay DTV->DTV_AERORI Picture PesqPict("DTV","DTV_AERORI") //--Origem
		DUY->(dbSetOrder(1))
		DUY->(MsSeek(xFilial("DUY")+DTV->DTV_CDRDES) )
		@Li,025 PSay DUY->DUY_DESCRI Picture PesqPict("DUY","DUY_DESCRI")	//-- Cidade de Destino
		@Li,058 PSay DTV->DTV_AERDES Picture PesqPict("DTV","DTV_AERDES")	//-- Sigla
		@Li,065 PSay DTV->DTV_CODEMB Picture PesqPict("DTV","DTV_CODEMB")	//-- Descricao das Embalagens
		VerLin(@Li,5)
		@Li,010 PSay DTV->DTV_QTDVOL Picture PesqPict("DTV","DTV_QTDVOL")	//-- Quant. de Volumes
		@Li,018 PSay DTV->DTV_PESO   Picture PesqPict("DTV","DTV_PESO")	//-- Peso Real KG
		@Li,031 PSay DTV->DTV_PESOM3 Picture PesqPict("DTV","DTV_PESOM3")	//-- Peso Taxado KG
		@Li,043 PSay DTV->DTV_AERORI+"/"+DTV->DTV_AERDES  //-- Trecho
		@Li,070 PSay DTV->DTV_DESPRO
		VerLin(@Li,5)
		If !Empty(DTV->DTV_CODOBS)
			cMens := E_MsMM(DTV->DTV_CODOBS,50)
		EndIf
		
		//-- Imprime Observacoes
		nLinha:= MLCount(cMens,40)
		@Li,035 PSAY MemoLine(cMens,40,1)
		For nBegin := 2 To nLinha
			VerLin(@Li,1)
			@Li,035 PSAY Memoline(cMens,40,nBegin)
		Next nBegin
		VerLin(@Li,2)
		@Li, 035 Psay STR0006 + " " + DTV->DTV_FILORI +" - "+ DTV->DTV_VIAGEM
		VerLin(@Li,2)
		@Li,010 PSay STR0005 //"SEGURO PROPRIO"
		VerLin(@Li,1)
		
		//-- Verifica se Retira no Aeroporto
		If DTV->DTV_RETAER == "1" // Se Sim
			@Li,040 PSay "XX"
		Else
			@Li,050 PSay "XX"
			VerLin(@Li,1)
			@Li,040 PSay DTV->DTV_LOCENT Picture PesqPict("DTV","DTV_LOCENT")	//Local de Retirada
		EndIf
		VerLin(@Li,10)
		@Li,035 PSay cNomAge	//--Nome Agente
		@Li,050 PSay cCodIATA  //--Codigo IATA
		VerLin(@Li,2)
		@Li,040 PSay DTV->DTV_DATEMI Picture PesqPict("DTV","DTV_DATEMI") //-- Data de Emissao
		@Li,060 PSay DTV->DTV_HOREMI Picture PesqPict("DTV","DTV_HOREMI") //-- Hora da Emissao
		VerLin(@Li,2)
		
		//-- Imprime a composicao do frete
		DT8->(DbSetOrder(3))
		If	DT8->(MsSeek(xFilial('DT8') + DTV->DTV_NUMAWB))
			@ Li,01 PSay RetTitle('DT3_CODPAS')
			@ Li,22 PSay RetTitle('DT8_VALPAS')
			@ Li,37 PSay RetTitle('DT8_VALIMP')
			@ Li,52 PSay RetTitle('DT8_VALPAS') + ' + ' + RetTitle('DT8_VALIMP')
			VerLin(@Li,2)
			While DT8->( ! Eof() .And. DT8->DT8_FILIAL + DT8->DT8_NUMAWB == xFilial('DT8') + DTV->DTV_NUMAWB )				
				If	DT8->DT8_CODPAS == '98'
					@ Li,01 PSay 'Seguro'
				ElseIf	DT8->DT8_CODPAS == 'TF'
					@ Li,01 PSay 'Total do Frete'
				Else
					@ Li,01 PSay Posicione('DT3', 1, xFilial('DT3') + DT8->DT8_CODPAS, 'DT3_DESCRI')
				EndIf				
				@ Li,22 PSay DT8->DT8_VALPAS Picture PesqPict('DT8','DT8_VALPAS')
				@ Li,37 PSay DT8->DT8_VALIMP Picture PesqPict('DT8','DT8_VALIMP')
				@ Li,52 PSay DT8->DT8_VALTOT Picture PesqPict('DT8','DT8_VALTOT')			
				VerLin(@Li,1)
				DT8->(DbSkip())
			EndDo
		EndIf
		VerLin(@Li,2)
		@Li,040 PSay UsrRetName(DTV->DTV_USER) //--Nome e Assinatura do Emissor
		@Li,065 PSay cNumMat //--Numero da Matricula
	EndIf
	dbSelectArea("DTV")
	dbSkip()
	Li:=10
EndDo
RestArea(aAreaSM0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea ( aAreaSA2 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VerLin    ³ Autor ³Patricia A. Salomao    ³ Data ³18.03.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Soma Linha                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VerLin(ExpN1,ExpN2)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha atual                                 ³±±
±±³          ³ ExpN2 - No. de Linhas que devera ser somado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerLin(Li,nSoma)
Li+=nSoma
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Imp_Nota  ³ Autor ³Patricia A. Salomao    ³ Data ³18.03.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Notas Fiscais                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Imp_Nota(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha atual                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imp_Nota(Li,aNotas)
Local nCol:=50
Local n   :=0

For n:= 1 To Len(aNotas)
	@Li,nCol PSay aNotas[n][1]+"/"
	nCol+=Len(aNotas[n][1])+2
Next
Return