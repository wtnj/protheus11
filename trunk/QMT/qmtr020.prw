#INCLUDE "QMTR020.CH"
#INCLUDE "FIVEWIN.CH"

#DEFINE STRCOLUNA_1 "|             |                                       "
#DEFINE STRCOLUNA_2 "|             |            |                      "
#DEFINE STRCOLUNA_4 "|        |         |        |         |           "
#DEFINE STRCOLUNA_5 "|             |                                  |"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � QMTR020	� Autor � Alessandro B. Freire  � Data � 30.03.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ficha de Calibra��o										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � QMTR020(void)											  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
�������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.			  ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data	� BOPS �  Motivo da Alteracao 					  ���
�������������������������������������������������������������������������Ĵ��
���Antonio     �19/07/99�22057 � Parametro de, ate para Status.           ���
���Antonio     �30/01/00�      � Rodap� de data/hora por instrumento.     ���
���Antonio     �02/02/00�      � Ajuste de lRodaImp e inclus�o de cChvQMK.��� 
���Denis M.    �13/12/00�      � Inclusao do MV_PAR21 na pergunta QMR020. ���
���            �        �      � Esse parametro permiti ao usuario impri- ��� 
���            �        �      � mir Fichas de Calibracao com status Atua-���
���            �        �      � liza "NAO".                              ���
���Denis M.    �05/04/02�014517� Impressao do Nome/Numero Procedimento ca-���
���            �        �      � dastrado na familia do instrumento qdo o ��� 
���            �        �      � mesmo nao estiver informado no cadastro  ���
���            �        �      � de procedimentos de calibracao(QA5).     ���
���Denis M.    �07/01/03�Melhor� Pegar sempre a ultima revisao das escalas���
���            �        �      � para impressao da ficha de calibracao.JJ ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function QMTR020()
//��������������������������������������������������������������Ŀ
//� Define Variaveis 														  �
//����������������������������������������������������������������
Local cDesc1		:=OemToAnsi( STR0001 ) // "Este programa ir� emitir a rela��o de"
Local cDesc2		:=OemToAnsi( STR0002 ) // "Fichas de Calibra��o de acordo com os"
Local cDesc3		:=OemToAnsi( STR0003 ) // "Par�metros selecionados."
Local cString		:="QM2"
Local wnrel

Private cTitulo   := OemToAnsi(STR0004) // "FICHA DE CALIBRACAO"
Private Cabec1    := ""
Private Cabec2    := ""
Private aReturn   := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 1, 2, 1, "",1 } // "Zebrado"#"Administra��o"
Private cNomeProg :="QMTR020"
Private nLastKey  := 0
Private cPerg	   :="QMR020"
Private cTamanho  := "M"
Private cImpCbInst := ""
Private cOldInst   := ""

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 							 �
//����������������������������������������������������������������
pergunte("QMR020",.F.)
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros									�
//� mv_par01				// Instrumento Inicial							� 
//� mv_par02				// Instrumento Final 							�
//� mv_par03				// Periodo Inicial								�
//� mv_par04				// Periodo Final								�
//� mv_par05				// Departamento Inicial 						�
//� mv_par06				// Departamento Final							�
//� mv_par07				// Orgao Calibrador Todos/Interno/Externo       �
//� mv_par08				// Org.Calib.Intr.Inicial  					  	�
//� mv_par09				// Org.Calib.Intr.Final    					    �
//� mv_par10				// Org.Calib.Extr.Inicial  					    �
//� mv_par11				// Org.Calib.Extr.Final    					    �
//� mv_par12				// Familia Inicial                          	�
//� mv_par13				// Familia Final 								�
//� mv_par14				// Fabricante Inicial							�
//� mv_par15				// Fabricante Final								�
//� mv_par16				// Status de  		                       		�
//� mv_par17                // Status ate                               	�
//� mv_par18				// Usu�rio Inicial 								�
//� mv_par19				// Usu�rio Final 								�
//� mv_par20				// Quebra p/ Instrumento Sim/Nao 			  	�
//���������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT 						 �
//����������������������������������������������������������������
wnrel := "QMTR020"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| r020Imp(@lEnd,wnRel,cString)},cTitulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � r020Imp  � Autor � Alessandro B. Freire  � Data � 30.03.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ficha de Calibra��o										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � QMTR020(void)											  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
�������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.			  ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data	� BOPS �  Motivo da Alteracao 					  ���
�������������������������������������������������������������������������Ĵ��
���Iuri Seto   �25/07/00�      � Inclusao do Tipo de Calibracao Relogio.  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function r020Imp( lEnd, wnRel, cString )

Local nNumMed := 0
Local cChave  := ""
Local cChave2 := ""
Local nEspec  := 0
Local nToler  := 0
Local lImprime:= .F.
Local cbCont  := 0
Local cbTxt   := ""
Local lRodaImp:= .F.
Local cRevEsc := ""
Local cInstr  := ""
Local cChvQMK := ""
Local cChvQMG := ""
Local cEscala := ""
Local cInstrCab := ""
Local cFaixa  := "",cStatus := ""
Local cRevQMA := "00"
Local cTipTol := ""
Local cKey		
Local cQuery := ""

Private TRB_FILIAL
Private TRB_INSTR
Private	TRB_REVINS
Private	TRB_REVINV
Private	TRB_VALDAF
Private	TRB_FREQAF
Private	TRB_TIPO
Private	TRB_RESP
Private	TRB_DEPTO	
Private	TRB_FABR	
Private	TRB_STATUS	
Private	TRB_LOCAL	
Private	TRB_LAUDO	
Private	TRB_NSEFAB	
Private cCabec1 := ""
Private cCabec2 := ""
Private cCabec3 := ""
Private cCabec4 := ""
Private lFirst  := .F.
Private cIndex  := ""	
Private nLimite := 132
Private cUniMed := ""
m_pag := 1
li 	:= 80

QM3->(dbSetOrder(1))
dbSelectArea("QM2")
dbSetOrder(01)
#IFDEF TOP
	If TcSrvType() != "AS/400"                             
		cQuery := "SELECT QM2_FILIAL,QM2_INSTR,QM2_REVINS,QM2_REVINV,QM2_VALDAF,QM2_FREQAF,QM2_NSEFAB,"
		cQuery += "QM2_DEPTO,QM2_RESP,QM2_TIPO,QM2_FABR,QM2_STATUS,QM2_LAUDO,QM2_LOCAL,QM2_FLAG,"
		cQuery += "QM1_FILIAL,QM1_TIPO,QM1_DESCR "
		cQuery += "FROM "+RetSqlName("QM2")+" QM2, "					
		cQuery += RetSqlName("QM1")+" QM1 "
		cQuery += "WHERE "
		cQuery += "QM2.QM2_FILIAL = '"			+xFilial("QM2")+	"' AND "
		cQuery += "QM2.QM2_INSTR  BetWeen '"	+ mv_par01 +		"' AND '" + mv_par02 +			"' AND " 
		cQuery += "QM2.QM2_DEPTO BetWeen '"		+ mv_par05 +		"' AND '" + mv_par06 + 			"' AND " 
		cQuery += "QM2.QM2_TIPO BetWeen '"		+ mv_par12 +		"' AND '" + mv_par13 + 			"' AND " 
		cQuery += "QM2.QM2_FABR BetWeen '"		+ mv_par14 +		"' AND '" + mv_par15 + 			"' AND " 
		cQuery += "QM2.QM2_STATUS BetWeen '"	+ mv_par16 +		"' AND '" + mv_par17 + 			"' AND " 
		cQuery += "QM2.QM2_RESP BetWeen '"		+ mv_par18 +		"' AND '" + mv_par19 + 			"' AND " 
		cQuery += "QM2.QM2_FLAG = '1' AND " 
		cQuery += "QM1.QM1_TIPO =  QM2.QM2_TIPO  AND " 
		cQuery += "QM2.D_E_L_E_T_= ' ' "+ " AND " +"QM1.D_E_L_E_T_= ' ' "
		If aReturn[8] == 1 
  	       cChave := "QM2_FILIAL+QM2_INSTR+QM2_REVINV"
		   cQuery += "ORDER BY " + SqlOrder(cChave)
		Endif	

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
		TcSetField("TRB","QM2_VALDAF","D",8,0)
		dbSelectArea( "TRB" )
    Else
#ENDIF    
		cIndex := CriaTrab(nil,.F.) // nome de indice valido
		cKey   := "QM2->QM2_FILIAL+QM2->QM2_INSTR+QM2->QM2_REVINV"			
		cQuery := 'QM2_FILIAL=="'+xFilial("QM2")+'".AND.QM2_INSTR >= "'+MV_PAR01+'".AND.QM2_INSTR <= "'+MV_PAR02+'"'
		cQuery := cQuery + '.AND.QM2_DEPTO  >= "'  +MV_PAR05+'".AND.QM2_DEPTO  <= "'+MV_PAR06+'"'	
		cQuery := cQuery + '.AND.QM2_TIPO   >= "'  +MV_PAR12+'".AND.QM2_TIPO   <= "'+MV_PAR13+'"'	
		cQuery := cQuery + '.AND.QM2_FABR   >= "'  +MV_PAR14+'".AND.QM2_FABR   <= "'+MV_PAR15+'"'			
		cQuery := cQuery + '.AND.QM2_STATUS >= "'  +MV_PAR16+'".AND.QM2_STATUS <= "'+MV_PAR17+'"'				
		cQuery := cQuery + '.AND.QM2_FLAG == "1"'				
		cQuery := cQuery + '.AND.QM2_RESP   >= "'  +MV_PAR18+'".AND.QM2_RESP   <= "'+MV_PAR19+'"'				
	// ������������������������������������������������������Ŀ
	// � A IndRegua cria o indice e o coloca como corrente    �
	// ��������������������������������������������������������
		IndRegua("QM2",cIndex,cKey,,cQuery,STR0015) //Selecionando Registros
		nIndex := RetIndex("QM2") //Retorna o ultimo indice
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF			
		dbSetOrder(nIndex+1)	
		dbSelectArea("QM2")
		dbGoTop()
#IFDEF TOP
	Endif
#ENDIF			

//�����������������������������������������������������������������Ŀ
//� Loop at� o �ltimo instrumento selecionado.					    �
//� Loop do instrumento.											�
//�������������������������������������������������������������������
SetRegua(RecCount())
lAbortPrint := .F.
While !Eof()
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			TRB_FILIAL	:= TRB->QM2_FILIAL
			TRB_INSTR	:= TRB->QM2_INSTR
			TRB_REVINS	:= TRB->QM2_REVINS
			TRB_REVINV	:= TRB->QM2_REVINV
			TRB_VALDAF	:= TRB->QM2_VALDAF
			TRB_FREQAF	:= TRB->QM2_FREQAF						
			TRB_TIPO	:= TRB->QM2_TIPO
			TRB_RESP	:= TRB->QM2_RESP	
			TRB_DEPTO	:= TRB->QM2_DEPTO
			TRB_FABR	:= TRB->QM2_FABR	
			TRB_STATUS	:= TRB->QM2_STATUS
			TRB_LOCAL	:= TRB->QM2_LOCAL
			TRB_LAUDO	:= TRB->QM2_LAUDO		
			TRB_NSEFAB	:= TRB->QM2_NSEFAB	
		Else	
	#ENDIF
			TRB_FILIAL	:= QM2->QM2_FILIAL	
			TRB_INSTR	:= QM2->QM2_INSTR
			TRB_REVINS	:= QM2->QM2_REVINS
			TRB_REVINV	:= QM2->QM2_REVINV
			TRB_VALDAF	:= QM2->QM2_VALDAF
			TRB_FREQAF	:= QM2->QM2_FREQAF						
			TRB_TIPO	:= QM2->QM2_TIPO
			TRB_RESP	:= QM2->QM2_RESP	
			TRB_DEPTO	:= QM2->QM2_DEPTO
			TRB_FABR	:= QM2->QM2_FABR	
			TRB_STATUS	:= QM2->QM2_STATUS
			TRB_LOCAL	:= QM2->QM2_LOCAL		
			TRB_LAUDO	:= QM2->QM2_LAUDO  
			TRB_NSEFAB	:= QM2->QM2_NSEFAB			
	#IFDEF TOP
		Endif
	#ENDIF               
	
	IncRegua()
	If lAbortPrint
		Exit
	EndIf
	
	//�����������������������������������������������������������������Ŀ
	//�����������������������������������������������������������������Ŀ
	//� Se n�o est� entre as validades informadas n�o imprime.		    �
	//�������������������������������������������������������������������
	If ( TRB_VALDAF < mv_par03 ) .Or. ;
		( TRB_VALDAF > mv_par04 )
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea("TRB")
			Else
		#ENDIF
				dbSelectArea("QM2")
		#IFDEF TOP
			Endif
		#ENDIF	
		dbSkip()
		Loop
	EndIf
	
	//�����������������������������������������������������������������Ŀ
	//� Verifico O.C. interno e externo                                 �
	//�������������������������������������������������������������������
	If mv_par07 == 1
		If ! Calibrador(0,mv_par08,mv_par09,mv_par10,mv_par11,TRB_INSTR,TRB_REVINS)
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("TRB")
				Else
			#ENDIF
					dbSelectArea("QM2")
			#IFDEF TOP
				Endif
			#ENDIF	
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//�����������������������������������������������������������������Ŀ
	//� Verifico O.C. interno                                           �
	//�������������������������������������������������������������������
	If mv_par07 == 2
		If ! Calibrador(1,mv_par08,mv_par09,,,TRB_INSTR,TRB_REVINS)
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("TRB")
				Else
			#ENDIF
					dbSelectArea("QM2")
			#IFDEF TOP
				Endif
			#ENDIF	
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//�����������������������������������������������������������������Ŀ
	//� Verifico O.C. externo                                           �
	//�������������������������������������������������������������������
	If mv_par07 == 3
		If ! Calibrador(2,,,mv_par10,mv_par11,TRB_INSTR,TRB_REVINS)
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("TRB")
				Else
			#ENDIF
					dbSelectArea("QM2")
			#IFDEF TOP
				Endif
			#ENDIF	
			dbSkip()
			Loop
		EndIf
	EndIf
	
	
	//���������������������������������������������������������������������������Ŀ
	//� Verifica se status do instrumento esta com atualiza ativo,dependendo do pa� 
	//� rametro MV_PAR21.														  �
	//�����������������������������������������������������������������������������
    If mv_par21 == 2
	   If !QMTXSTAT(TRB_STATUS)
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("TRB")
				Else
			#ENDIF
					dbSelectArea("QM2")
			#IFDEF TOP
				Endif
			#ENDIF	
			dbskip()
			loop
	   EndIf
	Endif   
	
	
	SRA->(dbSetOrder(1))
	SRA->(dbSeek(xFilial("SRA")+TRB_RESP))
	cInstrCab := ""

    QMP->(dbSetOrder(1))
    QMP->(dbSeek(xFilial("QMP")+TRB_STATUS))
    cStatus := QMP->QMP_DESCR
	//�����������������������������������������������������������������Ŀ
	//� Define o cabe�alho do instrumento.       						�
	//�������������������������������������������������������������������
	Cabec1 := ""
	Cabec2 := ""
	
	cCabec1 := STR0007 + TRB_INSTR         + "          " + ;	// "INSTRUMENTO..: "
	STR0008 + TRB_DEPTO         + "          " + ;				// "DEPARTAMENTO.: "
	STR0009 + Str(TRB_FREQAF,4) + OemToAnsi(STR0037) + ;		// "FREQ.AFERICAO: "
	STR0010 + DtoC(TRB_VALDAF)									// "VALIDADE.....: "
	
	cCabec2 := STR0011 + Mtr020Proc(TRB_TIPO)					// "PROCEDIMENTO.: "
	
	cCabec3 := STR0012 + TRB_LOCAL + "          " + ;			// "LOCALIZACAO"
	STR0013 + TRB_NSEFAB+ "    " + ;							// "No. DE SERIE"
	Upper(TitSx3("QM2_RESP")[1])+" : " + SRA->RA_APELIDO 		// TRB_RESP
	
	cCabec4 := OemToAnsi(STR0036) + TRIM(UPPER(SubStr(cUsuario,7,15))) + "             " +;      // ""EMISSOR......: "
 	           Trim(Upper(TitSx3("QM2_STATUS")[1]))  + ".......: " +;
	           Trim(Upper(cStatus)) + "              "+;
	           Alltrim(Upper(QaTit("QM2_TIPO",7)))+"......: "+TRB_TIPO // FAMILIA
	
	//�����������������������������������������������������������������Ŀ
	//� Procura as escalas amarradas a Familia							�
	//�������������������������������������������������������������������
	dbSelectArea("QMK")
	dbSetOrder(1)
	If dbSeek( xFilial("QMK") + TRB_TIPO )
		cChvQMK := QMK->QMK_TIPO+QMK->QMK_REVTIP
	Else
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea("TRB")
			Else
		#ENDIF
				dbSelectArea("QM2")
		#IFDEF TOP
			Endif
		#ENDIF	
		dbSkip()
		Loop
	EndIf
	
	//�����������������������������������������������������������������Ŀ
	//� Quebra por instrumento.                                         �
	//�������������������������������������������������������������������
	cImpCbInst := TRB_INSTR + TRB_REVINS
	
	//�����������������������������������������������������������������Ŀ
	//� Loop das escalas.											    �
	//�������������������������������������������������������������������
	While QMK->(!Eof()) .And. xFilial("QMK") == QMK->QMK_FILIAL ;
		.And. QMK->QMK_TIPO+QMK->QMK_REVTIP == cChvQMK
		
		lImprime := IIF( mv_par20 == 2, .T., .F. )
		//�����������������������������������������������������������������Ŀ
		//� Pega o numero de medicoes no cadastro de escalas. 			    �
		//�������������������������������������������������������������������
		QM9->(dbSetOrder(1))
		QM9->(dbSeek(xFilial("QM9")+QMK->QMK_ESCALA))
		nNumMed := QM9->QM9_NROMED
		
		//�����������������������������������������������������������������Ŀ
		//� Verifica quais escalas devem ser impressas					    �
		//�������������������������������������������������������������������
		QMR->(dbSetOrder(1))
		QMR->(dbSeek(xFilial("QMR")+TRB_INSTR+TRB_REVINS+QMK->QMK_ESCALA))
		
		cEscala := ""
		
		If QMR->QMR_CAOBRI == "S"
			
			//����������������������������������������������������Ŀ
			//� INSTRUMENTOS COM TIPO DE AFERICAO 1,2,3 		   �
			//������������������������������������������������������
			If QM9->QM9_TIPAFE $ "1|2|3|9"
				
				//��������������������������������������������������������������Ŀ
				//� Procura os pontos amarrados as escalas.					     �
				//����������������������������������������������������������������
				dbSelectArea("QMC")  // Padrao / Escalas
				dbSetOrder(1)
				QMC->(dbSeek(xFilial("QMC")+QMK->QMK_ESCALA+;
				Inverte(QM9->QM9_REVESC)) )
				
				cRevEsc := QMC->QMC_REVESC
				
				While QMC->(!Eof()) .And. xFilial("QMC") == QMC->QMC_FILIAL ;
					.And. ( QMC->QMC_REVESC == cRevEsc ) ;
					.And. ( QMC->QMC_ESCALA == QMK->QMK_ESCALA )
					
					//��������������������������������������������������������Ŀ
					//� Posiciona no QM3: Pontos.               	       	   �
					//����������������������������������������������������������
					dbSelectArea("QM3") // Padrao / Calibracao
					dbSetOrder(1)
					QM3->(dbSeek( xFilial("QM3") + QMC->QMC_PADRAO ))
					SAH->(dbSetOrder(1))
					SAH->(dbSeek(xFilial("SAH")+QM3->QM3_UNIMED))
					
					lRodaImp := .T.
					
					If cInstrCab <> TRB_INSTR + TRB_REVINS
						r020Inst()
						cInstrCab := TRB_INSTR + TRB_REVINS
					EndIf
					
					If !(QMK->QMK_FILIAL+QMK->QMK_ESCALA == cEscala)
						
						//��������������������������������������������������������Ŀ
						//� Cabe�alho das escalas.	         			           �
						//����������������������������������������������������������
						If QM9->QM9_TIPAFE$"1"
							r020Escala(1)  // com uma coluna.
						ElseIf QM9->QM9_TIPAFE$"2"
							r020Escala(2)  // com duas colunas.
						ElseIf QM9->QM9_TIPAFE$"3|9"
							r020Escala(4)
						EndIf
						
						cEscala := QMK->QMK_FILIAL+QMK->QMK_ESCALA
					EndIf
					
					If QM3->QM3_TIPPAD != "A" .And. QM9->QM9_NROMED > 0
						
						//���������������������������������������������������������Ŀ
						//� 1� Linha de impress�o para padr�o com  medi��es         �
						//� com valores.                                            �
						//�����������������������������������������������������������
						li++
						//�������������������������������������������Ŀ
						//� Faz a troca de p�g. se necess�rio.        �
						//���������������������������������������������
					    r020Cab(.T.) // Imprime linha na pr�x. p�g.
						
//             10       20         30        40        50        60        70        80        90        100       110       120
//   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//	"|Padrao          | Rev | Especificado | Tol.Minima | Tol.Maxima |Tp.Calc.Tol| Valor       | Obs.                               |"
//	"|Padrao          | Rev | Especificado | Tol.Minima | Tol.Maxima |Tp.Calc.Tol| Vlr Inicial | Vlr Final  | Obs.                  |"												
//  "|                |     |              |            |            |           |  Valor Inicial   |   Valor Final    |              |"
//  "|Padrao          | Rev | Especificado | Tol.Minima | Tol.Maxima |Tp.Calc.Tol| Subida | Descida | Subida | Descida |Obs.          |"
																																								
						@li, 00 PSAY "|"
						@li, 01 PSAY QM3->QM3_PADRAO
						@li, 17 PSAY "|"
						@li, 19 PSAY QM3->QM3_REVPAD
						@li, 23 PSAY "|"
						@li, 24 PSAY PadR(AllTrim(QM3->QM3_ESPEC),10) // "Especificado: "
						@li, 38 PSAY "|"
						@li, 39 PSAY PadR(AllTrim(QMC->QMC_TOLMIN),10) // "Toler.Minima: "                     
						@li, 51 PSAY "|"						
						@li, 52 PSAY PadR(AllTrim(QMC->QMC_TOLER),10) // "Toler.Maxima: "						
						@li, 64 PSAY "|"												
						@li, 65 PSAY SubStr(QMTCBox("QMC_TIPTOL",QMC->QMC_TIPTOL),5,10) // "Tip.Calc.Tolerancia
//			10		  20        30        40        50        60        70		  80        90        100       110       120								
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//|                |     |              |            |            |           |             |                                       "						
						If QM9->QM9_TIPAFE$"1"
							@li, 76 PSAY STRCOLUNA_1  // "|                                    |"
						ElseIf QM9->QM9_TIPAFE$"2"
							@li, 76 PSAY STRCOLUNA_2 // "|             |            |                      "
						ElseIf QM9 ->QM9_TIPAFE$"3|9"
							@li, 76 PSAY STRCOLUNA_4 // "|                     |                     |" //63
						EndIf
						@li, 131 PSAY "|"
						
						li++
						If li > 55
							@li,00 PSAY Repl( "-", nLimite )
							li := 66 // For�a a quebra de p�g.
						EndIf
						//�������������������������������������������Ŀ
						//� Faz a troca de p�g. se necess�rio.        �
						//���������������������������������������������
						r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
						@ li,00 PSAY Repl( "-", nLimite )
						//����������������������������������������������������Ŀ
						//� A fun��o r020Medic  monta as linhas com as colunas �
						//�  em branco para preenchimento pelo usu�rio.        �
						//������������������������������������������������������
						If QM9->QM9_TIPAFE$"1"
							r020Medic( nNumMed -1, 76 , STRCOLUNA_1)
						ElseIf QM9->QM9_TIPAFE$"2"
							r020Medic( nNumMed -1, 76 , STRCOLUNA_2)
						ElseIf QM9->QM9_TIPAFE$"3|9"
							r020Medic( nNumMed -1, 76, STRCOLUNA_4)
						EndIf
						
					ElseIf QM9->QM9_NROMED == 0   //COLETA == "N"
						
						//����������������������������������������������������Ŀ
						//� Trata laborat�rios externos.                       �
						//������������������������������������������������������
						r020MedExt()
						
					Else
						
						//�������������������������������������������������������Ŀ
						//� Imprime a linha para atributos.                       �
						//���������������������������������������������������������
						If QM9->QM9_TIPAFE$"1" // 1 Coluna
							r020Atrib( 1 ) // "|               |              | [  ] APROVADO                       "
						ElseIf QM9->QM9_TIPAFE$"2"  // 2 Colunas
							r020Atrib(2 ) //	"|               |              | [  ] APROVADO       | [  ] REPROVADO"
						ElseIf QM9->QM9_TIPAFE$"3|9" // 4 Colunas
							r020Atrib(4 ) //	"|               |              | [  ] APROVADO       | [  ] REPROVADO"
						EndIf
						
					EndIf
					
					dbSelectArea( "QMC" )
					
					QMC->(dbSkip())
					
				EndDo
				
			ElseIf QM9->QM9_TIPAFE $ "5"
				dbSelectArea("QM9")				
				If xFilial("QM9")+QM9->QM9_ESCALA == QM9->QM9_FILIAL+QMK->QMK_ESCALA 
					//Pega sempre a ultima revisao da escala
					cRevQMA := QM9->QM9_REVESC	                      
				Endif		
				//������������������������������������������������������Ŀ
				//� INSTRUMENTOS COM TIPO DE AFERICAO 5 - SOMA.          �
				//��������������������������������������������������������
				dbSelectArea( "QMA" )
				dbSetOrder(1)
				dbSeek( xFilial("QMA") + QMK->QMK_ESCALA + cRevQMA )
				cChvQMA := QMA->QMA_ESCALA+QMA->QMA_REVESC
				
				//�����������������������������������������������������������Ŀ
				//� Posiciona no QM3: Pontos.               	         	  �
				//�������������������������������������������������������������
				QM3->(dbSeek( xFilial("QM3") + QMA->QMA_PADRAO ))
				SAH->(dbSetOrder(1))
				SAH->(dbSeek(xFilial("SAH")+QM3->QM3_UNIMED))
				
				lRodaImp := .T.
				
				If cInstrCab <> TRB_INSTR + TRB_REVINS
					r020Inst()
					cInstrCab := TRB_INSTR + TRB_REVINS
				EndIf
				
				//���������������������������������������������������������Ŀ
				//� Cabe�alho das escalas.                                  �
				//�����������������������������������������������������������
				r020Escala(2) // 2 Colunas.
				
				While QMA->(!Eof()) ;
					.And.  QMA->QMA_ESCALA+QMA->QMA_REVESC == cChvQMA ;
					.And. QMA->QMA_FILIAL == xFilial("QMA")
					
					//�������������������������������������������Ŀ
					//� Faz a troca de p�g. se necess�rio.        �
					//���������������������������������������������
					r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
					
					cChvFaixa := QMA->QMA_ESCALA +QMA->QMA_REVESC + QMA->QMA_FAIXA
					nToler    := 0
					nEspec    := 0
					nTolMin	  := 0	
					
					While QMA->QMA_ESCALA+QMA->QMA_REVESC+QMA->QMA_FAIXA == cChvFaixa ;
						.And.	QMA->QMA_FILIAL == xFilial("QMA") ;
						.And. !QMA->(EOF())
						
						//���������������������������������������������������������Ŀ
						//� Reposiciona o QM3 para cada reg em QMA. O 1� � desnec...�
						//�����������������������������������������������������������
						QM3->(dbSeek( xFilial("QM3") + QMA->QMA_PADRAO ))
						
						If !QM3->(Found())  // s� pra garantir...
							QMA->(dbSkip())
							Loop
						EndIf
						
						If QM3->QM3_TIPPAD == "A"
							Exit
						Else
							li++
							//�������������������������������������������Ŀ
							//� Faz a troca de p�g. se necess�rio.        �
							//���������������������������������������������
						    r020Cab(.T.) // Imprime linha na pr�x. p�g.
							
							@li, 00 PSAY "|"
							@li, 01 PSAY QM3->QM3_PADRAO
							@li, 17 PSAY "|"
							@li, 19 PSAY QM3->QM3_REVPAD
							@li, 23 PSAY "|"
							@li, 24 PSAY PadR(AllTrim(QM3->QM3_ESPEC),10) // "Especificado: "
							@li, 38 PSAY "|"
							@li, 39 PSAY PadR(AllTrim(QMA->QMA_TOLMIN),10) // "Tol.Minima "
							@li, 51 PSAY "|"
							@li, 52 PSAY PadR(AllTrim(QMA->QMA_TOLER),10) // "Tol.Maxima "
							@li, 64 PSAY "|"
							@li, 65 PSAY SubStr(QMTCBox("QMA_TIPTOL",QMA->QMA_TIPTOL),5,10)
							@li, 76 PSAY "|XXXXXXXXXXXXX|XXXXXXXXXXXX|"
							@li,131 PSAY "|"
							li++
							If li > 55
								@li,00 PSAY Repl( "-", nLimite )
								li := 66 // For�a a quebra de p�g.
							EndIf
							//�������������������������������������������Ŀ
							//� Faz a troca de p�g. se necess�rio.        �
							//���������������������������������������������
							r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
							@ li,00 PSAY Repl( "-", nLimite )
							
							cFaixa := QMA->QMA_FAIXA
							nEspec += SuperVal( QM3->QM3_ESPEC )
							nToler := IIF( nToler > SuperVal(QMA->QMA_TOLER)	,;
							nToler					,;
							SuperVal(QMA->QMA_TOLER) )
						
							nTolMin := IIF( nTolMin > SuperVal(QMA->QMA_TOLMIN)	,;
							nTolMin					,;
							SuperVal(QMA->QMA_TOLMIN) )
							cTipTol := QMA->QMA_TIPTOL
						EndIf
						
						
						QMA->(dbSkip())
					EndDo
					
					//���������������������������������������������������������Ŀ
					//� Para QM3_TIPPAD == "A" o looping anterior ter� que      �
					//� acontecer necessariamente apenas 1 vez, sendo v�lido    �
					//� testar o atributo pelo QM3.                             �
					//�����������������������������������������������������������
					If QM9->QM9_NROMED > 0  ;
						.And.  QM3->QM3_TIPPAD != "A"   //COLETA != "N"
						
						//���������������������������������������������������������Ŀ
						//� 1� Linha de impress�o para padr�o com  medi��es         �
						//� com valores.                                            �
						//�����������������������������������������������������������
						li++
						//�������������������������������������������Ŀ
						//� Faz a troca de p�g. se necess�rio.        �
						//���������������������������������������������
					    r020Cab(.T.) // Imprime linha na pr�x. p�g.
						@li, 00 PSAY "|"
						@li, 01 PSAY cFaixa
						@li, 16 PSAY "|"
						@li, 22 PSAY "|"
						@li, 24 PSAY  PadR(AllTrim(Str(nEspec)),10)
						@li, 37 PSAY "|"
						@li, 39 PSAY  PadR(AllTrim(Str(nTolMin)),10)
						@li, 50 PSAY "|"
						@li, 52 PSAY  PadR(AllTrim(Str(nToler)),10)	
						@li, 63 PSAY "|"											
						@li, 64 PSAY SubStr(QMTCBox("QMA_TIPTOL",cTipTol),5,10) 
						@li, 75 PSAY STRCOLUNA_2 // "|                     |                     |"
						@li,132 PSAY "|"
						li++
						If li > 55
							@li,00 PSAY Repl( "-", nLimite )
							li := 66 // For�a a quebra de p�g.
						EndIf
						//�������������������������������������������Ŀ
						//� Faz a troca de p�g. se necess�rio.        �
						//���������������������������������������������
						r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
						@ li,00 PSAY Repl( "-", nLimite )
						//���������������������������������������������������Ŀ
						//� A fun��o r020Medic monta as linhas com as colunas �
						//�  em branco para preenchimento pelo usu�rio.       �
						//�����������������������������������������������������
						r020Medic( nNumMed - 1, 76, STRCOLUNA_2)
						
					ElseIf QM9->QM9_NROMED == 0    //COLETA == "N"
						
						//����������������������������������������������������Ŀ
						//� Trata laborat�rios externos.                       �
						//������������������������������������������������������
						r020MedExt()
						
					ElseIf QM3->QM3_TIPPAD = "A"
						//����������������������������������������������������Ŀ
						//� Imprime a linha para atributos.                    �
						//������������������������������������������������������
						r020Atrib(2 ) //	"|               |              | [  ] APROVADO       | [  ] REPROVADO"
						QMA->(dbSkip())
					EndIf
					
				EndDo
				
				
			ElseIf  QM9->QM9_TIPAFE$"4|8"
				
				//������������������������������������������������������������Ŀ
				//� INSTRUMENTOS COM TIPO DE AFERICAO - 3                      �
				//��������������������������������������������������������������
				dbSelectArea( "QMG" )
				dbSetOrder(1)
				dbSeek( xFilial("QMG") + TRB_INSTR + TRB_REVINS )
				cChvQMG := QMG->QMG_INSTR + QMG->QMG_REVINS
				cEscala := ""
				
				While QMG->(!Eof()) .And. QMG->QMG_INSTR + QMG->QMG_REVINS == cChvQMG ;
					.And.  xFilial("QMG") == QMG->QMG_FILIAL
					
					SAH->(dbSetOrder(1))
					SAH->(dbSeek(xFilial("SAH")+QMG->QMG_UNIMED))
					cUniMed := SAH->AH_UMRES 

					If lFirst
					   r020Cab(.T.)
					Endif   
  				    lFirst := .T.
					If cInstrCab <> TRB_INSTR + TRB_REVINS
						r020Inst()
						cInstrCab := TRB_INSTR + TRB_REVINS
					EndIf
					
					If !(QMK->QMK_ESCALA ==  cEscala)
						//��������������������������������������������������������Ŀ
						//� Constr�i o cabe�alho dos padr�es.		       	       �
						//����������������������������������������������������������
						r020EscQMG()
						cEscala := QMK->QMK_ESCALA
					EndIf
					
					lRodaImp := .T.
					
					If QMG->QMG_TIPCAL != "A" .And. QM9->QM9_NROMED > 0
						//���������������������������������������������������������Ŀ
						//� 1� Linha de impress�o para padr�o com  medi��es         �
						//� com valores.                                            �
						//�����������������������������������������������������������
						li++
						//�������������������������������������������Ŀ
						//� Faz a troca de p�g. se necess�rio.        �
						//���������������������������������������������
						//r020Cab(.T.) // Imprime linha na pr�x. p�g.
						//           1         2         3         4         5         6         7         8         9         10        11
					    // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
					    //"|Ponto           | Especificado | LIE        | LSE        |Tp.Calc.Tol| Unid.Med. | Valor       | Obs.:                            |"										
						
						@li, 00 PSAY "|"
						@li, 01 PSAY QMG->QMG_PONTO
						@li, 17 PSAY "|"
						@li, 18 PSAY Padr(AllTrim(QMG->QMG_NOMIN),10) // "Especificado: "
						@li, 32 PSAY "|"
						@li, 33 PSAY Padr(AllTrim(QMG->QMG_LIE),10)
						@li, 45 PSAY "|"
						@li, 46 PSAY Padr(AllTrim(QMG->QMG_LSE),10)
						@li, 58 PSAY "|"
						@li, 59 PSAY SubStr(QMTCBox("QMG_TIPTOL",QMG->QMG_TIPTOL),5,10)
					
						//             10       20         30        40        50        60        70        80        90        100       110       120       130
						//   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
						//  "|Ponto           | Especificado | LIE        | LSE        |Tp.Calc.Tol| Vlr Final       | Vlr Final       | Obs.:                  |"								

						If QM9->QM9_TIPAFE$"4"
							@li, 70 PSAY "|"//STRCOLUNA_1 
							@li, 72 PSAY cUniMed
    						@li, 82 PSAY STRCOLUNA_5
						ElseIf QM9->QM9_TIPAFE$"8"
							@li, 70 PSAY STRCOLUNA_2 
						EndIf
						@li,131 PSAY "|"
						li++
						If li > 55
							@li,00 PSAY Repl( "-", nLimite )
							li := 66 // For�a a quebra de p�g.
						EndIf
						//�������������������������������������������Ŀ
						//� Faz a troca de p�g. se necess�rio.        �
						//���������������������������������������������

					    r020Cab(.T.) // N�o imprime linha na pr�x. p�g.
						
						@ li,00 PSAY Repl( "-", nLimite )
						//����������������������������������������������������Ŀ
						//� A fun��o r020Medic monta as linhas com as colunas  �
						//�  em branco para preenchimento pelo usu�rio.        �
						//������������������������������������������������������
						If QM9->QM9_TIPAFE$"4"      
							r020Medic( nNumMed -1, 82, STRCOLUNA_5)							
						ElseIf QM9->QM9_TIPAFE$"8"
							r020Medic( nNumMed -1, 70, STRCOLUNA_2)
						EndIf
						
					ElseIf QM9->QM9_NROMED == 0 //COLETA == "N"
						
						//����������������������������������������������������Ŀ
						//� Trata laborat�rios externos.                       �
						//������������������������������������������������������
						r020MedExt()
						
					ElseIf QMG->QMG_TIPCAL == "A"
						//����������������������������������������������������Ŀ
						//� Imprime a linha para atributos.                    �
						//������������������������������������������������������
						r020AtQMG()
					EndIf
					
					QMG->(dbSkip())
					
				EndDo
			ElseIf  Empty(QM9->QM9_TIPAFE) .or. Alltrim(QM9->QM9_TIPAFE)==""
				//����������������������������������������������������Ŀ
				//� Trata laborat�rios externos.                       �
				//������������������������������������������������������
				r020MedExt()
			EndIf
			
		EndIf
		
		dbSelectArea( "QMK" )
		dbSetOrder(1)
		cPula := QMK->QMK_ESCALA + QMK->QMK_TIPO + QMK->QMK_REVTIP
		While QMK->(!Eof()) .and. QMK->QMK_ESCALA + QMK->QMK_TIPO+ QMK->QMK_REVTIP == cPula
			dbSkip()
		EndDo
	EndDo
	
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			dbSelectArea("TRB")
		Else
	#ENDIF
			dbSelectArea("QM2")
	#IFDEF TOP
		Endif
	#ENDIF	
	
	dbSkip()
	
	If lRodaImp
		
		nRodaLim := 56
		
		//           1         2         3         4         5         6         7         8         9        10        11        12        13
		//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		// "| Data :    /    /      | Hora Inicial:      :        | Hora Final  :      :        | Metrologista :
		li++
		//�������������������������������������������Ŀ
		//� Faz a troca de p�g. se necess�rio.        �
		//���������������������������������������������
	    r020Cab(.T.,58) // Imprime linha na pr�x. p�g.
		
		@ li,00  PSAY Repl( "=", nLimite )
		li++
		@ li,00  PSAY STR0032 // "| Data :    /    /"
		@ li,24  PSAY STR0033 // "| Hora Inicial:      :"
		@ li,54  PSAY STR0034 // "| Hora Final  :      :"
		@ li,84  PSAY STR0035 // "| Metrologista : "
		@ li,131 PSAY "|"
		li++
		@li,00 PSAY Repl( "=", nLimite )
		
		lRodaImp := .F.
	EndIf
	
EndDo

If li <> 80
	Roda( cbCont, cbTxt, cTamanho )
EndIf

Set Device To Screen
#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea("TRB")
		dbCloseArea()
	Else
#ENDIF	
		Set Filter To
		RetIndex("QM2")
		dbClearInd()
		FErase(cIndex+OrdBagExt())
		dbCloseArea()
#IFDEF TOP
	Endif
#ENDIF	

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
End

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao	 �r020Medic � Autor � Antonio Aurelio       � Data � 20.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Constroi os cabecalhos de medi��es						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function r020Medic( nNumMed , nPos, cCol )

Default nPos := 63
Default cCol := "|                     |                     |"

//�����������������������������������������������������������������Ŀ
//� Constr�i o cabe�alho das medicoes.  						    �
//�������������������������������������������������������������������

For i = 1 To nNumMed
	li++
	//�������������������������������������������Ŀ
	//� Faz a troca de p�g. se necess�rio.        �
	//���������������������������������������������
    r020Cab(.T.) // Imprime linha na pr�x. p�g.
	@li,00   PSAY "|"
	@li,nPos PSAY cCol
	@li,131  PSAY "|"
	If i < nNumMed
		li++
		//�������������������������������������������Ŀ
		//� Verifico se esta no final da p�g.         �
		//� e for�o o fechamento da caixa.            �
		//���������������������������������������������
		If li > 55
			@li,00 PSAY Repl( "-", nLimite )
			li := 66 // For�a a quebra de p�g.
		EndIf
		//�������������������������������������������Ŀ
		//� Faz a troca de p�g. se necess�rio.        �
		//���������������������������������������������
		If !r020Cab(.T.) // Imprime linha na pr�x. p�g.
			@li,00 PSAY "|"
			@ li,nPos PSAY Repl( "-", Len(cCol) + 1)
		Else
			li-- // Ajuste aqui
		EndIf
	EndIf
Next

If nNumMed > 0
	li++
	//�������������������������������������������Ŀ
	//� Faz a troca de p�g. se necess�rio.        �
	//���������������������������������������������
	r020Cab(.F.) // Imprime linha na pr�x. p�g.
	@ li,00 PSAY Repl( "-", nLimite )
EndIf

Return( NIL )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Mtr020Sec � Autor � Alessandro B. Freire  � Data � 24.04.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna os padroes secundarios utilizados na escala        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � MTR020Sec( )                     						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Mtr020Sec()

Local cOldAlias	:= Alias()
Local cQuery	:= ""	
Local cChave    := ""
Local aArrayQMH := {}
Local aArrayRet := {}
Local nPos      := 0
//��������������������������������������������������������Ŀ
//� Imprime os padroes secundarios.     				   �
//����������������������������������������������������������
dbSelectArea( "QMH" )
dbSetOrder(1)
dbSeek( xFilial("QMH") + QMK->QMK_ESCALA )
If Found()
	#IFDEF TOP
		If TcSrvType() != "AS/400"               
		    cChave := "QMH_FILIAL+QMH_ESCALA"
			cQuery := "SELECT QMH_FILIAL,QMH_ESCALA,QMH_PADSEC "
			cQuery += "FROM "+RetSqlName("QMH")+" "
			cQuery += "WHERE "
			cQuery += "QMH_FILIAL = '" +xFilial("QMH")+	"' AND "
			cQuery += "QMH_ESCALA = '" + QMK->QMK_ESCALA + "' AND "	
			cQuery += "D_E_L_E_T_= ' ' "
			cQuery += " ORDER BY " + SqlOrder(cChave)

			cQuery := ChangeQuery(cQuery)
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TQH",.T.,.T.)
			
			While ! Eof() 
				If Ascan(aArrayQMH,AllTrim( TQH->QMH_PADSEC )) == 0
					Aadd(aArrayQMH,AllTrim( TQH->QMH_PADSEC ))
				Endif
				dbSkip()
			EndDo
			TQH->(dbCloseArea()	)
		Else
	#ENDIF		
	While QMH->(!Eof()) .And. ( xFilial("QMH")+QMH->QMH_ESCALA == QMK->QMK_FILIAL+QMK->QMK_ESCALA )
			If Ascan(aArrayQMH,AllTrim( QMH->QMH_PADSEC )) == 0
				Aadd(aArrayQMH,AllTrim( QMH->QMH_PADSEC ))
			Endif
		dbSkip()
	EndDo
	#IFDEF TOP
		Endif
	#ENDIF
Endif

dbSelectArea( cOldAlias )

If Len(aArrayQMH) > 0
	For nx := 1 to Len(aArrayQMH)
		If nPos > 110 .or. nx == 1
			Aadd(aArrayRet,aArrayQMH[nx])
			nPos := 0
			nPos :=  nPos + Len(aArrayQMH[nx])
		Else
			aArrayRet[Len(aArrayRet)] += " / "+aArrayQMH[nx]
			nPos :=  nPos + (Len(aArrayQMH[nx]) + 3)
		Endif		
	Next		
Endif

Return( aArrayRet )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Mtr020Proc� Autor � Alessandro B. Freire  � Data � 24.04.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o procedimento de calibracao do instrumento.       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � MTR020Proc()                     						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function Mtr020Proc(TRB_TIPO)
Local cOldAlias := Alias()

//�����������������������������������������������������������������Ŀ
//� Encontra o tipo do instrumento.                                 �
//�������������������������������������������������������������������
dbSelectArea( "QM1" )
dbSetOrder( 1 )
dbSeek( xFilial("QM1") + TRB_TIPO )

//�����������������������������������������������������������������Ŀ
//� Encontra o procedimento de calibracao amarrado ao tipo          �
//�������������������������������������������������������������������
dbSelectArea( "QA5")
dbSetOrder( 1 )
If QA5->(dbSeek( xFilial("QA5") + "C" + QM1->QM1_PROCAL ))
	dbSelectArea( cOldAlias )
	Return( AllTrim( QA5->QA5_NORMA ) + " - " + AllTrim ( QA5->QA5_DESCRI ) )
Else
	dbSelectArea( cOldAlias )
	Return( AllTrim( QM1->QM1_PROCAL ))
Endif

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �r020Cab   � Autor � Antonio Aurelio       � Data � 20.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabe�alho.                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function r020Cab(lLnImpr, nLnLim)
Local lRet

Default lLnImpr := .T.
Default nLnLim := 55

lRet := .F.

If li > nLnLim
	
	Cabec(cTitulo,"","",cNomeprog,cTamanho,IIF(aReturn[4]==1,15,18) )
	li := 5
	@li,00 PSAY Repl( "*", nLimite )
	
	//��������������������������������������������������������������������Ŀ
	//� cOldInst � private em r020Imp, e � atualizada apenas em r020Inst   �
	//� que � quando se imprime todo cabe�alho de instrumento.             �
	//����������������������������������������������������������������������
	If cImpCbInst == cOldInst
		li++
		li++
		@li,00 PSAY cCabec1
		li++
		
	Else
		r020Inst()
		cOldInst := cImpCbInst
	EndIf
	
	If lLnImpr
		li++
		@ li,00 PSAY Repl( "-", nLimite )
	EndIf
	li++
	lRet := .T.
EndIf

Return lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �r020Instr � Autor � Ant�nio Aur�lio       � Data � 20.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabe�alho.                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function r020Inst()

//�����������������������������������������������������������������Ŀ
//� Quebra por instrumento.                                         �
//�������������������������������������������������������������������
If mv_par20 == 1 .And. li > 4
	li := 66
EndIf

//�������������������������������������������Ŀ
//� Faz a troca de p�g. se necess�rio.        �
//���������������������������������������������
If li > 55  // Imprime todo o 'bloco' ou pula de p�g.
	Cabec(cTitulo,"","",cNomeprog,cTamanho,IIF(aReturn[4]==1,15,18) )
	li:=5
	@li,00 PSAY Repl( "*", nLimite )
EndIf

li++
@li,00 PSAY cCabec1
li++
@Li,00 PSAY cCabec2
li++
@li,00 PSAY cCabec3
li++
@li,00 PSAY cCabec4
li++
@li,00 PSAY Repl( "*", nLimite )

//����������������������������������������������Ŀ
//� cOldInst � verificada em r020Cab.            �
//� cImpCbInst � atualizada quando se troca de   �
//� instrumento.                                 �
//������������������������������������������������
cOldInst := cImpCbInst

Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �r020Atrib � Autor � Ant�nio Aur�lio       � Data � 20.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a linha para atributos.                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function r020Atrib(nCol)

li++
//�������������������������������������������Ŀ
//� Faz a troca de p�g. se necess�rio.        �
//���������������������������������������������
r020Cab(.T.) // Imprime linha na pr�x. p�g.

@li,00  PSAY "|"
@li,01  PSAY PadR(QM3->QM3_PADRAO,16)
@li,17  PSAY "|"
@li,19  PSAY PadR(QM3->QM3_REVPAD,3)
@li,23  PSAY "|"
If nCol = 1
	@li, 38 PSAY "|"
	@li, 51 PSAY "|"	
	@li, 64 PSAY "|"		
	@li, 76 PSAY STR0026 //  "| [ ] APROVADO        |"
	@li,131 PSAY "|"
	li++
	//�������������������������������������������Ŀ
	//� Verifico se esta no final da p�g.         �
	//� e for�o o fechamento da caixa.            �
	//���������������������������������������������
	If li > 55
		@li,00 PSAY Repl( "-", nLimite )
		li := 66 // For�a a quebra de p�g.
	EndIf
	//�������������������������������������������Ŀ
	//� Faz a troca de p�g. se necess�rio.        �
	//���������������������������������������������
    r020Cab(.T.) // Imprime linha na pr�x. p�g.
	
	@li,00  PSAY "|"
	@li,76  PSAY STR0027 // "|[ ] REPROVADO|"
	@li,131 PSAY "|"
ElseIf nCol == 2
	@li, 38 PSAY "|"
	@li, 51 PSAY "|"	
	@li, 64 PSAY "|"		
	@li, 76 PSAY STR0029  // "|               |              | [  ] APROVADO         [  ] REPROVADO      |                       |"
	@li,131 PSAY "|"	
ElseIf nCol == 4
	@li, 38 PSAY "|"
	@li, 51 PSAY "|"	
	@li, 64 PSAY "|"		
	@li, 76   PSAY  STR0030 // "|              | [  ] APROVADO            [  ] REPROVADO        |                  |"
EndIf

li++
//�������������������������������������������Ŀ
//� Verifico se esta no final da p�g.         �
//� e for�o o fechamento da caixa.            �
//���������������������������������������������
If li > 55
	@li,00 PSAY Repl( "-", nLimite )
	li := 66 // For�a a quebra de p�g.
EndIf
//�������������������������������������������Ŀ
//� Faz a troca de p�g. se necess�rio.        �
//���������������������������������������������
r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
@ li,00 PSAY Repl( "-", nLimite )

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �r020AtQMG � Autor � Ant�nio Aur�lio       � Data � 20.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a linha para atributos.                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function r020AtQMG()

li++
//�������������������������������������������Ŀ
//� Faz a troca de p�g. se necess�rio.        �
//���������������������������������������������
r020Cab(.T.) // Imprime linha na pr�x. p�g.

@li, 00 PSAY "|"
@li, 01 PSAY QMG->QMG_PONTO
@li, 17 PSAY "|"
@li, 32 PSAY "|"       
@li, 45 PSAY "|"       
@li, 58 PSAY "|"        
@li, 70 PSAY "|"       

If QM9->QM9_TIPAFE$"4"
	@li,72 PSAY cUniMed
	@li,82 PSAY STR0026
	@li,131 PSAY "|"
	li++
	//�������������������������������������������Ŀ
	//� Verifico se esta no final da p�g.         �
	//� e for�o o fechamento da caixa.            �
	//���������������������������������������������
	If li > 55
		@li,00 PSAY Repl( "-", nLimite )
		li := 66 // For�a a quebra de p�g.
	EndIf
	//�������������������������������������������Ŀ
	//� Faz a troca de p�g. se necess�rio.        �
	//���������������������������������������������
    r020Cab(.T.) // Imprime linha na pr�x. p�g.
	
	@li,00 PSAY "|"
	@li,17 PSAY "|"
	@li,32 PSAY "|"
	@li,45 PSAY "|"
	@li, 58 PSAY "|"        
	@li, 70 PSAY "|"       
	@li,82 PSAY STR0027  // "| [ ] REPROVADO       |"	
ElseIf QM9->QM9_TIPAFE$"8"
	@li, 70 PSAY STR0028 // "| [ ] APROVADO           [ ] REPROVADO      |"
EndIf
@li,131 PSAY "|"

li++
//�������������������������������������������Ŀ
//� Verifico se esta no final da p�g.         �
//� e for�o o fechamento da caixa.            �
//���������������������������������������������
If li > 55
	@li,00 PSAY Repl( "-", nLimite )
	li := 66 // For�a a quebra de p�g.
EndIf
//�������������������������������������������Ŀ
//� Faz a troca de p�g. se necess�rio.        �
//���������������������������������������������
r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
@ li,00 PSAY Repl( "-", nLimite )

Return NIL


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �r020Escala� Autor � Ant�nio Aur�lio       � Data � 20.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a linha para atributos.                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � QMTR020													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function r020Escala(nCol)
Local aArrays	:={}
Local nx		:= 1
Local lPadSec	:= .F.
Default nCol	:= 1

li++
//�������������������������������������������Ŀ
//� Faz a troca de p�g. se necess�rio.        �
//���������������������������������������������
r020Cab(.F.,45) // N�o imprime linha na pr�x. p�g.

@li,000 PSAY STR0014 + QMK->QMK_ESCALA // "ESCALA.: "
@li,029 PSAY STR0015 + QM3->QM3_UNIMED + ; // "UNIDADE DE MEDIDA: "
If(SAH->(Found())," - " + SAH->AH_DESCPO," ")
	li++

	aArrays := Mtr020Sec()

	For nx := 1 To Len(aArrays)
		If nx == 1 // Se passar a primeira vez imprime cabec+dados
			lPadSec := .T.
			@li,00 PSAY STR0016 + aArrays[nx]
			li++		
		Else //So imprime os dados
			@li,19 PSAY aArrays[nx]		
			li++
		Endif
	Next nx
    
    If !lPadSec
		@li,00 PSAY STR0016    	
		li++
    Endif
	@li,00 PSAY STR0017 // "INSTRUMENTO UTILIZADO:"
	li++
	@ li,00 PSAY Repl( "-", nLimite )
	li++              
//             10       20         30        40        50        60        70        80        90        100
//   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//	"|Padrao          | Rev |Especificado| Tol.Minima | Tol.Maxima |Tp.Calc.Tol| Valor       | Obs.                               |"

	If nCol == 1
		@li, 00 PSAY "|" + STR0018 // "Padrao"
		@li, 17 PSAY "| " + SubsTR(OemToAnsi(STR0019),1,3)+" " // "Rev"
		@li, 23 PSAY STR0020 // "|Especificado| Tol.Minima | Tol.Maxima |Tip.Calc.Toler.|Valor           | Obs.:                                        |"
	ElseIf nCol == 2
		@li, 00 PSAY "|" + STR0018 // "Padrao"
		@li, 17 PSAY "| " + SubsTR(OemToAnsi(STR0019),1,3) // "Rev"
		@li, 23 PSAY STR0021 // "| Especificado | Tol.Minima | Tol.Minima | Vlr Inicial | Vlr Final  | Obs.                  |"
	ElseIf nCol == 4
		@li, 00 PSAY "|"
		@li, 17 PSAY "| "
		@li, 00 PSAY STR0022 // |  Valor Inicial         |   Valor Final         |                  |"
		li++
		@li, 00  PSAY STR0023 // "| Padrao            | Revisao   | Especificado  | Tolerancia   |  Subida    | Descida   |  Subida   | Descida   | Obs.             |"
	EndIf
	li++
	@ li,00 PSAY Repl( "-", nLimite )
	
	
	Return NIL
	
	/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Fun��o	 �r020EscQMG� Autor � Ant�nio Aur�lio       � Data � 20.03.00 ���
	�������������������������������������������������������������������������Ĵ��
	���Descri��o � Imprime a linha para atributos.                            ���
	�������������������������������������������������������������������������Ĵ��
	��� Uso		 � QMTR020													  ���
	��������������������������������������������������������������������������ٱ�
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	/*/
	Static Function r020EscQMG()
	Local aArrays := {}
	Local nx := 1	
	Local lPadSec := .F.
	li++
	//�������������������������������������������Ŀ
	//� Faz a troca de p�g. se necess�rio.        �
	//���������������������������������������������
	r020Cab(.T.,48) // Imprime linha na pr�x. p�g.
	
	@li,000 PSAY STR0014 + QMK->QMK_ESCALA // "ESCALA.: "
	dbSelectArea("QM9")
	dbSetOrder(1)
	If dbSeek(xFilial("QM9")+QMK->QMK_ESCALA+QMK->QMK_REVINV)
		dbSelectArea("SAH")
		dbSetOrder(1)
		If dbSeek(xFilial("SAH")+QM9->QM9_UNIMED)
			@li,029 PSAY STR0015 + SAH->AH_UNIMED + ; // "UNIDADE DE MEDIDA:"
			" - " + SAH->AH_DESCPO
		Endif	
	Endif	
	li++
	aArrays := Mtr020Sec()
	For nx := 1 To Len(aArrays)
		If nx == 1 // Se passar a primeira vez imprime cabec+dados
			lPadSec := .T.
			@li,00 PSAY STR0016 + aArrays[nx]
			li++		
		Else //So imprime os dados
			@li,19 PSAY aArrays[nx]		
			li++
		Endif
	Next nx
	If !lPadSec
		@li,00 PSAY STR0016		
	Endif
	li++
	@li,00 PSAY STR0017 // "INSTRUMENTO UTILIZADO:"
	li++
	//�������������������������������������������Ŀ
	//� Faz a troca de p�g. se necess�rio.        �
	//���������������������������������������������
	r020Cab(.F.,56) // N�o imprime linha na pr�x. p�g.
	@ li,00 PSAY Repl( "-", nLimite )
	li++
	If QM9->QM9_TIPAFE$"4"  // 1 Coluna
		@li,00 PSAY STR0024  
	ElseIf QM9->QM9_TIPAFE$"8"  // 2 Colunas
		@li,00 PSAY STR0025
	EndIf
	li++
	@ li,00 PSAY Repl( "-", nLimite )
	
	Return NIL
		
		/*/
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		�������������������������������������������������������������������������Ŀ��
		���Fun��o	 �r020MedExt� Autor � Ant�nio Aur�lio       � Data � 20.03.00 ���
		�������������������������������������������������������������������������Ĵ��
		���Descri��o � Imprime linha para lab. externos                           ���
		�������������������������������������������������������������������������Ĵ��
		��� Uso		 � QMTR020													  ���
		��������������������������������������������������������������������������ٱ�
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		/*/
		Static Function r020MedExt()
		
		li++
		//�������������������������������������������Ŀ
		//� Faz a troca de p�g. se necess�rio.        �
		//���������������������������������������������
		r020Cab(.T.) // Imprime linha na pr�x. p�g.
		@li,00  PSAY "|"
		@li,02  PSAY STR0031  // "* * * * * *   M E D I C O E S   R E A L I Z A D A S   P O R   L A B O R A T O R I O   E X T E R N O   * * * * * *"
		@li,131 PSAY "|"
		li++
		If li > 55
			@li,00 PSAY Repl( "-", nLimite )
			li := 66 // For�a a quebra de p�g.
		EndIf
		//�������������������������������������������Ŀ
		//� Faz a troca de p�g. se necess�rio.        �
		//���������������������������������������������
		r020Cab(.F.) // N�o imprime linha na pr�x. p�g.
		@ li,00 PSAY Repl( "-", nLimite )
		
		Return .T.
