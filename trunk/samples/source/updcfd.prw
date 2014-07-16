#Include "Protheus.ch"
#define X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#define X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"
#define X3_USADO_NAOALTERA "€€€€€€€€€€€€€€° "		//Nao permite alteracao do campo
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UPDCFD    ³ Autor ³Marcello               ³ Data ³10/01/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Programa de atualizacao das tabelas para o uso de comprova- ³±±
±±³          ³tes fiscais digitais - Mexico                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CFD                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UpdCFD

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
//
PRIVATE cDirCFD := "\cfd"
PRIVATE cDirIni := "\inicfd\"
PRIVATE cDirFac := "\facturas\"
PRIVATE cDirChv := "\llaves\"
PRIVATE cArqSF1 := "fatemex.ini"
PRIVATE cArqSF2 := "fatsmex.ini"

Set Dele On

lHistorico 	:= MsgYesNo("Desea actualizar las tablas para el uso de Comprobantes Fiscales Digitales ? Esta rutina debe ser utilizada en modo exclusivo ! Haga una copia de los diccionarios y de la base de Datos antes de actualizar los archivos para eventuales fallas de actualizacion !", "Atencion !")
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Comprobantes Fiscales Digitais" BORDER SINGLE
ACTIVATE WINDOW oMainWnd ;
	ON INIT If(lHistorico,(Processa({|lEnd| FISProc(@lEnd)},"Procesando","Aguarde , Preparando archivos",.F.), MsgAlert("Proceso efectuado.!","Atencion!"), oMainWnd:End() ), oMainWnd:End() )
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

Local cTexto    := ''
Local cFile     :=""
Local nRecno    := 0
Local nI        := 0
Local nX		:= 0
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

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI]))
			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
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
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			ACTIVATE MSDIALOG oDlg CENTERED
	
			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 

		Next nI 

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
//³ SFP                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCpos := {"FP_FILIAL","FP_ESPECIE","FP_ATIVO"}  //campos no utilizados
Aadd(aSX3,{"SFP",;				//Arquivo
	"ZZ",;						//Ordem
	"FP_NRCERT",;				//Campo
	"C",;						//Tipo
	20,;						//Tamanho
	0,;							//Decimal
	"Certificado",;				//Titulo
	"Certificado",;				//Titulo SPA
	"Certificado",;				//Titulo ENG
	"Nr.Serie Certificado",;	//Descricao
	"Nr.Serie Certificado",;	//Descricao SPA
	"Nr.Serie Certificado",;	//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO,;			//USADO
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SF2                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Numero de aprobacion
Aadd(aSX3,{"SF2",;				//Arquivo
	"ZZ",;						//Ordem
	"F2_APROFOL",;				//Campo
	"C",;						//Tipo
	10,;						//Tamanho
	0,;							//Decimal
	"Nr.Aprobacion",;			//Titulo
	"Nr.Aprobacion",;			//Titulo SPA
	"Nr.Aprobacion",;			//Titulo ENG
	"Nr. aprobacion folio",;	//Descricao
	"Nr. aprobacion folio",;	//Descricao SPA
	"Nr. aprobacion folio",;	//Descricao ENG
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
Aadd(aSX3,{"SF2",;				//Arquivo
	"ZZ",;						//Ordem
	"F2_CERTFOL",;				//Campo
	"C",;						//Tipo
	20,;						//Tamanho
	0,;							//Decimal
	"Nr.Certif.",;				//Titulo
	"Nr.Certif.",;				//Titulo SPA
	"Nr.Certif.",;				//Titulo ENG
	"Nr. certificado folios",;	//Descricao
	"Nr. certificado folios",;	//Descricao SPA
	"Nr. certificado folios",;	//Descricao ENG
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SF1                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Numero de aprobacion
Aadd(aSX3,{"SF1",;				//Arquivo
	"ZZ",;						//Ordem
	"F1_APROFOL",;				//Campo
	"C",;						//Tipo
	10,;						//Tamanho
	0,;							//Decimal
	"Nr.Aprobacion",;			//Titulo
	"Nr.Aprobacion",;			//Titulo SPA
	"Nr.Aprobacion",;			//Titulo ENG
	"Nr. aprobacion folio",;	//Descricao
	"Nr. aprobacion folio",;	//Descricao SPA
	"Nr. aprobacion folio",;	//Descricao ENG
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
Aadd(aSX3,{"SF1",;				//Arquivo
	"ZZ",;						//Ordem
	"F1_CERTFOL",;				//Campo
	"C",;						//Tipo
	20,;						//Tamanho
	0,;							//Decimal
	"Nr.Certif.",;				//Titulo
	"Nr.Certif.",;				//Titulo SPA
	"Nr.Certif.",;				//Titulo ENG
	"Nr. certificado folios",;	//Descricao
	"Nr. certificado folios",;	//Descricao SPA
	"Nr. certificado folios",;	//Descricao ENG
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SF3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Numero de aprobacion
Aadd(aSX3,{"SF3",;				//Arquivo
	"ZZ",;						//Ordem
	"F3_APROFOL",;				//Campo
	"C",;						//Tipo
	10,;						//Tamanho
	0,;							//Decimal
	"Nr.Aprobacion",;			//Titulo
	"Nr.Aprobacion",;			//Titulo SPA
	"Nr.Aprobacion",;			//Titulo ENG
	"Nr. aprobacion folio",;	//Descricao
	"Nr. aprobacion folio",;	//Descricao SPA
	"Nr. aprobacion folio",;	//Descricao ENG
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
	"F3_CERTFOL",;				//Campo
	"C",;						//Tipo
	20,;						//Tamanho
	0,;							//Decimal
	"Nr.Certif.",;				//Titulo
	"Nr.Certif.",;				//Titulo SPA
	"Nr.Certif.",;				//Titulo ENG
	"Nr. certificado folios",;	//Descricao
	"Nr. certificado folios",;	//Descricao SPA
	"Nr. certificado folios",;	//Descricao ENG
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
dbSetOrder(1)
DbSeek("SFP")
While X3_ARQUIVO == "SFP"
	RecLock("SX3",.F.)
	If Ascan(aCpos,AllTrim(X3_CAMPO)) == 0
		Replace X3_USADO	With X3_USADO_EMUSO
		Replace X3_BROWSE	With "S"
	Else
		Replace X3_USADO With X3_USADO_NAOUSADO
		Replace X3_BROWSE	With "N"
		IncProc("Actualizando Diccionario de Datos...")
	Endif
	MsUnLock()
	DbSkip()
Enddo
dbSetOrder(2)
cTexto += "Actualizacion de la tabla SFP " + CRLF
Aadd(aArqUpd,"SFP")
If DbSeek("FP_SERIE")
	cTexto += "    Actualizacion del campo FP_SERIE" + CRLF	
	RecLock("SX3",.F.)
	Replace X3_VALID	With 'ExistCpo("SX5","01"+M->FP_SERIE)'
	MsUnLock()
Endif
If DbSeek("FP_CAI")
	cTexto += "    Actualizacion del campo FP_CAI" + CRLF	
	RecLock("SX3",.F.)
	Replace X3_PICTURE	With "@!"
	Replace X3_TITULO 	With "Nr.Aprov."
	Replace X3_TITSPA 	With "Nr.Aprov."
	Replace X3_TITENG 	With "Nr.Aprov."
	Replace X3_DESCRIC	With "Numero aprovacion folios"
	Replace X3_DESCSPA	With "Numero aprovacion folios"
	Replace X3_DESCENG	With "Numero aprovacion folios"
	MsUnLock()
Endif
If DbSeek("FP_NUMINI")
	RecLock("SX3",.F.)
	cTexto += "    Actualizacion del campo FP_NUMINI" + CRLF	
	Replace X3_TAMANHO	With TamSX3("F2_DOC")[1]
	MsUnLock()
Endif
If DbSeek("FP_NUMFIM")
	RecLock("SX3",.F.)
	cTexto += "    Actualizacion del campo FP_NUMFIM" + CRLF	
	Replace X3_TAMANHO	With TamSX3("F2_DOC")[1]
	MsUnLock()
Endif
cTexto += "Actualizacion de la tabla SA1 " + CRLF
Aadd(aArqUpd,"SA1")
If DbSeek("A1_PAIS")
	RecLock("SX3",.F.)
	cTexto += "    Actualizacion del campo A1_PAIS" + CRLF	
	Replace X3_USADO	With X3_USADO_EMUSO
	MsUnLock()
Endif
If DbSeek("A1_PAISDES")
	RecLock("SX3",.F.)
	cTexto += "    Actualizacion del campo A1_PAISDES" + CRLF	
	Replace X3_USADO	With X3_USADO_EMUSO
	MsUnLock()
Endif
cTexto += "Actualizacion de la tabla SA2 " + CRLF
Aadd(aArqUpd,"SA2")
If DbSeek("A2_PAIS")
	RecLock("SX3",.F.)
	cTexto += "    Actualizacion del campo A2_PAIS" + CRLF	
	Replace X3_USADO	With X3_USADO_EMUSO
	MsUnLock()
Endif
If DbSeek("A2_PAISDES")
	RecLock("SX3",.F.)
	cTexto += "    Actualizacion del campo A2_PAISDES" + CRLF	
	Replace X3_USADO	With X3_USADO_EMUSO
	MsUnLock()
Endif
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
				"X6_CONTEUD",;
				"X6_CONTSPA",;
				"X6_CONTENG",;
				"X6_PROPRI",;
				"X6_PYME"}

cTexto += "Actualizacion del archivo de parametros" + CRLF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDUSO                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDUSO",;
			"C",;
			"Geracao de documentos eletronicos",;
			"Generacion de documentos electronicos",;
			"Generacion de documentos electronicos",;
			"1",;
			"1",;
			"1",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDDIRS                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDDIRS",;
			"C",;
			"Diretorio com as chaves privada e publica",;
			"Directorio con las llaves privada y publica",;
			"Directorio con laa llaves privada y publica",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirChv+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirChv+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirChv+"'",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDARQS                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDARQS",;
			"C",;
			"Arquivo com a chave privada",;
			"Archivo con la llave privada",;
			"Archivo con la llave privada",;
			"",;
			"",;
			"",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDCPUB                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDCPUB",;
			"C",;
			"Arquivo com a chave publica",;
			"Archivo con la llave publica",;
			"Archivo con la llave publica",;
			"",;
			"",;
			"",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDDOCS                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDDOCS",;
			"C",;
			"Local onde serao gravados os cfd's",;
			"Indica donde los cfd's seran grabados",;
			"Indica donde los cfd's seran grabados",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirFac+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirFac+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirFac+"'",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDFTS                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDFTS",;
			"C",;
			"Indica o local e o arquivo para geracao do cfd",;
			"Indica el path y archivo para generacion del cfd",;
			"Indica el path y archivo para generacion del cfd",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirIni+cArqSF2+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirIni+cArqSF2+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirIni+cArqSF2+"'",;
			"S",;
			"S"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MV_CFDFTE                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSX6,{	"  ",;
			"MV_CFDFTE",;
			"C",;
			"Indica o local e o arquivo para geracao do cfd",;
			"Indica el path y archivo para generacion del cfd",;
			"Indica el path y archivo para generacion del cfd",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirIni+cArqSF1+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirIni+cArqSF1+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirIni+cArqSF1+"'",;
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
	cTexto += "    documentos: " + cDirCFD + cDirFac
	If !ExistDir(cStartP+cDirCFD+cDirFac)
		If MakeDir(cStartP+cDirCFD+cDirFac) <> 0 
			cTexto += "    (ERROR)"
		Endif
	Endif
	cTexto +=   + CRLF
	cTexto += "    estructura de documentos: " + cDirCFD + cDirIni
	If !ExistDir(cStartP+cDirCFD+cDirIni)
		If MakeDir(cStartP+cDirCFD+cDirIni) <> 0
			cTexto += "    (ERROR)"
		Endif
	Endif
	cTexto +=   + CRLF
	cTexto += "    archivos llaves: " + cDirCFD + cDirChv
	If !ExistDir(cStartP + cDirCFD + cDirChv)
		If MakeDir(cStartP+cDirCFD+cDirChv) <> 0
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
