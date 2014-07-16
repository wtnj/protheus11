/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FinR710  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±³          ³ Nhfin023 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 25.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bordero de Pagamento.                                      ³±±
±±³          ³ Adaptado para a NHW, fixado o campo SE2->E2_TIPO           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FinR710(void)                                              ³±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"   

User Function NhFin023( )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := "Este programa tem a funcao de emitir os borderos de pagamen-"
LOCAL cDesc2 := "tos."
LOCAL cDesc3 :=""
LOCAL limite := 132
LOCAL Tamanho:="M"
LOCAL cString:="SEA"

PRIVATE titulo := "Emissao de Borderos de Pagamentos"
PRIVATE cabec1 := ""
PRIVATE cabec2 := ""
PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR710"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg  :="FIN710"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN710",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para parametros                        ³
//³ mv_par01              // Do Bordero                         ³
//³ mv_par02              // At‚ o Bordero                      ³
//³ mv_par03              // Data para d‚bito                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a data para debito com a data base do sistema         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")
If dbSeek ("FIN710"+"03")  // Busca a pergunta para mv_par03
  Reclock("SX1",.F.)
  Replace X1_CNT01 With "'"+dtoc(dDataBase)+"'"
  MsUnlock()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR710"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
  Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
  Return
Endif

RptStatus({|lEnd| Fa710Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fa710Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Bordero de Pagamento.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fa710imp                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Generico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA710Imp(lEnd,wnRel,cString, Tamanho)

LOCAL CbCont,CbTxt
LOCAL cModelo
LOCAL nTotValor   := 0
LOCAL lCheque     := .f.
LOCAL lBaixa      := .f.
LOCAL nTipo
LOCAL nColunaTotal
LOCAL cNumConta   := CriaVar("EA_NUMCON")
LOCAL lNew            := .F.
LOCAL cNumBor
LOCAL lAbatimento := .F.
LOCAL nAbat       := 0
Local lFirst := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt     := SPACE(10)
cbcont    := 0
li        := 80
m_pag     := 1

dbSelectArea("SEA")
dbSetOrder( 1 )
dbSeek(cFilial+mv_par01,.T.)

nTipo := aReturn[4]
nContador := 0

SetRegua(RecCount())
lNew := .T.

While !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02

  cNumBor := SEA->EA_NUMBOR

  IF lEnd
      @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
      Exit
  EndIF

  IncRegua()

  IF Empty(EA_NUMBOR)
      dbSkip( )
      Loop
  End

  IF SEA->EA_CART != "P"
      dbSkip( )
      Loop
  End

  lCheque := .f.
  lBaixa  := .f.
  cModelo := SEA->EA_MODELO
  dbSelectArea( "SE2" )
  cLoja := Iif ( Empty(SEA->EA_LOJA) , "" , SEA->EA_LOJA )
  dbSeek( cFilial+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja )
  dbSelectArea( "SE5" )
  dbSetOrder( 2 )
  dbSeek( cFilial+"VL"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE )

  While !Eof() .and. ;
      E5_FILIAL   == cFilial           .and. ;
      E5_TIPODOC  == "VL"            .and. ;
      E5_PREFIXO  == SE2->E2_PREFIXO .and. ;
      E5_NUMERO   == SE2->E2_NUM   .and. ;
      E5_PARCELA  == SE2->E2_PARCELA .and. ;
      E5_TIPO     == SE2->E2_TIPO  .and. ;
      E5_DATA     == SE2->E2_BAIXA     .and. ;
      E5_CLIFOR   == SE2->E2_FORNECE .and. ;
      E5_LOJA     == cLoja
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ S¢ considera baixas que nao possuem estorno   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
          If SubStr( E5_DOCUMEN,1,6 ) == cNumBor
              lBaixa := .t.
              Exit
          End
      EndIf
      dbSkip( )
  End
  If !lBaixa
      If (dbSeek( cFilial+"BA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE))
          While !Eof() .and. ;
              E5_FILIAL   == cFilial           .and. ;
              E5_TIPODOC  == "BA"            .and. ;
              E5_PREFIXO  == SE2->E2_PREFIXO .and. ;
              E5_NUMERO   == SE2->E2_NUM   .and. ;
              E5_PARCELA  == SE2->E2_PARCELA .and. ;
              E5_TIPO     == SE2->E2_TIPO  .and. ;
              E5_DATA     == SE2->E2_BAIXA     .and. ;
              E5_CLIFOR   == SE2->E2_FORNECE .and. ;
              E5_LOJA     == SE2->E2_LOJA

              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ S¢ considera baixas que nao possuem estorno   ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
                  If SubStr( E5_DOCUMEN,1,6 ) == cNumBor
                      lBaixa := .t.
                      Exit
                  Endif
              EndIf
              dbSkip( )
          End
      End
  End
  dbSelectArea( "SEF" )
  If (dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))
      lCheque := .t.
  End
  dbSelectArea( "SA2" )
  dbSeek( cFilial+SE2->E2_FORNECE+SE2->E2_LOJA )
  dbSelectArea( "SEA" )

  IF li > 55 .Or. lNew
      fr710Cabec( SEA->EA_MODELO, nTipo, Tamanho, @lFirst)
      m_pag++
      lNew := .F.
  End

  lAbatimento := SEA->EA_TIPO $ MV_CPNEG .or. SEA->EA_TIPO $ MVABATIM
  If lAbatimento
      nAbat   := SE2->E2_SALDO
  EndIf

  If ! lAbatimento
      li++
      @li, 0 PSAY SEA->EA_PREFIXO
      @li, 4 PSAY SEA->EA_NUM
      @li,14 PSAY SEA->EA_PARCELA // 17
      @li,17 PSAY SE2->E2_TIPO   
  EndIf
  cNumConta := SEA->EA_NUMCON

  If SEA->EA_MODELO $ "CH/02"
      dbSelectArea( "SEA" )
      If ! lAbatimento
          If lCheque
              @li,22 PSAY SubStr(SEF->EF_BENEF,1, 30)
          Elseif lBaixa
              @li,22 PSAY SubStr(SE5->E5_BENEF,1, 30)
          Else
              @li,22 PSAY SubStr(SA2->A2_NOME,1, 30)
          End
      EndIf

      dbSelectArea( "SA6" )
      If lBaixa
          dbSeek( xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA))
      Else
          dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
      End
      dbSelectArea( "SEA" )
      If ! lAbatimento
          @li,55 PSAY SA6->A6_NREDUZ
          @li,71 PSAY SE2->E2_VENCREA
          If lCheque
              @li,82 PSAY "CH. " + SEF->EF_NUM
          End
      EndIf
      If lBaixa
          If ! lAbatimento
              @li,102 PSAY SE5->E5_VALOR - nAbat  Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          nTotValor += SE5->E5_VALOR
      Else
          If ! lAbatimento
              @li,102 PSAY SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat Picture "@E 999,999,999.99"
              nAbat := 0
              nTotValor += SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES
          Else
              nTotValor -= SE2->E2_SALDO
          End
      End
      nColunaTotal := 102
  Elseif SEA->EA_MODELO $ "CT/30"
      If ! lAbatimento
          @li,22 PSAY SubStr(SA2->A2_NOME,1, 30)
          @li,55 PSAY SE2->E2_VENCREA
          If lCheque
              @li,78 PSAY SEF->EF_NUM
          End
      EndIf
      If lBaixa
          If ! lAbatimento
              @li,94 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          nTotValor += SE5->E5_VALOR
      Else
          If ! lAbatimento
              @li,094 PSAY SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          if lAbatimento
              nTotValor -= SE2->E2_SALDO
          Else
              nTotValor += SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES
          End
      End
      nColunaTotal := 94
  Elseif SEA->EA_MODELO $ "CP/31"
      If ! lAbatimento
          @li,27 PSAY SubStr(SA2->A2_NOME,1, 25)
      EndIf
      dbSelectArea( "SA6" )
      dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
      dbSelectArea( "SEA" )
      If ! lAbatimento
          @li,55 PSAY SA6->A6_NREDUZ
          @li,71 PSAY SE2->E2_VENCREA
          @li,83 PSAY SE2->E2_NUMBCO
      EndIf
      If lBaixa
          If ! lAbatimento
              @li,99 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          nTotValor += SE5->E5_VALOR
      Else
          If ! lAbatimento
              @li,099 PSAY SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          If lAbatimento
              nTotValor -= SE2->E2_SALDO
          Else
              nTotValor += SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES
          End
      End
      nColunaTotal := 99
  Elseif SEA->EA_MODELO $ "CC/01/03/04/05/10/41/43"
      dbSelectArea( "SA6" )
      dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
      dbSelectArea( "SEA" )
      If ! lAbatimento
          @li,22  PSAY Substr(SA6->A6_NREDUZ,1,30)
          @li,36  PSAY SA2->A2_BANCO + " " + SA2->A2_AGENCIA + " " + SA2->A2_NUMCON
          @li,60  PSAY SubStr(SA2->A2_NOME, 1, 25 )
          @li,86  PSAY SA2->A2_CGC Picture IIF(Len(Alltrim(SA2->A2_CGC))>11,"@R 99999999/9999-99","@R 999999999-99")
          @li,104 PSAY SE2->E2_VENCREA
      EndIf
      If lBaixa
          If ! lAbatimento
              @li,115 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          nTotValor += SE5->E5_VALOR
      Else
          If ! lAbatimento
              @li,115 PSAY SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          If lAbatimento
              nTotValor -= SE2->E2_SALDO
          Else
              nTotValor += SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES
          End
      End
      nColunaTotal := 115
  Else
      If ! lAbatimento
          @li,22 PSAY SubStr(SA2->A2_NOME,1, 30)
      EndIf
      dbSelectArea( "SA6" )
      dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
      dbSelectArea( "SEA" )
      If ! lAbatimento
          @li,55 PSAY SA6->A6_NREDUZ
          @li,71 PSAY SE2->E2_VENCREA
          @li,84 PSAY SE2->E2_NUMBCO
      EndIf

      If lBaixa
          If ! lAbatimento
              @li,100 PSAY SE5->E5_VALOR - nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          EndIf
          nTotValor += SE5->E5_VALOR
      Else
          If ! lAbatimento
              @li,100 PSAY SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat Picture "@E 999,999,999.99"
              nAbat := 0
          Endif

          If lAbatimento
              nTotValor -= SE2->E2_SALDO
          Else
              nTotValor += SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES
          End
      End
      nColunaTotal := 100
  End
  dbSelectArea( "SEA" )
  dbSkip( )

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se n„o h  mais registros v lidos a analisar.    ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  DO WHILE !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02 ;
              .and. (Empty(EA_NUMBOR) .or. SEA->EA_CART != "P")
      dbSkip( )
  ENDDO

  If cNumBor != SEA->EA_NUMBOR
      lNew := .T.                             // Novo bordero a ser impresso
      If li != 80
          li+=2
          @li,    00 PSAY __PrtThinLine()
          li++
          @li, 75 PSAY "TOTAL GERAL ..... "
          @li,nColunaTotal PSAY nTotValor Picture "@E 999,999,999.99"
          cExtenso := Extenso( nTotValor, .F., 1 )
          li+=2
          @li,    1 PSAY Trim(SubStr(cExtenso,1,100))
          If Len(Trim(cExtenso)) > 100
              li++
              @li, 0 PSAY SubStr(cExtenso,101,Len(Trim(cExtenso))-100)
          End
          li+=2
          If cModelo $ "CH/02"
              @li, 0 PSAY "AUTORIZAMOS V.SAS. A EMITIR OS CHEQUES NOMINATIVOS AOS BENEFICIARIOS EM REFERENCIA,"
              li++
              @li, 0 PSAY "DEBITANDO EM NOSSA CONTA CORRENTE NO DIA " + DtoC( mv_par03 )  //"DEBITANDO EM NOSSA CONTA CORRENTE NO DIA "
              li++
              @li, 0 PSAY "PELO VALOR ACIMA TOTALIZADO."
          Elseif cModelo $ "CT/30"
              @li, 0 PSAY "AUTORIZAMOS V.SAS. A PAGAR OS TITULOS ACIMA RELACIONADOS EM NOSSA"
              li++
              @li, 0 PSAY "CONTA MOVIMENTO NUM. " + Alltrim(cNumConta) + " NO DIA " + DtoC( mv_par03 ) + ", PELO VALOR ACIMA TOTALIZADO."  //"CONTA MOVIMENTO NO DIA "###", PELO VALOR ACIMA TOTALIZADO."
          Elseif cModelo $ "CP/31"
              @li, 0 PSAY "AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
              li++
              @li, 0 PSAY "CONTA CORRENTE NUM. " + Alltrim(cNumConta) + " NO DIA "+ DtoC( mv_par03 ) + " PELO VALOR ACIMA TOTALIZADO."  //"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
          Elseif cModelo $ "CC/01/03/04/05/10/41/43"
              @li, 0 PSAY "AUTORIZAMOS V.SAS. A EMITIREM ORDEM DE PAGAMENTO, OU DOC PARA OS BANCOS/CONTAS ACIMA."
              li++
              @li, 0 PSAY "DOS TITULOS RESPECTIVOS DEBITANDO EM NOSSA C/CORRENTE NUM "  + cNumConta  //"DOS TITULOS RESPECTIVOS DEBITANDO EM NOSSA C/CORRENTE NUM "
              li++
              @li, 0 PSAY "NO DIA " + dToC( mv_par03 ) + " PELO VALOR ACIMA TOTALIZADO."  //"NO DIA "### " PELO VALOR ACIMA TOTALIZADO."
          Else
              @li, 0 PSAY "AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
              li++
              @li, 0 PSAY "CONTA CORRENTE NUM. " + Alltrim(cNumConta) + " NO DIA " + DtoC( mv_par03 ) + " PELO VALOR ACIMA TOTALIZADO."  //"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
          End
          li+=3
          @li,60 PSAY "----------------------------"
          li++
          @li,60 PSAY SM0->M0_NOMECOM
          li++
          @li, 0 PSAY " "
          nTotValor := 0
      End
  EndIf
  dbSelectArea("SEA")
End

Set Device To Screen
dbSelectArea("SE5")
dbSetOrder( 1 )
dbSelectArea("SE2")
dbSetOrder(1)
Set Filter To
If aReturn[5] = 1
  Set Printer To
  dbCommit( )
  Ourspool(wnrel)
End
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fr710cabec³ Autor ³ Wagner Xavier         ³ Data ³ 24.05.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cabe‡alho do Bordero                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³fr710cabec()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr710cabec( cModelo, nTipo, Tamanho, lFirst)
Local cCabecalho
Local cTexto := ""

If cModelo $ "CH/02" // Tabela("58",cModelo)
  cTexto := Tabela("58",@cModelo)
  cCabecalho := "PRF NUMERO    PC TIPO B E N E F I C I A R I O          BANCO           DT.VENC  HISTORICO               VALOR A PAGAR"
Elseif cModelo $ "CT/30"
  cTexto := Tabela("58",@cModelo)
  cCabecalho := "PRF NUMERO    PC TIPO B E N E F I C I A R I O          DT.VENC BCO AGENCIA NUM CHEQUE         VALOR A PAGAR"
Elseif cModelo $ "CP/31"
  cTexto := Tabela("58",@cModelo)
  cCabecalho := "PRF NUMERO    PC TIPO B E N E F I C I A R I O          BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR"
ElseIf cModelo $ "CC/01/03/04/05/10/41/43"
  cTexto := Tabela("58",@cModelo) 
  cCabecalho := "PRF NUMERO    PC TIPO B A N C O     BCO AGENC NUMERO CONTA  BENEFICIARIO              CNPJ/CPF        DT.VENC       VALOR A PAGAR"
Else
  cTexto := Tabela("58",@cModelo)
  cCabecalho := "PRF NUMERO    PC TIPO B E N E F I C I A R I O          BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR"
End

dbSelectArea( "SA6" )
dbSeek( cFilial+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON )
aCabec := {Sm0->M0_nome,"AUTORIZACAO PARA PAGAMENTO DE COMPROMISSOS",;
           "Emissao:"+DtoC(dDataBase),;
           PadC(cTexto,97),;
           "Bordero:"+SEA->EA_NUMBOR,;
           "Banco: "+SA6->A6_NOME,;
           "Agencia: "+SA6->A6_AGENCIA+" - "+SA6->A6_NUMCON,;
           "Endereco do Banco: "+Pad(SA6->A6_END + " "  + SA6->A6_MUN + " " + SA6->A6_EST,130)}
           
Cabec1 := cCabecalho            
li := Cabec710(Titulo,Cabec1,NomeProg,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),;
          GetMv("MV_NORM")), aCabec, @lFirst)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o  ³fa710DtDeb³ Autor ³ Mauricio Pequim Jr.     ³ Data ³ 12.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da data de d‚bito para o bordero                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³fa710DtDeb()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fa710DtDeb()

Local lRet := .T.
lRet := IIf (mv_par03 < dDataBase, .F. , .T. )
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Cabec170  ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 14.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da data de d‚bito para o bordero                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³Cabec170()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUNCTION cabec710(cTitulo,cCabec1,cNomPrg,nTamanho,nChar,aCustomText,lFirst)

Local cAlias,nLargura,nLin:=0, aDriver := ReadDriver(),nCont:= 0, cVar,uVar,cPicture
Local lWin := .f.
Local nI := 0
Local oFntCabec
Local nRow, nCol
// Default aCustomText := Nil // Parâmetro que se passado suprime o texto padrao desta função por outro customizado

#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
#DEFINE INIPARAM    Chr(27)+Chr(04)+Chr(01)
#DEFINE FIMPARAM    Chr(27)+Chr(04)+Chr(02)

lPerg := If(GetMv("MV_IMPSX1") == "S" ,.T.,.F.)

cNomPrg := Alltrim(cNomPrg)

Private cSuf:=""

// DEFAULT lFirst := .t.

If TYPE("__DRIVER") == "C"
  If "DEFAULT"$__DRIVER
      lWin := .t.
  EndIf
EndIf

nLargura:=132

IF aReturn[5] == 1   // imprime em disco
   lWin := .f.    // Se eh disco , nao eh windows
Endif

If lFirst       
  nRow := PRow()
  nCol := PCol()
  SetPrc(0,0)
  If aReturn[5] <> 2 // Se nao for via Windows manda os caracteres para setar a impressora
      If nChar == NIL .and. !lWin .and. __cInternet == Nil
          @ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
      ElseIf !lWin .and. __cInternet == Nil
          If nChar == 15
              @ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
          Else
              @ 0,0 PSAY &(aDriver[4])
          EndIf
      EndIf
  EndIF
  If GetMV("MV_CANSALT",,.T.) // Saltar uma página na impressão
      If GetMv("MV_SALTPAG",,"S") != "N"
          Setprc(nRow,nCol)
      EndIf   
  Endif
Endif
// Impressão da lista de parametros quando solicitada
If lPerg .and. Substr(cAcesso,101,1) == "S"
  If lFirst
      // Imprime o cabecalho padrao
      nLin := SendCabec(lWin, nLargura, cNomPrg, RptParam+" - "+Alltrim(cTitulo), "", "", .F.)
      cAlias := Alias()
      DbSelectArea("SX1")
      DbSeek(cPerg)
      @ nLin+=2, 5 PSAY INIPARAM
      While !EOF() .AND. X1_GRUPO = cPerg
          cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
          @(nLin+=2),5 PSAY INIFIELD+RptPerg+" "+ X1_ORDEM + " : "+ AllTrim(X1Pergunt())+FIMFIELD
          If X1_GSC == "C"
              xStr:=StrZero(&cVar,2)
              If ( &(cVar)==1 )
                  @ nLin,Pcol()+3 PSAY INIFIELD+X1Def01()+FIMFIELD
              ElseIf ( &(cVar)==2 )
                  @ nLin,Pcol()+3 PSAY INIFIELD+X1Def02()+FIMFIELD
              ElseIf ( &(cVar)==3 )
                  @ nLin,Pcol()+3 PSAY INIFIELD+X1Def03()+FIMFIELD
              ElseIf ( &(cVar)==4 )
                  @ nLin,Pcol()+3 PSAY INIFIELD+X1Def04()+FIMFIELD
              ElseIf ( &(cVar)==5 )
                  @ nLin,Pcol()+3 PSAY INIFIELD+X1Def05()+FIMFIELD
              Else                    
                  @ nLin,Pcol()+3 PSAY INIFIELD+''+FIMFIELD
              EndIf
          Else
              uVar := &(cVar)
              If ValType(uVar) == "N"
                  cPicture:= "@E "+Replicate("9",X1_TAMANHO-X1_DECIMAL-1)
                  If( X1_DECIMAL>0 )
                      cPicture+="."+Replicate("9",X1_DECIMAL)
                  Else
                      cPicture+="9"
                  EndIf
                  @nLin,Pcol()+3 PSAY INIFIELD+Transform(Alltrim(Str(uVar)),cPicture)+FIMFIELD
              Elseif ValType(uVar) == "D"
                  @nLin,Pcol()+3 PSAY INIFIELD+DTOC(uVar)+FIMFIELD
              Else
                  @nLin,Pcol()+3 PSAY INIFIELD+uVar+FIMFIELD
              EndIf
          EndIf
          DbSkip()
      Enddo
      cFiltro := Iif (!Empty(aReturn[7]),MontDescr("SEA",aReturn[7]),"")
      nCont := 1
      If !Empty(cFiltro)
          nLin+=2
          @ nLin,5  PSAY  INIFIELD+"Filtro      : "+ Substr(cFiltro,nCont,nLargura-19)+FIMFIELD  // "Filtro      : "
          While Len(AllTrim(Substr(cFiltro,nCont))) > (nLargura-19)
              nCont += nLargura - 19
              nLin+=1
              @ nLin,19   PSAY    INIFIELD+Substr(cFiltro,nCont,nLargura-19)+FIMFIELD
          Enddo
          nLin++
      EndIf
      nLin++
      @ nLin ,00  PSAY __PrtFatLine()+FIMPARAM
      DbSelectArea(cAlias)
  Endif
EndIf

@ 00,00 PSAY __PrtFatLine()
@ 01,00 PSAY SM0->M0_NOME // __PrtLogo()
@ 02,00 PSAY __PrtFatLine()


@ 04,00 PSAY __PrtLeft(aCustomText[1])    // Empresa
@ 04,00 PSAY __PrtCenter(aCustomText[2])  // Titulo do relatorio
@ 04,00 PSAY __PrtRight(aCustomText[3])   // Data Emissao
@ 05,00 PSAY __PrtCenter(aCustomText[4])  // Descricao do tipo de bordero
@ 05,00 PSAY __PrtRight(aCustomText[5])   // Nro do bordero
@ 08,00 PSAY __PrtLeft(aCustomText[6])    // Ao Banco
@ 09,00 PSAY __PrtLeft(aCustomText[7])    // Agencia
@ 10,00 PSAY __PrtLeft(aCustomText[8])    // Endereco Banco

If LEN(Trim(cCabec1)) != 0
  @ 11,00  PSAY __PrtThinLine()
  @ 12,00  PSAY cCabec1
  @ 13,00  PSAY __PrtThinLine()
EndIf
nLin :=14     
m_pag++
lFirst := .f.
If Subs(__cLogSiga,4,1) == "S"
  __LogPages()
EndIf

Return nLin

