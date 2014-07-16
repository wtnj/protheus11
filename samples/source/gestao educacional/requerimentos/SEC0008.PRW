#include "rwmake.ch"
#define CRLF	Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0008a  ºAutor  ³Gustavo Henrique    º Data ³  19/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra do Script do Requerimento de Avaliacao Substitutiva   º±±
±±º          ³Verifica se o aluno pode fazer a avaliacao substitutiva.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³ExpC1 : RA do aluno.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se a gravacao obteve sucesso             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
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

User Function SEC0008a( lWeb )

Local lRet		:= .T.
Local aRet      := {}
Local cCurso	:= ""
Local cPerLet	:= ""
Local cHabili	:= ""
Local cTurma	:= ""
Local cDiscip	:= ""
Local cCodAva	:= ""

lWeb := IIf(lWeb == NIL, .F., lWeb)

if lWeb
	
	cNumra	 	:= HttpSession->ra
	cCurso		:= HttpSession->ccurso
	cPerLet		:= Httpsession->perlet
	cTurma		:= Httpsession->turma
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG04      ³ HABILITACAO
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// pesquisar nos dados recebidos do formulario o PERG04
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG04" } )
	
	if nPos > 0
		cHabili := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG11      ³ DISCIPLINA
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// pesquisar nos dados recebidos do formulario o PERG09
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG11" } )
	
	if nPos > 0
		cDiscip := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG15      ³ CODIGO DA AVALIACAO
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// pesquisar nos dados recebidos do formulario o PERG13
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG15" } )
	
	if nPos > 0
		cCodAva := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	
else
	
	cNumRA     	:= M->JBH_CODIDE
	cCurso		:= M->JBH_SCP01
	cPerLet		:= M->JBH_SCP03
	cHabili		:= M->JBH_SCP04
	cTurma		:= M->JBH_SCP06
	cDiscip		:= M->JBH_SCP11
	cCodAva		:= M->JBH_SCP15
	
endif

// JBS_FILIAL + JBS_NUMRA + JBS_CODCUR + JBS_PERLET + JBS_HABILI + JBS_TURMA + JBS_CODDIS + JBS_CODAVA
JBS->( dbSetOrder( 2 ) )

If JBS->( dbSeek( xFilial( "JBS" ) + SubStr( cNumRA, 1, 15 ) + cCurso + cPerLet + cHabili + cTurma + cDiscip + cCodAva ) )
	
	If JBS->JBS_COMPAR == "1"
		If lWeb
			aadd(aRet,{.F.,"O aluno já fez a avaliação solicitada."})
		Else
			MsgStop( "O aluno já fez a avaliação solicitada." )
			lRet := .F.
		EndIf
	EndIf
	
EndIf

Return( iif( lWeb, aRet, lRet ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0008b  ºAutor  ³Gustavo Henrique    º Data ³  20/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra Inicial do Requerimento de Avaliacao Substitutiva     º±±
±±º          ³Envia e-mail para o professor da disciplina informando que  º±±
±±º          ³deve aplicar a avaliacao substitutiva para o aluno.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³ExpC1 : RA do aluno.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se executou a regra com sucesso          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
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
User Function SEC0008b()

Local lRet			:= .F.
Local aScript		:= ACScriptReq( JBH->JBH_NUM )
Local cMsg			:= ""
Local cEmail		:= ""
Local cEmailCoor	:= ""
Local lCoSemMail	:= .F.		// Indica se os coordenadores estão sem e-mail

// Estrutura do aScript
// aScript[01] - Curso do aluno
// aScript[02] - Descricao
// aScript[03] - Periodo Letivo
// aScript[04] - Turma
// aScript[05] - Ano Letivo
// aScript[06] - Semestre
// aScript[07] - Telefone
// aScript[08] - Tipo da disciplina
// aScript[09] - Disciplina
// aScript[10] - Descricao
// aScript[11] - Regime
// aScript[12] - Descricao
// aScript[13] - Avaliacao
// aScript[14] - Descricao

// Posiciona tipo de requerimento da solicitacao
JBF->( dbSetOrder( 1 ) )
JBF->( dbSeek( xFilial( "JBF" ) + JBH->JBH_TIPO + JBH->JBH_VERSAO ) )

// Posiciona no aluno
JA2->( dbSetOrder( 1 ) )
JA2->( dbSeek( xFilial( "JA2" ) + SubStr(JBH->JBH_CODIDE, 1, 15) ) )

// Posiciona no apontamento de nota
JBL->( dbSetOrder( 1 ) ) // JBL_FILIAL + JBL_CODCUR + JBL_PERLET + JBL_HABILI + JBL_TURMA + JBL_CODDIS + JBL_MATPRF
JBL->( dbSeek( xFilial("JBL") + aScript[1] + aScript[3] + aScript[4] + aScript[6] + aScript[11] ))

// Busca o e-mail do professor
SRA->( dbSetOrder( 1 ) )
SRA->( dbSeek( xFilial( "SRA" ) + JBL->JBL_MATPRF ) )

// Posiciona no curso do aluno
JAH->( dbSetOrder( 1 ) )
JAH->( dbSeek( xFilial("JAH") + aScript[1] ) )

cMsg := "Prezado Professor"
cMsg += CRLF + CRLF
cMsg += "O requerimento acima mencionado foi deferido para o aluno " + JA2->JA2_NOME
cMsg += " matriculado sob o RA número " + AllTrim( JBH->JBH_CODIDE )
cMsg += ", no curso de " + Rtrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))
cMsg += ", na unidade " + Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC" )
cMsg += CRLF
cMsg += " A avaliação solicitada pelo aluno é a " + aScript[15] + " - " + aScript[16]
cMsg += " referente a disciplina " + aScript[11] + " - " + aScript[12]
cMsg += CRLF + CRLF
cMsg += "Secretaria de Registros Acadêmicos" + CRLF
cMsg += "Microsiga Intelligence"

If ! Empty( SRA->RA_EMAIL )
	cEmail := AllTrim( SRA->RA_EMAIL ) + ";"
EndIf

// Busca os coordenadores do curso para enviar copia do e-mail
JAJ->( dbSetOrder( 1 ) )
JAJ->( dbSeek( xFilial("JAJ") + aScript[1] ) )

Do While JAJ->( ! EoF() .and. JAJ_CODCUR == aScript[1] )
	
	SRA->( dbSetOrder( 1 ) )
	SRA->( dbSeek( xFilial( "SRA" ) + JAJ->JAJ_CODCOO ) )
	
	If ! Empty( SRA->RA_EMAIL )
		cEmailCoor += AllTrim(SRA->RA_EMAIL) + ";"
	Else
		lCoSemMail := .T.
	EndIf
	
	JAJ->( dbSkip() )
	
EndDo

If Empty( cEmail )
	If lCoSemMail
		MsgStop( "Não foi informado e-mail para o professor da disciplina : " + RTrim(aScript[11]) + " - " + RTrim(aScript[12]) +;
		", e para o coordenador do curso : " + RTrim(aScript[1]) + " - " + RTrim(aScript[2]))
	Else
		MsgInfo( "Não foi informado e-mail para o professor da disciplina : " + RTrim(aScript[11]) + " - " + RTrim(aScript[12]) )
	EndIf
ElseIf lCoSemMail
	MsgInfo( "Não foi informado e-mail para o coordenador do curso: " + RTrim(aScript[1]) + " - " + RTrim(aScript[2]) )
EndIf

If ! Empty( cEmail ) .or. ! Empty( cEmailCoor )
	lRet := ACSendMail( ,,,, cEmail + cEmailCoor, "Requerimento " + AllTrim(JBH->JBH_NUM) + " - " + AllTrim(JBF->JBF_DESC), cMsg )
EndIf

If lRet
	// Finaliza o requerimento automaticamente.
	U_SEC0008c( JBH->JBH_NUM )
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0008c  ºAutor  ³Gustavo Henrique    º Data ³  02/set/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Finalizar o requerimento de Avaliacao Substitutiva          º±±
±±º          ³automaticamente.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1 : RA do aluno.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se executou a regra com sucesso          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0008c( cNumReq )

Begin Transaction

// Grava status do header da solicitacao como deferido
JBH->( dbSetOrder( 1 ) )
JBH->( dbSeek( xFilial( "JBH" ) + cNumReq ) )

RecLock( "JBH", .F. )
JBH->JBH_STATUS := "1"
MsUnlock()

// Grava status do departamento como deferido
JBI->( dbSetOrder( 1 ) )
JBI->( dbSeek( xFilial( "JBG" ) + cNumReq ) )

RecLock( "JBI", .F. )

JBI->JBI_STATUS	:= "1"
JBI->JBI_DTSAI	:= dDataBase
JBI->JBI_HRSAI	:= Time()

MsUnlock()

End Transaction

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0008d º Autor ³ Gustavo Henrique   º Data ³  22/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida a disciplina selecionada.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Indica se esta sendo chamado da Web.               º±±
±±º          ³ EXPC2 - Numero do RA do aluno                              º±±
±±º          ³ EXPC3 - Curso em que o aluno estah matriculado             º±±
±±º          ³ EXPC4 - Periodo letivo                                     º±±
±±º          ³ EXPC5 - Habilitacao                                        º±±
±±º          ³ EXPC6 - Turma                                              º±±
±±º          ³ EXPC7 - Disciplina                                         º±±
±±º          ³ EXPC8 - Tipo de disciplina                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de Avaliacao Substitutiva e Revisao de Prova  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0008d( lWeb, cRA, cCurso, cPerLet, cHabili, cTurma, cDiscip, cTpDis )

local lRet    := .T.
local aRet    := {}
local aSx3Box := {}
local cDesSit := ""

cRA     := PadR( cRA, TamSX3( "JA2_NUMRA" )[1] )
lWeb := iif( lWeb == NIL, .F., lWeb )

lRet := ExistCpo( "JAE", cDiscip )

if lRet
	
	JC7->( dbSetOrder( 1 ) )
	
	lRet := JC7->( dbSeek( xFilial( "JC7" ) + cRA + cCurso + cPerLet + cHabili + cTurma + cDiscip ) )
	
	if ! lRet
		
		if lWeb
			aadd(aRet,{.F.,"Selecione uma disciplina que exista na grade curricular do aluno."})
		else
			MsgStop( "Selecione uma disciplina que exista na grade curricular do aluno." )
		endif
		
	else
		
		if JC7->JC7_SITUAC $ "789"	// 7=Trancado; 8=Dispensado; 9=Cancelado
			
			aSX3Box := RetSx3Box( Posicione("SX3", 2, "JC7_SITUAC", "X3CBox()" ),,, 1 )
			cDesSit := AllTrim( Lower( aSx3Box[ aScan( aSx3Box, { |aBox| aBox[2] = JC7->JC7_SITUAC } )][3] ) )
			lRet	:= .F.
			
			if lWeb
				aadd(aRet,{.F.,"A situação desta disciplina é : " + cDesSit + ", portanto ela não pode ser selecionada."})
			else
				MsgStop( "A situação desta disciplina é : " + cDesSit + ", portanto ela não pode ser selecionada." )
			endif
			
		endif
		
		if lRet
			
			if cTpDis == "4"	// 4=Nota Unica
				
				if ! Empty( JC7->JC7_OUTCUR )
					lRet := ( Posicione( "JAS", 2, xFilial( "JAS" ) + JC7->( JC7_OUTCUR + JC7_OUTPER + JC7_OUTHAB + JC7_DISCIP ), "JAS_TIPNOT" ) == "1" )
				else
					lRet := ( Posicione( "JAS", 2, xFilial( "JAS" ) + JC7->( JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_DISCIP ), "JAS_TIPNOT" ) == "1" )
				endif
				
				if ! lRet
					
					if lWeb
						aadd(aRet,{.F.,"Ao escolher o tipo 4=Nota Única no script, selecione uma disciplina de Nota Única."})
					else
						MsgStop( "Ao escolher o tipo 4=Nota Única no script, selecione uma disciplina de Nota Única." )
					endif
					
				endif
				
			else
				
				if ! Empty( JC7->JC7_OUTCUR )
					lRet := ( Posicione( "JAS", 2, xFilial( "JAS" ) + JC7->( JC7_OUTCUR + JC7_OUTPER + JC7_OUTHAB + JC7_DISCIP ), "JAS_TIPNOT" ) # "1" )
				else
					lRet := ( Posicione( "JAS", 2, xFilial( "JAS" ) + JC7->( JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_DISCIP ), "JAS_TIPNOT" ) # "1" )
				endif
				
				if ! lRet
					
					if lWeb
						aadd(aRet,{.F.,"Para selecionar uma disciplina de Nota Única, escolha o tipo 4=Nota Única no script."})
					else
						MsgStop( "Para selecionar uma disciplina de Nota Única, escolha o tipo 4=Nota Única no script." )
					endif
					
				endif
				
			endif
			
			if lRet .and. ! lWeb
				M->JBH_SCP12 := Posicione( "JAE", 1, xFilial( "JAE" ) + JC7->JC7_DISCIP, "JAE_DESC" )
				M->JBH_SCP13 := JC7->JC7_SITDIS
				M->JBH_SCP14 := Tabela( "F3", JC7->JC7_SITDIS, .F. )
			endif
			
		endif
		
	endif
	
endif

Return( iif( lWeb, aRet, lRet ) )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0008e º Autor ³ Gustavo Henrique   º Data ³  24/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validar a avaliacao selecionada.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Indica se esta sendo chamado pela Web              º±±
±±º          ³ EXPL2 - Indica se esta sendo chamado do requerimento de    º±±
±±º          ³         Revisao de Prova.                                  º±±
±±º          ³ EXPC3 - Regime em que a disciplina estah sendo cursada     º±±
±±º          ³ EXPC4 - Codigo da avaliacao                                º±±
±±º          ³ EXPC5 - Tipo da disciplina                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de Avaliacao Substitutiva e Revisao de Prova  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0008e( lWeb, lRevisao, cRegime, cCodAva, cTpDis )
Local aRet := {}

local lRet

lWeb     := iif( lWeb     == NIL, .F., lWeb     )
lRevisao := iif( lRevisao == NIL, .F., lRevisao )

JBQ->( dbSetOrder( 3 ) )

if cRegime $ "001/002/006"
	lRet := JBQ->( dbSeek( xFilial( "JBQ" ) + JC7->( JC7_OUTCUR + JC7_OUTPER + JC7_OUTHAB ) + cCodAva ) )
else
	lRet := JBQ->( dbSeek( xFilial( "JBQ" ) + JC7->( JC7_CODCUR + JC7_PERLET + JC7_HABILI ) + cCodAva ) )
endif

if ! lRet
	
	if lWeb
		aadd( aRet, {.F., "Avaliação inválida para a disciplina selecionada." } )
	else
		MsgStop( "Avaliação inválida para a disciplina selecionada." )
	endif
	
else
	
	if cTpDis == "4" .and. JBQ->JBQ_TIPO # "4"
		
		lRet := .F.
		
		if lWeb
			aadd( aRet, {.F., "Selecione uma avaliação de Nota Única." } )
		else
			MsgStop( "Selecione uma avaliação de Nota Única." )
		endif
		
	elseif cTpDis # "4" .and. JBQ->JBQ_TIPO == "4"
		
		lRet := .F.
		
		if lWeb
			aadd( aRet, {.F., "Para selecionar uma avaliação de Nota Única, você deve escolher o tipo de disciplina Nota Única." } )
		else
			MsgStop( "Para selecionar uma avaliação de Nota Única, você deve escolher o tipo de disciplina Nota Única." )
		endif
		
	endif
	
	if lRet
		
		lRet := iif( lRevisao, .T., ( JBQ->JBQ_CHAMAD # "2" ) )
		
		if ! lRet
			
			if lWeb
				aadd( aRet, {.F., "Esta avaliação não possui 2a. chamada. Selecione outra avaliação." } )
			else
				MsgStop( "Esta avaliação não possui 2a. chamada. Selecione outra avaliação." )
			endif
			
		elseif ! lWeb
			
			M->JBH_SCP16 := JBQ->JBQ_DESC
			
		endif
		
	endif
	
endif

Return( iif( lWeb, aRet, lRet ) )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0008f º Autor ³ Gustavo Henrique   º Data ³  12/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Encapsulamento para chamada das funcoes do requerimento    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de Avaliacao Substitutiva e Revisao de Prova  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0008f( lRevisao )
Local aRet    := {}
Local aArea   := GetArea()
Local nPos    := 0
Local cTDisc  := ""
Local cDisc   := ""
Local cRegime := ""
Local cCodAva := ""
Local cHabili := ""
           
lRevisao := IIf(lRevisao == NIL, .F., lRevisao)

if ! lRevisao
	if ExistBlock("SEC0008A")
		aRet := U_SEC0008A( .T. )
	endif
else
	if ExistBlock("SEC0024A")
		aRet := U_SEC0024A( .T. )
	endif
endif

if len(aRet) == 0 // continua validacao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³**** validar disciplina selecionada ***³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG04      ³ HABILITACAO
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// pesquisar nos dados recebidos do formulario o PERG08
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG04" } )
	
	if nPos > 0
		cHabili := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG10      ³ TIPO DISCIPLINA
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// pesquisar nos dados recebidos do formulario o PERG10
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG10" } )
	
	if nPos > 0
		cTDisc := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG11      ³ DISCIPLINA
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// pesquisar nos dados recebidos do formulario o PERG11
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG11" } )
	
	if nPos > 0
		cDisc := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	
	if ExistBlock("SEC0008D")
		aRet := U_SEC0008d(.T., HttpSession->ra, Httpsession->ccurso, Httpsession->perlet, cHabili, Httpsession->turma, cDisc, cTDisc )
	endif
	
	
	if len(aRet) == 0 // continua a validacao com o regime
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³*** validar avaliação selecionada ***³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      PERG11      ³ REGIME
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		// pesquisar nos dados recebidos do formulario o PERG11
		nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG11" } )
		
		if nPos > 0
			cRegime := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      PERG13      ³ CODIGO DA AVALIACAO
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		// pesquisar nos dados recebidos do formulario o PERG13
		nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG13" } )
		
		if nPos > 0
			cCodAva := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
		endif
		
		if ExistBlock("SEC0008E")
			aRet := U_SEC0008e( .T., .F., cRegime, cCodAva, cTDisc )
		endif
	endif
	
endif

Restarea(aArea)
Return aRet
