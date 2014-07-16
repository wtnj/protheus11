#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGAC03   ³Autora ³ Wilson Tedokon       ³ Data ³ 22/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para implementação da   ³±±
±±³          ³ melhoria relacionada ao Controle de Locais 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGAC03()
Local cMsg := ""

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários de dados para a "
cMsg += "implementação da melhoria relacionada ao Controle de Locais.   "
cMsg += "Esta rotina deve ser processada em modo exclusivo! "
cMsg += "Faça um backup dos dicionários e base de dados antes do processamento!"

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Implementando Controle de Locais"
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 640
oMainWnd:nHeight := 460
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 2 ) == 2 , ( Processa({|lEnd| GACProc(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Operaçao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACProc    ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada para a criação dos dicionários para todas as empre-³±±
±±³          ³ sas e filiais                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACProc(lEnd)
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcRegua(nI)
			IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Limpa chaves unicas e indices para atualização qdo necessario       |      
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Verificando chaves primárias e indices...")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Verificando chaves primárias e indices...")			
			cTexto += "Verificando chaves primárias e indices..."+CHR(13)+CHR(10)
			GACLimpaSX()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de perguntas.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Analisando Dicionario de Perguntas...")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Analisando Dicionario de Perguntas...")			
			cTexto += "Analisando Dicionario de Perguntas..."+CHR(13)+CHR(10)
			GACAtuSX1()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")			
			cTexto += "Analisando Dicionario de Arquivos..."+CHR(13)+CHR(10)
			GACAtuSX2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GACAtuSX3()

			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza parametros.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Parametros")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Parametros")			
			cTexto += "Analisando Parametros..."+CHR(13)+CHR(10)
			GACAtuSX6(SM0->M0_CODIGO)
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Parametros")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Parametros")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Gatilhos")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Gatilhos")			
			cTexto += "Analisando Gatilhos..."+CHR(13)+CHR(10)
			GACAtuSX7()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Gatilhos")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Gatilhos")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			cTexto += "Analisando arquivos de índices. "+CHR(13)+CHR(10)
			GACAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Consultas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes")
			cTexto += "Analisando consultas padroes..."+CHR(13)+CHR(10) 
			GACAtuSxB()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza X3_ORDEM   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Atualizacao Ordem do Dicionario")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Atualizacao Ordem do Dicionario")
			cTexto += "Atualizando ordem do dicionario..."+CHR(13)+CHR(10) 
            AltX3_ORD1()            
            AltX3_ORD2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Atualizacao Ordem do Dicionario")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Atualizacao Ordem do Dicionario")

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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chamar o alias de todas as tabelas alteradas para forçar a criação  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")
			dbSelectArea("JMT")
			dbSelectArea("JA3")
			dbSelectArea("JMM")
			dbSelectArea("JMN")
			dbSelectArea("JMP")
			dbSelectArea("JML")
			dbSelectArea("JMO")
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			
			RpcClearEnv()
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSX1  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SX1                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACAtuSX1()
Local aSX1   	:= {}							//Array que contem as informacoes dos perguntes
Local i			:= 0							//contador de laço no processamento

aAdd( aSX1, {	"GAC010",;		//X1_GRUPO
			 	"11",;			//X1_ORDEM
			 	"Local de ?",;	//X1_PERGUNT
			 	"Local de ?",;	//X1_PERSPA
			 	"Local de ?",;	//X1_PERENG
		   		"MV_CHB",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR11",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC010",;		//X1_GRUPO
			 	"12",;			//X1_ORDEM
			 	"Local até ?",;	//X1_PERGUNT
			 	"Local até ?",;	//X1_PERSPA
			 	"Local até ?",;	//X1_PERENG
		   		"MV_CHC",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR12",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC030",;		//X1_GRUPO
			 	"11",;			//X1_ORDEM
			 	"Local de ?",;	//X1_PERGUNT
			 	"Local de ?",;	//X1_PERSPA
			 	"Local de ?",;	//X1_PERENG
		   		"MV_CHB",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR11",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC030",;		//X1_GRUPO
			 	"12",;			//X1_ORDEM
			 	"Local até ?",;	//X1_PERGUNT
			 	"Local até ?",; //X1_PERSPA
			 	"Local até ?",;	//X1_PERENG
		   		"MV_CHC",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR12",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC040",;		//X1_GRUPO
			 	"09",;			//X1_ORDEM
			 	"Local de ?",;	//X1_PERGUNT
			 	"Local de ?",;	//X1_PERSPA
			 	"Local de ?",;	//X1_PERENG
		   		"MV_CH9",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR09",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC030",;		//X1_GRUPO
			 	"10",;			//X1_ORDEM
			 	"Local até ?",;	//X1_PERGUNT
			 	"Local até ?",;	//X1_PERSPA
			 	"Local até ?",;	//X1_PERENG
		   		"MV_CHA",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR10",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC020",;		//X1_GRUPO
			 	"03",;			//X1_ORDEM
			 	"Local de ?",;	//X1_PERGUNT
			 	"Local de ?",;	//X1_PERSPA
			 	"Local de ?",;	//X1_PERENG
		   		"MV_CH3",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3001",;		//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR03",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC020",;		//X1_GRUPO
			 	"04",;			//X1_ORDEM
			 	"Local até ?",;	//X1_PERGUNT
			 	"Local até ?",;	//X1_PERSPA
			 	"Local até ?",;	//X1_PERENG
		   		"MV_CH4",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3001",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR04",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC050",;		//X1_GRUPO
			 	"10",;			//X1_ORDEM
			 	"Local de ?",;	//X1_PERGUNT
			 	"Local de ?",;	//X1_PERSPA
			 	"Local de ?",;	//X1_PERENG
		   		"MV_CHA",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR10",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GAC050",;		//X1_GRUPO
			 	"11",;			//X1_ORDEM
			 	"Local até ?",;	//X1_PERGUNT
			 	"Local até ?",;	//X1_PERSPA
			 	"Local até ?",;	//X1_PERENG
		   		"MV_CHB",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR11",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GACR01",;		//X1_GRUPO
			 	"03",;			//X1_ORDEM
			 	"Local de ?",;	//X1_PERGUNT
			 	"Local de ?",;	//X1_PERSPA
			 	"Local de ?",;	//X1_PERENG
		   		"MV_CH3",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR03",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

aAdd( aSX1, {	"GACR01",;		//X1_GRUPO
			 	"04",;			//X1_ORDEM
			 	"Local até ?",;	//X1_PERGUNT
			 	"Local até ?",;	//X1_PERSPA
			 	"Local até ?",;	//X1_PERENG
		   		"MV_CH4",;		//X1_VARIAVL
		   		"C",;			//X1_TIPO
		   		6,;				//X1_TAMANHO
		   		0,;				//X1_DECIMAL
		   		0,;				//X1_PRESEL
		   		"G",;			//X1_GSC
		   		"",;			//X1_VALID
		   		"JA3",;			//X1_F3
		   		"",;			//X1_GRPSXG
		   		"",;			//X1_PYME
		   		"MV_PAR04",;    //X1_VAR01
		   		"",;			//X1_DEF01
		   		"",;			//X1_DEFSPA1
		   		"",;			//X1_DEFENG1
		   		"",;			//X1_CNT01
		   		"",;			//X1_DEF02
		   		"",;			//X1_DEFSPA2
		   		"",;			//X1_DEFENG2
		   		"",;			//X1_DEF03
		   		"",;			//X1_DEFSPA3
		   		"",;			//X1_DEFENG3
		   		"",;			//X1_DEF04
		   		"",;			//X1_DEFSPA4
		   		"",;			//X1_DEFENG4
		   		"",;			//X1_DEF05
		   		"",;			//X1_DEFSPA5
		   		"",;			//X1_DEFENG5
		   		{},;			//aHelpPor
				{},;			//aHelpEng
				{},;    		//aHelpSpa
		   		""})	 		//X1_HELP

For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i,1])
		PutSx1(	aSX1[i,1]  ,aSX1[i,2]  ,aSX1[i,3]  ,aSX1[i,4] , aSX1[i,5]  ,aSX1[i,6],;
				aSX1[i,7]  ,aSX1[i,8]  ,aSX1[i,9]  ,aSX1[i,10], aSX1[i,11] ,aSX1[i,12],;
				aSX1[i,13] ,aSX1[i,14] ,aSX1[i,15] ,aSX1[i,16], aSX1[i,17] ,aSX1[i,18],;
				aSX1[i,19] ,aSX1[i,20] ,aSX1[i,21] ,aSX1[i,22], aSX1[i,23] ,aSX1[i,24],;
				aSX1[i,25] ,aSX1[i,26] ,aSX1[i,27] ,aSX1[i,28], aSX1[i,29] ,aSX1[i,30],;
				aSX1[i,31] ,aSX1[i,32] ,aSX1[i,33] ,aSX1[i,34], aSX1[i,35] ,aSX1[i,36])
	EndIf				
Next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSX2  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SX2                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACAtuSX2()
Local aSX2   := {}							//Array que contem as informacoes das tabelas
Local aEstrut:= {}							//Array que contem a estrutura da tabela SX2
Local i      := 0							//Contador para laco
Local j      := 0							//Contador para laco
Local cAlias := ''     						//Nome da tabela
Local cPath									//String para caminho do arquivo 
Local cNome									//String para nome da empresa e filial
Local cModo

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG",;
		   "X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO","X2_PYME"}

dbSelectArea("SX2")
SX2->(DbSetOrder(1))	
MsSeek("SA1") //Seleciona a tabela que eh padrao do sistema para pegar algumas informacoes
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)
cModo := SX2->X2_MODO

aAdd(aSX2,{	"JMT",; 							//X2_CHAVE
			cPath,;								//X2_PATH
			"JMT"+cNome,;						//X2_ARQUIVO
			"Permissões de Operadores",;	    //X2_NOME
			"Permissões de Operadores",;	    //X2_NOMESPA
			"Permissões de Operadores",;	    //X2_NOMEENG
			0,;									//X2_DELET
			"C",;							    //X2_MODO - (C)Compartilhado ou (E)Exclusivo
			"",;								//X2_TTS
			"",;								//X2_ROTINA
			"",;								//X2_UNICO
			"S"})								//X2_PYME

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If SX2->( !dbSeek(aSX2[i,1]) )
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.) 
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH 	:= cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			MsUnLock()
		EndIf
	EndIf
Next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSX3  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SX3                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACAtuSX3()
Local aSX3           := {}				//Array com os campos das tabelas
Local aEstrut        := {}              //Array com a estrutura da tabela SX3
Local i              := 0				//Laco para contador
Local j              := 0				//Laco para contador
Local lSX3	         := .F.             //Indica se houve atualizacao
Local cAlias         := ""				//String para utilizacao do noem da tabela
Local cUsadoKey		 := ""				//String que servira para cadastrar um campo como "USADO" em campos chave
Local cReservKey	 := ""				//String que servira para cadastrar um campo como "Reservado" em campos chave
Local cUsadoObr		 := ""				//String que servira para cadastrar um campo como "USADO" em campos obrigatorios
Local cReservObr	 := ""				//String que servira para cadastrar um campo como "Reservado" em campos obrigatorios
Local cUsadoOpc		 := ""				//String que servira para cadastrar um campo como "USADO" em campos opcionais
Local cReservOpc	 := ""				//String que servira para cadastrar um campo como "Reservado" em campos opcionais
Local cUsadoNao		 := ""				//String que servira para cadastrar um campo como "USADO" em campos fora de uso
Local cReservNao	 := ""				//String que servira para cadastrar um campo como "Reservado" em campos fora de uso
Local cX3UsadoJA3 	 := ""
Local cX3ReserJA3 	 := ""

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

If SX3->( dbSeek("A1_COD") ) //Este campo eh chave
	cUsadoKey	:= SX3->X3_USADO
	cReservKey	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("A1_NOME") ) //Este campo eh obrigatorio e permite alterar
	cUsadoObr	:= SX3->X3_USADO
	cReservObr	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("A1_DDI") ) //Este campo eh opcional e permite alterar
	cUsadoOpc	:= SX3->X3_USADO
	cReservOpc	:= SX3->X3_RESERV
EndIf

If SX3->( dbSeek("A1_FILIAL") ) //Este campo nao eh usado
	cUsadoNao	:= SX3->X3_USADO
	cReservNao	:= SX3->X3_RESERV
EndIf

aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
			"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
			"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
			"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

aAdd(aSX3,{	"JMT",;								//X3_ARQUIVO
			"01",;								//X3_ORDEM
			"JMT_FILIAL",;						//X3_CAMPO
			"C",;								//X3_TIPO
			2,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Filial",; 					    	//X3_TITULO
			"Filial",;  				   		//X3_TITSPA
			"Filial",;      					//X3_TITENG
			"Filial do Sistema",;	   		    //X3_DESCRIC
			"Filial do Sistema",;				//X3_DESCSPA
			"Filial do Sistema",;				//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;								//X3_VALID
			cUsadoNao,;							//X3_USADO
			'"2"',;								//X3_RELACAO
			"",;								//X3_F3
			1,;									//X3_NIVEL
			cReservNao,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                            	//X3_OBRIGAT
			"",;								//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;								//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMT",;								//X3_ARQUIVO
			"02",;								//X3_ORDEM
			"JMT_CODUSR",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Cod. Usuario",;			    	//X3_TITULO
			"Cod. Usuario",;			   		//X3_TITSPA
			"Cod. Usuario",;					//X3_TITENG
			"Codigo do Usuario",;	   		    //X3_DESCRIC
			"Codigo do Usuario",;   			//X3_DESCSPA
			"Codigo do Usuario",;				//X3_DESCENG
			"999999",;							//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoKey,;							//X3_USADO
			"",;								//X3_RELACAO
			"",;								//X3_F3
			1,;									//X3_NIVEL
			cReservKey,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                            	//X3_OBRIGAT
			"",;								//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;								//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMT",;								//X3_ARQUIVO
			"03",;								//X3_ORDEM
			"JMT_CODLOC",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Cod. Local",;	       		    	//X3_TITULO
			"Cod. Local",;	                	//X3_TITSPA
			"Cod. Local",;	                	//X3_TITENG
			"Codigo do Local",;                	//X3_DESCRIC
			"Codigo do Local",;                	//X3_DESCSPA
			"Codigo do Local",;                	//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoObr,;							//X3_USADO
			"",;								//X3_RELACAO
			"",;								//X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                            	//X3_OBRIGAT
			"",;								//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;								//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMT",;								//X3_ARQUIVO
			"04",;								//X3_ORDEM
			"JMT_TIPPER",; 						//X3_CAMPO
			"C",;								//X3_TIPO
			1,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Permite Exc. Lim.",;			    //X3_TITULO
			"Permite Exc. Lim.",;			    //X3_TITSPA
			"Permite Exc. Lim.",;			    //X3_TITENG
			"Permite Exceder Limites?",;		    //X3_DESCRIC
			"Permite Exceder Limites?",;		    //X3_DESCSPA
			"Permite Exceder Limites?",;		    //X3_DESCENG
			"9",;								//X3_PICTURE
			'Pertence("12")',;                  //X3_VALID
			cUsadoOpc,;							//X3_USADO
			"",;								//X3_RELACAO
			"",;								//X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                            	//X3_OBRIGAT
			"",;   					            //X3_VLDUSER
			"1=Sim;2=Não",;                     //X3_CBOX
			"1=Sim;2=Não",;                     //X3_CBOXSPA
			"1=Sim;2=Não",;                     //X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME
			
aAdd(aSX3,{	"JA3",;								//X3_ARQUIVO
			"14",;								//X3_ORDEM
			"JA3_ACERVO",; 						//X3_CAMPO
			"C",;								//X3_TIPO
			1,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Acervo?",;         			    //X3_TITULO
			"Acervo?",;         			    //X3_TITSPA
			"Acervo?",;         			    //X3_TITENG
			"O local e um Acervo?",;         	//X3_DESCRIC
			"O local e um Acervo?",;         	//X3_DESCSPA
			"O local e um Acervo?",;         	//X3_DESCENG
			"@!",;								//X3_PICTURE
			'Pertence("123")',;                 //X3_VALID
			cUsadoObr,;							//X3_USADO
			'"3"',;								//X3_RELACAO
			"",;								//X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                            	//X3_OBRIGAT
			"",;            					//X3_VLDUSER
			"1=Sim;2=Não",;                     //X3_CBOX
			"1=Sim;2=Não",;                     //X3_CBOXSPA
			"1=Sim;2=Não",;                     //X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME
			
aAdd(aSX3,{	"JMM",;								//X3_ARQUIVO
			"21",;								//X3_ORDEM
			"JMM_LOCACE",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Local Exemp.",;      		    	//X3_TITULO
			"Local Exemp.",;       		   		//X3_TITSPA
			"Local Exemp.",;    				//X3_TITENG
			"Local Exemplar",;      		    //X3_DESCRIC
			"Local Exemplar",;     		     	//X3_DESCSPA
			"Local Exemplar",;      			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoOpc,;							//X3_USADO
			'POSICIONE("JA3",1,XFILIAL("JA3")+ POSICIONE("JM1",1,XFILIAL("JM1")+JMM->JMM_EXEMPL,"JM1->JM1_LOCACE") ,"JA3->JA3_CODLOC")',;//X3_RELACAO
			"",;							    //X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMM",;								//X3_ARQUIVO
			"22",;								//X3_ORDEM
			"JMM_DESLOC",;						//X3_CAMPO
			"C",;								//X3_TIPO
			30,;								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Desc. Local",;      		    	//X3_TITULO
			"Desc. Local",;       		   		//X3_TITSPA
			"Desc. Local",;      				//X3_TITENG
			"Descricao do Local",;     		    //X3_DESCRIC
			"Descricao do Local",;  			//X3_DESCSPA
			"Descricao do Local",;   			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoOpc,;							//X3_USADO
			'POSICIONE("JA3",1,XFILIAL("JA3")+ POSICIONE("JM1",1,XFILIAL("JM1")+JMM->JMM_EXEMPL,"JM1->JM1_LOCACE") ,"JA3->JA3_DESLOC")',;//X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME
			
aAdd(aSX3,{	"JMN",;								//X3_ARQUIVO
			"12",;								//X3_ORDEM
			"JMN_LOCACE",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Local Exemp.",;      		    	//X3_TITULO
			"Local Exemp.",;       		   		//X3_TITSPA
			"Local Exemp.",;    				//X3_TITENG
			"Local Exemplar",;      		    //X3_DESCRIC
			"Local Exemplar",;     		     	//X3_DESCSPA
			"Local Exemplar",;      			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoOpc,;							//X3_USADO
			'POSICIONE("JA3",1,XFILIAL("JA3")+ POSICIONE("JM1",1,XFILIAL("JM1")+JMN->JMN_EXEMPL,"JM1->JM1_LOCACE") ,"JA3->JA3_CODLOC")',;//X3_RELACAO
			"",;							    //X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMN",;								//X3_ARQUIVO
			"13",;								//X3_ORDEM
			"JMN_DESLOC",;						//X3_CAMPO
			"C",;								//X3_TIPO
			30,;								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Desc. Local",;      		    	//X3_TITULO
			"Desc. Local",;       		   		//X3_TITSPA
			"Desc. Local",;      				//X3_TITENG
			"Descricao do Local",;     		    //X3_DESCRIC
			"Descricao do Local",;  			//X3_DESCSPA
			"Descricao do Local",;   			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoOpc,;							//X3_USADO
			'POSICIONE("JA3",1,XFILIAL("JA3")+ POSICIONE("JM1",1,XFILIAL("JM1")+JMN->JMN_EXEMPL,"JM1->JM1_LOCACE") ,"JA3->JA3_DESLOC")',;//X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME
			
aAdd(aSX3,{	"JMN",;								//X3_ARQUIVO
			"14",;								//X3_ORDEM
			"JMN_CODUSU",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,; 								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Cod. Usuario",;      		    	//X3_TITULO
			"Cod. Usuario",;      		    	//X3_TITSPA
			"Cod. Usuario",;      		    	//X3_TITENG
			"Cod. Usuario",;      		    	//X3_DESCRIC
			"Cod. Usuario",;      		    	//X3_DESCSPA
			"Cod. Usuario",;      		    	//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoNao,;							//X3_USADO
			"",;                                //X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservNao,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMN",;								//X3_ARQUIVO
			"05",;								//X3_ORDEM
			"JMN_EXEMPL",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,; 								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Cod. Exemplar",;      		    	//X3_TITULO
			"Cod. Ejemplar",;      		    	//X3_TITSPA
			"Exemplar Cd.",;      		    	//X3_TITENG
			"Codigo Exemplar",;   		    	//X3_DESCRIC
			"Codigo. Ejemplar",;  		    	//X3_DESCSPA
			"Exemplar Code",;      		    	//X3_DESCENG
			"",;								//X3_PICTURE
			'ExistCpo("JM1",M->JMN_EXEMPL)',;                                //X3_VALID
			cUsadoNao,;							//X3_USADO
			"",;                                //X3_RELACAO
			"JM1001",;     						//X3_F3
			1,;									//X3_NIVEL
			cReservNao,;						//X3_RESERV
			"",;								//X3_CHECK
			"S",;                               //X3_TRIGGER
			"",;                                //X3_PROPRI
			"S",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMP",;								//X3_ARQUIVO
			"05",;								//X3_ORDEM
			"JMP_LOCACE",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Local Exemp.",;      		    	//X3_TITULO
			"Local Exemp.",;       		   		//X3_TITSPA
			"Local Exemp.",;    				//X3_TITENG
			"Local Exemplar",;      		    //X3_DESCRIC
			"Local Exemplar",;     		     	//X3_DESCSPA
			"Local Exemplar",;      			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoObr,;							//X3_USADO
			'POSICIONE("JA3",1,XFILIAL("JA3")+ POSICIONE("JM1",1,XFILIAL("JM1")+JMP->JMP_EXEMPL,"JM1->JM1_LOCACE") ,"JA3->JA3_CODLOC")',;//X3_RELACAO
			"",;							    //X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMP",;								//X3_ARQUIVO
			"06",;								//X3_ORDEM
			"JMP_DESLOC",;						//X3_CAMPO
			"C",;								//X3_TIPO
			30,;								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Desc. Local",;      		    	//X3_TITULO
			"Desc. Local",;       		   		//X3_TITSPA
			"Desc. Local",;      				//X3_TITENG
			"Descricao do Local",;     		    //X3_DESCRIC
			"Descricao do Local",;  			//X3_DESCSPA
			"Descricao do Local",;   			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoObr,;							//X3_USADO
			'POSICIONE("JA3",1,XFILIAL("JA3")+ POSICIONE("JM1",1,XFILIAL("JM1")+JMP->JMP_EXEMPL,"JM1->JM1_LOCACE") ,"JA3->JA3_DESLOC")',;//X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JML",;								//X3_ARQUIVO
			"07",;								//X3_ORDEM
			"JML_MAXEMP",;						//X3_CAMPO
			"N",;								//X3_TIPO
			3,;  								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Qtd Max Empr",;    		    	//X3_TITULO
			"Qtd Max Empr",;       		   		//X3_TITSPA
			"Qtd Max Empr",;     				//X3_TITENG
			"Qtd maxima de emprestimo",;	    //X3_DESCRIC
			"Qtd maxima de emprestimo",;        //X3_DESCSPA
			"Qtd maxima de emprestimo",;		//X3_DESCENG
			"999",;								//X3_PICTURE
			"POSITIVO()",;                      //X3_VALID
			cUsadoOpc,;							//X3_USADO
			"",;                                //X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JML",;								//X3_ARQUIVO
			"13",;								//X3_ORDEM
			"JML_MAXRES",;						//X3_CAMPO
			"N",;								//X3_TIPO
			3,;  								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Qtd Max Res",;     		    	//X3_TITULO
			"Qtd Max Res",;       		   		//X3_TITSPA
			"Qtd Max Res",;     				//X3_TITENG
			"Qtd maxima de reservas",;  	    //X3_DESCRIC
			"Qtd maxima de reservas",;          //X3_DESCSPA
			"Qtd maxima de reservas",;  		//X3_DESCENG
			"999",;								//X3_PICTURE
			"POSITIVO()",;                      //X3_VALID
			cUsadoOpc,;							//X3_USADO
			"",;                                //X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservOpc,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMO",;								//X3_ARQUIVO
			"12",;								//X3_ORDEM
			"JMO_LOCACE",;						//X3_CAMPO
			"C",;								//X3_TIPO
			6,;									//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Local Prefer",;      		    	//X3_TITULO
			"Local Prefer",;       		   		//X3_TITSPA
			"Local Prefer",;    				//X3_TITENG
			"Local Preferencia",;      		    //X3_DESCRIC
			"Local Preferencia",;     		   	//X3_DESCSPA
			"Local Preferencia",;      			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"M->JMO_LOCACE $ GACVFLOC() .Or. Vazio()",;//X3_VALID
			cUsadoObr,;							//X3_USADO
			"",;                                //X3_RELACAO
			"JA3001",;						    //X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"",;								//X3_VISUAL
			"",;                                //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMO",;								//X3_ARQUIVO
			"13",;								//X3_ORDEM
			"JMO_DESLOC",;						//X3_CAMPO
			"C",;								//X3_TIPO
			30,;								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Desc. Local",;      		    	//X3_TITULO
			"Desc. Local",;       		   		//X3_TITSPA
			"Desc. Local",;      				//X3_TITENG
			"Descricao do Local",;     		    //X3_DESCRIC
			"Descricao do Local",;  			//X3_DESCSPA
			"Descricao do Local",;   			//X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoObr,;							//X3_USADO
			'IF(!INCLUI,POSICIONE("JA3",1,XFILIAL("JA3")+M->JMO_LOCACE,"JA3->JA3_DESLOC"),"")',;//X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"N",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                             	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			"",;                                //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMR",;								//X3_ARQUIVO
			"05",;								//X3_ORDEM
			"JMR_AUTNOM",;						//X3_CAMPO
			"C",;								//X3_TIPO
			40,;  								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Nome Autor",;        		    	//X3_TITULO
			"Nombre Autor",;      		    	//X3_TITSPA
			"Author Name",;       		    	//X3_TITENG
			"Nome do Autor",;        		    //X3_DESCRIC
			"Nombre del Autor",;      		    //X3_DESCSPA
			"Author Name",;           		    //X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoObr,;							//X3_USADO
			'If(!Inclui .And. IsMemVar("JMR_AUTOR"), Posicione("JMF",1,xFilial("JMF")+M->JMR_AUTOR,"JMF->JMF_NOME"), "")',; //X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"S",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			'Posicione("JMF",1,xFilial("JMF")+JMR->JMR_AUTOR,"JMF->JMF_NOME")',; //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

aAdd(aSX3,{	"JMS",;								//X3_ARQUIVO
			"05",;								//X3_ORDEM
			"JMS_AUTNOM",;						//X3_CAMPO
			"C",;								//X3_TIPO
			40,;  								//X3_TAMANHO
			0,;									//X3_DECIMAL
			"Nome Autor",;        		    	//X3_TITULO
			"Nombre Autor",;      		    	//X3_TITSPA
			"Author Name",;       		    	//X3_TITENG
			"Nome do Autor",;        		    //X3_DESCRIC
			"Nombre del Autor",;      		    //X3_DESCSPA
			"Author Name",;           		    //X3_DESCENG
			"@!",;								//X3_PICTURE
			"",;                                //X3_VALID
			cUsadoObr,;							//X3_USADO
			'If(!Inclui .And. IsMemVar("JMS_AUTOR"), Posicione("JMF",1,xFilial("JMF")+M->JMS_AUTOR,"JMF->JMF_NOME"), "")',; //X3_RELACAO
			"",;	     						//X3_F3
			1,;									//X3_NIVEL
			cReservObr,;						//X3_RESERV
			"",;								//X3_CHECK
			"",;                                //X3_TRIGGER
			"",;                                //X3_PROPRI
			"S",;                               //X3_BROWSE
			"V",;								//X3_VISUAL
			"V",;                               //X3_CONTEXT
			"",;                               	//X3_OBRIGAT
			"",;                            	//X3_VLDUSER
			"",;                                //X3_CBOX
			"",;                                //X3_CBOXSPA
			"",;			        			//X3_CBOXENG
			"",;                                //X3_PICTVAR
			"",;								//X3_WHEN
			'Posicione("JMF",1,xFilial("JMF")+JMS->JMS_AUTOR,"JMF->JMF_NOME")',; //X3_INIBRW
			"",;                                //X3_GRPSXG
			"",;                                //X3_FOLDER
			"S"})								//X3_PYME

SX3->(DbSetOrder(2))	

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				if aScan(aArqUpd, aSX3[i,1] ) == 0
					aAdd(aArqUpd,aSX3[i,1])
				endif
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			MsUnLock()
		Endif
	EndIf
Next i

//Atualizando campo X3_USADO da Tabela JA3 e JDI.
//Motivo: Essa tabela estava cadastrada para uso somente no GE.
SX3->(DbSetOrder(1))
If dbSeek("JA3")
	Do While !EOF() .And. SX3->X3_ARQUIVO == "JA3"
		cX3UsadoJA3 := ""
		cX3ReserJA3 := ""
		If AllTrim(SX3->X3_CAMPO) == "JA3_FILIAL"
			cX3UsadoJA3 := cUsadoNao
			cX3ReserJA3 := cReservNao
		ElseIf AllTrim(SX3->X3_CAMPO) == "JA3_CODLOC"
			cX3UsadoJA3 := cUsadoKey
			cX3ReserJA3 := cReservKey
		ElseIf 	AllTrim(SX3->X3_CAMPO) == "JA3_DESLOC" .OR. ;
				AllTrim(SX3->X3_CAMPO) == "JA3_TIPO"   .OR. ;
				AllTrim(SX3->X3_CAMPO) == "JA3_ACERVO"
			cX3UsadoJA3 := cUsadoObr
			cX3ReserJA3 := cReservObr
		Else 
			//"JA3_CGC" / "JA3_CEP" / "JA3_END" / "JA3_NUMEND" / "JA3_COMPLE" / "JA3_BAIRRO" /
			//"JA3_CIDADE" / "JA3_EST" / "JA3_FONE" / "JA3_LOGO" / "JA3_MAPA"
			cX3UsadoJA3 := cUsadoOpc
			cX3ReserJA3 := cReservOpc
		EndIf

		If Len(cX3UsadoJA3) > 0
			RecLock("SX3", .F.)
				SX3->X3_USADO := cX3UsadoJA3
				SX3->X3_USADO := cX3UsadoJA3
			MsUnlock()
		EndIf
		SX3->(DbSkip())
	EndDo
EndIf           

//JDI
SX3->(DbSetOrder(1))
If dbSeek("JDI")
	Do While !EOF() .And. SX3->X3_ARQUIVO == "JDI"
		cX3UsadoJA3 := ""
		cX3ReserJA3 := ""
		If AllTrim(SX3->X3_CAMPO) == "JDI_FILIAL" .Or. AllTrim(SX3->X3_CAMPO) == "JDI_CODLOC"
			cX3UsadoJA3 := cUsadoNao
			cX3ReserJA3 := cReservNao
		Else
			//JDI_ITEM / JDI_INSINI / JDI_INSFIM / JDI_BOLINI / JDI_BOLFIM
			cX3UsadoJA3 := cUsadoObr
			cX3ReserJA3 := cReservObr
		EndIf

		If Len(cX3UsadoJA3) > 0
			RecLock("SX3", .F.)
				SX3->X3_USADO := cX3UsadoJA3
				SX3->X3_USADO := cX3UsadoJA3
			MsUnlock()
		EndIf
		SX3->(DbSkip())
	EndDo
EndIf           

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSX6  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SX6                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GacAtuSX6( cCodFilial )
Local lSx6      := .F.                      //Verifica se houve atualizacao
Local aSx6      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SX6
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ""						//Alias para tabelas

aEstrut:= { "X6_Filial","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
			"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA", "X6_CONTENG",;
			"X6_PROPRI", "X6_PYME"}

aAdd(aSx6,{cCodFilial,;						//X6_Filial
		"",;								//X6_VAR
		"",;                 				//X6_TIPO
		"",; 								//X6_DESCRIC
		"",; 								//X6_DSCSPA
		"",; 								//X6_DSCENG
		"",;								//X6_DESC1
		"",;								//X6_DSCSPA1
		"",;								//X6_DSCENG1
		"",; 								//X6_DESC2
		"",;								//X6_DSCSPA2
		"",;								//X6_DSCENG2
		"",;								//X6_CONTEUD
		"",;								//X6_CONTSPA
		"",;								//X6_CONTENG
		"S",;								//X6_PROPRI		
		"S"})								//X6_PYME

dbSelectArea("SX6")
SX6->(DbSetOrder(1))	

For i:= 1 To Len(aSx6)
	If !Empty(aSx6[i,1]) .And. !Empty(aSx6[i,2])
		If !DbSeek(aSx6[i,1]+aSx6[i,2])
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
		MsUnLock()
	EndIf
Next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSX7  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SX7                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACAtuSX7()

Local aSX7   := {}					//Array que contera os dados dos gatilhos
Local aEstrut:= {}					//Array que contem a estrutura da tabela SX7
Local i      := 0					//Contador para laco
Local j      := 0					//Contador para laco

aEstrut:= { "X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS",;
			"X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}

aAdd(aSX7,{	"JMN_EXEMPL",;			//X7_CAMPO
			"004",;					//X7_SEQUENC
			"GACVLOCAL(M->JMN_EXEMPL)",;//X7_REGRA
			"JMN_LOCACE",;          //X7_CDOMIN
			"P",;              		//X7_TIPO
			"N",;  					//X7_SEEK
			"",;					//X7_ALIAS
			0,;						//X7_ORDEM
			"",;					//X7_CHAVE
			"S",;					//X7_PROPRI
			""})					//X7_CONDIC

aAdd(aSX7,{	"JMP_EXEMPL",;			//X7_CAMPO
			"003",;					//X7_SEQUENC
			"GACCodLoc(M->JMP_EXEMPL)",;//X7_REGRA
			"JMP_LOCACE",;          //X7_CDOMIN
			"P",;              		//X7_TIPO
			"N",;  					//X7_SEEK
			"",;					//X7_ALIAS
			0,;						//X7_ORDEM
			"",;					//X7_CHAVE
			"S",;					//X7_PROPRI
			""})					//X7_CONDIC

aAdd(aSX7,{	"JMP_EXEMPL",;			//X7_CAMPO
			"004",;					//X7_SEQUENC
			"GACDesLoc(M->JMP_EXEMPL)",;//X7_REGRA
			"JMP_DESLOC",;          //X7_CDOMIN
			"P",;              		//X7_TIPO
			"N",;  					//X7_SEEK
			"",;					//X7_ALIAS
			0,;						//X7_ORDEM
			"",;					//X7_CHAVE
			"S",;					//X7_PROPRI
			""})					//X7_CONDIC

aAdd(aSX7,{	"JMO_LOCACE",;			//X7_CAMPO
			"001",;					//X7_SEQUENC
			'POSICIONE("JA3",1,XFILIAL("JA3")+M->JMO_LOCACE,"JA3->JA3_DESLOC")',;//X7_REGRA
			"JMO_DESLOC",;          //X7_CDOMIN
			"P",;              		//X7_TIPO
			"S",;  					//X7_SEEK
			"",;					//X7_ALIAS
			0,;						//X7_ORDEM
			"",;					//X7_CHAVE
			"S",;					//X7_PROPRI
			""})					//X7_CONDIC

dbSelectArea("SX7")
SX7->(DbSetOrder(1))	

For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !Msseek(aSX7[i,1]+aSX7[i,2])
			RecLock("SX7",.T.)
		Else	
			RecLock("SX7",.F.)
		Endif	
		For j:=1 To Len(aSX7[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
			EndIf
		Next j
		MsUnLock()
	EndIf
Next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSIX  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SIX                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACAtuSIX()
Local lSix      := .F.                      //Verifica se houve atualizacao
Local aSix      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SiX
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ''						//Alias para tabelas
Local lDelInd   := .F.

aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3",;
		   "NICKNAME","SHOWPESQ"}

aAdd(aSIX,{	"JMT",;   						//INDICE
			"1",;                           //ORDEM
			"JMT_FILIAL+JMT_CODUSR+JMT_CODLOC",;//CHAVE
			"Cod. Usuario + Cod. Local",;  	//DESCRICAO
			"Cod. Usuario + Cod. Local",;   //DESCSPA
			"Cod. Usuario + Cod. Local",;  	//DESCENG
			"S",; 							//PROPRI
			"",;  							//F3
			"",;  							//NICKNAME
			"S"}) 							//SHOWPESQ  


dbSelectArea("SIX")
SIX->(DbSetOrder(1))	

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !MsSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
			lDelInd := .F.
		Else
			RecLock("SIX",.F.)
			lDelInd := .T. //Se for alteracao precisa apagar o indice do banco
		EndIf
		
		If UPPER(AllTrim(CHAVE)) != UPPER(Alltrim(aSIX[i,3]))
			if aScan(aArqUpd, aSIX[i,1]) == 0
				aAdd(aArqUpd,aSIX[i,1])
			endif
			
			lSix := .T.
			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			MsUnLock()
			If lDelInd
				TcInternal(60,RetSqlName(aSix[i,1]) + "|" + RetSqlName(aSix[i,1]) + aSix[i,2]) //Exclui sem precisar baixar o TOP
			Endif	
		EndIf
	EndIf
Next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACAtuSXB  ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a manutenção da tabela SXB                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACAtuSXB()
Local lSXB      := .F.                      //Verifica se houve atualizacao
Local aSXB      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SXB
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define estrutura do array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEstrut:= {"XB_ALIAS", "XB_TIPO", "XB_SEQ", "XB_COLUNA", "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM", "XB_WCONTEM"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os novos conteudos dos filtros das consultas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aSXB,{	"JM1001",;    //XB_ALIAS
			"6",;         //XB_TIPO
			"",;          //XB_SEQ
			"",;	      //XB_COLUNA
			"",;	  	  //XB_DESCRI
			"",;	  	  //XB_DESCSPA
			"",;       	  //XB_DESCENG
			'If(AllTrim(Upper(FunName())) == "GACA100", .T., &("JM1->JM1_LOCACE = GACXGETLOC()"))',;
			""})	      //XB_WCONTEM

aAdd(aSXB,{	"JA3001",;    //XB_ALIAS
			"1",;         //XB_TIPO
			"01",;        //XB_SEQ
			"DB",;	      //XB_COLUNA
			"Locais",;	  //XB_DESCRI
			"Locais",;	  //XB_DESCSPA
			"Locais",;    //XB_DESCENG
			"JA3",;       //XB_CONTEM
			""})	      //XB_WCONTEM

aAdd(aSXB,{	"JA3001",;    //XB_ALIAS
			"2",;         //XB_TIPO
			"01",;        //XB_SEQ
			"01",;	      //XB_COLUNA
			"Local",;	  //XB_DESCRI
			"Local",;	  //XB_DESCSPA
			"Local",;	  //XB_DESCENG
			"",;          //XB_CONTEM
			""})          //XB_WCONTEM

aAdd(aSXB,{	"JA3001",;    //XB_ALIAS
			"4",;         //XB_TIPO
			"01",;        //XB_SEQ
			"01",;	      //XB_COLUNA
			"Codigo do Local",;	 //XB_DESCRI
			"Codigo do Local",;  //XB_DESCSPA
			"Codigo do Local",;  //XB_DESCENG
			"JA3_CODLOC",;       //XB_CONTEM
			""})          //XB_WCONTEM

aAdd(aSXB,{	"JA3001",;    //XB_ALIAS
			"4",;         //XB_TIPO
			"01",;        //XB_SEQ
			"02",;	      //XB_COLUNA
			"Descricao do Local",;  //XB_DESCRI
			"Descricao do Local",;  //XB_DESCSPA
			"Descricao do Local",;  //XB_DESCENG
			"JA3_DESLOC",;          //XB_CONTEM
			""})          //XB_WCONTEM

aAdd(aSXB,{	"JA3001",;    //XB_ALIAS
			"5",;         //XB_TIPO
			"01",;        //XB_SEQ
			"",;	      //XB_COLUNA
			"",;          //XB_DESCRI
			"",;          //XB_DESCSPA
			"",;          //XB_DESCENG
			"JA3->JA3_CODLOC",;     //XB_CONTEM
			""})          //XB_WCONTEM

aAdd(aSXB,{	"JA3001",;    //XB_ALIAS
			"6",;         //XB_TIPO
			"",;        //XB_SEQ
			"",;	      //XB_COLUNA
			"",;          //XB_DESCRI
			"",;          //XB_DESCSPA
			"",;          //XB_DESCENG
			'JA3->JA3_CODLOC $ GACVFLOC()',;     //XB_CONTEM
			""})          //XB_WCONTEM

dbSelectArea("SXB")
SXB->(dbSetOrder(1)) //XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA	

For i := 1 To Len(aSXB)   
	If !Empty(aSXB[i,1])
		If !dbSeek(PadR(aSXB[i,1],6)+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			RecLock("SXB",.T.)
		Else
			RecLock("SXB",.F.)
		EndIf
		lSxB := .T.
		For j:=1 To Len(aSXB[i])
			If FieldPos(aEstrut[j]) > 0
				FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
			EndIf
		Next j
		MsUnLock()
	EndIf	
Next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyOpenSM0Ex³Autor  ³ Sergio Silveira      ³ Data ³ 07/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GACLimpaSX ³Autora ³ Solange Zanardi      ³ Data ³ 28/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inicialmente apaga registros já criados em caso de reproc. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GACLimpaSX()
Local i			:= 0		//Contador de Laço
Local aDelSX2	:= {}       //Alias de tabela para remocao de chave primaria
Local aDelSIX	:= {}		//Alias de tabela para remocao de indices
Local aDelSXB	:= {}		//Nome de consultas padroes para remocao
Local aDelSX3	:= {"JMR_AUTNOM", "JMS_AUTNOM"} //Nome de campos do dicionário para remocao

SX2->( dbSetOrder(1) )
for i := 1 to len( aDelSX2 )
	if SX2->( dbSeek( aDelSX2[i] ) )
		TCSQLExec("DROP INDEX "+RetSQLName(aDelSX2[i])+"."+RetSQLName(aDelSX2[i])+"_UNQ")
		RecLock( "SX2", .F. )
		SX2->( dbDelete() )
		SX2->( msUnlock() )
	endif
next i

SIX->( dbSetOrder(1) )
for i := 1 to len( aDelSIX )
	if SIX->( dbSeek( aDelSIX[i] ) )
		RecLock( "SIX", .F. )
		SIX->( dbDelete() )
		SIX->( msUnlock() )
	endif
next i

SXB->( dbSetOrder(1) )
for i := 1 to len( aDelSXB )
	while SXB->( dbSeek( aDelSXB[i] ) )
		RecLock( "SXB", .F. )
		SXB->( dbDelete() )
		SXB->( msUnlock() )
	end
next i

SX3->( dbSetOrder(2) )
for i := 1 to len( aDelSX3 )
	if SX3->( dbSeek( aDelSX3[i] ) )
		RecLock( "SX3", .F. )
		SX3->( dbDelete() )
		SX3->( msUnlock() )
	endif
next i

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AltX3_ORD1  ³Autor  ³Wilson Jorge Tedokon ³ Data ³ 10/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a alteração do X3_ORDEM                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AltX3_ORD1()
Local i             := 0						   	//Contador para laco
Local aAltX3_ORDEM	:= {} //Nome de campos que terao o X3_ORDEM ALTERADOS somando 1
Local lAtuX3_ORDEM  := .T.

aAltX3_ORDEM	:= {"JMR_TIPO", "JMS_TIPO", "JA3_LOGO", "JA3_MAPA" }

SX3->( dbSetOrder(2) )   


// Verifica se a rotina de atualizacao da ordem do SX3 foi executada.

if SX3->( dbSeek( aAltX3_ORDEM[1] ) )
  if SX3->X3_ORDEM == "06"
    lAtuX3_ORDEM  := .F.
  endif
endif  

// Atualiza o X3_ORDEM apenas na primeira vez que o programa e executado.
if lAtuX3_ORDEM
  for i := 1 to len( aAltX3_ORDEM )
    if SX3->( dbSeek( aAltX3_ORDEM[i] ) )
	  RecLock( "SX3", .F. )
	  SX3->X3_ORDEM:= Soma1(SX3->X3_ORDEM, 2)
	  SX3->( msUnlock() )
	endif
  next i
endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AltX3_ORD2  ³Autor  ³Wilson Jorge Tedokon ³ Data ³ 10/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua a alteração do X3_ORDEM                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AltX3_ORD2()
Local i             := 0						   	//Contador para laco
Local aAltX3_ORDEM	:= {} //Nome de campos que terao o X3_ORDEM ALTERADOS somando 2
Local lAtuX3_ORDEM  := .T.

aAltX3_ORDEM	:= {"JMP_TPMOTI", "JMP_MOTIVO", "JMP_CODOBS", "JMP_OBSERV", "JMP_DTDESC", "JMP_HRDESC",;
                    "JMP_USDESC", "JMO_BITMAP","JMO_CODPOR"}

SX3->( dbSetOrder(2) )   


// Verifica se a rotina de atualizacao da ordem do SX3 foi executada.

if SX3->( dbSeek( aAltX3_ORDEM[1] ) )
  if SX3->X3_ORDEM == "07"
    lAtuX3_ORDEM  := .F.
  endif
endif  

// Atualiza o X3_ORDEM apenas na primeira vez que o programa e executado.
if lAtuX3_ORDEM
  for i := 1 to len( aAltX3_ORDEM )
    if SX3->( dbSeek( aAltX3_ORDEM[i] ) )
	  RecLock( "SX3", .F. )
	  SX3->X3_ORDEM:= Soma1(Soma1(SX3->X3_ORDEM, 2),2)
	  SX3->( msUnlock() )
	endif
  next i
endif

Return

