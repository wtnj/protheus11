#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13500  ºAutor  ³Rafael Rodrigues    º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Bolsas x Alunos.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC13500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13500.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JC5_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JC5_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JC5_TIPBOL", "C", 006, 0 } )
aAdd( aStru, { "JC5_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JC5_BOLSA" , "C", 006, 0 } )
aAdd( aStru, { "JC5_PERBOL", "N", 006, 2 } )
aAdd( aStru, { "JC5_VLRBOL", "N", 009, 2 } )
aAdd( aStru, { "JC5_DTVAL1", "D", 008, 0 } )
aAdd( aStru, { "JC5_DTVAL2", "D", 008, 0 } )
aAdd( aStru, { "JC5_PERDE" , "C", 001, 0 } )
aAdd( aStru, { "JC5_CLIENT", "C", 006, 0 } )
aAdd( aStru, { "JC5_MATR"  , "C", 001, 0 } )

aAdd( aFiles, { 'Bolsas x Alunos', '\Import\AC13501.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JC5_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JC5_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JC5_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JC5_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Observações', '\Import\AC13502.TXT', aClone( aStru ), 'TRB02', .F. } )

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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JC5_NUMRA )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JC5_NUMRA )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JC5_NUMRA+JC5_ITEM" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JC5_NUMRA+JC5_ITEM+JC5_SEQ" ), NIL ) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JC5_NUMRA)  '	, 'RA do Aluno não informado.' } )
		aAdd( aObrig, { 'JC5_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JC5_NUMRA, "JA2_NUMRA" )', 'Aluno não cadastrado na tabea JA2.' } )
		aAdd( aObrig, { '!Empty(JC5_ITEM)   '	, 'Item não informado.' } )
		aAdd( aObrig, { '!Empty(JC5_TIPBOL) '	, 'Tipo de Bolsa não informado.' } )
		aAdd( aObrig, { 'JC5_TIPBOL == Posicione( "JC4", 1, xFilial("JC4")+JC5_TIPBOL, "JC4_COD" )', 'Tipo de bolsa não cadastrado na tabela JC4.' } )
		aAdd( aObrig, { 'JC5_PERBOL <= 100'		, 'Percentual de bolsa superior a 100%.' } )
		aAdd( aObrig, { '!Empty(JC5_BOLSA)  '	, 'Número de controle da bolsa não informado.' } )
		aAdd( aObrig, { 'JC5_PERDE$"12"'		, '"Perde Bolsa?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JC5_MATR$"12"'			, '"Bolsa incide na matrícula?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'Empty(JC5_CLIENT) .or. JC5_CLIENT == Posicione( "SA1", 1, xFilial("SA1")+JC5_CLIENT, "A1_COD" )', 'Parceria de convênio não cadastrada na tabela SA1.' } )
		aAdd( aObrig, { 'Empty(JC5_DTVAL1) == Empty(JC5_DTVAL2)', 'Datas de inicio e fim de validade devem ser informadas conjuntamente.' } )
		aAdd( aObrig, { 'Empty(JC5_DTVAL1) .or. JC5_DTVAL1 <= JC5_DTVAL2', 'Data de inicio da validade deve ser menor ou igual à data final.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB01", "JC5_NUMRA+JC5_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JC5_NUMRA) '	, 'RA do aluno não informado.' } )
		aAdd( aObrig, { '!Empty(JC5_ITEM)   '	, 'Item não informado.' } )
		aAdd( aObrig, { '!Empty(JC5_SEQ)    '	, 'Sequencial de linha não informada.' } )
		aAdd( aObrig, { 'JC5_NUMRA == Posicione( "JC5", 1, xFilial("JC5")+JC5_NUMRA+JC5_ITEM, "JC5_NUMRA" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JC5_NUMRA+TRB02->JC5_ITEM, .F. ) ) )'	, 'Bolsa x Aluno não cadastrada na tabela JC5 e não presente nos arquivos de importação.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB02", "JC5_NUMRA+JC5_PERLET+JC5_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC13501Grv( @lEnd, aFiles[1,1] ) .and. xAC13502Grv( @lEnd, aFiles[2,1] ) }, 'Gravação em andamento' )
		
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
±±ºPrograma  ³xAC13501GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13500                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13501Grv( lEnd, cTitulo )
Local cFilJC5	:= xFilial("JC5")	// Criada para ganhar performance
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JC5->( dbSetOrder(3) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JC5", JC5->( !dbSeek( cFilJC5+TRB01->JC5_NUMRA+TRB01->JC5_ITEM ) ) )
	JC5->JC5_FILIAL	:= cFilJC5
	JC5->JC5_NUMRA	:= TRB01->JC5_NUMRA
	JC5->JC5_ITEM	:= TRB01->JC5_ITEM
	JC5->JC5_TIPBOL	:= TRB01->JC5_TIPBOL
	JC5->JC5_CURSO	:= TRB01->JC5_CURSO
	JC5->JC5_BOLSA	:= TRB01->JC5_BOLSA
	JC5->JC5_PERBOL	:= TRB01->JC5_PERBOL
	JC5->JC5_VLRBOL	:= TRB01->JC5_VLRBOL
	JC5->JC5_DTVAL1	:= TRB01->JC5_DTVAL1
	JC5->JC5_DTVAL2	:= TRB01->JC5_DTVAL2
	JC5->JC5_PERDE	:= TRB01->JC5_PERDE
	JC5->JC5_CLIENT	:= TRB01->JC5_CLIENT
	JC5->JC5_LOJA	:= TRB01->JC5_LOJA
	JC5->JC5_MATR	:= TRB01->JC5_MATR
	JC5->( msUnlock() )
	
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13502GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Observacoes na base.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13500                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13502Grv( lEnd, cTitulo )
Local cFilJC5	:= xFilial("JC5")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JC5->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB02->JC5_NUMRA+TRB02->JC5_ITEM
	
	while cChave == TRB02->JC5_NUMRA+TRB02->JC5_ITEM .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JC5_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JC5->( dbSeek( cFilJC5+cChave ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JC5_OBSERV³
		//³e armazena o codigo do memo no campo JC5_MEMO1. Sobrescreve caso JC5_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JC5", .F. )
		MSMM( JC5->JC5_MEMO1, TamSX3("JC5_OBSERV")[1],, cMemo, 1,,, "JC5", "JC5_MEMO1" )
		JC5->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd