#INCLUDE "rwmake.ch"
#INCLUDE "QNCACAO.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QNCACAO  ³ Autor ³ Aldo Marini Junior    ³ Data ³ 06.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Acoes Corretivas			                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QNCACAO(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function QNCACAO()

Local ni,nj

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,")
SetPrvt("TITULO,CCABEC,AT_PROG,WCABEC0,WCABEC1,WCABEC2,WCABEC3,CONTFL,LI,NTAMANHO,")
SetPrvt("NORDEM,WNREL,CALIAS,NOLDORDER,AREGISTROS,NJ,NI,CTXTDET,NET")
SetPrvt("CFILDE,CFILATE,CANODE,CANOATE,CACAODE,CACAOATE,CREVDE,CREVATE,NETAPA,NACAO,CSTATUS,NRELAC,")
SetPrvt("ATIPQI3,ASTATUS,NCOLT,NLINDET,CTXTDET,CINICIO,CFIM,NT,")

cAlias		:= Alias()
nJ				:= 0
nI				:= 0
nOldOrder	:= 0
aRegistros	:= {}
cPerg			:= "QNRACA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o SX1 caso nao exista os registros correspondentes              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegistros,{cPerg,"01","Filial De          ?"," "," ","mv_ch1","C", 2,0,0,"G"," "      ,"mv_par01"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," ","SM0"," "})
AADD(aRegistros,{cPerg,"02","Filial Ate         ?"," "," ","mv_ch2","C", 2,0,0,"G"," "      ,"mv_par02"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," ","SM0"," "})
AADD(aRegistros,{cPerg,"03","Ano De             ?"," "," ","mv_ch3","C", 4,0,0,"G"," "      ,"mv_par03"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"04","Ano Ate            ?"," "," ","mv_ch4","C", 4,0,0,"G"," "      ,"mv_par04"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"05","Acao Corretiva De  ?"," "," ","mv_ch5","C",10,0,0,"G"," "      ,"mv_par05"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," ","QI3"," "})
AADD(aRegistros,{cPerg,"06","Acao Corretiva Ate ?"," "," ","mv_ch6","C",10,0,0,"G"," "      ,"mv_par06"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," ","QI3"," "})
AADD(aRegistros,{cPerg,"07","Revisao De         ?"," "," ","mv_ch7","C", 2,0,0,"G"," "      ,"mv_par07","Sim"       ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"08","Revisao Ate        ?"," "," ","mv_ch8","C", 2,0,0,"G"," "      ,"mv_par08","Sim"       ," "," "," "," ","Nao"        ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"09","Etapas da Acoes    ?"," "," ","mv_ch9","N", 1,0,3,"C"," "      ,"mv_par09","Pendentes" ," "," "," "," ","Baixadas"   ," "," "," "," ","Ambas"      ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"10","Acoes              ?"," "," ","mv_cha","N", 1,0,4,"C"," "      ,"mv_par10","Corretivas"," "," "," "," ","Preventivas"," "," "," "," ","Melhoria"   ," "," "," "," ","Ambas"," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"11","Status da Acoes    ?"," "," ","mv_chb","C", 5,0,0,"G","fStatus","mv_par11"," "         ," "," "," "," "," "          ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})
AADD(aRegistros,{cPerg,"12","FNC Relacionadas   ?"," "," ","mv_chc","N", 1,0,1,"C"," "      ,"mv_par12","Sim"       ," "," "," "," ","Nao"        ," "," "," "," "," "          ," "," "," "," "," "    ," "," "," "," "," "," "," "," "," "  ," "})

nOldOrder := SX1->(IndexOrd())
SX1->(dbSetOrder(1))

If SX1->(!dbSeek(aRegistros[1,1]+aRegistros[1,2]))
	For nI:=1 to Len(aRegistros)
		If SX1->(!dbSeek(aRegistros[nI,1]+aRegistros[nI,2]))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Assume que 5 - X1_TIPO, 9 - X1_GSC, 13 - X1_CNT01            ³
			//³ Atribui o valor de dDataBase para vari veis tipo data sem    ³
			//³  valor espec¡fico
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aRegistros[nI,5] == "D" .And. aRegistros[nI,9] == "G";
												 .And. Empty(aRegistros[nI,13])
				aRegistros[nI,13] := "'" + DtoC(dDataBase) + "'"
			EndIf
			RecLock("SX1",.T.)
			For nJ:=1 to SX1->(FCount())
				SX1->(FieldPut(nJ,aRegistros[nI,nJ]))
			Next
			MsUnlock()
		EndIf
	Next nI
Endif

SX1->(dbSetOrder(nOldOrder))
dbSelectArea(cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Basicas)                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesc1 	:= STR0001		//"Relatorio de Acoes Corretivas."
cDesc2 	:= STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo usuario."
cDesc3	:= ""
cString	:= "QI3"       				// alias do arquivo principal (Base)
aOrd		:= {STR0003,STR0004}		//"Ano+Acao Corretiva+Revisao"###"Acao Corretiva+Revisao"
aReturn  := { STR0005, 1,STR0006, 2, 2, 1,"",1 }	//"Zebrado"###"Administra‡„o"
nomeprog := "QNCACA0"
aLinha   := {}
nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo	:= STR0007		//"ACOES CORRETIVAS"
cCabec	:= ""
AT_PRG	:= "QNCACAO"
wCabec0	:= 3
wCabec1	:= ""
wCabec2	:= Padr("| ",131)+"|"
wCabec3	:= ""
CONTFL	:= 1
LI			:= 0
nTamanho	:= "M"

nOrdem := 1
INCLUI := .F.	// Utilizado devido algumas funcoes de retorno de descricao/nome

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("QNRACA",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Ano De 				                       ³
//³ mv_par04        //  Ano Ate             			              ³
//³ mv_par05        //  Acao Corretiva De                        ³
//³ mv_par06        //  Acao Corretiva Ate                       ³
//³ mv_par07        //  Revisao De                               ³
//³ mv_par08        //  Revisao Ate                              ³
//³ mv_par09        //  Etapas 1-Pendentes/2-Baixadas/3-Ambas    ³
//³ mv_par10        //  Acoes 1-Corretiva/2-Preventiva/3-Melhoria³
//³                     4-Ambas                                  ³
//³ mv_par11        //  Status Acoes 1-Registrada/2-Em Analise   ³
//³                   3-Procede/4-Nao Procede/5-Cancelada/6-Ambas³
//³ mv_par12        //  FNC Relacionadas 1-Sim/2-Nao			     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="QNCACAO"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]
cFilDe   := mv_par01
cFilAte  := mv_par02
cAnoDe   := mv_par03
cAnoAte  := mv_par04
cAcaoDe  := mv_par05
cAcaoAte := mv_par06
cRevDe   := mv_par07
cRevAte  := mv_par08
nEtapa   := mv_par09
nAcao    := mv_par10
cStatus  := mv_par11
nRelac   := mv_par12

If	nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If	nLastKey == 27
	Return
Endif

RptStatus({|lEnd| QNCRACAImp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QNCRACAImp³ Autor ³ Aldo Marini Junior    ³ Data ³ 06.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acoes Corretivas  			                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³QNCRACAImp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QNCACAO                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function QNCRACAImp(lEnd,WnRel,cString)
Local nt,net

aTipQI3 := {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010)}	// "Corretiva" ### "Preventiva" ### "Melhoria"
aStatus := {OemtoAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014),OemToAnsi(STR0015)}	// "Registrada" ### "Em Analise" ### "Procede" ### "Nao Procede" ### "Cancelada"
nColT   := 0
nLinDet := 0
cTxtDet := ""

dbSelectArea( "QI3" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 1 )
	dbSeek(IF(Empty(xFilial("QI3")),xFilial("QI3"),cFilDe) + cAnoDe + cAcaoDe + cRevDe,.T.)
	cInicio  := "QI3->QI3_FILIAL + QI3->QI3_ANO + QI3->QI3_CODIGO + QI3->QI3_REV"
	cFim     := IF(Empty(xFilial("QI3")),xFilial("QI3"),cFilAte) + cAnoAte + cAcaoAte + cRevAte
ElseIf nOrdem == 2
	dbSetOrder( 2 )
	dbSeek(IF(Empty(xFilial("QI3")),xFilial("QI3"),cFilDe) + cAcaoDe + cRevDe,.T.)
	cInicio  := "QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV"
	cFim     := IF(Empty(xFilial("QI3")),xFilial("QI3"),cFilAte) + cAcaoAte + cRevAte
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua de Processamento                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(QI3->(RecCount()))

While !EOF() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	(QI3->QI3_ANO < cAnoDe ) .Or. ( QI3->QI3_ANO > cAnoAte ) .Or. ;
	 	(Left(QI3->QI3_CODIGO,6) < Left(cAcaoDe,6) ) .Or. ( Left(QI3->QI3_CODIGO,6) > Left(cAcaoAte,6) ) .Or. ;
		(QI3->QI3_REV < cRevDe ) .Or. ( QI3->QI3_REV > cRevAte ) 
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Consiste o tipo de Acao Corretiva                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nAcao <> 4 .And. Val(QI3->QI3_TIPO) <> nAcao
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Consiste o Status das Acoes Corretivas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(QI3->QI3_STATUS $ cStatus)
		dbSkip()
		Loop
	Endif

	WCabec1	:= Padr("| "+OemToAnsi(STR0016)+TransForm(QI3->QI3_CODIGO,"@R 999999/9999")+"  "+;			// "No. "
				OemToAnsi(STR0017)+QI3->QI3_REV+"   "+OemToAnsi(STR0018)+PADR(DTOC(QI3->QI3_ABERTU),10)+;		// "Revisao: " ### "Data Abertura: "
				"   "+OemToAnsi(STR0019)+PADR(DTOC(QI3->QI3_ENCREA),10)+"   "+OemToAnsi(STR0020)+;	// "Data Encerramento: " ### "Acao "
				Padr(aTipQI3[Val(QI3->QI3_TIPO)],10),131)+"|"
				
	WCabec3	:= Padr("| "+OemToAnsi(STR0021)+QA_NUSR(QI3->QI3_FILMAT,QI3->QI3_MAT,.F.)+SPACE(34)+OemToAnsi(STR0022)+aStatus[Val(QI3->QI3_STATUS)],131)+"|"	// "Responsavel: " ### "Status: "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao Detalhada                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTxtDet  := StrTran(AllTrim(MSMM(QI3->QI3_PROBLE)),chr(13)+chr(10)," ")
	If !Empty(cTxtDet)
		nLinDet  := Int(Len(cTxtDet)/128)
		If Int(Len(cTxtDet)/128) <> Len(cTxtDet)/100
			nLinDet++
		Endif
		If nLinDet > 0
			QImpr("|-"+OemToAnsi(STR0023)+Replicate("-",110)+"|","C")		// "Descricao Detalhada"
			QImpr("|"+Space(130)+"|","C")
			nColT := 1
			For nT:=1 to nLinDet
				If nT > 1
					nColT+=128
				Endif
				QImpr("| "+Padr(SubStr(cTxtDet,nColT,128),128)+" |","C")
			Next
	    Endif
	Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao Resumida das Possiveis Causas            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QI6->(dbSeek( QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV ))
		QImpr("|"+Space(130)+"|","C")
		QImpr("|-"+OemToAnsi(STR0024)+Replicate("-",113)+"|","C")				// "Possiveis Causas"
		QImpr("|"+Space(130)+"|","C")
		While !Eof() .And. QI6->QI6_FILIAL + QI6->QI6_CODIGO + QI6->QI6_REV == QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV
			QImpr(PADR("| "+QI6->QI6_SEQ+" "+FQNCNTAB("1",QI6->QI6_CAUSA),131)+"|","C")	
			QI6->(dbSkip())
		Enddo
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime as Etapas das Acoes                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nContEta := 0
	IF QI5->(dbSeek( QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV ))
		QImpr("|"+Space(130)+"|","C")
		QImpr("|-"+OemToAnsi(STR0025)+Replicate("-",124)+"|","C")				// "Acoes"
		While !Eof() .And. QI5->QI5_FILIAL + QI5->QI5_CODIGO + QI5->QI5_REV == QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV
			If nContEta > 0
				QImpr("|"+Replicate("-",130)+"|","C")
			Endif
			QImpr(Padr("| "+QI5->QI5_TPACAO+"-"+FQNCDSX5("QD",QI5->QI5_TPACAO),131)+"|","C")
			cTxtDet := StrTran(AllTrim(MSMM(QI5->QI5_DESCCO)),chr(13)+chr(10)," ")
			nLinDet := 0
			If !Empty(cTxtDet)
				nLinDet  := Int(Len(cTxtDet)/128)
				If Int(Len(cTxtDet)/128) <> Len(cTxtDet)/100
					nLinDet++
				Endif
				If nLinDet > 0
					nColT := 1
					For nT:=1 to nLinDet
						If nT > 1
							nColT+=128
						Endif
						QImpr("| "+Padr(SubStr(cTxtDet,nColT,128),128)+" |","C")
					Next
			   Endif
			Endif
			If nLinDet < 4
				For nT:=1 to (4-nLinDet)
					QImpr("| "+Replicate(".",128)+" |","C")
				Next
			Endif
			nContEta := nContEta + 1
			QI5->(dbSkip())
		Enddo
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime as Etapas em branco para serem preenchidas           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nContEta < 5	//-- Sim
		For nEt := nContEta to 5
			QImpr("|"+Replicate("-",130)+"|","C")
			QImpr("|"+Space(130)+"|","C")
			For nT := 1 to 4
				QImpr("| "+Replicate(".",128)+" |","C")
			Next
			QImpr("|"+Space(130)+"|","C")
		Next
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao do Resultado Esperado                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTxtDet  := StrTran(AllTrim(MSMM(QI3->QI3_RESESP)),chr(13)+chr(10)," ")
	If !Empty(cTxtDet)
		nLinDet  := Int(Len(cTxtDet)/128)
		If Int(Len(cTxtDet)/128) <> Len(cTxtDet)/100
			nLinDet++
		Endif
		If nLinDet > 0
			QImpr("|"+Space(130)+"|","C")
			QImpr("|-"+OemToAnsi(STR0027)+Replicate("-",111)+"|","C")		// "Resultado Esperado"
			QImpr("|"+Space(130)+"|","C")
			nColT := 1
			For nT:=1 to nLinDet
				If nT > 1
					nColT+=128
				Endif
				QImpr("| "+Padr(SubStr(cTxtDet,nColT,128),128)+" |","C")
			Next
	    Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime a Descricao do Resultado Atingido                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTxtDet  := StrTran(AllTrim(MSMM(QI3->QI3_RESATI)),chr(13)+chr(10)," ")
	If !Empty(cTxtDet)
		nLinDet  := Int(Len(cTxtDet)/128)
		If Int(Len(cTxtDet)/128) <> Len(cTxtDet)/100
			nLinDet++
		Endif
		If nLinDet > 0
			QImpr("|"+Space(130)+"|","C")
			QImpr("|-"+OemToAnsi(STR0028)+Replicate("-",111)+"|","C")		// "Resultado Atingido"
			QImpr("|"+Space(130)+"|","C")
			nColT := 1
			For nT:=1 to nLinDet
				If nT > 1
					nColT+=128
				Endif
				QImpr("| "+Padr(SubStr(cTxtDet,nColT,128),128)+" |","C")
			Next
	    Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Imprime as Fichas de Nao Conformidades Relacionadas          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nRelac == 1	// Sim
		If QI9->(dbSeek(QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV))
			QImpr("|"+Space(130)+"|","C")
			QImpr("|-"+OemToAnsi(STR0029)+Replicate("-",93)+"|","C")		// "Ficha Nao Conformidades Relacionadas"	
			QImpr(Padr("| "+OemToAnsi(STR0030),131)+"|","C")				// "No.FNC.     Rv Originador                     Abertura   Descricao"
			QImpr("|"+Space(130)+"|","C")
			While !Eof() .And. QI9->QI9_FILIAL + QI9->QI9_CODIGO + QI9->QI9_REV == QI3->QI3_FILIAL + QI3->QI3_CODIGO + QI3->QI3_REV
				IF QI2->(dbSeek(QI9->QI9_FILIAL+Right(QI9->QI9_FNC,4)+QI9->QI9_FNC+QI9->QI9_REVFNC))
					QImpr(Padr("| "+Transform(QI2->QI2_FNC,"@r 999999/9999")+" "+QI2->QI2_REV+" "+;
						  Padr(QA_NUSR(QI2->QI2_FILMAT,QI2->QI2_MAT,.F.),30)+" "+;
						  PADR(DTOC(QI2->QI2_OCORRE),10)+" "+QI2->QI2_DESCR,131)+"|" , "C")
				Endif
				QI9->(dbSkip())
			Enddo
		Endif
	Endif	
    IF Li < 60
		QImpr("|"+Space(130)+"|","C")	
		QImpr(" "+Replicate("-",130)+" ","C")
		QImpr("","P")
	Endif
	dbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QI3")
Set Filter to
dbSetOrder(1)
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return Nil