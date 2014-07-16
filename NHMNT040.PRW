
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT040 ºAutor ³ João Felipe da Rosa º Data ³  29/04/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GRAFICO DE OSs ABERTAS E FECHADAS                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - MANUTENCAO DE ATIVOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "msobjects.ch"
#INCLUDE "topconn.ch"

User Function NHMNT040()  
Local cQuery
//MV_PAR01 = DE DATA
//MV_PAR02 = ATE DATA
//MV_PAR03 = DE SERVICO
//MV_PAR04 = ATE SERVICO

	If !Pergunte("MNT040",.T.)
		Return
	EndIf

	cQuery := "SELECT COUNT(*) AS ABERTAS FROM "+RetSqlName("STJ")
	cQuery += " WHERE TJ_TERMINO = 'N'"
	cQuery += " AND TJ_DTORIGI BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"
	cQuery += " AND TJ_SERVICO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND TJ_FILIAL = '"+xFilial("STJ")+"'"
	cQuery += " AND D_E_L_E_T_ = ''"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DbGoTop())
	nAbertas := TRA1->ABERTAS
	TRA1->(DbCloseArea())
	
	cQuery := " SELECT COUNT(*) AS FECHADAS FROM "+RetSqlName("STJ")
	cQuery += " WHERE TJ_TERMINO = 'S'"
	cQuery += " AND TJ_DTORIGI BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"
	cQuery += " AND TJ_SERVICO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND TJ_FILIAL = '"+xFilial("STJ")+"'"
	cQuery += " AND D_E_L_E_T_ = ''"
	
	TCQUERY cQuery NEW ALIAS "TRB"
	
	TRB->(DbGoTop())
	nFechadas := TRB->FECHADAS
	TRB->(DbCloseArea())

	oGraf := Grafico():New()
	oGraf:aMat := {{"Abertas",nAbertas},{"Fechadas",nFechadas}}
	oGraf:cTitulo := "OSS ABERTAS E FECHADAS"
	oGraf:nEspaco := 40
	oGraf:Show()
	
Return