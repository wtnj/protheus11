#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

#Include "TOPCONN.CH"
#Include "PROTHEUS.CH"
#Include "MSOLE.CH"

Static cCodIns

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SECR002	³ Autor ³Regiane & LeandroSD    ³ Data ³ 03/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emite o historico escolar						       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Academico 							          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SECR002()
Local oDlgPrint,oBtnImp,oBtnSair,oBtnPar,oMemo,oGroup
Local cPerg     := "SEC002"
Local cObjetivo := ""
Local lOpc      := .f.
Local cFiltro   := ""

//Funcoes requeridas para as funcoes de impressao
Private nLastKey  := 0
Private cArqTRBC  := ""
Private cArqTRBD  := ""
Private cArqTRBI  := ""
Private cOrder    := ""

Private cPRO := Space(6)
Private cSEC := Space(6)

if cCodIns == nil
	cCodIns := GetMV("MV_ACCODIN")
endif

cObjetivo := "Este programa tem como objetivo, imprimir o Historico "
cObjetivo += "Escolar de acordo com os parâmetros informados pelo usuário."

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da tela												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDlgPrint := MSDialog():New( 10,10,250,350,"Impressão de Historico Escolar",,,,,,,,,.T. )

oGroup    := TGroup():New( 3,4,115,166,"",,,,.T.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos Botoes											    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oBtnImp   := SButton():New( 15, 125, 1, {|| oDlgPrint:End(),lOpc := .T.},,.T. )
oBtnSair  := SButton():New( 35, 125, 2, {|| oDlgPrint:End()},,.T. )
oBtnPar   := SButton():New( 55, 125, 5, {|| Pergunte(cPerg,.T.)},,.T. )

oBtnImp :cToolTip  := "Imprimir..."
oBtnSair:cToolTip  := "Sair..."
oBtnPar :cToolTip  := "Parâmetros..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do campo Memo                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oMemo:= tMultiget():New(10,10,{|u|if(Pcount()>0,cObjetivo:=u,cObjetivo)},oDlgPrint,100,100,,,,,,.T.,,,{||.F.})

oDlgPrint:Activate(,,,.T.,,,)

If lOpc
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da rotina de escolha de assinaturas.... ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF   ALLTRIM(Posicione("JAH",1,xFilial("JAH")+POSICIONE("JBE",1,XFILIAL("JBE")+mv_par01,"JBE->JBE_CODCUR"),"JAH_GRUPO")) $ '004/008'
		cVar := SPACE (500)
		Processa({||U_sASIN() })
	ELSE
		Processa({||U_ASSREQ() })
	ENDIF
	
	cFiltro 				:= "SELECT DISTINCT "
	cFiltro 				+= "	JBE.JBE_NUMRA NUMRA, "
	cFiltro 				+= "	JBE.JBE_CODCUR CODCUR, "
	cFiltro 				+= "	JAF.JAF_DESMEC DESCCUR, "
	cFiltro 				+= "	JAF.JAF_COD ccURLO "
	
	cFiltro 				+= "FROM "
	cFiltro 				+= "	" + RetSQLName("JBE") + " JBE, "
	cFiltro 				+= "	" + RetSQLName("JAH") + " JAH, "
	cFiltro 				+= "	" + RetSQLName("JAF") + " JAF "
	
	cFiltro 				+= "WHERE "
	cFiltro 				+= " JBE.JBE_FILIAL = '" + xFilial( "JBE" ) 	+ "' "
	cFiltro 				+= "	AND JAF.JAF_FILIAL = '"	+ xFilial( "JAF" ) 	+ "' "
	cFiltro 				+= "	AND JAH.JAH_FILIAL = '"	+ xFilial( "JAH" ) 	+ "' "
	cFiltro 				+= "	AND JBE.JBE_NUMRA  Between '" + mv_par01 + "' And '"+mv_par02	+"' "
	cFiltro 				+= "	AND JBE.JBE_CODCUR Between '" + mv_par05 + "' And '"+mv_par06	+"' "
	cFiltro 				+= "	AND JBE.JBE_TURMA  Between '" + mv_par07 + "' And '"+mv_par08	+"' "
	cFiltro 				+= "	AND JAH.JAH_UNIDAD Between '" + mv_par09 + "' And '"+mv_par10	+ "' "
	cFiltro 				+= "	AND JAH.JAH_CODIGO = JBE.JBE_CODCUR "
	cFiltro 				+= "	AND JAF.JAF_COD    = JAH.JAH_CURSO "
	cFiltro 				+= "	AND JAF.JAF_VERSAO = JAH.JAH_VERSAO "
	cFiltro 				+= "	AND JAF.JAF_AREA   Between '" + mv_par03 + "' And '"+ mv_par04 	+ "' "
	
	cFiltro 				+= "ORDER BY "
	cFiltro 				+= "	NUMRA, CODCUR "
	
	cFiltro 				:= ChangeQuery(cFiltro)
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cFiltro),"TMP", .F., .T.)
	TMP->( dbGotop() )
	while TMP->( !eof() )
		cARcUR	:=	TMP->ccURLO
		Processa( { || ACATRB0002(.T.,TMP->NUMRA,TMP->CODCUR,TMP->DESCCUR, mv_par11 == 2,cARcUR) } )
		TMP->( dbSkip() )
	end
	TMP->( dbCloseArea() )
	
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SEC0002	³ Autor ³Regiane & LeandroSD    ³ Data ³ 03/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emite o historico escolar						       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Academico 							          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0002()
Local nLastKey	:= 0

Private cPRO						:= Space(6)
Private cSEC						:= Space(6)

//Chamada da rotina de escolha de assinaturas....
Processa({||U_ASSREQ() })

If nLastKey == 27
	Set Filter To
	Return
EndIf

// Chamada da rotina de armazenamento de dados...
Processa({||ACATRB0002() })

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACATRB0002³ Autor ³Regiane & LeandroSD    ³ Data ³ 03/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Armazenamento e Tratamento dos dados 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	 ³ Especifico Academico              				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³								            ³ Data ³  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION ACATRB0002(lViaMenu,cRa,cCodCur,cDescCur,lPrint,cARcUR)
Local aCamposC		:= {}
Local aCamposD		:= {}
Local aCamposI		:= {}
Local cQuery		:= ""
Local aTamRA		:= TamSX3("JA2_NUMRA")

Local aRet			:= {}
Local lOracle		:= "ORACLE" $ TcGetDb()
Local lAchou
Local cArqTRBC  	:= ""
Local cArqTRBD  	:= ""
Local cArqTRBI  	:= ""
Local aPerLets		:= {}
Local aDisOpt		:= {}
Local nLenOpt		:= 0
Local nInd			:= 0
Local aAreaJC7
Local cDisOri

lViaMenu := if( lViaMenu == NIL, .F., lViaMenu )
lPrint   := if( lPrint == NIL, .F., lPrint )

ProcRegua( 4 )

If !lViaMenu
	cRA 					:= Left(JBH_CODIDE,aTamRA[1])
	cNumReq 				:= JBH->JBH_NUM
	aRet 					:= ACScriptReq( cNumReq )
	IF ALLTRIM(Posicione("JAH",1,xFilial("JAH")+aRet[1],"JAH_GRUPO")) $ '004/008'
		U_ACATRBLE2D(.F.,cRa,cCodCur,cDescCur,lPrint,cARcUR,cVar)
		RETURN
	ENDIF
Else
	aRet 					:= {cCodCur,cDescCur}
	IF ALLTRIM(Posicione("JAH",1,xFilial("JAH")+cCodCur,"JAH_GRUPO")) $ '004/008'
		U_ACATRBLE2D(.T.,cRa,cCodCur,cDescCur,lPrint,cARcUR,cVar)
		RETURN
	ENDIF
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivos de Trabalho			       				     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCamposC,{"NUMRA"			,"C",TamSX3("JA2_NUMRA")[1],0})
Aadd(aCamposC,{"UNIDADE"		,"C",TamSX3("JA3_DESLOC")[1],0})
Aadd(aCamposC,{"CEP"      		,"C",008,0})
Aadd(aCamposC,{"ENDERECO" 		,"C",TamSX3("JA3_END")[1],0})
Aadd(aCamposC,{"NUMEND"   		,"C",TamSX3("JA3_NUMEND")[1],0})
Aadd(aCamposC,{"COMPLE"   		,"C",TamSX3("JA3_COMPLE")[1],0})
Aadd(aCamposC,{"BAIRRO"   		,"C",TamSX3("JA3_BAIRRO")[1],0})
Aadd(aCamposC,{"CIDADE"   		,"C",TamSX3("JA3_CIDADE")[1],0})
Aadd(aCamposC,{"ESTADO"   		,"C",002,0})
Aadd(aCamposC,{"FONE"     		,"C",TamSX3("JA3_FONE")[1],0})
Aadd(aCamposC,{"CODCUR"   		,"C",TamSX3("JAH_CODIGO")[1],0})
Aadd(aCamposC,{"HABILI"			,"C",TamSX3("JDK_CODIGO")[1],0})
Aadd(aCamposC,{"CURSO"			,"C",TamSX3("JAF_DESMEC")[1],0})
Aadd(aCamposC,{"DECRET"			,"C",TamSX3("JCF_MEMO3")[1],0})
Aadd(aCamposC,{"NOME"			,"C",TamSX3("JA2_NOME")[1],0})
Aadd(aCamposC,{"NACION"			,"C",030,0})
Aadd(aCamposC,{"NATURA"			,"C",030,0})
Aadd(aCamposC,{"DTNASC"			,"D",008,0})
Aadd(aCamposC,{"RG"				,"C",TamSX3("JA2_RG")[1],0})
Aadd(aCamposC,{"ESTRG"			,"C",002,0})
Aadd(aCamposC,{"TITULO"			,"C",TamSX3("JA2_TITULO")[1],0})
Aadd(aCamposC,{"ENTIDA"			,"C",TamSX3("JCL_NOME")[1],0})
Aadd(aCamposC,{"ENTCID"			,"C",TamSX3("JCL_CIDADE")[1],0})
Aadd(aCamposC,{"ENTEST"			,"C",002,0})
Aadd(aCamposC,{"CONCLU"			,"C",004,0})
Aadd(aCamposC,{"INSTIT"			,"C",006,0})
Aadd(aCamposC,{"DATAPR"			,"C",TamSX3("JA2_DATAPR")[1],0})
Aadd(aCamposC,{"CLASSF"			,"C",006,0})
Aadd(aCamposC,{"PONTUA"			,"N",008,2})
Aadd(aCamposC,{"CHCURSO"		,"N",TamSX3("JAF_CARGA")[1],0})
Aadd(aCamposC,{"INICIO"			,"D",008,0})
Aadd(aCamposC,{"FIM"			,"D",008,0})
Aadd(aCamposC,{"LOCAL"			,"C",006,0})
Aadd(aCamposC,{"DISPRO"			,"C",006,0})
Aadd(aCamposC,{"FORING"			,"C",001,0})
Aadd(aCamposC,{"CMILIT"			,"C",014,0})
Aadd(aCamposC,{"SEXO"			,"C",001,0})
Aadd(aCamposC,{"QTDOPT"			,"N",002,0})

cArqTRBC := CriaTrab(aCamposC,.T.)
dbUseArea( .T.,, cArqTRBC, "TRBC", .F., .F. )
IndRegua( "TRBC",cArqTRBC,"NUMRA+CURSO",,,"Selecionando Registros...")

Aadd(aCamposD,{"DISCIP"			,"C",TamSX3("JAE_DESC")[1],0})
Aadd(aCamposD,{"DISPAI"			,"C",015,0})
Aadd(aCamposD,{"DMESTRE"		,"C",TamSX3("JAE_DESC")[1],0})

cArqTRBD := CriaTrab(aCamposD,.T.)
dbUseArea( .T.,, cArqTRBD, "TRBD", .F., .F. )
IndRegua( "TRBD",cArqTRBD,"DISCIP+DISPAI",,,"Selecionando Registros...")

Aadd(aCamposI,{"CODCUR"			,"C",006,0})
Aadd(aCamposI,{"ANO"			,"C",004,0})
Aadd(aCamposI,{"PERIOD"			,"C",002,0})
Aadd(aCamposI,{"CODDIS"			,"C",TamSX3("JAE_CODIGO")[1],0})
Aadd(aCamposI,{"DISCIP"			,"C",TamSX3("JAE_DESC")[1],0})
Aadd(aCamposI,{"MEDIA"			,"N",TamSX3("JC7_MEDFIM")[1],TamSX3("JC7_MEDFIM")[2]})
Aadd(aCamposI,{"MEDCON"			,"C",TamSX3("JC7_MEDCON")[1],0})
Aadd(aCamposI,{"DESMCO"			,"C",TamSX3("JC7_DESMCO")[1],0})
Aadd(aCamposI,{"CH"				,"N",004,0})
Aadd(aCamposI,{"SITUAC"			,"C",001,0})
Aadd(aCamposI,{"INSTIT"			,"C",006,0})
Aadd(aCamposI,{"ANOINS"			,"C",TamSX3("JCO_ANOINS")[1],0})
Aadd(aCamposI,{"AE"				,"C",001,0})
Aadd(aCamposI,{"SEMESTRE"		,"C",002,0})
Aadd(aCamposI,{"HABILI"  		,"C",TamSX3("JC7_HABILI")[1],TamSX3("JC7_HABILI")[2]})
Aadd(aCamposI,{"CODPROF"		,"C",006,0})
Aadd(aCamposI,{"NOMEPROF"		,"C",TamSX3("RA_NOME")[1],0})
Aadd(aCamposI,{"CARGOPRF"		,"C",030,0})
Aadd(aCamposI,{"FALTAS"			,"N",004,0})
Aadd(aCamposI,{"TIPODIS"		,"C",003,0})
Aadd(aCamposI,{"OPTATIVA"		,"C",001,0})
Aadd(aCamposI,{"ORDEM"			,"C",001,0})
Aadd(aCamposI,{"TOTCHARG"		,"N",004,0})

cArqTRBI := CriaTrab(aCamposI,.T.)
dbUseArea( .T.,, cArqTRBI, "TRBI", .F., .F. )
IndRegua( "TRBI",cArqTRBI,"CODCUR+ORDEM+SEMESTRE+HABILI+CODDIS",,,"Selecionando Registros...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query do cabecalho   				   	                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT "
cQuery += "	JAH.JAH_CODIGO CODCUR , "
cQuery += "	JAH.JAH_CURSO CURPAD , "
cQuery += "	JA2.JA2_NUMRA NUMRA , "
cQuery += "	JA2.JA2_NOME NOME , "
cQuery += "	JA2.JA2_NACION NACION , "
cQuery += "	JA2.JA2_NATURA NATURA , "
cQuery += "	JA2.JA2_DTNASC DTNASC , "
cQuery += "	JA2.JA2_RG RG , "
cQuery += "	JA2.JA2_ESTRG ESTRG , "
cQuery += "	JA2.JA2_TITULO TITULO , "
cQuery += "	JCL.JCL_NOME ENTIDA , "
cQuery += "	JCL.JCL_CIDADE ENTCID , "
cQuery += "	JCL.JCL_ESTADO ENTEST , "
cQuery += " JA2.JA2_CONCLU CONCLU , "
cQuery += "	JA2.JA2_INSTIT INSTIT , "
cQuery += "	JA2.JA2_DATAPR DATAPR , "
cQuery += "	JA2.JA2_CLASSF CLASSF , "
cQuery += "	JA2.JA2_PONTUA PONTUA , "
cQuery += "	JA3.JA3_CODLOC LOCAL , "
cQuery += "	JA3.JA3_DESLOC UNIDADE , "
cQuery += "	JA3.JA3_CEP    CEP , "
cQuery += "	JA3.JA3_END    ENDERECO , "
cQuery += "	JA3.JA3_NUMEND NUMEND , "
cQuery += "	JA3.JA3_COMPLE COMPLE , "
cQuery += "	JA3.JA3_BAIRRO BAIRRO , "
cQuery += "	JA3.JA3_CIDADE CIDADE , "
cQuery += "	JA3.JA3_EST    ESTADO , "
cQuery += "	JA3.JA3_FONE   FONE , "
cQuery += "	JAF.JAF_CARGA  CHCURSO, "
cQuery += "	JA2.JA2_MEMO2  DISPRO, "
cQuery += "	JA2.JA2_FORING FORING, "
cQuery += "	JA2.JA2_CMILIT CMILIT, "
cQuery += "	JA2.JA2_SEXO   SEXO, "
cQuery += " SUM(JAW.JAW_QTDOPT) QTDOPT, "
cQuery += "	MIN(JAR.JAR_DATA1) INICIO, "
cQuery += "	MAX(JAR.JAR_DATA2) FIM, "
cQuery += " MAX(JAR.JAR_HABILI) HABILI "

cQuery += "FROM  "
cQuery += "	" + RetSQLName("JA2")+ " JA2, "
cQuery += "	" + RetSQLName("JA3")+ " JA3, "
cQuery += "	" + RetSQLName("JAH")+ " JAH, "
cQuery += "	" + RetSQLName("JAF")+ " JAF, "
cQuery += "	" + RetSQLName("JCL")+ " JCL, "
cQuery += "	" + RetSQLName("JAR")+ " JAR, "
cQuery += " " + RetSQLName("JAW")+ " JAW "

cQuery += "WHERE "
cQuery += "       JA2.JA2_FILIAL  = '" + xFilial("JA2")	+"' "
cQuery += "   and JA3.JA3_FILIAL  = '" + xFilial("JA3")	+"' "
cQuery += "   and JAH.JAH_FILIAL  = '" + xFilial("JAH")	+"' "
cQuery += "   and JAF.JAF_FILIAL  = '" + xFilial("JAF")	+"' "
cQuery += "   and JAW.JAW_FILIAL  = '" + xFilial("JAW")	+"' "

if lOracle
	cQuery += "   and JCL.JCL_FILIAL(+)  = '"	+ xFilial("JCL")	+"' "
else
	cQuery += "   and JCL.JCL_FILIAL  = '"	+ xFilial("JCL")	+"' "
endif

cQuery += "   and JA2.JA2_NUMRA  = '" + cRA + "' "
cQuery += "   and JAH.JAH_CODIGO = '" + aRet[1] + "' "
cQuery += "   and JAF.JAF_COD    = JAH.JAH_CURSO "
cQuery += "   and JAF.JAF_VERSAO = JAH.JAH_VERSAO "
cQuery += "   and JA3.JA3_CODLOC = JAH.JAH_UNIDAD "

if lOracle
	cQuery += "   and JA2.JA2_ENTIDA = JCL.JCL_CODIGO(+) "
else
	cQuery += "   and JA2.JA2_ENTIDA *= JCL.JCL_CODIGO "
endif

cQuery += "   and JAR.JAR_CODCUR = JAH.JAH_CODIGO "
cQuery += "   and JAW.JAW_CURSO = JAF.JAF_COD "
cQuery += "   and JAW.JAW_VERSAO = JAF.JAF_VERSAO "
cQuery += "   and JAW.JAW_PERLET = JAR.JAR_PERLET "
cQuery += "   and JAW.JAW_HABILI = JAR.JAR_HABILI "

cQuery += "   and JA2.D_E_L_E_T_ <> '*' "
cQuery += "   and JA3.D_E_L_E_T_ <> '*' "
cQuery += "   and JAH.D_E_L_E_T_ <> '*' "
cQuery += "   and JAF.D_E_L_E_T_ <> '*' "
cQuery += "   and JAW.D_E_L_E_T_ <> '*' "

if lOracle
	cQuery += "   and JCL.D_E_L_E_T_(+) <> '*' "
else
	cQuery += "   and JCL.D_E_L_E_T_ <> '*' "
endif

cQuery += "   and JAR.D_E_L_E_T_ <> '*' "

cQuery += "GROUP BY "

cQuery += "	JAH.JAH_CODIGO  , "
cQuery += "	JAH.JAH_CURSO  , "
cQuery += "	JA2.JA2_NUMRA  , "
cQuery += "	JA2.JA2_NOME  , "
cQuery += "	JA2.JA2_NACION  , "
cQuery += "	JA2.JA2_NATURA  , "
cQuery += "	JA2.JA2_DTNASC  , "
cQuery += "	JA2.JA2_RG  , "
cQuery += "	JA2.JA2_ESTRG  , "
cQuery += "	JA2.JA2_TITULO  , "
cQuery += "	JCL.JCL_NOME  , "
cQuery += "	JCL.JCL_CIDADE  , "
cQuery += "	JCL.JCL_ESTADO  , "
cQuery += " JA2.JA2_CONCLU  , "
cQuery += "	JA2.JA2_INSTIT  , "
cQuery += "	JA2.JA2_DATAPR  , "
cQuery += "	JA2.JA2_CLASSF  , "
cQuery += "	JA2.JA2_PONTUA  , "
cQuery += "	JA3.JA3_CODLOC  , "
cQuery += "	JA3.JA3_DESLOC  , "
cQuery += "	JA3.JA3_CEP     , "
cQuery += "	JA3.JA3_END     , "
cQuery += "	JA3.JA3_NUMEND  , "
cQuery += "	JA3.JA3_COMPLE  , "
cQuery += "	JA3.JA3_BAIRRO  , "
cQuery += "	JA3.JA3_CIDADE  , "
cQuery += "	JA3.JA3_EST     , "
cQuery += "	JA3.JA3_FONE    , "
cQuery += "	JAF.JAF_CARGA   , "
cQuery += "	JA2.JA2_MEMO2   , "
cQuery += "	JA2.JA2_FORING  , "
cQuery += "	JA2.JA2_CMILIT  , "
cQuery += "	JA2.JA2_SEXO "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQJC", .F., .T.)
TcSetField("SQJC","INICIO","D",8,0)
TcSetField("SQJC","FIM"   ,"D",8,0)
TcSetField("SQJC","DTNASC","D",8,0)
TcSetField("SQJC","DATAPR","C",TamSX3("JA2_DATAPR")[1],0)
TcSetField("SQJC","PONTUA","N",8,2)
TcSetField("SQJC","QTDOPT","N",2,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerando o arquivo de trabalho do cabecalho                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea ("SQJC")
While !Eof()
	DbSelectArea( "TRBC" )
	RecLock( "TRBC",.T. )
	
	TRBC->NUMRA 		:= SQJC->NUMRA
	TRBC->UNIDADE 		:= SQJC->UNIDADE
	TRBC->ENDERECO		:= SQJC->ENDERECO
	TRBC->NUMEND		:= SQJC->NUMEND
	TRBC->COMPLE		:= SQJC->COMPLE
	TRBC->CEP			:= SQJC->CEP
	TRBC->BAIRRO		:= SQJC->BAIRRO
	TRBC->CIDADE		:= SQJC->CIDADE
	TRBC->ESTADO		:= SQJC->ESTADO
	TRBC->FONE			:= SQJC->FONE
	TRBC->CODCUR		:= SQJC->CODCUR
	TRBC->LOCAL	 		:= SQJC->LOCAL
	TRBC->CURSO   		:= aRet[2]
	TRBC->HABILI		:= SQJC->HABILI
	TRBC->DECRET  		:= AcDecret(SQJC->CURPAD)
	TRBC->NOME    		:= SQJC->NOME
	TRBC->NACION  		:= SQJC->NACION
	TRBC->NATURA  		:= TABELA("12", ALLTRIM(SQJC->NATURA), .F.)
	TRBC->DTNASC  		:= SQJC->DTNASC
	TRBC->RG      		:= SQJC->RG
	TRBC->ESTRG   		:= SQJC->ESTRG
	TRBC->TITULO  		:= SQJC->TITULO
	TRBC->ENTIDA  		:= SQJC->ENTIDA
	TRBC->ENTCID  		:= SQJC->ENTCID
	TRBC->ENTEST  		:= SQJC->ENTEST
	TRBC->CONCLU  		:= SQJC->CONCLU
	TRBC->INSTIT  		:= SQJC->INSTIT
	TRBC->DATAPR  		:= SQJC->DATAPR
	TRBC->CLASSF  		:= SQJC->CLASSF
	TRBC->PONTUA  		:= SQJC->PONTUA
	TRBC->CHCURSO 		:= SQJC->CHCURSO
	TRBC->INICIO      	:= SQJC->INICIO
	TRBC->FIM		  	:= SQJC->FIM
	TRBC->DISPRO 		:= SQJC->DISPRO
	TRBC->FORING 		:= SQJC->FORING
	TRBC->CMILIT		:= SQJC->CMILIT
	TRBC->SEXO			:= SQJC->SEXO
	TRBC->QTDOPT		:= SQJC->QTDOPT
	MsUnlock()
	DbSelectArea("SQJC")
	Dbskip()
Enddo

IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query das disciplinas  				   	                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT DISTINCT "
cQuery += "	JAE1.JAE_DESC   	DISCIP, "
cQuery += "	JAE1.JAE_DISPAI 	DISPAI, "
cQuery += "	JAE2.JAE_DESC  	DMESTRE "

cQuery += "FROM "
cQuery += "	" + RetSQLName("JAE") + " JAE1, "
cQuery += "	" + RetSQLName("JAE") + " JAE2, "
cQuery += "	" + RetSQLName("JAV") + " JAV, "
cQuery += "	" + RetSQLName("JA2") + " JA2, "
cQuery += "	" + RetSQLName("JA8") + " JA8 "

cQuery += "WHERE "
cQuery += "	    JA2.JA2_FILIAL     = '" + xFilial("JA2") + "'"
cQuery += " AND JAV.JAV_FILIAL     = '" + xFilial("JAV") + "'"
cQuery += " AND JA8.JA8_FILIAL     = '" + xFilial("JA8") + "'"
cQuery += " AND JAE1.JAE_FILIAL    = '" + xFilial("JAE") + "'"

if lOracle
	cQuery += " AND JAE2.JAE_FILIAL(+) = '" + xFilial("JAE") + "'"
else
	cQuery += " AND JAE2.JAE_FILIAL = '" + xFilial("JAE") + "'"
endif

cQuery += " AND JA2.JA2_NUMRA      = '" + cRA + "' "
cQuery += " AND JA8.JA8_CODIGO     = JA2.JA2_PROSEL "
cQuery += " AND JAV.JAV_CODPRO     = JA8.JA8_CODIGO "
cQuery += " AND JAV.JAV_CODFAS     = JA8.JA8_FASE "
cQuery += " AND JAV.JAV_CODCAN     = JA2.JA2_CODINS "
cQuery += " AND JAE1.JAE_CODIGO    = JA8.JA8_CODDIS "

if lOracle
	cQuery += " AND JAE2.JAE_CODIGO(+) = JAE1.JAE_DISPAI "
else
	cQuery += " AND JAE2.JAE_CODIGO =* JAE1.JAE_DISPAI "
endif

cQuery += " AND JA2.D_E_L_E_T_     <> '*' "
cQuery += " AND JA8.D_E_L_E_T_     <> '*' "
cQuery += " AND JAV.D_E_L_E_T_     <> '*' "
cQuery += " AND JAE1.D_E_L_E_T_    <> '*' "

if lOracle
	cQuery += " AND JAE2.D_E_L_E_T_(+) <> '*' "
else
	cQuery += " AND JAE2.D_E_L_E_T_ <> '*' "
endif

cQuery += "ORDER BY "
cQuery += "	DMESTRE, DISPAI, DISCIP"

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQJD", .F., .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerando o arquivo de trabalho das disciplinas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea ("SQJD")
While !Eof()
	DbSelectArea( "TRBD" )
	RecLock( "TRBD",.T. )
	
	TRBD->DISCIP  := SQJD->DISCIP
	TRBD->DISPAI  := SQJD->DISPAI
	TRBD->DMESTRE := SQJD->DMESTRE
	
	MsUnlock()
	DbSelectArea("SQJD")
	Dbskip()
Enddo

IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query dos itens 	   				   	                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRBC->( dbGoTop() )

JCO->( dbSetOrder(1) )
JCH->( dbSetOrder(2) )
JAS->( dbSetOrder(2) )
JAR->( dbSetOrder(1) )
JAE->( dbSetOrder(1) )
JC7->( dbSetOrder(4) )
JBE->( dbSetOrder(1) )

While TRBC->( !eof() )
	
	aPerLets := {}
	
	JAS->( dbSeek(xFilial("JAS")+TRBC->CODCUR) )
	
	while JAS->( !eof() ) .and. JAS->JAS_FILIAL+JAS->JAS_CODCUR == xFilial("JAS")+TRBC->CODCUR
		
		JAR->( dbSeek(xFilial("JAR")+JAS->JAS_CODCUR+JAS->JAS_PERLET+JAS->JAS_HABILI) )
		JAE->( dbSeek(xFilial("JAE")+JAS->JAS_CODDIS) )
		
		if JCO->( dbSeek( xFilial("JCO")+TRBC->NUMRA+JAS->JAS_CODCUR+JAS->JAS_PERLET+JAS->JAS_HABILI+JAS->JAS_CODDIS ) ) .and. !SEC002AE( JCO->JCO_CODINS, JCO->JCO_NUMRA, JCO->JCO_DISCIP, TRBC->CODCUR )
			
			RecLock( "TRBI", TRBI->( !dbSeek(JAS->JAS_CODCUR+"1"+JAS->JAS_PERLET+JAS->JAS_HABILI+JAS->JAS_CODDIS) ) )
			TRBI->CODCUR      	:= JAS->JAS_CODCUR
			TRBI->ANO       	:= if( JAR->JAR_PERIOD == "00", StrZero( Val( JAR->JAR_ANOLET ) - 1, 4 ), JAR->JAR_ANOLET )
			TRBI->PERIOD		:= if( JAR->JAR_PERIOD$"08/09/10/11/12/00", "02", if( JAR->JAR_PERIOD$"03/04/05/06/07", "01", JAR->JAR_PERIOD ))
			TRBI->CODDIS		:= JAS->JAS_CODDIS
			TRBI->DISCIP    	:= JAE->JAE_DESC
			TRBI->TIPODIS    	:= JAE->JAE_TIPO
			TRBI->CH        	:= JAE->JAE_CARGA
			TRBI->TOTCHARG		:= JAE->JAE_CARGA //soma as cargas das disciplina
			TRBI->SEMESTRE   	:= JAS->JAS_PERLET
			TRBI->HABILI     	:= JAS->JAS_HABILI
			TRBI->SITUAC    	:= '8'
			TRBI->INSTIT    	:= JCO->JCO_CODINS
			TRBI->ANOINS    	:= JCO->JCO_ANOINS
			TRBI->MEDIA     	:= JCO->JCO_MEDFIM
			TRBI->MEDCON    	:= JCO->JCO_MEDCON
			TRBI->DESMCO		:= JCO->JCO_DESMCO
			TRBI->CODPROF   	:= ' '
			TRBI->NOMEPROF		:= ' '
			TRBI->CARGOPRF		:= ' '
			TRBI->FALTAS		:= 0
			TRBI->AE			:= 'S'
			TRBI->OPTATIVA		:= JAS->JAS_TIPO
			TRBI->ORDEM			:= '1'
			TRBI->( MsUnlock() )
		elseIF POSICIONE("JAY",1,XFILIAL("JAY")+(Posicione("JAH",1,Xfilial("JAH")+TRBC->CODCUR,"JAH_CURSO"))+(Posicione("JAH",1,Xfilial("JAH")+TRBC->CODCUR,"JAH_VERSAO"))+JAS->JAS_PERLET+JAS->JAS_HABILI+JAS->JAS_CODDIS,"JAY_STATUS") == '1'
			RecLock( "TRBI", .T. )
			TRBI->CODCUR      	:= JAS->JAS_CODCUR
			TRBI->ANO       	:= if( JAR->JAR_PERIOD == "00", StrZero( Val( JAR->JAR_ANOLET ) - 1, 4 ), JAR->JAR_ANOLET )
			TRBI->PERIOD		:= if( JAR->JAR_PERIOD$"08/09/10/11/12/00", "02", if( JAR->JAR_PERIOD$"03/04/05/06/07", "01", JAR->JAR_PERIOD ))
			TRBI->CODDIS		:= JAS->JAS_CODDIS
			TRBI->DISCIP    	:= JAE->JAE_DESC
			TRBI->TIPODIS    	:= JAE->JAE_TIPO
			TRBI->CH        	:= JAE->JAE_CARGA
			TRBI->TOTCHARG		:= JAE->JAE_CARGA //soma as cargas das disciplina
			TRBI->SEMESTRE   	:= JAS->JAS_PERLET
			TRBI->HABILI     	:= JAS->JAS_HABILI
			TRBI->SITUAC    	:= ' '
			TRBI->INSTIT    	:= ' '
			TRBI->ANOINS    	:= ' '
			TRBI->MEDIA     	:= 0
			TRBI->MEDCON    	:= ' '
			TRBI->DESMCO		:= Space(30)
			TRBI->CODPROF   	:= ' '
			TRBI->NOMEPROF		:= ' '
			TRBI->CARGOPRF		:= ' '
			TRBI->FALTAS		:= 0
			TRBI->AE			:= 'N'
			TRBI->OPTATIVA		:= JAS->JAS_TIPO
			TRBI->ORDEM			:= '1'
			TRBI->( MsUnlock() )
			
		endif
		
		aAdd( aPerLets, {JAS->JAS_CODCUR, JAS->JAS_PERLET, JAS->JAS_HABILI, JAS->JAS_CODDIS} )
			
		// Guarda disciplina se for Opcional
		If Posicione("JAY",1,XFILIAL("JAY")+(Posicione("JAH",1,Xfilial("JAH")+TRBC->CODCUR,"JAH_CURSO"))+(Posicione("JAH",1,Xfilial("JAH")+TRBC->CODCUR,"JAH_VERSAO"))+JAS->JAS_PERLET+JAS->JAS_HABILI+JAS->JAS_CODDIS,"JAY_STATUS") == '2'
			AAdd( aDisOpt, JAS->( JAS_CODCUR + "1" + JAS_PERLET + JAS_HABILI + JAS_CODDIS ) )
		EndIf

		JAS->( dbSkip() )
	end
	
	// Verifica as disciplinas já cursadas
	JC7->( dbSeek( xFilial("JC7")+TRBC->NUMRA+TRBC->CODCUR ) )
	while JC7->( !eof() ) .and. JC7->JC7_FILIAL+JC7->JC7_NUMRA+JC7->JC7_CODCUR == xFilial("JC7")+TRBC->NUMRA+TRBC->CODCUR
		
		JAS->( dbSeek( xFilial( "JAS" ) + JC7->( JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_DISCIP ) ) )
		
		aAreaJC7	:= JC7->( GetArea() )
		cDisOri		:= JC7->JC7_DISCIP
		
		// Se o aluno cursou uma equivalente dessa disciplina, posiciona no registro em que foi cursada
		SEC002EQ( JC7->JC7_NUMRA, JC7->JC7_DISCIP, TRBC->CODCUR )
		
		JBE->( dbSeek( xFilial( "JBE" ) + JC7->( JC7_NUMRA  + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA ) ) )
		
		if !empty( JC7->JC7_OUTCUR )
			JAR->( dbSeek( xFilial("JAR")+JC7->JC7_OUTCUR+JC7->JC7_OUTPER + JC7->JC7_OUTHAB ) )
		else
			JAR->( dbSeek( xFilial("JAR")+JC7->JC7_CODCUR+JC7->JC7_PERLET + JC7->JC7_HABILI ) )
		endif
		
		// Guarda disciplina se for Opcional
		if JAS->JAS_TIPO == "2" .And. aScan( aDisOpt, JAS->( JAS_CODCUR + "1" + JAS_PERLET + JAS_HABILI + JAS_CODDIS ) ) == 0
			AAdd( aDisOpt, JAS->( JAS_CODCUR + "1" + JAS_PERLET + JAS_HABILI + JAS_CODDIS ) )
		endif
		
		nPerLet	:= aScan( aPerLets, {|x| x[1]+x[4] == JC7->JC7_CODCUR+cDisOri} )
		lAchou	:= nPerLet > 0 .and. TRBI->( dbSeek(JC7->JC7_CODCUR+"1"+aPerLets[nPerLet,2]+aPerLets[nPerLet,3]+cDisOri) )
		
		if !lAchou .or. Empty(TRBI->SITUAC) .or. JAR->( JAR_ANOLET+JAR_PERIOD ) > TRBI->ANO+TRBI->PERIOD
			
			JAE->( dbSeek(xFilial("JAE")+cDisOri) )
			
			RecLock( "TRBI", !lAchou )
			
			TRBI->CODCUR      	:= JAS->JAS_CODCUR
			
			if JC7->JC7_SITDIS == "001"	// Adaptacao
				TRBI->ANO       	:= if( JAR->JAR_PERIOD$"08/09/10/11/12", StrZero( Val( JAR->JAR_ANOLET ) + 1, 4 ), JAR->JAR_ANOLET )
				TRBI->PERIOD		:= if( JAR->JAR_PERIOD$"08/09/10/11/12/00", "01", if( JAR->JAR_PERIOD$"03/04/05/06/07", "02", JAR->JAR_PERIOD ))
			else
				TRBI->ANO       	:= if( JAR->JAR_PERIOD == "00", StrZero( Val( JAR->JAR_ANOLET ) - 1, 4 ), JAR->JAR_ANOLET )
				TRBI->PERIOD		:= if( JAR->JAR_PERIOD$"08/09/10/11/12/00", "02", if( JAR->JAR_PERIOD$"03/04/05/06/07", "01", JAR->JAR_PERIOD ))
			endif
			
			TRBI->CODDIS		:= cDisOri
			TRBI->DISCIP    	:= JAE->JAE_DESC
			TRBI->TIPODIS    	:= JAE->JAE_TIPO
			TRBI->CH        	:= JAE->JAE_CARGA
			TRBI->TOTCHARG		:= JAE->JAE_CARGA
			if SEC002AE( JC7->JC7_CODINS, JC7->JC7_NUMRA, JC7->JC7_DISCIP, TRBC->CODCUR )
				TRBI->SITUAC	:= if( JC7->JC7_SITUAC == '8', '8', '2' )
				TRBI->AE		:= if( JC7->JC7_SITUAC == '8', 'S', 'N' )
			else
				TRBI->SITUAC    := if( JBE->JBE_SITUAC == '1', ' ', JC7->JC7_SITUAC )
				TRBI->AE		:= if( Posicione('JCO', 1, xFilial("JCO")+JC7->( JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_DISCIP ), "JCO_NUMRA" ) == JC7->JC7_NUMRA, 'S', 'N' )
			endif
			
			TRBI->INSTIT		:= JC7->JC7_CODINS
			TRBI->ANOINS		:= JC7->JC7_ANOINS
			TRBI->DESMCO		:= JC7->JC7_DESMCO
			TRBI->SEMESTRE   	:= if( Empty(TRBI->SEMESTRE), JC7->JC7_PERLET, TRBI->SEMESTRE )
			TRBI->HABILI     	:= if( Empty(TRBI->HABILI), JC7->JC7_HABILI, TRBI->HABILI )
			TRBI->MEDIA     	:= JC7->JC7_MEDFIM
			TRBI->MEDCON    	:= JC7->JC7_MEDCON
			TRBI->CODPROF   	:= JC7->JC7_CODPRF
			TRBI->NOMEPROF		:= ACNomeProf(JC7->JC7_CODPRF)
			TRBI->CARGOPRF		:= if( Empty(ACNomeProf(JC7->JC7_CODPRF, "RA_CODTIT")), " ", Tabela("FF", ACNomeProf(JC7->JC7_CODPRF, "RA_CODTIT"), .F.) )
			TRBI->FALTAS		:= 0
			TRBI->OPTATIVA 		:= JAS->JAS_TIPO
			TRBI->ORDEM			:= '1'
			if Empty(JC7->JC7_OUTCUR)
			If JCH->( dbSeek( xFilial("JCH")+JC7->JC7_NUMRA+JC7->JC7_CODCUR+JC7->JC7_PERLET+JC7->JC7_HABILI+JC7->JC7_TURMA+JC7->JC7_DISCIP ) )
				while JCH->( !eof() ) .and. JCH->(JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DISCIP) == xFilial("JCH")+JC7->JC7_NUMRA+JC7->JC7_CODCUR+JC7->JC7_PERLET+JC7->JC7_HABILI+JC7->JC7_TURMA+JC7->JC7_DISCIP
					TRBI->FALTAS	+= JCH->JCH_QTD
					JCH->( dbSkip() )
				end
				EndIf
			else
				If JCH->( dbSeek( xFilial("JCH")+JC7->JC7_NUMRA+JC7->JC7_OUTCUR+JC7->JC7_OUTPER+JC7->JC7_OUTHAB+JC7->JC7_OUTTUR+JC7->JC7_DISCIP ) )
					while JCH->( !eof() ) .and. JCH->(JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DISCIP) == xFilial("JCH")+JC7->JC7_NUMRA+JC7->JC7_OUTCUR+JC7->JC7_OUTPER+JC7->JC7_OUTHAB+JC7->JC7_OUTTUR+JC7->JC7_DISCIP
						TRBI->FALTAS	+= JCH->JCH_QTD
						JCH->( dbSkip() )
					end
				EndIf
			endif
			
			TRBI->( MsUnlock() )
			
		endif
		
		JC7->( RestArea( aAreaJC7 ) )
		
		JC7->( dbSkip() )
	end
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre as disciplinas que ultrapassam o total de optativas do curso, atualizando sua ordem de impressao no historico ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLenOpt := Len( aDisOpt )
	
	For nInd := 1 To nLenOpt
		
		if nInd > TRBC->QTDOPT
			
			// Altera ordem para impressao no final do historico
			If TRBI->( dbSeek( aDisOpt[ nInd ] ) )
				Reclock( "TRBI", .F. )
				TRBI->ORDEM := '2'
				TRBI->( MsUnlock() )
			Endif
			
		endif
		
	Next nInd
	
	TRBC->( dbSkip() )
end

IncProc()

// Chamada da rotina de impressao do relat¢rio...
Processa({|| PREL0002( lPrint,cARcUR ) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios		                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SQJC")
DbCloseArea()

DbSelectarea("TRBC")
DbCloseArea()

DbSelectarea("TRBI")
DbCloseArea()

DbSelectarea("TRBD")
DbCloseArea()

DbSelectarea("SQJD")
DbCloseArea()

if File( cArqTRBC+GetDbExtension() )
	FErase( cArqTRBC+GetDbExtension() )
endif
if File( cArqTRBC+OrdBagExt() )
	FErase( cArqTRBC+GetDbExtension() )
endif
if File( cArqTRBD+GetDbExtension() )
	FErase( cArqTRBC+GetDbExtension() )
endif
if File( cArqTRBD+OrdBagExt() )
	FErase( cArqTRBC+GetDbExtension() )
endif
if File( cArqTRBI+GetDbExtension() )
	FErase( cArqTRBC+GetDbExtension() )
endif
if File( cArqTRBI+OrdBagExt() )
	FErase( cArqTRBC+GetDbExtension() )
endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ PREL0002 ³ Autor ³Regiane & LeandroSD    ³ Data ³ 03/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do WORD                       			    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Academico              				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³		                                    ³ Data ³  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PREL0002( lImprime, cARcUR )

Local aAss		:= {}
Local aDiscip	:= {}
Local cEqvCon	:= ""
Local cSituac	:= ""
Local cSemestg	:= ""
Local cArqDot	:= ""
Local cPathDot	:= ""
Local cMemo		:= ""
Local cDecret	:= ""
Local cEnder	:= ""
Local cNextSem	:= "" //Proximo Semestre
Local cConceito	:= ""
Local cObs		:= ""
Local aObs      := {}
Local aLeg      := {}
Local nMemCount	:= 0
Local nLoop		:= 0
Local nCntFor	:= 0
Local nCntFo1	:= 0
Local nPos		:= 0
Local hWord		:= 0
Local nx		:= 0
Local cDisPro	:= ""
Local cForIng	:= ""
Local cLegenda	:= ""
Local cMonog	:= SPACE(2)
Local cCargaHor   := ""
Local cCredDiscip := ""
Local aCLeng      := 0

Private cPathEst:= Alltrim(GetMv("MV_DIREST")) // PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Incrementa regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( TRBI->( LastRec() ) + TRBD->( LastRec() ) )

hWord := OLE_CreateLink()
OLE_SetProperty ( hWord, oleWdVisible, .F.)

dbSelectArea("TRBC")
dbGoTop()

If subs(TRBC->NUMRA,1,1)=="6" .or. subs(TRBC->NUMRA,1,1)=="8"
	If ALLTRIM(cARcUR) == '00011' .OR. ALLTRIM(cARcUR) == '00018'
		cArqDot  := "SEC0002B.DOT"
	ELSE
		cArqDot  := "SEC002A.DOT"
	ENDIF
ELSEIf ALLTRIM(cARcUR) == '00011' .OR. ALLTRIM(cARcUR) == '00018'
	cArqDot  := "SEC0002B.DOT"
ELSE
	cArqDot  := "SEC0002.DOT"
Endif



cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD

MontaDir(cPathEst)

If !File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgStop("Atencao... " +cPathDot+"  nao encontrado no Servidor")
	
Elseif hWord == "-1"
	MsgStop("Impossível estabelecer comunicação com o Microsoft Word.")
	
Else
	If File( cPathEst + cArqDot )
		Ferase( cPathEst + cArqDot )
	EndIf
	
	CpyS2T(cPathDot,cPathEst,.T.)
Endif
nVALCH := 0
while TRBC->( !eof() )
	
	IncProc('Montando histórico do aluno '+TRBC->NUMRA)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando novo documento do Word na estacao                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_NewFile( hWord, cPathEst + cArqDot)
	
	OLE_SetProperty( hWord, oleWdVisible, .F. )
	OLE_SetProperty( hWord, oleWdPrintBack, .F. )
	
	cEnder		:=	TRBC->( RTrim(ENDERECO) + ", " + RTrim(NUMEND) + " - " + RTrim(CIDADE) + " - " +RTrim(ESTADO) + " - CEP " + RTrim(CEP) + " - Tel.: " + RTrim(FONE) )
	cDecret		:= ""
	cMemo		:= MSMM(TRBC->DECRET)
	nMemCount	:= MlCount( cMemo ,60 )
	
	If !Empty( nMemCount )
		For nLoop := 1 To nMemCount
			cDecret += MemoLine( cMemo, 60, nLoop )
		Next nLoop
	Else
		cDecret   := cMemo
	EndIf
	
	cDecret   := if( Empty(cDecret), " ", cDecret )
	
	cDisPro := MSMM( TRBC->DISPRO )
	cDisPro := Alltrim( StrTran( cDisPro, Chr(13)+Chr(10), ", " ) )
	if Right( cDisPro, 1 ) == ","
		cDisPro := Left( cDisPro, Len( cDisPro ) - 1 )
	endif
	
	cForIng := if( TRBC->FORING == "4", "CONCURSO VESTIBULAR", "PROCESSO SELETIVO" )
	IF ALLTRIM(TRBC->LOCAL) == '000079'
		OLE_SetDocumentVar(hWord, "cUnidade"  , 'UNIDADE '+ALLTRIM(TRBC->UNIDADE)+' AMÉRICA LATINA')
	ELSE
		OLE_SetDocumentVar(hWord, "cUnidade"  , 'UNIDADE '+ALLTRIM(TRBC->UNIDADE))
	ENDIF
	OLE_SetDocumentVar(hWord, "cEndereco" , cEnder)
	
	OLE_SetDocumentVar(hWord, "cCurso"    , TRBC->CURSO)
	OLE_SetDocumentVar(hWord, "cHabil"    , Posicione( "JDK",1, xFilial("JDK")+TRBC->HABILI, "JDK_DESC"))

	OLE_SetDocumentVar(hWord, "MDECRET"   , cDecret)
	if ALLTRIM(cARcUR) == '00011'
		JBE->( dbSetOrder(3) )
		JBE->(DBSEEK(XFILIAL("JBE")+'5'+TRBC->NUMRA))
		OLE_SetDocumentVar(hWord, "cOBSERV2"  , 'Curso de Pedagogia, Habilitação Administração Escolar do Ensino Fundamental e Médio, nos termos da Alínea "a", do Artigo 8º, da Resolução nº 02, de 12/05/1969, do Egrégio Conselho Federal de Educação. ')
		if !empty(dtoS(JBE->JBE_DTENC))
			OLE_SetDocumentVar(hWord, "cDTINC"    , IIF(TRBC->SEXO == "1",'O ','A ')+'referid'+IIF(TRBC->SEXO == "1",'o ','a ')+'alun'+IIF(TRBC->SEXO == "1",'o ','a ')+'participou do Exame Nacional de Cursos, realizado em '+DTOC(JBE->JBE_DTENC)+'. ')
		endif
	ELSE
		OLE_SetDocumentVar(hWord, "cOBSERV2"  , ' ')
		JBE->( dbSetOrder(3) )
		JBE->(DBSEEK(XFILIAL("JBE")+'5'+TRBC->NUMRA))
		if !empty(dtoS(JBE->JBE_DTENC))
			OLE_SetDocumentVar(hWord, "cDTINC"    , IIF(TRBC->SEXO == "1",'O ','A ')+'referid'+IIF(TRBC->SEXO == "1",'o ','a ')+'alun'+IIF(TRBC->SEXO == "1",'o ','a ')+'participou do Exame Nacional de Cursos, realizado em '+DTOC(JBE->JBE_DTENC)+'. ')
		ELSE
			OLE_SetDocumentVar(hWord, "cDTINC"    , ' ')
		ENDIF
	endif
	OLE_SetDocumentVar(hWord, "cNome"     , TRBC->NOME)
	OLE_SetDocumentVar(hWord, "cNacion"   , substr(Tabela( "34", TRBC->NACION, .F. ),1,1)+lower(substr(ALLTRIM(Tabela( "34", TRBC->NACION, .F. )),2,(len(ALLTRIM(Tabela( "34", TRBC->NACION, .F. ))))-2)+if( TRBC->SEXO == "1", "o", "a" )) )
	OLE_SetDocumentVar(hWord, "cNatura"   , TRBC->NATURA)
	OLE_SetDocumentVar(hWord, "dDtNasc"   , TRBC->DTNASC)
	IF ALLTRIM(TRBC->NACION) == '10' .OR. ALLTRIM(TRBC->NACION) == '20'
		OLE_SetDocumentVar(hWord, "cRG"       , ' R.G. Nº '+TRBC->RG)
	ELSE
		OLE_SetDocumentVar(hWord, "cRG"       , ' R.N.E.: '+TRBC->RG)
	ENDIF
	OLE_SetDocumentVar(hWord, "cEstRG"    , TRBC->ESTRG)
	OLE_SetDocumentVar(hWord, "cEstRA"    , MV_PAR01)
	OLE_SetDocumentVar(hWord, "cTitulo"   , TRBC->TITULO)
	OLE_SetDocumentVar(hWord, "cEntida"   , TRBC->ENTIDA)
	OLE_SetDocumentVar(hWord, "cEntCid"   , TRBC->ENTCID)
	OLE_SetDocumentVar(hWord, "cEntEst"   , TRBC->ENTEST)
	OLE_SetDocumentVar(hWord, "cConclu"   , Alltrim(TRBC->CONCLU))
	OLE_SetDocumentVar(hWord, "cInstit"   , Posicione( "JCL", 1, xFilial("JCL") + TRBC->INSTIT, "JCL_NOME" ) )
	OLE_SetDocumentVar(hWord, "dDataPr"   , TRBC->DATAPR)
	OLE_SetDocumentVar(hWord, "cClassf"   , Alltrim(Str(Val(TRBC->CLASSF),4,0))+"ª")
	OLE_SetDocumentVar(hWord, "nPontua"   , TRBC->PONTUA)
	OLE_SetDocumentVar(hWord, "dData1"    , TRBC->Inicio)
	OLE_SetDocumentVar(hWord, "dData2"    , TRBC->Fim)
	OLE_SetDocumentVar(hWord, "cDisPro"   , Iif( Empty(cDisPro), " ", cDisPro) )
	OLE_SetDocumentVar(hWord, "cForIng"   , cForIng)
	OLE_SetDocumentVar(hWord, "cSexo"     , if( TRBC->SEXO == "1", "M", "F" ) )
	if  TRBC->SEXO == "1"
		OLE_SetDocumentVar(hWord, "cCMilit"   , 'Reservista: '+TRBC->CMILIT)
	else
		OLE_SetDocumentVar(hWord, "cCMilit"   , ' ')
	endif
	if ALLTRIM(cARcUR) == '00018'
		OLE_SetDocumentVar(hWord, "cteso"   , ' ')
		OLE_SetDocumentVar(hWord, "cteso1"   , ' ')
		OLE_SetDocumentVar(hWord, "cColacao"  , ' ')
		OLE_SetDocumentVar(hWord, "cDiploma"  , ' ')
	elseif ALLTRIM(cARcUR) $ '10204/10202/10210/10208/10209/10201/10205/10203/10211/10213/10207/10216/10217/10339/10223/10226/10391/10237/10227/10222/10228/10238/10224/10233/10225/10235/11271/11268/11264'
		OLE_SetDocumentVar(hWord, "cteso"   , 'DATA DE CONCLUSÃO DO CURSO:')
		OLE_SetDocumentVar(hWord, "cteso1"   , ' DATA DE EXPEDIÇÃO DO DIPLOMA:')
		OLE_SetDocumentVar(hWord, "cColacao"  , IIF(!EMPTY(DTOS(Posicione("JBE",3,xFilial("JBE")+'5'+TRBC->NUMRA,"JBE_DCOLAC"))),DTOC(Posicione("JBE",1,xFilial("JBE")+TRBC->NUMRA,"JBE_DCOLAC")),'XXXXXX'))
		OLE_SetDocumentVar(hWord, "cDiploma"  , IIF(!EMPTY(DTOS(Posicione("JBE",3,xFilial("JBE")+'5'+TRBC->NUMRA,"JBE_DATADI"))),DTOC(Posicione("JBE",1,xFilial("JBE")+TRBC->NUMRA,"JBE_DATADI")),'XXXXXX'))
	else
		OLE_SetDocumentVar(hWord, "cteso"   , 'DATA DE COLAÇÃO DE GRAU:')
		OLE_SetDocumentVar(hWord, "cteso1"   , ' DATA DE EXPEDIÇÃO DO DIPLOMA:')
		OLE_SetDocumentVar(hWord, "cColacao"  , IIF(!EMPTY(DTOS(Posicione("JBE",3,xFilial("JBE")+'5'+TRBC->NUMRA,"JBE_DCOLAC"))),DTOC(Posicione("JBE",3,xFilial("JBE")+'5'+TRBC->NUMRA,"JBE_DCOLAC")),'XXXXXX'))
		OLE_SetDocumentVar(hWord, "cDiploma"  , IIF(!EMPTY(DTOS(Posicione("JBE",3,xFilial("JBE")+'5'+TRBC->NUMRA,"JBE_DATADI"))),DTOC(Posicione("JBE",3,xFilial("JBE")+'5'+TRBC->NUMRA,"JBE_DATADI")),'XXXXXX'))
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variaveis para as disciplinas                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("TRBD")
	DbGoTop()
	
	aDiscip := {}
	cDiscip := " "
	
	While !Eof()
		
		cDMestre := TRBD->DMESTRE
		cDiscip  := TRBD->DMESTRE + "("
		
		While !Eof() .AND. TRBD->DMESTRE == cDMestre
			IncProc('Montando histórico do aluno '+TRBC->NUMRA)
			
			If Ascan(aDiscip,{|x| x = TRBD->DISCIP}) = 0
				cDiscip += Alltrim(TRBD->DISCIP)+" "
			EndIf
			dbSkip()
		EndDo
		
		cDiscip += "),"
		
		Aadd (aDiscip,cDMestre)
	EndDo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variaveis para os itens  	                	              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("TRBI")
	dbSeek( TRBC->CODCUR )
	
	aObs    	:= {}
	aLeg    	:= {}
	nCntFor 	:= 0
	cSemestg	:= TRBI->SEMESTRE
	
	JAR->( dbSetOrder( 1 ) )
	JAR->( dbSeek( xFilial( "JAR" ) + TRBC->CODCUR + cSemestg ) )
	
	cConceito   := JAR->JAR_CRIAVA
	While !Eof() .and. TRBI->CODCUR = TRBC->CODCUR
		
		While !Eof() .AND. TRBI->SEMESTRE == cSemestg .and. TRBI->CODCUR = TRBC->CODCUR
			
			IncProc('Montando histórico do aluno '+TRBC->NUMRA)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerando variaveis do documento                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nCntFor += 1
			nCntFo1 := 1
			cObs    := " "
			nVALCH += TRBI->TOTCHARG
			OLE_SetDocumentVar(hWord, "cSemest"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), if( TRBI->SITUAC$" 789A", "-",  TRBI->PERIOD))
			nCntFo1 += 1
			
			OLE_SetDocumentVar(hWord, "cAno"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), if( TRBI->SITUAC$" 789A", "-",  TRBI->ANO))
			nCntFo1 += 1
			
			OLE_SetDocumentVar(hWord, "cDiscip"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(TRBI->DISCIP))
			nCntFo1 += 1
			
			if TRBI->TIPODIS == "003"
				if TRBI->SITUAC $ "28"
					OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), "Cumpriu")
				elseif TRBI->SITUAC$" 1679A"
					OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), "-")
				else
					OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), "Não Cumpriu")
				endif
			else
				if TRBI->SITUAC$" 1679A"
					OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), "-")
				else
					if TRBI->SITUAC == "8"
						if !Empty( TRBI->MEDCON )
							OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(TRBI->MEDCON) )
						else
							OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(Str(TRBI->MEDIA,5,2)) )
						endif
					elseIf cConceito == "2"
						if Empty( TRBI->MEDCON )
							cEqvCon := Posicione("JAR",1,xFilial("JAR")+TRBC->CODCUR+cSemestg,"JAR_EQVCON")
							JDF->( dbSetOrder( 1 ) )
							JDF->( dbSeek(xFilial("JDF")+cEqvCon) )
							While JDF->( ! EoF() .and. JDF_FILIAL+JDF_CODIGO == xFilial("JDF")+cEqvCon )
								If JDF->( (TRBI->MEDIA >= JDF_NOTINI) .and. (TRBI->MEDIA <= JDF_NOTFIN) )
									Exit
								EndIf
								JDF->(dbSkip())
							Enddo
							OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(JDF->JDF_CONCEI) )
						else
							OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(TRBI->MEDCON) )
						endif
					Else
						OLE_SetDocumentVar(hWord, "nMedia"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(Str(TRBI->MEDIA,5,2)) )
					EndIf
				endif
			endif
			nCntFo1 += 1
			
			OLE_SetDocumentVar(hWord, "nCH"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Str(TRBI->CH,3,0))
			nCntFo1 += 1
			aCleng := 0
			If Empty(TRBI->SITUAC) .or. TRBI->SITUAC $ "79A" // Trancado / Desistente
				cSituac := "AC"
			ElseIf TRBI->SITUAC $ "16"	// Cursando / Exame
				cSituac := "C"
			ElseIf	TRBI->SITUAC == "2" // Aprovado
				cSituac := "A"
			ElseIf	TRBI->SITUAC == "3" // Reprovado por Nota
				cSituac := "RN"
			ElseIf	TRBI->SITUAC $ "45" // Reprovado por Falta / Reprovado por nota e falta
				cSituac := "RF"
			ElseIf	TRBI->SITUAC == "8" // Dispensado
				cSituac := If(TRBI->AE <> "S", "D", "AE")
				
				nPos := Ascan(aObs,{|x| x[1] = TRBI->INSTIT})
				If nPos == 0
					cObs := REPLICATE("*",Len(aObs)+1)
					Aadd(aObs,{TRBI->INSTIT,cObs})
				Else
					cObs := aObs[nPos,2]
				EndIf
				If Ascan(aLeg,{|x| x[1] + x[2] == TRBI->INSTIT+Alltrim(TRBI->MEDCON)+' '}) == 0
					nPos := Ascan( aObs, { |x| x[1] == TRBI->INSTIT } )
					If !empty(alltrim(TRBI->INSTIT))
						Aadd(aLeg,{TRBI->INSTIT,Alltrim(TRBI->MEDCON)+' ',aObs[nPos][2],Alltrim(TRBI->DESMCO)+' '})
						if !empty(alltrim(TRBI->INSTIT+''+Alltrim(TRBI->MEDCON)+''+Alltrim(TRBI->DESMCO)))
							aCleng += 1
						endif
					endif
				EndIf
			EndIf
			
			OLE_SetDocumentVar(hWord,"cSituac"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)),cSituac)
			nCntFo1 += 1
			
			OLE_SetDocumentVar(hWord,"cObs"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)),cObs)
			nCntFo1 += 1
			
			OLE_SetDocumentVar(hWord, "nFaltas"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Str(TRBI->FALTAS,4,0))
			nCntFo1 += 1
			
			cNextSem := cSemestg
			
			OLE_SetDocumentVar(hWord, "cNome"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(TRBI->NOMEPROF)+' ')
			OLE_SetDocumentVar(hWord, "cCargo"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(TRBI->CARGOPRF)+' ')
			
			nCntFo1 += 1
			
			OLE_SetDocumentVar(hWord, "cConclu"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), if( !Empty(TRBI->ANOINS), Alltrim(TRBI->ANOINS)+" ", " " ) )
			nCntFo1 += 1
			
			cCargaHor   := AllTrim(Str(TRBI->CH))+' '
			cCredDiscip := Tabela("FY", cCargaHor, .F.)
			
			OLE_SetDocumentVar(hWord, "cCred"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), cCredDiscip)
			nCntFo1 += 1
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Indica se a disciplina deve ser impressa no final do historico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			OLE_SetDocumentVar(hWord,'cOrdem'+AllTrim(Str(nCntFor)), TRBI->ORDEM )
			
			DbSkip()
			
			If !Eof()
				If cNextSem <> TRBI->SEMESTRE
					OLE_SetDocumentVar(hWord,'Adv_CriaLinha' + Alltrim(Str(nCntFor)) ,"S")
					cNextSem := cSemestg
				Else
					OLE_SetDocumentVar(hWord,'Adv_CriaLinha' + Alltrim(Str(nCntFor)) ,"N")
				EndIf
			Else
				OLE_SetDocumentVar(hWord,'Adv_CriaLinha' + Alltrim(Str(nCntFor)) ,"N")
			EndIf
			
		Enddo
		
		cSemestg	:= TRBI->SEMESTRE
		
		JAR->( dbSetOrder( 1 ) )
		JAR->( dbSeek( xFilial( "JAR" ) + TRBC->CODCUR + cSemestg ) )
		
		cConceito	:= JAR->JAR_CRIAVA
		
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nr. de linhas da Tabela a ser utilizada na matriz do Word             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_SetDocumentVar(hWord,'Adv_SEMESTRE',Str(nCntFor))
	OLE_SetDocumentVar(hWord, "cCHCurso"  , ALLTRIM(STR(nVALCH)))
	OLE_SetDocumentVar(hWord, "dDtHoje" , SubStr(DtoC(dDataBase),1,2) + " de " + MesExtenso(Val(SubStr(DtoC(dDataBase),4,2))) + " de " + AllTrim(Str(Year(dDataBase))))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variaveis para observacao 	                	              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cObserv := " "
	
	For nx := 1 to Len(aObs)
		cObserv += aObs[nx,2]
		cObserv += " Disciplina cursada na "+Alltrim(Posicione("JCL",1,xFilial("JCL") + aObs[nx,1],"JCL_NOME")) + " "
	Next
	
	OLE_SetDocumentVar( hWord, "cObserv", cObserv )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variavel para legenda de conceitos de outras instituicoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLegenda := ""
	
	OLE_SetDocumentVar( hWord, "nNumLeg", str(aCleng) )
	
	For nx := 1 to Len(aLeg)
		cLegenda += aLeg[nx,3] + aLeg[nx,2] + " " + aLeg[nx,4] + "; "
		OLE_SetDocumentVar( hWord, "cCodLeg"+Alltrim(Str(nx,2)), aLeg[nx,3] )
		OLE_SetDocumentVar( hWord, "cLeg"+Alltrim(Str(nx,2)), aLeg[nx,2] + " " + aLeg[nx,4] )
	Next
	
	OLE_SetDocumentVar( hWord, "cLegenda", cLegenda )
	
	if Select("ZA4") > 0
		ZA4->( dbSetOrder(1) )
		ZA2->( dbSetOrder(2) )
		ZA4->( dbSeek( xFilial("ZA4")+ALLTRIM(TRBC->NUMRA)) )
		WHILE ALLTRIM(TRBC->NUMRA) == ALLTRIM(ZA4->ZA4_NUMRA)
			IF ZA2->( dbseek( xFilial("ZA2")+alltrim(ZA4->ZA4_CODATV)+"000000" ) )
				cMonog := ALLTRIM(ZA4->ZA4_TITULO)
			endif
			ZA4->(DBSKIP())
		ENDDO
		nL := 1
		if  !empty(alltrim(cMonog))
			OLE_SetDocumentVar( hWord, "cMonog", "MONOGRAFIA: "+cMonog )
		else
			OLE_SetDocumentVar( hWord, "cMonog", " ")
		endif
	endif
	OLE_SetDocumentVar(hWord, "CdasTA"			, "São Paulo, " + SubStr(DtoC(dDataBase),1,2) + " de " + MesExtenso(Val(SubStr(DtoC(dDataBase),4,2))) + " de " + AllTrim(Str(Year(dDataBase)))+'.')
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando variaveis para assinaturas 	                	              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAss := U_ACRetAss( cPRO )
	
	OLE_SetDocumentVar( hWord, "cAss1"  , aAss[1] )
	OLE_SetDocumentVar( hWord, "cCargo1", aAss[2] )
	
	aAss := U_ACRetAss( cSEC )
	
	OLE_SetDocumentVar( hWord, "cAss2"  , aAss[1] )
	OLE_SetDocumentVar( hWord, "cCargo2", aAss[2] )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa macro do Word                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_ExecuteMacro(hWord,"SEMESTRE")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizando variaveis do documento                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_UpdateFields( hWord )
	
	if lImprime
		OLE_PrintFile( hWord )
		Sleep(2000)	// Espera 2 segundos pra imprimir.
		OLE_CloseFile( hWord )
	endif
	
	TRBC->( dbSkip() )
End

if lImprime
	OLE_CloseLink( hWord )
else
	OLE_SetProperty( hWord, oleWdVisible, .T. )
	OLE_SetProperty( hWord, oleWdWindowState, "MAX" )
endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC002AE  ºAutor  ³Rafael Rodrigues    º Data ³  14/Mai/03  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o aluno cursou esta disciplina na mesma institu-º±±
±±º          ³icao e se foi no mesmo curso padrao do curso no JCO.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SEC0002                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SEC002AE( cIns, cNumRA, cDiscip, cCodCur )
Local lRet	:= Alltrim(cIns) == Alltrim(cCodIns)
Local aArea	:= JC7->( GetArea() )

if lRet
	lRet := .F.
	JC7->( dbSetOrder(3) )
	JC7->( dbSeek( xFilial("JC7")+cNumRA+cDiscip ) )
	while JC7->( JC7_FILIAL+JC7_NUMRA+JC7_DISCIP ) == xFilial("JC7")+cNumRA+cDiscip .and. JC7->( !eof() )
		if JC7->JC7_SITUAC $ "28" .and. AcaCurPad(JC7->JC7_CODCUR) == AcaCurPad(cCodCur)
			lRet := .T.
			exit
		endif
		JC7->( dbSkip() )
	end
	
	JC7->( RestArea(aArea) )
	
endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC002EQ  ºAutor  ³Rafael Rodrigues    º Data ³  09/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o aluno cursou alguma equivalencia da disciplinaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SEC002EQ( cNumRA, cCodDis, cCodCur )
Local lRet		:= .F.
Local cQuery	:= ""
Local aDiscip   := { cCodDis }
Local aDisOri	:= { cCodDis }
Local cDiscip	:= "'"+cCodDis+"'"
Local cDisOri	:= "'"+cCodDis+"'"
Local i

while !lRet .and. !Empty( aDisOri )
	cQuery := "Select Distinct JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_SITUAC "
	cQuery += "From "
	cQuery += RetSQLName("JC7")+" JC7 "
	cQuery += "Where "
	cQuery += "    JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ <> '*' "
	cQuery += "and JC7_NUMRA  = '"+cNumRA+"' "
	cQuery += "and JC7_CODCUR = '"+cCodCur+"' "
	cQuery += "and JC7_DISORI in ("+cDisOri+") "
	cQuery += "and JC7_DISCIP not in ("+cDiscip+") "
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBEQV", .F., .F.)
	
	TRBEQV->( dbGoTop() )
	aDisOri := {}
	while !lRet .and. TRBEQV->( !eof() )
		if TRBEQV->JC7_SITUAC $ "28"
			lRet := .T.
			JC7->( dbSetOrder(1) )
			JC7->( dbSeek( xFilial("JC7")+cNumRA+cCodCur+TRBEQV->JC7_PERLET+TRBEQV->JC7_HABILI+TRBEQV->JC7_TURMA+TRBEQV->JC7_DISCIP ) )
		endif
		
		aAdd( aDisOri, TRBEQV->JC7_DISCIP )
		if aScan( aDiscip, TRBEQV->JC7_DISCIP ) == 0
			aAdd( aDiscip, TRBEQV->JC7_DISCIP )
		endif
		TRBEQV->( dbSkip() )
	end
	
	TRBEQV->( dbCloseArea() )
	
	cDisOri := ""
	for i := 1 to len( aDisOri )
		cDisOri += "'"+aDisOri[i]+"', "
	next i
	cDisOri := Left( cDisOri,len(cDisOri)-2 )
	
	cDiscip := ""
	for i := 1 to len( aDiscip )
		cDiscip += "'"+aDiscip[i]+"', "
	next i
	cDiscip := Left( cDiscip,len(cDiscip)-2 )
end

Return lRet
