#INCLUDE "EICCC150.CH"
#include "AVERAGE.CH"

/*
Funcao    ³ EICCC150
Autor     ³ AVERAGE/LUIZ CLAUDIO BARBOSA
Manutenção³ GUSTAVO CARREIRO 12/07/2001
Data      ³ 07.11.2000
Descricao ³ Relarório de importações pagas no periodo
Sintaxe   ³ U_EICCC150()
Uso       ³ SIGAEIC
*/
*-----------------------*
User Function EICCC150()
*-----------------------*
// Define variaveis das funções SetPrint() e SetDefault()
PRIVATE cString := "SW6", cAlias := Alias()
PRIVATE NomeRel := "EICCC150"
PRIVATE titulo  := STR0001 //"Relarório de importações pagas no periodo por"
PRIVATE cDesc1  := STR0002 //"Este relatório apresenta as importações pagas por"
PRIVATE cDesc2  := STR0003 //"periodo conforme parametros informados pelo usuáruo"
PRIVATE cDesc3  := ""
PRIVATE aOrd    := Nil
PRIVATE tamanho := "M"
PRIVATE nLin    := 999
PRIVATE aReturn := { "Zebrado", 1,"Importação", 2, 2, 1, "", 1 }
PRIVATE m_pag   := 1
PRIVATE cCabec1 := ""
PRIVATE cCabec2 := ""
PRIVATE cArqTrb := ""
PRIVATE lImpObs:=.F.

SX3->(DBSETORDER(2))
PRIVATE lCposAdto:=SX3->(DBSEEK("WB_PO_DI")) .AND. SX3->(DBSEEK("WB_PGTANT")) .AND. SX3->(DBSEEK("WB_NUMPO"))
SX3->(DBSETORDER(1))

// lCposAdto->Se existir os cpos referente a pagto antecipado, trata Seek
// com um campo a mais  WA_PO_DI/WB_PO_DI que, nas parcelas de cambio de DI tera como 
// conteudo a letra "D".

// Define variaveis desta rotina
Private cKey
Private cQUEBRA
Private nVLTOTGER:= 0 
Private nVLTOTUSGER:= 0 
Private Var1,Var2,Var3,Var4,Var5
Do While .T.
   If ! Pergunte("EICCC1", .T.)
      Exit
   EndIf                        
   
   Var1 := MV_PAR01
   Var2 := MV_PAR02
   Var3 := MV_PAR03
   Var4 := MV_PAR04
   
	If Var3 == 2     .And. !Pergunte("EICCC3", .T.) // Por Banco
      Loop      
   ElseIf Var3 == 3 .And. !Pergunte("EICCC4", .T.)// Por Corretora
      Loop      
   ElseIf Var3 == 1 .And. !Pergunte("EICCC5", .T.)// Por Fornecedor
      Loop      
   EndIf

   Var5 := MV_PAR01

   CC150GRVTRB()

   CC150IMPRIME()
   
EndDo
dbSelectArea(cAlias)
Return Nil

*-----------------------------*
Static Function CC150GRVTRB() 
*-----------------------------*
LOCAL nTX_PTAX:=0,nValSWB:=0
LOCAL cMoeDolar:=GETMV("MV_SIMB2",,"US$")

aStru := { { "PROCESSO"   , "C", 18, 0 } ,;
           { "VAL_FOB"    , "N", 17, 2 } ,;
           { "VAL_FOB_US" , "N", 17, 2 } ,;
           { "DT_FECH"    , "D", 08, 0 } ,;
           { "TX_FECH"    , "N", 15, 8 } ,;
           { "TX_PTAX"    , "N", 15, 8 } ,;
           { "FEC_X_PTAX" , "N", 08, 2 } ,;
           { "DT_DEBITO"  , "D", 08, 0 } ,;
           { "BANCO"      , "C", 06, 0 } ,;
           { "DESCBANCO"  , "C", 15, 0 } ,;
           { "CORRETORA"  , "C", 06, 0 } ,;
           { "PRODUTO"    , "C", 15, 0 } ,;
           { "FORNECEDOR" , "C", AVSX3("A2_COD",3), 0 } ,;
           { "PAIS"       , "C", 03, 0 }  }

cArqTrb := CriaTrab(aStru, .T.)

dbUseArea(.T., , cArqTrb, "TRB", .F.)

If Var3 == 1 // Por Fornecedor
   cKey    := STR0004 //"Fornecedor"
ElseIf Var3 == 2 // Por Banco
   cKey    := STR0005 //"Banco"
ElseIf Var3 == 3 // Por Corretora
   cKey    := STR0006 //"Corretora"
ElseIf Var3 == 4 // Por Produto
   cKey    := STR0007 //"Produto"        
EndIf

titulo += cKey

IndRegua("TRB", cArqTrb, cKey+"+Dtos(DT_FECH)", , , STR0008) //"Indexando arquivo de trabalho"

lImpObs:=.F.
SYE->(DBSETORDER(2))
SW6->(dbSetOrder(1))
SWB->(dbSetOrder(3))
SWB->(dbSeek(xFilial("SWB")+DTOS(Var1), .T.))
IF SA6->(dbSeek(xFilial("SA6")+SWB->WB_BANCO+SWB->WB_AGENCIA))
   cNomeBco:=SA6->A6_NREDUZ
ELSE
   cNomeBco:=""
ENDIF   

Do While !SWB->(Eof()) .And. SWB->WB_FILIAL==xFilial("SWB")

   If Var4 = 1 .And. !Empty(SWB->WB_DT_CONT) // Aberto
      SWB->(DbSkip())
      Loop      
   ElseIf SWB->WB_DT_CONT < Var1 .Or. SWB->WB_DT_CONT > Var2
      SWB->(DbSkip())
      Loop      
   EndIf
                      
   If !Empty(Var5)
      If Var3 == 1 .And. SWB->WB_FORN # Var5  // Por Fornecedor
         SWB->(dbSkip())
         Loop      
      ElseIf Var3 == 2 .And. SWB->WB_BANCO # Var5 // Por Banco
         SWB->(dbSkip())
         Loop      
      ElseIf Var3 == 3 .And. SWB->WB_CORRETO # Var5 // Por Corretora
         SWB->(dbSkip())
         Loop
      EndIf                
   EndIf

   SW6->(dbSeek(xFilial("SW6")+SWB->WB_HAWB))
   SW7->(dbSeek(xFilial("SW7")+SWB->WB_HAWB))
   If lCposAdto .And. SWB->WB_PO_DI=="A" 
      SW2->(dbSeek(xFilial("SW2")+Alltrim(SWB->WB_HAWB)))
      nValSWB:=SWB->WB_PGTANT
      lImpObs:=.T.
   Else
      SW2->(dbSeek(xFilial("SW2")+SW7->W7_PO_NUM))
      nValSWB:=SWB->WB_FOBMOE
   EndIf
   IF nValSWB == 0
      SWB->(dbSkip())
      LOOP
   ENDIF

   If Var4 = 2      
      nTX_PTAX := If(SYE->(DBSEEK(xFilial("SYE")+SWB->WB_MOEDA+DTOS(SWB->WB_DT_CONT))),SYE->YE_VLCON_C,0)
   Else
      nTX_PTAX := If(SYE->(DBSEEK(xFilial("SYE")+SWB->WB_MOEDA+DTOS(dDataBase))),SYE->YE_VLCON_C,0)
   EndIf

   TRB->(DbAppend())   
   TRB->PROCESSO   := If(lCposAdto .And. SWB->WB_PO_DI=="A","*","")+SWB->WB_HAWB
   TRB->VAL_FOB    := nValSWB
   TRB->VAL_FOB_US := (nValSWB * BuscaTaxa(SWB->WB_MOEDA, SWB->WB_DT_CONT,,.F.)) / BuscaTaxa(cMoeDolar, SWB->WB_DT_CONT,,.F.)
   TRB->DT_FECH    := SWB->WB_DT_CONT
   TRB->TX_FECH    := SWB->WB_CA_TX
   TRB->TX_PTAX    := nTX_PTAX
   TRB->FEC_X_PTAX := IF(!EMPTY(nTX_PTAX),((nTX_PTAX/SWB->WB_CA_TX)-1)*100,0)
   TRB->DT_DEBITO  := SWB->WB_DT_DESE
   TRB->BANCO      := SWB->WB_BANCO
   TRB->DESCBANCO  := cNomeBco
   TRB->CORRETORA  := SWB->WB_CORRETO
   TRB->PRODUTO    := ""
   TRB->FORNECEDOR := SWB->WB_FORN
   TRB->PAIS       := SA2->A2_PAIS
   
   SWB->(dbSkip())
EndDo

SYE->(DbSetOrder(1))
SWB->(dbSetOrder(1))
Return .T.

*----------------------------*
Static Function CC150IMPRIME() 
*----------------------------*
LOCAL aDados :={"TRB",;
                Titulo,;
                cDesc1,;
                cDesc2,;
                "G",;
                132,;
                "",;
                "",;
                Titulo,;
                aReturn,; 
                "EICCC150",;
                {{|| U_CC150QUEBRA() },{|| U_CC150TOTAL()}},;
                }

Private cChave
Private aRCampos:={ ;
                  {"PROCESSO"                                    , STR0009     , "E"}  ,; //"Processo"
                  {"FORNECEDOR"                                  , STR0004     , "E"}  ,; //"Fornecedor"
                  {"CORRETORA"                                   , STR0006     , "E"}  ,; //"Corretora"
                  {"TRANS(VAL_FOB,'@E 99,999,999,999,999.99')"   , STR0010     , "D"}  ,; //"Valor ME"
                  {"TRANS(VAL_FOB_US,'@E 99,999,999,999,999.99')", STR0011     , "D"}  ,; //"Valor US$" 
                  {"DTOC(DT_FECH)"                               , STR0012     , "E"}  ,; //"DT.Fech."
                  {"TRANS(TX_FECH,'@E 999,999.99999999')"        , STR0013     , "E"}  ,; //"Tx.Fech."
                  {"TRANS(TX_PTAX,'@E 999,999.99999999')"        , If(Var4=1,STR0014,STR0015)  , "E"}  ,; //"Tx.PTax" OU "Tx.PTaxFech"
                  {"TRANS(FEC_X_PTAX,'@E 99,999.9999')"          , If(Var4=1,STR0016,STR0017)  , "E"}  ,; //"Tx.Fec/Tx.PTax%" OU "Tx.Fec/Tx.PTaxFec%"
                  {"BANCO"                                       , STR0005     , "E"}  ,; //"Banco"
                  {"DESCBANCO"                                   , STR0018     , "E"}  ,; //"Descrição"
                  {"DTOC(DT_DEBITO)"                             , STR0019     , "E"}  } //"DT.Débito"

If Var3     == 1 // Por Fornecedor
   cChave := "FORNECEDOR+PAIS"
   bQUEBRA := {||TRB->FORNECEDOR}
ElseIf Var3 == 2 // Por Banco
   cChave := ""
   bQUEBRA := {||TRB->BANCO}
ElseIf Var3 == 3 // Por Corretora
   cChave := "CORRETORA"
   bQUEBRA := {||TRB->CORRETORA}
ElseIf Var3 == 4 // Por Produto
   cChave := "PRODUTO"
   bQUEBRA := {||TRB->PRODUTO}
Endif

DbSelectArea("TRB")               
If TRB->(Bof()) .And. TRB->(Eof())
   Help("", 1, "AVG0000553")//MsgInfo("Não existe informações no periodo informado")
Else
   TRB->(DBGOTOP())
   cQUEBRA:= EVAL(bQUEBRA)
   nVLTOT:=nVLTOTUS:=nVLTOTGER:=nVLTOTUSGER:=0
   If lImpObs
      aDados[7]:=STR0022 //"Os Processos iniciados com * referem-se a Adiantamentos - Número do Pedido"
   EndIf   
   E_Report(aDados,aRCampos)
EndIf
TRB->(E_EraseArq(cArqTrb))
dbSelectArea(cAlias)

Return Nil

*-----------------------------*
User FUNCTION CC150QUEBRA() 
*-----------------------------*
IF Alltrim(EVAL(bQUEBRA)) # Alltrim(cQuebra)
   cQuebra:=EVAL(bQUEBRA)
   Linha+= 2
   @ Linha, 41 PSAY REPLICATE("-",21)
   @ Linha, 63 PSAY REPLICATE("-",21)
   Linha+= 1
   @ Linha, 20 PSAY STR0020 + cKey //"Total por "
   @ Linha, 41 PSAY TRANS(nVLTOT,"@E 99,999,999,999,999.99")
   @ Linha, 63 PSAY TRANS(nVLTOTUS,"@E 99,999,999,999,999.99")
   Linha+= 1
   nVLTOTGER+=nVLTOT
   nVLTOTUSGER+=nVLTOTUS
   
   nVLTOT:=nVLTOTUS:=0
   nVLTOT   += TRB->VAL_FOB
   nVLTOTUS += TRB->VAL_FOB_US
   
Else
   nVLTOT   += TRB->VAL_FOB
   nVLTOTUS += TRB->VAL_FOB_US
ENDIF   

Return .T.


*-----------------------------*
User FUNCTION CC150TOTAL() 
*-----------------------------*
nVLTOT   += TRB->VAL_FOB
nVLTOTUS += TRB->VAL_FOB_US
Linha+= 2
@ Linha, 30 PSAY REPLICATE("-",21)
@ Linha, 52 PSAY REPLICATE("-",21)
Linha+= 1
@ Linha, 9 PSAY STR0020 + cKey //"Total por "
@ Linha, 30 PSAY TRANS(nVLTOT,"@E 99,999,999,999,999.99")
@ Linha, 52 PSAY TRANS(nVLTOTUS,"@E 99,999,999,999,999.99")
nVLTOTGER+=nVLTOT
nVLTOTUSGER+=nVLTOTUS
nVLTOT:=nVLTOTUS:=0

Linha+= 2

@ Linha, 30 PSAY REPLICATE("=",21)
@ Linha, 52 PSAY REPLICATE("=",21)
Linha+= 1
@ Linha, 9 PSAY STR0021 //"Total Geral =>"
@ Linha, 30 PSAY TRANS(nVLTOTGER,"@E 99,999,999,999,999.99")
@ Linha, 52 PSAY TRANS(nVLTOTUSGER,"@E 99,999,999,999,999.99")

Return .T.
