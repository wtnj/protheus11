/*
Programa        : FLWPROC.PRW
Objetivo        : Impressao do Follow-up em fase de processo
Autor           : Cristiano A. Ferreira
Data/Hora       : 14/08/1999 14:35
Obs.            :
*/

//definicao de situacao de processos apresentado em ordem de uso
#define ST_PC  "*"     //processo/embarque cancelado
#define ST_CL  "3"     //credito liberado

// *** Variaveis usadas no FLWPROC.PRW *** \\
nOrdEE7 := EE7->(IndexOrd())
cSeqRel := nil
cFileRpt:= "FW0001"
nTipo := nil ; dDataIni := nil ; dDataFim := nil
// *** \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ *** \\

EE7->(dbSetOrder(2)) // FILIAL+DATA SOLIC.CREDITO+DATA APROV.CREDITO

While .T.
   mv_ch1 := 1
      
   IF ! Pergunte("FW0001",.T.)
      Exit
   Endif
   
   // Alterado por Heder M Oliveira - 8/13/1999
   
   // Variaveis definidas na Pergunte
   // nTipo    := 1-Sem Solicitacao de Credito
   //             2-Aguardando Aprovacao de Credito
   //             3-Credito Liberado
   // dDataIni := Data Inicial 
   // dDataFim := Data Final
   
   nTipo    := mv_par01
   dDataIni := mv_par02
   dDataFim := mv_par03
      
   IF nTipo == 1 // Sem Solicitacao de Credito
      EE7->(dbSeek(xFilial("EE7")))
   Elseif nTipo == 2 .or. nTIPO== 3
      // Procura a primeira data de Solicitacao de Credito preenchida.
      EE7->(dbSeek(xFilial("EE7")+dtos(ctod('01/01/1900')),.T.))
   Else
      MsgStop("Tipo de Relatório inválido !","Aviso")
      Loop
   Endif
   
   While EE7->(!Eof()) .And. EE7->EE7_FILIAL == xFilial("EE7")
      SysRefresh()
      
      IF nTipo == 1 // Sem sol. de Credito
         IF !Empty(EE7->EE7_DTSLCR)
            Exit
         Endif
      ELSEIF nTIPO == 2 .or. nTIPO == 3
                       
         IF Empty(EE7->EE7_DTSLCR)
            Exit
         Endif
         
         IF ( nTIPO==2  ) //ag.aprov.credito
            IF !Empty(EE7->EE7_DTAPCR)
               EE7->(dbSkip())
               Loop
            Endif
         ELSE
            IF ( EE7->EE7_STATUS#ST_CL )  //credito liberado
               EE7->(DBSKIP(1))
               LOOP
            ENDIF
         ENDIF
      Endif
      
      IF EE7->EE7_STATUS == ST_PC // Cancelado
         EE7->(dbSkip())
         Loop
      Endif
      
      IF !Empty(dDataIni)
         IF dDataIni > EE7->EE7_DTPROC
            EE7->(dbSkip())
            Loop
         Endif
      Endif
      
      IF !Empty(dDataFim)
         IF dDataFim < EE7->EE7_DTPROC
            EE7->(dbSkip())
            Loop
         Endif
      Endif

      IF Empty(cSeqRel)
         cSeqRel := GETSX8NUM("SY0","Y0_SEQREL")
         ConfirmSX8()
      Endif
      
      HEADER_P->(dbAppend())
      HEADER_P->AVG_CHAVE  := EE7->EE7_PEDIDO
      HEADER_P->AVG_SEQREL := cSeqRel
      HEADER_P->AVG_D01_08 := EE7->EE7_DTPROC
      HEADER_P->AVG_D02_08 := EE7->EE7_DTPEDI
      HEADER_P->AVG_C01_60 := AllTrim(EE7->EE7_IMPORT)+" "+EE7->EE7_IMPODE
      HEADER_P->AVG_C02_60 := AllTrim(EE7->EE7_CLIENT)+" "+BuscaCliente(EE7->EE7_CLIENT,.T.)
      HEADER_P->AVG_C03_60 := AllTrim(EE7->EE7_FORN)+" "+BuscaFabr_Forn(EE7->EE7_FORN)
      HEADER_P->AVG_C04_60 := AllTrim(EE7->EE7_EXPORT)+" "+BuscaFabr_Forn(EE7->EE7_EXPORT)
      HEADER_P->AVG_C05_60 := AllTrim(EE7->EE7_CONSIG)+" "+BuscaCliente(EE7->EE7_CONSIG,.T.)
      HEADER_P->AVG_C06_60 := AllTrim(EE7->EE7_BENEF)+" "+EE7->EE7_BENEDE
      HEADER_P->AVG_C01_10 := Str(nTipo,1)
      HEADER_P->(dbUnlock())
      
      EE7->(dbSkip())
   Enddo                         
                          
   IF Empty(cSeqRel)
      HELP(" ",1,"AVG0000063")
      Loop
   Endif

   HEADER_P->(dbCommit())
   
   
   AvgCrw32(cFileRpt,"Follow-up em Fase de Processo",cSeqRel)

   Exit
Enddo

EE7->(dbSetOrder(nOrdEE7))

__Return(NIL)

