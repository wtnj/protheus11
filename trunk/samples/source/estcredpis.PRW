#INCLUDE 'RWMAKE.CH'
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³RDMAKE    ³ ESTCREDP    ³ Autor ³Fernando J. Siquini ³ Data ³ 12.02.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa criado para requisitar valor do estqoue ref a cred³±±
±±³          ³ ito de Custos por Beneficios Fiscais.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ESTCREDP()

Local aSays      := {}
Local aButtons   := {}
Local cCadastro  := 'Reducao de custos por Beneficios Fiscais'
Local cStrTipo   := ''
Local cStrGrupo  := ''
Local lOkParam   := .F.

Private dDataRef   := SuperGETMV('MV_ULMES')
Private nPercReq   := 3

aAdd(aSays,'Este RDMAKE gera Requisicoes Valorizadas p/reducao de custos')
aAdd(aSays,'referente a Beneficios Fiscais, calculado com relacao ao Estoque')
aAdd(aSays,'na Data do Ultimo Fechamento (MV_ULMES). Os Produtos e o')
aAdd(aSays,'Percentual aplicado deverao serao parametrizados.')
aAdd(aButtons, { 5,.T.,{|| ParCredPer(@cStrTipo,@cStrGrupo,@lOkParam) } } )
aAdd(aButtons, { 1,.T.,{|o|If(lOkParam,(Processa({|lEnd| PrcCredPerc(cStrTipo,cStrGrupo)}),o:oWnd:End()),Aviso('ESTCREDP', 'Atencao!!! A opcao de Parametros desta rotina deve ser acessada antes de sua execucao!', {'Ok'})) } } )
aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Array     ³ PARCREDPER  ³ Autor ³Fernando J. Siquini ³ Data ³ 12.02.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para selecionar tipo de produto e grupo de produto  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ParCredPer(cStrTipo,cStrGrupo,lOk)

Local aTipo      :={}
Local aGrupo     :={}
Local nTamTipo   := Len(SB1->B1_TIPO)
Local nTamGrupo  := Len(SB1->B1_GRUPO)
Local nX         := 0
Local oDlg
Local oQual
Local oQual2
Local oSay1
Local oGet1
Local oOk        := LoadBitmap( GetResources(), 'LBOK')
Local oNo        := LoadBitmap( GetResources(), 'LBNO')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Tabela de Tipos                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SX5')
dbSeek(xFilial()+'02')
Do While (X5_filial == xFilial()) .AND. (X5_tabela == '02') .and. !Eof()
	cCapital := OemToAnsi(Capital(X5Descri()))
	aAdd(aTipo,{.T.,SubStr(X5_chave,1,3)+cCapital})
	dbSkip()
EndDo
aAdd(aTipo,{.F.,'*Tipos em Branco*'})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Tabela de Grupos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SBM')
dbSeek(xFilial())
Do While (BM_FILIAL == xFilial()) .AND. !Eof()
	cCapital := OemToAnsi(Capital(BM_DESC))
	aAdd(aGrupo,{.T.,SubStr(BM_GRUPO,1,5)+' '+cCapital})
	dbSkip()
EndDo
aAdd(aGrupo,{.F.,'*Grupos em Branco*'})

DEFINE MSDIALOG oDlg TITLE 'Selecione os tipos e grupos de produtos para processamento' From 145,0 To 345,400 OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipos de Material                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 10,10 LISTBOX oQual VAR cVarQ Fields HEADER '','Tipos de Material' SIZE 75,60 ON DBLCLICK (aTipo:=CA710Troca(oQual:nAt,aTipo),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@aTipo) NOSCROLL OF oDlg PIXEL
oQual:SetArray(aTipo)
oQual:bLine := { || {If(aTipo[oQual:nAt,1],oOk,oNo),aTipo[oQual:nAt,2]}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grupos de Material                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 10,105 LISTBOX oQual2 VAR cVarQ2 Fields HEADER '','Grupos de Material' SIZE 75,60 ON DBLCLICK (aGrupo:=CA710Troca(oQual2:nAt,aGrupo),oQual2:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual2,oOk,oNo,@aGrupo) NOSCROLL OF oDlg  PIXEL
oQual2:SetArray(aGrupo)
oQual2:bLine := { || {If(aGrupo[oQual2:nAt,1],oOk,oNo),aGrupo[oQual2:nAt,2]}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percentual de Reducao - Say                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSay1                 := TSAY():Create(oDlg)
oSay1:cName           := 'oSay1'
oSay1:cCaption        := 'Percentual de Reducao:'
oSay1:nLeft           := 20
oSay1:nTop            := 165
oSay1:nWidth          := 170
oSay1:nHeight         := 17
oSay1:lShowHint       := .F.
oSay1:lReadOnly       := .F.
oSay1:Align           := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap       := .F.
oSay1:lTransparent    := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percentual de Reducao - Get                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGet1                 := TGET():Create(oDlg)
oGet1:cName           := 'oGet1'
oGet1:nLeft           := 150
oGet1:nTop            := 160
oGet1:nWidth          := 70
oGet1:nHeight         := 21
oGet1:lShowHint       := .F.
oGet1:lReadOnly       := .F.
oGet1:Align           := 0
oGet1:Picture         := '@E 999.99'
oGet1:cVariable       := 'nPercReq'
oGet1:bSetGet         := {|u| If(PCount()>0,nPercReq:=u,nPercReq) }
oGet1:lVisibleControl := .T.
oGet1:lPassword       := .F.
oGet1:lHasButton      := .F.
oGet1:bWhen           := {|| .T. }

DEFINE SBUTTON FROM 80,140 TYPE 1 ACTION (oDlg:End(),lOk:=.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80,167 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

If lOk
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Move aTipo para aStrTipo                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cStrTipo := Space(Len(SB1->B1_TIPO))+'|'
	For nX :=1 To (Len(aTipo)-1)
		If aTipo[nX,1]
			cStrTipo := cStrTipo+SubStr(aTipo[nX,2],1,nTamTipo)+'|'
		EndIf
	Next nX
	If aTipo[Len(aTipo),1]
		cStrTipo := cStrTipo+Space(nTamTipo)+'|'
	EndIf
	cStrTipo := AllTrim(cStrTipo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Move aGrupo para aStrGrupo                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cStrGrupo := Space(Len(SB1->B1_GRUPO))+'|'
	For nX := 1 To (Len(aGrupo)-1)
		If aGrupo[nX,1]
			cStrGrupo := cStrGrupo+SubStr(aGrupo[nX,2],1,nTamGrupo)+'|'
		EndIf
	Next nX
	If aGrupo[Len(aGrupo),1]
		cStrGrupo := cStrGrupo+Space(nTamGrupo)+'|'
	EndIf
	cStrGrupo := AllTrim(cStrGrupo)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Corrige o Percentual a ser calculado                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPercReq := nPercReq/100
EndIf

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Array     ³ PRCCREDPERC ³ Autor ³Fernando J. Siquini ³ Data ³ 12.02.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para processar produto a produto                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrcCredPerc(cStrTipo,cStrGrupo)

Local aAreaAnt   := GetArea()
Local aAreaSB1   := SB1->(GetArea())
Local aAreaSB2   := SB2->(GetArea())
Local aAreaSD3   := SD3->(GetArea())
Local aSalPrd    := {}
Local lSuccess   := .T.
Local cFilSB1    := ''
Local cSeekSB2   := ''

dbSelectArea('SB1')
ProcRegua(LastRec())
dbSetOrder(1)
dbSeek(cFilSB1:=xFilial('SB1'), .F.)
Do While !Eof() .And. B1_FILIAL == cFilSB1
	IncProc()
	If SB1->B1_TIPO $cStrTipo .And. SB1->B1_GRUPO $cStrGrupo
		dbSelectArea('SB2')
		dbSetOrder(1)
		If dbSeek(cSeekSB2:=xFilial('SB2')+SB1->B1_COD, .F.)
			Do While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD == cSeekSB2
				aSalPrd  := CalcEst(SB1->B1_COD,SB2->B2_LOCAL,dDataRef)
				lSuccess := CriSD3PER(SB1->B1_COD,SB2->B2_LOCAL,aSalPrd)
				If !lSuccess
					Exit
				EndIf
				dbSelectArea('SB2')
				dbSkip()
			EndDo
		EndIf
	EndIf
	If !lSuccess
		Exit
	EndIf
	dbSelectArea('SB1')
	dbSkip()
EndDo

If lSuccess
	Aviso('ESTCREDP', 'Rotina encerrada com sucesso !!!', {'Ok'})
Else
	Aviso('ESTCREDP', 'Ocorreram Problemas durante a execucao desta Rotina', {'Ok'})
EndIf

RestArea(aAreaSD3)
RestArea(aAreaSB2)
RestArea(aAreaSB1)
RestArea(aAreaAnt)

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Array     ³ CRISD3PER   ³ Autor ³Fernando J. Siquini ³ Data ³ 12.02.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para criar registros no SD3                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriSD3PER(cProduto, cLocal, aSalPrd)

Local aAreaAnt   := GetArea()
Local nX         := 0
Local cDocto     := 'ESTCRE'
Local cLoteCTL   := 'EC'+DtoS(dDataBase)
Local cNumLote   := 'ESTCRE'
Local cEndPad    := ''
Local cArmSBE    := ''
Local lRet       := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o percentual                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aSalPrd)
	aSalPrd[nX] := aSalPrd[nX] * nPercReq
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o Endereco Padrao                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Localiza(SB1->B1_COD)
	dbSelectArea('SBE')
	dbSetOrder(1)
	If !MSSeek(xFilial('SBE')+(cArmSBE:=SB2->B2_LOCAL), .F.)
		Aviso('ESTCREDP', 'Nao existem Encederos cadastrados nesta Filial para o Armazem '+cArmSBE+' !!! Esta rotina sera abortada.', {'Ok'})
		lRet := .F.
	Else
		cEndPad := BE_LOCALIZ
	EndIf
EndIf

If lRet
	Begin Transaction
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera a Dev. no SD3 com Quantidade = 1 e Custo = 1    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock('SD3',.T.)
	Replace D3_FILIAL  With xFilial('SD3')
	Replace D3_COD     With SB1->B1_COD
	Replace D3_QUANT   With 1
	Replace D3_CF      With 'DE6'
	Replace D3_CHAVE   With SubStr(D3_CF,2,1)+If(D3_CF=='DE4','9','0')
	Replace D3_LOCAL   With SB2->B2_LOCAL
	Replace D3_DOC     With cDocto
	Replace D3_EMISSAO With dDataBase
	Replace D3_UM      With SB1->B1_UM
	Replace D3_GRUPO   With SB1->B1_GRUPO
	Replace D3_NUMSEQ  With ProxNum()
	Replace D3_QTSEGUM With 0
	Replace D3_SEGUM   With SB1->B1_SEGUM
	Replace D3_TM      With '499'
	Replace D3_TIPO    With SB1->B1_TIPO
	Replace D3_CONTA   With SB1->B1_CONTA
	Replace D3_USUARIO With SubStr(cUsuario,7,15)
	Replace D3_CUSTO1  With 1
	Replace D3_CUSTO2  With 1
	Replace D3_CUSTO3  With 1
	Replace D3_CUSTO4  With 1
	Replace D3_CUSTO5  With 1
	If Rastro(SB1->B1_COD)
		Replace D3_LOTECTL With cLoteCTL
		Replace D3_DTVALID With dDataBase
		If Rastro(SB1->B1_COD, 'S')
			Replace D3_NUMLOTE With cNumLote
		EndIf
	EndIf
	If Localiza(SB1->B1_COD)
		Replace D3_LOCALIZ With cEndPad
	EndIf
	MsUnlock()
	B2AtuComD3({D3_CUSTO1,D3_CUSTO2,D3_CUSTO3,D3_CUSTO4,D3_CUSTO5},NIL,NIL,NIL,NIL,.T.,Nil)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera a Req. no SD3 com Quantidade = 1 e Custo = 1+%  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock('SD3',.T.)
	Replace D3_FILIAL  With xFilial()
	Replace D3_COD     With SB1->B1_COD
	Replace D3_QUANT   With 1
	Replace D3_CF      With 'RE6'
	Replace D3_CHAVE   With SubStr(D3_CF,2,1)+If(D3_CF=='DE4','9','0')
	Replace D3_LOCAL   With SB2->B2_LOCAL
	Replace D3_DOC     With cDocto
	Replace D3_EMISSAO With dDataBase
	Replace D3_UM      With SB1->B1_UM
	Replace D3_GRUPO   With SB1->B1_GRUPO
	Replace D3_NUMSEQ  With ProxNum()
	Replace D3_QTSEGUM With 0
	Replace D3_SEGUM   With SB1->B1_SEGUM
	Replace D3_TM      With '999'
	Replace D3_TIPO    With SB1->B1_TIPO
	Replace D3_CONTA   With SB1->B1_CONTA
	Replace D3_USUARIO With SubStr(cUsuario,7,15)
	Replace D3_CUSTO1  With 1+aSalPrd[2]
	Replace D3_CUSTO2  With 1+aSalPrd[3]
	Replace D3_CUSTO3  With 1+aSalPrd[4]
	Replace D3_CUSTO4  With 1+aSalPrd[5]
	Replace D3_CUSTO5  With 1+aSalPrd[6]
	If Rastro(SB1->B1_COD)
		Replace D3_LOTECTL With cLoteCTL
		Replace D3_DTVALID With dDataBase
		If Rastro(SB1->B1_COD, 'S')
			Replace D3_NUMLOTE With cNumLote
		EndIf
	EndIf
	If Localiza(SB1->B1_COD)
		Replace D3_LOCALIZ With cEndPad
	EndIf
	MsUnlock()
	B2AtuComD3({D3_CUSTO1,D3_CUSTO2,D3_CUSTO3,D3_CUSTO4,D3_CUSTO5},NIL,NIL,NIL,NIL,.T.,Nil)
	End Transaction
EndIf

RestArea(aAreaAnt)

Return lRet