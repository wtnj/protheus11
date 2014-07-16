/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QMT140OK ºAutor  ³ João Felipe da Rosa º Data ³ 08/06/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validação da tela na rotina de       º±±
±±º          ³ Calibração de Instrumentos (QMTA140)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - METROLOGIA                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "topconn.ch"

User Function QMT140OK()
Local cQuery
Local lRet := .T.

	If SM0->M0_CODIGO == "NH" //Empresa Usinagem
                        
		U_NH140STS()
		
		
		//verifica se o instrumento que está sendo calibrado
		//está emprestado ou não
		cQuery := " SELECT QML_INSTR FROM "+RetSqlName("QML")
		cQuery += " WHERE QML_INSTR = '"+QM2->QM2_INSTR+"'"
		cQuery += " AND QML_FLAGB = 'A'" //instrumento emprestado
		cQuery += " AND QML_FILIAL = '"+xFilial("QML")+"'"
		cQuery += " AND D_E_L_E_T_ = ''"

		TCQUERY cQuery NEW ALIAS "TRA1"
		
		TRA1->(DbGoTop())
		
		If !Empty(TRA1->QML_INSTR)
			Alert("Instrumento não pode ser calibrado pois está emprestado!")
			TRA1->(DbCloseArea())
			Return .F.
		EndIf
		
		TRA1->(DbCloseArea())

	EndIf
	
Return lRet


User Function NH140STS()
	If SM0->M0_CODIGO == "NH" //Empresa Usinagem
		
		QM2->(dbSetOrder(1))
		QM2->(dbSeek(xFilial("QM2")+M->QM6_INSTR))
	
		//OS 004082
		//Não permite Calibração do instrumento ativo
		If !QM2->QM2_STATUS$"C/G"
			Alert("Para realizar a calibração: "+chr(13)+chr(10)+;
			      " - Altere o status do instrumento para C ou G!")
			Return .F.
		EndIf
	EndIf
Return .T.