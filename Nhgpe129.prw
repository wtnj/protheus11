/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE129  ºAutor  ³Marcos R Roquitski  º Data ³  24/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Liquidos Estagiario + Taxa.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe129()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")                                       	
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlSalario,_nVlExtras,_nVlFerias,_nVlRct,_nVl131,_nVl132,_nVlFgts,_nVlInss,cSituacao")
SetPrvt("_ntVlSalario,_ntVlExtras,_ntVlFerias,_ntVlRct,_ntVl131,_ntVl132,_ntVlFgts,_ntVlInss")

cString   := "SRA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("liquidos dos pagamentos de terceiros folha mensal/Adiantamento")
cDesc3    := OemToAnsi("")
tamanho   := "M"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 132
//nControle := 15
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE129"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Liquidos Estagiarios"
Cabec1    := " Matr.    Nome                                     C. Custo    Descricao                  Liquido           Taxa          TOTAL"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13

Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE129"
cPerg     := "NHGPE129"


If !Pergunte(cPerg,.T.) //Ativa os parametros
	Return(nil)
Endif

wnRel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
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
cSituacao:= mv_par01		//  Situacoes

// inicio do processamento do relatório
Processa( {|| fGeraTmp() },"Gerando Dados para a Impressao Folha")
Processa( {|| fGeraTmr() },"Gerando Dados para a Impressao Rescisao")
Processa( {|| RptTmp() },"Imprimindo...")    

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool


Return


Static Function RptTmp()
Local _lRet := .F.,	_nTotG0 := _nTotLiq := _nTotGer := _nTot825 := _nTot799 := _nV799 := _nV825 := 0
Local _cMat := Space(06)
Local _lRct := .F.
Local _cCC	:= ""

Titulo := "Liquido + Taxa Estagiario: Folha / "+MesExtenso(Month(dDataBase))+" de "+Alltrim(Str(Year(dDataBase)))

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMP") 
TMP->(dbgotop())

While TMP->(!eof())

	If !( TMP->RA_SITFOLH $ cSituacao )
		TMP->(dbSkip())
		Loop
	Endif
	
	If _cCC <> TMP->RA_CC
		@ Prow()+2, 001 Psay "Centro de Custo: "+TMP->RA_CC+" - "+TMP->CTT_DESC01
		@ Prow()+1, 000 Psay __PrtThinLine()
		_cCC := TMP->RA_CC
	EndIf

	TMR->(DbGotop())
	While !TMR->(Eof()) 
		If TMR->RA_MAT == TMP->RA_MAT
			_lRct := .T.
			Exit
		Endif	
		TMR->(DbSkip())
	Enddo

	If _lRct 
		TMP->(dbSkip())
		_lRct := .F.
		Loop
	Endif

	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		@ Prow()+1, 001 Psay "Centro de Custo: "+TMP->RA_CC+" - "+TMP->CTT_DESC01
		@ Prow()+1, 000 Psay __PrtThinLine()
	Endif

	@ Prow() +1, 001 Psay TMP->RA_MAT
	@ Prow()   , 010 Psay TMP->RA_NOME
	@ Prow()   , 053 Psay TMP->RA_CC
	@ Prow()   , 063 Psay Substr(TMP->CTT_DESC01,1,24)
	                                                                                                                                   		
	_cMat := TMP->RA_MAT
	While !TMP->(Eof()) .and. TMP->RA_MAT == _cMat
		If TMP->RC_PD == '799'
			_nV799 += TMP->RC_VALOR
			_nTot799 += TMP->RC_VALOR
		Elseif 	TMP->RC_PD == '825'
			_nV825   += TMP->RC_VALOR
			_nTot825 += TMP->RC_VALOR
		Endif	
		_nTotLiq += TMP->RC_VALOR
		_nTotGer += TMP->RC_VALOR
		TMP->(DbSkip())
	Enddo

	@ Prow()   , 085 Psay _nV799   Picture "@E 99,999,999.99"		
	@ Prow()   , 100 Psay _nV825   Picture "@E 99,999,999.99"
	@ Prow()   , 115 Psay _nTotLiq Picture "@E 99,999,999.99"

	_nTotLiq := _nV799 := _nV825 := 0

Enddo

// Imprime verbas da Rescisao

DbSelectArea("TMR") 
TMR->(dbgotop())

While TMR->(!eof())

	If !( TMR->RA_SITFOLH $ cSituacao )
		TMR->(dbSkip())
		Loop
	Endif

	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	@ Prow() +1, 001 Psay TMR->RA_MAT
	@ Prow()   , 010 Psay TMR->RA_NOME
	@ Prow()   , 053 Psay TMR->RA_CC
	@ Prow()   , 063 Psay Substr(TMR->CTT_DESC01,1,24)
	                                                                                                                                   		
	_cMat := TMR->RA_MAT
	While !TMR->(Eof()) .and. TMR->RA_MAT == _cMat
		If TMR->RR_PD == '476'
			_nV799 += TMR->RR_VALOR
			_nTot799 += TMR->RR_VALOR
		Elseif 	TMR->RR_PD == '825'
			_nV825   += TMR->RR_VALOR
			_nTot825 += TMR->RR_VALOR
		Endif	
		_nTotLiq += TMR->RR_VALOR
		_nTotGer += TMR->RR_VALOR
		TMR->(DbSkip())
	Enddo

	@ Prow()   , 085 Psay _nV799   Picture "@E 99,999,999.99"		
	@ Prow()   , 100 Psay _nV825   Picture "@E 99,999,999.99"
	@ Prow()   , 115 Psay _nTotLiq Picture "@E 99,999,999.99"

	_nTotLiq := _nV799 := _nV825 := 0

Enddo

@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 065 Psay "T O T A L"
@ Prow()   , 084 PSAY Transform(_nTot799,"@E 99,999,999.99")
@ Prow()   , 099 PSAY Transform(_nTot825,"@E 99,999,999.99")
@ Prow()   , 114 PSAY Transform(_nTotGer,"@E 99,999,999.99")
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +2, 000 PSAY ""

DbSelectArea("TMP")
DbCloseArea("TMP")

DbSelectArea("TMR")
DbCloseArea("TMR")

Return


Static Function RptTmd()
Local _lRet := .F.,	_nTotG0 := _nTotLiq := _nTotGer := _nTot825 := _nTot799 := 0
Local _cMat := Space(06)
Local nZero := 0
Local _lRct := .F.
Titulo := "Liquido + Taxa Estagiario: Folha / "+MesExtenso(Month(dDataBase))+" de "+Alltrim(Str(Year(dDataBase)))

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMD") 
TMD->(dbgotop())

While TMD->(!eof())

	If !( TMD->RA_SITFOLH $ cSituacao )
		TMD->(dbSkip())
		Loop
	Endif

	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	TMR->(DbGotop())
	While !TMR->(Eof()) 
		If TMR->RA_MAT == TMD->RA_MAT
			_lRct := .T.
			Exit
		Endif	
		TMR->(DbSkip())
	Enddo

	If _lRct 
		TMD->(dbSkip())
		_lRct := .F.
		Loop
	Endif		

	@ Prow() +1, 001 Psay TMD->RA_MAT
	@ Prow()   , 010 Psay TMD->RA_NOME
	@ Prow()   , 053 Psay TMD->RA_CC
	@ Prow()   , 063 Psay Substr(TMD->CTT_DESC01,1,24)	
	                                                                                                                                   		
	_cMat := TMD->RA_MAT
	While !TMD->(Eof()) .and. TMD->RA_MAT == _cMat
		If TMD->RD_PD == '799' 
			@ Prow()   , 085 Psay TMD->RD_VALOR  Picture "@E 99,999,999.99"		
			@ Prow()   , 100 Psay nZero          Picture "@E 99,999,999.99"		
			_nTot799 += TMD->RD_VALOR
		Elseif 	TMD->RD_PD == '825'
			@ Prow()   , 085 Psay nZero          Picture "@E 99,999,999.99"		
			@ Prow()   , 100 Psay TMD->RD_VALOR  Picture "@E 99,999,999.99"
			_nTot825 += TMD->RD_VALOR
		Endif	
		_nTotLiq += TMD->RD_VALOR
		_nTotGer += TMD->RD_VALOR
		TMD->(DbSkip())
	Enddo

	@ Prow()   , 115 Psay _nTotLiq Picture "@E 99,999,999.99"
	_nTotLiq := 0

Enddo

// Imprime Rescisao

fGeraTmr()

DbSelectArea("TMR") 
TMR->(dbgotop())

While TMR->(!eof())

	If !( TMR->RA_SITFOLH $ cSituacao )
		TMR->(dbSkip())
		Loop
	Endif

	If Prow() > 56
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
	Endif

	@ Prow() +1, 001 Psay TMR->RA_MAT
	@ Prow()   , 010 Psay TMR->RA_NOME
	@ Prow()   , 053 Psay TMR->RA_CC
	@ Prow()   , 063 Psay Substr(TMR->CTT_DESC01,1,24)
	                                                                                                                                   		
	_cMat := TMR->RA_MAT
	While !TMR->(Eof()) .and. TMR->RA_MAT == _cMat
		If TMR->RR_PD == '476'
			_nV799 += TMR->RR_VALOR
			_nTot799 += TMR->RR_VALOR
		Elseif 	TMR->RR_PD == '825'
			_nV825   += TMR->RR_VALOR
			_nTot825 += TMR->RR_VALOR
		Endif	
		_nTotLiq += TMR->RR_VALOR
		_nTotGer += TMR->RR_VALOR
		TMR->(DbSkip())
	Enddo

	@ Prow()   , 085 Psay _nV799   Picture "@E 99,999,999.99"		
	@ Prow()   , 100 Psay _nV825   Picture "@E 99,999,999.99"
	@ Prow()   , 115 Psay _nTotLiq Picture "@E 99,999,999.99"

	_nTotLiq := _nV799 := _nV825 := 0

Enddo

@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +1, 065 Psay "T O T A L"
@ Prow()   , 084 PSAY Transform(_nTot799,"@E 99,999,999.99")
@ Prow()   , 099 PSAY Transform(_nTot825,"@E 99,999,999.99")
@ Prow()   , 114 PSAY Transform(_nTotGer,"@E 99,999,999.99")
@ Prow() +1, 000 PSAY __PrtThinLine()
@ Prow() +2, 000 PSAY ""


DbSelectArea("TMD")
DbCloseArea("TMD")

DbSelectArea("TMR")
DbCloseArea("TMR")

Return

Static Function fGeraTmp()
Local _dDatarq := Substr(Dtos(dDataBase),1,6)
Local _cZemp 

If Alltrim(GETMV("MV_FOLMES")) == _dDatarq 

	cQuery := "SELECT RA.RA_MAT,RA.RA_NOME,RA.RA_CC,RA.RA_SITFOLH,RC.RC_VALOR,RC.RC_PD,CT.CTT_DESC01 "
	cQuery += "FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRC') + " RC, " + RetSqlName('CTT') + " CT "
	cQuery += "WHERE RC.D_E_L_E_T_ = ' ' " 
	cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
	cQuery += "AND CT.D_E_L_E_T_ = ' ' " 
	cQuery += "AND RC.RC_PD IN ('799','825') "
	cQuery += "AND RA.RA_CATFUNC = 'G' " 
	cQuery += "AND RC.RC_MAT = RA.RA_MAT " 
	cQuery += "AND RA.RA_CC = CT.CTT_CUSTO "
	cQuery += "AND CT.CTT_CUSTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" 

	_cZemp := mv_par02

	If Mv_par02 $ '2/3/4/5' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

	Elseif Mv_par02 == '7'
    	cQuery  += " AND RA.RA_ZEMP IN ('2','4','5') "
		cQuery  += " AND RA.RA_CODFUNC <> '0321' "
		
	Endif
  
    If mv_par05 == 1
	    cQuery += "ORDER BY RA.RA_MAT "
	Else
		cQuery += "ORDER BY CT.CTT_CUSTO "
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TMP" 

Else

	cQuery := "SELECT RA.RA_MAT,RA.RA_NOME,RA.RA_CC,RA.RA_SITFOLH,RD.RD_VALOR,RD.RD_PD,CT.CTT_DESC01 "
	cQuery += "FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRD') + " RD, " + RetSqlName('CTT') + " CT "
	cQuery += "WHERE RD.D_E_L_E_T_ = ' ' " 
	cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
	cQuery += "AND CT.D_E_L_E_T_ = ' ' " 
	cQuery += "AND RD.RD_PD IN ('799','825') "
	cQuery += "AND RA.RA_CATFUNC = 'G' " 	 
	cQuery += "AND RD.RD_MAT = RA.RA_MAT " 
	cQuery += "AND RA.RA_CC = CT.CTT_CUSTO "
	cQuery += "AND CT.CTT_CUSTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" 
	cQuery += "AND RD.RD_DATARQ = '" + _dDatarq + "' " 

	_cZemp := mv_par02

	If Mv_par02 $ '2/3/4/5' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

	Elseif Mv_par02 == '7'
    	cQuery  += " AND RA.RA_ZEMP IN ('2','4','5') "
		cQuery  += " AND RA.RA_CODFUNC <> '0321' "
		
	Endif

	If mv_par05 == 1
	    cQuery += "ORDER BY RA.RA_MAT "
	Else
		cQuery += "ORDER BY CT.CTT_CUSTO "
	EndIf

	TCQUERY cQuery NEW ALIAS "TMD" 

Endif	

Return


Static Function fGeraTmr()
Local _dDatarq := Substr(Dtos(dDataBase),1,6)
Local _cZemp 

	cQuery := "SELECT RA.RA_MAT,RA.RA_NOME,RA.RA_CC,RA.RA_SITFOLH,RR.RR_VALOR,RR.RR_PD,CT.CTT_DESC01 "
	cQuery += "FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRR') + " RR, " + RetSqlName('CTT') + " CT "
	cQuery += "WHERE RR.D_E_L_E_T_ = ' ' " 
	cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
	cQuery += "AND CT.D_E_L_E_T_ = ' ' " 
	cQuery += "AND RR.RR_PD IN ('476','825') "
	cQuery += "AND RA.RA_CATFUNC = 'G' " 	 
	cQuery += "AND RR.RR_MAT = RA.RA_MAT " 
	cQuery += "AND RA.RA_CC = CT.CTT_CUSTO " 
	cQuery += "AND CT.CTT_CUSTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" 
	cQuery += "AND SUBSTRING(RR.RR_DATA,1,6) = '" + _dDatarq + "' " 

	_cZemp := mv_par02

	If Mv_par02 $ '2/3/4/5' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

	Elseif Mv_par02 == '7'
    	cQuery  += " AND RA.RA_ZEMP IN ('2','4','5') "
		cQuery  += " AND RA.RA_CODFUNC <> '0321' "
		
	Endif

	If mv_par05 == 1
	    cQuery += "ORDER BY RA.RA_MAT "
	Else
		cQuery += "ORDER BY CT.CTT_CUSTO "
	EndIf

	TCQUERY cQuery NEW ALIAS "TMR" 

Return
