#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

#Include "TOPCONN.CH"
#Include "rwmake.CH"
#Include "MSOLE.CH"
#Include "SEC0037.CH"

Static cCodIns

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SECR037	³ Autor ³ Leandro Duarte        ³ Data ³ 07/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emite o historico escolar						       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Academico 							          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SECR037()
Local oDlgPrint,oBtnImp,oBtnSair,oBtnPar,oMemo,oGroup
Local cPerg     := "SEC002"
Local cObjetivo := ""
Local lOpc      := .f.
Local cFiltro   := ""

//Funcoes requeridas para as funcoes de impressao
Private nLastKey  := 0
Private cArqTRBC  := ""
Private cArqTRBI  := ""
Private cOrder    := ""

Private cPRO := Space(6)
Private cSEC := Space(6)
Private cVar := Space(500)

if cCodIns == nil
	cCodIns := GetMV("MV_ACCODIN")
endif

cObjetivo := STR0001
cObjetivo += STR0002

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao da tela												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDlgPrint := MSDialog():New( 10,10,250,350,STR0003,,,,,,,,,.T. )

oGroup    := TGroup():New( 3,4,115,166,"",,,,.T.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos Botoes											    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oBtnImp   := SButton():New( 15, 125, 1, {|| oDlgPrint:End(),lOpc := .T.},,.T. )
oBtnSair  := SButton():New( 35, 125, 2, {|| oDlgPrint:End()},,.T. )
oBtnPar   := SButton():New( 55, 125, 5, {|| Pergunte(cPerg,.T.)},,.T. )

oBtnImp :cToolTip  := STR0004
oBtnSair:cToolTip  := STR0005
oBtnPar :cToolTip  := STR0006

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
		Processa({||ASSHSTCOL() })
	ELSE
		Processa({||ASSHSTCOL() })
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
	cFiltro 				+= "	AND JAH.D_E_L_E_T_<>'*' "
	cFiltro 				+= "	AND JAF.D_E_L_E_T_<>'*' "
	cFiltro 				+= "	AND JBE.D_E_L_E_T_<>'*'	"
	cFiltro 				+= "ORDER BY "
	cFiltro 				+= "	NUMRA, CODCUR "
	
	cFiltro 				:= ChangeQuery(cFiltro)
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cFiltro),"TMP", .F., .T.)
	TMP->( dbGotop() )
	while TMP->( !eof() )
		cARcUR	:=	TMP->ccURLO
		Processa( { || ACATRB0037(.T.,TMP->NUMRA,TMP->CODCUR,TMP->DESCCUR, mv_par11 == 2,cARcUR) } )
		TMP->( dbSkip() )
	end
	TMP->( dbCloseArea() )
	
EndIf
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SEC0037	³ Autor ³ Leandro Duarte        ³ Data ³ 07/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emite o historico escolar						       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Academico 							          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0037()
Local nLastKey	:= 0

Private cPRO						:= Space(6)
Private cSEC						:= Space(6)
Private cvAR						:= Space(500)

//Chamada da rotina de escolha de assinaturas....
Processa({||ASSHSTCOL() })

If nLastKey == 27
	Set Filter To
	Return
EndIf

// Chamada da rotina de armazenamento de dados...
Processa({||ACATRB0037() })

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ACATRB0037³ Autor ³ Leandro Duarte        ³ Data ³ 07/12/06 ³±±
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
STATIC FUNCTION ACATRB0037(lViaMenu,cRa,cCodCur,cDescCur,lPrint,cARcUR)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local aDados  		:=	{}
Local aRet			:=	{}
Local aCabec		:=	{}
Local cNumReq
Local nVolt			:= 0
Local cPer			:= ''
Local cTurma		:= cAnoLet		:=	cPeriod		:=	''
Local aSx3Box    	:= RetSx3Box( Posicione("SX3", 2, "JC7_SITUAC", "X3CBox()" ),,, 1 )
Local lPai			:= .F.
Local aMatr			:= {}
Local cHabili		:=	""
Local cTurma		:=	""
Local cAnoLet		:=	""
Local cPeriod		:=	""
Local cPerLet		:=	""
Local cDiscip		:=	""
Local cDisDesc		:=	""
Local nMedia		:=	0
Local cIdenti		:=	""
Local nCarga		:=	0
Local i				:=	0
lViaMenu := if( lViaMenu == NIL, .F., lViaMenu )
lPrint   := if( lPrint == NIL, .F., lPrint )

ProcRegua( 4 )

dbselectarea("JAH")

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³inicialização de Query para buscar dados principais do aluno      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery	:= 	"	SELECT DISTINCT A.JA2_NUMRA, A.JA2_NOME, A.JA2_RG, A.JA2_DTNASC, I.X5_DESCRI AS JA2_NACION, A.JA2_NASCMN, A.JA2_EST, C.JAH_GRUPO, 		"
cQuery	+= 	"		F.JAR_PERLET, F.JAR_HABILI, D.JAF_DESMEC, E.JC7_DISCIP, E.JC7_MEDFIM, G.JAE_DESC, E.JC7_SITUAC, H.JAY_TIPCOM, H.JAY_STATUS,  		"
cQuery	+= 	"		H.JAY_TIPO, G.JAE_CARGA, D.JAF_COD, C.JAH_UNIDAD, G.JAE_DISPAI, G.JAE_DISMES		"
cQuery	+= 	"	  FROM "+retsqlname("JA2")+" A, "+retsqlname("JBE")+" B, "+retsqlname("JAH")+" C, "+retsqlname("JAF")+" D, "+retsqlname("JC7")+" E, "+retsqlname("JAR")+" F, "+retsqlname("JAE")+" G, "+retsqlname("JAY")+" H, "+retsqlname("SX5")+" I "
cQuery	+= 	"	 WHERE A.JA2_FILIAL = '"+xFilial("JA2")+"' 		"
cQuery	+= 	"	   AND B.JBE_FILIAL = '"+xFilial("JBE")+"' 		"
cQuery	+= 	"	   AND C.JAH_FILIAL = '"+xFilial("JAH")+"' 		"
cQuery	+= 	"	   AND D.JAF_FILIAL = '"+xFilial("JAF")+"' 		"
cQuery	+= 	"	   AND E.JC7_FILIAL = '"+xFilial("JC7")+"' 		"
cQuery	+= 	"	   AND F.JAR_FILIAL = '"+xFilial("JAR")+"' 		"
cQuery	+= 	"	   AND G.JAE_FILIAL = '"+xFilial("JAE")+"' 		"
cQuery	+= 	"	   AND H.JAY_FILIAL = '"+xFilial("JAY")+"' 		"
cQuery	+= 	"	   AND I.X5_FILIAL = '"+xFilial("SX5")+"' 		"
cQuery	+= 	"	   AND A.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND B.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND C.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND D.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND E.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND F.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND G.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND H.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND I.D_E_L_E_T_ <> '*' 		"
cQuery	+= 	"	   AND A.JA2_NUMRA = B.JBE_NUMRA 		"
cQuery	+= 	"	   AND B.JBE_CODCUR = C.JAH_CODIGO 		"
cQuery	+= 	"	   AND C.JAH_CURSO = D.JAF_COD 		"
cQuery	+= 	"	   AND E.JC7_NUMRA = A.JA2_NUMRA 		"
cQuery	+= 	"	   AND E.JC7_CODCUR = B.JBE_CODCUR 		"
cQuery	+= 	"	   AND E.JC7_PERLET = B.JBE_PERLET 		"
cQuery	+= 	"	   AND E.JC7_HABILI = B.JBE_HABILI 		"
cQuery	+= 	"	   AND E.JC7_TURMA = B.JBE_TURMA 		"
cQuery	+= 	"	   AND B.JBE_CODCUR = F.JAR_CODCUR 		"
cQuery	+= 	"	   AND B.JBE_PERLET = F.JAR_PERLET 		"
cQuery	+= 	"	   AND B.JBE_HABILI = F.JAR_HABILI 		"
cQuery	+= 	"	   AND E.JC7_DISCIP = G.JAE_CODIGO 		"
cQuery	+= 	"	   AND C.JAH_CURSO  = H.JAY_CURSO 		"
cQuery	+= 	"	   AND F.JAR_PERLET = H.JAY_PERLET 		"
cQuery	+= 	"	   AND F.JAR_HABILI = H.JAY_HABILI 		"
cQuery	+= 	"	   AND E.JC7_DISCIP = H.JAY_CODDIS		"
cQuery	+= 	"	   AND I.X5_TABELA = '34'	"
cQuery	+= 	"	   AND I.X5_CHAVE = A.JA2_NACION		"
cQuery	+= 	"	   AND A.JA2_NUMRA = '"+cRa+"' "
cQuery	+= 	"	   AND B.JBE_CODCUR = '"+cCodCur+"' "
cQuery	+= 	" ORDER BY  F.JAR_PERLET, G.JAE_DISPAI, H.JAY_TIPCOM		"
cQuery	:= ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQLTRB", .F., .T.)

aStruc := SQLTRB->(dbstruct())
AADD(aStruc,{'JBO_TURMA',tamsx3("JBO_TURMA")[3],tamsx3("JBO_TURMA")[1],tamsx3("JBO_TURMA")[2]})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³cabeçalho da matriz caso for adicionar um indice da matrix aMatriz adicionar no cabeçalho                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCabec,'JA2_NUMRA')
AADD(aCabec,'JA2_NOME')
AADD(aCabec,'JA2_RG')
AADD(aCabec,'JA2_DTNASC')
AADD(aCabec,'JA2_NACION')
AADD(aCabec,'JA2_NASCMN')
AADD(aCabec,'JA2_EST')
AADD(aCabec,'JAH_GRUPO')
AADD(aCabec,'JAR_PERLET')
AADD(aCabec,'JAR_HABILI')
AADD(aCabec,'JAF_DESMEC')
AADD(aCabec,'JC7_DISCIP')
AADD(aCabec,'JC7_MEDFIM')
AADD(aCabec,'JAE_DESC')
AADD(aCabec,'JC7_SITUAC')
AADD(aCabec,'JAY_TIPCOM')
AADD(aCabec,'JAY_STATUS')
AADD(aCabec,'JAY_TIPO')
AADD(aCabec,'JAE_CARGA')
AADD(aCabec,'JAF_COD')
AADD(aCabec,'JAH_UNIDAD')
AADD(aCabec,'JAE_DISPAI')
AADD(aCabec,'JAE_DISMES')
AADD(aCabec,'JBO_TURMA')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta a Matriz para o tipo de ensino³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aDados,{'cTpEnsino',ALLTRIM(tabela('FC',SQLTRB->JAH_GRUPO,.t.))})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta a Matriz para o Reconhecimento do curso |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aDados,{'cReconh', ALLTRIM(MSMM(ACDecret( SQLTRB->JAF_COD, dDataBase, SQLTRB->JAH_UNIDAD )))})
aadd(aDados,{'cAutoriz', ALLTRIM(MSMM(posicione("JAF",1,XfILIAL("JAF")+SQLTRB->JAF_COD,"JAF_MEMO1")))})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop para alimentar a Matriz para o impressão do Word |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

while SQLTRB->(!eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Alimenta as variaveis para buscar a media da Disciplina Pai  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHabili		:=	SQLTRB->JAR_HABILI
	cTurma		:=	posicione("JBE",1,xFilial("JBE")+cRa+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JBE_TURMA")
	cAnoLet		:=	posicione("JAR",1,xFilial("JAR")+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JAR_ANOLET")
	cPeriod		:=	posicione("JAR",1,xFilial("JAR")+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JAR_PERIOD")
	cPerLet		:=	SQLTRB->JAR_PERLET
	cCodCur		:=	posicione("JBE",1,xFilial("JBE")+cRa+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JBE_CODCUR")
	cDiscip		:=	SQLTRB->JC7_DISCIP
	cDisDesc	:=	SQLTRB->JAE_DESC
	nMedia		:=	SQLTRB->JC7_MEDFIM
	cIdenti		:=	SQLTRB->JAE_DISMES
	nCarga		:=	SQLTRB->JAE_CARGA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Função padrão de calcular a media da disciplina Pai  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !EMPTY(posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_DISPAI"))
		cDisPaic	:=	posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_DISPAI")
		cDisDesc	:=	posicione("JAE",1,xFilial("JAE")+cDisPaic,"JAE_DESC")
		IF aScan(aMatr,{|loc| loc[22]==cDisPaic .AND. loc[9]==cPerLet })!=0
			nLoc		:= aScan(aMatr,{|loc| loc[22]==cDisPaic .AND. loc[9]==cPerLet })
			cDiscip		:=	cDisPaic
			nMedia		:=	val(ACMedPai( cRa, cCodCur, cPerLet, cHabili, cTurma, cDiscip, cAnoLet, cPeriod ))
			nCarga		:=	posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_CARGA")
			cDisDesc	:=	posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_DESC")
			aMatr[nLoc][12]	:=	cDiscip
			aMatr[nLoc][13]	:=	nMedia
			aMatr[nLoc][19]	:=	nCarga
			aMatr[nLoc][14]	:=	cDisDesc
		else
			AADD(aMatr,{cRa,; 			// 01
			SQLTRB->JA2_NOME,;  		// 02
			SQLTRB->JA2_RG,;  			// 03
			SQLTRB->JA2_DTNASC,;  		// 04
			SQLTRB->JA2_NACION,;  		// 05
			SQLTRB->JA2_NASCMN,;  		// 06
			SQLTRB->JA2_EST,;  			// 07
			SQLTRB->JAH_GRUPO,; 		// 08
			cPerLet,;  					// 09
			cHabili,;  					// 10
			SQLTRB->JAF_DESMEC,;  		// 11
			cDiscip,;  					// 12
			nMedia,;  					// 13
			cDisDesc,;  				// 14
			SQLTRB->JC7_SITUAC,;  		// 15
			SQLTRB->JAY_TIPCOM,;  		// 16
			SQLTRB->JAY_STATUS,; 		// 17
			SQLTRB->JAY_TIPO,;  		// 18
			nCarga,;  					// 19
			acacurpad(cCodCur),;  		// 20
			SQLTRB->JAH_UNIDAD,;  		// 21
			SQLTRB->JAE_DISPAI,;  		// 22
			cIdenti,; 					// 23
			cTurma}) 					// 24
		endif
	else
		AADD(aMatr,{cRa,; 			// 01
		SQLTRB->JA2_NOME,;  		// 02
		SQLTRB->JA2_RG,;  			// 03
		SQLTRB->JA2_DTNASC,;  		// 04
		SQLTRB->JA2_NACION,;  		// 05
		SQLTRB->JA2_NASCMN,;  		// 06
		SQLTRB->JA2_EST,;  			// 07
		SQLTRB->JAH_GRUPO,; 		// 08
		cPerLet,;  					// 09
		cHabili,;  					// 10
		SQLTRB->JAF_DESMEC,;  		// 11
		cDiscip,;  					// 12
		nMedia,;  					// 13
		cDisDesc,;  				// 14
		SQLTRB->JC7_SITUAC,;  		// 15
		SQLTRB->JAY_TIPCOM,;  		// 16
		SQLTRB->JAY_STATUS,; 		// 17
		SQLTRB->JAY_TIPO,;  		// 18
		nCarga,;  					// 19
		acacurpad(cCodCur),;  		// 20
		SQLTRB->JAH_UNIDAD,;  		// 21
		SQLTRB->JAE_DISPAI,;  		// 22
		cIdenti,; 					// 23
		cTurma}) 					// 24
	endif
	SQLTRB->(dbskip())
	nMedia		:= 0
end
SQLTRB->(DBCLOSEAREA())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³outra query para identificar a analise de grade curricular³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery	:= 	"	SELECT DISTINCT E.JA2_NUMRA, E.JA2_NOME, E.JA2_RG, E.JA2_DTNASC, J.X5_DESCRI AS JA2_NACION, E.JA2_NASCMN, E.JA2_EST, 	"
cQuery	+= 	"			F.JAH_GRUPO, B.JCT_PERLET AS JAR_PERLET, A.JCS_HABILI AS JAR_HABILI, G.JAF_DESMEC AS JAF_DESMEC, B.JCT_DISCIP AS JC7_DISCIP,  	"
cQuery	+= 	"			B.JCT_MEDFIM AS JC7_MEDFIM, H.JAE_DESC, B.JCT_SITUAC AS JC7_SITUAC, H.JAE_CARGA, G.JAF_COD, F.JAH_UNIDAD, H.JAE_DISPAI, H.JAE_DISMES, 	"
cQuery	+= 	"			I.JAY_TIPCOM, I.JAY_STATUS, I.JAY_TIPO 	"
cQuery	+= 	"	  FROM "+RETSQLNAME("JCS")+" A, "+RETSQLNAME("JCT")+" B, "+RETSQLNAME("JBH")+" C, "+RETSQLNAME("JBE")+" D, "+RETSQLNAME("JA2")+" E, "+RETSQLNAME("JAH")+" F, "+RETSQLNAME("JAF")+" G, "+RETSQLNAME("JAE")+" H, "+RETSQLNAME("JAY")+" I, "+RETSQLNAME("SX5")+" J "
cQuery	+= 	"	 WHERE A.JCS_FILIAL = '"+xFilial("JCS")+"' 		"
cQuery	+= 	"	   AND B.JCT_FILIAL = '"+xFilial("JCT")+"' 		"
cQuery	+= 	"	   AND C.JBH_FILIAL = '"+xFilial("JBH")+"' 		"
cQuery	+= 	"	   AND D.JBE_FILIAL = '"+xFilial("JBE")+"' 		"
cQuery	+= 	"	   AND E.JA2_FILIAL = '"+xFilial("JA2")+"' 		"
cQuery	+= 	"	   AND F.JAH_FILIAL = '"+xFilial("JAH")+"' 		"
cQuery	+= 	"	   AND G.JAF_FILIAL = '"+xFilial("JAF")+"' 		"
cQuery	+= 	"	   AND H.JAE_FILIAL = '"+xFilial("JAE")+"' 		"
cQuery	+= 	"	   AND I.JAY_FILIAL = '"+xFilial("JAY")+"' 		"
cQuery	+= 	"	   AND J.X5_FILIAL = '"+xFilial("SX5")+"' 		"
cQuery	+= 	"	   AND I.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND H.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND G.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND F.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND E.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND A.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND B.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND C.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND D.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND J.D_E_L_E_T_ <> '*' 	"
cQuery	+= 	"	   AND C.JBH_NUM = A.JCS_NUMREQ 	"
cQuery	+= 	"	   AND A.JCS_NUMREQ = JCT_NUMREQ 	"
cQuery	+= 	"	   AND D.JBE_NUMREQ = A.JCS_NUMREQ 	"
cQuery	+= 	"	   AND D.JBE_PERLET = B.JCT_PERLET 	"
cQuery	+= 	"	   AND D.JBE_CODCUR = A.JCS_CURSO 	"
cQuery	+= 	"	   AND D.JBE_TURMA = A.JCS_TURMA 	"
cQuery	+= 	"	   AND D.JBE_HABILI = A.JCS_HABILI 	"
cQuery	+= 	"	   AND D.JBE_NUMRA = E.JA2_NUMRA 	"
cQuery	+= 	"	   AND A.JCS_CURSO = F.JAH_CODIGO 	"
cQuery	+= 	"	   AND F.JAH_CURSO = G.JAF_COD 	"
cQuery	+= 	"	   AND F.JAH_VERSAO = G.JAF_VERSAO 	"
cQuery	+= 	"	   AND H.JAE_CODIGO = B.JCT_DISCIP 	"
cQuery	+= 	"	   AND I.JAY_CURSO = G.JAF_COD 	"
cQuery	+= 	"	   AND I.JAY_PERLET = B.JCT_PERLET 	"
cQuery	+= 	"	   AND I.JAY_HABILI = A.JCS_HABILI 	"
cQuery	+= 	"	   AND J.X5_TABELA = '34'	"
cQuery	+= 	"	   AND J.X5_CHAVE = E.JA2_NACION 	"
cQuery	+= 	"	   AND E.JA2_NUMRA = '"+cRa+"' "
cQuery	+= 	"	   AND D.JBE_CODCUR = '"+cCodCur+"' "
cQuery	+= 	" ORDER BY  JAR_PERLET, JAE_DISPAI, JAY_TIPCOM		"
cQuery	:= ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQLTRB", .F., .T.)

aStruc := SQLTRB->(dbstruct())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop para alimentar a Matriz para o impressão do Word |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SELECT("SQLTRB")> 0
	while SQLTRB->(!eof())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alimenta as variaveis para buscar a media da Disciplina Pai  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cHabili		:=	SQLTRB->JAR_HABILI
		cTurma		:=	posicione("JBE",1,xFilial("JBE")+cRa+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JBE_TURMA")
		cAnoLet		:=	posicione("JAR",1,xFilial("JAR")+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JAR_ANOLET")
		cPeriod		:=	posicione("JAR",1,xFilial("JAR")+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JAR_PERIOD")
		cPerLet		:=	SQLTRB->JAR_PERLET
		cCodCur		:=	posicione("JBE",1,xFilial("JBE")+cRa+cCodCur+SQLTRB->JAR_PERLET+SQLTRB->JAR_HABILI,"JBE_CODCUR")
		cDiscip		:=	SQLTRB->JC7_DISCIP
		cDisDesc	:=	SQLTRB->JAE_DESC
		nMedia		:=	SQLTRB->JC7_MEDFIM
		cIdenti		:=	SQLTRB->JAE_DISMES
		nCarga		:=	SQLTRB->JAE_CARGA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Função padrão de calcular a media da disciplina Pai  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !EMPTY(posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_DISPAI"))
			cDisPaic	:=	posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_DISPAI")
			cDisDesc	:=	posicione("JAE",1,xFilial("JAE")+cDisPaic,"JAE_DESC")
			IF aScan(aMatr,{|loc| loc[22]==cDisPaic .AND. loc[9]==cPerLet })!=0
				nLoc		:= aScan(aMatr,{|loc| loc[22]==cDisPaic .AND. loc[9]==cPerLet })
				cDiscip		:=	cDisPaic
				nMedia		:=	val(ACMedPai( cRa, cCodCur, cPerLet, cHabili, cTurma, cDiscip, cAnoLet, cPeriod ))
				nCarga		:=	posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_CARGA")
				cDisDesc	:=	posicione("JAE",1,xFilial("JAE")+cDiscip,"JAE_DESC")
				aMatr[nLoc][12]	:=	cDiscip
				aMatr[nLoc][13]	:=	nMedia
				aMatr[nLoc][19]	:=	nCarga
				aMatr[nLoc][14]	:=	cDisDesc
			else
				AADD(aMatr,{cRa,; 			// 01
				SQLTRB->JA2_NOME,;  		// 02
				SQLTRB->JA2_RG,;  			// 03
				SQLTRB->JA2_DTNASC,;  		// 04
				SQLTRB->JA2_NACION,;  		// 05
				SQLTRB->JA2_NASCMN,;  		// 06
				SQLTRB->JA2_EST,;  			// 07
				SQLTRB->JAH_GRUPO,; 		// 08
				cPerLet,;  					// 09
				cHabili,;  					// 10
				SQLTRB->JAF_DESMEC,;  		// 11
				cDiscip,;  					// 12
				nMedia,;  					// 13
				cDisDesc,;  				// 14
				SQLTRB->JC7_SITUAC,;  		// 15
				SQLTRB->JAY_TIPCOM,;  		// 16
				SQLTRB->JAY_STATUS,; 		// 17
				SQLTRB->JAY_TIPO,;  		// 18
				nCarga,;  					// 19
				acacurpad(cCodCur),;  		// 20
				SQLTRB->JAH_UNIDAD,;  		// 21
				SQLTRB->JAE_DISPAI,;  		// 22
				cIdenti,; 					// 23
				cTurma}) 					// 24
			endif
		else
			AADD(aMatr,{cRa,; 			// 01
			SQLTRB->JA2_NOME,;  		// 02
			SQLTRB->JA2_RG,;  			// 03
			SQLTRB->JA2_DTNASC,;  		// 04
			SQLTRB->JA2_NACION,;  		// 05
			SQLTRB->JA2_NASCMN,;  		// 06
			SQLTRB->JA2_EST,;  			// 07
			SQLTRB->JAH_GRUPO,; 		// 08
			cPerLet,;  					// 09
			cHabili,;  					// 10
			SQLTRB->JAF_DESMEC,;  		// 11
			cDiscip,;  					// 12
			nMedia,;  					// 13
			cDisDesc,;  				// 14
			SQLTRB->JC7_SITUAC,;  		// 15
			SQLTRB->JAY_TIPCOM,;  		// 16
			SQLTRB->JAY_STATUS,; 		// 17
			SQLTRB->JAY_TIPO,;  		// 18
			nCarga,;  					// 19
			acacurpad(cCodCur),;  		// 20
			SQLTRB->JAH_UNIDAD,;  		// 21
			SQLTRB->JAE_DISPAI,;  		// 22
			cIdenti,; 					// 23
			cTurma}) 					// 24
		endif
		SQLTRB->(dbskip())
		nMedia		:= 0
	end
	SQLTRB->(DBCLOSEAREA())
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ordenar a matriz de dados para apresentar no documento        ³
//³não alterar essa ordem, pois a mesma foi feita para executar  ³
//³a macro correta caso precise deve alterar a macro no word para³
//³poder executar corretamente                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aMatr := aSort( aMatr,,, {|x,y|  x[23]+x[9] < Y[23]+y[9]  } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³executa a gravação da matriz para executar a macro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
for i := 1 to len(aMatr)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava a Quantidade de Voltas que deu na variavel      |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVolt++
	aeval(aStruc,{ |Extr| aadd(aDados,{Extr[1]+alltrim(str(nVolt)),aMatr[i][aScan(aCabec,Extr[1])]})})
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Joga na matriz a quantidade de voltas para tratamento de macro do Word |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aDados,{'qtd',nVolt})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz um Seek para definição de quantidades de periodos letivos existentes no curso Vigente |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

JAR->(DBSETORDER(1))
JAR->(DBSEEK(XFILIAL("JAR")+cCodCur))
while cCodCur == JAR->JAR_CODCUR
	cPer	:= JAR->JAR_PERLET
	JAR->(DBSKIP())
END
aadd(aDados,{'serie',cPer})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para verificar se existe disciplinas dispensadas ou que foram cursadas em outra IES |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery	:=  "	SELECT *		"
cQuery	+= 	"	  FROM "+retsqlname("JD1")+" A, "+retsqlname("JCL")+" B		"
cQuery	+= 	"	 WHERE A.JD1_FILIAL = '"+xFilial("JD1")+"'		"
cQuery	+= 	"	   AND B.JCL_FILIAL = '"+xFilial("JCL")+"'		"
cQuery	+= 	"	   AND A.D_E_L_E_T_ <> '*'		"
cQuery	+= 	"	   AND B.D_E_L_E_T_ <> '*'		"
cQuery	+= 	"	   AND B.JCL_CODIGO = JD1_CODINS		"
cQuery	+= 	"	   AND A.JD1_NUMRA = '"+cRa+"' 		"
cQuery	+= 	" ORDER BY A.JD1_ITEM "
cQuery	:= ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)
aStruc := TRB1->(dbstruct())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop para alimentar a Matriz para o impressão do Word |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

while TRB1->(!eof())
	
	nVolt++
	aeval(aStruc,{|y| aadd(aDados,{y[1]+alltrim(str(nVolt)),IIF(y[1]=="JD1_SITUAC",AllTrim( aSx3Box[ Ascan( aSx3Box , { |aBox| aBox[2] = &('TRB1->JD1_SITUAC') } )][3] ),&('TRB1->'+y[1]) )} ) } )
	TRB1->(dbskip())
end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Joga na matriz a quantidade de voltas para tratamento de macro do Word |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(aDados,{'qtd2',nVolt})
aadd(aDados,{'cObs',iif(empty(alltrim(cVar)),' ',alltrim(cVar))})
aadd(aDados,{'cDirD',iif(empty(alltrim(cPRO)),' ',alltrim(posicione("JBJ",1,xFilial("JBJ")+cPRO,"JBJ_DESC")))})
aadd(aDados,{'cSecD',iif(empty(alltrim(cSEC)),' ',alltrim(posicione("JBJ",1,xFilial("JBJ")+cSEC,"JBJ_DESC")))})
aadd(aDados,{'cDir',iif(empty(alltrim(cPRO)),' ',alltrim(posicione("JBJ",1,xFilial("JBJ")+cPRO,"ALLTRIM(ACNOMEPROF(JBJ_MATRES))")))})
aadd(aDados,{'cSec',iif(empty(alltrim(cSEC)),' ',alltrim(posicione("JBJ",1,xFilial("JBJ")+cSEC,"ALLTRIM(ACNOMEPROF(JBJ_MATRES))")))})
aadd(aDados,{'cDir_',iif(empty(alltrim(cPRO)),' ','________________________________')})
aadd(aDados,{'cSec_',iif(empty(alltrim(cSEC)),' ','________________________________')})

TRB1->(DBCLOSEAREA())

ACImpDoc( "SEC0037.Dot", aDados, "SEMESTRE" )

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ASSREQ   º Autor ³                    º Data ³  08/07/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Tela para informacao das assinaturas utilizadas em alguns  º±±
±±º          ³ documentos de requerimentos.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACAA410                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ASSHSTCOL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPRO := Space(6)
cSEC := Space(6)
cVar := Space(290)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 64,262 To 341,567 Dialog assinaturas Title STR0007
@ 10,18 Say STR0008 Size 46,8
@ 25,15 Say STR0009 Size 46,8
@ 40,15 Say STR0010 Size 46,8
@ 10,63 Get cPRO F3 "JBJ" Size 76,8
@ 25,63 Get cSEC F3 "JBJ" Size 76,8
@ 55,15 Get cVar MEMO Size 126,62
@ 124,111 BmpButton Type 1 Action close(assinaturas)
Activate Dialog assinaturas	CENTERED
Return({cPro, cSec, cVar})
