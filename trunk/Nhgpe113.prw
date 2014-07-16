/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE113  ºAutor  ³Marcos R. Roquitski º Data ³  10/11/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Declaracao de Assalariado.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "MSOLE.CH"

User Function Nhgpe113()

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL,CXINSTRU,CXLOCAL,_aExtras")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS")
SetPrvt("_nSalm2,_nSalf2,_nSale2,_nSalo2,_nSalm1,_nAno,_nMes,_cAnoMes,_nSalf2,_nSale2,_nSalo2")


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

Pergunte("GPE055",.F.)

cCadastro 	:= OemtoAnsi("Integracao com MS-Word")
aSays	  	:= {}
aButtons  	:= {}
_aExtras    := {}

AADD(aSays,OemToAnsi("Esta rotina ir  imprimir os certificados dos cursos realizados "))

AADD(aButtons, { 5,.T.,{|| Pergunte("GPE055",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| WORDIMP()})
Endif
	
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
Local _cDescf := Space(20)
Local i

SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))

// Seleciona Arquivo Modelo 
cArquivo := "\system\reajuste.dot"

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

lImpress	:= .F.               // Verifica se a saida sera em Tela ou Impressora
cArqSaida	:= "REAJUSTE"        // Nome do arquivo de saida
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

DbSelectArea("SRA")
DbSetOrder(01)
SRD->(DbSetOrder(1))
SRC->(DbSetOrder(1))
SRJ->(DbSetOrder(1))
SR3->(DbSetOrder(1))
SR7->(DbSetOrder(1))
CTT->(DbSetOrder(1))

SRA->(DbSeek(xFilial("SRA")+mv_par01))
While SRA->(!Eof()) .and. SRA->RA_MAT>=mv_par01 .and. SRA->RA_MAT<=mv_par02

	//--Cadastro Funcionario
	OLE_SetDocumentVar(oWord,"cNomeFun",SRA->RA_NOME)

	_cDescf := Space(20)
	SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
	If SRJ->(Found())
		_cDescf := SRJ->RJ_DESC
	Endif		
	
	_cDescCusto := Space(30)
	CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
	If CTT->(Found())
		_cDescCusto := CTT->CTT_DESC01
	Endif		
	
	dDatalt  := Ctod(Space(8))
	cDescFu  := Space(30)
	_nSalnov := 0

	SR7->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))
	While SR7->(!Eof()) .and. SR7->R7_MAT==SRA->RA_MAT
		SR3->(DbSeek(SR7->R7_FILIAL+SR7->R7_MAT+dTos(SR7->R7_DATA),.T.))
		If SR3->R3_MAT==SR7->R7_MAT .AND. dTos(SR3->R3_DATA)==dTos(SR7->R7_DATA)
			dDatalt := SR3->R3_DATA
			cDescFu := SR7->R7_DESCFUNC
			_nSalnov := SR3->R3_VALOR
		Endif
		SR7->(Dbskip())
	Enddo
	_nPerCent := 0
	If SR3->(!Eof())
		SR3->(Dbskip(-1))
		_nVlrAnt  := SR3->R3_VALOR
		_nPerCent := (_nSalnov / _nVlrAnt * 100) - 100
	Endif

	OLE_SetDocumentVar(oWord,"Funcao",_cDescf)
	OLE_SetDocumentVar(oWord,"Matricula",SRA->RA_MAT)
	OLE_SetDocumentVar(oWord,"Admissa",DTOC(SRA->RA_ADMISSA))
	OLE_SetDocumentVar(oWord,"Ctps",SRA->RA_NUMCP+" "+SRA->RA_SERCP+" - "+SRA->RA_UFCP)
	OLE_SetDocumentVar(oWord,"CCusto",SRA->RA_CC)
	OLE_SetDocumentVar(oWord,"CDescCusto",_cDescCusto)
	OLE_SetDocumentVar(oWord,"dDatalt",dDatalt)
	OLE_SetDocumentVar(oWord,"cDescFu",cDescFu)
	OLE_SetDocumentVar(oWord,"nSalnov",Transform(_nSalnov,"@E 999,999.99")+ " "+IIF(SRA->RA_CATFUNC=='M'," P\MES"," P\HORA"))
	OLE_SetDocumentVar(oWord,"nPercent",Transform(_nPerCent,"@E 999.99")+ "%")
	

	//--Atualiza Variaveis
	OLE_UpDateFields(oWord)

	//Alterar nome do arquivo para Cada Pagina do arquivo para evitar sobreposicao.
	nPag ++ 
	cArqPag := cArqSaida + Strzero(nPag,3)

	//-- Imprime as variaveis				
	IF lImpress
		OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 ) 
	Else       
		Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento " +cArqPag+ " ou clique no botao para fechar.", {"Fechar"}) //"Alterne para o programa do Ms-Word para visualizar o documento "###" ou clique no botao para fechar."###"Fechar"
		OLE_SaveAsFile( oWord, cArqPag )
	EndIF
	
	dbSelectArea("SRA")
	dbSkip()	

Enddo

OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return
