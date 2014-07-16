#INCLUDE "EECPEM33.ch"
/*
Programa..: EECPEM33.PRW
Objetivo..:  Certificado de Origem - Bolivia/Chile
Autor.....: Cristiano A. Ferreira
Data/Hora.: 18/01/2000 14:19
Obs.......: considera que está posicionado no registro de processos (embarque) (EEC)
            Este programa imprime o C.O. da Bolivia e do Chile
            para identificar se é Bolivia ou Chile é usado a
            variavel lBolivia.
            
            Exemplo de Chamada do Rdmake - Bolivia:
            ExecBlock("EECPEM33",.F.,.F.,"B")
            
            Exemplo de Chamada do Rdmake - Chile:
            ExecBlock("EECPEM33",.F.,.F.,"C")
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM33.CH"
#define MARGEM    " "  // SPACE(01)
#DEFINE LENCON1    10
#DEFINE LENCON2    93
#define TOT_NORMAS 04
#define LENCOL1    10
#define LENCOL2    20
#define LENCOL3    45
#define LENCOL4    17
#define LENCOL5    17
#define TOT_ITENS  14
#DEFINE TAMOBS     93
*--------------------------------------------------------------------
USER FUNCTION EECPEM33
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001             },; //"Ordem"
                  {"COD_NALAD",LENCOL2,"C",STR0002     },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003         },; //"Descricao"
                  {"PESO_QTDE",LENCOL4,"C",STR0004},; //"Peso Liq. ou Qtde."
                  {"VALOR_FOB",LENCOL5,"C",STR0005}},; //"Valor Fob em Dolar"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001           },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0006}} //"Normas de Origem"
PRIVATE cEDITA,;
        lBOLIVIA := (VALTYPE(ParamIXB)=="U" .OR. ParamIXB == "B"),;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("MER")
   IF CODET(aLENCOL,aLENCON,"EE9_NALSH",TOT_NORMAS,"PEM33",TOT_ITENS,,,"1") // DETALHES
      aCAB := COCAB()        // CABECALHO
      aROD := COROD(TAMOBS) // RODAPE
      // EDICAO DOS DADOS
      IF COTELAGETS(IF(lBOLIVIA,STR0007,STR0008)) //"Bolivia"###"Chile"
         // EXPORTADOR
         mDET := ""
         mDET := mDET+REPLICATE(ENTER,8)
         mDET := mDET+MARGEM+aCAB[1,1]+ENTER
         mDET := mDET+MARGEM+aCAB[1,2]+ENTER
         mDET := mDET+MARGEM+aCAB[1,3]+ENTER
         // IMPORTADOR
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[2,1]+ENTER
         mDET := mDET+MARGEM+aCAB[2,2]+ENTER
         mDET := mDET+MARGEM+aCAB[2,3]+ENTER
         // CONSIGNATARIO
         mDET := mDET+REPLICATE(ENTER,3)
         mDET := mDET+MARGEM+aCAB[3,1]+ENTER
         mDET := mDET+MARGEM+aCAB[3,2]+ENTER
         // PORTO OU LOCAL DE EMBARQUE / PAIS DE DESTINO DAS MERCADORIAS
         mDET := mDET+REPLICATE(ENTER,1)
         mDET := mDET+MARGEM+aCAB[4]+SPACE(02)+;
                             aCAB[5]+ENTER
         // VIA DE TRANSPORTE / N.FATURA / DATA DA FATURA
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[6]+SPACE(15)+;
                             aCAB[7]+SPACE(07)+;
                             aCAB[8]+ENTER
         mDET := mDET+REPLICATE(ENTER,3)
         // RODAPE
         mROD := ""
         mROD := mROD+MARGEM+aROD[1,1]+ENTER  // LINHA 1 DA OBS.
         mROD := mROD+MARGEM+aROD[1,2]+ENTER  // LINHA 2 DA OBS.
         mROD := mROD+MARGEM+aROD[1,3]+ENTER  // LINHA 3 DA OBS.
         mROD := mROD+MARGEM+aROD[1,4]+ENTER  // LINHA 4 DA OBS.
         mROD := mROD+REPLICATE(ENTER,8)      // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[2]+ENTER    // INSTRUMENTO DE NEGOCIACAO
         mROD := mROD+MARGEM+aROD[3]+ENTER    // NOME DO EXPORTADOR
         mROD := mROD+MARGEM+aROD[4]+ENTER    // MUNICIPIO/DATA DE EMISSAO
         // DETALHES
         lRET := COIMP(mDET,mROD,MARGEM,2)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
USER FUNCTION PEM33()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cPictPeso  := IF(lBOLIVIA,"@E ","")+"99,999,999"+IF(EEC->EEC_DECPES>0,"."+Replic("9",EEC->EEC_DECPES),""),;
      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)
*
TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := TRANSFORM(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := TMP->TMP_DSCMEM
TMP->PESO_QTDE := PADL(ALLTRIM(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO)) ,LENCOL4," ")
TMP->VALOR_FOB := PADL(ALLTRIM(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO)),LENCOL5," ")
RETURN(NIL)
*--------------------------------------------------------------------
