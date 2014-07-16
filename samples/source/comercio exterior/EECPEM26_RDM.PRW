#INCLUDE "EECPEM26.ch"
/*
Programa        : EECPEM26.PRW
Objetivo        : Memorando de Exportacao 
Autor           : Heder M Oliveira
Data/Hora       : 20/11/99 14:47
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

#xTranslate xLin1(<nVar>) => (<nVar> := <nVar>+10)
#xTranslate xLin2(<nVar>) => (<nVar> := <nVar>+08)

/*
Funcao      : EECPEM26
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira
              08/12/1999 10:16     
Obs.        :
*/
User Function EECPEM26

Local lRet := .f.
Local cRpt := "MEMEXP.RPT"

Local nCont

Private cSEQMEM,dDTIPMEM,cNomeExp,cEndExp,cCgcExp,cInscExp,cCidExp  
Private cEstExp,cNFExp,cSerieExp,dNFExp,cExpNro,cObsExp,cREExp,dREExp   
Private cDEExp,dDEExp,cCEExp,dCEExp,cProd1Exp,cProd2Exp,cProd3Exp
Private cDestExp,cDtExp,cAss1Exp,cAss2Exp,cNomeFab,cEndFab,cEnd2Fab 
Private cCgcFab,cInscFab,cCidFab,cEstFab,cNFFab,cSerieFab,cDtNFFab 

Begin Sequence
   cSEQMEM  := SPACE(20) //SEQUENCIA MEMORANDO
   dDTIPMEM := dDATABASE // DATA IMPRESSAO MEMORANDO
   cNomeExp := Space(60) // Nome do Exportador
   cEndExp  := Space(60) // Endereco do Exportador
   cCgcExp  := Space(30) // CGC
   cInscExp := Space(30) // Inscricao Estadual
   cCidExp  := Space(60) // Cidade
   cEstExp  := Space(10) // Estado
   cNFExp   := "" //Space(30) // Nota Fiscal
   cSerieExp:= Space(20) // Serie da Nota
   dNFExp   := AVCTOD("")  // Data da Nota
   cExpNro  := Space(20) // Exportacao Nro
   cObsExp  := INCSPACE(STR0001,60,.F.) //Space(60) // Observacoes //"CONVÊNIO ICMS 113 DE 13/09/96"
   cREExp   := Space(20) // Registro de Exportacao
   dREExp   := AVCTOD("")  // Dt.Registro de Exportacao
   cDEExp   := Space(20) // Despacho de Exportacao
   dDEExp   := AVCTOD("")  // Dt.Despacho de Exportacao
   cCEExp   := Space(20) // Conhecimento de Exportacao
   dCEExp   := AVCTOD("")  // Dt do Conhecimento de Exportacao
   cProd1Exp:= Space(60) // Produtos 1
   cProd2Exp:= Space(60) // Produtos 2
   cProd3Exp:= Space(60) // Produtos 3
   cDestExp := Space(20) // Destino
   cDtExp   := Space(60) // Data 
   cAss1Exp := Space(60) // Nome da Pessoa Assinante
   cAss2Exp := Space(60) // Cargo da pessoa assinante

   cNomeFab := Space(60) // Nome do Fabricante
   cEndFab  := Space(60) // Endereco
   cEnd2Fab := Space(60) // Complemento do End
   cCgcFab  := Space(30) // CGC
   cInscFab := Space(30) // Inscricao Estadual
   cCidFab  := Space(30) // cidade
   cEstFab  := Space(10) // Estado
   cNFFab   := Space(30) // Nota Fiscal
   cSerieFab:= Space(20) // Serie
   cDtNFFab := Space(10) // Data da NF
   
   IF ! TelaGets()
      Break
   Endif
   
   // Alterado por Heder M Oliveira - 1/6/2000
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
 
   FOR nCONT:=1 TO 4 //4 VIAS
      //adicionar registro no HEADER_P
      HEADER_P->(DBAPPEND())

      //gravar dados a serem editados
      HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
      
      HEADER_P->AVG_SEQREL := cSeqRel
	   HEADER_P->AVG_C01_10 := STR(nCONT,1) //NR. VIA
	   HEADER_P->AVG_C01_20 := cSEQMEM    // NR. SEQUENCIA
	   HEADER_P->AVG_C02_20 := DTOC(dDTIPMEM) //DATA IMPRESSAO
      HEADER_P->AVG_C01_60 := cNomeExp  // Nome do Exportador
      HEADER_P->AVG_C02_60 := cEndExp   // Endereco do Exportador
      HEADER_P->AVG_C01_30 := cCgcExp   // CGC
      HEADER_P->AVG_C02_30 := cInscExp  // Inscricao Estadual
      HEADER_P->AVG_C03_60 := cCidExp   // Cidade
      HEADER_P->AVG_C02_10 := cEstExp   // Estado
      HEADER_P->AVG_C03_30 := cNFExp    // Nota Fiscal
      HEADER_P->AVG_C03_20 := cSerieExp // Serie da Nota
      HEADER_P->AVG_C03_10 := Dtoc(dNFExp) // Data da Nota
      HEADER_P->AVG_C04_20 := cExpNro   // Exportacao Nro
      HEADER_P->AVG_C04_60 := cObsExp   // Observacoes
      HEADER_P->AVG_C05_20 := cREExp    // Registro de Exportacao
      HEADER_P->AVG_C04_10 := Dtoc(dREExp) // Dt.Registro de Exportacao
      HEADER_P->AVG_C06_20 := cDEExp    // Despacho de Exportacao
      HEADER_P->AVG_C05_10 := Dtoc(dDEExp) // Dt.Despacho de Exportacao
      HEADER_P->AVG_C07_20 := cCEExp    // Conhecimento de Exportacao
      HEADER_P->AVG_C06_10 := Dtoc(dCEExp) // Dt do Conhecimento de Exportacao
      HEADER_P->AVG_C07_60 := cProd1Exp // Produtos 1
      HEADER_P->AVG_C08_60 := cProd2Exp // Produtos 2
      HEADER_P->AVG_C09_60 := cProd3Exp // Produtos 3
      HEADER_P->AVG_C08_20 := cDestExp  // Destino
      HEADER_P->AVG_C10_60 := cDtExp    // Data 
      HEADER_P->AVG_C11_60 := cAss1Exp  // Nome da Pessoa Assinante
      HEADER_P->AVG_C12_60 := cAss2Exp  // Cargo da pessoa assinante

      HEADER_P->AVG_C13_60 := cNomeFab // Nome do Fabricante
      HEADER_P->AVG_C14_60 := cEndFab  // Endereco
      HEADER_P->AVG_C15_60 := cEnd2Fab // Complemento do End
      HEADER_P->AVG_C04_30 := cCgcFab  // CGC
      HEADER_P->AVG_C05_30 := cInscFab // Inscricao Estadual
      HEADER_P->AVG_C06_30 := cCidFab  // cidade
      HEADER_P->AVG_C07_10 := cEstFab  // Estado
      HEADER_P->AVG_C07_30 := cNFFab   // Nota Fiscal
      HEADER_P->AVG_C09_20 := cSerieFab// Serie
      HEADER_P->AVG_C16_60 := cDtNFFab // Data da NF
      
      // Gravar historico de doctos
      HEADER_H->(dbAppend())
      AvReplace("HEADER_P","HEADER_H")
      
   NEXT nCONT
   
   IF ! (lRet := AvgCrw32(cRpt,STR0002,cSeqRel)) //"Memorando de Exportacao"
      Break
   Endif
      
   //gravar historico de documentos
   E_HISTDOC(,STR0002,dDATABASE,,,cRPT,cSeqRel,"2",EEC->EEC_PREEMB) //"Memorando de Exportacao"
   
End Sequence

Return .F.

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local y := 0
Local bOk, bCancel

Local oFld,aFld

Begin Sequence
   
   M->EEC_PREEMB := Space(AVSX3("EEC_PREEMB",3))

   DEFINE MSDIALOG oDlg TITLE STR0003 FROM 7,10 TO 12,60 OF oMainWnd //"Memorando de Exportação"
   
      y := 20
      cDescCpo := Avsx3("EEC_PREEMB",AV_TITULO)
      @ y,05 SAY cDescCpo PIXEL
      @ y,45 MSGET M->EEC_PREEMB F3 "EEC" SIZE 50,08;
                    PICTURE AVSX3("EEC_PREEMB",6) ;
                    VALID ExistEmbarq() PIXEL 
      
      bOk     := {||lRet:=.t.,IF(ValidAll(oDlg),oDlg:End(),lRet:=.f.)}
      bCancel := {||oDlg:End()}

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,bOk,bCancel))
   
   IF ! lRet
      Break
   Endif 
   
   lRet := .f.
   
   LoadGets()
   
   DEFINE MSDIALOG oDlg TITLE STR0003 FROM 7,0 TO 28,80 OF oMainWnd //"Memorando de Exportação"
   
      oFld := TFolder():New(15,1,{STR0004, STR0005,STR0006},; //"Exportador"###"Exportador - Continuação"###"Fabricante"
                 {"EXP","CON","FAB"},oDlg,,,,.T.,.F.,314,145)
      
      // Atribui a fonte da dialog, para os folder's ...
      aFld := oFld:aDialogs
      aEval(aFld,{|x| x:SetFont(oDlg:oFont) }) 
      
      // Exportador ...
      TSay():New(y:=1,01,{|| STR0007},aFld[1],,,,,,.t.) //"Nome"
      TGet():New(xLin2(y),01,bSetGet(cNomeExp),aFld[1],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y),01,{|| STR0008},aFld[1],,,,,,.t.) //"Endereco"
      TGet():New(xLin2(y),01,bSetGet(cEndExp),aFld[1],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0009},aFld[1],,,,,,.t.) //"CGC"
      TSay():New(y, 80,{|| STR0010},aFld[1],,,,,,.t.) //"Inscriçao Estadual"
      TSay():New(y,160,{|| STR0011},aFld[1],,,,,,.t.) //"Cidade"
      TSay():New(y,250,{|| STR0012},aFld[1],,,,,,.t.) //"Estado"
      
      TGet():New(xLin2(y),01,bSetGet(cCGCExp),aFld[1],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,80,bSetGet(cInscExp),aFld[1],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,160,bSetGet(cCidExp),aFld[1],87,08,"@!",,,,,,,.t.,)
      TGet():New(y,250,bSetGet(cEstExp),aFld[1],57,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0013},aFld[1],,,,,,.t.) //"Nota Fiscal Nro."
      TSay():New(y,140,{|| STR0014},aFld[1],,,,,,.t.) //"Série"
      TSay():New(y,213,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      
      TGet():New(xLin2(y),01,bSetGet(cNFExp),aFld[1],137,08,"@!",,,,,,,.t.,)
      TGet():New(y,140,bSetGet(cSerieExp),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y,213,bSetGet(dNFExp),aFld[1],60,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0016},aFld[1],,,,,,.t.) //"Exportação Nro."
      TSay():New(y, 74,{|| STR0017},aFld[1],,,,,,.t.) //"Observações"
      
      TGet():New(xLin2(y),01,bSetGet(cExpNro),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y, 74,bSetGet(cObsExp),aFld[1],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0018},aFld[1],,,,,,.t.) //"Registro de Exportação Nro."
      TSay():New(y, 74,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      TSay():New(y,111,{|| STR0019},aFld[1],,,,,,.t.) //"Despacho Exportacao Nro."
      TSay():New(y,184,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      
      TGet():New(xLin2(y),01,bSetGet(cREExp),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y, 74,bSetGet(dREExp),aFld[1],40,08,"@!",,,,,,,.t.,)
      TGet():New(y,111,bSetGet(cDEExp),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y,184,bSetGet(dDEExp),aFld[1],40,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0020},aFld[1],,,,,,.t.) //"Conhecimento de Embarque"
      TSay():New(y, 74,{|| STR0015},aFld[1],,,,,,.t.) //"Data"
      
      TGet():New(xLin2(y),01,bSetGet(cCEExp),aFld[1],70,08,"@!",,,,,,,.t.,)
      TGet():New(y, 74,bSetGet(dCEExp),aFld[1],40,08,"@!",,,,,,,.t.,)
      
      // Exportador - Continuacao ...
	  y:=1
      
      TSay():New(y,01,{|| STR0021},aFld[2],,,,,,.t.) //"Destino"
      TGet():New(xLin2(y),01,bSetGet(cDestExp),aFld[2],70,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0022},aFld[2],,,,,,.t.) //"Descriminação dos Produtos"
      
      TGet():New(xLin2(y),01,bSetGet(cProd1Exp),aFld[2],210,08,"@!",,,,,,,.t.,)
      TGet():New(xLin1(y),01,bSetGet(cProd2Exp),aFld[2],210,08,"@!",,,,,,,.t.,)
      TGet():New(xLin1(y),01,bSetGet(cProd3Exp),aFld[2],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0023},aFld[2],,,,,,.t.) //"Data da Impressão"
      TGet():New(xLin2(y),01,bSetGet(cDtExp),aFld[2],210,08,"@!",,,,,,,.t.,)
      
	  TSay():New(xLin1(y), 01,{|| STR0024},aFld[2],,,,,,.t.) //"Assinatura"
      TGet():New(xLin2(y),01,bSetGet(cAss1Exp),aFld[2],210,08,"@!",,,,,,,.t.,,,,,,,,,"E33")
      TGet():New(xLin1(y),01,bSetGet(cAss2Exp),aFld[2],210,08,"@!",,,,,,,.t.)
      
	  TSay():New(xLin1(y), 01,{|| STR0025},aFld[2],,,,,,.t.) //"Seqüência do Memorando "
	  TSay():New(y,80,{|| STR0026},aFld[2],,,,,,.t.) //"Data do Memorando"
	  TGet():New(xLin2(y),01,bSetGet(cSEQMEM),aFld[2],70,08,"@!",,,,,,,.t.)
      TGet():New(y,80,bSetGet(dDTIPMEM),aFld[2],70,08,"@!",,,,,,,.t.)
       
      // Fabricante ...
      y := 1
      
      TSay():New(1,01,{|| STR0007},aFld[3],,,,,,.t.) //"Nome"
      TGet():New(xLin2(y),01,bSetGet(cNomeFab),aFld[3],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y),01,{|| STR0008},aFld[3],,,,,,.t.) //"Endereco"
      TGet():New(xLin2(y),01,bSetGet(cEndFab),aFld[3],210,08,"@!",,,,,,,.t.,)
      TGet():New(xLin1(y),01,bSetGet(cEnd2Fab),aFld[3],210,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0009},aFld[3],,,,,,.t.) //"CGC"
      TSay():New(y, 80,{|| STR0010},aFld[3],,,,,,.t.) //"Inscriçao Estadual"
      TSay():New(y,160,{|| STR0011},aFld[3],,,,,,.t.) //"Cidade"
      TSay():New(y,250,{|| STR0012},aFld[3],,,,,,.t.) //"Estado"
      
      TGet():New(xLin2(y),01,bSetGet(cCGCFab),aFld[3],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,80,bSetGet(cInscFab),aFld[3],77,08,"@!",,,,,,,.t.,)
      TGet():New(y,160,bSetGet(cCidFab),aFld[3],87,08,"@!",,,,,,,.t.,)
      TGet():New(y,250,bSetGet(cEstFab),aFld[3],57,08,"@!",,,,,,,.t.,)
      
      TSay():New(xLin1(y), 01,{|| STR0013},aFld[3],,,,,,.t.) //"Nota Fiscal Nro."
      TSay():New(y,140,{|| STR0014},aFld[3],,,,,,.t.) //"Série"
      TSay():New(y,213,{|| STR0015},aFld[3],,,,,,.t.) //"Data"
      
      TGet():New(xLin2(y),01,bSetGet(cNFFab),aFld[3],137,08,"@!",,,,,,,.t.,)
      TGet():New(y,140,bSetGet(cSerieFab),aFld[3],70,08,"@!",,,,,,,.t.,)
      TGet():New(y,213,bSetGet(cDtNFFab),aFld[3],60,08,"@!",,,,,,,.t.,)

      bOk     := {||lRet:=.t.,oDlg:End()}
      bCancel := {||oDlg:End()}
      
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

Return lRet

/*
Funcao      : LoadGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function LoadGets

Local aOrd := SaveOrd({"SA2","EE9","SYR","EEM"})
Local cAux

Begin Sequence

   SA2->(dbSetOrder(1))
   EE9->(dbSetOrder(3))
   SYR->(dbSetOrder(1))
   EEM->(dbSetOrder(2))

   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

   IF !EMPTY(EEC->EEC_EXPORT)
      SA2->(dbSeek(xFilial()+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
   ELSE
      SA2->(dbSeek(xFilial()+EEC->EEC_FORN+EEC->EEC_FOLOJA))
   ENDIF

   cNomeExp := Padr(Transf(SA2->A2_NOME,AVSX3("A2_NOME",6)),60)
   cEndExp  := Padr(Transf(SA2->A2_END,AVSX3("A2_END",6)),60)
   cCgcExp  := Padr(Transf(SA2->A2_CGC,AVSX3("A2_CGC",6)),30)
   cInscExp := Padr(Transf(SA2->A2_INSCR,AVSX3("A2_INSCR",6)),30)
   cCidExp  := Padr(Transf(SA2->A2_MUN,AVSX3("A2_MUN",6)),60)
   cEstExp  := Padr(Transf(SA2->A2_EST,AVSX3("A2_EST",6)),10)

   cNFExp   := "" // Nota Fiscal
   cSerieExp:= Space(20) // Serie da Nota
   dNFExp   := AVCTOD("")  // Data da Nota

   EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
   EEM->(dbEval({|| cNFExp:=cNFExp+IF(!EMPTY(cNFExp),";","")+ALLTRIM(EEM->EEM_NRNF),;
                    cSerieExp := EEM->EEM_SERIE,;
                    dNFExp := EEM->EEM_DTNF },{|| EEM->EEM_TIPONF=="1"},;
                {|| EEM_FILIAL==xFilial("EEM") .And. EEM_PREEMB == EEC->EEC_PREEMB .And. EEM_TIPOCA==EEM_NF}))

   cNFExp := Padr(cNFExp,30)
   cSerieExp:=Padr(cSerieExp,20)

   cExpNro  := Transf(EEC->EEC_PREEMB,AVSX3("EEC_PREEMB",6))

   cREExp   := Padr(Transf(EE9->EE9_RE,AVSX3("EE9_RE",6)),20) // Registro de Exportacao
   dREExp   := EE9->EE9_DTRE       // Dt.Registro de Exportacao

   cDEExp   := Padr(Transf(EE9->EE9_NRSD,AVSX3("EE9_NRSD",6)),20)//Space(20) // Despacho de Exportacao
   dDEExp   := EE9->EE9_DTAVRB //AVCTOD("")  // Dt.Despacho de Exportacao

   cCEExp   := Padr(Transf(EEC->EEC_NRCONH,AVSX3("EEC_NRCONH",6)),20) // Conhecimento de Exportacao
   dCEExp   := EEC->EEC_DTCONH  // Dt do Conhecimento de Exportacao
            
   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))
   cDestExp := Padr(POSICIONE("SYA",1,XFILIAL("SYA")+SYR->YR_PAIS_DE,"YA_DESCR"),20) // Destino

   cDtExp   := Padr(STR0027+AllTrim(Str(Day(dDataBase)))+STR0028+Upper(MesExtenso(Month(dDataBase)))+STR0028+Str(Year(dDataBase),4),60) //"SAO PAULO, "###" DE "###" DE "
   cAss1Exp := Padr(EECCONTATO(CD_SA2,SA2->A2_COD,SA2->A2_LOJA,"1",1),60) // Nome da Pessoa Assinante
   cAss2Exp := Padr(EECCONTATO(CD_SA2,SA2->A2_COD,SA2->A2_LOJA,"1",2),60) // Cargo da pessoa assinante

   SA2->(dbSeek(xFilial()+EE9->EE9_FABR+EE9->EE9_FALOJA))

   // Dados do Fabricante ...
   cNomeFab := Padr(SA2->A2_NOME,60)
   cEndFab  := Padr(SA2->A2_END,60)
   cEnd2Fab := Padr(ALLTRIM(SA2->A2_BAIRRO)+"-"+ALLTRIM(SA2->A2_MUN)+"/"+ALLTRIM(SA2->A2_EST) ;
                             +"-"+ALLTRIM(BUSCAPAIS(SA2->A2_PAIS)) ;
                             +IF(!EMPTY(SA2->A2_CX_POST),STR0029+SA2->A2_CX_POST,""); //"-Cx.Post. "
                             +IF(!EMPTY(SA2->A2_CEP),STR0030+SA2->A2_CEP,""),60) //"-C.E.P. "
   Space(60) // Complemento do End
   cCgcFab  := Padr(Transf(SA2->A2_CGC,AVSX3("A2_CGC",6)),30)
   cInscFab := Padr(Transf(SA2->A2_INSCR,AVSX3("A2_INSCR",6)),30)
   cCidFab  := Padr(Transf(SA2->A2_MUN,AVSX3("A2_MUN",6)),60)  
   cEstFab  := Padr(Transf(SA2->A2_EST,AVSX3("A2_EST",6)),10)  

   cNFFab   := Space(30) // Nota Fiscal
   cSerieFab:= Space(20) // Serie
   cDtNFFab := Space(10) // Data da NF

   cAux := AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),2))+" - "

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
    
      cAux := cAux+AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1))+" / "
      EE9->(dbSkip())
   Enddo

   cAux := Substr(cAux,1,Len(cAux)-2)

   cProd1Exp:= Padr(MemoLine(cAux,60,1),60) // Produto 1
   cProd2Exp:= Padr(MemoLine(cAux,60,2),60) // Produto 2
   cProd3Exp:= Padr(MemoLine(cAux,60,3),60) // Produto 3

End Sequence

RestOrd(aOrd)

Return NIL

*-------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM26.PRW                                            *
*-------------------------------------------------------------------------*
