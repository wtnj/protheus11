#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ BALIMP   ³ Autor ³ Paulo Augusto         ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Balancete Impositivo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Legislacao - Paraguai                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Paulo August³26/11/01³11646 ³inclusao do Saldo anterior nos totais da  ³±±
±±³            ³        ³      ³coluna de Somas e tratamento da impressao ³±±
±±³            ³        ³      ³dos saldo pelo tipo da conta              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Balimp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,WNREL,TAMANHO,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,ARETURN,CNOMEPRG,NLASTKEY,CBTXT,CDATE")
SetPrvt("CPERG,CBCONT,M_PAG,LPERIODO,CPERIODO1,CPERIODO2")
SetPrvt("nDebito,nCredito,nSaldo,LI,nTotDeb,nTotCred")
SetPrvt("NDEUDOR,NACREEDOR,NACTIVO,NPASIVO,NPERDIDA,NGANANCIA")
SetPrvt("NDIF,NACUSA,NSDEBE,NSHABER,NSDEUDOR,NSACREEDOR")
SetPrvt("NSACTIVO,NSPASIVO,NSPERDIDA,NSGANANCIA,_SALIAS,AREGS")
SetPrvt("I,J,cLin1,CLIN2,")
Private nPag:=0
Private nSalant:= 0    
cString 	:= "SI1"
wnRel   	:= "BALIMP"
Tamanho 	:= "G"
Titulo  	:= "BALANCETE IMPOSITIVO"
cDesc1  	:= "Este informe imprimira el balancete impositivo correspondiente  "
cDesc2  	:= "al mes especificado en la pantalla de parametros.  "
cDesc3		:= ""
aReturn 	:= { "Zebrado", 1,"Contabilidad", 2, 2, 1, "",1 } 
cNomePrg 	:= "BALIMP"
nLastKey 	:= 0
Cbtxt    := Space( 10 )
cDate    := DATE()
cPerg    := "BALIMP"
cbCont   	:= 0
m_pag    	:= 1
lperiodo := .t.
cperiodo1 	:= ""
cperiodo2 	:= ""
nDebito     := ""
nCredito    := ""
nSalant		:= 0
nSaldo     := 0
li        	:= 0
nTotDeb     := 0
nTotCred    := 0
ndeudor   := 0
nacreedor := 0
nactivo   := 0
npasivo   	:= 0
nperdida  := 0
nganancia := 0
ndif      := 0
nacusa    	:= 0
nsdebe  	:= 0
nshaber   	:= 0
nsdeudor  	:= 0
nsacreedor	:= 0
nsactivo  	:= 0
nspasivo  	:= 0
nsperdida 	:= 0
nsganancia	:= 0
lvez		:=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    // Data        De                                ³
//³ mv_par02    //             Ate                               ³
//³ mv_par03    // Grupo de Lucros                               ³
//³ mv_par04    // Grupo de Perdas                               ³
//³ mv_par05    // Nome rep. Legal                               ³
//³ mv_par06    // Nome do Contador                              ³
//³ mv_par07    // Identificacao do Contador                     ³
//³ mv_par08    // Numero do Formulario                          ³
//³ mv_par09    // Numero de Orde                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

VldPerg()
pergunte(cPerg,.F.)

wnRel:=SetPrint(cString,wnRel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey == 27
	Return(.T.)
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(.T.)
Endif

RptStatus({|| proceso() })

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VldPerg  ³ Autor ³ Paulo Augusto         ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BALIMP                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VldPerg()
Local cAlias:=Alias(),aPerg:={}
Local cPerg := "BALIMP"
Local nx := 0

dbSelectArea("SX1")

Aadd(aPerg,{"Data Inicial       ","Fecha Inicial       ","From Date          ?","D",8 ,"G","mv_ch1"," "," "," "," "," "," "})
Aadd(aPerg,{"Data Final         ","Fecha Fim           ","To Date            ?","D",8 ,"G","mv_ch2"," "," "," "," "," "," "})
Aadd(aPerg,{"Grupo Lucros      ?","Grupo Ganancia     ?","Grup Lucros        ?","C",1 ,"G","mv_ch3"," "," "," "," "," "," "})
Aadd(aPerg,{"Grupo Prejuizo    ?","Grupo Perdidas     ?","Grup Prejuizo      ?","C",1 ,"G","mv_ch4"," "," "," "," "," "," "})
Aadd(aPerg,{"Nome Rep. Legal   ?","Nombre Res. Legal  ?","Nome Res. Legal    ?","C",30,"G","mv_ch5"," "," "," "," "," "," "})
Aadd(aPerg,{"Nome Contador     ?","Nombre Contador    ?","Nome Contador      ?","C",30,"G","mv_ch6"," "," "," "," "," "," "})
Aadd(aPerg,{"Ident.do Contador ?","Ident.del Contador ?","Nome Res. Legal    ?","C",12,"G","mv_ch7"," "," "," "," "," "," "})
Aadd(aPerg,{"Formulario Numero ?","Formulario Numero  ?","Nome Res. Legal    ?","C",12,"G","mv_ch8"," "," "," "," "," "," "})
Aadd(aPerg,{"Numero da Ordem   ?","Numero Ordem       ?","Orden of Number    ?","C",12,"G","mv_ch9"," "," "," "," "," "," "})



For nx:=1 To Len(aPerg)

	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO   	with cPerg
		Replace X1_ORDEM   	with StrZero(nx,2)
		Replace X1_PERGUNT 	with aPerg[nx][1]
		Replace X1_PERSPA  	with aPerg[nx][2]
		Replace X1_PERENG  	with aPerg[nx][3]
		Replace X1_TIPO	 	with aPerg[nx][4]
		Replace X1_TAMANHO 	with aPerg[nx][5]
		Replace X1_GSC	   	with aPerg[nx][6]
		Replace X1_VARIAVL 	with aPerg[nx][7]
		Replace X1_DEF01  	with aPerg[nx][8]
		Replace X1_DEF02 		with aPerg[nx][9]
		Replace X1_DEFSPA1 	with aPerg[nx][10]
		Replace X1_DEFSPA2 	with aPerg[nx][11]
		Replace X1_DEFENG1 	with aPerg[nx][12]
		Replace X1_DEFENG2 	with aPerg[nx][13]
		Replace X1_VAR01   	with "mv_par"+StrZero(nx,2)
		MsUnlock()
	EndIf
Next nx
dbSelectArea(cAlias)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Proceso  ³ Autor ³Paulo Augusto          ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Proceso principal del balance                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BALIMP                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function proceso()


If ! DataMoeda(1,@cperiodo1, mv_par01)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF	
	Help(" ",1,"MESINVALID")
	Return
End
If ! DataMoeda(1, @cperiodo2, mv_par02)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF	
	Help(" ",1,"MESINVALID")
	Return
End		


datamoeda(1,@cperiodo1,mv_par01)
datamoeda(1,@cperiodo2,mv_par02)

cperiodo1 := val(alltrim(cperiodo1))
cperiodo2 := val(alltrim(cperiodo2))

dbSelectArea("SI1")

If Type("SI1->I1_INF8COL") == "U"
	MsgAlert("Campo SI1->I1_INF8COL nao existe")
	Return
EndIf


DbSetOrder(1)
DbGoTop()

SetRegua(RecCount())

doccabec()

/*      1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cuenta                                            Debito               Credito                Deudor              Acreedor                Activo                Pasivo              Perdidas             Ganancias
xxxxxxxxxxxxxxxxxxxxxxxxx                99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999*/

while !SI1->(EOF())
	nDebito  := 0
	nCredito := 0
	nSalant:= 0
	nSaldo := 0
	If si1->i1_inf8col == "G" .and. nacusa == 1
		corte()
		If li >= 54
			doccabec()
		endif
	endif

	If (si1 -> i1_inf8col == "S" .or. si1 -> i1_inf8col == "G")

		@ li,001 Psay si1 -> i1_desc

		If i1_inf8col == "G"
			li := li + 1
			@ li,000 Psay "-------------------------"
		Endif

		nDebito  := totdebitos(1,cperiodo1-1)  // calcula total dos movimentos a debito
		nCredito := totcreditos(1,cperiodo1-1)  // calcula total dos movimentos a credito
		If SI1->I1_NORMAL=="D"
        	nSalant:=(I1_SALANT *-1)+ nDebito-nCredito
		Else
			nSalant:=I1_SALANT+nCredito-nDebito
		EndIf
        nDebito	:=0
        nCredito	:=0
        nDebito  := totdebitos(cperiodo1,cperiodo2)  // calcula total dos movimentos a debito
		nCredito := totcreditos(cperiodo1,cperiodo2)  // calcula total dos movimentos a credito

		If SI1->I1_NORMAL=="D" .and. nSalant >= 0  .or. SI1->I1_NORMAL=="C" .and. nSalant < 0
 			nDebito  := nDebito + Abs(nSalant)
		elseif  SI1->I1_NORMAL=="D" .and. nSalant < 0 .or. SI1->I1_NORMAL=="C" .and. nSalant >= 0
			nCredito := nCredito + Abs(nSalant)
		Endif	
		If SI1->I1_NORMAL=="D"
			nSaldo :=  nDebito - nCredito 
		else
			nSaldo :=   nCredito - nDebito  
		EndIf
		if si1 -> i1_inf8col == "S"
			@ li,042 Psay Abs(nDebito)                  picture "@e 999,999,999,999"
			@ li,064 Psay Abs(nCredito)                 picture "@e 999,999,999,999"
			nTotDeb := nDebito  + nTotDeb
			nTotCred:= nCredito + nTotCred
			nsdebe := nDebito  + nsdebe
			nshaber:= nCredito + nshaber

			if nSaldo > 0  .and. SI1->I1_NORMAL == "D" .or. nSaldo < 0  .and.  SI1->I1_NORMAL == "C"
				@ li,086 Psay Abs(nSaldo)                 picture "@e 999,999,999,999"  
				ndeudor := ndeudor + Abs(nSaldo)
				nsdeudor := nsdeudor + Abs(nsaldo)
			endif

			if nsaldo < 0 .and.  SI1->I1_NORMAL == "D" .or. nsaldo > 0  .and.  SI1->I1_NORMAL == "C"
				@ li,108 Psay abs(nsaldo )         picture "@e 999,999,999,999"
				nacreedor := nacreedor + abs(nsaldo)
				nsacreedor := nsacreedor + abs(nsaldo)
			endif
			if ((substr(si1->i1_codigo,1,1)!=mv_par03) .and. (substr(si1->i1_codigo,1,1)!=mv_par04))

				if  nsaldo > 0  .and. SI1->I1_NORMAL == "D" .or. nsaldo < 0  .and.  SI1->I1_NORMAL == "C"
					@ li,130 Psay Abs(nsaldo)         picture "@e 999,999,999,999"
					nactivo := nactivo + Abs(nsaldo)
					nsactivo := nsactivo + Abs(nsaldo)
				endif

				if nsaldo < 0 .and.  SI1->I1_NORMAL == "D" .or. nsaldo > 0  .and.  SI1->I1_NORMAL == "C"
					@ li,152 Psay abs(nsaldo)          picture "@e 999,999,999,999"
					npasivo := npasivo + Abs(nsaldo)
					nspasivo := nspasivo + Abs(nsaldo)
				endif
			else
				if  nsaldo > 0  .and. SI1->I1_NORMAL == "D" .or. nsaldo < 0  .and.  SI1->I1_NORMAL == "C"
					@ li,174 Psay Abs(nsaldo)                 picture "@e 999,999,999,999"
					nperdida := nperdida + Abs(nsaldo)
					nsperdida := nsperdida + Abs(nsaldo)
				endif
				if nsaldo < 0 .and.  SI1->I1_NORMAL == "D" .or. nsaldo > 0  .and.  SI1->I1_NORMAL == "C"
					@ li,196 Psay Abs(nsaldo)          picture "@e 999,999,999,999"
					nganancia := nganancia + Abs(nsaldo)
					nsganancia := nsganancia + Abs(nsaldo)
				endif
			endif
		endif
		nacusa := 1
		li := li + 1
	endif

	if li >= 54
		doccabec()
	endif
	dbskip()

	incregua()
End
corte()
@ li,000 Psay "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
li := li + 1
@ li,000 Psay "TOTALES"
doctotal()
@ li,000 Psay "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
docres()
li := li +1
@ li,000 Psay "============================================================================================================================================================================================================================"
li := li +1
@ li,000 Psay "Sumas Iguales"
doctotal()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apresenta relatorio na tela                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnRel)
endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DOCCABEC ³ Autor ³ Paulo Augusto         ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime cabeçalho do Balancete                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BALIMP                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DocCabec()

/*
1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Movimiento                                   nsaldos                                     Inventario                                Resultados
Cuenta                                            Debito               Credito                Deudor              Acreedor                Activo                Pasivo              Perdidas             Ganancias
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
xxxxxxxxxxxxxxxxxxxxxxxxx                99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999

*/
clind  	:= "1-IDENTIFICACION DEL CONTIBUYENTE                                                                                                                            2- PERIODO FISCAL "
clind1 := "|_______________________________________________________________________|___________________________________________________________________________________|_________________|_____________"
clind2 	:= "|           RAZON SOCIAL O APELLIDOS                                    |              NOMBRES                              |     IDENTIFICADOR RUC         |    DESDE        |   HASTA     |"
clind3 :=  sm0->m0_nome +space(57) +sm0->m0_nomecom+space(17) + sm0->m0_cgc+ SPACE(14) + DTOC(MV_PAR01) + SPACE (8) +DTOC(MV_PAR02)
clind4 	:= "3-IDENTIFICACION DEL REPRESENTANTE LEGAL                                  4-IDENTIFICACION DEL CONTADOR                                                      5- DECLARACION JURADA UTILIZADA"
clind5 	:= "|          APELLIDOS / NOMBRES                                           |      APELLIDOS / NOMBRES                         |     IDENTIFICADOR RUC         |      FORMULARIO No.       |        No. ORDEN        |"
clind6 := "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
clin1 := "                                                            Sumas                                        SALDOS                                     Inventario                                Resultados"
clin2 	:= "Cuenta                                            Debito               Credito                Deudor              Acreedor                Activo                Pasivo              Perdidas             Ganancias"


If nPag>0

	@ li,000 Psay "T R A N S P O R T E "
	doctotal()
EndIf

li:=cabec(titulo,"BALANCETE IMPOSITIVO",SPACE(1),wnrel,tamanho) 
li := li + 2	
@li,01 Psay clind
li := li + 1
@li,01 Psay clind6
li:=li+1
@li,01 Psay clind2
li:=li+1
@li,04 Psay clind3
li:=li+1
@li,01 Psay clind6
li:=li+2
@li,01 Psay clind4
li:=li+1
@li,01 Psay clind6
li:=li+1
@li,01 Psay clind5
li:=li+1	
@li,09  Psay MV_PAR05
@li,80 Psay MV_PAR06
@li,130 Psay MV_PAR07
@li,166 Psay MV_PAR08
@li,196 Psay MV_PAR09
li:=li+1	
@li,01 Psay clind6
li:=li+2
@li,01 Psay clind6
li:=li+1
@li,01 Psay clin1
li:=li+1
@li,01 Psay clin2
li:=li+1
@li,01 Psay clind6
li:=li+1

// Imprime transporte para outra pagina qdo diferente da primeira

If nPag>0
	@ li,001 Psay "T R A N S P O R T E "
	doctotal()
EndIf

nPag:= nPag+1

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DOCTOTAL ³ Autor ³ Paulo Augusto         ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os Totais                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BALIMP                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function doctotal()

/*      1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cuenta                                            Debito               Credito                Deudor              Acreedor                Activo                Pasivo              Perdidas             Ganancias
xxxxxxxxxxxxxxxxxxxxxxxxx               999,999,999,9999      999,999,999,9999      999,999,999,9999      999,999,999,9999      999,999,999,9999      999,999,999,9999      999,999,999,9999      999,999,999,9999
*/

@ li,041 Psay Abs(nTotDeb)        picture "@e 99,999,999,999,999"
@ li,063 Psay Abs(nTotCred)       picture "@e 99,999,999,999,999"
@ li,085 Psay Abs(ndeudor)      picture "@e 99,999,999,999,999"
@ li,107 Psay Abs(nacreedor)    picture "@e 99,999,999,999,999"
@ li,129 Psay Abs(nactivo)      picture "@e 99,999,999,999,999"
@ li,151 Psay Abs(npasivo) 		Picture "@e 99,999,999,999,999"
@ li,173 Psay Abs(nperdida)     picture "@e 99,999,999,999,999"
@ li,195 Psay Abs(nganancia)    picture "@e 99,999,999,999,999"
li := li + 1

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DOCRES   ³ Autor ³ Paulo Augusto         ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Total do Exercicio                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BALIMP                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function docres()

li := li + 1
@ li,001 Psay "Resultados Ejercicio"

ndif := nTotDeb - nTotCred

if ndif < 0
	@ li,041 Psay Abs(ndif)       picture "@e 99,999,999,999,999"
	nTotDeb := nTotDeb + Abs(ndif)
else
	@ li,063 Psay ndif              picture "@e 99,999,999,999,999"
	nTotCred := nTotCred + ndif
endif

ndif := ndeudor - nacreedor
if ndif < 0
	@ li,085 Psay Abs(ndif)       picture "@e 99,999,999,999,999"
	ndeudor := ndeudor + Abs(ndif)
else
	@ li,107 Psay ndif              picture "@e 99,999,999,999,999"
	nacreedor := nacreedor + ndif
endif

ndif := nactivo - npasivo
if ndif < 0
	@ li,129 Psay Abs(ndif)    	picture "@e 99,999,999,999,999"
	nactivo := nactivo + Abs(ndif)
else
	@ li,151 Psay ndif         	picture "@e 99,999,999,999,999"
	npasivo := npasivo + ndif
endif

ndif := nperdida - nganancia
if ndif < 0
	@ li,173 Psay Abs(ndif)       picture "@e 99,999,999,999,999"
	nperdida := nperdida + Abs(ndif)
else
	@ li,195 Psay ndif              picture "@e 99,999,999,999,999"
	nganancia := nganancia + ndif
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Corte    ³ Autor ³ Paulo Augusto         ³ Data ³ 31/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BALIMP                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function corte()

/*      1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TOTAL           99,999,999,999        99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999       99,999,999,9999*/
@ li,026 Psay "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
li := li + 1
@ li,026 Psay "TOTAL"
@ li,042 Psay Abs(nsdebe)        	Picture "@e 99,999,999,999,999"
@ li,064 Psay Abs(nshaber)       	Picture "@e 99,999,999,999,999"
@ li,086 Psay Abs(nsdeudor)      	Picture "@e 99,999,999,999,999"
@ li,108 Psay Abs(nsacreedor)    	Picture "@e 99,999,999,999,999"
@ li,130 Psay Abs(nsactivo)      	Picture "@e 99,999,999,999,999"
@ li,152 Psay Abs(nspasivo)      	Picture "@e 99,999,999,999,999"

if (nsperdida > 0 .or. nsganancia > 0)
	@ li,174 Psay Abs(nsperdida)	Picture "@e 99,999,999,999,999"
	@ li,196 Psay Abs(nsganancia) 	Picture "@e 99,999,999,999,999"
endif
li := li + 1
nsdebe    := 0
nshaber   := 0
nsdeudor  := 0
nsacreedor:= 0
nsactivo  := 0
nspasivo  := 0
nsperdida := 0
nsganancia:= 0

Return
