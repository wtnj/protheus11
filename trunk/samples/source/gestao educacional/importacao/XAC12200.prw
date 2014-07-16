#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12200  ºAutor  ³Rafael Rodrigues    º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Grade Curricular dos Cursos Vigentes  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC12200()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12200.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local lDBF03	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAS_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAS_QTDFAT", "N", 003, 0 } )
aAdd( aStru, { "JAS_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JAS_VALOR" , "N", 012, 2 } )
aAdd( aStru, { "JAS_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JAS_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JAS_TIPNOT", "C", 001, 0 } )
aAdd( aStru, { "JAS_ESCDIA", "C", 001, 0 } )

aAdd( aFiles, { 'Grades dos Cursos Vigentes', '\Import\AC12201.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAS_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conteúdos Programáticos', '\Import\AC12202.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAS_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias', '\Import\AC12203.TXT', aClone( aStru ), 'TRB03', .F. } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTables	:= U_xACGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo pôde ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
else
	
	lDBF01	:= aScan( aTables, {|x| x[1] == "TRB01"} ) > 0
	lDBF02	:= aScan( aTables, {|x| x[1] == "TRB02"} ) > 0
	lDBF03	:= aScan( aTables, {|x| x[1] == "TRB03"} ) > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAS_CODCUR )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAS_CODCUR )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif

	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JAS_CODCUR )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAS_CODCUR+JAS_PERLET+JAS_ITEM" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAS_CODCUR+JAS_PERLET+JAS_ITEM+JAS_SEQ" ), NIL ),;
											if( lDBF03, IndRegua( "TRB03", cIDX03, "JAS_CODCUR+JAS_PERLET+JAS_ITEM+JAS_SEQ" ), NIL ) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Período letivo não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_ITEM)   '	, 'Item não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina não informada.' } )
		aAdd( aObrig, { '!Empty(JAS_CARGA)  '	, 'Carga Horária não informada.' } )
		aAdd( aObrig, { '!Empty(JAS_FRQMIN) '	, 'Frequência mínima não informada.' } )
		aAdd( aObrig, { 'StrZero( Val( JAS_ITEM ), 2 ) == JAS_ITEM', 'Item deve ser preenchido com zeros à esquerda (ex: 01, 02...).' } )
		aAdd( aObrig, { 'JAS_TIPO$"12"'			, 'Tipo deve ser 1 (Obrigatória) ou 2 (Optativa).' } )
		aAdd( aObrig, { 'JAS_TIPNOT$"123"'		, 'Tipo de nota deve ser 1 (Nota Única), 2 (Por Avaliação) ou 3 (Por Atividades).' } )
		aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JAS_CODCUR, "JAH_CODIGO" )', 'Curso vigente não cadastrado na tabela JAH.' } )
		aAdd( aObrig, { 'JAS_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JAS_CODCUR+JAS_PERLET, "JAR_PERLET" )', 'Período letivo não cadastrado na tabela JAR.' } )
		aAdd( aObrig, { 'JAS_CODDIS == Posicione( "JAE", 1, xFilial("JAE")+JAS_CODDIS, "JAE_CODIGO" )', 'Disciplina não cadastrada na tabela JAE.' } )
		aAdd( aObrig, { '( Empty( JAS_DATA1 ) .and. Empty( JAS_DATA2 ) ) .or. ( !Empty( JAS_DATA1 ) .and. !Empty( JAS_DATA2 ) )', 'Datas de início e fim da disciplina devem ser informadas conjuntamente.' } )
		aAdd( aObrig, { 'Empty( JAS_DATA1 ) .or. Empty( JAS_DATA2 ) .or. JAS_DATA1 <= JAS_DATA2', 'Data de início da disciplina deve ser menor que a data final.' } )
		aAdd( aObrig, { 'JAS_ESCDIA$"12"', '"Escolhe dia?" deve ser 1=Sim ou 2=Não.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB01", "JAS_CODCUR+JAS_PERLET+JAS_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Período letivo não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_ITEM)   '	, 'Item não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina não informada.' } )
		aAdd( aObrig, { '!Empty(JAS_SEQ)    '	, 'Sequencial de linha não informada.' } )
		aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 1, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_ITEM, "JAS_CODCUR" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAS_CODCUR+TRB02->JAS_PERLET+TRB02->JAS_ITEM, .F. ) ) )'	, 'Curso vigente não cadastrado na tabela JAS e não presente nos arquivos de importação.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB02", "JAS_CODCUR+JAS_PERLET+JAS_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Período letivo não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_ITEM)   '	, 'Item não informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina não informada.' } )
		aAdd( aObrig, { '!Empty(JAS_SEQ)    '	, 'Sequencial de linha não informada.' } )
		aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 1, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_ITEM, "JAS_CODCUR" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JAS_CODCUR+TRB03->JAS_PERLET+TRB03->JAS_ITEM, .F. ) ) )'	, 'Curso vigente não cadastrado na tabela JAS e não presente nos arquivos de importação.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB03", "JAS_CODCUR+JAS_PERLET+JAS_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsistências. Impossível prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else

		nRecs += if( lDBF01, TRB01->( RecCount() ), 0 )
		nRecs += if( lDBF02, TRB02->( RecCount() ), 0 )
		nRecs += if( lDBF03, TRB03->( RecCount() ), 0 )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC12201Grv( @lEnd, aFiles[1,1] ) .and. xAC12202Grv( @lEnd, aFiles[2,1] ) .and. xAC12203Grv( @lEnd, aFiles[3,1] ) }, 'Gravação em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Gravação realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX01 + OrdBagExt() )
	FErase( cIDX02 + OrdBagExt() )
	FErase( cIDX03 + OrdBagExt() )
	
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
±±ºPrograma  ³xAC12201GrvºAutor  ³Rafael Rodrigues   º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12201Grv( lEnd, cTitulo )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAS->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JAS", JAS->( !dbSeek( cFilJAS+TRB01->JAS_CODCUR+TRB01->JAS_PERLET+TRB01->JAS_ITEM ) ) )
	JAS->JAS_FILIAL	:= cFilJAS
	JAS->JAS_CODCUR	:= TRB01->JAS_CODCUR
	JAS->JAS_PERLET	:= TRB01->JAS_PERLET
	JAS->JAS_ITEM	:= TRB01->JAS_ITEM
	JAS->JAS_CODDIS	:= TRB01->JAS_CODDIS
	JAS->JAS_CARGA	:= TRB01->JAS_CARGA
	JAS->JAS_FRQMIN	:= TRB01->JAS_FRQMIN
	JAS->JAS_QTDFAT	:= TRB01->JAS_QTDFAT
	JAS->JAS_TIPO	:= TRB01->JAS_TIPO
	JAS->JAS_VALOR	:= TRB01->JAS_VALOR
	JAS->JAS_DATA1	:= TRB01->JAS_DATA1
	JAS->JAS_DATA2	:= TRB01->JAS_DATA2
	JAS->JAS_ESCDIA	:= TRB01->JAS_ESCDIA
	JAS->( msUnlock() )
	
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12202GrvºAutor  ³Rafael Rodrigues   º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12202Grv( lEnd, cTitulo )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAS->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB02->JAS_CODCUR+TRB02->JAS_PERLET+TRB02->JAS_ITEM
	
	while cChave == TRB02->JAS_CODCUR+TRB02->JAS_PERLET+TRB02->JAS_ITEM .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JAS_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAS->( dbSeek( cFilJAS+cChave ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAS_CONTEU³
		//³e armazena o codigo do memo no campo JAS_MEMO1. Sobrescreve caso JAS_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAS", .F. )
		MSMM( JAS->JAS_MEMO1, TamSX3("JAS_CONTEU")[1],, cMemo, 1,,, "JAS", "JAS_MEMO1" )
		JAS->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12203GrvºAutor  ³Rafael Rodrigues   º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Bibliografias na base.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12203Grv( lEnd, cTitulo )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JAS->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB03->JAS_CODCUR+TRB03->JAS_PERLET+TRB03->JAS_ITEM
	
	while cChave == TRB03->JAS_CODCUR+TRB03->JAS_PERLET+TRB03->JAS_ITEM .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JAS_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAS->( dbSeek( cFilJAS+cChave ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAS_BIBLIO³
		//³e armazena o codigo do memo no campo JAS_MEMO2. Sobrescreve caso JAS_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAS", .F. )
		MSMM( JAS->JAS_MEMO2, TamSX3("JAS_BIBLIO")[1],, cMemo, 1,,, "JAS", "JAS_MEMO2" )
		JAS->( msUnlock() )

		end transaction
	endif

end

Return !lEnd