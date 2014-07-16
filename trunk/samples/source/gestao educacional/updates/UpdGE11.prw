#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UpdGE11   ³ Autor ³Icaro Queiroz          ³ Data ³ 28/Ago/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Update feito para criar o parametro MV_ACEXBOL e para      ³±±
±±³          ³ excluir o parametro MV_ACBLDLB. Ambos tem a mesma finalidad³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaGE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UpdGE11() // Detalhes - consultar dados referente ao projeto "PROTHEUS 8 RELEASE 4"
Local cMsg := ""

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados "
cMsg += "para a implementação da melhoria ... "
cMsg += "Esta rotina deve ser processada em modo exclusivo! "
cMsg += "Faça um backup dos dicionários e base de dados antes do processamento!"

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Implementando ..."
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 640
oMainWnd:nHeight := 460
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 2 ) == 2 , ( Processa({|lEnd| GEProc(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Operaçao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cFile     :="" 				//Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}			
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo	:= 49 				//SIGAGE - GESTAO EDUCACIONAL

/********************************************************************************************
Inicia o processamento.
********************************************************************************************/
IncProc("Verificando integridade dos dicionários....")
Conout("Verificando integridade dos dicionários....")

If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
  		If ( nI := Ascan( aRecnoSM0, {|x| x[2] == M0_CODIGO} ) ) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO,{}})
			nI := Len(aRecnoSM0)
		EndIf
		
		aAdd( aRecnoSM0[nI,3], SM0->M0_CODFIL )
		
		dbSkip()
	EndDo	
		
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			lMsFinalAuto := .F.

			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua( nI)
			IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os parametros.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Parametros")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Parametros")			
			cTexto += "Analisando Parametros..."+CHR(13)+CHR(10)
			GEAtuSX6()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Parametros")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Parametros")


			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				Conout( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				cTexto += "Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]"+CHR(13)+CHR(10)
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim Atualizando Estruturas "+aArqUpd[nx])
				Conout( dtoc( Date() )+" "+Time()+" "+"Fim Atualizando Estruturas "+aArqUpd[nx])
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios...")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios...")
			SX3->( Pack() )
			SX6->( Pack() )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")

			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")

			dbSelectArea("JA1")

			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			
			// Atualiza a base de dados da empresa para cada filial
			For nX := 1 To Len(aRecnoSM0[nI,3])

				RpcSetType(2)
				RpcSetEnv(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
				lMsFinalAuto := .F.


				IncProc( dtoc( Date() )+" "+Time()+" "+"Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX] )
				Conout( dtoc( Date() )+" "+Time()+" "+"Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX] )
				cTexto += "Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX]+CHR(13)+CHR(10)

				ProcRegua(nX)
				IncProc("Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX])

				RpcClearEnv()
			Next nX
			
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
			
		Next nI 
		   
		If lOpen

			IncProc( dtoc( Date() )+" "+Time()+" "+"Atualização Concluída." )
			Conout( dtoc( Date() )+" "+Time()+" "+"Atualização Concluída." )
			
			cTexto := "Log da Atualização "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao Concluída." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
			
		EndIf
		
	EndIf
		
EndIf 	

Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³ Icaro Queiroz        ³ Data ³ 28/Ago/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ³        ³      ³                                          ±±
±±³             ³        ³      ³                                         ³±±
±±³             ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GEAtuSX3()
Local aSX3           := {}				//Array com os campos das tabelas
Local aEstrut        := {}              //Array com a estrutura da tabela SX3
Local i              := 0				//Laco para contador
Local j              := 0				//Laco para contador
Local lSX3	         := .F.             //Indica se houve atualizacao
Local cAlias         := ''				//String para utilizacao do noem da tabela
Local cUsadoKey		 := ''				//String que servira para cadastrar um campo como "USADO" em campos chave
Local cReservKey	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos chave
Local cUsadoObr		 := ''				//String que servira para cadastrar um campo como "USADO" em campos obrigatorios
Local cReservObr	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos obrigatorios
Local cUsadoOpc		 := ''				//String que servira para cadastrar um campo como "USADO" em campos opcionais
Local cReservOpc	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos opcionais
Local cUsadoNao		 := ''				//String que servira para cadastrar um campo como "USADO" em campos fora de uso
Local cReservNao	 := ''				//String que servira para cadastrar um campo como "Reservado" em campos fora de uso
Local nPos			 := 0				//Variavel que usado como auxilio na criacao da proxima ordem
Local lCampo		 := .T.				//Controla a inclusao do campo

/*******************************************************************************************
Define a estrutura do array
*******************************************/
aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
			"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
			"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
			"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

/*******************************************************************************************
Seleciona as informacoes de alguns campos para uso posterior
*******************************************/
If SX3->( dbSeek("JAE_CODIGO") ) //Este campo eh chave
	cUsadoKey	:= SX3->X3_USADO
	cReservKey	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("JAE_DESC") ) //Este campo eh obrigatorio e permite alterar
	cUsadoObr	:= SX3->X3_USADO
	cReservObr	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("JAE_DISPAI") ) //Este campo eh opcional e permite alterar
	cUsadoOpc	:= SX3->X3_USADO
	cReservOpc	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("JAE_FILIAL") ) //Este campo nao eh usado
	cUsadoNao	:= SX3->X3_USADO
	cReservNao	:= SX3->X3_RESERV
EndIf
        

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
SX3->( MsSeek( "JA1" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JA1" )
	nPos++
	If X3_CAMPO == "JA1_CENEM " // Tem que deixar esses espacos, porque X3_CAMPO tem 10 posicoes.
		lCampo := .F.
	EndIf
	SX3->( dbSkip() )
Enddo

nPos++
/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************/
//Tabela JBV

If lCampo
	aAdd(aSX3,{	"JA1",;								//Arquivo
				cValToChar(nPos),;					//Ordem
				"JA1_CENEM",;						//Campo
				"C",;								//Tipo
				1,;									//Tamanho
				0,;									//Decimal
				"ENEM",;						    //Titulo
				"ENEM",;						   	//Titulo SPA
				"ENEM",;			    			//Titulo ENG
				"Avaliação pelo ENEM",;				//Descricao
				"Avaliação pelo ENEM",;				//Descricao SPA
				"Avaliação pelo ENEM",;				//Descricao ENG
				"@!",;								//Picture
				"",;								//VALID
				cUsadoOpc,;							//USADO
				"",;								//RELACAO
				"",;								//F3
				1,;									//NIVEL
				cReservOpc,;						//RESERV
				"","","S","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
				"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;	//CBOX, CBOX SPA, CBOX ENG
				"","AC070ENEM()","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
	
	/******************************************************************************************
	Grava informacoes do array no banco de dados
	******************************************************************************************/
	ProcRegua(Len(aSX3))
	
	SX3->(DbSetOrder(2))	
	
	For i:= 1 To Len(aSX3)
	
		If !Empty(aSX3[i][1])
	
			If !dbSeek(aSX3[i,3])
				RecLock("SX3",.T.)		
			Else
				RecLock("SX3",.F.)		
			EndIf
	
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				if aScan(aArqUpd, aSX3[i,1] ) == 0
					aAdd(aArqUpd,aSX3[i,1])
				endif
			EndIf
	
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...")
			Conout("Atualizando Dicionario de Dados...")
	
		EndIf
	Next i   
EndIf

Return 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX6  ³ Autor ³ Icaro Queiroz         ³ Data ³28/Ago/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para criacao do parametro MV_ACEXBOL e exclusao do  ³±±
±±³          ³ parametro MV_ACBLDLB - ambos tem a mesma funcionalidade.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX6()
Local cTexto    := ''						//String para msg ao fim do processo
Local lSx6      := .F.                      //Verifica se houve atualizacao
Local aSx6      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SX6
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ''						//Alias para tabelas
Local cContPor  := ""						//Recebera o conteudo do parametro 
Local cContEsp  := ""						//Recebera o conteudo do parametro 
Local cContIng  := ""						//Recebera o conteudo do parametro 
Local lCamp		:= .T.

/*********************************************************************************************
Define estrutura do array
*********************************************************************************************/
aEstrut:= { "X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
			"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2", "X6_CONTEUD","X6_CONTSPA", "X6_CONTENG",;
			"X6_PROPRI", "X6_PYME"}

dbSelectArea("SX6")
SX6->(DbSetOrder(1))

SX6->( MsSeek( xFilial("SX6") + "MV_ACBLDLB" ) )
While ( ! Eof() )
	If SX6->X6_VAR == "MV_ACBLDLB"
		RecLock( "SX6", .F. )
		cContPor := AllTrim( SX6->X6_CONTEUD )
		cContEsp := AllTrim( SX6->X6_CONTSPA )
		cContIng := AllTrim( SX6->X6_CONTENG )
		SX6->( dbDelete() )
		SX6->( MsUnLock() )
	EndIf	
	SX6->( dbSkip() )
Enddo

SX6->( MsSeek( xFilial("SX6") + "MV_ACEXBOL" ) )
While ( !Eof() )
	If SX6->X6_VAR == "MV_ACEXBOL"
		lCamp := .F.
	EndIf 
	SX6->( dbSkip() ) 
Enddo


/*********************************************************************************************
Define os dados do parametro
*********************************************************************************************/
If lCamp
	aadd(aSx6,{ "MV_ACEXBOL",;											//Var
				"N",;                 				 					//Tipo
				"Permite a exclusao de titulos",;				 		//Descric
				"Permite a exclusao de titulos",; 			  			//DscSpa
				"Permite a exclusao de titulos",;  			 			//DscEng
				"se o mesmo estiver setado com 1",; 		 			//Desc1
				"se o mesmo estiver setado com 1",; 					//DscSpa1
				"se o mesmo estiver setado com 1",; 					//DscEng1
				"",;	 												//Desc2
				"",;													//DscSpa2
				"",;													//DscEng2
				Iif( cContPor == "T", "1", "2" ),;						//Conteud
				Iif( cContEsp == "T", "1", "2" ),;						//ContSpa
				Iif( cContIng == "T", "1", "2" ),;						//ContEng
				"S",;													//Propri
				"S"})													//Pyme
	
	/*********************************************************************************************
	Grava as informacoes do array na tabela six
	*********************************************************************************************/
	ProcRegua(Len(aSx6))
	
	dbSelectArea("SX6")
	SX6->(DbSetOrder(1))
	
	For i:= 1 To Len(aSx6)
		If !Empty(aSx6[i,1])
			If !DbSeek(xFilial("SX6")+aSx6[i,2])
				RecLock("SX6",.T.)
			Else
				RecLock("SX6",.F.)
			EndIf
			
			aAdd(aArqUpd,aSx6[i,1])
			lSx6 := .T.
			If !(aSx6[i,1]$cAlias)
				cAlias += aSx6[i,1]+"/"
			EndIf
			For j:=1 To Len(aSx6[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSx6[i,j])
				EndIf
			Next j
			dbCommit()        
			MsUnLock()
			cTexto  += (aSx6[i][1] + " - " + aSx6[i][3] + Chr(13) + Chr(10))
		EndIf
		IncProc("Atualizando parametros...")
	Next i
	
	If lSx6
		cTexto += "parametros atualizados  : MV_ACEXBOL" + Chr(13)
	EndIf
	
EndIf
	
Return cTexto


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20  
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 	
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf

Return( lOpen )
