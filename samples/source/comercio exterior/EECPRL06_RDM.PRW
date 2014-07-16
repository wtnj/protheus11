#INCLUDE "EECPRL06.ch"
/*
Programa        : EECPRL06.PRW
Objetivo        : Impressao Processo por Data de Atracação
Autor           : Cristiane C. Figueiredo
Data/Hora       : 30/05/2000 20:25
Obs.            :
*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL06
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   :30/05/2000 20:25   
Revisao     :
Obs.        :
*/
User Function EECPRL06

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cExport  := SPACE(AVSX3("A2_COD",3))
Private cFabr    := SPACE(AVSX3("A2_COD",3))
Private cPorto   := SPACE(AVSX3("EEC_PREEMB",3))
Private aTpOrdem := {AVSX3("EEC_ETA",AV_TITULO),AVSX3("EEC_VIA",AV_TITULO)}
Private cTpOrdem := aTpOrdem[1]

Private cArqRpt, cTitRpt

cNomDbfC:= "WORK06C"
aCamposC:= {}
AADD(aCamposC,{"SEQREL"  ,"C", 8,0})
AADD(aCamposC,{"EMPRESA" ,"C",60,0})
AADD(aCamposC,{"PERIODO" ,"C",30,0})
AADD(aCamposC,{"EMBARQUE","C",60,0})
AADD(aCamposC,{"EXPORT"  ,"C",60,0})

cNomDbfD:= "WORK06D"
aCamposD:= {}
AADD(aCamposD,{"SEQREL"  ,"C", 8,0})
AADD(aCamposD,{"ORDEM"   ,"C",60,0})
AADD(aCamposD,{"VIATRANS","C", 1,0})
AADD(aCamposD,{"TRANSP"  ,"C",30,0})
AADD(aCamposD,{"ETA"     ,"D", 8,0})
AADD(aCamposD,{"ETD"     ,"D", 8,0})
AADD(aCamposD,{"ETADEST" ,"D", 8,0})
AADD(aCamposD,{"EMB"     ,"C",15,0})
AADD(aCamposD,{"PESLIQ"  ,"N",15,3})
AADD(aCamposD,{"PESBRU"  ,"N",15,3})
AADD(aCamposD,{"DTEMB"   ,"D", 8,0})
AADD(aCamposD,{"FRETE"   ,"N",15,2})
AADD(aCamposD,{"PORTEMB" ,"C",20,0})
AADD(aCamposD,{"PORTDEST","C",20,0})
AADD(aCamposD,{"AGEMB"   ,"C",30,0})
AADD(aCamposD,{"AGDEST"  ,"C",30,0})
AADD(aCamposD,{"CUBAGEM" ,"N",15,3})

aArqs := {}
AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

Begin Sequence
   
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("56","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("56","EEA_COD"),"EEA_TITULO"))
   Endif
   
   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EEC->(DBSETORDER(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0001 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0002 + DtoC(dDtFim) //" ATE "
   Endif
      
   IF empty(cPorto)
      cPorto := STR0001  //"TODOS"
   ENDIF
   IF empty(cExport)
      cExport := STR0001  //"TODOS"
   ENDIF
   
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->EMBARQUE:= IF(cPorto <> STR0001,Posicione("SY9",2,xFilial("SY9")+cPorto,"Y9_DESCR"),cPorto) //"TODOS"
   CAB->EXPORT  := IF(cExport <> STR0001,Posicione("SA2",1,xFilial("SA2")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  If(Empty(dDtFim),.t.,EEC->EEC_DTEMBA <= dDtFim)
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
      
      lFabr9 := .f.
      cFABR1 := EE9->EE9_FABR
      
      While EE9->(!EOF() .AND. EE9->EE9_FILIAL==xFilial("EE9")) .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB
         IF EE9->EE9_FABR == cFabr
            lFabr9 := .t.
         ENDIF
        
         EE9->(DBSKIP())
      End
     
      lPorto  := cPorto <> STR0001 .and. cPorto <> EEC->EEC_ORIGEM //"TODOS"
      lFabr   := !(empty(cFabr)) .and. !lFabr9
      lExport := cExport<>STR0001 .and. IF(EMPTY(EEC->EEC_EXPORT),cExport <> EEC->EEC_FORN,cExport <> EEC->EEC_EXPORT) //"TODOS"
     
      IF lPorto .or. lFabr .or. lExport
         EEC->(DBSKIP())
         Loop
      ENDIF
   
      DET->(DBAPPEND())
      DET->SEQREL  := cSeqRel 
     
      IF cTpOrdem==aTpOrdem[1]
         DET->ORDEM := DTOS(EEC->EEC_ETA)
      ELSE
         DET->ORDEM := EEC->EEC_VIA
      ENDIF
     
      DET->VIATRANS:= SUBST(POSICIONE("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),3,1) //SUBST(EEC->EEC_VIA,1,1)
      DET->TRANSP  := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_TRA)
      DET->ETA     := EEC->EEC_ETA
      DET->ETD     := EEC->EEC_ETD
      DET->ETADEST := EEC->EEC_ETADES
      DET->EMB     := EEC->EEC_PREEMB
      DET->PESLIQ  := EEC->EEC_PESLIQ
      DET->PESBRU  := EEC->EEC_PESBRU
      DET->DTEMB   := EEC->EEC_DTEMBA
      DET->FRETE   := EEC->EEC_FRPREV
      DET->PORTEMB := IF(EMPTY(EEC->EEC_ORIGEM),"",POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR"))
      DET->PORTDEST:= IF(EMPTY(EEC->EEC_DEST),"",POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST,"Y9_DESCR"))
      DET->AGEMB   := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_AGE)
      DET->AGDEST  := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_ARM)
      
      IF Empty(EEC->EEC_EMBAFI) .Or.;
           GetMv("MV_AVG0005") // Deixar de gravar embalagens ? 
         nCubagem := EEC->EEC_CUBAGE
      Else
         nCubagem := EEC->EEC_CUBAGE*EEC->EEC_TOTVOL
      Endif     
   
      DET->CUBAGEM := nCubagem
      DET->(MSUNLOCK())
      
      EEC->(DBSKIP())
      lZero := .f.
   Enddo   
  
   IF ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
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

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 30/05/2000 20:25   
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet  := .f.

Local oDlg

Local nOpc := 0
Local bOk  := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }
   
Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 21,50 OF oMainWnd
   
      @ 20,05 SAY STR0005 PIXEL //"Data Inicial"
      @ 20,45 MSGET dDtIni SIZE 40,8 PIXEL
      
      @ 33,05 SAY STR0006 PIXEL //"Data Final"
      @ 33,45 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL
      
      @ 46,05 SAY STR0007 PIXEL //"Fabricante"
      @ 46,45 MSGET cFabr SIZE 40,8 F3 "SA2" PICT AVSX3("A2_COD",6) valid (Empty(cFabr).or.ExistCpo("SA2")) PIXEL

      @ 59,05 SAY STR0008 PIXEL //"Exportador"
      @ 59,45 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) F3 "SA2" PIXEL
      
      @ 72,05 SAY STR0009 PIXEL //"P. Embarque"
      @ 72,45 MSGET cPorto SIZE 40,8 F3 "EY9" PIXEL PICT AVSX3("Y9_SIGLA",AV_PICTURE) VALID Vazio() .Or. ExistCpo("SY9",cPorto,2)

      @ 85,05 SAY STR0010 //"Ordenar por"
      TComboBox():New(111,40,bSETGET(cTpOrdem),aTpOrdem,115,60,oDlg,,,,,,.T.)
                                                     
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   Endif 
   
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
      MsgInfo(STR0011,STR0004) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   Else
      lRet := .t.
   Endif   

End Sequence
      
Return lRet
   
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL06.PRW                                                 *
*------------------------------------------------------------------------------*
