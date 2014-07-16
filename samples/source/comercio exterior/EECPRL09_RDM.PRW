#INCLUDE "EECPRL09.ch"
/*
Programa        : EECPRL09.PRW
Objetivo        : Fornecedores por Dt Embarque
Autor           : Cristiane C. Figueiredo
Data/Hora       : 02/06/2000 11:17
Obs.            :
*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL09
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 02/06/2000 11:17
Revisao     :
Obs.        :
*/
User Function EECPRL09

Local lRet  := .T.
Local aOrd  := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})
Local lZero := .t.

Local cNomDbfC, aCamposC, cNomDbfD, aCamposD, aArqs

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cForn    := SPACE(AVSX3("A2_COD",3))
Private cFamilia := SPACE(AVSX3("YC_COD",3))
Private cRemarks := space(120)
Private cCopia   := space(120)
Private cCopia1  := space(120)

Private cArqRpt, cTitRpt

cNomDbfC:= "WORK09C"
aCamposC:= {}
AADD(aCamposC,{"SEQREL","C",  8,0})
AADD(aCamposC,{"TITULO","C",240,0})
AADD(aCamposC,{"REMARK","C",120,0})
AADD(aCamposC,{"COPIA" ,"C",120,0})
AADD(aCamposC,{"COPIA1","C",120,0})

cNomDbfD:= "WORK09D"
aCamposD:= {}
AADD(aCamposD,{"SEQREL"    ,"C", 8,0})
AADD(aCamposD,{"ORDEM"     ,"C",15,0})
AADD(aCamposD,{"ORDNBR"    ,"C",20,0})
AADD(aCamposD,{"COUNTNAME" ,"C",20,0})
AADD(aCamposD,{"CUSTNAME"  ,"C",20,0})
AADD(aCamposD,{"CUSTREFNBR","C",20,0})
AADD(aCamposD,{"QTYMTSO"   ,"N",15,2})
AADD(aCamposD,{"QTYMTSS"   ,"N",15,2})
AADD(aCamposD,{"PRICEUSD"  ,"N",15,2})
AADD(aCamposD,{"TERMS"     ,"C",10,0})
AADD(aCamposD,{"TOTPRICE"  ,"N",15,2})
AADD(aCamposD,{"TOTFREI"   ,"N",15,2})
AADD(aCamposD,{"INSURAN"   ,"N",15,2})
AADD(aCamposD,{"TOTCCPRICE","N",15,2})
AADD(aCamposD,{"TERMSDD"   ,"N", 4,0})
AADD(aCamposD,{"VESTRU"    ,"C",60,0})
AADD(aCamposD,{"SHIPM"     ,"C",10,0})
AADD(aCamposD,{"ETSORI"    ,"D", 8,0})
AADD(aCamposD,{"ETADEST"   ,"D", 8,0})
AADD(aCamposD,{"BLDATE"    ,"D", 8,0})
AADD(aCamposD,{"BLNBR"     ,"C",20,0})
AADD(aCamposD,{"ATOCONC"   ,"C",10,0})

aArqs := {}
AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("59","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("59","EEA_COD"),"EEA_TITULO"))
   Endif
   
   aRetCrw := CrwNewFile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EEC->(DBSETORDER(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   
   cDatas := if(DTOC(dDTIni)<>"  /  /  ",DTOC(dDTini),"")
   cDatas := cDatas + if(!empty(cDatas) .or. DTOC(dDTFim)<>"  /  /  ",STR0001,"") //" ATE "
   cDatas := cDatas + if(DTOC(dDTfim)<>"  /  /  ",DTOC(dDTFim),"")
   cTitulo:= Alltrim(cForn) + if(!empty(cforn)," -  ","")+" EXPORT REPORT "+IF(!Empty(cDatas),"- ","")+Alltrim(cDatas)
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->TITULO  := cTitulo
   CAB->REMARK  := cRemarks
   CAB->COPIA   := cCopia 
   CAB->COPIA1  := cCopia1
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  if(Empty(dDtFim), .T.,EEC->EEC_DTEMBA <= dDtFim)
     
      IF (!empty(cForn) .and. EEC->EEC_FORN <> cForn)
         EEC->(DBSKIP())
         Loop
      ENDIF
      
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
     
      nQtdOrd  := 0
      nQtdEmb  := 0
      
      nValor   := 0
      nValorPed:= 0
      nValINC  := 0
      
      While (EE9->(!EOF() .AND. EE9->EE9_FILIAL==xFilial("EE9")) .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB)
        
         IF (!Empty(cFamilia) .and. EE9->EE9_FPCOD <> cFamilia)
            EE9->(DBSKIP())
            Loop
         ENDIF
         
         nQtdEmb := nQtdEmb+ EE9->EE9_SLDINI
         nValor  := nValor + EE9->EE9_PRCINC
         nValINC := nValINC+ EE9->EE9_PRCTOT
         
         EE8->(DBSETORDER(1))
         EE8->(DBSEEK(XFILIAL("EE8")+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN))
         
         nQtdOrd := nQtdOrd + EE8->EE8_SLDINI
         nValorPed:= nValorPed + EE8->EE8_PRCTOT
         
         EE9->(DBSKIP())
      Enddo
      
      IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
         cTRANSP := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
      Else
         cTRANSP := Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
      Endif   
         
      DET->(DBAPPEND())
      
      DET->SEQREL    := cSeqRel 
      DET->ORDNBR    := EEC->EEC_PREEMB
      DET->COUNTNAME := POSICIONE("SYA",1,XFILIAL("SYA")+EEC->EEC_PAISET, "YA_DESCR")
      DET->CUSTNAME  := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_NREDUZ")
      DET->CUSTREFNBR:= EEC->EEC_REFIMP
      DET->QTYMTSO   := nQtdOrd
      DET->QTYMTSS   := if(empty(EEC->EEC_DTEMBA),0,nQtdEmb)
      DET->PRICEUSD  := (nValINC/if(empty(EEC->EEC_DTEMBA),nQtdOrd,nQtdEmb))
      DET->TERMS     := EEC->EEC_INCOTE
      DET->TOTPRICE  := IF(EMPTY(EEC->EEC_DTEMBA), nValorPed, nValor)
      DET->TOTFREI   := EEC->EEC_FRPREV
      DET->INSURAN   := EEC->EEC_SEGPRE
      DET->TOTCCPRICE:= nValINC
      DET->TERMSDD   := Posicione("SY6",1,XFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DIAS_PA")
      DET->VESTRU    := cTransp
      DET->SHIPM     := POSICIONE("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_DESCR")
      DET->ETSORI    := EEC->EEC_ETA
      DET->ETADEST   := EEC->EEC_ETADES
      DET->BLDATE    := EEC->EEC_DTCONH
      DET->BLNBR     := EEC->EEC_NRCONH
      DET->ATOCONC   := EE9->EE9_ATOCON
      DET->(MSUNLOCK())
     
      lZero := .f.
     
      EEC->(DBSKIP())
   Enddo   
  
   IF ( lZero )
      MSGINFO(STR0002, STR0003) //"Intervalo sem dados para impressão"###"Aviso"
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
Data/Hora   : 02/06/2000 11:17
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 23,50 OF oMainWnd

      @  20,05 SAY STR0004 PIXEL //"Data Inicial"
      @  20,60 MSGET dDtIni SIZE 40,8 PIXEL
      
      @  33,05 SAY STR0005 PIXEL //"Data Final"
      @  33,60 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim,dDtIni) PIXEL
      
      @  46,05 SAY STR0006 PIXEL //"Fornecedor"
      @  46,60 MSGET cForn SIZE 40,8 F3 "SA2" VALID (Vazio() .Or. ExistCpo("SA2")) PIXEL
                                                            
      // @  59,05 SAY "Família" PIXEL
      // @  59,60 MSGET cFamilia SIZE 29,8 F3 "SYC" VALID (Vazio() .Or. ExistCpo("SYC")) PIXEL

      @  59,05 SAY STR0007 PIXEL //"Remarks"
      @  59,60 MSGET cRemarks SIZE 115,8 PIXEL
      
      @  72,05 SAY "Copy To" PIXEL
      @  72,60 MSGET cCopia SIZE 115,8 PIXEL
      @  85,60 MSGET cCopia1 SIZE 115,8 PIXEL
      
      bOk     := {|| nOpc:=1, oDlg:End() }
      bCancel := {|| oDlg:End() }
   
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
      MsgInfo(STR0008,STR0003) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   Else
      lRet := .t.
   Endif   

End Sequence
      
Return lRet
   
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL09.PRW                                                 *
*------------------------------------------------------------------------------*
