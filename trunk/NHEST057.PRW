/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST054        ³ Fabio Nico            ³ Data ³ 06.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validade dos produtos                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function NhEST057() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z")

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir Os")
cDesc2    := OemToAnsi("Produtos com data de validade vencidas ")
cDesc3    := OemToAnsi("")
tamanho   := "M"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST099"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "VALIDADE DOS LOTES "
Cabec1    := "Codigo Prod.      Localizacao       Lote      Disponivel       Data Validade "
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHEST99"       //Nome Default do relatorio em Disco
_cPerg    := "EST099"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX1)
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

//Mv_par01 :=	FORNECEDOR INICIO
//Mv_par02 :=	FORNECEDOR FIM
//Mv_par03 :=	EMISSAO DE
//Mv_par04 :=	EMISSAO ATE
//Mv_par05 :=	VALOR TOTAL DOS ITENS DE
//Mv_par06 :=	VALOR TOTAL DOS ITENS ATE
                                                                                         
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
If Empty(TMP->BF_PRODUTO)
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


Static Function Gerando()
//**********************************
	cQuery := "SELECT SBF.BF_PRODUTO,SBF.BF_LOCALIZ,SBF.BF_LOTECTL,SBF.BF_QUANT,SDB.DB_VALLOTE "
	cQuery += "FROM " + RetSqlName('SBF') + " SBF, " + RetSqlName('SDB') + " SDB "
	cQuery += "WHERE SDB.DB_PRODUTO = SBF.BF_PRODUTO "
    cQuery += "AND SDB.DB_LOTECTL   = SBF.BF_LOTECTL "
    cQuery += "AND SDB.DB_VALLOTE BETTWEEN " + mv_par02 + " AND " + mv_par03
    cQuery += "AND SDB.D_E_L_E_T_ = ' ' "
	cQuery += "AND SBF.BF_PRODUTO = '" + mv_par01 + "' "
	cQuery += "AND SBF.D_E_L_E_T_ = ' ' "   
	cQuery += "GROUP BY SBF.BF_PRODUTO,SBF.BF_LOCALIZ,SBF.BF_LOTECTL,SBF.BF_QUANT,SDB.DB_VALLOTE "
	
    MemoWrit('C:\TEMP\NHEST099.SQL',cQuery)
    TCQUERY cQuery NEW ALIAS "TMP"                      
    DbSelectArea("TMP")

Return


Static Function RptDet1()
               
@ 00, 00 pSay Chr(15)      
// imprime cabeçalho
Cabec2    := "Periodo de : "  
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
	   @ Prow() +1, 001 Psay TMP->BF_PRODUTO
	   @ Prow()   , 020 Psay TMP->BF_LOCALIZ
	   @ Prow()   , 040 Psay TMP->BF_LOTECTL
	   @ Prow()   , 050 Psay TMP->BF_QUANT
	   @ Prow()   , 060 Psay stod(TMP->DB_VALLOTE)  Picture '99/99/9999'
   dbskip()
enddo
@ Prow() +1, 000 PSAY __PrtThinLine()

Return