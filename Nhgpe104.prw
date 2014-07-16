/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE104  ºAutor  ³Marcos R Roquitski  º Data ³  13/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo vale mercado, chamada do roteiro do calculo.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe104()

Local _nValor   := 1.00 
Local _nSalario := 0
Local _nRecno   
Local _nFaltas  := 0
Local _cMat     
Local _cCodf
Local _cCodn
Local _lDesc := .F.

SR8->(DbSetOrder(1))

If SRA->RA_ZEMP = '1' // Usinagem
	_cCodf := '1193'

Elseif SRA->RA_ZEMP $ '2/4/5/6' // Fundicao
	_cCodf := '0321'

Endif


If SRA->RA_CATFUNC = 'H'
	_nSalario := (SRA->RA_SALARIO * SRA->RA_HRSMES)
Else
	_nSalario := SRA->RA_SALARIO
Endif
        

If _nSalario <= 4000.00 .And. SRA->RA_CODFUNC <> _cCodf
	
	If Val(Dtos(SRA->RA_ADMISSA + 90)) <= Val(Substr(Dtos(dDataBase),1,6)+"15")

		_nRecno := SRC->(Recno())
		SRC->(DbSeek(xFilial("SRC")+SRA->RA_MAT))
		While !SRC->(Eof()) .and. SRC->RC_MAT == SRA->RA_MAT
			If SRC->RC_PD == "425" .or. SRC->RC_PD == "427" .or. SRC->RC_PD == "428"
				_nFaltas+=SRC->RC_HORAS
			Endif
			SRC->(DbSkip())
		Enddo
		SRC->(Dbgoto(_nRecno))


		If SRA->RA_SITFOLH == 'A'

			If SR8->(DbSeek(xFilial("SR8")+SRA->RA_MAT))
				While !SR8->(Eof()) .and. SR8->R8_MAT == SRA->RA_MAT .and. SR8->R8_FILIAL == SRA->RA_FILIAL

					_dDtp1 := Ctod( '01/' + Substr(Dtos(dDataBase),5,2) + '/' + Substr(Dtos(dDataBase),1,4) )
					_dDtp2 := Ctod( '15/' + Substr(Dtos(dDataBase),5,2) + '/' + Substr(Dtos(dDataBase),1,4) )
					_dDtp3 := dDataBase
										
					If SR8->R8_TIPO == 'Q' // Maternidade 
						fGeraVerba("457",_nValor,,,,,,,,,.T.)					
						Exit
					Endif						

					If SR8->R8_TIPO $ 'O/P' 
						// Saida de Afastamento 
															
						If (SR8->R8_DATAINI + 365) >= dDataBase
							If SR8->R8_DATAFIM == Ctod(Space(08)) 
								fGeraVerba("457",_nValor,,,,,,,,,.T.) 
								Exit 
							Endif 
						Endif 
					Endif 
					SR8->(DbSkip()) 

				Enddo
    		
    		Endif
    		

		Else
			
			If _nFaltas <= 0.15 
				fGeraVerba("457",_nValor,,,,,,,,,.T.) 
			Endif 
			
		Endif	


	Endif

Endif

Return(.T.) 