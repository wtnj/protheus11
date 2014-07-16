/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MDTR700  ³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o |Perfil Profissiografico Previdenciario  -  P.P.P.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MDTR700()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Nhmdt002()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel   := "MDTR700"
LOCAL limite  := 95
LOCAL cDesc1  := "Este relatorio apresentara um historico laboral pessoal com proposito"
LOCAL cDesc2  := "previdenciarios para informacoes relativas a fiscalizacao do gerenciamento"
LOCAL cDesc3  := "de riscos, existencia de agentes nocivos no ambiente de trabalho."
LOCAL cString := "SRA"

PRIVATE nomeprog := "MDTR700"
PRIVATE tamanho  := "M"
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE titulo   := "Perfil Profissiografico Previdenciario"
PRIVATE ntipo    := 0
PRIVATE nLastKey := 0
PRIVATE cPerg    :="MDR700"
PRIVATE cabec1, cabec2
PRIVATE cAlias
PRIVATE cDescr
Private nSizeSI3
nSizeSI3 := If((TAMSX3("I3_CUSTO")[1]) < 1,9,(TAMSX3("I3_CUSTO")[1]))
PRIVATE cTypeEnd
PRIVATE lNGMDTPS := .F.

cAlias := "SI3"
cDescr := "SI3->I3_DESC"

Dbselectarea("SX6")
Dbsetorder(1)
If Dbseek(xFilial("SX6")+"MV_NGMDTPS")
  If Alltrim(GETMV("MV_NGMDTPS")) == "S"
      lNGMDTPS := .T.
  Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De  Matricula                        ³
//³ mv_par02             // Ate Matricula                        ³
//³ mv_par03             // De  Centro de Custo                  ³
//³ mv_par04             // Ate Centro de Custo                  ³
//³ mv_par05             // De  Funcao                           ³
//³ mv_par06             // Ate Funcao                           ³
//³ mv_par07             // Considerar Risco                     ³
//³ mv_par08             // Descricao das Atividades             ³
//³ mv_par09             // Tipo de Endereco                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX1")
DbSetOrder(01)
If !DbSeek(cPerg+"01")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "01"
   SX1->X1_VARIAVL := "mv_ch1"
   SX1->X1_PERGUNT := "De Matricula?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "If(Empty(Mv_par01),.t.,ExistCpo('SRA',mv_par01))"
   SX1->X1_VAR01   := "mv_par01"
   SX1->X1_F3      := "SRA"
   SX1->(MsUnLock())
Else
  If Alltrim(SX1->X1_VALID) != "If(Empty(Mv_par01),.t.,ExistCpo('SRA',mv_par01))"
      Reclock('SX1',.F.)
      SX1->X1_VALID   := "If(Empty(Mv_par01),.t.,ExistCpo('SRA',mv_par01))"
      SX1->X1_PERGUNT := "De Matricula?"
      SX1->(MsUnLock())
  Endif
endif
lIncSX1 := .f.
If !DbSeek(cPerg+"02")
  Reclock('SX1',.T.)
  lIncSX1 := .t.
Else
  If Alltrim(SX1->X1_PERGUNT) != "Ate Matricula?"
      Reclock('SX1',.F.)
      lIncSX1 := .t.
  Endif
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "02"
   SX1->X1_VARIAVL := "mv_ch2"
   SX1->X1_PERGUNT := "Ate Matricula?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "If(AteCodigo('SRA',Mv_par01,Mv_par02,6),.t.,.f.)"
   SX1->X1_VAR01   := "mv_par02"
   SX1->X1_F3      := "SRA"
   SX1->(MsUnLock())
Endif

lIncSX1 := .f.
If !DbSeek(cPerg+"03")
  Reclock('SX1',.T.)
  lIncSX1 := .t.
Else
  If Alltrim(SX1->X1_PERGUNT) != "De Centro de Custo?"
      Reclock('SX1',.F.)
      lIncSX1 := .t.
  Endif
Endif
If lIncSX1
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "03"
   SX1->X1_VARIAVL := "mv_ch3"
   SX1->X1_PERGUNT := "De Centro de Custo?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nSizeSI3
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "If(Empty(Mv_par03),.t.,Existcpo('"+cAlias+"',Mv_par03))"
   SX1->X1_VAR01   := "mv_par03"
   SX1->X1_F3      := cAlias
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"04")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "04"
   SX1->X1_VARIAVL := "mv_ch4"
   SX1->X1_PERGUNT := "Ate Centro de Custo?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := nSizeSI3
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "if(atecodigo('"+cAlias+"',mv_par03,mv_par04,"+StrZero(nSizeSI3,2)+"),.t.,.f.)"
   SX1->X1_VAR01   := "mv_par04"
   SX1->X1_F3      := cAlias
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"05")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "05"
   SX1->X1_VARIAVL := "mv_ch5"
   SX1->X1_PERGUNT := "De Funcao?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 04
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "If(Empty(Mv_par05),.t.,Existcpo('SRJ',Mv_par05))"
   SX1->X1_VAR01   := "mv_par05"
   SX1->X1_F3      := "SRJ"
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"06")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "06"
   SX1->X1_VARIAVL := "mv_ch6"
   SX1->X1_PERGUNT := "Ate Funcao?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 04
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "if(atecodigo('SRJ',mv_par05,mv_par06,4),.t.,.f.)"
   SX1->X1_VAR01   := "mv_par06"
   SX1->X1_F3      := "SRJ"
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"07")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "07"
   SX1->X1_PERGUNT := "Considerar Risco   ?"
   SX1->X1_VARIAVL := "mv_ch7"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par07"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Todos"
   SX1->X1_DEF02   := "Consta no PPP"
   MsUnLock("SX1")
ENDIF
If !DbSeek(cPerg+"08")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "08"
   SX1->X1_PERGUNT := "Desc. das Atividad.?"
   SX1->X1_VARIAVL := "mv_ch8"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par08"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Tarefa"
   SX1->X1_DEF02   := "Cargo"
   MsUnLock("SX1")
ENDIF
If !DbSeek(cPerg+"09")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "09"
   SX1->X1_PERGUNT := "Endereco da Empresa?"
   SX1->X1_VARIAVL := "mv_ch9"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par09"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Cobranca"
   SX1->X1_DEF02   := "Entrega"
   MsUnLock("SX1")
ENDIF
If !DbSeek(cPerg+"10")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "10"
   SX1->X1_PERGUNT := "Comprov. de Entrega?"
   SX1->X1_VARIAVL := "mv_cha"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par10"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Nao"
   SX1->X1_DEF02   := "Sim"
   MsUnLock("SX1")
Endif
If !DbSeek(cPerg+"11")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "11"
   SX1->X1_VARIAVL := "mv_chb"
   SX1->X1_PERGUNT := "Termo Responsab.?"
   SX1->X1_TIPO    := "C"
   SX1->X1_TAMANHO := 06
   SX1->X1_DECIMAL := 0
   SX1->X1_GSC     := "G"
   SX1->X1_VALID   := "If(Empty(Mv_par11),.t.,Existcpo('TMZ',Mv_par11))"
   SX1->X1_VAR01   := "mv_par11"
   SX1->X1_F3      := "TMZ"
   SX1->(MsUnLock())
Endif
If !DbSeek(cPerg+"12")
   Reclock('SX1',.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "12"
   SX1->X1_PERGUNT := "Utiliza Epc Eficaz?"
   SX1->X1_VARIAVL := "mv_chc"
   SX1->X1_TAMANHO := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NAOVAZIO()"
   SX1->X1_VAR01   := "mv_par12"
   SX1->X1_TIPO    := "N"
   SX1->X1_DEF01   := "Sim"
   SX1->X1_DEF02   := "Nao"
   MsUnLock("SX1")
Endif
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
wnRel := "PPP"+SM0->M0_CODIGO+SM0->M0_CODFIL
wnRel += IF(MV_PAR01==MV_PAR02,MV_PAR01,IF(EMPTY(MV_PAR01),"BRANCO",MV_PAR01)+MV_PAR02)+"_"
wnRel += STRZERO(DAY(DATE()),2)+"-"+STRZERO(MONTH(DATE()),2)+"-"+STRZERO(YEAR(DATE()),4)
aReturn[6] := wnRel
If nLastKey == 27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Set Filter to
   Return
Endif

RptStatus({|lEnd| R700Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R700Imp  ³ Autor ³Denis Hyroshi de Souza ³ Data ³21/10/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MDTR700                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function R700Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0
LOCAL nTotRegs  := 0 ,nMult := 1 ,nPosAnt := 4 ,nPosAtu := 4 ,nPosCnt := 0
PRIVATE lContinua := .T.
PRIVATE li := 0 ,m_pag := 1
nTipo  := IIF(aReturn[4]==1,15,18)

aDBF := {}
AADD(aDBF,{"NUMRIS"   ,"C",09,0})
AADD(aDBF,{"CODAGE"   ,"C",06,0})
AADD(aDBF,{"AGENTE"   ,"C",33,0})
AADD(aDBF,{"MAT"      ,"C",06,0})
AADD(aDBF,{"DT_DE"    ,"D",08,0})
AADD(aDBF,{"DT_ATE"   ,"D",08,0})
AADD(aDBF,{"SETOR"    ,"C",nSizeSI3,0})
AADD(aDBF,{"FUNCAO"   ,"C",04,0})
AADD(aDBF,{"TAREFA"   ,"C",06,0})
AADD(aDBF,{"INTENS"   ,"N",09,3})
AADD(aDBF,{"UNIDAD"   ,"C",06,0})
AADD(aDBF,{"TECNIC"   ,"C",20,0})
AADD(aDBF,{"PROTEC"   ,"C",03,0})
AADD(aDBF,{"EPC"      ,"C",03,0})
AADD(aDBF,{"GFIP"     ,"C",02,0})
AADD(aDBF,{"INDEXP"   ,"C",01,0})

cArqTrab := CriaTrab(aDBF,.t.)
cIDX1 := SUBSTR(cArqTrab,1,7)+"1"
cIDX2 := SUBSTR(cArqTrab,1,7)+"2"
Use (cArqTrab) NEW Exclusive Alias TRB
#IFDEF CDX
   INDEX ON dtos(DT_DE)+dtos(DT_ATE)+NUMRIS TAG (cIDX1) TO (cArqTrab)
   INDEX ON CODAGE+Str(INTENS,9,3) TAG (cIDX2) TO (cArqTrab)
#ELSE
   INDEX ON dtos(DT_DE)+dtos(DT_ATE)+NUMRIS TAG (cIDX1) TO (cArqTrab)
   INDEX ON CODAGE+Str(INTENS,9,3) TAG (cIDX2) TO (cArqTrab)
   SET INDEX TO (cIDX1),(cIDX2)
#ENDIF

aDBF1 := {}
AADD(aDBF1,{"DTDATA"   ,"D",08,0})
AADD(aDBF1,{"CCUSTO"   ,"C",nSizeSI3,0})
cArqTrab1 := CriaTrab(aDBF1)
Use (cArqTrab1) NEW Exclusive Alias TRBE
INDEX ON DTOS(DTDATA)+CCUSTO TO (cArqTrab1)

aDBF2 := {}
AADD(aDBF2,{"DTDATA"   ,"D",08,0})
AADD(aDBF2,{"TIPO"   ,"C",03,0})
AADD(aDBF2,{"FUNCAO"   ,"C",04,0})

cArqTrab2 := CriaTrab(aDBF2)
Use (cArqTrab2) NEW Exclusive Alias TRB7
INDEX ON DTOS(DTDATA)+TIPO TO (cArqTrab2)

aDBF3 := {}
AADD(aDBF3,{"EXAME"   ,"C",06,0})
AADD(aDBF3,{"NOMEX"   ,"C",40,0})
AADD(aDBF3,{"DTPRO"   ,"D",08,0})
AADD(aDBF3,{"DTRES"   ,"D",08,0})
AADD(aDBF3,{"TIPOE"   ,"C",16,0})
AADD(aDBF3,{"TIPOR"   ,"C",08,0})

cArqTrabX := CriaTrab(aDBF3,.t.)
cIDXX1 := SUBSTR(cArqTrabX,1,7)+"1"
cIDXX2 := SUBSTR(cArqTrabX,1,7)+"2"
Use (cArqTrabX) NEW Exclusive Alias TRBX
#IFDEF CDX
   INDEX ON DTOS(DTRES)+EXAME TAG (cIDXX1) TO (cArqTrabX)
   INDEX ON DTOS(DTPRO)+EXAME TAG (cIDXX2) TO (cArqTrabX)
#ELSE
   INDEX ON DTOS(DTRES)+EXAME TAG (cIDXX1) TO (cArqTrabX)
   INDEX ON DTOS(DTPRO)+EXAME TAG (cIDXX2) TO (cArqTrabX)
   SET INDEX TO (cIDXX1),(cIDXX2)
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Relatorio                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTypeEnd := If(Mv_par09==2,"ENT","COB")

DbSelectArea("SRA")
DbSetOrder(1)
DbSeek(xFilial("SRA")+MV_PAR01,.t.)
While !eof() .and. xFilial("SRA") == SRA->RA_FILIAL .and.  SRA->RA_MAT <= Mv_par02

   If SRA->RA_CC < Mv_par03 .or. SRA->RA_CC > Mv_par04
       DbSkip()
       Loop
   Endif
   If SRA->RA_CODFUNC < Mv_par05 .or. SRA->RA_CODFUNC > Mv_par06
       DbSkip()
       Loop
   Endif

   DbSelectArea("SRA")
   Matricula := SRA->RA_MAT
   NGMDT700() //Chamada da funcao que imprime o PPP

   Dbselectarea("TRB")
   Zap
   Dbselectarea("TRBE")
   Zap
   Dbselectarea("TRB7")
   Zap
   Dbselectarea("TRBX")
   Zap

   DbSelectArea("SRA")
   DbSkip()
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SRA")
Dbselectarea("TRB")
Use
Dbselectarea("TRBE")
Use
Dbselectarea("TRB7")
Use
Dbselectarea("TRBX")
Use
Set Filter To

Set device to Screen

If aReturn[5] = 1
        Set Printer To
        dbCommitAll()
        OurSpool(wnrel)
Endif
MS_FLUSH()

dbSelectArea("SRA")
Return NIL
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ NGMDT700 ³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime o Perfil Profissiografico Previdenciario           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NGMDT700()
Local cRespSim, cRespNao
Local aCat  := {}, aHist := {}, aExame := {} , aAUDIO := {}, aFATOR := {}
Local cODR1 := " ", cODR2 := " ", cODR3 := " ", cODR4 := " "
Local cOER1 := " ", cOER2 := " ", cOER3 := " ", cOER4 := " "
Local cODS1 := " ", cODS2 := " ", cODS3 := " ", cODS4 := " ", cODS5 := " ", cODS6 := " "
Local cOES1 := " ", cOES2 := " ", cOES3 := " ", cOES4 := " ", cOES5 := " ", cOES6 := " "
Private dODR := ctod("  /  /    "), dODS := ctod("  /  /    "), dOER := ctod("  /  /    "), dOES := ctod("  /  /    ")
Private aFuncao := {}
Private aCargo  := {}
Private aRiscos := {}
Private lFindCLI := .f.

Dbselectarea("SRJ")
Dbsetorder(1)
Dbseek(xFilial("SRJ")+SRA->RA_CODFUNC)

Dbselectarea("SQ3")
Dbsetorder(1)
Dbseek(xFilial("SQ3")+SRJ->RJ_CARGO)

Dbselectarea("TM0")
Dbsetorder(3)
Dbseek(xFilial("TM0")+Matricula)
nNum_Ficha := TM0->TM0_NUMFIC

aCat := NG700VECAT(nNum_Ficha) //Verifica se existe CAT para a Ficha Medica do Funcionario
If len(aCat) > 0     //Se existir CAT
  cRespSim := 'X'
  cRespNao := ' '
Else                 //Se nao existir CAT
  cRespSim := ' '
  cRespNao := 'X'
Endif

aHist  := NG700HISTO(Matricula)    // Retorna o historico profissiografico do funcionario
aExame := NG700EXAME(nNum_Ficha)   //  Retorna os exames feitos pelo funcionario
aAUDIO := NG700AUDIO(nNum_Ficha)   //  Retorna o resultado do exame de audiometria referencial

Dbselectarea("SRJ")
Dbsetorder(1)
Dbseek(xFilial("SRJ")+SRA->RA_CODFUNC)

Dbselectarea("SQ3")
Dbsetorder(1)
Dbseek(xFilial("SQ3")+SRJ->RJ_CARGO)

If len(aAUDIO) > 0
  For xx := 1 to len(aAUDIO)

      If aAUDIO[xx][1] == "ODR"
          cODR1 := If( (aAUDIO[xx][2] == "1" .or. aAUDIO[xx][2] == "3"),"X"," ")
          cODR2 := If( (aAUDIO[xx][2] != "1" .and. aAUDIO[xx][2] != "3"),"X"," ")
          If Empty(cODR1)
              cODR3 := If( (aAUDIO[xx][3] == "2"),"X"," ")
              cODR4 := If( (aAUDIO[xx][3] == "1"),"X"," ")
          Endif

      ElseIf aAUDIO[xx][1] == "ODS" .and. (dODS >= dODR .or. Empty(dODR))
          cODS1 := If( (aAUDIO[xx][2] == "1" .or. aAUDIO[xx][2] == "3"),"X"," ")
          cODS2 := If( (aAUDIO[xx][2] != "1" .and. aAUDIO[xx][2] != "3"),"X"," ")
          If Empty(cODS1)
              cODS3 := If( (aAUDIO[xx][3] == "2"),"X"," ")
              cODS4 := If( (aAUDIO[xx][3] == "1"),"X"," ")
          Endif
          cODS5 := If( (aAUDIO[xx][2] == "5"),"X"," ")
          cODS6 := If( (aAUDIO[xx][2] == "2" .or. aAUDIO[xx][2] == "4"),"X"," ")

      ElseIf aAUDIO[xx][1] == "OER"
          cOER1 := If( (aAUDIO[xx][2] == "1" .or. aAUDIO[xx][2] == "3"),"X"," ")
          cOER2 := If( (aAUDIO[xx][2] != "1" .and. aAUDIO[xx][2] != "3"),"X"," ")
          If Empty(cOER1)
              cOER3 := If( (aAUDIO[xx][3] == "2"),"X"," ")
              cOER4 := If( (aAUDIO[xx][3] == "1"),"X"," ")
          Endif

      ElseIf aAUDIO[xx][1] == "OES"   .and. (dOES >= dOER .or. Empty(dOER))
          cOES1 := If( (aAUDIO[xx][2] == "1" .or. aAUDIO[xx][2] == "3"),"X"," ")
          cOES2 := If( (aAUDIO[xx][2] != "1" .and. aAUDIO[xx][2] != "3"),"X"," ")
          If Empty(cOES1)
              cOES3 := If( (aAUDIO[xx][3] == "2"),"X"," ")
              cOES4 := If( (aAUDIO[xx][3] == "1"),"X"," ")
          Endif
          cOES5 := If( (aAUDIO[xx][2] == "5"),"X"," ")
          cOES6 := If( (aAUDIO[xx][2] == "2" .or. aAUDIO[xx][2] == "4"),"X"," ")

      Endif
  Next xx
Endif

lDo := .t.
cNOMERES := space(20)
cCRMRES  := space(12)
DbSelectArea("TMW")
Dbsetorder(1)
DbGoBottom()
While !Bof() .and. lDo
  If xFilial("TMW") == TMW->TMW_FILIAL .and. ;
     dDatabase >= TMW->TMW_DTINIC .and. dDatabase <= TMW->TMW_DTFIM

      DbSelectArea("TMK")
      DbSetOrder(1)
      If DbSeek(xFilial("TMK")+TMW->TMW_CODUSU)
          cNOMERES := Alltrim(TMK->TMK_NOMUSU)
          cCRMRES  := Alltrim(TMK->TMK_NUMENT)
          lDo := .f.
      Endif
  ENdif
  Dbselectarea("TMW")
  Dbskip(-1)
End

If lNGMDTPS
  Dbselectarea("SA1")
  Dbsetorder(1)
  If TM0->(FieldPos("TM0_CLIENT")) > 0
      If Dbseek(xFilial("SA1")+TM0->TM0_CLIENT)
          lFindCLI := .t.
      Endif
  Endif

  If !lFindCLI
      If TM0->(FieldPos("TM0_CC")) > 0
          If Dbseek(xFilial("SA1")+Substr(TM0->TM0_CC,1,6))
              lFindCLI := .t.
          Endif
      Endif
  Endif

  If !lFindCLI
      If Dbseek(xFilial("SA1")+Substr(SRA->RA_CC,1,6))
          lFindCLI := .t.
      Endif
  Endif
Endif

Li := 1

@li,044 Psay "PERFIL PROFISSIOGRAFICO PREVIDENCIARIO - PPP"
Somalinha()
@li,001 Psay replicate("_",131)
Somalinha()
@li,000 Psay "|1-"
@li,003 Psay "Empresa/Estabelecimento:"
@li,091 Psay "|2-"
@li,094 Psay "CNAE"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
If lNGMDTPS .and. lFindCLI
  @li,003 Psay SA1->A1_NOME
Else
  @li,003 Psay SM0->M0_NOMECOM
Endif
@li,091 Psay "|"
If lNGMDTPS .and. lFindCLI
  @li,094 Psay SA1->A1_ATIVIDA
Else
  @li,094 Psay SM0->M0_CNAE
Endif
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
If lNGMDTPS .and. lFindCLI
  @li,003 Psay SA1->A1_END
Else
  @li,003 Psay &("SM0->M0_END"+cTypeEnd)
Endif
@li,091 Psay "|________________________________________|"
Somalinha()
If lNGMDTPS .and. lFindCLI
  If !empty(SA1->A1_EST)
      cCidade := alltrim(SA1->A1_MUN)+"-"+SA1->A1_EST
  Else
      cCidade := alltrim(SA1->A1_MUN)
  Endif
Else
  If !empty(&("SM0->M0_EST"+cTypeEnd))
      cCidade := alltrim(&("SM0->M0_CID"+cTypeEnd))+"-"+&("SM0->M0_EST"+cTypeEnd)
  Else
      cCidade := alltrim(&("SM0->M0_CID"+cTypeEnd))
  Endif
Endif
@li,000 Psay "|"
If !Empty(cCidade)
  @li,003 Psay substr(cCidade,1,23)
Endif
@li,033 Psay "CEP:"
If lNGMDTPS .and. lFindCLI
  @li,038 Psay SA1->A1_CEP Picture "@R 99999-999"
Else
  @li,038 Psay &("SM0->M0_CEP"+cTypeEnd) Picture "@R 99999-999"
Endif
@li,091 Psay "|3-"
@li,094 Psay "ANO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,003 Psay "CNPJ:"
If lNGMDTPS .and. lFindCLI
  @li,009 Psay SA1->A1_CGC Picture "@R 99.999.999/9999-99"
Else
  @li,009 Psay SM0->M0_CGC Picture "@R 99.999.999/9999-99"
Endif
//@li,055 Psay SRJ->RJ_CBO
@li,091 Psay "|"
@li,094 Psay year(dDatabase)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|__________________________________________________________________________________________|________________________________________|"
Somalinha()
@li,000 Psay "|4-"
@li,003 Psay "Nome do Trabalhador"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,003 Psay SRA->RA_NOME
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|5-"
@li,003 Psay "NIT(PIS/PASEP)"
@li,043 Psay "|6-"
@li,046 Psay "CTPS"
@li,086 Psay "|7-"
@li,089 Psay "Admissao na Empresa"
@li,132 Psay "|"
//@li,055 Psay STR0012 //"CBO"
SomaLinha()
@li,000 Psay "|"
@li,003 Psay SRA->RA_PIS
@li,043 Psay "|"
@li,046 Psay SRA->RA_NUMCP Picture "@R 999.999"
@li,059 Psay SRA->RA_SERCP Picture "99999"
@li,086 Psay "|"
@li,089 Psay SRA->RA_ADMISSA
@li,132 Psay "|"
SomaLinha()
@li,000 Psay "|__________________________________________|__________________________________________|_____________________________________________|"
Somalinha()
@li,000 Psay "|8-"
@li,003 Psay "Data de Nascimento"
@li,066 Psay "|9-"
@li,069 Psay "SEXO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,003 Psay SRA->RA_NASC
If SRA->RA_SEXO == "M"
   _SEXO := "Masculino"
Else
   _SEXO := "Feminino"
Endif
@li,066 Psay "|"
@li,069 Psay _SEXO Picture "@!"
@li,132 Psay "|"
SomaLinha()
@li,000 Psay "|_________________________________________________________________|_________________________________________________________________|"
Somalinha()
lPosi := .f.
lLen  := .f.
If len(acat) > 0
  For xx := 1 to len(aCat)
      If len( acat ) == xx
          lLen := .t.
      EndIf
      nResto := Mod(xx,2)
      If xx == 1
          @li,000 Psay "|10-"
          @li,004 Psay "CAT emitida no periodo: "
          @li,030 Psay "SIM"+"("+cRespSim+")" //"SIM"
          @li,038 Psay "NAO"+"("+cRespNao+")" //"NAO"
          @li,066 Psay "|"
          @li,132 Psay "|"
      EndIf
      If nResto = 1 .and. lLen
          SomaLinha()
          @li,000 Psay "|"
          If xx == 1
              @li,002 Psay "Emissao:"
          Endif
          @li,013 Psay aCat[xx][1]
          @li,025 Psay "No."
          @li,029 Psay aCat[xx][2]
          @li,066 Psay "|"
          @li,132 Psay "|"
      Elseif nResto = 0
          SomaLinha()
          @li,000 Psay "|"
          If xx == 2
              @li,002 Psay "Emissao:"
          Endif
          @li,013 Psay aCat[xx-1][1]
          @li,025 Psay "No."
          @li,029 Psay aCat[xx-1][2]
          @li,066 Psay "|"

          If xx == 2
              @li,068 Psay "Emissao:"
          Endif
          @li,079 Psay aCat[xx][1]
          @li,091 Psay "No."
          @li,095 Psay aCat[xx][2]
          @li,132 Psay "|"
      EndIf
  Next xx
Else
  @li,000 Psay "|10-"
  @li,004 Psay "CAT emitida no periodo: "
  @li,030 Psay "SIM"+"( )" //"SIM"
  @li,038 Psay "NAO"+"(X)" //"NAO"
  @li,066 Psay "|"
  @li,132 Psay "|"
Endif
Somalinha()
@li,000 Psay "|_________________________________________________________________|_________________________________________________________________|"
Somalinha()
@li,000 Psay "|11-"
@li,004 Psay "Requisitos da Funcao:"
@li,132 Psay "|"
lMv_achou := .f.
Dbselectarea("SX6")
Dbsetorder(1)
If Dbseek(xFilial("SX6")+"MV_USACSA")
  If Alltrim(GETMV("MV_USACSA")) == "S"

      aFATOR := NG700FATOR(SQ3->Q3_GRUPO) // Busca os fatores do Grupo do Cargo exercido pelo Funcionario
      For xx := 1 To Len(aFATOR)
          lMv_achou := .t.
          If !Empty(aFATOR[xx][1])
              SomaLinha()
              @ Li,000 Psay "|"
              @ Li,004 Psay aFATOR[xx][1] Picture "@!"
              @ Li,132 Psay "|"
          EndIf
      Next xx
  Endif
Endif
If !lMv_achou
  For nFx := 1 to Len(aFuncao)
      Dbselectarea("SRJ")
      Dbsetorder(1)
      If Dbseek(xFilial("SRJ")+aFuncao[nFx][1])
          If SRJ->(FieldPos('RJ_DESCREQ')) > 0
              cMemo := MSMM(SRJ->RJ_DESCREQ)
              nLinhasMemo := MLCOUNT(cMemo,117)
              For LinhaCorrente := 1 To nLinhasMemo
                  If LinhaCorrente == 1
                      SomaLinha()
                      @ Li,000 Psay "|"
                      @ Li,004 Psay aFuncao[nFx][2] Picture "@!"
                      @ Li,132 Psay "|"
                  Endif
                  If !Empty((MemoLine(cMemo,117,LinhaCorrente)))
                      SomaLinha()
                      @ Li,000 Psay "|"
                      @ Li,010 Psay (MemoLine(cMemo,117,LinhaCorrente)) Picture "@!"
                      @ Li,132 Psay "|"
                  EndIf
              Next LinhaCorrente
          Endif
      Endif
  Next nFx
Endif
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,001 Psay replicate("_",131)
Somalinha()
@li,000 Psay "|"
@li,054 Psay "DESCRICAO PROFISSIOGRAFICA"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
ATIV700R()//IMPRIME DESCRICAO DAS ATIVIDADES
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|13-"
@li,004 Psay "Periodo"
@li,022 Psay "|14-"
@li,026 Psay "Setor"
@li,055 Psay "|15-"
@li,059 Psay "Cargo"
@li,085 Psay "|16-"
@li,089 Psay "Funcao"
@li,115 Psay "|17-"
@li,119 Psay "CBO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|_____________________|________________________________|_____________________________|_____________________________|________________|"
If len(aHist) > 0
  For i := 1 to len(aHist)
      Somalinha()
      @li,000 Psay "|"
      @li,001 Psay NGPPPDATE(aHist[i][2])
      @li,010 Psay "a"
      If i == len(aHist)
          @li,012 Psay NGPPPDATE(aHist[i][3])
      Else
          @li,012 Psay NGPPPDATE(aHist[i][3]-1)
      Endif
      @li,022 Psay "|"
      @li,023 Psay SubStr(aHist[i][4],1,30)
      @li,055 Psay "|"
      @li,056 Psay SubStr(aHist[i][5],1,29)
      @li,085 Psay "|"
      @li,086 Psay SubStr(aHist[i][6] ,1,29)
      @li,115 Psay "|"
      @Li,120 Psay aHist[i][7]
      @li,132 Psay "|"
      Somalinha()
      @li,000 Psay "|_____________________|________________________________|_____________________________|_____________________________|________________|"
  Next i
Else
  Somalinha()
  @li,000 Psay "|"
  @li,020 Psay "|"
  @li,041 Psay "|"
  @li,066 Psay "|"
  @li,081 Psay "|"
  @li,132 Psay "|"
  Somalinha()
  @li,000 Psay "|_____________________|________________________________|_____________________________|_____________________________|________________|"
Endif

Somalinha()
If li <= 68
  li := 1
Endif
//SEGUNDA FOLHA**********************************************************

@li,001 Psay replicate("_",131)
Somalinha()
@li,000 Psay "|"
@li,061 Psay "EXPOSICAO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|18-"
@li,004 Psay "Periodo"
@li,021 Psay "|19-"
@li,025 Psay "Agente"
@li,057 Psay "|20-"
@li,061 Psay "Itensidade"+"/"  //"Itensidade"
@li,080 Psay "|21-"
@li,084 Psay Substr(Alltrim("Tecnica")+" "+"      ",1,18)        //"Tecnica"
@li,102 Psay "|22-"
@li,106 Psay "Protecao Eficaz"
@li,122 Psay "|23-"
@li,126 Psay "GFIP"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,021 Psay "|"
@li,057 Psay "|"
@li,059 Psay "Concentracao"
@li,080 Psay "|"
@li,102 Psay "|"
@li,107 Psay "EPI"+" / "+"EPC" //"EPI"###"EPC"
@li,122 Psay "|"
@li,126 Psay "Codigo"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|____________________|___________________________________|______________________|_____________________|___________________|_________|"
lNot := .t.
Dbselectarea("TRB")
Dbsetorder(1)
Dbgotop()
While !eof()
  Somalinha()
  @li,000 Psay "|"
  @li,001 Psay NGPPPDATE(TRB->DT_DE)
  @li,010 Psay "-"
  @li,012 Psay NGPPPDATE(TRB->DT_ATE)
  @li,021 Psay "|"
  @li,023 Psay TRB->AGENTE
  @li,057 Psay "|"
  If TRB->INTENS == 0
      @li,063 Psay Substr("QUALITATIVA",1,15)//"QUALITATIVA"
  Else
      @li,061 Psay TRB->INTENS Picture "@E 99,999.999"
      @li,073 Psay TRB->UNIDAD Picture "@!"
  Endif
  @li,080 Psay "|"
  @li,082 Psay TRB->TECNIC
  @li,102 Psay "|"
  @li,107 Psay TRB->PROTEC
  @li,111 Psay "/"
  @li,113 Psay TRB->EPC
  @li,122 Psay "|"
  @li,126 Psay TRB->GFIP
  @li,132 Psay "|"
  Somalinha()
  @li,000 Psay "|____________________|___________________________________|______________________|_____________________|___________________|_________|"
    lNot := .f.
  Dbskip()
End
If lNot
  Somalinha()
  @li,000 Psay "|"
  @li,021 Psay "|"
  @li,057 Psay "|"
  @li,080 Psay "|"
  @li,102 Psay "|"
  @li,122 Psay "|"
  @li,132 Psay "|"
  Somalinha()
  @li,000 Psay "|____________________|___________________________________|______________________|_____________________|___________________|_________|"
Endif
Somalinha()
@li,001 Psay replicate("_",131)
Somalinha()
@li,000 Psay "|"
@li,040 Psay "EXAMES MEDICOS CLINICOS E COMPLEMENTARES REF. EXPOSICAO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|24-"
@li,004 Psay "Data"
@li,015 Psay "|25-"
@li,019 Psay "Tipo"
@li,044 Psay "|26-"
@li,048 Psay "Descricao dos Resultados (normais/alterados)"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|______________|____________________________|_______________________________________________________________________________________|"

nTRBX := 0
Dbselectarea("TRBX")
Dbsetorder(1)
Dbgotop()
While !eof()
  nTRBX++
  Somalinha()
  @li,000 Psay "|"
  @li,004 Psay NGPPPDATE(TRBX->DTRES)
  @li,015 Psay "|"
  @li,019 Psay TRBX->TIPOE Picture "@!"
  @li,044 Psay "|"
  If Empty(TRBX->TIPOR)
      @li,048 Psay "NORMAL" Picture "@!"
  Else
      @li,048 Psay TRBX->TIPOR Picture "@!"
  EndIf
  @li,132 Psay "|"
  Somalinha()
  @li,000 Psay "|______________|____________________________|_______________________________________________________________________________________|"
  Dbskip()
End
If nTRBX = 0
  Somalinha()
  @li,000 Psay "|"
  @li,015 Psay "|"
  @li,044 Psay "|"
//    @li,076 Psay "|"
  @li,132 Psay "|"
  Somalinha()
  @li,000 Psay "|______________|____________________________|_______________________________________________________________________________________|"
Endif
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|"
@li,050 Psay Alltrim("Exame Audiometrico de")+" "+Alltrim("Referencia") //"Exame Audiometrico de"#"Referencia"
@li,088 Psay "|"
@li,095 Psay "Exame Audiometrico Sequencial"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|              |                            |___________________________________________|___________________________________________|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|"
@li,048 Psay "Orelha Direita"
@li,066 Psay "|"
@li,070 Psay "Orelha Esquerda"
@li,088 Psay "|"
@li,092 Psay "Orelha Direita"
@li,110 Psay "|"
@li,114 Psay "Orelha Esquerda"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|              |                            |_____________________|_____________________|_____________________|_____________________|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|("+cODR1+")"
@li,050 Psay "Normal"
@li,066 Psay "|("+cOER1+")"
@li,072 Psay "Normal"
@li,088 Psay "|("+cODS1+")"
@li,094 Psay "Normal"
@li,110 Psay "|("+cOES1+")"
@li,116 Psay "Normal"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|              |                            |_____________________|_____________________|_____________________|_____________________|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|("+cODR2+")"
@li,050 Psay "Anormal"
@li,066 Psay "|("+cOER2+")"
@li,072 Psay "Anormal"
@li,088 Psay "|("+cODS2+")"
@li,094 Psay "Anormal"
@li,110 Psay "|("+cOES2+")"
@li,116 Psay "Anormal"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|"
@li,066 Psay "|"
@li,088 Psay "|  ("+cODS6+")"
@li,096 Psay "Estavel"
@li,110 Psay "|  ("+cOES6+")"
@li,118 Psay "Estavel"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|"
@li,066 Psay "|"
@li,088 Psay "|  ("+cODS5+")"
@li,096 Psay "Agravamento"
@li,110 Psay "|  ("+cOES5+")"
@li,118 Psay "Agravamento"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|              |                            |_____________________|_____________________|_____________________|_____________________|"
Somalinha()
@li,000 Psay "|              |                            |"
@li,056 Psay "Origem da Anormalidade"
@li,088 Psay "|"
@li,100 Psay "Origem da Anormalidade"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|              |                            |___________________________________________|___________________________________________|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|("+cODR3+")"
@li,050 Psay "Ocupacional"
@li,066 Psay "|("+cOER3+")"
@li,072 Psay "Ocupacional"
@li,088 Psay "|("+cODS3+")"
@li,094 Psay "Ocupacional"
@li,110 Psay "|("+cOES3+")"
@li,116 Psay "Ocupacional"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|              |                            |_____________________|_____________________|_____________________|_____________________|"
Somalinha()
@li,000 Psay "|"
@li,015 Psay "|"
@li,044 Psay "|("+cODR4+")"
@li,050 Psay Substr("Nao Ocupacional",1,16) //"Nao Ocupacional"
@li,066 Psay "|("+cOER4+")"
@li,072 Psay Substr("Nao Ocupacional",1,16) //"Nao Ocupacional"
@li,088 Psay "|("+cODS4+")"
@li,094 Psay Substr("Nao Ocupacional",1,16) //"Nao Ocupacional"
@li,110 Psay "|("+cOES4+")"
@li,116 Psay Substr("Nao Ocupacional",1,16) //"Nao Ocupacional"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|______________|____________________________|_____________________|_____________________|_____________________|_____________________|"
Somalinha()
@li,000 Psay "|"
@li,052 Psay "EXPOSICAO A AGENTE NOCIVO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|27-"
@li,004 Psay "Agente"
@li,042 Psay "|"
@li,044 Psay "Habitual / Permanente"
@li,069 Psay "|"
@li,071 Psay "Ocasional / Intermitente"
@li,099 Psay "|"
@li,101 Psay "Ausencia de Agente Nocivo"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|_________________________________________|__________________________|_____________________________|________________________________|"
lTrb := .f.
cRiscoant := ""
Dbselectarea("TRB")
Dbsetorder(2)
Dbgotop()
While !eof()
  If Empty(TRB->INDEXP) .OR. TRB->INDEXP == "3"
      Dbskip()
      Loop
  Endif
  If cRiscoant == TRB->CODAGE+Str(TRB->INTENS,9,3)
      Dbskip()
      Loop
  Endif
  cRiscoant := TRB->CODAGE+Str(TRB->INTENS,9,3)
  lTrb := .t.

  Somalinha()
  @li,000 Psay "|"
  @li,001 Psay Substr(TRB->AGENTE,1,40)
  @li,042 Psay "|"
  @li,055 Psay If(TRB->INDEXP == "1","X"," ")
  @li,069 Psay "|"
  @li,084 Psay If(TRB->INDEXP == "2","X"," ")
  @li,099 Psay "|"
  @li,132 Psay "|"
  Dbskip()

End
If !lTrb
  Somalinha()
  @li,000 Psay "|"
  @li,042 Psay "|"
  @li,069 Psay "|"
  @li,099 Psay "|"
  @li,115 Psay "X"
  @li,132 Psay "|"
  Somalinha()
  @li,000 Psay "|_________________________________________|__________________________|_____________________________|________________________________|"
Else
  Somalinha()
  @li,000 Psay "|_________________________________________|__________________________|_____________________________|________________________________|"
Endif

Somalinha()
@li,000 Psay "|28-"
@li,004 Psay "Data de Emissao do Documento"+":" //"Data de Emissao do Documento"
@li,042 Psay dDataBase
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,001 Psay replicate("_",131)
Somalinha()
@li,000 Psay "|"
@li,047 Psay "Responsavel pelas Avaliacoes/Informacoes"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,048 Psay "|"
@li,090 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,048 Psay "|"
@li,090 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,048 Psay "|"
@li,090 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|    _______________________________________    |    _________________________________    |    _________________________________    |"
Somalinha()

nSize := if(len(cNOMERES) <= 43,len(cNOMERES),43)
If len(cNOMERES) > 43
  cNOMERES := substr(cNOMERES,1,43)
Endif
nSize := 43 - nSize
nTabu := 1
If nSize > 1
  If (nSize % 2) != 0
      nSize++
      nTabu := (nSize / 2) - 1
  Else
      nTabu := nSize / 2
  Endif
Endif

cCRMRES := "CRM: "+cCRMRES //"CRM: "
nSize2 := if(len(cCRMRES) <= 43,len(cCRMRES),43)
If len(cCRMRES) > 43
  cCRMRES := substr(cNOMERES,1,43)
Endif
nSize2 := 43 - nSize2
nTabu2 := 1
If nSize2 > 1
  If (nSize2 % 2) != 0
      nSize2++
      nTabu2 := (nSize2 / 2) - 1
  Else
      nTabu2 := nSize2 / 2
  Endif
Endif
limpmed := .t.
Dbselectarea("SX6")
Dbsetorder(1)
If Dbseek(xFilial("SX6")+"MV_NG2IMC")
  If Alltrim(GETMV("MV_NG2IMC")) == "N"
  limpmed := .f.
  Endif
Endif

@li,000 Psay "|"
IF limpmed
  @li,002 Psay space(nTabu)+cNOMERES
ELSE
  @li,014 Psay " " // STR0069
ENDIF
@li,048 Psay "|"
@li,060 Psay "Nome e CRM/CREA do"
@li,090 Psay "|"
@li,105 Psay "Gerente de RH"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
IF limpmed
  @li,002 Psay space(nTabu2)+cCRMRES
ELSE
  @li,013 Psay "Coordenador do PCMSO"
ENDIF
@li,048 Psay "|"
@li,058 Psay "Responsavel pelo LTCAT"
@li,090 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|_______________________________________________|_________________________________________|_________________________________________|"
Somalinha()
@li,000 Psay "|"
@li,030 Psay "As informacoes sao veridicas e fundamentadas por LTCAT/PPRA/PGR e PCMSO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"

If Mv_par10 == 2
  MDTERMO700()
Endif

/*
          1         2         3         4         5         6         7         8         9         0         1        12        13
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

                        PERFIL PROFISSIOGRAFICO PREVIDENCIARIO - PPP
 ___________________________________________________________________________________________
|1-Empresa/Estabelecimento:CNPJ                     |2-NIT(PIS/PASEP)  |3-CNAE              |
|  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX             |  XXXXXXXXXXX     |  XXXXXXX           |
|  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                   |__________________|____________________|
|  XXXXXXXXXXXXXXXXXXXX-XX    XXXXX-XXX             |4-CBO             |5-ANO               |
|  XXXXXXXXXXXXXX                                   |  XXXXX           |  2002              |
|___________________________________________________|__________________|____________________|
|6-Nome do Trabalhador                                                                      |
|                                                                                           |
|___________________________________________________________________________________________|
|7-Data de Nascimento                                                                       |
|                                                                                           |
|___________________________________________________________________________________________|
|8-SEXO                                                                                     |
|                                                                                           |
|___________________________________________________________________________________________|
|9-Admissao na Empresa|10-CTPS         |11-CAT emitida no periodo:  SIM( )      NAO( )      |
|  99/99/99           |  999.999 99999 |    Data da Emissao: 99/99/99   No 999999           |
|_____________________|________________|____________________________________________________|
|12-Requisitos da Funcao: XXXXXXXXXXXXXXXXXXXX                                              |
|   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  |
|   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  |
|   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  |
|___________________________________________________________________________________________|
 ___________________________________________________________________________________________
|                                 DESCRICAO PROFISSIOGRAFICA                                |
|___________________________________________________________________________________________|
|13-Descricao das Atividades: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                |
or            próximo            pesquisar
|13-Descricao das Atividades: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                |
|___________________________________________________________________________________________|
|14-Periodo         |15-Setor                |16-Cargo                |17-Funcao            |
|___________________|________________________|________________________|_____________________|
|99/99/99 a 99/99/99| 12345678901234567890123| 12345678901234567890123| 12345678901234567890|
|___________________|________________________|________________________|_____________________|
|99/99/99 a 99/99/99| 12345678901234567890123| 12345678901234567890123| 12345678901234567890|
|___________________|________________________|________________________|_____________________|
 OONONONONONONONOOOONONONOONONONONONONONONONONONONONONON
  OONONONONONONONOOOONONONOONONONONONONONONONONONONONONON
   OONONONONONONONOOOONONONOONONONONONONONONONONONONONONON
 M
          1         2         3         4         5         6         7         8         9         0         1        12        13
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
 ___________________________________________________________________________________________
|                                        EXPOSICAO                                          |
|___________________________________________________________________________________________|
|18-Periodo         |19-Agente       |20-Itensidade/|21-Tecnica |22-Protecao Eficaz |23-GFIP|
|                   |                | Concentracao | Utilizada |    EPI / EPC      | Codigo|
|___________________|________________|______________|___________|___________________|_______|
|99/99/99 a 99/99/99| XXXXXXXXXXXXX15| 99.999,99    | XXXXXXXXXX| XXXXXXXXXXXXXXXX18|   XX  |
|___________________|________________|______________|___________|___________________|_______|
|99/99/99 a 99/99/99| XXXXXXXXXXXXX15| 99.999,99    |           | XXXXXXXXXXXXXXXX18|   XX  |
|___________________|________________|______________|___________|___________________|_______|
 ___________________________________________________________________________________________
|                        EXAMES MEDICOS CLINICOS E COMPLEMENTARESPOSICAO                    |
|___________________________________________________________________________________________|
|24-Data |26-Tipo           |27-Descricao dos Resultados (Normal/Alterado)                  |
|________|__________________|_______________________________________________________________|
|99/99/99| XXXXXXXXXXXXXXXX |   XXXXXXXXXX                                                  |
|________|__________________|_______________________________________________________________|
|99/99/99| XXXXXXXXXXXXXXXX |   XXXXXXXXXX                                                  |
|________|__________________|_______________________________________________________________|
|        |                  |      Exame Audiometrico de   |      Exame Audiometrico de     |
|        |                  |           Referencia         |           Sequencial           |
|        |                  |______________________________|________________________________|
|        |                  |Orelha Direita|Orelha Esquerda|Orelha Direita  | Orelha Esquerd|
|        |                  |______________|_______________|________________|_______________|
|        |                  |( ) Normal    |( ) Normal     |( ) Normal      |( ) Normal     |
|        |                  |______________|_______________|________________|_______________|
|        |                  |( ) Anormal   |( ) Anormal    |( ) Anormal     |( ) Anormal    |
or            próximo            pesquisar
|        |                  |( ) Anormal   |( ) Anormal    |( ) Anormal     |( ) Anormal    |
|        |                  |              |               |  ( )Estavel    |  ( )Estavel   |
|        |                  |              |               |  ( )Agravamento|  ( )Agravament|
|        |                  |______________|_______________|________________|_______________|
|        |                  |( )Ocupacional|( )Ocupacional |( )Ocupacional  |( )Ocupacional |
|        |                  |______________|_______________|________________|_______________|
|        |                  |( )Nao        |( )Nao         |( )Nao          |( )Nao         |
|        |                  | Ocupacional  | Ocupacional   | Ocupacional    | Ocupacional   |
|________|__________________|______________|_______________|________________|_______________|
|                               EXPOSICAO A AGENTE NOCIVO                                   |
|___________________________________________________________________________________________|
|27-Agente       | Habitual/Permanente | Ocasional/Intermitente | Ausencia de Agente Nocivo |
|________________|_____________________|________________________|___________________________|
|RUIDO CONTINUO  |         X           |                        |                           |
|DHSJD KS DKASM  |                     |                        |             X             |
|________________|_____________________|________________________|___________________________|
|28-Data de Emissao do Documento:         99/99/99                                          |
|___________________________________________________________________________________________|
 ___________________________________________________________________________________________
|                          Responsavel pelas Avaliacoes/Informacoes                         |
|___________________________________________________________________________________________|
|                                  |                            |                           |
|                                  |                            |                           |
|                                  |                            |                           |
| ________________________________ | __________________________ | __________________________|
| DENIS HYROSHI DE SOUZA           |     Nome e CRM/CREA do     |       Gerente de RH       |
|         CRM: 237388299393        |   Responsavel pelo LTCAT   |   (assinatura e carimbo)  |
|__________________________________|____________________________|___________________________|
|         As informacoes sao veridicas e fundamentadas por LTCAT/PPRA/PGR e PCMSO           |
|___________________________________________________________________________________________|
*/
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700VECAT³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Verifica se o Funcionario tem Cat impresso.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
or            próximo            pesquisar
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700VECAT(nFicha)
Local aVerCat := {}
Local lSai := .f.

Dbselectarea("TNC")
Dbsetorder(1)
Dbseek(xFilial("TNC"))

While !Eof() .and. xFilial("TNC") == TNC->TNC_FILIAL

  If nFicha = TNC->TNC_NUMFIC .And. !Empty(TNC->TNC_DTEMIS)

      cCat := TNC->TNC_ACIDEN

      If TNC->(FieldPos('TNC_CATINS')) > 0
          If !Empty(TNC->TNC_CATINS)
              cCat := TNC->TNC_CATINS
          Else
              Dbselectarea("TNC")
              Dbskip()
              Loop
          Endif
      Endif
      AADD(aVerCat,{TNC->TNC_DTEMIS,SubStr(cCat,1,20)})

  Endif
  Dbskip()
End

Return aVerCat
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700HISTO³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Carrega os dados do historico do funcionario               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
or            próximo            pesquisar
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700HISTO(cMatr)
Local aHistory := {}
Local dDe_Data, dAte_Data, cFuncao, dPro_Data, cCC, cCargo := ' ', lSRE := .f., lSR7 := .f., lGoSR7 := .f., lGoSRE := .f.
Local dtSRE := cTod("  /  /  ")
Local dtSR7 := cTod("  /  /  ")
Local aSRE := {}
Local aSR7 := {}
Local dDtFINAL := If(empty(SRA->RA_DEMISSA),dDataBase,SRA->RA_DEMISSA)
Local cCBO := 0
lHisSal := .f.
cFuncOld := " "
Dbselectarea("SR7")
Dbsetorder(1)
Dbseek(SRA->RA_FILIAL+cMatr)
While !eof() .and. SR7->R7_FILIAL == SRA->RA_FILIAL .And.;
      SR7->R7_MAT == cMatr

  If cFuncOld == SR7->R7_FUNCAO
      Dbselectarea("SR7")
      Dbskip()
      Loop
  Endif
  cFuncOld := SR7->R7_FUNCAO
  Dbselectarea("TRB7")
  TRB7->(Dbappend())
  TRB7->DTDATA :=  SR7->R7_DATA
  TRB7->TIPO   :=  SR7->R7_TIPO
  TRB7->FUNCAO :=  SR7->R7_FUNCAO
  If SR7->R7_DATA > dDtFINAL
      dDtFINAL := dDataBase
  Endif
  lHisSal := .t.
  Dbselectarea("SR7")
  Dbskip()
End
Dbselectarea("TRB7")
DBGoTop()
If !Dbseek(DTOS(SRA->RA_ADMISSA)) .and. lHisSal
  TRB7->(Dbappend())
  TRB7->DTDATA :=  SRA->RA_ADMISSA
Endif

cOLdCusto := " "
LPRIMEIRO := .T.
Dbselectarea("SRE")
Dbsetorder(1)
Dbseek(cEmpAnt+SRA->RA_FILIAL+cMatr)
While !eof() .and. cEmpAnt == SRE->RE_EMPD .and.;
  SRE->RE_FILIALD == SRA->RA_FILIAL .And. SRE->RE_MATD == cMatr

    IF LPRIMEIRO
      LPRIMEIRO  := .F.
      Dbselectarea("TRBE")
      TRBE->(Dbappend())
      TRBE->DTDATA  := SRA->RA_ADMISSA
      TRBE->CCUSTO := SRE->RE_CCD
  ENDIF
  If cOLdCusto == SRE->RE_CCP
      Dbselectarea("SRE")
      Dbskip()
      Loop
  Endif
  cOLdCusto := SRE->RE_CCP
  Dbselectarea("TRBE")
  TRBE->(Dbappend())
  TRBE->DTDATA  := SRE->RE_DATA
  TRBE->CCUSTO := SRE->RE_CCP
  If SRE->RE_DATA > dDtFINAL
      dDtFINAL := dDataBase
  Endif

  Dbselectarea("SRE")
  Dbskip()
End
///xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
cCC       := SRA->RA_CC
cFuncao   := SRA->RA_CODFUNC
dDe_Data  := SRA->RA_ADMISSA
dAte_Data := dDtFINAL
dPro_Data := SRA->RA_ADMISSA

Dbselectarea("TRB7")
DBGoTop()
If Dbseek(DTOS(SRA->RA_ADMISSA))

  lSR7 := .t. ; lGoSR7 := .t.

  dDe_Data   := TRB7->DTDATA
  cFuncao    := TRB7->FUNCAO
  TRB7->(DBDELETE())

  Dbselectarea("TRB7")
  DBGoTop()
  IF !EOF()
      dAte_Data := TRB7->DTDATA
      dPro_Data := TRB7->DTDATA
      DtSR7     := TRB7->DTDATA
  ENDIF
Endif

Dbselectarea("TRBE")
DBGoTop()
IF !EOF()
  cCC  := TRBE->CCUSTO
  lSRE := .t.; lGoSRE := .t.
  TRBE->(DBDELETE())

  Dbselectarea("TRBE")
  DBGoTop()
  IF !EOF()
      If TRBE->DTDATA < dAte_Data
          dAte_Data := TRBE->DTDATA
          dPro_Data := TRBE->DTDATA
          DtSRE     := TRBE->DTDATA
      ENDIF
  Endif
Endif

If lGoSRE .or. lGoSR7
  While lSRE .OR. lSR7
      Dbselectarea("SRJ")
      Dbsetorder(1)
      Dbseek(xFilial("SRJ")+cFuncao)
      strFuncao := SRJ->RJ_DESC
      Cargo := SRJ->RJ_CARGO
      cCBO  := SRJ->RJ_CBO
      If FieldPos("RJ_CODCBO") > 0
          If !Empty(SRJ->RJ_CODCBO)
              cCBO := SRJ->RJ_CODCBO
          Endif
      Endif
      Dbselectarea("SQ3")
      Dbsetorder(1)
      If !Dbseek(xFilial("SQ3")+Cargo+cCC)
          Dbselectarea("SQ3")
          Dbsetorder(1)
          Dbseek(xFilial("SQ3")+Cargo)
      Endif
      strCargo := SQ3->Q3_DESCSUM
      Dbselectarea(cAlias)
      Dbsetorder(1)
      Dbseek(xFilial(cAlias)+cCC)
      strCCusto := &cDescr

      If aSCAN(aFuncao,{|x| X[1] == cFuncao}) < 1
          AADD(aFuncao,{cFuncao,strFuncao})
      Endif
      If aSCAN(aCargo,{|x| X[1] == Cargo .and. X[3] == cCC}) < 1
          AADD(aCargo,{Cargo,strCargo,cCC})
      Endif

      AADD(aHistory,{cMatr,dDe_Data,dAte_Data,strCCusto,strCargo,strFuncao,cCBO})  //Adiciona dados para o Historico do Funcionario
      NG700TAREF(cMatr,dDe_Data,dAte_Data,cCC,cFuncao)  // Verifica se o funcionario executou alguma tarefa
      dDe_Data := dPro_Data

      Dbselectarea("TRBE")
      DBGoTop()
      If Eof()
          lSRE := .F.
          dtSRE := dDtFINAL
      Else
          dtSRE := TRBE->DTDATA
      Endif

      Dbselectarea("TRB7")
      DBGoTop()
      If Eof()
          lSR7 := .F.
          dtSR7 := dDtFINAL
      Else
          dtSR7 := TRB7->DTDATA
      Endif

      IF dtSR7 < dtSRE  // FUNCAO ANTES DO SETOR
          lEof := .f.
          cFuncao := TRB7->FUNCAO
          Dbselectarea("TRB7")
          DBGoTop()
          If !eof()
              TRB7->(DBDELETE())
          Endif
          Dbselectarea("TRB7")
          DBGoTop()
          If !eof()
              dAte_Data := TRB7->DTDATA
              dPro_Data := TRB7->DTDATA
          Else
              dAte_Data := dDtFINAL
              lEof := .t.
          Endif
          Dbselectarea("TRBE")
          DBGoTop()
          If !eof()
              If TRBE->DTDATA < dAte_Data
                  dAte_Data := TRBE->DTDATA
                  dPro_Data := TRBE->DTDATA
              Endif
          Else
              If lEof
                  dAte_Data := dDtFINAL
              Endif
          Endif
      ELSEIF dtSR7 == dtSRE  //FUNCAO E SETOR NO MESMO PERIODO
          lEof := .f.
          cFuncao := TRB7->FUNCAO
          cCC := TRBE->CCUSTO
          Dbselectarea("TRB7")
          DBGoTop()
          If !eof()
              TRB7->(DBDELETE())
          Endif
          Dbselectarea("TRBE")
          DBGoTop()
          If !eof()
              TRBE->(DBDELETE())
          Endif
          Dbselectarea("TRB7")
          DBGoTop()
          If !eof()
              dAte_Data := TRB7->DTDATA
              dPro_Data := TRB7->DTDATA
          Else
              lEof := .t.
              dAte_Data := dDtFINAL
          Endif
          Dbselectarea("TRBE")
          DBGoTop()
          If !eof()
              If TRBE->DTDATA < dAte_Data
                  dAte_Data := TRBE->DTDATA
                  dPro_Data := TRBE->DTDATA
              Endif
          Else
              If lEof
                  dAte_Data := dDtFINAL
              Endif
          Endif

      ELSEIF dtSRE < dtSR7 //SETOR ANTES DA FUNCAO
          lEof := .f.
          cCC := TRBE->CCUSTO
          Dbselectarea("TRBE")
          DBGoTop()
          If !eof()
              TRBE->(DBDELETE())
          Endif
          Dbselectarea("TRBE")
          DBGoTop()
          If !eof()
              dAte_Data := TRBE->DTDATA
              dPro_Data := TRBE->DTDATA
          Else
              lEof := .t.
              dAte_Data := dDtFINAL
          Endif
          Dbselectarea("TRB7")
          DBGoTop()
          If !eof()
              If TRB7->DTDATA < dAte_Data
                  dAte_Data := TRB7->DTDATA
                  dPro_Data := TRB7->DTDATA
              Endif
          Else
              If lEof
                  dAte_Data := dDtFINAL
              Endif
          Endif
      ENDIF
  End
Else
  Dbselectarea("SRJ")
  Dbsetorder(1)
  Dbseek(xFilial("SRJ")+cFuncao)
  strFuncao := SRJ->RJ_DESC
  Cargo := SRJ->RJ_CARGO
  cCBO  := SRJ->RJ_CBO
  If FieldPos("RJ_CODCBO") > 0
      If !Empty(SRJ->RJ_CODCBO)
          cCBO := SRJ->RJ_CODCBO
      Endif
  Endif
  Dbselectarea("SQ3")
  Dbsetorder(1)
  Dbseek(xFilial("SQ3")+Cargo)
  strCargo := SQ3->Q3_DESCSUM
  Dbselectarea(cAlias)
  Dbsetorder(1)
  Dbseek(xFilial(cAlias)+cCC)
  strCCusto := &cDescr

  AADD(aFuncao,{cFuncao,strFuncao})
  AADD(aCargo,{Cargo,strCargo,cCC})
  AADD(aHistory,{cMatr,dDe_Data,dAte_Data,strCCusto,strCargo,strFuncao,cCBO})
  NG700TAREF(cMatr,dDe_Data,dAte_Data,cCC,cFuncao)  // Verifica se o funcionario executou alguma tarefa
Endif
Return aHistory
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700RISCO³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Verifica os riscos que o funcionario esteve exposto        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700RISCO(cTarefa,cCusto,cFuncc,Mat,dIniRisco,dFinRisco,nParam)

_cTarefa := cTarefa
_centrCusto  := cCusto
_cFuncc  := cFuncc
cMatric  := Mat
nRisco   := space(9)
///   11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
If nParam > 0
  DbSelectArea("TN0")
  DbSetOrder(5)
  IF DbSeek(xFilial("TN0") + _centrCusto + _cFuncc + _cTarefa )
      Do While !EOF()                                   .AND. ;
          TN0->TN0_CC     == _centrCusto                .AND. ;
          TN0->TN0_CODFUN == _cFuncc                    .AND. ;
          TN0->TN0_CODTAR == _cTarefa                   .AND. ;
          TN0->TN0_FILIAL == xFilial("TN0")

          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco

              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
      EndDO
  ENDIF
///   22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
  DbSelectArea("TN0")
  DbSetOrder(5)
  IF DbSeek(xFilial("TN0") + "*"+Space(nSizeSI3-1) + _cFuncc + _cTarefa )
      Do While !EOF()                                   .AND. ;
          TN0->TN0_CC     == "*"+Space(nSizeSI3-1)     .AND. ;
          TN0->TN0_CODFUN == _cFuncc                    .AND. ;
          TN0->TN0_CODTAR == _cTarefa                   .AND. ;
          TN0->TN0_FILIAL == xFilial("TN0")
          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco

              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
      EndDO
  ENDIF

/// 3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
  DbSelectArea("TN0")
  DbSetOrder(5)
  IF DbSeek(xFilial("TN0") + _centrCusto + "*   " + _cTarefa )
      Do While !EOF()                                   .AND. ;
          TN0->TN0_CC     == _centrCusto                .AND. ;
          TN0->TN0_CODFUN == "*   "                    .AND. ;
          TN0->TN0_CODTAR == _cTarefa                   .AND. ;
          TN0->TN0_FILIAL == xFilial("TN0")

          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco

              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
      EndDO
  ENDIF
/// 444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
  DbSelectArea("TN0")
  DbSetOrder(5)
  IF DbSeek(xFilial("TN0") + "*"+Space(nSizeSI3-1) + "*   "  + _cTarefa )
      Do While !EOF()                                   .AND. ;
          TN0->TN0_CC     == "*"+Space(nSizeSI3-1)     .AND. ;
          TN0->TN0_CODFUN == "*   "                     .AND. ;
          TN0->TN0_CODTAR == _cTarefa                   .AND. ;
          TN0->TN0_FILIAL == xFilial("TN0")

          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco

              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
      EndDO
  ENDIF
  Return
Endif
/// 55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
DbSelectArea("TN0")
DbSetOrder(5)
IF DbSeek(xFilial("TN0") + _centrCusto + _cFuncc + "*     " )
  Do While !EOF()                                   .AND. ;
      TN0->TN0_CC     == _centrCusto                .AND. ;
      TN0->TN0_CODFUN == _cFuncc                    .AND. ;
      TN0->TN0_CODTAR == "*     "                   .AND. ;
      TN0->TN0_FILIAL == xFilial("TN0")

          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco

              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
  EndDO
ENDIF
/// 66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
DbSelectArea("TN0")
DbSetOrder(5)
IF DbSeek(xFilial("TN0") + "*"+Space(nSizeSI3-1) + _cFuncc + "*     " )
  Do While !EOF()                                   .AND. ;
      TN0->TN0_CC     == "*"+Space(nSizeSI3-1)     .AND. ;
      TN0->TN0_CODFUN == _cFuncc                    .AND. ;
      TN0->TN0_CODTAR == "*     "                   .AND. ;
      TN0->TN0_FILIAL == xFilial("TN0")

          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco


              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
  EndDO
ENDIF


DbSelectArea("TN0")
DbSetOrder(5)
IF DbSeek(xFilial("TN0") + _centrCusto + "*   " + "*     " )
  Do While !EOF()                                   .AND. ;
      TN0->TN0_CC     == _centrCusto                .AND. ;
      TN0->TN0_CODFUN == "*   "                     .AND. ;
      TN0->TN0_CODTAR == "*     "                   .AND. ;
      TN0->TN0_FILIAL == xFilial("TN0")

          lStart  := .f.
          dInicioRis := dIniRisco
          dFimRis    := dFinRisco

              dtAval := TN0->TN0_DTRECO
              If dtAval >= dFimRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
                  Dbselectarea("TN0")
                  Dbskip()
                  Loop
              Endif
              If dtAval >= dInicioRis  .and. dtAval < dFimRis
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
                  dInicioRis := dtAval
              Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM >= dInicioRis)
                  lStart  := .t.
                  If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                      dFimRis := TN0->TN0_DTELIM
                  Endif
              Endif
              If lStart
                  NGGRAVA700()
              Endif

          DbSelectArea("TN0")
          DbSkip()
  EndDO
ENDIF


DbSelectArea("TN0")
DbSetOrder(5)
IF DbSeek(xFilial("TN0") + "*"+Space(nSizeSI3-1) + "*   "  + "*     " )
  Do While !EOF()                                   .AND. ;
      TN0->TN0_CC     == "*"+Space(nSizeSI3-1)     .AND. ;
      TN0->TN0_CODFUN == "*   "                     .AND. ;
      TN0->TN0_CODTAR == "*     "                   .AND. ;
      TN0->TN0_FILIAL == xFilial("TN0")


        lStart  := .f.
      dInicioRis := dIniRisco
      dFimRis    := dFinRisco

          dtAval := TN0->TN0_DTRECO
          If dtAval > dFimRis
              Dbselectarea("TN0")
              Dbskip()
              Loop
          Endif
            If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
              Dbselectarea("TN0")
              Dbskip()
              Loop
          Endif
          If dtAval >= dInicioRis  .and. dtAval <= dFimRis
              lStart  := .t.
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                  dFimRis := TN0->TN0_DTELIM
              Endif
              dInicioRis := dtAval
          Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM > dInicioRis)
              lStart  := .t.
              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
                  dFimRis := TN0->TN0_DTELIM
              Endif
          Endif
          If lStart
              NGGRAVA700()
          Endif

      DbSelectArea("TN0")
      DbSkip()
  EndDO
ENDIF


// Especifico WHB

DbSelectArea("TN0")
DbSetOrder(5)
If DbSeek(xFilial("TN0"))
  While !TN0->(EOF()) .And. TN0->TN0_FILIAL == xFilial("TN0")

      If TN0->TN0_CC == _centrCusto
      
      	If TN0->TN0_CODFUN == _cFuncc

		      lStart     := .f.
		      dInicioRis := dIniRisco
		      dFimRis    := dFinRisco
				dtAval     := TN0->TN0_DTRECO

	          If dtAval > dFimRis
   	           Dbselectarea("TN0")
      	        Dbskip()
	              Loop
   	       Endif
      	      If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM <  dInicioRis
	              Dbselectarea("TN0")
   	           Dbskip()
      	        Loop
	          Endif
   	       If dtAval >= dInicioRis  .and. dtAval <= dFimRis
	              lStart  := .t.
   	           If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
      	            dFimRis := TN0->TN0_DTELIM
		           Endif
   		        dInicioRis := dtAval
	          Elseif dtAval < dInicioRis .and. (Empty(TN0->TN0_DTELIM) .OR. TN0->TN0_DTELIM > dInicioRis)
   	           lStart  := .t.
	              If !Empty(TN0->TN0_DTELIM) .and. TN0->TN0_DTELIM < dFimRis
   	               dFimRis := TN0->TN0_DTELIM
	              Endif
	          Endif
   	       If lStart
      	        NGGRAVA700()
	          Endif
			Endif
		Endif				   		
      DbSelectArea("TN0")
      DbSkip()
  EndDO
ENDIF















Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700TAREF³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Busca as tarefas do funcionario no periodo                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700TAREF(Mat,dDTde,dDTate,cCusto,cFuncc)

Local cTarefa := "*"
_cCusto := cCusto
_cFuncc := cFuncc
_Mat := Mat
_dDTinicio  := dDTde
_dDTfim := dDTate
lStart  := .f.

// Busca os riscos que o funcinario esta exposto nessas condicoes
Dbselectarea("TN6")
Dbsetorder(2)
Dbseek(xFilial("TN6")+Mat)
While !eof() .and. xFilial("TN6") == TN6->TN6_FILIAL .and. Mat == TN6->TN6_MAT

    _dDTinicio := dDTde
    _dDTfim    := dDTate
    If TN6->TN6_DTINIC >= _dDTfim .or. (TN6->TN6_DTTERM < _dDTinicio  .and. !Empty(TN6->TN6_DTTERM))
      Dbselectarea("TN6")
      Dbskip()
      Loop
    Endif

  If TN6->TN6_DTINIC >= _dDTinicio  .and. TN6->TN6_DTINIC < _dDTfim
      lStart  := .t.
      If TN6->TN6_DTTERM < _dDTfim .and. !Empty(TN6->TN6_DTTERM)
          _dDTfim := TN6->TN6_DTTERM
      Endif
      _dDTinicio := TN6->TN6_DTINIC

  Elseif TN6->TN6_DTINIC < _dDTinicio .and. (TN6->TN6_DTTERM >= _dDTinicio  .OR. Empty(TN6->TN6_DTTERM))
      lStart  := .t.
      If TN6->TN6_DTTERM < _dDTfim .and. !Empty(TN6->TN6_DTTERM)
          _dDTfim := TN6->TN6_DTTERM
      Endif
  Endif

  cTarefa := TN6->TN6_CODTAR

  If lStart
      NG700RISCO(cTarefa,_cCusto,_cFuncc,_Mat,_dDTinicio,_dDTfim,100)
  Endif

  Dbselectarea("TN6")
  Dbskip()
End
cTarefa := "*     "
NG700RISCO(cTarefa,_cCusto,_cFuncc,_Mat,dDTde,dDTate,0)
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700EXAME³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Busca os exames do funcionario para imprimir no PPP         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700EXAME(Ficha)

Local _Ficha := Ficha
Local aExames := {}

For xRi := 1 to Len(aRiscos)
  Dbselectarea("TN2")
  Dbsetorder(1)
  Dbseek(xFilial("TN2")+aRiscos[xRi][1])
    While !eof() .and. xFilial("TN2") == TN2->TN2_FILIAL .and. ;
        TN2->TN2_NUMRIS == aRiscos[xRi][1]

      Dbselectarea("TM5")
      Dbsetorder(6)
      Dbseek(xFilial("TM5")+_Ficha+TN2->TN2_EXAME)
      While !eof() .and. xFilial("TM5") == TM5->TM5_FILIAL .and. ;
          nNum_Ficha == TM5->TM5_NUMFIC .AND. TN2->TN2_EXAME == TM5->TM5_EXAME

          If !Empty(TM5->TM5_DTRESU) .and. TM5->TM5_DTRESU >= aRiscos[xRi][2] .and. ;
              TM5->TM5_DTRESU <= aRiscos[xRi][3] .and. TM5->TM5_ORIGEX == '2'

              Dbselectarea("TRBX")
              Dbsetorder(2)
              If !Dbseek(DTOS(TM5->TM5_DTPROG)+TM5->TM5_EXAME)

                  cNatexa := "Periodico"
                  If TM5->TM5_NATEXA == '1'; cNatexa := "Admissional"
                  ElseIf TM5->TM5_NATEXA == '2'; cNatexa := "Periodico"
                  ElseIf TM5->TM5_NATEXA == '3'; cNatexa := "Mudanca Funcao"
                  ElseIf TM5->TM5_NATEXA == '4'; cNatexa := "Retorno Trabalho"
                  ElseIf TM5->TM5_NATEXA == '5'; cNatexa := "Demissional"
                  Endif

                  Dbselectarea("TM4")
                  Dbsetorder(1)
                  Dbseek(xFilial("TM4")+TM5->TM5_EXAME)

                  TRBX->(DBAPPEND())
                  TRBX->EXAME := TM5->TM5_EXAME
                  TRBX->NOMEX := TM4->TM4_NOMEXA
                  TRBX->DTPRO := TM5->TM5_DTPROG
                  TRBX->DTPRO := TM5->TM5_DTPROG
                  TRBX->DTRES := TM5->TM5_DTRESU
                  TRBX->TIPOE := cNatexa
                  TRBX->TIPOR := If(TM4->TM4_INDRES == "4","",If(TM5->TM5_INDRES == "2","Alterado","Normal")) //"Alterado"###"Normal"
              Endif
          Endif
          Dbselectarea("TM5")
          Dbskip()
      End
      Dbselectarea("TN2")
      Dbskip()
  End
Next xRi
Return aExames
 /*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NGGRAVA700³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Grava arquivo de trabalho contendo os riscos do funcionario³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NGGRAVA700()

Local lSave  := .f.
Local lAchouRisco := .f.
Local cEXPOSICAO := " "
Local cTECNICA := " "
Local lEpiFunc := .f.
Local lEpcFunc := If(Mv_par12==1,.t.,.f.)
If mv_par07 == 2 .and. TN0->TN0_LISASO $ "12"
  Return .t.
Endif

aAdd(aRiscos,{TN0->TN0_NUMRIS,dInicioRis,dFimRis}) // Adiciona o numero do risco na array aRISCOS

If FieldPos('TN0_INDEXP') > 0
  cEXPOSICAO := TN0->TN0_INDEXP
Endif
If FieldPos('TN0_TECUTI') > 0
  cTECNICA := TN0->TN0_TECUTI
Endif
cEpiant := " "

Dbselectarea("TNX")
Dbsetorder(1)
If Dbseek(xFilial("TNX")+TN0->TN0_NUMRIS)
  lEpiFunc := .t.
Endif

Dbselectarea("TMA")
Dbsetorder(1)
Dbseek(xFilial("TMA")+TN0->TN0_AGENTE)

Dbselectarea("TRB")
Dbsetorder(2)
If !Dbseek(TN0->TN0_AGENTE+Str(TN0->TN0_QTAGEN,9,3))
  lSave  := .t.
Else
  dtstart := dInicioRis
  dtstop  := dFimRis
  nRecOld := nil
  Dbselectarea("TRB")
  Dbsetorder(2)
  Dbseek(TN0->TN0_AGENTE+Str(TN0->TN0_QTAGEN,9,3))
  While !eof() .and. TN0->TN0_AGENTE+Str(TN0->TN0_QTAGEN,9,3) == TRB->CODAGE+Str(TRB->INTENS,9,3)

      If TRB->DT_DE <= dtstart .and. TRB->DT_ATE >= dtstart-1
          If dtstop > TRB->DT_ATE
              RecLock("TRB",.F.)
              TRB->DT_ATE := dtstop
              dtstart := TRB->DT_DE
              Msunlock("TRB")
              aAreaTRB := TRB->(GetArea())
              If nRecOld != nil
                  Dbselectarea("TRB")
                  Dbgoto(nRecOld)
                  TRB->(Dbdelete())
              Endif
              RestArea(aAreaTRB)
          Endif
          lAchouRisco := .t.
          nRecOld := recno()

      Elseif TRB->DT_DE <= dtstop+1 .and. TRB->DT_ATE >= dtstop
          If dtstart < TRB->DT_DE
              RecLock("TRB",.F.)
              TRB->DT_DE := dtstart
              dtstop := TRB->DT_ATE
              Msunlock("TRB")
              aAreaTRB := TRB->(GetArea())
              If nRecOld != nil
                  Dbselectarea("TRB")
                  Dbgoto(nRecOld)
                  TRB->(Dbdelete())
              Endif
              RestArea(aAreaTRB)
          Endif
          lAchouRisco := .t.
          nRecOld := recno()

      Elseif TRB->DT_DE > dtstart .and. TRB->DT_ATE < dtstop
          RecLock("TRB",.F.)
          TRB->DT_DE := dtstart
          TRB->DT_ATE := dtstop
          Msunlock("TRB")
          aAreaTRB := TRB->(GetArea())
          If nRecOld != nil
              Dbselectarea("TRB")
              Dbgoto(nRecOld)
              TRB->(Dbdelete())
          Endif
          RestArea(aAreaTRB)
          lAchouRisco := .t.
          nRecOld := recno()
      Endif
      Dbskip()

  End
  If !lAchouRisco
      lSave := .t.
  Endif
Endif
If lSave
  Dbselectarea("TRB")
  TRB->(DBAPPEND())
  TRB->NUMRIS := TN0->TN0_NUMRIS
  TRB->CODAGE := TN0->TN0_AGENTE
  TRB->AGENTE := TMA->TMA_NOMAGE
  TRB->MAT    := cMatric
  TRB->DT_DE  := dInicioRis
  TRB->DT_ATE := dFimRis
  TRB->SETOR  := _centrCusto
  TRB->FUNCAO := _cFuncc
  TRB->TAREFA := _cTarefa
  TRB->INTENS := TN0->TN0_QTAGEN
  TRB->UNIDAD := TN0->TN0_UNIMED
  TRB->TECNIC := Substr(cTECNICA,1,20)
  TRB->PROTEC := If(lEpiFunc,Substr("SIM",1,3),Substr("NAO",1,3)) //"SIM"###"NAO"
  TRB->EPC    := If(lEpcFunc,Substr("SIM",1,3),Substr("NAO",1,3)) //"SIM"###"NAO"
  TRB->INDEXP := cEXPOSICAO

    _cGFIP := sra->ra_ocorren

  Dbselectarea("TN0")
  If FieldPos("TN0_SEFIP") > 0
      If !Empty(TN0->TN0_SEFIP)
          If Valtype(TN0->TN0_SEFIP) == "N"
              If TN0->TN0_SEFIP != 0
                  _cGFIP := Strzero(TN0->TN0_SEFIP,2)
              Endif
          Elseif Valtype(TN0->TN0_SEFIP) == "C"
              If Alltrim(TN0->TN0_SEFIP) != "0"
                  _cGFIP := Substr(TN0->TN0_SEFIP,1,2)
              Endif
          Endif
      Endif
  Endif
  TRB->GFIP   := _cGFIP
Endif
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700AUDIO³ Autor ³Denis Hyroshi de Souza ³ Data ³ 04/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Retorna os exames de audimetria do funcionario             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700AUDIO(nFicha)
Local cFicha := nFicha, lTM9_ORIG
Local aDir_Ref,aDir_Seq,aEsq_Ref,aEsq_Seq
lTRUE := .t.
lODR := .f.
lODS := .f.
lOER := .f.
lOES := .f.
aDir_Ref := {}
aDir_Seq := {}
aEsq_Ref := {}
aEsq_Seq := {}
aRetorno := {}

Dbselectarea("TM9")
lTM9_ORIG := If(FieldPos("TM9_ODORIG") > 0 .and. FieldPos("TM9_OEORIG") > 0,.t.,.f.)
Dbsetorder(1)
Dbseek(xFilial("TM9")+nFicha)
While !eof() .and. xFilial("TM9") == TM9->TM9_FILIAL .and. TM9->TM9_NUMFIC == cFicha

    If TM9->TM9_ODREFE == "1"
      Dbselectarea("TM5")
      Dbsetorder(1)
      If Dbseek(xFilial("TM5")+cFicha+Dtos(TM9->TM9_DTPROG)+TM9->TM9_EXAME)
          If !lODR
              AADD(aDir_Ref,{"ODR",TM9->TM9_ODRESU,If(lTM9_ORIG,If(TM9->TM9_ODORIG=="2","1","2")," ")})
              dODR := TM5->TM5_DTRESU
              lODR := .T.
          Else
              If TM5->TM5_DTRESU > dODR
                  AADD(aDir_Ref,{"ODR",TM9->TM9_ODRESU,If(lTM9_ORIG,If(TM9->TM9_ODORIG=="2","1","2")," ")})
                  dODR := TM5->TM5_DTRESU
              Endif
          Endif
        Endif

    ELSEIF TM9->TM9_ODREFE == "2"
      Dbselectarea("TM5")
      Dbsetorder(1)
      If Dbseek(xFilial("TM5")+cFicha+Dtos(TM9->TM9_DTPROG)+TM9->TM9_EXAME)
          If !lODS
              AADD(aDir_Seq,{"ODS",TM9->TM9_ODRESU,If(lTM9_ORIG,If(TM9->TM9_ODORIG=="2","1","2")," ")})
              dODS := TM5->TM5_DTRESU
              lODS := .T.
          Else
              If TM5->TM5_DTRESU > dODS
                  AADD(aDir_Seq,{"ODS",TM9->TM9_ODRESU,If(lTM9_ORIG,If(TM9->TM9_ODORIG=="2","1","2")," ")})
                  dODS := TM5->TM5_DTRESU
              Endif
          Endif
      Endif
    ENDIF

    IF TM9->TM9_OEREFE == "1"
      Dbselectarea("TM5")
      Dbsetorder(1)
      If Dbseek(xFilial("TM5")+cFicha+Dtos(TM9->TM9_DTPROG)+TM9->TM9_EXAME)
          If !lOER
              AADD(aEsq_Ref,{"OER",TM9->TM9_OERESU,If(lTM9_ORIG,If(TM9->TM9_OEORIG=="2","1","2")," ")})
              dOER := TM5->TM5_DTRESU
              lOER := .T.
          Else
              If TM5->TM5_DTRESU > dOER
                  AADD(aEsq_Ref,{"OER",TM9->TM9_OERESU,If(lTM9_ORIG,If(TM9->TM9_OEORIG=="2","1","2")," ")})
                  dOER := TM5->TM5_DTRESU
              Endif
          Endif
      Endif

  ELSEIF TM9->TM9_OEREFE == "2"
      Dbselectarea("TM5")
      Dbsetorder(1)
      If Dbseek(xFilial("TM5")+cFicha+Dtos(TM9->TM9_DTPROG)+TM9->TM9_EXAME)
          If !lOES
              AADD(aEsq_Seq,{"OES",TM9->TM9_OERESU,If(lTM9_ORIG,If(TM9->TM9_OEORIG=="2","1","2")," ")})
              dOES := TM5->TM5_DTRESU
              lOES := .T.
          Else
              If TM5->TM5_DTRESU > dOES
                  AADD(aEsq_Seq,{"OES",TM9->TM9_OERESU,If(lTM9_ORIG,If(TM9->TM9_OEORIG=="2","1","2")," ")})
                  dOES := TM5->TM5_DTRESU
              Endif
          Endif
      Endif
  ENDIF

  Dbselectarea("TM9")
  Dbskip()
End

If Len(aDir_Ref) > 0
  AADD(aRetorno,aDir_Ref[Len(aDir_Ref)])
Endif
If Len(aDir_Seq) > 0
  AADD(aRetorno,aDir_Seq[Len(aDir_Seq)])
Endif
If Len(aEsq_Ref) > 0
  AADD(aRetorno,aEsq_Ref[Len(aEsq_Ref)])
Endif
If Len(aEsq_Seq) > 0
  AADD(aRetorno,aEsq_Seq[Len(aEsq_Seq)])
Endif
Return aRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NG700fator³ Autor ³Denis Hyroshi de Souza ³ Data ³ 18/12/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Retorna os fatores do Grupo do cargo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function NG700FATOR(cGRUPO)
local aRet := {}
If Select("SQ1") > 0
  Dbselectarea("SQ1")
  Dbsetorder(1)
  Dbseek(xFilial("SQ1")+cGrupo)
  While !eof() .and. xFilial("SQ1") == SQ1->Q1_FILIAL .and. cGrupo == SQ1->Q1_GRUPO

      Aadd(aRet,{SQ1->Q1_DESCSUM})

      Dbselectarea("SQ1")
      Dbskip()
  End
Endif
Return aRet
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ SomaLinha³ Autor ³Denis Hyroshi de Souza ³ Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha inicial                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Somalinha(_li)
    If _li != nil
        Li += _li
    Else
        Li ++
    Endif

    If Li > 68
       @li,000 Psay "|"
       @li,001 Psay replicate("_",131)
       @li,132 Psay "|"
       Li := 0
       @li,001 Psay replicate("_",131)
       Somalinha()
    Endif
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ATIV700R  ³ Autor ³Denis Hyroshi de Souza ³ Data ³ 04/04/03 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ATIV700R()
Local lTar := .f.
Local lCar := .f.

If IMPFUN700()
  Return .t.
Endif

For nFx := 1 to Len(aCargo)
  Dbselectarea("SQ3")
  Dbsetorder(1)
  If Dbseek(xFilial("SQ3")+aCargo[nFx][1])
      cMemo := MSMM(SQ3->Q3_DESCDET)
      nLinhasMemo := MLCOUNT(cMemo,117)
      For LinhaCorrente := 1 To nLinhasMemo
         If !Empty((MemoLine(cMemo,117,LinhaCorrente)))
              lCar := .t.
              Exit
         EndIf
      Next LinhaCorrente
  Endif
Next nFx

Dbselectarea("TN6")
Dbsetorder(2)
Dbseek(xFilial("TN6")+SRA->RA_MAT)
While !eof() .and. xFilial("TN6") == TN6->TN6_FILIAL .and. SRA->RA_MAT == TN6->TN6_MAT
  Dbselectarea("TN5")
  Dbsetorder(1)
  If Dbseek(xFilial("TN5")+TN6->TN6_CODTAR)
      If !Empty(TN5->TN5_DESTAR)
          lTar := .t.
          Exit
      Endif
  Endif
  Dbselectarea("TN6")
  Dbskip()
End

If Mv_par08 == 1
  If lTar
      IMPTAR700()
  Else
      IMPCGO700()
  Endif
Else
  If lCar .or. !lTar
      IMPCGO700()
  Elseif lTar
      IMPTAR700()
  Endif
Endif
Return
//***********************************************/
//***********************************************/
Static Function IMPTAR700()
Local aTarFunc := {}
nLinTar := 3

@li,000 Psay "|12-"
@li,004 Psay "Descricao das Atividades:"
@li,132 Psay "|"
Dbselectarea("TN6")
Dbsetorder(2)
Dbseek(xFilial("TN6")+SRA->RA_MAT)
While !eof() .and. xFilial("TN6") == TN6->TN6_FILIAL .and. SRA->RA_MAT == TN6->TN6_MAT
  If aSCAN(aTarFunc,{|x| X[1] == TN6->TN6_CODTAR}) < 1
      AADD(aTarFunc,{TN6->TN6_CODTAR})
      Dbselectarea("TN5")
      Dbsetorder(1)
      If Dbseek(xFilial("TN5")+TN6->TN6_CODTAR)
          If !Empty(TN5->TN5_DESTAR)
              SomaLinha()
              @ Li,000 Psay "|"
              @ Li,004 Psay TN5->TN5_NOMTAR
              @ Li,132 Psay "|"

              nLinhasMemo := MLCOUNT(TN5->TN5_DESTAR,117)
              nLinTar := 3
              For LinhaCorrente := 1 To nLinhasMemo
                 If !Empty((MemoLine(TN5->TN5_DESTAR,117,LinhaCorrente)))
                    SomaLinha()
                    @ Li,000 Psay "|"
                    @ Li,009+nLinTar Psay (MemoLine(TN5->TN5_DESTAR,117,LinhaCorrente)) Picture "@!"
                    @ Li,132 Psay "|"
                    nLinTar := 0
                 EndIf
              Next
              If FieldPos("TN5_DESCR1") > 0
                  nLinhasMemo := MLCOUNT(TN5->TN5_DESCR1,117)
                  nLinTar := 3
                  For LinhaCorrente := 1 To nLinhasMemo
                     If !Empty((MemoLine(TN5->TN5_DESCR1,117,LinhaCorrente)))
                        SomaLinha()
                        @ Li,000 Psay "|"
                        @ Li,009+nLinTar Psay (MemoLine(TN5->TN5_DESCR1,117,LinhaCorrente)) Picture "@!"
                        @ Li,132 Psay "|"
                        nLinTar := 0
                     EndIf
                  Next
              Endif
              If FieldPos("TN5_DESCR2") > 0
                  nLinhasMemo := MLCOUNT(TN5->TN5_DESCR2,117)
                  nLinTar := 3
                  For LinhaCorrente := 1 To nLinhasMemo
                     If !Empty((MemoLine(TN5->TN5_DESCR2,117,LinhaCorrente)))
                        SomaLinha()
                        @ Li,000 Psay "|"
                        @ Li,009+nLinTar Psay (MemoLine(TN5->TN5_DESCR2,117,LinhaCorrente)) Picture "@!"
                        @ Li,132 Psay "|"
                        nLinTar := 0
                     EndIf
                  Next
              Endif
              If FieldPos("TN5_DESCR3") > 0
                  nLinhasMemo := MLCOUNT(TN5->TN5_DESCR3,117)
                  nLinTar := 3
                  For LinhaCorrente := 1 To nLinhasMemo
                     If !Empty((MemoLine(TN5->TN5_DESCR3,117,LinhaCorrente)))
                        SomaLinha()
                        @ Li,000 Psay "|"
                        @ Li,009+nLinTar Psay (MemoLine(TN5->TN5_DESCR3,117,LinhaCorrente)) Picture "@!"
                        @ Li,132 Psay "|"
                        nLinTar := 0
                     EndIf
                  Next
              Endif
              If FieldPos("TN5_DESCR4") > 0
                  nLinhasMemo := MLCOUNT(TN5->TN5_DESCR4,117)
                  nLinTar := 3
                  For LinhaCorrente := 1 To nLinhasMemo
                     If !Empty((MemoLine(TN5->TN5_DESCR4,117,LinhaCorrente)))
                        SomaLinha()
                        @ Li,000 Psay "|"
                        @ Li,009+nLinTar Psay (MemoLine(TN5->TN5_DESCR4,117,LinhaCorrente)) Picture "@!"
                        @ Li,132 Psay "|"
                        nLinTar := 0
                     EndIf
                  Next
              Endif
          Endif
      Endif
  Endif
  Dbselectarea("TN6")
  Dbskip()
End

Return
//***********************************************/
//***********************************************/
Static Function IMPCGO700()
local aRecnos := {}
@li,000 Psay "|12-"
@li,004 Psay "Descricao das Atividades:"
@li,132 Psay "|"

For nFx := 1 to Len(aCargo)
  For xFor := 1 to 2
    cCargoCC := Space(6)
    If xFor == 1
      cCargoCC := aCargo[nFx][1]+aCargo[nFx][3]
    Else
      cCargoCC := aCargo[nFx][1]+Space(nSizeSI3)
    Endif

  Dbselectarea("SQ3")
  Dbsetorder(1)
  If Dbseek(xFilial("SQ3")+cCargoCC)
      If aScan(aRecnos,{|X| X == Recno()}) > 0
          loop
      Endif
      aAdd(aRecnos,Recno())

      cMemo := MSMM(SQ3->Q3_DESCDET)
      nLinhasMemo := MLCOUNT(cMemo,117)
      For LinhaCorrente := 1 To nLinhasMemo
         If LinhaCorrente == 1
              SomaLinha()
              @ Li,000 Psay "|"
              @ Li,004 Psay aCargo[nFx][2] Picture "@!"
              @ Li,132 Psay "|"
         Endif
         If !Empty((MemoLine(cMemo,117,LinhaCorrente)))
            SomaLinha()
            @ Li,000 Psay "|"
            @ Li,010 Psay (MemoLine(cMemo,117,LinhaCorrente)) Picture "@!"
            @ Li,132 Psay "|"
         EndIf
      Next LinhaCorrente
      Exit
  Endif
  Next xFor
Next nFx
Return
//***********************************************/
//***********************************************/
Static Function IMPFUN700()
Local lRetorno := .f.
Local lPrintFu := .t.

Dbselectarea("SRJ")
If FieldPos("RJ_MEMOATI") > 0
  For nFx := 1 to Len(aFuncao)
      Dbselectarea("SRJ")
      Dbsetorder(1)
      If Dbseek(xFilial("SRJ")+aFuncao[nFx][1])
          cMemo := SRJ->RJ_MEMOATI
          nLinhasMemo := MLCOUNT(cMemo,117)
          For LinhaCorrente := 1 To nLinhasMemo
              lRetorno := .t.
              If lPrintFu
                  @li,000 Psay "|12-"
                  @li,004 Psay "Descricao das Atividades:"
                  @li,132 Psay "|"
                  lPrintFu := .f.
              Endif
              If LinhaCorrente == 1
                  SomaLinha()
                  @ Li,000 Psay "|"
                  @ Li,004 Psay aFuncao[nFx][2] Picture "@!"
                  @ Li,132 Psay "|"
              Endif
              If !Empty((MemoLine(cMemo,117,LinhaCorrente)))
                  SomaLinha()
                  @ Li,000 Psay "|"
                  @ Li,010 Psay (MemoLine(cMemo,117,LinhaCorrente)) Picture "@!"
                  @ Li,132 Psay "|"
              EndIf
          Next LinhaCorrente
      Endif
  Next nFx
Endif
Return lRetorno
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MDTERMO700  Autor ³Denis Hyroshi de Souza ³ Data ³ 04/04/03 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function MDTERMO700()
Somalinha()
If li <= 68
  li := 1
Endif
//TERCEIRA FOLHA**********************************************************
@li,044 Psay "PERFIL PROFISSIOGRAFICO PREVIDENCIARIO - PPP"
Somalinha()
@li,001 Psay replicate("_",131)
Somalinha()
@li,000 Psay "|"
@li,003 Psay "Empresa/Estabelecimento:"
@li,091 Psay "|"
@li,094 Psay "CNAE"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
If lNGMDTPS .and. lFindCLI
  @li,003 Psay SA1->A1_NOME
Else
  @li,003 Psay SM0->M0_NOMECOM
Endif
@li,091 Psay "|"
If lNGMDTPS .and. lFindCLI
  @li,094 Psay SA1->A1_ATIVIDA
Else
  @li,094 Psay SM0->M0_CNAE
Endif
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
If lNGMDTPS .and. lFindCLI
  @li,003 Psay SA1->A1_END
Else
  @li,003 Psay &("SM0->M0_END"+cTypeEnd)
Endif
@li,091 Psay "|________________________________________|"
Somalinha()
If lNGMDTPS .and. lFindCLI
  If !empty(SA1->A1_EST)
      cCidade := alltrim(SA1->A1_MUN)+"-"+SA1->A1_EST
  Else
      cCidade := alltrim(SA1->A1_MUN)
  Endif
Else
  If !empty(&("SM0->M0_EST"+cTypeEnd))
      cCidade := alltrim(&("SM0->M0_CID"+cTypeEnd))+"-"+&("SM0->M0_EST"+cTypeEnd)
  Else
      cCidade := alltrim(&("SM0->M0_CID"+cTypeEnd))
  Endif
Endif
@li,000 Psay "|"
If !Empty(cCidade)
  @li,003 Psay substr(cCidade,1,23)
Endif
@li,033 Psay "CEP:"
If lNGMDTPS .and. lFindCLI
  @li,038 Psay SA1->A1_CEP Picture "@R 99999-999"
Else
  @li,038 Psay &("SM0->M0_CEP"+cTypeEnd) Picture "@R 99999-999"
Endif
@li,091 Psay "|"
@li,094 Psay "ANO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,003 Psay "CNPJ:"
If lNGMDTPS .and. lFindCLI
  @li,009 Psay SA1->A1_CGC Picture "@R 99.999.999/9999-99"
Else
  @li,009 Psay SM0->M0_CGC Picture "@R 99.999.999/9999-99"
Endif
//@li,055 Psay SRJ->RJ_CBO
@li,091 Psay "|"
@li,094 Psay year(dDatabase)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|__________________________________________________________________________________________|________________________________________|"
Somalinha()
Dbselectarea(cAlias)
Dbsetorder(1)
Dbseek(xFilial(cAlias)+SRA->RA_CC)
Dbselectarea("SRJ")
Dbsetorder(1)
Dbseek(xFilial("SRJ")+SRA->RA_CODFUNC)

@li,000 Psay "|"
@li,032 Psay "COMPROVANTE DE ENTREGA DO PERFIL PROFISSIOGRAFICO PREVIDENCIARIO (PPP)"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Matricula......:"
@li,019 Psay SRA->RA_MAT
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Nome...........:"
@li,019 Psay SRA->RA_NOME
@li,091 Psay "|"
@li,094 Psay "ANO"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,003 Psay "CNPJ:"
If lNGMDTPS .and. lFindCLI
  @li,009 Psay SA1->A1_CGC Picture "@R 99.999.999/9999-99"
Else
  @li,009 Psay SM0->M0_CGC Picture "@R 99.999.999/9999-99"
Endif
//@li,055 Psay SRJ->RJ_CBO
@li,091 Psay "|"
@li,094 Psay year(dDatabase)
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|__________________________________________________________________________________________|________________________________________|"
Somalinha()
Dbselectarea(cAlias)
Dbsetorder(1)
Dbseek(xFilial(cAlias)+SRA->RA_CC)
Dbselectarea("SRJ")
Dbsetorder(1)
Dbseek(xFilial("SRJ")+SRA->RA_CODFUNC)

@li,000 Psay "|"
@li,032 Psay "COMPROVANTE DE ENTREGA DO PERFIL PROFISSIOGRAFICO PREVIDENCIARIO (PPP)"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Matricula......:"
@li,019 Psay SRA->RA_MAT
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Nome...........:"
@li,019 Psay SRA->RA_NOME
@li,132 Psay "|"   
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Centro de Custo:"
@li,019 Psay &cDescr
@li,132 Psay "|"   
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Funcao.........:"
@li,019 Psay SRJ->RJ_DESC
@li,132 Psay "|"    
Somalinha()
@li,000 Psay "|"
@li,002 Psay "Data Admissao..:"
@li,019 Psay SRA->RA_ADMISSA
@li,132 Psay "|"   
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"   


Dbselectarea("TMZ")
Dbsetorder(1)
Dbseek(xFilial("TMZ")+Mv_par11)
nLinhasMemo := MLCOUNT(TMZ->TMZ_DESCRI,125)
nLinhasMemo := If(nLinhasMemo > 43,43,nLinhasMemo)
For LinhaCorrente := 1 To nLinhasMemo
  	If !Empty((MemoLine(TMZ->TMZ_DESCRI,125,LinhaCorrente)))
  		If LinhaCorrente == 1
  			SomaLinha()
  			@ Li,000 Psay "|"
  			@ Li,006 Psay (MemoLine(TMZ->TMZ_DESCRI,125,LinhaCorrente))
  			@ Li,132 Psay "|"						
  		Else		
  			SomaLinha()
 			@ Li,000 Psay "|"
  			@ Li,003 Psay (MemoLine(TMZ->TMZ_DESCRI,125,LinhaCorrente))
  			@ Li,132 Psay "|"
  		Endif	
  	EndIf
Next LinhaCorrente

If Empty(TMZ->TMZ_DESCRI)
  	For xxx:=1 to 4
 		Somalinha()
  		@li,000 Psay "|"
  		@li,132 Psay "|"  
  	Next xxx	
Endif

Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"

cNomMat := Alltrim(SRA->RA_NOME)
nSize := if(len(cNomMat) <= 30,len(cNomMat),30)
If len(cNomMat) > 30
  cNomMat := substr(cNomMat,1,30)
Endif
nSize := 30 - nSize
nTabu := 1
If nSize > 1
  If (nSize % 2) != 0
      nSize++
      nTabu := (nSize / 2) - 1
  Else
      nTabu := nSize / 2
  Endif
Endif
Somalinha()
@li,000 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,010 Psay Replicate("_",30)
If lNGMDTPS .and. lFindCLI
  @li,050 Psay alltrim(SA1->A1_MUN)+", "+Dtoc(Date())
Else
  @li,050 Psay alltrim(&("SM0->M0_CID"+cTypeEnd))+", "+Dtoc(Date())
Endif
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,010 Psay space(nTabu)+cNomMat
@li,132 Psay "|"
Somalinha()
@li,000 Psay "|"
@li,001 Psay replicate("_",131)
@li,132 Psay "|"
Somalinha()
Return .t.

Static Function NGPPPDATE(dDtPPP)
	Local cRet,cDia,cMes,cAno

cDia := Strzero(Day(dDtPPP),2)
cMes := Strzero(Month(dDtPPP),2)
cAno := Substr(Str(Year(dDtPPP),4),3,2)

cRet := cDia+"/"+cMes+"/"+cAno

Return cRet
