/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST092  ºAutor  ³Marcos R Roquitski  º Data ³  25/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Lista de Ferramentas.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhest092()

SetPrvt("aRotina,cCadastro,_cList,_cOperc")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fListF01()",0,4} }
             

cCadastro := "Cadastro de Produtos"

mBrowse(,,,,"SB1",,,)

Return



User Function fListF01()

Private cCadastro := "Cadastro de Lista de Ferramentas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                     {"Visualizar","AxVisual",0,2} ,;
                     {"Incluir","AxInclui",0,3} ,;
                     {"Ferramentas","U_fListF02()",0,4} }
             
DbSelectArea("ZA7")
SET FILTER TO ZA7->ZA7_PRODUT == SB1->B1_COD  
ZA7->(DbGotop())

mBrowse(,,,,"ZA7",,,)

SET FILTER TO 
ZA7->(DbGotop())

DbSelectArea("SB1")
Return(.T.)


User Function fListF02()

Private cCadastro := "Cadastro de Lista de Ferramentas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                     {"Visualizar","AxVisual",0,2} ,;
                     {"Incluir","AxInclui",0,3} ,;
                     {"Alterar","AxAltera",0,4} ,;
                     {"Excluir","AxDeleta",0,5} ,;
                     {"Desenho","U_fMostLst()",0,5} }


_cList  := ZA7->ZA7_LF
_cOperc := ZA7->ZA7_OPERAC
             
DbSelectArea("ZA7")
SET FILTER TO
ZA7->(DbGotop())

SET FILTER TO ZA7->ZA7_LF + ZA7->ZA7_OPERAC == _cList + _cOperc
ZA7->(DbGotop())

mBrowse(,,,,"ZA7",,,)

DbSelectArea("SB1")
RecLock("SB1",.F.)
SB1->B1_LISTFER := "S"
MsUnlock("SB1")
	
Return(.T.)

                                           

User Function fMostWan()
Local cMvSave := "CELEWIN400"  
Local oWord
Local lView   := GetMv( "MV_QDVIEW" ) 
Local cEditor := Space(12)
Local cArqtmp
Local cPView  := Alltrim( GetMv( "MV_QDPVIEW" ) )
Local cLinha  := ""  
Local nRecebe
Local lAchou  := .F.
Local aQPath     := QDOPATH()
Local cQPath     := aQPath[1]

Alert(cQPath)

QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+ZA7->ZA7_FER)) //  + ZA7->ZA7_FERRV))	        
While QDH->QDH_DOCTO = ZA7->ZA7_FER
	lAchou := .T.
	QDH->(DbSkip())
Enddo


If lAchou
	
	QDH->(DbSkip(-1))

	cQArqtmp := "\ap8\ap_data\sigaadv\docs\"+Alltrim(QDH->QDH_NOMDOC)

	If Alltrim(QDH->QDH_DTOIE) == "I"

		oWord := OLE_CreateLink( cEditor )

		OLE_SetProperty( oWord, oleWdVisible,   .f. )
		OLE_SetProperty( oWord, oleWdPrintBack, .F. )   
		OLE_OpenFile( oWord, cQArqTmp, .F., cMvSave, cMvSave )

	  	OLE_UpdateFields( oWord )
	  	OLE_SaveFile( oWord )
		OLE_CloseFile( oWord )
	  	
		If lView == "S"
	   		OLE_CloseLink( oWord )
			cLinha := "ADVVIEW "+cPView+"WORDVIEW "+cQArqTmp+" WORDVIEW"
			nRecebe := WaitRun( cLinha )
		Else
			OLE_SetProperty( oWord, oleWdVisible,   .T. )
			OLE_SetProperty( oWord, oleWdPrintBack, .T. )
			OLE_OpenFile( oWord, cQArqTmp, .T., cMvSave, cMvSave )	
		Endif
	Else
		ShellExecute( "open", cQArqtmp, "", "",5 )
	
	Endif    
    
Else
	MsgBox("Documento nao encontrado!","Cadastro de documento","STOP")
Endif

Return
	