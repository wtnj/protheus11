#INCLUDE "MNTR730.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MNTR005  ³ Autor ³ Fabio Nico            ³ Data ³ 10/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de paradas do equipamento                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function NHMNT005()
Local WNREL      := "MNT005"
Local LIMITE     := 132
Local cDESC1     := STR0001 //"Relatorio das Paradas dos Bens nas Manutencoes."
Local cDESC2     := STR0002 //"Usar os Parametros para Selecionar o C.Custo, o Bem, o "
Local cDESC3     := STR0003 //"Servico e o Periodo de Paradas que Deseja Imprimir."
Local cSTRING    := "ST9"

Private NOMEPROG := "MNT005"
Private TAMANHO  := "G"
Private aRETURN  := {STR0004,1,STR0005,1,2,1,"",1}  //"Zebrado"###"Administracao"
Private TITULO   := STR0006 //"Paradas de Equipamentos para Manutencoes"
Private nTIPO    := 0                                                                 
Private CABEC1, CABEC2
Private nSOMA := 0,nHORAS := 0,lPROBLEMA := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Parametros!                        ³
//³ mv_par01     // De Data Parada                               ³
//³ mv_par02     // Ate Data Parada                              ³
//³ mv_par03     // De C.Custo                                   ³
//³ mv_par04     // Ate C.Custo                                  ³
//³ mv_par05     // Do Bem                                       ³
//³ mv_par06     // Ate Bem                                      ³
//³ mv_par07     // Do Servico                                   ³
//³ mv_par08     // Ate Servico                                  ³
//³ mv_par09     // Sequencia                                    ³
//³ mv_par10     // Lista Obs. Mot. Parada                       ³ 
//³ mv_par11     // Considera Calendario                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

DbSelectArea("SX1")
DbSetOrder(01)
If !Dbseek("MNT005"+"11")
   Reclock("SX1",.T.)
   SX1->X1_GRUPO   := "MNT005"
   SX1->X1_ORDEM   := "11"
   SX1->X1_PERGUNT := "Considera Calendario ?"        
   SX1->X1_PERSPA  := "Considera Calendario ?"
   SX1->X1_PERENG  := "Consider Calendar ?"
   SX1->X1_VARIAVL := "mv_chb"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 1
   SX1->X1_PRESEL  := 1 
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_GSC     := "C"
   SX1->X1_VAR01   := "mv_par11"
   SX1->X1_DEF01   := "Nao"
   SX1->X1_DEF02   := "Sim"
   SX1->X1_DEFSPA1 := "Si"
   SX1->X1_DEFSPA2 := "No"
   SX1->X1_DEFENG1 := "Yes"
   SX1->X1_DEFENG2 := "No"
   MsUnLock("SX1")
Endif
                                
PRIVATE cPERG := "MNT005"
PERGUNTE(cPERG,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WNREL := SETPRINT(cSTRING,WNREL,cPERG,TITULO,cDESC1,cDESC2,cDESC3,.F.,"")
TITULO := 'Parada dos equipamentos para Manutencao  - no Periodo de ' + DTOC(mv_par01) + ' a ' + DTOC(mv_par02)

If nLASTKEY = 27
   SET FILTER TO
   RETURN
Endif
SETDEFAULT(aRETURN,cSTRING)

RPTSTATUS({|lEND|MNT005IMP(@lEND,WNREL,TITULO,TAMANHO)},TITULO)
RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Descri‡…o ³ Impressão do relatório                                     ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function MNT005IMP(lEND,WNREL,TITULO,TAMANHO)
Local cRODATXT := ""
Local nCNTIMPR := 0
Local nMULT    := 1

Private li := 80 ,m_pag := 1
aTRAB      := {}
dDTPARINI  := dDataBase
nTOHRPAR   := 0.00
nTOHRESP   := 0.00
nTOHRMAN   := 0.00
nTOHRHOM   := 0.00
nTHRDISP   := 0.00
nMVPAR     := Val(mv_par09)

nTIPO      := IIf(aRETURN[4]==1,15,18)
CABEC1     := STR0007 //"   Bem              Descricao                 O.Serv. Manutencao                     Dt.Parada   Hr/Par  Hr/Esp  Hr/Man    Hr/h"
//                                        1         2         3         4         5         6         7         8         9        10        11        12        13              14       15         16
//                         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//CABEC1     := STR0007 //"   Bem              Descricao                 O.Serv. Manutencao                     Dt.Parada   Hr/Par  Hr/Esp  Hr/Man    Hr/h"
CABEC1     := STR0007 //  "   Bem              Descricao                                     Ordem  Manutencao                                                      Contador   Dt.Parada   Hr/Par   Hr/Esp    Hr/Man     Hr/h"
CABEC2     := " "

/*
          1         2         3         4         5         6         7         8         9        10        11        12        13              14       15         16
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*************************************************************************************************************************************
   Bem              Descricao                 Ordem  Manutencao                                            Contador   Dt.Parada   Hr/Par   Hr/Esp    Hr/Man     Hr/h
*************************************************************************************************************************************
Centro de Custo..: xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                     9999999999  99/99/9999 9999:99  9999:99   9999:99   999:99
                                              Obs: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                              xxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxx                                   99/99/9999 9999:99  9999:99   9999:99  9999:99

                                                  Total da Manut.: Paradas:    999  Hr/Dis: 99999:99  Perc.: 999,9%           999999:99 99999.99 999999:99 99999:99
                    
                                                  Total do Bem:    Paradas:    999  Hr/Dis: 99999:99  Perc.: 999,9%           999999:99 99999.99 999999:99 99999:99
                    
                                                  Total do C.Custo:Paradas:    999  *Media: HP x HD:    9999999,99*           999999:99 99999.99 999999:99 99999:99

                                                  Total Geral:     Paradas:    999  *Media: HP x HD:   99999999,99*           999999:99 99999.99 999999:99 99999:99
*/

aDBF := {{"CUSTO"  ,"C",Len(stj->tj_ccusto),0},;
         {"CODBEM" ,"C",16,0},;
         {"ORDEM"  ,"C",06,0},;
         {"SERVIC" ,"C",06,0},;
         {"SEQUEN" ,"N",03,0},;
         {"POSCONT","N",09,0},;
         {"DTPRIN" ,"D",08,0},;
         {"HORPAR" ,"N",12,2},;
         {"HORESP" ,"N",12,2},;
         {"HORMAN" ,"N",12,2},;
         {"HORHOM" ,"N",12,2},;
         {"HORDIS" ,"N",12,2},;
         {"ARQUIV" ,"C",03,0}}

cARQ1 := CriaTrab(aDBF,.T.)
USE (cARQ1) ALIAS TRB EXCLUSIVE NEW
#IFDEF CDX
   INDEX ON CUSTO+CODBEM+SERVIC+STR(SEQUEN,3) TAG TRB TO (cARQ1)
#ELSE
   INDEX ON CUSTO+CODBEM+SERVIC+STR(SEQUEN,3) TO (cARQ1)
   SET INDEX TO (cARQ1)
#ENDIF

PROCESSA({|lEND| MNTR005STJ()},STR0016+STR0017) //"Processando Arquivo..."..NORMAIS
If !lPROBLEMA
   PROCESSA({|lEND| MNTR005STS()},STR0016+STR0018) //"Processando Arquivo..."..HISTORICO
Endif
If !lPROBLEMA
   //Inicio da impressao

   Dbselectarea("TRB")
   Dbgotop()
   Store 0.00 To nTOTHRPAR,nTOTHRESP,nTOTHRMAN,nTOTHRHOM,nTOTPARAD,nTOTHRDIS,nTOHDPCC
   SETREGUA(LASTREC())
   While !Eof()
      NGSOMALI(58)
      cCUSTO := TRB->CUSTO
      Store 0.00 To nTOCHRPAR,nTOCHRESP,nTOCHRMAN,nTOCHRHOM,nTOCPARAD,nTOCHRDIS,nHDISPCC

      @ Li,000 PSAY STR0011 //"Centro de Custo..:"
      @ Li,019 PSAY Alltrim(TRB->CUSTO)+" "+NGSEEK('SI3',TRB->CUSTO,1,'SUBSTR(I3_DESC,1,30)')
      NGSOMALI(58)

      Dbselectarea("TRB")
      While !Eof() .And. TRB->CUSTO == cCUSTO
         NGSOMALI(58)
         cCODBEM  := TRB->CODBEM
         Store 0.00 To nTOMHRHOM,nTOMHRPAR,nTOMHRESP,nTOMHRMAN,nTOMPARAD,nTOMHRDIS

         @ Li,003 PSAY TRB->CODBEM
         @ Li,020 PSAY NGSEEK('ST9',TRB->CODBEM,1,'SUBSTR(T9_NOME,1,25)')

         Dbselectarea("TRB")
         nHDISPCC += TRB->HORDIS

         While !Eof() .And. TRB->CUSTO == cCUSTO .And. TRB->CODBEM == cCODBEM
            cSERVIC  := TRB->SERVIC
            cSEQUEN  := TRB->SEQUEN
            nTTHRDIS := TRB->HORDIS
            Store 0.00 To nTTHRHOM,nTTHRPAR,nTTHRESP,nTTHRMAN,nPARADAS

            While !Eof() .And. TRB->CUSTO == cCUSTO .And. TRB->CODBEM == cCODBEM .And.;
               TRB->SERVIC == cSERVIC .And. TRB->SEQUEN == cSEQUEN

               INCREGUA()
               @ Li,066 PSAY TRB->ORDEM
               If TRB->SEQUEN == 0
                  @ Li,074 PSAY NGSEEK('ST4',TRB->SERVIC,1,'SUBSTR(T4_NOME,1,31)')
               ELSE
                  @ Li,074 PSAY NGSEEK('STF',TRB->CODBEM+TRB->SERVIC+STR(TRB->SEQUEN,3),;
                                        1,'SUBSTR(TF_NOMEMAN,1,31)')
               Endif
               Dbselectarea("TRB")
               @ Li,136 PSAY TRB->POSCONT Picture "999999999"ÿ
               @ Li,149 PSAY TRB->DTPRIN  Picture "99/99/9999"ÿ
               @ Li,158 PSAY TRB->HORPAR  Picture "@E 99999.99"
               @ Li,168 PSAY TRB->HORESP  Picture "@E 9999.99"
               @ Li,177 PSAY TRB->HORMAN  Picture "@E 99999.99"
               @ Li,187 PSAY TRB->HORHOM  Picture "@E 9999.99"
               If MV_PAR10 == 1
                  cOBS := If(TRB->ARQUIV = 'STJ',NGSEEK('STJ',TRB->ORDEM,1,'TJ_OBSERVA'),;
                             NGSEEK('STS',TRB->ORDEM,1,'TS_OBSERVA'))
                  NGIMPMEMO(cOBS,69,046,"Obs.: ",.F.,.T.)
               Endif
               nTTHRHOM := nTTHRHOM + TRB->HORHOM
               nTTHRPAR := nTTHRPAR + TRB->HORPAR
               nTTHRESP := nTTHRESP + TRB->HORESP
               nTTHRMAN := nTTHRMAN + TRB->HORMAN
               nPARADAS := nPARADAS + 1
               NGSOMALI(58)
               Dbselectarea("TRB")
               Dbskip()
            End
            NGSOMALI(58)
            @ Li,080 PSAY STR0015 //"Total de Man:"
            @ Li,097 PSAY STR0012
            @ Li,109 PSAY nPARADAS Picture "@E 999"
            @ Li,114 PSAY STR0009 //"Hr/Dis:"
            @ Li,122 PSAY nTTHRDIS Picture "@E 99999.99"
            @ Li,132 PSAY STR0010 //"Per:"
            @ Li,138 PSAY (nTTHRPAR*100) / nTTHRDIS Picture "@E 9999.9"
            @ Li,145 PSAY "%"
            @ Li,157 PSAY nTTHRPAR Picture "@E 999999.99"
            @ Li,167 PSAY nTTHRESP Picture "@E 99999.99"
            @ Li,176 PSAY nTTHRMAN Picture "@E 999999.99"
            @ Li,186 PSAY nTTHRHOM Picture "@E 99999.99"
            nTOMHRHOM := nTOMHRHOM + nTTHRHOM
            nTOMHRPAR := nTOMHRPAR + nTTHRPAR
            nTOMHRESP := nTOMHRESP + nTTHRESP
            nTOMHRMAN := nTOMHRMAN + nTTHRMAN
            nTOMPARAD := nTOMPARAD + nPARADAS
            nTOMHRDIS := nTOMHRDIS + nTTHRDIS
            NGSOMALI(58)
            NGSOMALI(58)
         End
         @ Li,080 PSAY STR0008 //"Total de Paradas:"
         @ Li,097 PSAY STR0012
         @ Li,109 PSAY nTOMPARAD Picture "@E 999"
         @ Li,114 PSAY STR0009 //"Hr/Dis:"
         @ Li,122 PSAY nTTHRDIS Picture "@E 99999.99"
         @ Li,132 PSAY STR0010 //"Per:"
         @ Li,138 PSAY (nTOMHRPAR*100) / nTTHRDIS Picture "@E 9999.9"
         @ Li,145 PSAY "%"
         @ Li,157 PSAY nTOMHRPAR Picture "@E 999999.99"
         @ Li,167 PSAY nTOMHRESP Picture "@E 99999.99"
         @ Li,176 PSAY nTOMHRMAN Picture "@E 999999.99"
         @ Li,186 PSAY nTOMHRHOM Picture "@E 99999.99"
         NGSOMALI(58)
         nTOCHRPAR := nTOCHRPAR + nTOMHRPAR
         nTOCHRESP := nTOCHRESP + nTOMHRESP
         nTOCHRMAN := nTOCHRMAN + nTOMHRMAN
         nTOCHRHOM := nTOCHRHOM + nTOMHRHOM
         nTOCPARAD := nTOCPARAD + nTOMPARAD
         nTOCHRDIS := nTOCHRDIS + nTOMHRDIS
      End
      NGSOMALI(58)
      @ Li,080 PSAY STR0013
      @ Li,097 PSAY STR0012
      @ Li,109 PSAY nTOCPARAD Picture "@E 999"

      @ Li,114 PSAY STR0019 //"*Media.: HP x HD:"
      @ Li,135 PSAY nTOCHRPAR /nHDISPCC Picture "@E 9999999.99*"

      @ Li,157 PSAY nTOCHRPAR Picture "@E 999999.99"
      @ Li,167 PSAY nTOCHRESP Picture "@E 99999.99"
      @ Li,176 PSAY nTOCHRMAN Picture "@E 999999.99"
      @ Li,186 PSAY nTOCHRHOM Picture "@E 99999.99"
      NGSOMALI(58)
      nTOTHRPAR := nTOTHRPAR + nTOCHRPAR
      nTOTHRESP := nTOTHRESP + nTOCHRESP
      nTOTHRMAN := nTOTHRMAN + nTOCHRMAN
      nTOTHRHOM := nTOTHRHOM + nTOCHRHOM
      nTOTPARAD := nTOTPARAD + nTOCPARAD
      nTOTHRDIS := nTOTHRDIS + nTOCHRDIS
      nTOHDPCC  := nTOHDPCC  + nHDISPCC
   End
   If nTOTPARAD > 0.00 .Or. nTOTHRPAR > 0.00 .Or.  nTOTHRESP > 0.00 .Or.;
      nTOTHRMAN > 0.00 .Or. nTOTHRHOM > 0.00
      NGSOMALI(58)
      @ Li,080 PSAY STR0014
      @ Li,097 PSAY STR0012
      @ Li,109 PSAY nTOTPARAD Picture "@E 999"

      @ Li,114 PSAY STR0019 //"*Media.: HP x HD:"
      @ Li,134 PSAY nTOCHRPAR / nTOHDPCC Picture "@E 99999999.99*"

      @ Li,157 PSAY nTOTHRPAR Picture "@E 999999.99"
      @ Li,167 PSAY nTOTHRESP Picture "@E 99999.99"
      @ Li,176 PSAY nTOTHRMAN Picture "@E 999999.99"
      @ Li,186 PSAY nTOTHRHOM Picture "@E 99999.99"
   Endif

   RODA(nCNTIMPR,cRODATXT,TAMANHO)
   RETINDEX("ST9")
   SET FILTER TO
   SET DEVICE TO SCREEN
   If aRETURN[5] == 1
      SET PRINTER TO
      dbCommitAll()
      OURSPOOL(WNREL)
   Endif
   MS_FLUSH()
Endif
Dbselectarea("TRB")
USE
RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Descri‡…o³Processa as ordem de servico - NORMAIS ( STJ )              ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function MNTR005STJ()
cCONDSTJ1 := 'stj->tj_termino = "S" .And. stj->tj_situaca = "L" .And. '
cCONDSTJ1 := cCONDSTJ1 + '(stj->tj_servico >= MV_PAR07 .And. stj->tj_servico <= MV_PAR08) .And.'
cCONDSTJ1 := cCONDSTJ1 + '(stj->tj_ccusto  >= MV_PAR03 .And. stj->tj_ccusto  <= MV_PAR04)'

cCONDSTL := 'stl->tl_sequenc > 0 .And. (stl->tl_tiporeg = "M" .Or. stl->tl_tiporeg = "E")'

Dbselectarea("STJ")
Dbsetorder(2)
Dbseek(xFILIAL("STJ")+"B"+MV_PAR05,.T.)
Procregua(LASTREC())
While !Eof() .And. STJ->TJ_FILIAL == xFILIAL("STJ") .And.;
   STJ->TJ_TIPOOS = "B" .And. STJ->TJ_CODBEM <= MV_PAR06

   Incproc()
   cCODBEM := stj->tj_codbem
   If !MNTR005CAL(cCODBEM,"STJ")
      lPROBLEMA := .T.
      Exit
   Endif
   Dbselectarea("STJ")
   Dbsetorder(2)
   While !Eof() .And. STJ->TJ_FILIAL == xFILIAL("STJ") .And.;
      STJ->TJ_TIPOOS == "B" .And. STJ->TJ_CODBEM == cCODBEM

      If &(cCONDSTJ1)
         cCONDSTJ2 := If(Empty(stj->tj_dtprini),'(stj->tj_dtmrini >= MV_PAR01 .And. stj->tj_dtmrini <= MV_PAR02)',;
                        '(stj->tj_dtprini >= MV_PAR01 .And. stj->tj_dtprini <= MV_PAR02)')
         If &(cCONDSTJ2)
            If !EMPTY(MV_PAR09)
               If nMVPAR != STJ->TJ_SEQUENC
                  Dbskip()
                  Loop
               Endif
            Endif

            nTOHRHOM := 0.00
            Dbselectarea("STL")
            Dbsetorder(1)
            Dbseek(xFILIAL("STL")+STJ->TJ_ORDEM+STJ->TJ_PLANO)
            While !Eof() .And. STL->TL_FILIAL == xFILIAL("STL") .And.;
               STL->TL_ORDEM == STJ->TJ_ORDEM .And. STL->TL_PLANO == STJ->TJ_PLANO

               If &(cCONDSTL)
                  nTOHRHOM := nTOHRHOM+STL->TL_QUANTID
               Endif
               Dbselectarea("STL")
               Dbskip()
            End

            MNTR005CHP(STJ->TJ_DTPRINI,STJ->TJ_HOPRINI,STJ->TJ_DTMRINI,;
                       STJ->TJ_HOMRINI,STJ->TJ_DTPRFIM,STJ->TJ_HOPRFIM,;
                       STJ->TJ_DTMRFIM,STJ->TJ_HOMRFIM)

            MNTR005TRB(STJ->TJ_CCUSTO,STJ->TJ_CODBEM,STJ->TJ_ORDEM,STJ->TJ_SERVICO,;
                       STJ->TJ_SEQUENC,'STJ',STJ->TJ_POSCONT)

         Endif
      Endif
      Dbselectarea("STJ")
      Dbskip()
   End
End
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Descri‡…o³Processa as ordem de servico - NORMAIS ( STS )              ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MNTR005STS()
cCONDSTS1 := 'sts->ts_termino = "S" .And. sts->ts_situaca = "L" .And. '
cCONDSTS1 := cCONDSTS1 + '(sts->ts_servico >= MV_PAR07 .And. sts->ts_servico <= MV_PAR08) .And. '
cCONDSTS1 := cCONDSTS1 + '(sts->ts_ccusto >= MV_PAR03 .And. sts->ts_ccusto <= MV_PAR04)'

cCONDSTT := 'stt->tt_sequenc > 0 .And. (stt->tt_tiporeg = "M" .Or. stt->tt_tiporeg = "E")'

Dbselectarea("STS")
Dbsetorder(2)
Dbseek(xFILIAL("STS")+"B"+MV_PAR05,.T.)
Procregua(LASTREC())
While !Eof() .And. STS->TS_FILIAL == xFILIAL("STS") .And.;
   STS->TS_TIPOOS = "B" .And. STS->TS_CODBEM <= MV_PAR06

   Incproc()
   cCODBEM := sts->ts_codbem
   If !MNTR005CAL(cCODBEM,"STS")
      lPROBLEMA := .T.
      Exit
   Endif
   Dbselectarea("STS")
   Dbsetorder(2)
   While !Eof() .And. STS->TS_FILIAL == xFILIAL("STS") .And.;
      STS->TS_TIPOOS == "B" .And. STS->TS_CODBEM == cCODBEM

      If &(cCONDSTS1)
         cCONDSTS2 := If(Empty(sts->ts_dtprini),'(sts->ts_dtmrini >= MV_PAR01 .And. sts->ts_dtmrini <= MV_PAR02)',;
                        '(sts->ts_dtprini >= MV_PAR01 .And. sts->ts_dtprini <= MV_PAR02)')
         If &(cCONDSTS2)
            If !EMPTY(MV_PAR09)
               If nMVPAR != STS->TS_SEQUENC
                  Dbskip()
                  Loop
               Endif
            Endif

            nTOHRHOM := 0.00
            Dbselectarea("STT")
            Dbsetorder(1)
            Dbseek(xFILIAL("STT")+STS->TS_ORDEM+STS->TS_PLANO)
            While !Eof() .And. STT->TT_FILIAL == xFILIAL("STT") .And.;
               STT->TT_ORDEM == STS->TS_ORDEM .And. STT->TT_PLANO == STS->TS_PLANO

               If &(cCONDSTT)
                  nTOHRHOM := nTOHRHOM+STT->TT_QUANTID
               Endif
               Dbselectarea("STT")
               Dbskip()
            End

            MNTR005CHP(STS->TS_DTPRINI,STS->TS_HOPRINI,STS->TS_DTMRINI,;
                       STS->TS_HOMRINI,STS->TS_DTPRFIM,STS->TS_HOPRFIM,;
                       STS->TS_DTMRFIM,STS->TS_HOMRFIM)

            MNTR005TRB(STS->TS_CCUSTO,STS->TS_CODBEM,STS->TS_ORDEM,STS->TS_SERVICO,;
                       STS->TS_SEQUENC,'STS',STS->TS_POSCONT)
         Endif
      Endif
      Dbselectarea("STS")
      Dbskip()
   End
End
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Descri‡…o³Calcula as horas de disponiveis do calendario do bem        ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MNTR005CAL(cVBEM,cARQP)
Local i := 0   
Dbselectarea("ST9")
Dbsetorder(1)
If !Dbseek(xFILIAL("ST9")+cVBEM)
   Msginfo(STR0020+" "+Alltrim(cVBEM)+" "+STR0021+" "+cARQP+" "+STR0022+" "+STR0023+" ST9.",STR0024)
   Return .f.
Endif

//Apura total de horas disponivel no periodo
nPOS := aSCAN(aTRAB,{|X| X[1] == ST9->T9_CALENDA})
If nPOS > 0
   nTHRDISP := aTRAB[nPOS][2]
ELSE
   aDIAMAN := NG_H7(ST9->T9_CALENDA)
   If Empty(aDIAMAN)
      Msginfo(STR0025+" "+ST9->T9_CALENDA+" ";
             +STR0021+" "+STR0020+" "+Alltrim(cVBEM)+" "+STR0022+" "+STR0023+" SH7.",STR0024)
      Return .f.
   Endif
   dDIA    := MV_PAR01
   nDIAS   := (MV_PAR02 - MV_PAR01) + 1
   nOCO    := MONTH(dDIA)
   nSOMA   := 0
   FOR i := 1 TO nDIAS
       nSEM  := If(DOW(dDIA)==1,7,DOW(dDIA)-1)
       nSOMA := nSOMA + HTOM(aDIAMAN[nSEM][03])
       dDIA  := dDIA + 1
   NEXT
   nSOMA := MTOH(nSOMA)
   nPOS  := AT(":",nSOMA)
   If nPOS >0
      nPOS1 := SUBSTR(nSOMA,1,(nPOS-1))
      nPOS2 := SUBSTR(nSOMA,(nPOS+1))
      nTHRDISP := VAL(nPOS1) + (VAL(nPOS2)/100)
      nTHRDISP := If(nTHRDISP<0,0,nTHRDISP)
      AADD(aTRAB,{ST9->T9_CALENDA,nTHRDISP})
   Endif
Endif
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Descri‡…o³Calcula as horas de parada                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MNTR005CHP(dDTPRINI,cHOPRINI,dDTMRINI,cHOMRINI,dDTPRFIM,;
                           cHOPRFIM,dDTMRFIM,cHOMRFIM)

//Calcula Horas Paradas
dDTINI    := dDTPRINI
cHRINI    := cHOPRINI
dDTPARINI := dDTPRINI
If EMPTY(dDTPRINI)
   dDTINI := dDTMRINI
   cHRINI := cHOMRINI
   dDTPARINI := dDTMRINI
Endif
dDTFIM := dDTPRFIM
cHRFIM := cHOPRFIM
If EMPTY(dDTPRFIM)
   dDTFIM := dDTMRFIM
   cHRFIM := cHOMRFIM
Endif
If dDTMRFIM > MV_PAR02
   dDTFIM := MV_PAR02
Endif 

If MV_PAR11 = 2 //Calcula as horas de parada considerando calendario do bem
   nTOHRPAR := NGCALENHORA(dDTINI,cHRINI,dDTFIM,cHRFIM,ST9->T9_CALENDA)
Else
   CALHORDAT()
   nTOHRPAR := nHORAS
EndIf

//Calcula Horas Espera
dDTINI := dDTPRINI
cHRINI := cHOPRINI
If EMPTY(dDTPRINI)
   dDTINI := dDTMRINI
   cHRINI := cHOMRINI
Endif
dDTFIM := dDTMRINI
cHRFIM := cHOMRINI
If dDTMRFIM > MV_PAR02
   dDTFIM := MV_PAR02
Endif 

If MV_PAR11 = 2 //Calcula as horas de espera considerando calendario do bem
   nTOHRESP := NGCALENHORA(dDTINI,cHRINI,dDTFIM,cHRFIM,ST9->T9_CALENDA)
Else
   CALHORDAT()
   nTOHRESP := nHORAS
EndIf

//Calcula Horas Manutencao
dDTINI := dDTMRINI
cHRINI := cHOMRINI
dDTFIM := dDTMRFIM
cHRFIM := cHOMRFIM
If dDTMRFIM > MV_PAR02
   dDTFIM := MV_PAR02
Endif

If MV_PAR11 = 2 //Calcula as horas da manutencao considerando calendario do bem
   nTOHRMAN := NGCALENHORA(dDTINI,cHRINI,dDTFIM,cHRFIM,ST9->T9_CALENDA)
Else
   CALHORDAT()
   nTOHRMAN := nHORAS
EndIf 

Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Descri‡…o³Grava o arquivo temporario                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MNTR005TRB(cCCUSTO,cVBEM,cORDEM,cSERV,nSEQU,cARQ,nPOSC)

Dbselectarea("TRB")
TRB->(DbAppend())
TRB->CUSTO  := cCCUSTO
TRB->CODBEM := cVBEM
TRB->ORDEM  := cORDEM
TRB->SERVIC := cSERV
TRB->SEQUEN := nSEQU
TRB->DTPRIN := dDTPARINI
TRB->HORPAR := nTOHRPAR
TRB->HORESP := nTOHRESP
TRB->HORMAN := nTOHRMAN
TRB->HORHOM := nTOHRHOM
TRB->HORDIS := nTHRDISP
TRB->ARQUIV := cARQ
TRB->POSCONT:= nPOSC
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CALHORDAT  ³ Autor ³ Deivys Joenck        ³ Data ³ 19/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Calcula horas entre duas datas                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ MNTR005                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function CALHORDAT()
nSOMA  := 0
nHORAS := 0
hINI   := (HTOM(cHRINI)/60)
hFIM   := (HTOM(cHRFIM)/60)

If dDTFIM > dDTINI
   nSOMA := ((dDTFIM-dDTINI)*24)
Endif
nHORAS := (hFIM+nSOMA)-hINI
RETURN .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ NGCHKCART ³ Autor ³ Deivys Joenck        ³ Data ³ 27/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Checa se foram digitados caracteres no parametro de sequen ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ MNTR005                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function NGCHKCART()
Local x := 0
If !Empty(MV_PAR09)
   For x:=1 To Len(AllTrim(MV_PAR09))
      If !Isdigit(Substr(MV_PAR09,x,1))
         return .F.
      Endif
   Next
Endif
Return .T.
