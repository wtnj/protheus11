/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE207  ºAutor  ³Marcos R. Roquitski º Data ³  03/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao rateio plano de saude e odontologico.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
                         

User Function Nhgpe207()
Private cPerg := "GPE180"

If Pergunte(cPerg,.T.)

	Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
	Processa( {|| GravaRhs() },"Gravando")

Endif

Return

// - Gerando
Static Function Gerando()
	cQuery := "SELECT RD.RD_MAT,RD.RD_DATARQ,RD.RD_VALOR,RD.RD_PD,RD.RD_DATPGT,RA.RA_NOME,RA.RA_MAT "
	cQuery := cQuery + " FROM " + RetSqlName( 'SRA' ) + " RA, " + RetSqlName( 'SRD' ) + " RD " 
	cQuery := cQuery + "WHERE RD.D_E_L_E_T_ = ' ' "
	cQuery := cQuery + "AND RA.RA_MAT = RD.RD_MAT "
	cQuery := cQuery + "AND RD.RD_DATPGT BETWEEN '20130101' AND '20131231' "
	cQuery := cQuery + "AND RA.RA_FILIAL = '01' " 
	cQuery := cQuery + "AND RA.RA_MAT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	//cQuery := cQuery + "AND RA.RA_CC = '11005002' " 
	//cQuery := cQuery + "AND RA.RA_MAT BETWEEN '002512' AND '002512' " 
	cQuery := cQuery + "AND RD.RD_PD IN ('437','439','441') "
	cQuery := cQuery + " ORDER BY RD.RD_MAT,RD.RD_PD ASC "
	TCQUERY cQuery NEW ALIAS "ZTMP"

	TcSetField("ZTMP","RD_DATPGT","D") // Muda a data de string para date.

Return


// - Gravarhs
Static Function GravaRhs()
Local _dDados,_nPd437 := 0, _nDep := 1, _nPd439 := 0, _nPd441 := 0

ZTMP->(DbGoTop())
ProcRegua(ZTMP->(RecCount()))

While ZTMP->(!Eof()) 

	_cRdMat := ZTMP->RD_MAT 
	While ZTMP->RD_MAT == _cRdMat 
    	If ZTMP->RD_PD == '437' 
			_nPd437 := _nPd437 + ZTMP->RD_VALOR 
		Endif 
    	If ZTMP->RD_PD == '439' 
			_nPd439 := _nPd439 + ZTMP->RD_VALOR 
		Endif 
    	If ZTMP->RD_PD == '441' 
			_nPd441 := _nPd441 + ZTMP->RD_VALOR 
		Endif 
		ZTMP->(DbSkip()) 
	Enddo 

	_nDep := 1
	If SRB->(DbSeek(xFilial("SRB") + _cRdMat)) 
		Do While SRB->(!EOF()) .AND. _cRdMat == SRB->RB_MAT 
			If !Empty(SRB->RB_ASMEDIC) .AND. YEAR(SRB->RB_DTNASC) < 2012
				_nDep++ 
			Endif 
			SRB->(DbSkip()) 
		Enddo 
	Endif 

	If _nPd437 > 0 
		If RecLock("RHS",.T.)
			RHS->RHS_FILIAL		:= "01"
			RHS->RHS_MAT		:= _cRdMat
			RHS->RHS_DATA		:= Ctod("30/12/2013")
			RHS->RHS_ORIGEM		:= "1"						// 1 = Titular; 2 = Dependente; 3 = Agregado
			RHS->RHS_CODIGO		:= ""
			RHS->RHS_TPLAN		:= "1"          			// 1-Plano, 2-Co-Partic., 3-Reembolso
			RHS->RHS_TPFORN		:= "1"    		   			// 1-Assist. Medica, 2-Assist. Odontologica
			RHS->RHS_CODFORN	:= "001" 					// Codigo Fornecedor
			RHS->RHS_TPPLAN		:= "1"   					// 1 - Salarial, 2 - Etaria
			RHS->RHS_PLANO		:= "01"
			RHS->RHS_PD			:= "437"
			RHS->RHS_VLRFUN		:= (_nPd437 / _nDep)
			RHS->RHS_VLREMP		:= 0.00
			RHS->RHS_COMPPG		:= '201312' //ZTMP->RD_DATARQ
			RHS->RHS_DATPGT     := Ctod("30/12/2013")
			MsUnlock("RHS")
		Endif
	Endif


	If SRB->(DbSeek(xFilial("SRB") + _cRdMat)) .and. _nPd437 > 0
		Do While SRB->(!EOF()) .AND. _cRdMat == SRB->RB_MAT 
			If !Empty(SRB->RB_ASMEDIC) .AND. YEAR(SRB->RB_DTNASC) < 2012
				If RecLock("RHS",.T.)			
					RHS->RHS_FILIAL		:= "01"
					RHS->RHS_MAT		:= _cRdMat
					RHS->RHS_DATA		:= Ctod("30/12/2013")
					RHS->RHS_ORIGEM		:= "2"						// 1 = Titular; 2 = Dependente; 3 = Agregado
					RHS->RHS_CODIGO		:= SRB->RB_COD
					RHS->RHS_TPLAN		:= "1"          			// 1-Plano, 2-Co-Partic., 3-Reembolso
					RHS->RHS_TPFORN		:= "1"    		   			// 1-Assist. Medica, 2-Assist. Odontologica
					RHS->RHS_CODFORN	:= "001" 					// Codigo Fornecedor
					RHS->RHS_TPPLAN		:= "1"   					// 1 - Salarial, 2 - Etaria
					RHS->RHS_PLANO		:= "01"
					RHS->RHS_PD			:= "437"
					RHS->RHS_VLRFUN		:= (_nPd437 / _nDep)
					RHS->RHS_VLREMP		:= 0.00
					RHS->RHS_COMPPG		:= '201312' //ZTMP->RD_DATARQ
					RHS->RHS_DATPGT     := Ctod("30/12/2013")
					MsUnlock("RHS")
				Endif
			Endif	
			SRB->(DbSkip()) 
		Enddo
	Endif
	
	If _nPd439 > 0 
		If RecLock("RHS",.T.)
			RHS->RHS_FILIAL		:= "01"
			RHS->RHS_MAT		:= _cRdMat
			RHS->RHS_DATA		:= Ctod("30/12/2013")
			RHS->RHS_ORIGEM		:= "1"						// 1 = Titular; 2 = Dependente; 3 = Agregado
			RHS->RHS_CODIGO		:= ""
			RHS->RHS_TPLAN		:= "1"          			// 1-Plano, 2-Co-Partic., 3-Reembolso
			RHS->RHS_TPFORN		:= "2"    		   			// 1-Assist. Medica, 2-Assist. Odontologica
			RHS->RHS_CODFORN	:= "002" 					// Codigo Fornecedor
			RHS->RHS_TPPLAN		:= "1"   					// 1 - Salarial, 2 - Etaria
			RHS->RHS_PLANO		:= "01"
			RHS->RHS_PD			:= "439"
			RHS->RHS_VLRFUN		:= _nPd439
			RHS->RHS_VLREMP		:= 0.00
			RHS->RHS_COMPPG		:= '201312' //ZTMP->RD_DATARQ
			RHS->RHS_DATPGT     := Ctod("30/12/2013")
			MsUnlock("RHS")
		Endif
	Endif
	
	If _nPd441 > 0
		If RecLock("RHS",.T.)
			RHS->RHS_FILIAL		:= "01"
			RHS->RHS_MAT		:= _cRdMat
			RHS->RHS_DATA		:= Ctod("30/12/2013")
			RHS->RHS_ORIGEM		:= "1"						// 1 = Titular; 2 = Dependente; 3 = Agregado
			RHS->RHS_CODIGO		:= ""
			RHS->RHS_TPLAN		:= "2"          			// 1-Plano, 2-Co-Partic., 3-Reembolso
			RHS->RHS_TPFORN		:= "1"    		   			// 1-Assist. Medica, 2-Assist. Odontologica
			RHS->RHS_CODFORN	:= "001" 					// Codigo Fornecedor
			RHS->RHS_TPPLAN		:= "1"   					// 1 - Salarial, 2 - Etaria
			RHS->RHS_PLANO		:= "01"
			RHS->RHS_PD			:= "441"
			RHS->RHS_VLRFUN		:= _nPd441
			RHS->RHS_VLREMP		:= 0.00
			RHS->RHS_COMPPG		:= '201213' //ZTMP->RD_DATARQ
			RHS->RHS_DATPGT     := Ctod("30/12/2013")
			MsUnlock("RHS")
		Endif
	Endif
	_nPd441 := 0 
	_nPd437 := 0 
	_nPd439 := 0 
		
Enddo 

DbSelectArea("ZTMP") 
DbCloseArea() 

Return(nil) 
