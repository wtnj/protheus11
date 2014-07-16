/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EICPO01S  º Autor ³Marcos R Roquitski  º Data ³  10/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE apos gravacao no P.O                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#INCLUDE "rwmake.ch"

User Function EICPO01S()
Local _cW2PoNum := M->W2_PO_NUM
   
             
If Inclui
	DbSelectArea("SW1")
	SW1->(DbsetOrder(2))
	SW1->(DbSeek(xFilial('SW1') + _cW2PoNum ))
	While SW1->(!Eof()) .and. SW1->W1_PO_NUM == _cW2PoNum 
		If	SW1->W1_PO_NUM == _cW2PoNum 
			RecLock("SW1") 
			SW1->W1_PO_NUM := SC7->C7_NUM 
			MsUnlock("SW2") 
		Endif 
		SW1->(DbSeek(xFilial('SW1') + _cW2PoNum ) ) 
	Enddo 

	DbSelectArea("SW2")
	SW2->(DbsetOrder(1))
	SW2->(DbSeek(xFilial('SW2')+ _cW2PoNum ) )
	While SW2->(!Eof()) .and. SW2->W2_PO_NUM == _cW2PoNum
		If	SW2->W2_PO_NUM == _cW2PoNum
			RecLock("SW2")
			SW2->W2_PO_NUM := SC7->C7_NUM
			MsUnlock("SW2")
		Endif
		SW2->(DbSeek(xFilial('SW2') + _cW2PoNum ))	
	Enddo

	DbSelectArea("SW3")
	SW3->(DbsetOrder(1))
	SW3->(DbSeek(xFilial('SW3') + _cW2PoNum ) )
	While SW3->(!Eof())  .and. SW3->W3_PO_NUM == _cW2PoNum
		If	SW3->W3_PO_NUM == _cW2PoNum
			RecLock("SW3")
			SW3->W3_PO_NUM := SC7->C7_NUM
			MsUnlock("SW3")
		Endif
		SW3->(DbSeek(xFilial('SW3') + _cW2PoNum ) )
	Enddo

	DbSelectArea("SW5")
	SW5->(DbsetOrder(3))
	SW5->(DbSeek(xFilial('SW5') + _cW2PoNum ) )
	While SW5->(!Eof())  .and. SW5->W5_PO_NUM == _cW2PoNum
		If	SW5->W5_PO_NUM == _cW2PoNum
			RecLock("SW5")
			SW5->W5_PO_NUM := SC7->C7_NUM
			MsUnlock("SW5")
		Endif
		SW5->(DbSeek(xFilial('SW5') + _cW2PoNum ) )
	Enddo
Endif      

Return(.T.)
