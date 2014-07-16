
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTA4204  ºAutor  ³João Felipe da Rosa º Data ³  08/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA CHAMADO APOS GRAVACAO DA OS CORRETIVA     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
       
#include "rwmake.ch"
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#Include "prtopdef.ch"    

       
USER FUNCTION MNTA4204()

// GRAVA AUTOMATICAMENTE A HORA DE PARADA REAL INICIAL DA OS
// E A DATA DE PARADA REAL, MAS PERMITE ALTERAR NO RETORNO
RECLOCK("STJ",.F.)
	STJ->TJ_HOPRINI := M->TJ_HRDIGIT
	STJ->TJ_DTPRINI := M->TJ_DTORIGI
MSUNLOCK("STJ") 

f420Mail()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ENVIA E-MAIL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function f420Mail()
Local cMsg
                
	cMsg := '<html><head><title>OS Corretiva</title></head><body>'
	
	cMsg += '<style type="text/css">'
	cMsg += 'body{font-size:12px}
	cMsg += '.fix{background:#efefef}'
	cMsg += '.tab{font-family:arial;border-collapse:collapse;border-color:#cccccc}'
	cMsg += '</style>'
	
	cMsg += '<table class="tab" width="100%" border="1">'
	
	cMsg += '<tr>'
	cMsg += '<td colspan="4" style="background:#cccccc">Abertura de Ordem de Serviço Corretiva</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td class="fix" width="110">Número</td>'
	cMsg += '<td>'+STJ->TJ_ORDEM+'</td>'
	cMsg += '<td class="fix" width="120">Data Original</td>'
	cMsg += '<td>'+DtoC(STJ->TJ_DTORIGI)+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td class="fix">Bem</td>'
	cMsg += '<td>'+STJ->TJ_CODBEM+'</td>'
	cMsg += '<td class="fix">Nome do Bem</td>'
	cMsg += '<td>'+Posicione("ST9",1,xFilial("ST9")+STJ->TJ_CODBEM,"T9_NOME")+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td class="fix">Título</td>'
	cMsg += '<td colspan="3">'+STJ->TJ_TITULO+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td class="fix">Serviço</td>'
	cMsg += '<td>'+STJ->TJ_SERVICO+'</td>'
	cMsg += '<td class="fix">Nome do Serviço</td>'
	cMsg += '<td>'+Posicione("ST4",1,xFilial("ST4")+STJ->TJ_SERVICO,"T4_NOME")+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td class="fix">Observação</td>'
	cMsg += '<td colspan="3">'+STJ->TJ_OBSERVA+'</td>'
	cMsg += '</tr>'
	
	cMsg += '<tr>'
	cMsg += '<td class="fix">Situação</td>'
	cMsg += '<td>'+Iif(STJ->TJ_SITUACA=="P","Pendente",Iif(STJ->TJ_SITUACA=="L","Liberado","Cancelado"))+'</td>'
	cMsg += '<td class="fix">Estado da Máq:</td>'
	if STJ->TJ_MAQSIT=="P"
		cMsg += '<td>Parada</td>'
	ElseIf STJ->TJ_MAQSIT=="D"
		cMsg += '<td>Deficiente</td>'
	ElseIf STJ->TJ_MAQSIT=="C"
		cMsg += '<td>Deficiente c/ Perda de Produção</td>'
	ElseIf STJ->TJ_MAQSIT=="S"
		cMsg += '<td>Setup</td>'
	EndIf
	cMsg += '</tr>'
	
	cMsg += '<tr>' 
	cMsg += '<td class="fix">Funcionário</td>'
	cMsg += '<td>'+STJ->TJ_CODFUN+'</td>'
	cMsg += '<td class="fix">Nome:</td>'
	cMsg += '<td>'+Posicione("QAA",1,xFilial("QAA")+STJ->TJ_CODFUN,"QAA_NOME")+'</td>'
	cMsg += '</tr>'
	
	cMsg += '</table>'
	
	oMail := Email():New()
	oMail:cMsg := cMsg
	oMail:cAssunto := "*** ABERTURA DE O.S. CORRETIVA "+STJ->TJ_ORDEM+" ***"

	If ALLTRIM(STJ->TJ_CENTRAB)=="FAB-05"
		oMail:cTo  := "lista-manutencao-virabrequim@whbbrasil.com.br"
//		oMail:cTo := "joaofr@whbbrasil.com.br"
		oMail:Envia() 
	EndIf
			
Return