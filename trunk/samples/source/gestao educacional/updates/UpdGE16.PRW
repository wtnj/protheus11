#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGE16    ³Autor  ³ Cristina Souza       ³ Data ³ 26/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de melhorias na digitacao de historico dos alunos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGE16()
Local cMsg := ""

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados para "
cMsg += "implementar a melhoria de disciplinas externas na rotina de digitação de histórico"+Chr(13)+Chr(10)+Chr(13)+Chr(10)
cMsg += "Esta rotina deve ser processada em modo exclusivo! "+Chr(13)+Chr(10)+Chr(13)+Chr(10)
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
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 3 ) == 2 , ( Processa({|lEnd| GEProc(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Operaçao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³Cristina Souza        ³ Data ³ 20/Dez/05 ³±±
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
			cTexto += "Limpando Dicionários..."+CHR(13)+CHR(10)
			GELimpaSX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Limpando Dicionários")						
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Arquivos")			
			cTexto += "Analisando Dicionario de Arquivos..."+CHR(13)+CHR(10)
			GEAtuSX2()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Arquivos")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os parametros.        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Parametros")			
			cTexto += "Analisando Parametros..."+CHR(13)+CHR(10)
			GEAtuSX6()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Parametros")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Gatilhos")			
			cTexto += "Analisando Gatilhos..."+CHR(13)+CHR(10)
			GEAtuSX7()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Gatilhos")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Indices")
			cTexto += "Analisando arquivos de índices. "+CHR(13)+CHR(10)
			GEAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Indices")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Consultas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Consultas Padroes")
			cTexto += "Analisando consultas padroes..."+CHR(13)+CHR(10) 
			GEAtuSxB( SM0->M0_CODIGO )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Consultas Padroes")

			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
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
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Retirando registros deletados dos dicionarios...")
			SIX->( Pack() )
			SX2->( Pack() )
			SX3->( Pack() )
			SX6->( Pack() )
			SX7->( Pack() )
			SXB->( Pack() )
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Retirando registros deletados dos dicionarios...")

			//Utiliza o Select Area para forcar a criacao das tabelas
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Abrindo Tabelas")

			dbSelectArea("JD1")

			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			
		Next nI 
		   
		If lOpen

			IncProc( dtoc( Date() )+" "+Time()+" "+"Atualização Concluída." )
			
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
±±³Fun‡…o    ³GEAtuSX2  ³ Autor ³Cristina Souza        ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2 - Arquivos      ³±± 
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

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO","X2_PYME"}

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
/*
aAdd(aSX2,{	"JC7",; 								//Chave
			cPath,;									//Path
			"JC7"+cNome,;							//Nome do Arquivo
			"Itens Alocacao do Aluno",;				//Nome Port
			"Itens Alocacao do Aluno",;				//Nome Port
			"Itens Alocacao do Aluno",;				//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1+JC7_SEQ",;				//Unico
			"S"})									//Pyme
*/			
aAdd(aSX2,{	"JGN",; 								//Chave
			cPath,;									//Path
			"JGN"+cNome,;							//Nome do Arquivo
			"Avaliação Historico Digitavel",;		//Nome Port
			"Avaliação Historico Digitavel",;		//Nome Port
			"Avaliação Historico Digitavel",;		//Nome Port
			0,;										//Delete
			cModo,;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JGN_FILIAL+JGN_NUM+JGN_CODCUR+JGN_PERLET+JGN_HABILI+JGN_CODDIS+JGN_CODAVA",;				//Unico
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
	EndIf
Next i

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³Cristina Souza        ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3 - Campos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX3()
Local aSX3			:= {}				//Array com os campos das tabelas
Local aEstrut		:= {}              //Array com a estrutura da tabela SX3
Local i				:= 0				//Laco para contador
Local j				:= 0				//Laco para contador
Local lSX3			:= .F.             //Indica se houve atualizacao
Local cAlias		:= ''				//String para utilizacao do noem da tabela
Local cUsadoKey		:= ''				//String que servira para cadastrar um campo como "USADO" em campos chave
Local cReservKey	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos chave
Local cUsadoObr		:= ''				//String que servira para cadastrar um campo como "USADO" em campos obrigatorios
Local cReservObr	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos obrigatorios
Local cUsadoOpc		:= ''				//String que servira para cadastrar um campo como "USADO" em campos opcionais
Local cReservOpc	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos opcionais
Local cUsadoNao		:= ''				//String que servira para cadastrar um campo como "USADO" em campos fora de uso
Local cReservNao	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos fora de uso
Local cCBoxSit		:= ''

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
If SX3->( dbSeek("JC7_SITUAC") ) //Este campo eh chave
	cCBoxSit	:= SX3->X3_CBOX
EndIf

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

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_NUMRA" ),;	//Ordem
			"JD1_NUMRA",;						//Campo
			"C",;								//Tipo
			15,;									//Tamanho
			0,;									//Decimal
			"RA do aluno",;			    		//Titulo
			"RA do aluno",;			    		//Titulo
			"RA do aluno",;			    		//Titulo
			"RA do aluno",;			    		//Titulo
			"RA do aluno",;			    		//Titulo
			"RA do aluno",;			    		//Titulo
			"",;								//Picture
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

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_TOTFAL" ),;	//Ordem
			"JD1_TOTFAL",;						//Campo
			"N",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Tot.Faltas",;			    		//Titulo
			"Tot.Faltas",;			    		//Titulo
			"Tot.Faltas",;			    		//Titulo
			"Tot.Faltas",;			    		//Titulo
			"Tot.Faltas",;			    		//Titulo
			"Tot.Faltas",;			    		//Titulo
			"",;								//Picture
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

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_SITUAC" ),;	//Ordem
			"JD1_SITUAC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Situacao",;			    		//Titulo
			"Situacao",;			    		//Titulo
			"Situacao",;			    		//Titulo
			"Situacao",;			    		//Titulo
			"Situacao",;			    		//Titulo
			"Situacao",;			    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			cCBoxSit,cCBoxSit,cCBoxSit,;		//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_ITEM" ),;		//Ordem
			"JD1_ITEM",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"",;								//Picture
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

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_ANOMED" ),;	//Ordem
			"JD1_ANOMED",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Ano Média",;				   		//Titulo
			"Ano Média",;				   		//Titulo
			"Ano Média",;				   		//Titulo
			"Ano da Média adquirida",;	   		//Titulo
			"Ano da Média adquirida",;	   		//Titulo
			"Ano da Média adquirida",;	   		//Titulo
			"",;								//Picture
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

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_CODINS" ),;	//Ordem
			"JD1_CODINS",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Instit",;				   		//Titulo
			"Cod. Instit",;				   		//Titulo
			"Cod. Instit",;				   		//Titulo
			"Codigo da Ies Anterior",;	   		//Titulo
			"Codigo da Ies Anterior",;	   		//Titulo
			"Codigo da Ies Anterior",;	   		//Titulo
			"",;								//Picture
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

aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_ANOINS" ),;	//Ordem
			"JD1_ANOINS",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Per.Conclus.",;			   		//Titulo
			"Per.Conclus.",;			   		//Titulo
			"Per.Conclus.",;			   		//Titulo
			"Periodo de Conclusào",;	   		//Titulo
			"Periodo de Conclusào",;	   		//Titulo
			"Periodo de Conclusào",;	   		//Titulo
			"",;								//Picture
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
			
aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_TIPCUR" ),;	//Ordem
			"JD1_TIPCUR",;						//Campo
			"C",;								//Tipo
			3,;	    							//Tamanho
			0,;									//Decimal
			"Tipo Curso",;				   		//Titulo
			"Tipo Curso",;				   		//Titulo
			"Tipo Curso",;				   		//Titulo
			"Tipo Curso",;				   		//Titulo
			"Tipo Curso",;				   		//Titulo
			"Tipo Curso",;				   		//Titulo
			"",;								//Picture
			"ExistCpo('SX5','FC'+JD1->JD1_TIPCUR)",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JGN",;								//Arquivo
			"01",;	//Ordem
			"JGN_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;				    		//Titulo
			"Filial",;				    		//Titulo
			"Filial",;				    		//Titulo
			"Filial",;				    		//Titulo
			"Filial",;				    		//Titulo
			"Filial",;				    		//Titulo
			"",;								//Picture
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

aAdd(aSX3,{	"JGN",;								//Arquivo
			"02",;		//Ordem
			"JGN_NUM",;							//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Num Historic",;		    		//Titulo
			"Num Historic",;		    		//Titulo
			"Num Historic",;		    		//Titulo
			"Num Historic",;		    		//Titulo
			"Num Historic",;		    		//Titulo
			"Num Historic",;		    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"IIF(INCLUI,M->JGL_NUM,JGL->JGL_NUM)",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"03",;		//Ordem
			"JGN_ITEM",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"Item",;				    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"STRZERO(LEN(ACOLS),2)",;					//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"04",;	//Ordem
			"JGN_CODAVA",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Avaliacao",;			    		//Titulo
			"Avaliacao",;			    		//Titulo
			"Avaliacao",;			    		//Titulo
			"Codigo da Avaliacao",;	    		//Titulo
			"Codigo da Avaliacao",;	    		//Titulo
			"Codigo da Avaliacao",;	    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"GetSx8Num('JBQ','JBQ_CODAVA')",;	//RELACAO
			"JBQ",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"05",;	//Ordem
			"JGN_DESCAV",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc Avalia",;			    		//Titulo
			"Desc Avalia",;			    		//Titulo
			"Desc Avalia",;			    		//Titulo
			"Descricao da Avaliacao",;    		//Titulo
			"Descricao da Avaliacao",;    		//Titulo
			"Descricao da Avaliacao",;    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"06",;	//Ordem
			"JGN_COMPAR",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Campareceu",;			    		//Titulo
			"Campareceu",;			    		//Titulo
			"Campareceu",;			    		//Titulo
			"Campareceu",;			    		//Titulo
			"Campareceu",;			    		//Titulo
			"Campareceu",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;			//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JGN",;								//Arquivo
			"07",;		//Ordem
			"JGN_NOTA",;						//Campo
			"N",;								//Tipo
			5,;									//Tamanho
			2,;									//Decimal
			"Nota da Aval",;		    		//Titulo
			"Nota da Aval",;		    		//Titulo
			"Nota da Aval",;		    		//Titulo
			"Nota da Avaliacao",;	    		//Titulo
			"Nota da Avaliacao",;	    		//Titulo
			"Nota da Avaliacao",;	    		//Titulo
			"@E 99.99",;						//Picture
			"M->JGN_NOTA <= 10 .And. Positivo()",;	//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","ACA500Nt()","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"08",;	//Ordem
			"JGN_CONCEI",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Conceito Not",;		    		//Titulo
			"Conceito Not",;		    		//Titulo
			"Conceito Not",;		    		//Titulo
			"Conceito de Nota",;	    		//Titulo
			"Conceito de Nota",;	    		//Titulo
			"Conceito de Nota",;	    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","ACA500Ct()","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"09",;		//Ordem
			"JGN_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Codigo Curso",;		    		//Titulo
			"Codigo Curso",;		    		//Titulo
			"Codigo Curso",;		    		//Titulo
			"Codigo Curso",;		    		//Titulo
			"Codigo Curso",;		    		//Titulo
			"Codigo Curso",;		    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"10",;		//Ordem
			"JGN_PERLET",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Periodo Let ",;		    		//Titulo
			"Periodo Let ",;		    		//Titulo
			"Periodo Let ",;		    		//Titulo
			"Periodo Letivo",;		    		//Titulo
			"Periodo Letivo",;		    		//Titulo
			"Periodo Letivo",;		    		//Titulo
			"99",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"11",;		//Ordem
			"JGN_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao ",;		    		//Titulo
			"Habilitacao ",;		    		//Titulo
			"Habilitacao ",;		    		//Titulo
			"Habilitacao ",;		    		//Titulo
			"Habilitacao ",;		    		//Titulo
			"Habilitacao ",;		    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"12",;	//Ordem
			"JGN_CODDIS",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Disciplina",;			    		//Titulo
			"Disciplina",;			    		//Titulo
			"Disciplina",;			    		//Titulo
			"Disciplina",;			    		//Titulo
			"Disciplina",;			    		//Titulo
			"Disciplina",;			    		//Titulo
			"@!",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"13",;		//Ordem
			"JGN_DATA1 ",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Dt de Inicio",;		    		//Titulo
			"Dt de Inicio",;		    		//Titulo
			"Dt de Inicio",;		    		//Titulo
			"Data de inicio",;		    		//Titulo
			"Data de inicio",;		    		//Titulo
			"Data de inicio",;		    		//Titulo
			"",;								//Picture
			"AC500DT1()",;						//VALID
			cUsadoKey,;							//USADO
			"STOD(' ')",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"14",;		//Ordem
			"JGN_DATA2",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Dt Final",;			    		//Titulo
			"Dt Final",;			    		//Titulo
			"Dt Final",;			    		//Titulo
			"Dt Final",;			    		//Titulo
			"Dt Final",;			    		//Titulo
			"Dt Final",;			    		//Titulo
			"",;								//Picture
			"AC500DT2()",;						//VALID
			cUsadoKey,;							//USADO
			"STOD(' ')",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"15",;		//Ordem
			"JGN_PESO",;						//Campo
			"N",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Peso",;				    		//Titulo
			"Peso",;				    		//Titulo
			"Peso",;				    		//Titulo
			"Peso da avaliacao",;	    		//Titulo
			"Peso da avaliacao",;	    		//Titulo
			"Peso da avaliacao",;	    		//Titulo
			"99",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"VAL('1')",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"16",;		//Ordem
			"JGN_TIPO",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo",;				    		//Titulo
			"Tipo",;				    		//Titulo
			"Tipo",;				    		//Titulo
			"Tipo",;				    		//Titulo
			"Tipo",;				    		//Titulo
			"Tipo",;				    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Regular;2=Exame;3=Integrada;4=Nota unica","1=Regular;2=Exame;3=Integrada;4=Nota unica","1=Regular;2=Exame;3=Integrada;4=Nota unica",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"17",;		//Ordem
			"JGN_CHAMAD",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"2a Chamada",;			    		//Titulo
			"2a Chamada",;			    		//Titulo
			"2a Chamada",;			    		//Titulo
			"2a Chamada",;			    		//Titulo
			"2a Chamada",;			    		//Titulo
			"2a Chamada",;			    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"18",;	//Ordem
			"JGN_DTAPON",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Limite Apont",;		    		//Titulo
			"Limite Apont",;		    		//Titulo
			"Limite Apont",;		    		//Titulo
			"Limite Apont",;		    		//Titulo
			"Limite Apont",;		    		//Titulo
			"Limite Apont",;		    		//Titulo
			"",;								//Picture
			"AC500DT3()",;						//VALID
			cUsadoKey,;							//USADO
			"STOD(' ')",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"19",;		//Ordem
			"JGN_EXASUB",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Exame Subst.",;		    		//Titulo
			"Exame Subst.",;		    		//Titulo
			"Exame Subst.",;		    		//Titulo
			"Exame Subst.",;		    		//Titulo
			"Exame Subst.",;		    		//Titulo
			"Exame Subst.",;		    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","pertence('12')",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"20",;	//Ordem
			"JGN_ATIVID",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Atividades",;			    		//Titulo
			"Atividades",;			    		//Titulo
			"Atividades",;			    		//Titulo
			"Atividades",;			    		//Titulo
			"Atividades",;			    		//Titulo
			"Atividades",;			    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","pertence('12')",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGN",;								//Arquivo
			"21",;	//Ordem
			"JGN_CONSNC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Considera NC",;		    		//Titulo
			"Considera NC",;		    		//Titulo
			"Considera NC",;		    		//Titulo
			"Considera NC",;		    		//Titulo
			"Considera NC",;		    		//Titulo
			"Considera NC",;		    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","pertence('12')",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGM",;								//Arquivo
			GetOrdem( "JGM", "JGM_MEDFIM" ),;	//Ordem
			"JGM_MEDFIM",;						//Campo
			"N",;								//Tipo
			5,;									//Tamanho
			2,;									//Decimal
			"Media Final",;		    		//Titulo
			"Media Final",;		    		//Titulo
			"Media Final",;		    		//Titulo
			"Media Final",;		    		//Titulo
			"Media Final",;		    		//Titulo
			"Media Final",;		    		//Titulo
			"@E 99.99",;								//Picture
			"AvaTela()",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","M->JGL_CRIAVA == '1'","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGM",;								//Arquivo
			GetOrdem( "JGM", "JGM_MEDCON" ),;	//Ordem
			"JGM_MEDCON",;						//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"M.Final Conc",;		    		//Titulo
			"M.Final Conc",;		    		//Titulo
			"M.Final Conc",;		    		//Titulo
			"M.Final Conc",;		    		//Titulo
			"M.Final Conc",;		    		//Titulo
			"M.Final Conc",;		    		//Titulo
			"",;								//Picture
			"AvaTela()",;								//VALID
			cUsadoKey,;							//USADO
			"",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","M->JGL_CRIAVA == '2'","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGM",;								//Arquivo
			GetOrdem( "JGM", "JGM_SITUAC" ),;	//Ordem
			"JGM_SITUAC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Sit.Final",;			    		//Titulo
			"Sit.Final",;			    		//Titulo
			"Sit.Final",;			    		//Titulo
			"Situação Final",;			    		//Titulo
			"Situação Final",;			    		//Titulo
			"Situação Final",;			    		//Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"'8'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","Pertence('123456789A')",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Aprovado;2=Reprov.Nota;3=Reprov.Falta;4=Reprov.Exame;5=Trancado;6=Dispensado;7=Cancelado;8=Cursando;9=Exame;A=A Cursar","1=Aprovado;2=Reprov.Nota;3=Reprov.Falta;4=Reprov.Exame;5=Trancado;6=Dispensado;7=Cancelado;8=Cursando;9=Exame;A=A Cursar","1=Aprovado;2=Reprov.Nota;3=Reprov.Falta;4=Reprov.Exame;5=Trancado;6=Dispensado;7=Cancelado;8=Cursando;9=Exame;A=A Cursar",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


SX3->( dbSetOrder(2) )
if SX3->( !dbSeek("JGL_CODCUR") )
	SX3->( dbSetOrder(1) )
	SX3->( dbSeek("JGM") )
	SX3->( dbSkip(-1) )
	
	while SX3->( !bof() .and. X3_ARQUIVO == "JGL" .and. X3_ORDEM >= "06" )
		RecLock("SX3",.F.)
		SX3->X3_ORDEM := Soma1(Soma1(SX3->X3_ORDEM))
		SX3->( msUnlock() )
		SX3->( dbSkip(-1) )
	end
endif

aAdd(aSX3,{	"JGL",;								//Arquivo
			"06",;								//Ordem
			"JGL_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Curso Vigent",;				    //Titulo
			"Curso Vigent",;				    //Titulo
			"Curso Vigent",;				    //Titulo
			"Curso Vigente",;				    //Titulo
			"Curso Vigente",;				    //Titulo
			"Curso Vigente",;				    //Titulo
			"@!",;								//Picture
			'AC500READ()',;				     	//VALID
			cUsadoObr,;							//USADO
			'',;                            	//RELACAO
			"JAH",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGL",;								//Arquivo
			"07",;								//Ordem
			"JGL_DESCUR",;						//Campo
			"C",;								//Tipo
			60,;								//Tamanho
			0,;									//Decimal
			"Descrição",;					    //TITULO
			"Descrição",;					    //TITULO
			"Descrição",;					    //TITULO
			"Descrição",;					    //TITULO
			"Descrição",;					    //TITULO
			"Descrição",;					    //TITULO
			"@S30",;							//Picture
			"",;				            	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGL",;							  												//Arquivo
			"20",;						  													//Ordem
			"JGL_SITFIM",;					   												//Campo
			"C",;						  													//Tipo
			1,;																				//Tamanho
			0,;								  												//Decimal
			"Sit. Final",;					  												//TITULO
			"Sit. Final",;					   												//TITULO SPA
			"Final status",;																//TITULO ENG
			"Situacao final no curso",;		  										        //Descricao 
			"Situacion final en curso",;	   										  	    //Descricao SPA
			"Course final status",;														    //Descricao ENG
			"9",;																			//Picture
			"Pertence('123456789')",; 											           	//VALID
			cUsadoObr,;																		//USADO
			"",;																			//RELACAO
			"",;																			//F3
			1,;																				//NIVEL
			cReservObr,;																	//RESERV
			"","","","","",;																//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;																     	//CONTEXT, OBRIGAT, VLDUSER
		   	"1=Trancado;2=Formado;3=Cancelado;4=Desistencia;5=Obito;6=Debitos Financeiro;7=Integralizado;8=Cursando;9=Ativo Não",; //CBOX,
		 	"1=Interrumpido;2=Graduado;3=Anulado;4=Desistencia;5=Fallecimiento;6=Deudas;7=Integralizado;8=Cursando;9=Ativo Não",;  //CBOX SPA,
		 	"1=Failed;2=Graduated;3=Cancelled;4=Quit;5=Death;6=Financial Debit;7=Paid in;8=Attending;9=Ativo Não",; //CBOX ENG							  
            "","","","","","S"})			  												//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JGL",;								//Arquivo
			"10",;								//Ordem
			"JGL_TURNO",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Turno",;						    //Titulo
			"Turno",;						    //Titulo
			"Turno",;						    //Titulo
			"Turno",;						    //Titulo
			"Turno",;						    //Titulo
			"Turno",;						    //Titulo
			"@!",;								//Picture
			'ExistCpo("SX5","F5"+M->JGL_TURNO) .And. AC500VlTur()',;				     	//VALID
			cUsadoObr,;							//USADO
			'',;                            	//RELACAO
			"F5",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
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

	EndIf
Next i

Return 
            

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX6  ³ Autor ³Bruno Paulinelli      ³ Data ³ 07/Jul/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6 - Parametros    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX6()

Local aSX6   := {}					//Array que contera os dados dos gatilhos
Local aEstrut:= {}					//Array que contem a estrutura da tabela SX6
Local i      := 0					//Contador para laco
Local j      := 0					//Contador para laco
/*********************************************************************************************
Define a estrutura da tabela SX6
*********************************************************************************************/
aEstrut:= { "X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
			"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA",;
			"X6_CONTENG","X6_PROPRI","X6_PYME"}

aAdd(aSX6,{	"MV_ACDGHIS",;																//Parametro			 		
			"L",;																		//Tipo
			"Indica se a inclusao de disciplinas na digitacao do historico",;			//Descricao
			"",;																		//Descricao
			"",;																		//Descricao
			" do aluno deve alterar o curriculo (.T.) ou gerar disciplinas","","",;		//Descricao1,Descricao SPA1, Descricao ENG1
			" externas para o aluno (.F.)","","",;										//Descricao2,Descricao SPA2, Descricao ENG2
			"F","F","F",;						  										//Conteudo, Conteudo SPA, Conteudo ENG
			"S","S"})																	//Propri, PYME

aAdd(aSX6,{	"MV_HISAVA",;																//Parametro			 		
			"L",;																		//Tipo
			"Indica se a inclusao de nota no historico digitavel será por ",;			//Descricao
			"",;																		//Descricao
			"",;																		//Descricao
			" Avaliação, cadastrando todas as avalia'~oes ou será por nota","","",;		//Descricao1,Descricao SPA1, Descricao ENG1
			" unica (Padrão) (.T.) para Avaliação, (.F.) Nota unica","","",;			//Descricao2,Descricao SPA2, Descricao ENG2
			"T","T","T",;						  										//Conteudo, Conteudo SPA, Conteudo ENG
			"S","S"})																	//Propri, PYME

/*********************************************************************************************
Realiza a gravacao das informacoes do array na tabela SX6
*********************************************************************************************/
ProcRegua(Len(aSX6))

dbSelectArea("SX6")
SX6->(DbSetOrder(1))	
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][1])
		If !DbSeek('  '+aSX6[i,1])
			RecLock("SX6",.T.)
		Else	
			RecLock("SX6",.F.)
		Endif	
		For j:=1 To Len(aSX6[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
			EndIf
		Next j
		MsUnLock()
		IncProc("Atualizando Parametros...")
	EndIf
Next i

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX7  ³ Autor ³Cristina Souza        ³ Data ³ 20/Dez/05 ³±±
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
			"X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}

aAdd(aSX7,{	"JGL_CODCUR",;			 												  //Campo
			"001",;																	  //Sequencia
			"JAH->JAH_DESC",;														  //Regra
			"JGL_DESCUR",;      													  //Campo Dominio
			"P",;              														  //Tipo
			"S",;  																	  //Posiciona?
			"JAH",;																	  //Alias
			1,;																		  //Ordem do Indice
			"xFilial('JAH')+M->JGL_CODCUR",;										  //Chave
			"",;																	  //Condi
			"S"})																	  //Proprietario

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
	EndIf
Next i

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSIX  ³ Autor ³Cristina Souza        ³ Data ³ 20/Dez/05 ³±±
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

aAdd(aSIX,{	"JD1",;   										//Indice
			"2",;                 								//Ordem
			"JD1_FILIAL+JD1_NUMRA+JD1_CODCUR+JD1_PERLET+JD1_HABILI+JD1_DISCIP",;		//Chave
			"Numero RA + Cod.Curso + Per. Letivo + Habilitacao + Disciplina",;			//Descicao Port.
			"Numero RA + Cod.Curso + Per. Letivo + Habilitacao + Disciplina",;			//Descicao Port.
			"Numero RA + Cod.Curso + Per. Letivo + Habilitacao + Disciplina",;			//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq  

aAdd(aSIX,{	"JGN",;   										//Indice
			"1",;                 								//Ordem
			"JGN_FILIAL+JGN_NUM+JGN_ITEM+JGN_CODCUR+JGN_PERLET+JGN_HABILI+JGN_CODDIS+JGN_CODAVA",;		//Chave
			"Num Historic+Item+Codigo Curso+Periodo Let+Habilitacao+Disciplina+Aval",;					//Descicao Port.
			"Num Historic+Item+Codigo Curso+Periodo Let+Habilitacao+Disciplina+Aval",;					//Descicao Port.
			"Num Historic+Item+Codigo Curso+Periodo Let+Habilitacao+Disciplina+Aval",;					//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq  

aAdd(aSIX,{	"JGN",;   										//Indice
			"2",;                 								//Ordem
			"JGN_FILIAL+JGN_CODCUR+JGN_PERLET+JGN_HABILI+JGN_CODDIS+JGN_CODAVA+JGN_NUM",;		//Chave
			"Codigo Curso+Periodo Let+Habilitacao+Disciplina+Avaliacao+Num Historic",;			//Descicao Port.
			"Codigo Curso+Periodo Let+Habilitacao+Disciplina+Avaliacao+Num Historic",;			//Descicao Port.
			"Codigo Curso+Periodo Let+Habilitacao+Disciplina+Avaliacao+Num Historic",;			//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq  
aAdd(aSIX,{	"JGN",;   										//Indice
			"3",;                 								//Ordem
			"JGN_FILIAL+JGN_NUM+JGN_CODCUR+JGN_PERLET+JGN_HABILI+JGN_CODDIS+JGN_CODAVA",;		//Chave
			"Num Historic+Codigo Curso+Periodo Let+Habilitacao+Disciplina+Avaliacao",;			//Descicao Port.
			"Num Historic+Codigo Curso+Periodo Let+Habilitacao+Disciplina+Avaliacao",;			//Descicao Port.
			"Num Historic+Codigo Curso+Periodo Let+Habilitacao+Disciplina+Avaliacao",;			//Descicao Port.
			"S",; 												//Proprietario
			"",;  												//F3
			"",;  												//NickName
			"S"}) 												//ShowPesq  
aAdd(aSIX,{	"JGN",;   										//Indice
			"4",;                 								//Ordem
			"JGN_FILIAL+JGN_ITEM+JGN_CODCUR+JGN_PERLET+JGN_HABILI+JGN_CODDIS",;		//Chave
			"Item+Codigo Curso+Periodo Let+Habilitacao+Disciplina",;			//Descicao Port.
			"Item+Codigo Curso+Periodo Let+Habilitacao+Disciplina",;			//Descicao Port.
			"Item+Codigo Curso+Periodo Let+Habilitacao+Disciplina",;			//Descicao Port.
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
	EndIf	
Next i
IF Len(aSIX) > 0
	CHKFILE("JGN")
ENDIF
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
/*
aAdd(aSXB,{	"JBL001","1","01","RE",;		// ALIAS, TIPO, SEQ, COLUNA
			"Selecione a sub-turma",;		// DESCRI
			"Selecione a sub-turma",;		// DESCRI
			"Selecione a sub-turma",;		// DESCRI
			"JBL", "" })				// CONTEM, WCONTEM  

aAdd(aSXB,{	"JBL001","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"AC670SelSub()", "" })		// CONTEM, WCONTEM

aAdd(aSXB,{	"JBL001","5","01","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"M->JCS_SUBTUR", "" })			// CONTEM, WCONTEM	   
*/
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GELimpaSX ³ Autor ³Cristina Souza      ³ Data ³ 01/Fev/2006 ³±±
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
Local aDelSX2	:= {}
Local aDelSIX	:= {"JD12"}
Local aDelSXB	:= {}
Local aDelSX3	:= {}
Local aDelSX6	:= {}

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

SX6->( dbSetOrder(1) )
for i := 1 to len( aDelSX6 )
	if SX6->(dbSeek( aDelSX6[i] ) )
		RecLock( "SX6", .F. )
		SX6->( dbDelete() )
		SX6->( msUnlock() )
	endif
next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetOrdem  ºAutor  ³Cristina Souza      º Data ³ 26/Set/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca a ordem que deve ser usada para atualizacao de campos º±±
±±º          ³no SX3.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AtuSX3                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetOrdem( cAlias, cCampo )
Local cRet

SX3->( dbSetOrder(2) )
if SX3->( dbSeek( cCampo ) )
	cRet := SX3->X3_ORDEM
else
	SX3->( dbSetOrder(1) )
	SX3->( dbSeek( cAlias ) )
	while SX3->( !eof() .and. X3_ARQUIVO == cAlias )
		cRet := SX3->X3_ORDEM
		SX3->( dbSkip() )
	end
	
	cRet := Soma1( cRet )
endif

Return cRet