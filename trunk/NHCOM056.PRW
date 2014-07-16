
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM056  ºAutor  ³João Felipe da Rosa º Data ³  13/01/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ E-MAIL DE AVISO DE VENCIMENTO DO PED. DE COMPRAS NAO       º±±
±±º          ³ ATENDIDO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "topconn.ch"

User Function NHCOM056()

	oAuth := RotinaAutomatica():New("FN","01","COM",{"SA2","SB1","SC7","SY1","SM0"})
	
	oAuth:Executa({||fMail()})
	
Return

Static Function fMail()
Local cQuery := cItens := cMsg := cC7User := cNum := cTo := ""

	cQuery := " SELECT C7.*, A2.A2_NOME , B1.B1_DESC FROM "
	cQuery += RetSqlName("SB1")+" B1, "+RetSqlName("SC7")+" C7, "+RetSqlName("SA2")+" A2"
	cQuery += " WHERE (C7.C7_QUANT - C7.C7_QUJE) > 0"
	cQuery += " AND C7.C7_PRODUTO = B1.B1_COD"
	cQuery += " AND C7.C7_FORNECE = A2.A2_COD"
	cQuery += " AND C7.C7_LOJA = A2.A2_LOJA"
	cQuery += " AND C7.C7_RESIDUO <> 'S'"
	cQuery += " AND C7_DATPRF = '"+DTOS(Date()-1)+"'"
	cQuery += " AND C7.D_E_L_E_T_ = '' AND C7.C7_FILIAL = '"+xFilial("SC7")+"'"
	cQuery += " AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND A2.D_E_L_E_T_ = '' AND A2.A2_FILIAL = '"+xFilial("SA2")+"'"
	cQuery += " ORDER BY C7_NUM, C7_ITEM"
                                  
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TCSETFIELD("TRA1","C7_EMISSAO","D")
	TCSETFIELD("TRA1","C7_DATPRF" ,"D")
	
	TRA1->(dbGotop())
	
	While TRA1->(!Eof())
	
		cMsg := '<style type="text/css">'
		cMsg += 'td{ padding-left:3px; padding-right:3px; }'
		cMsg += 'table{ font-size:14px; border-color:#666666 }'
		cMsg += '</style>'
		
		cMsg += '<table border="1" style="border-collapse:collapse;font-family:arial">'
		cMsg += '<tr style="background:#cccccc">'
		cMsg += '<td>Pedido</td>'
		cMsg += '<td>Fornecedor</td>'
		cMsg += '<td>Loja</td>'
		cMsg += '<td>Descrição</td>'
		cMsg += '<td>Emissão</td>'
		cMsg += '</tr>'

		cMsg += '<tr>'
		cMsg += '<td align="center">'+TRA1->C7_NUM+'</td>'
		cMsg += '<td align="center">'+TRA1->C7_FORNECE+'</td>'
		cMsg += '<td align="center">'+TRA1->C7_LOJA+'</td>'
		cMsg += '<td>'+TRA1->A2_NOME+'</td>'
		cMsg += '<td align="center">'+DTOC(TRA1->C7_EMISSAO)+'</td>'
		cMsg += '</tr>'

		cMsg += '</table>'
		cMsg += '<br />'
		
		cMsg += '<table border="1" style="border-collapse:collapse;font-family:arial">'
		cMsg += '<tr style="background:#cccccc">'
		cMsg += '<td>Item</td>'
		cMsg += '<td>Produto</td>'
		cMsg += '<td>Descrição</td>'
		cMsg += '<td>Quantidade</td>'
		cMsg += '<td>Quant. Entregue</td>'
		cMsg += '<td>Data Prevista</td>'
		cMsg += '</tr>'
		
		cNum    := TRA1->C7_NUM
		cC7User := TRA1->C7_USER

		While TRA1-> (!EOF()) .AND. TRA1->C7_NUM==cNum
			
			cMsg += '<tr>'
			cMsg += '<td>'+TRA1->C7_ITEM+'</td>'
			cMsg += '<td>'+TRA1->C7_PRODUTO+'</td>'
			cMsg += '<td>'+TRA1->B1_DESC+'</td>'
			cMsg += '<td align="center">'+ALLTRIM(STR(TRA1->C7_QUANT))+'</td>'
			cMsg += '<td align="center">'+ALLTRIM(STR(TRA1->C7_QUJE))+'</td>'
			cMsg += '<td align="center">'+DTOC(TRA1->C7_DATPRF)+'</td>'
			cMsg += '</tr>'
				    
			TRA1->(dbSkip())  
			
		EndDo
		
		cMsg += '</table>'
		cMsg += '<br />'
		
		// Encontra os destinatários do e-mail
		cTo := ""
		SY1->(dbSetOrder(3)) // filial + USER
		If SY1->(dbSeek(xFilial("SY1")+cC7User))
			If !Empty(SY1->Y1_EMAIL)
				cTo += SY1->Y1_EMAIL
			EndIf
		EndIf
		
		oMail          := Email():New()
		oMail:cMsg     := cMsg
		oMail:cAssunto := "*** ATRASO NA ENTREGA DO PED. DE COMPRA "+cNum+" ***"
		oMail:cTo      := cTo//"joaofr@whbbrasil.com.br"
		
		oMail:Envia()

	EndDo

Return


