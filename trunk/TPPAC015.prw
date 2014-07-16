#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC015  º Autor ³ HANDERSON DUARTE   º Data ³  26/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro Meios de Controle APQP                            º±±
±±º          ³ Tabelas ZCA e ZCI                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 R 1.2 MSSQL                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±`±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC015 () 
Local aCores := {{"Empty(ZCA_STATUS) .AND. ZCA_STAREV "		,"BR_AMARELO" },; //Pendente
                 {"!ZCA_STAREV"		     					,"BR_PRETO"},;    //Revisão Obsoleta 
                 {"ZCA_STATUS=='S'"     					,"BR_VERDE"},;    //Aprovado                
                 {"ZCA_STATUS=='N'"							,"DISABLE" }}     //Reprovado
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persistências forem concluídas com êxito.
Private cCadastro 	:=	"Cadastro de Meios de Controle APQP"
Private cENGEN 		:=	"{"+Getmv("WHB_ENGEN")+"}"
Private aENGEN		:=	&cENGEN   //indica quais sao os codigos dos usuarios da engenharia que poderao aprovar o documento. (QAA)       Ex.: "000000004","000000005"                      
Private cMETRO 		:=	"{"+Getmv("WHB_METRO")+"}"
Private aMETRO		:=	&cMETRO   //Indica quais sao os codigos dos usuarios da metrollogia que poderao aprovar o documento (QAA).      Ex.: "0000000002","0000000003"                    



Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"U_PPAC015A (2)"	,0,2} ,;
        		     {"Incluir"		,"U_PPAC015A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC015A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC015A (5)"	,0,5} ,;
        		     {"Aprovar/Reprovar","U_PPAC015A (6)"	,0,6},;
        		     {"Gerar Revisão","U_PPAC015A (7)"	,0,7},;        		     
        		     {"Imprimir"	,"U_TPPAR014"	,0,8},;        		     
        		     {"Legenda		","U_PPAC015H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZCA"
//Cria Variavel de Quebra de Linha
Private cEOL	:= "CHR(13)+CHR(10)"
cEOL		:= &cEOL

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC015H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_PRETO"    		,"Obsoleto"	},;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"}})
Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC015A (nOpc) 
Local aAreaZCA	:=	ZCA->(GetArea())
Local aAreaZCI	:=	ZCI->(GetArea())
Local nRecZCA	:=	IIF(nOpc<>3,ZCA->(RecNo()),0) 
Local cTexto	:=	""
Local cTitulo	:=	""
Local lFlag		:=	.T.   
Local cAprovAnt		:= ""
Local cStaRevAnt	:= "" 
Do Case
	Case nOpc==2//Visualizar
		sfTela	("ZCA",nRecZCA,nOpc)
	Case nOpc==3//Inclusao 
		If	!Empty(AScan(aENGEN,ALLTRIM(QA_USUARIO()[3])))
			sfTela	("ZCA",nRecZCA,nOpc)
		Else
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC015->PPAC015A("+AllTrim(Str(nOpc))+") Incluir"	
			cTexto		:=	"O usuário em questão não faz parte da alçada da Engenharia. Verifique o parâmetro WHB_ENGEN."			
		EndIf
	Case nOpc==4//Alteração
		If Empty(ZCA->ZCA_STATUS)
			sfTela	("ZCA",nRecZCA,nOpc)		
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC015->PPAC015A("+AllTrim(Str(nOpc))+") Alteração"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado."			
		EndIf	
	Case nOpc==5//Exclusao
		lFlag		:=	.F.		
		cTitulo		:=	"TPPAC015->PPAC015A("+AllTrim(Str(nOpc))+") Excluir"	
		cTexto		:=	"Não é permitido excluir registros"				
		
	Case nOpc == 6 //Aprovar/Reprovar
		If Empty(ZCA->ZCA_STATUS) 
			sfAprovar (nRecZCA,nOpc)	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC015->PPAC015A("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado."							
		EndIf
	Case nOpc == 7 //Gerar revisão
		If !Empty(ZCA->ZCA_STATUS) .AND. ZCA->ZCA_STAREV   
		
			cAprovAnt	:= ZCA->ZCA_STATUS
			cStaRevAnt	:= ZCA->ZCA_STAREV   
			
			_lRet := sfTela ("ZCA",nRecZCA,nOpc) 
			//alert(_lRet)	                   
/*			If !_lRet
			
				RecLock("ZCA",.F.) 
					DbDelete()
				ZCA->(MsUnLock())
				
				ZCA->(DBGoTo(nRecZCA))    
				RecLock("ZCA",.F.) 
					ZCA->ZCA_STATUS	:= cAprovAnt
					ZCA->ZCA_STAREV := cStaRevAnt
				ZCA->(MsUnLock())
			EndIf    */
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC015->PPAC015A("+AllTrim(Str(nOpc))+") Gerar Revisão"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou se trata de uma revisão obsoleta."							
		EndIf		
				
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC015->PPAC015A("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."				
				
EndCase
RestArea(aAreaZCA)
RestArea(aAreaZCI)
If !lFlag
	Aviso(cTitulo,cTexto,{"OK"},2)
EndIf
Return ()
//==========================Fim da Incluisão de Registros==========================================
//===============================Aprovação de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZCA	:=	ZCA->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZCA->ZCA_STATUS) .OR. AllTrim(ZCA->ZCA_STATUS)=="N" )//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
	  aUser := PswRet() // Retorna vetor com informações do usuário
	EndIf
	
	DBSelectArea("QAA") 
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))  
		Do While QAA->(!EoF()) .AND. QAA->QAA_LOGIN==aUser[1][2] .AND. lFlag
			If QAA->QAA_TPUSR=="1" .AND. (!Empty(AScan(aMETRO,ALLTRIM(QAA->QAA_MAT))) .OR. !Empty(AScan(aENGEN,ALLTRIM(QAA->QAA_MAT)))) .AND. QAA->QAA_STATUS=="1";
				 .AND. QAA->QAA_LOGIN==aUser[1][2] .AND. (dDataBase>=QAA->QAA_INICIO .AND. (dDataBase<=QAA->QAA_FIM .OR. Empty(DtoS(QAA->QAA_FIM))));
				.AND. QAA->QAA_RECMAI=="1" .AND. !Empty(QAA->QAA_EMAIL) 
				
				lFlag:=.F.			
//			Else 			
//				lFlag:=.T.					
			EndIf
//			If lFlag	
				If !APMsgNoYes("Aprovar o Registro","Aprovar?")
					Processa({||sfAprvRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL)}) //Reprovar
				Else
					Processa({||sfAprvRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)})	//Aprovar		
				EndIf
//			Else
//				MsgStop("Usuário sem permissão para aprovar o documento. Usuário sem ou com cadastro desatualizado QAA","TPPAC015->PPAC015A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")				
//			EndIf				
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC015->PPAC015A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser Aprovado/Reprovado caso o registro não tenha passado pela operação. Registro já Aprovado/Reprovado.",;
			"TPPAC015->PPAC015A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZCA)

Return ()
//==========================Fim da Aprovação de Registros========================================== 
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZCA	:= 	ZCA->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cTexto	:=	""
Local cTitulo	:=	""
dbSelectArea("ZCA")
ZCA->(DBSetOrder(1)) //ZCA_FILIAL, ZCA_MEIOS, R_E_C_N_O_, D_E_L_E_T_
ZCA->(DBGoTo(nRecNo))   
BEGIN TRANSACTION
	Do Case
		Case	ZCA->ZCA_RESENG==cMatr //Engenharia
			If Empty(DtoS(ZCA->ZCA_APRENG))
				lFlag:=RecLock("ZCA",.F.)
					ZCA->ZCA_APRENG		:=dDataBase		
				ZCA->(MsUnLock())
				If !lFlag
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf
			Else 
				lFlag:=.F.
				cTexto:="O Registro já foi aprovada pela Engenharia e não poderá ser alterada a data da mesma"
				cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf
			                                                                                      
		Case	ZCA->ZCA_RESMET==cMatr //Metodologia
			If Empty(DtoS(ZCA->ZCA_APRMET))
				lFlag:=RecLock("ZCA",.F.)
					ZCA->ZCA_APRMET		:=dDataBase		
				ZCA->(MsUnLock())
				If !lFlag
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf
			Else 
				lFlag:=.F.
				cTexto:="O Registro já foi aprovada pela Metodologia e não poderá ser alterada a data da mesma"
				cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf			
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
			cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			
	EndCase
	
	If lFlag 
		dbSelectArea("ZCA")  
		ZCA->(DBSetOrder(1)) //ZCA_FILIAL, ZCA_MEIOS,ZCA_REV, R_E_C_N_O_, D_E_L_E_T_
		ZCA->(DBGoTo(nRecNo))
		If nOpc==7  //Aprovação
			If !Empty(DtoS(ZCA->ZCA_APRMET)) .AND. !Empty(DtoS(ZCA->ZCA_APRENG))//Se todas as datas estiverem preenchida o registro está aprovado			
				lFlag:=RecLock("ZCA",.F.)
					ZCA->ZCA_STATUS		:="S"
				ZCA->(MsUnLock())
				If !lFlag
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf						 	
			EndIf
		ElseIf nOpc==8//Reprovaçào 
			lFlag:=RecLock("ZCA",.F.)
				ZCA->ZCA_STATUS		:="N"
			ZCA->(MsUnLock())
			If !lFlag
				lFlag:=.F.
				cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
				cTitulo:="TPPAC015->PPAC015A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Reprovação"					
			EndIf
		EndIf
	EndIf
	
	If  !lFlag  //Desfaz a transação se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	Aviso(cTitulo,cTexto,{"OK"},2)
EndIf
If lFlag .AND. nOpc==7 .AND. (!Empty(DtoS(ZCA->ZCA_APRMET)) .AND. !Empty(DtoS(ZCA->ZCA_APRENG)))//Aprovado
	cMensagem	:=	cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV+cEOL		 				
	cMensagem	+=	"Data do registro "+DtoC(ZCA->ZCA_EMISSA)+cEOL
	cMensagem	+=	"Peça "+ZCA->ZCA_PROD+"-"+ZCA->ZCA_REVPC+cEOL
	cMensagem	+=	"Descrição da Peça "+Posicione("QK1",1,xFilial("QK1")+ZCA->(ZCA_PROD+ZCA_REVPC),"QK1_DESC")+cEOL	
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Aprovado "+cCadastro,ZCA->ZCA_MEIOS,ZCA->ZCA_REV,cMatr,cMensagem)//Para HTML
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESENG,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Aprovado "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf	
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESMET,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Aprovado "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf
		
EndIf

If lFlag .AND. nOpc==8//Reprovaçào 		
	cMensagem:=sfJustif ( )+cEOL	//chamada da tela de justificativa				
	//Grava na tabela de justificativas
	dbSelectArea("ZCA")
	ZCA->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCA")
		ZCC->ZCC_CODDOC	:=	ZCA->ZCA_MEIOS
		ZCC->ZCC_REV	:=	ZCA->ZCA_REV			
		ZCC->ZCC_TABELA	:=	"ZCA"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cMensagem	+=	cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV+cEOL		 				
	cMensagem	+=	"Data do registro "+DtoC(ZCA->ZCA_EMISSA)+cEOL
	cMensagem	+=	"Peça "+ZCA->ZCA_PROD+"-"+ZCA->ZCA_REVPC+cEOL
	cMensagem	+=	"Descrição da Peça "+Posicione("QK1",1,xFilial("QK1")+ZCA->(ZCA_PROD+ZCA_REVPC),"QK1_DESC")+cEOL	
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprovado "+cCadastro,ZCA->ZCA_MEIOS,ZCA->ZCA_REV,cMatr,cMensagem)//Para HTML
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESENG,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovado "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf	
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESMET,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovado "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf
		
EndIf

RestArea(aAreaZCA)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//==========================Monta a Tela ==========================================================
Static Function sfTela(cAlias,nReg,nOpc)

Local oDlg		:= NIL
Local lOk 		:= .F.
Local aButtons	:= {} 
Local nCont		:=	0
Local aAreaZCA	:=	ZCA->(GetArea())
Local aAreaZCI	:=	ZCI->(GetArea())
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na LinhaOk                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aColsGrade := {}
PRIVATE aHeadgrade := {}
PRIVATE aHeadFor   := {}
PRIVATE aColsFor   := {}
PRIVATE N          := 1

Private aTELA[0][0],aGETS[0]


DbSelectArea(cAlias)
If (nOpc == 3)
	RegToMemory( cAlias, .T., .F. )
ElseIf ( nOpc == 7)                
	RegToMemory( cAlias, .F., .F. )
	RegToMemory( cAlias, .T., .F. )
Else 
	RegToMemory( cAlias, .F., .F. )
EndIf	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)    
MsSeek("ZCI")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZCI") )
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aCols                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
If nOpc	==	3
	M->ZCA_MEIOS	:=GETSXENUM("ZCA","ZCA_MEIOS")
	M->ZCA_REV		:="00"
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		If ( AllTrim(aHeader[nCntFor][2]) == "ZCI_ITEM" )	
			aCols[1][nCntFor] := "01"
		EndIf
	Next nCntFor
	aCOLS[1][Len(aHeader)+1] := .F.
Else	
	DBSelectArea("ZCI")	
	ZCI->(DBSetOrder(1)) //ZCI_FILIAL+ZCI_MEIOS+ZCI_REV+ZCI_ITEM
	ZCI->(DBSeek(xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)))
	Do While ZCI->(!EoF()) .AND. (xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)) == (ZCI->(ZCI_FILIAL+ZCI_MEIOS+ZCI_REV))	
		nCont++   //Verifica o tamanho do aCols
		ZCI->(DBSkip())
	EndDo	 
	aCols:=Array(nCont,nUsado+1)
	nUsado:=0
	nCont:=1	
	ZCI->(DBSetOrder(1))//ZCI_FILIAL+ZCI_MEIOS+ZCI_REV+ZCI_ITEM
	ZCI->(DBSeek(xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)))
	Do While ZCI->(!EoF()) .AND. ((ZCI->(ZCI_FILIAL+ZCI_MEIOS+ZCI_REV)) == (xFilial("ZCI")+ZCA->(ZCA_MEIOS+ZCA_REV)))
		dbSelectArea("Sx3")
		SX3->(dbSeek("ZCI"))
		While SX3->(!Eof()) .And. (x3_arquivo == "ZCI")
			IF cNivel >= x3_nivel .AND. X3USO(x3_usado) 
				nUsado++
				Do case
					Case AllTrim(SX3->X3_CAMPO)== "ZCI_DESOPE" //Índice 2 da Tabela QKK -> QKK_FILIAL+QKK_PECA+QKK_REV+QKK_NOPE
						aCOLS[nCont][nUsado] :=Posicione("QKK",2,xFilial("QKK")+ZCA->(ZCA_PROD+ZCA_REVPC)+ZCI->(ZCI_NOPE),"QKK_DESC")
						
					Case AllTrim(SX3->X3_CAMPO)== "ZCI_DESINS" //Índice 2 da Tabela QM2 -> QM2_FILIAL+QM2_INSTR+QM2_REVINV
						aCOLS[nCont][nUsado] :=Posicione("QM2",1,xFilial("QM2")+ZCI->(ZCI_CODINS+ZCI_REVINS),"QM2_DESCR")						
						
					OtherWise 			
		    	        aCOLS[nCont][nUsado] :=ZCI->&(SX3->X3_CAMPO)					
		    	        
				EndCase			    
		   	Endif
			SX3->(dbSkip())
		EndDo
		aCOLS[nCont][nUsado+1] := .F.			
		nCont++ 
		nUsado:=0
		ZCI->(DBSkip())
	EndDo				 	
EndIf  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Enchoice                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
EnChoice( cAlias, nReg, IIF(nOpc==7,3,nOpc), , , , , aPosObj[1],,,,,)  
If nOpc==7//Gera nova revisão
	DBSelectArea("ZCA")
	ZCA->(DBGoto(nReg))
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))    
	MsSeek("ZCA")
	While ( SX3->(!Eof()) .And. (SX3->X3_ARQUIVO == "ZCA") )
		If Empty(AllTrim(SX3->X3_RELACAO))
			M->&(SX3->X3_CAMPO)	:=	ZCA->&(SX3->X3_CAMPO)
		EndIf	
		SX3->(dbSkip())
	EndDo		
					
	M->ZCA_REV		:=	sfRevisao (ZCA->ZCA_MEIOS)
	M->ZCA_STATUS	:=	Space(01)
	M->ZCA_STAREV	:=	.T.             
	M->ZCA_DTREVI	:=	dDataBase	
	M->ZCA_APRENG	:=	CtoD("  /  /  ")
	M->ZCA_APRMET	:=	CtoD("  /  /  ")
	M->ZCA_RESENG	:=	Space(10)
	M->ZCA_RESMET	:=	Space(10)
	M->ZCA_USUALT	:=	QA_USUARIO()[3]
	M->ZCA_ALTERA	:=	Space(150)			

EndIf 

//Enchoice(cAlias,nReg,IIF(nOpc==6,4,nOpc), , , ,aCposVis ,{14,03,110,570}, , , , ,) 
//		                     1          2           3        4       5          6          7              8            9
//					   ( nSuperior, nEsquerda, nInferior, nDireita, nOpc, [ cLinhaOk ], [ cTudoOk ], [ cIniCpos ], [ lApagar ], 
//							10          11       12           13         14              15             16         17            18
//						[ aAlter ], [ uPar1 ], [ lVazio ], [ nMax ], [ cCampoOk ], [ cSuperApagar ], [ uPar2 ], [ cApagaOk ], [ oWnd ] )
//							1            2            3             4        5    	 6 				7     8   					 9  	 10 11 12 13 14 15 16 17  18
oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(nOpc==7,3,nOpc),"U_PPAC015E('Linha')","U_PPAC015E('Tudo')","+ZCI_ITEM" ,.T.,  ,  ,  ,  ,  ,  ,  ,  ,	,)		
Private oGetDad:=oGetD
                        
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk := sfTudOk (nOpc,nReg), Iif(lOk,oDlg:End(),)},{||oDlg:End()}, , )

If lOk .and. (nOpc == 3 .or. nOpc == 4 .or. nOpc == 7)
   	Processa({||sfGravar(cAlias,nOpc,nReg)})
Endif

If nOpc == 5 .and. lOk
//	A280Dele()
Endif
RestArea(aAreaZCA)
RestArea(aAreaZCI)
Return lOk
//===========================Função para Gravar os Registros=======================================
Static Function sfGravar(cAlias,nOpc,nReg)
Local aAreaZCA	:=	ZCA->(GetArea())
Local aAreaZCI	:=	ZCI->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZCA->(RecNo()),0)
Local nRecAtu	:=	0
Local nContHea	:=	0
Local nContCol	:=	0
Local bCampo	:= { |nCPO| Field(nCPO) }
Local lGraOk	:=	.T. 
Local nPosItem	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCI_ITEM"})
Local cMensagem	:=	""
Local cMatr		:=	""
Local cEmail	:=	""

Do Case 
	Case nOpc==3 //Inclusao 
		Begin Transaction
			DbSelectArea(cAlias)
			ZCA->(DbSetOrder(1))//ZCA_FILIAL, ZCA_MEIOS,ZCA_REV, R_E_C_N_O_, D_E_L_E_T_		
			If !ZCA->(DBSeek(xFilial(cAlias)+M->(ZCA_MEIOS+ZCA_REV)))
				//--------Gravação do cabeçalho
				lGraOk:=RecLock(cAlias,.T.)
				    If lGraOk//Verifica o transação
						For nCont := 1 To FCount()
							If "FILIAL"$Field(nCont)
								FieldPut(nCont,xFilial(cAlias))
							Else
								FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
							Endif
						Next nCont
				    Else 
				    	lGraOk:=.F.
						cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="2-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    				
				    EndIf
				ZCA->(MsUnLock())
				//--------Fim da Gravação do Cabecálho
				//--------Gravação dos Itens
				If lGraOk //Se estiver tudo OK, então continua a gravação dos itens
					DbSelectArea("ZCI")
					ZCI->(DbSetOrder(1))//ZCI_FILIAL, ZCI_MEIOS,ZCI_REV, ZCI_ITEM, R_E_C_N_O_, D_E_L_E_T_
					If !ZCI->(DBSeek(xFilial("ZCI")+M->(ZCA_MEIOS+ZCA_REV)))
						For nContCol:=1 to Len(aCols)
							If !(aCols[nContCol][Len(aHeader)+1])
								lGraOk:=RecLock("ZCI",.T.)
								If lGraOk
									ZCI->ZCI_FILIAL	:= xFilial("ZCI")
									ZCI->ZCI_MEIOS	:=	M->ZCA_MEIOS	
									ZCI->ZCI_REV	:=	M->ZCA_REV
									For nContHea := 1 To Len(aHeader)
										ZCI->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
													
									Next nContHea
								Else
									nContCol:=Len(aCols)
							    	lGraOk:=.F.
									cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
									cTexto:="4-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"					
								EndIf
								ZCI->(MsUnLock())
							EndIf
						Next nContCol
					Else
				    	lGraOk:=.F.
						cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="3-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    									
					EndIf		
				EndIf
				//------Fim da Gravação dos Itens
			Else
		    	lGraOk:=.F.
				cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="1-Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "	+ZCA->ZCA_REV
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
			ZCA->(DbSetOrder(1))//ZCI_FILIAL, ZCI_MEIOS,ZCI_REV, ZCI_ITEM, R_E_C_N_O_, D_E_L_E_T_
			If ZCA->(DBSeek(xFilial(cAlias)+M->(ZCA_MEIOS+ZCA_REV)))
				Do While ZCA->(!EoF()) .AND. (Xfilial("ZCA")+M->(ZCA_MEIOS+ZCA_REV))==(ZCA->(ZCA_FILIAL+ZCA_MEIOS+ZCA_REV)) .AND. lGraOk
				    If nRecNo<>ZCA->(RecNo())
						lGraOk:=.F.
					Else
						lGraOk:=.T.					
					EndIf
					ZCA->(DBSkip())
				EndDo			
			Else
				lGraOk:=.F.		
			EndIf	
			If  lGraOk
				//--------Gravação do Cabeçalho
				ZCA->(DBgoto(nRecNo))
					lGraOk:=RecLock(cAlias,.F.)
				    If lGraOk//Verifica o transação
						For nCont := 1 To FCount()
							Do Case
								Case 	Field(nCont)=="ZCA_APRENG"
									FieldPut(nCont,CtoD(" / / "))	 
									
								Case	Field(nCont)=="ZCA_APRMET"
									FieldPut(nCont,CtoD(" / / "))	 
											
							OtherWise								
								If "FILIAL"$Field(nCont)
									FieldPut(nCont,xFilial(cAlias))
								Else
									FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
								Endif 
								
						EndCase									
						Next nCont
				    Else 
				    	lGraOk:=.F.
						cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="2-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    				
				    EndIf
				ZCA->(MsUnLock())
				//------Fim da gravação do cabeçalho
				If lGraOk //Se tudo estiver Ok, então grava os itens
					//------------Gravação dos Itens
					DbSelectArea("ZCI")
					ZCI->(DbSetOrder(1))//ZCI_FILIAL, ZCI_MEIOS,ZCI_REV, ZCI_ITEM, R_E_C_N_O_, D_E_L_E_T_	
					If ZCI->(DBSeek(xFilial("ZCI")+M->(ZCA_MEIOS+ZCA_REV)))  //Se  nao encontrar nada, o registro está corrompido
						For nContCol:=1 to Len(aCols)
							//Posiciona no registo respectivo do aCols
							If ZCI->(DBSeek(xFilial("ZCI")+(M->(ZCA_MEIOS+ZCA_REV)+aCols[nContCol][nPosItem])))
								If !(aCols[nContCol][Len(aHeader)+1])
									lGraOk:=RecLock("ZCI",.F.)
									If lGraOk
										ZCI->ZCI_FILIAL	:= xFilial("ZCI")
										ZCI->ZCI_MEIOS	:= M->ZCA_MEIOS											
										ZCI->ZCI_REV	:= M->ZCA_REV
										For nContHea := 1 To Len(aHeader)
											ZCI->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
										Next nContHea
									Else
										nContCol:=Len(aCols)
								    	lGraOk:=.F.
										cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
										cTexto:="6-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"					
									EndIf
									ZCI->(MsUnLock())
								Else//Tratar os deletados
									lGraOk:=RecLock("ZCI",.F.)
									If lGraOk
										DBDELETE()
									Else
										nContCol:=Len(aCols)
								    	lGraOk:=.F.
										cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
										cTexto:="5-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"					
									EndIf										
									ZCI->(MsUnLock())									
								EndIf
							Else//Se nao encontrar, inserir o novo registro
								If !(aCols[nContCol][Len(aHeader)+1])
									lGraOk:=RecLock("ZCI",.T.)
									If lGraOk
										ZCI->ZCI_FILIAL	:= xFilial("ZCI")
										ZCI->ZCI_MEIOS	:= M->ZCA_MEIOS											
										ZCI->ZCI_REV	:= M->ZCA_REV											
										For nContHea := 1 To Len(aHeader)
											ZCI->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
										Next nContHea
									Else
										nContCol:=Len(aCols)
								    	lGraOk:=.F.
										cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
										cTexto:="7-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"					
									EndIf
									ZCI->(MsUnLock())
								EndIf							
							EndIf
						Next nContCol
					Else
				    	lGraOk:=.F.
						cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="4-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    									
					EndIf
				Else
			    	lGraOk:=.F.
					cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
					cTexto:="3-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    																								
				EndIf
			Else
		    	lGraOk:=.F.
				cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="1-Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "+ZCA->ZCA_REV
			EndIf	
			If  !lGraOk 
				DisarmTransaction()
				RollBackSX8()
			Else
				ConfirmSX8()			
			EndIf	
		End Transaction
		
	Case nOpc==7 //Gera nova revisão
		Begin Transaction
			DbSelectArea(cAlias)
			ZCA->(DbSetOrder(1))//ZCA_FILIAL, ZCA_MEIOS,ZCA_REV, R_E_C_N_O_, D_E_L_E_T_		
			If !ZCA->(DBSeek(xFilial(cAlias)+M->(ZCA_MEIOS+ZCA_REV)))
				//--------Gravação do cabeçalho
				lGraOk:=RecLock(cAlias,.T.)
				    If lGraOk//Verifica o transação
						For nCont := 1 To FCount()
							If "FILIAL"$Field(nCont)
								FieldPut(nCont,xFilial(cAlias))
							Else
								FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
							Endif
						Next nCont
				    Else 
				    	lGraOk:=.F.
						cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="2-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    				
				    EndIf
				ZCA->(MsUnLock())
				//--------Fim da Gravação do Cabecálho
				//--------Gravação dos Itens
				If lGraOk //Se estiver tudo OK, então continua a gravação dos itens
					DbSelectArea("ZCI")
					ZCI->(DbSetOrder(1))//ZCI_FILIAL, ZCI_MEIOS,ZCI_REV, ZCI_ITEM, R_E_C_N_O_, D_E_L_E_T_
					If !ZCI->(DBSeek(xFilial("ZCI")+M->(ZCA_MEIOS+ZCA_REV)))
						For nContCol:=1 to Len(aCols)
							If !(aCols[nContCol][Len(aHeader)+1])
								lGraOk:=RecLock("ZCI",.T.)
								If lGraOk
									ZCI->ZCI_FILIAL	:= xFilial("ZCI")
									ZCI->ZCI_MEIOS	:=	M->ZCA_MEIOS	
									ZCI->ZCI_REV	:=	M->ZCA_REV
									For nContHea := 1 To Len(aHeader)
										ZCI->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea] 
													
									Next nContHea
								Else
									nContCol:=Len(aCols)
							    	lGraOk:=.F.
									cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
									cTexto:="4-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"					
								EndIf
								ZCI->(MsUnLock())
							EndIf
						Next nContCol
					Else
				    	lGraOk:=.F.
						cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
						cTexto:="3-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    									
					EndIf		
				EndIf
				//------Fim da Gravação dos Itens
				//------Atualiza o registro anterior como obsoleto
				DbSelectArea("ZCA")
				nRecAtu:=ZCA->(RecNo())
				ZCA->(Dbgoto(nRecNo))
				lGraOk:=RecLock("ZCA",.F.)
					ZCA->ZCA_STAREV	:=	.F.
				ZCA->(MsUnLock())
				ZCA->(DBGoto(nRecAtu))
				
				If !lGraOk
			    	lGraOk:=.F.
					cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
					cTexto:="5-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
				EndIf				
			Else
		    	lGraOk:=.F.
				cTitulo:="TPPAC015->PPAC015A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="1-Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "	+ZCA->ZCA_REV
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
If lGraOk .AND. nOpc	==	4//Alterar 
	cMensagem	:=	cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV+cEOL		 				
	cMensagem	+=	"Data do registro "+DtoC(ZCA->ZCA_EMISSA)+cEOL
	cMensagem	+=	"Peça "+ZCA->ZCA_PROD+"-"+ZCA->ZCA_REVPC+cEOL
	cMensagem	+=	"Descrição da Peça "+Posicione("QK1",1,xFilial("QK1")+ZCA->(ZCA_PROD+ZCA_REVPC),"QK1_DESC")+cEOL	
	cMensagem	+=	"Motivo "+ZCA->ZCA_ALTERA+cEOL
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Alteração "+cCadastro,ZCA->ZCA_MEIOS,ZCA->ZCA_REV,cMatr,cMensagem)//Para HTML
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESENG,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf	
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESMET,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf		
EndIf
If lGraOk .AND. nOpc	==	7//Gera Revisão
	cMensagem	:=	cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV+cEOL		 				
	cMensagem	+=	"Data do registro "+DtoC(ZCA->ZCA_EMISSA)+cEOL
	cMensagem	+=	"Peça "+ZCA->ZCA_PROD+"-"+ZCA->ZCA_REVPC+cEOL
	cMensagem	+=	"Descrição da Peça "+Posicione("QK1",1,xFilial("QK1")+ZCA->(ZCA_PROD+ZCA_REVPC),"QK1_DESC")+cEOL	
	cMensagem	+=	"Motivo "+ZCA->ZCA_MOTIVO+cEOL
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Nova Revisão "+cCadastro,ZCA->ZCA_MEIOS,ZCA->ZCA_REV,cMatr,cMensagem)//Para HTML
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESENG,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Nova Revisão "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf	
	cEMail		:=	Posicione("QAA",1,xFilial("QAA")+ZCA->ZCA_RESMET,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Nova Revisão "+cCadastro+" "+ZCA->ZCA_MEIOS+"-"+ZCA->ZCA_REV ,cEMail,"",)})
	EndIf		
EndIf

RestArea(aAreaZCA)
RestArea(aAreaZCI)	
Return(lGraOk)
//===========================Fim da Função para gravar os Registros =============================== 
//================================Valida os Dados na Persistência=====================================================================
Static Function sfTudOk (nOpc,nRecNo)
Local aArea		:=	ZCA->(GetArea())
Local aAreaX3	:=	SX3->(GetArea())
Local lRet		:= .T. 
Local aCampo	:=	{}
Local cCampo	:=	""
Local cValid	:=	"" 
Local cTexto	:=	""

dbSelectArea("SX3")
dbSetOrder(1)    
MsSeek("ZCA")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZCA") )
	If ( X3USO(SX3->X3_USADO) .And.	cNivel >= SX3->X3_NIVEL )
   		If AllTrim(SX3->X3_OBRIGAT)=="€"
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
			DbSelectArea("ZCA")
			ZCA->(DbSetOrder(1))//ZCA_FILIAL+ZCA_MEIOS+ZCA_REV			
			If !ZCA->(DBSeek(xFilial("ZCA")+M->(ZCA_MEIOS+ZCA_REV)))
				lRet:=.T.
			Else
				lRet:=.F.
				MsgAlert("Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "+ZCA->ZCA_REV,"TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")
			EndIf
			If M->ZCA_RESENG == M->ZCA_RESMET .AND. lRet
				lRet := .F.
				MsgAlert("Os aprovadores devem ser diferêntes. Verificar os campos RESPONS. MET (ZCA_RESMET) e RESPONS. ENG (ZCA_RESENG).","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")				
			EndIf						
									
			
		Case nOpc==4 //Alterar
			If Empty(ZCA->ZCA_STATUS)
				lRet := .T.			
			Else
				lRet := .F.
				MsgAlert("O registro não pode ser alterado, pois já existe uma data de aprovação.","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Alteração")	
			EndIf
			If lRet
				DbSelectArea("ZCA")
				ZCA->(DbSetOrder(1))//ZCA_FILIAL, ZCA_MEIOS,ZCA_REV, R_E_C_N_O_, D_E_L_E_T_			
				If ZCA->(DBSeek(xFilial("ZCA")+M->(ZCA_MEIOS+ZCA_REV)))
					Do While ZCA->(!EoF()) .AND. (Xfilial("ZCA")+M->(ZCA_MEIOS+ZCA_REV))==(ZCA->(ZCA_FILIAL+ZCA_MEIOS+ZCA_REV)) .AND. lRet
					    If nRecNo<>ZCA->(RecNo())
							lRet:=.F.
							MsgAlert("Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "+ZCA->ZCA_REV,"TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")
						Else
							lRet:=.T.					
						EndIf
						ZCA->(DBSkip())
					EndDo			
				Else
					lRet:=.F. 
					MsgAlert("Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "+ZCA->ZCA_REV,"TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")		
				EndIf
							
				If Empty(M->ZCA_ALTERA) .AND. lRet
					lRet := .F.
					MsgAlert("O campo MOTIVO ALTER (ZCA_ALTERA) é obrigatório.","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")				
				EndIf
				If M->ZCA_RESENG == M->ZCA_RESMET .AND. lRet
					lRet := .F.
					MsgAlert("Os aprovadores devem ser diferêntes. Verificar os campos RESPONS. MET (ZCA_RESMET) e RESPONS. ENG (ZCA_RESENG).","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")				
				EndIf														
			EndIf
		Case nOpc==7 //Gera nova revisão
			DbSelectArea("ZCA")
			ZCA->(DbSetOrder(1))//ZCA_FILIAL+ZCA_MEIOS+ZCA_REV			
			If !ZCA->(DBSeek(xFilial("ZCA")+M->(ZCA_MEIOS+ZCA_REV)))
				lRet:=.T.
			Else
				lRet:=.F.
				MsgAlert("Já Exite registros com tais dados. Registro "+ZCA->ZCA_MEIOS+" Revisão "+ZCA->ZCA_REV,"TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")
			EndIf
			
			If Empty(M->ZCA_MOTIVO) .AND. lRet
				lRet := .F.
				MsgAlert("O campo MOTIVO REV (ZCA_MOTIVO) é obrigatório.","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")				
			EndIf
			If Empty(M->ZCA_USUALT) .AND. lRet
				lRet := .F.
				MsgAlert("O campo Usr Revisão (ZCA_USUALT) é obrigatório.","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")				
			EndIf
			If M->ZCA_RESENG == M->ZCA_RESMET .AND. lRet
				lRet := .F.
				MsgAlert("Os aprovadores devem ser diferêntes. Verificar os campos RESPONS. MET (ZCA_RESMET) e RESPONS. ENG (ZCA_RESENG).","TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")				
			EndIf																															
			
	
	EndCase
Else 
	lRet := .F.	
	For nCont:=1 to Len(aCampo)	
		cTexto+="Campo Obrigatório "+aCampo[nCont][3]+CHR(13)+CHR(10)
	Next nCont
	Aviso("Verifique os campos obrigatório da rotina. TPPAC015->PPAC015A->sfTudOk("+AllTrim(Str(nOpc))+") btOK",cTexto,{"OK"},2)					
EndIf
If lRet //Verifica o Browser
	lRet:=U_PPAC015E("Tudo")
EndIf
RestArea(aArea)
Return lRet
//=========================Fim da Validação dos Dados na Persistência===================================================================
//==========================Fim da Montagem da Tela================================================
User Function PPAC015E (cOpcao)   
Local lRet		:=	.T.      
Local nCont		:=	0
Local nDESCR 	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCI_DESCR"})
Local nNOPE   	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCI_NOPE"})
Local nCODINS 	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCI_CODINS"})
Local nOBS    	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCI_OBS"})
Local nDESOPE   := 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCI_DESOPE"})

Do Case
	Case cOpcao=="Linha" 
		lRet:=.F.
		For nCont:=1 to Len(aCols)// Verifica se a peça do cabecálho é igual a peça dos itens
			If !(aCols[nCont][Len(aHeader)+1]) .AND. ;
			(AllTrim(Posicione("QKK",2,xFilial("QKK")+M->(ZCA_PROD+ZCA_REVPC)+aCols[nCont][nNOPE],"QKK_DESC"))<>AllTrim(aCols[nCont][nDESOPE]))
				lRet:=.F. 
				nCont:=Len(aCols)	
			Else
				lRet:=.T.
			EndIf		
		Next nCont
		If !lRet
			Aviso("Atencao!","As operações não corespondem a peça do cabeçalho do registro. As operações devem ser revisadas",{"OK"},2)
		Endif			
		
	Case cOpcao=="Tudo"
		lRet:=.F.
		For nCont:=1 to Len(aCols)  //Verifica se há pelo menos um registro no ZCI
			If !(aCols[nCont][Len(aHeader)+1]) .AND. ;
			(!Empty(aCols[nCont][nDESCR]) .OR. !Empty(aCols[nCont][nNOPE]).OR. !Empty(aCols[nCont][nCODINS]) .OR. !Empty(aCols[nCont][nOBS]))
				lRet:=.T. 
				nCont:=Len(aCols)	
			Else
				lRet:=.F.
			EndIf		
		Next nCont
		If !lRet
			Aviso("Atencao!","Informe os itens do controle",{"OK"},2)
		Endif
		
		If lRet // Verifica se a peça do cabecálho é igual a peça dos itens
			lRet:=.F.
			For nCont:=1 to Len(aCols)
				If !(aCols[nCont][Len(aHeader)+1]) .AND. ;
				(AllTrim(Posicione("QKK",2,xFilial("QKK")+M->(ZCA_PROD+ZCA_REVPC)+aCols[nCont][nNOPE],"QKK_DESC"))<>allTrim(aCols[nCont][nDESOPE]))
					lRet:=.F. 
					nCont:=Len(aCols)	
				Else
					lRet:=.T.
				EndIf		
			Next nCont
			If !lRet
				Aviso("Atencao!","As operações não corespondem a peça do cabeçalho do registro. As operações devem ser revisadas",{"OK"},2)
			Endif			
		EndIf
			
EndCase

Return(lRet)
//================================JUSTIFICATIVA DA REPROVAÇÃO======================================
Static Function sfJustif ( )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cGetTexto  := ""

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgEmail","oGetTexto","oBtnEnviar","oGetMemo")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgEmail  := MSDialog():New( 168,253,451,948,"Justificativa da Reprovação",,,.F.,,,,,,.T.,,,.T. )
//oGetTexto  := TGet():New( 020,004,{|u| If(PCount()>0,cGetTexto:=u,cGetTexto)},oDlgEmail,336,114,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTexto",,)
@ 020,004 GET cGetTexto MEMO SIZE 336,114 OF oDlgEmail PIXEL HSCROLL
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||IIF(!Empty(AllTrim(cGetTexto)),oDlgEmail:End(),)},037,012,,,,.T.,,"",,,,.F. )


oDlgEmail:Activate(,,,.T.)
Return (cGetTexto)
//================================FIM DA REPROVAÇÃO================================================ 
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
cHTML	+='    <td width="115" class="style5">Responsável</td>'
cHTML	+='    <td width="377"><span class="style5">'+Posicione("QAA",1,xFilial("QAA")+cMatr,"QAA_NOME")+' </span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><span class="style8">Mensagem automática do sistema Protheus. Favor não responder</span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='</body>'
cHTML	+='</html>'
Return(cHTML)
//================================FIM DO TEXTO JUSTIFICATIVA =============================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cMEIOS)
Local cRet		:=	""
Local aAreaZCA	:=	ZCA->(GetArea())
DBSelectArea("ZC4")
ZCA->(DBGoTop())
ZCA->(DBSetOrder(1))//ZCA_FILIAL+ZCA_MEIOS+ZCA_REV
If ZCA->(DBSeek(xFilial("ZCA")+cMEIOS))
	Do While ZCA->(!EoF()) .AND. (ZCA->(ZCA_FILIAL+ZCA_MEIOS)) == ;
			  (xFilial("ZCA")+(cMEIOS))
		cRet:=ZCA->ZCA_REV			 					
		ZCA->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZCA)
Return (cRet)
//================================FIM DA REVISÃO ================================================== 