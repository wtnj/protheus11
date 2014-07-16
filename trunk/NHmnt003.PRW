/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHMNT003        ³ Fabio Nico            ³ Data ³ 06.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ RELATORIO DE OS / SITUAÇÃO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MANUTENCAO DE ATIVOS                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"     
#INCLUDE "FIVEWIN.CH"

User Function NHMNT003() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z")

cString   := "STJ"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir Os")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT003"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "OS ABERTAS POR TURNO"
Cabec1    := " ORDEM    PLANO     DTORIGI       CODBEM      DESCRICAO                                  C.CUSTO                              SERVICO  SIT.  HORA    OBS" 
//  "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHMNT003"       //Nome Default do relatorio em Disco
_cPerg    := "MNT003"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

// mv_par01 := ORDEM SERVICO INICIAL
// mv_par02 := ORDEM SERVICO FINAL             
// mv_par03 := TERMINO (S/N)
// mv_par04 := DE DATA
// mv_par05 := ATE DATA
// mv_par06 := DE SERVICO
// mv_par07 := ATE SERVICO
// mv_par08 := DE C TRABALHO
// mv_par09 := ATE C TRABALHO
// mv_par10 := DE C CUSTO
// mv_par11 := ATE C CUSTO
// mv_par12 := DE OPERACAO
// mv_par13 := ATE OPERACAO
// mv_par14 := DE HORA
// mv_par15 := ATE HORA
// mv_par16 := DE BEM
// mv_par17 := ATE BEM
// mv_par18 := ESTADO DA MAQ
// mv_par19 := DO STATUS
// mv_par20 := ATE STATUS
// mv_par21 := SITUACAO (1=LIBERADA,2=PENDENTE,3=AMBAS)

If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer

TMP->(DbGoTop())
If Empty(TMP->TJ_ORDEM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()

   Return
Endif

//inicio da impressao
Processa( {|| RptDet1() },"Imprimindo...")
DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

//***********************************************************************************************************
Static Function Gerando()
//***********************************************************************************************************

	cQuery := "SELECT STJ.TJ_ORDEM,STJ.TJ_PLANO, STJ.TJ_DTORIGI,STJ.TJ_CODBEM,ST9.T9_NOME,STJ.TJ_SERVICO,"
    cQuery += "STJ.TJ_TERMINO,STJ.TJ_MAQSIT,STJ.TJ_HRPARAD,STJ.R_E_C_N_O_, STJ.TJ_CCUSTO, CTT.CTT_DESC01 "
	cQuery += "FROM " + RetSqlName('STJ') + " STJ , " + RetSqlName( 'ST9' ) + " ST9, "+RetSqlName("CTT")+" CTT "
	cQuery += "WHERE STJ.TJ_ORDEM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND STJ.TJ_TERMINO = '" + Iif(mv_par03==1,"S","N") + "'"

	cQuery += " AND CTT.CTT_CUSTO = STJ.TJ_CCUSTO"
    
    cQuery += " AND STJ.TJ_CODBEM BETWEEN '"+mv_par16+"' AND '"+mv_par17+"'"//add dia 21/01/2009
	
	if mv_par18 == 2 //Deficiente
		cQuery += "  AND STJ.TJ_MAQSIT = 'D'"
	EndIf
	if mv_par18 == 1 //parada
		cQuery += " AND STJ.TJ_MAQSIT = 'P'"
	EndIf

	cQuery += " AND STJ.TJ_DTORIGI BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "' "
    cQuery += " AND STJ.TJ_SERVICO BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
    cQuery += " AND STJ.TJ_CENTRAB BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "

    If mv_par21==1 // liberada
    	cQuery += " AND STJ.TJ_SITUACA = 'L' "
    ElseIf mv_par21==2 //pendentes
    	cQuery += " AND STJ.TJ_SITUACA = 'P' "
    Else
	    cQuery += " AND STJ.TJ_SITUACA <> 'C' "
    EndIf


    cQuery += " AND STJ.TJ_CCUSTO BETWEEN '" + mv_par10 + "' AND '" + mv_par11 +"' "
    cQuery += " AND STJ.D_E_L_E_T_ = ' ' "             
    cQuery += " AND CTT.D_E_L_E_T_ = ' ' "             
    cQuery += " AND STJ.TJ_CODBEM = ST9.T9_CODBEM "
    cQuery += " AND ST9.T9_OPERAC BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"'"
//    cQuery += " AND STJ.TJ_HOPRINI >= '"+MV_PAR14+"'"
//    cQuery += " AND STJ.TJ_HOPRFIM <= '"+MV_PAR15+"'"
 	cQuery += " AND STJ.TJ_HRPARAD BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"'"
 	cQuery += " AND STJ.TJ_STFOLUP BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"'"
    cQuery += " AND ST9.D_E_L_E_T_ = ' ' "    
    cQuery += " ORDER BY STJ.TJ_CODBEM, STJ.TJ_DTORIGI,STJ.TJ_HRPARAD DESC "
    
    TCQUERY cQuery NEW ALIAS "TMP"
 	TcSetField("TMP","TJ_DTORIGI","D")
    DbSelectArea("TMP")
Return

Static Function RptDet1()
               
@ 00, 00 pSay Chr(15)      
// imprime cabeçalho
//Cabec2    := "Periodo de : "  
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

DbSelectArea("TMP") 
dbgotop()

If Prow() > 66
   _nPag := _nPag + 1
   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
Endif                     

While !eof()      
	If Prow() > 60
	   _nPag := _nPag + 1
	   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
	 	Endif                     
	   @ Prow() +1, 001 Psay TMP->TJ_ORDEM
	   @ Prow()   , 010 Psay TMP->TJ_PLANO
	   @ Prow()   , 019 Psay TMP->TJ_DTORIGI  PICTURE "99/99/99"
	   @ Prow()   , 032 Psay ALLTRIM(TMP->TJ_CODBEM)
	   @ Prow()   , 046 Psay SUBS(TMP->T9_NOME,1,40)
	   @ Prow()   , 089 Psay ALLTRIM(TMP->TJ_CCUSTO)+" - "+SUBS(TMP->CTT_DESC01,1,25)
       @ Prow()   , 126 Psay TMP->TJ_SERVICO
	   @ Prow()   , 136 Psay TMP->TJ_MAQSIT
	   @ Prow()   , 141 Psay TMP->TJ_HRPARAD              
	   
		DbSelectArea("STJ")
		STJ->(DbSetOrder(1))
		STJ->(Dbgoto(TMP->R_E_C_N_O_))       
		nLinha = MlCount(Alltrim(STJ->TJ_OBSERVA))
                                                 
		for x = 1 to nLinha
           if x=1 
             	@ Prow() , 149 Psay MemoLine(STJ->TJ_OBSERVA,60,x)
              else
//                @ Prow()+1 , 001 Psay ""
                @ Prow()+1   , 149 Psay MemoLine(STJ->TJ_OBSERVA,60,x)
           endif
       next 
       DbSelectArea("TMP") 
    dbskip()
enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
Return