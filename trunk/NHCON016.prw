#Include "ctbr280.Ch"
#Include "PROTHEUS.Ch"

//Tradu��o PTG 20080721

/*/  
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � Ctbr280  � Autor � Claudio Donizete      � Data � 20.12.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Rela�ao de Movimentos Acumulados p/ CC Extra               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr280  ()                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NHCON016()

Private cAliasCT1, cAliasCTT
Private Li := 0

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

U_CTBR280R3()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CTBR280R4 � Autor �Paulo Carnelossi       � Data �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao do Relatorio para release 4 utilizando obj tReport   ���
���          �Relatorio de alocacao de recursos                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
User Function CTBR280R4()

Local aArea		:= GetArea()
Local cPerg  := "CTR280"
Local cMensagem
Local aMeses := {}
Local nMeses := 0
Local aPeriodos
Local nCont

Private aoTotal := {}
Private aoTotal1 := {}
Private nDecim_ := 2
Private cPict_ := ""

Pergunte(cPerg, .T.)

// Localiza o periodo contabil para os calendarios da moeda 
aPeriodos := ctbPeriodos(mv_par07, mv_par01, mv_par02, .T., .F.)
If Empty(aPeriodos[1][1])
	cMensagem	:= STR0017
	cMensagem	+= STR0018
    MsgInfo(cMensagem)
	Return
EndIf

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
		nMeses += 1           					
	Else
		AADD(aMeses,{"  ",ctod("  /  /  "),ctod("  /  /  ")})
	EndIf
Next     

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport := ReportDef(aPeriodos, aMeses, nMeses)

If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf	

oReport:PrintDialog()

RestArea(aArea)
	
Return
*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Paulo Carnelossi       � Data �04/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(aPeriodos, aMeses, nMeses)

Local oReport
Local oCentroCusto
Local oSaldos
Local nX
Local cPerg := "CTR280"
Local aOrdem := {}
Local oBreak, oTotal

dbSelectArea("CT1")
dbSetOrder(1)

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������

oReport := TReport():New("NHCON016",OemToAnsi(STR0006), cPerg, ;
			{|oReport| If(!ct040Valid(mv_par10), oReport:CancelPrint(), ReportPrint(aPeriodos, aMeses, nMeses))},;
			STR0001+CRLF+RetTitle("CT3_CUSTO",15)+OemToAnsi(STR0010)+CRLF+OemToAnsi(STR0003) )

oReport:SetLandScape()
oReport:ParamReadOnly()

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oCentroCusto := TRSection():New(oReport, AllTrim(RetTitle("CTT_CUSTO"))+" x "+AllTrim(RetTitle("CT1_CONTA")), {"CT1"}, aOrdem, .F., .F.)

TRCell():New(oCentroCusto,	"CTT_CUSTO"	,"CTT",/*Titulo*/,/*Picture*/,22,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oCentroCusto,	"CTT_DESC01","CTT",/*Titulo*/,/*Picture*/,25/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oCentroCusto,	"CT1_CONTA"	,"CT1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
TRCell():New(oCentroCusto,	"CT1_DESC01","CT1",/*Titulo*/,/*Picture*/,25/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

oCentroCusto:Cell("CTT_DESC01"):SetCellBreak()
oCentroCusto:Cell("CT1_DESC01"):SetCellBreak()
oCentroCusto:Cell("CTT_DESC01"):SetTitle(STR0020)		//"Desc"
oCentroCusto:Cell("CT1_DESC01"):SetTitle(STR0020)

oCentroCusto:SetLineStyle()

oCentroCusto:SetHeaderSection(.F.)	//Nao imprime o cabe�alho da secao

oBreak:= TRBreak():New(oCentroCusto,{||.T.},"")

oSaldos := TRSection():New(oCentroCusto, STR0021, {"CT1"}, /*aOrdem*/, .F., .F.) //"Valores"

For nX := 1 To Len(aPeriodos)           
	TRCell():New(oSaldos,	"VALOR_PER"+StrZero(nX,2),"",STR0022 + Dtoc(aPeriodos[nX][2])/*Titulo*/,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/,,,"RIGHT") //"Ate "
	aAdd(aoTotal, TRFunction():New(oSaldos:Cell("VALOR_PER"+StrZero(nX,2)),"Valor_Periodo_"+StrZero(nX,2) ,"SUM",oBreak,/*cTitle*/,/*cPicture*/,MontaBlock("{||aSaldos["+StrZero(nX,2)+"][1]}")/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/))
	aoTotal[Len(aoTotal)]:Disable()
	aAdd(aoTotal1,TRFunction():New(oSaldos:Cell("VALOR_PER"+StrZero(nX,2)),"Valor_Periodo_"+StrZero(nX,2) ,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,MontaBlock("{|| ValorCTB(aoTotal["+StrZero(nX,2)+"]:GetValue(),,,17,nDecim_,.T.,cPict_,,,,,,,,.F.) }")/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/))
Next

oSaldos:SetLeftMargin(20)
oSaldos:SetLineBreak()
oSaldos:SetHeaderPage()	//Define o cabecalho da secao como padrao

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Paulo Carnelossi      � Data �29/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �que faz a chamada desta funcao ReportPrint()                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �ExpO1: Objeto TReport                                       ���
���          �ExpC2: Alias da tabela de Planilha Orcamentaria (AK1)       ���
���          �ExpC3: Alias da tabela de Contas da Planilha (Ak3)          ���
���          �ExpC4: Alias da tabela de Revisoes da Planilha (AKE)        ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(aPeriodos, aMeses, nMeses)

Local oCentroCusto:= oReport:Section(1)
Local oSaldos		:= oReport:Section(1):Section(1)
Local cPerg  		:= "CTR280"
Local lImpCC 		:= .T., lImpConta := .T.
Local nDecimais 	:= 2
Local cCtt_Custo
Local aCtbMoeda 	:= {}
Local cMascConta
Local cMascCus
Local cSepConta 	:= ""
Local cSepCus   	:= ""
Local cPicture
Local nX
Local aTotalCC
Local nCol
Local nTotais
Local cCodRes
Local cCodResCC
Local nDigitAte 	:= 0
Local lFirst		:= .T.
Local cMensagem	:= ""
Local nPos			:= 0
Local lComSaldo	:= .F.
Local cString   	:= "CT1"
Local lImprime 	:= .T.
#IFDEF TOP
Local lAs400	:= Upper(TcSrvType()) == "AS/400"
#ENDIF
Private aSaldos

aSetOfBook := CTBSetOf(mv_par10)

nDecimais 	:= DecimalCTB(aSetOfBook,mv_par07)
nDecim_     := nDecimais

If Empty(aSetOfBook[2])
	cMascConta := GetMv("MV_MASCARA")
	cMascCus	  := GetMv("MV_MASCCUS")
Else
	cMascConta := RetMasCtb(aSetOfBook[2],@cSepConta)
	cMascCus   := RetMasCtb(aSetofBook[6],@cSepCus)
EndIf

cPicture 	:= aSetOfBook[4]
cPict_      := cPicture

//Seta numero de pagina inicial
oReport:SetPageNumber(MV_PAR08)
oReport:SetParam(cPerg)

//	Se nenhuma moeda foi escolhida, sai do programa
aCtbMoeda  	:= CtbMoeda(mv_par07)
If Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	Set Filter To
	oReport:CancelPrint()
Endif

//��������������������������������������������������������������Ŀ
//� Localiza centro de custo inicial                             �
//����������������������������������������������������������������
dbSelectArea("CTT")
dbSetOrder(1)
dbSeek( xFilial("CTT")+mv_par03,.T. )

TRPosition():New(oCentroCusto,"CTT",1,{|| xFilial("CTT") + (cAliasCTT)->CTT_CUSTO})
TRPosition():New(oCentroCusto,"CT1",1,{|| xFilial("CT1") + (cAliasCT1)->CT1_CONTA})

oReport:SetMeter(RecCount())

aTotalCC  := Array(Len(aPeriodos))
oReport:SetTitle(oReport:Title() + " " + aPeriodos[1][3]) // Adiciona o exercicio ao titulo

oReport:SetTitle(oReport:Title() + " ("+ DTOC(mv_par01)+" - "+DTOC(mv_par02) +") ")
If mv_par19 == 2
	oReport:SetTitle(oReport:Title() + " - "+STR0019)
Endif

// Verifica Se existe filtragem Ate o Segmento
If !Empty(mv_par12)
	nDigitAte := CtbRelDig(mv_par12,cMascCus) 	
EndIf		

If !Empty(mv_par13)			//// FILTRA O SEGMENTO N�
	If Empty(mv_par10)		//// VALIDA SE O C�DIGO DE CONFIGURA��O DE LIVROS EST� CONFIGURADO
		help("",1,"CTN_CODIGO")
		oReport:CancelPrint()
	Else
		If !Empty(aSetOfBook[5])
			MsgInfo(STR0023+CHR(10)+STR0024,STR0025) //"O plano gerencial ainda n�o est� dispon�vel para este relat�rio."###"Altere a configura��o de livros..."###"Config. de Livros..."
			oReport:CancelPrint()
		Endif
	Endif

	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+aSetOfBook[7])
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == aSetOfBook[7]
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(mv_par13),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		help("",1,"CTM_CODIGO")
		oReport:CancelPrint()
	EndIf
EndIf 

oCentroCusto:Cell("CTT_CUSTO"):SetBlock({||		If(mv_par18 == 1 /*Imprime Cod. CC Normal*/, ;
													EntidadeCtb(cCtt_Custo,li,00,15,.f.,cMascCus,cSepCus,/*cAlias*/,/*nOrder*/,/*lGraf*/,/*oPrint*/,.F./*lSay*/);
												,;
													/* Imprime codigo reduzido*/;
													EntidadeCtb(cCodResCC,li,00,15,.f.,cMascCus,cSepCus,/*cAlias*/,/*nOrder*/,/*lGraf*/,/*oPrint*/,.F./*lSay*/);
												) })

oCentroCusto:Cell("CTT_DESC01"):SetBlock({|| CtbDescMoeda("(cAliasCTT)->CTT_DESC"+MV_PAR07)})

oCentroCusto:Cell("CT1_CONTA"):SetBlock({||		If(mv_par17==1/*Imprime Cod. Conta Normal*/,;
													EntidadeCTB(&("(cAliasCT1)->CT1_CONTA"),++li,00,20,.F.,cMascConta,cSepConta,/*cAlias*/,/*nOrder*/,/*lGraf*/,/*oPrint*/,.F./*lSay*/);
												,;
													EntidadeCTB(cCodRes,++li,00,20,.F.,cMascConta,cSepConta,/*cAlias*/,/*nOrder*/,/*lGraf*/,/*oPrint*/,.F./*lSay*/);
												) })
oCentroCusto:Cell("CT1_DESC01"):SetBlock({|| CtbDescMoeda("(cAliasCT1)->CT1_DESC" + MV_PAR07)})

For nX := 1 TO Len(aPeriodos)
	oSaldos:Cell("VALOR_PER"+StrZero(nX,2)):SetPicture(cPicture)
Next //nX

cAliasCT1 := "CT1"
cAliasCTT := "CTT"

#IFDEF TOP
	If !lAs400
		MsAguarde({|| U_CTR280Qry(aMeses,mv_par07,mv_par09,mv_par05,mv_par06,mv_par03,mv_par04,aSetOfBook,mv_par11 == 1,cString,oCentroCusto:GetAdvplExp()/*aReturn[7]*/,.F./*lImpAntLP*/,/*dDataLP*/) }, STR0006 )
		cAliasCT1 := "TRBTMP"
		cAliasCTT := "TRBTMP"
	Else
		// Processa o arquivo de centro de custos, dentro dos parametros do usuario
		dbSelectArea(cAliasCTT)
		dbSetOrder(1)
	Endif
#ELSE
	// Processa o arquivo de centro de custos, dentro dos parametros do usuario
	dbSelectArea(cAliasCTT)
	dbSetOrder(1)
#ENDIF                    
While (cAliasCTT)->(!Eof()) .And. (cAliasCTT)->CTT_FILIAL==xFilial("CTT") .And. (cAliasCTT)->CTT_CUSTO <= mv_par04
	
	oReport:IncMeter()
	lImprime := .T.
	
	// Guarda o centro de custo para ser utilizado na quebra	
	cCtt_Custo 	:= (cAliasCTT)->CTT_CUSTO
	cCodResCC	:= (cAliasCTT)->CTT_RES
	lImpCC     	:= .T.
	aFill(aTotalCC,0) 			// Zera o totalizador por periodo
	
	******************** "FILTRAGEM PARA IMPRESSAO" *************************
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(mv_par12)
		If Len(Alltrim((cAliasCTT)->CTT_CUSTO)) > nDigitAte
			(cAliasCTT)->(dbSkip())
			Loop
		Endif
	EndIf
	
	//Caso faca filtragem por segmento de item,verifico se esta dentro 
	//da solicitacao feita pelo usuario. 
	If !Empty(mv_par13)
		If Empty(mv_par14) .And. Empty(mv_par15) .And. !Empty(mv_par16)
			If  !(Substr((cAliasCTT)->CTT_CUSTO,nPos,nDigitos) $ (mv_par16) ) 
				(cAliasCTT)->(dbSkip())
				Loop
			EndIf	
		Else
			If Substr((cAliasCTT)->CTT_CUSTO,nPos,nDigitos) < Alltrim(mv_par14) .Or. Substr((cAliasCTT)->CTT_CUSTO,nPos,nDigitos) > Alltrim(mv_par15)
				(cAliasCTT)->(dbSkip())
				Loop
			EndIf	
		Endif
	EndIf	                                        
	
	************************* ROTINA DE IMPRESSAO *************************
								
	#IFNDEF TOP
		If (cAliasCTT)->CTT_CLASSE == "1"		// Sintetica
			(cAliasCTT)->(DbSkip())
			Loop
		Endif
	
		// Localiza os saldos do centro de custo
		dbSelectArea(cAliasCT1)
		dbSetOrder(1)			 	// Filial+Custo+Conta+Moeda
		dbSeek(xFilial("CT1")+mv_par05, .T.)
	
	#ELSE
		If lAs400
			If (cAliasCTT)->CTT_CLASSE == "1"		// Sintetica
				(cAliasCTT)->(DbSkip())
				Loop
			Endif

			// Localiza os saldos do centro de custo
			dbSelectArea(cAliasCT1)
			dbSetOrder(1)			 	// Filial+Custo+Conta+Moeda
			dbSeek(xFilial("CT1")+mv_par05, .T.)
		Endif
	#ENDIF
		
	oCentroCusto:Init()
	oSaldos:Init()
	// Obtem os saldos do centro de custo
	While !Eof() .And. (cAliasCT1)->CT1_FILIAL == xFilial("CT1") .And. (cAliasCTT)->CTT_CUSTO == cCtt_Custo .And. (cAliasCT1)->CT1_CONTA <= mv_par06
		IF oReport:Cancel()
			Exit
		EndIf
    		              
		lImpConta 	:= .T.
        lImprime := lImpCC .OR. lImpConta

		cCt3_Conta  := (cAliasCT1)->CT1_CONTA //CT3->CT3_CONTA
		nCol 	  	:= 1 
		aSaldos 	:= {}
		For nX := 1 TO Len(aPeriodos)
			oSaldos:Cell("VALOR_PER"+StrZero(nX,2)):SetValue({|| 0 })
		Next //nX
		nTotais 	:= 0
		
		#IFDEF TOP    
			If !lAs400
				For nX := 1 To Len(aPeriodos)
					If aPeriodos[nX][1] >= mv_par01 .And. aPeriodos[nX][2] <= mv_par02 
						If mv_par19 == 2 
							aAdd(aSaldos,{ &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))+nTotais,0,0,0,0,0} )/// ACUMULA MOVIMENTO
						Else 
							aAdd(aSaldos,{ &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))        ,0,0,0,0,0} )/// POR PERIODO (SEM ACUMULAR)
						EndIf
						nTotais += &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))
					Else
						Aadd(	aSaldos, {0,0,0,0,0,0})
					Endif
				Next
			Else
		#ENDIF
 
			If (cAliasCT1)->CT1_CLASSE = "1"		// Sintetica
				(cAliasCT1)->(DbSkip())
				Loop
			Endif
	
			For nX := 1 To Len(aPeriodos)
				//	Obtem o saldo acumulado ate o ultimo dia do periodo
				// da moeda escolhida.
				If aPeriodos[nX][2] >= mv_par01 .And. aPeriodos[nX][2] <= mv_par02
					If mv_par19 == 2 // ACUMULA MOVIMENTO
						Aadd(aSaldos,SaldoCt3((cAliasCT1)->CT1_CONTA,cCtt_Custo,aPeriodos[nX][2],mv_par07,MV_PAR09))			
					Else  // POR PERIODO (SEM ACUMULAR)
						Aadd(aSaldos,SaldoCt3((cAliasCT1)->CT1_CONTA,cCtt_Custo,aPeriodos[nX][2],mv_par07,MV_PAR09))			
						aSaldos[nX][1] -= nTotais
					EndIf
					nTotais += aSaldos[nX][1]
				Else
					Aadd(	aSaldos, {0,0,0,0,0,0})						
				EndIf
			Next
  		#IFDEF TOP    
  			Endif
  		#ENDIF

		lComSaldo	:= .F.  		
  		For nX := 1 To Len(aPeriodos)
  		    If aSaldos[nX][1]  <> 0 
  		    	lComSaldo	:= .T.
				Exit  		    	
  		    EndIf  		
  		Next

		If mv_par11 == 1  .And. !lComSaldo
		
	  		#IFDEF TOP	
				If !lAs400	  		
					If CtbExDtFim("CTT")  
						//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
						//relatorio for maior, nao ira imprimir a entidade. 
						If !Empty((cAliasCTT)->CTTDTEXSF) .And. (dtos(mv_par01) > DTOS((cAliasCTT)->CTTDTEXSF))  
							dbSelectArea(cAliasCT1)
							dbSkip()
							Loop													
						EndIf
					EndIf				
						
					If CtbExDtFim("CT1")  
						//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
						//relatorio for maior, nao ira imprimir a entidade. 
						If !Empty((cAliasCT1)->CT1DTEXSF) .And. (dtos(mv_par01) > DTOS((cAliasCT1)->CT1DTEXSF))  
							dbSelectArea(cAliasCT1)
							dbSkip()
							Loop													
						EndIf
					EndIf	  						
						
				Else
			#ENDIF	
				If CtbExDtFim("CTT")  			
					If !CtbVlDtFim("CTT",mv_par01) 
						dbSelectArea(cAliasCT1)
						dbSkip()
						Loop																	
					EndIf				
				EndIf
				
				If CtbExDtFim("CT1")
					If !CtbVlDtFim("CT1",mv_par01) 
						dbSelectArea(cAliasCT1)
						dbSkip()
						Loop																						
					EndIf				
				EndIf			
	  		#IFDEF TOP			  	
	  			EndIf
			#ENDIF		  		
		EndIf
			
		// Se imprime saldos zerados ou 
		// se nao imprime saldos zerados e houver valor,
		// imprime os saldos
		If mv_par11 == 1 .OR. (mv_par11 == 2 .AND. nTotais != 0)
			For nX := 1 To Len(aSaldos)
				IF oReport:Cancel()
					Exit
				EndIf
		
				// Imprime o Centro de Custo
				If lImpCC
					oCentroCusto:Cell("CTT_CUSTO"):Show()
					oCentroCusto:Cell("CTT_DESC01"):Show()
					lImpCC := .F.
					lFirst := .F.
				Endif
				
				// Imprime a Conta
				If lImpConta
					cCodRes := (cAliasCT1)->CT1_RES
					lImpConta := .F.
					oCentroCusto:Cell("CTT_CUSTO"):Show()
					oCentroCusto:Cell("CTT_DESC01"):Show()
					oCentroCusto:Cell("CT1_CONTA"):Show()
					oCentroCusto:Cell("CT1_DESC01"):Show()
				EndIf
				
				If lImprime
					oCentroCusto:PrintLine()
					//oReport:ThinLine()
				EndIf	
                
				If ! lImpCC
					oCentroCusto:Cell("CTT_CUSTO"):Hide()
					oCentroCusto:Cell("CTT_DESC01"):Hide()
  				EndIf

				If ! lImpConta
					oCentroCusto:Cell("CTT_CUSTO"):Hide()
					oCentroCusto:Cell("CTT_DESC01"):Hide()
					oCentroCusto:Cell("CT1_CONTA"):Hide()
					oCentroCusto:Cell("CT1_DESC01"):Hide()
  				EndIf

                lImprime := lImpCC .OR. lImpConta
				// Imprime o valor
				//ValorCTB(aSaldos[nX][1],li,48+(nCol++*19),17,nDecimais,.T.,cPicture)
				//aTotalCC[nX] += aSaldos[nX][1]
				oSaldos:Cell("VALOR_PER"+StrZero(nX,2)):SetValue(ValorCTB(aSaldos[nX][1],li,48+(nCol++*19),17,nDecimais,.T.,cPicture,/*cTipo*/,/*cConta*/,/*lGraf*/,/*oPrint*/,/*cTipoSinal*/,/*cIdentifi*/,/*lPrintZero*/,.F./*lSay*/))
			Next
			oSaldos:PrintLine()
		Endif	
	
		// Vai para a proxima conta
		dbSelectArea(cAliasCT1)
		(cAliasCT1)->(DbSkip())
	EndDo
	
	If !lFirst
		// Quebrou o Centro de Custo
		If !lImpCC
			//oReport:ThinLine()
			oReport:Say(oReport:Row()+10, 10, ;
							OemToAnsi(STR0012)+RetTitle("CTT_CUSTO",7)+": "+;
							If(mv_par18 == 1/*Imprime Cod. CC Normal*/, ;
								EntidadeCtb(cCtt_Custo,li,PCOL(),15,.F.,cMascCus,cSepCus,/*cAlias*/,/*nOrder*/,/*lGraf*/,/*oPrint*/,.F./*lSay*/), ;
								EntidadeCtb(cCodResCC,li,PCOL(),15,.F.,cMascCus,cSepCus,/*cAlias*/,/*nOrder*/,/*lGraf*/,/*oPrint*/,.F./*lSay*/)))
        EndIf
    EndIf
    oSaldos:Finish()        
    oCentroCusto:Finish()
	
//	oReport:ThinLine()
				
	dbSelectArea(cAliasCTT)
	#IFNDEF TOP
		dbSetOrder(1)
		(cAliasCTT)->(dbSkip())
	#ELSE
	 	If lAs400
 			dbSetOrder(1)
			(cAliasCTT)->(dbSkip())
	 	Endif
	#ENDIF       
Enddo

#IFNDEF TOP
	dbsetOrder(1)
	Set Filter To
#ELSE
	If lAs400
		dbsetOrder(1)
		Set Filter To
	Endif
#ENDIF

Return

//-------------------------------RELEASE 3------------------------------------------//

/*/  
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � Ctbr280R3� Autor � Claudio Donizete      � Data � 20.12.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Rela�ao de Movimentos Acumulados p/ CC Extra               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Ctbr280R3()                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CtbR280R3()
Local Wnrel
LOCAL cString:="CT1"
LOCAL cDesc1:= OemToAnsi(STR0001)                                             //"Este programa ir� imprimir a rela��o de Movimentos "
LOCAL cDesc2:= OemToAnsi(STR0002)+RetTitle("CT3_CUSTO",15)+OemToAnsi(STR0010)  //"Acumulados por "###" Extra Cont�bil das con-"
LOCAL cDesc3:= OemToAnsi(STR0003)  //"tas determinadas pelo usu�rio."
LOCAL tamanho:="G"
Local titulo := OemToAnsi(STR0006)  //"Relacao de Movimentos Acumulados para CC Extra - Exercicio "
Local aSetOfBook
Local aPergs

PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="NHCON016"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="CTR280"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("CTR280",.F.)

//������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                       �
//� mv_par01            // Data inicial                        �
//� mv_par02            // Data Final                          �
//� mv_par03            // do Centro do Custo                  �
//� mv_par04            // at� o Centro de Custo               �
//� mv_par05            // da Conta                            �
//� mv_par06            // at� a Conta                         �
//� mv_par07            // moeda                               �
//� mv_par08            // Pagina inicial                      �
//� mv_par09   			// Saldos? Reais / Orcados/Gerenciais  �
//� mv_par10            // Set of books                        �
//� mv_par11			// Saldos Zerados?			     	   �
//� mv_par12			// Imprime at� o Segmento?			   �
//� mv_par13			// Filtra Segmento?					   �
//� mv_par14			// Conteudo Inicial Segmento?		   �
//� mv_par15			// Conteudo Final Segmento?		       �
//� mv_par16			// Conteudo Contido em				   �
//� mv_par17 			// Codigo da Conta (Reduzido/Normal)   �
//� mv_par18			// Codigo do CC (Reduzido/Normal)      �
//� mv_par19			// Comparar? (Movimento/Acumulado)     �
//��������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="NHCON016"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif
//��������������������������������������������������������������Ŀ
//� Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano�
//� Gerencial -> montagem especifica para impressao)				  �
//����������������������������������������������������������������
If !ct040Valid(mv_par10)
	Set Filter To
	Return
EndIf
aSetOfBook := CTBSetOf(mv_par10)

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| Ct280Imp(@lEnd,wnRel,cString,Tamanho,Titulo,aSetOfBook)})

Return 

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun�ao    � Ct280Imp � Autor � Claudio Donizete      � Data � 20/12/00 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Impressao Relacao Movimento Mensal                         ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   � Ct280Imp(lEnd,wnRel,cString)                               ���
��������������������������������������������������������������������������Ĵ��
��� Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGACTB                                                    ���
��������������������������������������������������������������������������Ĵ��
���Parametros � lEnd    - Acao do Codeblock                                ���
���           � wnRel   - T�tulo do relat�rio                              ���
���           � cString - Mensagem                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function Ct280Imp(lEnd,WnRel,cString,Tamanho,Titulo, aSetOfBook)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL Cbcont
LOCAL limite := 220
Local lImpCC := .T., lImpConta := .T.
Local nDecimais := 2
Local cabec1 := "Codigo C.Custo  Descricao" + SPACE(44)//OemToAnsi(STR0014)
Local cabec2 := "Codigo da Conta   C.Custo   Descricao"//OemToAnsi(STR0015)

Local cCtt_Custo
Local aCtbMoeda := {}
Local aPeriodos
Local aSaldos
Local cMascConta
Local cMascCus
Local cSepConta := ""
Local cSepCus   := ""
Local cPicture
Local nX
Local aTotalCC
Local nCol
Local nTotais
Local cCodRes
Local cCodResCC
Local nDigitAte := 0
Local lFirst	:= .T.
Local cMensagem	:= ""
Local aMeses	:= {}
Local nCont		:= 1
Local nMeses	:= 0
Local nPos		:= 0
Local lComSaldo	:= .F.

#IFDEF TOP
Local lAs400	:= Upper(TcSrvType()) == "AS/400"
#ENDIF

nDecimais 	:= DecimalCTB(aSetOfBook,mv_par07)

If Empty(aSetOfBook[2])
	cMascConta := GetMv("MV_MASCARA")
	cMascCus	  := GetMv("MV_MASCCUS")
Else
	cMascConta := RetMasCtb(aSetOfBook[2],@cSepConta)
	cMascCus   := RetMasCtb(aSetofBook[6],@cSepCus)
EndIf
cPicture 	:= aSetOfBook[4]

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := MV_PAR08



aTotais := {0,0,0,0,0,0,0,0,0,0,0,0} 



//	Se nenhuma moeda foi escolhida, sai do programa
aCtbMoeda  	:= CtbMoeda(mv_par07)
If Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	Set Filter To
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Localiza centro de custo inicial                             �
//����������������������������������������������������������������
dbSelectArea("CTT")
dbSetOrder(1)
dbSeek( xFilial("CTT")+mv_par03,.T. )
SetRegua(Reccount())

// Localiza o periodo contabil para os calendarios da moeda 
aPeriodos := ctbPeriodos(mv_par07, mv_par01, mv_par02, .T., .F.)
If Empty(aPeriodos[1][1])
	cMensagem	:= STR0017
	cMensagem	+= STR0018
    MsgInfo(cMensagem)
    Return
EndIf

For nCont := 1 to len(aPeriodos)       
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02 
		AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})	
		nMeses += 1           					
	Else
		AADD(aMeses,{"  ",ctod("  /  /  "),ctod("  /  /  ")})
	EndIf
Next     

aTotalCC  := Array(Len(aPeriodos))
Titulo += " " + aPeriodos[1][3] // Adiciona o exercicio ao titulo

Titulo += " ("+ DTOC(mv_par01)+" - "+DTOC(mv_par02) +") "
If mv_par19 == 2
	Titulo += " - "+STR0019
Endif

For nX := 1 To Len(aPeriodos)
/*
	If nX >= 9
		Cabec2 += Padl(STR0022 + Dtoc(aPeriodos[nX][2]),17) + "  " //"Ate "
	Else	
		Cabec1 += Padl(STR0022 + Dtoc(aPeriodos[nX][2]),17) + "  " //"Ate "
	Endif	
*/    
	Cabec1 += Substr(MesExtenso(aPeriodos[nX][2]),1,3) + "/" + Substr(DtoS(aPeriodos[nX][2]),1,4) + "     " //incluido por joaofr
	
Next

// Verifica Se existe filtragem Ate o Segmento
If !Empty(mv_par12)
	nDigitAte := CtbRelDig(mv_par12,cMascCus) 	
EndIf		

If !Empty(mv_par13)			//// FILTRA O SEGMENTO N�
	If Empty(mv_par10)		//// VALIDA SE O C�DIGO DE CONFIGURA��O DE LIVROS EST� CONFIGURADO
		help("",1,"CTN_CODIGO")
		Return
	Else
		If !Empty(aSetOfBook[5])
			MsgInfo(STR0023+CHR(10)+STR0024,STR0025) //"O plano gerencial ainda n�o est� dispon�vel para este relat�rio."###"Altere a configura��o de livros..."###"Config. de Livros..."
			Return
		Endif
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+aSetOfBook[7])
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == aSetOfBook[7]
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(mv_par13),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		help("",1,"CTM_CODIGO")
		Return
	EndIf
EndIf 

cAliasCT1 := "CT1"
cAliasCTT := "CTT"

#IFDEF TOP
	If !lAs400
		MsAguarde({|| U_CTR280Qry(aMeses,mv_par07,mv_par09,mv_par05,mv_par06,mv_par03,mv_par04,aSetOfBook,mv_par11 == 1,cString,aReturn[7],.F./*lImpAntLP*/,/*dDataLP*/) }, STR0006 )
		cAliasCT1 := "TRBTMP"
		cAliasCTT := "TRBTMP"
	Else
		// Processa o arquivo de centro de custos, dentro dos parametros do usuario
		dbSelectArea(cAliasCTT)
		dbSetOrder(1)
	Endif
#ELSE
	// Processa o arquivo de centro de custos, dentro dos parametros do usuario
	dbSelectArea(cAliasCTT)
	dbSetOrder(1)
#ENDIF                    
While (cAliasCTT)->(!Eof()) .And. (cAliasCTT)->CTT_FILIAL==xFilial("CTT") .And. (cAliasCTT)->CTT_CUSTO <= mv_par04
	
	IncRegua()	
	
	// Guarda o centro de custo para ser utilizado na quebra	
	cCtt_Custo 	:= (cAliasCTT)->CTT_CUSTO
	cCodResCC	:= (cAliasCTT)->CTT_RES
	lImpCC     	:= .T.
	aFill(aTotalCC,0) 			// Zera o totalizador por periodo
	
	******************** "FILTRAGEM PARA IMPRESSAO" *************************
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(mv_par12)
		If Len(Alltrim((cAliasCTT)->CTT_CUSTO)) > nDigitAte
			(cAliasCTT)->(dbSkip())
			Loop
		Endif
	EndIf
	
	//Caso faca filtragem por segmento de item,verifico se esta dentro 
	//da solicitacao feita pelo usuario. 
	If !Empty(mv_par13)
		If Empty(mv_par14) .And. Empty(mv_par15) .And. !Empty(mv_par16)
			If  !(Substr((cAliasCTT)->CTT_CUSTO,nPos,nDigitos) $ (mv_par16) ) 
				(cAliasCTT)->(dbSkip())
				Loop
			EndIf	
		Else
			If Substr((cAliasCTT)->CTT_CUSTO,nPos,nDigitos) < Alltrim(mv_par14) .Or. Substr((cAliasCTT)->CTT_CUSTO,nPos,nDigitos) > Alltrim(mv_par15)
				(cAliasCTT)->(dbSkip())
				Loop
			EndIf	
		Endif
	EndIf	                                        
	
	************************* ROTINA DE IMPRESSAO *************************
								
	#IFNDEF TOP
		If (cAliasCTT)->CTT_CLASSE == "1"		// Sintetica
			(cAliasCTT)->(DbSkip())
			Loop
		Endif
	
		// Localiza os saldos do centro de custo
		dbSelectArea(cAliasCT1)
		dbSetOrder(1)			 	// Filial+Custo+Conta+Moeda
		dbSeek(xFilial("CT1")+mv_par05, .T.)
	
	
	#ELSE
		If lAs400
			If (cAliasCTT)->CTT_CLASSE == "1"		// Sintetica
				(cAliasCTT)->(DbSkip())
				Loop
			Endif

			// Localiza os saldos do centro de custo
			dbSelectArea(cAliasCT1)
			dbSetOrder(1)			 	// Filial+Custo+Conta+Moeda
			dbSeek(xFilial("CT1")+mv_par05, .T.)
		Endif
	#ENDIF
		
	// Obtem os saldos do centro de custo
	While !Eof() .And. (cAliasCT1)->CT1_FILIAL == xFilial("CT1") .And. (cAliasCTT)->CTT_CUSTO == cCtt_Custo .And. (cAliasCT1)->CT1_CONTA <= mv_par06
    		              
		lImpConta 	:= .T.
		cCt3_Conta  := (cAliasCT1)->CT1_CONTA //CT3->CT3_CONTA
		nCol 	  	:= 1 
		aSaldos 	:= {}
		nTotais 	:= 0
		
		#IFDEF TOP    
			If !lAs400
				For nX := 1 To Len(aPeriodos)
					If aPeriodos[nX][1] >= mv_par01 .And. aPeriodos[nX][2] <= mv_par02 
						If mv_par19 == 2 
							aAdd(aSaldos,{ &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))+nTotais,0,0,0,0,0} )/// ACUMULA MOVIMENTO
						Else 
							aAdd(aSaldos,{ &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))        ,0,0,0,0,0} )/// POR PERIODO (SEM ACUMULAR)
						EndIf
						nTotais += &("(cAliasCT1)->COLUNA"+alltrim(str(nX)))
					Else
						Aadd(	aSaldos, {0,0,0,0,0,0})
					Endif
				Next
			Else
		#ENDIF
 
			If (cAliasCT1)->CT1_CLASSE = "1"		// Sintetica
				(cAliasCT1)->(DbSkip())
				Loop
			Endif
	
			For nX := 1 To Len(aPeriodos)
				//	Obtem o saldo acumulado ate o ultimo dia do periodo
				// da moeda escolhida.
				If aPeriodos[nX][2] >= mv_par01 .And. aPeriodos[nX][2] <= mv_par02
					If mv_par19 == 2 // ACUMULA MOVIMENTO
						Aadd(aSaldos,SaldoCt3((cAliasCT1)->CT1_CONTA,cCtt_Custo,aPeriodos[nX][2],mv_par07,MV_PAR09))			
					Else  // POR PERIODO (SEM ACUMULAR)
						Aadd(aSaldos,SaldoCt3((cAliasCT1)->CT1_CONTA,cCtt_Custo,aPeriodos[nX][2],mv_par07,MV_PAR09))			
						aSaldos[nX][1] -= nTotais
					EndIf
					nTotais += aSaldos[nX][1]
				Else
					Aadd(	aSaldos, {0,0,0,0,0,0})						
				EndIf
			Next
  		#IFDEF TOP    
  			Endif
  		#ENDIF

		lComSaldo	:= .F.  		
  		For nX := 1 To Len(aPeriodos)
  		    If aSaldos[nX][1]  <> 0 
  		    	lComSaldo	:= .T.
				Exit  		    	
  		    EndIf  		
  		Next

		If mv_par11 == 1  .And. !lComSaldo
		
	  		#IFDEF TOP	
				If !lAs400	  		
					If CtbExDtFim("CTT")  
						//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
						//relatorio for maior, nao ira imprimir a entidade. 
						If !Empty((cAliasCTT)->CTTDTEXSF) .And. (dtos(mv_par01) > DTOS((cAliasCTT)->CTTDTEXSF))  
							dbSelectArea(cAliasCT1)
							dbSkip()
							Loop													
						EndIf
					EndIf				
						
					If CtbExDtFim("CT1")  
						//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
						//relatorio for maior, nao ira imprimir a entidade. 
						If !Empty((cAliasCT1)->CT1DTEXSF) .And. (dtos(mv_par01) > DTOS((cAliasCT1)->CT1DTEXSF))  
							dbSelectArea(cAliasCT1)
							dbSkip()
							Loop													
						EndIf
					EndIf	  						
						
				Else
			#ENDIF	
				If CtbExDtFim("CTT")  			
					If !CtbVlDtFim("CTT",mv_par01) 
						dbSelectArea(cAliasCT1)
						dbSkip()
						Loop																	
					EndIf				
				EndIf
				
				If CtbExDtFim("CT1")
					If !CtbVlDtFim("CT1",mv_par01) 
						dbSelectArea(cAliasCT1)
						dbSkip()
						Loop																						
					EndIf				
				EndIf			
	  		#IFDEF TOP			  	
	  			EndIf
			#ENDIF		  		
		EndIf
			
		// Se imprime saldos zerados ou 
		// se nao imprime saldos zerados e houver valor,
		// imprime os saldos
		If mv_par11 == 1 .OR. (mv_par11 == 2 .AND. nTotais != 0)
			For nX := 1 To Len(aSaldos)
				IF lEnd
					@Prow()+1,0 PSAY OemToAnsi(STR0009)  //"***** CANCELADO PELO OPERADOR *****"
					Exit
				EndIf
				// quebra de linha a cada 8 periodos
/*
				If nX % 9 == 0
					Li++
					nCol := 1
				EndIf
*/				
  	
				// Inicio da impressao
				If li+If(lImpcc .and. lImpConta,3,If(lImpCC,2,If(lImpConta,1,0))) > 57
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					li--
					If lImpcc
						Li--
					Endif	
					
/*
					If nX % 9 == 0 .And. ( !lImpCC .And. !lImpConta )
						li++
					EndIf   
*/					
					lFirst	:= .F.
				EndIf
		
				// Imprime o Centro de Custo
				If lImpCC
					li += 2
					If mv_par18 == 1 //Imprime Cod. CC Normal
						EntidadeCtb(cCtt_Custo,li,00,15,.f.,cMascCus,cSepCus)
					Else							
						// Imprime codigo reduzido
						EntidadeCtb(cCodResCC,li,00,15,.f.,cMascCus,cSepCus)
					Endif
					@ li, PCOL() + 1 PSAY CtbDescMoeda("(cAliasCTT)->CTT_DESC"+MV_PAR07)
					lImpCC := .F.
					li++
				Endif
				// Imprime a Conta
				If lImpConta
					cCodRes := (cAliasCT1)->CT1_RES
					If mv_par17 ==1 //Imprime Cod. Conta Normal
						EntidadeCTB(&("(cAliasCT1)->CT1_CONTA"),++li,00,18,.F.,cMascConta,cSepConta)
						EntidadeCtb(cCtt_Custo,li,18,09,.f.,cMascCus,cSepCus)
					Else 
						EntidadeCTB(cCodRes,++li,00,20,.F.,cMascConta,cSepConta)
						// Imprime codigo reduzido
						EntidadeCtb(cCodResCC,li,18,09,.f.,cMascCus,cSepCus)
						
					Endif

					//DESC CTA CONTABIL
					@ li, PCOL() + 1 PSAY Substr(CtbDescMoeda("(cAliasCT1)->CT1_DESC" + MV_PAR07),1,34)
					lImpConta := .F.
				EndIf
				// Imprime o valor
                
				@ li, 52+(nCol++*13) PSAY aSaldos[nX][1] PICTURE "@E 9,999,999.99"//cPicture
				
				//ValorCTB(aSaldos[nX][1],li,48+(nCol++*13),14,nDecimais,.T.,cPicture)
				aTotalCC[nX] += aSaldos[nX][1]
			Next
		Endif	
	
		// Vai para a proxima conta
		dbSelectArea(cAliasCT1)
		(cAliasCT1)->(DbSkip())		
	EndDo

	If !lFirst
		// Quebrou o Centro de Custo
		If !lImpCC
			li+=2
			@ li,00 PSAY Replicate("-",Limite)
			li++
			@ li,000 PSay OemToAnsi(STR0012)+RetTitle("CTT_CUSTO",7)+": "
			If mv_par18 == 1 //Imprime Cod. CC Normal 	
				EntidadeCtb(cCtt_Custo,li,PCOL(),10,.F.,cMascCus,cSepCus)
			Else
				EntidadeCtb(cCodResCC,li,PCOL(),10,.F.,cMascCus,cSepCus)
			Endif
  	
			// Imprime o totalizador por periodo
			nCol := 1

		    For nX := 1 to Len(aTotalCC)	
			    @ li, 52+(nCol++*13) PSAY aTotalCC[nX] PICTURE "@E 9,999,999.99" //cPicture
			    
			    aTotais[nX] += aTotalCC[nX]
			    
			Next

//			Aeval( aTotalCC, { |e,nX| /*If(nX%9==0,(nCol := 1, Li++),NIL),*/;
//										  ValorCTB(e,li,48+(nCol++*13),14,nDecimais,.T.,cPicture) } )
			li++
			@ li,00 PSAY Replicate("-",Limite)
		EndIf
	EndIf
	dbSelectArea(cAliasCTT)
	#IFNDEF TOP
		dbSetOrder(1)
		(cAliasCTT)->(dbSkip())
	#ELSE
	 	If lAs400
 			dbSetOrder(1)
			(cAliasCTT)->(dbSkip())
	 	Endif
	#ENDIF       
Enddo

li++
// Imprime o totalizador geral 
@ li,00 PSAY "TOTAL GERAL:"

nCol := 1

For nX := 1 to Len(aTotalCC)	
	If(nX==7)
		nCol := 1
		li++
	EndIf

    @ li, 35+(nCol++*26) PSAY aTotais[nX] PICTURE "@E 9,999,999,999.99" //cPicture
Next
li++
@ li,00 PSAY Replicate("-",Limite)


#IFNDEF TOP
	dbsetOrder(1)
	Set Filter To
#ELSE
	If lAs400
		dbsetOrder(1)
		Set Filter To
	Endif
#ENDIF

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBR280   �Autor  �Marcos S. Lobo      � Data �  02/05/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query para o relatorio Mov.Acum. CCxContaxMeses     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                 
User Function CTR280Qry(aPeriodos,cMoeda,cTpSaldo,cContaIni,cContaFim,cCustoIni,cCustoFim,aSetOfBook,lVlrZerado,cString,cFILUSU,lImpAntLP,dDataLP)

Local aSaveArea	:= GetArea()
Local cQuery	:= ""
Local nColunas	:= 0
Local aTamVlr	:= TAMSX3("CT3_DEBITO")
Local nStr		:= 1
Local l1St 		:= .T.
Local lAbriu	:= .F.

DEFAULT lVlrZerado	:= .F.
DEFAULT lImpAntLP   := .F.
DEFAULT cFilUSU		:= ""
DEFAULT cString		:= "CTT"
DEFAULT aSetOfBook  := {""}

MsProcTxt(STR0026) //"Montando consulta..."

cQuery := " SELECT CT1_FILIAL CT1_FILIAL, CT1_CONTA CT1_CONTA,CT1_NORMAL CT1_NORMAL, CT1_RES CT1_RES, CT1_DESC"+cMoeda+" CT1_DESC"+cMoeda+", "

If CtbExDtFim("CT1")  
	cQuery += "CT1_DTEXSF CT1DTEXSF, "			
EndIf
cQuery += " 	CT1_CLASSE CT1_CLASSE, CT1_GRUPO CT1_GRUPO, CT1_CTASUP CT1_CTASUP, "
cQuery += " 	CTT_FILIAL CTT_FILIAL, CTT_CUSTO CTT_CUSTO, CTT_DESC"+cMoeda+" CTT_DESC"+cMoeda+", CTT_CLASSE CTT_CLASSE, CTT_RES CTT_RES, CTT_CCSUP CTT_CCSUP, "

If CtbExDtFim("CTT")  
	cQuery += "CTT_DTEXSF CTTDTEXSF, "			
EndIf

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USU�RIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USU�RIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USU�RIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
      
For nColunas := 1 to Len(aPeriodos)
	If !Empty(aPeriodos[nColunas][1])	
		cQuery += " 	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
		cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
		cQuery += " 			WHERE CT3.CT3_FILIAL = '"+xFilial("CT3")+"' "
		cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
		cQuery += " 			AND CT3_TPSALD = '"+cTpSaldo+"' "
		cQuery += " 			AND CT3_CONTA	= ARQ.CT1_CONTA "
		cQuery += " 			AND CT3_CUSTO	= ARQ2.CTT_CUSTO "
		If l1St .And. mv_par19 == 2	//	Se for o primeiro periodo e Saldo Acumulado
			cQuery += " 			AND CT3_DATA <= '"+DTOS(aPeriodos[nColunas][3])+"' "
			l1St := .F.
		Else
			cQuery += " 			AND CT3_DATA BETWEEN '"+DTOS(aPeriodos[nColunas][2])+"' AND '"+DTOS(aPeriodos[nColunas][3])+"' "
		Endif
		If lImpAntLP .and. dDataLP >= aPeriodos[nColunas][2]
			cQuery += " AND CT3_LP <> 'Z' "
		Endif                          
		cQuery += " 			AND CT3.D_E_L_E_T_ <> '*') COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "
	Else
		cQuery += " 0 COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "
	Endif
	
	If nColunas <> Len(aPeriodos)
		cQuery += ", "
	EndIf		
Next	
	
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "
If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURA��O DE LIVROS     
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif	
cQuery += " 	AND ARQ.D_E_L_E_T_ <> '*' "

cQuery += " 	AND ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCustoIni+"' AND '"+cCustoFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "
If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURA��O DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif	
cQuery += " 	AND ARQ2.D_E_L_E_T_ <> '*' "

l1St := .T.
 
If !lVlrZerado
	For nColunas := 1 to Len(aPeriodos)
		If !Empty(aPeriodos[nColunas][1])
			If ! lAbriu
				cQuery += " 	AND ( "
				lAbriu := .T.
			EndIf
			If !l1St
				cQuery += " 	OR "
			EndIf          
			cQuery += "	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
			cQuery += " FROM "+RetSqlName("CT3")+" CT3 "
			cQuery += " WHERE CT3.CT3_FILIAL	= '"+xFilial("CT3")+"' "
			cQuery += " AND CT3_MOEDA = '"+cMoeda+"' "
			cQuery += " AND CT3_TPSALD = '"+cTpSaldo+"' "
			cQuery += " AND CT3_CONTA	= ARQ.CT1_CONTA "
			cQuery += " AND CT3_CUSTO	= ARQ2.CTT_CUSTO "
			If l1St .And. mv_par19 == 2	//	Se for o primeiro periodo e Saldo Acumulado
				cQuery += " AND CT3_DATA <= '"+DTOS(aPeriodos[nColunas][3])+"' "
			Else
				cQuery += " AND CT3_DATA BETWEEN '"+DTOS(aPeriodos[nColunas][2])+"' AND '"+DTOS(aPeriodos[nColunas][3])+"' "
			Endif
			l1St := .F.
			If lImpAntLP .and. dDataLP >= aPeriodos[nColunas][2]
				cQuery += " AND CT3_LP <> 'Z' "
			Endif
			cQuery += " 	AND CT3.D_E_L_E_T_ <> '*') <> 0 "
		Endif        
		If lAbriu .And. nColunas == Len(aPeriodos)
			cQuery += " ) "
		EndIf	
	Next
Endif
cQuery += " ORDER BY CTT_CUSTO,CT1_CONTA "

cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()                                 
Endif	

MsProcTxt(STR0027) //"Executando consulta..."
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
For nColunas := 1 to Len(aPeriodos)
	TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
Next

If CtbExDtFim("CTT")  
	TCSetField("TRBTMP","CTTDTEXSF","D",8,0)	
EndIf

If CtbExDtFim("CT1")  
	TCSetField("TRBTMP","CT1DTEXSF","D",8,0)	
EndIf

RestArea(aSaveArea)

Return
