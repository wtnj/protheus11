#Include "Protheus.ch"
#Include "MsOle.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AC70Decl  ºAutor  ³Rafael Rodrigues    º Data ³  27/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao da declaracao de presenca no vestibular           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³AC70Decl()                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Acaa070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AC70Decl()
Local cEditor 	:= "TMsOleWord97"
Local oWord
Local nCopias 	:= 1
Local cPathSrv	:= GetMv("MV_ACDOCS")
Local cPathTer	:= GetMv("MV_ACDOCT")
Local cArquivo 	:= GetMv("MV_ACDECL")
Local aMeses 	:= { "Janeiro",  "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro" }
Local cAss		:= Space(6)
Local cFase		:= Space(3)
Local aFases	:= {}
Local nOpc		:= 0
Local oFase

JA6->( dbSetOrder(1) )
JA6->( dbSeek( xFilial("JAI")+M->JA1_PROSEL ) )

JAI->( dbSetOrder(1) )
JAI->( dbSeek( xFilial("JAI")+JA6->JA6_CODIGO ) )

while JAI->( !eof() ) .and. JAI->JAI_FILIAL+JAI->JAI_CODIGO == xFilial("JAI")+JA6->JA6_CODIGO
	aAdd( aFases, JAI->JAI_FASE )
	JAI->( dbSkip() )
end

if !Empty( aFases )
	cFase := aFases[1]
endif

If File(cPathTer+cArquivo)
	FErase(cPathTer+cArquivo)
endif

If File( cPathSrv+cArquivo )
	CpyS2T( cPathSrv+cArquivo, cPathTer, .T. )
Else
	Help("",1,"ACAA070_02")	// o arquivo do word nao foi encontrado
	Return
Endif

define msDialog oDlg title "Informações" from 0,0 to 180,280 pixel

	@ 10,10 Say "Assinante"	Size 50,8 of oDlg pixel
	@ 25,10 Say "Fase"		Size 50,8 of oDlg pixel
	@ 10,65 msGet cAss F3 "SRA" Size 60,8 of oDlg pixel
	@ 25,65 ComboBox oFase var cFase items aFases Size 60,8 of oDlg pixel
	define sButton oBt1 from 70,010 type 1 action ( nOpc := 1, oDlg:End() ) enable of oDlg pixel
	define sButton oBt1 from 70,050 type 2 action oDlg:End() enable of oDlg pixel

activate dialog oDlg center

if nOpc == 0
	Return
endif

JAI->( dbSetOrder(1) )
JAI->( dbSeek( xFilial("JAI")+JA6->JA6_CODIGO+cFase ) )

SRA->( dbSetOrder(1) )
SRA->( dbSeek( xFilial("SRA")+cAss ) )

SRJ->( dbSetOrder(1) )
SRJ->( dbSeek( xFilial("SRJ")+SRA->RA_CODFUNC ) )

oWord := OLE_CreateLink( cEditor )
OLE_SetProperty( oWord, oleWdVisible,   .F. )
OLE_SetProperty( oWord, oleWdPrintBack, .F. )

OLE_OpenFile( oWord, cPathTer+cArquivo, .F. )

// Atualiza os campos.
OLE_SetDocumentVar( oWord, "Aca_NomeCand", Alltrim(M->JA1_NOME) )
OLE_SetDocumentVar( oWord, "Aca_Processo", Alltrim(JA6->JA6_DESC) )
OLE_SetDocumentVar( oWord, "Aca_Data", StrZero( Day( JAI->JAI_DTNOR ), 2 )+" de "+aMeses[ Month( JAI->JAI_DTNOR ) ]+" de "+StrZero( Year( JAI->JAI_DTNOR ), 4 ) )
OLE_SetDocumentVar( oWord, "Aca_Hora", Alltrim(JAI->JAI_HRNDE) )
OLE_SetDocumentVar( oWord, "Aca_Nome", Alltrim(SRA->RA_NOME) )
OLE_SetDocumentVar( oWord, "Aca_Cargo", Alltrim(SRJ->RJ_DESC) )

OLE_UpdateFields( oWord )
Sleep(5000)
OLE_PrintFile( oWord, "ALL",,, nCopias )
Sleep(5000)
OLE_SetProperty( oWord, oleWdVisible, .F. )

OLE_CloseFile( oWord )
OLE_CloseLink( oWord )

Return
