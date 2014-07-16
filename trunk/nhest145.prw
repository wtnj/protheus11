/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST145 ºAutor  ³ João Felipe da Rosaº Data ³  12/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PORTAL DO CLIENTE                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - COMERCIAL / ENGENHARIA / QUALIDADE                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "protheus.ch"
#include "dbtree.ch"
#INCLUDE "MSOLE.CH"

User Function NHEST145()
Private cCadastro := "Portal do Cliente"
Private aRotina := {}



	
	aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
	aAdd(aRotina,{ "Visualizar"	    ,"U_EST145(2)" 	, 0 , 2})
	aAdd(aRotina,{ "Incluir"		,"U_EST145(3)" 	, 0 , 3})
	aAdd(aRotina,{ "Alterar"		,"U_EST145(4)" 	, 0 , 4})
	
	mBrowse( 6, 1,22,75,"ZBQ",,,,,,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function EST145(nParam)
Local bEnchoice := {||}
Local bOk       := {||}
Local bCanc     := {||oDlg:End()}
Private nPar    := nParam
Private aSize   := MsAdvSize()
//Private aArqC   := {} //Matriz de arquivos do cliente
//Private aProd   := {} //Matriz com as pecas do cliente
//Private aArqP   := {} //Matriz com os arquivos das pecas
//Private	aArqC2  := {}
//Private	aArqP2  := {}
//Private	aProd2  := {}
Private aArq := {}
Private cCrg    := ""
Private cStartPath   := GetSrvProfString("Startpath","")

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif               

cStartPath += "Portal\"//Portal do Cliente

	If nPar==3 //incluir
		cCli     := Space(06)
		cLoja    := Space(02)
		cDescCli := ""
	Else
		cCli     := ZBQ->ZBQ_CLI
		cLoja    := ZBQ->ZBQ_LOJA  
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
		cDescCli := SA1->A1_NOME
	EndIf
	
	If nPar==2     //visualizar 
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir
		bOk := {|| fInclui()}
		bCanc := {|| oDlg:End()}
	ElseIf nPar==4 //alterar
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		bOk := {|| fExclui()}
	EndIf
	
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo automatico de dimensoes dos objetos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	
	AAdd( aObjects, { 130, 150, .f., .t. } ) 
	AAdd( aObjects, { 100, 100, .f., .t. } ) 
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 } 
	aObj  := MsObjSize( aInfo, aObjects, , .T. ) 

	//ÚÄÄÄÄÄÄ¿
	//³ TELA ³
	//ÀÄÄÄÄÄÄÙ
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Portal do Cliente",,,,,CLR_BLACK,CLR_WHITE,,oMainWnd,.T.)

	oTree := DbTree():New( aObj[1,1], aObj[1,2], aObj[1,3], aObj[1,4],oDlg,{||fChange()},,.T.)	
	
	oBUT1 := tButton():New(20,140,"Cliente"           ,oDlg,{||addCli()  } ,60,10,,,,.T.)

	oBut2 := tButton():New(32,140,"Nova Pasta",oDlg,{||addPasta() } ,60,10,,,,.T.)
	oBUT3 := tButton():New(44,140,"Novo Arquivo",oDlg,{||addArq() } ,60,10,,,,.T.)

	If nPar==4 //incluir
		oBUT4 := tButton():New(56,140,"Excluir"           ,oDlg,{||fExc()    } ,60,10,,,,.T.)
	EndIf

	oBUT5 := tButton():New(68,140,"Abrir Arquivo"     ,oDlg,{||fOpenArq()} ,60,10,,,,.T.)




/*
	oGetx := tGet():New(40 ,300,{|u| if(Pcount() > 0, cCrg := u,cCrg)},oDlg,40,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cCrg")
*/

	
	oBUT2:lActive := .F.
	oBUT3:lActive := .F.
//	oBUT4:lActive := .F.
	oBUT5:lActive := .F.
		
	If nPar==2 .Or. nPar==4 //visualizar ou alterar
		fCarrega() //traz os itens da arvore para visualizacao
		oBUT1:lActive := .F.
	EndIf                                     
	
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE A TELA PARA ADICIONAR UM CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function addCli()
Local bOkCli := {||GrvCli()}

	oDlgCli := MsDialog():New(0,0,94,560,"Adicionar Cliente",,,,,CLR_BLACK,CLR_WHITE,,oDlg,.T.)

	oSay1 := TSay():New(10,10,{||"Cliente"},oDlgCli,,,,,,.T.,,)
	oGet1 := tGet():New(8 ,35,{|u| if(Pcount() > 0, cCli := u,cCli)},oDlgCli,40,8,"@!",{||fValCli()},;
		,,,,,.T.,,,{||.T.},,,,,,"SA1","cCli")
	oGet2 := tGet():New(8 ,80,{|u| if(Pcount() > 0, cLoja := u,cLoja)},oDlgCli,10,8,"@!",{||fValLoja()},;
		,,,,,.T.,,,{||.T.},,,,,,,"cLoja")
	oGet3 := tGet():New(8,95,{|u| if(Pcount() > 0, cDescCli := u,cDescCli)},oDlgCli,180,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescCli")

	oGroup := tGroup():New(25,05,27,275,,oDlgCli,,,.T.)
		
	oBtn1 := tButton():New(32,190,"Ok",oDlgCli,bOkCli,40,10,,,,.T.)
	oBtn2 := tButton():New(32,235,"Cancelar",oDlgCli,{||oDlgCli:End()},40,10,,,,.T.)
	
	oDlgCli:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA UM CLIENTE NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvCli(lCarrega)

	If nPar==3 //inclui
		ZBQ->(DbSetOrder(1)) // FILIAL + CLI + LOJA
	
		ZBQ->(DbSeek(xFilial("ZBQ")+cCli+cLoja))
		If ZBQ->(Found())
			Alert("Já existe um cadastro para este cliente e loja!")
			Return
		EndIf
	EndIf

	oTree:BeginUpdate() // Sempre fechar o com EndUpdate
	
	oTree:TreeSeek("")
	
	oTree:AddTree(Substr(cDescCli,1,30),,"FOLDER5","FOLDER6",,,"Client") //esta linha define que todos os Cargos terão 22 caracteres
	aAdd(aArq,{cCli,cLoja,"Client",1,"","S","",Substr(cDescCli,1,30),"","N"})//adiciona o cliente no array de arquivos

	oTree:EndTree()

	oTree:EndUpdate()
	
	oBUT1:lActive := .F.//desabilita o botao do cliente pois soh pode incluir um cliente

	If nPar != 2 //visualizar
		oBUT2:lActive := .T.
		oBUT3:lActive := .T.
	EndIf

	If lCarrega
		fEstrut(.T.)
	Else
		fEstrut()
		oDlgCli:End()
	EndIf
  	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA A ESTRUTURA DE PASTAS PADRÃO PARA O CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fEstrut(lCarrega)
Local aPadrao := {}

	oTree:BeginUpdate() // Sempre fechar o com EndUpdate
	
	oTree:TreeSeek("Client")

	If !lCarrega
		//ADICIONA AS PASTAS PADRÃO VINDAS DO ARRAY
		aAdd(aPadrao,"CONTATOS")
		aAdd(aPadrao,"REQUISITOS ESPECÍFICOS")
		aAdd(aPadrao,"CADASTRO DA PEÇA")
		aAdd(aPadrao,"ACORDO DE QUALIDADE")
		aAdd(aPadrao,"CRITERIO DE ACEITACAO BRUTO / USINADO")
		aAdd(aPadrao,"FLUXOGRAMA  DE PROCESSO")
		aAdd(aPadrao,"PFMEA")
		aAdd(aPadrao,"PLANO DE CONTROLE")
		aAdd(aPadrao,"ESPECIFICAÇÃO TÉCNICA DE PROCESSO")
		aAdd(aPadrao,"MÉTODO DE TRABALHO")
		aAdd(aPadrao,"DERROGAS")
		aAdd(aPadrao,"PPAP")
		aAdd(aPadrao,"ANÁLISE DE SISTEMAS DE MEDIÇÃO")
		aAdd(aPadrao,"ESTUDOS DE CAPABILIDADE")
		aAdd(aPadrao,"ALERTA DE QUALIDADE")
		aAdd(aPadrao,"RAC")
		aAdd(aPadrao,"DESEMPENHO INTERNO")
		aAdd(aPadrao,"DESEMPENHO NO CLIENTE")
		aAdd(aPadrao,"LICOES APRENDIDAS")
		aAdd(aPadrao,"ATAS DE REUNIAO")
	
		For x:=1 to Len(aPadrao)
	    	cCargo := GetSxeNum("ZBR","ZBR_CARGO")
	    	ConfirmSx8()
	    	
			oTree:AddItem(aPadrao[x],cCargo,"FOLDER7","FOLDER8",,,2)
			oTree:EndTree() //ativa a arvore para realizar animacao de pasta aberta e pasta fechada
			aAdd(aArq,{cCli,cLoja,cCargo,2,"Client","S","",aPadrao[x],"","S"})//adiciona a pasta padrão no array de arquivos
	    Next
    Else

		//ADICIONA AS PASTAS PADRÃO VINDAS DO BANCO DE DADOS
		ZBR->(DbSetOrder(1))//FILIAL + CLI + LOJA + CARGO
		ZBR->(DbSeek(xFilial("ZBR")+cCli+cLoja))
		
		WHILE ZBR->(!EOF()) .AND. ZBR->ZBR_CLI==cCli .AND. ZBR->ZBR_LOJA==cLoja
		
			If ZBR->ZBR_PADRAO=="S"
				oTree:AddItem(ZBR->ZBR_NOMARQ,ZBR->ZBR_CARGO,"FOLDER7","FOLDER8",,,2)
				oTree:EndTree() //ativa a arvore para realizar animacao de pasta aberta e pasta fechada
				aAdd(aArq,{cCli,cLoja,ZBR->ZBR_CARGO,2,"Client","S","",ZBR->ZBR_NOMARQ,"","S"})//adiciona a pasta padrão no array de arquivos
			EndIf
		
			ZBR->(DbSkip())
		ENDDO

    EndIf

	oTree:EndUpdate()

	oTree:Refresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BLOQUEIA O CAMPO DOCUMENTO OU O CAMPO ARQUIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fDocOuArq()

	cArq := ""
	cDoc := Space(16)
	
	oGet1:lActive := Iif(nRadio==1,.T.,.F.)
	oGet2:lActive := Iif(nRadio==2,.T.,.F.)

	oGet1:Refresh()	
	oGet2:Refresh()

	oBtn1:lActive := Iif(nRadio==1,.T.,.F.)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValCli()
	SA1->(DbSetOrder(1)) // filial + cod
	SA1->(DbSeek(xFilial("SA1")+cCli))
	If SA1->(!Found())
		Alert("Cliente não encontrado!")
		Return .F.
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA A LOJA DO CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValLoja()
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
	If SA1->(!Found())
		Alert("Loja do Cliente não encontrada!")
		Return .F.
	Else
		cDescCli := SA1->A1_NOME
		oGet3:Refresh()
	EndIf
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE HABILITA O BOTAO PARA ABRIR O ARQUIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fChange()
Local cCargo  := ""
Local cDocArq := ""

	cCargo := oTree:GetCargo()
	
//	cCrg := cCargo
//	oGetx:Refresh()

	_n := aScan(aArq,{|x| x[3]==ALLTRIM(cCargo)})
	If _n<>0

		If aArq[_n][6]=="N" //se estiver em cima de um arquivo de Peca ou arquivo de Cliente
			oBUT5:lActive := .T.//ativa o botao Abrir arquivo
			oBUT2:lActive := .F.//desativa o botao de nova pasta
			oBUT3:lActive := .F.//desativa o botao de novo arquivo
		Else
			oBut5:lActive := .F.//desativa o botao abrir arquivo
			oBUT2:lActive := .T.//ativa o botao de nova pasta
			oBUT3:lActive := .T.//ativa o botao de novo arquivo
		EndIf
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE O ARQUIVO DO CLIENTE OU DA PECA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fOpenArq()
Local cMvSave   := "CELEWIN400"  
Local cPView    := Alltrim( GetMv( "MV_QDPVIEW" ) )
Local lAchou    := .F.
Local aQPath    := QDOPATH()
Local cQPath    := aQPath[1]
Local cQPathD   := aQPath[2]
Local cQPathTrm := aQPath[3]

Local cEndArq   := ""
Local cDocArq   := ""

	cCargo := Alltrim(oTree:GetCargo())

	//localiza no array de arq. cliente e pega o valor de cDocArq
	_n := aScan(aArq,{|x| x[3]==cCargo})

	If _n<>0
		cDocArq := aArq[_n][7]//doc ou arq
		cEndArq := aArq[_n][9]//endereco
	EndIf
	
	If !Empty(cEndArq)

		cEndArq := AllTrim(cEndArq)

		If cDocArq=="D" //DOCUMENTO DO CONTROLE DE DOCUMENTOS

			If !File(cQPathTrm+cEndArq)
				CpyS2T(cQPath+cEndArq,cQPathTrm,.T.)
			EndIf
			
			If UPPER(Right(cEndArq,4))$".CEL"

				fRename(cQPathTrm+cEndArq,cQPathTrm+StrTran(UPPER(cEndArq),".CEL",".DOC"))

				cEndArq := StrTran(UPPER(cEndArq),".CEL",".DOC")
				
				oWordTmp := OLE_CreateLink("TMsOleWord97")
				OLE_SetProperty( oWordTmp, oleWdVisible,   .T. )
				OLE_SetProperty( oWordTmp, oleWdPrintBack, .F. )
				OLE_OpenFile( oWordTmp, ( cQPathTrm + cEndArq ),.F., cMvSave, cMvSave )

				Aviso("", "Alterne para o programa do Ms-Word para visualizar o documento ou clique no botao para fechar.", {"Fechar"})
		
				OLE_CloseLink( oWordTmp )
			ELSE			
				QA_OPENARQ(cQPathTrm+cEndArq)
			ENDIF
		
		EndIf
			
		If cDocArq=="A" //ARQUIVO EM DISCO LOCAL OU EM REDE
			If File(cEndArq)
				If UPPER(Substr(cEndArq,1,15))=="\SYSTEM\PORTAL\" //arquivo do servidor
					CpyS2T(cEndArq,cQPathTrm,.T.) //copia para pasta temporaria S:\
					QA_OPENARQ(cQPathTrm+STRTRAN(UPPER(cEndArq),"\SYSTEM\PORTAL\","")) //abre o arquivo removendo o '\system\portal'
				Else //arquivo local
					QA_OPENARQ(cEndArq) //abre o arquivo local
				EndIf
		 	Else
				Alert("Impossível abrir o arquivo!")
				Return	
			EndIf
		EndIf
	Else
		alert("O ítem selecionado não é um arquivo válido!")
		Return
	EndIf

Return  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FAZ A INCLUSAO DO CLIENTE E SEUS ARQUIVOS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fInclui()

	RecLock("ZBQ",.T.)
		ZBQ->ZBQ_FILIAL := xFilial("ZBQ")
		ZBQ->ZBQ_CLI    := cCli
		ZBQ->ZBQ_LOJA   := cLoja
	MsUnLock("ZBQ")

	//---------------------------------
	// Dados do array aArq
	//---------------------------------
	//  1=Cliente
	//  2=Loja
	//  3=Cargo
	//  4=Nivel na árvore
	//  5=cargo do Pai
	//  6=pasta ("S" ou "N")
	//  7=doc ou arq ("D" OU "A")
	//  8=nome do arquivo
	//  9=endereco do arquivo
	// 10=arquivo padrao ("S" ou "N")
	//---------------------------------
	
	//Grava os arquivos do Cliente
	For x:=1 to Len(aArq)
	
		//Faz o upload da imagem se for um arquivo
		If aArq[x][6]=="N"//nao e pasta
			If !Empty(aArq[x][9]) .AND. aArq[x][7]=="A"  //endereco do arquivo nao vazio e arquivo em disco

			 	//startpath + cargo + extensao
				cTmp := cStartPath+aArq[x][3]+Right(AllTrim(aArq[x][9]),4)
	
				If !(cTmp==aArq[x][9])
					If __CopyFile(aArq[x][9],cTmp)
						aArq[x][9] := cTmp
					Else
						Alert("Impossível copiar Imagem "+aArq[x][9])
						aArq[x][9] := ""
					EndIf
				EndIf
	            
            EndIf
		EndIf
				
		RecLock("ZBR",.T.)
			ZBR->ZBR_FILIAL := xFilial("ZBR")
			ZBR->ZBR_CLI    := aArq[x][1]
			ZBR->ZBR_LOJA   := aArq[x][2]
			ZBR->ZBR_CARGO  := aArq[x][3]
			ZBR->ZBR_NIVEL  := aArq[x][4]
			ZBR->ZBR_PAI    := aArq[x][5]
			ZBR->ZBR_PASTA  := aArq[x][6]
			ZBR->ZBR_DOCARQ := aArq[x][7]
			ZBR->ZBR_NOMARQ := aArq[x][8]
			ZBR->ZBR_ENDARQ := aArq[x][9]
			ZBR->ZBR_PADRAO := aArq[x][10]
		MsUnLock("ZBR")
	Next

	oDlg:End()

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ADICIONA NOVA PASTA A ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function addPasta()
Private cPst := Space(30)

	oDlgPst := MsDialog():New(0,0,100,280,"Adicionar Pasta",,,,,CLR_BLACK,CLR_WHITE,,oDlg,.T.)

	oSay1 := TSay():New(10,10,{||"Nome"},oDlgPst,,,,,,.T.,,)
	oGet1 := tGet():New(8 ,35,{|u| if(Pcount() > 0, cPst := u,cPst)},oDlgPst,100,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.T.},,,,,,,"cPst")

	oGroup := tGroup():New(25,05,27,135,,oDlgPst,,,.T.)
		
	oBtn1 := tButton():New(32,50,"Ok",oDlgPst,{||GrvPst()},40,10,,,,.T.)
	oBtn2 := tButton():New(32,95,"Cancelar",oDlgPst,{||oDlgPst:End()},40,10,,,,.T.)
	
	oDlgPst:Activate(,,,.T.,{||.T.},,)
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄâ¿
//³ GRAVA A NOVA PASTA NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄâÙ
Static Function GrvPst(lCarrega)

	If lCarrega

    	cCargo := ZBR->ZBR_CARGO
    	cPai   := ZBR->ZBR_PAI
    	nNivel := ZBR->ZBR_NIVEL
    	cPst   := ZBR->ZBR_NOMARQ

 	Else
		
		If Empty(cPst)
			Alert("Informe o nome da pasta!")
			Return
		EndIf
		
		cPai := Alltrim(oTree:GetCargo()) //pega o cargo que o cursor está focado
	
		_n := aScan(aArq,{|x| x[3]==cPai}) //pega a posicao do arquivo pai no array de arquivos
	
		If _n==0
			Alert("Erro!") //nao pode ocorrer este erro
			Return
		Else
			If aArq[_n][6]=="N"
				Alert("Não é possível adicionar pastas dentro de arquivos!")
				Return
			EndIf
		EndIf
	
		nNivel := aArq[_n][4] +1 //nivel do arquivo pai + 1
	
		//Verifica se nao existe uma sub-pasta com o mesmo nome dentro da pasta pai
		_n2 := aScan(aArq,{|x| x[5]==cPai .AND. x[8]==cPst .AND. x[6]=="S"})
		If _n2<>0
			Alert("Já existe uma sub-pasta com este nome nesta pasta!")
			Return
		EndIf

		//pega um novo cargo sequencial
	   	cCargo := GetSxeNum("ZBR","ZBR_CARGO")
   		ConfirmSx8()
	EndIf    	
	
	oTree:BeginUpdate() // Sempre fechar o com EndUpdate
	
	oTree:TreeSeek(cPai)
	                                                 
	oTree:AddItem(cPst,cCargo,"FOLDER5","FOLDER6",,,nNivel)
	aAdd(aArq,{cCli,cLoja,cCargo,nNivel,cPai,"S","",cPst,"","N"})//adiciona a pasta no array de arquivos

	oTree:EndTree() //ativa a arvore para realizar animacao de pasta aberta e pasta fechada

	oTree:EndUpdate()

	oTree:Refresh()//atualiza a arvore
	
	If !lCarrega
		oDlgPst:End()
	EndIf
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ADICIONA UM ARQUIVO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function addArq()
Private nRadio   := 1
Private cTitArq  := Space(30)
Private cDoc     := Space(16)
Private cArq     := ""
	
	oDlgArq  := MsDialog():New(0,0,186,335,"Adicionar Arquivo",,,,,CLR_BLACK,CLR_WHITE,,oDlg,.T.)

	oSay1 := TSay():New(10,10,{||"Titulo"},oDlgArq,,,,,,.T.,,)
	oGet1 := tGet():New(8 ,35,{|u| if(Pcount() > 0, cTitArq := u,cTitArq)},oDlgArq,100,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.T.},,,,,,,"cTitArq")
		
	oRadio := tRadMenu():New(22,35,{"Arquivo em Disco","Doc. do Controle de Docs."},;
				{|u| iF(PCount()>0,nRadio:=u,nRadio)},oDlgArq,,{||fDocOuArq()},,,,,,100,30,,,,.T.)
	
	oSay2 := TSay():New(46,10,{||"Arquivo"},oDlgArq,,,,,,.T.,,)	
	oGet1 := tGet():New(44,35,{|u| if(Pcount() > 0, cArq := u,cArq)},oDlgArq,115,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==1},,,,,,,"cArq")
	oBtn1 := tButton():New(44,151,"...",oDlgArq,{||cArq := cGetFile(,,0,,.T.,49)},10,10,,,,.T.)

	oSay3 := TSay():New(58,10,{||"Doc."},oDlgArq,,,,,,.T.,,)	
	oGet2 := tGet():New(56,35,{|u| if(Pcount() > 0, cDoc := u,cDoc)},oDlgArq,80,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==2},,,,,,"QDH","cDoc")
//	oGet3 := tGet():New(56,116,{|u| if(Pcount() > 0, cDocRev := u,cDocRev)},oDlgArq,15,8,"@!",{||.T.},;
//		,,,,,.T.,,,{||nRadio==2},,,,,,"","cDocRev")

	oGroup := tGroup():New(71,05,72,163,,oDlgArq,,,.T.)
		
	oBtn2 := tButton():New(78,78,"Ok",oDlgArq,{||GrvArq()},40,10,,,,.T.)
	oBtn3 := tButton():New(78,123,"Cancelar",oDlgArq,{||oDlgArq:End()},40,10,,,,.T.)

	oDlgArq:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA O ARQUIVO NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvArq(lCarrega)
Local cPai
Local cCargo
Local nNivel
Local cDocArq //"D=Documento" ou "A=Arquivo" 

	If lCarrega
	
		cCargo  := ZBR->ZBR_CARGO
		cPai    := ZBR->ZBR_PAI
		nNivel  := ZBR->ZBR_NIVEL
		cDocArq := ZBR->ZBR_DOCARQ
		cTitArq := ZBR->ZBR_NOMARQ
		cEndArq := ZBR->ZBR_ENDARQ
	
	Else
	
		If nRadio==1 //arquivo

			If Empty(cArq)
				Alert("Informe o arquivo!")
				Return
			EndIf

			cDocArq := "A"
			cEndArq := cArq

		ElseIf nRadio==2 //documento
		    If Empty(cDoc)
		    	Alert("Informe o documento!")
		    	Return
		    EndIf
			
			cDocArq := "D"
		
			QDH->(DbSetOrder(1)) //ultima revisao
			QDH->(DbSeek(xFilial("QDH")+AllTrim(cDoc)))
				
			While QDH->(!EOF()) .AND. QDH->QDH_DOCTO == cDoc
				QDH->(DbSkip())
			Enddo
			
			QDH->(DbSkip(-1))
	
			cEndArq := QDH->QDH_NOMDOC
		EndIf
		
		If Empty(cTitArq)
			Alert("Informe o título do arquivo!")
			Return
		EndIf	
		

	
		cPai := Alltrim(oTree:GetCargo()) //pega o cargo que o cursor está focado
	
		_n := aScan(aArq,{|x| x[3]==cPai}) //pega a posicao do arquivo pai no array de arquivos
	
		If _n==0
			Alert("Erro!") //nao pode ocorrer este erro
			Return
		Else
			If aArq[_n][6]=="N"
				Alert("Não é possível adicionar arquivos dentro de arquivos!")
				Return
			EndIf
		EndIf
	
		nNivel := aArq[_n][4] +1 //nivel do arquivo pai + 1
	
		//Verifica se nao existe um arquivo com o mesmo nome dentro da pasta pai
		_n2 := aScan(aArq,{|x| x[5]==cPai .AND. x[8]==cTitArq .AND. x[6]=="N"})
		If _n2<>0
			Alert("Já existe um arquivo com este nome nesta pasta!")
			Return
		EndIf

		//pega um novo cargo sequencial
	   	cCargo := GetSxeNum("ZBR","ZBR_CARGO")
	   	ConfirmSx8()
	EndIf
	
	oTree:BeginUpdate() // Sempre fechar o com EndUpdate
	
	oTree:TreeSeek(cPai)
	                                                 
	oTree:AddItem(cTitArq,cCargo,"CLIPS","CLIPS",,,nNivel)
	aAdd(aArq,{cCli,cLoja,cCargo,nNivel,cPai,"N",cDocArq,cTitArq,cEndArq,"N"})//adiciona a pasta no array de arquivos

	oTree:EndUpdate()

	oTree:Refresh()//atualiza a arvore
	
	If !lCarrega
		oDlgArq:End()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ OS ITENS DA ARVORE PARA VISUALIZACAO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fCarrega()
Private cZbrCargo := ""

	cCli  := ZBQ->ZBQ_CLI
	cLoja := ZBQ->ZBQ_LOJA
	SA1->(DbSetOrder(1)) // FILIAL + COD + LOJA
	SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
	cDescCli := SA1->A1_NOME
	
	GrvCli(.T.) //inclui o cliente na arvore

	//inclui os arquivos e pastas da arvore
	ZBR->(DbSetOrder(2)) // FILIAL + COD_CLI + LOJA + NIVEL
	ZBR->(DbSeek(xFilial("ZBR")+cCli+cLoja))

	If ZBR->(Found())
		While ZBR->(!EOF()) .AND. ZBR->ZBR_CLI==cCli .AND. ZBR->ZBR_LOJA==cLoja

			If ZBR->ZBR_PADRAO == "N" .AND. ZBR->ZBR_NIVEL != 1
			
				If ZBR->ZBR_PASTA=="S"
					GrvPst(.T.) //inclui a pasta na arvore
				Else
				    GrvArq(.T.)
				EndIf				
			EndIf
			
			ZBR->(DbSkip())
		EndDo
	EndIf

Return


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ADICIONA UM ARQUIVO DO CLIENTE NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function addArqC()

	nRadio := 1
	
	cTitArqC := Space(30)
	cDocC    := Space(16)
	cDocRev  := Space(03)
	cArqC    := ""
	
	oDlgArqC := MsDialog():New(0,0,186,335,"Adicionar Arquivo do Cliente",,,,,CLR_BLACK,CLR_WHITE,,oDlg,.T.)

	oSay1 := TSay():New(10,10,{||"Titulo"},oDlgArqC,,,,,,.T.,,)
	oGet1 := tGet():New(8 ,35,{|u| if(Pcount() > 0, cTitArqC := u,cTitArqC)},oDlgArqC,100,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.T.},,,,,,,"cTitArqC")
		
	oRadio := tRadMenu():New(22,35,{"Arquivo em Disco","Doc. do Controle de Docs."},;
				{|u| iF(PCount()>0,nRadio:=u,nRadio)},oDlgArqC,,{||fDocOuArq()},,,,,,100,30,,,,.T.)
	
	oSay2 := TSay():New(46,10,{||"Arquivo"},oDlgArqC,,,,,,.T.,,)	
	oGet1 := tGet():New(44,35,{|u| if(Pcount() > 0, cArqC := u,cArqC)},oDlgArqC,115,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==1},,,,,,,"cArqC")
	oBtn1 := tButton():New(44,151,"...",oDlgArqC,{||cArqC := cGetFile(,,0,,.T.,49)},10,10,,,,.T.)

	oSay3 := TSay():New(58,10,{||"Doc."},oDlgArqC,,,,,,.T.,,)	
	oGet2 := tGet():New(56,35,{|u| if(Pcount() > 0, cDocC := u,cDocC)},oDlgArqC,80,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==2},,,,,,"QDH","cDocC")
	oGet3 := tGet():New(56,116,{|u| if(Pcount() > 0, cDocRev := u,cDocRev)},oDlgArqC,15,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==2},,,,,,"","cDocRev")

	oGroup := tGroup():New(71,05,72,163,,oDlgArqC,,,.T.)
		
	oBtn2 := tButton():New(78,78,"Ok",oDlgArqC,{||GrvArqC()},40,10,,,,.T.)
	oBtn3 := tButton():New(78,123,"Cancelar",oDlgArqC,{||oDlgArqC:End()},40,10,,,,.T.)

	oDlgArqC:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA O ARQUIVO DO CLIENTE NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvArqC(lCarrega)
Local cCargo  := ""
Local cDocArq := ""

	If Empty(cTitArqC)
		Alert("Informe o título do arquivo!")
		Return
	EndIf
	
	//Verifica se existe um arquivo com o mesmo nome
	_n := aScan(aArqC,{|x| Alltrim(x[5])==AllTrim(cTitArqC) })
	If _n<>0
		Alert("Já existe um arquivo com este nome!")
		Return
	EndIf
	
	If nRadio==1 //arquivo em disco
		If Empty(cArqC)
			Alert("Arquivo não informado!")
			Return
		EndIf
		
		cDocArq := "A"
	EndIf
	
	If nRadio==2 //documento do controle de documentos
		If nPar==3 .or. nPar==4 //incluir ou alterar
			If Empty(cDocC) 
				Alert("Documento não informado!")
				Return
			EndIf
		
			QDH->(DbSetOrder(1)) //ultima revisao
			QDH->(DbSeek(xFilial("QDH")+AllTrim(cDocC)))
			
			While QDH->(!EOF()) .AND. QDH->QDH_DOCTO == cDocC
				QDH->(DbSkip())
			Enddo
			
			QDH->(DbSkip(-1))

			cArqC   := QDH->QDH_NOMDOC
		EndIf
		
		cDocArq := "D"
	EndIf
	
	oTree:BeginUpdate() // Sempre fechar o com EndUpdate
	
	oTree:TreeSeek("Client")

	//define a identidade (cargo) do item na árvore	
	//cCargo := "ArqC"+cCli+cLoja+StrZero(Len(aArqC)+1,3) //"ArqC" + cliente + loja + sequencial de 3 digitos
    If !lCarrega
    	cCargo := GetSxeNum("ZBR","ZBR_CARGO")
    	ConfirmSx8()
    Else 
    	cCargo := cZBRCargo
    EndIf                                          
    
	oTree:AddItem(cTitArqC,cCargo,"CLIPS","CLIPS",,,2)
	
	//{cli,loja,cargo,prod,nomearq,endarq,docarq}
	aAdd(aArqC,{cCli,cLoja,cCargo,"",cTitArqC,cArqC,cDocArq})//adiciona os dados do arquivo no array de arquivos do cliente

	oTree:EndUpdate()

	oTree:Refresh()
	
	If !lCarrega
		oDlgArqC:End()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TELA PARA INCLUSAO DE NOVA PECA NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function addProd()

	cProd     := Space(15)
	cDescProd := ""
	
	oDlgProd := MsDialog():New(0,0,94,462,"Adicionar Peça do Cliente",,,,,CLR_BLACK,CLR_WHITE,,oDlg,.T.)

	oSay1 := TSay():New(10,10,{||"Cód Peça"},oDlgProd,,,,,,.T.,,)
	oGet1 := tGet():New(8 ,35,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlgProd,70,8,"@!",{||fValProd()},;
		,,,,,.T.,,,{||.T.},,,,,,"SB1","cProd")
		
	oGet2 := tGet():New(8,106,{|u| if(Pcount() > 0, cDescProd := u,cDescProd)},oDlgProd,120,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescProd")

	oGroup := tGroup():New(25,05,27,226,,oDlgProd,,,.T.)
		
	oBtn2 := tButton():New(32,141,"Ok",oDlgProd,{||GrvProd()},40,10,,,,.T.)
	oBtn3 := tButton():New(32,186,"Cancelar",oDlgProd,{||oDlgProd:End()},40,10,,,,.T.)
	
	oDlgProd:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VALIDA O PRODUTO E TRAZ A DESCRICAO DA PECA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValProd()

	SB1->(DbSetOrder(1))//filial + cod produto
	SB1->(DbSeek(xFilial("SB1")+cProd))
	If SB1->(!Found())
		Alert("Peça não encontrada!")
		Return .F.
	Else
		cDescProd := SB1->B1_DESC
		oGet2:Refresh()
	EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA O PRODUTO NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvProd(lCarrega)

	//Verifica se nao existe um produto igual 
	_n := aScan(aProd,{|x| Alltrim(x[4])==Alltrim(cProd)})

	If _n<>0
		Alert("Peça já existe!")
		Return .F.
	EndIf
	
	oTree:BeginUpdate() // Sempre fechar o com EndUpdate

	oTree:TreeSeek("Client")
	
    If !lCarrega //incluir
    	cCargo := GetSxeNum("ZBR","ZBR_CARGO")
    	ConfirmSx8()
    Else 
    	cCargo := cZBRCargo
    EndIf                                          
	
	oTree:AddItem(cProd,cCargo,"FOLDER5","FOLDER6",,,3)
	oTree:EndTree() //ativa a arvore para realizar animacao de pasta aberta e pasta fechada

	//         {cli ,loja ,cargo ,prod ,nomearq,endarq,docarq}
	aAdd(aProd,{cCli,cLoja,cCargo,cProd,"","",""})//adiciona o produto na matriz de produtos

	oTree:EndUpdate() 

	oTree:Refresh()
	
	If !lCarrega //inclui
		oDlgProd:End()
	EndIf
	
	If nPar==3 .or. nPar==4 
//		oBUT4:lActive := .T.
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE A TELA PARA INCLUSAO DE ARQUIVO DA PECA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function addArqP()

	nRadio    := 1
	cDocP     := Space(16)
	cDocRev   := Space(03)
	cProd     := Space(15)
	cDescProd := ""
	cArqP     := ""
	cTitArqP  := Space(30)

	//Verifica se o item selecionado é um produto
	For x:=1 to Len(aProd)
		If ALLTRIM(oTree:GetCargo()) == AllTrim(aProd[x][3])
			cProd := aProd[x][4] //puxa o codigo do produto para a tela
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+cProd))
			cDescProd := SB1->B1_DESC
		EndIf
	Next

	oDlgArqP := MsDialog():New(0,0,210,522,"Adicionar Arquivo da Peça",,,,,CLR_BLACK,CLR_WHITE,,oDlg,.T.)

	oSay1 := TSay():New(10,10,{||"Peça"},oDlgArqP,,,,,,.T.,,)
	oGet1 := tGet():New(8 ,35,{|u| if(Pcount() > 0, cProd := u,cProd)},oDlgArqP,70,8,"@!",{||fValProd()},;
		,,,,,.T.,,,{||.T.},,,,,,"SB1","cProd")
	oGet2 := tGet():New(8 ,106,{|u| if(Pcount() > 0, cDescProd := u,cDescProd)},oDlgArqP,150,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.F.},,,,,,,"cDescProd")

	oSay2 := TSay():New(22,10,{||"Titulo"},oDlgArqP,,,,,,.T.,,)
	oGet3 := tGet():New(20,35,{|u| if(Pcount() > 0, cTitArqP := u,cTitArqP)},oDlgArqP,100,8,"@!",{||.T.},;
		,,,,,.T.,,,{||.T.},,,,,,,"cTitArqP")

	oRadio := tRadMenu():New(34,35,{"Arquivo em Disco","Doc. do Controle de Docs."},;
				{|u| iF(PCount()>0,nRadio:=u,nRadio)},oDlgArqP,,{||fDocOuArq()},,,,,,100,30,,,,.T.)
	
	oSay2 := TSay():New(58,10,{||"Arquivo"},oDlgArqP,,,,,,.T.,,)	
	oGet1 := tGet():New(56,35,{|u| if(Pcount() > 0, cArqP := u,cArqP)},oDlgArqP,115,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==1},,,,,,,"cArqP")
	oBtn1 := tButton():New(56,151,"...",oDlgArqP,{||cArqP := cGetFile(,,0,,.T.,49)},10,10,,,,.T.)

	oSay3 := TSay():New(70,10,{||"Doc."},oDlgArqP,,,,,,.T.,,)	
	oGet2 := tGet():New(68,35,{|u| if(Pcount() > 0, cDocP := u,cDocP)},oDlgArqP,80,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==2},,,,,,"QDH","cDocP")
	oGet3 := tGet():New(68,116,{|u| if(Pcount() > 0, cDocRev := u,cDocRev)},oDlgArqP,15,8,"@!",{||.T.},;
		,,,,,.T.,,,{||nRadio==2},,,,,,"","cDocRev")

	oGroup := tGroup():New(83,05,85,256,,oDlgArqP,,,.T.)
		
	oBtn2 := tButton():New(90,171,"Ok",oDlgArqP,{||GrvArqP()},40,10,,,,.T.)
	oBtn3 := tButton():New(90,216,"Cancelar",oDlgArqP,{||oDlgArqP:End()},40,10,,,,.T.)

	oDlgArqP:Activate(,,,.T.,{||.T.},,)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA O ARQUIVO DA PECA NA ARVORE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function GrvArqP(lCarrega)
Local lExist := .F.
Local cCargo := ""
	
	If Empty(cTitArqP)
		Alert("Informe o título do arquivo!")
		Return
	EndIf

	If nRadio==1 //arquivo em disco
		If Empty(cArqP)
			Alert("Arquivo não informado!")
			Return
		EndIf
		
		cDocArq := "A"
	EndIf
	
	If nRadio==2 //documento do controle de documentos
		If nPar==3 .Or. nPar==4//incluir ou alterar
			If Empty(cDocP)
				Alert("Documento não informado!")
				Return
			EndIf
			
			QDH->(DbSetOrder(1)) //ultima revisao
			QDH->(DbSeek(xFilial("QDH")+AllTrim(cDocP)))
		
			While QDH->(!EOF()) .AND. QDH->QDH_DOCTO == cDocP
				QDH->(DbSkip())
			Enddo
			
			QDH->(DbSkip(-1))
			
			cArqP   := QDH->QDH_NOMDOC
		EndIf
		cDocArq := "D"
	EndIf

	//Verifica se nao existe um arquivo igual
	_n := aScan(aArqP,{|x| cProd==x[4] .and. Alltrim(x[5])==Alltrim(cTitArqP)})

	If _n<>0
		Alert("Arquivo já existe com este nome!")
		Return
	EndIf
	
	oTree:BeginUpdate() // Sempre fechar o com EndUpdate

	For x:=1 to Len(aProd)
		If ALLTRIM(cProd)==ALLTRIM(aProd[x][4])
			lExist := .T.
			oTree:TreeSeek(aProd[x][3])
		EndIf
	Next

	If !lExist
		Alert("Produto não existe ou não foi adicionado!")
		Return
	EndIf
	
	//gera o id (cargo) do item da árvore
	//cCargo := "ArqP"+cProd+StrZero(Len(aArqP)+1,3) //"ArqP" + codproduto + sequencial de 3 posicoes
    If !lCarrega //incluir
    	cCargo := GetSxeNum("ZBR","ZBR_CARGO")
    	ConfirmSx8()
    Else 
    	cCargo := cZBRCargo
    EndIf                                          

	oTree:AddItem(cTitArqP,cCargo,"CLIPS","CLIPS",,,4)

	//         {cli ,loja ,cargo ,prod ,nomearq ,endarq,docarq}
	aAdd(aArqP,{cCli,cLoja,cCargo,cProd,cTitArqP,cArqP,cDocArq})//adiciona o produto na matriz de produtos

	oTree:EndUpdate()

	oTree:Refresh()
	
	If !lCarrega
		oDlgArqP:End()
	EndIf

Return

*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA QUAL O CARGO PARA REALIZAR A EXCLUSÃO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fExc()
Local cCargo 
Local lExc := .F.
	
    cCargo := AllTrim(oTree:GetCargo())

	If MsgYesNo("Deseja excluir este ítem?")

		If cCargo=="Client"
			Alert("Impossível excluir o cliente!")
			Return .F.
		EndIf
	    
		//localiza no array de arq. cliente
		_n := aScan(aArq,{|x| x[3]==cCargo})
		
		If _n<>0
		
		 	If aArq[_n][10]=="S"
		 		Alert("Impossível excluir um ítem padrão da estrutura do cliente!")
		 		Return
		 	EndIf

			If aArq[_n][6]=="S"
				cPai := aArq[_n][3]
			
				_m := aScan(aArq,{|x| x[5]==cPai})
				If _m <> 0
					Alert("Impossível excluir esta pasta! Ela não está vazia!")
					Return
				EndIf
			EndIf
					
			//-- exclui do array aArq --//	
			If Len(aArq)==1
				aArq := {}
			Else
				aDel(aArq,_n)
				_aArq := {}
				For _x := 1 to Len(aArq)
					If !ValType(aArq[_x])$"U"
						aAdd(_aArq,aArq[_x])
					EndIf
				Next
				aArq := aClone(_aArq)
			EndIf
			lExc := .T.

		Else
			Alert("Impossível excluir este ítem!")
			Return
		EndIf
		
		If lExc
			//deleta da arvore o item deletado
			oTree:DelItem()
		Else
			Alert("Item não excluído!")
		EndIf
	EndIf
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REALIZA A ALTERAÇÃO DO CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fAltera()

	ZBR->(DbSetOrder(1)) // filial + cli + loja + cargo

	//Grava os arquivos do Cliente
	For x:=1 to Len(aArq)

		ZBR->(DbSeek(xFilial("ZBR")+cCli+cLoja+aArq[x][3]))
		If ZBR->(!Found())
		
			//INCLUI
			//Faz o upload da imagem se for um arquivo
			If aArq[x][6]=="N"//nao e pasta
				If !Empty(aArq[x][9]) .AND. aArq[x][7]=="A"  //endereco do arquivo nao vazio e arquivo em disco
	
				 	//startpath + cargo + extensao
					cTmp := cStartPath+aArq[x][3]+Right(AllTrim(aArq[x][9]),4)
		
					If !(cTmp==aArq[x][9])
						If __CopyFile(aArq[x][9],cTmp)
							aArq[x][9] := cTmp
						Else
							Alert("Impossível copiar Arquivo "+aArq[x][9])
							aArq[x][9] := ""
						EndIf
					EndIf
		            
	            EndIf
			EndIf
					
			RecLock("ZBR",.T.)
				ZBR->ZBR_FILIAL := xFilial("ZBR")
				ZBR->ZBR_CLI    := aArq[x][1]
				ZBR->ZBR_LOJA   := aArq[x][2]
				ZBR->ZBR_CARGO  := aArq[x][3]
				ZBR->ZBR_NIVEL  := aArq[x][4]
				ZBR->ZBR_PAI    := aArq[x][5]
				ZBR->ZBR_PASTA  := aArq[x][6]
				ZBR->ZBR_DOCARQ := aArq[x][7]
				ZBR->ZBR_NOMARQ := aArq[x][8]
				ZBR->ZBR_ENDARQ := aArq[x][9]
				ZBR->ZBR_PADRAO := aArq[x][10]
			MsUnLock("ZBR")
		EndIf

	Next

	ZBR->(DbGoTop())
	ZBR->(DbSeek(xFilial("ZBR")+cCli+cLoja))
	
	//varre a tabela ZBR procurando por arquivos que não existam nos arrays para excluir do banco
	WHILE ZBR->(!Eof()) .AND. ZBR->ZBR_CLI==cCli .AND. ZBR->ZBR_LOJA==cLoja
		
		lExc := .F.
		
		_n := aScan(aArq,{|x| x[3]==ZBR->ZBR_CARGO})
		If _n==0 
			lExc := .T.
		EndIf

		If lExc
			RecLock("ZBR",.F.)
				ZBR->(DbDelete())
			MsUnlock("ZBR")
		EndIf
	     
		ZBR->(DbSkip())
	ENDDO
	
	oDlg:End()

Return 

