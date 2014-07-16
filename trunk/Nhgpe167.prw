/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE167  ºAutor  ³Marcos R Roquitski  º Data ³  26/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo holerite Banco Itau.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#include "topconn.ch" 

User Function Nhgpe167()

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,")
SetPrvt("nHdl,cLin,cFnl,_cMat")

If !Pergunte("NHGP125",.T.)
	Return
Endif

//Depositos
fTmp0Dep()
DbSelectArea("TMP0")
If !Empty(TMP0->RA_MAT) 
	If SM0->M0_CODIGO == "FN"	// Fundicao
		cArqDep := "FNHO" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	Else
		cArqDep := "NHHO" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	Endif	
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqDep)
	lEnd    := .F.

	MsAguarde ( {|lEnd| fArqDep() },"Aguarde","Gerando arquivo...",.T.)

Endif

If Select("TMP0") > 0
	TMP0->(dbCloseArea())
EndIf

Return


// Holerite Banco Itau
Static Function fArqDep()
Local nSega := nSegd := nSege := nSegt := 1
Local _nTotsa := 0
Local _cMat := Space(06)
Local _n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701Irrf := _n735Fgts := _nVlSct := 0


	nlin := 0
	
	** Header - do Arquivo
	cLin := "341"
	cLin := cLin + "0000"
	cLin := cLin + "0"
	cLin := cLin + Space(6)
	cLin := cLin + "080"
	cLin := cLin + "2"
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + Space(20)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Space(01)
	cLin := cLin + fGeracc()
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,30)
	cLin := cLin + "BANCO ITAU                    "
	cLin := cLin + Space(10)
	cLin := cLin + "1"
	cLin := cLin + Substr(Dtos(date()),7,2) + Substr(Dtos(date()),5,2) + Substr(Dtos(date()),1,4) 
	cLin := cLin + Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)  
	cLin := cLin + "000000000"
	cLin := cLin + "00030"
	cLin := cLin + Space(69)

	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))


	** Header de Lote 
	cLin := "341"
	cLin := cLin + "0001"
	cLin := cLin + "1"
	cLin := cLin + "C"
	cLin := cLin + "30" 
	cLin := cLin + "01" 
	cLin := cLin + "040"
	cLin := cLin + Space(01)
	cLin := cLin + "2"
	cLin := cLin + Subst(SM0->M0_CGC,1,14)
	cLin := cLin + Space(20)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Space(01) 
	cLin := cLin + fGeracc() 
	cLin := cLin + Subst(SM0->M0_NOMECOM,1,30)
	cLin := cLin + '01'     
	cLin := cLin + Space(38)
	cLin := cLin + Subst(SM0->M0_ENDCOB,1,30)
	cLin := cLin + "01000"
	cLin := cLin + Space(15)
	cLin := cLin + Substr(SM0->M0_CIDCOB,1,20) 
	cLin := cLin + Substr(SM0->M0_CEPCOB,1,8) 
	cLin := cLin + Substr(SM0->M0_ESTCOB,1,2) 
	cLin := cLin + Space(18) 
	nSegt++
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	TMP0->(DbGotop())

	While !TMP0->(Eof())


		** SEGMENTO A 
		cLin := "341" 
		cLin := cLin + "0001" 
		cLin := cLin + "3" 
		cLin := cLin + StrZero(nSega,5) 
		cLin := cLin + "A" 
		cLin := cLin + "001" 
		cLin := cLin + "000" 
		cLin := cLin + "341" 
     
        // Agencia, Conta favorecido
		cLin := cLin + "0"
		cLin := cLin + Substr(TMP0->RA_BCDEPSA,4,4) // Agencia
		cLin := cLin + Space(01)
		cLin := cLin + StrZero(Val(Substr(TMP0->RA_CTDEPSA,1,5)),12) // Conta corrente
		cLin := cLin + Space(01)
		cLin := cLin + Substr(TMP0->RA_CTDEPSA,6,1) // DAC 
		cLin := cLin + Substr(TMP0->RA_NOME,1,30)
		cLin := cLin + Space(20)
		cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
		cLin := cLin + "REA" 
		cLin := cLin + "000000000000000" 
		cLin := cLin + StrZero(TMP0->RC_VALOR*100,15)
		cLin := cLin + Space(20) 
		cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
		cLin := cLin + StrZero(TMP0->RC_VALOR*100,15)
		cLin := cLin + "HP01"
		cLin := cLin + Space(16)
		cLin := cLin + "000000"
		cLin := cLin + StrZero(Val(TMP0->RA_CIC),14)
		cLin := cLin + "00"
		cLin := cLin + "00000"
		cLin := cLin + "00000"
		cLin := cLin + "0"
		cLin := cLin + Space(10) 
		nSegt++
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 


		fTmp1Dep(TMP0->RA_MAT)
		
		// Segmento D
		DbSelectarea("TMP1")
		TMP1->(DbGotop())
		While !TMP1->(Eof())		

			If TMP0->RA_MAT <> TMP1->RA_MAT
				TMP1->(DbSkip())
				Loop
			Endif		
			If SRV->(DbSeek(xFilial("SRV") + TMP1->RC_PD)) // Verbas
						
				If TMP1->RC_PD == '736' // FGTS	
					_n736Fgts := TMP1->RC_VALOR
				Endif	
			
				If 	SRV->RV_TIPOCOD == '1' // Provento
					_nVlCre += TMP1->RC_VALOR
				Endif
				
				If SRV->RV_TIPOCOD == '2' // Desconto
					_nVlDeb += TMP1->RC_VALOR
				Endif
				
				If TMP1->RC_PD == '799'
					_nVlLiq := TMP1->RC_VALOR
					_nTotsa += TMP1->RC_VALOR					
				Endif
				
				If TMP1->RC_PD == '715'
					_nVlSct += TMP1->RC_VALOR
				Endif
				
				If TMP1->RC_PD == '716'
					_nVlSct += TMP1->RC_VALOR
				Endif


				If TMP0->RA_CATFUNC == 'H'	
					_nVlSal := TMP0->RA_SALARIO  // * TMP0->RA_HRSMES)
				Endif

				If TMP0->RA_CATFUNC == 'M'	
					_nVlSal := TMP0->RA_SALARIO 
				Endif

				If TMP1->RC_PD == '701' // BASE DO I.R.R.F
					_n701Irrf := TMP1->RC_VALOR
				Endif	

				If TMP1->RC_PD == '735' // BASE DO F.G.T.S
					_n735Fgts := TMP1->RC_VALOR
				Endif	
	
			Endif	

			TMP1->(DbSkip())			
		Enddo

		** SEGMENTO D
		cLin := "341" 
		cLin := cLin + "0001" 
		cLin := cLin + "3" 
		cLin := cLin + StrZero(nSega,5) 
		cLin := cLin + "D" 
		cLin := cLin + Space(03)
		cLin := cLin + Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
		cLin := cLin + TMP0->RC_CC + Space(6)
		cLin := cLin + TMP0->RC_MAT+Space(9)
		_cDescFunc := Space(30)
		If SRJ->(DbSeek(xFilial("SRJ") + TMP0->RA_CODFUNC))
			_cDescFunc := TMP0->RA_CODFUNC + ' ' + SRJ->RJ_DESC+Space(05)
		Endif	
		cLin := cLin + _cDescFunc
		cLin := cLin + "00000000"
		cLin := cLin + "00000000"
		cLin := cLin + StrZero(Val(TMP0->RA_DEPIR),2)
		cLin := cLin + StrZero(Val(TMP0->RA_DEPSF),2)
		cLin := cLin + "40"
		cLin := cLin + StrZero(_nVlSct*100,15)
		cLin := cLin + StrZero(_n736Fgts*100,15)
		cLin := cLin + StrZero(_nVlCre*100,15)
		cLin := cLin + StrZero(_nVlDeb*100,15)		
		cLin := cLin + StrZero(_nVlLiq*100,15)				
		cLin := cLin + StrZero(_nVlSal*100,15)		
		cLin := cLin + StrZero(_n701Irrf*100,15)
		cLin := cLin + StrZero(_n735Fgts*100,15)
		cLin := cLin + "02"
		cLin := cLin + Space(13)

		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 
		nSegt++		
		_n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701irrf := _n735Fgts := _nVlSct := 0


		** SEGMENTO E - processa Provento/Credito
		cLin := "341"
		cLin := cLin + "0001"
		cLin := cLin + "3"
		cLin := cLin + StrZero(nSega,5)
		cLin := cLin + "E"
		cLin := cLin + Space(03)

		// Segmento E processa Provento/Credito
		cLin := cLin + '1'				
		_nE := 0
		DbSelectarea("TMP1")
		TMP1->(DbGotop())
		While !TMP1->(Eof())		

			If TMP0->RA_MAT <> TMP1->RA_MAT
				TMP1->(DbSkip())
				Loop
			Endif		

			If SRV->(DbSeek(xFilial("SRV") + TMP1->RC_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito

					If (_nE + 1 > 4) 


						cLin := cLin + Space(22)
						cLin := cLin + cFnl 
						fWrite(nHdl,cLin,Len(cLin)) 
						nSegt++						
						_nE := 0
						
						** SEGMENTO E - nova linha
						cLin := "341"
						cLin := cLin + "0001"
						cLin := cLin + "3"
						cLin := cLin + StrZero(nSega,5)
						cLin := cLin + "E"
						cLin := cLin + Space(03)
						cLin := cLin + '1'

					Endif	
					cLin := cLin + SRV->RV_COD + ' '+Substr(SRV->RV_DESC,1,18)+SPACE(01) + Str(TMP1->RC_HORAS,7,2) + Space(05)					
					cLin := cLin + StrZero(TMP1->RC_VALOR*100,15)

					//cLin := cLin + SRV->RV_COD + ' '+SRV->RV_DESC+SPACE(11)
					//cLin := cLin + StrZero(TMP1->RC_VALOR*100,15)
					_nE  += 1
				Endif
				
			Endif
			TMP1->(DbSkip())
		
		Enddo
		If _nE == 1
			cLin := cLin + Space(35) + '000000000000000'
			cLin := cLin + Space(35) + '000000000000000'
			cLin := cLin + Space(35) + '000000000000000'		
		Elseif _nE == 2	
			cLin := cLin + Space(35) + '000000000000000'
			cLin := cLin + Space(35) + '000000000000000'		
		Elseif _nE == 3
			cLin := cLin + Space(35) + '000000000000000'		
		Endif	
		cLin := cLin + Space(22)
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 
		nSegt++		
		_nE := 0

		** SEGMENTO E - processa Desconto/Debito
		cLin := "341" 
		cLin := cLin + "0001" 
		cLin := cLin + "3" 
		cLin := cLin + StrZero(nSega,5) 
		cLin := cLin + "E" 
		cLin := cLin + Space(03)

		// Segmento E processa Provento/Credito
		cLin := cLin + '2'				
		_nE := 0
		DbSelectarea("TMP1")
		TMP1->(DbGotop())
		While !TMP1->(Eof())		

			If TMP0->RA_MAT <> TMP1->RA_MAT
				TMP1->(DbSkip())
				Loop
			Endif		

			If SRV->(DbSeek(xFilial("SRV") + TMP1->RC_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '2' // Provento/Credito

					If (_nE + 1 > 4) 

						cLin := cLin + Space(22)
						cLin := cLin + cFnl 
						fWrite(nHdl,cLin,Len(cLin)) 
						nSegt++						
						_nE := 0
						
						** SEGMENTO E - nova linha
						cLin := "341"
						cLin := cLin + "0001"
						cLin := cLin + "3"
						cLin := cLin + StrZero(nSega,5)
						cLin := cLin + "E"
						cLin := cLin + Space(03)
						cLin := cLin + '2'										

					Endif	
					cLin := cLin + SRV->RV_COD + ' '+Substr(SRV->RV_DESC,1,18)+SPACE(01) + Str(TMP1->RC_HORAS,7,2) + Space(05)					
					cLin := cLin + StrZero(TMP1->RC_VALOR*100,15)

					//cLin := cLin + SRV->RV_COD + ' '+SRV->RV_DESC+SPACE(11)
					//cLin := cLin + StrZero(TMP1->RC_VALOR*100,15)
					_nE  += 1
				Endif
				
			Endif
			TMP1->(DbSkip())
		
		Enddo
		If _nE == 1
			cLin := cLin + Space(35) + '000000000000000'
			cLin := cLin + Space(35) + '000000000000000'
			cLin := cLin + Space(35) + '000000000000000'		
		Elseif _nE == 2	
			cLin := cLin + Space(35) + '000000000000000'
			cLin := cLin + Space(35) + '000000000000000'		
		Elseif _nE == 3
			cLin := cLin + Space(35) + '000000000000000'		
		Endif	
		cLin := cLin + Space(22)
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 
		nSegt++		
		_nE := 0
		nSega++	
		TMP0->(DbSkip())
	
	Enddo

cLin := "341" 
cLin := cLin + "0001" 
cLin := cLin + "5" 
cLin := cLin + Space(09) 
cLin := cLin + StrZero(nSegt,6) 
cLin := cLin + StrZero(_nTotsa*100,18) 
cLin := cLin + StrZero(0,18) 
cLin := cLin + Space(181) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

cLin := "341" 
cLin := cLin + "9999" 
cLin := cLin + "9" 
cLin := cLin + Space(09) 
cLin := cLin + "000001"
cLin := cLin + StrZero(nSegt+2,6) 
cLin := cLin + Space(211) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 


DbSelectArea("TMP0")
DbCloseArea("TMP0")

DbSelectArea("TMP1")
DbCloseArea("TMP1")


Return(nil)



Static Function fGeracc()
Local _cRet,cConta,i
Local cDac := ''

	cConta    := StrZero(Val(Substr(MV_PAR03,1,AT("-",MV_PAR03))),12,0)
	i := 1
	For i := 1 To 12
		If Substr(MV_PAR03,i,1) == "-"
			cDac := cDac + Substr(MV_PAR03,i+1,2)
			Exit
		Endif
	Next
	cDac := Alltrim(cDac)
      
	If Len(cDac) == 1
		_cRet := cConta+Space(01)+cDac
	Else
		_cRet := cConta+cDac
	Endif
	
Return(_cRet)



Static Functio fGeraag()
Local _cAgencia := _cConta := _cRet :=  _cDac := ''

	_cAgencia  := StrZero(Val(Substr(TMP0->ZRA_AGENCI,1,4)),5,0)+Substr(TMP->ZRA_AGENCI,5,1)
	_cConta    := StrZero(Val(Substr(TMP0->ZRA_CONTA,1,AT("-",TMP->ZRA_CONTA))),12,0)

	i := 1
	For i := 1 To 12
		If Substr(TMP->ZRA_CONTA,i,1) == "-"
			_cDac := _cDac + Substr(TMP->ZRA_CONTA,i+1,2)
			Exit
		Endif
	Next
	_cDac   := Alltrim(_cDac)
      
	If     Len(_cDac) == 1
		_cRet := _cAgencia+_cConta+_cDac+" "
	Elseif Len(_cDac) == 2
		_cConta := StrZero(Val(Substr(TMP->ZRA_CONTA,1,AT("-",TMP->ZRA_CONTA))),12,0)
		_cRet   := _cAgencia+_cConta+_cDac 
	Else
		_cRet   := _cAgencia+_cConta+Space(02)
	Endif

Return(_cRet) 



Static Functio fGeraat()
Local _cAgencia := _cConta := _cRet :=  _cDac := ''

	_cAgencia  := StrZero(Val(Substr(TMT->ZRA_AGENCI,1,4)),5,0)+Substr(TMT->ZRA_AGENCI,5,1)
	_cConta    := StrZero(Val(Substr(TMT->ZRA_CONTA,1,AT("-",TMT->ZRA_CONTA))),12,0)

	i := 1
	For i := 1 To 12
		If Substr(TMT->ZRA_CONTA,i,1) == "-"
			_cDac := _cDac + Substr(TMT->ZRA_CONTA,i+1,2)
			Exit
		Endif
	Next
	_cDac   := Alltrim(_cDac)
      
	If     Len(_cDac) == 1
		_cRet := _cAgencia+_cConta+_cDac+" "
	Elseif Len(_cDac) == 2
		_cConta := StrZero(Val(Substr(TMT->ZRA_CONTA,1,AT("-",TMT->ZRA_CONTA))),12,0)
		_cRet   := _cAgencia+_cConta+_cDac 
	Else
		_cRet   := _cAgencia+_cConta+Space(02)
	Endif

Return(_cRet) 


Static Functio fGerado()
Local _cAgencia := _cConta := _cRet :=  _cDac := ''

	_cAgencia  := StrZero(Val(Substr(TMD->ZRA_AGENCI,1,4)),5,0)+Substr(TMD->ZRA_AGENCI,5,1)
	_cConta    := StrZero(Val(Substr(TMD->ZRA_CONTA,1,AT("-",TMD->ZRA_CONTA))),12,0)

	i := 1
	For i := 1 To 12
		If Substr(TMD->ZRA_CONTA,i,1) == "-"
			_cDac := _cDac + Substr(TMD->ZRA_CONTA,i+1,2)
			Exit
		Endif
	Next
	_cDac   := Alltrim(_cDac)
      
	If     Len(_cDac) == 1
		_cRet := _cAgencia+_cConta+_cDac+" "
	Elseif Len(_cDac) == 2
		_cConta := StrZero(Val(Substr(TMD->ZRA_CONTA,1,AT("-",TMD->ZRA_CONTA))),12,0)
		_cRet   := _cAgencia+_cConta+_cDac 
	Else
		_cRet   := _cAgencia+_cConta+Space(02)
	Endif

Return(_cRet) 


// Liquidos
Static Function fTmp0Dep()

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRC') + " RC "
cQuery += "WHERE RC.D_E_L_E_T_ = ' ' "  
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
cQuery += "AND RC.RC_FILIAL = '" + xFilial("SRC")+ "'"
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '341' " 
cQuery += "AND RA.RA_MAT BETWEEN '"+ Mv_par06 + "' AND '"+ Mv_par07 + "' "
cQuery += "AND RC.RC_MAT = RA.RA_MAT "
cQuery += "AND RC.RC_PD = '799' "
cQuery += "ORDER BY RA.RA_MAT "

TCQUERY cQuery NEW ALIAS "TMP0"
//TcSetField("TMP","ZRC_DATA","D") // Muda a data de string para date.

DbSelectArea("TMP0")
TMP0->(Dbgotop())

// Movimento
Static Function fTmp1Dep(_cMat)

If Select("TMP1") > 0
	dbSelectArea("TMP1")
	dbCloseArea()
Endif

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRC') + " RC "
cQuery += "WHERE RC.D_E_L_E_T_ = ' ' "  
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "'" 
cQuery += "AND RC.RC_FILIAL = '" + xFilial("SRC")+ "'"
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '341' " 
cQuery += "AND RA.RA_MAT = '"+ _cMat + "'" 
cQuery += "AND RC.RC_MAT = '"+ _cMat + "'" 
cQuery += "ORDER BY RA.RA_MAT, RC.RC_PD"

TCQUERY cQuery NEW ALIAS "TMP1" 

DbSelectArea("TMP1")
TMP1->(Dbgotop())

Return