#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |Updge10  ºAutor  ³Rodrigo Fazan       º Data ³ 28/Ago/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizador de dicionarios para contemplar as novas funcionaº±±
±±º          ³lidades da integração GE X Fiscal                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GE                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UpdGE18() //Para maiores detalhes sobre a utilizacao deste fonte leia o boletim

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualizacao do dicionário? Esta rotina deve ser utilizada em modo exclusivo! Faca um backup dos dicionários e da base de dados antes da atualização para eventuais falhas de atualização!", "Atenção")

If lHistorico
	Processa({|lEnd| GEProc(@lEnd)},"Processando","Aguarde, preparando os arquivos",.F.)
	Final("Atualização efetuada!")
endif
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³Rodrigo Fazan         ³ Data ³ 28/Ago/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cFile     :="" //Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}				     
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo := 49 				//SIGAGE - GESTAO EDUCACIONAL

/********************************************************************************************
Inicia o processamento.
********************************************************************************************/
ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Elimina do SX o que deve ser eliminado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcRegua(3)

			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += AtuSX2()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += AtuSX3()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME) 
			cTexto += AtuSIX()
            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += AtuSX6(SM0->M0_CODFIL)
			
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
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
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			dbSelectArea("JJ1")
			dbSelectArea("JJ2")
			dbSelectArea("JJ3")
			dbSelectArea("JJ4")
			dbSelectArea("JJ5")

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
		Next nI 
		   
		If lOpen
			cTexto := "Log da atualizacao "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
±±³Fun‡…o    ³AtuSX2    ³ Autor ³Rodrigo Fazan         ³ Data ³ 28/Ago/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para a gravação do sx2 das tabelas "JJ"             ³±± 
±±³          ³                                                            ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AtuSX2()
Local aSX2   := {}							//Array que contem as informacoes das tabelas
Local aEstrut:= {}							//Array que contem a estrutura da tabela SX2
Local i      := 0							//Contador para laco
Local j      := 0							//Contador para laco
Local cTexto := ''							//Retorno da funcao, sera utilizado pela funcao chamadora
Local cAlias := ''     						//Nome da tabela
Local cPath									//String para caminho do arquivo 
Local cNome									//String para nome da empresa e filial

aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG",;
			"X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO","X2_PYME"}

ProcRegua(Len(aSX2))

dbSelectArea("SX2")
SX2->(DbSetOrder(1))	
MsSeek("JA1") //Seleciona a tabela que eh padrao do sistema para pegar algumas informacoes
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)  

/******************************************************************************************
* Adiciona as informacoes das tabelas num array, para trabalho posterior
*******************************************************************************************/
aAdd(aSX2,{	"JJ1",; 								//Chave
			cPath,;									//Path
			"JJ1"+cNome,;							//Nome do Arquivo
			"Integrações GE x Fiscal",;		//Nome Port
			"Integrações GE x Fiscal",;		//Nome Port
			"Integrações GE x Fiscal",;		//Nome Port
			0,;										//Delete
			"E",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JJ1_FILIAL+JJ1_NUMPRO",;				//Unico
			"S"})									//Pyme
		
aAdd(aSX2,{	"JJ2",; 								//Chave
			cPath,;									//Path
			"JJ2"+cNome,;							//Nome do Arquivo
			"Titulos das Integrações GE",;			//Nome Port
			"Titulos das Integrações GE",;			//Nome Port
			"Titulos das Integrações GE",;			//Nome Port
			0,;										//Delete
			"E",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JJ2_FILIAL+JJ2_NUMPRO+JJ2_PRFTIT+JJ2_NUMTIT+JJ2_PARTIT+JJ2_TIPTIT",;		//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JJ3",; 								//Chave
			cPath,;									//Path
			"JJ3"+cNome,;							//Nome do Arquivo
			"Filtros das Integrações GE",;				//Nome Port
			"Filtros das Integrações GE",;				//Nome Port
			"Filtros das Integrações GE",;				//Nome Port
			0,;										//Delete
			"E",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JJ3_FILIAL+JJ3_NUMPRO+JJ3_TIPFIL+JJ3_CONTEU",;				//Unico
			"S"})									//Pyme
		
aAdd(aSX2,{	"JJ4",; 								//Chave
			cPath,;									//Path
			"JJ4"+cNome,;							//Nome do Arquivo
			"Grupos de Integração",;				//Nome Port
			"Grupos de Integração",;				//Nome Port
			"Grupos de Integração",;				//Nome Port
			0,;										//Delete
			"E",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JJ4_FILIAL+JJ4_TIPO+JJ4_CODGRP",;		//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JJ5",; 								//Chave
			cPath,;									//Path
			"JJ5"+cNome,;							//Nome do Arquivo
			"Itens de Grupo de Integração",;		//Nome Port
			"Itens de Grupo de Integração",;		//Nome Port
			"Itens de Grupo de Integração",;		//Nome Port
			0,;										//Delete
			"E",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JJ5_FILIAL+JJ5_TIPO+JJ5_CODGRP+JJ5_CHAVE",;		//Unico
			"S"})									//Pyme
			
/*******************************************************************************************
Realiza a inclusao das tabelas
*******************************************/
For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If SX2->( !dbSeek(aSX2[i,1]) )
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.) //Adiciona registro
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
	EndIf
Next i

Return cTexto

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
Static Function AtuSX3()
Local aSX3           := {}				//Array com os campos das tabelas
Local aEstrut        := {}              //Array com a estrutura da tabela SX3
Local i              := 0				//Laco para contador
Local j              := 0				//Laco para contador
Local lSX3	         := .F.             //Indica se houve atualizacao
Local cTexto         := ''				//String para msg ao fim do processo
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
aAdd(aSX3,{	"JJ1",;								//Arquivo
			"01",;								//Ordem
			"JJ1_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"@!",;								//Picture
			'ExistChav("JJ1",M->JJ1_NUMPRO) .and. FreeForUse("JJ1",M->JJ1_NUMPRO)',;					//VALID
			cUsadoOpc,;							//USADO
			'GetSXENum("JJ1","JJ1_NUMPRO")',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"02",;								//Ordem
			"JJ1_NUMPRO",;						//Campo
			"C",;								//Tipo
			10,;									//Tamanho
			0,;									//Decimal
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"@!",;								//Picture
			'ExistChav("JJ1",M->JJ1_NUMPRO) .and. FreeForUse("JJ1",M->JJ1_NUMPRO)',;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JHO",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"03",;								//Ordem
			"JJ1_STATUS",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Status",;					    //Titulo
			"Status",;					    //Titulo
			"Status",;					    //Titulo
			"Status",;					    //Titulo
			"Status",;					    //Titulo
			"Status",;					    //Titulo
			"",;							//Picture
			''  ,;							//VALID
			cUsadoOpc,;						//USADO
			"1",;							//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Simulacao;2=NF Gerada;3=NF Cancelada","1=Simulacao;2=NF Gerada;3=NF Cancelada","1=Simulacao;2=NF Gerada;3=NF Cancelada",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"04",;								//Ordem
			"JJ1_DTSIMU",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Data Simul",;					    //Titulo
			"Data Simul.",;					    //Titulo
			"Data Simul.",;					    //Titulo
			"Data Simul.",;					    //Titulo
			"Data Simul.",;					    //Titulo
			"Data Simul.",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'dDataBase',;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JJ1",;								//Arquivo
			"05",;								//Ordem
			"JJ1_HRSIMU",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora Simul",;					    //Titulo
			"Hora Simul",;					    //Titulo
			"Hora Simul",;					    //Titulo
			"Hora Simul",;					    //Titulo
			"Hora Simul",;					    //Titulo
			"Hora Simul",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'Time()',;							//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"06",;								//Ordem
			"JJ1_USSIMU",;						//Campo
			"C",;								//Tipo
			15,;									//Tamanho
			0,;									//Decimal
			"Usuario Sim",;					    //Titulo
			"Usuario Sim",;					    //Titulo
			"Usuario Sim",;					    //Titulo
			"Usuario Sim",;					    //Titulo
			"Usuario Sim",;					    //Titulo
			"Usuario Sim",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'Subs(cUsuario,7,15)',;				//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"07",;								//Ordem
			"JJ1_DTEFET",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Data Efeti.",;					    //Titulo
			"Data Efeti.",;					    //Titulo
			"Data Efeti.",;					    //Titulo
			"Data Efeti.",;					    //Titulo
			"Data Efeti.",;					    //Titulo
			"Data Efeti.",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME			

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"08",;								//Ordem
			"JJ1_HREFET",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora Efeti.",;					    //Titulo
			"Hora Efeit.",;					    //Titulo
			"Hora Efeti.",;					    //Titulo
			"Hora Efeti.",;					    //Titulo
			"Hora Efeti.",;					    //Titulo
			"Hora Efeti.",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;							//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"09",;								//Ordem
			"JJ1_USEFET",;						//Campo
			"C",;								//Tipo
			15,;									//Tamanho
			0,;									//Decimal
			"Usuario Efe",;					    //Titulo
			"Usuario Efe",;					    //Titulo
			"Usuario Efe",;					    //Titulo
			"Usuario Efe",;					    //Titulo
			"Usuario Efe",;					    //Titulo
			"Usuario Efe",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'',;				//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"10",;								//Ordem
			"JJ1_DTCANC",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Data Cancel.",;					    //Titulo
			"Data Cancel.",;					    //Titulo
			"Data Cancel.",;					    //Titulo
			"Data Cancel.",;					    //Titulo
			"Data Cancel.",;					    //Titulo
			"Data Cancel.",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME			

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"11",;								//Ordem
			"JJ1_HRCANC",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Hora Cancel.",;					    //Titulo
			"Hora Cancel.",;					    //Titulo
			"Hora Cancel.",;					    //Titulo
			"Hora Cancel.",;					    //Titulo
			"Hora Cancel.",;					    //Titulo
			"Hora Cancel.",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;							//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ1",;								//Arquivo
			"12",;								//Ordem
			"JJ1_USCANC",;						//Campo
			"C",;								//Tipo
			15,;									//Tamanho
			0,;									//Decimal
			"Usuario Can",;					    //Titulo
			"Usuario Can",;					    //Titulo
			"Usuario Can",;					    //Titulo
			"Usuario Can",;					    //Titulo
			"Usuario Can",;					    //Titulo
			"Usuario Can",;					    //Titulo
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'',;				//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////   JJ2
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

aAdd(aSX3,{	"JJ2",;								//Arquivo
			"01",;								//Ordem
			"JJ2_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"@!",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;								//Arquivo
			"02",;								//Ordem
			"JJ2_NUMPRO",;						//Campo
			"C",;								//Tipo
			10,;								//Tamanho
			0,;									//Decimal
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"@!",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
                                                                                          
aAdd(aSX3,{	"JJ2",;								//Arquivo
			"03",;								//Ordem
			"JJ2_PRFTIT",;						//Campo
			"C",;								//Tipo
			03,;								//Tamanho
			0,;									//Decimal
			"Prefixo",;					    //Titulo
			"Prefixo",;					    //Titulo
			"Prefixo",;					    //Titulo
			"Prefixo",;					    //Titulo
			"Prefixo",;					    //Titulo
			"Prefixo",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"04",;							//Ordem
			"JJ2_NUMTIT",;					//Campo
			"C",;							//Tipo
			06,;							//Tamanho
			0,;								//Decimal
			"Numero",;					    //Titulo
			"Numero",;					    //Titulo
			"Numero",;					    //Titulo
			"Numero",;					    //Titulo
			"Numero",;					    //Titulo
			"Numero",;					    //Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"05",;							//Ordem
			"JJ2_PARTIT",;					//Campo
			"C",;							//Tipo
			01,;							//Tamanho
			0,;								//Decimal
			"Parcela",;					    //Titulo
			"Parcela",;					    //Titulo
			"Parcela",;					    //Titulo
			"Parcela",;					    //Titulo
			"Parcela",;					    //Titulo
			"Parcela",;					    //Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","011","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
                                                                                      
aAdd(aSX3,{	"JJ2",;							//Arquivo
			"06",;							//Ordem
			"JJ2_TIPTIT",;					//Campo
			"C",;							//Tipo
			03,;							//Tamanho
			0,;								//Decimal
			"Tipo titulo",;					    //Titulo
			"Tipo titulo",;					    //Titulo
			"Tipo titulo",;					    //Titulo
			"Tipo titulo",;					    //Titulo
			"Tipo titulo",;					    //Titulo
			"Tipo titulo",;					    //Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"07",;							//Ordem
			"JJ2_VALOR",;					//Campo
			"N",;							//Tipo
			14,;							//Tamanho
			2,;								//Decimal
			"Valor",;					    //Titulo
			"Valor",;					    //Titulo
			"Valor",;					    //Titulo
			"Valor",;					    //Titulo
			"Valor",;					    //Titulo
			"Valor",;					    //Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JJ2",;							//Arquivo
			"08",;							//Ordem
			"JJ2_VENCTO",;					//Campo
			"D",;							//Tipo
			8,;							//Tamanho
			0,;								//Decimal
			"Vencimento",;					//Titulo
			"Vencimento",;					//Titulo
			"Vencimento",;					//Titulo
			"Vencimento",;					//Titulo
			"Vencimento",;					//Titulo
			"Vencimento",;					//Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"09",;							//Ordem
			"JJ2_EMISSA",;					//Campo
			"D",;							//Tipo
			8,;							//Tamanho
			0,;								//Decimal
			"Emissao",; 					//Titulo
			"Emissao",; 					//Titulo
			"Emissao",; 					//Titulo
			"Emissao",; 					//Titulo
			"Emissao",; 					//Titulo
			"Emissao",; 					//Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"10",;							//Ordem
			"JJ2_SERIE",;					//Campo
			"C",;							//Tipo
			3,;							//Tamanho
			0,;								//Decimal
			"Serie nota",; 					//Titulo
			"Serie nota",; 					//Titulo
			"Serie nota",; 					//Titulo
			"Serie nota",; 					//Titulo
			"Serie nota",; 					//Titulo
			"Serie nota",; 					//Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"11",;							//Ordem
			"JJ2_NOTA",;					//Campo
			"C",;							//Tipo
			6,;							//Tamanho
			0,;								//Decimal
			"Nota Fiscal",; 					//Titulo
			"Nota Fiscal",; 					//Titulo
			"Nota Fiscal",; 					//Titulo
			"Nota Fiscal",; 					//Titulo
			"Nota Fiscal",; 					//Titulo
			"Nota Fiscal",; 					//Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
                                                                                      
aAdd(aSX3,{	"JJ2",;							//Arquivo
			"12",;							//Ordem
			"JJ2_NUMRA",;					//Campo
			"C",;							//Tipo
			15,;							//Tamanho
			0,;								//Decimal
			"RA do aluno",; 					//Titulo
			"RA do aluno",; 					//Titulo
			"RA do aluno",; 					//Titulo
			"RA do aluno",; 					//Titulo
			"RA do aluno",; 					//Titulo
			"RA do aluno",; 					//Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ2",;							//Arquivo
			"13",;							//Ordem
			"JJ2_NRDOC",;					//Campo
			"C",;							//Tipo
			15,;							//Tamanho
			0,;								//Decimal
			"Nr Documento",; 					//Titulo
			"Nr Documento",; 					//Titulo
			"Nr Documento",; 					//Titulo
			"Nr Documento",; 					//Titulo
			"Nr Documento",; 					//Titulo
			"Nr Documento",; 					//Titulo
			"",;							//Picture
			"",;							//VALID
			cUsadoOpc,;						//USADO
			"",;							//RELACAO
			"",;							//F3
			1,;								//NIVEL
			cReservOpc,;					//RESERV
			"","","","S","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;						//CONTEXT, OBRIGAT, VLDUSER
			"","","",;						//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})			//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//JJ3
////////////////////////////////////////////////////////////////////////////////////////////////////////////

aAdd(aSX3,{	"JJ3",;								//Arquivo
			"01",;								//Ordem
			"JJ3_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"@!",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ3",;								//Arquivo
			"02",;								//Ordem
			"JJ3_NUMPRO",;						//Campo
			"C",;								//Tipo
			10,;								//Tamanho
			0,;									//Decimal
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"Num Proc.",;					    //Titulo
			"@!",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 

aAdd(aSX3,{	"JJ3",;								//Arquivo
			"03",;								//Ordem
			"JJ3_TIPFIL",;						//Campo
			"C",;								//Tipo
			02,;								//Tamanho
			0,;									//Decimal
			"Tipo Filtro",;					    //Titulo
			"Tipo Filtro",;					    //Titulo
			"Tipo Filtro",;					    //Titulo
			"Tipo Filtro",;					    //Titulo
			"Tipo Filtro",;					    //Titulo
			"Tipo Filtro",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 

aAdd(aSX3,{	"JJ3",;								//Arquivo
			"04",;								//Ordem
			"JJ3_CONTEU",;						//Campo
			"C",;								//Tipo
			08,;								//Tamanho
			0,;									//Decimal
			"Conteudo",;					    //Titulo
			"Conteudo",;					    //Titulo
			"Conteudo",;					    //Titulo
			"Conteudo",;					    //Titulo
			"Conteudo",;					    //Titulo
			"Conteudo",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//JJ4
////////////////////////////////////////////////////////////////////////////////////////////////////////////

aAdd(aSX3,{	"JJ4",;								//Arquivo
			"01",;								//Ordem
			"JJ4_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"@!",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ4",;								//Arquivo
			"02",;								//Ordem
			"JJ4_TIPO",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Tipo",;					    //Titulo
			"Tipo",;					    //Titulo
			"Tipo",;					    //Titulo
			"Tipo de agrupamento",;					    //Titulo
			"Tipo de agrupamento",;					    //Titulo
			"Tipo de agrupamento",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ4",;								//Arquivo
			"03",;								//Ordem
			"JJ4_CODGRP",;						//Campo
			"C",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Cod Grupo",;					    //Titulo
			"Cod Grupo",;					    //Titulo
			"Cod Grupo",;					    //Titulo
			"Codigo do agrupamento",;					    //Titulo
			"Codigo do agrupamento",;					    //Titulo
			"Codigo do agrupamento",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ4",;								//Arquivo
			"04",;								//Ordem
			"JJ4_DESC",;						//Campo
			"C",;								//Tipo
			30,;									//Tamanho
			0,;									//Decimal
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"Descricao",;					    //Titulo
			"@!",;								//Picture
			"NaoVazio()",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//JJ4
////////////////////////////////////////////////////////////////////////////////////////////////////////////

aAdd(aSX3,{	"JJ5",;								//Arquivo
			"01",;								//Ordem
			"JJ5_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"Filial",;					    //Titulo
			"@!",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ5",;								//Arquivo
			"02",;								//Ordem
			"JJ5_TIPO",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Tipo",;					    //Titulo
			"Tipo",;					    //Titulo
			"Tipo",;					    //Titulo
			"Tipo de agrupamento",;		    //Titulo
			"Tipo de agrupamento",;		    //Titulo
			"Tipo de agrupamento",;		    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ5",;								//Arquivo
			"03",;								//Ordem
			"JJ5_CODGRP",;						//Campo
			"C",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Cod. Grupo",;					    //Titulo
			"Cod. Grupo",;					    //Titulo
			"Cod. Grupo",;					    //Titulo
			"Cod. Grupo",;					    //Titulo
			"Cod. Grupo",;					    //Titulo
			"Cod. Grupo",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JJ5",;								//Arquivo
			"04",;								//Ordem
			"JJ5_CHAVE",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Chave",;					    //Titulo
			"Chave",;					    //Titulo
			"Chave",;					    //Titulo
			"Chave",;					    //Titulo
			"Chave",;					    //Titulo
			"Chave",;					    //Titulo
			"",;								//Picture
			"",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME			

/******************************************************************************************
Grava informacoes do array no banco de dados
******************************************************************************************/
ProcRegua(Len(aSX3))

SX3->(DbSetOrder(2))	

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
				aAdd(aArqUpd,aSX3[i,1])
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...") //
		Endif
	EndIf
Next i

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AtuSIX  ³ Autor ³Rafael Rodrigues      ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX - Indices       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME SHOWPESQ
Local cTexto    := ''						//String para msg ao fim do processo
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

aAdd(aSIX,{"JJ1",;   										//Indice
		"1",;                 								//Ordem
		"JJ1_FILIAL+JJ1_NUMPRO",;  							//Chave
		"Numero do Processo",; 								//Descicao Port.
		"Numero do Processo",;									//Descicao Spa.
		"Numero do Processo",;									//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  

aAdd(aSIX,{"JJ2",;   										//Indice
		"2",;                 								//Ordem
		"JJ1_FILIAL+JJ1_STATUS+JJ1_NUMPRO",;				//Chave
		"Status+Numero do Processo",;						//Descicao Port.
		"Status+Numero do Processo",;						//Descicao Port.
		"Status+Numero do Processo",;						//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  
		
aAdd(aSIX,{"JJ2",;                                          //Indice                        
		"1",;                                                                                                              //Ordem
		"JJ2_FILIAL+JJ2_NUMPRO+JJ2_SERIE+JJ2_NOTA+JJ2_PRFTIT+JJ2_NUMTIT+JJ2_PARTIT+JJ2_TIPTIT",;  //Chave
		"Numero do processo+Serie+Nota+Prefixo+Numero+Parcela+Tipo do Titulo",; //Descicao Port.
		"Numero do processo+Serie+Nota+Prefixo+Numero+Parcela+Tipo do Titulo",; //Descicao Port.
		"Numero do processo+Serie+Nota+Prefixo+Numero+Parcela+Tipo do Titulo",; //Descicao Port.
		"S",; //Proprietario
		"",;  //F3
		"",;  //NickName
		"S"})            

aAdd(aSIX,{"JJ2",;                                                                                                                //Indice
		"2",;                                                                            //Ordem
		"JJ2_FILIAL+JJ2_PRFTIT+JJ2_NUMTIT+JJ2_PARTIT+JJ2_TIPTIT+JJ2_NUMPRO",;            //Chave
		"Prefixo+Numero+Parcela+Tipo do Titulo+Numero do processo",;					 //Descicao Port.
		"Prefixo+Numero+Parcela+Tipo do Titulo+Numero do processo",;					 //Descicao Port.
		"Prefixo+Numero+Parcela+Tipo do Titulo+Numero do processo",;					 //Descicao Port.
		"S",;                                                                                                                                      //Proprietario
		"",;                                                                                                                                        //F3
		"",;                                                                                                                                        //NickName
		"S"})       
                                                                                                                                                                                                                                                      //ShowPesq
aAdd(aSIX,{"JJ3",;   										//Indice
		"1",;                 								//Ordem
		"JJ3_FILIAL+JJ3_NUMPRO+JJ3_TIPFIL+JJ3_CONTEU",;	//Chave
		"Cod. Grupo+Item",; //Descicao Port.
		"Cod. Grupo+Item",; //Descicao Port.
		"Cod. Grupo+Item",; //Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JJ4",;   										//Indice
		"1",;                 								//Ordem
		"JJ4_FILIAL+JJ4_TIPO+JJ4_CODGRP",;	//Chave
		"Tipo de grupo+Codigo do grupo",; //Descicao Port.
		"Tipo de grupo+Codigo do grupo",; //Descicao Port.
		"Tipo de grupo+Codigo do grupo",; //Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JJ5",;                                                                                                                //Indice
		"1",;                 	                                     //Ordem
		"JJ5_FILIAL+JJ5_TIPO+JJ5_CODGRP+JJ5_CHAVE",;                 //Chave
		"Tipo de grupo+Codigo do grupo+Chave",; //Descicao Port.
		"Tipo de grupo+Codigo do grupo+Chave",; //Descicao Port.
		"Tipo de grupo+Codigo do grupo+Chave",; //Descicao Port.
		"S",;                                                                                                                                      //Proprietario
		"",;                                                                                                                                        //F3
		"",;                                                                                                                                        //NickName
		"S"})                                                                                                                                     //ShowPesq


/*********************************************************************************************
Grava as informacoes do array na tabela six
*********************************************************************************************/
ProcRegua(Len(aSIX))

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
			aAdd(aArqUpd,aSIX[i,1])
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
			cTexto  += (aSix[i][1] + " - " + aSix[i][3] + Chr(13) + Chr(10))
			If lDelInd
				TcInternal(60,RetSqlName(aSix[i,1]) + "|" + RetSqlName(aSix[i,1]) + aSix[i,2]) //Exclui sem precisar baixar o TOP
			Endif	
		EndIf
		IncProc("Atualizando índices...")
	EndIf
Next i

If lSix
	cTexto += "Índices atualizados  : "+cAlias+CHR(13)+CHR(10)
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UPDGE18   ºAutor  ³Microsiga           º Data ³  08/29/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSX6(cCodFilial)
Local cTexto    := ''						//String para msg ao fim do processo
Local lSx6      := .F.                      //Verifica se houve atualizacao
Local aSx6      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SX6
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ''						//Alias para tabelas

Default cCodFilial := ""

/*********************************************************************************************
Define estrutura do array
*********************************************************************************************/
aEstrut:= { "X6_Filial","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
			"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2", "X6_CONTEUD","X6_CONTSPA", "X6_CONTENG",;
			"X6_PROPRI", "X6_PYME"}

/*********************************************************************************************
Define os dados do parametro
*********************************************************************************************/
aAdd(aSx6,{cCodFilial,;											//Filial
		"MV_ACFISTS",;											//Var
		"C",;                 									//Tipo
		"Tes de saida utilizada para a geração de not",; 	//Descric
		"Tes de saida utilizada para a geração de not",; 	//Descric
		"Tes de saida utilizada para a geração de not",; 	//Descric
		"as ficais ",;	//Desc1
		"as ficais ",;	//Desc1
		"as ficais ",;	//Desc1
		"",; 												//Desc2
		"",;												//DscSpa2
		"",;												//DscEng2
		"",;												//Conteud
		"",;												//ContSpa
		"",;												//ContEng
		"S",;													//Propri		
		"S"})													//Pyme

aAdd(aSx6,{cCodFilial,;											//Filial
		"MV_ACFISPR",;											//Var
		"C",;                 									//Tipo
		"Código do produto usado para a geração de   ",; 	//Descric
		"Código do produto usado para a geração de   ",; 	//Descric
		"Código do produto usado para a geração de   ",; 	//Descric
		"notas ficais ",;	//Desc1
		"notas ficais ",;	//Desc1
		"notas ficais ",;	//Desc1
		"",; 												//Desc2
		"",;												//DscSpa2
		"",;												//DscEng2
		"",;												//Conteud
		"",;												//ContSpa
		"",;												//ContEng
		"S",;													//Propri		
		"S"})													//Pyme

aAdd(aSx6,{cCodFilial,;											//Filial
		"MV_ACFISCL",;											//Var
		"C",;                 									//Tipo
		"Código cliente + loja   para a geração de   ",; 	//Descric
		"Código cliente + loja   para a geração de   ",; 	//Descric
		"Código cliente + loja   para a geração de   ",; 	//Descric
		"notas ficais ",;	//Desc1
		"notas ficais ",;	//Desc1
		"notas ficais ",;	//Desc1
		"",; 												//Desc2
		"",;												//DscSpa2
		"",;												//DscEng2
		"",;												//Conteud
		"",;												//ContSpa
		"",;												//ContEng
		"S",;													//Propri		
		"S"})													//Pyme

aAdd(aSx6,{cCodFilial,;											//Filial
		"MV_ACFISCP",;											//Var
		"C",;                 									//Tipo
		"Condição de pagamento   para a geração de   ",; 	//Descric
		"Condição de pagamento   para a geração de   ",; 	//Descric
		"Condição de pagamento   para a geração de   ",; 	//Descric
		"notas ficais ",;	//Desc1
		"notas ficais ",;	//Desc1
		"notas ficais ",;	//Desc1
		"",; 												//Desc2
		"",;												//DscSpa2
		"",;												//DscEng2
		"",;												//Conteud
		"",;												//ContSpa
		"",;												//ContEng
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
		cTexto  += (aSx6[i][1] + " - " + aSx6[i][2] + Chr(13) + Chr(10))
	EndIf
	IncProc("Atualizando parametros...")
Next i

If lSx6
	cTexto += "parametros atualizados " + Chr(13)
EndIf

Return cTexto