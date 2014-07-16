/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHFIN033  �Autor  �Marcos R. Roquitski � Data �  27/01/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "FINR150.CH"
#Include "PROTHEUS.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINR150	� Autor � Wagner Xavier   	     � Data � 02.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o dos Titulos a Pagar										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR150(void)															  ���
�������������������������������������������������������������������������Ĵ��
���Par�metros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Gen�rico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Nhfin033()
//������������������Ŀ
//� Define Vari�veis �
//��������������������
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi��o dos titulos a pagar relativo a data base"
Local cDesc2 :=OemToAnsi(STR0002)  //"do sistema."
LOCAL cDesc3 :=""
LOCAL wnrel
LOCAL cString:="SE2"
LOCAL nRegEmp := SM0->(RecNo())
Local dOldDtBase := dDataBase

PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR150"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="FIN150"
PRIVATE nJuros  :=0
PRIVATE tamanho:="G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//��������������������������Ŀ
//� Definicao dos cabe�alhos �
//����������������������������
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Pagar"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor nominal   Valor corrigido |   Valor nominal  | dor   |   permanencia   Atraso               "

AjustaSX1()
//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//��������������������������������������
pergunte("FIN150",.F.)
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01	  // do Numero 			  �
//� mv_par02	  // at� o Numero 		  �
//� mv_par03	  // do Prefixo			  �
//� mv_par04	  // at� o Prefixo		  �
//� mv_par05	  // da Natureza  	     �
//� mv_par06	  // at� a Natureza		  �
//� mv_par07	  // do Vencimento		  �
//� mv_par08	  // at� o Vencimento	  �
//� mv_par09	  // do Banco			     �
//� mv_par10	  // at� o Banco		     �
//� mv_par11	  // do Fornecedor		  �
//� mv_par12	  // at� o Fornecedor	  �
//� mv_par13	  // Da Emiss�o			  �
//� mv_par14	  // Ate a Emiss�o		  �
//� mv_par15	  // qual Moeda			  �
//� mv_par16	  // Imprime Provis�rios  �
//� mv_par17	  // Reajuste pelo vencto �
//� mv_par18	  // Da data contabil	  �
//� mv_par19	  // Ate data contabil	  �
//� mv_par20	  // Imprime Rel anal/sint�
//� mv_par21	  // Considera  Data Base?�
//� mv_par22	  // Cons filiais abaixo ?�
//� mv_par23	  // Filial de            �
//� mv_par24	  // Filial ate           �
//� mv_par25	  // Loja de              �
//� mv_par26	  // Loja ate             �
//� mv_par27 	  // Considera Adiantam.? �
//� mv_par28	  // Imprime Nome 		  �
//� mv_par29	  // Outras Moedas 		  �
//� mv_par30     // Imprimir os Tipos    �
//� mv_par31     // Nao Imprimir Tipos	  �
//� mv_par32     // Consid. Fluxo Caixa  �
//����������������������������������������
//���������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT �
//�����������������������������������������

wnrel := "FINR150"            //Nome Default do relatorio em Disco
aOrd	:= {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010) ,;  //"Por Numero"###"Por Natureza"###"Por Vencimento"
	OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014) }  //"Por Banco"###"Fornecedor"###"Por Emissao"###"Por Cod.Fornec."
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa150Imp(@lEnd,wnRel,cString)},Titulo)

//���������������������������������������Ŀ
//� Restaura empresa / filial original    �
//�����������������������������������������
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1  // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA150Imp � Autor � Wagner Xavier 		  � Data � 02.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o dos Titulos a Pagar										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA150Imp(lEnd,wnRel,cString)										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd	  - A��o do Codeblock										  ���
���			 � wnRel   - T�tulo do relat�rio 									  ���
���			 � cString - Mensagem										 			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Gen�rico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA150Imp(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt

LOCAL limite := 220
LOCAL nOrdem :=0
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
LOCAL nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOCAL nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0,nFilJur:=0
LOCAL cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0,nSaldoNom:=0
LOCAL aCampos:={},aTam:={}
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra
LOCAL nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
LOCAL dDtContab
LOCAL	cIndexSe2
LOCAL	cChaveSe2
LOCAL	nIndexSE2
LOCAL cFilDe,cFilAte
Local aStru := SE2->(dbStruct()), ni
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase

//��������������������������������������������������������������Ŀ
//� Ponto de entrada para Filtrar 										  �
//��������������������������������������� Localiza��es Argentina��
If lFr150Flt
	cFr150Flt := EXECBLOCK("Fr150FLT",.f.,.f.)
Endif

//�����������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impress�o do Cabe�alho e Rodap� �
//�������������������������������������������������������������
cbtxt  := OemToAnsi(STR0015)  //"* indica titulo provisorio, P indica Saldo Parcial"
cbcont := 0
li 	 := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := LTrim(Str(mv_par15))
Titulo += OemToAnsi(STR0035)+GetMv("MV_MOEDA"+cMoeda)  //" em "

SE5->(DbsetOrder(7))

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par22 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par23
	cFilAte:= mv_par24
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1	//Considera Data Base
	dDataBase := mv_par33
Endif	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte

	dbSelectArea("SE2")
	cFilAnt := SM0->M0_CODFIL

	#IFDEF TOP
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE2")
		cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += "   AND D_E_L_E_T_ <> '*' "
	#ENDIF

	IF nOrdem == 1
		SE2->(dbSetOrder(1))
		#IFDEF TOP
			cOrder := SqlOrder(indexkey())
		#ELSE
			dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
		#ENDIF
		cCond1 := "E2_PREFIXO <= mv_par04"
		cCond2 := "E2_PREFIXO"
		titulo += OemToAnsi(STR0016)  //" - Por Numero"
		nQualIndice := 1
	Elseif nOrdem == 2
		SE2->(dbSetOrder(2))
		#IFDEF TOP
			cOrder := SqlOrder(indexkey())
		#ELSE
			dbSeek(xFilial("SE2")+mv_par05,.T.)
		#ENDIF
		cCond1 := "E2_NATUREZ <= mv_par06"
		cCond2 := "E2_NATUREZ"
		titulo += OemToAnsi(STR0017)  //" - Por Natureza"
		nQualIndice := 2
	Elseif nOrdem == 3
		SE2->(dbSetOrder(3))
		#IFDEF TOP
			cOrder := SqlOrder(indexkey())
		#ELSE
			dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
		#ENDIF
		cCond1 := "E2_VENCREA <= mv_par08"
		cCond2 := "E2_VENCREA"
		titulo += OemToAnsi(STR0018)  //" - Por Vencimento"
		nQualIndice := 3
	Elseif nOrdem == 4
		SE2->(dbSetOrder(4))
		#IFDEF TOP
			cOrder := SqlOrder(indexkey())
		#ELSE
			dbSeek(xFilial("SE2")+mv_par09,.T.)
		#ENDIF
		cCond1 := "E2_PORTADO <= mv_par10"
		cCond2 := "E2_PORTADO"
		titulo += OemToAnsi(STR0031)  //" - Por Banco"
		nQualIndice := 4
	Elseif nOrdem == 6
		SE2->(dbSetOrder(5))
		#IFDEF TOP
			cOrder := SqlOrder(indexkey())
		#ELSE
			dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
		#ENDIF
		cCond1 := "E2_EMISSAO <= mv_par14"
		cCond2 := "E2_EMISSAO"
		titulo += OemToAnsi(STR0019)  //" - Por Emissao"
		nQualIndice := 5
	Elseif nOrdem == 7
		SE2->(dbSetOrder(6))
		#IFDEF TOP
			cOrder := SqlOrder(indexkey())
		#ELSE
			dbSeek(xFilial("SE2")+mv_par11,.T.)
		#ENDIF			
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE"
		titulo += OemToAnsi(STR0020)  //" - Por Cod.Fornecedor"
		nQualIndice := 6
	Else
		cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			cOrder := SqlOrder(cChaveSe2)
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE+E2_LOJA"
		titulo += OemToAnsi(STR0022)  //" - Por Fornecedor"
		nQualIndice := IndexOrd()
	EndIF

	If mv_par20 == 1
		titulo += OemToAnsi(STR0023)  //" - Analitico"
	Else
		titulo += OemToAnsi(STR0024)  // " - Sintetico"
		cabec1 := OemToAnsi(STR0033)  // "                                                                                          |        Titulos vencidos         |    Titulos a vencer     |           Valor dos juros ou                       (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0034)  // "                                                                                          | Valor nominal   Valor corrigido |      Valor nominal      |            com. permanencia                                         "
	EndIf

	dbSelectArea("SE2")
	cFilterUser:=aReturn[7]

	Set Softseek Off

	#IFDEF TOP
		cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
		cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
		cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
		cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
		cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
		cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
		cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
		cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"
		cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
		If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
			cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";") 
		ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
			cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
		EndIf
		If mv_par32 == 1
			cQuery += " AND E2_FLUXO <> 'N'"
		Endif
		cQuery += " ORDER BY "+ cOrder
		cQuery := ChangeQuery(cQuery)
		dbSelectArea("SE2")
		dbCloseArea()
		dbSelectArea("SA2")

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)

		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ENDIF

	SetRegua(nTotsRec)
	
	If MV_MULNATP .And. nOrdem == 2
		Finr155(cFr150Flt, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ )
		#IFDEF TOP
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSetOrder(1)
		#ENDIF
		If Empty(xFilial("SE2"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif

	While &cCond1 .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")

		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
			Exit
		End

		IncRegua()

		dbSelectArea("SE2")

		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

		//����������������������������������������Ŀ
		//� Carrega data do registro para permitir �
		//� posterior analise de quebra por mes.	 �
		//������������������������������������������
		dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

		cCarAnt := &cCond2

		While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")

			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
				Exit
			End

			IncRegua()

			dbSelectArea("SE2")

			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario                                  �
			//����������������������������������������������������������������
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario no ponto de entrada.             �
			//����������������������������������������������������������������
			If lFr150flt
				If &cFr150flt
					DbSkip()
					Loop
				Endif
			Endif
			//������������������������������������������������������Ŀ
			//� Verifica se trata-se de abatimento ou provisorio, ou �
			//� Somente titulos emitidos ate a data base				   �
			//��������������������������������������������������������
			IF SE2->E2_TIPO $ MVABATIM .Or. SE2 -> E2_EMISSAO > dDataBase
				dbSkip()
				Loop
			EndIF
			//������������������������������������������������������Ŀ
			//� Verifica se ser� impresso titulos provis�rios		   �
			//��������������������������������������������������������
			IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
				dbSkip()
				Loop
			EndIF

			//������������������������������������������������������Ŀ
			//� Verifica se ser� impresso titulos de Adiantamento	 �
			//��������������������������������������������������������
			IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
				dbSkip()
				Loop
			EndIF

			// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
			// compatibilizando com a vers�o 2.04 que n�o gerava para titulos
			// de ISS e FunRural

			dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)

			//����������������������������������������Ŀ
			//� Verifica se esta dentro dos parametros �
			//������������������������������������������
			IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
					E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
					E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
					E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
					E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
					E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
					E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
					E2_EMISSAO > dDataBase .OR. dDtContab  < mv_par18 .OR. ;
					E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
					dDtContab  > mv_par19  .Or. !&(fr150IndR())

				dbSkip()
				Loop
			Endif

			//��������������������������������������������������������������Ŀ
			//� Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou �
			//� n�o no relat�rio quando se considera database (mv_par21 = 1) �
			//� ou caso n�o se considere a database, se o titulo foi totalmen�
			//� te baixado.																  �
			//����������������������������������������������������������������
			dbSelectArea("SE2")
			IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,;
					(SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase))
				dbSkip()
				Loop
			EndIF

			//����������������������������������������Ŀ
			//� Verifica se deve imprimir outras moedas�
			//������������������������������������������
			If mv_par29 == 2 // nao imprime
				if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif	
			Endif


			dbSelectArea("SA2")
			MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			dbSelectArea("SE2")

			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF

			If mv_par20 == 1
				@li,	0 PSAY SE2->E2_FORNECE+"-"+SubStr( SE2->E2_NOMFOR, 1, 20 )
				li := IIf (aTamFor[1] > 6,li+1,li)
				@li, 28 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
				@li, 47 PSAY SE2->E2_TIPO
				@li, 51 PSAY SE2->E2_NATUREZ
				@li, 62 PSAY SE2->E2_EMISSAO
				@Li, 73 PSAY SE2->E2_VENCTO
				@li, 84 PSAY SE2->E2_VENCREA
				@li, 96 PSAY xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1) Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
			EndIf
			#IFNDEF TOP
				dbSetOrder( nQualIndice )
			#ENDIF

			dDataReaj := IIF(SE2->E2_VENCREA < dDataBase ,IIF(mv_par17=1,dDataBase,SE2->E2_VENCREA),dDataBase)

			If dDataBase > SE2->E2_VENCREA 		//vencidos
				If mv_par21 == 1
					nSaldo := xSaldoTit() //SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA)
				Else
					nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1)
				Endif

				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
				   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
				EndIf

				If mv_par20 == 1
					@ li, 112 PSAY nSaldo Picture PesqPict("SE2","E2_SALDO",14,MV_PAR15)
				EndIf
				nJuros:=0
				dBaixa:=dDataBase
				fa080Juros(mv_par15)
				dbSelectArea("SE2")
				If mv_par20 == 1
					@li,129 PSAY nSaldo+nJuros Picture PesqPict("SE2","E2_SALDO",14,MV_PAR15)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nTit1 -= nSaldo
					nTit2 -= nSaldo+nJuros
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nMesTit1 -= nSaldo
					nMesTit2 -= nSaldo+nJuros
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nTit1 += nSaldo
					nTit2 += nSaldo+nJuros
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nMesTit1 += nSaldo
					nMesTit2 += nSaldo+nJuros
				Endif
				nTotJur += (nJuros)
				nMesTitJ += (nJuros)
			Else				  //a vencer
				If mv_par21 == 1
					nSaldo:= xSaldoTit() // SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA)
				Else
					nSaldo:=xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1)
				Endif
				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
						!( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
				EndIf
				If mv_par20 == 1
					@li,147 PSAY nSaldo Picture PesqPict("SE2","E2_SALDO",14,MV_PAR15)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nTit3 -= nSaldo
					nTit4 -= nSaldo
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nMesTit3 -= nSaldo
					nMesTit4 -= nSaldo
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nTit3 += nSaldo
					nTit4 += nSaldo
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1)
					nMesTit3 += nSaldo
					nMesTit4 += nSaldo
				Endif
			Endif
			If mv_par20 == 1
				@Li,165 PSAY SE2->E2_PORTADO
			EndIf
			If nJuros > 0
				If mv_par20 == 1
					@Li,173 PSAY nJuros Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
				EndIf
				nJuros := 0
			Endif

			IF dDataBase > E2_VENCREA
				nAtraso:=dDataBase-E2_VENCTO
				IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso:=0
					EndIF
				EndIF
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par20 == 1
						@li,189 PSAY nAtraso Picture "9999"
					EndIf
				EndIF
			EndIF
			If mv_par20 == 1
				@li,194 PSAY SUBSTR(SE2->E2_HIST,1,24)+ ;
					IIF(E2_TIPO $ MVPROVIS,"*"," ")+ ;
					Iif(nSaldo == xMoeda(E2_VALOR,E2_MOEDA,mv_par15,dDataReaj,ndecs+1)," ","P")
			EndIf

			//����������������������������������������Ŀ
			//� Carrega data do registro para permitir �
			//� posterior analise de quebra por mes.	 �
			//������������������������������������������
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

			dbSkip()
			nTotTit ++
			nMesTTit ++
			nFiltit++
			nTit5 ++
			If mv_par20 == 1
				li ++
			EndIf

		EndDO

		IF nTit5 > 0 .and. nOrdem != 1
			SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur)
			If mv_par20 == 1
				li++
			EndIf
		EndIF

		//����������������������������������������Ŀ
		//� Verifica quebra por mes					 �
		//������������������������������������������
		lQuebra := .F.
		If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif

		dbSelectArea("SE2")

		nTot0 += nTit0
		nTot1 += nTit1
		nTot2 += nTit2
		nTot3 += nTit3
		nTot4 += nTit4
		nTotJ += nTotJur

		nFil0 += nTit0
		nFil1 += nTit1
		nFil2 += nTit2
		nFil3 += nTit3
		nFil4 += nTit4
		nFilJ += nTotJur
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
	Enddo					

	dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par22 == 1 .and. SM0->(Reccount()) > 1
		ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj)
	Endif
	Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
	If Empty(xFilial("SE2"))
		Exit
	Endif

	#IFDEF TOP
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	#ENDIF

	dbSelectArea("SM0")
	dbSkip()
EndDO

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

SE5->(DbsetOrder(1))

IF li != 80
	If mv_par20 == 1
		li +=2
	Endif
	ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ)
	cbcont := 1
	roda(cbcont,cbtxt,"G")
EndIF
Set Device To Screen

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil(NIL)
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE2")
	dbCloseArea()
	ChKFile("SE2")
	dbSetOrder(1)
#ENDIF	

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SubTot150 � Autor � Wagner Xavier 		  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR SUBTOTAL DO RELATORIO 									  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � SubTot150() 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur)
If mv_par20 == 1
	li++
EndIf

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

if nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 6
	@li,000 PSAY OemToAnsi(STR0026)  //"S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	@li,000 PSAY cCarAnt +" "+SED->ED_DESCRIC
Elseif nOrdem == 5
	@Li,000 PSAY IIF(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	@li,000 PSAY SA2->A2_COD+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif
if mv_par20 == 1
	@li,096 PSAY nTit0		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
endif
@li,112 PSAY nTit1		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,129 PSAY nTit2		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,147 PSAY nTit3		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
If nTotJur > 0
	@li,173 PSAY nTotJur 	 Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
Endif
@li,204 PSAY nTit2+nTit3 Picture PesqPict("SE2","E2_VALOR",16,MV_PAR15)
li++
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ImpTot150 � Autor � Wagner Xavier 		  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR TOTAL DO RELATORIO 										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpTot150() 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0027)  //"T O T A L   G E R A L ----> "
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"
if mv_par20 == 1
	@li,096 PSAY nTot0		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
endif
@li,112 PSAY nTot1		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,129 PSAY nTot2		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,147 PSAY nTot3		 Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,173 PSAY nTotJ		 Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
@li,204 PSAY nTot2+nTot3 Picture PesqPict("SE2","E2_VALOR",16,MV_PAR15)
li+=2
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ImpMes150 � Autor � Vinicius Barreira	  � Data � 12.12.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpMes150() 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function ImpMes150(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0030)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"
if mv_par20 == 1
	@li,096 PSAY nMesTot0   Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
endif
@li,112 PSAY nMesTot1	Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,129 PSAY nMesTot2	Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,147 PSAY nMesTot3	Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,173 PSAY nMesTotJ	Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
@li,204 PSAY nMesTot2+nMesTot3 Picture PesqPict("SE2","E2_VALOR",16,MV_PAR15)
li+=2
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � ImpFil150� Autor � Paulo Boschetti 	     � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir total do relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpFil150()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico				   									 			  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0032)+" "+cFilAnt  //"T O T A L   F I L I A L ----> " 
if mv_par20 == 1
	@li,096 PSAY nFil0        Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
endif
@li,112 PSAY nFil1        Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,129 PSAY nFil2        Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,147 PSAY nFil3        Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
@li,173 PSAY nFilJ		  Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
@li,204 PSAY nFil2+nFil3 Picture PesqPict("SE2","E2_VALOR",16,MV_PAR15)
li+=2
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fr150Indr � Autor � Wagner           	  � Data � 12.12.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta Indregua para impressao do relat�rio						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fr150IndR()
Local cString
//������������������������������������������������������������Ŀ
//� ATENCAO !!!!                                               �
//� N�o adiconar mais nada a chave do filtro pois a mesma est� �
//� com 254 caracteres.                                        �
//��������������������������������������������������������������
cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += '(E2_MULTNAT="1" .OR. (E2_NATUREZ>="'+mv_par05+'".and.E2_NATUREZ<="'+mv_par06+'")).And.'
cString += 'E2_FORNECE>="'+mv_par11+'".and.E2_FORNECE<="'+mv_par12+'".And.'
cString += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".and.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'".And.'
cString += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E2_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
	cString += '.And.E2_TIPO$"'+mv_par30+'"'
ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
	cString += '.And.!(E2_TIPO$'+'"'+mv_par31+'")'
EndIf
IF mv_par32 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E2_FLUXO!="N")'	
Endif
		
Return cString
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1� Autor � Lucas                 � Data � 11/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Remito .prx                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()
Local _sAlias	:= Alias()
Local cPerg		:= "FIN150"
Local cOrdem 
Local aRegs		:= {}

AAdd(aRegs,{"Imprimir Tipos      ","Imprimir Tipos      ","Print Types          ","mv_cho","C",TamSx3("E1_TIPO")[1]*10,0,0,"G","","mv_par30","","","","","","","","","",""})
AAdd(aRegs,{"Nao Imprimir Tipos  ","No Imprimir Tipos   ","Do not Print Types   ","mv_chp","C",TamSx3("E1_TIPO")[1]*10,0,0,"G","","mv_par31","","","","","","","","","",""})
AAdd(aRegs,{"Somente Tit.p/Fluxo?","�Solo Tit.p/Flujo  ?","Just Bills to C.Flow","mv_chq","N",1,0,2,"C","","mv_par32","Sim","Si","Yes","","","Nao","No","No","",""})
AAdd(aRegs,{"Data Base           ","Data de Hoy         ","Base Date           ","mv_chr","D",8,0,0,"G","","mv_par33","","","","'"+Dtoc(dDataBase)+"'","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aRegs)
	cOrdem := StrZero(nX+29,2)
	If !(MsSeek(cPerg+cOrdem))
		RecLock("SX1",.T.)
		Replace X1_GRUPO		With cPerg
		Replace X1_ORDEM		With cOrdem
		Replace x1_pergunte	With aRegs[nx][01]
		Replace x1_perspa		With aRegs[nx][02]
		Replace x1_pereng		With aRegs[nx][03]
		Replace x1_variavl	With aRegs[nx][04]
		Replace x1_tipo		With aRegs[nx][05]
		Replace x1_tamanho	With aRegs[nx][06]
		Replace x1_decimal	With aRegs[nx][07]
		Replace x1_presel		With aRegs[nx][08]
		Replace x1_gsc			With aRegs[nx][09]
		Replace x1_valid		With aRegs[nx][10]
		Replace x1_var01		With aRegs[nx][11]
		Replace x1_def01		With aRegs[nx][12]
		Replace x1_defspa1	With aRegs[nx][13]
		Replace x1_defeng1	With aRegs[nx][14]
		Replace x1_cnt01		With aRegs[nx][15]
		Replace x1_var02		With aRegs[nx][16]
		Replace x1_def02		With aRegs[nx][17]
		Replace x1_defspa2	With aRegs[nx][18]
		Replace x1_defeng2	With aRegs[nx][19]
		Replace x1_f3			With aRegs[nx][20]
		Replace x1_grpsxg		With aRegs[nx][21]
		MsUnlock()
	ElseIf cOrdem == "33"  //DataBase
		//Acerto o parametro com a database
		RecLock("SX1",.F.)
		Replace x1_cnt01		With aRegs[nx][15]
		MsUnlock()	
	Endif
Next
dbSelectArea(_sAlias)
Return

Static Function xSaldoTit()
Local _nValor := SE2->E2_VALOR,;
      _nSaldo := 0

	SE5->(DbsetOrder(7))
	SE5->(DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
	If SE5->(Found())
		_nValor := 0
		While !SE5->(EOF()) .AND. SE5->E5_PREFIXO == SE2->E2_PREFIXO .AND. SE5->E5_NUMERO == SE2->E2_NUM .AND. ;
							      SE5->E5_PARCELA == SE2->E2_PARCELA .AND. SE5->E5_TIPO == SE2->E2_TIPO .AND. ;
							      SE5->E5_CLIFOR == SE2->E2_FORNECE .AND. SE5->E5_LOJA == SE2->E2_LOJA

			If SE2->E2_SALDO <=0
				If dDataBase > SE2->E2_VENCREA 		//Vencidos
					If mv_par15 == 1
						If SE5->E5_DATA <= dDataBase
							_nValor += SE5->E5_VALOR
						Else
							_nValor := SE2->E2_VALOR
						Endif
					Else
						_nValor += SE5->E5_VALOR
					Endif
				Else  // A Vencer
					_nValor += SE2->E2_VALOR
					Exit
				Endif				
			Else
				_nValor := SE2->E2_SALDO			
			Endif
			SE5->(Dbskip())
		Enddo
	Endif
	_nSaldo := _nValor
			
Return(_nSaldo)
``