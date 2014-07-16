/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE262  ºAutor  ³Marcos R. Roquitski º Data ³  03/07/2013.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Pagamento PPR rescisao.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe262()
Local _nValor  := 0
Local _nV139   := 0 
Local _nV421   := 0
Local _cAnoMes := Substr(Dtos(dDataBase),1,4)
Local _nMesAdm := 12
Local _nMesPro := 0
Local _nVPpr   := 0
Local _nV417   := 0

If M->RG_TIPORES == '02'
 
	For i = 1 to Len(aPd)
		
		If aPd[1,1] = '139' ; _nV139 := aPd[1,5]		
		Endif

	Next

    /*
	Valor da PLR anual (em R$)	Alíquota (em %)	Parcela a deduzir (em R$)
	Até 6.270,00	0 	***
	De 6.270,01 a 9.405,00	7,5	R$ 470,25
	De 9.405,01 a 12.540,00	15	R$ 1.175,62
	De 12.540,01 a 15.675,00	22,5	R$ 2.116,12
	Mais de 15.675,00	27,5	R$ 2.899,87
    */

	// Tabela I.R - exclusiva PLR
	_nValor := _nV139
			
	If _nValor <= 6270
		_nV417 := 0
				
	Elseif (_nValor >= 6270.01 .and. _nValor <= 9405.00)
		_nV417 := (((_nValor * 7.5)/100) - 470.25)
				
	Elseif (_nValor >= 9405.01 .and. _nValor <= 12540.00)
		_nV417 := (((_nValor * 15)/100) - 1175.62) 
				
	Elseif (_nValor >= 12540.01 .and. _nValor <= 15675.00)
		_nV417 := (((_nValor * 22.5)/100) - 2116.12)
				
	Elseif (_nValor >= 15675.01)
		_nV417 := (((_nValor * 27.5)/100) - 2899.87)

	Endif

	If _nV417 > 0 
		fGeraVerba("417",_nV417,,,,,,,,,.T.)
	
		_nTaxa  := ((_nValor * 3)/100)		
		fGeraVerba("421",_nTaxa,,,,,,,,,.T.)

    Endif


Endif

                           
 /*
	SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+'R'))
	While  !SRR->(Eof())  .AND. SRA->RA_FILIAL == SRR->RR_FILIAL .and. SRA->RA_MAT==SRR->RR_MAT
    
      If SRR->RR_PD == "139" //.AND. Substr(_cAnoMes,1,4) == Dtos(SRR->RR_DATA,1,4)
	         _nV139 := SRR->RR_VALOR
      Endif   

      SRR->(DbSkip())
	
	Enddo   

 	ALERT(_nV139)
Endif


	/*
	_cOrigem1 := "POABS01.TXT"
	
	If !File(_cOrigem1)
	   MsgBox("Arquivo de Faltas/Absenteismo nao Localizado: " + _cOrigem1,"Arquivo Retorno","INFO")
	   Return
	Endif

	// Arquivo a ser trabalhado
	_aStruct:={{ "LINHA","C",50,0}}

	_cTr1 := CriaTrab(_aStruct,.t.)
	USE &_cTr1 Alias TFAL New Exclusive
	Append From (_cOrigem1) SDF

	_nFaltas := 0
	DbSelectArea("TFAL") 
	TFAL->(DbgoTop()) 
	While !TFAL->(Eof())
		If SRA->RA_MAT == Substr(TFAL->LINHA,1,6)
			_nFaltas += Val(Substr(TFAL->LINHA,8,20))
		Endif 
		TFAL->(Dbskip()) 
	Enddo 
	TFAL->(DbCloseArea()) 

	SRD->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+_cAnoMes))
	While  !SRD->(Eof())  .AND. SRA->RA_FILIAL == SRD->RD_FILIAL .and. SRA->RA_MAT==SRD->RD_MAT
    
      If SRD->RD_PD == "139" .AND. Substr(_cAnoMes,1,4) == Substr(SRD->RD_DATARQ,1,4)
	         _nV139 := SRD->RD_VALOR
      Endif   

      If SRD->RD_PD == "421" .AND. Substr(_cAnoMes,1,4) == Substr(SRD->RD_DATARQ,1,4)
	         _nV421 := SRD->RD_VALOR
      Endif   
      
      SRD->(DbSkip())
	
	Enddo   

	If Year(SRA->RA_ADMISSA) >= Year(dDataBase)

		If Day(SRA->RA_ADMISSA) <= 15
			_nMesAdm := 12 - Month(SRA->RA_ADMISSA)

		Else
			If Month(SRA->RA_ADMISSA) == 12
				_nMesAdm := 0                       	
				
			Else
				_nMesAdm := (12 - (Month(SRA->RA_ADMISSA)+ 1))
	
			Endif
					
		Endif	

	Endif



    If _nV139 > 0

		If Day(M->RG_DATADEM) < 15
			_nMesPro := Month(M->RG_DATADEM) - 1

		Else                                                                          

			If Month(M->RG_DATADEM) == 12
				_nMesPro := 12
				
			Else
				_nMesPro := Month(M->RG_DATADEM) 
	
			Endif
					
		Endif	
	
		_nFaltas := (_nFaltas * 5)
		_nVlrAbs := 0
		_nDifAbs := 0

		If _nFaltas > 0
			_nVPpr   := ((11000 * _nMesPro)/12)
			_nValor  := ((_nVPpr * _nMesAdm)/12) 
		
			// Desconto faltas	
			_nVlrAbs := ((_nValor * _nFaltas)/100)
			_nDifAbs := (_nValor - _nVlrAbs)
			

			If _nDifAbs > 6000 

				_nValor  := _nDifAbs 

			Else

				_nValor  := 0
							
			Endif	
				
			_nTaxa  := (((_nValor - _nV139 -_nV421)* 3)/100)		

		Else
		
			_nVPpr  := ((11000 * _nMesPro)/12)
			_nValor := ((_nVPpr * _nMesAdm)/12) 
			_nTaxa  := (((_nValor - _nV139 -_nV421)* 3)/100)		

		Endif	
		

		If _nValor > 0


			// Tabela I.R - exclusiva PLR
			If _nValor <= 6000 
				_nV417 := 0
				
			Elseif (_nValor >= 6000.01 .and. _nValor <= 9000.00)
				_nV417 := (((_nValor * 7.5)/100) - 450)
				
			Elseif (_nValor >= 9000.01 .and. _nValor <= 12000.00)
				_nV417 := (((_nValor * 15)/100) - 1125)                 	
				
			Elseif (_nValor >= 12000.01 .and. _nValor <= 15000.00)
				_nV417 := (((_nValor * 22.5)/100) - 2025)
				
			Endif

			If _nValor > 0 ; fGeraVerba("138",_nValor,,,,,,,,,.T.)
			Endif

			If _nV139 > 0 ;	fGeraVerba("432",_nV139,,,,,,,,,.T.)
			Endif	

			If _nTaxa > 0 ;	fGeraVerba("421",_nTaxa,,,,,,,,,.T.)
			Endif	

			If _nV417 > 0 ;	fGeraVerba("417",_nV417,,,,,,,,,.T.)
			Endif	


		Endif	
		

	Endif
Endif
*/

Return(.T.)    

