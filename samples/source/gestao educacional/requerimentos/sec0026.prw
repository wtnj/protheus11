#include "rwmake.ch"
#define CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0026a  ºAutor  ³Gustavo Henrique    º Data ³  21/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Regra Final do Requerimento de Acao Judicial.               º±±
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
User Function SEC0026a()

local lRet		:= .F.
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local cRA		:= Padr( JBH->JBH_CODIDE, TamSx3("JA2_NUMRA")[1] )
local cPerAnt	:= Iif( aRet[03] # "01", StrZero( Val( aRet[03] ) - 1, 2 ), aRet[03] )
local cCurso	:= aRet[1]
local cPerLet	:= aRet[3]
Local cHabili   := aRet[4]
local cTurma	:= aRet[6]
local cLiminar	:= aRet[10]
local cTipoLim  := aRet[11]
local cTipo		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe Habilitacao no Periodo Letivo Anterior.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
local cHabAnt := AcTrazHab(cCurso, cPerAnt, cHabili)

JBE->( dbSetOrder( 1 ) )
if JBE->(dbSeek(xFilial("JBE") + cRA + cCurso + cPerLet + cHabili + cTurma))
		
	while JBE->( ! EoF() .and. JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA == xFilial("JBE") + cRA + cCurso + cPerLet + cHabili + cTurma)
		if JBE->JBE_ATIVO $ "1259" // 1=Ativo;2=Inativo;5=Formado;9=Débitos Financeiros
			exit
		endif
		JBE->(dbSkip())
	enddo

	begin transaction     
	
	if cLiminar == "1"	// Entrega liminar

		if cTipoLim == "1"
		
			if JBE->JBE_TIPO $ "45"
				cTipo := "6"
			else
				cTipo := "3"
			endif
		
			ACDesBloq( cRA, cCurso, cPerLet, cHabili, cTurma, cTipo )
		
		elseif cTipoLim == "2"
		
			if JBE->JBE_TIPO == "2"
				cTipo := "5"
			elseif JBE->JBE_TIPO == "3"
				cTipo := "6"
			else
				cTipo := "4"
			endif
			
			JBE->(RecLock("JBE",.F.))
			JBE->JBE_TIPO	:= cTipo
			If JBE->JBE_ATIVO == '9'
				JBE->JBE_ATIVO := '1'
			EndIf
			// Alunos pré-matriculados que entram com ação judicial financeira ficam matriculados
			If JBE->JBE_SITUAC <> "2"
				Acaa350(JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, JBE->JBE_TURMA)
			EndIf
			JBE->(MsUnlock())
		
		endif
		
	else	// Cassacao de liminar
		                          
		JAR->( dbSetOrder( 1 ) )
	
		if	cPerAnt >= "01" .and. JAR->(dbSeek(xFilial("JAR") + cCurso + cPerAnt + cHabAnt ))
                                    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acao Judicial por Bloqueio de Dependencias ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if cTipoLim == "1"	
                                              
				lRet := AcBloq(cRA,cCurso,cPerAnt,cHabAnt,JAR->JAR_DPMAX)

				if JBE->JBE_TIPO == "3"
					cTipo := iif( lRet, "2", "1" )
				elseif JBE->JBE_TIPO == "6"	
					cTipo := iif( lRet, "5", "4" )
				endif	

				JBE->(RecLock("JBE",.F.))
				JBE->JBE_TIPO := cTipo // 1=Regular;2=Dependencia;3=Regular-Acao Judicial
				JBE->(MsUnlock())
				    
				if lRet
				
					JC7->(dbSetOrder(1)) // JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1
					JC7->(dbSeek(xFilial("JC7") + cRA + cCurso + cPerLet + cHabili + cTurma ))
					while JC7->( ! EoF() .and. JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA == xFilial("JC7") + cRA + cCurso + cPerLet + cHabili + cTurma)
						if JC7->JC7_SITUAC $ "123456A"
							JC7->(RecLock("JC7",.F.))
							JC7->JC7_SITUAC := If(JC7->JC7_SITDIS == "010","A",If(JC7->JC7_SITDIS == "003","8",If(JC7->JC7_SITUAC == "A","1",JC7->JC7_SITUAC)))
							JC7->(MsUnlock())
						endIf
						JC7->(dbSkip())
					enddo
				
				endif
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acao Judicial por Debitos Financeiros ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    elseif cTipoLim == "2"
		                             
				// Bloqueia o aluno
					RecLock("JBE",.F.)
					JBE->JBE_ATIVO	:= "9"	// Debitos Financeiros
					JBE->(MsUnlock())

			endif
						
		endif
		
	endif  
	
	end transaction
	
endif
	
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0026b  ºAutor  ³Gustavo Henrique    º Data ³  21/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacao dos campos do Script.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Indicador de validacao.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpL1 : Indica se estah sendo chamado pela Web              º±±
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
User Function SEC0026b()

local aArea		:= GetArea()
local aRet      := {}
local nPos		:= 0
local lRet		:= .T.
local lExiste	:= .F.
local lWeb		:= IsBlind()
local cTipoLim	:= ""
local cLiminar  := ""
local cHabili   := ""
local cNumRA	:= iif( lWeb, PadR(HttpSession->RA, TamSX3("JA2_NUMRA")[1]), Padr(M->JBH_CODIDE ,TamSx3("JA2_NUMRA")[1]) )
local cCurso	:= iif( lWeb, HttpSession->CCurso, Padr(M->JBH_SCP01  ,TamSx3("JBE_CODCUR")[1]) )
local cPerLet	:= iif( lWeb, HttpSession->PerLet, Padr(M->JBH_SCP03  ,TamSx3("JBE_PERLET")[1]) )
local cTurma	:= iif( lWeb, HttpSession->Turma, Padr(M->JBH_SCP06  ,TamSx3("JBE_TURMA")[1]) )

if lWeb
	// Busca do script na web o tipo preenchido se: 1=Bloqueio de DP ou 2=Debitos Financeiros
	nPos := Ascan(HttpSession->aParamPost, { |X| X[1] == "PERG11"})
	if nPos > 0
		cTipoLim := HttpSession->aParamPos[nPos][3]
	endif
else
	cTipoLim := M->JBH_SCP11
endif               

if lWeb
	// Busca do script na web o tipo de liminar: 1=Entrega;2=Cassação
	nPos := Ascan(HttpSession->aParamPost, { |X| X[1] == "PERG10"})
	if nPos > 0
		cLiminar := HttpSession->aParamPos[nPos][3]
	endif
else
	cLiminar := M->JBH_SCP10
endif               

if lWeb
	// Busca do script na web a habilitacao 
	nPos := Ascan(HttpSession->aParamPost, { |X| X[1] == "PERG04"})
	if nPos > 0
		cHabili := HttpSession->aParamPos[nPos][3]
	endif
else
	cHabili := M->JBH_SCP04
endif               
                   
JBE->( dbSetOrder(3) )
if ! JBE->(dbSeek(xFilial("JBE") + '1' + cNumRA + cCurso + cPerLet + cHabili + cTurma))  .and.;
   ! (JBE->(dbSeek(xFilial("JBE") + '2' + cNumRA + cCurso + cPerLet + cHabili + cTurma)) .and. JBE->JBE_SITUAC == "1") .and.;
   ! JBE->(dbSeek(xFilial("JBE") + '9' + cNumRA + cCurso + cPerLet + cHabili + cTurma))  
    If lWeb
		aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">O aluno não está ativo no curso e período letivo solicitados.</font></b><br>'})
	Else	        
		MsgStop("O aluno não está ativo no curso e período letivo solicitados.")
		lRet := .F.
	EndIf
endif

if lRet

	// Entrega de Liminar            
	if cLiminar == "1"
	                     
		// Bloqueio por Dependencias
		if cTipoLim == "1" .And. JBE->JBE_TIPO $ "36"
	
		    if lWeb
				aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Este aluno já está sob Ação Judicial de Bloqueio de Dependências.</font></b><br>'})
			else	        
				MsgStop("Este aluno já está sob Ação Judicial por Bloqueio de Dependências.")
				lRet := .F.
			endif
	                                
		// Debitos Financeiros
		elseif cTipoLim == "2" .And. JBE->JBE_TIPO $ "456" .and. ! JBE->JBE_ATIVO == '9'
	
		    if lWeb
				aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Este aluno já está sob Ação Judicial de Débitos Financeiros.</font></b><br>'})
			else	        
				MsgStop("Este aluno já está sob Ação Judicial por Débitos Financeiros.")
				lRet := .F.
			endif
		
		endif

	// Cassacao	
	elseif cLiminar == "2"
	         
		// Bloqueio por Dependencias
		if cTipoLim == "1" .And. JBE->JBE_TIPO $ "1245"
		
		    if lWeb
				aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">O aluno deve estar sob Ação Judicial por Bloqueio de Dependências.</font></b><br>'})
			else	        
				MsgStop("O aluno deve estar sob Ação Judicial por Bloqueio de Dependências.")
				lRet := .F.
			endif
		                            
		// Debitos Financeiros
		elseif cTipoLim == "2" .And. JBE->JBE_TIPO $ "123"

		    if lWeb
				aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">O aluno deve estar sob Ação Judicial por Débitos Financeiros.</font></b><br>'})
			else	        
				MsgStop("O aluno deve estar sob Ação Judicial por Débitos Financeiros.")
				lRet := .F.
			endif
		
		endif	
	
	endif
	
endif

if lRet .And. cTipoLim == "2"
                                                   
	JA2->( dbSetOrder( 1 ) )
	JA2->( dbSeek( xFilial("JA2") + cNumRA ) )

	SE1->( dbSetOrder(2) )	// E1_FILIAL + E1_CLIENTE + E1_LOJA
	SE1->( dbSeek( xFilial("SE1") + JA2->( JA2_CLIENT + JA2_LOJA ) ) )

	do while SE1->( ! EoF() .and. E1_FILIAL+E1_CLIENTE + E1_LOJA == xFilial("SE1") + JA2->( JA2_CLIENT + JA2_LOJA ) )
				
		// Se o curso for outro, ignora
		if Left( SE1->E1_NRDOC, 6 ) <> cCurso
			SE1->( dbSkip() )
		    loop
		elseif SE1->E1_VENCREA < dDatabase .and. SE1->E1_STATUS <> "B"		// Se estiver em atraso, acumula no array 
			lExiste := .T.               
			exit
		endif
				
		SE1->( dbSkip() )
		
	enddo       
	
	if ! lExiste
	            
	    if lWeb
			aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Não foram encontrados títulos em atraso.</font></b><br>'})
		else	        
			MsgStop("Não foram encontrados títulos em atraso.")
			lRet := .F.
		endif
	
	endif                      
	
endif

RestArea(aArea)

Return( iif( lWeb, aRet, lRet ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEC0026c  ºAutor  ³Gustavo Henrique    º Data ³  21/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Validacoes do script.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ExpL1 : Indicador de validacao.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpL1 : Indica se esta sendo chamado do script              º±±
±±º          ³ExpC2 : Chave para pesquisa na tabela JBE                   º±±
±±º          ³ExpL3 : Indica se esta sendo chamado pela Web               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gestao Educacional - Requerimentos                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SEC0026c( lScript, cKey, lWeb )

local lRet	:= .T.
local aRet  := {}

lScript	:= if( lScript == nil, .F., lScript )
cKey	:= if( cKey == nil, "", cKey )    
lWeb	:= if( lWeb == nil, .F., lWeb )    

if lScript
	lRet	:= ExistCpo("JBE",Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey, 1)

	if lRet

		JBE->( dbSetOrder(3) )
		// Alunos ativos ou Pré-Matriculados.
		lRet := (JBE->( dbSeek( xFilial("JBE")+"1"+Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey ) ) .or.;
   			    (JBE->( dbSeek( xFilial("JBE")+"2"+Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey ) ) .and. JBE->JBE_SITUAC == "1") .or.;
				 JBE->( dbSeek( xFilial("JBE")+"9"+Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey ) ) )
		
		if !lRet
		    If !lWeb
				MsgStop("Curso inválido para este aluno.")
			Else
				aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Curso inválido para este aluno.</font></b><br>'})
		        Return aRet
		    EndIf     
		elseif ! lWeb
			M->JBH_SCP02	:= Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC")
			M->JBH_SCP03	:= JBE->JBE_PERLET
			M->JBH_SCP04	:= JBE->JBE_HABILI
			M->JBH_SCP05    := Posicione("JDK",1,xFilial("JDK")+JBE->JBE_HABILI,"JDK_DESC")
			M->JBH_SCP06	:= JBE->JBE_TURMA
			M->JBH_SCP07	:= Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_ANOLET")
			M->JBH_SCP08	:= Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_PERIOD")
			M->JBH_SCP09	:= Posicione("JA2",1,xFilial("JA2")+JBE->JBE_NUMRA,"JA2_FRESID")
		endif
	endif
endif

Return( lRet )
