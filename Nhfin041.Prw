/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ NHFIN041 ³ Autor ³ MICROSIGA             ³ Data ³ 09.09.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³EMITE DUPLICATA PADRAO MICROSIGA                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DUPLI  (void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento/Financeiro                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"      

User Function NHFIN041()    

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("CPERG,NLASTKEY,LI,CSAVSCR1,CSAVCUR1,CSAVROW1")
SetPrvt("CSAVCOL1,CSAVCOR1,WNREL,ADRIVER,CCOMPAC,CNORMAL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo  := "EMISSAO DE DUPLICATAS"
cDesc1  := "Este programa ir  emitir as Duplicatas conforme"
cDesc2  := "parametros especificados."
cDesc3  := ""
cString := "SE1"
aReturn:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cPerg  :="MTR750"
nLastKey := 0
li := 06

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros        ³
//³ mv_par01            // Duplicata de         ³
//³ mv_par02            // Duplicata ate        ³
//³ mv_par03            // Serie                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR750",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="DUPLI" 

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)


If LastKey() == 27 .Or. nLastKey == 27
   Return()
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
   Return()
Endif

rptStatus({||Imprime()},"Imprimindo...")
Return


Static Function Imprime()
dbSelectArea("SE1")
SE1->(dbSetOrder(1)) // filial + prefixo + numero
SE1->(DbSeek(xFilial("SE1")+mv_par03+mv_par01,.T.))

If (SE1->E1_NUM <= mv_par02 .And. SE1->E1_PREFIXO == mv_par03) 
	
//   SetRegua(RecCount())
//   Set Print On   
//   Set Device to Print

   aDriver := ReadDriver()
   cCompac := aDriver[1]
   cNormal := aDriver[2]

   @ PRow(), 000 PSAY &cCompac+" "     // Compressao de Impressao
   SetRegua(Val(mv_par02)-Val(mv_par01))
   While (SE1->E1_NUM <= mv_par02 .And. SE1->E1_PREFIXO == mv_par03) .and. !SE1->(Eof())
      @ prow()+5,095 PSAY SE1->E1_EMISSAO
      @ prow()+5,027 PSAY SE1->E1_VALOR picture "@E 99,999,999.99"
      @ prow(),050 PSAY SE1->E1_NUM
      @ prow(),065 PSAY SE1->E1_VALOR picture "@E 99,999,999.99"
      @ prow(),086 PSAY SE1->E1_NUM+"-"+SE1->E1_PREFIXO
      SF2->(DbSetOrder(1))
      SF2->(DbSeek(xFilial("SF2")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA))
      If Substr(SF2->F2_COND,1,3) == "XXX"    // "APR"
         @ prow(),102 PSAY "C/APRES."
      Else
         @ prow(),0102 PSAY SE1->E1_VENCTO
      Endif
      DbSelectArea("SA1")
      SA1->(DbSetOrder(1))
      SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
      If SA1->(Found())
         @ prow()+5,039 PSAY SA1->A1_NOME
         @ prow()+1,039 PSAY SA1->A1_END
         @ prow(),110   PSAY SA1->A1_CEP picture "@R 99999-999"
         @ prow()+1,039 PSAY SA1->A1_MUN
         @ prow(),075   PSAY SA1->A1_EST

         @ prow()+1,039 PSAY SA1->A1_ENDCOB
         @ prow(),110   PSAY SA1->A1_CEPC picture "@R 99999-999"
         @ prow()+1,039 PSAY SA1->A1_CGC picture "@R 99.999.999/9999-99"
         @ prow(),110   PSAY SA1->A1_INSCR

      Endif 
       
      DbSelectArea("SE1")
       
      @ prow()+2,039 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),1,75)) + REPLICATE("*",54),1,75)
      @ prow()+1,039 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),76,75)) + REPLICATE("*",54),1,75) 
      @ prow()+1,039 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),152,75)) + REPLICATE("*",54),1,75)
      SE1->(DbSkip())
      IncRegua()
      @ prow()+13,030 PSAY ""
   EndDO
Endif


//Set Device to Screen
DbSelectArea("SE1")
DbSetOrder(1)
DbSelectArea("SA1")
DbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em Disco, chama Spool.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
     Set Printer To 
     dbCommitAll()
     ourspool(wnrel)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para Spool da Rede.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_PFLUSH()
Return()

