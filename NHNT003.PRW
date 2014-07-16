/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHMNT 03        ³ Fabio Nico            ³ Data ³ 06.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ RELATORIO DE ORDENS DE SERVICO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
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
//cDesc2    := OemToAnsi("Produtos com data de validade vencidas ")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHmnt003"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "O.S. Em aberto por turno"                        
Cabec1    := "ORDEM   PLANO    DTORIGI    CODBEM   DESCRICAO                                          SERVICO SIT. HORA " 
  "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
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

// mv_par01 :=	ORDEM SERVICO INICIAL
// mv_par02 :=	ORDEM SERVICO FINAL             
// mv_par03 :=  SITUACAO DA ORDEM DE SERVICO
                                                                                         
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

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
	cQuery := "SELECT STJ.TJ_ORDEM,STJ.TJ_DTORIGI,STJ.TJ_CODBEM,ST9.T9_NOME,STJ.TJ_SERVICO,"
    cQuery += "STJ.TJ_TERMINO,STJ.TJ_MAQSIT,STJ.TJ_HRPARAD,STJ.R_E_C_N_O_ "
	cQuery += "FROM " + RetSqlName('STJ') + " STJ , " + RetSqlName( 'ST9' ) + " ST9 " 
	cQuery += "WHERE STJ.TJ_ORDEM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += " AND STJ.TJ_TERMINO = '" + mv_par03 + "'"
	cQuery += " AND STJ.TJ_DTORIGI BETWEEN '" + DtoS(mv_par04) + "' AND '" + DtoS(mv_par05) + "' "
    cQuery += " AND STJ.TJ_SERVICO BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
    cQuery += " AND STJ.TJ_CENTRAB BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "    
    cQuery += " AND STJ.TJ_SITUACA <> 'C' "
    cQuery += " AND STJ.D_E_L_E_T_ = ' ' "
    cQuery += " AND STJ.TJ_CODBEM = ST9.T9_CODBEM "
    cQuery += " AND ST9.D_E_L_E_T_ = ' ' "    
    cQuery += " ORDER BY STJ.TJ_DTORIGI,STJ.TJ_HRPARAD DESC "
    
    MemoWrit('C:\TEMP\NHMNT003.SQL',cQuery)
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
	If Prow() > 56
	   _nPag := _nPag + 1
	   Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0) 
	 	Endif                     
	   @ Prow() +1, 001 Psay TMP->TJ_ORDEM
	   @ Prow()   , 08 Psay TMP->TJ_DTORIGI  PICTURE "99/99/99"
	   @ Prow()   , 19 Psay TMP->TJ_CODBEM
	   @ Prow()   , 36 Psay TMP->T9_NOME
       @ Prow()   , 87 Psay TMP->TJ_SERVICO
	   @ Prow()   , 95 Psay TMP->TJ_MAQSIT
	   @ Prow()   , 100 Psay TMP->TJ_HRPARAD              
	   
	   
		DbSelectArea("STJ")
		STJ->(DbSetOrder(1))
		STJ->(Dbgoto(TMP->R_E_C_N_O_))       
		nLinha = MlCount(Alltrim(STJ->TJ_OBSERVA))
                                                 
		for x = 1 to nLinha
           if x=1 
             	@ Prow() , 110 Psay MemoLine(STJ->TJ_OBSERVA,50,x)
              else
                @ Prow()+1 , 110 Psay MemoLine(STJ->TJ_OBSERVA,50,x)
           endif
       next 
       DbSelectArea("TMP") 
    dbskip()
enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
Return