#INCLUDE "rwmake.ch"
#INCLUDE "totvs.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Cadastro                                                !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! AFAT002.PRW                                             !
+------------------+---------------------------------------------------------+
!Descricao         ! Estrutura de composição de preços.                      !
+------------------+---------------------------------------------------------+
!Autor             ! Cleverson Funaki                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/06/2012                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+ 
*/
User Function NHEST217
	Private cCadastro := "Estrutura de Composição"
	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
			             {"Visualizar","U_EST217A",0,2} ,;
			             {"Incluir","U_EST217A",0,3} ,;
			             {"Alterar","U_EST217A",0,4} ,;
			             {"Rel.Hist.","U_EST217R",0,2}}
	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString := "Z02"

	dbSelectArea("Z02")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString)
Return

/*
+----------------------------------------------------------------------------+
! Função    ! AFAT002A     ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Tela de manutenção do cadastro de composições.                 !
+-----------+----------------------------------------------------------------+
*/
User Function EST217A(cAlias,nReg,nOpc)
	Local _aArea := GetArea()
	Local _aButtons := {}
	Local _aHeader := {}
	Local _aCols := {}
	Local _aCpoAlt := {"Z03_CODCOM","Z03_VALOR"}
	Local _nOldZ02 := 0
	Local _nEditGD := nil
	Local _aSize := {}
	Local _aObjects := {}
	Local _aInfo := {}
	Local _aCpoAux := {}
	Private _aColsAux := {}
	Private _aCampos := {"Z03_CODCOM","Z03_SINTET","Z03_DESCRI","Z03_VALOR"}
	Private _cTabela := CriaVar("Z02_CODIGO",.F.)
	Private _aTiCon := {"A=Aberto","F=Fechado"}
	Private _cTiCon := "A"
	Private _cProduto := CriaVar("B1_COD",.F.)
	Private _cDesPrd := CriaVar("B1_DESC",.F.)
	Private _cCliente := CriaVar("A1_COD",.F.)
	Private _cLoja := CriaVar("A1_LOJA",.F.)
	Private _cNomCli := CriaVar("A1_NOME",.F.)
	Private _dDtIni := DDATABASE
	Private _dDtFim := STOD("")
	Private _nVolume := 0
	Private _nTotal := 0
	
	// Cria arquivo temporário para controlar os valores por estrutura
	AADD(_aCpoAux,{"CODIGO","C",6,0})
	AADD(_aCpoAux,{"PRODUTO","C",15,0})
	AADD(_aCpoAux,{"DESCRI","C",30,0})
	AADD(_aCpoAux,{"VALOR","N",17,2})
	
	If SELECT("TMPEST") > 0
		TMPEST->(dbCloseArea())
	Endif

	cNomeArq:=CriaTrab( _aCpoAux, .T. )
	dbUseArea(.T.,__LocalDriver,cNomeArq,"TMPEST",.F.,.F.)
	INDEX ON TMPEST->CODIGO+TMPEST->PRODUTO TO &cNomeArq
	
	// Permite alterar somente se for a última revisão
	If nOpc == 4
		If A002Revisao(Z02->Z02_CODIGO,Z02->Z02_ALTPED,Z02->Z02_TPCONT,Z02->Z02_PRODUT,Z02->Z02_CLIENT,Z02->Z02_LOJA,.F.) != Z02->Z02_REVISA
			Alert("A alteração pode ser realizada somente na última revisão da estrutura.")
			Return
		Endif
	Endif
	
	Aadd(_aButtons, {"PENDENTE", {|| A002Total() }, "Total por Tipo", "Total" , {|| .T.}})
	Aadd(_aButtons, {"PENDENTE", {|| A002Det(nOpc) }, "Valor Estrutura", "Estrutura" , {|| .T.}})
	
	_aSize := MsAdvSize()

	AAdd(_aObjects, { 100, 100, .T., .T. } ) // Dados da Enchoice 
	AAdd(_aObjects, { 200, 200, .T., .T. } ) // Dados da getdados 
	
	// Dados da área de trabalho e separação
	_aInfo := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3} 
	
	// Chama MsObjSize e recebe array e tamanhos
	_aPosObj := MsObjSize(_aInfo,_aObjects,.T.)
	
	RegToMemory("Z02",(nOpc==3)) 
	
	// Define os campos da getdados
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nX := 1 to Len(_aCampos)
		If SX3->(dbSeek(_aCampos[nX]))
			AADD(_aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
							 SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX
	
	If nOpc == 3
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		For nX := 1 to Len(_aCampos)
			If dbSeek(_aCampos[nX])
				AADD(_aColsAux, CriaVar(SX3->X3_CAMPO))
			Endif
		Next nX
		AADD(_aColsAux, .F.)
		AADD(_aCols, _aColsAux)
	Else
		_aCols := A002Cols()
		
		// Se for alteração, alguns incrementa o número da revisão e limpa os campos necessários
		If nOpc == 4
			_nOldZ02 := Z02->(Recno())
			
			M->Z02_REVISA := A002Revisao(Z02->Z02_CODIGO,Z02->Z02_ALTPED,Z02->Z02_TPCONT,Z02->Z02_PRODUT,Z02->Z02_CLIENT,Z02->Z02_LOJA,.T.)
//			M->Z02_ALTPED := CriaVar("Z02_ALTPED",.F.)
			M->Z02_OBS := CriaVar("Z02_OBS",.F.)
			M->Z02_USER := CriaVar("Z02_USER",.T.)
			M->Z02_DTALT := CriaVar("Z02_DTALT",.T.)
			M->Z02_HORA := CriaVar("Z02_HORA",.T.)
		Endif
	Endif
	
	DEFINE MSDIALOG oDlg TITLE "Estrutura de Composição" FROM _aSize[7],0 To _aSize[6],_aSize[5] of oMainWnd PIXEL	//FROM 000,000 To 450,800 
	EnChoice("Z02",nReg,nOpc,,,,,{_aPosObj[1,1],_aPosObj[1,2],_aPosObj[1,3],_aPosObj[1,4]},,3,,,,,,.F.)
	
	If nOpc == 3 .Or. nOpc == 4
		_nEditGD := GD_INSERT + GD_UPDATE + GD_DELETE
	Else
		_nEditGD := nil
	Endif
	_oGDEst := MsNewGetDados():New(_aPosObj[2,1],_aPosObj[2,2],_aPosObj[2,3]-25,_aPosObj[2,4],_nEditGD,"AllwaysTrue","AllwaysTrue",,_aCpoAlt,,999,"AllwaysTrue","","AllwaysTrue",oDlg,_aHeader,_aCols,"U_EST217C()")
//	_oGDEst:oBrowse:blDblClick := {|| A002Det(nOpc) }
	@_aPosObj[2,3]-21,_aPosObj[2,4]-130 GROUP _oGrpTot TO _aPosObj[2,3],_aPosObj[2,4] PROMPT "" OF oDlg PIXEL
	@_aPosObj[2,3]-13,_aPosObj[2,4]-120 SAY "Preço do Produto:" SIZE 050,007 OF _oGrpTot PIXEL
	@_aPosObj[2,3]-15,_aPosObj[2,4]-70 MSGET _oTotal VAR _nTotal PICTURE "@E 999,999,999,999.99" WHEN .F. SIZE 065,008 OF _oGrpTot PIXEL
 	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg, {|| IF(A002Ok(nOpc),oDlg:End(),Nil) },{|| oDlg:End() },,_aButtons)
 	
 	If (nOpc == 2 .Or. nOpc == 4) .And. _nOldZ02 > 0
 		Z02->(dbGoTo(_nOldZ02))
 	Endif
	
	RestArea(_aArea)
Return

/*
+----------------------------------------------------------------------------+
! Função    ! A002Cols     ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! _cChave - Código do produto                                    !
!           ! _aRet (OUT) - Array com as informações para o aCols            !
+-----------+----------------------------------------------------------------+
! Descricao ! Função para montar o aCols de acordo com a chave passada.      !
+-----------+----------------------------------------------------------------+
*/
Static Function A002Cols
	Local _aRet := {}
	
	dbSelectArea("Z03")
	Z03->(dbSetOrder(1))
	Z03->(dbSeek(xFilial("Z03")+Z02->Z02_CODIGO+Z02->Z02_ALTPED+Z02->Z02_TPCONT+Z02->Z02_REVISA+Z02->Z02_PRODUT+Z02->Z02_CLIENT+Z02->Z02_LOJA))
	
	While !Z03->(EOF()) .And. Alltrim(Z03->Z03_FILIAL+Z03->Z03_CODIGO+Z03->Z03_ALTPED+Z03->Z03_TPCONT+Z03->Z03_REVISA+Z03->Z03_PRODUT+Z03->Z03_CLIENT+Z03->Z03_LOJA)==Alltrim(xFilial("Z03")+Z02->Z02_CODIGO+Z02->Z02_ALTPED+Z02->Z02_TPCONT+Z02->Z02_REVISA+Z02->Z02_PRODUT+Z02->Z02_CLIENT+Z02->Z02_LOJA)
		_aColsAux := {}
		For _nI := 1 to Len(_aCampos)
			If Alltrim(_aCampos[_nI]) == "Z03_DESCRI"
				AADD(_aColsAux, Posicione("Z01",1,xFilial("Z01")+Z03->Z03_CODCOM,"Z01_DESCRI"))
			ElseIf Alltrim(_aCampos[_nI]) == "Z03_SINTET"
				AADD(_aColsAux, Posicione("Z01",1,xFilial("Z01")+Substr(Z03->Z03_CODCOM,1,3),"Z01_DESCRI"))
			Else
				AADD(_aColsAux, Z03->&(_aCampos[_nI]))
			Endif
		Next nX
		AADD(_aColsAux, .F.)
		AADD(_aRet, _aColsAux)
		
		// Verifica se o tipo de composição é controlado por estrutura
		dbSelectArea("Z01")
		Z01->(dbSetOrder(1))
		If Z01->(dbSeek(xFilial("Z01")+Z03->Z03_CODCOM))
			// Recupera os preços cadastrados por item da estrutura para o arquivo temporário
			If Z01->Z01_ESTRUT == "S"
				dbSelectArea("Z04")
				Z04->(dbSetOrder(1))
				Z04->(dbSeek(xFilial("Z04")+Z03->Z03_CODIGO+Z03->Z03_ALTPED+Z03->Z03_REVISA+Z03->Z03_TPCONT+Z03->Z03_PRODUT+Z03->Z03_CLIENT+Z03->Z03_LOJA+Z03->Z03_CODCOM))
				
				While !Z04->(EOF()) .And. ;
					  Z04->Z04_FILIAL+Z04->Z04_CODIGO+Z04->Z04_ALTPED+Z04->Z04_REVISA+Z04->Z04_TPCONT+Z04->Z04_PRODUT+Z04->Z04_CLIENT+Z04->Z04_LOJA+Z04->Z04_CODCOM==xFilial("Z04")+Z03->Z03_CODIGO+Z03->Z03_ALTPED+Z03->Z03_REVISA+Z03->Z03_TPCONT+Z03->Z03_PRODUT+Z03->Z03_CLIENT+Z03->Z03_LOJA+Z03->Z03_CODCOM
					RecLock("TMPEST",.T.)
					TMPEST->CODIGO := Z04->Z04_CODCOM
					TMPEST->PRODUTO := Z04->Z04_CODPRO
					TMPEST->DESCRI := Z04->Z04_DESCRI
					TMPEST->VALOR := Z04->Z04_VALOR
					MsUnlock("TMPEST")
					
					Z04->(dbSkip())
				Enddo
			Endif
		Endif
		
		_nTotal += Z03->Z03_VALOR

		Z03->(dbSkip())
	Enddo
Return(_aRet)

Static Function A002Revisao(_pTabela,_pAltPed,_pTpCont,_pProduto,_pCliente,_pLoja,_pProx)
	Local _aArea := GetArea()
	Local _cRet := "001"
	
	If SELECT("QREV") > 0
		QREV->(dbCloseArea())
	Endif
	
	BeginSql Alias "QREV"
		SELECT ISNULL(MAX(Z02.Z02_REVISA),"000") AS Z02_REVISA
		  FROM %table:Z02% Z02
		 WHERE Z02.Z02_FILIAL = %xFilial:Z02%
		   AND Z02.Z02_CODIGO = %Exp:_pTabela%
		   AND Z02.Z02_ALTPED = %Exp:_pAltPed%
		   AND Z02.Z02_TPCONT = %Exp:_pTpCont%
		   AND Z02.Z02_PRODUT = %Exp:_pProduto%
		   AND Z02.Z02_CLIENT = %Exp:_pCliente%
		   AND Z02.Z02_LOJA = %Exp:_pLoja%
		   AND Z02.%NotDel%
	EndSql
	
	If !QREV->(EOF())
		If _pProx .Or. QREV->Z02_REVISA == "000"
			_cRet := SOMA1(QREV->Z02_REVISA)
		Else
			_cRet := QREV->Z02_REVISA
		Endif
	Endif
	QREV->(dbCloseArea())
	
	RestArea(_aArea)
Return(_cRet)

/*
+----------------------------------------------------------------------------+
! Função    ! V002Prod     ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! _nOpc - Opção selecionada no menu                              !
!           ! _lRet (OUT) - Flag de produto válido ou inválido               !
+-----------+----------------------------------------------------------------+
! Descricao ! Validação do campo Produto. Se o produto já possuir estrutura  !
!           ! cadastrada, preenche o aCols e muda o nOpc para 4 (alteração). !
+-----------+----------------------------------------------------------------+
*/
Static Function V002Prod(_nOpc)
	Local _lRet := .T.
	
	If ExistCpo("SB1",_cProduto)
		_cDesPrd := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_DESC")
		
		// Se for inclusão, verifica se o produto já possui estrutura
		If _nOpc == 3
			Z02->(dbGoTop())
			If Z02->(dbSeek(xFilial("Z02")+Alltrim(_cProduto)))
				_oGDEst:aCols := {}
				_oGDEst:aCols := A002Cols(_cProduto)
				_oGDEst:oBrowse:Refresh()
				
				_nOpc := 4
			Endif
		Endif
	Else
		_lRet := .F.
	Endif
Return(_lRet)

/*
+----------------------------------------------------------------------------+
! Função    ! AFAT002B     ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! _lRet (OUT) - Flag de tipo válido ou inválido                  !
+-----------+----------------------------------------------------------------+
! Descricao ! Função de validação do campo de tipo de composição.            !
+-----------+----------------------------------------------------------------+
*/
User Function EST217B
	Local _lRet := .T.
	
	// Verifica se o código está cadastrado
	If ExistCpo("Z01",M->Z03_CODCOM)
		// Verifica se já existe alguma linha com o código cadastrado
		For _nI := 1 To Len(_oGDEst:aCols)
			If _nI != _oGDEst:nAT .And. GDFieldGet("Z03_CODCOM",_nI) == M->Z03_CODCOM .And. !_oGDEst:aCols[_nI,(Len(_oGDEst:aHeader)+1)]
				Alert("Este código já foi incluído para este produto. Verifique!")
				_lRet := .F.
				Exit
			Endif
		Next _nI
	Else
		_lRet := .F.
	Endif
Return(_lRet)

// Função de confirmação da tela
/*
+----------------------------------------------------------------------------+
! Função    ! A002Ok       ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! _nOpc - Opção selecionada no menu                              !
!           ! _lOk (OUT) - Flag de gravação OK                               !
+-----------+----------------------------------------------------------------+
! Descricao ! Função de confirmação da tela.                                 !
+-----------+----------------------------------------------------------------+
*/
Static Function A002Ok(_nOpc)
	Local _lOk := .F.
	
	If _nOpc == 3 .Or. _nOpc == 4
		If Empty(M->Z02_CODIGO)
			Alert("Favor informar o número do pedido.")
			Return(.F.)
		Endif
		
		If Empty(M->Z02_PRODUT)
			Alert("Favor informar o código do produto.")
			Return(.F.)
		Endif
		
		If Empty(M->Z02_CLIENT) .Or. Empty(M->Z02_LOJA)
			Alert("Favor informar o código/loja do cliente.")
			Return(.F.)
		Endif
		
		If Empty(M->Z02_DTINI)
			Alert("Favor informar a data de início de vigência do pedido.")
			Return(.F.)
		Endif
		
		If Empty(M->Z02_OBS)
			Alert("Favor informar o motivo da inclusão/alteração do pedido.")
			Return(.F.)
		Endif
		
		For _nI := 1 To Len(_oGDEst:aCols)
			If !_oGDEst:aCols[_nI,(Len(_oGDEst:aHeader)+1)] .And. !Empty(_oGDEst:aCols[_nI,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)])
				For _nJ := 1 To Len(_oGDEst:aCols)
					If _nI != _nJ .And. !_oGDEst:aCols[_nJ,(Len(_oGDEst:aHeader)+1)] .And. _oGDEst:aCols[_nI,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)] == _oGDEst:aCols[_nJ,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)]
						Alert("Existem itens duplicados na estrutura de preços.")
						Return(.F.)
					Endif
				Next _nJ
			Endif
		Next _nI
		
		// Se for alteração, verifica se houve alguma alteração
		If _nOpc == 4
			_lAlt := .F.
			If M->Z02_ALTPED != Z02->Z02_ALTPED .Or. M->Z02_DTINI != Z02->Z02_DTINI .Or. M->Z02_DTFIM != Z02->Z02_DTFIM .Or. M->Z02_VOLUME != Z02->Z02_VOLUME
				_lAlt := .T.
			Endif
			
			If !_lAlt
				dbSelectArea("Z03")
				Z03->(dbSetOrder(1))
				
				For _nI := 1 To Len(_oGDEst:aCols)
					If !_oGDEst:aCols[_nI,(Len(_oGDEst:aHeader)+1)]
						If Z03->(dbSeek(xFilial("Z03")+Z02->Z02_CODIGO+Z02->Z02_ALTPED+Z02->Z02_TPCONT+Z02->Z02_REVISA+Z02->Z02_PRODUT+Z02->Z02_CLIENT+Z02->Z02_LOJA+_oGDEst:aCols[_nI,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)]))
							If Z03->Z03_VALOR != _oGDEst:aCols[_nI,GdFieldPos("Z03_VALOR",_oGDEst:aHeader)]
								_lAlt := .T.
								Exit
							Endif
						Else
							_lAlt := .T.
							Exit
						Endif
					Else
						If Z03->(dbSeek(xFilial("Z03")+Z02->Z02_CODIGO+Z02->Z02_ALTPED+Z02->Z02_TPCONT+Z02->Z02_REVISA+Z02->Z02_PRODUT+Z02->Z02_CLIENT+Z02->Z02_LOJA+_oGDEst:aCols[_nI,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)]))
							_lAlt := .T.
							Exit
						Endif
					Endif
				Next _nI
			Endif
			
			// Verifica se foi alterado algum valor por item
			If !_lAlt
				dbSelectArea("Z04")
				Z04->(dbSetOrder(1))
				
				TMPEST->(dbGoTop())
				While !TMPEST->(EOF())
					If Z04->(dbSeek(xFilial("Z04")+Z02->Z02_CODIGO+Z02->Z02_REVISA+Z02->Z02_TPCONT+Z02->Z02_PRODUT+Z02->Z02_CLIENT+Z02->Z02_LOJA+TMPEST->CODIGO+TMPEST->PRODUTO+Z02->Z02_ALTPED))
						If Z04->Z04_VALOR != TMPEST->VALOR
							_lAlt := .T.
							Exit
						Endif
					Else
						_lAlt := .T.
						Exit
					Endif
					
					TMPEST->(dbSkip())
				Enddo
			Endif
			
			If !_lAlt
				Alert("Não foi realizada nenhuma alteração na estrutura, não será gerada nova revisão.")
				Return(.F.)
			Endif
		Endif
		
		Begin Transaction
		
		// Grava o cabeçalho
		RecLock("Z02",.T.)
		Z02->Z02_FILIAL:= xFilial("Z02")
		Z02->Z02_CODIGO:= M->Z02_CODIGO
		Z02->Z02_ALTPED:= M->Z02_ALTPED
		Z02->Z02_TPCONT:= M->Z02_TPCONT
		Z02->Z02_REVISA:= M->Z02_REVISA
		Z02->Z02_PRODUT:= M->Z02_PRODUT
		Z02->Z02_CLIENT:= M->Z02_CLIENT
		Z02->Z02_LOJA  := M->Z02_LOJA
		Z02->Z02_DTINI := M->Z02_DTINI
		Z02->Z02_DTFIM := M->Z02_DTFIM
		Z02->Z02_VOLUME:= M->Z02_VOLUME
		Z02->Z02_SALDO := M->Z02_SALDO
		Z02->Z02_OBS   := M->Z02_OBS
		Z02->Z02_USER  := M->Z02_USER
		Z02->Z02_DTALT := M->Z02_DTALT
		Z02->Z02_HORA  := M->Z02_HORA
		Z02->Z02_IMPOST:= M->Z02_IMPOST
		Z02->Z02_MOEDA := M->Z02_MOEDA		
		MsUnlock("Z02")

		// Grava os itens da estrutura		
		For _nI := 1 To Len(_oGDEst:aCols)
			If !_oGDEst:aCols[_nI,(Len(_oGDEst:aHeader)+1)]
				RecLock("Z03",.T.)
				Z03->Z03_FILIAL := xFilial("Z03")
				Z03->Z03_CODIGO := M->Z02_CODIGO
				Z03->Z03_ALTPED := M->Z02_ALTPED
				Z03->Z03_TPCONT := M->Z02_TPCONT
				Z03->Z03_REVISA := M->Z02_REVISA
				Z03->Z03_PRODUT := M->Z02_PRODUT
				Z03->Z03_CLIENT := M->Z02_CLIENT
				Z03->Z03_LOJA := M->Z02_LOJA
				Z03->Z03_CODCOM := _oGDEst:aCols[_nI,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)]
				Z03->Z03_VALOR := _oGDEst:aCols[_nI,GdFieldPos("Z03_VALOR",_oGDEst:aHeader)]
				MsUnlock("Z03")
			Endif
		Next _nI
		
		// Grava os valores por item de estrutura
		TMPEST->(dbGoTop())
		While !TMPEST->(EOF())
			dbSelectArea("Z04")
			Z04->(dbSetOrder(1))
			If !Z04->(dbSeek(xFilial("Z04")+M->Z02_CODIGO+M->Z02_ALTPED+M->Z02_REVISA+M->Z02_TPCONT+M->Z02_PRODUT+M->Z02_CLIENT+M->Z02_LOJA+TMPEST->CODIGO+TMPEST->PRODUTO))
				RecLock("Z04",.T.)
				Z04->Z04_FILIAL := xFilial("Z04")
				Z04->Z04_CODIGO := M->Z02_CODIGO
				Z04->Z04_ALTPED := M->Z02_ALTPED
				Z04->Z04_REVISA := M->Z02_REVISA
				Z04->Z04_TPCONT := M->Z02_TPCONT
				Z04->Z04_PRODUT := M->Z02_PRODUT
				Z04->Z04_CLIENT := M->Z02_CLIENT
				Z04->Z04_LOJA := M->Z02_LOJA
				Z04->Z04_CODCOM := TMPEST->CODIGO
				Z04->Z04_CODPRO := TMPEST->PRODUTO
				Z04->Z04_DESCRI := TMPEST->DESCRI
			Else
				RecLock("Z04",.F.)
			Endif
			Z04->Z04_VALOR := TMPEST->VALOR
			MsUnlock("Z04")
			
			TMPEST->(dbSkip())
		Enddo
		
		End Transaction
	Endif
Return(.T.)

Static Function A002Total
	Private aList := {}
	Private oLbx1
	
	Processa({|| A002Lista()})
	
	DEFINE MSDIALOG oDlgTot TITLE "Totais por tipo" FROM 000,000 TO 230,500 OF oMainWnd PIXEL
	@ 015,002 LISTBOX oLbx1 FIELDS HEADER "Tipo","Total" SIZE 250,100 OF oDlgTot PIXEL
	oLbx1:SetArray(aList)
	oLbx1:bLine := { || {aList[oLbx1:nAt,1],aList[oLbx1:nAt,2] } }
	oLbx1:nFreeze  := 2
	ACTIVATE MSDIALOG oDlgTot ON INIT EnchoiceBar(oDlgTot,{|| oDlgTot:End()},{|| oDlgTot:End()},,) CENTERED
Return

Static Function A002Lista
	Local _cAux := ""
	Local _aAux := {}
	
	ProcRegua(Len(_oGDEst:aCols))
	
	For _nI := 1 To Len(_oGDEst:aCols)
		IncProc("Totalizando a estrutura...")
		If !_oGDEst:aCols[_nI,(Len(_oGDEst:aHeader)+1)]
			_cAux := Substr(_oGDEst:aCols[_nI,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)],1,3)
			_nPos := aScan(_aAux,{|X| ALLTRIM(X[1]) == Alltrim(_cAux)})
			
			If _nPos == 0
				AADD(_aAux,{_cAux,_oGDEst:aCols[_nI,GdFieldPos("Z03_VALOR",_oGDEst:aHeader)]})
			Else
				_aAux[_nPos,2] += _oGDEst:aCols[_nI,GdFieldPos("Z03_VALOR",_oGDEst:aHeader)]
			Endif
		Endif
	Next _nI
	
	For _nI := 1 To Len(_aAux)
		AADD(aList,{Posicione("Z01",1,xFilial("Z01")+_aAux[_nI,1],"Z01_DESCRI"),;
					Transform(_aAux[_nI,2],"@E 999,999,999,999,999.99")})
	Next _nI
Return

/*
+----------------------------------------------------------------------------+
! Função    ! AFAT002C     ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Função para atualizar o valor total do produto no rodapé.      !
+-----------+----------------------------------------------------------------+
*/
User Function EST217C
	_nTotal := 0
	For _nI := 1 To Len(_oGDEst:aCols)
		If !_oGDEst:aCols[_nI,(Len(_oGDEst:aHeader)+1)]
			_nTotal += (_oGDEst:aCols[_nI,GdFieldPos("Z03_VALOR",_oGDEst:aHeader)])	// * _oGDEst:aCols[_nI,GdFieldPos("Z02_QUANT",_oGDEst:aHeader)])
		Endif
	Next _nI
		
	_oTotal:Refresh()
Return

/*
+----------------------------------------------------------------------------+
! Função    ! AFAT002D     ! Autor ! Cleverson Funaki   ! Data !  20/06/12   !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! _nRet (OUT) - Valor do produto                                 !
+-----------+----------------------------------------------------------------+
! Descricao ! Função para retonar o valor do produto de acordo com a composi-!
!           ! ção. Utilizado no gatilho do campo DA1_CODPRO.                 !
+-----------+----------------------------------------------------------------+
*/
User Function EST217D
	Local _aArea := GetArea()
	Local _nRet := 0
	Local _cCliente := CriaVar("Z02_CLIENT",.F.)
	Local _cLojaCli := CriaVar("Z02_LOJA",.F.)
	Local _cProduto := CriaVar("Z02_PRODUT",.F.)
	Local _dDtPed := CriaVar("Z02_DTINI",.F.)
	
	If Alltrim(Funname()) == "NHFAT014"
		_cCliente := _cCli
		_cLojaCli := _cLoja
		_cProduto := M->ZR_PRODUTO
		_dDtPed := _dData
	ElseIf Alltrim(Funname()) == "MATA410"
		_cCliente := M->C5_CLIENTE
		_cLojaCli := M->C5_LOJACLI
		_cProduto := M->C6_PRODUTO
		_dDtPed := M->C5_EMISSAO
	Endif
	
	If SELECT("QZ02") > 0
		QZ02->(dbCloseArea())
	Endif
	
	BeginSql Alias "QZ02"
		SELECT Z02.Z02_CODIGO,
			   Z02.Z02_ALTPED,
			   Z02.Z02_TPCONT,
			   Z02.Z02_REVISA,
			   Z02.Z02_PRODUT,
			   Z02.Z02_CLIENT,
			   Z02.Z02_LOJA,
			   Z02.Z02_DTINI,
			   SUM(Z03.Z03_VALOR) AS Z03_VALOR
		  FROM %table:Z02% Z02
		  JOIN %table:Z03% Z03 ON (Z03.Z03_FILIAL = Z02.Z02_FILIAL
		  					   AND Z03.Z03_CODIGO = Z02.Z02_CODIGO
		  					   AND Z03.Z03_ALTPED = Z02.Z02_ALTPED
							   AND Z03.Z03_TPCONT = Z02.Z02_TPCONT
							   AND Z03.Z03_CLIENT = Z02.Z02_CLIENT
							   AND Z03.Z03_LOJA = Z02.Z02_LOJA
							   AND Z03.Z03_PRODUT = Z02.Z02_PRODUT
							   AND Z03.Z03_REVISA = Z02.Z02_REVISA
							   AND Z03.%NotDel%)
		 WHERE Z02.Z02_FILIAL = %xFilial:Z02%
		   AND Z02.Z02_CLIENT = %Exp:_cCliente%
		   AND Z02.Z02_LOJA = %Exp:_cLojaCli%
		   AND Z02.Z02_PRODUT = %Exp:_cProduto%
		   AND Z02.Z02_DTINI <= %Exp:DTOS(_dDtPed)%
		   AND (Z02.Z02_DTFIM = ' '
		     OR Z02.Z02_DTFIM >= %Exp:DTOS(_dDtPed)%)
		   AND Z02.Z02_REVISA = (SELECT MAX(T2.Z02_REVISA)
								   FROM %table:Z02% T2
								  WHERE T2.Z02_CODIGO = Z02.Z02_CODIGO
								  	AND T2.Z02_PRODUT = Z02.Z02_PRODUT
								  	AND T2.Z02_CLIENT = Z02.Z02_CLIENT
								  	AND T2.Z02_LOJA = Z02.Z02_LOJA
								  	AND T2.Z02_TPCONT = Z02.Z02_TPCONT
								  	AND T2.%NotDel%)
		   AND Z02.%NotDel%
		 GROUP BY Z02.Z02_CODIGO, Z02.Z02_ALTPED, Z02.Z02_TPCONT, Z02.Z02_REVISA, Z02.Z02_PRODUT, Z02.Z02_CLIENT, Z02.Z02_LOJA, Z02.Z02_DTINI
		 ORDER BY Z02.Z02_TPCONT DESC, Z02.Z02_DTINI ASC
	EndSql
	
	dbSelectArea("Z02")
	Z02->(dbSetOrder(1))
	
	While !QZ02->(EOF())
		If Z02->(dbSeek(xFilial("Z02")+QZ02->Z02_CODIGO+QZ02->Z02_ALTPED+QZ02->Z02_TPCONT+QZ02->Z02_REVISA+QZ02->Z02_PRODUT+QZ02->Z02_CLIENT+QZ02->Z02_LOJA))
			// Se possuir volume cadastrado, verifica se tem saldo a utilizar
			If Z02->Z02_VOLUME == 0
				_nRet := QZ02->Z03_VALOR
				Exit
			ElseIf Z02->Z02_VOLUME > 0 .And. Z02->Z02_SALDO > 0
				// Verifica se a tabela já foi utilizada em algum item para verificar o saldo
				_nSalAux := 0
				
				For _nI := 1 To Len(aCols)
					If !aCols[_nI][Len(aHeader)+1] .And. _nI != N
						If Alltrim(Funname()) == "NHFAT014"
							If Alltrim(_aTab[_nI]) == Alltrim(xFilial("Z02")+QZ02->Z02_CODIGO+QZ02->Z02_ALTPED+QZ02->Z02_TPCONT+QZ02->Z02_REVISA+QZ02->Z02_PRODUT+QZ02->Z02_CLIENT+QZ02->Z02_LOJA)
								_nSalAux += aCols[_nI][aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"})]
							Endif
						ElseIf Alltrim(Funname()) == "MATA410"
							If Alltrim(aCols[_nI,aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C6_TABPRC"})]) == Alltrim(xFilial("Z02")+QZ02->Z02_CODIGO+QZ02->Z02_ALTPED+QZ02->Z02_TPCONT+QZ02->Z02_REVISA+QZ02->Z02_PRODUT+QZ02->Z02_CLIENT+QZ02->Z02_LOJA)
								_nSalAux += aCols[_nI][aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C6_QTDVEN"})]
							Endif
						Endif
					Endif
				Next _nI
					
				If (Z02->Z02_SALDO - _nSalAux) > 0
					_nRet := QZ02->Z03_VALOR
					Exit
				Endif
			Endif
		Endif
		
		QZ02->(dbSkip())
	Enddo
	
	If _nRet > 0
		If Alltrim(Funname()) == "NHFAT014"
			If Len(_aTab) >= N
				_aTab[N] := xFilial("Z02")+QZ02->Z02_CODIGO+QZ02->Z02_ALTPED+QZ02->Z02_TPCONT+QZ02->Z02_REVISA+QZ02->Z02_PRODUT+QZ02->Z02_CLIENT+QZ02->Z02_LOJA
			Else
				For _nK := Len(_aTab)+1 To N
					If _nK == N
						AADD(_aTab,xFilial("Z02")+QZ02->Z02_CODIGO+QZ02->Z02_ALTPED+QZ02->Z02_TPCONT+QZ02->Z02_REVISA+QZ02->Z02_PRODUT+QZ02->Z02_CLIENT+QZ02->Z02_LOJA)
					Else
						AADD(_aTab,"")
					Endif
				Next
			Endif
		ElseIf Alltrim(Funname()) == "MATA410"
			aCols[N,aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C6_TABPRC"})] := xFilial("Z02")+QZ02->Z02_CODIGO+QZ02->Z02_ALTPED+QZ02->Z02_TPCONT+QZ02->Z02_REVISA+QZ02->Z02_PRODUT+QZ02->Z02_CLIENT+QZ02->Z02_LOJA
		Endif
	Else
		_nRet := Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_PRV1")
	Endif
	QZ02->(dbCloseArea())
	
	RestArea(_aArea)
Return(_nRet)

// Verifica se possui o volume necessário na tabela fechada
User Function EST217E
	Local _aArea := GetArea()
	Local _nTotAux := 0
	Local _nSalAux := 0
	
	dbSelectArea("Z02")
	Z02->(dbSetOrder(1))
	
	For _nI := 1 To Len(aCols)
		If !aCols[_nI][Len(aHeader)+1] .And. _nI != N
			If Z02->(dbSeek(_aTab[_nI]))
				If Z02->Z02_SALDO > 0
					_nTotAux += aCols[_nI][aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZR_QTDE"})]
				Endif
			Endif
		Endif
	Next _nI
	
	If Z02->(dbSeek(_aTab[N]))
		If Z02->Z02_SALDO > 0
			_nSalAux := Z02->Z02_SALDO - _nTotAux
			
			If _nSalAux > 0 .And. M->ZR_QTDE > _nSalAux
				MsgInfo("Saldo de volume insuficiente na tabela de preços."+CHR(10)+CHR(13)+;
						"Saldo Volume: "+AllTrim(Str(_nSalAux))+CHR(10)+CHR(13)+;
						"Favor criar uma nova linha para o volume excedente!")
				Return(.F.)
			Endif
		Endif
	Endif
	
	RestArea(_aArea)
Return(.T.)

// Monta a tela de valores pela estrutura do produto
Static Function A002Det(nOpc)
	Local _aArea := GetArea()
	Local _cDComp := Alltrim(_oGDEst:aCols[_oGDEst:nAT,GdFieldPos("Z03_SINTET",_oGDEst:aHeader)]) + " - " + Alltrim(_oGDEst:aCols[_oGDEst:nAT,GdFieldPos("Z03_DESCRI",_oGDEst:aHeader)])
	Local _cTpProd := SPACE(2)
	Local _aEstrut := {}
	Local _aHeader := {}
	Local _aCols := {}
	Local _aAux := {}
	Local _aCpoAlt := {"Z04_VALOR"}
	Local _aCpoEst := {"Z04_CODPRO","Z04_DESCRI","Z04_VALOR"}
	Local _aButtons := {}
	Local _nEditGD := nil
	Private nEstru := 0
	Private _nValTot := 0
	Private _cTpComp := _oGDEst:aCols[_oGDEst:nAT,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)]
	
	// Verifica se o tipo de composição é controlado por estrutura
	dbSelectArea("Z01")
	Z01->(dbSetOrder(1))
	If Z01->(dbSeek(xFilial("Z01")+_cTpComp))
		If Z01->Z01_ESTRUT != "S"
			Alert("Este tipo de composição não possui controle dos valores pela estrutura de produtos. Verifique!")
			Return
		Else
			_cTpProd := Z01->Z01_TPPROD
		Endif
	Endif
	
	If !Empty(_cTpProd)
		// Recupera da estrutura do produto principal os tipos correspondentes
		dbSelectArea("SG1")
		SG1->(dbSetOrder(1))
		SG1->(dbSeek(xFilial("SG1")+M->Z02_PRODUT))
		
		While !SG1->(EOF()) .And. Alltrim(SG1->G1_FILIAL+SG1->G1_COD)==Alltrim(xFilial("SG1")+M->Z02_PRODUT)
			If Alltrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_TIPO")) == Alltrim(_cTpProd)
				// Verifica se já está no arquivo temporário
				TMPEST->(dbGoTop())
				If !TMPEST->(dbSeek(_cTpComp+SG1->G1_COMP))
					RecLock("TMPEST",.T.)
					TMPEST->CODIGO := _cTpComp
					TMPEST->PRODUTO := SG1->G1_COMP
					TMPEST->DESCRI := Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC")
					TMPEST->VALOR := 0
					MsUnlock("TMPEST")
				Endif
			Endif
			
			SG1->(dbSkip())
		Enddo
	Endif
	
	// Define os campos da getdados
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nX := 1 to Len(_aCpoEst)
		If SX3->(dbSeek(_aCpoEst[nX]))
			AADD(_aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
							 SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX
	
	// Monta o aCols de acordo com o arquivo temporário
	TMPEST->(dbGoTop())
	TMPEST->(dbSeek(_cTpComp))
	While !TMPEST->(EOF()) .And. Alltrim(TMPEST->CODIGO)==Alltrim(_cTpComp)
		_aAux := {}
		AADD(_aAux, TMPEST->PRODUTO)
		AADD(_aAux, Posicione("SB1",1,xFilial("SB1")+TMPEST->PRODUTO,"B1_DESC"))
		AADD(_aAux, TMPEST->VALOR)
		AADD(_aAux, .F.)
		AADD(_aCols, _aAux)
		
		_nValTot += TMPEST->VALOR
		
		TMPEST->(dbSkip())
	Enddo
	
	If Len(_aCols) > 0
		If nOpc == 3 .Or. nOpc == 4
			_nEditGD := GD_UPDATE
		Else
			_nEditGD := nil
		Endif
		
		// Monta a tela para informar os valores dos componentes da estrutura
		DEFINE MSDIALOG oDlgEst TITLE "Estrutura do Produto" FROM 000,000 To 280,560 of oMainWnd PIXEL
		@015,002 GROUP _oGrpBx TO 037,280 PROMPT "[ Tipo de Composição ]" OF oDlgEst PIXEL
		@025,005 SAY "Tipo:" SIZE 039,007 OF oDlgEst PIXEL
		@023,020 MSGET _cTpComp SIZE 030,007 PICTURE "@R !!!.!!!" WHEN .F. OF oDlgEst PIXEL
		@023,050 MSGET _cDComp SIZE 100,007 PICTURE "@!" WHEN .F. OF oDlgEst PIXEL
		@025,170 SAY "Valor Total:" SIZE 050,007 OF oDlgEst PIXEL
		@023,200 MSGET _oValTot VAR _nValTot SIZE 070,007 PICTURE "@E 999,999,999,999.99" WHEN .F. OF oDlgEst PIXEL
		oGDPrd := MsNewGetDados():New(040,003,135,280,_nEditGD,"AllwaysTrue","AllwaysTrue",,_aCpoAlt,,Len(_aCols),"AllwaysTrue","","Allwaystrue",oDlgEst,_aHeader,_aCols)
		ACTIVATE MSDIALOG oDlgEst CENTER ON INIT EnchoiceBar(oDlgEst, {|| IF(A002OkE(),oDlgEst:End(),Nil) },{|| oDlgEst:End() },,_aButtons)
	Endif
	
	RestArea(_aArea)
Return

Static Function A002OkE
	// Atualiza os valores por produto no arquivo temporário
	For _nI := 1 To Len(oGDPrd:aCols)
		If !oGDPrd:aCols[_nI,Len(oGDPrd:aCols[_nI])]
			TMPEST->(dbGoTop())
			If TMPEST->(dbSeek(_cTpComp+oGDPrd:aCols[_nI,GdFieldPos("Z04_CODPRO",oGDPrd:aHeader)]))
				RecLock("TMPEST",.F.)
				TMPEST->VALOR := oGDPrd:aCols[_nI,GdFieldPos("Z04_VALOR",oGDPrd:aHeader)]
				MsUnlock("TMPEST")
			Endif
		Endif
	Next _nI
	
	// Atualiza o valor na tela principal
	_oGDEst:aCols[_oGDEst:nAT,GdFieldPos("Z03_VALOR",_oGDEst:aHeader)] := _nValTot
	
	// Atualiza o valor total na tela principal
	U_EST217C()
Return(.T.)

// Atualiza o valor total da tela de estrutra de produtos
User Function EST217F
	_nValTot := M->Z04_VALOR
	For _nI := 1 To Len(oGDPrd:aCols)
		If !oGDPrd:aCols[_nI,Len(oGDPrd:aCols[_nI])] .And. _nI != oGDPrd:nAT
			_nValTot += oGDPrd:aCols[_nI,GdFieldPos("Z04_VALOR",oGDPrd:aHeader)]
		Endif
	Next _nI
	_oValTot:Refresh()
Return(M->Z04_VALOR)

// Copia as informações da última tabela cadastrada para o produto
User Function EST217G
	Local _aArea := GetArea()
	Local _lExec := .T.
	Local _aColsAux := {}
	Local _nOldZ02 := Z02->(Recno())
	
	If Len(_oGDEst:aCols) > 0
		If !Empty(_oGDEst:aCols[1,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)])
			_lExec := .F.
		Endif
	Endif
	
	If _lExec
		// Recupera as informações da última tabela cadastrada para este produto
		If SELECT("QZ02") > 0
			QZ02->(dbCloseArea())
		Endif
		
		BeginSql Alias "QZ02"
			SELECT Z02.*,
				   Z02.R_E_C_N_O_ AS RECNUM
			  FROM %table:Z02% Z02
			 WHERE Z02.Z02_FILIAL = %xFilial:Z02%
			   AND Z02.Z02_PRODUT = %Exp:M->Z02_PRODUT%
			   AND Z02.%NotDel%
			 ORDER BY Z02.Z02_DTALT DESC, Z02.Z02_HORA DESC
		EndSql
		
		If !QZ02->(EOF())
			Z02->(dbGoTo(QZ02->RECNUM))
			
			_aColsAux := A002Cols()
			
			_oGDEst:aCols := aClone(_aColsAux)
			_oGDEst:nAT := 1
			_oGDEst:oBrowse:Refresh()
			
			Z02->(dbGoTo(_nOldZ02))
		Endif
		QZ02->(dbCloseArea())
	Endif
	
	RestArea(_aArea)
Return(M->Z02_PRODUT)

User Function EST217H
	// Verifica se o tipos selecionado é controlado pela estrutura do produto
	dbSelectArea("Z01")
	Z01->(dbSetOrder(1))
	If Z01->(dbSeek(xFilial("Z01")+_oGDEst:aCols[_oGDEst:nAT,GdFieldPos("Z03_CODCOM",_oGDEst:aHeader)]))
		If Z01->Z01_ESTRUT == "S"
			_cMsg := "Este tipo possui o valor controlado pela estrutura do produto. " + CHR(13) + CHR(10)
			_cMsg += "Para alterar o valor, acesse: Ações Relacionadas > Estrutura"
			msgInfo(_cMsg)
			Return(.F.)
		Endif
	Endif
Return(.T.)

User Function EST217R
	Local _oReport
	Private _cPerg := "EST217"
    
	AjustaSX1()
	Pergunte(_cPerg,.F.)
	
	_oReport := A002Def()
	_oReport:PrintDialog()
Return

Static Function A002Def
	Local _oReport
	Local _oSection1
	Local _oSection2
	Local _oSection3
	Local _oSection4
	
	_oReport := TReport():New("EST217","Histórico da Tabela",_cPerg,{|_oReport| A002Print(_oReport)},"Histórico")

	_oSection1 := TRSection():New(_oReport,"Header",{"Z02","SB1","SA1"},,,,,,,,,.T.)
	TRCell():New(_oSection1,"Z02_CODIGO","Z02")
	TRCell():New(_oSection1,"Z02_ALTPED","Z02")
	TRCell():New(_oSection1,"Z02_TPCONT","Z02")
	TRCell():New(_oSection1,"Z02_REVISA","Z02")
	TRCell():New(_oSection1,"Z02_PRODUT","Z02")
	TRCell():New(_oSection1,"B1_DESC","SB1","Descrição","@!",30)
	TRCell():New(_oSection1,"Z02_CLIENT","Z02")
	TRCell():New(_oSection1,"Z02_LOJA","Z02")
	TRCell():New(_oSection1,"A1_NREDUZ","SA1","Nome","@!",30)
	TRCell():New(_oSection1,"Z02_DTINI","Z02")
	TRCell():New(_oSection1,"Z02_DTFIM","Z02")
	TRCell():New(_oSection1,"Z02_VOLUME","Z02")
	TRCell():New(_oSection1,"Z02_SALDO","Z02")
	TRCell():New(_oSection1,"Z02_OBS","Z02")
	TRCell():New(_oSection1,"Z02_USER","Z02")
	TRCell():New(_oSection1,"Z02_DTALT","Z02")
	TRCell():New(_oSection1,"Z02_HORA","Z02")
	TRCell():New(_oSection1,"Z02_IMPOST","Z02")	
	
	_oSection2 := TRSectio0n():New(_oSection1,"Itens","Z03")
	TRCell():New(_oSection2,"Z03_CODCOM","Z03")
	TRCell():New(_oSection2,"DESSIN","   ","Tipo","@!",30)
	TRCell():New(_oSection2,"DESANA","   ","Composição","@!",30)
	TRCell():New(_oSection2,"Z03_VALOR","Z03")
	_oSection2:SetLinesBefore(0)
	
	_oSection3 := TRSection():New(_oSection2,"Estrutura","Z04")
	TRCell():New(_oSection3,"Z04_CODPRO","Z04")
	TRCell():New(_oSection3,"Z04_DESCRI","Z04")
	TRCell():New(_oSection3,"Z04_VALOR","Z04")
	
	TRFunction():New(_oSection2:Cell("Z03_VALOR"),NIL,"SUM",,,,,,.F.)
	_oSection2:SetTotalInLine(.F.)
	_oSection2:SetTotalText(" ")
Return(_oReport)

Static Function A002Print(_oReport)
	Local _oSection1 := _oReport:Section(1)
	Local _oSection2 := _oReport:Section(1):Section(1)
	Local _oSection3 := _oReport:Section(1):Section(1):Section(1)
	Local _cFilRev := "%%"
	
	If MV_PAR01 == 1
		_cFilRev := "%AND Z02.Z02_REVISA = (SELECT MAX(T2.Z02_REVISA) "
		_cFilRev += " FROM " + RetSqlName("Z02") + " T2 "
		_cFilRev += " WHERE T2.Z02_FILIAL = Z02.Z02_FILIAL "
		_cFilRev += "   AND T2.Z02_CODIGO = Z02.Z02_CODIGO "
		_cFilRev += "   AND T2.Z02_ALTPED = Z02.Z02_ALTPED "
		_cFilRev += "   AND T2.Z02_TPCONT = Z02.Z02_TPCONT "
		_cFilRev += "   AND T2.Z02_PRODUT = Z02.Z02_PRODUT "
		_cFilRev += "   AND T2.Z02_CLIENT = Z02.Z02_CLIENT "
		_cFilRev += "   AND T2.Z02_LOJA = Z02.Z02_LOJA "
		_cFilRev += "   AND T2.D_E_L_E_T_ <> '*') %"
	Else
		_cFilRev := "%AND Z02.Z02_REVISA BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'%"
	Endif
	
	If SELECT("QZ02") > 0
		QZ02->(dbCloseArea())
	Endif
	
	BeginSql Alias "QZ02"
		SELECT Z02.Z02_CODIGO,
			   Z02.Z02_ALTPED,
			   Z02.Z02_TPCONT,
			   Z02.Z02_REVISA,
			   Z02.Z02_PRODUT,
			   SB1.B1_DESC,
			   Z02.Z02_CLIENT,
			   Z02.Z02_LOJA,
			   SA1.A1_NREDUZ,
			   Z02.Z02_DTINI,
			   Z02.Z02_DTFIM,
			   Z02.Z02_VOLUME,
			   Z02.Z02_SALDO,
			   Z02.Z02_OBS,
			   Z02.Z02_USER,
			   Z02.Z02_DTALT,
			   Z02.Z02_HORA,
			   Z02.R_E_C_N_O_ AS RECNUM
		  FROM %table:Z02% Z02
		  JOIN %table:SA1% SA1 ON (SA1.A1_FILIAL = %xFilial:SA1%
		  					   AND SA1.A1_COD = Z02.Z02_CLIENT
		  					   AND SA1.A1_LOJA = Z02.Z02_LOJA
		  					   AND SA1.%NotDel%)
		  JOIN %table:SB1% SB1 ON (SB1.B1_FILIAL = %xFilial:SB1%
		  					   AND SB1.B1_COD = Z02.Z02_PRODUT
		  					   AND SB1.%NotDel%)
		 WHERE Z02.Z02_FILIAL = %xFilial:Z02%
		   AND Z02.Z02_CODIGO = %Exp:Z02->Z02_CODIGO%
		   AND Z02.Z02_ALTPED = %Exp:Z02->Z02_ALTPED%
		   AND Z02.Z02_TPCONT = %Exp:Z02->Z02_TPCONT%
		   AND Z02.Z02_PRODUT = %Exp:Z02->Z02_PRODUT%
		   AND Z02.Z02_CLIENT = %Exp:Z02->Z02_CLIENT%
		   AND Z02.Z02_LOJA = %Exp:Z02->Z02_LOJA%
		   AND Z02.%NotDel%
		   %Exp:_cFilRev%
		 ORDER BY Z02.Z02_CODIGO, Z02.Z02_ALTPED, Z02.Z02_TPCONT, Z02.Z02_REVISA
	EndSql
	
	QZ02->(dbGoTop())
	Count To _nRegs
	QZ02->(dbGoTop())
	
	_oReport:SetMeter(_nRegs)
	
	_oSection1:Init()
	While !QZ02->(EOF())
		_oReport:IncMeter()
		
		Z02->(dbGoTo(QZ02->RECNUM))
		
		_oSection1:Cell("Z02_CODIGO"):SetValue(QZ02->Z02_CODIGO)
		_oSection1:Cell("Z02_ALTPED"):SetValue(QZ02->Z02_ALTPED)
		_oSection1:Cell("Z02_TPCONT"):SetValue(QZ02->Z02_TPCONT)
		_oSection1:Cell("Z02_REVISA"):SetValue(QZ02->Z02_REVISA)
		_oSection1:Cell("Z02_PRODUT"):SetValue(QZ02->Z02_PRODUT)
		_oSection1:Cell("B1_DESC"):SetValue(QZ02->B1_DESC)
		_oSection1:Cell("Z02_CLIENT"):SetValue(QZ02->Z02_CLIENT)
		_oSection1:Cell("Z02_LOJA"):SetValue(QZ02->Z02_LOJA)
		_oSection1:Cell("A1_NREDUZ"):SetValue(QZ02->A1_NREDUZ)
		_oSection1:Cell("Z02_DTINI"):SetValue(STOD(QZ02->Z02_DTINI))
		_oSection1:Cell("Z02_DTFIM"):SetValue(STOD(QZ02->Z02_DTFIM))
		_oSection1:Cell("Z02_VOLUME"):SetValue(QZ02->Z02_VOLUME)
		_oSection1:Cell("Z02_SALDO"):SetValue(QZ02->Z02_SALDO)
		_oSection1:Cell("Z02_OBS"):SetValue(Z02->Z02_OBS)
		_oSection1:Cell("Z02_USER"):SetValue(QZ02->Z02_USER)
		_oSection1:Cell("Z02_DTALT"):SetValue(STOD(QZ02->Z02_DTALT))
		_oSection1:Cell("Z02_HORA"):SetValue(QZ02->Z02_HORA)
		_oSection1:PrintLine()
		
		If SELECT("QZ03") > 0
			QZ03->(dbCloseArea())
		Endif
		
		BeginSql Alias "QZ03"
			SELECT Z03.Z03_CODCOM,
				   Z03.Z03_VALOR
			  FROM %table:Z03% Z03
			 WHERE Z03.Z03_FILIAL = %xFilial:Z03%
			   AND Z03.Z03_CODIGO = %Exp:QZ02->Z02_CODIGO%
			   AND Z03.Z03_TPCONT = %Exp:QZ02->Z02_TPCONT%
			   AND Z03.Z03_REVISA = %Exp:QZ02->Z02_REVISA%
			   AND Z03.Z03_PRODUT = %Exp:QZ02->Z02_PRODUT%
			   AND Z03.Z03_CLIENT = %Exp:QZ02->Z02_CLIENT%
			   AND Z03.Z03_LOJA = %Exp:QZ02->Z02_LOJA%
			   AND Z03.Z03_ALTPED = %Exp:QZ02->Z02_ALTPED%
			   AND Z03.%NotDel%
		EndSql
		
		_oSection2:Init()
		While !QZ03->(EOF())
			_oSection2:Cell("Z03_CODCOM"):SetValue(QZ03->Z03_CODCOM)
			_oSection2:Cell("DESSIN"):SetValue(Posicione("Z01",1,xFilial("Z01")+Substr(QZ03->Z03_CODCOM,1,3),"Z01_DESCRI"))
			_oSection2:Cell("DESANA"):SetValue(Posicione("Z01",1,xFilial("Z01")+QZ03->Z03_CODCOM,"Z01_DESCRI"))
			_oSection2:Cell("Z03_VALOR"):SetValue(QZ03->Z03_VALOR)
			_oSection2:PrintLine()
			
			If SELECT("QZ04") > 0
				QZ04->(dbCloseArea())
			Endif
			
			BeginSql Alias "QZ04"
				SELECT Z04.Z04_CODPRO,
					   Z04.Z04_DESCRI,
					   Z04.Z04_VALOR
				  FROM %table:Z04% Z04
				 WHERE Z04.Z04_FILIAL = %xFilial:Z04%
				   AND Z04.Z04_CODIGO = %Exp:QZ02->Z02_CODIGO%
				   AND Z04.Z04_REVISA = %Exp:QZ02->Z02_REVISA%
				   AND Z04.Z04_TPCONT = %Exp:QZ02->Z02_TPCONT%
				   AND Z04.Z04_PRODUT = %Exp:QZ02->Z02_PRODUT%
				   AND Z04.Z04_CLIENT = %Exp:QZ02->Z02_CLIENT%
				   AND Z04.Z04_LOJA = %Exp:QZ02->Z02_LOJA%
				   AND Z04.Z04_CODCOM = %Exp:QZ03->Z03_CODCOM%
				   AND Z04.Z04_ALTPED = %Exp:QZ02->Z02_ALTPED%
				   AND Z04.%NotDel%
			EndSql
			
			If !QZ04->(EOF())
				_oSection3:Init()
				
				While !QZ04->(EOF())
					_oSection3:Cell("Z04_CODPRO"):SetValue(QZ04->Z04_CODPRO)
					_oSection3:Cell("Z04_DESCRI"):SetValue(QZ04->Z04_DESCRI)
					_oSection3:Cell("Z04_VALOR"):SetValue(QZ04->Z04_VALOR)
					_oSection3:PrintLine()
			
					QZ04->(dbSkip())
				Enddo
				_oSection3:Finish()
				
				QZ04->(dbCloseArea())
			Endif

			QZ03->(dbSkip())
		Enddo
		_oSection2:Finish()
		QZ03->(dbSkip())
		
		QZ02->(dbSkip())
	Enddo
	_oSection1:Finish()
	QZ02->(dbCloseArea())
Return

/*
+-------------------------------------------------------------------------+
! Função    ! AjustaSX1 ! Autor ! Cleverson Funaki   ! Data !  20/01/12   !
+-----------+-----------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                         !
+-----------+-------------------------------------------------------------+
! Descricao ! Ajusta as perguntas do SX1.                                 !
+-----------+-------------------------------------------------------------+
*/
Static Function AjustaSx1
	PutSx1(_cPerg,"01","Última Revisão?","Última Revisão?","Última Revisão?","mv_ch1","N",1,0,1,"C","","","","","mv_par01","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","",{"Indica se imprime somente a","última revisão. Se selecionado 'Sim',","os parâmetros abaixo serão ignorados",""},{"Indica se imprime somente a","última revisão. Se selecionado 'Sim',","os parâmetros abaixo serão ignorados",""},{"Indica se imprime somente a","última revisão. Se selecionado 'Sim',","os parâmetros abaixo serão ignorados"},"")
	PutSx1(_cPerg,"02","Revisão De?","Revisão De?","Revisão De?","mv_ch2","C",3,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{"Revisão inicial para impressão.","","",""},{"Revisão inicial para impressão.","","",""},{"Revisão inicial para impressão.","",""},"")
	PutSx1(_cPerg,"03","Revisão Até?","Revisão Até?","Revisão Até?","mv_ch3","C",3,0,0,"G","","","","","mv_par03","","","","ZZZ","","","","","","","","","","","","",{"Revisão final para impressão.","","",""},{"Revisão final para impressão.","","",""},{"Revisão final para impressão.","",""},"")
Return