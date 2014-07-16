/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHEST075        ³ FABIO NICO            ³ Data ³ 29/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de consumo dos ultimos 6 meses com saldo atual  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padrao para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"   
#INCLUDE "MATR340.CH"   
User Function NhEst075

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,nQtde")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,_AFIELDS")
//SetPrvt("_DDATA,_CARQNTX,_CORDEM,_NPER,_NPOS,_CCABEC1,M_PAG,_ca,_cb,_cc,cTipoNF")
//SetPrvt("aAuxCombo1,aCombo1,cPedido,cINSP,cFornece,cSerie,cNF,cLoja,dDtDigi,_cNome")
//SetPrvt("nBASEICM,nVALICM,nBRICMS,nICMSRET,nVALMERC,nDESCONT,nFRETE,nSEGURO,nDESPESA,nVALIPI,nVALBRUT")
SetPrvt("_cCodUsr")

cString   :="SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir o  ")
cDesc2    := OemToAnsi("Consumo dos ultimos 6 meses, mostrando o saldo")
cDesc3    := OemToAnsi("atual nos almoxarifados e o ponto de pedido.")
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="NHEST075"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    :="Relatório de consumo dos ultimos 6 meses" 
Cabec1    :="Codigo  Produto                                  Grupo  Sld   Pto " 
// Mes01  Mes02  Mes03  Mes04  Mes05  Mes06 Media Total"
cabec2    :=""                                                  
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     :="NHEST075"          //Nome Default do relatorio em Disco
_cPerg    := "EST075"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)


// Parametros Utilizados
// mv_par01 = Data da digitacao Inicio
// mv_par02 = Data da Digitacao Fim


dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

                                                                                        
If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 
//SetPrint("SZ7",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")        


If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif
             
nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver 	:= ReadDriver()
cCompac 	:= aDriver[1]
cNormal 	:= aDriver[2] 
cFilterUser := aReturn[7]

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
TMP->(DbGoTop())
If Empty(TMP->B1_COD)
   MsgBox("Nota Fiscal nao Encontrada","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| RptDetail() },"Gerando Dados para a Impressao")
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
	cQuery := "SELECT B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO,SUM(B2.B2_QATU) AS TOTAL, B3.B3_Q06,B3.B3_Q07,B3.B3_Q08,B3.B3_Q09,B3.B3_Q10,B3.B3_Q11,B3.B3_Q12, "
    cQuery += "B3.B3_Q06+B3.B3_Q07+B3.B3_Q08+B3.B3_Q09+B3.B3_Q10+B3.B3_Q11+B3.B3_Q12 AS SOMAGER "
	cQuery += "FROM " + RetSqlName('SB1') +" B1, " +RetSqlName('SB2') +" B2, " + RetSqlName('SB3') +" B3 "
	cQuery += "WHERE B2.B2_COD = B1.B1_COD "
	cQuery += "AND B3.B3_COD = B1.B1_COD "
	cQuery += "AND B1.B1_GRUPO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "AND B1.B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
	cQuery += "AND B1.B1_MSBLQL <> '1' "
	cQuery += "AND B1.D_E_L_E_T_ = '' "
	cQuery += "AND B2.D_E_L_E_T_ = '' "
	cQuery += "AND B3.D_E_L_E_T_ = '' "
	cQuery += "GROUP BY B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO, B3.B3_Q06,B3.B3_Q07,B3.B3_Q08,B3.B3_Q09,B3.B3_Q10,B3.B3_Q11,B3.B3_Q12 "
	cQuery += "ORDER BY SOMAGER DESC"

//TCQuery Abre uma workarea com o resultado da query            
    MemoWrit('C:\TEMP\NHEST075.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"  

Return

Static Function RptDetail()
LOCAL aMeses:= {STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0017,STR0018,STR0019,STR0020,STR0021,STR0022}	
LOCAL nMes := 0
nMes := MONTH(dDataBase)+1
nMes := nMes-6
IF nMes = 13 
	nMes := 1
Endif
cMes := StrZero(nMes,2)



//"JAN"###"FEV"###"MAR"###"ABR"###"MAI"###"JUN"###"JUL"###"AGO"###"SET"###"OUT"###"NOV"###"DEZ"


FOR nX := 1 TO 6
	IF aMeses[nMes] == STR0011 .And. nX != 1
		nAno++
	EndIF
	cabec1 += Space(4)+aMeses[nMes]
	nMes++
	IF nMes > 12
		nMes := 1
	ENDIF
NEXT nX
cabec1 += "  Media  Total"


TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())

   If Prow() > 66
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif
                                            
	@ Prow() + 1, 001 Psay TMP->B1_COD
	@ Prow()    , 017 Psay TMP->B1_DESC 
	@ Prow()    , 050 Psay TMP->B1_GRUPO 	
	@ Prow()    , 055 Psay TMP->TOTAL       Picture"@E 9999" 
	@ Prow()    , 062 Psay TMP->B3_Q06      Picture"@E 9999"
	@ Prow()    , 069 Psay TMP->B3_Q07      Picture"@E 9999"
	@ Prow()    , 076 Psay TMP->B3_Q08      Picture"@E 9999"		
	@ Prow()    , 083 Psay TMP->B3_Q09      Picture"@E 9999"
	@ Prow()    , 090 Psay TMP->B3_Q10      Picture"@E 9999"
	@ Prow()    , 097 Psay TMP->B3_Q11      Picture"@E 9999"
	@ Prow()    , 104 Psay TMP->B3_Q12      Picture"@E 9999" 
    _Media = TMP->SOMAGER/6
	@ Prow()    , 111 Psay _Media           Picture"@E 9999" 
	@ Prow()    , 118 Psay TMP->SOMAGER     Picture"@E 9999" 		
   
   TMP->(Dbskip())   
EndDo
      
Return(nil)      
  
