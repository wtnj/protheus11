#Include "Conr240.Ch"
#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONR240  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27.04.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Orcados X Reais                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CONR240(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NhCon005()
Local Wnrel
LOCAL cString:="SIA"
LOCAL cDesc1 := OemToAnsi(STR0001)  //"Este programa ir  imprimir o Relat¢rio de Or‡ados x Reais,"
LOCAL cDesc2 := OemToAnsi(STR0002)  //"tomando como base os Or‡amentos j  feitos e de acordo com"
LOCAL cDesc3 := OemToAnsi(STR0003)  //"os parametros solicitados pelo usu rio."
LOCAL tamanho:="M"
PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="CONR240"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="COR240"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("COR240",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        // Data Inicial do periodo desejado          ³
//³ mv_par02        // da conta                                  ³
//³ mv_par03        // ate a conta                               ³
//³ mv_par04        // Moeda                                     ³
//³ mv_par05        // Descricao na Lingua                       ³
//³ mv_par06        // do Centro de Custo                        ³
//³ mv_par07        // Ate o centro de custo                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no arquivo SIGACONR.INI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE titulo := OemToAnsi(STR0006)  //"Relatorio de Orcados x Reais"
PRIVATE cabec1 :=OemToAnsi(STR0007)  //"CONTA                                        DESCRICAO                           VALOR ORCADO       VALOR REALIZADO       VARIACAO %"


PRIVATE cabec2 := " "
PRIVATE cCancel:= OemToAnsi(STR0008)  //"***** CANCELADO PELO OPERADOR *****"
PRIVATE cTitulo:= OemToAnsi(STR0009)  //"Mapa Orcados x Reais"
PRIVATE cDe		:= OemToAnsi(STR0010)  //" de "
PRIVATE cEm		:= OemToAnsi(STR0011)  //" em "
PRIVATE cAte	:= OemToAnsi(STR0012)  //" ate "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="CONR240"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| Cr240Imp(@lEnd,wnRel,cString,Tamanho)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ Cr240Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao Orcados x Reais                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Cr240Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACON                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Cr240Imp(lEnd,WnRel,cString,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lTemCC   := .F.
LOCAL lProcSI1 := .F.
LOCAL CbTxt
LOCAL CbCont
LOCAL limite   := 132
LOCAL cConta, cDesc, nReal, nOrcado, nVariacao
LOCAL aDataAtu
Local lEstrang
Local cDigVer	:= GetMv("MV_DIGVER")
LOCAL cPeriodo      
Local nTotOrc := 0
Local nTotReal:= 0
Local cCC                    
Local cDescCC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula datas iniciais e finais							           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMoeda 	:= mv_par04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula data inicial										           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPeriodo := Strzero(Year(mv_par01),4)
cMesAtu17 := StrZero(Month(mv_par01),2)

titulo	:= cTitulo + cDe + Dtoc(mv_par01) + ;
				cEm + GetMv("MV_MOEDA"+str(nmoeda,1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se centro de custo esta em uso                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SX3" )
dbSetOrder( 2 )
dbSeek( "IA_CC" )
If X3USO( X3_USADO )

//            0         1         2         3         4         5         6         7         8         9         0         1         2
//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
    cabec1 :=OemToAnsi(STR0013)+Upper(RetTitle("I3_CUSTO",15))+OemToAnsi(STR0014)  //"CONTA                        "###" DESCRICAO                           VALOR ORCADO       VALOR REALIZADO       VARIACAO %"
    lTemCC := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se descricao em outra lingua      	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lEstrang := .F.
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("I1_DESCEST")
If X3USO(X3_USADO)
	If mv_par05 == 2
		lEstrang := .T.
	EndIf
EndIf		
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza registro a ser impresso                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SIA" )
dbSetOrder( 1 )
dbSeek( cFilial+mv_par02,.T. )

SetRegua(Reccount())

cCC := Mv_par06  //primeiro Centro de Custo

While IA_FILIAL == cFilial .and. IA_CONTA >= mv_par02 .and. ;
  	IA_CONTA <= mv_par03 .and. ! Eof()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
     
	IncRegua()

//	If (SIA->IA_CC < mv_par06)  .or. (SIA->IA_CC > mv_par07 ) .And. lTemCC
	If SIA->IA_CC >= mv_par06 .And. SIA->IA_CC <= mv_par07 .And. lTemCC
   	      
   	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a moeda                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IA_MOEDA != mv_par04
			dbSkip()
			Loop
		EndIF

		If IA_ANO != cPeriodo
			dbSkip()
			Loop
		Endif
		
		If IA_SITUAC != "01"		// Apenas Orcado Original
			dbSkip()
			Loop
		Endif
		
		IF li > 56
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,;
			Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
		EndIF
	
		cConta := SIA->IA_CONTA
		cDesc  := Space(35)
		dbSelectArea("SI1")
		dbSetOrder(1)
	
		If dbSeek(cFilial+cConta)
			If lEstrang
				cDesc := Substr(SI1->I1_DESCEST,1,30)
			Else
				cDesc := Substr(SI1->I1_DESC,1,30)
			EndIf		  
		EndIf
	
	   cCusto  := CRIAVAR( "IA_CC" )
	
	   If lTemCC
			dbSelectArea( "SI3" )
			dbSetOrder(1)
			If dbSeek( xFilial("SI3") + SIA->IA_CC + SIA->IA_CONTA + Str(mv_par04,1) )
	      	   cCusto := SIA->IA_CC
			EndIf     
   		    If dbSeek( xFilial("SI3") + SIA->IA_CC + Space(20))
	      	   cDescCC := SI3->I3_DESC // Descricao do centro de custo
	      	Else
	      	   cDescCC := " "   
			EndIf
		EndIf
	
	/*	dbSelectArea("SIA")
	    nRecno    := Recno()
	    If ! dbSeek( xFilial("SIA")+ cConta + cCusto )
	   		dbGoTo( nRecno )
			dbSkip()
	      	Loop
		EndIf
	  */
		If ! lTemCC .or. Empty( cCusto )
	   		nReal := Movimento(cConta,Val(cMesAtu17),mv_par04,mv_par01)
		ElseIf lTemCC .And. !Empty( cCusto )
	   		nReal := MovimCC(cCusto,cConta,Val(cMesAtu17),mv_par04,mv_par01)
		EndIf
	
		dbSelectArea("SIA")
		nOrcado := Abs(&('SIA->IA_VLORC'+cMesAtu17))
	
		nVariacao := (nReal / nOrcado) * 100
	
	//	dbGoTo( nRecno )
/*		If SIA->IA_CC == cCC
 		   nTotOrc  += Abs(&('SIA->IA_VLORC'+cMesAtu17))
		   nTotReal += Abs(nReal)	                                                                                   
		Else                                   
  		   @li+2, 0 PSAY "TOTAL DO CENTRO DE CUSTO " + cCC
		   @li+2, 82  PSAY Transform(nTotOrc,"@e 9,999,999,999.99")
		   @li+2, 101 PSAY Transform(nTotReal,"@e 9,999,999,999.99")
		   @li+2, 123 PSAY Transform((nTotReal/nTotOrc)*100,"@e 999.99")
		   @li+2, 130 PSAY "%"
   		   nTotOrc  := Abs(&('SIA->IA_VLORC'+cMesAtu17))
		   nTotReal := Abs(nReal)
		   cCC := SIA->IA_CC // Atualiza Centro de Custo	                                                                                   
		Endif   */
	    nTotOrc  += &('SIA->IA_VLORC'+cMesAtu17)
 	    nTotReal += nReal	                                                                                   

		li++
		If cDigVer == "S"
		   @li, 00  PSAY mascara(Alltrim(cConta)+SI1->I1_DC)
		Else
		   @li, 00  PSAY mascara(cConta)
		EndIf	
	    @li, 29  PSAY IIf( lTemCC, SIA->IA_CC, " " )
	    @li, 45  PSAY cDesc
		@li, 81  PSAY &('SIA->IA_VLORC'+cMesAtu17) Picture tm(&('SIA->IA_VLORC'+cMesAtu17),17,,lEstrang)
	    @li, 100 PSAY nReal                   Picture tm(nReal,17,,lEstrang)
	    @li, 122 PSAY Abs(nVariacao)               Picture tm(Abs(nVariacao),7,,lEstrang)
	    @li, 130 PSAY "%"

	Endif    
	dbSelectArea("SIA")
	dbSkip()
EndDO
// Para imprimir o ultimo centro de custo
@li+2, 0 PSAY "TOTAL DO CENTRO DE CUSTO "+ cCC + " - "+cDescCC
@li+2, 82  PSAY Transform(nTotOrc,"@e 9,999,999,999.99")
@li+2, 101 PSAY Transform(nTotReal,"@e 9,999,999,999.99")
@li+2, 123 PSAY Transform((nTotReal/nTotOrc)*100,"@e 999.99")
@li+2, 130 PSAY "%"

IF li != 80
	roda(0,"",Tamanho)
EndIF

Set Filter To

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()
Return
