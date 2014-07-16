/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHMDT005  ºAutor  ³Marcos R Roquitski  º Data ³  13/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de prestadores de servicos.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhmdt007()
Local cMsg     := ""
Local cItems   := ""
Local lEnvia   := .F.
Local cDescCli := ""
Local CRLF := chr(13)+chr(10)
Local _cFornec := Space(08)
Local _cNomeFor := Space(40)


	DbSelectarea("ZBW")
	ZBW->(DbSetOrder(6)) //Codigo do Fornecedor
	SA2->(DbSetOrder(1)) // filial + cod + loja
	
	ZBW->(DbGotop())
	While ZBW->(!EOF())

		_cFornec := ZBW->ZBW_FORNEC + ZBW->ZBW_LOJA

		While ZBW->(!EOF()) .and. ZBW->ZBW_FORNEC + ZBW->ZBW_LOJA == _cFornec

			If (ZBW->ZBW_DTASO+365 < Date()) .or. (ZBW->ZBW_VLINTE+365 < Date()) // Calcula vencimento Integracao e ASO      
				lEnvia := .T.
				cItems += '<tr>'
				cItems += '<td>'+ZBW->ZBW_COD+'</td>'
				cItems += '<td>'+ZBW->ZBW_NOME+'</td>'
				cItems += '<td>'+ZBW->ZBW_RG+'</td>'  
				cItems += '<td>'+TRANSFORM(ZBW->ZBW_CPF,"@R 999.999.999-99")+'</td>'  

				If (ZBW->ZBW_DTASO+365 < Date())			                            
					cItems += '<td>'+DTOC(ZBW->ZBW_DTASO)+'</td>'
				Else
					cItems += '<td>'+'  /  / '+'</td>'			
				Endif	

				If (ZBW->ZBW_VLINTE+365 < Date())			                            
					cItems += '<td>'+DTOC(ZBW->ZBW_VLINTE)+'</td>'
				Else
					cItems += '<td>'+'  /  / '+'</td>'			
				Endif	

				cItems += '</tr>'
				_cNomefor := ZBW->ZBW_NOMFOR
			Endif
		
			ZBW->(DbSkip())
		EndDo
            
		If lEnvia
			cMsg := '<html>'
			cMsg += '<body style="font-family:arial">'
			cMsg += '<p></p>'
			cMsg += '<table width="100%" border="1">'
			cMsg += '<tr style="background:#ccc">'
			cMsg += '<td colspan="9" style="background:ccc">'
			cMsg += 'Fornecedor:' + _cNomeFor
			cMsg += '</td></tr>'
			cMsg += '<tr style="background:#abc">'
			cMsg += '<td>Codigo</td>'
			cMsg += '<td>Nome</td>'
			cMsg += '<td>R.G</td>'
			cMsg += '<td>CPF</td>'
			cMsg += '<td>ASO(Vencida)</td>'
			cMsg += '<td>Integracao (Vencida)</td>'
			cMsg += '</tr>'
			cMsg += cItems
			cMsg += '</table><br />'
			cMsg += '</body>'
			cMsg += '</html>
			cTo := "marcosr@whbbrasil.com.br;almirrr@whbusinagem.com.br;elitonso@whbusinagem.com.br"
		
			oMail          := Email():New()
			oMail:cMsg     := cMsg
			oMail:cAssunto := "SESMT WHB - Vencimento: INTEGRACAO e ASO / "+_cNomeFor
			oMail:cTo      := cTo
			oMail:Envia()
		Endif
		_cFornec := Space(06)
		lEnvia   := .F.
		cItems   := ""
	Enddo		

Return
