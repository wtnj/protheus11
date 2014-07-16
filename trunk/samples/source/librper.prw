#include "SIGAWIN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#include "RWMAKE.CH"
#INCLUDE "LibrPer.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ LibrPer    º Autor ³      Nava       º Data ³  07/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao ³ Livro de IGV Compras y Ventas (Localizacao Peru )         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Sintaxe   ³ LibrPer()                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parametro ³ NIL                                    			           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno   ³ NIL                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso       ³ SigaLoja - Localizacoes 											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LIBRPER()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


#DEFINE CPICTVAL0 	"@E)    99,999,999,999.99"
#DEFINE CPICTVAL1 	"@E)   999,999,999,999.99"
#DEFINE	CPICTVAL2	"@E) 9,999,999,999,999.99"
#DEFINE NLINESPAGE  55

LOCAL aRegs := {}

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("ASER,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY")
SetPrvt("LCONTINUA,WNREL,LFINREL")
SetPrvt("LTIPOS,NQ,CSTRING")
SetPrvt("CCHAVE,CFILTRO,CARQINDXF3")
SetPrvt("NLIN,NPAGINA")
SetPrvt("DENTANT")
SetPrvt("NA,NTIPO,AMESES,CEMPRESA")
SetPrvt("CINSCR,CRUCEMP,CTITULO,_NMES,NCNT1,ND")
SetPrvt("ADRIVER,NOPC,CCOR")
SetPrvt("J")

Private lVenda
Private lCLocal
Private lVIsenta
Private nTotalVal
Private nTotalBas
Private nTotalImp

// ----------  Pergunte
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros                         ³
//³mv_par01             // Fecha desde                          ³
//³mv_par02             // Fecha hasta                          ³
//³mv_par03             // Ventas o compras                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg := "LIBPER"
aRegs := {}

Aadd( aRegs,{ cPerg, "01","¨Data Inicio       ?","¨Fecha Inicio      ?","¨Fecha Inicio      ?","mv_ch1","D", 8,0,0,"G",;
                     "                                                            ",;
                     "mv_par01       ","               ","               ","               ","'01/01/80'                    ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","               ","                              ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","          ","                              ","   ","   " } )
Aadd( aRegs,{ cPerg, "02","¨Data Fim          ?","¨Fecha Fin         ?","¨Fecha Fin         ?","mv_ch2","D", 8,0,0,"G",;
                     "                                                            ",;
                     "mv_par02       ","               ","               ","               ","'31/12/01'                    ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","               ","                              ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","          ","                              ","   ","   " } )
Aadd( aRegs,{ cPerg, "03","¨Libro de          ?","¨Libro de          ?","¨Libro de          ?","mv_ch3","N", 1,0,2,"C",;
                     "                                                            ",;
                     "mv_par03       ","Vendas         ","Ventas         ","Vendas         ","                              ","               ","Compras        ","Compras        ","Compras        ","                              ",;
                     "               ","               ","               ","               ","                              ","               ","              .","               ","               ","                              ",;
                     "               ","               ","               ","          ","                              ","   ","   " } )
lValidPerg(aRegs)
Pergunte(cPerg,.F.)

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
aSer	:=	{}
tamanho:="G"
limite :=220
titulo   := PADC(OemtoAnsi(STR0001),74)   //"Emision del Subdiario de IGV"
cDesc1   := PADC(OemtoAnsi(STR0002),74)   //"Seran solicitadas la fecha inicial y la fecha final para la emision "
cDesc2   := PADC(OemtoAnsi(STR0003),74)   //"de los libros de IGV Ventas e IGV Compras"
cDesc3	 :=""
cNatureza:=""
aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 }  //"Especial"  "Administracion"
nomeprog :="LibrPer"
nLastKey := 0
lContinua:= .T.
wnrel    := "LibrPer"
lFinRel  := .F.
nQtdFt   := 0

//Busca aliquota e campos de gravacao do imposto IGV
dbSelectArea("SFB")
DbSetOrder(1)
nAliq 		:= 0
cCpoValImp  := "SF3->F3_VALIMP1"
cCpoBasImp  := "SF3->F3_BASIMP1"
If dbSeek(xFilial()+"IGV")
	nAliq := SFB->FB_ALIQ
	cCpoValImp := "SF3->F3_VALIMP"+SFB->FB_CPOLVRO  //Campo de gravacao do valor do imposto no arq. de Livros Fiscais
	cCpoBasImp := "SF3->F3_BASIMP"+SFB->FB_CPOLVRO  //Campo de gravacao da base do imposto no arq. de Livros Fiscais  
EndIf

DbSelectArea("SF3")

cString:="SF3"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas para parametros                         ³
//³mv_par01             // Fecha desde                          ³
//³mv_par02             // Fecha hasta                          ³
//³mv_par03             // Ventas o compras                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lVenda	:= ( mv_par03 == 1 )	// Venda
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	RptStatus({|| Execute(RptDetail)})
RptStatus({|| RptDetail()})
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RptDetail ºAutor  ³Nava                º Data ³  27/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de processamento do relatorio                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LibrPer                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	Function RptDetail
Static Function RptDetail()

LOCAL cRazaoSoc
LOCAL cCgc
LOCAL cPictCgc
LOCAL nBasImp
LOCAL nValImp

LOCAL nVentaNoGravada:= 0
LOCAL nExonerado 		:= 0
LOCAL cPoliza 			:= Space( 16 )
LOCAL cRefDoc			:= Space( 08 )
LOCAL cComp 			:= Space( 05 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara o SF3 para extracao dos dados            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF3")
Retindex("SF3")
//dbSelectArea("SF3")
cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.AND.DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+;
				"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"' .And.F3_TIPOMOV == "+ IF( lVenda, "'V'", "'C'" ) 

cChave := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CFO"

cArqIndxF3 := CriaTrab(NIL,.F.)

IndRegua("SF3",cArqIndxF3,cChave,,cFiltro,OemToAnsi(STR0006))  //"Filtrando registros..."
nindex := RetIndex("SF3")

#IFNDEF TOP
	//dbClearIndex()
	dbSetIndex(cArqIndxF3+OrdBagExt())
#ENDIF

dbSetOrder(nIndex+1)
nNroDoc := 0  // Fernando Dourado 03/12/99 Numero de documentos impressos

nTotalVlr := 0
nTotalBas := 0
nTotalImp := 0
nLin	:= 60
nPagina := 0

SetRegua(LastRec())

dbSelectArea("SF3")
dbGoTop()
dEntAnt	:= CTOD("")
DO WHILE !SF3->( Eof() )
	IncRegua()
	If LastKey() == 286
		@ 00,01 PSAY OemToAnsi(STR0007)  //"** CANCELADO PELO OPERADOR **"  
		Exit
	EndIf
	
	IF lAbortPrint
		@ 00,01 PSAY OemToAnsi(STR0007)  //"** CANCELADO PELO OPERADOR **"  
		lContinua := .F.
		Exit
	Endif

	If nLin > NLINESPAGE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dispara a funcao para impressao do Rodape.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		R020Cab()
	EndIf

	If !lVenda // Compra
		SA2->( DbSetOrder(1) )
		SA2->( DbSeek( xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
		cRazaoSoc:= SA2->A2_NOME
		cCgc	  	:=SA2->A2_CGC
		cPictCgc := PesqPict( "SA2", "A2_CGC" )
	Else
		IF SF3->F3_ESPECIE = "NCC"
			SF1->( DbSetOrder(1) )
			SF1->( DbSeek( xFilial("SF1")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
			cRefDoc := SF1->F1_NFORI  
		ELSE
			cRefDoc := Space( 8 )
		ENDIF		
		
		SA1->( DbSetOrder(1) )
		SA1->( DbSeek( xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
		cRazaoSoc:= SA1->A1_NOME
		cCgc		:= SA1->A1_CGC
		cPictCgc := PesqPict( "SA1", "A1_CGC" )
	EndIf

	nSigno := IF( ( lVenda .AND. F3_ESPECIE = "NCC") .OR. ( !lVenda .AND. F3_ESPECIE = "NDP" ) , -1, 1 )
	If ( Month(F3_ENTRADA)<>Month(dEntAnt).AND.Month(dEntAnt)<>0 )
		nPagina := 0
		lFinRel := .T.
		R020Rod()
		R020Cab()
		nTotalVlr := 0
		nTotalBas := 0
		nTotalImp := 0
	EndIf                      
	If ( F3_ENTRADA<>dEntAnt )
		dEntAnt := F3_ENTRADA
	EndIf
	@ nLin,000 PSAY F3_ENTRADA		
	@ nLin,009 PSAY F3_TPDOC
	IF ! Empty( F3_DTCANC )
		@ nLin, IF( !lVenda, 81, 11 ) PSAY F3_SERIE+' '+F3_NFISCAL	
		@ nLin, 100 PSAY OemToAnsi( STR0034 ) // "** ANULADA **"
		SF3->( DbSkip())
		LOOP
	ENDIF		

	nBasImp := &cCpoBasImp
	nValImp := &cCpoValImp

	IF !lVenda
		@ nLin,012 PSAY cComp
		@ nLin,018 PSAY cPoliza
		@ nLin,035 PSAY cCgc						Picture cPictCgc
		@ nLin,050 PSAY Left(cRazaoSoc,30)	Picture '@!'
		@ nLin,081 PSAY F3_SERIE+' '+F3_NFISCAL	
		@ nLin,097 PSAY nExonerado				Picture CPICTVAL0
		@ nLin,115 PSAY nBasImp * nSigno		Picture CPICTVAL0
		@ nLin,133 PSAY nValImp * nSigno		Picture CPICTVAL0
		@ nLin,151 PSAY F3_VALCONT	* nSigno	Picture CPICTVAL2
	ELSE
		@ nLin,012 PSAY F3_SERIE+F3_NFISCAL	
		@ nLin,027 PSAY cRefDoc
		@ nLin,036 PSAY Left(cRazaoSoc,30)	Picture '@!'
		@ nLin,067 PSAY cCgc						Picture cPictCgc
		@ nLin,082 PSAY nBasImp * nSigno		Picture CPICTVAL0
		@ nLin,100 PSAY nVentaNoGravada		Picture CPICTVAL0
		@ nLin,119 PSAY nValImp * nSigno		Picture CPICTVAL0
		@ nLin,137 PSAY F3_VALCONT	* nSigno	Picture CPICTVAL2
	ENDIF	

	nTotalVlr += F3_VALCONT	* nSigno
	nTotalBas += nBasImp * nSigno
	nTotalImp += nValImp * nSigno
	nLin := nLin + 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dispara a funcao para impressao do Rodape.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > NLINESPAGE
		R020Rod()
	EndIf
	SF3->( dbSkip() )
EndDo

lFinRel := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dispara a funcao para impressao do Rodape.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ( nPagina == 1 .and. nLin < NLINESPAGE )
	R020Rod()
EndIf
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
#IFNDEF TOP
	Ferase(cArqIndxF3+OrdBagExt())
#ENDIF
DbSelectArea("SF3")
DbSetOrder(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³R020Cab   ºAutor  ³Jose Lucas          º Data ³  06/07/98   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho do Libro de IGV ( Compras e Ventas ).             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LibrPer                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020Cab()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no cabecalho          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aMeses:={}
AADD(aMeses,OemToAnsi(STR0008))//"ENERO    "
AADD(aMeses,OemToAnsi(STR0009))//"FEBRERO  "
AADD(aMeses,OemToAnsi(STR0010))//"MARZO    "
AADD(aMeses,OemToAnsi(STR0011))//"ABRIL    "
AADD(aMeses,OemToAnsi(STR0012))//"MAYO     "
AADD(aMeses,OemToAnsi(STR0013))//"JUNIO    "
AADD(aMeses,OemToAnsi(STR0014))//"JULIO    "
AADD(aMeses,OemToAnsi(STR0015))//"AGOSTO   "
AADD(aMeses,OemToAnsi(STR0016))//"SETIEMBRE"
AADD(aMeses,OemToAnsi(STR0017))//"OCTUBRE  "
AADD(aMeses,OemToAnsi(STR0018))//"NOVIEMBRE"
AADD(aMeses,OemToAnsi(STR0019))//"DICIEMBRE"

cEmpresa	:= SM0->M0_NOMECOM
cInscr   := InscrEst()
cRucEmp	:= TRANSFORM(SM0->M0_CGC,PesqPict("SA1", "A1_CGC"))
cTitulo  := OemtoAnsi(STR0020) //"R E G I S T R O    D E   "
If lVenda
	cTitulo += OemtoAnsi(STR0022)//"V E N T A S"
Else
	cTitulo := cTitulo + OemtoAnsi(STR0021)//"C O M P R A S"
EndIf

nPagina := nPagina + 1
@ 02,000 PSAY OemToAnsi(STR0023) //"Empresa:"
@ 02,010 PSAY cEmpresa
@ 02,112 PSAY OemToAnsi(STR0024)//"Pagina Nro.:"
@ 02,125 PSAY StrZero(nPagina,6)

@ 03,000 PSAY OemToAnsi(STR0025)//"Ruc:"
@ 03,010 PSAY cRucEmp

_nMes := Month(mv_par02)

If _nMes > 0 .And. _nMes < 13
	@ 04,000 PSAY OemToAnsi(STR0026)//"Mes: "
	@ 04,010 PSAY aMeses[_nMes]
	@ 05,000 PSAY OemToAnsi(STR0027)//"Ano:"
	@ 05,010 PSAY StrZero(Year(mv_par02),4)
EndIf

@ 06,050 PSAY cTitulo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho para o Relatorio.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// COMPRAS
//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//					 FECHA - TD -COMP ---- POLIZA ---  ---- RUC ----- --------- PROVEEDOR ---------- SER - FACTURA - -- EXONERADOS --- ---- BASE IMP.--- ------ IGV ------ ------ TOTAL -------
//					99/99/99 xx xxxxx xxxxxxxxxxxxxxxx xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxx xxxxxxxxxxx 99,999,999,999.99 99,999,999,999.99 99,999,999,999.99 9,999,999,999,999.99 

// VENDAS
//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//					 FECHA - TD -- DOCUMENTO - REF.DOC. ---------- CLIENTE ----------- ---- RUC ----- ---- BASE IMP.---  VENTA NO GRAVADA ------ IGV ------- -- IMPORTE TOTAL ---
//					99/99/99 xx xxxxxxxxxxxxxx XXXXXXXX xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxx 99,999,999,999.99 99,999,999,999.99 999,999,999,999.99 9,999,999,999,999.99 

IF lVenda
	@ 08,000 PSAY OemToAnsi(STR0028) // FECHA - TD -- DOCUMENTO - REF.DOC. ---------- CLIENTE ----------- ---- RUC ----- ---- BASE IMP.---  VENTAS NO GRAVADA ----- IGV ------- -- IMPORTE TOTAL ---
ELSE
	@ 08,000 PSAY OemToAnsi(STR0029) // FECHA - TD -COMP ---- POLIZA ---  ---- RUC ----- --------- PROVEEDOR ---------- SER - FACTURA - -- EXONERADOS --- ---- BASE IMP.--- ------ IGV ------ ------ TOTAL -------
ENDIF

nLin := 10

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ R020Rod  ºAutor  ³Jose Lucas          º Data ³  06/07/98   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Libro de IGV ( Compras e Ventas ).               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LibrPer                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Rod
Static Function R020Rod()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dispara a funcao para impressao do Rodape.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := nLin + 1
//                  8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//            456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//        Totales :         999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999,999.99
@ nLin,000 PSAY OemToAnsi(STR0030) //"Totales :"

IF !lVenda
	@ nLin,114 PSAY nTotalBas	Picture CPICTVAL1
	@ nLin,132 PSAY nTotalImp	Picture CPICTVAL1
	@ nLin,151 PSAY nTotalVlr	Picture CPICTVAL2
ELSE
	@ nLin,081 PSAY nTotalBas	Picture CPICTVAL1
	@ nLin,118 PSAY nTotalImp	Picture CPICTVAL1
	@ nLin,137 PSAY nTotalVlr	Picture CPICTVAL2
ENDIF

nLin := nLin +1

If  !(lFinRel)
	R020Cab()
	@ nLin,000 PSAY OemToAnsi(STR0031) //"Transporte :"
	IF !lVenda
		@ nLin,114 PSAY nTotalBas	Picture CPICTVAL1
		@ nLin,132 PSAY nTotalImp	Picture CPICTVAL1
		@ nLin,151 PSAY nTotalVlr	Picture CPICTVAL2
	ELSE
		@ nLin,081 PSAY nTotalBas	Picture CPICTVAL1
		@ nLin,118 PSAY nTotalImp	Picture CPICTVAL1
		@ nLin,137 PSAY nTotalVlr	Picture CPICTVAL2
	ENDIF
	nLin:= nlin+1
EndIf
lFinRel := .F.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ VerImp   ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica posicionamento de papel na Impressora             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LibrPer                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
aDriver:=ReadDriver()
If aReturn[5]==2
	
	nOpc       := 1
	DO WHILE .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ 00   ,000	PSAY aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		If MsgYesNo(OemtoAnsi(STR0032))//"¨Fomulario esta posicionado ? "
			nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0033))//"¨Tenta Nuevamente ? "
			nOpc := 2
		Else
			nOpc := 3
		Endif
		
		Do Case
		Case nOpc==1
			lContinua:=.T.
			Exit
		Case nOpc==2
			Loop
		Case nOpc==3
			lContinua:=.F.
			Return
		EndCase
	End
Endif
Return
