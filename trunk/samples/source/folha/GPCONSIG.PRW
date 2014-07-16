#include "Protheus.ch"
#define CRLF Chr(13)+Chr(10)                       

/*                                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPCONSIG  ºAutor  ³Equipe R.H.                ³  17/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina tem a finalidade de ler o arquivo .TXT que vem º±±
±±º          ³ do banco(padrao Itau) e colocar em tela, assim permitindo  º±±
±±º          ³ que o usuario possa alterar e confirmar os dados a serem   º±±
±±º          ³ reenviado ao banco, e apos ao  analise do funcionario  a   º±±
±±º          ³ possibilidade de gravacao na tabela(SRC) na folha de pagto.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Para o sistema de Consignicao em folha de pagamento (Itau) º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GPCONSIG()
Local cCaption      := cCadastro 		:= "Tratamento das informacoes bancaria"
Local _cLinha		:= "",_LineStatus 	:= ""
Local cIndex 		:= cChave  			:= ""
Local cMatric		:= cFilFunc			:= cNome	:= ""
Local lSimNao 		:= .f.
Local _cTipoWork	:= 9
Local nOpcA			:= 0
Local oDlgTask
Local oGetD

Local aRegistros	:= {}
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjCoords 	:= {}
Local aObjSize		:= {}
Local aCampos		:= {}

Local FONT


PRIVATE aCols		:= {}
PRIVATE aHeader		:= {}
PRIVATE aRotina     := { { "chamada","Ft320Work",0,4} }
PRIVATE INCLUI      := .F. ,aalter:= {}
Private _cArqRead	:= GetMV("MV_CONSFOL")
Private cArqTemp	:= ""
Private cArqTempAll	:= ""
Private cMensag		:= ""
PRIVATE dData       := dDataAtu := date()
Private nCont		:= 0
Private cTabAll		:= "GPCONSIG"
Private aAreaSra	:= {}

DEFINE FONT oBold NAME "Georgia" SIZE 0, -14 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do arquivo temporario, este arquivo sempre sera criado, pois toda as informacoes que tenha	 |
//| na tabela GPECONSIG.DBF ele armazenara dentro deste TMP para a leitura e gravacao nesta rotina           |
//| somente para o mesmo usuario ele trara as informacoes.                                                   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {{ "TR_FILIAL"  	,"C",002,0 	} ,;	// FILIAL DA EMPRESA DO FUNCIONARIO
             { "TR_MAT"    	,"C",006,0 	} ,;	// MATRICULA DO FUNCIONARIO
             { "TR_VERBA"  	,"C",003,0 	} ,;	// CODIGO DA VERBA A SER AMARRADA O REGISTRO
             { "TR_LZERO"  	,"C",240,0 	} ,;	// CONTEUDO DA LINHA ZERO
             { "TR_LUM"    	,"C",240,0 } ,;   	// CONTEUDO DA LINHA UM DO LAYOUT	
             { "TR_LDOIS"  	,"C",240,0 } ,;		// CONTEUDO DA LINHA DOIS DO LAYOUT
             { "TR_CDBANCO"	,"N",003,0 } ,;  	// CODIGO DO BANCO 
             { "TR_CDLOTE" 	,"N",004,0 } ,;		// CODIGO DO LOTE
             { "TR_TPREGIS"	,"N",001,0 } ,;		// TIPO DO REGISTRO
             { "TR_NREGIST"	,"N",005,0 } ,;    // NUMERO DO REGISTRO
             { "TR_SEGMENT" ,"C",001,0 } ,;		// SEGMENTO
             { "TR_TPMOVIM" ,"N",003,0 } ,;		// TIPO DO MOVIMENTO
             { "TR_ZEROS1" 	,"N",003,0 } ,;		// ZEROS
             { "TR_NOMEFAV" ,"C",030,0 } ,;		// NOME DO FAVORECIDO
             { "TR_SEUNUME" ,"C",020,0 } ,;		// SEU NUMERO
             { "TR_DTPAGTO" ,"D",008,0 } ,;		// DATA DO PAGTO
             { "TR_ZEROS2" 	,"N",003,0 } ,;		// ZEROS COMPLEMENTAR
             { "TR_VLPAGTO" ,"N",013,2 } ,;		// VALOR DO PAGAMENTO
             { "TR_NNUMERO"	,"C",015,0 } ,;		// NOSSO NUMERO
             { "TR_BRANCO1" ,"C",005,0 } ,;		// BRANCOS
             { "TR_DTAFETI"	,"D",008,0 } ,;		// DATA AFETIVA
             { "TR_VLEFETI"	,"N",013,2 } ,;		// VALOR EFETIVO
             { "TR_NCONTRA"	,"N",008,0 } ,;		// NUMERO CONTRATO
             { "TR_NPARCEL" ,"N",003,0 } ,;		// NUMERO DA PARCELA
             { "TR_IREPASS"	,"C",002,0 } ,;		// INDICADOR DE REPASSE
             { "TR_CDNREPA" ,"C",002,0 } ,;		// CODIGO DO NAO REPASSE
             { "TR_CPF"  	,"C",011,0 } ,;		// CPF DO FUNCIONARIO
             { "TR_DTVENCI" ,"D",008,0 } ,;		// DATA DE VENCIMENTO
             { "TR_BRANCO2" ,"C",058,0 } ,;		// BRANCOS
             { "TR_OCORREN" ,"C",010,0 } ,;		// OCORRENCIAS
             { "TR_LCINCO" ,"C",240 ,0 } ,;		// CONTEUDO DA LINHA CINCO
             { "TR_LNOVE"  ,"C",240 ,0 } ,;		// CONTEUDO DA LINHA NOVE DO LAYOUT
             { "TR_USUARIO","C",020 ,0 } ,;		// Usuario a acessar a rotina
             { "TR_TPPAGTO","N",002 ,0 } ,;		// Tipo de pagamento / status 9 - Averbacao cons./ 11 - man. da consig./12 consig das parcelas
             { "TR_DATALAN","D",008 ,0 }}		// Data do lançamento

cArqTemp := CriaTrab(aCampos)
dbUseArea(.T.,,cArqTemp,"TRB",.T.,.F.)	
IndRegua("TRB",cArqTemp,"TR_FILIAL+Str(TR_TPREGIS)+TR_USUARIO",,,"Selecionando Registros...")


If !File(cTabAll+".DBF")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso nao exista o arquivo GPCONSIG.DBF, ele criara. Rotina utilizada somente para o primeiro acesso, pois ³
	//³permite a gravacao da leitura do TXT.                                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTempAll := CriaTrab(aCampos)
	dbUseArea(.T.,,cArqTempAll,cTabAll,.t.,.F.)
	IndRegua(cTabAll,cArqTempAll,"TR_FILIAL+Str(TR_TPREGIS)+TR_USUARIO",,,"Selecionando Registros...")
Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisar o tipo de registro, caso for somente informativo ele nao importa³
	//³na tela do MsGetDados.                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (File(_cArqRead))
		FT_FUse(_cArqRead)
		FT_FGotop()	
		While ( !FT_FEof() )
			_cLinha 	:= FT_FREADLN()
			_LineStatus	:= SubStr(_cLinha,8,1)
			If "1" == _LineStatus
				If Substr(_cLinha,10,2) == "09"
			  		Alert("Este tipo de documento de importação é somente informativo !")
					dbSelectArea("TRB")
					dbCloseArea("TRB")
					FErase(cArqTemp+OrdBagExt())
					FErase(cArqTemp+".DBF")
					Return
			  	EndIf
			Endif
			FT_FSkip()
		EndDo
		FT_FUse()         
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Esta variavel _cArqRead, contem o caminho do arquivo que sera importado (TXT) para dentro do TRB, ³
	//³este nome arquivo TXT podera ser alterado no SX6 - MV_CONSFOL                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (File(_cArqRead))
		FT_FUse(_cArqRead)
		FT_FGotop()
		nLin	:= 0
				
		While ( !FT_FEof() )
			_cLinha := FT_FREADLN()
			_LineStatus	:= SubStr(_cLinha,8,1)
			If "0" == _LineStatus
	       		RecLock("TRB",.T.)	           
					Replace TR_LZERO 	WITH 	_cLinha
					Replace TR_TPREGIS 	WITH 	0
					Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
				MsUnLock()
			ElseIf "1" == _LineStatus
	       		RecLock("TRB",.T.)	           
					Replace TR_LUM 		WITH 	_cLinha
					Replace TR_TPREGIS 	WITH 	1
					Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
					_cTipoWork	:= Val(Substr(_cLinha,10,2))
				MsUnLock()
			ElseIf "2" == _LineStatus
	       		RecLock("TRB",.T.)	           
					Replace TR_DOIS 	WITH 	_cLinha
					Replace TR_TPREGIS 	WITH 	2
					Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
				MsUnLock()
		
			ElseIf "5" == _LineStatus
	       		RecLock("TRB",.T.)	           
					Replace TR_LCINCO 	WITH 	_cLinha
					Replace TR_TPREGIS 	WITH 	5
					Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
				MsUnLock()
			ElseIf "9" == _LineStatus
	       		RecLock("TRB",.T.)	           
					Replace TR_LNOVE 	WITH 	_cLinha
					Replace TR_TPREGIS 	WITH 	9
					Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
				MsUnLock()
			EndIf
			FT_FSkip()
		EndDo	
		FT_FUse()	
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Neste bloco, ele permite buscar no GPECONSIG.DBF somente o TIPO DE REGISTRO igual a "3" e que o  ³
	//|usuario seje igual aos registros da tabela,pois a leitura das linhas anteriores foram para buscar|
	//³o Tipo Registro diferente de "3"  no TXT.                                                        |                                                                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbUseArea(.T.,,cTabAll,cTabAll,nil,.F.)
	While !Eof()
		If Alltrim(Upper(GPCONSIG->TR_USUARIO)) == Alltrim(Upper(Substr(cUsuario,7,15)))
			RecLock("TRB",.T.)
				Replace TRB->TR_FILIAL		WITH 	GPCONSIG->TR_FILIAL
				Replace TRB->TR_MAT 		WITH 	GPCONSIG->TR_MAT
				Replace TRB->TR_CDBANCO 	WITH 	GPCONSIG->TR_CDBANCO
				Replace TRB->TR_VERBA 		WITH 	GPCONSIG->TR_VERBA
				Replace TRB->TR_CDLOTE 		WITH 	GPCONSIG->TR_CDLOTE
				Replace TRB->TR_TPREGIS 	WITH 	GPCONSIG->TR_TPREGIS
				Replace TRB->TR_NREGIST 	WITH 	GPCONSIG->TR_NREGIST
				Replace TRB->TR_SEGMENT 	WITH 	GPCONSIG->TR_SEGMENT
				Replace TRB->TR_TPMOVIM 	WITH 	GPCONSIG->TR_TPMOVIM
				Replace TRB->TR_ZEROS1 		WITH 	GPCONSIG->TR_ZEROS1
				Replace TRB->TR_NOMEFAV 	WITH 	GPCONSIG->TR_NOMEFAV
				Replace TRB->TR_SEUNUME 	WITH 	GPCONSIG->TR_SEUNUME
				Replace TRB->TR_DTPAGTO 	WITH 	GPCONSIG->TR_DTPAGTO
				Replace TRB->TR_ZEROS2 		WITH 	GPCONSIG->TR_ZEROS2
				Replace TRB->TR_VLPAGTO		WITH 	GPCONSIG->TR_VLPAGTO
				Replace TRB->TR_NNUMERO 	WITH 	GPCONSIG->TR_NNUMERO
				Replace TRB->TR_BRANCO1 	WITH 	GPCONSIG->TR_BRANCO1
				Replace TRB->TR_DTAFETI 	WITH 	GPCONSIG->TR_DTAFETI
				Replace TRB->TR_VLEFETI 	WITH 	GPCONSIG->TR_VLEFETI
				Replace TRB->TR_NCONTRA 	WITH 	GPCONSIG->TR_NCONTRA
				Replace TRB->TR_NPARCEL 	WITH 	GPCONSIG->TR_NPARCEL
				Replace TRB->TR_IREPASS 	WITH 	GPCONSIG->TR_IREPASS
				Replace TRB->TR_CDNREPA 	WITH 	GPCONSIG->TR_CDNREPA
				Replace TRB->TR_CPF	   		WITH 	GPCONSIG->TR_CPF
				Replace TRB->TR_DTVENCI 	WITH 	GPCONSIG->TR_DTVENCI
				Replace TRB->TR_BRANCO2 	WITH 	GPCONSIG->TR_BRANCO2
				Replace TRB->TR_OCORREN 	WITH 	GPCONSIG->TR_OCORREN
				Replace TRB->TR_USUARIO		With 	GPCONSIG->TR_USUARIO
				Replace TRB->TR_LZERO		With 	GPCONSIG->TR_lZERO
				Replace TRB->TR_LUM			With 	GPCONSIG->TR_LUM
				Replace TRB->TR_LDOIS		With 	GPCONSIG->TR_LDOIS
				Replace TRB->TR_LCINCO		With 	GPCONSIG->TR_LCINCO
				Replace TRB->TR_LNOVE		With 	GPCONSIG->TR_LNOVE				
				Replace TRB->TR_TPPAGTO		With 	_cTipoWork
			MsUnlock()				
			dbSelectArea("GPCONSIG")
        Endif	
	  dbSkip()
	EndDo			
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³A finalidade deste indice sobre o SRA, eh que com base no CIC do funcionario eu busco a matricula dele e o nome ³
//³na tabela SRA, assim permanecendo o nome exato ao cadastro nosso.                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRA")
cIndex := CriaTrab(nil,.f.)
cChave  := "RA_CIC+DTOS(RA_DEMISSA)"
IndRegua("SRA",cIndex,cChave,,,"Selecionando Registros...")

aAreaSra	:= GetArea()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta funcao MontaHeader, tem a finalidade de montar a estrutura do Header na MsGetDados, conforme³
//³o manual de arquivo mensal de repasse do banco, campo a campo.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MontaHeader()


If RecCount("TRB") == 0
	Aadd(aCols,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",.t.})
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso o acesso seje de um usuario com informacoes na tabela GPCONSIG.DBF ele passara dentro desta condicao           ³
	//³com objetivo de somente gerar o Acols dos registro do tipo "3", que sao os funcionarios da empresa que veio via TXT.³
	//³a funcao = GrvAcols (permite carregar o conteudo de todos os funcionarios dentro do Acols).                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbGotop()
	While !Eof()
		If TR_TPREGIS == 3
			U_GrvAcols()	
		Endif
		dbSelectArea("TRB")
		dbSkip()
	EndDo
Endif


aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 000 , 030 , .T. , .F. } )
aAdd( aObjCoords , { 000 , 150 , .t. , .f. } )	
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

		
	DEFINE MSDIALOG oDlgTask TITLE cCaption FROM 02,0 TO 32,128 OF oMainWnd
		
		@ 016,010 SAY  "Informações do banco:  Itaú "  			Of	oDlgTask PIXEL 	SIZE 250,020 FONT oBold
	   	@ 028,010 SAY  "Data da transação   : " + Dtoc(date()) 	OF 	oDlgTask PIXEL	SIZE 250,020 FONT oBold
        
		@ 028,410 SAY  "Usuário: " + Substr(cUsuario,7,15)		Of	oDlgTask PIXEL 	SIZE 250,020 FONT oBold
	
		@ 204,005 BUTTON OemToAnsi("Leitura Arquivo")	SIZE 060,017 FONT oDlgTask:oFont ACTION U_MontaGet() 	PIXEL
		@ 204,087 BUTTON OemToAnsi("Reenvio Banco") 	SIZE 060,017 FONT oDlgTask:oFont ACTION U_ReadEnvio() 	PIXEL
		@ 204,170 BUTTON OemToAnsi("Importação Folha") 	SIZE 060,017 FONT oDlgTask:oFont ACTION U_EmpMigra() 	PIXEL
		@ 204,250 BUTTON OemToAnsi("Cancelar") 			SIZE 060,017 FONT oDlgTask:oFont ACTION (oDlgTask:End()) PIXEL
	
		oGetd:=MsGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],1,"U_EmpLinOk","U_EmpTudOk","",Nil)
	ACTIVATE MSDIALOG oDlgTask ON INIT EnchoiceBar(oDlgTask,{||nOpcA:=1,If(oGetd:TudoOk(),oDlgTask:End(),nOpcA:=0)},{||oDlgTask:End()})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta funcao Encerra(), tem o objetivo de apagar os registro tipo "3" do arquivo e gravar³
//³os novos campos alterado pelo o usuario, na GetDados e fechando as tabelas temporarias. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
U_Encerra(nOpcA)
	
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPCONSIG  ºAutor  ³Equipe R.H.         º Data ³  07/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de opcao para a chamada da geracao do arquivo TXT, paraº±±
±±º          ³o envio ao banco, o caminho do arquivo eh configurado       º±±
±±º          ³MV_CAMBANCO.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ReadEnvio()

Local cCaption      := cCadastro := + "Caminho do arquivo de geração"
Local cArqBusca		:= IIf(Len(Alltrim(GetMV("MV_CAMBANCO")))>0,GetMV("MV_CAMBANCO"),Space(70))
Local nOpcA			:=	0
Local oDlgFilho
Local oMainWnd
Local oGetx


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz a verificacao se existe o parametro na tabela SX6(MV_CAMBANCO), caso       ³
//³nao exista ele cria o parametro colocando a descricao no SX6 com o conteudo do ³
//³segundo parametro e o terceiro parametro grava como valor.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_GrvSx6("MV_CAMBANCO","Aponta o caminho e o arquivo a gerar ao banco",cArqBusca)

DEFINE MSDIALOG oDlgFilho TITLE cCaption FROM 20,30 TO 30,090 OF oMainWnd
	
	@18,020  Say OemToAnsi("Entre com o caminho e arquivo a gerar ao banco") 	PIXEL 
	@30,020  MSGET cArqBusca SIZE 200,10 When .t. PIXEL

	@60,020  BUTTON OemToAnsi("Confirma") SIZE 040,012 FONT oDlgFilho:oFont ACTION (U_EmpExport(cArqBusca),oDlgFilho:Refresh(),oDlgFilho:End()) PIXEL	// OF oPanel3 PIXEL
	@60,080  BUTTON OemToAnsi("Cancelar") SIZE 040,012 FONT oDlgFilho:oFont ACTION oDlgFilho:End() PIXEL

ACTIVATE MSDIALOG oDlgFilho ON INIT EnchoiceBar(oDlgFilho,{||nOpcA:=1,If(oGetx:TudoOk(),oDlgFilho:End(),nOpcA:=0)},{||oDlgFilho:End()})

If nOpcA == 0
	Return
Endif


Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTAGET  ºAutor  ³Equipe R.H.         º Data ³  07/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela que permite a entrada do parametro e escolha do cami- º±±
±±º          ³nho a ser buscado o arquvo TXT para a carga/leitura inicial.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MontaGet()
Local cCaption      := 	cCadastro := + "Caminho do arquivo"
Local cArqBusca		:= 	IIf(Len(Alltrim(GetMV("MV_CONSFOL")))>0,GetMV("MV_CONSFOL"),Space(70))
Local nOpcA			:=	0
Local oDlgFilho
Local oMainWnd
Local oGetx

aCols:= {}


DEFINE MSDIALOG oDlgFilho TITLE cCaption FROM 20,30 TO 30,090 OF oMainWnd
	
	@18,020  Say OemToAnsi("Entre com o arquivo a ser buscado na leitura da carga") PIXEL 
	@30,020  MSGET cArqBusca SIZE 200,10 When .t. PIXEL

	@60,020  BUTTON OemToAnsi("Confirma") SIZE 040,012 FONT oDlgFilho:oFont ACTION (U_GrvParm(cArqBusca),oDlgFilho:Refresh(),oDlgFilho:End()) PIXEL
	@60,080  BUTTON OemToAnsi("Cancelar") SIZE 040,012 FONT oDlgFilho:oFont ACTION oDlgFilho:End() PIXEL

ACTIVATE MSDIALOG oDlgFilho ON INIT EnchoiceBar(oDlgFilho,{||nOpcA:=1,If(oGetx:TudoOk(),oDlgFilho:End(),nOpcA:=0)},{||oDlgFilho:End()})


If nOpcA == 0
	Return
Endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvParam  ºAutor  ³Microsiga           º Data ³  07/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Varre o arquivo TXT e o GPCONSIG.DBF e apresenta na tela   º±±
±±º          ³ os movimentos dos arquivos, caso tenha algum movimento de  º±±
±±º          ³ acordo com o usuario ele emite uma msg inf. que existe mov.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvParm(_cArqRead)
Local _cTipoWork	:= 12
Local _LineStatus	:= ""
Local _cLinha		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analisar o tipo de registro, caso for somente informativo ele nao importa³
//³na tela do MsGetDados.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (File(_cArqRead))
	FT_FUse(_cArqRead)
	FT_FGotop()	
	While ( !FT_FEof() )
		_cLinha 	:= FT_FREADLN()
		_LineStatus	:= SubStr(_cLinha,8,1)
		If "1" == _LineStatus
			If Substr(_cLinha,10,2) == "09"
		  		Alert("Este tipo de documento de importação é somente informativo !")
				Aadd(aCols,{"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",.t.})
		  		Return
		  	EndIf
		Endif
		FT_FSkip()
	EndDo
	FT_FUse()         
Endif


dbSelectArea("TRB")
dbGotop()
If RecCount() >= 1
	If !(MsgYesNo("Você já possui lançamentos, deseja sobrepor ?"))		
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A finalidade desta exclusao eh apagar os arquivos que tenham no TRB, assim gravaremos³
	//³todos os registros da aCols para a tabela TRB. Somente registro tipo "3".            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		RecLock("TRB",.F.,.T.)
	   	dbDelete()
	   	dbSkip()
	Enddo
	cMensag	:= ""
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz a verificacao se existe o parametro na tabela SX6(MV_CONSFOL),  caso       ³
//³nao exista ele cria o parametro colocando a descricao no SX6 com o conteudo do ³
//³segundo parametro e o terceiro parametro grava como valor.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_GrvSx6("MV_CONSFOL","Caminho do arquivo para a leitura do arquivo",_cArqRead)

If (File(_cArqRead))
	FT_FUse(_cArqRead)
	FT_FGotop()
	nLin	:= 0
	
	While ( !FT_FEof() )
		_cLinha := FT_FREADLN()
		_LineStatus	:= SubStr(_cLinha,8,1)
		If "0" == _LineStatus
       		RecLock("TRB",.T.)	           
				Replace TR_LZERO 	WITH 	_cLinha
				Replace TR_TPREGIS 	WITH 	0
				Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
			MsUnLock()
		ElseIf "1" == _LineStatus
       		RecLock("TRB",.T.)	           
				Replace TR_LUM 		WITH 	_cLinha
				Replace TR_TPREGIS 	WITH 	1
				Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
				_cTipoWork	:= Val(Substr(_cLinha,10,2))
			MsUnLock()
		ElseIf "2" == _LineStatus
       		RecLock("TRB",.T.)	           
				Replace TR_DOIS 	WITH 	_cLinha
				Replace TR_TPREGIS 	WITH 	2
				Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
			MsUnLock()
		ElseIf "3" == _LineStatus
       		RecLock("TRB",.T.)	           
				Replace TR_FILIAL	WITH 	cFilial
				Replace TR_MAT 		WITH 	Substr(_cLinha,64,6)
				Replace TR_CDBANCO 	WITH 	Val(Substr(_cLinha,1,3))
				Replace TR_CDLOTE 	WITH 	Val(Substr(_cLinha,4,4))
				Replace TR_TPREGIS 	WITH 	Val(Substr(_cLinha,8,1))
				Replace TR_NREGIST 	WITH 	Val(Substr(_cLinha,9,05))
				Replace TR_SEGMENT 	WITH 	Substr(_cLinha,14,01)
				Replace TR_TPMOVIM 	WITH 	Val(Substr(_cLinha,15,03))
				Replace TR_ZEROS1 	WITH 	Val(Substr(_cLinha,18,03))
				Replace TR_NOMEFAV 	WITH 	Substr(_cLinha,21,30)
				Replace TR_SEUNUME 	WITH 	Substr(_cLinha,51,20)
				Replace TR_DTPAGTO 	WITH 	CtoD( Substr(_cLinha,71,02) +"/"+ Substr(_cLinha,73,02) +"/"+ Substr(_cLinha,77,02) )
				Replace TR_ZEROS2 	WITH 	Val(Substr(_cLinha,79,03))
				Replace TR_VLPAGTO	WITH 	Val(Substr(_cLinha,82,13)+"."+Substr(_cLinha,95,2))
				Replace TR_NNUMERO 	WITH 	Substr(_cLinha,97,15)
				Replace TR_BRANCO1 	WITH 	Substr(_cLinha,112,05)
				Replace TR_DTAFETI 	WITH 	CtoD( Substr(_cLinha,117,02) +"/"+ Substr(_cLinha,119,02) +"/"+ Substr(_cLinha,123,02) )
				Replace TR_VLEFETI 	WITH 	Val(Substr(_cLinha,125,13)+"."+Substr(_cLinha,138,2))
				Replace TR_NCONTRA 	WITH 	Val(Substr(_cLinha,140,8))
				Replace TR_NPARCEL 	WITH 	Val(Substr(_cLinha,148,03))
				Replace TR_IREPASS 	WITH 	Iif(Substr(_cLinha,151,1)="1","N","S")
				Replace TR_CDNREPA 	WITH 	Substr(_cLinha,152,02)
				Replace TR_CPF	   	WITH 	Substr(_cLinha,154,11)
				Replace TR_DTVENCI 	WITH 	CtoD( Substr(_cLinha,165,02) +"/"+ Substr(_cLinha,167,02) +"/"+ Substr(_cLinha,171,02)  )
				Replace TR_BRANCO2 	WITH 	Substr(_cLinha,173,058)
				Replace TR_OCORREN 	WITH 	Substr(_cLinha,231,010)
				Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
				Replace TR_TPPAGTO	With 	_cTipoWork
			MsUnLock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega os registros lido no arquivo para o Acols, assim disponibilizando na tela da MsGetDados .     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			U_GrvAcols()

		ElseIf "5" == _LineStatus
       		RecLock("TRB",.T.)	           
				Replace TR_LCINCO 	WITH 	_cLinha
				Replace TR_TPREGIS 	WITH 	5
				Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
			MsUnLock()
		ElseIf "9" == _LineStatus
       		RecLock("TRB",.T.)	           
				Replace TR_LNOVE 	WITH 	_cLinha
				Replace TR_TPREGIS 	WITH 	9
				Replace TR_USUARIO	With 	Substr(cUsuario,7,15)
			MsUnLock()
		EndIf
		FT_FSkip()
	EndDo
	FT_FUse()
Endif
dbSelectArea("TRB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta chamada ChamaLog(),  tem por objetivo de registrar no arquivo GPCONSIG.LOG as diferencas³
//³dos registros que não foram possiveis serem lidas no momento de apresentar na MsGetDados     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_ChamLog()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvAcols  ºAutor  ³Equipe R.H.         º Data ³  07/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz o retorno do aCols, para a MsGetDados.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvAcols()
	cMatric		:= ""
	cFilFunc	:= ""
	cNome		:= ""
	lSimNao		:= .t.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca pelo o CPF do funcionario de acordo com o indice que foi gerado do SRA com a chave RA_CIC, assim³
	//³eu encontro o nome completo do funcinario quanto a filial e a matricula.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_ChekName(TRB->TR_CPF,@cMatric,@cFilFunc,@cNome,@lSimNao)

	Aadd(aCols,{Iif(lSimNao,"S I M","N A O"),TRB->TR_TPPAGTO,cFilFunc,cMatric,TRB->TR_VERBA,TRB->TR_CDBANCO,TRB->TR_CDLOTE,TRB->TR_TPREGIS,TRB->TR_NREGIST,TRB->TR_SEGMENT,TRB->TR_TPMOVIM,TRB->TR_ZEROS1,cNome,TRB->TR_SEUNUME,;
					TRB->TR_DTPAGTO,TRB->TR_ZEROS2,TRB->TR_VLPAGTO,TRB->TR_NNUMERO,TRB->TR_BRANCO1,TRB->TR_DTAFETI,TRB->TR_VLEFETI,TRB->TR_NCONTRA,TRB->TR_NPARCEL,TRB->TR_IREPASS,;
					TRB->TR_CDNREPA,TRB->TR_CPF,TRB->TR_DTVENCI,TRB->TR_BRANCO2,TRB->TR_OCORREN,.F.})
Return(aCols)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvSx6    ºAutor  ³Equipe R.H.         º Data ³  07/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Traz ou grava no SX6 o conteudo que vier no parametro.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GrvSx6(cParam,cMens,cArqBusca)

dbSelectArea("SX6")
dbSetOrder(1)
If dbSeek("  "+cParam)
   PutMv(cParam,Alltrim(Upper(cArqBusca)))
Else
	RecLock("SX6",.t.)
        REPLACE X6_VAR 		With cParam
        REPLACE X6_TIPO 	With "C"
        REPLACE X6_DESCRIC 	With cMens
        REPLACE X6_CONTEUD 	With Alltrim(Upper(cArqBusca))
	MsUnLock()	
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EmpLinOk	³ Autor ³Equipe R.H.            ³ Data ³ 11/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Critica linha digitada                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  Esta livre para ser tratada                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EmpLinOk()

Local lRet := .T.

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EmpTudOk	³ Autor ³ Equipe R.H.           ³ Data ³11/07/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  A ser tratada                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EmpTudOk(o)
Local lRetorna  := .T.

Return lRetorna



 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina de exportacao dos dados para o envio ao banco.              ³
//³Consiste em pegar as informacoes do Acols caso tenha alterado      ³
//³com o cabeçalho e rodapé gerar o arquivo TXT para o envio bancario.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPCONSIG  ºAutor  ³Microsiga           º Data ³  07/16/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de exportacao dos dados para o envio ao banco.       º±±
±±º          ³Consiste em pegar as informacoes do Acols caso tenha        º±±
±±º          ³alterado com o cabeçalho e rodapé gerar o arquivo 		  º±±
±±º          ³TXT para o envio bancario.								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EmpExport(_cArqExport)
Local nHdlConf		:= 0
Local lPass 		:= .t.      
Local nCont			:= 0

PutMv("MV_CAMBANCO",Alltrim(Upper(_cArqExport)))

If !MsgYesNo("Este procedimento somente deverá ser efetuado após avaliação das condições dos empréstimo enviado pelo banco.","Reenvio banco")
    Return
Endif


DbSelectArea("SRA")
dbSetOrder ()

dbSelectArea("TRB")
dbGotop()


If !File(_cArqExport)
	nHdlConf := MSFCREATE(_cArqExport,0)
Else
	FERASE(_cArqExport)
	nHdlConf := MSFCREATE(_cArqExport,0)
EndIf


While !Eof()
	If !Empty(TR_LZERO)
		fWrite(nHdlConf,TR_LZERO + CRLF)
	ElseIf !Empty(TR_LUM)
		fWrite(nHdlConf,Substr(TR_LUM,1,9)+"12"+Substr(TR_LUM,12,250)+ CRLF)
	ElseIf !Empty(TR_LDOIS)
		fWrite(nHdlConf,TR_LDOIS + CRLF)
	ElseIf !Empty(TR_LCINCO)
		fWrite(nHdlConf,TR_LCINCO + CRLF)
	ElseIf !Empty(TR_LNOVE)
		fWrite(nHdlConf,TR_LNOVE + CRLF)
	ElseIf TR_TPREGIS == 3  .And. lPass
		For nCont:= 1 to Len(aCols)
			IF ( SRA->( dbSeek( ACols[nCont][26] , .F. ) ) )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Esta funcao  SizeCampo, ele traz espacos em brancos ou zeros de acordo         ³
				//³com o lado que ele estiver posicionado do campo. Ele sozinho identifica quantos³
				//³espaços devem/zeros serem reproduzidos, e fazendo os tratamentos caso caracter,³
				//³numerico ou data.                                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				fWrite(nHdlConf,(U_SizeCampo("CODIGO BANCO")+Alltrim(Str(ACols[nCont][6])))  	+  	(U_SizeCampo("CODIGO DO LOTE")+Alltrim( Str(ACols[nCont][7])))  	+  	(U_SizeCampo("TIPO DE REGISTRO")+Alltrim(Str(ACols[nCont][8])))+ (U_SizeCampo("NUMERO REGISTRO")+Alltrim(Str(ACols[nCont][9])))					+;
								ACols[nCont][10]   			 								   	+  	(U_SizeCampo("TIPO MOV")+ Alltrim(Str(ACols[nCont][11])))			+	(U_SizeCampo("ZEROS1")+Alltrim(Str(ACols[nCont][12])))		+	( (Alltrim(ACols[nCont][13])) + U_SizeCampo("NOME FAVORECIDO")) 					+;
								((Alltrim(ACols[nCont][14]))+U_SizeCampo("SEU NUMERO"))		+	(U_SizeCampo("DATA PAGTO"))                                        	+	(U_SizeCampo("ZEROS2")+Alltrim(Str(ACols[nCont][16])))		+	(U_SizeCampo("VALOR PAGTO")  + Iif(Len( Substr(Str(ACols[nCont][17]),At(".",Str(ACols[nCont][17]))+1,2)) == 2,"0","") + StrTran(Alltrim(Str(ACols[nCont][17])),".","") + Iif(Len( Substr(Str(ACols[nCont][17]),At(".",Str(ACols[nCont][17]))+1,2)) == 1,"0","")  )	+;
								((Alltrim(ACols[nCont][18]))+U_SizeCampo("NOSSO NUMERO"))		+ 	(U_SizeCampo("BRANCOS1")+ Alltrim(ACols[nCont][19]))				+	(U_SizeCampo("DATA EFETIVA"))								+	(U_SizeCampo("VALOR EFETIVO")+ Iif(Len( Substr(Str(ACols[nCont][21]),At(".",Str(ACols[nCont][21]))+1,2)) == 2,"0","") + StrTran(Alltrim(Str(ACols[nCont][21])),".","") + Iif(Len( Substr(Str(ACols[nCont][21]),At(".",Str(ACols[nCont][21]))+1,2)) == 1,"0","")  )	+;
								(U_SizeCampo("NUMERO CONTRATO")+Alltrim(Str(ACols[nCont][22])))+	(U_SizeCampo("NUMERO PARCELA")+Alltrim( ACols[nCont][23]))			+	ACols[nCont][24]											+	(Alltrim(ACols[nCont][25])+U_SizeCampo("CODIGO NAO REPASSE")) 						+;
								(Alltrim(ACols[nCont][26])+U_SizeCampo("CPF FUNCIONARIO"))		+	(U_SizeCampo("DATA VENCTO"))										+	(Alltrim(ACols[nCont][28]) + U_SizeCampo("BRANCOS2"))		+	(Alltrim(ACols[nCont][29] + U_SizeCampo("OCORRENCIAS")))							+	CRLF )				
								lPass := .f.
			ElseIf !Empty(ACols[nCont][4])
			    MsgYesNo("Este funcionario " + ACols[nCont][3]+" - "+ACols[nCont][4] + "  não esta cadastrado na base.")
			Endif
		Next
	Endif
	dbSelectArea("TRB")
	TRB->(dbSkip())
EndDo
fClose(nHdlConf)
Return(ACols)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EmpMigra  ºAutor  ³Equipe R.H.         º Data ³  06/29/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a gravacao na tabela SRC, dos movimentos registros      º±±
±±º          ³importados pelo o sistema, funcionarios acordados.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EmpMigra()
Local _cArqExport	:= IIf(Len(Alltrim(GetMV("MV_CONSFOL")))>0,GetMV("MV_CONSFOL"),Space(70))
Local nHdlConf		:= 0
Local lPass 		:= .t.
Local cDescVerba	:= ""
Local cNumCpf		:= ""
Local cMatric		:= ""
Local cFilFunc		:= ""
Local cNome			:= ""
Local cTipoSrc		:= ""
Local cCentroCusto	:= ""
Local cStatusFunc	:= ""
Local nCont			:= 0

If !MsgYesNo("Os lançamentos serão atualizados na tabela lançamentos mensais (SRC). A partir desta atualização os descontos serão efetuados automaticamente através do cálculo da folha e a baixa de cada parcela através do fechamento mensal.","Importação Folha")
    Return
Endif

If !File(_cArqExport)
	Alert("Analisar, pois esta faltando o arquivo para importacao !!!" + _cArqExport)
	Return
EndIf

For nCont:= 1 to Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tipo de pagamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ACols[nCont][02] <> 11
		Alert("O funcionário : "+ ACols[nCont][4]+" - "+ACols[nCont][13]+", esta com o status que não permite a importação.")
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Matricula do Funcionario.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(ACols[nCont][04])
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicao da Verba, em branco não grava.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(ACols[nCont][05])
		Alert("O funcionário : "+ ACols[nCont][4]+" - "+ACols[nCont][13]+", está sem a verba lançada e não é possivel importar.")
		Loop
	Endif

	cDescVerba		:= fDesc( "SRV" , ACols[nCont][5] , "RV_COD")
	cTipoSrc		:= POSICIONE("SRV",3,xFilial("SRV")+ACols[nCont][5],"SRV->RV_TIPO")
	cNumCpf			:= ACols[nCont][26]

	cCentroCusto	:= POSICIONE("SRA",1,cNumCpf,"SRA->RA_CC")	
	cStatusFunc		:= POSICIONE("SRA",1,cNumCpf,"SRA->RA_SITFOLH")	

	If cStatusFunc == "D"
		Alert("O funcionário : "+ ACols[nCont][4]+" - "+ACols[nCont][13]+", esta DEMITIDO e não permite a importação.")
		Loop	
	Endif

	cMatric		:= ""
	cFilFunc	:= ""
	cNome		:= ""
	lSimNao		:= .t.                      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca pelo o CPF do funcionario de acordo com o indice que foi gerado do SRA com a chave RA_CIC, assim³
	//³eu encontro o nome completo do funcinario quanto a filial e a matricula.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	U_ChekName(cNumCpf,@cMatric,@cFilFunc,@cNome,@lSimNao)
	
    dbSelectArea("SRC")
    dbSetOrder()
	If !dbSeek(cFilFunc+cMatric,.T.)
	                                               
			RecLock("SRC",.T.)
	Else
	 		RecLock("SRC",.F.)
	Endif	
		  	Replace	RC_FILIAL 	With 	ACols[nCont][03]
			Replace	RC_MAT 		With 	cMatric
		    Replace	RC_PD 		With 	ACols[nCont][05]
			Replace	RC_TIPO1	With 	"V"	//cTipoSrc
		    Replace	RC_VALOR	With  	ACols[nCont][17]
		   	Replace	RC_CC		With  	cCentroCusto
		    Replace	RC_TIPO2	With  	"G"
		    Replace	RC_DATA		With  	ACols[nCont][15]
			Replace	RC_PARCELA	With 	ACols[nCont][23]
		MsUnLock()
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Encerra	ºAutor  ³Equipe R.H.         º Data ³  07/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do registros na tabela GPCONSIG.DBF, retorno do    º±±
±±º          ³indice do SRA  e apagar o arquivo temporario.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Encerra(nOpcA)
Local nCont := 0

If nOpcA<>0
	dbSelectArea(cTabAll)
	dbGotop()
	While !Eof()
		If Alltrim(Upper(GPCONSIG->TR_USUARIO)) == Alltrim(Upper(Substr(cUsuario,7,15)))	
			If GPCONSIG->TR_TPREGIS == 3			
				RecLock(cTabAll,.F.,.T.)
			   	dbDelete()                         
			EndIf
		 Endif
		 dbSkip()
	Enddo
	
	dbGotop()
	For nCont:= 1 to Len(aCols)
		RecLock("GPCONSIG",.T.)
			Replace GPCONSIG->TR_TPPAGTO 	WITH 	aCols[nCont][2]
			Replace GPCONSIG->TR_FILIAL		WITH 	aCols[nCont][3]
			Replace GPCONSIG->TR_MAT 		WITH 	aCols[nCont][4]
			Replace GPCONSIG->TR_VERBA	 	WITH 	aCols[nCont][5]
			Replace GPCONSIG->TR_CDBANCO 	WITH 	aCols[nCont][6]
			Replace GPCONSIG->TR_CDLOTE 	WITH 	aCols[nCont][7]
			Replace GPCONSIG->TR_TPREGIS 	WITH 	aCols[nCont][8]
			Replace GPCONSIG->TR_NREGIST 	WITH 	aCols[nCont][9]
			Replace GPCONSIG->TR_SEGMENT 	WITH 	aCols[nCont][10]
			Replace GPCONSIG->TR_TPMOVIM 	WITH 	aCols[nCont][11]
			Replace GPCONSIG->TR_ZEROS1 	WITH 	aCols[nCont][12]
			Replace GPCONSIG->TR_NOMEFAV 	WITH 	aCols[nCont][13]
			Replace GPCONSIG->TR_SEUNUME 	WITH 	aCols[nCont][14]			
			Replace GPCONSIG->TR_DTPAGTO 	WITH 	aCols[nCont][15]
			Replace GPCONSIG->TR_ZEROS2 	WITH 	aCols[nCont][16]
			Replace GPCONSIG->TR_VLPAGTO	WITH 	aCols[nCont][17]
			Replace GPCONSIG->TR_NNUMERO 	WITH 	aCols[nCont][18]
			Replace GPCONSIG->TR_BRANCO1 	WITH 	aCols[nCont][19]
			Replace GPCONSIG->TR_DTAFETI 	WITH 	aCols[nCont][20]
			Replace GPCONSIG->TR_VLEFETI 	WITH 	aCols[nCont][21]
			Replace GPCONSIG->TR_NCONTRA 	WITH 	aCols[nCont][22]
			Replace GPCONSIG->TR_NPARCEL 	WITH 	aCols[nCont][23]
			Replace GPCONSIG->TR_IREPASS 	WITH 	aCols[nCont][24]			
			Replace GPCONSIG->TR_CDNREPA 	WITH 	aCols[nCont][25]
			Replace GPCONSIG->TR_CPF	   	WITH 	aCols[nCont][26]
			Replace GPCONSIG->TR_DTVENCI 	WITH 	aCols[nCont][27]
			Replace GPCONSIG->TR_BRANCO2 	WITH 	aCols[nCont][28]
			Replace GPCONSIG->TR_OCORREN 	WITH 	aCols[nCont][29]
			Replace GPCONSIG->TR_USUARIO 	WITH 	Alltrim(Substr(cUsuario,7,15))
		MsUnLock()
	Next
	
	dbCloseArea(cTabAll)
	__CopyFile(cArqTempAll+".DBF","GPCONSIG.DBF")	
Else
	dbSelectArea("GPCONSIG")
	dbCloseArea("GPCONSIG")
	FErase(cArqTempAll+OrdBagExt())
Endif

dbSelectArea("TRB")
dbCloseArea("TRB")
FErase(cArqTemp+OrdBagExt())
FErase(cArqTemp+".DBF")


dbCloseArea("SRA")
dbSelectArea("SRA")
RetIndex("SRA")
dbSetOrder(1)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SizeCampo ºAutor  ³Equipe R.H.         º Data ³  06/30/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Analisa se eh caracter, numerico ou data e retorna a quanti-º±±
±±º          ³dade de espacos para numerico ou caracter para preencher  o º±±
±±º          ³necessario para ficar alinhado gerar o arquivo TXT.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SizeCampo(_cDesc)
Local nAscan 	:= nTamCampo 	:= 0
Local _cSpace	:= ""

nAscan 		:= Ascan(aHeader, {|e| e[1] == _cDesc })
nTamCampo	:= aHeader[nAscan][4]

If aHeader[nAscan][8] == "C"
	_cSpace		:= (Space(nTamCampo-Len(Alltrim(ACols[nCont][nAscan]))))
ElseiF aHeader[nAscan][8] == "N"
	_cSpace		:= (nTamCampo-Len(Alltrim(Str(ACols[nCont][nAscan] ) )))
	_cSpace		:= IIf(_cSpace>0,Replicate("0",_cSpace),"")	
ElseIf aHeader[nAscan][8] == "D"
	_cSpace		:= Iif(!Empty(ACols[nCont][nAscan]),(Substr(Dtoc(ACols[nCont][nAscan]),1,2)+Substr(Dtoc(ACols[nCont][nAscan]),4,2)+Alltrim(Str(Year(ACols[nCont][nAscan])))),Space(08))
Endif

Return(_cSpace)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChekName  ºAutor  ³Equipe R.H.         º Data ³  07/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca pelo o CPF no SRA e traz o nome, matricula e filial   º±±
±±º          ³do funcionario.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ChekName(_cPf,cMatric,cFilFunc,cNome,lSimNao)

//dbSelectArea("SRA")
RestArea(aAreaSra)
dbGotop()
SRA->(dbSeek( _Cpf , .F. ))
lSimNao	:= .t.

If !Eof()
	cMatric		:= SRA->RA_MAT
	cFilFunc	:= SRA->RA_FILIAL 
	cNome		:= SRA->RA_NOME	
Endif

While !Eof() .And. SRA->RA_CIC == _Cpf
	If SRA->RA_SITFOLH <> "D"	
		cMatric		:= SRA->RA_MAT
		cFilFunc	:= SRA->RA_FILIAL 
		cNome		:= SRA->RA_NOME	
		Exit
	Else
		cMensag	:= cMensag + "O Funcionário "+SRA->RA_MAT+" - "+SRA->RA_NOME+" - Demitido."+ CRLF
		lSimNao	:= .f.		
	Endif	
	SRA->(dbSkip())
EndDo
dbSelectArea("TRB")
Return(_Cpf,@cMatric,@cFilFunc,@cNome,@lSimNao)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaHeaderºAutor  ³Equipe R.H.         º Data ³  07/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Nesta rotina ele monta o aHeader para a MsGetDados          º±±
±±º          ³campos definidos pelo o layOut do banco (Itau).              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MontaHeader()

	Aadd(aHeader,{"IMPORTOU"		,;  						 	// titulo
				 "TR_PROCE"   		,;                        		// campo
				 "@!"				,;                         		// picture
				 3   				,;  							// tamanho
				 0   				,;  						 	// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 ""					,;								// arquivo
				 ""					} )  	                   		// context


	Aadd(aHeader,{"TP_PAGTO"		,;  						 	// titulo
				 "TR_TPPAGTO"  		,;                        		// campo
				 "99"				,;                         		// picture
				 2   				,;  							// tamanho
				 0   				,;  						 	// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 ""					,;								// arquivo
				 ""					} )  	                   		// context


	Aadd(aHeader,{"FILIAL"			,;  						 	// titulo
				 "TR_FILIAL"   		,;                        		// campo
				 "@!"				,;                         		// picture
				 2   				,;  							// tamanho
				 0   				,;  						 	// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 ""					,;								// arquivo
				 ""					} )  	                   		// context


	Aadd(aHeader,{"MATRICULA"		,;  						 	// titulo
				 "TR_MAT"   		,;                        		// campo
				 "@!"				,;                         		// picture
				 6   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                             	// valid
				 "€€€€€€€€€€€€€€°"	,;                             	// usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context


	Aadd(aHeader,{"VERBA"			,;  						 	// titulo
				 "TR_VERBA"   		,;                        		// campo
				 "@!"				,;                         		// picture
				 3   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                             	// valid
				 "€€€€€€€€€€€€€€°"	,;                             	// usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context


	Aadd(aHeader,{"CODIGO BANCO"	,;  						 	// titulo
				 "TR_BANCO"   		,;                        		// campo
				 "999"				,;                     			// picture
				 3   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} ) 							// arquivo - context

	Aadd(aHeader,{"CODIGO DO LOTE"	,;  						 	// titulo
				 "TR_CDLOTE"   		,;                        		// campo
				 "9999"				,;                     			// picture
				 4   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;                              // arquivo - 
				 ""					} )  	                       	// context

	Aadd(aHeader,{"TIPO DE REGISTRO",;  						 	// titulo
				 "TR_TPREGIS"  		,;                        		// campo
				 "9"				,;                    			// picture
				 1   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} )                            	// arquivo - context

	Aadd(aHeader,{"NUMERO REGISTRO"	,;  					 		// titulo
				 "TR_NREGIST"   	,;                        		// campo
				 "99999"			,;                         		// picture
				 5   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;  	                        // valid
				 "€€€€€€€€€€€€€€°" 	,;                             	// usado
				 "N"				,;                             	// tipo
				 " "				,;                             	// arquivo -
				 ""					} )                            	// context

	Aadd(aHeader,{"SEGMENTO"		,; 					 			// titulo
				 "TR_SEGMENT"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 1   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;	                            // usado
				 "C"				,;                              // tipo
				 " "				,;                              // arquivo 
				 ""					} )  	                       	// context
            
	Aadd(aHeader,{"TIPO MOV"		,;					 			// titulo
				 "TR_TPMOVIM"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 3   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;                              // arquivo 
				 ""					} )                            	// context

	Aadd(aHeader,{"ZEROS1"			,; 				 				// titulo
				 "TR_ZEROS1"   		,;                        		// campo
				 "999"				,;                     			// picture
				 3   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;   	                        // tipo
				 " "				,;
				 ""					} )  	                       	// arquivo - context
   
	Aadd(aHeader,{"NOME FAVORECIDO"	,;  						 	// titulo
				 "TR_NOMEFAV"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 30   				,;  							// tamanho
				 0   				,;  						    // decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                       	// arquivo - context
      
                      

	Aadd(aHeader,{"SEU NUMERO"		,;  				 			// titulo
				 "TR_SEUNUME"   	,; 		                       	// campo
				 "@!"				,;                         		// picture
				 20  				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                             	// valid
				 "€€€€€€€€€€€€€€°"	,;                             	// usado
				 "C"				,;                             	// tipo
				 " "				,;
				 ""					} )                           	// arquivo - context

	Aadd(aHeader,{"DATA PAGTO"		,; 				 				// titulo
				 "TR_DTPAGTO"   	,;                        		// campo
				 ""					,;                     			// picture
				 8   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "D"				,;                              // tipo
				 " "				,;
				 ""					} )                            	// arquivo - context

	Aadd(aHeader,{"ZEROS2"			,; 				 				// titulo
				 "TR_ZEROS2"   		,;                    			// campo
				 "999"				,;                         		// picture
				 3   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} )  	                       	// arquivo - context

	Aadd(aHeader,{"VALOR PAGTO"		,;  			 				// titulo
				 "TR_VLPAGTO"   	,;                        		// campo
				 "9999999999999.99"	,;                     			// picture
				 15   				,;  							// tamanho
				 2   				,;  							// decimal
				 ""					,;                              // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} )                           	// arquivo - context

	Aadd(aHeader,{"NOSSO NUMERO"	,;  							// titulo
				 "TR_NNUMERO"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 15		   			,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

	Aadd(aHeader,{"BRANCOS1"		,;  						 	// titulo
				 "TR_BRANCO1"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 5   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;                              // arquivo
				 ""					} )  	                        //  context

	Aadd(aHeader,{"DATA EFETIVA"	,;  						 	// titulo
				 "TR_DTAFETI"   	,;                        		// campo
				 ""					,;                         		// picture
				 8   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "D"				,;                              // tipo
				 " "				,;                              // arquivo
				 ""					} )  	                        // context

	Aadd(aHeader,{"VALOR EFETIVO"	,;  						 	// titulo
				 "TR_VLEFETI"   	,;                        		// campo
				 "999999999999.99"	,;                         		// picture
				 15		   			,;  							// tamanho
				 2   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

	Aadd(aHeader,{"NUMERO CONTRATO",;  						 		// titulo
				 "TR_NCONTRA"   	,;                        		// campo
				 "99999999"			,;                         		// picture
				 8   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

	Aadd(aHeader,{"NUMERO PARCELA"	,;  						 	// titulo
				 "TR_NPARCEL"   	,;                        		// campo
				 "999"				,;                         		// picture
				 3   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "N"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

	Aadd(aHeader,{"INDICADOR REPASSE",;  						 	// titulo
				 "TR_IREPASS"   	,;                        		// campo
				 ""					,;                         		// picture
				 2   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

	Aadd(aHeader,{"CODIGO NAO REPASSE",;  						 	// titulo
				 "TR_CDNREPA"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 2   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

	Aadd(aHeader,{"CPF FUNCIONARIO"	,;  						 	// titulo
				 "TR_CPF"   		,;                        		// campo
				 "@!"				,;                         		// picture
				 11		   			,;  							// tamanho
				 0  				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;                              // arquivo
				 ""					} )  	                        // context

	Aadd(aHeader,{"DATA VENCTO"		,;  						 	// titulo
				 "TR_DTVENCI"   	,;                        		// campo
				 ""					,;                         		// picture
				 8   				,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "D"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context
				 
	Aadd(aHeader,{"BRANCOS2"			,;  						 	// titulo
				 "TR_BRANCO2"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 58		   			,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context
				 
	Aadd(aHeader,{"OCORRENCIAS"		,;  						 	// titulo
				 "TR_OCORREN"   	,;                        		// campo
				 "@!"				,;                         		// picture
				 10		   			,;  							// tamanho
				 0   				,;  							// decimal
				 ""					,;   	                        // valid
				 "€€€€€€€€€€€€€€°"	,;                              // usado
				 "C"				,;                              // tipo
				 " "				,;
				 ""					} )  	                        // arquivo - context

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChamLog   ºAutor  ³Equipe R.H.         º Data ³  15/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava o LOG no momento da rotina de Leitura do arquivo      º±±
±±º          ³assim se estiver alguma diferenca, que nao sucede o importa-º±±
±±º          ³cao do TXT para o aCols, ele grava neste LOG.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ChamLog()
Local nHdlConf := 0
Local _cArqExport	:= "GPCONSIG.LOG"

If !Empty(Alltrim(cMensag))
	If !File(_cArqExport)
		nHdlConf := MSFCREATE(_cArqExport,0)
	Else
		FERASE(_cArqExport)
		nHdlConf := MSFCREATE(_cArqExport,0)
	EndIf

	fWrite(nHdlConf,"A data deste LOG é "+Dtoc(date())+", e as horas "+time()+CRLF)	
	fWrite(nHdlConf,cMensag+ CRLF)
	
	fClose(nHdlConf)  
	Alert("Foi Gerado um LOG de diferenças de leitura, no arquivo  GPCONSIG.LOG")
Endif

Return
