
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHEST195 Autor:José Henrique M Felipetto    Data:02/24/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de acesso dos usuários às rotinas                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
User Function NHEST195(Rotina,Usuario)
Local cQuery := ""

Default Usuario := upper(alltrim(cUserName))

// Verifica se o usuário e a rotina passados existem na tabela de ZRX.
cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("ZRX")
cQuery += " WHERE ZRX_ROTINA = '" + Rotina + "' AND ZRX_USER = '" + Usuario + "' "
cQuery += " AND D_E_L_E_T_ = '' AND ZRX_FILIAL = '" + xFilial("ZRX") + "' "

TCQUERY cQuery NEW ALIAS "TMP"
TMP->(DbGoTop() )

If TMP->(EOF() )  // Se o resultado da query vier vazia, o usuario não tem autorização para usar a rotina
	alert("Usuário " + Alltrim(Usuario) + " não autorizado a utilizar a rotina " + Alltrim(Upper(Rotina)) + "! Favor verifique!")
	TMP->(DbCloseArea() )
	Return .F.
EndIf
TMP->(DbCloseArea() )

Return .T.