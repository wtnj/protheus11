#include "rwmake.ch"
#define CRLF	Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0024a  ºAutor  ³Edney Souza         º Data ³  14/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra do Script do Requerimento de Revisão de Prova         º±±
±±º          ³Verifica se a avaliação ocorreu nas últimas 48 horas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³ExpC1 : RA do aluno.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se a avaliacao é valida para revisao     º±±
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
User Function SEC0024a( lWeb )
Local aRet      := {}
Local dData		
Local cCurso	:= ""
Local cPerLet	:= ""
Local cHabili   := ""
Local cTurma	:= ""
Local cDiscip	:= ""
Local cCodAva	:= ""
Local cCodAtiv	:= ""
Local lRet      := .T.

lWeb := IIf(lWeb == NIL, .F., lWeb)

if lweb
	
	dData		:= Date()
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
	// pesquisar nos dados recebidos do formulario o PERG11
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG11" } )
	
	if nPos > 0
		cDiscip := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG15      ³ CODIGO DA AVALIACAO
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// pesquisar nos dados recebidos do formulario o PERG15
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG15" } )
	
	if nPos > 0
		cCodAva := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      PERG17      ³ CODIGO DA ATIVIDADE
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	// pesquisar nos dados recebidos do formulario o PERG17
	nPos := aScan( HttpSession->aParamPost, { |x| Alltrim(x[1])=="PERG17" } )
	
	if nPos > 0
		cCodAtiv := HttpSession->aParamPost[nPos][3] // pegar o conteudo...
	endif

else
	                     
	dData		:= dDataBase
    cNumRa    	:= M->JBH_CODIDE
	cCurso		:= M->JBH_SCP01
	cPerLet		:= M->JBH_SCP03
	cHabili     := M->JBH_SCP04
	cTurma		:= M->JBH_SCP06
	cDiscip		:= M->JBH_SCP11
	cCodAva		:= M->JBH_SCP15
	cCodAtiv	:= M->JBH_SCP17
	
endif                
                       
If Empty( cCodAtiv )

	// JBS_FILIAL + JBS_NUMRA + JBS_CODCUR + JBS_PERLET + JBS_HABILI + JBS_TURMA + JBS_CODDIS + JBS_CODAVA
	JBS->( dbSetOrder( 2 ) )
	
	If ! JBS->( dbSeek( xFilial( "JBS" ) + SubStr( cNumRA, 1, 15 ) + cCurso + cPerLet + cHabili + cTurma + cDiscip + cCodAva ) )
		            
		if lWeb
			aadd( aRet, {.F., "A nota dessa avaliação ainda não foi apontada." } )
		else
			MsgStop( "A nota dessa avaliação ainda não foi apontada." )
			lRet := .F.
		endif
		
	Else
		            
		If ! JBS->JBS_COMPAR == "1"
	
			if lWeb
				aadd( aRet, {.F., "O aluno não fez a avaliação informada." } )
			else
				MsgStop( "O aluno não fez a avaliação informada." )
				lRet := .F.
			endif
	
		EndIf
		
		If lRet .And. JBS->JBS_DTAPON < dData - 2
	
			if lWeb
				aadd( aRet, {.F., "Já faz mais de 48 horas que essa nota foi apontada. Continua ?" } )
			else
				lRet := MsgNoYes( "Já faz mais de 48 horas que essa nota foi apontada. Continua ?" )
			endif
	
		EndIf
		
	EndIf

Else

	JDC->( dbSetOrder( 1 ) )
	
	If ! JDC->( dbSeek( xFilial( "JDC" ) + cCurso + cPerLet + cHabili + cTurma + cDiscip + cCodAva + cCodAtiv + cNumRA ) )
	
		if lWeb
			aadd( aRet, {.F., "A nota dessa atividade ainda não foi apontada." } )
		else
			MsgStop( "A nota dessa atividade ainda não foi apontada." )
			lRet := .F.
		endif

	Else 
	
		If ! JDC->JDC_COMPAR == "1"

			if lWeb
				aadd( aRet, {.F., "O aluno não fez a atividade informada." } )
			else
				MsgStop( "O aluno não fez a atividade informada." )
				lRet := .F.
			endif
		
		EndIf
	
	EndIf

EndIf

Return( iif( lWeb, aRet, lRet ) )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0024b  ºAutor  ³Edney Souza         º Data ³ 15/10/02    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra Inicial do Requerimento de Revisão de Prova           º±±
±±º          ³Envia e-mail para o professor da disciplina informando que  º±±
±±º          ³deve revisar a avaliacao do aluno.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Void                                                        º±±
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
User Function SEC0024b()

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
// aScript[04] - Habilitacao
// aScript[05] - Descricao da habilitacao
// aScript[06] - Turma
// aScript[07] - Ano Letivo
// aScript[08] - Semestre
// aScript[09] - Telefone
// aScript[10] - Tipo da disciplina
// aScript[11] - Disciplina
// aScript[12] - Descricao
// aScript[13] - Regime
// aScript[14] - Descricao
// aScript[15] - Avaliacao
// aScript[16] - Descricao
// aScript[17] - Atividade
// aScript[18] - Descricao

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
cMsg += "O requerimento acima mencionado foi solicitado pelo aluno " + JA2->JA2_NOME
cMsg += " matriculado sob o RA número " + AllTrim( JBH->JBH_CODIDE )
cMsg += ", no curso de " + Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")
cMsg += ", na unidade " + Posicione( "JA3", 1, xFilial("JA3") + JAH->JAH_UNIDAD, "JA3_DESLOC" )
cMsg += CRLF
cMsg += " A revisao de prova solicitada pelo aluno é a " + aScript[15] + " - " + aScript[16]
cMsg += " referente à disciplina " + aScript[11] + " - " + aScript[12]
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

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0024c º Autor ³ Microsiga          º Data ³  30/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza campos referente a atividade caso a avaliacao     º±±
±±º          ³ seja por atividade.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0024c()
             
M->JBH_SCP17 := Space( TamSX3("JDA_ATIVID")[1] )
M->JBH_SCP18 := Space( 30 )

Return( .T. )
