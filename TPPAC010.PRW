#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC010  º Autor ³ HANDERSON DUARTE   º Data ³  02/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Características Especiais                      º±±
±±º          ³ Tabelas ZC7 e ZCH                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 R 1.2 MSSQL                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±`±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC010 ()
Local aCores := {{"	ZC7_STAREV	.AND. Empty(ZC7_STATUS)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
{"	!ZC7_STAREV"						       ,"BR_PRETO" },;                //Revisão obsoleta
{"ZC7_STATUS=='S'"       					  ,"BR_VERDE"},;                //Aprovado
{"ZC7_STATUS=='N'"						      ,"DISABLE" }}                //Reprovado

Private cCadastro := "Cadastro de Caracteristicas Especiais"

Private cCargo:="{"+Getmv("WHB_CARGO")+"}"
Private cDepart:="{"+Getmv("WHB_DPTO")+"}"
Private aCargo:=&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart:=&cDepart//Departamentos autorizados a aprovar e geras revisões

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
{"Visualizar"	,"U_PPAC010A (2)"	,0,2} ,;
{"Incluir"		,"U_PPAC010A (3)"	,0,3} ,;
{"Alterar"		,"U_PPAC010A (4)"	,0,4} ,;
{"Excluir"		,"U_PPAC010A (5)"	,0,5} ,;
{"Gerar Revisao","U_PPAC010A (6)"	,0,6} ,;
{"Aprovar/Reprovar","U_PPAC010A (7)"	,0,7},;
{"Imprimir"	,"U_TPPAR005 ()"	,0,8},;
{"Legenda		","U_PPAC010H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC7"

dbSelectArea("ZC7")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC010H()
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
{"BR_VERDE"    		,"Aprovado"	},;
{"DISABLE"    		,"Reprovado"},;
{"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================
User Function PPAC010A (nOpc)
Local aAreaZC7	:=	ZC7->(GetArea())
Local aAreaZCH	:=	ZCH->(GetArea())
Local nRecZC7	:=	IIF(nOpc<>3,ZC7->(RecNo()),0)
Local cTexto	:=	""
Local cTitulo	:=	""
Local lFlag		:=	.T.
Do Case
	Case nOpc==2//Visualizar
		sfTela	("ZC7",nRecZC7,nOpc)
	Case nOpc==3//Inclusao
		sfTela	("ZC7",nRecZC7,nOpc)
	Case nOpc==4//Alteração
		If Empty(ZC7->ZC7_STATUS) .AND. ZC7->ZC7_STAREV
			sfTela	("ZC7",nRecZC7,nOpc)
		Else
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC010->PPAC010A("+AllTrim(Str(nOpc))+") Alteração"
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta"
		EndIf
	Case nOpc==5//Exclusao
		lFlag		:=	.F.
		cTitulo		:=	"TPPAC010->PPAC010A("+AllTrim(Str(nOpc))+") Excluir"
		cTexto		:=	"Não é permitido excluir registros"
	Case nOpc==6//Gerar revisão
		If !Empty(ZC7->ZC7_STATUS) .AND.  ZC7->ZC7_STAREV
			sfTela	("ZC7",nRecZC7,nOpc)
		Else
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC010->PPAC010A("+AllTrim(Str(nOpc))+") Gerar Revisão"
			cTexto		:=	"O registro não pode ser alterado, pois não foi aprovado/reprovado ou é uma revisão obsoleta."
		EndIf
	Case nOpc == 7 //Aprovar/Reprovar
		If Empty(ZC7->ZC7_STATUS) .AND. ZC7->ZC7_STAREV
			sfAprovar (nRecZC7,nOpc)//7
		Else
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC010->PPAC010A("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta."
		EndIf
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC010->PPAC010A("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."
		
EndCase
RestArea(aAreaZC7)
RestArea(aAreaZCH)
If !lFlag
	Aviso(cTitulo,cTexto,{"OK"},2)
EndIf
Return ()
//==========================Fim da Incluisão de Registros==========================================
//===============================Aprovação de Registros ===========================================
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg
Local aUser	 	:= {}
Local aAreaZC7	:=	ZC7->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC7->ZC7_STATUS) .OR. AllTrim(ZC7->ZC7_STATUS)=="N" ) .AND. ZC7->ZC7_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
		aUser := PswRet() // Retorna vetor com informações do usuário
	EndIf
	
	DBSelectArea("QAA")
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))
		Do While QAA->(!EoF()) .AND. QAA->QAA_LOGIN==aUser[1][2] .AND. lFlag
			If QAA->QAA_TPUSR=="1" .AND. !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN))) .AND. QAA->QAA_STATUS=="1";
				.AND. QAA->QAA_LOGIN==aUser[1][2] .AND. (dDataBase>=QAA->QAA_INICIO .AND. (dDataBase<=QAA->QAA_FIM .OR. Empty(DtoS(QAA->QAA_FIM))));
				.AND. QAA->QAA_RECMAI=="1" .AND. !Empty(QAA->QAA_EMAIL)
				
				lFlag:=.F.
				If !APMsgNoYes("Aprovar o Registro","Aprovar?")
					Processa({||sfAprvRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL)}) //Reprovar
				Else
					Processa({||sfAprvRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)})	//Aprovar
				EndIf
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC010->PPAC010A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser Aprovado/Reprovado caso o registro que ainda não esteja aprovado ou que seja uma revisão atualizada",;
	"TPPAC010->PPAC010A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC7)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)
Local aAreaZC7	:= 	ZC7->(GetArea())
Local cMensagem	:=	""
Local cEMail	:=	""
Local lFlag		:=	.T.
Local cTexto	:=	""
Local cTitulo	:=	""
Local nSeq		:=	1//Sequência das perguntas     
Local cNUMQUA	:= ""     
Local cREVQUA	:= ""

dbSelectArea("ZC7")
ZC7->(DBSetOrder(1)) //ZC7_FILIAL, ZC7_CARESP, ZC7_REV, R_E_C_N_O_, D_E_L_E_T_
ZC7->(DBGoTo(nRecNo))
cCARESP	:=	ZC7->ZC7_CARESP
cREVCAR	:=	ZC7->ZC7_REV                 

/*
DbSelectArea("ZC8")
ZC8->(DbSetOrder(2)) // ZC8_FILIAL, ZC8_CODCLI, ZC8_LOJA, ZC8_COPRO, ZC8_REV   
If ZC8->(DbSeek(xFilial("ZC8") + ZC7->ZC7_CODCLI + ZC7->ZC7_LOJA + PadR(AllTrim(ZC7->ZC7_CODWHB), Len(ZC8->ZC8_CODPRO)) + ZC7->ZC7_REV))
	cNUMQUA := ZC8->ZC8_NUMQUA   
	cREVQUA	:= ZC8->ZC8_REV
EndIf
*/

 BEGIN TRANSACTION  
Do Case
	Case	ZC7->ZC7_GERPRO==cMatr //Produção
		nSeq:=1
		If Empty(DtoS(ZC7->ZC7_APPRO))  
			If ZC7->(DBSeek(xFilial("ZC7")+cCARESP+cREVCAR+StrZero(nSeq,2)))
//				Do While ZC7->(!EoF()) .AND. ZC7->(ZC7_FILIAL+ZC7_CARESP+ZC7_REV) == (xFilial("ZC7")+cCARESP+cREVCAR+StrZero(nSeq,2)) .AND. lFlag
				Do While ZC7->(!EoF()) .AND. ZC7->(ZC7_FILIAL+ZC7_CARESP+ZC7_REV) == (xFilial("ZC7")+cCARESP+cREVCAR) .AND. lFlag
					nSeq++
					lFlag:=RecLock("ZC7",.F.)
					ZC7->ZC7_APPRO		:=dDataBase
					ZC7->(MsUnLock())
					ZC7->(DBSkip())
				EndDo
			Else
				!lFlag
				lFlag:=.F.
				cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
				cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma"
			cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
		EndIf
		
	Case	ZC7->ZC7_GERQUA  ==cMatr
		nSeq:=1
		If Empty(DtoS(ZC7->ZC7_APQUA))  
			If ZC7->(DBSeek(xFilial("ZC7")+cCARESP+cREVCAR+StrZero(nSeq,2)))  
//				Do While ZC7->(!EoF()) .AND. ZC7->(ZC7_FILIAL+ZC7_CARESP+ZC7_REV) == (xFilial("ZC7")+cCARESP+cREVCAR+StrZero(nSeq,2)) .AND. lFlag 
				Do While ZC7->(!EoF()) .AND. ZC7->(ZC7_FILIAL+ZC7_CARESP+ZC7_REV) == (xFilial("ZC7")+cCARESP+cREVCAR) .AND. lFlag 
					nSeq++
					lFlag:=RecLock("ZC7",.F.)
					ZC7->ZC7_APQUA		:=dDataBase
					ZC7->(MsUnLock())
					ZC7->(DBSkip())
				EndDo
			Else
				!lFlag
				lFlag:=.F.
				cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
				cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Qualidade e não poderá ser alterada a data da mesma"
			cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
		EndIf
		
	Case	ZC7->ZC7_GERENG  ==cMatr
		nSeq:=1
		If Empty(DtoS(ZC7->ZC7_APENG))
			If ZC7->(DBSeek(xFilial("ZC7")+cCARESP+cREVCAR+StrZero(nSeq,2)))
				Do While ZC7->(!EoF()) .AND. ZC7->(ZC7_FILIAL+ZC7_CARESP+ZC7_REV) == (xFilial("ZC7")+cCARESP+cREVCAR) .AND. lFlag
					nSeq++
					lFlag:=RecLock("ZC7",.F.)
					ZC7->ZC7_APENG		:=dDataBase
					ZC7->(MsUnLock())
					ZC7->(DBSkip())
				EndDo
			else
				!lFlag
				lFlag:=.F.
				cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
				cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Engenharia e não poderá ser alterada a data da mesma"
			cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
		EndIf
		
	OtherWise
		lFlag:=.F.
		cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
		cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
		
EndCase

If lFlag
	dbSelectArea("ZC7")
	ZC7->(DBSetOrder(1)) //ZC7_FILIAL, ZC7_CARESP, ZC7_REV, R_E_C_N_O_, D_E_L_E_T_
	ZC7->(DBGoTo(nRecNo))
	If nOpc==7  //Aprovação
		If !Empty(DtoS(ZC7->ZC7_APPRO)) .AND. !Empty(DtoS(ZC7->ZC7_APQUA)) .AND. !Empty(DtoS(ZC7->ZC7_APENG))//Se todas as datas estiverem preenchida o registro está aprovado
			//	If !Empty(DtoS(ZC7->ZC7_DTPROC)) .AND. !Empty(DtoS(ZC8->ZC8_DTQUAL)) .AND. !Empty(DtoS(ZC8->ZC8_DTENG))//Se todas as datas estiverem preenchida o registro está aprovado
			//	If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)))   

//			Do While ZC8->(!EoF()) .AND. ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) == (xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC7",.F.)
				ZC7->ZC7_STATUS		:="S"
				ZC7->(MsUnLock())
				If !lFlag
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
				EndIf
//			EndDo
		EndIf
	ElseIf nOpc==8//Reprovaçào
		lFlag:=RecLock("ZC7",.F.)
		ZC7->ZC7_STATUS		:="N"
		ZC7->(MsUnLock())
		If !lFlag
			lFlag:=.F.
			cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
			cTitulo:="TPPAC010->PPAC010A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
		EndIf
	EndIf
EndIf

If  !lFlag  //Desfaz a transação se tiver algum erro
	DisarmTransaction()
	RollBackSX8()
EndIf


END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	Aviso(cTexto,cTitulo,{"OK"},2)
EndIf

If lFlag .AND. nOpc==8//Reprovaçào

	While Empty(cMensagem)	 
		Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
		cMensagem:=sfJustif ( )	//chamada da tela de justificativa
	EndDo			
	//Grava na tabela de justificativas
	dbSelectArea("ZC7")
	ZC7->(DBGoTo(nRecNo))
	RecLock("ZCC",.T.)
	ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
	ZCC->ZCC_CODDOC	:=	ZC7->ZC7_CARESP
	ZCC->ZCC_REV	:=	ZC7->ZC7_REV
	ZCC->ZCC_TABELA	:=	"ZC7"
	ZCC->ZCC_TEXTO	:=	cMensagem
	ZCC->ZCC_DATA	:=	dDataBase
	ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERPRO,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprovação "+cCadastro,ZC7->ZC7_CARESP,ZC7->ZC7_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
	EndIf
	
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERQUA  ,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
	EndIf
	
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERENG   ,"QAA_EMAIL")
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
	EndIf
EndIf

RestArea(aAreaZC7)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//==========================Monta a Tela ==========================================================
Static Function sfTela(cAlias,nReg,nOpc)

Local oDlg		:= NIL
Local lOk 		:= .F.
Local aButtons	:= {}
Local nCont		:=	0
Local aAreaZC7	:=	ZC7->(GetArea())
Local aAreaZCH	:=	ZCH->(GetArea())
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
LOCAL aCposVis := { "ZC7_CODCLI", "ZC7_LOJA"}

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


//aCposAlt := { "ZC7_UNID", "ZC7_DOCTO", "ZC7_REVDOC" }


DbSelectArea(cAlias)
If (nOpc == 3 .OR. nOpc == 6 )
	RegToMemory(cAlias,.F.)
	RegToMemory(cAlias,.T.)
Else
	RegToMemory(cAlias,.F.,.F.)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("ZCH")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZCH") )
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
	M->ZC7_CARESP	:=GETSXENUM("ZC7","ZC7_CARESP")
	M->ZC7_REV		:="00"
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		If ( AllTrim(aHeader[nCntFor][2]) == "ZCH_ITEM" )
			aCols[1][nCntFor] := "01"
		EndIf
	Next nCntFor
	aCOLS[1][Len(aHeader)+1] := .F.
ElseIf nOpc	==	6
	DBSelectArea("ZCH")
	ZCH->(DBSetOrder(1))
	ZCH->(DBSeek(xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)))
	Do While ZCH->(!EoF()) .AND. (xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)) == (ZCH->(ZCH_FILIAL+ZCH_CARESP+ZCH_REVCAR))
		nCont++   //Verifica o tamanho do aCols
		ZCH->(DBSkip())
	EndDo
	aCols:=Array(nCont,nUsado+1)
	nUsado:=0
	nCont:=1
	ZCH->(DBSetOrder(1))
	ZCH->(DBSeek(xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)))
	Do While ZCH->(!EoF()) .AND. ((ZCH->(ZCH_FILIAL+ZCH_CARESP+ZCH_REVCAR)) == (xFilial("ZCH")+ZC7->(ZC7_CARESP+ZC7_REV)))
		dbSelectArea("Sx3")
		SX3->(dbSeek("ZCH"))
		While SX3->(!Eof()) .And. (x3_arquivo == "ZCH")
			IF cNivel >= x3_nivel .AND. X3USO(x3_usado)
				nUsado++
				aCOLS[nCont][nUsado] :=ZCH->&(SX3->X3_CAMPO)
			Endif
			SX3->(dbSkip())
		EndDo
		aCOLS[nCont][nUsado+1] := .F.
		nCont++
		nUsado:=0
		ZCH->(DBSkip())
	EndDo
Else
	DBSelectArea("ZCH")
	ZCH->(DBSetOrder(1))
	ZCH->(DBSeek(xFilial("ZCH")+M->(ZC7_CARESP+ZC7_REV)))
	Do While ZCH->(!EoF()) .AND. (xFilial("ZCH")+M->(ZC7_CARESP+ZC7_REV)) == (ZCH->(ZCH_FILIAL+ZCH_CARESP+ZCH_REVCAR))
		nCont++   //Verifica o tamanho do aCols
		ZCH->(DBSkip())
	EndDo
	aCols:=Array(nCont,nUsado+1)
	nUsado:=0
	nCont:=1
	ZCH->(DBSetOrder(1))
	ZCH->(DBSeek(xFilial("ZCH")+M->(ZC7_CARESP+ZC7_REV)))
	Do While ZCH->(!EoF()) .AND. ((ZCH->(ZCH_FILIAL+ZCH_CARESP+ZCH_REVCAR)) == (xFilial("ZCH")+M->(ZC7_CARESP+ZC7_REV)))
		dbSelectArea("Sx3")
		SX3->(dbSeek("ZCH"))
		While SX3->(!Eof()) .And. (x3_arquivo == "ZCH")
			IF cNivel >= x3_nivel .AND. X3USO(x3_usado)
				nUsado++
				aCOLS[nCont][nUsado] :=ZCH->&(SX3->X3_CAMPO)
			Endif
			SX3->(dbSkip())
		EndDo
		aCOLS[nCont][nUsado+1] := .F.
		nCont++
		nUsado:=0
		ZCH->(DBSkip())
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
EnChoice( cAlias, nReg, IIF(nOpc==6,3,nOpc), , , , , aPosObj[1],,,,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Tela para Geração de Revisão                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nOpc==6
	dbSelectArea("Sx3")
	SX3->(dbSeek("ZC7"))
	While SX3->(!Eof()) .And. (x3_arquivo == "ZC7")
		IF cNivel >= x3_nivel .AND. X3USO(x3_usado)
			If AllTrim(SX3->X3_CAMPO)=="ZC7_REV"
				M->ZC7_REV	 :=	sfRevisao (ZC7->ZC7_CARESP)
			Else
				M->&(SX3->X3_CAMPO) :=ZC7->&(SX3->X3_CAMPO)
			EndIf
		Endif
		SX3->(dbSkip())
	EndDo
EndIf

//Enchoice(cAlias,nReg,IIF(nOpc==6,4,nOpc), , , ,aCposVis ,{14,03,110,570}, , , , ,)
//		                     1          2           3        4       5          6          7              8            9
//					   ( nSuperior, nEsquerda, nInferior, nDireita, nOpc, [ cLinhaOk ], [ cTudoOk ], [ cIniCpos ], [ lApagar ],
//							10          11       12           13         14              15             16         17            18
//						[ aAlter ], [ uPar1 ], [ lVazio ], [ nMax ], [ cCampoOk ], [ cSuperApagar ], [ uPar2 ], [ cApagaOk ], [ oWnd ] )
//							1            2            3             4        5    	 6 				7     8   					 9  	 10 11 12 13 14 15 16 17  18
oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_PPAC010E('Linha')","U_PPAC010E('Tudo')","+ZCH_ITEM" ,.T.,  ,  ,  ,  ,  ,  ,  ,  ,	,)
Private oGetDad:=oGetD

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk := sfTudOk (nOpc,nReg), Iif(lOk,oDlg:End(),)},{||oDlg:End()}, , )

If lOk .and. (nOpc == 3 .or. nOpc == 4 .or. nOpc == 6)
	Processa({||sfGravar(cAlias,nOpc,nReg)})
Endif

If nOpc == 5 .and. lOk
	//	A280Dele()
Endif
RestArea(aAreaZC7)
RestArea(aAreaZCH)
Return
//===========================Função para Gravar os Registros=======================================
Static Function sfGravar(cAlias,nOpc,nReg)
Local aAreaZC7	:=	ZC7->(GetArea())
Local aAreaZCH	:=	ZCH->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC7->(RecNo()),0)
Local nContHea	:=	0
Local nContCol	:=	0
Local bCampo	:= { |nCPO| Field(nCPO) }
Local lGraOk	:=	.T.
Local nPosItem	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCH_ITEM"})
Local cMensagem	:=	""
Local cMatr		:=	""
Local cEmail	:=	""

Do Case
	Case nOpc==3 .OR. nOpc==6//Inclusao ou Geração de Revisão
		Begin Transaction
		DbSelectArea(cAlias)
		ZC7->(DbSetOrder(5))//ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC
		If !ZC7->(DBSeek(xFilial(cAlias)+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)))
			lGraOk:=.T.
		Else
			Do While ZC7->(!EoF()) .AND. ;
				(Xfilial("ZC7")+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC))==;
				(ZC7->(ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)) .AND. lGraOk
				If nRecNo<>ZC7->(RecNo()) .AND. M->ZC7_CARESP<>ZC7->ZC7_CARESP
					lGraOk:=.F.
				Else
					lGraOk:=.T.
				EndIf
				ZC7->(DBSkip())
			EndDo
		EndIf
		ZC7->(DbSetOrder(1))//ZC7_FILIAL+ZC7_CARESP+ZC7_REV
		If !ZC7->(DBSeek(xFilial(cAlias)+M->(ZC7_CARESP+ZC7_REV))) .AND. lGraOk
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
				cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="1-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
			EndIf
			ZC7->(MsUnLock())
			If lGraOk
				DbSelectArea("ZCH")
				ZCH->(DbSetOrder(1))//ZCH_FILIAL, ZCH_CARESP, ZCH_REVCAR, ZCH_ITEM
				If !ZCH->(DBSeek(xFilial("ZCH")+M->(ZC7_CARESP+ZC7_REV)))
					For nContCol:=1 to Len(aCols)
						If !(aCols[nContCol][Len(aHeader)+1])
							lGraOk:=RecLock("ZCH",.T.)
							If lGraOk
								ZCH->ZCH_FILIAL	:= xFilial("ZCH")
								ZCH->ZCH_CARESP:=	M->ZC7_CARESP
								ZCH->ZCH_REVCAR:=	M->ZC7_REV
								For nContHea := 1 To Len(aHeader)
									Do Case
										Case	AllTrim(aHeader[nContHea][2])=="ZCH_CARESP"
											ZCH->ZCH_CARESP:=	M->ZC7_CARESP
											
										Case	AllTrim(aHeader[nContHea][2])=="ZCH_REVCAR"
											ZCH->ZCH_REVCAR:=	M->ZC7_REV
											
										OtherWise
											ZCH->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea]
											
									EndCase
								Next nContHea
							Else
								nContCol:=Len(aCols)
								lGraOk:=.F.
								cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
								cTexto:="4-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
							EndIf
						EndIf
					Next nContCol
				Else
					lGraOk:=.F.
					cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
					cTexto:="3-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
				EndIf
			EndIf
		Else
			lGraOk:=.F.
			cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
			cTexto:="2-Já Exite registros com tais dados. Registro "+ZC7->ZC7_CARESP+" Revisão "+ZC7->ZC7_REV
		EndIf
		If 	lGraOk .AND. nOpc==6
			DBSelectArea("ZC7")
			ZC7->(DBGoto(nReg))
			lGraOk:=RecLock("ZC7",.F.)
			ZC7->ZC7_STAREV	:=	.F.
			ZC7->(MsUnLock())
			If !lGraOk
				lGraOk:=.F.
				cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="3-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
			EndIf
			
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
		ZC7->(DbSetOrder(5))//ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC
		If !ZC7->(DBSeek(xFilial(cAlias)+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)))
			lGraOk:=.T.
		Else
			Do While ZC7->(!EoF()) .AND. ;
				(Xfilial("ZC7")+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC))==;
				(ZC7->(ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)) .AND. lGraOk
				If nRecNo<>ZC7->(RecNo()) .AND. M->ZC7_CARESP<>ZC7->ZC7_CARESP
					lGraOk:=.F.
				Else
					lGraOk:=.T.
				EndIf
				ZC7->(DBSkip())
			EndDo
		EndIf
		ZC7->(DbSetOrder(1))//ZC7_FILIAL+ZC7_CARESP+ZC7_REV
		If ZC7->(DBSeek(xFilial(cAlias)+M->(ZC7_CARESP+ZC7_REV))) .AND. lGraOk
			Do While ZC7->(!EoF()) .AND. (Xfilial("ZC7")+M->(ZC7_CARESP+ZC7_REV))==(ZC7->(ZC7_FILIAL+ZC7_CARESP+ZC7_REV)) .AND. lGraOk
				If nRecNo<>ZC7->(RecNo())
					lGraOk:=.F.
				Else
					lGraOk:=.T.
				EndIf
				ZC7->(DBSkip())
			EndDo
		Else
			lGraOk:=.F.
		EndIf
		If  lGraOk
			ZC7->(DBgoto(nRecNo))
			lGraOk:=RecLock(cAlias,.F.)
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
				cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="2-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
			EndIf
			ZC7->(MsUnLock())
			If lGraOk
				DbSelectArea("ZCH")
				ZCH->(DbSetOrder(1))//ZCH_FILIAL, ZCH_CARESP, ZCH_REVCAR, ZCH_ITEM
				If ZCH->(DBSeek(xFilial("ZCH")+M->(ZC7_CARESP+ZC7_REV)))  //Se  nao encontrar nada, o registro está corrompido
					For nContCol:=1 to Len(aCols)
						//Posiciona no registo respectivo do aCols
						If ZCH->(DBSeek(xFilial("ZCH")+(M->ZC7_CARESP+M->ZC7_REV+aCols[nContCol][nPosItem])))
							If !(aCols[nContCol][Len(aHeader)+1])
								lGraOk:=RecLock("ZCH",.F.)
								If lGraOk
									ZCH->ZCH_FILIAL	:= xFilial("ZCH")
									ZCH->ZCH_CARESP:=	M->ZC7_CARESP
									ZCH->ZCH_REVCAR:=	M->ZC7_REV
									For nContHea := 1 To Len(aHeader)
										Do Case
											Case	AllTrim(aHeader[nContHea][2])=="ZCH_CARESP"
												ZCH->ZCH_CARESP:=	M->ZC7_CARESP
												
											Case	AllTrim(aHeader[nContHea][2])=="ZCH_REVCAR"
												ZCH->ZCH_REVCAR:=	M->ZC7_REV
												
											OtherWise
												ZCH->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea]
												
										EndCase
									Next nContHea
								Else
									nContCol:=Len(aCols)
									lGraOk:=.F.
									cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
									cTexto:="6-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
								EndIf
								ZCH->(MsUnLock())
							Else//Tratar os deletados
								lGraOk:=RecLock("ZCH",.F.)
								If lGraOk
									DBDELETE()
								Else
									nContCol:=Len(aCols)
									lGraOk:=.F.
									cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
									cTexto:="5-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
								EndIf
								ZCH->(MsUnLock())
							EndIf
						Else//Se nao encontrar, inserir o novo registro
							If !(aCols[nContCol][Len(aHeader)+1])
								lGraOk:=RecLock("ZCH",.T.)
								If lGraOk
									ZCH->ZCH_FILIAL	:= xFilial("ZCH")
									ZCH->ZCH_CARESP:=	M->ZC7_CARESP
									ZCH->ZCH_REVCAR:=	M->ZC7_REV
									For nContHea := 1 To Len(aHeader)
										Do Case
											Case	AllTrim(aHeader[nContHea][2])=="ZCH_CARESP"
												ZCH->ZCH_CARESP:=	M->ZC7_CARESP
												
											Case	AllTrim(aHeader[nContHea][2])=="ZCH_REVCAR"
												ZCH->ZCH_REVCAR:=	M->ZC7_REV
												
											OtherWise
												ZCH->&(aHeader[nContHea][2])	:=	aCols[nContCol][nContHea]
												
										EndCase
									Next nContHea
								Else
									nContCol:=Len(aCols)
									lGraOk:=.F.
									cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
									cTexto:="7-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
								EndIf
								ZCH->(MsUnLock())
							EndIf
						EndIf
					Next nContCol
				Else
					lGraOk:=.F.
					cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
					cTexto:="4-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
				EndIf
			Else
				lGraOk:=.F.
				cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
				cTexto:="3-Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"
			EndIf
		Else
			lGraOk:=.F.
			cTitulo:="TPPAC010->PPAC010A->sfGravar("+AllTrim(Str(nOpc))+")"
			cTexto:="1-Já Exite registros com tais dados. Registro "+ZC7->ZC7_CARESP+" Revisão "+ZC7->ZC7_REV
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
else
	If nOpc==4
		cMensagem:="Motivo da Alteração: "+ZC7->ZC7_ALTER
		cMatr:=QA_USUARIO()[3]
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERPRO,"QAA_EMAIL")
		//Chamada da funcão do e-mail
		//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Alteração "+cCadastro,ZC7->ZC7_CARESP,ZC7->ZC7_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			Processa({|| U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
		EndIf
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERQUA  ,"QAA_EMAIL")
		If !Empty(cEMail)
			Processa({|| U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
		EndIf
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERENG   ,"QAA_EMAIL")
		If !Empty(cEMail)
			Processa({|| U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
		EndIf
	EndIf
	If nOpc==6
		cMensagem:="Motivo da Revisão: "+ZC7->ZC7_MOTIVO
		cMatr:=QA_USUARIO()[3]
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERPRO,"QAA_EMAIL")
		//Chamada da funcão do e-mail
		//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Nova Revisão "+cCadastro,ZC7->ZC7_CARESP,ZC7->ZC7_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			Processa({|| U_TWHBX001 (cMensagem,"Nova Revisão "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
		EndIf
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERQUA  ,"QAA_EMAIL")
		If !Empty(cEMail)
			Processa({|| U_TWHBX001 (cMensagem,"Nova Revisão "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
		EndIf
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC7->ZC7_GERENG   ,"QAA_EMAIL")
		If !Empty(cEMail)
			Processa({|| U_TWHBX001 (cMensagem,"Nova Revisão "+cCadastro+" "+ZC7->ZC7_CARESP ,cEMail,"",)})
		EndIf
	EndIf
EndIf

RestArea(aAreaZC7)
RestArea(aAreaZCH)
Return(lGraOk)
//===========================Fim da Função para gravar os Registros ===============================
//================================Valida os Dados na Persistência=====================================================================
Static Function sfTudOk (nOpc,nRecNo)
Local aArea		:=	ZC7->(GetArea())
Local aAreaX3	:=	SX3->(GetArea())
Local lRet		:= .T.
Local aCampo	:=	{}
Local cCampo	:=	""
Local cValid	:=	""
Local cTexto	:=	""

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("ZC7")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZC7") )
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
		Case nOpc==3 .or. nOpc==6 //Inclui	ou Geração de Revisão
			DbSelectArea("ZC7")
			ZC7->(DbSetOrder(5))//ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC
			If !ZC7->(DBSeek(xFilial("ZC7")+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)))
				lRet:=.T.
			Else
				Do While ZC7->(!EoF()) .AND. ;
					(Xfilial("ZC7")+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC))==;
					(ZC7->(ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)) .AND. lRet
					If nRecNo<>ZC7->(RecNo()) .AND. M->ZC7_CARESP<>ZC7->ZC7_CARESP
						lRet:=.F.
					Else
						lRet:=.T.
					EndIf
					ZC7->(DBSkip())
				EndDo
			EndIf
			If !lRet
				MsgAlert("Já Exite registros com tais dados. Registro "+ZC7->ZC7_CARESP+" Revisão "+ZC7->ZC7_REV,"TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")
			EndIf
			
			If(M->ZC7_GERENG == M->ZC7_GERQUA) .OR. (M->ZC7_GERENG == M->ZC7_GERPRO ) .OR.   (M->ZC7_GERQUA==M->ZC7_GERPRO)
				lRet := .F.
				MsgAlert("As matrículas dos aprovadores não podem ser iguais.","TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")
			EndIf
			If nOpc==6
				If Empty(M->ZC7_MOTIVO)
					lRet := .F.
					MsgAlert("Para a geração de revisão o Campo Motivo é Obrigatório.","TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")
				Endif
				
			EndIf
			
			
		Case nOpc==4 //Alterar
			If Empty(ZC7->ZC7_STATUS) .AND. ZC7->ZC7_STAREV
				lRet := .T.
			Else
				lRet := .F.
				MsgAlert("O registro não pode ser alterado, pois já existe uma data de aprovação ou é uma revisão obsoleta","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Alteração")
			EndIf
			If lRet
				DbSelectArea("ZC7")
				ZC7->(DbSetOrder(5))//ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC
				If !ZC7->(DBSeek(xFilial("ZC7")+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)))
					lRet:=.T.
				Else
					Do While ZC7->(!EoF()) .AND. ;
						(Xfilial("ZC7")+M->(ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC))==;
						(ZC7->(ZC7_FILIAL+ZC7_PPAP+ZC7_CODCLI+ZC7_LOJA+ZC7_NUMPC+ZC7_REVPEC)) .AND. lRet
						If nRecNo<>ZC7->(RecNo()) .AND. M->ZC7_CARESP<>ZC7->ZC7_CARESP
							lRet:=.F.
						Else
							lRet:=.T.
						EndIf
						ZC7->(DBSkip())
					EndDo
				EndIf
				If !lRet
					MsgAlert("Já Exite registros com tais dados. Registro "+ZC7->ZC7_CARESP+" Revisão "+ZC7->ZC7_REV,"TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")
				EndIf
			EndIf
			If Empty(M->ZC7_ALTER)
				lRet := .F.
				MsgAlert("Para Alteração o Campo Motivo da Alteração é Obrigatório.","TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")
			Endif
			If(M->ZC7_GERENG == M->ZC7_GERQUA) .OR. (M->ZC7_GERENG == M->ZC7_GERPRO ) .OR.   (M->ZC7_GERQUA==M->ZC7_GERPRO)
				lRet := .F.
				MsgAlert("As matrículas dos aprovadores não podem ser iguais.","TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")
			EndIf
			
			
	EndCase
Else
	lRet := .F.
	For nCont:=1 to Len(aCampo)
		cTexto+="Campo Obrigatório "+aCampo[nCont][3]+CHR(13)+CHR(10)
	Next nCont
	//MsgAlert("Verifique os campos obrigatório da rotina","TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") btOK")
	Aviso("Verifique os campos obrigatório da rotina. TPPAC010->PPAC010A->sfTudOk("+AllTrim(Str(nOpc))+") btOK",cTexto,{"OK"},2)
EndIf
If lRet //Verifica o Browser
	lRet:=U_PPAC010E("Tudo")
EndIf
RestArea(aArea)
Return lRet
//=========================Fim da Validação dos Dados na Persistência===================================================================
//==========================Fim da Montagem da Tela================================================
User Function PPAC010E (cOpcao)
Local lRet		:=	.T.
Local nCont		:=	0
Local nCont2	:=	0
Local nPosTipo	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCH_TIPOCA"})
Local nPosProc	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCH_PROCES"})
Local nPosDesc	:= 	Ascan(aHeader, {|x| alltrim(x[2]) == "ZCH_DESC"})

Local nChave	:=	""  //ZCH_CARESP, ZCH_REVCAR, ZCH_TIPOCA, ZCH_PROCES, ZCH_DESC
Local cTexto	:=	""

Do Case
	Case cOpcao=="Linha"
		For nCont:=1 to Len(aCols)
			If !(aCols[nCont][Len(aHeader)+1])
				nChave	:=	aCols[nCont][nPosTipo]+aCols[nCont][nPosProc]+aCols[nCont][nPosDesc]
				nCont2	:=	1
				For nCont2:=nCont2+nCont to Len(aCols)
					If !(aCols[nCont2][Len(aHeader)+1])
						If nChave == aCols[nCont2][nPosTipo]+aCols[nCont2][nPosProc]+aCols[nCont2][nPosDesc] //Verifica linha a linha se há duplicidade
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
		cTexto:="Há registros duplicados"
		If !lRet
			Aviso("Atencao!",cTexto,{"OK"},2)
		EndIf
		
	Case cOpcao=="Tudo"
		For nCont:=1 to Len(aCols)
			If !(aCols[nCont][Len(aHeader)+1])
				nChave	:=	aCols[nCont][nPosTipo]+aCols[nCont][nPosProc]+aCols[nCont][nPosDesc]
				nCont2	:=	1
				For nCont2:=nCont2+nCont to Len(aCols)
					If !(aCols[nCont2][Len(aHeader)+1])
						If nChave == aCols[nCont2][nPosTipo]+aCols[nCont2][nPosProc]+aCols[nCont2][nPosDesc] //Verifica linha a linha se há duplicidade
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
		cTexto:="Há registros duplicados"
		If !lRet
			Aviso("Atencao!",cTexto,{"OK"},2)
		Else
			lRet:=.F.
			For nCont:=1 to Len(aCols)  //Verifica se há pelo menos um registro no ZCF
				If !(aCols[nCont][Len(aHeader)+1]) .AND. !Empty(aCols[nCont][nPosTipo]) .AND. !Empty(aCols[nCont][nPosProc]).AND. !Empty(aCols[nCont][nPosDesc])
					lRet:=.T.
					nCont:=Len(aCols)
				Else
					lRet:=.F.
				EndIf
			Next nCont
		EndIf
		If !lRet
			Aviso("Atencao!","Informe as Características",{"OK"},2)
		Endif
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
Static Function sfRevisao (cCARESP)
Local cRet		:=	""
Local aAreaZC7	:=	ZC7->(GetArea())
DBSelectArea("ZC7")
ZC7->(DBGoTop())
ZC7->(DBSetOrder(1))//ZC7_FILIAL, ZC7_CARESP, ZC7_REV, R_E_C_N_O_, D_E_L_E_T_
If ZC7->(DBSeek(xFilial("ZC7")+cCARESP))
	Do While ZC7->(!EoF()) .AND. (ZC7->(ZC7_FILIAL+ZC7_CARESP)) == ;
		(xFilial("ZC7")+(cCARESP))
		cRet:=ZC7->ZC7_REV
		ZC7->(DBSkip())
	EndDo
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC7)
Return (cRet)
//================================FIM DA REVISÃO ================================================== //================================FIM DA REVISÃO ================================================== 
