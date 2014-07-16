#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UpdGE01   ³ Autor ³Eduardo de Souza       ³ Data ³ 30/Nov/05³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de Segmentos (Regra de Visibilidade) - Gestao Educ.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaGE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UpdGE01() //Para maiores detalhes sobre a utilizacao deste fonte leia o boletim
							    //"Ge - Controle de Visibilidade".

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd 

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualizacao do Dicionário? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionários e da Base de Dados antes da atualização para eventuais falhas de atualização !", "Atenção")
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Atualização do Dicionário - GE"

ACTIVATE WINDOW oMainWnd ;
	ON INIT If(lHistorico,(Processa({|lEnd| GEProc(@lEnd)},"Processando","Aguarde , processando preparação dos arquivos",.F.) , Final("Atualização efetuada!")),oMainWnd:End())
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEProc    ³ Autor ³Eduardo de Souza       ³ Data ³30/Nov/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
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
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcRegua(8)
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GEAtuSX2()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GEAtuSX3()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Gatilhos...")
			GEAtuSX7()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME) 
			cTexto += GEAtuSIX()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o parametro³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando parametro...") 
			cTexto += GEAtuSx6( SM0->M0_CODIGO )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Consultas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando consultas padroes...") 
			cTexto += GEAtuSxB( SM0->M0_CODIGO )

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
			dbSelectArea("JHC")
			dbSelectArea("JHD")
			dbSelectArea("JHE")
			dbSelectArea("JHF")
			dbSelectArea("JHG")
			dbSelectArea("JHH")
			dbSelectArea("JHI")
			dbSelectArea("JHJ")
			dbSelectArea("JHN")						
			
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX2  ³ Autor ³Eduardo de Souza       ³ Data ³30/Nov/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
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
*******************************************************************************************
Cadastro de Segmentos
*******************************************/
Aadd(aSX2,{	"JHC",; 								//Chave
			cPath,;									//Path
			"JHC"+cNome,;							//Nome do Arquivo
			"Cadastro de Segmentos",;				//Nome Port
			"Cadastro de Segmentos",;				//Nome Esp
			"Cadastro de Segmentos",;				//Nome Ing
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHC_FILIAL+JHC_CODSEG",;				//Unico
			"S"})									//Pyme
		
/*******************************************************************************************
Segmentos X Visoes
*******************************************/
Aadd(aSX2,{	"JHD",; 								//Chave
			cPath,;									//Path
			"JHD"+cNome,;							//Nome do Arquivo
			"Segmentos X Visoes",;					//Nome Port
			"Segmentos X Visoes",;					//Nome Esp
			"Segmentos X Visoes",;					//Nome Ing
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHD_FILIAL+JHD_CODSEG+JHD_ITEM",;		//Unico
			"S"})									//Pyme
		
/*******************************************************************************************
Segmentos X Grupos de Usuarios
*******************************************/
Aadd(aSX2,{	"JHN",; 								//Chave
			cPath,;									//Path
			"JHN"+cNome,;							//Nome do Arquivo
			"Segmentos X Grupos de Usuarios",;		//Nome Port
			"Segmentos X Grupos de Usuarios",;		//Nome Esp
			"Segmentos X Grupos de Usuarios",;		//Nome Ing
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHN_FILIAL+JHN_CODSEG+JHN_CODGRU",;	//Unico
			"S"})									//Pyme

/*******************************************************************************************
Segmentos X Usuarios
*******************************************/
Aadd(aSX2,{	"JHE",; 								//Chave
			cPath,;									//Path
			"JHE"+cNome,;							//Nome do Arquivo
			"Segmentos X Usuarios",;				//Nome Port
			"Segmentos X Usuarios",;				//Nome Esp
			"Segmentos X Usuarios",;				//Nome Ing
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHE_FILIAL+JHE_CODSEG+JHE_CODUSU",;	//Unico
			"S"})									//Pyme


/*******************************************************************************************
Segmentos X Departamentos
*******************************************/
Aadd(aSX2,{	"JHF",; 								//Chave
			cPath,;									//Path
			"JHF"+cNome,;							//Nome do Arquivo
			"Segmentos X Departamentos",;			//Nome Port
			"Segmentos X Departamentos",;			//Nome Esp
			"Segmentos X Departamentos",;			//Nome Ing
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHF_FILIAL+JHF_CODSEG+JHF_CODDEP",;				//Unico
			"S"})									//Pyme
			
/*******************************************************************************************
Segmentos X Grupos de Documentos
*******************************************/
Aadd(aSX2,{	"JHG",; 								//Chave
			cPath,;									//Path
			"JHG"+cNome,;							//Nome do Arquivo
			"Segmentos X Grupos Documentos",;		//Nome Port
			"Segmentos X Grupos Documentos",;		//Nome Esp 
			"Segmentos X Grupos Documentos",;		//Nome Ing 
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHG_FILIAL+JHG_CODSEG+JHG_CODGRU",;	//Unico
			"S"})									//Pyme

/*******************************************************************************************
Segmentos X Externos
*******************************************/
Aadd(aSX2,{	"JHH",; 								//Chave
			cPath,;									//Path
			"JHH"+cNome,;							//Nome do Arquivo
			"Segmentos X Externos",;				//Nome Port
			"Segmentos X Externos",;				//Nome Esp 
			"Segmentos X Externos",;				//Nome Ing 
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHH_FILIAL+JHH_CODSEG+JHH_CODEXT",;	//Unico
			"S"})									//Pyme

/*******************************************************************************************
Segmentos X Funcionarios
*******************************************/
Aadd(aSX2,{	"JHI",; 								//Chave
			cPath,;									//Path
			"JHI"+cNome,;							//Nome do Arquivo
			"Segmentos X Funcionarios",;			//Nome Port
			"Segmentos X Funcionarios",;			//Nome Esp 
			"Segmentos X Funcionarios",;			//Nome Ing 
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHI_FILIAL+JHI_CODSEG+JHI_MATFUN",;	//Unico
			"S"})									//Pyme


/*******************************************************************************************
Segmentos X Disciplinas
*******************************************/
Aadd(aSX2,{	"JHJ",; 								//Chave
			cPath,;									//Path
			"JHJ"+cNome,;							//Nome do Arquivo
			"Segmentos X Disciplinas",;				//Nome Port
			"Segmentos X Disciplinas",;				//Nome Esp 
			"Segmentos X Disciplinas",;				//Nome Ing 
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHJ_FILIAL+JHJ_CODSEG+JHJ_CODDIS",;	//Unico
			"S"})									//Pyme

/*******************************************************************************************
Realiza a inclusao das tabelas
*******************************************/
For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !MsSeek(aSX2[i,1])
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
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Arquivos...")
		EndIf
	EndIf
Next i

Return cTexto

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³Eduardo de Souza       ³ Data ³30/Nov/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
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
Local cTexto         := ''				//String para msg ao fim do processo
Local cAlias         := ''				//String para utilizacao do noem da tabela
Local cUsadoObrig	 := ''				//String que servira para cadastrar um campo como "USADO"
Local cReservado	 := ''				//String que servira para cadastrar um campo como "Reservado"
Local cNaoUsado		 := ''
Local nI             := 0				//Laco para contador
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
If SX3->(MsSeek("JAG_DESC")) //Este campo e obrigatorio e permite alterar
	For nI := 1 To SX3->(FCount())
		If "X3_USADO"  $ SX3->(FieldName(nI))
			cUsadoObrig  := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
		If "X3_RESERV"  $ SX3->(FieldName(nI))
			cReservado  := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
	Next
EndIf
If SX3->(MsSeek("JA1_FILIAL")) //Este campo e obrigatorio e permite alterar
	For nI := 1 To SX3->(FCount())
		If "X3_USADO"  $ SX3->(FieldName(nI))
			cNaoUsado  := SX3->(FieldGet(FieldPos(FieldName(nI))))
		EndIf
	Next
EndIf

/*******************************************************************************************
Monta o array com os campos das tabelas/*
/*******************************************
JHC_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHC",;								//Arquivo
			"01",;								//Ordem
			"JHC_FILIAL",;						//Campo
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
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHC_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHC",;								//Arquivo
			"02",;								//Ordem
			"JHC_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"ExistChav('JHC',M->JHC_CODSEG) .And. FreeForUse('JHC',M->JHC_CODSEG)",;//VALID
			cUsadoObrig,;						//USADO
			"GETSXENUM('JHC','JHC_CODSEG')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHC_DESSEG
********************************************************************************************/
Aadd(aSX3,{	"JHC",;								//Arquivo
			"03",;								//Ordem
			"JHC_DESSEG",;						//Campo
			"C",;								//Tipo
			50,;					   			//Tamanho
			0,;									//Decimal
			"Descricao",;		      			//Titulo
			"Descricao",;		   				//Titulo SPA
			"Descricao",;		      			//Titulo ENG
			"Descricao do Segmento",;			//Descricao
			"Descricao do Segmento",;			//Descricao SPA
			"Descricao do Segmento",;  			//Descricao ENG
			"@!",;					   			//Picture
			"NaoVazio()",;						//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME			
/********************************************************************************************
JHD_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"01",;								//Ordem
			"JHD_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;							//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"02",;								//Ordem
			"JHD_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_ITEM
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"03",;								//Ordem
			"JHD_ITEM",;						//Campo
			"C",;								//Tipo
			3,;						   			//Tamanho
			0,;									//Decimal
			"Item",;			      			//Titulo
			"Item",;			   				//Titulo SPA
			"Item",;			      			//Titulo ENG
			"Item",;							//Descricao
			"Item",;							//Descricao SPA
			"Item",;				   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME

/********************************************************************************************
JHD_CURSO
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"04",;								//Ordem
			"JHD_CURSO",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Curso",;			      			//Titulo
			"Curso",;			   				//Titulo SPA
			"Curso",;			      			//Titulo ENG
			"Curso Padrao",;					//Descricao
			"Curso Padrao",;					//Descricao SPA
			"Curso Padrao",;		   			//Descricao ENG
			"@!",;					   			//Picture
			"EXISTCPO('JAF',M->JHD_CURSO)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"JAF",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_DESCUR
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"05",;								//Ordem
			"JHD_DESCUR",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Curso",;			    		//Titulo
			"Desc.Curso",;			   			//Titulo SPA
			"Desc.Curso",;			     		//Titulo ENG
			"Descricao do Curso Padrao",;		//Descricao
			"Descricao do Curso Padrao",;		//Descricao SPA
			"Descricao do Curso Padrao",;		//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('JAF',1,xFilial('JAF')+JHD->JHD_CURSO,'JAF_DESC'),'')",;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_UNIDAD
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"06",;								//Ordem
			"JHD_UNIDAD",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Unidade",;			   			//Titulo
			"Cod.Unidade",;						//Titulo SPA
			"Cod.Unidade",;		      			//Titulo ENG
			"Codigo da Unidade",;				//Descricao
			"Codigo da Unidade",;				//Descricao SPA
			"Codigo da Unidade",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"ExistCpo('JA3',M->JHD_UNIDAD)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"JA3",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_DESUNI
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"07",;								//Ordem
			"JHD_DESUNI",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Unidade",;		    		//Titulo
			"Desc.Unidade",;		   			//Titulo SPA
			"Desc.Unidade",;		     		//Titulo ENG
			"Descricao da Unidade",;			//Descricao
			"Descricao da Unidade",;			//Descricao SPA
			"Descricao da Unidade",;			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"IF(!INCLUI,POSICIONE('JA3',1,XFILIAL('JA3')+JHD->JHD_UNIDAD,'JA3_DESLOC'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_TURNO
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"08",;								//Ordem
			"JHD_TURNO",;						//Campo
			"C",;								//Tipo
			3,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Turno",;			   			//Titulo
			"Cod.Turno",;						//Titulo SPA
			"Cod.Turno",;		      			//Titulo ENG
			"Codigo do Turno",;					//Descricao
			"Codigo do Turno",;					//Descricao SPA
			"Codigo do Turno",;		   			//Descricao ENG
			"@!",;					   			//Picture
			"ExistCpo('SX5','F5'+M->JHD_TURNO)",;//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"F5",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_DESTUR
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"09",;								//Ordem
			"JHD_DESTUR",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Turno",;			    		//Titulo
			"Desc.Turno",;			   			//Titulo SPA
			"Desc.Turno",;			     		//Titulo ENG
			"Descricao do Turno",;				//Descricao
			"Descricao do Turno",;				//Descricao SPA
			"Descricao do Turno",;				//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Left(Posicione('SX5',1,xFilial('SX5')+'F5'+JHD->JHD_TURNO, 'X5_DESCRI'),30),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_GRUPO
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"10",;								//Ordem
			"JHD_GRUPO",;						//Campo
			"C",;								//Tipo
			3,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Grupo",;			   			//Titulo
			"Cod.Grupo",;						//Titulo SPA
			"Cod.Grupo",;		      			//Titulo ENG
			"Codigo do Grupo",;					//Descricao
			"Codigo do Grupo",;					//Descricao SPA
			"Codigo do Grupo",;		   			//Descricao ENG
			"@!",;					   			//Picture
			"ExistCpo('SX5','FC'+M->JHD_GRUPO)",;//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"FC",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME			
/********************************************************************************************
JHD_DESGRU
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"11",;								//Ordem
			"JHD_DESGRU",;						//Campo
			"C",;								//Tipo
			40,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Grupo",;			    		//Titulo
			"Desc.Grupo",;			   			//Titulo SPA
			"Desc.Grupo",;			     		//Titulo ENG
			"Descricao do Grupo",;				//Descricao
			"Descricao do Grupo",;				//Descricao SPA
			"Descricao do Grupo",;				//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Tabela('FC',JHD->JHD_GRUPO, .F.),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHD_AREA 
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"12",;								//Ordem
			"JHD_AREA",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Area",;			   			//Titulo
			"Cod.Area",;						//Titulo SPA
			"Cod.Area",;		      			//Titulo ENG
			"Codigo da Area",;					//Descricao
			"Codigo da Area",;					//Descricao SPA
			"Codigo da Area",;		   			//Descricao ENG
			"@!",;					   			//Picture
			"ExistCpo('JAG',M->JHD_AREA)",;		//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"JAG",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME						
/********************************************************************************************
JHD_DESARE
********************************************************************************************/
Aadd(aSX3,{	"JHD",;								//Arquivo
			"13",;								//Ordem
			"JHD_DESARE",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Area",;			    		//Titulo
			"Desc.Area",;			   			//Titulo SPA
			"Desc.Area",;			     		//Titulo ENG
			"Descricao da Area",;				//Descricao
			"Descricao do Area",;				//Descricao SPA
			"Descricao do Area",;				//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('JAG',1,xFilial('JAG')+JHD->JHD_AREA,'JAG_DESC'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHN_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHN",;								//Arquivo
			"01",;								//Ordem
			"JHN_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;			    			//Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHN_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHN",;								//Arquivo
			"02",;								//Ordem
			"JHN_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHN_CODGRU
********************************************************************************************/
Aadd(aSX3,{	"JHN",;								//Arquivo
			"03",;								//Ordem
			"JHN_CODGRU",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Grupo",;		      			//Titulo
			"Cod.Grupo",;		   				//Titulo SPA
			"Cod.Grupo",;		      			//Titulo ENG
			"Grupo de Usuarios",;				//Descricao
			"Grupo de Usuarios",;				//Descricao SPA
			"Grupo de Usuarios",;	   			//Descricao ENG
			"999999",;				   			//Picture
			"Acm050GrUs('G')",;					//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"GRP",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHN_NOMGRU
********************************************************************************************/
Aadd(aSX3,{	"JHN",;								//Arquivo
			"04",;								//Ordem
			"JHN_NOMGRU",;						//Campo
			"C",;								//Tipo
			20,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Grupo",;			    		//Titulo
			"Desc.Grupo",;			   			//Titulo SPA
			"Desc.Grupo",;			     		//Titulo ENG
			"Des. Grupo de Usuarios",;			//Descricao
			"Des. Grupo de Usuarios",;			//Descricao SPA
			"Des. Grupo de Usuarios",;			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHN_ACEMAN
********************************************************************************************/
Aadd(aSX3,{	"JHN",;								//Arquivo
			"05",;								//Ordem
			"JHN_ACEMAN",;						//Campo
			"C",;								//Tipo
			1,;						   			//Tamanho
			0,;									//Decimal
			"Manut.Geral",;		      			//Titulo
			"Manut.Geral",;		   				//Titulo SPA
			"Manut.Geral",;		      			//Titulo ENG
			"Permite Manutencao Geral",;		//Descricao
			"Permite Manutencao Geral",;		//Descricao SPA
			"Permite Manutencao Geral",;		//Descricao ENG
			"@!",;				   				//Picture
			"Pertence('12') .And. Acm050VDir('JHN_ACEMAN')",;//VALID
			cUsadoObrig,;						//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"1=Sim;2=Nao",;						//CBOX
			"1=Sim;2=Nao",;						//CBOX SPA
			"1=Sim;2=Nao",;						//CBOX ENG
			"",;								//PICTVAR
			"M->JHN_ACEMOV == '2'",;			//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHN_ACEMOV
********************************************************************************************/
Aadd(aSX3,{	"JHN",;								//Arquivo
			"06",;								//Ordem
			"JHN_ACEMOV",;						//Campo
			"C",;								//Tipo
			1,;						   			//Tamanho
			0,;									//Decimal
			"Somente Mov.",;	      			//Titulo
			"Somente Mov.",;	   				//Titulo SPA
			"Somente Mov.",;	      			//Titulo ENG
			"Permite Somente Mov. Aluno",;		//Descricao
			"Permite Somente Mov. Aluno",;		//Descricao SPA
			"Permite Somente Mov. Aluno",;		//Descricao ENG
			"@!",;				   				//Picture
			"Pertence('12') .And. Acm050VDir('JHN_ACEMOV')",;//VALID
			cUsadoObrig,;						//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"1=Sim;2=Nao",;						//CBOX
			"1=Sim;2=Nao",;						//CBOX SPA
			"1=Sim;2=Nao",;						//CBOX ENG
			"",;								//PICTVAR
			"M->JHN_ACEMAN == '2'",;			//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHE_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHE",;								//Arquivo
			"01",;								//Ordem
			"JHE_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;						   	//Titulo SPA
			"Filial",;						    //Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",; 								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;	 							//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHE_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHE",;								//Arquivo
			"02",;								//Ordem
			"JHE_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHE_CODUSU
********************************************************************************************/
Aadd(aSX3,{	"JHE",;								//Arquivo
			"03",;								//Ordem
			"JHE_CODUSU",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Usuario",;		      			//Titulo
			"Cod.Usuario",;		   				//Titulo SPA
			"Cod.Usuario",;		      			//Titulo ENG
			"Codigo do Usuario",;				//Descricao
			"Codigo do Usuario",;				//Descricao SPA
			"Codigo do Usuario",;	   			//Descricao ENG
			"999999",;				   			//Picture
			"Acm050GrUs('U')",;					//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"USR",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHE_NOMUSU
********************************************************************************************/
Aadd(aSX3,{	"JHE",;								//Arquivo
			"04",;								//Ordem
			"JHE_NOMUSU",;						//Campo
			"C",;								//Tipo
			20,;					   			//Tamanho
			0,;									//Decimal
			"Nome Usuario",;		    		//Titulo
			"Nome Usuario",;		   			//Titulo SPA
			"Nome Usuario",;		     		//Titulo ENG
			"Nome do Usuario",;					//Descricao
			"Nome do Usuario",;					//Descricao SPA
			"Nome do Usuario",;					//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"",;							//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHE_ACEMAN
********************************************************************************************/
Aadd(aSX3,{	"JHE",;								//Arquivo
			"05",;								//Ordem
			"JHE_ACEMAN",;						//Campo
			"C",;								//Tipo
			1,;						   			//Tamanho
			0,;									//Decimal
			"Manut.Geral",;		      			//Titulo
			"Manut.Geral",;		   				//Titulo SPA
			"Manut.Geral",;		      			//Titulo ENG
			"Permite Manutencao Geral",;		//Descricao
			"Permite Manutencao Geral",;		//Descricao SPA
			"Permite Manutencao Geral",;		//Descricao ENG
			"@!",;				   				//Picture
			"Pertence('12') .And. Acm050VDir('JHE_ACEMAN')",;//VALID
			cUsadoObrig,;						//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"1=Sim;2=Nao",;						//CBOX
			"1=Sim;2=Nao",;						//CBOX SPA
			"1=Sim;2=Nao",;						//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHE_ACEMOV
********************************************************************************************/
Aadd(aSX3,{	"JHE",;								//Arquivo
			"06",;								//Ordem
			"JHE_ACEMOV",;						//Campo
			"C",;								//Tipo
			1,;						   			//Tamanho
			0,;									//Decimal
			"Somente Mov.",;	      			//Titulo
			"Somente Mov.",;	   				//Titulo SPA
			"Somente Mov.",;	      			//Titulo ENG
			"Permite Somente Mov. Aluno",;		//Descricao
			"Permite Somente Mov. Aluno",;		//Descricao SPA
			"Permite Somente Mov. Aluno",;		//Descricao ENG
			"@!",;				   				//Picture
			"Pertence('12') .And. Acm050VDir('JHE_ACEMOV')",;//VALID
			cUsadoObrig,;						//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"1=Sim;2=Nao",;						//CBOX
			"1=Sim;2=Nao",;						//CBOX SPA
			"1=Sim;2=Nao",;						//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHF_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHF",;								//Arquivo
			"01",;								//Ordem
			"JHF_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;						    //Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;	 							//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;			 					//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHF_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHF",;								//Arquivo
			"02",;								//Ordem
			"JHF_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHF_CODDEP
********************************************************************************************/
Aadd(aSX3,{	"JHF",;								//Arquivo
			"03",;								//Ordem
			"JHF_CODDEP",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Depto",;		      			//Titulo
			"Cod.Depto",;		   				//Titulo SPA
			"Cod.Depto",;		      			//Titulo ENG
			"Codigo do Departamento",;			//Descricao
			"Codigo do Departamento",;			//Descricao SPA
			"Codigo do Departamento",; 			//Descricao ENG
			"@!",;					   			//Picture
			"GEExistcpo('JBJ',M->JHF_CODDEP)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"JBJ",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHF_DESDEP
********************************************************************************************/
Aadd(aSX3,{	"JHF",;								//Arquivo
			"04",;								//Ordem
			"JHF_DESDEP",;						//Campo
			"C",;								//Tipo
			60,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Depto",;			    		//Titulo
			"Desc.Depto",;			   			//Titulo SPA
			"Desc.Depto",;			     		//Titulo ENG
			"Descricao do Departamento",;		//Descricao
			"Descricao do Departamento",;		//Descricao SPA
			"Descricao do Departamento",;		//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('JBJ',1,xFilial('JBJ')+JHF->JHF_CODDEP,'JBJ_DESC'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHG_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHG",;								//Arquivo
			"01",;								//Ordem
			"JHG_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;					  				//Decimal
			"Filial",;			    			//Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;						    //Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHG_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHG",;								//Arquivo
			"02",;								//Ordem
			"JHG_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHG_CODGRU
********************************************************************************************/
Aadd(aSX3,{	"JHG",;								//Arquivo
			"03",;								//Ordem
			"JHG_CODGRU",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Cod.Grupo",;		      			//Titulo
			"Cod.Grupo",;		   				//Titulo SPA
			"Cod.Grupo",;		      			//Titulo ENG
			"Cod.Grupo de Documentos",;			//Descricao
			"Cod.Grupo de Documentos",;			//Descricao SPA
			"Cod.Grupo de Documentos",; 		//Descricao ENG
			"@!",;					   			//Picture
			"GEExistcpo('JAK',M->JHG_CODGRU)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"JAK",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHG_DESGRU
********************************************************************************************/
Aadd(aSX3,{	"JHG",;								//Arquivo
			"04",;								//Ordem
			"JHG_DESGRU",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Grupo",;			    		//Titulo
			"Desc.Grupo",;			   			//Titulo SPA
			"Desc.Grupo",;			     		//Titulo ENG
			"Descricao do Grupo",;				//Descricao
			"Descricao do Grupo",;				//Descricao SPA
			"Descricao do Grupo",;				//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('JAK',1,xFilial('JAK')+JHG->JHG_CODGRU,'JAK_DESC'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHH_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHH",;								//Arquivo
			"01",;								//Ordem
			"JHH_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;			  				//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHH_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHH",;								//Arquivo
			"02",;								//Ordem
			"JHH_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHH_CODEXT 
********************************************************************************************/
Aadd(aSX3,{	"JHH",;								//Arquivo
			"03",;								//Ordem
			"JHH_CODEXT",;						//Campo
			"C",;								//Tipo
			10,;					   			//Tamanho
			0,;									//Decimal
			"Cod.Externo",;		      			//Titulo
			"Cod.Externo",;		   				//Titulo SPA
			"Cod.Externo",;		      			//Titulo ENG
			"Aluno Externo",;					//Descricao
			"Aluno Externo",;					//Descricao SPA
			"Aluno Externo",; 		//Descricao ENG
			"@!",;					   			//Picture
			"GEExistcpo('JCR',M->JHH_CODEXT)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"J15",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHH_DESEXT
********************************************************************************************/
Aadd(aSX3,{	"JHH",;								//Arquivo
			"04",;								//Ordem
			"JHH_DESEXT",;						//Campo
			"C",;								//Tipo
			60,;					   			//Tamanho
			0,;									//Decimal
			"Nome Externo",;		    		//Titulo
			"Nome Externo",;		   			//Titulo SPA
			"Nome Externo",;		     		//Titulo ENG
			"Nome do Aluno Externo",;			//Descricao
			"Nome do Aluno Externo",;			//Descricao SPA
			"Nome do Aluno Externo",;			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('JCR',1,xFilial('JCR')+JHH->JHH_CODEXT,'JCR_NOME'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHI_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHI",;								//Arquivo
			"01",;								//Ordem
			"JHI_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;			  			 	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHI_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHI",;								//Arquivo
			"02",;								//Ordem
			"JHI_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHI_MATFUN 
********************************************************************************************/
Aadd(aSX3,{	"JHI",;								//Arquivo
			"03",;								//Ordem
			"JHI_MATFUN",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Mat.Func.",;		      			//Titulo
			"Mat.Func.",;		   				//Titulo SPA
			"Mat.Func.",;		      			//Titulo ENG
			"Matricula do Funcionario",;		//Descricao
			"Matricula do Funcionario",;		//Descricao SPA
			"Matricula do Funcionario",;		//Descricao ENG
			"@!",;					   			//Picture
			"GEExistcpo('SRA',M->JHI_MATFUN)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"SRA",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHI_NOMFUN
********************************************************************************************/
Aadd(aSX3,{	"JHI",;								//Arquivo
			"04",;								//Ordem
			"JHI_NOMFUN",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Nome Func.",;			    		//Titulo
			"Nome Func.",;			   			//Titulo SPA
			"Nome Func.",;			     		//Titulo ENG
			"Nome do Funcionario",;				//Descricao
			"Nome do Funcionario",;				//Descricao SPA
			"Nome do Funcionario",;				//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('SRA',1,xFilial('SRA')+JHI->JHI_MATFUN,'RA_NOME'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHJ_FILIAL
********************************************************************************************/
Aadd(aSX3,{	"JHJ",;								//Arquivo
			"01",;								//Ordem
			"JHJ_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;						    //Titulo
			"Filial",;			  			 	//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			"",;								//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			"",;								//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHJ_CODSEG
********************************************************************************************/
Aadd(aSX3,{	"JHJ",;								//Arquivo
			"02",;								//Ordem
			"JHJ_CODSEG",;						//Campo
			"C",;								//Tipo
			6,;						   			//Tamanho
			0,;									//Decimal
			"Codigo",;			      			//Titulo
			"Codigo",;			   				//Titulo SPA
			"Codigo",;			      			//Titulo ENG
			"Codigo do Segmento",;				//Descricao
			"Codigo do Segmento",;				//Descricao SPA
			"Codigo do Segmento",;	   			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cNaoUsado,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"N",;								//BROWSE
			"",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHJ_CODDIS 
********************************************************************************************/
Aadd(aSX3,{	"JHJ",;								//Arquivo
			"03",;								//Ordem
			"JHJ_CODDIS",;						//Campo
			"C",;								//Tipo
			15,;					   			//Tamanho
			0,;									//Decimal
			"Cod.Discip.",;		      			//Titulo
			"Cod.Discip.",;		   				//Titulo SPA
			"Cod.Discip.",;		      			//Titulo ENG
			"Codigo da Disciplina",;			//Descricao
			"Codigo da Disciplina",;			//Descricao SPA
			"Codigo da Disciplina",;			//Descricao ENG
			"@!",;					   			//Picture
			"GEExistcpo('JAE',M->JHJ_CODDIS)",;	//VALID
			cUsadoObrig,;						//USADO
			"",;								//RELACAO
			"JAE",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"S",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"A",;								//VISUAL
			"R",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME
/********************************************************************************************
JHJ_DESDIS
********************************************************************************************/
Aadd(aSX3,{	"JHJ",;								//Arquivo
			"04",;								//Ordem
			"JHJ_DESDIS",;						//Campo
			"C",;								//Tipo
			30,;					   			//Tamanho
			0,;									//Decimal
			"Desc.Discip.",;		    		//Titulo
			"Desc.Discip.",;		   			//Titulo SPA
			"Desc.Discip.",;		     		//Titulo ENG
			"Descricao da Disciplina",;			//Descricao
			"Descricao da Disciplinao",;		//Descricao SPA
			"Descricao da Disciplina",;			//Descricao ENG
			"@!",;					   			//Picture
			"",;								//VALID
			cUsadoObrig,;						//USADO
			"If(!Inclui,Posicione('JAE',1,xFilial('JAE')+JHJ->JHJ_CODDIS,'JAE_DESC'),'')",;//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservado,;						//RESERV
			"",;								//CHECK
			"",;								//TRIGGER
			"S",;								//PROPRI
			"S",;								//BROWSE
			"V",;								//VISUAL
			"V",;								//CONTEXT
			"",;								//OBRIGAT
			"",;								//VLDUSER
			"",;								//CBOX
			"",;								//CBOX SPA
			"",;								//CBOX ENG
			"",;								//PICTVAR
			"",;								//WHEN
			"",;								//INIBRW
			"",;								//SXG
			"",;								//FOLDER			
			"S"})								//PYME			
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
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Dados...") //
		Endif
	EndIf
Next i

SX3->(dbSetOrder(1))
SX3->(dbSeek( "J" ))
While SX3->( !eof() .and. Left( X3_ARQUIVO, 1) == "J" )
	If ( "EXISTCPO("$Upper(SX3->X3_VALID) ) .and. ( !"GEEXISTCPO("$Upper(SX3->X3_VALID) ) .and. (UPPER(AllTrim(SX3->X3_ARQUIVO)) != "JHD")
		RecLock("SX3", .f.)//alteração
		SX3->X3_VALID := StrTran( SX3->X3_VALID, "ExistCpo(", "GEExistCpo(" )
		SX3->( MsUnlock() )
	EndIf
	SX3->( dbSkip() )
End

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX7  ³ Autor ³Eduardo de Souza       ³ Data ³30/Nov/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
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
/*********************************************************************************************
JHD_CURSO
*********************************************************************************************/
aadd(aSX7,{	"JHD_CURSO",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JAF',6,xFilial('JAF')+'1'+M->JHD_CURSO,'JAF->JAF_DESC')",;//Regra
			"JHD_DESCUR",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao
/*********************************************************************************************
JHD_UNIDAD
*********************************************************************************************/
aadd(aSX7,{	"JHD_UNIDAD",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JA3',1,xFilial('JA3')+M->JHD_UNIDAD,'JA3->JA3_DESLOC')",;//Regra
			"JHD_DESUNI",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao			
/*********************************************************************************************
JHD_TURNO
*********************************************************************************************/
aadd(aSX7,{	"JHD_TURNO",;			 		//Campo
			"001",;							//Sequencia
			"Tabela('F5', M->JHD_TURNO, .F.)",;//Regra
			"JHD_DESTUR",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao			
/*********************************************************************************************
JHD_GRUPO
*********************************************************************************************/
aadd(aSX7,{	"JHD_GRUPO",;			 		//Campo
			"001",;							//Sequencia
			"Tabela('FC', M->JHD_GRUPO, .F.)",;//Regra
			"JHD_DESGRU",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao			
/*********************************************************************************************
JHD_AREA
*********************************************************************************************/
aadd(aSX7,{	"JHD_AREA",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JAG',1,xFilial('JAG')+M->JHD_AREA,'JAG->JAG_DESC')",;//Regra
			"JHD_DESARE",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao
/*********************************************************************************************
JHF_CODDEP
*********************************************************************************************/
aadd(aSX7,{	"JHF_CODDEP",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JBJ',1,xFilial('JBJ')+M->JHF_CODDEP,'JBJ->JBJ_DESC')",;//Regra
			"JHF_DESDEP",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao
/*********************************************************************************************
JHG_CODGRU
*********************************************************************************************/
aadd(aSX7,{	"JHG_CODGRU",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JAK',1,xFilial('JAK')+M->JHG_CODGRU,'JAK_DESC')",;//Regra
			"JHG_DESGRU",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao
/*********************************************************************************************
JHH_CODEXT
*********************************************************************************************/
aadd(aSX7,{	"JHH_CODEXT",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JCR',1,xFilial('JCR')+M->JHH_CODEXT,'JCR_NOME')",;//Regra
			"JHH_DESEXT",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao
/*********************************************************************************************
JHI_MATFUN
*********************************************************************************************/
aadd(aSX7,{	"JHI_MATFUN",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('SRA',1,xFilial('SRA')+M->JHI_MATFUN,'RA_NOME')",;//Regra
			"JHI_NOMFUN",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao
/*********************************************************************************************
JHJ_CODDIS
*********************************************************************************************/
aadd(aSX7,{	"JHJ_CODDIS",;			 		//Campo
			"001",;							//Sequencia
			"Posicione('JAE',1,xFilial('JAE')+M->JHJ_CODDIS,'JAE_DESC')",;//Regra
			"JHJ_DESDIS",;      			//Campo Dominio
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
		dbCommit()
		MsUnLock()
		IncProc("Atualizando Gatilhos...")
	EndIf
Next i

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSIX  ³ Autor ³Eduardo de Souza       ³ Data ³30/Nov/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX - Indices       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSIX()
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
/*********************************************************************************************
JHC_CODSEG
*********************************************************************************************/
aadd(aSIX,{"JHC",;   										//Indice
		"1",;                 								//Ordem
		"JHC_FILIAL+JHC_CODSEG",;  							//Chave
		"Codigo",;            								//Descicao Port.
		"Codigo",;											//Descicao Spa.
		"Codigo",;											//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
/*********************************************************************************************
JHC_DESSEG
*********************************************************************************************/
aadd(aSIX,{"JHC",;   										//Indice
		"2",;                 								//Ordem
		"JHC_FILIAL+JHC_DESSEG",;  							//Chave
		"Descricao",;            							//Descicao Port.
		"Descricao",;										//Descicao Spa.
		"Descricao",;										//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq		
/*********************************************************************************************
JHD_CODSEG + JHD_ITEM
*********************************************************************************************/
aadd(aSIX,{"JHD",;   										//Indice
		"1",;                 								//Ordem
		"JHD_FILIAL+JHD_CODSEG+JHD_ITEM",;					//Chave
		"Cod.Seg. + Item",;        							//Descicao Port.
		"Cod.Seg. + Item",;									//Descicao Spa.
		"Cod.Seg. + Item",;									//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
/*********************************************************************************************
JHN_CODSEG + JHN_CODGRU
*********************************************************************************************/
aadd(aSIX,{"JHN",;   										//Indice
		"1",;                 								//Ordem
		"JHN_FILIAL+JHN_CODSEG+JHN_CODGRU",;				//Chave
		"Cod.Segmento + Cod.Grupo",;   						//Descicao Port.
		"Cod.Segmento + Cod.Grupo",;						//Descicao Spa.
		"Cod.Segmento + Cod.Grupo",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHN_CODGRU + JHN_CODSEG
*********************************************************************************************/
aadd(aSIX,{"JHN",;   										//Indice
		"2",;                 								//Ordem
		"JHN_FILIAL+JHN_CODGRU+JHN_CODSEG",;				//Chave
		"Cod.Grupo + Cod.Segmento",;   						//Descicao Port.
		"Cod.Grupo + Cod.Segmento",;						//Descicao Spa.
		"Cod.Grupo + Cod.Segmento",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHE_CODSEG + JHE_CODUSU
*********************************************************************************************/
aadd(aSIX,{"JHE",;   										//Indice
		"1",;                 								//Ordem
		"JHE_FILIAL+JHE_CODSEG+JHE_CODUSU",;				//Chave
		"Cod.Segmento + Cod.Usuario",;						//Descicao Port.
		"Cod.Segmento + Cod.Usuario",;						//Descicao Spa.
		"Cod.Segmento + Cod.Usuario",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHE_CODUSU + JHE_CODSEG
*********************************************************************************************/
aadd(aSIX,{"JHE",;   										//Indice
		"2",;                 								//Ordem
		"JHE_FILIAL+JHE_CODUSU+JHE_CODSEG",;				//Chave
		"Cod.Usuario + Cod.Segmento",;   					//Descicao Port.
		"Cod.Usuario + Cod.Segmento",;						//Descicao Spa.
		"Cod.Usuario + Cod.Segmento",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHF_CODSEG + JHF_CODDEP
*********************************************************************************************/
aadd(aSIX,{"JHF",;   										//Indice
		"1",;                 								//Ordem
		"JHF_FILIAL+JHF_CODSEG+JHF_CODDEP",;				//Chave
		"Cod.Segmento + Cod.Depto",;						//Descicao Port.
		"Cod.Segmento + Cod.Depto",;						//Descicao Spa.
		"Cod.Segmento + Cod.Depto",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHG_CODSEG + JHG_CODGRU
*********************************************************************************************/
aadd(aSIX,{"JHG",;   										//Indice
		"1",;                 								//Ordem
		"JHG_FILIAL+JHG_CODSEG+JHG_CODGRU",;				//Chave
		"Cod.Segmento + Cod.Grupo",;						//Descicao Port.
		"Cod.Segmento + Cod.Grupo",;						//Descicao Spa.
		"Cod.Segmento + Cod.Grupo",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHH_CODSEG + JHH_CODEXT
*********************************************************************************************/
aadd(aSIX,{"JHH",;   										//Indice
		"1",;                 								//Ordem
		"JHH_FILIAL+JHH_CODSEG+JHH_CODEXT",;				//Chave
		"Cod.Segmento + Cod.Externo",;						//Descicao Port.
		"Cod.Segmento + Cod.Externo",;						//Descicao Spa.
		"Cod.Segmento + Cod.Externo",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHI_CODSEG + JHI_MATFUN
*********************************************************************************************/
aadd(aSIX,{"JHI",;   										//Indice
		"1",;                 								//Ordem
		"JHI_FILIAL+JHI_CODSEG+JHI_MATFUN",;				//Chave
		"Cod.Segmento + Mat.Func.",;						//Descicao Port.
		"Cod.Segmento + Mat.Func.",;						//Descicao Spa.
		"Cod.Segmento + Mat.Func.",;						//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq	
/*********************************************************************************************
JHJ_CODSEG + JHJ_CODDIS
*********************************************************************************************/
aadd(aSIX,{"JHJ",;   										//Indice
		"1",;                 								//Ordem
		"JHJ_FILIAL+JHJ_CODSEG+JHJ_CODDIS",;				//Chave
		"Cod.Segmento + Cod.Discip.",;						//Descicao Port.
		"Cod.Segmento + Cod.Discip.",;						//Descicao Spa.
		"Cod.Segmento + Cod.Discip.",;						//Descicao Eng.
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
			dbCommit()        
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSX6  ³ Autor ³Eduardo de Souza       ³ Data ³30/Nov/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para atualizacao de parametro de regra de visibili- ³±±
±±³          ³ dade (MV_ACVISIB)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GEAtuSX6( cCodFilial)
Local cTexto    := ''						//String para msg ao fim do processo
Local lSx6      := .F.                      //Verifica se houve atualizacao
Local aSx6      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SX6
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local cAlias    := ''						//Alias para tabelas

/*********************************************************************************************
Define estrutura do array
*********************************************************************************************/
aEstrut:= { "X6_Filial","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
			"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2", "X6_CONTEUD","X6_CONTSPA", "X6_CONTENG",;
			"X6_PROPRI", "X6_PYME"}

/*********************************************************************************************
Define os dados do parametro
*********************************************************************************************/
aadd(aSx6,{cCodFilial,;											//Filial
		"MV_ACVISIB",;											//Var
		"C",;                 									//Tipo
		"Regra Visibilidade onde 1=Ligado 2=Desligado",; 	//Descric
		"Regra Visibilidade onde 1=Ligado 2=Desligado",; 	//DscSpa
		"Regra Visibilidade onde 1=Ligado 2=Desligado",; 	//DscEng
		"Posicoes:1-Ativo 2-Curso 3-Unid. 4-Turno 5-Grupo",;	//Desc1
		"Posicoes:1-Ativo 2-Curso 3-Unid. 4-Turno 5-Grupo",;	//DscSpa1
		"Posicoes:1-Ativo 2-Curso 3-Unid. 4-Turno 5-Grupo",;	//DscEng1
		"6-Area",; 												//Desc2
		"6-Area",;												//DscSpa2
		"6-Area",;												//DscEng2
		"222222",;												//Conteud
		"222222",;												//ContSpa
		"222222",;												//ContEng
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
	cTexto += "parametros atualizados  : MV_ACVISIB" + Chr(13)
EndIf

Return cTexto

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
Local cTexto    := ''						//String para msg ao fim do processo
Local lSXB      := .F.                      //Verifica se houve atualizacao
Local aSXB      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SXB
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define estrutura do array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEstrut:= {"XB_ALIAS","XB_TIPO","XB_CONTEM"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os novos conteudos dos filtros das consultas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSXB,{'J03   ','6','#AcSXBFil("JAF","J03")'})
Aadd(aSXB,{'J05   ','6','#AcSXBFil("JAF","J05")'})
Aadd(aSXB,{'J07   ','6','#AcSXBFil("JA5","J07")'})
Aadd(aSXB,{'J08   ','6','#AcSXBFil("JBH","J08")'})
Aadd(aSXB,{'J09   ','6','#AcSXBFil("SRA","J09")'})
Aadd(aSXB,{'J0A   ','6','#AcSXBFil("JA3","J0A")'})
Aadd(aSXB,{'J11   ','6','#AcSXBFil("JA2","J11")'})
Aadd(aSXB,{'J12   ','6','#AcSXBFil("JAS","J12")'})
Aadd(aSXB,{'J13   ','6','#AcSXBFil("JAF","J13")'})
Aadd(aSXB,{'J14   ','6','#AcSXBFil("JBO","J14")'})
Aadd(aSXB,{'J15   ','6','#AcSXBFil("JCR","J15")'})
Aadd(aSXB,{'J16   ','6','#AcSXBFil("JAE","J16")'})
Aadd(aSXB,{'J16   ','6','#AcSXBFil("JAE","J16")'})
Aadd(aSXB,{'J1B   ','6','#AcSXBFil("JBE","J1B")'})
Aadd(aSXB,{'J1D   ','6','#AcSXBFil("JBQ","J1D")'})
Aadd(aSXB,{'J1E   ','6','#AcSXBFil("JC7","J1E")'})
Aadd(aSXB,{'J1F   ','6','#AcSXBFil("JAR","J1F")'})
Aadd(aSXB,{'J1G   ','6','#AcSXBFil("JBK","J1G")'})
Aadd(aSXB,{'J1H   ','6','#AcSXBFil("JBE","J1H")'})
Aadd(aSXB,{'J1I   ','6','#AcSXBFil("JBL","J1I")'})
Aadd(aSXB,{'J1J   ','6','#AcSXBFil("JBE","J1J")'})
Aadd(aSXB,{'J1L   ','6','#AcSXBFil("JDA","J1L")'})
Aadd(aSXB,{'J1N   ','6','#AcSXBFil("JDA","J1N")'})
Aadd(aSXB,{'J1O   ','6','#AcSXBFil("JAS","J1O")'})
Aadd(aSXB,{'J1P   ','6','#AcSXBFil("JDA","J1P")'})
Aadd(aSXB,{'J1Z   ','6','#AcSXBFil("JAY","J1Z")'})
Aadd(aSXB,{'J1Z   ','6','#AcSXBFil("JAY","J1Z")'}) 
Aadd(aSXB,{'J20   ','6','#AcSXBFil("JAF","J20")'}) 
Aadd(aSXB,{'J21   ','6','#AcSXBFil("JAR","J21")'}) 
Aadd(aSXB,{'J22   ','6','#AcSXBFil("JBE","J22")'}) 
Aadd(aSXB,{'J23   ','6','#AcSXBFil("JBE","J23")'}) 
Aadd(aSXB,{'J24   ','6','#AcSXBFil("JBK","J24")'})
Aadd(aSXB,{'J25   ','6','#AcSXBFil("JA3","J25")'})
Aadd(aSXB,{'J26   ','6','#AcSXBFil("JAH","J26")'})
Aadd(aSXB,{'J27   ','6','#AcSXBFil("JBK","J27")'})
Aadd(aSXB,{'J28   ','6','#AcSXBFil("JAH","J28")'})
Aadd(aSXB,{'J2B   ','6','#AcSXBFil("SRA","J2B")'})
Aadd(aSXB,{'J2C   ','6','#AcSXBFil("JBO","J2C")'})
Aadd(aSXB,{'J30   ','6','#AcSXBFil("JAS","J30")'})
Aadd(aSXB,{'J32   ','6','#AcSXBFil("JAE","J32")'})
Aadd(aSXB,{'J33   ','6','#AcSXBFil("JAS","J33")'})
Aadd(aSXB,{'J34   ','6','#AcSXBFil("JBE","J34")'})
Aadd(aSXB,{'J35   ','6','#AcSXBFil("JBE","J35")'})
Aadd(aSXB,{'J36   ','6','#AcSXBFil("JBE","J36")'})
Aadd(aSXB,{'J37   ','6','#AcSXBFil("JAF","J37")'})
Aadd(aSXB,{'J38   ','6','#AcSXBFil("JAH","J38")'})
Aadd(aSXB,{'J39   ','6','#AcSXBFil("JAH","J39")'})
Aadd(aSXB,{'J40   ','6','#AcSXBFil("JBE","J40")'})
Aadd(aSXB,{'J41   ','6','#AcSXBFil("JBQ","J41")'})
Aadd(aSXB,{'J42   ','6','#AcSXBFil("JAH","J42")'})
Aadd(aSXB,{'J43   ','6','#AcSXBFil("JBJ","J43")'})
Aadd(aSXB,{'J44   ','6','#AcSXBFil("JA3","J44")'})
Aadd(aSXB,{'J45   ','6','#AcSXBFil("JA3","J45")'})
Aadd(aSXB,{'J46   ','6','#AcSXBFil("JA4","J46")'})
Aadd(aSXB,{'J47   ','6','#AcSXBFil("JA5","J47")'})
Aadd(aSXB,{'J48   ','6','#AcSXBFil("JA5","J48")'})
Aadd(aSXB,{'J49   ','6','#AcSXBFil("JBE","J49")'})
Aadd(aSXB,{'J7B   ','6','#AcSXBFil("JAY","J7B")'})
Aadd(aSXB,{'JA2   ','6','#AcSXBFil("JA2","JA2")'})
Aadd(aSXB,{'JA3   ','6','#AcSXBFil("JA3","JA3")'})
Aadd(aSXB,{'JA4   ','6','#AcSXBFil("JA4","JA4")'})
Aadd(aSXB,{'JA5   ','6','#AcSXBFil("JA5","JA5")'})
Aadd(aSXB,{'JAC   ','6','#AcSXBFil("JAC","JAC")'})
Aadd(aSXB,{'JAE   ','6','#AcSXBFil("JAE","JAE")'})
Aadd(aSXB,{'JAF   ','6','#AcSXBFil("JAF","JAF")'})
Aadd(aSXB,{'JAG   ','6','#AcSXBFil("JAG","JAG")'})
Aadd(aSXB,{'JAH   ','6','#AcSXBFil("JAH","JAH")'})
Aadd(aSXB,{'JAK   ','6','#AcSXBFil("JAK","JAK")'})
Aadd(aSXB,{'JAN   ','6','#AcSXBFil("JA2","JAN")'})
Aadd(aSXB,{'JAR   ','6','#AcSXBFil("JA2","JAR")'})
Aadd(aSXB,{'JAS   ','6','#AcSXBFil("JA5","JAS")'})
Aadd(aSXB,{'JBD   ','6','#AcSXBFil("JBD","JBD")'})
Aadd(aSXB,{'JBH   ','6','#AcSXBFil("JBH","JBH")'})
Aadd(aSXB,{'JBJ   ','6','#AcSXBFil("JBJ","JBJ")'})
Aadd(aSXB,{'JBK   ','6','#AcSXBFil("JBK","JBK")'})
Aadd(aSXB,{'JBL   ','6','#AcSXBFil("JBL","JBL")'})
Aadd(aSXB,{'JBO   ','6','#AcSXBFil("JBO","JBO")'})
Aadd(aSXB,{'JBQ   ','6','#AcSXBFil("JBQ","JBQ")'})
Aadd(aSXB,{'JBW   ','6','#AcSXBFil("SRA","JBW")'})
Aadd(aSXB,{'JC8   ','6','#AcSXBFil("JC8","JC8")'})
Aadd(aSXB,{'JCS   ','6','#AcSXBFil("JBO","JCS")'})
Aadd(aSXB,{'JGD   ','6','#AcSXBFil("JAS","JGD")'})
Aadd(aSXB,{'JLB   ','6','#AcSXBFil("JBL","JLB")'})
Aadd(aSXB,{'JLC   ','6','#AcSXBFil("JBE","JLC")'})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa consultas para alteracao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aSXB))

dbSelectArea("SXB")
SXB->(dbSetOrder(1)) //XB_ALIAS+XB_TIPO+XB_SEQ	
For i := 1 To Len(aSXB)
	If !dbSeek(aSXB[i,1]+aSXB[i,2])
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
	dbCommit()
	MsUnLock()
	cTexto  += (aSXB[i][1]+Chr(13)+Chr(10))
	IncProc("Atualizando consulta padrao...")
Next i

If lSXB
	cTexto += "Consultas atualizadas com sucesso"
EndIf

Return(cTexto)

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