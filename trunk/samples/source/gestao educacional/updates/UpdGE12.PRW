
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGE12    ³Autor  ³ Viviane Miam         ³ Data ³ 08/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados                   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGE12()
Local cMsg := ""

cArqEmp := "sigamat.emp"
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Elimina do SX o que deve ser eliminado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Limpando Dicionários")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Limpando Dicionários")			
			cTexto += "Limpando Dicionários..."+CHR(13)+CHR(10)
			GELimpaSX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Limpando Dicionários")						
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Limpando Dicionários")						
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")			
			cTexto += "Analisando Dicionario de Arquivos..."+CHR(13)+CHR(10)
			GEAtuSX2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			cTexto += "Analisando arquivos de índices. "+CHR(13)+CHR(10)
			GEAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			

			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				Conout( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				cTexto += "Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]"+CHR(13)+CHR(10)
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				//ATUALIZA A BASE DE DADOS
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
			SIX->( Pack() )
			SX2->( Pack() )
			SX3->( Pack() )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")

			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")
			Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")

			dbSelectArea("JCG")
			dbSelectArea("JCH")			
			dbSelectArea("JCW")

			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			
			// Atualiza a base de dados da empresa para cada filial
			For nX := 1 To Len(aRecnoSM0[nI,3])

				RpcSetType(2)
				RpcSetEnv(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
				lMsFinalAuto := .F.

				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Atualizando Tabelas")
				Conout( dtoc( Date() )+" "+Time()+" "+"Inicio - Atualizando Tabelas")
		
				AtuBase()
			  
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Atualizando Tabelas")
				Conout( dtoc( Date() )+" "+Time()+" "+"Fim - Atualizando Tabelas")

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

aAdd(aSX2,{	"JCG",; 								//Chave
			cPath,;									//Path
			"JCG"+cNome,;							//Nome do Arquivo
			"Header Apontamento Faltas Alun",;		//Nome Port
			"Header Apontamento Faltas Alun",;		//Nome Port
			"Header Apontamento Faltas Alun",;		//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+JCG_DATA+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+JCG_MATPRF",;//Unico
			"S"})									//Pyme
			   
aAdd(aSX2,{	"JCH",; 								//Chave
			cPath,;									//Path
			"JCH"+cNome,;							//Nome do Arquivo
			"Itens Apontamento Faltas Aluno",;		//Nome Port
			"Itens Apontamento Faltas Aluno",;		//Nome Port
			"Itens Apontamento Faltas Aluno",;		//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DATA+JCH_ITEM+JCH_DISCIP+JCH_CODAVA+JCH_MATPRF",;//Unico
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
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Icaro Queiroz³25/08/06³------³Tratamento para verificar qual eh a ultima±±
±±³             ³        ³      ³ordem para incluir o registro na proxima ³±±
±±³             ³        ³      ³ordem, e nao permitir incluir novamente. ³±±
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
nPos := 0
SX3->( MsSeek( "JCG" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JCG" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
/*******************************************************************************************
Monta o array com os campos das tabelas/
*******************************************/
//Tabela JCG
	aAdd(aSX3,{	"JCG",;								//Arquivo
				cValToChar(nPos),;					//Ordem
				"JCG_MATPRF",;						//Campo
				"C",;								//Tipo
				6,;									//Tamanho
				0,;									//Decimal
				"Mat. Prof.",; 					    //Titulo
				"Mat. Prof.",;					   	//Titulo SPA
				"Mat. Prof.",;	  		  			//Titulo ENG
				"Matricula do Professor",;			//Descricao
				"Matricula do Professor",;			//Descricao SPA
				"Matricula do Professor",;			//Descricao ENG
				"",;								//Picture
				"ExistCpo('SRA') .and. AC180VlPr(M->JCH_MATPRF)",;	//VALID
				Posicione( "SX3", 2, "JCH_CODAVA", "X3_USADO" ),;	//USADO
				"",;								//RELACAO
				"J2B",;								//F3
				1,;									//NIVEL
				Posicione( "SX3", 2, "JCH_CODAVA", "X3_RESERV" ),;	//RESERV
				"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"R","S","",;						//CONTEXT, OBRIGAT, VLDUSER
				"","","",;							//CBOX, CBOX SPA, CBOX ENG
				"","","","","","S"})//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME										
nPos++
aAdd(aSX3,{	"JCG",;								//Arquivo
			cValToChar(nPos),;					//Ordem
			"JCG_ITEM",;						//Campo
			"C",;								//Tipo
			2 ,;								//Tamanho
			0,;									//Decimal
			"Aula",; 						    //Titulo
			"Aula",;						   	//Titulo SPA
			"Aula",;		  		  			//Titulo ENG
			"Aula",;			  				//Descricao
			"Aula",;		   					//Descricao SPA
			"Aula",;			 				//Descricao ENG
			"@!",;								//Picture
			"A590ValDat()",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","A","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","M->JCG_TIPO<>'3' .AND. M->JCG_TIPO<>'2' .AND. INCLUI","","","","S"})//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JCH" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JCH" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
/*******************************************************************************************
Monta o array com os campos das tabelas
*******************************************/
//Tabela JCH
	aAdd(aSX3,{	"JCH",;								//Arquivo
				cValToChar(nPos),;					//Ordem
				"JCH_MATPRF",;						//Campo
				"C",;								//Tipo
				6,;									//Tamanho
				0,;									//Decimal
				"Mat. Prof.",; 					    //Titulo
				"Mat. Prof.",;					   	//Titulo SPA
				"Mat. Prof.",;	  		  			//Titulo ENG
				"Matricula do Professor",;			//Descricao
				"Matricula do Professor",;			//Descricao SPA
				"Matricula do Professor",;			//Descricao ENG
				"",;								//Picture
				"ExistCpo('SRA') .and. AC180VlPr(M->JCH_MATPRF)",;	//VALID
				Posicione( "SX3", 2, "JCH_CODAVA", "X3_USADO" ),;	//USADO
				"",;								//RELACAO
				"J2B",;								//F3
				1,;									//NIVEL
				Posicione( "SX3", 2, "JCH_CODAVA", "X3_RESERV" ),;	//RESERV
				"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"R","S","",;						//CONTEXT, OBRIGAT, VLDUSER
				"","","",;							//CBOX, CBOX SPA, CBOX ENG
				"","","","","","S"})//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME										

nPos++
	aAdd(aSX3,{	"JCH",;								//Arquivo
			cValToChar(nPos),;					//Ordem
			"JCH_ITEM",;						//Campo
			"C",;								//Tipo
			2 ,;								//Tamanho
			0,;									//Decimal
			"Aula",; 						    //Titulo
			"Aula",;						   	//Titulo SPA
			"Aula",;		  		  			//Titulo ENG
			"Aula",;			  				//Descricao
			"Aula",;		   					//Descricao SPA
			"Aula",;			 				//Descricao ENG
			"@!",;								//Picture
			"",;									//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","V","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","S","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","M->JCG_TIPO=='1'","","","","S"})//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
									
// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JCW" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JCW" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************/
//Tabela JCW

	aAdd(aSX3,{	"JCW",;								//Arquivo
				cValToChar(nPos),;					//Ordem
				"JCW_MATPRF",;						//Campo
				"C",;								//Tipo
				6,;									//Tamanho
				0,;									//Decimal
				"Mat. Prof.",; 					    //Titulo
				"Mat. Prof.",;					   	//Titulo SPA
				"Mat. Prof.",;	  		  			//Titulo ENG
				"Matricula do Professor",;			//Descricao
				"Matricula do Professor",;			//Descricao SPA
				"Matricula do Professor",;			//Descricao ENG
				"",;								//Picture
				"",;								//VALID
				cUsadoOpc,;							//USADO
				"",;								//RELACAO
				"",;								//F3
				1,;									//NIVEL
				cReservOpc,;						//RESERV
				"","","V","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"R","S","",;						//CONTEXT, OBRIGAT, VLDUSER
				"","","",;							//CBOX, CBOX SPA, CBOX ENG
				"","",;								//PICTVAR, WHEN
				"","","","S"})						//INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JCW",;								//Arquivo
			cValToChar(nPos),;					//Ordem
			"JCW_ITEM",;						//Campo
			"C",;								//Tipo
			2 ,;								//Tamanho
			0,;									//Decimal
			"Aula",; 						    //Titulo
			"Aula",;						   	//Titulo SPA
			"Aula",;		  		  			//Titulo ENG
			"Aula",;			  				//Descricao
			"Aula",;		   					//Descricao SPA
			"Aula",;			 				//Descricao ENG
			"@!",;								//Picture
			"",;									//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","V","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","S","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","",;								//PICTVAR, WHEN
			"","","","S"})						//INIBRW, SXG, FOLDER, PYME
	
/******************************************************************************************
Grava informacoes do array no banco de dados
******************************************************************************************/
if SX3->( dbSeek( "JCG_DATA" ) )
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= "Ac590Aula() .AND. A590ValDat()"
	SX3->(MsUnlock())
endif	

if SX3->( dbSeek( "JCG_DISCIP" ) )
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= "ExistCpo('JAE') .And. Aca590Alu(.T.) .And. A590Exibe(M->JCG_TIPO)"
	SX3->(MsUnlock())
endif	

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

Return 
          
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

aAdd(aSIX,{"JCW",;   										//Indice
		"1",;                 								//Ordem
		"JCW_FILIAL+JCW_LOTE+JCW_NUMRA+DTOS(JCW_DATA)+JCW_ITEM",;//Chave
		"Num. do Lote + RA + Data + Aula",;					//Descicao Port.
		"Num. do Lote + RA + Data + Aula",;					//Descicao Port.
		"Num. do Lote + RA + Data + Aula",;					//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  
		
aAdd(aSIX,{"JBL",;   										//Indice
		"1",;                 								//Ordem
		"JBL_FILIAL+JBL_CODDIS+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_DIASEM+JBL_ITEM+JBL_MATPRF",;//Chave
		"Cod. Discip + Cod.Curso + Per. Letivo + Habilitacao + Turma + Dia Semana + Aula + Cod. Professor",; //Descicao Port.
		"Cod. Discip + Cod.Curso + Per. Letivo + Habilitacao + Turma + Dia Semana + Aula + Cod. Professor",;	//Descicao Port.
		"Cod. Discip + Cod.Curso + Per. Letivo + Habilitacao + Turma + Dia Semana + Aula + Cod. Professor",;	//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  

SX3->( dbSetOrder(2) )
if SX3->( dbSeek("JCG_SUBTUR") )
	aAdd(aSIX,{"JCG",;   										//Indice
			"1",;                 								//Ordem
			"JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+JCG_SUBTUR+JCG_MATPRF",;//Chave
			"Curso Vigent + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip + Cod. Avaliacao + Cod. Subturma + Cod. Professor",;//Descicao Port.
			"Curso Vigent + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip + Cod. Avaliacao + Cod. Subturma + Cod. Professor",;//Descicao Port.
			"Curso Vigent + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip + Cod. Avaliacao + Cod. Subturma + Cod. Professor",;//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq     
else
	aAdd(aSIX,{"JCG",;   										//Indice
			"1",;                 								//Ordem
			"JCG_FILIAL+JCG_CODCUR+JCG_PERLET+JCG_HABILI+JCG_TURMA+DTOS(JCG_DATA)+JCG_ITEM+JCG_DISCIP+JCG_CODAVA+JCG_MATPRF",;//Chave
			"Curso Vigent + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip + Cod. Avaliacao + Cod. Professor",;//Descicao Port.
			"Curso Vigent + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip + Cod. Avaliacao + Cod. Professor",;//Descicao Port.
			"Curso Vigent + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip + Cod. Avaliacao + Cod. Professor",;//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq     
endif
		
aAdd(aSIX,{"JCH",;   										//Indice
		"1",;                 								//Ordem
		"JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+DTOS(JCH_DATA)+JCH_ITEM+JCH_DISCIP+JCH_CODAVA+JCH_HORA1",;//Chave
		"RA + Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip. + Cod. Avaliacao + Hora 1",;//Descicao Port.
		"RA + Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip. + Cod. Avaliacao + Hora 1",;//Descicao Port.
		"RA + Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Aula + Cod. Discip. + Cod. Avaliacao + Hora 1",;//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  
		
aAdd(aSIX,{"JCH",;   										//Indice
		"4",;                 								//Ordem
		"JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+DTOS(JCH_DATA)+JCH_DISCIP+JCH_MATPRF+JCH_HORA1",;//Chave
		"RA+Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Cod. Discip. + Cod. Professor + Hora 1",;//Descicao Port.
		"RA+Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Cod. Discip. + Cod. Professor + Hora 1",;//Descicao Port.
		"RA+Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Cod. Discip. + Cod. Professor + Hora 1",;//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  

aAdd(aSIX,{"JCH",;   										//Indice
		"5",;                 								//Ordem
		"JCH_FILIAL+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+DTOS(JCH_DATA)+JCH_DISCIP+JCH_CODAVA+JCH_HORA1",;//Chave
		"RA + Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Cod. Discip. + Cod. Avaliacao + Hora 1",;//Descicao Port.
		"RA + Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Cod. Discip. + Cod. Avaliacao + Hora 1",;//Descicao Port.
		"RA + Cod.Curso + Per. Letivo + Habilitacao + Turma + Data + Cod. Discip. + Cod. Avaliacao + Hora 1",;//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  		

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
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .T. ) 	
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
Local aDelSX2	:= {"JCG","JCH"}
Local aDelSIX	:= {"JCG1","JCH1","JCH5","JCW1","JBL1"}
Local aDelSXB	:= {}
Local aDelSX3	:= {}

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
		TCSQLExec("DROP INDEX "+RetSQLName(SIX->INDICE)+"."+RetSQLName(SIX->INDICE)+SIX->ORDEM )
		RecLock( "SIX", .F. )
		SIX->( dbDelete() )
		SIX->( msUnlock() )
	endif
next i

Return
