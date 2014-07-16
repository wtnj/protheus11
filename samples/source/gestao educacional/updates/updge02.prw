#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UpdGE02  ³ Autor ³ Rafael Rodrigues     ³ Data ³ 20/Dez/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de melhorias do projeto CMC                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaGE                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UpdGE02() //Para maiores detalhes sobre a utilizacao deste fonte leia o boletim

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
			
			
			GEAtuSIX()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Elimina do SX o que deve ser eliminado.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcRegua(9)
			IncProc("Analisando Dicionario de Arquivos...")
			GELimpaSX()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
				//Se jah existir o campo JIF_PARTIT na base, atualiza o tamanho do campo
				if aArqUpd[nx] == "JIF" .and. JIF->( FieldPos("JIF_PARTIT") ) > 0
					TcRefresh("JIF")
				endif
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
			Next nX

			//Utiliza o Select Area para forcar a criacao das tabelas
			dbSelectArea("JHO")
			dbSelectArea("JHP")
			dbSelectArea("JHQ")
			dbSelectArea("JF6")
			dbSelectArea("JF7")
			dbSelectArea("JI7")
			dbSelectArea("JC1")
			dbSelectArea("JA2")
			dbSelectArea("JIE")
			dbSelectArea("JIF")
			dbSelectArea("JIG")
			dbSelectArea("JIX")
			
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
aAdd(aSX2,{	"JF6",; 								//Chave
			cPath,;									//Path
			"JF6"+cNome,;							//Nome do Arquivo
			"Formas de pagamento (header)",;		//Nome Port
			"Formas de pagamento (header)",;		//Nome Port
			"Formas de pagamento (header)",;		//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JF6_FILIAL+JF6_CODFOR",;				//Unico
			"S"})									//Pyme
		
aAdd(aSX2,{	"JF7",; 								//Chave
			cPath,;									//Path
			"JF7"+cNome,;							//Nome do Arquivo
			"Formas de pagamento (itens)",;			//Nome Port
			"Formas de pagamento (itens)",;			//Nome Port
			"Formas de pagamento (itens)",;			//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JF7_FILIAL+JF7_CODFOR+JF7_PARCEL+JF7_ITEMPA",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JI7",; 								//Chave
			cPath,;									//Path
			"JI7"+cNome,;							//Nome do Arquivo
			"Servicos educacionais",;				//Nome Port
			"Servicos educacionais",;				//Nome Esp
			"Servicos educacionais",;				//Nome Ing
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JI7_FILIAL+JI7_CODSER",;				//Unico
			"S"})									//Pyme
		
aAdd(aSX2,{	"JHO",; 								//Chave
			cPath,;									//Path
			"JHO"+cNome,;							//Nome do Arquivo
			"Cadastro de familias",;				//Nome Port
			"Cadastro de familias",;				//Nome Port
			"Cadastro de familias",;				//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHO_FILIAL+JHO_CODFAM",;				//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JHP",; 								//Chave
			cPath,;									//Path
			"JHP"+cNome,;							//Nome do Arquivo
			"Membros das familias",;				//Nome Port
			"Membros das familias",;				//Nome Port
			"Membros das familias",;				//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHP_FILIAL+JHP_CODFAM+JHP_ITEM",;		//Unico
			"S"})									//Pyme
			
aAdd(aSX2,{	"JHQ",; 								//Chave
			cPath,;									//Path
			"JHQ"+cNome,;							//Nome do Arquivo
			"Veiculos das familias",;				//Nome Port
			"Veiculos das familias",;				//Nome Port
			"Veiculos das familias",;				//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JHQ_FILIAL+JHQ_CODFAM+JHQ_ITEM",;		//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JIE",; 								//Chave
			cPath,;									//Path
			"JIE"+cNome,;							//Nome do Arquivo
			"Planos de pagamentos",;				//Nome Port
			"Planos de pagamentos",;				//Nome Port
			"Planos de pagamentos",;				//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JIE_FILIAL+JIE_CODPLA",;				//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JIF",; 								//Chave
			cPath,;									//Path
			"JIF"+cNome,;							//Nome do Arquivo
			"Itens dos planos de pagamentos",;		//Nome Port
			"Itens dos planos de pagamentos",;		//Nome Port
			"Itens dos planos de pagamentos",;		//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JIF_FILIAL+JIF_CODPLA+JIF_CODSER+JIF_CHAVE+JIF_PARCEL+JIF_ITEMPA",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JIG",; 								//Chave
			cPath,;									//Path
			"JIG"+cNome,;							//Nome do Arquivo
			"Planos de pagamentos x servicos",;		//Nome Port
			"Planos de pagamentos x servicos",;		//Nome Port
			"Planos de pagamentos x servicos",;		//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JIG_FILIAL+JIG_CODPLA+JIG_ITEM+JIG_CODCUR+JIG_PERLET+JIG_HABILI+JIG_CODSER+JIG_CHAVE",;	//Unico
			"S"})									//Pyme

aAdd(aSX2,{	"JIX",; 								//Chave
			cPath,;									//Path
			"JIX"+cNome,;							//Nome do Arquivo
			"Cursos x Formas de pagamento",;		//Nome Port
			"Cursos x Formas de pagamento",;		//Nome Port
			"Cursos x Formas de pagamento",;		//Nome Port
			0,;										//Delete
			"C",;									//Modo - (C)Compartilhado ou (E)Exclusivo
			"",;									//TTS
			"",;									//Rotina
			"JIX_FILIAL+JIX_CODCUR+JIX_PERLET+JIX_HABILI+JIX_CODFOR",;	//Unico
			"S"})									//Pyme

/*******************************************************************************************
Realiza a inclusao das tabelas
*******************************************/
For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If SX2->( !dbSeek(aSX2[i,1]) )
			RecLock("SX2",.T.) //Adiciona registro
		Else
			RecLock("SX2",.F.) //Altera registro
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

Return cTexto

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
±±³Icaro Queiroz³01/09/06³------³Tratamento para verificar qual eh a ultima±±
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
Local lAtu 			 := .F.
Local nPos			 := 0				//Variavel que usado como auxilio na criacao da proxima ordem
Local cParVisib		 := GetNewPar("MV_ACVISIB", "999999") // Verifica se a regra de visibilidade foi aplicada
Local nTam			 := 0
Local cGRPSXG		 := ""

/*******************************************************************************************
Define a estrutura do array
*******************************************/
aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
			"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
			"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
			"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))//X3_CAMPO

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

SX3->(DbSetOrder(1)) //X3_ARQUIVO+X3_ORDEM

/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************/

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JC4" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JC4" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
aAdd(aSX3,{ "JC4",;								//Arquivo
    		StrZero(nPos, 2),;					//Ordem
			"JC4_RETROA",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Retroativo",;						//Titulo
			"Retroativo",;						//Titulo SPA
			"Retroativo",;			    		//Titulo ENG
			"Bolsa e retroativa?",;				//Descricao
			"Bolsa e retroativa?",;				//Descricao SPA
			"Bolsa e retroativa?",;				//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;					//VALID
			cUsadoOpc,;							//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","S","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","","",;				//CBOX, CBOX SPA, CBOX ENG
		   	"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME */

nPos++
aAdd(aSX3,{	"JC4",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC4_PARCEL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Parcela de",;						//Titulo
			"Parcela de",;						//Titulo SPA
			"Parcela de",;			    		//Titulo ENG
			"Parcela de Retroatividade",;		//Descricao
			"Parcela de Retroatividade",;		//Descricao SPA
			"Parcela de Retroatividade",;		//Descricao ENG
			"99",;								//Picture
			"",;		              			//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			0,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;	             			//CBOX, CBOX SPA, CBOX ENG
			"","M->JC4_RETROA == '1'","","","",""}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 

nPos++
aAdd(aSX3,{	"JC4",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC4_VALEDC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Vale Descont",;					//Titulo
			"Vale Descont",;					//Titulo SPA
			"Vale Descont",;			    	//Titulo ENG
			"Vale desconto para a bolsa",;		//Descricao
			"Vale desconto para a bolsa",;		//Descricao SPA
			"Vale desconto para a bolsa",;		//Descricao ENG
			"@!",;								//Picture
			"",;		              			//VALID
			cUsadoOpc,;							//USADO
			"'2'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","U","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","",'Pertence("12")',;			//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","","",;	   			//CBOX, CBOX SPA, CBOX ENG
			"","","","","",""}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JC5" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JC5" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
aAdd(aSX3,{	"JC5",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC5_CONCEC",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Concessao",;						//Titulo
			"Concessao",;						//Titulo SPA
			"Concessao",;			    		//Titulo ENG
			"Concessao",;						//Descricao
			"Concessao",;						//Descricao SPA
			"Concessao",;						//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;	       			//VALID
			cUsadoOpc,;							//USADO
			"'1'",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;	                		//CONTEXT, OBRIGAT, VLDUSER
			"1=Ok;2=Atrasada","","",;	   		//CBOX, CBOX SPA, CBOX ENG
			"","","","","",""}) 				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 			

aAdd(aSX3,{	"JA2",;								//Arquivo
			"02",;								//Ordem
			"JA2_CODFAM",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Familia",;						    //Titulo
			"Familia",;						   	//Titulo SPA
			"Familia",;			    			//Titulo ENG
			"Familia",;							//Descricao
			"Familia",;							//Descricao SPA
			"Familia",;							//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999','GEExistCpo("JHO",M->JA2_CODFAM,1).and.ACA240Mem(.T.)','ExistCpo("JHO",M->JA2_CODFAM,1).and.ACA240Mem(.T.)'),;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JHO",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
			"03",;								//Ordem
			"JA2_CODMEM",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Cod.Membro",;					    //Titulo
			"Cod.Membro",;					   	//Titulo SPA
			"Cod.Membro",;		    			//Titulo ENG
			"Cod.Membro",;						//Descricao
			"Cod.Membro",;						//Descricao SPA
			"Cod.Membro",;						//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JHP",M->JA2_CODFAM+M->JA2_CODMEM,1).and.ACA240Mem(.T.)','ExistCpo("JHP",M->JA2_CODFAM+M->JA2_CODMEM,1).and.ACA240Mem(.T.)'),;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JHP",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","S","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF6",;								//Arquivo
			"01",;								//Ordem
			"JF6_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					  	  	//Titulo
			"Filial",;					   		//Titulo SPA
			"Filial",;		    		   		//Titulo ENG
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
			    
aAdd(aSX3,{	"JF6",;								//Arquivo
			"02",;								//Ordem
			"JF6_CODFOR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Codigo",;					    	//Titulo
			"Codigo",;					   		//Titulo SPA
			"Codigo",;		    				//Titulo ENG
			"Codigo",;							//Descricao
			"Codigo",;							//Descricao SPA
			"Codigo",;							//Descricao ENG
			"@!",;								//Picture
			'ExistChav("JF6",M->JF6_CODFOR) .and. FreeForUse("JF6",M->JF6_CODFOR)',;	//VALID
			cUsadoKey,;							//USADO
			'GetSXENum("JF6","JF6_CODFOR")',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
    
aAdd(aSX3,{	"JF6",;								//Arquivo
			"03",;								//Ordem
			"JF6_DESFOR",;						//Campo
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
			
aAdd(aSX3,{	"JF6",;								//Arquivo
			"04",;								//Ordem
			"JF6_CODSER",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Servico",;					    	//Titulo
			"Servico",;					   		//Titulo SPA
			"Servico",;		    				//Titulo ENG
			"Servico",;							//Descricao
			"Servico",;							//Descricao SPA
			"Servico",;							//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JI7",M->JF6_CODSER,1)','ExistCpo("JI7",M->JF6_CODSER,1)'),; 	//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"JI7",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	

aAdd(aSX3,{	"JF6",;								//Arquivo
			"05",;								//Ordem
			"JF6_DESSER",;						//Campo
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
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'if(Inclui,"",Posicione("JI7",1,xFilial("JI7")+M->JF6_CODSER,"JI7_DESSER"))',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JF6",;								//Arquivo
			"06",;								//Ordem
			"JF6_VALTOT",;						//Campo
			"N",;								//Tipo
			12,;								//Tamanho
			2,;									//Decimal
			"Valor Total",;					    //Titulo
			"Valor Total",;					   	//Titulo SPA
			"Valor Total",;		    			//Titulo ENG
			"Valor Total",;						//Descricao
			"Valor Total",;						//Descricao SPA
			"Valor Total",;						//Descricao ENG
			"@E 999,999,999.99",;				//Picture
			"AC585Valor()",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	 

aAdd(aSX3,{	"JF6",;								//Arquivo
			"07",;								//Ordem
			"JF6_PARMAX",;						//Campo
			"N",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Parcel.Maxim",;				    //Titulo
			"Parcel.Maxim",;				   	//Titulo SPA
			"Parcel.Maxim",;		    		//Titulo ENG
			"Parcel.Maxim",;					//Descricao
			"Parcel.Maxim",;					//Descricao SPA
			"Parcel.Maxim",;					//Descricao ENG
			"@E 999",;							//Picture
			"Positivo()",;						//VALID
			cUsadoOpc,;							//USADO
			"1",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JF6",;								//Arquivo
			"08",;								//Ordem
			"JF6_PERCOB",;						//Campo
			"N",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Per.Cobrados",;				    //Titulo
			"Per.Cobrados",;				   	//Titulo SPA
			"Per.Cobrados",;		    		//Titulo ENG
			"Per.Cobrados",;					//Descricao
			"Per.Cobrados",;					//Descricao SPA
			"Per.Cobrados",;					//Descricao ENG
			"@E 99",;							//Picture
			"Entre(1,999)",;					//VALID
			cUsadoOpc,;							//USADO
			"1",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	   
			
aAdd(aSX3,{	"JF6",;								//Arquivo
			"09",;								//Ordem
			"JF6_COBMAT",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Cobr. Matr.",;					    //Titulo
			"Cobr. Matr.",;					   	//Titulo SPA
			"Cobr. Matr.",;		    			//Titulo ENG
			"Cobr. Matr.",;						//Descricao
			"Cobr. Matr.",;						//Descricao SPA
			"Cobr. Matr.",;						//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;					//VALID
			cUsadoOpc,;							//USADO
			'"1"',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;		//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME										

aAdd(aSX3,{	"JF6",;								//Arquivo
			"10",;								//Ordem
			"JF6_PERDES",;						//Campo
			"N",;								//Tipo
			6,;									//Tamanho
			2,;									//Decimal
			"% Desconto",;					    //Titulo
			"% Desconto",;					   	//Titulo SPA
			"% Desconto",;		    			//Titulo ENG
			"% Desconto",;						//Descricao
			"% Desconto",;						//Descricao SPA
			"% Desconto",;						//Descricao ENG
			"@E 999.99",;						//Picture
			"Entre(0,100)",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF6",;								//Arquivo
			"11",;								//Ordem
			"JF6_PERACR",;						//Campo
			"N",;								//Tipo
			6,;									//Tamanho
			2,;									//Decimal
			"% Acrescimo",;					    //Titulo
			"% Acrescimo",;					   	//Titulo SPA
			"% Acrescimo",;		    			//Titulo ENG
			"% Acrescimo",;						//Descricao
			"% Acrescimo",;						//Descricao SPA
			"% Acrescimo",;						//Descricao ENG
			"@E 999.99",;						//Picture
			"Entre(0,999.99)",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JF6",;								//Arquivo
			"12",;								//Ordem
			"JF6_STATUS",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Status",;					    	//Titulo
			"Status",;					   		//Titulo SPA
			"Status",;		    				//Titulo ENG
			"Status",;					   		//Descricao
			"Status",;					   		//Descricao SPA
			"Status",;							//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;					//VALID
			cUsadoOpc,;							//USADO
			'"1"',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Disponivel;2=Indisponivel","1=Disponivel;2=Indisponivel","1=Disponivel;2=Indisponivel",;		//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JF6",;								//Arquivo
			"13",;								//Ordem
			"JF6_MEMO1",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Observacao",;					    //Titulo
			"Observacao",;					   	//Titulo SPA
			"Observacao",;		    			//Titulo ENG
			"Observacao",;						//Descricao
			"Observacao",;						//Descricao SPA
			"Observacao",;						//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF6",;								//Arquivo
			"14",;								//Ordem
			"JF6_OBS",;							//Campo
			"M",;								//Tipo
			80,;								//Tamanho
			0,;									//Decimal
			"Observacao",;					    //Titulo
			"Observacao",;					   	//Titulo SPA
			"Observacao",;		    			//Titulo ENG
			"Observacao",;						//Descricao
			"Observacao",;						//Descricao SPA
			"Observacao",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'if(Inclui,"",MSMM(JF6->JF6_MEMO1))',;		//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JF6" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JF6" )
	nPos++
	SX3->( dbSkip() )
Enddo  

nPos++
if nPos < 15
	nPos := 15
endif

aAdd(aSX3,{	"JF6",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF6_MATPAG",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Matr.Pagto",;					    //Titulo
			"Matr.Pagto",;					   	//Titulo SPA
			"Matr.Pagto",;		    			//Titulo ENG
			"Matricula Vinc. a Pagto ?",;   	//Descricao
			"Matricula Vinc. a Pagto ?",;		//Descricao SPA
			"Matricula Vinc. a Pagto ?",;		//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;					//VALID
			cUsadoOpc,;							//USADO
			'"2"',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","","",;				//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    'M->JF6_COBMAT == "1"'

nPos++
aAdd(aSX3,{	"JF6",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF6_BANCO ",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Banco",;					    //Titulo
			"Banco",;					   	//Titulo SPA
			"Banco",;		    			//Titulo ENG
			"Codigo do Banco",;   	//Descricao
			"Codigo do Banco",;		//Descricao SPA
			"Codigo do Banco",;		//Descricao ENG
			"@!",;								//Picture
			'ExistCpo("SA6",M->JF6_BANCO)',;   //VALID
			cUsadoObr,;							//USADO
			'',;								//RELACAO
			"SA6",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;				//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 

nPos++
aAdd(aSX3,{	"JF6",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF6_AGENCI ",;						//Campo
			"C",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Agencia",;					    //Titulo
			"Agencia",;					   	//Titulo SPA
			"Agencia",;		    			//Titulo ENG
			"Codigo da Agencia",;   	//Descricao
			"Codigo da Agencia",;		//Descricao SPA
			"Codigo do Agencia",;		//Descricao ENG
			"@!",;								//Picture
			'',;   //VALID
			cUsadoObr,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;				//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
nPos++
aAdd(aSX3,{	"JF6",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF6_CONTA ",;						//Campo
			"C",;								//Tipo
			10,;									//Tamanho
			0,;									//Decimal
			"Conta",;					    //Titulo
			"Conta",;					   	//Titulo SPA
			"Conta",;		    			//Titulo ENG
			"Numero da Conta",;   	//Descricao
			"Numero da Conta",;		//Descricao SPA
			"Numero da Conta",;		//Descricao ENG
			"@!",;								//Picture
			'',;   //VALID
			cUsadoObr,;							//USADO
			'',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;				//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 			

aAdd(aSX3,{	"JHP",;								//Arquivo
			"01",;								//Ordem
			"JHP_FILIAL",;						//Campo
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
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"02",;								//Ordem
			"JHP_CODFAM",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Familia",;						    //Titulo
			"Familia",;						   	//Titulo SPA
			"Familia",;			    			//Titulo ENG
			"Familia",;							//Descricao
			"Familia",;							//Descricao SPA
			"Familia",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"03",;								//Ordem
			"JHP_ITEM",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item",;						    //Titulo
			"Item",;						   	//Titulo SPA
			"Item",;			    			//Titulo ENG
			"Item",;							//Descricao
			"Item",;							//Descricao SPA
			"Item",;							//Descricao ENG
			"999",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","S","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


aAdd(aSX3,{	"JHP",;								//Arquivo
			"04",;								//Ordem
			"JHP_NOMMEM",;						//Campo
			"C",;								//Tipo
			60,;								//Tamanho
			0,;									//Decimal
			"Nome",;						    //Titulo
			"Nome",;						   	//Titulo SPA
			"Nome",;			    			//Titulo ENG
			"Nome",;							//Descricao
			"Nome",;							//Descricao SPA
			"Nome",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"05",;								//Ordem
			"JHP_ITPAI",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item pai",;						//Titulo
			"Item pai",;					  	//Titulo SPA
			"Item pai",;			    		//Titulo ENG
			"Item pai",;						//Descricao
			"Item pai",;						//Descricao SPA
			"Item pai",;						//Descricao ENG
			"999",;								//Picture
			"Vazio() .or. AC905Pais()",;		//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"06",;								//Ordem
			"JHP_ITMAE",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item mae",;					   //Titulo
			"Item mae",;					  	//Titulo SPA
			"Item mae",;			    		//Titulo ENG
			"Item mae",;						//Descricao
			"Item mae",;						//Descricao SPA
			"Item mae",;						//Descricao ENG
			"999",;								//Picture
			"Vazio() .or. AC905Pais()",;		//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"07",;								//Ordem
			"JHP_EMAIL",;						//Campo
			"C",;								//Tipo
			40,;								//Tamanho
			0,;									//Decimal
			"E-mail",;						    //Titulo
			"E-mail",;						   	//Titulo SPA
			"E-mail",;			    			//Titulo ENG
			"E-mail",;							//Descricao
			"E-mail",;							//Descricao SPA
			"E-mail",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"08",;								//Ordem
			"JHP_RG",;							//Campo
			"C",;								//Tipo
			10,;								//Tamanho
			0,;									//Decimal
			"RG",;							    //Titulo
			"RG",;							   	//Titulo SPA
			"RG",;				    			//Titulo ENG
			"RG",;								//Descricao
			"RG",;								//Descricao SPA
			"RG",;								//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"09",; 								//Ordem
			"JHP_CPF",;							//Campo
			"C",;								//Tipo
			14,;								//Tamanho
			0,;									//Decimal
			"CPF",;							    //Titulo
			"CPF",;							   	//Titulo SPA
			"CPF",;				    			//Titulo ENG
			"CPF",;								//Descricao
			"CPF",;								//Descricao SPA
			"CPF",;								//Descricao ENG
			"",;								//Picture
			"CGC()",;							//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"10",;								//Ordem
			"JHP_DTNASC",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Dt.Nasc",;						    //Titulo
			"Dt.Nasc",;						   	//Titulo SPA
			"Dt.Nasc",;			    			//Titulo ENG
			"Dt.Nasc",;							//Descricao
			"Dt.Nasc",;							//Descricao SPA
			"Dt.Nasc",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"11",;								//Ordem
			"JHP_CEP",;							//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"CEP",;							    //Titulo
			"CEP",;							   	//Titulo SPA
			"CEP",;				    			//Titulo ENG
			"CEP",;								//Descricao
			"CEP",;								//Descricao SPA
			"CEP",;								//Descricao ENG
			"@R 99999-999",;					//Picture
			"Cep(M->JHP_CEP)",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JC2",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","S","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"12",;								//Ordem
			"JHP_END",;							//Campo
			"C",;								//Tipo
			40,;								//Tamanho
			0,;									//Decimal
			"Endereco",;					    //Titulo
			"Endereco",;					   	//Titulo SPA
			"Endereco",;		    			//Titulo ENG
			"Endereco",;						//Descricao
			"Endereco",;						//Descricao SPA
			"Endereco",;						//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"13",;								//Ordem
			"JHP_NUMEND",;						//Campo
			"C",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Numero",;						    //Titulo
			"Numero",;						   	//Titulo SPA
			"Numero",;			    			//Titulo ENG
			"Numero",;							//Descricao
			"Numero",;							//Descricao SPA
			"Numero",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"14",;								//Ordem
			"JHP_COMPLE",;						//Campo
			"C",;								//Tipo
			50,;								//Tamanho
			0,;									//Decimal
			"Complemento",;					    //Titulo
			"Complemento",;					   	//Titulo SPA
			"Complemento",;		    			//Titulo ENG
			"Complemento",;						//Descricao
			"Complemento",;						//Descricao SPA
			"Complemento",;						//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"15",;								//Ordem
			"JHP_BAIRRO",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Bairro",;			  			    //Titulo
			"Bairro",;						   	//Titulo SPA
			"Bairro",;		    				//Titulo ENG
			"Bairro",;							//Descricao
			"Bairro",;							//Descricao SPA
			"Bairro",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"16",;								//Ordem
			"JHP_CIDADE",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Cidade",;					    	//Titulo
			"Cidade",;					   		//Titulo SPA
			"Cidade",;		    				//Titulo ENG
			"Cidade",;							//Descricao
			"Cidade",;							//Descricao SPA
			"Cidade",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"17",;								//Ordem
			"JHP_EST",;							//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Estado",;					    	//Titulo
			"Estado",;					   		//Titulo SPA
			"Estado",;		    				//Titulo ENG
			"Estado",;							//Descricao
			"Estado",;							//Descricao SPA
			"Estado",;							//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("SX5","12"+M->JHP_EST)', 'ExistCpo("SX5","12"+M->JHP_EST)'),;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"12",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"18",;								//Ordem
			"JHP_CLIENT",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cliente",;					    	//Titulo
			"Cliente",;					   		//Titulo SPA
			"Cliente",;		    				//Titulo ENG
			"Cliente",;							//Descricao
			"Cliente",;							//Descricao SPA
			"Cliente",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"SA1",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHP",;								//Arquivo
			"19",;								//Ordem
			"JHP_LOJA",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Loja",;					    	//Titulo
			"Loja",;					   		//Titulo SPA
			"Loja",;		    				//Titulo ENG
			"Loja",;							//Descricao
			"Loja",;							//Descricao SPA
			"Loja",;							//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JC1" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JC1" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_DTNASC",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Dt.Nasc.",;					    //Titulo
			"Dt.Nasc.",;					    //Titulo
			"Dt.Nasc.",;					    //Titulo
			"Dt.Nasc.",;					    //Titulo
			"Dt.Nasc.",;					    //Titulo
			"Dt.Nasc.",;					    //Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_CEP",;							//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"CEP",;					    		//Titulo
			"CEP",;					    		//Titulo
			"CEP",;					    		//Titulo
			"CEP",;					    		//Titulo
			"CEP",;					    		//Titulo
			"CEP",;					    		//Titulo
			"@R 99999-999",;					//Picture
			'Cep(M->JC1_CEP)',;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JC2",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_END",;							//Campo
			"C",;								//Tipo
			40,;								//Tamanho
			0,;									//Decimal
			"Endereco",;					    //Titulo
			"Endereco",;					    //Titulo
			"Endereco",;					    //Titulo
			"Endereco",;					    //Titulo
			"Endereco",;					    //Titulo
			"Endereco",;					    //Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;			   		//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_NUMEND",;						//Campo
			"C",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Numero",;					    	//Titulo
			"Numero",;					    	//Titulo
			"Numero",;					    	//Titulo
			"Numero",;					    	//Titulo
			"Numero",;					    	//Titulo
			"Numero",;					    	//Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
 
nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_COMPLE",;						//Campo
			"C",;								//Tipo
			50,;								//Tamanho
			0,;									//Decimal
			"Complemento",;					    //Titulo
			"Complemento",;					    //Titulo
			"Complemento",;					    //Titulo
			"Complemento",;					    //Titulo
			"Complemento",;					    //Titulo
			"Complemento",;					    //Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;			   		//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_BAIRRO",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Bairro",;					    	//Titulo
			"Bairro",;					    	//Titulo
			"Bairro",;					    	//Titulo
			"Bairro",;					    	//Titulo
			"Bairro",;					    	//Titulo
			"Bairro",;					    	//Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;			   		//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_CIDADE",;						//Campo
			"C",;								//Tipo
			20,;								//Tamanho
			0,;									//Decimal
			"Cidade",;					    	//Titulo
			"Cidade",;					    	//Titulo
			"Cidade",;					    	//Titulo
			"Cidade",;					    	//Titulo
			"Cidade",;					    	//Titulo
			"Cidade",;					    	//Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_EST",;					   		//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Estado",;					    	//Titulo
			"Estado",;					    	//Titulo
			"Estado",;					    	//Titulo
			"Estado",;					    	//Titulo
			"Estado",;					    	//Titulo
			"Estado",;					    	//Titulo
			"12",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("SX5","12"+M->JC1_EST)', 'ExistCpo("SX5","12"+M->JC1_EST)'),;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_CLIENT",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cliente",;					 	   	//Titulo
			"Cliente",;					   		//Titulo
			"Cliente",;					  	  	//Titulo
			"Cliente",;					  	  	//Titulo
			"Cliente",;					    	//Titulo
			"Cliente",;					    	//Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_LOJA",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Loja",;					    	//Titulo
			"Loja",;					    	//Titulo
			"Loja",;					    	//Titulo
			"Loja",;					    	//Titulo
			"Loja",;					    	//Titulo
			"Loja",;					    	//Titulo
			"",;								//Picture
			'',;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","V",;			   		//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_PERREQ",;						//Campo
			"N",;								//Tipo
			6,;									//Tamanho
			2,;									//Decimal
			"% s/ Requer.",;				    //Titulo
			"% s/ Requer.",;				    //Titulo
			"% s/ Requer.",;				    //Titulo
			"% s/ Requer.",;				    //Titulo
			"% s/ Requer.",;				    //Titulo
			"% s/ Requer.",;				    //Titulo
			"@E 999.99",;						//Picture
			'',;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JC1",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JC1_CODMEM",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Cod.Membro",;					    //Titulo
			"Cod.Membro",;					   	//Titulo SPA
			"Cod.Membro",;		    			//Titulo ENG
			"Cod.Membro",;						//Descricao
			"Cod.Membro",;						//Descricao SPA
			"Cod.Membro",;						//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JHP",M->JA2_CODFAM+M->JC1_CODMEM,1)', 'ExistCpo("JHP",M->JA2_CODFAM+M->JC1_CODMEM,1)'),;		//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JHP",;								//F3
			1,;									//NIVEL
			cReservOpc,;		   				//RESERV
			"","S","S","N","V",;				//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI7",;								//Arquivo
			"01",;								//Ordem
			"JI7_FILIAL",;						//Campo
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
			
aAdd(aSX3,{	"JI7",;								//Arquivo
			"02",;								//Ordem
			"JI7_CODSER",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Codigo",;					    	//Titulo
			"Codigo",;					   		//Titulo SPA
			"Codigo",;		    				//Titulo ENG
			"Codigo",;							//Descricao
			"Codigo",;							//Descricao SPA
			"Codigo",;							//Descricao ENG
			"@!",;								//Picture
			'ExistChav("JI7",M->JI7_CODSER) .and. FreeForUse("JI7",M->JI7_CODSER) .and. AC645VlCod(M->JI7_CODSER)',;	//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


aAdd(aSX3,{	"JI7",;								//Arquivo
			"03",;								//Ordem
			"JI7_DESSER",;						//Campo
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
			
aAdd(aSX3,{	"JI7",;								//Arquivo
			"04",;								//Ordem
			"JI7_TIPO",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo",;					    	//Titulo
			"Tipo",;					   		//Titulo SPA
			"Tipo",;		    				//Titulo ENG
			"Tipo",;							//Descricao
			"Tipo",;							//Descricao SPA
			"Tipo",;							//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;								//VALID
			cUsadoOpc,;							//USADO
			'"1"',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Automatico;2=Manual","1=Automatico;2=Manual","1=Automatico;2=Manual",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME    
			
aAdd(aSX3,{	"JI7",;								//Arquivo
			"05",;								//Ordem
			"JI7_PREFIX",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Prefixo",;					    	//Titulo
			"Prefixo",;					   		//Titulo SPA
			"Prefixo",;		    				//Titulo ENG
			"Prefixo",;							//Descricao
			"Prefixo",;							//Descricao SPA
			"Prefixo",;							//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","M->JI7_CODSER > '499'","","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI7",;								//Arquivo
			"06",;								//Ordem
			"JI7_NATURE",;						//Campo
			"C",;								//Tipo
			10,;								//Tamanho
			0,;									//Decimal
			"Natureza",;					    //Titulo
			"Natureza",;					   	//Titulo SPA
			"Natureza",;		    			//Titulo ENG
			"Natureza",;						//Descricao
			"Natureza",;						//Descricao SPA
			"Natureza",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"SED",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","S","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","M->JI7_CODSER > '499'","","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JI7",;								//Arquivo
			"07",;								//Ordem
			"JI7_DNATUR",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc.Natur",;					    //Titulo
			"Desc.Natur",;					   	//Titulo SPA
			"Desc.Natur",;		    			//Titulo ENG
			"Desc.Natur",;						//Descricao
			"Desc.Natur",;						//Descricao SPA
			"Desc.Natur",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'if(inclui.or.Empty(JI7->JI7_NATURE),"",Posicione("SED",1,xFilial("SED")+JI7->JI7_NATURE,"ED_DESCRIC"))',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","",'Posicione("SED",1,xFilial("JED")+M->JI7_NATURE,"ED_DESCRIC")',"","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JI7" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JI7" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++
if nPos < 8
	nPos := 8
endif

aAdd(aSX3,{	"JI7",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JI7_AGLUTI",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Aglutina",;					    	//Titulo
			"Aglutina",;					   		//Titulo SPA
			"Aglutina",;		    				//Titulo ENG
			"Aglutina",;							//Descricao
			"Aglutina",;							//Descricao SPA
			"Aglutina",;							//Descricao ENG
			"@!",;								//Picture
			'Pertence("12")',;					//VALID
			cUsadoOpc,;							//USADO
			"'2'",;                     		//RELACAO '"1"'
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","","",;				//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"01",;								//Ordem
			"JIX_FILIAL",;						//Campo
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
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"02",;								//Ordem
			"JIX_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Curso Vig.",;						//Titulo
			"Curso Vig.",;						//Titulo SPA
			"Curso Vig.",;			    		//Titulo ENG
			"Curso Vig.",;						//Descricao
			"Curso Vig.",;						//Descricao SPA
			"Curso Vig.",;						//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JAH", M->JIX_CODCUR,1)', 'ExistCpo("JAH", M->JIX_CODCUR,1)'),;	//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"JAH",;								//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"03",;								//Ordem
			"JIX_PERLET",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo SPA
			"Per.Letivo",;			    		//Titulo ENG
			"Per.Letivo",;						//Descricao
			"Per.Letivo",;						//Descricao SPA
			"Per.Letivo",;						//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JAR", GDFieldGet("JIX_CODCUR")+M->JIX_PERLET,1)', 'ExistCpo("JAR", GDFieldGet("JIX_CODCUR")+M->JIX_PERLET,1)'),;	//VALID
			cUsadoObr,;							//USADO
			"",;								//RELACAO
			"JAR001",;							//F3
			1,;									//NIVEL
			cReservObr,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JIX",;								//Arquivo
			"04",;								//Ordem
			"JIX_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo SPA
			"Habilitacao",;			    		//Titulo ENG
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao SPA
			"Habilitacao",;						//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JAR", GDFieldGet("JIX_CODCUR")+GDFieldGet("JIX_PERLET")+M->JIX_HABILI,1)','ExistCpo("JAR", GDFieldGet("JIX_CODCUR")+GDFieldGet("JIX_PERLET")+M->JIX_HABILI,1)'),;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JAR002",;							//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"05",;								//Ordem
			"JIX_DHABIL",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Desc.Habili.",;					//Titulo
			"Desc.Habili.",;					//Titulo SPA
			"Desc.Habili.",;		    		//Titulo ENG
			"Desc.Habili.",;					//Descricao
			"Desc.Habili.",;					//Descricao SPA
			"Desc.Habili.",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"06",;								//Ordem
			"JIX_VALOR",;						//Campo
			"N",;								//Tipo
			14,;								//Tamanho
			2,;									//Decimal
			"Valor",;							//Titulo
			"Valor",;							//Titulo SPA
			"Valor",;				    		//Titulo ENG
			"Valor",;							//Descricao
			"Valor",;							//Descricao SPA
			"Valor",; 							//Descricao ENG
			"@E 999,999,999.99",;				//Picture
			"Positivo()",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"07",;								//Ordem
			"JIX_FORPAD",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Forma padrao?",;					//Titulo
			"Forma padrao?",;					//Titulo SPA
			"Forma padrao?",;			    	//Titulo ENG
			"Forma padrao?",;					//Descricao
			"Forma padrao?",;					//Descricao SPA
			"Forma padrao?",;					//Descricao ENG
			"",;								//Picture
			'Pertence("12")',;					//VALID
			cUsadoOpc,;							//USADO
			'"2"',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIX",;								//Arquivo
			"08",;								//Ordem
			"JIX_CODFOR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Forma pagamento",;					//Titulo
			"Forma pagamento",;					//Titulo SPA
			"Forma pagamento",;			    	//Titulo ENG
			"Forma pagamento",;					//Descricao
			"Forma pagamento",;					//Descricao SPA
			"Forma pagamento",;					//Descricao ENG
			"",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","S","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME   
		
aAdd(aSX3,{	"JHO",;								//Arquivo
			"01",;								//Ordem
			"JHO_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;							//Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;			       			//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;							//Descricao ENG
			"",;			   					//Picture
			"",;			   					//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME  
			
aAdd(aSX3,{	"JHO",;								//Arquivo
			"02",;								//Ordem
			"JHO_CODFAM",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod.Familia",;						//Titulo
			"Cod.Familia",;						//Titulo SPA
			"Cod.Familia",;			    		//Titulo ENG
			"Cod.Familia",;						//Descricao
			"Cod.Familia",;						//Descricao SPA
			"Cod.Familia",;						//Descricao ENG
			"@!",;								//Picture
			'ExistChav("JHO",M->JHO_CODFAM).And.FreeForUse("JHO",M->JHO_CODFAM)',;	//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHO",;								//Arquivo
			"03",;								//Ordem
			"JHO_NOMFAM",;						//Campo
			"C",;								//Tipo
			60,;								//Tamanho
			0,;									//Decimal
			"Nome Clan",;						//Titulo
			"Nome Clan",;						//Titulo SPA
			"Nome Clan",;			    		//Titulo ENG
			"Nome Clan",;						//Descricao
			"Nome Clan",;						//Descricao SPA
			"Nome Clan",;						//Descricao ENG
			"@!",;								//Picture
			"",;				   				//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHO",;								//Arquivo
			"04",;								//Ordem
			"JHO_MEMO1",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Observacao",;						//Titulo
			"Observacao",;						//Titulo SPA
			"Observacao",;			    		//Titulo ENG
			"Observacao",;						//Descricao
			"Observacao",;						//Descricao SPA
			"Observacao",;						//Descricao ENG
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

aAdd(aSX3,{	"JHO",;								//Arquivo
			"05",;								//Ordem
			"JHO_OBS",;							//Campo
			"M",;								//Tipo
			80,;								//Tamanho
			0,;									//Decimal
			"Observacao",;						//Titulo
			"Observacao",;						//Titulo SPA
			"Observacao",;			    		//Titulo ENG
			"Observacao",;						//Descricao
			"Observacao",;						//Descricao SPA
			"Observacao",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			'IF(!INCLUI,MSMM(JHO->JHO_MEMO1),"")',;	//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"01",;								//Ordem
			"JHQ_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;					 		//Titulo
				"Filial",;				  		//Titulo SPA
			"Filial",;			    	 		//Titulo ENG
			"Filial",;							//Descricao
			"Filial",;				   			//Descricao SPA
			"Filial",;				  			//Descricao ENG
			"@!",;								//Picture
			"",;				  				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"02",;								//Ordem
			"JHQ_CODFAM",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod Familia",;						//Titulo
			"Cod Familia",;						//Titulo SPA
			"Cod Familia",;			    		//Titulo ENG
			"Cod Familia",;						//Descricao
			"Cod Familia",;						//Descricao SPA
			"Cod Familia",;						//Descricao ENG
			"@!",;								//Picture
			"",;				 				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"03",;								//Ordem
			"JHQ_ITEM",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item",;							//Titulo
			"Item",;				 			//Titulo SPA
			"Item",;			    			//Titulo ENG
			"Item",;							//Descricao
			"Item",;				   			//Descricao SPA
			"Item",;		 					//Descricao ENG
			"999",;								//Picture
			"",;			  					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"04",;								//Ordem
			"JHQ_PLACA",;						//Campo
			"C",;								//Tipo
			7,;									//Tamanho
			0,;									//Decimal
			"Placa",;				   			//Titulo
			"Placa",;				 			//Titulo SPA
			"Placa",;			     			//Titulo ENG
			"Placa",;				 			//Descricao
			"Placa",;				 			//Descricao SPA
			"Placa",;							//Descricao ENG
			"@!",;								//Picture
			"AC905Placa()",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"05",;								//Ordem
			"JHQ_COR",;					  		//Campo
			"C",;								//Tipo
			25,;								//Tamanho
			0,;									//Decimal
			"Cor",;					 			//Titulo
			"Cor",;								//Titulo SPA
			"Cor",;			    				//Titulo ENG
			"Cor",;								//Descricao
			"Cor",;								//Descricao SPA
			"Cor",;								//Descricao ENG
			"@!",;								//Picture
			"",;			 					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"06",;								//Ordem
			"JHQ_ANO",;				  			//Campo
			"C",;								//Tipo
			4,;									//Tamanho
			0,;									//Decimal
			"Ano",;					   			//Titulo
			"Ano",;					  			//Titulo SPA
			"Ano",;			    	   			//Titulo ENG
			"Ano",;					  			//Descricao
			"Ano",;					 			//Descricao SPA
			"Ano",;					 			//Descricao ENG
			"9999",;							//Picture
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

aAdd(aSX3,{	"JHQ",;								//Arquivo
			"07",;								//Ordem
			"JHQ_MODELO",;						//Campo
			"C",;								//Tipo
			30,;								//Tamanho
			0,;									//Decimal
			"Modelo",;				  			//Titulo
			"Modelo",;				 			//Titulo SPA
			"Modelo",;			    	  		//Titulo ENG
			"Modelo",;				   			//Descricao
			"Modelo",;				  			//Descricao SPA
			"Modelo",;				   			//Descricao ENG
			"@!",;								//Picture
			"",;				 				//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JIE",;								//Arquivo
			"01",;								//Ordem
			"JIE_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;			   				//Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;				   			//Descricao
			"Filial",;							//Descricao SPA
			"Filial",;				   			//Descricao ENG
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

aAdd(aSX3,{	"JIE",;								//Arquivo
			"02",;								//Ordem
			"JIE_CODPLA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Plano Pagto",;						//Titulo
			"Plano Pagto",;						//Titulo SPA
			"Plano Pagto",;			    		//Titulo ENG
			"Plano Pagto",;						//Descricao
			"Plano Pagto",;						//Descricao SPA
			"Plano Pagto",;						//Descricao ENG
			"@!",;								//Picture
			'ExistChav("JIE",M->JIE_CODPLA) .and. FreeForUse("JIE",M->JIE_CODPLA)',;	//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIE",;								//Arquivo
			"03",;								//Ordem
			"JIE_NUMRA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"RA do Aluno",;						//Titulo
			"RA do Aluno",;						//Titulo SPA
			"RA do Aluno",;			    		//Titulo ENG
			"RA do Aluno",;						//Descricao
			"RA do Aluno",;						//Descricao SPA
			"RA do Aluno",;						//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("JA2",M->JIE_NUMRA,1)', 'ExistCpo("JA2",M->JIE_NUMRA,1)'),;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"JA2",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIE",;								//Arquivo
			"04",;								//Ordem
			"JIE_CLIENT",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Cod. Cliente",;					//Titulo
			"Cod. Cliente",;					//Titulo SPA
			"Cod. Cliente",;		    		//Titulo ENG
			"Cod. Cliente",;					//Descricao
			"Cod. Cliente",;					//Descricao SPA
			"Cod. Cliente",;					//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("SA1",M->JIE_CLIENT,1)', 'ExistCpo("SA1",M->JIE_CLIENT,1)'),;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIE",;								//Arquivo
			"05",;								//Ordem
			"JIE_LOJA",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Loja Cliente",;					//Titulo
			"Loja Cliente",;					//Titulo SPA
			"Loja Cliente",;		    		//Titulo ENG
			"Loja Cliente",;					//Descricao
			"Loja Cliente",;					//Descricao SPA
			"Loja Cliente",;					//Descricao ENG
			"@!",;								//Picture
			if(cParVisib <> '999999', 'GEExistCpo("SA1",M->JIE_CLIENT+M->JIE_LOJA,1)', 'ExistCpo("SA1",M->JIE_CLIENT+M->JIE_LOJA,1)'),;	//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
		
aAdd(aSX3,{	"JIF",;								//Arquivo
			"01",;								//Ordem
			"JIF_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;				 			//Titulo
			"Filial",;				 			//Titulo SPA
			"Filial",;			     			//Titulo ENG
			"Filial",;				 			//Descricao
			"Filial",;				 			//Descricao SPA
			"Filial",;				 			//Descricao ENG
			"@!",;								//Picture
			"",;				 				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"02",;								//Ordem
			"JIF_CODPLA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Plano Pagto",;						//Titulo
			"Plano Pagto",;						//Titulo SPA
			"Plano Pagto",;			    		//Titulo ENG
			"Plano Pagto",;						//Descricao
			"Plano Pagto",;						//Descricao SPA
			"Plano Pagto",;						//Descricao ENG
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

aAdd(aSX3,{	"JIF",;								//Arquivo
			"03",;								//Ordem
			"JIF_PARCEL",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Parcela",;							//Titulo
			"Parcela",;							//Titulo SPA
			"Parcela",;			    			//Titulo ENG
			"Parcela",;				   			//Descricao
			"Parcela",;				   			//Descricao SPA
			"Parcela",;					 		//Descricao ENG
			"999",;					 			//Picture
			"",;				  				//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"04",;								//Ordem
			"JIF_VENCTO",;						//Campo
			"D",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Vencimento",;						//Titulo
			"Vencimento",;						//Titulo SPA
			"Vencimento",;			    		//Titulo ENG
			"Vencimento",;						//Descricao
			"Vencimento",;						//Descricao SPA
			"Vencimento",;						//Descricao ENG
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
			"",'Empty(GDFieldGet("JI7_NUMTIT"))',"","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"05",;								//Ordem
			"JIF_VALOR",;						//Campo
			"N",;								//Tipo
			12,;								//Tamanho
			2,;									//Decimal
			"Valor",;			 				//Titulo
			"Valor",;			   				//Titulo SPA
			"Valor",;			   		 		//Titulo ENG
			"Valor",;			   				//Descricao
			"Valor",;							//Descricao SPA
			"Valor",;				 			//Descricao ENG
			"@E 999,999,999.99",;				//Picture
			"Positivo()",;						//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"",'Empty(GDFieldGet("JI7_NUMTIT"))',"","","","S"})		//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"06",;								//Ordem
			"JIF_STATUS",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Status",;							//Titulo
			"Status",;				   			//Titulo SPA
			"Status",;			       			//Titulo ENG
			"Status",;				   			//Descricao
			"Status",;				   			//Descricao SPA
			"Status",;				   			//Descricao ENG
			"@!",;								//Picture
			'Pertence("123")',;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"07",;								//Ordem
			"JIF_PRFTIT",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Prefixo",;							//Titulo
			"Prefixo",;							//Titulo SPA
			"Prefixo",;			     			//Titulo ENG
			"Prefixo",;			   				//Descricao
			"Prefixo",;				   			//Descricao SPA
			"Prefixo",;				  			//Descricao ENG
			"@!",;								//Picture
			"",;			 					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"08",;								//Ordem
			"JIF_NUMTIT",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Num. Titulo",;						//Titulo
			"Num. Titulo",;						//Titulo SPA
			"Num. Titulo",;			    		//Titulo ENG
			"Num. Titulo",;						//Descricao
			"Num. Titulo",;						//Descricao SPA
			"Num. Titulo",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


//Verifica qual o tamanho do campo E1_PARCELA para atribuir o mesmo tamanho no campo JIF_PARTIT
SX3->(DbSetOrder(2)) //X3_CAMPO
SX3->( MsSeek( "E1_PARCELA" ) )
nTam 	:= SX3->X3_TAMANHO
cGRPSXG := SX3->X3_GRPSXG //Associa o mesmo Grupo de Campos do E1_PARCELA

aAdd(aSX3,{	"JIF",;								//Arquivo
			"09",;								//Ordem
			"JIF_PARTIT",;						//Campo
			"C",;								//Tipo
			nTam,;								//Tamanho
			0,;									//Decimal
			"Parc. Titulo",;					//Titulo
			"Parc. Titulo",;					//Titulo SPA
			"Parc. Titulo",;			   		//Titulo ENG
			"Parc. Titulo",;					//Descricao
			"Parc. Titulo",;					//Descricao SPA
			"Parc. Titulo",;					//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","",cGRPSXG,"","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIF",;								//Arquivo
			"10",;								//Ordem
			"JIF_TIPTIT",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Tipo Titulo",;						//Titulo
			"Tipo Titulo",;						//Titulo SPA
			"Tipo Titulo",;			    		//Titulo ENG
			"Tipo Titulo",;						//Descricao
			"Tipo Titulo",;						//Descricao SPA
			"Tipo Titulo",;						//Descricao ENG
			"@!",;								//Picture
			"",;								//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{   "JIF",;                           //Arquivo
			"11",;								//Ordem
			"JIF_CODSER",;                      //Campo
			"C",;                               //Tipo
			3,;                                 //Tamanho
			0,;                                 //Decimal
			"Servico",;                         //Titulo
			"Servico",;                         //Titulo
			"Servico",;                         //Titulo
			"Servico",;                         //Titulo
			"Servico",;                         //Titulo
			"Servico",;                         //Titulo
			"",;                                //Picture
			"",;                                //VALID
			cUsadoNao,;                         //USADO
			"",;                                //RELACAO
			"",;                                //F3
			1,;                                 //NIVEL
			cReservNao,;                        //RESERV
			"","","S","N","",;                  //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;                          //CONTEXT, OBRIGAT, VLDUSER
			"","","",;                          //CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})                //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


aAdd(aSX3,{   "JIF",;                           //Arquivo
			"12",;								//Ordem
			"JIF_CHAVE",;                       //Campo
			"C",;                               //Tipo
			15,;                                //Tamanho
			0,;                                 //Decimal
			"Chave",;                           //Titulo
			"Chave",;                           //Titulo
			"Chave",;                           //Titulo
			"Chave",;                           //Titulo
			"Chave",;                           //Titulo
			"Chave",;                           //Titulo
			"",;                                //Picture
			"",;                                //VALID
			cUsadoNao,;                         //USADO
			"",;                                //RELACAO
			"",;                                //F3
			1,;                                 //NIVEL
			cReservNao,;                        //RESERV
			"","","S","N","",;                  //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;                          //CONTEXT, OBRIGAT, VLDUSER
			"","","",;                          //CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})                //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
SX3->(DbSetOrder(1)) //X3_ARQUIVO+X3_ORDEM
nPos := 0
SX3->( MsSeek( "JIF" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JIF" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++				
if nPos < 13
	nPos := 13
endif

aAdd(aSX3,{	"JIF",;								//Arquivo
			StrZero(nPos, 2),; 	 	            //Ordem
			"JIF_ITEMPA",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Item Parcela",;					//Titulo
			"Item Parcela",;					//Titulo SPA
			"Item Parcela",;			    	//Titulo ENG
			"Item da Parcela",;					//Descricao
			"Item da Parcela",;					//Descricao SPA
			"Item da Parcela",;					//Descricao ENG
			"99",;								//Picture
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

nPos++
aAdd(aSX3,{	"JIF",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JIF_ITEM",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Item",;							//Titulo
			"Item",;							//Titulo SPA
			"Item",;			    			//Titulo ENG
			"Item",;							//Descricao
			"Item",;							//Descricao SPA
			"Item",;							//Descricao ENG
			"",;								//Picture
			"",;		            			//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JIF",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JIF_VBOLSA",;						//Campo
			"N",;								//Tipo
			12,;								//Tamanho
			2,;									//Decimal
			"Vlr. Bolsa",;						//Titulo
			"Vlr. Bolsa",;						//Titulo SPA
			"Vlr. Bolsa",;			    		//Titulo ENG
			"Valor da Bolsa",;					//Descricao
			"Valor da Bolsa",;					//Descricao SPA
			"Valor da Bolsa",;					//Descricao ENG
			"@E 999,999,999.99",;				//Picture
			"AC060VldBo()",;					//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","U","N","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","",""})					//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JAH" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JAH" )
	nPos++
	SX3->( dbSkip() )
Enddo                         

nPos++			
aAdd(aSX3,{   "JAH",;                       //Arquivo
			StrZero(nPos, 2),;              //Ordem
			"JAH_TPPARC",;                  //Campo
			"C",;                           //Tipo
			1,;                             //Tamanho
			0,;                             //Decimal
			"Parcelamento",;                //Titulo
			"Parcelamento",;                //Titulo
			"Parcelamento",;                //Titulo
			"Parcelamento",;                //Titulo
			"Parcelamento",;                //Titulo
			"Parcelamento",;                //Titulo
			"",;                            //Picture
			"",;                            //VALID
			cUsadoOpc,;                     //USADO
			'"1"',;                         //RELACAO
			"",;                            //F3
			1,;                             //NIVEL
			cReservOpc,;                    //RESERV
			"","","S","N","",;              //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;                      //CONTEXT, OBRIGAT, VLDUSER
			"1=Calend.Fin.;2=Forma pagto","1=Calend.Fin.;2=Forma pagto","1=Calend.Fin.;2=Forma pagto",;  //CBOX, CBOX SPA, CBOX ENG
			"","INCLUI","","","","S"})      //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIG",;								//Arquivo
			"01",;				              	//Ordem
			"JIG_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;							//Titulo
			"Filial",;			   				//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;			   				//Descricao
			"Filial",;			   				//Descricao SPA
			"Filial",;			   				//Descricao ENG
			"@!",;								//Picture
			"",;			  					//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIG",;								//Arquivo
			"02",;				  	            //Ordem
			"JIG_CODPLA",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Plano Pagto",;						//Titulo
			"Plano Pagto",;						//Titulo SPA
			"Plano Pagto",;			    		//Titulo ENG
			"Plano Pagto",;						//Descricao
			"Plano Pagto",;						//Descricao SPA
			"Plano Pagto",;						//Descricao ENG
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

aAdd(aSX3,{	"JIG",;								//Arquivo
			"03",;				  	            //Ordem
			"JIG_CODCUR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Curso Vigente",;					//Titulo
			"Curso Vigente",;					//Titulo SPA
			"Curso Vigente",;			   		//Titulo ENG
			"Curso Vigente",;					//Descricao
			"Curso Vigente",;					//Descricao SPA
			"Curso Vigente",;					//Descricao ENG
			"@!",;								//Picture
			"",;				  				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIG",;								//Arquivo
			"04",;				  	            //Ordem
			"JIG_PERLET",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Per.Letivo",;						//Titulo
			"Per.Letivo",;						//Titulo SPA
			"Per.Letivo",;			    		//Titulo ENG
			"Per.Letivo",;						//Descricao
			"Per.Letivo",;						//Descricao SPA
			"Per.Letivo",;						//Descricao ENG
			"@!",;								//Picture
			"",;				 				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME 
			
aAdd(aSX3,{	"JIG",;								//Arquivo
			"05",;				  	            //Ordem
			"JIG_HABILI",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Habilitacao",;						//Titulo
			"Habilitacao",;						//Titulo SPA
			"Habilitacao",;			    		//Titulo ENG
			"Habilitacao",;						//Descricao
			"Habilitacao",;						//Descricao SPA
			"Habilitacao",;						//Descricao ENG
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

aAdd(aSX3,{	"JIG",;								//Arquivo
			"06",;				  	            //Ordem
			"JIG_CODSER",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Servico",;							//Titulo
			"Servico",;							//Titulo SPA
			"Servico",;			     			//Titulo ENG
			"Servico",;				 			//Descricao
			"Servico",;				  			//Descricao SPA
			"Servico",;				  			//Descricao ENG
			"@!",;								//Picture
			"",;				 				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIG",;								//Arquivo
			"07",; 				 	            //Ordem
			"JIG_CHAVE",;						//Campo
			"C",;								//Tipo
			15,;								//Tamanho
			0,;									//Decimal
			"Chave",;				   			//Titulo
			"Chave",;			   				//Titulo SPA
			"Chave",;			   		 		//Titulo ENG
			"Chave",;			  				//Descricao
			"Chave",;			   				//Descricao SPA
			"Chave",;			   				//Descricao ENG
			"@!",;								//Picture
			"",;		   						//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JIG",;								//Arquivo
			"08",; 				 	            //Ordem
			"JIG_CODFOR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Forma Pagto",;						//Titulo
			"Forma Pagto",;						//Titulo SPA
			"Forma Pagto",;			    		//Titulo ENG
			"Forma Pagto",;						//Descricao
			"Forma Pagto",;						//Descricao SPA
			"Forma Pagto",;						//Descricao ENG
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

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JIG" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JIG" )
	nPos++
	SX3->( dbSkip() )
Enddo   			

nPos++             
if nPos < 9
	nPos := 9
endif

aAdd(aSX3,{	"JIG",;								//Arquivo
			StrZero(nPos, 2),;  	            //Ordem
			"JIG_ITEM",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"ITEM",;						//Titulo
			"ITEM",;						//Titulo SPA
			"ITEM",;			    		//Titulo ENG
			"ITEM",;						//Descricao
			"ITEM",;						//Descricao SPA
			"ITEM",;						//Descricao ENG
			"",;								//Picture
			"",;					//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
aAdd(aSX3,{	"JF7",;								//Arquivo
			"01",;				  	            //Ordem
			"JF7_FILIAL",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Filial",;			  				//Titulo
			"Filial",;			 				//Titulo SPA
			"Filial",;			    			//Titulo ENG
			"Filial",;			 				//Descricao
			"Filial",;			   				//Descricao SPA
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

aAdd(aSX3,{	"JF7",;								//Arquivo
			"02",; 				 	            //Ordem
			"JF7_CODFOR",;						//Campo
			"C",;								//Tipo
			6,;									//Tamanho
			0,;									//Decimal
			"Codigo",;							//Titulo
			"Codigo",;							//Titulo SPA
			"Codigo",;			   		 		//Titulo ENG
			"Codigo",;				 			//Descricao
			"Codigo",;							//Descricao SPA
			"Codigo",;				 			//Descricao ENG
			"@!",;								//Picture
			"",;				   				//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF7",;								//Arquivo
			"03",;				  	            //Ordem
			"JF7_PARCEL",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Parcela",;							//Titulo
			"Parcela",;							//Titulo SPA
			"Parcela",;			  		  		//Titulo ENG
			"Parcela",;				 			//Descricao
			"Parcela",;				  			//Descricao SPA
			"Parcela",;				 			//Descricao ENG
			"@E 999",;							//Picture
			"",;				  				//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF7",;								//Arquivo
			"04",; 				 	            //Ordem
			"JF7_DIACOB",;						//Campo
			"N",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Dia Cobranca",;					//Titulo
			"Dia Cobranca",;					//Titulo SPA
			"Dia Cobranca",;			    	//Titulo ENG
			"Dia Cobranca",;					//Descricao
			"Dia Cobranca",;					//Descricao SPA
			"Dia Cobranca",;					//Descricao ENG
			"@E 99",;							//Picture
			"Entre(0,31) .and. AC585Dia()",;	//VALID
			cUsadoOpc,;							//USADO
			"5",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"",'GDFieldGet("JF7_TIPINT")$"124"',"","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF7",;								//Arquivo
			"05",; 				 	            //Ordem
			"JF7_TIPINT",;						//Campo
			"C",;								//Tipo
			1,;									//Tamanho
			0,;									//Decimal
			"Tipo Interv.",;					//Titulo
			"Tipo Interv.",;					//Titulo SPA
			"Tipo Interv.",;			   		//Titulo ENG
			"Tipo Interv.",;					//Descricao
			"Tipo Interv.",;					//Descricao SPA
			"Tipo Interv.",;					//Descricao ENG
			"",;								//Picture
			'Pertence("1234") .and. AC585Dia()',;	//VALID
			cUsadoOpc,;							//USADO
			'"4"',;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"1=Uteis;2=Corridos;3=Ultimo dia do mes;4=Nenhum","1=Uteis;2=Corridos;3=Ultimo dia do mes;4=Nenhum","1=Uteis;2=Corridos;3=Ultimo dia do mes;4=Nenhum",;	//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF7",;								//Arquivo
			"06",;				  	            //Ordem
			"JF7_INTERV",;						//Campo
			"N",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Intervalo",;						//Titulo
			"Intervalo",;						//Titulo SPA
			"Intervalo",;			    		//Titulo ENG
			"Intervalo",;						//Descricao
			"Intervalo",;						//Descricao SPA
			"Intervalo",;						//Descricao ENG
			"@E 999",;							//Picture
			'Positivo() .and. AC585Dia()',;		//VALID
			cUsadoOpc,;							//USADO
			"0",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"",'GDFieldGet("JF7_TIPINT")$"12"',"","","","S"})	//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF7",;								//Arquivo
			"07",; 				 	            //Ordem
			"JF7_PERPAR",;						//Campo
			"N",;								//Tipo
			8,;									//Tamanho
			4,;									//Decimal
			"Percentual",;						//Titulo
			"Percentual",;						//Titulo SPA
			"Percentual",;			    		//Titulo ENG
			"Percentual",;						//Descricao
			"Percentual",;						//Descricao SPA
			"Percentual",;						//Descricao ENG
			"@E 999.9999",;						//Picture
			'Entre(0.0001, 100) .and. AC585Valor()',;	//VALID
			cUsadoOpc,;							//USADO
			"AC585Perc()",;						//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JF7",;								//Arquivo
			"08",;  				            //Ordem
			"JF7_VALPAR",;						//Campo
			"N",;								//Tipo
			12,;								//Tamanho
			2,;									//Decimal
			"Val.Parcela",;						//Titulo
			"Val.Parcela",;						//Titulo SPA
			"Val.Parcela",;			    		//Titulo ENG
			"Val.Parcela",;						//Descricao
			"Val.Parcela",;						//Descricao SPA
			"Val.Parcela",;						//Descricao ENG
			"@E 999,999,999.99",;				//Picture
			'Entre(0.01, M->JF6_VALTOT) .and. AC585Valor()',;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"V","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

// Verifica qual eh a ultima ordem para incluir o registro na proxima ordem
nPos := 0
SX3->( MsSeek( "JF7" ) )
While SX3->( ! Eof() .And. Left( X3_ARQUIVO, 3 ) == "JF7" )
	nPos++
	SX3->( dbSkip() )
Enddo     			

nPos++
if nPos < 9
	nPos := 9
endif

aAdd(aSX3,{	"JF7",;								//Arquivo
			StrZero(nPos, 2),;  	            //Ordem
			"JF7_ITEMPA",;						//Campo
			"C",;								//Tipo
			2,;									//Tamanho
			0,;									//Decimal
			"Item Parcela",;					//Titulo
			"Item Parcela",;					//Titulo SPA
			"Item Parcela",;			    	//Titulo ENG
			"Item da Parcela",;					//Descricao
			"Item da Parcela",;					//Descricao SPA
			"Item da Parcela",;					//Descricao ENG
			"99",;								//Picture
			"",;								//VALID
			cUsadoNao,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservNao,;						//RESERV
			"","","","S","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

nPos++
aAdd(aSX3,{	"JF7",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF7_BANCO",;						//Campo
			"C",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Banco",;							//Titulo
			"Banco",;							//Titulo SPA
			"Banco",;			    			//Titulo ENG
			"Codigo do Banco",;					//Descricao
			"Codigo do Banco",;					//Descricao SPA
			"Codigo do Banco",;					//Descricao ENG
			"@!",;								//Picture
			'ExistCpo("SA6",M->JF7_BANCO)',;	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"SA6",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME			

nPos++
aAdd(aSX3,{	"JF7",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF7_AGENCI",;						//Campo
			"C",;								//Tipo
			5,;									//Tamanho
			0,;									//Decimal
			"Agencia",;							//Titulo
			"Agencia",;							//Titulo SPA
			"Agencia",;			    			//Titulo ENG
			"Codigo da Agencia",;				//Descricao
			"Codigo da Agencia",;				//Descricao SPA
			"Codigo da Agencia",;				//Descricao ENG
			"@!",;								//Picture
			'',;                             	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME		

nPos++
aAdd(aSX3,{	"JF7",;								//Arquivo
			StrZero(nPos, 2),;					//Ordem
			"JF7_CONTA",;						//Campo
			"C",;								//Tipo
			10,;								//Tamanho
			0,;									//Decimal
			"Conta",;							//Titulo
			"Conta",;							//Titulo SPA
			"Conta",;			    			//Titulo ENG
			"Numero da Conta",;					//Descricao
			"Numero da Conta",;					//Descricao SPA
			"Numero da Conta",;					//Descricao ENG
			"@!",;								//Picture
			'',;                             	//VALID
			cUsadoOpc,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservOpc,;						//RESERV
			"","","","S","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME		

//
// Reordena os campos da JA2
//
SX3->( dbSetOrder(2) )
if SX3->( !dbSeek( "JA2_CODFAM" ) )
	i := 0
	SX3->( dbSetOrder(1) )
	SX3->( dbSeek("JA2") )
	while SX3->( !eof() .and. X3_ARQUIVO == "JA2" )
		i++
		SX3->( dbSkip() )
	end
	
	SX3->( dbSeek("JA3") )
	SX3->( dbSkip(-1) )
	while SX3->( !bof() .and. X3_ARQUIVO == "JA2" .and. Upper(Alltrim(X3_CAMPO)) <> "JA2_FILIAL" )
		RecLock("SX3", .F.)
		SX3->X3_ORDEM := StrZero( i + 2, 2 )
		SX3->( msUnlock() )
		i--
		SX3->( dbSkip(-1) )
	end
endif


/******************************************************************************************
Grava informacoes do array no banco de dados
******************************************************************************************/
ProcRegua(Len(aSX3))

SX3->(DbSetOrder(2))	

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lAtu := .T.
		Else
			lAtu := .F.
		EndIf
		lSX3	:= .T.		
		If !(aSX3[i,1]$cAlias)
			cAlias += aSX3[i,1]+"/"
			aAdd(aArqUpd,aSX3[i,1])			
		EndIf
		RecLock("SX3",lAtu)
		For j:=1 To Len(aSX3[i])
			If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		MsUnLock()
		IncProc("Atualizando Dicionario de Dados...") //

	EndIf
Next i

If lSX3
	cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

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

aAdd(aSX7,{	"JHP_CEP",;			 			//Campo
			"001",;							//Sequencia
			"JC2->JC2_LOGRAD",;				//Regra
			"JHP_END",;      				//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JHP_CEP",;			 			//Campo
			"002",;							//Sequencia
			"JC2->JC2_BAIRRO",;				//Regra
			"JHP_BAIRRO",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JHP_CEP",;			 			//Campo
			"003",;							//Sequencia
			"JC2->JC2_CIDADE",;				//Regra
			"JHP_CIDADE",;      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JHP_CEP",;			 			//Campo
			"004",;							//Sequencia
			"JC2->JC2_ESTADO",;				//Regra
			"JHP_EST",;		      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"001",;							//Sequencia
			"JHP->JHP_NOMMEM",;				//Regra
			"JA2_NOME",;	      			//Campo Dominio
			"P",;              				//Tipo
			"S",;  							//Posiciona?
			"JHP",;							//Alias
			1,;								//Ordem do Indice
			'xFilial("JHP")+M->JA2_CODFAM+M->JA2_CODMEM',;//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"002",;							//Sequencia
			"JHP->JHP_EMAIL",;				//Regra
			"JA2_EMAIL",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"003",;							//Sequencia
			"JHP->JHP_RG",;					//Regra
			"JA2_RG",;		      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"004",;							//Sequencia
			"JHP->JHP_CPF",;				//Regra
			"JA2_CPF",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"005",;							//Sequencia
			"JHP->JHP_END",;				//Regra
			"JA2_END",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"006",;							//Sequencia
			"JHP->JHP_NUMEND",;				//Regra
			"JA2_NUMEND",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"007",;							//Sequencia
			"JHP->JHP_COMPLE",;				//Regra
			"JA2_COMPLE",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"008",;							//Sequencia
			"JHP->JHP_CEP",;				//Regra
			"JA2_CEP",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"009",;							//Sequencia
			"JHP->JHP_BAIRRO",;				//Regra
			"JA2_BAIRRO",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"010",;							//Sequencia
			"JHP->JHP_CIDADE",;				//Regra
			"JA2_CIDADE",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"011",;							//Sequencia
			"JHP->JHP_EST",;				//Regra
			"JA2_EST",;	      				//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"012",;							//Sequencia
			"AC240GPai()",;				//Regra
			"JA2_PAI",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;		//Chave
			"S",;							//Proprietario
			""})		//Condicao

aAdd(aSX7,{	"JA2_CODMEM",;		 			//Campo
			"013",;							//Sequencia
			"AC240GMae()",;				//Regra
			"JA2_MAE",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;		//Chave
			"S",;							//Proprietario
			""})		//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"001",;							//Sequencia
			"SA1->A1_NOME",;				//Regra
			"JC1_NOME",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"002",;							//Sequencia
			"SA1->A1_EMAIL",;				//Regra
			"JC1_EMAIL",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"003",;							//Sequencia
			"SA1->A1_RG",;					//Regra
			"JC1_RG",;		      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"004",;							//Sequencia
			"SA1->A1_CGC",;				//Regra
			"JC1_CPF",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"005",;							//Sequencia
			'Left(SA1->A1_END, At(",", SA1->A1_END)-1)',;				//Regra
			"JC1_END",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"006",;							//Sequencia
			'Subs(SA1->A1_END, At(",", SA1->A1_END)+1)',;				//Regra
			"JC1_NUMEND",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"007",;							//Sequencia
			"SA1->A1_CEP",;				//Regra
			"JC1_CEP",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"008",;							//Sequencia
			"SA1->A1_BAIRRO",;				//Regra
			"JC1_BAIRRO",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"009",;							//Sequencia
			"SA1->A1_MUN",;				//Regra
			"JC1_CIDADE",;	      			//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JC1_CLIENT",;		 			//Campo
			"010",;							//Sequencia
			"SA1->A1_EST",;				//Regra
			"JC1_EST",;	      				//Campo Dominio
			"P",;              				//Tipo
			"N",;  							//Posiciona?
			"",;							//Alias
			0,;								//Ordem do Indice
			"",;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JI7_NATURE",;		 			//Campo
			"001",;							//Sequencia
			"SED->ED_DESCRIC",;				//Regra
			"JI7_DNATUR",;	      				//Campo Dominio
			"P",;              				//Tipo
			"S",;  							//Posiciona?
			"SED",;							//Alias
			1,;								//Ordem do Indice
			'xFilial("SED")+M->JI7_NATURE',;							//Chave
			"S",;							//Proprietario
			""})							//Condicao

aAdd(aSX7,{	"JIX_HABILI",;		 			//Campo
			"001",;							//Sequencia
			"JDK->JDK_DESC",;				//Regra
			"JIX_DHABIL",;	      				//Campo Dominio
			"P",;              				//Tipo
			"S",;  							//Posiciona?
			"JDK",;							//Alias
			1,;								//Ordem do Indice
			'xFilial("JDK")+M->JIX_HABILI',;							//Chave
			"S",;							//Proprietario
			""})							//Condicao         

aAdd(aSX7,{	"JF6_CODSER",;		 			//Campo
			"001",;							//Sequencia
			"JI7->JI7_DESSER",;				//Regra
			"JF6_DESSER",;	      				//Campo Dominio
			"P",;              				//Tipo
			"S",;  							//Posiciona?
			"JI7",;							//Alias
			1,;								//Ordem do Indice
			'xFilial("JI7")+M->JF6_CODSER',;//Chave
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
		MsUnLock()
		IncProc("Atualizando Gatilhos...")
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

aAdd(aSIX,{"JHO",;   										//Indice
		"1",;                 								//Ordem
		"JHO_FILIAL+JHO_CODFAM",;  							//Chave
		"Codigo familia",;     								//Descicao Port.
		"Codigo familia",;									//Descicao Spa.
		"Codigo familia",;									//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  

aAdd(aSIX,{"JHO",;   										//Indice
		"2",;                 								//Ordem
		"JHO_FILIAL+JHO_NOMFAM",;	  						//Chave
		"Nome do cla",;     								//Descicao Port.
		"Nome do cla",;     								//Descicao Spa.
		"Nome do cla",;     								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  
                                                                                                                                                                                                                                                      //ShowPesq
aAdd(aSIX,{"JIX",;   										//Indice
		"1",;                 								//Ordem
		"JIX_FILIAL+JIX_CODCUR+JIX_PERLET+JIX_HABILI+JIX_FORPAD+JIX_CODFOR",;	//Chave
		"Curso+Periodo letivo+Habilitacao+Forma padrão+Forma de pagamento",; //Descicao Port.
		"Curso+Periodo letivo+Habilitacao+Forma padrão+Forma de pagamento",; //Descicao Spa.
		"Curso+Periodo letivo+Habilitacao+Forma padrão+Forma de pagamento",; //Descicao Eng.
		"S",;												//Proprietario
		"",;												//F3
		"",;												//NickName
		"S"})												//ShowPesq

aAdd(aSIX,{"JIX",;   										//Indice
		"2",;                 								//Ordem
		"JIX_FILIAL+JIX_CODFOR+JIX_CODCUR+JIX_PERLET+JIX_HABILI",;	//Chave
		"Forma de pagamento+Curso+Periodo letivo+Habilitacao",; //Descicao Port.
		"Forma de pagamento+Curso+Periodo letivo+Habilitacao",; //Descicao Spa.
		"Forma de pagamento+Curso+Periodo letivo+Habilitacao",; //Descicao Eng.
		"S",;												//Proprietario
		"",;												//F3
		"",;												//NickName
		"S"})												//ShowPesq

aAdd(aSIX,{"JIE",;											//Indice
		"1",;												//Ordem
		"JIE_FILIAL+JIE_CODPLA",;                 			//Chave
		"Codigo do plano",; 								//Descicao Port.
		"Codigo do plano",; 								//Descicao Spa.
		"Codigo do plano",; 								//Descicao Eng.
		"S",;												//Proprietario
		"",;												//F3
		"",;												//NickName
		"S"})												//ShowPesq                                                                                                                                    //ShowPesq

aAdd(aSIX,{"JIE",;   										//Indice
		"2",;                 								//Ordem
		"JIE_FILIAL+JIE_NUMRA+JIE_CLIENT+JIE_LOJA",;		//Chave
		"Aluno+Cliente+Loja",; 								//Descicao Port.
		"Aluno+Cliente+Loja",; 								//Descicao Spa.
		"Aluno+Cliente+Loja",; 								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
	
aAdd(aSIX,{"JIE",;   										//Indice
		"3",;                 								//Ordem
		"JIE_FILIAL+JIE_CLIENT+JIE_LOJA+JIE_CODPLA",;  		//Chave
		"Cliente+Loja+Plano",; 								//Descicao Port.
		"Cliente+Loja+Plano",; 								//Descicao Spa.
		"Cliente+Loja+Plano",; 								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq         

aAdd(aSIX,{"JF6",;   										//Indice
		"1",;                 								//Ordem
		"JF6_FILIAL+JF6_CODFOR",;  							//Chave
		"Codigo da Forma",;     							//Descicao Port.
		"Codigo da Forma",;									//Descicao Spa.
		"Codigo da Forma",;									//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq   
		
aAdd(aSIX,{"JF6",;   										//Indice
		"2",;                 								//Ordem
		"JF6_FILIAL+JF6_CODSER+JF6_CODFOR",;  				//Chave
		"Servico+Forma",;     								//Descicao Port.
		"Servico+Forma",;									//Descicao Spa.
		"Servico+Forma",;									//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JF6",;   										//Indice
		"3",;                 								//Ordem
		"JF6_FILIAL+JF6_DESFOR+JF6_CODFOR",;  				//Chave
		"Descricao+Codigo",;     							//Descicao Port.
		"Descricao+Codigo",;								//Descicao Spa.
		"Descricao+Codigo",;								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq 
		
aAdd(aSIX,{"JF6",;   										//Indice
		"4",;                 								//Ordem
		"JF6_FILIAL+JF6_STATUS+JF6_CODFOR",;  				//Chave
		"Status+Codigo",;     								//Descicao Port.
		"Status+Codigo",;									//Descicao Spa.
		"Status+Codigo",;									//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
                                                                        

aAdd(aSIX,{"JF7",;   										//Indice
		"1",;                 								//Ordem
		"JF7_FILIAL+JF7_CODFOR+JF7_PARCEL+JF7_ITEMPA",;  	//Chave
		"Codigo da Forma+Parcela+Item",;     					//Descicao Port.
		"Codigo da Forma+Parcela+Item",;     					//Descicao Port.
		"Codigo da Forma+Parcela+Item",;     					//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq   

aAdd(aSIX,{"JHP",;   										//Indice
		"1",;                 								//Ordem
		"JHP_FILIAL+JHP_CODFAM+JHP_ITEM",;  				//Chave
		"Cod.Familia+Item",;     							//Descicao Port.
		"Cod.Familia+Item",;								//Descicao Spa.
		"Cod.Familia+Item",;								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JHP",;   										//Indice
		"2",;                 								//Ordem
		"JHP_FILIAL+JHP_NOMMEM",;  							//Chave
		"Clan",;     										//Descicao Port.
		"Clan",;											//Descicao Spa.
		"Clan",;											//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
                                                                         
aAdd(aSIX,{"JHQ",;   										//Indice
		"1",;                 								//Ordem
		"JHQ_FILIAL+JHQ_CODFAM+JHQ_ITEM",;  				//Chave
		"Cod Familia+Item",;     							//Descicao Port.
		"Cod Familia+Item",;								//Descicao Spa.
		"Cod Familia+Item",;								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JHQ",;   										//Indice
		"2",;                 								//Ordem
		"JHQ_FILIAL+JHQ_PLACA",;  							//Chave
		"Placa",;     										//Descicao Port.
		"Placa",;											//Descicao Spa.
		"Placa",;											//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq 
		
aAdd(aSIX,{"JI7",;   										//Indice
		"1",;                 								//Ordem
		"JI7_FILIAL+JI7_CODSER",;  							//Chave
		"Codigo do Servico",;     							//Descicao Port.
		"Codigo do Servico",;								//Descicao Spa.
		"Codigo do Servico",;								//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  
		
aAdd(aSIX,{"JI7",;   										//Indice
		"2",;                 								//Ordem
		"JI7_FILIAL+JI7_DESSER+JI7_CODSER",;  				//Chave
		"Descricao",;     									//Descicao Port.
		"Descricao",;										//Descicao Spa.
		"Descricao",;										//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JIF",;                                         //Indice
		"1",;                                              //Ordem
		"JIF_FILIAL+JIF_CODPLA+JIF_CODSER+JIF_CHAVE+JIF_PARCEL+JIF_ITEMPA",; 	//Chave
		"Plano+Servico+Chave+Parcela+Item",; 					//Descicao Port.
		"Plano+Servico+Chave+Parcela+Item",; 					//Descicao Spa.
		"Plano+Servico+Chave+Parcela+Item",; 					//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq 

aAdd(aSIX,{"JIF",;   										//Indice
		"2",;                 								//Ordem
		"JIF_FILIAL+JIF_PRFTIT+JIF_NUMTIT+JIF_PARTIT+JIF_TIPTIT",;  //Chave
		"Prefixo+Numero+Parcela+Tipo do titulo",;     		//Descicao Port.
		"Prefixo+Numero+Parcela+Tipo do titulo",;     		//Descicao Spa.
		"Prefixo+Numero+Parcela+Tipo do titulo",;     		//Descicao Eng.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
                                            
aAdd(aSIX,{"JIG",;											//Indice
		"1",;												//Ordem
		"JIG_FILIAL+JIG_CODPLA+JIG_ITEM+JIG_CODCUR+JIG_PERLET+JIG_HABILI+JIG_CODSER+JIG_CHAVE",;	//Chave
		"Plano+item+Curso+PerLet+Habilitacao+Servico+Chave",; //Descicao Port.
		"Plano+item+Curso+PerLet+Habilitacao+Servico+Chave",; //Descicao Port.
		"Plano+item+Curso+PerLet+Habilitacao+Servico+Chave",; //Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq

aAdd(aSIX,{"JIG",;											//Indice
		"2",;												//Ordem
		"JIG_FILIAL+JIG_CODPLA+JIG_CODCUR+JIG_PERLET+JIG_HABILI+JIG_CODSER+JIG_CHAVE",;	//Chave
		"Plano+Curso+PerLet+Habilitacao+Servico+Chave",; 	//Descicao Port.
		"Plano+Curso+PerLet+Habilitacao+Servico+Chave",; 	//Descicao Port.
		"Plano+Curso+PerLet+Habilitacao+Servico+Chave",; 	//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq
		
aAdd(aSIX,{"JA2",;											//Indice
		"A",;												//Ordem
		"JA2_FILIAL+JA2_CODFAM",;							//Chave
		"Cod. Familia",; 									//Descicao Port.
		"Cod. Familia",; 									//Descicao Port.
		"Cod. Familia",; 									//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"JA210",;											//NickName
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
aEstrut:= {"XB_ALIAS", "XB_TIPO", "XB_SEQ", "XB_COLUNA", "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM", "XB_WCONTEM"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os novos conteudos dos filtros das consultas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aSXB,{	"JAR001","1","01","DB",;				// ALIAS, TIPO, SEQ, COLUNA
			"Periodos letivos do curso vigente",;	// DESCRI
			"Periodos letivos do curso vigente",;	// DESC SPA
			"Periodos letivos do curso vigente",;	// DESC ENG
			"JAR", "" })							// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","2","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Periodo letivo",;						// DESCRI
			"Periodo letivo",;						// DESC SPA
			"Periodo letivo",;						// DESC ENG
			"", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","4","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Periodo letivo",;						// DESCRI
			"Periodo letivo",;						// DESC SPA
			"Periodo letivo",;						// DESC ENG
			"JAR->JAR_PERLET", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","4","01","02",;				// ALIAS, TIPO, SEQ, COLUNA
			"Habilitacao",;							// DESCRI
			"Habilitacao",;							// DESC SPA
			"Habilitacao",;							// DESC ENG
			"JAR->JAR_HABILI", "" })				// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","5","01","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			"JAR->JAR_PERLET", ""})					// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","5","02","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			"JAR->JAR_HABILI", ""})					// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","5","03","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			'Posicione("JDK",1,xFilial("JDK")+JAR->JAR_HABILI,"JDK_DESC")', ""})					// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR001","6","","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			'JAR->JAR_CODCUR = GDFieldGet("JIX_CODCUR")', ""})	// CONTEM, WCONTEM

//
aAdd(aSXB,{	"JAR002","1","01","DB",;				// ALIAS, TIPO, SEQ, COLUNA
			"Habilitacoes do curso vigente",;	// DESCRI
			"Habilitacoes do curso vigente",;	// DESC SPA
			"Habilitacoes do curso vigente",;	// DESC ENG
			"JAR", "" })							// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR002","2","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;						// DESCRI
			"Codigo",;						// DESC SPA
			"Codigo",;						// DESC ENG
			"", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR002","4","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Habilitacao",;							// DESCRI
			"Habilitacao",;							// DESC SPA
			"Habilitacao",;							// DESC ENG
			"JAR->JAR_HABILI", "" })				// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR002","4","01","02",;				// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;							// DESCRI
			"Descricao",;							// DESC SPA
			"Descricao",;							// DESC ENG
			'Posicione("JDK",1,xFilial("JDK")+JAR->JAR_HABILI,"JDK_DESC")', "" })				// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR002","5","01","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			"JAR->JAR_HABILI", ""})					// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR002","5","02","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			'Posicione("JDK",1,xFilial("JDK")+JAR->JAR_HABILI,"JDK_DESC")', ""})					// CONTEM, WCONTEM

aAdd(aSXB,{	"JAR002","6","","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			'JAR->JAR_CODCUR = GDFieldGet("JIX_CODCUR") .and. JAR->JAR_PERLET = GDFieldGet("JIX_PERLET")', ""})	// CONTEM, WCONTEM

aAdd(aSXB,{	"JI7","1","01","DB",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Servico Educacional",;							// DESCRI
			"Servico Educacional",;							// DESC SPA
			"Servico Educacional",;							// DESC ENG
			"JI7", "JI7" })				// CONTEM, WCONTEM
                                                                            
aAdd(aSXB,{	"JI7","2","01","02",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Descricao",;							// DESCRI
			"Descricao",;							// DESC SPA
			"Descricao",;							// DESC ENG
			"", "" })				// CONTEM, WCONTEM
                                                                            
aAdd(aSXB,{	"JI7","2","02","01",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Codigo",;							// DESCRI
			"Codigo",;							// DESC SPA
			"Codigo",;							// DESC ENG
			"", "" })				// CONTEM, WCONTEM
			
aAdd(aSXB,{	"JI7","3","01","01",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Cadastra Novo",;							// DESCRI
			"Cadastra Novo",;							// DESC SPA
			"Cadastra Novo",;							// DESC ENG
			"01", "" })				// CONTEM, WCONTEM 
			
aAdd(aSXB,{	"JI7","4","01","01",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Descricao",;							// DESCRI
			"Descricao",;							// DESC SPA
			"Descricao",;							// DESC ENG
			"JI7_DESSER", "JI7_DESSER" })				// CONTEM, WCONTEM   

aAdd(aSXB,{	"JI7","4","01","02",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Codigo",;							// DESCRI
			"Codigo",;							// DESC SPA
			"Codigo",;							// DESC ENG
			"JI7_CODSER", "JI7_CODSER" })				// CONTEM, WCONTEM
			
aAdd(aSXB,{	"JI7","4","02","01",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Codigo",;							// DESCRI
			"Codigo",;							// DESC SPA
			"Codigo",;							// DESC ENG
			"JI7_CODSER", "JI7_CODSER" })				// CONTEM, WCONTEM    

aAdd(aSXB,{	"JI7","4","02","02",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Descricao",;							// DESCRI
			"Descricao",;							// DESC SPA
			"Descricao",;							// DESC ENG
			"JI7_DESSER", "JI7_DESSER" })				// CONTEM, WCONTEM  
			
aAdd(aSXB,{	"JI7","5","01","",;				// ALIAS, TIPO, SEQ, COLUNA1
			"Codigo",;							// DESCRI
			"Codigo",;							// DESC SPA
			"Codigo",;							// DESC ENG
			"JI7->JI7_CODSER", "JI7->JI7_CODSER" })				// CONTEM, WCONTEM                                                                                     

// Cadastro de familias
aAdd(aSXB,{	"JHO","1","01","DB",;				// ALIAS, TIPO, SEQ, COLUNA
			"Familias",;						// DESCRI
			"Familias",;						// DESCRI
			"Familias",;						// DESCRI
			"JHO", "" })							// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","2","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;							// DESCRI
			"Codigo",;							// DESCRI
			"Codigo",;							// DESCRI
			"", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","2","02","02",;				// ALIAS, TIPO, SEQ, COLUNA
			"Nome do cla",;							// DESCRI
			"Nome do cla",;							// DESCRI
			"Nome do cla",;							// DESCRI
			"", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","4","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;								// DESCRI
			"Codigo",;								// DESCRI
			"Codigo",;								// DESCRI
			"JHO->JHO_CODFAM", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","4","01","02",;				// ALIAS, TIPO, SEQ, COLUNA
			"Nome",;								// DESCRI
			"Nome",;								// DESCRI
			"Nome",;								// DESCRI
			"JHO->JHO_NOMFAM", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","4","02","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Nome",;								// DESCRI
			"Nome",;								// DESCRI
			"Nome",;								// DESCRI
			"JHO->JHO_NOMFAM", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","4","02","02",;				// ALIAS, TIPO, SEQ, COLUNA
			"Codigo",;								// DESCRI
			"Codigo",;								// DESCRI
			"Codigo",;								// DESCRI
			"JHO->JHO_CODFAM", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHO","5","01","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			"JHO->JHO_CODFAM", ""})					// CONTEM, WCONTEM

// Membros das familias
aAdd(aSXB,{	"JHP","1","01","DB",;				// ALIAS, TIPO, SEQ, COLUNA
			"Membros das Familias",;			// DESCRI
			"Membros das Familias",;			// DESCRI
			"Membros das Familias",;			// DESCRI
			"JHP", "" })							// CONTEM, WCONTEM

aAdd(aSXB,{	"JHP","2","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Família + Membro",;				// DESCRI
			"Família + Membro",;				// DESCRI
			"Família + Membro",;				// DESCRI
			"", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHP","4","01","01",;				// ALIAS, TIPO, SEQ, COLUNA
			"Membro",;								// DESCRI
			"Membro",;								// DESCRI
			"Membro",;								// DESCRI
			"JHP_ITEM", "" })						// CONTEM, WCONTEM

aAdd(aSXB,{	"JHP","4","01","02",;				// ALIAS, TIPO, SEQ, COLUNA
			"Nome",;								// DESCRI
			"Nome",;								// DESCRI
			"Nome",;								// DESCRI
			"JHP_NOMMEM", "" })								// CONTEM, WCONTEM

aAdd(aSXB,{	"JHP","5","01","",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			"JHP->JHP_ITEM", ""})					// CONTEM, WCONTEM

aAdd(aSXB,{	"JHP","7","01","01",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			'xFilial("JHP")+M->JA2_CODFAM', ""})	// CONTEM, WCONTEM

aAdd(aSXB,{	"JHP","7","02","02",;					// ALIAS, TIPO, SEQ, COLUNA
			"",;									// DESCRI
			"",;									// DESC SPA
			"",;									// DESC ENG
			'xFilial("JHP")+M->JA2_CODFAM', ""})	// CONTEM, WCONTEM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa consultas para alteracao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua(Len(aSXB))

dbSelectArea("SXB")
SXB->(dbSetOrder(1)) //XB_ALIAS+XB_TIPO+XB_SEQ	
For i := 1 To Len(aSXB)
	If !dbSeek(Padr(aSXB[i,1],6)+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GELimpaSX ³ Autor ³Rafael Rodrigues    ³ Data ³ 01/Fev/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Elimina dados do dicionario antes da atualizacao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao GE                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Icaro Queiroz³29/08/06³099583³Tratamento para excluir indices do Banco  ±±
±±³             ³        ³      ³de dados, e dar um Refresh               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GELimpaSX()
Local i
Local aDelSXB	:= {"JHO"}
Local aDelSIX	:= {"JIF1, JIG2", "JIE2"}
Local aDelSX2	:= {"JIF"}
Local aDelSX3	:= {"JHO_MEMO", "JIX_PERLET", "JIX_HABILI", "JI7_DNATUR", "JHP_ITPAI", "JHP_ITMAE"}

SXB->( dbSetOrder(1) )
for i := 1 to len( aDelSXB )
	while SXB->( dbSeek( aDelSXB[i] ) )
		RecLock( "SXB", .F. )
		SXB->( dbDelete() )
		SXB->( msUnlock() )
	end
next i

SIX->( dbSetOrder(1) )
for i := 1 to len( aDelSIX )
	while SIX->( dbSeek( aDelSIX[i] ) )
		RecLock( "SIX", .F. )
		SIX->( dbDelete() )
		SIX->( msUnlock() )
		
		TCSQLExec("drop index "+RetSQLName(Subs(aDelSIX[i],1,3))+Subs(aDelSIX[i],4,1))
		TCRefreh(Subs(aDelSIX[i],1,3))
	end
next i

SX2->( dbSetOrder(1) )
for i := 1 to len( aDelSX2 )
	if SX2->( dbSeek( aDelSX2[i] ) )
		RecLock( "SX2", .F. )
		SX2->( dbDelete() )
		SX2->( msUnlock() )
	endif
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
