#include "Protheus.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0032a  ºAutor  ³Rafael Rodrigues    º Data ³  28/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Requerimento de Mudanca de Turno/Aula.                      º±±
±±º          ³Transfere uma unica aula do aluno para outra grade.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Requerimentos.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0032a()
Local cMarca	:= GetMark()
Local aStru		:= {}
Local aTitles	:= {"Segunda","Terça","Quarta","Quinta","Sexta","Sábado","Domingo"}
Local aPages	:= {"HEADER","HEADER","HEADER","HEADER","HEADER","HEADER","HEADER"}
Local aMarks	:= {nil,nil,nil,nil,nil,nil,nil}
Local aCpoBrw	:= {}
Local nOpca     := 0
Local cQuery
Local oFolder
Local i,j
Local cArqTRB
Local cIndTRB1
Local cIndTRB2

aAdd( aStru, { "JBL_OK"    , "C", 2                      , 0 } )
aAdd( aStru, { "JBL_DIASEM", "C", TamSX3("JBL_DIASEM")[1], 0 } )
aAdd( aStru, { "JBL_HORA1" , "C", TamSX3("JBL_HORA1" )[1], 0 } )
aAdd( aStru, { "JBL_HORA2" , "C", TamSX3("JBL_HORA2" )[1], 0 } )
aAdd( aStru, { "JBL_CODLOC", "C", TamSX3("JBL_CODLOC")[1], 0 } )
aAdd( aStru, { "JBL_CODPRE", "C", TamSX3("JBL_CODPRE")[1], 0 } )
aAdd( aStru, { "JBL_ANDAR" , "C", TamSX3("JBL_ANDAR" )[1], 0 } )
aAdd( aStru, { "JBL_CODSAL", "C", TamSX3("JBL_CODSAL")[1], 0 } )
aAdd( aStru, { "JBL_CODCUR", "C", TamSX3("JBL_CODCUR")[1], 0 } )
aAdd( aStru, { "JBL_PERLET", "C", TamSX3("JBL_PERLET")[1], 0 } )
aAdd( aStru, { "JBL_TURMA" , "C", TamSX3("JBL_TURMA" )[1], 0 } )

aAdd( aCpoBrw, { "JBL_OK"    ,, " "     , " "     } )
aAdd( aCpoBrw, { "JBL_CODCUR",, "Curso" , "@!"    } )
aAdd( aCpoBrw, { "JBL_TURMA" ,, "Turma" , "@!"    } )
aAdd( aCpoBrw, { "JBL_HORA1" ,, "Hora 1", "99:99" } )
aAdd( aCpoBrw, { "JBL_HORA2" ,, "Hora 2", "99:99" } )
aAdd( aCpoBrw, { "JBL_CODLOC",, "Local" , "@!"    } )
aAdd( aCpoBrw, { "JBL_CODPRE",, "Prédio", "@!"    } )
aAdd( aCpoBrw, { "JBL_ANDAR" ,, "Andar" , "@!"    } )
aAdd( aCpoBrw, { "JBL_CODSAL",, "Sala"  , "@!"    } )
aAdd( aCpoBrw, { "JBL_PERLET",, "Série" , "@!"    } )

cArqTRB  := CriaTrab(aStru, .T.)
cIndTRB1 := CriaTrab(Nil, .F.)
cIndTRB2 := CriaTrab(Nil, .F.)

dbUseArea( .T., , cArqTRB, "TRB", .F. )

IndRegua( "TRB", cIndTRB1, "JBL_DIASEM+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL+JBL_HORA1+JBL_HORA2",,,"Aguarde...")
TRB->( dbClearIndex() )
IndRegua( "TRB", cIndTRB2, "JBL_OK+JBL_HORA1+JBL_HORA2",,,"Aguarde...")
TRB->( dbClearIndex() )

TRB->( dbSetIndex( cIndTRB1 + OrdBagExt() ) )
TRB->( dbSetIndex( cIndTRB2 + OrdBagExt() ) )

TRB->( dbSetOrder(1) )

// Posiciona JAH e JAR no curso de origem do aluno
JAH->( dbSetOrder(1) )
JAH->( dbSeek(xFilial("JAH")+M->JBH_SCP01) )

JAR->( dbSetOrder(1) )
JAR->( dbSeek(xFilial("JAR")+M->JBH_SCP01+M->JBH_SCP03) )

// Query para selecionar as grades de aulas de todos os cursos vigentes baseados no mesmo curso padrao
// que o original, no turno informado, que tenha vaga disponivel para a disciplina.
cQuery := "SELECT DISTINCT "
cQuery += "JBL_DIASEM, "
cQuery += "JBL_HORA1, "
cQuery += "JBL_HORA2, "
cQuery += "JBL_CODLOC, "
cQuery += "JBL_CODPRE, "
cQuery += "JBL_ANDAR, "
cQuery += "JBL_CODSAL, "
cQuery += "JBL_CODCUR, "
cQuery += "JBL_PERLET, "
cQuery += "JBL_TURMA "

cQuery += "FROM "
cQuery += RetSQLName("JBL")+" JBL, "
cQuery += RetSQLName("JAH")+" JAH, "
cQuery += RetSQLName("JAR")+" JAR, "
cQuery += RetSQLName("JAE")+" JAE "

cQuery += "WHERE "
cQuery += "    JBL.D_E_L_E_T_ <> '*' "
cQuery += "and JAH.D_E_L_E_T_ <> '*' "
cQuery += "and JAR.D_E_L_E_T_ <> '*' "
cQuery += "and JAE.D_E_L_E_T_ <> '*' "
cQuery += "and JBL_FILIAL = '"+xFilial("JBL")+"' "
cQuery += "and JAH_FILIAL = '"+xFilial("JAH")+"' "
cQuery += "and JAR_FILIAL = '"+xFilial("JAR")+"' "
cQuery += "and JAE_FILIAL = '"+xFilial("JAE")+"' "
cQuery += "and JAH_CURSO = '"+JAH->JAH_CURSO+"' "
cQuery += "and JAH_VERSAO = '"+JAH->JAH_VERSAO+"' "
cQuery += "and JAR_PERLET = '"+JAR->JAR_PERLET+"' "
cQuery += "and JAR_ANOLET = '"+JAR->JAR_ANOLET+"' "
cQuery += "and JAR_PERIOD = '"+JAR->JAR_PERIOD+"' "
cQuery += "and JBL_CODDIS = '"+M->JBH_SCP05+"' "
cQuery += "and JAE_CODIGO = '"+M->JBH_SCP05+"' "
cQuery += "and JAH_CODIGO <> '"+M->JBH_SCP01+"' "
cQuery += "and JAR_CODCUR <> '"+M->JBH_SCP01+"' "
cQuery += "and JBL_CODCUR <> '"+M->JBH_SCP01+"' "
cQuery += "and JAH_TURNO = '"+M->JBH_SCP10+"' "
cQuery += "and JAH_CODIGO = JBL_CODCUR "
cQuery += "and JAH_CODIGO = JAR_CODCUR "
cQuery += "and JBL_CODDIS = JAE_CODIGO "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBQRY", .F., .T.)

TRBQRY->( dbGoTop() )
while TRBQRY->( !eof() )
	RecLock( "TRB", .T. )
	TRB->JBL_DIASEM	:= TRBQRY->JBL_DIASEM
	TRB->JBL_HORA1	:= TRBQRY->JBL_HORA1
	TRB->JBL_HORA2	:= TRBQRY->JBL_HORA2
	TRB->JBL_CODLOC	:= TRBQRY->JBL_CODLOC
	TRB->JBL_CODPRE	:= TRBQRY->JBL_CODPRE
	TRB->JBL_ANDAR	:= TRBQRY->JBL_ANDAR
	TRB->JBL_CODSAL	:= TRBQRY->JBL_CODSAL
	TRB->JBL_CODCUR	:= TRBQRY->JBL_CODCUR
	TRB->JBL_PERLET	:= TRBQRY->JBL_PERLET
	TRB->JBL_TURMA	:= TRBQRY->JBL_TURMA
	
	TRB->( msUnlock() )
	
	TRBQRY->( dbSkip() )
end

TRBQRY->( dbCloseArea() )

DEFINE MSDIALOG oDlg TITLE "Grades Disponíveis" FROM 00,00 TO 350,750 PIXEL

oFolder := TFolder():New( 12,2,aTitles,aPages,oDlg,,,,.T.,.T.,(oDlg:nClientWidth/2)-4,(oDlg:nClientHeight/2)-14)

for i := 1 to 7
	j := if( i == 7, 1, i+1 )
	aMarks[i] := MsSelect():New("TRB","JBL_OK",,aCpoBrw,,cMarca,{ 2, 2, (oFolder:nClientHeight/2)-4, (oFolder:nClientWidth/2)-4 },"( '" + Str(j,1) + "')","( '" + Str(j,1) + "')",oFolder:aDialogs[i])

	aMarks[i]:oBrowse:Default()
	aMarks[i]:oBrowse:Refresh()
	aMarks[i]:bAval               := &("{ || U_SEC0032m(cMarca,@aMarks["+Str(i,1)+"]) }")
	aMarks[i]:oBrowse:lhasMark    := .T.
	aMarks[i]:oBrowse:lCanAllmark := .F.
next i

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg, { || nOpca := 1, If( U_SEC0032v(cMarca), oDlg:End(), nOpca := 0) }, { || oDlg:End() },,)

if nOpca == 1
	TRB->( dbSetOrder(2) )
	if TRB->( dbSeek( cMarca ) )
		JAH->( dbSetOrder(1) )
		JAH->( dbSeek( xFilial("JAH")+TRB->JBL_CODCUR ) )
		JAF->( dbSetOrder(1) )
		JAF->( dbSeek( xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO ) )
		M->JBH_SCP11 := TRB->JBL_CODCUR
		M->JBH_SCP12 := JAF->JAF_DESMEC
		M->JBH_SCP13 := TRB->JBL_PERLET
		M->JBH_SCP14 := TRB->JBL_TURMA
		M->JBH_SCP15 := TRB->JBL_DIASEM
	endif
endif

TRB->( dbCloseArea() )
dbSelectArea("JAH")

Return nOpca == 1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0032b  ºAutor  ³Rafael Rodrigues    º Data ³  28/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Requerimento de Mudanca de Turno/Aula.                      º±±
±±º          ³Valida se o aluno possui aula no dia da semana especificado.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Requerimentos.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0032b()
Local aArea := JC7->( GetArea() )
Local lOk	:= .F.

JC7->( dbSetOrder(1) )
if JC7->( !dbSeek(xFilial("JC7")+Left(M->JBH_CODIDE, TamSX3("JC7_NUMRA")[1])+M->JBH_SCP01+M->JBH_SCP03+M->JBH_SCP04+M->JBH_SCP05) )
	MsgStop('Esta disciplina não existe na grade de aulas do aluno.')
elseif ! JC7->JC7_SITDIS $ '001/002/006/010'
	MsgStop('Apenas disciplinas com situação "Matriculado", "Adaptaçao", "Dependência" ou "Tutoria" podem ser movidas.')
else	
	while !lOk .and. JC7->( !eof() ) .and. JC7->( JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP ) == xFilial("JC7")+Left(M->JBH_CODIDE, TamSX3("JC7_NUMRA")[1])+M->JBH_SCP01+M->JBH_SCP03+M->JBH_SCP04+M->JBH_SCP05
		lOk := JC7->JC7_DIASEM == M->JBH_SCP09
		JC7->( dbSkip() )
	end
	
	if !lOk
		MsgStop('Não existe aula desta disciplina neste dia da semana na grade do aluno!')
	endif
endif

JC7->( RestArea(aArea) )
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0032c  ºAutor  ³Rafael Rodrigues    º Data ³  28/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Requerimento de Mudanca de Turno/Aula.                      º±±
±±º          ³Validacao do curso informado manualmente.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Requerimentos.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0032c()
Local lRet := Empty(M->JBH_SCP11) .or. ( !Empty(M->JBH_SCP12) .and. !Empty(M->JBH_SCP13) .and. !Empty(M->JBH_SCP14) .and. !Empty(M->JBH_SCP15) )

if !lRet
	MsgStop('Utilize a tecla F3 para selecionar o curso e a aula de destino.')
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0032d  ºAutor  ³Rafael Rodrigues    º Data ³  28/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Requerimento de Mudanca de Turno/Aula.                      º±±
±±º          ³Processamento da transferencia da aula do aluno.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Requerimentos.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0032d()
Local aRet	:= ACScriptReq( JBH->JBH_NUM )
Local cRA	:= Left( JBH->JBH_CODIDE, TamSX3("JC7_NUMRA")[1] )
Local i
Local aCpos := {}

JC7->( dbSetOrder(1) )
JC7->( dbSeek( xFilial("JC7")+cRA+aRet[1]+aRet[3]+aRet[4]+aRet[5] ) )

for i := 1 to JC7->( FCount() )
	aAdd( aCpos, JC7->( FieldGet(i) ) )
next i

while JC7->( !eof() ) .and. JC7->( JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP ) == xFilial("JC7")+cRA+aRet[1]+aRet[3]+aRet[4]+aRet[5]
	if JC7->JC7_DIASEM == aRet[9]
		RecLock( "JC7", .F. )
		JC7->JC7_SITDIS := '008'		// Transferido
		JC7->JC7_SITUAC := '9'			// Cancelado
		JC7->( msUnlock() )
	endif
	JC7->( dbSkip() )
end

JBL->( dbSetOrder(1) )
JBL->( dbSeek( xFilial("JBL")+aRet[11]+aRet[13]+aRet[14]+aRet[5] ) )
while JBL->( !eof() ) .and. JBL->( JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_TURMA+JBL_CODDIS ) == xFilial("JBL")+aRet[11]+aRet[13]+aRet[14]+aRet[5]
	if JBL->JBL_DIASEM == aRet[15]
		RecLock( "JC7", .T. )
		for i := 1 to JC7->( FCount() )
			JC7->( FieldPut( i, aCpos[i] ) )
		next i
		JC7->JC7_DIASEM := JBL->JBL_DIASEM
		JC7->JC7_CODHOR := JBL->JBL_CODHOR
		JC7->JC7_HORA1  := JBL->JBL_HORA1
		JC7->JC7_HORA2  := JBL->JBL_HORA2
		JC7->JC7_CODLOC := JBL->JBL_CODLOC
		JC7->JC7_CODPRE := JBL->JBL_CODPRE
		JC7->JC7_ANDAR  := JBL->JBL_ANDAR
		JC7->JC7_CODSAL := JBL->JBL_CODSAL
		JC7->JC7_CODPRF := JBL->JBL_MATPRF
		JC7->JC7_CODPR2 := JBL->JBL_MATPR2
		JC7->JC7_CODPR3 := JBL->JBL_MATPR3
		JC7->JC7_OUTCUR := JBL->JBL_CODCUR
		JC7->JC7_OUTPER := JBL->JBL_PERLET
		JC7->JC7_OUTTUR := JBL->JBL_TURMA
		JC7->( msUnlock() )
	endif
	
	JBL->( dbSkip() )
end

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0032m  ºAutor  ³Rafael Rodrigues    º Data ³  28/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Requerimento de Mudanca de Turno/Aula.                      º±±
±±º          ³Marca/Desmarca os itens na markbrowse.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Requerimentos.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0032m( cMarca, oMark )
Local nRec   := TRB->( Recno() )
Local lMarca := TRB->JBL_OK != cMarca
Local cChave := TRB->( JBL_DIASEM+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL )
Local cCurso := TRB->( JBL_CODCUR+JBL_PERLET+JBL_TURMA )

if lMarca
	TRB->( dbSetOrder(2) )
	while TRB->( dbSeek( cMarca ) )
		RecLock( "TRB", .F. )
		TRB->JBL_OK := Space(2)
		TRB->( msUnlock() )
	end
	
	TRB->( dbSetOrder(1) )
	TRB->( dbGoTo( nRec ) )
endif

TRB->( dbSeek( cChave ) )
while TRB->( !eof() ) .and. TRB->( JBL_DIASEM+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL ) == cChave
	if cCurso == TRB->( JBL_CODCUR+JBL_PERLET+JBL_TURMA )
		RecLock("TRB", .F.)
		TRB->JBL_OK := if( lMarca, cMarca, Space(2) )
		TRB->( msUnlock() )
	endif
	
	TRB->( dbSkip() )
end
TRB->( dbGoTo( nRec ) )

oMark:oBrowse:Refresh()

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0032v  ºAutor  ³Rafael Rodrigues    º Data ³  28/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Requerimento de Mudanca de Turno/Aula.                      º±±
±±º          ³Valida a selecao da aula.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Requerimentos.                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0032v( cMarca )
Local nRec := TRB->( Recno() )
Local lRet := .T.

TRB->( dbSetOrder(2) )
lRet := TRB->( dbSeek( cMarca ) )

if !lRet
	MsgStop("Nenhuma aula foi selecionada! Selecione uma aula para prosseguir.")
end

TRB->( dbSetOrder(1) )
TRB->( dbGoTo( nRec ) )

Return lRet