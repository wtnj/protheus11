#INCLUDE "rwmake.ch"
#INCLUDE "TRM080.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRM080   ³ Autor ³ Equipe R.H.			³ Data ³ 23/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Resultados Avaliacoes conf.parametros selecionados.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³	    ³	   ³										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TRM080()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,TITULO,WNREL,NORDEM")
SetPrvt("CINICIO,CFIM,CFIL,CFIL2,LFIRST,LFIRST2")
SetPrvt("CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET")
SetPrvt("NNOTA,NPONTOS,CCHAVE,CCHAVE2,CMAT,CTESTE,CQUESTAO,CALTERNA,NRECNO")
SetPrvt("NITEM,I,CDESCR,NLINHA,CTIPO,CQUESTANT,CSINON,CDESCSI") 

aOrd 	:= {}
cDesc1  := OemtoAnsi(STR0001) //"Este programa tem como objetivo imprimir relatorio "
cDesc2  := OemtoAnsi(STR0002) //"de acordo com os parametros informados pelo usuario."
cDesc3  := OemtoAnsi(STR0003) //"Avaliacoes realizadas"
cPerg	:= "TRM080"
cString := "RAI"
Titulo  := OemtoAnsi(STR0003) //"Avaliacoes realizadas"
lEnd  	:= .F.
nTamanho:= "M"
nomeprog:= "TRM080" // Nome do programa para impressao no cabecalho
aReturn := { STR0005, 1, STR0006, 2, 2, 1, "", 1}	//"Zebrado"###"Administracao"
nLastKey:= 0
wnrel   := "TRM080" // Nome do arquivo usado para impressao em disco
cCabec  := ""
At_prg  := "TRM080"
WCabec0 := 1
Contfl  := 1
Li      := 0
Colunas := 132

dbSelectArea("RAI")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRM080",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Calendario De                            ³
//³ mv_par04        //  Calendario Ate                           ³
//³ mv_par05        //  Curso De                                 ³
//³ mv_par06        //  Curso Ate                                ³
//³ mv_par07        //  Turma De                                 ³
//³ mv_par08        //  Turma Ate                                ³
//³ mv_par09        //  Matricula De                             ³
//³ mv_par10        //  Matricula Ate                            ³
//³ mv_par11        //  Teste De                                 ³
//³ mv_par12        //  Teste Ate                                ³
//³ mv_par13        //  Nota De                                  ³
//³ mv_par14        //  Nota Ate                                 ³
//³ mv_par15        //  Tipo Avaliacao De                        ³
//³ mv_par16        //  Tipo Avaliacao Ate                       ³
//³ mv_par17        //  Relatorio: Analitico / Sintetico         ³
//³ mv_par18        //  Imp.Todas Alternat.: Sim / Nao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel 	:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| Relato()},Titulo)
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Relato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Relato()

mv_par01:= If(xFilial("RAI") == Space(2),Space(2),mv_par01)

If mv_par17 == 2 // Sintetico 

	WCabec1	:= STR0007 //"Filial Matricula Nome                          Avaliacao                               Nota"

	dbSelectArea("RAI")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "RAI->RAI_FILIAL + RAI->RAI_CALEND" 
	cFim	:= mv_par02 + mv_par04 

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If 	RAI->RAI_FILIAL	< mv_par01 .Or. RAI->RAI_FILIAL 	> mv_par02 .Or.;
			RAI->RAI_CALEND	< mv_par03 .Or. RAI->RAI_CALEND 	> mv_par04 .Or.;
			RAI->RAI_CURSO 	< mv_par05 .Or. RAI->RAI_CURSO		> mv_par06 .Or.;
			RAI->RAI_TURMA 	< mv_par07 .Or. RAI->RAI_TURMA 	> mv_par08 .Or.;
			RAI->RAI_MAT 	< mv_par09 .Or. RAI->RAI_MAT 		> mv_par10 .Or.;
			RAI->RAI_TESTE 	< mv_par11 .Or. RAI->RAI_TESTE 	> mv_par12 .Or.;
			RAI->RAI_TIPO 	< mv_par15 .Or. RAI->RAI_TIPO	 	> mv_par16
			dbSkip()
			Loop
		EndIf              
		
		cChave2 := 	RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
					RAI->RAI_CURSO + RAI->RAI_TURMA
		lFirst2 := .T.   				
		While !Eof() .And. RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
					RAI->RAI_CURSO + RAI->RAI_TURMA == cChave2

			nNota 		:= 0
			nItem 		:= 0
			cQuestAnt	:= ""
		   	cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	   					RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE 
					   	
			While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
							RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)
	
				// Buscar Valor das Alternativas selecionadas
				dbSelectArea("SQO")
				dbSetOrder(1)
				cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
				nPontos := 0
				If dbSeek( cFil + RAI->RAI_QUESTAO )
					 nPontos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
				EndIf   
				nNota 	+= nPontos 

				If RAI->RAI_QUESTAO != cQuestAnt
					cQuestAnt := RAI->RAI_QUESTAO
					nItem ++
				EndIf				                     
				
				cMat	:= RAI->RAI_MAT
				cTeste  := RAI->RAI_TESTE 
				cTipo 	:= RAI->RAI_TIPO 
				
				cCalend := RAI->RAI_CALEND
				cCurso	:= RAI->RAI_CURSO
				cTurma	:= RAI->RAI_TURMA
				 
				dbSelectArea("RA2")
				dbSetOrder(1)
				dbSeek(xFilial("RA2")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA)
				cSinon	:= RA2->RA2_SINON
				cDescSi	:= FDesc("RA9",cSinon,"RA9->RA9_DESCR",27)
				
				cDescCal:= FDesc("RA2",cCalend,"RA2_DESC")
				cDescCur:= FDesc("RA1",cCurso,"RA1_DESC",27)
			
				dbSelectArea("RAI")
				dbSetOrder(1)
				dbSkip()
			EndDo
				               
			If cTipo == "AVA" .Or. cTipo == "EFI"
				nNota := nNota / nItem
			EndIf
							                                           
			If nNota >= mv_par13 .And. nNota  <= mv_par14
		                                       
				// Buscar Avaliacao      
				If Len(Alltrim(cTeste)) == 3
					dbSelectArea("SQQ")
					cFil := If(xFilial("SQQ") == Space(2),Space(2),RAI->RAI_FILIAL)	
				Else 
					dbSelectArea("SQW") 
					cFil := If(xFilial("SQW") == Space(2),Space(2),RAI->RAI_FILIAL)						
				EndIf
				dbSetOrder(1)
						
				dbSeek( cFil + Alltrim(cTeste) )
			
				// Buscar Funcionario
				dbSelectArea("SRA")
				dbSetOrder(1)  
				cFil := If(xFilial("SRA") == Space(2),Space(2),SRA->RA_FILIAL)
				dbSeek( cFil + cMat )
	
	   			// Impressao de detalhe
	   			If lFirst2                          
					IMPR(Repl("-",Colunas),"C")
		   			DET	:= STR0009+cCalend+"-"+cDescCal +Space(01)+ STR0010+cCurso+"-"+cDescCur +Space(01)+ STR0018+cSinon+"-"+cDescSi+Space(01)+ STR0011+cTurma //"Calendario: "#"Curso: "#"Sinonimo: "#"Turma: "
		   			IMPR(DET,"C")
					IMPR(Repl("-",Colunas),"C")
		   			lFirst2 := .F.
		   		EndIf

	   			DET := "  "
				DET += SRA->RA_FILIAL + Space(05)
				DET += SRA->RA_MAT + Space(02)
				DET += SRA->RA_NOME + Space(01)     
				If Len(Alltrim(cTeste)) == 3
					DET += cTeste +" - "+ Padr(SQQ->QQ_DESCRIC,30) + Space(01)
				Else
					DET += cTeste +" - "+ Padr(SQW->QW_DESCRIC,30) + Space(01)					
				EndIf
				DET += Str(nNota,6,2)
				IMPR(DET,"C")
				If cCalend != RAI->RAI_CALEND
					IMPR("","C")	
				EndIf
	    	EndIf
      
			dbSelectArea("RAI")
			dbSetOrder(1)
		EndDo
	Enddo
	
Else // Analitico
 	
 	If mv_par18 == 2 // Nao imprimir todas alternativas
 		WCabec1	:= STR0008 // "Filial Matricula Nome                          Avaliacao                              Questao Alternativa  Pontos"
    Else
		WCabec1	:= STR0013 // "Filial Matricula Nome                          Avaliacao"    
    EndIf
    
	dbSelectArea("RAI")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "RAI->RAI_FILIAL + RAI->RAI_CALEND" 
	cFim	:= mv_par02 + mv_par04

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If 	RAI->RAI_FILIAL	< mv_par01 .Or. RAI->RAI_FILIAL 	> mv_par02 .Or.;
			RAI->RAI_CALEND	< mv_par03 .Or. RAI->RAI_CALEND 	> mv_par04 .Or.;
			RAI->RAI_CURSO 	< mv_par05 .Or. RAI->RAI_CURSO		> mv_par06 .Or.;
			RAI->RAI_TURMA 	< mv_par07 .Or. RAI->RAI_TURMA 		> mv_par08 .Or.;
			RAI->RAI_MAT 	< mv_par09 .Or. RAI->RAI_MAT 		> mv_par10 .Or.;
			RAI->RAI_TESTE 	< mv_par11 .Or. RAI->RAI_TESTE 		> mv_par12 .Or.;
			RAI->RAI_TIPO 	< mv_par15 .Or. RAI->RAI_TIPO	 	> mv_par16			
			dbSkip()
			Loop
		EndIf              

		cChave2 := 	RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
					RAI->RAI_CURSO + RAI->RAI_TURMA
		lFirst2 := .T.   					   				
		While !Eof() .And. RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
							RAI->RAI_CURSO + RAI->RAI_TURMA == cChave2
		
			// Verificar a Nota do Candidato
			nRecno 	:= Recno()      
			nNota	:= 0                   
		   	cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	   					RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE 
				   	
			While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
								RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)
  		
				// Buscar Valor das Alternativas selecionadas
				dbSelectArea("SQO")
				dbSetOrder(1)
				cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
				nPontos := 0
				If dbSeek( cFil + RAI->RAI_QUESTAO )
					 nPontos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
				EndIf   
				nNota 	+= nPontos 

				dbSelectArea("RAI")
				dbSetOrder(1)
				dbSkip()
			EndDo    
			If nNota >= mv_par13 .And. nNota  <= mv_par14
				dbGoto(nRecno)
			Else
				Loop	
			EndIf	
		        
	     	If mv_par18 == 2 				// Nao imprimir todas alternativas
				Tr080Resum() 	                              
	     	
	     	Else 							// imprimir todas alternativas
				Tr080Detal()     	
	     	EndIf

		Enddo
	EndDo
EndIf

// Fim do Relatorio
IMPR("","F")

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime apenas as alternativas escolhidas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Tr080Resum()

dbSelectArea("RAI")
dbSetOrder(1)
nNota 	:= 0                         
nItem	:= 0
cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
			RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE

lFirst		:= .T.                                     
cQuestAnt	:= ""
While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)
	
	// Buscar Valor das Alternativas selecionadas
	dbSelectArea("SQO")
	dbSetOrder(1)
	cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
	nPontos := 0
	If dbSeek( cFil + RAI->RAI_QUESTAO )
		nPontos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
	EndIf
	nNota		+= nPontos
	
	If RAI->RAI_QUESTAO != cQuestAnt
		cQuestAnt := RAI->RAI_QUESTAO
		nItem ++
	EndIf
	
	cMat	 	:= RAI->RAI_MAT
	cTeste  	:= RAI->RAI_TESTE
	cQuestao 	:= RAI->RAI_QUESTAO
	cAlterna	:= RAI->RAI_ALTERNA
	cTipo 		:= RAI->RAI_TIPO 
	
	cCalend 	:= RAI->RAI_CALEND
	cCurso		:= RAI->RAI_CURSO
	cTurma		:= RAI->RAI_TURMA
	cDescCal	:= FDesc("RA2",cCalend,"RA2_DESC")
	cDescCur	:= FDesc("RA1",cCurso,"RA1_DESC",27)
	                   
	dbSelectArea("RA2")
	dbSetOrder(1)
	dbSeek(xFilial("RA2")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA)
	cSinon	:= RA2->RA2_SINON
	cDescSi	:= FDesc("RA9",cSinon,"RA9->RA9_DESCR",27)
	
	// Buscar Avaliacao
	If Len(Alltrim(cTeste)) == 3
		dbSelectArea("SQQ")
		cFil := If(xFilial("SQQ") == Space(2),Space(2),RAI->RAI_FILIAL)
	Else
		dbSelectArea("SQW")
		cFil := If(xFilial("SQW") == Space(2),Space(2),RAI->RAI_FILIAL)
	EndIf
	
	dbSetOrder(1)
	
	dbSeek( cFil + Alltrim(cTeste) )
	
	// Buscar Funcionario
	dbSelectArea("SRA")
	dbSetOrder(1)
	cFil := If(xFilial("SRA") == Space(2),Space(2),SRA->RA_FILIAL)
	dbSeek( cFil + cMat )
	
	// Impressao de detalhe
	If lFirst
		If lFirst2
			IMPR(Repl("-",Colunas),"C")
			DET	:= STR0009+cCalend+"-"+cDescCal +Space(01)+ STR0010+cCurso+"-"+cDescCur +Space(01)+ STR0018+cSinon+"-"+cDescSi+Space(01)+ STR0011+cTurma //"Calendario: "#"Curso: "#"Sinonimo: "#"Turma: "
			IMPR(DET,"C")
			IMPR(Repl("-",Colunas),"C")
			lFirst2 := .F.
		EndIf
		
		DET := "  "
		DET += SRA->RA_FILIAL + Space(05)
		DET += SRA->RA_MAT 	+ Space(02)
		DET += SRA->RA_NOME 	+ Space(01)
		If Len(Alltrim(cTeste)) == 3
			DET += cTeste +" - "+ Padr(SQQ->QQ_DESCRIC,30) + Space(04)
		Else
			DET += cTeste +" - "+ Padr(SQW->QW_DESCRIC,30) + Space(04)
		EndIf
	Else
		DET := Space(89)
	EndIf
	DET += cQuestao	+ Space(08)
	DET += cAlterna	+ Space(05)
	DET += Str(nPontos,6,2)
	
	IMPR(DET,"C")
	lFirst := .F.
	
	dbSelectArea("RAI")
	dbSetOrder(1)
	dbSkip()
EndDo
IMPR("","C")          

If cTipo == "AVA" .Or. cTipo == "EFI"
	cDet := Space(02)+STR0012+" "+Str(nNota,6,2) 				//"Total de Pontos: "
	cDet += Space(73)+STR0017+" "+Str(( nNota / nItem ),6,2)	//"Media: "
	IMPR(cDet,"C")
Else
	IMPR(Space(02)+STR0012+Space(88)+Str(nNota,6,2),"C")		//"Total de Pontos: "
EndIf

If cCalend == RAI->RAI_CALEND .Or. Empty(RAI->RAI_CALEND)
	IMPR(Repl("-",Colunas-2),"C",,,02)
Else
	IMPR("","C")
EndIf
			
Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime todas as alternativas de cada questao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Tr080Detal()
Local i		:= 0
Local nBegin:= 0

dbSelectArea("RAI")
dbSetOrder(1)
nNota 	:= 0
cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	  				RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE
nItem 	:= 0
lFirst	:= .T.
cDescr	:= ""

While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
				RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)

	cMat	 	:= RAI->RAI_MAT
	cTeste  	:= RAI->RAI_TESTE
	cQuestao 	:= RAI->RAI_QUESTAO
	cAlterna	:= RAI->RAI_ALTERNA
	cCalend 	:= RAI->RAI_CALEND
	cCurso		:= RAI->RAI_CURSO
	cTurma		:= RAI->RAI_TURMA   
	cTipo 		:= RAI->RAI_TIPO 
	cDescCal	:= FDesc("RA2",cCalend,"RA2_DESC")
	cDescCur	:= FDesc("RA1",cCurso,"RA1_DESC",27)	
           
	dbSelectArea("RA2")
	dbSetOrder(1)
	dbSeek(xFilial("RA2")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA)
	cSinon	:= RA2->RA2_SINON
	cDescSi	:= FDesc("RA9",cSinon,"RA9->RA9_DESCR",27)
	
	// Buscar Avaliacao
	If Len(Alltrim(cTeste)) == 3
		dbSelectArea("SQQ")
		cFil := If(xFilial("SQQ") == Space(2),Space(2),RAI->RAI_FILIAL)
	Else
		dbSelectArea("SQW")
		cFil := If(xFilial("SQW") == Space(2),Space(2),RAI->RAI_FILIAL)
	EndIf
	dbSetOrder(1)
	dbSeek( cFil + Alltrim(cTeste) )
	
	// Buscar Funcionario
	dbSelectArea("SRA")
	dbSetOrder(1)
	cFil := If(xFilial("SRA") == Space(2),Space(2),RAI->RAI_FILIAL)
	dbSeek( cFil + cMat )
	
	// Impressao de detalhe
	If lFirst
		If lFirst2
			IMPR(Repl("-",Colunas),"C")
			DET	:= STR0009+cCalend+"-"+cDescCal +Space(01)+ STR0010+cCurso+"-"+cDescCur +Space(01)+ STR0018+cSinon+"-"+cDescSi+Space(01)+ STR0011+cTurma //"Calendario: "#"Curso: "#"Sinonimo: "#"Turma: "
			IMPR(DET,"C")
			IMPR(Repl("-",Colunas),"C")
			lFirst2 := .F.
		EndIf
		
		DET := "  "
		DET += SRA->RA_FILIAL 	+ Space(05)
		DET += SRA->RA_MAT		+ Space(02)
		DET += SRA->RA_NOME 	+ Space(01)
		If Len(Alltrim(cTeste)) == 3
			DET += cTeste +" - "+ Padr(SQQ->QQ_DESCRIC,30) + Space(04)
		Else
			DET += cTeste +" - "+ Padr(SQW->QW_DESCRIC,30) + Space(04)
		EndIf 
		
		IMPR(DET,"C")
		IMPR("","C") 
	EndIf
	
	// Buscar Valor das Alternativas selecionadas
	dbSelectArea("SQO")
	dbSetOrder(1)
	cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
	nPontos := 0
	If dbSeek( cFil + RAI->RAI_QUESTAO )
		nPontos := ( SQO->QO_PONTOS )
	EndIf                           

	// Imprimir Questao	 
	nItem ++	 
	cDescr:= Alltrim(SQO->QO_QUEST) //+ " ("+RAI->RAI_QUESTAO+")"
	nLinha:= MLCount(cDescr,115)
	For i := 1 to nLinha
		DET := Space(05)+IIF(i==1,StrZero(nItem,3)+"- ",Space(Len(StrZero(nItem,3)))+"  ")+MemoLine(cDescr,115,i,,.T.)
		Impr(DET,"C")
	Next i	
	Impr("","C") 
	   
	// Verifica se Questao eh Dissertativa
	If RAI->RAI_ALTERN == "00"	// Dissertativa	 
		DET := Space(11)+STR0016+Space(84)+STR0015	//"Resposta    "###"Pontos"
		Impr(DET,"C")   

		nPtos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
		nNota += nPtos
					   
		cAuxDet := MSMM(RAI->RAI_MRESPO,,,,3)	// Leitura do campo memo da descricao detalhada
		nLinha	:= MLCount(cAuxDet,99)		// Verifica numero de linhas.
		If nLinha > 0
			For nBegin := 1 To nLinha
				If nBegin == nLinha
					DET := Space(07)+Memoline(cAuxDet,99,nBegin,,.t.)+" "+Str(nPtos,6,2)   
				Else 
					DET := Space(07)+Memoline(cAuxDet,99,nBegin,,.t.)+" "
				EndIf
				Impr(DET,"C")   
			Next nBegin
		EndIf
	Else  		// Imprime Cabecalho das alternativas.
		DET := Space(11)+STR0014+Space(84)+STR0015	//"Alternativas"###"Pontos"
		Impr(DET,"C")   
        
		dbSelectArea("RAI")
		dbSetOrder(1)       
	
		aSaveRAI := GetArea()
		
		If Empty(SQO->QO_ESCALA)
		
			dbSelectArea("SQP")
			dbSetOrder(1)
			cFil := If(xFilial("SQP") == Space(2),Space(2),RAI->RAI_FILIAL)
			If dbSeek(cFil + RAI->RAI_QUESTAO )
				While !Eof() .And. ( SQP->QP_FILIAL + SQP->QP_QUESTAO  ) ==;
									( cFil + cQuestao )
	             
					dbSelectArea("RAI")
					dbSetOrder(1) 
					nPtos := 0
					cFil2 := If(xFilial("RAI") == Space(2),Space(2),SRA->RA_FILIAL)			
					If dbSeek( cFil2 + cCalend + cCurso + cTurma + cMat + cTeste + SQP->QP_QUESTAO + SQP->QP_ALTERNA )
				
						nPtos := ( nPontos * RAI->RAI_RESULTA / 100 )
						nNota += nPtos
						DET := Space(07)+"(X) "+SQP->QP_ALTERNA+" - "+Left(SQP->QP_DESCRIC,90)+" "+Str(nPtos,6,2)
					Else
						DET := Space(07)+"( ) "+SQP->QP_ALTERNA+" - "+Left(SQP->QP_DESCRIC,90)+" "+Str(nPtos,6,2)
					EndIf		 
					IMPR(DET,"C")	
					
					dbSelectArea("SQP")
					dbSetOrder(1)
					dbSkip()
				EndDo
			EndIf
		
		Else
		
			dbSelectArea("RBL") 
			dbSetOrder(1)
			cFil := If(xFilial("RBL") == Space(2),Space(2),RAI->RAI_FILIAL)
			If dbSeek(cFil + SQO->QO_ESCALA )
				While !Eof() .And. ( RBL->RBL_FILIAL + RBL->RBL_ESCALA  ) ==;
									( cFil + SQO->QO_ESCALA )
	             
					dbSelectArea("RAI")
					dbSetOrder(1) 
					nPtos := 0
					cFil2 := If(xFilial("RAI") == Space(2),Space(2),SRA->RA_FILIAL)			
					If dbSeek( cFil2 + cCalend + cCurso + cTurma + cMat + cTeste + SQO->QO_QUESTAO + RBL->RBL_ITEM )
				
						nPtos := ( nPontos * RAI->RAI_RESULTA / 100 )
						nNota += nPtos
						DET := Space(07)+"(X) "+RBL->RBL_ITEM+" - "+Left(RBL->RBL_DESCRI,90)+" "+Str(nPtos,6,2)
					Else
						DET := Space(07)+"( ) "+RBL->RBL_ITEM+" - "+Left(RBL->RBL_DESCRI,90)+" "+Str(nPtos,6,2)
					EndIf		 
					IMPR(DET,"C")	
					
					dbSelectArea("RBL") 
					dbSetOrder(1)
					dbSkip()
				EndDo
			EndIf
					
		EndIf
		RestArea(aSaveRAI)
		
	EndIf

	Impr("","C")	    
	lFirst := .F.             

	dbSelectArea("RAI")
	dbSetOrder(1)
	While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
			RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE + RAI->RAI_QUESTAO ) == ;
			( RAI->RAI_FILIAL + cCalend + cCurso + cTurma + cMat + cTeste + cQuestao)

		dbSkip()
	EndDo		
EndDo

IMPR("","C") 

If cTipo == "AVA" .Or. cTipo == "EFI"
	cDet := Space(02)+STR0012+" "+Str(nNota,6,2) 				//"Total de Pontos: "
	cDet += Space(73)+STR0017+" "+Str(( nNota / nItem ),6,2)	//"Media: "
	IMPR(cDet,"C")
Else
	IMPR(Space(02)+STR0012+Space(88)+Str(nNota,6,2),"C")		//"Total de Pontos: "
EndIf

If cCalend == RAI->RAI_CALEND .Or. Empty(RAI->RAI_CALEND)
	IMPR(Repl("-",Colunas-2),"C",,,02)
Else
	IMPR("","C")
EndIf

Return Nil
