#INCLUDE "EECPRL14.ch"
/*
Funcao      : EECPRL14
Parametros  : 
Retorno     : 
Objetivos   : Relatório de Embarques
Autor       : LUCIANO CAMPOS DE SANTANA
Data        : 18/07/2001
Revisao     : 
Obs.        : Arquivo do Crystal REL14.rpt
*/
#INCLUDE  "TOPCONN.CH"
#INCLUDE  "EECRDM.CH"
#INCLUDE  "RWMAKE.CH"
*--------------------------------------------------------------------
USER FUNCTION EECPRL14()
Local lRet     := .f.,;
      nOldArea := ALIAS(),;
      aOpcoes  := {"",""},;
      aORDANT := SAVEORD({"EEC","EEM"})
Private aArqs, cCmd,cWhere,cOrder,nTOTREC,cTEMP,;
        dDtIni    := AVCTOD("  /  /  "),;
        dDtFim    := AVCTOD("  /  /  "),;
        cArqRpt, cTitRpt,;
        lZero    := .T.,;
        nOpcao   := 1,;
        aItems := {STR0001,STR0002},; //"Nao Embarcados"###"Embarcados"
        cNomDbfC := "WORK14C",;
        aCamposC := {{"SEQREL    ","C",08,0},;
                     {"TITULO    ","C",100,0},;
                     {"SUBTITULO ","C",100,0},;
                     {"PERIODO   ","C",100,0}},;
        cNomDbfD := "WORK14D",;
        aCamposD := {{"SEQREL    ","C", 8,0},;
                     {"PREEMB    ","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;  
                     {"IMPORT    ","C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;  
                     {"IMPODE    ","C",35,0},;  
                     {"NFS       ","C",50,0},;  
                     {"DTPROC    ","C",10,0},;  
                     {"ETD       ","C",10,0},;  
                     {"DTEMBA    ","C",10,0},;  
                     {"FLAG      ","C",01,0},;
                     {"TOTPED"    ,"N",15,2} }  
*
Begin Sequence
   cArqRpt := "REL14.RPT"
   cTitRpt := STR0003 //"Relatório de Embarques"
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Endif
   If ! TelaGets1()
      lRet := .F.
      Break
   ELSEIf nOpcao <> 1
          If ! TelaGets2()
             lRet := .F.
             Break
          Endif
   EndIf		   
   aARQS   := {{cNomDbfC,aCamposC,"CAB","SEQREL"},;
               {cNomDbfD,aCamposD,"DET","SEQREL"}}
   aRetCrw := CrwNewFile(aARQS)
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         if nOpcao = 1 
	         aOpcoes[1] := "AND EEC_DTEMBA = '        '"
        	   cOrder     := "ORDER BY EEC_ETD, EEC_PREEMB"
         Elseif nOpcao == 2
                aOpcoes[1] := If(Empty(dDtIni),"AND EEC_DTEMBA > '        '","AND EEC_DTEMBA >='" + DtoS(dDtIni) + "'")
                aOpcoes[2] := If(Empty(dDtFim),"","AND EEC_DTEMBA <='" + DtoS(dDtFim) + "'")
                cOrder     := "ORDER BY EEC_DTEMBA, EEC_PREEMB"
         Endif
         cCmd   := "SELECT EEC_PREEMB,EEC_IMPORT,EEC_IMPODE,EEC_DTPROC,EEC_ETD,"+; 
                          "EEC_DTEMBA,EEC_TOTPED "+;
                   "FROM "+RetSqlName("EEC")+" "
         cWhere := "WHERE D_E_L_E_T_ <> '*' AND " +; 
                         "EEC_FILIAL = '"+xFilial("EEC")+"' AND "+;
                         "EEC_STATUS <> '*' AND "+;
                         "(EEC_AMOSTR <> 'S' AND EEC_AMOSTR <> '1') "+;
                         aOpcoes[1]+aOpcoes[2]
         cCmd := ChangeQuery(cCmd+cWhere+cOrder)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
         cCmd := ChangeQuery("SELECT COUNT(*) AS NCOUNT FROM " +RetSqlName("EEC")+" "+cWhere)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.) 
         nTOTREC := QRYTEMP->NCOUNT
         QRYTEMP->(DBCLOSEAREA())
         DBSELECTAREA("QRY")
      ELSE
   #ENDIF
         EEC->(DBSETORDER(12))
         if nOpcao = 1 
	         aOpcoes[1] := "DTOS(EEC_DTEMBA) = '        '"
     	      cOrder     := "DTOS(EEC_ETD)+EEC_PREEMB"
            EEC->(DBSEEK(XFILIAL("EEC")))
         Elseif nOpcao == 2
                IF EMPTY(dDTINI)
                   aOpcoes[1] := "DTOS(EEC_DTEMBA) > '        '"
                   EEC->(DBSEEK(XFILIAL("EEC")+"19500101",.T.))
                ELSE
                   aOpcoes[1] := "DTOS(EEC_DTEMBA) >='"+DtoS(dDtIni)+"'"
                   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDTINI),.T.))
                ENDIF
                aOpcoes[2] := If(Empty(dDtFim),"",".AND. DTOS(EEC_DTEMBA) <='"+DtoS(dDtFim)+"'")
                cOrder     := "DTOS(EEC_DTEMBA)+EEC_PREEMB"
         Endif
         cWHERE := "EEC->(EEC_FILIAL = '"+xFilial("EEC")+"' .AND. "+aOpcoes[1]+aOpcoes[2]+")"
         cCMD   := E_CRIATRAB("EEC",,"QRY")
         IndRegua("QRY",cCMD+OrdBagExt(),cORDER)
         DO WHILE ! EEC->(EOF()) .AND. &cWHERE
            IF EEC->(EEC_STATUS <> '*' .AND. EEC_AMOSTR <> 'S' .AND. EEC_AMOSTR <> '1')
               QRY->(DBAPPEND())
               AVREPLACE("EEC","QRY")
            ENDIF
            EEC->(DBSKIP())
         ENDDO
         QRY->(DBGOTOP())
         nTOTREC := QRY->(LASTREC())
         cTEMP   := E_CRIATRAB("EEM",,"QRYNF")
         IndRegua("QRYNF",cTEMP+OrdBagExt(),"EEM_NRNF")
   #IFDEF TOP
      ENDIF
   #ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   Processa({|| lRet := Imprimir() })
   IF ( lZero )
      MSGINFO(STR0004, STR0005) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   ENDIF
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         QRY->(dbCloseArea())
      ELSE
   #ENDIF
         QRY->(E_ERASEARQ(cCMD))
         QRYNF->(E_ERASEARQ(cTEMP))
   #IFDEF TOP
      ENDIF
   #ENDIF
   IF ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   ELSE
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   ENDIF
End Sequence   
RESTORD(aORDANT)
dbSelectArea(nOldArea)
Return (.F.)
*--------------------------------------------------------------------
Static Function Imprimir()
Local cPeriodo,lRet := .f.
*
lZero    := .t.
ProcRegua(nTOTREC)
*
CAB->(DBAPPEND())                     
CAB->SEQREL    := cSeqRel 
CAB->TITULO    := cTitRpt
CAB->SUBTITULO := aItems[nOpcao]
If !Empty(dDtIni) .or. !Empty(dDtFim)
   cPeriodo := DtoC(dDtIni)+STR0006+ DtoC(dDtFim)  //" ate "
Else
   cPeriodo := STR0007 //"Todos"
Endif
CAB->PERIODO := cPeriodo
cFlag := "0"
DO While QRY->(!Eof())
  	IncProc(STR0008 + QRY->EEC_PREEMB) //"Imprimindo: "
   DET->(DBAPPEND())                     
   DET->SEQREL      := cSeqRel 
   DET->PREEMB      := QRY->EEC_PREEMB
   DET->IMPORT      := QRY->EEC_IMPORT
   DET->IMPODE      := SubStr(AllTrim(QRY->EEC_IMPODE),1,35)
   DET->DTPROC      := TransData(QRY->EEC_DTPROC)
   DET->ETD         := TransData(QRY->EEC_ETD   )
   DET->DTEMBA      := TransData(QRY->EEC_DTEMBA)
   DET->TOTPED      := QRY->EEC_TOTPED
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd   := "SELECT EEM_NRNF FROM "+RetSqlName("EEM")+;
                      " WHERE D_E_L_E_T_ <> '*' AND" +; 
                      " EEM_FILIAL = '" + xFilial("EEM") + "' AND" +;
                      " EEM_PREEMB = '" + QRY->EEC_PREEMB + "' AND"+;
                      " EEM_TIPOCA = '" + EEM_NF + "' AND"+;
                      " EEM_TIPONF = '" + EEM_SD + "'"+;
                      " ORDER BY EEM_NRNF" 
         cCmd := ChangeQuery(cCmd)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYNF", .F., .T.) 
      ELSE
   #ENDIF
         QRYNF->(__DBZAP())
         EEM->(DBSETORDER(1))
         EEM->(DBSEEK(XFILIAL("EEM")+QRY->EEC_PREEMB+EEM_NF))
         DO WHILE ! EEM->(EOF()) .AND.;
            EEM->(EEM_FILIAL+EEM_PREEMB) = (XFILIAL("EEM")+QRY->EEC_PREEMB) .AND.;
            EEM->EEM_TIPOCA = EEM_NF
            *
            IF EEM->EEM_TIPONF = EEM_SD
               QRYNF->(DBAPPEND())
               AVREPLACE("EEM","QRYNF")
            ENDIF
            EEM->(DBSKIP())
         ENDDO
         QRYNF->(DBGOTOP())
   #IFDEF TOP
      ENDIF
   #ENDIF
   nCont := 0
   cNfs  := ""        
   DO While ! QRYNF->(Eof())
      If nCont == 4
         DET->FLAG   := cFlag
         DET->NFS    := cNfs
         DET->(DBAPPEND())
         cNfs := AllTrim(QRYNF->EEM_NRNF)
      Else
	      cNfs += If(Empty(cNfs),""," / ") + AllTrim(QRYNF->EEM_NRNF)
      EndIf
      If(Mod(nCont,4)==0,nCont:=1,nCont++)
      QRYNF->(dbSkip())                                   
   ENDDO
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         QRYNF->(dbCloseArea())     
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF
   DET->FLAG   := cFlag
   DET->NFS    := cNfs
   lZero := .f.
   QRY->(dbSkip())
   lRet := .t.
   If(cFlag == "1",cFlag:="0",cFlag:="1")
Enddo   
Return(lRet)
*--------------------------------------------------------------------
Static Function TelaGets1()
Local bOk, bCancel,;
      lRet  := .f.,;
      nOpc  := 0
Begin Sequence
   Define MsDialog oDlg Title cTitRpt From 9,0 To 17,45 Of oMainWnd // 31
      @ 20,5 To 55,175 LABEL STR0009 Of oDlg Pixel //"Opções:"
      @ 30,13 Radio oRad Var nOpcao Size 60,09 Items aItems[1],aItems[2] Of oDlg Pixel
      bOk     := {|| nOpc:=1,oDlg:End()}
      bCancel := {|| oDlg:End() }
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   lRET := IF(nOPC=1,.T.,.F.)
End Sequence
Return(lRet)
*--------------------------------------------------------------------
Static Function TelaGets2()
Local lRet  := .f.,;
      nOpc  := 0,;
      bOk, bCancel              
Begin Sequence
   Define MsDialog oDlg Title cTitRpt From 9,0 To 19.5,35 Of oMainWnd
      @ 23,15 Say STR0010 Pixel //"Data Inicial"
      @ 23,70 MsGet dDtIni Size 50,8 Pixel
      @ 46,15 Say STR0011 Pixel //"Data Final"
      @ 46,70 MsGet dDtFim Size 50,8 Pixel
      
      bOk     := {|| If(fConfData(dDtFim,dDtIni),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   lRET := IF(nOpc=1,.t.,.f.)
End Sequence
Return(lRet)
*--------------------------------------------------------------------
Static Function fConfData(dFim,dIni)
LOCAL lRet  := .t.
if !empty(dFim) .and. dFim < dIni
   MsgInfo(STR0012,STR0005) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   lRet := .F.
Endif   
ReturN(lRet)
*--------------------------------------------------------------------
Static Function TransData(sData)
IF VALTYPE(sDATA) = "D"
   sDATA := DTOC(sDATA)
ELSEIF Empty(sData)
       sData := "  /  /    "
ELSE
   sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),1,4)
ENDIF
Return(sData)
*--------------------------------------------------------------------