#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050GRV  ºAutor  ³Marcos R Roquitski  º Data ³  10/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada do FA050GRV, serve p/ tratar dados        º±±
±±º          ³ apos estarem gravados.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050GRV()

Local _Prefixo, _Num, _Naturez, _nRecno


DbSelectArea("SE2")
_Prefixo := SE2->E2_PREFIXO
_Num := SE2->E2_NUM
_Naturez := SE2->E2_NATUREZ
_nRecno := SE2->(RECNO())

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
SE2->(DbGoto(_nRecno))
Return
