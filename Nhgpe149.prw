/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE149  ºAutor  ³Marcos R Roquitski  º Data ³  17/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Liquidos PPR.                                 .º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³WHB                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhgpe149()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,aChave,nTipo,aReturn,NOMEPROG,ALINHA,NLASTKEY,LEND")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,CCOMPAC,CNORMAL,CQUERY,TITULO,CABEC1")
SetPrvt("dDataRef,cFilDe,cFilAte,cCcDe,cCcAte,cMatDe,cMatAte,cNomeDe,cNomeAte,nAnaSin,nGerRes,lImpNiv,cCateg")
SetPrvt("_nVlSalario,_nVlExtras,_nVlFerias,_nVlRct,_nVl131,_nVl132,_nVlFgts,_nVlInss")
SetPrvt("_ntVlSalario,_ntVlExtras,_ntVlFerias,_ntVlRct,_ntVl131,_ntVl132,_ntVlFgts,_ntVlInss")

cString   := "ZRA"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir")
cDesc2    := OemToAnsi("liquidos dos pagamentos do PPR")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
//nControle := 15
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHGPE149"
aLinha    := {}
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "PPR Liquidos Terceiros: "
Cabec1    := " Matr.    Favorecido                                 CPF/CGC          Bco  Agencia   C.Corrente           Liquido"
//           "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           "         1         2         3         4         5         6         7         8         9         10        11        12        13

Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHGPE149"
_cPerg    := "NHGPE149"
                     
If !Pergunte(_cPerg,.T.) //Ativa os parametros
	Return(nil)
Endif
                  
                              
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
titulo  := "PPR Liquido terceiro: Pagamento "+MesExtenso(Month(dDataBase))+"/"+Alltrim(Str(Year(dDataBase)))+ '  -  Banco: '+mv_par01+ ' Agencia: '+mv_par02 + ' Conta:' + mv_par03

// inicio do processamento do relatório
Processa( {||  fTTMPDep() },"Gerando Dados para a Impressao")
                 
//inicio da impressao
Processa( {|| RptDet() },"Imprimindo...")
     
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DbSelectArea("TTMP")
TTMP->(DbCloseArea())

DbSelectArea("TTMD")
TTMD->(DbCloseArea())

DbSelectArea("TTMT")
TTMT->(DbCloseArea())

Return


Static Function RptDet()
Local _lRet := .F.,	_nTotG0 := _nTotLiq := _nTotGer := 0

cCusto := Space(10)
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
DbSelectArea("TTMP") 
dbgotop()
If TTMP->(Recno() > 0)

	While TTMP->(!eof())

		If Prow() > 56
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		Endif
	
		@ Prow() +1, 001 Psay TTMP->ZRA_MAT
		@ Prow()   , 010 Psay TTMP->ZRA_FAVORE
		@ Prow()   , 053 Psay TTMP->ZRA_CPFCGC
		@ Prow()   , 070 Psay TTMP->ZRA_BANCO
		@ Prow()   , 075 Psay TTMP->ZRA_AGENCI	
		@ Prow()   , 085 Psay TTMP->ZRA_CONTA
		@ Prow()   , 100 PSAY TTMP->ZRP_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TTMP->ZRP_VALOR
		_nTotGer += TTMP->ZRP_VALOR
		TTMP->(DbSkip())
	
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
DbSelectArea("TTMT") 
dbgotop()
_nTotLiq := 0
If TTMT->(Recno()) > 0

	While TTMT->(!eof())

		If Prow() > 56
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		Endif
	
		@ Prow() +1, 001 Psay TTMT->ZRA_MAT
		@ Prow()   , 010 Psay TTMT->ZRA_FAVORE
		@ Prow()   , 053 Psay TTMT->ZRA_CPFCGC
		@ Prow()   , 070 Psay TTMT->ZRA_BANCO
		@ Prow()   , 075 Psay TTMT->ZRA_AGENCI	
		@ Prow()   , 085 Psay TTMT->ZRA_CONTA
		@ Prow()   , 100 PSAY TTMT->ZRP_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TTMT->ZRP_VALOR
		_nTotGer += TTMT->ZRP_VALOR
		TTMT->(DbSkip())
	
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
DbSelectArea("TTMD") 
dbgotop()
_nTotLiq := 0

If TTMD->(Recno()) > 0

	While TTMD->(!eof())

		If Prow() > 56
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 0)
		Endif
	
		@ Prow() +1, 001 Psay TTMD->ZRA_MAT
		@ Prow()   , 010 Psay TTMD->ZRA_FAVORE
		@ Prow()   , 053 Psay TTMD->ZRA_CPFCGC  
		@ Prow()   , 070 Psay TTMD->ZRA_BANCO
		@ Prow()   , 075 Psay TTMD->ZRA_AGENCI	
		@ Prow()   , 085 Psay TTMD->ZRA_CONTA
		@ Prow()   , 100 PSAY TTMD->ZRP_VALOR  Picture "@E 99,999,999.99"
		_nTotLiq += TTMD->ZRP_VALOR
		_nTotGer += TTMD->ZRP_VALOR
		TTMD->(DbSkip())
	
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

Static Function fTTMPDep()

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RP.ZRP_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRP') + " RP "
cQuery += "WHERE RP.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RP.ZRP_PD = '799' "
cQuery += "AND RA.ZRA_FIM = ' ' " 
cQuery += "AND RA.ZRA_BANCO = '001' " 
cQuery += "AND RP.ZRP_MAT = RA.ZRA_MAT " 
cQuery += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"	

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif


cQuery += "ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TTMP" 


cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RP.ZRP_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRP') + " RP "
cQuery += "WHERE RP.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RP.ZRP_PD = '799' "
cQuery += "AND RA.ZRA_FIM = ' ' " 
cQuery += "AND RA.ZRA_BANCO <> '001' " 
cQuery += "AND RA.ZRA_BANCO <> '' "
cQuery += "AND RP.ZRP_VALOR >= 2000 " 
cQuery += "AND RP.ZRP_MAT = RA.ZRA_MAT " 
cQuery += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"	

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif

cQuery += "ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TTMT" 

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,RP.ZRP_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZRP') + " RP "
cQuery += "WHERE RP.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' "
cQuery += "AND RP.ZRP_PD = '799' "
cQuery += "AND RA.ZRA_FIM = ' ' "
cQuery += "AND RA.ZRA_BANCO <> '001' "
cQuery += "AND RA.ZRA_BANCO <> '' "
cQuery += "AND RP.ZRP_VALOR < 2000 " 
cQuery += "AND RP.ZRP_MAT = RA.ZRA_MAT " 
cQuery += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"	

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif



cQuery += "ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TTMD"

Return