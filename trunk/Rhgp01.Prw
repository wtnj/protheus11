/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RHGP01    ºAutor  ³Microsiga           º Data ³  10/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Desconto plano de saude.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Rhgp01()

Local _NVALOR,_NNU,_DEPEND,_VERBAT,_VERBAD,_NRECNO, _NSALARIO, _NMAIOR18

DbSelectArea("SRX")
DbSetOrder(1)
SRX->(DbGoTop())

DbSelectArea("SRB")
DbSetOrder(1)
_nRecno := SRB->(RECNO())
SRB->(DbGoTop())

_nValor    := 0
_nNu       := 0
_Depend    := 0
_VerbaT    := " "
_VerbaD    := " "
_nSalario  := 0
_nMaior18  := 0
_nIntegral := 142.50
      
If SRA->RA_ASMEDIC <> Space(02)

	  If SRA->RA_FILIAL == '02' // Pernambuco UNIMED

	      _Depend    := 84.90
    	  _nValor    := 84.90
	      _nIntegral := 0

	  Else // FUNDICAO

	      _Depend    := 97.30
    	  _nValor    := 97.30
	      _nIntegral := 163.88
	  
	  Endif
      
      If SRA->RA_ASMEDIC == "02"  // ENFERMARIA 

         If SRA->RA_CATFUNC = 'H' 
            _nSalario := (SRA->RA_SALARIO * SRA->RA_HRSMES)	   
         Else 
           _nSalario := SRA->RA_SALARIO	  
         Endif 

		 If SRA->RA_FILIAL == '01' // FUNDICAO 


 	         If _nSalario <= 2188.37 
    	        _nValor := 40.84

	         Elseif _nSalario >= 2188.38 .and. _nSalario <= 3643.31 
	            _nValor := 44.77 

	         Elseif _nSalario >= 3643.32 .and. _nSalario <= 7172.13 
	            _nValor := 50.19 

	         Elseif _nSalario > 7172.14 
	            _nValor := 52.07 
	         Endif 
	         
		     _nIntegral := 86.17 //-- INCLUIDA POR JOAOFR 09/01/2013 
	   		
	   	 Else // PERNAMBUCO 
	   	  
	         If _nSalario <= 2009.00 
    	        _nValor := 24.94 
	         Elseif _nSalario > 2009.01 .and. _nSalario <= 3345.00 
	            _nValor := 39.06 
	         Elseif _nSalario > 3345.01 .and. _nSalario <= 6585.00 
	            _nValor := 43.79 
	         Elseif _nSalario > 6585.01 
	            _nValor := 45.43 
	         Endif
	   		
 	         _nIntegral := _nValor

	   	 Endif	 

      Endif
      
	//-- DEPENDENTES
 
	_nNu := _nNu + 1
	_nMaior18 := 0
	SRB->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.T.))
	While !SRB->(Eof()) .and. SRA->RA_FILIAL==SRB->RB_FILIAL .and. SRA->RA_MAT==SRB->RB_MAT
	
		If SRB->RB_ASMEDIC <> Space(02)
			If (SRB->RB_GRAUPAR == "F" .OR. SRB->RB_GRAUPAR == "E")
				If Year(dDataBase) - Year(SRB->RB_DTNASC) < 17
    		    	_nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) >=19
				    _nMaior18++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) < Month(dDatabase)
			        _nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) > Month(dDatabase)
			        _nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) <=14
			        _nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 17 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) >=14
			        _nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) < Month(dDatabase)
				    _nMaior18++
			    
				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) > Month(dDatabase)
   			        _nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) > 14
   			        _nNu++

				Elseif Year(dDataBase) - Year(SRB->RB_DTNASC) == 18 .and. Month(SRB->RB_DTNASC) == Month(dDatabase) .and. Day(SRB->RB_DTNASC) <= 14
						    _nMaior18++
				Endif

			Else
   		        _nNu := _nNu + 1
			
			Endif

        Endif
        SRB->(DbSkip())
   Enddo

   //Endif

   If SRA->RA_ASMEDIC == "01"
      _VerbaT := "791"
   Endif

   If SRA->RA_ASMEDIC == "02"
      _VerbaT := "793"
   Endif

   If _VerbaT <> " "
      fGeraVerba(_VerbaT,(_Nvalor*_nNu) + (_nMaior18 * _nIntegral),_nNu,,,,,,,,.T.)
   Endif

   If _VerbaT == "791"
      _VerbaD := "792"
   Endif

   If _VerbaT == "793"
      _VerbaD := "794"
   Endif

   If _VerbaD <> " "
      fGeraVerba(_VerbaD,(_Depend -_Nvalor)*_nNu + (_nMaior18 * _nIntegral),_nNu + _nMaior18,,,,,,,,.T.)
   Endif

   fGeraVerba("437",(_Nvalor*_nNu) + (_nMaior18 * _nIntegral),_nNu+_nMaior18,,,,,,,,.T.)

Endif

DbSelectArea("SRB")
SRB->(DbGoto(_nRecno))

Return(.T.)
