#INCLUDE "MNTR360.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MNTR360  ³ Autor ³ Deivys Joenck         ³ Data ³ 22/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de MTBR e MTTR                                   ³±±                
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBSERVACAO³ Revisao tecnica 10/10/2002                                 ³±±
±±³          ³ Revisao 10/12/2005 - Fabio Nico                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function NHMNT004()  

Local WNREL      := "NHMNT004"
Local LIMITE     := 132
Local cDESC1     := STR0001 //"Analise de MTBR e MTTR."
Local cDESC2     := STR0002 //"O usuario pode selecionar quais os campos que deverao ser mostrados,"
Local cDESC3     := STR0003 //"bem como informar parametros de selecao para a impressao."
Local cSTRING    := "STJ"

Private NOMEPROG := "NHMNT004"
Private TAMANHO  := "M"
Private aRETURN  := {STR0004,1,STR0005,1,2,1,"",1}   //"Zebrado"###"Administracao"
Private TITULO   := STR0001 //"Analise de MTBR e MTTR."
Private nLASTKEY := 0
Private CABEC1, CABEC2
Private aux_QtdeEquip := 0
Private aux_TotDias   := 0
Private aux_TotHora   := 0
Private aux_TotRefo   := 0              

Private a_QtdeEquip := 0
Private a_TotDias   := 0
Private a_TotHora   := 0
Private a_TotRefo   := 0              


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis utilizadas para parametros!                        ³
³ mv_par01     // De  Familia                                  ³
³ mv_par02     // Ate Familia                                  ³
³ mv_par03     // De  Bem                                      ³
³ mv_par04     // Ate Bem                                      ³
³ mv_par05     // De  Centro de Custo                          ³
³ mv_par06     // Ate Centro de Custo                          ³
³ mv_par07     // De  Centro de Trabalho                       ³
³ mv_par08     // Ate Centro de Trabalho                       ³
³ mv_par09     // De  Data                                     ³
³ mv_par10     // Ate Data                                     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Private cPERG := "MNT36R"
Pergunte(cPERG,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WNREL:=SetPrint(cSTRING,WNREL,cPERG,TITULO,cDESC1,cDESC2,cDESC3,.F.,"")
TITULO := 'Analise de MTBR e MTTR. - no Periodo de ' + DTOC(mv_par09) + ' a ' + DTOC(mv_par10)
If nLASTKEY = 27
   Set Filter To
   DbSelectArea("STJ")
   Return
EndIf
SetDefault(aReturn,cSTRING)

RptStatus({|lEND| MNT004IMP(@lEND,WNREL,TITULO,TAMANHO)},TITULO)
DbSelectArea("STJ")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNTR360IMP³ Autor ³ Deivys Joenck         ³ Data ³ 22/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR360                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Function MNTR360IMP(lEND,WNREL,TITULO,TAMANHO)
STATIC Function MNT004IMP(lEND,WNREL,TITULO,TAMANHO)

Local cRODATXT := ""
Local nCNTIMPR := 0
Local cCUSTO,dDIAS
Local nMULT := 1

Private li := 80,m_pag := 1
nTIPO  := IIf(aReturn[4]==1,15,18)

CABEC1   := STR0006 //"Centro Custo          Descricao                   C.Trabalho Descricao"
CABEC2   := STR0007 //"Familia Decricao                 Bem              Nome do Bem                MTBF       MTTR"
cCONDST9 := 'st9->t9_codfami >= MV_PAR01 .And. st9->t9_codfami <= MV_PAR02'

/*/
          1         2         3         4         5         6         7         8         9         0         1         2         3
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
************************************************************************************************************************************
Centro Custo          Descricao                   C.Trabalho Descricao
Familia Decricao                 Bem              Nome do Bem                MTBR      MTTR
************************************************************************************************************************************
xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxx   xxxxxx     xxxxxxxxxxxxxxxxxxxx       
xxxxxx  xxxxxxxxxxxxxxxxxxxx     xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx    99999,9   99999,9
xxxxxx  xxxxxxxxxxxxxxxxxxxx     xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx    99999,9   99999,9
/*/

aDBF := {{"CUSTO"  ,"C",20,0},;
         {"CENTRAB","C",06,0},;
         {"FAMILIA","C",06,0},;
         {"CODBEM" ,"C",16,0},;
         {"DATAINI","D",08,0},;
         {"HORAINI","C",08,0},;
         {"DATAFIM","D",08,0},;
         {"HORAFIM","C",08,0},;
         {"ORDEM","C",06,0}}

cARQ1 := CriaTrab(aDBF,.T.)
USE (cARQ1) alias TRB EXCLUSIVE NEW
Index On CUSTO+CENTRAB+FAMILIA+CODBEM+DTOS(DATAINI) To (cARQ1)

Processa({|lEND| MNT004STJ()},STR0008+STR0009) //"Processando Arquivo..."..Normal
Processa({|lEND| MNT004STS()},STR0008+STR0010) //"Processando Arquivo..." ..Historico

Dbselectarea("TRB")
DbGotop()
SetRegua(LastRec())
While !Eof()

   cCUSTO := TRB->CUSTO
   While !Eof() .And. TRB->CUSTO = cCUSTO
      cCENTRAB := TRB->CENTRAB
      NGSOMALI(58)
      @LI,000 Psay TRB->CUSTO
      @LI,022 Psay NGSEEK('SI3',TRB->CUSTO,1,"Substr(I3_DESC,1,25)")

      @LI,050 Psay TRB->CENTRAB
      @LI,061 Psay NGSEEK('SHB',TRB->CENTRAB,1,"Substr(HB_NOME,1,20)")

      Dbselectarea("TRB")
      While !Eof() .And. TRB->CUSTO = cCUSTO .And. TRB->CENTRAB = cCENTRAB

         lPRIMEIRO := .T.
         Store 0 To nNUMDIAS,nREFORMA,nHORAS
         cFAMILIA := TRB->FAMILIA
         cCODBEM  := TRB->CODBEM

         NGSOMALI(58)
         @LI,000 Psay TRB->FAMILIA
         @LI,008 Psay NGSEEK('ST6',TRB->FAMILIA,1,"Substr(T6_NOME,1,20)")

         @LI,033 Psay TRB->CODBEM
         @LI,050 Psay NGSEEK('ST9',TRB->CODBEM,1,"Substr(T9_NOME,1,20)")

         Dbselectarea("TRB")
         While !Eof() .And. TRB->CUSTO = cCUSTO .And. TRB->CENTRAB = cCENTRAB;
            .And. TRB->FAMILIA = cFAMILIA .And. TRB->CODBEM = cCODBEM
      
            IncRegua()
            If lPRIMEIRO
               dDIAS     := TRB->DATAINI
               lPRIMEIRO := .F.
            EndIf
            nNUMDIAS := nNUMDIAS+(TRB->DATAINI-dDIAS)
            nREFORMA := nREFORMA+1
            nHORAS   := nHORAS+CALCTIME()
            dDIAS    := TRB->DATAFIM


            aux_TotDias  := aux_TotDias + nNUMDIAS
            aux_TotHora  := aux_TotHoras + nHORAS
            aux_TotRefo  :=  aux_TotRefo + nREFORMA



            Dbselectarea("TRB")
            Dbskip()
         End
         @LI,074 PSay nNUMDIAS picture '@E 99999.9'
         @LI,084 PSay nREFORMA Picture '@E 99999.9'
         @LI,094 Psay nNUMDIAS/nREFORMA Picture '@E 99999.9'
         cTMHORAS := NTOH(nHORAS/nREFORMA)
         @LI,104 + 8 - (Len(cTMHORAS)) Psay cTMHORAS
         aux_QtdeEquip := aux_QtdeEquip + 1   
         
      End
      NGSOMALI(58)
      NGSOMALI(58)
   End
        // fabio
       @LI, 020 Psay  'Total Dias: '
       @LI, 032 Psay  aux_TotDias
       @LI, 050 Psay  'Total Horas: '
       @LI, 065 Psay  aux_TotHora //                Picture '99:99'
       @LI, 080 Psay  'Reformas: ' 
       @LI, 092 Psay  aux_TotRefo Picture '@e 999999'
       @LI, 100 Psay  'Equip.: '
       @LI, 110 Psay  aux_QtdeEquip Picture '@e 999999'


       a_QtdeEquip := a_QtdeEquip + aux_QtdeEquip
       a_TotDias   := a_TotDias   + aux_TotDias 
       a_TotHora   := a_TotHora   + aux_TotHora
       a_TotRefo   := a_TotRefo   + aux_TotRefo
                                

       NGSOMALI(58)
       NGSOMALI(58)                              

       aux_TotDias  := 0
       aux_TotHora  := 0
       aux_TotRefo  := 0           
       aux_QtdeEquip := 0
  
End                                              
       @LI, 020 Psay  'Total Dias: '
       @LI, 032 Psay  a_TotDias
       @LI, 050 Psay  'Total Horas: '
       @LI, 065 Psay  a_TotHora 
       @LI, 080 Psay  'Reformas: ' 
       @LI, 092 Psay  a_TotRefo Picture '@e 999999'
       @LI, 100 Psay  'Equip.: '
       @LI, 110 Psay  a_QtdeEquip Picture '@e 999999'



RODA(nCNTIMPR,cRODATXT,TAMANHO)
Dbselectarea("TRB")
Use
RetIndex("STJ")
Set Filter To
Set Device To Screen
If aReturn[5] == 1
   Set Printer To
   dbCommitAll()
   OurSpool(WNREL)
EndIf
MS_FLUSH()
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNTR360STJ³ Autor ³ In cio Luiz Kolling   ³ Data ³10/10/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Processa as o.s. normais                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR360                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Static Function MNTR360STJ()
Static Function MNT004STJ()

cCONDSTJ := 'stj->tj_situaca = "L" .And. stj->tj_termino = "S" .And. '
cCONDSTJ := cCONDSTJ + '(stj->tj_codbem >= MV_PAR03 .And. stj->tj_codbem <= MV_PAR04)'
cCONDSTJ := cCONDSTJ + ' .And. (stj->tj_centrab >= MV_PAR07 .And. stj->tj_centrab <= MV_PAR08)'
cCONDSTJ := cCONDSTJ + ' .And. (stj->tj_dtorigi >= MV_PAR09 .And. stj->tj_dtorigi <= MV_PAR10)'
cCONDSTJ := cCONDSTJ + ' .And. stj->tj_tipoos = "B"'

DbSelectArea("STJ")
DbSetOrder(05)
Dbseek(xFILIAL("STJ")+"000000"+MV_PAR05,.T.)
ProcRegua(LastRec())
While !Eof() .And. STJ->TJ_FILIAL == xFILIAL("STJ") .And.;
   Val(STJ->TJ_PLANO) = 0 .And. STJ->TJ_CCUSTO <= MV_PAR06
   
   Incproc()
   If &(cCONDSTJ)
      DbSelectArea("ST9")
      Dbsetorder(01)
      If Dbseek(xFILIAL("ST9")+STJ->TJ_CODBEM)
         If &(cCONDST9)
            MNT004TRB(STJ->TJ_CCUSTO,STJ->TJ_CENTRAB,STJ->TJ_CODBEM,;
                       STJ->TJ_DTMRINI,STJ->TJ_HOMRINI,STJ->TJ_DTMRFIM,;
                       STJ->TJ_HOMRFIM,STJ->TJ_ORDEM)
         EndIf
      EndIf
   EndIf
   DbSelectArea("STJ")
   DbSkip()
End
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNTR360STS³ Autor ³ In cio Luiz Kolling   ³ Data ³10/10/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Processa as o.s. historico                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR360                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function MNT004STS()

cCONDSTS := 'sts->ts_situaca = "L" .And. sts->ts_termino = "S" .And. '
cCONDSTS := cCONDSTS + '(sts->ts_codbem >= MV_PAR03 .And. sts->ts_codbem <= MV_PAR04)'
cCONDSTS := cCONDSTS + ' .And. (sts->ts_centrab >= MV_PAR07 .And. sts->ts_centrab <= MV_PAR08)'
cCONDSTS := cCONDSTS + ' .And. (sts->ts_dtorigi >= MV_PAR09 .And. sts->ts_dtorigi <= MV_PAR10)'
cCONDSTS := cCONDSTS + ' .And. sts->ts_tipoos = "B"'

DbSelectArea("STS")
DbSetOrder(10)
DbSeek(xFILIAL("STS")+"000000"+MV_PAR05,.T.)
ProcRegua(LastRec())
While !Eof() .And. STS->TS_FILIAL == xFILIAL("STS") .And.;
   Val(STS->TS_PLANO) = 0 .And. STS->TS_CCUSTO <= MV_PAR06
   
   Incproc()
   If &(cCONDSTS)
      Dbselectarea("ST9")
      Dbsetorder(1)
      If Dbseek(xFILIAL("ST9")+STS->TS_CODBEM)
         If &(cCONDST9)
            MNT004TRB(STS->TS_CCUSTO,STS->TS_CENTRAB,STS->TS_CODBEM,;
                       STS->TS_DTMRINI,STS->TS_HOMRINI,STS->TS_DTMRFIM,;
                       STS->TS_HOMRFIM)
         EndIf
      EndIf
   EndIf
   Dbselectarea("STS")
   DbSkip()
End
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNTR360TRB³ Autor ³ In cio Luiz Kolling   ³ Data ³10/10/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava o arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR360                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MNT004TRB(cCCUSTO,cCENTRAB,cCODBEM,dDTMRINI,cHOMRINI,;
                           dDTMRFIM,cHOMRFIM)
DbSelectArea("TRB")
TRB->(DbAppend())
TRB->CUSTO   := cCCUSTO
TRB->CENTRAB := cCENTRAB
TRB->FAMILIA := ST9->T9_CODFAMI
TRB->CODBEM  := cCODBEM
TRB->DATAINI := dDTMRINI
TRB->HORAINI := cHOMRINI
TRB->DATAFIM := dDTMRFIM
TRB->HORAFIM := cHOMRFIM 
TRB->ORDEM   := STJ->TJ_ORDEM
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CALCHORA ³ Autor ³ Deivys Joenck         ³ Data ³ 03/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Calcula a quantidade de horas da manutencao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR360                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CALCTIME()

Local nHORAS := 0
If (TRB->DATAFIM - TRB->DATAINI) > 0
   nHORAS := (TRB->DATAFIM - TRB->DATAINI) * 1440
EndIf
nHORAS := nHORAS+(HTOM(TRB->HORAFIM) - HTOM(TRB->HORAINI))
nHORAS := nHORAS/60
Return nHORAS
