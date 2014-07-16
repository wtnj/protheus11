/*                                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NHEST116  ³ Autor ³ João Felipe da Rosa    Data ³ 15/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Grupos de Produto                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rdmake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP			                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#include "Topconn.ch"
#include "font.ch"

User Function NHEST116()

axCadastro("ZAQ")

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := OemToAnsi("Programação de Entregas")
aRotina := {{ "Pesquisa"	,"AxPesqui"     , 0 , 1},;
            { "Visualizar"	,'U_fEST116(1)'	, 0 , 2},;
            { "Incluir"   	,'U_fEST116(2)' , 0 , 3},;
            { "Alterar"   	,'U_fEST116(3)' , 0 , 5},;
            { "Excluir"   	,'U_fEST116(4)'	, 0 , 4}}

mBrowse( 6, 1,22,75,"ZAQ",,,,,,)
Return                          

User Function fEST116(_nParam)
_nPar   := _nParam
_cCod   := Space(6)
_cGrupo := Space(30)
		
	If _nPar <> 2 //Visualizar/Alterar/Excluir
		_cCod   := ZAQ->ZAQ_COD
		_cGrupo := ZAQ->ZAQ_GRUPO
	EndIf
	
	If _nPar == 2 //Incluir
		_cCod := GetSXENum("ZAQ","ZAQ_COD")
	EndIf

	DEFINE FONT oFont NAME "Arial" SIZE 12, -12
	
	Define MsDialog oDialog Title OemToAnsi("Grupo de Produtos") From 000,000 To 140,300 Pixel
	@ 015,015 Say "Código: " Size 040,8
	@ 015,040 Say _cCod	Size 040,8 Object oCod
	oCod:SetFont(oFont)
	@ 030,015 Say "Grupo: " Size 040,8
	@ 030,040 Get _cGrupo Picture "@!" When(_nPar == 2 .OR. _nPar == 3) Size 100,8
    
	@ 050,070 BMPBUTTON TYPE 01 ACTION fOk()
	@ 050,110 BMPBUTTON TYPE 02 ACTION fEnd()

	Activate MsDialog oDialog Center	

Return

Static Function fOk()
Local cQuery

If _nPar == 1 //visualizar
	Close(oDialog)
EndIf		

If _nPar == 2 //Incluir
	ZAQ->(DbSetOrder(1))// filial + cod
	ZAQ->(DbSeek(xFilial("ZAQ")+_cCod))
	If ZAQ->(Found())
		MsgAlert(OemToAnsi("Código já existe. Entre em contato com seu Administrador de Sistema."))
		Close(oDialog)
	EndIf
	RecLock("ZAQ",.T.)
		ZAQ->ZAQ_FILIAL := xFilial("ZAQ")
		ZAQ->ZAQ_COD    := _cCod
		ZAQ->ZAQ_GRUPO  := _cGrupo
	MsUnLock("ZAQ")
	ConfirmSX8()		
	Close(oDialog)
EndIf

If _nPar == 3 //Alterar

	RecLock("ZAQ",.F.)
		ZAQ->ZAQ_GRUPO  := _cGrupo
	MsUnLock("ZAQ")
	Close(oDialog)		

EndIf

If _nPar == 4 //Excluir
	cQuery := "SELECT TOP 1 * FROM "+RetSqlName("SB1")
	cQuery += " WHERE B1_GRPPROD = '"+ ZAQ->ZAQ_COD+"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	If Empty(TRA1->B1_COD)
		If MsgYesNo("Tem certeza que deseja excluir o grupo?")
	    	RecLock('ZAQ',.F.)
        		ZAQ->(DbDelete())
			MsUnlock('ZAQ')
    	EndIf
		TRA1->(DbCloseArea())
		Close(oDialog)
	Else
		MsgAlert(OemToAnsi("Este grupo não pode ser excluído pois está sendo usado em algum produto. Verifique!"))
		TRA1->(DbCloseArea())
		Close(oDialog)
	EndIf
	
EndIf

Return

Static Function fEnd()

	RollBackSx8()
   	Close(oDialog) 

Return
