/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE218  ºAutor  ³Marcos R Roquitski  º Data ³  24/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Provisao/13 Salario Transferencias.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe218()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlnormal,_nVlextras,_cCusto,_nVlDsr,_nVlOutras,_nVlFerias,_nVl13")


cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("relacao de custos com mao de obra e encargos")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE218"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "RELACAO DE MAO DE OBRA E ENCARGOS"
Cabec1    := " Matr.  Nome                            C.Custo    Descricao             Sal.Nominal         H.Extras            DSR       Despesas       T O T A L    Prov. Ferias    Prov.13o.Sal    Enc.Sal.104%    Enc.Extr.73%"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE218"
_cPerg    := "GPR070"
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	

If !Pergunte(_cPerg,.T.) //Ativa os parametros
	Return(nil)
Endif
                                   
wnRel := SetPrint(cString,wnrel,_cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
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
dDataRef:= mv_par01                             // Data de Referencia
cFilDe	:= mv_par02								//	Filial De
cFilAte := mv_par03								//	Filial Ate
cCcDe	:= mv_par04								//	Centro de Custo De
cCcAte	:= mv_par05								//	Centro de Custo Ate
cMatDe	:= mv_par06								//	Matricula De
cMatAte := mv_par07								//	Matricula Ate
cNomeDe := mv_par08								//	Nome De
cNomeAte:= mv_par09								//	Nome Ate
nAnaSin := mv_par10								//	Analitica / Sintetica
nGerRes := mv_par11								//	Geral / Resumida
lImpNiv := If(mv_par12 == 1,.T.,.F.)		    //  Imprimir Niveis C.Custo
cCateg	:= mv_par13								//	Categorias (Utilizada em fMonta_TPR)

SRA->(DbSetOrder(1)) 

// inicio do processamento do relatório
Processa( {|| GeraSrd() },"Gerando Dados para a Impressao")
                  
//inicio da impressao
Processa( {|| RptDet() },"Imprimindo...")
     
DbSelectArea("TMP")
DbCloseArea("TMP")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function GeraSrd() 
	//**********************************
	cQuery := "SELECT * FROM " + RetSqlName('SRD') + " SRD " 
	cQuery += "WHERE SRD.RD_MAT BETWEEN '"+ Mv_par06 + "' AND '"+ Mv_par07 + "' " 
    cQuery += "AND SRD.RD_CC BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' "	
	cQuery += "AND SRD.RD_DATARQ = '" + Substr(Dtos(Mv_par01),1,6) + "' " 
	cQuery += "AND SRD.D_E_L_E_T_ = ' ' " 
	cQuery += "ORDER BY SRD.RD_MAT ASC" 
    TCQUERY cQuery NEW ALIAS "TMP" 
    DbSelectArea("TMP") 
Return


Static Function RptDet()
Local _lRet := .F.,	_nTotG0 := 0

_cMat   := Space(6)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMP") 
dbgotop()

While TMP->(!eof())
	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	
	_cMat := TMP->RD_MAT 
	@ Prow() +1, 001 Psay TMP->RD_MAT 
	@ Prow()   , 008 Psay fNomefu(TMP->RD_MAT) 
	@ Prow()   , 040 Psay TMP->RD_CC 
	@ Prow()   , 051 Psay fNomecc(TMP->RD_CC) 

	While TMP->RD_MAT == _cMat

		fTotHrm()
		@ Prow()   , 071 PSAY Transform(_nVlNormal,"@E 999,999,999.99")
		@ Prow()   , 088 PSAY Transform(_nVlExtras,"@E 999,999,999.99")
		@ Prow()   , 103 PSAY Transform(_nVlDsr,"@E 999,999,999.99")
		@ Prow()   , 118 PSAY Transform(_nVlOutras,"@E 999,999,999.99")
		_nTotG0 := (_nVlNormal + _nVlExtras + _nVlDsr + _nVlOutras)
		@ Prow()   , 134 PSAY Transform(_nTotG0,"@E 999,999,999.99")
		@ Prow()   , 150 PSAY Transform(_nVlFerias,"@E 999,999,999.99")
		@ Prow()   , 166 PSAY Transform(_nVl13,"@E 999,999,999.99")

		@ Prow()   , 182 PSAY Transform(((_nVlNormal*104)/100),"@E 999,999,999.99")
		@ Prow()   , 198 PSAY Transform(((_nVlExtras100*73)/100),"@E 999,999,999.99")

	Enddo
	_nTotG0 := 0
Enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
/*
@ Prow() +1, 030 Psay "Total:"
@ Prow() +1, 000 PSAY __PrtThinLine()
*/
Return


Static Function fTotHrm()
Local _cTipoCod := Space(01)
_nVlnormal := 0
_nVlextras := 0
_nVlDsr    := 0
_nVlOutras := 0
_nVl13     := 0
While TMP->(!eof()) .AND. _cMat == TMP->RD_MAT
	cTipoCod := Space(01)
		
	If SRV->(DbSeek(xFilial("SRV") + TMP->RD_PD))
		_cTipoCod := SRV->RV_TIPOCOD

	Endif		

	If _cTipoCod == "1"
		If TMP->RD_PD $ '101/102'
			_nVlnormal += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '105/106/107/108/109/110/111/116'
			_nVlextras += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '122'
			_nVlDsr += TMP->RD_VALOR

		Else
			_nVlOutras +=  TMP->RD_VALOR

		Endif
    Endif
	TMP->(Dbskip())

Enddo

// Calcula provisao de 13o. e Ferias
_nVl13 := 0
_nVlFerias := 0
SRT->(DbSetOrder(1))
SRT->(DbSeek(xFilial("SRT") + _cMat))
While SRT->(!eof()) .AND. _cMat == SRT->RT_MAT
	If Substr(Dtos(SRT->RT_DATACAL),1,6) == Substr(Dtos(Mv_par01),1,6)
		If SRT->RT_VERBA $ '758/767'   // Ferias e 1/3 de Ferias
			_nVlFerias += SRT->RT_VALOR
		Elseif SRT->RT_VERBA $ '748/763'
			_nVl13 += SRT->RT_VALOR
		Endif
	Endif
	SRT->(Dbskip())
Enddo

Return(.T.)

Static Function fNomecc(_pCusto)
Local _cDesc := Space(30)
If CTT->(DbSeek(xFilial("CTT") + _pCusto))	
	_cDesc := Substr(CTT->CTT_DESC01,1,25)
Endif	
Return(_cDesc)


Static Function fNomefu(_pMat)
Local _cDesc := Space(30)
If SRA->(DbSeek(xFilial("SRA") + _pMat))	
	_cDesc := SRA->RA_NOME
Endif	
Return(_cDesc)

