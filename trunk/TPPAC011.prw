#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC011  º Autor ³ Handerso Duarte    º Data ³  07/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Análise Crítica Técnica                        º±±
±±º          ³ Tabela ZC2                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 R 1.2 MSSQL                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC011 ()
Local aCores := {{"	ZC2_STAREV	.AND. Empty(ZC2_STATUS)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
                 {"	!ZC2_STAREV"						       ,"BR_PRETO" },;                //Revisão obsoleta
                 {"ZC2_STATUS=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC2_STATUS=='N'"						      ,"DISABLE" }}                //Reprovado


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persistências forem concluídas com êxito.
Private cCadastro 	:=	"Cadastro de Análise Crítica Técnica"
Private cCargo		:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart		:=	"{"+Getmv("WHB_DPTO")+"}"
Private aCargo		:=	&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart		:=	&cDepart//Departamentos autorizados a aprovar e geras revisões

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC011A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC011A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC011A (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC011A (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC011A (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR008()"	,0,8},;        		     
        		     {"Legenda		","U_PPAC011H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC2"

dbSelectArea("ZC2")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC011H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC011A (nOpc) 
Local nRecNo	:=	IIF(nOpc<>3,ZC2->(RecNo()),0)
Local lFlag		:=	.T.  
local lRet := ''    
Local cAprovAnt		:= ""
Local cStaRevAnt	:= "" 
Local nRecNoAnt		:= '' 
Do Case
	Case nOpc == 3 //Inclusao
		AxInclui( cString,,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,)
		  
	Case nOpc == 4 //Alteracao
		If Empty(ZC2->ZC2_STATUS) .AND. ZC2->ZC2_STAREV
			AxAltera(cString,,nOpc,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,) 
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Alteração"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta"
		EndIf
		 
	Case nOpc == 5 //Excluir 
		lFlag		:=	.F.
		cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Exclusão"	
		cTexto		:=	"Não é permitido efetuar exclusão dos Registros."
		
	Case nOpc == 6 //Gerar revisão
		If !Empty(ZC2->ZC2_STATUS) .AND. ZC2->ZC2_STAREV  
			nRecNoAnt   := nRecNo
			cAprovAnt	:= ZC2->ZC2_STATUS
		    cStaRevAnt	:= ZC2->ZC2_STAREV
			nRecNo		:=	sfGerRev(nRecNo,nOpc)
			If lTudoOK
				DBSelectArea("ZC2")
				ZC2->(DBgoto(nRecNo))
				//lRet := AxAltera(cString,,4,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,) 
				
				If AxAltera(cString,,4,,,,,"U_PPAC011B  ("+AllTrim(Str(nOpc))+")",,,) == 3		//CHAMA A ROTINA DE ALTERAÇÃO PARA REVISÕES
					RecLock("ZC2",.F.) 
						DbDelete()
					ZC2->(MsUnLock()) 
					
					ZC2->(DBGoTo(nRecNoAnt))    
					RecLock("ZC2",.F.) 
						ZC2->ZC2_STATUS	:= cAprovAnt
						ZC2->ZC2_STAREV := cStaRevAnt
					ZC2->(MsUnLock())
				EndIf 
		
			EndIf
		Else
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Gerar Revisão"	
			cTexto		:=	"O registro não pode ser alterado, pois não foi aprovado/reprovado ou é uma revisão obsoleta."		
		EndIf		
	Case nOpc == 7 //Aprovar/Reprovar
		If Empty(ZC2->ZC2_STATUS) .AND. ZC2->ZC2_STAREV
			sfAprovar (nRecNo,nOpc)//7	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC011->PPAC011B("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta."							
		EndIf	
		
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC011->PPAC011A("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."
				
EndCase
If !lFlag
	MsgAlert(cTexto,cTitulo)			
EndIf
Return (lRet)
//==========================Fim da Incluisão de Registros==========================================
//==========================Validação para Gravação================================================
User Function PPAC011B (nOpc)
Local lRet		:=	.T.
Local aArea		:=	ZC2->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC2->(REcNo()),0)
Local cMensagem	:=	"Há um documento pendente para análise."
Local cEMail	:=	""
cTitulo	:=	""	
cTexto	:=	""

Do Case
	Case nOpc == 3 //Inclusao
		DBselectArea("ZC2")
		ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
		If !ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)))
			ZC2->(DBSetOrder(6))//ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ
			If !ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)))
				lRet:=.T.
			Else
				lRet:=.F.
				cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
				cTexto:="Já existe registro com o mesmo Produto e Projeto. Verifique "+ZC2->ZC2_ACT+" Revisão "+ZC2->ZC2_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC2->ZC2_ACT+" Revisão "+ZC2->ZC2_REV
		EndIf
		If lRet .AND. M->ZC2_CARCLI=="1" .AND. Empty(M->ZC2_CARAC)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo Carac. Cliente(ZC2_CARCLI) for sim, então é necessário informar o campo Quais (ZC2_CARAC)"								
		EndIf		
		If lRet .AND. M->ZC2_ANATEC=="1" .AND. Empty(M->ZC2_RELAT)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo Análise Técnica (ZC2_ANATEC) for sim, então é necessário informar o campo Relatar (ZC2_RELAT)"								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situação Pendente "+cCadastro,M->ZC2_ACT,M->ZC2_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situação Pendente "+cCadastro+" "+M->ZC2_ACT ,cEMail,"",)
			EndIf		
		EndIf
		
	Case nOpc == 4 //Alteraçao
		DBselectArea("ZC2") 
		ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
		ZC2->(DBGotop())		
		If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)))
			Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_ACT+ZC2_REV)==(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)) .AND. lRet
				If ZC2->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC2->(DBSkip())
			EndDo
			If lRet
				ZC2->(DBSetOrder(6))//ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ
				ZC2->(DBGotop())				
				If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)))
					Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ)==(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)) .AND. lRet
						If ZC2->(RecNo())<>nRecNo .AND. ZC2->ZC2_ACT<>M->ZC2_ACT
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC2->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Alteração"
						cTexto:="Já existe registro com o mesmo Produto e Projeto. Verifique "+ZC2->ZC2_ACT+" Revisão "+ZC2->ZC2_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Alteração"
				cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC2->ZC2_ACT+" Revisão "+ZC2->ZC2_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Não há registro a ser alterado. Erro na operação de Alteração."
		EndIf 
		If lRet .AND. M->ZC2_CARCLI=="1" .AND. Empty(M->ZC2_CARAC)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Se campo Carac. Cliente(ZC2_CARCLI) for sim, então é necessário informar o campo Quais (ZC2_CARAC)"								
		EndIf		
		If lRet .AND. M->ZC2_ANATEC=="1" .AND. Empty(M->ZC2_RELAT)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Se campo Análise Técnica (ZC2_ANATEC) for sim, então é necessário informar o campo Relatar (ZC2_RELAT)"								
		EndIf		 
		
	Case nOpc == 6 //Gerar Revisão
		DBselectArea("ZC2") 
		ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
		ZC2->(DBGotop())		
		If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)))
			Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_ACT+ZC2_REV)==(xFilial("ZC2")+M->(ZC2_ACT+ZC2_REV)) .AND. lRet
				If ZC2->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC2->(DBSkip())
			EndDo
			If lRet
				ZC2->(DBSetOrder(6))//ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ
				ZC2->(DBGotop())				
				If ZC2->(DBSeek(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)))
					Do While ZC2->(!EoF()) .AND. ZC2->(ZC2_FILIAL+ZC2_CODPRO+ZC2_PROJ)==(xFilial("ZC2")+M->(ZC2_CODPRO+ZC2_PROJ)) .AND. lRet
						If ZC2->(RecNo())<>nRecNo .AND. M->ZC2_ACT<>ZC2->ZC2_ACT
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC2->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revisão"
						cTexto:="Já existe registro com o mesmo Produto e Projeto. Verifique "+ZC2->ZC2_ACT+" Revisão "+ZC2->ZC2_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revisão"
				cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC2->ZC2_ACT+" Revisão "+ZC2->ZC2_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Não há registro a ser alterado. Erro na operação de Alteração."
		EndIf
		If lRet .AND. Empty(M->ZC2_MOTIVO)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="É necessário informar o movito da revisão."								
		EndIf
		If lRet .AND. M->ZC2_CARCLI=="1" .AND. Empty(M->ZC2_CARAC)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Se campo Carac. Cliente(ZC2_CARCLI) for sim, então é necessário informar o campo Quais (ZC2_CARAC)"								
		EndIf		
		If lRet .AND. M->ZC2_ANATEC=="1" .AND. Empty(M->ZC2_RELAT)
			lRet:=.F.
			cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Se campo Análise Técnica (ZC2_ANATEC) for sim, então é necessário informar o campo Relatar (ZC2_RELAT)"								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situação Pendente "+cCadastro,M->ZC2_ACT,M->ZC2_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situação Pendente "+cCadastro+" "+M->ZC2_ACT ,cEMail,"",)
			EndIf		
		EndIf						
		
	OtherWise	
		lRet:=.F.
		cTitulo:="TPPAC011->PPAC011A->PPAC011B("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."
EndCase	

RestArea(aArea)
If !lRet
	MsgAlert(cTexto,cTitulo)	
EndIf
Return(lRet)
//==========================Fim da Validação para Gravação=========================================
//==========================Gera revião ===========================================================
Static Function sfGerRev(nRecNo,nOpc)
Local 	lRet		:=	.F. 
Local	nRecNoAtu	:=	0 
Local 	nCont		:=	0	
Local 	aAreaZC2	:=	ZC2->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC2->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

dbSelectArea("ZC2")
ZC2->(DBGoTo(nRecNo)) 
dbSelectArea("TRB")
RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC2->&(aStru[nCont][1])
	Next nCont
	TRB->ZC2_REV	:=	sfRevisao (ZC2->ZC2_ACT)//Nova Revisão
	TRB->ZC2_APPRO	:=  StoD(" / / ")
	TRB->ZC2_STATUS	:=	""
	TRB->ZC2_STAREV	:=	.T.		
	TRB->ZC2_MOTIVO	:=	""		
	TRB->ZC2_DTREV	:=	dDataBase		
TRB->(MsUnLock())

BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC2")
	ZC2->(dbSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
	If !ZC2->(DBSeek(xFilial("ZC2")+TRB->(ZC2_ACT+ZC2_REV)))
		lRet:=RecLock("ZC2",.T.)
			If lRet
				For nCont := 1 TO FCount() 	
					FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC2->ZC2_FILIAL := TRB->ZC2_FILIAL					
			EndIf
		nRecNoAtu:=ZC2->(RecNo())
		ZC2->(MsUnLock())  								
		
		dbSelectArea("ZC2") //Atualiza o registro como vesão não atual
		ZC2->(DBGoTo(nRecNo)) 
		lRet:=RecLock("ZC2",.F.)
			If lRet 
				ZC2->ZC2_STAREV	:=	.F.
			EndIf	
		ZC2->(MsUnLock()) 				
						       
	Else
		lRet:=.F.
	EndIf 
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC011->PPAC011B->sfGerRev("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro"
	Else
		cTitulo:="TPPAC011->PPAC011B->sfGerRev("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Revisão gerada com sucesso"			
	EndIf 
END TRANSACTION 

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC2)
lTudoOK:=lRet
Return(nRecNoAtu)
//==========================Fim Gera revisão======================================== 
//===============================Aprovação de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC2	:=	ZC2->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC2->ZC2_STATUS) .OR. AllTrim(ZC2->ZC2_STATUS)=="N" ) .AND. ZC2->ZC2_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
	  aUser := PswRet() // Retorna vetor com informações do usuário
	EndIf
	
	DBSelectArea("QAA") 
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))
		Do While QAA->(!EoF()) .AND. AllTrim(QAA->QAA_LOGIN)==AllTrim(aUser[1][2]) .AND. lFlag
			If !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN)))
				
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
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC011->PPAC011A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser Aprovado/Reprovado caso o registro que ainda não esteja aprovado ou que seja uma revisão atualizada",;
			"TPPAC011->PPAC011A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC2)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC2	:= 	ZC2->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cACT	:=	""
Local cREV	:=	""
dbSelectArea("ZC2")
ZC2->(DBSetOrder(1)) //ZC2_FILIAL,ZC2_ACT,ZC2_REV
ZC2->(DBGoTo(nRecNo))
cACT	:=	ZC2->ZC2_ACT
cREV	:=	ZC2->ZC2_REV   
BEGIN TRANSACTION
	Do Case
		Case	ZC2->ZC2_RESP==cMatr
			If ZC2->(DBSeek(xFilial("ZC2")+cACT+cREV))
				lFlag:=RecLock("ZC2",.F.)
					ZC2->ZC2_APPRO		:=dDataBase		
					If nOpc==7  //Aprovação
						ZC2->ZC2_STATUS		:="S"
					ElseIf nOpc==8//Reprovaçào 
						ZC2->ZC2_STATUS		:="N"
					EndIf					
				ZC2->(MsUnLock())
			Else 
				lFlag:=.F.
				cTexto:="O Registro não encontrado. Erro na operação"
				cTitulo:="TPPAC011->PPAC011A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf 
			 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
			cTitulo:="TPPAC011->PPAC011A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			
	EndCase
	
	If  !lFlag  //Desfaz a transação se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	MsgStop(cTexto,cTitulo)
EndIf

If lFlag .AND. nOpc==8//Reprovaçào 		
	While Empty(cMensagem)	 
		Alert('O preenchimento da Justificativa de Reprovação é obrigatorio!')	
		cMensagem:=sfJustif ( )	//chamada da tela de justificativa
	EndDo				
	//Grava na tabela de justificativas
	dbSelectArea("ZC2")
	ZC2->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC2->ZC2_ACT
		ZCC->ZCC_REV	:=	ZC2->ZC2_REV			
		ZCC->ZCC_TABELA	:=	"ZC2"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC2->ZC2_RESP,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprovação "+cCadastro,ZC2->ZC2_ACT,ZC2->ZC2_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC2->ZC2_ACT ,cEMail,"",)})
	EndIf	
EndIf

RestArea(aAreaZC2)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cACT)
Local cRet		:=	""
Local aAreaZC2	:=	ZC2->(GetArea())
DBSelectArea("ZC2")
ZC2->(DBGoTop())
ZC2->(DBSetOrder(1))//ZC2_FILIAL+ZC2_ACT+ZC2_REV
If ZC2->(DBSeek(xFilial("ZC2")+cACT))
	Do While ZC2->(!EoF()) .AND. (ZC2->(ZC2_FILIAL+ZC2_ACT)) == ;
			  (xFilial("ZC2")+(cACT))
		cRet:=ZC2->ZC2_REV			 					
		ZC2->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC2)
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
