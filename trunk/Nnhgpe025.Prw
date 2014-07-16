#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function nhgpe025()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,CRODATXT")
SetPrvt("NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,ASTRU,CARQ,CIND,_DAT01,_DAT02")
SetPrvt("_DAT03,_DAT04,_DAT05,_DAT06,_DAT07,_DAT08")
SetPrvt("_DAT09,_DAT10,_DAT11,_DAT12,_DATATU,_FUNCAO")
SetPrvt("NQTDE00,NQTDE01,NQTDE02,NQTDE03,NQTDE04,NQTDE05")
SetPrvt("NQTDE06,NQTDE07,NQTDE08,NQTDE09,NQTDE10,NQTDE11")
SetPrvt("NQTDE12,TB,A,FIMLIN,LINHA,RSR")
SetPrvt("NOUTFILE,_MATRIC,_NOME,_CODCUSTO,_QTDE01,_QTDE02")
SetPrvt("_QTDE03,_QTDE04,_QTDE05,_QTDE06,_QTDE07,_QTDE08")
SetPrvt("_QTDE09,_QTDE10,_QTDE11,_QTDE12,B,M_PAG")
SetPrvt("_NLI,_PRIVEZ,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> #INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> #DEFINE PSAY SAY
#ENDIF

/*
Maner Consultoria - Data 15/08/2001
Ranking de horas extras
*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="P"
limite :=225
cString:="SRA"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Ranking de Horas extras"
cDesc1   := "O objetivo deste relatorio e' listar os Funcionarios totalizados"
cDesc2   := "por quantidade de horas extras no ano."
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
nomeprog := "NHGPE025"
cPerg    := "RHGP27"
// pergunte('GPM450',.T.)
wnrel:= "NHGPE025"

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif
ntipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

nPag := 1
//                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18
//         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1 := "MATRIC NOME                                     CCUSTO      FUNCAO       JANEIRO FEVEREIRO   MARCO    ABRIL     MAIO    JUNHO   JULHO    AGOSTO SETEMBRO  OUTUBRO NOVEMBRO DEZEMBRO"
//                                                                                 12345678 12345678 12345678 12345678 12345678 12345678 12345678 12345678 12345678 12345678 12345678 12345678 
nRos:=SM0->M0_CGC
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

rptStatus({||Imprime()},"Imprimindo...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Imprime)},"Imprimindo...")
Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Imprime
Static Function Imprime()
cString := "GPE"
aStru:={}
aAdd(aStru,{"NOME","C",40,00})
aAdd(aStru,{"MATRIC","C",6,00})
aAdd(aStru,{"CODCUSTO","C",9,0})
aAdd(aStru,{"FUNCAO","C",20,0})
aAdd(aStru,{"QTDE01","N",11,2})
aAdd(aStru,{"QTDE02","N",11,2})
aAdd(aStru,{"QTDE03","N",11,2})
aAdd(aStru,{"QTDE04","N",11,2})
aAdd(aStru,{"QTDE05","N",11,2})
aAdd(aStru,{"QTDE06","N",11,2})
aAdd(aStru,{"QTDE07","N",11,2})
aAdd(aStru,{"QTDE08","N",11,2})
aAdd(aStru,{"QTDE09","N",11,2})
aAdd(aStru,{"QTDE10","N",11,2})
aAdd(aStru,{"QTDE11","N",11,2})
aAdd(aStru,{"QTDE12","N",11,2})
cArq := CriaTrab(aStru,.T.)
// dbUseArea(.T.,,cArq,cString,.T.)
cInd := CriaTrab(NIL,.F.)
Use (cArq) alias GPE new Exclusive
_dat01:= "20" + substr(DTOC(DDATABASE),7,2) +"01"
_dat02:= "20" + substr(DTOC(DDATABASE),7,2) +"02"
_dat03:= "20" + substr(DTOC(DDATABASE),7,2) +"03"
_dat04:= "20" + substr(DTOC(DDATABASE),7,2) +"04"
_dat05:= "20" + substr(DTOC(DDATABASE),7,2) +"05"
_dat06:= "20" + substr(DTOC(DDATABASE),7,2) +"06"
_dat07:= "20" + substr(DTOC(DDATABASE),7,2) +"07"
_dat08:= "20" + substr(DTOC(DDATABASE),7,2) +"08"
_dat09:= "20" + substr(DTOC(DDATABASE),7,2) +"09"
_dat10:= "20" + substr(DTOC(DDATABASE),7,2) +"10"
_dat11:= "20" + substr(DTOC(DDATABASE),7,2) +"11"
_dat12:= "20" + substr(DTOC(DDATABASE),7,2) +"12"
_DatAtu := "20" + substr(DTOC(DDATABASE),7,2) +substr(DTOC(DDATABASE),4,2)
MsgBox (_dat01,"_dat01","INFO")
MsgBox (_dat02,"_dat02","INFO")
MsgBox (_dat03,"_dat03","INFO")
MsgBox (_dat04,"_dat04","INFO")
MsgBox (_dat05,"_dat05","INFO")
MsgBox (_dat06,"_dat06","INFO")
MsgBox (_dat07,"_dat07","INFO")
MsgBox (_dat08,"_dat08","INFO")
MsgBox (_dat09,"_dat09","INFO")
MsgBox (_dat10,"_dat10","INFO")
MsgBox (_dat11,"_dat11","INFO")
MsgBox (_dat12,"_dat12","INFO")
MsgBox (_datatu,"_datatu","INFO")
DbSelectArea("SRD")
DbSetOrder(01)
DbSelectArea("SRA")
DbSetOrder(01)
DbSelectArea("SI3")
DbSetOrder(01)
DbSelectArea("SRJ")
DbSetOrder(01)
SRA->(DbGoTop())

SRA->(DbSeek("01",.T.))
While SRA->(!Eof())  
   If SRA->RA_FILIAL < mv_par01 .OR. SRA->RA_FILIAL > mv_par02
      SRA->(DbSkip())
      Loop
   EndIf
   If SRA->RA_MAT < mv_par03 .OR. SRA->RA_MAT > mv_par04
      SRA->(DbSkip())
      Loop
   EndIf
   If SRA->RA_CC < mv_par05 .OR. SRA->RA_CC > mv_par06
      SRA->(DbSkip())
      Loop
   EndIf
   _Funcao := "Funcao Nao Cadastrada"
   SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC,.T.))
   IF SRA->RA_CODFUNC==SRJ->RJ_FUNCAO
      _Funcao := SRJ->RJ_DESC
   EndIf   
   nQtde00:=0.00
   nQtde01:=0.00
   nQtde02:=0.00
   nQtde03:=0.00
   nQtde04:=0.00
   nQtde05:=0.00
   nQtde06:=0.00
   nQtde07:=0.00
   nQtde08:=0.00
   nQtde09:=0.00
   nQtde10:=0.00
   nQtde11:=0.00
   nQtde12:=0.00
   If _DatAtu >= _DAT01
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT01+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499" 
         If SRD->RD_DATARQ == _DAT01 
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde01:= nQtde01 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde01:= nQtde01 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde01:= nQtde01 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde01:= nQtde01 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT02
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT02+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499" 
         If SRD->RD_DATARQ == _DAT02
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde02:= nQtde02 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde02:= nQtde02 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde02:= nQtde02 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde02:= nQtde02 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT03
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT03+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT03 
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde03:= nQtde03 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde03:= nQtde03 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde03:= nQtde03 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde03:= nQtde03 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT04
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT04+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT04
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde04:= nQtde04 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde04:= nQtde04 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde04:= nQtde04 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde04:= nQtde04 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT05
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT05+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT05 
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde05:= nQtde05 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde05:= nQtde05 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde05:= nQtde05 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde05:= nQtde05 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT06
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT06+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT06
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde06:= nQtde06 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde06:= nQtde06 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde06:= nQtde06 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde06:= nQtde06 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT07
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT07+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT07 
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde07:= nQtde07 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde07:= nQtde07 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde07:= nQtde07 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde07:= nQtde07 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT08
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT08+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT08
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde08:= nQtde08 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde08:= nQtde08 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde08:= nQtde08 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde08:= nQtde08 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT09
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT09+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT09 
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde09:= nQtde09 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde09:= nQtde09 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde09:= nQtde09 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde09:= nQtde09 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT10
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT10+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT10
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde10:= nQtde10 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde10:= nQtde10 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde10:= nQtde10 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde10:= nQtde10 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT11
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT11+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT11 
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde11:= nQtde11 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde11:= nQtde11 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde11:= nQtde11 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde11:= nQtde11 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   If _DatAtu >= _DAT12
      SRD->(DbGoTop())
      SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DAT12+"105",.T.))
      WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_PD < "499"
         If SRD->RD_DATARQ == _DAT12
            If SRD->RD_PD >="105" .and. SRD->RD_PD <="111" 
               nQtde12:= nQtde12 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="116"
               nQtde12:= nQtde12 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD >="305" .and. SRD->RD_PD <="311" 
               nQtde12:= nQtde12 + SRD->RD_HORAS
            EndIf
            If SRD->RD_PD =="316"
               nQtde12:= nQtde12 + SRD->RD_HORAS
            EndIf
         Endif   
         SRD->(DbSkip())
      End DO
   End If
   nQtde00 := nQtde01 + nQtde02 +nQtde03 +nQtde04 +nQtde05 +nQtde06
   nQtde00 := nQtde00 + nQtde07 + nQtde08 +nQtde09 +nQtde10 +nQtde11 +nQtde12
   If nQtde00 > 0.00 
      MsgBox (str(nQtde00),"nQtde00 tem de ser > zero","INFO")
      DbSelectArea("GPE")
      RecLock("GPE",.T.)
         GPE->NOME     := SRA->RA_NOME
         GPE->MATRIC   := SRA->RA_MAT
         GPE->CODCUSTO := SRA->RA_CC
         GPE->FUNCAO   := _Funcao
         GPE->QTDE01   := nQtde01
         GPE->QTDE02   := nQtde02
         GPE->QTDE03   := nQtde03
         GPE->QTDE04   := nQtde04
         GPE->QTDE05   := nQtde05
         GPE->QTDE06   := nQtde06
         GPE->QTDE07   := nQtde07
         GPE->QTDE08   := nQtde08
         GPE->QTDE09   := nQtde09
         GPE->QTDE10   := nQtde10
         GPE->QTDE11   := nQtde11
         GPE->QTDE12   := nQtde12
      MsUnLock("GPE")
   Endif   
   SRA->(DbSkip())
End do   
TB:=SM0->M0_NOME    // garante integridade da matriz no rdmake
a:=GPE->(RecCount())
FIMLIN:=CHR(13)+CHR(10)
LINHA:={}
RSR := 0
If a>0
   nOutfile := FCreate("\dadosadv\rh\TESTE"+".TXT",0)  // cria o arquivo
   GPE->(DbGoTop())
   Do While GPE->(! Eof())
      RSR := RSR + 1
      _MATRIC:=GPE->MATRIC
      _NOME:=GPE->NOME
      _CODCUSTO:=GPE->CODCUSTO
      _FUNCAO:=GPE->FUNCAO
      _QTDE01:=GPE->QTDE01
      _QTDE02:=GPE->QTDE02
      _QTDE03:=GPE->QTDE03
      _QTDE04:=GPE->QTDE04
      _QTDE05:=GPE->QTDE05
      _QTDE06:=GPE->QTDE06
      _QTDE07:=GPE->QTDE07
      _QTDE08:=GPE->QTDE08
      _QTDE09:=GPE->QTDE09
      _QTDE10:=GPE->QTDE10
      _QTDE11:=GPE->QTDE11
      _QTDE12:=GPE->QTDE12
      b:=_MATRIC+_NOME+_CODCUSTO+_FUNCAO+SUBSTR(STR(_QTDE01*100),1,11)+SUBSTR(STR(_QTDE02*100),1,11)+SUBSTR(STR(_QTDE03*100),1,11)+SUBSTR(STR(_QTDE04*100),1,11)+SUBSTR(STR(_QTDE05*100),1,11)+SUBSTR(STR(_QTDE06*100),1,11)+SUBSTR(STR(_QTDE07*100),1,11)+SUBSTR(STR(_QTDE08*100),1,11)+SUBSTR(STR(_QTDE09*100),1,11)+SUBSTR(STR(_QTDE10*100),1,11)+SUBSTR(STR(_QTDE11*100),1,11)+SUBSTR(STR(_QTDE12*100),1,11)+FIMLIN
          FWrite(nOutFile,b,209) // chr(10) indica fim de linha
                                 // ,241 indica o tamanho da linha b=240+chr(10)=1
      GPE->(DbSkip())
   Enddo
   FClose(nOutFile)                // fecha o arquivo
                                   // ,510 indica o tamanho da linha b=510+chr(10)+chr(13)=2
EndIf
limite   := 225
m_pag    := 1
@ 01  , 01 pSay Chr(18)
_NLI:= 80
      DbSelectArea("GPE")

If substr(DTOC(DDATABASE),4,2) == "01"
   SORT TO \dadosadv\RH\GPE ON QTDE01 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "02"
   SORT TO \dadosadv\RH\GPE ON QTDE02 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "03"
   SORT TO \dadosadv\RH\GPE ON QTDE03 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "04"
   SORT TO \dadosadv\RH\GPE ON QTDE04 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "05"
   SORT TO \dadosadv\RH\GPE ON QTDE05 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "06"
   SORT TO \dadosadv\RH\GPE ON QTDE06 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "07"
   SORT TO \dadosadv\RH\GPE ON QTDE07 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "08"
   SORT TO \dadosadv\RH\GPE ON QTDE08 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "09"
   SORT TO \dadosadv\RH\GPE ON QTDE09 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "10"
   SORT TO \dadosadv\RH\GPE ON QTDE10 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "11"
   SORT TO \dadosadv\RH\GPE ON QTDE11 /D
EndIf
If substr(DTOC(DDATABASE),4,2) == "12"
   SORT TO \dadosadv\RH\GPE ON QTDE12 /D
EndIf

_PRIVEZ:= 0
Use \dadosadv\RH\GPE.DBF
While (! Eof())
   If _NLI > 66
      iF _PRIVEZ == 1
         Eject
      eNDIF
      iF _PRIVEZ == 0
         _PRIVEZ := 1
      ENDIF
      Cabecalho()
   Endif
   @ _NLI , 01 pSay MATRIC
   @ _NLI , 08 pSay NOME
   @ _NLI , 49 pSay CODCUSTO
   @ _NLI , 61 pSay substr(FUNCAO,1,10)
   @ _NLI , 73 pSay QTDE01 Picture "@E 9,999.99"
   @ _NLI , 82 pSay QTDE02 Picture "@E 9,999.99"
   @ _NLI , 91 pSay QTDE03 Picture "@E 9,999.99"
   @ _NLI ,100 pSay QTDE04 Picture "@E 9,999.99"
   @ _NLI ,109 pSay QTDE05 Picture "@E 9,999.99"
   @ _NLI ,118 pSay QTDE06 Picture "@E 9,999.99"
   @ _NLI ,127 pSay QTDE07 Picture "@E 9,999.99"
   @ _NLI ,136 pSay QTDE08 Picture "@E 9,999.99"
   @ _NLI ,145 pSay QTDE09 Picture "@E 9,999.99"
   @ _NLI ,154 pSay QTDE10 Picture "@E 9,999.99"
   @ _NLI ,163 pSay QTDE11 Picture "@E 9,999.99"
   @ _NLI ,172 pSay QTDE12 Picture "@E 9,999.99"
   _NLI := _NLI +1
   (DbSkip())
End do   
RetIndex("SRA")
RetIndex("SRD")
RetIndex("SI3")
RetIndex("SRJ")

DbSelectArea("GPE")
DbCloseArea()

Eject
RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Cabecalho
Static Function Cabecalho()
//                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18
//         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 02  , 01 pSay Replicate("-",180)
@ 03  , 01 pSay "New Hubner"
@ 03  ,172 pSay "Folha: " + strzero(m_pag,2)
@ 04  , 01 pSay "SIGA/NHGPE025 "
@ 04  , 90 pSay "Ranking de Horas Extras"
@ 04  ,164 pSay "Emissao: " + Dtoc(Date())
@ 05  , 01 pSay "Hora: " + time()
@ 06  , 01 pSay Replicate("-",180)
@ 07  , 01 pSay CABEC1
_NLI := 10
m_pag := m_pag + 1
Return
