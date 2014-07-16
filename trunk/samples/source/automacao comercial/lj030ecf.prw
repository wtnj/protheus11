/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lj030ECF  ºAutor  ³Andre Alves Veiga   º Data ³  26/09/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do resumo de caixa na impressora fiscal           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Lj030ECF()

Local aCaixa := {}
Local cString := ''
Local cRet := ' '
Local nTroco
Local nTotCredito
Local nTotDebito
Local nSaldFinal
Local nRet := 0
Local lAberto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array com valores totais do caixa em uma data          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCaixa := MovimCaixa(cCaixa,dDataMovto)
Lj030Dados(aCaixa,;	// Alimenta Totalizadores / Arrays aDados...
				@nTroco,@nTotCredito,@nTotDebito,;
				@nSaldFinal)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o relatório gerencial                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := chr(10) + chr(10) + Repl('-',40) + chr(10)
cString += Space((40-Len("RESUMO DE CAIXA"))/2) + "RESUMO DE CAIXA" + chr(10)
cString += Repl('-',40) + chr(10)
cString += "Codigo do Caixa: " + SA6->A6_COD+"-"+SA6->A6_NOME + chr(10) 
cString += "Data Movimento: " + Dtoc(dDataMovto)	+ chr(10)
cString += Repl('-',40) + chr(10)
cString += Subst("Saldo Inicial: " + Space(26),1,26) + Trans(nTroco,'@E 999,999,999.99') + chr(10)
cString += Repl('-',40) + chr(10)

cString += Subst("Credito/Vendas" + Space(26),1,26) + Trans(nTotCredito,'@E 999,999,999.99')	+ chr(10)
For nI :=1 to len(aDadosVen)
	lAberto := (Left(aDadosVen[nI][1],1)=="-" .and. aDadosVen[nI][2] # 0)
	cString += padr(aDadosVen[nI][1]+" ",26,IIf(lAberto,"",".")) +;
	IIf(lAberto,"",Trans(aDadosVen[nI][2],'@E 999,999,999.99')) + Chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)

cString += Subst("Debitos/Sangrias" + Space(26),1,26) + Trans(nTotDebito,'@E 999,999,999.99') + chr(10)
For nI :=1 to len(aDadosSan)
	cString += padr(aDadosSan[nI][1]+" ",26,".") + Trans(aDadosSan[nI][2],'@E 999,999,999.99') + chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)
cString += Subst("SALDO FINAL" + Space(26),1,26) + Trans(nSaldFinal,'@E 999,999,999.99') + chr(10)
cString += Repl('-',40) + chr(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o relatório para a impressora                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nRet := IFRelGer(nHdlECF,cString,1)
If nRet <> 0
	MsgStop("Problemas com a Impressora Fiscal")
Endif

Return