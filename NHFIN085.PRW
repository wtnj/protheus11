#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN085     ºAutor  ³Felipe Ciconini  º Data ³  30/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³NOTAS FISCAIS EM ABERTO VENCIDAS                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function NHFIN085

cString		:= "SE1"
cDesc1		:= "Este relatorio tem como objetivo Imprimir"
cDesc2		:= ""
cDesc3		:= ""
tamanho		:= "G"
limite		:= 132
aReturn		:= {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog	:= "NHFIN085"
nLastKey	:= 0
titulo		:= OemToAnsi("NOTAS FISCAIS EM ABERTO VENCIDAS")
cabec1		:= "Data Base: "+DtoC(dDataBase)
cabec2		:= "PREFIXO      NF       PARCELA    COD CLIENTE   LOJA   NOME                                      EMISSAO    VENC ORIGINAL   DATA PAGAMENTO   VALOR LIQUIDO    DIAS           JUROS       VALOR CORRIGIDO"
cCancel		:= "***** CANCELADO PELO OPERADOR *****"
_nPag		:= 1
M_PAG		:= 1
wnrel		:= "NHFIN085"
_cPerg		:= "NHFIN085"
aOrd      := {OemToAnsi("Por Cliente"),OemToAnsi("Por Vencimento")}


Pergunte(_cPerg,.F.)
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,tamanho)

if nLastKey == 27
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

nTipo		:= IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver		:= ReadDriver()
cCompac		:= aDriver[1]

Processa( {|| Gerando() },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

Set Filter to
If aReturn[5] == 1
	Set Printer to
	Commit
	Ourspool(wnrel)
EndIf
MS_FLUSH()

Return

Static Function Gerando ()
Local cQuery

	//------------------
	//MONTANDO A QUERY  
	//------------------
	
	
	cQuery := "SELECT SE1.E1_PARCELA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_EMISSAO, SE1.E1_BAIXA, "
	cQuery += " SE1.E1_VENCREA, SE1.E1_SALDO, SA1.A1_NOME, SE1.E1_CLIENTE, SE1.E1_LOJA "
	cQuery += " FROM "+RetSqlName('SE1')+" SE1, "+RetSqlName('SA1')+" SA1"
	cQuery += " WHERE "+DtoS(dDataBase)+" >= SE1.E1_VENCREA "
	cQuery += " AND SE1.E1_SALDO > 0 "
	cQuery += " AND SE1.E1_CLIENTE = SA1.A1_COD "  
	cQuery += " AND SE1.E1_LOJA = SA1.A1_LOJA "  
	cQuery += " AND SE1.E1_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND SE1.E1_VENCREA BETWEEN '" + DtoS(mv_par06) + "' AND '" + DtoS(mv_par07) + "'"
	cQuery += " AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	If aReturn [8] == 1
		cQuery += " ORDER BY SE1.E1_CLIENTE, SE1.E1_LOJA ASC"
	Else
		cQuery += " ORDER BY SE1.E1_VENCREA ASC"
	EndIf
		
	MemoWrit('C:/TEMP/NHFIN085.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1"
	TRA1->(DbGoTop())
	TcSetField("TRA1","E1_VENCREA","D")
	TcSetField("TRA1","E1_EMISSAO","D")
	TcSetField("TRA1","E1_BAIXA","D")	
	
Return

Static Function ValDtRet()
	If !Empty(dDtRet)
		If dDtRet < dDataBase
			Alert('Data de Retirada deve ser igual ou maior que a data de hoje!')
			Return .F.
		EndIf
	EndIF
Return .T.

Static Function RptDetail()
Local _nVcto		:= 0
Local _nCli			:= 0
Local nTotCli		:= 0 //TOTAL POR CLIENTE
Local nTotSalCli	:= 0 //SALDO TOTAL POR CLIENTE
Local nTotJurCli	:= 0 //JUROS TOTAL POR CLIENTE
Local nTotal		:= 0 //TOTAL GERAL
Local nTotalSal		:= 0 //SALDO TOTAL
Local nTotalJur		:= 0 //JUROS TOTAL
Local cNomeCli  	:= ""
Local cLojaCli		:= ""
Local cDiaVcto  	:= ""

Titulo := OemToAnsi("CÁLCULO DE JUROS")

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

While TRA1->(!Eof())
	nTotCli	   := 0
	cNomeCli   := ""
	cDiaVcto   := ""
	nTotSalCli := 0	
	nTotJurCli := 0
	
	_nVcto	:= TRA1->E1_VENCREA
	_nCli	:= TRA1->E1_CLIENTE+TRA1->E1_LOJA
	If aReturn [8] == 1
		While TRA1->E1_CLIENTE+TRA1->E1_LOJA == _nCli //WHILE PARA FAZER A QUEBRA DA ORDEM SELECIONADA (CLIENTE/VENCIMENTO)
			nDias      := dDataBase - TRA1->E1_VENCREA //CALCULO DOS DIAS ATRASADOS
			nJuram     := mv_par03/100 //CALCULO DO JUROS POR DIA COM A VARIAVEL DA PERGUNTA
			nLiq	   := TRA1->E1_SALDO
			nValcor    := nLiq*((1+nJuram)^(nDias/30)) //SE O JUROS FOR ZERO, O nJuram VAI SOMAR COM O 1 E ELEVADO A POTENCIA, DARÁ 1. LOGO NAO MUDARA NO VALOR TOTAL
			nValjur    := nValcor - nLiq
			nTotCli    += nValcor
			nTotSalCli += nLiq
			nTotJurCli += nValjur
			cNomeCli   := TRA1->A1_NOME
			
		  
			If Prow() > 55
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
			EndIf
			
			@Prow()+1,002 psay TRA1->E1_PREFIXO //PREFIXO NOTA FISCAL
			@Prow()  ,010 psay TRA1->E1_NUM //NOTA FISCAL
			@Prow()  ,025 psay TRA1->E1_PARCELA //NUMERO PARCELA
			@Prow()  ,035 psay TRA1->E1_CLIENTE //CODIGO CLIENTE
			@Prow()  ,048 psay TRA1->E1_LOJA //CODIGO LOJA CLIENTE
			@Prow()  ,054 psay TRA1->A1_NOME //CAUSA SOCIAL CLIENTE
			@Prow()  ,094 psay TRA1->E1_EMISSAO //DATA DE EMISSAO
			@Prow()  ,108 psay TRA1->E1_VENCREA //DATA VENCIMENTO REAL
			@Prow()  ,124 psay TRA1->E1_BAIXA //DATA PAGAMENTO
			@Prow()  ,140 psay TRA1->E1_SALDO Picture "@e 999,999,999.99" //VALOR LIQUIDO
			@Prow()  ,158 psay nDias //DIAS ATRASADO
			@Prow()  ,165 psay nValjur Picture "@e 999,999,999.99" //VALOR DO JUROS
			@Prow()  ,181 psay nValcor Picture "@e 999,999,999.99"//VALOR TOTAL COM JUROS
			TRA1->(DbSkip())
		EndDo	
		nTotalSal  += nLiq //SOMA VALOR LIQUIDO TOTAL
		nTotalJur  += nValjur //SOMA JUROS TOTAL
		nTotal     += nTotCli //SOMA TOTAL
		
		@Prow()+2,001 psay "Total do Cliente:" + cNomeCli
		@Prow()  ,140 psay nTotSalCli Picture "@e 999,999,999.99"
		@Prow()  ,165 psay nTotJurCli Picture "@e 999,999,999.99"
		@Prow()  ,181 psay nTotCli Picture "@e 999,999,999.99" //IMPRESSAO DO TOTAL DO CLIENTE
		@Prow()+1,000 psay __PrtThinLine()
	Else
		While TRA1->E1_VENCREA == _nVcto //WHILE PARA FAZER A QUEBRA DA ORDEM SELECIONADA (CLIENTE/VENCIMENTO)
			nDias      := dDataBase - TRA1->E1_VENCREA //CALCULO DOS DIAS ATRASADOS
			nJuram     := mv_par03/100 //CALCULO DO JUROS POR DIA COM A VARIAVEL DA PERGUNTA
			nLiq	   := TRA1->E1_SALDO
			nValcor    := nLiq*((1+nJuram)^(nDias/30)) //SE O JUROS FOR ZERO, O nJuram VAI SOMAR COM O 1 E ELEVADO A POTENCIA, DARÁ 1. LOGO NAO MUDARA NO VALOR TOTAL
			nValjur    := nValcor - nLiq
			nTotCli    += nValcor
			nTotSalCli += nLiq
			nTotJurCli += nValjur
			cDiaVcto   := TRA1->E1_VENCREA
		  
			If Prow() > 55
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
			EndIf
			
			@Prow()+1,002 psay TRA1->E1_PREFIXO //PREFIXO NOTA FISCAL
			@Prow()  ,010 psay TRA1->E1_NUM //NOTA FISCAL
			@Prow()  ,025 psay TRA1->E1_PARCELA //NUMERO PARCELA
			@Prow()  ,035 psay TRA1->E1_CLIENTE //CODIGO CLIENTE
			@Prow()  ,048 psay TRA1->E1_LOJA //CODIGO LOJA CLIENTE
			@Prow()  ,054 psay TRA1->A1_NOME //CAUSA SOCIAL CLIENTE
			@Prow()  ,094 psay TRA1->E1_EMISSAO //DATA DE EMISSAO
			@Prow()  ,108 psay TRA1->E1_VENCREA //DATA VENCIMENTO REAL
			@Prow()  ,124 psay TRA1->E1_BAIXA //DATA PAGAMENTO
			@Prow()  ,140 psay TRA1->E1_SALDO Picture "@e 999,999,999.99" //VALOR LIQUIDO
			@Prow()  ,158 psay nDias //DIAS ATRASADO
			@Prow()  ,165 psay nValjur Picture "@e 999,999,999.99" //VALOR DO JUROS
			@Prow()  ,181 psay nValcor Picture "@e 999,999,999.99"//VALOR TOTAL COM JUROS
			TRA1->(DbSkip())
		EndDo
		nTotalSal  += nTotSalCli //SOMA VALOR LIQUIDO TOTAL
		nTotalJur  += nTotJurCli //SOMA JUROS TOTAL
		nTotal     += nTotCli //SOMA TOTAL	
		
		@Prow()+2,001 psay "Total do Dia: "
		@Prow()  ,140 psay nTotSalCli Picture "@e 999,999,999.99"
		@Prow()  ,165 psay nTotJurCli Picture "@e 999,999,999.99"
		@Prow()  ,181 psay nTotCli Picture "@e 999,999,999.99" //IMPRESSAO DO TOTAL DO CLIENTE
		@Prow()+1,000 psay __PrtThinLine()
	EndIf
EndDo
@Prow()+2,001 psay "Total:"
@Prow()  ,140 psay nTotalSal Picture "@e 999,999,999.99" //IMPRESSAO DO SALDO TOTAL
@Prow()  ,165 psay nTotalJur Picture "@e 999,999,999.99" //IMPRESSAO DO JUROS TOTAL
@Prow()  ,181 psay nTotal Picture "@e 999,999,999.99" //IMPRESSAO DO TOTAL GERAL

TRA1->(DbCloseArea()) 

Return(nil)

	@Prow()+2,000 PSAY __PrtThinLine()