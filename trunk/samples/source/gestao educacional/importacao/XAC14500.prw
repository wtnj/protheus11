#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC14500  ºAutor  ³Rafael Rodrigues    º Data ³  17/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa os Aproveitamentos de Estudos dos Alunos            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC14500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC14500.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JC8_DISC1" , "C", 015, 0 } )
aAdd( aStru, { "JC8_DISC2" , "C", 015, 0 } )
aAdd( aStru, { "JC8_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JC8_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JC8_TIPO"  , "C", 001, 0 } )

aAdd( aFiles, { 'Disciplinas Equivalentes', '\Import\AC14500.TXT', aClone( aStru ), 'TRB', .F. } )

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
	if Empty( TRB->JC8_DISC1 )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	aObrig := {}
	aAdd( aObrig, { '!Empty(JC8_DISC1)', 'Disciplina 1 não informada.' } )
	aAdd( aObrig, { 'JC8_DISC1 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC1, "JAE_CODIGO")', 'Disciplina 1 não existe na tabela JAE.' } )
	aAdd( aObrig, { '!Empty(JC8_DISC2)', 'Disciplina 2 não informada.' } )
	aAdd( aObrig, { 'JC8_DISC2 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC2, "JAE_CODIGO")', 'Disciplina 2 não existe na tabela JAE.' } )
	aAdd( aObrig, { 'JC8_DISC1 <> JC8_DISC2', 'Disciplinas 1 e 2 não podem ser a mesma.' } )
	aAdd( aObrig, { 'Posicione("JAE", 1, xFilial("JAE")+JC8_DISC1, "JAE_CARGA") == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC2, "JAE_CARGA") .or. JC8_TIPO <> "1"', 'A carga horária da Disciplina 1 não pode ser diferente da carga horária da Disciplina 2 quando o tipo de equivalência for 1.' } )
	aAdd( aObrig, { 'Empty(JC8_CURSO) .or. JC8_CURSO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO, "JAF_COD")', 'Curso informado não existe na tabela JAF.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) == Empty(JC8_CURSO)', 'A versão deve ser informada quando o curso for informado.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) .or. JC8_VERSAO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO+JC8_VERSAO, "JAF_VERSAO")', 'Versão informada não existe para o curso informado.' } )
	aAdd( aObrig, { 'JC8_TIPO$"123"', 'Tipo de Equivalência deve ser 1, 2 ou 3.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO" ) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
	
	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsistências. Impossível prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else

		nRecs := TRB->( RecCount() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC14500Grv( @lEnd, aFiles[1,1] ) }, 'Gravação em andamento' )
		
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
±±ºPrograma  ³xAC14500GrvºAutor  ³Rafael Rodrigues   º Data ³  17/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC14500                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC14500Grv( lEnd, cTitulo )
Local cFilJC8	:= xFilial("JC8")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

if Select( "TRB" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB->( dbGoTop() )

JC8->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction

	RecLock( "JC8", JC8->( !dbSeek( cFilJC8+TRB->JC8_DISC1+TRB->JC8_DISC2+TRB->JC8_CURSO+TRB->JC8_VERSAO ) ) )
	
	JC8->JC8_FILIAL	:= cFilJC8
	JC8->JC8_DISC1	:= TRB->JC8_DISC1
	JC8->JC8_DISC2	:= TRB->JC8_DISC2
	JC8->JC8_CURSO	:= TRB->JC8_CURSO
	JC8->JC8_VERSAO	:= TRB->JC8_VERSAO
	JC8->JC8_TIPO	:= TRB->JC8_TIPO
	JC8->( msUnlock() )

	end transaction

	TRB->( dbSkip() )	
end

Return !lEnd