#INCLUDE "FiveWin.ch"
#INCLUDE "GPER510.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER510  ³ Autor ³ R.H. - Recursos Humano³ Data ³ 07.10.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Acumulados por Codigos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER510(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Silvia      ³04/03/02³------³ Ajustes na Picture para Localizacoes    .³±±
±±³Mauro       ³08/07/02³------³ Alterado para o tamanho do centro custo  ³±±
±±³            ³        ³------³ tirando da linha func. saindo no total   ³±±
±±³            ³        ³------³ acerto nos totais horizontais e verticais³±±
±±³Priscila    ³19/08/02³------³ Ajuste nas perguntas para versao 7.10.   ³±±
±±³Emerson     ³06/09/02³------³ Acidionar sempre 18 elementos em aTotais.³±±
±±³Priscila    ³07/01/03³------³ Alteracao para considerar tb o 13.salario³±±
±±³Emerson     ³22/01/03³------³ Incluir "+" na Query excluido por engano.³±±
±±³Pedro Eloy  ³22/03/04³070293³ Ajuste do nChar de 18 para 15 comprimido ³±±
±±³Pedro Eloy  ³06/10/04³074306³ Comentar funcao fZera(7) em fImpFil().   ³±±
±±³Ricardo D.  ³19/01/05³073612³ Ajuste para nao totalizar o salario base ³±±
±±³            ³        ³------³ junto com as verbas impressas.           ³±±
±±³Eduardo Ju  ³13/07/05³083312³ Considera Somente Funcionarios Demitidos ³±±
±±³            ³        ³------³ de acordo c/ Mes de Competencia Informado³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User function Nhgpe060()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1 	:= STR0001  //"Relatorio Acumulados por Codigo"
LOCAL cDesc2 	:= STR0002  //"Ser  impresso de acordo com os parametros solicitados pelo"
LOCAL cDesc3 	:= STR0003  //"usuario."
LOCAL cString	:="SRA"        // alias do arquivo principal (Base)
LOCAL aOrd		:={STR0004,STR0005,STR0006}  //"Matricula"###"Centro de Custo"###"Nome"
Local cSize	 	:= "G"      
Local nFor
Local aArea		:= GetArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := { STR0007, 1,STR0008, 2, 2, 1, "",1 }  //"Zebrado"###"Administra‡„o"
PRIVATE nomeprog:="GPER510"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="GPR510"
PRIVATE aAC 	:= { STR0009,STR0010 }  //"Abandona"###"Confirma"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nOrdem
PRIVATE aInfo	:={}
PRIVATE aTotais := { }
PRIVATE cVerba, cCodigos, cVerbaCod, nCtSB, nCtcPd
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Vetor de Totalizacao Generico 1 Coluna = CODIGO                    ³
//³                              2 Coluna = Total Horas do Funcionario³
//³                              3 Coluna = Total Valor do Funcionario³
//³                              4 Coluna = Total Horas Centro Custo  ³
//³      aTotais                 5 Coluna = Total Valor Centro Custo  ³
//³                              6 Coluna = Total Horas Filial        ³
//³                              7 Coluna = Total Valor Filial        ³
//³                              8 Coluna = Total Geral Horas         ³
//³                              9 Coluna = Total Geral Valor         ³
//³                             10 Coluna = Mes Referencia            ³
//³                             11 Coluna = Data Pagamento            ³
//³                             12 Coluna = Tipo 1                    ³
//³                             13 Coluna = Tipo 2                    ³
//³                             14 Coluna = Proventos/Base(-)Descontos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE titulo
PRIVATE AT_PRG 	:= "GPER510"
PRIVATE wCabec0
PRIVATE wCabec1
PRIVATE wCabec2
PRIVATE CONTFL  := 1
PRIVATE LI      := 0
PRIVATE COLUNAS := 220
PRIVATE nTamanho:= "G"
PRIVATE nChar	:= 15
Private cPict1	:=	If (MsDecimais(1)==2,"@E 99,999,999,999.99",TM(99999999999,17,MsDecimais(1)))  // "@E 99,999,999,999.99
Private cPict2	:=	If (MsDecimais(1)==2,"@E 999,999,999.99",TM(99999999999,17,MsDecimais(1)))  // "@E 99,999,999,999.99

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  Tamanho Decimal Presel  GSC   Valid                              Var01     	 Def01      DefSPA1      DefEng1      Cnt01          					  Var02  Def02    	    DefSpa2          DefEng2	Cnt02  Var03 		Def03      DefSpa3    DefEng3  		Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04 		 Var05  Def05       DefSpa5	 DefEng5   Cnt05  	XF3  GrgSxg   cPyme   aHelpPor  aHelpEng	 aHelpSpa    cHelp      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("GPR510",.F.)
cTit   	:= STR0011  //"VALORES ACUMULADOS POR CODIGO "
wnrel	:="GPER510"            //Nome Default do relatorio em Disco
wnrel	:=SetPrint(cString,wnrel,cPerg,@cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Centro de Custo De                       ³
//³ mv_par04        //  Centro de Custo Ate                      ³
//³ mv_par05        //  Matricula De                             ³
//³ mv_par06        //  Matricula Ate                            ³
//³ mv_par07        //  Nome De                                  ³
//³ mv_par08        //  Nome Ate                                 ³
//³ mv_par09        //  Data De                                  ³
//³ mv_par10        //  Data Ate                                 ³
//³ mv_par11        //  Numero da Semana De                      ³
//³ mv_par12        //  Numero da Semana Ate                     ³
//³ mv_par13        //  Formato Vertical / Horizontal            ³
//³ mv_par14        //  Listar Horas / Valores                   ³
//³ mv_par15        //  Relatorio Analitico ou Sintetica         ³
//³ mv_par16        //  Se lista todos os codigos encontrados    ³
//³ mv_par17        //  Lista Salario do Cadastro ?              ³
//³ mv_par18        //  Cria String com Situacao do Funcionario  ³
//³ mv_par19        //  Cria String contendo Categorias          ³
//³ mv_par20        //  Codigos a Listar                         ³
//³ mv_par21        //  Cont. Codigos a Listar                   ³
//³ mv_par22        //  Imprimir Totais                          ³
//³ mv_par23        //  Imprimir Liquidos                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FilialDe  := mv_par01
FilialAte := mv_par02
CcDe      := mv_par03
CcAte     := mv_par04
MatDe     := mv_par05
MatAte    := mv_par06
NomDe     := mv_par07
NomAte    := mv_par08
DatDe     := mv_par09
DatAte    := mv_par10
cSemanaDE := mv_par11
cSemanAte := mv_par12
nVerHor   := If(mv_par16=1,1,mv_par13)
nValHor   := mv_par14
nSinAna   := mv_par15
lTodos    := If(Empty(mv_par20),.T.,If(mv_par16=1,.T.,.F.))
lSalario  := If(mv_par17=1,.T.,.F.)
cSituacao := mv_par18
cCategoria:= mv_par19
cCodigos  := ALLTRIM(mv_par20)
cCodigos  += ALLTRIM(mv_par21)
lTotais   := If(mv_par22=1,.T.,.F.)
lLiquido  := If(mv_par23=1,.T.,.F.)

cAnoMesI :=	SubStr(DatDe,3,4) + SubStr(DatDe,1,2) 
cAnoMesF :=	SubStr(DatAte,3,4)  + SubStr(DatAte,1,2)

If	nLastKey = 27
	Return
Endif

// Separa os Codigos das verbas solicitadas a listar
cVerba := ""
If nVerHor =  2
	If lLiquido
		cCodigos += "LIQ"
	Endif
	If lTotais
		cCodigos += "TOT"
	Endif	
Endif	
If !Empty(cCodigos)
	For nFor := 1 To Len(ALLTRIM(cCodigos)) Step 3
		cVerba += "'"+Subs(cCodigos,nFor,3)+"'"
		If Len(ALLTRIM(cCodigos)) > ( nFor+3 )
			cVerba += "," 
		Endif
	Next nFor
Endif

If nVerHor = 2   //Horizontal
	// Cria no vetor de totalizacao, as verbas solicitadas
	If !Empty(cCodigos)
		For nFor := 1 To Len(ALLTRIM(cCodigos)) Step 3
			cVerbaCod := Subs(cCodigos,nFor,3)
			//--Incluir Salario Base nos codigos a listar
			Aadd(aTotais,{cVerbaCod,0,0,0,0,0,0,0,0,cAnoMesI," "," "," ",0,0,0,0,0})
		Next
	Endif        
	//--Limite de Verbas Horizontal em Valor           
	If Len(aTotais) > 10 .AND. nValHor  = 1
        Help(" ",1,"R100MAIO8")
		Return                              
	//--Limite de Verbas Horizontal em Horas		
	ElseIf Len(aTotais) > 16 .AND. nValHor = 2
		Help(" ",1,"R100MAIO15")
		Return
	Endif
	If (Len(aTotais) > 4 .AND. nValHor = 1) .OR. (Len(aTotais) > 6 .AND. nValHor = 2)
		cSize   	:= "G"
		nTamanho	:= "G"
		COLUNAS    	:= 220
        nChar		:= 15
        aReturn[4]	:= 2
	Endif
Else
	cSize   	:= "M"
	nTamanho	:= "M"
	COLUNAS    	:= 132
	nChar		:= 15
	aReturn[4]	:= 1
Endif             

TITULO := STR0011+STR0013+aOrd[ aReturn[8] ]+" )"  //'VALORES ACUMULADOS POR CODIGO '###"    ( Ordem: "
wCabec0 := 2
If nVerHor = 1
	wCabec1 := SPACE(41)+STR0014+SPACE(4)+STR0015 //'DATA'###'T T |- PROVENTO/DESCONTO -|'
	wCabec2 := STR0028+Space(1)+STR0030+sPACE(2)+STR0031+;
	SPACE(27)+STR0032+SPACE(4)+STR0033+SPACE(1)+STR0034+SPACE(1)+STR0035+SPACE(15)+;
	STR0018+SPACE(5)+STR0017+SPACE(2)+STR0036   //	'FI MATR.  NOME                           REF.    1 2 COD DESCRICAO               HORAS     V A L O R  DT.PAGTO'
	********************************************************************************************************************************************
	//             99 999999999999999999999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/9999 X X 999 XXXXXXXXXXXXXXXXXXX 999999,99 999.999.999,99 99/99/99
	//             99 999999999 - XXXXXXXXXXXXXXXXXXXX                                                                999999,99 999.999.999,99 99/99/99
	//             99 XXXXXXXXXXXXXXX                                             99/9999 X X 999 XXXXXXXXXXXXXXXXXXX 999999,99 999.999.999,99 99/99/99
	//             99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                           99/9999 X X 999 XXXXXXXXXXXXXXXXXXX 999999,99 999.999.999,99 99/99/99
	//                                                                            TOTAL DA VERBA                      999999,99 999.999.999,99 99/99/99
	//                   T O T A L     D O     F U N C I O N A R I O                                                  999999,99 999.999.999,99          
	//                   T O T A L     D O     C E N T R O  D E  C U S T O                                            999999,99 999.999.999,99          
	//            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//    				    1         2         3         4         5         6         7         8         9         0         1         2         3
	*******************************************************************************************************************************************
Else
	aTotais := aSort(aTotais,,,{ |x,y| x[10]+x[1] < y[10]+y[1] })
	wCabec1 := STR0028+SPACE(1)+STR0030+Space(2)+STR0031+SPACE(27)+STR0014+SPACE(4) //"FI C.CUSTO   MATR.  NOME                           DATA  " 
	wCabec2 := "                                                  "
*********************************************************************************
// cabec.1     99 999999999999999999999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/9999 999-xxxxxxxxxxxxx  
// cabec.2                                                          V A L O R
// cabec.1     99 999999999999999999999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/9999 999-xxxxx
// cabec.2                                                          HORAS
//             99 999999999999999999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX       999999,99
//             99 999999999899999999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX       99,999,999,999.99
//             99 XXXXXXXXXXXXXXX                                           999999,99
//             99 XXXXXXXXXXXXXXX                                           99,999,999,999.99
//             Empresa: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                   999999,99
//             T O T A L     D O     F U N C I O N A R I O                  999999,99 999.999.999,99
//             T O T A L     D O     C E N T R O  D E  C U S T O            999999,99 999.999.999,99
//             22                    TOTAL DO FUNCIONARIO                   999999,99 999.999.999,99
//            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//    				    1         2         3         4         5         6         7         8         9         0         1         2         3
*******************************************************************************************
	For nFor := 1 To Len(aTotais) 
		WCabec1 += Space(1)+FVerba(aTotais[nFor,1],If(nValHor==1,11,6),cFilial)
		WCabec2 += If(nValHor=1,Space(6)+STR0017,Space(5)+STR0018)+" "  //"V A L O R"###"HORAS"
	Next
//	WCabec2 += If(nValHor=1,If(lLiquido,STR0027,+Space(8)+STR0019),Space(1)+STR0019)  //"T O T A L"###"TOTAL LIQUIDO"
Endif


If	nLastKey = 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Passa parametros de controle da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString,,,cSize)


RptStatus({|lEnd| GR510Imp(@lEnd,wnRel,cString)},titulo)

RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER510  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Acumulados por Codigos                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR510Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GR510Imp(lEnd,wnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt // Ambiente
LOCAL CbCont
Local cAcessaSRA  := &("{ || " + ChkRH("GPER510","SRA","2") + "}")
Local cAcessaSRD  := &("{ || " + ChkRH("GPER510","SRD","2") + "}")
Local nPos
//--Variaveis para Query SRD             
Local cAliasSRD := "SRD" 	//Alias da Query
Local DtPagto	
Local lQuery    := .F. 		// Indica se a query foi executada
Local cDtDemiss := ""

#IFDEF TOP
	Local cQuery    := "" 		//Expressao da Query
	Local aStruSRD  := {}      //Estrutura da Query
	Local nX
#ENDIF

cbtxt	:=	SPACE(10)
cbcont	:=	0


//--Salvar Ordem Selecionada SETPRINT
nOrdem    := aReturn[8]

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder(1)
	dbSeek(FilialDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := FilialAte + MatAte
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek(FilialDe + CcDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
	dbSetOrder(3)
	dbSeek(FilialDe + NomDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := FilialAte + NomAte + MatAte
Endif

cFilAnterior := "!!"
cCcAnt  := "!!!!!!!!!"

dbSelectArea("SRA")
SetRegua(SRA->(RecCount()))

While	!Eof() .And. &cInicio <= cFim
	
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif	 

	If	Sra->ra_Filial # cFilAnterior
		If	cFilAnterior # "!!"
			fImpFil()    // Totaliza Filial
		Endif
		cFilAnterior := SRA->RA_FILIAL
		cCcAnt       := SRA->RA_CC
		fInfo(@aInfo,cFilAnterior)
   Endif
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza Registros Conforme Situacao e Categoria Funcionarios³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	!( SRA->RA_SITFOLH $ cSituacao ) .OR.  !( SRA->RA_CATFUNC $ cCategoria )
		fTestaTotal()		
		Loop
	Endif     
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera Somente os Funcionarios Demitidos de acordo com o Mes de Competencia Informado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDtDemiss := MesAno(SRA->RA_DEMISSA)
	If SRA->RA_SITFOLH == "D" .And. ( (cDtDemiss < cAnoMesI) .Or. (cDtDemiss > cAnoMesF) )
		fTestaTotal()
		Loop		
 	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->RA_NOME < NomDe) .Or. (SRA->RA_NOME > NomAte) .Or. ;
		(SRA->RA_MAT < MatDe)  .Or. (SRA->RA_MAT > MatAte)  .Or. ;
		(SRA->RA_CC < CcDe)    .Or. (SRA->RA_CC > CcAte)
		fTestaTotal()
		Loop
	EndIf  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		fTestaTotal()
		Loop
	EndIf
	
	nCtSB  := 0
	nCtcPd := 0

	#IFDEF TOP
		lQuery := .T.
		cAliasSRD 	:= "QSRD"
		aStruSRD  	:= If(Empty(aStruSRD),SRD->(dbStruct()),aStruSRD)
		cQuery 		:= "SELECT * "
		cQuery 		+= "FROM "+RetSqlName("SRD")+" SRD "
		cQuery 		+= "WHERE SRD.RD_FILIAL='"+SRA->RA_FILIAL+"' AND "
		cQuery 		+= "SRD.RD_MAT='"+SRA->RA_MAT+"' AND "
		cQuery 		+= "SRD.RD_DATARQ>='"+cAnoMesI+"' AND "
		cQuery		+= "SRD.RD_DATARQ<='"+cAnoMesF+"' AND "
		cQuery 		+= "SRD.RD_SEMANA>='"+ cSemanaDe+"' AND "
		cQuery 		+= "SRD.RD_SEMANA<='"+ cSemanAte+"' AND "
				
		IF !Empty(SRD->RD_EMPRESA) 
			cQuery += "SRD.RD_EMPRESA='"+cEmpAnt+"' AND "
		EndIf

		IF !lTodos .And. !Empty(cVerba) 
			cQuery += "SRD.RD_PD IN (" + Upper(cVerba) + ") AND " 
		Endif
        
		cQuery += "SRD.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(SRD->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSRD,.T.,.T.)
		
		For nX := 1 To Len(aStruSRD)
			If ( aStruSRD[nX][2] <> "C" )
				TcSetField(cAliasSRD,aStruSRD[nX][1],aStruSRD[nX][2],aStruSRD[nX][3],aStruSRD[nX][4])
			EndIf
		Next nX
	#ELSE
		dbSelectArea("SRD")
		dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)	
	#ENDIF

	While	!Eof() .And. ((cAliasSRD)->RD_FILIAL+(cAliasSRD)->RD_MAT == Sra->ra_filial+Sra->ra_Mat) .And. ;
	                   ( (cAliasSRD)->RD_DATARQ<=cAnoMesF)
		If (cAliasSRD)->RD_DATARQ < cAnoMesI 
			dbSkip()
			Loop
		Endif
		IF !Empty((cAliasSRD)->RD_EMPRESA) .And. (cAliasSRD)->RD_EMPRESA # cEmpAnt
			dbSkip()
			Loop
		Endif    
		if (cAliasSRD)->RD_SEMANA < cSemanaDe .or. (cAliasSRD)->RD_SEMANA > cSemanAte
			dbSkip()
			Loop
		Endif
		IF !lTodos .And. !Empty(cVerba) .And. !((cAliasSRD)->RD_PD $ cVerba) 
			dbSkip()
			Loop
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos								 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Eval(cAcessaSRD)
			dbSkip()
			Loop
		EndIf
		DtPagto:= LEFT(DTOC((cAliasSRD)->RD_DATPGT),6) + RIGHT(DTOC((cAliasSRD)->RD_DATPGT),2)

		FAcumula((cAliasSRD)->RD_PD,(cAliasSRD)->RD_HORAS,(cAliasSRD)->RD_VALOR,(cAliasSRD)->RD_DATARQ, DtPagto ,(cAliasSRD)->RD_TIPO1,(cAliasSRD)->RD_TIPO2)
		
		If PosSrv( (cAliasSRD)->RD_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"		//Proventos
			nValorM := (cAliasSRD)->RD_VALOR * (-1)
        Else
			nValorM := (cAliasSRD)->RD_VALOR                 
        Endif
        
        //--Somar no Liquido do Funcionario
		If lliquido .And. nVerHor = 2 .And. Ascan(aTotais,{ |x| x[1] = (cAliasSRD)->RD_PD}) > 0
			FAcumula("LIQ",(cAliasSRD)->RD_HORAS,nValorM,(cAliasSRD)->RD_DATARQ, DtPagto ,(cAliasSRD)->RD_TIPO1,(cAliasSRD)->RD_TIPO2)
		Endif					

		//--Somar no total do funcionario
		If lTotais .And.  nVerHor = 2 .And. Ascan(aTotais,{ |x| x[1] = (cAliasSRD)->RD_PD}) > 0
			FAcumula("TOT",(cAliasSRD)->RD_HORAS,(cAliasSRD)->RD_VALOR,(cAliasSRD)->RD_DATARQ, DtPagto ,(cAliasSRD)->RD_TIPO1,(cAliasSRD)->RD_TIPO2)
		Endif					
	
		(cAliasSRD)->(dbSkip())
	Enddo
	If ( lQuery )
		dbSelectARea(cAliasSRD)
		dbCloseArea()
		dbSelectArea("SRD")
	EndIf
	
	If	FTotaliza(2)+FTotaliza(3) > 0 .and. lSalario .And. nVerHor == 1
		FAcumula(" SB",SRA->RA_HRSMES,SRA->RA_SALARIO,cAnoMesI," "," "," ")
	ElseIf	FTotaliza(2)+FTotaliza(3) > 0 .and. lSalario .And. nVerHor == 2
		nPos := Ascan(aTotais,{|x|x[1]==" SB"})
		if nPos ==0
			Aadd(aTotais,{" SB",SRA->RA_HRSMES,SRA->RA_SALARIO,SRA->RA_HRSMES,SRA->RA_SALARIO,SRA->RA_HRSMES,SRA->RA_SALARIO,SRA->RA_HRSMES,SRA->RA_SALARIO,cAnoMesI,"","","",0.00,0,0,0,0})
		Else
			aTotais[nPos,02] += SRA->RA_HRSMES
			aTotais[nPos,03] += SRA->RA_SALARIO
			aTotais[nPos,04] += SRA->RA_HRSMES
			aTotais[nPos,05] += SRA->RA_SALARIO
			aTotais[nPos,06] += SRA->RA_HRSMES
			aTotais[nPos,07] += SRA->RA_SALARIO
			aTotais[nPos,08] += SRA->RA_HRSMES
			aTotais[nPos,09] += SRA->RA_SALARIO
			aTotais[nPos,10] := cAnoMesI
			aTotais[nPos,14] := 0
		EndIf	       
	Endif                    
	fImpFun()
	fTestaTotal()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ftestatotalºAutor  ³Microsiga           º Data ³  10-29-02  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pula funcinario e verifica as quebras de centro de custo    º±±
±±º          ³filial / empresa.                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fTestaTotal()     

cCcAnt       := SRA->RA_CC
cFilAnterior := SRA->RA_FILIAL

dbSelectArea("SRA")
dbSkip()

If Eof() .Or. &cInicio > cFim
	fImpCc()
	fImpFil()
	fImpEmp()
Elseif cFilAnterior # SRA->RA_FILIAL
	fImpCc()
	fImpFil()
Elseif cCcAnt # SRA->RA_CC .And. !Eof()
	fImpCc()
Endif
Return Nil

***********************
Static Function fImpFun            // Imprime um Funcionario
***********************
If nSinAna = 2 // Se Relatorio e' Analitico
	fImprime(1,2)
Endif
FZera(2) // Zerar a Coluna de Funcionarios
Retu Nil

**********************
Static Function fImpCc             // Imprime Centro de Custo
**********************
If nOrdem ==  2 .AND. FTotaliza(4)+FTotaliza(5) > 0
	fImprime(2,4) // Imprime
Endif
FZera(4)   
fZera(14)
Return Nil

***********************
Static Function fImpFil            // Imprime Filial
***********************
If fTotaliza(6)+fTotaliza(7) > 0
	fImprime(3,6)
Endif	
FZera(6)
//fZera(7)
Retu Nil

***********************
Static Function fImpEmp            // Imprime Geral
***********************
fImprime(4,8)
FZera(8)
Retu Nil

************************************
Static Function fImprime(nTipo,nCol)
************************************
// nTipo: 1- Funcionario
//        2- Centro de Custo
//        3- Filial
//        4- Geral

If nTipo == 1
	DET:= Sra->ra_Filial + " " + Sra->ra_MAT + "-" 
	DET+= If(nVerHor==1,Left(SRA->RA_NOME,30)+Space(01),Left(SRA->RA_NOME,30)+Space(1))
	FImpDet(2,3,1)
Elseif nTipo == 2
	If nVerHor = 2 // Se e' horizontal
		IMPR(REPL("-",COLUNAS),"C")
	Endif  // 64
 	DET:= cFilAnterior + " " + Substr(cCcAnt+"-"+DescCC(cCcAnt,cFilAnterior,18)+Space(38),1,38)
	DET+= If(nVerHor==1,Space(0),Space(1))
	FImpDet(4,5,2)
Elseif nTipo == 3
	DET:= cFilAnterior + "  " + Subs(aInfo[1],1,15) + Space(If(nVerHor==1,22,22))
	FImpDet(6,7,3)
	IMPR("","P")                // Salta Pagina apos Quebra Cc/Filial/Empresa
Elseif nTipo == 4
	DET:= STR0021 + If(nVerHor==1,Subs(aInfo[3],1,30)+Space(2),Subs(aInfo[3],1,33)+Space(1))  //"Empresa: "
	FImpDet(8,9,4)
	IMPR("","P")                // Salta Pagina apos Quebra Cc/Filial/Empresa
Endif
Return Nil

**********************************************************************
Static Function FAcumula(cPd,nHoras,nValor,AnoMes,DtPagto,Tipo1,Tipo2)
**********************************************************************
LOCAL n := 0, nCt, nAchou          
Local nValLiq := 0

n := Ascan(aTotais,{ |x| x[1]+X[10] = cPd+AnoMes } )
If n = 0 
	If nVerHor == 2
		For nCt:=1 to Len(cCodigos) Step 3
			nAchou := Ascan(aTotais,{ |x| x[1]+X[10] = SubStr(cCodigos,nCt,3)+AnoMes } )
			if nAchou = 0
				Aadd(aTotais,{SubStr(cCodigos,nCt,3),0,0,0,0,0,0,0,0,AnoMes," "," "," ",0,0,0,0,0})
			Endif
		Next
		n := Ascan(aTotais,{ |x| x[1]+X[10] = cPd+AnoMes } )
		If n > 0
			aTotais[n,2] += nHoras
			aTotais[n,3] += nValor
			aTotais[n,4] += nHoras
			aTotais[n,5] += nValor
			aTotais[n,6] += nHoras
			aTotais[n,7] += nValor
			aTotais[n,8] += nHoras
			aTotais[n,9] += nValor
			aTotais[n,11] := Left(DtPagto,6)+ right(DtPagto,2)
			aTotais[n,12] := Tipo1
			aTotais[n,13] := Tipo2
			If PosSrv(cPd,SRA->RA_FILIAL,"RV_TIPOCOD") == "1"
				nValLiq := nValor
			ElseIf SRV->RV_TIPOCOD == "2"
				nValLiq = nValor * (-1)
			EndIf
			aTotais[n,14] += nValLiq
			//--Acumula Liquido Func.
			aTotais[n,15] += nValLiq 
			//--Liquido Centro de Custo
			aTotais[n,16] += nValLiq
			//--Liquido Filial
			aTotais[n,17] += nValLiq
			//--Liquido Empresa
			aTotais[n,18] += nValLiq
		Endif	
	Else
		Aadd(aTotais,{cPd,nHoras,nValor,nHoras,nValor,nHoras,nValor,nHoras,nValor,AnoMes,DtPagto,Tipo1,Tipo2,0.00,0.00,0,0,0})
		If PosSrv(cPd,SRA->RA_FILIAL,"RV_TIPOCOD") == "1"
			nValLiq := nValor
		ElseIf SRV->RV_TIPOCOD == "2"
			nValLiq := nValor * (-1)
		EndIf
		aTotais[Len(aTotais),14] += nValLiq
		//--Liquido Funcionario
		aTotais[Len(aTotais),15] += nValLiq
		//--Liquido Centro de Custo
		aTotais[Len(aTotais),16] += nValLiq
		//--Liquido Filial
		aTotais[Len(aTotais),17] += nValLiq
		//--Liquido Empresa
		aTotais[Len(aTotais),18] += nValLiq
	Endif	
Else
	aTotais[n,2] += nHoras
	aTotais[n,3] += nValor
	aTotais[n,4] += nHoras
	aTotais[n,5] += nValor
	aTotais[n,6] += nHoras
	aTotais[n,7] += nValor
	aTotais[n,8] += nHoras
	aTotais[n,9] += nValor
	aTotais[n,11] := Left(DtPagto,6)+ right(DtPagto,2)
	aTotais[n,12] := Tipo1
	aTotais[n,13] := Tipo2
	If PosSrv(cPd,SRA->RA_FILIAL,"RV_TIPOCOD") == "1"
		nValLiq := nValor
	ElseIf SRV->RV_TIPOCOD == "2"
		nValLiq := nValor * (-1)
	EndIf
	aTotais[n,14] += nValLiq
	//--Liquido Funcionario
	aTotais[Len(aTotais),15] += nValLiq
	//--Liquido Centro de Custo
	aTotais[n,16] += nValLiq
	//--Liquido Filial
	aTotais[n,17] += nValLiq
	//--Liquido Empresa
	aTotais[n,18] += nValLiq
Endif
Return Nil

***************************
Static Function FZera(nCol)
***************************
Local nFor
For nFor := 1 To Len(aTotais)
	aTotais [nFor,nCol]   := 0   // Zera Totais de horas
	If nCol # 14
		aTotais [nFor,nCol+1] := 0   // Zera Totais de Valores
	Endif	
Next
Return Nil

*******************************
Static Function FTotaliza(nCol)
*******************************
LOCAL nTot := 0
AEVAL(aTotais,{ |x| nTot += If(x[1] <> " SB",x[nCol],0.00) })	// Despreza o salario base ao calcular os totais.
Return nTot

********************************************
Static Function FImpDet(nCol1,nCol2,nMsgTot)
********************************************
LOCAL lImprime := .F.
LOCAL cMsg[4]
LOCAL nTotHoras:=0, nTotValor:=0, cPdAnt:=Space(3)
LOCAL cMesAno, nCt, SubTotais:={}
Local nFor

If nVerHor == 1 //-- Vertical
	aTotais := aSort(aTotais,,,{ |x,y| x[1]+x[10] < y[1]+y[10] })
Else
	aTotais := aSort(aTotais,,,{ |x,y| x[10]+x[1] < y[10]+y[1] })
Endif
cMsg[1] := 'D O     F U N C I O N A R I O      '
cMsg[2] := 'D O     C E N T R O  D E  C U S T O'
cMsg[3] := 'D A     F I L I A L                '
cMsg[4] := 'D A     E M P R E S A              '

//Impressao Vertical
If nVerHor == 1		
	For nFor := 1 To Len(aTotais)
		If aTotais[nFor,nCol1]+aTotais[nFor,nCol2] # 0
			If aTotais[nFor,1] # " SB"
				If cPdAnt==Space(3)
					cPdAnt:=aTotais[nFor,1]
				Endif
				If cPdAnt # aTotais[nFor,1]
					If lTotais
						IMPR(Space(48)+STR0022+space(09)+TRANSFORM(nTotHoras,'@E 999999.99')+' '+TRANSFORM(nTotValor,cPict2),'C')  //"TOTAL DA VERBA      "
						IMPR(" ","C")
					EndIf
					cPdAnt:=aTotais[nFor,1] 	
					nTotHoras:=0
					nTotValor:=0
				Endif
				nTotHoras+=aTotais[nFor,nCol1]
				nTotValor+=aTotais[nFor,nCol2]
			Endif                                      
			//--Montagem da impressao meses diferentes da mesma verba
			If aTotais[nFor,1] # " SB" .And. ( nFor > 1 .And. aTotais[nFor,1] == aTotais[nFor-1,1])
				DET += Right(aTotais[nFor,10],2)+"/"+Left(aTotais[nFor,10],4)+" "
				DET += aTotais[nFor,12]+" "+aTotais[nFor,13]+Space(24)
			Else
				//--Montagem da 1o. impressão de uma determinada verba
				If aTotais[nFor,1] # " SB"
					DET += Right(aTotais[nFor,10],2)+"/"+Left(aTotais[nFor,10],4)+" "
					DET += aTotais[nFor,12]+" "+aTotais[nFor,13]+" "
				Else
					DET += Space(11)
				Endif
				//--Descricao da Verba

				DET += If(aTotais[nFor,1]=" SB","   ",aTotais[nFor,1])+" "+If(aTotais[nFor,1]=" SB",STR0012+SPACE(8),DescPd(aTotais[nFor,1],cFilAnterior,19))  //"SALARIO BASE"
			Endif
			//--Valores/Horas da verba a ser impressa.
 			DET +=" "+TRANSFORM(aTotais[nFor,nCol1],'@E 999999.99')+' '+TRANSFORM(aTotais[nFor,nCol2],cPict2)
			DET +=" "+If(nMsgTot==1,aTotais[nFor,11]," ")
			IMPR(DET,'C')
			lImprime := .T.
		Endif
		IF lImprime = .T.
			DET := Space(41)
		Endif
	Next	
	//--Impressão dos Totais ou Liquido conforme parametro
	If lTotais .Or. lLiquido
		If (nTotHoras+nTotValor) > 0 
			If lTotais
				IMPR(Space(48)+STR0022+space(09) +TRANSFORM(nTotHoras,'@E 999999.99')+' '+TRANSFORM(nTotValor,cPict2),'C')  //"TOTAL DA VERBA      "
				IMPR(" ","C")
			Endif
			nTotHoras:=0
			nTotValor:=0
		Endif
		If lLiquido 
			DET := Space(48) + Repl("-",53)
			IMPR(DET,'C')
			DET := Space(48) + STR0027 + Space(22) + TRANSFORM(FTotaliza(13+nMsgTot),cPict1)  //"TOTAL LIQUIDO"
			IMPR(DET,'C')
		EndIf
		DET := Space(5)+STR0019+Space(5)+cMsg[nMsgTot]+Space(16)+">>>>>"+Space(2) //"T O T A L"
		DET += TRANSFORM(FTotaliza(nCol1),'@E 999999.99')+' '
		DET += TRANSFORM(FTotaliza(nCol2),cPict2)
	Endif
	IF FTotaliza(nCol1)+FTotaliza(nCol2) # 0
		IMPR(" ","C")
		If(lTotais,IMPR(DET,"C"),)
		IMPR(REPLICATE('-',COLUNAS),'C')
	Endif
//Impressao Horizontal	
Else                                        
	// Quebra por centro de custo
	If nMsgTot == 2
		IMPR(DET,"C")
	EndIf	    
	
	For nFor := 1 To Len(aTotais)

		If aTotais[nFor,1] == " SB"
			cDetalhe := Space(35)+" "+STR0012+Space(If (nValHor = 1,1,0)) //"SALARIO BASE"
			If (nValHor=2 .and. aTotais[nFor,nCol1] > 0) .or. (nValHor=1 .and. aTotais[nFor,nCol2]>0 )
	 			cDetalhe +="  "+If(nValHor=2,TRANSFORM(aTotais[nFor,nCol1],'@E 9999999.99'),TRANSFORM(aTotais[nFor,nCol2],cPict2))
				If nMsgTot == 1 .Or. nMsgTot == 3
					IMPR(cDetalhe,'C')
				Endif
			EndIf
//			nTotHoras+=aTotais[nFor,nCol1]	// Comentadas as duas linhas para nao somar
//			nTotValor+=aTotais[nFor,nCol2]	// o salario base ao total da 1a coluna.
		Endif

		If aTotais[nFor,1] # " SB"
	
			cMesAno := aTotais[nFor,10]
			//-- Se for impressao do Funcionario/Analitico ou Filial/Sintetico
			If (nSinAna==2 .And. nMsgTot==1) .Or. (nMsgTot == 3 .And. nSinAna == 1)
				DET += Space(1)+Right(aTotais[nFor,10],2)+"/"+Left(aTotais[nFor,10],4)
			Else
				DET += Space(8)
			Endif		
			For nCt:=nFor to Len(aTotais)
				If cMesAno # aTotais[nCt,10]
					Exit
				Endif
				DET += '  ' + If(nValHor=2,TRANSFORM(aTotais[nCt,nCol1],'@E 999999.99'),TRANSFORM(aTotais[nCt,nCol2],cPict2))
				nMesAchou:= Ascan(SubTotais,{ |x| x[1] = aTotais[nCt,1] } )
				If nMesAChou == 0
					aadd(SubTotais,{aTotais[nCt,1] ,If(nValHor=2,aTotais[nCt,nCol1],aTotais[nCt,nCol2])})
				Else
					SubTotais[nMesAchou,2] += If(nValHor=2,aTotais[nCt,nCol1],aTotais[nCt,nCol2])
				Endif
			Next
			If FTotalHor(nCol1,nFor,(nCt-1))+FTotalHor(nCol2,nFor,(nCt-1) ) # 0
				If nMsgTot == 1 .Or. nMsgTot == 3
					IMPR(DET,'C')
				Endif
				lImprime := .T.
			Endif
			nFor:=(nCt-1)
	
			If lImprime
				DET := Space(41)
			Else
				DET := PadR(DET,41)
			EndIf
		Endif	
	Next
	nTot:=0
	AEVAL(SubTotais,{ |x| nTot += x[2] })
	If Len(SubTotais) # 0 .And. nTot > 0 .And. !(nMsgTot==1 .And. cAnoMesI==cAnoMesF)
		SubTotais := aSort(SubTotais,,,{ |x,y| x[1] < y[1] })
		DET := STR0019+Space(5)+cMsg[nMsgTot] + SPACE(2) //"T O T A L"
		For nCt:=1 to Len(SubTotais)
			If nCt==1
			 	nTotHoras+= SubTotais[nCt,2]
			 	nTotValor+= SubTotais[nCt,2]
				DET  += If(nValHor=2,TRANSFORM(nTotHoras,'@E 999999.99'),TRANSFORM(nTotValor,cPict2)) + '  '
			Else
				DET += If(nValHor=2,TRANSFORM(SubTotais[nCt,2],'@E 999999.99'),TRANSFORM(SubTotais[nCt,2] ,cPict2)) + '  '
			EndIf
		Next
		IMPR(" ","C")
		IMPR(DET,"C")
		IMPR(REPLICATE('-',COLUNAS),'C')
	Endif	
Endif

Return Nil

**************************************
Static Function FVerba(cCod,nTam,cFil)
**************************************
LOCAL cRet
If cCod = " SB"
	cRet := TRIM(Space(3)+"-"+Subs(STR0026,1,nTam))
	cRet := Space(nTam+4-Len(cRet))+ cRet
//	cRet := If(nTam>9,Space(nTam-5),"")+STR0026  //"SAL. BASE"
ElseIf cCod = "LIQ"
	cRet := TRIM(Subs(STR0027,1,nTam))
	cRet := Space(nTam+4-Len(cRet))+ cRet
//	cRet := If(nTam>9,Space(nTam-5),"")+STR0027  //"TOTAL LIQUIDO"
ElseIf cCod = "TOT"
	cRet := TRIM(Space(3)+" "+Subs(STR0019,1,nTam))
	cRet := Space(nTam+4-Len(cRet))+ cRet
//	cRet := If(nTam>9,Space(nTam-5),"")+STR0019  //"T O T A L"
Else
	cRet := TRIM(cCod+"-"+DescPd(cCod,cFil,nTam))
	cRet := Space(nTam+4-Len(cRet))+ cRet
Endif
Return cRet


******************************************
Static Function FTotalHor(nCol,Inicio,Fim)
******************************************
LOCAL nTot := 0, nConta
For nConta:=Inicio to Fim
    nTot += aTotais[nConta,nCol]
Next
Return nTot
