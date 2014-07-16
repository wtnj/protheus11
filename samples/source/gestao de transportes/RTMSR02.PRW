#INCLUDE "protheus.ch"
#INCLUDE "rtmsr02.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR02  ³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Ordem de Coleta                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR02                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestao de Transporte                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ANTONIO C F ³03.05.02³      ³Ajustes.                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR02()

LOCAL titulo  := STR0001 //"Impressao da Ordens de Coleta"
LOCAL cString := "DTQ"
LOCAL wnrel   := "RTMSR02"
LOCAL cDesc1  := STR0002 //"Este programa ira listar as Ordens de Coleta"
LOCAL cDesc2  := ""
LOCAL cDesc3  := ""
LOCAL tamanho := "M"

PRIVATE aReturn  := {STR0003,1,STR0004,1, 2, 1, "",1 } //"Zebrado"###"Administracao"
PRIVATE cPerg    := "RTMR02"
PRIVATE nLastKey := 0

//Chamada do relatorio padrao
If FindFunction("TRepInUse") .And. TRepInUse()
	TMSR580()
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Viagem Inicial	                          ³
//³ mv_par02        	// Viagem Final       	                    ³
//³ mv_par03        	// Impressao/ Reimpressao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("RTMR02",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR02Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR02Imp³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR02			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR02Imp(lEnd,wnRel,titulo,tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cRe_Impressao  := mv_par03
Local nLin			   := 80
Local li             := 99
Local cDestCarga 	   := ""
Local cDescri 		   := ""
Local cDocTMS        := StrZero(1, Len(DT6->DT6_DOCTMS)) // Documento coleta.
Local cCond          := ""
Local cIndDT6        := ""
Local cKeyDT6        := ""
Local nIndDT6        := 0
Local nQtdVol        := 0
Local nPeso          := 0
Local cRota          := ""
Local cDescRota      := ""

Private m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice condicional no DT6(Documentos).                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DT6")
cIndDT6 := CriaTrab(Nil, .F.)
cKeyDT6 := IndexKey()

cCond += 'DT6_FILIAL=="'+xFilial("DT6")+'".And.'
cCond += 'DT6_FILORI=="'+cFilAnt+'".And.'
cCond += 'DT6_DOC>="'+mv_par01+'".And.DT6_DOC<="'+mv_par02+'".And.'
cCond += 'DT6_DOCTMS=="'+cDocTMS+'"'

IndRegua("DT6",cIndDT6,cKeyDT6,,cCond,STR0040) //"Selecionando Registros..."
nIndDT6 := RetIndex("DT6")
DbSelectArea("DT6")
DbSetOrder(nIndDT6+1)
DbGoTop()
SetRegua(LastRec())

While !Eof()
	If Interrupcao(@lEnd)
		Exit
	Endif
	
	If DT6->DT6_FIMP == "1" .And. cRe_Impressao==1
		DbSkip()
		Loop
	EndIf
	
	cDestCarga := ""
	cDescri 	  := ""
	nLin       := 80
	
	IncRegua()
	
	/* Busca a descricao da rota. */
	cDescRota := Space(Len(DA8->DA8_DESC))
	DT5->(dbSetOrder(4))
	DTQ->(dbSetOrder(2))
	DA8->(dbSetOrder(1))
	If DT5->(MsSeek(xFilial("DT5")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
		If DT5->DT5_STATUS == StrZero(1,Len(DT5->DT5_STATUS)) // Em Aberto
			cRota := DT5->DT5_ROTPRE
		Else
			DTQ->(MsSeek(xFilial('DTQ')+DT6->(DT6_FILVGA+DT6_NUMVGA)))
			cRota := DTQ->DTQ_ROTA
		EndIf			
		If DA8->(MsSeek(xFilial("DA8")+cRota))
			cDescRota := DA8->DA8_DESC
		EndIf
	EndIf				
	
	DT5->(dbSetOrder(4))    // DT5_FILIAL+DT5_FILDOC+DT5_DOC+DT5_SERIE
	DT5->(dbSeek(xFilial("DT5")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
		
	//-- Imprime cabecalho com os Dados da Empresa
	RTMSR02Cabec(@nLin, cDescRota)
	
	//-- IMPRIME OS DADOS DA CARGA 
	DUM->(dbSetOrder(1))
	DUM->(MsSeek(xFilial("DUM")+DT5->(DT5_FILORI+DT5_NUMSOL)))
	While !DUM->(Eof()) .And. xFilial("DUM")+DT5->(DT5_FILORI+DT5_NUMSOL) == DUM->(DUM_FILIAL+DUM_FILORI+DUM_NUMSOL)		
	   
	   If nLin > 55
			//-- Imprime cabecalho com os Dados da Empresa
			RTMSR02Cabec(@nLin, cDescRota)
		EndIf	

		If li > 55
		   //Imprime o cabecalho dos dados da Carga
			@nLin,000 PSay Padc(" " + STR0013 + " ",132,"=")
			nLin++			
     		@nLin,000 PSay STR0041 //"Produto                         Embalagem  Volume Previsto  Peso Previsto   Volume Real    Peso Real"
			nLin++	     		
		EndIf

	   @nLin,000 PSay RTrim(Posicione("SB1", 1, xFilial('SB1') + DUM->DUM_CODPRO, "B1_DESC"))   
		@nLin,032 PSay	DUM->DUM_CODEMB
		@nLin,043 PSay	Alltrim(TransForm(DUM->DUM_QTDVOL,PesqPict("DUM","DUM_QTDVOL")))	                                                                   
		@nLin,060 PSay Alltrim(TransForm(DUM->DUM_PESO,PesqPict("DUM","DUM_PESO")))		
		@nLin,076 PSay "___________" //"Volume Real "		
		@nLin,089 PSay "___________" //"Peso Real   "
		nLin++         
		nQtdVol += DUM->DUM_QTDVOL
		nPeso   += DUM->DUM_PESO
		li := nLin		
		DUM->(dbSkip())		
	
	EndDo	            
	
	nLin++
	
	@nLin,000 PSay STR0042 //'T O T A L --> '
	@nLin,075 PSay Alltrim(TransForm(nQtdVol,PesqPict("DUM","DUM_QTDVOL")))	                                                                   
	@nLin,092 PSay Alltrim(TransForm(nPeso,PesqPict("DUM","DUM_PESO")))	                                                                   	
	@nLin,108 PSay "___________" 
	@nLin,121 PSay "___________" 	
	nLin+=5
	   
   If nLin > 55
		//-- Imprime cabecalho com os Dados da Empresa
		RTMSR02Cabec(@nLin, cDescRota)
	EndIf	
	
	//-- Imprime Dados
	@nLin,000 PSay Padc("",132,"")
	nLin+=1
	@nLin,000 PSay STR0021 + DTOC(DT5->DT5_DATSOL) + "   " + Transform(DT5->DT5_HORSOL,PesqPict('DT5','DT5_HORSOL')) //"Data Pedido : "
	@nLin,050 PSay STR0022 + "___________" //"Hora Cheg. : "
	@nLin,080 PSay STR0023 + "___________" //"Hora Saida : "
	nLin+=1
	@nLin,050 PSay STR0025 + "___________________" //"Veiculo : "
	@nLin,088 PSay STR0043 + "___________" //"Km.: "
	nLin+=1
	@nLin,000 PSay STR0027   //"Observacao : "

   If nLin > 55
		//-- Imprime cabecalho com os Dados da Empresa
		RTMSR02Cabec(@nLin, cDescRota)
	EndIf	
	
	cDescri := MsMM(DT5->DT5_CODOBS,300)
	While Len( cDescri ) > 0
		@ nLin, 018 PSay AllTrim(Substr( cDescri, 1, 100 ))
		cDescri := Substr( cDescri, 101 )
		nLin++
	EndDo

   If nLin > 55
		//-- Imprime cabecalho com os Dados da Empresa
		RTMSR02Cabec(@nLin, cDescRota)
	EndIf	
	
	nLin+=2
	@ nLin,020  PSay "_______________________"
	@ nLin,050  PSay "_______________________________________"
	nLin+=1
	@ nLin,020  Psay STR0028      //"         Data          "
	@ nLin,050  PSay STR0029      //"             Assinatura                "
	nLin+=1
	
	//-- Atualiza campo DT6_FIMP (Flag de Impressao)
	DT6->( RecLock("DT6", .F.) )
	DT6->DT6_FIMP := "1"
	DT6->( MsUnlock() )
	
	dbSelectArea("DT6")
	DbSkip()
EndDo


dbSelectArea("DT6")
RetIndex("DT6")
cIndDT6 += OrdBagExt()
Ferase(cIndDT6)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR02Cab³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Cabecalho com os Dados da Empresa                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR02Cabec(ExpN1)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR02			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR02Cabec(nLin, cDescRota)

Local lSE := .F.

If nLin > 55
	nLin:=0
	@ 00,00 PSAY AvalImp(132)
EndIf	

//----------------- IMPRIME OS DADOS DA EMPRESA
nLin+=1
@nLin,000 PSay Padc(STR0044,132," ") //"ORDEM DE COLETA DE CARGAS"
nLin+=1
@nLin,000 PSay SM0->M0_CODFIL+"  " +SM0->M0_FILIAL+"  " +SM0->M0_NOME
nLin+=1
@nLin,000 PSay SM0->M0_ENDCOB
@nLin,060 PSay STR0035 + DT6->DT6_FILORI+ "  " + DT6->DT6_DOC+"/"+DT6->DT6_SERIE //"Ordem de Coleta : "
nLin+=1
@nLin,000 PSay STR0036 + DT5->DT5_FILORI + "/" + DT5->DT5_NUMSOL
@nLin,060 PSay STR0037 + DT5->DT5_TIPCOL +;
Iif(DT5->DT5_TIPCOL == StrZero(1, Len(DT5->DT5_TIPCOL)), STR0038, STR0039)
nLin+=1
@nLin,000 PSay SM0->M0_CEPCOB+"  " +  SM0->M0_ENDCOB+"  " +SM0->M0_ESTCOB
@nLin,060 PSay SM0->M0_TEL+"  "+ SM0->M0_FAX
nLin+=1
@nLin,000 PSay STR0032 + DTOC(DT6->DT6_DATEMI) + "   " + Transform(DT6->DT6_HOREMI,PesqPict('DT6','DT6_HOREMI')) //"Emissao : "
@nLin,060 PSay STR0045 + " : " + SM0->M0_CGC //"CGC : "
nLin+=1
@nLin,000 PSay STR0046 + SM0->M0_INSC //"Insc. Estadual..: "
@nLin,060 PSay STR0034 + cDescRota //DA8->DA8_DESC // "Rota : "
nLin+=1

//----------------- IMPRIME OS DADOS DO SOLICITANTE  
DUE->(dbSetOrder(1)) //Solicitantes
DUE->(MsSeek(xFilial("DUE")+DT5->( DT5_DDD+DT5_TEL )))                           
		
If !Empty(DT5->DT5_SEQEND)
	DUL->(dbSetOrder(1)) // Endereco de Solicitantes
	DUL->(MsSeek(xFilial("DUE")+DT5->(DT5_DDD+DT5_TEL+DT5_SEQEND)))
	lSE := .T.
EndIf

@nLin,000 PSay Padc(" " + STR0047 + " ",132,"=") //"SOLICITANTE"
nLin+=1
@nLin,000 PSay STR0006 + DUE->DUE_NOME  //"Nome : "
nLin+=1
@nLin,000 PSay STR0007 + If(lSE,DUL->DUL_END,DUE->DUE_END) //"Endereco : "
nLin+=1
@nLin,000 PSay STR0008 + If(lSE,DUL->DUL_BAIRRO,DUE->DUE_BAIRRO) //"Bairro : "
@nLin,067 PSay STR0048 + Transform(If(lSE,DUL->DUL_CEP,DUE->DUE_CEP),PesqPict("DUE","DUE_CEP")) //"CEP : "
nLin+=1
@nLin,000 PSay STR0009 + If(lSE,DUL->DUL_MUN,DUE->DUE_MUN) //"Cidade : "
@nLin,067 PSay STR0049 + If(lSE,DUL->DUL_EST,DUE->DUE_EST) //"UF  : "
nLin+=1
@nLin,000 PSay STR0045 + ".............: " + Transform(DUE->DUE_CGC,PesqPict("DUE","DUE_CGC")) //"CGC.............: "
@nLin,055 PSay STR0046 + Transform(DUE->DUE_INSCR,PesqPict("DUE","DUE_INSCR")) //"Insc. Estadual..: "
nLin+=1
@nLin,000 PSay STR0011 + "(" + DUE->DUE_DDD +")" + DUE->DUE_TEL //"Telefone : "
@nLin,055 PSay STR0054 + DUE->DUE_CONTAT //"Contato : "
nLin+=1
@nLin,000 PSay STR0050 + Transform(DUE->DUE_HORCOI,PesqPict("DUE","DUE_HORCOI")) +; //"Efetuar coleta : "
STR0051 + Transform(DUE->DUE_HORCOF,PesqPict("DUE","DUE_HORCOF")) //" as "
@nLin,055 PSay STR0052 + Dtoc(DT5->DT5_DATPRV) //"Data Previsao de Coleta : "
nLin+=1
@nLin,000 PSay STR0053 + Transform(DT5->DT5_HORPRV, PesqPict("DT5", "DT5_HORPRV")) //"Hora Previsao de Coleta : "
nLin+=1

Return Nil