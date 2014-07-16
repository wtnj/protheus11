#include "rwmake.ch"        
#INCLUDE "MSOLE.CH"
#INCLUDE "CERT.CH"

User Function CERT()        

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL,CXINSTRU,CXLOCAL")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Certif   ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 02.02.00 ³±±
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
//³ mv_par11         Situacao Folha               ³
//³ mv_par12         Turma De                     ³
//³ mv_par13         Turma Ate                    ³
//³ mv_par14         1-Impressora / 2-Arquivo     ³
//³ mv_par15         Nome do arquivo de saida     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("CERTIF",.F.)

cCadastro 	:= OemtoAnsi(STR0001) //"Integra‡„o com MS-Word"
aSays	  	:= {}
aButtons  	:= {}

AADD(aSays,OemToAnsi(STR0002) )  //"Esta rotina ir  imprimir os certificados dos cursos realizados "

AADD(aButtons, { 5,.T.,{|| Pergunte("CERTIF",.T. )}})
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
±±³Descri‡„o ³ Relatorio de Certificados dos cursos  - VIA WORD           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static FUNCTION WORDIMP()

// Seleciona Arquivo Modelo 
cType := "CERTIF     | *.DOT"
cArquivo := cGetFile(cType, OemToAnsi(STR0003+Subs(cType,1,6)),,,.T.,GETF_ONLYSERVER )//"Selecione arquivo "

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
nPag 		:= 0

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

cInicio 	:= "RA4->RA4_FILIAL+RA4->RA4_CALEND"
cFim		:= mv_par02+mv_par08
cFil		:= If (xFilial("RA4") = Space(2), Space(2), mv_par01)
   
dbSelectArea("RA4")
dbSetOrder(3)        
dbSeek(cFil+mv_par07,.T.)
While ! Eof() .And. &cInicio <= cFim       

	If 	RA4->RA4_FILIAL	< mv_par01 .Or. RA4->RA4_FILIAL > mv_par02 .Or.;
		RA4->RA4_CURSO  < mv_par09 .Or. RA4->RA4_CURSO  > mv_par10 .Or.;
		RA4->RA4_CALEND < mv_par07 .Or. RA4->RA4_CALEND > mv_par08	.Or.;
		RA4->RA4_TURMA 	< mv_par12 .Or.	 RA4->RA4_TURMA > mv_par13
		
		dbSkip()
		Loop
	EndIf
	
    dbSelectArea("RA2")
    dbSetOrder(1)        
	cFil	:= If (xFilial("RA2") = Space(2), Space(2), RA4->RA4_FILIAL)
	cXInstru:= ""
	cXLocal	:= ""
    If dbSeek(cFil+RA4->RA4_CALEND)
    
    	While !Eof() .And. RA4->RA4_CALEND == RA2->RA2_CALEND
    		If (RA4->RA4_CURSO+RA4->RA4_TURMA != RA2->RA2_CURSO+RA2_TURMA) 
    		
    			dbSelectArea("RA2")
    			dbSkip()
    			Loop
    		EndIf
			cXInstru:= RA2->RA2_INSTRU
	//	   	cXLocal := RA2->RA2_LOCAL  
			exit
		EndDo
	EndIf
	
	cXLocal := Fdesc("RA0",RA4->RA4_ENTIDA,"RA0_DESC")
  	
  	dbSelectArea("SRA")
   	dbSetOrder(1)
   	If dbSeek(RA4->RA4_FILIAL+RA4->RA4_MAT)
    	
		If SRA->RA_MAT < mv_par05 .Or.;
			SRA->RA_MAT > mv_par06 .Or.;
			SRA->RA_CC < mv_par03 .Or.;
			SRA->RA_CC > mv_par04 .Or.;
			!(SRA->RA_SITFOLH $ mv_par11)
					
			dbSelectArea("RA4")
			dbSkip()
			Loop
		EndIf		     	
		
		dbSelectArea("RA7")
		cFil:= If (xFilial("RA7") = Space(2), Space(2), RA4->RA4_FILIAL)
		dbSeek(cFil+cXInstru)
				
		// Variaveis a serem usadas na Montagem do Documento no Word    
		//--Cadastro Funcionario
		OLE_SetDocumentVar(oWord,"cNomeFun",SRA->RA_NOME)

		//--Curso 
		OLE_SetDocumentVar(oWord,"cLocal" ,cXLocal)
		OLE_SetDocumentVar(oWord,"cCurso" ,POSICIONE("RA1",1,xFilial("RA1")+RA4->RA4_CURSO,"RA1->RA1_DESC"))
		OLE_SetDocumentVar(oWord,"dInicio",RA4->RA4_DATAIN)
		OLE_SetDocumentVar(oWord,"dFim"   ,RA4->RA4_DATAFI)

		//--Data atual
		OLE_SetDocumentVar(oWord,"cDia"	, StrZero(Day(RA4->RA4_DATAFI),2))
		OLE_SetDocumentVar(oWord,"cAno"	, StrZero(Year(RA4->RA4_DATAFI),4))
		OLE_SetDocumentVar(oWord,"cMes"	, MesExtenso(Month(RA4->RA4_DATAFI)))
				
		//--Instrutor
		OLE_SetDocumentVar(oWord,"cInstrutor"	, RA7->RA7_NOME) 
		
		//--Sinonimo de Curso
		OLE_SetDocumentVar(oWord,"cSinon"	, Fdesc("RA9", RA4->RA4_SINONI, "RA9_DESCR"))
	
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
			
	dbSelectArea("RA4")
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
