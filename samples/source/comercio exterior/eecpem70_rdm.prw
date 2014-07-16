/*
Programa        : EECPEM70_RDM.PRW
Objetivo        : Certificado de Origem - Mercosul - FIEP
Autor           : Julio de Paula Paz
Data/Hora       : 07/06/2006 16:00
Obs.            : considera que estah posicionado no registro de processos (embarque) (EEC)
Revisão         : 
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM70.CH"

#define MARGEM     Space(05)
#DEFINE LENCON1    10
#DEFINE LENCON2    93
#define TOT_NORMAS 07
#define LENCOL1    09
#define LENCOL2    12//10 
#define LENCOL3    58//51
#define LENCOL4    14
#define LENCOL5    15
#define TOT_ITENS  17//11
#DEFINE TAMOBS     93
*--------------------*
User Function EECPEM70
*--------------------*
Local cParam := If(Type("ParamIxb") = "A" , ParamIxb[1],"")

LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001},;  //"Ordem"
                  {"COD_NCM"  ,LENCOL2,"C",STR0002},;  //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003},;  //"Descricao"
                  {"PESO_QTDE",LENCOL4,"C",STR0004},;  //"Peso Liq. ou Qtde."
                  {"VALOR_FOB",LENCOL5,"C",STR0005}},; //"Valor Fob em Dolar"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001},;  //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0006}}   //"Normas de Origem"

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("MER")
   IF CODET(aLENCOL,aLENCON,"EE9_POSIPI",TOT_NORMAS,"PEM70",TOT_ITENS,,,"1") // DETALHES
      aCAB := COCAB()       // CABECALHO
      aROD := COROD(TAMOBS) // RODAPE
      //data de emissão
      aROD[4] := STR(DAY(dDATABASE),2)+" DE "+Alltrim(UPPER(MESEXTENSO(MONTH(dDATABASE))))+" DE "+STR(YEAR(dDATABASE),4)

      // EDICAO DOS DADOS
      IF COTELAGETS(STR0007) //"Mercosul"
         // EXPORTADOR
         mDET := ""
         mDET := mDET+REPLICATE(ENTER,5)
         mDET := mDET+MARGEM+aCAB[1,1]+ENTER
         mDET := mDET+MARGEM+aCAB[1,2]+ENTER
         mDET := mDET+MARGEM+aCAB[1,3]+ENTER
         // IMPORTADOR
         /*
         mDET := mDET+REPLICATE(ENTER,5)
         mDET := mDET+MARGEM+aCAB[2,1]+ENTER
         mDET := mDET+MARGEM+aCAB[2,2]+ENTER
         mDET := mDET+MARGEM+aCAB[2,3]+ENTER
         */
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[2,1]+ENTER
         mDET := mDET+MARGEM+aCAB[2,2]+ENTER
         mDET := mDET+MARGEM+aCAB[2,3]+ENTER

         // CONSIGNATARIO
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[3,1]+ENTER
         mDET := mDET+MARGEM+aCAB[3,2]+ENTER
         // PORTO OU LOCAL DE EMBARQUE / PAIS DE DESTINO DAS MERCADORIAS
         mDET := mDET+REPLICATE(ENTER,4)
         mDET := mDET+MARGEM+aCAB[4]+SPACE(7)+;
                             aCAB[5]+ENTER
         // VIA DE TRANSPORTE / N.FATURA / DATA DA FATURA
         mDET := mDET+REPLICATE(ENTER,4)
         mDET := mDET+MARGEM+aCAB[6]+SPACE(14)+;//15
                             aCAB[7]+SPACE(04)+;
                             aCAB[8]+ENTER
         mDET := mDET+REPLICATE(ENTER,4)
         // RODAPE
         mROD := ""+ENTER
         
         mROD := mROD+MARGEM+aROD[1,1]+ENTER  // LINHA 1 DA OBS.
         mROD := mROD+MARGEM+aROD[1,2]+ENTER  // LINHA 2 DA OBS.
         mROD := mROD+MARGEM+aROD[1,3]+ENTER  // LINHA 3 DA OBS.
         mROD := mROD+MARGEM+aROD[1,4]+ENTER  // LINHA 4 DA OBS.
         mROD := mROD+REPLICATE(ENTER,11)     // LINHAS EM BRANCO
      
         //mROD := mROD+MARGEM+aROD[2]+ENTER    // INSTRUMENTO DE NEGOCIACAO
         //mROD := mROD+MARGEM+aROD[3]+ENTER    // NOME DO EXPORTADOR
         mROD := mROD+MARGEM+Space(08)+aROD[4]+ENTER    // MUNICIPIO/DATA DE EMISSAO
         mROD := mROD+REPLICATE(ENTER,12)
         
         // DETALHES
         lRET := COIMP(mDET,mROD,MARGEM,03) //9
         
         If lRet
            HEADER_P->(RecLock("HEADER_P",.f.))
            HEADER_P->AVG_C01_10 := cParam
            HEADER_P->(MsUnlock())
         EndIf
         
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)


USER FUNCTION PEM70()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cPictPeso  := "@E 9,999,999"+if(EEC->EEC_DECPES > 0, "."+REPLICATE("9",EEC->EEC_DECPES),""),;
      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NCM   := TRANSFORM(TMP->EE9_POSIPI,AVSX3("EE9_POSIPI",AV_PICTURE))
TMP->PESO_QTDE := PADL(ALLTRIM(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO)) ,LENCOL4," ")
TMP->VALOR_FOB := PADL(ALLTRIM(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO)),LENCOL5," ")
TMP->DESCRICAO := TMP->TMP_DSCMEM

RETURN(NIL)