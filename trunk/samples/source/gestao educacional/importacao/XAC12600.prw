#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC12600  บAutor  ณRafael Rodrigues    บ Data ณ  17/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Cursos Vigentes x Financeiro          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC12600()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12600.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JB5_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JB5_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JB5_PARCEL", "C", 002, 0 } )
aAdd( aStru, { "JB5_CODFIN", "C", 010, 0 } )
aAdd( aStru, { "JB5_VALOR" , "N", 012, 2 } )
aAdd( aStru, { "JB5_MATPAG", "C", 001, 0 } )
aAdd( aStru, { "JB5_PAGTO1", "C", 002, 0 } )
aAdd( aStru, { "JB5_TPPAG1", "C", 001, 0 } )
aAdd( aStru, { "JB5_DESC1" , "N", 012, 2 } )
aAdd( aStru, { "JB5_PERC1" , "N", 006, 2 } )
aAdd( aStru, { "JB5_PAGTO2", "C", 002, 0 } )
aAdd( aStru, { "JB5_TPPAG2", "C", 001, 0 } )
aAdd( aStru, { "JB5_DESC2" , "N", 012, 2 } )
aAdd( aStru, { "JB5_PERC2" , "N", 006, 2 } )
aAdd( aStru, { "JB5_PAGTO3", "C", 002, 0 } )
aAdd( aStru, { "JB5_TPPAG3", "C", 001, 0 } )
aAdd( aStru, { "JB5_DESC3" , "N", 012, 2 } )
aAdd( aStru, { "JB5_PERC3" , "N", 006, 2 } )

aAdd( aFiles, { 'Cursos vigentes x Financeiro', '\Import\AC12600.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JB5_CODCUR )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณprepara as consistencias a serem feitas no arquivo temporarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd( aObrig, { '!Empty(JB5_CODCUR) ', 'C๓digo do curso vigente nใo informado.' } )
	aAdd( aObrig, { '!Empty(JB5_PERLET) ', 'Perํodo letivo nใo informado.' } )
	aAdd( aObrig, { '!Empty(JB5_PARCEL) ', 'Parcela nใo informada.' } )
	aAdd( aObrig, { '!Empty(JB5_CODFIN) ', 'Calendแrio financeiro nใo informado.' } )
	aAdd( aObrig, { '!Empty(JB5_VALOR)  ', 'Valor nใo informado.' } )
	aAdd( aObrig, { 'JB5_MATPAG$"12"    ', '"Matrํcula vinculada ao pagamento?" deve ser 1 (Sim) ou 2 (Nใo).' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO1) .or. JB5_PAGTO1 == StrZero( Val( JB5_PAGTO1), 2 )', 'Dia para Pagamento 1, quando informado, deve ser preenchido com zeros เ esquerda.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO1) .or. Val( JB5_PAGTO1 ) <= 31', 'Dia para Pagamento 1 superior a 31.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO1) .or. JB5_TPPAG1$"123"', 'Tipo de dias 1 deve ser informado sempre que Dia para Pagamento 1 for informado. Seu valor deve ser 1 (Corridos), 2 (ฺteis) ou 3 (Antecipados).' } )
	aAdd( aObrig, { '!Empty(JB5_PAGTO1) .or. Empty(JB5_TPPAG1)', 'Tipo de dias 1 informado e Dia para Pagamento 1 em branco. Devem ser informados ou deixados em branco conjuntamente.' } )
	aAdd( aObrig, { 'JB5_PERC1 <= 100"', 'Percentual de desconto 1 maior que 100%.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO2) .or. JB5_PAGTO2 == StrZero( Val( JB5_PAGTO2), 2 )', 'Dia para Pagamento 2, quando informado, deve ser preenchido com zeros เ esquerda.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO2) .or. Val( JB5_PAGTO2 ) <= 31', 'Dia para Pagamento 2 superior a 31.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO2) .or. JB5_TPPAG2$"123"', 'Tipo de dias 2 deve ser informado sempre que Dia para Pagamento 2 for informado. Seu valor deve ser 1 (Corridos), 2 (ฺteis) ou 3 (Antecipados).' } )
	aAdd( aObrig, { '!Empty(JB5_PAGTO2) .or. Empty(JB5_TPPAG2)', 'Tipo de dias 2 informado e Dia para Pagamento 2 em branco. Devem ser informados ou deixados em branco conjuntamente.' } )
	aAdd( aObrig, { 'JB5_PERC2 <= 100"', 'Percentual de desconto 2 maior que 100%.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO3) .or. JB5_PAGTO3 == StrZero( Val( JB5_PAGTO3), 2 )', 'Dia para Pagamento 3, quando informado, deve ser preenchido com zeros เ esquerda.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO3) .or. Val( JB5_PAGTO3 ) <= 31', 'Dia para Pagamento 3 superior a 31.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO3) .or. JB5_TPPAG3$"123"', 'Tipo de dias 3 deve ser informado sempre que Dia para Pagamento 3 for informado. Seu valor deve ser 1 (Corridos), 2 (ฺteis) ou 3 (Antecipados).' } )
	aAdd( aObrig, { '!Empty(JB5_PAGTO3) .or. Empty(JB5_TPPAG3)', 'Tipo de dias 3 informado e Dia para Pagamento 3 em branco. Devem ser informados ou deixados em branco conjuntamente.' } )
	aAdd( aObrig, { 'JB5_PERC3 <= 100"', 'Percentual de desconto 3 maior que 100%.' } )
	aAdd( aObrig, { 'JB5_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JB5_CODCUR, "JAH_CODIGO" )', 'Curso vigente nใo cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JB5_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JB5_CODCUR+JB5_PERLET, "JAR_PERLET" )', 'Perํodo letivo nใo cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JB5_CODFIN == Posicione( "JCB", 2, xFilial("JCB")+JB5_CODFIN, "JCB_CODFIN" )', 'Calendแrio financeiro nใo cadastrado na tabela JCB.' } )
	aAdd( aObrig, { 'JB5_PARCEL == Posicione( "JCC", 4, xFilial("JCC")+JB5_CODFIN+JB5_PARCEL, "JCC_PARCEL" )', 'Parcela nใo existente no calendแrio financeiro informado.' } )
	aAdd( aObrig, { 'Posicione( "JCB", 2, xFilial("JCB")+JB5_CODFIN, "JCB_ANOLET" ) == Posicione( "JAR", 1, xFilial("JAR")+JB5_CODCUR+JB5_PERLET, "JAR_ANOLET" )', 'Ano letivo do calendแrio financeiro nใo coincide com o ano letivo do perํodo letivo informado.' } )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณordena o arquivo de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JB5_CODCUR+JB5_PERLET+JB5_PARCEL" ) } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณverifica chaves unicas e consistencias pre-definidasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JB5_CODCUR+JB5_PERLET+JB5_PARCEL", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_xAC126CF( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida็ใo do Arquivo' )
	
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
		Processa( { |lEnd| lOk := xAC12600Grv( @lEnd ) }, 'Grava็ใo em andamento' )
		
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
ฑฑบPrograma  ณxAC12600GrvบAutor  ณRafael Rodrigues   บ Data ณ  17/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados na base do AP6.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC12600                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC12600Grv( lEnd )
Local cFilJB5	:= xFilial("JB5")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JB5->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JB5", JB5->( !dbSeek( cFilJB5+TRB->JB5_CODCUR+TRB->JB5_PERLET+TRB->JB5_PARCEL ) ) )
	JB5->JB5_FILIAL	:= cFilJB5
	JB5->JB5_CODCUR	:= TRB->JB5_CODCUR
	JB5->JB5_PERLET	:= TRB->JB5_PERLET
	JB5->JB5_PARCEL	:= TRB->JB5_PARCEL
	JB5->JB5_CODFIN	:= TRB->JB5_CODFIN
	JB5->JB5_VALOR	:= TRB->JB5_VALOR
	JB5->JB5_MATPAG	:= TRB->JB5_MATPAG
	JB5->JB5_PAGTO1	:= TRB->JB5_PAGTO1
	JB5->JB5_TPPAG1	:= TRB->JB5_TPPAG1
	JB5->JB5_DESC1	:= TRB->JB5_DESC1
	JB5->JB5_PERC1	:= TRB->JB5_PERC1
	JB5->JB5_PAGTO2	:= TRB->JB5_PAGTO2
	JB5->JB5_TPPAG2	:= TRB->JB5_TPPAG2
	JB5->JB5_DESC2	:= TRB->JB5_DESC2
	JB5->JB5_PERC2	:= TRB->JB5_PERC2
	JB5->JB5_PAGTO3	:= TRB->JB5_PAGTO3
	JB5->JB5_TPPAG3	:= TRB->JB5_TPPAG3
	JB5->JB5_DESC3	:= TRB->JB5_DESC3
	JB5->JB5_PERC3	:= TRB->JB5_PERC3
	JB5->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC126CF  บAutor  ณRafael Rodrigues    บ Data ณ  17/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se existe o mesmo numero de pacelas no arquivo e no  บฑฑ
ฑฑบ          ณcalendario financeiro informado.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC12600                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC126CF( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local cChave	:= ""
Local nLinha	:= 0
Local lLog		:= cLog <> NIL

JCC->( dbSetOrder(4) )

TRB->( dbGoTop() )

ProcRegua( TRB->( RecCount() ) )
IncProc( 'Verificando as parcelas do curso '+Alltrim( TRB->JB5_CODCUR )+'...' )

while TRB->( !eof() ) .and. !lEnd .and. ( lLog .or. lRet )

	cChave	:= TRB->JB5_CODCUR+TRB->JB5_PERLET
	nLinha	:= TRB->( Recno() )

	JCC->( dbSeek( xFilial("JCC")+TRB->JB5_CODFIN ) )
	
	while JCC->( !eof() ) .and. JCC->JCC_FILIAL+JCC->JCC_CODFIN == xFilial("JCC")+TRB->JB5_CODFIN .and. !lEnd .and. ( lLog .or. lRet )
		if TRB->( !dbSeek( cChave+JCC->JCC_PARCEL ) )
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( nLinha, 6 )+': Parcela '+JCC->JCC_PARCEL+' do calendแrio financeiro '+Alltrim(TRB->JB5_CODFIN)+' nใo encontrada no arquivo de importa็ใo.', cLogFile )
			else
				exit
			endif
		endif
		JCC->( dbSkip() )
	end
	
	if !lRet .and. !lLog
		exit
	endif

	TRB->( dbGoTo( nLinha ) )
	while TRB->( !eof() ) .and. TRB->JB5_CODCUR+TRB->JB5_PERLET == cChave .and. !lEnd .and. ( lLog .or. lRet )
		IncProc( 'Verificando as parcelas do curso '+Alltrim( TRB->JB5_CODCUR )+'...' )
		TRB->( dbSkip() )
	end
end

lRet := lRet .and. !lEnd

Return lRet