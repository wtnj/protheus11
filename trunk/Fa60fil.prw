/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA60FIL   ºAutor  ³Marcos R. Roquitski º Data ³  30/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada filtar Clientes no bordero                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "rwmake.ch"

User Function FA60FIL()

SetPrvt("_dDataDe, _dDataAte, _cVar,_lRet")

_cCliente   := SE1->E1_CLIENTE                                     
_cLoja      := SE1->E1_LOJA
_cCods      := ''
_cVar       := ''

@ 200,050 To 400,500 Dialog DlgFiltro Title OemToAnsi("Filtro por Cliente")

@ 010,010 Say OemToAnsi("Cliente  ") Size 45,8
@ 025,010 Say OemToAnsi("Loja     ") Size 45,8

@ 009,070 Get _cCliente  PICTURE "@!" F3 "SA1" Size 45,8
@ 024,070 Get _cLoja     PICTURE "@!" Valid ExistCpo("SA1",_cCliente+_cLoja) Size 10,8 
@ 045,010 Get _cCods     PICTURE "@!" Size 210,8 When .f.


@ 075,060 BMPBUTTON TYPE 04 ACTION fSomaCods()
@ 075,100 BMPBUTTON TYPE 01 ACTION fAfiltro(@_cVar)
@ 075,140 BMPBUTTON TYPE 02 ACTION Close(DlgFiltro)
Activate Dialog DlgFiltro CENTERED

Return(_cVar)


Static Function fAfiltro(pVar)
pVar    := 'SE1->E1_CLIENTE+SE1->E1_LOJA  $ "' + _cCods + '"'
Close(DlgFiltro)
Return(pVar)

Static Function fSomaCods()
_cCods  += Alltrim(_cCliente + _cLoja + '/')
Return(.t.)

