//#INCLUDE "FINR190.CH"
#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINR190  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Nhfin031()
    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local wnrel
Local aOrd:={OemToAnsi("Por Data"),OemToAnsi("Por Banco"),OemToAnsi("Por Natureza"),OemToAnsi("Alfabetica"),OemToAnsi("Nro. Titulo"),OemToAnsi("Dt.Digitacao"),OemToAnsi("Por Lote"),"Por Data de Credito"}  
Local cDesc1   := "Este programa ir  emitir a relacao dos titulos baixados."
Local cDesc2   := "Poder  ser emitido por data, banco, natureza ou alfabetica"
Local cDesc3   := "de cliente ou fornecedor e data da digitacao."
Local tamanho  :="G"
Local limite   := 220
Local cString  :="SE5"

Private titulo :=OemToAnsi("Relacao de Baixas")
Private cabec1
Private cabec2
Private cNomeArq
Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:="FINR190"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="FIN190"

AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³
//³ TemBxCanc() utilizara o SE5 sem filtro.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !( ChkFile("SE5",.F.,"NEWSE5") )
  Return(Nil)
EndIf

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
//³ mv_par29            // Nao Imprimir tipos                ³
//³ mv_par30            // Nome Reduzido ou Razo Social      ³
//³ mv_par31            // Da Filial Origem                ³
//³ mv_par32            // Ate Filial Origem               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR190"            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
  dbSelectArea("NEWSE5")
  dbCloseArea()
  Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
  dbSelectArea("NEWSE5")
  dbCloseArea()
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
Local nTimes  := 0
Local cMotBaixa := CRIAVAR("E5_MOTBX")
Local cFilNome := Space(15)
Local cCliFor190 := ""
Local aTam := IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu := {}
Local nDecs      := GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),"")))
Local nMoedaBco:= 1
Local nMoeda   :=mv_par12
Local lCarteira
Local cFilTrb
Local cFilOrig

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem   := aReturn[8]
cSuf     := LTrim(Str(mv_par12))
cMoeda   := GetMv("MV_MOEDA"+cSuf)
cCond3   := ".T."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF mv_par11 == 1
 	titulo := OemToAnsi("Relacao dos Titulos Recebidos em ")  + cMoeda  //"Relacao dos Titulos Recebidos em "
  	// cabec1 := OemToAnsi("Prf Numero       P TP Client Nome Cliente       Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Rec. Bco Dt Digit. Mot. Baixa")
  	cabec1 := OemToAnsi("Prf Numero       P TP Client Nome Cliente       Natureza    Vencto     Historico                         Dt Baixa   Valor Original Tx Perman          Multa     Correcao    Descontos     Total Rec. Bco Dt Digit. Mot. Baixa")
Else
 	titulo := OemToAnsi("Relacao dos Titulos Pagos em ")  + cMoeda  //"Relacao dos Titulos Pagos em "
  	cabec1 := OemToAnsi("Prf Numero       P TP Fornec Nome Fornecedor    Natureza    Vencto     Historico                         Dt Baixa   Valor Original Tx Perman          Multa     Correcao    Descontos     Total Pago Bco Dt Digit. Mot. Baixa")
Endif
cabec2 := ""

dbSelectArea("NEWSE5")
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 2
  cFilDe := cFilAnt
  cFilAte:= cFilAnt
Else
  cFilDe := mv_par18  // Todas as filiais
  cFilAte:= mv_par19
EndIf

aColu := Iif(aTam[1] > 6,{023,027,040,042,000,022},{000,004,017,019,023,030})

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
  cFilAnt := SM0->M0_CODFIL
  cFilNome:= SM0->M0_FILIAL

  nTimes++

  DbSelectArea("NEWSE5")
  If nOrdem == 1
      cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
      cCond2 := "E5_DATA"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          DbSetOrder(1)
          cChave := IndexKey()
          titulo += OemToAnsi(" por data de pagamento")
          cNomeArq := CriaTrab(Nil,.F.)
          IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))
      EndIf
      DbSeek(xFilial("SE5")+Dtos(mv_par01),.T.)
  ElseIf nOrdem == 2
      cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
      cCond2 := "E5_BANCO"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          DbSetOrder(3)
          cChave := IndexKey()
          titulo += OemToAnsi(" por Banco")
          cNomeArq := CriaTrab(Nil,.F.)
          IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))
      EndIf
      DbSeek(xFilial("SE5")+mv_par03,.T.)
  ElseIf nOrdem == 3
      cCondicao := "E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06"
      cCond2 := "E5_NATUREZ"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          DbSetOrder(4)
          cChave := IndexKey()
          titulo += OemToAnsi(" por Natureza")
          cNomeArq := CriaTrab(Nil,.F.)
          IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))
      EndIf
      DbSeek(xFilial("SE5")+mv_par05,.T.)
  ElseIf nOrdem == 4
      cCondicao := ".T."
      cCond2 := "E5_BENEF"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          titulo += OemToAnsi(" Alfabetica")
          cNomeArq := CriaTrab("",.f.)
          IndRegua("NEWSE5",cNomeArq,"E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA",,cFilSe5,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
      EndIf
      DbSeek(xFilial("SE5"),.T.)
  Elseif nOrdem == 5
      cCondicao := ".T."
      cCond2 := "E5_NUMERO"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          titulo += OemToAnsi(" Nro. dos Titulos")
          cNomeArq := CriaTrab("",.f.)
          IndRegua("NEWSE5",cNomeArq,"E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)",,cFilSE5,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
      EndIf
      DbSeek(xFilial("SE5"),.T.)
  ElseIf nOrdem == 6  //Ordem 6 (Digitacao)
      cCondicao := ".T."
      cCond2 := "E5_DTDIGIT"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          titulo += OemToAnsi(" Por Data de Digitacao")
          cNomeArq := CriaTrab("",.f.)
          IndRegua("NEWSE5",cNomeArq,"E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)",,cFilSE5,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
      EndIf
      DbSeek(xFilial("SE5"),.T.)
  ElseIf nOrdem == 7 // por Lote
      cCondicao := "E5_LOTE >= mv_par20 .and. E5_LOTE <= mv_par21"
      cCond2 := "E5_LOTE"

      DbSelectArea("NEWSE5")
      If nTimes == 1
          DbSetOrder(5)
          cChave := IndexKey()
          titulo += OemToAnsi(" por Lote")
          cNomeArq := CriaTrab(Nil,.F.)
          IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))
      EndIf
      DbSeek(xFilial("SE5")+mv_par20,.T.)
  Else                        // Data de Crédito (dtdispo)
      cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
      cCond2 := "E5_DTDISPO"
      DbSelectArea("NEWSE5")
      If nTimes == 1
          cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
          titulo += OemToAnsi(" por data de pagamento")
          cNomeArq := CriaTrab(Nil,.F.)
          IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))
      EndIf
      DbSeek(xFilial("SE5")+Dtos(mv_par01),.T.)
  EndIf

  DbSelectArea("NEWSE5")
  SetRegua(RecCount())

  While NEWSE5->(!Eof()) .And. NEWSE5->E5_FILIAL==xFilial("SE5") .And. &cCondicao .and. lContinua
      If lEnd
          @PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
          lContinua:=.F.
          Exit
      EndIf

      IncRegua()

      DbSelectArea("NEWSE5")

      If ! &(cFilSe5)                 // Verifico filtro tambem CODEBASE para
          NEWSE5->(dbSkip())          // filtro de registros desnecessarios
          Loop
      Endif
      If NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2"
          NEWSE5->(dbSkip())          // filtro de registros desnecessarios
          Loop
      Endif

      IF NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TR#TE" .or.;
              (NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
          NEWSE5->(dbSkip())
          Loop
      Endif

      If NEWSE5->E5_FILORIG < mv_par31 .or. NEWSE5->E5_FILORIG > mv_par32
          NEWSE5->( dbSkip() )
          Loop
      EndIF

      If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;   //Titulo normal
          (NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG ))     //Adiantamento
          lCarteira := "R"
      Else
          lCarteira := "P"
      Endif

      If NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
          NEWSE5->( dbSkip())
          Loop
      Endif

      If Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
          NEWSE5->( dbSkip() )
          Loop
      Endif

      If Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
          NEWSE5->( dbSkip() )
          Loop
      Endif
      If NEWSE5->E5_RECPAG == "R"
          If (NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 ) .and.;
                  NEWSE5->E5_MOTBX == "CMP"
              NEWSE5->( dbSkip() )
              LOOP
          EndIF
      EndIF

      If NEWSE5->E5_RECPAG == "P"
          If (NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 ) .and.;
                  NEWSE5->E5_MOTBX == "CMP"
              NEWSE5->( dbSkip() )
              LOOP
          EndIF
      EndIF

      If cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
         SA6->(DbSetOrder(1))
         SA6->(DbSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
         nMoedaBco    :=  Max(SA6->A6_MOEDA,1)
      Else
         nMoedaBco    :=  1
      Endif

        If mv_par25 == 2
           If nMoedaBco <> nMoeda
              NEWSE5->(DbSkip())
              Loop
           EndIf
        EndIf

      cAnterior   := &cCond2
      nTotValor   := 0
      nTotDesc    := 0
      nTotJuros   := 0
      nTotMulta   := 0
      nTotCM      := 0
      nCT         := 0
      nTotOrig    := 0
      nTotBaixado := 0
      nTotAbat    := 0
      nTotMovFin  := 0
      nTotComp    := 0

      While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. NEWSE5->E5_FILIAL=xFilial("SE5") .and. lContinua

          lManual := .f.

          IF NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TR#TE" .or. ;
                  ( NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA )
              NEWSE5->(dbSkip())
              Loop
          Endif
          If NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2"
              NEWSE5->(dbSkip())            // filtro de registros desnecessarios
              Loop
          Endif

          IF lEnd
              @PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
              lContinua:=.F.
              Exit
          EndIF

          If ! &(cFilSe5)                 // Verifico filtro tambem CODEBASE para
              NEWSE5->(dbSkip())            // filtro de registros desnecessarios
              Loop
          Endif

          If Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
              NEWSE5->( dbSkip() )
              Loop
          Endif

          If Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
              NEWSE5->( dbSkip() )
              Loop
          Endif

          If NEWSE5->E5_RECPAG == "R"
              If (NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 ) .and.;
                      NEWSE5->E5_MOTBX == "CMP"
                  NEWSE5->( dbSkip() )
                  LOOP
              EndIF
          EndIF

          If NEWSE5->E5_RECPAG == "P"
              If (NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 ) .and.;
                      NEWSE5->E5_MOTBX == "CMP"
                  NEWSE5->( dbSkip() )
                  LOOP
              EndIF
          EndIF

          If Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1
              lManual := .t.
          EndIf

          If Empty(NEWSE5->E5_NUMERO) .And. mv_par16 == 1
              lManual := .t.
          EndIf

          If NEWSE5->E5_FILORIG < mv_par31 .or. NEWSE5->E5_FILORIG > mv_par32
              NEWSE5->( dbSkip() )
              Loop
          EndIF

          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Na versao TOP reposiciona o SE5 porque a TemBXCanc utiliza o     ³
          //³ SE5 posicionado para a montagem da query.                        ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

          #IFDEF TOP
              DbSelectArea("SE5")
              DbGoto(NEWSE5->(Recno()))
              DbSelectArea("NEWSE5")
          #ENDIF

          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Verifica se existe estorno para esta baixa                       ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
              DbSelectArea("NEWSE5")
              NEWSE5->(DbSkip())
              Loop
          EndIf

          If cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
             SA6->(DbSetOrder(1))
             SA6->(DbSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
             nMoedaBco    :=  Max(SA6->A6_MOEDA,1)
          Else
             nMoedaBco    :=  1
          Endif

            If mv_par25 == 2
               If nMoedaBco <> nMoeda
                  NEWSE5->(DbSkip())
                  Loop
               EndIf
            EndIf

          dbSelectArea("NEWSE5")
          cNumero     := NEWSE5->E5_NUMERO
          cPrefixo    := NEWSE5->E5_PREFIXO
          cParcela    := NEWSE5->E5_PARCELA
          dBaixa      := NEWSE5->E5_DATA
          cBanco      := NEWSE5->E5_BANCO
          cNatureza   := NEWSE5->E5_NATUREZ
          cCliFor     := NEWSE5->E5_BENEF
          cLoja       := NEWSE5->E5_LOJA
          cSeq        := NEWSE5->E5_SEQ
          cNumCheq    := NEWSE5->E5_NUMCHEQ
          cRecPag     := NEWSE5->E5_RECPAG
          cMotBaixa   := NEWSE5->E5_MOTBX
          cFilOrig    := NEWSE5->E5_FILORIG

          If !Empty(NEWSE5->E5_NUMERO)
              If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
                  (NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
                  dbSelectArea( "SA1")
                  dbSetOrder(1)
                  If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
                      cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
                  EndIF
              Else
                  dbSelectArea( "SA2")
                  dbSetOrder(1)
                  If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
                      cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
                  EndIF
              EndIf
          EndIf

          dbSelectArea("NEWSE5")
          cCheque    := NEWSE5->E5_NUMCHEQ
          cTipo      := NEWSE5->E5_TIPO
          cFornece   := NEWSE5->E5_CLIFOR
          cLoja      := NEWSE5->E5_LOJA
          dDigit     := NEWSE5->E5_DTDIGIT
          lBxTit    := .F.

          If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;   //Titulo normal
              (NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG ))     //Adiantamento
              dbSelectArea("SE1")
              DbSetOrder(1)
              lBxTit := dbSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo)
              If !lBxTit
                  lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
              Endif
              lCarteira := "R"
              dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
              While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
                  If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja  // Cliente igual, Ok
                      Exit
                  Endif
                  SE1->( dbSkip() )
              EndDo
              cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
              nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
          Else
              dbSelectArea("SE2")
              DbSetOrder(1)
              lCarteira := "P"
             lBxTit := dbSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
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
          While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. NEWSE5->E5_FILIAL=xFilial("SE5")

              cTipodoc   := NEWSE5->E5_TIPODOC

              IF lEnd
                  @PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
                  lContinua:=.F.
                  Exit
              EndIF

              IncRegua()

              If ! &(cFilSe5)                 // Verifico filtro tambem CODEBASE para
                  NEWSE5->(dbSkip())            // filtro de registros desnecessarios
                  Loop
              Endif
              If NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2"
                  NEWSE5->(dbSkip())            // filtro de registros desnecessarios
                  Loop
              Endif

              If NEWSE5->E5_SITUACA $ "C/E/X"
                  NEWSE5->( dbSkip() )
                  Loop
              EndIF

              If NEWSE5->E5_LOJA != cLoja
                  Exit
              Endif

              If NEWSE5->E5_FILORIG < mv_par31 .or. NEWSE5->E5_FILORIG > mv_par32
                  NEWSE5->( dbSkip() )
                  Loop
              EndIF

              If Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
                  NEWSE5->( dbSkip() )
                  Loop
              Endif

              If NEWSE5->E5_TIPODOC == "TR"
                  NEWSE5->( dbSkip() )
                  Loop
              Endif

              If mv_par11 == 1 .and. !lManual .and.  ;
                      (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
                  If !(SE1->E1_SITUACA $ mv_par15)
                      NEWSE5->( dbSkip() )
                      Loop
                  Endif
              Endif

              If NEWSE5->E5_RECPAG == "R"
                  If (NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par24 == 2 ) .and.;
                          NEWSE5->E5_MOTBX == "CMP"
                      NEWSE5->( dbSkip() )
                      LOOP
                  EndIF
              EndIF

              If NEWSE5->E5_RECPAG == "P"
                  If (NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 ) .and.;
                          NEWSE5->E5_MOTBX == "CMP"
                      NEWSE5->( dbSkip() )
                      Loop
                  EndIf
              EndIf

              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³Se escolhido o parƒmetro "baixas normais", apenas imprime as baixas  ³
              //³que gerarem movimenta‡„o banc ria e as movimenta‡”es financeiras     ³
              //³manuais, se consideradas.                                            ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              If mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual
                  NEWSE5->(DbSkip())
                  Loop
              EndIf

              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ Na versao TOP reposiciona o SE5 porque a TemBXCanc utiliza o     ³
              //³ SE5 posicionado para a montagem da query.                        ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              #IFDEF TOP
                  DbSelectArea("SE5")
                  DbGoto(NEWSE5->(Recno()))
                  DbSelectArea("NEWSE5")
              #ENDIF

              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ Verifica se existe estorno para esta baixa                       ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              If TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
                  DbSelectArea("NEWSE5")
                  NEWSE5->(DbSkip())
                  Loop
              EndIf

              If mv_par11 = 1 .And. E5_TIPODOC $ "E2#CB"
                  NEWSE5->( dbSkip() )
                  Loop
              Endif

              If NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04
                  NEWSE5->( dbSkip() )
                  Loop
              Endif

              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ Considera filtro do usuario                                  ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              dbSelectArea("NEWSE5")
              If !Empty(cFilterUser).and.!(&cFilterUser)
                  NEWSE5->(dbSkip())
                  Loop
              Endif

              If cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
                  SA6->(DbSetOrder(1))
                  SA6->(DbSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
                  nMoedaBco   :=  Max(SA6->A6_MOEDA,1)
              Else
                  nMoedaBco   :=  1
              Endif

              If mv_par25 == 2
                  If nMoedaBco <> nMoeda
                      NEWSE5->(DbSkip())
                      Loop
                  EndIf
              EndIf

              dBaixa      := NEWSE5->E5_DATA
              cBanco      := NEWSE5->E5_BANCO
              cNatureza   := NEWSE5->E5_NATUREZ
              cCliFor     := NEWSE5->E5_BENEF
              cSeq        := NEWSE5->E5_SEQ
              cNumCheq    := NEWSE5->E5_NUMCHEQ
              cRecPag     := NEWSE5->E5_RECPAG
              cMotBaixa   := NEWSE5->E5_MOTBX
              cTipo190    := NEWSE5->E5_TIPO
              cFilorig    := NEWSE5->E5_FILORIG

              If !Empty(NEWSE5->E5_NUMERO)
                  If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
                      (NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
                      dbSelectArea( "SA1")
                      dbSetOrder(1)
                      If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
                          cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
                      EndIF
                  Else
                      dbSelectArea( "SA2")
                      dbSetOrder(1)
                      If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
                          cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
                      EndIF
                  EndIf
              EndIf

              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ Obter moeda da conta no Banco.                               ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              If cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
                  SA6->(DbSetOrder(1))
                  SA6->(DbSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
                  nMoedaBco   :=  Max(SA6->A6_MOEDA,1)
              Else
                  nMoedaBco   :=  1
              Endif
              dbSelectArea("SM2")
              dbSetOrder(1)
              dbSeek(NEWSE5->E5_DATA)
              dbSelectArea("NEWSE5")
              nRecSe5:=Recno()
              nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2))))
              nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2))))
              nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2))))
              nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2))))
              If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
                  cHistorico := NEWSE5->E5_HISTOR
                  nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2))))
              Else
                  nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2))))
                  cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
                  cNatureza   := NEWSE5->E5_NATUREZ
              Endif
              dbSkip()
              If lManual      // forca a saida do looping se for mov manual
                  Exit
              Endif
          EndDO

          If (nDesc+nValor+nJuros+nCM+nMulta+nVlMovFin) > 0
              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ Calculo do Abatimento        ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              If lCarteira == "R" .and. !lManual
                  dbSelectArea("SE1")
                  nRecno := Recno()
                  nAbat := SomaAbat(cPrefixo,cNumero,cParcela,"R",mv_par12,,cFornece,cLoja)
                  dbSelectArea("SE1")
                  dbGoTo(nRecno)
              Elseif !lManual
                  dbSelectArea("SE2")
                  nRecno := Recno()
                  nAbat :=    SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
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
                  If lCarteira == "R"
                      cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
                      nVlr:= SE1->E1_VLCRUZ
                      If mv_par12 > 1
                          nVlr := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_EMISSAO,nDecs+1)
                      EndIF
                      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                      //³ Baixa de PA                  ³
                      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  Else
                      cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
                      nVlr:= SE2->E2_VLCRUZ
                      If mv_par12 > 1
                          nVlr := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_EMISSAO,nDecs+1)
                      Endif
                  Endif
                  cFilTrb := If(lCarteira=="R","SE1","SE2")
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
                  dbSelectArea("NEWSE5")
                  dbgoto(nRecSe5)
                  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                  //³ Obter moeda da conta no Banco.                               ³
                  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                  If cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
                      SA6->(DbSetOrder(1))
                      SA6->(DbSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
                      nMoedaBco   :=  Max(SA6->A6_MOEDA,1)
                  Else
                      nMoedaBco   :=  1
                  Endif
                  nVlr := xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(NEWSE5->E5_VALOR==NEWSE5->E5_VLMOED2,0,NEWSE5->(E5_VALOR/E5_VLMOED2)))
                  nAbat:= 0
                  lOriginal := .t.
                  NEWSE5->( dbSkip() )
                  nRecSe5:=Recno()
                  dbSelectArea("TRB")
              Endif
              IF lCarteira == "R"
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
                  @li, 71 PSAY SubStr( cHistorico ,1,33)
                  @li, 105 PSAY dBaixa // 90
					   /* 
                  IF nVlr > 0
                      @li,116 PSAY nVlr  Picture tm(nVlr,14,nDecs) // 101
                  Endif
                  */
                  @li,116 PSAY nVlr  Picture tm(nVlr,14,nDecs) // 101
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
                      @li, 71 PSAY SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,33)
                  Else
                      @li, 71 PSAY SubStr(ALLTRIM(cHistorico),1,33)
                  EndIf
                  @li, 105 PSAY dBaixa // 90
                	/*
                  IF nVlr > 0
                      @li,116 PSAY nVlr Picture tm(nVlr,14,nDecs) // 101
                  Endif
                  */
					   @li,116 PSAY nVlr Picture tm(nVlr,14,nDecs) // 101
              Endif
              nCT++
              @li,129 PSAY nJuros     PicTure tm(nJuros,10,nDecs) // 116
              @li,142 PSAY nMulta     PicTure tm(nMulta,12,nDecs) // 129
              @li,155 PSAY nCM        PicTure tm(nCM ,12,nDecs)   // 142
              @li,168 PSAY nDesc      PicTure tm(nDesc,12,nDecs)  // 155
              // @li,168 PSAY nAbat       Picture tm(nAbat,12,nDecs) // 168

              If nVlMovFin > 0
                  @li,181 PSAY nVlMovFin     PicTure tm(nVlMovFin,14,nDecs)
              Else
                  @li,181 PSAY nValor         PicTure tm(nValor,14,nDecs)
              Endif
              @li,196 PSAY cBanco
              @li,202 PSAY dDigit

              If empty(cMotBaixa)
                  cMotBaixa := "NOR"  //NORMAL
              Endif

              @li,211 PSAY Substr(cMotBaixa,1,3)
              @li,215 PSAY cFilOrig
              nTotOrig   += Iif(lOriginal,nVlr,0)
              nTotBaixado+= Iif(cTipodoc == "CP",0,nValor)        // n„o soma, j  somou no principal
              nTotDesc   += nDesc
              nTotJuros  += nJuros
              nTotMulta  += nMulta
              nTotCM     += nCM
              nTotAbat   += nAbat
              nTotValor  += IIF( nVlMovFin <> 0, nVlMovFin , Iif(MovBcoBx(cMotBaixa),nValor,0))
              nTotMovFin += nVlMovFin
              nTotComp      += Iif(cTipodoc == "CP",nValor,0)
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
                  @li, 0 PSAY "Sub Total : "+cAnterior
                  If nOrdem == 4
                      If (mv_par11 == 1 .and. (cRecpag == "R" .and. !(cTipo190 $ MVPAGANT+"/"+MV_CPNEG))) .or. ;
                              (cRecpag == "P" .and. cTipo190 $ MVRECANT+"/"+MV_CRNEG)

                          dbSelectArea("SA1")
                          DbSetOrder(1)
                          If !Empty(cAnterior)
                              dbSeek(cFilial+cAnterior)
                              cLinha:=TRIM(A1_NOME)+"  "+A1_CGC
                          Else
                              cLinha:= OemToAnsi("Moviment. Financeiras Manuais ")
                          Endif
                      ElseIF (mv_par11 == 2 .and. (cRecpag == "P" .and. !(cTipo190 $ MVRECANT+"/"+MV_CRNEG))) .or.;
                              (cRecpag == "R" .and. cTipo190 $ MVPAGANT+"/"+MV_CPNEG)
                          dbSelectArea("SA2")
                          DbSetOrder(1)
                          If !Empty(cAnterior)
                              dbSeek(cFilial+cAnterior)
                              cLinha:=TRIM(A2_NOME)+"  "+A2_CGC
                          Else
                              cLinha:= OemToAnsi("Moviment. Financeiras Manuais ")
                          Endif
                      Endif
                      @li,20 PSAY cLinha
                  Elseif nOrdem == 2
                      dbSelectArea("SA6")
                      DbSetOrder(1)
                      dbSeek(cFilial+cAnterior)
                      cLinha:=TRIM(A6_NOME)
                      @li,20 PSAY cLinha
                  Endif
              Elseif nOrdem == 3
                  dbSelectArea("SED")
                  DbSetOrder(1)
                  dbSeek(cFilial+cAnterior)
                  @li, 0 PSAY "SubTotal : " + cAnterior + " "+ED_DESCRIC
              Endif
              If nOrdem != 5
                  @li,116 PSAY nTotOrig     PicTure tm(nTotOrig,14,nDecs)
                  @li,129 PSAY nTotJuros    PicTure tm(nTotJuros,10,nDecs)
                  @li,142 PSAY nTotMulta    PicTure tm(nTotMulta,12,nDecs)
                  @li,155 PSAY nTotCM       PicTure tm(nTotCM ,12,nDecs)
                  @li,168 PSAY nTotDesc     PicTure tm(nTotDesc,12,nDecs)
                  @li,181 PSAY nTotValor    PicTure tm(nTotValor,14,nDecs)
                  If nTotBaixado > 0
                      @li,197 PSAY OemToAnsi("Baixados")
                      @li,205 PSAY nTotBaixado  PicTure tm(nTotBaixado,14,nDecs)
                  Endif
                  If nTotMovFin > 0
                      li++
                      @li,197 PSAY OemToAnsi("Mov Fin.")
                      @li,205 PSAY nTotMovFin   PicTure tm(nTotMovFin,14,nDecs)
                  Endif
                  If nTotComp > 0
                      li++
                      @li,197 PSAY OemToAnsi("Compens.")
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
      nGerOrig    += nTotOrig
      nGerValor   += nTotValor
      nGerDesc    += nTotDesc
      nGerJuros   += nTotJuros
      nGerCM      += nTotCM
      nGerMulta   += nTotMulta
      nGerAbat    += nTotAbat
      nGerBaixado += nTotBaixado
      nGerMovFin  += nTotMovFin
      nGerComp    += nTotComp
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³Incrementa Totais Filial ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nFilOrig    += nTotOrig
      nFilValor   += nTotValor
      nFilDesc    += nTotDesc
      nFilJuros   += nTotJuros
      nFilCM      += nTotCM
      nFilMulta   += nTotMulta
      nFilAbat    += nTotAbat
      nFilBaixado += nTotBaixado
      nFilMovFin  += nTotMovFin
      nFilComp    += nTotComp
  Enddo

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Imprimir TOTAL por filial somente quan-³
  //³ do houver mais do que 1 filial.        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .And. li != 80
      @li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
      @li,116 PSAY nFilOrig       PicTure tm(nFilOrig,14,nDecs)
      @li,129 PSAY nFilJuros      PicTure tm(nFilJuros,10,nDecs)
      @li,142 PSAY nFilMulta      PicTure tm(nFilMulta,12,nDecs)
      @li,155 PSAY nFilCM         PicTure tm(nFilCM ,12,nDecs)
      @li,168 PSAY nFilDesc       PicTure tm(nFilDesc,12,nDecs)
      @li,181 PSAY nFilValor      PicTure tm(nFilValor,14,nDecs)
      If nFilBaixado > 0
          @li,197 PSAY OemToAnsi("Baixados")
          @li,205 PSAY nFilBaixado    PicTure tm(nFilBaixado,14,nDecs)
      Endif
      If nFilMovFin > 0
          li++
          @li,197 PSAY OemToAnsi("Mov Fin.")
          @li,205 PSAY nFilMovFin   PicTure tm(nFilMovFin,14,nDecs)
      Endif
      If nFilComp > 0
          li++
	       @li,197 PSAY OemToAnsi("Compens.")
          @li,205 PSAY nFilComp     PicTure tm(nFilComp,14,nDecs)
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
  @li,  0 PSAY OemToAnsi("Total Geral : ")
  @li,116 PSAY nGerOrig       PicTure tm(nGerOrig,14,nDecs)
  @li,129 PSAY nGerJuros      PicTure tm(nGerJuros,10,nDecs)
  @li,142 PSAY nGerMulta      PicTure tm(nGerMulta,12,nDecs)
  @li,155 PSAY nGerCM         PicTure tm(nGerCM ,12,nDecs)
  @li,168 PSAY nGerDesc       PicTure tm(nGerDesc,12,nDecs)
  @li,181 PSAY nGerValor      PicTure tm(nGerValor,14,nDecs)
  If nGerBaixado > 0
      @li,197 PSAY OemToAnsi("Baixados")
      @li,205 PSAY nGerBaixado    PicTure tm(nGerBaixado,14,nDecs)
  Endif
  If nGerMovFin > 0
      li++
      @li,197 PSAY OemToAnsi("Mov Fin.")
      @li,205 PSAY nGerMovFin   PicTure tm(nGerMovFin,14,nDecs)
  Endif
  If nGerComp > 0
      li++
      @li,197 PSAY OemToAnsi("Compens.")
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
Local cPerg       := "FIN190"
Local aRegs       := {}
Local cOrdem

AAdd(aRegs,{OemToansi("Prefixo De"),OemToansi("Prefixo De"),OemToansi("Prefixo De"),"mv_cho","C",TamSx3("E1_PREFIXO")[1],0,0,"G","","mv_par26","","","","","","","","","",""}) // Prefixo De
AAdd(aRegs,{OemToansi("Prefixo Ate"),OemToansi("Prefixo Ate"),OemToansi("Prefixo Ate"),"mv_chp","C",TamSx3("E1_PREFIXO")[1],0,0,"G","","mv_par27","","","","ZZZ","","","","","",""}) // Prefixo Ate
AAdd(aRegs,{OemToansi("Imprimir Tipos"),OemToansi("Imprimir Tipos"),OemToansi("Imprimir Tipos"),"mv_chq","C",TamSx3("E1_TIPO")[1]*10,0,0,"G","","mv_par28","","","","","","","","","",""}) // Imprimir Tipos
AAdd(aRegs,{OemToansi("Nao Imprimir Tipos"),OemToansi("Nao Imprimir Tipos"),OemToansi("Nao Imprimir Tipos"),"mv_chr","C",TamSx3("E1_TIPO")[1]*10,0,0,"G","","mv_par29","","","","","","","","","",""}) // Nao Imprimir Tipos
AAdd(aRegs,{OemToansi("Imprime Nome"),OemToansi("Imprime Nome"),OemToansi("Imprime Nome"),"mv_chs","N",1,0,1,"C","","mv_par30","Reduzido","Reducido","Reduced","","","Razao Social","Razon Social","Company Name","",""}) // Imprime Nome
AAdd(aRegs,{OemToansi("Da Filial Origem"),OemToansi("Da Filial Origem"),OemToansi("Da Filial Origem"),"mv_cht","C",2,0,0,"G","","mv_par31","","","","","","","","","",""}) // Da Filial Origem
AAdd(aRegs,{OemToansi("Ate Filial Origem"),OemToansi("Ate Filial Origem"),OemToansi("Ate Filial Origem"),"mv_chu","C",2,0,0,"G","","mv_par32","","","","zz","","","","","",""}) // Ate Filial Origem

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aRegs)
  cOrdem := StrZero(nX+25,2)
  If !MsSeek(cPerg+cOrdem)
      RecLock("SX1",.T.)
      Replace X1_GRUPO        With cPerg
      Replace X1_ORDEM        With cOrdem
      Replace x1_pergunte     With aRegs[nx][01]
      Replace x1_perspa       With aRegs[nx][02]
      Replace x1_pereng       With aRegs[nx][03]
      Replace x1_variavl      With aRegs[nx][04]
      Replace x1_tipo         With aRegs[nx][05]
      Replace x1_tamanho      With aRegs[nx][06]
      Replace x1_decimal      With aRegs[nx][07]
      Replace x1_presel       With aRegs[nx][08]
      Replace x1_gsc          With aRegs[nx][09]
      Replace x1_valid        With aRegs[nx][10]
      Replace x1_var01        With aRegs[nx][11]
      Replace x1_def01        With aRegs[nx][12]
      Replace x1_defspa1      With aRegs[nx][13]
      Replace x1_defeng1      With aRegs[nx][14]
      Replace x1_cnt01        With aRegs[nx][15]
      Replace x1_var02        With aRegs[nx][16]
      Replace x1_def02        With aRegs[nx][17]
      Replace x1_defspa2      With aRegs[nx][18]
      Replace x1_defeng2      With aRegs[nx][19]
      Replace x1_f3           With aRegs[nx][20]
      Replace x1_grpsxg       With aRegs[nx][21]
      MsUnlock()
  Endif
Next
dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek(cPerg+"24")
  If "NCC Compensados" $ X1_PERGUNTE
      RecLock("SX1")
      Replace X1_PERGUNTE     With "Adiant.Compensados ?"
      Replace X1_PERSPA       With "¿Anticip.Compensado?"
      Replace X1_PERENG       With "Cleared Advances   ?"
      MsUnlock()
  Endif
Endif
RestArea(aArea)
Return

