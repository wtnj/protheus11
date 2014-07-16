/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³NHCOM040  ³ Autor ³ Marcos R Roquitski    ³ Data ³ 01/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±  
±±³Descricao ³Desbloqueia fornecedor para movimentacao.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Ap8                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

#include "rwmake.ch"  

User Function Nhcom040()   

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Fornecedores' 

aRotina := {{ "Pesquisar"   ,"AxPesqui",0,1},; 
            { "Visualizar"  ,"AxVisual",0,2},; 
            { "Desbloqueia" ,'U_FDesbloFor()',0,2}} 

DbSelectArea("SA2") 
SET FILTER TO SA2->A2_MSBLQL = '1' 
SA2->(DbGoTop()) 
            
mBrowse(,,,,"SA2",,"A2_MSBLQL=='1'") 
SET FILTER TO 
SA2->(DbGoTop()) 


Return(nil) 

User Function fDesbloFor() 
Local lOk
	If fValLib()	
		lOk := MsgBox("Confirma desbloqueio do Fornecedor ?","Fornecedor","YESNO")
		If lOk
			Reclock("SA2")
			SA2->A2_MSBLQL := Space(01)
			MsUnlock("SA2")
		Endif  
		SA2->(DbGotop())
	Endif	
Return(.T.)
                 


Static Function fValLib()

Local _afGrupo,_cfCodUsr,_lfRet

_afGrupo  := pswret() 
_cfCodUsr := _afgrupo[1,1]
_lfRet    := .F.

SAJ->(DbSetOrder(2))
SAJ->(DbSeek(xFilial("SAJ")+_cfCodUsr))
If SAJ->(Found()) .AND. SAJ->AJ_BLOFOR = 'S'
	_lfRet := .T.
Else
	MsgBox("Usuario não autorizado ao desbloqueio do Fornecedor !","Bloqueio de Fornecedor")
Endif

Return(_lfRet)
