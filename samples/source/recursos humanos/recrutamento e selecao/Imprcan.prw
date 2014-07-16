#INCLUDE "Protheus.CH"
#INCLUDE "IMPRCAN.CH"
#INCLUDE "MSOLE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRCAN  ³ Autor ³ Desenvolvimento R.H.  ³ Data ³ 21.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Ficha do Candidato                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Imprcan(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rwmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³			   ³		³	   ³										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function IMPRCAN(aCand)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais 		                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca		:= 	0 
Local aSays 	:= {}
Local aButtons	:= {}

Default aCand := {}	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE		                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := { STR0007, 1,STR0008, 2, 2, 1, "",1 }  //"Zebrado"###"Administra‡„o"
PRIVATE nomeprog:= "IMPRCAN"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "IMPCAN"
PRIVATE oPrint
PRIVATE lFirst 	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo  := STR0009 //"FICHA DO CANDIDATO"
PRIVATE cCabec  := ""
PRIVATE AT_PRG  := "IMPRCAN"
PRIVATE wCabec0 := 0       					//NUMERO DE CABECALHOS QUE O PROGRAMA POSSUI. EX.:2//
PRIVATE wCabec1 := ""
PRIVATE CONTFL	:= 1						//CONTA PAGINA
PRIVATE LI		:= 0
PRIVATE nTamanho:= "P" 		                //TAMANHO DO RELATORIO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis PRIVATE utilizadas para Impressao Grafica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nPos	:= 0						//LINHA DE IMPRESSAO DO RELATORIO GRAFICO
PRIVATE cVar    := ""
PRIVATE nLinha	:= 0
PRIVATE cLine	:= ""
Private cFont	:= ""						//FONTES UTILIZADAS NO RELATORIO
Private aFotos	:= {}						//armazena nome  foto 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cIndCond:= ""
PRIVATE cFor	:= ""
PRIVATE nOrdem  := 0
PRIVATE aInfo 	:= {}
PRIVATE lAchou 	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oFont07,oFont09, oFont10, oFont10n, oFont11,oFont15, oFont16,oFont18
                                                  
//<oFont> := TFont():New( <cName>, <nWidth>, <nHeight>, <.from.>,[<.bold.>],<nEscapement>,,<nWeight>,;
// 						  [<.italic.>],[<.underline.>],,,,,, [<oDevice>] )

oFont07	:= TFont():New("Courier New",07,07,,.F.,,,,.F.,.F.)
oFont09	:= TFont():New("Tahoma",09,09,,.F.,,,,.F.,.F.)
oFont10	:= TFont():New("Tahoma",10,10,,.F.,,,,.F.,.F.)
oFont10n:= TFont():New("Courier New",10,10,,.T.,,,,.F.,.F.)
oFont11	:= TFont():New("Tahoma",11,11,,.T.,,,,.F.,.F.)		//Normal s/negrito
oFont15	:= TFont():New("Courier New",15,15,,.T.,,,,.F.,.F.)
oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.F.,.F.)
oFont18	:= TFont():New("Arial",18,18,,.T.,,,,.F.,.T.)

// Correcao de SX1
ImpAcertSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("IMPCAN",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Curriculo De                             ³
//³ mv_par04        //  Curriculo Ate                            ³
//³ mv_par05        //  Area De                                  ³
//³ mv_par06        //  Area  Ate                                ³
//³ mv_par07        //  Nome De                                  ³
//³ mv_par08        //  Nome Ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "IMPRCAN"            //Nome Default do relatorio em Disco

If Len(aCand) == 0	//Pelo menu

	AADD(aSays,OemToAnsi(STR0002) )  //"Ser  impresso de acordo com os parametros solicitados pelo"
	AADD(aSays,OemToAnsi(STR0003) )  //"usuario."
	
	AADD(aButtons, { 5,.T.,{|| Pergunte("IMPCAN",.T. ) } } )  
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}} )
	AADD(aButtons, { 2,.T.,{|o| nOpca := 0,FechaBatch()}} )
	
	FormBatch( STR0001, aSays, aButtons )	//"Ficha do Candidato"
	
	If nOpca == 0
		Return Nil
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordem do Relatorio                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FilialDe	:= mv_par01
FilialAte	:= mv_par02
CcurriDe 	:= mv_par03
CcurriAte	:= mv_par04
cAreaDe   	:= mv_par05
cAreaAte   	:= mv_par06
NomDe    	:= Upper(mv_par07)
NomAte   	:= Upper(mv_par08)

If nLastKey = 27
	Return
Endif

Titulo := STR0009 	//"FICHA DO CANDIDATO"

RptStatus({|lEnd| ResuImp(@lEnd,aCand)},Titulo) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ResuImp  ³ Autor ³ Desenvolvimento R.H.  ³ Data ³ 21.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamanto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ResuImp(lEnd,aCand) 			                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        	- A‡Æo do Codelock                            ³±±
±±³          ³ aCand		- Array com codigo dos curriculos.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RWMAKE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ResuImp(lEnd,aCand)
Local cAcessaSQG  := &("{ || " + ChkRH("IMPRCAN","SQG","2") + "}")

Local nx := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao das Ordens de Impressao, onde sera definido ³
//³o Inicio e Fim da impressao do Arquivo                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea( "SQG" )       		//SQG - CADASTRO DE CURRICULO
         
If Len(aCand) == 0
	If nOrdem == 1
		dbSetOrder(1)
		dbSeek(XFILIAL("SQG",FilialDe) + cCurriDe,.T.)
		
		cInicio  := "SQG->QG_FILIAL + SQG->QG_CURRIC"	//Ordem de Codigo do Curriculo
		cFim     := FilialAte + cCurriAte
		
	ElseIf nOrdem == 2
		dbSetOrder(5)
		dbSeek(XFILIAL("SQG",FilialDe) + NomDe,.T.)
		
		cInicio  := "SQG->QG_FILIAL + SQG->QG_NOME"   	//Ordem de Nome
		cFim     := FilialAte + NomAte
		
	Endif
EndIf
	
SetRegua(SQG->(RecCount()))

cFilAnterior := "!!"
cCcAnt       := "!!!!!!!!!"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se receber parametros (Chamada pela Pesquisa de Candiatos)   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCand) > 0
	dbSelectArea("SQG")
	dbSetOrder(1)
	For nx := 1 To Len(aCand)
		If dbSeek(xFilial("SQG")+aCand[nx])		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Movimenta Regua de Processamento                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncRegua(STR0011+SQG->QG_FILIAL + " "+STR0017+SQG->QG_CURRIC) //"Filial: "###"Curriculo: "
			
			If lEnd
				@Prow()+1,0 PSAY cCancel
				Exit
			Endif
				
			lAchou:= .T.
			
			wCabec1 :=Titulo //"FICHA DO CANDIDATO"
			
			CabecGraf()
			ImpGraf()
			
		EndIf
    Next nx


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao receber parametros (Chamada pelo menu)		         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
Else             
	dbSelectArea("SQG")
	While !EOF() .And. &cInicio <= cFim
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua de Processamento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc(STR0011+SQG->QG_FILIAL + " "+STR0017+SQG->QG_CURRIC) //"Filial: "###"Curriculo: "
		
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  ( SQG->QG_CURRIC < CCurriDe )  	.Or. ( SQG->QG_CURRIC > CCurriAte )		.Or. ;
			( SQG->QG_AREA < cAreaDe )     	.Or. ( SQG->QG_AREA > cAreaAte )   		.Or. ;
			( Upper(SQG->QG_NOME) < NomDe )	.Or. ( Upper(SQG->QG_NOME) > NomAte )
			
			dbSelectArea( "SQG" )
			dbSkip()
			Loop
		Endif
	
		lAchou:= .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SQG->QG_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSQG)
			dbSelectArea( "SQG" )
			dbSkip()
			Loop
		EndIf
		
		wCabec1 :=Titulo //"FICHA DO CANDIDATO"
		
		CabecGraf()
		ImpGraf()
		
		dbSelectarea("SQG")
		dbSkip()
		
	Enddo
	
EndIf
Impr(" ","F")

dbSelectArea("SQG")
dbSetOrder(1)
dbGoTop()

If lAchou
	oPrint:Preview()        // Visualiza impressao grafica antes de imprimir
	MS_FLUSH()

	//-- Apaga BMP Foto do Diretorio
	For nx := 1 to Len(aFotos)
		IF File(aFotos[nx])
			fErase( aFotos[nx])
		Endif	
	next nx		
	
Else
	 Aviso(STR0064, STR0065, {'Ok'})
Endif
                         
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CabecGraf ³ Autor ³ Desenvolvimento R.H.	³ Data ³ 03.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do CABECALHO Modo Grafico                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION CabecGraf()

If !lFirst
	lFirst		:= .T.
	oPrint 		:= TMSPrinter():New("FICHA DO CANDIDATO")
	oPrint:SetPortrait()            //Define que a impressao deve ser RETRATO//
Endif

oPrint:StartPage() 			// Inicia uma nova pagina
cFont:=oFont09

//Box Itens
oPrint:Box(035 ,035 ,3000,2350)        //DESENHA O CONTORNO DA FOLHA

oPrint:say (045 ,040 ,(SM0->M0_NOME),cFont)
oPrint:say (045 ,2085,(RPTFOLHA+" "+TRANSFORM(ContFl,'999999')),cFont)
oPrint:say (080 ,040 ,"SIGA / "+nomeprog+"/V."+cVersao+"    ",cFont)
oPrint:say (120 ,800 ,(TRIM(TITULO)),oFont18)
oPrint:say (215 ,040 ,(RPTHORA+" "+TIME()),cFont)
oPrint:say (215 ,2060,(RPTEMISS+" "+DTOC(MSDATE())),cFont)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados Pessoais                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos   := 260

fFoto()
	
oPrint:line(nPos ,035 ,260 ,2350)					//Linha Horizontal
nPos+=05
oPrint:say (265 ,040 ,STR0023,cFont) 				//Dados Pessoais

nPos+=40
oPrint:line(310 ,035 ,310 ,2350)					//Linha Horizontal

nPos+=50
oPrint:say (nPos ,0500 ,STR0017,cFont) 				//CURRICULO
oPrint:say (nPos ,0750 ,SQG->QG_CURRIC,cFont)

nPos+=50
oPrint:say (nPos ,0500 ,STR0014,cFont)  			//NOME
oPrint:say (nPos ,0750 ,SQG->QG_NOME,cFont)

oPrint:say (nPos ,1500,STR0020,cFont) 				//DATA DE NASCIMENTO
oPrint:say (nPos ,1700,(DtoC(SQG->QG_DTNASC)),cFont)

nPos+=50
oPrint:say (nPos ,0500 ,STR0012,cFont)				//ENDERECO
oPrint:say (nPos ,0750 ,SQG->QG_ENDEREC,oFont09)

oPrint:say (nPos ,1500,STR0015,cFont)				//COMPLEMENTO
oPrint:say (nPos ,1700,SQG->QG_COMPLEM,oFont09)

nPos+=50   

IF Empty( cBmpPict := Upper( AllTrim( SQG->QG_BITMAP ) ) )
	oPrint:say (nPos ,0200,STR0071,cFont)			//FOTO
EndIf

oPrint:say (nPos ,0500,STR0019,cFont)				//CEP
oPrint:say (nPos ,0750 ,SQG->QG_CEP,cFont)

oPrint:say (nPos ,1500 ,STR0038,cFont)  			//BAIRRO
oPrint:say (nPos ,1700 ,SQG->QG_BAIRRO,cFont)

nPos+=50
oPrint:say (nPos ,0500,STR0029,cFont)				//MUNICIPIO
oPrint:say (nPos ,0750,(ALLTRIM(SQG->QG_MUNICIP)),cFont)

oPrint:say (nPos ,1500,STR0018,cFont)  				//ESTADO
oPrint:say (nPos ,1700,(ALLTRIM(SQG->QG_ESTADO)),cFont)

nPos+=50
oPrint:say (nPos ,0500 ,STR0039, cFont)	 			//CARGO PRETENDIDO
oPrint:say (nPos ,0750 ,SQG->QG_DESCFUN,cFont)

oPrint:say (nPos ,1500 ,STR0022,cFont)				//PRET.SALARIAL
oPrint:say (nPos ,1700,(Alltrim(TRANSFORM(SQG->QG_PRETSAL,"@E 999,999,999.99"))),cFont)

nPos+=50
oPrint:say (nPos ,0500,STR0040,cFont)				//ULTIMO SALARIO
oPrint:say (nPos ,0750,(Alltrim(TRANSFORM(SQG->QG_ULTSAL,"@E 999,999,999.99"))),cFont)

oPrint:say (nPos ,1500 ,STR0016,cFont)				//Fone
oPrint:say (nPos ,1700 ,ALLTRIM(SQG->QG_FONE),cFont)

If SQG->(FieldPos("QG_FONECEL")) > 0 .And. SQG->(FieldPos("QG_EMAIL")) > 0
	nPos+=50
	oPrint:say (nPos ,0500 	,STR0067,cFont)				//Celular
	oPrint:say (nPos ,0750	,(Alltrim(SQG->QG_FONECEL)),cFont)

	oPrint:say (nPos ,1500	,STR0068,cFont)  			//e-mail
	oPrint:say (nPos ,1700	,(ALLTRIM(SQG->QG_EMAIL)),cFont)
EndIf

If SQG->(FieldPos("QG_FONTE")) > 0 .And. SQG->(FieldPos("QG_INDICAD")) > 0        
	nPos+=50
	oPrint:say (nPos ,0500	,STR0069,cFont)  			//Fonte Recrutam.
	oPrint:say (nPos ,0750	,ALLTRIM(SQG->QG_FONTE)+"-"+fDesc("SX5","RT"+SQG->QG_FONTE,"X5DESCRI()",30,,),cFont)
			
	oPrint:say (nPos ,1500	,OemToAnsi(STR0070),cFont)  			//Indicacao
	oPrint:say (nPos ,1700	,ALLTRIM(SQG->QG_INDICAD),cFont)
EndIf

nPos+=50
oPrint:line(nPos ,035,nPos,2350)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpGraf  ³ Autor ³ Desenvolvimento R.H.	³ Data ³ 03.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Modo Grafico FICHA DO CANDIDATO                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  ImpGraf()

Local aVagas	:= {}
Local i			:= 0
Local nX		:= 0
Local nLi   	:= 0
Local nQuest	:= 0   
Local aSaveArea := GetArea()
Local lVaga		:= ( SQR->(FieldPos("QR_VAGA")) > 0 ) .And. ( SQR->(FieldPos("QR_DATA")) > 0 )

Local cVaga		:= ""
Local dData     := Ctod("")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXPERIENCIA PROFISSIONAL                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLi := Imprcanlin("SQG",1)  
If nPos+nLi < 2790 .And. nLi < 2770
	cFont:=oFont09
	nPos+=05
	oPrint:say (nPos ,040 ,STR0041,cFont)	//EXPERIENCIA
	nPos+=40
	oPrint:line(nPos ,035 ,nPos,2350)		//Linha Horizontal
	nPos+=35 
Else
	oPrint:EndPage()
	oPrint:StartPage()		// Inicia uma nova pagina
	ContFl++
	
	CabecGraf()  
	cFont:=oFont09
	nPos+=05
	oPrint:say (nPos ,040 ,STR0041,cFont)	//EXPERIENCIA
	nPos+=40
	oPrint:line(nPos ,035 ,nPos,2350)		//Linha Horizontal
	nPos+=35
EndIf

cVar   := MSMM(SQG->QG_EXPER,,,,3)    			//Campo MEMO
nLinha := MlCount(cVar,110)

For i:=1 to nLinha
	
	cLine := Space(05)+Memoline(cVar,110,i,,.T.)
	If nPos>=2700 .And. Len(cline) >= nPos
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf()
	Endif
	
	nLi := Imprcanlin("SQG",1)
	If nPos+nLi < 2790 .And. nLi < 2770
		oPrint:say (nPos,040 ,cLine,cFont)
		nPos+=50 
	Else
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf()  
		
		cFont:=oFont09
		nPos+=05
		oPrint:say (nPos ,040 ,STR0041,cFont)	//EXPERIENCIA
		nPos+=40
		oPrint:line(nPos ,035 ,nPos,2350)		//Linha Horizontal
		nPos+=35
		
		oPrint:say (nPos,040 ,cLine,cFont)
		nPos+=50 
	EndIf	
Next i 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ANALISE DO CANDIDATO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLi := Imprcanlin("SQG",2)
If nPos+nLi < 2790 .And. nLi < 2770
	oPrint:line(nPos,035 ,nPos,2350)		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0026,cFont)	//ANALISE
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35 
Else
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()
	  
	oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0026,cFont)				//ANALISE
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
	nPos+=35 
EndIf

cVar   := MSMM(SQG->QG_ANALISE,,,,3)      			//Campo MEMO
nLinha := MlCount(cVar,110)

For i := 1 to nLinha
	cLine:= Space(05)+Memoline(cVar,110,i,,.T.)
	
	nLi := Imprcanlin("SQG",1)
	If nPos+nLi < 2790 .And. nLi < 2770
		oPrint:say(nPos,040 ,cLine,cFont)
	    nPos+=50 
	Else
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf() 
		
		oPrint:line(nPos,035 ,nPos,2350)		//Linha Horizontal
		nPos+=05
		oPrint:say (nPos,040 ,STR0026,cFont)	//ANALISE
		nPos+=40
		oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
		nPos+=35
		 
		oPrint:say (nPos,040 ,cLine,cFont)
		nPos+=50 
	EndIf
	
	If 	nPos>=2800
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf()
	Endif
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³HISTORICO PROFISSIONAL                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLi := Imprcanlin("SQL",3)
If nPos+nLi < 2790 .And. nLi < 2770
	oPrint:line(nPos,035 ,nPos,2350)		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0028,cFont)	//HISTORICO PROFISSIONAL
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35
Else
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()  
	
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0028,cFont)	//HISTORICO PROFISSIONAL
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35 
EndIf

dbSelectArea("SQL")							//SQL - HISTORICO PROFISSIONAL
dbSetOrder(1)
dbSeek(xFilial("SQL")+SQG->QG_CURRIC)
While !Eof() .And. xFilial("SQL")+SQL->QL_CURRIC == SQG->QG_FILIAL+SQG->QG_CURRIC

	nLi := Imprcanlin("SQL",3)
	If nPos+nLi < 2790 .And. nLi < 2770
		oPrint:say(nPos,040,SPACE(05)+STR0010+(SQL->QL_EMPRESA),oFont10)			//"EMPRESA"
   		oPrint:say(nPos,040,SPACE(85)+STR0046+(SQL->QL_FUNCAO),oFont10)			//"FUNCAO"
		oPrint:say(nPos,040,SPACE(155)+STR0044+(Dtoc(SQL->QL_DTADMIS))+" / "+STR0045+(Dtoc(SQL->QL_DTDEMIS)),oFont10)	//"DT.ADM"###"DT.DEMISSA"
		nPos+=50 
	Else
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf()
		
		oPrint:line(nPos,035 ,nPos,2350)		//Linha Horizontal
		nPos+=05
		oPrint:say (nPos,040 ,STR0028,cFont)	//HISTORICO PROFISSIONAL
		nPos+=40
		oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
		nPos+=35
		  
		oPrint:say(nPos,040,SPACE(05)+STR0010+(SQL->QL_EMPRESA),oFont10)			//"EMPRESA"
		oPrint:say(nPos,040,SPACE(85)+STR0046+(SQL->QL_FUNCAO),oFont10)			//"FUNCAO"
		oPrint:say(nPos,040,SPACE(155)+STR0044+(Dtoc(SQL->QL_DTADMIS))+" / "+STR0045+(Dtoc(SQL->QL_DTDEMIS)),oFont10)	//"DT.ADM"###"DT.DEMISSA"
		nPos+=50
	EndIf	
	
	cVar   := MSMM(SQL->QL_ATIVIDA,,,,3)		//Campo MEMO
	nLinha := MlCount(cVar,110)
	
	For  i:=1 to nLinha
		
		If i=1
			nLi := Imprcanlin("SQL",3)
			If nPos+nLi < 2790 .And. nLi < 2770
				cLine:= Space(03)+Memoline(cVar,110,i,,.T.)
				oPrint:say(nPos,040 ,SPACE(05)+STR0030+cLine,cFont)
				nPos+=50 
			Else
				oPrint:EndPage()
				oPrint:StartPage() 			// Inicia uma nova pagina
				ContFl++
				
				CabecGraf()  
				cLine:= Space(03)+Memoline(cVar,110,i,,.T.)
				oPrint:say(nPos,040 ,SPACE(05)+STR0030+cLine,cFont)
				nPos+=50
			EndIf
		Else
			nLi := Imprcanlin("SQL",3)
			If nPos+nLi < 2790 .And. nLi < 2770
				cLine:= Space(05)+Memoline(cVar,110,i,,.T.)
				oPrint:say(nPos,200 ,cLine,cFont)
				nPos+=50
			Else
				oPrint:EndPage()
				oPrint:StartPage() 			// Inicia uma nova pagina
				ContFl++
				CabecGraf()  
				
				cLine:= Space(05)+Memoline(cVar,110,i,,.T.)
				oPrint:say(nPos,200 ,cLine,cFont)
		   		nPos+=50
			EndIf
		Endif
		
		If 	nPos>=2800
			oPrint:EndPage()
			oPrint:StartPage() 			// Inicia uma nova pagina
			ContFl++
			CabecGraf()
		Endif
		
	Next i
	
	dbSelectArea("SQL")
	dbSetOrder(1)
	dbSkip()
	
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CURSOS EXTRACURRICULARES                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLi := Imprcanlin("SQM",4)
If nPos+nLi < 2790 .And. nLi < 2770
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0034,cFont)	//CURSOS EXTRACURRICULARES
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35
Else
	oPrint:EndPage()
	oPrint:StartPage()			// Inicia uma nova pagina
	ContFl++
	CabecGraf()
	  
	oPrint:line(nPos,035 ,nPos,2350)		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0034,cFont)	//CURSOS EXTRACURRICULARES
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35
EndIf

dbSelectArea("SQM")							//SQM - CURSOS DO CURRICULO
dbSetOrder(1)
dbSeek(xFilial("SQM")+SQG->QG_CURRIC)
While !Eof() .And. xFilial("SQM")+SQM->QM_CURRIC == SQG->QG_FILIAL+SQG->QG_CURRIC
	
	nLi := Imprcanlin("SQM",4)
	If nPos+nLi < 2790 .And. nLi < 2770
		oPrint:say(nPos,040 ,SPACE(05)+STR0035+(SQM->QM_ENTIDAD),cFont)
		oPrint:say(nPos,040, SPACE(90)+STR0047+": "+(DTOC(SQM->QM_DATA)),cFont)
	Else
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf() 
		
		oPrint:line(nPos,035 ,nPos,2350) 				//Linha Horizontal
		nPos+=05
		oPrint:say (nPos,040 ,STR0034,cFont)			//CURSOS EXTRACURRICULARES
		nPos+=40
		oPrint:line(nPos,035 ,nPos,2350) 				//Linha Horizontal
		nPos+=35
		 
		oPrint:say(nPos,040 ,SPACE(05)+STR0035+(SQM->QM_ENTIDAD),cFont)
		oPrint:say(nPos,040, SPACE(90)+STR0047+": "+(DTOC(SQM->QM_DATA)),cFont)
	EndIf	
	
	dbSelectArea("SQT")			//SQT - CADASTRO DE CURSOS
	dbSetOrder(1)
	dbSeek(xFilial("SQT")+SQM->QM_CURSO)
	
	nLi := Imprcanlin("SQM",4)
	If nPos+nLi < 2790 .And. nLi < 2770
		oPrint:say(nPos,040,SPACE(140)+STR0048+SQM->QM_CURSO+" - "+SQT->QT_DESCRIC,cFont)
		nPos+=50
	Else
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf()  
		oPrint:say(nPos,040,SPACE(140)+STR0048+SQM->QM_CURSO+" - "+SQT->QT_DESCRIC,cFont)
		nPos+=50
	EndIf	
	
	dbSelectArea("SQM")
	dbSetOrder(1)
	dbSkip()
	
Enddo
If 	nPos>=2800
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³QUALIFICACOES                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLi := Imprcanlin("SQI",5)
If nPos+nLi < 2790 .And. nLi < 2770
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0024,cFont)	//QUALIFICACOES
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35
	oPrint:say (nPos,040 ,SPACE(05)+OemtoAnsi(STR0049),cFont)		//"Grupo"
	oPrint:say (nPos,040 ,SPACE(55)+OemToAnsi(STR0066),cFont)		//"Fator"
	oPrint:say (nPos,040 ,SPACE(125)+OemToAnsi(STR0050),cFont)		//"Grau" 
	oPrint:say (nPos,040 ,SPACE(195)+OemToAnsi(STR0047),cFont)		//"Dt. Formacao"
Else
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()  
	
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0024,cFont)	//QUALIFICACOES
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
	nPos+=35
	oPrint:say (nPos,040 ,SPACE(05)+OemtoAnsi(STR0049),cFont)		//"Grupo"
	oPrint:say (nPos,040 ,SPACE(55)+OemToAnsi(STR0066),cFont)		//"Fator"
	oPrint:say (nPos,040 ,SPACE(125)+OemToAnsi(STR0050),cFont)		//"Grau" 
	oPrint:say (nPos,040 ,SPACE(195)+OemToAnsi(STR0047),cFont)		//"Dt. Formacao"
EndIf

dbSelectArea("SQI")	 	//SQI - QUALIFICACAO DO CURRICULO					
dbSetOrder(1)                   
dbSeek(xFilial("SQI")+SQG->QG_CURRIC)
While !Eof() .And. xFilial("SQI")+SQI->QI_CURRIC == SQG->QG_FILIAL+SQG->QG_CURRIC
	nLi := Imprcanlin("SQI",5)
	If nPos+nLi < 2790 .And. nLi < 2770
		nPos+=50
		oPrint:say(nPos,040,SPACE(05)+SQI->QI_GRUPO+"-"+fDesc("SQ0", SQI->QI_GRUPO , "Q0_DESCRIC", 30),cFont) //Imprime Grupo		
		oPrint:say(nPos,040,SPACE(55)+SQI->QI_FATOR+"-"+fDesc("SQ1", SQI->QI_GRUPO+SQI->QI_FATOR , "Q1_DESCSUM", 30),cFont) //Imprime Fator					
		oPrint:say(nPos,040,SPACE(125)+SQI->QI_GRAU+"-"+fDesc("SQ2", SQI->QI_GRUPO+SQI->QI_FATOR+SQI->QI_GRAU , "Q2_DESC", 30),cFont) //Imprime Grau
		oPrint:say(nPos,040,SPACE(195)+(ALLTRIM(DTOC(SQI->QI_DATA))),cFont)//Imprime Dt. formacao
	Else
		oPrint:EndPage()
		oPrint:StartPage() 			// Inicia uma nova pagina
		ContFl++
		CabecGraf()
		
		oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
		nPos+=05
		oPrint:say (nPos,040 ,STR0024,cFont)	//QUALIFICACOES
		nPos+=40
		oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
		nPos+=35
		oPrint:say (nPos,040 ,SPACE(05)+OemtoAnsi(STR0049),cFont)		//"Grupo"
		oPrint:say (nPos,040 ,SPACE(55)+OemToAnsi(STR0066),cFont)		//"Fator"
		oPrint:say (nPos,040 ,SPACE(125)+OemToAnsi(STR0050),cFont)		//"Grau" 
		oPrint:say (nPos,040 ,SPACE(195)+OemToAnsi(STR0047),cFont)		//"Dt. Formacao"
		
		oPrint:say(nPos,040,SPACE(05)+SQI->QI_GRUPO+"-"+fDesc("SQ0", SQI->QI_GRUPO , "Q0_DESCRIC", 30),cFont) //Imprime Grupo		
		oPrint:say(nPos,040,SPACE(55)+SQI->QI_FATOR+"-"+fDesc("SQ1", SQI->QI_GRUPO+SQI->QI_FATOR , "Q1_DESCSUM", 30),cFont) //Imprime Fator			
		oPrint:say(nPos,040,SPACE(125)+SQI->QI_GRAU+"-"+fDesc("SQ2", SQI->QI_GRUPO+SQI->QI_FATOR+SQI->QI_GRAU , "Q2_DESC", 30),cFont) //Imprime Grau
		oPrint:say(nPos,040,SPACE(195)+(ALLTRIM(DTOC(SQI->QI_DATA))),cFont)//Imprime Dt. formacao
	EndIf
			
	dbSelectArea("SQI")
	dbSetOrder(1)
	dbSkip() 	
Enddo

If 	nPos>=2800
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()
EndIf
nPos+=50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³AVALIACAO DO CURRICULO                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	nPos>=2500
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()
EndIf

nLi := Imprcanlin("SQR",6)
If nPos+nLi < 2790 .And. nLi < 2770
	oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0042,cFont)				//AVALIACAO
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
	nPos+=30
	
	oPrint:say (nPos,040 ,SPACE(05)+STR0054,cFont)		//TESTE REALIZADO
	oPrint:say (nPos,040 ,SPACE(70)+STR0055,cFont)		//NR.QUESTOES
	oPrint:say (nPos,040 ,SPACE(100)+STR0056,cFont)	//TOTAL PONTOS
	oPrint:say (nPos,040 ,SPACE(130)+STR0057,cFont)	//PONTOS OBTIDOS
	oPrint:say (nPos,040 ,SPACE(160)+STR0058,cFont)	//%ACERTO 
	If lVaga
		oPrint:say (nPos,040 ,SPACE(190)+STR0072,cFont)	//VAGA
		oPrint:say (nPos,040 ,SPACE(220)+STR0062,cFont)	//DATA
	EndIf
Else
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()  
	
	oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
	nPos+=05
	oPrint:say (nPos,040 ,STR0042,cFont)				//AVALIACAO
	nPos+=40
	oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
	nPos+=30
	
	oPrint:say (nPos,040 ,SPACE(05)+STR0054,cFont)		//TESTE REALIZADO
	oPrint:say (nPos,040 ,SPACE(70)+STR0055,cFont)		//NR.QUESTOES
	oPrint:say (nPos,040 ,SPACE(100)+STR0056,cFont)	//TOTAL PONTOS
	oPrint:say (nPos,040 ,SPACE(130)+STR0057,cFont)	//PONTOS OBTIDOS
	oPrint:say (nPos,040 ,SPACE(160)+STR0058,cFont)	//%ACERTO
	If lVaga			
		oPrint:say (nPos,040 ,SPACE(190)+STR0072,cFont)	//VAGA
		oPrint:say (nPos,040 ,SPACE(220)+STR0062,cFont)	//DATA
	EndIf
EndIf

dbSelectArea("SQR")				//SQR - AVALIACAO DO CURRICULO
If dbSeek(SQG->QG_FILIAL+SQG->QG_CURRIC)
	cChaveSQR := SQR->QR_FILIAL+SQR->QR_CURRIC
	aTestes := {}
	While !Eof() .And. SQR->QR_FILIAL+SQR->QR_CURRIC == cChaveSQR
		If !lVaga
			If Ascan(aTestes, {|x| x[1]+x[2]+x[3] == ;
			 				SQR->QR_FILIAL+SQR->QR_CURRIC+SQR->QR_TESTE }) == 0
				Aadd(aTestes,{SQR->QR_FILIAL,SQR->QR_CURRIC,SQR->QR_TESTE})
			EndIf
		Else
			If Ascan(aTestes, {|x| x[1]+x[2]+x[3]+X[4]+X[5] == ;
							SQR->QR_FILIAL+SQR->QR_CURRIC+SQR->QR_TESTE+SQR->QR_VAGA+Dtoc(SQR->QR_DATA) }) == 0 
				Aadd(aTestes,{SQR->QR_FILIAL,SQR->QR_CURRIC,SQR->QR_TESTE,SQR->QR_VAGA,Dtoc(SQR->QR_DATA)})		
			EndIf
		EndIf
		dbSkip()	
	EndDo
	
	If !lVaga
		aTestes := Asort( aTestes,,,{ |x,y| ( x[1]+x[2]+x[3] ) < ( y[1]+y[2]+y[3] ) } )	
	Else
		aTestes := Asort( aTestes,,,{ |x,y| ( x[1]+x[2]+x[3]+x[4]+x[5] ) < ( y[1]+y[2]+y[3]+y[4]+y[5] ) } )
	EndIf

	cChave 	:= "SQR->QR_FILIAL+SQR->QR_CURRIC+SQR->QR_TESTE"
	
	For nx := 1 To Len(aTestes)
		
		dbSelectArea("SQQ")			//SQQ - TESTE
		dbSetOrder(1)
		
		nQuest 		:= 0 
		cChaveAtu 	:= aTestes[nx][1]+aTestes[nx][2]+aTestes[nx][3]
		
		dbSelectArea("SQR")
		dbSeek(cChaveAtu)
		
		nQuest 	:= 0
		While !Eof() .And. &cChave == cChaveAtu
			If lVaga
				If ( (aTestes[nx][4] != SQR->QR_VAGA) .Or. (Ctod(aTestes[nx][5]) != SQR->QR_DATA) )
					dbSkip()
					Loop
				EndIf
			EndIf   
			
			nQuest++
			dbSkip()
		EndDo    
				
		nNrPontos 	:= 0
		nNrPonObt 	:= 0
		nAcerto	  	:= 0 
		
		dbSeek(cChaveAtu)
		While !Eof() .And. &cChave == cChaveAtu
			If lVaga
				If aTestes[nx][4] != SQR->QR_VAGA .Or. Ctod(aTestes[nx][5]) != SQR->QR_DATA
					SQR->( dbSkip() )
					Loop
				EndIf
				cVaga	:= SQR->QR_VAGA
				dData   := SQR->QR_DATA
			EndIf
			
			dbSelectArea("SQO")				//SQO - CADASTRO DE QUESTOES
			dbSeek(SQR->QR_FILIAL+SQR->QR_QUESTAO)
			nNrPontos+= SQO->QO_PONTOS
			nNrPonObt+= SQO->QO_PONTOS * (SQR->QR_RESULTA/100)
			
			nAcerto =(nNrPonObt/nNrPontos*100)
			
			dbSelectArea("SQR")
			dbSkip()
		EndDo
		
		// Imprime o teste realizado
		nLi := Imprcanlin("SQR",6)
		If nPos+nLi < 2790 .And. nLi < 2770
			nPos+=50
	
			oPrint:say (nPos,040 ,SPACE(05)+aTestes[nx][3]+"-"+fDesc("SQQ", aTestes[nx][3] ,"QQ_DESCRIC", 30),cFont)//IMPRIME TESTE DO CURRICULO
			oPrint:say (nPos,040 ,SPACE(73)+(STR(nQuest,3)),cFont)    				//NUMERO DE QUESTOES
			oPrint:say (nPos,040 ,SPACE(103)+STR(nNrPontos,7,2),cFont)   			//TOTAL DE PONTOS
			oPrint:say (nPos,040 ,SPACE(133)+STR(nNrPonObt,7,2),cFont)   			//PONTOS OBTIDOS
			oPrint:say (nPos,040 ,SPACE(161)+STR(nAcerto,7,2),cFont)     			//%ACERTO        
			If lVaga			
				oPrint:say (nPos,040 ,SPACE(191)+cVaga,cFont)     					//VAGA  			
				oPrint:say (nPos,040 ,SPACE(221)+Dtoc(dData),cFont)    			//DATA  							
			EndIf
		Else
			oPrint:EndPage()
			oPrint:StartPage() 			// Inicia uma nova pagina
			ContFl++
			CabecGraf()
			
			oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
			nPos+=05
			oPrint:say (nPos,040 ,STR0042,cFont)				//AVALIACAO
			nPos+=40
			oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
			nPos+=30
			
			oPrint:say (nPos,040 ,SPACE(05)+STR0054,cFont)		//TESTE REALIZADO
			oPrint:say (nPos,040 ,SPACE(70)+STR0055,cFont)		//NR.QUESTOES
			oPrint:say (nPos,040 ,SPACE(100)+STR0056,cFont)	//TOTAL PONTOS
			oPrint:say (nPos,040 ,SPACE(130)+STR0057,cFont)	//PONTOS OBTIDOS
			oPrint:say (nPos,040 ,SPACE(160)+STR0058,cFont)	//%ACERTO 
			If lVaga			
				oPrint:say (nPos,040 ,SPACE(190)+STR0072,cFont)	//VAGA
				oPrint:say (nPos,040 ,SPACE(220)+STR0062,cFont)	//DATA
			EndIf      

			
			nPos+=50        
			oPrint:say (nPos,040 ,SPACE(05)+SQQ->QQ_TESTE+"-"+SQQ->QQ_DESCRIC,cFont)	//IMPRIME TESTE DO CURRICULO
			oPrint:say (nPos,040 ,SPACE(73)+(STR(nQuest,3)),cFont)    					//NUMERO DE QUESTOES
			oPrint:say (nPos,040 ,SPACE(103)+STR(nNrPontos,7,2),cFont)   				//TOTAL DE PONTOS
			oPrint:say (nPos,040 ,SPACE(133)+STR(nNrPonObt,7,2),cFont)   				//PONTOS OBTIDOS
			oPrint:say (nPos,040 ,SPACE(161)+STR(nAcerto,7,2),cFont)     				//PERCENTUAL DE ACERTO
			If lVaga		
				oPrint:say (nPos,040 ,SPACE(191)+cVaga,cFont)     						//VAGA  			
				oPrint:say (nPos,040 ,SPACE(221)+Dtoc(dData),cFont)    				//DATA  							
			EndIf
		EndIf              
		
		dbSelectArea("SQR")
	Next nx
EndIf

nPos+=50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PROCESSO SELETIVO                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	nPos>=2800
	oPrint:EndPage()
	oPrint:StartPage() 			// Inicia uma nova pagina
	ContFl++
	CabecGraf()
EndIf

oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal
nPos+=05
oPrint:say (nPos,040 ,STR0043,cFont)	//PROCESSO SELETIVO
nPos+=40
oPrint:line(nPos,035 ,nPos,2350) 		//Linha Horizontal

dbSelectArea("SQD")				//SQD - AGENDA
dbSetOrder(2) 
dbSeek(SQG->QG_FILIAL+SQG->QG_CURRIC)
aVagas := {}
While !Eof() .And. SQD->QD_CURRIC == SQG->QG_CURRIC
	If Ascan(aVagas, {|x| x == SQD->QD_VAGA }) == 0
		Aadd(aVagas, SQD->QD_VAGA)	
	EndIf
	dbSkip()
EndDo

For nX := 1 To Len(aVagas)

	dbSelectArea("SQD")	
	dbSetOrder(3)
	If dbSeek(SQG->QG_FILIAL+aVagas[nx]+SQG->QG_CURRIC)
		
		dbSelectArea("SQS")			//SQS - VAGAS
		dbSetOrder(1)
		If dbSeek(SQD->QD_FILIAL+SQD->QD_VAGA)
			
			//IMPRIME A VAGA
			If nX > 1
				nPos+=40
				oPrint:line(nPos,035 ,nPos,2350) 					//Linha Horizontal
			EndIf
			nPos+=35
			oPrint:say (nPos,040,SPACE(05)+STR0059,cFont)		//Vaga
			oPrint:say (nPos,040 ,SPACE(15)+SQD->QD_VAGA+"-"+SQS->QS_DESCRIC)
		Endif
		nPos+=70
		If 	nPos>=2800
			oPrint:EndPage()
			oPrint:StartPage() 			// Inicia uma nova pagina
			ContFl++
			CabecGraf()
		Endif
		oPrint:say (nPos,040 ,SPACE(05)+STR0060,cFont)  	//ITENS DO PROCESSO
		oPrint:say (nPos,850,STR0061,cFont)     			//Hora
		oPrint:say (nPos,1145,STR0062,cFont)     			//Data
		oPrint:say (nPos,1380,STR0063,cFont)     			//Resultado
		oPrint:say (nPos,1790,STR0036,cFont)				//Teste Realizado

        dbSelectArea("SQD")
        dbSetOrder(3)				
        
		While !Eof() .And. ( SQG->QG_FILIAL+aVagas[nx]+SQG->QG_CURRIC == ;
							SQD->QD_FILIAL + SQD->QD_VAGA + SQD->QD_CURRIC )
			//IMPRIME OS TOPICOS DO PROCESSO//
			nPos+=50
			
			If 	nPos>=2800     
				oPrint:EndPage()
				oPrint:StartPage() 			// Inicia uma nova pagina
				ContFl++
				CabecGraf()
			Endif
			oPrint:say (nPos,080 ,SQD->QD_TPPROCE+"-",cFont)		//TITULO DO ITEM DO PROCESSO
			oPrint:say (nPos,140 ,fDesc("SX5","R9"+SQD->QD_TPPROCE,"X5DESCRI()",30,,),cFont)
			oPrint:say (nPos,860 ,SQD->QD_HORA,cFont)       		//HORA DO TESTE
			oPrint:say (nPos,1145,DTOC(SQD->QD_DATA),cFont) 		//DATA DO TESTE
			oPrint:say (nPos,1390,SQD->QD_RESULTA+"-",cFont)		//RESULTADO DO TESTE
			oPrint:say (nPos,1440,fDesc("SX5","RA"+SQD->QD_RESULTA,"X5DESCRI()",30,,),cFont)
			
			dbSelectArea("SQQ")			//SQQ - TESTE
			dbSeek(SQD->QD_FILIAL+SQD->QD_TESTE)
			oPrint:say (nPos,1795,SQD->QD_TESTE+" - "+SQQ->QQ_DESCRIC,cFont)
			
			dbSelectArea("SQD")
			dbSetOrder(3)
			dbSkip()
		EndDo
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FIM DO RELATORIO                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:EndPage()
CONTFL:=1

dbSelectArea("SQD")
dbSetOrder(1)

RestArea(aSaveArea)

Return   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ Imprcanlin   ³ Autor ³Desenvolvimento R.H³ Data ³ 06.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checagem do numero de linhas para impressao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Imprcanlin()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ IMPRCAN  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Imprcanlin(cAlias,nTipo)

Local aSaveArea := GetArea()
Local aSaveArea1:= SQG->(GetArea())
Local aSaveArea2:= SQL->(GetArea()) 
Local aSaveArea3:= SQM->(GetArea())
Local aSaveArea4:= SQI->(GetArea())
Local aSaveArea5:= SQR->(GetArea()) 
Local cFil		:= ""
Local nLi	    := 0
Local cDescDet  := ""   

Do Case   
    Case cAlias == "SQG"	 
    	If !Empty(SQG->QG_EXPER) .And. nTipo == 1 //Experiencia Profissional
    		cDescDet := MSMM(SQG->QG_EXPER,,,,3)    		
			nLi  := MlCount(cVar,110)
		ElseIf !Empty(SQG->QG_ANALISE) .And. nTipo == 2 //Analise
    		cDescDet := MSMM(SQG->QG_ANALISE,,,,3) 
			nLi  := MlCount(cVar,110)
		EndIf	
	Case cAlias == "SQL" .And. nTipo == 3 //Historico Profissional      
		dbSelectArea("SQL")	
		dbSetOrder(1)
		cFil:= If(xFilial("SQL") == Space(2),Space(2),SQL->QL_FILIAL)
		If dbSeek(xFilial("SQL")+SQG->QG_CURRIC)
			While !Eof() .And. cFil+SQL->QL_CURRIC == SQG->QG_FILIAL+SQG->QG_CURRIC 
				nLi ++
				DbSkip()
			EndDo
		EndIf 
	Case cAlias == "SQM" .And. nTipo == 4 //Cursos Extracurriculares			          
		dbSelectArea("SQM")								//SQM - CURSOS DO CURRICULO
		dbSetOrder(1) 
		cFil:= If(xFilial("SQM") == Space(2),Space(2),SQM->QM_FILIAL)
		If dbSeek(xFilial("SQM")+SQG->QG_CURRIC)
			While !Eof() .And. cFil+SQM->QM_CURRIC == SQG->QG_FILIAL+SQG->QG_CURRIC		
				nLi ++
				DbSkip()
			EndDo
		EndIf 		
	Case cAlias == "SQI" .And. nTipo == 5 //Qualificacoes
		dbSelectArea("SQI")	 					
		dbSetOrder(1)
		cFil:= If(xFilial("SQI") == Space(2),Space(2),SQI->QI_FILIAL)
		If dbSeek(xFilial("SQI")+SQG->QG_CURRIC)
			While !Eof() .And. cFil+SQI->QI_CURRIC == SQG->QG_FILIAL+SQG->QG_CURRIC		
		    	nLi ++
		    	DbSkip()
		    EndDo
		EndIf
	Case cAlias == "SQR" .And. nTipo == 6  //Avaliacao
		dbSelectArea("SQR")	
		cFil:= If(xFilial("SQR") == Space(2),Space(2),SQR->QR_FILIAL)
		If dbSeek(SQG->QG_FILIAL+SQG->QG_CURRIC)
			cChaveSQR := SQR->QR_FILIAL+SQR->QR_CURRIC
			While !Eof() .And. cFil+SQR->QR_CURRIC == cChaveSQR
				nLi ++
				DbSkip()
			EndDo
		EndIf								    	
EndCase    

RestArea(aSaveArea1)
RestArea(aSaveArea2)
RestArea(aSaveArea3)
RestArea(aSaveArea4)
RestArea(aSaveArea5)
RestArea(aSaveArea)

Return(nLi)																			                                                                                        



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ ImpAcertSX1  ³ Autor ³ Desenvimento RH  	³ Data ³ 23/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Correcao nas perguntas.					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ImpAcertSX1()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ IMPRCAN  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpAcertSX1()

Local aSaveArea	:= GetArea()

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek("IMPCAN")
While !Eof() .And. X1_GRUPO == "IMPCAN"
	If ( "FILIAL" $ UPPER(X1_PERGUNT) ) .And. ( "NAOVAZIO" $ UPPER(X1_VALID) )
		RecLock("SX1", .F.)
			X1_VALID := " "
		MsUnlock()
	EndIf
	dbSkip()
EndDo

RestArea(aSaveArea)
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fFoto	    ³ Autor ³ Desenvimento RH  	³ Data ³ 20/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Foto do Candidato				                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fFoto()                                            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ IMPRCAN  											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fFoto()

Local lFile		
Local cBmpPict	:= ""
Local cPath		:= GetSrvProfString("Startpath","")
Local oDlg8
Local oBmp
Local cSAlias := Alias()
Local nSRecno := RecNo()
Local nSOrdem := IndexOrd()

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega a Foto do Funcionario								   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cBmpPict := Upper( AllTrim( SQG->QG_BITMAP))
cPathPict 	:= ( cPath + cBmpPict+".BMP" )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Para impressao da foto eh necessario abrir um dialogo para   ³
³ extracao da foto do repositorio.No entanto na impressao,nao  |
³ ha a necessidade de visualiza-lo( o dialogo).Por esta razao  ³
³ ele sera montado nestas coordenadas fora da Tela             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
DEFINE MSDIALOG oDlg8   FROM -1000000,-4000000 TO -10000000,-8000000  PIXEL 
@ -10000000, -1000000000000 REPOSITORY oBmp SIZE -6000000000, -7000000000 OF oDlg8  
	oBmp:LoadBmp(cBmpPict)
	oBmp:Refresh()
	
	//-- Box com  Foto
	oPrint:Box( 325,60,685, 460 )
	
	IF !Empty( cBmpPict := Upper( AllTrim( SQG->QG_BITMAP ) ) )
		IF !File( cPathPict)
			lFile:=oBmp:Extract(cBmpPict  ,cPathPict,.F.)
			If lFile		                

				oPrint:SayBitmap(340,75,cPathPict,370,330) //Linha, Coluna, Largura, Altura
				
			Endif	
		Else

			oPrint:SayBitmap(340,75,cPathPict,370,330)	//Linha, Coluna, Largura, Altura
			
		EndIF
	EndIF
	
	aAdd(aFotos,cPathPict)

ACTIVATE MSDIALOG oDlg8 ON INIT (oBmp:lStretch := .T.,oDlg8:End())

dbselectarea(cSAlias)
dbsetorder(nSOrdem)
dbgoto(nSRecno)
Return 
