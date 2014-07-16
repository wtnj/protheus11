/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHGPE250 ºAutor  ³Marcos R Roquitski  º Data ³  22/05/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Bloqueio de calculo de Rescisao                            º±±
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


User Function Nhgpe250()

	If MsgBox("Bloquea Rotina de Calculo de ** RESCISAO ?.","Bloqueio de Lancamentos","YESNO")

		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM040"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "S"
			MsUnlock("SX6")

			Alert("** RESCISAO DE CONTRATO,  BLOQUEADA para manutencao.")	
		Else
			Alert("Parametro MV_GPEM040 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
	
	Else
	
		SX6->(DbSeek(xFilial("SRA")+"MV_GPEM040"))
		If SX6->(Found())
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "N"
			MsUnlock("SX6")

			Alert("** RESCISAO DE CONTRATO,  LIBERADA para manutencao.")

		Else
			Alert("Parametro MV_GPEM040 Nao cadastrado. Verifique no cadastro de parametros!")	

		Endif	
		
	Endif
	
Return
