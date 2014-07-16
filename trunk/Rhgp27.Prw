#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function Rhgp27()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

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
SetPrvt("NOMEPROG,CPERG,NPAG,CQUERY,NREG,NROS")
SetPrvt("ADRIVER,CCOMPAC,CNORMAL,NUMERO,CULTIMO,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> #INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RHGP27          ³ Marcelo J. Santos     ³ Data ³ 16.09.99 ³±±
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
titulo   := "Relatorio de Funcionarios com Dependentes"
cDesc1   := "O objetivo deste relatorio e' listar os Funcionarios e"
cDesc2   := "seus dependentes."
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
nomeprog := "RHGP27"
cPerg    := "RHGP27"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte('GPM450',.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "RHGP27"

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


nPag := 1

cabec1 := "MATRICULA    NOME                                                 CENTRO DE CUSTOS                                      "
cabec2 := "---------    ---------------------------------------------------- ----------------------------------------------------- "
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   1         2         3         4

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Gerando)},"Gerando Base para o Relatorio...")

rptStatus({||Imprime()},"Imprimindo...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Imprime)},"Imprimindo...")
Return


// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Gerando
Static Function Gerando()
cQuery := "SELECT RA_MAT,RA_NOME,RA_CC"
cQuery := cQuery + " FROM SRANH0"
cQuery := cQuery + " WHERE RA_CC BETWEEN '" + Dtos(Mv_par01) + "' AND '" + Dtos(Mv_par02) + "' "
cQuery := cQuery + " AND D_E_L_E_T_ <> '*' AND RA_SITFOLHA='F' AND RA_SITFOLHA=' ' "
cQuery := cQuery + " ORDER BY RA_CC,RA_NOME"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TEMPSRA"
DbSelectArea("TEMPSRA")

Return


// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function IMPRIME
Static Function IMPRIME()
//DbSelectArea("SRA")
//Copy to TEMP.DBF for SRA->RA_SITFOLH$" F"

//Use TEMP.DBF alias TEMPSRA new
//Index on RA_MAT to TEMP

//Close TEMPSRA

//Use TEMP.DBF index TEMP alias TEMPSRA new

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
// IncRegua()
   If pRow() > 66
      Eject
      nPag := nPag + 1
      Cabecalho()
   Endif
   @ pRow()+1,00 pSay TEMPSRA->RA_MAT
   @ pRow(),13 pSay TEMPSRA->RA_NOME
   SI3->(DbSeek(xFilial("SI3")+TEMPSRA->RA_CC))
   @ pRow(),66 pSay SI3->IC_CUSTO + " - " + SI3->I3_DESC
   SRB->(DbSeek(xFilial("SRB")+TEMPSRA->RA_MAT))
   If SRB->(Found())
      While SRB->RB_MAT == TEMPSRA->RA_MAT
         @ pRow()+1,20 psay SRB->RB_NOME
         SRB->(DbSkip())
      Enddo
   Endif
   TEMPSRA->(DbSkip())
Enddo

Eject

RestScreen(3,0,24,79,cSavScr1)
DbSelectArea("TEMPSRA")
DbCloseArea()

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

