/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE052  ºAutor  ³Marcos R. Roquitski º Data ³  20/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de I.R - Conferencia DIRF                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe052()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nTotVlr,nTotFat")

cString   := "SRA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir, ")
cDesc2    := OemToAnsi("o I.R dos funcionarios.")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE052"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Relatorio de Recolhimento do Imposto de Renda"
Cabec1    := " Mtr.   Nome                                       Dt.Pgto       Cod.Descricao da Verba                                Valor"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE052"
_cPerg    := "GPE052"
nTotVlr   := 0
nTotFat   := 0
                  

If !Pergunte('GPE052',.T.)
   Return(nil)
Endif   

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)

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

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Return



Static Function Gerando()
	cQuery := "SELECT RD.RD_MAT,RD.RD_DATARQ,RD.RD_VALOR,RD.RD_PD,RD.RD_DATPGT,RA.RA_NOME,RA.RA_MAT,RV.RV_DESC,RV.RV_COD"
	cQuery := cQuery + " FROM " + RetSqlName( 'SRA' ) + " RA, " + RetSqlName( 'SRD' ) + " RD," + RetSqlName( 'SRV' ) + " RV "
	cQuery := cQuery + "WHERE RD.D_E_L_E_T_ = ' ' "
	cQuery := cQuery + "AND RA.RA_MAT = RD.RD_MAT "
	cQuery := cQuery + "AND RD.RD_DATARQ LIKE '" + Mv_par01 + '%' + "' "
	cQuery := cQuery + "AND RD.RD_DATPGT BETWEEN '" + Dtos(Mv_par02) + "' AND '" + Dtos(Mv_par03) + "' "
	cQuery := cQuery + "AND RA.RA_ZEMP BETWEEN '" + Mv_par04 + "' AND '" + Mv_par05 + "' "   
	cQuery := cQuery + "AND RA.RA_FILIAL BETWEEN '" + Mv_par06 + "' AND '" + Mv_par07 +"' " 
	cQuery := cQuery + "AND RD.RD_FILIAL BETWEEN '" + Mv_par06 + "' AND '" + Mv_par07 +"' " 
	cQuery := cQuery + "AND RD.RD_PD IN ('407','409','411','413','415','417','723') "
	cQuery := cQuery + "AND RD.RD_PD = RV.RV_COD "
	cQuery := cQuery + " ORDER BY RD.RD_DATPGT,RD.RD_MAT ASC"
	TCQUERY cQuery NEW ALIAS "TMP"

	TcSetField("TMP","RD_DATPGT","D") // Muda a data de string para date.

Return


Static Function RptDetail()
Local _nTotal:=0, _dData := Ctod(Space(06)), _nTotGe := 0
TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))


Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
While TMP->(!Eof())

	If Prow() > 60
  	   _nPag := _nPag + 1
     	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif
  	@ Prow() + 1, 001 Psay TMP->RD_MAT
	@ Prow()    , 008 Psay TMP->RA_NOME
	@ Prow()    , 050 Psay TMP->RD_DATPGT
	@ Prow()    , 065 Psay TMP->RD_PD + " " + TMP->RV_DESC
	@ Prow()    , 110 Psay TMP->RD_VALOR   Picture "@E 999,999,999.99"
	_dData  := TMP->RD_DATPGT
	_nTotal := _nTotal + TMP->RD_VALOR
	_nTotge := _nTotge + TMP->RD_VALOR
	TMP->(DbSkip())
	If _dData <> TMP->RD_DATPGT
		@ Prow() + 2, 110 Psay _nTotal   Picture "@E 999,999,999.99"
	  	@ Prow() + 1, 001 Psay Replicate("-",limite)
	  	_nTotal := 0
	Endif

Enddo
@ Prow() + 1, 050 Psay "Total ................."
@ Prow()    , 110 Psay _nTotge   Picture "@E 999,999,999.99"
@ Prow() + 1, 001 Psay Replicate("-",limite)

DbSelectArea("TMP")
DbCloseArea()


Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
  ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return(nil)



