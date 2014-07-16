#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13000  ºAutor  ³Rafael Rodrigues    º Data ³ 10/Fev/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Atividades das Avaliacoes             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC13000( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC13000'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv		:= 0

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JDA_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JDA_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JDA_HABILI" , "C", 003, 0 } )
aAdd( aStru, { "JDA_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JDA_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JDA_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JDA_ATIVID", "C", 002, 0 } )
aAdd( aStru, { "JDA_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JDA_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JDA_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JDA_PESO"  , "N", 002, 0 } )
aAdd( aStru, { "JDA_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JDA_CHAMAD", "C", 001, 0 } )
aAdd( aStru, { "JDA_DTAPON", "D", 008, 0 } )    

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Atividades das Avaliações', 'AC13000', aClone( aStru ), 'TRB', .T., 'JDA_CODCUR, JDA_PERLET, JDA_HABILI, JDA_TURMA, JDA_CODDIS, JDA_CODAVA, JDA_ATIVID' } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 2	// So processamento
	U_xOpen( aTables, aFiles, aDriver, .F. ) 
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver, .F., nOpc == 1 )
	if nOpc == 1
		Return aTables
	endif
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo pôde ser importado para este processo.' )
	Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDrv := aScan( aDriver, aTables[1,3] )
	if nDrv # 3
		TRB->( dbGoBottom() )
		if Empty( TRB->JDA_CODCUR )
			RecLock( "TRB", .F. )
			TRB->( dbDelete() )
			TRB->( msUnlock() )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

	aAdd( aObrig, { '!Empty(JDA_CODCUR) ', 'Código do curso vigente não informado.' } )
	aAdd( aObrig, { '!Empty(JDA_PERLET) ', 'Período letivo não informado.' } )
	aAdd( aObrig, { '!Empty(JDA_TURMA)  ', 'Turma não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_CODDIS) ', 'Disciplina não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_CODAVA) ', 'Avaliação não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_ATIVID) ', 'Atividade não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_DESC)   ', 'Descrição não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_DATA1)  ', 'Data inicial não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_DATA2)  ', 'Data final não informada.' } )
	aAdd( aObrig, { '!Empty(JDA_PESO)   ', 'Peso não informado.' } )
	aAdd( aObrig, { 'JDA_TIPO$"12"      ', 'Tipo deve ser 1 (Regular) ou 2 (Integrada).' } )
	aAdd( aObrig, { 'JDA_CHAMAD$"12"    ', 'Segunda chamada deve ser 1 (Sim) ou 2 (Não).' } )
	aAdd( aObrig, { '!Empty(JDA_DTAPON) ', 'Data limite para apontamento não informado.' } )
	aAdd( aObrig, { 'JDA_CODAVA == Posicione( "JBQ", 1, xFilial("JBQ")+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_CODAVA, "JBQ_CODAVA" )', 'Período letivo não cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JDA_TURMA == Posicione( "JBO", 1, xFilial("JBO")+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA, "JBO_TURMA" )', 'Turma não cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JDA_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_CODDIS, "JAS_CODDIS" )', 'Disciplina não cadastrada na tabela JAS.' } )
	aAdd( aObrig, { 'JDA_DATA1 >= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA1" ) .and. JDA_DATA1 <= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA2" )', 'Data inicial fora do limite de datas do período letivo.' } )
	aAdd( aObrig, { 'JDA_DATA2 >= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA1" ) .and. JDA_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA2" )', 'Data final fora do limite de datas do período letivo.' } )
	aAdd( aObrig, { 'JDA_DATA1 <= JDA_DATA2', 'Data inicial deve ser menor ou igual à data final.' } )  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv # 3  
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID" ) } )
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )

	Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validação do Arquivo' )

	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsistências. Impossível prosseguir.' )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else 

		nRecs := TRB->( RecCount() ) 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if nOpc == 0
			Processa( { |lEnd| lOk := u_x13000Grv( @lEnd, aTables[1,4] ) }, 'Gravação em andamento' )
		else	
			lOk := xAC13000Grv( @lEnd, aTables[1,4] )
		endif	

		if !lOk 
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.' )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else 
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Gravação realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Elimina os arquivos de trabalho criados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRB->( dbCloseArea() )
	if nDrv # 3 
		FErase( cIDX + OrdBagExt() )
	endif
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13000GrvºAutor  ³Rafael Rodrigues   º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13000                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13000Grv( lEnd, nRecs )
Local cFilJDA	:= xFilial("JDA")	// Criada para ganhar performance
Local cFilJD9	:= xFilial("JD9")	// Criada para ganhar performance
Local i			:= 0
Local cChave	:= ""

ProcRegua( nRecs )

if Select( "TRB" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB->( dbGoTop() )
JDA->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )

	if cChave <> TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA )
		cChave := TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA )
		Reclock("JD9",.T.)
		JD9->JD9_FILIAL := cFilJD9
		JD9->JD9_CODCUR := TRB->JDA_CODCUR
		JD9->JD9_PERLET := TRB->JDA_PERLET
		JD9->JD9_HABILI := TRB->JDA_HABILI
		JD9->JD9_TURMA  := TRB->JDA_TURMA
		JD9->JD9_CODDIS := TRB->JDA_CODDIS
		JD9->JD9_CODAVA := TRB->JDA_CODAVA
		JD9->JD9_MATPRF := Posicione( "JBL", 1, xFilial("JBL")+TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS ), "JBL_MATPRF" )
		JD9->( MsUnlock() )
	endif
	RecLock( "JDA", JDA->( !dbSeek( cFilJDA+TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID ) ) ) )
	JDA->JDA_FILIAL	:= cFilJDA
	JDA->JDA_CODCUR	:= TRB->JDA_CODCUR
	JDA->JDA_PERLET	:= TRB->JDA_PERLET
	JDA->JDA_HABILI	:= TRB->JDA_HABILI
	JDA->JDA_TURMA	:= TRB->JDA_TURMA
	JDA->JDA_CODDIS	:= TRB->JDA_CODDIS
	JDA->JDA_CODAVA	:= TRB->JDA_CODAVA
	JDA->JDA_ATIVID	:= TRB->JDA_ATIVID
	JDA->JDA_DATA1	:= TRB->JDA_DATA1
	JDA->JDA_DATA2	:= TRB->JDA_DATA2
	JDA->JDA_DESC	:= TRB->JDA_DESC
	JDA->JDA_PESO	:= TRB->JDA_PESO
	JDA->JDA_TIPO	:= TRB->JDA_TIPO
	JDA->JDA_CHAMAD	:= TRB->JDA_CHAMAD
	JDA->JDA_DTAPON	:= TRB->JDA_DTAPON
	JDA->( msUnlock() )
	
	TRB->( dbSkip() )
end
Return !lEnd