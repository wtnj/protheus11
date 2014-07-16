#INCLUDE "AcaDia.ch"
#INCLUDE "RWMAKE.CH"

/*  
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AcaDia   ³ Autor ³ Marco Aurelio         ³ Data ³ 26/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Emite Diario de Classe.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAESP                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AcaDia(cNomArq)

Local cArqTmp  := ""	// Arquivo temporario
Local lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private CbCont  := ""			// Auxiliar para impressao de rodape
Private CbTxt   := ""			// Auxiliar para impressao de rodape
Private cString := "JBE"		// Alias principal
Private Tamanho := "G"			// Tamanho da listagem e colunas ( P=80, M=136, G=220 )
Private wnrel	:= cNomArq	// Nome da rotina a ser usada no spool de impressao
Private titulo  := ""			// Titulo da listagem  ( "DIARIO DE CLASSE" )
Private cDesc1  := STR0002 		//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
Private cDesc2  := STR0003 		//"totalizando por produto e escolhendo a moeda forte para os Valores."
Private cDesc3  := ""
Private lWeb      := .F.

wnrel := Iif(wnrel == nil,"AcaDia",wnrel)
                                 
lWeb := IsBlind()

nLastKey := 0			// Numero da ultima tecla acionada
m_pag    := 1           // Numeracao sequencial de paginas
aReturn  := {}			// Dados de configuracao da listagem ( "Zebrado"###"Administracao" )
cPerg    := "ACR660"	// Referencia dos parametros no SX1
nomeprog := "AcaDiario"	// Nome da rotina a ser exibida na listagem
titulo   := STR0001+ " - " + AllTrim(SM0->M0_NOME) + " - " + Alltrim(SM0->M0_FILIAL)	// Titulo da liastagem  ( "DIARIO DE CLASSE" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 Unidade De ?        ³
//³ mv_par02 Unidade Ate ?       ³
//³ mv_par03 Curso De ?          ³
//³ mv_par04 Curso Ate ?         ³
//³ mv_par05 Serie De ?          ³
//³ mv_par06 Serie Ate?          ³
//³ mv_par07 Turma De ?          ³
//³ mv_par08 Turma Ate ?         ³
//³ mv_par09 Ano  ?              ³
//³ mv_par10 Periodo Letivo ?    ³
//³ mv_par11 Disciplina De ?     ³
//³ mv_par12 Disciplina Ate ?    ³
//³ mv_par13 Professor De ?      ³
//³ mv_par14 Professor Ate ?     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lWeb // Se não estiver chamando em Job (Sem utilizar objetos de janela)
	Pergunte(cPerg,.F.)
Else
	// forca a geracao do relatorio em disco, conforme indicacao do Fernandes
	__AIMPRESS[1]:=1
Endif

// Forcar a variavel para NIL, invertendo processamento na Setprint
__cInternet := NIL

SetPrintEnv(1)

aReturn := {STR0003, 1,STR0004, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
wnrel	:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,   ,.f. ,  ,  ,lWeb,.T.)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString,,lWeb)

If nLastKey == 27
	Set Filter To
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da rotina de armazenamento de dados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lweb
	Processa({|| AcDiaTRB(@cArqTmp) })
Else
	AcDiaTRB(@cArqTmp)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o Arquivo de Trabalho para impressao do Diario de Classe. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()          

Count To nRegs

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da rotina de impressao do relat¢rio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

// Chamada da rotina de impressao do relat¢rio...
If !lweb
   RptStatus({|lEnd| AcaImpDia(@lEnd,nRegs) })
Else
	AcaImpDia(@lEnd,nRegs)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1

	dbCommitAll()
	
	Set Printer To

	If !lWeb
		OurSpool(wnrel)
	Endif
	
EndIf

MS_FLUSH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectarea("TRB")
dbCloseArea()

DbSelectArea("JBE")
RetIndex("JBE")
DbSelectArea("JC7")
RetIndex("JC7")

Return wnrel


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AcDiaTRB³ Autor ³Marco Aurelio         ³ Data ³ 26/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Selecione os registros baseados nos parametros passados	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	 ³ Especifico Academico                   				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³								            ³      ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function AcDiaTRB(cArqTmp)

Local cQuery   := ""	// String para filtro de tabelas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona asa tabelas e as ordens de indicesa serm usadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("JA2")	// Cadastro de Alunos
DbSetOrder(1)		// Ordem: Codigo
DbSelectArea("JAR")	// Curso x Periodo Letivo
DbSetOrder(1)		// Ordem: Curso + Periodo Letivo

cQuery := "SELECT DISTINCT "
cQuery += "JC7.JC7_NUMRA  RA, "
cQuery += "JC7.JC7_CODPRF MATPRF, "
cQuery += "JC7.JC7_CODCUR CURSO, "
cQuery += "JC7.JC7_PERLET SERIE, "
cQuery += "JC7.JC7_TURMA  TURMA, "
cQuery += "JC7.JC7_DISCIP DISCIP, "
cQuery += "JC7.JC7_SITUAC SITUAC, "
cQuery += "SX5.X5_DESCRI SITDIS, "
cQuery += "JC7.JC7_MEDFIM MEDIA, "
cQuery += "JC7.JC7_MEDCON MEDCON, "
cQuery += "JA2.JA2_NOME   ALUNO, "
cQuery += "JC7.JC7_CODLOC UNIDADE, "
cQuery += "JC7.JC7_CODPRE PREDIO, "
cQuery += "JC7.JC7_ANDAR  ANDAR, "
cQuery += "JC7.JC7_CODSAL SALA, "
cQuery += "JAH.JAH_CURSO  CURPAD, "
cQuery += "JC7.JC7_CODCUR CURSOF, "
cQuery += "JC7.JC7_PERLET SERIEF, "
cQuery += "JC7.JC7_OUTCUR OUTCUR, "
cQuery += "JC7.JC7_OUTPER OUTPER, "
cQuery += "JBE.JBE_SITUAC MATRICU "

cQuery += "FROM "+	RetSQLName("JC7")+" JC7, "+;	// Itens da movimentacao do aluno
					RetSQLName("JBE")+" JBE, "+;	// Header da movimentacao do aluno
					RetSQLName("JA2")+" JA2, "+;	// Alunos
					RetSQLName("SX5")+" SX5, "+;	// Tabelas
					RetSQLName("JAH")+" JAH "		// Cursos Vigentes

cQuery += "WHERE "
cQuery += "JBE.JBE_FILIAL = '" + xFilial("JBE") + "' And "
cQuery += "JC7.JC7_FILIAL = '" + xFilial("JC7") + "' And "
cQuery += "JAH.JAH_FILIAL = '" + xFilial("JAH") + "' And "
cQuery += "JA2.JA2_FILIAL = '" + xFilial("JA2") + "' And "
cQuery += "SX5.X5_FILIAL = '" + xFilial("SX5") + "' And "

cQuery += "JAH.JAH_CURSO Between '"+mv_par03+"' and '"+mv_par04+"' And "		// Curso De/Ate
cQuery += "JAH.JAH_UNIDAD Between '"+mv_par01+"' and '"+mv_par02+"' And "	// Unidade De/Ate

cQuery += "JA2.JA2_NUMRA  = JC7.JC7_NUMRA  And " 
cQuery += "JA2.JA2_NUMRA  = JBE.JBE_NUMRA  And " 
cQuery += "JBE.JBE_NUMRA  = JC7.JC7_NUMRA  And " 

cQuery += "JBE.JBE_CODCUR = JAH.JAH_CODIGO And " 
cQuery += "JC7.JC7_CODCUR = JAH.JAH_CODIGO And " 
cQuery += "JBE.JBE_CODCUR = JC7.JC7_CODCUR And " 

cQuery += "JBE.JBE_PERLET Between '" + mv_par05 + "' And '" + mv_par06 + "' And "
cQuery += "JC7.JC7_PERLET Between '" + mv_par05 + "' And '" + mv_par06 + "' And "
cQuery += "JC7.JC7_PERLET = JBE.JBE_PERLET And "

cQuery += "JBE.JBE_TURMA  Between '" + mv_par07 + "' And '" + mv_par08 + "' And "
cQuery += "JC7.JC7_TURMA  Between '" + mv_par07 + "' And '" + mv_par08 + "' And "
cQuery += "JC7.JC7_TURMA  = JBE.JBE_TURMA And " 

cQuery += "JC7.JC7_DISCIP BETWEEN '" + mv_par11 + "' And '" + mv_par12 + "' And "
cQuery += "JC7.JC7_SITUAC NOT IN ('7','8','9','A') And "	// 7=Trancado, 8=Dispensado, 9=Cancelado, A=A Cursar
cQuery += "JBE_ATIVO in ('1','2','5') and "					// 1=Ativo, 2=Inativo, 5=Formado
cQuery += "SX5.X5_TABELA = 'F3' and SX5.X5_CHAVE = JC7.JC7_SITDIS and "

cQuery += "	JC7.JC7_SITDIS IN ('001','002','006','010') and "

cQuery += "	JC7.JC7_OUTCUR   =  '"+Space(TamSX3("JC7_OUTCUR")[1])+"' and "
cQuery += "	JC7.JC7_OUTPER   =  '"+Space(TamSX3("JC7_OUTPER")[1])+"' and "
cQuery += "	JC7.JC7_OUTTUR   =  '"+Space(TamSX3("JC7_OUTTUR")[1])+"' and "

cQuery += "JC7.JC7_CODPRF BETWEEN '" + mv_par13 + "' And '" + mv_par14 + "' And "
cQuery += "JBE.JBE_ANOLET = '" + mv_par09 + "' And "
cQuery += "JBE.JBE_PERIOD = '" + mv_par10 + "' And "

cQuery += "JC7.D_E_L_E_T_ <> '*' And "
cQuery += "JBE.D_E_L_E_T_ <> '*' And "
cQuery += "JAH.D_E_L_E_T_ <> '*' And "
cQuery += "SX5.D_E_L_E_T_ <> '*' And "
cQuery += "JA2.D_E_L_E_T_ <> '*' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sub Select complementar para pegar os alunos referentes a outros cursos. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += "UNION "

cQuery += "SELECT DISTINCT "
cQuery += "JC7.JC7_NUMRA  RA, "
cQuery += "JC7.JC7_CODPRF MATPRF, "
cQuery += "JC7.JC7_OUTCUR CURSO, "
cQuery += "JC7.JC7_OUTPER SERIE, "
cQuery += "JC7.JC7_OUTTUR TURMA, "
cQuery += "JC7.JC7_DISCIP DISCIP, "
cQuery += "JC7.JC7_SITUAC SITUAC, "
cQuery += "SX5.X5_DESCRI SITDIS, "
cQuery += "JC7.JC7_MEDFIM MEDIA, "
cQuery += "JC7.JC7_MEDCON MEDCON, "
cQuery += "JA2.JA2_NOME   ALUNO, "
cQuery += "JC7.JC7_CODLOC UNIDADE, "
cQuery += "JC7.JC7_CODPRE PREDIO, "
cQuery += "JC7.JC7_ANDAR  ANDAR, "
cQuery += "JC7.JC7_CODSAL SALA, "
cQuery += "JAH.JAH_CURSO  CURPAD, "
cQuery += "JC7.JC7_CODCUR CURSOF, "
cQuery += "JC7.JC7_PERLET SERIEF, "
cQuery += "JC7.JC7_OUTCUR OUTCUR, "
cQuery += "JC7.JC7_OUTPER OUTPER, "
cQuery += "JBE.JBE_SITUAC MATRICU "

cQuery += "FROM "+	RetSQLName("JC7")+" JC7, "+;	// Itens da movimentacao do aluno
					RetSQLName("JBE")+" JBE, "+;	// Header da movimentacao do aluno
					RetSQLName("JA2")+" JA2, "+;	// Alunos
					RetSQLName("SX5")+" SX5, "+;	// Tabelas
					RetSQLName("JAH")+" JAH "		// Cursos Vigentes

cQuery += "WHERE "
cQuery += "JBE.JBE_FILIAL = '" + xFilial("JBE") + "' And "
cQuery += "JC7.JC7_FILIAL = '" + xFilial("JC7") + "' And "
cQuery += "JAH.JAH_FILIAL = '" + xFilial("JAH") + "' And "
cQuery += "JA2.JA2_FILIAL = '" + xFilial("JA2") + "' And "
cQuery += "SX5.X5_FILIAL = '" + xFilial("SX5") + "' And "

cQuery += "JAH.JAH_CURSO Between '"+mv_par03+"' and '"+mv_par04+"' And "		// Curso De/Ate
cQuery += "JAH.JAH_UNIDAD Between '"+mv_par01+"' and '"+mv_par02+"' And "	// Unidade De/Ate

cQuery += "JA2.JA2_NUMRA  = JC7.JC7_NUMRA  And " 
cQuery += "JA2.JA2_NUMRA  = JBE.JBE_NUMRA  And " 
cQuery += "JBE.JBE_NUMRA  = JC7.JC7_NUMRA  And " 

cQuery += "JC7.JC7_OUTCUR = JAH.JAH_CODIGO And " 
cQuery += "JBE.JBE_CODCUR = JC7.JC7_CODCUR And " 

cQuery += "JC7.JC7_OUTPER Between '" + mv_par05 + "' And '" + mv_par06 + "' And "
cQuery += "JC7.JC7_PERLET = JBE.JBE_PERLET And "

cQuery += "JC7.JC7_OUTTUR  Between '" + mv_par07 + "' And '" + mv_par08 + "' And "
cQuery += "JC7.JC7_TURMA  = JBE.JBE_TURMA And " 

cQuery += "JC7.JC7_DISCIP BETWEEN '" + mv_par11 + "' And '" + mv_par12 + "' And "

cQuery += "JC7.JC7_SITUAC NOT IN ('7','8','9','A') And "	// 7=Trancado, 8=Dispensado, 9=Cancelado, A=A Cursar
cQuery += "JBE_ATIVO IN ('1','2','5') and "					// 1=Ativo, 2=Inativo, 5=Formado
cQuery += "SX5.X5_TABELA = 'F3' and SX5.X5_CHAVE = JC7.JC7_SITDIS and "

cQuery += "JC7.JC7_SITDIS IN ('001','002','006','010') and "

cQuery += "JC7.JC7_OUTCUR <> '"+Space(TamSX3("JC7_OUTCUR")[1])+"' and "
cQuery += "JC7.JC7_OUTPER <> '"+Space(TamSX3("JC7_OUTPER")[1])+"' and "
cQuery += "JC7.JC7_OUTTUR <> '"+Space(TamSX3("JC7_OUTTUR")[1])+"' and "

cQuery += "JC7.JC7_CODPRF BETWEEN '" + mv_par13 + "' And '" + mv_par14 + "' And "
cQuery += "JBE.JBE_ANOLET = '" + mv_par09 + "' And "
cQuery += "JBE.JBE_PERIOD = '" + mv_par10 + "' And "

cQuery += "JC7.D_E_L_E_T_ <> '*' And "
cQuery += "JBE.D_E_L_E_T_ <> '*' And "
cQuery += "JAH.D_E_L_E_T_ <> '*' And "
cQuery += "SX5.D_E_L_E_T_ <> '*' And "
cQuery += "JA2.D_E_L_E_T_ <> '*' "

cQuery += "ORDER BY CURSO, SERIE, TURMA, DISCIP, MATPRF, ALUNO"

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³AcaImpDia ³ Autor ³ Marco Aurelio         ³ Data ³ 26/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Diario de Classe					          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AcaDiario      											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AcaImpDia(lEnd,nRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo caracter ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMV_ACCHRNC := GetMV("MV_ACCHRNC")// Caracteres a serem impressos na ausencia de nota
Local cCurso      := ""					// Codigo do curso
Local cSerie      := ""					// Periodo Letivo
Local cTurma      := ""					// Turma
Local cDisciplina := ""					// Codigo da Disciplina
Local cMatPrf     := ""
Local cDescCab1A  := ""					// Cabecalho de detalhes 1 - Parte A
Local cDescCab1B  := ""					// Cabecalho de detalhes 1 - Parte B
Local cDescCab2A  := ""					// Cabecalho de detalhes 2 - Parte A
Local cDescCab2B  := ""					// Cabecalho de detalhes 2 - Parte B
Local cDescCab3A  := ""					// Cabecalho de detalhes 3 - Parte A
Local cDescCab3B  := ""					// Cabecalho de detalhes 3 - Parte B
Local cCabDias    := ""					// Cabecalho auxiliar dos dias do periodo
Local cCabAtiv    := ""					// Cabecalho auxiliar de atividades
Local cDescBox    := ""					// Descricao da situacao do aluno
Local cProfessor  := ""					// Nome do Professor
Local cStrDiaSem  := ""					// Contem os dias da semana que o professor leciona

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo numericas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nMes       := 0								// Auxiliar para controle de mudanca de mes
Local nLin       := 0								// Numero da linha de impressao
Local nLinFal    := 0								// Numero da linha no array referente as faltas
Local nInd       := 0								// Indice de laco For/Next
Local nAtiv      := 0								// Indice de laco For/Next Atividades
Local nOrdem     := 0								// Numero sequencial para identificacao do Aluno
Local nPosIniFal := 0								// Posicicao inicial para impressao de faltas
Local nCtMes     := 0								// Controla o numero de meses a serem considerado no cabecalho de faltas
Local nCtLinFal  := 0								// Quantidade de linhas referentes as faltas
Local nTamAval   := 0								// Determina o tamanho do cabecalho referente as avaliacoes
Local nTotFaltas := 0								// Totalizador de faltas                           	
Local nTamCabFal := 0								// Tamanho do maior cabecalho de faltas
Local nPosTotFal := 0								// Posicao de impressao do Total de Faltas
Local nPosCabFal := 0								// Posicao de impressao dos cabecalhos extras de faltas
Local nPosImp    := 0								// Posicao de impressao a partir do Total de Faltas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo array ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAvaliacao  := {}	// Contem os codigos referentes as avaliacoes do periodo letivo
Local aAtividades := {}	// Contem os codigos referentes as atividades por avaliacoes 
Local aCabFaltas  := {}	// Contem os cabecalhos referentes as faltas
Local aFaltas     := {}	// Contem os dados para controle de impressao de faltas
Local aLinFal     := {}	// Linhas detalhes complementares de faltas
Local aMeses      := {}	// Contem os extensos dos meses quanto apontamento Mensal

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo data ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local dDataDe,dDataAte	// Auxiliar para validacao de datas validas de aula no periodo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo logicas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lConceito  := .f.	// Determina se o apontamento de notas se refere a valor ou conceito
Local lDiaOK     := .t.	// Determina que um determinado dia eh valido para aula
Local lExec      := .t.	// Determina se gera dados de cabecalho
Local cDias      := ""

cDescCab3A := STR0021   // "No.  RA                  Nome do Aluno" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o Arquivo de Trabalho para impressao do Diario de Classe. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()          

If !lWeb
	SetRegua(nRegs)
Endif

cbtxt  := SPACE(10)
cbcont := 0

While !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Somente considera alunos matriculados ou pre-matriculados ³
	//³ cujo curso usado como OUTCUR for especial de ferias.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( TRB->MATRICU == "1" .and. !AcFerias(TRB->CURSOF,TRB->SERIEF,TRB->OUTCUR,TRB->OUTPER) )

		TRB->(dbSkip())                                    
		
		Loop
	
	EndIf	
		
	If lExec
	
		If 	( TRB->CURSO+TRB->SERIE+TRB->TURMA # cCurso+cSerie+cTurma) .or. ( TRB->DISCIP # cDisciplina ).or. ( TRB->MATPRF # cMatPrf )
	
			If 	( TRB->CURSO+TRB->SERIE # cCurso+cSerie )
	
				cCurso := TRB->CURSO
				cSerie := TRB->SERIE
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona JAH(Cursos Vigentes) para apurar o metodo de apontamento de faltas. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				JAH->( dbSetOrder(1) )	// Ordem: Curso
				JAH->( dbSeek(xFilial("JAH")+TRB->CURSO) )
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona JAR(Periodos Vigentes) para apurar o metodo de apontamento de faltas. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				JAR->( dbSetOrder(1) )	// Ordem: Curso + Periodo Letivo
				JAR->( dbSeek(xFilial("JAR")+TRB->CURSO+TRB->SERIE) )
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Chama rotina para verificar se o criterio de avaliacao e por Nota ou Conceito. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				 lConceito := ( JAR->JAR_CRIAVA == "2" ) // Se for conceito
	
			EndIf
			
			If 	( TRB->DISCIP # cDisciplina ) .or. ( TRB->TURMA # cTurma ) .or. ( TRB->MATPRF # cMatPrf )

				aFaltas     := {}
				aCabFaltas  := {}
				aAtividades := {}
				cDescCab1B  := ""
				cDescCab2B  := ""
				cDescCab3B  := ""
				cStrDiaSem  := ""
				cCabDias    := ""
				cTurma      := TRB->TURMA
				cDisciplina := TRB->DISCIP
				cMatPrf     := TRB->MATPRF
				nOrdem      := 0
				nTamAval    := 0
				nTamCabFal  := 0
				nPosIniFal  := 68
				nLinFal     := 1
				cProfessor  := AllTrim(Posicione("SRA",1,xFilial("SRA")+TRB->MATPRF,"RA_NOME"))
				cDias		:= ""
		
				If (JAR->JAR_APFALT == "1")	// Apontamento Diario
	
					Aadd(aCabFaltas,"")
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Loop na JBL(Grade de Aulas) para apurar os dias da semana que o professor leciona ³
					//³ em relacao ao curso,  periodo e disciplina.                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					JD2->(dbSetOrder(3)) // JD2_FILIAL+JD2_CODCUR+JD2_PERLET+JD2_TURMA+JD2_DIASEM+JD2_ITEM+DTOS(JD2_DATA)	
				
					dbSelectArea("JBL")	// Grade de Aulas
					dbSetOrder(1) 		// Curso+Periodo+Turma+Disciplina+Professor
									
					dbSeek(xFilial("JBL")+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP+TRB->MATPRF)
				
					dDataDe		:= Iif(Empty(JBL->JBL_DATA1),JAR->JAR_DATA1,JBL->JBL_DATA1)
					dDataAte	:= Iif(Empty(JBL->JBL_DATA2),JAR->JAR_DATA2,JBL->JBL_DATA2)

					While 	JBL->JBL_FILIAL == xFilial("JBL") .And.;
							JBL->JBL_CODCUR == TRB->CURSO     .And.;
							JBL->JBL_PERLET == TRB->SERIE	  .And.;
							JBL->JBL_TURMA  == TRB->TURMA	  .And.;
							JBL->JBL_CODDIS == TRB->DISCIP    .And.;
							JBL->JBL_MATPRF == TRB->MATPRF    .And. ! JBL->(Eof())
						
						If At(JBL->JBL_DIASEM,cStrDiaSem)==0
							cStrDiaSem += JBL->JBL_DIASEM
						EndIf	
						
						JD2->(dbSeek(xFilial("JD2")+JBL->JBL_CODCUR+JBL->JBL_PERLET+JBL->JBL_TURMA+JBL->JBL_DIASEM+JBL->JBL_ITEM))
						While ! JD2->(Eof()) .and.;
							JD2->JD2_FILIAL == xFilial("JD2") .and.;
							JD2->JD2_CODCUR == JBL->JBL_CODCUR .and.;
							JD2->JD2_PERLET == JBL->JBL_PERLET .and.;
							JD2->JD2_TURMA  == JBL->JBL_TURMA .and.;
							JD2->JD2_DIASEM == JBL->JBL_DIASEM .and.;
							JD2->JD2_ITEM   == JBL->JBL_ITEM

							cDias += Dtos(JD2->JD2_DATA)+";"
						
							JD2->(DbSkip())
						
						End
										
				    	JBL->(dbSkip())
					
					EndDo
				
					nMes		:= Month(dDataDe)
				    nCtMes		:= 1
				    nCtLinFal	:= 1
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os dias de aula referente ao periodo letivo em relacao ao calendario . ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While dDataDe <= dDataAte
					
						lDiaOK := .t.

						If ! Empty(cDias) .and. ! dtos(dDataDe) $ cDias
							lDiaOk := .f.
						EndIf
					    
						dbSelectArea("JBV") // Feriado Academico     
						dbSetOrder(1)       // Codigo
					
						dbSeek(xFilial("JBV")+JAR->JAR_CALACA)
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Despreza datas do periodo de aulas que estejam cadastradas na tabela de ³
						//³ de feriados.                                                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						While  ! JBV->(Eof()) .and. lDiaOk .and. JBV->(JBV_FILIAL+JBV_COD) == xFilial("JBV")+JAR->JAR_CALACA
				
							If ( dDataDe >= JBV->JBV_DTINI .and. dDataDe <= JBV->JBV_DTFIM )
							    
								lDiaOK := .f.
							    
							EndIf
									
							JBV->(dbSkip())
							
						EndDo
				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Caso for um dia normal de aula guarda posicao referente a coluna ³
						//³ para impressao da falta deste.   								 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lDiaOK .and. ( Str(Dow(dDataDe),1) $ cStrDiaSem )
			                        
							If ! nMes == Month(dDataDe) .or. Empty(cCabDias)
								nMes       := Month(dDataDe)
								cCabDias   += AcaMeses(.t.,nMes)+"/"
							EndIF
				  			nPosIniFal += 1
							cCabDias   += StrZero(Day(dDataDe),2)+" "
							
							Aadd(aFaltas,{StrZero(Month(dDataDe),2),nPosIniFal,0,StrZero(Day(dDataDe),2),nLinFal})
							
							nPosIniFal +=  2 
							
						EndIf
						
						dDataDe += 1
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Quando mudar o mes monta cabecalhos. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (nMes # Month(dDataDe) .or. dDataDe > dDataAte) .and. ! Empty(cCabDias)
							
							cCabDias   += " "
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Limite de meses no cabecalho igual a 2. ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					  		If nCtMes > 1 .or. (dDataDe > dDataAte)
						  		
						  		nPosIniFal := 69 
							    nCtLinFal  += 1
						  		nCtMes     := 0
						  		nLinFal    += 1
				   
						 		If Len(cCabDias) > nTamCabFal		  		
						 			nTamCabFal := Len(cCabDias)
						 		EndIf
						 		
								Aadd(aCabFaltas,cCabDias)
								
	  							cCabDias   := ""
	
						  	EndIf	
						  	
					  		nPosIniFal += Iif(nCtMes==1,5,1)
							nCtMes     ++
	
						EndIf	
				
					EndDo
					
					aCabFaltas[1] := PadC(STR0049,(nTamCabFal-2),"_")+Space(12) 	// "FALTAS DIARIAS"
	
	 			ElseIf (JAR->JAR_APFALT == "2")										// Apontamento Mensal
	
					aMeses := AcaMeses(.f.)
					nPosIniFal += 2 
	                
					For nInd:=1 To Len(aMeses)
						
						cDescCab3B += aMeses[nInd][1]+" "
						
						Aadd(aFaltas,{aMeses[nInd][2],nPosIniFal,0,0,1})
	
						nPosIniFal += 4
	
					Next	
					
					cDescCab3B += " "
					cDescCab1B := Space(Len(AllTrim(cDescCab3B)))+Space(12)			
					cDescCab2B := PadC(AllTrim(STR0029),Len(AllTrim(cDescCab3B)),"_")+"  "			
					
				Endif
				
				cDescCab2B += STR0031+"  "							   					// "TOTAL DE"
				cDescCab3B += STR0029+"  "												// " FALTAS "
				aAvaliacao := {}
				ncSpace    := 0	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona JBQ(Curso X Avaliacoes) para apurar numero de avaliacoes para o curso.³
				//³ e montar a cabecalho especifico para estas.                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("JBQ")	// Periodo Letivo x Avaliacoes
				dbSetOrder(1)		// Ordem: Curso + Periodo Letivo
				dbSeek(xFilial("JBQ") + TRB->CURSO + TRB->SERIE)
			
				While 	JBQ->JBQ_FILIAL == xFilial("JBQ") .And.;
						JBQ->JBQ_CODCUR == TRB->CURSO     .And.;
						JBQ->JBQ_PERLET == TRB->SERIE     .And. !Eof()
						
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gera cabecalho referente as avaliacoes ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
					cCabAtiv := ""
					
					Aadd(aAvaliacao,{JBQ->JBQ_CODAVA,"N"})
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Para cada avaliacao verifica se existem atividades relacionadas ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("JDA")	// Itens de Atividades por Avaliacao
					dbSetOrder(1)		// Ordem: Curso+Periodo Letivo+Turma+Disciplina+Avaliacao+Atividade
					dbSeek(xFilial("JDA")+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP+JBQ->JBQ_CODAVA)
		
					While 	JDA->JDA_FILIAL == xFilial("JDA")  .And.;
							JDA->JDA_CODCUR == TRB->CURSO	   .And.;
							JDA->JDA_PERLET == TRB->SERIE	   .And.;
							JDA->JDA_TURMA  == TRB->TURMA	   .And.;
							JDA->JDA_CODDIS == TRB->DISCIP	   .And.;
							JDA->JDA_CODAVA == JBQ->JBQ_CODAVA
						 
						cCabAtiv += STR0054+JDA->JDA_ATIVID+" "	// "Ava"
							   
						Aadd(aAtividades,JBQ->JBQ_CODAVA)
														
						dbSkip()
									
					EndDo		
					
					cCabAtiv   += Iif(Empty(cCabAtiv),STR0048,STR0047)	//  "Notas"#"Media"
					cDescCab2B += Iif(Len(cCabAtiv)>Len(AllTrim(JBQ->JBQ_DESC)),PadC(AllTrim(JBQ->JBQ_DESC),Len(cCabAtiv),"."),AllTrim(JBQ->JBQ_DESC))+" "
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cria coluna para nota da segunda chamada da avaliacao ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  JBQ->JBQ_CHAMAD == "1"

						cDescCab2B += STR0057+" "
						cCabAtiv   += " "+STR0048	//  "Notas"
						
						aAvaliacao[Len(aAvaliacao)][2] := "S"
						
					EndIf
					
					cDescCab3B += Iif(Len(cCabAtiv)>Len(AllTrim(JBQ->JBQ_DESC)),cCabAtiv,PadC(cCabAtiv,Len(AllTrim(JBQ->JBQ_DESC))))+" "
					nTamAval   += Len(Iif(Len(cCabAtiv)>Len(AllTrim(JBQ->JBQ_DESC)),cCabAtiv,AllTrim(JBQ->JBQ_DESC)))+1

					dbSelectArea("JBQ")	// Periodo Letivo x Avaliacoes
					dbSkip()
					
				EndDo
	
				cDescCab1B += PadC(STR0050,nTamAval-1,"_")+Space(37)	// "AVALIACOES"
				cDescCab2B += STR0051+Space(31)	   						// "MEDIA"
				cDescCab3B += (STR0052+" "+STR0023)+Space(22)			// "FINAL"#"SITUACAO"
	
				nPosCabFal := ( 220 - (nTamCabFal+Len(cDescCab1B)+10) )
				nPosTotFal := ((220-Len(cDescCab2B)) + 2)+(AT(STR0031,cDescCab2b)-1)
	
			EndIf
			
	    EndIf
	    
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Cabecalho. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaCabDia(aCabFaltas,nTamCabFal,cDescCab1A,@cDescCab1B,cDescCab2A,@cDescCab2B,cDescCab3A,@cDescCab3B,@nLin,@lExec,nPosCabFal)

	dbSelectArea("TRB")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quebra por Curso+Periodo+Turma+Disciplina ou por estouro do tamanho da pagina ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While 	TRB->CURSO  == cCurso      .And.;
			TRB->SERIE  == cSerie      .And.;
			TRB->TURMA  == cTurma      .And.;
			TRB->DISCIP == cDisciplina .And.;
			TRB->MATPRF == cMatPrf     .And. !Eof() .And. (nLin < 53)

		If !lWeb
			IncRegua()
		Endif
	
	  	If lEnd
			Exit
		EndIf                                      

		nOrdem++                                                 
		
		@ nLin,000 PSAY StrZero(nOrdem,3) Picture "999" 	// Numero de controle da lista
		@ nLin,005 PSAY TRB->RA 							// RA do aluno
		@ nLin,021 PSAY Left(TRB->SITDIS,3)
		@ nLin,025 PSAY Left(TRB->ALUNO,40)					// Nome do aluno

		If (JAR->JAR_APFALT # "3")	// Apontamento Diario ou Mensal

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Zera array de faltas do aluno ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nInd:=1 To Len(aFaltas)
				aFaltas[nInd][3] := 0
			Next nInd

		EndIf
		
		aLinFal := {}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime faltas. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaFaltas(aFaltas,@nLin,@nTotFaltas,cDescCab1B,@aLinFal)

		@ nLin,nPosTotFal PSAY Str(nTotFaltas,3)

		nPosImp := nPosTotFal+8
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Loop para impressao das notas do aluno. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nInd:=1 To Len(aAvaliacao)
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Para cada avaliacao verificar se existe Notas por Atividade relacionadas ³
			//³ a esta adaptando o cabecalho de detalhes e armaze                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("JDC")	// Itens de Apontamento de Notas por Atividades
			dbSetOrder(2)		// Ordem: RA+Curso+Periodo Letivo+Turma+Disciplina+Avaliacao+Atividade+Tipo de Aluno

			If dbSeek(xFilial("JDC")+TRB->RA+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP+aAvaliacao[nInd][1])

				While 	JDC->JDC_FILIAL == xFilial("JDC")  .And.;
						JDC->JDC_NUMRA  == TRB->RA		   .And.;
						JDC->JDC_CODCUR == TRB->CURSO	   .And.;
						JDC->JDC_PERLET == TRB->SERIE	   .And.;
						JDC->JDC_TURMA  == TRB->TURMA	   .And.;
						JDC->JDC_CODDIS == TRB->DISCIP	   .And.;
						JDC->JDC_CODAVA == aAvaliacao[nInd][1]
					
					If lConceito
					 	@ nLin,nPosImp PSAY Iif(Empty(JDC->JDC_NOTA),PadL(cMV_ACCHRNC,5),PadC(JDC->JDC_CONCEI,5))
					Else	
						@ nLin,nPosImp PSAY Iif(Empty(JDC->JDC_NOTA) .And. JDC->JDC_COMPAR=="2",PadC(cMV_ACCHRNC,5),Str(JDC->JDC_NOTA,5,2))
					EndIf	
					
					nPosImp += 6
			
					dbSkip()
								
				EndDo		
				
			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso houver relacao com apontamento de notas por atividades e estas ³
				//³ ainda nao tiverem sido apontadas, imprime "N/C" para estas          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				For nAtiv:=1 To Len(aAtividades)

					If aAtividades[nAtiv] == aAvaliacao[nInd][1]
		
					 	@ nLin,nPosImp PSAY PadL(cMV_ACCHRNC,5)
				
						nPosImp += 6
					
					EndIf
								
				Next nAtiv
					
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se Existe nota para a Avaliacao³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("JBS")	//	Itens do Apontamento de Notas do Aluno
			dbSetOrder(2) 		//	Ordem: Ra+Curso+Periodo+Turma+Diciplina+Avaliacao
			
			If dbSeek(xFilial("JBS")+TRB->RA+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP+aAvaliacao[nInd][1])
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso a nota corresponde a 2.Chamada imprime N/C para a nota normal do GQ ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(JBS->JBS_DTCHAM) .and. aAvaliacao[nInd][2] == "S"

				  	@ nLin,nPosImp PSAY PadC(cMV_ACCHRNC,5)

					nPosImp += 6
					
				EndIf

				If lConceito
				  	@ nLin,nPosImp PSAY Iif(Empty(JBS->JBS_CONCEI),PadC(cMV_ACCHRNC,5),PadC(JBS->JBS_CONCEI,5))
				Else	
					@ nLin,nPosImp PSAY Iif(Empty(JBS->JBS_NOTA),PadC(cMV_ACCHRNC,5),Str(JBS->JBS_NOTA,5,2))
				EndIf	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso exista coluna referente a 2.Chamada considera espaco reservado para esta ³
				//³se nao houve apontamento de nota.                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty(JBS->JBS_DTCHAM) .and. aAvaliacao[nInd][2] == "S"
					nPosImp += 6
				EndIf

				nPosImp += 6
				
			Else	
				
				@ nLin,nPosImp PSAY PadC(cMV_ACCHRNC,5)

				nPosImp += 6
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso exista coluna referente a 2.Chamada considera espaco reservado para esta ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aAvaliacao[nInd][2] == "S"
					nPosImp += 6
				EndIf

			EndIf	
			
		Next nInd
	    
		If lConceito
			@ nLin,nPosImp PSAY if(Empty(TRB->MEDCON),NotCon(TRB->MEDIA),TRB->MEDCON)
		Else	
        	If !Empty(TRB->MEDIA)
				@ nLin,nPosImp PSAY TRB->MEDIA Picture "@E 99.99" 	
			EndIf
		EndIf	

		nPosImp += 6
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem a descricao da Situacao do Aluno.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDescBox := AcaX3Combo("JC7_SITUAC",TRB->SITUAC)
			
		@ nLin,nPosImp PSAY cDescBox	// Situacao do aluno na disciplina

		nLinFal := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime linhas complementares de faltas. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nInd:=1 To Len(aLinFal)

			If nLinFal # aLinFal[nInd][3]
				nLinFal := aLinFal[nInd][3]
				nLin++    
			EndIf
				
			@ nLin,aLinFal[nInd][1] PSAY aLinFal[nInd][2]
			
		Next nInd

		nLin++    
 
 		dbSelectArea("TRB") 
		dbSkip()

	EndDo  
	
  	If lEnd
		nLin += 3
		@ PROW()+1,001 PSAY STR0056 // "CANCELADO PELO OPERADOR"
		Exit
	EndIf                        

	If 	( TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP+TRB->MATPRF # cCurso+cSerie+cTurma+cDisciplina+cMatPrf )

		lExec := .t.
			
		nLin++
		@ nLin,000 PSAY __PrtThinLine()
		nLin++
		@ nLin,00 PSAY "OBS:"
		nLin += 4
            

		@ nLin,000 PSAY "_____/_____/_____"
		@ nLin,100 PSAY Iif(Empty(cProfessor)," ",Replicate("_",30))
		@ nLin,(220-Len(STR0015)) PSAY Replicate("_",Len(STR0015)) // "  COORDENADOR(A) / DIRETOR(A)  "
		nLin++
	
		@ nLin,006 PSAY STR0013
		@ nLin,100 PSAY Iif(Empty(cProfessor)," ",PadC(cProfessor,30))
		@ nLin,(220-Len(STR0015)) PSAY STR0015 // "  COORDENADOR(A) / DIRETOR(A)  "
                                         
	EndIf

	Roda(cbcont,cbtxt,tamanho)
	
EndDo	

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AcaCabDia³ Autor ³ Marco Aurelio         ³ Data ³ 26/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Cabecalho.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AcaCabDia(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6,ExpC7)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Descricao da primeira linha do cabecalho - Parte A ³±±
±±³          ³ ExpC2 : Descricao da primeira linha do cabecalho - Parte B ³±±
±±³          ³ ExpC3 : Descricao da segunda  linha do cabecalho - Parte A ³±±
±±³          ³ ExpC4 : Descricao da segunda  linha do cabecalho - Parte B ³±±
±±³          ³ ExpC5 : Descricao da terceira linha do cabecalho - Parte A ³±±
±±³          ³ ExpC6 : Descricao da terceira linha do cabecalho - Parte B ³±±
±±³          ³ ExpN7 : Numero da linha de impressao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AcaDiario                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AcaCabDia(aCabFaltas,nTamCabFal,cDescCab1A,cDescCab1B,cDescCab2A,cDescCab2B,cDescCab3A,cDescCab3B,nLin,lExec,nPosCabFal)
Local cDesPer := Iif(mv_par10 == "01", STR0011, STR0012)  // "Primeiro"###"Segundo"
Local cCabec1 := ""
Local nTam    := 0
Local nLinFal := 0
Local nInd    := 0
Local nCab    := 0
Local cCabec2  := ""
Local cArea    := Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_AREA")
Local cProf    := Posicione("SRA",1,xFilial("SRA")+TRB->MATPRF,"RA_NOME")			
Local cUnidade := STR0026+TRB->UNIDADE+" "+AllTrim(Posicione("JA3",1,xFilial("JA3")+TRB->UNIDADE,"JA3_DESLOC"))
Local cPredio  := STR0033+AllTrim(Posicione("JA4",1,xFilial("JA4")+TRB->UNIDADE+TRB->PREDIO,"JA4_DESPRE"))						
Local cSala    := AllTrim(Posicione("JA5",1,xFilial("JA5")+TRB->UNIDADE+TRB->PREDIO+TRB->ANDAR+TRB->SALA,"JA5_DESCSA"))						
Local cDCurso  := STR0016+AllTrim(TRB->CURPAD)+"/"+TRB->CURSO+" - "+AllTrim(JAH->JAH_DESC)+" "+STR0027+ TRB->SERIE+"ª "+TRB->TURMA
Local cCargaH  := ''
Local cAnoSem  := STR0025+mv_par09+" "+STR0024+cDesPer	
Local cDesUnid := Posicione("JA3",1,xFilial("JA3") + TRB->UNIDADE,"JA3_DESLOC")

JAE->( dbSetOrder(1) )
JAE->( dbSeek( xFilial("JAE")+TRB->DISCIP ) )

cCargaH := STR0020+Padr(AllTrim(Transform(JAE->JAE_CARGA,"@E 9,999")),5)

Titulo := STR0001 +" "+ AllTrim(SM0->M0_NOME) + " - " + cDesUnid  //"Lista de Presenca"

Cabec(titulo,cCabec1,cCabec2,NomeProg,Tamanho,Iif(aReturn[4] == 1, 15, 18))

nLin  := 08
cArea := AllTrim(STR0032+Posicione("JAG",1,xFilial("JAG")+cArea,"JAG_DESC"))
nTam  := Len(cArea)

If Len(AllTrim(cCargaH)) > nTam
	nTam := Len(cCargaH)
EndIf

If 	Len(AllTrim(cAnoSem)) > nTam
	nTam := Len(cAnoSem)
EndIf	

If 	Len(AllTrim(cArea)) > nTam
	nTam := Len(cAreaSem)
EndIf	

@ nLin,000        PSAY STR0028+cProf										// Professor:
nLin++
@ nLin,000        PSAY STR0019+AllTrim(TRB->DISCIP)+" - "+JAE->JAE_DESC		// Disciplina: 
@ nLin,(220-nTam) PSAY cArea												// Area#Sem. Letivo 
nLin++
@ nLin,000        PSAY cDCurso 												// Curso: 
@ nLin,(220-nTam) PSAY cCargaH												// Carga Horaria:
nLin++
@ nLin,000        PSAY cUnidade+" "+cPredio+" "+cSala						// Unidade#Predio/Sala
@ nLin,(220-nTam) PSAY cAnoSem												// Ano:#Sem. Civil 
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++

nLinFal := Iif(Len(aCabFaltas) > 3,(Len(aCabFaltas)-3),0 )

If (JAR->JAR_APFALT == "1")	// Apontamento Diario
                                                        
	If nLinfal > 0
	
		For nInd:=1 To nLinFal
			@ nLin,nPosCabFal PSAY PadR(aCabFaltas[nInd],nTamCabFal)
			nLin++
		Next nInd
	          
		If lExec
		
			lExec   := .f.
			nLinFal := nInd 
			nCab    := 1
			
			For nInd:=nLinFal To Len(aCabFaltas)
	
				If nCab == 1
					cDescCab1B := PadR(aCabFaltas[nInd],nTamCabFal)+Space(10)+cDescCab1B
				ElseIf nCab == 2
					cDescCab2B := PadR(aCabFaltas[nInd],nTamCabFal)+cDescCab2B
				Else	
					cDescCab3B := PadR(aCabFaltas[nInd],nTamCabFal)+cDescCab3B
				EndIf	
	
				nCab++
		
			Next nInd
			
		EndIf
		
	Else		
	
		If lExec
	
			lExec := .f.
			
			For nInd:=1 To Len(aCabFaltas) 
	
				If nInd == 1
					cDescCab1B := PadR(aCabFaltas[nInd],nTamCabFal)+Space(10)+cDescCab1B
				ElseIf nInd == 2
					cDescCab2B := PadR(aCabFaltas[nInd],nTamCabFal)+cDescCab2B
				Else	
					cDescCab3B := PadR(aCabFaltas[nInd],nTamCabFal)+cDescCab3B
				EndIf	
	
			Next nInd

		EndIf
		
	EnDif
		
EndIf

If !Empty(cDescCab1A+cDescCab1B)
	@ nLin, 000 PSAY cDescCab1A
	@ nLin,(220-Len(cDescCab1B)) PSAY cDescCab1B
	nLin++                               
EndIf
If !Empty(cDescCab2A+cDescCab2B)
	@ nLin, 000 PSAY cDescCab2A
	@ nLin,(220-Len(cDescCab2B)) PSAY cDescCab2B
	nLin++                               
EndIf
If !Empty(cDescCab3A+cDescCab3B)
	@ nLin, 000 PSAY cDescCab3A
	@ nLin,(220-Len(cDescCab3B)) PSAY cDescCab3B
	nLin++                               
EndIf
@ nLin,000 PSAY __PrtThinLine()
nLin += 1

Return Nil






/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AcaMeses ³ Autor ³ Marco Aurelio         ³ Data ³ 26/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta array extenso dos meses referentes ao periodo letivo ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AcaMeses()   			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 : Determina o conteudo de retorno .                  ³±±
±±³          ³ ExpN2 : Numero referente ao mes.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AcaDiario                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AcaMeses(lRetMes,nMes)
Local nInd   := 0
Local nMeses := 0
Local xMesRet:= {}
Local aMeses := {	STR0035, STR0036, STR0037, ;// Jan###Fev###Mar
					STR0038, STR0039, STR0040, ;// Abr###Mai###Jun
					STR0041, STR0042, STR0043, ;// Jul###Ago###Set
					STR0044, STR0045, STR0046 }	// Out###Nov###Dez


Local dDataDe,dDataAte

JAR->( dbSetOrder(1) )	// Ordem: Curso + Periodo Letivo
JAR->( dbSeek(xFilial("JAR")+TRB->CURSO+TRB->SERIE) )

JBL->(dbSetOrder(1)) 		// Curso+Periodo+Turma+Disciplina+Professor				
JBL->(dbSeek(xFilial("JBL")+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP+TRB->MATPRF))
				
dDataDe		:= Iif(Empty(JBL->JBL_DATA1),JAR->JAR_DATA1,JBL->JBL_DATA1)
dDataAte	:= Iif(Empty(JBL->JBL_DATA2),JAR->JAR_DATA2,JBL->JBL_DATA2)

If lRetMes
	xMEsRet := aMeses[nMes]
Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ calcula o numero de meses existentes entre o inicio do periodo e o fim ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMeses := 1 + ((Year(dDataAte)*12) + Month(dDataAte)) - ((Year(dDataDe)*12) + Month(dDataDe))
	
	For nInd:=0 To If(nMeses > 1, nMeses-1, 0)	// Seguranca contra datas finais menores que datas iniciais. Vai saber...
		
		If (Month(dDataDe) + nInd) <= 12
			Aadd(xMesRet,{aMeses[Month(dDataDe)+nInd],StrZero(Month(dDataDe)+nInd,2,0)})
		Else
			Aadd(xMesRet,{aMeses[Month(dDataDe)+nInd-12],StrZero(Month(dDataDe)+nInd-12,2,0)})
		Endif
		
	Next nInd

EndIf
	
Return(xMesRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AcaFaltas ³ Autor ³ Marco Aurelio        ³ Data ³ 26/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna quantidade de faltas de um aluno conforme parametro³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AcaFaltas(ExpA1,ExpN1,ExpN1,ExpN3)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com dados de posicionamento para impressao   ³±±
±±³          ³         das faltas                                         ³±±
±±³          ³ ExpN1 = Contador das linhas de impressao                   ³±±
±±³          ³ ExpN2 = Totalizador de faltas                              ³±±
±±³          ³ ExpN3 = Posicao de Impressao                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AcaDiario                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AcaFaltas(aFaltas,nLin,nTotFaltas,cDescCab1B,aLinFal)
Local nColFal := 0
Local nElem   := 0
Local nInd    := 0
Local nLinFal := 0
Local nColIni := 0

nTotFaltas := 0

dbSelectArea("JCH")	// Itens de Apontamento de faltas
dbSetOrder(2) 		// RA+Curso+Periodo+Turma+Diciplina                                             

dbSeek(xFilial("JCH")+TRB->RA+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP)
	
While 	JCH->JCH_FILIAL+JCH->JCH_NUMRA+JCH->JCH_CODCUR+JCH->JCH_PERLET+JCH->JCH_TURMA+JCH->JCH_DISCIP ==;
		xFilial("JCH")+TRB->RA+TRB->CURSO+TRB->SERIE+TRB->TURMA+TRB->DISCIP		
		
	If (JAR->JAR_APFALT # "3")	// Apontamento Dario ou Mensal

		If (JAR->JAR_APFALT == "1")	// Apontamento Diario
			nElem := aScan(aFaltas,{|x| x[1]+x[4]==StrZero(Month(JCH->JCH_DATA),2)+StrZero(Day(JCH->JCH_DATA),2)})
		Else						// Apontamento Mensal
			nElem := aScan(aFaltas,{|x| x[1]==StrZero(Month(JCH->JCH_DATA),2)}) 
		EndIf

		If nElem>0			
			aFaltas[nElem][3] := JCH->JCH_QTD
		EndIf	
		
	EndIf	
		
	nTotFaltas += JCH->JCH_QTD
	
	dbSkip()
	
EndDo

If (JAR->JAR_APFALT # "3")	// Apontamento Dario ou Mensal

	For nInd:=1 To Len(aFaltas)

		If nLinFal # aFaltas[nInd][5]
			nColIni := aFaltas[nInd][2]
			nLinFal := aFaltas[nInd][5]
		EndIf
			
		nColFal := aFaltas[nInd][2] 
		nColFal += ( (220-Len(cDescCab1B) - nColIni) + If(JAR->JAR_APFALT == "1",4,0))
		
		If nLinFal == 1
			@ nLin,nColFal PSAY Str(aFaltas[nInd][3],Iif(JAR->JAR_APFALT=="1",2,3))
		Else
			Aadd(aLinFal,{nColFal,Str(aFaltas[nInd][3],2),aFaltas[nInd][5]})
		EndIf	
		
	Next	
	                  
EndIf

Return(Nil)


/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³NotCon    ³ Autor ³ Rafael Rodrigues      ³ Data ³ 01/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Converte uma nota em um conceito.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ NotCon()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ACAR270                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NotCon( nMedia )
local cRet := ""

JAR->( dbSetOrder(1) ) // Ordem: Curso Vigente + Periodo Letivo
JAR->( dbSeek( xFilial("JAR")+TRB->CURSO+TRB->SERIE ) ) 

JDF->( dbSetOrder(1) )
JDF->( dbSeek( xFilial("JDF")+JAR->JAR_EQVCON ) )

while JDF->( !eof() ) .and. JDF->( JDF_FILIAL+JDF_CODIGO ) == xFilial("JDF")+JAR->JAR_EQVCON

	If ( nMedia >= JDF->JDF_NOTINI) .and. ( nMedia <= JDF->JDF_NOTFIN )
					
		cRet := JDF->JDF_CONCEI
					
		Exit
					
	EndIf
	JDF->(dbSkip())
end

Return cRet
