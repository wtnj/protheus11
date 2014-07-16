#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFixWindow บAutor  ณRafael Rodrigues    บ Data ณ 09/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta janela para confirmacao da execucao dos diversos      บฑฑ
ฑฑบ          ณFix.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FixWindow( nBOPS, bRun, cPerg )
Local cMsg		:= ""
Local lPerg		:= .T.
Local aSays		:= {}
Local aButtons	:= {}
Local nOpc		:= 0

cPerg := if( cPerg # nil, cPerg, "" )

Private oMainWnd

if !OpenSm0()
	Return
endif

aAdd(aSays, "Este programa tem como objetivo ajustar a base de dados afetada pela nใo-conformidade" )
aAdd(aSays, "registrada no BOPS nบ "+Alltrim(Str(nBOPS))+".")
aAdd(aSays, " ")
aAdd(aSays, "O processamento da corre็ao pode levar alguns minutos.")

if !Empty(cPerg)
	lPerg := .F.
	aAdd(aButtons, { 5, .T., { || lPerg := Pergunte(cPerg,.T.) }})
endif
aAdd(aButtons, { 1, .T., { || nOpc := if( lPerg .or. Pergunte(cPerg,.T.), 1, 2 ), if( nOpc == 1, FechaBatch(), nil ) }})
aAdd(aButtons, { 2, .T., { || FechaBatch() }})

FormBatch("Ajuste de base de dados", aSays, aButtons)

if nOpc == 1
	Processa( {|| RunFix( nBOPS, bRun ) }, "Ajuste de base de dados" )
endif

Return

//
// RunFIX
//
Static Function RunFix( nBOPS, bRun )
Local aEmpOk	:= {}
Local cNomeArq	:= "FIX"+Alltrim(Str(nBOPS))
Local cExtArq	:= ".##R"
Local nRecSM0	:= 0

Private cLogFile

Set Dele On

// Faz o laco de repeticao para cada empresa do sistema
ProcRegua( SM0->( RecCount() ) )
SM0->( dbGotop() )

while SM0->( !eof() )
	IncProc( "Processando empresa "+SM0->M0_CODIGO+", filial "+SM0->M0_CODFIL )
	
	// Verifica se a empresa ja foi processada (em caso de tabelas compartilhadas)
	if SM0->( Deleted() ) .or. aScan( aEmpOk, SM0->M0_CODIGO ) > 0
		SM0->( dbSkip() )
		loop
	endif
	
	RPCSetType(3)
 	RPCSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
	lMsFinalAuto := .F.
	
	cLogFile	:= __RelDir + cNomeArq + cExtArq
	AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Iniciando processamento na empresa "+SM0->M0_CODIGO+", filial "+SM0->M0_CODFIL+"." )
	
	// Se a tabela JC7 for compartilhada, efetua somente uma vez por empresa
	// se estiver exclusiva, efetua o processo para cada filial
	SX2->( dbSetOrder(1) )
	if SX2->( dbSeek("JC7") .and. Upper(X2_MODO) == "C" )
		aAdd( aEmpOk, SM0->M0_CODIGO )
	endif
	
	// Executa a corre็ใo para a empresa/filial
	Eval( bRun )
	
	AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Fim do processamento na empresa "+SM0->M0_CODIGO+", filial "+SM0->M0_CODFIL+"." )
   
	nRecSM0 := SM0->( Recno() )
	RPCClearEnv()

	if Select("SM0") == 0
		OpenSm0()
		SM0->( dbGoTo(nRecSM0) )
	endif
	
	SM0->( dbSkip() )
end

AcaLog( cLogFile, Dtoc( date() )+" "+Time()+" - Processamento concluํdo." )
AcaLog( cLogFile, "" )

MsgAlert( "Programa de corre็ao finalizado!"+Chr(13)+Chr(10)+"Consulte o arquivo '"+cLogFile+"' para maiores detalhes." )

Return

//
// OpenSM0
//
Static Function OpenSM0()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .T. )
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas!", { "Ok" }, 2 )
EndIf                                 

Return lOpen    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix90953  บAutor  ณMicrosiga           บ Data ณ 17/Jan/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados afetada pela gravacao incorrega da  บฑฑ
ฑฑบ          ณmedia final do aluno.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix90953()
FixWindow( 90953, {|| F90953Go() } )
Return

Static Function F90953Go()
Local cQuery	:= ""
Local cCodCur, cPerLet, cHabili, cTurma, cDiscip
Local i, nSeq	:= 0
Local aLote		:= {}
Local aAlunos	:= {}
Local aTables	:= {}
Local aRunning	:= {}

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

// Prepara todas as tabelas do GE para iniciarem no environment das threads
SX2->( dbSetOrder(1) )
SX2->( dbSeek( "J" ) )
while SX2->( !eof() .and. Left( X2_CHAVE, 1 ) == "J" )

	// Garante que todas as tabelas estarใo abertas para assegurar que o xFilial retornara o valor certo.
	dbSelectArea( SX2->X2_CHAVE )
	
	aAdd( aTables, SX2->X2_CHAVE )
	SX2->( dbSkip() )
end
aAdd( aTables, "SA1" )
aAdd( aTables, "SE1" )
aAdd( aTables, "SE5" )
aAdd( aTables, "SEA" )
aAdd( aTables, "SED" )

// Monta a query para identificar os alunos afetados
cQuery := "select distinct JC7_NUMRA, JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, '2' JC7_OUTRAT "
cQuery += " from "
cQuery += RetSQLName("JC7")+" JC7, "
cQuery += RetSQLName("JBS")+" JBS, "
cQuery += RetSQLName("JBQ")+" JBQ "
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ = ' ' "
cQuery += "   and JBS_FILIAL = '"+xFilial("JBS")+"' and JBS.D_E_L_E_T_ = ' ' "
cQuery += "   and JBQ_FILIAL = '"+xFilial("JBQ")+"' and JBQ.D_E_L_E_T_ = ' ' "
cQuery += "   and JC7_NUMRA  = JBS_NUMRA  "
cQuery += "   and JC7_CODCUR = JBS_CODCUR "
cQuery += "   and JC7_PERLET = JBS_PERLET "
cQuery += "   and JC7_HABILI = JBS_HABILI "
cQuery += "   and JC7_TURMA  = JBS_TURMA  "
cQuery += "   and JC7_DISCIP = JBS_CODDIS "
cQuery += "   and JBS_CODCUR = JBQ_CODCUR "
cQuery += "   and JBS_PERLET = JBQ_PERLET "
cQuery += "   and JBS_HABILI = JBQ_HABILI "
cQuery += "   and JBS_CODAVA = JBQ_CODAVA "
cQuery += "   and JBQ_TIPO   = '2' "					// Somente quem possui apontamento de exame
cQuery += "   and JBS_COMPAR = '1' "					// Somente quem compareceu ao exame
cQuery += "   and JC7_MEDANT = JC7_MEDFIM "				// com media anterior igual a media final.
cQuery += "   and JC7_OUTCUR = '      ' "

cQuery += " union "

cQuery += "select distinct JC7_NUMRA, JC7_OUTCUR JC7_CODCUR, JC7_OUTPER JC7_PERLET, JC7_OUTHAB JC7_HABILI, JC7_OUTTUR JC7_TURMA, JC7_DISCIP, '1' JC7_OUTRAT "
cQuery += " from "
cQuery += RetSQLName("JC7")+" JC7, "
cQuery += RetSQLName("JBS")+" JBS, "
cQuery += RetSQLName("JBQ")+" JBQ "
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ = ' ' "
cQuery += "   and JBS_FILIAL = '"+xFilial("JBS")+"' and JBS.D_E_L_E_T_ = ' ' "
cQuery += "   and JBQ_FILIAL = '"+xFilial("JBQ")+"' and JBQ.D_E_L_E_T_ = ' ' "
cQuery += "   and JC7_NUMRA  = JBS_NUMRA  "
cQuery += "   and JC7_OUTCUR = JBS_CODCUR "
cQuery += "   and JC7_OUTPER = JBS_PERLET "
cQuery += "   and JC7_OUTHAB = JBS_HABILI "
cQuery += "   and JC7_OUTTUR = JBS_TURMA  "
cQuery += "   and JC7_DISCIP = JBS_CODDIS "
cQuery += "   and JBS_CODCUR = JBQ_CODCUR "
cQuery += "   and JBS_PERLET = JBQ_PERLET "
cQuery += "   and JBS_HABILI = JBQ_HABILI "
cQuery += "   and JBS_CODAVA = JBQ_CODAVA "
cQuery += "   and JBQ_TIPO   = '2' "					// Somente quem possui apontamento de exame
cQuery += "   and JBS_COMPAR = '1' "					// Somente quem compareceu ao exame
cQuery += "   and JC7_MEDANT = JC7_MEDFIM "				// com media anterior igual a media final.
cQuery += " order by JC7_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_NUMRA "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "FIX", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Disciplina      Aluno           Tipo" )

while FIX->( !eof() )
	cCodCur	:= FIX->JC7_CODCUR
	cPerLet  := FIX->JC7_PERLET
	cHabili	:= FIX->JC7_HABILI
	cTurma	:= FIX->JC7_TURMA
	cDiscip	:= FIX->JC7_DISCIP
	aAlunos	:= {}
	while FIX->( !eof() .and. JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP = cCodCur+cPerLet+cHabili+cTurma+cDiscip  )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+cCodCur+" "+cPerLet+" "+cHabili+" "+cTurma+" "+cDiscip+" "+FIX->JC7_NUMRA+" "+if( FIX->JC7_OUTRAT == "1", "Outra turma", "Regular" ) )
		aAdd( aAlunos, { FIX->JC7_NUMRA, FIX->JC7_OUTRAT } )
		FIX->( dbSkip() )
	end
	
	aAdd( aLote, { cCodCur, cPerLet, cHabili, cTurma, cDiscip, aAlunos } )
	
	// A cada 20 turmas, fecha o lote e inicia uma thread para processamento
	if Len( aLote ) == 20 .or. FIX->( eof() )
		// Inicia uma thread para calculo deste lote
		aAdd( aRunning, "FIX90953."+StrZero(++nSeq,3) )
		StartJob( "U_FX90953T", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, aTables, aLote, aRunning[Len(aRunning)] } )
		
		aLote := {}
		
		// Sempre que houver o limite de threads em execu็ใo, monitora at้ alguma finalizar
		// ou quando forem as ultimas threads do processamento, tambem aguarda todas finalizarem
		while ( Len( aRunning ) == 10 ) .or. ( FIX->( eof() ) .and. Len( aRunning ) > 0 )
			for i := 1 to len( aRunning )
				if i <= len( aRunning )
					if File( aRunning[i] )
						FErase( aRunning[i] )
						aRunning := aDel( aRunning, i )
						aRunning := aSize( aRunning, Len( aRunning ) - 1 )
					endif
				endif
			next i
			// Aguarda 1 segundo antes de verificar novamente
			sleep( 1000 )
		end
	endif
end

// Executa o recalculo do ultimo lote parcial, caso ainda tenha algo a processar
if Len( aLote ) > 0
	// Inicia uma thread para calculo deste lote
	aAdd( aRunning, "FIX90953."+StrZero(++nSeq,3) )
	StartJob( "U_F90953T", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, aTables, aLote, aRunning[Len(aRunning)] } )
	
	aLote := {}
	
	// Sempre que houver o limite de threads em execu็ใo, monitora at้ alguma finalizar
	// ou quando forem as ultimas threads do processamento, tambem aguarda todas finalizarem
	while Len( aRunning ) > 0
		for i := 1 to len( aRunning )
			if i <= len( aRunning )
				if File( aRunning[i] )
					FErase( aRunning[i] )
					aRunning := aDel( aRunning, i )
					aRunning := aSize( aRunning, Len( aRunning ) - 1 )
				endif
			endif
		next i
		// Aguarda 1 segundo antes de verificar novamente
		sleep( 1000 )
	end
endif

FIX->( dbCloseArea() )

Return

//
// Funcao de multi-processamento do FIX90953
//
User Function F90953T( aDados )
Local cCodEmp	:= aDados[1]
Local cCodFil	:= aDados[2]
Local aTables	:= aDados[3]
Local aLote		:= aDados[4]
Local cFile		:= aDados[5]
Local i
Local cCodCur
Local cPerLet
Local cHabili
Local cTurma
Local cDiscip
Local aAlunos

// Abre conexใo do ambiente
RPCSetType(3)
RPCSetEnv( cCodEmp, cCodFil,,,,, aTables )

// Garante que todas as tabelas estarao abertas para assegurar que o xFilial retornara o valor certo.
for i := 1 to len( aTables )
	dbSelectArea( aTables[i] )
next i

for i := 1 to len( aLote )
	cCodCur	:= aLote[i,1]
	cPerLet	:= aLote[i,2]
	cHabili	:= aLote[i,3]
	cTurma	:= aLote[i,4]
	cDiscip	:= aLote[i,5]
	aAlunos	:= aLote[i,6]

	AcaCalcMedia( cCodCur, cPerLet, cHabili, cTurma, cDiscip, aAlunos, "2", .T., 4, .F. )
next i

// Registra o fim do processamento para o robo monitorar
AcaLog( cFile, "Recแlculo do lote concluํdo!" )

// Finaliza conexใo
RPCClearEnv()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix91463  บAutor  ณAlberto Deviciente  บ Data ณ 31/Jan/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados afetada pela gravacao incorreta da  บฑฑ
ฑฑบ          ณGeracao de Pre-Matricula                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix91463()
FixWindow( 91463, {|| F91463Go() } )
Return    

Static Function F91463Go()
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

// Garante que a JBE esteja aberta
dbSelectArea("JBE")

// Monta a query para identificar os alunos afetados (Alunos que estao ATIVOS em dois periodos letivos para o mesmo curso)
cQuery := "select JBE_NUMRA, JBE_CODCUR "
cQuery += " from "
cQuery += RetSQLName("JBE")+" JBE "
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' ' "
cQuery += "   and JBE_ATIVO = '1' " //Somente Alunos que estao ativos
cQuery += " group by JBE_NUMRA, JBE_CODCUR "
cQuery += "having count(*) > 1 " //Somente alunos que estao ATIVOS em mais de um periodo Letivo para o mesmo curso

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Aluno          " )

while QRY1->( !eof() )
	JBE->( dbSetOrder(1) )
	JBE->( dbSeek( xFilial("JBE")+QRY1->JBE_NUMRA+QRY1->JBE_CODCUR ) )
 	while JBE->( !eof() ) .and. JBE->JBE_FILIAL+JBE->JBE_NUMRA+JBE->JBE_CODCUR == xFilial("JBE")+QRY1->JBE_NUMRA+QRY1->JBE_CODCUR 
		if !LastPer( JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET)
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )			
			RecLock( "JBE", .F. )
			JBE->JBE_ATIVO := '2' //Desativa o aluno do periodo letivo anterior     
			JBE->( MsUnlock() )
		endif
		JBE->( dbSkip() )
	enddo
	QRY1->( dbSkip() )
end
  
QRY1->( dbCloseArea() )

RestArea( aArea )

Return

//
// LastPer, usada pelo FIX91463
//
Static Function LastPer( cRA, cCodcur, cPerLet )
Local aArea := GetArea()
Local cQuery	:= ""
Local lRet //Retorna (.T.) se o aluno esta ATIVO em mais de um periodo letivo para o mesmo curso

cQuery := "select max(JBE_PERLET) PERLET "
cQuery += " from "
cQuery += RetSQLName("JBE")+" JBE "
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' ' "
cQuery += "   and JBE_ATIVO  = '1' " //Somente Alunos que estao ativos
cQuery += "   and JBE_NUMRA  = '"+cRA+"' " 
cQuery += "   and JBE_CODCUR = '"+cCodCur+"' " 

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )

lRet := cPerLet == QRY2->PERLET 

QRY2->( dbCloseArea() )

RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix93086  บAutor  ณRafael Rodrigues    บ Data ณ 09/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrecao do JBE_ATIVO dos alunos afetados pelo BOPS 93086   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix93086()
FixWindow( 93086, {|| F93086Go() } )
Return

Static Function F93086Go()
Local aArea		:= GetArea()
Local cQuery	:= ""
Local lMySQL	:= "MYSQL"$Upper(TCGetDB())
Local lMSSQL	:= "MSSQL"$Upper(TCGetDB())
Local lLog

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

dbSelectArea("JBE")

// Monta a query para identificar os alunos afetados (Alunos que estao ATIVOS em dois periodos letivos para o mesmo curso)
cQuery := "select JBE.R_E_C_N_O_ RECJBE, SE1.R_E_C_N_O_ RECSE1 "
cQuery += " from "
cQuery += RetSQLName("JBE")+" JBE, "
cQuery += RetSQLName("SE1")+" SE1 "
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' '"
cQuery += "   and E1_FILIAL  = '"+xFilial("SE1")+"' and SE1.D_E_L_E_T_ = ' '"
cQuery += "   and JBE_ATIVO  = '2'"
cQuery += "   and JBE_SITUAC = '1'"
cQuery += "   and E1_PREFIXO = 'MAT'"
cQuery += "   and E1_NUMRA   = JBE_NUMRA"
if lMySQL
	cQuery += "   and E1_NRDOC   = Concat( JBE_CODCUR, JBE_PERLET )"
elseif lMSSQL
	cQuery += "   and E1_NRDOC   = JBE_CODCUR+JBE_PERLET"
else
	cQuery += "   and E1_NRDOC   = JBE_CODCUR||JBE_PERLET"
endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "FIX", .F., .F. )

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"C.Vig  PL Habili Tur Aluno          " )

while FIX->( !eof() )
	JBE->( dbGoTo( FIX->RECJBE ) )
	if JBE->( !Eof() )
		lLog := .F.
		
		JBE->( dbSetOrder(3) )
		if JBE->( dbSeek( xFilial("JBE")+"2"+JBE->JBE_NUMRA+JBE->JBE_CODCUR+StrZero(Val(JBE->JBE_PERLET)-1,2) ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )
			lLog := .T.
			
			JBE->(RecLock("JBE", .F.))
			JBE->JBE_ATIVO := "1"  // Ativo
			JBE->(MsUnLock())
		Endif
		
		SE1->( dbGoTo( FIX->RECSE1 ) )
		if SE1->( !eof() )
			if SE1->E1_SALDO == 0
				if !lLog
					AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+JBE->JBE_CODCUR+" "+JBE->JBE_PERLET+" "+JBE->JBE_HABILI+" "+JBE->JBE_TURMA+" "+JBE->JBE_NUMRA )			
				endif
				FA070Aca()
			endif
		endif
	endif
	FIX->( dbSkip() )
end
  
FIX->( dbCloseArea() )

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFixDup    บAutor  ณRafael Rodrigues    บ Data ณ 08/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige duplicidades na base de dados                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FixDupl()
FixWindow( 0, {|| FDuplRun() } )
Return

Static Function FDuplRun()
Local cQuery	:= ""
Local i, j		:= 0
Local aAlias	:= {}
Local cChave, cKey

aAdd( aAlias, {"JAS", 2} )	//Indice 02: JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS
aAdd( aAlias, {"JAY", 1} )	//Indice 01: JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS

for i := 1 to len( aAlias )
	
	cChave := Posicione("SX2", 1, aAlias[i,1], "X2_UNICO")
	
	RecLock("SX2",.F.)
	SX2->X2_UNICO := ""
	msUnlock()

	TCSQLExec("DROP INDEX "+RetSQLName(aAlias[i,1])+"."+RetSQLName(aAlias[i,1])+"_UNQ")
	
	cKey := AllTrim(ParseKey(aAlias[i,1], cChave))
	
	cQuery := "select "+cKey+", Count( distinct R_E_C_N_O_ ) as QTD "
	cQuery += "  from "+RetSQLName(aAlias[i,1])
	cQuery += " where "+aAlias[i,1]+"_FILIAL = '"+xFilial(aAlias[i,1])+"' and D_E_L_E_T_ = ' '"
	cQuery += " group by "+cKey
	cQuery += " having Count( distinct R_E_C_N_O_ ) > 1"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "FIX", .F., .F. )
	
	if FIX->( !eof() )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Tabela "+aAlias[i,1]+" - Recnos eliminados:" )
	else
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Tabela "+aAlias[i,1]+" - Nenhuma duplicidade encontrada." )
	endif
	
	dbSelectArea( aAlias[i,1] )
	dbSetOrder( aAlias[i,2] )
	while FIX->( !eof() )
		for j := 1 to FIX->QTD - 1
			if dbSeek( &("FIX->("+cChave+")") )
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+StrZero( Recno(), 10 ) )
				RecLock( aAlias[i,1], .F. )
				dbDelete()
				msUnlock()
				dbSkip()
			endif
		next j
		FIX->( dbSkip() )
	end

	dbSelectArea( aAlias[i,1] )
	dbCloseArea()

	SX2->( dbSeek( aAlias[i,1] ) )
	RecLock("SX2",.F.)
	SX2->X2_UNICO := cChave
	msUnlock()
	
	X31UpdTable( aAlias[i,1] )
	
	FIX->( dbCloseArea() )
next i

Return

//
// ParseKey, usada pelo FixDupl
//
Static Function ParseKey(cAlias, cChave)
cChave := StrTran( cChave, "+", ", " )
cChave := StrTran( Upper(cChave), "DTOS(", "" )
cChave := StrTran( Upper(cChave), "STRZERO(", "" )
cChave := StrTran( Upper(cChave), "STR(", "" )
cChave := StrTran( Upper(cChave), ")", "" )

Return cChave         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix93048  บAutor  ณAlberto Deviciente  บ Data ณ 07/Mar/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados onde alunos estao matriculados      บฑฑ
ฑฑบ          ณ(JBE_SITUAC = 2), mas estao com status provisorio           บฑฑ
ฑฑบ          ณ(JA2_STATUS = 2)                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix93048()
FixWindow( 93048, {|| F93048Go() } )
Return    

Static Function F93048Go()
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando alunos" )

// Garante que a JA2 esteja aberta
dbSelectArea("JA2")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a query para identificar os alunos afetados.                                                    ณ
//ณ Alunos que estao "matriculados" (JBE_SITUAC = 2), mas estao com status "provisorio" (JA2_STATUS = 2)  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
cQuery := "select distinct JA2_NUMRA "
cQuery += " from "                 
cQuery += RetSQLName("JA2")+" JA2, "
cQuery += RetSQLName("JBE")+" JBE  "
cQuery += " where JA2_FILIAL = '"+xFilial("JA2")+"' and JA2.D_E_L_E_T_ = ' ' "
cQuery += "   and JBE_FILIAL = '"+xFilial("JBE")+"' and JBE.D_E_L_E_T_ = ' ' "
cQuery += "   and JA2_STATUS = '2' " //Somente alunos que estejam com status "Provisorio" 
cQuery += "   and JA2_NUMRA  = JBE_NUMRA "
cQuery += "   and JBE_SITUAC = '2' " //Somente alunos que estejam com status "Matriculado"
 
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY93048", .F., .F. )    

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"RA do Aluno" )

while QRY93048->( !eof() )
	JA2->( dbSetOrder(1) ) //ORDEM: JA2_FILIAL+JA2_NUMRA
	JA2->( dbSeek( xFilial("JA2")+QRY93048->JA2_NUMRA ) )  
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+QRY93048->JA2_NUMRA )			
		RecLock( "JA2", .F. )
		JA2->JA2_STATUS := '1' //Efetiva o aluno que estava como provisorio     
		JA2->( MsUnlock() )
	QRY93048->( dbSkip() )
end
  
QRY93048->( dbCloseArea() )

RestArea( aArea )

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix92225  บAutor  ณAlberto Deviciente  บ Data ณ 31/Mar/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrige a base de dados excluido os registros da tabela JB5 บฑฑ
ฑฑบ          ณque estao relacionados com os cursos da tabela JAH excluidosบฑฑ
ฑฑบ          ณ(registros que estao "orfaos" na tabela JB5) - BOPS 92225   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fix92225()
FixWindow( 92225, {|| F92225Go() } )
Return    

Static Function F92225Go()
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

// Garante que a JB5 esteja aberta
dbSelectArea("JB5")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a query para identificar os resgistros afetados.                                                                          ณ
//ณ Registros que estao excluidos na tabela JAH (CURSO VIGENTE), mas nao estao excluidos na tabela JB5 (CURSO VIGENTE X FINANCEIRO) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
cQuery := "SELECT DISTINCT JB5_CODCUR "
cQuery += "FROM "
cQuery += RetSQLName("JB5")+" JB5 "
cQuery += "WHERE JB5.D_E_L_E_T_ = ' ' "
cQuery += "AND JB5_CODCUR IN "
cQuery += "( SELECT JAH.JAH_CODIGO "
cQuery += "FROM " 
cQuery += RetSQLName("JAH")+" JAH "
cQuery += "WHERE JAH.D_E_L_E_T_ = '*')"
 
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY92225", .F., .F. )    

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Curso" )

while QRY92225->( !eof() )
	JB5->( dbSetOrder(1) ) //ORDEM: JB5_FILIAL+JB5_CODCUR+JB5_PERLET+JB5_HABILI+JB5_PARCEL
	JB5->( dbSeek( xFilial("JB5")+QRY92225->JB5_CODCUR ) )  
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+QRY92225->JB5_CODCUR )			
   	while JB5->JB5_FILIAL == xFilial( "JB5" ) .And.	JB5->JB5_CODCUR == QRY92225->JB5_CODCUR
		JB5->( RecLock("JB5",.F.) )
		JB5->( dbDelete() )
		JB5->( msUnlock() ) 
		JB5->( dbSkip() )
	end
	QRY92225->( dbSkip() )
end
  
QRY92225->( dbCloseArea() )

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106129   บAutor  ณEduardo de Souza    บ Data ณ 30/Ago/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a SE1 de alunos que tiveram transferencia de turma   บฑฑ
ฑฑบ          ณcujo campo esta diferente da chave                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106129()
FixWindow(106129, {|| F106129Go() } )
Return    

Static Function F106129Go()
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza os procedimentos propriamente ditoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aArea		:= GetArea()
Local cQuery	:= ""
Local lOracle	:= "ORACLE" $ TCGetDB()
Local cMV_1DUP	:= GetMV("MV_1DUP")
Local nParcela
Local aAlunos	:= {}
Local nInd		:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

DbSelectArea("SE1")
DbSelectArea("JBE")

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComo a aplica็ใo foi corrigida, o ano ้ fixo, 2006, paraณ
//ณacertar os alunos nestas condi็๕es (nใo poderแ          ณ
//ณocorrer mais situa็๕es desse tipo).                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cQuery := "SELECT SE1.R_E_C_N_O_ REG_SE1, JBE.R_E_C_N_O_ REG_JBE, JAR_DATA1 "
cQuery += "FROM " + RetSQLName("JBE") + " JBE, " + RetSQLName("SE1") + " SE1, " + RetSQLName("JAR") + " JAR "
cQuery += "WHERE JBE.D_E_L_E_T_ = ' ' "
cQuery += "AND SE1.D_E_L_E_T_ = ' ' "
cQuery += "AND JAR.D_E_L_E_T_ = ' ' "
cQuery += "AND E1_FILIAL = '"  + xFilial("SE1") + "' "
cQuery += "AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += "AND JAR_FILIAL = '" + xFilial("JAR") + "' "
cQuery += "AND JAR_CODCUR = JBE_CODCUR "
cQuery += "AND JAR_PERLET = JBE_PERLET "
cQuery += "AND JAR_HABILI = JBE_HABILI "
cQuery += "AND JBE_NUMRA = E1_NUMRA "
cQuery += "AND JBE_ATIVO = '1' "
cQuery += "AND JBE_ANOLET = '2006' "
cQuery += "AND JBE_PERIOD = '02' "
cQuery += "AND JBE_SITUAC = '2' "
cQuery += "AND E1_PREFIXO = 'MES' "
cQuery += "AND E1_VENCTO BETWEEN JAR_DATA1 AND JAR_DATA2 "
If lOracle
	cQuery += "AND JBE_CODCUR + JBE_PERLET <> SUBSTR(E1_NRDOC,1,8) "
	cQuery += "AND SUBSTR(E1_NRDOC,9,1) = ' ' "
Else
	cQuery += "AND JBE_CODCUR + JBE_PERLET <> SUBSTRING(E1_NRDOC,8) "
	cQuery += "AND SUBSTRING(E1_NRDOC,9,1) = ' ' "
Endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYSE1", .F., .F. )
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAltera o NRDOC dos registros da SE1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
While _QRYSE1->(!Eof())
	SE1->( DbGoto(_QRYSE1->REG_SE1))	
	JBE->( DbGoto(_QRYSE1->REG_JBE))		
	if Empty( SE1->E1_VALLIQ )
		if val(SE1->E1_PARCELA) == 0
			if cMV_1DUP == "1"
				nParcela := ASC(SE1->E1_PARCELA)-55
			Else
				nParcela := ASC(SE1->E1_PARCELA)-64
			EndIf
		Else
			nParcela := val(SE1->E1_PARCELA)
		EndIf
		SE1->(RecLock("SE1",.F.))
		SE1->(dbDelete())
		SE1->(MsUnLock())
		AcaLog(cLogFile, "SE1 EXCLUIDA - RECNO " + Alltrim(Str(SE1->(RECNO()))))		

		If nParcela > 0 .and. nParcela <= Len( JBE->JBE_BOLETO )
			JBE->(RecLock("JBE",.F.))
			JBE->JBE_BOLETO := Substr(JBE->JBE_BOLETO,1,nParcela-1)+" "+Substr(JBE->JBE_BOLETO,nParcela+1)
			JBE->(MsUnLock())
		EndIf
	Else
		SE1->(RecLock("SE1",.F.))
		SE1->E1_NRDOC := JBE->(JBE_CODCUR + JBE_PERLET)
		SE1->(MsUnLock())
		AcaLog(cLogFile, "SE1_NRDOC ATUALIZADO - RECNO " + Alltrim(Str(SE1->(RECNO()))))		
	EndIf
	If aScan( aAlunos, { |x| x[1] + x[2] + x[3] + x[4] + x[5] == JBE->(JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA) }) == 0
		aAdd( aAlunos, { JBE->JBE_NUMRA, JBE->JBE_CODCUR, JBE->JBE_PERLET , JBE->JBE_HABILI , JBE->JBE_TURMA, _QRYSE1->JAR_DATA1 } )
	Endif
	_QRYSE1->( dbSkip() )
End

_QRYSE1->( dbCloseArea() )

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a chamada para geracao de boletosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
For nInd := 1 To Len(aAlunos)
	dDataBase := StoD(aAlunos[nInd,6])
	AC680Bolet(,,aAlunos[nInd,1],aAlunos[nInd,1],aAlunos[nInd,2],aAlunos[nInd,2],,aAlunos[nInd,3],aAlunos[nInd,5],,,,,,,aAlunos[nInd,4])
Next nInd
RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106401   บAutor  ณEduardo de Souza    บ Data ณ 01/Set/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria uma senha temporaria para alunos que nao a possuem. Desบฑฑ
ฑฑบ          ณsa forma, podem entrar no site, solicitar a mesma e altera- บฑฑ
ฑฑบ          ณla posteriormente                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106401()
FixWindow(106401, {|| F106401Go() } )
Return    

Static Function F106401Go()
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza os procedimentos propriamente ditoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aArea		:= GetArea()
Local cQuery	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

DbSelectArea("JA2")

cQuery := "SELECT DISTINCT JA2.R_E_C_N_O_ REG FROM " + RetSQLName("JA2") + " JA2, " + RetSQLName("JBE") + " JBE "
cQuery += "WHERE JA2_FILIAL = '" + xFilial("JA2") + "' AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += "AND JA2.D_E_L_E_T_ = ' ' AND JBE.D_E_L_E_T_ = ' ' AND JA2_NUMRA = JBE_NUMRA "
cQuery += "AND JBE_ATIVO IN ('1','2') AND JA2_WPSS = '      ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYJA2", .F., .F. )

While _QRYJA2->(!Eof())
	JA2->(DBGOTO(_QRYJA2->REG))
	If RecLock("JA2",.F.)
		JA2->JA2_WPSS	:= StrZero(Int(Randomize(0, 10^TamSx3("JA2_WPSS")[1])),TamSx3("JA2_WPSS")[1])
		JA2->(MsUnlock())
		AcaLog(cLogFile, "JA2 SENHA ALTERADA : RECNO " + Alltrim(Str(JA2->(RECNO()))))
	Endif
	_QRYJA2->(dbSkip())
End

_QRYJA2->(dbCloseArea())

RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106873   บAutor  ณEduardo de Souza    บ Data ณ 05/Set/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui registros indevidos da JBE/JC7 de alunos trancados   บฑฑ
ฑฑบ          ณque tiveram a promocao - pre-matricula                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106873()
FixWindow(106873, {|| F106873Go() } )
Return    

Static Function F106873Go()
/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza os procedimentos propriamente ditoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cTexto	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

DbSelectArea("JBE")
DbSelectArea("JC7")
DbSelectArea("SE1")

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona alunos com requerimento de trancamento de matriculaณ
//ณque nao possuam requerimento de retorno posterior.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cQuery := "SELECT JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, COUNT(*), JBH_DTPART "
cQuery += " FROM " + RetSQLName("JBE") + " JBE, " + RetSQLName("JBH") + " JBH "
cQuery += " WHERE JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JBH.D_E_L_E_T_ = ' ' "
cQuery += " AND JBH_FILIAL = '" + xFilial("JBH") + "' "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += " AND JBH_CODIDE = JBE_NUMRA "
cQuery += " AND JBH_TIPO = '000019' "
cQuery += " AND JBE_ANOLET >= '2006' "
cQuery += " AND JBH_STATUS = '1' "
cQuery += " AND JBE_NUMRA NOT IN ( "
cQuery += " SELECT JBH_CODIDE FROM " + RetSQLName("JBH")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND JBH_FILIAL = '" + xFilial("JBH") + "' "
cQuery += " AND JBH_CODIDE = JBE.JBE_NUMRA "
cQuery += " AND JBH_TIPO = '000029' AND JBH_STATUS = '1' "
cQuery += " AND JBH_DTPART >= JBH.JBH_DTPART) "
cQuery += " GROUP BY JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBH_DTPART  "
cQuery += " HAVING COUNT(*) > 1 "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYJBE", .F., .F. )

JBE->(dbSetOrder(1)) //JBE_FILIAL+JBE_ATIVO+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA
JC7->(dbSetOrder(1)) //JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA
SE1->( dbOrderNickName("SE116") )	// Ordem: RA + Vencimento + Prefixo

While _QRYJBE->(!Eof())
	cTexto := ""
	
	If JBE->(dbSeek(xFilial("JBE")+_QRYJBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)))
		While JBE->(!Eof()) .And. JBE->(JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI) == xFilial("JBE")+_QRYJBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)
			If JBE->JBE_ATIVO == "4"
				JBE->(dbSkip())
				loop
			Endif				
		    
			Begin Transaction
			cTexto := "******* ALUNO " + JBE->JBE_NUMRA + Chr(13)+Chr(10)
			
	        JC7->(dbSeek(xFilial("JC7")+ JBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)))
	        While JC7->(!Eof()) .And. JC7->(JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI) == xFilial("JC7") + JBE->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI)
	        	If JC7->JC7_SITDIS == "004" .Or. (JC7->JC7_SITDIS <> "004" .And. !Empty(JC7->JC7_OUTCUR)) //Ignora trancados ou com outcur preenchida
	        		JC7->(dbSkip())
	        		loop
	        	Endif
	        	If RecLock("JC7", .F.)
	        		JC7->(dbDelete())
	        		JC7->(MsUnlock())
	        		cTexto += "JC7 EXCLUIDA " + Alltrim(Str(JC7->(RECNO()))) + Chr(13)+Chr(10)
	        	Endif
	        	JC7->(dbSkip())
	        End
	
			AcaVerJAR(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, 2)
			AcaVerJBO(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, JBE->JBE_TURMA, 2)
			ACM010Rec(JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_TURMA, JBE->JBE_HABILI, , , , )
			
			/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe achar titulos, caso estejam 'Em aberto', exclui; caso contrario,ณ
			//ณatualiza o E1_NRDOC.                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
			SE1->( dbSeek( xFilial("SE1") + JBE->JBE_NUMRA ) )
			While SE1->( !eof()) .and. SE1->(E1_FILIAL+E1_NUMRA) == xFilial("SE1")+JBE->JBE_NUMRA
				If Substr(SE1->E1_NRDOC,1,TamSX3("JBE_CODCUR")[1] + TamSX3("JBE_PERLET")[1]) == JBE->(JBE_CODCUR+JBE_PERLET)
					if Empty( SE1->E1_VALLIQ )
						SE1->(RecLock("SE1",.F.))
						SE1->(dbDelete())
						SE1->(MsUnLock())
		        		cTexto += "SE1 EXCLUIDA " + Alltrim(Str(SE1->(RECNO()))) + Chr(13)+Chr(10)						
					EndIf
				EndIf
				SE1->( dbSkip() )
			End
			If RecLock("JBE",.F.)
				JBE->(dbDelete())
				JBE->(MsUnlock())
	       		cTexto += "JBE EXCLUIDA " + Alltrim(Str(JBE->(RECNO()))) + Chr(13)+Chr(10)
			Endif				
			AcaLog(cLogFile, cTexto)
			End Transaction
			JBE->(dbSkip())
		End
	Endif
	_QRYJBE->(dbSkip())
End

_QRYJBE->(dbCloseArea())

RestArea( aArea )

DbSelectArea("JA2")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF105923   บAutor  ณViviane Miam        บ Data ณ 14/Set/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInsere registros na JCO (disciplinas dispensadas no deferi- บฑฑ
ฑฑบ			 ณmento de transfer๊ncia de externos)						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F105923()
FixWindow(105923, {|| F105923Go() } )
Return

Static Function F105923Go()
Local aJBE		:= {}
Local cQuery	:= ""
Local dDtMat	:= dDataBase
Local cNumra
Local cSerie
Local cHabili
Local cTurma
Local lSeq		:= JC7->(FieldPos("JC7_SEQ")) > 0 .and. JBE->(FieldPos("JBE_SEQ")) > 0
Local lJCTJust	:= If(Posicione("SX3",2,"JCT_JUSTIF","X3_CAMPO" )=="JCT_JUSTIF",.T.,.F.)
Local lJCOJust	:= If(Posicione("SX3",2,"JCO_JUSTIF","X3_CAMPO" )=="JCO_JUSTIF",.T.,.F.)
Local cSeq		:= ""
Local cMemoJCT	:= ""

AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Selecionando registros" )

dbSelectArea("JA2")
dbSelectArea("JBE")
dbSelectArea("JBH")
dbSelectArea("JBL")
dbSelectArea("JC7")
dbSelectArea("JCO")
dbSelectArea("JCR")
dbSelectArea("JCS")
dbSelectArea("JCT")

cQuery := "select distinct"
cQuery += "       jct.r_e_c_n_o_ RECJCT,"
cQuery += "       jcs.r_e_c_n_o_ RECJCS,"
cQuery += "       jct_numreq,"
cQuery += "       ja2_numra,"
cQuery += "       jcs_curso,"
cQuery += "       jct_perlet,"
cQuery += "       jcs_habili,"
cQuery += "       jcs_serie"
cQuery += "  from " + RetSQLName("JBH") + " JBH, "
cQuery +=             RetSQLName("JCS") + " JCS, "
cQuery +=             RetSQLName("JCT") + " JCT, "
cQuery +=             RetSQLName("JCR") + " JCR, "
cQuery +=             RetSQLName("JA2") + " JA2 "
cQuery += " where jbh_filial = '" + xFilial("JBH") + "' and jbh.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_filial = '" + xFilial("JCS") + "' and jcs.d_e_l_e_t_ = ' '"
cQuery += "   and jct_filial = '" + xFilial("JCT") + "' and jct.d_e_l_e_t_ = ' '"
cQuery += "   and jcr_filial = '" + xFilial("JCR") + "' and jcr.d_e_l_e_t_ = ' '"
cQuery += "   and ja2_filial = '" + xFilial("JA2") + "' and ja2.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_numreq = jbh_num"
cQuery += "   and jcr_rg     = jbh_codide"
cQuery += "   and jct_numreq = jcs_numreq"
cQuery += "   and ja2_rg     = jcr_rg"
cQuery += "   and jbh_tipo   = '000024'"
cQuery += "   and jbh_status = '1'"
cQuery += "   and jct_perlet < jcs_serie"
cQuery += "   and not exists ( select jbe_perlet"
cQuery += "                      from " + RetSQLName("JBE") + " JBE, "
cQuery +=                                 RetSQLName("JBO") + " JBO "
cQuery += "                     where jbe_filial = jct_filial and jbe.d_e_l_e_t_ = ' '"
cQuery += "                       and jbo_filial = jbe_filial and jbo.d_e_l_e_t_ = ' '"
cQuery += "                       and jbe_numra  = ja2_numra"
cQuery += "                       and jbe_codcur = jcs_curso"
cQuery += "                       and jbe_perlet = jct_perlet"
cQuery += "                       and jbe_habili = jct_habili"
cQuery += "                       and jbe_codcur = jbo_codcur"
cQuery += "                       and jbe_perlet = jbo_perlet"
cQuery += "                       and jbe_habili = jbo_habili"
cQuery += "                       and jbe_turma  = jbo_turma )"
cQuery += " union "
cQuery += "select distinct"
cQuery += "       jct.r_e_c_n_o_ RECJCT,"
cQuery += "       jcs.r_e_c_n_o_ RECJCS,"
cQuery += "       jct_numreq,"
cQuery += "       ja2_numra,"
cQuery += "       jcs_curso,"
cQuery += "       jct_perlet,"
cQuery += "       jcs_habili,"
cQuery += "       jcs_serie"
cQuery += "  from " + RetSQLName("JBH") + " JBH, "
cQuery +=             RetSQLName("JCS") + " JCS, "
cQuery +=             RetSQLName("JCT") + " JCT, "
cQuery +=             RetSQLName("JA2") + " JA2 "
cQuery += " where jbh_filial = '" + xFilial("JBH") + "' and jbh.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_filial = '" + xFilial("JCS") + "' and jcs.d_e_l_e_t_ = ' '"
cQuery += "   and jct_filial = '" + xFilial("JCT") + "' and jct.d_e_l_e_t_ = ' '"
cQuery += "   and ja2_filial = '" + xFilial("JA2") + "' and ja2.d_e_l_e_t_ = ' '"
cQuery += "   and jcs_numreq = jbh_num"
cQuery += "   and ja2_numra  = jbh_codide"
cQuery += "   and jct_numreq = jcs_numreq"
cQuery += "   and jbh_tipo   in ('000029', '000032', '000037')"
cQuery += "   and jbh_status = '1'"
cQuery += "   and jct_perlet < jcs_serie"
cQuery += "   and not exists ( select jbe_perlet"
cQuery += "                      from " + RetSQLName("JBE") + " JBE, "
cQuery +=                                 RetSQLName("JBO") + " JBO "
cQuery += "                     where jbe_filial = jct_filial and jbe.d_e_l_e_t_ = ' '"
cQuery += "                       and jbo_filial = jbe_filial and jbo.d_e_l_e_t_ = ' '"
cQuery += "                       and jbe_numra  = ja2_numra"
cQuery += "                       and jbe_codcur = jcs_curso"
cQuery += "                       and jbe_perlet = jct_perlet"
cQuery += "                       and jbe_habili = jct_habili"
cQuery += "                       and jbe_codcur = jbo_codcur"
cQuery += "                       and jbe_perlet = jbo_perlet"
cQuery += "                       and jbe_habili = jbo_habili"
cQuery += "                       and jbe_turma  = jbo_turma )"
cQuery += " order by jct_numreq, ja2_numra, jcs_curso, jct_perlet"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

JCS->( dbSetOrder(1) )
JCT->( dbSetOrder(1) )
JCO->( dbSetOrder(1) )
JBE->( dbSetOrder(1) )
JBL->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )

While QRY->(!Eof())

	JCT->( dbGoTo(QRY->RECJCT) )
	JCS->( dbGoTo(QRY->RECJCS) )
	
	if JBE->( !dbSeek( xFilial("JBE")+QRY->JA2_NUMRA+JCS->JCS_CURSO+JCS->JCS_SERIE ) )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Ignorando registro "+Alltrim(Str(QRY->RECJCT))+" da JCT pois nใo hแ JBE do perํodo letivo da transferencia como referencia." )
		QRY->( dbSkip() )
		Loop
	endif
	
	Begin Transaction

	if aScan( aJBE, QRY->JA2_NUMRA+JCS->JCS_CURSO+JCT->JCT_PERLET ) == 0
		aAdd( aJBE, QRY->JA2_NUMRA+JCS->JCS_CURSO+JCT->JCT_PERLET )
		
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Iniciando processamento do aluno "+QRY->JA2_NUMRA+", curso vigente "+JCS->JCS_CURSO+", periodo letivo "+JCT->JCT_PERLET+". Requerimento nบ "+JCT->JCT_NUMREQ )
		
		dDtMat	:= JBE->JBE_DTMATR
		cNumRA	:= QRY->JA2_NUMRA
		cSerie	:= JCT->JCT_PERLET
		cHabili := AcTrazHab(JCS->JCS_CURSO, cSerie, JCS->JCS_HABILI)
		cTurma	:= GetTurma(JCS->JCS_CURSO,cSerie,cHabili,JBE->JBE_TURMA)
		
		JAR->( dbSetOrder(1) )
		JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+cSerie+cHabili ) )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCria o aluno no JBEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if JBE->( dbSeek( xFilial("JBE")+QRY->JA2_NUMRA+JCS->JCS_CURSO+cSerie+cHabili ) )
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Turma incorreta '"+JBE->JBE_TURMA+"' ajustada para '"+cTurma+"'." )

			RecLock("JBE", .F.)
		else
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Gerado novo registro para o aluno na turma '"+cTurma+"'." )

			RecLock("JBE", .T.)
			JBE->JBE_FILIAL := xFilial("JBE")
			JBE->JBE_NUMRA  := cNumRA
			JBE->JBE_CODCUR := JCS->JCS_CURSO
			JBE->JBE_PERLET := cSerie
			JBE->JBE_HABILI := cHabili
			JBE->JBE_TIPO   := "1"  // Periodo Letivo Normal
			JBE->JBE_SITUAC := "2"  // 1=Pre-Matricula; 2=Matricula
			JBE->JBE_ATIVO  := "2"  // 1=Sim; 2=Nao
			JBE->JBE_TPTRAN := "002"	// Campo do script ref. ao Tipo de Transferencia
			JBE->JBE_KITMAT := "2"		// Pendente
			JBE->JBE_NUMREQ := JBH->JBH_NUM
			if lSeq
				JBE->JBE_SEQ    := ACSequence(cNumRA, JCS->JCS_CURSO, cSerie, cTurma, cHabili)
			endif
		endif
		
		JBE->JBE_TURMA  := cTurma
		JBE->JBE_DTMATR := dDtMat
		JBE->JBE_ANOLET := JAR->JAR_ANOLET
		JBE->JBE_PERIOD := JAR->JAR_PERIOD
		
		JBE->( MsUnLock() )
	else
		JBE->( dbSeek( xFilial("JBE")+QRY->JA2_NUMRA+JCS->JCS_CURSO+JCT->JCT_PERLET ) )
	endif

	if lSeq
		cSeq := ACSequence( cNumRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_TURMA, JBE->JBE_HABILI, .F. )
	endif
	
	if JBL->( dbSeek(xFilial("JBL")+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JCT->JCT_DISCIP) )
		While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS == xFilial("JBL")+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JCT->JCT_DISCIP )
			if JC7->( !dbSeek( xFilial("JC7")+JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JBL->( JBL_CODDIS+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL+JBL_DIASEM+JBL_HORA1 )+cSeq ) )
				RecLock("JC7", .T.)
				
				JC7->JC7_FILIAL := xFilial("JC7")
				JC7->JC7_NUMRA  := cNumRA
				JC7->JC7_CODCUR := JBE->JBE_CODCUR
				JC7->JC7_PERLET := JBE->JBE_PERLET
				JC7->JC7_HABILI := JBE->JBE_HABILI
				JC7->JC7_TURMA  := JBE->JBE_TURMA
				JC7->JC7_DISCIP := JCT->JCT_DISCIP
				JC7->JC7_SITDIS := JCT->JCT_SITUAC
				JC7->JC7_DIASEM := JBL->JBL_DIASEM
				JC7->JC7_CODHOR := JBL->JBL_CODHOR
				JC7->JC7_HORA1  := JBL->JBL_HORA1
				JC7->JC7_HORA2  := JBL->JBL_HORA2
				JC7->JC7_CODPRF := JBL->JBL_MATPRF
				JC7->JC7_CODPR2 := JBL->JBL_MATPR2
				JC7->JC7_CODPR3 := JBL->JBL_MATPR3
				JC7->JC7_CODPR4 := JBL->JBL_MATPR4
				JC7->JC7_CODPR5 := JBL->JBL_MATPR5
				JC7->JC7_CODPR6 := JBL->JBL_MATPR6
				JC7->JC7_CODPR7 := JBL->JBL_MATPR7
				JC7->JC7_CODPR8 := JBL->JBL_MATPR8
				JC7->JC7_CODLOC := JBL->JBL_CODLOC
				JC7->JC7_CODPRE := JBL->JBL_CODPRE
				JC7->JC7_ANDAR  := JBL->JBL_ANDAR
				JC7->JC7_CODSAL := JBL->JBL_CODSAL
				JC7->JC7_SITUAC := if(JCT->JCT_SITUAC $ "003/011", "8", If(JCT->JCT_SITUAC == "001","A","1"))   // 8 - Dispensado; 1 - Cursando; A - A cursar
				JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
				JC7->JC7_MEDCON := JCT->JCT_MEDCON
				JC7->JC7_CODINS := JCT->JCT_CODINS
				JC7->JC7_ANOINS := JCT->JCT_ANOINS
				if lSeq
					JC7->JC7_SEQ := cSeq
				endif
				JC7->( MsUnLock() )
			endif
			
			if JC7->JC7_SITUAC == "8"
				JCO->( dbSetOrder(1) )
				if JCO->( !dbSeek( xFilial("JCO")+JC7->( JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_DISCIP ) ) )
					RecLock("JCO", .T.)
					
					JCO->JCO_FILIAL := xFilial("JCO")
					JCO->JCO_NUMRA  := JC7->JC7_NUMRA
					JCO->JCO_CODCUR := JC7->JC7_CODCUR
					JCO->JCO_PERLET := JC7->JC7_PERLET
					JCO->JCO_HABILI := JC7->JC7_HABILI
					JCO->JCO_DISCIP := JC7->JC7_DISCIP
					JCO->JCO_MEDFIM := JC7->JC7_MEDFIM
					JCO->JCO_MEDCON := JC7->JC7_MEDCON
					JCO->JCO_CODINS := JC7->JC7_CODINS
					JCO->JCO_ANOINS := JC7->JC7_ANOINS
					
					if lJCOJust .and. lJCTJust
						cMemoJCT := JCT->( MSMM( JCT_MEMO1 ) )
						JCO->( MSMM(,TamSx3("JCO_JUSTIF")[1],,cMemoJCT,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
					endif
					
					JCO->( MsUnLock() )
				endif
			endif
			JBL->( dbSkip() )
		end
	elseif JCT->JCT_SITUAC $ "003/011"
		JCO->( dbSetOrder(1) )	// JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP
		if JCO->( !dbSeek( xFilial("JCO")+JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI )+JCT->JCT_DISCIP ) )
			RecLock("JCO", .T.)
			
			JCO->JCO_NUMRA  := cNumRA
			JCO->JCO_CODCUR := JBE->JBE_CODCUR
			JCO->JCO_PERLET := JBE->JBE_PERLET
			JCO->JCO_HABILI := JBE->JBE_HABILI
			JCO->JCO_DISCIP := JCT->JCT_DISCIP
			JCO->JCO_MEDFIM := JCT->JCT_MEDFIM
			JCO->JCO_MEDCON := JCT->JCT_MEDCON
			JCO->JCO_CODINS := JCT->JCT_CODINS
			JCO->JCO_ANOINS := JCT->JCT_ANOINS
			
			if lJCOJust .and. lJCTJust
				cMemoJCT := JCT->( MSMM( JCT_MEMO1 ) )
				JCO->( MSMM(,TamSx3("JCO_JUSTIF")[1],,cMemoJCT,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
			endif
			JCO->( MsUnLock() )
		endif
	endif

	End Transaction

	QRY->( dbSkip() )
end

QRY->(dbCloseArea())
dbSelectArea("JA2")

Return

Static Function GetTurma(cCodCur, cPerLet, cHabili, cTurPref)
Local cRet		:= ""
Local aAreaJBO	:= JBO->( GetArea() )

JBO->( dbSetOrder(1) )
if JBO->( dbSeek( xFilial("JBO")+cCodCur+cPerLet+cHabili+cTurPref ) ) .or. JBO->( dbSeek( xFilial("JBO")+cCodCur+cPerLet+cHabili ) )
	cRet := JBO->JBO_TURMA
endif

JBO->( RestArea(aAreaJBO) )

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF106545   บAutor  ณ Rafael Rodrigues   บ Data ณ 05/Out/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReorganiza os valores de JBE_SEQ e JC7_SEQ na base de dados บฑฑ
ฑฑบ			 ณque pode ter sido afetada pelos problemas na ACSequence     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F106545()
FixWindow(106545, {|| F106545Go() } )
Return

Static Function F106545Go()
Local cQuery	:= ""
Local cAtivo	:= ""

if JBE->( FieldPos("JBE_SEQ") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JBE_SEQ" )
	Return
elseif JC7->( FieldPos("JC7_SEQ") ) == 0
	AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"Empresa/filial nใo serแ processada pois nใo possui o campo JC7_SEQ" )
	Return
endif

//
// 1a Parte - Reorganiza os SEQ para 001 de quem tem apenas 1 ocorrencia
//
cQuery := "select JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA"
cQuery += "  from "+RetSQLName("JBE")
cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
cQuery += " group by JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA "
cQuery += "having count(*) = 1"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

JBE->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )

while QRY1->( !eof() )
	
	if JBE->( dbSeek( xFilial("JBE")+QRY1->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA ) ) )
		if JBE->JBE_SEQ <> "001"
			AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JBE->(Recno()),10)+" atualizado na JBE para o sequencial 001." )
			RecLock("JBE",.F.)
			JBE->JBE_SEQ := "001"
			JBE->( msUnlock() )
		endif
	
		cQuery := "select R_E_C_N_O_ REC"
		cQuery += "  from "+RetSQLName("JC7")
		cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
		cQuery += "   and JC7_NUMRA  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and JC7_CODCUR = '"+JBE->JBE_CODCUR+"'"
		cQuery += "   and JC7_PERLET = '"+JBE->JBE_PERLET+"'"
		cQuery += "   and JC7_HABILI = '"+JBE->JBE_HABILI+"'"
		cQuery += "   and JC7_TURMA  = '"+JBE->JBE_TURMA+"'"
		cQuery += "   and JC7_SEQ   <> '001'"
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	    
		while QRY2->( !eof() )
			JC7->( dbGoTo( QRY2->REC ) )

			cQuery := "select count(*) QUANT"
			cQuery += "  from "+RetSQLName("JC7")
			cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
			cQuery += "   and JC7_NUMRA  = '"+JC7->JC7_NUMRA+"'"
			cQuery += "   and JC7_CODCUR = '"+JC7->JC7_CODCUR+"'"
			cQuery += "   and JC7_PERLET = '"+JC7->JC7_PERLET+"'"
			cQuery += "   and JC7_HABILI = '"+JC7->JC7_HABILI+"'"
			cQuery += "   and JC7_TURMA  = '"+JC7->JC7_TURMA+"'"
			cQuery += "   and JC7_DISCIP = '"+JC7->JC7_DISCIP+"'"
			cQuery += "   and JC7_CODLOC = '"+JC7->JC7_CODLOC+"'"
			cQuery += "   and JC7_CODPRE = '"+JC7->JC7_CODPRE+"'"
			cQuery += "   and JC7_ANDAR  = '"+JC7->JC7_ANDAR+"'"
			cQuery += "   and JC7_CODSAL = '"+JC7->JC7_CODSAL+"'"
			cQuery += "   and JC7_DIASEM = '"+JC7->JC7_DIASEM+"'"
			cQuery += "   and JC7_HORA1  = '"+JC7->JC7_HORA1+"'"
			cQuery += "   and JC7_SEQ    = '001'"
	
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY3", .F., .F. )

			RecLock("JC7",.F.)
			if QRY3->( eof() .or. QRY3->QUANT == 0 )
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" atualizado na JC7 para o sequencial 001." )
				JC7->JC7_SEQ := "001"
			else
				AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" eliminado da JC7 para impedir duplicidade." )
				JC7->( dbDelete() )
			endif
			JC7->( msUnlock() )
			
			QRY3->( dbCloseArea() )
			dbSelectArea("JBE")

			QRY2->( dbSkip() )
		end
		QRY2->( dbCloseArea() )
		dbSelectArea("JBE")
	endif
	
	QRY1->( dbSkip() )
end
QRY1->( dbCloseArea() )
dbSelectArea("JBE")

//
// 2a Parte - Localiza JC7 com SEQ invalido (sem JBE correspondente) e busca o JBE_SEQ correto
//
cQuery := "select R_E_C_N_O_ REC"
cQuery += "  from "+RetSQLName("JC7")
cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and D_E_L_E_T_ = ' '"
cQuery += "   and not exists ( select JBE_SEQ"
cQuery += "                      from "+RetSQLName("JBE")
cQuery += "                     where JBE_FILIAL = JC7_FILIAL  and D_E_L_E_T_ = ' '"
cQuery += "                       and JBE_NUMRA  = JC7_NUMRA"
cQuery += "                       and JBE_CODCUR = JC7_CODCUR"
cQuery += "                       and JBE_PERLET = JC7_PERLET"
cQuery += "                       and JBE_HABILI = JC7_HABILI"
cQuery += "                       and JBE_TURMA  = JC7_TURMA"
cQuery += "                       and JBE_SEQ    = JC7_SEQ )"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY1", .F., .F. )

while QRY1->( !eof() )
	JC7->( dbGoTo( QRY1->REC ) )
	
	if JC7->JC7_SITUAC$"1234568A"
		cAtivo := "'1','2','5'"
	else
		cAtivo := "'3','4','6','7','8','9','A','B'"
	endif
	
	cQuery := "select JBE_SEQ"
	cQuery += "  from "+RetSQLName("JBE")
	cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' and D_E_L_E_T_ = ' '"
	cQuery += "   and JBE_NUMRA  = '"+JC7->JC7_NUMRA+"'"
	cQuery += "   and JBE_CODCUR = '"+JC7->JC7_CODCUR+"'"
	cQuery += "   and JBE_PERLET = '"+JC7->JC7_PERLET+"'"
	cQuery += "   and JBE_HABILI = '"+JC7->JC7_HABILI+"'"
	cQuery += "   and JBE_TURMA  = '"+JC7->JC7_TURMA+"'"
	cQuery += "   and JBE_ATIVO in ("+cAtivo+")"
	cQuery += "   and not exists ( select JC7_SEQ"
	cQuery += "                      from "+RetSQLName("JC7")
	cQuery += "                     where JC7_FILIAL = JBE_FILIAL and D_E_L_E_T_ = ' '"
	cQuery += "                       and JBE_NUMRA  = JC7_NUMRA"
	cQuery += "                       and JBE_CODCUR = JC7_CODCUR"
	cQuery += "                       and JBE_PERLET = JC7_PERLET"
	cQuery += "                       and JBE_HABILI = JC7_HABILI"
	cQuery += "                       and JBE_TURMA  = JC7_TURMA"
	cQuery += "                       and JBE_SEQ    = JC7_SEQ"
	cQuery += "                       and JC7_DISCIP = '"+JC7->JC7_DISCIP+"'"
	cQuery += "                       and JC7_CODLOC = '"+JC7->JC7_CODLOC+"'"
	cQuery += "                       and JC7_CODPRE = '"+JC7->JC7_CODPRE+"'"
	cQuery += "                       and JC7_ANDAR  = '"+JC7->JC7_ANDAR+"'"
	cQuery += "                       and JC7_CODSAL = '"+JC7->JC7_CODSAL+"'"
	cQuery += "                       and JC7_DIASEM = '"+JC7->JC7_DIASEM+"'"
	cQuery += "                       and JC7_HORA1  = '"+JC7->JC7_HORA1+"' )"
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY2", .F., .F. )
	
	RecLock("JC7",.F.)
	if QRY2->( !eof() .and. !Empty(JBE_SEQ) )
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" atualizado na JC7 para o sequencial "+QRY2->JBE_SEQ+"." )
		JC7->JC7_SEQ := QRY2->JBE_SEQ
	else
		AcaLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+"- Registro "+Str(JC7->(Recno()),10)+" eliminado da JC7 para impedir duplicidade." )
		JC7->( dbDelete() )
	endif
	JC7->( msUnlock() )

	QRY2->( dbCloseArea() )
	dbSelectArea("JBE")
	
	QRY1->( dbSkip() )
end
QRY1->( dbCloseArea() )
dbSelectArea("JBE")
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix104992 บAutor  ณRafael Rodrigues    บ Data ณ 09/Fev/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrecao do JBE_ATIVO dos alunos afetados pelo BOPS 93086   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx104992()
FixWindow( 104992, {|| F104992G() } )
Return

Static Function F104992G()
Local cQuery	:= ""
Local lMSSQL	:= "MSSQL"$Upper(TCGetDB())
Local lMySQL	:= "MYSQL"$Upper(TCGetDB())
Local cAlias1	:= GetNextAlias()
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local cCCusto1	:= ""
Local cCCusto2	:= ""

cQuery += "select jbe_numra, jbe_codcur, jbe_perlet, jbe_habili, jbe_turma, jbe_anolet, jbe_period, jbe_tipo, r_e_c_n_o_ rec"
cQuery += "  from "+RetSQLName("JBE")+" a"
cQuery += " where a.jbe_filial = '"+xFilial("JBE")+"' and a.d_e_l_e_t_ = ' '"
cQuery += "   and a.jbe_ativo  = '1'"
cQuery += "   and jbe_perlet = ( select max(jar_perlet)"
cQuery += "                        from "+RetSQLName("JAR")+" jar"
cQuery += "                       where jar_filial = a.jbe_filial and jar.d_e_l_e_t_ = ' '"
cQuery += "                         and jar_codcur = a.jbe_codcur )"
cQuery += "   and exists ( select jbe_numra"
cQuery += "                  from "+RetSQLName("JBE")+" b"
cQuery += "                 where b.jbe_filial = a.jbe_filial and b.d_e_l_e_t_ = ' '"
cQuery += "                   and b.jbe_numra  = a.jbe_numra"
cQuery += "                   and b.jbe_codcur = a.jbe_codcur"
cQuery += "                   and b.jbe_perlet < a.jbe_perlet )"
cQuery += "   and exists ( select jbe_numra"
cQuery += "                  from "+RetSQLName("JBE")+" c"
cQuery += "                 where c.jbe_filial = a.jbe_filial and c.d_e_l_e_t_ = ' '"
cQuery += "                   and c.jbe_numra  = a.jbe_numra"
cQuery += "                   and c.jbe_codcur <> a.jbe_codcur"
cQuery += "                   and c.jbe_perlet = a.jbe_perlet"
cQuery += "                   and c.jbe_ativo  = '1'"
if lMSSQL
	cQuery += "                   and c.jbe_anolet+c.jbe_period > a.jbe_anolet+a.jbe_period )"
elseif lMySQL
	cQuery += "                   and Concat(c.jbe_anolet, c.jbe_period) > Concat(a.jbe_anolet, a.jbe_period) )"
else
	cQuery += "                   and c.jbe_anolet||c.jbe_period > a.jbe_anolet||a.jbe_period )"
endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias1, .F., .F. )

while (cAlias1)->( !eof() )
	cQuery := "select r_e_c_n_o_ rec"
	cQuery += "  from "+RetSQLName("JBE")
	cQuery += " where jbe_filial = '"+xFilial("JBE")+"' and d_e_l_e_t_ = ' '"
	cQuery += "   and jbe_ativo  = '1'"
	cQuery += "   and jbe_numra  = '"+(cAlias1)->JBE_NUMRA+"'"
	cQuery += "   and jbe_codcur <> '"+(cAlias1)->JBE_CODCUR+"'"
	if lMSSQL
		cQuery += "   and jbe_anolet+jbe_period > '"+(cAlias1)->(JBE_ANOLET+JBE_PERIOD)+"'"
	elseif lMySQL
		cQuery += "   and Concat(jbe_anolet,jbe_period) > '"+(cAlias1)->(JBE_ANOLET+JBE_PERIOD)+"'"
	else
		cQuery += "   and jbe_anolet||jbe_period > '"+(cAlias1)->(JBE_ANOLET+JBE_PERIOD)+"'"
	endif
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias2, .F., .F. )
	
	if (cAlias2)->( !eof() )
		JBE->( dbGoTo( (cAlias2)->REC ) )
	
		(cAlias2)->( dbCloseArea() )
		dbSelectArea("JA2")
		
		AcaLog( cLogFile, "[Registro JBE "+Alltrim(Str(JBE->(Recno())))+"]"+" : Aluno "+Alltrim((cAlias1)->JBE_NUMRA)+" ("+Alltrim(Posicione("JA2",1,xFilial("JA2")+(cAlias1)->JBE_NUMRA,"JA2_NOME"))+") " )
		AcaLog( cLogFile, "  - Ano/semestre   : "+JBE->( JBE_ANOLET+"/"+JBE_PERIOD ) )
		AcaLog( cLogFile, "  - Curso indevido : "+JBE->( JBE_CODCUR+"/"+JBE_PERLET+"/"+JBE_TURMA+" - "+Alltrim(Posicione("JAH",1,xFilial("JAH")+JBE_CODCUR,"JAH_DESC")) ) )
		AcaLog( cLogFile, "  - Curso correto  : "+(cAlias1)->( JBE_CODCUR+"/"+JBE_PERLET+"/"+JBE_TURMA+" - "+Alltrim(Posicione("JAH",1,xFilial("JAH")+JBE_CODCUR,"JAH_DESC")) ) )
		
		cQuery := "select r_e_c_n_o_ rec"
		cQuery += "  from "+RetSQLName("JC7")
		cQuery += " where jc7_filial = '"+xFilial("JC7")+"' and d_e_l_e_t_ = ' '"
		cQuery += "   and jc7_numra  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and jc7_codcur = '"+JBE->JBE_CODCUR+"'"
		cQuery += "   and jc7_perlet = '"+JBE->JBE_PERLET+"'"
		cQuery += "   and jc7_habili = '"+JBE->JBE_HABILI+"'"
		cQuery += "   and jc7_turma  = '"+JBE->JBE_TURMA+"'"
	
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias2, .F., .F. )
		
		AcaLog( cLogFile, "  - Disciplinas movidas:" )
		if (cAlias2)->( !eof() )
			while (cAlias2)->( !eof() )
				JC7->( dbGoTo( (cAlias2)->REC ) )
				if !Empty( JC7->JC7_OUTCUR )
					if JC7->JC7_SITDIS == "001"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Adapta็ใo (mantida)" )
					elseif JC7->JC7_SITDIS == "002"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Depend๊ncia (mantida)" )
					elseif JC7->JC7_SITDIS == "006"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Tutoria (mantida)" )
					elseif JC7->JC7_SITDIS == "010"
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Regular (alterada para Depend๊ncia)" )
					else
						AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Outra situa็ใo (mantida)" )
					endif

					RecLock("JC7",.F.)
					JC7->JC7_CODCUR	:= (cAlias1)->JBE_CODCUR
					JC7->JC7_PERLET	:= (cAlias1)->JBE_PERLET
					JC7->JC7_HABILI	:= (cAlias1)->JBE_HABILI
					JC7->JC7_TURMA	:= (cAlias1)->JBE_TURMA
					if JC7->JC7_SITDIS == "010"
						JC7->JC7_SITDIS	:= "002"
					endif
					JC7->JC7_SEQ	:= "002"
					JC7->( msUnlock() )
				else
					AcaLog( cLogFile, "    [Registro JC7 "+Alltrim(Str(JC7->(Recno())))+"] : "+PadR(JC7->JC7_DISCIP+" ("+Alltrim(Posicione("JAE",1,xFilial("JAE")+JC7->JC7_DISCIP,"JAE_DESC"))+")",60)+"  Regular (mantida)" )
					
					RecLock("JC7",.F.)
					JC7->JC7_OUTCUR	:= JC7->JC7_CODCUR
					JC7->JC7_OUTPER	:= JC7->JC7_PERLET
					JC7->JC7_OUTHAB	:= JC7->JC7_HABILI
					JC7->JC7_OUTTUR	:= JC7->JC7_TURMA
					JC7->JC7_CODCUR	:= (cAlias1)->JBE_CODCUR
					JC7->JC7_PERLET	:= (cAlias1)->JBE_PERLET
					JC7->JC7_HABILI	:= (cAlias1)->JBE_HABILI
					JC7->JC7_TURMA	:= (cAlias1)->JBE_TURMA
					JC7->JC7_SEQ	:= "002"
					JC7->( msUnlock() )
				endif
				(cAlias2)->( dbSkip() )
			end
		else
			AcaLog( cLogFile, "    Nenhuma disciplina vinculada a esta matricula" )
		endif	
		
		cQuery := "select r_e_c_n_o_ rec"
		cQuery += "  from "+RetSQLName("SE1")
		cQuery += " where e1_filial = '"+xFilial("SE1")+"' and d_e_l_e_t_ = ' '"
		cQuery += "   and e1_numra  = '"+JBE->JBE_NUMRA+"'"
		cQuery += "   and e1_nrdoc like '"+JBE->(JBE_CODCUR+JBE_PERLET)+"%'"
	
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias3, .F., .F. )

		AcaLog( cLogFile, "  - Tํtulos movidos:" )
		if (cAlias3)->( !eof() )
			while (cAlias3)->( !eof() )
				SE1->( dbGoTo( (cAlias3)->REC ) )
				AcaLog( cLogFile, "    [Registro SE1 "+Alltrim(Str(SE1->(Recno())))+"] : "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+SE1->E1_TIPO )
				RecLock("SE1",.F.)
				SE1->E1_NRDOC	:= (cAlias1)->( JBE_CODCUR+JBE_PERLET )+Subs( SE1->E1_NRDOC, 9 )
				SE1->( msUnlock() )
				
				(cAlias3)->( dbSkip() )
			end
		else
			AcaLog( cLogFile, "    Nenhum tํtulo vinculado a esta matricula" )
		endif
		
		(cAlias3)->( dbCloseArea() )
		dbSelectArea("JA2")
		
		RecLock("JBE",.F.)
		JBE->JBE_CODCUR	:= (cAlias1)->JBE_CODCUR
		JBE->JBE_PERLET	:= (cAlias1)->JBE_PERLET
		JBE->JBE_TIPO	:= "2"
		JBE->JBE_SEQ	:= "002"
		JBE->( msUnlock() )
		
		// Desativa o periodo letivo anterior do curso correto
		JBE->( dbGoTo( (cAlias1)->REC ) )
		RecLock("JBE",.F.)
		JBE->JBE_ATIVO	:= "2"
		JBE->( msUnlock() )
		
		cCCusto1 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+(cAlias1)->JBE_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO, "JAF_CCUSTO")
		cCCusto2 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO, "JAF_CCUSTO")
		if cCCusto1 <> cCCusto2
			AcaLog( cLogFile, "" )
			AcaLog( cLogFile, "  * Aten็ใo! O centro de custo do curso anterior ("+cCCusto1+") ้ diferente do centro de custo do curso atual do aluno ("+cCCusto2+"). ษ necessแrio rever os lan็amentos contแbeis deste aluno." )
		endif
		
		AcaLog( cLogFile, "" )
	endif

	(cAlias2)->( dbCloseArea() )
	dbSelectArea("JA2")
	
	(cAlias1)->( dbSkip() )
end

(cAlias1)->( dbCloseArea() )
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFix111440 บAutor  ณViviane Miam        บ Data ณ 20/out/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpar o valor dos campos JAV_CHAMAD, JAV_PROCES, JAV_POSICAบฑฑ
ฑฑบ          ณpara realiza็ใo do processamento de chamada que estava      บฑฑ
ฑฑบ          ณincorreto.												  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111440()
FixWindow( 111440, {|| F111440G() } )
Return

Static Function F111440G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()       
Local cAlias1	:= GetNextAlias()
Local aArea		:= GetArea()

cQuery += "select JAV_CODCAN, JAV_CODPRO, JAV_CODFAS, JAV_CODCUR"
cQuery += "  from "+RetSQLName("JAV")
cQuery += " where JAV_FILIAL = '"+xFilial("JAV")+"'
cQuery += "   and JAV_STATUS = '09'"
cQuery += "   and D_E_L_E_T_ = ' '"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

Begin Transaction
JAV->(dbSetOrder(1))

While (cAlias)->(!Eof())
	cTexto := ""
	cTexto := "******* ALUNO " + (cAlias)->JAV_CODCAN + Chr(13)+Chr(10)
	cTexto := "******* PROCESSO SELETIVO " + (cAlias)->JAV_CODPRO + Chr(13)+Chr(10)	
	cTexto := "******* FASE " + (cAlias)->JAV_CODFAS + Chr(13)+Chr(10)
	cTexto := "******* CURSO " + (cAlias)->JAV_CODCUR + Chr(13)+Chr(10)	
	
	If JAV->(dbSeek(xFilial("JAV")+(cAlias)->(JAV_CODCAN+JAV_CODPRO+JAV_CODFAS+JAV_CODCUR)))
		RecLock("JAV", .F.)
	
		JAV->JAV_CHAMAD := ''
		JAV->JAV_PROCES := ''
		JAV->JAV_POSICA := 0.0
		
		JAV->(MsUnlock())
	Endif
	(cAlias)->(dbSkip())
End

(cAlias)->(dbCloseArea())
      
cQuery := ""
//ATUALIZA A QUANTIDADE DE VAGASselect COUNT(JAV_CODCAN) PRE, JAV_CODPRO, JAV_CODCUR 
cQuery += " select COUNT(JAV_CODCAN) PRE, JAV_CODPRO, JAV_CODCUR "
cQuery += " from "+RetSQLName("JAV")+ " A "
cQuery += " where JAV_FILIAL = ' ' and D_E_L_E_T_ = ' ' "
cQuery += "   and JAV_STATUS = '01' "
cQuery += "   and JAV_CHAMAD <> ' ' "
cQuery += "   and JAV_CODCAN not in ( select JAV_CODCAN "
cQuery += "                             from "+RetSQLName("JAV")+ " B "
cQuery += "                            where B.R_E_C_N_O_ = A.R_E_C_N_O_ "
cQuery += "                              and EXISTS ( SELECT JA2_CODINS "
cQuery += "                                             FROM "+RetSQLName("JA2")
cQuery += "                                            WHERE JA2_CODINS = B.JAV_CODCAN "
cQuery += "                                              AND D_E_L_E_T_ = '*') "
cQuery += "                              and NOT EXISTS ( SELECT JA2_CODINS  "
cQuery += "                                                 FROM "+RetSQLName("JA2")
cQuery += "                                                WHERE JA2_CODINS = B.JAV_CODCAN "
cQuery += "                                                  AND D_E_L_E_T_ = ' ') ) "
cQuery += " GROUP BY JAV_CODPRO, JAV_CODCUR "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias1, .F., .F. )
dbSelectArea("JA7")
dbSetOrder(1)

While (cAlias1)->(!Eof())
	If JA7->( dbSeek( xFilial("JA7") + (cAlias1)->JAV_CODPRO + (cAlias1)->JAV_CODCUR ) )
		RecLock( "JA7", .F. )
		JA7->JA7_VAGPRE := (cAlias1)->PRE
		JA7->JA7_VAGLIV := JA7->JA7_NUMVAG - JA7->JA7_VAGPRE
		JA7->( MsUnlock() )
	Endif               
	(cAlias1)->(dbSkip())	
End

End Transaction

DbSelectArea("JA7")
RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111845  บAutor  ณRafael Rodrigues    บ Data ณ 23/Out/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorrecao do JBE_TIPO dos alunos afetados pelo BOPS 111845   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111845()
FixWindow( 111845, {|| F111845G() } )
Return

Static Function F111845G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

cQuery += "select jbe_numra, jbe_codcur, jbe_perlet, jbe_habili, jbe_turma, jar_dpmax"
cQuery += "  from "+RetSQLName("JBE")+" jbe, "
cQuery +=           RetSQLName("JAR")+" jar "
cQuery += " where jbe_filial = '"+xFilial("JBE")+"' and jbe.d_e_l_e_t_ = ' '"
cQuery += "   and jar_filial = '"+xFilial("JAR")+"' and jar.d_e_l_e_t_ = ' '"
cQuery += "   and jbe_tipo   = '2'"
cQuery += "   and jbe_codcur = jar_codcur"
cQuery += "   and jbe_perlet = jar_perlet"
cQuery += "   and jbe_habili = jar_habili"
cQuery += "   and jbe_anolet = jar_anolet"
cQuery += "   and jbe_period = jar_period"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )

while (cAlias)->( !eof() )
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" alunos..." )
	
	(cAlias)->( ACBloqAlu( JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JAR_DPMAX, JBE_PERLET, JBE_HABILI ) )

	AcaLog( cLogFile, "  Aluno "+(cAlias)->JBE_NUMRA+" regulazirado." )
	(cAlias)->( dbSkip() )
end

(cAlias)->( dbCloseArea() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx114547  บAutor  ณViviane Miam        บ Data ณ 01/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEstorno dos boletos de matrํcula gerados sem desconto, devi-บฑฑ
ฑฑบ          ณdo filtro incorreto no ACAA680.PRW                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx114547()
FixWindow( 114547, {|| F114547G() } )
Return

Static Function F114547G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

cQuery += "select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
cQuery += "  from "+RetSQLName("SE1")+" E1 "
cQuery += " where E1_FILIAL = '"+xFilial("SE1")+"' and E1.D_E_L_E_T_ = ' '"
cQuery += "   and (E1_PREFIXO = 'MAT' or E1_PREFIXO = 'MES')"
cQuery += "   and E1_VENCTO = '20070117'"
cQuery += "   and E1_DESCON1 = '0.0'"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )

Begin Transaction
SE1->(dbSetOrder(1))

while (cAlias)->( !eof() )
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" titulos..." )
	
	If SE1->(dbSeek(xFilial("SE1")+(cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
		SE1->(RecLock("SE1",.F.))
		SE1->(dbDelete())
		SE1->(MsUnLock())
	Endif

	AcaLog( cLogFile, "  Titulo "+(cAlias)->E1_PREFIXO + (cAlias)->E1_NUM + " Parcela: " + (cAlias)->E1_PARCELA + " Tipo: " + (cAlias)->E1_TIPO + " regulazirado." )
	(cAlias)->( dbSkip() )
end

End Transaction
(cAlias)->( dbCloseArea() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx115512  บAutor  ณViviane Miam        บ Data ณ 11/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณO sistema estava deixando mais de um curso ativo.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx115512()
FixWindow( 115512, {|| F115512G() } )
Return

Static Function F115512G()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local nCount	:= 0

cQuery += " SELECT DISTINCT JAF1.JAF_COD, JAF1.JAF_VERSAO "
cQuery += " FROM "+RetSQLName("JAF")+" JAF1 "
cQuery += " WHERE JAF1.JAF_ATIVO = '1' "
cQuery += " AND JAF1.D_E_L_E_T_ = '' "
cQuery += " AND JAF1.JAF_FILIAL = '"+xFilial("JAF")+"' "
cQuery += " AND JAF1.JAF_VERSAO NOT IN ( SELECT MAX(JAF2.JAF_VERSAO) "
cQuery += "			   FROM "+RetSQLName("JAF")+" JAF2 "
cQuery += "			WHERE JAF2.JAF_COD = JAF1.JAF_COD "
cQuery += "			AND JAF2.JAF_ATIVO = '1' "
cQuery += "			AND JAF2.D_E_L_E_T_ = '' "   
cQuery += " 		AND JAF2.JAF_FILIAL = '"+xFilial("JAF")+"' "
cQuery += "			GROUP BY JAF2.JAF_COD) "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )

Begin Transaction
JAF->(dbSetOrder(1))

while (cAlias)->( !eof() )
	
	If JAF->(dbSeek(xFilial("JAF")+(cAlias)->(JAF_COD+JAF_VERSAO)))
		JAF->(RecLock("JAF",.F.))
		JAF->JAF_ATIVO := '2' //Desativa os cursos com vers๕es anteriores
		JAF->(MsUnLock())
	Endif

	AcaLog( cLogFile, "   Curso: "+(cAlias)->JAF_COD + " Versao: " + (cAlias)->JAF_VERSAO + " regularizado." )
	(cAlias)->( dbSkip() )
end

End Transaction
(cAlias)->( dbCloseArea() )
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx116173  บAutor  ณViviane Miam      บ Data ณ 11/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo na JCX e JCY para rodar lote novamente.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx116173()
FixWindow( 116173, {|| F116173G() } )
Return

Static Function F116173G()
Local cQuery	:= ""
Local cQuery1	:= ""
Local cAlias	:= GetNextAlias()
Local cAlias1	:= GetNextAlias()
Local nCount	:= 0
                  
if SIX->( !dbSeek("JCY3") )
	RecLock("SIX",.T.)
	SIX->INDICE := "JCY3"
	SIX->ORDEM     := "3"
	SIX->CHAVE     := "JCY_FILIAL+JCY_MATPRF+JCY_LOTE+JCY_CODCUR+JCY_PERLET+JCY_HABILI+JCY_TURMA+JCY_CODDIS"
	SIX->DESCRICAO := ""
	SIX->DESCSPA   := ""
	SIX->DESCENG   := ""
	SIX->PROPRI    := "S"
	SIX->F3        := ""
	SIX->NICKNAME  := ""
	SIX->SHOWPESQ  := "S"	
	SIX->( msUnlock() )
endif
cQuery := " SELECT JCX.JCX_FILIAL, JCX.JCX_CODCUR, JCX.JCX_PERLET, JCX.JCX_HABILI, JCX.JCX_TURMA, JCX.JCX_CODDIS, "
cQuery += " JCX.JCX_CODAVA, JCX.JCX_NUMRA, JCX.JCX_MATPRF, JCX.JCX_LOTE "
cQuery += " FROM "+RetSQLName("JCX")+" JCX "
cQuery += " WHERE JCX.JCX_CODATI = 'SU' "
cQuery += " AND JCX.D_E_L_E_T_ = ' ' "
cQuery += " AND JCX.JCX_FILIAL = '"+xFilial("JCX")+"' "
cQuery += "	ORDER BY JCX.JCX_LOTE "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )

ProcRegua( nCount )
dbSelectArea("JCY")
JCY->(dbSetOrder(3))
dbSelectArea("JCX")
JCX->(dbSetOrder(1))
dbSelectArea("JBS")
JBS->(dbSetOrder(1))
Begin Transaction

while (cAlias)->( !eof() )                               
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" registros..." )
	if JCX->(dbSeek(xFilial("JCX")+(cAlias)->(JCX_MATPRF+JCX_LOTE+JCX_CODCUR+JCX_PERLET+JCX_HABILI+JCX_TURMA+JCX_CODDIS+JCX_CODAVA+JCX_NUMRA)))
		JCX->(RecLock("JCX",.F.))
		JCX->JCX_CONF := ' '
		JCX->JCX_DATCOF := CtoD("  /  /  ")
		JCX->JCX_CODATI := '  '
		JCX->(MsUnLock())
		
		cQuery1 := " SELECT JCY.JCY_FILIAL, JCY.JCY_CODCUR, JCY.JCY_PERLET, JCY.JCY_HABILI, JCY.JCY_TURMA, JCY.JCY_CODDIS, "
		cQuery1 += " JCY.JCY_MATPRF, JCY.JCY_LOTE "
		cQuery1 += " FROM "+RetSQLName("JCY")+" JCY "
		cQuery1 += " WHERE JCY.D_E_L_E_T_ = ' ' "
		cQuery1 += " AND JCY.JCY_FILIAL = '"+xFilial("JCY")+"' "
		cQuery1 += " AND JCY.JCY_MATPRF = '"+(cAlias)->(JCX_MATPRF)+"' "			
		cQuery1 += " AND JCY.JCY_LOTE = '"+(cAlias)->(JCX_LOTE)+"' "			
		cQuery1 += " AND JCY.JCY_CODCUR = '"+(cAlias)->(JCX_CODCUR)+"' "			
		cQuery1 += " AND JCY.JCY_PERLET = '"+(cAlias)->(JCX_PERLET)+"' "			
		cQuery1 += " AND JCY.JCY_TURMA = '"+(cAlias)->(JCX_TURMA)+"' "												
		cQuery1 += " AND JCY.JCY_HABILI = '"+(cAlias)->(JCX_HABILI)+"' "												
		cQuery1 += " AND JCY.JCY_CODDIS = '"+(cAlias)->(JCX_CODDIS)+"' "												
		cQuery1 := ChangeQuery( cQuery1 )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )

		(cAlias1)->( dbEval( {|| nCount++ } ) )
		(cAlias1)->( dbGoTop() )
		if JCY->(dbSeek(xFilial("JCY")+(cAlias1)->(JCY_MATPRF+JCY_LOTE+JCY_CODCUR+JCY_PERLET+JCY_HABILI+JCY_TURMA+JCY_CODDIS)))
			JCY->(RecLock("JCY",.F.))
			JCY->JCY_CONF := '1'
			JCY->(MsUnLock())
		Endif
		(cAlias1)->( dbCloseArea() )
		AcaLog( cLogFile, "   Filial: "+xFilial("JCX")+"   Curso: "+(cAlias)->JCX_CODCUR + " Periodo: " + (cAlias)->JCX_PERLET+ " Habilitacao: " + (cAlias)->JCX_HABILI+ " Turma: " + (cAlias)->JCX_TURMA+" Disciplina: " + (cAlias)->JCX_CODDIS+" Avaliacao: " + (cAlias)->JCX_CODAVA+" RA: " + (cAlias)->JCX_NUMRA+" regularizado." )
	Endif
	(cAlias)->( dbSkip() )
end

(cAlias)->( dbCloseArea() )

dbSelectArea("JA2")

End Transaction
                          
SIX->( dbSetOrder(1) )
if SIX->( dbSeek("JCY3") )
	if Select("JCY") > 0
		JCY->( dbCloseArea() )
	endif
	if ChkFile("JCY",.T.)
		RecLock("SIX",.F.)
		SIX->( dbDelete() )		
		SIX->( msUnlock() )
		// FECHA A TABELA PARA MANIPULAR O INDICE
		if Select("JCY") > 0
			JCY->( dbCloseArea() )
		endif
		// APAGA O INDICE NO DATABASE
		TcSqlExec( "DROP INDEX "+RetSqlName("JCY")+"."+RetSQLName("JCY")+"3" )
	Endif
endif                  

dbSelectArea("JA2")
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx116458  บAutor  ณEduardo de Souza    บ Data ณ 21/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza o recalculo da media, para disciplinas com avalicao บฑฑ
ฑฑบ          ณpor atividades com sub-turma                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx116458()
FixWindow( 116458, {|| F116458G() } )
Return

Static Function F116458G()
Local cQuery	:= ""
Local aMedia	:= {}
Local aAlunos	:= {}
Local nCount	:= 0
Local i, j		:= 0
Local nTotal	:= 0
Local lSubTurma  := JBR->( FieldPos( "JBR_SUBTUR" ) ) > 0

/*ESTRUTURA ARRAY aMEDIA
[n, 1] = Curso Vigente
[n, 2] = Periodo Letivo
[n, 3] = Habilitacao
[n, 4] = Turma
[n, 5] = Disciplina
[n, 6] = aAlunos
[n, 7] = Tipo de Avaliacao
--------------------------------
ESTRUTURA ARRAY aALUNOS
[n, 1] = RA
[n, 2] = Cursa em Outra Turma? (1=Sim/2=Nao)*/

cQuery := "SELECT DISTINCT JC7_FILIAL, JC7_NUMRA, JBE_CODCUR, JC7_PERLET, JC7_HABILI, "
cQuery += " JC7_TURMA, JC7_OUTCUR, JBL_SUBTUR, JC7_DISCIP, JBQ_TIPO, JC7_CODPRF, JBQ_CODAVA "

cQuery += " FROM " + RetSQLName("JBK") + " JBK, " + RetSQLName("JBL") + " JBL, " + RetSQLName("JAR") + " JAR, "
cQuery += RetSQLName("JC7") + " JC7, " + RetSQLName("JBQ") + " JBQ, " + RetSQLName("JBE") + " JBE "

cQuery += " WHERE JAR_FILIAL = JBE_FILIAL "
cQuery += " AND JBK_FILIAL = JBE_FILIAL "
cQuery += " AND JBL_FILIAL = JBE_FILIAL "
cQuery += " AND JAR_FILIAL = JBE_FILIAL "
cQuery += " AND JC7_FILIAL = JBE_FILIAL "
cQuery += " AND JBQ_FILIAL = JBE_FILIAL "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "

cQuery += " AND JBK_CODCUR = JAR_CODCUR "
cQuery += " AND JBK_PERLET = JAR_PERLET "
cQuery += " AND JBK_HABILI = JAR_HABILI "

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JC7_CODCUR = JBL_CODCUR "
cQuery += " AND JC7_PERLET = JBL_PERLET "
cQuery += " AND JC7_HABILI = JBL_HABILI "
cQuery += " AND JC7_TURMA  = JBL_TURMA "
cQuery += " AND JC7_SUBTUR = JBL_SUBTUR "
cQuery += " AND JC7_DISCIP = JBL_CODDIS "

cQuery += " AND JBQ_CODCUR = JAR_CODCUR "
cQuery += " AND JBQ_PERLET = JAR_PERLET "
cQuery += " AND JBQ_HABILI = JAR_HABILI "

cQuery += " AND JBE_NUMRA = JC7_NUMRA "
cQuery += " AND JBE_CODCUR = JC7_CODCUR "
cQuery += " AND JBE_PERLET = JC7_PERLET "
cQuery += " AND JBE_HABILI = JC7_HABILI "
cQuery += " AND JBE_TURMA  = JC7_TURMA "
cQuery += " AND JBE_ANOLET = JAR_ANOLET "
cQuery += " AND JBE_PERIOD = JAR_PERIOD "

cQuery += " AND JBL_SUBTUR <> '  ' " //SubTurma nao pode estar em branco
cQuery += " AND JBK_ATIVO = '1' " //Grade de aulas deve estar ativa.
cQuery += " AND JC7_SITDIS IN ('001', '002', '010') " //Adaptacao, Dependencia, Tutoria
cQuery += " AND JBQ_ATIVID = '1' " //Apontamento da avaliacao deve ser por atividades
cQuery += " AND JAR_ANOLET = '2006' " //Somente ano 2006
cQuery += " AND JAR_PERIOD = '02' "  //Somente 2 periodo
cQuery += " AND JBE_ATIVO = '1' "	//Alunos ativos
cQuery += " AND JBE_SITUAC = '2' "	//Alunos matriculados

cQuery += " AND JAR.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBQ.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "

//cQuery += " AND JAR_CODCUR = '000045' "

cQuery += " ORDER BY JBE_CODCUR, JC7_PERLET, JC7_HABILI, JC7_TURMA, JC7_DISCIP, JC7_NUMRA"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRYNOTA", .F., .F. )

QRYNOTA->( dbEval( {|| nCount++ } ) )
QRYNOTA->( dbGoTop() )

ProcRegua( nCount )

While QRYNOTA->(!Eof())
	IncProc( "Verificando registros "+ Alltrim(Str(nCount--)) )
	//Verifica se o curso+perlet+habili+turma+discip ja estao no array
	If aScan( aMedia, {|x| x[1]+x[2]+x[3]+x[4]+x[5] == QRYNOTA->(JBE_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP)})  == 0
		//Mudou a chave; deve entao adicionar os alunos pertencentes a disciplina
		If Len(aMedia) > 0 //Primeira inclusao; ignora pois nao possui o array estruturado
			aMedia[Len(aMedia), 6] := aAlunos
		Endif
		aAdd(aMedia, { QRYNOTA->JBE_CODCUR, QRYNOTA->JC7_PERLET, QRYNOTA->JC7_HABILI, QRYNOTA->JC7_TURMA, QRYNOTA->JC7_DISCIP, ,  QRYNOTA->JBQ_TIPO, QRYNOTA->JC7_NUMRA, QRYNOTA->JC7_OUTCUR,QRYNOTA->JC7_CODPRF,QRYNOTA->JBQ_CODAVA,QRYNOTA->JBL_SUBTUR   })
		aAlunos := {}
	Endif
	//Adiciona o aluno (se cursa em outra turma, "1"; senao, "2")
	aAdd( aAlunos, {QRYNOTA->JC7_NUMRA, Iif(Empty(QRYNOTA->JC7_OUTCUR), "2", "1")} )
	QRYNOTA->(DbSkip())
End
//Para a ultima linha matricial adiciona o array alunos
If Len(aMedia) > 0 //Primeira inclusao; ignora pois nao possui o array estruturado
	aMedia[Len(aMedia), 6] := aAlunos
Endif
QRYNOTA->(DbCloseArea())

ProcRegua( Len(aMedia) )

If Len(aMedia) > 0
	AcaLog (cLogFile, "RELACAO DE CURSOS QUE REALIZARAO RECALCULO DE MEDIA ")
Else
	AcaLog(cLogFile, " ** PARA ESTA EMPRESA/FILIAL NAO HA REGISTROS PARA SEREM PROCESSADOS")
Endif	

For i := 1 To Len(aMedia)
	IncProc( "Realizando calculo da m้dia..." )
	AcaLog(cLogFile, "CODCUR: " + aMedia[i, 1] + " - PERLET: " + aMedia[i, 2] + " - HABILI: " + aMedia[i, 3] + " - TURMA: " + aMedia[i, 4] + " - DISCIP.: " + aMedia[i, 5])

	AcaLanJBS( aMedia[i, 1], aMedia[i, 2], aMedia[i, 4], aMedia[i, 5], aMedia[i, 11], aMedia[i, 10], aMedia[i, 8], aMedia[i, 9], aMedia[i, 3], If( lSubTurma,aMedia[i, 12], "" ) )

	AcaCalcMedia(aMedia[i, 1], aMedia[i, 2], aMedia[i, 3], aMedia[i, 4], aMedia[i, 5], aMedia[i, 6], "")
	
	AcaLog(cLogFile, "		ALUNOS NESTA DISCIPLINA: ")
	For j := 1 To Len(aMedia[i, 6])
		AcaLog(cLogFile, "		" + aMedia[i,6,j,1]) //RA
		nTotal++
	Next j
	
	AcaLog(cLogFile, "		TOTAIS DE ALUNOS NESTA DISCIPLINA: " + Alltrim(STR(Len(aMedia[i, 6]))))
	AcaLog(cLogFile, "")
Next i

If nTotal > 0
	AcaLog(cLogFile, "")
	AcaLog(cLogFile, "** TOTAL GERAL DE REGISTROS PROCESSADOS PARA A EMPRESA/FILIAL: " + Alltrim(STR(nTotal)))	
Endif		

AcaLog(cLogFile, "******************************************************************")
Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx116398  บAutor  ณAlberto Deviciente  บ Data ณ 20/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo na JCV e JCW (Apont. Faltas) para rodar lote    บฑฑ
ฑฑบ          ณnovamente.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx116398()
FixWindow( 116398, {|| F116398G() } )
Return

Static Function F116398G()
Local cQuery	:= ""
Local cQuery1	:= ""
Local cAlias	:= GetNextAlias()
Local cAlias1	:= GetNextAlias()
Local nCount	:= 0

cQuery := "SELECT distinct JCW.JCW_NUMRA NUMRA, JCW.JCW_LOTE LOTE, JCW.JCW_CODCUR CODCUR, JCW.JCW_PERLET PERLET, JCW.JCW_TURMA TURMA, JCW.JCW_HABILI HABILI, JCW.JCW_DISCIP DISCIP, JCW.JCW_DATA DT, JCW.R_E_C_N_O_ RECNOJCW "
cQuery += "  FROM "+RetSQLName("JCV")+"  JCV, "+RetSQLName("JCW")+"  JCW "
cQuery += " WHERE JCV.JCV_FILIAL = '"+xFilial("JCV")+"' "
cQuery += "   AND JCV.JCV_FILIAL = JCW.JCW_FILIAL "
cQuery += "   AND JCV.JCV_LOTE   = JCW.JCW_LOTE "
cQuery += "   AND JCV.JCV_LOTE   = '000000000001349' "
cQuery += "   AND JCV.JCV_CODCUR = JCW.JCW_CODCUR "
cQuery += "   AND JCV.JCV_PERLET = JCW.JCW_PERLET "
cQuery += "   AND JCV.JCV_TURMA  = JCW.JCW_TURMA "
cQuery += "   AND JCV.JCV_HABILI = JCW.JCW_HABILI "
cQuery += "   AND JCV.JCV_DISCIP = JCW.JCW_DISCIP "
cQuery += "   AND JCV.JCV_CODLOC = JCW.JCW_CODLOC "
cQuery += "   AND JCW.JCW_DATA = '20061231' "
cQuery += "   AND JCV.D_E_L_E_T_ = ' ' "
cQuery += "   AND JCW.D_E_L_E_T_ = ' ' "
cQuery += "	ORDER BY JCW.JCW_LOTE, JCW.JCW_CODCUR, JCW.JCW_PERLET, JCW.JCW_HABILI, JCW.JCW_TURMA "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )


cQuery1 := "SELECT distinct JCV.JCV_LOTE LOTE, JCV.JCV_CODCUR CODCUR, JCV.JCV_PERLET PERLET, JCV.JCV_TURMA TURMA, JCV.JCV_HABILI HABILI, JCV.JCV_DISCIP DISCIP, JCV.R_E_C_N_O_ RECNOJCV "
cQuery1 += "  FROM "+RetSQLName("JCV")+"  JCV, "+RetSQLName("JCW")+"  JCW "
cQuery1 += " WHERE JCV.JCV_FILIAL = '"+xFilial("JCV")+"' "
cQuery1 += "   AND JCV.JCV_FILIAL = JCW.JCW_FILIAL "
cQuery1 += "   AND JCV.JCV_LOTE   = JCW.JCW_LOTE "
cQuery1 += "   AND JCV.JCV_LOTE   = '000000000001349' "
cQuery1 += "   AND JCV.JCV_CODCUR = JCW.JCW_CODCUR "
cQuery1 += "   AND JCV.JCV_PERLET = JCW.JCW_PERLET "
cQuery1 += "   AND JCV.JCV_TURMA  = JCW.JCW_TURMA "
cQuery1 += "   AND JCV.JCV_HABILI = JCW.JCW_HABILI "
cQuery1 += "   AND JCV.JCV_DISCIP = JCW.JCW_DISCIP "
cQuery1 += "   AND JCV.JCV_CODLOC = JCW.JCW_CODLOC "
cQuery1 += "   AND JCW.JCW_DATA = '20061231' "
cQuery1 += "   AND JCV.D_E_L_E_T_ = ' ' "
cQuery1 += "   AND JCW.D_E_L_E_T_ = ' ' "
cQuery1 += "  ORDER BY JCV.JCV_LOTE, JCV.JCV_CODCUR, JCV.JCV_PERLET, JCV.JCV_HABILI, JCV.JCV_TURMA "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )


(cAlias)->( dbEval( {|| nCount++ } ) )
(cAlias)->( dbGoTop() )
(cAlias1)->( dbGoTop() )

ProcRegua( nCount )

dbSelectArea("JAR")
dbSelectArea("JCW")
dbSelectArea("JCV")
dbSelectArea("JCH")

JAR->(dbSetOrder(1)) //JAR_FILIAL+JAR_CODCUR+JAR_PERLET+JAR_HABILI
JCH->(dbSetOrder(1)) //JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+DTOS(JCH_DATA)+JCH_DISCIP+JCH_CODAVA+JCH_HORA1


Begin Transaction

AcaLog( cLogFile, " ***  Atualizacao da tabela JCW: " )

while (cAlias)->( !eof() )                               
	IncProc( "Faltam "+Alltrim(Str(nCount--))+" registros..." )
    
    if JAR->( dbSeek( xFilial("JAR")+(cAlias)->(CODCUR+PERLET+HABILI) ) )
		
		if JCH->( dbSeek( xFilial("JCH")+(cAlias)->(NUMRA+CODCUR+PERLET+HABILI+TURMA+DT+DISCIP) ) )		
			JCH->(RecLock("JCH",.F.))
			JCH->JCH_DATA := JAR->JAR_DATA2
			JCH->(MsUnLock())					
		Endif
			
		JCW->( dbGoTo( (cAlias)->RECNOJCW ) )
		JCW->(RecLock("JCW",.F.))
		JCW->JCW_DATA := JAR->JAR_DATA2
		JCW->JCW_OK   := " "
		JCW->(MsUnLock())
		
		AcaLog( cLogFile, "   Filial: "+xFilial("JCW")+"   Curso: "+(cAlias)->CODCUR + " Periodo: " + (cAlias)->PERLET+ " Habilitacao: " + (cAlias)->HABILI+ " Turma: " + (cAlias)->TURMA+" Disciplina: " + (cAlias)->DISCIP+" regularizado." )
   	endif
   	
	(cAlias)->( dbSkip() )
end

AcaLog( cLogFile, " ***  Atualizacao da tabela JCV: " )
while (cAlias1)->( !eof() )                               
		
	JCV->( dbGoTo( (cAlias1)->RECNOJCV ) )
	JCV->(RecLock("JCV",.F.))
	JCV->JCV_OK   := "1"
	JCV->(MsUnLock())
	
	AcaLog( cLogFile, "   Filial: "+xFilial("JCV")+"   Curso: "+(cAlias1)->CODCUR + " Periodo: " + (cAlias1)->PERLET+ " Habilitacao: " + (cAlias1)->HABILI+ " Turma: " + (cAlias1)->TURMA+" Disciplina: " + (cAlias1)->DISCIP+" regularizado." )

	(cAlias1)->( dbSkip() )
end

End Transaction
                          
(cAlias)->( dbCloseArea() )
(cAlias1)->( dbCloseArea() )

dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111111  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JD9 que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111111_()
FixWindow( 111111, {|| F111111G() } )
Return

Static Function F111111G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//atualizando JD9
cQuery2 := " SELECT JD9_CODCUR, JD9_PERLET, JD9_HABILI, JD9_TURMA, JD9_CODDIS, JD9_CODAVA, JD9_SUBTUR "
cQuery2 += " FROM "+RetSQLName("JD9")+" JD9 "
cQuery2 += " WHERE JD9.JD9_FILIAL = '" + xFilial("JD9") + "' "
cQuery2 += " AND JD9.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JD9.JD9_SUBTUR NOT IN (SELECT JBL.JBL_SUBTUR "
cQuery2 += "                             FROM "+RetSQLName("JBL")+" JBL "
cQuery2 += "                             WHERE JBL.JBL_FILIAL = JD9.JD9_FILIAL  "
cQuery2 += "                             AND JBL.JBL_CODCUR = JD9.JD9_CODCUR  "
cQuery2 += "                             AND JBL.JBL_PERLET = JD9.JD9_PERLET "
cQuery2 += "                             AND JBL.JBL_HABILI = JD9.JD9_HABILI "
cQuery2 += "                             AND JBL.JBL_TURMA = JD9.JD9_TURMA  "
cQuery2 += "                             AND JBL.JBL_CODDIS = JD9.JD9_CODDIS  "
cQuery2 += "                             AND JBL.D_E_L_E_T_ = ' ') "
cQuery2 += " ORDER BY JD9_CODCUR DESC, JD9_PERLET, JD9_HABILI, JD9_TURMA, JD9_CODDIS, JD9_CODAVA, JD9_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )

ProcRegua( nCount )
dbSelectArea("JD9")
JD9->(dbSetOrder(1))
Begin Transaction                                
while (cAlias2)->( !eof() )              

	
	cQuery3 := " SELECT DISTINCT JBL.JBL_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JBL")+"  JBL "
	cQuery3 += " WHERE JBL.JBL_FILIAL = '" + xFilial("JBL") + "' "
	cQuery3 += " AND JBL.D_E_L_E_T_ = ' '"
	cQuery3 += " AND JBL.JBL_CODCUR = '" + (cAlias2)->JD9_CODCUR + "' " 
	cQuery3 += " AND JBL.JBL_PERLET = '" + (cAlias2)->JD9_PERLET + "' " 
	cQuery3 += " AND JBL.JBL_HABILI = '" + (cAlias2)->JD9_HABILI + "' " 
	cQuery3 += " AND JBL.JBL_TURMA = '" + (cAlias2)->JD9_TURMA + "' " 
	cQuery3 += " AND JBL.JBL_CODDIS = '" + (cAlias2)->JD9_CODDIS + "' " 
	cQuery3 += " AND JBL.JBL_SUBTUR NOT IN (SELECT JD9.JD9_SUBTUR "
	cQuery3 += "                             FROM "+RetSQLName("JD9")+" JD9 "
	cQuery3 += "                             WHERE JD9.JD9_FILIAL = JBL.JBL_FILIAL "
	cQuery3 += "                             AND JD9.JD9_CODCUR = JBL.JBL_CODCUR " 
	cQuery3 += "                             AND JD9.JD9_PERLET = JBL.JBL_PERLET " 
	cQuery3 += "                             AND JD9.JD9_HABILI = JBL.JBL_HABILI " 
	cQuery3 += "                             AND JD9.JD9_TURMA = JBL.JBL_TURMA " 
	cQuery3 += "                             AND JD9.JD9_CODDIS = JBL.JBL_CODDIS  " 
	cQuery3 += "                             AND JD9.JD9_CODAVA = '" + (cAlias2)->JD9_CODAVA + "' " 
	cQuery3 += "                             AND JD9.D_E_L_E_T_ = ' ') "
	cQuery3 += " ORDER BY JBL_SUBTUR "	

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if JD9->(dbSeek(xFilial("JD9")+(cAlias2)->(JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR)))
			JD9->(RecLock("JD9",.F.))
			JD9->( dbDelete() )
			JD9->(MsUnLock())
		endif
   	endif

   	while (cAlias3)->( !eof() ) 
		if !JD9->(dbSeek(xFilial("JD9")+(cAlias2)->(JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA)+(cAlias3)->JBL_SUBTUR))
			if JD9->(dbSeek(xFilial("JD9")+(cAlias2)->(JD9_CODCUR+JD9_PERLET+JD9_HABILI+JD9_TURMA+JD9_CODDIS+JD9_CODAVA+JD9_SUBTUR)))
				JD9->(RecLock("JD9",.F.))
				JD9->JD9_SUBTUR := (cAlias3)->JBL_SUBTUR
				JD9->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End
	(cAlias3)->( dbCloseArea() )	

	(cAlias2)->( dbSkip() )
end
(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111112  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JDA que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111112()
FixWindow( 111112, {|| F111112G() } )
Return

Static Function F111112G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//atualizando JDA
cQuery2 := " SELECT JDA_CODCUR, JDA_PERLET, JDA_HABILI, JDA_TURMA, JDA_CODDIS, JDA_CODAVA, JDA_ATIVID, JDA_SUBTUR  "
cQuery2 += " FROM "+RetSQLName("JDA")+" JDA "
cQuery2 += " WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += " AND JDA.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JDA.JDA_SUBTUR NOT IN (SELECT JD9.JD9_SUBTUR "
cQuery2 += "                           FROM "+RetSQLName("JD9")+" JD9 "
cQuery2 += "                           WHERE JD9.JD9_FILIAL = '" + xFilial("JD9") + "' "
cQuery2 += "                           AND JD9.D_E_L_E_T_ = ' ' "
cQuery2 += "                           AND JD9.JD9_CODCUR = JDA.JDA_CODCUR "
cQuery2 += "                           AND JD9.JD9_PERLET = JDA.JDA_PERLET "
cQuery2 += "                           AND JD9.JD9_HABILI = JDA.JDA_HABILI  "
cQuery2 += "                           AND JD9.JD9_TURMA = JDA.JDA_TURMA "
cQuery2 += "                           AND JD9.JD9_CODDIS = JDA.JDA_CODDIS  "
cQuery2 += "                           AND JD9.JD9_CODAVA = JDA.JDA_CODAVA)"
cQuery2 += " ORDER BY JDA_CODCUR DESC, JDA_PERLET, JDA_HABILI, JDA_TURMA, JDA_CODDIS, JDA_CODAVA, JDA_ATIVID, JDA_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )                                      
Begin Transaction   
ProcRegua( nCount )
dbSelectArea("JDA")
JDA->(dbSetOrder(6))
while (cAlias2)->( !eof() )              

	             
	cQuery3 := " SELECT DISTINCT JD9.JD9_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JD9")+" JD9 "
	cQuery3 += " WHERE JD9.JD9_FILIAL = '" + xFilial("JD9") + "' "
	cQuery3 += " AND JD9.D_E_L_E_T_ = ' ' "
	cQuery3 += " AND JD9.JD9_CODCUR = '" + (cAlias2)->JDA_CODCUR + "' " 
	cQuery3 += " AND JD9.JD9_PERLET = '" + (cAlias2)->JDA_PERLET + "' " 
	cQuery3 += " AND JD9.JD9_HABILI = '" + (cAlias2)->JDA_HABILI + "' " 
	cQuery3 += " AND JD9.JD9_TURMA = '" + (cAlias2)->JDA_TURMA + "' " 
	cQuery3 += " AND JD9.JD9_CODDIS = '" + (cAlias2)->JDA_CODDIS + "' " 
	cQuery3 += " AND JD9.JD9_CODAVA = '" + (cAlias2)->JDA_CODAVA + "' " 
	cQuery3 += " AND JD9.JD9_SUBTUR NOT IN (SELECT JDA.JDA_SUBTUR " 
	cQuery3 += "                        FROM "+RetSQLName("JDA")+" JDA "
	cQuery3 += "                        WHERE JDA.JDA_FILIAL = JD9.JD9_FILIAL "
	cQuery3 += "                        AND JDA.JDA_CODCUR = JD9.JD9_CODCUR "
	cQuery3 += "                        AND JDA.JDA_PERLET = JD9.JD9_PERLET "
	cQuery3 += "                        AND JDA.JDA_HABILI = JD9.JD9_HABILI "
	cQuery3 += "                        AND JDA.JDA_TURMA = JD9.JD9_TURMA "
	cQuery3 += "                        AND JDA.JDA_CODDIS = JD9.JD9_CODDIS "
	cQuery3 += "                        AND JDA.JDA_CODAVA = JD9.JD9_CODAVA "
	cQuery3 += "                        AND JDA.JDA_ATIVID = '" + (cAlias2)->JDA_ATIVID + "' " 
	cQuery3 += "                        AND JDA.D_E_L_E_T_ = ' ') 
	cQuery3 += " ORDER BY JD9.JD9_SUBTUR 		

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if JDA->(dbSeek(xFilial("JDA")+(cAlias2)->(JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_SUBTUR+JDA_ATIVID)))
			JDA->(RecLock("JDA",.F.))
			JDA->( dbDelete() )
			JDA->(MsUnLock())
		endif
   endif
   
   while (cAlias3)->( !eof() ) 
		if !JDA->(dbSeek(xFilial("JDA")+(cAlias2)->(JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA)+(cAlias3)->JD9_SUBTUR+(cAlias2)->JDA_ATIVID))
			if JDA->(dbSeek(xFilial("JDA")+(cAlias2)->(JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_SUBTUR+JDA_ATIVID)))
				JDA->(RecLock("JDA",.F.))
				JDA->JDA_SUBTUR := (cAlias3)->JD9_SUBTUR
				JDA->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End 
	(cAlias3)->( dbCloseArea() )	

	(cAlias2)->( dbSkip() )
end

(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111113  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JDB que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111113()
FixWindow( 111113, {|| F111113G() } )
Return

Static Function F111113G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//ATUALIZANDO JDB 
cQuery2 := " SELECT JDB_CODCUR, JDB_PERLET, JDB_HABILI, JDB_TURMA, JDB_CODDIS, JDB_CODAVA, JDB_ATIVID, JDB_SUBTUR "
cQuery2 += " FROM "+RetSQLName("JDB")+" JDB "
cQuery2 += " WHERE JDB.JDB_FILIAL = '" + xFilial("JDB") + "' "
cQuery2 += " AND JDB.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JDB.JDB_SUBTUR NOT IN (SELECT JDA.JDA_SUBTUR "
cQuery2 += "                           FROM "+RetSQLName("JDA")+" JDA "
cQuery2 += "                           WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += "                           AND JDA.D_E_L_E_T_ = ' ' "
cQuery2 += "                           AND JDA.JDA_CODCUR = JDB.JDB_CODCUR "
cQuery2 += "                           AND JDA.JDA_PERLET = JDB.JDB_PERLET "
cQuery2 += "                           AND JDA.JDA_HABILI = JDB.JDB_HABILI "
cQuery2 += "                           AND JDA.JDA_TURMA = JDB.JDB_TURMA "
cQuery2 += "                           AND JDA.JDA_CODDIS = JDB.JDB_CODDIS "
cQuery2 += "                           AND JDA.JDA_CODAVA = JDB.JDB_CODAVA "
cQuery2 += "                           AND JDA.JDA_ATIVID = JDB.JDB_ATIVID) "
cQuery2 += " ORDER BY JDB_CODCUR DESC, JDB_PERLET, JDB_HABILI, JDB_TURMA, JDB_CODDIS, JDB_CODAVA, JDB_ATIVID, JDB_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )                                      
Begin Transaction   
ProcRegua( nCount )
dbSelectArea("JDB")
JDB->(dbSetOrder(1))
while (cAlias2)->( !eof() )              
	             
	cQuery3 := " SELECT DISTINCT JDA.JDA_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JDA")+" JDA "
	cQuery3 += " WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
	cQuery3 += " AND JDA.D_E_L_E_T_ = ' ' "
	cQuery3 += " AND JDA.JDA_CODCUR = '" + (cAlias2)->JDB_CODCUR + "' " 
	cQuery3 += " AND JDA.JDA_PERLET = '" + (cAlias2)->JDB_PERLET + "' " 
	cQuery3 += " AND JDA.JDA_HABILI = '" + (cAlias2)->JDB_HABILI + "' " 
	cQuery3 += " AND JDA.JDA_TURMA = '" + (cAlias2)->JDB_TURMA + "' " 
	cQuery3 += " AND JDA.JDA_CODDIS = '" + (cAlias2)->JDB_CODDIS + "' " 
	cQuery3 += " AND JDA.JDA_CODAVA = '" + (cAlias2)->JDB_CODAVA + "' " 
	cQuery3 += " AND JDA.JDA_ATIVID = '" + (cAlias2)->JDB_ATIVID + "' " 
	cQuery3 += " AND JDA.JDA_SUBTUR NOT IN (SELECT JDB.JDB_SUBTUR " 
	cQuery3 += "                        FROM "+RetSQLName("JDB")+" JDB "
	cQuery3 += "                        WHERE JDB.JDB_FILIAL = JDA.JDA_FILIAL "
	cQuery3 += "                        AND JDB.JDB_CODCUR = JDA.JDA_CODCUR "
	cQuery3 += "                        AND JDB.JDB_PERLET = JDA.JDA_PERLET "
	cQuery3 += "                        AND JDB.JDB_HABILI = JDA.JDA_HABILI "
	cQuery3 += "                        AND JDB.JDB_TURMA = JDA.JDA_TURMA "
	cQuery3 += "                        AND JDB.JDB_CODDIS = JDA.JDA_CODDIS "
	cQuery3 += "                        AND JDB.JDB_CODAVA = JDA.JDA_CODAVA "
	cQuery3 += "                        AND JDB.JDB_ATIVID = JDA.JDA_ATIVID "
	cQuery3 += "                        AND JDB.D_E_L_E_T_ = ' ') 
	cQuery3 += " ORDER BY JDA.JDA_SUBTUR 		

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if JDB->(dbSeek(xFilial("JDB")+(cAlias2)->(JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR)))
			JDB->(RecLock("JDB",.F.))
			JDB->( dbDelete() )
			JDB->(MsUnLock())
		endif
   endif
   
   while (cAlias3)->( !eof() ) 
		if !JDB->(dbSeek(xFilial("JDB")+(cAlias2)->(JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID)+(cAlias3)->JDA_SUBTUR))		
			if JDB->(dbSeek(xFilial("JDB")+(cAlias2)->(JDB_CODCUR+JDB_PERLET+JDB_HABILI+JDB_TURMA+JDB_CODDIS+JDB_CODAVA+JDB_ATIVID+JDB_SUBTUR)))		
				JDB->(RecLock("JDB",.F.))
				JDB->JDB_SUBTUR := (cAlias3)->JDA_SUBTUR
				JDB->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End 
	(cAlias3)->( dbCloseArea() )	
	(cAlias2)->( dbSkip() )
end
(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx111114  บAutor  ณViviane Miam        บ Data ณ 19/Dez/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo Subturma da JBR que estava gravando sem   บฑฑ
ฑฑบ          ณvalidar a exist๊ncia de subturma no curso                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx111114()
FixWindow( 111114, {|| F111114G() } )
Return

Static Function F111114G()
Local cQuery2	:= ""
Local cQuery3	:= ""
Local cAlias2	:= GetNextAlias()
Local cAlias3	:= GetNextAlias()
Local nCount	:= 0

//atualizando JBR
cQuery2 := " SELECT DISTINCT JBR_CODCUR, JBR_PERLET, JBR_HABILI, JBR_TURMA, JBR_CODDIS, JBR_CODAVA, JBR_SUBTUR "
cQuery2 += " FROM "+RetSQLName("JBR")+" JBR, "+RetSQLName("JDA")+" JDA "
cQuery2 += " WHERE JBR.JBR_FILIAL = '" + xFilial("JBR") + "' "
cQuery2 += " AND JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += " AND JBR.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JDA.D_E_L_E_T_ = ' ' "
cQuery2 += " AND JBR.JBR_CODCUR = JDA.JDA_CODCUR "
cQuery2 += " AND JBR.JBR_PERLET = JDA.JDA_PERLET "
cQuery2 += " AND JBR.JBR_HABILI = JDA.JDA_HABILI "
cQuery2 += " AND JBR.JBR_TURMA = JDA.JDA_TURMA " 
cQuery2 += " AND JBR.JBR_CODDIS = JDA.JDA_CODDIS " 
cQuery2 += " AND JBR.JBR_CODAVA = JDA.JDA_CODAVA " 
cQuery2 += " AND JBR.JBR_SUBTUR NOT IN (SELECT JDA2.JDA_SUBTUR "
cQuery2 += "                           FROM "+RetSQLName("JDA")+" JDA2 "
cQuery2 += "                           WHERE JDA2.JDA_FILIAL = '" + xFilial("JDA") + "' "
cQuery2 += "                           AND JDA2.D_E_L_E_T_ = ' ' "
cQuery2 += "                           AND JDA2.JDA_CODCUR = JBR.JBR_CODCUR "
cQuery2 += "                           AND JDA2.JDA_PERLET = JBR.JBR_PERLET "
cQuery2 += "                           AND JDA2.JDA_HABILI = JBR.JBR_HABILI " 
cQuery2 += "                           AND JDA2.JDA_TURMA = JBR.JBR_TURMA "
cQuery2 += "                           AND JDA2.JDA_CODDIS = JBR.JBR_CODDIS " 
cQuery2 += "                           AND JDA2.JDA_CODAVA = JBR.JBR_CODAVA) "
cQuery2 += " ORDER BY JBR_CODCUR DESC, JBR_PERLET, JBR_HABILI, JBR_TURMA, JBR_CODDIS, JBR_CODAVA, JBR_SUBTUR "

cQuery2 := ChangeQuery( cQuery2 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )

(cAlias2)->( dbGoTop() )                                      
Begin Transaction   
ProcRegua( nCount )
dbSelectArea("JBR")
JBR->(dbSetOrder(1))
while (cAlias2)->( !eof() )              
	             
	cQuery3 := " SELECT DISTINCT JDA.JDA_SUBTUR "
	cQuery3 += " FROM  "+RetSQLName("JDA")+" JDA "
	cQuery3 += " WHERE JDA.JDA_FILIAL = '" + xFilial("JDA") + "' "
	cQuery3 += " AND JDA.D_E_L_E_T_ = ' ' "            
	cQuery3 += " AND JDA.JDA_CODCUR = '" + (cAlias2)->JBR_CODCUR + "' " 
	cQuery3 += " AND JDA.JDA_PERLET = '" + (cAlias2)->JBR_PERLET + "' " 
	cQuery3 += " AND JDA.JDA_HABILI = '" + (cAlias2)->JBR_HABILI + "' " 
	cQuery3 += " AND JDA.JDA_TURMA = '" + (cAlias2)->JBR_TURMA + "' " 
	cQuery3 += " AND JDA.JDA_CODDIS = '" + (cAlias2)->JBR_CODDIS + "' " 
	cQuery3 += " AND JDA.JDA_CODAVA = '" + (cAlias2)->JBR_CODAVA + "' " 
	cQuery3 += " AND JDA.JDA_SUBTUR NOT IN (SELECT JBR.JBR_SUBTUR " 
	cQuery3 += "                        FROM "+RetSQLName("JBR")+" JBR "
	cQuery3 += "                        WHERE JBR.JBR_FILIAL = JDA.JDA_FILIAL "
	cQuery3 += "                        AND JBR.JBR_CODCUR = JDA.JDA_CODCUR "
	cQuery3 += "                        AND JBR.JBR_PERLET = JDA.JDA_PERLET "
	cQuery3 += "                        AND JBR.JBR_HABILI = JDA.JDA_HABILI "
	cQuery3 += "                        AND JBR.JBR_TURMA = JDA.JDA_TURMA "
	cQuery3 += "                        AND JBR.JBR_CODDIS = JDA.JDA_CODDIS "
	cQuery3 += "                        AND JBR.JBR_CODAVA = JDA.JDA_CODAVA "
	cQuery3 += "                        AND JBR.D_E_L_E_T_ = ' ') 
	cQuery3 += " ORDER BY JDA.JDA_SUBTUR 		

	cQuery3 := ChangeQuery( cQuery3 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )

	(cAlias3)->( dbGoTop() )    
	
   if (cAlias3)->( eof() ) 	
		if	JBR->(dbSeek(xFilial("JBR")+(cAlias2)->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR)))   
			JBR->(RecLock("JBR",.F.))
			JBR->( dbDelete() )
			JBR->(MsUnLock())
		endif
   endif
   
   while (cAlias3)->( !eof() ) 
		if !JBR->(dbSeek(xFilial("JBR")+(cAlias2)->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA)+(cAlias3)->JDA_SUBTUR))   
			if JBR->(dbSeek(xFilial("JBR")+(cAlias2)->(JBR_CODCUR+JBR_PERLET+JBR_HABILI+JBR_TURMA+JBR_CODDIS+JBR_CODAVA+JBR_SUBTUR)))   
				JBR->(RecLock("JBR",.F.))
				JBR->JBR_SUBTUR := (cAlias3)->JDA_SUBTUR
				JBR->(MsUnLock())
			endif
		endif
		(cAlias3)->( dbSkip() )
	End 
	(cAlias3)->( dbCloseArea() )	
	(cAlias2)->( dbSkip() )
end

(cAlias2)->( dbCloseArea() )
End Transaction
dbSelectArea("JA2")

Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx102374  บAutor  ณViviane Miam        บ Data ณ 09/Jan/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorre็ใo no campo E1_VALLIQ,pois na baixa automแtica de bol-บฑฑ
ฑฑบ          ณsa pr๓pria, esse campo nใo estava sendo zerado              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx102374()
FixWindow( 102374, {|| F102374G() } )
Return

Static Function F102374G()
Local cQuery1	:= ""
Local cAlias1	:= GetNextAlias()

//atualizando SE1                                                                                               
cQuery1 := " SELECT E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO "
cQuery1 += " FROM "+RetSQLName("SE1")+" E1, "+RetSQLName("JC5")+" JC5, " +RetSQLName("JC4")+ " JC4 "
cQuery1 += " WHERE E1.E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery1 += " AND JC4.JC4_FILIAL = '" + xFilial("JBR") + "' "
cQuery1 += " AND JC5.JC5_FILIAL = '" + xFilial("JBR") + "' "
cQuery1 += " AND E1.E1_NUMRA = JC5.JC5_NUMRA "
cQuery1 += " AND JC5.JC5_TIPBOL = JC4.JC4_COD "
cQuery1 += " AND E1.E1_VALLIQ <> '0' "
cQuery1 += " AND E1.E1_STATUS = 'B' "
cQuery1 += " AND JC5.JC5_PERBOL = '100' "
cQuery1 += " AND JC4.JC4_TPCONV = '1' "
cQuery1 += " AND JC4.JC4_BAIXA = '1' "
cQuery1 += " AND E1.D_E_L_E_T_ = '' "
cQuery1 += " AND JC4.D_E_L_E_T_ = '' "
cQuery1 += " AND JC5.D_E_L_E_T_ = '' "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )

(cAlias1)->( dbGoTop() )                                      
Begin Transaction   
dbSelectArea("SE1")
SE1->(dbSetOrder(1))
while (cAlias1)->( !eof() )              
	if	SE1->(dbSeek(xFilial("SE1")+(cAlias1)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
		SE1->(RecLock("SE1",.F.))
		SE1->E1_VALLIQ = 0.0
		SE1->(MsUnLock())
	endif
	(cAlias1)->( dbSkip() )
end                            
(cAlias1)->( dbCloseArea() )
End Transaction
dbSelectArea("SE1")

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx119913  บAutor  ณEduardo de Souza    บ Data ณ 23/Fev/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a alocacao do Aluno (JC7) com dados da JBL.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx119913()
FixWindow( 119913, {|| F119913A() } )
Return

Static Function F119913A()
Local cQuery 	:= ""
Local cAlias1	:= GetNextAlias()
Local lSubTur	:= JBE->(FieldPos("JBE_SUBTUR")) > 0 .And. JC7->(FieldPos("JC7_SUBTUR"))  > 0 .And. JBL->(FieldPos("JBL_SUBTUR")) > 0

//Vinculo com aluno de grade regular
cQuery := "SELECT DISTINCT JC7.R_E_C_N_O_ REC, JBL_MATPRF, JBL_MATPR2, JBL_MATPR3, JBL_MATPR4, "
cQuery += " JBL_MATPR5, JBL_MATPR6, JBL_MATPR7, JBL_MATPR8 "

cQuery += " FROM " + RetSQLName("JC7") + " JC7, " + RetSQLName("JBE") + " JBE, "
cQuery += RetSQLName("JBK") + " JBK, " + RetSQLName("JBL")+ " JBL "

cQuery += " WHERE "

cQuery += " JC7_FILIAL     = '" + xFilial("JC7") + "' "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += " AND JBK_FILIAL = '" + xFilial("JBK") + "' "
cQuery += " AND JBL_FILIAL = '" + xFilial("JBL") + "' "

cQuery += " AND JC7_CODCUR = JBE_CODCUR "
cQuery += " AND JC7_PERLET = JBE_PERLET "
cQuery += " AND JC7_HABILI = JBE_HABILI "
cQuery += " AND JC7_TURMA  = JBE_TURMA "

If JBE->(FieldPos("JBE_SEQ")) > 0
	cQuery += " AND JC7_SEQ  = JBE_SEQ "
Endif

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBE_SUBTUR "
Endif

cQuery += " AND JBK_CODCUR = JBE_CODCUR "
cQuery += " AND JBK_PERLET = JBE_PERLET "
cQuery += " AND JBK_HABILI = JBE_HABILI "
cQuery += " AND JBK_TURMA  = JBE_TURMA "

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JBE_ANOLET = '2007' "
cQuery += " AND JBE_PERIOD = '01' "

cQuery += " AND ((JBE_ATIVO = '1' AND JBE_SITUAC = '2' ) OR  "
cQuery += " (JBE_ATIVO = '2' AND JBE_SITUAC = '1')) "

cQuery += " AND JBK_ATIVO  = '1' "

cQuery += " AND JC7_DISCIP = JBL_CODDIS "
cQuery += " AND JC7_DIASEM = JBL_DIASEM "
cQuery += " AND JC7_CODHOR = JBL_CODHOR "
cQuery += " AND JC7_HORA1  = JBL_HORA1 "
cQuery += " AND JC7_HORA2  = JBL_HORA2 "

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBL_SUBTUR "
Endif

cQuery += " AND (JC7_CODPRF <> JBL_MATPRF OR "
cQuery += " JC7_CODPR2 <> JBL_MATPR2 OR "
cQuery += " JC7_CODPR3 <> JBL_MATPR3 OR "
cQuery += " JC7_CODPR4 <> JBL_MATPR4 OR "
cQuery += " JC7_CODPR5 <> JBL_MATPR5 OR "
cQuery += " JC7_CODPR6 <> JBL_MATPR6 OR "
cQuery += " JC7_CODPR7 <> JBL_MATPR7 OR "
cQuery += " JC7_CODPR8 <> JBL_MATPR8) "

cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "

cQuery += " UNION "

//Vinculo com aluno cursando outra grade
cQuery += "SELECT DISTINCT JC7.R_E_C_N_O_ REC, JBL_MATPRF, JBL_MATPR2, JBL_MATPR3, JBL_MATPR4, "
cQuery += " JBL_MATPR5, JBL_MATPR6, JBL_MATPR7, JBL_MATPR8 "

cQuery += " FROM " + RetSQLName("JC7") + " JC7, " + RetSQLName("JBE") + " JBE, "
cQuery += RetSQLName("JBK") + " JBK, " + RetSQLName("JBL")+ " JBL "

cQuery += " WHERE "

cQuery += " JC7_FILIAL     = '" + xFilial("JC7") + "' "
cQuery += " AND JBE_FILIAL = '" + xFilial("JBE") + "' "
cQuery += " AND JBK_FILIAL = '" + xFilial("JBK") + "' "
cQuery += " AND JBL_FILIAL = '" + xFilial("JBL") + "' "

cQuery += " AND JC7_CODCUR = JBE_CODCUR "
cQuery += " AND JC7_PERLET = JBE_PERLET "
cQuery += " AND JC7_HABILI = JBE_HABILI "
cQuery += " AND JC7_TURMA  = JBE_TURMA "

If JBE->(FieldPos("JBE_SEQ")) > 0
	cQuery += " AND JC7_SEQ  = JBE_SEQ "
Endif

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBE_SUBTUR "
Endif

cQuery += " AND JBK_CODCUR = JC7_OUTCUR "
cQuery += " AND JBK_PERLET = JC7_OUTPER "
cQuery += " AND JBK_HABILI = JC7_OUTHAB "
cQuery += " AND JBK_TURMA  = JC7_OUTTUR"

cQuery += " AND JBL_CODCUR = JBK_CODCUR "
cQuery += " AND JBL_PERLET = JBK_PERLET "
cQuery += " AND JBL_HABILI = JBK_HABILI "
cQuery += " AND JBL_TURMA  = JBK_TURMA "

cQuery += " AND JBE_ANOLET = '2007' "
cQuery += " AND JBE_PERIOD = '01' "

cQuery += " AND ((JBE_ATIVO = '1' AND JBE_SITUAC = '2' ) OR  "
cQuery += " (JBE_ATIVO = '2' AND JBE_SITUAC = '1')) "

cQuery += " AND JBK_ATIVO  = '1' "

cQuery += " AND JC7_DISCIP = JBL_CODDIS "
cQuery += " AND JC7_DIASEM = JBL_DIASEM "
cQuery += " AND JC7_CODHOR = JBL_CODHOR "
cQuery += " AND JC7_HORA1  = JBL_HORA1 "
cQuery += " AND JC7_HORA2  = JBL_HORA2 "

If lSubTur
	cQuery += " AND JC7_SUBTUR  = JBL_SUBTUR "
Endif

cQuery += " AND (JC7_CODPRF <> JBL_MATPRF OR "
cQuery += " JC7_CODPR2 <> JBL_MATPR2 OR "
cQuery += " JC7_CODPR3 <> JBL_MATPR3 OR "
cQuery += " JC7_CODPR4 <> JBL_MATPR4 OR "
cQuery += " JC7_CODPR5 <> JBL_MATPR5 OR "
cQuery += " JC7_CODPR6 <> JBL_MATPR6 OR "
cQuery += " JC7_CODPR7 <> JBL_MATPR7 OR "
cQuery += " JC7_CODPR8 <> JBL_MATPR8) "

cQuery += " AND JC7.D_E_L_E_T_ = ' ' "
cQuery += " AND JBE.D_E_L_E_T_ = ' ' "
cQuery += " AND JBK.D_E_L_E_T_ = ' ' "
cQuery += " AND JBL.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias1, .F., .F. )
    
DbSelectArea("JC7")

While (cAlias1)->(!Eof())
	JC7->(DbGoto( (cAlias1)->REC ))
	If RecLock("JC7", .F.)
		JC7->JC7_CODPRF := (cAlias1)->JBL_MATPRF
		JC7->JC7_CODPR2 := (cAlias1)->JBL_MATPR2
		JC7->JC7_CODPR3 := (cAlias1)->JBL_MATPR3
		JC7->JC7_CODPR4 := (cAlias1)->JBL_MATPR4
		JC7->JC7_CODPR5 := (cAlias1)->JBL_MATPR5
		JC7->JC7_CODPR6 := (cAlias1)->JBL_MATPR6
		JC7->JC7_CODPR7 := (cAlias1)->JBL_MATPR7
		JC7->JC7_CODPR8 := (cAlias1)->JBL_MATPR8
		JC7->(MsUnlock())												
		AcaLog(cLogFile, "JC7 ALTERADA : " + AllTrim(Str(JC7->(RECNO()))))
	Else
		AcaLog(cLogFile, "** JC7 NAO PODE SER ALTERADA : " + AllTrim(Str(JC7->(RECNO()))))	
	Endif
   (cAlias1)->(DbSkip())
End

(cAlias1)->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx101821  บAutor  ณViviane Miam        บ Data ณ 02/Mar/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste nas tabelas JBL e JDA para preenchimento dos campos  บฑฑ
ฑฑบ          ณITEM e MATPRF, referente เ melhoria de apont. de faltas.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Fx101821()
FixWindow( 101821, {|| F101821G() } )
Return

Static Function F101821G()
Local cQuery1, cQuery2, cQuery3, cQuery4 := ""
Local cAlias1 := GetNextAlias()
Local cAlias2 := ""
Local cAlias3 := ""
Local cAlias4 := ""
Local lSubTurma := JD2->(FieldPos("JD2_SUBTUR")) > 0

//atualizando JCG       
cQuery1 := " SELECT JCG.JCG_CODCUR, JCG.JCG_PERLET, JCG.JCG_HABILI, JCG.JCG_TURMA, JCG.JCG_DATA, JCG.JCG_ITEM, "
cQuery1 += " JCG.JCG_DISCIP, JCG.JCG_CODAVA, JCG.JCG_MATPRF "
if lSubTurma
	cQuery1 += ", JCG.JCG_SUBTUR "
endif
cQuery1 += " FROM "+RetSQLName("JCG")+" JCG "
cQuery1 += " WHERE JCG.JCG_FILIAL = '" + xFilial("JCG") + "' "
cQuery1 += " AND ((JCG.JCG_ITEM = ''  "
cQuery1 += " AND JCG.JCG_TIPO = '1')  "
cQuery1 += " OR JCG.JCG_MATPRF = '') "
cQuery1 += " AND JCG.D_E_L_E_T_ = '' "

cQuery1 := ChangeQuery( cQuery1 )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery1), cAlias1, .F., .F. )
(cAlias1)->( dbGoTop() )

dbSelectArea("JCG")
JCG->(dbSetOrder(1))
JCH->(dbSetOrder(1))
JAH->(dbSetOrder( 1 ))
JAF->(dbSetOrder( 1 ))

while (cAlias1)->( !eof() )              
	nItem := ""
	nMatprf := ""
	JAH->(dbSeek( xFilial("JAH")+ (cAlias1)->JCG_CODCUR ))
	JAF->(dbSeek( xFilial("JAF") + JAH->(JAH_CURSO + JAH_VERSAO)))
    if JAF->JAF_TIPGRD == "2"           
		cQuery2 := " SELECT JD2.JD2_CODCUR, JD2.JD2_PERLET, JD2.JD2_HABILI,JD2.JD2_TURMA, JD2.JD2_CODDIS, "
		cQuery2 += " JD2.JD2_DATA, JD2.JD2_DIASEM, JD2.JD2_AULA, JD2.JD2_MATPRF  "
		if lSubTurma
			cQuery2 += ", JCG.JCG_SUBTUR "
		endif
		cQuery2 += " FROM "+RetSQLName("JD2")+" JD2 "
		cQuery2 += " WHERE JD2.JD2_FILIAL = '" + xFilial("JD2") + "' "
		cQuery2 += " AND JD2.JD2_CODCUR = '" + (cAlias1)->JCG_CODCUR + "' "
		cQuery2 += " AND JD2.JD2_PERLET = '" + (cAlias1)->JCG_PERLET + "' "
		cQuery2 += " AND JD2.JD2_HABILI = '" + (cAlias1)->JCG_HABILI + "' "
		cQuery2 += " AND JD2.JD2_TURMA = '" + (cAlias1)->JCG_TURMA + "' "
		cQuery2 += " AND JD2.JD2_CODDIS = '" + (cAlias1)->JCG_DISCIP + "' "
		cQuery2 += " AND JD2.JD2_DATA = '" + (cAlias1)->JCG_DATA + "' "
		cQuery2 += " AND JD2.JD2_DIASEM = '" + str(Dow(stod((cAlias1)->JCG_DATA)),1) + "' "
		if lSubTurma
			cQuery2 += " AND JD2.JD2_SUBTUR = '" + (cAlias1)->JCG_SUBTURMA + "' "
		endif
		cQuery2 += " AND JD2.D_E_L_E_T_ = '' "
		cQuery2 += " ORDER BY JD2.JD2_ITEM, JD2.JD2_AULA "		
		
		cQuery2 := ChangeQuery( cQuery2 )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery2), cAlias2, .F., .F. )
		(cAlias2)->( dbGoTop() )                                      
    	While (cAlias2)->( !eof() )              
    		if JCG->(dbSeek(xFilial("JCG")+(cAlias2)->(JD2_CODCUR+JD2_PERLET+JD2_HABILI+JD2_TURMA+JD2_DATA+JD2_AULA+JD2_DISCIP)+(cAlias1)->(JCG_CODAVA+if(lSubturma, JCG_SUBTUR, ""))+(cAlias2)->(JD2_MATPRF)))
				(cAlias2)->(dbSkip())	
			else
				if JCG->(dbSeek(xFilial("JCG")+(cAlias1)->(JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+JCG_DATA+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+if(lSubturma, JCG_SUBTUR, "")+JCG_MATPRF)))			
					JCG->(RecLock("JCG",.F.)) 
					if (alltrim(JCG->JCG_ITEM) == "" ) .and. (JCG->JCG_TIPO == "1")
						IF (alltrim(JCG->JCG_MATPRF) <> "" .and. alltrim(JCG->JCG_MATPRF) == alltrim((cAlias2)->JD2_MATPRF)) .or. alltrim(JCG->JCG_MATPRF) == ""
							JCG->JCG_ITEM 	:= (cAlias2)->JD2_ITEM
							nItem := (cAlias2)->JBL_ITEM
						endif
					endif                 
					if (alltrim(JCG->JCG_MATPRF) == "") 
						if (alltrim(JCG->JCG_ITEM) <> "" .and. alltrim(JCG->JCG_ITEM) == alltrim((cAlias2)->JD2_ITEM)) .or. alltrim(JCG->JCG_ITEM) == ""
							JCG->JCG_MATPRF := (cAlias2)->JD2_MATPRF
							nMatprf := (cAlias2)->JD2_MATPRF						
						endif
					endif
					JCG->(MsUnLock())
				endif
			endif    
			(cAlias2)->(dbSkip())
		end            
		(cAlias2)->( dbCloseArea() )		
    else
		cQuery3 := " SELECT JBL.JBL_CODCUR, JBL.JBL_PERLET, JBL.JBL_HABILI,JBL.JBL_TURMA, JBL.JBL_CODDIS, "
		cQuery3 += " JBL.JBL_DIASEM, JBL.JBL_MATPRF, JBL.JBL_ITEM  "
		if lSubTurma
			cQuery3 += ", JBL.JBL_SUBTUR "
		endif
		cQuery3 += " FROM "+RetSQLName("JBL")+" JBL "
		cQuery3 += " WHERE JBL.JBL_FILIAL = '" + xFilial("JD2") + "' "
		cQuery3 += " AND JBL.JBL_CODCUR = '" + (cAlias1)->JCG_CODCUR + "' "
		cQuery3 += " AND JBL.JBL_PERLET = '" + (cAlias1)->JCG_PERLET + "' "
		cQuery3 += " AND JBL.JBL_HABILI = '" + (cAlias1)->JCG_HABILI + "' "
		cQuery3 += " AND JBL.JBL_TURMA = '" + (cAlias1)->JCG_TURMA + "' "
		cQuery3 += " AND JBL.JBL_CODDIS = '" + (cAlias1)->JCG_DISCIP + "' "
		cQuery3 += " AND JBL.JBL_DIASEM = '" + str(Dow(stod((cAlias1)->JCG_DATA)),1) + "' "
		if lSubTurma
			cQuery3 += " AND JBL.JBL_SUBTUR = '" + (cAlias1)->JCG_SUBTURMA + "' "
		endif
		cQuery3 += " AND JBL.D_E_L_E_T_ = '' "
		cQuery3 += " ORDER BY JBL.JBL_ITEM "		
		
		cQuery3 := ChangeQuery( cQuery3 )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery3), cAlias3, .F., .F. )
		(cAlias3)->( dbGoTop() )                                      		
    	While (cAlias3)->( !eof() )              
    		if JCG->(dbSeek(xFilial("JCG")+(cAlias3)->(JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA)+(cAlias1)->(JCG_DATA)+(cAlias3)->(JBL_ITEM+JBL_CODDIS)+(cAlias1)->(JCG_CODAVA)+if(lSubturma, (cAlias1)->JCG_SUBTUR, "")+(cAlias3)->JBL_MATPRF))
				(cAlias3)->(dbSkip())	
			else
				if JCG->(dbSeek(xFilial("JCG")+(cAlias1)->(JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+JCG_DATA+JCG_ITEM+JCG_DISCIP+JCG_CODAVA)+if(lSubturma, (cAlias1)->JCG_SUBTUR, "")+(cAlias1)->JCG_MATPRF))			
					JCG->(RecLock("JCG",.F.)) 
					if (alltrim(JCG->JCG_ITEM) == "" ) .and. (JCG->JCG_TIPO == "1")
						IF (alltrim(JCG->JCG_MATPRF) <> "" .and. alltrim(JCG->JCG_MATPRF) == alltrim((cAlias3)->JBL_MATPRF)) .or. alltrim(JCG->JCG_MATPRF) == ""
							JCG->JCG_ITEM 	:= (cAlias3)->JBL_ITEM
							nItem := (cAlias3)->JBL_ITEM
						endif
					endif                 
					if (alltrim(JCG->JCG_MATPRF) == "") 
						if (alltrim(JCG->JCG_ITEM) <> "" .and. alltrim(JCG->JCG_ITEM) == alltrim((cAlias3)->JBL_ITEM)) .or. alltrim(JCG->JCG_ITEM) == ""
							JCG->JCG_MATPRF := (cAlias3)->JBL_MATPRF
							nMatprf := (cAlias3)->JBL_MATPRF						
						endif
					endif
					JCG->(MsUnLock())
				endif
			endif    
			(cAlias3)->(dbSkip())
		end
		(cAlias3)->( dbCloseArea() )    
    endif
    
	//atualizando JCH
	cQuery4 := " SELECT JCH.JCH_CODCUR, JCH.JCH_PERLET, JCH.JCH_HABILI, JCH.JCH_TURMA, JCH.JCH_DATA, JCH.JCH_ITEM, "
	cQuery4 += " JCH.JCH_DISCIP, JCH.JCH_CODAVA, JCH.JCH_MATPRF, JCH.JCH_NUMRA "
	cQuery4 += " FROM "+RetSQLName("JCH")+" JCH "
	cQuery4 += " WHERE JCH.JCH_FILIAL = '" + xFilial("JCH") + "' "
	cQuery4 += " AND JCH.JCH_ITEM = '' "
	cQuery4 += " AND JCH.JCH_MATPRF = '' "
	cQuery4 += " AND JCH.JCH_CODCUR = '" + (cAlias1)->JCG_CODCUR + "' "
	cQuery4 += " AND JCH.JCH_PERLET = '" + (cAlias1)->JCG_PERLET + "' "
	cQuery4 += " AND JCH.JCH_HABILI = '" + (cAlias1)->JCG_HABILI + "' "
	cQuery4 += " AND JCH.JCH_TURMA = '" + (cAlias1)->JCG_TURMA + "' "
	cQuery4 += " AND JCH.JCH_DISCIP = '" + (cAlias1)->JCG_DISCIP + "' "
	cQuery4 += " AND JCH.JCH_CODAVA = '" + (cAlias1)->JCG_CODAVA + "' "	
	cQuery4 += " AND JCH.JCH_DATA = '" + (cAlias1)->JCG_DATA + "' "
	cQuery4 += " AND JCH.D_E_L_E_T_ = '' "
	
	cQuery4 := ChangeQuery( cQuery4 )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery4), cAlias4, .F., .F. )
	While (cAlias4)->( !eof() )              
		if JCH->(dbSeek(xFilial("JCH")+(cAlias4)->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DATA)+nItem+(cAlias4)->(JCH_DISCIP+JCH_CODAVA)+nMatprf))
			(cAlias4)->(dbSkip())	
		else
			JCH->(dbSeek(xFilial("JCH")+(cAlias4)->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DATA+JCH_ITEM+JCH_DISCIP+JCH_CODAVA+JCH_MATPRF)))			
			JCH->(RecLock("JCH",.F.))  
			if alltrim(nItem) <> ""
				JCH->JCH_ITEM 	:= nItem
			endif
			if alltrim(nMatprf) <> ""
				JCH->JCH_MATPRF := nMatprf
			endif
			JCH->(MsUnLock())
		endif    
		(cAlias4)->(dbSkip())
	end
	(cAlias4)->( dbCloseArea() )
	(cAlias1)->( dbSkip() )
end                            
(cAlias1)->( dbCloseArea() )

dbSelectArea("JCG")
Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFx120699  บAutor  ณCristina Santana Souza                             บ Data ณ 06/Mar/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjuste na tabela JBI para gravar a data e hora de saida (JBI_DTSAI e JBI_HRSAI) do         บฑฑ
ฑฑบ          ณsegundo passo do requerimento (Ordem 02), que no ambiente de producao do cliente			 บฑฑ
ฑฑบ          ณencontra-se deferido (JBI_STATUS = 1 - Deferido), mas sem a data e hora de saida gravados. บฑฑ
ฑฑบ          ณ																							 บฑฑ
ฑฑบ          ณA mesma data e hora serao gravadas na data e hora de entrada (JBI_DTENT e JBI_HRENT)       บฑฑ
ฑฑบ          ณdo item seguinte (Ordem 03) que esta com  a JBI_STATUS = 3 (Pendente).					 บฑฑ
ฑฑบ          ณ																						     บฑฑ
ฑฑบ          ณO tratamento sera efetuado apenas para Filial 04 - Campinas								 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAjuste de base de dados                                    								 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Fx120699()

FixWindow( 120699, {|| F120699G() } )
Return

Static Function F120699G()

Local cQuery := ""
Local cAlias := GetNextAlias()
Local dDataReq := dDataBase
Local dHoraReq := Time()

dbSelectArea("JBI")

//Soh atualiza para a filial 04 - Campinas
if xFilial("JBI") <> "04"
	Return
endif

cQuery := " SELECT JBI_NUM, JBI_ORDEM, JBI.R_E_C_N_O_ JBIREC FROM " +RetSQLName("JBI")+ " JBI "
cQuery += " WHERE JBI_FILIAL = '04' "
cQuery += " AND JBI_STATUS = '1'  "   //(1=Deferido;2=ndeferido;3=Pendente;4=Atrasado)
cQuery += " AND JBI_DTSAI  = ' '  "
cQuery += " AND JBI_ORDEM  = '02' "
cQuery += " AND JBI_NUM IN ( '000497', '000498', '000499', '000500', '000501', '000502', '000503', '000504', '000505', '000506', '000507') "
cQuery += " AND JBI.D_E_L_E_T_ = ' ' "

cQuery += " UNION "

cQuery += " SELECT JBI_NUM, JBI_ORDEM, JBI.R_E_C_N_O_ JBIREC FROM " +RetSQLName("JBI")+ " JBI "
cQuery += " WHERE JBI_FILIAL = '04' "
cQuery += " AND JBI_STATUS = '3' "   //(1=Deferido;2=ndeferido;3=Pendente;4=Atrasado)
cQuery += " AND JBI_DTENT  = ' '  "
cQuery += " AND JBI_ORDEM  = '03' "
cQuery += " AND JBI_NUM IN ( '000497', '000498', '000499', '000500', '000501', '000502', '000503', '000504', '000505', '000506', '000507') "
cQuery += " AND JBI.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY JBI_NUM, JBIREC  "  

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

Begin Transaction

dbSelectArea("JBI")

AcaLog(cLogFile, "Inํcio do processamento..." + Dtoc( date() )+" "+Time())
AcaLog(cLogFile, "Atualizando tabela JBI..." )

While (cAlias)->( !eof() )              
  
	JBI->( dbGoTo( (cAlias)->JBIREC ) )
	
	If (cAlias)->JBI_ORDEM = '02'
		RecLock("JBI", .F.)    
		JBI->JBI_DTSAI := dDataReq
		JBI->JBI_HRSAI := dHoraReq
		JBI->( MsUnLock() )
		AcaLog(cLogFile, "Atualizado protocolo: " + (cAlias)->JBI_NUM + " Ordem: " + (cAlias)->JBI_ORDEM )
	Else
		RecLock("JBI", .F.)
		JBI->JBI_DTENT := dDataReq
		JBI->JBI_HRENT := dHoraReq
		JBI->( MsUnLock() )
		AcaLog(cLogFile, "Atualizado protocolo: " + (cAlias)->JBI_NUM + " Ordem: " + (cAlias)->JBI_ORDEM )
	Endif
                  
	(cAlias)->( dbSkip() )

Enddo

AcaLog(cLogFile, "Final do processamento..." + Dtoc( date() )+" "+Time())
          
(cAlias)->(dbCloseArea())

End Transaction

dbSelectArea("JA2")
                   
Return

