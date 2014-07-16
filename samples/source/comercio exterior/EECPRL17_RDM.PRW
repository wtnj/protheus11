#INCLUDE "EECPRL17.ch"
/*
Programa        : EECPRL17.PRW
Objetivo        : RELATORIO RECYABLE ACCOUNT STATEMENT
Autor           : Jeferson Barros Jr.
Data/Hora       : 15/08/2001 - 13:33
Revisão         : 
Obs.            : Arquivo - EECPRL17.RPT
*/                          											

#Include  "TOPCONN.CH"
#include  "EECRDM.CH"

*---------------------------
User Function EECPRL17()  
*---------------------------
Local aArqs,aRetCrw, cQry,;
      lRet     := .T.

Local aOrd     := SaveOrd({"EEC","SA1"}),;
      cNomDBFC := "IPAS_3MC"
   
Local aCamposC := {{"WKSEQREL  ","C",08,0},;
                   {"WKIMPORT"  ,"C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;
                   {"WKIMPODE  ","C",60,0},;
                   {"WKPERIODO ","C",21,0}}
     
Local cNomDBFD := "IPAS_3MD",;
      aCamposD := {{"WKSEQREL  ","C",08,0},;
                   {"WKIMPORT"  ,"C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;
                   {"WKNRINVO  ","C",20,0},{"WKIMPODE  ","C",60,0},; 
                   {"WKDTINVO  ","C",08,0},{"WKCBVCT   ","C",08,0},;
                   {"WKDTEMBA  ","C",08,0},{"WKPREEMB  ","C",20,0},;
                   {"WKCBPGT   ","C",08,0},{"WKTOTPED  ","N",15,2},;
                   {"WKCBNR    ","C",20,0},{"WKTOTOPEN ","N",15,2},;
                   {"WKFLAG    ","C",01,0},{"WKTOTCLOS ","N",15,2},;
                   {"WKPERIODO ","C",21,0}}

Private cArqRpt, cTitRpt,;
        dDtIni   := dDtFim   := AVCTOD("  /  /    "),;
        cImport  := Space(AVSX3("A1_COD",3)) 

Private lZero  := .T.

Begin Sequence

   If Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   EndIf
   
   If ! TelaGets()
      lRET := .F.
      Break
   EndIf

   aARQS := {}
   AADD(aARQS,{cNomDBFC,aCamposC,"CAB","WKSEQREL+WKIMPORT"})
   AADD(aARQS,{cNomDBFD,aCamposD,"DET","WKSEQREL+WKIMPORT"})

   aRetCrw := CrwNewFile(aARQS)
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         MsAguarde({|| lRet := GravaDados() },STR0001) //"Aguarde"
      ELSE
   #ENDIF
         MsAguarde({|| GravaDBF()},STR0002)     //"Gravando arquivo temporário..."
         MsAguarde({|| lRet := GravaDados()},STR0001)     //"Aguarde"
   #IFDEF TOP
      ENDIF
   #ENDIF

   IF ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   ENDIF

   If ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   Else                    
     // Fecha e apaga os arquivos temporarios
     CrwCloseFile(aRetCrw,.T.)
   EndIf

End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cWork))
Endif              

RestOrd(aOrd)

Return(.F.)

/*
Funcao          : GravaDBF
Parametros      : Nenhum                  
Retorno         : .T.
Objetivos       : Gravar DBF com os registros para impressao
Autor           : Jeferson Barros Jr.
Data/Hora       : 15/08/2001 - 13:53
Revisao         :
Obs.            : 
*/
*-----------------------------------*
Static Function GravaDBF()
*-----------------------------------*
Local cWork, aSemSX3 := {}, aOrd:=SaveOrd({"EEC","EEQ"}),;
      cMacro:="", cMacro1:= "", lRet:= .T. 


Local aConds:={"!Empty(EEC->EEC_DTEMBA)  ",;
               "EEC->EEC_IMPORT = cImport",; 
               "EEQ->EEQ_PGT >= dDtini   ",;
               "EEQ->EEQ_PGT <= dDtfim"}

aSemSX3 := { {"EEC_FILIAL","C",AVSX3("EEC_FILIAL",AV_TAMANHO),0},;
             {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;
             {"EEC_IMPODE","C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;   
             {"EEC_IMPORT","C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;   
             {"EEC_NRINVO","C",AVSX3("EEC_NRINVO",AV_TAMANHO),0},;   
             {"EEC_DTEMBA","D",AVSX3("EEC_DTEMBA",AV_TAMANHO),0},;   
             {"EEC_DTINVO","D",AVSX3("EEC_DTINVO",AV_TAMANHO),0}}    


cWork  := E_CRIATRAB("EEQ",aSemSX3,"QRY")

IndRegua("QRY",cWork+OrdBagExt(),"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0005) //"Processando Arquivo Temporario"

Set Index to (cWork+OrdBagExt())

Begin Sequence

   EEQ->(dbSetOrder(1))     // Filial+Processo+Parcela
  
   If !Empty(cImport)  
      EEC->(DbSetorder(6))  // Filial+Importador
      EEC->(DbSeek(XFilial("EEC")+cImport))  
         
      cMacro1:= aConds[2]                          //"EEC->EEC_IMPORT = cImport"
      If Empty(dDtini) .And. Empty(dDtFim)                               
         cMacro:= ".T."         
      Else              
         cMacro := If(!Empty(dDtini),aConds[3],"") //"EEQ->EEQ_PGT >= dDtini" 
         cMacro += If(!Empty(dDtini),If(!Empty(dDtfim)," .And. ",""),"")                      
         cMacro += If(!Empty(dDtfim),aConds[4],"") //"EEQ->EEQ_PGT <= dDtfim"
      EndIf     
   Else                                          
      EEC->(DbSetorder(12)) //Filial+Dta Embarque

      EEC->(DbSeek(xFilial("EEC")+IF(!Empty(dDtIni),Dtos(dDtIni),"00000000"),.T.))
         
      cMacro1:=".T."
         
      If Empty(dDtini) .And. Empty(dDtFim)                               
         cMacro:= aConds[1]                         //"!Empty(EEC->EEC_DTEMBA)  "
      Else              
         cMacro := If(!Empty(dDtini),aConds[3],"")  //"EEQ->EEQ_PGT >= dDtini"
         cMacro += If(!Empty(dDtini),If(!Empty(dDtfim)," .And. ",""),"")                      
         cMacro += If(!Empty(dDtfim),aConds[4],"")  //"EEQ->EEQ_PGT <= dDtfim"
      Endif        
   Endif
 
   Do While EEC->(!Eof()) .And. EEC->EEC_FILIAL == xFilial("EEC") .And. &cMacro1  
      EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))          
      IF &cMacro
         While EEQ->(!Eof() .And. EEQ_FILIAL == xFilial("EEQ")) .And. EEQ->EEQ_PREEMB == EEC->EEC_PREEMB 
            QRY->(DbAppend())
            QRY->EEC_PREEMB:= EEC->EEC_PREEMB                     
            QRY->EEC_IMPODE:= EEC->EEC_IMPODE
            QRY->EEC_IMPORT:= EEC->EEC_IMPORT
            QRY->EEC_DTEMBA:= EEC->EEC_DTEMBA 
            QRY->EEC_NRINVO:= EEC->EEC_NRINVO
            QRY->EEC_DTINVO:= EEC->EEC_DTINVO             
            QRY->EEQ_VCT   := EEQ->EEQ_VCT
            QRY->EEQ_PGT   := EEQ->EEQ_PGT                        
            QRY->EEQ_VL    := EEQ->EEQ_VL
            QRY->EEQ_NROP  := EEQ->EEQ_NROP                    
            EEQ->(DbSkip())
         Enddo 
      EndIf
      EEC->(DbSkip())
   EndDo         
   RestOrd(aOrd)

End Sequence

QRY->(DbGoTop())

Return lRet

*-------------------------------------------------------------
Static Function GravaDados()
*-------------------------------------------------------------
Local lRet
Local cProcAnt := " ",lFlag := .t.       

#IFDEF TOP
   Local cQry   
#ENDIF

lZero := .T.

Begin Sequence
  
   MsProcTxt(STR0006) //"Gerando relatório ..."
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cQRY := "SELECT EEC_NRINVO, EEC_DTINVO, EEQ_VCT, EEC_DTEMBA, EEC_PREEMB,"+;
                 " EEQ_VL, EEQ_PGT, EEQ_NROP, EEC_IMPORT, EEC_IMPODE "+;
                 " FROM "+RetSqlName("EEC")+" EEC, "+RetSqlName("EEQ")+" EEQ " 
         cQRY += "WHERE EEC.D_E_L_E_T_ <> '*' AND EEC_FILIAL = '"+xFilial("EEC")+"' AND"+;
                 " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND "+;
                 " EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"'"
         cWhere := "" 
         IF !Empty(cImport)
            cWhere += " AND EEC_IMPORT = '"+cImport+"'"
         Endif
         IF !Empty(dDtIni) .Or. !Empty(dDtFim)
            cWhere += " AND (EEQ_PGT = '        ' OR"  
            IF !Empty(dDtIni)
               cWhere += " EEQ_PGT >= '"+Dtos(dDtIni)+"'"
               IF !Empty(dDtFim)
                  cWhere += " AND"
               Endif
            Endif
            IF !Empty(dDtFim)
               cWhere += " EEQ_PGT <= '"+Dtos(dDtFim)+"'"
            Endif           
            cWhere += ")"  
         Endif
         cQRY += cWhere
         cQRY += " ORDER BY EEC_IMPORT, EEQ_VCT, EEQ_PREEMB"       
         cQRY := ChangeQuery(CQRY)
         DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQRY),"QRY",.F.,.T.)
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF
   cSEQREL  := GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   MsProcTxt(STR0006)   //"Gerando relatório ..."
    
   cImportAtu := ""
   
   Do While ! QRY->(Eof())         
      CAB->(DbAppend())  
      CAB->WKSEQREL  := cSeqRel
      CAB->WKIMPORT  := QRY->EEC_IMPORT 
      CAB->WKIMPODE  := QRY->EEC_IMPODE

      cImportAtu := QRY->EEC_IMPORT

      lRet := .T.
      
      Do While ! QRY->(Eof()) .And. cImportAtu == QRY->EEC_IMPORT         
         
         DET->(DbAppend())
         DET->WKSEQREL  := CAB->WKSEQREL
         DET->WKIMPORT  := CAB->WKIMPORT
         DET->WKIMPODE  := QRY->EEC_IMPODE
         DET->WKPERIODO := IF(Empty(dDtIni).And.Empty(dDtFim),STR0011,Dtoc(dDtIni)+STR0012+Dtoc(dDtFim)) //"ALL"###" TO "
         DET->WKNRINVO  := QRY->EEC_NRINVO        
         #IFDEF TOP
            IF TCSRVTYPE() <> "AS/400"
               DET->WKDTINVO := TransData(QRY->EEC_DTINVO)
               DET->WKCBVCT  := TransData(QRY->EEQ_VCT)
               DET->WKDTEMBA := TransDAta(QRY->EEC_DTEMBA)
               DET->WKCBPGT  := TransData(QRY->EEQ_PGT)
            ELSE
         #ENDIF
               DET->WKDTINVO := Dtoc(QRY->EEC_DTINVO)
               DET->WKCBVCT  := Dtoc(QRY->EEQ_VCT)
               DET->WKDTEMBA := Dtoc(QRY->EEC_DTEMBA)
               DET->WKCBPGT  := Dtoc(QRY->EEQ_PGT)
         #IFDEF TOP
            ENDIF
         #ENDIF
         DET->WKPREEMB := QRY->EEC_PREEMB                 
         DET->WKTOTPED := QRY->EEQ_VL
         DET->WKCBNR   := QRY->EEQ_NROP

         IF cProcAnt <> QRY->EEC_PREEMB
            cProcAnt := QRY->EEC_PREEMB        
            lFlag    := ! lFlag
         Endif

         DET->WKFLAG  := IF(lFlag,"1","0")
         
         If !Empty(QRY->EEQ_PGT)
            DET->WKTOTCLOS := DET->WKTOTPED            
         Else
            DET->WKTOTOPEN := DET->WKTOTPED
         EndIF          
                  
         lZero := .F.
         
         QRY->(dbSkip())
      Enddo      
   EndDo

   QRY->(dbCloseArea())
  
End Sequence

Return lRet

*--------------------------------------------------------------------         
STATIC FUNCTION TELAGETS
*--------------------------------------------------------------------
Local oDlg,;
      bOk     := {|| nOpc := 1,if(fConfData(dDtFim,dDtIni),oDlg:End(),"")},;
      bCancel := {|| oDlg:End() },;
      lRet    := .f.,;
      nOpc    := 0
                               
Begin Sequence

   Define MsDialog oDlg Title cTITRPT From 9,0 To 19,50 Of oMainWnd  // 33

      @ 15,09 Say STR0008 Pixel //"Importador"
      @ 15,49 MsGet cImport Size 40,8 Valid(Empty(cImport).or.ExistCpo("SA1")) F3("SA1") Pixel

      @ 30,05 To 71,175 Label STR0013 Pixel  //"Período" // 126
      
      @ 39,09 Say STR0009      Pixel //"Data Inicial"
      @ 39,49 MsGet dDtIni Size 40,8  Pixel
      
      @ 52,09 Say STR0010        PIXEL //"Data Final"
      @ 52,49 MsGet dDtFim Size 40,8  PIXEL //Valid(fConfData(dDtFim,dDtIni)) Pixel

   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
  
   If nOpc == 1
      lRet  := .t.
   EndIf 

End Sequence

Return(lRet)
*--------------------------------------------------------------------   
Static Function fConfData(dFim,dIni)
Local lRet  := .f.

Begin Sequence

    If !Empty(dFim) .or. !Empty(dIni) 
       If dFim < dIni .or. Empty(dIni)    
          MsgInfo(STR0007,STR0004) //"Data Final Não Pode Ser Menor Que Data Inicial"###"Aviso"
       Else
          lRet := .t.
       EndIf   
     Else
       lRet := .t.
     EndIf
     
End Sequence

Return(lRet)

#IFDEF TOP
   *-----------------------------------*
   Static Function TransData(sData)
   *-----------------------------------*
   If Empty(sData)
      sData := "  /  /  "
   Else
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),3,2)
   Endif

   Return sData
#ENDIF