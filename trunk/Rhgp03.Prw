/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RHGP03    ºAutor  ³Microsiga           º Data ³  03/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Roteiro de calculo para desconto da mensalidade sindical.  º±±
±±º          ³ e desconto da contribuicao assistencial.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch" 

User Function Rhgp03() 

Local _NSALARIO,_NVALOR

SetPrvt("_cOrigem, _aStruct, _cTr1, _cSituacao, lEnd")

_nSalario := 0
_nValor   := 0


If SM0->M0_CODIGO == 'FN' .AND. SM0->M0_CODFIL == '02'

	If SRA->RA_CATFUNC = 'H'
		_nSalario := (SRA->RA_SALARIO * SRA->RA_HRSMES)

	Else
		_nSalario := SRA->RA_SALARIO	  
	
	Endif      

	//Contribuição Assistencial: Criar Desconto de R$ 5,11 para salários até R$ 809,42 e acima desconto de R$ 6,99, fixo mensal.

	If _nSalario <= 809.42
		_nValor := 5.11

	Else
		_nValor := 6.99

	Endif

	If (SRA->RA_MENSALI == "M" .AND. SRA->RA_SITFOLH <> 'D' .AND. SRA->RA_SITFOLH <> 'A')	

		fGeraVerba("459",_nValor,,,,,,,,,.T.)	

	Endif	


Else

	If dDataBase >= Ctod('01/07/2014') // Conforme acordo sindical de 2013 nao descontar mensalidade 

		If SRA->RA_CATFUNC=="M"
		   _nSalario:=SRA->RA_SALARIO

		Else
		   _nSalario:=SRA->RA_SALARIO*SRA->RA_HRSMES
	
		Endif

		If (SRA->RA_MENSALI == "M" .AND. SRA->RA_SITFOLH <> 'D' .AND. SRA->RA_SITFOLH <> 'A')
		   _nValor := _nSalario * GetMV("MV_MENSALI") / 100

		   If _nValor > GetMV("MV_MENSTET")
    		  _nValor:= GetMV("MV_MENSTET")
	
		   EndIf
		   fGeraVerba("422",_nValor,GetMV("MV_MENSALI"),,,,,,,,.T.)
	
		Endif

		If SRA->RA_MENSALI == "C"
		   _nValor:= _nSalario * GetMV("MV_MENSALI") / 100
		   fGeraVerba("423",_nValor,GetMV("MV_MENSALI"),,,,,,,,.T.)
		Endif
	
	Endif	

	If (SRA->RA_MENSALI == "M" .AND. SRA->RA_SITFOLH <> 'D' .AND. SRA->RA_SITFOLH <> 'A')
	
		_cOrigem1 := "RHSIND01.TXT" 
	
		If !File(_cOrigem1)
		   MsgBox("Arquivo Desconto mensalidade sindical nao Localizado: " + _cOrigem1,"Arquivo Retorno","INFO")
		   Return
		Endif

		// Arquivo a ser trabalhado
		_aStruct:={{ "LINHA","C",50,0}}

		_cTr1 := CriaTrab(_aStruct,.t.)
		USE &_cTr1 Alias TFAL New Exclusive
		Append From (_cOrigem1) SDF

		DbSelectArea("TFAL") 
		TFAL->(DbgoTop()) 
		While !TFAL->(Eof())
			If SRA->RA_MAT == Substr(TFAL->LINHA,1,6)

				If SRA->RA_CATFUNC=="M"
				   _nSalario:=SRA->RA_SALARIO

				Else
				   _nSalario:=SRA->RA_SALARIO*SRA->RA_HRSMES
	
				Endif

				If (SRA->RA_MENSALI == "M" .AND. SRA->RA_SITFOLH <> 'D' .AND. SRA->RA_SITFOLH <> 'A')
				   _nValor := _nSalario * GetMV("MV_MENSALI") / 100

				   If _nValor > GetMV("MV_MENSTET")
		    		  _nValor:= GetMV("MV_MENSTET")
	
				   EndIf
				   fGeraVerba("422",_nValor,GetMV("MV_MENSALI"),,,,,,,,.T.)
	
				Endif

			Endif 
			TFAL->(Dbskip()) 
	
		Enddo 
		TFAL->(DbCloseArea()) 

	Endif

Endif	

Return(.T.)
