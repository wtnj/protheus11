#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Marcos R. Roquitski º Data ³  14/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada apos a gravacao SE2, grava a natureza nos  º±±
±±º          ³imposto.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100AGR()
Local _Prefixo, _Num, _Naturez
SA2->(DbSetOrder(1))
DbSelectArea("SE2")
If SA2->(DbSeek(xFilial("SA2")+ SE2->E2_FORNECE + SE2->E2_LOJA))
	If !Empty(SA2->A2_CGC) .And. Alltrim(SE2->E2_TIPO) == 'NF'

		If SA2->A2_BANCO == '001'
			RecLock("SE2",.F.)
			SE2->E2_PORTADO = '990'
			MsUnlock("SE2")		

		Elseif SA2->A2_BANCO == '341'
			RecLock("SE2",.F.)
			SE2->E2_PORTADO = '880'
			MsUnlock("SE2")		

		Else
			If SE2->E2_SALDO >= 3000
				RecLock("SE2",.F.)	
				SE2->E2_PORTADO = '998'		
				MsUnlock("SE2")			
			Else
				RecLock("SE2",.F.)
				SE2->E2_PORTADO = '999'				
				MsUnlock("SE2")			
			Endif	
		Endif	
	Endif
Endif	

_Prefixo := SE2->E2_PREFIXO
_Num := SE2->E2_NUM
_Naturez := SE2->E2_NATUREZ

// Pesquisa tipo TX
SE2->(DbGotop())
SE2->(DbSeek(xFilial("SE2")+_Prefixo + _Num + "1TX 00228500")) // Fixo parcela, tipo e Fornecedor = parametro MV_UNIAO
While !SE2->(Eof()) .And. (SE2->E2_PREFIXO  == _Prefixo .And. SE2->E2_NUM == _Num .And. ;
					       SE2->E2_TIPO == "TX " .And. SE2->E2_FORNECE == "002285" .And. SE2->E2_LOJA == "00")

	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Naturez
	MsUnlock("SE2")
	SE2->(DbSkip())	
Enddo

// Pesquisa tipo INS
SE2->(DbGotop())
SE2->(DbSeek(xFilial("SE2")+_Prefixo + _Num + "1INS00228500")) // Fixo parcela, tipo e Fornecedor = parametro MV_UNIAO
While !SE2->(Eof()) .And. (SE2->E2_PREFIXO  == _Prefixo .And. SE2->E2_NUM == _Num .And. ;
					       SE2->E2_TIPO == "INS" .And. SE2->E2_FORNECE == "002285" .And. SE2->E2_LOJA == "00")

	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Naturez
	MsUnlock("SE2")
	SE2->(DbSkip())	
Enddo

// Pesquisa tipo ISS 
SE2->(DbGotop())
SE2->(DbSeek(xFilial("SE2")+_Prefixo + _Num + "1ISS00228500")) // Fixo parcela, tipo e Fornecedor = parametro MV_UNIAO
While !SE2->(Eof()) .And. (SE2->E2_PREFIXO  == _Prefixo .And. SE2->E2_NUM == _Num .And. ;
					       SE2->E2_TIPO == "ISS" .And. SE2->E2_FORNECE == "002285" .And. SE2->E2_LOJA == "00")

	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Naturez
	MsUnlock("SE2")
	SE2->(DbSkip())	
Enddo


// Pesquisa tipo ISS 
SE2->(DbGotop())
SE2->(DbSeek(xFilial("SE2")+_Prefixo + _Num + "1ISSMUNIC 00")) // Fixo parcela, tipo e Fornecedor = parametro MV_UNIAO
While !SE2->(Eof()) .And. (SE2->E2_PREFIXO  == _Prefixo .And. SE2->E2_NUM == _Num .And. ;
					       SE2->E2_TIPO == "ISS" .And. SE2->E2_FORNECE == "MUNIC " .And. SE2->E2_LOJA == "00")

	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Naturez
	MsUnlock("SE2")
	SE2->(DbSkip())	
Enddo

// Pesquisa tipo INS
SE2->(DbGotop())
SE2->(DbSeek(xFilial("SE2")+_Prefixo + _Num + "1INSINPS  00")) // Fixo parcela, tipo e Fornecedor = parametro MV_UNIAO
While !SE2->(Eof()) .And. (SE2->E2_PREFIXO  == _Prefixo .And. SE2->E2_NUM == _Num .And. ;
					       SE2->E2_TIPO == "INS" .And. SE2->E2_FORNECE == "INPS  " .And. SE2->E2_LOJA == "00")

	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Naturez
	MsUnlock("SE2")
	SE2->(DbSkip())	
Enddo

// Pesquisa tipo TX
SE2->(DbGotop())
SE2->(DbSeek(xFilial("SE2")+_Prefixo + _Num + "1TX UNIAO 00")) // Fixo parcela, tipo e Fornecedor = parametro MV_UNIAO
While !SE2->(Eof()) .And. (SE2->E2_PREFIXO  == _Prefixo .And. SE2->E2_NUM == _Num .And. ;
					       SE2->E2_TIPO == "TX " .And. SE2->E2_FORNECE == "UNIAO " .And. SE2->E2_LOJA == "00")

	RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Naturez
	MsUnlock("SE2")
	SE2->(DbSkip())	
Enddo


Return



