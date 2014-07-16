#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFa100Trf  บAutor  ณAndre Veiga         บ Data ณ  23/01/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณP.E. na Transferencia da Movimentacao Bancaria              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRegistrar a Sangria no ECF e abrir a gaveta.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fa100Trf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณParametros recebidos       ณ
//ณ====================       ณ
//ณ[1] Banco Origem           ณ
//ณ[2] Agencia Origem         ณ
//ณ[3] Conta Origem           ณ
//ณ[4] Banco Destino          ณ
//ณ[5] Agencia Destino        ณ
//ณ[6] Conta Destino          ณ
//ณ[7] Tipo Transerencia      ณ
//ณ[8] Tipo Documento         ณ
//ณ[9] Valor Transferencia    ณ
//ณ[10] Historico             ณ
//ณ[11] Beneficiario          ณ
//ณ[12] Natureza origem       ณ
//ณ[13] Natureza Destino      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cBcoOrig 	:= ParamIxb[1]
Local cAgenOrig	:= ParamIxb[2]
Local cCtaOrig	:= ParamIxb[3]
Local cBcoDest	:= ParamIxb[4]
Local cAgenDest	:= ParamIxb[5]
Local cCtaDest	:= ParamIxb[6]
Local cTipoTran	:= ParamIxb[7]
Local cDocTran	:= ParamIxb[8]
Local nValorTran:= ParamIxb[9]
Local cHist100	:= ParamIxb[10]
Local cBenef100	:= ParamIxb[11]
Local cNaturOri	:= ParamIxb[12]
Local cNaturDes	:= ParamIxb[13]
Local iRet		:= -1
Local cPortaGav	:= LJGetStation("PORTGAV")
Local ccaixa    := xNumCaixa()

If lFiscal
	If cBcoOrig == cCaixa
		// Faz a sangria
		iRet := IFSupr( nHdlECF, 3, Str(nValorTran,14,2), '', '' )
	ElseIf cBcoDest == cCaixa
		// Faz o troco
		iRet := IFSupr( nHdlECF, 2, Str(nValorTran,14,2), '', '' )
	Endif
Endif

If iRet = 0 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se ha gaveta configurada na porta COMณ
	//ณCaso nao tenha envia o comando pelo ECF       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lGaveta
		iRet := GavetaAci( nHdlGaveta, cPortaGav )
	Else
		iRet := IFGaveta( nHdlECF )
	Endif
Endif	

Return .T.