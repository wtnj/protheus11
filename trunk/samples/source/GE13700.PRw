#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GE13700   ºAutor  ³Rafael Rodrigues    º Data ³  26/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Faltas x Alunos                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GE13700()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13700.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JCH_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JCH_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JCH_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCH_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JCH_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JCH_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JCH_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JCH_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JCH_QTD"   , "N", 003, 0 } )

aAdd( aFiles, { 'Faltas x Alunos', '\Import\AC13700.TXT', aStru, 'TRB', .T. } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTables	:= U_GEGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo pôde ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRB->( dbGoBottom() )
	if Empty( TRB->JCH_NUMRA )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd( aObrig, { '!Empty(JCH_NUMRA)  ', 'RA do aluno não informado.' } )
	aAdd( aObrig, { 'JCH_NUMRA == Posicione( "JC7", 1, xFilial("JC7")+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+JCH_DISCIP, "JC7_NUMRA" )', 'Matrícula do aluno para esta disciplina não cadastrada na tabela JC7.' } )
	aAdd( aObrig, { '!Empty(JCH_CODCUR) ', 'Código do curso vigente não informado.' } )
	aAdd( aObrig, { '!Empty(JCH_PERLET) ', 'Período letivo não informado.' } )
	aAdd( aObrig, { '!Empty(JCH_TURMA)  ', 'Turma não informada.' } )
	aAdd( aObrig, { '!Empty(JCH_DATA)   ', 'Data não informada.' } )
	aAdd( aObrig, { '!Empty(JCH_DISCIP) ', 'Disciplina não informada.' } )
	aAdd( aObrig, { 'JCH_TIPO$"12"      ', 'Tipo deve ser 1 (indeferida) ou 2 (deferida).' } )
	aAdd( aObrig, { 'JCH_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JCH_CODCUR, "JAH_CODIGO" )', 'Curso vigente não cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JCH_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_PERLET" )', 'Período letivo não cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JCH_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JCH_CODCUR+JCH_PERLET+JCH_TURMA, "JBO_TURMA" )', 'Turma não cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JCH_DISCIP == Posicione( "JAS", 2, xFilial("JAS")+JCH_CODCUR+JCH_PERLET+JCH_DISCIP, "JAS_CODDIS" )', 'Disciplina não cadastrada na tabela JAS.' } )
	aAdd( aObrig, { '!Empty(JCH_QTD) ', 'Quantidade não informada.' } )
	aAdd( aObrig, { 'Empty(JCH_HORA1) .or. U_GEIsHora(JCH_HORA1,.T.) ', 'Horário inválido.' } )
	aAdd( aObrig, { 'Empty(JCH_HORA1) .or. Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "1" ', 'Horário somente deve ser informado quando o apontamento for diário.' } )
	aAdd( aObrig, { 'JCH_QTD == 1 .or. Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "1" ', 'O período letivo possui apontamento diário, então a quantidade deve ser 1.' } )
	aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "2" .or. JCH_DATA == LastDay(JCH_DATA)', 'Quando o apontamento for mensal, a data deve ser igual ao último dia do mês.' } )
	aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "3" .or. JCH_DATA == Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_DATA2")', 'Quando o apontamento for por período letivo, a data deve ser igual ao último dia do período letivo.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP+JCH_HORA1" ) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP+JCH_HORA1", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validação do Arquivo' )
	
	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsistências. Impossível prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| lOk := GE13700Grv( @lEnd ) }, 'Gravação em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Gravação realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX + OrdBagExt() )
	
endif

U_xSaveLog( cLog, cLogFile )
U_xKillLog( cLog )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Elimina os arquivos de trabalho criados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
for i := 1 to len( aTables )
	dbSelectArea( aTables[i][1] )
	dbCloseArea()
	FErase( aTables[i][2]+GetDBExtension() )
next i

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GE13700Grv ºAutor  ³Rafael Rodrigues   º Data ³  26/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GE13700                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GE13700Grv( lEnd )
Local cFilJCH	:= xFilial("JCH")	// Criada para ganhar performance
Local cFilJCG	:= xFilial("JCG")	// Criada para ganhar performance
Local i			:= 0
Local cChave	:= ""

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JCG->( dbSetOrder(1) )
JCH->( dbSetOrder(3) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cChave <> TRB->(JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP)
		cChave := TRB->(JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP)

		begin transaction

		RecLock( "JCG", JCG->( !dbSeek( cFilJCG+TRB->(JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP) ) ) )
		JCG->JCG_FILIAL	:= cFilJCG
		JCG->JCG_CODCUR	:= JCH->JCH_CODCUR
		JCG->JCG_PERLET	:= JCH->JCH_PERLET
		JCG->JCG_TURMA	:= JCH->JCH_TURMA
		JCG->JCG_DISCIP	:= JCH->JCH_DISCIP
		JCG->JCG_TIPO	:= Posicione( "JAR", 1, xFilial("JAR")+JCH->JCH_CODCUR+JCH->JCH_PERLET, "JAR_APFALT" )
		JCG->JCG_DATA	:= JCH->JCH_DATA
		JCG->( msUnlock() )

		end transaction
	endif
	
	begin transaction

	RecLock( "JCH", JCH->( !dbSeek( cFilJCH+TRB->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP+JCH_HORA1) ) ) )
	JCH->JCH_FILIAL	:= cFilJCH
	JCH->JCH_NUMRA	:= TRB->JCH_NUMRA
	JCH->JCH_CODCUR	:= TRB->JCH_CODCUR
	JCH->JCH_PERLET	:= TRB->JCH_PERLET
	JCH->JCH_TURMA	:= TRB->JCH_TURMA
	JCH->JCH_DATA	:= TRB->JCH_DATA
	JCH->JCH_DISCIP	:= TRB->JCH_DISCIP
	JCH->JCH_HORA1	:= TRB->JCH_HORA1
	JCH->JCH_TIPO	:= TRB->JCH_TIPO
	JCH->JCH_QTD	:= TRB->JCH_QTD
	JCH->( msUnlock() )

	end transaction

	TRB->( dbSkip() )
end

Return !lEnd