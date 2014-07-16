/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A120PIDF  ºAutor  ³Marcos R Roquitski  º Data ³  19/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no pedido de compra, apos teclar F4 para   º±±
±±º          ³selecionar as SC.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"


User Function A120PIDF()
SetPrvt("_aGrupo,_cLogin,nRecno,_cNumSc,_cNivel,_cOk,_cCodus,aRetFiltro")
	If GetMv("MV_LOGAPR") == "S"
		_aGrupo := pswret()
		_cCodus := _agrupo[1,1] // Codigo
		_cLogin := _agrupo[1,2] // Apelido
	//	fDetalhes()
		aRetFiltro := {'C1_LOGAPR=="'+_aGrupo[1,1]+'"'}                                
	Else
		_aGrupo := Space(06)
		aRetFiltro := {'C1_LOGAPR>="'+_aGrupo+'"'}
	Endif
Return(aRetFiltro)


Static Function fDetalhes()

_cNivel := Space(01)
_cOk := 'S'

SZU->(DbSetOrder(1))
SZU->( DbGotop())
SZU->(DbSeek(xFilial("SZU")+_cLogin))

While !SZU->(Eof()) .AND. SZU->ZU_LOGIN == _cLogin
	
	_cOk := 'S'
	If Empty(SZU->ZU_STATUS)
		_nRecno := SZU->(Recno())
		_cNumSc := SZU->ZU_NUM+SZU->ZU_ITEM
		_cNivel := SZU->ZU_NIVEL

		SZU->(DbSetOrder(2))             
		SZU->(DbSeek(xFilial("SZU")+_cNumSc))
		While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == _cNumSc
			If (SZU->ZU_STATUS $ "B/C" .And. Alltrim(SZU->ZU_LOGIN) <> Alltrim(_cLogin) )
				_cOk := "N"
				EXIT
			Else
				If (Empty(SZU->ZU_STATUS) .AND. SZU->ZU_NIVEL < _cNivel)		
					_cOk := "N"
					EXIT
				Endif	
			Endif
			SZU->(DbSkip())
		Enddo
		SZU->(DbSetOrder(1))
		SZU->(DbGoto(_nRecno))

		SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
		If SC1->(Found()) .AND. _cOk == 'S' .AND. EMPTY(SC1->C1_GRUPCOM)
			RecLock("SC1",.F.)
			SC1->C1_LOGAPR := _cCodUs
			MsUnlock("SC1")
		Endif

	Endif		
	SZU->(DbSkip())
Enddo

Return(.T.)