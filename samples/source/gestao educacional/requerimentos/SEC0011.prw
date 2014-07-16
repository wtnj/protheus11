#include "rwmake.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011a  ºAutor  ³Rafael Rodrigues    º Data ³  21/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra para gravacao da Grade Curricular do Externo para     º±±
±±º          ³analise.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³ Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Gustavo     ³15/08/02³xxxxx ³ Gerar a grade curricular a partir das    ³±±
±±³            ³        ³      ³ disciplinas do curso padrao.             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011a()

Local aScript := ACScriptReq( JBH->JBH_NUM )

RecLock("JCS", .T.)
JCS->JCS_FILIAL	:= xFilial("JCS")
JCS->JCS_NUMREQ	:= JBH->JBH_NUM
JCS->JCS_CURPAD	:= aScript[1]
JCS->JCS_VERSAO	:= aScript[3]
msUnlock("JCS")

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011b  ºAutor  ³Rafael Rodrigues    º Data ³  22/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Se o externo tiver a grade curricular avaliada e aprovar a  º±±
±±º          ³matricula, esta regra sera utilizada para gerar o aluno     º±±
±±º          ³provisorio.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
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
User Function SEC0011b()
local cRG		:= PadR( JBH->JBH_CODIDE, TamSX3("JCR_RG")[1] )
local cCodCli	:= ""
local cNumRA	:= ""
local lVaga		:= .F.
local lGeraSA1	:= .T.
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local cMemo		:= ACScriptReq( JBH->JBH_NUM )
Local nA		:= 0
Local cSerie    := ""
Local cHabili   := ""

JCR->( dbSetOrder(1) )	// JCS_FILIAL+JCS_NUMREQ
JCR->( dbSeek(xFilial("JCR")+cRG) )

SA1->( dbSetOrder(3) )
SA1->( dbSeek(xFilial("SA1")+JCR->JCR_CPF) )

Do While SA1->( ! EoF() .and. xFilial( "SA1" ) + JCR->JCR_CPF == A1_FILIAL + A1_CGC )
	
	If RTrim(SA1->A1_RG) == RTrim(JCR->JCR_RG)
		lGeraSA1 := .F.
		Exit
	EndIf
	
	SA1->( dbSkip() )
	
EndDo

JCS->( dbSetOrder(1) )	// JCS_FILIAL+JCS_NUMREQ
JCS->( dbSeek(xFilial("JCS")+JBH->JBH_NUM) )

// Deve preencher o periodo letivo na analise da grade para poder matricular o aluno
If Empty( JCS->JCS_SERIE )
	MsgInfo( "O Periodo Letivo não foi informado na Analise da Grade Curricular." )
	Return( .F. )
EndIf

JAR->( dbSetOrder(1) )
JAR->( dbSeek(xFilial("JAR")+JCS->(JCS_CURSO+JCS_SERIE+JCS_HABILI) ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe vaga disponível no curso desejado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !AcaVerJAR(JCS->JCS_CURSO, JCS->JCS_SERIE, JCS->JCS_HABILI, 4)
	MsgStop("Não existe vaga disponível neste curso.")
	Return .F.
endif

JBO->( dbSetOrder(1) )
JBO->( dbSeek(xFilial("JBO") + JCS->JCS_CURSO + JCS->JCS_SERIE + JCS->JCS_HABILI) )

while !JBO->( eof() ) .and. JBO->JBO_FILIAL+JBO->JBO_CODCUR+JBO->JBO_PERLET+JBO->JBO_HABILI == xFilial("JBO")+JCS->JCS_CURSO+JCS->JCS_SERIE+JCS->JCS_HABILI
	
	if AcaVerJBO(JAR->JAR_CODCUR, JAR->JAR_PERLET, JAR->JAR_HABILI, JBO->JBO_TURMA, 4)
		lVaga := .T.
		exit
	endif
	
	JBO->( dbSkip() )
end

if !lVaga
	MsgStop("Não existe vaga disponível em nenhuma turma deste curso.")
	Return .F.
endif

begin transaction

if lGeraSA1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Reserva o código de cliente no SA1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodCli := GetSXENum("SA1","A1_COD")
	SA1->( dbSetOrder(1) )
	while SA1->( dbSeek(xFilial("SA1")+cCodCli) )
		SA1->( ConfirmSX8() )
		cCodCli	:= GetSXENum("SA1","A1_COD")
	end
else
	cCodCli	:= SA1->A1_COD
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Reserva o código de cliente no SA1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumRA := if( ExistBlock("ACGERARA" ), ExecBlock("ACGERARA",.F.,.F.,"SEC0011"), CriaVar("JA2_NUMRA") )
	
if Empty( cNumRA )
	cNumRA := GetSXENum("JA2","JA2_NUMRA")
	ConfirmSX8()

	JA2->( dbSetOrder(1) )
	While JA2->( dbSeek(xFilial("JA2") + cNumRA) )
		cNumRA := GetSXENum("JA2","JA2_NUMRA")
		ConfirmSX8()
	End
EndIf

If ExistBlock("AcaConfRA")
	M->JA2_NUMRA := cNumRA
	ExecBlock("AcaConfRA",.F.,.F.,.T.)
EndIf

if Empty(cNumRA)
	MsgStop("Não foi possível obter um número RA para o aluno."+Chr(13)+Chr(10)+"Impossível prosseguir.")
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava o Aluno no JA2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("JA2", .T.)

JA2->JA2_FILIAL	:= xFilial("JA2")
JA2->JA2_NUMRA	:= cNumRA
JA2->JA2_NOME	:= JCR->JCR_NOME
JA2->JA2_CEP	:= JCR->JCR_CEP
JA2->JA2_END	:= JCR->JCR_END
JA2->JA2_NUMEND	:= JCR->JCR_NUMEND
JA2->JA2_COMPLE	:= JCR->JCR_COMPLE
JA2->JA2_BAIRRO	:= JCR->JCR_BAIRRO
JA2->JA2_CIDADE	:= JCR->JCR_CIDADE
JA2->JA2_EST	:= JCR->JCR_EST
JA2->JA2_FRESID	:= JCR->JCR_FRESID
JA2->JA2_FCELUL	:= JCR->JCR_FCELUL
JA2->JA2_FCONTA	:= JCR->JCR_FCONTA
JA2->JA2_NOMCON	:= JCR->JCR_NOMCON
JA2->JA2_EMAIL	:= JCR->JCR_EMAIL
JA2->JA2_DTNASC	:= JCR->JCR_DTNASC
JA2->JA2_NATURA	:= JCR->JCR_NATURA
JA2->JA2_NACION	:= JCR->JCR_NACION
JA2->JA2_ECIVIL	:= JCR->JCR_ECIVIL
JA2->JA2_PAI	:= JCR->JCR_PAI
JA2->JA2_MAE	:= JCR->JCR_MAE
JA2->JA2_SEXO	:= JCR->JCR_SEXO
JA2->JA2_DATA	:= dDatabase
JA2->JA2_CPF	:= JCR->JCR_CPF
JA2->JA2_TIPCPF	:= JCR->JCR_TIPCPF
JA2->JA2_RG		:= JCR->JCR_RG
JA2->JA2_DTRG	:= JCR->JCR_DTRG
JA2->JA2_ESTRG	:= JCR->JCR_ESTRG
JA2->JA2_TITULO	:= JCR->JCR_TITULO
JA2->JA2_CIDTIT	:= JCR->JCR_CIDTIT
JA2->JA2_ESTTIT	:= JCR->JCR_ESTTIT
JA2->JA2_ZONA	:= JCR->JCR_ZONA
JA2->JA2_CMILIT	:= JCR->JCR_CMILIT
JA2->JA2_ENDCOB	:= JCR->JCR_ENDCOB
JA2->JA2_NUMCOB	:= JCR->JCR_NUMCOB
JA2->JA2_BAICOB	:= JCR->JCR_BAICOB
JA2->JA2_COMCOB	:= JCR->JCR_COMCOB
JA2->JA2_ESTCOB	:= JCR->JCR_ESTCOB
JA2->JA2_CIDCOB	:= JCR->JCR_CIDCOB
JA2->JA2_CEPCOB	:= JCR->JCR_CEPCOB
JA2->JA2_STATUS	:= "2"			// Provisorio
JA2->JA2_CLIENT	:= cCodCli
JA2->JA2_LOJA	:= "01"
JA2->JA2_PROCES	:= JCR->JCR_PROCES
JA2->JA2_INSTIT	:= JCR->JCR_INSTIT
JA2->JA2_DATAPR	:= JCR->JCR_DATAPR
JA2->JA2_CLASSF	:= JCR->JCR_CLASSF
JA2->JA2_PONTUA	:= JCR->JCR_PONTUA
JA2->JA2_FORING	:= JCR->JCR_FORING
JA2->JA2_DATADI	:= JCR->JCR_DATADI
JA2->JA2_PROFIS	:= JCR->JCR_PROFIS
JA2->JA2_CEPPRF	:= JCR->JCR_CEPPRF
JA2->JA2_ENDPRF	:= JCR->JCR_ENDPRF
JA2->JA2_NUMPRF	:= JCR->JCR_NUMPRF
JA2->JA2_COMPRF	:= JCR->JCR_COMPRF
JA2->JA2_BAIPRF	:= JCR->JCR_BAIPRF
JA2->JA2_CIDPRF	:= JCR->JCR_CIDPRF
JA2->JA2_ESTPRF	:= JCR->JCR_ESTPRF
JA2->JA2_FCOML	:= JCR->JCR_FCOML
JA2->JA2_RAMAL	:= JCR->JCR_RAMAL
JA2->JA2_ENTIDA	:= JCR->JCR_ENTIDA
JA2->JA2_CONCLU	:= JCR->JCR_CONCLU
JA2->JA2_ACAOJU	:= "2"	// Nao
JA2->JA2_VERCAR	:= "001"
JA2->JA2_TEMPOJ := JCR->JCR_TEMPOJ
JA2->JA2_TIPENS := JCR->JCR_TIPENS

cMemo := MSMM(JCR->JCR_MEMO1)

MSMM(,TamSx3("JA2_OBSERV")[1],,cMemo,1,,,"JA2","JA2_MEMO1")

cMemo := MSMM(JCR->JCR_MEMO2)

MSMM(,TamSx3("JA2_DISPRO")[1],,cMemo,1,,,"JA2","JA2_MEMO2")

JA2->( msUnlock() )

JA2->( ConfirmSX8() )

if lGeraSA1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o cliente no SA1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SA1", .T.)
	
	SA1->A1_FILIAL	:= xFilial("SA1")
	SA1->A1_COD		:= cCodCli
	SA1->A1_LOJA	:= "01"
	SA1->A1_NOME	:= JA2->JA2_NOME
	SA1->A1_NREDUZ	:= JA2->JA2_NOME
	SA1->A1_PESSOA	:= "F"
	SA1->A1_TIPO	:= "F"
	SA1->A1_END		:= JA2->JA2_END
	SA1->A1_MUN		:= JA2->JA2_CIDADE
	SA1->A1_EST		:= JA2->JA2_EST
	SA1->A1_BAIRRO	:= JA2->JA2_BAIRRO
	SA1->A1_CEP		:= JA2->JA2_CEP
	SA1->A1_TEL		:= JA2->JA2_FRESID
	SA1->A1_ENDCOB	:= JA2->JA2_ENDCOB
	SA1->A1_CGC		:= JA2->JA2_CPF
	SA1->A1_EMAIL	:= JA2->JA2_EMAIL
	SA1->A1_RG		:= JA2->JA2_RG
	SA1->A1_DTNASC	:= JA2->JA2_DTNASC
	SA1->A1_BAIRROC	:= JA2->JA2_BAICOB
	SA1->A1_CEPC	:= JA2->JA2_CEPCOB
	SA1->A1_MUNC	:= JA2->JA2_CIDCOB
	SA1->A1_ESTC	:= JA2->JA2_ESTCOB
	SA1->A1_NATUREZ	:= &(GetMv("MV_ACNATMT"))
	SA1->A1_NUMRA	:= cNumRA
	
	SA1->( msUnlock() )
	
	SA1->( ConfirmSX8() )
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Reserva a vaga³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACFazReserva( JCS->JCS_CURSO, JCS->JCS_SERIE, JCS->JCS_HABILI, JCS->JCS_TURMA, "", .F. )

JBM->( dbSetOrder(4) ) // JBM_FILIAL+JBM_NUMREQ
if JBM->( dbSeek( xFilial("JBM")+JBH->JBH_NUM) )
	RecLock("JBM", .F.)
	JBM->JBM_TIPO	:= "2"	// Aluno
	JBM->JBM_CODIDE	:= cNumRA
	JBM->( msUnlock() )
endif

For nA := 1 To Val(JCS->JCS_SERIE)
	
	cSerie := StrZero(nA,TamSX3("JBE_PERLET")[1])
	cHabili := AcTrazHab(JCS->JCS_CURSO, cSerie, JCS->JCS_HABILI)
	
	JAR->( dbSetOrder(1) )
	JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+cSerie+cHabili ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o aluno no JBE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("JBE", .T.)
	
	JBE->JBE_FILIAL := xFilial("JBE")
	JBE->JBE_NUMRA  := cNumRA
	JBE->JBE_CODCUR := JCS->JCS_CURSO
	JBE->JBE_PERLET := cSerie
	JBE->JBE_HABILI := cHabili
	JBE->JBE_TURMA  := JBO->JBO_TURMA
	JBE->JBE_TIPO   := "1"  // Periodo Letivo Normal
	If cSerie == JCS->JCS_SERIE
		JBE->JBE_SITUAC := if( Posicione("JB5",1,xFilial("JB5")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+"01", "JB5_MATPAG") == "1" .and. Posicione("JAH",1,xFilial("JAH")+JCS->JCS_CURSO,"JAH_VALOR") == "1", "1", "2" )	// 1=PreMatricula; 2=Matricula
		JBE->JBE_ATIVO  := if( JBE->JBE_SITUAC == "1", "2", "1" )   // 1=Sim; 2=Nao
	Else
		JBE->JBE_SITUAC := "2"  // 1=Pre-Matricula; 2=Matricula
		JBE->JBE_ATIVO  := "2"  // 1=Sim; 2=Nao
	EndIf
	JBE->JBE_DTMATR := dDataBase
	JBE->JBE_ANOLET := JAR->JAR_ANOLET
	JBE->JBE_PERIOD := JAR->JAR_PERIOD
	JBE->JBE_TPTRAN := aRet[05]	// Campo do script ref. ao Tipo de Transferencia
	JBE->JBE_KITMAT := "2"		// Pendente
	JBE->JBE_NUMREQ := JBH->JBH_NUM
	
	MsUnLock()
	
	JCT->( dbSetOrder(1) )	// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_DISCIP
	JCT->( dbSeek(xFilial("JCT")+JBH->JBH_NUM+cSerie+cHabili) )
	While !JCT->( eof() ) .and. JCT->JCT_NUMREQ == JCS->JCS_NUMREQ .and. JCT->JCT_PERLET == cSerie .And. JCT->JCT_HABILI == cHabili
		
		JBL->( dbSetOrder(1) )	// JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_TURMA+JBL_CODDIS
		JBL->( dbSeek(xFilial("JBL")+JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI+JBE->JBE_TURMA+JCT->JCT_DISCIP) )
		
		While !JBL->( eof() ) .and. JBL->JBL_FILIAL+JBL->JBL_CODCUR+JBL->JBL_PERLET+JBL->JBL_HABILI+JBL->JBL_TURMA+JBL->JBL_CODDIS == ;
			xFilial("JBL") + JCS->JCS_CURSO + JCT->JCT_PERLET + JCT->JCT_HABILI + JBE->JBE_TURMA + JCT->JCT_DISCIP
			RecLock("JC7", .T.)
			
			JC7->JC7_FILIAL := xFilial("JC7")
			JC7->JC7_NUMRA  := cNumRA
			JC7->JC7_CODCUR := JBE->JBE_CODCUR
			JC7->JC7_PERLET := JBE->JBE_PERLET
			JC7->JC7_HABILI := JBE->JBE_HABILI
			JC7->JC7_TURMA  := JBE->JBE_TURMA
			JC7->JC7_DISCIP := JCT->JCT_DISCIP
			JC7->JC7_SITDIS := JCT->JCT_SITUAC
			JC7->JC7_DIASEM := JBL->JBL_DIASEM
			JC7->JC7_CODHOR := JBL->JBL_CODHOR
			JC7->JC7_HORA1  := JBL->JBL_HORA1
			JC7->JC7_HORA2  := JBL->JBL_HORA2
			JC7->JC7_CODPRF := JBL->JBL_MATPRF
			JC7->JC7_CODPR2 := JBL->JBL_MATPR2
			JC7->JC7_CODPR3 := JBL->JBL_MATPR3
			JC7->JC7_CODPR4 := JBL->JBL_MATPR4
			JC7->JC7_CODPR5 := JBL->JBL_MATPR5
			JC7->JC7_CODPR6 := JBL->JBL_MATPR6
			JC7->JC7_CODPR7 := JBL->JBL_MATPR7
			JC7->JC7_CODPR8 := JBL->JBL_MATPR8
			JC7->JC7_CODLOC := JBL->JBL_CODLOC
			JC7->JC7_CODPRE := JBL->JBL_CODPRE
			JC7->JC7_ANDAR  := JBL->JBL_ANDAR
			JC7->JC7_CODSAL := JBL->JBL_CODSAL
			JC7->JC7_SITUAC := if(JCT->JCT_SITUAC == "003", "8", If(JCT->JCT_SITUAC == "001","A","1"))   // 8 - Dispensado; 1 - Cursando; A - A cursar
			JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
			JC7->JC7_MEDCON := JCT->JCT_MEDCON
			JC7->JC7_CODINS := JCT->JCT_CODINS
			JC7->JC7_ANOINS := JCT->JCT_ANOINS
			
			JC7->( MsUnLock() )
			
			if JC7->JC7_SITUAC == "8"
				
				RecLock("JCO", .T.)
				
				JCO->JCO_FILIAL := xFilial("JCO")
				JCO->JCO_NUMRA  := JC7->JC7_NUMRA
				JCO->JCO_CODCUR := JC7->JC7_CODCUR
				JCO->JCO_PERLET := JC7->JC7_PERLET
				JCO->JCO_HABILI := JC7->JC7_HABILI
				JCO->JCO_DISCIP := JC7->JC7_DISCIP
				JCO->JCO_MEDFIM := JC7->JC7_MEDFIM
				JCO->JCO_MEDCON := JC7->JC7_MEDCON
				JCO->JCO_CODINS := JC7->JC7_CODINS
				JCO->JCO_ANOINS := JC7->JC7_ANOINS
				
				JCO->( MsUnLock() )
				
			endif
			
			JBL->( dbSkip() )
			
		end
		
		JCT->( dbSkip() )
		
	end
	
Next nA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava os documentos do curso.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AcGeraDoc(JA2->JA2_NUMRA, JBE->JBE_CODCUR)

AC680BOLET(JA2->JA2_PROSEL,"010",JA2->JA2_NUMRA,JA2->JA2_NUMRA,JBE->JBE_CODCUR,JBE->JBE_CODCUR,1,JBE->JBE_PERLET,JBE->JBE_TURMA,,,,,,,JBE->JBE_HABILI)

end transaction

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011c  ºAutor  ³Rafael Rodrigues    º Data ³  03/jul/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacoes no script do requerimento.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011c( lScript, cKey, lWeb )
local lRet	:= .F.
local aRet  := {}

lScript := if( lScript == nil, .F., lScript )
lWeb    := IIf( lWeb == Nil , .F., lWeb)

if lScript
	if ExistCpo("JAR", cKey , 1)
		JAR->( dbSetOrder(1) )
		JAR->( dbSeek(xFilial("JAR")+cKey) )
		
		while JAR->( !eof() .and. Left( &(IndexKey()), len(cKey) + 2 ) == xFilial("JAR")+cKey )
			if JAR->JAR_ANOLET >= StrZero(Year(dDatabase),4,0)
				lRet := .T.
				exit
			endif
			JAR->( dbSkip() )
		end
		
		if !lRet
			If !lWeb
				Aviso("Ano letivo inválido", "O ano letivo deve ser maior ou igual ao ano corrente", {"Ok"})
			Else
				aadd(aRet,{.F.,"Ano letivo inválido"})
				aadd(aRet,{.F.,"O ano letivo deve ser maior ou igual ao ano corrente"})
				Return aRet
			EndIf
		else
			If !lWeb
				M->JBH_SCP02 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JAR->JAR_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC")
			EndIf
		endif
	endif
else
	lRet := .T.
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011e  ºAutor  ³Gustavo Henrique    º Data ³  15/ago/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao do turno selecionado no script do Requerimento de º±±
±±º          ³Transferencia Externos                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011e()

Local lRet	:= .T.
Local aArea	:= GetArea()

If ! Empty( M->JBH_SCP09 )
	
	dbSelectArea( "JAH" )
	
	lRet := ExistCpo( "SX5", "F5" + M->JBH_SCP09 )
	
	If lRet
		
		JAH->( dbSetOrder( 4 ) )
		lRet := JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP01 + M->JBH_SCP03 ) )
		
		If lRet
			
			lRet := .F.
			
			Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP01 .and. JAH_VERSAO == M->JBH_SCP03 ) )
				If JAH->JAH_STATUS == "1" .and. JAH->JAH_UNIDAD == M->JBH_SCP07 .and. JAH->JAH_TURNO == M->JBH_SCP09
					lRet := .T.
					Exit
				EndIf
				JAH->( dbSkip() )
			EndDo
			
			If lRet
				M->JBH_SCP10 := Tabela( "F5", M->JBH_SCP09, .T. )
			Else
				MsgInfo( "Não existe nenhum curso vigente ativo definido para a unidade e turno informados." )
			EndIf
			
		EndIf
		
	EndIf
	
Else
	M->JBH_SCP10 := ""
EndIf

RestArea( aArea )

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011f  ºAutor  ³Gustavo Henrique    º Data ³  15/ago/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao do curso selecionado no script do Requerimento de º±±
±±º          ³Transferencia Externos                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011f()

Local lRet := .F.

If NaoVazio()
	
	JAF->( dbSetOrder( 6 ) )
	If JAF->( dbSeek( xFilial( "JAF" ) + "1" + M->JBH_SCP01 ) )
		
		If Empty( M->JBH_SCP03 )
			M->JBH_SCP03 := JAF->JAF_VERSAO
		EndIf
		
		JAH->( dbSetOrder( 4 ) )
		
		If JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP01 + M->JBH_SCP03 ) )
			
			Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP01 .and. JAH_VERSAO == M->JBH_SCP03 ) )
				If JAH->JAH_STATUS == "1" // Em aberto
					lRet := .T.
					Exit
				EndIf
				JAH->( dbSkip() )
			EndDo
			
			If lRet
				M->JBH_SCP02 := JAF->JAF_DESMEC
				M->JBH_SCP03 := JAF->JAF_VERSAO
			Else
				MsgInfo( "Não existe nenhum curso vigente ativo definido para o curso e versao informada." )
			EndIf
			
		Else
			MsgInfo( "Não existe nenhum curso vigente ativo definido para o curso e versao informada." )
		EndIf
	Else
		MsgInfo( "Curso padrão não cadastrado." )
	EndIf
	
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011g  ºAutor  ³Gustavo Henrique    º Data ³  30/set/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao da unidade selecionada no script do Requerimento  º±±
±±º          ³de Transferencia Externos                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011g()

Local lRet := .F.

If NaoVazio()
	
	JA3->( dbSetOrder( 1 ) )
	If JA3->( dbSeek( xFilial( "JA3" ) + M->JBH_SCP07 ) )
		JAH->( dbSetOrder( 4 ) )
		If JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP01 + M->JBH_SCP03 ) )
			
			Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP01 .and. JAH_VERSAO == M->JBH_SCP03 ) )
				If JAH->JAH_STATUS == "1" .and. JAH->JAH_UNIDAD == M->JBH_SCP07 // Em aberto
					lRet := .T.
					Exit
				EndIf
				JAH->( dbSkip() )
			EndDo
			
			If lRet
				M->JBH_SCP08 := JA3->JA3_DESLOC
				M->JBH_SCP09 := Space( TamSX3( "JAH_TURNO" )[1] )
			Else
				MsgInfo( "Não existe nenhum curso vigente ativo definido para a unidade informada." )
			EndIf
		Else
			MsgInfo( "Não existe nenhum curso vigente ativo definido para a unidade informada." )
		EndIf
	Else
		MsgInfo( "Unidade não cadastrada." )
	EndIf
	
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011h  ºAutor  ³Gustavo Henrique    º Data ³  30/set/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Filtro para consulta J37 do curso refeente ao campo curso doº±±
±±º          ³script do requerimento de de Transferencia Externos         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011h()

Local lRet := .F.

JAH->( dbSetOrder( 4 ) )
JAH->( dbSeek( xFilial( "JAH" ) + JAF->( JAF_COD + JAF_VERSAO ) ) )
	
If JAH->JAH_STATUS == "1"
	lRet := (Posicione( "JBK", 3, xFilial( "JBK" ) + "1" + JAH->JAH_CODIGO, "JBK_ATIVO" ) == "1")
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011i  ºAutor  ³Gustavo Henrique    º Data ³  30/set/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Emite o documento de Declaracao de Vaga ao gerar a          º±±
±±º          ³pre-matricula do aluno.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011i()

Local lRet		:= .T.
Local aDados 	:= {}
Local aAss		:= {}
Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local cDataExt	:= AllTrim(Str(Day(dDataBase)))+" de "+ MesExtenso(Month(dDataBase))+ " de " + AllTrim(Str(Year(dDataBase)))
local cRG		:= PadR( JBH->JBH_CODIDE, TamSX3("JCR_RG")[1] )
Local cHabili  := ""

Private cSec	:= ""
Private cPro	:= ""

If Empty( CtoD( aRet[11] ) )
	MsgInfo( "A data limite para manutenção da reserva não foi informada no script." )
	Return( .F. )
EndIf

// Verifica se o periodo letivo foi informado na analise da grade curricular
lRet := U_ACAGradeOk()

If lRet
	
	// Abre dialogo para digitacao dos codigos da secretaria e pro-reitoria.
	U_AssReq()
	
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + JCS->JCS_CURSO ) )
	
	JCR->( dbSetOrder( 1 ) )
	JCR->( dbSeek( xFilial( "JCR" ) + cRG ) )

	If Empty(JCS->JCS_HABILI)
		cHabili := " "
	Else
		cHabili := "habilitação " + AllTrim(Posicione("JDK",1,xFilial("JDK") + JCS->JCS_HABILI,"JDK_DESC")) + ", "
	EndIf
	
	AAdd( aDados, { "cDia"		, aRet[11]    									 } )
	AAdd( aDados, { "cPeriodo"	, JCS->JCS_SERIE 								 } )
	AAdd( aDados, { "cCurso"	, RTrim( Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC") )} )
	AAdd( aDados, { "cGrupo"	, Tabela( "FC", JAH->JAH_GRUPO, .F. ) 			 } )
	AAdd( aDados, { "cTurno"	, Tabela( "F5", JAH->JAH_TURNO, .F. )			 } )
	AAdd( aDados, { "cNome" 	, RTrim( JCR->JCR_NOME )						 } )
	AAdd( aDados, { "cRG"		, RTrim( JCR->JCR_RG )							 } )
	AAdd( aDados, { "cDataExt"	, cDataExt										 } )
	AAdd( aDados, { "cHabili"  , cHabili                               } )
	
	aAss := U_ACRetAss( cPRO )
	
	AAdd( aDados, { "cAss1"		, aAss[1] } )
	AAdd( aDados, { "cCargo1"	, aAss[2] } )
	AAdd( aDados, { "cRG1"		, aAss[3] } )
	
	aAss := U_ACRetAss( cSEC )
	
	AAdd( aDados, { "cAss2"		, aAss[1] } )
	AAdd( aDados, { "cCargo2"	, aAss[2] } )
	AAdd( aDados, { "cRG2"		, aAss[3] } )
	
	ACImpDoc( JBG->JBG_DOCUM, aDados, "Proteger" )
	
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0011k  ºAutor  ³Gustavo Henrique    º Data ³  15/out/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Valida o curso selecionado na opcao "Trocar Curso" na       º±±
±±º          ³Analise da Grade Curricular.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se obteve sucesso                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional  									      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0011k( cCursoDest, nUnidade, nDescUnid, nTurno, nDescTurno )

Local lRet := .F.
Local aRet := ACScriptReq( JCS->JCS_NUMREQ )

JAH->( dbSetOrder( 1 ) )
JAH->( dbSeek( xFilial( "JAH" ) + cCursoDest ) )

If JAH->JAH_UNIDAD # aRet[nUnidade]
	MsgInfo( "Selecione um curso vigente para a unidade: " + aRet[nDescUnid] )
	
ElseIf JAH->JAH_TURNO # aRet[nTurno]
	MsgInfo( "Selecione um curso vigente para o turno: " + aRet[nDescTurno] )
	
Else
	lRet := .T.
	
EndIf

Return( lRet )
