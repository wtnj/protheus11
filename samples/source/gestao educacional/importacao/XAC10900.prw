#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC10900  บAutor  ณRafael Rodrigues    บ Data ณ  12/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Grade Curricular do Curso Padrao      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC10900()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC10900.log'
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

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAY_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JAY_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAY_QTDFAT", "N", 003, 0 } )
aAdd( aStru, { "JAY_VALOR" , "N", 012, 2 } )
aAdd( aStru, { "JAY_CONSDP", "C", 001, 0 } )
aAdd( aStru, { "JAY_STATUS", "C", 001, 0 } )

aAdd( aFiles, { 'Grades Curr. dos Cursos', '\Import\AC10901.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAY_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conte๚dos das Grades', '\Import\AC10902.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAY_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias das Grades', '\Import\AC10903.TXT', aClone( aStru ), 'TRB03', .F. } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a janela para selecao de arquivos e importacao dos temporariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aTables	:= U_xACGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo p๔de ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo p๔de ser importado para este processo.', {'Ok'} )
else
	
	lDBF01	:= aScan( aTables, {|x| x[1] == "TRB01"} ) > 0
	lDBF02	:= aScan( aTables, {|x| x[1] == "TRB02"} ) > 0
	lDBF03	:= aScan( aTables, {|x| x[1] == "TRB03"} ) > 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณantes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAY_CURSO )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAY_CURSO )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif
	
	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JAY_CURSO )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณordena os arquivos de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ" ), NIL ),;
											if( lDBF02, IndRegua( "TRB03", cIDX03, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ" ), NIL ) } )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณprepara as consistencias a serem feitas no arquivo temporarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'Curso nใo informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Versใo nใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Perํodo letivo ใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina nใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CARGA)  '	, 'Carga horแria nใo informada.' } )
		aAdd( aObrig, { 'JAY_TIPO$"12"' 		, 'Tipo deve ser 1 (Obrigat๓rio) ou 2 (Optativo).' } )
		aAdd( aObrig, { '!Empty(JAY_FRQMIN)'	, 'Frequ๊ncia mํnima nใo informada.' } )
		aAdd( aObrig, { 'JAY_CONSDP$"12"' 		, '"Considera DP na Quantidade Mแxima" deve ser 1 (Sim) ou 2 (Nใo).' } )
		aAdd( aObrig, { 'JAY_STATUS$"12"' 		, 'Tipo na grade deve ser 1 (Obrigat๓rio) ou 2 (Optativo).' } )
		aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAF", 1, xFilial("JAF")+JAY_CURSO+JAY_VERSAO, "JAF_COD" )', 'Curso/Versใo nใo cadastrado na tabela JAF.' } )
		aAdd( aObrig, { 'JAY_PERLET == Posicione( "JAW", 1, xFilial("JAW")+JAY_CURSO+JAY_VERSAO+JAY_PERLET, "JAW_PERLET" )'	, 'Perํodo Letivo nใo cadastrado na tabela JAW.' } )
		aAdd( aObrig, { 'JAY_CODDIS == Posicione( "JAE", 1, xFilial("JAE")+JAY_CODDIS, "JAE_CODIGO" )'	, 'Disciplina nใo cadastrada na tabela JAE.' } )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณverifica chaves unicas e consistencias pre-definidasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		U_xAddLog( cLog, '  .Iniciando valida็ใo do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB01", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_xAC109CH( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da valida็ใo do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'C๓digo nใo informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Versใo nใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Perํodo letivo ใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina nใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_SEQ)    '	, 'Sequencial de linha nใo informada.' } )
		aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAY_CURSO+TRB02->JAY_VERSAO+TRB02->JAY_PERLET+TRB02->JAY_CODDIS, .F. ) ) )', 'Grade curricular nใo cadastrada na tabela JAY e nใo presente nos arquivos de importa็ใo.' } )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณverifica chaves unicas e consistencias pre-definidasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		U_xAddLog( cLog, '  .Iniciando valida็ใo do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB02", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da valida็ใo do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'C๓digo nใo informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Versใo nใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Perํodo letivo ใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina nใo informada.' } )
		aAdd( aObrig, { '!Empty(JAY_SEQ)    '	, 'Sequencial de linha nใo informada.' } )
		aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JAY_CURSO+TRB03->JAY_VERSAO+TRB03->JAY_PERLET+TRB03->JAY_CODDIS, .F. ) ) )', 'Grade curricular nใo cadastrada na tabela JAY e nใo presente nos arquivos de importa็ใo.' } )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณverifica chaves unicas e consistencias pre-definidasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		U_xAddLog( cLog, '  .Iniciando valida็ใo do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB03", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da valida็ใo do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	
	
	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsist๊ncias. Impossํvel prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Impossํvel Prosseguir!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else

		nRecs += if( lDBF01, TRB01->( RecCount() ), 0 )
		nRecs += if( lDBF02, TRB02->( RecCount() ), 0 )
		nRecs += if( lDBF03, TRB03->( RecCount() ), 0 )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRealiza a gravacao dos dados nas tabelas do sistemaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC10901Grv( @lEnd, aFiles[1,1] ) .and. xAC10902Grv( @lEnd, aFiles[2,1] ) .and. xAC10903Grv( @lEnd, aFiles[3,1] ) }, 'Grava็ใo em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de grava็ใo interrompido pelo usuแrio. Serแ necessแrio reiniciar o processo de importa็ใo.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Opera็ใo Cancelada!', 'O processo de grava็ใo foi interrompido pelo usuแrio. Serแ necessแrio reiniciar o processo de importa็ใo.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Grava็ใo realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX01 + OrdBagExt() )
	FErase( cIDX02 + OrdBagExt() )
	
endif

U_xSaveLog( cLog, cLogFile )
U_xKillLog( cLog )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณElimina os arquivos de trabalho criadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
for i := 1 to len( aTables )
	dbSelectArea( aTables[i][1] )
	dbCloseArea()
	FErase( aTables[i][2]+GetDBExtension() )
next i

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC10901GrvบAutor  ณRafael Rodrigues   บ Data ณ  12/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados do arquivo principal na base.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC10900                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC10901Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local cChave	:= ""
Local nItem		:= 0
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )

	if cChave <> TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		cChave	:= TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		nItem	:= 0
	endif
	
	begin transaction
	
	RecLock( "JAY", JAY->( !dbSeek( cFilJAY+TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET+TRB01->JAY_CODDIS ) ) )
	JAY->JAY_FILIAL	:= cFilJAY
	JAY->JAY_CURSO	:= TRB01->JAY_CURSO
	JAY->JAY_VERSAO	:= TRB01->JAY_VERSAO
	JAY->JAY_PERLET	:= TRB01->JAY_PERLET
	JAY->JAY_CODDIS	:= TRB01->JAY_CODDIS
	JAY->JAY_ITEM	:= StrZero( ++nItem, TamSX3("JAY_ITEM")[1] )
	JAY->JAY_CARGA	:= TRB01->JAY_CARGA
	JAY->JAY_TIPO	:= TRB01->JAY_TIPO
	JAY->JAY_FRQMIN	:= TRB01->JAY_FRQMIN
	JAY->JAY_QTDFAT	:= TRB01->JAY_QTDFAT
	JAY->JAY_VALOR	:= TRB01->JAY_VALOR
	JAY->JAY_CONSDP	:= TRB01->JAY_CONSDP
	JAY->JAY_STATUS	:= TRB01->JAY_STATUS

	JAY->( msUnlock() )
		
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC10902GrvบAutor  ณRafael Rodrigues   บ Data ณ  12/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados dos Conteudos na base.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC10900                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC10902Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB02->JAY_CURSO+TRB02->JAY_VERSAO+TRB02->JAY_PERLET+TRB02->JAY_CODDIS
	
	while cChave == TRB02->JAY_CURSO+TRB02->JAY_VERSAO+TRB02->JAY_PERLET+TRB02->JAY_CODDIS .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )
		
		cMemo += StrTran( TRB02->JAY_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAY->( dbSeek( cFilJAY+cChave ) )
		begin transaction
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณgrava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAY_CONTEUณ
		//ณe armazena o codigo do memo no campo JAY_MEMO1. Sobrescreve caso JAY_MEMO1 esteja preenchidoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RecLock( "JAY", .F. )
		MSMM( JAY->JAY_MEMO1, TamSX3("JAY_CONTEU")[1],, cMemo, 1,,, "JAY", "JAY_MEMO1" )
		JAY->( msUnlock() )
		
		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC10903GrvบAutor  ณRafael Rodrigues   บ Data ณ  12/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados das Bibliografias na base.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC10900                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC10903Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB03->JAY_CURSO+TRB03->JAY_VERSAO+TRB03->JAY_PERLET+TRB03->JAY_CODDIS
	
	while cChave == TRB03->JAY_CURSO+TRB03->JAY_VERSAO+TRB03->JAY_PERLET+TRB03->JAY_CODDIS .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JAY_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAY->( dbSeek( cFilJAY+cChave ) )
		begin transaction
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณgrava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAY_BIBLIOณ
		//ณe armazena o codigo do memo no campo JAY_MEMO2. Sobrescreve caso JAY_MEMO2 esteja preenchidoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RecLock( "JAY", .F. )
		MSMM( JAY->JAY_MEMO2, TamSX3("JAY_CONTEU")[1],, cMemo, 1,,, "JAY", "JAY_MEMO2" )
		JAY->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC109CH  บAutor  ณRafael Rodrigues    บ Data ณ  12/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se a carga horaria dos periodos eh igual aa carga    บฑฑ
ฑฑบ          ณhoraria do curso.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC10900                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC109CH( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local nCHTot	:= 0
Local nCHDis	:= 0
Local cChave	:= ""
Local nLinha	:= 0
Local lLog		:= cLog <> NIL

TRB01->( dbGoTop() )

ProcRegua( TRB01->( RecCount() ) )

cChave	:= TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
nCHTot	:= Posicione( "JAW", 1, xFilial("JAW")+cChave, "JAW_CARGA" )
nLinha	:= TRB01->( Recno() )
while TRB01->( !eof() ) .and. !lEnd

	IncProc( 'Verificando carga horแria do curso '+Alltrim( TRB01->JAY_CURSO )+'...' )
	
	if cChave <> TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		if nCHTot <> nCHDis
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( nLinha, 6 )+': A soma das cargas horแrias das disciplinas ('+StrZero( nCHDis, 4 )+') nใo corresponde เ carga horแria total do perํodo ('+StrZero( nCHTot, 4 )+').', cLogFile )
			else
				exit
			endif
		endif
		
		cChave	:= TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		nCHTot	:= Posicione( "JAW", 1, xFilial("JAW")+cChave, "JAW_CARGA" )
		nLinha	:= TRB01->( Recno() )
		nCHDis	:= 0
	endif

	nCHDis += TRB01->JAY_CARGA
	
	TRB01->( dbSkip() )
end

lRet := lRet .and. !lEnd

Return lRet