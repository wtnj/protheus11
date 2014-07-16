/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN096  ºAutor  ³Marcos R Roquitski  º Data ³  17/05/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Duplicar lancamento bancarios.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhfin096()

SetPrvt("AROTINA,CCADASTRO,")

aRotina := { { "Pesquisar"  , 'AxPesqui'  , 0 ,1},;
             { "Visualizar" , 'AxVisual'  , 0 ,2},;
             { "Duplicar"   , 'U_fDupSe5' , 0 ,3},;
             { "Alterar"    , 'AxAltera'  , 0 ,4}}
             
cCadastro := "Adiantamento ao Fornecedor"
DbSelectArea("SE5")
Set Filter to (SE5->E5_RECPAG == 'P' .and. SE5->E5_MOEDA = 'M1')
SE5->(DbGoTop())

mBrowse(,,,,"SE5",,,25)

Set Filter to 
SE5->(DbGoTop())

Return(.T.)


//
User Function fDupSe5()

Local _dE5_Data    := SE5->E5_DATA 
Local _cE5_Tipo    := SE5->E5_TIPO 
Local _cE5_Moeda   := SE5->E5_Moeda
Local _nE5_Valor   := SE5->E5_VALOR
Local _cE5_Nature  := SE5->E5_NATUREZ
Local _cE5_Banco   := SE5->E5_BANCO 
Local _cE5_Agencia := SE5->E5_AGENCIA
Local _cE5_Conta   := SE5->E5_CONTA
Local _cE5_NumCheq := SE5->E5_NUMCHEQ
Local _cE5_RecPag  := SE5->E5_RECPAG
Local _cE5_Benef   := SE5->E5_BENEF
Local _cE5_Histor  := SE5->E5_HISTOR 
Local _cE5_TipoDoc := SE5->E5_TIPODOC
Local _cE5_VlMoed2 := SE5->E5_VLMOED2
Local _cE5_Numero  := SE5->E5_NUMERO
Local _cE5_Clifor  := SE5->E5_CLIFOR
Local _cE5_Loja    := SE5->E5_LOJA
Local _cE5_DtDigit := SE5->E5_DTDIGIT
Local _cE5_MotBx   := SE5->E5_MOTBX
Local _cE5_DtDispo := SE5->E5_DTDISPO
Local _cE5_Fornece := SE5->E5_FORNECE 
Local _cE5_Debito  := SE5->E5_DEBITO 
Local _cE5_Credito := SE5->E5_CREDITO 
Local _cE5_ModSpb  := SE5->E5_MODSPB
Local _cE5_Documen := SE5->E5_DOCUMEN 
Local _nReg


If MsgBox("Confirma duplicação do registro","Movimento Banco","YESNO")
	// Grava no movimento Bancario
	RecLock("SE5",.T.)
		SE5->E5_FILIAL  := xFilial("SE5")
		SE5->E5_FILORIG := xFilial("SE5")
		SE5->E5_DATA    := dDataBase 
		SE5->E5_MOEDA   := _cE5_Moeda
		SE5->E5_TIPO    := _cE5_Tipo
		SE5->E5_VALOR   := _nE5_Valor
		SE5->E5_NATUREZ := _cE5_Nature
		SE5->E5_BANCO   := _cE5_Banco
		SE5->E5_AGENCIA := _cE5_Agencia
		SE5->E5_CONTA   := _cE5_Conta
		SE5->E5_NUMCHEQ := _cE5_NumCheq
		SE5->E5_RECPAG  := _cE5_RecPag
		SE5->E5_BENEF   := _cE5_Benef
		SE5->E5_HISTOR  := _cE5_Histor
		SE5->E5_TIPODOC := _cE5_TipoDoc
		SE5->E5_VLMOED2 := _cE5_VlMoed2
		SE5->E5_NUMERO  := _cE5_Numero
		SE5->E5_CLIFOR  := _cE5_Clifor
		SE5->E5_LOJA    := _cE5_Loja
		SE5->E5_DTDIGIT := dDataBase
		SE5->E5_MOTBX   := _cE5_MotBx
		SE5->E5_DTDISPO := dDataBase
		SE5->E5_FORNECE := _cE5_Fornece
		SE5->E5_DEBITO  := _cE5_Debito
		SE5->E5_CREDITO := _cE5_Credito
		SE5->E5_MODSPB  := _cE5_ModSpb 
		SE5->E5_DOCUMEN := _cE5_Documen
	MsUnlock("SE5")
Endif
	
Return(.T.)	 


//
Static Function NhF096Alt()

Local nOpca
Local nOpc := 4
Local cTudoOK := '.T.'
Local nReg := SE5->(Recno())

nOpca := AxAltera("SE5",nReg,nOpc,,,,,cTudoOk)

Return




