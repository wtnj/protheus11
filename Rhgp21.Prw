#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp21()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

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
SetPrvt("NOMEPROG,CPERG,N10,N20,N25,N30")
SetPrvt("N35,N40,N45,N50,N55,N65")
SetPrvt("N75,NGE,NTO,NPAG,NREG,NROS")
SetPrvt("ADRIVER,CCOMPAC,CNORMAL,NUMERO,CULTIMO,CDESCRICAO")
SetPrvt("CDESCUL,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RHGP21          ³ Marcelo J. Santos     ³ Data ³ 16.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Funcionarios Totalizado por Grau de Instrucao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="M"
limite :=132
cString:="SRA"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio de Funcionarios por Grau de Instrucao"
cDesc1   := "O objetivo deste relatorio e' listar os Funcionarios totalizados"
cDesc2   := "por Grau de Instrucao."
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
nomeprog := "RHGP21"
cPerg    := "NFSIGW"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte('GPM450',.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "RHGP21"

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

n10 := 0
n20 := 0
n25 := 0
n30 := 0
n35 := 0
n40 := 0
n45 := 0
n50 := 0
n55 := 0
n65 := 0
n75 := 0
nGe := 0 
nTo := 0
nPag := 1

cabec1 := "MATRICULA    NOME                               GRAU DE INSTRUCAO"
cabec2 := "---------    ---------------------------------  ------------------------------------------------------------------------------------"


DbSelectArea("SRA")
Copy to TEMP.DBF for SRA->RA_SITFOLH$" F"

Use TEMP.DBF alias TEMPSRA new
Index on RA_GRINRAI+RA_NOME to TEMP
     
DbSelectArea("TEMPSRA")
DbCloseArea()


Use TEMP.DBF index TEMP alias TEMPSRA new

DbSelectArea("TEMPSRA")
nREG := TEMPSRA->(Reccount())
//SetRegua(nREG)
TEMPSRA->(DbgoTop())

nRos:=SM0->M0_CGC
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Cabecalho()

Numero:=1
Numero:=Numero+1
cULTIMO := "  "
TEMPSRA->(dbGoTop())
While TEMPSRA->(!Eof())
   //IncRegua()
   If pRow() > 66
      Eject
      nPag := nPag + 1
      Cabecalho()
   Endif
   If TEMPSRA->RA_GRINRAI <> cULTIMO .and. cULTIMO <> "  "
      @ prow()+2,00 PSAY "TOTAL ------> "+Alltrim(cDESCUL)+" ------> "
      @ prow(),pcol()+01 PSAY nTo picture "@ 99,999"
      @ pRow()+1,00 PSAY " "
      nTo := 0
   Endif
   SX5->(DbSeek("  26"+TEMPSRA->RA_GRINRAI,.F.))
   cDESCRICAO := SX5->X5_DESCRI
   @ prow()+1,00 PSAY TEMPSRA->RA_MAT+"       "+TEMPSRA->RA_NOME+"     "+cDESCRICAO
   cULTIMO := TEMPSRA->RA_GRINRAI
   cDESCUL := cDESCRICAO
   nGe := nGe + 1
   nto := nto + 1
   Do Case
      Case TEMPSRA->RA_GRINRAI == "10"
         n10 := n10 + 1
      Case TEMPSRA->RA_GRINRAI == "20"
         n20 := n20 + 1
      Case TEMPSRA->RA_GRINRAI == "25"
         n25 := n25 + 1
      Case TEMPSRA->RA_GRINRAI == "30"
         n30 := n30 + 1
      Case TEMPSRA->RA_GRINRAI == "35"
         n35 := n35 + 1
      Case TEMPSRA->RA_GRINRAI == "40"
         n40 := n40 + 1
      Case TEMPSRA->RA_GRINRAI == "45"
         n45 := n45 + 1
      Case TEMPSRA->RA_GRINRAI == "50"
         n50 := n50 + 1
      Case TEMPSRA->RA_GRINRAI == "55"
         n55 := n55 + 1
      Case TEMPSRA->RA_GRINRAI == "65"
         n65 := n65 + 1
      Case TEMPSRA->RA_GRINRAI == "75"
         n65 := n65 + 1
   EndCase
   TEMPSRA->(DbSkip())
Enddo

@ prow()+2,00 PSAY "TOTAIS: "
@ prow()+1,00 PSAY "ANALFABETO                                           "+Trans(n10,"@ 99,999")
@ prow()+1,00 PSAY "ATE 4a SERIE INCOMPLETA (PRIMARIO INCOMPLETO)        "+Trans(n20,"@ 99,999")
@ prow()+1,00 PSAY "COM 4a SERIE COMPLETA DO 1o GRAU (PRIMARIO COMPLETO) "+Trans(n25,"@ 99,999")
@ prow()+1,00 PSAY "5a A 8a SERIE INCOMPLETA (GINASIO INCOMPLETO)        "+Trans(n30,"@ 99,999")
@ prow()+1,00 PSAY "PRIMEIRO GRAU (GINASIO) COMPLETO                     "+Trans(n35,"@ 99,999")
@ prow()+1,00 PSAY "SEGUNDO GRAU (COLEGIAL) INCOMPLETO                   "+Trans(n40,"@ 99,999")
@ prow()+1,00 PSAY "SEGUNDO GRAU (COLEGIAL) COMPLETO                     "+Trans(n45,"@ 99,999")
@ prow()+1,00 PSAY "SUPERIOR INCOMPLETO                                  "+Trans(n50,"@ 99,999")
@ prow()+1,00 PSAY "SUPERIOR COMPLETO                                    "+Trans(n55,"@ 99,999")
@ prow()+1,00 PSAY "MESTRADO COMPLETO                                    "+Trans(n65,"@ 99,999")
@ prow()+1,00 PSAY "DOUTORADO COMPLETO                                   "+Trans(n75,"@ 99,999")
@ prow()+2,00 PSAY "TOTAL GERAL                                          "+Trans(nGe,"@ 99,999")
Eject

RestScreen(3,0,24,79,cSavScr1)
DbSelectArea("TEMPSRA")
DbCloseArea()


Delete File TEMP.DBF
Delete File TEMP.NTX
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Cabecalho
Static Function Cabecalho()
@ prow()+1,00 Psay &cCompac+Repli("*",132)
@ prow()+1,00 Psay "*"+SM0->M0_NOMECOM
@ prow(),112 Psay "Folha : "                                                                                                    
@ prow(),124 Psay StrZero(nPag,5,0)+"  *"
@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
@ prow(),20 Psay PadC(titulo,82)
@ prow(),112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
@ prow()+1,00 Psay "*Hora...: "+Time()
@ prow(),112 Psay "Emissao: "+Dtoc(Date())+"  *"
@ prow()+1,00 Psay Repli("*",132)
@ prow()+1,00 Psay " "
@ prow()+1,00 Psay cabec1 
@ prow()+1,00 Psay cabec2 

Return

