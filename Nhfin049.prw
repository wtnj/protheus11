#include "finr620.CH"
#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINR620	³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR620(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Nhfin049()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := STR0001  //"Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria"
LOCAL cDesc2 := STR0002  //"de acordo com os parametros definidos pelo usuario. Poder  ser"
LOCAL cDesc3 := STR0003  //"impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o."
LOCAL cString := "SE5"
LOCAL aOrd := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0034)}  //"Por Dt.Dispo"###"Por Banco"###"Por Natureza"###"Dt.Digitacao"###"Por Dt. Movimentacao"
Local cTamanho
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local aPergs	:= {}

PRIVATE titulo 
PRIVATE cabec1	:= ""
PRIVATE cabec2 := ""
PRIVATE aReturn := { OemToAnsi(STR0019), 1,OemToAnsi(STR0020), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR620"
PRIVATE nLastKey := 0
PRIVATE cPerg	 :="FIN620"
PRIVATE lRel
PRIVATE _cArqDbf
PRIVATE _cArqDb2

lRel := .F.   
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
AADD(aHelpPor,'Informe "Sim" se deseja imprimir os ')
AADD(aHelpPor,'saldos anterior e atual					')
AADD(aHelpSpa,'Informe "Si" si desea imprimir los ' )
AADD(aHelpSpa,'saldos anterior y actual.')
AADD(aHelpEng,'Inform "Yes" if you want to print ' )
AADD(aHelpEng,'the current and previous balances')

Aadd(aPergs,{"Imprime saldos?","¿Imprime saldos?","Print Balances?","mv_ch7","N",1,0,2,"C","","mv_par15","Sim","Si ","Yes","","","Nao","No ","No ","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

AjustaSx1("FIN620",aPergs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN620",.T.)
mv_par11 := Iif(Empty(mv_par11),1,mv_par11)
titulo := STR0021 + If(mv_par11==1, STR0022, STR0023) //" Analitico"###" Sintetico"
// Seta o tamanho do relatorio, G - Analitico e ordem <> 3 e M - Caso contrario.
cTamanho :=	If(mv_par11==1 .And. aReturn[8] != 3,"G","M")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								 ³
//³ mv_par01				// da data										 ³
//³ mv_par02				// ate a data									 ³
//³ mv_par03				// do banco 									 ³
//³ mv_par04				// ate o banco 								 ³
//³ mv_par05				// da natureza 								 ³
//³ mv_par06				// ate a natureza 							 ³
//³ mv_par07				// da data de digitacao 					 ³
//³ mv_par08				// ate a data de digitacao 				 ³
//³ mv_par09				// qual moeda									 ³
//³ mv_par10				// tipo de historico 						 ³
//³ mv_par11				// Analitico / Sintetico					 ³
//³ mv_par12				// Considera filiais      				    ³
//³ mv_par13				// Filial De					 	          ³
//³ mv_par14				// Filial Ate			   					 ³
//³ mv_par15				// Imprime saldos		   					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR620"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,cTamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa620Imp(@lEnd,wnRel,cString,cTamanho)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA620Imp ³ Autor ³ Wagner Xavier 	    ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA620Imp(lEnd,wnRel,Cstring)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock								  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 							  ³±±
±±³			 ³ cString - Mensagem										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA620Imp(lEnd,wnRel,cString,cTamanho)
LOCAL CbCont,CbTxt
LOCAL nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nColuna := 0,lContinua := .T.
LOCAL nValor,cDoc
LOCAL lVazio  := .T.
LOCAL nMoeda, cTexto
#IFDEF TOP
	Local ni
	Local aStru 	:= SE5->(dbStruct())
	Local cIndice	:= SE5->(IndexKey())
#ELSE
	LOCAL nOrdSE5 :=SE5->(IndexOrd())
	LOCAL cChave		
#ENDIF	

LOCAL cIndex
LOCAL cHistor
LOCAL cChaveSe5
Local nTxMoeda:=0
Local cFilterUser := aReturn[7]
Local nMoedaBco	:=	1                                   
Local nCasas		:= GetMv("MV_CENT"+(IIF(mv_par09 > 1 , STR(mv_par09,1),""))) 
LOCAL bWhile   := { || IF( mv_par12 == 1, .T., SE5->E5_FILIAL == xFilial("SE5") ) }
Local nTotSaldo := 0
Local aSaldo
Local nGerSaldo := 0
Local nSaldoAtual := 0
Local lFirst := .T.
Local nTxMoedBc	:= 0
Local cPict := ""
Local nA	:= 0
Local lF620Qry := ExistBlock("F620QRY")
Local cQueryAdd := ""
Local nSaldoAnt := 0
Local lImpSaldo := .F.
Local nAscan := 0
Local cAnterior := ""
Local nBancos := 0
Local cCond2 := ""
Local cCond3 := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso so'exista uma empresa/filial ou o SE5 seja compartilhado³
//³ nao ha' necessidade de ser processado por filiais            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par12 := Iif(SM0->(Reccount()) == 1 .or. Empty(xFilial("SE5")),2,mv_par12)
aSaldo := GetSaldos( MV_PAR12 == 1, nMoeda, If(mv_par12==1,mv_par13,xFilial("SA6")), If(mv_par12==1,mv_par14,xFilial("SA6")), mv_par01)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

cMoeda := Str(mv_par09,1,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos						             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	titulo := STR0008 //"Relacao da Movimentacao Bancaria em "
	If aReturn[8] != 3 .And. mv_par15 == 1 // Ordem de natureza nao sera impresso os saldos
		cabec1 := STR0024 //"DATA       BCO AGENCIA  CONTA      NATUREZA    DOCUMENTO                              VALOR                               HISTORICO"
		cabec2 := STR0025 //"                                                                           ENTRADA             SAIDA        SALDO ATUAL"
	Else
		cabec1 := OemToAnsi(STR0009)  //"  DATA   BCO AGENCIA  CONTA    NATUREZA      DOCUMENTO                            VALOR             HISTORICO"
		cabec2 := OemToAnsi(STR0010)  //"                                                                        ENTRADA             SAIDA            "
	Endif	
Else
	titulo := STR0026 //"Movimentação Bancária em "
	cabec1 := If(	mv_par15 == 1, STR0027,;
						StrTran(StrTran(StrTran(STR0027,"SALDO ATUAL",""),"SALDO ACTUAL",""),"CURR. BALN.","")) //"                                    ENTRADA             SAIDA        SALDO ATUAL"
Endif	


nMoeda	:= mv_par09
cTexto	:= GetMv("MV_MOEDA"+Str(nMoeda,1))
Titulo	+= cTexto
titulo   += STR0028 + If(mv_par11==1, STR0029, STR0030) + STR0028 //" - "###"Analitico"###"Sintetico"###" - "
dbSelectArea("SE5")

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5")
		IF mv_par12 == 1
		   cQuery += " WHERE E5_FILIAL BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "'"	
      ELSE
		   cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
		ENDIF
		cQuery += " AND D_E_L_E_T_ <> '*' "
	Endif
#ENDIF

If aReturn[8] == 1
	titulo += OemToAnsi(STR0011)  //" por data"
	#IFDEF TOP
		cCondicao 	:= ".T."
		cCond2 		:= "E5_DTDISPO"
		IF mv_par12 == 1
			cOrder  := "E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
			cOrde2  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
		ELSE
			cOrder  := "E5_FILIAL+E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA"
			cOrde2  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
		ENDIF
	#ELSE
		cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
		cCond2 := "E5_DTDISPO"
		dbSelectArea("SE5")
		dbSetOrder(nOrdSE5)
		cIndex	:= CriaTrab(nil,.f.)
      IF mv_par12 == 1
		   cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
			IndRegua("SE5",cIndex,cChave,,"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",OemToAnsi(STR0012))  //"Selecionando Registros..."
		ELSE
			cChave	:= "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
			IndRegua("SE5",cIndex,cChave,,,OemToAnsi(STR0012))  //"Selecionando Registros..."
		ENDIF
		nIndex	 := RetIndex("SE5")
		dbSelectArea("SE5")
		dbSetIndex(cIndex+OrdBagExt())
		dbSetOrder(nIndex+1)
		IF mv_par12 == 1
			dbSeek(DtoS(mv_par01),.T.)
		ELSE
			dbSeek(xFilial()+DtoS(mv_par01),.T.)
		ENDIF
	#ENDIF
Elseif aReturn[8] == 2
	titulo += OemToAnsi(STR0013)  //" por Banco"
	SE5->(dbSetOrder(3))
	#IFDEF TOP
		cCondicao 	:= ".T."
		cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
		cIndice := SE5->(IndexKey())
		cOrde2 := cIndice
		IF mv_par12 == 1
		   cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1)) + "+E5_FILIAL"
		ENDIF
		cOrder := cIndice
	#ELSE
		cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
		cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
		IF mv_par12 == 1
		   cIndex	:= CriaTrab(nil,.f.)
		   cChave	:= SE5->(INDEXKEY())
			cChave   := ALLTRIM(SUBSTR(cChave, AT("+",cChave)+1)) + "+E5_FILIAL"
			IndRegua("SE5" ,cIndex,cChave,,"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",OemToAnsi(STR0012))  //"Selecionando Registros..."
			nIndex	 := RetIndex("SE5")
			SE5->(dbSetIndex(cIndex+OrdBagExt()))
		   SE5->(dbSetOrder(nIndex+1))
			SE5->(DBSEEK(mv_par03,.T. ))
		ELSE
			SE5->(dbSetOrder(3))
		   SE5->(dbSeek(xFilial("SE5")+mv_par03,.T.))
		ENDIF
	#ENDIF
Elseif aReturn[8] == 3
	titulo += OemToAnsi(STR0014)  //" por Natureza"
	SE5->(dbSetOrder(4))
	#IFDEF TOP
		cCondicao 	:= ".T."
		cCond2		:= "E5_NATUREZ"
		cIndice := SE5->(IndexKey())
		cOrde2 := cIndice
		IF mv_par12 == 1
		   cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1))+"+E5_FILIAL"
		ENDIF
		cOrder := cIndice
	#ELSE
		cCondicao := "E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06"
		cCond2	  := "E5_NATUREZ"
		IF mv_par12 == 1
            cIndex := CriaTrab(NIL,.F.)
			cChave := SE5->(INDEXKEY())
			cChave := ALLTRIM(SUBSTR(cChave,AT("+",cChave)+1))+"+E5_FILIAL"
			IndRegua("SE5"  ,cIndex ,cChave,,"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",OemToAnsi(STR0012))
			nIndex	 := RetIndex("SE5")
			SE5->(dbSetIndex(cIndex+OrdBagExt()))
		   SE5->(dbSetOrder(nIndex+1))
			SE5->(DBSEEK(mv_par05,.T.))
		ELSE
		   SE5->(dbSeek(xFilial("SE5")+mv_par05,.T.))
		ENDIF
	#ENDIF
Elseif aReturn[8] == 4 // Digitacao
   IF mv_par12 == 1
		cOrder	 := "DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
	ELSE
	   cOrder	 := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	ENDIF
	cCond2 := "E5_DTDIGIT"
	cOrde2 := cOrder
	#IFDEF TOP
		cCondicao 	:= ".T."
	#ELSE
		cCondicao := "E5_DTDIGIT >= mv_par07 .and. E5_DTDIGIT <= mv_par08"
		titulo += OemToAnsi(STR0015)  //"  Por Data de Digitacao"
		cIndex:=CriaTrab("",.F.)
		dbSelectArea("SE5")
		IF mv_par12 == 1
	 	   IndRegua("SE5",cIndex,cOrder,,"E5_FILIAL >= '" + mv_par13 + "' .AND. E5_FILIAL <= '" + mv_par14 + "'",OemToAnsi(STR0012))  //"Selecionando Registros..."
			nIndex	 := RetIndex("SE5")
			SE5->(dbSetIndex(cIndex+OrdBagExt()))
		   SE5->(dbSetOrder(nIndex+1))
			SE5->(dbSeek(DTOS(mv_par07),.T.))
		ELSE
		   IndRegua("SE5",cIndex,cOrder,,,OemToAnsi(STR0012))  //"Selecionando Registros..."
		   nIndex	 := RetIndex("SE5")
			SE5->(dbSetIndex(cIndex+OrdBagExt()))
		   SE5->(dbSetOrder(nIndex+1))
		   SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par07),.T.))
		ENDIF
	#ENDIF
ElseIf aReturn[8] >= 5 // Data da Movimentacao
	If mv_par12 == 1
		cOrder := "DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
	Else
		cOrder := "E5_FILIAL+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	Endif
	cCond2 := "E5_DATA"
	cOrde2 := cOrder
	#IFDEF TOP
		cCondicao 	:= ".T."
	#ELSE
		cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
		titulo    += OemToAnsi(STR0034) // "Por Dt. Movimentacao"
		cIndex    := CriaTrab("",.F.)
		dbSelectArea("SE5")
		If mv_par12 == 1
	 		IndRegua("SE5",cIndex,cOrder,,"E5_FILIAL >= '" + mv_par13 + "' .AND. E5_FILIAL <= '" + mv_par14 + "'",OemToAnsi(STR0012))  //"Selecionando Registros..."
			nIndex := RetIndex("SE5")
			SE5->(dbSetIndex(cIndex+OrdBagExt()))
			SE5->(dbSetOrder(nIndex+1))
			SE5->(dbSeek(DTOS(mv_par01),.T.))
		Else
			IndRegua("SE5",cIndex,cOrder,,,OemToAnsi(STR0012))  //"Selecionando Registros..."
			nIndex := RetIndex("SE5")
			SE5->(dbSetIndex(cIndex+OrdBagExt()))
			SE5->(dbSetOrder(nIndex+1))
			SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par01),.T.))
		Endif
	#ENDIF	
EndIF
cFilterUser:=aReturn[7]

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_NUMCHEQ <> '%*'"
		cQuery += " AND E5_VENCTO <= E5_DATA " 
		cQuery += " AND E5_DTDISPO BETWEEN '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02)       + "'"
		cQuery += " AND E5_BANCO BETWEEN   '" + mv_par03        + "' AND '" + mv_par04       + "'"
		cQuery += " AND E5_BANCO <> '   ' "
		//cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par05        + "' AND '" + mv_par06       + "'"
		cQuery += " AND E5_DTDIGIT BETWEEN '" + DTOS(mv_par07)        + "' AND '" + DTOS(mv_par08)       + "'"
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL') "
		If lF620Qry
			cQueryAdd := ExecBlock("F620QRY", .F., .F., {aReturn[7]})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND ( " + cQueryAdd + ")"
			EndIf
		EndIf
		cQuery += " ORDER BY " + SqlOrder(cOrder)

		cQuery := ChangeQuery(cQuery)

		dbSelectAre("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
	
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Endif
#ENDIF
fCopiaSe5()

Set Softseek Off
SetRegua(RecCount())

For nBancos := 1 To IIf(aReturn[8]==2,Len(aSaldo),1)

	nTotEnt:=0
	nTotSai:=0
	nTotSaldo := 0
	lImpSaldo := (lFirst .And. aReturn[8] != 3) // Indica se o saldo anterior deve ser impresso
	If aReturn[8] == 2
		nSaldoAtual := 0
	Endif
	nSaldoAnt := 0
	
	// Pesquisa o saldo bancario
	If mv_par15 == 1 .And. lImpSaldo
		nSaldoAnt := 0
		If aReturn[8] == 2 // Ordem de banco
			If (!Empty(aSaldo[nBancos][2]) .And. !Empty(aSaldo[nBancos][3]) .And. !Empty(aSaldo[nBancos][4]))
				cCond3:=aSaldo[nBancos][2]+aSaldo[nBancos][3]+aSaldo[nBancos][4]
			Else
				cCond3 := "EOF"
			EndIf
			nAscan := Ascan(aSaldo, {|e| e[2]+e[3]+e[4] == cCond3 } )
			If nAscan > 0 
				If ( cPaisLoc == "BRA" ) 
					nSaldoAnt := aSaldo[nAscan][6]
				Else
					nSaldoAnt := Round(xMoeda(aSaldo[nAscan][6],nMoedaBco,mv_par09,IIf(SE5->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
				Endif
			Else
				nSaldoAnd := 0
			Endif	
			lFirst := .T.
		Else
			// Na primeira vez, soma todos os saldos de todos os bancos
			If lFirst 
				// Soma os saldos de todos os bancos
				For nA := 1 To Len(aSaldo)
					If ( cPaisLoc <> "BRA" )
						nSaldoAnt += Round(xMoeda(aSaldo[nA][6],MoedaBco(aSaldo[nA][2],aSaldo[nA][3],aSaldo[nA][4]),mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
					Else
						nSaldoAnt += aSaldo[nA][6]
					Endif
				Next
				lFirst := .F.
			Else
				// Apos a impressao da primeira linha, o saldo Anterior sera igual ao
				// saldo atual, impresso na ultima linha, antes da quebra de data
				If ( cPaisLoc == "BRA" )
					nSaldoAnt := nSaldoAtual
				Else
					nSaldoAnt := Round(xMoeda(nSaldoAtual,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
				Endif
			Endif	
		Endif	
		If ( cPaisLoc == "BRA" )
			cPict := "@E 999,999,999.99"
		Else
			cPict := PesqPict( "SE5", "E5_VALOR", 18, mv_par09 )
		Endif
		
		IF li > 58
			cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
		Endif
			
		// Imprime o saldo anterior
		@li,000 PSAY STR0031 + DTOC(mv_par01)+ ; //"Saldo anterior a "
						 If( aReturn[8] == 2, " : " + aSaldo[nBancos][2]+" "+aSaldo[nBancos][3]+" "+aSaldo[nBancos][4],STR0032)+; //" (Todos os bancos): "
						 Transform(nSaldoAnt,cPict)
		li++
		li++
		nSaldoAtual := nSaldoAnt
	Endif

	
	While !Eof() .And. EVAL(bWhile) .And. &cCondicao .and. lContinua
	
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0016)  //"CANCELADO PELO OPERADOR"
			lContinua:=.F.
			Exit
		End
	
		#IFNDEF TOP
			If !Fr620Skip1()
				dbSkip()
				Loop
			EndIf	
		#ELSE
			If TcSrvType() == "AS/400"
				If !Fr620Skip1()
					dbSkip()
					Loop
				EndIf	
			EndIf
		#ENDIF		
	
		IncRegua()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSkip()
			Loop
		Endif

		IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
			dbSkip()
			Loop
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Na transferencia somente considera nestes numerarios 		 ³
		//³ No Fina100 ‚ tratado desta forma.                    		 ³
		//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
		//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
        //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
	    //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
	    //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
	      If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
				dbSkip()
				Loop
			Endif
		Endif
	
		If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
			.or. Substr(E5_DOCUMEN,1,1) == "*" )
			dbSkip()
			Loop
		Endif
	
		If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		//Sangria
			dbSkip()
			Loop
		Endif
	
		cAnterior:=&cCond2
		nTotEnt:=0
		nTotSai:=0
		nTotSaldo := 0
	
		If aReturn[8] == 2
			nSaldoAtual := 0
			cCond3:="E5_BANCO=='"+aSaldo[nBancos][2]+"' .And. E5_AGENCIA=='"+aSaldo[nBancos][3]+"' .And. E5_CONTA=='"+aSaldo[nBancos][4]+"'"
		Else
			cCond3:=".T."
		Endif	
	
		While !EOF() .and. &cCond2 = cAnterior .and. EVAL(bWhile) .and. lContinua .And. &cCond3
	
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0016)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIF
	
			IF Empty(E5_BANCO)
				dbSkip()
				Loop
			Endif
	
			IncRegua()
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
	
			IF E5_SITUACA == "C"
				dbSkip()
				Loop
			EndIF
	
			IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
				dbSkip()
				Loop
			EndIF
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Na transferencia somente considera nestes numerarios 	     ³
			//³ No Fina100 ‚ tratado desta forma.                    	     ³
			//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
			//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
     	    //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
	        //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
	        //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
	         If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
					dbSkip()
					Loop
				Endif
			Endif
	
			If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
				.or. Substr(E5_DOCUMEN,1,1) == "*" )
				dbSkip()
				Loop
			Endif
	
	
			If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		// Sangria
				dbSkip()
				Loop
			Endif
	
			IF E5_VENCTO > E5_DATA
				dbSkip()
				Loop
			EndIF
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta' FORA dos parametros                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF (E5_DTDISPO < mv_par01) .or. (E5_DTDISPO > mv_par02)
				dbSkip()
				Loop
			Endif
	
			IF (E5_BANCO < mv_par03) .or. (E5_BANCO  > mv_par04)
				dbSkip()
				Loop
			EndIf
	        
			IF (E5_NATUREZ < mv_par05) .or. (E5_NATUREZ > mv_par06)
				dbSkip()
				Loop
			Endif
	        
			IF (E5_DTDIGIT < mv_par07) .or. (E5_DTDIGIT > mv_par08)
				dbSkip()
				Loop
			EndIF
	
			IF E5_TIPODOC $ "DC/JR/MT/BA/MT/CM/D2/J2/M2/C2/V2/CX/CP/TL"
				dbSkip()
				Loop
			Endif
	
			//  Para o Sigaloja, quando for sangria e nao for R$, nÆo listar nos 
			// movimentos bancarios
	
			If (E5_TIPODOC == "SG") .And. (!E5_MOEDA $ "R$"+IIf(cPaisLoc=="BRA","","/$ ")) //Sangria com moeda <> R$
				dbSkip()
				Loop
			EndIf
	
			dbSelectArea("SE5")
	
			If SubStr(E5_NUMCHEQ,1,1)=="*"      //cheque para juntar (PA)
				dbSkip()
				Loop
			Endif
	
			If !Empty( E5_MOTBX )
				If !MovBcoBx(E5_MOTBX)
					dbSkip()
					Loop
				Endif
			Endif
	
			IF li > 58
				cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
			Endif
	
			If cPaisLoc	# "BRA"
				SA6->(DbSetOrder(1))
				SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
				nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    If SE5->(FieldPos('E5_TXMOEDA')) > 0
					nTxMoedBc := SE5->E5_TXMOEDA	
				Else  	
					nTxMoedBc := 0
				Endif
				If mv_par09 > 1 .and. !Empty(E5_VLMOED2)
					nTxMoeda := RecMoeda(E5_DTDISPO,mv_par09)
					nTxMoeda :=if(nTxMoeda=0,1,nTxMoeda)
					nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par09,,nCasas+1,nTxMoedBc,nTxMoeda),nCasas)
				Else
					nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
				Endif
			Else
				nValor := xMoeda(E5_VALOR,1,mv_par09,E5_DATA)
			Endif
	
			lVazio := .F.
			
			// Calcula saldo atual
			nSaldoAtual := If(E5_RECPAG = "R",nSaldoAtual+nValor,nSaldoAtual-nValor)
	
			If mv_par11 == 1
				@li,000 PSAY If( aReturn[8]!=5, E5_DTDISPO, E5_DATA )
				@li,011 PSAY E5_BANCO
				@li,015 PSAY E5_AGENCIA
				@li,024 PSAY E5_CONTA
				@li,035 PSAY E5_NATUREZ
				cDoc := E5_NUMCHEQ
				If Empty( cDoc )
					cDoc := E5_DOCUMEN
				Endif
	
				IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 14
					cDoc := Alltrim(E5_DOCUMEN) + if(!empty(E5_DOCUMEN).and. !empty(E5_NUMCHEQ),"-","") + Alltrim(E5_NUMCHEQ )
				Endif
	
				If Empty(cDoc)
					cDoc := Alltrim(E5_PREFIXO)+if(!empty(E5_PREFIXO),"-","")+;
							  Alltrim(E5_NUMERO )+if(!empty(E5_PARCELA),"-"+E5_PARCELA,"")
				Endif
	
				If Substr( cDoc,1,1 ) == "*"
					dbSkip()
					Loop
				Endif
				// ajusta otamanho do documento para nao desposicionar o relatorio
				cDoc := If(Len(cDoc)==0,Space(1),cDoc) 
				@li,47 PSAY cDoc
				nColuna := IIF(E5_RECPAG = "R" ,67, 85)
				
				@li,nColuna	PSAY nValor PicTure tm(nValor,16,MsDecimais(mv_par09))
				If aReturn[8] != 3 .And. mv_par15 == 1
					@li,102		PSAY nSaldoAtual PicTure tm(nSaldoAtual,18,MsDecimais(mv_par09))
				Endif	
			Endif
	
			IF E5_RECPAG = "R"
				nTotEnt += nValor
			Else
				nTotSai += nValor
			Endif
			nTotSaldo += nSaldoAtual
			If mv_par11 == 1
				nColuna := If(aReturn[8] != 3 .And. mv_par15 == 1, 122, 105)
				If mv_par10 == 1	// Imprime normalmente
					@li,nColuna PSAY SUBSTR(E5_HISTOR,1,25)
				Else					// Busca historico do titulo
					If E5_RECPAG == "R"
						cHistor		:= E5_HISTOR
						cChaveSe5	:= E5_FILIAL + E5_PREFIXO + ;
											E5_NUMERO + E5_PARCELA + ;
											E5_TIPO
						dbSelectArea("SE1")
						dbSeek( cChaveSe5 )
						@li,nColuna PSAY Left( iif( Empty(SE1->E1_HIST), cHistor, SE1->E1_HIST) , 25 )
					Else
						cHistor		:= E5_HISTOR
						cChaveSe5	:= E5_FILIAL + E5_PREFIXO + ;
											E5_NUMERO + E5_PARCELA + ;
											E5_TIPO	 + E5_CLIFOR
						dbSelectArea("SE2")
						dbSeek( cChaveSe5 )
						@li,nColuna PSAY Left( iif( Empty(SE2->E2_HIST), cHistor, SE2->E2_HIST) , 25 )
					Endif
				Endif
				li++
			Endif
			dbSelectArea("SE5")
			dbSkip()
		Enddo
	
		If ( nTotEnt + nTotSai ) != 0
			li++
			IF aReturn[8] == 1 .or. aReturn[8] == 4 .or. aReturn[8] == 5
				@li, 0 PSAY STR0033 + DTOC(cAnterior) //"Total : "
			Elseif aReturn[8] == 2
				// Banco+Agencia+Conta
				@li, 0 PSAY STR0033 + Substr(cAnterior,1,3)+" "+Substr(cAnterior,4,5)+" "+Substr(cAnterior,9,10) //"Total : "
			Elseif aReturn[8] == 3
				dbSelectArea("SED")
				dbSeek(cFilial+cAnterior)
				@li, 0 PSAY STR0033 + cAnterior + " "+Substr(ED_DESCRIC,1,30) //"Total : "
			EndIF
			If mv_par11 != 1 // Sintetico
				@li, 55 PSAY nTotEnt	  PicTure tm(nTotEnt,16,MsDecimais(mv_par09))
				@li, 73 PSAY nTotSai	  PicTure tm(nTotSai,16,MsDecimais(mv_par09))
			Else	
				@li, 67 PSAY nTotEnt	  PicTure tm(nTotEnt,16,MsDecimais(mv_par09))
				@li, 85 PSAY nTotSai	  PicTure tm(nTotSai,16,MsDecimais(mv_par09))
			Endif
			
			If aReturn[8] != 3 .And. mv_par15 == 1
				@li,If(mv_par11==1,102,89) PSAY nSaldoAtual PicTure tm(nTotSaldo,18,MsDecimais(mv_par09))
			Endif	
			nGerEnt += nTotEnt
			nGerSai += nTotSai
			nGerSaldo += (nSaldoAnt + nTotEnt - nTotSai)
			nSaldoAnt := 0			
			nTotSaldo := 0
			nTotEnt := 0
			nTotSai := 0
			li+=2
		Endif
		dbSelectArea("SE5")		
		If aReturn[8]==2
			Exit
		EndIf
	EndDo
Next

IF (nGerEnt+nGerSai) != 0
	IF li+2 > 58
		cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
	Endif
	li++
	@li,	0 PSAY OemToAnsi(STR0017)  //"Total Geral : "
	If mv_par11 != 1 // Sintetico
		@li, 55 PSAY nGerEnt 	PicTure tm(nGerEnt,16,MsDecimais(mv_par09))
		@li, 73 PSAY nGerSai 	PicTure tm(nGerSai,16,MsDecimais(mv_par09))
	Else
		@li, 67 PSAY nGerEnt 	PicTure tm(nGerEnt,16,MsDecimais(mv_par09))
		@li, 85 PSAY nGerSai 	PicTure tm(nGerSai,16,MsDecimais(mv_par09))
	Endif	
	If aReturn[8] != 3 .And. mv_par15 == 1
		@li,If(mv_par11==1,102,89) PSAY nGerSaldo PicTure tm(nTotSaldo,18,MsDecimais(mv_par09))
	Endif	
	li++
	roda(cbcont,cbtxt,cTamanho)
End

If lVazio
	IF li > 58
		cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
	End
	@li, 0 PSAY OemToAnsi(STR0018)  //"Nao existem lancamentos neste periodo"
	li++
	roda(cbcont,cbtxt,cTamanho)
End


Set Device To Screen

#IFDEF TOP
   If TcSrvType() != "AS/400"
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	Else
		dbSelectArea("SE5")
		dbClearFil()
		RetIndex( "SE5" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	Endif
#ELSE
	dbSelectArea("SE5")
	dbClearFil()
	RetIndex( "SE5" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ENDIF

If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
End
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr620Skip1³ Autor ³ Pilar S. Albaladejo	  ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR620.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr620Skip1()

Local lRet := .T.

If Empty(E5_BANCO)
	lRet := .F.
ElseIf E5_SITUACA == "C"
	lRet := .F.
ElseIf E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
	lRet := .F.
ElseIf E5_VENCTO > E5_DATA
	lRet := .F.
Endif

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetSaldos ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obter os saldos dos bancos do SA6                          º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ lConsFil    -> Considera filiais                           º±±
±±º          ³ nMoeda      -> Codigo da moeda                             º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[n] = .F.,Banco,Agencia,Conta,Nome,Saldo               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR140                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSaldos( lConsFil, nMoeda, cFilDe, cFilAte, dDataSaldo )
Local aRet     := {},;
		aArea    := GetArea(),;
		aAreaSa6 := Sa6->(GetArea()),;
		aAreaSe8 := Se8->(GetArea()),;
		cTrbBanco                   ,;
		cTrbAgencia                 ,;
		cTrbConta                   ,;
		cTrbNome                    ,;
		nTrbSaldo                   ,;
		cIndSE8  := ""					 ,;
		cSavFil  := cFilAnt			 ,;
		aAreaSm0 :=	SM0->(GetArea()),;
		nAscan

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lConsFil
   cFilDe  := cFilAnt
	cFilAte := cFilAnt
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	cFilAnt := SM0->M0_CODFIL

	DbSelectArea("SA6")
	MsSeek( xFilial("SA6") )
	
	While SA6->(!Eof()) .And. A6_FILIAL == xFilial("SA6")
		If SA6->A6_FLUXCAI $ "S "
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica banco a banco a disponibilidade imediata				  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE8")
			cTrbBanco  := SA6->A6_COD
			cTrbAgencia:= SA6->A6_AGENCIA
			cTrbConta  := SA6->A6_NUMCON
			cTrbNome   := SA6->A6_NREDUZ
			Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,0,nMoeda, xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),mv_par09)})
			// Pesquiso o saldo na data anterior a data solicitada
			If MsSeek(xFilial("SE8")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON), .T.)
				While !EOF() 										.And.;
						SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	;
						SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
						xFilial("SE8") == SE8->E8_FILIAL
						dbSkip()
				End
				DbSkip(-1)
				While !Bof() 										.And.;
						SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	;
						SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
						xFilial("SE8") == SE8->E8_FILIAL		.And.;
						SE8->E8_DTSALAT >= dDataSaldo
					dbSkip( -1 )
				End
			EndIf
			While !Eof()										.And.;
					SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) == ;
					SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
	            xFilial("SE8") == SE8->E8_FILIAL		.And.;
	            SE8->E8_DTSALAT < dDataSaldo
				nTrbSaldo := xMoeda(SE8->E8_SALATUA,1,nMoeda)
				// Pesquisa banco+agencia+conta, para nao exibir saldos duplicados.
				nAscan := Ascan(aRet, {|e| e[2]+e[3]+e[4] == cTrbBanco+cTrbAgencia+cTrbConta})
				If nAscan > 0
					aRet[nAscan][6] := aRet[nAscan][6] + nTrbSaldo
				Else
					Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,nTrbSaldo,nMoeda, xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),mv_par09)})
				Endif	
				DbSkip()
			EndDo
		Endif
		dbSelectArea("SA6")
		dbSkip()
	End
	If Empty(xFilial("SA6")) .And.;
		Empty(xFilial("SE8"))
		Exit
	Endif
	dbSelectArea("SM0")
	dbSkip()
EndDo

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

If ( !Empty(cIndSE8) )
	dbSelectArea("SE8")
	RetIndex("SE8")
	dbClearFilter()	
	Ferase(cIndSE8+OrdBagExt())
EndIf

Sa6->(RestArea(aAreaSa6))
Se8->(RestArea(aAreaSe8))
RestArea(aArea)

Return aRet

Static Function fCopiaSe5()
Local _aEstru, _cArqDbf, _nI,_cConteudo,_aEstr2, _cArqDb2, _cArqDb3, _cAestr3, nReg := 0, lExclui := .F.

	DbSelectArea("SE5")
	_aEstru  := SE5->(DbStruct())
	_aEstr2  := SE5->(DbStruct())
	_cArqDBF := CriaTrab(NIL,.f.)
	_cArqDB2 := CriaTrab(NIL,.f.)

	DbCreate(_cArqDbf,_aEstru)
	DbUseArea(.T.,,_cArqDbf,"TRB",.F.)
	
	DbCreate(_cArqDb2,_aEstr2)
	DbUseArea(.T.,,_cArqDb2,"TR2",.F.)

	DbSelectArea("SE5")
	SE5->(DbGoTop())
	While !SE5->(Eof())
		RecLock("TRB",.T.)
		For _nI:= 1 to Len(_aEstru)
			_cConteudo := SE5->(FieldGet(_nI))
			TRB->(FieldPut(_nI,_cConteudo))
		Next
		MsUnLock("TRB")
		SE5->(DbSkip())
	Enddo

	dbSelectAre("SE5")
	dbCloseArea()

	DbselectArea("TRB")
	dbCloseArea()
	
	DbUseArea(.T.,,_cArqDbf,"SE5",.F.)
	SE5->(DbGotop())

	SEF->(DbSetOrder(1))
	SE2->(DbSetOrder(1))
	While !SE5->(Eof())
	  
		If Empty(SE5->E5_NATUREZ) .and. !Empty(SE5->E5_NUMCHEQ)
			SEF->(DbSeek(xFilial("SEF")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))
			While !SEF->(Eof()) .and. SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ == SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM
				SE2->(DbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
				If SE2->(Found())

					RecLock("TR2",.T.)
					For _nI:= 1 to Len(_aEstr2)
						_cConteudo := SE5->(FieldGet(_nI))
						TR2->(FieldPut(_nI,_cConteudo))
					Next
					TR2->E5_VALOR := SE2->E2_VALLIQ
					TR2->E5_NATUREZ := SE2->E2_NATUREZ
					MsUnLock("TR2")

					RecLock("SE5",.F.)
					SE5->E5_NATUREZ := "*"
					MsUnLock("SE5")

				Endif
				SEF->(DbSkip())
			Enddo
			
		ENDIF			
		SE5->(DbSkip())
	Enddo

	DbSelectArea("SE5")
	SE5->(Dbgotop())
	While !SE5->(Eof())
		If ALLTRIM(SE5->E5_NATUREZ) == '*'
			RecLock("SE5",.F.)
			SE5->(DbDelete())
			MsUnLock("SE5")
		Endif
		SE5->(DbSkip())
	Enddo

	DbSelectArea("TR2")
	TR2->(DbGoTop())

	While !TR2->(Eof())
		RecLock("SE5",.T.)
		For _nI := 1 to Len(_aEstr2)
			_cConteudo := TR2->(FieldGet(_nI))
			SE5->(FieldPut(_nI,_cConteudo))
		Next
		MsUnLock("SE5")
		TR2->(DbSkip())
	Enddo
	DbselectArea("TR2")
	dbCloseArea()

	DbSelectArea("SE5")
	INDEX ON &cOrde2 to (_cArqDbf)
	SE5->(Dbgotop())

Return