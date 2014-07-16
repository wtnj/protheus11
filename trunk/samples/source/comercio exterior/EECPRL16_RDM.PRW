#INCLUDE "EECPRL16.ch"
#INCLUDE  "TOPCONN.CH"
#INCLUDE  "EECRDM.CH"
#INCLUDE  "RWMAKE.CH"

/*                                                                             
Funcao      : EECPRL16
Parametros  : Nenhum                                                       
Retorno     : .F.
Objetivos   : Fechto. de Cambio - Variacao Cambial Mensal
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/08/2001 09:31
Revisao     : 
Obs.        : EECPRL16.RPT                           
*/

*-----------------------------------*
User Function EECPRL16()
*-----------------------------------*
Local lRet     := .f.
Local nOldArea := ALIAS()
Local aOrd     := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})
Private aArqs, cCmd,cWhere,cOrder,;
        cNomDbfC := "R28002C",;
        aCamposC := {{"SEQREL    ","C",08,0},;
                     {"TITULO    ","C",100,0},;
                     {"PERIODO   ","C",100,0},;
                     {"TXPTAX    ","N",AVSX3("EEQ_TX",3),AVSX3("EEQ_TX",4)}},;
        cNomDbfD := "R28002D",;
        aCamposD := {{"SEQREL    ","C", 8,0},;
                     {"PROCESSO  ","C",AVSX3("EEC_PREEMB",3),0},;   
                     {"DTPROCESSO","C",10,0},;   
                     {"DTVENC    ","C",10,0},;
                     {"IMPODE    ","C",60,0},;
                     {"VALORNFS  ","N",AVSX3("EEM_VLNF",3),AVSX3("EEM_VLNF",4)},;
                     {"VALORUSS  ","N",AVSX3("EEC_TOTPED",3),AVSX3("EEC_TOTPED",4)},;
                     {"VRCAMB    ","N",AVSX3("EEQ_TX",3),AVSX3("EEQ_TX",4)}}

Private dDtIni    := AVCTOD("  /  /  ")
Private dDtFim    := AVCTOD("  /  /  ")
Private cArqRpt, cTitRpt
Private nTxPTAX   := 0
Private lZero    := .T.
Private lNovo    := .F.

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Endif

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   aARQS := {}
   AADD(aARQS,{cNOMDBFC,aCAMPOSC,"CAB","SEQREL"})
   AADD(aARQS,{cNOMDBFD,aCAMPOSD,"DET","SEQREL"})

   aRetCrw := CrwNewFilee(aARQS)
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd   := "SELECT EEC_PREEMB, EEC_DTPROC, EEQ_VCT, EEC_IMPODE, EEQ_VL, EEC_MOEDA, EEC_DTEMBA FROM " +;  
                   RetSqlName("EEC") + " EEC, "+RetSqlName("EEQ")+" EEQ " 
         cWhere := " WHERE EEC.D_E_L_E_T_ <> '*' AND "+; 
                   " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "+;
                   " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"' AND EEQ_PGT = '        '"
         If !Empty(dDtIni)
            cWhere := cWhere + " AND EEQ_VCT >= '" + DtoS(dDtIni)+"'"
         EndIf
         If !Empty(dDtFim)
            cWhere := cWhere + " AND EEQ_VCT <= '" + DtoS(dDtFim)+"'"         
         EndIf                    
         cOrder := " ORDER BY EEQ_VCT"	
         cCmd := ChangeQuery(cCmd+cWhere+cOrder)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
         Processa({|| lRet := Imprimir() })
      ELSE
   #ENDIF
         // ** Grava arquivo temporário ...     
         GravaDBF()                 
         MsAguarde({||lRet := Imprimir()},STR0002)                                                                     //"Imprimindo registros ..."
   #IFDEF TOP
      ENDIF
   #ENDIF
     
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
  
   If ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   EndIf

   QRY->(dbCloseArea())

   If ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   Else  
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   EndIf

End Sequence   

dbSelectArea(nOldArea)

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

Return (.F.)

/*
Funcao          : GravaDBF
Parametros      : Nenhum                  
Retorno         : .T.
Objetivos       : Gravar DBF com os registros para impressao
Autor           : Jeferson Barros Jr.
Data/Hora       : 15/08/2001 - 09:50
Revisao         :
Obs.            : 
*/
*-----------------------------------*
Static Function GravaDBF()
*-----------------------------------*
Local cWork, aSemSX3 := {}, aOrd:=SaveOrd({"EEC","EEQ"}),;
      cMacro:="", cMacro1:= "", lRet:= .T. 


Local aConds:={"!Empty(EEC->EEC_DTEMBA)  ",;
               "EEC->EEC_DTEMBA >= dDtini",;
               "EEC->EEC_DTEMBA <= dDtfim"}

aSemSX3 := {{"EEC_FILIAL","C",AVSX3("EEC_FILIAL",AV_TAMANHO),0},;     
            {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;     
            {"EEC_IMPODE","C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;     
            {"EEC_MOEDA ","C",AVSX3("EEC_MOEDA ",AV_TAMANHO),0},;     
            {"EEC_DTEMBA","D",AVSX3("EEC_DTEMBA",AV_TAMANHO),0},;     
            {"EEC_DTPROC","D",AVSX3("EEC_DTPROC",AV_TAMANHO),0}}     

cWork  := E_CRIATRAB("EEQ",aSemSX3,"QRY")

IndRegua("QRY",cWork+OrdBagExt(),"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"

Set Index to (cWork+OrdBagExt())

Begin Sequence
  
   EEC->(DbSetorder(12))                         //Filial + Dta Embarque        
   EEC->(DbSeek(xFilial("EEC")+IF(!Empty(dDtIni),Dtos(dDtIni),"00000000"),.T.))
              
   If Empty(dDtini) .And. Empty(dDtFim)                               
      cMacro:= aConds[1]                         //"!Empty(EEC->EEC_DTEMBA)"
   Else              
     cMacro := If(!Empty(dDtini),aConds[2],"")   //"EEC->EEC_DTEMBA >= dDtini"
     cMacro += If(!Empty(dDtini),If(!Empty(dDtfim)," .And. ",""),"")                      
     cMacro += If(!Empty(dDtfim),aConds[3],"")   //"EEC->EEC_DTEMBA <= dDtfim"
   Endif        

   EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))          
      
   Do While EEC->(!Eof() .And. EEC_FILIAL == xFilial("EEC")) 
       
      EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))          
     
      IF &cMacro        
         While EEQ->(!Eof() .And. EEQ_FILIAL == xFilial("EEQ")) .And. EEQ->EEQ_PREEMB == EEC->EEC_PREEMB 
            If Empty(EEQ->EEQ_PGT)
               QRY->(DbAppend())
               QRY->EEC_PREEMB:= EEC->EEC_PREEMB  
               QRY->EEC_DTPROC:= EEC->EEC_DTPROC 
               QRY->EEC_IMPODE:= EEC->EEC_IMPODE 
               QRY->EEC_MOEDA := EEC->EEC_MOEDA  
               QRY->EEC_DTEMBA:= EEC->EEC_DTEMBA              
               QRY->EEQ_VCT   := EEQ->EEQ_VCT    
               QRY->EEQ_VL    := EEQ->EEQ_VL                     
            EndIf
         EEQ->(DbSkip())
         Enddo            
      EndIf
      EEC->(DbSkip())
   EndDo         

   RestOrd(aOrd)
   QRY->(DbGoTop())   

End Sequence

Return lRet
        
*-----------------------------------*
Static Function Imprimir
*-----------------------------------*
Local lRet := .f.
Local cPeriodo 

#IFDEF TOP
   Local nOldArea
#ENDIF

Begin Sequence

   lZero := .t.
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd     := "SELECT COUNT(*) AS NCOUNT FROM " +;  
                     RetSqlName("EEC") + " EEC, "+RetSqlName("EEQ")+" EEQ " 
         cCmd     := ChangeQuery(cCmd+cWhere)
         nOldArea := Alias()
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.) 
         ProcRegua(QRYTEMP->NCOUNT)
         QRYTEMP->(dbCloseArea())
         dbSelectArea(nOldArea)
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF
      
   CAB->(DBAPPEND())                     
   CAB->SEQREL  := cSeqRel 
   CAB->TITULO  := cTitRpt
     
   // ** Define o Período do Relatório   
   If !Empty(dDtini) .And. !Empty(dDtfim)   
      cPeriodo := STR0005+Dtoc(dDtini)+STR0006+Dtoc(dDtfim)     //"Vencimentos de  "###"  Até  "
   ElseIf !Empty(dDtini) .And. Empty(dDtfim)
      cPeriodo := STR0007+Dtoc(dDtini)    //"Vencimentos a partir de  "
   ElseIf Empty(dDtini) .And. !Empty(dDtfim)   
      cPeriodo := STR0008+Dtoc(dDtfim) //"Vencimentos até  "
   Else   
      cPeriodo := STR0009 //"Todos os Vencimentos"
   EndIf   
   
   CAB->PERIODO := cPeriodo
   CAB->TXPTAX  := nTxPTAX
   CAB->(MSUNLOCK())                                                       
      
   While QRY->(!Eof())
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            IncProc(STR0010 + QRY->EEC_PREEMB) //"Imprimindo: "
         ELSE
      #ENDIF
            //... DBF ...
      #IFDEF TOP
         ENDIF
      #ENDIF
      DET->(DBAPPEND())
      DET->SEQREL      := cSeqRel 
      DET->PROCESSO    := QRY->EEC_PREEMB
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
      DET->IMPODE := ALLTRIM(QRY->EEC_IMPODE)
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            DET->VALORNFS := QRY->EEQ_VL * BuscaTaxa(QRY->EEC_MOEDA,CtoD(TransData(QRY->EEC_DTEMBA)))
         ELSE
      #ENDIF
            DET->VALORNFS := QRY->EEQ_VL * BuscaTaxa(QRY->EEC_MOEDA,QRY->EEC_DTEMBA)
      #IFDEF TOP
         ENDIF
      #ENDIF
      DET->VALORUSS  := QRY->EEQ_VL
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            DET->VRCAMB := QRY->EEQ_VL * (nTxPTAX - BuscaTaxa(QRY->EEC_MOEDA,CtoD(TransData(QRY->EEC_DTEMBA))))
         ELSE
      #ENDIF
            DET->VRCAMB := QRY->EEQ_VL * (nTxPTAX - BuscaTaxa(QRY->EEC_MOEDA,QRY->EEC_DTEMBA))
      #IFDEF TOP
         ENDIF
      #ENDIF
      DET->(MSUNLOCK())

      lNovo := .T.
      lZero := .f.
   
      QRY->(dbSkip())

      lRet := .t.           
   Enddo   

End Sequence 

Return lRet

*-----------------------------------*
Static Function TelaGets
*-----------------------------------*

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 18.5,50 OF oMainWnd
      
      @ 20,15 SAY STR0014 PIXEL //"Taxa PTAX"
      @ 20,70 MSGET nTxPTAX PICTURE (AVSX3("EEQ_TX",6)) Valid NaoVazio() SIZE 50,8 PIXEL

      @ 35,15 SAY STR0011 PIXEL //"Data Inicial"
      @ 35,70 MSGET dDtIni SIZE 50,8 PIXEL
      
      @ 50,15 SAY STR0012 PIXEL //"Data Final"
      @ 50,70 MSGET dDtFim SIZE 50,8 Valid fConfData(dDtFim,dDtIni) PIXEL
      
      bOk     := {|| If(fConfData(dDtFim,dDtIni),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   Else
      lRet := .f.   
   Endif 

End Sequence

Return lRet   
   
*-----------------------------------*
Static Function fConfData(dFim,dIni)
*-----------------------------------*

Local lRet  := .t.

Begin Sequence
      
      if !empty(dFim) .and. dFim < dIni
         MsgInfo(STR0013,STR0004) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
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
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),1,4)
   Endif

   Return sData 
#ENDIF