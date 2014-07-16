/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE275  ºAutor  ³Marcos R. Roquitski º Data ³  10/05/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do desconto de transporte, ITESPAR.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
     
/**********************************************************************************************************************************/
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/**********************************************************************************************************************************/
user function Nhgpe275()

Local _nValDesc := 0

	If SRA->RA_ADMISSA >= CTOD('01/11/2013')  .AND. SRA->RA_SALARIO >= 1200
	
		DbSelectArea("SR0") 
		If SR0->(DbSeek(xFilial("SR0")+SRA->RA_MAT)) // tabela linha de transporte
			While SR0->(!EOF()) .and. SR0->R0_MAT == SRA->RA_MAT 

				If SRN->(DbSeek(xFilial("SRN")+SR0->R0_MEIO)) // tabela meio de transporte
				
					_nValDesc := ((SRA->RA_SALARIO * 6)/100) 

					If _nValDesc >	SRN->RN_VUNIATU 
						_nValDesc := SRN->RN_VUNIATU 
					Endif	

				Endif
				SR0->(DbSkip())		
			Enddo	
			If _nValDesc > 0
				fGeraVerba("435",_nValDesc,,,,,,,,,.T.) // Verba desconto vale transporte
			Endif	

		Endif	

	Endif	
                                                             
return nil
