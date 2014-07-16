#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13100  ºAutor  ³Rafael Rodrigues    º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Alunos                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC13100()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13100.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local cIDX04	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local lDBF03	:= .F.
Local lDBF04	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JA2_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JA2_CODINS", "C", 010, 0 } )
aAdd( aStru, { "JA2_PROSEL", "C", 006, 0 } )
aAdd( aStru, { "JA2_NOME"  , "C", 060, 0 } )
aAdd( aStru, { "JA2_CEP"   , "C", 008, 0 } )
aAdd( aStru, { "JA2_END"   , "C", 060, 0 } )
aAdd( aStru, { "JA2_NUMEND", "C", 005, 0 } )
aAdd( aStru, { "JA2_COMPLE", "C", 020, 0 } )
aAdd( aStru, { "JA2_BAIRRO", "C", 060, 0 } )
aAdd( aStru, { "JA2_CIDADE", "C", 030, 0 } )
aAdd( aStru, { "JA2_EST"   , "C", 002, 0 } )
aAdd( aStru, { "JA2_FRESID", "C", 015, 0 } )
aAdd( aStru, { "JA2_FCELUL", "C", 015, 0 } )
aAdd( aStru, { "JA2_FCONTA", "C", 015, 0 } )
aAdd( aStru, { "JA2_NOMCON", "C", 030, 0 } )
aAdd( aStru, { "JA2_EMAIL" , "C", 100, 0 } )
aAdd( aStru, { "JA2_DTNASC", "D", 008, 0 } )
aAdd( aStru, { "JA2_NATURA", "C", 002, 0 } )
aAdd( aStru, { "JA2_NACION", "C", 002, 0 } )
aAdd( aStru, { "JA2_ECIVIL", "C", 001, 0 } )
aAdd( aStru, { "JA2_PAI"   , "C", 110, 0 } )
aAdd( aStru, { "JA2_MAE"   , "C", 110, 0 } )
aAdd( aStru, { "JA2_SEXO"  , "C", 001, 0 } )
aAdd( aStru, { "JA2_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JA2_CPF"   , "C", 014, 0 } )
aAdd( aStru, { "JA2_TIPCPF", "C", 001, 0 } )
aAdd( aStru, { "JA2_RG"    , "C", 010, 0 } )
aAdd( aStru, { "JA2_DTRG"  , "D", 008, 0 } )
aAdd( aStru, { "JA2_ESTRG" , "C", 002, 0 } )
aAdd( aStru, { "JA2_TITULO", "C", 015, 0 } )
aAdd( aStru, { "JA2_CIDTIT", "C", 020, 0 } )
aAdd( aStru, { "JA2_ESTTIT", "C", 002, 0 } )
aAdd( aStru, { "JA2_ZONA"  , "C", 010, 0 } )
aAdd( aStru, { "JA2_CMILIT", "C", 014, 0 } )
aAdd( aStru, { "JA2_ENDCOB", "C", 060, 0 } )
aAdd( aStru, { "JA2_NUMCOB", "C", 005, 0 } )
aAdd( aStru, { "JA2_BAICOB", "C", 060, 0 } )
aAdd( aStru, { "JA2_COMCOB", "C", 020, 0 } )
aAdd( aStru, { "JA2_ESTCOB", "C", 002, 0 } )
aAdd( aStru, { "JA2_CIDCOB", "C", 030, 0 } )
aAdd( aStru, { "JA2_CEPCOB", "C", 008, 0 } )
aAdd( aStru, { "JA2_STATUS", "C", 001, 0 } )
aAdd( aStru, { "JA2_CLIENT", "C", 006, 0 } )
aAdd( aStru, { "JA2_LOJA"  , "C", 002, 0 } )
aAdd( aStru, { "JA2_PROCES", "C", 006, 0 } )
aAdd( aStru, { "JA2_INSTIT", "C", 006, 0 } )
aAdd( aStru, { "JA2_DATAPR", "D", 008, 0 } )
aAdd( aStru, { "JA2_CLASSF", "C", 006, 0 } )
aAdd( aStru, { "JA2_PONTUA", "N", 008, 2 } )
aAdd( aStru, { "JA2_FORING", "C", 001, 0 } )
aAdd( aStru, { "JA2_DATADI", "D", 008, 0 } )
aAdd( aStru, { "JA2_WPSS"  , "C", 032, 0 } )
aAdd( aStru, { "JA2_PROFIS", "C", 040, 0 } )
aAdd( aStru, { "JA2_CEPPRF", "C", 008, 0 } )
aAdd( aStru, { "JA2_ENDPRF", "C", 060, 0 } )
aAdd( aStru, { "JA2_CIDPRF", "C", 030, 0 } )
aAdd( aStru, { "JA2_ESTPRF", "C", 002, 0 } )
aAdd( aStru, { "JA2_BAIPRF", "C", 060, 0 } )
aAdd( aStru, { "JA2_FCOML" , "C", 015, 0 } )
aAdd( aStru, { "JA2_RAMAL" , "C", 005, 0 } )
aAdd( aStru, { "JA2_ENTIDA", "C", 006, 0 } )
aAdd( aStru, { "JA2_CONCLU", "C", 004, 0 } )
aAdd( aStru, { "JA2_ACAOJU", "C", 001, 0 } )
aAdd( aStru, { "JA2_VERCAR", "C", 003, 0 } )
aAdd( aStru, { "JA2_PRONTU", "C", 015, 0 } )
aAdd( aStru, { "JA2_PASTA" , "C", 015, 0 } )
aAdd( aStru, { "JA2_ARQMOR", "C", 015, 0 } )
aAdd( aStru, { "JA2_DIARIO", "C", 015, 0 } )
aAdd( aStru, { "JA2_PUBLIC", "C", 015, 0 } )
aAdd( aStru, { "JA2_DATAPU", "D", 008, 0 } )

aAdd( aFiles, { 'Cadastro de Alunos', '\Import\AC13101.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JA2_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JA2_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JA2_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Observações', '\Import\AC13102.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JA2_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JA2_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JA2_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Disciplinas do Processo Seletivo', '\Import\AC13103.TXT', aClone( aStru ), 'TRB03', .F. } )

aStru := {}

aAdd( aStru, { "JC1_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JC1_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JC1_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JC1_NOME"  , "C", 030, 0 } )
aAdd( aStru, { "JC1_EMAIL" , "C", 040, 0 } )
aAdd( aStru, { "JC1_PERC"  , "N", 006, 2 } )
aAdd( aStru, { "JC1_RG"    , "C", 010, 0 } )
aAdd( aStru, { "JC1_CPF"   , "C", 014, 0 } )

aAdd( aFiles, { 'Responsáveis pelos Alunos', '\Import\AC13104.TXT', aClone( aStru ), 'TRB04', .F. } )

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
	lDBF04	:= aScan( aTables, {|x| x[1] == "TRB04"} ) > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JA2_NUMRA )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JA2_NUMRA )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif

	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JA2_NUMRA )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	if lDBF04
		TRB04->( dbGoBottom() )
		if Empty( TRB04->JC1_NUMRA )
			RecLock( "TRB04", .F. )
			TRB04->( dbDelete() )
			TRB04->( msUnlock() )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JA2_NUMRA" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JA2_NUMRA+JA2_SEQ" ), NIL ),;
											if( lDBF03, IndRegua( "TRB03", cIDX03, "JA2_NUMRA+JA2_SEQ" ), NIL ),;
											if( lDBF04, IndRegua( "TRB04", cIDX04, "JC1_NUMRA+JC1_ITEM" ), NIL ) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JA2_NUMRA) '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_NOME)  '	, 'Nome não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_CEP)   '	, 'CEP não informado.' } )
		aAdd( aObrig, { 'Posicione("JC2",1,xFilial("JC2")+JA2_CEP,"JC2_CEP") == JA2_CEP'	, 'CEP inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_END)   '	, 'Endereço não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_NUMEND)'	, 'Número do logradouro não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_BAIRRO)'	, 'Bairro não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_CIDADE)'	, 'Cidade não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_EST)   '	, 'Estado não informado.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_EST,"X5_CHAVE"),2) == JA2_EST'	, 'Estado inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_DTNASC)'	, 'Data de nascimento não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_NATURA)'	, 'Naturalidade não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_NACION)'	, 'Nacionalidade não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_PAI)   '	, 'Nome do pai não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_MAE)   '	, 'Nome da mãe não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_CPF)   '	, 'CPF não informado.' } )
		aAdd( aObrig, { 'U_xACChkCGC(JA2_CPF)'	, 'CPF inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_RG)    '	, 'RG não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_DTRG)  '	, 'Data de expedição do RG não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_ESTRG) '	, 'Estado de expedição do RG não informado.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_ESTRG,"X5_CHAVE"),2) == JA2_ESTRG'	, 'Estado de expedição do RG inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_ENDCOB)'	, 'Endereço de cobrança não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_NUMCOB)'	, 'Número do logradouro de cobrança não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_BAICOB)'	, 'Bairro do endereço de cobrança não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_ESTCOB)'	, 'Estado do endereço de cobrança não informado.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_ESTCOB,"X5_CHAVE"),2) == JA2_ESTCOB'	, 'Estado do endereço de cobrança inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_CIDCOB)'	, 'Cidade do endereço de cobrança não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_CEPCOB)'	, 'CEP do endereço de cobrança não informado.' } )
		aAdd( aObrig, { 'Posicione("JC2",1,xFilial("JC2")+JA2_CEPCOB,"JC2_CEP") == JA2_CEPCOB'	, 'CEP do endereço de cobrança inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_INSTIT)'	, 'Instituição anterior não informada.' } )
		aAdd( aObrig, { 'Posicione("JCL",1,xFilial("JCL")+JA2_INSTIT,"JCL_CODIGO") == JA2_INSTIT'	, 'Instituição anterior não cadastrada na tabela JCL.' } )
		aAdd( aObrig, { '!Empty(JA2_PROFIS)'	, 'Profissão não informada.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_NATURA,"X5_CHAVE"),2) == JA2_NATURA'	, 'Naturalidalidade inválida.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"34"+JA2_NACION,"X5_CHAVE"),2) == JA2_NACION'	, 'Nacionalidade inválida.' } )
		aAdd( aObrig, { 'Empty(JA2_CEPPRF) .or. Posicione("JC2",1,xFilial("JC2")+JA2_CEPPRF,"JC2_CEP") == JA2_CEPPRF'	, 'CEP do endereço comercial inválido.' } )
		aAdd( aObrig, { 'Posicione("JCL",1,xFilial("JCL")+JA2_ENTIDA,"JCL_CODIGO") == JA2_ENTIDA'	, 'Entidade anterior não cadastrada na tabela JCL.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_ESTPRF,"X5_CHAVE"),2) == JA2_ESTPRF'	, 'Estado do endereço comercial inválido.' } )
		aAdd( aObrig, { 'Empty(JA2_CONCLU) .or. Len(Alltrim(JA2_CONCLU)) == 4'	, 'Ano de conclusão deve ser informado com 4 dígitos.' } )
		aAdd( aObrig, { 'JA2_ECIVIL$"CDMQSV"'	, 'Estado Civil deve ser C=Casado, D=Divorciado, M=Marital, Q=Desquitado, S=Solteiro ou V=Viúvo.' } )
		aAdd( aObrig, { 'JA2_SEXO$"12"'			, 'Sexo deve ser 1 (Masculino) ou 2 (Feminino).' } )
		aAdd( aObrig, { 'JA2_TIPCPF$"12"'		, 'Tipo do CPF deve ser 1(Próprio) ou 2(Responsável).' } )
		aAdd( aObrig, { 'JA2_STATUS$"12"'		, 'Status deve ser 1 (Efetivo) ou 2 (Provisório).' } )
		aAdd( aObrig, { 'JA2_FORING$"12345"'	, 'Forma de ingresso deve ser 1 (Processo Seletivo), 2 (ENEM), 3 (Entrevista), 4 (Vestibular Externo) ou 5 (Sem Processo Adm.).' } )
		aAdd( aObrig, { 'JA2_ACAOJU$"12"'		, '"Tem ação judicial?" deve ser 1 (Sim) ou 2 (Não).' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB01", "JA2_NUMRA", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk  }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JA2_NUMRA) '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_SEQ)    '	, 'Sequencial de linha não informado.' } )
		aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JA2_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JA2_NUMRA, .F. ) ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB02", "JA2_NUMRA+JA2_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JA2_NUMRA) '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_SEQ)    '	, 'Sequencial de linha não informado.' } )
		aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JA2_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JA2_NUMRA, .F. ) ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB03", "JA2_NUMRA+JA2_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF04
		aObrig := {}
		aAdd( aObrig, { '!Empty(JC1_NUMRA)   '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_ITEM)    '	, 'Item não informado.' } )
		aAdd( aObrig, { 'JC1_ITEM <> StrZero(Val(JC1_ITEM),2) '	, 'Item deve ser informado com zeros à esquerda.' } )
		aAdd( aObrig, { '!Empty(JC1_NOME)    '	, 'Nome não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_PERC)    '	, 'Percentual de responsabilidade não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_RG)      '	, 'RG do responsável não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_CPF)     '	, 'CPF do responsável não informado.' } )
		aAdd( aObrig, { 'U_xACChkCGC(JC1_CPF)'	, 'CPF do responsável inválido.' } )
		aAdd( aObrig, { 'JC1_TIPO$"123"      '	, 'Tipo de responsável deve ser 1(Academico) 2(Financeiro)ou 3(Ambos).' } )
		aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JC1_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB04->JC1_NUMRA, .F. ) ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_xAddLog( cLog, '  .Iniciando validação do arquivo "'+aFiles[4,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB04", "JC1_NUMRA+JC1_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[4,1] )
		U_xAddLog( cLog, '  .Fim da validação do arquivo "'+aFiles[4,1]+'".', if( lForceLog, cLogFile, nil ) )
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
		nRecs += if( lDBF04, TRB04->( RecCount() ), 0 )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC13101Grv( @lEnd, aFiles[1,1] ) .and. xAC13102Grv( @lEnd, aFiles[2,1] ) .and. xAC13103Grv( @lEnd, aFiles[3,1] ) .and. xAC13104Grv( @lEnd, aFiles[4,1] ) }, 'Gravação em andamento' )
		
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
	FErase( cIDX04 + OrdBagExt() )
	
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
±±ºPrograma  ³xAC13101GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13101Grv( lEnd, cTitulo )
Local cFilJA2	:= xFilial("JA2")	// Criada para ganhar performance
Local cFilSA1	:= xFilial("SA1")	// Criada para ganhar performance
Local cCodCli	:= ""
Local cLojCli	:= ""
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JA2->( dbSetOrder(1) )
SA1->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )

	begin transaction

	if JA2->( !dbSeek( cFilJA2+TRB01->JA2_NUMRA ) ) .or. Empty( JA2->JA2_CLIENT )
		if Empty( TRB01->JA2_CLIENT )
			cCodCli  := GetSXENum("SA1","A1_COD")
			cLojCli := "01"
			ConfirmSX8()
		else
			cCodCli := TRB01->JA2_CLIENT
			cLojCli := if( !Empty(TRB01->JA2_LOJA), TRB01->JA2_LOJA, "01" )
		endif
	elseif !Empty( TRB01->JA2_CLIENT )
		cCodCli := TRB01->JA2_CLIENT
		cLojCli := if( !Empty(TRB01->JA2_LOJA), TRB01->JA2_LOJA, "01" )
	elseif !Empty( JA2->JA2_CLIENT )
		cCodCli := JA2->JA2_CLIENT
		cLojCli := if( !Empty(JA2->JA2_LOJA), JA2->JA2_LOJA, "01" )
	else
		cCodCli  := GetSXENum("SA1","A1_COD")
		cLojCli := "01"
		ConfirmSX8()
	endif
	
	RecLock( "JA2", JA2->( !dbSeek( cFilJA2+TRB01->JA2_NUMRA ) ) )
	JA2->JA2_FILIAL	:= cFilJA2
	JA2->JA2_NUMRA	:= TRB01->JA2_NUMRA
	JA2->JA2_CODINS	:= TRB01->JA2_CODINS
	JA2->JA2_PROSEL	:= TRB01->JA2_PROSEL
	JA2->JA2_NOME  	:= TRB01->JA2_NOME
	JA2->JA2_CEP   	:= TRB01->JA2_CEP
	JA2->JA2_END   	:= TRB01->JA2_END
	JA2->JA2_NUMEND	:= TRB01->JA2_NUMEND
	JA2->JA2_COMPLE	:= TRB01->JA2_COMPLE
	JA2->JA2_BAIRRO	:= TRB01->JA2_BAIRRO
	JA2->JA2_CIDADE	:= TRB01->JA2_CIDADE
	JA2->JA2_EST   	:= TRB01->JA2_EST
	JA2->JA2_FRESID	:= TRB01->JA2_FRESID
	JA2->JA2_FCELUL	:= TRB01->JA2_FCELUL
	JA2->JA2_FCONTA	:= TRB01->JA2_FCONTA
	JA2->JA2_NOMCON	:= TRB01->JA2_NOMCON
	JA2->JA2_EMAIL 	:= TRB01->JA2_EMAIL
	JA2->JA2_DTNASC	:= TRB01->JA2_DTNASC
	JA2->JA2_NATURA	:= TRB01->JA2_NATURA
	JA2->JA2_NACION	:= TRB01->JA2_NACION
	JA2->JA2_ECIVIL	:= TRB01->JA2_ECIVIL
	JA2->JA2_PAI   	:= TRB01->JA2_PAI
	JA2->JA2_MAE   	:= TRB01->JA2_MAE
	JA2->JA2_SEXO  	:= TRB01->JA2_SEXO
	JA2->JA2_DATA  	:= TRB01->JA2_DATA
	JA2->JA2_CPF   	:= TRB01->JA2_CPF
	JA2->JA2_TIPCPF	:= TRB01->JA2_TIPCPF
	JA2->JA2_RG    	:= TRB01->JA2_RG
	JA2->JA2_DTRG  	:= TRB01->JA2_DTRG
	JA2->JA2_ESTRG 	:= TRB01->JA2_ESTRG
	JA2->JA2_TITULO	:= TRB01->JA2_TITULO
	JA2->JA2_CIDTIT	:= TRB01->JA2_CIDTIT
	JA2->JA2_ESTTIT	:= TRB01->JA2_ESTTIT
	JA2->JA2_ZONA  	:= TRB01->JA2_ZONA
	JA2->JA2_CMILIT	:= TRB01->JA2_CMILIT
	JA2->JA2_ENDCOB	:= TRB01->JA2_ENDCOB
	JA2->JA2_NUMCOB	:= TRB01->JA2_NUMCOB
	JA2->JA2_BAICOB	:= TRB01->JA2_BAICOB
	JA2->JA2_COMCOB	:= TRB01->JA2_COMCOB
	JA2->JA2_ESTCOB	:= TRB01->JA2_ESTCOB
	JA2->JA2_CIDCOB	:= TRB01->JA2_CIDCOB
	JA2->JA2_CEPCOB	:= TRB01->JA2_CEPCOB
	JA2->JA2_STATUS	:= TRB01->JA2_STATUS
	JA2->JA2_CLIENT	:= cCodCli
	JA2->JA2_LOJA  	:= cLojCli
	JA2->JA2_PROCES	:= TRB01->JA2_PROCES
	JA2->JA2_INSTIT	:= TRB01->JA2_INSTIT
	JA2->JA2_DATAPR	:= TRB01->JA2_DATAPR
	JA2->JA2_CLASSF	:= TRB01->JA2_CLASSF
	JA2->JA2_PONTUA	:= TRB01->JA2_PONTUA
	JA2->JA2_FORING	:= TRB01->JA2_FORING
	JA2->JA2_DATADI	:= TRB01->JA2_DATADI
	JA2->JA2_WPSS  	:= Embaralha( if( Empty(TRB01->JA2_WPSS), dtos(TRB01->JA2_DTNASC), TRB01->JA2_WPSS ), 0 )
	JA2->JA2_PROFIS	:= TRB01->JA2_PROFIS
	JA2->JA2_CEPPRF	:= TRB01->JA2_CEPPRF
	JA2->JA2_ENDPRF	:= TRB01->JA2_ENDPRF
	JA2->JA2_CIDPRF	:= TRB01->JA2_CIDPRF
	JA2->JA2_ESTPRF	:= TRB01->JA2_ESTPRF
	JA2->JA2_BAIPRF	:= TRB01->JA2_BAIPRF
	JA2->JA2_FCOML 	:= TRB01->JA2_FCOML
	JA2->JA2_RAMAL 	:= TRB01->JA2_RAMAL
	JA2->JA2_ENTIDA	:= TRB01->JA2_ENTIDA
	JA2->JA2_CONCLU	:= TRB01->JA2_CONCLU
	JA2->JA2_ACAOJU	:= TRB01->JA2_ACAOJU
	JA2->JA2_VERCAR	:= TRB01->JA2_VERCAR
	JA2->JA2_PRONTU	:= TRB01->JA2_PRONTU
	JA2->JA2_PASTA 	:= TRB01->JA2_PASTA
	JA2->JA2_ARQMOR	:= TRB01->JA2_ARQMOR
	JA2->JA2_DIARIO	:= TRB01->JA2_DIARIO
	JA2->JA2_PUBLIC	:= TRB01->JA2_PUBLIC
	JA2->JA2_DATAPU	:= TRB01->JA2_DATAPU

	JA2->( msUnlock() )
	
	end transaction

	begin transaction

	RecLock( "SA1", SA1->( !dbSeek( cFilSA1+cCodCli+cLojCli ) ) )
	SA1->A1_FILIAL	:= cFilSA1
	SA1->A1_COD		:= cCodCli
	SA1->A1_LOJA	:= cLojCli
	SA1->A1_NOME	:= JA2->JA2_NOME
	SA1->A1_NREDUZ	:= JA2->JA2_NOME
	SA1->A1_PESSOA	:= "F"
	SA1->A1_TIPO	:= "F"
	SA1->A1_END		:= JA2->JA2_END
	SA1->A1_MUN		:= JA2->JA2_CIDADE
	SA1->A1_EST		:= JA2->JA2_EST
	SA1->A1_BAIRRO	:= JA2->JA2_BAIRRO
	SA1->A1_CEP		:= JA2->JA2_CEP
	SA1->A1_TEL		:= JA2->JA2_FRESID
	SA1->A1_ENDCOB	:= JA2->JA2_ENDCOB
	SA1->A1_CGC		:= JA2->JA2_CPF
	SA1->A1_EMAIL	:= JA2->JA2_EMAIL
	SA1->A1_RG		:= JA2->JA2_RG
	SA1->A1_DTNASC	:= JA2->JA2_DTNASC
	SA1->A1_BAIRROC	:= JA2->JA2_BAICOB
	SA1->A1_CEPC	:= JA2->JA2_CEPCOB
	SA1->A1_MUNC	:= JA2->JA2_CIDCOB
	SA1->A1_ESTC	:= JA2->JA2_ESTCOB
	SA1->A1_NATUREZ	:= &(GetMv("MV_ACNATMT"))
	SA1->A1_NUMRA	:= JA2->JA2_NUMRA

	end transaction
	
	
	TRB01->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13102GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Observacoes na base.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13102Grv( lEnd, cTitulo )
Local cFilJA2		:= xFilial("JA2")	// Criada para ganhar performance
Local i				:= 0
Local cNumRA
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JA2->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo		:= ""
	cNumRA		:= TRB02->JA2_NUMRA
	
	while cNumRA == TRB02->JA2_NUMRA .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JA2_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JA2->( dbSeek( cFilJA2+cNumRA ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JA2_OBSERV³
		//³e armazena o codigo do memo no campo JA2_MEMO1. Sobrescreve caso JA2_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JA2", .F. )
		MSMM( JA2->JA2_MEMO1, TamSX3("JA2_OBSERV")[1],, cMemo, 1,,, "JA2", "JA2_MEMO1" )
		JA2->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13103GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Disciplinas na base.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13103Grv( lEnd, cTitulo )
Local cFilJA2	:= xFilial("JA2")	// Criada para ganhar performance
Local i			:= 0
Local cNumRA
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JA2->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cNumRA	:= TRB03->JA2_NUMRA
	
	while cNumRA == TRB03->JA2_NUMRA .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JA2_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JA2->( dbSeek( cFilJA2+cNumRA ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JA2_DISPRO³
		//³e armazena o codigo do memo no campo JA2_MEMO2. Sobrescreve caso JA2_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JA2", .F. )
		MSMM( JA2->JA2_MEMO2, TamSX3("JA2_DISPRO")[1],, cMemo, 1,,, "JA2", "JA2_MEMO2" )
		JA2->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13104GrvºAutor  ³Rafael Rodrigues   º Data ³  26/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos responsaveis pelo aluno.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13104Grv( lEnd, cTitulo )
Local cFilJC1	:= xFilial("JC1")	// Criada para ganhar performance
Local i			:= 0

if Select( "TRB04" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB04->( dbGoTop() )

JC1->( dbSetOrder(1) )

while TRB04->( !eof() ) .and. !lEnd

	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB04->( RecCount() ), 6 )+'...' )

	begin transaction
	
	RecLock( "JC1", JC1->( !dbSeek( cFilJC1+TRB04->JC1_NUMRA+TRB04->JC1_ITEM ) ) )

	JC1->JC1_FILIAL	:= cFilJC1
	JC1->JC1_NUMRA	:= TRB04->JC1_NUMRA
	JC1->JC1_ITEM	:= TRB04->JC1_ITEM
	JC1->JC1_TIPO	:= TRB04->JC1_TIPO
	JC1->JC1_NOME	:= TRB04->JC1_NOME
	JC1->JC1_EMAIL	:= TRB04->JC1_EMAIL
	JC1->JC1_PERC	:= TRB04->JC1_PERC
	JC1->JC1_RG		:= TRB04->JC1_RG
	JC1->JC1_CPF	:= TRB04->JC1_CPF

	JC1->( msUnlock() )

	end transaction

	TRB04->( dbSkip() )
end

Return !lEnd