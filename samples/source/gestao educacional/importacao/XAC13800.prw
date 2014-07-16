#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13800  ºAutor  ³Rafael Rodrigues    º Data ³  26/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Notas x Alunos                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC13800()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13800.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBS_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JBS_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JBS_ATIVID", "C", 002, 0 } )
aAdd( aStru, { "JBS_MATPRF", "C", 006, 0 } )
aAdd( aStru, { "JBS_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JBS_CONCEI", "C", 001, 0 } )
aAdd( aStru, { "JBS_NOTA"  , "N", 005, 2 } )
aAdd( aStru, { "JBS_COMPAR", "C", 001, 0 } )
aAdd( aStru, { "JBS_DTCHAM", "D", 008, 0 } )
aAdd( aStru, { "JBS_OUTRAT", "C", 001, 0 } )
aAdd( aStru, { "JBS_DTAPON", "D", 008, 0 } )

aAdd( aFiles, { 'Notas x Alunos', '\Import\AC13800.TXT', aStru, 'TRB', .T. } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTables	:= U_xACGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo pôde ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRB->( dbGoBottom() )
	if Empty( TRB->JBS_NUMRA )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd( aObrig, { '!Empty(JBS_CODCUR) ', 'Código do curso vigente não informado.' } )
	aAdd( aObrig, { '!Empty(JBS_PERLET) ', 'Período letivo não informado.' } )
	aAdd( aObrig, { '!Empty(JBS_TURMA)  ', 'Turma não informada.' } )
	aAdd( aObrig, { '!Empty(JBS_CODDIS) ', 'Disciplina não informada.' } )
	aAdd( aObrig, { '!Empty(JBS_CODAVA) ', 'Avaliação não informada.' } )
	aAdd( aObrig, { '!Empty(JBS_MATPRF) ', 'Matrícula do professor não informada.' } )
	aAdd( aObrig, { '!Empty(JBS_NUMRA)  ', 'RA do aluno não informado.' } )
	aAdd( aObrig, { 'JBS_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBS_CODCUR, "JAH_CODIGO" )', 'Curso vigente não cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JBS_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBS_CODCUR+JBS_PERLET, "JAR_PERLET" )', 'Período letivo não cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBS_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JBS_CODCUR+JBS_PERLET+JBS_TURMA, "JBO_TURMA" )', 'Turma não cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JBS_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JBS_CODCUR+JBS_PERLET+JBS_CODDIS, "JAS_CODDIS" )', 'Disciplina não cadastrada na tabela JAS.' } )
	aAdd( aObrig, { 'JBS_CODAVA == Posicione( "JBQ", 3, xFilial("JBQ")+JBS_CODCUR+JBS_PERLET+JBS_CODAVA, "JBQ_CODAVA" )', 'Avaliação não cadastrada na tabela JBQ.' } )
	aAdd( aObrig, { 'JBS_NUMRA == Posicione( "JC7", if(JBS_OUTRAT=="1",8,1), xFilial("JC7")+JBS_NUMRA+JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS, "JC7_NUMRA" )', 'Matrícula do aluno para esta disciplina não cadastrada na tabela JC7.' } )
	aAdd( aObrig, { 'Empty(JBS_ATIVID) .or. JBS_ATIVID == Posicione( "JDA", 1, xFilial("JDA")+JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID, "JDA_ATIVID" )', 'Atividade não cadastrada na tabela JDA.' } )
	aAdd( aObrig, { '!Empty(AcNomeProf(JBS_MATPRF))  ', 'Professor não cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'JBS_COMPAR$"12"      ', '"Compareceu?" deve ser 1 (sim) ou 2 (não).' } )
	aAdd( aObrig, { 'JBS_OUTRAT$"12"      ', '"Aluno de outra turma?" deve ser 1 (sim) ou 2 (não).' } )
	aAdd( aObrig, { '!Empty(JBS_DTAPON) ', 'Data de apontamento não informada.' } )
	aAdd( aObrig, { '!Empty(JBS_CONCEI) .or. Posicione( "JAR", 1, xFilial("JAR")+JBS_CODCUR+JBS_PERLET, "JAR_CRIAVA" ) != "2" ', 'Conceito não informado. Este período letivo avalia por conceito.' } )
	aAdd( aObrig, { 'JBS_NOTA <= 10', 'Nota maior que 10.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_NUMRA+JBS_OUTRAT" ) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_NUMRA", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validação do Arquivo' )
	
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
		Processa( { |lEnd| lOk := xAC13800Grv( @lEnd ) }, 'Gravação em andamento' )
		
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
±±ºPrograma  ³xAC13800GrvºAutor  ³Rafael Rodrigues   º Data ³  26/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13800Grv( lEnd )
Local cFilJBR	:= xFilial("JBR")	// Criada para ganhar performance
Local cFilJBS	:= xFilial("JBS")	// Criada para ganhar performance
Local cFilJDB	:= xFilial("JDB")	// Criada para ganhar performance
Local cFilJDC	:= xFilial("JDC")	// Criada para ganhar performance
Local i			:= 0
Local cKeyJBR	:= ""
Local cKeyJBS	:= ""
Local cKeyJDB	:= ""

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBR->( dbSetOrder(1) )
JBS->( dbSetOrder(1) )
JDB->( dbSetOrder(1) )
JDC->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cKeyJBR <> TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_OUTRAT)
		cKeyJBR := TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_OUTRAT)

		begin transaction

		RecLock( "JBR", JBR->( !dbSeek( cFilJBR+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA) ) ) )
		JBR->JBR_FILIAL	:= cFilJBR
		JBR->JBR_CODCUR	:= TRB->JBS_CODCUR
		JBR->JBR_PERLET	:= TRB->JBS_PERLET
		JBR->JBR_TURMA	:= TRB->JBS_TURMA
		JBR->JBR_CODDIS	:= TRB->JBS_CODDIS
		JBR->JBR_CODAVA	:= TRB->JBS_CODAVA
		JBR->JBR_MATPRF	:= TRB->JBS_MATPRF
		JBR->( msUnlock() )

		end transaction
	endif
	
	if cKeyJBS <> TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA)
		cKeyJBS := TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA)

		begin transaction

		RecLock( "JBS", JBS->( !dbSeek( cFilJBS+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA) ) ) )
		JBS->JBS_FILIAL	:= cFilJBS
		JBS->JBS_NUMRA	:= TRB->JBS_NUMRA
		JBS->JBS_CODCUR	:= TRB->JBS_CODCUR
		JBS->JBS_PERLET	:= TRB->JBS_PERLET
		JBS->JBS_TURMA	:= TRB->JBS_TURMA
		JBS->JBS_CODAVA	:= TRB->JBS_CODAVA
		JBS->JBS_CODDIS	:= TRB->JBS_CODDIS
		JBS->JBS_MATPRF	:= TRB->JBS_MATPRF
		JBS->JBS_CONCEI	:= TRB->JBS_CONCEI
		JBS->JBS_NOTA	:= TRB->JBS_NOTA
		JBS->JBS_COMPAR	:= TRB->JBS_COMPAR
		JBS->JBS_DTCHAM	:= TRB->JBS_DTCHAM
		JBS->JBS_OUTRAT	:= TRB->JBS_OUTRAT
		JBS->JBS_DTAPON	:= TRB->JBS_DTAPON
		JBS->( msUnlock() )

		end transaction
	endif

	if !Empty( TRB->JBS_ATIVID )
		if cKeyJDB <> TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_OUTRAT)
			cKeyJDB := TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_OUTRAT)
	
			begin transaction
	
			RecLock( "JDB", JDB->( !dbSeek( cFilJDB+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+if(JBS_OUTRAT=="1","2","1") ) ) ) )
			JDB->JDB_FILIAL	:= cFilJDB
			JDB->JDB_CODCUR	:= TRB->JBS_CODCUR
			JDB->JDB_PERLET	:= TRB->JBS_PERLET
			JDB->JDB_TURMA	:= TRB->JBS_TURMA
			JDB->JDB_CODDIS	:= TRB->JBS_CODDIS
			JDB->JDB_CODAVA	:= TRB->JBS_CODAVA
			JDB->JDB_ATIVID	:= TRB->JBS_ATIVID
			JDB->( msUnlock() )
	
			end transaction
		endif
	
		begin transaction
	
		RecLock( "JDC", JDC->( !dbSeek( cFilJDC+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+if(JBS_OUTRAT=="1","2","1")+JBS_NUMRA ) ) ) )
		JDC->JDC_FILIAL	:= cFilJBC
		JDC->JDC_CODCUR	:= TRB->JBS_CODCUR
		JDC->JDC_PERLET	:= TRB->JBS_PERLET
		JDC->JDC_TURMA	:= TRB->JBS_TURMA
		JDC->JDC_CODDIS	:= TRB->JBS_CODDIS
		JDC->JDC_CODAVA	:= TRB->JBS_CODAVA
		JDC->JDC_ATIVID	:= TRB->JBS_ATIVID
		JDC->JDC_NUMRA	:= TRB->JBS_NUMRA
		JDC->JDC_OUTRAT	:= TRB->JBS_OUTRAT
		JDC->JDC_CONCEI	:= TRB->JBS_CONCEI
		JDC->JDC_NOTA	:= TRB->JBS_NOTA
		JDC->JDC_COMPAR	:= TRB->JBS_COMPAR
		JDC->JDC_DTCHAM	:= TRB->JBS_DTCHAM
		JDC->( msUnlock() )
	
		end transaction
	endif

	TRB->( dbSkip() )
end

Return !lEnd