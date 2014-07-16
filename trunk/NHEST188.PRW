
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST188 ºAutor  ³José Henrique M Felipetto ºData 07/08/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Saldos                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque/Custos                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    
#include "protheus.ch"        
#INCLUDE "FIVEWIN.CH"

User Function NHEST188()

cString		:= "SB1"
cDesc1		:= "Relatório de Saldos"
cDesc2      := ""
cDesc3      := ""      
tamanho		:= "M"
limite		:= 132
aReturn		:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHEST188"
nLastKey	:= 0
titulo		:= OemToAnsi("Relatório de Saldos")
cabec2		:= ""
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1 //Variavel da pagina
M_PAG		:= 1
wnrel		:= "NHEST188"
_cPerg		:= "EST188"
nCont		:= 0
Cabec1		:= " Código               Descrição                            Grupo      Local               Saldo"
Cabec2		:= ""

Private aSaldos := {} 
Private nQuant	:= 0
Private dData	
Private cNovaLinha := Chr(13) + Chr(10)

oFnt1 		:= TFont():New("Arial"		,,14,,.T.,,,,,.F.)
oFnt2		:= TFont():New("Arial"		,,10,,.T.,,,,,.F.)
oFnt3		:= TFont():New("Arial"		,,08,,.T.,,,,,.F.)
oFnt4		:= TFont():New("Arial"		,,09,,.T.,,,,,.F.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,,,.F.,,,tamanho)

If nlastKey == 27
    Set Filter to
    Return
Endif          

SetDefault(aReturn,cString)

nTipo	:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver	:= ReadDriver()
cCompac	:= aDriver[1]

If Pergunte(_cPerg,.T.)
	Processa({||Gerando() },"Gerando Relatório...")
	Processa({||RptDetail() }," Imprimindo Relatório...")
else
	Return(nil)
EndIf

TMP->(DbCloseArea())
set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return 

Static Function Gerando()
cQuery := " SELECT B1_COD,B1_GRUPO,B1_DESC,B2_COD,B2_LOCAL FROM " + RetSqlName('SB1') + " B1, " + RetSqlName('SB2') + " B2 " + "(NoLock) "
cQuery += " WHERE B1_COD = B2_COD AND B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND B1_GRUPO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND B2_LOCAL BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
cQuery += " AND B1_TIPO  BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP") 
TMP->(DbGoTop() )
Return

Static Function RptDetail()

dData	:= mv_par07
Titulo := OemToAnsi("Relatório de Saldos - Dia:" + DTOC(dData))
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
               
MsgBox("Para criação do txt, deve ser criada a pasta 'SALDODIA' no C: de sua maquina !","Txt sera criado em C:\SALDODIA\ !","INFO")
cARQEXP := "C:\SALDODIA\RELATORIOSALDOSDIA.TXT"
cARQ  := FCreate(cARQEXP)

While TMP->(!EOF())
If @Prow() > 75
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
EndIf
	aSaldos	 := CalcEst(TMP->B1_COD,TMP->B2_LOCAL,dData + 1)
	@Prow()+1, 001 psay TMP->B1_COD // Código
	@Prow(), 022 psay TMP->B1_DESC // Descrição
	@Prow(),060 psay  TMP->B1_GRUPO // Grupo
	@Prow(),070 psay  TMP->B2_LOCAL // Local
	@Prow(),080 psay  aSaldos[1] Picture(PesqPict("SB2","B2_QATU"))     
	FWrite(cARQ,(TMP->(B1_COD + Chr(9) + B1_DESC + Chr(9)+ B1_GRUPO + Chr(9) +  B2_LOCAL + Chr(9) + Str(aSaldos[1])) + Chr(9) + cNovaLinha ))
	TMP -> (DbSkip())
EndDo
FClose(cARQ)
Return

