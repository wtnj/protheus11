/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHFIN047        ³ Fabio Nico            ³ Data ³ 02/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Viagem FUNCIONARIO X PERIODO                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhfin047()   

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Resumo Acerto de Viagens"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SZ4"
nTipo     := 0
nomeprog  := "NHFIN047"
cPerg     := "NHFI47"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Codigo do Funcionario                           ³
//³ mv_par02     Periodo de                                      ³
//³ mv_par03     Periodo ate                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHFIN047"

SetPrint("SZ3",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")
rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Gerando         ³ Fabio Nico            ³ Data ³ 02/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gerando a Consulta Padrao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Gerando()

cQuery := "SELECT SZ4.Z4_NUM, SZ4.Z4_MATR, SZ4.Z4_NOME, SZ4.Z4_DESTINO, SZ4.Z4_DESPRS, "
cQuery += "SZ4.Z4_ADIANTA, SZ4.Z4_RESTITU, SZ4.Z4_REMB, SZ3.Z3_ADTDAT, SZ3.Z3_ACTDAT, SZ3.Z3_FINDAT "
cQuery += "FROM " + RetSqlName( 'SZ4' ) + " SZ4, " +  RetSqlName( 'SZ3' ) + " SZ3 "
cQuery += "WHERE SZ4.Z4_MATR = SZ3.Z3_MATR "
cQuery += "AND SZ4.Z4_NUM = SZ3.Z3_NUM "
cQuery += "AND SZ4.D_E_L_E_T_ <> '*' "
cQuery += "AND Z3_MATR BETWEEN  '" + Mv_par01 + "' AND '"+ Mv_par02 + "' "
cQuery += "AND SZ3.Z3_ADTDAT BETWEEN '"+ Dtos(Mv_par03) + "' AND '"+ Dtos(Mv_par04) + "' "
cQuery += "AND SZ3.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SZ4.Z4_NUM, SZ4.Z4_MATR, SZ4.Z4_NOME, SZ4.Z4_DESTINO, SZ4.Z4_DESPRS, "
cQuery += "SZ4.Z4_ADIANTA, SZ4.Z4_RESTITU, SZ4.Z4_REMB, SZ3.Z3_ADTDAT, SZ3.Z3_ACTDAT, SZ3.Z3_FINDAT "
cQuery += "ORDER BY SZ3.Z3_ADTDAT"

TCQUERY cQuery NEW ALIAS "TMP"                      
DbSelectArea("TMP")
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Imprime()

TMP->(Dbgotop())
                          
If Empty(TMP->Z4_NUM)
   MsgBox("Nenhum Ocorrencia para este Funcionario","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloserArea()
   Return(.F.)
Endif
Cabec1    := "Matr.   Nome                                      Numero   Dt. Adto.     Valor Adto.           Destino                           Dt.Acerto        Tot.Desp           Reembolso         Restituicao   Acerto Fin."
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo) 
While !TMP->(eof())    

   If Mv_Par05 = 1 .and. STOD(TMP->Z3_FINDAT) <> Ctod(Space(08))
		TMP->(Dbskip())   
		Loop
   Endif		
   
   If Mv_Par05 = 2 .and. STOD(TMP->Z3_FINDAT) == Ctod(Space(08))
		TMP->(Dbskip())   
		Loop
   Endif

   If Prow() > 56
      nPag := nPag + 1
      Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
   Endif         
   @ Prow() + 1, 000 Psay TMP->Z4_MATR
   @ Prow()    , 008 Psay TMP->Z4_NOME
   @ Prow()    , 050 Psay TMP->Z4_NUM
   @ Prow()    , 060 Psay STOD(TMP->Z3_ADTDAT)
   @ Prow()    , 074 Psay TMP->Z4_ADIANTA    picture "@E 999,999.99"
   @ Prow()    , 095 Psay TMP->Z4_DESTINO
   @ Prow()    , 130 Psay STOD(TMP->Z3_ACTDAT)
   @ Prow()    , 144 Psay TMP->Z4_DESPRS     Picture "@E 999,999.99"
   @ Prow()    , 164 Psay TMP->Z4_RESTITU    Picture "@E 999,999.99"
   @ Prow()    , 184 Psay TMP->Z4_REMB       Picture "@E 999,999.99"
   @ Prow()    , 200 Psay STOD(TMP->Z3_FINDAT)

   tot01 := TOT01 + TMP->Z4_DESPRS
   tot02 := TOT02 + TMP->Z4_ADIANTA 
   tot03 := TOT03 + TMP->Z4_RESTITU 
   tot04 := TOT04 + TMP->Z4_REMB

   TMP->(Dbskip())

Enddo

@ Prow() + 2, 074 Psay TOT02      Picture "@E 999,999.99"
@ Prow()    , 144 Psay TOT01      Picture "@E 999,999.99"
@ Prow()    , 164 Psay TOT03      Picture "@E 999,999.99"
@ Prow()    , 184 Psay TOT04      Picture "@E 999,999.99"

Return