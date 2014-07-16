#include "Protheus.ch"   
#INCLUDE "Trm070.CH"

User Function Trm070()  

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,IMPRIME")
SetPrvt("LEND,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG")
SetPrvt("TITULO,AT_PRG,CCABEC,WCABEC0,WCABEC1,CONTFL")
SetPrvt("LI,NOPC,NOPCA,WNREL,NTAMANHO,L1VEZ")
SetPrvt("CCANCEL,NY")
SetPrvt("CINICIO,CFIM,CCODTESTE,CDETALHE,CDESCR,NLINHA")
SetPrvt("I,NNUM,CTESTE,CNOME,ASAVEAREA")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TRM070   � Autor � Equipe R.H.			� Data � 23/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os teste conforme parametros selecionados          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���			   �	    �	   �										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
cDesc1  := OemtoAnsi(STR0001) //"Este programa tem como objetivo imprimir os testes"
cDesc2  := OemtoAnsi(STR0002) //"conforme parametros selecionados."
cDesc3  := ""
cString := "SQQ"  	
aOrd    := {}
Imprime := .T.
lEnd    := .F.

//��������������������������������������������������������������Ŀ
//� Define Variaveis (Basicas)                            		 �
//����������������������������������������������������������������
aReturn  := { STR0003,1,STR0004,2,2,1,"",1 } //"Zebrado"###"Administracao"
NomeProg := "TRM070"
aLinha   := {}
nLastKey := 0
cPerg    := "TRM070"

//��������������������������������������������������������������Ŀ
//� Define Variaveis (Programa)                                  �
//����������������������������������������������������������������
Titulo  := OemToAnsi(STR0005) //"Avaliacao"
At_prg  := "TRM070"
cCabec  := ""
wCabec0 := 0
wCabec1 := ""
ContFl  := 1
Li      := 1

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("TRM070",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Teste de                                 �
//� mv_par02        //  Teste ate                                �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
nOpc 	:= 2
nOpca	:= 2
wnrel	:= "TRM070"   					//Nome Default do relatorio em Disco
wnrel	:= SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Return 
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return 
EndIf

RptStatus({|| F003Impr()})

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � F003Impr � Autor � Equipe RH		        � Data � 23/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de impressao das Avaliacoes.                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function F003Impr()
cCabec  := ""
At_prg  := "TRM070"
WCabec0 := 1
WCabec1 := OemtoAnsi(STR0005) //"Avaliacao"
Contfl  := 1
Li      := 0
nTamanho:= "M"    
l1Vez   := .T.
cCancel := STR0007 //"Cancelado pelo usuario"

R003Impri()

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio                                         �
//����������������������������������������������������������������
dbSelectArea("SQQ")
dbSetOrder(1)
dbGoTop()

Set Device To Screen
Set Printer To
Commit

If aReturn[5] == 1
	Ourspool(wnrel)
EndIf

MS_FLUSH()
Return 
         

//��������������������������������������������������������������Ŀ
//� Rotina de Impressao				                             �
//����������������������������������������������������������������
Static Function R003Impri(cTeste)
aSaveArea := GetArea()
dbSelectArea("SQQ")
dbSetOrder(1)
dbSeek(xFilial("SQQ")+mv_par01,.T.)
cInicio := "QQ_FILIAL+QQ_TESTE"
cFim	:= QQ_FILIAL+mv_par02

SetRegua( RecCount() )
cCodTeste:=""
While	!Eof() .And. &cInicio <= cFim

	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Cancela Impress�o ao se pressionar <ALT> + <A>               �
	//����������������������������������������������������������������
	If lEnd
		cDetalhe:= STR0008 //"Cancelado pelo Operador"
		Impr(cDetalhe,"P")
		Exit
	EndIf
	
	If cCodTeste #SQQ->QQ_TESTE
		R003Cabec()
		cCodTeste:= SQQ->QQ_TESTE
	EndIf	

	If li > 55
		cDetalhe:=""
		Impr(cDetalhe,"P")
	EndIf
	
	R003Questoes()
	
	If li > 55
		cDetalhe:=""
		Impr(cDetalhe,"P")
	EndIf
	
	R003Alternat()
	
	dbSelectArea("SQQ")
	dbSkip()

EndDo

cDetalhe:=""
Impr(cDetalhe,"F")

RestArea(aSaveArea)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R003Cabec� Autor � Equipe RH				� Data � 23/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta o cabecalho do teste dependendo da opcao selecionada ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R003Cabec()
cDetalhe:=""
Impr(cDetalhe,"C")
cDetalhe := Space(02)+"** "+OemtoAnsi(STR0009)+SQQ->QQ_TESTE+" - "+SQQ->QQ_DESCRIC //"Avaliacao: "
Impr(cDetalhe,"C")
cDetalhe:=""
Impr(cDetalhe,"C")
Return 
	
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R003Questoes� Autor � Equipe RH		     � Data �23/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime as Questoes do Teste		    	                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/	
Static Function R003Questoes() 
Local i	:= 0

aSaveArea := GetArea()
dbSelectArea("SQO")
dbSetOrder(1)

If dbSeek(xFilial("SQQ")+SQQ->QQ_QUESTAO)
	cDescr:= Alltrim(SQO->QO_QUEST)
	nLinha:= MLCount(cDescr,115)
	For i := 1 to nLinha
		cDetalhe:= Space(05)+IIF(i==1,SQQ->QQ_ITEM+"- ",Space(Len(SQQ->QQ_ITEM))+"  ")+MemoLine(cDescr,115,i,,.T.)
		Impr(cDetalhe,"C")
	Next i	
EndIf

RestArea(aSaveArea)

Return
	
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R003Alternat� Autor � Equipe RH		    � Data � 23/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime as Alternativas das questoes                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/	
Static Function R003Alternat()
Local i := 0

aSaveArea 	:= GetARea()
nNum  		:= 96

If Empty(SQO->QO_ESCALA)
	
	dbSelectArea("SQP")
	dbSetOrder(1)
	If dbSeek(xFilial("SQQ")+SQQ->QQ_QUESTAO)
	
		While !Eof() .And. xFilial("SQQ")+SQQ->QQ_QUESTAO == QP_FILIAL+QP_QUESTAO
			cDescr:= Alltrim(SQP->QP_DESCRIC)
			nLinha:= MLCount(cDescr,110)
			nNum:= nNum + 1
			For i := 1 to nLinha
				cDetalhe:= IIF(i==1,Space(10)+"("+CHR(nNum)+")- ",Space(13))+Memoline(cDescr,110,i,,.T.)
				Impr(cDetalhe,"C")
			Next i	
			dbSkip()
		EndDo
	Else
		cDetalhe:=""
		For i := 1 To 4
			Impr(cDetalhe,"C")
		Next i
	EndIf

Else

	dbSelectArea("RBL") 
	dbSetOrder(1)
	If dbSeek(xFilial("RBL")+SQO->QO_ESCALA)
	
		While !Eof() .And. xFilial("RBL")+SQO->QO_ESCALA == RBL->RBL_FILIAL+RBL->RBL_ESCALA
			cDescr:= Alltrim(RBL->RBL_DESCRI)
			nLinha:= MLCount(cDescr,110)
			nNum:= nNum + 1
			For i := 1 to nLinha
				cDetalhe:= IIF(i==1,Space(10)+"("+CHR(nNum)+")- ",Space(13))+Memoline(cDescr,110,i,,.T.)
				Impr(cDetalhe,"C")
			Next i	
			dbSkip()
		EndDo
	Else
		cDetalhe:=""
		For i := 1 To 4
			Impr(cDetalhe,"C")
		Next i
	EndIf

EndIf
	
cDetalhe:=""
Impr(cDetalhe,"C")

RestArea(aSaveArea)

Return
