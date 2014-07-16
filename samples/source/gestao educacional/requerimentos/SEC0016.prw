#include "rwmake.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0016a  ºAutor  ³Rafael Rodrigues    º Data ³  28/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra para gravacao da Grade Curricular do Aluno para       º±±
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
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0016a()
local lRet		:= .F.
local cNumRA	:= PadR( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aScript	:= ACScriptReq( JBH->JBH_NUM )

JCT->( dbSetOrder(1) )	// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP

JC7->( dbSetOrder(3) )	// JC7_FILIAL+JC7_NUMRA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL

JAY->( dbSetOrder(1) )	// JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS
JAY->( dbSeek( xFilial("JAY")+aScript[3]+aScript[5], .T. ) )

while !JAY->( eof() ) .and. JAY->JAY_FILIAL+JAY->JAY_CURSO+JAY->JAY_VERSAO == xFilial("JAY")+aScript[3]+aScript[5]
	
	if JCT->( dbSeek( xFilial("JCT") + JBH->JBH_NUM + JAY->JAY_PERLET + JAY->JAY_HABILI + JAY->JAY_CODDIS ) )
		JAY->( dbSkip() )
		loop
	endif
	
	RecLock("JCT", .T.)
	JCT->JCT_FILIAL	:= xFilial("JCT")
	JCT->JCT_NUMREQ	:= JBH->JBH_NUM
	JCT->JCT_PERLET	:= JAY->JAY_PERLET
	JCT->JCT_HABILI := JAY->JAY_HABILI
	JCT->JCT_DISCIP	:= JAY->JAY_CODDIS
	
	if JC7->( dbSeek( xFilial("JC7") + cNumRA + JAY->JAY_CODDIS ) ) .and. JC7->JC7_SITUAC $ "82"
		JCT->JCT_SITUAC	:= "003"
	else
		JCT->JCT_SITUAC	:= "010"
	endif
	
	msUnlock("JCT")
	
	JAY->( dbSkip() )
	
end

if JCT->( dbSeek( xFilial("JCT") + JBH->JBH_NUM ) )
	RecLock("JCS", .T.)
	JCS->JCS_FILIAL	:= xFilial("JCS")
	JCS->JCS_NUMREQ	:= JBH->JBH_NUM
	JCS->JCS_CURPAD	:= aScript[3]
	JCS->JCS_VERSAO	:= aScript[5]
	msUnlock("JCS")
	
	lRet := .T.
else
	MsgStop("Não foi possível preparar a grade curricular para este aluno.")
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0016b  ºAutor  ³Rafael Rodrigues    º Data ³  28/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Se o aluno tiver a grade curricular avaliada e aprovar a    º±±
±±º          ³matricula, esta regra sera utilizada para reservar a vaga   º±±
±±º          ³do mesmo.                                                   º±±
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
User Function SEC0016b()
local cNumRA	:= PadR( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local lVaga		:= .F.
local aRet      := ACScriptReq( JBH->JBH_NUM )
Local nA		:= 0
Local nPerIni	:= 0
Local cTipo		:= ""
Local cSerie    := ""
Local cSituacao := ""
Local cKitMat	:= ""
Local nRecno    := 0 
Local aSitCur	:= {}
local cSitCur	:= ""
local cAnoPer   := ""

JA2->( dbSetOrder(1) )
JA2->( dbSeek(xFilial("JA2")+cNumRA) )

JCS->( dbSetOrder(1) )	// JCS_FILIAL+JCS_NUMREQ
JCS->( dbSeek(xFilial("JCS")+JBH->JBH_NUM) )

JAR->( dbSetOrder(1) )
JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+JCS->JCS_SERIE+JCS->JCS_HABILI) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe vaga disponível no curso desejado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !AcaVerJAR(JCS->JCS_CURSO, JCS->JCS_SERIE, JCS->JCS_HABILI, 4)
	MsgStop("Não existe vaga disponível neste curso.")
	Return .F.
endif

JBO->( dbSetOrder(1) )
JBO->( dbSeek(xFilial("JBO") + JCS->JCS_CURSO + JCS->JCS_SERIE + JCS->JCS_HABILI ) )

while !JBO->( eof() ) .and. JBO->JBO_FILIAL+JBO->JBO_CODCUR+JBO->JBO_PERLET+JBO->JBO_HABILI== xFilial("JBO")+JCS->JCS_CURSO+JCS->JCS_SERIE+JCS->JCS_HABILI
	
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura o ultimo tipo de curso (1=Regula;2=Somente dependencia;3=Regular-Acao Judicial,  ³
//³ antes de trancar/desistir da matricula                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )

cAnoPer := ""

do while JBE->( ! EoF() .and. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial("JBE") + cNumRA + aRet[1] )
	if JBE->( JBE_ANOLET + JBE_PERIOD ) > cAnoPer
		cAnoPer := JBE->( JBE_ANOLET + JBE_PERIOD )
		cTipo   := JBE->JBE_TIPO
		cKitMat := JBE->JBE_KITMAT
	endif
	JBE->( dbSkip() )
enddo

begin transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Reserva a vaga³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACFazReserva( JCS->JCS_CURSO, JCS->JCS_SERIE, JCS->JCS_HABILI, JCS->JCS_TURMA )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o aluno no JBE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPerIni := Iif( aRet[1] == JCS->JCS_CURSO, Val(JCS->JCS_SERIE), 1 )

For nA := nPerIni To Val(JCS->JCS_SERIE)
	
	cSerie := StrZero(nA,TamSX3("JBE_PERLET")[1])
	
	JAR->( dbSetOrder(1) )
	JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) )
	
	RecLock("JBE", .T.)
	
	JBE->JBE_FILIAL := xFilial("JBE")
	JBE->JBE_NUMRA  := cNumRA
	JBE->JBE_CODCUR := JCS->JCS_CURSO
	JBE->JBE_PERLET := cSerie        
	JBE->JBE_HABILI := JCS->JCS_HABILI
	JBE->JBE_TURMA  := JBO->JBO_TURMA
	JBE->JBE_TIPO   := iif( cTipo # "1", cTipo, "1" )  // Periodo Letivo Normal
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
	JBE->JBE_TPTRAN := "006"
	JBE->JBE_KITMAT := cKitMat
	
	MsUnLock()
	
	JCT->( dbSetOrder(1) )	// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP
	JCT->( dbSeek(xFilial("JCT")+JBH->JBH_NUM + cSerie + JCS->JCS_HABILI) )
	While !JCT->( eof() ) .and. JCT->JCT_NUMREQ == JCS->JCS_NUMREQ .and. JCT->JCT_PERLET == cSerie .and. JCT->JCT_HABILI == JCS->JCS_HABILI

		cSituacao := If( JCT->JCT_SITUAC == "003", "8", iif( JCT->JCT_SITUAC == "001", "A", "1" ) )
		nRecno := 0
				
		If JCT->JCT_SITUAC $ "010;002;006" .and. Val( JCT->JCT_PERLET ) < Val( JCS->JCS_SERIE )
	     
			JC7->( dbSetOrder( 3 ) )
			JC7->( dbSeek( xFilial( "JC7" ) + cNumRA + JCT->JCT_DISCIP ) )
 		
	 		Do While JC7->( ! EoF() .and. JC7_NUMRA + JC7_DISCIP == cNumRA + JCT->JCT_DISCIP )
 	
				If JC7->JC7_SITDIS $ "001;010;002;006" .and. JC7->JC7_SITUAC $ "345"
					nRecno := JC7->(Recno())
					cSituacao := JC7->JC7_SITUAC
				EndIf
						
				JC7->( dbSkip() )
		
 			EndDo	
	
		EndIF

		If nRecno > 0
			JC7->(dbGoto(nRecno))
			JCT->(RecLock("JCT",.F.))
			JCT->JCT_MEDFIM := JC7->JC7_MEDFIM
			JCT->JCT_MEDCON := JC7->JC7_MEDCON
			JCT->(MsUnlock())
		EndIF
		
		JBL->( dbSetOrder(1) )	// JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS
		JBL->( dbSeek(xFilial("JBL")+JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI+JBE->JBE_TURMA+JCT->JCT_DISCIP) )
		
		While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS == ;
			xFilial("JBL") + JCS->JCS_CURSO + JCT->JCT_PERLET + JCT->JCT_HABILI + JBE->JBE_TURMA + JCT->JCT_DISCIP )
			
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
			JC7->JC7_SITUAC := cSituacao
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

If aRet[1] # JCS->JCS_CURSO

	JBE->( dbSetOrder( 1 ) )
	JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )
	
	While JBE->( ! EoF() .And. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial( "JBE" ) + cNumRA + aRet[1] )
	     
		AAdd( aSitCur, { JBE->JBE_DTSITU, JBE->JBE_ATIVO } )
	     
		JBE->( dbSkip() )
	
	EndDo
	
	aSitCur := aSort( aSitCur,,, { |x,y| x[1] < y[1] } )
	cSitCur := aSitCur[ Len( aSitCur ), 2 ]

	dbSelectArea( "JBE" )
	dbSetOrder( 1 )		// JBE_FILIAL + JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA
	dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] )
	
	While xFilial( "JBE" ) + cNumRA + aRet[1] == JBE->JBE_FILIAL + JBE->JBE_NUMRA + JBE->JBE_CODCUR .and. ! JBE->(Eof())
		
		If JBE->JBE_ATIVO $ "125" .and. JBE->JBE_PERLET <= JCS->JCS_SERIE .and. JBE->JBE_HABILI == JCS->JCS_HABILI
			
			If ExistBlock("ACAtAlu1")
				U_ACAtAlu1("JBE")
			EndIf
			
			RecLock( "JBE", .F. )
			JBE->JBE_NUMREQ := JBH->JBH_NUM
			JBE->JBE_ATIVO  := cSitCur			//	Trancado
			MsUnlock()
			
			If ExistBlock("ACAtAlu2")
				U_ACAtAlu2("JBE")
			EndIf
			
		EndIf
		
		JBE->(dbSkip())
		
	EndDo

EndIf

AC680BOLET(JA2->JA2_PROSEL,"010",JA2->JA2_NUMRA,JA2->JA2_NUMRA,JCS->JCS_CURSO,JCS->JCS_CURSO,1,JCS->JCS_SERIE,JBO->JBO_TURMA,,,,,,,JCS->JCS_HABILI)

end transaction

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0016c  ºAutor  ³Rafael Rodrigues    º Data ³  28/jun/02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao da tela de script.                                º±±
±±º          ³Verifica se o status do aluno eh cancelado ou desistencia.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam.    ³Nenhum.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Informando se pode incluir o requerimento           º±±
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
User Function SEC0016c(lweb)
local lRet		:= .F.
Local aRet      := {}
local cNumRA	:= Padr( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

lWeb := IIf(lWeb == NIL, .F., lWeb)

JBE->( dbSetOrder(3) )	// Filial + Ativo + RA + Curso
lRet := lRet .or. JBE->( dbSeek(xFilial("JBE")+"4"+cNumRA+M->JBH_SCP01) ) .or.;
                  JBE->( dbSeek(xFilial("JBE")+"7"+cNumRA+M->JBH_SCP01) ) .or.;
                  JBE->( dbSeek(xFilial("JBE")+"9"+cNumRA+M->JBH_SCP01) )           
If ! lRet
	If lWeb
		aadd(aRet,{.F.,"Este curso não encontra-se com TRANCAMENTO, DESISTÊNCIA ou DÉBITOS FINANCEIROS para este aluno."})
		aadd(aRet,{.F.,"O retorno do aluno só é possível nessas situações."})
		Return aRet
	Else
		MsgStop("Este curso não encontra-se com TRANCAMENTO, DESISTÊNCIA ou DÉBITOS FINANCEIROS para este aluno."+Chr(13)+Chr(10)+;
		"O retorno do aluno só é possível nessas situações.")
	Endif
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0016d ºAutor  ³ Gustavo Henrique   º Data ³  05/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o aluno estah tentando retornar para um curso  º±±
±±º          ³ em um ano/periodo anterior ao que ele cursou.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de Retorno do Aluno                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0016d()
                          
local lRet    := .T.
local aRet    := ACScriptReq( JBH->JBH_NUM )
local cNumRA  := Padr( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local cAnoOri := ""
local cPerOri := ""

JCS->( dbSetOrder( 1 ) )	// JCS_FILIAL + JCS_NUMREQ
JCS->( dbSeek( xFilial("JCS") + JBH->JBH_NUM ) )

JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )
         
cAnoOri := JBE->JBE_ANOLET
cPerOri := JBE->JBE_PERIOD

do while JBE->( ! EoF() .and. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial( "JBE" ) + cNumRA + aRet[1] )
                     
	if cAnoOri + cPerOri < JBE->( JBE_ANOLET + JBE_PERIOD )
		cAnoOri := JBE->JBE_ANOLET
		cPerOri := JBE->JBE_PERIOD
	endif
     
	JBE->( dbSkip() )

enddo                

JAR->( dbSeek( xFilial( "JAR" ) + JCS->( JCS_CURSO + JCS_SERIE + JCS_HABILI ) ) )

if cAnoOri + cPerOri > JAR->( JAR_ANOLET + JAR_PERIOD )
	MsgStop( 	"O aluno não pode retornar em um ano/período anterior ao que ele cursou." + Chr(13) + Chr(10) +; 
				"Verifique o curso selecionado na rotina de Análise da Grade." )
	lRet := .F.			
endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0016e º Autor ³ Gustavo Henrique   º Data ³  05/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida o curso anterior informado no script                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de Retorno de Aluno                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0016e( cCodIde, cCurOri, lWeb )
              
local lRet    := .T.                                    
local aRet    := {}
local cNumRA  := Padr( cCodIde, TamSX3("JA2_NUMRA")[1] )
                                              
lWeb := iif( lWeb == NIL, .F., .T. )

JBE->( dbSetOrder( 1 ) )

lRet := JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + cCurOri ) )

if ! lRet

	if ! lWeb
		MsgInfo( "Não existe registro do aluno no curso anterior informado. Selecione outro curso vigente." )
	else	                     
		aadd(aRet, { .F., "Não existe registro do aluno no curso anterior informado. Selecione outro curso vigente."} )
	endif

else

	if ! lWeb
		M->JBH_SCP02 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+cCurOri,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC")
	endif

endif

Return( iif( lWeb, aRet, lRet ) )

                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SEC0016f º Autor ³ Gustavo Henrique   º Data ³  05/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida o curso padrao de destino informado no script       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Requerimento de Retorno de Aluno                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0016f( cCurDes, lWeb )
        
local lRet := .T.
local aRet := {}

lWeb := iif( lWeb == NIL, .F., .T. )

JAF->( dbSetOrder( 1 ) )
lRet := JAF->( dbSeek( xFilial( "JAF" ) + cCurDes ) )

if ! lRet

	if ! lWeb
		MsgInfo( "Curso inválido." )
	else	                     
		aadd( aRet, { .F., "Curso inválido." } )
	endif
	     
else

	if ! lWeb
		M->JBH_SCP04 := JAF->JAF_DESMEC
	endif	
	
endif    

Return( iif( lWeb, aRet, lRet ) )
