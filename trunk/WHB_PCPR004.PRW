#Include "WHB_PCPR004.CH"
#Include "FIVEWIN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MATR880   ³ Autor ³Felipe Nunes Toledo    ³ Data ³ 11/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MRP                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß           

WHB 31/08/2010
Por padrão um mes terá 4semanas de 6 dias cada.
Cada quinzena tem 2 semanas de 6 dias cada.

*/
user Function pWhbr004(lUsed)

Default lUsed      := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |                 
//| nestes fontes. NAO REMOVER !!!                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
EndIf


MATR880R3(lUsed)

Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa    MATR880.PRW ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data          |BOPS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³Flavio Luiz Vicco         ³ 27/04/2006    |   00000097325   ³±±
±±³      02  ³Flavio Luiz Vicco         ³ 18/01/2006    |                 ³±±
±±³      03  ³Erike Yuri da Silva       ³ 02/06/2006    |   00000099418   ³±± <-- Devido os arquivos principais serem binarios nao foi incluida nenhuma query
±±³      04  ³Erike Yuri da Silva       ³ 02/06/2006    |   00000099418   ³±±
±±³      05  ³Flavio Luiz Vicco         ³ 27/04/2006    |   00000097325   ³±±
±±³      06  ³Flavio Luiz Vicco         ³ 16/03/2006    |   00000094092   ³±±
±±³      07  ³Flavio Luiz Vicco         ³ 15/02/2006    |   00000089829   ³±±
±±³      08  ³Flavio Luiz Vicco         ³ 16/03/2006    |   00000094092   ³±±
±±³      09  ³Flavio Luiz Vicco         ³ 15/02/2006    |   00000089829   ³±±
±±³      10  ³Flavio Luiz Vicco         ³ 18/01/2006    |                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR880  ³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 02/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  MRP                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR880(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
static Function MATR880R3(lUsed)
Local titulo   := "MRP v.2"
LOCAL cString  := "SB1"
Local wnrel    := "MATR880"
Local cDesc    := STR0002  //"Este programa ira imprimir a Rela‡„o do MRP"
Local tamanho  := "M"
Local aArea    := GetArea()
Local aAreaSHA := {}
Local aAreaSH5 := {}
Local nParRel,cProdIni,cProdFim,lLogMrp,lVNecesEst
Local lContinua:= .T.
DEFAULT lUsed       := .F.
PRIVATE aReturn     := {STR0003,1,STR0004, 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nLastKey    := 0
PRIVATE cPerg       := "MTR880WHB"
Private nTipoCusto  := 1
Private nPeriodos   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                    ³
//³ mv_par01 - Lista ? Tudo     So' c/ Saidas   So' c/ Neces.               ³
//³ mv_par02 - De Produto                                                   ³
//³ mv_par03 - Ate Produto                                                  ³
//³ mv_par04 - Lista log de eventos  1 = sim 2 = nao                        ³
//³ mv_par05 - Custo Produto: 1-Custo Standard;2-Custo Medio;3-Preco Compra ³
//³ mv_par06 - Aglutina Periodos     1 = sim 2 = nao                        ³
//³ mv_par07 - Periodos para aglutina                                       ³
//³ mv_par08 - Lista a Necess. da Estrutura? 1 = sim 2 = nao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui pergunta no SX1                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1("MTR880WHB","01","Lista MRP ?"                  ,"Lista MRP ?"                  ,"Lista MRP ?"                  ,"mv_ch1","N", 1,0,1,"C","",""   ,"","","mv_par01","Tudo","Tudo","Tudo","","So com Saidas","So com Saidas","So com Saidas","Só c/ Nec.","Só c/ Nec.","Só c/ Nec.","","","","","", "",{"","",""},{"","",""}, {"","",""})
PutSx1("MTR880WHB","02","De  Produto ?"                ,"De  Produto ?"                ,"De  Produto ?"                ,"mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","", "",{"","",""},{"","",""}, {"","",""})
PutSx1("MTR880WHB","03","Ate Produto ?"                ,"Ate Produto ?"                ,"Ate Produto ?"                ,"mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","Sim","Si","Yes","","Nao","No","No","","","","","","","","", "", {"","",""},{"","",""}, {"","",""})
PutSx1("MTR880WHB","04","Lista Log de Eventos do MRP ?","Lista Log de Eventos do MRP ?","Lista Log de Eventos do MRP ?","mv_ch4","N", 1,0,1,"C","",""   ,"","","mv_par04","Tudo","Tudo","Tudo","","So com Saidas","So com Saidas","So com Saidas","Só c/ Nec.","Só c/ Nec.","Só c/ Nec.","","","","","", "",{"","",""},{"","",""}, {"","",""})
PutSx1("MTR880WHB","05","Custo Produto   "             ,"Costo Producto"			   ,"Product Cost"   		       ,"mv_ch5","N", 1,0,1,"C","",""   ,"","","mv_par05","Custo Standard","Costo Estandar","Standard Cost","","Custo Medio","Costo Promedio","Average Cost","Preco Compra","Precio Compra","Average Cost","Não Mostra","Não Mostra","Não Mostra","","", "", {"1) Custo Standard " , "2) Custo Medio "   , "3) Preco Compra" }, {"1) Costo Estandar", "2) Costo Promedio", "3) Precio Compra"}, {"1) Standard Cost" , "2) Average Cost"  , "3) Average Cost" })
PutSx1("MTR880WHB","06","Aglutina Periodos"            ,"Agrupa Periodos ?"       	   ,"Group periods ?" 		       ,"mv_ch6","N", 1,0,2,"C","",""   ,"","","mv_par06","Sim","Si","Yes","","Nao","No","No","","","","","","","","", "", {"Se informado Sim soma mais de um "        , "periodo na mesma coluna"}, {}, {})
PutSx1("MTR880WHB","07","Periodos para aglutinar"      ,"Periodos para agrupar ?" 	   ,"Periods to group ?" 	       ,"mv_ch7","N", 3,0,8,"G","",""   ,"","","mv_par07","","","","","","","","","","","","","","","","",{"Numero de periodos a serem somados e "    , "exibidos em cada coluna"}, {}, {})
PutSx1("MTR880WHB","08","Lista a Necess. da Estrutura?","Lista a Necess. da Estrutura?","Lista a Necess. da Estrutura?","mv_ch8","N", 1,0,2,"C","",""   ,"","","mv_par08","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",{"Permite listar a necessidade da estru-" , "tura do produto caso exista"}, {}, {})
PutSx1("MTR880WHB","09","Aglut. Necessidade ?"         ,"Aglut. Necessidade ?"         ,"Aglut. Necessidade ?"         ,"mv_ch9","N", 1,0,2,"C","",""   ,"","","mv_par09","Semanal","Semanal","Semanal","","Quinzenal","Quinzenal","Quinzenal","Mensal","Mensal","Mensal","Não Mostra","Não Mostra","Não Mostra","","", "", {"Se informado Sim soma mais de um "        , "periodo na mesma coluna"}, {}, {})

Pergunte(cPerg,.F.)

wnrel       := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,"",,Tamanho)
nParRel     := mv_par01
cProdIni    := mv_par02
cProdFim    := mv_par03
lLogMrp     := mv_par04==1
nTipoCusto  := mv_par05
lQuebraPer  := mv_par06 == 1
nNumPer     := mv_par07
lVNecesEst  := mv_par08 ==1

If nLastKey = 27
	dbClearFilter()
	lContinua := .F.
EndIf

If lContinua
	SetDefault(aReturn,cString)
EndIf

If lContinua .And. nLastKey = 27
	dbClearFilter()
	lContinua := .F.
EndIf

If lContinua
	If lUsed
		aAreaSHA:=SHA->(GetArea());aAreaSH5:=SH5->(GetArea())
	EndIf
	RptStatus({|lEnd| R880Imp(@lEnd,wnRel,titulo,tamanho,lUsed,nParRel,cProdIni,cProdFim,lLogMrp,lVNecesEst)},titulo)
	If lUsed
		RestArea(aAreaSHA)
		RestArea(aAreaSH5)
	EndIf
EndIf

RestArea(aArea)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R880Imp  ³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 02/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR880                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R880Imp(lEnd,wnRel,titulo,tamanho,lUsed,nParRel,cProdIni,cProdFim,lLogMrp,lVNecesEst)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt,j
LOCAL CbCont,cabec1,cabec2,i
LOCAL limite    := 132
LOCAL nomeprog  := "MATR880"
LOCAL cArquivo,cArquivo2,nTotLin,cSeekLog:="",cNecEstrAtu := ""
LOCAL aOrdem    := Array(6), lLista, lImprimiu
LOCAL cCondSH5  := "H5_PRODUTO != '"+Criavar("B1_COD",.F.)+"'"
LOCAL aPeriodos := {}
Local aPerOri   := {}
LOCAL nTotProd  := 0
LOCAL nTotal    := 0
LOCAL cDrvSHA   := ""
LOCAL nTipo     := 0
Local aNeces    := {}
Local nNecEstr  := 0
Local nCusto    := 0
Local nQtdPer   := 0
Local aListaNec := {}
Local nC        := 0
Local lContinua	:= .T.
Local nWhbQuant := 0
Local nCount    := 0
Local aCount    := {}
/*
aCount[1] := Produto
aCount[2] := Descrição
aCount[3] := Un
aCount[4] := Quantidade
*/


Private aPerQuebra := {}

#IFDEF WNTX
	cDrvSHA := "DBFNTX"
#ENDIF
#IFDEF WCDX
	cDrvSHA := "DBFCDX"
#ENDIF
#IFDEF WAXS
	cDrvSHA := "DBFCDXAX"
#ENDIF

aOrdem[1] := STR0005
aOrdem[2] := STR0006
aOrdem[3] := STR0007
aOrdem[4] := STR0017
aOrdem[5] := STR0008
aOrdem[6] := STR0009

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsed != .t.
	lContinua := A710OpenFMRP(.T.)
EndIf

If lContinua
	dbSelectArea("SH5")
	If !Empty(dbFilter())
		dbClearFilter()
	EndIf
	dbSetOrder(1)
	dbGotop()
	
	dbSelectArea("SHG")
	dbSetOrder(1)
	
	aPeriodos:=R880PER(@nTipo)
	
	If lQuebraPer
		aPerOri    := aClone(aPeriodos)
		aPerQuebra := R880DivPeriodo(aPeriodos, .T.)
		aPeriodos  := R880DivPeriodo(aPeriodos)
	EndIf
	
	dbSelectArea("SH5")
	Set Filter to &cCondSH5
EndIf	

If lContinua
	dbSelectArea("SHA")
	dbGotop()
	SetRegua(LastRec())
	Titulo  := Titulo+" - "+STR0018+" "+SHA->HA_NUMMRP
	NTotLin := Len(aPeriodos) / 5
	nTotLin := If(Len(aPeriodos) % 6 > 0,++nTotLin,nTotLin)
	While !Eof()
		If lEnd
			@ Prow()+1,001 PSay STR0011	//"CANCELADO PELO OPERADOR"
			Exit
		EndIf
		IncRegua()
		nRec := Recno()
		cSeekLog  := SHA->HA_NUMMRP+SHA->HA_PRODUTO
		lImprimiu := .F.
		If SHA->HA_PRODUTO >= cProdIni .And. SHA->HA_PRODUTO <= cProdFim .And. SB1->(dbSeek(xFilial("SB1")+SHA->HA_PRODUTO))
			If li > 50
				cabec(titulo,"","",nomeprog,tamanho,18)
				@ li,00 PSay __PrtFatLine()
				li++
			EndIf
			lLista		:= R880FILTRO(nParRel,nTipo)
			lImprimiu	:= .f.
			If lLista
				nTotProd	:= 0
				lImprimiu	:= .t.
				nCusto		:= R880Custo(SB1->B1_COD)
				@ li,00 PSay STR0012 +SB1->B1_COD +SPACE(3) + Substr(SB1->B1_DESC,1,30) + SPACE(3) +STR0013;	//"PRODUTO: "###"UM:"
				+ SB1->B1_UM + SPACE(3)+STR0014 + Str(RetFldProd(SB1->B1_COD,"B1_LE"), Posicione("SX3", 2, "B1_LE", "X3_TAMANHO"), Posicione("SX3", 2, "B1_LE", "X3_DECIMAL")) + SPACE(3) + Upper(AllTrim(RetTitle("B1_ESTSEG"))) + ": " + Str(RetFldProd(SB1->B1_COD,"B1_ESTSEG"), Posicione("SX3", 2, "B1_ESTSEG", "X3_TAMANHO"), Posicione("SX3", 2, "B1_ESTSEG", "X3_DECIMAL")) + Space(3) + STR0015+ SB1->B1_TIPO	//"LOTE ECON: "### "TIPO: "
				li++
				dbSelectArea("SHA")
				nCount := 0
				nPerIni := 1
				nWhbQuant := 0
				While .t.
					dbGoto(nRec)
					nCol := 30
					li++
					// ---- Imprime Periodos
					@ li,00 PSay STR0016  //"Periodos"
					If lQuebraPer .And. nNumPer > 1
						@ li,10 PSay STR0024  //"(inicial)"
					EndIf
					For i:= nPerIni to nPerIni+5
						If i > Len(aPeriodos)
							Exit
						EndIf
						@ li,nCol PSay DtoC(aPeriodos[i])
						nCol += 15
					Next i
					// ---- Se Aglutina em mais de 1 periodo, Imprime data final do periodo
					If lQuebraPer .And. nNumPer > 1
						nCol := 30
						li++
						@ li,10 PSay STR0025  //"(final)"
						For i:= nPerIni to nPerIni+5
							If i > Len(aPeriodos)
								Exit
							EndIf
							// ---- Calcula posicao no array de periodos
							// ---- = (coluna-1)*nro.periodos p/ aglutinar+len(array periodos aglutinados)
							nC := (i-1)*nNumPer+Len(aPerQuebra[i,2])
							@ li,nCol PSay DtoC(aPerOri[nC])
							nCol += 15
						Next i
					EndIf
					// ----
					li += 2
					aNeces := {}
					For i := 1 to 6
						nCol := 23
						@ li,00 PSay allTrim(aOrdem[i])+" (Ton)"
						For j := nPerIni to nPerIni+5
							If j > Len(aPeriodos)
								Exit
							EndIf
							
							nQtdPer := R880ValField(j)

							//Convertendo para tonelada
							@ li,nCol PSay (nQtdPer/1000) Picture "999999999999.99"
							nCol+=15
							If i == 6
								aAdd(aNeces, nQtdPer)
								nWhbQuant += nQtdPer
								nTotProd+= nQtdPer
								
								//Acumulando para imprimir no final do relatório
								If  SB1->B1_TIPO == "MP"
									xPos := aScan(aCount,{|x| x[1] == SB1->B1_COD})
									
									If ( xPos == 0 )
										aAdd(aCount,{SB1->B1_COD,SB1->B1_DESC,"Ton",nQtdPer})
									Else
										aCount[xPos,4] += nQtdPer
									Endif
								Endif
							EndIf
						Next
						SHA->(dbSkip())
						li++
					Next
	            
					//Tipo Custo igual a 4 é não imprime.
					If ( nTipoCusto != 4 )
						nCol := 23
						@ li,00 PSay STR0020 // "Valor"
						For j := 1 to Len(aNeces)
							@ li,nCol PSay aNeces[j] * nCusto Picture "999999999999.99"
							nCol+=15
						Next
	                Endif

					nCount++

					//Imprime total semanal
					If ( mv_par09 == 1 )
						li+= 1
						nCol := 16
						@ li,00 PSay "Total Semanal(Ton):"
						@ li,nCol PSay (nWhbQuant/1000) Picture "999999999999.99"
						nWhbQuant := 0
					
					//Imprime total Mensal
					ElseIf ( mv_par09 == 2 .And. mod(nCount,2)  == 0 ) .Or. ( mv_par09 == 2 .And. nPerIni+6 > Len(aPeriodos) )
						li+= 1
						nCol := 16
						@ li,00 PSay "Total Quinzenal(Ton):"
						@ li,nCol PSay (nWhbQuant/1000) Picture "999999999999.99"
						nWhbQuant := 0
					
					//Imprime total Mensal
					ElseIf ( mv_par09 == 3 .And. mod(nCount,4)  == 0 ) .Or. ( mv_par09 == 3 .And. nPerIni+6 > Len(aPeriodos) )
						li+= 1
						nCol := 16
						@ li,00 PSay "Total Mensal(Ton):"
						@ li,nCol PSay (nWhbQuant/1000) Picture "999999999999.99"
						nWhbQuant := 0

					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Lista a necessidade da estrutura do produto possicionado a partir da    ³
					//³ da tabela SH5 com H5_ALIAS igual a "SHA".                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lVNecesEst
						//Reposiciono no produto
						DbSelectArea("SHA")
						DbGoto(nRec)
						aListaNec := R880LstNec(SHA->HA_PRODUTO+"SHA",aPeriodos,nPerIni)
						If !Empty(aListaNec)
							li+=2
							@ li,00 PSay STR0022
							cNecEstrAtu := ""
							For i:=1 To Len(aListaNec)
								If cNecEstrAtu<>aListaNec[i,1] .Or. !lQuebraPer
									cNecEstrAtu := aListaNec[i,1]
									li++
								EndIf
								@ li,000 PSay aListaNec[i,1]
								nCol := 16
								For j := nPerIni to nPerIni+5
									If j > Len(aPeriodos)
										Exit
									EndIf
									nNecEstr := 0
									If aPeriodos[j]==aListaNec[i,3]
										nNecEstr := aListaNec[i,2]
									EndIf
									@ li,nCol PSay nNecEstr Picture "999999999999.99"
									nCol+=15
								Next
	
								If li > 60
									cabec(titulo,"","",nomeprog,tamanho,18)
									@ li,00 PSay __PrtFatLine()
									li++
								EndIf
							Next
							li++
						EndIf
					EndIf
					
					nPerIni+=6
					If nPerIni > Len(aPeriodos)
						Exit
					EndIf
					If li > 50
						cabec(titulo,"","",nomeprog,tamanho,18)
						@ li,00 PSay __PrtFatLine()
						li++
					EndIf
					//li++
				Enddo


				//Tipo Custo igual a 4 é não imprime.
				If ( nTipoCusto != 4 )
					li += 2
					nCol := 16
					@ li,00 PSay STR0021	//"Tot Vl. Produto:"
					@ li,nCol PSay nTotProd * nCusto Picture "999999999999.99"
				Endif

				li+= 2
				nTotProd := 0

			EndIf
	
			// Lista os eventos de log desse produto
			If lLogMrp
				dbSelectArea("SHG")
				If dbSeek(xFilial("SHG")+cSeekLog)
					If li > 50
						cabec(titulo,"","",nomeprog,tamanho,18)
					EndIf
					@ li,00 PSay OemToAnsi(STR0019) //"Eventos relacionados ao produto"
					li++
					li++
					While !EOF() .AND. xFilial("SHG")+cSeekLog == HG_FILIAL+HG_SEQMRP+HG_COD
						If li > 50
							cabec(titulo,"","",nomeprog,tamanho,18)
						EndIf
						@ li,00 PSay HG_LOGMRP
						li++
						dbSkip()
					End
					li++
				EndIf
			EndIf
			dbSelectArea("SHA")
		EndIf
		DbGoto(nRec)
		DbSkip(6)
		If lImprimiu
			@ li,00 PSay __PrtThinLine()
			li++
		EndIf
	End

	cabec(titulo,"TOTAL GERAL DAS MATÉRIAS-PRIMA","PRODUTO          DESCRICAO                      UN      QUANTIDADE",nomeprog,tamanho,18)
   
	For s := 1 to Len(aCount)

		//Desconsidera produto zerado
		If ( aCount[s,4] == 0 )
			Loop
		Endif

		//Quebra
		If li > 50
			cabec(titulo,"TOTAL GERAL DAS MATÉRIAS-PRIMA","PRODUTO          DESCRICAO                      UN      QUANTIDADE",nomeprog,tamanho,15)
		EndIf

		@ li,00 pSay aCount[s,1]
		@ li,17 pSay aCount[s,2]
		@ li,48 pSay aCount[s,3]
		@ li,52 pSay transForm(aCount[s,4]/1000,"99999999999.99")
		li++

	Next
		
	If li != 80
		roda(cbcont,cbtxt)
	EndIf

EndIf	
If lContinua .And. lUsed != .t.
	dbSelectArea("SHA")
	dbCloseArea()
	dbSelectArea("SH5")
	dbCloseArea()
EndIf
dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)
If aReturn[5] = 1
	Set Printer TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()
Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R880Per    ³ Autor ³Rodrigo de A. Sartorio³ Data ³ 03/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de montagem de array aperiodos para Impressao        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR880                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R880PER(nTipo)
Local i, dInicio
Local aRet:={}
Local nPosAno, nTamAno, cForAno
Local lConsSabDom:=Nil
Pergunte("MTA712",.F.)
lConsSabDom:=mv_par12 == 1
Pergunte(cPerg, .F.)
If __SetCentury()
	nPosAno := 1
	nTamAno := 4
	cForAno := "ddmmyyyy"
Else
	nPosAno := 3
	nTamAno := 2
	cForAno := "ddmmyy"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona registro em array totalizador utilizado no TREE  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SH5")
dbSetOrder(1)
dbGotop()
While !Eof()
	// Recupera parametrizacao gravada no ultimo processamento
	// A T E N C A O
	// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
	// os periodos de maneira desordenada, por causa do indice do arquivo SH5
	// O array aRet é corrigido logo abaixo
	If H5_ALIAS == "PAR"
		nTipo       := H5_RECNO
		dInicio     := H5_DATAORI
		nPeriodos   := H5_QUANT
		If nTipo == 7
			AADD(aRet,DTOS(CTOD(Alltrim(H5_OPC))))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ NUMERO DO MRP                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		c711NumMRP:=H5_NUMMRP
	EndIf
	dbSkip()
End

//Somente para nTipo==7 (Periodos Diversos) re-ordena aRet
//pois como o H5_OPC esta gravado a data como caracter ex:(09/10/05)
//o arquivo esta indexado incorretamente (diferente de 20051009)
If !Empty(aRet)
	ASort(aRet)
	For i:=1 To Len(aRet)
		aRet[i] := STOD(aRet[i])
	Next i
EndIf

If (nTipo == 2)                         // Semanal
	While Dow(dInicio)!=2
		dInicio--
	EndDo
ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6),cForAno)
ElseIf (nTipo == 5)                     // Trimestral
	If Month(dInicio) < 4
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
		dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >=10)
		dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7),cForAno)
	EndIf
ElseIf (nTipo == 6)                     // Semestral
	If Month(dInicio) <= 6
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
	Else
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
	EndIf
EndIf
If nTipo != 7
	For i := 1 to nPeriodos
		AADD(aRet,dInicio)
		If nTipo == 1
			dInicio ++
			While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
				dInicio++
			EndDo
		ElseIf nTipo == 2
			dInicio+=7
		ElseIf nTipo == 3
			dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
	 		If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
			Str(Year(dInicio)+1,4)+"0101")),cForAno)			
		ElseIf nTipo == 4
			dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 5
			dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 6
			dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		EndIf
	Next i
EndIf
Return aRet

Static Function R880FILTRO(nParRel,nTipo)
Local ni,lRet := .f.,cAlias := Alias(),nReg:=0
dbSelectArea("SHA")
nReg:=Recno()
If nParRel == 1
	lRet := .T.
ElseIf nParRel == 2
	dbSkip(2)
	For ni := 1 to nPeriodos
		cCampo := "HA_PER"+StrZero(ni,3)
		If &(cCampo) != 0
			lRet := .t.
			Exit
		EndIf
	Next
	If !lRet
		dbSkip()
		For ni := 1 to nPeriodos
			cCampo := "HA_PER"+StrZero(ni,3)
			If &(cCampo) != 0
				lRet := .t.
				Exit
			EndIf
		Next
	EndIf
ElseIf nParRel == 3
	dbSkip(5)
	For ni := 1 to nPeriodos
		cCampo := "HA_PER"+StrZero(ni,3)
		If &(cCampo) != 0
			lRet := .t.
			Exit
		EndIf
	Next
EndIf
dbGoto(nReg)
dbSelectArea(cAlias)
Return (lRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R880Custo  ³ Autor ³Marcelo Iuspa         ³ Data ³ 05/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o custo do produto informado baseado na opcao       ³±±
±±³          ³ do pergunte (mv_par05):                                     ³±±
±±³          ³ Custo Produto: 1-Custo Standard;2-Custo Medio;3-Preco Compra³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR880                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function R880Custo(cProd)
Local nCusto := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
	Final("Atualizar SIGACUS.PRW !!!")
EndIf
If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
	Final("Atualizar SIGACUSA.PRX !!!")
EndIf
If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
	Final("Atualizar SIGACUSB.PRX !!!")
EndIf

SB1->(MsSeek(xFilial("SB1") + cProd))
If nTipoCusto == 1
	nCusto := RetFldProd(SB1->B1_COD,"B1_CUSTD")
	cStr:="1"
ElseIf nTipoCusto == 2
	nCusto := PegaCmAtu(cProd, RetFldProd(SB1->B1_COD,"B1_LOCPAD"))[1]
	cStr:="2"
ElseIf nTipoCusto == 3
	nCusto := RetFldProd(SB1->B1_COD,"B1_UPRC")
	cStr:="3"
EndIf
Return(nCusto)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R880DivPeriodo ³ Autor ³ Marcelo Iuspa    ³ Data ³ 18/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o array de periodos aglutinados conforme parametro  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPeriodos  - Array original de periodos do MRP              ³±±
±±³          ³ lRetQuebra - Se .T. retorna array com os periodos de cada   ³±±
±±³          ³              faixa aglutinada                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR880                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function R880DivPeriodo(aPeriodos, lRetQuebra)
Local nLenArr := Len(aPeriodos)
Local nLoop   := Nil
Local nAglut  := 1
Local aRetPer := {aPeriodos[1]}
Local aQuebra := {{1, {1}}}

Default lRetQuebra := .F.

For nLoop := 2 to nLenArr
	If nAglut >= nNumPer
		Aadd(aRetPer, aPeriodos[nLoop])
		Aadd(aQuebra, {Len(aQuebra)+1, {}})
		nAglut := 1
	Else
		nAglut ++
	EndIf
	Aadd(aQuebra[Len(aQuebra), 2], nLoop)
Next

Return(If(lRetQuebra, aQuebra, aRetPer))

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R880ValField   ³ Autor ³ Marcelo Iuspa    ³ Data ³ 18/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna soma de periodos para o periodo aglitinado          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nPeriodo   - Periodo aglutinado a obter a soma              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR880                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function R880ValField(nPeriodo)
Local nRet  := 0
Local nLoop := 0
Local aPer  := Nil

If ! lQuebraPer
	nRet := SHA->(FieldGet(FieldPos("HA_PER" + StrZero(nPeriodo, 3))))
Else
	aPer := aPerQuebra[nPeriodo, 2]
	For nLoop := 1 to Len(aPer)
		nRet += SHA->(FieldGet(FieldPos("HA_PER" + StrZero(aPer[nLoop], 3))))
		If SHA->HA_TIPO == "1"
			Exit
		ElseIf SHA->HA_TIPO == "5"
			nRet := SHA->(FieldGet(FieldPos("HA_PER" + StrZero(aPer[nLoop], 3))))
		EndIf
	Next
EndIf
Return(nRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R880LstNec     ³ Autor ³ Erike Y. da Silva³ Data ³ 09/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lista a estrutura da necessidade do produto                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cChave  - Codigo do produto filho que sera usado na explosao³±±
±±³          ³           da necessidade.                                   ³±±
±±³          ³ aPeriodos- Array com os periodos definidos pela parametrizac³±±
±±³          ³ nPerIni  - Periodo inicial a ser analisado no array aPeriodos±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR880                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R880LstNec(cChave,aPeriodos,nPerIni)
Local nPos,nI
Local nTamPer   := Len(aPeriodos)
Local lContinua := .F.
Local aLista    := {}
Local cAlias    := Alias()
Local aAreaSH5  := SH5->(GetArea())

DbSelectArea("SH5")
SH5->(dbSetOrder(3))
SH5->(dbSeek(cChave))
While SH5->(!Eof() .AND. H5_PRODUTO+H5_ALIAS==cChave)
	lContinua := .F.
	For nI:=nPerIni To nPerIni+5
		If nI> nTamPer
			Exit
		EndIf
		If aPeriodos[nI]==SH5->H5_DATAORI
			lContinua := .T.
			Exit
		EndIf
	Next

	If !lContinua
		SH5->(DbSkip())
		Loop
	EndIf

	nPos := AsCan(aLista,{|x|x[1]==SH5->H5_DOC .and. x[3]==SH5->H5_DATAORI})
	If Empty(nPos) .Or. !lQuebraPer
		SB1->(MsSeek(xFilial("SB1") + SH5->H5_DOC))
		Aadd(aLista,{SH5->H5_DOC,SH5->H5_QUANT,SH5->H5_DATAORI})
	Else
		aLista[nPos,2] += SH5->H5_QUANT
	EndIf
	SH5->(DbSkip())
EndDo

If !Empty(aLista)
	aLista := aSort(aLista,,,{|x,y|x[1]<y[1]})
EndIf

RestArea(aAreaSH5)           
DbSelectArea(cAlias)
Return aClone(aLista)
