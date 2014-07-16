/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Nhcfg008  ºAutor  ³Marcos R Roquitski  º Data ³  04/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de aprovadores de SC.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"


User Function Nhcfg008()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

cCadastro := "Cadastro de Aprovadores de SC"

mBrowse(,,,,"ZAA",,,)

Return(.T.)

User Function Imp008()
	If MsgBox("Importa do SX5","Importacao","YESNO")
		SX5->(DbSetOrder(1))
		SX5->(DbSeek(xFilial("SX5") + "ZH"))
		While !SX5->(Eof()) .AND.  SX5->X5_TABELA = 'ZH'
			RecLock("ZAA",.T.)
			ZAA->ZAA_FILIAL :=  '01'
			ZAA->ZAA_LOGIN  :=  Substr(SX5->X5_DESCRI,01,15)
			ZAA->ZAA_GRUPO  :=  Substr(SX5->X5_DESCRI,16,4)
			ZAA->ZAA_ORDEM  :=  Substr(SX5->X5_DESCRI,20,1)
			ZAA->ZAA_TIPO   :=  Substr(SX5->X5_DESCRI,21,2)
			ZAA->ZAA_CONTA  :=  Substr(SX5->X5_DESCRI,23,9)
			ZAA->ZAA_CONTRA :=  Substr(SX5->X5_DESCRI,32,1)
			MsUnlock("ZAA")
			SX5->(DbSkip())
		Enddo
	Endif
Return
