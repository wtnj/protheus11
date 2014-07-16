/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE068  ºAutor  ³Marcos R Roquitski  º Data ³  21/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Mao de Obra Direta Junho/2006.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe068()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlnormal,_nVlextras,_cCusto,_nVlDsr,_nVlOutras,_nVlFerias,_nVl13,_nVlHoras,nTotfun,_nTotfg,_nTotHo")

cString   := "SRA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("relacao de custos com mao de obra e encargos")
cDesc3    := OemToAnsi("")
tamanho   := "P"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 80
//nControle := 15
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE068"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "MAO DE OBRA DIRETA"
Cabec1    := " C.Custo  Descricao C.Custo         Nr.Func.   H.Extras   Tot.+Encargos"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE068"
_cPerg    := "GPE068"
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	
_nTotfg   := 0

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
cCcDe	:= mv_par02								//	Centro de Custo De
cCcAte	:= mv_par03								//	Centro de Custo Ate

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
	cQuery += "WHERE SRD.RD_CC BETWEEN '"+ Mv_par02 + "' AND '"+ Mv_par03 + "' "	
	cQuery += "AND SRD.RD_DATARQ = '" + Substr(Dtos(Mv_par01),1,6) + "' " 
	cQuery += "AND SRD.D_E_L_E_T_ = ' ' " 
	cQuery += "ORDER BY SRD.RD_CC ASC" 
    TCQUERY cQuery NEW ALIAS "TMP" 
    DbSelectArea("TMP")
Return


Static Function RptDet()
Local _lRet := .F.,	_nTotG0 := 0, _nVlEncar := 0


SRA->(DbSetOrder(2))
titulo := "Mao De Obra Direta "+MesExtenso(Month(Mv_par01))+ "/"+Alltrim(Str(Year(mv_par01)))
cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMP") 
dbgotop()
_nTotho := 0

While TMP->(!eof())
	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	
	_cCusto := TMP->RD_CC
	@ Prow() +1, 001 Psay TMP->RD_CC
	@ Prow()   , 010 Psay fNomecc(TMP->RD_CC)
	@ Prow()   , 038 pSay fSomaFunc() Picture "@E 9999"

	While TMP->RD_CC == _cCusto
		fTotHrm()
		_nVlencar := 0
		_nVlencar := _nVlExtras + ((_nVlExtras * 64)/100)
		@ Prow()   , 048 PSAY _nVlHoras Picture "@E 9,999.99"
		@ Prow()   , 060 PSAY _nVlencar Picture "@E 9,999,999.99"
		_nTotho += _nVlHoras
		_nTotg0 += _nVlencar
	Enddo

Enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 037 PSAY _nTotfg Picture "@E 9999"
@ Prow()   , 047 PSAY _nTotho Picture "@E 9,999.99"
@ Prow()   , 059 PSAY _nTotg0 Picture "@E 9,999,999.99"
@ Prow() +1, 000 PSAY __PrtThinLine()

Return

Static Function fSomaFunc()
_nTotfun := 0
SRA->(DbSeek(xFilial("SRA") + _cCusto))
While SRA->(!eof()) .AND. SRA->RA_CC == _cCusto
	If SRA->RA_SITFOLH <> 'D'
		_nTotfun++
	Endif	
	SRA->(DbSkip())
Enddo
_nTotfg += _nTotfun
Return(_nTotfun)


Static Function fTotHrm()
Local _cTipoCod := Space(01), _cMat := Space(06)
_nVlnormal := 0
_nVlextras := 0
_nVlDsr    := 0
_nVlOutras := 0
_nVl13     := 0
_nVlHoras  := 0
While TMP->(!eof()) .AND. _cCusto == TMP->RD_CC
	cTipoCod := Space(01)
		
	If SRV->(DbSeek(xFilial("SRV") + TMP->RD_PD))
		_cTipoCod := SRV->RV_TIPOCOD
	Endif		

	If _cTipoCod == "1"
		If TMP->RD_PD $ '101/102'
			_nVlnormal += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '105/106/107/108/109/110/111/116' // Horas extras
			_nVlextras += TMP->RD_VALOR
			_nVlHoras  += TMP->RD_HORAS

		Elseif TMP->RD_PD $ '122'
			_nVlDsr += TMP->RD_VALOR

		Else
			_nVlOutras +=  TMP->RD_VALOR

		Endif
    Endif
	TMP->(Dbskip())

Enddo

Return(.T.)


Static Function fNomecc(_pCusto)
Local _cDesc := Space(30)
If CTT->(DbSeek(xFilial("CTT") + _pCusto))	
	_cDesc := Substr(CTT->CTT_DESC01,1,30)
Endif	
Return(_cDesc)
