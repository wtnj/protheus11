/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM036  ºAutor  ³Microsiga           º Data ³  13/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno pedido com residuo eliminado.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  

User Function Nhcom036()   

Local aGrupo 	:= {}
Local aIndexSC7	:= {}
Local aFixe     := {{ "Numero do PC","C7_NUM    " },;	//"Numero do PC"
			      	{ "Data Emissao","C7_EMISSAO" },;	//"Data Emissao"
  					{ "Fornecedor","C7_FORNECE" },;	    //"Fornecedor"
  					{ "Residuo","C7_RESIDUO" },; 	    //"Residuo"
  					{ "Produto","C7_PRODUTO" },; 	    //"Produto"
  					{ "Descricao","SUBSTR(C7_DESCRI,1,30)" }}  	    //"Descricao"

Local aCores    := {{ 'C7_RESIDUO=="S"', 'BR_MARRON'}}

PRIVATE aRotina := {{ "Pesquisar","PesqBrw", 0 , 1},;	//"Pesquisar"
					{ "Retorna Residuo","U_Retres()", 0 , 2}} //"Visualizar"

cCadastro := 'Compras/Eliminar Residuos'

DbSelectArea("SC7")
SC7->(DbSetOrder(1))
SET FILTER TO SC7->C7_RESIDUO = 'S' 
SC7->(DbGoTop())

mBrowse(,,,,"SC7",aFixe,,,,,aCores)

dbSelectArea("SC7")
dbSetOrder(1)
SET FILTER TO 
SC7->(DbGotop())

Return(.T.)
 

User Function Retres()
	If MsgBox("Retorno residuo Eliminado ? ","Residuo","YESNO")
		RecLock("SC7",.F.)
		SC7->C7_RESIDUO  := Space(01)
		MsUnlock("SC7")
	Endif
Return(.t.)
