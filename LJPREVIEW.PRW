#include "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "colors.ch"
#include "color.ch"
#include "font.ch"
#include "ap5mail.ch"  
#include "vkey.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLJPREVIEW บAutor  ณ Mauro Paladini H.  บ Data ณ  16/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMsGetDados da Pre-Solicitacao de Compras                    บฑฑ
ฑฑฬออออออออออุออออออออออออออหอออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      ณ Analista     บ Modificacao   						      บฑฑ
ฑฑฬออออออออออุออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ 16/04/04 ณMAURO HANIOKA บ Implantacao                      		      บฑฑ
ฑฑศออออออออออฯออออออออออออออสอออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LJPREVIEW()

	Local nI
	Local oDlg
	Local oGetDB
	Local nUsado 	:= 0
	Local aStruct	:= {}
	Local aBotoes1	:= {{"S4WB011N",{|| _LJVerCubo() },OemToAnsi("Vendas Mes a Mes .. (F4)")}}
	Local nOpc		:= 0
	Local bOk		:= {||nOpc:=1,oWindow:End()}
	Local bCancel 	:= {||nOpc:=0,oWindow:End()}			

	DbSelectArea("SZM")
	
	Private	cNumero		:= SZM->ZM_NUMERO
	Private cDataGer	:= DToc(SZM->ZM_EMISSAO)
	Private nVOrcado	:= SZM->ZM_VALORC
	Private	nVTotal		:= SZM->ZM_VALOR
	Private	cRegiao		:= SZM->ZM_REGIAO
	Private nRecs		:= 0
	
	// Variaveis da GetDados
	Private aPermite	:= {}
	Private lRefresh 	:= .T.
	Private aHeader 	:= {}
	Private aCols 		:= {}
	Private	nElemento	:= 4    // Elemento do aRotina
	Private _lView		:= .T. // Flag para exibicao do campo na GetDados

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ E obrigatorio a declaracao da aRotina para passarณ
	//ณ a var nOpc para a GetDados                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZN")

	While !Eof() .and. SX3->X3_ARQUIVO == "SZN"
	
		_lView	:= .T. 

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Exibe o nome de cada filial de acordo com o SIGAMAT.EMP e filtra somente   ณ
		//ณ as lojas cuja M0_ESTCOB for igual cRegiao atraves da funcao LJRet( cLoja ) ณ
		//ณ ** MUDAR _LVIEW para .F. caso nao queria exibir o campo na GetDados **     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		IF Substr(SX3->X3_CAMPO,4,1) $ "0/1/2/3/4/5/6/7/8/9"
			_aLojaOK 	:= LJRet(Substr(SX3->X3_CAMPO,4,2))
			_cLJCampo 	:= _aLojaOk[1]
			_cLJRegiao	:= _aLojaOk[2]
			If _cLJRegiao <> cRegiao
				_lView 	:= .F.
			Endif
		Else
			_cLJCampo	:= RTrim(X3Titulo())
		Endif
		

		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. _lView

			nUsado++					             
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ aHeader - Campos utilizados pelo aCols na GetDados   ณ
			//ณ aStruct - Estrutura da tabela temporaria da GetDados ณ
			//ณ aPermite - Campos que podem ser editados na GetDados ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			Aadd(aHeader,{ _cLJCampo ,SX3->X3_CAMPO,SX3->X3_PICTURE,	SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,SX3->X3_VALID,"",SX3->X3_TIPO,	"","" })
			Aadd(aStruct,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			If SX3->X3_VISUAL == "A"
				Aadd(aPermite,SX3->X3_CAMPO)
			Endif
		
		EndIf	
		DbSkip()	
	End

	Aadd(aStruct,{"FLAG","L",1,0})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria tabela temporaria para swap das informacoes  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCriaTrab := CriaTrab(aStruct,.T.)
	DbUseArea( .T.,__LocalDriver,cCriaTrab,"TRB",.T.,.F. )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Importa para a TRB os dados da tabela oficial do Banco ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa( {|| __IncDados( cNumero , nUsado  ) } , "Carregando, Aguarde ..." )

	SetKey(VK_F4,{||_LJVerCubo()})
	
	Define MsDialog oWindow Title OemToAnsi("Preview da Pr้-Solicita็ใo de Compras") FROM 065,000 TO 678,1010 PIXEL
	@ 017,010 Say OemToAnsi("Data Base:") Size 33,8
	@ 017,098 Say OemToAnsi("Orcamento:") Size 30,8
	@ 017,186 Say OemToAnsi("Solicitado:") Size 27,8
	@ 017,275 Say OemToAnsi("Regiao:") Size 20,8
	@ 016,048 Get cDataGer Size 36,10 When .F.  Object oEmissao
	@ 016,132 Get nVOrcado Size 40,10 Picture PesqPict("SZM","ZM_VALORC") When .F.  Object oVOrcado
	@ 016,217 Get nVTotal  Size 40,10 Picture PesqPict("SZM","ZM_VALOR")  When .F.  Object oVTotal
	@ 016,299 Get cRegiao  Size 15,10 Picture PesqPict("SZM","ZM_REGIAO") When .F.  Object oRegiao
	
	// oGetDB := MsGetDB():New(030,005,295,500,4,,"U_LJTudoK",,.T.,aPermite,,.F.,.F.,"TRB","U_LJFieldOK",,.F.,oWindow, .T., ,"U_LJDelOK", "U_LJSuperDEL")
	oGetDados := MsGetDados():New(030,005,295,500,4,"U_LJLinhaOK","U_LJTudoOK",,.T.,aPermite,,.T.,200,"U_LJFieldOK","U_LJSuperDEL",,"U_LJDelOK",oWindow)


	ACTIVATE MSDIALOG oWindow On Init EnchoiceBar(oWindow,bOk,bCancel,,aBotoes1) Centered
	SetKey(VK_F4,Nil)

	DbSelectArea("TRB")
	DbCloseArea()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ__IncDadosบ Autor ณ Mauro Paladini     บ Data ณ  19/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAlimentar tabela temporaria do aCols com os Dados da SZN    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ__IncDados( numero da pre-sc )                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function __IncDados( _Arg1 , _nUsado )

	Local _aArea 	:= GetArea()	
	
	DbSelectArea("TRB")
	
	_aEstru 	:= DbStruct() // Igual ao aHeader
	_Lin		:= 1
		
	_SQL := "SELECT COUNT(*) AS REGUA FROM " + RetSqlName("SZN") + " WHERE ZN_NUMERO = '" + _Arg1 + "' AND D_E_L_E_T_ <> '*'"
	DbUseArea( .T.,"TOPCONN", TCGenQry(,,_SQL), 'SQL', .F. , .T.)	; DbGoTop()	
	_Regua := SQL->REGUA
	DbCloseArea()	

	DbSelectArea("SZN")
	ProcRegua(_Regua)
	DbGoTop()
	
	If DbSeek( xFilial("SZN") + _Arg1 )	
		While !Eof() .And. SZN->ZN_NUMERO == _Arg1		
		
			IncProc()
	
			// Cria Linha no aCols e declara as variaveis
			Aadd(aCols,Array(_nUsado+1))
			DbSelectArea("SZN")

			For nI := 1 To _nUsado
				_xPos	:= FieldPos(_aEstru[nI,1])
				_xConteudo 	:= FieldGet(_xPos)
				_xCampo		:= FieldName(_xPos)
	  			aCols[_Lin][nI] := CriaVar(aHeader[nI][2])	
	  			aCols[_Lin][nI] := _xConteudo	  			
			Next			

  			aCols[_Lin][_nUsado+1] := .F.

			DbSelectArea("SZN")
			DbSkip()
			_Lin ++
			
		Enddo	
	Endif

	RestArea( _aArea )
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAxPreview บ Autor ณ Mauro Paladini     บ Data ณ  19/04/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelacao dos Consumos Mensais                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCompras                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AxPreview()

	Private cString
	Private cCadastro 	:= "Pr้-Solicita็ใo"
	Private aRotina 	:= { {"Pesquisar" ,"AxPesqui",0,1},{"Preview","U_LJPreview()",0,4}}
	Private cDelFunc 	:= ".T." 
	Private cString 	:= "SZM"

	DbSelectArea("SZM")
	DbSetOrder(1)
	
	mBrowse(6,1,22,75,cString,,)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณLJRet()   บ Autor ณ Mauro Paladini     บ Data ณ  19/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFuncao para retornar a regiao e nome da loja correspondente บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNumero da filial                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVetor com unidimencional ==> [1] Nome | [2] Regiao          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function LJRet( _cLoja )

	Local _aArea 	:= GetArea()
	Local _Ret	    := {}
	
	DbSelectArea("SM0")
	If DbSeek( cEmpAnt + _cLoja )	
		aAdd( _Ret , RTrim(Capital(SM0->M0_FILIAL)) )
		aAdd( _Ret , SM0->M0_ESTCOB )
	Else
		aAdd( _Ret , "ERRO" )
		aAdd( _Ret , Space(2))		
	Endif
	
	RestArea ( _aArea )
	
Return( _Ret )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ_LjVerCuboบ Autor ณ Mauro Paladini     บ Data ณ  19/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณExibe informacao de venda e estoque gravada em matriz dados บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaCols[nBrLin,_nPosProd]                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNenhum                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _LjVerCubo()

	Local _aArea	:= GetArea()
	Local _cProduto	:= aCols[n,1]
	Local _aFileVen	:= CriaTrab( Nil , .F. )
	Local _aCPOVen	:= {}                                                      
	Local _aCPOEst	:= {}
	Local nOpc		:= 0
	Local bOk		:= {||nOpc:=1,oSubWindow:End()}
	Local bCancel 	:= {||nOpc:=0,oSubWindow:End()}				

	SetKey(VK_F4,Nil)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Representacao das vendas mes a mes de todos os anos disponiveis na matriz ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	_SQL := "SELECT ZB3_FILIAL,ZB3_ANO,ZB3_Q01,ZB3_Q02,ZB3_Q03,ZB3_Q04,ZB3_Q05,ZB3_Q06,ZB3_Q07,ZB3_Q08,ZB3_Q09,ZB3_Q10,ZB3_Q11,ZB3_Q12 "
	_SQL += "FROM " + RetSqlName("ZB3") + " WHERE ZB3_COD = '" + _cProduto + "' AND D_E_L_E_T_ <> '*' ORDER BY ZB3_ANO+ZB3_FILIAL"
	DbUseArea( .T.,"TOPCONN", TCGenQry(,,_SQL), 'Vendas', .F. , .T.)
	
	aAdd( _aCPOVen , { "ZB3_FILIAL" , "Filial" } )
	aAdd( _aCPOVen , { "ZB3_ANO" , "Ano" } )
	aAdd( _aCPOVen , { "ZB3_Q01" , "Jan" , "999" } )
	aAdd( _aCPOVen , { "ZB3_Q02" , "Fev" , "999" } )
	aAdd( _aCPOVen , { "ZB3_Q03" , "Mar" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q04" , "Abr" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q05" , "Mai" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q06" , "Jun" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q07" , "Jul" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q08" , "Ago" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q09" , "Set" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q10" , "Out" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q11" , "Nov" , "999" } )	
	aAdd( _aCPOVen , { "ZB3_Q12" , "Dez" , "999" } )
	
	DbGoTop()
	Copy To &_aFileVen
	DbCloseArea()
	DbUseArea( .T.,__LocalDriver,_aFileVen,"VEN", .T. , .F. )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Representacao dos dias com estoque mes a mes ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    
 	_aCampos	:= {}
 	aAdd( _aCampos , { "ANO"   , "C" ,4,0 })
 	aAdd( _aCampos , { "FILIAL", "C" ,2,0 })
	aAdd( _aCampos , { "MES01" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES02" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES03" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES04" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES05" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES06" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES07" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES08" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES09" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES10" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES11" , "N" ,2,0 }) 	
	aAdd( _aCampos , { "MES12" , "N" ,2,0 }) 	
	_aFileEst	:= CriaTrab( _aCampos , .T. )	
	DbUseArea( .T.,"DBFCDX",_aFileEst,"EST", .T. , .F. )
	
	_SQL := "SELECT ZB3_FILIAL,ZB3_ANO,ZB3_OUT01,ZB3_OUT02,ZB3_OUT03,ZB3_OUT04,ZB3_OUT05,ZB3_OUT06,ZB3_OUT07,ZB3_OUT08,ZB3_OUT09,ZB3_OUT10,ZB3_OUT11,ZB3_OUT12 "
	_SQL += "FROM " + RetSqlName("ZB3") + " WHERE ZB3_COD = '" + _cProduto + "' AND D_E_L_E_T_ <> '*' ORDER BY ZB3_ANO+ZB3_FILIAL"
	DbUseArea( .T.,"TOPCONN", TCGenQry(,,_SQL), 'OUT', .F. , .T.)

 	DbSelectArea("OUT")
		While !Eof()
			
			DbSelectArea("EST")
			RecLock("EST",.T.)
				EST->FILIAL	:= OUT->ZB3_FILIAL
				EST->ANO	:= OUT->ZB3_ANO
				EST->MES01	:= ContaDCE( RTrim(OUT->ZB3_OUT01) )
				EST->MES02	:= ContaDCE( RTrim(OUT->ZB3_OUT02) )
				EST->MES03	:= ContaDCE( RTrim(OUT->ZB3_OUT03) )
				EST->MES04	:= ContaDCE( RTrim(OUT->ZB3_OUT04) )
				EST->MES05	:= ContaDCE( RTrim(OUT->ZB3_OUT05) )
				EST->MES06	:= ContaDCE( RTrim(OUT->ZB3_OUT06) )
				EST->MES07	:= ContaDCE( RTrim(OUT->ZB3_OUT07) )
				EST->MES08	:= ContaDCE( RTrim(OUT->ZB3_OUT08) )
				EST->MES09	:= ContaDCE( RTrim(OUT->ZB3_OUT09) )
				EST->MES10	:= ContaDCE( RTrim(OUT->ZB3_OUT10) )
				EST->MES11	:= ContaDCE( RTrim(OUT->ZB3_OUT11) )
				EST->MES12	:= ContaDCE( RTrim(OUT->ZB3_OUT12) )
			MsUnLock()
			
			DBSelectArea("OUT")
			DbSkip()
			
		Enddo

	DbSelectArea("OUT")
	DbCloseArea()

	aAdd( _aCPOEst , { "FILIAL" , "Filial" } )
	aAdd( _aCPOEst , { "ANO" , "Ano" } )
	aAdd( _aCPOEst , { "MES01" , "Jan" , "99" } )
	aAdd( _aCPOEst , { "MES02" , "Fev" , "99" } )
	aAdd( _aCPOEst , { "MES03" , "Mar" , "99" } )	
	aAdd( _aCPOEst , { "MES04" , "Abr" , "99" } )	
	aAdd( _aCPOEst , { "MES05" , "Mai" , "99" } )	
	aAdd( _aCPOEst , { "MES06" , "Jun" , "99" } )	
	aAdd( _aCPOEst , { "MES07" , "Jul" , "99" } )	
	aAdd( _aCPOEst , { "MES08" , "Ago" , "99" } )	
	aAdd( _aCPOEst , { "MES09" , "Set" , "99" } )	
	aAdd( _aCPOEst , { "MES10" , "Out" , "99" } )	
	aAdd( _aCPOEst , { "MES11" , "Nov" , "99" } )	
	aAdd( _aCPOEst , { "MES12" , "Dez" , "99" } )	

	DbSelectArea("Ven")
	DbGoTop()
	
	DbSelectArea("Est")
	DbGoTop()    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Construcao da tela 	de visualizacao das vendas e estoques ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Define MsDialog oSubWindow Title OemToAnsi("Informa็๕es Adicionais") FROM 065,000 TO 344,795 PIXEL
	@ 013,006 To 071,393 Title OemToAnsi(" Vendas Mes a Mes ")
	@ 023,010 To 066,389 Browse "VEN" Fields _aCPOVen Object oVendas
	@ 077,006 To 135,393 Title OemToAnsi(" Dias com estoque ")
	@ 086,010 To 129,389 Browse "EST" Fields _aCPOEst Object oEstoques
	Activate Dialog oSubWindow On Init EnchoiceBar(oSubWindow,bOk,bCancel,,) Centered
	
	DlgRefresh(oVendas)
	DlgRefresh(oEstoques)
	
	DbSelectArea("Ven")
	DbCloseArea()
	
	DbSelectArea("Est")
	DbCloseArea()

	SetKey(VK_F4,{||_LJVerCubo()})
	
	RestArea( _aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณContaDCE()บAutor  ณMauro Paladini      บ Data ณ  02/23/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณLe a string compactada de dias com estoque e retorna total  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณContaDCE( _cString )                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ContaDCE( _cString )

	Local _nDias	:= 0
	Local x			:= 1
	
	For x := 1 To Len( _cString )
		If Substr(_cString,x,1) == "1"
			_nDias := (_nDias + 1 )
		Endif
	Next	
	
Return( _nDias )