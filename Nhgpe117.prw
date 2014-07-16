/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE117  ºAutor  ³Marcos R Roquitski  º Data ³  24/04/06   º±±
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

User Function Nhgpe117()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlSalario,_nVlExtras,_nVlFerias,_nVlRct,_nVl131,_nVl132,_nVlFgts,_nVlInss")
SetPrvt("_ntVlSalario,_ntVlExtras,_ntVlFerias,_ntVlRct,_ntVl131,_ntVl132,_ntVlFgts,_ntVlInss")

cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("resumo gerencial salarios/ferias/rescisao/13.salario/fgts/inss")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE117"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Resumo Gerencial salarios/ferias/rescisao/13.salario/fgts/inss"
Cabec1    := " C.Custo       Descricao C.Custo                       Salarios       H.Extras         Ferias      Rescisoes   1a.Parc.13o.   2a.Parc 13o.           FGTS           INSS"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE117"
_cPerg    := "GPR070"
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	
_ntVlSalario := 0
_ntVlExtras  := 0
_ntVlFerias  := 0
_ntVlRct     := 0
_ntVl131     := 0
_ntVl132     := 0
_ntVlFgts    := 0
_ntVlInss    := 0

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
    cQuery += "AND SRD.RD_FILIAL = '" + xFilial("SRD")+ "'"	
	cQuery += "AND SRD.D_E_L_E_T_ = ' ' "                   
	cQuery += "ORDER BY SRD.RD_CC ASC"
  TCQUERY cQuery NEW ALIAS "TMP"                      
  DbSelectArea("TMP")
Return


Static Function RptDet()
Local _lRet := .F.,	_nTotG0 := 0

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMP") 
dbgotop()

While TMP->(!eof())
	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif
	
	_cCusto := TMP->RD_CC
	@ Prow() +1, 001 Psay TMP->RD_CC
	@ Prow()   , 015 Psay fNomecc(TMP->RD_CC)

	While TMP->RD_CC == _cCusto
		fTotHrm()
		@ Prow()   , 050 PSAY Transform(_nVlSalario,"@E 999,999,999.99")
		@ Prow()   , 065 PSAY Transform(_nVlExtras,"@E 999,999,999.99")
		@ Prow()   , 080 PSAY Transform(_nVlFerias,"@E 999,999,999.99")
		@ Prow()   , 095 PSAY Transform(_nVlRct,"@E 999,999,999.99")
		@ Prow()   , 110 PSAY Transform(_nVl131,"@E 999,999,999.99")
		@ Prow()   , 125 PSAY Transform(_nVl132,"@E 999,999,999.99")
		@ Prow()   , 140 PSAY Transform(_nVlFgts,"@E 999,999,999.99")
		@ Prow()   , 155 PSAY Transform(_nVlInss,"@E 999,999,999.99")
	Enddo
	_nTotG0 := 0
Enddo
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 030 Psay "Total:"
@ Prow()   , 050 PSAY Transform(_ntVlSalario,"@E 99,999,999.99")
@ Prow()   , 065 PSAY Transform(_ntVlExtras,"@E 99,999,999.99")
@ Prow()   , 080 PSAY Transform(_ntVlFerias,"@E 99,999,999.99")
@ Prow()   , 095 PSAY Transform(_ntVlRct,"@E 99,999,999.99")
@ Prow()   , 110 PSAY Transform(_ntVl131,"@E 99,999,999.99")
@ Prow()   , 125 PSAY Transform(_ntVl132,"@E 99,999,999.99")
@ Prow()   , 140 PSAY Transform(_ntVlFgts,"@E 99,999,999.99")
@ Prow()   , 155 PSAY Transform(_ntVlInss,"@E 99,999,999.99")
@ Prow() +1, 000 PSAY __PrtThinLine()

Return

Static Function fTotHrm()
Local _cTipoCod := Space(01)
_nVlSalario := 0
_nVlExtras  := 0
_nVlFerias  := 0
_nVlRct     := 0
_nVl131     := 0
_nVl132     := 0
_nVlFgts    := 0
_nVlInss    := 0
While TMP->(!eof()) .AND. _cCusto == TMP->RD_CC
		
		If TMP->RD_PD $ '101/102/103/113/119/120/123/125/128/129/130/132/136/166/191/210/217/218/220/322/233/399' // /425/427/428/429' // Salario 
			//If TMP->RD_PD $ '425/427/428/429' // Faltas e atrasos
			//	_nVlSalario -= TMP->RD_VALOR
			//	_ntVlSalario -= TMP->RD_VALOR
			//Else

			_nVlSalario += TMP->RD_VALOR
			_ntVlSalario += TMP->RD_VALOR

			//Endif
			
		Elseif TMP->RD_PD $ '105/107/110/111/116/122' // Horas extras
			_nVlextras += TMP->RD_VALOR
			_ntVlextras += TMP->RD_VALOR
			
		Elseif TMP->RD_PD $ '156/157/158/159/160/162/164/168/170/172/173/178/180/182/183/184/186' // Ferias
			_nVlFerias += TMP->RD_VALOR
			_ntVlFerias += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '140/174/176/193/195/197/203/205/207/216/470/472/737/740/744/746/747' // Rescisao
			_nVlRct += TMP->RD_VALOR
			_ntVlRct += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '144' // 13o. 1a. Parcela
			_nVl131 += TMP->RD_VALOR
			_ntVl131 += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '105/107/110/111/113/116/141/143/145/146/217/448' // 13o. 2a. Parcela
			_nVl132 += TMP->RD_VALOR
			_ntVl132 += TMP->RD_VALOR

		Elseif TMP->RD_PD $ '736/739' // Fgts
			_nVlFgts += TMP->RD_VALOR
			_ntVlFgts += TMP->RD_VALOR
			
    Endif
    
		TMP->(Dbskip())

Enddo

SRZ->(DbSetOrder(1))
SRZ->(DbSeek(xFilial("SRZ") + _cCusto))	
While !SRZ->(Eof()) .and. Alltrim(SRZ->RZ_CC) == Alltrim(_cCusto)

	if SRZ->RZ_PD $ '778/779/780/814/815' .AND. SRZ->RZ_TIPO == 'FL' // Inss
			_nVlInss += SRZ->RZ_VAL 
			_ntVlInss += SRZ->RZ_VAL 
  Endif

	SRZ->(DbSkip())		
Enddo

Return

Static Function fNomecc(_pCusto)
Local _cDesc := Space(30)
If CTT->(DbSeek(xFilial("CTT") + _pCusto))	
	_cDesc := Substr(CTT->CTT_DESC01,1,20)
Endif	
Return(_cDesc)
