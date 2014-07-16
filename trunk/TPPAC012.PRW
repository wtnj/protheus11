#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC012  º Autor ³ Handerso Duarte    º Data ³  11/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Análise Crítica Comercial                      º±±
±±º          ³ Tabela ZC1                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB MP10 R 1.2 MSSQL                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TPPAC012 ()
Local aCores := {{"	ZC1_STAREV	.AND. Empty(ZC1_STATUS)"       ,"BR_AMARELO" },;           //Pendente, Aguardando revisão ou aprovacao
                 {"	!ZC1_STAREV"						       ,"BR_PRETO" },;                //Revisão obsoleta
                 {"ZC1_STATUS=='S'"       					  ,"BR_VERDE"},;                //Aprovado
                 {"ZC1_STATUS=='N'"						      ,"DISABLE" }}                //Reprovado

Local aUser	 	    := {}   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cTitulo		:=	""	
Private cTexto		:=	""
Private lTudoOK		:=	.T.//Flag para garantir que as persistências forem concluídas com êxito.
Private cCadastro 	:=	"Cadastro de Análise Crítica Comercial"
Private cCargo		:=	"{"+Getmv("WHB_CARGO")+"}"
Private cDepart		:=	"{"+Getmv("WHB_DPTO")+"}"
Private aCargo		:=	&cCargo   //Cagos autorizados a aprovar e geras revisões
Private aDepart		:=	&cDepart//Departamentos autorizados a aprovar e geras revisões

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
		             {"Visualizar"	,"AxVisual"			,0,2} ,;
        		     {"Incluir"		,"U_PPAC012A (3)"	,0,3} ,;
		             {"Alterar"		,"U_PPAC012A (4)"	,0,4} ,;
        		     {"Excluir"		,"U_PPAC012A (5)"	,0,5} ,;
        		     {"Gerar Revisao","U_PPAC012A (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC012A (7)"	,0,7},;
        		     {"Imprimir"	,"U_TPPAR009"	,0,8},;        		     
        		     {"Legenda		","U_PPAC012H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC1"

dbSelectArea("ZC1")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return  ()
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC012H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros=================================================  
User Function PPAC012A (nOpc) 
Local nRecNo	:=	IIF(nOpc<>3,ZC1->(RecNo()),0)
Local lFlag		:=	.T. 
Local aUser	 	    := {}     
Local cAprovAnt		:= ""
Local cStaRevAnt	:= "" 
Local nRecNoAnt		:= '' 
lRet := ''
Do Case
	Case nOpc == 3 //Inclusao
		AxInclui( cString,,,,,,"U_PPAC012B  ("+AllTrim(Str(nOpc))+")",,,)
		  
	Case nOpc == 4 //Alteracao    
		If Empty(ZC1->ZC1_STATUS) .AND. ZC1->ZC1_STAREV
			AxAltera(cString,,nOpc,,,,,"U_PPAC012B  ("+AllTrim(Str(nOpc))+")",,,) 
		Else 
			lFlag		:=	.F.
			cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Alteração"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta"
		EndIf
		  
	Case nOpc == 5 //Excluir 
		lFlag		:=	.F.
		cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Exclusão"	
		cTexto		:=	"Não é permitido efetuar exclusão dos Registros."
		
	Case nOpc == 6 //Gerar revisão
		If !Empty(ZC1->ZC1_STATUS) .AND. ZC1->ZC1_STAREV  
			
			DBSelectArea("ZC1")
			ZC1->(DBgoto(nRecNo))    
			cAprovAnt	:= ZC1->ZC1_STATUS
			cStaRevAnt	:= ZC1->ZC1_STAREV
			nRecNoAnt	:= nRecNo
				
			nRecNo		:=	sfGerRev(nRecNo,nOpc)
			If nRecNo<>0
				DBSelectArea("ZC1")
				ZC1->(DBgoto(nRecNo))
				lRet := AxAltera(cString,,4,,,,,"U_PPAC012B  ("+AllTrim(Str(nOpc))+")",,,)
				If lRet = 3
				
					RecLock("ZC1",.F.) 
						DbDelete()
					ZC1->(MsUnLock())
					
					ZC1->(DBGoTo(nRecNoAnt))    
					RecLock("ZC1",.F.) 
						ZC1->ZC1_STATUS	:= cAprovAnt
						ZC1->ZC1_STAREV := cStaRevAnt
					ZC1->(MsUnLock())
			
				EndIf 
			EndIf
		Else
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Gerar Revisão"	
			cTexto		:=	"O registro não pode ser alterado, pois não foi aprovado/reprovado ou é uma revisão obsoleta."		
		EndIf		
	Case nOpc == 7 //Aprovar/Reprovar
		If Empty(ZC1->ZC1_STATUS) .AND. ZC1->ZC1_STAREV
			sfAprovar (nRecNo,nOpc)//7	
		Else 
			lFlag		:=	.F.			
			cTitulo		:=	"TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+") Aprovar/Reprovar"	
			cTexto		:=	"O registro não pode ser alterado, pois já foi aprovado/reprovado ou é uma revisão obsoleta."							
		EndIf	
		
	OtherWise
		lFlag		:=	.F.
		cTitulo:="TPPAC012->PPAC012A("+AllTrim(Str(nOpc))+")"
		cTexto:="Operação não configurada."
				
EndCase
If !lFlag
	MsgAlert(cTexto,cTitulo)			
EndIf
Return (lRet)
//==========================Fim da Incluisão de Registros==========================================
//==========================Validação para Gravação================================================
User Function PPAC012B (nOpc)
Local lRet		:=	.T.
Local aArea		:=	ZC1->(GetArea())
Local nRecNo	:=	IIF(nOpc<>3,ZC1->(REcNo()),0)
Local cMensagem	:=	"Há um documento pendente para análise."
Local cEMail	:=	""
cTitulo	:=	""	
cTexto	:=	""

Do Case
	Case nOpc == 3 //Inclusao 
		DBselectArea("ZC1")
		ZC1->(DBSetOrder(1))//ZC1_FILIAL, ZC1_ACC, ZC1_REV, R_E_C_N_O_, D_E_L_E_T_
		If !ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)))
			ZC1->(DBSetOrder(6))//ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET
			If !ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)))
				lRet:=.T.
			Else
				lRet:=.F.
				cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
				cTexto:="Já existe registro com o mesmo Produto e Projeto. Verifique "+ZC1->ZC1_ACC+" Revisão "+ZC1->ZC1_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC1->ZC1_ACC+" Revisão "+ZC1->ZC1_REV
		EndIf
		If lRet .AND. M->ZC1_RESTRI=="1" .AND. Empty(M->ZC1_QUAL)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Incluir"
			cTexto:="Se campo LOCAL RESTR.(ZC1_RESTRI) for sim, então é necessário informar o campo Qual (ZC1_QUAL)"								
		EndIf 
		If lRet .AND. M->ZC1_CUSTO=="1" .AND. Empty(M->ZC1_RELATA)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Incluir"
			cTexto:="Se campo CUSTO(ZC1_CUSTO) for sim, então é necessário informar o campo RELATAR (ZC1_RELATA)"								
		EndIf		
		If lRet .AND. M->ZC1_CONDFO=="4" .AND. Empty(M->ZC1_OUTROS)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo COND. FORNEC (ZC1_CONDFO) for igual a OUTROS, então é necessário informar o campo OUTROS QUAL? (ZC1_OUTROS)"								
		EndIf		
		If lRet .AND. M->ZC1_DOC=="1" .AND. (M->ZC1_ANOS)==0
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo SUJEITO DOC. (ZC1_DOC) for igual a SIM, então é necessário informar o campo QTOS ANOS? (ZC1_ANOS)"								
		EndIf		

		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_NOVADT)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL for igual a NAO, então é necessário informar o campo NOVO NIVEL"								
		EndIf		
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_ALTER)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL (ZC1_DESNIV) for igual a NAO, então é necessário informar o campo QUAIS (ZC1_ALTER)"								
		EndIf		
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situação Pendente "+cCadastro,M->ZC1_ACC,M->ZC1_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situação Pendente "+cCadastro+" "+M->ZC1_ACC ,cEMail,"",)
			EndIf		
		EndIf
		
	Case nOpc == 4 //Alteraçao
		DBselectArea("ZC1") 
		ZC1->(DBSetOrder(1))//ZC1_FILIAL, ZC1_ACC, ZC1_REV, R_E_C_N_O_, D_E_L_E_T_
		ZC1->(DBGotop())		
		If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)))
			Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_ACC+ZC1_REV)==(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)) .AND. lRet
				If ZC1->(RecNo())<>nRecNo  
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC1->(DBSkip())
			EndDo
			If lRet
				ZC1->(DBSetOrder(6))//ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET
				ZC1->(DBGotop())				
				If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)))
					Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)==(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)) .AND. lRet
						If ZC1->(RecNo())<>nRecNo .AND. ZC1->ZC1_ACC<>M->ZC1_ACC
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC1->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
						cTexto:="Já existe registro com o mesmo Produto e Projeto. Verifique "+ZC1->ZC1_ACC+" Revisão "+ZC1->ZC1_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
				cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC1->ZC1_ACC+" Revisão "+ZC1->ZC1_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Não há registro a ser alterado. Erro na operação de Alteração."
		EndIf 
		If lRet .AND. M->ZC1_RESTRI=="1" .AND. Empty(M->ZC1_QUAL)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Se campo LOCAL RESTR.(ZC1_RESTRI) for sim, então é necessário informar o campo Qual (ZC1_QUAL)"								
		EndIf		
		If lRet .AND. M->ZC1_CONDFO=="4" .AND. Empty(M->ZC1_OUTROS)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Se campo COND. FORNEC (ZC1_CONDFO) for igual a OUTROS, então é necessário informar o campo OUTROS QUAL? (ZC1_OUTROS)"								
		EndIf
		If lRet .AND. M->ZC1_CUSTO=="1" .AND. Empty(M->ZC1_RELATA)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Alteração"
			cTexto:="Se campo CUSTO(ZC1_CUSTO) for sim, então é necessário informar o campo RELATAR (ZC1_RELATA)"								
		EndIf		
		If lRet .AND. M->ZC1_DOC=="1" .AND. (M->ZC1_ANOS)==0
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Se campo SUJEITO DOC. (ZC1_DOC) for igual a SIM, então é necessário informar o campo QTOS ANOS? (ZC1_ANOS)"								
		EndIf
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_NOVADT)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Alteração"
			cTexto:="Se campo MESMO NIVEL for igual a NAO, então é necessário informar o campo NOVO NIVEL"								
		EndIf			
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_ALTER)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL (ZC1_DESNIV) for igual a NAO, então é necessário informar o campo QUAIS (ZC1_ALTER)"								
		EndIf		 
		
	Case nOpc == 6 //Gerar Revisão
		DBselectArea("ZC1") 
		ZC1->(DBSetOrder(1))//ZC1_FILIAL+ZC1_ACC+ZC1_REV
		ZC1->(DBGotop())		
		If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)))
			Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_ACC+ZC1_REV)==(xFilial("ZC1")+M->(ZC1_ACC+ZC1_REV)) .AND. lRet
				If ZC1->(RecNo())<>nRecNo
					lRet:=.F.
				Else
					lRet:=.T.	
				EndIf
				ZC1->(DBSkip())
			EndDo
			If lRet
				ZC1->(DBSetOrder(6))//ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET
				ZC1->(DBGotop())				
				If ZC1->(DBSeek(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)))
					Do While ZC1->(!EoF()) .AND. ZC1->(ZC1_FILIAL+ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)==(xFilial("ZC1")+M->(ZC1_CODPRO+ZC1_REVPEC+ZC1_PROJET)) .AND. lRet
						If ZC1->(RecNo())<>nRecNo .AND. M->ZC1_ACC<>ZC1->ZC1_ACC
							lRet:=.F.
						Else
							lRet:=.T.	
						EndIf
						ZC1->(DBSkip())
					EndDo
					If !lRet
						lRet:=.F.
						cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
						cTexto:="Já existe registro com o mesma Peça e Projeto. Verifique "+ZC1->ZC1_ACC+" Revisão "+ZC1->ZC1_REV			
					EndIf
				Else
					lRet:=.T.
				EndIf				
			Else
				lRet:=.F.
				cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
				cTexto:="Já existe registro com a mesma numeração de controle e revisão. Verifique "+ZC1->ZC1_ACC+" Revisão "+ZC1->ZC1_REV			
			EndIf
		Else
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Não há registro a ser alterado. Erro na operação de Alteração."
		EndIf
		If lRet .AND. Empty(M->ZC1_MOTIVO)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="É necessário informar o movito da revisão."								
		EndIf
		If lRet .AND. M->ZC1_RESTRI=="1" .AND. Empty(M->ZC1_QUAL)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Gera Revisão"
			cTexto:="Se campo LOCAL RESTR.(ZC1_RESTRI) for sim, então é necessário informar o campo Qual (ZC1_QUAL)"								
		EndIf		
		If lRet .AND. M->ZC1_CONDFO=="4" .AND. Empty(M->ZC1_OUTROS)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Se campo COND. FORNEC (ZC1_CONDFO) for igual a OUTROS, então é necessário informar o campo OUTROS QUAL? (ZC1_OUTROS)"								
		EndIf		
		If lRet .AND. M->ZC1_DOC=="1" .AND. (M->ZC1_ANOS)==0
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Se campo SUJEITO DOC. (ZC1_DOC) for igual a SIM, então é necessário informar o campo QTOS ANOS? (ZC1_ANOS)"								
		EndIf
		If lRet .AND. M->ZC1_CUSTO=="1" .AND. Empty(M->ZC1_RELATA)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")Gera Revisão"
			cTexto:="Se campo CUSTO(ZC1_CUSTO) for sim, então é necessário informar o campo RELATAR (ZC1_RELATA)"								
		EndIf
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_NOVADT)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Gera Revisão"
			cTexto:="Se campo MESMO NIVEL for igual a NAO, então é necessário informar o campo NOVO NIVEL)"								
		EndIf			
				
		If lRet .AND. M->ZC1_DESNIV=="2" .AND. Empty(M->ZC1_ALTER)
			lRet:=.F.
			cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+") Incluir"
			cTexto:="Se campo MESMO NIVEL (ZC1_DESNIV) for igual a NAO, então é necessário informar o campo QUAIS (ZC1_ALTER)"								
		EndIf	
		If lRet 
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
			cMensagem:=sfTexto("Situação Pendente "+cCadastro,M->ZC1_ACC,M->ZC1_REV,QA_USUARIO()[3],cMensagem)//Para HTML
			If !Empty(cEMail)
				U_TWHBX001 (cMensagem,"Situação Pendente "+cCadastro+" "+M->ZC1_ACC ,cEMail,"",)
			EndIf		
		EndIf						
		
	OtherWise	
		lRet:=.F.
		cTitulo:="TPPAC012->PPAC012A->PPAC012B("+AllTrim(Str(nOpc))+")"
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
Local   aUser	    := {}	
Local 	aAreaZC1	:=	ZC1->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }  
Private	aStru		:=	ZC1->(DbStruct())
Private	cNomArq 	:=	""
 
cNomArq 			:=	CriaTrab(aStru,.T.) 

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.) 
dbClearIndex()     

dbSelectArea("ZC1")
ZC1->(DBGoTo(nRecNo)) 
dbSelectArea("TRB")
RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC1->&(aStru[nCont][1])
	Next nCont
	TRB->ZC1_REV	:=	sfRevisao (ZC1->ZC1_ACC)//Nova Revisão
	TRB->ZC1_APPRO	:=  StoD(" / / ")
	TRB->ZC1_STATUS	:=	""
	TRB->ZC1_STAREV	:=	.T.		
	TRB->ZC1_MOTIVO	:=	""		
	TRB->ZC1_DTREV	:=	dDataBase		
TRB->(MsUnLock())

BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC1")
	ZC1->(dbSetOrder(1))//ZC1_FILIAL+ZC1_ACC+ZC1_REV
	If !ZC1->(DBSeek(xFilial("ZC1")+TRB->(ZC1_ACC+ZC1_REV)))
		lRet:=RecLock("ZC1",.T.)
			If lRet
				For nCont := 1 TO FCount() 	
					FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
				Next nCont
				ZC1->ZC1_FILIAL := TRB->ZC1_FILIAL					
			EndIf
		nRecNoAtu:=ZC1->(RecNo())
		ZC1->(MsUnLock())  								
		
		dbSelectArea("ZC1") //Atualiza o registro como vesão não atual
		ZC1->(DBGoTo(nRecNo)) 
		lRet:=RecLock("ZC1",.F.)
			If lRet 
				ZC1->ZC1_STAREV	:=	.F.
			EndIf	
		ZC1->(MsUnLock()) 				
						       
	Else
		lRet:=.F.
	EndIf 
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC012->PPAC012B->sfGerRev("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro"
	Else
		cTitulo:="TPPAC012->PPAC012B->sfGerRev("+AllTrim(Str(nOpc))+") Revisão"
		cTexto:="Revisão gerada com sucesso"			
	EndIf 
END TRANSACTION 

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension()) 
RestArea(aAreaZC1)
lTudoOK:=lRet
Return(nRecNoAtu)
//==========================Fim Gera revisão======================================== 
//===============================Aprovação de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC1	:=	ZC1->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC1->ZC1_STATUS) .OR. AllTrim(ZC1->ZC1_STATUS)=="N" ) .AND. ZC1->ZC1_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
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
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC012->PPAC012A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser Aprovado/Reprovado caso o registro que ainda não esteja aprovado ou que seja uma revisão atualizada",;
			"TPPAC012->PPAC012A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC1)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC1	:= 	ZC1->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cACC	:=	""
Local cREV	:=	""
dbSelectArea("ZC1")
ZC1->(DBSetOrder(1)) //ZC1_FILIAL,ZC1_ACC,ZC1_REV
ZC1->(DBGoTo(nRecNo))
cACC	:=	ZC1->ZC1_ACC
cREV	:=	ZC1->ZC1_REV   
BEGIN TRANSACTION
	Do Case
		Case	ZC1->ZC1_RESP==cMatr
			If ZC1->(DBSeek(xFilial("ZC1")+cACC+cREV))
				lFlag:=RecLock("ZC1",.F.)
					ZC1->ZC1_APPRO		:=dDataBase		
					If nOpc==7  //Aprovação
						ZC1->ZC1_STATUS		:="S"
					ElseIf nOpc==8//Reprovaçào 
						ZC1->ZC1_STATUS		:="N"
					EndIf					
				ZC1->(MsUnLock())
			Else 
				lFlag:=.F.
				cTexto:="O Registro não encontrado. Erro na operação"
				cTitulo:="TPPAC012->PPAC012A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf 
			 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
			cTitulo:="TPPAC012->PPAC012A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			
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
	dbSelectArea("ZC1")
	ZC1->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC1->ZC1_ACC
		ZCC->ZCC_REV	:=	ZC1->ZC1_REV			
		ZCC->ZCC_TABELA	:=	"ZC1"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprovação "+cCadastro,ZC1->ZC1_ACC,ZC1->ZC1_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC1->ZC1_ACC ,cEMail,"",)})
	EndIf	
EndIf
If lFlag .AND. nOpc==7//Aprovado
	cMensagem:="O registro da Rotina "+cCadastro+" Numero de Controle "+ZC1->ZC1_ACC+"-"+ZC1->ZC1_REV+" foi aprovado."
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC1->ZC1_RESP,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Registro Aprovado"+cCadastro,ZC1->ZC1_ACC,ZC1->ZC1_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		Processa({|| U_TWHBX001 (cMensagem,"Registro Aprovado"+cCadastro+" "+ZC1->ZC1_ACC ,cEMail,"",)})
	EndIf	
EndIf

RestArea(aAreaZC1)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//================================REVISÃO =========================================================
Static Function sfRevisao (cACC)
Local cRet		:=	""
Local aAreaZC1	:=	ZC1->(GetArea())
DBSelectArea("ZC1")
ZC1->(DBGoTop())
ZC1->(DBSetOrder(1))//ZC1_FILIAL+ZC1_ACC+ZC1_REV
If ZC1->(DBSeek(xFilial("ZC1")+cACC))
	Do While ZC1->(!EoF()) .AND. (ZC1->(ZC1_FILIAL+ZC1_ACC)) == ;
			  (xFilial("ZC1")+(cACC))
		cRet:=ZC1->ZC1_REV			 					
		ZC1->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC1)
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
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||IIF(Empty(AllTrim(cGetTexto)),,oDlgEmail:End())},037,012,,,,.T.,,"",,,,.F. )

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