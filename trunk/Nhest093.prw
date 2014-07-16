/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST093  ºAutor  ³Marcos R Roquitski  º Data ³  25/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta desenho de ferramentas.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"

User Function Nhest093()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Lista Ferramenta","U_fMlistFe()",0,4} ,;
             {"Pesquisar","AxPesqui",0,1} }

cCadastro := "Cadastro de Produtos"

DbSelectArea("SB1")
SET FILTER TO B1_LISTFER =='S'
SB1->(DbGotop())

mBrowse(,,,,"SB1",,,)

SET FILTER TO 
SB1->(DbGotop())

Return

User Function fMlistFe()
/*
Local aFixe := {{ "Lista de Ferramenta","ZA7_LF"},;
			   	{ "Revisao","ZA7_LFRV"},;
  				{ "Operacao","ZA7_OPERAC"},;
  				{ "Ferramenta","ZA7_FER"},;
  				{ "Revisao","ZA7_FERRV"},;
  				{ "Produto","ZA7_PRODUT"} }
*/
Private aRotina := { {"Desenho","U_fMostLst()",0,5},; 
                     {"Pesquisar","AxPesqui",0,1} }
             
Private cCadastro := "Cadastro de Lista de Ferramentas"
             
DbSelectArea("ZA7")
SET FILTER TO ZA7->ZA7_PRODUT == SB1->B1_COD  
ZA7->(DbGotop())

// mBrowse(,,,,"ZA7",aFixe,,)

mBrowse(,,,,"ZA7",,,)


SET FILTER TO 
ZA7->(DbGotop())

DbSelectArea("SB1")

Return
                                             

User Function fMostLst()
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
Local f          
Local cQPathD   := aQPath[2]
Local cQPathTrm := aQPath[3]
Local cTexto
Local cQPathf

//Alert(cQPath)

QDH->(DbSetOrder(1)) // Ultima revisao
QDH->(DbSeek(xFilial("QDH")+ZA7->ZA7_FER)) //  + ZA7->ZA7_FERRV))	        
While QDH->QDH_DOCTO = ZA7->ZA7_FER
	lAchou := .T.
	QDH->(DbSkip())
Enddo


If lAchou

	QDH->(DbSkip(-1))	

	
    cTexto := Alltrim(QDH->QDH_NOMDOC)
	If !File(cQPathTrm+cTexto)
		CpyS2T(cQPath+cTexto,cQPathTrm,.T.)
	EndIf
	QA_OPENARQ(cQPathTrm+cTexto)

Else
	MsgBox("Documento nao encontrado!","Cadastro de documento","STOP")
Endif

Return	
