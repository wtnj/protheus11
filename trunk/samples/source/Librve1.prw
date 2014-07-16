#include "SIGAWIN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#include "RWMAKE.CH"
#INCLUDE "LIBRVE1.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa  � LibrvE1    � Autor �      Nava       � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
��� Descricao � Livro de IVA Compras y Ventas (Localizacao Venezuela)     ���
�������������������������������������������������������������������������͹��
��� Sintaxe   � LibrvE1()                                                 ���
�������������������������������������������������������������������������͹��
��� Parametro � NIL                                    			           ���
�������������������������������������������������������������������������͹��
��� Retorno   � NIL                                                       ���
�������������������������������������������������������������������������͹��
��� Uso       � SigaLoja - Localizacoes 											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LibrVE1()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������


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
SetPrvt("CINSCR,CRIF,CTITULO,_NMES,NCNT1,ND")
SetPrvt("ADRIVER,NOPC,CCOR")
SetPrvt("J")

Private lVenda
Private lCLocal
Private lVIsenta
Private nTotalVal
Private nTotalBas
Private nTotalImp

// ----------  Pergunte
//�������������������������������������������������������������Ŀ
//�Variaveis utilizadas para parametros                         �
//�mv_par01             // Fecha desde                          �
//�mv_par02             // Fecha hasta                          �
//�mv_par03             // Ventas o compras                     �
//���������������������������������������������������������������

cPerg := "LIBVE1"
aRegs := {}

Aadd( aRegs,{ cPerg, "01","�Data Inicio        ","�Fecha Inicio       ","�Fecha Inicio       ","mv_ch1","D", 8,0,0,"G",;
                     "                                                            ",;
                     "mv_par01       ","               ","               ","               ","'01/01/80'                    ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","               ","                              ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","          ","                              ","   ","   " } )
Aadd( aRegs,{ cPerg, "02","�Data Fim           ","�Fecha Fin          ","�Fecha Fin          ","mv_ch2","D", 8,0,0,"G",;
                     "                                                            ",;
                     "mv_par02       ","               ","               ","               ","'31/12/01'                    ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","               ","                              ","               ","               ","               ","               ","                              ",;
                     "               ","               ","               ","          ","                              ","   ","   " } )
Aadd( aRegs,{ cPerg, "03","�Livro de           ","�Libro de           ","�Libro de           ","mv_ch3","N", 1,0,2,"C",;
                     "                                                            ",;
                     "mv_par03       ","Vendas Contrib.","Ventas Contrib.","Ventas Contrib.","                              ","               ","Vendas Isentas ","Ventas Exentas ","Ventas Exentas ","                              ",;
                     "               ","Compras Locais ","Compras Locales","Compras Locales","                              ","               ","Compras Import.","Compras Import.","Compras Import.","                              ",;
                     "               ","               ","               ","          ","                              ","   ","   " } )
AjustaSX1(aRegs)
Pergunte(cPerg,.F.)

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
aSer	:=	{}
tamanho:="M"
limite :=132
titulo   := PADC(OemtoAnsi(STR0001),74)   //"Emision del Subdiario de IVA"
cDesc1   := PADC(OemtoAnsi(STR0002),74)   //"Seran solicitadas la fecha inicial y la fecha final para la emision "
cDesc2   := PADC(OemtoAnsi(STR0003),74)   //"de los libros de IVA Ventas e IVA Compras"
cDesc3	 :=""
cNatureza:=""
aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 }  //"Especial"  "Administracion"
nomeprog :="LIBRVE1"
cPerg    :="LIBVE1"
nLastKey := 0
lContinua:= .T.
wnrel    := "LIBRVE1"
lFinRel  := .F.
nQtdFt   := 0

//Busca aliquota e campos de gravacao do imposto IVA
dbSelectArea("SFB")
DbSetOrder(1)
nAliq 		:= 0
cCpoValImp  := "SF3->F3_VALIMP1"
cCpoBasImp  := "SF3->F3_BASIMP1"
If dbSeek(xFilial()+"IVA")
	nAliq := SFB->FB_ALIQ
	cCpoValImp := "SF3->F3_VALIMP"+SFB->FB_CPOLVRO  //Campo de gravacao do valor do imposto no arq. de Livros Fiscais
	cCpoBasImp := "SF3->F3_BASIMP"+SFB->FB_CPOLVRO  //Campo de gravacao da base do imposto no arq. de Livros Fiscais  
EndIf

DbSelectArea("SF3")

cString:="SF3"

//�������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT           �
//���������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

//����������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora       �
//������������������������������������������������������

VerImp()

//�������������������������������������������������������������Ŀ
//�Variaveis utilizadas para parametros                         �
//�mv_par01             // Fecha desde                          �
//�mv_par02             // Fecha hasta                          �
//�mv_par03             // Ventas o compras                     �
//���������������������������������������������������������������
lVenda	:= ( mv_par03 <  3 )	// Venda
lCLocal	:= ( mv_par03 == 3 )	// Compra Locale
lVIsenta	:= ( mv_par03 == 2 )	// Venta Exenta


//���������������������������������������������Ŀ
//� Inicio do Processamento do Relatorio.       �
//�����������������������������������������������

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	RptStatus({|| Execute(RptDetail)})
RptStatus({|| RptDetail()})
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RptDetail �Autor  �Nava                � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de processamento do relatorio                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	Function RptDetail
Static Function RptDetail()

LOCAL cRazaoSoc
LOCAL cCgc
LOCAL cPictCgc
LOCAL nBasImp
LOCAL nValImp

//��������������������������������������������������Ŀ
//� Prepara o SF3 para extracao dos dados            �
//����������������������������������������������������

dbSelectArea("SF3")
Retindex("SF3")
//dbSelectArea("SF3")
cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.AND.DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+;
				"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"' .And.F3_TIPOMOV == "+ IF( lVenda, "'V'", "'C'" ) 
IF lVenda 
	IF lVIsenta
		cFiltro += " .AND. F3_EXENTAS > 0 "
	ELSE
		cFiltro += " .AND. F3_EXENTAS = 0 "
	ENDIF				
ENDIF

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
		//�������������������������������������������������������Ŀ
		//�Dispara a funcao para impressao do Rodape.             �
		//���������������������������������������������������������
		R020Cab()
	EndIf
	If !lVenda // Compra
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek( xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
		cRazaoSoc:= SA2->A2_NOME
		cCgc	  	:=SA2->A2_CGC
		cPictCgc := PesqPict( "SA2", "A2_CGC" )
		IF ( lClocal 	.AND. SA2->A2_TIPO <> "3" ) .OR. ;
			( !lClocal 	.AND. SA2->A2_TIPO <> "4" )
			SF3->( DbSKip() )
			LOOP
		ENDIf						
	Else
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
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
	@ nLin, 000 PSAY F3_ENTRADA		
	@ nLin,009 PSAY F3_SERIE+F3_NFISCAL	
	IF ! Empty( F3_DTCANC )
		@ nLin, 024 PSAY OemToAnsi( STR0034 ) // "** ANULADA **"
		SF3->( DbSkip())
		LOOP
	ENDIF		

//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//             ------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL ------- ---- BASE IMP.---   %  ------ IVA ------
//					99/99/99 xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxx 9,999,999,999,999.99 99,999,999,999.99 99,9 99,999,999,999.99 
	nBasImp := &cCpoBasImp
	nValImp := &cCpoValImp

	@ nLin,024 PSAY Left(cRazaoSoc,30)	Picture '@!'
	@ nLin,055 PSAY cCgc						Picture cPictCgc
   @ nLin,070 PSAY F3_VALCONT	* nSigno	Picture CPICTVAL2
	IF !lVIsenta
	   @ nLin,091 PSAY nBasImp * nSigno		Picture CPICTVAL0
	   @ nLin,110 PSAY nAliq						Picture "99.9"
	   @ nLin,114 PSAY nValImp * nSigno		Picture CPICTVAL0
	ENDIF	
	nTotalVlr += F3_VALCONT	* nSigno
	nTotalBas += nBasImp * nSigno
	nTotalImp += nValImp * nSigno
	nLin := nLin + 1
	
	//����������������������������������������������������������Ŀ
	//� Dispara a funcao para impressao do Rodape.               �
	//������������������������������������������������������������
	
	If nLin > NLINESPAGE
		R020Rod()
	EndIf
	SF3->( dbSkip() )
EndDo

lFinRel := .T.

//������������������������������������������������������Ŀ
//� Dispara a funcao para impressao do Rodape.           �
//��������������������������������������������������������

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �R020Cab   �Autor  �Jose Lucas          � Data �  06/07/98   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cabecalho do Libro de IVA ( Compras e Ventas ).             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020Cab()

//��������������������������������������������Ŀ
//� Variaveis utilizadas no cabecalho          �
//����������������������������������������������

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
cRif	   := TRANSFORM(SM0->M0_CGC,PesqPict("SA1", "A1_CGC"))
cTitulo  := OemtoAnsi(STR0020) //"L I B R O   D E   "
If lVenda
	cTitulo += OemtoAnsi(STR0022)//"V E N T A S"
	IF lVIsenta
		cTitulo += OemtoAnsi(STR0037)  //" E X E N T A S "
	ELSE
		cTitulo += OemtoAnsi(STR0038)  //" C O N T R I B U Y E N T E S "
	ENDIF	
Else
	cTitulo := cTitulo + OemtoAnsi(STR0021)//"C O M P R A S"
	IF lCLocal
		cTitulo += OemtoAnsi(STR0036) //" L O C A L E S "
	ELSE
		cTitulo += OemtoAnsi(STR0035) //" I M P O R T A C I O N "
	ENDIF	
EndIf

nPagina := nPagina + 1
@ 02,000 PSAY OemToAnsi(STR0023) //"Empresa:"
@ 02,010 PSAY cEmpresa
@ 02,112 PSAY OemToAnsi(STR0024)//"Pagina Nro.:"
@ 02,125 PSAY StrZero(nPagina,6)

@ 03,000 PSAY OemToAnsi(STR0025)//"Rif:"
@ 03,010 PSAY cRif

_nMes := Month(mv_par02)

If _nMes > 0 .And. _nMes < 13
	@ 04,000 PSAY OemToAnsi(STR0026)//"Mes: "
	@ 04,010 PSAY aMeses[_nMes]
	@ 05,000 PSAY OemToAnsi(STR0027)//"Ano:"
	@ 05,010 PSAY StrZero(Year(mv_par02),4)
EndIf

@ 06,050 PSAY cTitulo
//�����������������������������������������������Ŀ
//� Cabecalho para o Relatorio.                   �
//�������������������������������������������������
//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//             ------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL ------- ---- BASE IMP.---   %  ------ IVA ------
//					99/99/99 xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxx 9,999,999,999,999.99 99,999,999,999.99 99,9 99,999,999,999.99 
IF !lVIsenta
	@ 08,000 PSAY OemToAnsi(STR0028) //------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL ------- ---- BASE IMP.---   %  ------ IVA ------"
ELSE
	@ 08,000 PSAY OemToAnsi(STR0029) //------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL -------"
ENDIF

nLin := 10

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � R020Rod  �Autor  �Jose Lucas          � Data �  06/07/98   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rodape do Libro de IVA ( Compras e Ventas ).               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Rod
Static Function R020Rod()

//������������������������������������������������������Ŀ
//� Dispara a funcao para impressao do Rodape.           �
//��������������������������������������������������������

nLin := nLin + 1
//                  8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//            456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//        Totales :         999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999,999.99
@ nLin,000 PSAY OemToAnsi(STR0030) //"Totales :"
@ nLin,070 PSAY nTotalVlr	Picture CPICTVAL2
IF !lVIsenta
	@ nLin,090 PSAY nTotalBas	Picture CPICTVAL1
	@ nLin,113 PSAY nTotalImp	Picture CPICTVAL1
ENDIF
nLin := nLin +1

If  !(lFinRel)
	R020Cab()
	@ nLin,000 PSAY OemToAnsi(STR0031) //"Transporte :"
	@ nLin,071 PSAY nTotalVlr	Picture CPICTVAL2
	IF !lVIsenta
		@ nLin,090 PSAY nTotalBas	Picture CPICTVAL1
		@ nLin,113 PSAY nTotalImp	Picture CPICTVAL1
	ENDIF
	nLin:= nlin+1
EndIf
lFinRel := .F.

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VerImp   �Autor  �Marcos Simidu       � Data �  20/12/95   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica posicionamento de papel na Impressora             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		
		@ 00   ,000	PSAY &aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		If MsgYesNo(OemtoAnsi(STR0032))//"�Fomulario esta posicionado ? "
			nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0033))//"�Tenta Nuevamente ? "
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa  � AjustaSX1  � Autor �      Nava       � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
��� Descricao � Verifica as perguntas, inclu�ndo-as caso n�o existam		  ���
�������������������������������������������������������������������������͹��
��� Sintaxe   � AjustaSX1( aRegs )													  ���
�������������������������������������������������������������������������͹��
��� Parametros� aRegs - Array com os parametros abaixo : 					  ���
���        01 � 	Nome da Pergunta		,;	 // X1_GRUPO						  ���
���        02 � 	Sequencia da Pergunta,;	 // X1_ORDEM						  ���
���        03 � 	Titulo Perg. Padrao	,;	 // X1_PERGUNT						  ���
���        04 � 	Titulo Perg. Espanhol,;	 // X1_PERSPA						  ���
���        05 � 	Titulo Perg. Ingles	,;	 // X1_PERENG						  ���
���        06 � 	Variavel					,;	 // X1_VARIAVL						  ���
���        07 � 	Tipo						,;	 // X1_TIPO   						  ���
���        08 � 	Tamanho					,;	 // X1_TAMANHO						  ���
���        09 � 	Decimais					,;	 // X1_DECIMAL						  ���
���        10 � 	Opcao Pre Selecionada,;	 // X1_PRESEL 						  ���
���        11 � 	Tipo da Pergunta		,;	 // X1_GSC    						  ���
���        12 � 	Validacao				,;	 // X1_VALID  						  ���
���        13 � 	Nome Var  1	      	,;	 // X1_VAR01  						  ���
���        14 � 	Definicao 1	Padrao	,;	 // X1_DEF01  						  ���
���        15 � 	Definicao 1 Espanhol	,;	 // X1_DEFSPA1						  ���
���        16 � 	Definicao 1 Ingles 	,;	 // X1_DEFENG1						  ���
���        17 � 	Conteudo  1				,;	 // X1_CNT01						  ���
���        18 � 	Nome Var  2       	,;	 // X1_VAR02  						  ���
���        19 � 	Definicao 2	Padrao	,;	 // X1_DEF02  						  ���
���        20 � 	Definicao 2 Espanhol	,;	 // X1_DEFSPA2						  ���
���        21 � 	Definicao 2 Ingles 	,;	 // X1_DEFENG2						  ���
���        22 � 	Conteudo  2				,;	 // X1_CNT02						  ���
���        23 � 	Nome Var  3       	,;	 // X1_VAR03  						  ���
���        24 � 	Definicao 3	Padrao	,;	 // X1_DEF03  						  ���
���        25 � 	Definicao 3 Espanhol	,;	 // X1_DEFSPA3						  ���
���        26 � 	Definicao 3 Ingles 	,;	 // X1_DEFENG3						  ���
���        27 � 	Conteudo  3				,;	 // X1_CNT03						  ���
���        28 � 	Nome Var  4       	,;	 // X1_VAR04  						  ���
���        29 � 	Definicao 4	Padrao	,;	 // X1_DEF04  						  ���
���        30 � 	Definicao 4 Espanhol	,;	 // X1_DEFSPA4						  ���
���        31 � 	Definicao 4 Ingles 	,;	 // X1_DEFENG4						  ���
���        32 � 	Conteudo  4				,;	 // X1_CNT05						  ���
���        33 � 	Nome Var  5       	,;	 // X1_VAR05						  ��� 
���        34 � 	Definicao 5	Padrao	,;	 // X1_DEF05  						  ���
���        35 � 	Definicao 5 Espanhol	,;	 // X1_DEFSPA5						  ���
���        36 � 	Definicao 5 Ingles 	,;	 // X1_DEFENG5						  ���
���        37 � 	Conteudo  5				,;	 // X1_CNT05						  ���
���        38 � 	Consulta F3				,;	 // X1_F3						  	  ��� 
���        39 � 	Grupo SXG   			}   // GRPSXG						     ���
�������������������������������������������������������������������������͹��
��� Retorno   � NIL                                                       ���
�������������������������������������������������������������������������͹��
��� Uso       � Generico - Protheus 508/609										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1( aRegs )

LOCAL nSX1Order:= SX1->(IndexOrd())
LOCAL nFCount	:= SX1->( Fcount() )
LOCAL nARegs	:= Len( aRegs )
LOCAL nI

SX1->(dbSetOrder(1))

FOR nI := 1 TO nARegs
	IF !SX1->(dbSeek(aRegs[nI][1]+aRegs[nI][2]))
		RecLock('SX1',.T.)
		Aeval( aRegs[nI], {|e,n| SX1->( FieldPut( n, e ) ) },, nFCount )
		MsUnlock()
	ENDIF
NEXT nI		

SX1->(dbSetOrder(nSX1Order))

RETURN NIL