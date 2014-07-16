#Include "TOPCONN.CH"  
#Include "RWMAKE.CH"   
#Include "MSOLE.CH"    
#Include "ACADEF.CH"

#define CRLF	Chr(13) + Chr(10)

/*/                                                                                 0
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ASSREQ   � Autor �                    � Data �  08/07/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Tela para informacao das assinaturas utilizadas em alguns  ���
���          � documentos de requerimentos.                               ���
�������������������������������������������������������������������������͹��
���Uso       � ACAA410                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function ASSREQ

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
cPRO := Space(6)
cSEC := Space(6)
cVar := Space(290)
//���������������������������������������������������������������������Ŀ
//� Criacao da Interface                                                �
//�����������������������������������������������������������������������
IF  Alltrim(JBH->JBH_TIPO) == '000002' .or. Alltrim(JBH->JBH_TIPO) == '000023'
	@ 64,262 To 341,567 Dialog assinaturas Title "ASSINATURAS"
	@ 10,18 Say "PRO-REITORIA" Size 46,8
	@ 25,15 Say "SECRETARIA" Size 46,8 
	@ 40,15 Say "OBSERVA��ES" Size 46,8
	@ 10,63 Get cPRO F3 "JBJ" Size 76,8
	@ 25,63 Get cSEC F3 "JBJ" Size 76,8
	@ 55,15 Get cVar MEMO Size 126,62
	@ 124,111 BmpButton Type 1 Action close(assinaturas)
	Activate Dialog assinaturas	
	Return({cPro, cSec, cVar})
ELSE
	@ 80,262 To 241,567 Dialog assinaturas Title "ASSINATURAS"
	@ 10,18 Say "PRO-REITORIA" Size 46,8
	@ 25,15 Say "SECRETARIA" Size 46,8
	@ 10,63 Get cPRO F3 "JBJ" Size 76,8
	@ 25,63 Get cSEC F3 "JBJ" Size 76,8
	@ 64,111 BmpButton Type 1 Action close(assinaturas)
	Activate Dialog assinaturas
	Return({cPro, cSec})
ENDIF


/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �AcMsgFun    � Autor � Gustavo Henrique     � Data � 16/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna vetor com o assunto do e-mail e mensagem a ser enviada���
���          �para o funcionario.                                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �AcMsgFun        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPC1 - Status atual: Pendente/Atrasado/Aguardando Vaga       ���
���������������������������������������������������������������������������Ĵ��
���Retorno	 �EXPC1 - Assunto do e-mail     								���
���       	 �EXPC2 - Corpo da mensagem do e-mail  							���
���       	 �EXPC3 - Campo memo com as observacoes para o funcionario   	���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACMsgFun

Local cStatus := ParamIxb[1]
Local cTipSol := ParamIxb[2]
Local cObs    := ParamIxb[3]
Local cCRLF   := Chr( 13 ) + Chr( 10 )
Local aRet    := Array( 2 )

aRet[1] := "Requerimento: " + RTrim( JBF->JBF_DESC ) + iif( cTipSol == "4", " RG: ", " RA: " ) + Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
aRet[2] := "Prezado Funcion�rio" + cCRLF + cCRLF
aRet[2] += "Por favor verificar requerimento n�mero " + JBH->JBH_NUM						

If JBI->( JBI_STATUS # "1" .and. JBI_STATUS # "2" )
	aRet[2] += cCRLF + "O status atual e : " + cStatus
EndIf

if ! Empty( cObs )
	aRet[2] += cCRLF + cCRLF + cObs
endif	

aRet[2] += cCRLF + cCRLF 
aRet[2] += "Secretaria de Registros Acad�micos" + cCRLF
aRet[2] += "Microsiga Intelligence"

Return( aRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �AcMsgSol    � Autor � Gustavo Henrique     � Data � 16/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna vetor com o assunto do e-mail e mensagem a ser enviada���
���          �para o solicitante.                                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �AcMsgSol        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPC1 - Nome do solicitante: Aluno/Funcionario/Candidato/Nome	���
���       	 �do solicitante externo.              							���
���       	 �EXPC2 - Status atual: 1=Deferido;2=Indeferido;3,4,5=Em analise���
���������������������������������������������������������������������������Ĵ��
���Retorno	 �EXPC1 - Assunto do e-mail     								���
���       	 �EXPC2 - Corpo da mensagem do e-mail  							���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACMsgSol

Local aRet    := Array( 2 )
Local cSolic  := ParamIxb[1]		// Nome do solicitante: Funcionario/Aluno/Candidato/Externo
Local cStatus := ParamIxb[2]		// 1=Deferido/2=Indeferido/3,4,5=Em analise
Local cTipSol := ParamIxb[3]		// Tipo de solicitante: 1=Funcionario;2=Aluno;3=Candidato;4=Externo
Local cObs    := ParamIxb[4]		// Campo memo com as observacoes para o departamento ou para o aluno.
Local cCRLF   := Chr( 13 ) + Chr( 10 )

aRet[1] := "Requerimento: " + RTrim( JBF->JBF_DESC ) + iif( cTipSol == "4", " RG: ", " RA: " ) + Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

// est� sendo analisado/foi indeferido/foi deferido
aRet[2] := "Prezado " + cSolic + cCRLF + cCRLF
aRet[2] += "Seu requerimento n�mero " + RTrim( JBH->JBH_NUM ) + " - " + RTrim( JBF->JBF_DESC )

If cStatus == "1"
	aRet[2] += " foi deferido."
ElseIf cStatus == "2"
	aRet[2] += " foi indeferido."
ElseIf cStatus $ "3/4/5"
	aRet[2] += " est� sendo analisado."
EndIf	
     
if ! Empty( cObs ) .And. cStatus == "2"
	aRet[2] += cCRLF + cCRLF + cObs
endif	

aRet[2] += cCRLF + cCRLF 
aRet[2] += "Secretaria de Registros Acad�micos" + cCRLF
aRet[2] += "Microsiga Intelligence"

Return( aRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ACScpAtrib�Autor  �Gustavo Henrique    � Data �  23/jul/02  ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Preenche um campo do script com um determinado conteudo     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpCO1: Ordem do campo no script do requerimento.           ���
���          �ExpC02: Conteudo para preencher o campo do script.          ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Gestao Educacional - Requerimentos                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACScpAtrib( cOrdem, cConteudo )

uRet := Eval( &( "{ || M->JBH_SCP" + cOrdem + " := " + cConteudo + " }" ) )

Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ACIntTrans�Autor  �Gustavo Henrique    � Data �  01/ago/02  ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Atualiza intencao de transferencia por curso e disciplina.  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpCO1: Curso da intencao.                                  ���
���          �ExpC02: Periodo Letivo da intencao.                         ���
���          �ExpL03: Soma uma intencao de transferencia.                 ���
���          �ExpL04: Busca o curso e o periodo da analise da grade       ���
���          �ExpC03: Habilitacao.                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Gestao Educacional - Requerimentos                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACIntTrans( nCurso, nPerLet, lSoma, lGrade, nHabili )
                         
Local cTurma  := ""		// Turma das disciplinas com intensao de matricula
Local cCurso  := ""		// Codigo do curso
Local cPerLet := ""		// Codigo do periodo letivo
Local cHabili := ""     // Codigo da habilitacao
Local aRet    := {}

lGrade := Iif( lGrade == NIL, .F., lGrade )
                                                                                                               
//���������������������������������������������������������������������Ŀ
//� Soh executa se:                                                     �
//� 1) For um requerimento de transferencia de curso                    �
//� 2) Se for para somar, sempre executa, caso seja para subtrair soh   �
//�    executa se o requerimento estiver deferido ou indeferido e o     �
//�    campo JBH_DTINIC estiver preenchido.                             �
//�����������������������������������������������������������������������
If JBF->JBF_TRANSF == "1" .and. If( lSoma, .T., JBH->JBH_STATUS $ "12" .and. ! Empty( JBH->JBH_DTINIC ) ) 

	Begin Transaction
	
		If lGrade
		             
			JCS->( dbSetOrder( 1 ) )
			JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )
		     
			cCurso  := JCS->JCS_CURSO
			cPerLet := JCS->JCS_SERIE
			cHabili := JCS->JCS_HABILI
		
		Else
                    
			aRet    := ACScriptReq( JBH->JBH_NUM )

			cCurso	:= aRet[nCurso]
			cPerLet := aRet[nPerLet]
			cHabili := aRet[nHabili]
			
		EndIf	

		JAR->( dbSetOrder( 1 ) )
		if !Empty( cCurso ) .and. !Empty( cPerLet ) .and. JAR->( dbSeek( xFilial( "JAR" ) + cCurso + cPerLet + cHabili) )
			
			RecLock( "JAR", .F. )
			
			If lSoma
				JAR->JAR_TRANSF += 1
			Else
				JAR->JAR_TRANSF -= 1
			EndIf
			
			MsUnlock()
			
			// Acumula a intensao de transferencia sempre na primeira turma encontrada
			// do curso e periodo letivo
			JCE->( dbSetOrder( 1 ) )
			JCE->( dbSeek( xFilial( "JCE" ) + cCurso + cPerLet + cHabili) )
			
			cTurma := If( lGrade, JCS->JCS_TURMA, JCE->JCE_TURMA )
			
			Do While JCE->( ! EoF() .and. JCE_FILIAL + JCE_CODCUR + JCE_PERLET + JCE_HABILI + JCE_TURMA == xFilial( "JCE" ) + cCurso + cPerLet + cHabili + cTurma )
				
				RecLock( "JCE", .F. )
				
				If lSoma
					JCE->JCE_TRANSF += 1
				Else
					JCE->JCE_TRANSF -= 1
				EndIf
				
				MsUnlock()
				
				JCE->( dbSkip() )
				
			EndDo
			
		Endif
				
	End Transaction

EndIf
	
Return( .T. )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACAnalise   � Autor � Gustavo Henrique     � Data � 30/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o documento referente a Analise Curricular.           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �ACAnalise       					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACAnalise()
             
Processa( { || U_ACProcAC() } )

Return( .T. )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACProcAC    � Autor � Gustavo Henrique     � Data � 30/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o processamento de impressao referente a Analise      ���
���          �Curricular.  													���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �ACProcAC()  						    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACProcAC()

Local cCodIde	:= ""
Local cTitIde	:= ""
Local aDiscip	:= {}
Local cArqDot	:= "SEC0022.DOT"
Local cPathDot	:= Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD
Local cPathEst	:= Alltrim(GetMv("MV_DIREST")) // Path do arquivo a ser armazenado na estacao de trabalho
Local cSemestre := ""
Local cHabili  := ""
Local cLinha	:= ""
Local cTurno	:= ""
Local nCntFor	:= 0
Local nNumDisp	:= 0
Local hWord		:= 0
Local cNotaDisc := " "
Local nCargaTot := 0
Local nPriElem  := 0
               
ProcRegua( 5 )      

IncProc()                    
                                                  
if JBH->JBH_TIPSOL == "4"
	cCodIde	:= Left(JBH_CODIDE,TamSX3("JCR_RG")[1])
	cNome	:= JBH->JBH_NOME
	cTitIde := "RG"
else
	cCodIde	:= Left(JBH_CODIDE,TamSX3("JA2_NUMRA")[1])
	cNome	:= SubStr(Posicione( "JA2", 1, xFilial("JA2")+cCodIde, "JA2_NOME" ),1,40)
	cTitIde := "RA"
endif

//�����������������������������������������������������������������������Ŀ
//� Criando link de comunicacao com o word                                �
//�������������������������������������������������������������������������
hWord := OLE_CreateLink()
OLE_SetProperty ( hWord, oleWdVisible, .F.)

//�����������������������������������������������������������������������Ŀ
//� Seu Documento Criado no Word                                          �
//� A extensao do documento tem que ser .DOT                              �
//�������������������������������������������������������������������������
MontaDir(cPathEst)

If ! File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox("Atencao... SEC0022.DOT nao encontrado no Servidor")

Elseif hWord == "-1"
	MsgBox("Imposs�vel estabelecer comunica��o com o Microsoft Word.")

Else   
             
	// Posiciona o Header da Analise da Grade Curricular
	JCS->( dbSetOrder( 1 ) )
	JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )

	// Caso encontre arquivo ja gerado na estacao
	//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
	If File( cPathEst + cArqDot )
		Ferase( cPathEst + cArqDot )
	EndIf
	
	CpyS2T(cPathDot,cPathEst,.T.) // Copia do Server para o Remote, eh necessario

	//para que o wordview e o proprio word possam preparar o arquivo para impressao e
	// ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da
	// estacao , por exemplo C:\WORDTMP
	cTurno := Tabela( "F5", Posicione( "JAH", 1, xFilial("JAH")+JCS->JCS_CURSO, "JAH_TURNO" ), .F.)
	
	//�����������������������������������������������������������������������Ŀ
	//� Gerando novo documento do Word na estacao                             �
	//�������������������������������������������������������������������������
	OLE_NewFile( hWord, cPathEst + cArqDot)
	
	OLE_SetProperty( hWord, oleWdVisible, .F. )
	OLE_SetProperty( hWord, oleWdPrintBack, .F. )

	//�����������������������������������������������������������������������Ŀ
	//� Gerando variaveis para o cabecalho   	                              �
	//�������������������������������������������������������������������������
	OLE_SetDocumentVar( hWord, "cReq"	, JBH->JBH_NUM	)
	OLE_SetDocumentVar( hWord, "cData"	, DtoC(dDataBase))
	OLE_SetDocumentVar( hWord, "cNome"	, cNome   )
	OLE_SetDocumentVar( hWord, "cTitIde", cTitIde )
	OLE_SetDocumentVar( hWord, "cRA"	, cCodIde )
	OLE_SetDocumentVar( hWord, "cCurso"	, Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JCS->JCS_CURSO,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC"))
	OLE_SetDocumentVar( hWord, "cHabili", Posicione( "JDK", 1, xFilial("JDK")+JCS->JCS_HABILI, "JDK_DESC" ))
	OLE_SetDocumentVar( hWord, "cAno"	, Posicione( "JAR", 1, xFilial("JAR")+JCS->(JCS_CURSO+JCS_SERIE+JCS_HABILI), "JAR_ANOLET" ))
	OLE_SetDocumentVar( hWord, "cTurno"	, cTurno )
	OLE_SetDocumentVar( hWord, "cFins"	, "Transfer�ncia de Curso" )
		     
	IncProc()
		                              
	cSemestre	:= ""

	JD1->( dbSetOrder( 1 ) )
	JAE->( dbSetOrder( 1 ) )
		
	JCT->( dbSetOrder( 1 ) )   
	JCT->( dbSeek( xFilial("JCT") + JCS->JCS_NUMREQ ) )
		
	Do While JCT->( ! EoF() .and. JCT_FILIAL = xFilial("JCT") .and. JCT_NUMREQ == JCS->JCS_NUMREQ )
		                               
		If ! Empty( JCT->JCT_DISCIP )
		     
			If JCT->JCT_PERLET # cSemestre .Or. JCT->JCT_HABILI # cHabili
				If ! Empty( cSemestre )
					AAdd( aDiscip, { JCT->JCT_PERLET, " ", " ", " ", " ", " ", " ", " ", JCT->JCT_HABILI } )
				EndIf
				cSemestre := JCT->JCT_PERLET
				cHabili   := JCT->JCT_HABILI
				AAdd( aDiscip, { JCT->JCT_PERLET,;
					Posicione( "JAR", 1, xFilial("JAR") + JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI,"JAR_DPERLE"),;
					" ", " ", " ", " ", " ", " ", JCT->JCT_HABILI } )
				AAdd( aDiscip, { JCT->JCT_PERLET, " ", " ", " ", " ", " ", " ", " ", JCT->JCT_HABILI } )	
			EndIf
			                        
			JAE->( dbSeek( xFilial("JAE") + JCT->JCT_DISCIP ) )
	
			If	JCT->JCT_SITUAC == "003" .and.;		// Dispensado
				JD1->( dbSeek( xFilial("JD1") + JCS->JCS_NUMREQ + JCS->JCS_CURSO + JCT->JCT_PERLET + JCT->JCT_HABILI + JCT->JCT_DISCIP ) )
                               
				nNumDisp := 0
				nCargaTot := 0
				
				While JD1->( ! EoF() .and. xFilial( "JD1" ) == JD1_FILIAL .and. JD1_NUMREQ == JCS->JCS_NUMREQ .And. JD1_CODCUR == JCS->JCS_CURSO .And. JD1_PERLET == JCT->JCT_PERLET .And. JD1_HABILI == JCT->JCT_HABILI .and. JD1_DISCIP == JCT->JCT_DISCIP )
				    
				    nNumDisp ++

					If Empty(JD1->JD1_NOTA)
						cNotaDisc := AllTrim(JD1->JD1_CONCEI)
					Else
						cNotaDisc := Transform(JD1->JD1_NOTA, PesqPict("JD1","JD1_NOTA"))
					EndIf

					nCargaTot += JD1->JD1_CARGA

					If nNumDisp == 1
						AAdd( aDiscip, { JCT->JCT_PERLET, JAE->JAE_DESC, JAE->JAE_CARGA, JD1->JD1_DISEXT, JD1->JD1_CARGA, " ", cNotaDisc, " ", JCT->JCT_HABILI } )

						nPriElem := Len(aDiscip)
					Else	
						AAdd( aDiscip, { JCT->JCT_PERLET, " ", " ", JD1->JD1_DISEXT, JD1->JD1_CARGA, " ", cNotaDisc, " ", JCT->JCT_HABILI } )
					EndIf
											
					JD1->( dbSkip() )
					
				EndDo
	
				aDiscip[nPriElem][6] := nCargaTot
				aDiscip[nPriElem][8] := Iif(Empty(JCT->JCT_MEDFIM), JCT->JCT_MEDCON, Transform(JCT->JCT_MEDFIM, PesqPict("JCT","JCT_MEDFIM")))
			Else
	
				AAdd( aDiscip, { JCT->JCT_PERLET, JAE->JAE_DESC, JAE->JAE_CARGA, " ", " ", " ", " ", " ", JCT->JCT_HABILI } )
	
			EndIf
		
		EndIf
			
		JCT->( dbSkip() )

	EndDo
             
	IncProc()

	nCntFor		:= 1
	cSemestre	:= aDiscip[1,1]
	cHabili     := aDiscip[1,9]
	cLinha		:= AllTrim(Str(nCntFor))
		            
	Do While nCntFor <= Len( aDiscip )

		Do While nCntFor <= Len( aDiscip ) .and. aDiscip[nCntFor,1] == cSemestre .And. aDiscip[nCntFor][9] == cHabili
	            
			//�����������������������������������������������������������������������Ŀ
			//� Gerando variaveis do documento                                        �
			//�������������������������������������������������������������������������
			cLinha	:= AllTrim(Str(nCntFor))
			
 			OLE_SetDocumentVar( hWord, "cDiscip1" + cLinha + "1", aDiscip[nCntFor,2] )
			OLE_SetDocumentVar( hWord, "nCH1" + cLinha + "2", aDiscip[nCntFor,3] )
 			OLE_SetDocumentVar( hWord, "cDiscip2" + cLinha + "3", aDiscip[nCntFor,4] )
			OLE_SetDocumentVar( hWord, "nCH2" + cLinha + "4", aDiscip[nCntFor,5] )
			OLE_SetDocumentVar( hWord, "nCHTot2" + cLinha + "5", aDiscip[nCntFor,6] )
			OLE_SetDocumentVar( hWord, "nNotaDis" + cLinha + "6", aDiscip[nCntFor,7] )
			OLE_SetDocumentVar( hWord, "nMedia" + cLinha + "7", aDiscip[nCntFor,8] )

			nCntFor += 1

		Enddo
		
		If nCntFor <= Len( aDiscip )
			cSemestre := aDiscip[nCntFor,1]
			cHabili   := aDiscip[nCntFor,9]
		EndIf
							
	Enddo                                                   

	IncProc()

	If nCntFor > 0
	
		//�����������������������������������������������������������������������Ŀ
		//� Nr. de linhas da Tabela a ser utilizada na matriz do Word             �
		//�������������������������������������������������������������������������
		OLE_SetDocumentVar(hWord,'Adv_SEMESTRE',cLinha)
	
		//�����������������������������������������������������������������������Ŀ
		//� Executa macro do Word                                                 �
		//�������������������������������������������������������������������������
		OLE_ExecuteMacro(hWord,"SEMESTRE") 
		
	EndIf
             
	//�����������������������������������������������������������������������Ŀ
	//� Atualizando variaveis do documento                                    �
	//�������������������������������������������������������������������������
	OLE_UpdateFields( hWord )
                                                
	//�����������������������������������������������������������������������Ŀ
	//� Maximizo o Documento Word e Ativo o Visible do Word                   �
	//�������������������������������������������������������������������������
	OLE_ExecuteMacro( hWord, "Proteger" )

	IncProc()

	OLE_SetProperty( hWord, oleWdVisible, .T. )
	OLE_SetProperty( hWord, oleWdWindowState, "MAX" )

EndIf

Return(.T.)

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACMsgAGrade � Autor � Gustavo Henrique     � Data � 30/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Envia e-mail para o aluno informando sobre a disponibilidade  ���
���          �do documento de analise curricular na secretaria.				���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �ACMsgAGrade     					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACMsgAGrade()
                        
Local cEmail	:= ""
Local cAssunto	:= ""
Local cMsg		:= ""         
Local cTipo		:= JBH->JBH_TIPSOL
Local cCodIde	:= ""
Local cNome		:= ""

JBF->( dbSetOrder( 1 ) )
JBF->( dbSeek( xFilial( "JBF" ) + JBH->( JBH_TIPO + JBH_VERSAO ) ) )
                     
If cTipo == "2"

	cCodIde := Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

	JA2->( dbSetOrder( 1 ) )
	JA2->( dbSeek( xFilial( "JA2" ) + cCodIde ) )
                        
	cEmail := JA2->JA2_EMAIL
	cNome  := Alltrim( JA2->JA2_NOME )
	
ElseIf cTipo == "4"

	cCodIde := Left( JBH->JBH_CODIDE, TamSX3("JCR_RG")[1] )

	JCR->( dbSetOrder( 1 ) )
	JCR->( dbSeek( xFilial( "JCR" ) + cCodIde ) )
                        
	cEmail := JCR->JCR_EMAIL
	cNome  := Alltrim( JCR->JCR_NOME )

EndIf	

If ! Empty( cEmail )
                                                    
	cAssunto	:= "Requerimento: " + RTrim( JBF->JBF_DESC ) + If( cTipo == "2", " RA: ", " RG: " ) + cCodIde
                                      
	cMsg		:= "Prezado " + cNome
	cMsg		+= CRLF + CRLF
	cMsg		+= "O documento referente a An�lise Curricular j� est� dispon�vel na secretaria." + CRLF
	cMsg		+= "Para que o processo continue, compare�a na secretaria do seu campus para verificar o documento."
	cMsg		+= CRLF + CRLF
	cMsg		+= "Atenciosamente," + CRLF + CRLF
	cMsg		+= "Secretaria de Registros Acad�micos" + CRLF
	cMsg		+= "Microsiga Intelligence"
                                                    
	cMsg		:= CONVCHR_HTM( cMsg )

	ACSendMail( ,,,, cEmail + ";", cAssunto, cMsg )

Else
     
	MsgInfo(	"O e-mail do " + Iif( cTipo == "2", " aluno ", " externo " ) +;
				"n�o foi informado. Ele n�o ser� avisado para comparecer a secretaria e verificar sua An�lise Curricular." )

EndIf

Return( .T. )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACCodDep    � Autor � Gustavo Henrique     � Data � 30/10/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna o codigo do departamento referente a secretaria,      ���
���          �tesouraria, coordenacao, pro-reitoria utilizados nos          ���
���          �requerimentos.                                                ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �ACCodDep        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - Identifica se eh departamento referente a coordenacao	���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACCodDep( cTipo, lCoord, nUnidade, nCurPad )

Local cRet		:= ""           
Local cRA		:= ""
Local cUnidade	:= ""
Local lAchou	:= .F.             
Local aRet		:= {}
Local cCodCur	:= ""
Local lWeb      := IsBlind()

lCoord		:= Iif( lCoord == NIL, .F., lCoord )
cTipo		:= Iif( cTipo == NIL, "", cTipo )
nUnidade	:= Iif( nUnidade == NIL, 0, nUnidade )
nCurPad		:= Iif( nCurPad == NIL, 0, nCurPad )

If nUnidade == 0

	cRA	:= Left( iif( lWeb, httpsession->RA, M->JBH_CODIDE ), TamSX3( "JA2_NUMRA" )[1] )

	JBE->( dbSetOrder( 3 ) )
	if JBE->( !dbSeek( xFilial( "JBE" ) + "1" + cRA ) )
		JBE->( dbSetOrder( 1 ) )
		JBE->( dbSeek( xFilial( "JBE" ) + cRA ) )
		
		while JBE->( !eof() ) .and. JBE->JBE_FILIAL+JBE->JBE_NUMRA == xFilial( "JBE" )+cRA
			JBE->( dbSkip() )
		end
		
		JBE->( dbSkip(-1) )
	endif

	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + JBE->JBE_CODCUR ) )
            
	cUnidade := JAH->JAH_UNIDAD

Else
                                                                               
	If ! Empty( cScript )
		aRet := ACSepara( cScript )
		cUnidade := aRet[ nUnidade ]
	EndIf	

EndIf

If ! Empty( cUnidade )

	If lCoord	// Coordenacao
		
		if nCurPad > 0
			JAH->( dbSetOrder(4) )
			JAH->( dbSeek( xFilial("JAH")+aRet[nCurPad] ) )
			while JAH->( !eof() ) .and. ( JAH->JAH_STATUS <> "1" .or. JAH->JAH_UNIDAD <> cUnidade ).and. JAH->( JAH_FILIAL+JAH_CURSO ) == xFilial("JAH")+aRet[nCurPad]
				JAH->( dbSkip() )
			end
			cCodCur := JAH->JAH_CODIGO
		else
			cCodCur := JBE->JBE_CODCUR
		endif
		
		// Percorre a tabela de coordenadores por curso para identificar o titular
		JAJ->( dbSetOrder( 2 ) )
		JAJ->( dbSeek( xFilial( "JAJ" ) + cCodCur ) )
		
		Do While JAJ->( ! EoF() .and. xFilial( "JAJ" ) == JAJ_FILIAL .and. JAJ_CODCUR == cCodCur )
			If JAJ->JAJ_TIPO == "1"
				lAchou := .T.
				Exit
			EndIf		
			JAJ->( dbSkip() )
		EndDo
	
		If lAchou
		
			// Percorre os departamentos da unidade ate encontrar o departamento do coordenador
			JBJ->( dbSetOrder( 4 ) )
			JBJ->( dbSeek( xFilial( "JBJ" ) + cTipo + cUnidade ) )
			
			While JBJ->( ! EoF() .and. xFilial( "JBJ" ) == JBJ_FILIAL .and. JBJ_TIPO == cTipo .and. JBJ_UNIDAD == cUnidade )
				If JBJ->JBJ_MATRES == JAJ->JAJ_CODCOO
					cRet := JBJ->JBJ_COD
					Exit
				EndIf	
				JBJ->( dbSkip() )
			End
			
		EndIf
		
	Else
	    
	    JBJ->( dbSetOrder( 4 ) )
	    
	    If JBJ->( dbSeek( xFilial( "JBJ" ) + cTipo + cUnidade ) )
		    cRet := JBJ->JBJ_COD
		EndIf
	
	EndIf

EndIf
	
Return( cRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACRetAssReq � Autor � Gustavo Henrique     � Data � 01/11/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna a Assinatura, o Nome e o RG do responsavel pelo       ���
���          �departamento.                                                 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �ACRetAssReq     					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPC1 - Identifica se eh departamento referente a coordenacao	���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function ACRetAss( cDep )

Local aRet := {}

cDep := Iif( cDep == NIL, "", cDep )

If ! Empty( cDep )

	JBJ->( dbSetOrder( 1 ) )
	JBJ->( dbSeek( xFilial( "JBJ" ) + cDep ) )
	
	SRA->( dbSetOrder( 1 ) )
	SRA->( dbSeek( xFilial( "SRA" ) + JBJ->JBJ_MATRES ) )
	
	AAdd( aRet, RTrim( SRA->RA_NOME ) )
	AAdd( aRet, RTrim( JBJ->JBJ_CARGO ) )
	AAdd( aRet, RTrim( JBJ->JBJ_RG ) )

Else

	AAdd( aRet, " " )
	AAdd( aRet, " " )
	AAdd( aRet, " " )

EndIf

Return( aRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACLibVaga � Autor � Gustavo Henrique   � Data �  24/03/03  ���
�������������������������������������������������������������������������͹��
���Descricao � Libera vaga do aluno no curso, periodo letivo e turma e    ���
���          � exclui os seus titulos em aberto.                          ���
�������������������������������������������������������������������������͹��
���Utilizacao� Requerimentos de Trancamento, Desistencia, Cancelamento    ���
���          � e Guia de Transferencia.                                   ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Numero do RA do aluno                              ���
���          � EXPC2 - Codigo do curso                                    ���
���          � EXPC3 - Periodo Letivo do curso                            ���
���          � EXPC4 - Turma                                              ���
���          � EXPC5 - Vetor com os prefixos validos no sistema           ���
���          � EXPC6 - Situacao da disciplina                             ���
���          � EXPC7 - Situacao do aluno na disciplina                    ���
���          � EXPC8 - Situacao do aluno no curso                         ���
���          � EXPC9 - Habilitacao                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Gestao Educacional                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACLibVaga( cNumRA, cCurso, cPerLet, cTurma, aPrefixo, cSitDis, cJC7Situ, cJBESitu,cHabili )

local cDiscip	:= ""

aPrefixo	:= IIf(Empty( aPrefixo ),ACPrefixo(),aPrefixo)

begin transaction

	JBE->( dbSetOrder( 3 ) )
	
	if JBE->( dbSeek( xFilial("JBE") + "1" + cNumRA + cCurso + cPerLet + cHabili + cTurma ) )

		//�������������������������������������������������������������������������������������Ŀ
		//� Percorre todas as disciplinas do aluno no curso e modifica a situacao para trancado �
		//���������������������������������������������������������������������������������������
		AcaVerJBO( JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, JBE->JBE_TURMA, if( JBE->JBE_SITUAC == "1", 2, 5 ) )
		AcaVerJAR( JBE->JBE_CODCUR, JBE->JBE_PERLET, JBE->JBE_HABILI, if( JBE->JBE_SITUAC == "1", 2, 5 ) )
		 
		JBM->( dbSetOrder( 2 ) )
		
		if JBM->( dbSeek( xFilial("JBM") + PadR( cNumRA, TamSX3( "JBM_CODIDE" )[1] ) + "2" + JBE->( JBE_CODCUR + JBE_PERLET + JBE_HABILI ) ) )
			RecLock("JBM",.F.)
			JBM->( dbDelete() )
			JBM->( msUnlock() )
		endif
		  
		JC7->( dbSetOrder(1) )
		JC7->( dbSeek( xFilial("JC7")+JBE->JBE_NUMRA+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA ) )
		
		do while JC7->( !eof() .and. JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA == xFilial("JC7")+JBE->JBE_NUMRA+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA )
		 
			// desfaz a aloca��o da vaga do aluno na disciplina, quando for o caso.
			If Posicione("JAE",1,xFilial("JAE") + JC7->JC7_DISCIP,"JAE_CONVAG") == "1" .and. !JC7->JC7_SITUAC$"789A" .and. JBE->JBE_ATIVO == "1"
				AcaVerJCE( JC7->JC7_CODCUR, JC7->JC7_PERLET, JC7->JC7_HABILI, JC7->JC7_TURMA, JC7->JC7_DISCIP, JC7->JC7_CODLOC, JC7->JC7_CODPRE, JC7->JC7_ANDAR, JC7->JC7_CODSAL, JC7->JC7_DIASEM, JC7->JC7_HORA1, JC7->JC7_HORA2, if( JBE->JBE_SITUAC == "1", 2, 5 ) )
			EndIf
		   
			cDiscip := JC7->JC7_DISCIP
		   
			// percorre a mesma disciplina alterando a situacao no JC7
			while JC7->( ! eof() .And. JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP == xFilial("JC7")+JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA+cDiscip ) )
				RecLock("JC7", .F.)
				JC7->JC7_SITDIS := cSitDis	
				JC7->JC7_SITUAC := cJC7Situ	
				JC7->( msUnlock() )
				JC7->( dbSkip() )
			end
		end
		
		//���������������������������������������������������������������������������������������������Ŀ
		//� Verifica se existem t�tulos em aberto para o aluno, caso exista exclui os t�tulos em aberto �
		//�����������������������������������������������������������������������������������������������
		ACVerBol( cNumRA, JBE->JBE_CODCUR, JBE->JBE_PERLET, "", "",, .F., JBE->JBE_HABILI )
    
		//�������������������������������������������������������
		//� Modifica a situacao do aluno no curso para trancado �
		//�������������������������������������������������������
		RecLock("JBE", .F.)
		JBE->JBE_ATIVO	:= cJBESitu
		JBE->JBE_DTSITU	:= dDatabase
		JBE->( msUnlock() )
		
	endif
	
end transaction

Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACValPrz �Autor  � Gustavo Henrique   � Data �  25/03/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida se o requerimento de trancamento, cancelamento ou   ���
���          � desistencia esta sendo solicitado entre antes dos 30 dias  ���
���          � do ultimo mes do periodo letivo. Retorna .F. se estiver    ���
���          � dentro do periodo.                                         ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Codigo do curso                                    ���
���          � EXPC2 - Periodo letivo                                     ���
���          � EXPC3 - Habilitacao                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACValPrz( cCurso, cPerLet, cHabili )
                               
local dUltPer	
local nDias   := 0

JAR->( dbSetOrder( 1 ) )
JAR->( dbSeek( xFilial( "JAR" ) + cCurso + cPerLet + cHabili ) )
                         
dUltPer := LastDay( JAR->JAR_DATA2 )	// Ultimo dia do mes do periodo letivo
nDias	:= dUltPer - dDataBase			// Numero de dias antes de terminar o mes do periodo letivo

Return( ! ( nDias > 0 .and. nDias <= 30 ) )
              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACMatPaga � Autor � Gustavo Henrique   � Data �  25/03/03  ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se existem titulos de matricula em aberto para o  ���
���          � aluno. Se existir retorna .F.                              ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Codigo do curso                                    ���
���          � EXPC2 - Periodo letivo                                     ���
���          � EXPC3 - Numero do RA do aluno                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACMatPaga( cCurso, cPerLet, cNumRA )
                                                
local aPrefixo	:= ACPrefixo()
Local cNrDoc	:= ""
local lRet		:= .T.

cNrDoc := cCurso + cPerLet + Space( TamSX3("E1_NRDOC" )[1] - Len( cCurso + cPerLet ) )

JA2->( dbSetOrder( 1 ) )
JA2->( dbSeek( xFilial( "JA2" ) + cNumRA ) )

SE1->( dbSetOrder(9) ) 	// NumDoc + Prefixo + Cliente + Loja
SE1->( dbSeek( xFilial( "SE1" ) + cNrDoc + aPrefixo[__MAT] + JA2->( JA2_CLIENT + JA2_LOJA ) ) )

do while SE1->(	! EoF() .and. E1_FILIAL + E1_NRDOC + E1_PREFIXO + E1_CLIENTE + E1_LOJA == ;
				xFilial( "SE1" ) + cNrDoc + aPrefixo[__MAT] + JA2->( JA2_CLIENT + JA2_LOJA ) )

	if SE1->( Empty( E1_BAIXA ) .and. E1_SALDO > 0 )
		lRet := .F.
		exit
	endif
	
	SE1->( dbSkip() )	
	
enddo	

Return( lRet )



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACAGradeOk � Autor � Gustavo Henrique   � Data �  05/08/03 ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se o periodo letivo da analise da grade foi       ���
���          � preenchido.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Requerimentos de Transferencia de Curso/Externos e Retorno ���
���          � de Aluno.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACAGradeOk()

Local lRet := .T.

// Posiciona na analise da grade curricular da solicitacao
JCS->( dbSetOrder(1) )	// JCS_FILIAL+JCS_NUMREQ
JCS->( dbSeek(xFilial("JCS")+JBH->JBH_NUM) )

// Deve preencher o periodo letivo na analise da grade para poder matricular o aluno 
If Empty( JCS->JCS_SERIE )
	MsgInfo( "O Periodo Letivo n�o foi informado na Analise da Grade Curricular." )
	lRet := .F.
EndIf

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACAFilRA  � Autor � Gustavo Henrique   � Data �  16/03/04  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao de filtro tipo 07 da consulta J19 e J34 utilizada   ���
���          � em algumas solicitacoes de requerimentos                   ���
�������������������������������������������������������������������������͹��
���Uso       � Gestao Educacional - Filtro tipo 07 da consulta J19/J34    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACAFilRA(cRA)

local lWeb := IsBlind()
                       
if lWeb
	cRet := xFilial("JBE")+cRA
else	
	cRet := xFilial("JBE")+Subs(cRA,1,TamSX3("JBH_CODIDE")[1])
endif

Return( cRet )
