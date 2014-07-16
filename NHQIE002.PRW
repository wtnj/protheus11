/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHQIE002        ³ Fabio Nico            ³ Data ³ 20.02.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ RELATORIO DE SKIP-LOTE NO MES POR FORNECEDOR              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"     
#INCLUDE "FIVEWIN.CH"

User Function NHQIE002() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z")

cString   := "QEK"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir os produtos em SKIP LOTE no mes")
//cDesc2    := OemToAnsi("Produtos com data de validade vencidas ")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQIE002"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "SKIP LOTE em aberto no mês"                        
Cabec1    := "PRODUTO             FORNECEDOR                             LOTE       LAUDO GERAL          "
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHQIE002"       //Nome Default do relatorio em Disco
_cPerg    := "QIE002"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)
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

// mv_par01 :=	DATA INICIO
// mv_par02 :=	DATA FIM
// mv_par03 :=  FORNECEDOR INICIO
// mv_par04 :=  FORNECEDOR FIM
// mv_par05 :=  PRODUTO INICIO
// mv_par06 :=  PRODUTO FIM

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
If Empty(TMP->QEK_VERIFI)
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
	cQuery := "SELECT QEK.QEK_VERIFI,QEK.QEK_DTENTR,QEK.QEK_LOTE,QEK.QEK_FORNEC,QEK.QEK_DOCENT,QEL.QEL_LAUDO, "
    cQuery += "SA2.A2_NOME,QED.QED_DESCPO,QEK.QEK_PRODUT,QEK.QEK_REVI,QEK.QEK_DOCENT "
    cQuery += "FROM QEKNH0 QEK, QELNH0 QEL, SA2NH0 SA2, QEDNH0 QED "
    cQuery += "WHERE QEK.QEK_FORNEC = QEL.QEL_FORNEC "
    cQuery += "AND QEK.QEK_PRODUT BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
    cQuery += "AND QEK.QEK_LOTE = QEL.QEL_LOTE "
    cQuery += "AND QEK.QEK_VERIFI = 2 "
    cQuery += "AND QEK.QEK_FORNEC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
    cQuery += "AND QED.QED_CODFAT = QEL.QEL_LAUDO "
    cQuery += "AND QED.D_E_L_E_T_ <> '*' "  
    cQuery += "AND SA2.A2_COD = QEK.QEK_FORNEC "
    cQuery += "AND SA2.D_E_L_E_T_ <> '*' "
    cQuery += "AND QEK.QEK_DTENTR BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
    cQuery += "AND QEK.D_E_L_E_T_ <> '*' "   
    cQuery += "GROUP BY  QEK.QEK_VERIFI,QEK.QEK_DTENTR,QEK.QEK_LOTE,QEK.QEK_FORNEC,QEK.QEK_DOCENT,QEL.QEL_LAUDO, "
    cQuery += "SA2.A2_NOME,QED.QED_DESCPO,QEK.QEK_PRODUT,QEK.QEK_REVI,QEK.QEK_DOCENT "
    cQuery += "ORDER BY 2,3 "

    MemoWrit('C:\TEMP\NHMNT001.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                               
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
	   @ Prow() +1, 001 Psay TMP->QEK_PRODUT
	   @ Prow()   , 020 Psay TMP->QEK_FORNEC
	   @ Prow()   , 030 Psay TMP->A2_NOME
	   @ Prow()   , 070 Psay TMP->QEK_LOTE
	   @ Prow()   , 080 Psay TMP->QEL_LAUDO
	   @ Prow()   , 085 Psay TMP->QED_DESCPO

    dbskip()
enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
Return