#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdGE22    ³Autor  ³ Fabiana Leal Pereira ³ Data ³ 28/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao do dicionario de dados para contemplacao da	  ³±±
±±³          ³ rotinas de Transferencia de Filial                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGE                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdGE22()
Local cMsg := ""

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd
Private cEmps := ""

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicionários e base de dados para "
cMsg += "implementar a melhoria de Transfência de Filial "+Chr(13)+Chr(10)+Chr(13)+Chr(10)
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
±±³Fun‡…o    ³GEProc    ³ Autor ³Fabiana Leal Pereira  ³ Data ³ 28/Dez/06 ³±±
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
Local cNumReq 	:= ""
Local cEmpAnt 	:= ""


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
			
			//Exclui o controle de numeracao do SXE e SXF da tabela JBF para que seja recriado pela rotina de Conf. de Requerimentos
			GEExclSXE()
			
			lMsFinalAuto := .F.
			
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua( nI)
			IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados")			
			cTexto += "Analisando Dicionario de Dados..."+CHR(13)+CHR(10)
			GEAtuSX3()
			TcRefresh("JC3")
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados")              

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

			dbSelectArea("JBH")
			dbSelectArea("JA2")
			dbSelectArea("JD1")		

			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Abrindo Tabelas")
			
			dbSelectArea("JBF")
			dbSelectArea("JBG")
			dbSelectArea("JC3")
			
			if cEmpAnt <> SM0->M0_CODIGO
				cEmpAnt := SM0->M0_CODIGO
				cNumReq := GENumReq(SM0->M0_CODIGO) //Retorna o proximo numero do requerimento
				
				//Faz a inclusao dos Requerimentos
				Begin Transaction
				GECriaReq(cNumReq, SM0->M0_CODIGO, aRecnoSM0[nI][3])
				End Transaction
			endif
			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
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
±±³Fun‡…o    ³GEAtuSX3  ³ Autor ³Fabiana Leal Pereira  ³ Data ³ 28/Dez/06 ³±±
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
/*Local cUsadoObr		:= ''				//String que servira para cadastrar um campo como "USADO" em campos obrigatorios
Local cReservObr	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos obrigatorios
Local cUsadoOpc		:= ''				//String que servira para cadastrar um campo como "USADO" em campos opcionais
Local cReservOpc	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos opcionais
Local cUsadoNao		:= ''				//String que servira para cadastrar um campo como "USADO" em campos fora de uso
Local cReservNao	:= ''				//String que servira para cadastrar um campo como "Reservado" em campos fora de uso
Local cCBoxSit		:= ''*/

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
cUsadoKey	:= '€€€€€€€€€€€€€€'
cReservKey	:= 'þA'

/*******************************************************************************************
Monta o array com os campos das tabelas/*
*******************************************/

aAdd(aSX3,{	"JBH",;								//Arquivo
			GetOrdem( "JBH", "JBH_NUMDES" ),;	//Ordem
			"JBH_NUMDES",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Num Fil Des",;			    		//Titulo
			"Num Fil Des",;			    		//Titulo Esp.
			"Num Fil Des",;			    		//Titulo Ingl.
			"Num. da Filial de Destino",;		//Descricao
			"Num. da Filial de Destino",;		//Descricao Esp.
			"Num. da Filial de Destino",;		//Descricao Ingl.
			"",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JBH",;								//Arquivo
			GetOrdem( "JBH", "JBH_NUMANT" ),;	//Ordem
			"JBH_NUMANT",;						//Campo
			"C",;								//Tipo
			8,;									//Tamanho
			0,;									//Decimal
			"Num Fil Ant",;				    	//Titulo
			"Num Fil Ant",;				    	//Titulo Esp.
			"Num Fil Ant",;			  		  	//Titulo Ingl.
			"Num. da Filial Anterior",;			//Descricao
			"Num. da Filial Anterior",;			//Descricao Esp.
			"Num. da Filial Anterior",;			//Descricao Ingl.
			"",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

aAdd(aSX3,{	"JA2",;								//Arquivo
			GetOrdem( "JA2", "JA2_RAANT" ),;	//Ordem
			"JA2_RAANT",;						//Campo
			"C",;								//Tipo
			17,;								//Tamanho
			0,;									//Decimal
			"RA Fil Ant",;			    		//Titulo
			"RA Fil Ant",;			    		//Titulo Esp.
			"RA Fil Ant",;			    		//Titulo Ingl.
			"RA na Filial Anterior",;	   		//Descricao
			"RA na Filial Anterior",;	   		//Descricao Esp.
			"RA na Filial Anterior",;	   		//Descricao Ingl.
			"",;								//Picture
			"",;								//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","N","V",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;		                    //CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
                 
aAdd(aSX3,{	"JD1",;								//Arquivo
			GetOrdem( "JD1", "JD1_FALTAS" ),;	//Ordem
			"JD1_FALTAS",;						//Campo
			"N",;								//Tipo
			3,;									//Tamanho
			0,;									//Decimal
			"Faltas",;				    		//Titulo
			"Faltas",;		   			 		//Titulo Esp.
			"Faltas",;		    				//Titulo Ingl.
			"Faltas",;	    					//Descricao
			"Faltas",;	   				 		//Descricao Esp.
			"Faltas",;	    					//Descricao Ingl.
			"999",;								//Picture
			"Positivo()",;                  	//VALID
			cUsadoKey,;							//USADO
			"",;								//RELACAO
			"",;								//F3
			1,;									//NIVEL
			cReservKey,;						//RESERV
			"","","","S","A",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			"R","","",;							//CONTEXT, OBRIGAT, VLDUSER
			"","","",;							//CBOX, CBOX SPA, CBOX ENG
			"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME

SX3->(DbSetOrder(2))
SX3->( dbSeek("JBI_OBSERV") )

//Alteracao apenas no X3_WHEN do campo JBI_OBSERV
aAdd(aSX3,{	SX3->X3_ARQUIVO,;				//Arquivo
			SX3->X3_ORDEM,;					//Ordem
			SX3->X3_CAMPO,;					//Campo
			SX3->X3_TIPO,;					//Tipo
			SX3->X3_TAMANHO,;				//Tamanho
			SX3->X3_DECIMAL,;				//Decimal
			SX3->X3_TITULO,;		    	//Titulo
			SX3->X3_TITSPA,;		    	//Titulo Esp
			SX3->X3_TITENG,;		    	//Titulo Ingl.
			SX3->X3_DESCRIC,;	    		//Descr. 
			SX3->X3_DESCSPA,;	    		//Descr. Esp.
			SX3->X3_DESCENG,;	    		//Descr. Ingl.
			SX3->X3_PICTURE,;				//Picture
			SX3->X3_VALID,;                 //VALID
			SX3->X3_USADO,;					//USADO
			SX3->X3_RELACAO,;				//RELACAO
			SX3->X3_F3,;					//F3
			SX3->X3_NIVEL,;					//NIVEL
			SX3->X3_RESERV,;				//RESERV
			SX3->X3_CHECK,SX3->X3_TRIGGER,SX3->X3_PROPRI,SX3->X3_BROWSE,SX3->X3_VISUAL,; //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			SX3->X3_CONTEXT,SX3->X3_OBRIGAT,SX3->X3_VLDUSER,;							 //CONTEXT, OBRIGAT, VLDUSER
			SX3->X3_CBOX,SX3->X3_CBOXSPA,SX3->X3_CBOXENG,;							     //CBOX, CBOX SPA, CBOX ENG
			SX3->X3_PICTVAR,"A410ValDep() .And. A410WStatu()",SX3->X3_INIBRW,SX3->X3_GRPSXG,SX3->X3_FOLDER,SX3->X3_PYME}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			
SX3->( dbSeek("JBI_STATUS") )

//Alteracao apenas no X3_WHEN do campo JBI_STATUS
aAdd(aSX3,{	SX3->X3_ARQUIVO,;				//Arquivo
			SX3->X3_ORDEM,;					//Ordem
			SX3->X3_CAMPO,;					//Campo
			SX3->X3_TIPO,;					//Tipo
			SX3->X3_TAMANHO,;				//Tamanho
			SX3->X3_DECIMAL,;				//Decimal
			SX3->X3_TITULO,;		    	//Titulo
			SX3->X3_TITSPA,;		    	//Titulo Esp
			SX3->X3_TITENG,;		    	//Titulo Ingl.
			SX3->X3_DESCRIC,;	    		//Descr.
			SX3->X3_DESCSPA,;	    		//Descr. Esp.
			SX3->X3_DESCENG,;	    		//Descr. Ingl.
			SX3->X3_PICTURE,;				//Picture
			SX3->X3_VALID,;                 //VALID
			SX3->X3_USADO,;					//USADO
			SX3->X3_RELACAO,;				//RELACAO
			SX3->X3_F3,;					//F3
			SX3->X3_NIVEL,;					//NIVEL
			SX3->X3_RESERV,;				//RESERV
			SX3->X3_CHECK,SX3->X3_TRIGGER,SX3->X3_PROPRI,SX3->X3_BROWSE,SX3->X3_VISUAL,; //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			SX3->X3_CONTEXT,SX3->X3_OBRIGAT,SX3->X3_VLDUSER,;							 //CONTEXT, OBRIGAT, VLDUSER
			SX3->X3_CBOX,SX3->X3_CBOXSPA,SX3->X3_CBOXENG,;							     //CBOX, CBOX SPA, CBOX ENG
			SX3->X3_PICTVAR,"A410ValDep() .And. A410WStatu()",SX3->X3_INIBRW,SX3->X3_GRPSXG,SX3->X3_FOLDER,SX3->X3_PYME}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
			

SX3->( dbSeek("JC3_F3") )

//Alteracao apenas o tamanho do campo JC3_F3
aAdd(aSX3,{	SX3->X3_ARQUIVO,;				//Arquivo
			SX3->X3_ORDEM,;					//Ordem
			SX3->X3_CAMPO,;					//Campo
			SX3->X3_TIPO,;					//Tipo
			6,;								//Tamanho
			SX3->X3_DECIMAL,;				//Decimal
			SX3->X3_TITULO,;		    	//Titulo
			SX3->X3_TITSPA,;		    	//Titulo Esp
			SX3->X3_TITENG,;		    	//Titulo Ingl.
			SX3->X3_DESCRIC,;	    		//Descr.
			SX3->X3_DESCSPA,;	    		//Descr. Esp.
			SX3->X3_DESCENG,;	    		//Descr. Ingl.
			SX3->X3_PICTURE,;				//Picture
			SX3->X3_VALID,;                 //VALID
			SX3->X3_USADO,;					//USADO
			SX3->X3_RELACAO,;				//RELACAO
			SX3->X3_F3,;					//F3
			SX3->X3_NIVEL,;					//NIVEL
			SX3->X3_RESERV,;				//RESERV
			SX3->X3_CHECK,SX3->X3_TRIGGER,SX3->X3_PROPRI,SX3->X3_BROWSE,SX3->X3_VISUAL,; //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			SX3->X3_CONTEXT,SX3->X3_OBRIGAT,SX3->X3_VLDUSER,;							 //CONTEXT, OBRIGAT, VLDUSER
			SX3->X3_CBOX,SX3->X3_CBOXSPA,SX3->X3_CBOXENG,;							     //CBOX, CBOX SPA, CBOX ENG
			SX3->X3_PICTVAR,SX3->X3_WHEN,SX3->X3_INIBRW,SX3->X3_GRPSXG,SX3->X3_FOLDER,SX3->X3_PYME}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME


SX3->( dbSeek("JC3_WF3") )

//Alteracao apenas o tamanho do campo JC3_WF3
aAdd(aSX3,{	SX3->X3_ARQUIVO,;				//Arquivo
			SX3->X3_ORDEM,;					//Ordem
			SX3->X3_CAMPO,;					//Campo
			SX3->X3_TIPO,;					//Tipo
			6,;								//Tamanho
			SX3->X3_DECIMAL,;				//Decimal
			SX3->X3_TITULO,;		    	//Titulo
			SX3->X3_TITSPA,;		    	//Titulo Esp
			SX3->X3_TITENG,;		    	//Titulo Ingl.
			SX3->X3_DESCRIC,;	    		//Descr.
			SX3->X3_DESCSPA,;	    		//Descr. Esp.
			SX3->X3_DESCENG,;	    		//Descr. Ingl.
			SX3->X3_PICTURE,;				//Picture
			SX3->X3_VALID,;                 //VALID
			SX3->X3_USADO,;					//USADO
			SX3->X3_RELACAO,;				//RELACAO
			SX3->X3_F3,;					//F3
			SX3->X3_NIVEL,;					//NIVEL
			SX3->X3_RESERV,;				//RESERV
			SX3->X3_CHECK,SX3->X3_TRIGGER,SX3->X3_PROPRI,SX3->X3_BROWSE,SX3->X3_VISUAL,; //CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
			SX3->X3_CONTEXT,SX3->X3_OBRIGAT,SX3->X3_VLDUSER,;							 //CONTEXT, OBRIGAT, VLDUSER
			SX3->X3_CBOX,SX3->X3_CBOXSPA,SX3->X3_CBOXENG,;							     //CBOX, CBOX SPA, CBOX ENG
			SX3->X3_PICTVAR,SX3->X3_WHEN,SX3->X3_INIBRW,SX3->X3_GRPSXG,SX3->X3_FOLDER,SX3->X3_PYME}) //PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME
						
			
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
		
		//Atualiza o campo no Banco de Dados
		if AllTrim(aSX3[i][3]) == "JC3_WF3"
			X31UpdTable("JC3")
		endif
		
		IncProc("Atualizando Dicionario de Dados...")

	EndIf
Next i

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSIX  ³ Autor ³Fabiana Leal Pereira  ³ Data ³ 28/Dez/06 ³±±
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

aAdd(aSIX,{	"JBH",;   										//Indice
			"7",;                 								//Ordem
			"JBH_FILIAL+JBH_NUMANT",;		//Chave
			"Num Fil Ant",;			//Descicao Port.
			"Num Fil Ant",;			//Descicao Port.
			"Num Fil Ant",;			//Descicao Port.
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
/*IF Len(aSIX) > 0
	CHKFILE("JBH")
ENDIF*/
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEAtuSXB  ³Autora ³Fabiana Leal Pereira   ³ Data ³28/Dez/06 ³±±
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
//-- Consulta J13001
aAdd(aSXB,{	"J13001","1","01","RE",;		// ALIAS, TIPO, SEQ, COLUNA
			"Cursos",;		// DESCRI
			"Cursos",;		// DESCRI
			"Cursos",;		// DESCRI
			"JAF", "" })				// CONTEM, WCONTEM  

aAdd(aSXB,{	"J13001","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"U_SEC22XB2()", "" })		// CONTEM, WCONTEM

aAdd(aSXB,{	"J13001","5","01","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"_RetCodCur", "" })			// CONTEM, WCONTEM	
  
//-- Consulta JA3002
aAdd(aSXB,{	"JA3002","1","01","RE",;		// ALIAS, TIPO, SEQ, COLUNA
			"Unidades",;		// DESCRI
			"Unidades",;		// DESCRI
			"Unidades",;		// DESCRI
			"JA3", "" })				// CONTEM, WCONTEM  

aAdd(aSXB,{	"JA3002","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"U_SEC22XB1()", "" })		// CONTEM, WCONTEM

aAdd(aSXB,{	"JA3002","5","01","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"_RetCodLoc", "" })			// CONTEM, WCONTEM	

//-- Consulta J19001
aAdd(aSXB,{	"J19001","1","01","DB",;		// ALIAS, TIPO, SEQ, COLUNA
			"Cursos x Aluno",;		// DESCRI
			"Cursos x Aluno",;		// DESCRI
			"Cursos x Aluno",;		// DESCRI
			"JBE", "" })				// CONTEM, WCONTEM  

aAdd(aSXB,{	"J19001","2","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Curso",;						// DESCRI
			"Curso",;						// DESCRI
			"Curso",;						// DESCRI
			"", "" })		// CONTEM, WCONTEM  
			
aAdd(aSXB,{	"J19001","4","01","01",;		// ALIAS, TIPO, SEQ, COLUNA
			"Curso",;						// DESCRI
			"Curso",;						// DESCRI
			"Curso",;						// DESCRI
			"JBE->JBE_CODCUR", "" })		// CONTEM, WCONTEM

aAdd(aSXB,{	"J19001","4","01","02",;		// ALIAS, TIPO, SEQ, COLUNA
			"Descricao",;						// DESCRI
			"Descricao",;						// DESCRI
			"Descricao",;						// DESCRI
			'Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_DESC")', "" })		// CONTEM, WCONTEM
			
aAdd(aSXB,{	"J19001","4","01","03",;		// ALIAS, TIPO, SEQ, COLUNA
			"Periodo Letivo",;						// DESCRI
			"Periodo Letivo",;						// DESCRI
			"Periodo Letivo",;						// DESCRI
			'Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_DPERLE")', "" })		// CONTEM, WCONTEM
			
aAdd(aSXB,{	"J19001","4","01","04",;		// ALIAS, TIPO, SEQ, COLUNA
			"Habilitacao",;						// DESCRI
			"Habilitacao",;						// DESCRI
			"Habilitacao",;						// DESCRI
			'Posicione("JDK",1,xFilial("JDK")+JBE->JBE_HABILI,"JDK_DESC")', "" })		// CONTEM, WCONTEM			

aAdd(aSXB,{	"J19001","5","01","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JBE->JBE_CODCUR", "" })			// CONTEM, WCONTEM	
			
aAdd(aSXB,{	"J19001","5","02","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			'Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_DESC")', "" })			// CONTEM, WCONTEM	
						
aAdd(aSXB,{	"J19001","5","03","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JBE->JBE_PERLET", "" })			// CONTEM, WCONTEM	
			
aAdd(aSXB,{	"J19001","5","04","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JBE->JBE_HABILI", "" })			// CONTEM, WCONTEM	
			
aAdd(aSXB,{	"J19001","5","05","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			'Posicione("JDK",1,xFilial("JDK")+JBE->JBE_HABILI,"JDK_DESC")', "" })			// CONTEM, WCONTEM	

aAdd(aSXB,{	"J19001","5","06","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			"JBE->JBE_TURMA", "" })			// CONTEM, WCONTEM	

aAdd(aSXB,{	"J19001","5","07","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			'IIF(JBE->(FIELDPOS("JBE_SUBTUR"))>0,JBE->JBE_SUBTUR,"")', "" })			// CONTEM, WCONTEM	
			
aAdd(aSXB,{	"J19001","5","08","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			'Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_ANOLET")', "" })			// CONTEM, WCONTEM	
			
aAdd(aSXB,{	"J19001","5","09","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			'Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_PERIOD")', "" })			// CONTEM, WCONTEM	
			
aAdd(aSXB,{	"J19001","5","10","",;		// ALIAS, TIPO, SEQ, COLUNA
			"",;						// DESCRI
			"",;						// DESCRI
			"",;						// DESCRI
			'Posicione("JA2",1,xFilial("JA2")+JBE->JBE_NUMRA,"JA2_FRESID")', "" })			// CONTEM, WCONTEM	

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



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENumReq  ºAutor  ³Alberto Deviciente  º Data ³ 15/Jan/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica qual o maior numero de requerimento existente na   º±±
±±º          ³base para todas as filiais e Retorna o proximo numero.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³UpdGe22                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GENumReq(cEmp)
Local aAreaAnt	:= GetArea()
Local cAlias    := GetNextAlias()
Local cRet		:= StrZero(1, TamSx3("JBF_COD")[1])
Local cQuery 	:= ""

cQuery := "SELECT JBF_FILIAL, MAX(JBF_COD) AS NUM "
cQuery += " FROM " + RetSQLName("JBF")
cQuery += " GROUP BY JBF_FILIAL "
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), cAlias, .T., .T. )

while (cAlias)->( !Eof() )
	if (cAlias)->NUM > cRet
		cRet := (cAlias)->NUM
	endif
	(cAlias)->( dbSkip() )
end

cRet := soma1(cRet) //Pega o proximo numero

(cAlias)->( dbCloseArea() )

RestArea(aAreaAnt)

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECriaReq ºAutor  ³Alberto Deviciente  º Data ³ 15/Jan/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria o requerimento na Base de Dados para todas as Filiais. º±±
±±º          ³Os Dados serao incluidos nas tabelas JBF, JBG e JC3.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³UpdGe22                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GECriaReq(cNumReq, cEmp, aFiliais)
Local aAreaAnt	:= GetArea()
Local aScript 	:= {}
Local nInd 		:= 0
Local nFil		:= 0
Local lExistJBF := TCCanOpen(RetSqlName("JBF"))
Local cFiliais 	:= ""
Local nFiliais	:= len(aFiliais)
Local lTemReq	:= .F.

dbSelectArea("JBF")

//Verifica se jah passou pela tabela. Para garantir a nao geracao de dados repetidos nas tabelas JBF, JBG e JC3.
If !lExistJBF .or. RetSQLName("JBF") $ cEmps
	RestArea(aAreaAnt)
	Return
Else
	cEmps += "|"+RetSQLName("JBF")+"|"
Endif

for nFil := 1 to nFiliais
	if nFil == nFiliais
		cFiliais += "'"+aFiliais[nFil]+"'"
	else
		cFiliais += "'"+aFiliais[nFil]+"', "
	endif
next nFil

if nFiliais == 0
	cFiliais += "'  '"
endif

//Verifica se o Requerimento jah foi incluido na base. Para Garantir que o Requerimento
//nao seja inluido de novo caso o Atualizador seja executado mais de uma vez.
lTemReq := GETemReq(cFiliais)

if lTemReq //Se jah existe o Requerimento na Base nao inclui de novo.
	RestArea(aAreaAnt)
	Return
endif

//Regras do Script
aAdd( aScript, {"Curso Atual",       6, "1", 'Posicione("JBE",3,xFilial("JBE") +"1"+SubStr(M->JBH_CODIDE,1,15),"JBE_CODCUR")', 'NaoVazio() .and. ACFilCurOri(.T.)', 'nOpc == 3', "1", '01,02|02,03|03,04|04,05|05,06|06,07|07,08|08,09|09,12', "", "J19001", "J19001"})
aAdd( aScript, {"Descricao",        40, "2", 'Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_DESC")', "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Periodo Atual",     2, "2", 'JBE->JBE_PERLET', "", '.F.', "2", "", ".F.", "" , ""})
aAdd( aScript, {"Habilitacao",       6, "2", 'JBE->JBE_HABILI', "", '.F.', "2", "", ".F.", "JDK", ""})
aAdd( aScript, {"Descricao",        60, "2", 'Posicione("JDK",1,xFilial("JDK")+JBE->JBE_HABILI,"JDK_DESC")', "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Turma Atual",       3, "2", 'JBE->JBE_TURMA', "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Sub-Turma Atual",   3, "2", 'IIf(JBE->(FIELDPOS("JBE_SUBTUR"))>0,JBE->JBE_SUBTUR,"")', "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Ano",               4, "2", 'Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_ANOLET")', "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Semestre",          2, "2", 'Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_PERIOD")', "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Telefone",         15, "2", 'Posicione("JA2",1,xFilial("JA2")+JBE->JBE_NUMRA,"JA2_FRESID")', "", '.F.', "1", "", ".F.", "", ""})
aAdd( aScript, {"Filial Destino",    2, "1", "", "U_SEC0022K()", 'nOpc == 3', "2", "", "nOpc == 3", "XM0", ""})
aAdd( aScript, {"Desc. Fil. Dest.", 35, "2", "", "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Unidade",           6, "2", "", "U_SEC0022J()", 'nOpc == 3', "1", '12,02|13,03', "nOpc == 3", "JA3002", "JA3002"})
aAdd( aScript, {"Descricao",        30, "2", "", "", '.F.', "2", "", "nOpc == 3", ".F.", "", ""})
aAdd( aScript, {"Curso Desejado",    6, "1", "", "U_SEC0022I()", 'nOpc == 3', "1", '14,02|15,03|16,04', "nOpc == 3", "J13001", "J13001"})
aAdd( aScript, {"Descricao",        40, "2", "", "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Versao",            3, "2", "", "", '.F.', "2", "", ".F.", "", ""})
aAdd( aScript, {"Tipo Transferencia",3, "1", "", 'NaoVazio() .and. !Empty(U_ACScpAtrib( "19", "Tabela( '+"'FL'"+', M->JBH_SCP18, .T. )" ))', "", "1", '17,02|18,03', ".F.", "FL", "FL"})
aAdd( aScript, {"Descricao",        30, "2", "", "", '.F.', "2", "", ".F.", "", ""})

dbSelectArea("JBF")
dbSelectArea("JBG")
dbSelectArea("JC3")

for nFil := 1 to nFiliais

	//JBF - HEADER CONF. DE REQUERIMENTOS
	RecLock("JBF", .T.)
	JBF->JBF_FILIAL := aFiliais[nFil]
	JBF->JBF_COD	:= cNumReq
	JBF->JBF_DESC	:= "TRANSFERENCIA DE FILIAL"
	JBF->JBF_VERSAO	:= "01"
	JBF->JBF_GRPDOC	:= ""
	JBF->JBF_CODPRO	:= ""
	JBF->JBF_TEMPO	:= "192:00"
	JBF->JBF_DUTEIS	:= "1"
	JBF->JBF_VALDE	:= dDataBase
	//JBF->JBF_VALATE	:= 
	JBF->JBF_DIASC	:= 0
	JBF->JBF_VALOR	:= 0
	JBF->JBF_REGVAL	:= ""
	JBF->JBF_DOCUM	:= "\SAMPLES\DOCUMENTS\GE\PROTOCOLO ALUNO.DOT"
	JBF->JBF_REGDOC	:= "U_ReqPGeral()"
	JBF->JBF_DISPON	:= "1"
	JBF->JBF_AGVAGA	:= "1"
	JBF->JBF_TRANSF	:= "1"
	JBF->JBF_ALTQTD	:= "1"
	JBF->JBF_FUNCIO	:= "2"
	JBF->JBF_ALUNO	:= "1"
	JBF->JBF_CANDID	:= "2"
	JBF->JBF_EXTERN	:= "2"
	JBF->JBF_REGRA1	:= "U_ACInicTrf(1,3,4,6,7,11,15,17)"
	JBF->JBF_WREGVA	:= ""
	JBF->JBF_REGRA2	:= "ACTransfere( 15, , , , 01, 03, 04, 06, , 18, , , 07, , 11 )"
	JBF->JBF_SCPVAL	:= "Iif(Inclui,U_ACTitPago(M->JBH_SCP01,M->JBH_SCP03,.F.),.T.)"
	JBF->JBF_REGWEB	:= ""
	JBF->JBF_WSCPV	:= ""
	JBF->JBF_REGCON	:= "U_ACRegCon()"
	JBF->JBF_REGGRA	:= ""
	JBF->JBF_VERATU	:= "1"
	JBF->( MsUnLock() )
	
	
	//JBG - ITENS CONF. DE REQUERIMENTOS (Departamentos)
	for nInd := 1 to 4
	
		RecLock("JBG", .T.)
		JBG->JBG_FILIAL	:= aFiliais[nFil]
		JBG->JBG_COD	:= cNumReq
		JBG->JBG_VERSAO	:= "01"
		JBG->JBG_ORDEM	:= StrZero(nInd,2)
		JBG->JBG_TEMPO	:= "048:00"
		//JBG->JBG_MEMO1 := 
		
		if nInd == 4
			JBG->JBG_CODDEP	:= 'U_ACCODDEP("003")'
			JBG->JBG_DOCUM 	:= "\SAMPLES\DOCUMENTS\GE\SEC0022.DOT"
			JBG->JBG_REGRA	:= "U_ACAGradeOK() .and. U_ACAnalise(.T.)"
			JBG->JBG_REGPRC	:= "U_ACFimOrig( 01, 03, 04, 06, 18 )"
		else
			JBG->JBG_CODDEP	:= 'U_ACCODDEP("001")'
			JBG->JBG_DOCUM 	:= ""
			JBG->JBG_REGRA	:= ""
			JBG->JBG_REGPRC	:= "U_ACAtuSta1()"
		endif
		JBG->( MsUnLock() )
	
	next nInd
	
	//JC3 - TIPO REQUERIMENTO X PERGUNTAS (Script do Requerimento)
	for nInd := 1 to 19
		RecLock("JC3", .T.)
		JC3->JC3_FILIAL	:= aFiliais[nFil]
		JC3->JC3_COD	:= cNumReq
		JC3->JC3_VERSAO	:= "01"
		JC3->JC3_SEQ	:= StrZero(nInd,2)
		JC3->JC3_PERG	:= aScript[nInd][1]
		JC3->JC3_TIPO	:= "1"
		JC3->JC3_TAM	:= aScript[nInd][2]
		JC3->JC3_DEC	:= 0
		JC3->JC3_PICT	:= "@!"
		JC3->JC3_TPSCRE	:= "3"
		JC3->JC3_OBRIG	:= aScript[nInd][3]
		JC3->JC3_RELAC	:= aScript[nInd][4]
		JC3->JC3_CBOX	:= ""
		JC3->JC3_VALID	:= aScript[nInd][5]
		JC3->JC3_WHEN	:= aScript[nInd][6]
		JC3->JC3_WEB	:= aScript[nInd][7]
		JC3->JC3_WREGRA	:= aScript[nInd][8]
		JC3->JC3_WVALID	:= ""
		JC3->JC3_WWHEN	:= aScript[nInd][9]
		JC3->JC3_WF3ORD	:= ""
		JC3->JC3_F3		:= aScript[nInd][10]
		JC3->JC3_WF3	:= aScript[nInd][11]
		JC3->( MsUnLock() )
	next nInd

next nFil

RestArea(aAreaAnt)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETemReq  ºAutor  ³Alberto Deviciente  º Data ³ 16/Jan/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o Requerimento jah foi incluido na base.        º±±
±±º          ³Para Garantir que o Requerimento nao seja inluido de novo   º±±
±±º          ³caso o Atualizador seja executado mais de uma vez.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³UpdGe22                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GETemReq(cFilIn)
Local aAreaAnt	:= GetArea()
Local cAlias    := GetNextAlias()
Local cQuery 	:= ""
Local lRet 		:= .F.
Local nTotReg	:= 0

cQuery :=  "SELECT JBF_COD "
cQuery += "  FROM "+ RetSQLName("JBF")
cQuery += " WHERE JBF_FILIAL in ("+cFilIn+") "
cQuery += "   AND JBF_DESC	 = 'TRANSFERENCIA DE FILIAL' "
cQuery += "   AND JBF_REGRA1 = 'U_ACInicTrf(1,3,4,6,7,11,15,17)' "
cQuery += "   AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery), cAlias, .T., .T. )

dbGoTop()
count to nTotReg
dbGoTop()

if nTotReg > 0
	lRet := .T.
endif

(cAlias)->( dbCloseArea() )

RestArea(aAreaAnt)
  
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEExclSXE ºAutor  ³Alberto Deviciente  º Data ³ 16/Jan/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui o controle de numeracao do SXE e SXF da tabela JBF   º±±
±±º          ³para que seja recriado pela rotina de Conf. de Requerimentosº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³UpdGe22                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GEExclSXE()
Local aAreaAnt	:= GetArea()

//Exclui para todas as filiais que encontrar
dbUseArea(.T.,,"SXE","SXE",.F.)
SXE->( dbGoTop() )
While SXE->( !eof() )
	if SXE->XE_ALIAS == "JBF"
		RecLock( "SXE", .F. )       
		SXE->( dbDelete() )
		SXE->( msUnlock() )
	endif
	SXE->( dbSkip() )
end
SXE->( dbCloseArea() )

dbUseArea(.T.,,"SXF","SXF",.F.)
SXF->( dbGoTop() )
While SXF->( !eof() )
	if SXF->XF_ALIAS == "JBF"
		RecLock( "SXF", .F. )       
		SXF->( dbDelete() )
		SXF->( msUnlock() )
	endif
	SXF->( dbSkip() )
end
SXF->( dbCloseArea() )

RestArea(aAreaAnt)

Return
