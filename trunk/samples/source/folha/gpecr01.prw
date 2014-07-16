#Include 'GPECR01.CH'

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Funcao    � GPECR010 � Autor � Advanced RH              � Data � 17/05/01 ���
�����������������������������������������������������������������������������Ĵ��
��� Descricao � Calculo de dissidio retroativo.							      ���
�����������������������������������������������������������������������������Ĵ��
��� Sintaxe   � GPECR010()													  ���
�����������������������������������������������������������������������������Ĵ��
��� Uso       � Especifico.													  ���
�����������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.				  ���
�����������������������������������������������������������������������������Ĵ��
��� Programador � Data   � BOPS �             Motivo da alteracao             ���
�����������������������������������������������������������������������������Ĵ��
��� Desenv-RH   �19/07/01�------�Colocar parametros: filial, centro de custo, ���
���-------------�--------�------�matricula e nome (De/Ate) na rotina  de  im- ���
���-------------�--------�------�pressao e gravacao. Verificar  totalizadores ���
���-------------�--------�------�na rotina de impressao e posicionar resgistro���
���-------------�--------�------�original no browse apos impressao e gravacao ���
���Emerson      �25/09/01�------�Verificar se o arquivo do dissidio criado em ���
���             �        �------�disco esta de acordo com a nova estrutura.   ���
���Priscila     �09/01/03�------�Alteracao p/ filtrar os dados na Geracao de  ���
���             �        �------�acordo com os parametros selecionados.       ���
���Andreia      �25/07/03�------�Alteracao para calcular as diferencas das ver���
���             �        �------�bas fazendo o recalculo da folha, a partir   ���
���             �        �------�dos arquivos de fechamento, e atualizando o  ���
���             �        �------�historico salarial na geracao dos lancamentos���
���             �        �------�futuros, valores mensais ou valores extras.  ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������*/
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/09/00

User Function GPECR01()

//���������������������������������������������������������������������������
//� Inicializa variaveis de execucao.										�
//���������������������������������������������������������������������������
Local cArqDbf	:= 'DISSRETR' + GetDBExtension()
Local cArqNtx	:= 'DISSRETR' + OrdBagExt()
Local cIndCond	:= 'TRB_FILIAL + TRB_MAT + Substr( TRB_DATA, 3, 4 ) + Substr( TRB_DATA, 1, 2 )+TRB_VB '
Local aTamCC	:= TAMSX3("RA_CC")
Local aFields	:= {	{ 'TRB_FILIAL', 'C', 02, 0 },;
						{ 'TRB_MAT'   , 'C', 06, 0 },;
						{ 'TRB_VB'    , 'C', 03, 0 },;
						{ 'TRB_CC'    , 'C', aTamCC[1], 0 },;
						{ 'TRB_VL'    , 'N', 12, 2 },;
						{ 'TRB_DATA'  , 'C', 06, 0 },;
						{ 'TRB_VERBA' , 'C', 03, 0 },;
						{ 'TRB_CALC'  , 'N', 12, 2 },;
						{ 'TRB_VALOR' , 'N', 12, 2 },; 
						{ 'TRB_INDICE', 'N', 08, 2 },;
						{ 'TRB_VLRAUM', 'N', 12, 2 },;
						{ 'TRB_TPOAUM', 'C', 03, 0 },;
						{ 'TRB_COMPL_', 'C', 01, 0 }}

Private aRotina := { 	{ STR0001, 'AxPesqui'     , 0, 1 },; 	// Pesquisar
						{ STR0002, 'U_RCALC'	  , 0, 4 },; 	// Calculo   
						{ STR0003, 'U_GPECRVis()' , 0, 2 },; 	// Visualiza
						{ STR0004, 'U_GPECRImp()' , 0, 4 },; 	// Relatorio
						{ STR0005, 'U_GPECRGrv()' , 0, 4 } } 	// Gravar
						                                                 
Private cCadastro	:= OemToAnsi( STR0006 )

Private bFiltraBrw := {|| Nil}      //Variavel para Filtro

//�������������������������������������������������������������������������Ŀ
//� Verifica se o arquivo esta vazio.										�
//���������������������������������������������������������������������������
If !ChkVazio( 'SRA' )
	Return
Endif

//�������������������������������������������������������������������������Ŀ
//� Cria arquivo de trabalho se necessario.									�
//���������������������������������������������������������������������������
If !File( cArqDbf )
	DbCreate( cArqDbf, aFields )
EndIf
DbUseArea( .T., , cArqDbf, 'TRB', .F. )
If FieldPos('TRB_FILIAL') == 0 .or. FieldPos('TRB_VLRAUM') == 0 .or. ;
   FieldPos('TRB_TPOAUM') == 0 .or. FieldPos('TRB_CC') == 0 .or. FieldPos('TRB_COMPL_')== 0
	dbCloseArea()
	fErase(cArqDbf)
	fErase(cArqNtx)
	DbCreate( cArqDbf, aFields )
	DbUseArea( .T., , cArqDbf, 'TRB', .F. )
Endif
If !File( cArqNtx )
	IndRegua( 'TRB', cArqNtx, cIndCond,,, STR0007 ) 
Else 
	Set Index To (cArqNtx)
Endif

//�������������������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE.											�
//���������������������������������������������������������������������������
dbSelectArea( 'SRA' )
mBrowse( 06, 01, 22, 75, 'SRA',,,,'SRA->RA_SITFOLH#"D"')
dbSelectArea( 'TRB' )
dbCloseArea()
Return
                                     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao RCalc() - Faz a verificacao de calculo.             ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
USER FUNCTION RCALC

Local aSalva 	:= GetArea()	// Area atual
Local aSays		:= {}			// Matriz de tela
Local aButtons	:= {}			// Matriz de botoes
Local nOpca		:= 0			// Opcao escolhida

Private cPerg := 'GPCR01'
            
//�������������������������������������������������������������������������Ŀ
//� Verifica cadastro de verbas.											�
//���������������������������������������������������������������������������
dbSelectArea( 'SRV' )
dbGoTop()
Do While !Eof()
	If SRV->RV_COMPL_ = 'S' .and. Empty( SRV->RV_CODCOM_ )
		Aviso( STR0019, STR0050, { STR0021 } )
		RestArea(aSalva)
		Return
	Endif
	Skip
Enddo

//�������������������������������������������������������������������������Ŀ
//� Carrega parametros.														�
//���������������������������������������������������������������������������
Pergunte( cPerg, .f. )

//�������������������������������������������������������������������������Ŀ
//� Monta tela de dialogo.													�
//���������������������������������������������������������������������������
Aadd( aSays, OemToAnsi( STR0051 ) )
	
AADD( aButtons, { 5, .T., { |o| Pergunte( cPerg, .t. ) } } )
AADD( aButtons, { 1, .T., { |o| nOpca := 1, If( GPECROk(), FechaBatch(), nOpca :=0 ) } } )
AADD( aButtons, { 2, .T., { |o| FechaBatch() } } )

FormBatch( cCadastro, aSays, aButtons )	

If nOpca = 1
	//�������������������������������������������������������������������������Ŀ
	//� Verifica se o calculo ja foi efetuado.									�
	//���������������������������������������������������������������������������
	dbSelectArea( 'TRB' )
	If LastRec() > 0
		If Aviso( STR0019, STR0043, { STR0044, STR0045 } ) = 2
			RestArea(aSalva)
			Return
		Endif
	Endif
	ProcGpe( {|lEnd| U_GPECRCal()},,,.t. )
Endif

RestArea(aSalva)
Return             

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do dissidio retroativo                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function GPECRCal()

//�������������������������������������������������������������������������Ŀ
//� Declara variaveis locais de trabalho.									�
//���������������������������������������������������������������������������
Local aMes	:= { 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez' }

Local cFilDe  	:= mv_par04
Local cFilAte 	:= mv_par05
Local cCcDe		:= mv_par06
Local cCcAte	:= mv_par07
Local cMatDe	:= mv_par08 
Local cMatAte	:= mv_par09 
Local cCategoria:= mv_par13
Local nCriterio := mv_par16
Local nArredonda:= mv_par17
Local cMesAnoDe
Local cMesAnoAte
Local nParcela
Local nIndReaj
Local cMesCabec
Local cInicio
Local cFim
Local cFilAnt
Local nPercDif 	:= 0
Local nValAum  	:= 0
Local cDatArq  	:= ""
Local aMeses	:= {}	 
Local aParametros := array(14)
Local nI		:= 0
Local aPercDif	:= {}             

Private cSindicato	:= Iif( Empty( mv_par15 ), '99', mv_par15 ) 
Private cNomeDe		:= mv_par10 
Private cNomeAte	:= mv_par11 
Private cSituacao	:= mv_par12
Private cTipoAum	:= mv_par14
Private aHeader		:= {}
Private aTELA		:= { 0, 0 }
Private aGETS		:= { 0 }
Private nUsado		:= 0
Private aCols		:= { {} }
Private nLinGetD	:= 0
Private cTitPerc	:= STR0008
Private aC			:= {}
Private aR			:= {}
Private aCGD		:= { 044, 005, 118, 315 }
Private cExclui		:= ''
Private aFaixas		:= {}
Private aCodFol		:= {}
Private lAbortPrint := .F.
                  
//�������������������������������������������������������������������������Ŀ
//� Ajusta variaveis de trabalho.											�
//���������������������������������������������������������������������������
cMesCabec	:= If( Empty( mv_par01 ), StrZero( Year( dDataBase ), 4, 0 ) + StrZero( Month( dDataBase ), 2, 0 ), SubStr( mv_par01, 3, 4 ) + SubStr( mv_par01, 1, 2 ) )
cMesAnoDe	:= If( Empty( mv_par01 ), StrZero( Year( dDataBase ), 4, 0 ) + StrZero( Month( dDataBase ), 2, 0 ), SubStr( mv_par01, 3, 4 ) + SubStr( mv_par01, 1, 2 ) )
cMesAnoAte	:= If( Empty( mv_par02 ), StrZero( Year( dDataBase ), 4, 0 ) + StrZero( Month( dDataBase ), 2, 0 ), SubStr( mv_par02, 3, 4 ) + SubStr( mv_par02, 1, 2 ) )
nIndReaj	:= If( Empty( mv_par03 ), 2, mv_par03 )

cExclui := cExclui + '{ || '
cExclui := cExclui + '( RA_FILIAL < cFilDe .or. RA_FILIAL > cFilAte ) .or. '
cExclui := cExclui + '( RA_MAT < cMatDe .or. RA_MAT > cMatAte ) .or. ' 
cExclui := cExclui + '( RA_CC < cCcDe .or. RA_CC > cCCAte ) .or. ' 
cExclui := cExclui + '( RA_NOME < cNomeDe .or. RA_NOME > cNomeAte ) .or. ' 
cExclui := cExclui + '!( RA_SITFOLH$cSituacao ) .or. !( RA_CATFUNC$cCategoria )'
cExclui := cExclui + ' } '

//���������������������������������������������������������������������������
//� Monta tabela de reajuste.												�
//���������������������������������������������������������������������������
Aadd( aHeader, { STR0009, 'SALDE' , '@E 999,999,999,999.99', 15, 2, 'positivo()', '�', 'N', '  ', ' ' } )	//'Faixa De'
Aadd( aHeader, { STR0010, 'SALATE', '@E 999,999,999,999.99', 15, 2, 'positivo()', '�', 'N', '  ', ' ' } )	//'Faixa Ate'
Aadd( aHeader, { STR0052, 'VALFIX', '@E 999,999,999,999.99', 15, 2, 'positivo()', '�', 'N', '  ', ' ' } )	//'Valor Aumento'
If nIndReaj =2
    Aadd( aHeader, { STR0011, 'SALPERC', '@E 999.999999'       , 10, 6, 'positivo()', '�', 'N', '  ', ' ' } )	//'% Aumento'
Else         
    Do While .t.
		Aadd( aHeader, { '( % )  ' + aMes[ Val( Right( cMesCabec, 2 ) ) ] + '/' + Left( cMesCabec, 4 ), 'SALPERC'+cMesCabec, '@E 999.999999'       , 10, 6, 'positivo()', '�', 'N', '  ', ' ' } )	//'% Aumento'
		If cMesCabec = cMesAnoAte
			Exit
		Endif
		If Right( cMesCabec, 2 ) = '12'
			cMesCabec := StrZero( Val( Left( cMesCabec, 4 ) ) + 1, 4, 0 ) + '01'
		Else
			cMesCabec := Left( cMesCabec, 4 ) + StrZero( Val( Right( cMesCabec, 2 ) ) + 1, 2, 0 ) 
		Endif
    Enddo
Endif    

For nI := 1 To Len( aHeader )
	Aadd( aCols[1], 0 )
Next                   
Aadd( aCols[1], .f. )
aCols[1, 1]	:= 0.01
nUsado 		:= Len( aCols[1] )

//�������������������������������������������������������������������������Ŀ
//� Verifica se digitou tabela de reajuste e atualiza matriz de calculo.	�
//���������������������������������������������������������������������������
If !( lRetMod2 := Modelo2( cTitPerc, aC, aR, aCGD, 3, 'U_ChkTabela()' ) )
	Return
ElseIf Len( Acols ) = 0
	Return
Endif	
For nI := 1 To Len( aCols )
	If aCols[nI, nUsado] == .F.
		Aadd( aFaixas, aCols[nI] )
	Endif
Next 

//�������������������������������������������������������������������������Ŀ
//� Prepara arquivo de trabalho.											�
//���������������������������������������������������������������������������
dbSelectArea( 'TRB' )
Zap

//�������������������������������������������������������������������������Ŀ
//� Posiciona ponteiros do arquivo SRA.										�
//���������������������������������������������������������������������������
dbSelectArea( 'SRA' )
dbSetOrder( 1 )
dbSeek( cFilDe + cMatDe, .T. )
cInicio := '{ || RA_FILIAL + RA_MAT }'
cFim    := cFilAte + cMatAte
cFilAnte:= "!!"
aCodFol	:= {}

GPProcRegua( SRA->( RecCount() ) )

Do While !Eof() .And.  Eval( &( cInicio ) ) <= cFim

	//�������������������������������������������������������������������������Ŀ
	//� Verifica exclusao de registro conforme parametros.						�
	//���������������������������������������������������������������������������
	If SRA->( Eval ( &( cExclui ) ) )
		dbSelectArea( 'SRA' )
		dbSkip()
		Loop
	Elseif cSindicato # '99'
		If sra->ra_sindica # cSindicato
			dbSkip()
			Loop
		Endif
	Endif

	If SRA->RA_FILIAL # cFilAnte
		aCodFol	:= {}
		cFilAnte:= SRA->RA_FILIAL
		Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
		If empty( aCodFol[337,1]) .or. empty( aCodFol[338,1]) .or. empty( aCodFol[339,1]) .or. empty( aCodFol[340,1])
			Aviso(STR0019,STR0023 + SRA->RA_FILIAL+STR0056,{"OK"}) //"Atencao"##"Filial "###" - Cadastre os identificadores de Calculo 337 a 340"
			While SRA->( !Eof()) .and. SRA->RA_FILIAL == cFilAnte
				SRA->( dbSkip())
			EndDo	
			dbSelectArea("SRV") // se o cadastro de verbas for compartilhado nao precisa checar as outras filiais
			If cFilial == '  ' 
				dbSelectArea( 'SRA' )
				Return
			Else
				Loop
			EndIf	
		EndIf	
	EndIf
	//�������������������������������������������������������������������������Ŀ
	//� Atualiza exibicao da regua de visualizacao.								�
	//���������������������������������������������������������������������������
	GPIncProc( SRA->RA_FILIAL + ' - ' + SRA->RA_MAT + ' - ' + SRA->RA_NOME )

	//�������������������������������������������������������������������������Ŀ
	//� Pesquisa Salario Anterior no SR3, Se nao achar utiliza salario atual.	�
	//���������������������������������������������������������������������������
	nPercDif 	:= 0
	nValAum		:= 0
    nSalario 	:= SRA->RA_SALARIO
    nNovoSal	:= 0
    
          
	cDatArq := cMesAnoDe
	While .t.

		dbSelectArea( 'SR3' )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cDatarq,.T. )
		   	While SR3->(!EOF()) 
			   If SRA->RA_FILIAL + SRA->RA_MAT == SR3->R3_FILIAL + SR3->R3_MAT .and. SR3->R3_TIPO == '000';
			   		.AND. MesAno( SR3->R3_DATA ) == cDatarq
			      nSalario := SR3->R3_VALOR
			   Endif
			   SR3->(dbskip())
			EndDo			   
		Endif

		Indice( aFaixas, nSalario, nIndreaj, cDatArq, aHeader,@nPercDif,@nValAum )

		nNovoSal	:= nSalario * (1+ (nPercDif/100))
		nNovoSal    += nValAum
    
	    If nCriterio == 1
			nNovoSal := NoRound(nNovoSal)
		ElseIf nCriterio == 2
			nNovoSal := Round(nNovoSal,2)
		Else				
			If nNovoSal - Round(nNovoSal,2) > 0.00
				nNovoSal := NoRound((nNovoSal + .01),2)
			Else
				nNovoSal := Round(nNovoSal,2)
			Endif
		EndIf

		If nArredonda # 0
			nValArre := 0
			Calc_Arre(@nNovoSal,nArredonda, nValArre)
		Endif			
	
		If Ascan( aPercDif, {|x| x[1] == SRA->RA_FILIAL+SRA->RA_MAT+cDatarq}) == 0
			Aadd( aPercDif,{SRA->RA_FILIAL+SRA->RA_MAT+cDatarq,nPercDif, nValAum})
		EndIF	
		//��������������������������������������������������������������Ŀ
		//� Atualizando SR3 - Alteracao Salarial                         �
		//����������������������������������������������������������������
		dbSelectArea( "TRB" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + substr(cDatarq,5,2)+substr(cDatarq,1,4)+"000")
			RecLock("TRB",.F.,.T.)
		Else
			RecLock("TRB",.T.,.T.)
		Endif

		TRB->TRB_FILIAL	:= SRA->RA_FILIAL
		TRB->TRB_MAT	:= SRA->RA_MAT
		TRB->TRB_VB		:= "000"
		TRB->TRB_DATA	:= substr(cDatArq,5,2)+substr(cDatArq,1,4)
		TRB->TRB_VERBA	:= ""
		TRB->TRB_VL		:= nSalario
		TRB->TRB_CALC	:= nNovoSal
		TRB->TRB_VALOR	:= TRB->TRB_CALC - TRB->TRB_VL
		TRB->TRB_INDICE	:= nPercDif
		TRB->TRB_VLRAUM	:= nValAum
		TRB->TRB_TPOAUM	:= cTipoAum 
		TRB->TRB_COMPL_	:= "N"
		MsUnLock()

		If Ascan( aMeses, ctod("01	/"+substr(cDatArq,5,2)+"/"+substr(cDatArq,1,4) )) == 0
			Aadd( aMeses, ctod("01	/"+substr(cDatArq,5,2)+"/"+substr(cDatArq,1,4) ))
    	EndIf
    	
		If Right( cDatArq, 2 ) = '12'
			cDatarq := StrZero( Val( Left( cDatarq, 4 ) ) + 1, 4, 0 ) + '01'
		Else
			cDatarq := Left( cDatarq, 4 ) + StrZero( Val( Right( cDatarq, 2 ) ) + 1, 2, 0 ) 
		Endif
	
		If cDatArq > cMesAnoAte
			Exit
		Endif
	EndDo

	dbSelectArea( 'SRA' )
    dbSkip()
Enddo


//����������������������������������������������������������Ŀ
//� Recalcula a Folha com base nos Salarios Reajustados      �
//������������������������������������������������������������
dDtBsOld := dDataBase
For nI := 1 to Len( aMeses ) 
	dDataBase := aMeses[nI]
		
	aParametros[01]		:=	1 					//	Calcular por 1-Matricula  2-C.Custo
	aParametros[02]		:=	cFilDe				//	Filial De
	aParametros[03] 	:=	cFilAte				//	Filial Ate
	aParametros[04]		:=	cCCde				//	Centro de Custo De
	aParametros[05]		:=	cCCAte				//	Centro de Custo Ate
	aParametros[06] 	:=	cMatDe				//	Matricula De
	aParametros[07]		:=	cMatAte				//	Matricula Ate
	aParametros[08] 	:=	space(02)			//	No. da Semana
	aParametros[09]		:=	dDataBase			//	Data de Pagamento
	aParametros[10] 	:=	ctod("")			//	Data Inicio Tarefeiro
	aParametros[11]		:=	ctod("")			//	Data Final	Tarefeiro
	aParametros[12] 	:=	2					//  Calc. Compl. 13o.  Sim/Nao
	aParametros[13]     :=	cCategoria			//  Categorias a serem calculadas
	aParametros[14] 	:= 	0		    		//  Usado no Adiantamento
		
	//����������������������������������������������������������Ŀ
	//� Recalcula a Folha com base nos Salarios Reajustados e    �
	//� grava diferencas no arquivo de dissidio(TRB)             �
	//������������������������������������������������������������
	ProcGpe({|lEnd| GPMProcessa("FOL",aParametros,.T.,aPercDif)},"Recalculando mes "+ subs(MesAno(dDatabase),5,2)+"/"+subs(MesAno(dDatabase),1,4) ,,.T.)	
Next    

dDataBase := dDtBsOld 

Return 


/*

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao ChkTabela() - Checagem da digitacao da tabela de    ���
���          �                      reajuste.                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ChkTabela
Local nI
Local nLinGetD := n
Local lRetorna := .T.

//�������������������������������������������������������������������������Ŀ
//� Verifica se as faixas estao coerentes.									�
//���������������������������������������������������������������������������
If aCols[nLinGetD, nUsado] == .F.
	If aCols[nLinGetD, 1] > aCols[nLinGetD, 2]
		Help( ' ', 1, 'GR200FAIXA' )
		lRetorna := .F.
	Endif
	If nLinGetD > 1
		If aCols[nLinGetD, 1] <= aCols[nLinGetD-1, 2]
			Help( ' ', 1, 'GR200FAIXA' )
			lRetorna := .F.
		Endif
	Endif
	For nI = 4 To Len( aCols[nLinGetD] ) - 1
		If ( aCols[nLinGetD, nI] == 0 ) .and. (aCols[nLinGetD,3] == 0) 
			Help( ' ', 1, 'GR200ZEROS' )
			lRetorna := .F.
			Exit
		Endif
    Next
Endif
Return( lRetorna )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao Indice() - Pega o indice de reajuste conforme o ti- ���
���          �                   po de calculo.                           ���
�������������������������������������������������������������������������͹��
���Uso       � Estatica                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Indice( aTabela	,;	// Matriz da tabela
						nSalario,;	// Valor do salario
						nTipReaj,;	// Tipo de reajuste
						cAnomes	,;	// Data 
						aCabec 	,;	// Matriz de cabecalho
					    nPerDif	,;	// Percentual de aumento
					    nValAum ;	// Valor do Aumento
					    )

//�������������������������������������������������������������������������Ŀ
//� Declara variaveis locais de execucao.									�
//���������������������������������������������������������������������������
Local nLinha	:= Ascan( aTabela, { |X| nSalario >= X[1] .and. nSalario <= X[2]} )
Local cMesAno	:= { 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez', 'Dez' }[ Val( Right( cAnoMes, 2 ) )] + '/' + Left( cAnoMes, 4 )
    
If nLinha > 0

	//�������������������������������������������������������������������������Ŀ
	//� Verifica se tipo de indice de reajuste e unico.							�
	//���������������������������������������������������������������������������
	nValAum := aTabela[nLinha, 3]

	If nTipReaj = 2
		nPerDif := aTabela[nLinha, 4]
	Else 
		//���������������������������������������������������������������������������
		//� Busca o indice indicado para o mes que esta sendo calculado.			�
		//���������������������������������������������������������������������������
		If ( nColuna := Ascan( aCabec, { | X | cMesAno$X[1] } ) ) > 0
			nPerDif := aTabela[nLinha, nColuna]
		Endif
	Endif
Endif
Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GPECRVis() - Visualiza os calculos efetuados por fun���
���          �                     cionario.                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPECRVis()
Local oFont
Local oGroup

//�������������������������������������������������������������������������Ŀ
//� Declara variaveis locais de execucao.									�
//���������������������������������������������������������������������������
Private aCols 	:= {}
Private aTELA[0,0],aGETS[0],nUsado:=0
Private aHeader := { 	{ STR0014, 'DATREFE', '@R 99/9999'              , 07, 0, '', '�', 'N', '  ', ' ' }, ; //"Mes Referencia"
						{ STR0012, 'VERBORI', '@!'                      , 03, 0, '', '�', 'N', '  ', ' ' }, ; //"Verba Origem"
						{ STR0015, 'VERBPGT', '@!'                      , 03, 0, '', '�', 'N', '  ', ' ' }, ; //"Verba Pagto"
						{ STR0016, 'INDICE' , '@E 99, 999.99'           , 08, 2, '', '�', 'N', '  ', ' ' }, ; //"Indice"
						{ STR0013, 'VALORI' , '@E 999,999,999,999.99'   , 15, 2, '', '�', 'N', '  ', ' ' }, ; //"Valor Origem"
						{ STR0017, 'VALCAL' , '@E 999, 999, 999, 999.99', 15, 2, '', '�', 'N', '  ', ' ' }, ; //"Valor Calculado"
						{ STR0018, 'VALPAG' , '@E 999, 999, 999, 999.99', 15, 2, '', '�', 'N', '  ', ' ' }, ; //"Valor a pagar"
						{ STR0053, 'COMPL_' , '@!'                      , 01, 0, '', '�', 'C', '  ', ' ' }}   //"Selecionado"

//�������������������������������������������������������������������������Ŀ
//� Verifica se o calculo foi executado.									�
//���������������������������������������������������������������������������
dbSelectArea( 'TRB' )
If TRB->( RecCount() ) = 0
	Aviso( STR0019, STR0024, { STR0021 } )
Else

	//���������������������������������������������������������������������������
	//� Monta matriz de visualizacao.											�
	//���������������������������������������������������������������������������
	dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
	Do While !Eof() .and. TRB->TRB_FILIAL + TRB->TRB_MAT = SRA->RA_FILIAL + SRA->RA_MAT
		Aadd( aCols, { TRB->TRB_DATA, TRB->TRB_VB, TRB->TRB_VERBA, TRB->TRB_INDICE, TRB->TRB_VL, TRB->TRB_CALC, TRB->TRB_VALOR,TRB->TRB_COMPL_, .f. } )
		dbSkip()
	Enddo

	//�������������������������������������������������������������������������Ŀ
	//� Verifica se existe verbas calculadas.									�
	//���������������������������������������������������������������������������
	If Len( aCols ) = 0
		Aviso( STR0019, STR0020, { STR0021 } )
	Else

		//���������������������������������������������������������������������������
		//� Exibe as verbas calculadas.												�
		//���������������������������������������������������������������������������

		nOpca := 0

 		SetaPilha()

		DEFINE MSDIALOG oDlg TITLE "Diferencas"  From 196,042 TO 540,680 OF oMainWnd PIXEL	//""

			@ 016 , 005.2 SAY "Funcionario: " +SRA->RA_MAT +" - "+ SRA->RA_NOME SIZE 0200,10 

			@ 016 , 225.2 SAY "Valor Fixo do Aumento: " + Transform(TRB->TRB_VLRAUM,"@E 999,999,999.99") SIZE 0200,10 

			@ 026 , 005.2 SAY "Admissao   : " + DtoC( SRA->RA_ADMISSA) SIZE 0200,10 

			@ 036 , 005.2 SAY "Salario    : " + Transform(SRA->RA_SALARIO,"@E 999,999,999.99") SIZE 0200,10 

  			oGet := MSGetDados():New(045,005,165,315,1,,,"",.F.,,2,,1000)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nopca:=1,oDlg:End()},{||oDlg:End()}) CENTERED
   		SetaPilha()
	Endif
Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GPCRImp() - Efetua a impressao do relatorio de dis- ���
���          �                    sidio retroativo.                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPECRImp()

//�������������������������������������������������������������������������Ŀ
//� Declara variaveis locais de execucao.									�
//���������������������������������������������������������������������������
Local cString	:= 'SRA'        				
Local cDesc1	:= STR0025		
Local cDesc2	:= STR0026		
Local cDesc3	:= STR0027		
Local aOrd		:= {STR0028,STR0029,STR0030}
Local aArea 	:= SRA->( GetArea() )

Private wnRel
Private cPerg	:= 'GPCR02'
Private aReturn	:= { STR0031, 1,STR0032, 2, 2, 1,'',1 }	
Private nomeprog:= 'CGPER003'
Private aLinha	:= {}
Private nLastKey:= 0
Private Titulo	:= STR0025
Private cCabec
Private AT_PRG	:= 'GPECR010'
Private wCabec0	:= 6
Private wCabec2 := STR0033 
Private CONTFL	:= 1
Private LI		:= 0
Private nTamanho:= 'M'
Private aInfo	:= {}
Private nOrdem	:= 0
Private nTipo
                                                                                                                                                                                                                       

*/
//�������������������������������������������������������������������������Ŀ
//� Carregar parametros  													�
//���������������������������������������������������������������������������
Pergunte(cPerg,.F.)     

//�������������������������������������������������������������������������Ŀ
//� Verifica parametros de impressao.										�
//���������������������������������������������������������������������������
WnRel 	:= 'RELDSRT'
WnRel 	:= SetPrint( cString,WnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd )
nOrdem	:= aReturn[8]

//�������������������������������������������������������������������������Ŀ
//� Verifica continuidade de impressao.										�
//���������������������������������������������������������������������������
If !( LastKey() = 27 .or. nLastkey = 27 )
    SetDefault( aReturn, cString )
	RptStatus( { |lEnd| GPECRPrn( @lEnd, wnRel, cString ) }, Titulo )
Endif
RestArea(aArea)
Return
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GPECRPrn() - Efetua a impressao dos calculos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GPECRPrn()

//�������������������������������������������������������������������������Ŀ
//� Declara variaveis locais de trabalho.									�
//���������������������������������������������������������������������������
Local cLinha, nTotal, aFunc, aTotal, nLinha, aFilial, cFil, cExclui
Local cFilDe, cFilAte, cCcDe, cCcAte, cMatDe, cMatAte, cNomeDe, cNomeAte
Local cInicio, cFinal, cLoop, i

//�������������������������������������������������������������������������Ŀ
//� Ajusta variaveis de trabalho.											�
//���������������������������������������������������������������������������
nTipo		:= mv_par01
cFilDe  	:= mv_par02
cFilAte 	:= mv_par03
cCcDe		:= mv_par04
cCcAte		:= mv_par05
cMatDe		:= mv_par06
cMatAte		:= mv_par07
cNomeDe		:= mv_par08
cNomeAte	:= mv_par09

cExclui := ''
cExclui := cExclui + '{ || '
cExclui := cExclui + '( RA_FILIAL < cFilDe .or. RA_FILIAL > cFilAte ) .or. '
cExclui := cExclui + '( RA_MAT < cMatDe .or. RA_MAT > cMatAte ) .or. ' 
cExclui := cExclui + '( RA_CC < cCcDe .or. RA_CC > cCCAte ) .or. ' 
cExclui := cExclui + '( RA_NOME < cNomeDe .or. RA_NOME > cNomeAte ) ' 
cExclui := cExclui + ' } '

//�������������������������������������������������������������������������Ŀ
//� Verifica a ordem de impressao e posiciona ponteiro.						�
//���������������������������������������������������������������������������
dbSelectArea( 'SRA' )
dbSetOrder( nOrdem )
If nOrdem = 1    
	cInicio := cFilDe + cMatDe
	cFinal	:= cFilAte + cMatAte
	cLoop	:= '{ || SRA->RA_FILIAL + SRA->RA_MAT <= "' + cFilAte + cMatAte + '" } '
ElseIf nOrdem = 2               
	cInicio := cFilDe + cCcDe + cMatDe
	cFinal  := cFilAte + cCcAte + cMatAte
	cLoop	:= '{ || SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT <= "' + cFilAte + cCcAte + cMatAte + '" } '
Else
	cInicio := cFilDe + cNomeDe 
	cFinal	:= cFilAte + cNomeAte
	cLoop	:= '{ || SRA->RA_FILIAL + SRA->RA_NOME <= "' + cFilAte + cNomeAte + '" } '
Endif	   
dbSeek( cInicio, .t. )
SetRegua( SRA->( RecCount() ) )

//�������������������������������������������������������������������������Ŀ
//� Inicializa variaveis de controle de impressao.							�
//���������������������������������������������������������������������������
aTotal	:= {}
aFilial := {}
aCC		:= {}
cFil	:= SRA->RA_FILIAL
cCC		:= SUBSTR(SRA->RA_CC+SPACE(20),1,20)
While !Eof() .and. SRA->( Eval( &( cLoop ) ) )

    //�������������������������������������������������������������������������Ŀ
    //� Incrementa Regua de Processamento.										�
    //���������������������������������������������������������������������������
    IncRegua()

	//�������������������������������������������������������������������������Ŀ
	//� Verifica exclusao de registro conforme parametros.						�
	//���������������������������������������������������������������������������
	If SRA->( Eval ( &( cExclui ) ) )
		dbSelectArea( 'SRA' )
		dbSkip()
		Loop
	Endif

	//�������������������������������������������������������������������������Ŀ
	//� Verifica se houve calculo para o funcionario.							�
	//���������������������������������������������������������������������������
	dbSelectArea( 'TRB' )                           
	If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
		
		//�������������������������������������������������������������������������Ŀ
		//� Imprime os calculos do funcionario.										�
		//���������������������������������������������������������������������������
		nTotal	:= 0
		aFunc	:= {}
		cLinha	:= SRA->RA_MAT + ' '  +  SRA->RA_NOME + ' '
		Do While !Eof() .and. TRB_FILIAL + TRB_MAT = SRA->RA_FILIAL + SRA->RA_MAT

			If nTipo = 1 //Analalitico
			    cLinha += Left( TRB_DATA, 2 ) + '/' + Right( TRB_DATA, 4 ) + '  '
			    cLinha += Transform( TRB_INDICE, '@R 999.9999' ) + '  ' 
			    If TRB_VB =="000"
				    cLinha += TRB_VB + '-' + Left("SALARIO"+space(20),20) + '  '
			    Else
				    cLinha += TRB_VB + '-' + Left(PosSrv( TRB_VB,SRA->RA_FILIAL, 'RV_DESC' )+space(20),20) + '  '
				EndIf    
		    	cLinha += Transform( TRB_VL, '@R 9,999,999.99' ) + '  '
			    cLinha += Transform( TRB_CALC, '@R 9,999,999.99' ) + '  '
			    cLinha += Transform( TRB_VALOR, '@R 999,999.99' ) + '  '
			    cLinha += TRB_VERBA
		    	Impr( cLinha )
				cLinha := Space( 38 )
		 	Endif

			//�������������������������������������������������������������������������Ŀ
			//� Atualiza matriz de total do funcionario.								�
			//���������������������������������������������������������������������������
		 	If ( nLinha := Ascan( aFunc, { | X | X[1] = TRB_VERBA } ) ) > 0
		 		aFunc[nLinha,2] += TRB_VALOR
		 	Else                            
		 		Aadd( aFunc, { TRB_VERBA, TRB_VALOR } )
		 	Endif
		 	
			//�������������������������������������������������������������������������Ŀ
			//� Atualiza matriz de total da filial.										�
			//���������������������������������������������������������������������������
		 	If ( nLinha := Ascan( aFilial, { | X | X[1] = TRB_VERBA } ) ) > 0
		 		aFilial[nLinha,2] += TRB_VALOR
		 	Else                            
		 		Aadd( aFilial, { TRB_VERBA, TRB_VALOR } )
		 	Endif

			//�������������������������������������������������������������������������Ŀ
			//� Atualiza matriz de total do centro de custo.							�
			//���������������������������������������������������������������������������
		 	If ( nLinha := Ascan( aCC, { | X | X[1] = TRB_VERBA } ) ) > 0
		 		aCC[nLinha,2] += TRB_VALOR
		 	Else                            
		 		Aadd( aCC, { TRB_VERBA, TRB_VALOR } )
		 	Endif

		 	//�������������������������������������������������������������������������Ŀ
			//� Atualiza matriz de totalizacao geral.									�
			//���������������������������������������������������������������������������
		 	If ( nLinha := Ascan( aTotal, { | X | X[1] = TRB_VERBA } ) ) > 0
		 		aTotal[nLinha,2] += TRB_VALOR
		 	Else                            
		 		Aadd( aTotal, { TRB_VERBA, TRB_VALOR } )
		 	Endif
		    nTotal += TRB_VALOR
			dbSkip()
		Enddo       
		Impr( Iif( nTipo = 1, ' ', SRA->RA_MAT + ' ' + SRA->RA_NOME ) )

		//�������������������������������������������������������������������������Ŀ
		//� Imprime total do funcionario.											�
		//���������������������������������������������������������������������������
		If Len( aFunc ) = 1
			cLinha := Pad( STR0034, 57 )
		    If !Empty(aFunc[1,1])
				cLinha += aFunc[1,1] + '-' + PosSrv( aFunc[1,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
				cLinha += Transform( aFunc[1,2], '@R 9,999,999.99' )
				Impr( cLinha )
			EndIf	
		Else
			nTotal := 0
			cLinha := Pad( STR0035, 57 )
			For i = 1 to Len( aFunc )
			    If !Empty(aFunc[i,1])
					cLinha += aFunc[i,1] + '-' + PosSrv( aFunc[i,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
					cLinha += Transform( aFunc[i,2], '@R 9,999,999.99' )
					Impr( cLinha )
					cLinha := Space( 57 )
					nTotal += aFunc[i,2]
				EndIf	
			Next
			Impr( Space( 57 ) + '--------------------------------------------------' )
			cLinha := Space( 57 )
			cLinha += Pad( STR0036, 24 ) + '  '
			cLinha += Transform( nTotal, '@R 9,999,999.99' )
			Impr( cLinha )
		Endif
		Impr( Replicate( '=', 132 ) )
	Endif
	dbSelectArea( 'SRA' )
	dbSkip()             

	If cCC != SRA->RA_CC .and. nOrdem = 2 .and. Len( aCC ) > 0

		//���������������������������������������������������������������������������
		//� Imprime total do Centro de custo.										�
		//���������������������������������������������������������������������������
		If Len( aCC ) = 1
			cLinha := Pad( STR0046 + cCC, 57 )
		    If !Empty(aCC[1,1])
				cLinha += aCC[1,1] + '-' + PosSrv( aCC[1,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
				cLinha += Transform( aCC[1,2], '@R 9,999,999.99' )
				Impr( cLinha )
			EndIf
		Else
			nTotal := 0
			cLinha := Pad( STR0046 + cCC, 57 )
			For i = 1 to Len( aCC )
				If !Empty(aCC[i,1])
					cLinha += aCC[i,1] + '-' + PosSrv( aCC[i,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
					cLinha += Transform( aCC[i,2], '@R 9,999,999.99' )
					Impr( cLinha )
					cLinha := Space( 57 )
					nTotal += aCC[i,2]
				EndIf	
			Next
			Impr( Space( 57 ) + '--------------------------------------------------' )
			cLinha := Space( 57 )
			cLinha += Pad( STR0036, 24 ) + '  '
			cLinha += Transform( nTotal, '@R 9,999,999.99' )
			Impr( cLinha )
		Endif
		cCC		:= SUBSTR(SRA->RA_CC+SPACE(20),1,20)
		aCC		:= {}
		Li		:= 99
	Endif
	
	If cFil != SRA->RA_FILIAL .and. Len( aFilial ) > 0
		//���������������������������������������������������������������������������
		//� Imprime total da filial.												�
		//���������������������������������������������������������������������������
		If Len( aFilial ) = 1
			cLinha := Pad( STR0037 + cFil, 57 )
			If !Empty(aFilial[1,1])
				cLinha += aFilial[1,1] + '-' + PosSrv( aFilial[1,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
				cLinha += Transform( aFilial[1,2], '@R 9,999,999.99' )
				Impr( cLinha )
			EndIf	
		Else
			nTotal := 0
			cLinha := Pad( STR0038 + cFil, 57 )
			For i = 1 to Len( aFilial )
				If !Empty(aFilial[i,1])
					cLinha += aFilial[i,1] + '-' + PosSrv( aFilial[i,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
					cLinha += Transform( aFilial[i,2], '@R 9,999,999.99' )
					Impr( cLinha )
					cLinha := Space( 57 )
					nTotal += aFilial[i,2]
				EndIf	
			Next
			Impr( Space( 57 ) + '--------------------------------------------------' )
			cLinha := Space( 57 )
			cLinha += Pad( STR0036, 24 ) + '  '
			cLinha += Transform( nTotal, '@R 9,999,999.99' )
			Impr( cLinha )
		Endif
		cFil 	:= SRA->RA_FILIAL
		aFilial := {}
		Li 		:= 99
	Endif
Enddo                                

//�������������������������������������������������������������������������Ŀ
//� Imprime total geral.													�
//���������������������������������������������������������������������������
If Len( aTotal ) = 1
	cLinha := Pad( STR0040, 57 )
	If !Empty(aTotal[1,1])
		cLinha += aTotal[1,1] + '-' + PosSrv( aTotal[1,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
		cLinha += Transform( aTotal[1,2], '@R 9,999,999.99' )
		Impr( cLinha )
	EndIf	
Else                                              
    If Len( aTotal ) > 0
		nTotal := 0
		cLinha := Pad( STR0041, 57 )
		For i = 1 to Len( aTotal )
			If !Empty(aTotal[i,1])
				cLinha += aTotal[i,1] + '-' + PosSrv( aTotal[i,1],SRA->RA_FILIAL, 'RV_DESC' ) + '  '
				cLinha += Transform( aTotal[i,2], '@R 9,999,999.99' )
				Impr( cLinha )
				cLinha := Space( 57 )
				nTotal += aTotal[i,2]
			EndIf	
		Next
		Impr( Space( 57 ) + '--------------------------------------------------' )
		cLinha := Space( 57 )
		cLinha += Pad( STR0036, 24 ) + '  '
		cLinha += Transform( nTotal, '@R 9,999,999.99' )
		Impr( cLinha )
	Endif
Endif

//�������������������������������������������������������������������������Ŀ
//� Finaliza impressao.														�
//���������������������������������������������������������������������������
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	If Len( aTotal ) > 0
		OurSpool( WnRel )
	Endif
Endif
MS_Flush()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  � Advanced RH        � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � GPECRGrv() - Grava valores a serem pagos futuramente.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPECRGrv()

//�������������������������������������������������������������������������Ŀ
//� Declara variaveis locais de trabalho.									�
//���������������������������������������������������������������������������
Local cPerg 	:= 'GPCR03'
Local aArea 	:= SRA->( GetArea() )
Local aSays 	:= {}
Local aButtons 	:= {}
Local nOpca		:= 0

//�������������������������������������������������������������������������Ŀ
//� Verifica se o calculo foi executado.									�
//���������������������������������������������������������������������������
dbSelectArea( 'TRB' )
If TRB->( RecCount() ) = 0
	Aviso( STR0019, STR0024, { STR0021 } )
Else

	//�������������������������������������������������������������������������Ŀ
	//� Carrega parametros.														�
	//���������������������������������������������������������������������������
	Pergunte( cPerg, .f. )
	
	//�������������������������������������������������������������������������Ŀ
	//� Monta tela de dialogo.													�
	//���������������������������������������������������������������������������
	AAdd( aSays, OemToAnsi( STR0048 ) )
	
	AADD( aButtons, { 5, .T., {|| Pergunte( cPerg, .T. ) } } )
	AADD( aButtons, { 1, .T., { |o| nOpca := 1, If( GPECROK(), FechaBatch(), nOpca :=0 ) } } )
	AADD( aButtons, { 2, .T., { |o| FechaBatch() } } )

	FormBatch( cCadastro, aSays, aButtons )	
	
	If nOpca == 1
		ProcGpe( { |lEnd| U_GPECRProc() },,, .T. )
	Endif
Endif

SRA->( RestArea(aArea) )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  �Advanced - RH       � Data �  17/05/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GPERProc() - Faz o processamento da geracao das par ���
���          �                     celas.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPECRProc()

Local nParcela, nMinimo, nI, aFunc, nFunc
Local cFilDe, cFilAte, cCcDe, cCcAte, cMatDe, cMatAte, cNomeDe, cNomeAte
Private cExclui := ""

//�������������������������������������������������������������������������Ŀ
//� Ajusta variaveis de trabalho.											�
//���������������������������������������������������������������������������
nParcela 	:= Iif( mv_par01 = 0, 1, mv_par01 )
nMinimo  	:= mv_par02
dDatVen	 	:= Iif( Empty( mv_par03 ), dDataBase, mv_par03 )
cFilDe  	:= mv_par04
cFilAte 	:= mv_par05
cCcDe		:= mv_par06
cCcAte		:= mv_par07
cMatDe		:= mv_par08
cMatAte		:= mv_par09
cNomeDe		:= mv_par10
cNomeAte	:= mv_par11
cDocumento	:= mv_par12
nAtuSalario := mv_par13
nAtuLanc    := mv_par14
cSemana		:= mv_par15


If nAtuLanc == 3 .and. empty(cSemana)
	Aviso( STR0019,STR0054, { "Ok" },,STR0055 ) //"Atencao"###'Preencher a pergunta "Semana".'###"Semana nao Preenchida"
	Return
EndIf

cExclui := cExclui + '{ || '
cExclui := cExclui + '( RA_FILIAL < cFilDe .or. RA_FILIAL > cFilAte ) .or. '
cExclui := cExclui + '( RA_MAT < cMatDe .or. RA_MAT > cMatAte ) .or. ' 
cExclui := cExclui + '( RA_CC < cCcDe .or. RA_CC > cCCAte ) .or. ' 
cExclui := cExclui + '( RA_NOME < cNomeDe .or. RA_NOME > cNomeAte ) ' 
cExclui := cExclui + ' } '

//�������������������������������������������������������������������������Ŀ
//� Posiciona ponteiros do arquivo SRA.										�
//���������������������������������������������������������������������������

dbSelectArea( 'SRA' )
dbGoTop()
GPProcRegua( SRA->( RecCount() ) )


Do While !Eof() 

	//�������������������������������������������������������������������������Ŀ
	//� Movimenta cursor para movimentacao da barra.							�
	//���������������������������������������������������������������������������
	GPIncProc( SRA->RA_FILIAL + ' - ' + SRA->RA_MAT + ' - ' + SRA->RA_NOME )

	//�������������������������������������������������������������������������Ŀ
	//� Verifica exclusao de registro conforme parametros.						�
	//���������������������������������������������������������������������������
	If SRA->( Eval ( &( cExclui ) ) )
		dbSelectArea( 'SRA' )
		dbSkip()
		Loop
 	EndIf
	//�������������������������������������������������������������������������Ŀ
	//� Verifica se houve calculo para o funcionario.							�
	//���������������������������������������������������������������������������
	dbSelectArea( 'TRB' )                           
	If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )

		aFunc 	:=	{}
		nFunc 	:= 	0                
		nValAnt := 	0
		While !Eof() .and. TRB_FILIAL + TRB_MAT = SRA->RA_FILIAL + SRA->RA_MAT

			//�������������������������������������������������������������������������Ŀ
			//� Atualiza matriz de total do funcionario.								�
			//���������������������������������������������������������������������������
			If TRB->TRB_VB == "000" 
			   	If nAtuSalario == 1  //Atualiza historico Salarial
					If nValAnt <> TRB->TRB_CALC
						nValAnt := TRB->TRB_CALC
						dbSelectArea("SR3")
					   	cChave := SRA->RA_FILIAL+SRA->RA_MAT+substr(TRB->TRB_DATA,3,4)+substr(TRB->TRB_DATA,1,2)+"01"+TRB->TRB_TPOAUM+"000"
						//��������������������������������������������������������������Ŀ
						//� Atualizando SR7 - Alteracao Salarial                         �
						//����������������������������������������������������������������
						cFun := DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)
						dbSelectArea( "SR7" )
						If dbSeek( substr(cChave,1,19 ))
							RecLock("SR7",.F.,.T.)
						Else
							RecLock("SR7",.T.,.T.)
						Endif
						SR7->R7_FILIAL   := SRA->RA_FILIAL
						SR7->R7_MAT      := SRA->RA_MAT
						SR7->R7_DATA     := Ctod("01/"+substr(TRB->TRB_DATA,1,2)+"/"+substr(TRB->TRB_DATA,3,4))
						SR7->R7_TIPO     := TRB->TRB_TPOAUM
						SR7->R7_FUNCAO   := SRA->RA_CODFUNC
						SR7->R7_DESCFUN  := cFun			
						SR7->R7_TIPOPGT  := SRA->RA_TIPOPGT
						SR7->R7_CATFUNC  := SRA->RA_CATFUNC
						SR7->R7_USUARIO  := SubStr(cUsuario,7,15)
						MsUnLock()
	
						//��������������������������������������������������������������Ŀ
						//� Atualizando SR3 - Alteracao Salarial                         �
						//����������������������������������������������������������������
					   	If SR3->(dbSeek( cChave ))                                          
		 					RecLock("SR3",.F.,.T.)
						Else				   	
					   		RecLock("SR3",.T.,.T.)
					   	EndIf	
						SR3->R3_FILIAL   := SRA->RA_FILIAL
						SR3->R3_MAT      := SRA->RA_MAT
						SR3->R3_DATA     := Ctod("01/"+substr(TRB->TRB_DATA,1,2)+"/"+substr(TRB->TRB_DATA,3,4))
						SR3->R3_PD       := "000"
						SR3->R3_DESCPD   := "SALARIO BASE"
						SR3->R3_VALOR    := TRB->TRB_CALC
						SR3->R3_TIPO     := TRB->TRB_TPOAUM
						MsUnLock()
	    
						dbSelectArea( "SRA" )
						RecLock( "SRA" , .F. )
						SRA->RA_SALARIO := TRB->TRB_CALC
						SRA->RA_ANTEAUM := TRB->TRB_CALC

					EndIf				
				EndIf	
			Else
				If !empty(TRB->TRB_VERBA)
				 	If ( nLinha := Ascan( aFunc, { | X | X[1]+X[2] = TRB_VERBA+TRB_CC } ) ) > 0
				 		aFunc[nLinha,3] += TRB_VALOR
				 	Else                            
		 				Aadd( aFunc, { TRB_VERBA,TRB_CC, TRB_VALOR } )
		 			EndIf	
			 	Endif 
			 	nFunc += TRB_VALOR
			EndIf
			dbSelectArea( 'TRB' )                           
		 	dbSkip()
		Enddo		

		//�������������������������������������������������������������������������Ŀ
		//� Grava valores calculados no arquivo de lancamentos futuros.				�
		//���������������������������������������������������������������������������
		For nI = 1 To Len( aFunc )    
		                                       
			If aFunc[nI,3] <=0
				Loop
			EndIf
				
			If nAtuLanc == 1 //Lancamento Futuro
				dbSelectArea("SRK")
				If ! dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+aFunc[ni,1])
					RecLock( 'SRK', .T. )
				Else
					RecLock( 'SRK', .F. )					
				Endif			
				SRK->RK_FILIAL	:= SRA->RA_FILIAL
				SRK->RK_MAT		:= SRA->RA_MAT
				SRK->RK_PD		:= aFunc[nI,1]
				SRK->RK_VALORTO	:= aFunc[nI,3]
				SRK->RK_DTVENC	:= dDatVen
				SRK->RK_DTMOVI	:= dDataBase
				SRK->RK_CC		:= aFunc[nI,2]
				SRK->RK_DOCUMEN	:= cDocumento
				If nParcela = 1 .or. nFunc <= nMinimo 
					SRK->RK_PARCELA := 1
					SRK->RK_VALORPA := aFunc[nI,3]
				Else 
					nValParcela		:= NoRound( aFunc[nI,3] / nParcela, 2 )
					nValResiduo		:= NoRound( afunc[nI,3] - ( nValParcela * nParcela ), 2 )
					SRK->RK_PARCELA	:= nParcela
					SRK->RK_VALORPA	:= nValParcela
					SRK->RK_VALORAR	:= nValResiduo
				Endif
			Elseif nAtuLanc == 2 //Lancamento Mensal
				dbSelectArea("SRC")
				If ! dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+aFunc[ni,1])
					RecLock( 'SRC', .T. )
				Else
					RecLock( 'SRC', .F. )					
				Endif			 
				
				SRC->RC_FILIAL 	:= 	SRA->RA_FILIAL
				SRC->RC_MAT 	:= 	SRA->RA_MAT
				SRC->RC_PD		:= 	aFunc[nI,1]
				SRC->RC_CC		:= 	aFunc[nI,2]
				SRC->RC_SEMANA 	:=	If(SRA->RA_TIPOPGT=="S",cSemana,"")  //So para semanalista
				SRC->RC_TIPO1	:= 	"V"
				SRC->RC_TIPO2	:= 	"G"
				SRC->RC_HORAS	:= 	0
				SRC->RC_VALOR	:= 	aFunc[nI,3]
				SRC->RC_PARCELA	:= 	0
				SRC->RC_SEQ		:= 	""

			Elseif nAtuLanc == 3 //Valores Extras
				SR1->( dbSetOrder(1) )
				IF SR1->( !dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cSemana+aFunc[nI,1]))
				   RecLock( "SR1",.T. )
				Else
				   RecLock( "SR1",.F. )
				Endif
			  	SR1->R1_FILIAL  := SRA->RA_FILIAL
				SR1->R1_MAT     := SRA->RA_MAT
			    SR1->R1_PD      := aFunc[nI,1]
				SR1->R1_TIPO1   := "V"
			    SR1->R1_HORAS   := 0
			    SR1->R1_VALOR   := aFunc[nI,3]
			   	SR1->R1_CC      := aFunc[nI,2]
			    SR1->R1_TIPO2   := "G"
			   	SR1->R1_PARCELA := 0
				SR1->R1_SEMANA  := cSemana
				MsUnlock()
			EndIf	
		Next
   	Endif  
	dbSelectArea( 'SRA' )
	dbSkip()
Enddo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  �Microsiga           � Data �  08/06/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GPECROK() - Confirmacao da execucao da geracao das  ���
���          �                    parcelas.                               ���
�������������������������������������������������������������������������͹��
���Uso       � Estatica                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPECROk() 
Return ( MsgYesNo( OemToAnsi( STR0049 ), OemToAnsi( STR0019 ) ) )
