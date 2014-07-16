#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp19()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,_CCANT,_NLI,_DESC")
SetPrvt("_DVENC,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RHGP19          ³ M.GracaNCarvalho      ³ Data ³ 23.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Resumo de Periodos Aquisitivo de Ferias/Faltas/Saldos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Alterado em 03/08/2000 - MANER Consultoria e Informatica
Solicitante : Marcio - RH
Alterar titulo para Programacao de ferias,formato 80 colunas
Nao imprimir faltas,imprimir descricao do centro de custo no lugar do codigo
*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""

cabec1:="";cabec2:="";cabec3:="";wnrel:=""

nOrdem:=0
tamanho:="M"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Programacao Ferias"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP19"
cPerg    := "RHGP19"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("RHGP19",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RHGP19"
wnRel := SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

cabec1 := "."
cabec2 := "."
cabec3 := "." 

#IFDEF WINDOWS
    RptStatus({|| RHG019()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG019)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG019
Static Function RHG019()
                
DbSelectArea("SRF")
DbSetOrder(01)
DbSelectArea("SI3")
DbSetOrder(01)

DbSelectArea("SRA")
DbSetOrder(08)
SRA->(DbgoTop())
SRA->(SetRegua(RecCount()))
SRA->(DbSeek(mv_par01+mv_par03,.T.))

m_pag    := 1
_CcAnt := "xxxxxxxxx"
@ 01  , 01 pSay Chr(15)
@ 02  , 01 pSay "DATA : " +Dtoc(Date())+"                      PROGRAMACAO DE FERIAS     Periodo : " + Dtoc(mv_par05) + " A " + Dtoc(mv_par06)
@ 03  , 01 pSay ""
@ 04  , 01 pSay "MATRIC NOME                           ADMISSAO   PER AQUISITIVO  LIMITE   VENC PROP   PROGRAMACAO    VISTO"
@ 05  , 01 pSay "______ ______________________________ ________ _________________ ________ ____ ____ ______________  ______________________"
//               12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                        1         2         3         4         5         6         7         8         9         1         2         3
@ 06  , 01 pSay " "
_NLI:=8
SRA->(dbGoTop())
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_CC>=mv_par03 .and. SRA->RA_CC<=mv_par04
   IncRegua()
   If SRA->RA_SITFOLH=="D" .or. SRA->RA_SITFOLH=="T"
      SRA->(DbSkip())
      Loop
   EndIf
   If _NLI> 58
      @ 02  , 01 pSay "DATA : " +Dtoc(Date())+"                      PROGRAMACAO DE FERIAS     Periodo : " + Dtoc(mv_par05) + " A " + Dtoc(mv_par06)
      @ 03  , 01 pSay ""
      @ 04  , 01 pSay "MATRIC NOME                           ADMISSAO   PER AQUISITIVO  LIMITE   VENC PROP   PROGRAMACAO    VISTO"
      @ 05  , 01 pSay "______ ______________________________ ________ _________________ ________ ____ ____ ______________  ______________________"
      @ 06  , 01 pSay " "
      _NLI:=8
      _CcAnt := "xxxxxxxxx"
   Endif
   SRF->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))
   If (SRA->RA_FILIAL==SRF->RF_FILIAL .and. SRA->RA_MAT==SRF->RF_MAT .and. (mv_par05 - SRF->RF_DATABAS > 680 .OR. mv_par06 - SRF->RF_DATABAS > 680))
      If _CcAnt <> SRA->RA_CC
         _CcAnt := SRA->RA_CC
         _Desc := "NAO CADASTRADO"
         SI3->(DbSeek(xFilial("SI3")+SRA->RA_CC,.T.))
         If SI3->(Found())
            _Desc:= SI3->I3_DESC 
         EndIf
         @ _NLI  , 01 pSay " "
         _NLI:=_NLI+1
         @ _NLI  , 01 pSay "      CENTRO DE CUSTO : " + _CcAnt + " - " + _Desc
         _NLI:=_NLI+2
      EndIf
      _dVenc:= SRF->RF_DFERVAT
      If SRF->RF_DFERANT <> 0
         _dVenc:= _dVenc - SRF->RF_DFERANT
      EndIf
      @ _NLI  , 01 pSay SRA->RA_MAT
      @ _NLI  , 08 pSay SRA->RA_NOME
      @ _NLI  , 39 pSay SUBSTR(Dtoc(SRA->RA_ADMISSA),1,6) + SUBSTR(Dtoc(SRA->RA_ADMISSA),9,2)
      @ _NLI  , 48 pSay SUBSTR(Dtoc(SRF->RF_DATABAS),1,6) + SUBSTR(Dtoc(SRF->RF_DATABAS),9,2)
      @ _NLI  , 57 pSay SUBSTR(Dtoc(SRF->RF_DATABAS+365.25),1,6) + SUBSTR(Dtoc(SRF->RF_DATABAS+365.25),9,2)
      @ _NLI  , 66 pSay SUBSTR(Dtoc(SRF->RF_DATABAS+700),1,6) + SUBSTR(Dtoc(SRF->RF_DATABAS+700),9,2)
      @ _NLI  , 75 pSay _dVenc Picture "99.9"
//      @ _NLI  , 73 pSay SRF->RF_DFERANT Picture "99.9"
//      @ _NLI  ,106 pSay SRF->RF_DFALVAT Picture "99.9"
//      @ _NLI  ,113 pSay SRF->RF_DFERAAT Picture "99.9"
//      @ _NLI  ,120 pSay SRF->RF_DFALAAT Picture "99.9"
      @ _NLI  , 80 pSay SRF->RF_DFERAAT Picture "99.9"
      @ _NLI  , 85 pSay "____/____/____  ______________________"
      _NLI:=_NLI+2
   EndIf   
   SRA->(DbSkip())
Enddo
RetIndex("SRA")

RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
