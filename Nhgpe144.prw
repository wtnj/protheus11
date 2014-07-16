/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE144  ºAutor  ³Marcos R Roquitski  º Data ³  17/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Liquidos 13o. Salario - 1a. Parcela           .º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe144()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlSalario,_nVlExtras,_nVlFerias,_nVlRct,_nVl131,_nVl132,_nVlFgts,_nVlInss")
SetPrvt("_ntVlSalario,_ntVlExtras,_ntVlFerias,_ntVlRct,_ntVl131,_ntVl132,_ntVlFgts,_ntVlInss")

cString   := "ZRA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("liquidos dos pagamentos de terceiros 13o. Salario - 1a. Parcela")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE144"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Folha de pagamento Liquidos Terceiros"
Cabec1    := " Matr.    Favorecido                                 CPF/CGC          Bco  Agencia   C.Corrente           Liquido"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13

Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE144"
_cPerg    := "NHGP125"
                              
wnRel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
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
Processa( {||  fTmpDep() },"Gerando Dados para a Impressao")
                 
//inicio da impressao
Processa( {|| RptDet() },"Imprimindo...")
     
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DbSelectArea("TMP")
DbCloseArea("TMP")

DbSelectArea("TMD")
DbCloseArea("TMD")

DbSelectArea("TMT")
DbCloseArea("TMT")

Return


Static Function RptDet()
Local _lRet := .F.,	_nTotG0 := _nTotLiq := _nTotGer := 0

Titulo  := "Liquido terceiro: 13o. Salario - 1a. Parcela "+MesExtenso(Month(dDataBase))+"/"+Alltrim(Str(Year(dDataBase)))

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TMP") 
dbgotop()
If TMP->(Recno() > 0)

	While TMP->(!eof())

		If Prow() > 56
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		Endif
	
		@ Prow() +1, 001 Psay TMP->ZRA_MAT
		@ Prow()   , 010 Psay TMP->ZRA_FAVORE
		@ Prow()   , 053 Psay TMP->ZRA_CPFCGC
		@ Prow()   , 070 Psay TMP->ZRA_BANCO
		@ Prow()   , 075 Psay TMP->ZRA_AGENCI	
		@ Prow()   , 085 Psay TMP->ZRA_CONTA
		@ Prow()   , 100 PSAY TMP->ZRE_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TMP->ZRE_VALOR
		_nTotGer += TMP->ZRE_VALOR
		TMP->(DbSkip())
	
	Enddo
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +1, 070 Psay "Total Depositos:"
	@ Prow()   , 100 PSAY Transform(_nTotLiq,"@E 99,999,999.99")
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +2, 000 PSAY ""

Endif

// TED
DbSelectArea("TMT") 
dbgotop()
_nTotLiq := 0
If TMT->(Recno()) > 0

	While TMT->(!eof())

		If Prow() > 56
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		Endif
	
		@ Prow() +1, 001 Psay TMT->ZRA_MAT
		@ Prow()   , 010 Psay TMT->ZRA_FAVORE
		@ Prow()   , 053 Psay TMT->ZRA_CPFCGC
		@ Prow()   , 070 Psay TMT->ZRA_BANCO
		@ Prow()   , 075 Psay TMT->ZRA_AGENCI	
		@ Prow()   , 085 Psay TMT->ZRA_CONTA
		@ Prow()   , 100 PSAY TMT->ZRE_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TMT->ZRE_VALOR
		_nTotGer += TMT->ZRE_VALOR
		TMT->(DbSkip())
	
	Enddo
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +1, 070 Psay "Total TED:"
	@ Prow()   , 100 PSAY Transform(_nTotLiq,"@E 99,999,999.99")
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +2, 000 PSAY ""

Endif


// DOC
DbSelectArea("TMD") 
dbgotop()
_nTotLiq := 0

If TMD->(Recno()) > 0

	While TMD->(!eof())

		If Prow() > 56
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		Endif
	
		@ Prow() +1, 001 Psay TMD->ZRA_MAT
		@ Prow()   , 010 Psay TMD->ZRA_FAVORE
		@ Prow()   , 053 Psay TMD->ZRA_CPFCGC  
		@ Prow()   , 070 Psay TMD->ZRA_BANCO
		@ Prow()   , 075 Psay TMD->ZRA_AGENCI	
		@ Prow()   , 085 Psay TMD->ZRA_CONTA
		@ Prow()   , 100 PSAY TMD->ZRE_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TMD->ZRE_VALOR
		_nTotGer += TMD->ZRE_VALOR
		TMD->(DbSkip())
	
	Enddo
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +1, 070 Psay "Total DOC:"
	@ Prow()   , 100 PSAY Transform(_nTotLiq,"@E 99,999,999.99")
	@ Prow() +1, 000 PSAY __PrtThinLine()

	@ Prow() +2, 000 PSAY ""
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +1, 070 Psay "Total Geral:"
	@ Prow()   , 100 PSAY Transform(_nTotGer,"@E 99,999,999.99")
	@ Prow() +1, 000 PSAY __PrtThinLine()

Endif

Return


Static Function fTmpDep()

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RE.ZRE_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRE') + " RE "
cQuery += "WHERE RE.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RE.ZRE_PD = '799' "
cQuery += "AND RA.ZRA_FIM = ' ' " 
cQuery += "AND RA.ZRA_BANCO = '001' " 
cQuery += "AND RE.ZRE_MAT = RA.ZRA_MAT " 
cQuery += "ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TMP" 


cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RE.ZRE_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRE') + " RE "
cQuery += "WHERE RE.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RE.ZRE_PD = '799' "
cQuery += "AND RA.ZRA_FIM = ' ' " 
cQuery += "AND RA.ZRA_BANCO <> '001' " 
cQuery += "AND RA.ZRA_BANCO <> '' "
cQuery += "AND RE.ZRE_VALOR >= 5000 " 
cQuery += "AND RE.ZRE_MAT = RA.ZRA_MAT " 
cQuery += "ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TMT" 

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RE.ZRE_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRE') + " RE "
cQuery += "WHERE RE.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' "
cQuery += "AND RE.ZRE_PD = '799' "
cQuery += "AND RA.ZRA_FIM = ' ' "
cQuery += "AND RA.ZRA_BANCO <> '001' "
cQuery += "AND RA.ZRA_BANCO <> '' "
cQuery += "AND RE.ZRE_VALOR < 5000 " 
cQuery += "AND RE.ZRE_MAT = RA.ZRA_MAT " 
cQuery += "ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TMD" 

Return
