#INCLUDE "FINR190.CH"
#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Nhfin046 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Nhfin046()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local wnrel
Local aOrd:={OemToAnsi(STR0001),OemToAnsi(STR0002),OemToAnsi(STR0003),OemToAnsi(STR0004),OemToAnsi(STR0032),OemToAnsi(STR0005),OemToAnsi(STR0036),STR0048}  //"Por Data"###"Por Banco"###"Por Natureza"###"Alfabetica"###"Nro. Titulo"###"Dt.Digitacao"###"Por Lote" //"Por Data de Credito"
Local cDesc1 := STR0006  //"Este programa ir  emitir a rela‡„o dos titulos baixados."
Local cDesc2 := STR0007  //"Poder  ser emitido por data, banco, natureza ou alfab‚tica"
Local cDesc3 := STR0008  //"de cliente ou fornecedor e data da digita‡„o."
Local tamanho:="G"
Local limite := 220
Local cString:="SE5"

Private titulo:=OemToAnsi(STR0009)  //"Relacao de Baixas"
Private cabec1
Private cabec2
Private cNomeArq
Private aReturn := { OemToAnsi(STR0010), 1,OemToAnsi(STR0030), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:="FINR190"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="FIN190"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN190",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // da data da baixa                  ³
//³ mv_par02            // at‚ a data da baixa               ³
//³ mv_par03            // do banco                          ³
//³ mv_par04            // at‚ o banco                       ³
//³ mv_par05            // da natureza                       ³
//³ mv_par06            // at‚ a natureza                    ³
//³ mv_par07            // do c¢digo                         ³
//³ mv_par08            // at‚ o c¢digo                      ³
//³ mv_par09            // da data de digita‡„o              ³
//³ mv_par10            // ate a data de digita‡„o           ³
//³ mv_par11            // Tipo de Carteira (R/P)            ³
//³ mv_par12            // Moeda                             ³
//³ mv_par13            // Hist¢rico: Baixa ou Emiss„o       ³
//³ mv_par14            // Imprime Baixas Normais / Todas    ³
//³ mv_par15            // Situacao                          ³
//³ mv_par16            // Cons Mov Fin                      ³
//³ mv_par17            // Cons filiais abaixo               ³
//³ mv_par18            // da filial                         ³
//³ mv_par19            // ate a filial                      ³
//³ mv_par20            // Do Lote                           ³
//³ mv_par21            // Ate o Lote                        ³
//³ mv_par22            // da loja                           ³
//³ mv_par23            // Ate a loja                        ³ 
//³ mv_par24            // NCC Compensados                   ³
//³ mv_par25            // Outras Moedas                     ³ 
//³ mv_par26            // do prefixo                        ³
//³ mv_par27            // at‚ o prefixo                     ³
//³ mv_par28            // Imprimir os Tipos                 ³
//³ mv_par29            // Nao Imprimir Tipos			     ³
//³ mv_par30            // Imprime nome (Normal ou reduzido) ³
//³ mv_par31            // da data da vencto. do tit         ³
//³ mv_par32            // at‚ a data de vencto do tit.      ³
//³ mv_par33            // da filial origem                  ³
//³ mv_par34            // ate filial origem                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR190"            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(Nil)
EndIf

cFilterUser := aReturn[7]

RptStatus({|lEnd| Fa190Imp(@lEnd,wnRel,cString)},Titulo)
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA190Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA190Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA190Imp(lEnd,wnRel,cString)

Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nCM:=0,nMulta:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJuros:=0,nTotMulta:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0
Local nGerValor:=0,nGerDesc:=0,nGerJuros:=0,nGerMulta:=0,nGerCm:=0,nGerOrig:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0
Local nFilOrig:=0,nFilJuros:=0,nFilMulta:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbat:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua:=.T.
Local lBxTit:=.F.
Local tamanho:="G"
Local aCampos := {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat := 0
Local nTotAbat := 0
Local nGerAbat := 0
Local cMotBxImp := " "
Local cHistorico
Local lManual := .f.
Local cTipodoc
Local nRecSe5 := 0
Local dDtMovFin
Local cRecPag
Local nRecEmp := SM0->(Recno())
Local cMotBaixa := CRIAVAR("E5_MOTBX")
Local cFilNome := Space(15)
Local cCliFor190 := ""
Local aTam := IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu := {}
Local nDecs	   := GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local nMoedaBco:= 1
Local cCarteira
Local cTipoPag
Local aStru := SE5->(DbStruct()), nI
Local cOrdem := ""
Local cFilTrb
Local lAsTop := .F.
Local cFilSe5 := ".T."
Local cQuery
Local cChave, bFirst
Local cFilOrig
Local lAchou := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem 	:= aReturn[8]
cSuf	:= LTrim(Str(mv_par12))
cMoeda	:= GetMv("MV_MOEDA"+cSuf)

cCond3	:= ".T."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	titulo := OemToAnsi(STR0011)  + cMoeda  //"Relacao dos Titulos Recebidos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0039),OemToAnsi(STR0012))  //"Cliente-Nome Cliente "###"Prf Numero       P TP Client Nome Cliente       Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Rec. Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi(STR0040),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
Else
	titulo := OemToAnsi(STR0013)  + cMoeda  //"Relacao dos Titulos Pagos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0041),OemToAnsi(STR0014))  //"Prf Numero       P TP Fornec Nome Fornecedor    Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Pago Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi(STR0040),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 2
	cFilDe := cFilAnt
	cFilAte:= cFilAnt
Else
	cFilDe := mv_par18	// Todas as filiais
	cFilAte:= mv_par19
EndIf
// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	titulo += OemToAnsi(STR0015)  //" por data de pagamento"
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	titulo += OemToAnsi(STR0016) // " por Banco"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	titulo += OemToAnsi(STR0017)  //" por Natureza"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	titulo += OemToAnsi(STR0020)  //" Alfabetica"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	titulo += OemToAnsi(STR0035) //" Nro. dos Titulos"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	titulo += OemToAnsi(STR0019)  //" Por Data de Digitacao"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= mv_par20 .and. E5_LOTE <= mv_par21"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	titulo += OemToAnsi(STR0036)  //" por Lote"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
OtherWise						// Data de Crédito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	titulo += OemToAnsi(STR0015)  //" por data de pagamento"
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert("Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert("Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400"
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "
		cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "
		cQuery += "      E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06       + "' AND "
		cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
		cQuery += "      D_E_L_E_T_ = ' '  AND "
		cQuery += "		  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC <> 'CD')) "
		
		If mv_par11 == 2
			cQuery += " AND E5_TIPODOC <> 'E2'"
		EndIf
		
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par28,";")
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par29,";")
		EndIf
		
		If mv_par16 == 2
			cQuery += " AND E5_TIPODOC <> '" + SPACE(LEN(E5_TIPODOC)) + "'"
			cQuery += " AND E5_NUMERO  <> '" + SPACE(LEN(E5_NUMERO)) + "'"
			cQuery += " AND E5_TIPODOC <> 'CH'"
		Endif
		
		If mv_par17 == 2
			cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			cQuery += " AND E5_FILIAL between '" + mv_par18 + "' AND '" + mv_par19 + "'"
		Endif
		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + SqlOrder(cChave) 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³
		//³ TemBxCanc() utilizara o SE5 sem filtro.							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par11 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		cFilSE5 += 'E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'".and.'
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par07+'"'+'.and.E5_CLIFOR<='+'"'+mv_par08+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par09)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par10)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par20+'"'+'.and.E5_LOTE<='+'"'+mv_par21+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par22+'"'+'.and.E5_LOJA<='+'"'+mv_par23+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par26+'"'+'.And.E5_PREFIXO<='+'"'+mv_par27+'"'
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par28)+Space(1)+'"'
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'")'
		EndIf
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	cFilAnt := SM0->M0_CODFIL
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")
	SetRegua(RecCount())
	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	If !lAsTop
		Eval(bFirst) // Posiciona no primeiro registro a ser processado
	Endif

	While NEWSE5->(!Eof()) .And. NEWSE5->E5_FILIAL==xFilial("SE5") .And. &cCondicao .and. lContinua
		If lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
			lContinua:=.F.
			Exit
		EndIf
		
		IncRegua()
		DbSelectArea("NEWSE5")
		// Testa condicoes de filtro	
		If !Fr190TstCond(cFilSe5,.F.)
			NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
			Loop
		Endif	
				 	
		If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
			(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
			cCarteira := "R"
		Else
			cCarteira := "P"
		Endif

		dbSelectArea("NEWSE5")
		cAnterior 	:= &cCond2
		nTotValor	:= 0
		nTotDesc	:= 0
		nTotJuros	:= 0
		nTotMulta	:= 0
		nTotCM		:= 0
		nCT			:= 0
		nTotOrig	:= 0
		nTotBaixado	:= 0
		nTotAbat  	:= 0
		nTotMovFin	:= 0
		nTotComp		:= 0

		While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. NEWSE5->E5_FILIAL=xFilial("SE5") .and. lContinua

			lManual := .f.
			dbSelectArea("NEWSE5")
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIF

			If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
				(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
				lManual := .t.
			EndIf
			
			// Testa condicoes de filtro	
			If !Fr190TstCond(cFilSe5,.T.)
				dbSelectArea("NEWSE5")
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif	
			
			cNumero    	:= NEWSE5->E5_NUMERO
			cPrefixo   	:= NEWSE5->E5_PREFIXO
			cParcela   	:= NEWSE5->E5_PARCELA
			dBaixa     	:= NEWSE5->E5_DATA
			cBanco     	:= NEWSE5->E5_BANCO
			cNatureza  	:= NEWSE5->E5_NATUREZ
			cCliFor    	:= NEWSE5->E5_BENEF
			cLoja      	:= NEWSE5->E5_LOJA
			cSeq       	:= NEWSE5->E5_SEQ
			cNumCheq   	:= NEWSE5->E5_NUMCHEQ
			cRecPag 	:= NEWSE5->E5_RECPAG
			cMotBaixa	:= NEWSE5->E5_MOTBX
			cCheque    	:= NEWSE5->E5_NUMCHEQ
			cTipo      	:= NEWSE5->E5_TIPO
			cFornece   	:= NEWSE5->E5_CLIFOR
			cLoja      	:= NEWSE5->E5_LOJA
			dDigit     	:= NEWSE5->E5_DTDIGIT
			lBxTit	  	:= .F.
			cFilorig    := NEWSE5->E5_FILORIG
			
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				dbSelectArea("SE1")
				dbSetOrder(1)
				lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo)
				If !lBxTit
					lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
				Endif				
				cCarteira := "R"
				dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
				While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
					If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
						Exit
					Endif
					SE1->( dbSkip() )
				EndDo
				If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
					(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
					If !(SE1->E1_SITUACA $ mv_par15)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif
				Endif
				cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
				nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
			Else
				dbSelectArea("SE2")
				DbSetOrder(1)
				cCarteira := "P"
				lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				If !lBxTit
					lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				Endif				
				dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
				cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
				nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
				cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
			Endif
			dbSelectArea("NEWSE5")
			IncRegua()
			cHistorico := Space(40)
			While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. NEWSE5->E5_FILIAL==xFilial("SE5")
				
				IncRegua()
				dbSelectArea("NEWSE5")
				cTipodoc   := NEWSE5->E5_TIPODOC

				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
					lContinua:=.F.
					Exit
				EndIF

				// Testa condicoes de filtro	
				If !Fr190TstCond(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	
				
				If NEWSE5->E5_SITUACA $ "C/E/X" 
					dbSelectArea("NEWSE5")
					NEWSE5->( dbSkip() )
					Loop
				EndIF
				
				If NEWSE5->E5_LOJA != cLoja
					Exit
				Endif

				If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
					dbSelectArea("NEWSE5")
					NEWSE5->( dbSkip() )
					Loop
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o vencto do Titulo ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFilTrb := If(mv_par11==1,"SE1","SE2")
				If (cFilTrb)->(!Eof()) .And.;
					((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())
					Loop
				Endif
            
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag		:= NEWSE5->E5_RECPAG
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cTipo190		:= NEWSE5->E5_TIPO
				cFilorig    := NEWSE5->E5_FILORIG
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Obter moeda da conta no Banco.                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc	# "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
					SA6->(DbSetOrder(1))
					SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
					nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
				Else
					nMoedaBco	:=	1
				Endif

				If !Empty(NEWSE5->E5_NUMERO)
					If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
						(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
						dbSelectArea( "SA1")
						dbSetOrder(1)
						lAchou := .F.
						If Empty(xFilial("SA1"))  //SA1 Compartilhado
							If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif
						Else
							cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
							If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
									lAchou := .T.
								Else
									cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Endif
								Endif
							Endif							
						EndIF
			            If mv_par30==1
							cCliFor := SA1->A1_NREDUZ
						Else //Imprime ou nao o nome Fantasia
							cCliFor := SA1->A1_NOME
						Endif
					Else
						dbSelectArea( "SA2")
						dbSetOrder(1)
						lAchou := .F.
						If Empty(xFilial("SA2"))  //SA2 Compartilhado
							If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif
						Else
							cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
							If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
									lAchou := .T.
								Else
									cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Endif
								Endif
							Endif							
						EndIF
						If lAchou 
							If mv_par30==1
								cCliFor := SA2->A2_NREDUZ
							Else //Imprime ou nao o nome Fantasia
								cCliFor := SA2->A2_NOME
								//cCliFor := SA1->A1_NOME
							Endif
						Endif
					EndIf
				EndIf
				dbSelectArea("SM2")
				dbSetOrder(1)
				dbSeek(NEWSE5->E5_DATA)
				dbSelectArea("NEWSE5")
				nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
				nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
					cHistorico := NEWSE5->E5_HISTOR
					nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				Else
					nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
					cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
					cNatureza  	:= NEWSE5->E5_NATUREZ
				Endif	
				dbSkip()
				If lManual		// forca a saida do looping se for mov manual
					Exit
				Endif
			EndDO

			If (nDesc+nValor+nJuros+nCM+nMulta+nVlMovFin) > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ C lculo do Abatimento        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cCarteira == "R" .and. !lManual
					dbSelectArea("SE1")
					nRecno := Recno()
					nAbat := SomaAbat(cPrefixo,cNumero,cParcela,"R",mv_par12,,cFornece,cLoja)
					dbSelectArea("SE1")
					dbGoTo(nRecno)
				Elseif !lManual
					dbSelectArea("SE2")
					nRecno := Recno()
					nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
					dbSelectArea("SE2")
					dbGoTo(nRecno)
				EndIF

				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				EndIF

				IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
					If lBxTit
						@li, aColu[05] PSAY SE1->E1_CLIENTE
					Endif
					@li, aColu[06] PSAY SubStr(cCliFor,1,18)
					li++
				Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
					If lBxTit
						@li, aColu[05] PSAY SE2->E2_FORNECE
					Endif
					@li, aColu[06] PSAY SubStr(cCliFor,1,18)
					li++
				Endif

				@li, aColu[01] PSAY cPrefixo
				@li, aColu[02] PSAY cNumero
				@li, aColu[03] PSAY cParcela
				@li, aColu[04] PSAY cTipo		

				If !lManual
					dbSelectArea("TRB")
					lOriginal := .T.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Baixas a Receber             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cCarteira == "R"
						cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
						nVlr:= SE1->E1_VLCRUZ
						If mv_par12 > 1
							nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDesc+1)
						EndIF
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixa de PA                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Else
						cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
						nVlr:= SE2->E2_VLCRUZ
						If mv_par12 > 1
							nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
						Endif
					Endif
					cFilTrb := If(cCarteira=="R","SE1","SE2")
					IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
						nVlr:=0
						nAbat:=0
						lOriginal := .F.
					Else
						nVlr:=NoRound(nVlr)
						RecLock("TRB",.T.)
						Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
						MsUnlock()
					EndIF
				Else
					If lAsTop
						dbSelectArea("SE5")
					Else
						dbSelectArea("NEWSE5")
					Endif
					dbgoto(nRecSe5)
					nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
					nAbat:= 0
					lOriginal := .t.
					If lAsTop
						nRecSe5:=NEWSE5->SE5RECNO
					Else
						nRecSe5:=Recno()
						NEWSE5->( dbSkip() )
					Endif
					dbSelectArea("TRB")
				Endif
				IF cCarteira == "R"
					If ( !lManual )
						If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
							cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
						Else
							cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
						Endif
					EndIf
					If aTam[1] <= 6 .and. !lManual
						If lBxTit
							@li, aColu[05] PSAY SE1->E1_CLIENTE
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
					Endif
					@li, 49 PSAY cNatureza
					If Empty( dDtMovFin ) .or. dDtMovFin == Nil
						dDtMovFin := CtoD("  /  /  ")
					Endif
					@li, 60 PSAY IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.))
					@li, 71 PSAY SubStr( cHistorico ,1,18)
					@li,102 PSAY dBaixa
					IF nVlr > 0
						@li,114 PSAY nVlr  Picture tm(nVlr,14,nDecs)
					Endif
				Else
					If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
						cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
					Else
						cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
					Endif
					If aTam[1] <= 6 .and. !lManual
						If lBxTit
							@li, aColu[05] PSAY SE2->E2_FORNECE
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
					Endif
					@li, 49 PSAY cNatureza
					If Empty( dDtMovFin ) .or. dDtMovFin == Nil
						dDtMovFin := CtoD("  /  /  ")
					Endif
					@li, 60 PSAY IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.))
					If !Empty(cCheque)
						@li, 71 PSAY SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,30)
					Else
						@li, 71 PSAY SubStr(ALLTRIM(cHistorico),1,30)
					EndIf
					@li,102 PSAY dBaixa
					IF nVlr > 0
						@li,114 PSAY nVlr Picture tm(nVlr,14,nDecs)
					Endif
				Endif

				nCT++
				@li,129 PSAY nJuros     PicTure tm(nJuros,12,nDecs)
				@li,142 PSAY nMulta     PicTure tm(nMulta,12,nDecs)

				//@li,142 PSAY nCM        PicTure tm(nCM ,12,nDecs)

				@li,155 PSAY nDesc      PicTure tm(nDesc,12,nDecs)
				@li,168 PSAY nAbat  	 Picture tm(nAbat,12,nDecs)
				If nVlMovFin > 0
					@li,181 PSAY nVlMovFin     PicTure tm(nVlMovFin,14,nDecs)
				Else
					@li,181 PSAY nValor			PicTure tm(nValor,14,nDecs)
				Endif
				@li,196 PSAY cBanco
				@li,202 PSAY dDigit

				If empty(cMotBaixa)
					cMotBaixa := "NOR"  //NORMAL
				Endif

				@li,211 PSAY Substr(cMotBaixa,1,3)
				@li,215 PSAY cFilorig
				
				nTotOrig   += Iif(lOriginal,nVlr,0)
				nTotBaixado+= Iif(cTipodoc == "CP",0,nValor)		// n„o soma, j  somou no principal
				nTotDesc   += nDesc
				nTotJuros  += nJuros
				nTotMulta  += nMulta
				nTotCM     += nCM
				nTotAbat   += nAbat
				nTotValor  += IIF( nVlMovFin <> 0, nVlMovFin , Iif(MovBcoBx(cMotBaixa),nValor,0))
				nTotMovFin += nVlMovFin
				nTotComp	  += Iif(cTipodoc == "CP",nValor,0)
				nDesc := nJuros := nValor := nMulta := nCM := nAbat := nVlMovFin := 0
				li++
			Endif
			dbSelectArea("NEWSE5")
		Enddo

		If (nTotValor+nDesc+nJuros+nCM+nTotMulta+nTotOrig+nTotMovFin+nTotComp)>0
			li++
			IF li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			Endif
			If nCT > 0
				IF nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8
					@li, 0 PSAY "Sub Total : " + DTOC(cAnterior)
				Elseif nOrdem == 2 .or. nOrdem == 4 .or. nOrdem == 7
					cLinha := "Sub Total : "+cAnterior+" "
					If nOrdem == 4
						If (mv_par11 == 1 .and. (cRecpag == "R" .and. !(cTipo190 $ MVPAGANT+"/"+MV_CPNEG))) .or. ;
								(cRecpag == "P" .and. cTipo190 $ MVRECANT+"/"+MV_CRNEG)

							dbSelectArea("SA1")
							DbSetOrder(1)
							If !Empty(cAnterior)
								MsSeek(cFilial+cFornece)
								cLinha+=" "+A1_CGC
							Else
								cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
							Endif
						ElseIF (mv_par11 == 2 .and. (cRecpag == "P" .and. !(cTipo190 $ MVRECANT+"/"+MV_CRNEG))) .or.;
								(cRecpag == "R" .and. cTipo190 $ MVPAGANT+"/"+MV_CPNEG)
							dbSelectArea("SA2")
							DbSetOrder(1)
							If !Empty(cAnterior)
								MsSeek(cFilial+cFornece)
								cLinha+=TRIM(A2_NOME)+"  "+A2_CGC
							Else
								cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
							Endif
						Endif
					Elseif nOrdem == 2
						dbSelectArea("SA6")
						DbSetOrder(1)
						MsSeek(cFilial+cAnterior)
						cLinha+=TRIM(A6_NOME)
					Endif
					@li,0 PSAY cLinha
				Elseif nOrdem == 3
					dbSelectArea("SED")
					DbSetOrder(1)
					MsSeek(cFilial+cAnterior)
					@li, 0 PSAY "SubTotal : " + cAnterior + " "+ED_DESCRIC
				Endif
				If nOrdem != 5
					@li,114 PSAY nTotOrig     PicTure tm(nTotOrig,14,nDecs)
					@li,129 PSAY nTotJuros    PicTure tm(nTotJuros,12,nDecs)
					@li,142 PSAY nTotMulta    PicTure tm(nTotMulta,12,nDecs)
					//@li,142 PSAY nTotCM       PicTure tm(nTotCM ,12,nDecs)
					@li,155 PSAY nTotDesc     PicTure tm(nTotDesc,12,nDecs)
					@li,168 PSAY nTotAbat     Picture tm(nTotAbat,12,nDecs)
					@li,181 PSAY nTotValor    PicTure tm(nTotValor,14,nDecs)
					If nTotBaixado > 0
						@li,197 PSAY OemToAnsi(STR0028)  //"Baixados"
						@li,206 PSAY nTotBaixado  PicTure tm(nTotBaixado,14,nDecs)
					Endif	
					If nTotMovFin > 0
						li++
						@li,197 PSAY OemToAnsi(STR0031)   //"Mov Fin."
						@li,206 PSAY nTotMovFin   PicTure tm(nTotMovFin,14,nDecs)
					Endif
					If nTotComp > 0
						li++
						@li,197 PSAY STR0037  //"Compens."
						@li,206 PSAY nTotComp     PicTure tm(nTotComp,14,nDecs)
					Endif
					li+=2
				Endif
				dbSelectArea("NEWSE5")
			Endif
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incrementa Totais Gerais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGerOrig		+= nTotOrig
		nGerValor	+= nTotValor
		nGerDesc		+= nTotDesc
		nGerJuros	+= nTotJuros
		nGerCM		+= nTotCM
		nGerMulta	+= nTotMulta
		nGerAbat		+= nTotAbat
		nGerBaixado += nTotBaixado
		nGerMovFin	+= nTotMovFin
		nGerComp		+= nTotComp
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incrementa Totais Filial ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFilOrig		+= nTotOrig
		nFilValor	+= nTotValor
		nFilDesc		+= nTotDesc
		nFilJuros	+= nTotJuros
		nFilCM		+= nTotCM
		nFilMulta	+= nTotMulta
		nFilAbat		+= nTotAbat
		nFilBaixado += nTotBaixado
		nFilMovFin	+= nTotMovFin
		nFilComp		+= nTotComp
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .And. li != 80
		@li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
		@li,114 PSAY nFilOrig       PicTure tm(nFilOrig,14,nDecs)
		@li,129 PSAY nFilJuros      PicTure tm(nFilJuros,12,nDecs)
		@li,142 PSAY nFilMulta      PicTure tm(nFilMulta,12,nDecs)
		//@li,142 PSAY nFilCM         PicTure tm(nFilCM ,12,nDecs)
		@li,155 PSAY nFilDesc       PicTure tm(nFilDesc,12,nDecs)
		@li,168 PSAY nFilAbat       PicTure tm(nFilAbat,12,nDecs)
		@li,181 PSAY nFilValor      PicTure tm(nFilValor,14,nDecs)
		If nFilBaixado > 0 
			@li,197 PSAY OemToAnsi(STR0028) // "Baixados"
			@li,206 PSAY nFilBaixado    PicTure tm(nFilBaixado,14,nDecs)
		Endif
		If nFilMovFin > 0
			li++
			@li,197 PSAY OemToAnsi(STR0031)   //"Mov Fin."
			@li,206 PSAY nFilMovFin   PicTure tm(nFilMovFin,14,nDecs)
		Endif
		If nFilComp > 0
			li++
			@li,197 PSAY STR0037  //"Compens."
			@li,206 PSAY nFilComp     PicTure tm(nFilComp,14,nDecs)
		Endif
		li+=2
		If Empty(xFilial("SE5"))
			Exit
		Endif	

		nFilOrig:=nFilJuros:=nFilMulta:=nFilCM:=nFilDesc:=nFilAbat:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=0
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo


If li != 80
	// Imprime o cabecalho, caso nao tenha espaco suficiente para impressao do total geral
	If (li+4)>=60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	li+=2
	@li,  0 PSAY OemToAnsi(STR0029)  //"Total Geral : "
	@li,114 PSAY nGerOrig       PicTure tm(nGerOrig,14,nDecs)
	@li,129 PSAY nGerJuros      PicTure tm(nGerJuros,12,nDecs)
	@li,142 PSAY nGerMulta      PicTure tm(nGerMulta,12,nDecs)
	//@li,142 PSAY nGerCM         PicTure tm(nGerCM ,12,nDecs)
	@li,155 PSAY nGerDesc       PicTure tm(nGerDesc,12,nDecs)
	@li,168 PSAY nGerAbat       PicTure tm(nGerAbat,12,nDecs)
	@li,181 PSAY nGerValor      PicTure tm(nGerValor,14,nDecs)
	If nGerBaixado > 0 
		@li,197 PSAY OemToAnsi(STR0028) // "Baixados"
		@li,206 PSAY nGerBaixado    PicTure tm(nGerBaixado,14,nDecs)
	Endif
	If nGerMovFin > 0
		li++
		@li,197 PSAY OemToAnsi(STR0031)   //"Mov Fin."
		@li,206 PSAY nGerMovFin   PicTure tm(nGerMovFin,14,nDecs)
	Endif
	If nGerComp > 0
		li++
		@li,197 PSAY STR0037  //"Compens."
		@li,206 PSAY nGerComp     PicTure tm(nGerComp,14,nDecs)
	Endif
	li++
	roda(cbcont,cbtxt,"G")
Endif

SM0->(dbgoto(nRecEmp))
cFilAnt := SM0->M0_CODFIL
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fr190TstCo³ Autor ³ Claudio D. de Souza   ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Testa as condicoes do registro do SE5 para permitir a impr.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Fr190TstCon(cFilSe5)													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilSe5 - Filtro em CodBase										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr190TstCond(cFilSe5,lInterno)
Local lRet := .T.
Local nMoedaBco
Local lManual := .F.

If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
	(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
	lRet := .F.
Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2" 
	lRet := .F.
Case NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TR#TE" .or.;
	(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
	lRet := .F.
Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
	lRet := .F. 
Case mv_par16 == 2 .and. NEWSE5->E5_TIPODOC $ "CH" 
	lRet := .F. 
Case NEWSE5->E5_TIPODOC == "TR"
	lRet := .F.
Case mv_par11 = 1 .And. E5_TIPODOC $ "E2#CB"
	lRet := .F.
Case NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se escolhido o parƒmetro "baixas normais", apenas imprime as baixas  ³
	//³que gerarem movimenta‡„o banc ria e as movimenta‡”es financeiras     ³
	//³manuais, se consideradas.                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual	
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case !Empty(cFilterUser).and.!(&cFilterUser)
	lRet := .F.	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe estorno para esta baixa, somente no nivel de quebra ³
	//³ mais interno, para melhorar a performance 										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case lInterno .And.;
	  TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))	
	lRet := .F.
EndCase

If lRet .And. NEWSE5->E5_RECPAG == "R"
	If (NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 ) .and.;
		NEWSE5->E5_MOTBX == "CMP"
		lRet := .F.
	EndIf
Endif
If lRet .And. NEWSE5->E5_RECPAG == "P"
	If (NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 ) .and.;
		NEWSE5->E5_MOTBX == "CMP"
		lRet := .F.
	EndIf
Endif	

If lRet .And. mv_par25 == 2
	If cPaisLoc	# "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
	   SA6->(DbSetOrder(1))
	   SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
	   nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	Else
	   nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par12
		lRet := .F.
	EndIf
EndIf

Return lRet     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Claudio D. de Souza   ³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR190                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aArea := GetArea()
Local nX
Local cPerg		:= "FIN190"
Local aRegs		:= {}
Local cOrdem
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

AAdd(aRegs,{"Da Filial Origem ?","¨De Sucursal Origem?","From Original Branch ?","mv_chv","C",2,0,0,"G","","mv_par33","","","","","","","","","",""})
AAdd(aRegs,{"Ate Filial Origem ?","¨A Sucursal Origem?","To Original Branch ?","mv_chx","C",2,0,0,"G","","mv_par34","","","","ZZ","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aRegs)
	cOrdem := StrZero(nX+32,2)
	If !MsSeek(cPerg+cOrdem)
		RecLock("SX1",.T.)
		Replace X1_GRUPO		With cPerg
		Replace X1_ORDEM		With cOrdem 
		Replace x1_pergunte	With aRegs[nx][01]
		Replace x1_perspa		With aRegs[nx][02]
		Replace x1_pereng		With aRegs[nx][03]
		Replace x1_variavl	With aRegs[nx][04]
		Replace x1_tipo		With aRegs[nx][05]
		Replace x1_tamanho	With aRegs[nx][06]
		Replace x1_decimal	With aRegs[nx][07]
		Replace x1_presel		With aRegs[nx][08]
		Replace x1_gsc			With aRegs[nx][09]
		Replace x1_valid		With aRegs[nx][10]
		Replace x1_var01		With aRegs[nx][11]
		Replace x1_def01		With aRegs[nx][12]
		Replace x1_defspa1	With aRegs[nx][13]
		Replace x1_defeng1	With aRegs[nx][14]
		Replace x1_cnt01		With aRegs[nx][15]
		Replace x1_var02		With aRegs[nx][16]
		Replace x1_def02		With aRegs[nx][17]
		Replace x1_defspa2	With aRegs[nx][18]
		Replace x1_defeng2	With aRegs[nx][19]
		Replace x1_f3			With aRegs[nx][20]
		Replace x1_grpsxg		With aRegs[nx][21]
		MsUnlock()
	Endif
Next
dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek(cPerg+"24")
	If "NCC Compensados" $ X1_PERGUNTE
		RecLock("SX1")
		Replace X1_PERGUNTE	With "Adiant.Compensados ?"
		Replace X1_PERSPA		With "¿Anticip.Compensado?"
		Replace X1_PERENG		With "Cleared Advances   ?"
		MsUnlock()
	Endif
Endif			
//Altera o tamanho da pergunta e ativa os novos tipos de cobrança (FGH)
dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek(cPerg+"15")
	RecLock("SX1")
	Replace X1_TAMANHO	With 11
	Replace X1_CNT01		With "01234567FGH"
	MsUnlock()
Endif			

AADD(aHelpPor,"Informe o código inicial do intervalo")
AADD(aHelpPor,"de códigos dos Clientes/Fornecedores ")
AADD(aHelpPor,"a serem considerados na geração do ")
AADD(aHelpPor,"relatório.                         ")

AADD(aHelpEng,"Select the initial code of the interval ")
AADD(aHelpEng,"related to code of Customers/Supliers   ")
AADD(aHelpEng,"to be considered when generating the    ")
AADD(aHelpEng,"report.                                 ")

AADD(aHelpSpa,"Digite el codigo inicial del intervalo")
AADD(aHelpSpa,"de codigos de los clientes/proveedor  ")
AADD(aHelpSpa,"que se deben considerar en la         ")
AADD(aHelpSpa,"generacion del informe.               ")

PutSX1Help("P.FIN19007.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}

AADD(aHelpPor,"Informe o código final do intervalo")
AADD(aHelpPor,"de códigos dos Clientes/Fornecedores ")
AADD(aHelpPor,"a serem considerados na geração do ")
AADD(aHelpPor,"relatório.                         ")

AADD(aHelpEng,"Select the final code of the interval ")
AADD(aHelpEng,"related to code of Customers/Supliers ")
AADD(aHelpEng,"to be considered when generating the  ")
AADD(aHelpEng,"report.                               ")

AADD(aHelpSpa,"Digite el codigo final del intervalo")
AADD(aHelpSpa,"de codigos de los clientes/proveedor  ")
AADD(aHelpSpa,"que se deben considerar en la         ")
AADD(aHelpSpa,"generacion del informe.               ")

PutSX1Help("P.FIN19008.",aHelpPor,aHelpEng,aHelpSpa)


RestArea(aArea)
Return
