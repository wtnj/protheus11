#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFDIMPR   บAutor  ณMicrosiga           บFecha ณ 17/01/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpresion de comprobantes fiscales digitales                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CFD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CFDIMPR()
Local aArea := GetArea()
Local cPerg := "CFDIMP"

Private cSelo := ""

AjustaSX1(cPerg)

cString:="SF3"
titulo :=PADC("Emisiขn de comprobante fiscal digital" ,74)
cDesc1 :=""
cDesc2 :=""
cDesc3 :=""
aReturn := {OemToAnsi("Especial"), 1,OemToAnsi("Administraciขn"), 1, 2, 1,"",1}
nomeprog:="CFDMEX" 
nLin:=0
wnrel:= "CFDMEX"     
limite:=132
tamanho:="M"

Pergunte(cPerg,.F.)
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,tamanho,"",.F.)
If nLastKey <> 27
	SetDefault(aReturn,cString)
	RptStatus({|lEnd| RptCFD(@lEnd)})
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		Ourspool(wnrel)
	Endif
	MS_FLUSH()
Endif
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPTCFD    บAutor  ณMicrosiga           บFecha ณ 17/01/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpresion del comprobante fiscal digital                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CFD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RptCFD(lEnd)
Local aQuery  := {}
Local cFiltro := ""
Local cQuery  := ""
Local dDEmis  := ""
Local cfatura := ""
Local cSerie  := ""
Local cCodigo := ""
Local cLoja   := ""
Local cFilSF3 := xFilial("SF3")

aQuery := {"SF3",""}
//query para TOP
cQuery := "F3_FILIAL = '" + xFilial("SF3") + "'"
cQuery += " and F3_EMISSAO >= '" + Dtos(MV_PAR01) + "'"
cQuery += " and F3_EMISSAO <= '" + Dtos(MV_PAR02) + "'"
cQuery += " and F3_SERIE >= '" + MV_PAR03 + "'"
cQuery += " and F3_SERIE <= '" + MV_PAR05 + "'"
cQuery += " and F3_NFISCAL >= '" + MV_PAR04 + "'"
cQuery += " and F3_NFISCAL <= '" + MV_PAR06 + "'"
cQuery += " and F3_APROFOL <> ''"
cQuery += " and F3_DTCANC = ''"
If SF3->(FieldPos("F3_FIMP")) > 0
	cQuery += " and F3_FIMP = 'S'"
Endif
cQuery += " and D_E_L_E_T_ =''"
//filtro para dbf
cFiltro := "F3_FILIAL = '" + xFilial("SF3") + "'"
cFiltro += " .and. Dtos(F3_EMISSAO) >= '" + Dtos(MV_PAR01) + "'"
cFiltro += " .and. Dtos(F3_EMISSAO) <= '" + Dtos(MV_PAR02) + "'"
cFiltro += " .and. F3_SERIE >= '" + MV_PAR03 + "'"
cFiltro += " .and. F3_SERIE <= '" + MV_PAR05 + "'"
cFiltro += " .and. F3_NFISCAL >= '" + MV_PAR04 + "'"
cFiltro += " .and. F3_NFISCAL <= '" + MV_PAR06 + "'"
cFiltro += " .and. !Empty(F3_APROFOL)"
cFiltro += " .and. Empty(F3_DTCANC)"
If SF3->(FieldPos("F3_FIMP")) > 0
	cFiltro += " .and. F3_FIMP = 'S'"
Endif
DbSelectArea("SF3")
DbSetOrder(1)
FsQuery(aQuery,1,cQuery,cFiltro,SF3->(IndexKey()))
DbSelectArea("SF3")
DbGoTop()
SetRegua(RecCount())
While !(SF3->(Eof())) .And. !lEnd
	IMPCFD(SF3->F3_ESPECIE,SF3->F3_CLIEFOR,SF3->F3_LOJA,SF3->F3_NFISCAL,SF3->F3_SERIE)
	IncRegua()
	dDEmis  := SF3->F3_ENTRADA
	cfatura := SF3->F3_NFISCAL
	cSerie  := SF3->F3_SERIE
	cCodigo := SF3->F3_CLIEFOR
	cLoja   := SF3->F3_LOJA
	While	SF3->F3_FILIAL == cFilSF3 .And. SF3->F3_ENTRADA == dDEmis .And. ;
			SF3->F3_NFISCAL == cFatura .And. SF3->F3_SERIE == cSerie .And. ;
			SF3->F3_CLIEFOR == cCodigo .And. SF3->F3_LOJA == cLoja
		SF3->(DbSkip())
	Enddo
	If lEnd
		lEnd:=MsgYesNo("Desea interromper la impresion de los cfd's")
	Endif
Enddo
FsQuery(aQuery,2)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCFD    บAutor  ณMicrosiga           บFecha ณ 18/01/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpresion del comprobante fiscal digital                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CFD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPCFD(cCFDEsp,cCFDCliFor,cCFDLoja,cCFDFac,cCFDSer)
Local nLin := 0
Local aQuery := {}
Local cQuery := ""
Local cFiltro := ""
Local cCadOrig := ""
Local cCpoIdx := ""
Local cUnid := ""
Local cProd := ""
Local cNome := ""
Local cEnd := ""
Local cRFC := ""
Local cCid := ""
Local cEst := ""
Local cCep := ""
Local cArqItem := ""
Local cData := ""
Local nQuant := 0
Local nPreco := 0
Local nTotal := 0
Local nSubTot := 0
Local nTotIVA := 0
Local nTotIVAC := 0
Local cTerminal := "||"
Local cSeparar := "|"

cCFDEsp := AllTrim(cCFDEsp)
cCadOrig := cTerminal
If cCFDEsp $ "NCI,NCC"
	DbSelectArea("SF1")
	DbSetOrder(1)
	MsSeek(xFilial("SF1")+cCFDFac+cCFDSer+cCFDCliFor+cCFDLoja)
	cArqItem := "SD1"
	cCpoIdx := "D1_ITEM"
	aQuery := {"SD1",""}
	cQuery := "D1_FILIAL = '" + xFilial("SD1") + "'"
	cQuery += " and D1_DOC = '" + SF1->F1_DOC + "'"
	cQuery += " and D1_SERIE = '" + SF1->F1_SERIE + "'" 
	cQuery += " and D1_FORNECE = '" + SF1->F1_FORNECE + "'"
	cQuery += " and D1_LOJA = '" + SF1->F1_LOJA + "'"
	cFiltro := "D1_FILIAL == '" + xFilial("SD1") + "'"
	cFiltro += " .and. D1_DOC == '" + SF1->F1_DOC + "'"
	cFiltro += " .and. D1_SERIE == '" + SF1->F1_SERIE + "'" 
	cFiltro += " .and. D1_FORNECE == '" + SF1->F1_FORNECE + "'"
	cFiltro += " .and. D1_LOJA == '" + SF1->F1_LOJA + "'"
	//cadena original
	cData := Dtos(SF1->F1_EMISSAO)
	cData := Left(cData,4) + "-" + Substr(cData,5,2)+ "-" + Right(cData,2)
	cData += "T" + SF1->F1_HORA + ":00"
	cCadOrig += Alltrim(SF1->F1_SERIE) + cSeparar
	cCadOrig += Alltrim(SF1->F1_DOC) + cSeparar
	cCadOrig += Alltrim(cData) + cSeparar
	cCadOrig += Alltrim(SF1->F1_APROFOL) + cSeparar
	cCadOrig += Alltrim(SF1->F1_COND) + cSeparar
	cCadOrig += Alltrim(SM0->M0_CGC) + cSeparar
	cCadOrig += Alltrim(SM0->M0_NOMECOM) + cSeparar
	cCadOrig += Alltrim(SM0->M0_ENDCOB) + cSeparar
	cCadOrig += AllTrim(SM0->M0_CIDCOB) + cSeparar
	cCadOrig += AllTrim(SM0->M0_ESTCOB) + cSeparar
	cCadOrig += "Mexico" + cSeparar
	cCadOrig += AllTrim(SM0->M0_CEPCOB) + cSeparar
	If cCFDEsp == "NCC"
		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		SYA->(MsSeek(xFilial("SYA")+SA1->A1_PAIS))
		cNome	:= AllTrim(A1_NOME)
		cRFC	:= AllTrim(A1_CGC)
		cEnd	:= AllTrim(A1_END)
		cCid	:= AllTrim(A1_MUN)
		cEst	:= AllTrim(A1_EST)
		cCep	:= AllTrim(A1_CEP)
	Else
		DbSelectArea("SA2")
		DbSetOrder(1)
		MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
		SYA->(MsSeek(xFilial("SYA")+SA2->A2_PAIS))
		cNome	:= AllTrim(A2_NOME)
		cRFC	:= AllTrim(A2_CGC)
		cEnd	:= AllTrim(A2_END)
		cCid	:= AllTrim(A2_MUN)
		cEst	:= AllTrim(A2_EST)
		cCep	:= AllTrim(A2_CEP)
	Endif
Else
	DbSelectArea("SF2")
	DbSetOrder(1)
	MsSeek(xFilial("SF2")+cCFDFac+cCFDSer+cCFDCliFor+cCFDLoja)
	cArqItem := "SD2"
	cCpoIdx := "D2_ITEM"
	aQuery := {"SD2",""}
	cQuery := "D2_FILIAL = '" + xFilial("SD2") + "'"
	cQuery += " and D2_DOC = '" + SF2->F2_DOC + "'"
	cQuery += " and D2_SERIE = '" + SF2->F2_SERIE + "'" 
	cQuery += " and D2_CLIENTE = '" + SF2->F2_CLIENTE + "'"
	cQuery += " and D2_LOJA = '" + SF2->F2_LOJA + "'"
	cFiltro := "D2_FILIAL == '" + xFilial("SD2") + "'"
	cFiltro += " .and. D2_DOC == '" + SF2->F2_DOC + "'"
	cFiltro += " .and. D2_SERIE == '" + SF2->F2_SERIE + "'" 
	cFiltro += " .and. D2_CLIENTE == '" + SF2->F2_CLIENTE + "'"
	cFiltro += " .and. D2_LOJA == '" + SF2->F2_LOJA + "'"
	//cadena original
	cData := Dtos(SF2->F2_EMISSAO)
	cData := Left(cData,4) + "-" + Substr(cData,5,2)+ "-" + Right(cData,2)
	cData += "T" + SF2->F2_HORA + ":00"
	cCadOrig += Alltrim(SF2->F2_SERIE) + cSeparar
	cCadOrig += Alltrim(SF2->F2_DOC) + cSeparar	
	cCadOrig += Alltrim(cData) + cSeparar
	cCadOrig += Alltrim(SF2->F2_APROFOL) + cSeparar
	cCadOrig += Alltrim(SF2->F2_COND) + cSeparar
	cCadOrig += Alltrim(SM0->M0_CGC) + cSeparar
	cCadOrig += Alltrim(SM0->M0_NOMECOM) + cSeparar
	cCadOrig += Alltrim(SM0->M0_ENDCOB) + cSeparar
	cCadOrig += AllTrim(SM0->M0_CIDCOB) + cSeparar
	cCadOrig += AllTrim(SM0->M0_ESTCOB) + cSeparar
	cCadOrig += "Mexico" + cSeparar
	cCadOrig += AllTrim(SM0->M0_CEPCOB) + cSeparar
	If cCFDEsp == "NDI"
		DbSelectArea("SA2")
		DbSetOrder(1)
		MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		SYA->(MsSeek(xFilial("SYA")+SA2->A2_PAIS))
		cNome	:= AllTrim(A2_NOME)
		cRFC	:= AllTrim(A2_CGC)
		cEnd	:= AllTrim(A2_END)
		cCid	:= AllTrim(A2_MUN)
		cEst	:= AllTrim(A2_EST)
		cCep	:= AllTrim(A2_CEP)
	Else
		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		SYA->(MsSeek(xFilial("SYA")+SA1->A1_PAIS))
		cNome	:= AllTrim(A1_NOME)
		cRFC	:= AllTrim(A1_CGC)
		cEnd	:= AllTrim(A1_END)
		cCid	:= AllTrim(A1_MUN)
		cEst	:= AllTrim(A1_EST)
		cCep	:= AllTrim(A1_CEP)
	Endif
Endif
//destinatario
cCadOrig += cRFC + cSeparar
cCadOrig += cNome + cSeparar
cCadOrig += cEnd + cSeparar
cCadOrig += cCid + cSeparar
cCadOrig += cEst + cSeparar
cCadOrig += Alltrim(SYA->YA_DESCR) + cSeparar
cCadOrig += cCep + cSeparar
//
FsQuery(aQuery,1,cQuery,cFiltro,cCpoIdx)
DbSelectArea(cArqItem)
DbGoTop()
nLin := 80
nTotIVA := 0
nTotIVAC := 0
nSubTot := 0
While !Eof()
	If nLin > 58
		If cArqItem == "SD1"
			nLin := ImpCFDCab(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_CERTFOL,SF1->F1_EMISSAO,cNome,cRFC,cEnd,cCid,cEst)
		Else
			nLin := ImpCFDCab(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CERTFOL,SF2->F2_EMISSAO,cNome,cRFC,cEnd,cCid,cEst)
	 	Endif
		//
		nLin++
		@nLin,00 PSay "Producto                                        Cantidad             Un                         Precio                  Precio Total"
		nLin++
		@nLin,00 PSay __PrtThinLine()
		nLin++
	Endif
	While !Eof() .And. nLin < 59
		If cArqItem == "SD1"
			cProd := SD1->D1_COD
			cUnid := SD1->D1_UM
			nQuant := SD1->D1_QUANT
			nPreco := SD1->D1_VUNIT
			nTotal := SD1->D1_TOTAL
			nTotIVA += SD1->D1_VALIMP1
			nTotIVAC += SD1->D1_VALIMP5
			nSubTot += SD1->D1_TOTAL
		Else
			cProd := SD2->D2_COD
			cUnid := SD2->D2_UM
			nQuant := SD2->D2_QUANT
			nPreco := SD2->D2_PRCVEN
			nTotal := SD2->D2_TOTAL
			nTotIVA += SD2->D2_VALIMP1
			nTotIVAC += SD2->D2_VALIMP5
			nSubTot += SD2->D2_TOTAL
		Endif
		SB1->(DbSeek(xFilial("SB1")+cProd))
		@nLin,000 PSay SB1->B1_DESC
		@nLin,043 PSay nQuant Picture "@E 99,999,999.99"
		@nLin,069 PSay cUnid
		@nLin,085 PSay nPreco Picture "@E 99,999,999,999.99"
		@nLin,115 PSay nTotal Picture "@E 99,999,999,999.99"
		nLin++
		(cArqItem)->(DbSkip())
		//cadena original
		cCadOrig += Alltrim(Str(nQuant)) + cSeparar
		cCadOrig += Alltrim(cUnid) + cSeparar
		cCadOrig += Alltrim(SB1->B1_DESC) + cSeparar
		cCadOrig += Alltrim(Str(nPreco)) + cSeparar
		cCadOrig += Alltrim(Str(nTotal)) + cSeparar
	Enddo
Enddo
FsQuery(aQuery,2)
nLin+=2
@nLin,106 PSay "Sub-Total"
@nLin,115 PSay nSubTot Picture "@E 99,999,999,999.99"
If nTotIVA <> 0
	nLin++
	@nLin,109 PSay "I.V.A."
	@nLin,115 PSay nTotIVA Picture "@E 99,999,999,999.99"
Endif
If nTotIVAC <> 0
	nLin++
	@nLin,098 PSay "I.V.A. (incluido)"
	@nLin,115 PSay nTotIVAC Picture "@E 99,999,999,999.99"
Endif
nLin++
@nLin,110 PSay "Total"
@nLin,115 PSay nSubTot + nTotIVA Picture "@E 99,999,999,999.99"
//cadena original
If cArqItem == "SD1"
	//Retencoes
	cCadOrig += If(SF1->F1_VALIMP3<>0, "ISR" + cSeparar + Alltrim(Str(SF1->F1_VALIMP3)) + cSeparar,"")
	cCadOrig += If(SF1->F1_VALIMP2<>0, "IVA" + cSeparar + Alltrim(Str(SF1->F1_VALIMP2)) + cSeparar,"")
	//Impuestos
	//IVA + IVA INCLUIDO
	cCadOrig += If((SF1->F1_VALIMP1+SF1->F1_VALIMP5)<>0, "IVA" + cSeparar + Alltrim(Str(SF1->F1_VALIMP1+SF1->F1_VALIMP5)) + cSeparar,"")
	//
Else
	//Retencoes
	cCadOrig += If(SF2->F2_VALIMP3<>0, "ISR" + cSeparar + Alltrim(Str(SF2->F2_VALIMP3)) + cSeparar,"")
	cCadOrig += If(SF2->F2_VALIMP2<>0, "IVA" + cSeparar + Alltrim(Str(SF2->F2_VALIMP2)) + cSeparar,"")
	//Impuestos
	//IVA + IVA INCLUIDO
	cCadOrig += If((SF2->F2_VALIMP1+SF2->F2_VALIMP5)<>0, "IVA" + cSeparar + Alltrim(Str(SF2->F2_VALIMP1+SF2->F2_VALIMP5)) + cSeparar,"")
Endif
//cadena original y sello
cCadOrig += cSeparar
cCadOrig := ENCODEUTF8(cCadOrig)
cSelo := MD5(cCadOrig,1)
cSelo := PrivSignRSA(&(SuperGetMv("MV_CFDDIRS",,""))+SuperGetMv("MV_CFDARQS",,""),cSelo,1)
cSelo := ENCODE64(cSelo)
nLin += 3
If nLin < 58
	@nLin,00 PSay "Cadena Original"
	nLin++
Endif
While !Empty(cCadOrig)
	If nLin > 58
		If cArqItem == "SD1"
			nLin := ImpCFDCab(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_CERTFOL,SF1->F1_EMISSAO,cNome,cRFC,cEnd,cCid,cEst)
		Else
			nLin := ImpCFDCab(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CERTFOL,SF2->F2_EMISSAO,cNome,cRFC,cEnd,cCid,cEst)
	 	Endif
	 	nLin++
		@nLin,00 PSay "Cadena Original"
		nLin++
	Endif
	@nLin,00 PSay Substr(cCadOrig,1,limite)
	cCadOrig := Substr(cCadOrig,limite + 1)
	nLin++
Enddo 
nLin += 3
If nLin < 58
	@nLin,00 PSay "Sello Digital"
	nLin++
Endif
While !Empty(cSelo)
	If nLin > 58
		If cArqItem == "SD1"
			nLin := ImpCFDCab(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_CERTFOL,SF1->F1_EMISSAO,cNome,cRFC,cEnd,cCid,cEst)
		Else
			nLin := ImpCFDCab(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CERTFOL,SF2->F2_EMISSAO,cNome,cRFC,cEnd,cCid,cEst)
	 	Endif
		@nLin,000 PSay "Sello Digital"
		nLin++
	Endif
	@nLin,000 PSay Substr(cSelo,1,limite)
	cSelo := Substr(cSelo,limite + 1)
	nLin++
Enddo 
ImpCFDRod(59)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCFDCAB บAutor  ณMicrosiga           บFecha ณ 18/01/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpresion de los datos de emisor y receptor                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CFD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCFDCab(cFac,cSer,cCert,dEmissao,cNome,cRFC,cEnd,cCid,cEst)
@00,000 PSay AllTrim(SM0->M0_NOMECOM)
@00,122 PSay cSer + " " + cFac
@01,000 PSay AllTrim(SM0->M0_CGC)
@01,112 PSay PadL(AllTrim(cCert),20)
@02,000 PSay SM0->M0_ENDCOB
@02,122 PSay Padl(Dtoc(dEmissao),10)
@03,000 PSay AllTrim(SM0->M0_ESTCOB) + " - " + AllTrim(SM0->M0_CIDCOB)
@03,112 PSay PadL(AllTrim(SM0->M0_CIDCOB),20)
//
@05,00 PSay "Cliente"
@06,00 PSay cNome + " - " + cRFC
@07,00 PSay cEnd + "  -  " + cCid + "  -  " + cEst
Return(8)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCFDROD บAutor  ณMicrosiga           บFecha ณ 18/01/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpresion de observacions en el cfd                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CFD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCFDRod(nLin)
@nLin,00 PSay __PrtThinLine()
nLin++
@nLin,00 PSay Padc("ESTE DOCUMENTO ES UNA IMPRESION DE UN COMPROBANTE FISCAL DIGITAL",limite)
nLin++
@nLin,00 PSay __PrtThinLine()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1 บAutor  ณMicrosiga           บFecha ณ 18/01/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCreacion del grupo de preguntas para el uso de la           บฑฑ
ฑฑบ          ณimpresion de cfd                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CFD                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)
Local aHP := {}
Local aHE := {}
Local aHI := {}

PutSx1(cPerg,"01","De Data"  ,"De Fecha"   ,"From Date"   ,"mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
aHP := {"Data inicial a ser considerado na filtragem do","cadastro de notas fiscais."}
aHE := {"Fecha inicial a considerarse en la","filtracion del archivo de facturas."}
aHI := {"Inicial date to be considered in","the filtering of invoices."}
PutSX1Help("P."+cPerg+"01.",aHP,aHI,aHE)

PutSx1(cPerg,"02","A Data"   ,"A Fecha"    ,"To Date"     ,"mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
aHP := {"Data final a ser considerado na filtragem do","cadastro de notas ficais."}
aHE := {"Fecha final a considerarse en la","filtracion del archivo de facturas."}
aHI := {"Final date to be considered in","the filtering of invoices."}
PutSX1Help("P."+cPerg+"02.",aHP,aHI,aHE)

PutSx1(cPerg,"03","De Serie" ,"De Serie"  ,"From Serie"  ,"mv_ch3","C",3,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
aHP := {"Serie inicial a ser considerada na","filtragem do casdastro de notais ficais"}
aHE := {"Serie inicial a considerarse en la","filtracion del archivo de facturas."}
aHI := {"Inicial serie to be considered in","the filtering of invoices file."}
PutSX1Help("P."+cPerg+"03.",aHP,aHI,aHE)

PutSx1(cPerg,"04","De Fatura","De Factura","From Invoice","mv_ch4","C",TamSX3("F3_NFISCAL")[1],0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
aHP := {"Nr. Nota fiscal inicial a ser considerada","na filtragem do cadastro de notas ","fiscais."}
aHE := {"Nr. Factura inicial a considerarse en la","filtracion del registro de facturas."}
aHI := {"Inicial Invoice number to be considered ","in the filtering of invoices file."}
PutSX1Help("P."+cPerg+"04.",aHP,aHI,aHE)

PutSx1(cPerg,"05","A Serie"  ,"A Serie"   ,"To Serie"    ,"mv_ch5","C",3,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
aHP := {"Serie final a ser considerado na","filtragem no cadastro de notas fiscais."}
aHE := {"Serie final a considerarse en la","filtracion del archivo de facturas."}
aHI := {"Final serie to be considered in the fil tering of invoices file."}
PutSX1Help("P."+cPerg+"05.",aHP,aHI,aHE)

PutSx1(cPerg,"06","A Fatura" ,"A Factura" ,"To Invoice"  ,"mv_ch6","C",TamSX3("F3_NFISCAL")[1],0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
aHP := {"Nr. Nota Fiscal final a ser considerado na ","filtragem do cadastro de nota fiscais."}
aHE := {"Nr. Factura final a considerarse en la ","filtracion del archivo de facturas."}
aHI := {"Final invoice number to be considered in"," the file of invoices."}
PutSX1Help("P."+cPerg+"06.",aHP,aHI,aHE)
Return