#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEGetF    บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria uma janela para selecao de arquivos a importar e       บฑฑ
ฑฑบ          ณimporta os arquivos selecionados para seus respectivos      บฑฑ
ฑฑบ          ณarquivos de trabalho.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GEGetF( aFiles, lForceLog )
Local aRet		:= {}
Local cMarca	:= GetMark()
Local aCampos	:= {}
Local aStru		:= {}
Local cFiles	:= ''
Local lEnd		:= .F.
Local nOpcA		:= 0
Local i
Local oDlg, oMark

aFiles	:= IIf(Empty( aFiles ), {}, aFiles)

Default lForceLog	:= .F.

aAdd( aStru, { 'T_OK'   , 'C', 002, 0 } )
aAdd( aStru, { 'T_DESC' , 'C', 030, 0 } )
aAdd( aStru, { 'T_PATH' , 'C', 255, 0 } )
aAdd( aStru, { 'T_OBRIG', 'C', 001, 0 } )
aAdd( aStru, { 'T_ITEM' , 'N', 005, 0 } )

cFiles	:= CriaTrab( aStru, .T. )
dbUseArea( .T.,, cFiles, 'T_Files', .T. )

for i := 1 to len( aFiles )
	RecLock( "T_Files", .T. )
	T_Files->T_OK		:= if( File( aFiles[i][2] ) .or. aFiles[i][5], cMarca, '' )
	T_Files->T_DESC		:= aFiles[i][1]
	T_Files->T_PATH		:= aFiles[i][2]
	T_Files->T_OBRIG	:= if( aFiles[i][5], 'S', 'N' )
	T_Files->T_ITEM		:= i
	T_Files->( msUnlock() )
next i

T_Files->( dbGoTop() )

aAdd( aCampos, { 'T_OK'		,, ' '			, '' } )
aAdd( aCampos, { 'T_DESC'	,, 'Tํtulo'		, '@S30' } )
aAdd( aCampos, { 'T_PATH'	,, 'Arquivo'	, '@S30' } )

define msDialog oDlg title 'Importa็ใo de Arquivos' from 00,00 to 380,600 pixel

@ 015,001 say	'Arquivos a Importar' size 060,07 of oDlg pixel

oMark := MsSelect():New( "T_Files", "T_OK",, aCampos,, cMarca, { 025, 000, 175, 300 } ,,, )

oMark:oBrowse:Refresh()
oMark:bAval               := { || ( GEGetFMk( cMarca ), oMark:oBrowse:Refresh() ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .F.

@ 180, 001 CheckBox oForceLog  	var lForceLog prompt 'For็ar grava็ใo segura de log'	size 100,08 of oDlg pixel

activate msDialog oDlg center on init EnchoiceBar(oDlg, { || if( GEGetFOk( cMarca ), ( nOpcA := 1, oDlg:End() ), nOpcA:=0 ) }, { || oDlg:End() })

if nOpca == 1

	Processa( { |lEnd| aRet := GEGetFRun( @lEnd, aFiles, cMarca ) }, 'Pr้-importa็ใo em andamento...' )
	
	if lEnd	// Se for cancelado pelo operador...
		aRet := {}
	endif
	
endif

dbSelectArea("T_Files")
dbCloseArea()

FErase( cFiles + GetDBExtension() )

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxGetFRun  บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria a tabela temporaria e appenda o arquivo texto na mesma.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEGetF                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GEGetFRun( lEnd, aFiles, cMarca )
Local aRet		:= {}

T_Files->( dbGoTop() )
ProcRegua( RecCount() )

while !lEnd .and. T_Files->( !eof() )
	IncProc( 'Lendo "'+Alltrim(T_Files->T_DESC)+'"...' )

	if T_Files->T_OK <> cMarca
		T_Files->( dbSkip() )
		loop
	endif
	
	aAdd( aRet, { aFiles[T_Files->T_ITEM][4], '' } )
	
	aRet[len(aRet)][2]	:= CriaTrab( aFiles[T_Files->T_ITEM][3], .T. )

	dbUseArea( .T.,, aRet[len(aRet)][2], aRet[len(aRet)][1], .T. )
	dbSelectArea( aRet[len(aRet)][1] )

	append from &(T_Files->T_PATH) SDF

	T_Files->( dbSkip() )
end

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEGetFMk  บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona o item do MarkBrowse e permite alterar a          บฑฑ
ฑฑบ          ณlocalizacao do arquivo texto.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEGetF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GEGetFMk( cMarca )
Local cPath		:= T_Files->T_PATH
Local lImport	:= T_Files->T_OK <> cMarca .or. T_Files->T_OBRIG == 'S'
Local nOpcA		:= 0
Local oDlg, oImport, oPath, oBtBrw, oBtOk, oBtCan

define msDialog oDlg title Alltrim( T_Files->T_DESC ) from 00,00 to 060,500 pixel

define sButton oBtOk  from 003,218 type 1 action (nOpcA := 1, oDlg:End()) enable of oDlg pixel
define sButton oBtCan from 018,218 type 2 action (nOpcA := 0, oDlg:End()) enable of oDlg pixel

@ 005, 005 CheckBox oImport	var lImport prompt 'Importar este arquivo'	size 060,08 of oDlg pixel when ( T_Files->T_OBRIG <> 'S' )

define sButton oBtBrw from 018,004 type 4 action ( cPath := cGetFile(cPath), oPath:Refresh() ) enable of oDlg pixel

@ 020, 035 msGet	oPath	var cPath									size 175,08 of oDlg pixel

activate msdialog oDlg center

if nOpcA == 1
	RecLock( "T_Files", .F. )
	T_Files->T_PATH	:= cPath
	T_Files->T_OK	:= if( lImport, cMarca, '' )
	T_Files->( msUnlock() )
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEGetFOk  บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se os arquivos selecionados existem.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEGetF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GEGetFOk( cMarca )
Local lRet	:= .T.
Local nPos	:= T_Files->( Recno() )

T_Files->( dbGoTop() )

while lRet .and. T_Files->( !eof() )
	if T_Files->T_OK == cMarca .and. !File( T_Files->T_PATH )
		lRet := .F.
		Aviso( 'Arquivo Invแlido', 'Nใo foi possํvel encontrar o arquivo "'+Alltrim( T_Files->T_PATH )+'". ', {'Ok'} )
	endif
	T_Files->( dbSkip() )
end

T_Files->( dbGoTo( nPos ) )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEChkInt  บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica a integridade de uma tabela, checando se existe    บฑฑ
ฑฑบ          ณchave duplicada ou campos obrigatorios nao preenchidos.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GEChkInt( cAlias, cChave, lOrdena, aValids, cLog, lEnd, cLogFile )
Local lRet		:= .T.
Local i			:= 0
Local nVld      := 0
Local cBusca	:= ""
Local lLog		:= cLog <> NIL
Local cIDX		:= CriaTrab( NIL, .F. )

if lOrdena
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( cAlias, cIDX, cChave ) } )
endif

ProcRegua( ( cAlias )->( RecCount() ) )
( cAlias )->( dbGoTop() )

while ( cAlias )->( !eof() ) .and. !lEnd

	i++
	IncProc( "Verificando linha "+Alltrim(Str(i,14,0))+" de "+Alltrim( Str( ( cAlias )->( RecCount() ), 14, 0 ) )+"." )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealiza as validacoes pre-definidasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for nVld := 1 to len( aValids )
		if lEnd
			exit
		endif
		if ( cAlias )->( !Eval( &("{ || "+aValids[nVld, 1]+" }") ) )
			lRet := .F.
			if !lLog
				exit
			endif
			U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( ( cAlias )->( Recno() ), 6 )+': '+aValids[nVld, 2], cLogFile )
		endif
	next nVld

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe nao estiver gravando log e o arquivo ja foi rejeitado, retorna imediatamenteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if !lRet .and. !lLog
		exit
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica chaves duplicadasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cBusca	:= ( cAlias )->( &cChave )
	nReg	:= ( cAlias )->( Recno() )
	
	( cAlias )->( dbSkip() )
	
	if ( cAlias )->( &cChave ) == cBusca
		
		lRet := .F.
		
		// Se nao estiver gravando log, retorna, pois ja sabe que o retorno eh .F.
		if !lLog
			exit
		endif

		// Continua verificando duplicidades da mesma chave...
		while ( cAlias )->( !eof() ) .and. ( cAlias )->( &cChave ) == cBusca .and. !lEnd
			i++
			IncProc( "Verificando linha "+Alltrim(Str(i,14,0))+" de "+Alltrim( Str( ( cAlias )->( RecCount() ), 14, 0 ) )+"." )

			U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( ( cAlias )->( Recno() ), 6 )+': Chave duplicada, jแ existente na linha '+StrZero( nReg, 6 )+'.', cLogFile )
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRealiza as validacoes pre-definidasณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			for nVld := 1 to len( aValids )
				if lEnd
					exit
				endif
				if ( cAlias )->( !Eval( &("{ || "+aValids[nVld, 1]+" }") ) )
					lRet := .F.
					if !lLog
						exit
					endif
					U_xAddLog( cLog, '  Inconsist๊ncia na linha '+StrZero( ( cAlias )->( Recno() ), 6 )+': '+aValids[nVld, 2], cLogFile )
				endif
			next nVld
			
			( cAlias )->( dbSkip() )
		end
	endif
end

if lEnd
	lRet := .F.
    if lLog
		U_xAddLog( cLog, '! Opera็ใo cancelada pelo operador.', cLogFile )
    endif
endif

if lOrdena
	FErase( cIDX + OrdBagExt() )
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEChkCGC  บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica a validade do CNPJ/CPF sem exibir mensagem de erro บฑฑ
ฑฑบ          ณcaso o CNPJ/CPF seja invalido.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GEChkCGC( cCGC )
Local nTam, nCnt, i, j, nSum, nDIG
Local cCPF := ""
Local cDVC := ""
Local cDIG := ""
Local lRet := .F.

nTam := Len( AllTrim( cCGC ) )

cDVC := SubStr( cCGC, 13, 02 )
cCGC := SubStr( cCGC, 01, 12 )

for j := 12 to 13
	nCnt := 1
	nSum := 0
	for i := j to 1 Step -1
		nCnt++
		if nCnt > 9
			nCnt := 2
		endif
		nSum += ( val( substr( cCGC,i,1) ) * nCnt )
	next i
	nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
	cCGC := cCGC + STR( nDIG, 1 )
	cDIG := cDIG + STR( nDIG, 1 )
next j

lRet := cDIG == cDVC

if !lRet
	if nTam < 14
		cDVC := SubStr( cCGC, 10, 2 )
		cCPF := SubStr( cCGC, 01, 9 )
		cDIG := ""

		for j := 10 to 11
			nCnt := j
			nSum := 0
			for i:= 1 to len( trim( cCPF ) )
				nSum += ( Val( SubStr( cCPF, i, 1 ) ) * nCnt )
				nCnt--
			next i
			nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
			cCPF := cCPF + STR( nDIG, 1 )
			cDIG := cDIG + STR( nDIG, 1 )
		next j

		lRet := cDIG == cDVC
	endif
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEIsHora  บAutor  ณRafael Rodrigues    บ Data ณ  17/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o horario passado como parametro eh valido.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GEIsHora( cHorario, lEmpty )
Local lRet	:= .T.
Local cHora	:= Subs( cHorario, 1, 2 )
Local cMin	:= Subs( cHorario, 4, 2 )
Default lEmpty := .F.

lRet := lRet .and. Subs( cHorario, 3, 1 ) == ':'
lRet := lRet .and. ( cHora == StrZero( Val( cHora ), 2 ) .or. if( lEmpty, cHora == Space(2), .F. ) )
lRet := lRet .and. ( cMin == StrZero( Val( cMin ), 2 ) .or. if( lEmpty, cMin == Space(2), .F. ) )
lRet := lRet .and. Val( cHora ) <= 23
lRet := lRet .and. Val( cMin ) <= 59

Return lRet