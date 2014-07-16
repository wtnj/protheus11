#include "rwmake.ch"        
#INCLUDE "MSOLE.CH"
#INCLUDE "CONVIT.CH"

User Function CONVIT()       

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ convite  ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio                        - VIA WORD                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros usados na rotina                   ³
//³ mv_par01         Filial   De                  ³
//³ mv_par02         Filial   Ate                 ³
//³ mv_par03         C.Custo  De                  ³
//³ mv_par04         C.Custo  Ate                 ³
//³ mv_par05         Matricula De                 ³
//³ mv_par06         Matricula Ate                ³
//³ mv_par07         Calendario De                ³
//³ mv_par08         Calendario Ate               ³
//³ mv_par09         Curso De                     ³
//³ mv_par10         Curso Ate                    ³   
//³ mv_par11         Turma De 	                  ³   
//³ mv_par12         Turma Ate 	                  ³   
//³ mv_par13         Situacao Folha               ³ 
//³ mv_par14         1-Impressora / 2-Arquivo     ³
//³ mv_par15         Nome do arquivo de saida     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("CONVIT",.F.)

cCadastro := OemtoAnsi(STR0001) //"Integra‡„o com MS-Word"
aSays	  :={}
aButtons  :={}

AADD(aSays,OemToAnsi(STR0002) ) //"Esta rotina ir  imprimir os convites dos cursos realizados "

AADD(aButtons, { 5,.T.,{|| Pergunte("CONVIT",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| WORDIMP()})  // Chamada do Processamento// Substituido pelo assistente de conversao do AP5 IDE em 14/02/00 ==> 	Processa({|| Execute(WORDIMP)})  // Chamada do Processamento
EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WORDIMP  ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 31.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de convites dos cursos  - VIA WORD               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static FUNCTION WORDIMP()

// Seleciona Arquivo Modelo 
cType 		:= "CONVITE     | *.DOT"
cArquivo 	:= cGetFile(cType, OemToAnsi(STR0003+Subs(cType,1,6)),,,.T.,GETF_ONLYSERVER )//"Selecione arquivo "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copiar Arquivo .DOT do Server para Diretorio Local ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos := Rat("\",cArquivo)
If nPos > 0
	cArqLoc := AllTrim(Subst(cArquivo, nPos+1,20 ))
Else 
	cArqLoc := cArquivo
EndIF
cPath := GETTEMPPATH()
If Right( AllTrim(cPath), 1 ) != "\"
   cPath += "\"
Endif
If !CpyS2T(cArquivo, cPath, .T.)
	Return
Endif

lImpress	:= ( mv_par14 == 1 )	// Verifica se a saida sera em Tela ou Impressora
cArqSaida	:= AllTrim( mv_par15 )	// Nome do arquivo de saida

// Inicia o Word 
nVez := 1

// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		

OLE_NewFile(oWord,cPath+cArqLoc)

If lImpress
	OLE_SetProperty( oWord, oleWdVisible,   .F. )
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
Else
	OLE_SetProperty( oWord, oleWdVisible,   .T. )
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )
EndIf
	
cInicio := "RA3->RA3_FILIAL+RA3->RA3_CALEND"
cFim	:= mv_par02+mv_par08
cFil	:= If (xFilial("RA3") = Space(2), Space(2), mv_par01)
nPag	:= 0

dbSelectArea("RA3")   
dbSetOrder(2)
dbSeek(cFil+mv_par07,.T.)
While ! Eof() .And. &cInicio <= cFim       
	IF  RA3->RA3_FILIAL	< mv_par01 .Or. RA3->RA3_FILIAL > mv_par02 .Or.;
		RA3->RA3_CALEND	< mv_par07 .Or. RA3->RA3_CALEND > mv_par08 .Or.;
		RA3->RA3_CURSO 	< mv_par09 .Or. RA3->RA3_CURSO > mv_par10	.Or.;
		RA3->RA3_TURMA 	< mv_par11 .Or. RA3->RA3_TURMA > mv_par12	.Or.;
		RA3->RA3_RESERV != "R"
	
		dbSkip()
		Loop
	Endif
	
    dbSelectArea("RA2")
    dbSetOrder(1)        
	cFil	:= If (xFilial("RA2") = Space(2), Space(2), RA3->RA3_FILIAL)
    If dbSeek(cFil+RA3->RA3_CALEND)
    
    	While !Eof() .And. RA3->RA3_CALEND == RA2->RA2_CALEND
    		If (RA3->RA3_CURSO+RA3->RA3_TURMA != RA2->RA2_CURSO+RA2_TURMA) 
    		
    			dbSelectArea("RA2")
    			dbSkip()
    			Loop
    		EndIf
			If RA2->RA2_REALIZA == "S"
	
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
			exit
		EndDo
	Else     
		dbSelectArea("RA3")
		dbSkip()
		Loop	
	EndIf
   			
	dbSelectArea("SRA")
	dbSetOrder(1)
	If dbSeek(RA3->RA3_FILIAL+RA3->RA3_MAT)
	    	
		If 	SRA->RA_CC < mv_par03 .Or.;
			SRA->RA_CC > mv_par04 .Or.;
			SRA->RA_MAT < mv_par05 .Or.;
			SRA->RA_MAT > mv_par06 .Or.;
			!(SRA->RA_SITFOLH $ mv_par13)

			dbSelectArea("RA3")
			dbSkip()
			Loop
		EndIf		     	
		                                         
		dbSelectArea("RA1")
		cFil:= If (xFilial("RA1") = Space(2), Space(2), SRA->RA_FILIAL)
		dbSeek(cFil+RA3->RA3_CURSO)
				
		dbSelectArea("RA7")
		cFil:= If (xFilial("RA7") = Space(2), Space(2), SRA->RA_FILIAL)
		dbSeek(cFil+RA2->RA2_INSTRU)
				
		dbSelectArea("SI3")
		cFil:= If (xFilial("SI3") = Space(2), Space(2), SRA->RA_FILIAL)
		dbSeek(cFil+SRA->RA_CC)
				
		dbSelectArea("RA0")
		cFil:= If (xFilial("RA0") = Space(2), Space(2), SRA->RA_FILIAL)				
		dbSeek(cFil+RA2->RA2_ENTIDA)
				
		// Variaveis a serem usadas na Montagem do Documento no Word    
		//--Cadastro Funcionario
		OLE_SetDocumentVar(oWord,"cNome",SRA->RA_NOME)
		OLE_SetDocumentVar(oWord,"cMat" ,SRA->RA_MAT)
		
		//--Centro de Custo                            
		OLE_SetDocumentVar(oWord,"cCC",SI3->I3_DESC)

		//--Curso 
		OLE_SetDocumentVar(oWord,"cLocal" 	,RA2->RA2_LOCAL)
		OLE_SetDocumentVar(oWord,"cCurso" 	,RA1->RA1_DESC)
		OLE_SetDocumentVar(oWord,"dInicio"	,RA2->RA2_DATAIN)
		OLE_SetDocumentVar(oWord,"dFim"		,RA2->RA2_DATAFI)
		OLE_SetDocumentVar(oWord,"cHorario"	,RA2->RA2_HORARI)
		OLE_SetDocumentVar(oWord,"cEntidade",RA0->RA0_DESC)

		//--Data atual
		OLE_SetDocumentVar(oWord,"cDia"	, StrZero(Day(dDataBase),2))
		OLE_SetDocumentVar(oWord,"cAno"	, StrZero(Year(dDataBase),4))
		OLE_SetDocumentVar(oWord,"cMes"	, MesExtenso(Month(dDataBase)))

		//--Sinonimo de Curso
		OLE_SetDocumentVar(oWord,"cSinon" ,Fdesc("RA9", RA2->RA2_SINON, "RA9_DESCR"))		
						
		//--Atualiza Variaveis
		OLE_UpDateFields(oWord)
        
		//Alterar nome do arquivo para Cada Pagina do arquivo para evitar sobreposicao.
		nPag ++ 
		cArqPag := cArqSaida + Strzero(nPag,3)

		//-- Imprime as variaveis				
		IF lImpress
			OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 ) 
		Else
			Aviso("", STR0004 +cArqPag+ STR0005, {STR0006}) //"Alterne para o programa do Ms-Word para visualizar o documento "###" ou clique no botao para fechar."###"Fechar"
			OLE_SaveAsFile( oWord, cArqPag )
		EndIF

	EndIf	
			
	dbSelectArea("RA3")
	dbSkip()	
EndDo

OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return
