#INCLUDE "QMTR040.Ch"
#Include "FIVEWIN.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ QMTR040	³ Autor ³ Alessandro B. Freire  ³ Data ³ 23.03.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Plano de Calibracao										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QMTr040(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Denis     ³Melhor³ Melhora de Performance - Utilizacao de Query's am-  ³±± 
±±³          ³      ³ biente Top e Arquivo Temporario para ambiente Code  ³±±
±±³          ³      ³ Base.												  ³±±
±±³Denis     ³Correc³ Acerto na descricao da funcao TcSrvType().          ³±± 
±±³Denis     ³Correc³ Listar as calibracoes previstas.                    ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QMTR040()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1		:= OemToAnsi(STR0001) // "Este programa ira emitir o Plano de Calibra‡„o dos Instrumentos"
Local cDesc2		:= ""
Local cDesc3		:= ""
Local limite		:= 220
Local cString		:="QM2"
Local aOrdem		:= {}
Local wnrel

Private titulo  	:= OemToAnsi(STR0005) // "Plano de Calibracao"
Private cabec1 		:= OemToAnsi(STR0010) // "                                                                     Freq.                                     |"
Private cabec2 		:= OemToAnsi(STR0002) // "Familia          Instrumento      Rev. Responsavel     Dias  Fabricante       Orgao Calibrador SG |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R."
Private aReturn		:= {OemToAnsi(STR0003),1,OemToAnsi(STR0004),1,2,1,"",1} // "Zebrado"###"Administra‡„o"
Private nomeprog	:="QMTR040"
Private nLastKey	:= 0
Private cPerg		:="QMR040"
Private cTamanho	:= "G"

/*
1 		  2			3			 4 		  5			6			 7 		  8			9			 0 		  1			2			 3 		  4			5			 6 		  7			8			 9 		  0			1
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Freq.                                      |Jan/98   |Fev/98   |Mar/98   |Abr/98   |Mai/98   |Jun/98   |Jul/98   |Ago/98   |Set/98   |Out/98   |Nov/98   |Dez/98
Familia          Instrumento      Rev. Responsavel     Dias  Fabricante       Orgao Calibrador SG |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.   |P.  R.
xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxx  xx	xxxxxxxxxxxxxxx xxx	 xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxx xxx|xx  xx/xx|xx  xx/xx|xx	xx/xx|xx  xx/xx|xx  xx/xx|xx	xx/xx|xx  xx/xx|xx  xx/xx|xx	xx/xx|xx  xx/xx|xx  xx/xx|xx	xx/xx
*/
AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("QMR040",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						    ³
//³ mv_par01: Instrumento Inicial                                   ³
//³ mv_par02: Instrumento Final                                     ³
//³ mv_par03: Periodo Inicial                                       ³
//³ mv_par04: Departamento Inicial                                  ³
//³ mv_par05: Departamento Final                                    ³
//³ mv_par06: Orgao Calibrador Todos/Interno/Externo                ³
//³ mv_par07: Orgao Calibrador interno inicial                      ³
//³ mv_par08: Orgao Calibrador interno final                        ³
//³ mv_par09: Orgao Calibrador externo inicial                      ³
//³ mv_par10: Orgao Calibrador externo final                        ³
//³ mv_par11: Fam¡lia inicial                                       ³
//³ mv_par12: Fam¡lia final                                         ³
//³ mv_par13: Fabricante inicial                                    ³
//³ mv_par14: Fabricante final                                      ³
//³ mv_par15: Usu rio inicial                                       ³
//³ mv_par16: Usu rio final                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordenacao dos registros										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrdem := { OemToAnsi(STR0006),; // "Familia+Instr.+Depto."
OemToAnsi(STR0007),; // "Familia+Depto.+Instr."
OemToAnsi(STR0008) } // "Depto.+Instr.+Familia"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="QMTR040"
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.F.,cTamanho)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| MTr040Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MTr040IMP³ Autor ³ Alessandro B.Freire   ³ Data ³ 23.03.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o plano de calibracao							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ MTr040IMP(lEnd,wnRel,cString) 							  ³±±
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
Static Function MTr040Imp(lEnd,wnRel,cString)

Local CbCont
Local CbTxt
Local lHaRegistros:= .T.
Local tamanho		:= "G"
Local nOrder		:= IndexOrd()
Local cAlias		:= Alias()
Local cInstr		:= ""
Local nIndice		:= 0
Local cChave		:= ""
Local nrecno		:= Recno()
Local cStrAnt		:= ""
Local lImprime 	:= .F.
Local nJ
Local nI
Local lOk
Local lTemPrev := .F.
Local cQuery := ""
Local cFiltroUser := aReturn[7]
Local nx			:= 1
Local cName			:= ""
Local cQryAd		:= ""
Private	TRB_INSTR	:= ""
Private	TRB_REVINS	:= ""
Private	TRB_REVINV	:= ""
Private	TRB_DEPTO	:= ""
Private	TRB_TIPO	:= ""
Private	TRB_VALDAF	:= ""
Private	TRB_FREQAF	:= ""
Private	TRB_RESP	:= ""
Private	TRB_FABR	:= ""
Private	TRB_Local 	:= ""
Private	TRB_STATUS	:= ""
Private	TRB_SQUARD	:= ""
Private cIndice		:= ""
Private dDataLim	:= AddMes( mv_par03, 11 )
Private nRecQM2		:= 0
Private aRetorno  := {}
Private aPrevRea 	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1   += Tr040Monta( mv_par03 )
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio ¡ndice tempor rio para corresponder a ordem desejada.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QM2")
#IFDEF TOP
	If TcSrvType() != "AS/400"
		cQuery := "SELECT QM2_FILIAL,QM2_INSTR,QM2_REVINS,QM2_REVINV,QM2_VALDAF,QM2_FREQAF,"
		//Tratamento de campos de usuario no filtro da SetPrint
		If !Empty(cFiltroUser)
			For nX := 1 To QM2->(FCount())
				cName := QM2->(FieldName(nX))
				If AllTrim( cName ) $ cFiltroUser
					If !cName $ cQuery .And. !cName $ cQryAd
						cQryAd += cName +","
					Endif 	
				EndIf 			       	
			 Next nX
			If !Empty(cQryAd)
				cQuery += cQryAd		
			Endif	
		Endif    
		cQuery += "QM2_DEPTO,QM2_RESP,QM2_TIPO,QM2_FABR,QM2_STATUS,QM2_SGUARD,QM2_LAUDO,QM2.R_E_C_N_O_ QM2RECNO "
		cQuery += "FROM "+RetSqlName("QM2")+" QM2 "					
		cQuery += "WHERE "
		cQuery += "QM2.QM2_FILIAL = '"			+xFilial("QM2")+	"' AND "
		cQuery += "QM2.QM2_INSTR  >= '"	+ mv_par01 + "' AND " 
		cQuery += "QM2.QM2_INSTR  <= '" + mv_par02 + "' AND " 
		cQuery += "QM2.QM2_VALDAF >= '"	+ Dtos(mv_par03)+	"' AND " 
		cQuery += "QM2.QM2_DEPTO BetWeen '"		+ mv_par04 +		"' AND '" + mv_par05 + 			"' AND " 
		cQuery += "QM2.QM2_TIPO BetWeen '"		+ mv_par11 +		"' AND '" + mv_par12 + 			"' AND " 
		cQuery += "QM2.QM2_FABR BetWeen '"		+ mv_par13 +		"' AND '" + mv_par14 + 			"' AND " 
		cQuery += "QM2.QM2_RESP BetWeen '"		+ mv_par15 +		"' AND '" + mv_par16 + 			"' AND " 
		cQuery += "QM2.QM2_FLAG = '1' AND " 
		cQuery += "QM2.D_E_L_E_T_= ' ' "
		Do Case
			Case aReturn[8] == 1
				cChave := "QM2_FILIAL+QM2_TIPO+QM2_INSTR+QM2_REVINV+QM2_DEPTO"
			Case aReturn[8] == 2
				cChave := "QM2_FILIAL+QM2_TIPO+QM2_DEPTO+QM2_INSTR+QM2_REVINV"
			Case aReturn[8] == 3
				cChave := "QM2_FILIAL+QM2_DEPTO+QM2_INSTR+QM2_REVINV+QM2_TIPO"
		EndCase
		cQuery += "ORDER BY " + SqlOrder(cChave)			
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
		TcSetField("TRB","QM2_VALDAF","D",8,0)
		dbSelectArea( "TRB" )
		dbGoTop()
	Else
#ENDIF	
		cIndice := CriaTrab(NIL,.F.)
		Do Case
			Case aReturn[8] == 1
				cChave := "QM2_FILIAL+QM2_TIPO+QM2_INSTR+QM2_REVINV+QM2_DEPTO"
			Case aReturn[8] == 2
				cChave := "QM2_FILIAL+QM2_TIPO+QM2_DEPTO+QM2_INSTR+QM2_REVINV"
			Case aReturn[8] == 3
				cChave := "QM2_FILIAL+QM2_DEPTO+QM2_INSTR+QM2_REVINV+QM2_TIPO"
		EndCase

		IndRegua("QM2",cIndice,cChave,,TR040Fil(),"Selecionando Registros")
		nIndice := RetIndex("QM2")
		dbSetIndex(cIndice+OrdBagExt())
		dbSetOrder(nIndice+1)
		dbSelectArea("QM2")	
		dbGoTop()
#IFDEF TOP
	Endif
#ENDIF

If BOF() .and. EOF()
	Help(" ",1,"RECNO")
End

SetRegua(RecCount())

While ! Eof()
	
	#IFDEF TOP  
		If TcSrvType() != "AS/400"
			TRB_FILIAL	:= TRB->QM2_FILIAL
			TRB_INSTR	:= TRB->QM2_INSTR
			TRB_REVINS	:= TRB->QM2_REVINS
			TRB_REVINV	:= TRB->QM2_REVINV
			TRB_DEPTO	:= TRB->QM2_DEPTO
			TRB_TIPO	:= TRB->QM2_TIPO
			TRB_VALDAF	:= TRB->QM2_VALDAF
			TRB_FREQAF	:= TRB->QM2_FREQAF
			TRB_RESP	:= TRB->QM2_RESP
			TRB_FABR	:= TRB->QM2_FABR
			TRB_STATUS	:= TRB->QM2_STATUS
			TRB_LAUDO	:= TRB->QM2_LAUDO
			TRB_SGUARD	:= TRB->QM2_SGUARD 		
			nRecQM2		:= TRB->QM2RECNO 		
		Else
	#ENDIF
			TRB_FILIAL	:= QM2->QM2_FILIAL
			TRB_INSTR	:= QM2->QM2_INSTR
			TRB_REVINS	:= QM2->QM2_REVINS
			TRB_REVINV	:= QM2->QM2_REVINV
			TRB_DEPTO	:= QM2->QM2_DEPTO
			TRB_TIPO	:= QM2->QM2_TIPO
			TRB_VALDAF	:= QM2->QM2_VALDAF
			TRB_FREQAF	:= QM2->QM2_FREQAF
			TRB_RESP	:= QM2->QM2_RESP
			TRB_FABR	:= QM2->QM2_FABR
			TRB_STATUS	:= QM2->QM2_STATUS
			TRB_SGUARD	:= QM2->QM2_SGUARD 
	#IFDEF TOP	
		Endif
	#ENDIF
	IncRegua()
	
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0009)	//"CANCELADO PELO OPERADOR"
		EXIT
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Revis„o anterior do instrumento n„o deve ser impresso		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF Alltrim(TRB_INSTR) == Alltrim(cStrAnt)
		dbSkip()
		Loop
	EndIf
	
	cStrAnt := TRB_INSTR
	
	//Verifica pasta filtro da SetPrint
	If !Empty(cFiltroUser) .and. !(&cFiltroUser)
		dbSkip()
		Loop		      
    Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifico O.C. interno e externo                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 1
		If ! Calibrador(0,mv_par07,mv_par08,mv_par09,mv_par10,TRB_INSTR,TRB_REVINS)
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifico O.C. interno                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 2
		If ! Calibrador(1,mv_par07,mv_par08,,,TRB_INSTR,TRB_REVINS)
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifico O.C. externo                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 3
		If ! Calibrador(2,,,mv_par09,mv_par10,TRB_INSTR,TRB_REVINS)
			dbSkip()
			Loop
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se status do instrumento esta com atualiza ativo       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !QMTXSTAT(TRB_STATUS)
		dbskip()
		loop
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ lOk: Criada para verificar se ha movimentacoes dentro do pe- ³
	//³ riodo desejado pelo usuario.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lOk		:= .F.
	aPrevRea := {}

	lOk := Tr040Prev(@lOk)
	
	If ! lOk
		dbSkip()
		Loop
	EndIf
	
	IF li > 53
		li := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		li++
	End
	
	/*
	1 		  2			3			 4 		  5			6			 7 		  8			9			 0 		  1			2			 3 		  4			5			 6 		  7			8			 9 		  0			1
	0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Freq.                                     |Jan/98  |Fev/98  |Mar/98  |Abr/98  |Mai/98  |Jun/98  |Jul/98  |Ago/98  |Set/98  |Out/98  |Nov/98  |Dez/98
	Familia          Instrumento      Rev Depto.    Responsavel          Dias Fabricante       Orgao Calibrador SG |P. R.   |P. R.   |P. R.   |P. R.   |P. R.   |P. R.   |P. R.   |P. R.   |P. R.   |P.  R.  |P.  R.  |P. R.
	xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxx xx  xxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxx  xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxx xxx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx|xx xx/xx
	*/
	@li,00  PSAY Alltrim(SubStr(TRB_TIPO,1,16))
	@li,17  PSAY Alltrim(SubStr(TRB_INSTR,1,16))
	@li,34  PSAY Alltrim(SubStr(TRB_REVINS,1,3))
	@li,38  PSAY Alltrim(SubStr(TRB_DEPTO,1,9))
	@li,48  PSAY Alltrim(SubStr(TRB_RESP,1,20))
	@li,69  PSAY Alltrim(Str(TRB_FREQAF,4))
	If !Empty(TRB_FABR) //Campo Fabricante nao eh obrigatorio....
		@li,74  PSAY Alltrim(SubStr(TRB_FABR,1,16))
		@li,91  PSAY IIF(QM9->QM9_ORGAFE == "I", QM9->QM9_DEPTO, QM9->QM9_LABOR)
		If !Empty(TRB_SGUARD)
			@li,108 PSAY Alltrim(SubStr(TRB_SGUARD,1,3))
		Endif	
	Else 
		TRB_FABR := Space(16)
		@li,74  PSAY TRB_FABR
		@li,91  PSAY IIF(QM9->QM9_ORGAFE == "I", QM9->QM9_DEPTO, QM9->QM9_LABOR)
		@li,108 PSAY SubStr(TRB_SGUARD,1,3)
	Endif	
	lTemPrev := .F.
	For nI := 1 to 30
		
		lImprime := .F.
		
		For nJ := 1 to 12
			If ! Empty(aPrevRea[nI][nJ,1])
				lImprime := .T.
				lTemPrev := .T.
				Exit
			EndIf
		Next nJ
		
		If ! lImprime
			Loop
		EndIf
		
		@li,111 PSAY "|" + (SubStr(DtoC(aPrevRea[nI][1,1]),1,2))
		If ! Empty(aPrevRea[nI][1,2])
			@li,115 PSAY (SubStr(DtoC(aPrevRea[nI][1,2]),1,5)) + "|"
		Else
			@li,115 PSAY "     |"
		EndIf
		
		@li,121 PSAY (SubStr(DtoC(aPrevRea[nI][2,1]),1,2))
		If ! Empty(aPrevRea[nI][2,2])
			@li,124 PSAY (SubStr(DtoC(aPrevRea[nI][2,2]),1,5)) + "|"
		Else
			@li,124 PSAY "     |"
		EndIf
		
		@li,130 PSAY (SubStr(DtoC(aPrevRea[nI][3,1]),1,2))
		If ! Empty(aPrevRea[nI][3,2])
			@li,133 PSAY (SubStr(DtoC(aPrevRea[nI][3,2]),1,5)) + "|"
		Else
			@li,133 PSAY "     |"
		EndIf
		
		@li,139 PSAY (SubStr(DtoC(aPrevRea[nI][4,1]),1,2))
		If ! Empty(aPrevRea[nI][4,2])
			@li,142 PSAY (SubStr(DtoC(aPrevRea[nI][4,2]),1,5)) + "|"
		Else
			@li,142 PSAY "     |"
		EndIf
		
		@li,148 PSAY (SubStr(DtoC(aPrevRea[nI][5,1]),1,2))
		If ! Empty(aPrevRea[nI][5,2])
			@li,151 PSAY (SubStr(DtoC(aPrevRea[nI][5,2]),1,5)) + "|"
		Else
			@li,151 PSAY "     |"
		Endif
		
		@li,157 PSAY (SubStr(DtoC(aPrevRea[nI][6,1]),1,2))
		If ! Empty(aPrevRea[nI][6,2])
			@li,160 PSAY (SubStr(DtoC(aPrevRea[nI][6,2]),1,5)) + "|"
		Else
			@li,160 PSAY "     |"
		EndIf
		
		@li,166 PSAY (SubStr(DtoC(aPrevRea[nI][7,1]),1,2))
		If ! Empty(aPrevRea[nI][7,2])
			@li,169 PSAY (SubStr(DtoC(aPrevRea[nI][7,2]),1,5)) + "|"
		Else
			@li,169 PSAY "     |"
		EndIf
		
		@li,175 PSAY (SubStr(DtoC(aPrevRea[nI][8,1]),1,2))
		If ! Empty(aPrevRea[nI][8,2])
			@li,178 PSAY (SubStr(DtoC(aPrevRea[nI][8,2]),1,5)) + "|"
		Else
			@li,178 PSAY "     |"
		EndIf
		
		@li,184 PSAY (SubStr(DtoC(aPrevRea[nI][9,1]),1,2))
		If ! Empty(aPrevRea[nI][9,2])
			@li,187 PSAY (SubStr(DtoC(aPrevRea[nI][9,2]),1,5)) + "|"
		Else
			@li,187 PSAY "     |"
		EndIf
		
		@li,193 PSAY (SubStr(DtoC(aPrevRea[nI][10,1]),1,2))
		If ! Empty(aPrevRea[nI][10,2])
			@li,196 PSAY (SubStr(DtoC(aPrevRea[nI][10,2]),1,5)) + "|"
		Else
			@li,196 PSAY "     |"
		EndIf
		
		@li,202 PSAY (SubStr(DtoC(aPrevRea[nI][11,1]),1,2))
		If ! Empty(aPrevRea[nI][11,2])
			@li,205 PSAY (SubStr(DtoC(aPrevRea[nI][11,2]),1,5)) + "|"
		Else
			@li,205 PSAY "     |"
		EndIf
		
		@li,211 PSAY (SubStr(DtoC(aPrevRea[nI][12,1]),1,2))
		If ! Empty(aPrevRea[nI][12,2])
			@li,214 PSAY (SubStr(DtoC(aPrevRea[nI][12,2]),1,5)) + "|"
		Else
			@li,214 PSAY "     |"
		EndIf
		li++
	Next nI

	If !lTemPrev
		li++
	EndIf
		
	@li,00 PSAY Repl("-",220)
	li++

	#IFDEF TOP	
		If TcSrvType() != "AS/400"
			dbSelectArea("TRB")
		Else
		#ENDIF	
			dbSelectArea("QM2")
		#IFDEF TOP
		Endif
	#ENDIF		
	dbSkip()
	Loop
End

Roda( cbCont, cbTxt, Tamanho )

Set Device To Screen
#IFNDEF TOP
	Set Filter To
	RetIndex("QM2")
	dbSetOrder(nOrder)
	dbGoto(nRecno)
	FErase(cIndice+OrdBagExt())
#ELSE
	dbSelectArea("TRB")
	dbCloseArea()
	dbSelectArea("QM2")
	dbSetOrder(nOrder)	
#ENDIF


If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
End

MS_FLUSH()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ TR040Prev³ Autor ³ Alessandro B.Freire   ³ Data ³ 22.08.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna as datas previstas para calibracao				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr040Prev() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QMTR040													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TR040Prev( lret )

Local nOldOrd	 := QM2->(IndexOrd())
//Local aRetorno  := {}
Local nLinha
Local nCol
Local dData
Local nI
Local cFiltro
Local aArea 
Local lReal := .F.
Local nColr  
aArea := GetArea()
aRetorno  := {}
For nI := 1 to 30
	AAdd( aRetorno,{{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")},;
	{CtoD("  /  /  ","DDMMYY"),CtoD("  /  /  ","DDMMYY")} } )
Next nI 

dbSelectArea("QM6")
dbSetOrder(1)
dbSeek( TRB_FILIAL+TRB_INSTR+TRB_REVINS+DTOS(mv_par03), .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Medicoes efetuadas.											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ! Eof() .And.	QM6->QM6_FILIAL+QM6->QM6_INSTR+QM6->QM6_REVINS == ;
	TRB_FILIAL+TRB_INSTR+TRB_REVINS
	
	If ( dDataLim < QM6->QM6_DTPREV ) .And. ;
		(Month(QM6->QM6_DTPREV)+Year(QM6->QM6_DTPREV) != ;
		Month(dDataLim)+Year(dDataLim) )
		dbSkip()
		Loop
	EndIf

	If QM6->QM6_DTPREV >= mv_par03 .or. ;
		(Month(QM6->QM6_DTPREV) == Month(mv_par03) .and.;
		Year(QM6->QM6_DTPREV) == Year(mv_par03) )
	
		If Year(QM6->QM6_DTPREV) == Year(mv_par03)
			nCol := Month(QM6->QM6_DTPREV)-Month(mv_par03) + 1
		Else
			nCol := 12 - Month(dDataLim) + Month(QM6->QM6_DTPREV)
		EndIf
	
		If mv_par17 == 1
			If Year(QM6->QM6_DATA) == Year(mv_par03)
				nColR := Month(QM6->QM6_DATA)-Month(mv_par03) + 1
			Else
				nColR := 12 - Month(dDataLim) + Month(QM6->QM6_DATA)
			EndIf
        EndIf
        
		For nI := 1 to Len( aRetorno )
			If mv_par17 == 1
				If Empty(aRetorno[nI][nCol][1])
					lReal := .T.				
					If nCol == nColr
						aRetorno[nI][nCol] := {QM6->QM6_DTPREV,QM6->QM6_DATA}
					Else
						aRetorno[nI][nCol] := {QM6->QM6_DTPREV,Ctod("  /  /  ")}
						aRetorno[nI][nColr]:= {Ctod("  /  /  "),QM6->QM6_DATA}			
					Endif	
					Exit
				EndIf
			Else
				If Empty(aRetorno[nI][nCol][1])
					lReal := .T.				
					aRetorno[nI][nCol] := {QM6->QM6_DTPREV,QM6->QM6_DATA}
					Exit
				EndIf
			Endif
		Next nI
	EndIf
	lRet := .T.
	dbSkip()

EndDo
#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea("TRB")
		dbGoTo(nRecQM2)
	Else
#ENDIF			
		dbSelectArea("QM2")
		dbSetOrder(nOldOrd)
#IFDEF TOP
	Endif
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Previsoes das proximas medicoes.							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dData := TRB_VALDAF

While (dData <= dDataLim) .or. (Month(dData)==Month(dDataLim) .and.;
	Year(dData)==Year(dDataLim))
	
	If Eof()
		Exit
	EndIf
	
	If dData >= mv_par03 .or. ;
		( Month(dData) == Month(mv_par03) .and. Year(dData) == Year(mv_par03) )
		
		If Year(dData) == Year(mv_par03)
			nCol := Month(dData)-Month(mv_par03) + 1
		Else
			nCol := 12 - Month(dDataLim) + Month(dData)
		EndIf
		
		For nI := 1 to Len( aRetorno )
			If Empty(aRetorno[nI][nCol][1])
				If !lReal
					aRetorno[nI][nCol] := { dData, CtoD("  /  /  ","DDMMYY") }
				Endif	
				Exit
			EndIf
		Next nI
	EndIf
	
	lReal := .F.
	dData += TRB_FREQAF
	lRet  := .T.
	
EndDo
RestArea(aArea)

aPrevRea := aClone(aRetorno)

//Return(aRetorno)
  
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AddMes	³ Autor ³ Alessandro B.Freire   ³ Data ³ 22.08.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Adiciona <n> meses a data passada como parametro			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ AddMes( dData, nMeses ) 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dData 	 -> Data inicial								  ³±±
±±³			 ³ nMeses	 -> No. de Meses a se adicionar a data inicial	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QMTR040													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function AddMes( dData, nMeses )
Local IsBissexto := (Int(Year(dData)/4) == (Year(dData)/4))

dDataRet := StrZero(Day(dData),2) + "/"

If Month(dData) + nMeses == 2
	If IsBissexto 
		dDataRet := "29/"
	EndIf
	If ! IsBissexto 
		dDataRet := "28/"
	EndIf
EndIf

nMes := Month(dData)+nMeses


If nMes > 12
	nAno := StrZero(Year(dData)+Int(nMes/12),4)
	nMes := nMes - 12
Else
	nAno := StrZero(Year(dData),4)
EndIf

If SubStr(Str(nMes),14,18) $ " 1| 3| 5| 7| 8| 10| 12"
	dDataRet := "31/"
ElseIf SubStr(Str(nMes),14,18) $ " 4| 6| 9| 11"
	dDataRet :=	"30/"
Endif

dDataRet += StrZero(nMes,2) + "/"+nAno

Return(CtoD(dDataRet,"DDMMYY"))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ TR040Fil ³ Autor ³ Alessandro B.Freire   ³ Data ³ 20.08.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtro do plano de calibracao 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Tr040Fil 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QMTR040													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Tr040Fil()

Local cExpr := ""

cExpr := 'QM2_FILIAL=="'+ xFilial("QM2") + '".And.'
cExpr += 'QM2_INSTR>="' + mv_par01 + '".And.'
cExpr += 'QM2_INSTR<="' + mv_par02 + '".And.'
cExpr += 'DTOS(QM2_VALDAF)>="' + DTOS(mv_par03) + '".And.'
cExpr += 'QM2_DEPTO>="' + mv_par04 + '".And.'
cExpr += 'QM2_DEPTO<="' + mv_par05 + '".And.'
cExpr += 'QM2_TIPO>="' + mv_par11 + '".And.'
cExpr += 'QM2_TIPO<="' + mv_par12 + '".And.'
cExpr += 'QM2_FABR>="' + mv_par13 + '".And.'
cExpr += 'QM2_FABR<="' + mv_par14 + '".And.'
cExpr += 'QM2_RESP>="' + mv_par15 + '".And.'
cExpr += 'QM2_RESP<="' + mv_par16 + '".And.'
cExpr += 'QM2_FLAG == "1"'
Return(cExpr)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³tr040Monta³ Autor ³ Alessandro B. Freire  ³ Data ³ 25.06.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a primeira linha do cabecalho                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ tr040Monta( dData )										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QMTR040													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION Tr040Monta()

Local aMeses	:= {STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,; // "Jan"###"Fev"###"Mar"###"Abr"###"Mai"###"Jun"
STR0017,STR0018,STR0019,STR0020,STR0021,STR0022 } // "Jul"###"Ago"###"Set"###"Out"###"Nov"###"Dez"

Local dData    := mv_par03
Local cCab1    := ""
Local nI

For nI := 1 to 12
	cCab1 += aMeses[Month(dData)] + "/" + SubStr(Str(Year(dData),4),3,2)
	cCab1 += "  |"
	dData := AddMes(dData,1)
Next

Return( cCab1 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AjustaSX1    ³Autor ³  Denis Martins       ³Data³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1("QMR040","17","Imprime Real. no Mes?","Imp.Realizado no Mes ?","Imp.Realizado no Mes ?","mv_chh","N",1,0,2,"C","","","","",;
   "mv_par17","Sim","Si","Yes","","Nao","No","No","","","","","","")	   
   
Return .t.
