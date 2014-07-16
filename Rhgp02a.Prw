#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function rhgp02a()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _NDIAS,_NVALOR,_NEMPRE,_DIAS,_nRecno, _nSalario

DbSelectArea("SR6")
DbSetOrder(1)
_nRecno := SR6->(Recno())
SR6->(DbGoTop())
_nDias  := 25
_nValor := 16
_nEmpre := 0
_nRecno := 0
_nSalario := 0

If SRA->RA_VALEREF <> Space(02)
    _nEmpre := GetMV("MV_VREMPRE")


   If SRA->RA_CATFUNC = 'H'
      _nSalario := (SRA->RA_SALARIO * SRA->RA_HRSMES)	   

   Else
      _nSalario := SRA->RA_SALARIO	  

   Endif

             
	If SM0->M0_CODIGO == 'FN'
   
		If SM0->M0_CODFIL = '01'

			If _nSalario <= 2188.37
				_nValor := 31.00
			    _nEmpre := 136.20
			Elseif _nSalario >= 2188.38 .and. _nSalario <= 3643.31
				_nValor := 34.00   	
			    _nEmpre := 133.20
			    
			Elseif _nSalario >= 3643.32 .and. _nSalario <= 7172.13
				_nValor := 52.44
			    _nEmpre := 114.76
			    
			Elseif _nSalario >= 7172.14
				_nValor := 59.54
			    _nEmpre := 107.66
			    	
			Endif


		Elseif SM0->M0_CODFIL = '02'  // Pernambuco

			_nValor := 24.15 
		    _nEmpre := 136.20	
		
		Endif	


	Else

		If _nSalario <= 2188.37 
			_nValor := 31.00 
		    _nEmpre := 136.20			

		Elseif _nSalario >= 2188.38 .and. _nSalario <= 3643.31 
			_nValor := 34.00 
		    _nEmpre := 133.20			

		Elseif _nSalario >= 3643.32 .and. _nSalario <= 7172.13 
			_nValor := 52.44 
		    _nEmpre := 114.76

		Elseif _nSalario >= 7172.14 
			_nValor := 59.54  
			_nEmpre := 107.66
			    	
		Endif

	Endif 


   If DiasTrab>=30
      fGeraVerba("788",(_nEmpre *_nDias) - _nValor,,,,,,,,,.T.)
   Elseif (DiasTrab==28 .or. DiasTrab==29) .and. Month(dDataBase)==2
      fGeraVerba("788",(_nEmpre*_nDias) - _nValor,,,,,,,,,.T.)
   Else   
      fGeraVerba("788",((_nEmpre*_nDias)*(DiasTrab/30)) - _nValor,,,,,,,,,.T.)
   Endif

EndIf
SR6->(DbGoto(_nRecno))

Return(.t.)
