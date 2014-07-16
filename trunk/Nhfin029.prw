/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN029  ºAutor  ³Marcos R. Roquitski º Data ³  01/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao do Adiantamento de Viagem, pelo Financeiro       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhfin029()

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Liberacao dos Adiantamentos de Viagem'
aRotina := {{ "Pesquisa","AxPesqui"       ,0 , 1},;
            { "Visual"  ,"AxVisual"       ,0 , 2},;
            { "Liberar" ,"U_fLibFinan"    ,0 , 3},;
            { "Legenda" ,"U_Fa014Legenda" ,0, 2}}


mBrowse(06,01,22,75,"SZ3",,,,,,fCriaCor())

Return


Static Function fCriaCor()

Local aLegenda :=	{	{"BR_AZUL"    , "Pendente" },;
  							{"BR_VERMELHO", "Liberado" },;
  							{"BR_VERDE"   , "Aberto"   }}

Local uRetorno := {}
Aadd(uRetorno, {'Z3_STATUS = "P"', aLegenda[1][1]})
Aadd(uRetorno, {'Z3_STATUS = "F"', aLegenda[2][1]})
Aadd(uRetorno, {'Z3_STATUS = "A"', aLegenda[3][1]})

Return(uRetorno)


User Function fLibFinan()
Local _aGrupo := pswret()

If SZ3->Z3_STATUS == "P"
	If MsgBox("Confima Liberacao no Financeiro ?","Liberacao","YESNO")
		RecLock("SZ3",.f.)
		SZ3->Z3_STATUS  := "F"  // Grava como fechada
      SZ3->Z3_FINUSR  :=  _agrupo[1,4 ] // Nome completo.
	   SZ3->Z3_FINDAT  :=  Date()
	   SZ3->Z3_FINHOR  :=  Substr(Time(),1,5)
		MsUnLock("SZ3")
	Endif
Elseif SZ3->Z3_STATUS == "A"
	MsgBox("Acerto de Viagem, Encontra-se Pendente !","Liberacao","STOP")
Elseif SZ3->Z3_STATUS == "F"
	MsgBox("Acerto de Viagem, Encontra-se Fechado !","Liberacao","STOP")
Endif	
Return
