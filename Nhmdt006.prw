/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMDT006  ºAutor  ³Marcos R. Roquitski º Data ³  30/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhmdt006()

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO,NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC,CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Prestadores de Servicos"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "ZBW"
nTipo     := 0
nomeprog  := "NHMDT006"
cPerg     := "NHMDT006"
nPag      := 1
M_PAG     := 1 
tot01     := 0 
tot02     := 0 
tot03     := 0 
tot04     := 0 

If !Pergunte(cPerg,.T.) //ativa os parametros
	Return(nil)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                                  ³
//³ mv_par01     Codigo do Funcionario                           ³
//³ mv_par02     Periodo de                                      ³
//³ mv_par03     Periodo ate                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "NHMDT006"

SetPrint("ZBW",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Imprime()
Local _lRet := .T.
Local cFilterUser:=aReturn[7]
ZBW->(Dbgotop())
Cabec1 := " Codigo   Nome                                    R.G          CPF             ASO           INTEGRACAO  Fornecedor    Nome Fornecedor                                      Funcao"
//        "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//        "         1         2         3         4         5         6         7         8         9         10        11        12        13       14        15        16        17
If mv_par01 == 1
	Titulo += ":(ASO/INTEGRACAO Vencidos)"

Else
	Titulo += ":(Geral)"
	
Endif



Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)

DbSelectarea("ZBW")
Set Filter to ZBW->ZBW_FORNEC >= mv_par02 .AND. ZBW->ZBW_FORNEC <= mv_par03

ZBW->(DbSetOrder(1)) //Codigo do Fornecedor
SA2->(DbSetOrder(1)) // filial + cod + loja
ZBW->(DbGotop())
While ZBW->(!EOF())

	If Prow() > 56
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
	Endif

	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	If Mv_par01 == 1
		If (ZBW->ZBW_DTASO+365 < Date()) .or. (ZBW->ZBW_VLINTE+365 < Date()) // Calcula vencimento Integracao e ASO      
			lRet := .T.
		Else
			lRet := .F.		
		Endif
	Else
		lRet := .T.	
	Endif

	If lRet 

		@ Prow() + 1, 001 Psay ZBW->ZBW_COD
		@ Prow()    , 010 Psay ZBW->ZBW_NOME
		@ Prow()    , 051 Psay ZBW->ZBW_RG
		@ Prow()    , 064 Psay TRANSFORM(ZBW->ZBW_CPF,"@R 999.999.999-99")
		@ Prow()    , 080 Psay ZBW->ZBW_DTASO
		@ Prow()    , 094 Psay ZBW->ZBW_VLINTE
		@ Prow()    , 106 Psay ZBW->ZBW_FORNEC + ' ' +ZBW->ZBW_LOJA
		@ Prow()    , 120 Psay ZBW->ZBW_NOMFOR
		@ Prow()    , 173 Psay ZBW->ZBW_FUNCAO
			
	Endif
	ZBW->(Dbskip())

Enddo
@ Prow() + 1,000 Psay __PrtThinLine()

set filter to
SBW->(DbGotop())
	
Return
