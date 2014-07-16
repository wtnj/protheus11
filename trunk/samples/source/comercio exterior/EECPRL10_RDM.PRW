#INCLUDE "EECPRL10.ch"
/*
Programa        : EECPRL10.PRW
Objetivo        : Controle de Embarque
Autor           : Cristiane C. Figueiredo
Data/Hora       : 04/06/2000 14:40
Obs.            : 

*/
// Alterado por Heder M Oliveira - 6/13/2000
#include "EECRDM.CH"

/*
Funcao      : EECPRL10
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 04/06/2000 14:40
Revisao     :
Obs.        :
*/

User Function EECPRL10

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw
Local aCodRel:=array(22)
Local cEmbarque := ""
Local dETA      := AVCTOD("  /  /    ")
Local dETD      := AVCTOD("  /  /    ")
Local dETADES   := AVCTOD("  /  /    ")
Local lAber     := .T.
Local cEMBARC   := ""
Local cLC       := ""
Local nX,cPaisDoc, cEmbPed, cRe:="", cSD:=""
   
Private cProces  := SPACE(AVSX3("EE7_PEDIDO",3)) 
Private cVolume  := SPACE(AVSX3("EE5_DESC",3))   
Private lTpEmb   := .f.

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("61","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("61","EEA_COD"),"EEA_TITULO"))
   Endif
   
   //Vetor de codigos de relatorio definido por cliente
   aCodRel[1]:="01"  //Order Acknowledgment
   aCodRel[2]:="02"  //Order Confirmation
   aCodRel[3]:=""    //Envio Saque
   aCodRel[4]:="04"  //Saque
   aCodRel[5]:=""    //Certificado de Origem
   aCodRel[6]:="13"  //Packing List
   aCodRel[7]:="28"  //Instrucao de Embarque
   aCodRel[8]:="31"  //Carta Remessa Doctos AO CLI
   aCodRel[9]:="05"  //Booking
   aCodRel[10]:="10" //Sol. de Paletizacao
   aCodRel[11]:="07" //Sol. de Inspecao
   aCodRel[12]:="08" //Confirmacao de Inspecao
   aCodRel[13]:="17" //Sol. de Laudo de Analise
   aCodRel[14]:="19" //Sol. de RE
   aCodRel[15]:="27" //Env. do Saque ao Cliente
   aCodRel[16]:=""   //Nota Fiscal
   aCodRel[17]:=""   //Nota Fiscal Complementar
   aCodRel[18]:="37" //Commercail Invoice
   aCodRel[19]:="12" //Carta Remessa Doctos ao Banco
   aCodRel[20]:="20" //Reserva de Praca
   aCodRel[21]:=""   //Liberacao de Credito
   aCodRel[22]:="30" //Cobertura de Seguro de Exportacao

   cNomDbfC:= "WORK11C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL"  ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA" ,"C",60,0})
   AADD(aCamposC,{"CLIENTE" ,"C",30,0})
   AADD(aCamposC,{"REF"     ,"C",40,0})
   AADD(aCamposC,{"NEXPORT" ,"C",20,0})
   AADD(aCamposC,{"DESTINO" ,"C",40,0})
   AADD(aCamposC,{"LC"      ,"C", 3,0})
   AADD(aCamposC,{"VOLUME"  ,"C",30,0})
   AADD(aCamposC,{"AGENCIA" ,"C",40,0})
   AADD(aCamposC,{"CONTATO" ,"C",35,0})
   AADD(aCamposC,{"NAVIO"   ,"C",30,0})
   AADD(aCamposC,{"ETAETS"  ,"C",25,0})
   AADD(aCamposC,{"ETADEST" ,"D", 8,0})
   AADD(aCamposC,{"TERMINAL","C",30,0})
   AADD(aCamposC,{"NRESERV" ,"C",30,0})
   AADD(aCamposC,{"OUTROS"  ,"C",30,0})
   AADD(aCamposC,{"NRSD"    ,"C",20,0})
   AADD(aCamposC,{"NRRE"    ,"C",20,0})
   AADD(aCamposC,{"ETA"     ,"D", 8,0})
   AADD(aCamposC,{"ETD"     ,"D", 8,0})
   AADD(aCamposC,{"EFETUAR_01","C", 1,0}) //ORDER ACKNOWLEDGMENT
   AADD(aCamposC,{"EFETUAD_01","C", 2,0})
   AADD(aCamposC,{"EFETUAR_02","C", 1,0}) //ORDER CONFIRMATION
   AADD(aCamposC,{"EFETUAD_02","C", 2,0})
   AADD(aCamposC,{"EFETUAR_03","C", 1,0}) //ENVIO SAQUE
   AADD(aCamposC,{"EFETUAD_03","C", 2,0})
   AADD(aCamposC,{"EFETUAR_04","C", 1,0}) //SAQUE 
   AADD(aCamposC,{"EFETUAD_04","C", 2,0})
   AADD(aCamposC,{"EFETUAR_05","C", 1,0}) //CERTIFICADO DE ORIGEM
   AADD(aCamposC,{"EFETUAD_05","C", 2,0})
   AADD(aCamposC,{"EFETUAR_06","C", 1,0}) //PACKING LIST
   AADD(aCamposC,{"EFETUAD_06","C", 2,0})
   AADD(aCamposC,{"EFETUAR_07","C", 1,0}) //INSTRUCAO DE EMBARQUE
   AADD(aCamposC,{"EFETUAD_07","C", 2,0})
   AADD(aCamposC,{"EFETUAR_08","C", 1,0}) //CARTA REMESSA DOCTOS
   AADD(aCamposC,{"EFETUAD_08","C", 2,0})
   AADD(aCamposC,{"EFETUAR_09","C", 1,0}) //BOOKING
   AADD(aCamposC,{"EFETUAD_09","C", 2,0})
   AADD(aCamposC,{"EFETUAR_10","C", 1,0}) //SOL. PALETIZACAO
   AADD(aCamposC,{"EFETUAD_10","C", 2,0})
   AADD(aCamposC,{"EFETUAR_11","C", 1,0}) //SOL. INSPECAO
   AADD(aCamposC,{"EFETUAD_11","C", 2,0})
   AADD(aCamposC,{"EFETUAR_12","C", 1,0}) //CONFIRMACAO INSPECAO
   AADD(aCamposC,{"EFETUAD_12","C", 2,0})
   AADD(aCamposC,{"EFETUAR_13","C", 1,0}) //SOL.LAUDO ANALISE
   AADD(aCamposC,{"EFETUAD_13","C", 2,0})
   AADD(aCamposC,{"EFETUAR_14","C", 1,0}) //SOL. DE R.E.
   AADD(aCamposC,{"EFETUAD_14","C", 2,0})
   AADD(aCamposC,{"EFETUAR_15","C", 1,0}) //ENV. SAQUE AO CLIENTE
   AADD(aCamposC,{"EFETUAD_15","C", 2,0})
   AADD(aCamposC,{"EFETUAR_16","C", 1,0}) //NOTA FISCAL
   AADD(aCamposC,{"EFETUAD_16","C", 2,0})
   AADD(aCamposC,{"EFETUAR_17","C", 1,0}) //NF COMPLEMENTAR
   AADD(aCamposC,{"EFETUAD_17","C", 2,0})
   AADD(aCamposC,{"EFETUAR_18","C", 1,0}) //COMMERCIAL INVOICE
   AADD(aCamposC,{"EFETUAD_18","C", 2,0})
   AADD(aCamposC,{"EFETUAR_19","C", 1,0}) //CARTA REMESSA DOCTOS AO BANCO
   AADD(aCamposC,{"EFETUAD_19","C", 2,0})
   AADD(aCamposC,{"EFETUAR_20","C", 1,0}) //RESERVA DE PRACA
   AADD(aCamposC,{"EFETUAD_20","C", 2,0})
   AADD(aCamposC,{"EFETUAR_21","C", 1,0}) //LIBERACAO CREDITO
   AADD(aCamposC,{"EFETUAD_21","C", 2,0})
   AADD(aCamposC,{"EFETUAR_22","C", 1,0}) //COBERTURA DE SEGURO DE EXPORTACAO
   AADD(aCamposC,{"EFETUAD_22","C", 2,0})


   cNomDbfD:= "WORK11D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL" ,"C", 8,0})
   AADD(aCamposD,{"ORDEM"  ,"C",60,0})
   AADD(aCamposD,{"PRODUTO","C",30,0})
   AADD(aCamposD,{"QTDE"   ,"N",10,0})
   AADD(aCamposD,{"VLUNIT" ,"N",15,2})
   AADD(aCamposD,{"VLTOTAL","N",15,2})

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   cEmbPed := Posicione("EE9",1,XFILIAL("EE9")+EE7->EE7_PEDIDO, "EE9_PREEMB")
   If !lTpEmb
      EEC->(DBSETORDER(1))
      EEC->(DBSEEK(XFILIAL("EEC")+cEmbPed))
   endif   
   cEmbarque:= If(lTpemb,EEC->EEC_PREEMB,cEmbPed)
   dETA     := If(lTpemb.OR.!Empty(cEmbPed),EEC->EEC_ETA,AVCTOD("  /  /    "))
   dETD     := If(lTpemb.OR.!Empty(cEmbPed),EEC->EEC_ETD,AVCTOD("  /  /    "))
   dETADES  := If(lTpemb.OR.!Empty(cEmbPed),EEC->EEC_ETADES,AVCTOD("  /  /    "))
   lAber    := If(lTpemb.OR.!Empty(cEmbPed),!Empty(EEC->EEC_DTCONH),.f.)
   cEMBARC  := If(lTpemb.OR.!Empty(cEmbPed),EEC->EEC_EMBARC,"")
   cLC      := If(lTpemb.OR.!Empty(cEmbPed),EEC->EEC_LC_NUM,"")
   
   If !lTpEmb
      EE8->(DBSETORDER(1))
      EE8->(DBSEEK(XFILIAL("EE8")+EE7->EE7_PEDIDO))
      While EE8->(!Eof()) .AND. XFILIAL("EE8")+EE8->EE8_PEDIDO == EE7->EE7_FILIAL+EE7->EE7_PEDIDO
    
         DET->(DBAPPEND())
         DET->SEQREL    := cSeqRel 
         DET->PRODUTO   := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
         DET->QTDE      := EE8->EE8_SLDINI
         DET->VLUNIT    := EE8->EE8_PRECOI
         DET->VLTOTAL   := EE8->EE8_PRCINC
    
         EE8->(DBSKIP())

      End
      // acha sd e re quando escolhido pedido que ja tenha embarque
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+cEmbPed))

      While EE9->(!Eof()) .AND. XFILIAL("EE9")+EE9->EE9_PREEMB == EE9->EE9_FILIAL+cEmbPed
    
        If empty(cRE)
           cRE := alltrim(EE9->EE9_RE)
        eNDIF   
         If empty(cSD)
           cSD := alltrim(EE9->EE9_NRSD)
        eNDIF   
        EE9->(DBSKIP())
     
     End
   Else
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
      While EE9->(!Eof()) .AND. XFILIAL("EE9")+EE9->EE9_PREEMB == EEC->EEC_FILIAL+EEC->EEC_PREEMB
    
         DET->(DBAPPEND())
         DET->SEQREL    := cSeqRel 
         DET->PRODUTO   := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
         DET->QTDE      := EE9->EE9_SLDINI
         DET->VLUNIT    := EE9->EE9_PRECOI
         DET->VLTOTAL   := EE9->EE9_PRCINC
         If empty(cRE)
            cRE := alltrim(EE9->EE9_RE)
         eNDIF   
         If empty(cSD)
            cSD := alltrim(EE9->EE9_NRSD)
         eNDIF   
         EE9->(DBSKIP())
      End
   endif   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->CLIENTE := Posicione("SA1",1,xFilial("SA1")+IF(lTpEmb,EEC->EEC_IMPORT,EE7->EE7_IMPORT),"A1_NREDUZ")
   CAB->EMPRESA := SM0->M0_NOME
   CAB->LC      := IF(Empty(cLC),STR0001,STR0002) //"NAO"###"SIM"
   CAB->REF     := IF(!lTpEmb,EE7->EE7_REFIMP,EEC->EEC_REFIMP)
   CAB->NEXPORT := IF(!lTpEmb,EE7->EE7_PEDIDO,"")
   CAB->VOLUME  := cVolume
   if lTpemb
      CAB->DESTINO := IF(EMPTY(EEC->EEC_DEST),"",POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST,"Y9_DESCR"))
      IF LEFT(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
         CAB->AGENCIA:=BuscaEmpresa(EEC->EEC_PREEMB,"Q","B")
      ELSE
         CAB->AGENCIA:=BuscaEmpresa(EEC->EEC_PREEMB,"Q","1")
      ENDIF
      cPaisDoc := AVKEY(EEC->EEC_PAISET,"EE1_PAIS")
   Else
      CAB->DESTINO := IF(EMPTY(EE7->EE7_DEST),"",POSICIONE("SY9",2,XFILIAL("SY9")+EE7->EE7_DEST,"Y9_DESCR"))
      IF LEFT(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
         CAB->AGENCIA:=BuscaEmpresa(EE7->EE7_PEDIDO,"P","B")
      ELSE
         CAB->AGENCIA:=BuscaEmpresa(EE7->EE7_PEDIDO,"P","1")
      ENDIF
      cPaisDoc := AVKEY(Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT,"A1_PAIS"),"EE1_PAIS")
   Endif
   IF !EEB->(Eof())
      CAB->CONTATO := EECCONTATO("E",EEB->EEB_CODAGE,,"1",1)
   ENDIF
   CAB->NAVIO   := Posicione("EE6",1,xFILIAL("EE6")+cEMBARC,"EE6_NOME")
   CAB->ETA     := DETA
   CAB->ETD     := DETD
   CAB->ETADEST := DETADES
   CAB->TERMINAL:= "" //A SER LANCADO PELO USUARIO NA FOLHA - NAO TEMOS CAMPO COM ESTE DADO
   CAB->NRESERV := "" //A SER LANCADO PELO USUARIO NA FOLHA - NAO TEMOS CAMPO COM ESTE DADO
   CAB->OUTROS  := "" //A SER LANCADO PELO USUARIO NA FOLHA - NAO TEMOS CAMPO COM ESTE DADO
   CAB->NRRE    := TRANSF(cRE, AVSX3("EE9_RE",6))
   CAB->NRSD    := TRANSF(cSD, AVSX3("EE9_NRSD",6))

   //carregar work com documentos exigidos pelo pais
   EE1->(DBSETORDER(2)) //FILIAL+TIPORELAC+DOCUMENTO+PAIS
   
   FOR nX:=1 TO LEN(aCodRel)
    IF !(Empty(aCodRel[nX])) .AND. EE1->(DBSEEK(XFILIAL("EE1")+TR_ARQ+AVKEY(aCodRel[nX],"EE1_DOCUM")+cPaisDoc))
      CAB->(FIELDPUT(FIELDPOS("EFETUAR_"+STRZERO(nX,2)),"X"))
    ENDIF
   NEXT
   
End

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

   Local nOpc := 0, cPictProc
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
      
   Begin Sequence
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 16,50 OF oMainWnd
      If AVSX3("EE7_PEDIDO",6) == AVSX3("EEC_PREEMB",6)
         cPictPro := AVSX3("EE7_PEDIDO",6)
      Endif
      @  20,05 SAY STR0003 PIXEL //"Processo"
     If Empty(cPictPro)
         @  20,60 MSGET cProces SIZE 115,8 F3 "EYC" valid (fProcEmb(cProces)) PIXEL
      Else
         @  20,60 MSGET cProces PICT cPictProc SIZE 115,8 F3 "EYC" valid fProcEmb(cProces) PIXEL
      Endif   
      @  33,05 SAY STR0004 PIXEL //"Volume"
      @  33,60 MSGET cVolume SIZE 115,8 PIXEL
      
      ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

      IF nOpc == 1
         lret := .t.
      ENDIF
      
   End Sequence

   Return lRet

/*
Funcao      : fProcEmb(cProc)
Parametros  : numero do processo
Retorno     : .T. ou .F.
Objetivos   : Validar entrada de dados e trazer Descricao do volume
Autor       : Cristiane de Campos Figueiredo
Data/Hora   : 05/09/00 10:05
Revisao     :
Obs.        :
*/
Static Function fProcEmb(cProc)
   LOCAL lExPro, lRet := .T.
   Begin Sequence
      EEC->(DBSETORDER(1))
      EE7->(DBSETORDER(1))
      lTpEmb := EEC->(DBSEEK(XFILIAL("EEC")+cProc)) .and. EEC->EEC_STATUS <> ST_PC
      lExPro := EE7->(DBSEEK(XFILIAL("EE7")+cProc)) .and. EE7->EE7_STATUS <> ST_PC
      
      IF !lTpEmb .and. !lExPro
         HELP(" ",1,"REGNOIS")
         lRet := .f.
      Endif

      If Empty(cVolume)
         If lTpEmb 
            cVOLUME:=posicione("EE5",1,XFILIAL("EE5")+AVKEY(EEC->EEC_EMBAFI,"EE5_COD"),"EE5_DESC")
         Else 
            cVOLUME:=posicione("EE5",1,XFILIAL("EE5")+AVKEY(EE7->EE7_EMBAFI,"EE5_COD"),"EE5_DESC")
         Endif
     Endif
     
   End Sequence

   Return lRet

*-----------------------------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL10.PRW                                                                        *
*-----------------------------------------------------------------------------------------------------*