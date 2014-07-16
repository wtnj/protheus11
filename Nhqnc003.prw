/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQNC003  ºAutor  ³Marcos R. Roquitski º Data ³  15/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerador do codigo sequencial.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function NHQNC003()
Local _lRet := .T.
Local _cCod := Space(02)
Local _nSeq := 0


QI0->(DbSetOrder(2))

If M->QI0_TIPO == '1'
	_cCod := M->QI0_CAUSA + '.'

Elseif M->QI0_TIPO == '2'
	_cCod := 'EF.'
            
Elseif M->QI0_TIPO == '3'
	_cCod := 'OR.'

Elseif M->QI0_TIPO == '4'
	_cCod := 'CT.'

Endif

//
QI0->(DbSeek(xFilial("QI0") + _cCod))
While !QI0->(Eof()) .and. Substr(QI0->QI0_CODIGO,1,3) == _cCod
	If Substr(QI0->QI0_CODIGO,1,3) == _cCod
		_nSeq := Val(Substr(QI0->QI0_CODIGO,4,4)) 
	Endif
	QI0->(DbSkip())
Enddo
M->QI0_CODIGO := _cCod + StrZero(_nSeq + 1,4)


Return(_lRet)

//
User function NHQNC004()
Local lRet
If Substr(M->QI0_CODIGO,1,2) $ 'MQ/MT/MP/MD/MO/MA/EF/OR/CT/FE/DI'
	_lRet := .T.
Else
	Alert("Atencao, Nao foi definia as 2 primeiras siglas MQ/MT/MP/MD/MO/MA/EF/OR/CT/FE/DI")
	_lRet := .F.	
Endif	

Return(_lRet)