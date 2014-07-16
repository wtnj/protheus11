#INCLUDE "MATR770.CH"
#INCLUDE "FIVEWIN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR770  � Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o das Devolucoes                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR770(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Marcello     �29/08/00�oooooo�Impressao de casas decimais de acordo   ���
���              �        �      �com a moeda selecionada e conversao     ���
���              �        �      �(xmoeda)baseada na moeda gravada na nota���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NhFat012()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL titulo :=OemToAnsi(STR0001)	//"Relacao das Devolucoes de Vendas"
LOCAL cDesc1 :=OemToAnsi(STR0002)	//"Este relat�rio ir� imprimir a rela��o de itens"
LOCAL cDesc2 :=OemToAnsi(STR0003)	//"referentes as devolu��es de vendas."
LOCAL cDesc3 :=""
LOCAL cString:="SF1", OldAlias := alias()
LOCAL aTam   := TamSX3("F4_CF")

PRIVATE tamanho :="G"
PRIVATE cPerg   := "MTR770"
PRIVATE aReturn := { STR0004, 1,STR0005, 1, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE nomeprog:= "MATR770",nLastKey := 0
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Imporessao do Cabecalho e Rodape   �
//����������������������������������������������������������������
wnrel := "MATR770"
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Data digitacao De         	        �
//� mv_par02             // Data digitacao Ate                   �
//� mv_par03             // Fornec. de                           �
//� mv_par04             // Fornec. Ate                          �
//� mv_par05             // Loja de                              �
//� mv_par06             // Loja Ate                             �
//� mv_par07             // CFO de                               �
//� mv_par08             // CFO Ate                              �
//� mv_par09             // Qual moeda                           �
//� mv_par10             // do Produto                           �
//� mv_par11             // ate Produto                          �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Este bloco foi colocado para aumentar o tamanho da pergunta  �
//� "CFOP", de 3 digitos para 4 digitos   �
//����������������������������������������������������������������
/*dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPERG+"07")
if SX1->X1_TAMANHO != aTam[1]
	RecLock("SX1",.F.)
    SX1->X1_TAMANHO := aTam[1]
	MsUnlock()
endif
dbSeek(cPERG+"08")
if SX1->X1_TAMANHO != aTam[1]
	RecLock("SX1",.F.)
    SX1->X1_TAMANHO := aTam[1]
	MsUnlock()
endif
*/
dbSelectArea(OldAlias)
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	Set filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C770Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C770IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR770			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C770Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL CbCont
LOCAL limite :=220
LOCAL titulo :=OemToAnsi(STR0001)	//"Relacao das Devolucoes de Vendas"
LOCAL cDesc1 :=OemToAnsi(STR0002)	//"Este relat�rio ir� imprimir a rela��o de itens"
LOCAL cDesc2 :=OemToAnsi(STR0003)	//"referentes as devolu��es de vendas."
LOCAL cDesc3 :=""
LOCAL nTotal := 0 ,nIpi
LOCAL cTipAnt,cChave,condicao,condicao1
LOCAL cTipGrp
LOCAL cProdAnt
LOCAL cQuebra
LOCAL cNomArq, lDevolucao
LOCAL aImpostos :={}
Local nCusto:=0

PRIVATE nImpInc,cCampoImp
PRIVATE nDecs:=msdecimais(mv_par09)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Imporessao do Cabecalho e Rodape   �
//����������������������������������������������������������������
titulo:= STR0001 + " - " + GetMv("MV_MOEDA"+STR(mv_par09,1))
cabec1:= STR0006	//"NOTA         PRODUTO         DESCRICAO                    QUANTIDADE UM    PR.UNITARIO IPI            VALOR ICM CODIGO/RAZAO SOCIAL DO CLIENTE                TP TE  TIPO GRUPO DT.DIGITACAO          CUSTO NF ORIG SERIE"
//        				999999999999 xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx 99,999,999.99 xx 999,999,999.99  99 9,999,999,999,99  99 999999/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  X xxx  xx   xxxx   99/99/9999 999,999,999.99 999999xxxxxx/xxx
//        				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21         
//        				0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
cabec2:= ""
cbtxt := SPACE(10)
cbcont:= 00
Li    := 80
m_pag := 01

nTipo := IIF(aReturn[04]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

cNomArq := Criatrab(NIL,.F.)

cFiltro := dbFilter()
cFiltro += If(!Empty(cFiltro),".And.","")
cFiltro += "F1_FILIAL=='"+xFilial("SF1")+"'"
cFiltro += ".And.F1_TIPO=='D'.And.dtos(F1_DTDIGIT)>='"+dtos(mv_par01)+"'.And.dtos(F1_DTDIGIT)<='"+dtos(mv_par02)+"'"
cFiltro += ".And.F1_FORNECE>='"+mv_par03+"'.And.F1_FORNECE<='"+mv_par04+"'"
cFiltro += ".And.F1_LOJA>='"+mv_par05+"'.And.F1_LOJA<='"+mv_par06+"'"

dbSelectArea("SF1")
IndRegua("SF1",cNomArq,IndexKey(),,cFiltro,STR0007)			//"Selecionando Registros ... "
dbGotop()

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof()
	nImpInc:=0
	
	IF lEnd
		Exit
	Endif
	
	IncRegua()
	
	If F1_DTDIGIT < mv_par01 .Or. F1_DTDIGIT > mv_par02 .Or. F1_TIPO != "D"
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	cNFOri:= D1_NFORI
	cSerie:= D1_SERIORI
	lDevolucao := .F.
	
	While !Eof() .And. ;
		D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == ;
		xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA


		If lEnd
			Exit
		Endif


		If D1_COD >= mv_par10 .and. D1_COD <= mv_par11
			
			If D1_TIPO != "D" .Or. D1_CF < mv_par07 .Or. D1_CF > mv_par08
				dbSkip()
				Loop
			Endif
		
			lDevolucao := .T.
		
			If Li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif
		
			@ Li,000 PSAY D1_DOC
			@ Li,013 PSAY D1_COD
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+SD1->D1_COD)
		
			@ Li,029 PSAY Subs(B1_DESC,1,25)
		
			dbSelectArea("SD1")
			If ( cPaisLoc#"BRA" )
				aImpostos:=TesImpInf(D1_TES)
				For nX:=1 to len(aImpostos)
					If ( aImpostos[nX][3]=="1")
						cCampoImp:=aImpostos[nX][2]
						nImpInc	+=	&cCampoImp
					EndIf
				Next
			EndIf
		
			@ Li,055 PSAY D1_QUANT		picture PesqPictQt("D1_QUANT",13)
			@ Li,069 PSAY SB1->B1_UM		picture "@!"
			@ Li,072 PSAY xMoeda(D1_VUNIT,SF1->F1_MOEDA,mv_par09,SD1->D1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA) picture PesqPict("SD1","D1_VUNIT",14,mv_par09)
		
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
			If (cPaisLoc<>"BRA")
				nIpi:=SD1->D1_ALQIMP1
			Else
				nIpi:=SD1->D1_IPI
			EndIf
		
			dbSelectArea("SD1")
			@ Li,088 PSAY nIpi		picture "99"
			@ Li,091 PSAY xMoeda((D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,SD1->D1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA) picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			If ( cPaisLoc=="BRA" )
				@ Li,109 PSAY D1_PICM		picture "99"
			EndIf
			@ Li,112 PSAY Left(D1_FORNECE+"/"+SA1->A1_NOME, 45)
		
			dbSelectArea("SD1")
		
			@ Li,159 PSAY D1_TIPO
			@ Li,161 PSAY D1_TES
			@ Li,169 PSAY D1_TP
			@ Li,171 PSAY D1_GRUPO
			@ Li,178 PSAY D1_DTDIGIT
			nCusto:=If(mv_par09==1,D1_CUSTO,&("D1_CUSTO"+Str(mv_par09,1)))
			@ Li,189 PSAY nCusto		picture Pesqpict("SD1","D1_CUSTO",14,mv_par09)
			@ Li,204 PSAY D1_NFORI+"/"+D1_SERIORI
		
			Li++
		Endif
		dbSkip()

	EndDo
	
	If lDevolucao
		nTotal += ImpTotN(titulo)
		ImpDupl(cNFOri,cSerie)
		@ Li,00 PSAY __PrtThinLine()
		Li++
	Endif
	
	dbSelectArea("SF1")
	dbSkip()
	
EndDo

If Li != 80
	If nTotal != 0
		If Li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		Li++
		@ Li,170  PSAY "TOTAL GERAL       --> "
		@ Li,198  PSAY nTotal	Picture PesqPict("SF1","F1_VALMERC",16,mv_par09)
		Li++
		If lEnd
			@ Li+1,000  PSAY STR0008	//"CANCELADO PELO OPERADOR"
		Endif
		roda(CbCont,"NOTAS","G")
	Endif
EndIf

//��������������������������������������������������������������Ŀ
//� Restaura a Integridade dos dados                             �
//����������������������������������������������������������������
dbSelectArea("SD1")
dbSetOrder(1)

dbSelectArea("SF1")
RetIndex("SF1")
Set Filter To
dbSetOrder(1)

If File(cNomArq+OrdBagExt())
	Ferase(cNomArq+OrdBagExt())
Endif

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



//��������������������������������������������������������������Ŀ
//� Imprime Total Da Nota Fiscal                                 �
//����������������������������������������������������������������
Static Function ImpTotN(titulo)
LOCAL nTotNota:=0
If Li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
If ( cPaisLoc=="BRA" )
	nTotNota:= SF1->F1_VALMERC + SF1->F1_FRETE + SF1->F1_DESPESA + SF1->F1_VALIPI + SF1->F1_ICMSRET - SF1->F1_DESCONT
Else
	nTotNota:= SF1->F1_VALMERC + SF1->F1_FRETE + SF1->F1_DESPESA + nImpInc - SF1->F1_DESCONT
EndIf

nTotNota:=xMoeda(nTotNota,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA)

@ Li,120 PSAY STR0009	//"TOTAL DESCONTOS --> "
@ Li,150 PSAY xMoeda(SF1->F1_DESCONT,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,Sf1->F1_TXMOEDA) picture PesqPict("SF1","F1_DESCONT",14,mv_par09)

@ Li,170 PSAY STR0010	//"TOTAL NOTA FISCAL --> "
@ Li,200 PSAY nTotNota picture Pesqpict("SF1","F1_VALMERC",14,mv_par09)
Li+=1

//Return xMoeda(nTotNota,1,mv_par09,SF1->F1_DTDIGIT)
Return nTotNota



//��������������������������������������������������������������Ŀ
//� Imprime Todas duplicatas da nota fiscal de Saida             �
//����������������������������������������������������������������
Static Function ImpDupl(cNFOri,cSerie)
LOCAL cSeek
dbSelectArea("SE1")
dbSetOrder(1)
cSeek:=cSerie+cNFOri
If dbSeek(xFilial()+cSeek,.F.)
	@ Li,53 PSAY STR0011
	Li++		//"Duplicatas da Nota Fiscal de Saida"
	For i := 1 To 101 Step 50
		@ Li,i PSAY STR0013 // "Prf Numero Parc.    Venc.           Saldo"
	Next i
	Li++
	While !Eof() .And. xFilial()+cSeek==E1_FILIAL+E1_PREFIXO+E1_NUM
		For i := 1 To 101 Step 50
			@ Li,i    PSAY E1_PREFIXO
			@ Li,i+4  PSAY E1_NUM
			@ Li,i+17 PSAY E1_PARCELA
			@ Li,i+19 PSAY E1_VENCTO
		  	@ Li,i+29 PSAY xMoeda(E1_SALDO,E1_MOEDA,mv_par09,SE1->E1_EMISSAO) picture PesqPict("SE1","E1_SALDO",14,mv_par09)			  

			dbSkip()
			IF cSeek!=E1_FILIAL+E1_PREFIXO+E1_NUM
				Exit
			Endif
		Next i
		Li++
	EndDo
Else
	@ Li,53 PSAY STR0012	//"Nao houve titulos gerados na saida"
EndIf
Li++

Return
