#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fileio.ch" 
USER FUNCTION SALDOINI()
cCodEmp := 'FN'
cCodFil := '01'
cModulo := 'EST'

	prepare environment empresa cCodEmp filial cCodFil modulo cModulo
	
	cProd  := 'VWB01.5.0001.02'
	cLocal := '32'
	cLote  := '2L07-1'
	cLocal := '01'
	
	SB1->(dbsetorder(1))
	If !SB1->(dbseek(xFilial('SB1')+cProd))
		Return
	Endif
	
	SB9->(dbsetorder(1)) // B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA))
	If !SB9->(dbseek(xFilial('SB9')+cProd+cLocal))
		return
	endif
	
	SBJ->(dbsetorder(1)) //BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL+BJ_NUMLOTE+DTOS(BJ_DATA)                                                                                                   
	
	While SB9->(!EOF()) .AND. ALLTRIM(B9_COD)==cProd .and. Alltrim(B9_LOCAL)==cLocal
		If SBJ->(dbseek(xFilial('SBJ')+cProd+cLocal))
			RecLock('SBJ')
		
		Endif
		
		SB9->(dbskip())
	Endif
      
	//nsaldo := CALCEST("IVE03.1.0134.02","34",CtoD('12/11/2012'))
	
RETURN nsaldo