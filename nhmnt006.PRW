#INCLUDE "MNTR780.ch"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MNTR780  ³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Historico de Bens                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function NHMNT006()   

Local cString    := "ST9"
Local cdesc1     := STR0001 //"Apresentacao do historico de bens selecionados."
Local cdesc2     := STR0002 //"E permitido selecionar o tipo de informacao a ser"
Local cdesc3     := STR0003 //"apresentada, atraves dos parametros do relatorio."
Local wnrel      := "MNTR006"
Private aReturn  := { STR0004, 1,STR0005, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nLastKey := 0
Private cPerg    := "MNT78R"
Private Titulo   := STR0006 //"Historico de Bens"
Private Tamanho  := "M"
Private nomeprog := "MNTR006"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // De  Centro de Custos                         ³
//³ mv_par02     // Ate Centro de Custos                         ³
//³ mv_par03     // De Centro de Trabalho                        ³
//³ mv_par04     // Ate Centro de Trabalho                       ³
//³ mv_par05     // De Familia de Bem                            ³
//³ mv_par06     // Ate Familia de Bem                           ³
//³ mv_par07     // De  Bem                                      ³
//³ mv_par08     // Ate Bem                                      ³
//³ mv_par09     // De Servico                                   ³
//³ mv_par10     // Ate Servico                                  ³
//³ mv_par11     // De Data Manutencao                           ³
//³ mv_par12     // Ate Data Manutencao                          ³
//³ mv_par13     // Detalhes do Bem 1 - Mostra 2 - Nao Mosta     ³
//³ mv_par14     // Descricao Bem   1 - Mostra 2 - Nao Mosta     ³
//³ mv_par15     // Descricao Manut.1 - Mostra 2 - Nao Mosta     ³
//³ mv_par16     // Lista O.S Observacao 1 - Sim 2 - Nao         ³
//³ mv_par17     // Previsto/Real 1-Previsto/Reali 2- So realiza.³
//³ mv_par18     // Lista Ins. Observacao 1 - Sim 2 - Nao        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
If nLastKey = 27
   Set Filter To
   DbSelectArea("ST0")
   Return
EndIf
SetDefault(aReturn,cString)
TITULO := 'Historico de Bens - no Periodo de ' + DTOC(mv_par11) + ' a ' + DTOC(mv_par12)
RptStatus({|lEnd| R006Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

DbSelectArea("ST0")
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R006Imp  ³ Autor ³ Inacio Luiz Kolling   ³ Data ³ 13.11.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R006Imp(lEnd,wnRel,titulo,tamanho)
Local cRodaTxt  := ""
Local nCntImpr  := 0
Local x := 0

Private li := 80 ,m_pag := 1
Private Cabec1  := " "
Private Cabec2  := " "

cCONDST9 := '(ST9->T9_CENTRAB >= MV_PAR03 .And. ST9->T9_CENTRAB <= MV_PAR04) .And. '
cCONDST9 := cCONDST9+'(ST9->T9_CODFAMI >= MV_PAR05 .And. ST9->T9_CODFAMI <= MV_PAR06)'
         
cCONDSTJ := 'STJ->TJ_SITUACA <> "C" .And. STJ->TJ_TIPOOS = "B" .and. '
cCONDSTJ := cCONDSTJ+'(STJ->TJ_CODBEM >= MV_PAR07 .And. STJ->TJ_CODBEM <= MV_PAR08) .And. '
cCONDSTJ := cCONDSTJ+'(STJ->TJ_SERVICO >= MV_PAR09 .And. STJ->TJ_SERVICO <= MV_PAR10) .And. '
cCONDSTJ := cCONDSTJ+'(STJ->TJ_DTORIGI >= MV_PAR11 .And. STJ->TJ_DTORIGI <= MV_PAR12)'

cCONDSTS := 'STS->TS_SITUACA <> "C" .And. STS->TS_TIPOOS = "B" .and. '
cCONDSTS := cCONDSTS+'(STS->TS_CODBEM >= MV_PAR07 .And. STS->TS_CODBEM <= MV_PAR08) .And. '
cCONDSTS := cCONDSTS+'(STS->TS_SERVICO >= MV_PAR09 .And. STS->TS_SERVICO <= MV_PAR10) .And. '
cCONDSTS := cCONDSTS+'(STS->TS_DTORIGI >= MV_PAR11 .And. STS->TS_DTORIGI <= MV_PAR12)'

aTarefa   := {}
temtarefa := .f.
dtrealini := CtoD("  /  /    ")
dtrealfim := CtoD("  /  /    ")
hrealini  := space(05)
hrealfim  := space(05)
dtprelini := CtoD("  /  /    ")
dtprelfim := CtoD("  /  /    ")
hrprlini  := space(05)
hrprlfim  := space(05)
nTipo     := IIF(aReturn[4]==1,15,18)

/*
          1         2         3         4         5         6         7         8         9         0         1         2         3
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

 Bem........: xxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  Familia...: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 Pai........: xxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  Familia...: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 Fornecedor.: xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxx  Fabricante: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Cal.: XXX
 Modelo.....: xxxxxxxxx    Serie..: xxxxxxxxxxxxxxx    Dt.Compra.: dd/mm/aa    Cod.Imob.: xxxxxxxxxxxxxxx      Prazo Gar.: xxxxxx xx
 Dt.Garan...: dd/mm/aaaa   Prior..: xxx    Cod.Estoq.: xxxxxxxxxxxxxxx         Tem Estr.: xxx   Sit.Bem..: x   Sit.Manut.: x      
 Desc.Cont1.: xxxxxxxxxxxxxx Contador..: 999.999.999 Acum.: 999.999.999.999 Dt.Acomp.: dd/mm/aaaa Var/Dia: 999999 Limite: 999.999.999
 Desc.Cont2.: xxxxxxxxxxxxxx Contador 2: 999.999.999 Acum.: 999.999.999.999 Dt.Acomp.: dd/mm/aaaa Var/Dia: 999999 Limite: 999.999.999
 Ponderacao.: Jan  Fev  Mar  Abr  Mai  Jun  Jul  Ago  Set  Out  Nov   Dez                                   
             X,XX X,XX X,XX X,XX X,XX X,XX X,XX X,XX X,XX X,XX X,XX, X,XX
 
 Caracter...: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx
              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx
 Descricao..: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
             
 O.S.   Plano  Serv.  Seq. Nome Servico                Contado 1  Contador 2 Evento P/R  .....Inicio..... ......Fim.......   DD-HH-MM
 xxxxxx xxxxxx xxxxxx  999 xxxxxxxxxxxxxxxxxxxxxxxxx 999.999.999 999.999.999 Parada  P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx xxxx xx xx
                                                                             Parada  R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx
                                                                             Exec.   P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx xxxx xx xx
                                                                             Exec.   R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx xxxx xx xx                                                                                         
                                                                            
        Observacao..: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                      
        Motivo do Atraso da  O.S..:  Motivo Descricao                                   .....Inicio..... ......Fim.......           
                                     xxxx   xxxxxxxxxxxxxxxxxxxx                        xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  
                                     xxxx   xxxxxxxxxxxxxxxxxxxx                        xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx
                                     
        Problema da O.S..:  xxxxxx codigo xxxxxnome truncadoxxxxxxxxxxx   -  xxxxxxxxdescricao do problemaxxxxxxxxxxxxx
                            xxxxxx codigo xxxxxnome truncadoxxxxxxxxxxx   -  xxxxxxxxdescricao do problemaxxxxxxxxxxxxx

        Tarefa..: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx           Exec.   P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx
                                                                            Exec.   R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx 
                        
           Problema da Tarefa.: xxxxxx xxxcodigoxxxxx xxxxxnome truncadoxxxxxxxxxxx  - xxxxxxxxxxxxxxdescricao do problemaxxxxxxxxxxx
                                xxxxxx xxxcodigoxxxxx xxxxxnome truncadoxxxxxxxxxxx  - xxxxxxxxxxxxxxdescricao do problemaxxxxxxxxxxx

                  Etapa..: R  xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                           Opcao..: XXXXXXXXXXXXXXX   Informou..: XXXXXXXXXXXXXXX  
                           Opcao..: XXXXXXXXXXXXXXX   Marcou....: SIM
                 

                  Ins..: xxxx xxxxxxxxxxxxxxx xxxxxxxxxtamanho 28xxxxxxxxx
                         Sq: xx Qr: xxx Quan: 999.999,99 Un: xxx Dest: xxx  Exec.   P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx
                                                                            Exec.  *R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx //Asteristico se o insumo tiver 
                         Sq: xx Qr: xxx Quan: 999.999,99 Un: xxx Dest: xxx  Exec.   P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx   garantia gravado no tpz
                                                                            Exec.   R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx
        Observacao..: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

                  Ins..: xxxx xxxxxxxxxxxxxxx xxxxxxxxxtamanho 28xxxxxxxxx
                         Sq: xx Qr: xxx Quan: 999.999,99 Un: xxx Dest: xxx  Exec.   P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx
                                                                            Exec.   R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx
                         Sq: xx Qr: xxx Quan: 999.999,99 Un: xxx Dest: xxx  Exec.   P   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx
                                                                            Exec.   R   xx/xx/xxxx xx:xx xx/xx/xxxx xx:xx  xxxx xx xx

                  Ocorr: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                  Causa: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                  Soluc: xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

                  Descricao.: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*/

aDBF := {{"CUSTO"    , "C", Len(stj->tj_ccusto),0} ,;
         {"TRABALHO" , "C", Len(stj->tj_centrab),0} ,;
         {"ORDEM"    , "C", 06,0} ,;
         {"PLANO"    , "C", 06,0} ,;
         {"BEM"      , "C", 16,0} ,;
         {"ARQUIVO"  , "C", 03,0}}

cARQ1      := CriaTrab(aDBF,.T.)
Use (cARQ1) alias TRB EXCLUSIVE NEW
Index On CUSTO+TRABALHO+BEM+PLANO+ORDEM To (cARQ1)

// PROCESSAO O HISTORICO ( STS )
DbSelectArea("STS")
DbSetOrder(04)
DbSeek(xFilial("STS")+MV_PAR01,.T.)
While !Eof() .And. STS->TS_FILIAL == xFILIAL("STS") .And.;
   STS->TS_CCUSTO <= MV_PAR02

   If &(cCONDSTS)

      DbSelectArea("ST9")
      DbSetOrder(01)
      If DbSeek(xFilial("ST9")+STS->TS_CODBEM)
         If &(cCONDST9)
            GRAVAR006(STS->TS_CCUSTO,ST9->T9_CENTRAB,STS->TS_ORDEM,STS->TS_PLANO,STS->TS_CODBEM,"STS")
         Endif
      Endif
   Endif
   DbSelectArea("STS")
   Dbskip()
End

// PROCESSAO O HISTORICO ( STJ )
DbSelectArea("STJ")
DbSetOrder(07)
DbSeek(xFilial("STJ")+MV_PAR01,.T.)
While !Eof() .And. STJ->TJ_FILIAL == xFILIAL("STJ") .And.;
   STJ->TJ_CCUSTO <= MV_PAR02
   If &(cCONDSTJ)
      DbSelectArea("ST9")
      DbSetOrder(01)
      If DbSeek(xFilial("ST9")+STJ->TJ_CODBEM)
         If &(cCONDST9)
            GRAVAR006(STJ->TJ_CCUSTO,ST9->T9_CENTRAB,STJ->TJ_ORDEM,STJ->TJ_PLANO,STJ->TJ_CODBEM,"STJ")
         Endif
      Endif
   Endif
   DbSelectArea("STJ")
   Dbskip()
End

DbSelectArea("TRB")
DbGotop()
SetRegua(LastRec())
While !Eof()
  
   cCUSTO := TRB->CUSTO
   SOMALI006()
   @ Li,000 Psay STR0011 //"BENS DO CENTRO DE CUSTO = "
   @ Li,026 Psay Alltrim(cCUSTO) +" "+ NGSEEK('SI3',cCUSTO,1,'I3_DESC')

   DbSelectArea("TRB")
   While !Eof() .And. TRB->CUSTO == cCUSTO
    
      cTRABALHO := TRB->TRABALHO
      SOMALI006()
      @ Li,000 Psay STR0012 //"CENTRO DE TRABALHO = "
      @ Li,021 Psay cTRABALHO
      @ Li,042 Psay NGSEEK("SHB",cTRABALHO,1,"HB_NOME")
      SOMALI006()  

      DbSelectArea("TRB")
      While !Eof() .And. TRB->CUSTO == cCUSTO .And. TRB->TRABALHO == cTRABALHO

         cBEM  := TRB->BEM
         lPRIM := .T.  
         DbSelectArea("TRB")
         While !Eof() .And. TRB->CUSTO == cCUSTO .And. TRB->TRABALHO == cTRABALHO .And.;
            cBEM == TRB->BEM

            IncRegua()
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifica se o Bem tem Bem Pai                            ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lPRIM
               DbSelectArea("STC")
               DbSetOrder(03)
               cChave := TRB->BEM
               While .T.
                  If DbSeek(xFilial("STC")+cChave)
                     cChave := STC->TC_CODBEM
                     Dbskip()
                     Loop
                  EndIf
                  Exit
               End

               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Primeira Linha da Estrutura                 ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               SOMALI006()
               DbSelectArea("ST9")
               DbSetOrder(01)
               DbSeek(xFilial("ST9")+TRB->BEM)
               @ Li,000 Psay STR0014 //"Bem........:"
               @ Li,013 Psay ST9->T9_CODBEM
               @ Li,031 Psay Substr(ST9->T9_NOME,1,38)
               @ Li,072 Psay STR0015 //"Familia...:"
               @ Li,084 Psay ST9->T9_CODFAMI
               @ Li,091 Psay NGSEEK("ST6",ST9->T9_CODFAMI,1,"T6_NOME")
                                      
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Segunda  Linha do Bem                       ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If TRB->BEM != cChave
                  DbSelectArea("ST9")
                  DbSetOrder(1)
                  DbSeek(xFilial("ST9") + cChave)
                  SOMALI006()
                  @ Li,000 Psay STR0016 //"Pai........:"
                  @ Li,013 Psay cChave
                  @ Li,031 Psay Substr(ST9->T9_NOME,1,38)
                  @ Li,072 Psay STR0015 //"Familia...:"
                  @ Li,084 Psay ST9->T9_CODFAMI
                  @ Li,091 Psay NGSEEK("ST6",ST9->T9_CODFAMI,1,"T6_NOME")
               EndIf

               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Terceira Linha do Bem                       ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               DbSelectArea("ST9")
               DbSetOrder(01)
               DbSeek(xFilial("ST9")+TRB->BEM)
               If MV_PAR13 = 1
                  SOMALI006()
                  @ Li,000 Psay STR0017 //"Fornecedor.:"
                  @ Li,013 Psay ST9->T9_FORNECE
                  @ Li,034 Psay NGSEEK("SA2",ST9->T9_FORNECE,1,"Substr(SA2->A2_NOME,1,27)") 
                  @ Li,063 Psay STR0018 //"Fabricante:"
                  @ Li,075 Psay ST9->T9_FABRICA
                  @ Li,082 Psay NGSEEK("ST7",ST9->T9_FABRICA,1,"T7_NOME")  //ST7->T7_NOME
                  @ Li,123 Psay STR0019 //"Cal.:"
                  @ Li,129 Psay ST9->T9_CALENDA
               EndIf
                    
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Quarta   Linha do Bem                       ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If MV_PAR13 = 1
                  SOMALI006()
                  @ Li,000 Psay STR0020 //"Modelo.....:"
                  @ Li,013 Psay ST9->T9_MODELO
                  @ Li,026 Psay STR0021 //"Serie..:"
                  @ Li,035 Psay ST9->T9_SERIE
                  @ Li,054 Psay STR0022 //"Dt.Compra.:"
                  @ Li,066 Psay ST9->T9_DTCOMPR
                  @ Li,079 Psay STR0023 //"Cod.Imob.:"
                  @ Li,090 Psay ST9->T9_CODIMOB
                  @ Li,110 Psay STR0024 //"Prazo Gar.:"
                  @ Li,122 Psay ST9->T9_PRGARAN Picture '999999'
                  @ Li,130 Psay ST9->T9_UNGARAN
               EndIf
                    
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Quinta   Linha do Bem                       ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If MV_PAR13 = 1
                  SOMALI006()
                  @ Li,000 Psay STR0025 //"Dt.Garan...:"
                  @ Li,013 Psay ST9->T9_DTGARAN
                  @ Li,026 Psay STR0026 //"Prior..:"
                  @ Li,035 Psay ST9->T9_PRIORID
                  @ Li,042 Psay STR0027 //"Cod.Estoq.:"
                  @ Li,054 Psay ST9->T9_CODESTO
                  @ Li,079 Psay STR0028 //"Tem Estr.:"
                  @ Li,090 Psay ST9->T9_ESTRUTU
                  @ Li,095 Psay STR0033 //"Sit.Bem..:"
                  @ Li,106 Psay ST9->T9_SITBEM
                  @ Li,110 Psay STR0034 //"Sit.Manut.:"
                  @ Li,122 Psay ST9->T9_SITMAN
               EndIf
              
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Sexta    Linha do Bem                       ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If MV_PAR13 = 1
                  If ST9->T9_TEMCONT <> "N"
                     SOMALI006() 
                     @ Li,000 Psay STR0071 //"Desc.Cont1.:"                                                       
                     @ Li,013 Psay Substr(ST9->T9_TPCONTA,1,14)
                     @ Li,028 Psay STR0029 //"Contador..:" 
                     @ Li,039 Psay ST9->T9_POSCONT Picture "@E 999,999,999"
                     @ Li,052 Psay STR0072 //"Acum.:"
                     @ Li,059 Psay ST9->T9_CONTACU Picture "@E 999,999,999,999"
                     @ Li,075 Psay STR0030  //"Dt.Acomp.:" 
                     @ Li,086 Psay ST9->T9_DTULTAC
                     @ Li,097 Psay STR0031 //"Var/Dia:"
                     @ Li,106 Psay ST9->T9_VARDIA  Picture "@E 999999"
                     @ Li,113 Psay STR0032 //"Limite:"	
                     @ Li,121 Psay ST9->T9_LIMICON Picture "@E 999,999,999"
                  EndIf 
                  
                  DbSelectArea("TPE")
	              DbSetOrder(1)
     			  If DbSeek(xFilial("TPE")+ST9->T9_CODBEM)
     			     SOMALI006()                                   
                     @ Li,000 Psay STR0073   //"Desc.Cont2.:"                                                       
                     @ Li,013 Psay Substr(TPE->TPE_TPCONT,1,14)  
                     @ Li,028 Psay STR0058   //"Contador 2:"
				     @ Li,039 Psay TPE->TPE_POSCON Picture "@E 999,999,999"
                     @ Li,052 Psay STR0072   //"Acum.:"
                     @ Li,059 Psay TPE->TPE_CONTAC Picture "@E 999,999,999,999"
                     @ Li,075 Psay STR0030   //"Dt.Acomp.:" 
                     @ Li,086 Psay TPE->TPE_DTULTA
                     @ Li,097 Psay STR0031   //"Var/Dia:"
                     @ Li,106 Psay TPE->TPE_VARDIA  Picture "@E 999999"
                     @ Li,113 Psay STR0032   //"Limite:"	 
                     @ Li,121 Psay TPE->TPE_LIMICON Picture "@E 999,999,999"
                  EndIf     
               EndIf

               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Linha de Poderacao de Uso do Bem            ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If MV_PAR13 = 1
                  SOMALI006()
                  @ Li,000 Psay STR0035 //"Ponderacao.: Jan  Fev  Mar  Abr  Mai  Jun  Jul  Ago  Set  Out  Nov  Dez"
                  SOMALI006()
                  @ Li,012 Psay ST9->T9_PONDERA
               EndIf
        
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Linha de Caracteristicas                    ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If MV_PAR13 = 1
                  lPrimeiro = .F.
                  DbSelectArea("STB")
                  DbSetOrder(01)
                  DbSeek(xFilial("STB")+ST9->T9_CODBEM)
                  While !Eof() .And. STB->TB_CODBEM == ST9->T9_CODBEM .And.;
                     STB->TB_FILIAL == xFilial("STB")
                     
                     SOMALI006()
                     If !lPrimeiro
                        lPrimeiro = .T.
                        @ Li,000 Psay STR0036 //"Caracter...:"     
                     EndIf
                     @ Li,013 Psay NGSEEK("TPR",STB->TB_CARACTE,1,"Substr(TPR_NOME,1,39)")
                     @ Li,054 Psay Substr(STB->TB_DETALHE,1,14)
                     @ Li,070 Psay STB->TB_UNIDADE
                     DbSelectArea("STB")
                     Dbskip()
                     Loop
                  End
               EndIf
               
               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³ Impressao da Linha de Descricao                          ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               LPRIMOPE := .F.
               If MV_PAR14 = 1 
                  SOMALI006()
                  NGIMPMEMO(ST9->T9_DESCRIC,56,0,STR0037,.F.,.F.) //"Descricao..: "  
               EndIf
               cabecos()
               lPRIM := .F.
            EndIf

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Impressao da Linha de Manutencoes                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            // PROCURA OS HISTORICOS DAS O.S. NO STS990
            If TRB->ARQUIVO == "STS"
               DbSelectArea("STS")
               DbSetOrder(01)
               If DbSeek(xFilial("STS")+TRB->ORDEM+TRB->PLANO)
                  SOMALI006()
                  PROCORDEM(sts->ts_ordem,sts->ts_plano,sts->ts_servico,sts->ts_sequenc,;
                            sts->ts_dtppini,sts->ts_hoppini,sts->ts_dtppfim,sts->ts_hoppfim,;
                            sts->ts_dtprini,sts->ts_hoprini,sts->ts_dtprfim,sts->ts_hoprfim,;
                            sts->ts_dtmpini,sts->ts_hompini,sts->ts_dtmpfim,sts->ts_hompfim,;
                            sts->ts_dtmrini,sts->ts_homrini,sts->ts_dtmrfim,sts->ts_homrfim,;
                            sts->ts_poscont,sts->ts_poscon2) 
                  
                  //LISTA OBSERVACAO DA O.S          
                  If MV_PAR16 = 1
                     LPRIMOPE := .F. 
                     SOMALI006()
                     NGIMPMEMO(STS->TS_OBSERVA,94,007,STR0038,.F.,.T.) //"Observacao.:"
                  EndIf
                                                         
                  // MOTIVO DE ATRASO DA O.S.
                  R006MOTAT()
                              
                  // IMPRIME OS PROBLEMA DA O.S.
                  DbSelectArea("STV")
                  DbSetOrder(01)
                  DbSeek(xFilial("STV")+STS->TS_ORDEM+STS->TS_PLANO+Space(06))
                  prim := .t.
                  While !Eof() .And. xFilial("STV") == stv->tv_filial .And.;
                     stv->tv_ordem == sts->ts_ordem .And. stv->tv_plano == sts->ts_plano  .And.;
                     stv->tv_tarefa == Space(06)

                     SOMALI006()
                     If prim
                        SOMALI006()
                        @li,007 Psay STR0039 //"Problema da O.S..:"
                        prim := .F.
                     EndIf
                     nnome   := Space(29)
                     PROCNOMBE(STV->TV_TIPOREG,STV->TV_CODIGO)
                     @li,076 Psay stv->tv_descric
                     DbSelectArea("STV")
                     Dbskip()
                  End
     
                  //IMPRIME DESCRICAO DA MANUTENCAO
                  If MV_PAR15 = 1 
                     LPRIMOPE := .F.
                     DbSelectArea("STF")
                     DbSetOrder(01)
                     If DbSeek(xFilial("STF")+sts->ts_codbem+sts->ts_servico+str(sts->ts_sequenc,3))
                        NGIMPMEMO(STF->TF_DESCRIC,56,007,STR0037,.F.,.T.) //"Descricao..:"
                     EndIf    
                  EndIf
                  
                  // PROCURA AS TAREFAS COM DATA E HORA DE INICIO E FIM
                  aTarefa := {}
                  temtarefa := .f.
                  ZERADATA()
                  DbSelectArea("STT")
                  DbSetOrder(01)
                  If DbSeek(xFilial("STT")+STS->TS_ORDEM+STS->TS_PLANO)
                     While !Eof() .And. xFilial("STT") == stt->tt_filial .And.;
                        stt->tt_ordem == sts->ts_ordem .And. stt->tt_plano == sts->ts_plano

                        If aScan(aTarefa, {|x| x[1] == STT->TT_TAREFA}) == 0
                           AAdd(aTarefa,{STT->TT_TAREFA,dtrealini,dtrealfim,hrealini,hrealfim,;
                                         ,dtprelini,dtprelfim,hrprlini,hrprlfim})
                        EndIf
                        Dbskip()
                        temtarefa := .t.
                     End
                  EndIf
                  
                  If temtarefa
                     For x := 1 To Len(aTarefa)
                         ZERADATA()
                         primzero  := .t.
                         primoutr  := .t.
                         DbSelectArea("STT")
                         DbSetOrder(01)
                         DbSeek(xFilial("STT")+STS->TS_ORDEM+STS->TS_PLANO+aTarefa[x][1])
                         While !Eof() .And. xFilial("STT") == stt->tt_filial .And.;
                            stt->tt_ordem == sts->ts_ordem .And. stt->tt_plano == sts->ts_plano .And.;
                            stt->tt_tarefa == aTarefa[x][1]
           
                            PROCHORINI(stt->tt_sequenc,stt->tt_dtinici,stt->tt_dtfim,;
                                       stt->tt_hoinici,stt->tt_hofim)
                            Dbskip()
                         End
                         aTarefa[x][2] := dtrealini
                         aTarefa[x][3] := dtrealfim
                         aTarefa[x][4] := hrealini
                         aTarefa[x][5] := hrealfim
                         aTarefa[x][6] := dtprelini
                         aTarefa[x][7] := dtprelfim
                         aTarefa[x][8] := hrprlini
                         aTarefa[x][9] := hrprlfim
                     Next x
                  EndIf
         
                  // PROCURA OS DETALHES DAS TAREFAS
                  For x := 1 To Len(aTarefa)
                      SOMALI006()
                      @li,007 Psay STR0040 //"Tarefa..:"
                      @li,017 Psay aTarefa[x][1]
                      If alltrim(aTarefa[x][1]) == "0"
                         @li,024 Psay STR0041 //"SEM ESPECIFICACAO DE TAREFA"
                      Else
                         DbSelectArea("ST5")
                         If DbSeek(xfilial("ST5")+sts->ts_codbem+sts->ts_servico+STR(sts->ts_sequenc,3)+aTarefa[x][1])
                            @li,024 Psay ST5->T5_DESCRIC
                         EndIf
                      EndIf
                      If MV_PAR17 == 1
                         @li,076 Psay STR0047 //"Exec.   P"
                         @li,088 Psay aTarefa[x][6]  Picture "99/99/9999"
                         @li,099 Psay aTarefa[x][8]  Picture "99:99"
                         @li,105 Psay aTarefa[x][7]  Picture "99/99/9999"
                         @li,116 Psay aTarefa[x][9]  Picture "99:99"
                         nHORA2 := HtoM(aTarefa[x][9]) - HtoM(aTarefa[x][8])
                         nDIA2  := aTarefa[x][7] - aTarefa[x][6]
                         cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                         @li,122 Psay ndia2 Picture "9999"
                         @li,127 Psay Substr(chora,1,2)
                         @li,130 Psay Substr(chora,4,2)
                         SOMALI006()
                         @li,076 Psay STR0048 //"Exec.   R"
                         @li,088 Psay aTarefa[x][2]  Picture "99/99/9999"
                         @li,099 Psay aTarefa[x][4]  Picture "99:99"
                         @li,105 Psay aTarefa[x][3]  Picture "99/99/9999"
                         @li,116 Psay aTarefa[x][5]  Picture "99:99"
                         nHORA2 := HtoM(aTarefa[x][5]) - HtoM(aTarefa[x][4])
                         nDIA2  := aTarefa[x][3] - aTarefa[x][2]
                         cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                         @li,122 Psay ndia2 Picture "9999"
                         @li,127 Psay Substr(chora,1,2)
                         @li,130 Psay Substr(chora,4,2)
                      Else
                         @li,076 Psay STR0048 //"Exec.   R"
                         @li,088 Psay aTarefa[x][2]  Picture "99/99/9999"
                         @li,099 Psay aTarefa[x][4]  Picture "99:99"
                         @li,105 Psay aTarefa[x][3]  Picture "99/99/9999"
                         @li,116 Psay aTarefa[x][5]  Picture "99:99"
                         nHORA2 := HtoM(aTarefa[x][5]) - HtoM(aTarefa[x][4])
                         nDIA2  := aTarefa[x][3] - aTarefa[x][2]
                         cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                         @li,122 Psay ndia2 Picture "9999"
                         @li,127 Psay Substr(chora,1,2)
                         @li,130 Psay Substr(chora,4,2)
                      EndIf

                      // IMPRIME OS PROBLEMAS DA TAREFA.
                      DbSelectArea("STV")
                      DbSetOrder(01)
                      DbSeek(xFilial("STV")+STS->TS_ORDEM+STS->TS_PLANO+aTarefa[x][1])
                      prim := .t.
                      While !Eof() .And. xFilial("STV") == stv->tv_filial .And.;
                         stv->tv_ordem == sts->ts_ordem .And. stv->tv_plano == sts->ts_plano .And.;
                         stv->tv_tarefa == aTarefa[x][1]

                         SOMALI006()
                         If prim
                            SOMALI006()
                            @li,010 Psay STR0042 //"Problema da Tarefa.:"
                            prim := .f.
                         EndIf
                         tipo     := Space(4)
                         nnome    := Space(29)
                         nproduto := Space(15)
                         POSINSUMO(STV->TV_TIPOREG,STV->TV_CODIGO,29)
                         @li,031 Psay tipo
                         @li,038 Psay nproduto
                         @li,053 Psay nnome
                         @li,084 Psay "-"
                         @li,087 Psay Substr(stv->tv_descric,1,36)
                         DbSelectArea("STV")
                         Dbskip()
                      End
                                  
                      // ETAPAS DA TAREFA
                      DbSelectArea("STX")
                      DbSetOrder(01)
                      lPRIMOPE := .T.
                      lOPCOES  := .F.
                      If DbSeek(xFilial("STX")+STS->TS_ORDEM+STS->TS_PLANO+aTarefa[x][1])
                         cEtapa := stx->tx_etapa
                         While !Eof() .And. xFilial("STX") == stx->tx_filial .And.;
                            stx->tx_ordem == sts->ts_ordem .And. stx->tx_plano == sts->ts_plano .And.;
                            aTarefa[x][1] == stx->tx_tarefa 
                                     
                            If stx->tx_etapa <> cEtapa
                               lPRIMOPE := .T.
                            EndIf   
                            If lPRIMOPE
                               
                               If lOPCOES
                                  SOMALI006()
                                  SOMALI006()
                               Else
                                  SOMALI006()
                               EndIf    
                               @li,017 Psay STR0043 //"Etapa..:"
                               If !Empty(stx->tx_ok)
                                  @li,026 Psay "R"
                               EndIf   
                               @li,029 Psay stx->tx_etapa
                               LPRIMOPE := .F.   
                               
                               DbSelectArea("TPA")
                               DbSetOrder(01)
                               If DbSeek(xFilial("TPA")+STX->TX_ETAPA)
                                  NGIMPMEMO(TPA->TPA_DESCRI,90,037,,.T.,.F.)
                               EndIf 
                            EndIf
                                           
                            //OPCOES DA ETAPA
                            lOPCOES := .F.
                            DbSelectArea("TPC")
                            DbSetOrder(01)
                            If DbSeek(xFilial("TPC")+STX->TX_ETAPA)
                               While !Eof() .And. TPC->TPC_FILIAL = Xfilial("TPC") .And.;
                                  TPC->TPC_ETAPA = STX->TX_ETAPA
                                  If !Empty(STX->TX_OK)
                                     DbSelectArea("TPX")
                                     DbSetOrder(01)
                                     If DbSeek(xFilial("TPX")+STX->TX_ORDEM+STX->TX_PLANO+STX->TX_TAREFA+TPC->TPC_ETAPA)
                                                      
                                        While !Eof() .And. TPX->TPX_FILIAL = Xfilial("TPX") .And.;
                                           TPX->TPX_ORDEM  = STX->TX_ORDEM                   .And.;
                                           TPX->TPX_PLANO  = STX->TX_PLANO                   .And.;
                                           TPX->TPX_TAREFA = STX->TX_TAREFA                  .And.;
                                           TPX->TPX_ETAPA  = TPC->TPC_ETAPA
                                                   
                                           If TPX->TPX_OPCAO = TPC->TPC_OPCAO 
                                              lOPCOES := .T.
                                              SOMALI006()
                                              @li,026 Psay STR0054 //"Opcao..:"
                                              @li,035 Psay TPX->TPX_OPCAO Picture '@!'
                                              If TPC->TPC_TIPRES = 'I'
                                                 @li,053 Psay STR0055 //"Informou....:"
                                                 @li,067 Psay TPX->TPX_RESPOS
                                                 @li,088 Psay STR0070 //"OS..:"
                                                 @li,094 Psay TPX->TPX_ORDEMG      
                                              Else
                                                 @li,053 Psay STR0056 //"Marcou......:"
                                                 @li,067 Psay STR0008 //"SIM"
                                              EndIf   
                                           EndIf
                                           DbSelectArea("TPX")
                                           Dbskip()
                                        End  
                                     EndIf
                                  EndIf   
                                  DbSelectArea("TPC")
                                  Dbskip()
                               End 
                            EndIf 
                            cEtapa := stx->tx_etapa
                            DbSelectArea("STX")
                            Dbskip()
                         End
                      EndIf
                                          
                      DbSelectArea("STT")
                      DbSetOrder(01)
                      If DbSeek(xFilial("STT")+STS->TS_ORDEM+STS->TS_PLANO+aTarefa[x][1])
                         While !Eof() .And. xFilial("STT") == stt->tt_filial .And.;
                            stt->tt_ordem  == sts->ts_ordem  .And.;
                            stt->tt_plano  == sts->ts_plano  .And.;
                            aTarefa[x][1]  == stt->tt_tarefa

                            If MV_PAR17 == 2 .And. stt->tt_sequenc = 0  // SO REAL
                               DbSelectArea("STT")
                               Dbskip()
                               Loop
                            EndIf
                            ntarefa  := stt->tt_tarefa
                            ntiporeg := stt->tt_tiporeg
                            tipo     := Space(4)
                            nnome    := Space(28)
                            nproduto := Space(15)
                            POSINSUMO(STT->TT_TIPOREG,STT->TT_CODIGO,28)
                            SOMALI006()
                            @li,017 Psay STR0059 //"Ins..:"
                            @li,024 Psay tipo
                            @li,029 Psay nproduto
                            @li,045 Psay nnome
                            DbSelectArea("STT")
                            nproduto := stt->tt_codigo
                            While !Eof() .And. xFilial("STT") == stt->tt_filial .And.;
                               stt->tt_ordem  == sts->ts_ordem   .And.;
                               stt->tt_plano  == sts->ts_plano   .And.;
                               ntarefa        == stt->tt_tarefa  .And.;
                               ntiporeg       == stt->tt_tiporeg .And.;
                               nproduto == stt->tt_codigo

                               SOMALI006()
                               @li,024 Psay STR0060 //"Sq:"
                               @li,028 Psay stt->tt_sequenc Picture "99"
                               @li,031 Psay STR0061 //"Qr:"
                               @li,035 Psay stt->tt_quanrec  Picture "999"
                               @li,039 Psay STR0062 //"Quan:"
                               @li,045 Psay stt->tt_quantid  Picture "@E 999,999.99"
                               @li,056 Psay STR0063 //"Un:"
                               @li,060 Psay stt->tt_unidade
                               @li,064 Psay STR0064 //"Dest:"
                               @li,070 Psay stt->tt_destino  Picture "@!S3"
                               If MV_PAR17 == 1   // PREVISTA e REAL
                                  @li,076 Psay STR0065  //"Exec."
                                  cTemGar := Space(1)
                                  cTemGar := If(STT->TT_GARANTI = "S",'*',cTemGar)
                                  @li,082 Psay cTemGar Picture "@!" 
                                  If stt->tt_sequenc = 0
                                     @li,084 Psay "P"
                                  Else
                                     @li,084 Psay "R"
                                  EndIf
                               Else  // REAL
                                  If stt->tt_sequenc = 0
                                     DbSelectArea("STT")
                                     Dbskip()
                                     Loop
                                  EndIf                 
                                  cTemGar := Space(1)
                                  cTemGar := If(STL->TL_GARANTI = "S",'*',cTemGar)
                                  @li,076 Psay STR0065 //"Exec."
                                  @li,082 Psay cTemGar Picture "@!" 
                                  @li,084 Psay "R"
                               EndIf
                               @li,088 Psay stt->tt_dtinici  Picture "99/99/9999"
                               @li,099 Psay stt->tt_hoinici  Picture "99:99"
                               @li,105 Psay stt->tt_dtfim    Picture "99/99/9999"
                               @li,116 Psay stt->tt_hofim    Picture "99:99"
                               If stt->tt_tiporeg <> "P"
                                  nHORA2 := HtoM(stt->tt_hofim) - HtoM(stt->tt_hoinici)
                                  nDIA2  := stt->tt_dtfim - stt->tt_dtinici
                                  cHora := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                                  @li,122 Psay ndia2 Picture "9999"
                                  @li,127 Psay Substr(chora,1,2)
                                  @li,130 Psay Substr(chora,4,2)
                               EndIf
                               //IMPRIME OBSERVACAO DO INSUMO
                               If MV_PAR18 = 1 
                                  LPRIMOPE := .F.
                                  NGIMPMEMO(STT->TT_OBSERVA,94,007,STR0038,.F.,.T.) //"Observacao.:"
                               EndIf
                               DbSelectArea("STT")
                               Dbskip()
                            End
                            SOMALI006()
                         End
                      EndIf
         
                      // PROCURA AS OCORRENCIAS
                      DbSelectArea("STU")
                      DbSetOrder(01)
                      If DbSeek(xFilial("STU")+STS->TS_ORDEM+STS->TS_PLANO+aTarefa[x][1])
                         While !Eof() .And. xFilial("STU") == stu->tu_filial .And.;
                            stu->tu_ordem  == sts->ts_ordem  .And.;
                            stu->tu_plano  == sts->ts_plano  .And.;
                            aTarefa[x][1]  == stu->tu_tarefa

                            IMPROCOR(STU->TU_CODOCOR,STU->TU_CAUSA,STU->TU_SOLUCAO,STU->TU_DESCRIC)
                            DbSelectArea("STU")
                            Dbskip()
                         End
                      EndIf
                  Next x
               EndIf
            Else
               DbSelectArea("STJ")
               DbSetOrder(01)
               If DbSeek(xFilial("STJ")+TRB->ORDEM+TRB->PLANO)
                  SOMALI006()
                  PROCORDEM(stj->tj_ordem,stj->tj_plano,stj->tj_servico,stj->tj_sequenc,;
                            stj->tj_dtppini,stj->tj_hoppini,stj->tj_dtppfim,stj->tj_hoppfim,;
                            stj->tj_dtprini,stj->tj_hoprini,stj->tj_dtprfim,stj->tj_hoprfim,;
                            stj->tj_dtmpini,stj->tj_hompini,stj->tj_dtmpfim,stj->tj_hompfim,;
                            stj->tj_dtmrini,stj->tj_homrini,stj->tj_dtmrfim,stj->tj_homrfim,;
                            stj->tj_poscont,stj->tj_poscon2)
                  
                  //LISTA OBSERVACAO DA O.S          
                  If MV_PAR16 = 1
                     LPRIMOPE := .F.
                     NGIMPMEMO(STJ->TJ_OBSERVA,94,007,STR0038,.F.,.T.) //"Observacao.:"
                  EndIf
                              
                  // MOTIVOS DO ATRASO DA O.S
                              
                  R006MOTAT()
                              
                  // IMPRIME OS PROBLEMA DA O.S.
                  DbSelectArea("STA")
                  DbSetOrder(01)
                  DbSeek(xFilial("STA")+STJ->TJ_ORDEM+STJ->TJ_PLANO+Space(06))
                  prim := .t.
                  While !Eof() .And. xFilial("STA") == sta->ta_filial .And.;
                     sta->ta_ordem  == stj->tj_ordem .And.;
                     sta->ta_plano  == stj->tj_plano .And.;
                     sta->ta_tarefa == Space(06)

                     SOMALI006()
                     If prim
                        SOMALI006()
                        @li,007 Psay STR0039 //"Problema da O.S..:"
                        prim := .f.
                     EndIf
                     nnome := Space(29)
                     PROCNOMBE(STA->TA_TIPOREG,STA->TA_CODIGO)
                     @li,076 Psay sta->ta_descric
                     DbSelectArea("STA")
                     Dbskip()
                  End
     
                  // IMPRIME A DESCRICAO DA MANUTENCAO
                  If MV_PAR15 = 1
                     LPRIMOPE := .F.   
                     DbSelectArea("STF")
                     DbSetOrder(01)
                     If DbSeek(xFilial("STF")+stj->tj_codbem+stj->tj_servico+str(stj->tj_sequenc,3))
                        NGIMPMEMO(STF->TF_DESCRIC,56,007,STR0037,.F.,.T.) //"Descricao..:"
                     EndIf   
                  EndIf
                  // PROCURA AS TAREFAS COM DATA E HORA DE INICIO E FIM
                  aTarefa   := {}
                  temtarefa := .f.
                  ZERADATA()
                  DbSelectArea("STL")
                  DbSetOrder(01)
                  If DbSeek(xFilial("STL")+STJ->TJ_ORDEM+STJ->TJ_PLANO)
                     While !Eof() .And. xFilial("STL") == stl->tl_filial .And.;
                        stl->tl_ordem == stj->tj_ordem  .And.;
                        stl->tl_plano == stj->tj_plano

                        If aScan(aTarefa, {|x| x[1] == STL->TL_TAREFA}) == 0
                           AAdd(aTarefa,{STL->TL_TAREFA,dtrealini,dtrealfim,hrealini,hrealfim,;
                                         ,dtprelini,dtprelfim,hrprlini,hrprlfim})
                        EndIf
                        Dbskip()
                        temtarefa := .t.
                     End
                  EndIf
                  If temtarefa
                     For x := 1 To Len(aTarefa)
                         ZERADATA()
                         primzero  := .t.
                         primoutr  := .t.
                         DbSelectArea("STL")
                         DbSetOrder(01)
                         DbSeek(xFilial("STL")+STJ->TJ_ORDEM+STJ->TJ_PLANO+aTarefa[x][1])
                         While !Eof() .And. xFilial("STL") == stl->tl_filial .And.;
                            stl->tl_ordem  == stj->tj_ordem  .And.;
                            stl->tl_plano  == stj->tj_plano  .And.;
                            stl->tl_tarefa == aTarefa[x][1]

                            PROCHORINI(stl->tl_sequenc,stl->tl_dtinici,stl->tl_dtfim,;
                                       stl->tl_hoinici,stl->tl_hofim)
                            Dbskip()
                         End
                         aTarefa[x][2] := dtrealini
                         aTarefa[x][3] := dtrealfim
                         aTarefa[x][4] := hrealini
                         aTarefa[x][5] := hrealfim
                         aTarefa[x][6] := dtprelini
                         aTarefa[x][7] := dtprelfim
                         aTarefa[x][8] := hrprlini
                         aTarefa[x][9] := hrprlfim
                     Next x
                  EndIf
   
                  // PROCURA OS DETALHES DAS TAREFAS
                  For x := 1 To Len(aTarefa)
                      SOMALI006()
                      @li,007 Psay STR0040 //"Tarefa..:"
                      @li,017 Psay aTarefa[x][1]
                      If alltrim(aTarefa[x][1]) == "0"
                         @li,024 Psay STR0041 //"SEM ESPECIFICACAO DE TAREFA"
                      Else
                         DbSelectArea("ST5")
                         If DbSeek(xfilial("ST5")+stj->tj_codbem+stj->tj_servico+STR(stj->tj_sequenc,3)+aTarefa[x][1])
                            @li,024 Psay ST5->T5_DESCRIC
                         EndIf
                      EndIf
                      If MV_PAR17 == 1
                         @li,076 Psay STR0047 //"Exec.   P"
                         @li,088 Psay aTarefa[x][6]  Picture "99/99/9999"
                         @li,099 Psay aTarefa[x][8]  Picture "99:99"
                         @li,105 Psay aTarefa[x][7]  Picture "99/99/9999"
                         @li,116 Psay aTarefa[x][9]  Picture "99:99"
                         nHORA2 := HtoM(aTarefa[x][9]) - HtoM(aTarefa[x][8])
                         nDIA2  := aTarefa[x][7] - aTarefa[x][6]
                         cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                         @li,122 Psay ndia2 Picture "9999"
                         @li,127 Psay Substr(chora,1,2)
                         @li,130 Psay Substr(chora,4,2)
                         SOMALI006()
                         @li,076 Psay STR0048 //"Exec.   R"
                         @li,088 Psay aTarefa[x][2]  Picture "99/99/9999"
                         @li,099 Psay aTarefa[x][4]  Picture "99:99"
                         @li,105 Psay aTarefa[x][3]  Picture "99/99/9999"
                         @li,116 Psay aTarefa[x][5]  Picture "99:99"
                         nHORA2 := HtoM(aTarefa[x][5]) - HtoM(aTarefa[x][4])
                         nDIA2  := aTarefa[x][3] - aTarefa[x][2]
                         cHora := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                         @li,122 Psay ndia2 Picture "9999"
                         @li,127 Psay Substr(chora,1,2)
                         @li,130 Psay Substr(chora,4,2)
                      Else
                         @li,076 Psay STR0048 //"Exec.   R"
                         @li,088 Psay aTarefa[x][2]  Picture "99/99/9999"
                         @li,099 Psay aTarefa[x][4]  Picture "99:99"
                         @li,105 Psay aTarefa[x][3]  Picture "99/99/9999"
                         @li,116 Psay aTarefa[x][5]  Picture "99:99"
                         nHORA2 := HtoM(aTarefa[x][5]) - HtoM(aTarefa[x][4])
                         nDIA2  := aTarefa[x][3] - aTarefa[x][2]
                         cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                         @li,122 Psay ndia2 Picture "9999"
                         @li,127 Psay Substr(chora,1,2)
                         @li,130 Psay Substr(chora,4,2)
                      EndIf

                      // IMPRIME OS PROBLEMAS DA TAREFA.
                      DbSelectArea("STA")
                      DbSetOrder(01)
                      DbSeek(xFilial("STA")+STJ->TJ_ORDEM+STJ->TJ_PLANO+aTarefa[x][1])
                      prim := .t.
                      While !Eof() .And. xFilial("STA") == sta->ta_filial .And.;
                         sta->ta_ordem  == stj->tj_ordem .And.;
                         sta->ta_plano  == stj->tj_plano .And.;
                         sta->ta_tarefa == aTarefa[x][1]

                         SOMALI006()
                         If prim
                            SOMALI006()
                            @li,010 Psay STR0042 //"Problema da Tarefa.:"
                            prim := .f.
                         EndIf
                         nnome    := Space(29)
                         tipo     := Space(4)
                         nproduto := Space(15)
                         POSINSUMO(STA->TA_TIPOREG,STA->TA_CODIGO,29)
                         @li,031 Psay tipo
                         @li,038 Psay nproduto
                         @li,053 Psay nnome
                         @li,084 Psay "-"
                         @li,087 Psay Substr(sta->ta_descric,1,36)
                         DbSelectArea("STA")
                         Dbskip()
                      End

                      // ETAPAS DA TAREFA
                      DbSelectArea("STQ")
                      DbSetOrder(01) 
                      lPrimeta := .T.
                      lOPCOES  := .F.
                      If DbSeek(xFilial("STQ")+STJ->TJ_ORDEM+STJ->TJ_PLANO+aTarefa[x][1])
                         cEtapa1 := stq->tq_etapa
                         While !Eof() .And. xFilial("STQ") == stq->tq_filial .And.;
                            stq->tq_ordem == stj->tj_ordem .And.;
                            stq->tq_plano == stj->tj_plano .And.;
                            aTarefa[x][1] == stq->tq_tarefa
                                           
                            If stq->tq_etapa <> cEtapa1
                               lPRIMETA := .T.
                            EndIf    
                            If lPRIMETA 
                            
                               If lOPCOES
                                  SOMALI006()
                                  SOMALI006()
                               Else
                                  SOMALI006()
                               EndIf    
                               @li,017 Psay STR0043 //"Etapa..:"
                               If !Empty(stq->tq_ok)
                                  @li,026 Psay "R"
                               EndIf 
                               @li,029 Psay stq->tq_etapa
                               
                               lPRIMETA := .F.              
                               DbSelectArea("TPA")
                               DbSetOrder(01)
                               If DbSeek(xFilial("TPA")+STQ->TQ_ETAPA)
                                  NGIMPMEMO(TPA->TPA_DESCRI,90,037,,.T.,.F.) 
                               EndIf
                            EndIf
                                       
                            //OPCOES DA ETAPA  
                            lOPCOES := .F.
                            DbSelectArea("TPC")
                            DbSetOrder(01)
                            If DbSeek(xFilial("TPC")+STQ->TQ_ETAPA)
                               While !Eof() .And. TPC->TPC_FILIAL = Xfilial("TPC") .And.;
                                  TPC->TPC_ETAPA = STQ->TQ_ETAPA
                                              
                                  If !Empty(stq->tq_ok)
                                     DbSelectArea("TPQ")
                                     DbSetOrder(01)
                                     If DbSeek(xFilial("TPQ")+STQ->TQ_ORDEM+STQ->TQ_PLANO+STQ->TQ_TAREFA+TPC->TPC_ETAPA)
                                                                          
                                        While !Eof() .And. TPQ->TPQ_FILIAL = Xfilial("TPQ") .And.;
                                           TPQ->TPQ_ORDEM  = STQ->TQ_ORDEM                   .And.;
                                           TPQ->TPQ_PLANO  = STQ->TQ_PLANO                   .And.;
                                           TPQ->TPQ_TAREFA = STQ->TQ_TAREFA                  .And.;
                                           TPQ->TPQ_ETAPA  = TPC->TPC_ETAPA
                                                   
                                           If TPQ->TPQ_OPCAO = TPC->TPC_OPCAO
                                              lOPCOES := .T. 
                                              SOMALI006()
                                              @li,026 Psay STR0054  //"Opcao..:"
                                              @li,035 Psay TPQ->TPQ_OPCAO Picture '@!'
                                              If TPC->TPC_TIPRES = 'I'
                                                 @li,053 Psay STR0055 //"Informou....:"
                                                 @li,067 Psay TPQ->TPQ_RESPOS
                                                 @li,088 Psay STR0070//"OS..:"
                                                 @li,094 Psay TPQ->TPQ_ORDEMG      
                                              Else
                                                 @li,053 Psay STR0056 //"Marcou......:"
                                                 @li,067 Psay STR0008 //"SIM"
                                              EndIf   
                                           EndIf
                                           DbSelectArea("TPQ")
                                           Dbskip()
                                        End  
                                     EndIf
                                  EndIf   
                                  DbSelectArea("TPC")
                                  Dbskip()
                               End 
                            EndIf 
                            cEtapa1 := stq->tq_etapa
                            DbSelectArea("STQ")
                            Dbskip()
                         End
                      EndIf
                                       
                      DbSelectArea("STL")
                      DbSetOrder(01)
                      If DbSeek(xFilial("STL")+STJ->TJ_ORDEM+STJ->TJ_PLANO+aTarefa[x][1])
                         SOMALI006()
                         While !Eof() .And. xFilial("STL") == stl->tl_filial .And.;
                            stl->tl_ordem  == stj->tj_ordem  .And.;
                            stl->tl_plano  == stj->tj_plano  .And.;
                            aTarefa[x][1]  == stl->tl_tarefa
                                   
                            If MV_PAR17 == 2 .And. stl->tl_sequenc = 0  // SO REAL
                               DbSelectArea("STL")
                               Dbskip()
                               Loop
                            EndIf
                            ntarefa  := stl->tl_tarefa
                            ntiporeg := stl->tl_tiporeg
                            tipo     := Space(4)
                            nnome    := Space(28)
                            nproduto := Space(15)
                            POSINSUMO(STL->TL_TIPOREG,STL->TL_CODIGO,28)
                            SOMALI006()
                            @li,017 Psay STR0059 //"Ins..:"
                            @li,024 Psay tipo
                            @li,029 Psay nproduto
                            @li,045 Psay nnome
                            DbSelectArea("STL")
                            nproduto := stl->tl_codigo
                            While !Eof() .And. xFilial("STL") == stl->tl_filial .And.;
                               stl->tl_ordem == stj->tj_ordem   .And.;
                               stl->tl_plano == stj->tj_plano   .And.;
                               ntarefa       == stl->tl_tarefa  .And.;
                               ntiporeg      == stl->tl_tiporeg .And.;
                               nproduto      == stl->tl_codigo
                                                
                               SOMALI006()
                               @li,024 Psay STR0060 //"Sq:"
                               @li,028 Psay stl->tl_sequenc Picture "99"
                               @li,031 Psay STR0061 //"Qr:"
                               @li,035 Psay stl->tl_quanrec  Picture "999"
                               @li,039 Psay STR0062 //"Quan:"
                               @li,045 Psay stl->tl_quantid  Picture "@E 999,999.99"
                               @li,056 Psay STR0063 //"Un:"
                               @li,060 Psay stl->tl_unidade
                               @li,064 Psay STR0064 //"Dest:"
                               @li,070 Psay stl->tl_destino  Picture "@!S3"
                               If MV_PAR17 == 1   // PREVISTA e REAL
                                  @li,076 Psay STR0065 //"Exec."
                                  cTemGar := Space(1)
                                  cTemGar := If(STL->TL_GARANTI = "S",'*',cTemGar)
                                  @li,082 Psay cTemGar Picture "@!" 
                                  If stl->tl_sequenc = 0
                                     @li,084 Psay "P"
                                  Else
                                     @li,084 Psay "R"
                                  EndIf
                               Else  // REAL
                                  If stl->tl_sequenc = 0
                                     DbSelectArea("STL")
                                     Dbskip()
                                     Loop
                                  EndIf
                                  cTemGar := Space(1)
                                  cTemGar := if(STL->TL_GARANTI = "S",'*',cTemGar)
                                  @li,076 Psay STR0065 //"Exec."
                                  @li,082 Psay cTemGar Picture "@!" 
                                  @li,084 Psay "R"
                               EndIf
                               @li,088 Psay stl->tl_dtinici  Picture "99/99/9999"
                               @li,099 Psay stl->tl_hoinici  Picture "99:99"
                               @li,105 Psay stl->tl_dtfim    Picture "99/99/9999"
                               @li,116 Psay stl->tl_hofim    Picture "99:99"
                               If stl->tl_tiporeg <> "P"
                                  nHORA2 := HtoM(stl->tl_hofim) - HtoM(stl->tl_hoinici)
                                  nDIA2  := stl->tl_dtfim - stl->tl_dtinici
                                  cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
                                  @li,122 Psay ndia2 Picture "9999"
                                  @li,127 Psay Substr(chora,1,2)
                                  @li,130 Psay Substr(chora,4,2)
                               EndIf
                               //IMPRIME OBSERVACAO DO INSUMO
                               If MV_PAR18 = 1 
                                  LPRIMOPE := .F.
                                  NGIMPMEMO(STL->TL_OBSERVA,94,007,STR0038,.F.,.T.) //"Observacao.:"
                               EndIf
                               DbSelectArea("STL")
                               Dbskip()
                            End
                            SOMALI006()
                         End
                      EndIf
          
                       // PROCURA AS OCORRENCIAS
                       DbSelectArea("STN")
                       DbSetOrder(01)
                       If DbSeek(xFilial("STN")+STJ->TJ_ORDEM+STJ->TJ_PLANO+aTarefa[x][1])
                          While !Eof() .And. xFilial("STN") == stn->tn_filial .And.;
                             stn->tn_ordem == stj->tj_ordem .And.;
                             stn->tn_plano == stj->tj_plano .And.;
                             aTarefa[x][1] == stn->tn_tarefa

                             IMPROCOR(STN->TN_CODOCOR,STN->TN_CAUSA,STN->TN_SOLUCAO,STN->TN_DESCRIC)
                             DbSelectArea("STN")
                             Dbskip()
                          End
                       EndIf
                  Next x
               EndIf
            EndIf
            SOMALI006()
            @Li,000 Psay Replicate("-",132)
            DbSelectArea("TRB")
            Dbskip()
         End
      End
   End
End

Roda(nCntImpr,cRodaTxt,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("ST9")
RetIndex("ST6")
RetIndex("SA2")
RetIndex("ST7")
RetIndex("STF")
RetIndex("ST4")
Set Filter To
Set device to Screen
If aReturn[5] = 1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
EndIf
MS_FLUSH()

DbSelectArea("TRB")
USE
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GRAVAR006³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava arquivo auxiliar                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GRAVAR006(cCCUSTO,cCENTRAB,cORDEM,cPLANO,cCODBEM,cARQ)

TRB->(DbAppend())
TRB->CUSTO    := cCCUSTO
TRB->TRABALHO := cCENTRAB
TRB->ORDEM    := cORDEM
TRB->PLANO    := cPLANO
TRB->BEM      := cCODBEM
TRB->ARQUIVO  := cARQ
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ SOMALI006³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha e Controla Salto de Pagina                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function SOMALI006()
Li++
If Li > 58
   Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
   //Li--
   SOMALI006()
   @Li,000 Psay Replicate("*",132)
   Li++
EndIf
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CABECOS  ³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha e Controla Salto de Pagina                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function cabecos()
SOMALI006()
@LI,000 Psay STR0044 // "O.S.   Plano  Serv.  Seq. Nome Servico                Contado 1  Contador 2 Evento P/R  .....Inicio..... ......Fim.......   DD-HH-MM"
return  .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PROCORDEM³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa as O.S. atuais e historico                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PROCORDEM(cordem,cplano,cservico,csequenc,;
                   ddtppini,choppini,ddtppfim,choppfim,;
                   ddtprini,choprini,ddtprfim,choprfim,;
                   ddtmpini,chompini,ddtmpfim,chompfim,;
                   ddtmrini,chomrini,ddtmrfim,chomrfim,;
                   npos1,npos2)

@li,000 Psay cordem
@li,007 Psay cplano
@li,014 Psay cservico               
@li,022 Psay csequenc Picture '999'
DbSelectArea("ST4")
DbSetOrder(01)
If DbSeek(xFilial("ST4")+cservico)
   @li,026 Psay Substr(st4->t4_nome,1,25)
EndIf
@li,052 Psay npos1 Picture '@E 999,999,999' 
@li,064 Psay npos2 Picture '@E 999,999,999' 
If MV_PAR17 = 1  // PARADAS PREVISTA E REALIZADA
   @li,076 Psay STR0045 //"Parada  P"
   @li,088 Psay ddtppini Picture "99/99/9999"
   @li,099 Psay choppini Picture "99:99"
   @li,105 Psay ddtppfim Picture "99/99/9999"
   @li,116 Psay choppfim Picture "99:99"
   nHORA1 := HtoM(choppfim) - HtoM(choppini)
   nDIA1  := ddtppfim - ddtppini
   cHora  := If(nHORA1 > 0,MtoH(nHORA1), "00:00")
   @li,122 Psay ndia1 Picture "9999"
   @li,127 Psay Substr(chora,1,2)
   @li,130 Psay Substr(chora,4,2)
   SOMALI006()
   @li,076 Psay STR0046 //"Parada  R"
   @li,088 Psay ddtprini Picture "99/99/9999"
   @li,099 Psay choprini Picture "99:99"
   @li,105 Psay ddtprfim Picture "99/99/9999"
   @li,116 Psay choprfim Picture "99:99"
   nHORA2 := HtoM(choprfim) - HtoM(choprini)
   nDIA2  := ddtprfim - ddtprini
   cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
   nAtrD  := ddtprfim - ddtprini
   nAtrH  := HtoM(choprfim) - HtoM(choprini)
   @li,122 Psay ndia2 Picture "9999"
   @li,127 Psay Substr(chora,1,2)
   @li,130 Psay Substr(chora,4,2)
   SOMALI006()
   @li,076 Psay STR0047 //"Exec.   P"
   @li,088 Psay ddtmpini Picture "99/99/9999"
   @li,099 Psay chompini Picture "99:99"
   @li,105 Psay ddtmpfim Picture "99/99/9999"
   @li,116 Psay chompfim Picture "99:99"
   nHORA1 := HtoM(chompfim) - HtoM(chompini)
   nDIA1  := ddtmpfim - ddtmpini
   cHora  := If(nHORA1 > 0,MtoH(nHORA1), "00:00")
   @li,122 Psay ndia1 Picture "9999"
   @li,127 Psay Substr(chora,1,2)
   @li,130 Psay Substr(chora,4,2)
   SOMALI006()
   @li,076 Psay STR0048 //"Exec.   R"
   @li,088 Psay ddtmrini Picture "99/99/9999"
   @li,099 Psay chomrini Picture "99:99"
   @li,105 Psay ddtmrfim Picture "99/99/9999"
   @li,116 Psay chomrfim Picture "99:99"
   nHORA2 := HtoM(chomrfim) - HtoM(chomrini)
   nDIA2  := ddtmrfim - ddtmrini
   cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
   @li,122 Psay ndia2 Picture "9999"
   @li,127 Psay Substr(chora,1,2)
   @li,130 Psay Substr(chora,4,2)
Else // SO PARADA REAL
   @li,076 Psay STR0046 //"Parada  R"
   @li,088 Psay ddtprini Picture "99/99/9999"
   @li,099 Psay choprini Picture "99:99"
   @li,105 Psay ddtprfim Picture "99/99/9999"
   @li,116 Psay choprfim Picture "99:99"
   nHORA2 := HtoM(choprfim) - HtoM(choprini)
   nDIA2  := ddtprfim - ddtprini
   cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
   @li,122 Psay ndia2 Picture "9999"
   @li,127 Psay Substr(chora,1,2)
   @li,130 Psay Substr(chora,4,2)
   SOMALI006()
   @li,076 Psay STR0048 //"Exec.   R"
   @li,088 Psay ddtmrini Picture "99/99/9999"
   @li,099 Psay chomrini Picture "99:99"
   @li,105 Psay ddtmrfim Picture "99/99/9999"
   @li,116 Psay chomrfim Picture "99:99"
   nHORA2 := HtoM(chomrfim) - HtoM(chomrini)
   nDIA2  := ddtmrfim - ddtmrini
   cHora  := If(nHORA2 > 0,MtoH(nHORA2), "00:00")
   @li,122 Psay ndia2 Picture "9999"
   @li,127 Psay Substr(chora,1,2)
   @li,130 Psay Substr(chora,4,2)
EndIf

Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ POSINSUMO³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Procura o nome do insumo                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function POSINSUMO(cTIPOREG,cCODIGO,nTAM)

If cTIPOREG = "P"          // PRODUTOS
   nproduto := cCODIGO
   tipo     := STR0066 //"Prod"
   calias   := "SB1"
ElseIf cTIPOREG = "M"   // FUNCIONARIO
   nproduto := Substr(cCODIGO,1,6)
   tipo     := STR0067 //"Func"
   calias   := "ST1"
ElseIf cTIPOREG = "F"   // FERRAMENTAS
   nproduto := Substr(cCODIGO,1,6)
   tipo     := STR0068 //"Ferr"
   calias   := "SH4"
Else                     // TERCEIROS
   nproduto := Substr(cCODIGO,1,6)
   tipo     := STR0069 //"Terc"
   calias   := "SA2"
EndIf

DbSelectArea(calias)
DbSetOrder(01)
If DbSeek(xFilial(calias)+nproduto)
   If cTIPOREG = "P"
      nnome  := left(sb1->b1_desc,nTAM)
   ElseIf cTIPOREG = "M"   // FUNCIONARIO
      nnome  := left(st1->t1_nome,nTAM)
   ElseIf cTIPOREG = "F"   // FERRAMENTAS
      nnome := left(sh4->h4_DESCRI,nTAM)
   Else                     // TERCEIROS
      nnome := left(sa2->a2_nome,nTAM)
   EndIf
EndIf
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PROCNOMBE³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Procura o nome do bem ou especialidade                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PROCNOMBE(cTIPOREG,cCODIGO)

If ctiporeg == "B"
   tipo     := STR0049 //"Bem"
   nproduto := Substr(ccodigo,1,6)
   DbSelectArea("ST9")
   DbSetOrder(01)
   If DbSeek(xFilial("ST9")+nproduto)
      nnome := left(st9->t9_nome,29)
   EndIf
ElseIf ctiporeg == "E"
   nproduto := Substr(ccodigo,1,3)
   tipo     := STR0050 //"Espec."
   DbSelectArea("ST0")
   DbSetOrder(01)
   If DbSeek(xFilial("ST0")+nproduto)
      nnome  := left(st0->t0_nome,29)
   EndIf
EndIf

@li,027 Psay tipo
@li,034 Psay nproduto
@li,041 Psay nnome
@li,073 Psay "-"
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ZERADATA ³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Limpa as variaveis de data e hora                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ZERADATA()

dtrealini  := CtoD("  /  /    ")
dtrealfim  := CtoD("  /  /    ")
hrealini   := Space(05)
hrealfim   := Space(05)
dtprelini  := CtoD("  /  /    ")
dtprelfim  := CtoD("  /  /    ")
hrprlini   := Space(05)
hrprlfim   := Space(05)
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ IMPROCOR ³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime as ocorrencias                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IMPROCOR(cCODOCOR,cCAUSA,cSOLUCAO,cDESCRIC)

SOMALI006()
@li,017 Psay STR0051 //"Ocorr:"
@li,024 Psay cCODOCOR

// PROCURA DESCRICAO DA OCORRENCIAS
DbSelectArea("ST8")
DbSetOrder(01)
If DbSeek(xFilial("ST8")+cCODOCOR)
   @li,031 Psay st8->t8_nome
EndIf
SOMALI006()
@li,017 Psay STR0052 //"Causa:"
@li,024 Psay cCAUSA
If DbSeek(xFilial("ST8")+cCAUSA)
   @li,031 Psay st8->t8_nome
EndIf
SOMALI006()
@li,017 Psay STR0053 //"Saluc:"
@li,024 Psay cSOLUCAO
If DbSeek(xFilial("ST8")+cSOLUCAO)
   @li,031 Psay st8->t8_nome
EndIf
LPRIMOPE := .F.
NGIMPMEMO(cDESCRIC,56,017,STR0037,.T.,.T.) //"Descricao..:"
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PROCHORINI³ Autor ³ Inacio Luiz Kolling   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica a data e hora inicio e fim                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PROCHORINI(nsequenc,ddtinic,ddtfim,choinici,chofim)

If nsequenc = 0
   //  VERIFICA QUAL E A DATA PREVISTA DE INICIO, DATA FIM, HORA INCIO, HORA FIM DA TAREFA
   If primzero
      dtprelini := ddtinic
      dtprelfim := ddtfim
      hrprlini  := choinici
      hrprlfim  := chofim
      primzero  := .f.
   Else
      If (ddtinic < dtprelini)
         dtprelini := ddtinic
         hrprlini  := choinici
      ElseIf ddtinic = dtprelini .And. choinici < hrprlini
         hrprlini  := choinici
      EndIf
      If ddtfim > dtprelfim
         dtprelfim := ddtfim
         hrprlfim  := chofim
      ElseIf ddtfim = dtprelfim .And. chofim > hrprlfim
         hrprlfim  := chofim
      EndIf
   EndIf
Else
   // VERIFICA QUAL E A DATA REAL DE INICIO, DATA FIM, HORA INCIO, HORA FIM DA TAREFA
   If primoutr
      dtrealini := ddtinic
      dtrealfim := ddtfim
      hrealini  := choinici
      hrealfim  := chofim
      primoutr  := .f.
   Else
      If (ddtinic < dtrealini)
         dtprelini := ddtinic
         hrealini  := choinici
      ElseIf ddtinic = dtrealini .And. choinici < hrealini
         hrealini  := choinici
      EndIf
      If ddtfim > dtrealfim
         dtrealfim := ddtfim
         hrealfim  := chofim
      ElseIf ddtfim = dtrealfim .And. chofim > hrealfim
         hrealfim  := chofim
      EndIf
   EndIf
EndIf
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R006MOTAT ³ Autor ³Elisangela Costa       ³ Data ³ 25/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime os motivos de atraso da O.S                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R006MOTAT()

DbSelectArea("TPL")
DbSetOrder(02)
If DbSeek(xFilial("TPL")+TRB->ORDEM)
   SOMALI006()
   SOMALI006()
   @LI,007 Psay STR0057 //"Motivo do Atraso da  O.S..:  Motivo Descricao                                   .....Inicio..... ......Fim......."
   While !Eof() .And. xfilial("TPL") = TPL->TPL_Filial .And. TPL->TPL_ORDEM = TRB->ORDEM
      SOMALI006()
      @LI,036 Psay TPL->TPL_CODMOT Picture '@!'
      DbSelectArea("TPJ")
      DbSetOrder(01)
      If DbSeek(xFilial("TPJ")+TPL->TPL_CODMOT)
         @LI,043 Psay TPJ->TPJ_DESMOT Picture '@!'
      EndIf   
      @li,087 Psay TPL->TPL_DTINIC Picture '99/99/99'
      @li,098 Psay TPL->TPL_HOINIC Picture '99:99'
      @li,104 Psay TPL->TPL_DTFIM  Picture '99/99/99'            
      @li,115 Psay TPL->TPL_HOFIM  Picture '99:99'
      DbSelectArea("TPL")
      Dbskip()
   End
   SOMALI006()    
EndIf    
                                         
Return .T.
