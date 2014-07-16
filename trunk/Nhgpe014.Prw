#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHGPE014        ³ Luciane P. Correia    ³ Data ³ 03.07.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Dependentes - Funcionarios Ativos (est civil)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function nhgpe014()

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,CRODATXT")
SetPrvt("NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,CQUERY,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,NUMERO,CULTIMO,_ESTADO,_DESCRICAO,_CCC")

cSavCur1 := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont   := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem   := 0
tamanho  := "M"
limite   := 132
cString  := "SRA"
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relacao de Dependentes por Estado Civil"
cDesc1   := "O objetivo deste relatorio eh listar os Funcionarios e"
cDesc2   := "seus dependentes."
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
nomeprog := "NHGPE014"
cPerg    := "RHGP27"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Da Filial                                       ³
//³ mv_par02     Ate a Filial                                    ³
//³ mv_par03     Da Matricula                                    ³
//³ mv_par04     Ate a Matricula                                 ³
//³ mv_par05     Do Centro de Custo                              ³
//³ mv_par06     Ate o Centro de Custo                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Abertura dos Arquivos
SRA->(DbSetOrder(1)) // Filial + Matricula
SRB->(DbSetOrder(1)) // Filial + Matricula

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "NHGPE014"
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
ntipo := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
nPag  := 1

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Gerando)},"Gerando Base para o Relatorio...")

cabec1 := "MATRICULA    NOME                                                                                DATA NASCIMENTO                    "
cabec2 := "------------------------------------------------------------------------------------------------------------------------------------"
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                   1         2         3         4         5         6         7         8         9         0         1         2         3
rptStatus({||Imprime()},"Imprimindo...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Imprime)},"Imprimindo...")
DbCloseArea("TEMPSRA")

Return


// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Gerando
Static Function Gerando()
cQuery := "SELECT * "
cQuery := cQuery + " FROM "+ RetSqlName("SRA")
cQuery := cQuery + " WHERE RA_MAT BETWEEN '" + Mv_par03 + "' AND '" + Mv_par04 + "' AND"
cQuery := cQuery + " RA_CC BETWEEN '" + Mv_par05 + "' AND '" + Mv_par06 + "' AND"
cQuery := cQuery + " (RA_SITFOLH = 'A' OR RA_SITFOLH = 'F' OR RA_SITFOLH = ' ') AND"
cQuery := cQuery + " D_E_L_E_T_ <> '*' "
cQuery := cQuery + " ORDER BY RA_ESTCIVI,RA_MAT"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TEMPSRA"
DbSelectArea("TEMPSRA")

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function IMPRIME
Static Function IMPRIME()

SetRegua(TEMPSRA->(Reccount()))
TEMPSRA->(DbgoTop())

aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Cabecalho()

Numero:=1
Numero:=Numero+1
cULTIMO := "  "
_ESTADO:= TEMPSRA->RA_ESTCIVI
_DESCRICAO := ""
While TEMPSRA->(!Eof())

   If pRow() > 66
      Eject
      nPag := nPag + 1
      Cabecalho()
      @ prow()+1,00 Psay "*** " + TEMPSRA->RA_ESTCIVI + " ***"
   Endif

   If SRB->(DbSeek(xFilial("SRB")+TEMPSRA->RA_MAT))
      
      @ pRow()+1,4    pSay TEMPSRA->RA_MAT
      @ pRow()  ,17   pSay TEMPSRA->RA_NOME

      While TEMPSRA->RA_MAT == SRB->RB_MAT
         @ pRow()+1,24  psay SRB->RB_NOME
         @ pRow()  ,104 psay SRB->RB_DTNASC
         SRB->(DbSkip())
      EndDo

      If _ESTADO != TEMPSRA->RA_ESTCIVI
         @ Prow() + 1, 000 Psay Repli("-",132)
         If TEMPSRA->RA_ESTCIVI == "C"
            _DESCRICAO := "CASADO"
         ELSEIF TEMPSRA->RA_ESTCIVI == "D"
            _DESCRICAO := "DIVORCIADO"
         ELSEIF TEMPSRA->RA_ESTCIVI == "M"
            _DESCRICAO := "MARITAL"
         ELSEIF TEMPSRA->RA_ESTCIVI == "Q"
            _DESCRICAO := "DESQUITADO"
         ELSEIF TEMPSRA->RA_ESTCIVI == "S"
            _DESCRICAO := "SOLTEIRO"
         ELSEIF TEMPSRA->RA_ESTCIVI == "V"
            _DESCRICAO := "VIUVO"
         ENDIF

         @ Prow() + 1, 000 Psay "*** Estado Civil:  " + TEMPSRA->RA_ESTCIVI+ " "+ _DESCRICAO + " ***"
         _cCC := TEMPSRA->RA_ESTCIVI
      Endif

      IncRegua()

   Endif
   TEMPSRA->(DbSkip())

EndDo

RestScreen(3,0,24,79,cSavScr1)
DbCloseArea("TEMPSRA")
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Cabecalho
Static Function Cabecalho()
If TEMPSRA->RA_ESTCIVI == "C"
   _DESCRICAO := "CASADO"
ELSEIF TEMPSRA->RA_ESTCIVI == "D"
   _DESCRICAO := "DIVORCIADO"
ELSEIF TEMPSRA->RA_ESTCIVI == "M"
   _DESCRICAO := "MARITAL"
ELSEIF TEMPSRA->RA_ESTCIVI == "Q"
   _DESCRICAO := "DESQUITADO"
ELSEIF TEMPSRA->RA_ESTCIVI == "S"
   _DESCRICAO := "SOLTEIRO"
ELSEIF TEMPSRA->RA_ESTCIVI == "V"
   _DESCRICAO := "VIUVO"
ENDIF

@ prow()+1,00 Psay &cCompac+Repli("*",129)
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
@ prow()+1,00 Psay "*** Estado Civil: " + TEMPSRA->RA_ESTCIVI + " " + _DESCRICAO + " ***"

Return