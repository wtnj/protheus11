#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC001 º Autor ³ HANDERSON DUARTE   º Data ³  11/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CADASTRO DAS DEFINIÇÕES DE EMBALAGEM.                      º±±
±±º          ³ TABELA ZC3 MSSQL                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 - WHB s                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TPPAC001()
Local aCores := {}
AADD(aCores, {"	!ZC3_STAREV"						      						,"BR_PRETO" })   //Revisão obsoleta
AADD(aCores, {"	ZC3_STATUS=='A'"       					  						,"BR_VERDE"})    //Aprovado
AADD(aCores, {"	ZC3_STATUS=='R'"						  					    ,"DISABLE" })   //Reprovado
AADD(aCores, {"	ZC3_STAREV	.AND. (Empty(ZC3_APROV) .OR. ZC3_APROV=='2')"       ,"BR_AMARELO" }) //Pendente, Aguardando revisão ou aprovacao

/*    Alterado 20090812 a pedido da Debora para que o campo que controla a aprovação seja

Local aCores := {{"	ZC3_STAREV	.AND. (Empty(ZC3_APROV) .OR. ZC3_APROV=='2')"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
{"	!ZC3_STAREV"						      						,"BR_PRETO" },;                //Revisão obsoleta
{"ZC3_APROV=='1'"       					  						,"BR_VERDE"},;                //Aprovado
{"ZC3_APROV=='3'" 						  						    ,"DISABLE" }}                //Reprovado
*/

Private cCadastro := "Descritivo de Embalagem"

Private cCargo:="{"+Getmv("WHB_CARGO")+"}"
Private cDepart:="{"+Getmv("WHB_DPTO")+"}"
Private aCargo:=&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart:=&cDepart//Departamentos autorizados a aprovar e geras revisões

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ³
//³ MBROWSE sera identica a da AXCADASTRO:                              ³
//³                                                                     ³
//³ cDelFunc  := ".T."                                                  ³
//³ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ³
//³                { "Visualizar"   ,"AxVisual" , 0, 2},;               ³
//³                { "Incluir"      ,"AxInclui" , 0, 3},;               ³
//³                { "Alterar"      ,"AxAltera" , 0, 4},;               ³
//³                { "Excluir"      ,"AxDeleta" , 0, 5} }               ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
{"Visualizar"	,"AxVisual"			,0,2} ,;
{"Incluir"		,"U_PPAC001A (3)"	,0,3} ,;
{"Alterar"		,"U_PPAC001B (4)"	,0,4} ,;
{"Excluir"		,"U_PPAC001E (5)"	,0,5} ,;
{"Gerar Revisao","U_PPAC001C (6)"	,0,6} ,;
{"Aprovar/Reprovar","U_PPAC001D (7)"	,0,7},;
{"Imprimir"	,"U_TPPAR001 ()"	,0,8},;
{"Legenda		","U_PPAC001H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC3"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC001H()
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
{"BR_VERDE"    		,"Aprovado"	},;
{"DISABLE"    		,"Reprovado"},;
{"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros================================================
User Function PPAC001A (nOpc)

AxInclui( cString,,,,,,"U_PPAC001F  ("+AllTrim(Str(nOpc))+")",,,)


Return ()
//==========================Fim da Incluisão de Registros==========================================
//===============================Alterar Registros=================================================
User Function PPAC001B (nOpc)
local lRet := ''
If Empty(DtoS(ZC3->ZC3_DATAF)) .AND. ZC3->ZC3_STAREV
//If ZC3->ZC3_STAREV	.AND. (!Empty(ZC3->ZC3_DTENG) .OR. !Empty(ZC3->ZC3_DTQUA) .OR. !Empty(ZC3->ZC3_DTPROD) .OR. !Empty(ZC3->ZC3_DTAPR))
	lRet :=  (AxAltera(cString,,nOpc,,,,,"U_PPAC001F  ("+AllTrim(Str(nOpc))+")",,,))
Else
	MsgAlert("O registro não pode ser alterado, pois já existe uma data fim ou é uma revisão obsoleta","TPPAC001->PPAC001B("+AllTrim(Str(nOpc))+") Alteração")
EndIf  

Return (lRet)
//==========================Fim da Alteração de Registros==========================================
//===============================Gerar Versão     =================================================
User Function PPAC001C (nOpc)
Local 	lRet		:=	.F.
Local 	cTexto		:=	""
Local 	cTitulo		:=	""
Local 	nRecNo		:=	ZC3->(RecNo())
Local	nRecNoAtu	:=	0
Local 	aAreaZC3	:=	ZC3->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }
Private	aStru		:=	ZC3->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.)

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.)
dbClearIndex()

//If !Empty (DtoS(ZC3->ZC3_DATAF)) .AND. ZC3->ZC3_STAREV //Só poderá gerar revisão se tiver data fim e com a revisão atual
If ZC3->ZC3_STAREV .AND. (!Empty(ZC3->ZC3_DTENG) .OR. !Empty(ZC3->ZC3_DTQUA) .OR. !Empty(ZC3->ZC3_DTPROD) .OR. !Empty(ZC3->ZC3_DTAPR))
	dbSelectArea("ZC3")
	ZC3->(DBGoTo(nRecNo))
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC3->&(aStru[nCont][1])
	Next nCont
	TRB->ZC3_REV	:=	sfRevisao (ZC3->ZC3_NUMEMB)//Nova Revisão
	TRB->ZC3_DATAF	:=  StoD(" / / ")
	TRB->ZC3_APROV	:=	""
	TRB->ZC3_STAREV	:=	.T.
	TRB->ZC3_APRFIM	:=	""
	TRB->ZC3_MOTIVO	:=	""
	TRB->ZC3_DTREV	:=	dDataBase
	TRB->ZC3_STATUS	:=	""
	TRB->ZC3_DTENG	:=	StoD(" / / ")
	TRB->ZC3_DTQUA	:=	StoD(" / / ")
	TRB->ZC3_DTPROD	:=	StoD(" / / ")
	TRB->ZC3_DTAPR	:=	StoD(" / / ")
	TRB->(MsUnLock())
	
	BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC3")
	ZC3->(dbSetOrder(3))//ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV+ZC3_APROV
	If !ZC3->(DBSeek(xFilial("ZC3")+TRB->(ZC3_NUMEMB+ZC3_REV)))
		lRet:=RecLock("ZC3",.T.)
		If lRet
			For nCont := 1 TO FCount()
				FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
			Next nCont
			ZC3->ZC3_FILIAL := TRB->ZC3_FILIAL
		EndIf
		nRecNoAtu:=ZC3->(RecNo())
		ZC3->(MsUnLock())
		
		dbSelectArea("ZC3") //Atualiza o registro como vesão não atual
		ZC3->(DBGoTo(nRecNo))
		lRet:=RecLock("ZC3",.F.)
		If lRet
			ZC3->ZC3_STAREV	:=	.F.
		EndIf
		ZC3->(MsUnLock())
		
	Else
		lRet:=.F.
	EndIf
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro"
	Else
		cTitulo:="TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Revisão gerada com sucesso"
	EndIf
	END TRANSACTION
	
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else
		ZC3->(DBGoTo(nRecNoAtu))
		//		MsgAlert(cTexto,cTitulo)
		If U_PPAC001B(6) == 3		//CHAMA A ROTINA DE ALTERAÇÃO PARA REVISÕES
			RecLock("ZC3",.F.) 
				DbDelete()
			ZC3->(MsUnLock()) 
			
			ZC3->(DBGoTo(nRecNo))    
			RecLock("ZC3",.F.) 
				ZC3->ZC3_STAREV := .T.
			ZC3->(MsUnLock())
		EndIf 
	EndIf
Else
//	MsgAlert("Só poderá ser gerada a revisão caso o registro tenha data fim ou não seja uma revisão obsoleta ","TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revisão")
	MsgAlert("Só poderá ser gerada a revisão caso não seja uma revisão obsoleta ","TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revisão")
EndIf

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension())
RestArea(aAreaZC3)

Return ()
//==========================Fim da Geração de Versão     ==========================================
//===============================Aprovação de Registros ===========================================
User Function PPAC001D (nOpc)//7
Local nRecNo	:=	ZC3->(RecNo())
Local aUser	 	:= {}
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC3->ZC3_APROV) .OR. AllTrim(ZC3->ZC3_APROV)=="2" .OR. AllTrim(ZC3->ZC3_APROV)=="3" ) .AND. ZC3->ZC3_STAREV .AND. ZC3->ZC3_STATUS <> 'R' 
//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
		aUser := PswRet() // Retorna vetor com informações do usuário
	EndIf

	DBSelectArea("QAA")
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))

		Do While QAA->(!EoF()) .AND. ALLTRIM(QAA->QAA_LOGIN)==AllTrim(aUser[1][2]) .AND. lFlag
			If !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN)))		
				lFlag:=.F.
				U_PPAC001G(nRecNo,sfOpcao (),QAA->QAA_MAT,QAA->QAA_EMAIL) //Reprovar
			EndIf
			QAA->(DBSkip())
		EndDo
	Else
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC001->PPAC001D("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser alterado caso o Descritivo ainda não esteja aprovado ou que seja uma revisão atualizada",;
	"TPPAC001->PPAC001D("+AllTrim(Str(nOpc))+") Descritivo Aprovado")
EndIf

RestArea(aAreaQAA)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//=================================================================================================
Static Function sfOpcao ()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nRMenu :=1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg","oRMenu","oBtn")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg       := MSDialog():New( 088,232,240,536,"Definição para o Documento",,,.F.,,,,,,.T.,,,.T. )
GoRMenu    := TGroup():New( 004,004,056,144,"Opções",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oRMenu     := TRadMenu():New( 008,010,{"Aprovacao","Aprovado Temporariamente","Reprovado"},{|u| If(PCount()>0,nRMenu:=u,nRMenu)},oDlg,,,CLR_BLACK,CLR_WHITE,"",,,120,17,,.F.,.F.,.T. )
oRMenu     := TRadMenu():New( 018,010,{"Aprovar","Reprovar"},{|u| If(PCount()>0,nRMenu:=u,nRMenu)},oDlg,,,CLR_BLACK,CLR_WHITE,"",,,120,17,,.F.,.F.,.T. )
oBtn       := TButton():New( 060,004,"OK",oDlg,{|| oDlg:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg:Activate(,,,.T.)

Return (nRMenu)
//=================================================================================================
//===============================Exlcusão de Registros=============================================
User Function PPAC001E (nOpc)
/*
Local nRecNo	:=	ZC3->(RecNo())
Local lRet		:=	U_PPAC001F  (nOpc)
If lRet
AxDeleta(cString,nRecNo,nOpc,,,,,)
EndIf
*/

MsgStop("Não é permitito excluir os registros","TPPAC001->PPAC001E("+AllTrim(Str(nOpc))+")")
Return ()
//==========================Fim da Exclusão de Registros ==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
User Function PPAC001G (nRecNo,nOpc,cMatr,cEMailRem)
Local aAreaZC3	:= 	ZC3->(GetArea())
Local cMensagem	:=	""
Local cEMail	:=	""

Local lFlag		:=	.T.
Local cNUMQUA	:=	""
Local cREVQUA	:=	""
Local nSeq		:=	1//Sequência das perguntas
Local cTexto	:=	""
Local cTitulo	:=	""
dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))
cNUMEMB	:=	ZC3->ZC3_NUMEMB
cREVEMB	:=	ZC3->ZC3_REV

//BEGIN TRANSACTION
//Do Case
If ZC3->ZC3_APENG==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTENG))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTENG	:= dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma"
			cTitulo:="Aprovação"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
		cTitulo:="Aprovação"
	EndIf
EndIf

dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))

If ZC3->ZC3_APQUA==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTQUA))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTQUA	:=dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma"
			cTitulo:="Aprovação"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
		cTitulo:="Aprovação"
	EndIf
EndIf

dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))

If ZC3->ZC3_APPROD==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTPROD))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTPROD	:=dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma"
			cTitulo:="Aprovação"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
		cTitulo:="Aprovação"
	EndIf
EndIf

dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))

If ZC3->ZC3_APLOG==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTAPR))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTAPR	:=dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma"
			cTitulo:="Aprovação"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
		cTitulo:="Aprovação"
	EndIf
EndIf

/*
OtherWise
lFlag:=.F.
cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
cTitulo:="Aprovação"

EndCase
*/
Do Case
	Case nOpc==1//Aprovação
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZC3",.F.)
		//ZC3->ZC3_DATAF 		:=dDataBase
		//ZC3->ZC3_APROV		:="1"
		If !Empty(ZC3->ZC3_DTENG) .AND. !Empty(ZC3->ZC3_DTQUA) .AND. !Empty(ZC3->ZC3_DTPROD) .AND. !Empty(ZC3->ZC3_DTAPR)
			ZC3->ZC3_STATUS := 'A'
		EndIf
		ZC3->(MsUnLock())
		/*
		Case nOpc==2//Aprocação Temporária
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZC3",.F.)
		//ZC3->ZC3_DATAF 		:=dDataBase
		//ZC3->ZC3_APROV		:="2"
		ZC3->(MsUnLock())
		*/
	Case nOpc==2//Reprovaçào
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZC3",.F.)
			ZC3->ZC3_STATUS := 'R'
		ZC3->(MsUnLock())
		While Empty(cMensagem)	 
			Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
			cMensagem:=sfJustif ( )	//chamada da tela de justificativa
		EndDo
		//Grava na tabela de justificativas
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZCC",.T.)
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC3->ZC3_NUMEMB
		ZCC->ZCC_REV	:=	ZC3->ZC3_REV
		ZCC->ZCC_TABELA	:=	"ZC3"
		ZCC->ZCC_TEXTO	:=	cMensagem
		ZCC->ZCC_DATA	:=	dDataBase
		ZCC->ZCC_USUAR	:=	ZC3->ZC3_APRFIM
		ZCC->(MsUnLock())
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APRFIM,"QAA_EMAIL")
		//Chamada da funcão do e-mail
		//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprovação Descritivo de Embalagem",ZC3->ZC3_NUMEMB,ZC3->ZC3_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprovação Descritivo de Embalagem"+ZC3->ZC3_NUMEMB ,cEMail,cEMailRem,)
		EndIf
		
		
EndCase
//END TRANSACTION
RestArea(aAreaZC3)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
//=================================================================================================
/*------------------------------------------------------------\
| Validação para Inclusão, Alteração, Excluir dos Registros	  |
\------------------------------------------------------------*/
User Function PPAC001F (nOpc)
Local lRet		:=	.T.
Local nRecNo	:=	IIF((nOpc==4 .OR. nOpc==6),ZC3->(RECNO()),0) //Só para alteração de registro ou Alteração para nova revisão.
Local aAreaZC3	:= 	ZC3->(GetArea())
Local nContReg	:=	0//Contador de Registros
Local cEMail	:=	""
Local aUser		:=	{}

PswOrder(1)
If PswSeek( __cuserid, .T. )
	aUser := PswRet() // Retorna vetor com informações do usuário
EndIf

Do Case
	Case nOpc==3//Inclusão
		DBSelectArea("ZC3")
		ZC3->(DBGoTop())
		DBSetOrder(1)//ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV
		If ZC3->(DBSeek(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)))
			lRet:=.F.
			MsgAlert("Já Existe registro para o cliente com o respectivo produto. Embalagem: "+ZC3->ZC3_NUMEMB,;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Embalagem já cadastrada")
		Else
			lRet:=.T.
		EndIf
		
	Case nOpc==4//Alteração
		If Empty(M->ZC3_APROV) .OR. AllTrim(M->ZC3_APROV)=="2" .OR. AllTrim(M->ZC3_APROV)=="3"//Só poderá ser alterado caso o pedido que ainda não esteja aprovado
			DBSelectArea("ZC3")
			ZC3->(DBGoTop())
			DBSetOrder(1)//ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV
			If ZC3->(DBSeek(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)))
				Do While ZC3->(!EoF()) .AND. (ZC3->(ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) == ;
					(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) .AND. lRet
					
					If	nRecNo <> ZC3->(RECNO())
						lRet:=.F.
						MsgAlert("Já Existe registro para o cliente com o respectivo produto. Embalagem: "+ZC3->ZC3_NUMEMB,;
						"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Embalagem já cadastrada")
					Else
						lRet:=.T.
					EndIF
					ZC3->(DBSkip())
				EndDo
			Else
				lRet:=.T.
			EndIf//Fim do DBSeek
		Else
			lRet:=.F.
			MsgAlert("Só poderá ser alterado caso a embalagem ainda não esteja aprovada.",;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Embalagem aprovada")
		EndIf
		If lRet//Enviar um e-mail ao responsável
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APRFIM,"QAA_EMAIL")
			cMensagem:=sfTexto("Alteração Descritivo de Embalagem",ZC3->ZC3_NUMEMB,ZC3->ZC3_REV,Posicione("QAA",6,aUser[1][2],"QAA_MAT"),"Alteração Descritivo de Embalagem")//Para HTML
			If !Empty(cEMail)
				//Chamada da funcão do e-mail
				//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
				U_TWHBX001 (cMensagem,"Alteração Descritivo de Embalagem"+ZC3->ZC3_NUMEMB ,cEMail,,)
			EndIf
		EndIf
		
	Case nOpc==5//Excluir
		If Empty(ZC3->ZC3_APRFIM) .AND. ZC3->ZC3_REV=="00"
			lRet:=.T.
		Else
			lRet:=.F.
			MsgAlert("O Descritivo em questão não pode ser excluído, pois há assinatura ou/e a revisão é maior que '00'.",;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Descritivo não pode ser excluído")
		EndIf
		
	Case nOpc==6// Gerar Revisão
		If !Empty(M->ZC3_MOTIVO) //Para novas revisão é obrigatório preencher o motivo da revisão
			If Empty(M->ZC3_APROV)//Só gera revisão se o descritivo esteja aprovado ou aprovado temporariamente
				DBSelectArea("ZC3")
				ZC3->(DBGoTop())
				DBSetOrder(1)//ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV
				If ZC3->(DBSeek(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)))
					Do While ZC3->(!EoF()) .AND. (ZC3->(ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) == ;
						(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) .AND. lRet
						
						If	nRecNo <> ZC3->(RECNO())
							lRet:=.F.
							MsgAlert("Já Existe registro para o cliente com o respectivo produto. Embalagem: "+ZC3->ZC3_NUMEMB,;
							"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Revisão")
						Else
							lRet:=.T.
						EndIF
						ZC3->(DBSkip())
					EndDo
				Else
					lRet:=.T.
				EndIf//Fim do DBSeek
			Else
				lRet:=.F.
				MsgAlert("Só poderá ser alterado caso o descritivo ainda não tenha aprovação.",;
				"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Revisão")
			EndIf
		Else
			lRet:=.F.
			MsgAlert("O Campo Motivo da Revisão é obrigatório.",;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Revisão")
		EndIf
		
EndCase

RestArea(aAreaZC3)
Return(lRet)
//=================================================================================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cNUMEMB)
Local cRet		:=	""
Local aAreaZC3	:=	ZC3->(GetArea())
DBSelectArea("ZC3")
ZC3->(DBGoTop())
DBSetOrder(3)//ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV+ZC3_APROV
If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB))
	Do While ZC3->(!EoF()) .AND. (ZC3->(ZC3_FILIAL+ZC3_NUMEMB)) == (xFilial("ZC3")+(cNUMEMB))
		cRet:=ZC3->ZC3_REV
		ZC3->(DBSkip())
	EndDo
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC3)
Return (cRet)
//================================FIM DA REVISÃO ==================================================
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
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||oDlgEmail:End()},037,012,,,,.T.,,"",,,,.F. )

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

