/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ orcareal        ³ Osmar Schimitberger   ³ Data ³ 24.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ OrcadoXRealizado por C.Custo e Conta Contabil             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function Nhcon009()     

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,ADRIVER,LPRIMEIRO,CQUERY")
SetPrvt("_CANO,_NGERJANRE,_NGERFEVRE,_NGERMARRE,_NGERABRRE,_NGERMAIRE")
SetPrvt("_NGERJUNRE,_NGERJULRE,_NGERAGORE,_NGERSETRE,_NGEROUTRE,_NGERNOVRE")
SetPrvt("_NGERDEZRE,_NGERJANOR,_NGERFEVOR,_NGERMAROR,_NGERABROR,_NGERMAIOR")
SetPrvt("_NGERJUNOR,_NGERJULOR,_NGERAGOOR,_NGERSETOR,_NGEROUTOR,_NGERNOVOR")
SetPrvt("_NGERDEZOR,_CCC,_NVALJANOR,_NVALFEVOR,_NVALMAROR,_NVALABROR")
SetPrvt("_NVALMAIOR,_NVALJUNOR,_NVALJULOR,_NVALAGOOR,_NVALSETOR,_NVALOUTOR")
SetPrvt("_NVALNOVOR,_NVALDEZOR,_NVALJANRE,_NVALFEVRE,_NVALMARRE,_NVALABRRE")
SetPrvt("_NVALMAIRE,_NVALJUNRE,_NVALJULRE,_NVALAGORE,_NVALSETRE,_NVALOUTRE")
SetPrvt("_NVALNOVRE,_NVALDEZRE,_LPRIM,_LIMPTOT,_CDESCCC,_NZERO")



cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="G"
limite :=220
aReturn := { "Especial", 1,"Administracao", 1, 1, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Orcado X Realizado por C.Custo e Conta Contabil"
cDesc1   := "Orcado X Realizado por C.Custo e Conta Contabil "
cDesc2   := " "
cDesc3   := " "
cString  := "SIA"
nTipo    := 0
nomeprog := "NHCON009"
cPerg    := "CON009"
nPag     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Ano Referencia                                  ³
//³ mv_par02     Da Conta                                        ³
//³ mv_par03     Ate a Conta                                     ³
//³ mv_par04     Do Centro de Custo                              ³
//³ mv_par05     Ate o Centro de Custo                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Abertura dos Arquivos
SIA->(DbSetOrder(1)) // NÆo sera usado a ordem do sistema, sera em SQL
SI3->(DbSetOrder(1)) // Custo + Conta + Moeda
SI1->(DbSetOrder(1)) // Conta Contabil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHCON009"
Pergunte(cPerg,.f.)

SetPrint("SIA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

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

// Trata a impressora
aDriver :=  ReadDRIVER()
//--Setar impressora
If aReturn[4] == 1  // Comprimido
    @ 0,0 PSAY &(aDriver[5])
Else                // Normal
    @ 0,0 PSAY &(aDriver[6])
Endif

lPrimeiro := .T.

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

// rptStatus({||Imprime()},"Imprimindo...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> // rptStatus({||Execute(Imprime)},"Imprimindo...")
TIA->(DbCloseArea())

Return


Static Function Gerando()

cQuery := "SELECT * "
cQuery += " FROM " +  RetSqlName( 'SIA' )
cQuery += " WHERE IA_FILIAL = '" + xFilial("SIA")+ "'"
cQuery += " AND IA_CONTA BETWEEN '" + Mv_par02 + "' AND '" + Mv_par03 + "' AND"
cQuery += " IA_CC BETWEEN '" + Mv_par04 + "' AND '" + Mv_par05 + "' AND"
cQuery += " D_E_L_E_T_ <> '*' AND IA_ANO = '" + mv_par01 + "'"
cQuery += " ORDER BY IA_CC+IA_CONTA"
//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TIA"
DbSelectArea("TIA")

RptStatus({||Imprime()},"Imprimindo...")

Return


Static Function Imprime()

//_cAno := StrZero(Year(ddatabase),4)
_cAno := mv_par01 // ano de referencia

SetRegua(TIA->(RecCount()))
TIA->(DbGoTop())

lPrimeiro := .T.

_nGerJanRe := 0.00
_nGerFevRe := 0.00
_nGerMarRe := 0.00
_nGerAbrRe := 0.00
_nGerMaiRe := 0.00
_nGerJunRe := 0.00
_nGerJulRe := 0.00
_nGerAgoRe := 0.00
_nGerSetRe := 0.00
_nGerOutRe := 0.00
_nGerNovRe := 0.00
_nGerDezRe := 0.00

_nGerJanOr := 0.00
_nGerFevOr := 0.00
_nGerMarOr := 0.00
_nGerAbrOr := 0.00
_nGerMaiOr := 0.00
_nGerJunOr := 0.00
_nGerJulOr := 0.00
_nGerAgoOr := 0.00
_nGerSetOr := 0.00
_nGerOutOr := 0.00
_nGerNovOr := 0.00
_nGerDezOr := 0.00

While TIA->(!Eof())
   
   If pRow() > 66 .or. lPrimeiro == .T.
      If lPrimeiro == .F.
         Eject
         nPag := nPag + 1
      Endif
      lPrimeiro := .f.
      Cabecalho()
   Endif
   
   _cCC     := TIA->IA_CC

   // Inicializa valores Originais
   _nValJanOr := 0.00
   _nValFevOr := 0.00
   _nValMarOr := 0.00
   _nValAbrOr := 0.00
   _nValMaiOr := 0.00
   _nValJunOr := 0.00
   _nValJulOr := 0.00
   _nValAgoOr := 0.00
   _nValSetOr := 0.00
   _nValOutOr := 0.00
   _nValNovOr := 0.00
   _nValDezOr := 0.00

   // Inicializa os valores Reais
   _nValJanRe := 0.00
   _nValFevRe := 0.00
   _nValmarRe := 0.00
   _nValAbrRe := 0.00
   _nValMaiRe := 0.00
   _nValJunRe := 0.00
   _nValJulRe := 0.00
   _nValAgoRe := 0.00
   _nValSetRe := 0.00
   _nValOutRe := 0.00
   _nValNovRe := 0.00
   _nValDezRe := 0.00
         
   // Imprimir notas que geraram financeiro
   _lPrim   := .t.
   _lImpTot := .f.
   While TIA->(!Eof()) .And. TIA->IA_CC == _cCC
         
         If pRow() > 66 
            If lPrimeiro == .F.
               Eject
               nPag := nPag + 1
            Endif
            lPrimeiro := .f.
            Cabecalho()
         Endif
              
         // Localiza a Conta dentro do CC e Imprime
         If SI3->(DbSeek(xFilial("SI3")+_cCC)) // Buscar o nome
            _cDescCC := AllTrim(SI3->I3_DESC)
         Else
            _cDescCC := "Nao achou CC"
         Endif

         If SI3->(DbSeek(xFilial("SI3")+_cCC+TIA->IA_CONTA))
            SI1->(DbSeek(xFilial("SI1")+TIA->IA_CONTA))
            @ Prow()+01, 001 Psay Alltrim(SI3->I3_CUSTO) + "/" + AllTrim(SI3->I3_CONTA) + " - " + _cDescCC + "/" + SI1->I1_DESC

            //Impressao dos valores originais
            @ Prow()+01, 006 Psay "Original"
            @ Prow()   , 023 Psay TIA->IA_VLORC01 Picture "@E 9,999,999.99"
            @ Prow()   , 040 Psay TIA->IA_VLORC02 Picture "@E 9,999,999.99"
            @ Prow()   , 057 Psay TIA->IA_VLORC03 Picture "@E 9,999,999.99"
            @ Prow()   , 074 Psay TIA->IA_VLORC04 Picture "@E 9,999,999.99"
            @ Prow()   , 090 Psay TIA->IA_VLORC05 Picture "@E 9,999,999.99"
            @ Prow()   , 107 Psay TIA->IA_VLORC06 Picture "@E 9,999,999.99"
            @ Prow()   , 124 Psay TIA->IA_VLORC07 Picture "@E 9,999,999.99"
            @ Prow()   , 141 Psay TIA->IA_VLORC08 Picture "@E 9,999,999.99"
            @ Prow()   , 158 Psay TIA->IA_VLORC09 Picture "@E 9,999,999.99"
            @ Prow()   , 175 Psay TIA->IA_VLORC10 Picture "@E 9,999,999.99"
            @ Prow()   , 192 Psay TIA->IA_VLORC11 Picture "@E 9,999,999.99"
            @ Prow()   , 209 Psay TIA->IA_VLORC12 Picture "@E 9,999,999.99"

            //Impressao dos valores Realizados
            @ Prow()+01, 006 Psay "Realizado"
            If mv_par01 == GetMv("MV_EXERC1")
               @ Prow()   , 023 Psay SI3->I3_DEB01-SI3->I3_CRE01 Picture "@E 9,999,999.99"
               @ Prow()   , 040 Psay SI3->I3_DEB02-SI3->I3_CRE02 Picture "@E 9,999,999.99"
               @ Prow()   , 057 Psay SI3->I3_DEB03-SI3->I3_CRE03 Picture "@E 9,999,999.99"
               @ Prow()   , 074 Psay SI3->I3_DEB04-SI3->I3_CRE04 Picture "@E 9,999,999.99"
               @ Prow()   , 090 Psay SI3->I3_DEB05-SI3->I3_CRE05 Picture "@E 9,999,999.99"
               @ Prow()   , 107 Psay SI3->I3_DEB06-SI3->I3_CRE06 Picture "@E 9,999,999.99"
  		         @ Prow()   , 124 Psay SI3->I3_DEB07-SI3->I3_CRE07 Picture "@E 9,999,999.99"
      	      @ Prow()   , 141 Psay SI3->I3_DEB08-SI3->I3_CRE08 Picture "@E 9,999,999.99"
         	   @ Prow()   , 158 Psay SI3->I3_DEB09-SI3->I3_CRE09 Picture "@E 9,999,999.99"
	            @ Prow()   , 175 Psay SI3->I3_DEB10-SI3->I3_CRE10 Picture "@E 9,999,999.99"
   	         @ Prow()   , 192 Psay SI3->I3_DEB11-SI3->I3_CRE11 Picture "@E 9,999,999.99"
      	      @ Prow()   , 209 Psay SI3->I3_DEB12-SI3->I3_CRE12 Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 023 Psay SI3->I3_DEB13-SI3->I3_CRE13 Picture "@E 9,999,999.99"
               @ Prow()   , 040 Psay SI3->I3_DEB14-SI3->I3_CRE14 Picture "@E 9,999,999.99"
               @ Prow()   , 057 Psay SI3->I3_DEB15-SI3->I3_CRE15 Picture "@E 9,999,999.99"
               @ Prow()   , 074 Psay SI3->I3_DEB16-SI3->I3_CRE16 Picture "@E 9,999,999.99"
               @ Prow()   , 090 Psay SI3->I3_DEB17-SI3->I3_CRE17 Picture "@E 9,999,999.99" 

	            @ Prow()   , 107 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 124 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 141 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 158 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 175 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 192 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 209 Psay 0 Picture "@E 9,999,999.99"
               
            Endif

            // Impressao das Diferencas
            @ Prow()+01, 006 Psay "Diferencas"
            If mv_par01 == GetMv("MV_EXERC1")
               @ Prow()   , 023 Psay (SI3->I3_DEB01-SI3->I3_CRE01)- TIA->IA_VLORC01 Picture "@E 9,999,999.99"
               @ Prow()   , 040 Psay (SI3->I3_DEB02-SI3->I3_CRE02) - TIA->IA_VLORC02 Picture "@E 9,999,999.99"
               @ Prow()   , 057 Psay (SI3->I3_DEB03-SI3->I3_CRE03) - TIA->IA_VLORC03 Picture "@E 9,999,999.99"
               @ Prow()   , 074 Psay (SI3->I3_DEB04-SI3->I3_CRE04) - TIA->IA_VLORC04 Picture "@E 9,999,999.99"
               @ Prow()   , 090 Psay (SI3->I3_DEB05-SI3->I3_CRE05) - TIA->IA_VLORC05 Picture "@E 9,999,999.99"

	            @ Prow()   , 107 Psay (SI3->I3_DEB06-SI3->I3_CRE06) - TIA->IA_VLORC06 Picture "@E 9,999,999.99"
	            @ Prow()   , 124 Psay (SI3->I3_DEB07-SI3->I3_CRE07) - TIA->IA_VLORC07 Picture "@E 9,999,999.99"
	            @ Prow()   , 141 Psay (SI3->I3_DEB08-SI3->I3_CRE08) - TIA->IA_VLORC08 Picture "@E 9,999,999.99"
	            @ Prow()   , 158 Psay (SI3->I3_DEB09-SI3->I3_CRE09) - TIA->IA_VLORC09 Picture "@E 9,999,999.99"
	            @ Prow()   , 175 Psay (SI3->I3_DEB10-SI3->I3_CRE10) - TIA->IA_VLORC10 Picture "@E 9,999,999.99"
	            @ Prow()   , 192 Psay (SI3->I3_DEB11-SI3->I3_CRE11) - TIA->IA_VLORC11 Picture "@E 9,999,999.99"
	            @ Prow()   , 209 Psay (SI3->I3_DEB12-SI3->I3_CRE12) - TIA->IA_VLORC12 Picture "@E 9,999,999.99"

            Else
               @ Prow()   , 023 Psay (SI3->I3_DEB13-SI3->I3_CRE13) - TIA->IA_VLORC01 Picture "@E 9,999,999.99"
               @ Prow()   , 050 Psay (SI3->I3_DEB14-SI3->I3_CRE14) - TIA->IA_VLORC02 Picture "@E 9,999,999.99"
               @ Prow()   , 067 Psay (SI3->I3_DEB15-SI3->I3_CRE15) - TIA->IA_VLORC03 Picture "@E 9,999,999.99"
               @ Prow()   , 084 Psay (SI3->I3_DEB16-SI3->I3_CRE16) - TIA->IA_VLORC04 Picture "@E 9,999,999.99"
               @ Prow()   , 100 Psay (SI3->I3_DEB17-SI3->I3_CRE17) - TIA->IA_VLORC05 Picture "@E 9,999,999.99"

	            @ Prow()   , 107 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 124 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 141 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 158 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 175 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 192 Psay 0 Picture "@E 9,999,999.99"
	            @ Prow()   , 209 Psay 0 Picture "@E 9,999,999.99"

            Endif

            // Impressao das Variacoes Percentuais
            @ Prow()+01, 006 Psay "Variacoes Perc."
            
            If mv_par01 == GetMv("MV_EXERC1")
               If TIA->IA_VLORC01 <> 0.00
                  @ Prow()   , 023 Psay (((SI3->I3_DEB01-SI3->I3_CRE01) / TIA->IA_VLORC01) - 1) * 100 Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 029 Psay "------"
               Endif
               If TIA->IA_VLORC02 <> 0.00
                  @ Prow()   , 040 Psay (((SI3->I3_DEB02-SI3->I3_CRE02) / TIA->IA_VLORC02) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 044 Psay "------"
               Endif
               If TIA->IA_VLORC03 <> 0.00
                  @ Prow()   , 057 Psay (((SI3->I3_DEB03-SI3->I3_CRE03) / TIA->IA_VLORC03) - 1) * 100 Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 065 Psay "------"
               Endif
               If TIA->IA_VLORC04 <> 0.00
                  @ Prow()   , 074 Psay (((SI3->I3_DEB04-SI3->I3_CRE04) / TIA->IA_VLORC04) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 082 Psay "------"
               Endif
               If TIA->IA_VLORC05 <> 0.00
                  @ Prow()   , 090 Psay (((SI3->I3_DEB05-SI3->I3_CRE05) / TIA->IA_VLORC05) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 100 Psay "------"
               Endif
            
	            If TIA->IA_VLORC06 <> 0.00
	               @ Prow()   , 107 Psay (((SI3->I3_DEB06-SI3->I3_CRE06) / TIA->IA_VLORC06) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 116 Psay "------"
	            Endif
	            If TIA->IA_VLORC07 <> 0.00
	               @ Prow()   , 124 Psay (((SI3->I3_DEB07-SI3->I3_CRE07) / TIA->IA_VLORC07) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 133 Psay "------"
	            Endif
	            If TIA->IA_VLORC08 <> 0.00
	               @ Prow()   , 141 Psay (((SI3->I3_DEB08-SI3->I3_CRE08) / TIA->IA_VLORC08) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 149 Psay "------"
	            Endif
	            If TIA->IA_VLORC09 <> 0.00
	               @ Prow()   , 158 Psay (((SI3->I3_DEB09-SI3->I3_CRE09) / TIA->IA_VLORC09) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 164 Psay "------"
	            Endif
	            If TIA->IA_VLORC10 <> 0.00
	               @ Prow()   , 175 Psay (((SI3->I3_DEB10-SI3->I3_CRE10) / TIA->IA_VLORC10) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 184 Psay "------"
	            Endif
	            If TIA->IA_VLORC11 <> 0.00
	               @ Prow()   , 192 Psay (((SI3->I3_DEB11-SI3->I3_CRE11) / TIA->IA_VLORC11) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 200 Psay "------"
	            Endif
	            If TIA->IA_VLORC12 <> 0.00
	               @ Prow()   , 209 Psay (((SI3->I3_DEB12-SI3->I3_CRE12) / TIA->IA_VLORC12) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 217 Psay "------"
	            Endif
	            
	            
            Else                           
            
               If TIA->IA_VLORC01 <> 0.00
                  @ Prow()   , 023 Psay (((SI3->I3_DEB13-SI3->I3_CRE13) / TIA->IA_VLORC01) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 029 Psay "------"
               Endif
               If TIA->IA_VLORC02 <> 0.00
                  @ Prow()   , 040 Psay (((SI3->I3_DEB14-SI3->I3_CRE14) / TIA->IA_VLORC02) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 044 Psay "------"
               Endif
               If TIA->IA_VLORC03 <> 0.00
                  @ Prow()   , 057 Psay (((SI3->I3_DEB15-SI3->I3_CRE15) / TIA->IA_VLORC03) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 065 Psay "------"
               Endif
               If TIA->IA_VLORC04 <> 0.00
                  @ Prow()   , 074 Psay (((SI3->I3_DEB16-SI3->I3_CRE16) / TIA->IA_VLORC04) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 082 Psay "------"
               EndIf
               If TIA->IA_VLORC05 <> 0.00
                  @ Prow()   , 090 Psay (((SI3->I3_DEB17-SI3->I3_CRE17) / TIA->IA_VLORC05) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 100 Psay "------"
               EndIf                            
               
	            If TIA->IA_VLORC06 <> 0.00
	               @ Prow()   , 107 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 116 Psay "------"
	            Endif
	            If TIA->IA_VLORC07 <> 0.00
	               @ Prow()   , 124 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 133 Psay "------"
	            Endif
	            If TIA->IA_VLORC08 <> 0.00
	               @ Prow()   , 141 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 149 Psay "------"
	            Endif
	            If TIA->IA_VLORC09 <> 0.00
	               @ Prow()   , 158 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 164 Psay "------"
	            Endif
	            If TIA->IA_VLORC10 <> 0.00
	               @ Prow()   , 175 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 184 Psay "------"
	            Endif
	            If TIA->IA_VLORC11 <> 0.00
	               @ Prow()   , 192 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 200 Psay "------"
	            Endif
	            If TIA->IA_VLORC12 <> 0.00
	               @ Prow()   , 209 Psay ((0) - 1) * 100  Picture "@E 9,999,999.99"
	            Else
	               @ Prow()   , 217 Psay "------"
	            Endif
       
            Endif
             
            
         Else // Nao achou conta contabil
            @ Prow()+01, 001 Psay Alltrim(TIA->IA_CC) + "/" + AllTrim(TIA->IA_CONTA) + " - " + _cDescCC

            //Impressao dos valores originais
            @ Prow()+01, 006 Psay "Original"
            @ Prow()   , 023 Psay TIA->IA_VLORC01 Picture "@E 9,999,999.99"
            @ Prow()   , 040 Psay TIA->IA_VLORC02 Picture "@E 9,999,999.99"
            @ Prow()   , 057 Psay TIA->IA_VLORC03 Picture "@E 9,999,999.99"
            @ Prow()   , 074 Psay TIA->IA_VLORC04 Picture "@E 9,999,999.99"
            @ Prow()   , 090 Psay TIA->IA_VLORC05 Picture "@E 9,999,999.99"
            @ Prow()   , 107 Psay TIA->IA_VLORC06 Picture "@E 9,999,999.99"
            @ Prow()   , 124 Psay TIA->IA_VLORC07 Picture "@E 9,999,999.99"
            @ Prow()   , 141 Psay TIA->IA_VLORC08 Picture "@E 9,999,999.99"
            @ Prow()   , 158 Psay TIA->IA_VLORC09 Picture "@E 9,999,999.99"
            @ Prow()   , 175 Psay TIA->IA_VLORC10 Picture "@E 9,999,999.99"
            @ Prow()   , 192 Psay TIA->IA_VLORC11 Picture "@E 9,999,999.99"
            @ Prow()   , 209 Psay TIA->IA_VLORC12 Picture "@E 9,999,999.99"

            //Impressao dos valores Realizados
            _nZero := 0.00
            @ Prow()+01, 006 Psay "Realizado"
            If mv_par01 == GetMv("MV_EXERC1")
               @ Prow()   , 023 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 040 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 057 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 074 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 090 Psay _nZero Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 023 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 040 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 057 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 074 Psay _nZero Picture "@E 9,999,999.99"
               @ Prow()   , 090 Psay _nZero Picture "@E 9,999,999.99"
            Endif
            @ Prow()   , 107 Psay _nZero Picture "@E 9,999,999.99"
            @ Prow()   , 124 Psay _nZero Picture "@E 9,999,999.99"
            @ Prow()   , 141 Psay _nZero Picture "@E 9,999,999.99"
            @ Prow()   , 158 Psay _nZero Picture "@E 9,999,999.99"
            @ Prow()   , 175 Psay _nZero Picture "@E 9,999,999.99"
            @ Prow()   , 192 Psay _nZero Picture "@E 9,999,999.99"
            @ Prow()   , 209 Psay _nZero Picture "@E 9,999,999.99"

            // Impressao das Diferencas
            @ Prow()+01, 006 Psay "Diferencas"
            If mv_par01 == GetMv("MV_EXERC1")
               @ Prow()   , 023 Psay _nZero - TIA->IA_VLORC01 Picture "@E 9,999,999.99"
               @ Prow()   , 040 Psay _nZero - TIA->IA_VLORC02 Picture "@E 9,999,999.99"
               @ Prow()   , 057 Psay _nZero - TIA->IA_VLORC03 Picture "@E 9,999,999.99"
               @ Prow()   , 074 Psay _nZero - TIA->IA_VLORC04 Picture "@E 9,999,999.99"
               @ Prow()   , 090 Psay _nZero - TIA->IA_VLORC05 Picture "@E 9,999,999.99"
               @ Prow()   , 107 Psay _nZero - TIA->IA_VLORC06 Picture "@E 9,999,999.99"
	            @ Prow()   , 124 Psay _nZero - TIA->IA_VLORC07 Picture "@E 9,999,999.99"
	            @ Prow()   , 141 Psay _nZero - TIA->IA_VLORC08 Picture "@E 9,999,999.99"
	            @ Prow()   , 158 Psay _nZero - TIA->IA_VLORC09 Picture "@E 9,999,999.99"
	            @ Prow()   , 175 Psay _nZero - TIA->IA_VLORC10 Picture "@E 9,999,999.99"
	            @ Prow()   , 192 Psay _nZero - TIA->IA_VLORC11 Picture "@E 9,999,999.99"
	            @ Prow()   , 209 Psay _nZero - TIA->IA_VLORC12 Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 023 Psay _nZero - TIA->IA_VLORC01 Picture "@E 9,999,999.99"
               @ Prow()   , 050 Psay _nZero - TIA->IA_VLORC02 Picture "@E 9,999,999.99"
               @ Prow()   , 067 Psay _nZero - TIA->IA_VLORC03 Picture "@E 9,999,999.99"
               @ Prow()   , 084 Psay _nZero - TIA->IA_VLORC04 Picture "@E 9,999,999.99"
               @ Prow()   , 100 Psay _nZero - TIA->IA_VLORC05 Picture "@E 9,999,999.99"
            Endif

            // Impressao das Variacoes Percentuais
            @ Prow()+01, 006 Psay "Variacoes Perc."
            If mv_par01 == GetMv("MV_EXERC1")
               If TIA->IA_VLORC01 <> 0.00
                  @ Prow()   , 023 Psay ((_nZero / TIA->IA_VLORC01) - 1) * 100 Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 029 Psay "------"
               Endif
               If TIA->IA_VLORC02 <> 0.00
                  @ Prow()   , 040 Psay ((_nZero / TIA->IA_VLORC02) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 044 Psay "------"
               Endif
               If TIA->IA_VLORC03 <> 0.00
                  @ Prow()   , 057 Psay ((_nZero / TIA->IA_VLORC03) - 1) * 100 Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 065 Psay "------"
               Endif
               If TIA->IA_VLORC04 <> 0.00
                  @ Prow()   , 074 Psay ((_nZero / TIA->IA_VLORC04) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 082 Psay "------"
               Endif
               If TIA->IA_VLORC05 <> 0.00
                  @ Prow()   , 090 Psay ((_nZero / TIA->IA_VLORC05) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 100 Psay "------"
               Endif
            Else
               If TIA->IA_VLORC01 <> 0.00
                  @ Prow()   , 023 Psay ((_nZero / TIA->IA_VLORC01) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 029 Psay "------"
               Endif
               If TIA->IA_VLORC02 <> 0.00
                  @ Prow()   , 040 Psay ((_nZero / TIA->IA_VLORC02) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 044 Psay "------"
               Endif
               If TIA->IA_VLORC03 <> 0.00
                  @ Prow()   , 057 Psay ((_nZero / TIA->IA_VLORC03) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 065 Psay "------"
               Endif
               If TIA->IA_VLORC04 <> 0.00
                  @ Prow()   , 074 Psay ((_nZero / TIA->IA_VLORC04) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 082 Psay "------"
               EndIf
               If TIA->IA_VLORC05 <> 0.00
                  @ Prow()   , 090 Psay ((_nZero / TIA->IA_VLORC05) - 1) * 100  Picture "@E 9,999,999.99"
               Else
                  @ Prow()   , 100 Psay "------"
               EndIf
            Endif

            If TIA->IA_VLORC06 <> 0.00
               @ Prow()   , 107 Psay ((_nZero / TIA->IA_VLORC06) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 116 Psay "------"
            Endif
            If TIA->IA_VLORC07 <> 0.00
               @ Prow()   , 124 Psay ((_nZero / TIA->IA_VLORC07) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 133 Psay "------"
            Endif
            If TIA->IA_VLORC08 <> 0.00
               @ Prow()   , 141 Psay ((_nZero / TIA->IA_VLORC08) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 149 Psay "------"
            Endif
            If TIA->IA_VLORC09 <> 0.00
               @ Prow()   , 158 Psay ((_nZero / TIA->IA_VLORC09) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 164 Psay "------"
            Endif
            If TIA->IA_VLORC10 <> 0.00
               @ Prow()   , 175 Psay ((_nZero / TIA->IA_VLORC10) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 184 Psay "------"
            Endif
            If TIA->IA_VLORC11 <> 0.00
               @ Prow()   , 192 Psay ((_nZero / TIA->IA_VLORC11) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 200 Psay "------"
            Endif
            If TIA->IA_VLORC12 <> 0.00
               @ Prow()   , 209 Psay ((_nZero / TIA->IA_VLORC12) - 1) * 100  Picture "@E 9,999,999.99"
            Else
               @ Prow()   , 217 Psay "------"
            Endif

         Endif // Do Seek do Centro de Custo e Conta Contabil

         // Soma dos valores Originais por centro de custo
         _nValJanOr := _nValJanOr + TIA->IA_VLORC01
         _nValFevOr := _nValFevOr + TIA->IA_VLORC02
         _nValmarOr := _nValmarOr + TIA->IA_VLORC03
         _nValAbrOr := _nValAbrOr + TIA->IA_VLORC04
         _nValMaiOr := _nValMaiOr + TIA->IA_VLORC05
         _nValJunOr := _nValJunOr + TIA->IA_VLORC06
         _nValJulOr := _nValJulOr + TIA->IA_VLORC07
         _nValAgoOr := _nValAgoOr + TIA->IA_VLORC08
         _nValSetOr := _nValSetOr + TIA->IA_VLORC09
         _nValOutOr := _nValOutOr + TIA->IA_VLORC10
         _nValNovOr := _nValNovOr + TIA->IA_VLORC11
         _nValDezOr := _nValDezOr + TIA->IA_VLORC12

         // Soma dos valores Gerais Originais por centro de custo
         _nGerJanOr := _nGerJanOr + TIA->IA_VLORC01
         _nGerFevOr := _nGerFevOr + TIA->IA_VLORC02
         _nGerMarOr := _nGerMarOr + TIA->IA_VLORC03
         _nGerAbrOr := _nGerAbrOr + TIA->IA_VLORC04
         _nGerMaiOr := _nGerMaiOr + TIA->IA_VLORC05
         _nGerJunOr := _nGerJunOr + TIA->IA_VLORC06
         _nGerJulOr := _nGerJulOr + TIA->IA_VLORC07
         _nGerAgoOr := _nGerAgoOr + TIA->IA_VLORC08
         _nGerSetOr := _nGerSetOr + TIA->IA_VLORC09
         _nGerOutOr := _nGerOutOr + TIA->IA_VLORC10
         _nGerNovOr := _nGerNovOr + TIA->IA_VLORC11
         _nGerDezOr := _nGerDezOr + TIA->IA_VLORC12
         
         // Soma dos valores Gerais Reais
         If mv_par01 == GetMv("MV_EXERC1")
            _nGerJanRe := _nGerJanRe + SI3->I3_DEB01
            _nGerFevRe := _nGerFevRe + SI3->I3_DEB02
            _nGerMarRe := _nGerMarRe + SI3->I3_DEB03
            _nGerAbrRe := _nGerAbrRe + SI3->I3_DEB04
            _nGerMaiRe := _nGerMaiRe + SI3->I3_DEB05
	         _nGerJunRe := _nGerJunRe + SI3->I3_DEB06
	         _nGerJulRe := _nGerJulRe + SI3->I3_DEB07
	         _nGerAgoRe := _nGerAgoRe + SI3->I3_DEB08
	         _nGerSetRe := _nGerSetRe + SI3->I3_DEB09
	         _nGerOutRe := _nGerOutRe + SI3->I3_DEB10
	         _nGerNovRe := _nGerNovRe + SI3->I3_DEB11
	         _nGerDezRe := _nGerDezRe + SI3->I3_DEB12

         Else
            _nGerJanRe := _nGerJanRe + SI3->I3_DEB13
            _nGerFevRe := _nGerFevRe + SI3->I3_DEB14
            _nGerMarRe := _nGerMarRe + SI3->I3_DEB15
            _nGerAbrRe := _nGerAbrRe + SI3->I3_DEB16
            _nGerMaiRe := _nGerMaiRe + SI3->I3_DEB17
         Endif

         // Soma dos valores Reais por centro de custo
         If mv_par01 == GetMv("MV_EXERC1")
            _nValJanRe := _nValJanRe + SI3->I3_DEB01
            _nValFevRe := _nValFevRe + SI3->I3_DEB02
            _nValMarRe := _nValMarRe + SI3->I3_DEB03
            _nValAbrRe := _nValAbrRe + SI3->I3_DEB04
            _nValMaiRe := _nValMaiRe + SI3->I3_DEB05
	         _nValJunRe := _nValJunRe + SI3->I3_DEB06
	         _nValJulRe := _nValJulRe + SI3->I3_DEB07
	         _nValAgoRe := _nValAgoRe + SI3->I3_DEB08
	         _nValSetRe := _nValSetRe + SI3->I3_DEB09
	         _nValOutRe := _nValOutRe + SI3->I3_DEB10
	         _nValNovRe := _nValNovRe + SI3->I3_DEB11
	         _nValDezRe := _nValDezRe + SI3->I3_DEB12

         Else
            _nValJanRe := _nValJanRe + SI3->I3_DEB13
            _nValFevRe := _nValFevRe + SI3->I3_DEB14
            _nValmarRe := _nValmarRe + SI3->I3_DEB15
            _nValAbrRe := _nValAbrRe + SI3->I3_DEB16
            _nValMaiRe := _nValMaiRe + SI3->I3_DEB17
         Endif

         TIA->(DbSkip())
   EndDo

   // Somar os Centro de Custo Orcados
   @ Prow()+02, 006 Psay "Total Original"
   @ Prow()   , 023 Psay _nValJanOr Picture "@E 9,999,999.99"
   @ Prow()   , 040 Psay _nValFevOr Picture "@E 9,999,999.99"
   @ Prow()   , 057 Psay _nValMarOr Picture "@E 9,999,999.99"
   @ Prow()   , 074 Psay _nValAbrOr Picture "@E 9,999,999.99"
   @ Prow()   , 090 Psay _nValMaiOr Picture "@E 9,999,999.99"
   @ Prow()   , 107 Psay _nValJunOr Picture "@E 9,999,999.99"
   @ Prow()   , 124 Psay _nValJulOr Picture "@E 9,999,999.99"
   @ Prow()   , 141 Psay _nValAgoOr Picture "@E 9,999,999.99"
   @ Prow()   , 158 Psay _nValSetOr Picture "@E 9,999,999.99"
   @ Prow()   , 175 Psay _nValOutOr Picture "@E 9,999,999.99"
   @ Prow()   , 192 Psay _nValNovOr Picture "@E 9,999,999.99"
   @ Prow()   , 209 Psay _nValDezOr Picture "@E 9,999,999.99"

   // Somar os Centro de Custo Reais
   @ Prow()+01, 006 Psay "Total Real"
   @ Prow()   , 023 Psay _nValJanRe Picture "@E 9,999,999.99"
   @ Prow()   , 040 Psay _nValFevRe Picture "@E 9,999,999.99"
   @ Prow()   , 057 Psay _nValMarRe Picture "@E 9,999,999.99"
   @ Prow()   , 074 Psay _nValAbrRe Picture "@E 9,999,999.99"
   @ Prow()   , 090 Psay _nValMaiRe Picture "@E 9,999,999.99"
   @ Prow()   , 107 Psay _nValJunRe Picture "@E 9,999,999.99"
   @ Prow()   , 124 Psay _nValJulRe Picture "@E 9,999,999.99"
   @ Prow()   , 141 Psay _nValAgoRe Picture "@E 9,999,999.99"
   @ Prow()   , 158 Psay _nValSetRe Picture "@E 9,999,999.99"
   @ Prow()   , 175 Psay _nValOutRe Picture "@E 9,999,999.99"
   @ Prow()   , 192 Psay _nValNovRe Picture "@E 9,999,999.99"
   @ Prow()   , 209 Psay _nValDezRe Picture "@E 9,999,999.99"

   // Diferencas dos Centros de custo
   @ Prow()+01, 006 Psay "Total Diferencas"
   @ Prow()   , 023 Psay _nValJanRe - _nValJanOr  Picture "@E 9,999,999.99"
   @ Prow()   , 040 Psay _nValFevRe - _nValFevOr  Picture "@E 9,999,999.99"
   @ Prow()   , 057 Psay _nValMarRe - _nValMarOr  Picture "@E 9,999,999.99"
   @ Prow()   , 074 Psay _nValAbrRe - _nValAbrOr  Picture "@E 9,999,999.99"
   @ Prow()   , 090 Psay _nValMaiRe - _nValMaiOr  Picture "@E 9,999,999.99"
   @ Prow()   , 107 Psay _nValJunRe - _nValJunOr  Picture "@E 9,999,999.99"
   @ Prow()   , 124 Psay _nValJulRe - _nValJulOr  Picture "@E 9,999,999.99"
   @ Prow()   , 141 Psay _nValAgoRe - _nValAgoOr  Picture "@E 9,999,999.99"
   @ Prow()   , 158 Psay _nValSetRe - _nValSetOr  Picture "@E 9,999,999.99"
   @ Prow()   , 175 Psay _nValOutRe - _nValOutOr  Picture "@E 9,999,999.99"
   @ Prow()   , 192 Psay _nValNovRe - _nValNovOr  Picture "@E 9,999,999.99"
   @ Prow()   , 209 Psay _nValDezRe - _nValDezOr  Picture "@E 9,999,999.99"

   // Somar as Variacoes Percentuais
   @ Prow()+01, 006 Psay "Variacoes Perc."
   If _nValJanOr <> 0.00
      @ Prow()   , 023 Psay ((_nValJanRe / _nValJanOr) - 1) * 100 Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 029 Psay "------"
   Endif
   If _nValFevOr <> 0.00
       @ Prow()   , 040 Psay ((_nValFevRe / _nValFevOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
       @ Prow()   , 044 Psay "------"
   Endif
   If _nValMarOr <> 0.00
       @ Prow()   , 057 Psay ((_nValMarRe / _nValMarOr) - 1) * 100 Picture "@E 9,999,999.99"
   Else
       @ Prow()   , 065 Psay "------"
   Endif
   If _nValAbrOr <> 0.00
      @ Prow()   , 074 Psay ((_nValAbrRe / _nValAbrOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 082 Psay "------"
   Endif
   If _nValMaiOr <> 0.00
      @ Prow()   , 090 Psay ((_nValMaiRe / _nValMaiOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 100 Psay "------"
   Endif
   If _nValjunOr <> 0.00
      @ Prow()   , 107 Psay ((_nValJunRe / _nValjunOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 116 Psay "------"
   Endif
   If _nValJulOr <> 0.00
      @ Prow()   , 124 Psay ((_nValJulRe / _nValJulOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 133 Psay "------"
   Endif
   If _nValAgoOr <> 0.00
      @ Prow()   , 141 Psay ((_nValAgoRe / _nValAgoOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 149 Psay "------"
   Endif
   If _nValSetOr <> 0.00
      @ Prow()   , 158 Psay ((_nValSetRe / _nValSetOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 164 Psay "------"
   Endif
   If _nValOutOr <> 0.00
      @ Prow()   , 175 Psay ((_nValOutRe / _nValOutOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 184 Psay "------"
   Endif
   If _nValNovOr <> 0.00
      @ Prow()   , 192 Psay ((_nValNovRe / _nValNovOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 200 Psay "------"
   Endif
   If _nValDezOr <> 0.00
      @ Prow()   , 209 Psay ((_nValDezRe / _nValDezOr) - 1) * 100  Picture "@E 9,999,999.99"
   Else
      @ Prow()   , 215 Psay "------"
   Endif
   @ prow()+1 , 000 Psay Repli("-",221)
      
   If pRow() > 63 
      If lPrimeiro == .F.
         Eject
         nPag := nPag + 1
      Endif
      lPrimeiro := .f.
      Cabecalho()
   Endif
Enddo

// Imprimir totais gerais
               
If pRow() > 63 
   If lPrimeiro == .F.
      Eject
      nPag := nPag + 1
   Endif
   lPrimeiro := .f.
   Cabecalho()
Endif

// Somar os Centro de Custo Orcados
@ Prow()+02, 006 Psay "Geral Original"
@ Prow()   , 023 Psay _nGerJanOr Picture "@E 9,999,999.99"
@ Prow()   , 040 Psay _nGerFevOr Picture "@E 9,999,999.99"
@ Prow()   , 057 Psay _nGerMarOr Picture "@E 9,999,999.99"
@ Prow()   , 074 Psay _nGerAbrOr Picture "@E 9,999,999.99"
@ Prow()   , 090 Psay _nGerMaiOr Picture "@E 9,999,999.99"
@ Prow()   , 107 Psay _nGerJunOr Picture "@E 9,999,999.99"
@ Prow()   , 124 Psay _nGerJulOr Picture "@E 9,999,999.99"
@ Prow()   , 141 Psay _nGerAgoOr Picture "@E 9,999,999.99"
@ Prow()   , 158 Psay _nGerSetOr Picture "@E 9,999,999.99"
@ Prow()   , 175 Psay _nGerOutOr Picture "@E 9,999,999.99"
@ Prow()   , 192 Psay _nGerNovOr Picture "@E 9,999,999.99"
@ Prow()   , 209 Psay _nGerDezOr Picture "@E 9,999,999.99"

// Somar os Centro de Custo Reais
@ Prow()+01, 006 Psay "Geral Real"
@ Prow()   , 023 Psay _nGerJanRe Picture "@E 9,999,999.99"
@ Prow()   , 040 Psay _nGerFevRe Picture "@E 9,999,999.99"
@ Prow()   , 057 Psay _nGerMarRe Picture "@E 9,999,999.99"
@ Prow()   , 074 Psay _nGerAbrRe Picture "@E 9,999,999.99"
@ Prow()   , 090 Psay _nGerMaiRe Picture "@E 9,999,999.99"
@ Prow()   , 107 Psay _nGerJunRe Picture "@E 9,999,999.99"
@ Prow()   , 124 Psay _nGerJulRe Picture "@E 9,999,999.99"
@ Prow()   , 141 Psay _nGerAgoRe Picture "@E 9,999,999.99"
@ Prow()   , 158 Psay _nGerSetRe Picture "@E 9,999,999.99"
@ Prow()   , 175 Psay _nGerOutRe Picture "@E 9,999,999.99"
@ Prow()   , 192 Psay _nGerNovRe Picture "@E 9,999,999.99"
@ Prow()   , 209 Psay _nGerDezRe Picture "@E 9,999,999.99"

// Diferencas Gerais dos Centros de custo
@ Prow()+01, 006 Psay "Geral Diferencas"
@ Prow()   , 023 Psay _nGerJanRe - _nGerJanOr  Picture "@E 9,999,999.99"
@ Prow()   , 040 Psay _nGerFevRe - _nGerFevOr  Picture "@E 9,999,999.99"
@ Prow()   , 057 Psay _nGerMarRe - _nGerMarOr  Picture "@E 9,999,999.99"
@ Prow()   , 074 Psay _nGerAbrRe - _nGerAbrOr  Picture "@E 9,999,999.99"
@ Prow()   , 090 Psay _nGerMaiRe - _nGerMaiOr  Picture "@E 9,999,999.99"
@ Prow()   , 107 Psay _nGerJunRe - _nGerJunOr  Picture "@E 9,999,999.99"
@ Prow()   , 124 Psay _nGerJulRe - _nGerJulOr  Picture "@E 9,999,999.99"
@ Prow()   , 141 Psay _nGerAgoRe - _nGerAgoOr  Picture "@E 9,999,999.99"
@ Prow()   , 158 Psay _nGerSetRe - _nGerSetOr  Picture "@E 9,999,999.99"
@ Prow()   , 175 Psay _nGerOutRe - _nGerOutOr  Picture "@E 9,999,999.99"
@ Prow()   , 192 Psay _nGerNovRe - _nGerNovOr  Picture "@E 9,999,999.99"
@ Prow()   , 209 Psay _nGerDezRe - _nGerDezOr  Picture "@E 9,999,999.99"

// Somar as Variacoes Percentuais
@ Prow()+01, 006 Psay "Variacoes Perc."
If _nGerJanOr <> 0.00
   @ Prow()   , 023 Psay ((_nGerJanRe / _nGerJanOr) - 1) * 100 Picture "@E 9,999,999.99"
Else
   @ Prow()   , 029 Psay "------"
Endif
If _nGerFevOr <> 0.00
   @ Prow()   , 040 Psay ((_nGerFevRe / _nGerFevOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
   @ Prow()   , 044 Psay "------"
Endif
If _nGerMarOr <> 0.00
   @ Prow()   , 057 Psay ((_nGerMarRe / _nGerMarOr) - 1) * 100 Picture "@E 9,999,999.99"
Else
   @ Prow()   , 065 Psay "------"
Endif
If _nGerAbrOr <> 0.00
   @ Prow()   , 074 Psay ((_nGerAbrRe / _nGerAbrOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
  @ Prow()   , 082 Psay "------"
Endif
If _nGerMaiOr <> 0.00
   @ Prow()   , 090 Psay ((_nGerMaiRe / _nGerMaiOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
   @ Prow()   , 098 Psay "------"
Endif
If _nGerjunOr <> 0.00
   @ Prow()   , 107 Psay ((_nGerJunRe / _nGerjunOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
   @ Prow()   , 113 Psay "------"
Endif
If _nGerJulOr <> 0.00
   @ Prow()   , 124 Psay ((_nGerJulRe / _nGerJulOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
   @ Prow()   , 130 Psay "------"
Endif
If _nGerAgoOr <> 0.00
   @ Prow()   , 141 Psay ((_nGerAgoRe / _nGerAgoOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
   @ Prow()   , 147 Psay "------"
Endif
If _nGerSetOr <> 0.00
   @ Prow()   , 158 Psay ((_nGerSetRe / _nGerSetOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
   @ Prow()   , 164 Psay "------"
Endif
If _nGerOutOr <> 0.00
   @ Prow()   , 175 Psay ((_nGerOutRe / _nGerOutOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
  @ Prow()   , 181 Psay "------"
Endif
If _nGerNovOr <> 0.00
   @ Prow()   , 192 Psay ((_nGerNovRe / _nGerNovOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
  @ Prow()   , 198 Psay "------"
Endif
If _nGerDezOr <> 0.00
   @ Prow()   , 209 Psay ((_nGerDezRe / _nGerDezOr) - 1) * 100  Picture "@E 9,999,999.99"
Else
  @ Prow()   , 215 Psay "------"
Endif

If aReturn[5] == 1
   Set Printer To
   Commit
   Ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Cabecalho()

cabec2 := " C.CUSTO+CONTA              JANEIRO        FEVEREIRO            MARCO            ABRIL            MAIO            JUNHO            JULHO           AGOSTO         SETEMBRO          OUTUBRO         NOVEMBRO         DEZEMBRO"

// @ prow()+1,00 Psay &cCompac+Repli("*",132)
@ prow()+1,00 Psay "*"+SM0->M0_NOMECOM
@ prow(),200  Psay "Folha : "                                                                                                    
@ prow(),212  Psay StrZero(nPag,5,0)+"   *"
@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
@ prow(),85   Psay titulo
@ prow(),200  Psay "DT.Ref.: "+Dtoc(dDataBase)+"   *"
@ prow()+1,00 Psay "*Hora...: "+Time()
@ prow(),104  Psay "Ano: " + _cAno
@ prow(),200  Psay "Emissao: "+Dtoc(dDataBase)+"   *"
@ prow()+1,00 Psay Repli("*",221)
@ prow()+1,00 Psay " "
@ prow()+1,00 Psay Replicate("*",221)
@ prow()+1,00 Psay cabec2
@ prow()+1,00 Psay Replicate("*",221)
Return


