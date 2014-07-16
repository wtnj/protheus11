#INCLUDE "EECPRL02.ch"
/*
Programa        : EECPRL02.PRW
Objetivo        : Impressao Open Orders
Autor           : Cristiane C. Figueiredo
Data/Hora       : 29/05/2000 20:50
Obs.            :

*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL02
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 29/05/2000 20:50       
Revisao     :
Obs.        :
*/
User Function EECPRL02

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t., lPais:=.f., lCliente
Local lPrimit, dETA := AVCtod(""), dETS := AVCtod(""), lAber
Local cEmbarque := ""

Local cEmbarc :="", lFamilia, lProduto, cTransp := "", cDtReq := ""

Local cPaisImpo:=""

Private tg_lRet  := .f.
Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cPais    := SPACE(AVSX3("YA_CODGI",3))
Private cFamilia := SPACE(AVSX3("YC_COD",3))  
Private cCliente := SPACE(AVSX3("A1_COD",3))  
Private cProd    := SPACE(AVSX3("B1_COD",3))  
Private cDest    := SPACE(AVSX3("EE3_NOME",3))
Private cFax     := SPACE(20)
Private cCopia1  := SPACE(AVSX3("EE3_NOME",3))
Private cFax1    := SPACE(20)
Private cCopia2  := SPACE(AVSX3("EE3_NOME",3))
Private cFax2    := SPACE(20)

Private cArqRpt, cTitRpt

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("52","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("52","EEA_COD"),"EEA_TITULO"))
   Endif

   cNomDbfC:= "WORK02C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL" ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"PAIS"   ,"C",60,0})
   AADD(aCamposC,{"PARA1"  ,"C",60,0})
   AADD(aCamposC,{"C_C1"   ,"C",60,0})
   AADD(aCamposC,{"PARA2"  ,"C",60,0})
   AADD(aCamposC,{"C_C2"   ,"C",60,0})


   cNomDbfD:= "WORK02D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL"  ,"C", 8,0})
   AADD(aCamposD,{"PROCESSO","C",20,0})
   AADD(aCamposD,{"PEDCLI"  ,"C",20,0})
   AADD(aCamposD,{"APELIDO" ,"C",20,0})
   AADD(aCamposD,{"PAIS"    ,"C",20,0})  
   AADD(aCamposD,{"DTPED"   ,"D", 8,0})
   AADD(aCamposD,{"PRODUTO" ,"C",20,0})
   AADD(aCamposD,{"QTDE_KG" ,"N",15,2})
   AADD(aCamposD,{"REQUIRED","C",14,0})
   AADD(aCamposD,{"TRANSP"  ,"C",30,0})
   AADD(aCamposD,{"DTETS"   ,"D", 8,0})
   AADD(aCamposD,{"DTETA"   ,"D", 8,0})
   AADD(aCamposD,{"REMARKS" ,"C",30,0})
   
   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)
   
   IF ! TelaGets()
      lRet := .F.
      BREAK
   Endif
   
   EE7->(dbSetOrder(1))
   EE7->(dbSeek(xFilial()))   
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := "ALL"
   Else   
      cPeriodo := "FROM "+ DtoC(dDtIni) + " TO " + DtoC(dDtFim)
   Endif
      
   IF empty(cPais)
      cPais := "ALL" 
   ENDIF
     
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
     
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->PAIS    := IF(cPais <> "ALL",Posicione("SYA",1,xFilial("SYA")+cPais,"YA_NOIDIOM"),cPais)
   CAB->PARA1   := Alltrim(cDest)   + If(Empty(cFax), ""," Fax: " + cFax)
   CAB->C_C1    := if(Empty(cCopia1),"","C/C1: " +Alltrim(cCopia1) + If(Empty(cFax1),""," Fax: " + cFax1))
   CAB->C_C2    := if(Empty(cCopia2),"","C/C2: " +Alltrim(cCopia2) + If(Empty(cFax2),""," Fax: " + cFax2))
                                                                                                
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EE7->(!Eof() .AND. EE7->EE7_FILIAL==xFilial("EE7"))
   
     IF (!Empty(dDtIni) .And. EE7->EE7_DTPEDI < dDtIni) .Or. (!Empty(dDtFim) .And. EE7->EE7_DTPEDI > dDtFim)
        EE7->(dbSkip())
        Loop
     Endif
     
  
     // ** by JBJ - 23/11/2001 - 17:45  (Inicio...)

     /*
     lPais   := cPais <> "ALL" .and.;
                (!Empty(EE7->EE7_DEST) .And. cPais <> Posicione("SY9",2,XFILIAL("SY9")+EE7->EE7_DEST,"Y9_PAIS") .Or.;
                 cPais <> Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"A1_PAIS"))               
     */
     If cPais <> "ALL"
        // LCS - 23/09/2002 -
        //If !Empty(EE7->EE7_DEST)        
        //   // ** Busca o Pais a partir do destino do processo ...
        //   cPaisDest:=Posicione("SY9",2,XFILIAL("SY9")+EE7->EE7_DEST,"Y9_PAIS")         
        //   If !Empty(cPaisDest)
        //      If (cPais <> cPaisDest,lPais:=.T.,"")                                               
        //   EndIf  
        //EndIf
        //If !lPais
           // ** Busca o pais a partir do importador ...
           cPaisImpo:=Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"A1_PAIS")                      

           If !Empty(cPaisImpo)
              If (cPais <> cPaisImpo, lPais:=.T., lPais:=.F.)
           Else 
              lPais:=.F.
           EndIf             
        //EndIf
     Else
        lPais:=.f.
     EndIf   
     // ** (Fim)   
     
     lCliente:= !(empty(cCliente)).and. cCliente <> EE7->EE7_IMPORT          
        
     IF ( lPais .or. lCliente)
        EE7->(DBSKIP())
        Loop
     ENDIF
    
     lPrimIt := .T.
     
     EE8->(DBSETORDER(1))
     EE8->(DBSEEK(XFILIAL("EE8")+EE7->EE7_PEDIDO))
     
     WHILE ( EE8->(!EOF() .AND. EE8->EE8_FILIAL==xFilial("EE8")) .and. EE7->EE7_PEDIDO == EE8->EE8_PEDIDO)
        
        dETA := AVCTOD("  /  /  ")
        dETS := AVCTOD("  /  /  ")
		      lAber:= .F.  

        EE9->(DBSETORDER(1))
        IF EE9->(DBSEEK(XFILIAL("EE9")+EE7->EE7_PEDIDO))
           EEC->(DBSETORDER(1))
           IF EEC->(DBSEEK(XFILIAL("EEC")+EE9->EE9_PREEMB))
              cEmbarque := EEC->EEC_PREEMB
              dETA := EEC->EEC_ETADES
              dETS := EEC->EEC_ETD
              lAber:= !Empty(EEC->EEC_DTCONH)
         			  cEMBARC:= EEC->EEC_EMBARC
       		   ENDIF
        ENDIF   
        
        lFamilia:= !(empty(cFamilia)) .and. EE8->EE8_FPCOD <> cFAMILIA
        lProduto:= !(empty(cProd)) .and. EE8->EE8_COD_I <> cProd
        
        IF lFamilia .or. lProduto .or. lAber
           EE8->(DBSKIP())
           Loop
        ENDIF

      		IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EE7->EE7_VIA,"YQ_COD_DI"),1) == "7"
           cTRANSP := BuscaEmpresa(cEmbarque,"Q","B")
           ctransp := EEB->EEB_CODAGE
        Else
           cTransp := cEMBARC
        Endif   
        
        IF EE8->EE8_DTENTR <= DDATABASE
           cDtReq := "IMMEDIATE"
        Else
           cDtReq := cmonth(EE8->EE8_DTENTR) + "/" + STR(YEAR(EE8->EE8_DTENTR),4)
        Endif   
        
        DET->(DBAPPEND())
        DET->SEQREL  := cSeqRel 
        DET->PRODUTO := EE8->EE8_COD_I
        DET->QTDE_KG := EE8->EE8_PSLQTO
        DET->REQUIRED:= cDTREQ
        
        IF ( lPrimIt )
           DET->PROCESSO:= EE7->EE7_PEDIDO
           DET->PEDCLI  := EE7->EE7_REFIMP
           DET->APELIDO := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"A1_NREDUZ") // EE7->EE7_IMPODE
           DET->DTPED   := EE7->EE7_DTPEDI
           DET->PAIS    := POSICIONE("SYA",1,XFILIAL("SYA")+Posicione("SY9",2,XFILIAL("SY9")+EE7->EE7_DEST,"Y9_PAIS"),"YA_DESCR")
           DET->TRANSP  := cTRANSP
           DET->DTETS   := dETS
           DET->DTETA   := dETA
           DET->REMARKS := MSMM(POSICIONE("EE4",1,XFILIAL("EE4")+EE7->EE7_MOTSIT,"EE4_TEXTO"),25,1)
           lPrimIt := .F.
           lZero := .f.
        ENDIF
        DET->(MSUNLOCK())
        EE8->(DBSKIP())
     END
     
     EE7->(DBSKIP())
   Enddo   
   
   IF ( lZero )
      MSGINFO(STR0001, STR0002) //"Intervalo sem dados para impress�o"###"Aviso"
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
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 33,50 OF oMainWnd
       
      @  20,05 SAY STR0003 PIXEL //"Data Inicial"
      @  20,40 MSGET dDtIni SIZE 40,8 PIXEL
      
      @  33,05 SAY STR0004 PIXEL //"Data Final"
      @  33,40 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim,dDtIni) PIXEL
      
      @  46,05 SAY STR0005 PIXEL //"Pais"
      @  46,40 MSGET cPais SIZE 20,8 pict AVSX3("YA_PAIS",6) F3 "SYA" valid (Empty(cPais).or.ExistCpo("SYA")) PIXEL
															
      @  59,05 SAY STR0006 PIXEL //"Familia"
      @  59,40 MSGET cFamilia SIZE 20,8  pict AVSX3("YC_COD",6) valid (Empty(cFamilia).or.ExistCpo("SYC")) F3 "SYC" PIXEL
																
      @  72,05 SAY STR0007 PIXEL //"Cliente"
      
      // ** by JBJ 22/11/2001 - 14:53
      @  72,40 MSGET cCliente SIZE 40,8  pict AVSX3("A1_COD",6) valid (Empty(cCliente).or.ExistCpo("SA1")) F3 "CLI" PIXEL																           
      //@  72,40 MSGET cCliente SIZE 40,8  pict AVSX3("A1_COD",6) valid (Empty(cCliente).or.ExistCpo("SA1")) F3 "SA1" PIXEL																      
      
      @  85,05 SAY STR0008 PIXEL //"Produto"
      @  85,40 MSGET cProd SIZE 60,8  pict AVSX3("B1_COD",6) valid (Empty(cProd) .or. ExistCpo("SB1")) F3 "SB1" PIXEL  
      															
      @  98,05 SAY STR0009 PIXEL //"Destinatario"
      @  98,40 MSGET cDest SIZE 115,8 pict AVSX3("EE3_NOME",6) valid (IF(Empty(cFax),cFax := IF(ALLTRIM(cDest)==ALLTRIM(EE3->EE3_NOME),EE3->EE3_FAX,SPACE(20)),),.t.) F3 "E33" PIXEL
																
      @ 111,05 SAY STR0010 PIXEL //"Fax"
      @ 111,40 MSGET cFax SIZE 115,8 PIXEL
																
      @ 124,05 SAY STR0011 PIXEL //"Copia 1 para"
      @ 124,40 MSGET cCopia1 SIZE 115,8 pict AVSX3("EE3_NOME",6) F3 "E33" valid (IF(Empty(cFax1),cFax1:= IF(ALLTRIM(cDest)==ALLTRIM(EE3->EE3_NOME),EE3->EE3_FAX,SPACE(20)),),.t.) PIXEL
																
      @ 137,05 SAY STR0012 PIXEL //"Fax 1"
      @ 137,40 MSGET cFax1 SIZE 115,8 PIXEL
																
      @ 150,05 SAY STR0013 PIXEL //"Copia 2 para"
      @ 150,40 MSGET cCopia2 SIZE 115,8  pict AVSX3("EE3_NOME",6) F3 "E33" valid (IF(Empty(cFax2),cFax2:= IF(ALLTRIM(cDest)==ALLTRIM(EE3->EE3_NOME),EE3->EE3_FAX,SPACE(20)),),.t.) PIXEL
		 													
      @ 163,05 SAY STR0014 PIXEL //"Fax 2"
      @ 163,40 MSGET cFax2 SIZE 115,8 PIXEL
			  
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
      MsgInfo(STR0015,STR0002) //"Data Final n�o pode ser menor que Data Inicial"###"Aviso"
   Else
      lRet := .t.
   Endif   

End Sequence
      
Return lRet                                                              


*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL02.PRW                                                 *
*------------------------------------------------------------------------------*
