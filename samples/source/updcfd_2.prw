#Include "Protheus.ch"
#define X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#define X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"
#define X3_USADO_NAOALTERA "€€€€€€€€€€€€€€° "		//Nao permite alteracao do campo
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDCFD_2  ³ Autor ³Marcello               ³ Data ³10/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Programa de atualizacao das tabelas para o uso de comprova- ³±±
±±³          ³tes fiscais digitais - Mexico                               ³±±
±±³          ³                                                            ³±±
±±³          ³COMPLEMENTO DO PROGRAMA UPDCFD                              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CFD                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdCFD_2

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
//
PRIVATE cDirCFD := "\cfd"
PRIVATE cDirAnul:= "\anuladas\"

Set Dele On

lHistorico 	:= MsgYesNo("Desea actualizar las tablas para el uso de Comprobantes Fiscales Digitales ? Esta rutina debe ser utilizada en modo exclusivo ! Haga una copia de los diccionarios y de la base de Datos antes de actualizar los archivos para eventuales fallas de actualizacion !", "Atencion !")
lEmpenho	:= .F.
lAtuMnu		:= .F.
DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Comprobantes Fiscales Digitais" BORDER SINGLE
ACTIVATE WINDOW oMainWnd ;
ON INIT If(lHistorico,(Processa({|lEnd| FISProc(@lEnd)},"Procesando","Aguarde , Preparando archivos",.F.), oMainWnd:End() ), oMainWnd:End() )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FISProc   ³ Autor ³Marcello               ³ Data ³10/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao dos arquivos            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FisProc(lEnd)

Local cTexto    := ""
Local cFile     := ""
Local cAmbiente := ""
Local nRecno    := 0
Local nI        := 0
Local nX		:= 0
Local nNCFD		:= 0
Local aRecnoSM0 := {}     
Local lOpen     := .F. 

ProcRegua(1)
IncProc("Verificando la integridad de los diccionarios....")
If MyOpenSm0Ex()
	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		Aadd(aRecnoSM0,SM0->(RECNO()))
		dbSkip()
	EndDo
	For nI := 1 To Len(aRecnoSM0)
		SM0->(dbGoto(aRecnoSM0[nI]))
		RpcSetType(2)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		RpcClearEnv()
		If !( lOpen := MyOpenSm0Ex() )
			Exit
		EndIf
	Next nI
	
	nNCFD := 0
	cAmbiente := ""
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			
			If !UPD2Verif()
				nNCFD++
				cAmbiente += SM0->M0_CODIGO + "/" + SM0->M0_CODFIL + CRLF
			Else
				cTexto := Replicate("-",128)+CHR(13)+CHR(10)
				cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o dicionario de dados   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Verificando Diccionario de Datos...")
				cTexto += FISAtuSX3()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza o arquivo de parametros ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Verificando Archivo de parametros...")
				cTexto += FISAtuSX6()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Criando os diretorios            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IncProc("Verificando Archivo de parametros...")
				cTexto += FISAtuDir()
				
				ProcRegua(Len(aArqUpd))
				__SetX31Mode(.F.)
				For nX := 1 To Len(aArqUpd)
					IncProc("Actualizando estructuras. Aguarde... ["+aArqUpd[nx]+"]"+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
					If Select(aArqUpd[nx])>0
						dbSelecTArea(aArqUpd[nx])
						dbCloseArea()
					EndIf
					X31UpdTable(aArqUpd[nx])
					If __GetX31Error()
						Alert(__GetX31Trace())
						Aviso("Atencion!","Ocorrio un error en la actualizacion de la tabla : "+ aArqUpd[nx] + ". Verifique la integridad del diccionario y de la tabla.",{"Proseguir"},2)
						cTexto += "Ocorrio un error en la actualizacion de la tabla : "+aArqUpd[nx] +CHR(13)+CHR(10)
					EndIf
				Next nX
				cTexto := "Log de actualizacion de los CFD's"+CHR(13)+CHR(10)+cTexto
				__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
				DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
				DEFINE MSDIALOG oDlg TITLE "Proceso concluido" From 3,0 to 340,417 PIXEL
					@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
					oMemo:bRClicked := {||AllwaysTrue()}
					oMemo:lReadOnly := .T.
					oMemo:oFont:=oFont
					DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				ACTIVATE MSDIALOG oDlg CENTERED
				
				RpcClearEnv()
				If !( lOpen := MyOpenSm0Ex() )
					Exit
				EndIf
			Endif
		Next nI
		If nNCFD > 0
			cTexto := "Hay bases de datos que no estan preparadas para el uso de CFD. "
			ctexto += 'Se debe, primeramente, ejecutar el programa UPDCFD (vea el boletín técnico "Comprobantes Fiscales Digitales - Facturas Eletrónicas").' + CRLF + CRLF
			cTexto += "Las bases abajo no fueron actualizadas." + CRLF + CRLF
			ctexto += "Empresa" + CRLF + cAmbiente
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Proceso concluido" From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:lReadOnly := .T.
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
	Endif
Endif
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FISAtuSX3 ³ Autor ³ Marcello              ³ Data ³10/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX3                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FISAtuSX3()
Local aSX3   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local aCpos  := {}

aEstrut := { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
	"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
	"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
	"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SF3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Numero de aprobacion
Aadd(aSX3,{"SF3",;				//Arquivo
	"ZZ",;						//Ordem
	"F3_HORA",;					//Campo
	"C",;						//Tipo
	5,;							//Tamanho
	0,;							//Decimal
	"Hora",;					//Titulo
	"Hora",;					//Titulo SPA
	"Time",;					//Titulo ENG
	"Hora",;					//Descricao
	"Hora",;					//Descricao SPA
	"Time",;					//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_NAOUSADO,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	"",;						//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"",;						//PROPRI
	"N",;						//BROWSE
	"",;						//VISUAL
	"",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;						//CBOX
	"",;						//CBOX SPA
	"",;						//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	""})						//FOLDER
//Serie del certificado
Aadd(aSX3,{"SF3",;				//Arquivo
	"ZZ",;						//Ordem
	"F3_FIMP",;					//Campo
	"C",;						//Tipo
	1,;							//Tamanho
	0,;							//Decimal
	"Flag Impres.",;			//Titulo
	"Indica.Impr.",;			//Titulo SPA
	"Print Flag",;				//Titulo ENG
	"Flag de Impressao",;		//Descricao
	"Flag de Impresion",;		//Descricao SPA
	"Printing Flag",;			//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_NAOUSADO,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	"",;						//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"",;						//PROPRI
	"N",;						//BROWSE
	"",;						//VISUAL
	"",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;						//CBOX
	"",;						//CBOX SPA
	"",;						//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	""})						//FOLDER
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizacion del diccionario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
ProcRegua(Len(aSX3)+Len(aCpos))
dbSetOrder(2)
For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If Ascan(aArqUpd,aSX3[i,1]) == 0
			cTexto += "Actualizacion de la tabla " + aSX3[i,1] + CRLF
			Aadd(aArqUpd,aSX3[i,1])
		Endif
		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)
			cTexto += "    Creacion del campo " + aSX3[i,3] + CRLF
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
	IncProc("Actualizando Diccionario de Datos...")
Next i
Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FISAtuSX6 ³ Autor ³ Marcello              ³ Data ³11/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX6                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FISAtuSX6()
Local aEstrut := {}
Local aSX6   := {}
Local i      := 0
Local j      := 0
Local cTexto := ''

aEstrut :=	{	"X6_FIL",;
				"X6_VAR",;
				"X6_TIPO",;
				"X6_DESCRIC",;
				"X6_DSCSPA",;
				"X6_DSCENG",;
				"X6_DESC1",;
				"X6_DSCENG1",;
				"X6_DSCSPA1",;
				"X6_CONTEUD",;
				"X6_CONTSPA",;
				"X6_CONTENG",;
				"X6_PROPRI",;
				"X6_PYME"}

cTexto += "Actualizacion del archivo de parametros" + CRLF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDANUL                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDANUL",;
			"C",;
			"Local para onde serao movidos os cfd's",;
			"Indica para donde los cfd's anulados",;
			"Indica para donde los cfd's anulados",;
			"cancelados",;
			"seran movidos",;
			"seran movidos",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirAnul+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirAnul+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirAnul+"'",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDNAF2                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDNAF2",;
			"C",;
			"Padrao para nome dos arquivos gerados",;
			"Padron para el nombre de los archivos",;
			"Padron para el nombre de los archivos",;
			"para CFD's (SF2)",;
			"generados para CFD's (SF2)",;
			"generados para CFD's (SF2)",;
			"Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_'  + Lower(AllTrim(SF2->F2_DOC)) + '.xml'",;
			"Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_'  + Lower(AllTrim(SF2->F2_DOC)) + '.xml'",;
			"Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_'  + Lower(AllTrim(SF2->F2_DOC)) + '.xml'",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDNAF1                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDNAF1",;
			"C",;
			"Padrao para nome dos arquivos gerados",;
			"Padron para el nombre de los archivos",;
			"Padron para el nombre de los archivos",;
			"para CFD's (SF1)",;
			"generados para CFD's (SF1)",;
			"generados para CFD's (SF1)",;
			"Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_'  + Lower(AllTrim(SF1->F1_DOC)) + '.xml'",;
			"Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_'  + Lower(AllTrim(SF1->F1_DOC)) + '.xml'",;
			"Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_'  + Lower(AllTrim(SF1->F1_DOC)) + '.xml'",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizacion de los parametros³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX6")
ProcRegua(Len(aSX6))
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !dbSeek(aSX6[i,1]+aSX6[i,2])
		RecLock("SX6",.T.)
		cTexto += "    Creacion del parametro " + AllTrim(aSX6[i,2]) + CRLF
		For j:=1 To Len(aSX6[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	EndIf
	IncProc("Actualizando parametros...")
Next i
Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FISAtuDir ³ Autor ³ Marcello              ³ Data ³11/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao para criacao para armazenamento dos arquivos         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FISAtuDir()
Local cTexto := ""
Local nDir := 0
Local cStartP := ""

cStartP := GetSrvProfString("startpath","")
cTexto += "Directorios" + CRLF
cTexto += "    Principal: " + cDirCFD
If !ExistDir(cStartP + cDirCFD)
	nDir := MakeDir(cStartP+cDirCFD)
Else
	nDir := 0
Endif
If nDir == 0
	cTexto +=   + CRLF
	cTexto += "    documentos anulados: " + cDirCFD + cDirAnul
	If !ExistDir(cStartP+cDirCFD+cDirAnul)
		If MakeDir(cStartP+cDirCFD+cDirAnul) <> 0 
			cTexto += "    (ERROR)"
		Endif
	Endif
	cTexto +=   + CRLF
Else
	cTexto += "    (ERROR)"
	cTexto +=   + CRLF
Endif
Return(cTexto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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
	Aviso( "Atencion !", "No fue posible abrir la tabla de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CFDVERIF()³ Autor ³ Marcello              ³ Data ³12/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Verifica se a base ja esta preparada para o uso de CFD,     ³±±
±±³          ³isto e, com as alteracoes feitas pelo programa UPDCFD.      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPD2Verif()
Local lRet      := .T.
Local nE        := 0
Local nLen      := 0
Local aGerarCFD := {}

lRet := .F.
If FindFunction("CFDVerific")
	aGerarCFD := CFDVerific()
Else
	aGerarCFD := {"0"}
Endif
If aGerarCFD[1] <> "0"
	lRet := .T.
	nE := 0
	nLen := Len(aGerarCFD[2])
	While lRet .And. (nE < nLen)
		nE++
		lRet := (aGerarCFD[2,nE,1] $ "10/11/99")
	Enddo
Endif
Return lRet