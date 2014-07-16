#INCLUDE "EECPEM74.ch"

/*
Programa. : EECPEM74_RDM.PRW
Objetivo..: Certificado Comum FIEP
Autor.....: Julio de Paula Paz
Data/Hora.: 12/06/2006
Obs.......: considera que estah posicionado no registro de processos (embarque) (EEC)
Revisão...: 
*/
#include "EECRDM.CH"
//#define MARGEM Space(6)
//#define LENCOL1    17
//#define LENCOL2    21
//#define LENCOL3    45

//#DEFINE LENCOL4    20
#define TOT_ITENS  12
#DEFINE TAMOBS     99
*--------------------------------------------------------------------
USER FUNCTION EECPEM74
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"SYR","SYA"}),;
      aLENCOL

Private nLenCol1
Private cMargem
cMargem := Space(5)
nLenCol1 := 99

aLENCOL := {{"DESCRICAO",nLenCol1,"M",STR0001}} //"Denominação das Mercadorias"
//{"DESCRICAO",LENCOL3,"M",STR0003}

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}

IF COVERI()
   IF CODET(aLENCOL,,"EE9_POSIPI",,"PEM74",TOT_ITENS) // DETALHES
      // CABECALHO
      aCAB    := COCAB()
      aROD := COROD(TAMOBS) 
      aROD[4] := STR(DAY(dDATABASE),2)+" DE "+Alltrim(UPPER(MESEXTENSO(MONTH(dDATABASE))))+" DE "+STR(YEAR(dDATABASE),4)
      aCAB[1,3] := StrTran(aCAB[1,3],"-"+AllTrim(aCAB[1,4])," ")
      // EDICAO DOS DADOS
      IF COTELAGETS(STR0002,"7") //"Comum FIEP"
         // N.FATURA / DATA DA FATURA 
         mDET := ""
         mDET := mDET+Replicate(ENTER,11)
         mDET := mDET+cMargem+Space(19)+aCAB[7]+SPACE(32)+;
                             aCAB[8]+ENTER
         // EXPORTADOR
         //mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+cMargem+Space(31)+aCAB[1,1]+Replicate(ENTER,2) 
         mDET := mDET+cMargem+Space(31)+aCAB[1,2]+ENTER
         mDET := mDET+cMargem+Space(31)+aCAB[1,3]+Replicate(ENTER,1)
         mDET := mDET+cMargem+Space(31)+aCAB[1,4]+ENTER
         // IMPORTADOR
         //mDET := mDET+REPLICATE(ENTER,1)
         mDET := mDET+cMargem+Space(31)+aCAB[2,1]+Replicate(ENTER,2)
         mDET := mDET+cMargem+Space(31)+aCAB[2,2]+ENTER
         mDET := mDET+cMargem+Space(31)+aCAB[2,3]+ENTER  
         mDET := mDET+cMargem+Space(31)+aCAB[2,4]+ENTER  
         // 
         // CONSIGNATARIO
         //mDET := mDET+REPLICATE(ENTER,1)
         mDET := mDET+cMargem+Space(26)+aCAB[3,1]+Replicate(ENTER,3)
         mDET := mDET+cmargem+Space(26)+aCAB[3,2]+ENTER
         mDET := mDET+Replicate(ENTER,2)   
         
         // CIDADE/PAIS DE DESTINO
         //mDET := mDET+cMargem+LEFT(aCAB[4],25)+SPACE(If(lLayOut,03,04))+LEFT(aCAB[5],25)+ENTER
         //mDET := mDET+REPLICATE(ENTER,If(lLayOut,13,8))
         // RODAPE
         mROD := ""        
         mROD := mROD+cMargem+aROD[1,1]+ENTER          // LINHA 1 DA OBS.          
         mROD := mROD+cMargem+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
         mROD := mROD+Replicate(ENTER,09)
         
         mROD := mROD+cMargem+Space(10)+aROD[4]+Replicate(ENTER,11)   // Data emissão por extenso.          
         
         // DETALHES
         lRET := COIMP(mDET,mROD,cMargem,0)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
/*USER FUNCTION PEM20()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cDESC,I,Z,Y,nLI,;
      nDESC       := AVSX3("EE9_VM_DES",AV_TAMANHO),;
      aORD        := SAVEORD({"EE9"}),;
      lPRI        := .T.
Local cPictDecPes := if(EEC->EEC_DECPES > 0,"."+Replic("9",EEC->EEC_DECPES),"")
Local cPictPeso   := "@E 999,999,999"+cPictDecPes

EE9->(DBSETORDER(4))
EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
DO WHILE ! EE9->(EOF()) .AND.;
   EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
   *
   IF lPRI
      TMP->(DBAPPEND())
      TMP->INVOICE   := EEC->EEC_NRINVO
      IF TMP->(RECNO()) = 1
         TMP->PESLIQBRU := TRANSFORM(EEC->EEC_PESLIQ,cPictPeso)+STR0006 //" KG"
      ENDIF
      nLI := 1
      TMP->(DBAPPEND())
      TMP->PACKAGE   := EEC->EEC_PACKAGE
      IF TMP->(RECNO()) = 2
         TMP->PESLIQBRU := TRANSFORM(EEC->EEC_PESBRU,cPictPeso)+STR0007 //" KGS"
      ENDIF
   ENDIF
   // MONTA A DESCRICAO DO PRODUTO
   cDESC := ALLTRIM(TRANSFORM(EE9->EE9_SLDINI,"99999999"))+" "+ALLTRIM(EE9->EE9_UNIDAD)+" "
   Z     := MSMM(EE9->EE9_DESC,nDESC)
   FOR I := 1 TO MLCOUNT(Z,nDESC)
       cDESC := cDESC+ALLTRIM(STRTRAN(MEMOLINE(Z,nDESC,I),ENTER,""))+" "
   NEXT
   Z := MLCOUNT(cDESC,nLenCol3)
   IF (nLI+Z) > TOT_ITENS
      IF ! lPRI
         FOR I := 1 TO (TOT_ITENS-nLI)
             TMP->(DBAPPEND())
         NEXT
         lPRI := .T.
         LOOP
      ENDIF
   ELSE
      IF lPRI
         lPRI := .F.
      ELSE
         TMP->(DBAPPEND())
      ENDIF
   ENDIF
   // GRAVA NO TMP A DESCRICAO DO PRODUTO
   Y := ""
   FOR I := 1 TO MLCOUNT(cDESC,nLenCol3)
       Y := Y+MEMOLINE(cDESC,nLenCol3,I)+ENTER
   NEXT
   TMP->DESCRICAO := Y
   nLI            := nLI+Z
   EE9->(DBSKIP())
ENDDO
*
RESTORD(aORD)
RETURN(NIL)
  */
USER FUNCTION PEM74()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
//LOCAL cPictPeso  := "@E 9,999,999"+if(EEC->EEC_DECPES > 0, "."+REPLICATE("9",EEC->EEC_DECPES),""),;
//      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)

TMP->DESCRICAO := TMP->TMP_DSCMEM

RETURN(NIL)