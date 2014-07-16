/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHGPE062 ºAutor  ³Marcos R Roquitski  º Data ³  10/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de campos obrigatorios.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "Font.ch"
#include "Colors.ch"

User Function Nhgpe062()

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD                                           
SetPrvt("cCadastro,aRotina,_cFunc,_PerCadt,_Valeref")

cCadastro := OemToAnsi("Alteração")

aRotina := {{ "Pesquisar"  ,"AxPesqui",0,1},;
            { "Altera"   ,'U_fAltera()',0,2}}

DbSelectArea("SRA")
SRA->(DbSetOrder(1))
DbGoTop()
            
mBrowse(,,,,"SRA",,"SRA->RA_DEMISSA<>Ctod(Space(08))")

Return(nil)    



User Function fAltera()
   _PerCadt := SRA->RA_PERCADT
   _Valeref := SRA->RA_VALEREF
   _cFunc   := "Funcionario: " +SRA->RA_MAT + " - " +SRA->RA_NOME
   
	@ 96,42 TO 250,405 DIALOG oDlg6 TITLE OemToAnsi("Alteração no Cadastro de Funcionarios")
	@ 10,14 Say OemToAnsi("% de Adiantamento:") Size 60,10
	@ 27,14 Say OemToAnsi("Desc. Refeicao  :") Size 60,10
	@ 09,64 Get _PerCadt Picture "999" Size 40,10    Valid _PerCadt >= 0
	@ 26,64 Get _Valeref Picture "@!"  Size 30,10 F3 "X26" Valid ChkValRef(_Valeref)

	@ 55,060 BMPBUTTON TYPE 01 ACTION fGrava()
	@ 55,100 BMPBUTTON TYPE 02 ACTION Close(oDlg6)

	ACTIVATE DIALOG oDlg6 CENTERED
Return


Static Function fGrava()
	RecLock("SRA",.f.)
	SRA->RA_PERCADT := _Percadt
	SRA->RA_VALEREF := _Valeref
	MsUnLock("SRA")
    Close(oDlg6)
Return 
