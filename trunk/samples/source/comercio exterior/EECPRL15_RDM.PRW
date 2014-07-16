#INCLUDE "EECPRL15.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "EECRDM.CH"
#INCLUDE "RWMAKE.CH"
/*                                                                             
Funcao      : EECPRL15().
Parametros  : Nenhum.
Retorno     : .F.
Objetivos   : Follow-up de Cambio.
Autor       : Jeferson Barros Jr.
Data/Hora   : 10/08/2001 - 8:42.
Obs.        : Arquivo - REL15.RPT.
Revisao     : 
*/

*-----------------------------------*
User Function EECPRL15()
*-----------------------------------*

Local nOldArea := ALIAS()
Local lRet     := .f.
Local aOrd     := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})

Private aArqs,;
      cNomDbfC := "R28001C",;
      aCamposC := {{"SEQREL    ","C",08,0},;
                   {"IMPORT    ","C",60,0},;
                   {"TITULO    ","C",100,0},;
                   {"PERIODO   ","C",100,0}},;
      cNomDbfD := "R28001D",;
      aCamposD := {{"SEQREL    ","C", 8,0},;
                   {"PROCESSO  ","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;   
                   {"DTPROCESSO","C",10,0},;   
                   {"DTVENC    ","C",10,0},;
                   {"DTPGT     ","C",10,0},;
                   {"IMPODE    ","C",60,0},;
                   {"VALORNFS  ","N",AVSX3("EEM_VLNF"  ,AV_TAMANHO),AVSX3("EEM_VLNF"  ,AV_DECIMAL)},;
                   {"VALORUSS  ","N",AVSX3("EEC_TOTPED",AV_TAMANHO),AVSX3("EEC_TOTPED",AV_DECIMAL)},;
                   {"TXCAMBIO  ","N",AVSX3("EEQ_TX"    ,AV_TAMANHO),AVSX3("EEQ_TX"    ,AV_DECIMAL)},;
                   {"VALORRS   ","N",AVSX3("EEQ_TX"    ,AV_TAMANHO),AVSX3("EEQ_TX"    ,AV_DECIMAL)},;
                   {"BANCO     ","C",50,0},;
                   {"FLAG      ","C",01,0}}

Private dDtIni    := AVCTOD("  /  /  ")
Private dDtFim    := AVCTOD("  /  /  ")
Private cImport   := Space(AVSX3("A1_COD",3))
Private cArqRpt, cTitRpt
Private aRadio := {STR0002,STR0003,STR0004,STR0005} //"A Vencer - Embarcado"###"A Vencer - Previsão de Emb."###"A Vencer - Ambos"###"Recebidos "
Private nRadio := 1
Private aCombo := {STR0006,STR0007} //"Sim"###"Nao"
Private cCombo := aCombo[2]
Private lZero  := .T.
Private lNovo  := .F.
Private cFile
Private cAlias

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := "REL15.RPT"
      cTitRpt := STR0008 //"Follow-up de Cambio"
   Endif

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   aARQS := {}
   AADD(aARQS,{cNOMDBFC,aCAMPOSC,"CAB","SEQREL"})
   AADD(aARQS,{cNOMDBFD,aCAMPOSD,"DET","SEQREL"})

   aRetCrw := CrwNewFilee(aARQS)   

   IF nRadio = 2 .Or. nRadio = 3 // A Vencer - Previsão de Emb. ou Ambos
      cAlias := "QRY2"
   Else
      cAlias := "QRY"
   Endif
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd := MontaQuery(nRadio) 
         cCmd := ChangeQuery(cCmd)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), cAlias, .F., .T.) 
         Processa({|| lRet := Imprimir() })
      ELSE
   #ENDIF
         // ** Grava arquivo temporário ...     
         GravaDBF(nRadio,cAlias)                 
         MsAguarde({||lRet := Imprimir()},STR0009)                                                                  //"Imprimindo registros ..."
   #IFDEF TOP
      ENDIF
   #ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   
   
   IF ( lZero )
      MSGINFO(STR0010, STR0011) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   ENDIF

   IF Empty(cFile)
      QRY->(dbCloseArea())
   Else 
      QRY->(E_EraseArq(cFile))
   Endif

   IF ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   ELSE
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   ENDIF

   IF Select("Work_Men") > 0
      Work_Men->(E_EraseArq(cWork))
   Endif              
   
End Sequence   

dbSelectArea(nOldArea)

RestOrd(aOrd)

Return (.F.)
         

*-----------------------------------*
Static Function TelaGets
*-----------------------------------*

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 25,45 OF oMainWnd 
      
      @ 16,10 To 59,170 TITLE STR0012  //"Cambios"
      @ 23,15 RADIO aRadio VAR nRadio 

      @ 65,15 SAY STR0013 PIXEL //"Cliente"
      @ 65,70 MSGET cImport F3 "SA1" Valid (Empty(cImport) .or. ExistCPO("SA1")) SIZE 40,8 PIXEL

      @ 80,15 SAY STR0014 PIXEL //"Data Inicial"
      @ 80,70 MSGET dDtIni SIZE 40,8 PIXEL
      
      @ 95,15 SAY STR0015 PIXEL //"Data Final"
      @ 95,70 MSGET dDtFim SIZE 40,8 PIXEL
      
      bOk     := {|| If(fConfData(dDtFim,dDtIni),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   ElsE
      lRet := .f.
   Endif 

End Sequence

Return lRet   
   
*-----------------------------------*
Static Function fConfData(dFim,dIni)
*-----------------------------------*
Local lRet  := .f.

Begin Sequence      
   if !empty(dFim) .and. dFim < dIni
      MsgInfo(STR0016,STR0011) //"Data Final não pode ser menor que Data Inicial" //"Aviso"
   Else
      lRet := .t.
   Endif   
End Sequence
      
Return lRet
  
#IFDEF TOP
   *-----------------------------------*
   Static Function TransData(sData)
   *-----------------------------------*
   if Empty(sData)
      sData := "  /  /  "
   Else
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),3,2)
   Endif

   Return sData 
#ENDIF
 
*--------------------------------------------------------------------
Static FUNCTION GPARC(cProc)
LOCAL Z,nTOTAL := 0,aPARC  := {}
LOCAL nCMP_VLR,dCMP_VCT

Begin Sequence

   EEC->(dbSetOrder(1))
   EEC->(dbSeek(xFilial()+cProc))
   
   // CALCULA AS PARCELAS E SEUS VENCIMENTOS
   SY6->(DBSETORDER(1))
   SY6->(DBSEEK(XFILIAL("SY6")+EEC->(EEC_CONDPA+STR(EEC_DIASPA,3,0))))
   
   IF SY6->Y6_TIPO = "1"       &&& NORMAL
      AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_ETD+EEC->EEC_DIASPA})
   ELSEIF SY6->Y6_TIPO = "2"   &&& A VISTA
      AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_ETD})
   
   ELSE   &&& PARCELADO
      FOR Z := 1 TO 10
          nCMP_VLR := "SY6->Y6_PERC_"+STRZERO(Z,2,0)
          dCMP_VCT := "SY6->Y6_DIAS_"+STRZERO(Z,2,0)
          
          IF &nCMP_VLR = 0
             EXIT
          ENDIF                                         
          
          AADD(aPARC,{EEC->EEC_TOTPED*(&nCMP_VLR/100),EEC->EEC_ETD+&dCMP_VCT})
          nTOTAL := nTOTAL+aPARC[LEN(aPARC),1]
      NEXT
      
      // ACERTANDO A DIFERENCA DE PARCELAS
      IF LEN(aPARC) > 0
         IF STRZERO(EEC->EEC_TOTPED,20,2) # STRZERO(nTOTAL,20,2)
            aPARC[LEN(aPARC),1] := aPARC[LEN(aPARC),1]+(EEC->EEC_TOTPED-nTOTAL)
         ENDIF
      ELSE
         MSGINFO(STR0017+ALLTRIM(EEC->EEC_PREEMB),STR0011) //"Verificar Processo: " //"Aviso"
      ENDIF
   ENDIF         
End Sequence

RETURN(aParc)

/*
Funcao          : MontaQuery
Parametros      : nRad => Tipo de seleção
Retorno         : Query
Objetivos       : Montar a query para selecionar registros para a impressao
Autor           : CAF / JBJ
Data/Hora       : 14/07/2001 13:25
Revisao         :
Obs.            : 
*/
Static Function MontaQuery(nRad,cSelect)

Local cQry := cSelect ,;
      cWhere2 := "", cOrder := "", cWhere := ""

//Private cWhere

/*
   cCmd   := "SELECT EEC_PREEMB, EEC_DTPROC, EEC_CBVCT, EEC_CBPGT, EEC_IMPODE, EEC_TOTPED, EEC_CBTX, EEC_MOEDA, EEC_DTEMBA FROM " +;  
             RetSqlName("EEC") + " EEC "
   
   cWhere := " WHERE D_E_L_E_T_ <> '*' AND "+; 
             " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "+;
             " EEC_DTEMBA <> '' "
   
   A-A Vencer - Embarcado, Recebidos
   ==================================================
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA, EEQ_VCT, EEQ_PGT, EEQ_VL, EEQ_TX
   FROM
       EEC990 EEC, EEQ990 EEQ
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND  EEC_FILIAL = '  ' AND 
      EEC_DTEMBA <> '' AND EEQ_PREEMB = EEC_PREEMB AND 
      EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '  '

   B-A Vencer - Previsão de Emb. (nRadio = 2)
   ==================================================
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA, '        ' AS EEQ_VCT, '        ' AS EEQ_PGT, 0 AS EEQ_VL, 0 AS EEQ_TX
   FROM
      EEC990 EEC
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND
      EEC_FILIAL = '  ' AND EEC_DTEMBA = '' AND 
      EEC_ETD <> ''
      
   C-A Vencer - Ambos (nRadio = 3)
   ==================================================
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA, EEQ_VCT, EEQ_PGT, EEQ_VL, EEQ_TX
   FROM
      EEC990 EEC, EEQ990 EEQ
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND  EEC_FILIAL = '  ' AND 
      EEC_DTEMBA <> '' AND EEQ_PREEMB = EEC_PREEMB AND 
      EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '  '
   UNION
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA,  '        ' AS EEQ_VCT, '        ' AS EEQ_PGT, 0 AS EEQ_VL, 0 AS EEQ_TX
   FROM
      EEC990 EEC
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND
      EEC_FILIAL = '  ' AND EEC_DTEMBA = '' AND 
      EEC_ETD <> ''
*/                                         

Begin Sequence
   
   IF Empty(cQry)
      cQry := "SELECT EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, EEC_DTEMBA, EEC_ETD"
      IF nRad <> 2
         cQry += ", EEQ_VCT, EEQ_PGT, EEQ_VL, EEQ_TX, EEQ_BANC"
      Else
         cQry += ", '        ' AS EEQ_VCT, '        ' AS EEQ_PGT, 0 AS EEQ_VL, 0 AS EEQ_TX, ' ' AS EEQ_BANC"
      Endif
   Endif 
   
   cQry += " FROM "+RetSqlName("EEC")+" EEC"
   
   IF nRad <> 2
      cQry += ", "+RetSqlName("EEQ")+" EEQ"
   Endif
   
   IF nRad <> 2
      cWhere := " WHERE EEC.D_E_L_E_T_ <> '*' AND "+; 
             " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "+;
             " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"'"
   Else
      cWhere := " WHERE EEC.D_E_L_E_T_ <> '*' AND "+; 
                " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "+;
                " EEC_DTEMBA = '        ' AND EEC_ETD <> '        '"
   Endif

   If !Empty(cImport)
      cWhere := cWhere + " AND EEC_IMPORT = '" + cImport + "' "
   Endif        
   
   If nRad = 1 // A Vencer - Embarcado
     If !Empty(dDtIni)
        cWhere := cWhere + " AND EEQ_VCT >= '" + DtoS(dDtIni)+"'"
     EndIf
     
     If !Empty(dDtFim)
        cWhere := cWhere + " AND EEQ_VCT <= '" + DtoS(dDtFim)+"'"         
     EndIf                    
     cWhere := cWhere + " AND EEQ_PGT = '        ' "         
     cOrder := " ORDER BY EEQ_VCT"    
   
   Elseif nRad = 2 // A Vencer - Previsão Emb.


    
   Elseif nRad = 3 // A Vencer - Ambos
      If !Empty(dDtIni)
         cWhere := cWhere + " AND EEQ_VCT >= '" + DtoS(dDtIni)+"'"
      EndIf
      If !Empty(dDtFim)
         cWhere := cWhere + " AND EEQ_VCT <= '" + DtoS(dDtFim)+"'"         
      EndIf                    
      cWhere := cWhere + " AND EEQ_PGT = '        ' "         
      //cOrder := " ORDER BY EEQ_VCT"     
      
      // Joga o 1o. select para a variavel cCmd            
      cQRY   += cWhere+" UNION "
      cQRY   += MontaQuery(2)
      cQRY   += " ORDER BY EEQ_VCT"
      cWhere := ""
      cOrder := ""   
         
   Else // Recebidos
      If !Empty(dDtIni)
         cWhere2 := " AND EEQ_PGT >= '" + DtoS(dDtIni)+"'"
      EndIf
      If !Empty(dDtFim)
         cWhere2 := cWhere2 + " AND EEQ_PGT <= '" + DtoS(dDtFim)+"'"         
      EndIf                    
      If Empty(cWhere2)
         cWhere := cWhere + " AND EEQ_PGT > '     ' "         
      Else
         cWhere := cWhere + cWhere2 
      Endif
      cOrder := " ORDER BY EEQ_PGT" 
   EnDif

End Sequence

Return cQry+cWhere+cOrder
*--------------------------------------------------------------------
Static Function GravaDBF(nRad,cAlias)
Local cWork,cCONDEEQ,;
      aSemSX3 := {},;
      aOrd    := SaveOrd({"EEC","EEQ","SIX"}),;
      lRet:= .T.

      /*
      aConds:={"EEC->EEC_IMPORT = cImport"+if(!Empty(dDtini).OR.!EMPTY(dDTFIM)," .And.",""),;
               "EEQ->EEQ_VCT >= dDtini ",;
               "EEQ->EEQ_VCT <= dDtfim ",;
               "Empty(EEC->EEC_DTEMBA) ",; 
               "!Empty(EEC->EEC_DTEMBA)",;
               "EEQ->EEQ_PGT >= dDtini ",;
               "EEQ->EEQ_PGT <= dDtfim ",;
               "EEC->EEC_IMPORT = cImport",;
               "EEC->EEC_DTPROC >= dDtini",;               
               "EEC->EEC_DTPROC <= dDtfim"}
      */
*
aSemSX3 := {{"EEC_FILIAL","C",AVSX3("EEC_FILIAL",AV_TAMANHO),0},;  
            {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;  
            {"EEC_IMPODE","C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;  
            {"EEC_IMPORT","C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;   
            {"EEC_MOEDA ","C",AVSX3("EEC_MOEDA ",AV_TAMANHO),0},;   
            {"EEC_ETD"   ,"D",AVSX3("EEC_ETD   ",AV_TAMANHO),0},;   
            {"EEC_DTEMBA","D",AVSX3("EEC_DTEMBA",AV_TAMANHO),0},;   
            {"EEC_DTPROC","D",AVSX3("EEC_DTPROC",AV_TAMANHO),0}}
cWork  := E_CRIATRAB("EEQ",aSemSX3,cAlias)
IF nRADIO = 4
   IndRegua(cAlias,cWork+OrdBagExt(),"EEQ_PGT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"
ELSE
   IndRegua(cAlias,cWork+OrdBagExt(),"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"
ENDIF

Set Index to (cWork+OrdBagExt())
*AQUI
Begin Sequence
   If nRad = 1 // ** A Vencer - Embarcado
      PRL15A()
   ElseIf nRad = 2  // ** A Vencer - Previsão de Embarque.
          PRL15B()
   ELSEIF nRAD = 3  // ** A Vencer - Ambos  ...
          PRL15A()
          PRL15B()
   ELSE   // ** Recebidos           
      cCONDEEQ := .F.
      // VERIFICA SE EXISTE O INDICE POR DATA DE PAGAMENTO
      SIX->(DBSETORDER(1))
      SIX->(DBSEEK("EEQ"))
      DO WHILE ! SIX->(EOF()) .AND. SIX->INDICE = "EEQ"
         IF LEFT(UPPER(SIX->CHAVE),24) = "EEQ_FILIAL+DTOS(EEQ_PGT)"
            cCONDEEQ := .T.
            EXIT
         ENDIF
         SIX->(DBSKIP())
      ENDDO
      // GERA O TMP
      IF cCONDEEQ
         EEQ->(DBSETORDER(VAL(SIX->ORDEM)))
         EEQ->(DBSEEK(XFILIAL("EEQ")+STRTRAN(DTOS(dDTINI)," ","0"),.T.))
         IF EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
            cCONDEEQ := ".T."
         ELSEIF ! EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
                cCONDEEQ := "DTOS(EEQ->EEQ_PGT) >= DTOS(dDTINI)"
         ELSEIF EMPTY(dDTINI) .AND. ! EMPTY(dDTFIM)
                cCONDEEQ := "DTOS(EEQ->EEQ_PGT) <= DTOS(dDTFIM)"
         ELSE
            cCONDEEQ := "EEQ->(DTOS(EEQ_PGT) >= DTOS(dDTINI) .AND. DTOS(EEQ_PGT) <= DTOS(dDTFIM))"
         ENDIF
      ELSE
         EEQ->(DBSETORDER(1))
         EEQ->(DBSEEK(XFILIAL("EEQ")))
         cCONDEEQ := ".T."
      ENDIF
      DO WHILE ! EEQ->(EOF()) .AND.;
         EEQ->EEQ_FILIAL = XFILIAL("EEQ") .AND. &cCONDEEQ
         *
         IF ! EMPTY(EEQ->EEQ_PGT)
            EEC->(DBSETORDER(1))
            EEC->(DBSEEK(XFILIAL("EEC")+EEQ->EEQ_PREEMB))
            IF (EMPTY(cIMPORT) .OR. EEC->EEC_IMPORT = cIMPORT)          .AND.;
               (EMPTY(dDTINI)  .OR. DTOS(EEQ->EEQ_PGT) >= DTOS(dDTINI)) .AND.;
               (EMPTY(dDTFIM)  .OR. DTOS(EEQ->EEQ_PGT) <= DTOS(dDTFIM))
               *
               (cAlias)->(DBAPPEND())
               (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB  
               (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
               (cAlias)->EEC_IMPODE := EEC->EEC_IMPODE
               (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
               (cAlias)->EEC_DTEMBA := EEC->EEC_DTEMBA              
               (cAlias)->EEQ_VCT    := EEQ->EEQ_VCT
               (cAlias)->EEQ_PGT    := EEQ->EEQ_PGT
               (cAlias)->EEQ_VL     := EEQ->EEQ_VL
               (cAlias)->EEQ_TX     := EEQ->EEQ_TX                      
               (cAlias)->EEQ_BANC   := EEQ->EEQ_BANC
            ENDIF
         ENDIF
         EEQ->(DBSKIP())
      ENDDO
   ENDIF
   RestOrd(aOrd)
   (cAlias)->(DbGoTop())   
End Sequence
Return lRet
*--------------------------------------------------------------------
Static Function Imprimir
Local lRet := .f.
Local cPeriodo
lZero := .t.
#IFDEF TOP
   IF TCSRVTYPE() <> "AS/400"
      IF nRadio <> 3
         cCmd     := MontaQuery(nRadio," SELECT COUNT(*) AS NCOUNT, ' ' AS EEQ_VCT, ' 'AS EEQ_PGT ")
         cCmd     := ChangeQuery(cCmd)
         nOldArea := Alias()
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.) 
         ProcRegua(QRYTEMP->NCOUNT)
         QRYTEMP->(dbCloseArea())
         dbSelectArea(nOldArea)
      EndIf
   ELSE
#ENDIF
      //... DBF ...
#IFDEF TOP
   ENDIF
#ENDIF
IF nRadio = 2 .Or. nRadio = 3 // A Vencer - Previsão de Emb. ou Ambos
   cFile := MontaWork(cAlias)
   QRY2->(dbCloseArea())
Endif   
      
CAB->(DBAPPEND())
CAB->SEQREL  := cSeqRel
CAB->TITULO  := ""

// ** Define Titulo do Relatório
If nRadio = 1 
   CAB->TITULO  := STR0018   //"CÂMBIO A VENCER"
ElseIf nRadio = 2 
   CAB->TITULO  := STR0019   //"A VENCER - PREVISÃO DE EMBARQUE"
ElseIf nRadio = 3
   CAB->TITULO  := STR0034  //"A VENCER - AMBOS"
Else
   CAB->TITULO  := STR0020   //"RECEBIDOS"
Endif
                       
// ** Define o Período do Relatório   
If !Empty(dDtini) .And. !Empty(dDtfim)
   If nRadio = 1 .or. nRadio = 3
      cPeriodo := STR0021+Dtoc(dDtini)+STR0022+Dtoc(dDtfim)  //"Vencimentos de  "###"  Até  "
   ElseIf nRadio = 2
      cPeriodo := STR0023+Dtoc(dDtini)+STR0022+Dtoc(dDtfim)  //"Vencimentos previstos de  " //"  Até  "
   Else
      cPeriodo := STR0024+Dtoc(dDtini)+STR0022+Dtoc(dDtfim)           //"Pagamentos de  " //"  Até  "
   EndIf
ElseIf !Empty(dDtini) .And. Empty(dDtfim)
   If nRadio = 1 .or. nRadio = 3
      cPeriodo := STR0025+Dtoc(dDtini) //"Vencimentos a partir de  "
   ElseIf nRadio = 2
      cPeriodo := STR0026+Dtoc(dDtini) //"Vencimentos previstos a partir de  "
   Else
      cPeriodo := STR0027+Dtoc(dDtini) //"Pagamentos a partir de  "
   EndIf
ElseIf Empty(dDtini) .And. !Empty(dDtfim)   
   If nRadio = 1 .or. nRadio = 3
      cPeriodo := STR0028+Dtoc(dDtfim) //"Vencimentos até  "
   ElseIf nRadio = 2
      cPeriodo := STR0029+Dtoc(dDtfim) //"Vencimentos previstos até  "
   Else
      cPeriodo := STR0030+Dtoc(dDtfim) //"Pagamentos até  "
   EndIf  
Else   
   cPeriodo := STR0033    //"Todos"
EndIf

CAB->PERIODO  := cPeriodo
CAB->IMPORT := If(Empty(cImport),STR0031,ALLTRIM(QRY->EEC_IMPODE)) //" Todos "
CAB->(MSUNLOCK())
      
While QRY->(!Eof())       
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         IncProc(STR0032 + QRY->EEC_PREEMB) //"Imprimindo: "
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF
   DET->(DBAPPEND())    
   DET->SEQREL   := cSeqRel 
   DET->PROCESSO := QRY->EEC_PREEMB
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         DET->DTPROCESSO := TransData(QRY->EEC_DTPROC)
         DET->DTVENC     := TransData(QRY->EEQ_VCT) 
      ELSE
   #ENDIF
         DET->DTPROCESSO := Dtoc(QRY->EEC_DTPROC)
         DET->DTVENC     := Dtoc(QRY->EEQ_VCT) 
   #IFDEF TOP
      ENDIF
   #ENDIF
   DET->IMPODE   := ALLTRIM(QRY->EEC_IMPODE)      
   DET->VALORUSS := QRY->EEQ_VL
   IF EMPTY(QRY->EEC_DTEMBA) .AND. ! EMPTY(QRY->EEC_ETD)
      DET->FLAG := "1"
   ELSE
      DET->FLAG := "0"
   ENDIF
   If nRadio = 4 // Recebidos
      DET->TXCAMBIO := QRY->EEQ_TX               
      DET->VALORRS  := QRY->EEQ_TX * QRY->EEQ_VL  
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            DET->DTPGT := TransData(QRY->EEQ_PGT)    
         ELSE
      #ENDIF
            DET->DTPGT := Dtoc(QRY->EEQ_PGT)
      #IFDEF TOP
         ENDIF
      #ENDIF
      DET->BANCO := Posicione("SA6",1,xFilial("SA6")+QRY->EEQ_BANC,"A6_NOME") // CAF 19/07/2001 20:22 BuscaInst(QRY->EEC_PREEMB,OC_EM,BC_COC)
   Else
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            DET->VALORNFS := QRY->EEQ_VL*BuscaTaxa(QRY->EEC_MOEDA,AVCTOD(TRANSDATA(QRY->EEC_DTEMBA)))
         ELSE
      #ENDIF
            DET->VALORNFS := QRY->EEQ_VL*BuscaTaxa(QRY->EEC_MOEDA,AVCTOD(DTOC(QRY->EEC_DTEMBA)))
      #IFDEF TOP
         ENDIF
      #ENDIF
   Endif

   DET->(MSUNLOCK())

   lNovo := .T.              
   lZero := .f.
     
   QRY->(dbSkip())
   lRet := .t.
Enddo     
   
Return lRet
*--------------------------------------------------------------------
/*
Funcao          : MontaWork()                  
Parametros      : Alias
Retorno         : cWork                
Objetivos       : Montar arquivo temporário
Autor           : CAF/JBJ
Data/Hora       : 14/07/01 - 14:49
Revisao         :
Obs.            : 
*/
Static Function MontaWork(cAlias)
Local cWork, aSemSX3 := (cAlias)->(dbStruct()), nZ:=0, i:=0
#IFDEF TOP
   IF TCSRVTYPE() <> "AS/400"
      aESTRU := {}
      FOR I := 1 TO LEN(aSEMSX3)
          cAX := {AVSX3(aSEMSX3[I,1],AV_TIPO),;
                  AVSX3(aSEMSX3[I,1],AV_TAMANHO),;
                  AVSX3(aSEMSX3[I,1],AV_DECIMAL)}
          IF cAX[1] = "D"
             cAX := {"C",8,0}
          ENDIF
          AADD(aESTRU,{aSEMSX3[I,1],cAX[1],cAX[2],cAX[3]})
      NEXT
      aSEMSX3 := aCLONE(aESTRU)
   ELSE
#ENDIF
      ///... DBF ...
#IFDEF TOP
   ENDIF
#ENDIF
cWORK  := E_CRIATRAB("",aSemSX3,"QRY")

INDREGUA("QRY",cWORK+OrdBagExt(),"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"
Set Index to (cWORK+OrdBagExt())
   
Do While ! (cAlias)->(Eof())
   QRY->(DbAppend())
   AvReplace(cAlias,"QRY")   
   IF nRADIO = 2
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            QRY->EEC_ETD := ""
         ELSE
      #ENDIF
            QRY->EEC_ETD := CTOD("  /  /  ")
      #IFDEF TOP
         ENDIF
      #ENDIF
   ENDIF
   If Empty((cAlias)->EEQ_VCT)
      aParc := GParc((cAlias)->EEC_PREEMB)
      If  Len(aParc) > 1
         For nZ := 1 To QRY->(Fcount())
            M->&(QRY->(FIELDNAME(nZ))) := QRY->(FIELDGET(nZ))
         Next
      Endif      
      For nZ:=1 to Len(aParc)                                     
         IF ! Empty(dDtIni) .And. aParc[nZ,2] < dDtIni  .Or.;
            ! Empty(dDtFim) .And. aParc[nZ,2] > dDtFim            
            IF nZ == 1
               QRY->(dbDelete())
            Endif            
            Loop
         Endif
         IF nZ > 1
            QRY->(dbAppend()) 
            AvReplace("M","QRY")
         Endif
         QRY->EEQ_VL  := aParc[nZ,1]
         #IFDEF TOP
            IF TCSRVTYPE() <> "AS/400"
               QRY->EEQ_VCT := Dtos(aParc[nZ,2])
            ELSE
         #ENDIF
               QRY->EEQ_VCT := aParc[nZ,2]
         #IFDEF TOP
            ENDIF
         #ENDIF
      Next    
   Endif        
   (cAlias)->(DBSKIP())
EndDo   
QRY->(DBGOTOP())   
Return(cWork)
*--------------------------------------------------------------------
STATIC FUNCTION PRL15A() // A VENCER - EMBARCADOS
LOCAL cCONDEEQ := .F.
// VERIFICA SE EXISTE O INDICE POR DATA DE VENCIMENTO
SIX->(DBSETORDER(1))
SIX->(DBSEEK("EEQ"))
DO WHILE ! SIX->(EOF()) .AND. SIX->INDICE = "EEQ"
   IF LEFT(UPPER(SIX->CHAVE),24) = "EEQ_FILIAL+DTOS(EEQ_VCT)"
      cCONDEEQ := .T.
      EXIT
   ENDIF
   SIX->(DBSKIP())
ENDDO
// GERA O TMP
IF cCONDEEQ
   EEQ->(DBSETORDER(VAL(SIX->ORDEM)))
   EEQ->(DBSEEK(XFILIAL("EEQ")+DTOS(dDTINI),.T.))
   IF EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
      cCONDEEQ := ".T."
   ELSEIF ! EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
          cCONDEEQ := "DTOS(EEQ->EEQ_VCT) >= DTOS(dDTINI)"
   ELSEIF EMPTY(dDTINI) .AND. ! EMPTY(dDTFIM)
          cCONDEEQ := "DTOS(EEQ->EEQ_VCT) <= DTOS(dDTFIM)"
   ELSE
      cCONDEEQ := "EEQ->(DTOS(EEQ_VCT) >= DTOS(dDTINI) .AND. DTOS(EEQ_VCT) <= DTOS(dDTFIM))"
   ENDIF
ELSE
   EEQ->(DBSETORDER(1))
   EEQ->(DBSEEK(XFILIAL("EEQ")))
   cCONDEEQ := ".T."
ENDIF
DO WHILE ! EEQ->(EOF()) .AND.;
   EEQ->EEQ_FILIAL = XFILIAL("EEQ") .AND. &cCONDEEQ
   *
   IF EMPTY(EEQ->EEQ_PGT)
      EEC->(DBSETORDER(1))
      EEC->(DBSEEK(XFILIAL("EEC")+EEQ->EEQ_PREEMB))
      IF (EMPTY(cIMPORT) .OR. EEC->EEC_IMPORT = cIMPORT)          .AND.;
         (EMPTY(dDTINI)  .OR. DTOS(EEQ->EEQ_VCT) >= DTOS(dDTINI)) .AND.;
         (EMPTY(dDTFIM)  .OR. DTOS(EEQ->EEQ_VCT) <= DTOS(dDTFIM))
         *
         (cAlias)->(DBAPPEND())
         (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
         (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
         (cAlias)->EEC_IMPODE := EEC->EEC_IMPODE
         (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
         (cAlias)->EEC_DTEMBA := EEC->EEC_DTEMBA
         (cAlias)->EEQ_VCT    := EEQ->EEQ_VCT
         (cAlias)->EEQ_PGT    := EEQ->EEQ_PGT
         (cAlias)->EEQ_VL     := EEQ->EEQ_VL
         (cAlias)->EEQ_TX     := EEQ->EEQ_TX                      
      ENDIF
   ENDIF
   EEQ->(DBSKIP())
ENDDO
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION PRL15B() // A VENCER COM PREVISAO DE EMBARQUE
EEC->(DBSETORDER(12))
EEC->(DBSEEK(XFILIAL("EEC")+"        "))
DO WHILE ! EEC->(EOF()) .AND.;
   EEC->(EEC_FILIAL+DTOS(EEC_DTEMBA)) = (XFILIAL("EEC")+"        ")
   *
   IF EEC->EEC_STATUS # ST_PC .AND. ! EMPTY(EEC->EEC_ETD) .AND.;
      (EMPTY(cIMPORT) .OR. EEC->EEC_IMPORT = cIMPORT)
      *
      (cAlias)->(DBAPPEND())
      (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
      (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
      (cAlias)->EEC_IMPODE := EEC->EEC_IMPODE
      (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
      (cALIAS)->EEC_ETD    := EEC->EEC_ETD
   ENDIF
   EEC->(DBSKIP())
ENDDO
RETURN(NIL)
*--------------------------------------------------------------------