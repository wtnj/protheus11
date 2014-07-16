/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN063  ºAutor  ³Marcos R Roquitski  º Data ³  02/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de valores devidos no vencimento.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#include "topconn.ch"

User Function Nhfin063()   

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,LPRIMEIRO,CQUERY,")

cSavCur1  := "";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont    := "";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem    := 0
tamanho   := "G"
limite    := 220
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cRodaTxt  := ""
nCntImpr  := 0
titulo    := "Valores devidos no Vencimento"
cDesc1    := " "
cDesc2    := " "
cDesc3    := " "
cString   := "SZ4"
nTipo     := 0
nomeprog  := "NHFIN063"
cPerg     := "NHFI63"
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
wnrel:= "NHFIN063"

SetPrint("SZ3",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")


If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

rptStatus({||Gerando()},"Gerando Base para o Relatorio...")

If Empty(TMP->ZT_NUMERO)
   MsgBox("Nenhum Ocorrencia ","Atençao","ALERT")  
   DbSelectArea("TMP")
   DbCloseArea("TMP")
   Return
Endif



rptStatus({||Imprime()},"Imprimindo...")

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
DbSelectArea("TMP")
DbCloseArea("TMP")
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

cQuery := "SELECT * "
//cQuery += "SZ4.Z4_ADIANTA, SZ4.Z4_RESTITU, SZ4.Z4_REMB, SZ3.Z3_ADTDAT, SZ3.Z3_ACTDAT, SZ3.Z3_FINDAT "
cQuery += "FROM " + RetSqlName( 'SZT' ) + " SZT "
cQuery += "WHERE SZT.D_E_L_E_T_ <> '*' "
cQuery += "AND SZT.ZT_NUMERO BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "

TCQUERY cQuery NEW ALIAS "TMP"                      
TcSetField("TMP","ZT_DATA","D") // Muda a data de string para date.


DbSelectArea("TMP")
Return


Static Function Imprime()
Local _nZxVlpago := 0, _cNumero, _cNmbanco := Space(40)
SZX->(DbSetOrder(1))
SA6->(DbSetOrder(1))

TMP->(Dbgotop())
                          
Cabec1    := ""
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
_cNumero := TMP->ZT_NUMERO

While !TMP->(eof())
	
	_cNmbanco := Space(40)
	SA6->(DbSeek(xFilial("SA6")+SZT->ZT_BANCO+SZT->ZT_AGENCI+SZT->ZT_CONTA))
	If SA6->(Found())
		_cNmBanco := "( "+Alltrim(SA6->A6_NOME)+" )"
	Endif


	If _cNumero <> TMP->ZT_NUMERO
		nPag := nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		_cNumero := TMP->ZT_NUMERO
	Endif

	_nZxVlpago := 0
	SZX->(DbSeek(xFilial("SZX") +  TMP->ZT_NUMERO))
	If SZX->(Found())
		_nZxVlpago := SZX->ZX_VLPAGO
	Endif
	@ Prow() + 1, 000 Psay "CONTRATO     : " + TMP->ZT_CONTRA + "  NUMERO: "+TMP->ZT_NUMERO
	@ Prow() + 1, 000 Psay "BANCO        : " + TMP->ZT_BANCO + " AGENCIA : "+TMP->ZT_AGENCI + " C\C: "+TMP->ZT_CONTA + " "+_cNmBanco
	@ Prow() + 1, 000 Psay "VALOR        : " + TRANSFORM(TMP->ZT_VALOR,"@E 9999,999,999,999.99")+ "      DESCRICAO DO BEM :"+TMP->ZT_DESCBEM
	@ Prow() + 1, 000 Psay "PRAZO        : " + TRANSFORM(TMP->ZT_PARCELA,"999999")
	@ Prow() + 1, 000 Psay "PARCELA      : " + TRANSFORM(SZX->ZX_VLPAGO,"@E 999,999,999,999.99")
	@ Prow() + 1, 000 Psay "DATA OPERACAO: " + DTOC(TMP->ZT_DATA)
	@ Prow() + 1, 000 Psay "TAXA JUROS   : " + TRANSFORM(TMP->ZT_TAXA1,"@E 999.9999")+"% a.a "+ TRANSFORM(TMP->ZT_TAXA,"@E 999.9999")+"% a.m "+ TRANSFORM(TMP->ZT_TAXA2,"@E 999.9999")+"% a.d "

	@ Prow() + 1,000 Psay __PrtThinLine()
	@ Prow() + 1, 000 Psay "Vencto        N.Parc            Amort.Princ               Juros             Vl.Pago     Dt.Pagto            Saldo Dev."
	@ Prow() + 1,000 Psay __PrtThinLine()

	While !SZX->(Eof()) .AND. SZX->ZX_NUMERO == TMP->ZT_NUMERO

		If Mv_Par07 == 1 .AND. SZX->ZX_DTPGTO == Ctod(Space(08))
			SZX->(DbSkip())
 			Loop
		Endif

		If Mv_Par07 == 2 .AND. SZX->ZX_DTPGTO <> Ctod(Space(08))
			SZX->(DbSkip())
 			Loop
		Endif
		
		IF SZX->ZX_VENCTO >= Mv_par05 .AND.SZX->ZX_VENCTO <= Mv_par06

			If SZX->ZX_PARCELA >= Mv_par03 .AND. SZX->ZX_PARCELA <= Mv_Par04

				If Prow() > 56
					nPag := nPag + 1
					Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
					@ Prow() + 1,000 Psay __PrtThinLine()
					@ Prow() + 1,000 Psay "Vencto        N.Parc            Amort.Princ               Juros             Vl.Pago     Dt.Pagto            Saldo Dev."
					@ Prow() + 1,000 Psay __PrtThinLine()
				Endif
				@ Prow() + 1, 000 Psay SZX->ZX_VENCTO
				@ Prow()    , 015 Psay SZX->ZX_PARCELA Picture "@E 99999"
				@ Prow()    , 025 Psay SZX->ZX_VLPRINC Picture "@E 999,999,999,999.99"
				@ Prow()    , 045 Psay SZX->ZX_VLJUROS Picture "@E 999,999,999,999.99"
				@ Prow()    , 065 Psay SZX->ZX_VLPAGO  Picture "@E 999,999,999,999.99"
				@ Prow()    , 088 Psay SZX->ZX_DTPGTO
				@ Prow()    , 100 Psay SZX->ZX_SLDDEV Picture "@E 999,999,999,999.99"
			Endif
		Endif			
		SZX->(DbSkip())

	Enddo
	@ Prow() + 1,000 Psay __PrtThinLine()

	TMP->(Dbskip())
Enddo
@ Prow() + 1,000 Psay __PrtThinLine()

Return
