#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC12300  บAutor  ณRafael Rodrigues    บ Data ณ  16/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Avaliacoes dos Cursos Vigentes        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC12300()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12300.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBQ_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBQ_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBQ_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JBQ_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JBQ_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JBQ_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JBQ_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBQ_PESO"  , "N", 002, 0 } )
aAdd( aStru, { "JBQ_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JBQ_CHAMAD", "C", 001, 0 } )
aAdd( aStru, { "JBQ_DTAPON", "D", 008, 0 } )

aAdd( aFiles, { 'Avalia็๕es dos Cursos Vigentes', '\Import\AC12300.TXT', aStru, 'TRB', .T. } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a janela para selecao de arquivos e importacao dos temporariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aTables	:= U_xACGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo p๔de ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo p๔de ser importado para este processo.', {'Ok'} )
else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณantes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TRB->( dbGoBottom() )
	if Empty( TRB->JBQ_CODCUR )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณprepara as consistencias a serem feitas no arquivo temporarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd( aObrig, { '!Empty(JBQ_CODCUR) ', 'C๓digo do curso vigente nใo informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_PERLET) ', 'Perํodo letivo nใo informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_ITEM)   ', 'Item nใo informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA1)  ', 'Data inicial nใo informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA2)  ', 'Data final nใo informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_CODAVA) ', 'C๓digo da avalia็ใo nใo informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_DESC)   ', 'Descri็ใo nใo informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_PESO)   ', 'Peso nใo informado.' } )
	aAdd( aObrig, { 'JBQ_TIPO$"1234"    ', 'Tipo deve ser 1 (Regular), 2 (Exame), 3 (Integrada) ou 4 (Nota ฺnica).' } )
	aAdd( aObrig, { 'JBQ_CHAMAD$"12"    ', 'Segunda chamada deve ser 1 (Sim) ou 2 (Nใo).' } )
	aAdd( aObrig, { '!Empty(JBQ_DTAPON) ', 'Data limite para apontamento nใo informado.' } )
	aAdd( aObrig, { 'JBQ_DTAPON >= JBQ_DATA1', 'Data limite para apontamento deve ser maior ou igual เ data inicial da avalia็ใo.' } )
	aAdd( aObrig, { 'JBQ_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBQ_CODCUR, "JAH_CODIGO" )', 'Curso vigente nใo cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JBQ_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_PERLET" )', 'Perํodo letivo nใo cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBQ_DATA1 >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA1" ) .and. JBQ_DATA1 <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA2" )', 'Data inicial fora do limite de datas do perํodo letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA2 >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA1" ) .and. JBQ_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA2" )', 'Data final fora do limite de datas do perํodo letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA1 <= JBQ_DATA2', 'Data inicial deve ser menor ou igual เ data final.' } )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณordena o arquivo de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBQ_CODCUR+JBQ_PERLET+JBQ_ITEM" ) } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณverifica chaves unicas e consistencias pre-definidasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JBQ_CODCUR+JBQ_PERLET+JBQ_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_xAC123Av( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida็ใo do Arquivo' )
	
	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsist๊ncias. Impossํvel prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Impossํvel Prosseguir!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRealiza a gravacao dos dados nas tabelas do sistemaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Processa( { |lEnd| lOk := xAC12300Grv( @lEnd ) }, 'Grava็ใo em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de grava็ใo interrompido pelo usuแrio. Serแ necessแrio reiniciar o processo de importa็ใo.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Opera็ใo Cancelada!', 'O processo de grava็ใo foi interrompido pelo usuแrio. Serแ necessแrio reiniciar o processo de importa็ใo.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Grava็ใo realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX + OrdBagExt() )
	
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
ฑฑบPrograma  ณxAC12300GrvบAutor  ณRafael Rodrigues   บ Data ณ  16/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados na base do AP6.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC12300                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC12300Grv( lEnd )
Local cFilJBQ	:= xFilial("JBQ")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBQ->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JBQ", JBQ->( !dbSeek( cFilJBQ+TRB->JBQ_CODCUR+TRB->JBQ_PERLET+TRB->JBQ_ITEM ) ) )
	JBQ->JBQ_FILIAL	:= cFilJBQ
	JBQ->JBQ_CODCUR	:= TRB->JBQ_CODCUR
	JBQ->JBQ_PERLET	:= TRB->JBQ_PERLET
	JBQ->JBQ_ITEM	:= TRB->JBQ_ITEM
	JBQ->JBQ_DATA	:= TRB->JBQ_DATA1
	JBQ->JBQ_DATA2	:= TRB->JBQ_DATA2
	JBQ->JBQ_CODAVA	:= TRB->JBQ_CODAVA
	JBQ->JBQ_DESC	:= TRB->JBQ_DESC
	JBQ->JBQ_PESO	:= TRB->JBQ_PESO
	JBQ->JBQ_TIPO	:= TRB->JBQ_TIPO
	JBQ->JBQ_CHAMAD	:= TRB->JBQ_CHAMAD
	JBQ->JBQ_DTAPON	:= TRB->JBQ_DTAPON
	JBQ->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC123Av  บAutor  ณRafael Rodrigues    บ Data ณ  16/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se nao existe a mesma avaliacao duas vezes no mesmo  บฑฑ
ฑฑบ          ณperiodo letivo.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC12300                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC123Av( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local cChave	:= ""
Local lLog		:= cLog <> NIL
Local aAvas		:= {}
Local cAva		:= ""
Local dData

TRB->( dbGoTop() )

ProcRegua( TRB->( RecCount() ) )
IncProc( 'Verificando as avalia็๕es do curso '+Alltrim( TRB->JBQ_CODCUR )+'...' )

while TRB->( !eof() ) .and. !lEnd

	cChave	:= TRB->JBQ_CODCUR+TRB->JBQ_PERLET
	aAvas	:= {}
	dData	:= TRB->JBQ_DATA1 - 1
	
	while cChave == TRB->JBQ_CODCUR+TRB->JBQ_PERLET .and. TRB->( !eof() ) .and. !lEnd .and. ( lLog .or. lRet )
		if aScan( aAvas, TRB->JBQ_CODAVA ) > 0
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( TRB->( Recno() ), 6 )+': Avalia็ใo "'+TRB->JBQ_CODAVA+'" encontrada duas vezes no mesmo curso vigente/perํodo letivo.', cLogFile )
			else
				exit
			endif
		else
			aAdd( aAvas, TRB->JBQ_CODAVA )
		endif
		
		if TRB->JBQ_DATA1 <= dData
			U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( TRB->( Recno() ), 6 )+': As datas das avalia็๕es '+cAva+' e '+TRB->JBQ_CODAVA+' estใo conflitantes.', cLogFile )
		endif
		
		dData	:= TRB->JBQ_DATA2
		cAva	:= TRB->JBQ_CODAVA
		TRB->( dbSkip() )
	end
	
	if !lLog .and. !lRet
		exit
	endif
end

lRet := lRet .and. !lEnd

Return lRet