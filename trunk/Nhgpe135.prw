/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE135  บAutor  ณMarcos R Roquitski  บ Data ณ  02/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manutencao liquidos de terceiros.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"                                                                    
#include "protheus.ch"

User Function Nhgpe135()

SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1},;
             {"Visualizar","AxVisual",0,2},;
             {"Alterar","U_fGpe135m()",0,3},;
             {"E-mail","U_Nhgpe229()",0,4} }                          


cCadastro := "Movimentacao dos liquidos Terceiros"

mBrowse(,,,,"ZRA",,"ZRA_FIM<>Ctod(Space(08))",)

Return


User Function fGpe135m()

SetPrvt("aRotina,cCadastro")

	aRotina := { {"Pesquisar","AxPesqui",0,1},;
	             {"Visualizar","AxVisual",0,2},;
	             {"Incluir","AxInclui",0,3},;
	             {"Alterar","AxAltera",0,4},;
	             {"Excluir","AxDeleta",0,5} }

	cCadastro := "Matricula: "+ZRA->ZRA_MAT + " " + Alltrim(ZRA->ZRA_NOME)

	DbSelectArea("ZR1")
	SET FILTER TO ZR1->ZR1_MAT == ZRA->ZRA_MAT 
	ZR1->(DbGotop())

	mBrowse(,,,,"ZR1",,,)

	SET FILTER TO
	ZR1->(DbGotop())

	DbSelectArea("ZRA")
                                                       
Return(.T.)