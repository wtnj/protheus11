/*
Programa        : EECPEM72_RDM.PRW
Objetivo        : Certificado de Origem - Aladi - FIEP
Autor           : Julio de Paula Paz
Data/Hora       : 08/06/2006 - 17:00
Obs.            : considera que esta posicionado no registro de embarque (EEC)
Revisão         : 
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM72.ch"

#define MARGEM     Space(03)
#DEFINE LENCON1    08
#DEFINE LENCON2    93
#define TOT_NORMAS 06
#define LENCOL1    08
#define LENCOL2    13
#define LENCOL3    78
#define TOT_ITENS  09  //10
#DEFINE TAMOBS     99
*---------------------*
USER FUNCTION EECPEM72
*---------------------*
Local cParam := If(Type("ParamIxb") = "A" , ParamIxb[1],"")

Local mDET,mROD,mCOMPL,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001 },; //"Ordem"
                  {"COD_NALAD",LENCOL2,"C",STR0002 },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003 }} //"Descricao"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001 },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0004 }} //"Normas de Origem"
                  
Private cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("ALA")
   IF CODET(aLENCOL,aLENCON,"EE9_NALSH",TOT_NORMAS,"PEM72",TOT_ITENS) // DETALHES
      aCAB    := COCAB()        // CABECALHO
      aROD    := COROD(TAMOBS) // RODAPE
      // DATA DE EMISSAO DO CERTIFICADO
      aROD[4] := STR(DAY(dDATABASE),2)+" DE "+Alltrim(UPPER(MESEXTENSO(MONTH(dDATABASE))))+" DE "+STR(YEAR(dDATABASE),4)

      // EDICAO DOS DADOS
      If COTELAGETS(STR0005,"2") //"Aladi"
         // EXPORTADOR
         mDET := ""
         mDET := mDET+Replicate(ENTER,12)               // LINHAS EM BRANCO
         mDET := mDET+MARGEM+Space(50)+aCAB[2,4]+ENTER  // Pais do inportador 
         mDET := mDET+Replicate(ENTER,3)
         // RODAPE
         mROD := ""
         // DATA DA IMPRESSAO DO CERTIFICADO
         mROD := mROD+MARGEM+Space(08)+STR(DAY(ctod(arod[5])),2)+" DE "+;
                 Alltrim(UPPER(MESEXTENSO(Month(ctod(arod[5])))))+" DE "+;
                 STR(YEAR(ctod(arod[5])),4)+ENTER
         mROD := mROD+Replicate(ENTER,3)              // LINHAS EM BRANCO
         mROD := mRod+MARGEM+Space(15)+aCAB[1,1]      // Nome do Exportador
         mRod := mRod+Replicate(ENTER,4)              // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[1,1]+ENTER          // LINHA 1 DA OBS.          
         mROD := mROD+MARGEM+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
         mROD := mROD+Replicate(ENTER,08) //4         // LINHAS EM BRANCO
         mROD := mROD+MARGEM+Space(21)+aROD[4]        // DATA DE EMISSAO DO CERTIFICADO
         mROD := mROD+Replicate(ENTER,09)
         
         // COMPLEMENTO
         mCOMPL := ""
         mCOMPL := mCOMPL+Replicate(ENTER,1)  // LINHAS EM BRANCO ENTRE DET E COMPL
         mCOMPL := mCOMPL+MARGEM+Space(92)+Transform(aCAB[7],AVSX3("EEC_NRINVO",AV_PICTURE))+ENTER  // NUMERO DA INVOICE
         //mCOMPL := mCOMPL+MARGEM+Space(42)+aROD[2]+ENTER  // INSTRUMENTO DE NEGOCIACAO
         mCOMPL := mCOMPL+Replicate(ENTER,5)  // LINHAS EM BRANCO ENTER O COMPL E AS NORMAS
         // DETALHES
         lRet := COIMP(mDET,mROD,MARGEM,1,mCOMPL)

         If lRet
            HEADER_P->(RecLock("HEADER_P",.f.))
            HEADER_P->AVG_C01_10 := cParam
            HEADER_P->(MsUnlock())
         EndIf
         
      EndIf
   EndIf
EndIf
Restord(aOrd)
Return(lRET)

*-------------------*
User Function PEM72()
*-------------------*

// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := Transform(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := AllTrim(StrTran(MemoLine(TMP->TMP_DSCMEM,LENCOL3,1),ENTER,""))

Return(Nil)
*--------------------------------------------------------------------
