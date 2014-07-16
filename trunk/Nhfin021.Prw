/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHFIN021        ³ Jose Roberto Gorski   ³ Data ³ 22.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ImpressÆo do Acerto de Viagem                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"  
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function Nhfin021()   

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="M"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Acerto de Viagem"
cDesc1   := " "
cDesc2   := " "
cDesc3   := " "
cString  := "SZ4"
nTipo    := 0
nomeprog := "NHFIN021"
cPerg    := "NHFI11"
nPag     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Numero Adiantamento                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHFIN021"

SetPrint("SZ4",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

nRos:=SM0->M0_CGC
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
lPrimeiro := .T.
/*/

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TRB")
DbCloseArea("TRB")
MS_FLUSH() //Libera fila de relatorios em spool

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Gerando         ³ Jose Roberto Gorski   ³ Data ³ 19.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gerando a Consulta Padrao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/



Static Function Gerando()
cQuery := "SELECT *  FROM " + RetSqlName( 'SZ4')
cQuery := cQuery + " WHERE Z4_NUM = '" + mv_par01 + "'"
cQuery := cQuery + " AND D_E_L_E_T_ <> '*' "

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Imprime         ³ Jose Roberto Gorski   ³ Data ³ 19.05.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ImpressÆo do Acerto de Viagem                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function Imprime()
Local _cPf := Space(11)

SZ5->(DbSetOrder(1))
SZ5->(DbSeek(xFilial("SZ5")+TRB->Z4_MATR))
If SZ5->(Found())
	_cPf := SZ5->Z5_CPF
Endif

SZ3->(DbSetOrder(1)) // filial + numero da requisicao
SZ3->(DbGoTop())

// Posiciona no Registro correto para informa‡äes de Conta Corrente
SZ3->(DbSeek(xFilial("SZ3")+TRB->Z4_NUM))

@ 001, 043 Psay "***  A T U A L I Z A C A O   D E   V I A G E M  ***"
@ 003, 001 Psay "ADIANTAMENTO: " + TRB->Z4_NUM 
@ 003, 030 Psay "EMPRESA: " + SM0->M0_NOMECOM // TRB->Z4_EMPRESA
@ 003, 060 Psay "ADIATAMENTO: " + Substr(SZ3->Z3_ADTUSR,1,25) + " Data: " + DTOC(SZ3->Z3_ADTDAT) + " Hora: " + SZ3->Z3_ADTHOR


@ 004, 001 Psay "PERIODO:     " + DtoC(StoD(TRB->Z4_DATADE)) + " A " + DtoC(StoD(TRB->Z4_DATAATE))
@ 004, 060 Psay "     ACERTO: " + Substr(SZ3->Z3_ACTUSR,1,25) + " Data: " + DTOC(SZ3->Z3_ACTDAT) + " Hora: " + SZ3->Z3_ACTHOR

@ 005, 001 Psay "DESTINO: " + TRB->Z4_DESTINO
@ 005, 060 Psay " FINANCEIRO: " + Substr(SZ3->Z3_FINUSR,1,25) + " Data: " + DTOC(SZ3->Z3_FINDAT) + " Hora: " + SZ3->Z3_FINHOR


@ 006, 001 Psay "FUNCIONARIO: " + TRB->Z4_MATR + " / " + Alltrim(TRB->Z4_NOME) + " CPF: "+Transform(_Cpf,"@R 999.999.999-99")
@ 008, 001 Psay "BANCO + AGENCIA + CONTA: " + AllTrim(SZ3->Z3_BANCO) +  "/" + AllTrim(SZ3->Z3_AGENCIA) + "/" + AllTrim(SZ3->Z3_CONTA)

@ 010, 001 Psay "MOEDAS"
@ 010, 021 Psay "REAL"
@ 010, 028 Psay "REAL CONV."
@ 010, 045 Psay "DOLAR"
@ 010, 062 Psay "DM"
@ 010, 072 Psay "OUTRAS"
@ 011, 001 Psay "HOTEL"

@ 011, 013 Psay TRB->Z4_HOTELRS Picture "@E 9,999,999.99"
@ 011, 026 Psay TRB->Z4_HOTELCV Picture "@E 9,999,999.99"
@ 011, 038 Psay TRB->Z4_HOTELUS Picture "@E 9,999,999.99"
@ 011, 052 Psay TRB->Z4_HOTELDM Picture "@E 9,999,999.99"
@ 011, 066 Psay TRB->Z4_HOTELOU Picture "@E 9,999,999.99"
@ 012, 001 Psay "REFEICAO"
@ 012, 013 Psay TRB->Z4_REFERS  Picture "@E 9,999,999.99"
@ 012, 026 Psay TRB->Z4_REFECV  Picture "@E 9,999,999.99"
@ 012, 038 Psay TRB->Z4_REFEUS  Picture "@E 9,999,999.99"
@ 012, 052 Psay TRB->Z4_REFEDM  Picture "@E 9,999,999.99"
@ 012, 066 Psay TRB->Z4_REFEOU  Picture "@E 9,999,999.99"
@ 013, 001 Psay "PASSAGEM"
@ 013, 013 Psay TRB->Z4_PASRS   Picture "@E 9,999,999.99"
@ 013, 026 Psay TRB->Z4_PASCV   Picture "@E 9,999,999.99"
@ 013, 038 Psay TRB->Z4_PASUS   Picture "@E 9,999,999.99"
@ 013, 052 Psay TRB->Z4_PASDM   Picture "@E 9,999,999.99"
@ 013, 066 Psay TRB->Z4_PASOU   Picture "@E 9,999,999.99"
@ 014, 001 Psay "COMBUSTIVEL"
@ 014, 013 Psay TRB->Z4_COMBRS  Picture "@E 9,999,999.99"
@ 014, 026 Psay TRB->Z4_COMBCV  Picture "@E 9,999,999.99"
@ 014, 038 Psay TRB->Z4_COMBUS  Picture "@E 9,999,999.99"
@ 014, 052 Psay TRB->Z4_COMBDM  Picture "@E 9,999,999.99"
@ 014, 066 Psay TRB->Z4_COMBOU  Picture "@E 9,999,999.99"
@ 015, 001 Psay "TELEFONE"
@ 015, 013 Psay TRB->Z4_FONERS  Picture "@E 9,999,999.99"
@ 015, 026 Psay TRB->Z4_FONECV  Picture "@E 9,999,999.99"
@ 015, 038 Psay TRB->Z4_FONEUS  Picture "@E 9,999,999.99"
@ 015, 052 Psay TRB->Z4_FONEDM  Picture "@E 9,999,999.99"
@ 015, 066 Psay TRB->Z4_FONEOU  Picture "@E 9,999,999.99"
@ 016, 001 Psay "CONDUCAO"
@ 016, 013 Psay TRB->Z4_CONDRS  Picture "@E 9,999,999.99"
@ 016, 026 Psay TRB->Z4_CONDCV  Picture "@E 9,999,999.99"
@ 016, 038 Psay TRB->Z4_CONDUS  Picture "@E 9,999,999.99"
@ 016, 052 Psay TRB->Z4_CONDDM  Picture "@E 9,999,999.99"
@ 016, 066 Psay TRB->Z4_CONDOU  Picture "@E 9,999,999.99"
@ 017, 001 Psay "OUTR.DESP1"
@ 017, 013 Psay TRB->Z4_OUTRORS Picture "@E 9,999,999.99"
@ 017, 026 Psay TRB->Z4_OUTROCV Picture "@E 9,999,999.99"
@ 017, 038 Psay TRB->Z4_OUTROUS Picture "@E 9,999,999.99"
@ 017, 052 Psay TRB->Z4_OUTRODM Picture "@E 9,999,999.99"
@ 017, 066 Psay TRB->Z4_OUTROOU Picture "@E 9,999,999.99"
@ 018, 001 Psay "OUTR.DESP2"
@ 018, 013 Psay TRB->Z4_OUTR1RS Picture "@E 9,999,999.99"
@ 018, 026 Psay TRB->Z4_OUTR1CV Picture "@E 9,999,999.99"
@ 018, 038 Psay TRB->Z4_OUTR1US Picture "@E 9,999,999.99"
@ 018, 052 Psay TRB->Z4_OUTR1DM Picture "@E 9,999,999.99"
@ 018, 066 Psay TRB->Z4_OUTR1OU Picture "@E 9,999,999.99"
@ 019, 001 Psay "OUTR.DESP3"
@ 019, 013 Psay TRB->Z4_OUTR2RS Picture "@E 9,999,999.99"
@ 019, 026 Psay TRB->Z4_OUTR2CV Picture "@E 9,999,999.99"
@ 019, 038 Psay TRB->Z4_OUTR2US Picture "@E 9,999,999.99"
@ 019, 052 Psay TRB->Z4_OUTR2DM Picture "@E 9,999,999.99"
@ 019, 066 Psay TRB->Z4_OUTR2OU Picture "@E 9,999,999.99"
@ 021, 001 Psay "TOT.DESP."
@ 021, 013 Psay TRB->Z4_DESPRS  Picture "@E 9,999,999.99"
@ 021, 026 Psay TRB->Z4_DESPCV  Picture "@E 9,999,999.99"
@ 021, 038 Psay TRB->Z4_DESPUS  Picture "@E 9,999,999.99"
@ 021, 052 Psay TRB->Z4_DESPDM  Picture "@E 9,999,999.99"
@ 021, 066 Psay TRB->Z4_DESPOU  Picture "@E 9,999,999.99"
@ 022, 001 Psay "TAXAS"
@ 022, 038 Psay TRB->Z4_TAXAUS  Picture "@E 9,999,999.99"
@ 022, 052 Psay TRB->Z4_TAXADM  Picture "@E 9,999,999.99"
@ 022, 066 Psay TRB->Z4_TAXAOU  Picture "@E 9,999,999.99"

//Verifica em qual moeda e o adintamaneto
SZ3->(DbSeek(xFilial("SZ3")+TRB->Z4_NUM))

@ 023, 001 Psay "ADIANT."

If SZ3->Z3_MOEDA == "2"
   @ 023, 038 Psay TRB->Z4_ADIANTA Picture "@E 9,999,999.99"
//   @ 023, 038 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
ElseIf SZ3->Z3_MOEDA == "3"
   @ 023, 052 Psay TRB->Z4_ADIANTA Picture "@E 9,999,999.99"
//   @ 023, 052 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
ElseIf SZ3->Z3_MOEDA == "4"
   @ 023, 066 Psay TRB->Z4_ADIANTA Picture "@E 9,999,999.99"
//   @ 023, 066 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
Else
   @ 023, 013 Psay TRB->Z4_ADIANTA Picture "@E 9,999,999.99"   
Endif

@ 024, 001 Psay "RESTIT."
If SZ3->Z3_MOEDA == "2"
   @ 024, 026 Psay Transform(TRB->Z4_RESTITU * TRB->Z4_TAXAUS,"@E 9,999,999.99")  
   @ 024, 038 Psay TRB->Z4_RESTITU Picture "@E 9,999,999.99"
//   @ 023, 038 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
ElseIf SZ3->Z3_MOEDA == "3"                                                         
   @ 024, 026 Psay Transform(TRB->Z4_RESTITU * TRB->Z4_TAXADM,"@E 9,999,999.99")  
   @ 024, 052 Psay TRB->Z4_RESTITU Picture "@E 9,999,999.99"
//   @ 023, 052 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
ElseIf SZ3->Z3_MOEDA == "4"                                   
   @ 024, 026 Psay Transform(TRB->Z4_RESTITU * TRB->Z4_TAXAOU,"@E 9,999,999.99")  
   @ 024, 066 Psay TRB->Z4_RESTITU Picture "@E 9,999,999.99"
//   @ 023, 066 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
Else
   @ 024, 013 Psay TRB->Z4_RESTITU Picture "@E 9,999,999.99"   
Endif

@ 025, 001 Psay "REEMBOLSO"
If SZ3->Z3_MOEDA == "2"
   @ 025, 026 Psay Transform(TRB->Z4_REMB * TRB->Z4_TAXAUS,"@E 9,999,999.99")  
   @ 025, 038 Psay TRB->Z4_REMB Picture "@E 9,999,999.99"
//   @ 023, 038 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
ElseIf SZ3->Z3_MOEDA == "3"                                                         
   @ 025, 026 Psay Transform(TRB->Z4_REMB * TRB->Z4_TAXADM,"@E 9,999,999.99")  
   @ 025, 052 Psay TRB->Z4_REMB Picture "@E 9,999,999.99"
//   @ 023, 052 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
ElseIf SZ3->Z3_MOEDA == "4"                                   
   @ 025, 026 Psay Transform(TRB->Z4_REMB * TRB->Z4_TAXAOU,"@E 9,999,999.99")  
   @ 025, 066 Psay TRB->Z4_REMB Picture "@E 9,999,999.99"
//   @ 023, 066 Psay SZ3->Z3_VALOR   Picture "@E 9,999,999.99"
Else
   @ 025, 013 Psay TRB->Z4_REMB Picture "@E 9,999,999.99"   
Endif

@ 032, 001 Psay "____________________                                        ____________________" 
@ 033, 001 Psay "    ASSINATURA                                                   RESPONSAVEL" 


Return


