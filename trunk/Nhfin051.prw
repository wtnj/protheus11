#INCLUDE "FINR130.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINR130	� Autor � Paulo Boschetti	    � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o dos Titulos a Receber 							  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR130(void)											  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function Nhfin051()
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi��o dos titulos a receber relativo a data ba-"
Local cDesc2 :=OemToAnsi(STR0002)  //"se do sistema."
Local cDesc3 :=""
Local wnrel
Local cString:="SE1"
Local nRegEmp:=SM0->(RecNo())
Local dOldDtBase := dDataBase
Local dOldData	:= dDatabase

Private titulo  :=""
Private cabec1  :=""
Private cabec2  :=""

Private aLinha  :={}
Private aReturn :={ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg	 :="FIN130"
Private nJuros  :=0
Private nLastKey:=0
Private nomeprog:="FINR130"
Private tamanho :="G"
Private _cNomCli := Space(30)
Private _nTotCli := 0
//��������������������������Ŀ
//� Defini��o dos cabe�alhos �
//����������������������������
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Receber"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Cliente      Prf-Numero         TP  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos Vencidos          | Titulos a Vencer | Num        Vlr.juros ou  Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor Nominal   Valor Corrigido |   Valor Nominal  | Banco       permanencia  Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela � necessaria para o correto funcionamento da pergunte 36 (Data Base)
//AjustaSx1()
PutDtBase()

pergunte("FIN130",.F.)

//������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros								   �
//� mv_par01		 // Do Cliente 										   �
//� mv_par02		 // Ate o Cliente									   �
//� mv_par03		 // Do Prefixo										   �
//� mv_par04		 // Ate o prefixo 									   �
//� mv_par05		 // Do Titulo				  					       �
//� mv_par06		 // Ate o Titulo									   �
//� mv_par07		 // Do Banco										   �
//� mv_par08		 // Ate o Banco										   �
//� mv_par09		 // Do Vencimento 									   �
//� mv_par10		 // Ate o Vencimento								   �
//� mv_par11		 // Da Natureza										   �
//� mv_par12		 // Ate a Natureza									   �
//� mv_par13		 // Da Emissao										   �
//� mv_par14		 // Ate a Emissao									   �
//� mv_par15		 // Qual Moeda										   �
//� mv_par16		 // Imprime provisorios								   �
//� mv_par17		 // Reajuste pelo vecto								   �
//� mv_par18		 // Impr Tit em Descont								   �
//� mv_par19		 // Relatorio Anal/Sint								   �
//� mv_par20		 // Consid Data Base?  								   �
//� mv_par21		 // Consid Filiais  ?  								   �
//� mv_par22		 // da filial										   �
//� mv_par23		 // a flial 										   �
//� mv_par24		 // Da loja  										   �
//� mv_par25		 // Ate a loja										   �
//� mv_par26		 // Consid Adiantam.?								   �
//� mv_par27		 // Da data contab. ?								   �
//� mv_par28		 // Ate data contab.?								   �
//� mv_par29		 // Imprime Nome    ?								   �
//� mv_par30		 // Outras Moedas   ?								   �
//� mv_par31         // Imprimir os Tipos								   �
//� mv_par32         // Nao Imprimir Tipos								   �
//� mv_par33         // Abatimentos  - Lista/Nao Lista/Despreza			   � 
//� mv_par34         // Consid. Fluxo Caixa								   �
//� mv_par35         // Salta pagina Cliente							   �
//� mv_par36         // Data Base										   �
//� mv_par37         // Compoe Saldo por: Data da Baixa, Credito ou DtDigit�
//� MV_PAR38         // Tit. Emissao Futura								   �
//��������������������������������������������������������������������������
//���������������������������������������Ŀ
//� Envia controle para a fun��o SETPRINT �
//�����������������������������������������

wnrel:="FINR130"            //Nome Default do relatorio em Disco
aOrd :={	OemToAnsi(STR0008),;	//"Por Cliente"
	OemToAnsi(STR0009),;	//"Por Prefixo/Numero"
	OemToAnsi(STR0010),; //"Por Banco"
	OemToAnsi(STR0011),;	//"Por Venc/Cli"
	OemToAnsi(STR0012),;	//"Por Natureza"
	OemToAnsi(STR0013),; //"Por Emissao"
	OemToAnsi(STR0014),;	//"Por Ven\Bco"
	OemToAnsi(STR0015),; //"Por Cod.Cli."
	OemToAnsi(STR0016),; //"Banco/Situacao"
	OemToAnsi(STR0047) } //"Por Numero/Tipo/Prefixo"

//wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| FA130Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

SM0->(dbGoTo(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par20 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA130Imp � Autor � Paulo Boschetti		  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime relat�rio dos T�tulos a Receber						  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA130Imp(lEnd,WnRel,cString)										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd	  - A��o do Codeblock				    					  ���
���			 � wnRel   - T�tulo do relat�rio 									  ���
���			 � cString - Mensagem													  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA130Imp(lEnd,WnRel,cString)
Local CbCont
Local CbTxt
Local nOrdem
Local lContinua := .T.
Local cCond1,cCond2,cCarAnt
Local nTit0:=0
Local nTit1:=0
Local nTit2:=0
Local nTit3:=0
Local nTit4:=0
Local nTit5:=0
Local nTotJ:=0
Local nTot0:=0
Local nTot1:=0
Local nTot2:=0
Local nTot3:=0
Local nTot4:=0
Local nTotTit:=0
Local nTotJur:=0
Local nTotFil0:=0
Local nTotFil1:=0
Local nTotFil2:=0
Local nTotFil3:=0
Local nTotFil4:=0
Local nTotFilTit:=0
Local nTotFilJ:=0
Local nAtraso:=0
Local nTotAbat:=0
Local nSaldo:=0
Local dDataReaj
Local dDataAnt := dDataBase
Local lQuebra
Local nMesTit0 := 0
Local nMesTit1 := 0
Local nMesTit2 := 0
Local nMesTit3 := 0
Local nMesTit4 := 0
Local nMesTTit := 0
Local nMesTitj := 0
Local cIndexSe1
Local cChaveSe1
Local nIndexSE1
Local dDtContab
Local cTipos  := ""
#IFDEF TOP
	Local aStru := SE1->(dbStruct()), ni
#ENDIF	
Local nTotsRec := SE1->(RecCount())
Local aTamCli  := TAMSX3("E1_CLIENTE")
Local lF130Qry := ExistBlock("F130QRY")
// variavel  abaixo criada p/pegar o nr de casas decimais da moeda
Local ndecs := Msdecimais(mv_par15)
Local nAbatim := 0
Local nDescont:= 0
Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase
PRIVATE cFilDe,cFilAte

//��������������������������������������������������������������Ŀ
//� Ponto de entrada para Filtrar os tipos sem entrar na tela do �
//� FINRTIPOS(), localizacao Argentina.                          �
//����������������������������Jose Lucas, Localiza��es Argentina��
IF EXISTBLOCK("F130FILT")
	cTipos	:=	EXECBLOCK("F130FILT",.f.,.f.)
ENDIF

nOrdem:=aReturn[8]
cMoeda:=Str(mv_par15,1)

//�����������������������������������������������������������Ŀ
//� Vari�veis utilizadas para Impress�o do Cabe�alho e Rodap� �
//�������������������������������������������������������������
cbtxt 	:= OemtoAnsi(STR0046)
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

//������������������������������������������������������������������Ŀ
//� POR MAIS ESTRANHO QUE PARE�A, ESTA FUNCAO DEVE SER CHAMADA AQUI! �
//�                                                                  �
//� A fun��o SomaAbat reabre o SE1 com outro nome pela ChkFile para  �
//� efeito de performance. Se o alias auxiliar para a SumAbat() n�o  �
//� estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   �
//� pois o Filtro do SE1 uptrapassa 255 Caracteres.                  �
//��������������������������������������������������������������������
SomaAbat("","","","R")

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par21 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par22	// Todas as filiais
	cFilAte:= mv_par23
Endif

//Acerta a database de acordo com o parametro
If mv_par20 == 1    // Considera Data Base
	dDataBase := mv_par36
Endif	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	
	dbSelectArea("SE1")
	cFilAnt := SM0->M0_CODFIL
	Set Softseek On
	
	If mv_par19 == 1
		titulo := titulo + OemToAnsi(STR0026)  //" - Analitico"
	Else
		titulo := titulo + OemToAnsi(STR0027)  //" - Sintetico"
		cabec1 := OemToAnsi(STR0044)  //"                                                                                                               |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0045)  //"                                                                                                               |  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	#IFDEF TOP
		
		If nOrdem = 1
			cQuery := ""
			aEval(SE1->(DbStruct()),{|e| If(!Alltrim(e[1])$"E1_FILIAL#E1_NOMCLI#E1_CLIENTE#E1_LOJA#E1_PREFIXO#E1_NUM#E1_PARCELA#E1_TIPO", cQuery += ","+AllTrim(e[1]),Nil)})
			cQuery := "SELECT E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM,E1_PARCELA, E1_TIPO, "+ SubStr(cQuery,2)
		Else
			cQuery := "SELECT * "
		EndIf
		
		cQuery += "  FROM "+	RetSqlName("SE1") + " SE1"
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
		cQuery += "   AND D_E_L_E_T_ <> '*' "
	#ENDIF
		
	SE1->(dbSetOrder(7))
	#IFNDEF TOP
		dbSeek(cFilial+DTOS(mv_par09))
	#ELSE
		cOrder := SqlOrder(IndexKey())
	#ENDIF
	cCond1 := "E1_VENCREA <= mv_par10"
	cCond2 := "DTOS(E1_VENCREA) + E1_NOMCLI"
	titulo := titulo + OemToAnsi(STR0020)  //" - Por Data de Vencimento"

	If mv_par19 == 1
		titulo := titulo + OemToAnsi(STR0026)  //" - Analitico"
	Else
		titulo := titulo + OemToAnsi(STR0027)  //" - Sintetico"
		cabec1 := OemToAnsi(STR0044)  //"Nome do Cliente      |        Titulos Vencidos          | Titulos a Vencer |            Vlr.juros ou             (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0045)  //"|  Valor Nominal   Valor Corrigido |   Valor Nominal  |             permanencia                              "
	EndIf
	
	cFilterUser:=aReturn[7]
	Set Softseek Off
	
	#IFDEF TOP
		cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
		cQuery += " AND E1_PREFIXO between '" + mv_par03        + "' AND '" + mv_par04 + "'"
		cQuery += " AND E1_NUM     between '" + mv_par05        + "' AND '" + mv_par06 + "'"
		cQuery += " AND E1_PORTADO between '" + mv_par07        + "' AND '" + mv_par08 + "'"
		cQuery += " AND E1_VENCREA between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
		cQuery += " AND (E1_MULTNAT = '1' OR (E1_NATUREZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'))"
		cQuery += " AND E1_EMISSAO between '" + DTOS(mv_par13)  + "' AND '" + DTOS(mv_par14) + "'"
		cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"

		If MV_PAR38 == 2 //Nao considerar titulos com emissao futura
			cQuery += " AND E1_EMISSAO <=      '" + DTOS(dDataBase) + "'"
		Endif

		cQuery += " AND ((E1_EMIS1  Between '"+ DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"') OR E1_EMISSAO Between '"+DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"')"
		If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
			cQuery += " AND E1_TIPO IN "+FormatIn(mv_par31,";") 
		ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
			cQuery += " AND E1_TIPO NOT IN "+FormatIn(mv_par32,";")
		EndIf
		If mv_par18 == 2
			cQuery += " AND E1_SITUACA NOT IN ('2','7')"
		Endif
		If mv_par20 == 2
			cQuery += ' AND E1_SALDO <> 0'
		Endif
		If mv_par34 == 1
			cQuery += " AND E1_FLUXO <> 'N'"
		Endif               
        //������������������������������������������������������������������������Ŀ
        //� Ponto de entrada para inclusao de parametros no filtro a ser executado �
        //��������������������������������������������������������������������������
	    If lF130Qry 
			cQuery += ExecBlock("F130QRY",.f.,.f.)
		Endif

		cQuery += " ORDER BY "+ cOrder
		
		cQuery := ChangeQuery(cQuery)
		
		dbSelectArea("SE1")
		dbCloseArea()
		dbSelectArea("SA1")
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ENDIF
	SetRegua(nTotsRec)
	
	If MV_MULNATR .And. nOrdem == 5
		Finr135(cTipos, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ )
		#IFDEF TOP
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
		#ENDIF
		If Empty(xFilial("SE1"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif
	
	While &cCond1 .and. !Eof() .and. lContinua .and. E1_FILIAL == xFilial("SE1")
		
		IF	lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		IncRegua()
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		//����������������������������������������Ŀ
		//� Carrega data do registro para permitir �
		//� posterior analise de quebra por mes.   �
		//������������������������������������������
		dDataAnt := SE1->E1_VENCREA
		cCarAnt  := &cCond2
		
		While &cCond2==cCarAnt .and. !Eof() .and. lContinua .and. E1_FILIAL == xFilial("SE1")
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0028)  //"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIF
			
			IncRegua()
			
			dbSelectArea("SE1")
			//��������������������������������������������������������������Ŀ
			//� Filtrar com base no Pto de entrada do Usuario...             �
			//����������������������������Jose Lucas, Localiza��es Argentina��
			If !Empty(cTipos)
				If !(SE1->E1_TIPO $ cTipos)
					dbSkip()
					Loop
				Endif
			Endif
			
			//��������������������������������������������������������������Ŀ
			//� Considera filtro do usuario                                  �
			//����������������������������������������������������������������
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			
			//��������������������������������������������������������������Ŀ
			//� Verifica se titulo, apesar do E1_SALDO = 0, deve aparecer ou �
			//� n�o no relat�rio quando se considera database (mv_par20 = 1) �
			//� ou caso n�o se considere a database, se o titulo foi totalmen�
			//� te baixado.																  �
			//����������������������������������������������������������������
			dbSelectArea("SE1")
			IF !Empty(SE1->E1_BAIXA) .and. Iif(mv_par20 == 2 ,SE1->E1_SALDO == 0 ,;
					IIF(mv_par37 == 1,(SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase),.F.))
				dbSkip()
				Loop
			EndIF
			
			//������������������������������������������������������Ŀ
			//� Verifica se trata-se de abatimento ou somente titulos�
			//� at� a data base. 									 �
			//��������������������������������������������������������
			IF (SE1->E1_TIPO $ MVABATIM .And. mv_par33 != 1) .Or.;
				(SE1->E1_EMISSAO > dDataBase .and. MV_PAR38 == 2)
				dbSkip()
				Loop
			Endif
			
			//������������������������������������������������������Ŀ
			//� Verifica se ser� impresso titulos provis�rios		 �
			//��������������������������������������������������������
			IF E1_TIPO $ MVPROVIS .and. mv_par16 == 2
				dbSkip()
				Loop
			Endif
			
			//������������������������������������������������������Ŀ
			//� Verifica se ser� impresso titulos de Adiantamento	 �
			//��������������������������������������������������������
			IF SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par26 == 2
				dbSkip()
				Loop
			Endif
			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtContab := Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)
			
			//����������������������������������������Ŀ
			//� Verifica se esta dentro dos parametros �
			//������������������������������������������
			dbSelectArea("SE1")
			IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
				SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
				SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
				SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
				SE1->E1_VENCREA < mv_par09 .OR. SE1->E1_VENCREA > mv_par10 .OR. ;
				SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;
				SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ;
				SE1->E1_LOJA    < mv_par24 .OR. SE1->E1_LOJA    > mv_par25 .OR. ;
				dDtContab       < mv_par27 .OR. dDtContab       > mv_par28 .OR. ;
				(SE1->E1_EMISSAO > dDataBase .and. MV_PAR38 == 2) .Or. !&(fr130IndR())
				dbSkip()
				Loop
			Endif
			
			If mv_par18 == 2 .and. E1_SITUACA $ "27"
				dbSkip()
				Loop
			Endif
			
			//����������������������������������������Ŀ
			//� Verifica se deve imprimir outras moedas�
			//������������������������������������������
			If mv_par30 == 2 // nao imprime
				if SE1->E1_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif
			Endif
			
			
			dDataReaj := IIF(SE1->E1_VENCREA < dDataBase ,;
				IIF(mv_par17=1,dDataBase,E1_VENCREA),;
				dDataBase)
			
			If mv_par20 == 1	// Considera Data Base
				nSaldo :=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par37)
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
					nSAldo -= SE1->E1_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
					nSAldo += SE1->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna 
				//sempre saldo em aberto quando mv_par33 = 1 (Abatimentos = Lista)
				If SE1->E1_TIPO $ MVABATIM .and. SE1->E1_BAIXA <= dDataBase .and. !Empty(SE1->E1_BAIXA)
					nSaldo := 0
				Endif

			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Endif

			//Caso exista desconto financeiro (cadastrado na inclusao do titulo), 
			//subtrai do valor principal.
			nDescont := FaDescFin("SE1",dBaixa,nSaldo,1)   
			If nDescont > 0
				nSaldo := nSaldo - nDescont
			Endif
			
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par38 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif

					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)

					If mv_par38 == 1
						dDataBase := dOldData
					Endif

					If STR(nSaldo,17,2) == STR(nAbatim,17,2)
						nSaldo := 0
					ElseIf mv_par33 != 3
						nSaldo-= nAbatim
					Endif
				EndIf
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)
			
			//������������������������������������������������������Ŀ
			//� Desconsidera caso saldo seja menor ou igual a zero   �
			//��������������������������������������������������������
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SA1")
			MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
			dbSelectArea("SA6")
			MSSeek(cFilial+SE1->E1_PORTADO)
			dbSelectArea("SE1")
			
			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
			
			If mv_par19 == 1
				@li,	0 PSAY SE1->E1_CLIENTE + "-" + SE1->E1_LOJA + "-" +;
					SubStr( SE1->E1_NOMCLI, 1, 17 )
				li := IIf (aTamCli[1] > 6,li+1,li)
				@li, 28 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA
				If SE1->E1_TIPO$MVABATIM
					@li,46 PSAY "["
				Endif
				@li, 47 PSAY SE1->E1_TIPO
				If SE1->E1_TIPO$MVABATIM
					@li,50 PSAY "]"
				Endif
				@li, 51 PSAY SE1->E1_NATUREZ
				@li, 62 PSAY SE1->E1_EMISSAO
				@li, 73 PSAY SE1->E1_VENCTO
				@li, 84 PSAY SE1->E1_VENCREA
				@li, 95 PSAY SE1->E1_PORTADO+" "+SE1->E1_SITUACA
				@li,101 PSAY xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))* If(SE1->E1_TIPO$MVABATIM+"/"+MV_CRNEG+"/"+MVRECANT, -1,1) Picture PesqPict("SE1","E1_VALOR",14,MV_PAR15)
			Endif
			
			If dDataBase > E1_VENCREA	//vencidos
				If mv_par19 == 1
					If ! SE1->E1_TIPO $ MVABATIM
						@li, 116 PSAY nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1)  Picture TM(nSaldo,14,nDecs)
					EndIf
				EndIf
				nJuros:=0
				fa070Juros(mv_par15)
				dbSelectArea("SE1")
				If mv_par19 == 1
					@li,133 PSAY (nSaldo+nJuros)* If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1) Picture TM(nSaldo+nJuros,14,nDecs)
				EndIf
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG
					nTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros)
					nMesTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nMesTit1 -= (nSaldo)
					nMesTit2 -= (nSaldo+nJuros)
					nTotJur  -= nJuros
					nMesTitj -= nJuros
					nTotFilJ -= nJuros
				Else
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit1 += (nSaldo)
						nTit2 += (nSaldo+nJuros)
						nMesTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nMesTit1 += (nSaldo)
						nMesTit2 += (nSaldo+nJuros)
						nTotJur  += nJuros
						nMesTitj += nJuros
						nTotFilJ += nJuros
					Endif	
				Endif
			Else						//a vencer
				If mv_par19 == 1
					@li,149 PSAY nSaldo * If(SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT, -1,1)  Picture TM(nSaldo,14,nDecs)
				EndIf
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit3 += (nSaldo-nTotAbat)
						nTit4 += (nSaldo-nTotAbat)
						nMesTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nMesTit3 += (nSaldo-nTotAbat)
						nMesTit4 += (nSaldo-nTotAbat)
					EndIf
				Else
					nTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
					nMesTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nMesTit3 -= (nSaldo-nTotAbat)
					nMesTit4 -= (nSaldo-nTotAbat)
				Endif
			Endif
			
			If mv_par19 == 1
				@ li, 164 PSAY SE1->E1_NUMBCO
			EndIf
			If nJuros > 0
				If mv_par19 == 1
					@ Li,181 PSAY nJuros Picture PesqPict("SE1","E1_JUROS",10,MV_PAR15)
				EndIf
				nJuros := 0
			Endif
			
			IF dDataBase > SE1->E1_VENCREA
				nAtraso:=dDataBase-SE1->E1_VENCTO
				IF Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso := 0
					EndIF
				EndIF
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par19 == 1
						@li ,195 PSAY nAtraso Picture "9999"
					EndIf
				EndIF
			EndIF
			If mv_par19 == 1
				@li,200 PSAY SubStr(SE1->E1_HIST,1,20)+ ;
					IIF(E1_TIPO $ MVPROVIS,"*"," ")+ ;
					Iif(nSaldo == xMoeda(E1_VALOR,E1_MOEDA,mv_par15,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))," ","P")
			EndIf
			
			//����������������������������������������Ŀ
			//� Carrega data do registro para permitir �
			//� posterior an�lise de quebra por mes.   �
			//������������������������������������������
			dDataAnt := SE1->E1_VENCREA

			dbSkip()
			nTotTit ++
			nMesTTit ++
			nTotFiltit++
			nTit5 ++
			If mv_par19 == 1
				li++
			EndIf
		Enddo
		
		IF nTit5 > 0 .and. nOrdem != 2 .and. nOrdem != 10
			SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par19 == 1
				Li++
			EndIf
		Endif
		
		//����������������������������������������Ŀ
		//� Verifica quebra por m�s	  			   �
		//������������������������������������������
		lQuebra := .F.
		If (Month(SE1->E1_VENCREA) # Month(dDataAnt) .or. SE1->E1_VENCREA > mv_par10)
			lQuebra := .T.
		Endif	

		If lQuebra .and. nMesTTit # 0
			ImpMes130(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif
		nTot0+=nTit0
		nTot1+=nTit1
		nTot2+=nTit2
		nTot3+=nTit3
		nTot4+=nTit4
		nTotJ+=nTotJur
		nTotFil0+=nTit0
		nTotFil1+=nTit1
		nTotFil2+=nTit2
		nTotFil3+=nTit3
		nTotFil4+=nTit4
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
	Enddo
	
	dbSelectArea("SE1")		// voltar para alias existente, se nao, nao funciona
	
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par21 == 1 .and. SM0->(Reccount()) > 1
		ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFiltit,nTotFilJ,nDecs)
	Endif
	Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
	If Empty(xFilial("SE1"))
		Exit
	Endif
	
	#IFDEF TOP
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	#ENDIF
	
	dbSelectArea("SM0")
	dbSkip()
Enddo

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL
IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	dbSelectArea("SE1")
	dbCloseArea()
	ChKFile("SE1")
	dbSelectArea("SE1")
	dbSetOrder(1)
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SubTot130 � Autor � Paulo Boschetti 		  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprimir SubTotal do Relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � SubTot130()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	    � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

Local cCarteira := " "
DEFAULT nDecs := Msdecimais(mv_par15)

If mv_par19 == 1
	li++
EndIf
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

@li,000 PSAY OemToAnsi(STR0037)  // "S U B - T O T A L ----> "
@li,028 PSAY Substr(cCarAnt,9,30)
@li,PCOL()+2 PSAY Iif(mv_par21==1,cFilAnt+ " - " + Alltrim(SM0->M0_FILIAL),"  ")

If mv_par19 == 1
	@li,101 PSAY nTit0		  Picture TM(nTit0,14,nDecs)
Endif
@li,116 PSAY nTit1		  Picture TM(nTit1,14,nDecs)
@li,133 PSAY nTit2		  Picture TM(nTit2,14,nDecs)
@li,149 PSAY nTit3		  Picture TM(nTit3,14,nDecs)
If nTotJur > 0
	@li,179 PSAY nTotJur  Picture TM(nTotJur,12,nDecs)
Endif
@li,204 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)
li++
If (nOrdem = 1 .Or. nOrdem == 8) .And. mv_par35 == 1 // Salta pag. por cliente
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
Endif
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � TotGer130� Autor � Paulo Boschetti       � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir total do relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � TotGer130()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

@li,000 PSAY OemToAnsi(STR0038) //"T O T A L   G E R A L ----> " + " " + Iif(mv_par21==1,cFilAnt,"")
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"		//"TITULOS"###"TITULO"
If mv_par19 == 1
	@li,101 PSAY nTot0		  Picture TM(nTot0,14,nDecs)
Endif
@li,116 PSAY nTot1		  Picture TM(nTot1,14,nDecs)
@li,133 PSAY nTot2		  Picture TM(nTot2,14,nDecs)
@li,149 PSAY nTot3		  Picture TM(nTot3,14,nDecs)
@li,179 PSAY nTotJ		  Picture TM(nTotJ,12,nDecs)
@li,204 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,16,nDecs)
li++
li++
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ImpMes130 � Autor � Vinicius Barreira	  � Data � 12.12.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpMes130() 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function ImpMes130(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)
li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0041)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0039),OemToAnsi(STR0040))+")"  //"TITULOS"###"TITULO"
If mv_par19 == 1
	@li,101 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
Endif
@li,116 PSAY nMesTot1	Picture TM(nMesTot1,14,nDecs)
@li,133 PSAY nMesTot2	Picture TM(nMesTot2,14,nDecs)
@li,149 PSAY nMesTot3	Picture TM(nMesTot3,14,nDecs)
@li,179 PSAY nMesTotJ	Picture TM(nMesTotJ,12,nDecs)
@li,204 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs)
li+=2
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � ImpFil130� Autor � Paulo Boschetti  	  � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir total do relatorio										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpFil130()																  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�																				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	    � Generico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0043)+" "+Iif(mv_par21==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")  //"T O T A L   F I L I A L ----> "
If mv_par19 == 1
	@li,101 PSAY nTotFil0        Picture TM(nTotFil0,14,nDecs)
Endif
@li,116 PSAY nTotFil1        Picture TM(nTotFil1,14,nDecs)
@li,133 PSAY nTotFil2        Picture TM(nTotFil2,14,nDecs)
@li,149 PSAY nTotFil3        Picture TM(nTotFil3,14,nDecs)
@li,179 PSAY nTotFilJ		  Picture TM(nTotFilJ,12,nDecs)
@li,204 PSAY nTotFil2+nTotFil3 Picture TM(nTotFil2+nTotFil3,16,nDecs)
li+=2
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fr130Indr � Autor � Wagner           	  � Data � 12.12.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta Indregua para impressao do relat�rio						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fr130IndR()
Local cString

cString := 'E1_FILIAL=="'+xFilial("SE1")+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_PREFIXO>="'+mv_par03+'".and.E1_PREFIXO<="'+mv_par04+'".And.'
cString += 'E1_NUM>="'+mv_par05+'".and.E1_NUM<="'+mv_par06+'".And.'
cString += 'DTOS(E1_VENCREA)>="'+DTOS(mv_par09)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par10)+'".And.'
cString += '(E1_MULTNAT == "1" .OR. (E1_NATUREZ>="'+mv_par11+'".and.E1_NATUREZ<="'+mv_par12+'")).And.'
cString += 'DTOS(E1_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E1_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
	cString += '.And.E1_TIPO$"'+mv_par31+'"'
ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
	cString += '.And.!(E1_TIPO$'+'"'+mv_par32+'")'
EndIf
IF mv_par34 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E1_FLUXO!="N")'	
Endif
Return cString

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PutDtBase� Autor � Mauricio Pequim Jr    � Data � 18/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Acerta parametro database do relatorio                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Finr130.prx                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN13036")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Mauricio Pequim Jr. � Data �29.12.2004   ���
�������������������������������������������������������������������������͹��
���Desc.     �Insere novas perguntas ao sx1                               ���
�������������������������������������������������������������������������͹��
���Uso       � FINR130                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
					  
Aadd( aHelpPor, 'Selecione "Sim" para que sejam         '  )
Aadd( aHelpPor, 'considerados no relat�rio, t�tulos cuja'  )
Aadd( aHelpPor, 'emiss�o seja em data posterior a database' )
Aadd( aHelpPor, 'do relat�rio, ou "N�o" em caso contr�rio'  )

Aadd( aHelpSpa, 'Seleccione "S�" para que se consideren en'	)
Aadd( aHelpSpa, 'el informe los t�tulos cuya emisi�n sea en')
Aadd( aHelpSpa, 'fecha posterior a la fecha base de dicho '	)
Aadd( aHelpSpa, 'informe o "No" en caso contrario'	)

Aadd( aHelpEng, 'Choose "Yes" for bills which issue date '	)
Aadd( aHelpEng, 'is posterior to the report base date in ' 	)
Aadd( aHelpEng, 'the report, otherwise "No"' 			)

PutSx1( "FIN130", "38","Tit. Emissao Futura?","Tit.Emision Futura  ","Future Issue Bill   ","mv_chs","N",1,0,2,"C","","","","","mv_par38","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Situcob   �Autor  �Mauricio Pequim Jr. � Data �13.04.2005   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna situacao de cobranca do titulo                      ���
�������������������������������������������������������������������������͹��
���Uso       � FINR130                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SituCob(cCarAnt)

Local aSituaca := {}
Local aArea		:= GetArea()
Local cCart		:= " "

//����������������������������������������������������������������������Ŀ
//� Monta a tabela de situa��es de T�tulos										 �
//������������������������������������������������������������������������
dbSelectArea("SX5")
dbSeek(cFilial+"07")
While SX5->X5_FILIAL+SX5->X5_tabela == cFilial+"07"
	cCapital := Capital(X5Descri())
	AADD( aSituaca,{SubStr(SX5->X5_CHAVE,1,2),OemToAnsi(SubStr(cCapital,1,20))})
	dbSkip()
EndDo

nOpcS := (Ascan(aSituaca,{|x| Alltrim(x[1])== Substr(cCarAnt,4,1) }))
If nOpcS > 0
	cCart := aSituaca[nOpcS,1]+aSituaca[nOpcs,2]		
ElseIf Empty(SE1->E1_SITUACA)
	cCart := "0 "+STR0029
Endif
RestArea(aArea)
Return cCart
