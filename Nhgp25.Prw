#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function Nhgp25()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,AORD")
SetPrvt("NORDEM,TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT")
SetPrvt("NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,CSTRING")
SetPrvt("NTIPO,M_PAG,NOMEPROG,CPERG,ASTRU,NQTDE")
SetPrvt("NVALOR,CARQ,_DATARQ,_NLI,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> #DEFINE PSAY SAY
#ENDIF

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""
cabec1:="";cabec2:="";cabec3:="";wnrel:=""
aOrd:=0

nOrdem:=0
tamanho:="M"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Ranking de horas extras"
cDesc1   := "Este programa gera relatorio com quantidade e valores de "
cDesc2   := "Horas extras"
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "NHGPE025"
cPerg    := "NHGPE25"
//"01","Imprime Todos","","","mv_ch1","N",1,0,1,"C","","mv_par01","Sim","","","","","Nao","","","","","","","",""})
//"02","Mes / Ano","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
//pergunte(cPerg,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

SetDefault(aReturn,cString)

cabec1 := "."
cabec2 := "Ranking de Horas Extras"
cabec3 := "." 

#IFDEF WINDOWS
    RptStatus({|| gerahr()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==>     RptStatus({|| SGSCOM()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| gerahr()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 06/06/01 ==>     RptStatus({|| Execute(SGSCOM)})  //-- Chamada do Relatorio.
    Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function gerahr
Static Function gerahr()
aStru:={}
nQtde:=0.00
nValor:=0.00
aAdd(aStru,{"NOME","C",40,00})
aAdd(aStru,{"MATRIC","C",6,00})
aAdd(aStru,{"SALARIO","N",11,2})
aAdd(aStru,{"CODCUSTO","C",9,0})
aAdd(aStru,{"CCCUSTO","C",25,0})
aAdd(aStru,{"CODFUNCAO","C",4,0})
aAdd(aStru,{"FUNCAO","C",20,0})
aAdd(aStru,{"QTDE","N",11,2})
aAdd(aStru,{"VALOR","N",11,2})


cArq := CriaTrab(aStru,.T.)
Use (cArq) alias TRB new Exclusive
SORT TO TRB ON TRB->QTDE /D
//_datarq:= substr(mv_par02,3,4) +substr(mv_par02,1,2)
_datarq:= "200105"
DbSelectArea("SRD")
DbSetOrder(01)
DbSelectArea("SRA")
DbSetOrder(01)
DbSelectArea("SI3")
DbSetOrder(01)
DbSelectArea("SRJ")
DbSetOrder(01)
SRA->(DbSeek("01",.T.))
While SRA->(!Eof())  
   If SRA->RA_SITFOLH=="T" .OR. SRA->RA_SITFOLH=="D"
      SRA->(DbSkip())
      Loop
   EndIf   
   nQtde:=0.00
   nValor:=0.00
   SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_DATARQ+"108",.T.))
   WHILE  SRA->RA_FILIAL==SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT .and. SRD->RD_DATARQ==_DATARQ
      If SRD->RD_PD $("108109110111112")
         nQtde:=SRD->RD_HORAS
         nValor:=SRD->RD_VALOR
      Endif   
   End DO   
   If nQtde > 0.00
      RecLock("TRB",.T.)
         TRB->NOME   := SRA->RA_NOME
         TRB->MATRIC := SRA->RA_MAT
         TRB->SALARIO:= SRA->RA_SALARIO
         TRB->CODCUSTO:= SRA->RA_CC
         TRB->CCCUSTO:= "NAO CADASTRADO"
         SI3->(DbSeek(xFilial()+SRA->RA_CC,.T.))
         If SRA->RA_FILIAL==SI3->I3_FILIAL .and. SRA->RA_CC==SI3->I3_CUSTO
            TRB->CCCUSTO:= SI3->I3_DESC
         EndIf   
         TRB->CODFUNCAO:= SRA->RA_CODFUNC
         TRB->FUNCAO:= "NAO CADASTRADO"
         SRJ->(DbSeek(xFilial()+SRA->RA_CODFUNC,.T.))
         If SRA->RA_FILIAL==SRJ->RJ_FILIAL .and. SRA->RA_CODFUNC==SRJ->RJ_FUNCAO
            TRB->FUNCAO:= SRJ->RJ_DESC
         EndIf   
         TRB->QTDE:= nQtde
         TRB->VALOR:= nValor
      TRB->(MsUnLock())
   Endif   
   SRA->(DbSkip())
End do   
limite   := 132
m_pag    := 1
@ 01  , 01 pSay Chr(15)                                                                                                     
_NLI:= 80

DbSelectArea("TRB")
TRB->(DbGoTop())
TRB->(DbSeek("01",.T.))
While TRB->(! Eof())
   @ _NLI , 01 pSay TRB->NOME
   @ _NLI , 42 pSay TRB->MATRIC
   @ _NLI , 50 pSay TRB->SALARIO Picture "@E 99,999.99"
   @ _NLI , 60 pSay TRB->CODCUSTO
   @ _NLI , 70 pSay TRB->CCCUSTO
//@ _NLI , 102 pSay TRB->CODFUNCAO
   @ _NLI , 97 pSay TRB->FUNCAO
   @ _NLI , 108 pSay TRB->QTDE Picture "@E 999.99"
   @ _NLI , 116 pSay TRB->VALOR Picture "@E 999,999.99"

   TRB->(DbSkip())
End do   
RetIndex("SRA")
RetIndex("SRD")
RetIndex("SI3")
RetIndex("SRJ")

Set device to Screen
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Cabec 
Static Function Cabec()
//               0        1         2        3         4         5         6         7         8         9        10        11        12        13
//               12345678901234567890123456780123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@ 02  , 01 pSay Replicate("-",limite)
@ 03  , 01 pSay "New Hubner"
@ 03  ,125 pSay "Folha:" + strzero(m_pag,2)
@ 04  , 01 pSay "SIGA/NHGPE025 "
@ 04  , 50 pSay "Ranking de Horas Extras"
@ 04  ,116 pSay "Emissao: " + Dtoc(Date())
@ 05  , 01 pSay "Hora: " + time()
@ 06  , 01 pSay Replicate("-",limite)
@ 07  , 01 pSay "               Produto                                             Quantidade       Valor  Dt Vencto  Dt Baixa   Comissao     Valor"
_NLI:=8
m_pag := m_pag + 1
Return
