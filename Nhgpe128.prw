/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE128  ºAutor  ³Marcos R Roquitski  º Data ³  18/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Liquidos Folha mensal e Adiantamento terceiros.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe128()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlSalario,_nVlExtras,_nVlFerias,_nVlRct,_nVl131,_nVl132,_nVlFgts,_nVlInss")
SetPrvt("_ntVlSalario,_ntVlExtras,_ntVlFerias,_ntVlRct,_ntVl131,_ntVl132,_ntVlFgts,_ntVlInss")

cString   := "ZRA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("liquidos dos pagamentos de terceiros folha mensal/Adiantamento")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE128"
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
wnrel     := "NHGPE128"
_cPerg    := "NHGP125"

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
TMP->(DbCloseArea())

DbSelectArea("TMD")
TMD->(DbCloseArea())

DbSelectArea("TMT")
TMT->(DbCloseArea())

Return


Static Function RptDet()
Local _lRet := .F.,	_nTotG0 := _nTotLiq := _nTotGer := 0

If MV_PAR05==1
	titulo    := "Liquido terceiro: Pagamento "+MesExtenso(Month(dDataBase))+"/"+Alltrim(Str(Year(dDataBase)))+ '  -  Banco: '+mv_par01+ ' Agencia: '+mv_par02 + ' Conta:' + mv_par03
Else
	titulo    := "Liquido terceiro: Adiantamento "+MesExtenso(Month(dDataBase))+"/"+Alltrim(Str(Year(dDataBase))) + '  -  Banco: '+mv_par01+ ' Agencia: '+mv_par02 + ' Conta:' + mv_par03
Endif

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
		@ Prow()   , 100 PSAY TMP->ZRC_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TMP->ZRC_VALOR
		_nTotGer += TMP->ZRC_VALOR
		TMP->(DbSkip())
	
	Enddo
	If _nTotLiq > 0
		@ Prow() +1, 000 PSAY __PrtThinLine()
		@ Prow() +1, 070 Psay "Total Depositos:"
		@ Prow()   , 100 PSAY Transform(_nTotLiq,"@E 99,999,999.99")
		@ Prow() +1, 000 PSAY __PrtThinLine()
		@ Prow() +2, 000 PSAY ""
	Endif	

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
		@ Prow()   , 100 PSAY TMT->ZRC_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TMT->ZRC_VALOR
		_nTotGer += TMT->ZRC_VALOR
		TMT->(DbSkip())
	
	Enddo
	If _nTotLiq > 0
		@ Prow() +1, 000 PSAY __PrtThinLine()
		@ Prow() +1, 070 Psay "Total TED:"
		@ Prow()   , 100 PSAY Transform(_nTotLiq,"@E 99,999,999.99")
		@ Prow() +1, 000 PSAY __PrtThinLine()
		@ Prow() +2, 000 PSAY ""
	Endif	

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
		@ Prow()   , 100 PSAY TMD->ZRC_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TMD->ZRC_VALOR
		_nTotGer += TMD->ZRC_VALOR
		TMD->(DbSkip())
	
	Enddo
	If _nTotLiq > 0
		@ Prow() +1, 000 PSAY __PrtThinLine()
		@ Prow() +1, 070 Psay "Total DOC:"
		@ Prow()   , 100 PSAY Transform(_nTotLiq,"@E 99,999,999.99")
		@ Prow() +1, 000 PSAY __PrtThinLine()
	Endif	

	@ Prow() +2, 000 PSAY ""
	@ Prow() +1, 000 PSAY __PrtThinLine()
	@ Prow() +1, 070 Psay "Total Geral:"
	@ Prow()   , 100 PSAY Transform(_nTotGer,"@E 99,999,999.99")
	@ Prow() +1, 000 PSAY __PrtThinLine()

Endif

Return


Static Function fTmpDep()

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RC.ZRC_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRC') + " RC "
cQuery += "WHERE RC.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"	
If MV_PAR05==1
	cQuery += "AND RC.ZRC_PD = '799' "
Else
	cQuery += "AND RC.ZRC_PD = '508' "
Endif	

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif

cQuery += "AND RA.ZRA_FIM = ' ' " 
cQuery += "AND RA.ZRA_BANCO = '001' " 
cQuery += "AND RC.ZRC_MAT = RA.ZRA_MAT " 
cQuery += "ORDER BY RA.ZRA_MAT,RA.ZRA_TIPOFJ "

TCQUERY cQuery NEW ALIAS "TMP" 


cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RC.ZRC_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRC') + " RC "
cQuery += "WHERE RC.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"	
If MV_PAR05==1
	cQuery += "AND RC.ZRC_PD = '799' "
Else
	cQuery += "AND RC.ZRC_PD = '508' "
Endif	

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif


cQuery += "AND RA.ZRA_FIM = ' ' " 
cQuery += "AND RA.ZRA_BANCO <> '001' " 
cQuery += "AND RA.ZRA_BANCO <> '' "
cQuery += "AND RC.ZRC_VALOR >= 2000 " 
cQuery += "AND RC.ZRC_MAT = RA.ZRA_MAT " 
cQuery += "ORDER BY RA.ZRA_MAT,RA.ZRA_TIPOFJ "

TCQUERY cQuery NEW ALIAS "TMT" 

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RC.ZRC_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRC') + " RC "
cQuery += "WHERE RC.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' "
cQuery += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"	
If MV_PAR05==1
	cQuery += "AND RC.ZRC_PD = '799' "
Else
	cQuery += "AND RC.ZRC_PD = '508' "
Endif	


If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA
Endif

cQuery += "AND RA.ZRA_FIM = ' ' "
cQuery += "AND RA.ZRA_BANCO <> '001' "
cQuery += "AND RA.ZRA_BANCO <> '' "
cQuery += "AND RC.ZRC_VALOR < 2000 " 
cQuery += "AND RC.ZRC_MAT = RA.ZRA_MAT " 
cQuery += "ORDER BY RA.ZRA_MAT,RA.ZRA_TIPOFJ "

TCQUERY cQuery NEW ALIAS "TMD" 

Return
