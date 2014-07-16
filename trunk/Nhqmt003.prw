#INCLUDE "QMTR010.Ch"
#INCLUDE "FIVEWIN.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � QMTR010  � Autor � Alessandro B. Freire  � Data � 23.03.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de instrumentos a calibrar                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QMTR010(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Denis     �Melhor� Melhora de Performance - Utilizacao de Query's am-  ��� 
���          �      � biente Top e Arquivo Temporario para ambiente Code  ���
���          �      � Base.												  ���
���Denis     �Melhor� Acerto na impressao do relatorio qdo da utilizacao  ��� 
���          �      � do indice data.                                     ���
���Alexandre �Melhor� Adicionada a Ordem por Familia em 07/04/04          ��� 
���R.Bento   �      �                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NhQMT003()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cDesc1	:= OemToAnsi( STR0001 ) // "Este programa ir� emitir a rela��o de"
Local cDesc2	:= OemToAnsi( STR0002 ) // "instrumentos a calibrar."
Local cDesc3	:= ""
Local wnrel    := ""
Local lImpLin2	:= .T.
Local limite	:= 132
Local cString	:="QM2"

Private titulo := OemToAnsi(STR0013) //Instrumentos a Calibrar
Private cabec1		:= ""
Private cabec2    := ""
Private aReturn	:= { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 } //"Zebrado"###"Administra��o"
Private nomeprog	:="QMTR010"
Private cPerg		:="QMR010"
Private cTamanho := "G"

aOrd := { OemToAnsi(STR0009), OemToAnsi(STR0010), OemToAnsi(STR0016),OemToAnsi(STR0018) }

PutSx1("QMR010","25",OemToAnsi(STR0017),OemToAnsi(STR0017),OemToAnsi(STR0017),"mv_chs","N",1,0,2,"C","","","","","mv_par25","Sim","Si","Si","","Nao","No","No","","",;
    "","","","","","","") 

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("QMR010",.F.)
//�������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                  �
//� mv_par01   : Instrumento Inicial                      �
//� mv_par02   : Instrumento Final                        �
//� mv_par03   : Periodo Inicial                          �
//� mv_par04   : Periodo Final                            �
//� mv_par05   : Departamento Inicial                     �
//� mv_par06   : Departamento Final                       �
//� mv_par07   : Orgao Calibrador Todos/Interno/Externo   �
//� mv_par08   : Orgao Calibrador interno de              �
//� mv_par09   : Orgao Calibrador interno ate             �
//� mv_par10   : Orgao Calibrador externo de              �
//� mv_par11   : Orgao Calibrador externo ate             �
//� mv_par12   : Fam�lia de                               �
//� mv_par13   : Fam�lia ate                              �
//� mv_par14   : Fabricante de                            �
//� mv_par15   : Fabricante ate                           �
//� mv_par16   : Impr.Desc.Fam�lia      Sim - N�o         �
//� mv_par17   : Impr.Localiza��o       Sim - N�o         �
//� mv_par18   : Impr.Tol.Proc./Redutor Sim - N�o         �
//� mv_par19   : Status de                                �
//� mv_par20   : Status ate                               �
//� mv_par21   : Usu�rio de                               �
//� mv_par22   : Usu�rio ate                              �
//� mv_par23   : Quebra por Depto                         �
//� mv_par24   : Formato da Data                          �
//���������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="QMTR010"   //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,cTamanho,{},.F.)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| MTR010Imp(@lEnd,wnRel,cString,lImpLin2)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR010IMP� Autor � Alessandro B.Freire   � Data � 23.03.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Sugestao de Bloqueio                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTR010IMP(lEnd,wnRel,cString)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - A��o do Codeblock                                ���
���          � wnRel   - T�tulo do relat�rio                              ���
���          � cString - Mensagem                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MTR010Imp(lEnd,wnRel,cString,lImpLin2)

Local CbCont
Local CbTxt
Local nTotCli		:= 0
Local nLimCred		:= 0
Local nOrdem		:= IndexOrd()
Local cAlias		:= Alias()
Local cInstr		:= ""
Local nCntParc		:= 0    // Contador para subtotal
Local nCntTot		:= 0    // Contador para total
Local cChave		:= ""   // Auxiliar para quebra de subtotal
Local nIndex		:= 0
Local cKey			:= ""
Local lVez			:= .t.
Local nRec			:= 0
Local nTm			:= 1
Local cLbDepto		:= Subs(TitSx3("QM2_DEPTO")[1],1,10)
Local cLbInstr		:= TitSx3("QM2_INSTR")[1]
Local cLbTipo		:= TitSx3("QM2_TIPO")[1]
Local cLbFabr		:= TiTSx3("QM2_FABR")[1]
Local cLbFreq		:= Subs(TitSx3("QM2_FREQAF")[1],1,4)
Local cLbValDaf		:= TitSx3("QM2_VALDAF")[1]
Local cLbResp		:= Subs(TitSx3("QM2_RESP")[1],1,9)
Local cLbLocal		:= TitSx3("QM2_LOCAL")[1]
Local cLbDescr		:= TitSx3("QM1_DESCR")[1]
Local cLbEscal		:= TitSx3("QM9_ESCALA")[1]
Local cLbRedut		:= Subs(TitSx3("QMR_REDUT")[1],1,10)
Local cLbTol		:= TitSx3("QMR_TOLPRO")[1]
Local cChaveQ		:= ""   
Private cIndex      := ""
Private lAbortPrint := .F.
Private cFilialTRB	
Private TRB_FILIAL	
Private TRB_INSTRL	
Private TRB_REVINS	
Private TRB_REVINV	
Private TRB_DEPTO	
Private TRB_TIPO	
Private TRB_VALDAF	
Private TRB_FREQAF	
Private TRB_RESP	
Private TRB_FABR	
Private TRB_STATUS	
Private TRB_LAUDO
Private TRB_TDESCR
Private TRB_CUSTO
Private TRB_DATCO
Private aInstru := {}
Private lImpSub := .F.
nCntTot := 0

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
titulo := OemToAnsi( STR0005 ) // "Relatorio de Instrumentos a Calibrar"

cabec1 :=	cLbDepto+" "+cLbInstr+space(6)+	cLbTipo+space(9)+cLbFabr+space(21)+;
					cLbFreq+"  "+cLbValDaf+" "+cLbResp+"      "+STR0006

cabec2 :=space(11)+;
			If( mv_par17 == 1,cLbLocal,SPACE(LEN(cLbLocal)))+space(6)+;
			If( mv_par16 == 1,cLbDescr,SPACE(LEN(cLbDescr)))+space(42)+;
			STR0007+"  "+;
			If( mv_par18 == 1,cLbEscal,SPACE(LEN(cLbEscal)))+space(3)+;
			If( mv_par18 == 1,cLbRedut,SPACE(10))+"  "+;
			If( mv_par18 == 1,cLbTol,SPACE(LEN(cLbTol)))

If ( mv_par16 == 2 ) .And. ( mv_par17 == 2 ) .And. ( mv_par18 == 2 )
	cabec2	:= ""
	lImpLin2	:= .F.
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//��������������������������������������������������������������Ŀ
//� Verifica a Ordem (informada na SetPrint)  ser utilizada      �
//����������������������������������������������������������������
dbSelectArea("QM2")
dbSetOrder(01)            

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cChaveQ := "QM2_FILIAL+QM2_INSTR+QM2_REVINV" 
		cQuery := "SELECT QM2_FILIAL,QM2_INSTR,QM2_REVINS,QM2_REVINV,QM2_VALDAF,QM2_FREQAF,"
		cQuery += "QM2_DEPTO,QM2_RESP,QM2_TIPO,QM2_FABR,QM2_STATUS,QM2_LAUDO,QM2_LOCAL,QM2_FLAG,"
		cQuery += "QM1_TIPO,QM1_DESCR "
		cQuery += "FROM "+RetSqlName("QM2")+" QM2, "					
		cQuery += RetSqlName("QM1")+" QM1 "
		cQuery += "WHERE "
		cQuery += "QM2.QM2_FILIAL = '"			+xFilial("QM2")+	"' AND "
		cQuery += "QM2.QM2_INSTR  BetWeen '"	+ mv_par01 +		"' AND '" + mv_par02 +			"' AND " 
		cQuery += "QM2.QM2_DEPTO BetWeen '"		+ mv_par05 +		"' AND '" + mv_par06 + 			"' AND " 
		cQuery += "QM2.QM2_TIPO BetWeen '"		+ mv_par12 +		"' AND '" + mv_par13 + 			"' AND " 
		cQuery += "QM2.QM2_FABR BetWeen '"		+ mv_par14 +		"' AND '" + mv_par15 + 			"' AND " 
		cQuery += "QM2.QM2_RESP BetWeen '"		+ mv_par21 +		"' AND '" + mv_par22 + 			"' AND " 
		cQuery += "QM1.QM1_TIPO =  QM2.QM2_TIPO  AND " 
		cQuery += "QM2.D_E_L_E_T_= ' ' "+ " AND " +"QM1.D_E_L_E_T_= ' ' "
		cQuery += "ORDER BY " + SqlOrder(cChaveQ)

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
		TcSetField("TRB","QM2_VALDAF","D",8,0)
		dbSelectArea( "TRB" )                 
		While !Eof()
			If TRB->QM2_FILIAL+TRB->QM2_INSTR <> cInstr
			   If QMTXSTAT(TRB->QM2_STATUS)
					If DtoS(TRB->QM2_VALDAF) >= DtoS(mv_par03) .and. DtoS(TRB->QM2_VALDAF) <= DtoS(mv_par04) 
						Aadd(aInstru,{TRB->QM2_FILIAL,TRB->QM2_INSTR,TRB->QM2_REVINS,TRB->QM2_REVINV,;
						TRB->QM2_VALDAF,TRB->QM2_FREQAF,TRB->QM2_DEPTO,TRB->QM2_RESP,;
						TRB->QM2_TIPO,TRB->QM2_FABR,TRB->QM2_STATUS,TRB->QM2_LAUDO,;
						TRB->QM2_LOCAL,TRB->QM1_DESCR})
					Endif		
				Endif
			Endif	
			cInstr := TRB->QM2_FILIAL+TRB->QM2_INSTR
			dbSkip()
		Enddo

		If aReturn[8] == 1 // Indice por Depto/Data
			aSort(aInstru,,,{|x,y| x[7]+DtoS(x[5]) < y[7]+DtoS(y[5])}) //Sorte da menor para maior data				
		ElseIf aReturn[8] == 2 // Indice por Data
			aSort(aInstru,,,{|x,y| x[5] < y[5]}) //Sorte da menor para maior data
		ElseIf aReturn[8] == 3 // Indice por Instrumento
			aSort(aInstru,,,{|x,y| x[1]+x[2] < y[1]+y[2]}) //Sorte por Instrumento
		ElseIf aReturn[8] == 4 // Indice por Familia
			aSort(aInstru,,,{|x,y| x[1]+x[9] < y[1]+y[9]}) //Sorte por Familia
		Endif	

	Else
#ENDIF
		cIndex := CriaTrab(nil,.F.) // nome de indice valido

		cKey	:= "QM2_FILIAL+QM2_INSTR+QM2_REVINV"

		cCond := 'QM2_FILIAL=="'+xFilial("QM2")+'".AND.QM2_INSTR >= "'+MV_PAR01+'".AND.QM2_INSTR <= "'+MV_PAR02+'"'
		cCond := cCond + '.AND.QM2_DEPTO  >= "'  +MV_PAR05+'".AND.QM2_DEPTO  <= "'+MV_PAR06+'"'	
		cCond := cCond + '.AND.QM2_TIPO   >= "'  +MV_PAR12+'".AND.QM2_TIPO   <= "'+MV_PAR13+'"'	
		cCond := cCond + '.AND.QM2_FABR   >= "'  +MV_PAR14+'".AND.QM2_FABR   <= "'+MV_PAR15+'"'			
		cCond := cCond + '.AND.QM2_RESP   >= "'  +MV_PAR21+'".AND.QM2_RESP   <= "'+MV_PAR22+'"'				
		// ������������������������������������������������������Ŀ
		// � A IndRegua cria o indice e o coloca como corrente    �
		// ��������������������������������������������������������
		IndRegua("QM2",cIndex,cKey,,cCond,STR0015) //Selecionando Registros
		nIndex := RetIndex("QM2") //Retorna o ultimo indice
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF	
		dbSetOrder(nIndex+1)	
		dbSelectArea("QM2")
		dbGoTop()
		While !Eof()
			If QM2->QM2_FILIAL+QM2->QM2_INSTR <> cInstr
				If QMTXSTAT(QM2->QM2_STATUS)
					If DTOS(QM2_VALDAF) >= DTOS(MV_PAR03) .AND. DTOS(QM2_VALDAF) <= DTOS(MV_PAR04)				
						Aadd(aInstru,{QM2->QM2_FILIAL,QM2->QM2_INSTR,QM2->QM2_REVINS,QM2->QM2_REVINV,;
							QM2->QM2_VALDAF,QM2->QM2_FREQAF,QM2->QM2_DEPTO,QM2->QM2_RESP,;
							QM2->QM2_TIPO,QM2->QM2_FABR,QM2->QM2_STATUS,QM2->QM2_LAUDO,QM2->QM2_LOCAL})
					Endif
				Endif
			Endif	
			cInstr := QM2->QM2_FILIAL+QM2->QM2_INSTR
			dbSkip()
		Enddo
		If aReturn[8] == 1 // Indice por Depto/Data
			aSort(aInstru,,,{|x,y| x[7]+DtoS(x[5]) < y[7]+DtoS(y[5])}) //Sorte da menor para maior data				
		ElseIf aReturn[8] == 2 // Indice por Data
			aSort(aInstru,,,{|x,y| x[5] < y[5]}) //Sorte da menor para maior data
		ElseIf aReturn[8] == 3 // Indice por Instrumento
			aSort(aInstru,,,{|x,y| x[1]+x[2] < y[1]+y[2]}) //Sorte por Instrumento
		ElseIf aReturn[8] == 4 // Indice por Instrumento
			aSort(aInstru,,,{|x,y| x[1]+x[9] < y[1]+y[9]}) //Sorte por Instrumento
		Endif	
		

#IFDEF TOP
	Endif
#ENDIF

SetRegua(RecCount())                  

While nTm <= Len(aInstru) 
	cFilialTRB	:= aInstru[nTm][1]
	TRB_INSTR	:= aInstru[nTm][2]
	TRB_REVINS	:= aInstru[nTm][3]
	TRB_REVINV	:= aInstru[nTm][4]
	TRB_VALDAF	:= aInstru[nTm][5]
	TRB_FREQAF	:= aInstru[nTm][6]
	TRB_DEPTO	:= aInstru[nTm][7]
	TRB_RESP	:= aInstru[nTm][8]
	TRB_TIPO	:= aInstru[nTm][9]
	TRB_FABR	:= aInstru[nTm][10]
	TRB_STATUS	:= aInstru[nTm][11]
	TRB_LAUDO	:= aInstru[nTm][12]
	TRB_LOCAL	:= aInstru[nTm][13]
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			TRB_TDESCR	:= aInstru[nTm][14]
		Endif	
	#ENDIF
		
	IncRegua()
	
	If lAbortPrint
		li := li + 1
      @li,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
		Exit
	EndIf

   //�����������������������������������������������������������������Ŀ
   //� Verifica se status do instrumento esta ativo                    �
   //�������������������������������������������������������������������
   If !QMTXSTAT(TRB_STATUS)
		nTm++   		
		dbskip()
		loop
   EndIf

	//�����������������������������������������������������������������Ŀ
	//� Verifico O.C. interno e externo                                 �
	//�������������������������������������������������������������������
	If mv_par07 == 1
		If ! Calibrador(0,mv_par08,mv_par09,mv_par10,mv_par11,TRB_INSTR,TRB_REVINS)
			nTm++
			dbSkip()
			Loop
		EndIf
	EndIf

	//�����������������������������������������������������������������Ŀ
	//� Verifico O.C. interno                                           �
	//�������������������������������������������������������������������
	If mv_par07 == 2
		If ! Calibrador(1,mv_par08,mv_par09,,,TRB_INSTR,TRB_REVINS)
			nTm++
			dbSkip()
			Loop
		Endif
	EndIf

	//�����������������������������������������������������������������Ŀ
	//� Verifico O.C. externo                                           �
	//�������������������������������������������������������������������
	If mv_par07 == 3
		If ! Calibrador(2,,,mv_par10,mv_par11,TRB_INSTR,TRB_REVINS)
			nTm++
			dbSkip()
			Loop
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Procura o departamento no SI3 - Centro de Custo.             �
	//����������������������������������������������������������������

	dbSelectArea("SI3")
	dbSetOrder(1)
	If dbSeek( xFilial("SI3") + TRB_DEPTO )
	    TRB_CUSTO := SI3->I3_CUSTO
	Else
	    nTm++
	Endif    

	#IFDEF TOP
		If TcSrvType() != "AS/400"
		Else
	#ENDIF			
			//��������������������������������������������������������������Ŀ
			//� Procura a descricao da familia no QM1                        �
			//����������������������������������������������������������������
			dbSelectArea( "QM1" )
			dbSetOrder( 1 )
			dbSeek( xFilial("QM1") + TRB_TIPO )
			TRB_TDESCR := QM1->QM1_DESCR
	#IFDEF TOP
		Endif
    #ENDIF

	TRB_DATCO := StrZero(Month(TRB_VALDAF),2) + "/"+ Str(YEAR(TRB_VALDAF),4)
	//�������������������������������������������������������������������������Ŀ
	//�Atribui indice a cChave (Departamento/Val.Afericao(Inteiro)/Val.Afericao)�
	//���������������������������������������������������������������������������

	If aReturn[8] == 1 .And. mv_par23 == 1
		If mv_par25 == 1 //Quebra Departamento e pagina
			If !Empty(cChave) //Primeira vez nao imprimir subtotal
				If (!TRB_DEPTO == cChave)
					MTR010Sub(@cChave,@nCntParc,@nCntTot)		
					cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
					lVez := .F.
				Endif	
			Endif	
			cChave := TRB_DEPTO
		Else
			lVez := .T.
		Endif
	ElseIf aReturn[8] == 2 .And. mv_par24 == 1
		If mv_par25 == 1 //Quebra Data completa e pagina
			If !Empty(cChave) //Primeira vez nao imprimir subtotal
				If (!DtoS(TRB_VALDAF) == cChave)
					MTR010Sub(@cChave,@nCntParc,@nCntTot)		
					cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
					lVez := .F.
				Endif	
			Endif	
			cChave := dtos(TRB_VALDAF)
		Else
			lVez := .T.
		Endif
	ElseIf aReturn[8] == 2 .And. mv_par24 == 2
		If mv_par25 == 1 //Quebra Data resumida e pagina
			If !Empty(cChave) //Primeira vez nao imprimir subtotal
				If (!TRB_DATCO == cChave)
					MTR010Sub(@cChave,@nCntParc,@nCntTot)		
					cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
					lVez := .F.
				Endif	
			Endif	
			cChave := StrZero(Month(TRB_VALDAF),2) + "/" + Str(YEAR(TRB_VALDAF),4)
		Else
			lVez := .T.
		Endif
	ElseIf aReturn[8] == 3  //Ordem por Instrumento
		If mv_par25 == 1 //Quebra Data resumida e pagina
			If !Empty(cChave) //Primeira vez nao imprimir subtotal
				If (!TRB_INSTR == cChave)
					MTR010Sub(@cChave,@nCntParc,@nCntTot)		
					cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
					lVez := .F.
				Endif	
			Endif	
			cChave := TRB_INSTR
		Else
			lVez := .T.
		Endif
	ElseIf aReturn[8] == 4  //Ordem por Familia
		If mv_par25 == 1 //Quebra Data resumida e pagina
			If !Empty(cChave) //Primeira vez nao imprimir subtotal
				If (!TRB_TIPO == cChave)
					MTR010Sub(@cChave,@nCntParc,@nCntTot)		
					cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
					lVez := .F.
				Endif	
			Endif	
			cChave := TRB_TIPO
		Else
			lVez := .T.
		Endif
		
	EndIf
	
	//�������������������������������������������������������������������������Ŀ
	//� Verifica a se deve dar subtotal - caso nao exista quebra por pagina		�
	//���������������������������������������������������������������������������
	If lVez
		MTR010Sub(@cChave,@nCntParc,@nCntTot)
	Endif

	lVez := .T.

	If  mv_par16 == 1 .or. mv_par17 == 1 .or.mv_par18 == 1  //Se imprime?   
		If li > 50
			cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
		EndIf
	Else
		If li > 55
			cabec(titulo,cabec1,"",nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
		EndIf
    Endif
	/*
   	       1         2         3         4         5         6         7         8         9         0         1         2         3
	012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	DEPTO      INSTRUMENTO       FAMILIA                              FABRICANTE       FREQ. VAL.CALIBR.       USUARIO   LAUDO
   	        LOCALIZACAO       DESCRICAO                                             DIAS  ESCALA            REDUTOR   TOLER. PROCESSO
	XXXXXXXXX  XXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXX                     XXXXXXXXXXXXXXXX 9999  99/99/99          XXXXXXXX  X
   	        XXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                         XXXXXXXXXXXXXXXX  XX        XXXXXXXXXX
	*/

	@ li,000 PSAY TRB_CUSTO
	@ li,011 PSAY TRB_INSTR
	@ li,029 PSAY TRB_TIPO
	@ li,050 PSAY TRB_FABR
	@ li,083 PSAY ALLTRIM(STR(TRB_FREQAF,4))
	If mv_par24 == 2
		cValDaf := StrZero(MONTH(TRB_VALDAF),2)+"/"+;
					  Str(YEAR (TRB_VALDAF),4)
	Else
		cValDaf := Dtoc(TRB_VALDAF)
	EndIf
	@ li,089 PSAY cValDaf

	SRA->(DbSetOrder(1))
	SRA->(DbSeek(xFilial("SRA")+TRB_RESP))
	If !SRA->(Eof())
		@ li,102 PSAY SRA->RA_APELIDO                 
	EndIf

	If TRB_LAUDO=="3"
	   @ li,117 PSAY Tabela("QA","APROV")
	Elseif TRB_LAUDO=="2"
	   @ li,117 PSAY Tabela("QA","APREST")
	ElseIf TRB_LAUDO=="1"
	   @ li,117 PSAY Tabela("QA","REPROV")
	Else                                    
		@ li,117 PSAY OemToAnsi(STR0014) //Nao Calibrado
	EndIf
	li++  

	If lImpLin2
		If mv_par16 == 1 .or. mv_par17 == 1 .or. mv_par18 == 1
			If li > 50
				cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
			EndIf
		Else
			If li > 55
				cabec(titulo,cabec1,"",nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
			EndIf
		Endif	

		@li,012 PSAY IIF(mv_par17 == 1, TRB_LOCAL, " ")
		@li,029 PSAY IIF(mv_par16 == 1, TRB_TDESCR, " ") //QM1_DESCR

		If mv_par18 == 1    
			// Pego o redutor do instrumento por escala
			dbSelectArea("QMR")
			dbSetOrder(1)
			If dbSeek(cFilialTRB+TRB_INSTR+TRB_REVINS)
				While ! Eof() .And. xFilial("QMR")+QMR->QMR_INSTR+QMR->QMR_REVINS == ;
					cFilialTRB+TRB_INSTR+TRB_REVINS
					If QMR->QMR_CAOBRI == "S"
						@li,089 PSAY QMR->QMR_ESCALA
						@li,107 PSAY QMR->QMR_REDUT
						@li,117 PSAY QMR->QMR_TOLPRO
						li++
						If  mv_par16 == 1 .or. mv_par17 == 1 .or.mv_par18 == 1  //Se imprime?   
							If li > 50
								cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
							EndIf
						Else
							If li > 55
								cabec(titulo,cabec1,"",nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
							EndIf
					    Endif
					EndIf						
					dbSkip()
				EndDo
			EndIf				
		Else
			li++			
		EndIf
	EndIf
	nCntParc++
	nCntTot++
	nTm++
EndDo

If Len(aInstru) > 0

	//��������������������������������������������������������������Ŀ
	//� Verifica a se deve dar subtotal                              �
	//����������������������������������������������������������������

	MTR010Sub(@cChave,@nCntParc,@nCntTot)

    If !lImpSub //Garantir impressao do ultimo subtotal
		li++
		If  mv_par16 == 1 .or. mv_par17 == 1 .or.mv_par18 == 1  //Se imprime?   
			If li > 50
				cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
			EndIf
		Else
			If li > 55
				cabec(titulo,cabec1,"",nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
			EndIf
		Endif
		@ li,010 PSAY OemToAnsi(STR0011)+Str(nCntParc,5)    	
    Endif
	
	li:= li+2

	If  mv_par16 == 1 .or. mv_par17 == 1 .or.mv_par18 == 1  //Se imprime?   
		If li > 50
			cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
		EndIf
	Else
		If li > 55
			cabec(titulo,cabec1,"",nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
		EndIf
	Endif

	@ li,010 PSAY OemToAnsi(STR0012)+Str(nCntTot,5) //Total........................:
Endif

//��������������������������������������������������������������Ŀ
//� Se a linha for 80, � porque nao foi impresso nem a 1� pag    �
//����������������������������������������������������������������
If li != 80
	 Roda( cbCont, cbTxt, cTamanho )
EndIf

Set Device To Screen

If File(cIndex+OrdBagExt())
	Set Filter To
	RetIndex("QM2")
	dbClearInd()
	FErase(cIndex+OrdBagExt())
	dbCloseArea()
Else	
	dbSelectArea("TRB")
	dbCloseArea()
	dbSelectArea("QM2")
	dbSetOrder(1)
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrdem)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
EndIf
MS_FLUSH()

Return(Nil)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR010SUB� Autor � Wanderley Goncalves   � Data � 24.06.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime subtotal                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTR010SUB()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � QMTR010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MTR010Sub(cChave,nCntParc,nCntTot)
If !Empty(cChave)
	If	(aReturn[8] == 1 .and. mv_par23 == 1 .and.;
			!(TRB_DEPTO == cChave)) .or.; // Por departamento com quebra
		(areturn[8] == 2 .and. mv_par24 == 1 .and.; // Por data cheia
			!(cchave == dtos(TRB_VALDAF))) .or.; 
		(areturn[8] == 2 .and. mv_par24 == 2 .and.; // Por data no formato MM/AAAA
			!(cchave == StrZero(Month(TRB_VALDAF),2)+ "/"+;
						Str(YEAR(TRB_VALDAF),4))) 
		li++
		If  mv_par16 == 1 .or. mv_par17 == 1 .or.mv_par18 == 1  //Se imprime?   
			If li > 50
				cabec(titulo,cabec1,cabec2,nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
			EndIf
		Else
			If li > 55
				cabec(titulo,cabec1,"",nomeprog,ctamanho,IIF(aReturn[4]==1,15,18))
			EndIf
    	Endif
		@ li,010 PSAY OemToAnsi(STR0011)+Str(nCntParc,5)	//Subtotal.....................:
		nCntParc := 0
		li:= li+2
		lImpSub := .T.
	Else
		lImpSub := .F.
	EndIf
Endif
//Atribui valores a cChave (Ordem de impressao)
If aReturn[8] == 1 .and. mv_par23 == 1
	cChave := TRB_DEPTO 
ElseIf areturn[8] == 2 .and. mv_par24 == 1
	cChave := dtos(TRB_VALDAF)
ElseIf areturn[8] == 2 .and. mv_par24 == 2
	cChave := StrZero(Month(TRB_VALDAF),2)+ "/"+Str(YEAR(TRB_VALDAF),4)
ElseIf areturn[8] == 3 
	cChave := TRB_INSTR
Endif

Return(Nil)