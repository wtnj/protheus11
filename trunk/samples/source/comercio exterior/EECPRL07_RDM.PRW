#INCLUDE "EECPRL07.ch"
/*
Programa        : EECPRL07.PRW
Objetivo        : Comissões Pendentes
Autor           : Cristiane C. Figueiredo
Data/Hora       : 22/05/2000 17:18
Obs.            :

*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL07
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 22/05/2000 17:18
Revisao     :
Obs.        :
*/

User Function EECPRL07

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo
Local aTPCOMB := {STR0001,STR0002,STR0003} //"Remeter"###"Conta Grafica"###"Deduzir Fatura"
Local lEmba, cAgeCom, lRecCom, lExport, lFornec, lTpCom, lRecebe, lValCom
Local nValFob, nPercom, nValCom, nDiasCP
   
Private dDtIni  := AVCTOD("  /  /  ")
Private dDtFim  := AVCTOD("  /  /  ")
Private cExport := SPACE(AVSX3("A2_COD",3))
Private cFabric := SPACE(AVSX3("A2_COD",3))
Private cRepres := SPACE(AVSX3("EEB_CODAGE",3))
Private aTpCom  := {STR0004, STR0005,STR0006, STR0007} //"0-Todos"###"1-Remeter"###"2-Conta Gráfica"###"3-Deduzir Fatura"
Private cTpCom := aTpCom[1]
   
Private cArqRpt, cTitRpt

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("57","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("57","EEA_COD"),"EEA_TITULO"))
   Endif

   cNomDbfC:= "WORK07C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL","C", 8,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"FABRIC","C",60,0})
   AADD(aCamposC,{"EXPORT","C",60,0})


   cNomDbfD:= "WORK07D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL","C", 8,0})
   AADD(aCamposD,{"DTEMBA","C",10,0})
   AADD(aCamposD,{"DTVENC","C",10,0})
   AADD(aCamposD,{"AGECOM","C",40,0})
   AADD(aCamposD,{"IMPORT","C",20,0})
   AADD(aCamposD,{"PREEMB","C",20,0})
   AADD(aCamposD,{"CONDPA","C",60,0})
   AADD(aCamposD,{"NRINVO","C",20,0})
   AADD(aCamposD,{"TPCOM","C",20,0})
   AADD(aCamposD,{"CODIMP","C",60,0})
   AADD(aCamposD,{"CODAGE","C",60,0})
   AADD(aCamposD,{"VALFOB","N",15,3})
   AADD(aCamposD,{"PERCOM","N",6,2})
   AADD(aCamposD,{"VALCOM","N",15,3})

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   EEC->(dbsetorder(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0008 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0009 + DtoC(dDtFim) //" ATE "
   Endif
   
   IF empty(cExport)
      cExport := STR0008  //"TODOS"
   ENDIF
   
   IF empty(cFabric)
      cFabric := STR0008  //"TODOS"
   ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->FABRIC  := If(cFabric <> STR0008, Posicione("SA2",1,XFILIAL("SA2")+cFabric,"A2_NREDUZ"),cFabric) //"TODOS"
   CAB->EXPORT  := If(cExport <> STR0008, Posicione("SA2",1,XFILIAL("SA2")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   
   CAB->(MSUNLOCK())
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  If(Empty(dDtFim),.t.,EEC->EEC_DTEMBA <= dDtFim)
     
     EE9->(DBSETORDER(3))
     EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
     if cFabric == STR0008 //"TODOS"
        lFornec := .f.
     Else
        lFornec := .t.
        Do while EE9->(!eof()) .and. xFilial("EE9") ==  EE9->EE9_FILIAL .AND. EE9->EE9_PREEMB == EEC->EEC_PREEMB
           if cFabric == EE9->EE9_FABR
              lFornec := .f.
           Endif   
           EE9->(DBSKIP())
        Enddo   
     endif      
     EEB->(DBSETORDER(1))
     lEmba   := EMPTY(EEC->EEC_DTEMBA)
     cAgeCom := BUSCAEMPRESA(EEC->EEC_PREEMB,"Q","3")
     lRecCom := empty(cAgecom)
     lValCom := empty(EEC->EEC_VALCOM)
     lExport := cExport<>STR0008 .and. cExport <> if(empty(EEC->EEC_EXPORT),EEC->EEC_FORN,EEC->EEC_EXPORT) //"TODOS"
     lTpCom  := substr(cTpCom,1,1) <> "0" .and. substr(cTpCom,1,1) <> EEC->EEC_TIPCOM
     lRecebe := !EMPTY(cRepres) .and. !(EEB->(DBSEEK(XFILIAL("EEB")+EEC->EEC_PREEMB+"Q"+cRepres+"3")))
     
     IF ( lExport .or. lFornec .or. lTpCom .or. lRecCom .or. lRecebe .or. lEmba .or. lValCom)
        EEC->(DBSKIP())
        Loop
     ENDIF
     
     lZero := .f.
     nValFOB := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
     
     nPerCom := if(EEC->EEC_TIPCVL=="1",EEC->EEC_VALCOM,(EEC->EEC_VALCOM/nValFOB)*100)
     nValCom := if(EEC->EEC_TIPCVL=="1",(EEC->EEC_VALCOM*nValFOB)/100,EEC->EEC_VALCOM)
     
     DET->(DBAPPEND())
     DET->SEQREL := cSeqRel 
     DET->DTEMBA := dtoc(EEC->EEC_DTEMBA)
     nDIASCP := POSICIONE("SY6",1,XFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DIAS_PA")
     DET->DTVENC := DTOC(EEC->EEC_DTEMBA + nDIASCP)
     DET->AGECOM := cAgeCom
     DET->IMPORT := Posicione("SA1",1,XFILIAL("SA1")+EEC->EEC_IMPORT,"A1_NREDUZ")
     DET->PREEMB := EEC->EEC_PREEMB
     DET->CONDPA := MSMM(Posicione("SY6",1,xFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DESC_P"),AVSX3("Y6_VM_DESP",3))
     DET->VALFOB := nValFOB
     DET->PERCOM := nPerCom
     DET->VALCOM := nValCom
     DET->NRINVO := EEC->EEC_NRINVO
     DET->TPCOM  := IF(!EMPTY(EEC->EEC_TIPCOM),aTPCOMB[VAL(EEC->EEC_TIPCOM)],"")
     DET->CODIMP := EEC->EEC_IMPORT
     DET->CODAGE := EEB->EEB_CODAGE
     DET->(MSUNLOCK())
     EEC->(DBSKIP())
   Enddo   
  
   IF ( lZero )
     MSGINFO(STR0010, STR0011) //"Não existe comissão para o intervalo escolhido"###"Aviso"
     lRet := .f.
   ENDIF
     
End Sequence


//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
ELSE
   // Fecha e apaga os arquivos temporarios
   CrwCloseFile(aRetCrw,.T.)
ENDIF


Return .f.
         
//----------------------------------------------------------------------
Static Function TelaGets

   Local lRet  := .f.

   Local oDlg

   Local nOpc := 0
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
      
   Begin Sequence
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 24,50 OF oMainWnd
   
      @ 20,05 SAY STR0012 PIXEL //"Data Inicial"
      @ 20,45 MSGET dDtIni SIZE 40,8 PIXEL
      
      @ 33,05 SAY STR0013 PIXEL //"Data Final"
      @ 33,45 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL
      
      @ 46,05 SAY STR0014 PIXEL //"Representante"
      @ 46,45 MSGET cRepres SIZE 20,8 PICT AVSX3("Y5_COD",6) valid (Empty(cRepres).or.ExistCpo("SY5")) F3 "SY5" PIXEL
   
      @ 59,05 SAY STR0015 PIXEL //"Exportador"
      @ 59,45 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) F3 "SA2" PIXEL
      
      @ 72,05 SAY STR0016 PIXEL //"Fabricante"
      @ 72,45 MSGET cFabric SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cFabric).or.ExistCpo("SA2")) F3 "SA2" PIXEL
   
      @ 85,05 SAY STR0017 PIXEL //"Tipo Comissão"
      TComboBox():New(85,45,bSETGET(cTpCom),aTpCom,80,50,oDlg,,,,,,.T.)
        
      ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

      IF nOpc == 1
         lret := .t.
      ENDIF
      
   End Sequence

   Return lRet
   
   

/*
Funcao      : fConfData
Parametros  : Data Final, Data Inicial
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 28/08/2000 11:00       
Revisao     :
Obs.        :
*/
Static Function fConfData(dFim,dIni)

Local lRet  := .f.

Begin Sequence
      
      if !empty(dFim) .and. dFim < dIni
         MsgInfo(STR0018,STR0011) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
      Else
         lRet := .t.
      Endif   

End Sequence
      
Return lRet


*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL07.PRW                                                 *
*------------------------------------------------------------------------------*
