#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TPPAC009 º Autor ³ HANDERSON DUARTE   º Data ³  11/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CADASTRO DA CONFIRMAÇÃO DA QUALIFICAÇÃO DO PROCESSO        º±±
±±º          ³ TABELA ZC8 MSSQL                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 - WHB                                                 º±±
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
User Function TPPAC009()

Local aCores := {{"	ZC8_STAREV	.AND. Empty(ZC8_APROV)"		,"BR_AMARELO" },;   //Pendente, Aguardando revisão ou aprovacao
                 {"	!ZC8_STAREV"					 		,"BR_PRETO" },;     //Revisão obsoleta
                 {"ZC8_APROV=='S'"       					,"BR_VERDE"},;      //Aprovado
                 {"ZC8_APROV=='N'" 						  	,"DISABLE" }}       //Reprovado
                                               

Private cCadastro := "CONFIRMAÇÃO DA QUALIFICAÇÃO DO PROCESSO"

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

Private aRotina := { {"Pesquisar"		,"AxPesqui"			,0,1} ,;
		             {"Visualizar"		,"U_PPAC009A (2)"	,0,2} ,;
        		     {"Incluir"			,"U_PPAC009A (3)"	,0,3} ,;
		             {"Alterar"			,"U_PPAC009A (4)" 	,0,4} ,;
        		     {"Excluir"			,"U_PPAC009A (5)"	,0,5} ,;
        		     {"Gerar Revisao"	,"U_PPAC009A (6)"	,0,6} ,;
        		     {"Aprovar/Reprovar","U_PPAC009A (7)"	,0,7},;
        		     {"Imprimir"		,"U_TPPAR007"		,0,8},;        		     
        		     {"Legenda"			,"U_PPAC009H"		,0,9}}


Private cString := "ZC8"
Private cFiltro := 'ZC8_QUESTA == "01"'

dbSelectArea(cString)
dbSetOrder(1)

Set Filter To &cFiltro
mBrowse( 6,1,22,75,cString,,,,,,aCores)
Set Filter To                                       

Return 
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC009H() 
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
                                   {"BR_VERDE"    		,"Aprovado"	},;
                                   {"DISABLE"    		,"Reprovado"},;                                   
                                   {"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//==================================================================================================
User Function PPAC009A(nOpc)
Local aArea	:= ZC8->(GetArea())
Local nReg	:=IIF(nOpc==3,0,ZC8->(Recno()))
Local lFlag	:=.F. 


If nOpc==2//Visualizar
	sfProcessa("ZC8",nReg,nOpc)
EndIf

If nOpc==3//Incluir
	sfProcessa("ZC8",nReg,nOpc)	
EndIf

If nOpc==4//Alterar
	sfProcessa("ZC8",nReg,nOpc)
EndIf

If nOpc==5//Excluir
	MsgStop("Não é permitito excluir os registros","TPPAC009->PPAC009A("+AllTrim(Str(nOpc))+")")
EndIf

If nOpc==6//Gerar Revisao

	Set Filter To

	sfGeraRev(nReg,nOpc)                                
	
	Set Filter To &cFiltro 
EndIf

If nOpc==7//Aprovar/Reprovar 

	Set Filter To
	
	sfAprovar (nReg,nOpc)
	
	Set Filter To &cFiltro
	
EndIf

RestArea(aArea)
Return .T.
//===============================Aprovação de Registros ===========================================  
Static Function sfAprovar (nReg,nOpc)//7
Local nRecNo	:=	nReg 
Local aUser	 	:= {}  
Local aAreaZC8	:=	ZC8->(GetArea())
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC8->ZC8_APROV) .OR. AllTrim(ZC8->ZC8_APROV)=="N" ) .AND. ZC8->ZC8_STAREV//Só poderá ser aprovado caso o pedido que ainda não esteja aprovado
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
					Processa({|| sfAprvRep	(nRecNo,8,QAA->QAA_MAT,QAA->QAA_EMAIL)}) //Reprovar
				Else
					Processa({||sfAprvRep	(nRecNo,7,QAA->QAA_MAT,QAA->QAA_EMAIL)})	//Aprovar		
				EndIf		
				
			EndIf
			QAA->(DBSkip())
		EndDo
	Else 
		MsgStop("Usuário sem permissão para aprovar o documento.","TPPAC009->PPAC009A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")
	EndIf
Else
	MsgAlert("Só poderá ser Aprovado/Reprovado caso o registro que ainda não esteja aprovado ou que seja uma revisão atualizada",;
			"TPPAC009->PPAC009A->sfAprvRep("+AllTrim(Str(nOpc))+") Aprovação")			
EndIf

RestArea(aAreaQAA)
RestArea(aAreaZC8)

Return ()
//==========================Fim da Aprovação de Registros==========================================
//================================APROVAÇÃO OU REPROVAÇÃO DO PEDIDO================================
Static Function sfAprvRep (nRecNo,nOpc,cMatr,cEMailRem)  
Local aAreaZC8	:= 	ZC8->(GetArea()) 
Local cMensagem	:=	"" 
Local cEMail	:=	""
Local lFlag		:=	.T. 
Local cNUMQUA	:=	""
Local cREVQUA	:=	""
Local nSeq		:=	1//Sequência das perguntas
Local cTexto	:=	""
Local cTitulo	:=	""
dbSelectArea("ZC8")
ZC8->(DBSetOrder(3)) //ZC8_FILIAL,ZC8_NUMQUA,ZC8_REV,ZC8_QUESTA
ZC8->(DBGoTo(nRecNo))
cNUMQUA	:=	ZC8->ZC8_NUMQUA
cREVQUA	:=	ZC8->ZC8_REV   
BEGIN TRANSACTION
	Do Case
		Case	ZC8->ZC8_PRODUC==cMatr
			nSeq:=1
			If Empty(DtoS(ZC8->ZC8_DTPROC))
				If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)))
					Do While ZC8->(!EoF()) .AND. ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) == (xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)) .AND. lFlag
						nSeq++
						lFlag:=RecLock("ZC8",.F.)
							ZC8->ZC8_DTPROC		:=dDataBase		
						ZC8->(MsUnLock())
						ZC8->(DBSkip())
					EndDo
				Else
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf
			Else 
				lFlag:=.F.
				cTexto:="O Registro já foi aprovada pela Produção e não poderá ser alterada a data da mesma"
				cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf 
			
		Case	ZC8->ZC8_QUAL  ==cMatr 
			nSeq:=1		
			If Empty(DtoS(ZC8->ZC8_DTQUAL))
				If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)))
					Do While ZC8->(!EoF()) .AND. ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) == (xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)) .AND. lFlag
						nSeq++			
						lFlag:=RecLock("ZC8",.F.)
							ZC8->ZC8_DTQUAL		:=dDataBase		
						ZC8->(MsUnLock())
						ZC8->(DBSkip())
					EndDo
				Else
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf				
			Else 
				lFlag:=.F.
				cTexto:="O Registro já foi aprovada pela Qualidade e não poderá ser alterada a data da mesma"
				cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf 		 
			
		Case	ZC8->ZC8_ENG   ==cMatr 
			nSeq:=1
			If Empty(DtoS(ZC8->ZC8_DTENG))
				If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)))
					Do While ZC8->(!EoF()) .AND. ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) == (xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)) .AND. lFlag
						nSeq++			
						lFlag:=RecLock("ZC8",.F.)
							ZC8->ZC8_DTENG		:=dDataBase		
						ZC8->(MsUnLock())
						ZC8->(DBSkip())
					EndDo
				Else
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf
			Else 
				lFlag:=.F.		
				cTexto:="O Registro já foi aprovada pela Engenharia e não poderá ser alterada a data da mesma"
				cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			EndIf 
					
		OtherWise
			lFlag:=.F.
			cTexto:="Usuário não faz parte do documento. A operação não proderá ser gravada."
			cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"
			
	EndCase
	
	If lFlag
		nSeq:=1	
		dbSelectArea("ZC8")  
		ZC8->(DBSetOrder(3)) //ZC8_FILIAL,ZC8_NUMQUA,ZC8_REV,ZC8_QUESTA		
		ZC8->(DBGoTo(nRecNo))
		If nOpc==7  //Aprovação
			If !Empty(DtoS(ZC8->ZC8_DTPROC)) .AND. !Empty(DtoS(ZC8->ZC8_DTQUAL)) .AND. !Empty(DtoS(ZC8->ZC8_DTENG))//Se todas as datas estiverem preenchida o registro está aprovado
				If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)))
					Do While ZC8->(!EoF()) .AND. ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) == (xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)) .AND. lFlag
						nSeq++			
						lFlag:=RecLock("ZC8",.F.)
							ZC8->ZC8_APROV		:="S"
						ZC8->(MsUnLock())
						ZC8->(DBSkip())
					EndDo
				Else
					lFlag:=.F.
					cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
					cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
				EndIf						 	
			EndIf
		ElseIf nOpc==8//Reprovaçào 
			If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)))
				Do While ZC8->(!EoF()) .AND. ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) == (xFilial("ZC8")+cNUMQUA+cREVQUA+StrZero(nSeq,2)) .AND. lFlag
					nSeq++			
					lFlag:=RecLock("ZC8",.F.)
						ZC8->ZC8_APROV		:="N"
					ZC8->(MsUnLock())
					ZC8->(DBSkip())
				EndDo
			Else
				lFlag:=.F.
				cTexto:="Falha na persistência dos dados, Verificar se há outro usuário utilizando o mesmo registro"
				cTitulo:="TPPAC009->PPAC009A->sfAprovar->sfAprvRep->("+AllTrim(Str(nOpc))+") Aprovação"					
			EndIf
		EndIf
	EndIf
	
	If  !lFlag  //Desfaz a transação se tiver algum erro
		DisarmTransaction()
		RollBackSX8()
	EndIf	
	
	
END TRANSACTION

If  !lFlag  //Aviso de Erro no Processo
	MsgStop(cTexto,cTitulo)
EndIf

If lFlag .AND. nOpc==8//Reprovaçào 		
	cMensagem:=sfJustif ( )	//chamada da tela de justificativa				
	//Grava na tabela de justificativas
	dbSelectArea("ZC8")
	ZC8->(DBGoTo(nRecNo))		
	RecLock("ZCC",.T.)	
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC8->ZC8_NUMQUAL
		ZCC->ZCC_REV	:=	ZC8->ZC8_REV			
		ZCC->ZCC_TABELA	:=	"ZC8"                   
		ZCC->ZCC_TEXTO	:=	cMensagem						
		ZCC->ZCC_DATA	:=	dDataBase			
		ZCC->ZCC_USUAR	:=	cMatr
	ZCC->(MsUnLock())		 				
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_PRODUC,"QAA_EMAIL")
	//Chamada da funcão do e-mail
	//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
	cMensagem:=sfTexto("Reprovação "+cCadastro,ZC8->ZC8_NUMQUAL,ZC8->ZC8_REV,cMatr,cMensagem)//Para HTML
	If !Empty(cEMail)
		U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC8->ZC8_NUMQUAL ,cEMail,"",)
	EndIf
	
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_QUAL  ,"QAA_EMAIL")
	If !Empty(cEMail)
		U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC8->ZC8_NUMQUAL ,cEMail,"",)
	EndIf
	
	cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_ENG   ,"QAA_EMAIL")
	If !Empty(cEMail)
		U_TWHBX001 (cMensagem,"Reprovação "+cCadastro+" "+ZC8->ZC8_NUMQUAL ,cEMail,"",)
	EndIf	
EndIf

RestArea(aAreaZC8)
Return( )
//========================FIM DA  APROVAÇÃO OU REPROVAÇÃO =========================================
//===============================Gerar Versão     =================================================  
Static Function sfGeraRev(nRecNo,nOpc)
Local 	lRet		:=	.F. 
Local 	cTexto		:=	""
Local 	cTitulo		:=	""
Local	nRecNoAtu	:=	0	
Local 	aAreaZC8	:=	ZC8->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }
Local 	cReviNova	:=	""
Local 	nSeq		:=	0 
Local 	cNUMQUA		:=	""
Local 	cREV		:=	""         
Local cAprovAnt		:= ""
Local cStaRevAnt	:= ""

Private	aStru 		:=	ZC8->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 	:=	CriaTrab(aStru,.T.)	
If (Select("TRBREV") <> 0)
	dbSelectArea("TRBREV")
	dbCloseArea()
EndIf 
	
DBUSEAREA(.T.,,cNomArq,"TRBREV",nil,.F.)
    
If !Empty(ZC8->ZC8_APROV) .AND. ZC8->ZC8_STAREV //Só poderá gerar revisão se não tiver data fim
	dbSelectArea("TRBREV")
	dbSelectArea("ZC8")
	ZC8->(dbSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA	
	ZC8->(DBGoTo(nRecNo))
	cReviNova	:=	sfRevisao (ZC8->ZC8_NUMQUAL)//Nova Revisão	
 	cNUMQUA		:=	ZC8->ZC8_NUMQUA
 	cREV		:=	ZC8->ZC8_REV 
 	cAprovAnt	:= ZC8->ZC8_APROV
 	cStaRevAnt	:= ZC8->ZC8_STAREV
 	nSeq++
	If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREV+StrZero(nSeq,2))) 			
		Do While ZC8->(!EoF()) .AND. (xFilial("ZC8")+cNUMQUA+cREV+StrZero(nSeq,2))==ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA)
			RecLock("TRBREV",.T.)
				For nCont:=1 to Len(aStru)
					TRBREV->&(aStru[nCont][1]) := ZC8->&(aStru[nCont][1])
				Next nCont
				TRBREV->ZC8_REV	:=	cReviNova
				TRBREV->ZC8_DTENG	:=  StoD(" / / ")
				TRBREV->ZC8_DTQUAL	:=  StoD(" / / ")
				TRBREV->ZC8_DTPROC	:=  StoD(" / / ")				
				TRBREV->ZC8_APROV	:=	""
				TRBREV->ZC8_STAREV	:=	.T.		
				TRBREV->ZC8_DTREV	:=	dDataBase
				TRBREV->ZC8_FILIAL	:=	xFilial("ZC8")		
			TRBREV->(MsUnLock())  
			ZC8->(DBSkip()) 
			nSeq++			
		EndDo
		If nSeq==23   //26 //A quantidade de registros tem que ser 25, equivalente ao número de questões
			lRet:=.T.
		Else
			lRet:=.F.			
		EndIf
	Else
		lRet:=.F.	
	EndIf
	If lRet
		BEGIN TRANSACTION
			TRBREV->(DBGotop())
			dbSelectArea("ZC8")
			ZC8->(dbSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA
			Do While TRBREV->(!EoF()) .AND. lRet
				If !ZC8->(DBSeek(xFilial("ZC8")+TRBREV->(ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA)))
					lRet:=RecLock("ZC8",.T.)
						If lRet
							For nCont := 1 TO FCount() 	
								FieldPut(nCont,TRBREV->&(EVAL(bCampo,nCont)))
							Next nCont
							ZC8->ZC8_FILIAL := TRBREV->ZC8_FILIAL					
						Else
							lRet:=.F.
							cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão"
							cTexto:="Erro ao gerar a revisão. Rotina RecLock "+TRBREV->(ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA)+" Registros da nova revisão."														
						EndIf
					ZC8->(MsUnLock())
				Else
					lRet:=.F.
					cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão"
					cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro. Questão "+TRBREV->ZC8_QUESTA+" Não encontrada para a nova revisão."
				EndIf
				TRBREV->(DBSkip())					
			EndDo		  								
			If lRet  //Atualiza os registros anteriores como revisão obsoleta
				dbSelectArea("ZC8")					
				ZC8->(DBGoTo(nRecNo))
				ZC8->(dbSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA						 
				nSeq:=1
				If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cREV+StrZero(nSeq,2)))
					Do While ZC8->(!EoF()) .AND. (xFilial("ZC8")+cNUMQUA+cREV+StrZero(nSeq,2))==ZC8->(ZC8_FILIAL+ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA) .AND.	lRet
						nSeq++
						lRet:=RecLock("ZC8",.F.)
							If lRet 
								ZC8->ZC8_STAREV	:=	.F.
							Else
								lRet:=.F.								
								cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão"
								cTexto:="Erro ao gerar a revisão. Rotina RecLock "+TRBREV->(ZC8_NUMQUA+ZC8_REV+ZC8_QUESTA)+" Registros da revisão obsoleta."																					
							EndIf	
						ZC8->(MsUnLock())
						ZC8->(DBSkip()) 
					EndDo
				Else
					cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão"
					cTexto:="Erro ao gerar a revisão, verifique se há algum usuário realizado alterações no registro. Questão "+StrZero(nSeq,2)+" Não encontrada para atualizar a revisão obsoleta."
					lRet:=.F.
				EndIf
			Else
				If Empty(AllTrim(cTitulo))
					cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão"
					cTexto:="Erro ao gerar a revisão. Ao finalizar a gravação da nova revisão foi constatado Erro."
				EndIf
				lRet:=.F.												
			EndIf
			If !lRet
				DisarmTransaction()
				RollBackSX8()
			Else
				cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão"
				cTexto:="Revisão gerada com sucesso"			
			EndIf
		END TRANSACTION 			
	Else 
		lRet:=.F.
		cTitulo:="TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão "+Str(nSeq)
		cTexto:="Erro na quantidade de questões, A quantidade de Questões de ser 22."		
	EndIf												       
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else 
		ZC8->(dbSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA
		
		ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA+cReviNova+"01"))	 
		
		If !sfProcessa("ZC8",ZC8->(RecNo()),nOpc)			//Chama a rotina para alterar a nova revisão  
		   			
			RecLock("ZC8",.F.) 
				DbDelete()
			ZC8->(MsUnLock())
			
			ZC8->(DBGoTo(nRecNo))    
			RecLock("ZC8",.F.) 
				ZC8->ZC8_APROV := cAprovAnt
				ZC8->ZC8_STAREV := cStaRevAnt
			ZC8->(MsUnLock())
		
		EndIf
		
	EndIf
Else
	MsgAlert("Só poderá ser gerada a revisão caso o registro esteja aprovado ou reprovado ou não seja uma revisão obsoleta ","TPPAC009->PPAC009A->sfGeraRev("+AllTrim(Str(nOpc))+") Revisão")		
EndIf	

If(Select("TRBREV")<>0)
	dbSelectArea("TRBREV")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension())
 
RestArea(aAreaZC8)

Return ( )
//==========================Fim da Geração de Versão     ==========================================
//================================Função para Inclusão, Alteração Visualização e Exclusão========================
Static Function sfProcessa(cAlias,nReg,nOpc)

Local oDlg			:= NIL
Local lOk 			:= .F.
Local aCposVis		:= {}
Local aCposAlt		:= {}
Local aButtons		:= {}

Private aTELA[0][0],aGETS[0]

Private aItens 		:= {"Adequado","Não Adequado","Não Aplicável"} 

Private cPlanej01 	:= cPlanej02 := cPlanej03 := cPlanej04 			:= Space(40)
Private cPlanej05 	:= cPlanej06 := cPlanej07 := cPlanej08 			:= Space(40)
Private cPlanej09 	:= cPlanej10 := cPlanej11 := cPlanej12 			:= Space(40)
Private cPlanej13 	:= cPlanej14 := cPlanej15 := cPlanej16 			:= Space(40)
Private cPlanej17 	:= cPlanej18 := cPlanej19 := cPlanej20 			:= Space(40)
//Private cPlanej21 	:= cPlanej22 := cPlanej23 := cPlanej24 			:= Space(40)
//Private cPlanej25 	:= Space(40)
Private cPlanej21 	:= cPlanej22                        			:= Space(40)

Private cObtido01 	:= cObtido02 := cObtido03 := cObtido04 			:= Space(40)
Private cObtido05 	:= cObtido06 := cObtido07 := cObtido08 			:= Space(40)
Private cObtido09 	:= cObtido10 := cObtido11 := cObtido12 			:= Space(40)
Private cObtido13 	:= cObtido14 := cObtido15 := cObtido16 			:= Space(40)
Private cObtido17 	:= cObtido18 := cObtido19 := cObtido20 			:= Space(40)
//Private cObtido21 	:= cObtido22 := cObtido23 := cObtido24 			:= Space(40)
//Private cObtido25 	:= Space(40)  
Private cObtido21 	:= cObtido22 						 			:= Space(40)

Private cChoice01 	:= cChoice02 := cChoice03 := cChoice04 	:= aItens[1]
Private cChoice05 	:= cChoice06 := cChoice07 := cChoice08 	:= aItens[1]
Private cChoice09 	:= cChoice10 := cChoice11 := cChoice12 	:= aItens[1]
Private cChoice13 	:= cChoice14 := cChoice15 := cChoice16 	:= aItens[1]
Private cChoice17 	:= cChoice18 := cChoice19 := cChoice20 	:= aItens[1]
//Private cChoice21 	:= cChoice22 := cChoice23 := cChoice24 	:= aItens[1]
//Private cChoice25 	:= aItens[1] 
Private cChoice21 	:= cChoice22 							:= aItens[1]

Private cPenden01 	:= cPenden02 := cPenden03 := cPenden04 			:= Space(40)
Private cPenden05 	:= cPenden06 := cPenden07 := cPenden08 			:= Space(40)
Private cPenden09 	:= cPenden10 := cPenden11 := cPenden12 			:= Space(40)
Private cPenden13 	:= cPenden14 := cPenden15 := cPenden16 			:= Space(40)
Private cPenden17 	:= cPenden18 := cPenden19 := cPenden20 			:= Space(40)
//Private cPenden21 	:= cPenden22 := cPenden23 := cPenden24 			:= Space(40)
//Private cPenden25 	:= Space(40)
Private cPenden21 	:= cPenden22 						 			:= Space(40)


aCposVis := { "ZC8_CODCLI", "ZC8_LOJA", "ZC8_CODPRO" }

aCposAlt := { "ZC8_UNID", "ZC8_DOCTO", "ZC8_REVDOC" }
				

DbSelectArea(cAlias)

Set Filter To 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Enchoice                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oDlg TITLE OemToAnsi(cCadastro) FROM 120,000 TO 516,795 OF oMainWnd PIXEL
						
RegToMemory(cAlias,(nOpc == 3))  
//RegToMemory(cAlias,.T.)  

Enchoice(cAlias,nReg,IIF(nOpc==6,4,nOpc), , , ,aCposVis ,{14,03,110,570}, , , , ,)

sfTELA(nOpc, oDlg)
                        
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk := sfTudOk(nOpc), Iif(lOk,oDlg:End(),)},{||oDlg:End()}, , )

If lOk .and. (nOpc == 3 .or. nOpc == 4 .or. nOpc == 6)
	Processa({||sfGravar(cAlias,nOpc)})
Endif

If nOpc == 5 .and. lOk
//	A280Dele()
Endif

Set Filter To &cFiltro   

Return lOk 
//================================Fim da Função para Inclusão, Alteração Visualização e Exclusão======================== 
//================================Função para Gravar os dados ==========================================================
Static Function sfGravar(cAlias,nOpc)

Local nCont, nRec
Local bCampo	:= { |nCPO| Field(nCPO) }
Local lGraOk	:= .T.
Local nSeq
Local lFlag		:=.F.
Local cTitulo	:=""
Local cTexto	:="" 
local aArea		:=	ZC8->(GetArea())
Local cEMail	:=	"" 
Local aUser		:=	{} 

PswOrder(1)
If PswSeek( __cuserid, .T. )
  aUser := PswRet() // Retorna vetor com informações do usuário
EndIf

Begin Transaction
	DbSelectArea(cAlias)
	ZC8->(DbSetOrder(3))	
	For nRec := 1 To 22 // 25 perguntas		
		nSeq := StrZero(nRec,2)	
		If nOpc==4 .OR. nOpc==6
			ZC8->(DbSeek(xFilial(cAlias)+M->ZC8_NUMQUA+M->ZC8_REV+nSeq))			
			lFlag:=RecLock(cAlias,.F.)			
		Else
			lFlag:=RecLock(cAlias,.T.)
		Endif
	    If lFlag//Verifica o transação
			For nCont := 1 To FCount()
				If "FILIAL"$Field(nCont)
					FieldPut(nCont,xFilial(cAlias))
				Else
					FieldPut(nCont,M->&(EVAL(bCampo,nCont)))
				Endif
			Next nCont
			
			ZC8->ZC8_QUESTA	:= nSeq
			ZC8->ZC8_RPOSTA	:= IIF(cChoice&(nSeq) == "Adequado","1",IIF(cChoice&(nSeq)=="Não Adequado","2","3")) //"Adequado","Não Adequado","Não Aplicável"
			ZC8->ZC8_PLAN	:= cPlanej&(nSeq)
			ZC8->ZC8_OBTIDO	:= cObtido&(nSeq)
			ZC8->ZC8_PENDEN	:= cPenden&(nSeq)
			If nOpc==4 .OR. nOpc==6
				ZC8->ZC8_DTPROC	:=	StoD(" / / ")	
				ZC8->ZC8_DTENG 	:=	StoD(" / / ")				
				ZC8->ZC8_DTQUAL	:=	StoD(" / / ")								
			EndIf
			
			DbSelectArea(cAlias)
	    Else 
	    	nRec:=22 //   25
	    	lGraOk:=.F.
			DisarmTransaction()
			RollBackSX8()
			cTitulo:="TPPAC009->PPAC009A->sfGravar("+AllTrim(Str(nOpc))+")"
			cTexto:="Erro ao gravar os dasdos, verifique se há algum usuário realizado alterações no registro"	    				
	    EndIf
	Next nRec
	If lGraOk
				ConfirmSX8() 
	EndIf			
	ZC8->(MsUnLock())
End Transaction


If !lFlag
	MsgAlert(cTexto,cTitulo)
Else
	If nOpc==4//Alteracao
		//Enviar um e-mail aos responsáveis
		//Chamada da funcão do e-mail			
		//TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)		 
		cMensagem:=sfTexto("Alteração "+cCadastro,ZC8->ZC8_NUMQUA,ZC8->ZC8_REV,Posicione("QAA",6,aUser[1][2],"QAA_MAT"),"Alteração Caracteristicas Especiais")//Para HTML		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_PRODUC,"QAA_EMAIL")
		If !Empty(cEMail) 			
			U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZC8->ZC8_NUMQUA ,cEMail,,)
		EndIf
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_QUAL,"QAA_EMAIL")
		If !Empty(cEMail) 						
			U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZC8->ZC8_NUMQUA ,cEMail,,)
		EndIf
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC8->ZC8_ENG,"QAA_EMAIL")
		If !Empty(cEMail) 		
			U_TWHBX001 (cMensagem,"Alteração "+cCadastro+" "+ZC8->ZC8_NUMQUA ,cEMail,,)
		EndIf																
	EndIf 	
EndIf



RestArea(aArea)			
Return lGraOk 
//================================fim da Função para Gravar os dados ===================================================
//================================Função para montar a tela de perguntas ===============================================
Static Function sfTELA(nOpc, oDlg)

Local oScrollBox := Nil
Local cOCombo
Local cOPlanej
Local cOObtido
Local cOPenden
Local cOChoice
Local nCont		:=0 
Local cBloco01	:=cBloco02:=cBloco03:=cBloco04:=""
Local cPlanej	:=cObtido:=cPenden:=cChoice:=""
Local nLinha	:=15

Local nNum:=0
					                       
Private aObj := {}

DEFINE FONT oFont 	 NAME "Arial" SIZE 5.5,12.5
DEFINE FONT oFontTxt NAME "Courier New" SIZE 6,0
DEFINE FONT oFontCou NAME "Courier New" SIZE 5,15

If nOpc <> 3
	sfCarreg()
Endif


oScrollBox := TScrollBox():New(oDlg,111,03,180,570,.T.,.T.,.T.) 
@ 000,000 MSPANEL oPanel1 PROMPT ""	COLOR CLR_WHITE,CLR_BLACK SIZE 555,012 OF oScrollBox
@ 004,004 SAY OemToAnsi("Item - Questão")	COLOR CLR_WHITE SIZE 065,010 OF oPanel1 PIXEL  //"Item - Pergunta"
@ 004,126 SAY OemToAnsi("Tipo")    			COLOR CLR_WHITE SIZE 010,010 OF oPanel1 PIXEL  //"Sim/Nao"
@ 004,169 SAY OemToAnsi("Planejamento")		COLOR CLR_WHITE SIZE 065,010 OF oPanel1 PIXEL  //"Comentarios/Acao Requerida"
@ 004,299 SAY OemToAnsi("Obtido")			COLOR CLR_WHITE SIZE 065,010 OF oPanel1 PIXEL  //"Responsavel"
@ 004,429 SAY OemToAnsi("Pendências")		COLOR CLR_WHITE SIZE 065,010 OF oPanel1 PIXEL  //"Dt. Prevista"	

@ 001,002 TO (15*26),124 		OF oScrollBox PIXEL
@ 001,002 TO (15*26),167 		OF oScrollBox PIXEL
@ 001,002 TO (15*26),297 		OF oScrollBox PIXEL
@ 001,002 TO (15*26),427		OF oScrollBox PIXEL
@ 001,002 TO (15*26),559		OF oScrollBox PIXEL


//Questionamentos (GET) 
For nCont:=1 to 22                      
	cChoice:="cChoice"+StrZero(nCont,2)
	cPlanej:="cPlanej"+StrZero(nCont,2)
	cObtido:="cObtido"+StrZero(nCont,2)
	cPenden:="cPenden"+StrZero(nCont,2)
			
	cOCombo:="oCombo"+StrZero(nCont,2)
	cOPlanej:="oPlanej"+StrZero(nCont,2)
	cOObtido:="oObtido"+StrZero(nCont,2)
	cOPenden:="oPenden"+StrZero(nCont,2)
	
	cBloco01:="{|u| If(PCount()>0,"+cPlanej+":=u,"+cPlanej+")}"
	cBloco02:="{|u| If(PCount()>0,"+cObtido+":=u,"+cObtido+")}"
	cBloco03:="{|u| If(PCount()>0,"+cPenden+":=u,"+cPenden+")}"	
	cBloco04:="{|u| If(PCount()>0,"+cChoice+":=u,"+cChoice+")}"	
	
	&cOCombo     := TComboBox():New( nLinha,125,&cBloco04,aItens,040,030,oScrollBox,,,,CLR_BLACK,CLR_WHITE,.T.,oFont,"",,,,,,,cChoice ) 						     

	&cOPlanej    := TGet():New( nLinha,168,&cBloco01,oScrollBox,128,010,PesqPict("ZC8","ZC8_PLAN"), ,CLR_BLACK,CLR_WHITE,oFontTxt, , ,.T.,"", , ,.F.,.F., ,.F.,.F.,"",cPlanej, , )
	&cOObtido    := TGet():New( nLinha,298,&cBloco02,oScrollBox,128,010,PesqPict("ZC8","ZC8_OBTIDO"), ,CLR_BLACK,CLR_WHITE,oFontTxt, , ,.T.,"", , ,.F.,.F., ,.F.,.F.,"",cObtido, , )	
	&cOPenden    := TGet():New( nLinha,428,&cBloco03,oScrollBox,128,010,PesqPict("ZC8","ZC8_PENDEN"), ,CLR_BLACK,CLR_WHITE,oFontTxt, , ,.T.,"", , ,.F.,.F., ,.F.,.F.,"",cPenden, , )		
													
	aAdd(aObj, {&(cOCombo), &(cOPlanej), &(cOObtido), &(cOPenden)})		                                                   
	nLinha:=nLinha+15
Next nCont           

sfSAY(oScrollBox,oFont)//Função para formar as Questões
      /*
If !Empty(M->ZC8_CHAVE)
	cChave := M->ZC8_CHAVE
Endif   
*/

If nOpc <> 3 .and. nOpc <> 4 .and. nOpc <> 6
	For nCont := 1 To Len(aObj)
		aObj[nCont,1]:lReadOnly := .T.
		aObj[nCont,2]:lReadOnly := .T.
		aObj[nCont,3]:lReadOnly := .T.
		aObj[nCont,4]:lReadOnly := .T.		
	Next nCont
Else
	For nCont := 1 To Len(aObj)
		aObj[nCont,4]:lReadOnly := .F.
	Next nCont
Endif

Return .T.                                                                                                              
//================================Fim da Função para montar a tela de perguntas ===============================================
//================================Função do SAY================================================================================
Static Function sfSay(oScrollBox,oFont)
Local cTit
Local cOTit
Local cQuest
Local cOQuest
Local cOLinh 
Local nLinha:=15
Local nCont	:=0
Local aTitulos	:={"PLANO GLOBAL DE TRABALHO","FATORES ERGONÔMICOS E HUMANOS","NÍVEIS DE INVENTÁRIO DE ARMAZENAMENTO","OBJETIVO PARA A QUALIDADE"}

Local aQuestoes	:={	{1,"Capacidade Produtiva PQS/ANO"}		,{1,"Máquina (Qtde)"},;
					{1,"Dispositivos (Qtde)"}				,{1,"Técnica Utilizada (Qtde)"},;
					{1,"Meios de Controle"}	  				,{1,"Embalagem"},;					
					{1,"Rastreabilidade"}	  				,{1,"Poka Yoke (Qtde)"},;					
					{1,"Peça Homem/Hora"}	  				,{1,"Tempo (Análise de Gargalo)"},;	
					{2,"Lay-out Área Produção M2"}			,{2,"Equipamentos Ergonômicos"},;					
					{2,"Número de Operadores/Turno"}		,{2,"Turnos Previstos"},;					
					{3,"Área de Recebimento"}	  			,{3,"Área de Expedição"},;
					{4,"PPM do Cliente"}		  			,{4,"CPK"},;					
					{4,"Eficiência do Processo"}  			,{4,"PPM Interno"},;					
					{4,"Performace de Entrega"}	  			,{4,"Reclamação de Cliente"}} //,;					
				//	{4,"Confiabilidade"}		  			,{4,"Mantenabilidade"},;					
				  //	{4,"Disponibilidade"}}
//Questionamentos (SAY)
/*
For nCont:=1 to Len(aQuestoes)
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	nNum++	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[nCont][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,003,{||aQuestoes[nCont][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),200)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
Next nCont
*/  
	//Questão 1
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[1][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[1][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 2	
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[2][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[2][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 3
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[3][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[3][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 4
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[4][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[4][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 5
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[5][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[5][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 6
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[6][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[6][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 7
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[7][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[7][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 8
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[8][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[8][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 9
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[9][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[9][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 10
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[10][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[10][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 11
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[11][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[11][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 12
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[12][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[12][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 13
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[13][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[13][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 14
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
//	cOLinh:="oLinh"+StrZero(nCont,2)	
  //	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[14][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[14][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 15
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[15][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[15][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 16
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[16][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[16][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 17
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[17][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[17][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 18
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[18][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[18][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 19
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[19][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[19][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 20
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[20][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[20][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 21
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[21][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[21][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 22
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
//	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[22][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,0013,{||aQuestoes[22][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
//	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
    /*
		//Questão 23
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[23][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,003,{||aQuestoes[23][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 24
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[24][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,003,{||aQuestoes[24][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
	//Questão 25
	cOTitulo:="oTit"+StrZero(nCont,2)
	cOQuest:="oQuest"+StrZero(nCont,2)
	cOLinh:="oLinh"+StrZero(nCont,2)	
	&cOTitulo      := TSay():New( nLinha,003,{||aTitulos[aQuestoes[25][1]]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	&cOQuest       := TSay():New( nLinha+5,003,{||aQuestoes[25][2]},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)	
	&cOLinh	       := TSay():New( nLinha+8,002,{||Replicate(OemToAnsi("_"),305)},oScrollBox,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE, 550,007)	
	nLinha:=nLinha+15
    */
	
Return()
//================================Fim da Função do SAY=========================================================================
//================================Função para carregar os questionamentos======================================================
Static Function sfCarreg()

Local cSeq
Local aArea		:= {}

aArea := GetArea()

DbSelectArea("ZC8")
DbSetOrder(3)
ZC8->(DbSeek(xFilial("ZC8")+M->ZC8_NUMQUA+M->ZC8_REV+"01"))

Do While xFilial("ZC8")+M->ZC8_NUMQUA+M->ZC8_REV == ZC8->ZC8_FILIAL+ZC8->ZC8_NUMQUA+ZC8->ZC8_REV ;
			.and. ZC8->(!Eof())
	
	cSeq := ZC8->ZC8_QUESTA
//	cPlanej	:=cObtido:=cPenden:=cChoice:=""
	
	cChoice&(cSeq)	:= aItens[Val(ZC8->ZC8_RPOSTA)]
	cPlanej&(cSeq)	:= ZC8->ZC8_PLAN
	cObtido&(cSeq)	:= ZC8->ZC8_OBTIDO

	cPenden&(cSeq) 	:= ZC8->ZC8_PENDEN
		
	DbSelectArea("ZC8")
	ZC8->(DbSkip())

EndDo

RestArea(aArea)

Return .T.
//================================Fim da Função para carregar os questionamentos======================================================
//================================Valida os Dados na Persistência=====================================================================
Static Function sfTudOk (nOpc)
Local aArea		:=	ZC8->(GetArea())
Local aAreaX3	:=	SX3->(GetArea())
Local lRet		:= .T. 
Local aCampo	:=	{}
Local cCampo	:=	""
Local cValid	:=	""

dbSelectArea("SX3")
dbSetOrder(1)    
MsSeek("ZC8")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "ZC8") )
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
			If Empty(M->ZC8_NUMQUA) .or. Empty(M->ZC8_REV)
				lRet := .F.
				Help(" ",1,"QPPAOBRIG")  // Campos obrigatorios
			Endif
			If !ExistChav("ZC8",M->ZC8_NUMQUA+M->ZC8_REV)
				lRet := .F.
				Help(" ",1,"JAGRAVADO")  // Campo ja Existe
			Endif
			
			If(M->ZC8_PRODUC == M->ZC8_ENG) .OR. (M->ZC8_PRODUC == M->ZC8_QUAL ) .OR.   (M->ZC8_ENG==M->ZC8_QUAL)
				lRet := .F.
				MsgAlert("As matrículas dos aprovadores não podem ser iguais.","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Incluir")				
			EndIf
			
		Case nOpc==4 //Alterar
			If Empty(ZC8->ZC8_APROV) .AND. ZC8->ZC8_STAREV
				lRet := .T.			
			Else
				lRet := .F.
				MsgAlert("O registro não pode ser alterado, pois já existe uma data de aprovação ou é uma revisão obsoleta","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Alteração")	
			EndIf 
			If (M->ZC8_PRODUC == M->ZC8_ENG) .OR. (M->ZC8_PRODUC == M->ZC8_QUAL ) .OR.   (M->ZC8_ENG==M->ZC8_QUAL)  
				lRet := .F.		
				MsgAlert("As matrículas dos aprovadores não podem ser iguais.","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Alterar")				
			EndIf		
	
		Case nOpc== 6 //Gerar Revisão
			If Empty(M->ZC8_MOTIVO)
				lRet := .F.
				MsgAlert("Para a geração de revisão o Campo Motivo é Obrigatório.","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")				
			Endif 				 
			If (M->ZC8_PRODUC == M->ZC8_ENG) .OR. (M->ZC8_PRODUC == M->ZC8_QUAL ) .OR.   (M->ZC8_ENG==M->ZC8_QUAL)
				lRet := .F.		
				MsgAlert("As matrículas dos aprovadores não podem ser iguais.","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") Gerar Revisão")				
			EndIf		
	
	EndCase
Else 
	lRet := .F.		
	MsgAlert("Verifique os campos obrigatório da rotina","TPPAC009->PPAC009A->sfTudOk("+AllTrim(Str(nOpc))+") btOK")						
EndIf
RestArea(aArea)
Return lRet
//=========================Fim da Validação dos Dados na Persistência===================================================================
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
//================================REVISÃO =========================================================
Static Function sfRevisao (cNUMQUA)
Local cRet		:=	""
Local aAreaZC8	:=	ZC8->(GetArea())
DBSelectArea("ZC8")
ZC8->(DBGoTop())
ZC8->(DBSetOrder(3))//ZC8_FILIAL, ZC8_NUMQUA, ZC8_REV, ZC8_QUESTA
If ZC8->(DBSeek(xFilial("ZC8")+cNUMQUA))
	Do While ZC8->(!EoF()) .AND. (ZC8->(ZC8_FILIAL+ZC8_NUMQUA)) == ;
			  (xFilial("ZC8")+(cNUMQUA))
		cRet:=ZC8->ZC8_REV			 					
		ZC8->(DBSkip())
	EndDo					
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revisão
RestArea(aAreaZC8)
Return (cRet)
//================================FIM DA REVISÃO ================================================== 