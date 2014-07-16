/**********************************************************************************************************************************/
/** Compras                                                                                                                      **/
/** ponto de entrada sera utilizado para alterar a query da rotina Solicitacao por Ponto de Pedido.                              **/
/** RSAC Soluções                                                                                                                **/
/** Data: 15/07/2013                                                                                                             **/
/** WHB FUNDICAO SA                                                                                                              **/
/**********************************************************************************************************************************/
/** Data       | Responsável                    | Descrição                                                                      **/
/**********************************************************************************************************************************/
/** 15/07/2013 | Esteferson Moura               | Criação da rotina/procedimento.                                                **/
/**********************************************************************************************************************************/
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/**********************************************************************************************************************************/
/** user function MT170QRY                                                                                                       **/
/** alterar a query original da rotina MATA170, para considerar a tabela customizada produto x almoxarifado.                     **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
user function MT170QRY
	
	// grava area
	local aArea   := GetArea()
	
	// query atual
	private cNewQry   := ParamIXB[1]
	// posicao linha
	private nLin      := 0
	// posicao coluna
	private nCol      := 0
	// array listbox
	private aLbxPROD  := {}
	// flag de gravacao
	private lGrvDados := .T.
	
	// produtos em ponto
	public aProdPP    := {}
	
	
	// processa os dados
	ProcDados()
	
	// itens em ponto de pedido
	if Len(aLbxPROD) > 0
		// restaura dimensoes
		TamTela()
		
		// produtos em ponto
		aProdPP := {}
		
		// listbox de produtos
		TelaProd()
		
		// atualiza query
		AtuQuery()
		
	else
		// mostra mensagem
		MsgAlert("Não existem produtos em Ponto de Pedido!")
		// variavel auxiliar
		cNewQry += " and SB1.B1_COD = ''
		
	endIf
	
	// restaura area
	RestArea(aArea)
	
return( cNewQry )

/**********************************************************************************************************************************/
/** static function ProcDados                                                                                                    **/
/** faz o processamento dos dadosdutos em Ponto de Pedido.                                                                       **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function ProcDados
	
	// numero de registros
	local nRegs     := 0
	// prazo
	local nPrazo    := 0
	// quantidade
	local nQuant    := 0
	// saldo
	local nSaldo    := 0
	//ent. prevista
	Local nEntPrev 	:= 0
	// necessidade
	local nNeces    := 0
	// estoque segurança
	local nEstSeg   := 0
	// quantidade auxiliar
	local nAuxQuant := 0
	// saldo
	local nSavSaldo := 0
	// saldo maximo
	local nSaldoMax := 0
	// saldo auxiliar
	local nSaldAux  := 0
	
		
	// array listbox
	aLbxPROD := {}
	
	// restaura produtos
	QrySB1()
	
	// inicio query
	QSB1->(DbGoTop())
	// numero de registros
	QSB1->(DbEval({|| nRegs++ }))
	// inicio query
	QSB1->(DbGoTop())
	
	// numero de registros da regua
	ProcRegua(nRegs)
	
	// faz o loop
	while !QSB1->( Eof() )
		
		// incrementa barra de processo
		IncProc()
		
		// seta ordem
		SG1->(dbSetOrder(1))
		// posiciona na estrutura
		If SG1->(dbSeek(xFilial("SG1")+QSB1->B1_COD))
			// proximo registro
			QSB1->(DbSkip())
			Loop
			
		endIf
		
		// Filtra se produto e sub-produto e deve ser alimentado via producao
		If FindFunction("IsNegEstr") .And. IsNegEstr(QSB1->B1_COD)[1]
			// proximo registro
			QSB1->(DbSkip())
			Loop
			
		endIf
		
		
		// Calcula o saldo atual do almoxarifados
		// seta ordem
		SB2->(DbSetOrder(1))
		// posiciona no almoxarifado
		if SB2->(DbSeek( xFilial("SB2") + QSB1->B1_COD + QSB1->B1_LOCPAD ))
			
			// calcula saldo do produto no almoxarifado
			nSaldo += SaldoSB2( Nil, Nil, If(Empty(mv_par11), dDataBase, mv_par11), mv_par12==1, mv_par13==1)
			// saldo pedido
			//nSaldo += SB2->B2_SALPEDI
			nEntPrev+= SB2->B2_SALPEDI
			// saldo a classificar
			nSaldo += SB2->B2_QACLASS
			
			// desconsidera quantidade em pedido de venda
			If mv_par14 == 1
				// subtrai quantidade
				nSaldo -= SB2->B2_QPEDVEN
				
			endIf
		
		endIf
		
		// estoque maximo do produto
		nSaldoMax := RetFldProd(QSB1->B1_COD,"B1_EMAX","QSB1")//A711Sb1EstMax(QSB1->B1_COD)
		// guarda o saldo
		nSavSaldo := nSaldo
		
		// desconsidera estoque de seguranca
		If mv_par20 == 1
			// recupera o estoque de seguranca
			nEstSeg := CalcEstSeg(RetFldProd(QSB1->B1_COD,"B1_ESTFOR", "QSB1"), "QSB1" )
			// subtrai estoque seguranca
			nSaldo  -= nEstSeg
			
		EndIf
		
		
		// saldo valido ou considera necessidade bruta
		If (Round(nSaldo,4) # 0) .Or. (mv_par09 == 1)
		
			Do Case
				Case ( RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1") != 0 .And. MV_PAR09 == 1 )
					If ( MV_PAR10 == 2 .And. nSaldo < 0 )
						// subtrai lote economico
						nSaldo -= RetFldProd(QSB1->B1_COD,"B1_LE","QSB1")
						
					EndIf
					
					// calcula necessidade do produto
					nNeces := If((nSaldo < 0),Abs(nSaldo)+RetFldProd(QSB1->B1_COD,"B1_EMAX","QSB1"),;
										If(QtdComp(nSaldo) <=  QtdComp( RetFldProd( QSB1->B1_COD,"B1_EMIN","QSB1")) ,  RetFldProd(QSB1->B1_COD,"B1_EMAX","QSB1")  -  QtdComp( RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1"))+( RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1") -nSaldo)      ,0))

					//-- Soma 1 na quantidade da necessidade.
					If nSaldo < QtdComp(RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1")) //-- Se o Saldo for menor que o Ponto do Pedido
						nNeces += 1
						
					EndIf
							
				Case ( RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1") != 0 .And. MV_PAR09 == 2 )
					If ( MV_PAR10 == 2 .And. nSaldo < 0 )
						// subtrai lote economico
						nSaldo -= RetFldProd(QSB1->B1_COD,"B1_LE","QSB1")
					
					EndIf
					
					// calcula necessidade do produto
					nNeces := If((nSaldo < 0),Abs(nSaldo),;
										(If(QtdComp(nSaldo) ==  QtdComp(  RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1")  ),1,0);
										+RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1")-nSaldo))
							
					//-- Soma 1 na quantidade da necessidade.
					If nSaldo < QtdComp(RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1")) //-- Se o Saldo for menor que o Ponto do Pedido
						nNeces += 1
					
					EndIf
					
				Case ( RetFldProd(QSB1->B1_COD,"B1_LE","QSB1") != 0 .And. (nSaldo < 0  .or. mv_par09 == 2) )
					If ( MV_PAR10 == 2 .And. nSaldo < 0 )
						// calcula necessidade
						nNeces := Abs(nSaldo)+RetFldProd(QSB1->B1_COD,"B1_LE","QSB1")
						
					Else
						// calcula necessidade
						nNeces := If( Abs(nSaldo)<RetFldProd(QSB1->B1_COD,"B1_LE","QSB1"),RetFldProd(QSB1->B1_COD,"B1_LE","QSB1"),if(nSaldo<0,Abs(nSaldo),0))
						
					EndIf
				
				OtherWise
					// calcula necessidade
					nNeces := IF(MV_PAR09 == 1,IIf(nSaldo<0,Abs(nSaldo)+1,0),0)
					
			EndCase
		
		Else
			If RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1") != 0
				// calcula necessidade
				nNeces := RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1")
				// soma um
				nNeces += 1
				
			Else
				// zera necessidade
				nNeces := 0
				
			Endif
		EndIf
		
		If nSaldoMax # 0 .And. mv_par14 == 2
			nNeces := Min(nSaldoMax - nSaldo,nNeces)
		
		Endif
		
		If nNeces > 0  .AND.  nNeces > nEntPrev .AND. nEntPrev < RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1")
			// separa por lote economico
			aQtdes := CalcLote(QSB1->B1_COD,nNeces,"C")
			
			// Soma a quantidade total a ser gerada
			nQuant := 0
			
			// loop sobre as quantidades
			For nx:=1 to Len(aQtdes)
				nQuant+=aQtdes[nx]
				
			Next nx
			
			// Ajusta o array para nao efetuar quebra
			If mv_par15 ==2
				aQtdes := {nQuant}
				
			EndIf
		
		Else
			aQtdes:={}
		
		EndIf
		
		
		// quantidade valida
		If nQuant > 0
			
			// ultimo preco de venda
			nUltPrc := 0
			nUltPrc := QrySD1( QSB1->B1_COD )
				// produtos em ponto
				IF QSB1->B1_LOCPAD>=MV_PAR16 .AND. QSB1->B1_LOCPAD<=MV_PAR17
					aAdd( aLbxPROD, { ""                     ,; // marcador
														cFilAnt                ,; // filial
														AllTrim(QSB1->B1_COD)  ,; // produto
														AllTrim(QSB1->B1_DESC) ,; // descricao
														QSB1->B1_TIPO          ,; // tipo
														QSB1->B1_GRUPO         ,; // grupo
														QSB1->B1_UM            ,; // unidade medida
														nSaldo                 ,; // saldo atual
														QSB1->B1_EMIN          ,; // estoque minimo
														QSB1->B1_ESTSEG        ,; // estoque seguranca
														QSB1->B1_EMAX          ,; // estoque maximo
														QSB1->B1_LE            ,; // lote economico
														nQuant-nEntPrev        ,; // quantidade a comprar
														QSB1->B1_LOCPAD        ,; // almoxarifado
														nUltPrc                ; // ultimo preco compra														
													} )    
					EndIF
				EndIF
		
		// zera variaveis
		nSaldo := 0
		nQuant := 0  
		nNeces := 0
		nEntPrev:= 0
		// proximo registro
		QSB1->(DbSkip())
		
	endDo
	
	// fecha query
	QSB1->(DbCloseArea())
	
	
return

/**********************************************************************************************************************************/
/** static function TelaProd                                                                                                     **/
/** monta tela para listar os produtos em Ponto de Pedido.                                                                       **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function TelaProd
	
	// botoes
	local aButton := {}
	// bitmap Ok
  local oOk     := LoadBitmap( GetResources(), "LBOK" )     
  // bitmap no
  local oNo     := LoadBitmap( GetResources(), "LBNO" )
  
  // tela produtos
	private oDlgProd
	// objeto tela
	private oDlgPesq
	// objeto tela
	private oDlgQtd
  
	
	// define a tela de dialogo
	Define MsDialog oDlgProd from (nLin*000), (nCol*000) to (nLin*475), (nCol*1100) title "[ Produtos em Ponto de Pedido ]" pixel
		
		// maxima a tela
		oDlgProd:lMaximized := .T.
		
		/* inicio alteracao P11 */
		// box fornecedor
		@ (nLin*002), (nCol*002) to (nLin*275), (nCol*666) title ""
		
		// define o listbox
		@ (nLin*004), (nCol*004) ListBox oLbxPROD Fields header "", "Filial", "Produto", "Desc.", "UM", "Tipo", "Grupo", "Almoxarifado", "Saldo Atual", "P.Pedido", "Est.Seg.", "Est. Maximo", "Lote Eco.", "Qtd Comprar", "Ult. Preco" size (nCol*660), (nLin*269) colsizes 20,20,70,150,20,40,40,40,50,50,50,50,50,50,50,50 of oDlgProd pixel
		
		// monta os dados do listbox
		oLbxPROD:SetArray(aLbxPROD)
		oLbxPROD:bLine := {|| { Iif(aLbxPROD[oLbxPROD:nAt][1] == "S", oOk, oNo)      ,; // status
												 	 aLbxPROD[oLbxPROD:nAt][2]                             ,; // filial
												 	 aLbxPROD[oLbxPROD:nAt][3]                             ,; // produto
												 	 aLbxPROD[oLbxPROD:nAt][4]                             ,; // descricao
												 	 aLbxPROD[oLbxPROD:nAt][7]                             ,; // unidade medida
												 	 aLbxPROD[oLbxPROD:nAt][5]                             ,; // tipo
												 	 aLbxPROD[oLbxPROD:nAt][6]                             ,; // grupo
												 	 aLbxPROD[oLbxPROD:nAt][14]                            ,; // almoxarifado
												 	 Transform(aLbxPROD[oLbxPROD:nAt][8], "@E 999999.99")  ,; // saldo atual
												 	 Transform(aLbxPROD[oLbxPROD:nAt][9], "@E 999999.99")  ,; // ponto pedido
												 	 Transform(aLbxPROD[oLbxPROD:nAt][10], "@E 999999.99") ,; // estoque seguranca
										   		 Transform(aLbxPROD[oLbxPROD:nAt][11], "@E 999999.99") ,; // estoque maximo
										   		 Transform(aLbxPROD[oLbxPROD:nAt][12], "@E 999999.99") ,; // lote economico
										   		 Transform(aLbxPROD[oLbxPROD:nAt][13], "@E 999999.99") ,; // quantidade compra
										   		 Transform(aLbxPROD[oLbxPROD:nAt][15], "@E 999,999.99") ; // ultimo preco de compra
												}																                          ;
	                    }
		
		// mostra help ao usuario
		oLbxPROD:cToolTip     := "Dê um duplo clique ou pressione a tecla <Enter> para selecionar o produto"
		// marca/desmarca todos itens
		oLbxPROD:bHeaderClick := {|| MarkAll() }
		// duplo clique
		oLbxPROD:bLDblClick   := {|| MarkItem() }
		// atualiza listbox
		oLbxPROD:refresh()
		
		
		// adiciona botoes
		aAdd( aButton, { "PESQUISA", {|| PesqProd() }, "Pesquisar [F2]"})
		aAdd( aButton, { "NOTE", {|| AltQuant() }, "Quantidade [F5]"})
		
		// cria atalhos
		SetKey( VK_F2, {|| Iif(ValType(oDlgPesq) != "O", PesqProd(), Nil) } )
		SetKey( VK_F5, {|| Iif(ValType(oDlgQtd) != "O", AltQuant(), Nil) } )
		
	// ativa a tela
	Activate MsDialog oDlgProd Centered On Init EnchoiceBar( oDlgProd, {|| GrvDados() }, {|| oDlgProd:End() },, aButton)
	
	// zera atalhos
	SetKey( VK_F2, {|| } )
	SetKey( VK_F5, {|| } )
	
return

/**********************************************************************************************************************************/
/** static function GrvDados                                                                                                    **/
/** processa os dados do array.                                                                                                  **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function GrvDados
	
	// flag processamento
  local lProc := .F.
	
	
	// loop sobre produtos
	for nX := 1 to Len(aLbxPROD)
		
		// produto marcado
		if aLbxPROD[nX][1] == "S"
			// atualiza flag
			lProc := .T.
			
			// produtos em ponto
			aAdd( aProdPP, { aLbxPROD[nX][3]  ,; // produto
											 aLbxPROD[nX][14] ,; // almoxarifado
											 aLbxPROD[nX][13] }) // quantidade a comprar
			
		endIf
		
	next nX
		
	// nenhum produto selecionado
	if !lProc
		// mostra mensagem
		MsgAlert("Nenhum produto foi selecionado, favor verificar!")
		
	else
		// fecha a tela
		oDlgProd:End()
		
	endIf
	
return

/**********************************************************************************************************************************/
/** static function AtuQuery                                                                                                     **/
/** atualiza a query de retorno, adicionando os produtos e almoxarifados selecionados.                                           **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function AtuQuery
	
	// produtos
  local cProdPP := ""
  // almoxarifado
  local cAlmoPP := ""
	
	
	// loop sobre produtos
	for nX := 1 to Len(aProdPP)
		// produto nao adicionado
		if !AllTrim(aProdPP[nX][1]) $ cProdPP
			// adiciona produto
			cProdPP += Iif(Empty(cProdPP), "'"+ AllTrim(aProdPP[nX][1]) +"'", ",'"+ AllTrim(aProdPP[nX][1]) +"'")
			
		endIf
		
		// almoxarifado nao adicionado
		if !AllTrim(aProdPP[nX][2]) $ cAlmoPP
			// adiciona almoxarifado
			cAlmoPP += Iif(Empty(cAlmoPP), "'"+ AllTrim(aProdPP[nX][2]) +"'", ",'"+ AllTrim(aProdPP[nX][2]) +"'")
			
		endIf
		
	next nX
	
	// produtos em ponto de pedido
	if Empty(cProdPP)
		// produtos
		cProdPP := "''"
		// almoxarifados
		cAlmoPP := "''"
		
	endIf
	
	// incrementa query
	cNewQry += " and Z05.Z05_COD in ("+ cProdPP +")
	cNewQry += " and Z05.Z05_LOCAL in ("+ cAlmoPP +")
	
return

/**********************************************************************************************************************************/
/** static function PesqProd                                                                                                     **/
/** monta tela de pesquisa de produtos.                                                                                          **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function PesqProd
	
	// ordem da grid
	private cOrd   := ''
	// itens do combobox
	private aItems := { 'Produto', 'Descrição' }
	// campo de busca
	private cTxt   := space(35)
	
		
	// define tela
	Define MsDialog oDlgPesq Title "Pesquisar" from (nLin*000), (nCol*000) TO (nLin*90), (nCol*240) pixel
		
		// divisao
		@ (nLin*002), (nCol*002) To (nLin*032),(nCol*121) Label "" Of oDlgPesq Pixel
		
		// opcoes de busca
		@ (nLin*007),(nCol*005) combobox oCombo var cOrd items aItems size (nCol*114),(nLin*010) Of oDlgPesq pixel
		// seta primeira opcao
		oCombo:nAt := 1
		
		// texto a ser localizado
		@ (nLin*018),(nCol*005) MsGet oTxt var cTxt Picture "@!" size (nCol*114),(nLin*08) Of oDlgPesq pixel
		// seta o focu
		oTxt:setfocus()
		
		// botao buscar
		@ (nLin*034),(nCol*060) Button "Pesquisar" size (nCol*30),(nLin*08) Action SeekItem() Of oDlgPesq pixel
		// botao buscar
		@ (nLin*034),(nCol*091) Button "Fechar" size (nCol*30),(nLin*08) Action oDlgPesq:End() Of oDlgPesq pixel
		
	// ativa tela
	Activate MsDialog oDlgPesq Centered
	
return

/**********************************************************************************************************************************/
/** static function AltQuant                                                                                                     **/
/** monta tela para alterar a quantidade a ser comprada.                                                                         **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function AltQuant
	
	// flag gravacao
	local lGrv := .F.
	
	// nova quantidade
	private nNewQtd := aLbxPROD[oLbxPROD:nAt][13]
	
		
	// define tela
	Define MsDialog oDlgQtd Title "Altera Quantidade" from (nLin*000), (nCol*000) TO (nLin*135), (nCol*270) pixel
		
		// divisao
		@ (nLin*002), (nCol*002) To (nLin*055),(nCol*136) Label "" Of oDlgQtd Pixel
		
		// codigo produto
		@ (nLin*009),(nCol*004) Say "Produto" size (nCol*50),(nLin*08) Of oDlgQtd pixel
		@ (nLin*007),(nCol*032) MsGet aLbxPROD[oLbxPROD:nAt][3] size (nCol*50),(nLin*08) When .F. Of oDlgQtd pixel
		
		// descricao
		@ (nLin*019),(nCol*004) Say "Descrição" size (nCol*50),(nLin*08) Of oDlgQtd pixel
		@ (nLin*017),(nCol*032) MsGet aLbxPROD[oLbxPROD:nAt][4] size (nCol*100),(nLin*08) When .F. Of oDlgQtd pixel
		
		// quantidade atual
		@ (nLin*029),(nCol*004) Say "Qtd. Atual" size (nCol*50),(nLin*08) Of oDlgQtd pixel
		@ (nLin*027),(nCol*032) MsGet aLbxPROD[oLbxPROD:nAt][13] size (nCol*50),(nLin*08) Picture "@E 999999.99" When .F. Of oDlgQtd pixel
		
		// quantidade nova
		@ (nLin*039),(nCol*004) Say "Qtd. Compra" size (nCol*50),(nLin*08) Of oDlgQtd pixel
		@ (nLin*037),(nCol*032) MsGet nNewQtd size (nCol*50),(nLin*08) Picture "@E 999999.99" Of oDlgQtd pixel
		
		
		// botao buscar
		@ (nLin*057),(nCol*075) Button "Confirmar" size (nCol*30),(nLin*08) Action (lGrv := .T., oDlgQtd:End()) Of oDlgQtd pixel
		// botao buscar
		@ (nLin*057),(nCol*106) Button "Fechar" size (nCol*30),(nLin*08) Action oDlgQtd:End() Of oDlgQtd pixel
		
	// ativa tela
	Activate MsDialog oDlgQtd Centered
	
	
	// grava a quantidade
	if lGrv
		// quantido nao informada
		if nNewQtd > 0
			// quantidade valida
			if nNewQtd >= aLbxPROD[oLbxPROD:nAt][9] .and. nNewQtd <= aLbxPROD[oLbxPROD:nAt][11]
				// atualiza a quantidade
				aLbxPROD[oLbxPROD:nAt][13] := nNewQtd
				// atualiza listbox
				oLbxPROD:refresh()
			
			// quantidade superior ao estoque maximo
			elseIf nNewQtd > aLbxPROD[oLbxPROD:nAt][11]
				// mostra mensagem
				MsgAlert("Quantidade informada é superior ao estoque máximo, favor verificar!")
				
			// quantidade inferior ao estoque minimo
			elseIf nNewQtd < aLbxPROD[oLbxPROD:nAt][9]
				// mostra mensagem
				MsgAlert("Quantidade informada é inferior ao estoque minimo, favor verificar!")
				
			endIf
			
		else
			// mostra mensagem
			MsgAlert("Deverá ser informada uma quantidade maior que zero, favor verificar!")
			
		endIf
		
	endIf
	
	
return

/**********************************************************************************************************************************/
/** static function SeekItem                                                                                                     **/
/** posiciona no item pesquisado.                                                                                                **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function SeekItem
	
	// coluna selecionada
	local nColSel := 0
	// linha localizada
	local nLinLoc := 0
	
	
	// verifica se foi informado dados pra busca
	if !Empty( AllTrim( cTxt ))
		
		// opcao produto
		if cOrd == aItems[1]
			// atualiza coluna
			nColSel := 3
			
			// opcao desricao
			elseIf cOrd == aItems[2]
				// atualiza coluna
				nColSel := 4
			
		endIf
		
		
		// procura o texto informado
		for nI := 1 to Len(aLbxPROD)
			// procura na coluna selecionada
			if AllTrim(Upper(cTxt)) == SubStr(AllTrim(Upper(aLbxPROD[nI][nColSel])), 1, Len(AllTrim(cTxt)))
				// linha localizada
				nLinLoc := nI
				// sai do loop
				exit
				
			endIf
			
		next nI
		
		// informacao localizada
		if nLinLoc > 0
			// seta primeira opcao
			oLbxPROD:nAt := nLinLoc
			
			else
				// mostra mensagem
				MsgAlert( "Produto não localizado!" )
				
		endIf
		
		// atualiza listbox
		oLbxPROD:refresh()
		
		// fecha tela
		oDlgPesq:End()
		
	endIf
	
return

/**********************************************************************************************************************************/
/** static function MarkAll                                                                                                      **/
/** seleciona todos os itens do array.                                                                                           **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function MarkAll
	
	// flag marcador
	local cMark := "S"
	// contador
	local nX    := 0
	
	
	// item valido
	if !Empty(aLbxPROD[1][2])
		
		// faz o loop
		for nX := 1 to len(aLbxPROD)
			
			// verifica se esta marcado
			if aLbxPROD[nX][1] == "S"
				// desmarca os refugos
				cMark := "N"
				// sai do loop
				exit
					
			endIf
			
		next nX
		
		// faz o loop
		for nX := 1 to len(aLbxPROD)
			
			// seleciona o titulo
			aLbxPROD[nX][1] := cMark
			
		next nX
		
		// atualiza listbox
		oLbxPROD:refresh()
		
	endIf
	
return

/**********************************************************************************************************************************/
/** static function MarkItem                                                                                                     **/
/** faz a selecao do item posicionado.                                                                                           **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function MarkItem
	
	
	// item valido
	if !Empty(aLbxPROD[1][2])
		
		// seleciona o titulo
		aLbxPROD[oLbxPROD:nAt][1] := Iif(aLbxPROD[oLbxPROD:nAt][1] == "S", "N", "S")
		
		// atualiza listbox
		oLbxPROD:refresh()
		
	endIf
	
return

/**********************************************************************************************************************************/
/** static function TamTela                                                                                                      **/
/** define a dimensao da tela para auto-redimensionar os objetos.                                                                **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function TamTela
	
	// controle de dimensao
	local aSize			:= {}
	local aObjects	:= {}
	local aInfo			:= {}
	local aPosObj		:= {}
  
  
  // obtem tamanho da area de trabalho
	aSize := MsAdvSize()
	
	// cria divisao da tela
	AAdd( aObjects, { 100,25,.T.,.T. } )
	AAdd( aObjects, { 100,75,.T.,.T. } )
	
	// recebe tamanho da tela
	aInfo   := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
	// recebe tamanho dos objetos
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
	// posicao linha
	nLin := (aPosObj[2,3])/277
	// posicao coluna
	nCol := (aPosObj[2,4])/666
	
return

/**********************************************************************************************************************************/
/** static function QrySB1                                                                                                       **/
/** restaura os produtos a serem tratados em ponto de pedido.                                                                    **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function QrySB1
	
	// grava area
	local aArea := GetArea()
	// query
	local cQry  := ""
	
	
	// monta query
	cQry += " select Z05.Z05_LOCAL B1_LOCPAD,
	cQry += "        Z05_ESTSEG B1_ESTSEG,
	cQry += "        Z05_LE B1_LE,
	cQry += "        Z05_QE B1_QE,
	cQry += "        Z05_EMIN B1_EMIN,
	cQry += "        Z05_PE B1_PE,
	cQry += "        Z05_EMAX B1_EMAX,
	cQry += "        Z05_ESTFOR B1_ESTFOR,
	cQry += "        SB1.*,
	cQry += "        SB1.R_E_C_N_O_ SB1RECNO	
	cQry += "   from "+ RetSqlName("Z05") +" Z05
	
	cQry += "  inner join "+ RetSqlName("SB1") +" SB1
	cQry += "     on SB1.D_E_L_E_T_ = ''
	cQry += "    and SB1.B1_FILIAL = '"+ xFilial("SB1") +"'
	cQry += "    and SB1.B1_COD = Z05.Z05_COD
	cQry += "    and SB1.B1_CONTRAT != 'S'
	cQry += "    and SB1.B1_TIPO != 'BN'
	cQry += "    and SB1.B1_COD NOT LIKE 'MOD%'
	cQry += "    and SB1.B1_MSBLQL != '1'
	cQry += "    and SB1.B1_GRUPO between '"+ mv_par03 +"' and '"+ mv_par04 +"'
	cQry += "    and SB1.B1_TIPO between '"+ mv_par05 +"' and '"+ mv_par06 +"'
	
	cQry += "  inner join "+ RetSqlName("Z06") +" Z06
	cQry += "     on Z06.D_E_L_E_T_ = ''
	cQry += "    and Z06.Z06_FILIAL = '"+ xFilial("Z06") +"'
	cQry += "    and Z06.Z06_LOCAL = Z05.Z05_LOCAL
	cQry += "    and (Z06.Z06_USER = '"+ RetCodUsr() +"' or Z06.Z06_USRSUP = '"+ RetCodUsr() +"')
	
	cQry += "  where Z05.D_E_L_E_T_ = ''
	cQry += "    and Z05.Z05_FILIAL = '"+ xFilial("Z05") +"'
	cQry += "    and Z05.Z05_COD between '"+ mv_par01 +"' and '"+ mv_par02 +"'
	cQry += "    and Z05.Z05_LOCAL between '"+ mv_par07 +"' and '"+ mv_par08 +"'
	
	// atualiza variavel de retorno
	cNewQry := cQry
	
	// Adicionado em 15/01/14 - DOUGLASSD
	MemoWrit('C:\TEMP\MT170QRY.SQL',cQry)
	
	
	cQry += "  order by SB1.B1_COD "
	 IF SELECT('QSB1')<>0
	 	QSB1->(DBcLOSEAREA())
	 EndIF
	TcQuery cQry New Alias "QSB1"
	// restaura area
	RestArea(aArea)
	
return

/**********************************************************************************************************************************/
/** static function QrySD1                                                                                                       **/
/** retaura o ultimo preco de compra do produto.                                                                                 **/
/**********************************************************************************************************************************/
/** Parâmetro  | Tipo | Tamanho | Descrição                                                                                      **/
/**********************************************************************************************************************************/
/** Nenhum parametro esperado neste procedimento                                                                                 **/
/**********************************************************************************************************************************/
static function QrySD1( xProd )
	
	// grava area
	local aArea := GetArea()
	// query
	local cQry  := ""
	// retorno
	local nRet  := 0
	
	
	// monta query
	cQry += " select top 1
	cQry += "        SD1.D1_VUNIT
	cQry += "   from "+ RetSqlName("SD1") +" SD1
	
	cQry += "  inner join "+ RetSqlName("SF4") +" SF4
	cQry += "     on SF4.D_E_L_E_T_ = ''
	cQry += "    and SF4.F4_FILIAL = '"+ xFilial("SF4") +"'
	cQry += "    and SF4.F4_CODIGO = SD1.D1_TES
	cQry += "    and SF4.F4_DUPLIC = 'S'
	
	cQry += "  where SD1.D_E_L_E_T_ = ''
	cQry += "    and SD1.D1_FILIAL = '"+ xFilial("SF4") +"'
	cQry += "    and SD1.D1_COD = '"+ xProd +"'
	cQry += "  order by SD1.R_E_C_N_O_ desc
	
	TcQuery cQry New Alias "QSD1"
	// restaura area
	RestArea(aArea)
	
	
	// inicio query
	QSD1->(DbGoTop())
	
	// atualiza o retorno
	nRet := QSD1->D1_VUNIT
	
	// fecha query
	QSD1->(DbCloseArea())
	
return( nRet )



User Function MR440QTD 

	local cQry  := ""
	local nNeces:= 0
	// monta query
	cQry += " select Z05.Z05_LOCAL B1_LOCPAD,
	cQry += "        Z05_ESTSEG B1_ESTSEG,
	cQry += "        Z05_LE B1_LE,
	cQry += "        Z05_QE B1_QE,
	cQry += "        Z05_EMIN B1_EMIN,                 
	cQry += "        Z05_PE B1_PE,
	cQry += "        Z05_EMAX B1_EMAX,
	cQry += "        Z05_ESTFOR B1_ESTFOR,
	cQry += "        SB1.*,
	cQry += "        SB1.R_E_C_N_O_ SB1RECNO	
	cQry += "   from "+ RetSqlName("Z05") +" Z05
	
	cQry += "  inner join "+ RetSqlName("SB1") +" SB1
	cQry += "     on SB1.D_E_L_E_T_ = ''
	cQry += "    and SB1.B1_FILIAL = '"+ xFilial("SB1") +"'
	cQry += "    and SB1.B1_COD = Z05.Z05_COD
	cQry += "    and SB1.B1_CONTRAT != 'S'
	cQry += "    and SB1.B1_TIPO != 'BN'
	cQry += "    and SB1.B1_COD NOT LIKE 'MOD%'
	cQry += "    and SB1.B1_MSBLQL != '1'
	cQry += "    and SB1.B1_GRUPO ='"+ SB1->B1_GRUPO+"' "
	cQry += "    and SB1.B1_TIPO = '"+SB1->B1_TIPO+"' "
	cQry += "  inner join "+ RetSqlName("Z06") +" Z06
	cQry += "     on Z06.D_E_L_E_T_ = ''
	cQry += "    and Z06.Z06_FILIAL = '"+ xFilial("Z06") +"'
	cQry += "    and Z06.Z06_LOCAL = Z05.Z05_LOCAL
	cQry += "    and (Z06.Z06_USER = '"+ RetCodUsr() +"' or Z06.Z06_USRSUP = '"+ RetCodUsr() +"')
	
	cQry += "  where Z05.D_E_L_E_T_ = ''
	cQry += "    and Z05.Z05_FILIAL = '"+ xFilial("Z05") +"'
	cQry += "    and Z05.Z05_COD = '"+ SB1->B1_COD +"'" 
	cQry += "    and Z05.Z05_LOCAL ='"+SB1->B1_LOCPAD+"'
	
	// atualiza variavel de retorno
	cNewQry := cQry
	
	cQry += "  order by SB1.B1_COD
	IF SELECT('QSB1')<>0
	 	QSB1->(DBcLOSEAREA())
	 EndIF
	TcQuery cQry New Alias "QSB1"
	// restaura area
	IF !QSB1->(EOF()) 	
		SB2->(DbSetOrder(1))
		// posiciona no almoxarifado
		SB2->(DbSeek( xFilial("SB2") + QSB1->B1_COD + QSB1->B1_LOCPAD ))
		nSaldo := SaldoSB2( Nil, Nil, If(Empty(mv_par11), dDataBase, mv_par11), mv_par12==1, mv_par13==1)
			// saldo pedido
			nSaldo += SB2->B2_SALPEDI
			// saldo a classificar
		nSaldo += SB2->B2_QACLASS
			
			// desconsidera quantidade em pedido de venda
		If mv_par14 == 1
			// subtrai quantidade
			nSaldo -= SB2->B2_QPEDVEN
			
		endIf
 		nNeces := If((nSaldo < 0),Abs(nSaldo)+RetFldProd(QSB1->B1_COD,"B1_EMAX","QSB1"),;
		If(QtdComp(nSaldo) <=  QtdComp( RetFldProd( QSB1->B1_COD,"B1_EMIN","QSB1")) ,  RetFldProd(QSB1->B1_COD,"B1_EMAX","QSB1")  -  QtdComp( RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1"))+( RetFldProd(QSB1->B1_COD,"B1_EMIN","QSB1") -nSaldo)      ,0))
  
  eNDif
return nNeces