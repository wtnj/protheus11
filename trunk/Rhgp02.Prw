/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RHGP02    ºAutor  ³Microsiga           º Data ³  10/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Desconto refeicao.                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Rhgp02()

Local _NVALOR, _nRecno, _nSalario

DbSelectArea("SR6")
DbSetOrder(1)
_nRecno := SR6->(RECNO())
SR6->(DbGoTop())
_nValor := 0         
_nSalario := 0


If SRA->RA_VALEREF <> Space(02)

	If SRA->RA_CATFUNC = 'H'
		_nSalario := (SRA->RA_SALARIO * SRA->RA_HRSMES)

	Else
		_nSalario := SRA->RA_SALARIO	  
	
	Endif      


/* 	 	 	 
Faixa Salarial	Desconto funcionário
R$ 1.433,47	a	R$ 2.188,37	R$ 30,99
R$ 2.189,97	a	R$ 3.643,31	R$ 36,41
R$ 3.644,49	a	R$ 7.172,13	R$ 53,87
Acima de	 	R$ 7.172,13	R$ 61,16

*/


	If SM0->M0_CODIGO == 'FN'
   
		If SM0->M0_CODFIL = '01'

			If _nSalario <= 2188.37
				_nValor := 31.00

			Elseif _nSalario >= 2188.38 .and. _nSalario <= 3643.31
				_nValor := 34.00   	

			Elseif _nSalario >= 3643.32 .and. _nSalario <= 7172.13
				_nValor := 52.44

			Elseif _nSalario >= 7172.14
				_nValor := 59.54
	
			Endif


		Elseif SM0->M0_CODFIL = '02'  // Pernambuco

			_nValor := 24.15 
	
		
		Endif	


	Else

		If _nSalario <= 2188.37 
			_nValor := 31.00 

		Elseif _nSalario >= 2188.38 .and. _nSalario <= 3643.31 
			_nValor := 34.00 

		Elseif _nSalario >= 3643.32 .and. _nSalario <= 7172.13 
			_nValor := 52.44 

		Elseif _nSalario >= 7172.14 
			_nValor := 59.54  
	
		Endif

	Endif 

	If DiasTrab>=30 
		fGeraVerba("433",_nValor,,,,,,,,,.T.) 

	Elseif (DiasTrab==28 .or. DiasTrab==29) .and. Month(dDataBase)==2 
		fGeraVerba("433",_nValor,,,,,,,,,.T.) 
	
	Else 
		fGeraVerba("433",_nValor/30*DiasTrab,,,,,,,,,.T.) 

	Endif


Endif
SR6->(DbGoto(_nRecno))

Return(.T.)