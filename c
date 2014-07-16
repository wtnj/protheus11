#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE171  ºAutor  ³Marcos R. Roquitski º Data ³  24/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Conferencia Medias.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Nhgpe171()  

Local cDesc1  := "Demonstrativo de Medias"
Local cDesc2  := "Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SRA"					      // alias do arquivo principal (Base)
Local aOrd	  := {"Matricula","Centro de Custo","Nome"}		//"Matricula"###"Centro de Custo"###"Nome"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }		// "Zebrado"###"Administra‡„o"
Private nomeprog:="gper080"
Private aLinha	:= { },nLastKey := 0
Private cPerg	:="GPR080"
Private M_PAG   := 1    
Private _nTMV999   := _nTMV144 := _nTMV739 := 0
Private _nVlv144 := _nVlv739 := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)							 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nOrdem, nTipo
Private aInfo	 := {}
Private aFolBas[4] , aAdiBas[4] , aFerBas[4] , a13Bas[4]
Private aFolIR[4]  , aAdiIR[4]	, aFerIR[4]  , a13IR[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR 						
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private titulo  := "MEDIAS 13o. Sal"
Private AT_PRG	:= "GPER080"
Private wCabec0 := 1
Private wCabec1 := "DATA BASE: "
Private CONTFL	:= 1
Private LI		:= 0
Private nTamanho:= "M"
Private Cabec1  := " Matr.  Nome                                                      Medias    13o.1a.Parc.    FGTS 13o. "
Private Cabec2  := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("GPR080",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					    ³
//³ mv_par01		//	Data Base (referencia)					³
//³ mv_par02		//	Filial	De								³
//³ mv_par03		//	Filial	Ate 							³
//³ mv_par04		//	Centro de Custo De						³
//³ mv_par05		//	Centro de Custo Ate 					³
//³ mv_par06		//	Matricula De							³
//³ mv_par07		//	Matricula Ate							³
//³ mv_par08		//	Nome De 								³
//³ mv_par09		//	Nome Ate								³
//³ mv_par10		//	Ferias, 13§ Salario, Aviso Previo, Todos³
//³ mv_par11		//	Situacao do Funcionario 				³
//³ mv_par12		//	Categoria do Funcionario				³
//³ mv_par13		//	Considera Mes Atual do Acumulado   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := "DEMONSTRATIVO DE MEDIAS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER080"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem	   := aReturn[8]
dDtBase    := mv_par01
cFilDe	   := mv_par02
cFilAte    := mv_par03
cCcDe	   := mv_par04
cCcAte	   := mv_par05
cMatDe	   := mv_par06
cMatAte    := mv_par07
cNomDe	   := mv_par08
cNomAte    := mv_par09
nTipoMed   := mv_par10
cSituacao  := mv_par11
cCategoria := mv_par12
lMesAtu    := If(mv_par13 == 3, .F., .T.)  // 1 - Mensal  2 - Acumulado  3 - Nao
lMovMensal := If(mv_par13 == 1, .T., .F.)
wCabec1    += DTOC(dDtBase)

If nLastKey = 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| GR080Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GR080Imp ³ Autor ³ R.H. - Jose Ricardo	³ Data ³ 12.04.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo de Medias									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR080Imp(lEnd,wnRel,cString)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd 	   - A‡Æo do Codelock							  ³±±
±±³			 ³ wnRel	   - T¡tulo do relat¢rio						  ³±±
±±³Parametros³ cString	- Mensagem										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	 	 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Gr080Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)						    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt // Ambiente
Local CbCont
Local Val_SalMin := 0
Local dDt1,dDt3,dDt4
Local cFilAnterior := "!!"
Local nSalario	:= nSalMes := nSalDia := nSalHora := 0
Local cArqDbf,cArqNtx

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER080" , "SRA" , "2" ) + " } " )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Privates (Programa)					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c__Roteiro			:= "   "
Private aPdv		:= {} // Matriz Incidencia de Verbas Usado na Fvaloriza()
Private aCodFol		:= {}
Private aRoteiro	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro Salario Minimo								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Sal_Min(@Val_SalMin,MesAno(dDtBase))
	Return
Endif

//--Criar Arquivo de Medias Temporario
Cria_TRP(@cArqDbf,@cArqNtx)

dbSelectArea ("SRA")
DbGoTop()
If nOrdem == 1
	dbSetOrder(1)
	dbSeek( cFilDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim	 := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek( cFilDe + cCcDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim	 := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSetOrder(3)
	dbSeek( cFilDe + cNomDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim	 := cFilAte + cNomAte + cMatAte
Endif

Cabec(Titulo, Cabec1,Cabec2,NomeProg, nTamanho, nTipo)
dbSelectArea("SRA")
SetRegua(SRA->(RecCount()))

While !Eof() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->Ra_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) .Or. ;
	   (SRA->Ra_MAT < cMatDe)  .Or. (SRA->RA_MAT > cMatAte)  .Or. ;
		(SRA->RA_CC < cCcDe)	.Or. (SRA->RA_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    IF !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
       	dbSelectArea("SRA")
       	dbSkip()
       	Loop
    EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza conforme Situacao e Categoria dos funcionarios     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	!( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quebra de Filial															 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	cFilAnterior # SRA->RA_FILIAL
		cFilAnterior := SRA->RA_FILIAL
		If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
			Return
		Endif
	Endif

	dDt1 := ""
	If	nTipoMed == 1 .Or. nTipoMed == 4
		dbSelectArea( "SRF" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			dDt1 := SRF->RF_DATABAS
		Else
			dDt1 := SRA->RA_ADMISSA
		Endif
	Endif
    dDt3 := If(nTipoMed = 2 .OR. nTipoMed = 4,dDtBase,"")
    dDt4 := If(nTipoMed > 2 ,dDtBase,"")

	nSalario := 0
	nSalMes  := 0
	nSalDia  := 0
	nSalHora := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta as Variaveis de Salario Incorporado					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPd := {} // Limpa a Matriz do SRC
	fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os valores de Rescisao e os carrega em aPd			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMovMensal .And. !Empty(SRA->RA_DEMISSAO)
		fApdResc(dDtBase)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Media 												 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRP")
	Zap
	_nVlv144 := _nVlv739 := 0
    If GPEXMED(dDt1,,dDt3,dDt4,dDtBase,nSalHora,Val_SalMin,aCodfol,lMesAtu,lMovMensal)
		@ Prow()+001, 001 Psay SRA->RA_MAT
		@ Prow()    , 010 Psay SRA->RA_NOME

		SRC->(DbSeek(xFilial("SRC") + SRA->RA_MAT))
		While !SRC->(Eof()) .AND. SRC->RC_MAT == SRA->RA_MAT
			If SRC->RC_PD == '144'			
				_nVlv144 := SRC->RC_VALOR 
				_nTMV144 += SRC->RC_VALOR
			Endif	
			
			If SRC->RC_PD == '739'			
				_nVlv739 := SRC->RC_VALOR
				_nTMV739 += SRC->RC_VALOR					
			Endif	
			
			SRC->(DbSkip())			
		Enddo


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Demonstrativo									    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   fImpr_Med(nSalMes,nSalDia,nSalHora)
    Endif
	dbSelectArea( "SRA" )
	dbSkip()
Enddo
@ Prow()+001, 000 PSAY __PrtThinLine() 
@ Prow()+001, 060 Psay _nTMV999 Picture "@E 9,999,999.99"
@ Prow()    , 075 Psay _nTMV144 Picture "@E 9,999,999.99"
@ Prow()    , 090 Psay _nTMV739 Picture "@E 9,999,999.99"
@ Prow() +1, 000 PSAY __PrtThinLine() 
@ Prow() +2, 000 PSAY "" 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio										³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
Set Filter to 
dbSetOrder(1)

Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()
TRP->(dbCloseArea())
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

Return Nil

*------------------------------------------------*
Static Function fImpr_Med(nSalMes,nSalDia,nSalHora)
*------------------------------------------------*
Local aTipoRel := {"Ferias Vencidas","Ferias a Vencer","13o Salario    ","Aviso Previo   "}		//"Ferias Vencidas"###"F‚rias a Vencer"###"13o Sal rio    "###"Aviso Pr‚vio   "
Local nMes       := nDia := nHor := nTipo := 0
Local cTipo      := "0", cPd := "000"
Local cTitulo    := "",aTipMed,cCnt,cTipoRel
Local cImpressas := ""
Local lAtuDatBse := .F.
Local dDtBasVen  := SRF->RF_DATABAS
Local nCnt

Private A1COLUNA 	:= {}
Private A2COLUNA 	:= {}
Private	LI    		:= 0

nMes := nSalMes
nDia := nSalDia
nHor := nSalhora

cColuna := "A1COLUNA"
dbSelectArea( "TRP" )
SRC->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipos de Medias a Imprimir:                                 ³
//| 1-Ferias Vencidas 1o Periodo                                |
//| 2-Ferias a Vencer                                           |
//| 3-13o Salario                                               |
//| 4-Aviso Previo                                              |
//| 5 a 9-Ferias Vencidas Periodos 2o,3o,4o...                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTipMed    := { "1","5","6","7","8","9","2","3","4" }
For nCnt := 1 To 9
	If !dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aTipMed[nCnt] )
		Loop
	ElseIf !(aTipMed[nCnt] $ "3*4") // 13o.Salario e Aviso Previo
		cImpressas += aTipMed[nCnt] + "*"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houver mais de um periodo de vencida atualiza a data base|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAtuDatBse := .F.
	Aeval( aTipMed, { |x| If( x $ cImpressas .And. x # aTipMed[nCnt], lAtuDatBse := .T., "" ) } )
	If aTipMed[nCnt] $ "2*5*6*7*8*9" .And. lAtuDatBse
		dDtBasVen := fCalcFimAq(dDtBasVen)+1 // Inicio do proximo periodo
	EndIf

	If Len(A1COLUNA) # 0
		xDESCARREGA()
		cColuna := "A1COLUNA" 
		IMPR(" ","C")
	Endif
	cTipo := TRP->RP_TIPO
	LI    := 0
	
	While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT == TRP->RP_FILIAL+TRP->RP_MAT

		If TRP->RP_DATARQ = "9999  " .and. TRP->RP_PD = '999'
			@ Prow()    , 060 Psay TRP->RP_VALATU Picture "@E 9,999,999.99"
			_nTMV999 += TRP->RP_VALATU


		Endif	
	
		dbSelectArea( "TRP" )
		dbSkip()

	Enddo
	
Next nCnt
@ Prow()    , 075 Psay _nVlv144 Picture "@E 9,999,999.99"
@ Prow()    , 090 Psay _nVlv739 Picture "@E 9,999,999.99"


Return nil

*---------------------------------------------------------------------------*
* FUNCAO PARA IMPRIMIR OS VETORES CONTENDO AS LINHAS DE DETALHE DE IMPRESSAO
*---------------------------------------------------------------------------*
Static Function xDESCARREGA
Local x
If Len(A1COLUNA) > Len(A2COLUNA)
	cColuna = "A1COLUNA"
	ASIZE(A2COLUNA,Len(A1COLUNA))
Else
	cColuna = "A2COLUNA"
	ASIZE(A1COLUNA,Len(A2COLUNA))
Endif
For x = 1 TO Len(&(cColuna))
	DET = "| "+IF(A1COLUNA[x]=NIL,SPACE(62),A1COLUNA[x])+" || "+IF(A2COLUNA[x]=NIL,SPACE(62),A2COLUNA[x])+" |"
	IMPR(DET,"C")
NEXT x

IMPR("|"+REPL("_",130)+"|","C")
ASIZE(A1COLUNA,0)
ASIZE(A2COLUNA,0)

Return (.T.)

*-----------------------------*
Static Function FTrocaColuna()
*-----------------------------*
If cColuna = "A2COLUNA"
	xDESCARREGA()
	cColuna = "A1COLUNA"
Else
	cColuna = "A2COLUNA"
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fApdResc |Autor  ³ Recursos Hunano       ³ Data ³ 27/04/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se deve incluir as medias do mes atual no         ³±±
±±³          ³ demonstrativo de medias.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fApdResc(dDtBase)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dDtBase     - mes atual de referencia                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fApdResc(dDtBase)
Local cAlias := Alias()

dbSelectArea( "SRG" )
dbSeek( SRA->RA_FILIAL+SRA->RA_MAT )
While !Eof() .And. SRG->RG_FILIAL+SRG->RG_MAT == SRA->RA_FILIAL+SRA->RA_MAT
	If MesAno(SRG->RG_DTGERAR) == MesAno(dDtBase) .And. SRG->RG_MEDATU == "S"
		dbSelectArea("SRR")
		dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "R" )
		While !Eof() .And. RR_FILIAL + RR_MAT == SRA->RA_FILIAL + SRA->RA_MAT
			If SRR->RR_TIPO3 == "R"
				nPos := Ascan(aPd,{ |X| X[1] = SRR->RR_PD } )
				If nPos = 0
					Aadd(aPd,{SRR->RR_PD,"","",SRR->RR_HORAS,SRR->RR_VALOR,SRR->RR_TIPO1,SRR->RR_TIPO2,0," ",SRR->RR_DATA})
				Else
					aPd[nPos,5] += SRR->RR_VALOR
				Endif
			EndIf
			dbSkip()
		Enddo
		Exit
	EndIf
	dbSelectArea( "SRG" )
	dbSkip()
EndDo
dbSelectArea( cAlias )
Return( NIL )
