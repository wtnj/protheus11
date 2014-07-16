#IFDEF PROTHEUS
#INCLUDE "RWMAKE.CH"
#ENDIF

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ IRMENOR  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 15.02.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calculo IR nÆo retido (valores menores que minimo retencao) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
"Rdmake para geracao de titulo aglutinador de IR nÆo calculado nos titulos 
originais por serem menor que o valor de retencao, porem devem ser calculados 
pois no periodo, se somados, superam o valor minimo de retencao"
/*/

#IFDEF PROTHEUS
User Function Irmeno()
#ENDIF

#IFDEF PROTHEUS
While !KillApp()
#ELSE
While .T.
#ENDIF

	nOpca := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cForDe 	:= CriaVar("E2_FORNECE")
	cForAte	:= CriaVar("E2_FORNECE")
	cLojaDe	:= CriaVar("E2_LOJA")
	cLojaAte := CriaVar("E2_LOJA")
	dDataIni	:= CTOD("//")
	dDataFin	:= CTOD("//")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Interface                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 74,39 To 288,368 Dialog mkwdlg Title OemToAnsi("IRRF Menor")
	@ 3,7 To 104,102	

	@ 10,16 Say OemToAnsi("Fornecedor De") Size 43,8
	@ 10,72 Say OemToAnsi("Loja De") Size 22,8
	@ 31,16 Say OemToAnsi("Fornecedor Ate") Size 47,8
	@ 31,71 Say OemToAnsi("Loja Ate") Size 24,8
	@ 50,16 Say OemToAnsi("Data Inicial") Size 32,8
	@ 71,16 Say OemToAnsi("Data Final") Size 35,8

	@ 20,15 Get cForDe 	F3 "FOR"	Size 45,10 
	@ 20,70 Get cLojaDe 				Size 20,10
	@ 39,15 Get cForAte	F3 "FOR" Size 45,10 Valid cForAte >= cForDe
	@ 39,71 Get cLojaAte 			Size 20,10
	@ 59,15 Get dDataIni				Size 76,10 Valid !Empty(dDataIni)
	@ 79,15 Get dDataFin				Size 76,10 Valid !Empty(ddataFin) .and. dDataFin >= dDataIni

	#IFNDEF PROTHEUS
		@ 11,114 Button OemToAnsi("_Ok") Size 36,16 Action EXECUTE (TESTE)
		@ 29,114 Button OemToAnsi("_Cancelar") Size 36,16 Action EXECUTE (TESTE2)
	#ELSE
		@ 11,114 Button OemToAnsi("_Ok") Size 36,16 Action TESTE()
		@ 29,114 Button OemToAnsi("_Cancelar") Size 36,16 Action TESTE2()
	#ENDIF

	Activate Dialog mkwdlg Centered

	If nOpca == 0
		Exit
	EndIf

	dbSelectArea("SE2")
	dbSetOrder(1)
	nVlMinIr := GetMv("MV_VLRETIR")
	cAlias	:= "SE2"
	cIndex	:= CriaTrab(nil,.f.)
	cChave	:= IndexKey()
	cFiltro := 'SE2->E2_FILIAL=="'+xFilial("SE2")+'" .And. '
	cFiltro := cFiltro + '(SE2->E2_FORNECE>="'+cForDe+'".And.'
	cFiltro := cFiltro + 'SE2->E2_LOJA>="'+cLojaDe+'").And.'
	cFiltro := cFiltro + '(SE2->E2_FORNECE<= "'+cForAte+'".And.'
	cFiltro := cFiltro + 'SE2->E2_LOJA<="'+cLojaAte+'").And.'
	cFiltro := cFiltro + 'DTOS(SE2->E2_EMIS1)>="'+DTOS(dDataIni)+'".And.'
	cFiltro := cFiltro + 'DTOS(SE2->E2_EMIS1)<="'+DTOS(dDataFin)+'".And.'
	cFiltro := cFiltro + 'SE2->E2_IRRF<='+STR(nVlMinIr,17,2)+'.And.'
	cFiltro := cFiltro + '!(E2_TIPO$"PR /PA '+MV_CPNEG+'")'

	IndRegua("SE2",cIndex,cChave,,cFiltro,"Selecionando Registros...")
	nIndex := RetIndex("SE2")
	DbSelectArea(cAlias)
	#IFNDEF TOP
		DbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	DbSetOrder(nIndex+1)
	DbSeek(xFilial("SE2"))
	DbGoTop()
	If Eof() .and. Bof()
		Help(" ",1,"RECNO")
		DbSelectArea("SE2")
		RetIndex("SE2")
		Set Filter to
		DbGoTop()
		FErase(cIndex+OrdBagExt())
		Loop
	Else
		nVlIrAcum := 0
		While !Eof()	
			nVlIrAcum := 0
			cFornAtu	 := SE2->E2_FORNECE+E2_LOJA	
			While !Eof() .and. SE2->E2_FORNECE+E2_LOJA == cFornAtu
				dbSelectArea("SED")
				dbSetOrder(1)
				If dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
					nPercIr := IIF(SED->ED_PERCIRF > 0 , ED_PERCIRF,Getmv("MV_ALIQIRF"))
					If SED->ED_CALCIRF == "S" .and. nPercIr > 0
						nVlIrrf := (SE2->E2_VLCRUZ + SE2->E2_INSS+SE2->E2_ISS) * (nPercIr/100)
						If nVlIrrf <= GetMv("MV_VLRETIR")
							nVlIrAcum := nVlIrAcum + nVlIrrf
						Endif
					Endif
				Endif
				DbSelectArea("SE2")
				nRegSE2	:= Recno()
				dbSkip()
			Enddo
			dbGoto(nRegSe2)
			If nVlIrAcum > 0 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria o Fornecedor, caso nao exista         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SA2")
				DbSeek(xFilial("SA2")+GetMV("MV_UNIAO")+Space(Len(A2_COD)-Len(GetMV("MV_UNIAO")))+"00")
				If ( EOF() )
					Reclock("SA2",.T.)
					SA2->A2_FILIAL := xFilial("SA2")
					SA2->A2_COD		:= GetMV("MV_UNIAO")
					SA2->A2_LOJA	:= "00"
					SA2->A2_NOME	:= "UNIAO"
					SA2->A2_NREDUZ	:= "UNIAO"
					SA2->A2_BAIRRO	:= "."
					SA2->A2_MUN		:= "."
					SA2->A2_EST		:= "."
					SA2->A2_End		:= "."
					SA2->A2_TIPO	:= "."
					MsUnlock()
				EndIf
				While ( .T. )
					cPrefixo := "IRF"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ VerIfica se ja' ha' titulo de IR com esta numera‡„o ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aTam		  := TamSx3("E2_NUM")
					cNumero    := SubStr(Dtos(dDataBase),3,aTam[1])
					cTipo      := "TX "
					cParcela   := GetMv("MV_1DUP")
					dbSelectArea("SE2")
					dbSetOrder(1)
					dbSeek(xFilial("SE2")+cPrefixo+cNumero+cParcela+cTipo+GetMV("MV_UNIAO"),.F.)
					While ( SE2->(Found()) )
						If ( cParcela == "Z" )
							cParcela := GetMv("MV_1DUP")
							cNumero  := Soma1(cNumero,3,aTam[1])
						EndIf
						cParcela := Soma1(cParcela,Len(SE2->E2_PARCELA))
						dbSeek(xFilial("SE2")+cPrefixo+cNumero+cParcela+cTipo+GetMV("MV_UNIAO"),.F.)
					EndDo
					Exit
				Enddo
				DbGoTo( nRegSe2 )
				dNextDay := dDataBase+1
				For nCntFor := 1 To 7
					If Dow( dNextDay ) == 1
						Exit
					EndIf
					dNextDay := dNextDay + 1
				Next nCntFor
				For n:= 1 to 3
					dNextDay := DataValida(dNextDay+1,.T.)
				Next
				dVencRea := dNextDay
				RecLock("SE2",.T.)
				SE2->E2_FILIAL  := xFilial("SE2")
				SE2->E2_PREFIXO := cPrefixo
				SE2->E2_NUM     := cNumero
				SE2->E2_PARCELA := cParcela
				SE2->E2_TIPO	 := "TX "
				SE2->E2_EMISSAO := ddatabase
				SE2->E2_VALOR   := nVlIrAcum
				SE2->E2_VENCREA := dVencrea
				SE2->E2_SALDO   := nVlIrAcum
				SE2->E2_VENCTO  := dVencRea
				SE2->E2_VENCORI := dVencRea
				SE2->E2_MOEDA   := 1
				SE2->E2_EMIS1   := dDataBase
				SE2->E2_FORNECE := GetMV("MV_UNIAO")
				SE2->E2_VLCRUZ  := SE2->E2_VALOR
				SE2->E2_LOJA    := SA2->A2_LOJA
				SE2->E2_NOMFOR  := SA2->A2_NREDUZ
				SE2->E2_ORIGEM  := "FINA050"
				cNatureza		 := GetMv("MV_IRF")
				cNatureza		 := &cNatureza
				SE2->E2_NATUREZ := cNatureza
				cNatureza       := SE2->E2_NATUREZ
				MsUnlock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria a natureza IRF caso nao exista        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SED")
				If ( !DbSeek(xFilial("SED")+cNatureza) )
					RecLock("SED",.T.)
					SED->ED_FILIAL  := xFilial("SED")
					SED->ED_CODIGO  := cNatureza
					SED->ED_CALCIRF := "N"
					SED->ED_CALCISS := "N"
					SED->ED_CALCINS := "N"
					SED->ED_DESCRIC := "IMPOSTO RENDA RETIDO NA FONTE"
					MsUnlock()
				EndIf
			Endif
			dbSelectArea("SE2")
			DbGoTo( nRegSe2 )
			dbSkip()
		Enddo
	Endif
Enddo
Return .t.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Teste    ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 15.02.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do Botao OK                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#IFDEF PROTHEUS
	Static Function Teste()
#ELSE
	Function Teste
#ENDIF

nOpca := 1
Close(mkwdlg)

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Teste2   ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 15.02.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do Botao Cancelar                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#IFDEF PROTHEUS
Static Function Teste2()
#ELSE
Function Teste2
#ENDIF
nOpca := 0
Close(mkwdlg)
Return
