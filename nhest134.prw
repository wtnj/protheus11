#INCLUDE 'topconn.ch'       
#INCLUDE 'RWMAKE.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST134    ºAutor  ³João Felipe da Rosaº Data ³  13/11/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ALTERA SERIE DAS NOTAS FISCAIS             				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHEST134()

SetPrvt("cCadastro,aRotina,_aOpçoes,cAlias,_nPos")
_aOpcoes := {"Nota de Entrada","Nota de Saida"}
_nPos    := 1

@ 100,050 To 300,370 Dialog DlgItem Title OemToAnsi("Altera Serie das NFs")
@ 005,008 To 075,150
@ 020,020 Say OemToAnsi("Escolha uma Opção")   Size 150,8
@ 040,020 RADIO _aOpcoes VAR _nPos

@ 080,080 BMPBUTTON TYPE 01 ACTION fOK()
@ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgItem)
Activate Dialog DlgItem Centered

Return

Static Function fOk()

   If _nPos == 1
      cMsg   := "Nota de entrada"
      cAlias := "SF1"
   Else
      cMsg := "Nota de Saida"   
      cAlias := "SF2"      
   Endif
   
cCadastro := OemToAnsi("Altera Serie das Notas Fiscais")
aRotina   := {{ "Pesquisa"     ,"Axpesqui"     ,0,1},;
              { "Altera Serie" ,'U_fAltSerie()',0,2}}

DbSelectArea(cAlias)
(cAlias)->(DbSetOrder(1))
DbGoTop()
	            
mBrowse(06,01,22,75,cAlias,,)     

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERA A SERIE DA NF NAS TABELAS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function fAltSerie()    

_cNumCheq  := "" 
_cNewSerie := "  "

@ 100,050 To 300,370 Dialog DlgSerie Title OemToAnsi("Altera Serie das NFs")
@ 005,008 To 075,150
@ 015,015 Say "Nota: "+SF1->F1_DOC Size 40,08
@ 015,050 Say "Serie: "+SF1->F1_SERIE Size 40,08
@ 030,015 Say "Nova Serie: " Size 40,08
@ 030,050 Get _cNewSerie Size 10,08
@ 080,080 BMPBUTTON TYPE 01 ACTION Processa({|| fAlt() }, "Alterando Series")
@ 080,120 BMPBUTTON TYPE 02 ACTION Close(DlgSerie)
Activate Dialog DlgSerie Centered

Return

Static Function fAlt()

ProcRegua(20)

If _nPos == 1//Entrada

	_cDoc     := SF1->F1_DOC
	_cSerie   := SF1->F1_SERIE
	_cTipMov  := "E"
	_cEmissao := DtoS(SF1->F1_EMISSAO)
	_cCliFor  := SF1->F1_FORNECE
	_cLoja    := SF1->F1_LOJA
	_cPoder3  := "R"
		
	//TABELA: Notas Fiscais de Entrada
	RecLock("SF1",.F.)
		SF1->F1_SERIE := _cNewSerie
	MsUnLock("SF1")

	//TBELA: Itens das NFs de Entrada
	DbSelectArea("SD1")
	DbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If DbSeek(xFilial("SD1")+_cDoc+_cSerie)
		While SD1->D1_DOC == _cDoc .AND. SD1->D1_SERIE == _cSerie
		    RecLock("SD1",.F.)
			    SD1->D1_SERIE := _cNewSerie
		    MsUnLock("SD1")
		    
		    SD1->(DbSkip()) 
		    IncProc("Alterando serie... Tabela: SD1")
		EndDo
	ENDIF

Else  //SAIDA
	_cDoc     := SF2->F2_DOC
	_cSerie   := SF2->F2_SERIE
	_cTipMov  := "S"
	_cEmissao := DtoS(SF2->F2_EMISSAO)
	_cCliFor  := SF2->F2_CLIENTE
	_cLoja    := SF2->F2_LOJA
	_cPoder3  := "D"
	
	//TABELA: Notas Fiscais de Saída
	RecLock("SF2",.F.)
		SF2->F2_SERIE := _cNewSerie
	MsUnLock("SF2")
	
	//TBELA: Itens das NFs de Saída
	DbSelectArea("SD2")
	DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	If DbSeek(xFilial("SD2")+_cDoc+_cSerie)
		While SD2->D2_DOC == _cDoc .AND. SD2->D2_SERIE == _cSerie
		    RecLock("SD2",.F.)
			    SD2->D2_SERIE := _cNewSerie
		    MsUnLock("SD2")
		    
		    SD2->(DbSkip())
		    IncProc("Alterando serie... Tabela: SD2")
		EndDo
	ENDIF

EndIf

//TABELA: Saldo em Poder de Terceiros
DbSelectArea("SB6")
DbSetOrder(5)//B6_FILIAL+B6_PODER3+B6_DOC+B6_SERIE+B6_CLIFOR
If DbSeek(xFilial("SB6")+_cPoder3+_cDoc+_cSerie)
	While SB6->B5_DOC == _cDoc .AND. SB6->B6_SERIE == _cSerie
		RecLock("SB6",.F.)
			SB6->B6_SERIE := _cNewSerie		
		MsUnlock("SB6")
		SB6->(DbSkip())
	    IncProc("Alterando serie... Tabela: SB6")
	EndDo
ENDIF

//TABELA: Livro Fiscal por Item de NF
DbSelectArea("SFT")
DbSetOrder(6)//FT_FILIAL+FT_TIPOMOV+FT_NFISCAL+FT_SERIE
If DbSeek(xFilial("SFT")+_cTipMov+_cDoc+_cSerie)
	While SFT->F7_NFISCAL == _cDoc .AND. SFT->FT_SERIE == _cSerie
		RecLock("SFT",.F.)
			SFT->FT_SERIE := _cNewSerie		
		MsUnlock("SFT")
		SFT->(DbSkip())
	    IncProc("Alterando serie... Tabela: SFT")
	EndDo
ENDIF

//TABELA: Livros Fiscais
cQuery := " SELECT R_E_C_N_O_ AS F3_RECNO FROM "+RetSqlName("SF3")
cQuery += " WHERE F3_NFISCAL = '"+_cDoc+"'"
cQuery += " AND F3_SERIE   = '"+_cSerie+"'"
cQuery += " AND F3_CLIEFOR = '"+_cCliFor+"'"
cQuery += " AND F3_LOJA    = '"+_cLoja+"'"
cQuery += " AND F3_EMISSAO = '"+_cEmissao+"'"
cQuery += " AND D_E_L_E_T_ = '' AND F3_FILIAL = '"+xFilial("SF3")+"'" 

TCQUERY cQuery NEW ALIAS "TRA1"

TRA1->(DbGoTop())

If !Empty(TRA1->F3_RECNO)

	DbSelectArea("SF3")
	If DbGoTo(TRA1->F3_RECNO)
		RecLock("SF3",.F.)
			SF3->F3_SERIE := _cNewSerie		
		MsUnlock("SF3")
	EndIf
	IncProc("Alterando serie... Tabela: SF3")
		
EndIf

TRA1->(DbCloseArea())
         
//TABELA: Contas a Pagar
DbSelectArea("SE2")
DbSetOrder(1)//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
If DbSeek(xFilial("SE2")+_cSerie+_cDoc)
	While SE2->E2_NUM == _cDoc .AND. SE2->E2_PREFIXO == _cSerie
		If SE2->E2_FORNECE == _cCliFor .AND. SE2->E2_LOJA == _cLoja .AND. DtoS(SE2->E2_EMISSAO) == _cEmissao
			RecLock("SE2",.F.)
				SE2->E2_PREFIXO := _cNewSerie
			MsUnLock("SE2")
		EndIf
		SE2->(DbSkip())
	    IncProc("Alterando serie... Tabela: SE2")
	EndDo
EndIf
		
//TABELA: Movimentacao Bancaria
DbSelectArea("SE5")
DbSetOrder(7)//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
If DbSeek(xFilial("SE5")+_cSerie+_cDoc)
	While SE5->E5_NUMERO == _cDoc .AND. SE5->E5_PREFIXO == _cSerie
		If SE5->E5_CLIFOR == _cCliFor .AND. SE5->E5_LOJA == _cLoja
			
			_cNumCheq := SE5->E5_NUMCHEQ
			
			RecLock("SE5",.F.)
				SE5->E5_PREFIXO := _cNewSerie
			MsUnLock("SE5")
			
			//TABELA: Cheques		
			If !Empty(_cNumCheq)
				cQuery := "SELECT R_E_C_N_O_ AS EF_RECNO FROM "+RetSqlName("SEF")
				cQuery += " WHERE EF_NUM = '"+_cNumCheq+"'" 
				cQuery += " AND EF_FORNECE = '"+_cCliFor+"'"
				cQuery += " AND EF_LOJA = '"+_cLoja+"'"
				cQuery += " AND D_E_L_E_T_ = '' AND EF_FILIAL = '"+xFilial("SEF")+"'"
			
				TCQUERY cQuery NEW ALIAS "TRB"
			
				TRB->(DbGoTop())
			
				If !Empty(TRB->EF_RECNO)
					While TRB->(!EOF())
						If SEF->(DbGoTo(TRB->EF_RECNO))
							RecLock("SEF",.F.)
								SEF->EF_PREFIXO := _cNewSerie
						    MsUnlock("SEF")
					    EndIf
						TRB->(DbSkip())
				    EndDo
				EndIf
				
				TRB->(DbCloseArea())
			EndIf
		EndIf
		SE5->(DbSkip())
	    IncProc("Alterando serie... Tabela: SE5")
	EndDo
EndIf

//TABELA: Titulos Enviados ao Banco
cQuery := "SELECT R_E_C_N_O_ AS EA_RECNO FROM "+RetSqlName("SEA")
cQuery += " WHERE EA_NUM = '"+_cDoc+"'"
cQuery += " AND EA_PREFIXO = '"+_cSerie+"'"
cQuery += " AND EA_FORNECE = '"+_cCliFor+"'"
cQuery += " AND EA_LOJA = '"+_cLoja+"'"
cQuery += " AND D_E_L_E_T_ = '' AND EA_FILIAL = '"+xFilial("SEA")+"'"

TCQUERY cQuery NEW ALIAS "TRC"

TRC->(DbGoTop())

If !Empty(TRC->EA_RECNO)
	DbSelectArea("SEA")
	While TRC->(!EOF())
		DbGoTo(TRC->EA_RECNO)
		RecLock("SEA",.F.)
			SEA->EA_PREFIXO := _cNewSerie
		MsUnlock("SEA")

		TRC->(DbSkip())
	    IncProc("Alterando serie... Tabela: SEA")
	EndDo
EndIf

TRC->(DbCloseArea())

//TABELA: Saldos a Distribuir
DbSelectArea("SDA")
DbSetOrder(2)//DA_FILIAL+DA_DOC+DA_SERIE
If DbSeek(xFilial("SDA")+_cDoc+_cSerie)
	While SDA->DA_DOC == _cDoc .AND. SDA->DA_SERIE == _cSerie
		If SDA->DA_CLIFOR == _cCliFor .AND. SDA->DA_LOJA == _cLoja
			RecLock("SDA",.F.)
				SDA->DA_SERIE := _cNewSerie
			MsUnlock("SDA")
		EndIf
		SDA->(DbSkip())
	    IncProc("Alterando serie... Tabela: SDA")
	EndDo
EndIf

//TABELA: Movimentos de Distribuicao
cQuery := "SELECT R_E_C_N_O_ AS DB_RECNO FROM "+RetSqlName("SDB")
cQuery += " WHERE DB_DOC = '"+_cDoc+"'"
cQuery += " AND DB_SERIE = '"+_cSerie+"'"
cQuery += " AND DB_CLIFOR = '"+_cCliFor+"'"
cQuery += " AND DB_LOJA = '"+_cLoja+"'"
cQuery += " AND D_E_L_E_T_ = '' AND DB_FILIAL = '"+xFilial("SDB")+"'"

TCQUERY cQuery NEW ALIAS "TRD"  

TRD->(DbGoTop())

If !Empty(TRD->DB_RECNO)
	DbSelectArea("SDB")
	While TRD->(!Eof())
		DbGoTo(TRD->DB_RECNO)
		RecLock("SDB",.F.)
			SDB->DB_SERIE := _cNewSerie	
	    MsUnlock("SDB")
	    TRD->(DbSkip())
	    IncProc("Alterando serie... Tabela: SDB")
	EndDo
Endif

TRD->(DbCloseArea())

//TABELA: Entradas
cQuery := "SELECT R_E_C_N_O_ AS QEK_RECNO FROM "+RetSqlName("QEK")
cQuery += " WHERE QEK_NTFISC = '"+_cDoc+"'"
cQuery += " AND QEK_SERINF = '"+_cSerie+"'"
cQuery += " AND QEK_FORNEC = '"+_cCliFor+"'"
cQuery += " AND QEK_LOJFOR = '"+_cLoja+"'"
cQuery += " AND D_E_L_E_T_ = '' AND QEK_FILIAL = '"+xFilial("QEK")+"'"

TCQUERY cQuery NEW ALIAS "TRE"

TRE->(DbGoTop())

If !Empty(TRE->QEK_RECNO)
	DbSelectArea("QEK")
	While TRE->(!EoF())
		DbGoTo(TRE->QEK_RECNO)
		RecLock("QEK",.F.)
			QEK->QEK_SERINF := _cNewSerie
		MsUnlock("QEK")
	    TRE->(DbSkip())
	    IncProc("Alterando serie... Tabela: QEK")
	EndDo
EndIf

TRE->(DbCloseArea())

//TABELA: Saldos por Lote
cQuery := "SELECT R_E_C_N_O_ AS B8_RECNO FROM "+RetSqlName("SB8")
cQuery += " WHERE B8_DOC = '"+_cDoc+"'"
cQuery += " AND B8_SERIE = '"+_cSerie+"'"
cQuery += " AND B8_CLIFOR = '"+_cCliFor+"'"
cQuery += " AND B8_LOJA = '"+_cLoja+"'"
cQuery += " AND D_E_L_E_T_ = '' AND B8_FILIAL = '"+xFilial("SB8")+"'"

TCQUERY cQuery NEW ALIAS "TRF"

TRF->(DbGoTop())

If !Empty(TRF->B8_RECNO)
	DbSelectArea("SB8")
	While TRF->(!EoF())
		DbGoTo(TRF->B8_RECNO)
		RecLock("SB8")	
			SB8->B8_SERIE := _cNewSerie		
		MsUnlock("SB8")	     
		TRF->(DbSkip())
	    IncProc("Alterando serie... Tabela: SB8")
    EndDo
EndIf

TRF->(DbCloseArea())

//TABELA: Debitos de Clientes
cQuery := "SELECT R_E_C_N_O_ AS ZA8_RECNO FROM "+RetSqlName("ZA8")
cQuery += " WHERE ZA8_DOC = '"+_cDoc+"'"
cQuery += " AND ZA8_SERIE = '"+_cSerie+"'"
cQuery += " AND ZA8_CLIENT = '"+_cCliFor+"'"
cQuery += " AND ZA8_LOJA = '"+_cLoja+"'"
cQuery += " AND D_E_L_E_T_ = '' AND ZA8_FILIAL = '"+xFilial("ZA8")+"'"

TCQUERY cQuery NEW ALIAS "TRG"

TRG->(DbGoTop())

If !Empty(TRG->ZA8_RECNO)
	DbSelectArea("ZA8")
	While TRG->(!EoF())
		DbGoTo(TRG->ZA8_RECNO)
		RecLock("ZA8")	
			ZA8->ZA8_SERIE := _cNewSerie		
		MsUnlock("ZA8")	     
		TRG->(DbSkip())
	    IncProc("Alterando serie... Tabela: ZA8")
    EndDo
EndIf

TRG->(DbCloseArea())    

Close(DlgSerie)

Return