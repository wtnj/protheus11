#INCLUDE "RWMAKE.CH" 
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH"

//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁPrograma  Ё GpeWord  Ё Autor ЁMarinaldo de Jesus     Ё Data Ё05/07/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤└o Ё Impressao de Documentos tipo Word                          Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//ЁSintaxe   Ё Chamada padr└o para programas em RdMake.                   Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//ЁUso       Ё Generico                                                   Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//ЁObs.:     Ё                                                            Ё
//цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё         ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL.             Ё
//цддддддддддддбддддддддддбддддддбдддддддддддддддддддддддддддддддддддддддд╢
//ЁProgramador ЁData      Ё BOPS ЁMotivo da Alteracao                     Ё
//цддддддддддддеддддддддддеддддддедддддддддддддддддддддддддддддддддддддддд╢
//Ё            Ё23/05/2002Ё      ЁInicial.nDepen qdo impr.variaveis       Ё
//Ё            Ё06/01/2003Ё------ЁBuscar o codigo CBO no cadastro funcoes Ё
//Ё            Ё          Ё------Ёde acordo com os novos codigos CBO/2002.Ё
//Ё            Ё28/04/2003|------|Incl.de Variaveis novas no Array aExp.  Ё
//Ё            Ё          Ё------|Alteracao na perg.Verific.Dependente, naЁ
//Ё            Ё          Ё------|Perg.Funcao(tamanho)e Ordem de Impress. Ё
//Ё            Ё          Ё------|para imprimir por Ordem de Dt. Admissao.Ё
//Ё            Ё          Ё061017ЁAjuste na varialvel CGC p/ trazer corre Ё
//Ё            Ё          Ё      Ёtamente o numero do CGC c/ 14 dig.      Ё
//ЁPedro Eloy  Ё27/11/03  Ё067893Ёretirada o tratamento da foto.          Ё
//юддддддддддддаддддддддддаддддддадддддддддддддддддддддддддддддддддддддддды
User Function GpeWord()

Local	oDlg	:= NIL

Private	cPerg	:= "GPWORD"
Private aInfo	:= {}
Private aDepenIR:= {}
Private aDepenSF:= {}
Private nDepen	:= 0

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё         Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi(STR0001)
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(STR0002)						 												
@ 030,020 SAY OemToAnsi(STR0003)																		
@ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || Pergunte(cPerg,.T.) } )	
@ 095,072 BUTTON OemToAnsi(STR0004) SIZE 55,13 ACTION Eval( { || (ndepen:= 0,fVarW_Imp() ) }  )      
@ 095,130 BUTTON OemToAnsi(STR0005) SIZE 55,13 ACTION Eval( { || Pergunte(cPerg,.F.) , fWord_Imp() } )
@ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfWord_Imp Ё Autor ЁMarinaldo de Jesus     Ё Data Ё05/07/2000Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁImpressao do Documento Word                                 Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function fWord_Imp()

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁDefinindo Variaveis Locais                                             Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local oWord			:= NIL
Local cExclui		:= ""
Local cFilAnt   	:= ""
Local aCampos		:= {}
Local nX			:= 0
Local nSvOrdem		:= 0
Local nSvRecno		:= 0
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPEWORD" , "SRA" , "2" ) + " } " )

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁCarregando mv_par para Variaveis Locais do Programa                    Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local cFilDe		:= mv_par01
Local cFilAte		:= mv_par02
Local cCcDe			:= mv_par03
Local cCcAte		:= mv_par04
Local cMatDe		:= mv_par05
Local cMatAte		:= mv_par06
Local cNomeDe		:= mv_par07
Local cNomeAte		:= mv_par08
Local cTnoDe		:= mv_par09
Local cTnoAte		:= mv_par10
Local cFunDe		:= mv_par11
Local cFunAte		:= mv_par12
Local cSindDe		:= mv_par13
Local cSindAte		:= mv_par14
Local dAdmiDe		:= mv_par15
Local dAdmiAte		:= mv_par16
Local cSituacao		:= mv_par17
Local cCategoria	:= mv_par18
Local nCopias		:= If ( Empty(mv_par23),1,mv_par23 ) 
Local nOrdem		:= mv_par24
Local cArqWord		:= mv_par25
Local lDepende		:= If (Mv_par26 = 1, .T., .F.)
Local nDepende  	:= mv_par27
Local lImpress      := ( mv_par28 == 1 )
Local cArqSaida     := AllTrim( mv_par29 )
nDepen				:= If ( ! lDepende, 4,nDepende )

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁBloco que definira a Consistencia da Parametrizacao dos Intervalos seleЁ
Ёcionados nas Perguntas De? Ate?.                                       Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
cExclui := cExclui + "{ || "
cExclui := cExclui + "(RA_FILIAL  < cFilDe     .or. RA_FILIAL  > cFilAte    ).or."
cExclui := cExclui + "(RA_MAT     < cMatDe     .or. RA_MAT     > cMatAte    ).or." 
cExclui := cExclui + "(RA_CC      < cCcDe      .or. RA_CC      > cCCAte     ).or." 
cExclui := cExclui + "(RA_NOME    < cNomeDe    .or. RA_NOME    > cNomeAte   ).or." 
cExclui := cExclui + "(RA_TNOTRAB < cTnoDe     .or. RA_TNOTRAB > cTnoAte    ).or." 
cExclui := cExclui + "(RA_CODFUNC < cFunDe     .or. RA_CODFUNC > cFunAte    ).or." 
cExclui := cExclui + "(RA_SINDICA < cSindDe    .or. RA_SINDICA > cSindAte   ).or." 
cExclui := cExclui + "(RA_ADMISSA < dAdmiDe    .or. RA_ADMISSA > dAdmiAte   ).or." 
cExclui := cExclui + "!(RA_SITFOLH$cSituacao).or.!(RA_CATFUNC$cCategoria)"
cExclui := cExclui + " } "

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁInicializa o Ole com o MS-Word 97 ( 8.0 )						      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oWord	:= OLE_CreateLink() ; OLE_NewFile( oWord , cArqWord )

dbSelectArea("SRB")
nSBOrdem := IndexOrd() ; nSBRecno := Recno()
dbGotop()

dbSelectArea("SRA")
nSvOrdem := IndexOrd() ; nSvRecno := Recno()
dbGotop()


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Posicionando no Primeiro Registro do Parametro               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF nOrdem == 1	   							//Matricula
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cMatDe , .T. )
	cInicio := '{ || RA_FILIAL + RA_MAT }'
	cFim    := cFilAte + cMatAte
ElseIF nOrdem == 2							//Centro de Custo
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cCcDe + cMatDe , .T. )
	cInicio  := '{ || RA_FILIAL + RA_CC + RA_MAT }'
	cFim     := cFilAte + cCcAte + cMatAte
ElseIF nOrdem == 3							//Nome 
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cNomeDe + cMatDe , .T. )
	cInicio := '{ || RA_FILIAL + RA_NOME + RA_MAT }'
	cFim    := cFilAte + cNomeAte + cMatAte
ElseIF nOrdem == 4							//Turno 
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cTnoDe ,.T. )
	cInicio  := '{ || RA_FILIAL + RA_TNOTRAB } '
	cFim     := cFilAte + cCcAte + cNomeAte
ElseIF nOrdem == 5							//Admissao 
	cIndCond:= "RA_FILIAL + DTOS (RA_ADMISSA)"
   	cArqNtx  := CriaTrab(Nil,.F.)
   	IndRegua("SRA",cArqNtx,cIndCond,,,STR0162)		//"Selecionando Registros..."
	dbSeek( cFilDe + DTOS(dAdmiDe) ,.T. )
	cInicio  :='{ || RA_FILIAL + DTOS(RA_ADMISSA)}' 
	cFim     := cFilAte + DTOS(dAdmiAte)
EndIF

cFilialAnt := Space(02)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ira Executar Enquanto Estiver dentro do Escopo dos ParametrosЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
While SRA->( !Eof() .and. Eval( &(cInicio) ) <= cFim )
//    здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//    Ё Consiste Parametrizacao do Intervalo de Impressao            Ё
//    юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF SRA->( Eval ( &(cExclui) ) )
	       dbSelectArea("SRA")
	       dbSkip()
	       Loop
	    EndIF
	    
//	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//	ЁConsiste Filiais e Acessos                                             Ё
//	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		dbSelectArea("SRA")
      		dbSkip()
       		Loop
	EndIF 
	
//	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©	
//  ЁConsiste os dependentes  de Salario Familia                            Ё
//	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lDepende
		If nDepende == 1 //Salario Familia //
//			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
// 		    ЁConsiste os dependentes  de Salario Familia                            Ё
//			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
		    	fDepSF( )
			Else
				SRA->(dbSkip())
				Loop
			Endif		
		ElseIf nDepende == 2 //Imposto de Renda	//
//			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
// 		    ЁConsiste os dependentes  de Imposto de Renda                           Ё
// 		    юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
	    		fDepIR( )
	    	Else
				SRA->(dbSkip())
				Loop
			Endif	
		ElseIf nDepende == 3 // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda //
//			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
// 		    ЁConsiste todos os tipos de Dependentes                            Ё
//			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
	       		fDepIR( )
	       	Else
				SRA->(dbSkip())
				Loop
			Endif
			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
	    		fDepSF( )
	    	Else                                                                         
				SRA->(dbSkip())
				Loop
			Endif	
		Endif
	
		If (nDepende == 1)
			If  empty(aDepenSF[1,1])
				SRA->(dbSkip())
				Loop
			Endif	
		ElseIf	(nDepende == 2)
			If  empty(aDepenIR[1,1])
				SRA->(dbSkip())
				Loop
			Endif	          
		ElseIf	(nDepende == 3)
			If  empty(aDepenIR[1,1])  .and. empty(aDepenSF[1,1])
				SRA->(dbSkip())
				Loop
			EndIf
		Endif	                                                          
	Endif			
//  здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//  Ё Carregando Informacoes da Empresa                            Ё
//  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF SRA->RA_FILIAL # cFilialAnt
			IF !fInfo(@aInfo,SRA->RA_FILIAL)
//   		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//	        Ё Encerra o Loop se Nao Carregar Informacoes da Empresa        Ё
//     		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Exit
			EndIF			
// 		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//      Ё Atualiza a Variavel cFilialAnt                               Ё
// 		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("SRA")
			cFilialAnt := SRA->RA_FILIAL
		EndIF	
//	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//  Ё Carrega Campos Disponiveis para Edicao                       Ё
//	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		aCampos := fCpos_Word()
   
//	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//  Ё Ajustando as Variaveis do Documento                          Ё
//	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Aeval(	aCampos																								,; 
				{ |x| OLE_SetDocumentVar( oWord, x[1]  																,;
											IF( Subst( AllTrim( x[3] ) , 4 , 2 )  == "->"          					,; 
												Transform( x[2] , PesqPict( Subst( AllTrim( x[3] ) , 1 , 3 )		,;
																			Subst( AllTrim( x[3] )  				,;
										        			         			  - ( Len( AllTrim( x[3] ) ) - 5 )	 ;	
										          								 )	  	 							 ; 
																	      )                                          ;
												         )															,; 
												Transform( x[2] , x[3] )                                     		 ;
				  	 						  ) 														 	 		 ; 
										)																			 ;
				}     																 							 	 ;
			 )
        	
//		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//      Ё Atualiza as Variaveis                                        Ё
// 		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        OLE_UpDateFields( oWord )

//	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//	ЁImprimindo o Documento                                                 Ё
//	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF lImpress
			For nX := 1 To nCopias
				OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord )
			Next nX
		Else
			OLE_SaveAsFile( oWord, cArqSaida )
		EndIF
		
		dbSelectArea("SRA")                                               
        dbSkip()
        //Iniciliaza array 
        aDepenIR:= {}
        aDepenSF:= {}
Enddo	
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁEncerrando o Link com o Documento                                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
OLE_CloseLink( oWord )
 
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁRestaurando dados de Entrada                                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea('SRA')
dbSetOrder( nSvOrdem )
dbGoTo( nSvRecno )

Return( NIL )

//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤фo    ЁfOpen_WordЁ Autor Ё Marinaldo de Jesus    Ё Data Ё06/05/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤фo ЁSelecionaro os Arquivos do Word.                            Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Function fOpen_Word()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= STR0006														
Local cNewPathArq	:= cGetFile( cTipo , STR0007 )									

IF !Empty( cNewPathArq )
	IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( STR0008 ) )	
		Aviso( STR0009 , cNewPathArq , { STR0010 } )								
    Else
    	MsgAlert( STR0011 )															
    	Return
    EndIF
Else
    Aviso(STR0012 ,{ STR0010 } )													
    Return
EndIF
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁLimpa o parametro para a Carga do Novo Arquivo                         Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SX1")  
IF lAchou := ( SX1->( dbSeek( cPerg + "25" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par25 := cNewPathArq
	MsUnLock()
EndIF	
dbSelectArea( cSvAlias )
Return( .T. )


//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤фo    ЁfVarW_Imp Ё Autor Ё Marinaldo de Jesus    Ё Data Ё07/05/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤фo ЁImpressao das Variaveis disponiveis para uso                Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function fVarW_Imp()

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define Variaveis Locais                                      Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local cString	:= 'SRA'                                	     
Local aOrd		:= {STR0142,STR0143}
Local cDesc1	:= STR0144
Local cDesc2	:= STR0145                     
Local cDesc3	:= STR0146                                
Local Tamanho	:= "P"

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define Variaveis Privates Basicas                            Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Private nomeprog	:= 'GPEWORD'
Private AT_PRG		:= nomeProg
Private aReturn		:= {STR0147, 1,STR0148, 2, 2, 1, '',1 }
Private wCabec0		:= 1
Private wCabec1		:= STR0149
Private wCabec2		:= ""
Private wCabec3		:= ""
Private nTamanho	:= "P"
Private lEnd		:= .F.
Private Titulo		:= cDesc1
Private Li			:= 0
Private ContFl		:= 1
Private cBtxt		:= ""
Private aLinha		:= {}
Private nLastKey	:= 0

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Envia controle para a funcao SETPRINT                        Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
WnRel := "WORD_VAR" 
WnRel := SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)

IF nLastKey == 27
	Return( NIL )
EndIF

SetDefault(aReturn,cString)

IF nLastKey == 27
	Return( NIL )
EndIF

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Chamada do Relatorio.                                        Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
RptStatus( { |lEnd| fImpVar() } , Titulo )

Return( NIL )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤фo    ЁfImpVar   Ё Autor Ё Marinaldo de Jesus    Ё Data Ё07/05/2000Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤фo ЁImpressao das Variaveis disponiveis para uso                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function fImpVar()

Local nOrdem	:= aReturn[8]
Local aCampos	:= {}
Local nX		:= 0
Local cDetalhe	:= ""

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Carregando Informacoes da Empresa                            Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/ 
IF !fInfo(@aInfo,xFilial("SRA"))
	Return( NIL )
EndIF			

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Carregando Variaveis                                         Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/ 
aCampos := fCpos_Word()

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Ordena aCampos de Acordo com a Ordem Selecionada             Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
IF nOrdem = 1
	aSort( aCampos , , , { |x,y| x[1] < y[1] } )
Else
	aSort( aCampos , , , { |x,y| x[4] < y[4] } )
EndIF

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Carrega Regua de Processamento                               Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
SetRegua( Len( aCampos ) )

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Impressao do Relatorio                                       Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
For nX := 1 To Len( aCampos )

        /*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Movimenta Regua Processamento                                Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
        IncRegua()  

        /*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Cancela Impresфo                                             Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
        IF lEnd
           @ Prow()+1,0 PSAY cCancel
           Exit
        EndIF            

		/*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Mascara do Relatorio                                         Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
        //        10        20        30        40        50        60        70        80
        //12345678901234567890123456789012345678901234567890123456789012345678901234567890
		//Variaveis                      Descricao
		//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

		/*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Carregando Variavel de Impressao                             Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
		cDetalhe := IF( Len( AllTrim( aCampos[nX,1] ) ) < 30 , AllTrim( aCampos[nX,1] ) + ( Space( 30 - Len( AllTrim ( aCampos[nX,1] ) ) ) ) , aCampos[nX,1] )
		cDetalhe := cDetalhe + AllTrim( aCampos[nX,4] )
      	
      	/*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Imprimindo Relatorio                                         Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
        Impr( cDetalhe )
        
Next nX

IF aReturn[5] == 1
   Set Printer To
   dbCommit()
   OurSpool(WnRel)
EndIF
//--APAGA OS INDICES TEMPORARIOS--//
If nOrdem == 5
	fErase( cArqNtx + OrdBagExt() )
Endif                      

MS_FLUSH()

Return( NIL )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfDepIR    Ё Autor ЁR.H.                   Ё Data Ё02/04/2001Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarrega Dependentes de Imp. de Renda                        Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/                                                                                                                                                  
Static Function fDepIR( )
Local Nx,nVezes
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁConsiste os dependentes  de I.R.                                       Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	aDepenIR:= {}
	Do  while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If  (SRB->RB_TipIr == '1') .Or.;
         	(SRB->RB_TipIr == '2' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 21) .Or. ;
            (SRB->RB_TipIr == '3' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 24)
			//	Nome do Depend., Dta Nascimento,Grau de parentesco
      		aAdd(aDepenIR,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    '))   })
        EndIf
        SRB->(dbSkip())
	EndDo 
	If  Len(aDepenIR) < 10
      	nVezes := (10 - Len(aDepenIR))
		For Nx := 1 to nVezes
			 aAdd(aDepenIR,{Space(30),Space(10),Space(10) } )
		Next Nx
	EndIf
Return(aDepenIR)

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfDepSF    Ё Autor ЁR.H.                   Ё Data Ё02/04/2001Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarrega Dependentes de Salario Familia                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function  fDepSF()
Local Nx,nVezes
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁConsiste os dependentes  de I.R.                                       Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	aDepenSF:= {}
   	Do While SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If (SRB->RB_TipSf == '1') .Or. (SRB->RB_TipSf == '2' .And. ;
			Year(dDAtABase) - Year(SRB->RB_DtNasc) <= 14)
			//Nome do Depend., Dta Nascimento,Grau Parent.,Local Nascimento,Cartorio,Numero Regr.,Numero do Livro, Numero da Folha, Data Entrega,Data baixa. //
      		aAdd(aDepenSF,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    ')),;
      						SRB->RB_LOCNASC,SRB->RB_CARTORI,SRB->RB_NREGCAR,SRB->RB_NUMLIVR,SRB->RB_NUMFOLH,SRB->RB_DTENTRA,SRB->RB_DTBAIXA})
		EndIf
		SRB->(dbSkip())
	Enddo
   	If  Len(aDepenSF) < 10
      	nVezes := (10 - Len(aDepenSF))
		For Nx := 1 to nVezes
			 aAdd(aDepenSF,{Space(30),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10) } )
		Next Nx
	EndIf

Return(aDepenSF)

//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤└o    ЁfCpos_WordЁ Autor ЁMarinaldo de Jesus     Ё Data Ё06/07/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤└o ЁRetorna Array com as Variaveis Disponiveis para Impressao   Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё          ЁaExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)  Ё
//Ё          ЁaExp[x,2] - Conteudo do Campo                (Tam Max. 49)  Ё
//Ё          ЁaExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture Ё
//Ё          ЁaExp[x,4] - Descricao da Variaval                           Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
STATIC Function fCpos_Word()

Local aExp			:= {}
Local cTexto_01		:= AllTrim( mv_par19 )
Local cTexto_02		:= AllTrim( mv_par20 )
Local cTexto_03		:= AllTrim( mv_par21 )
Local cTexto_04		:= AllTrim( mv_par22 ) 
Local cApoderado	:= ""
Local cRamoAtiv		:= ""   

If cPaisLoc == "ARG"
	If fPHist82(xFilial(),"99","01")
		cApoderado := SubStr(SRX->RX_TXT,1,30)
	EndIf
	If fPHist82(xFilial(),"99","02")
		cRamoAtiv := SubStr(SRX->RX_TXT,1,50) 
	EndIf	           
EndIf	

aAdd( aExp, {'GPE_FILIAL'				,	SRA->RA_FILIAL 										  	, "SRA->RA_FILIAL"			,STR0013	} ) 
aAdd( aExp, {'GPE_MATRICULA'			,	SRA->RA_MAT												, "SRA->RA_MAT"				,STR0014	} ) 
aAdd( aExp, {'GPE_CENTRO_CUSTO'			,	SRA->RA_CC												, "SRA->RA_CC"				,STR0015	} ) 
aAdd( aExp, {'GPE_DESC_CCUSTO'			,	fDesc("SI3",SRA->RA_CC,"I3_DESC")		 				, "@!"						,STR0016	} ) 
aAdd( aExp, {'GPE_NOME'		   			,	SRA->RA_NOME											, "SRA->RA_NOME"			,STR0017	} ) 
aAdd( aExp, {'GPE_CPF'		   			,	SRA->RA_CIC												, "SRA->RA_CIC"				,STR0018	} ) 
aAdd( aExp, {'GPE_PIS'		   			,	SRA->RA_PIS												, "SRA->RA_PIS"				,STR0019	} ) 
aAdd( aExp, {'GPE_RG'		   			,	SRA->RA_RG												, "SRA->RA_RG"				,STR0020	} ) 
aAdd( aExp, {'GPE_RG_ORG'	   			,	SRA->RA_RGORG											, "@!"						,STR0152	} ) 
aAdd( aExp, {'GPE_CTPS'					,	SRA->RA_NUMCP							 				, "SRA->RA_NUMCP"			,STR0021	} ) 
aAdd( aExp, {'GPE_SERIE_CTPS'			,	SRA->RA_SERCP							 				, "SRA->RA_SERCP"			,STR0022	} ) 
aAdd( aExp, {'GPE_UF_CTPS'				,	SRA->RA_UFCP							 				, "SRA->RA_UFCP"			,STR0023	} ) 
aAdd( aExp, {'GPE_CNH'   	  			,	SRA->RA_HABILIT							 				, "SRA->RA_HABILIT"			,STR0024	} ) 
aAdd( aExp, {'GPE_RESERVISTA'			,	SRA->RA_RESERVI							 				, "SRA->RA_RESERVI"			,STR0025	} ) 
aAdd( aExp, {'GPE_TIT_ELEITOR' 			,	SRA->RA_TITULOE							 				, "SRA->RA_TITULOE"			,STR0026	} ) 
aAdd( aExp, {'GPE_ZONA_SECAO'  			,	SRA->RA_ZONASEC							 				, "SRA->RA_ZONASEC"			,STR0027	} ) 
aAdd( aExp, {'GPE_ENDERECO'				,	SRA->RA_ENDEREC							 				, "SRA->RA_ENDEREC"			,STR0028	} ) 
aAdd( aExp, {'GPE_COMP_ENDER'			,	SRA->RA_COMPLEM							 				, "SRA->RA_COMPLEM"			,STR0029	} )	
aAdd( aExp, {'GPE_BAIRRO'				,	SRA->RA_BAIRRO							 				, "SRA->RA_BAIRRO"			,STR0030	} ) 
aAdd( aExp, {'GPE_MUNICIPIO'			,	SRA->RA_MUNICIP							 				, "SRA->RA_MUNICIP"			,STR0031	} )	
aAdd( aExp, {'GPE_ESTADO'				,	SRA->RA_ESTADO											, "SRA->RA_ESTADO"			,STR0032	} )	
aAdd( aExp, {'GPE_DESC_ESTADO'			,	fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI")			, "@!"						,STR0033	} ) 
aAdd( aExp, {'GPE_CEP'		   			,	SRA->RA_CEP												, "SRA->RA_CEP"				,STR0034	} ) 
aAdd( aExp, {'GPE_TELEFONE'	   			,	SRA->RA_TELEFON											, "SRA->RA_TELEFON"			,STR0035	} ) 
aAdd( aExp, {'GPE_NOME_PAI'	   			,	SRA->RA_PAI												, "SRA->RA_PAI"				,STR0036	} ) 
aAdd( aExp, {'GPE_NOME_MAE'	   			,	SRA->RA_MAE												, "SRA->RA_MAE"				,STR0037	} ) 
aAdd( aExp, {'GPE_COD_SEXO'	   			,	SRA->RA_SEXO											, "SRA->RA_SEXO"			,STR0038	} ) 
aAdd( aExp, {'GPE_DESC_SEXO'   			,	SRA->(IF(RA_SEXO ="M","Masculino","Feminino"))			, "@!"						,STR0039	} ) 
If cPaisLoc <> "ARG"
	aAdd( aExp, {'GPE_EST_CIVIL'  			,	SRA->RA_ESTCIVI										, "SRA->RA_ESTCIVI"			,STR0040	} ) 
Else	
	aAdd( aExp, {'GPE_EST_CIVIL'  			,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")		, "SRA->RA_ESTCIVI"			,STR0040	} ) 
EndIf	
aAdd( aExp, {'GPE_COD_NATURALIDADE'		,	If(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," ")	    	, "SRA->RA_NATURAL"			,STR0041	} ) 
aAdd( aExp, {'GPE_DESC_NATURALIDADE'	,	fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI")			, "@!"						,STR0042	} ) 
aAdd( aExp, {'GPE_COD_NACIONALIDADE'	,	SRA->RA_NACIONA											, "SRA->RA_NACIONA"			,STR0043	} ) 
aAdd( aExp, {'GPE_DESC_NACIONALIDADE'	,	fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI")			, "@!"						,STR0044	} ) 
aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG											, "SRA->RA_ANOCHEG"			,STR0045	} )
aAdd( aExp, {'GPE_DEP_IR'   			,	SRA->RA_DEPIR										 	, "SRA->RA_DEPIR"			,STR0046	} )	
aAdd( aExp, {'GPE_DEP_SAL_FAM'			,	SRA->RA_DEPSF											, "SRA->RA_DEPSF"			,STR0047 	} )
aAdd( aExp, {'GPE_DATA_NASC'  			,	SRA->RA_NASC											, "SRA->RA_NASC"			,STR0048	} )
aAdd( aExp, {'GPE_DATA_ADMISSAO'		,	SRA->RA_ADMISSA											, "SRA->RA_ADMISSA"			,STR0049	} )
aAdd( aExp, {'GPE_DIA_ADMISSAO' 		,	StrZero( Day( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0050	} )
aAdd( aExp, {'GPE_MES_ADMISSAO'			,	StrZero( Month( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0051 	} )
aAdd( aExp, {'GPE_ANO_ADMISSAO'			,	StrZero( Year( SRA->RA_ADMISSA ) , 4 )					, "@!"						,STR0052	} )
aAdd( aExp, {'GPE_DT_OP_FGTS'  			,	SRA->RA_OPCAO											, "SRA->RA_OPCAO"			,STR0053	} )
aAdd( aExp, {'GPE_DATA_DEMISSAO'		,	SRA->RA_DEMISSA											, "SRA->RA_DEMISSA"			,STR0054	} ) 
aAdd( aExp, {'GPE_DATA_EXPERIENCIA'		,	SRA->RA_VCTOEXP											, "SRA->RA_VCTOEXP"			,STR0055	} )
aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 		,	StrZero( Day( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0056	} )
aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	StrZero( Month( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0057	} )
aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	StrZero( Year( SRA->RA_VCTOEXP ) , 4 ) 					, "@!"						,STR0058	} )
aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		,	StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03)				, "@!"						,STR0059	} )
aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI											, "SRA->RA_EXAMEDI"			,STR0060	} )
aAdd( aExp, {'GPE_BCO_AG_DEP_SAL'		, 	SRA->RA_BCDEPSA											, "SRA->RA_BCDEPSA"			,STR0061	} )
aAdd( aExp, {'GPE_DESC_BCO_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME")					, "@!"						,STR0062	} )
aAdd( aExp, {'GPE_DESC_AGE_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE")				, "@!"						,STR0063	} )
aAdd( aExp, {'GPE_CTA_DEP_SAL'			,	SRA->RA_CTDEPSA											, "SRA->RA_CTDEPSA"			,STR0064	} )
aAdd( aExp, {'GPE_BCO_AG_FGTS'			,	SRA->RA_BCDPFGT											, "SRA->RA_BCDPFGT"			,STR0065	} )
aAdd( aExp, {'GPE_DESC_BCO_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME")					, "@!"						,STR0066	} )
aAdd( aExp, {'GPE_DESC_AGE_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE")				, "@!"						,STR0067	} )
aAdd( aExp, {'GPE_CTA_Dep_FGTS'			,	SRA->RA_CTDPFGT											, "SRA->RA_CTDPFGT"			,STR0068	} )
aAdd( aExp, {'GPE_SIT_FOLHA'	  		,	SRA->RA_SITFOLH											, "SRA->RA_SITFOLH"			,STR0069	} )
aAdd( aExp, {'GPE_DESC_SIT_FOLHA'  		,	fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI")			, "@!"						,STR0070	} )
aAdd( aExp, {'GPE_HRS_MENSAIS'			,	SRA->RA_HRSMES											, "SRA->RA_HRSMES"			,STR0071	} )
aAdd( aExp, {'GPE_HRS_SEMANAIS'			,	SRA->RA_HRSEMAN											, "SRA->RA_HRSEMAN"			,STR0072	} )
aAdd( aExp, {'GPE_CHAPA'		  		,	SRA->RA_CHAPA											, "SRA->RA_CHAPA"			,STR0073	} )
aAdd( aExp, {'GPE_TURNO_TRAB'	 		,	SRA->RA_TNOTRAB											, "SRA->RA_TNOTRAB"			,STR0074	} )
aAdd( aExp, {'GPE_DESC_TURNO'	  		,	fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC')					, "@!"						,STR0075	} )
aAdd( aExp, {'GPE_COD_FUNCAO'	 		,	SRA->RA_CODFUNC											, "SRA->RA_CODFUNC"			,STR0076 	} )
aAdd( aExp, {'GPE_DESC_FUNCAO'			,	fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC')					, "@!"						,STR0077	} )
aAdd( aExp, {'GPE_CBO'			   		,	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase)		, "@!"				        ,STR0078	} )
aAdd( aExp, {'GPE_CONT_SINDIC'			,	SRA->RA_PGCTSIN											, "SRA->RA_PGCTSIN"			,STR0079	} )
aAdd( aExp, {'GPE_COD_SINDICATO'		,	SRA->RA_SINDICA											, "SRA->RA_SINDICA"			,STR0080	} )
aAdd( aExp, {'GPE_DESC_SINDICATPO'		,	AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) ), "@!"						,STR0081	} )
aAdd( aExp, {'GPE_COD_ASS_MEDICA'		,	SRA->RA_ASMEDIC											, "SRA->RA_ASMEDIC"			,STR0082	} )
aAdd( aExp, {'GPE_DEP_ASS_MEDICA'		,	SRA->RA_DPASSME											, "SRA->RA_DPASSME"			,STR0083	} )
aAdd( aExp, {'GPE_ADIC_TEMP_SERVIC'		,	SRA->RA_ADTPOSE											, "SRA->RA_ADTPOSE"			,STR0084	} )
aAdd( aExp, {'GPE_COD_CESTA_BASICA'		,	SRA->RA_CESTAB											, "SRA->RA_CESTAB"			,STR0085	} )
aAdd( aExp, {'GPE_COD_VALE_REF' 		,	SRA->RA_VALEREF											, "SRA->RA_VALEREF"			,STR0086	} )
aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV											, "SRA->RA_SEGUROV"			,STR0087	} )
aAdd( aExp, {'GPE_%ADIANTAM'	 		,	SRA->RA_PERCADT											, "SRA->RA_PERCADT"			,STR0089	} )
aAdd( aExp, {'GPE_CATEG_FUNC'	  		,	SRA->RA_CATFUNC											, "SRA->RA_CATFUNC"			,STR0090	} )
aAdd( aExp, {'GPE_DESC_CATEG_FUNC'		,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")			, "@!"						,STR0091	} )
aAdd( aExp, {'GPE_POR_MES_HORA'			,	SRA->(IF(RA_CATFUNC$"H","P/Hora","P/Mes")) 			, "@!"						,STR0092	} )
aAdd( aExp, {'GPE_TIPO_PAGTO'  			,	SRA->RA_TIPOPGT								 			, "SRA->RA_TIPOPGT"			,STR0093	} )
aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  	,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")			, "@!"						,STR0094	} )
aAdd( aExp, {'GPE_SALARIO'		   		,	SRA->RA_SALARIO											, "SRA->RA_SALARIO"			,STR0095	} )
aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM											, "SRA->RA_ANTEAUM"			,STR0096	} )
aAdd( aExp, {'GPE_HRS_PERICULO'  		,	SRA->RA_PERICUL											, "SRA->RA_PERICUL"			,STR0099	} )
aAdd( aExp, {'GPE_HRS_INS_MINIMA'		,	SRA->RA_INSMIN											, "SRA->RA_INSMIN"			,STR0100	} )
aAdd( aExp, {'GPE_HRS_INS_MEDIA'		,	SRA->RA_INSMED											, "@!"						,STR0101	} )
aAdd( aExp, {'GPE_HRS_INS_MAXIMA'		,	SRA->RA_INSMAX											, "SRA->RA_INSMAX"			,STR0102	} )
aAdd( aExp, {'GPE_TIPO_ADMISSAO'		,	SRA->RA_TIPOADM											, "SRA->RA_TIPOADM"			,STR0103	} )
aAdd( aExp, {'GPE_DESC_TP_ADMISSAO'		,	fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI")			, "@!"						,STR0104	} )
aAdd( aExp, {'GPE_COD_AFA_FGTS'			,	SRA->RA_AFASFGT											, "SRA->RA_AFASFGT"			,STR0105	} )
aAdd( aExp, {'GPE_DESC_AFA_FGTS'		,	fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI")			, "@!"						,STR0106	} )
aAdd( aExp, {'GPE_VIN_EMP_RAIS'			,	SRA->RA_VIEMRAI											, "SRA->RA_VIEMRAI"			,STR0107	} )
aAdd( aExp, {'GPE_DESC_VIN_EMP_RAIS'	,	fDesc("SX5","25"+RA_VIEMRAI,"X5_DESCRI")				, "@!"						,STR0108	} )
aAdd( aExp, {'GPE_COD_INST_RAIS'		,	SRA->RA_GRINRAI											, "SRA->RA_GRINRAI"			,STR0109	} )
aAdd( aExp, {'GPE_DESC_GRAU_INST'		,	fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI")			, "@!"						,STR0110	} )
aAdd( aExp, {'GPE_COD_RESC_RAIS'		,	SRA->RA_RESCRAI											, "SRA->RA_RESCRAI"			,STR0111	} )
aAdd( aExp, {'GPE_CRACHA'		  		,	SRA->RA_CRACHA											, "SRA->RA_CRACHA"			,STR0112	} )
aAdd( aExp, {'GPE_REGRA_APONTA'			,	SRA->RA_REGRA											, "SRA->RA_REGRA"			,STR0113	} )
aAdd( aExp, {'GPE_NO_REGISTRO'	 		,	SRA->RA_REGISTR											, "SRA->RA_REGISTR"			,STR0115	} )
aAdd( aExp, {'GPE_NO_FICHA'	    		,	SRA->RA_FICHA											, "SRA->RA_FICHA"			,STR0116	} )
aAdd( aExp, {'GPE_TP_CONT_TRAB'			,	SRA->RA_TPCONTR											, "SRA->RA_TPCONTR"			,STR0117	} )
aAdd( aExp, {'GPE_DESC_TP_CONT_TRAB'	,	SRA->(IF(RA_TPCONTR="1","Indeterminado","Determinado")) , "@!"						,STR0118	} )
aAdd( aExp, {'GPE_APELIDO'		   		,	SRA->RA_APELIDO											, "SRA->RA_APELIDO"			,STR0119	} )
aAdd( aExp, {'GPE_E-MAIL'		 		,	SRA->RA_EMAIL											, "SRA->RA_EMAIL"			,STR0120	} )
aAdd( aExp, {'GPE_TEXTO_01'				,	cTexto_01								   				, "@!"						,STR0121	} ) 
aAdd( aExp, {'GPE_TEXTO_02'				,	cTexto_02												, "@!"						,STR0122	} )
aAdd( aExp, {'GPE_TEXTO_03'				,	cTexto_03												, "@!"						,STR0123	} )
aAdd( aExp, {'GPE_TEXTO_04'				,	cTexto_04												, "@!"						,STR0124	} )
aAdd( aExp, {'GPE_EXTENSO_SAL'			,	Extenso( SRA->RA_SALARIO , .F. , 1 )					, "@!"						,STR0125 	} )
aAdd( aExp, {'GPE_DDATABASE'			,	dDataBase                    	        				, "" 						,STR0126	} )
aAdd( aExp, {'GPE_DIA_DDATABASE'		,	StrZero( Day( dDataBase ) , 2 )            				, "@!"						,STR0127	} )
aAdd( aExp, {'GPE_MES_DDATABASE'		,	MesExtenso( dDataBase ) 								, "@!"						,STR0128	} )
aAdd( aExp, {'GPE_ANO_DDATABASE'		,	StrZero( Year( dDataBase ) , 4 )            			, "@!"						,STR0129	} )
aAdd( aExp, {'GPE_NOME_EMPRESA' 		,	aInfo[03]                              					, "@!"						,STR0130	} )
aAdd( aExp, {'GPE_END_EMPRESA'			,	aInfo[04]                              					, "@!"						,STR0131	} )
aAdd( aExp, {'GPE_CID_EMPRESA'			,	aInfo[05]                              					, "@!"						,STR0132	} )
aAdd( aExp, {'GPE_CEP_EMPRESA'         	,   aInfo[07]                                              	, "!@R #####-###"          	,STR0034 	} )
aAdd( aExp, {'GPE_EST_EMPRESA'         	,   aInfo[06]												, "@!"						,STR0032 	} )
aAdd( aExp, {'GPE_CGC_EMPRESA' 			,	aInfo[08]             									, "@R ##.###.###/####-##"	,STR0134	} )
aAdd( aExp, {'GPE_INSC_EMPRESA' 		,	aInfo[09]                              					, "@!" 						,STR0135	} )
aAdd( aExp, {'GPE_TEL_EMPRESA'	 		,	aInfo[10]                              					, "@!" 						,STR0136	} )
aAdd( aExp, {'GPE_FAX_EMPRESA'         	,   If(aInfo[11]#nil ,aInfo[11], "        ")              	, "@!"                     	,STR0136 	} )
aAdd( aExp, {'GPE_BAI_EMPRESA'			,	aInfo[13]                              					, "@!" 						,STR0137	} )
aAdd( aExp, {'GPE_DESC_RESC_RAIS'		,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")			, "@!" 						,STR0138	} )
aAdd( aExp, {'GPE_DIA_DEMISSAO'			,	StrZero( Day( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0139	} )
aAdd( aExp, {'GPE_MES_DEMISSAO'			,	StrZero( Month( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0140 	} )
aAdd( aExp, {'GPE_ANO_DEMISSAO'			,	StrZero( Year( SRA->RA_DEMISSA ) , 4 )					, "@!" 						,STR0141 	} )
//SALARIO FAMILIA//
aAdd( aExp, {'GPE_CFILHO01'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[1,1],space(30))		, "@!"						,STR0150 	} )
aAdd( aExp, {'GPE_DTFL01'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[1,2],space(08))		, ""						,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO02'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[2,1],space(30))		, "@!"						,STR0150 	} )
aAdd( aExp, {'GPE_DTFL02'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[2,2],space(08))		, ""						,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO03'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[3,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL03'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[3,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO04'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[4,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL04'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[4,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO05'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[5,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL05'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[5,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO06'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[6,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL06'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[6,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO07'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[7,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL07'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[7,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO08'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[8,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL08'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[8,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO09'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[9,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL09'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[9,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO10'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[10,1],space(30))		, "@!"                    	,STR0150 	} )
aAdd( aExp, {'GPE_DESC_ESTEMP'         	,   alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI"))      		, "@!"                     	,STR0134 	} ) 
aAdd( aExp, {'GPE_cGrau01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_LOCAL01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,5],space(10))	 	, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,6],space(10))	 	, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,7],space(10))	 	, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,8],space(10))	 	, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,9],space(10))	 	, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,10],space(10))  	, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,4],space(10))	 	, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,5],space(10))	 	, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,06],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,5],space(10))		, "@!"						,STR0156 	} )
aAdd( aExp, {'GPE_NREGISTRO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,7],space(10))	    , "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,10],space(10))		, "@!"						,STR0161 	} ) 
//IMPOSTO DE RENDA//
aAdd( aExp, {'GPE_CDEPE01'             	,   if(nDepen==2 .or. nDepen==3,aDepenIR[1,1],space(30))		, "@!"						,STR0154   	} )
aAdd( aExp, {'GPE_cGrDp01'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[1,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR01'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[1,2],space(08)) 		, ""						,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[2,1],space(30))		, "@!" 						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[2,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR02'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[2,2],space(08))		, ""						,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[3,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[3,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR03'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[3,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[4,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[4,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR04'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[4,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[5,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[5,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR05'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[5,2],space(08))		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[6,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[6,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR06'				,   if(nDepen==2 .or. nDepen==3,aDepenIR[6,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[7,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[7,3],space(10))		, "@!"						,STR0153	} ) 
aAdd( aExp, {'GPE_DTFLIR07'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[7,2],space(08))		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[8,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[8,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR08'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[8,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[9,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[9,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR09'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[9,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR10'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[10,2],space(08))		, ""                        ,STR0163 	} )

If cPaisLoc == "ARG"
	aAdd( aExp, {'GPE_MES_ADEXT'		    ,	MesExtenso( Month( SRA->RA_ADMISSA ) )					    , "@!"						,STR0155	} )
	aAdd( aExp, {'GPE_APODERADO'		    ,	cApoderado												    , "@!"						,STR0156	} )
	aAdd( aExp, {'GPE_ATIVIDADE'		    ,	cRamoAtiv												    , "@!"						,STR0157	} )
EndIf	

Return( aExp )


/*
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё         Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01              DefSPA1     DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aAdd(aRegs,{cPerg,'01' ,'Filial De          ?',''				 ,''			 ,'mv_ch1','C'  ,02     ,0      ,0     ,'G','                                ','mv_par01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''   	  ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{cPerg,'02' ,'Filial Ate         ?',''				 ,''			 ,'mv_ch2','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par02','               '  ,''		 ,''	 ,REPLICATE('9',02) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,'' 	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SM0',''})
aAdd(aRegs,{cPerg,'03' ,'Centro de Custo De ?',''				 ,''			 ,'mv_ch3','C'  ,09     ,0      ,0     ,'G','                                ','mv_par03','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SI3',''})
aAdd(aRegs,{cPerg,'04' ,'Centro de Custo Ate?',''				 ,''			 ,'mv_ch4','C'  ,09     ,0      ,0     ,'G','naovazio                        ','mv_par04','               '  ,''		 ,''	 ,REPLICATE('Z',09) ,''   ,'        	   ',''		 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SI3',''})
aAdd(aRegs,{cPerg,'05' ,'Matricula De       ?',''				 ,''			 ,'mv_ch5','C'  ,06     ,0      ,0     ,'G','                                ','mv_par05','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{cPerg,'06' ,'Matricula Ate      ?',''				 ,''			 ,'mv_ch6','C'  ,06     ,0      ,0     ,'G','naovazio                        ','mv_par06','               '  ,''		 ,''	 ,REPLICATE('Z',06) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ','' 		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRA',''})
aAdd(aRegs,{cPerg,'07' ,'Nome De            ?',''				 ,''			 ,'mv_ch7','C'  ,30     ,0      ,0     ,'G','                                ','mv_par07','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'08' ,'Nome Ate           ?',''				 ,''			 ,'mv_ch8','C'  ,30     ,0      ,0     ,'G','naovazio                        ','mv_par08','               '  ,''		 ,''	 ,REPLICATE('Z',30) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'09' ,'Turno De           ?',''				 ,''			 ,'mv_ch9','C'  ,03     ,0      ,0     ,'G','                                ','mv_par09','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,'' 	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SR6',''})
aAdd(aRegs,{cPerg,'10' ,'Turno Ate          ?',''				 ,''			 ,'mv_cha','C'  ,03     ,0      ,0     ,'G','naovazio                        ','mv_par10','               '  ,''		 ,''	 ,REPLICATE('Z',03) ,''   ,'        	   ',''    	 ,''   	  ,''	 ,''   ,'       ' ,''  	 	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SR6',''})
aAdd(aRegs,{cPerg,'11' ,'Fun┤ao De          ?',''				 ,''			 ,'mv_chb','C'  ,03     ,0      ,0     ,'G','                                ','mv_par11','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRJ',''})
aAdd(aRegs,{cPerg,'12' ,'Fun┤ao Ate         ?',''				 ,''			 ,'mv_chc','C'  ,03     ,0      ,0     ,'G','naovazio                        ','mv_par12','               '  ,''		 ,''	 ,REPLICATE('Z',03) ,''   ,'        	   ',''    	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'SRJ',''})
aAdd(aRegs,{cPerg,'13' ,'Sindicato De       ?',''				 ,''			 ,'mv_chd','C'  ,02     ,0      ,0     ,'G','                                ','mv_par13','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'X04',''})
aAdd(aRegs,{cPerg,'14' ,'Sindicato Ate      ?',''				 ,''			 ,'mv_che','C'  ,02     ,0      ,0     ,'G','naovazio                        ','mv_par14','               '  ,''		 ,''	 ,REPLICATE('Z',03) ,''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'X04',''})
aAdd(aRegs,{cPerg,'15' ,'Admissao De        ?',''				 ,''			 ,'mv_chf','D'  ,08     ,0      ,0     ,'G','                                ','mv_par15','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'16' ,'Admissao Ate       ?',''				 ,''			 ,'mv_chg','D'  ,08     ,0      ,0     ,'G','naovazio                        ','mv_par16','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'17' ,'Situa┤■es  a Impr. ?',''				 ,''			 ,'mv_chh','C'  ,05     ,0      ,0     ,'G','fSituacao                       ','mv_par17','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'18' ,'Categorias a Impr. ?',''				 ,''			 ,'mv_chi','C'  ,10     ,0      ,0     ,'G','fCategoria                      ','mv_par18','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'19' ,'Texto Livre 1      ?',''				 ,''			 ,'mv_chj','C'  ,30     ,0      ,0     ,'G','                                ','mv_par19','               '  ,''		 ,''	 ,'<Texto Livre 01>',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'20' ,'Texto Livre 2      ?',''				 ,''			 ,'mv_chk','C'  ,30     ,0      ,0     ,'G','                                ','mv_par20','               '  ,''		 ,''	 ,'<Texto Livre 02>',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'21' ,'Texto Livre 3      ?',''				 ,''			 ,'mv_chl','C'  ,30     ,0      ,0     ,'G','                                ','mv_par21','               '  ,''		 ,''	 ,'<Texto Livre 03>',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'22' ,'Texto Livre 4      ?',''				 ,''			 ,'mv_chm','C'  ,30     ,0      ,0     ,'G','                                ','mv_par22','               '  ,''		 ,''	 ,'<Texto Livre 04>',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'23' ,'Nro. de Copias     ?',''				 ,''			 ,'mv_chn','N'  ,03     ,0      ,0     ,'G','                                ','mv_par23','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'24' ,'Ordem de Impressao ?',''				 ,''			 ,'mv_cho','N'  ,01     ,0      ,0     ,'C','                                ','mv_par24','Matricula      '  ,''		 ,''	 ,'                ',''   ,'Centro de Custo',''   	 ,''   	  ,''	 ,''   ,'Nome   ' ,''   	 ,''      ,''	 ,''	,'Turno  ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'25' ,'Arquivo do Word    ?',''				 ,''			 ,'mv_chp','C'  ,30     ,0      ,0     ,'G','fOpen_Word()                    ','mv_par25','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''   	  ,''	 ,''   ,'       ' ,''   	 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,''  	   ,''		 ,''	,'   ',''})
aAdd(aRegs,{cPerg,'26' ,'Verific.Dependente ?','Verifi.Dependiente','Check Dependent','mv_chq','N',1    ,0      ,1     ,'C',''                                ,'mv_par26','Sim'              ,'Yes'      ,'Si'   ,''                ,''   ,'Nao'            ,'No'           ,'No'         ,''         ,''        ,''      ,''    ,''    ,''	      ,''	     ,'      ',''  	 ,''  	,''	        ,''	       ,''		 ,''    ,''	  ,''})
aAdd(aRegs,{cPerg,'27  ,'Tipo de Dependente ?','                 ,'              ','mv_chr",'N'  ,01    ,0      ,3     ,'C',''                                ,'mv_par27','Dep.Sal.Familia'  ,'Dep.Sal.Familia'  ,'Fam.Allow.Dep.'  ,''   ,'Dep.Imp.Renda'  ,'Dep.Imp.Renta','Income Dep.','Ambos'    ,'Ambos'   ,'Ambos' ,''	 ,''	,''	      ,''	     ,''	  ,''	 ,''	,''	        ,''	       ,''	     ,''	,''	  ,''})
aAdd(aRegs,{cPerg,'28' ,'Impressao          ?','Impresion        ','Printing     ','mv_chs','N'  ,01    ,0      ,0     ,'C','                                ','mv_par28','Impressora' 		 ,'Impresone','Printer','              ',''   ,'Arquivo        ','Archivo'      ,'File'       ,''         ,''        ,'      ',''    ,''    ,''       ,''        ,'      ',''    ,''    ,''         ,''        ,''       ,''    ,''   ,''})
aAdd(aRegs,{cPerg,'29' ,'Arquivo Saida      ?','Archivo Salida   ','Output File  ','mv_cht','C'  ,30    ,0      ,0     ,'G','                                ','mv_par29','         '  		 ,''         ,''     ,'                ',''   ,'               ',''      ,''      ,''    ,''   ,'       ' ,''        ,''      ,''    ,''    ,'       ',''        ,''      ,''    ,''    ,''         ,''        ,''       ,''    ,'   ',''})
*/