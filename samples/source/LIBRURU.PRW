#INCLUDE "SIGAWIN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "LIBRURU.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณLIBRURU   บAutor  ณ Jose Aur้lio/Lucas บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Diario de Ventas para Uruguay.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Livros Fiscais                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Libruru()
Local nQ:=0

Private CBTXT,CBCONT,NORDEM,ALFA,Z,M
Private ASER,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2
Private CDESC3,CNATUREZA,NOMEPROG,CPERG,NLASTKEY
Private LCONTINUA,WNREL,LFINREL,CPICTVALS,ATIPOS,ATOTALES
Private LTIPOS,NQ,CSTRING,LCONTRANUL
Private CCONTNF,NCANTSERIES,CCHAVE,CFILTRO,CARQTMP,NMAXLEN
Private NSER,NDIFER,NA,NTIPO,AMESES,CEMPRESA
Private CINSCR,CCUIT,CTITULO,_NMES,NCNT1,ND
Private NLINRODA1,NLINRODA2,NLINRODA3,NLINRODA4,NLINRODA5,NLINRODA1B
Private NLINRODA2B,NLINRODA3B,NLININI,ADRIVER,NOPC,CCOR,NLINLIN := 0
Private _SALIAS,AREGS,I,J
Private tpass
Private nX
Private nMoedaSF2
Private aCampos := {}
Private aStrutTRB := {}
Private nNeto  := 0
Private nValNeto := 0
Private nIVA14 := 0
Private nIVA23 := 0
Private aTotPesos := { {"Unica      ",0,0,0,0,0},; 
				  	   {"Tasa Minima",0,0,0,0,0},;
				 	   {"Exento     ",0,0,0,0,0},;
					   {"TOTALES    ",0,0,0,0,0}}

Private aTotDolar := { {"Unica      ",0,0,0,0,0},;
					   {"Tasa Minima",0,0,0,0,0},;
					   {"Exento     ",0,0,0,0,0},;
					   {"TOTALES    ",0,0,0,0,0}}
Private lCabec := .t.	
ValidPerg()
CbTxt  := ""
CbCont := ""
nOrdem := 0
Alfa   := 0
Z:=0
M:=0
aSer   := {}
tamanho := "G"
limite  := 220
titulo   := PADC(OemtoAnsi(STR0001),74)//PADC("Emisiขn del Subdiario de IVA",74) // Nota de Debito/Credito en formulario pre-impreso.",74)
cDesc1   := PADC(OemtoAnsi(STR0002),74)//PADC("Ser n solicitadas la fecha inicial y la fecha final para la emisi๓n ",74)
cDesc2   := PADC(OemtoAnsi(STR0003),74)//PADC("de los libros de IVA Ventas e IVA Compras",74)
cDesc3   :=""
cNatureza:=""
aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 }
nomeprog :="LIBRURU"
cPerg    :="LIBURU"
nLastKey := 0
lContinua:= .T.
wnrel    := "LIBRURU"
lFinRel  := .F.

SX3->(DbSetOrder(2))
SX3->(DbSeek("A1_CGC"))
If  SX3->(Found() )
	cPicCgc := Alltrim(SX3->X3_PICTURE)
EndIf
aTipos   := {}
aTotales := {}
lTipos	 := SX5->(DBSEEK(xFilial("SX5")+"SF"))
If lTipos
	While !SX5->(EOF()).And.SX5->X5_TABELA=="SF"
		Aadd(aTipos,{SX5->X5_CHAVE,Alltrim(SX5->X5_DESCRI)})
		SX5->(DbSkip())
	Enddo	
	Aadd(aTipos,{"  ",OemToAnsi(STR0006)})	
	For nQ	:=	1 To len(aTipos)
		Aadd(aTotales,{0.00,0.00,0.00,0.00,0.00})
	Next
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte(cPerg,.F.)
cString := "SF3"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
VerImp()
RptStatus({|| RptDetail()})
Return

Static Function RptDetail()
Local nI:=0

lContrAnul := mv_par04 ==1
cContNF := GetMv("MV_CONTNF")
dbSelectArea("SF3")
Retindex("SF3")
cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.AND.DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"'"
cFiltro := cFiltro + ".And.F3_TIPOMOV == 'V'"
cChave := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CFO"
cArqIndxF3 := CriaTrab(NIL,.F.)
IndRegua("SF3",cArqIndxF3,cChave,,cFiltro,OemToAnsi(STR0007))
nindex := RetIndex("SF3")
#IFNDEF TOP	
	dbSetIndex(cArqIndxF3+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
nNroDoc := 0  
nLin    := 60
nCpos   := 0
nPagina := 0
dbSelectArea("SX3")
dbGoTop()
dbSetOrder(2)
aCampos := {"F2_MOEDA","F3_ENTRADA","F3_ALQIMP1","F3_ALQIMP2","F3_SERIE","F3_BASIMP1","F3_VALIMP1","F3_BASIMP2","F3_VALIMP2","F2_VALMERC","F3_TIPO","F3_NFISCAL","F3_CLIEFOR","F3_LOJA","F3_TIPOMOV","F3_EXENTAS","F3_ESPECIE"}
For nI := 1 To Len(aCampos)
	If dbSeek(aCampos[nI])		
		nCpos++
		AADD(aStrutTRB,{x3_campo,x3_tipo,x3_tamanho,x3_decimal} )
	EndIf
Next nI

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+DTOS(mv_par01),.T.)

SetRegua(LastRec())

While !Eof() .and. F3_ENTRADA <= mv_par02

	IncRegua()	
	If Lastkey() == 286
		@ 00,01 PSAY OemToAnsi(STR0008)
		Exit
	EndIf	
	If lAbortPrint
		@ 00,01 PSAY OemToAnsi(STR0008)
		lContinua := .F.
		Exit
	Endif
	nLinLim := 55		
	If nLin > nLinLim
		R020Cab()
	EndIf

	If mv_par03 == 1 .or. mv_par03 == 2
		@ nLin,001 PSAY F3_ENTRADA 				Picture PesqPict("SF3","F3_ENTRADA")
		nLin := nLin + 1
    EndIf
    
	dDataDia := F3_ENTRADA
	
	While !Eof() .and. F3_ENTRADA == dDataDia
	
		SF2->( dbSetOrder(1) )
		SF2->( dbSeek(xFilial("SF2")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA) )	

		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA) )

		If F3_ESPECIE $ "NCC"
			nSigno	:=-1
		Else
			nSigno	:= 1
		EndIf	

		If mv_par03 == 1 .or. mv_par03 == 2
		
			If SF2->F2_MOEDA > 1
				nValNeto := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA)
			Else
				nValNeto := SF2->F2_VALMERC
			EndIf
								
			@ nLin,002 PSAY IIf(F3_ESPECIE=="NCC","NCC",IIF(F3_TIPO=="D","NDC","FAC"))
			@ nLin,006 PSAY Subs(AllTrim(F3_SERIE),1,1)
			@ nLin,008 PSAY F3_NFISCAL				Picture PesqPict("SF3","F3_NFISCAL")
			@ nLin,022 PSAY F3_CLIEFOR+"-"+F3_LOJA
			@ nLin,032 PSAY Subs(SA1->A1_NOME,1,30)	Picture "@!"
			@ nLin,070 PSAY nValNeto				Picture PesqPict("SF2","F2_VALMERC",14,1)
			@ nLin,091 PSAY (F3_VALIMP1 * nSigno)	Picture PesqPict("SF3","F3_VALIMP1",14,1)
			@ nLin,106 PSAY (F3_VALIMP2 * nSigno)	Picture PesqPict("SF3","F3_VALIMP2",14,1)
			nLin := nLin + 1
		EndIf
	
		If SF2->F2_MOEDA == 1
			If F3_VALIMP2 > 0
				aTotPesos[1][2] += SF2->F2_VALMERC
				aTotPesos[1][4] += (F3_VALIMP2 * nSigno)
			EndIf
			If F3_VALIMP1 > 0
				aTotPesos[2][2] += SF2->F2_VALMERC
				aTotPesos[2][3] += (F3_VALIMP1 * nSigno)
			EndIf
			If F3_EXENTAS > 0
				aTotPesos[3][2] += SF2->F2_VALMERC
			EndIf
		ElseIf SF2->F2_MOEDA == 2

			nValNeto := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA)
		
			If F3_VALIMP2 > 0
				aTotDolar[1][2] += (nValNeto * nSigno)
				aTotDolar[1][4] += (F3_VALIMP2 * nSigno)
			EndIf	            	
			If F3_VALIMP1 > 0
				aTotDolar[2][2] += (nValNeto * nSigno)
				aTotDolar[2][3] += (F3_VALIMP1 * nSigno)
			EndIf	         	
			If F3_EXENTAS > 0
				aTotDolar[3][2] += (nValNeto * nSigno)        	
			Endif		
		EndIf    	
		aTotPesos[1][5] := aTotPesos[1][4]
		aTotPesos[1][6] := aTotPesos[1][2] + aTotPesos[1][4]	
		aTotPesos[2][5] := aTotPesos[2][3]
		aTotPesos[2][6] := aTotPesos[2][2] + aTotPesos[2][3]
		
		aTotDolar[1][5] := aTotDolar[1][4]
		aTotDolar[1][6] := aTotDolar[1][2] + aTotDolar[1][4]	
		aTotDolar[2][5] := aTotDolar[2][3]
		aTotDolar[2][6] := aTotDolar[2][2] + aTotDolar[2][3]

		nNeto  := nNeto  += (nValNeto * nSigno)
		nIVA14 := nIVA14 += (F3_VALIMP2  * nSigno)
		nIVA23 := nIVA23 += (F3_VALIMP2  * nSigno)

		DbSelectArea("SF3")
		DbSkip()	
	EndDo	
EndDo
Roda(0,"","")

lFinRel := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Imprimir o Resumo...										            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
R020Rdp()

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
#IFNDEF TOP
	Ferase(cArqIndxF3+OrdBagExt())
#ENDIF
DbSelectArea("SF3")
dbCloseArea ()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็เo	 ณR020Cab   บAutor  ณ Jose Aurelio/Lucas บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cabecalho do Libro de IVA ( Compras e Ventas ).            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LIBR020                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020Cab()

aMeses := {}
AADD(aMeses,OemToAnsi(STR0030))//"ENERO    "
AADD(aMeses,OemToAnsi(STR0031))//"FEBRERO  "
AADD(aMeses,OemToAnsi(STR0032))//"MARZO    "
AADD(aMeses,OemToAnsi(STR0033))//"ABRIL    "
AADD(aMeses,OemToAnsi(STR0034))//"MAYO     "
AADD(aMeses,OemToAnsi(STR0035))//"JUNIO    "
AADD(aMeses,OemToAnsi(STR0036))//"JULIO    "
AADD(aMeses,OemToAnsi(STR0037))//"AGOSTO   "
AADD(aMeses,OemToAnsi(STR0038))//"SETIEMBRE"
AADD(aMeses,OemToAnsi(STR0039))//"OCTUBRE  "
AADD(aMeses,OemToAnsi(STR0040))//"NOVIEMBRE"
AADD(aMeses,OemToAnsi(STR0041))//"DICIEMBRE"
cEmpresa := SM0->M0_NOMECOM
cInscr   := InscrEst()
cCUIT    := TRANSFORM(SM0->M0_CGC,cPicCgc)
cTitulo  := OemtoAnsi(STR0042) //"L I B R O   D E   "
cTitulo := cTitulo + OemtoAnsi(STR0044)//"V E N T A S"
nPagina := nPagina + 1
@ 02,000 PSAY OemToAnsi(STR0045) //"Empresa: "
@ 02,020 PSAY cEmpresa
@ 02,122 PSAY OemToAnsi(STR0046)//"Pagina Nro.: "
@ 02,136 PSAY StrZero(nPagina,6)
@ 03,000 PSAY OemToAnsi(STR0048)//"CUIT: "
@ 03,007 PSAY cCUIT
@ 05,000 PSAY cTitulo
_nMes := Month(mv_par02)
If _nMes > 0 .And. _nMes < 13
	@ 05,080 PSAY OemToAnsi(STR0049)//"Mes "
	@ 05,085 PSAY aMeses[_nMes]
	@ 05,095 PSAY OemToAnsi(STR0050)//"Ano"
	@ 05,100 PSAY StrZero(Year(mv_par02),4)
EndIf
If lCabec
	@ 07,000 PSAY OemToAnsi(STR0051)
Endif
nLin := 09
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็เo	 ณR020Rod   บAutor  ณ Jose Aurelio/Lucas บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rodape do Libro de IVA ( Compras e Ventas ).     	      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LIBR020                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function R020Rod()
nLin := nLin + 1
@ nLin,000 PSAY OemToAnsi(STR0053) //"Totales :"
@ nLin,080 PSAY nNeto                  Picture PesqPict("SF2","F2_VALMERC",14,1)
@ nLin,096 PSAY nIVA14                 Picture PesqPict("SF3","F3_VALIMP1",14,1)
@ nLin,111 PSAY nIVA23                 Picture PesqPict("SF3","F3_VALIMP2",14,1)
nLin := nLin +1
lFinRel := .F.
Return*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็เo	 ณR020Rdp   บAutor  ณ Jose Aurelio/Lucas บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rodape do Libro de IVA ( Compras e Ventas ).               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LIBR020                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
7฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function R020Rdp()
Local nD:=0

nCnt1 :=	1
lCabec := .f.
If F3_TIPO
	For nD:=1 to len(aTotales)
		If aTotales[nD][1]<>0.00.Or.aTotales[nD][2]<>0.00 .Or. aTotales[nD][3] <> 0.00
			If nCnt1==1
				@nLin + 1 , 002 PSAY OemToAnsi(STR0068) + IIf(mv_par03==1,OemToAnsi(STR0069),OemToAnsi(STR0070))
				nCnt1 := nCnt1 + 2
			Endif
			@nLin	+ nCnt1, 055 PSAY aTipos[nD][2]
			@nLin	+ nCnt1, 128 PSAY Trans(aTotales[nD][1],cPictVals)
			@nLin	+ nCnt1, 143 PSAY Trans(aTotales[nD][2],cPictVals)
			@nLin	+ nCnt1, 158 PSAY Trans(aTotales[nD][3],cPictVals)
			@nLin	+ nCnt1, 173 PSAY Trans(aTotales[nD][4],cPictVals)
			@nLin	+ nCnt1, 188 PSAY Trans(aTotales[nD][5],"@E) 999,999,999,999.99")
			nCnt1	:=	nCnt1 + 1
		Endif
	Next
Endif
nLin	:=	nLin + nCnt1 + 1
If mv_par03 <> 2
	If nLin > nLinLin
		R020Cab()
	EndIf
	@ nLin, 050 PSAY OemToAnsi(STR0079)
	nLin := nLin + 3
	@ nLin, 002 PSAY OemToAnsi(STR0088)
	nLin := nLin + 3
	@ nlin, 050 PSAY OemToAnsi(STR0077)
 	nLin := nLin + 1
	@ nLin, 002 PSAY OemToAnsi(STR0071)
	@ nLin, 022 PSAY OemToAnsi(STR0076)
	@ nLin, 042 PSAY OemToAnsi(STR0078)
	@ nLin, 062 PSAY OemToAnsi(STR0085)
	@ nLin, 082 PSAY OemToAnsi(STR0086)
	@ nLin, 102 PSAY OemToAnsi(STR0087)
	nLin := nLin + 1	
	@ nLin, 002 PSAY aTotPesos [1][1]
	@ nLin, 022 PSAY aTotPesos [1][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [1][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [1][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [1][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [1][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [2][1]
	@ nLin, 022 PSAY aTotPesos [2][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [2][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [2][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [2][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [2][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [3][1]
	@ nLin, 022 PSAY aTotPesos [3][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [3][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [3][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [3][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [3][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	aTotPesos[4][2] := aTotPesos[1][2] + aTotPesos[2][2] + aTotPesos[3][2]
	aTotPesos[4][3] := aTotPesos[1][3] + aTotPesos[2][3] + aTotPesos[3][3]
	aTotPesos[4][4] := aTotPesos[1][4] + aTotPesos[2][4] + aTotPesos[3][4]
	aTotPesos[4][5] := aTotPesos[1][5] + aTotPesos[2][5] + aTotPesos[3][5]
	aTotPesos[4][6] := aTotPesos[1][6] + aTotPesos[2][6] + aTotPesos[3][6]
	@ nLin, 002 PSAY aTotPesos [4][1]
	@ nLin, 022 PSAY aTotPesos [4][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [4][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [4][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [4][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [4][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 3
	@ nLin, 002 PSAY OemToAnsi(STR0089)
	nLin := nLin + 3
	@ nlin, 050 PSAY OemToAnsi(STR0077)
	nLin := nLin + 1
	@ nLin, 002 PSAY OemToAnsi(STR0071)
	@ nLin, 022 PSAY OemToAnsi(STR0076)
	@ nLin, 042 PSAY OemToAnsi(STR0078)
	@ nLin, 062 PSAY OemToAnsi(STR0085)
	@ nLin, 082 PSAY OemToAnsi(STR0086)
	@ nLin, 102 PSAY OemToAnsi(STR0087)
	nLin := nLin + 1	
	@ nLin, 002 PSAY aTotDolar [1][1]
	@ nLin, 022 PSAY aTotDolar [1][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [1][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [1][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [1][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [1][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotDolar [2][1]
	@ nLin, 022 PSAY aTotDolar [2][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [2][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [2][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [2][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [2][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotDolar [3][1]
	@ nLin, 022 PSAY aTotDolar [3][2] Picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [3][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [3][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [3][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [3][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	aTotDolar[4][2] := aTotDolar[1][2] + aTotDolar[2][2] + aTotDolar[3][2]
	aTotDolar[4][3] := aTotDolar[1][3] + aTotDolar[2][3] + aTotDolar[3][3]
	aTotDolar[4][4] := aTotDolar[1][4] + aTotDolar[2][4] + aTotDolar[3][4]
	aTotDolar[4][5] := aTotDolar[1][5] + aTotDolar[2][5] + aTotDolar[3][5]
	aTotDolar[4][6] := aTotDolar[1][6] + aTotDolar[2][6] + aTotDolar[3][6]
	@ nLin, 002 PSAY aTotDolar [4][1]
	@ nLin, 022 PSAY aTotDolar [4][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [4][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [4][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [4][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [4][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 3
	@ nLin, 002 PSAY OemToAnsi(STR0090)
	nLin := nLin + 3
	@ nlin, 050 PSAY OemToAnsi(STR0077)
	nLin := nLin + 1
	@ nLin, 002 PSAY OemToAnsi(STR0071)
	@ nLin, 022 PSAY OemToAnsi(STR0076)
	@ nLin, 042 PSAY OemToAnsi(STR0078)
	@ nLin, 062 PSAY OemToAnsi(STR0085)
	@ nLin, 082 PSAY OemToAnsi(STR0086)
	@ nLin, 102 PSAY OemToAnsi(STR0087)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [1][1]
	@ nLin, 022 PSAY aTotPesos [1][2] + aTotDolar [1][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [1][3] + aTotDolar [1][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [1][4] + aTotDolar [1][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [1][5] + aTotDolar [1][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [1][6] + aTotDolar [1][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [2][1]
	@ nLin, 022 PSAY aTotPesos [2][2] + aTotDolar [2][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [2][3] + aTotDolar [2][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [2][4] + aTotDolar [2][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [2][5] + aTotDolar [2][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [2][6] + aTotDolar [2][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [3][1]
	@ nLin, 022 PSAY aTotPesos [3][2] + aTotDolar [3][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [3][3] + aTotDolar [3][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [3][4] + aTotDolar [3][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [3][5] + aTotDolar [3][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [3][6] + aTotDolar [3][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [4][1]
	@ nLin, 022 PSAY aTotPesos [4][2] + aTotDolar [4][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [4][3] + aTotDolar [4][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [4][4] + aTotDolar [4][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [4][5] + aTotDolar [4][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [4][6] + aTotDolar [4][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	Roda(0,"","")
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็เo    ณ VerImp   บAutor  ณMarcos Simidu       บ Data ณ  20/12/95   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica posicionamento de papel na Impressora             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerImp()

nLin:= 0                
nLinIni:=0
aDriver:=ReadDriver()
If aReturn[5]==2	
	nOpc       := 1
	While .T.		
		SetPrc(0,0)
		dbCommitAll()				
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."		
		If MsgYesNo(OemtoAnsi(STR0080))//"จFomulario esta posicionado ? "
			nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0081))//"จTenta Nuevamente ? "
			nOpc := 2
		Else
			nOpc := 3
		Endif	
		Do Case
		Case nOpc==1
			lContinua:=.T.
			Exit
		Case nOpc==2
			Loop
		Case nOpc==3
			lContinua:=.F.
			Return
		EndCase
	End
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็เo	 ณ ValidPergบAutor  ณ Jose Aurelio/Lucas บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica as perguntas incluํndo-as caso nไo existam        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LIBRURU - Listado de IVA Compras ou Ventas.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
Local i:=0, j:=0
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("LIBURU",6)
aRegs:={}
aAdd(aRegs,{cPerg,"01","Data Inicio         ?","จFecha Inicio       ?","Initial Date        ?","mv_ch1","D",8,0,0,"G","","mv_par01",    "",    "",   "","01/01/80","",         "",       "",      "","","",      "",       "",      "","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Fim            ?","จFecha Fin          ?","Final Date          ?","mv_ch2","D",8,0,0,"G","","mv_par02",    "",    "",   "","31/12/99","",         "",       "",      "","","",      "",       "",      "","","","","","",""})
aAdd(aRegs,{cPerg,"03","Imprimir            ?","จImprimir           ?","Print               ?","mv_ch3","N",1,0,0,"C","","mv_par03","Tudo","Todo","All",        "","","Relatorio","Informe","Report","","","Resumo","Resumen","Resume","","","","","",""})
aAdd(aRegs,{cPerg,"04","Considera canceladas?","จConsidera Anuladas ?","Consider cancelled  ?","mv_ch4","N",1,0,0,"C","","mv_par04", "Sim",  "Si","Yes",        "","",      "Nao",     "No",    "No","","",      "",       "",      "","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return
