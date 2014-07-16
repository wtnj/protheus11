#INCLUDE "Protheus.ch"        
#INCLUDE "Fileio.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGE04    ³Autor  ³ Rafael Emiliano      ³ Data ³ 20/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de melhorias do projeto IBTA                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Solange Z.³        ³      ³Revisao de controle de Filiais              ³±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGE04()
Local cMsg := ""         

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd          

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados "
cMsg += "para a implementação da melhoria relacionada a Componentes Curriculares. "
cMsg += "Esta rotina deve ser processada em modo exclusivo! "
cMsg += "Faça um backup dos dicionários e base de dados antes do processamento!" 

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Implementando Componentes Curriculares"
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
Local cTextoAux	:= ""
Local cFile     :="" 				//Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}			
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo	:= 49 				//SIGAGE - GESTAO EDUCACIONAL

Private cArquivo   	:= "UpdGE04.LOG"
Private cErros   	:= "UpdErr.LOG"

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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Elimina do SX o que deve ser eliminado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Limpando Dicionários")
			cTextoAux := dtoc( Date() )+" "+Time()+" "+"Inicio - Limpando Dicionários"+ CHR(13)+CHR(10)
			cTexto += "Limpando Dicionários..."+CHR(13)+CHR(10)
			GELimpaSX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Limpando Dicionários")						
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Limpando Dicionários"+CHR(13)+CHR(10)

						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos"+CHR(13)+CHR(10)

			cTexto += "Analisando Dicionario de Arquivos..."+CHR(13)+CHR(10)
			GEAtuSX2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos"+CHR(13)+CHR(10)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              
			cTextoAux +=dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados"+CHR(13)+CHR(10)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Gatilhos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Gatilhos" +CHR(13)+CHR(10)
			cTexto += "Analisando Gatilhos..."+CHR(13)+CHR(10)
			GEAtuSX7()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Gatilhos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Gatilhos" +CHR(13)+CHR(10)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Indices" +CHR(13)+CHR(10)
			cTexto += "Analisando arquivos de índices. "+CHR(13)+CHR(10)
			GEAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Indices" +CHR(13)+CHR(10)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Consultas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes" +CHR(13)+CHR(10)
			cTexto += "Analisando consultas padroes..."+CHR(13)+CHR(10) 
			GEAtuSxB( SM0->M0_CODIGO )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes"  +CHR(13)+CHR(10)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tira campos obsoletos de uso ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Campos Obsoletos")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Campos Obsoletos" +CHR(13)+CHR(10)
			cTexto += "Analisando campos obsoletos..."+CHR(13)+CHR(10) 
			GETiraUso()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Campos Obsoletos")			
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim - Campos Obsoletos"  +CHR(13)+CHR(10)

			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				cTextoaux += dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx]+CHR(13)+CHR(10)
				
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
				cTextoAux += dtoc( Date() )+" "+Time()+" "+"Fim Atualizando Estruturas "+aArqUpd[nx] +CHR(13)+CHR(10)
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios...")
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios..." +CHR(13)+CHR(10)

			SIX->( Pack() )
			SX2->( Pack() )
			SX3->( Pack() )
			SX7->( Pack() )
			SXB->( Pack() )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")
			cTextoAux +=  dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios..." +CHR(13)+CHR(10)
			
			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")                       
			cTextoAux += dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas" +CHR(13)+CHR(10)
			dbSelectArea("JHV")
			dbSelectArea("JHW")
			dbSelectArea("JHX")
			dbSelectArea("JHY")
			dbSelectArea("JHZ")
			dbSelectArea("JI1")
			dbSelectArea("JI2")
			dbSelectArea("JI3")
			dbSelectArea("JI4")
			dbSelectArea("JI5")
			dbSelectArea("JI6")
			dbSelectArea("JII")
			AcaLog( cArquivo, cTextoAux)
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			cTextoAux := ""
			RpcClearEnv()
			
		Next nI 
				
		// Atualiza a base de dados da empresa para cada filial
		For nI := 1 To Len(aRecnoSM0)
		
			For nX := 1 To Len(aRecnoSM0[nI,3])
	
				RpcSetType(2)
				RpcSetEnv(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
				lMsFinalAuto := .F.
				
				IncProc( dtoc( Date() )+" "+Time()+" "+"Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX] )
				cTexto += "Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX]+CHR(13)+CHR(10)
				AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Criando Componentes para a Filial: "+aRecnoSM0[nI,3,nX] )
				
				AtuBase(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
				
				ProcRegua()
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
±±³Fun‡…o    ³GEAtuSX2  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2 - Arquivos      ³±± 
±±³          ³ Adiciona as tabelas para regra de visibilidade             ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX2()
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

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
SX2->(DbSetOrder(1))	
MsSeek("JAH") //Seleciona a tabela que eh padrao do sistema para pegar algumas informacoes
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)
cModo := SX2->X2_MODO

/******************************************************************************************
* Adiciona as informacoes das tabelas num array, para trabalho posterior
*******************************************************************************************/
aAdd(aSX2,{	"JAS",; 								//Chave
			cPath,;									//Path
			"JAS"+cNome,;							//Nome do Arquivo
			"Disciplinas X Cursos",;				//Nome Port
			"Disciplinas X Cursos",;				//Nome Port
			"Disciplinas X Cursos",;				//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_COMP+JAS_ITEMOD+JAS_CODDIS",;				//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JAY",; 								//Chave
			cPath,;									//Path
			"JAY"+cNome,;							//Nome do Arquivo
			"Disciplinas X Cursos",;				//Nome Port
			"Disciplinas X Cursos",;				//Nome Port
			"Disciplinas X Cursos",;				//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_COMP+JAY_ITEMOD+JAY_CODDIS",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JHV",; 								//Chave
			cPath,;									//Path
			"JHV"+cNome,;							//Nome do Arquivo
			"Header de modelos curriculares",;		//Nome Port
			"Header de modelos curriculares",;		//Nome Port
			"Header de modelos curriculares",;		//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHV_FILIAL+JHV_CODMOD",;				//Unico
			"S"})									//Pyme
		
aAdd(aSX2,{	"JHW",; 								//Chave
			cPath,;									//Path
			"JHW"+cNome,;							//Nome do Arquivo
			"Item modelos curriculares",;		    //Nome Port
			"Item modelos curriculares",;		    //Nome Port
			"Item modelos curriculares",;		    //Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHW_FILIAL+JHW_CODMOD+JHW_ITEMOD",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JHX",; 								//Chave
			cPath,;									//Path
			"JHX"+cNome,;							//Nome do Arquivo
			"Header grupo de atividades",;		    //Nome Port
			"Header grupo de atividades",;		    //Nome Port
			"Header grupo de atividades",;		    //Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHX_FILIAL+JHX_CODGRP",;				//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JHY",; 								//Chave
			cPath,;									//Path
			"JHY"+cNome,;							//Nome do Arquivo
			"Itens grupo de atividades",;		    //Nome Port
			"Itens grupo de atividades",;		    //Nome Port
			"Itens grupo de atividades",;		    //Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHY_FILIAL+JHY_CODGRP+JHY_ITEGRP",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JHZ",; 								//Chave
			cPath,;									//Path
			"JHZ"+cNome,;							//Nome do Arquivo
			"Matriz curricular",;				    //Nome Port
			"Matriz curricular",;				    //Nome Port
			"Matriz curricular",;				    //Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHZ_FILIAL+JHZ_CURSO+JHZ_VERSAO+JHZ_PERLET+JHZ_HABILI+JHZ_COMP",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI1",; 								//Chave
			cPath,;									//Path
			"JI1"+cNome,;							//Nome do Arquivo
			"Itens do componente",;				    //Nome Port
			"Itens do componente",;				    //Nome Port
			"Itens do componente",;				    //Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI1_FILIAL+JI1_CURSO+JI1_VERSAO+JI1_PERLET+JI1_HABILI+JI1_COMP+JI1_ITEMOD",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI2",; 								//Chave
			cPath,;									//Path
			"JI2"+cNome,;							//Nome do Arquivo
			"Curso X Atividades",;				    //Nome Port
			"Curso X Atividades",;				    //Nome Port
			"Curso X Atividades",;				    //Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI2_FILIAL+JI2_CURSO+JI2_VERSAO+JI2_PERLET+JI2_HABILI+JI2_COMP+JI2_ITEMOD+JI2_CODGRP",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI3",; 								//Chave
			cPath,;									//Path
			"JI3"+cNome,;							//Nome do Arquivo
			"Curso vigente X Componente curricular",;//Nome Port
			"Curso vigente X Componente curricular",;//Nome Port
			"Curso vigente X Componente curricular",;//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI3_FILIAL+JI3_CODCUR+JI3_PERLET+JI3_HABILI+JI3_COMP",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI4",; 								//Chave
			cPath,;									//Path
			"JI4"+cNome,;							//Nome do Arquivo
			"Item curso vigente X Componente",;		//Nome Port
			"Item curso vigente X Componente",;		//Nome Port
			"Item curso vigente X Componente",;		//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI4_FILIAL+JI4_CODCUR+JI4_PERLET+JI4_HABILI+JI4_COMP+JI4_ITEMOD",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI5",; 								//Chave
			cPath,;									//Path
			"JI5"+cNome,;							//Nome do Arquivo
			"Curso vigente X Atividades",;			//Nome Port
			"Curso vigente X Atividades",;			//Nome Port
			"Curso vigente X Atividades",;			//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI5_FILIAL+JI5_CODCUR+JI5_PERLET+JI5_HABILI+JI5_COMP+JI5_ITEMOD+JI5_CODGRP",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI6",; 								//Chave
			cPath,;									//Path
			"JI6"+cNome,;							//Nome do Arquivo
			"Aluno X Componentes X Curso vigente",;	//Nome Port
			"Aluno X Componentes X Curso vigente",;	//Nome Port
			"Aluno X Componentes X Curso vigente",;	//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI6_FILIAL+JI6_NUMRA+JI6_CODCUR+JI6_COMP",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JII",; 								//Chave
			cPath,;									//Path
			"JII"+cNome,;							//Nome do Arquivo
			"Itens apontamentos de atividades",;	//Nome Port
			"Itens apontamentos de atividades",;	//Nome Port
			"Itens apontamentos de atividades",;	//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JII_FILIAL+JII_NUMRA+JII_CODCUR+JII_PERLET+JII_HABILI+JII_TURMA+JII_COMP+JII_CODGRP+JII_ATIVID",;	//Unico
			"S"})									//Pyme
			
aAdd(aSX2,{	"JHT",; 								//Chave
			cPath,;									//Path
			"JHT"+cNome,;							//Nome do Arquivo
			"Movimentacoes de alunos",;				//Nome Port
			"Movimentacoes de alunos",;				//Nome Port
			"Movimentacoes de alunos",;				//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHT_FILIAL+JHT_NUM",;					//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JHU",; 								//Chave
			cPath,;									//Path
			"JHU"+cNome,;							//Nome do Arquivo
			"Itens movimentacoes de alunos",;		//Nome Port
			"Itens movimentacoes de alunos",;		//Nome Port
			"Itens movimentacoes de alunos",;		//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHU_FILIAL+JHU_NUM+JHU_CODDIS",;		//Unico
			"S"})									//Pyme
			

/*******************************************************************************************
Realiza a inclusao das tabelas
*******************************************/
For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])

		If SX2->( !dbSeek(aSX2[i,1]) )
			RecLock("SX2",.T.) //Adiciona registro		
		Else
			RecLock("SX2",.F.) //Altera Registro
		EndIf
		
		If !(aSX2[i,1]$cAlias)
			cAlias += aSX2[i,1]+"/"
		EndIf

		For j:=1 To Len(aSX2[i])
			If FieldPos(aEstrut[j]) > 0
				FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
			EndIf
		Next j
		SX2->X2_PATH := cPath
		SX2->X2_ARQUIVO := aSX2[i,1]+cNome
		MsUnLock()
		IncProc("Atualizando Dicionario de Arquivos...")
		Conout("Atualizando Dicionario de Arquivos...")

	EndIf
Next i

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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


/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************/
aAdd(aSX3,{	"JHV",;								//Arquivo
			"01",;								//Ordem
			"JHV_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;	 					    //Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;		    				//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHV",;								//Arquivo
			"02",;								//Ordem
			"JHV_CODMOD",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Modelo",;	  				    //Titulo
			"Cod. Modelo",;	  				    //Titulo
			"Cod. Modelo",;					    //Titulo
			"Codigo Modelo Curricular",;		//Descricao
			"Codigo Modelo Curricular",;		//Descricao
			"Codigo Modelo Curricular",;		//Descricao
			"@!",;								//Picture
			'ExistChav("JHV",M->JHV_CODMOD) .and. FreeForUse("JHV",M->JHV_CODMOD)',;		//VALID
			cUsadoKey,;							//USADO
			'GetSXENum("JHV","JHV_CODMOD")',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHV",;								//Arquivo
			"03",;								//Ordem
			"JHV_DESC",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					   	//Titulo SPA
			"Descricao",;		    			//Titulo ENG
			"Descricao do Modelo",;				//Descricao
			"Descricao do Modelo",;				//Descricao SPA
			"Descricao do Modelo",;				//Descricao ENG
			"@!",;								//Picture
			"NaoVazio()",;						//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","INCLUI","","","","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHV",;								//Arquivo
			"04",;								//Ordem
			"JHV_STATUS",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Status",;						    //Titulo
			"Status",;						    //Titulo
			"Status",;						    //Titulo
			"Status Modelo Curricular",;		//Descricao
			"Status Modelo Curricular",;		//Descricao SPA
			"Status Modelo Curricular",;		//Descricao ENG
			"@!",;								//Picture
			"Pertence('12')",;								//VALID
			cUsadoOpc,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=DISPONIVEL;2=INDISPONIVEL","1=DISPONIVEL;2=INDISPONIVEL","1=DISPONIVEL;2=INDISPONIVEL",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHW",;								//Arquivo
			"01",;								//Ordem
			"JHW_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;		    				//Titulo ENG
			"Filial",;	   						//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHW",;								//Arquivo
			"02",;								//Ordem
			"JHW_CODMOD",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Modelo",;				  	     //Titulo
			"Cod. Modelo",;				   		 //Titulo
			"Cod. Modelo",;				   		 //Titulo
			"Codigo Modelo Curricular",;		//Descricao
			"Codigo Modelo Curricular",;		//Descricao
			"Codigo Modelo Curricular",;		//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHW",;								//Arquivo
			"03",;								//Ordem
			"JHW_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item",;					 		//Titulo
			"Item",;						    //Titulo
			"Item",;						    //Titulo
			"Item do Modelo Curricular",;		//Descricao
			"Item do Modelo Curricular",;		//Descricao
			"Item do Modelo Curricular",;		//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","INCLUI","","","","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHW",;								//Arquivo
			"04",;								//Ordem
			"JHW_DESC",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao
			"@!",;								//Picture
			"NaoVazio()",;						//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHW",;								//Arquivo
			"05",;								//Ordem
			"JHW_TPCONT",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tip.Controle",;				    //Titulo
			"Tip.Controle",;				    //Titulo
			"Tip.Controle",;				    //Titulo
			"Tipo do Controle",;				//Descricao
			"Tipo do Controle",;				//Descricao
			"Tipo do Controle",;				//Descricao
			"@!",;								//Picture
			"Pertence('12')",;					//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Disciplina;2=Atividade","1=Disciplina;2=Atividade","1=Disciplina;2=Atividade",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHW",;								//Arquivo
			"06",;								//Ordem
			"JHW_CARGA",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Carg.Horaria",;					//Titulo
			"Carg.Horaria",;				    //Titulo
			"Carg.Horaria",;				    //Titulo
			"Tip.Controle p/ Carg.Hor.",;		//Descricao
			"Tip.Controle p/ Carg.Hor.",;		//Descricao
			"Tip.Controle p/ Carg.Hor.",;		//Descricao
			"@!",;								//Picture
			"Pertence('1234')",;				//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=NAO CONTROLA;2=CONTROLA MINIMO;3=CONTROLA MAXIMO;4=CONTROLA AMBOS","1=NAO CONTROLA;2=CONTROLA MINIMO;3=CONTROLA MAXIMO;4=CONTROLA AMBOS","1=NAO CONTROLA;2=CONTROLA MINIMO;3=CONTROLA MAXIMO;4=CONTROLA AMBOS",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHW",;								//Arquivo
			"07",;								//Ordem
			"JHW_CREDIT",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Tip.Controle p/ Creditos",;		//Descricao
			"Tip.Controle p/ Creditos",;		//Descricao
			"Tip.Controle p/ Creditos",;		//Descricao
			"@!",;								//Picture
			"Pertence('1234')",;				//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=NAO CONTROLA;2=CONTROLA MINIMO;3=CONTROLA MAXIMO;4=CONTROLA AMBOS","1=NAO CONTROLA;2=CONTROLA MINIMO;3=CONTROLA MAXIMO;4=CONTROLA AMBOS","1=NAO CONTROLA;2=CONTROLA MINIMO;3=CONTROLA MAXIMO;4=CONTROLA AMBOS",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i := 0
SX3->( dbSetOrder(1) )
SX3->( dbSeek("JAF") )
while SX3->( !eof() .and. X3_ARQUIVO == "JAF" )
	i++
	SX3->( dbSkip() )
end
i++
aAdd(aSX3,{	"JAF",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAF_CODMOD",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Modelo",;				    	//Titulo
			"Cod. Modelo",;				    	//Titulo
			"Cod. Modelo",;				    	//Titulo
			"Codigo Modelo Curricular",;		//Descricao
			"Codigo Modelo Curricular",;		//Descricao
			"Codigo Modelo Curricular",;		//Descricao
			"@!",;								//Picture
			"ExistCpo('JHV',M->JAF_CODMOD,1) .and. A210VlMod(M->JAF_CODMOD)",;	//VALID
			cUsadoObr,;							//USADO
			"",;					   			//RELACAO
			"JHV",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","INCLUI .OR. A210WhenMo(M->JAF_COD,M->JAF_VERSAO)","","","","S"}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i++
aAdd(aSX3,{	"JAF",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAF_DESMOD",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;				    	//Titulo
			"Descricao",;				    	//Titulo
			"Descricao",;				    	//Titulo
			"Descricao do Modelo Curricular",;	//Descricao
			"Descricao do Modelo Curricular",;	//Descricao
			"Descricao do Modelo Curricular",;	//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"If(!Inclui,Posicione('JHV',1,xFilial('JHV')+JAF->JAF_CODMOD,'JHV_DESC'),'')",;		//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHX",;								//Arquivo
			"01",;								//Ordem
			"JHX_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;		    				//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHX",;								//Arquivo
			"02",;								//Ordem
			"JHX_CODGRP",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Grupo",;				    	//Titulo
			"Cod. Grupo",;				    	//Titulo
			"Cod. Grupo",;				    	//Titulo
			"Codigo Grupo de Atividades",;		//Descricao
			"Codigo Grupo de Atividades",;		//Descricao
			"Codigo Grupo de Atividades",;		//Descricao
			"@!",;								//Picture
			'ExistChav("JHX",M->JHX_CODGRP) .and. FreeForUse("JHX",M->JHX_CODGRP)',;		//VALID
			cUsadoKey,;							//USADO
			'GetSXENum("JHX","JHX_CODGRP")',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHX",;								//Arquivo
			"03",;								//Ordem
			"JHX_DESC",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					   	//Titulo SPA
			"Descricao",;		    			//Titulo ENG
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao SPA
			"Descricao",;						//Descricao ENG
			"@!",;								//Picture
			"NaoVazio()",;						//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHY",;								//Arquivo
			"01",;								//Ordem
			"JHY_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHY",;								//Arquivo
			"02",;								//Ordem
			"JHY_CODGRP",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Grupo",;				  	    //Titulo
			"Cod. Grupo",;				  	    //Titulo
			"Cod. Grupo",;				  	    //Titulo
			"Codigo Grupo de Atividades",;		//Descricao
			"Codigo Grupo de Atividades",;		//Descricao
			"Codigo Grupo de Atividades",;		//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHY",;								//Arquivo
			"03",;								//Ordem
			"JHY_ITEGRP",;						//Campo
			"C",;								//Tipo
			3,;	   								//Tamanho
			0,;									//Decimal
			"Item",;						    //Titulo
			"Item",;						    //Titulo
			"Item",;						    //Titulo
			"Item Grupo de Atividades",;		//Descricao
			"Item Grupo de Atividades",;		//Descricao
			"Item Grupo de Atividades",;		//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHY",;								//Arquivo
			"04",;								//Ordem
			"JHY_DESC",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;						//Titulo
			"Descricao",;						//Titulo
			"Descricao",;					    //Titulo
			"Descricao da Atividade",;			//Descricao
			"Descricao da Atividade",;			//Descricao
			"Descricao da Atividade",;			//Descricao
			"@!",;								//Picture
			"NaoVazio()",;						//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHY",;								//Arquivo
			"05",;								//Ordem
			"JHY_CARGA",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Carga Horaria",;				    //Titulo
			"Carga Horaria",;				    //Titulo
			"Carga Horaria",;				    //Titulo
			"Carga Horaria",;					//Descricao
			"Carga Horaria",;					//Descricao
			"Carga Horaria",;					//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHY",;								//Arquivo
			"06",;								//Ordem
			"JHY_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;						//Descricao
			"Creditos",;						//Descricao
			"Creditos",;						//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"01",;								//Ordem
			"JHZ_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHZ",;								//Arquivo
			"02",;								//Ordem
			"JHZ_CURSO",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Codigo do Curso Padrao",;			//Descricao
			"Codigo do Curso Padrao",;			//Descricao
			"Codigo do Curso Padrao",;			//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"03",;								//Ordem
			"JHZ_VERSAO",;						//Campo
			"C",;								//Tipo
			3,;	   								//Tamanho
			0,;									//Decimal
			"Versao",;						    //Titulo
			"Versao",;						    //Titulo
			"Versao",;						    //Titulo
			"Versao",;							//Descricao
			"Versao",;							//Descricao
			"Versao",;							//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"04",;								//Ordem
			"JHZ_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"05",;								//Ordem
			"JHZ_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"06",;								//Ordem
			"JHZ_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;						//Descricao
			"Componente",;						//Descricao
			"Componente",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"AC210IniCom()",;					//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"07",;								//Ordem
			"JHZ_CODDIS",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Disciplina",;					    //Titulo
			"Disciplina",;					    //Titulo
			"Disciplina",;					    //Titulo
			"Disciplina Associada",;			//Descricao
			"Disciplina Associada",;			//Descricao
			"Disciplina Associada",;			//Descricao
			"@!",;								//Picture
			"ExistCpo('JAE',M->JHZ_CODDIS)",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"JAE",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"08",;								//Ordem
			"JHZ_DESC",;						//Campo
			"C",;								//Tipo
			100,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao do Componente",;			//Descricao
			"Descricao do Componente",;			//Descricao
			"Descricao do Componente",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"09",;								//Ordem
			"JHZ_TIPCOM",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo Comp.",;					    //Titulo
			"Tipo Comp.",;					    //Titulo
			"Tipo Comp.",;					    //Titulo
			"Tipo do Componente",;				//Descricao
			"Tipo do Componente",;				//Descricao
			"Tipo do Componente",;				//Descricao
			"@!",;								//Picture
			"Pertence('12')",;					//VALID
			cUsadoOpc,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=OBRIGATORIO;2=OPTATIVO","1=OBRIGATORIO;2=OPTATIVO","1=OBRIGATORIO;2=OPTATIVO",;			//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"10",;								//Ordem
			"JHZ_TIPAPR",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo Aprov.",;					    //Titulo
			"Tipo Aprov.",;					    //Titulo
			"Tipo Aprov.",;					    //Titulo
			"Tipo de Aprovacao",;				//Descricao
			"Tipo de Aprovacao",;				//Descricao
			"Tipo de Aprovacao",;				//Descricao
			"@!",;								//Picture
			"Pertence('12')",;					//VALID
			cUsadoObr,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM",;			//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"11",;								//Ordem
			"JHZ_TIPREP",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo Reprov.",;					    //Titulo
			"Tipo Reprov.",;					    //Titulo
			"Tipo Reprov.",;					    //Titulo
			"Tipo de Reprovacao",;				//Descricao
			"Tipo de Reprovacao",;				//Descricao
			"Tipo de Reprovacao",;				//Descricao
			"@!",;								//Picture
			"GDFieldGet('JHZ_TIPAPR') = '2' .or. M->JHZ_TIPREP = '1'",;			//VALID
			cUsadoObr,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM",;			//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"12",;								//Ordem
			"JHZ_COREQ",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Co-Requisito",;				    //Titulo
			"Co-Requisito",;				    //Titulo
			"Co-Requisito",;				    //Titulo
			"Co-Requisito",;					//Descricao
			"Co-Requisito",;					//Descricao
			"Co-Requisito",;					//Descricao
			"@!",;								//Picture
			"(Vazio().or.ExistCPO('JAE')).and.M->JHZ_COREQ<>GDFieldGet('JHZ_CODDIS')",;		//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JAE",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","S","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHZ",;								//Arquivo
			"13",;								//Ordem
			"JHZ_DESCOR",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc.Co-Req.",;				    //Titulo
			"Desc.Co-Req.",;				    //Titulo
			"Desc.Co-Req.",;				    //Titulo
			"Descricao Co-Requis.",;			//Descricao
			"Descricao Co-Requis.",;			//Descricao
			"Descricao Co-Requis.",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"If(!Inclui,Posicione('JAE',1,xFilial('JAE')+JHZ->JHZ_COREQ,'JAE_DESC' ),'')",;		//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"01",;								//Ordem
			"JI1_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JI1",;								//Arquivo
			"02",;								//Ordem
			"JI1_CURSO",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"03",;								//Ordem
			"JI1_VERSAO",;						//Campo
			"C",;								//Tipo
			3,;	   								//Tamanho
			0,;									//Decimal
			"Versao",;						    //Titulo
			"Versao",;						    //Titulo
			"Versao",;						    //Titulo
			"Versao",;							//Descricao
			"Versao",;							//Descricao
			"Versao",;							//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"04",;								//Ordem
			"JI1_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"05",;								//Ordem
			"JI1_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"06",;								//Ordem
			"JI1_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;						//Descricao
			"Componente",;						//Descricao
			"Componente",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"07",;								//Ordem
			"JI1_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"08",;								//Ordem
			"JI1_CARMIN",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Carga Min.",;					    //Titulo
			"Carga Min.",;					    //Titulo
			"Carga Min.",;					    //Titulo
			"Carga Horaria Minima",;			//Descricao
			"Carga Horaria Minima",;			//Descricao
			"Carga Horaria Minima",;			//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lDisciplina .And. lCarMin","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"09",;								//Ordem
			"JI1_CARMAX",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Carga Max.",;					    //Titulo
			"Carga Max.",;					    //Titulo
			"Carga Max.",;					    //Titulo
			"Carga Horaria Maxima",;			//Descricao
			"Carga Horaria Maxima",;			//Descricao
			"Carga Horaria Maxima",;			//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lDisciplina .And. lCarMax","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"10",;								//Ordem
			"JI1_CREMIN",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Credito Min.",;				    //Titulo
			"Credito Min.",;				    //Titulo
			"Credito Min.",;				    //Titulo
			"Credito Minimo",;					//Descricao
			"Credito Minimo",;					//Descricao
			"Credito Minimo",;					//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lAtividade .And. lCreMin","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI1",;								//Arquivo
			"11",;								//Ordem
			"JI1_CREMAX",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Credito Max.",;				    //Titulo
			"Credito Max.",;				    //Titulo
			"Credito Max.",;				    //Titulo
			"Credito Maximo",;					//Descricao
			"Credito Maximo",;					//Descricao
			"Credito Maximo",;					//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lAtividade .And. lCreMax","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"01",;								//Ordem
			"JI2_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JI2",;								//Arquivo
			"02",;								//Ordem
			"JI2_CURSO",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"03",;								//Ordem
			"JI2_VERSAO",;						//Campo
			"C",;								//Tipo
			3,;	   								//Tamanho
			0,;									//Decimal
			"Versao",;						    //Titulo
			"Versao",;						    //Titulo
			"Versao",;						    //Titulo
			"Versao",;							//Descricao
			"Versao",;							//Descricao
			"Versao",;							//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"04",;								//Ordem
			"JI2_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"05",;								//Ordem
			"JI2_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"06",;								//Ordem
			"JI2_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;						//Descricao
			"Componente",;						//Descricao
			"Componente",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"07",;								//Ordem
			"JI2_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"08",;								//Ordem
			"JI2_CODGRP",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Gr.Atividade",;				    //Titulo
			"Gr.Atividade",;				    //Titulo
			"Gr.Atividade",;				    //Titulo
			"Grupo de Atividade",;				//Descricao
			"Grupo de Atividade",;				//Descricao
			"Grupo de Atividade",;				//Descricao
			"@!",;								//Picture
			"A210VALGRP()",;					//VALID
			cUsadoObr,;							//USADO
			"0",;								//RELACAO
			"JHX",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"09",;								//Ordem
			"JI2_DESGRP",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc.Grp.Atv",;				    //Titulo
			"Desc.Grp.Atv",;				    //Titulo
			"Desc.Grp.Atv",;				    //Titulo
			"Desc. Grupo Atividades",;			//Descricao
			"Desc. Grupo Atividades",;			//Descricao
			"Desc. Grupo Atividades",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"If(!Inclui,Posicione('JHX',1,xFilial('JHX')+JI2->JI2_CODGRP,'JHX_DESC'),'')",;		//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"10",;								//Ordem
			"JI2_CARGA",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"CH Lim.Lanc.",;				    //Titulo                                                 
			"CH Lim.Lanc.",;				    //Titulo
			"CH Lim.Lanc.",;				    //Titulo
			"Carg.Horaria Limite Lanc.",;		//Descricao
			"Carg.Horaria Limite Lanc.",;		//Descricao
			"Carg.Horaria Limite Lanc.",;		//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI2",;								//Arquivo
			"11",;								//Ordem
			"JI2_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"CR Lim.Lanc.",;				    //Titulo
			"CR Lim.Lanc.",;				    //Titulo
			"CR Lim.Lanc.",;				    //Titulo
			"Creditos Limite Lanc.",;			//Descricao
			"Creditos Limite Lanc.",;			//Descricao
			"Creditos Limite Lanc.",;			//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoOpc,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"01",;								//Ordem
			"JI3_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JI3",;								//Arquivo
			"02",;								//Ordem
			"JI3_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"03",;								//Ordem
			"JI3_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"04",;								//Ordem
			"JI3_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"05",;								//Ordem
			"JI3_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Item do Componente",;				//Descricao
			"Item do Componente",;				//Descricao
			"Item do Componente",;				//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"",".F.","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"06",;								//Ordem
			"JI3_DESC",;						//Campo
			"C",;								//Tipo
			100,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao do componente",;			//Descricao
			"Descricao do componente",;			//Descricao
			"Descricao do componente",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"",".F.","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"07",;								//Ordem
			"JI3_TIPO",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo",;						    //Titulo
			"Tipo",;						    //Titulo
			"Tipo",;						    //Titulo
			"Tipo do componente",;				//Descricao
			"Tipo do componente",;				//Descricao
			"Tipo do componente",;				//Descricao
			"@!",;								//Picture
			"Pertence('12')",;					//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=OBRIGATORIO;2=OPTATIVO","1=OBRIGATORIO;2=OPTATIVO","1=OBRIGATORIO;2=OPTATIVO",;			//CBOX, CBOX SPA, CBOX ENG
			"",".T.","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"08",;								//Ordem
			"JI3_TIPAPR",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo Aprov.",;					    //Titulo
			"Tipo Aprov.",;					    //Titulo
			"Tipo Aprov.",;					    //Titulo
			"Tipo de Aprovacao",;				//Descricao
			"Tipo de Aprovacao",;				//Descricao
			"Tipo de Aprovacao",;				//Descricao
			"@!",;								//Picture
			"Pertence('12')",;					//VALID
			cUsadoObr,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM",;			//CBOX, CBOX SPA, CBOX ENG
			"",".T.","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI3",;								//Arquivo
			"09",;								//Ordem
			"JI3_TIPREP",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo Reprov.",;					    //Titulo
			"Tipo Reprov.",;					    //Titulo
			"Tipo Reprov.",;					    //Titulo
			"Tipo de Reprovacao",;				//Descricao
			"Tipo de Reprovacao",;				//Descricao
			"Tipo de Reprovacao",;				//Descricao
			"@!",;								//Picture
			"GDFieldGet('JI3_TIPAPR') = '2' .or. M->JI3_TIPREP = '1'",;			//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM","1=COMPONENTE;2=ITEM A ITEM",;			//CBOX, CBOX SPA, CBOX ENG
			"",".T.","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"01",;								//Ordem
			"JI4_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JI4",;								//Arquivo
			"02",;								//Ordem
			"JI4_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"03",;								//Ordem
			"JI4_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"04",;								//Ordem
			"JI4_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"05",;								//Ordem
			"JI4_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Item do Componente",;				//Descricao
			"Item do Componente",;				//Descricao
			"Item do Componente",;				//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"06",;								//Ordem
			"JI4_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"07",;								//Ordem
			"JI4_CARMIN",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"C.H.Minima",;					    //Titulo
			"C.H.Minima",;					    //Titulo
			"C.H.Minima",;					    //Titulo
			"Carga Horaria Minima",;			//Descricao
			"Carga Horaria Minima",;			//Descricao
			"Carga Horaria Minima",;			//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lDisciplina .And. lCarMin","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"08",;								//Ordem
			"JI4_CARMAX",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"C.H.Maxima",;					    //Titulo
			"C.H.Maxima",;					    //Titulo
			"C.H.Maxima",;					    //Titulo
			"Carga Horaria Maxima",;			//Descricao
			"Carga Horaria Maxima",;			//Descricao
			"Carga Horaria Maxima",;			//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lDisciplina .And. lCarMax","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"09",;								//Ordem
			"JI4_CREMIN",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"CR Minimo",;					    //Titulo
			"CR Minimo",;					    //Titulo
			"CR Minimo",;					    //Titulo
			"Creditos Minimos",;				//Descricao
			"Creditos Minimos",;				//Descricao
			"Creditos Minimos",;				//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lAtividade .And. lCreMin","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI4",;								//Arquivo
			"10",;								//Ordem
			"JI4_CREMAX",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"CR Maximo",;					    //Titulo
			"CR Maximo",;					    //Titulo
			"CR Maximo",;					    //Titulo
			"Creditos Maximos",;				//Descricao
			"Creditos Maximos",;				//Descricao
			"Creditos Maximos",;				//Descricao
			"@E 9999",;							//Picture
			"Positivo()",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","lAtividade .And. lCreMax","","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"01",;								//Ordem
			"JI5_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JI5",;								//Arquivo
			"02",;								//Ordem
			"JI5_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Cod Curso",;				  	    //Titulo
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"03",;								//Ordem
			"JI5_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"04",;								//Ordem
			"JI5_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"05",;								//Ordem
			"JI5_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Item do Componente",;				//Descricao
			"Item do Componente",;				//Descricao
			"Item do Componente",;				//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"06",;								//Ordem
			"JI5_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"Item do Modelo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"07",;								//Ordem
			"JI5_CODGRP",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Gr. Atividade",;				    //Titulo
			"Gr. Atividade",;				    //Titulo
			"Gr. Atividade",;				    //Titulo
			"Grupo de Atividade",;				//Descricao
			"Grupo de Atividade",;				//Descricao
			"Grupo de Atividade",;				//Descricao
			"@!",;								//Picture
			"ExistCpo('JHX',M->JI5_CODGRP,1)",;	//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"JHX",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"",".F.","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"08",;								//Ordem
			"JI5_DESGRP",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc. Grupo",;					    //Titulo
			"Desc. Grupo",;					    //Titulo
			"Desc. Grupo",;					    //Titulo
			"Desc.Grupo de Atividade",;			//Descricao
			"Desc.Grupo de Atividade",;			//Descricao
			"Desc.Grupo de Atividade",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"If(!Inclui,Posicione('JHX',1,xFilial('JHX')+JI5->JI5_CODGRP,'JHX_DESC'),'')",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"09",;								//Ordem
			"JI5_CARGA",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"CH Lim.Lanc.",;				    //Titulo
			"CH Lim.Lanc.",;				    //Titulo
			"CH Lim.Lanc.",;				    //Titulo
			"Carg.Horaria Limite Lanc.",;		//Descricao
			"Carg.Horaria Limite Lanc.",;		//Descricao
			"Carg.Horaria Limite Lanc.",;		//Descricao
			"@E 9,999",;						//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI5",;								//Arquivo
			"10",;								//Ordem
			"JI5_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"CR Lim.Lanc.",;				    //Titulo
			"CR Lim.Lanc.",;				    //Titulo
			"CR Lim.Lanc.",;				    //Titulo
			"Creditos Limite Lanc.",;			//Descricao
			"Creditos Limite Lanc.",;			//Descricao
			"Creditos Limite Lanc.",;			//Descricao
			"@E 9,999",;						//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"01",;								//Ordem
			"JI6_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JI6",;								//Arquivo
			"02",;								//Ordem
			"JI6_NUMRA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Numero RA",;				  	    //Titulo
			"Numero RA",;				  	    //Titulo
			"Numero RA",;				  	    //Titulo
			"Numero RA",;						//Descricao
			"Numero RA",;						//Descricao
			"Numero RA",;						//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"03",;								//Ordem
			"JI6_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;					   				//Tamanho
			0,;									//Decimal
			"Curso",;							//Titulo
			"Curso",;							//Titulo
			"Curso",;							//Titulo
			"Curso Padrao",;					//Descricao
			"Curso Padrao",;					//Descricao
			"Curso Padrao",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"04",;								//Ordem
			"JI6_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Codigo do Componente",;			//Descricao
			"Codigo do Componente",;			//Descricao
			"Codigo do Componente",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"05",;								//Ordem
			"JI6_DCOMP",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descr.Comp.",;					    //Titulo
			"Descr.Comp.",;					    //Titulo
			"Descr.Comp.",;					    //Titulo
			"Descricao do Componente",;			//Descricao
			"Descricao do Componente",;			//Descricao
			"Descricao do Componente",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"Posicione('JI3',2,xFilial('JI3')+JI6->JI6_CODCUR+JI6->JI6_COMP,'JI3_DESC')",;		//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"06",;								//Ordem
			"JI6_SITUAC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Situacao",;					    //Titulo
			"Situacao",;					    //Titulo
			"Situacao",;					    //Titulo
			"Situacao do Aluno",;				//Descricao
			"Situacao do Aluno",;				//Descricao
			"Situacao do Aluno",;				//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Cursando;2=Aprovado;3=Reprov.Nota;4=Reprov.Falta;7=Trancado;8=Dispensado;9=Cancelado;A=A Cursar",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"07",;								//Ordem
			"JI6_MEDFIM",;						//Campo
			"N",;								//Tipo
			5,;									//Tamanho
			2,;									//Decimal
			"Media Final",;					    //Titulo
			"Media Final",;					    //Titulo
			"Media Final",;					    //Titulo
			"Media Final",;						//Descricao
			"Media Final",;						//Descricao
			"Media Final",;						//Descricao
			"@E 99.99",;						//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
aAdd(aSX3,{	"JI6",;								//Arquivo
			"08",;								//Ordem
			"JI6_MEDCON",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Conceito Fin",;				    //Titulo
			"Conceito Fin",;				    //Titulo
			"Conceito Fin",;				    //Titulo
			"Conceito Final",;					//Descricao
			"Conceito Final",;					//Descricao
			"Conceito Final",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"09",;								//Ordem
			"JI6_CHREAL",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Carga Real",;					    //Titulo
			"Carga Real",;					    //Titulo
			"Carga Real",;					    //Titulo
			"Carga Horaria Realizada",;			//Descricao
			"Carga Horaria Realizada",;			//Descricao
			"Carga Horaria Realizada",;			//Descricao
			"@E 9999",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"10",;								//Ordem
			"JI6_CRREAL",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Credito Real",;				    //Titulo
			"Credito Real",;				    //Titulo
			"Credito Real",;				    //Titulo
			"Creditos Realizados",;				//Descricao
			"Creditos Realizados",;				//Descricao
			"Creditos Realizados",;				//Descricao
			"@E 9999",;							//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"11",;								//Ordem
			"JI6_ANOLET",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Ano Letivo",;	    			    //Titulo
			"Ano Letivo",;	    			    //Titulo
			"Ano Letivo",;	    			    //Titulo
			"Ano Letivo",;						//Descricao
			"Ano Letivo",;						//Descricao
			"Ano Letivo",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI6",;								//Arquivo
			"12",;								//Ordem
			"JI6_PERIOD",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Periodo Ano",;				    	//Titulo
			"Periodo Ano",;				    	//Titulo
			"Periodo Ano",;				    	//Titulo
			"Periodo Ano",;						//Descricao
			"Periodo Ano",;						//Descricao
			"Periodo Ano",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"01",;								//Ordem
			"JII_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JII",;								//Arquivo
			"02",;								//Ordem
			"JII_NUMRA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Numero RA",;				  	    //Titulo
			"Numero RA",;				  	    //Titulo
			"Numero RA",;				  	    //Titulo
			"Numero RA",;						//Descricao
			"Numero RA",;						//Descricao
			"Numero RA",;						//Descricao
			"@!",;								//Picture
			'',;								//VALID
			cUsadoObr,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"03",;								//Ordem
			"JII_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;					   				//Tamanho
			0,;									//Decimal
			"Curso",;							//Titulo
			"Curso",;							//Titulo
			"Curso",;							//Titulo
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"Codigo do Curso",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"04",;								//Ordem
			"JII_PERLET",;						//Campo
			"C",;								//Tipo
			2,;					   				//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"Periodo Letivo",;					//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"05",;								//Ordem
			"JII_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;					    //Titulo
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"06",;								//Ordem
			"JII_TURMA",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;							//Descricao
			"Turma",;							//Descricao
			"Turma",;							//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"07",;								//Ordem
			"JII_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente Curricular",;			//Descricao
			"Componente Curricular",;			//Descricao
			"Componente Curricular",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"08",;								//Ordem
			"JII_DCOMP",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"09",;								//Ordem
			"JII_CODGRP",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Grupo",;				  	    //Titulo
			"Cod. Grupo",;				  	    //Titulo
			"Cod. Grupo",;				  	    //Titulo
			"Codigo Grupo de Atividades",;		//Descricao
			"Codigo Grupo de Atividades",;		//Descricao
			"Codigo Grupo de Atividades",;		//Descricao
			"@!",;								//Picture
			'ACA675TpApt() .And. ExistCpo("JHX",M->JII_CODGRP)',;	//VALID
			cUsadoObr,;							//USADO
			'',;								//RELACAO
			"JHY",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"10",;								//Ordem
			"JII_ATIVID",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Atividade",;					    //Titulo
			"Atividade",;					    //Titulo
			"Atividade",;					    //Titulo
			"Atividade",;						//Descricao
			"Atividade",;						//Descricao
			"Atividade",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"11",;								//Ordem
			"JII_DATIVI",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao
			"Descricao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"12",;								//Ordem
			"JII_CARGA",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Carga Horar",;					    //Titulo
			"Carga Horar",;					    //Titulo
			"Carga Horar",;					    //Titulo
			"Carga Horaria",;					//Descricao
			"Carga Horaria",;					//Descricao
			"Carga Horaria",;					//Descricao
			"@E 9999",;							//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"13",;								//Ordem
			"JII_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;						//Descricao
			"Creditos",;						//Descricao
			"Creditos",;						//Descricao
			"@E 9999",;							//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JII",;								//Arquivo
			"14",;								//Ordem
			"JII_SITUAC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Situacao",;					    //Titulo
			"Situacao",;					    //Titulo
			"Situacao",;					    //Titulo
			"Situacao",;						//Descricao
			"Situacao",;						//Descricao
			"Situacao",;						//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Pendente;2=Confirmado","1=Pendente;2=Confirmado","1=Pendente;2=Confirmado",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i := 0
SX3->( dbSetOrder(1) )
SX3->( dbSeek("JAE") )
while SX3->( !eof() .and. X3_ARQUIVO == "JAE" )
	i++
	SX3->( dbSkip() )
end
i++
/******************************************************
Cadastro de disciplinas*/
aAdd(aSX3,{	"JAE",;								//Arquivo
			StrZero(i,2),;								//Ordem
			"JAE_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos por disciplina",;			//Descricao
			"Creditos por disciplina",;			//Descricao
			"Creditos por disciplina",;			//Descricao
			"@E 9,999",;						//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i := 0
SX3->( dbSetOrder(1) )
SX3->( dbSeek("JAY") )
while SX3->( !eof() .and. X3_ARQUIVO == "JAY" )
	i++
	SX3->( dbSkip() )
end
i++
aAdd(aSX3,{	"JAY",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAY_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Codigo do Componente",;			//Descricao
			"Codigo do Componente",;			//Descricao
			"Codigo do Componente",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i++
aAdd(aSX3,{	"JAY",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAY_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item do Modelo Curricular",;		//Descricao
			"Item do Modelo Curricular",;		//Descricao
			"Item do Modelo Curricular",;		//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i++
aAdd(aSX3,{	"JAY",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAY_PESO",;						//Campo
			"N",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Peso",;						    //Titulo
			"Peso",;						    //Titulo
			"Peso",;						    //Titulo
			"Peso da disciplina no comp",;		//Descricao
			"Peso da disciplina no comp",;		//Descricao
			"Peso da disciplina no comp",;		//Descricao
			"@E 99",;							//Picture
			"Entre(1,99)",;						//VALID
			cUsadoOpc,;							//USADO
			"1",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
i++			
aAdd(aSX3,{	"JAY",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAY_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos por disciplina",;			//Descricao
			"Creditos por disciplina",;			//Descricao
			"Creditos por disciplina",;			//Descricao
			"@E 9,999",;							//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
		
i := 0
SX3->( dbSetOrder(1) )
SX3->( dbSeek("JAS") )
while SX3->( !eof() .and. X3_ARQUIVO == "JAS" )
	i++
	SX3->( dbSkip() )
end
i++
aAdd(aSX3,{	"JAS",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAS_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Componente",;					    //Titulo
			"Codigo do Componente",;			//Descricao
			"Codigo do Componente",;			//Descricao
			"Codigo do Componente",;			//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i++
aAdd(aSX3,{	"JAS",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAS_ITEMOD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item Modelo",;					    //Titulo
			"Item do Modelo Curricular",;		//Descricao
			"Item do Modelo Curricular",;		//Descricao
			"Item do Modelo Curricular",;		//Descricao
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

i++
aAdd(aSX3,{	"JAS",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAS_PESO",;						//Campo
			"N",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Peso",;						    //Titulo
			"Peso",;						    //Titulo
			"Peso",;						    //Titulo
			"Peso da disciplina no comp",;		//Descricao
			"Peso da disciplina no comp",;		//Descricao
			"Peso da disciplina no comp",;		//Descricao
			"@E 99",;							//Picture
			"Entre(1,99)",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
i++			
aAdd(aSX3,{	"JAS",;								//Arquivo
			StrZero(i,2),;						//Ordem
			"JAS_CREDIT",;						//Campo
			"N",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos",;					    //Titulo
			"Creditos por disciplina",;			//Descricao
			"Creditos por disciplina",;			//Descricao
			"Creditos por disciplina",;			//Descricao
			"@E 9,999",;						//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criadas as tabelas para utilização de estorno de operações³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAdd(aSX3,{	"JHT",;								//Arquivo
			"01",;								//Ordem
			"JHT_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    	//Titulo
			"Filial",;					   		//Titulo SPA
			"Filial",;		    				//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"02",;								//Ordem
			"JHT_NUM",;							//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Num.Controle",;					//Titulo
			"Num.Controle",;					//Titulo SPA
			"Num.Controle",;		    		//Titulo ENG
			"Num.Controle",;					//Descricao
			"Num.Controle",;					//Descricao SPA
			"Num.Controle",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHT",;								//Arquivo
			"03",;								//Ordem
			"JHT_TIPO",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Tp.Operacao",;					    //Titulo
			"Tp.Operacao",;					   	//Titulo SPA
			"Tp.Operacao",;		    			//Titulo ENG
			"Tp.Operacao",;						//Descricao
			"Tp.Operacao",;						//Descricao SPA
			"Tp.Operacao",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
						
aAdd(aSX3,{	"JHT",;								//Arquivo
			"04",;								//Ordem
			"JHT_NUMRA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"RA do aluno",;					    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"05",;								//Ordem
			"JHT_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"Cur. Vigente",;					//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"",;								//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"06",;								//Ordem
			"JHT_PERLET",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"Per. Letivo",;				    	//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	 
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"07",;								//Ordem
			"JHT_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"08",;								//Ordem
			"JHT_TURMA",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"Turma",;						    //Titulo
			"@!",;									//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"09",;								//Ordem
			"JHT_SEQ",;							//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"Sequencial",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"10",;								//Ordem
			"JHT_DATA",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"Data",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"11",;								//Ordem
			"JHT_HORA",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"Hora",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"12",;								//Ordem
			"JHT_USER",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"13",;								//Ordem
			"JHT_NUMREQ",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"Requerimento",;					//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"14",;								//Ordem
			"JHT_MEMO1",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"15",;								//Ordem
			"JHT_OBSERV",;						//Campo
			"M",;								//Tipo
			80,;								//Tamanho
			0,;									//Decimal
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"Observacoes",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME     
			
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"16",;								//Ordem
			"JHT_CURDES",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"C.V.Destino",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME     
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"17",;								//Ordem
			"JHT_PERDES",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"P.L.Destino",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"18",;								//Ordem
			"JHT_HABDES",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"Hab.Destino",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME         
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"19",;								//Ordem
			"JHT_TURDES",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"Turma Dest.",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"20",;								//Ordem
			"JHT_BEATIV",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"Ativo",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"21",;								//Ordem
			"JHT_BESITU",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"Situacao",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"22",;								//Ordem
			"JHT_BETIPO",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"Tp.Matricula",;					//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME     
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"23",;								//Ordem
			"JHT_DATAES",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"Dt. Estorno",;						//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"24",;								//Ordem
			"JHT_HORAES",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"Hora Estorno",;					//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHT",;								//Arquivo
			"25",;								//Ordem
			"JHT_USERES",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"Usuario",;						    //Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHU",;								//Arquivo
			"01",;								//Ordem
			"JHU_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME       
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"02",;								//Ordem
			"JHU_NUM",;							//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Num.Controle",;					//Titulo
			"Num.Controle",;					//Titulo SPA
			"Num.Controle",;			    	//Titulo ENG
			"Num.Controle",;					//Descricao
			"Num.Controle",;					//Descricao SPA
			"Num.Controle",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"03",;								//Ordem
			"JHU_CODDIS",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Disciplina",;						//Titulo
			"Disciplina",;						//Titulo SPA
			"Disciplina",;			    		//Titulo ENG
			"Disciplina",;						//Descricao
			"Disciplina",;						//Descricao SPA
			"Disciplina",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"04",;								//Ordem
			"JHU_SEQDIS",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Seq.Oper.Dis",;					//Titulo
			"Seq.Oper.Dis",;					//Titulo SPA
			"Seq.Oper.Dis",;			    	//Titulo ENG
			"Seq.Oper.Dis",;					//Descricao
			"Seq.Oper.Dis",;					//Descricao SPA
			"Seq.Oper.Dis",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"05",;								//Ordem
			"JHU_C7SITD",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Sit.Mat.Disc",;					//Titulo
			"Sit.Mat.Disc",;					//Titulo SPA
			"Sit.Mat.Disc",;			    	//Titulo ENG
			"Sit.Mat.Disc",;					//Descricao
			"Sit.Mat.Disc",;					//Descricao SPA
			"Sit.Mat.Disc",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"06",;								//Ordem
			"JHU_C7SITU",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Sit.Final",;						//Titulo
			"Sit.Final",;						//Titulo SPA
			"Sit.Final",;			    		//Titulo ENG
			"Sit.Final",;						//Descricao
			"Sit.Final",;						//Descricao SPA
			"Sit.Final",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME      
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"07",;								//Ordem
			"JHU_C7MEDF",;						//Campo
			"N",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Media Ant.",;						//Titulo
			"Media Ant.",;						//Titulo SPA
			"Media Ant.",;			    		//Titulo ENG
			"Media Ant.",;						//Descricao
			"Media Ant.",;						//Descricao SPA
			"Media Ant.",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"08",;								//Ordem
			"JHU_C7MEDC",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Media Conse",;						//Titulo
			"Media Conse",;						//Titulo SPA
			"Media Conse",;			    		//Titulo ENG
			"Media Conse",;						//Descricao
			"Media Conse",;						//Descricao SPA
			"Media Conse",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME         
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"09",;								//Ordem
			"JHU_C7DMEC",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc. Conse",;						//Titulo
			"Desc. Conse",;						//Titulo SPA
			"Desc. Conse",;			    		//Titulo ENG
			"Desc. Conse",;						//Descricao
			"Desc. Conse",;						//Descricao SPA
			"Desc. Conse",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"10",;								//Ordem
			"JHU_C7CINS",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Instituicao",;						//Titulo
			"Instituicao",;						//Titulo SPA
			"Instituicao",;			    		//Titulo ENG
			"Instituicao",;						//Descricao
			"Instituicao",;						//Descricao SPA
			"Instituicao",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"11",;								//Ordem
			"JHU_C7AINS",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Ano Concl",;						//Titulo
			"Ano Concl",;						//Titulo SPA
			"Ano Concl",;			    		//Titulo ENG
			"Ano Concl",;						//Descricao
			"Ano Concl",;						//Descricao SPA
			"Ano Concl",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
			
aAdd(aSX3,{	"JHU",;								//Arquivo
			"12",;								//Ordem
			"JHU_C7TPCU",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Tipo Curso",;					    //Titulo
			"Tipo Curso",;					   	//Titulo SPA
			"Tipo Curso",;		    			//Titulo ENG
			"Tipo Curso",;						//Descricao
			"Tipo Curso",;						//Descricao SPA
			"Tipo Curso",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHU",;								//Arquivo
			"13",;								//Ordem
			"JHU_COMP",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Componente",;						//Titulo
			"Componente",;						//Titulo SPA
			"Componente",;			    		//Titulo ENG
			"Componente",;						//Descricao
			"Componente",;						//Descricao SPA
			"Componente",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

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

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAS_PESO" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAS_CREDIT" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAS_CARGA" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	
			
//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAS_BIBLIO" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAS_CONTEU" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo AMG_ para que tenha inicialização 2=Nao
if SX3->( dbSeek( "JAS_AMG_" ) )
	RecLock("SX3",.F.)
	SX3->X3_RELACAO	:= '"2"'
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAY_PESO" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAY_CREDIT" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAY_CARGA" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	
			
//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAY_BIBLIO" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo carga da disciplina para que seja editável como o do credito
if SX3->( dbSeek( "JAY_CONTEU" ) )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoOpc
	SX3->X3_RESERV	:= cReservOpc	
	SX3->X3_VISUAL  := "A"
	SX3->(MsUnlock())
endif	

//Alterar o campo Frequencia Minima para Nao Usado.
If SX3->( dbSeek("JAY_FRQMIN") ) 
	RecLock("SX3",.F.)
	SX3->X3_USADO := cUsadoNao
	SX3->X3_RESERV := cReservNao
	SX3->(MsUnlock())
EndIf

//Altera o campo JAE_PESO para NAO USADO, pois com a implementacao de Componentes Curriculares sao utilizados os campo JAY_PESO e 
//JAS_PESO para controle de peso em disciplinas
If SX3->( dbSeek("JAE_PESO") )
	RecLock("SX3",.F.)
	SX3->X3_USADO	:= cUsadoNao
	SX3->X3_RESERV	:= cReservNao
	SX3->(MsUnlock())
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX7  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX7 - Gatilhos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX7()

Local aSX7   := {}					//Array que contera os dados dos gatilhos
Local aEstrut:= {}					//Array que contem a estrutura da tabela SX7
Local i      := 0					//Contador para laco
Local j      := 0					//Contador para laco
/*********************************************************************************************
Define a estrutura da tabela SX7
*********************************************************************************************/
aEstrut:= { "X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS",;
			"X7_ORDEM","X7_CHAVE","X7_PROPRI","X7_CONDIC"}

aAdd(aSX7,{	"JAF_CODMOD",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JHV',1,xFilial('JHV')+M->JAF_CODMOD,'JHV->JHV_DESC')",;		//Regra
			"JAF_DESMOD",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condi

aAdd(aSX7,{	"JHZ_CODDIS",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JAE',1,xFilial('JAE')+M->JHZ_CODDIS,'JAE_DESC')",;		//Regra
			"JHZ_DESC",;      				//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JHZ_COREQ",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JAE',1,xFilial('JAE')+M->JHZ_COREQ,'JAE->JAE_DESC')",;		//Regra
			"JHZ_DESCOR",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JI2_CODGRP",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JHX',1,xFilial('JHX')+M->JI2_CODGRP,'JHX_DESC')",;		//Regra
			"JI2_DESGRP",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JI5_CODGRP",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JHX',1,xFilial('JHX')+M->JI5_CODGRP,'JHX_DESC')",;		//Regra
			"JI5_DESGRP",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

/*********************************************************************************************
Realiza a gravacao das informacoes do array na tabela SX7
*********************************************************************************************/
ProcRegua(Len(aSX7))

dbSelectArea("SX7")
SX7->(DbSetOrder(1))	
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !DbSeek(aSX7[i,1]+aSX7[i,2])
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
		IncProc("Atualizando Gatilhos...")
		Conout("Atualizando Gatilhos...")
	EndIf
Next i

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSIX  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX - Indices       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME SHOWPESQ
Local lSix      := .F.                      //Verifica se houve atualizacao
Local aSix      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SiX
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ''						//Alias para tabelas
Local lDelInd   := .F.
/*********************************************************************************************
Define estrutura do array
*********************************************************************************************/
aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3",;
		   "NICKNAME","SHOWPESQ"}

aAdd(aSIX,{"JHV",;   										//Indice
		"1",;                 								//Ordem
		"JHV_FILIAL+JHV_CODMOD",;  							//Chave
		"Cod. Modelo",;     								//Descicao Port.
		"Cod. Modelo",;     								//Descicao Port.
		"Cod. Modelo",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  

aAdd(aSIX,{"JHV",;   										//Indice
		"2",;                 								//Ordem
		"JHV_FILIAL+JHV_DESC",;  							//Chave
		"Descricao",;	     								//Descicao Port.
		"Descricao",;	     								//Descicao Port.
		"Descricao",;	     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  
		
aAdd(aSIX,{"JHW",;                                          //Indice                        
		"1",;                                               //Ordem
		"JHW_FILIAL+JHW_CODMOD+JHW_ITEMOD",;  				//Chave
		"Cod. Modelo+Item",; 								//Descicao Port.
		"Cod. Modelo+Item",; 								//Descicao Port.
		"Cod. Modelo+Item",;								//Descicao Port.
		"S",; 												//Proprietario
		"",; 												//F3
		"",; 		 									 	//NickName
		"S"})            

aAdd(aSIX,{"JHX",;   										//Indice
		"1",;                 								//Ordem
		"JHX_FILIAL+JHX_CODGRP",;							//Chave
		"Cod. Grupo",; 										//Descicao Port.
		"Cod. Grupo",; 										//Descicao Port.
		"Cod. Grupo",; 										//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JHX",;   										//Indice
		"2",;                 								//Ordem
		"JHX_FILIAL+JHX_DESC",;								//Chave
		"Descricao",; 										//Descicao Port.
		"Descricao",;										//Descicao Port.
		"Descricao",; 										//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JHY",;                                          //Indice
		"1",;                                               //Ordem
		"JHY_FILIAL+JHY_CODGRP+JHY_ITEGRP",;                //Chave
		"Cod. Grupo+Item",; 								//Descicao Port.
		"Cod. Grupo+Item",; 								//Descicao Port.
		"Cod. Grupo+Item",; 								//Descicao Port.
		"S",;                                               //Proprietario
		"",;                                                //F3
		"",;                                                //NickName
		"S"})                                               //ShowPesq

aAdd(aSIX,{"JHZ",;   										//Indice
		"1",;                 								//Ordem
		"JHZ_FILIAL+JHZ_CURSO+JHZ_VERSAO+JHZ_PERLET+JHZ_HABILI+JHZ_COMP",;  						//Chave
		"Cod.Curso+Versao+Per. Letivo+Habilitacao+Componente",;     								//Descicao Port.
		"Cod.Curso+Versao+Per. Letivo+Habilitacao+Componente",;     								//Descicao Port.
		"Cod.Curso+Versao+Per. Letivo+Habilitacao+Componente",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq   

aAdd(aSIX,{"JHZ",;   										//Indice
		"2",;                 								//Ordem
		"JHZ_FILIAL+JHZ_CURSO+JHZ_VERSAO+JHZ_PERLET+JHZ_HABILI+JHZ_CODDIS",;  						//Chave
		"Cod.Curso+Versao+Per. Letivo+Habilitacao+Disciplina",;     								//Descicao Port.
		"Cod.Curso+Versao+Per. Letivo+Habilitacao+Disciplina",;     								//Descicao Port.
		"Cod.Curso+Versao+Per. Letivo+Habilitacao+Disciplina",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq   
		
aAdd(aSIX,{"JI1",;   										//Indice
		"1",;                 								//Ordem
		"JI1_FILIAL+JI1_CURSO+JI1_VERSAO+JI1_PERLET+JI1_HABILI+JI1_COMP+JI1_ITEMOD",;  				//Chave
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item",;     								//Descicao Port.
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item",;     								//Descicao Port.
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JI2",;   										//Indice
		"1",;                 								//Ordem
		"JI2_FILIAL+JI2_CURSO+JI2_VERSAO+JI2_PERLET+JI2_HABILI+JI2_COMP+JI2_ITEMOD+JI2_CODGRP",;    //Chave
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
		
aAdd(aSIX,{"JI3",;   										//Indice
		"1",;                 								//Ordem
		"JI3_FILIAL+JI3_CODCUR+JI3_PERLET+JI3_HABILI+JI3_COMP",;    //Chave
		"Cod.Curso+Per.Letivo+Habilitacao+Componente",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JI3",;   										//Indice
		"2",;                 								//Ordem
		"JI3_FILIAL+JI3_CODCUR+JI3_COMP",;    				//Chave
		"Cod.Curso+Componente",;     						//Descicao Port.
		"Cod.Curso+Componente",;     						//Descicao Port.
		"Cod.Curso+Componente",;     						//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"N"}) 												//ShowPesq
                                                                        
aAdd(aSIX,{"JI4",;   										//Indice
		"1",;                 								//Ordem
		"JI4_FILIAL+JI4_CODCUR+JI4_PERLET+JI4_HABILI+JI4_COMP+JI4_ITEMOD",;    //Chave
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JI5",;   										//Indice
		"1",;                 								//Ordem
		"JI5_FILIAL+JI5_CODCUR+JI5_PERLET+JI5_HABILI+JI5_COMP+JI5_ITEMOD+JI5_CODGRP",;    //Chave
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
                                                                         
aAdd(aSIX,{"JI5",;   										//Indice
		"2",;                 								//Ordem
		"JI5_FILIAL+JI5_CODCUR+JI5_PERLET+JI5_HABILI+JI5_COMP+JI5_CODGRP",;   								 //Chave
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"Cod.Curso+Per.Letivo+Habilitacao+Componente+Item+Gr.Atividade",;     								//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JI6",;   										//Indice
		"1",;                 								//Ordem
		"JI6_FILIAL+JI6_NUMRA+JI6_CODCUR+JI6_COMP",;    		//Chave
		"Num RA+Curso+Componente",;     					//Descicao Port.
		"Num RA+Curso+Componente",;     					//Descicao Port.
		"Num RA+Curso+Componente",;     					//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JI6",;   										//Indice
		"2",;                 								//Ordem
		"JI6_FILIAL+JI6_CODCUR+JI6_COMP+JI6_NUMRA",;    		//Chave
		"Curso+Componente+Num RA",;     					//Descicao Port.
		"Curso+Componente+Num RA",;     					//Descicao Port.
		"Curso+Componente+Num RA",;     					//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"N"}) 												//ShowPesq

aAdd(aSIX,{"JII",;   										//Indice
		"1",;                 								//Ordem
		"JII_FILIAL+JII_NUMRA+JII_CODCUR+JII_PERLET+JII_HABILI+JII_TURMA+JII_COMP+JII_CODGRP+JII_ATIVID",;  //Chave
		"Num RA+Curso+Per.Letivo+Habilitacao+Turma+Componente",;     					//Descicao Port.
		"Num RA+Curso+Per.Letivo+Habilitacao+Turma+Componente",;     					//Descicao Port.
		"Num RA+Curso+Per.Letivo+Habilitacao+Turma+Componente",;     					//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
		
aAdd(aSIX,{"JAY",;   										//Indice
		"5",;                 								//Ordem
		"JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_COMP+JAY_ITEMOD+JAY_CODDIS",;    //Chave
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item+Disciplina",;     						//Descicao Port.
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item+Disciplina",;     						//Descicao Port.
		"Curso+Versao+Per.Letivo+Habilitacao+Componente+Item+Disciplina",;     						//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"N"}) 												//ShowPesq

aAdd(aSIX,{"JAS",;   										//Indice
		"4",;                 								//Ordem
		"JAS_FILIAL+JAS_CODDIS+JAS_PERLET+JAS_HABILI",;  	//Chave
		"Disciplina+Per.Letivo+Habilitacao",;     				//Descicao Port.
		"Disciplina+Per.Letivo+Habilitacao",;     				//Descicao Port.
		"Disciplina+Per.Letivo+Habilitacao",;     				//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JAS",;   										//Indice
		"5",;                 								//Ordem
		"JAS_FILIAL+JAS_CODDIS+JAS_CODCUR+JAS_PERLET+JAS_HABILI",;  //Chave
		"Disciplina+Curso+Per.Letivo+Habilitacao",;     				//Descicao Port.
		"Disciplina+Curso+Per.Letivo+Habilitacao",;     				//Descicao Port.
		"Disciplina+Curso+Per.Letivo+Habilitacao",;     				//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JAS",;   										//Indice
		"6",;                 								//Ordem
		"JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_COMP+JAS_ITEMOD+JAS_CODDIS",;  //Chave
		"Curso+Per.Letivo+Habilitacao+Componente+Item+Disciplina",;     				//Descicao Port.
		"Curso+Per.Letivo+Habilitacao+Componente+Item+Disciplina",;     				//Descicao Port.
		"Curso+Per.Letivo+Habilitacao+Componente+Item+Disciplina",;     				//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"N"}) 												//ShowPesq

aAdd(aSIX,{"JAS",;   										//Indice
		"7",;                 								//Ordem
		"JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_COMP+JAS_CODDIS",;  //Chave
		"Curso+Per.Letivo+Componente+Disciplina",;     			  //Descicao Port.
		"Curso+Per.Letivo+Componente+Disciplina",;     			  //Descicao Port.
		"Curso+Per.Letivo+Componente+Disciplina",;     			  //Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JAS",;   										//Indice
		"8",;                 								//Ordem
		"JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_COMP+JAS_CODDIS",;  //Chave
		"Curso+Per.Letivo+Habilitacao+Componente+Disciplina",;     			 //Descicao Port.
		"Curso+Per.Letivo+Habilitacao+Componente+Disciplina",;     			 //Descicao Port.
		"Curso+Per.Letivo+Habilitacao+Componente+Disciplina",;     			 //Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{	"JHT",;   										//Indice
			"1",;                 							//Ordem
			"JHT_FILIAL+JHT_NUM",;  						//Chave
			"Numero de controle",;     						//Descicao Port.
			"Numero de controle",;     						//Descicao Port.
			"Numero de controle",;     						//Descicao Port.
			"S",; 											//Proprietario
			"",;  											//F3
			"",;  											//NickName
			"S"}) 											//ShowPesq  

aAdd(aSIX,{	"JHT",;   										//Indice
			"2",;                 							//Ordem
			"JHT_FILIAL+JHT_NUMRA+JHT_CODCUR+JHT_PERLET+JHT_HABILI+JHT_TURMA+JHT_NUM",;  							//Chave
			"RA+Curso vigente+Periodo letivo+Habilitacao+Turma+Num. Controle",;     						//Descicao Port.
			"RA+Curso vigente+Periodo letivo+Habilitacao+Turma+Num. Controle",;     						//Descicao Port.
			"RA+Curso vigente+Periodo letivo+Habilitacao+Turma+Num. Controle",;     						//Descicao Port.
			"S",; 											//Proprietario
			"",;  											//F3
			"",;  											//NickName
			"S"}) 											//ShowPesq  

aAdd(aSIX,{	"JHU",;   										//Indice
			"1",;                 							//Ordem
			"JHU_FILIAL+JHU_NUM+JHU_CODDIS",;  				//Chave
			"Numero de controle+Disciplina",;     			//Descicao Port.
			"Numero de controle+Disciplina",;     			//Descicao Port.
			"Numero de controle+Disciplina",;     			//Descicao Port.
			"S",; 											//Proprietario
			"",;  											//F3
			"",;  											//NickName
			"S"}) 

aAdd(aSIX,{	"JHU",;   										//Indice
			"2",;                 							//Ordem
			"JHU_FILIAL+JHU_CODDIS+JHU_SEQDIS",;  			//Chave
			"Disciplina+Sequencial",;     					//Descicao Port.
			"Disciplina+Sequencial",;     					//Descicao Port.
			"Disciplina+Sequencial",;     					//Descicao Port.
			"S",; 											//Proprietario
			"",;  											//F3
			"",;  											//NickName
			"S"}) 
			
aAdd(aSIX,{	"JHU",;   										//Indice
			"3",;                 							//Ordem
			"JHU_FILIAL+JHU_NUM+JHU_CODDIS+JHU_C7SITD+JHU_C7SITU+JHU_C7TPCU",;  					//Chave
			"Num.Controle+Disciplina+Sit.Mat.Disc+Sit.Final+Tipo Curs",;     						//Descicao Port.
			"Num.Controle+Disciplina+Sit.Mat.Disc+Sit.Final+Tipo Curs",;     						//Descicao Port.
			"Num.Controle+Disciplina+Sit.Mat.Disc+Sit.Final+Tipo Curs",;     						//Descicao Port.
			"S",; 											//Proprietario
			"",;  											//F3
			"",;  											//NickName
			"S"}) 											//ShowPesq  

/*********************************************************************************************
Grava as informacoes do array na tabela six
*********************************************************************************************/
ProcRegua(Len(aSIX))

dbSelectArea("SIX")
SIX->(DbSetOrder(1))	

For i:= 1 To Len(aSIX)
   
	If !Empty(aSIX[i,1])
		If !DbSeek(aSIX[i,1]+aSIX[i,2])
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
		IncProc("Atualizando índices...")
		Conout("Atualizando índices...")
	EndIf
Next i

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSXB  ³Autora ³Solange Zanardi        ³ Data ³02/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para atualização das consultas padroes do sistema   ³±±
±±³          ³ para quando o cliente for utilizar visibilidade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSXB(cCodFilial)
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
aAdd(aSXB,{	"JHV","1","01","DB",;		// ALIAS, TIPO, SEQ, COLUNA
			"Modelos Curriculares",;	// DESCRI
			"Modelos Curriculares",;	// DESCRI
			"Modelos Curriculares",;	// DESCRI
			"JHV", "" })				// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","2","02","02",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","4","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"JHV_CODMOD", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","4","01","02",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"JHV_DESC", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","4","02","03",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"JHV_DESC", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","4","02","04",;		// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"JHV_CODMOD", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHV","5","01","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JHV_CODMOD", "" })			// CONTEM, WCONTEM


aAdd(aSXB,{	"JHX","1","01","DB",;		// ALIAS, TIPO, SEQ, COLUNA
			"Grupos de Atividades",;	// DESCRI
			"Grupos de Atividades",;	// DESCRI
			"Grupos de Atividades",;	// DESCRI
			"JHX", "" })				// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","2","02","02",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","4","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"JHX_CODGRP", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","4","01","02",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"JHX_DESC", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","4","02","03",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"JHX_DESC", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","4","02","04",;		// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"Codigo",;					// DESCRI
			"JHX_CODGRP", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHX","5","01","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JHX->JHX_CODGRP", "" })	// CONTEM, WCONTEM

aAdd(aSXB,{	"JHY","1","01","DB",;		// ALIAS, TIPO, SEQ, COLUNA
			"Grp Atividades",;			// DESCRI
			"Grp Atividades",;			// DESCRI
			"Grp Atividades",;			// DESCRI
			"JHY", "" })				// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Cod.Grupo+Item",;			// DESCRI
			"Cod.Grupo+Item",;			// DESCRI
			"Cod.Grupo+Item",;			// DESCRI
			"", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","4","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Cod.Grupo",;				// DESCRI
			"Cod.Grupo",;				// DESCRI
			"Cod.Grupo",;				// DESCRI
			"JHY_CODGRP", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","4","01","02",;		// ALIAS, TIPO, SEQ, COLUNA
			"Item",;					// DESCRI
			"Item",;					// DESCRI
			"Item",;					// DESCRI
			"JHY_ITEGRP", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","4","01","03",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"Descricao",;				// DESCRI
			"JHY_DESC", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","5","01","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JHY->JHY_CODGRP", "" })	// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","5","02","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JHY->JHY_ITEGRP", "" })	// CONTEM, WCONTEM	
aAdd(aSXB,{	"JHY","5","03","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JHY->JHY_DESC", "" })		// CONTEM, WCONTEM
aAdd(aSXB,{	"JHY","6","01","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JHY->JHY_CODGRP $ ACA675Grp()", "" })		// CONTEM, WCONTEM


aAdd(aSXB,{	"JAH002","1","01","DB",;		// ALIAS, TIPO, SEQ, COLUNA
			"Curso Vig. x Aluno",;			// DESCRI
			"Curso Vig. x Aluno",;			// DESCRI
			"Curso Vig. x Aluno",;			// DESCRI
			"JAH", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JAH002","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Curso Vigent",;			// DESCRI
			"Curso Vigent",;			// DESCRI
			"Cur. Course",;				// DESCRI
			"", "" })					// CONTEM, WCONTEM
aAdd(aSXB,{	"JAH002","4","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Curso Vigent",;			// DESCRI
			"Curso Vigent",;			// DESCRI
			"Cur. Course",;				// DESCRI
			"JAH_CODIGO", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JAH002","4","01","02",;	// ALIAS, TIPO, SEQ, COLUNA
			"Desc. Curric.",;			// DESCRI
			"Desc. Curric.",;			// DESCRI
			"Resum. Desc.",;			// DESCRI
			"JAH_DESC", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JAH002","5","01","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JAH->JAH_CODIGO", "" })			// CONTEM, WCONTEM
aAdd(aSXB,{	"JAH002","6","01","",;			// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JAH->JAH_CODIGO $ ACA675CrVig()", "" })	// CONTEM, WCONTEM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa consultas para alteracao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aSXB))

dbSelectArea("SXB")
SXB->(dbSetOrder(1)) //XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA	
For i := 1 To Len(aSXB)
	If !DbSeek(PadR(aSXB[i,1],6)+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
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
	IncProc("Atualizando consulta padrao...")
	Conout("Atualizando consulta padrao...")
Next i

Return

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
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .F. )
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GELimpaSX ³ Autor ³Rafael Rodrigues    ³ Data ³ 01/Fev/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Elimina dados do dicionario antes da atualizacao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GELimpaSX()
Local i
Local aDelSX2	:= {"JAS","JAY"}
Local aDelSIX	:= {"JAS4","JAS5","JAY5"}
Local aDelSXB	:= {}
Local aDelSX3	:= {"JI6_DCOMP"}

SX2->( dbSetOrder(1) )
for i := 1 to len( aDelSX2 )
	if SX2->( dbSeek( aDelSX2[i] ) )
		TCSQLExec("DROP INDEX "+RetSQLName(aDelSX2[i])+"."+RetSQLName(aDelSX2[i])+"_UNQ")
		RecLock( "SX2", .F. )
		SX2->( dbDelete() )
		SX2->( msUnlock() )
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

SIX->( dbSetOrder(1) )
for i := 1 to len( aDelSIX )
	if SIX->( dbSeek( aDelSIX[i] ) )
		RecLock( "SIX", .F. )
		SIX->( dbDelete() )
		SIX->( msUnlock() )
	endif
next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GETiraUso ³ Autor ³Rafael Rodrigues    ³ Data ³ 02/Fev/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tira campos obsoletos de uso no SX3                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETiraUso()
Local cUsadoNao		:= ''
Local cReservNao	:= ''
Local aCampos		:= {"JAY_QTDFAT", "JAY_VALOR", "JAY_ITEJAW", "JAS_QTDFAT", "JAS_VALOR", "JAS_QAULAS"}
Local cOrdem
Local i

SX3->( dbSetOrder(2) )
if SX3->( dbSeek("JAE_FILIAL") ) //Este campo nao eh usado
	cUsadoNao	:= SX3->X3_USADO
	cReservNao	:= SX3->X3_RESERV
endif

for i := 1 to len( aCampos )
	if SX3->( dbSeek(aCampos[i]) )
		RecLock("SX3",.F.)
		SX3->X3_USADO	:= cUsadoNao
		SX3->X3_RESERV	:= cReservNao
		SX3->( msUnlock() )
	endif
next i

// Muda o titulo dos campos JAS_TIPO, JAY_TIPO e JAY_STATUS para evitar duvidas
if SX3->( dbSeek("JAS_TIPO") )
	RecLock("SX3",.F.)
	SX3->X3_TITULO	:= "No Pe.Letivo"
	SX3->X3_TITENG	:= "No Pe.Letivo"
	SX3->X3_TITSPA	:= "No Pe.Letivo"
	SX3->( msUnlock() )
endif
if SX3->( dbSeek("JAY_TIPO") )
	RecLock("SX3",.F.)
	SX3->X3_TITULO	:= "No Pe.Letivo"
	SX3->X3_TITENG	:= "No Pe.Letivo"
	SX3->X3_TITSPA	:= "No Pe.Letivo"
	SX3->( msUnlock() )
	cOrdem	:= SX3->X3_ORDEM
endif
if SX3->( dbSeek("JAY_STATUS") )
	RecLock("SX3",.F.)
	SX3->X3_TITULO	:= "Na Formacao"
	SX3->X3_TITENG	:= "Na Formacao"
	SX3->X3_TITSPA	:= "Na Formacao"
	SX3->X3_ORDEM	:= cOrdem
	SX3->( msUnlock() )
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ão    ³GEProc    ³Autor  ³Carlos Roberto/Rafael  ³ Data ³31/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Prepara as empresas para o processo de atualizacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuBase(cEmp, cFil)
Local i 		:= 0
Local lOk		:= .T.    
Local cCURPAD 	:= ""     
Local cCURVIG 	:= ""     
Local lJAE_PESO := JAE->( FieldPos("JAE_PESO") ) > 0 //Verifica se existe o campo JAE_PESO na Base. Campo para atribuir peso a disciplina

IncProc( dtoc(dDataBase) + " " + Time()+ " Inicio AtuBase")
AcaLogTab( cArquivo, "AtuBase", "Inicio", cEmp + " " +cFil)

dbSelectArea("JAS")
dbSelectArea("JC7")
dbSelectArea("JHW")
dbSelectArea("JHV")
dbSelectArea("JHX")
dbSelectArea("JHY")
dbSelectArea("JHZ")
dbSelectArea("JI1")
dbSelectArea("JI2")
dbSelectArea("JI3")
dbSelectArea("JI4")
dbSelectArea("JI5")
dbSelectArea("JI6")
dbSelectArea("JAF")

IncProc( dtoc( Date() )+" "+Time()+" "+"Criando modelo curricular")
AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Criando modelo curricular")

JHV->( dbSetOrder(1) ) //JHV_FILIAL+JHV_CODMOD
//JAY->( dbSetOrder(1) ) //JAY.JAY_CURSO,JAY.JAY_VERSAO+JAY.JAY_PERLET+JAY.JAY_HABILI+JAY.JAY_CODDIS

If JHV-> ( !dbSeek( xFilial("JHV") + '000001' ) )
	// Adiciona modelo curricular Generico na JHV
	RecLock("JHV",.T.) //Adiciona registro
	JHV->JHV_FILIAL := xFilial("JHV")
	JHV->JHV_CODMOD := '000001'
	JHV->JHV_DESC   := 'GENERICO'
	JHV->JHV_STATUS := '1'
	MsUnLock()

	// Adiciona itens do modelo curricular na JHW (001 - Teorico, 002 - Pratico)
	JHW->( dbSetOrder(1) ) //JHW_FILIAL+JHW_CODMOD+JHW_ITEMOD
	If JHW-> ( !dbSeek( xFilial("JHW") + '000001' + '001' ) )
		RecLock("JHW",.T.) //Adiciona registro
		JHW->JHW_FILIAL := xFilial("JHW")
		JHW->JHW_CODMOD := '000001'
		JHW->JHW_ITEMOD := '001'
		JHW->JHW_DESC   := 'TEORIA'
		JHW->JHW_TPCONT := '1'
		JHW->JHW_CARGA  := '2'
		JHW->JHW_CREDIT := '1'
		MsUnLock()
	EndIf

	If JHW-> ( !dbSeek( xFilial("JHW") + '000001' + '002' ) )
		RecLock("JHW",.T.) //Adiciona registro
		JHW->JHW_FILIAL := xFilial("JHW")
		JHW->JHW_CODMOD := '000001'
		JHW->JHW_ITEMOD := '002'
		JHW->JHW_DESC   := 'PRATICA'
		JHW->JHW_TPCONT := '1'
		JHW->JHW_CARGA  := '2'
		JHW->JHW_CREDIT := '1'
		MsUnLock()
	EndIf

EndIf

//******************************************************************************************************************
//Atualizando Curso Padrão
//******************************************************************************************************************
cQuery := "SELECT "
cQuery += " 	JAF.JAF_COD, JAF.JAF_VERSAO, JAY.JAY_CODDIS, JAF.JAF_CODMOD, JAY.JAY_CURSO,JAY.JAY_VERSAO,JAY.JAY_PERLET,JAY.JAY_HABILI, JAY.JAY_STATUS"
cQuery += " FROM"
cQuery += " " + RetSqlName("JAF") + " JAF,"
cQuery += " " + RetSqlName("JAY") + " JAY"  
cQuery += " WHERE"
cQuery += " JAF.JAF_FILIAL = '" + xFilial("JAF") + "' AND JAF.D_E_L_E_T_ <> '*' AND"	
cQuery += " JAY.JAY_FILIAL = '" + xFilial("JAY") + "' AND JAY.D_E_L_E_T_ <> '*' AND"	
cQuery += " JAF.JAF_COD = JAY.JAY_CURSO AND"
cQuery += " JAF.JAF_VERSAO = JAY.JAY_VERSAO"
cQuery += " ORDER BY " + SqlOrder( JAY->( IndexKey() ) )

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"trbJAF", .F., .T.)

ProcRegua( 2 + TRBJAF->( RecCount() ) )

While !trbJAF->(Eof())	.and. lOk  		
	    
	If !trbJAF->JAF_COD+trbJAF->JAF_VERSAO == cCURPAD

		IncProc( dtoc( Date() )+" "+Time()+" "+"Atualizando curso " + trbJAF->JAF_COD+" "+trbJAF->JAF_VERSAO )
		AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Atualizando curso " + trbJAF->JAF_COD+" "+trbJAF->JAF_VERSAO )
			
		i := 0		

		JAF->( dbSetOrder(1) )
		JAF->( DbSeek( xFilial("JAF")+trbJAF->JAF_COD+trbJAF->JAF_VERSAO ) )		
		RecLock("JAF",.F.)
		JAF->JAF_CODMOD	:= "000001"
		JAF->(MsUnlock())       
		cCURPAD := trbJAF->JAF_COD+trbJAF->JAF_VERSAO
				
    Endif

	JAE->( DbSetOrder(1) )
	If JAE->( DbSeek( xFilial("JAE") + trbJAF->JAY_CODDIS ) )
		lOk := IncluiJHZ(JAE->JAE_CODIGO, JAE->JAE_DISPAI, @i, lJAE_PESO)
	Else
		lOk := .T.
		//Aviso("Disciplina nao Localizada",trbJAF->JAY_CODDIS,{"Ok"},2)
		AcaLog( cErros, dtoc( Date() )+" "+Time()+" "+"Disciplina nao Localizada " + trbJAF->JAY_CODDIS + ". Curso padrao " + trbJAF->JAF_COD )
	EndIf
	
	trbJAF->(dbSkip())
End

trbJAF->(dbCloseArea())  

//******************************************************************************************************************
//Atualizando Curso Vigente
//******************************************************************************************************************
cQuery := "SELECT "
cQuery += " 	JAH.JAH_CODIGO, JAH.JAH_CURSO, JAH.JAH_VERSAO, JAH.JAH_STATUS, JAS.JAS_CODCUR, JAS.JAS_CODDIS,JAS.JAS_PERLET,JAS.JAS_HABILI,JAS.JAS_ITEM"    
cQuery += " FROM"
cQuery += " " + RetSqlName("JAH") + " JAH,"
cQuery += " " + RetSqlName("JAS") + " JAS"  
cQuery += " WHERE"
cQuery += " JAH.JAH_FILIAL = '" + xFilial("JAH") + "' AND JAH.D_E_L_E_T_ <> '*' AND"	
cQuery += " JAS.JAS_FILIAL = '" + xFilial("JAS") + "' AND JAS.D_E_L_E_T_ <> '*' AND"	
cQuery += " JAH.JAH_CODIGO = JAS.JAS_CODCUR"
cQuery += " ORDER BY " + SqlOrder( JAS->( IndexKey() ) )

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"trbJAH", .F., .T.)

ProcRegua( 2 + TRBJAH->( RecCount() ) )

While !trbJAH->(Eof())	.and. lOk  		

	If !trbJAH->JAH_CODIGO == cCURVIG
		IncProc( dtoc( Date() )+" "+Time()+" "+"Atualizando curso vigente " + trbJAH->JAH_CODIGO )
		AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Atualizando curso vigente " + trbJAH->JAH_CODIGO )
			    
		JAH->( DbSetOrder(1) )
		JAH->( DbSeek( xFilial("JAH")+trbJAH->JAH_CODIGO ) )
		RecLock("JAH",.F.)
		JAH->JAH_STATUS	:= If( trbJAH->JAH_STATUS <> "2", "1", "2" )
		JAH->( MsUnlock() )
		cCURVIG := trbJAH->JAH_CODIGO
	Endif
	
	JAE->( DbSetOrder(1) )
	If JAE->( DbSeek( xFilial("JAE") + trbJAH->JAS_CODDIS ) )
		lOk := IncluiJI3( trbJAH->JAH_CURSO, trbJAH->JAH_VERSAO, JAE->JAE_CODIGO, JAE->JAE_DISPAI, lJAE_PESO )
	Else
		lOk := .T.
		//Aviso("Disciplina nao Localizada",trbJAS->JAS_CODDIS,{"Ok"},2)                                     
		AcaLog( cErros, dtoc( Date() )+" "+Time()+" "+"Disciplina nao Localizada " + trbJAH->JAS_CODDIS + ". Curso vigente " + trbJAH->JAH_CODIGO )
	EndIf
	
	trbJAH->(dbSkip())
End
trbJAH->(dbCloseArea())

// Gera componentes para todos os alunos da base      
IncluiJI6(cEmp, cFil)

AcaLogTab( cArquivo, "AtuBase", "Fim", cEmp + " " + cFil)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ão    ³IncluiJHZ ³Autor  ³Carlos Roberto/Rafael  ³ Data ³31/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Incluir registros da JHZ e JI1                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluiJHZ( cCodDis, cDisPai, i, lJAE_PESO )
Local cDisJHZ	:= if( Empty(cDisPai), cCodDis, cDisPai )

JAE->( dbSetOrder(1) ) //JAE_FILIAL+JAE_CODIGO
JAE->( dbSeek( xFilial("JAE")+cDisJHZ ) )

JHZ->( dbSetOrder(2) ) //JHZ_FILIAL+JHZ_CURSO+JHZ_VERSAO+JHZ_PERLET+JHZ_HABILI+JHZ_CODDIS
if JHZ->( !dbSeek( xFilial("JHZ") + trbJAF->(JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+cDisJHZ) ) )  
    
	// Incrementa 1 no codigo do componente
	i++
                       
	//Adiciona registro
	RecLock("JHZ",.T.)
	JHZ->JHZ_FILIAL := xFilial("JHZ")                              
	JHZ->JHZ_CURSO  := trbJAF->JAY_CURSO
	JHZ->JHZ_VERSAO := trbJAF->JAY_VERSAO
	JHZ->JHZ_PERLET := trbJAF->JAY_PERLET
	JHZ->JHZ_HABILI := trbJAF->JAY_HABILI
	JHZ->JHZ_COMP   := StrZero(i, 3)
	JHZ->JHZ_DESC   := JAE->JAE_DESC
	JHZ->JHZ_CODDIS := cDisJHZ
	JHZ->JHZ_TIPCOM := trbJAF->JAY_STATUS
	JHZ->JHZ_TIPAPR := '1'
	JHZ->JHZ_TIPREP := '1'           
	JHZ->JHZ_COREQ 	:= JAE->JAE_COREQ
	
	JHZ->( MsUnLock() )
	 
endif

JAE-> ( dbSeek( xFilial("JAE")+cCodDis ) )
If JAE->JAE_TIPO == '001' 	// Teorica
	cIteMod	:= '001'		// Pasta Teoria
else
	cIteMod	:= '002'		// Pasta Pratica
endif	

// JI1_FILIAL+JI1_CURSO+JI1_VERSAO+JI1_PERLET+JI1_HABILI+JI1_COMP+JI1_ITEMOD
JI1->( dbSetOrder(1) ) //JI1_FILIAL+JI1_CURSO+JI1_VERSAO+JI1_PERLET+JI1_HABILI+JI1_COMP+JI1_ITEMOD
if JI1->( !dbSeek( xFilial("JI1")+JHZ->(JHZ_CURSO+JHZ_VERSAO+JHZ_PERLET+JHZ_HABILI+JHZ_COMP)+cIteMod ) )
	// Inclui registro no JI1
	RecLock("JI1",.T.) //Adiciona registro
	JI1->JI1_FILIAL := xFilial("JI1")
	JI1->JI1_CURSO  := trbJAF->JAY_CURSO
	JI1->JI1_VERSAO := trbJAF->JAY_VERSAO
	JI1->JI1_PERLET := trbJAF->JAY_PERLET
	JI1->JI1_HABILI := trbJAF->JAY_HABILI
	JI1->JI1_COMP   := JHZ->JHZ_COMP
	JI1->JI1_ITEMOD := cIteMod
	JI1->JI1_CARMIN	:= JAE->JAE_CARGA
	MsUnLock()
	
	// Vincula JAY ao componente criado
	JAY->( DbSetOrder(1) ) //JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS
	JAY->( DbSeek( xFilial("JAY")+trbJAF->JAF_COD+trbJAF->JAF_VERSAO+trbJAF->JAY_PERLET+trbJAF->JAY_HABILI+trbJAF->JAY_CODDIS) )			
	RecLock("JAY",.F.) //Altera registro
	JAY->JAY_COMP   := JHZ->JHZ_COMP
	JAY->JAY_ITEMOD := cIteMod
	//Atualiza o campo JAY_PESO
	JAE->( dbSeek( xFilial("JAE") + trbJAF->JAY_CODDIS ) )
	//Se existir o campo JAE_PESO atualiza o campo JAY_PESO com o mesmo valor contido no campo JAE_PESO
	if lJAE_PESO .and. JAE->JAE_PESO > 0
		JAY->JAY_PESO := JAE->JAE_PESO
	else //Se nao possuir peso cadastrado para a disciplina, atribui peso = 1
		JAY->JAY_PESO := 1
	endif
	MsUnLock()
endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ão    ³IncluiJI3 ³Autor  ³Carlos Roberto/Rafael  ³ Data ³31/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Incluir registros da JI3 e JI4                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluiJI3( cCurso, cVersao, cCodDis, cDisPai, lJAE_PESO )
Local cDisJI3	:= if( Empty(cDisPai), cCodDis, cDisPai )
Local lNovoComp	:= .F.

JHZ->( dbSetOrder(2) ) //JHZ_FILIAL+JHZ_CURSO+JHZ_VERSAO+JHZ_PERLET+JHZ_HABILI+JHZ_CODDIS
if JHZ->( !dbSeek( xFilial("JHZ")+cCurso+cVersao+trbJAH->JAS_PERLET+trbJAH->JAS_HABILI+cDisJI3 ) )
	//Aviso("Sem componente","Não foi possivel encontrar o componente para a disciplina "+cDisJI3+" do curso vigente "+JAS->JAS_CODCUR+" período "+JAS->JAS_PERLET, {"Ok"}, 2)
	AcaLog( cErros, dtoc( Date() )+" "+Time()+" "+"Sem componente - Não foi possivel encontrar o componente para a disciplina " + cDisJI3 +" do curso vigente "+trbJAH->JAS_CODCUR+" período "+trbJAH->JAS_PERLET )	
	Return .T.
endif

JI3->( dbSetOrder(1) ) //JI3_FILIAL+JI3_CODCUR+JI3_PERLET+JI3_HABILI+JI3_COMP
if JI3->( !dbSeek( xFilial("JI3")+trbJAH->(JAS_CODCUR+JAS_PERLET+JAS_HABILI)+JHZ->JHZ_COMP ) )
	RecLock("JI3",.T.) //Adiciona registro
	JI3->JI3_FILIAL	:= xFilial("JI3")
	JI3->JI3_CODCUR	:= trbJAH->JAS_CODCUR
	JI3->JI3_PERLET	:= trbJAH->JAS_PERLET
	JI3->JI3_HABILI	:= trbJAH->JAS_HABILI
	JI3->JI3_COMP	:= JHZ->JHZ_COMP
	JI3->JI3_DESC	:= JHZ->JHZ_DESC
	JI3->JI3_TIPO	:= Iif(Empty(Posicione("JAY",1,xFilial("JAY")+cCurso+cVersao+trbJAH->JAS_PERLET+trbJAH->JAS_HABILI+cDisJI3, "JAY_STATUS")),'1',Posicione("JAY",1,xFilial("JAY")+cCurso+cVersao+trbJAH->JAS_PERLET+trbJAH->JAS_HABILI+cDisJI3, "JAY_STATUS"))
	JI3->JI3_TIPAPR	:= '1'
	JI3->JI3_TIPREP	:= '1'
	JI3->( MsUnLock() )
	                     
	lNovoComp	:= .T.
endif

JAE-> ( dbSeek( xFilial("JAE")+cCodDis ) )
If JAE->JAE_TIPO == '001' // Teorica
	cIteMod	:= '001'	// Pasta Teoria
else
	cIteMod	:= '002'	// Pasta Pratica
endif	

JI4->( dbSetOrder(1) ) //JI4_FILIAL+JI4_CODCUR+JI4_PERLET+JI4_HABILI+JI4_COMP+JI4_ITEMOD
if JI4->( !dbSeek( xFilial("JI4")+JI3->(JI3_CODCUR+JI3_PERLET+JI3_HABILI+JI3_COMP)+cIteMod ) )
	// Inclui registro no JI1
	RecLock("JI4",.T.) //Adiciona registro
	JI4->JI4_FILIAL	:= xFilial("JI4")
	JI4->JI4_CODCUR	:= trbJAH->JAS_CODCUR
	JI4->JI4_PERLET	:= trbJAH->JAS_PERLET
	JI4->JI4_HABILI	:= trbJAH->JAS_HABILI
	JI4->JI4_COMP	:= JI3->JI3_COMP
	JI4->JI4_ITEMOD	:= cIteMod
	JI4->JI4_CARMIN	:= JAE->JAE_CARGA
	MsUnLock()
	
	// Vincula JAS ao componente criado
	JAS->( DbSetOrder(1) )	//JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_ITEM
	JAS->( DbSeek( xFilial("JAS")+trbJAH->JAS_CODCUR+trbJAH->JAS_PERLET+trbJAH->JAS_HABILI+trbJAH->JAS_ITEM) )
	RecLock("JAS",.F.) //Altera registro
	JAS->JAS_COMP   := JI3->JI3_COMP
	JAS->JAS_ITEMOD := cIteMod
	//Atualiza o campo JAS_PESO
	JAE->( dbSeek( xFilial("JAE") + JAS->JAS_CODDIS ) )
	//Se existir o campo JAE_PESO atualiza o campo JAS_PESO com o mesmo valor contido no campo JAE_PESO
	if lJAE_PESO .and. JAE->JAE_PESO > 0
		JAS->JAS_PESO := JAE->JAE_PESO
	else //Se nao possuir peso cadastrado para a disciplina, atribui peso = 1
		JAS->JAS_PESO := 1
	endif
	MsUnLock()
endif

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncluiJI6 ºAutor  ³Rafael Rodrigues    º Data ³ 31/Jan/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera componentes x alunos (JI6) para toda a base.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Atualizacao de componentes curriculares                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluiJI6(cEmp, cFil)
Local cQuery		:= ""
Local cQueryJob		:= ""
Local cAlias		:= GetNextAlias()
Local nREC_I		:= 0
Local nREC_F		:= 0
Local lQryJA2		:= .T.
Local nQtdeLote		:= 999			// Quantidade de alunos a serem processados por lote

cQuery := "SELECT MIN(R_E_C_N_O_) as REC"
cQuery += " FROM"
cQuery += " " + RetSqlName("JA2") + " JA2"
cQuery += " WHERE"
cQuery += " JA2.JA2_FILIAL = '" + xFilial("JA2") + "' AND JA2.D_E_L_E_T_ <> '*'

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"trbJA2", .F., .T.)

if !trbJA2->(eof())
	nREC_I :=  trbJA2->REC
	nREC_F :=  trbJA2->REC + nQtdeLote
endif
trbJA2->(dbCloseArea())
                     
lQryJA2 := .T.       
while lQryJA2

	AcaLogTab( cArquivo, "IncluiJI6", "Inicio da query alunos", "")

	cQuery := "select JC7_NUMRA, JC7_CODCUR, JAS_PERLET, JAS_HABILI, JC7_TURMA, JHZ_COMP, JHZ_DESC, Max( JC7_MEDFIM ) JC7_MEDFIM, Min( JC7_SITUAC ) JC7_SITUAC, Count(distinct JAS.R_E_C_N_O_) QUANT "
	cQuery += "  from "
	cQuery += RetSQLName("JC7")+" JC7, "
	cQuery += RetSQLName("JAS")+" JAS, "
	cQuery += RetSQLName("JAH")+" JAH, "
	cQuery += RetSQLName("JHZ")+" JHZ, "
	cQuery += RetSQLName("JA2")+" JA2 "
	cQuery += " where JC7_FILIAL = '"+xFilial("JC7")+"' and JC7.D_E_L_E_T_ = ' ' "
	cQuery += "   and JAS_FILIAL = '"+xFilial("JAS")+"' and JAS.D_E_L_E_T_ = ' ' "
	cQuery += "   and JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' "
	cQuery += "   and JHZ_FILIAL = '"+xFilial("JHZ")+"' and JHZ.D_E_L_E_T_ = ' ' "
	cQuery += "   and JA2_FILIAL = '"+xFilial("JA2")+"' and JHZ.D_E_L_E_T_ = ' ' "	
	cQuery += "   and JC7_CODCUR = JAS_CODCUR"
	cQuery += "   and JAS_CODCUR = JAH_CODIGO"
	cQuery += "   and JAH_CURSO  = JHZ_CURSO"
	cQuery += "   and JAH_VERSAO = JHZ_VERSAO"
	cQuery += "   and JAS_PERLET = JHZ_PERLET"
	cQuery += "   and JAS_HABILI = JHZ_HABILI"
	cQuery += "   and JAS_COMP   = JHZ_COMP"
	cQuery += "   and JA2_NUMRA  = JC7_NUMRA"
	cQuery += "   and JC7_SITUAC not in ('7','8','9','A')"
	cQuery += "   and JA2.R_E_C_N_O_ between '" + Str(nREC_I) + "' AND '" + Str(nREC_F) + "'"
	cQuery += " group by JC7_NUMRA, JC7_CODCUR, JAS_PERLET, JAS_HABILI, JC7_TURMA, JHZ_COMP, JHZ_DESC"
	cQuery += " order by JC7_NUMRA, JC7_CODCUR, JHZ_COMP"
	                     
	// Armazena query a ser processada pelo job
	cQueryJob	:= cQuery
	
	cQuery 		:= ChangeQuery( cQuery )
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )  
	
	AcaLogTab( cArquivo, "IncluiJI6", "Fim da query alunos", "")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle do laco principal. Se nao retornar nada desta query nao deve continuar         ³
	//³ processando.                                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if (cAlias)->( eof() )
		lQryJA2 := .F.
	endif
	
	if lQryJA2
	
		JI6->( dbSetOrder(1) ) //JI6_FILIAL+JI6_NUMRA+JI6_CODCUR+JI6_COMP    
		while (cAlias)->( !eof() )
		
			if JI6->( !dbSeek( xFilial("JI6")+(cAlias)->(JC7_NUMRA+JC7_CODCUR+JHZ_COMP) ) )
	
				RecLock("JI6",.T.)
				JI6->JI6_FILIAL	:= xFilial("JI6")
				JI6->JI6_NUMRA	:= (cAlias)->JC7_NUMRA
				JI6->JI6_CODCUR	:= (cAlias)->JC7_CODCUR
				JI6->JI6_COMP	:= (cAlias)->JHZ_COMP
				JI6->( msUnlock() )
								
				AcaLogTab( cArquivo, "IncluiJI6", "Aluno: " + JI6->JI6_NUMRA, " Filial: " + JI6->JI6_FILIAL )
						
			endif
				
			(cAlias)->( dbSkip() )
		end                             
		
		(cAlias)->( dbCloseArea() )
	
		AcaLogTab( cArquivo, "IncluiJI6", "Startjob - " + StrZero(nREC_I, 6), "Fim " + StrZero(nREC_F, 6))
		Conout("RESQLNAME ANTES DA CHAMADA DO JOB - " + RetSqlName('JI6') )
		Conout("TCCANOPEN ANTES DA CHAMADA DO JOB - " + IIF(TCCANOPEN(RetSqlName('JI6')),"TRUE","FALSE") )
		
		StartJOB ( "JobMedia", GetEnvServer() , .F., cEmp, cFil, cQueryJob, nREC_I, nREC_F)
		
	endif

	nREC_I :=  nREC_F + 1
	nREC_F :=  nREC_F + nQtdeLote

enddo

dbSelectArea("JAF")

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ JobMedia ºAutor  ³Fabio F. Pessoa     º Data ³ 22/05/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Job responsavel pelo calculo da media                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Atualizacao de componentes curriculares                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function JobMedia(cEmp, cFil, cQuery, nRecI, nRecF)
Local cAlias	:= GetNextAlias()
Local cArqLote 	:= "Up" + StrZero(nRecI,6) + ".LOG"		// Nome do log de acordo com o lote

// Nao consome licensa
RPCSetType(3)

RPCSetEnv( cEmp, cFil, ,,,, {"JC7", "JAE", "JI6", "JA2", "JC7", "JAH", "JAR", "JAS", "JI3", "JAF", "JI5", "JHW", "JI4", "JII" })

dbSelectArea('SX2')
dbSelectArea('JI6')

AcaLog( cArqLote, "Inicio - Lote " + StrZero(nRecI, 6), "Fim " + StrZero(nRecF, 6))

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )       

ProcRegua( (cAlias)->( RecCount() ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle do laco principal. Se nao retornar nada desta query nao deve continuar         ³
//³ processando.                                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
JI6->( dbSetOrder(1) ) //JI6_FILIAL + JI6_NUMRA + JI6_CODCUR + JI6_COMP
JAS->( dbSetOrder(7) ) //JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_COMP+JAS_CODDIS
JC7->( dbSetOrder(4) ) //JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_DISCIP
while (cAlias)->( !eof() )
	
	JI6->( dbSetOrder(1) ) //JI6_FILIAL + JI6_NUMRA + JI6_CODCUR + JI6_COMP
	if JI6->( dbSeek( xFilial("JI6") + (cAlias)->(JC7_NUMRA + JC7_CODCUR + JHZ_COMP) ) )
		IncProc("Processando Aluno R.A: " + JI6->JI6_NUMRA)
		if (cAlias)->QUANT == 1
			JAS->( dbSetOrder(7) ) //JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_COMP+JAS_CODDIS
			if JAS->( dbSeek( xFilial("JAS") + (cAlias)->(JC7_CODCUR + JAS_PERLET + JHZ_COMP) ) )
				AcaLogTab( cArqLote, "JobMedia", "* Inicio Média Normal *", JI6->JI6_NUMRA)
				RecLock("JI6",.F.)
				
				JC7->( dbSetOrder(4) ) //JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_DISCIP			
				if JC7->( dbSeek( xFilial("JC7")+ (cAlias)->(JC7_NUMRA)+JAS->JAS_CODCUR+JAS->JAS_CODDIS) )				
					JI6->JI6_SITUAC := iif( (cAlias)->JC7_SITUAC == "5", "3", iif( (cAlias)->JC7_SITUAC == "6", "1", (cAlias)->JC7_SITUAC ) )
				Else
					JI6->JI6_SITUAC := "A"				
				Endif
				
				if JI6->JI6_SITUAC <> "1" .and. JI6->JI6_SITUAC <> "A"
					JI6->JI6_MEDFIM := (cAlias)->JC7_MEDFIM
				endif
				if JI6->JI6_SITUAC $ "28"
					JI6->JI6_ANOLET := Posicione("JBE",1,xFilial("JBE")+(cAlias)->(JC7_NUMRA+JC7_CODCUR+JAS_PERLET+JAS_HABILI+JC7_TURMA),"JBE_ANOLET")
					JI6->JI6_PERIOD := JBE->JBE_PERIOD
					JI6->JI6_CHREAL := JAS->JAS_CARGA
					JI6->JI6_CRREAL := JAS->JAS_CREDIT
				endif
				JI6->( Msunlock() )
				AcaLogTab( cArqLote, "JobMedia", "*** Fim Média Normal ***", JI6->JI6_NUMRA)
			endif
		else                                                               
			JAS->( dbSetOrder(7) ) //JAS_FILIAL+JAS_CODCUR+JAS_PERLET+JAS_COMP+JAS_CODDIS
			if JAS->( dbSeek( xFilial("JAS") + (cAlias)->(JC7_CODCUR + JAS_PERLET + JHZ_COMP) ) )
				JC7->( dbSetOrder(4) ) //JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_DISCIP
				if JC7->( dbSeek( xFilial("JC7")+ (cAlias)->(JC7_NUMRA)+JAS->JAS_CODCUR+JAS->JAS_CODDIS) )				
					RecLock("JI6",.F.)
					JI6->JI6_SITUAC := iif( (cAlias)->JC7_SITUAC == "5", "3", iif( (cAlias)->JC7_SITUAC == "6", "1", (cAlias)->JC7_SITUAC ) )
					JI6->( Msunlock() )

					AcaLogTab( cArqLote, "JobMedia", "* Inicio  ACMedPai *", JI6->JI6_NUMRA)
					ACMedPai( JI6->JI6_NUMRA, JI6->JI6_CODCUR, (cAlias)->JAS_PERLET, (cAlias)->JAS_HABILI )
					AcaLogTab( cArqLote, "JobMedia", "*** Fim ACMedPai ***", JI6->JI6_NUMRA)
					
				Else
					RecLock("JI6",.F.)
					JI6->JI6_SITUAC := "A"
					JI6->( Msunlock() )
				Endif                  
			Else
				AcaLogTab( cArqLote, "JobMedia", "Não encontrou JAS", JI6->JI6_NUMRA)
			Endif                      
			
		endif
	else
		AcaLogTab( cArqLote, "JobMedia", "Não encontrou JI6", (cAlias)->(JC7_NUMRA) )
	endif
	
	(cAlias)->( dbSkip() )
end

(cAlias)->( dbCloseArea() )

AcaLog( cArqLote, "Fim    - Lote " + StrZero(nRecI, 6), "Fim " + StrZero(nRecF, 6))

// Libera environment
RPCClearEnv()

Return .T.
