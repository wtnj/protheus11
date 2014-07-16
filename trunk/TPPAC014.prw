#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAC014  � Autor � HANDERSON DUARTE   � Data �  17/02/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro Hist�rico do Processo                             ���
���          � Tabelas ZC9 e ZCK                                          ���
�������������������������������������������������������������������������͹��
���Uso       � WHB MP10 R 1.2 MSSQL                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������`������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TPPAC014 () 
Local aCores := {{"Empty(ZC9_STATUS)"	,"BR_AMARELO" },; //Pendente
                 {"ZC9_STATUS=='S'"     ,"BR_VERDE"},;    //Aprovado
                 {"ZC9_STATUS=='N'"		,"DISABLE" }}     //Reprovado
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persist�ncias forem conclu�das com �xito.
Private cCadastro 	:=	"Cadastro de An�lise Cr�tica Comercial"
Private cPermiss	:=	"{"+Getmv("WHB_APRHIS")+"}"
Private aPermiss	:=	&cPermiss   //Indica quais os usuario (QAA) poderao aprovar o processo de Historicos do Processo. Ex.: "1234567890","0123456789"

Private cCadastro := "Cadastro de Hist�rico do Processo" 


Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"U_PPAC014A (2)"	,0,2} ,;
        		     {"Incluir"		,"U_PPAC014A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC014A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC014A (5)"	,0,5} ,;
        		     {"Aprovar/Reprovar","U_PPAC014A (6)"	,0,6},;
        		     {"Imprimir"	,"U_TPPAR012"	,0,7},;        		     
        		     {"Legenda		","U_PPAC014H"	,0,8}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC9"

dbSelectArea("ZC9")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC014H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"}})
Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC014A (nOpc) 
Local aAreaZC9	:=	ZC9->(GetArea())
Local aAreaZCK	:=	ZCK->(GetArea())
Local nRecZC9	:=	IIF(nOpc<>3,ZC9->(RecNo()),0) 
Local cTexto	:=	""
Local cTitulo	:=	""
Local lFlag		:=	.T.
Do Case
	Case nOpc==2//Visualizar
		sfTela	("ZC9",nRecZC9,nOpc)
	Case nOpc==3//Inclusao
		sfTela	("ZC9",nRecZC9,nOpc)
	Case nOpc==4//Altera��o
		If Empty(ZC9->ZC9_STATUS)
			sfTela	("ZC9",nRecZC9,nOpc)		
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC014->PPAC014A("+AllTrim(Str(nOpc))+") Altera��o"	
			cTexto		:=	"O registro n�o pode ser alterado, pois j� foi aprovado/reprovado."			
		EndIf	
	Case nOpc==5//Exclusao
		lFlag		:=	.F.		
		cTitulo		:=	"TPPAC014->PPAC014A("+AllTrim(Str(nOpc))+") Excluir"	
		cTexto		:=	"N�o � permitido excluir registros"				
		
	Case nOpc == 6 //Aprovar/Reprovar
		If Empty(ZC9->ZC9_STATUS) 
			sfAprovar (nRecZC9,nOpc)	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC014->PPAC014A("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro n�o pode ser alterado, pois j� foi aprovado/reprovado."							
		EndIf		
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC014->PPAC014A("+AllTrim(Str(nOpc))+")"
		cTexto:="Opera��o n�o configurada."				
				
EndCase
RestArea(aAreaZC9)
RestArea(aAreaZCK)
If !lFlag
	Aviso(cTitulo,cTexto,{"OK"},2)
EndIf
Return ()
//==========================Fim da Incluis�o de Registros==========================================
//===============================Aprova��o de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC9	:=	ZC9->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC9->ZC9_STATUS) .OR. AllTrim(ZC9->ZC9_STATUS)=="N" )//S� poder� ser aprovado caso o pedido que ainda n�o esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
	  aUser := PswRet() // Retorna vetor com informa��es do usu�rio
	EndIf
	
	DBSelectArea("QAA") 
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))
		Do While QAA->(!EoF()) .AND. ALltrim(QAA->QAA_LOGIN)==AllTrim(aUser[1][2]) .AND. lFlag  
			If !Empty(AScan(aPermiss,ALLTRIM(QAA->QAA_MAT)))  
				lFlag:=.F.			
			Else 			
			    lFlag:=.T.					
			EndIf     
			If !lFlag	
				If !APMsgNoYes("Aprovar o Registro","Aprovar?")
					Processa({||sfAprvRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL)}) //Reprovar
				Else
					Processa({||sfAprvRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)})	//Aprovar		
				EndIf
			Else
		   		MsgStop("Usu�rio sem permiss�o para aprovar o documento. Usu�rio sem ou com cadastro desatualizado QAA","TPPAC014->PPAC014A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")				
			EndIf				
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usu�rio sem permiss�o para aprovar o documento.","TPPAC014->PPAC014A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")
	EndIf
Else
	MsgAlert("S� poder� ser Aprovado/Reprovado caso o registro n�o tenha passado pela opera��o. Registro j� Aprovado/Reprovado.",;
			"TPPAC014->PPAC014A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprova��o")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC9)

Return ()
//==========================Fim da Aprova��o de Registros========================================== 
//================================APROVA��O OU REPROVA��O DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC9	:= 	ZC9->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cTexto	:=	""
Local cTitulo	:=	""
//Cria Variavel de Quebra de Linha
Local cEOL	:= "CHR(13)+CHR(10)"
cEOL		:= &cEOL
dbSelectArea("ZC9")
ZC9->(DBSetOrder(1)) //ZC9_FILIAL, ZC9_NUMHIS, R_E_C_N_O_, D_E_L_E_T_
ZC9->(DBGoTo(nRecNo))   
BEGIN TRANSACTION
	Do Case
		Case	ZC9->ZC9_RESP==cMatr //Produ��o
			If Empty(DtoS(ZC9->ZC9_APPRO))
				lFlag:=RecLock("ZC9",.F.)
					ZC9->ZC9_APPRO		:=dDataBase		
				ZC9->(MsUnLock())
				ZC9->(DBSkip())
				If !lFlag
					lFlag:=.F.
					cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
					cTitulo:="TPPAC014->PPAC014A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"					
				EndIf
			Else 
				lFlag:=.F.
				cTexto:="O Registro j� foi aprovada pela Produ��o e n�o poder� ser alterada a data da mesma"
				cTitulo:="TPPAC014->PPAC014A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"
			EndIf 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usu�rio n�o faz parte do documento. A opera��o n�o proder� ser gravada."
			cTitulo:="TPPAC014->PPAC014A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"
			
	EndCase
	
	If lFlag 
		dbSelectArea("ZC9")  
		ZC9->(DBSetOrder(1)) //ZC9_FILIAL, ZC9_NUMHIS, R_E_C_N_O_, D_E_L_E_T_
		ZC9->(DBGoTo(nRecNo))
		If nOpc==7  //Aprova��o
			If !Empty(DtoS(ZC9->ZC9_APPRO)) //Se todas as datas estiverem preenchida o registro est� aprovado			
				lFlag:=RecLock("ZC9",.F.)
					ZC9->ZC9_STATUS		:="S"
				ZC9->(MsUnLock())
				If !lFlag
					lFlag:=.F.
					cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
					cTitulo:="TPPAC014->PPAC014A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"					
				EndIf						 	
			EndIf
		ElseIf nOpc==8//Reprova��o 
			lFlag:=RecLock("ZC9",.F.)
				ZC9->ZC9_STATUS		:="N"
			ZC9->(MsUnLock())
			If !lFlag
				lFlag:=.F.
				cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
				cTitulo:="TPPAC014->PPAC014A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprova��o"					
			EndIf
		EndIf
	EndIf
	
	If  !lFlag  //Desfaz a transa��o se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	Aviso(cTitulo,cTexto,{"OK"},2)
EndIf
If lFlag .AND. nOpc==7//Aprovado
	cMensagem	:=	cCadastro+" "+ZC9->ZC9_NUMHIS+cEOL		 				
	cMensagem	+=	"Data do registro "+DtoC(ZC9->ZC9_DATA)+cEOL
	cMensagem	+=	"Pe�a "+ZC9->ZC9_PECA+"-"+ZC9->ZC9_REVPC+cEOL
	cMensagem	+=	"Cliente "+ZC9->ZC9_CLIENT+"-"+ZC9->ZC9_LOJA+cEOL	
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZC9->ZC9_EMITEN,"QAA_EMAIL")
	//Chamada da func�o do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Aprovado "+cCadastro,ZC9->ZC9_NUMHIS,"XX",cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Aprovado "+cCadastro+" "+ZC9->ZC9_NUMHIS ,cEMail,"",)})
	EndIf
		
EndIf

If lFlag .AND. nOpc==8//Reprova��o 		
	While Empty(cMensagem)	 
		Alert('O preenchimento da Justificativa de Reprova��o � obrigatorio!')	
		cMensagem:=sfJustif ( )	//chamada da tela de justificativa
	EndDo			
	//Grava na tabela de justificativas
	dbSelectArea("ZC9")
	ZC9->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC9->ZC9_NUMHIS
		ZCC->ZCC_REV	:=	"XX"			
		ZCC->ZCC_TABELA	:=	"ZC9"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC9->ZC9_EMITEN,"QAA_EMAIL")
	//Chamada da func�o do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprova��o "+cCadastro,ZC9->ZC9_NUMHIS,"XX",cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprova��o "+cCadastro+" "+ZC9->ZC9_NUMHIS ,cEMail,"",)})
	EndIf
		
EndIf

RestArea(aAreaZC9)
Return( )
//========================FIM DA  APROVA��O OU REPROVA��O =========================================
//==========================Monta a Tela ==========================================================
Static Function sfTela(cAlias,nReg,nOpc)

Local oDlg		:= NIL
Local lOk 		:= .F.
Local aButtons	:= {} 
Local nCont		:=	0
Local aAreaZC9	:=	ZC9->(GetArea())
Local aAreaZCK	:=	ZCK->(GetArea())
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aInfo     := {}
Local aCpos     := Nil
Local nOpcA 	:= 0
Local nCntFor	:= 0
Local nGetLin   := 0
Local nUsado	:= 0 
Local lTransf	:= .F.                                   
Local lProperty := .F.
Local lMemory   := .F.                          
Local oGetD 

//������������������������������������������������������Ŀ
//� Variaveis utilizadas na LinhaOk                      �
//��������������������������������������������������������
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aColsGrade := {}
PRIVATE aHeadgrade := {}
PRIVATE aHeadFor   := {}
PRIVATE aColsFor   := {}
PRIVATE N          := 1

Private aTELA[0][0],aGETS[0]


//aCposAlt := { "ZC9_UNID", "ZC9_DOCTO", "ZC9_REVDOC" }
				

DbSelectArea(cAlias)
If (nOpc == 3)	
	RegToMemory( cAlias, .T., .F. )
Else 
	RegToMemory( cAlias, .F., .F. )
EndIf	


//������������������������������������������������������Ŀ
//� Montagem do aHeader                                  �
//��������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)    
MsSeek("ZCK")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZCK") )
	If ( X3USO(SX3->X3_USADO) .And.	cNivel >= SX3->X3_NIVEL )
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo
//������������������������������������������������������Ŀ
//�Montagem do aCols                                     �
//��������������������������������������������������������  
If nOpc	==	3
	M->ZC9_NUMHIS	:=GETSXENUM("ZC9","ZC9_NUMHIS")
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		If ( AllTrim(aHeader[nCntFor][2]) == "ZCK_ITEM" )	
			aCols[1][nCntFor] := "01"
		EndIf
	Next nCntFor
	aCOLS[1][Len(aHeader)+1] := .F.
Else
	DBSelectArea("ZCK")	
	ZCK->(DBSetOrder(1))
	ZCK->(DBSeek(xFilial("ZCK")+ZC9->(ZC9_NUMHIS)))
	Do While ZCK->(!EoF()) .AND. (xFilial("ZCK")+ZC9->(ZC9_NUMHIS)) == (ZCK->(ZCK_FILIAL+ZCK_NUMHIS))	
		nCont++   //Verifica o tamanho do aCols
		ZCK->(DBSkip())
	EndDo	 
	aCols:=Array(nCont,nUsado+1)
	nUsado:=0
	nCont:=1	
	ZCK->(DBSetOrder(1))
	ZCK->(DBSeek(xFilial("ZCK")+ZC9->(ZC9_NUMHIS)))
	Do While ZCK->(!EoF()) .AND. ((ZCK->(ZCK_FILIAL+ZCK_NUMHIS)) == (xFilial("ZCK")+ZC9->(ZC9_NUMHIS)))
		dbSelectArea("Sx3")
		SX3->(dbSeek("ZCK"))
		While SX3->(!Eof()) .And. (x3_arquivo == "ZCK")
			IF cNivel >= x3_nivel .AND. X3USO(x3_usado) 
				nUsado++ 			
    	        aCOLS[nCont][nUsado] :=ZCK->&(SX3->X3_CAMPO)		    
		   	Endif
			SX3->(dbSkip())
		EndDo
		aCOLS[nCont][nUsado+1] := .F.			
		nCont++ 
		nUsado:=0
		ZCK->(DBSkip())
	EndDo 	
EndIf  


//��������������������������������������������������������������Ŀ
//� Monta Enchoice                                               �
//����������������������������������������������������������������

//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )	


aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
nGetLin := aPosObj[3,1]

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
						
//RegToMemory(cAlias,(nOpc == 3))  
//RegToMemory(cAlias,.T.)  
EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],,,,,)

//Enchoice(cAlias,nReg,IIF(nOpc==6,4,nOpc), , , ,aCposVis ,{14,03,110,570}, , , , ,) 
//		                     1          2           3        4       5          6          7              8            9
//					   ( nSuperior, nEsquerda, nInferior, nDireita, nOpc, [ cLinhaOk ], [ cTudoOk ], [ cIniCpos ], [ lApagar ], 
//							10          11       12           13         14              15             16         17            18
//						[ aAlter ], [ uPar1 ], [ lVazio ], [ nMax ], [ cCampoOk ], [ cSuperApagar ], [ uPar2 ], [ cApagaOk ], [ oWnd ] )
//							1            2            3             4        5    	 6 				7     8   					 9  	 10 11 12 13 14 15 16 17  18
oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_PPAC014E('Linha')","U_PPAC014E('Tudo')","+ZCK_ITEM" ,.T.,  ,  ,  ,  ,  ,  ,  ,  ,	,)		
Private oGetDad:=oGetD
                        
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk := sfTudOk (nOpc,nReg), Iif(lOk,oDlg:End(),)},{||oDlg:End()}, , )

If lOk .and. (nOpc == 3 .or. nOpc == 4)
   	Processa({||sfGravar(cAlias,nOpc,nReg)})
Endif

If nOpc == 5 .and. lOk
//	A280Dele()
Endif
RestArea(aAreaZC9)
RestArea(aAreaZCK)
Return 
//===========================Fun��o para Gravar os Registros=======================================
Static Function sfGravar(cAlias,nOpc,nReg)
Local aAreaZC9	:=	ZC9->(GetArea())
Local aAreaZCK	:=	ZCK->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC9->(RecNo()),0)
Local nContHea	:=	0
Local nContCol	:=	0
Local bCampo	:= { |nCPO| Field(nCPO) }
Local lGraOk	:=	.T. 
Local nPosItem	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCK_ITEM"})
Local cMensagem	:=	""
Local cMatr		:=	""
Local cEmail	:=	""

Do Case 
	Case nOpc==3 //Inclusao 
		Begin Transaction
			DbSelectArea(cAlias)
			ZC9->(DbSetOrder(1))//ZC9_FILIAL, ZC9_NUMHIS, R_E_C_N_O_, D_E_L_E_T_		
			If !ZC9->(DBSeek(xFilial(cAlias)+M->(ZC9_NUMHIS)))
				//--------Grava��o do cabe�alho
				lGraOk:=RecLock(cAlias,.T.)
				    If lGraOk//Verifica o transa��o
						For nCont := 1 To FCount()
							If "FILIAL"$Field(nCont)
								FieldPut(nCont,xFilial(cAlias))
							Else
								FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
							Endif
						Next nCont
				    Else 
				    	lGraOk:=.F.
						cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="2-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"	    				
				    EndIf
				ZC9->(MsUnLock())
				//--------Fim da Grava��o do Cabec�lho
				//--------Grava��o dos Itens
				If lGraOk //Se estiver tudo OK, ent�o continua a grava��o dos itens
					DbSelectArea("ZCK")
					ZCK->(DbSetOrder(1))//ZCK_FILIAL, ZCK_NUMHIS, ZCK_ITEM, R_E_C_N_O_, D_E_L_E_T_
					If !ZCK->(DBSeek(xFilial("ZCK")+M->(ZC9_NUMHIS)))
						For nContCol:=1 to Len(aCols)
							If !(aCols[nContCol][Len(aHeader)+1])
								lGraOk:=RecLock("ZCK",.T.)
								If lGraOk
									ZCK->ZCK_FILIAL	:= xFilial("ZCK")
									ZCK->ZCK_NUMHIS:=	M->ZC9_NUMHIS	
									For nContHea := 1 To Len(aHeader)
										Do Case
											Case	AllTrim(aHeader[nContHea][2])=="ZCK_NUMHIS"
												ZCK->ZCK_NUMHIS:=	M->ZC9_NUMHIS 
												
											OtherWise
												ZCK->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
													
										EndCase
									Next nContHea
								Else
									nContCol:=Len(aCols)
							    	lGraOk:=.F.
									cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
									cTexto:="4-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"					
								EndIf
							EndIf
						Next nContCol
					Else
				    	lGraOk:=.F.
						cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="3-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"	    									
					EndIf		
				EndIf
				//------Fim da Grava��o dos Itens
			Else
		    	lGraOk:=.F.
				cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="1-J� Exite registros com tais dados. Registro "+ZC9->ZC9_NUMHIS	
			EndIf
			If  !lGraOk 
				DisarmTransaction()
				RollBackSX8()
			Else
				ConfirmSX8()			
			EndIf	
		End Transaction
		
	Case nOpc	==	4//Alterar 
		Begin Transaction 
			DbSelectArea(cAlias)
			ZC9->(DbSetOrder(1))//ZCK_FILIAL, ZCK_NUMHIS, ZCK_ITEM, R_E_C_N_O_, D_E_L_E_T_
			If ZC9->(DBSeek(xFilial(cAlias)+M->(ZC9_NUMHIS)))
				Do While ZC9->(!EoF()) .AND. (Xfilial("ZC9")+M->(ZC9_NUMHIS))==(ZC9->(ZC9_FILIAL+ZC9_NUMHIS)) .AND. lGraOk
				    If nRecNo<>ZC9->(RecNo())
						lGraOk:=.F.
					Else
						lGraOk:=.T.					
					EndIf
					ZC9->(DBSkip())
				EndDo			
			Else
				lGraOk:=.F.		
			EndIf	
			If  lGraOk
				//--------Grava��o do Cabe�alho
				ZC9->(DBgoto(nRecNo))
				lGraOk:=RecLock(cAlias,.F.)
				    If lGraOk//Verifica o transa��o
						For nCont := 1 To FCount()
							If "FILIAL"$Field(nCont)
								FieldPut(nCont,xFilial(cAlias))
							Else
								FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
							Endif
						Next nCont
				    Else 
				    	lGraOk:=.F.
						cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="2-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"	    				
				    EndIf
				ZC9->(MsUnLock())
				//------Fim da grava��o do cabe�alho
				If lGraOk //Se tudo estiver Ok, ent�o grava os itens
					//------------Grava��o dos Itens
					DbSelectArea("ZCK")
					ZCK->(DbSetOrder(1))//ZCK_FILIAL, ZCK_NUMHIS, ZCK_ITEM, R_E_C_N_O_, D_E_L_E_T_	
					If ZCK->(DBSeek(xFilial("ZCK")+M->(ZC9_NUMHIS)))  //Se  nao encontrar nada, o registro est� corrompido
						For nContCol:=1 to Len(aCols)
							//Posiciona no registo respectivo do aCols
							If ZCK->(DBSeek(xFilial("ZCK")+(M->ZC9_NUMHIS+aCols[nContCol][nPosItem])))
								If !(aCols[nContCol][Len(aHeader)+1])
									lGraOk:=RecLock("ZCK",.F.)
									If lGraOk
										ZCK->ZCK_FILIAL	:= xFilial("ZCK")
										ZCK->ZCK_NUMHIS	:= M->ZC9_NUMHIS											
										For nContHea := 1 To Len(aHeader)
											Do Case
												Case	AllTrim(aHeader[nContHea][2])=="ZCK_NUMHIS"
													ZCK->ZCK_NUMHIS					:=	M->ZC9_NUMHIS													
												OtherWise
													ZCK->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
														
											EndCase	
										Next nContHea
									Else
										nContCol:=Len(aCols)
								    	lGraOk:=.F.
										cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
										cTexto:="6-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"					
									EndIf
									ZCK->(MsUnLock())
								Else//Tratar os deletados
									lGraOk:=RecLock("ZCK",.F.)
									If lGraOk
										DBDELETE()
									Else
										nContCol:=Len(aCols)
								    	lGraOk:=.F.
										cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
										cTexto:="5-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"					
									EndIf										
									ZCK->(MsUnLock())									
								EndIf
							Else//Se nao encontrar, inserir o novo registro
								If !(aCols[nContCol][Len(aHeader)+1])
									lGraOk:=RecLock("ZCK",.T.)
									If lGraOk
										ZCK->ZCK_FILIAL	:= xFilial("ZCK")
										ZCK->ZCK_NUMHIS	:= M->ZC9_NUMHIS											
										For nContHea := 1 To Len(aHeader)
											Do Case
												Case	AllTrim(aHeader[nContHea][2])=="ZCK_CARESP"
													ZCK->ZCK_NUMHIS					:=	M->ZC9_NUMHIS
													
												OtherWise
													ZCK->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
														
											EndCase	
										Next nContHea
									Else
										nContCol:=Len(aCols)
								    	lGraOk:=.F.
										cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
										cTexto:="7-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"					
									EndIf
									ZCK->(MsUnLock())
								EndIf							
							EndIf
						Next nContCol
					Else
				    	lGraOk:=.F.
						cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="4-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"	    									
					EndIf
				Else
			    	lGraOk:=.F.
					cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
					cTexto:="3-Erro ao gravar os dasdos, verifique se h� algum usu�rio realizado altera��es no registro"	    																								
				EndIf
			Else
		    	lGraOk:=.F.
				cTitulo:="TPPAC014->PPAC014A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="1-J� Exite registros com tais dados. Registro "+ZC9->ZC9_NUMHIS
			EndIf	
			If  !lGraOk 
				DisarmTransaction()
				RollBackSX8()
			Else
				ConfirmSX8()			
			EndIf	
		End Transaction
		
EndCase		

If  !lGraOk 
	MsgStop(cTexto,cTitulo)
EndIf

RestArea(aAreaZC9)
RestArea(aAreaZCK)	
Return(lGraOk)
//===========================Fim da Fun��o para gravar os Registros =============================== 
//================================Valida os Dados na Persist�ncia=====================================================================
Static Function sfTudOk (nOpc,nRecNo)
Local aArea		:=	ZC9->(GetArea())
Local aAreaX3	:=	SX3->(GetArea())
Local lRet		:= .T. 
Local aCampo	:=	{}
Local cCampo	:=	""
Local cValid	:=	"" 
Local cTexto	:=	""

dbSelectArea("SX3")
dbSetOrder(1)    
MsSeek("ZC9")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZC9") )
	If ( X3USO(SX3->X3_USADO) .And.	cNivel >= SX3->X3_NIVEL )
   		If AllTrim(SX3->X3_OBRIGAT)=="�"
   			cCampo:=SX3->X3_CAMPO 
            If Empty(SX3->X3_VLDUSER) .OR. Empty(SX3->X3_VALID)
            	Do Case
            		Case SX3->X3_TIPO=="C" .OR. SX3->X3_TIPO=="M"
						If Empty(M->&cCampo)
					   		aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})            			
						EndIf
						
					Case	SX3->X3_TIPO=="D" 
						If Empty(DtoS(M->&cCampo))
							aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})            			
						EndIf 
						
					Case	SX3->X3_TIPO=="N" 
						If M->&cCampo=0
							aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})            			
						EndIf
												
					Case	SX3->X3_TIPO=="L" 
						If Empty(M->&cCampo)
							aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})            			
						EndIf						
							
            	EndCase	
            Else
            	cValid:=IIF( !Empty(SX3->X3_VLDUSER),AllTrim(SX3->X3_VLDUSER),"")		
            	cValid+=IIF( !Empty(SX3->X3_VALID) .AND. !Empty(SX3->X3_VLDUSER),".AND. "+AllTrim(SX3->X3_VALID),IIF(!Empty(SX3->X3_VALID),AllTrim(SX3->X3_VALID),""))            	           		
				If &cValid
					aADD(aCampo,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TITULO})            			
				EndIf            	
	   		EndIf
   		EndIf			
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If  Empty(aCampo)
	Do Case
		Case nOpc==3 //Inclui	
			DbSelectArea("ZC9")
			ZC9->(DbSetOrder(1))//ZC9_FILIAL, ZC9_NUMHIS, R_E_C_N_O_, D_E_L_E_T_			
			If !ZC9->(DBSeek(xFilial("ZC9")+M->(ZC9_NUMHIS)))
				lRet:=.T.
			Else
				lRet:=.F.
				MsgAlert("J� Exite registros com tais dados. Registro "+ZC9->ZC9_NUMHIS,"TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")
			EndIf			
			
			If(M->ZC9_IDENT == "3") .AND. Empty(M->ZC9_ESPEC) .AND. lRet
				lRet := .F.
				MsgAlert("Se o campo Identifica��o(ZC9_IDENT) for igual a '3', ent�o o campo Especifique ser� obrigat�rio (ZC9_ESPEC) .","TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")				
			EndIf
						
			
		Case nOpc==4 //Alterar
			If Empty(ZC9->ZC9_STATUS)
				lRet := .T.			
			Else
				lRet := .F.
				MsgAlert("O registro n�o pode ser alterado, pois j� existe uma data de aprova��o.","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Altera��o")	
			EndIf
			If lRet
				DbSelectArea("ZC9")
				ZC9->(DbSetOrder(1))//ZC9_FILIAL, ZC9_NUMHIS, R_E_C_N_O_, D_E_L_E_T_			
				If ZC9->(DBSeek(xFilial("ZC9")+M->(ZC9_NUMHIS)))
					Do While ZC9->(!EoF()) .AND. (Xfilial("ZC9")+M->(ZC9_NUMHIS))==(ZC9->(ZC9_FILIAL+ZC9_NUMHIS)) .AND. lRet
					    If nRecNo<>ZC9->(RecNo())
							lRet:=.F.
							MsgAlert("J� Exite registros com tais dados. Registro "+ZC9->ZC9_NUMHIS,"TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")
						Else
							lRet:=.T.					
						EndIf
						ZC9->(DBSkip())
					EndDo			
				Else
					lRet:=.F. 
					MsgAlert("J� Exite registros com tais dados. Registro "+ZC9->ZC9_NUMHIS,"TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")		
				EndIf
							
				If(M->ZC9_IDENT == "3") .AND. Empty(M->ZC9_ESPEC) .AND. lRet
					lRet := .F.
					MsgAlert("Se o campo Identifica��o(ZC9_IDENT) for igual a '3', ent�o o campo Especifique ser� obrigat�rio (ZC9_ESPEC) .","TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")				
				EndIf				
			EndIf					
			
	
	EndCase
Else 
	lRet := .F.	
	For nCont:=1 to Len(aCampo)	
		cTexto+="Campo Obrigat�rio "+aCampo[nCont][3]+CHR(13)+CHR(10)
	Next nCont
	//MsgAlert("Verifique os campos obrigat�rio da rotina","TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") btOK") 
	Aviso("Verifique os campos obrigat�rio da rotina. TPPAC014->PPAC014A->sfTudOk("+AllTrim(Str(nOpc))+") btOK",cTexto,{"OK"},2)					
EndIf
If lRet //Verifica o Browser
	lRet:=U_PPAC014E("Tudo")
EndIf
RestArea(aArea)
Return lRet
//=========================Fim da Valida��o dos Dados na Persist�ncia===================================================================
//==========================Fim da Montagem da Tela================================================
User Function PPAC014E (cOpcao)  
Local lRet		:=	.T.          
Local nCont		:=	0
Local nCont2	:=	0
Local nPosMod	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCK_MODDOC"})
Local nPosFol	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCK_FOLHA"})
Local nPosDt	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCK_DTIMP"})

Local cChave	:=	""  //ZCK_MODDOC,ZCK_FOLHA,ZCK_DTIMP
Local cTexto	:=	"" 

Do Case
	Case cOpcao=="Linha"
		For nCont:=1 to Len(aCols)
			If !(aCols[nCont][Len(aHeader)+1])
				cChave	:=	AllTrim(aCols[nCont][nPosMod])+AllTrim(aCols[nCont][nPosFol])+DtoS(aCols[nCont][nPosDt])
				nCont2	:=	1	
				For nCont2:=nCont2+nCont to Len(aCols) 
					If !(aCols[nCont2][Len(aHeader)+1])		
						If cChave == AllTrim(aCols[nCont2][nPosMod])+AllTrim(aCols[nCont2][nPosFol])+DtoS(aCols[nCont2][nPosDt]) //Verifica linha a linha se h� duplicidade
							nCont	:=	Len(aCols)	
							nCont2	:=	Len(aCols)
							lRet	:=	.F.			
						Else
							lRet	:=	.T.		
						EndIf
					EndIf
				Next nCont2
			EndIf	
		Next nCont
		cTexto:="H� registros duplicados"
		If !lRet
			Aviso("Atencao!",cTexto,{"OK"},2)
		EndIf
	
	Case cOpcao=="Tudo"
		For nCont:=1 to Len(aCols)
			If !(aCols[nCont][Len(aHeader)+1])
				cChave	:=	AllTrim(aCols[nCont][nPosMod])+AllTrim(aCols[nCont][nPosFol])+DtoS(aCols[nCont][nPosDt])
				nCont2	:=	1	
				For nCont2:=nCont2+nCont to Len(aCols) 
					If !(aCols[nCont2][Len(aHeader)+1])		
						If cChave == AllTrim(aCols[nCont2][nPosMod])+AllTrim(aCols[nCont2][nPosFol])+DtoS(aCols[nCont2][nPosDt]) //Verifica linha a linha se h� duplicidade
							nCont	:=	Len(aCols)	
							nCont2	:=	Len(aCols)
							lRet	:=	.F.			
						Else
							lRet	:=	.T.		
						EndIf
					EndIf
				Next nCont2
			EndIf	
		Next nCont
		cTexto:="H� registros duplicados"		
		If !lRet
			Aviso("Atencao!",cTexto,{"OK"},2)
		Else 
			lRet:=.F.
			For nCont:=1 to Len(aCols)  //Verifica se h� pelo menos um registro no ZCK
				If !(aCols[nCont][Len(aHeader)+1]) .AND. !Empty(aCols[nCont][nPosMod]) .AND. !Empty(aCols[nCont][nPosFol]).AND. !Empty(DtoS(aCols[nCont][nPosDt]))
					lRet:=.T. 
					nCont:=Len(aCols)	
				Else
					lRet:=.F.
				EndIf		
			Next nCont
		EndIf
		If !lRet
			Aviso("Atencao!","Informe as Modifica��es",{"OK"},2)
		Endif		
EndCase

Return(lRet)
//================================JUSTIFICATIVA DA REPROVA��O======================================
Static Function sfJustif ( )

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private cGetTexto  := ""

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgEmail","oGetTexto","oBtnEnviar","oGetMemo")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlgEmail  := MSDialog():New( 168,253,451,948,"Justificativa da Reprova��o",,,.F.,,,,,,.T.,,,.T. )
//oGetTexto  := TGet():New( 020,004,{|u| If(PCount()>0,cGetTexto:=u,cGetTexto)},oDlgEmail,336,114,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTexto",,)
@ 020,004 GET cGetTexto MEMO SIZE 336,114 OF oDlgEmail PIXEL HSCROLL
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||IIF(!Empty(AllTrim(cGetTexto)),oDlgEmail:End(),)},037,012,,,,.T.,,"",,,,.F. )


oDlgEmail:Activate(,,,.T.)
Return (cGetTexto)
//================================FIM DA REPROVA��O================================================ 
//================================TEXTO JUSTIFICATIVA =============================================
Static Function sfTexto(cTitulo,cNum,cRev,cMatr,cTexto)
Local cHTML		:=	""
Local nCont		:=	0
Local cLinhaObs	:=	""
cHTML	+='<html >'
cHTML	+='<head>'
cHTML	+='<style type="text/css">'
cHTML	+='<!--'
cHTML	+='.style1 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 24px;'
cHTML	+='}'
cHTML	+='.style2 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 14px;'
cHTML	+='}'
cHTML	+='.style3 {font-family: Arial, Helvetica, sans-serif}'
cHTML	+='.style5 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 12px;'
cHTML	+='}'
cHTML	+='.style8 {font-family: Arial, Helvetica, sans-serif; font-size: 10px; }'
cHTML	+='-->'
cHTML	+='</style></head>'

cHTML	+='<body>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><div align="center"><strong><span class="style1">'+cTitulo+' '+cNum+'-'+cRev+'</span></strong></div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="497"><strong><span class="style2">Justificativa:</span></strong></td>'
cHTML	+='  </tr>'
cHTML	+='  <tr>'
cHTML	+='    <td height="142"><div align="left">'
		For nCont := 1 to MLCount( cTexto , 90 )
			cLinhaObs	:=Memoline( cTexto ,90, nCont )
			cHTML	+='      <p class="style3">'+cLinhaObs+'</p>'	  	       		
		Next nCont 
cHTML	+='      <p class="style3">&nbsp;</p>'
cHTML	+='    </div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="508" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="115" class="style5">Respons�vel</td>'
cHTML	+='    <td width="377"><span class="style5">'+Posicione("QAA",1,xFilial("QAA")+cMatr,"QAA_NOME")+' </span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><span class="style8">Mensagem autom�tica do sistema Protheus. Favor n�o responder</span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='</body>'
cHTML	+='</html>'
Return(cHTML)

//================================FIM DO TEXTO JUSTIFICATIVA =============================================