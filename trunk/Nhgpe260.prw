/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE260  ºAutor  ³Marcos R Roquitski  º Data ³  01/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo holerite Banco Bradesco                       º±±
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

User Function Nhgpe260()                        	

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN") 
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,") 
SetPrvt("nHdl,cLin,cFnl,_cMat") 

If !Pergunte("NHGPE260",.T.)
	Return
Endif

//Depositos
fTmp0Dep()
DbSelectArea("TMP0")
If !Empty(TMP0->RA_MAT) 
	If SM0->M0_CODIGO == "FN"	// Fundicao
		cArqDep := "C:\RELATO\FN237" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	Else
		cArqDep := "C:\RELATO\NH237" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
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


// Holerite Banco Bradesco
Static Function fArqDep()
Local nSega := 1
Local nSegd := 0
Local nSege := 0
Local nSegt := 0
Local _nTotsa := 0
Local _cMat := Space(06)
Local _n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701Irrf := _n735Fgts := _nVlSct := 0
Local _n723Irad := 0

	nlin := 0
	            
	
	
	
	** Header - do Arquivo
	cLin := "0" 
	cLin := cLin + "REMESSA HPAG EMPRESA" 
	cLin := cLin + "000003302" // Codigo da empresa 
	cLin := cLin + StrZero(MV_PAR03,9) // sequencial do arquivo.
	cLin := cLin + "001261681" // 01.261.681.0002/95 - CNPJ 
	cLin := cLin + "0002" 
	cLin := cLin + "95" 
	cLin := cLin + Substr(Dtos(date()),7,2) + Substr(Dtos(date()),5,2) + Substr(Dtos(date()),1,4) 
	cLin := cLin + "I" 
	cLin := cLin + "00777" 
	cLin := cLin + Space(155)
	cLin := cLin + Space(1) 
	cLin := cLin + Space(9)	 
	cLin := cLin + Space(12) 
	cLin := cLin + StrZero(nSega,5) 
	cLin := cLin + cFnl 
	nSega++ 
	fWrite(nHdl,cLin,Len(cLin)) 


	TMP0->(DbGotop())
	While !TMP0->(Eof())

/*
0REMESSA HPAG EMPRESA00000330200000000100126168100029530072013I00777                                                                                                                                                           T         999         00001
1I0010720130508201302370321700000005210208 54216834434000122965434150000003279736000077068ADRIANA C DA ROCHA DANTAS     0000000000291201 ASSIST ADMINISTRATIV               26122011                                                     999113      00002
20101SALARIO MENSAL      0000001620001                                                                                                                                                                                                               00003
20399ARREDONDAMENTO      0000000000641                                                                                                                                                                                                               00004
20000TOTAL DE PROVENTOS  0000001620642                                                                                                                                                                                                               00005
20401INSS SALARIO        0000000145803                                                                                                                                                                                                               00006
20430ARREDONDAMENTO      0000000000943                                                                                                                                                                                                               00007
20433VALE REFEIC/DESJEJUM0000000022783                                                                                                                                                                                                               00008
20437ASSISTENCIA MEDICA  0000000091123                                                                                                                                                                                                               00009
20442ADIANT SALARIAL     0000000648003                                                                                                                                                                                                               00010
20000TOTAL DE DESCONTOS  0000000908644                                                                                                                                                                                                               00011
20000TOTAL LIQUIDO       0000000712005                                                                                                                                                                                                               00012
3I.R ADIANTAMENTO:       0,00                                                                                                                                                                                                                        00013
40508201302004000000016200000S00000000000000000000000000000000000000162000000000000000000000082620000000000000000000000000000000000000000000162000000000012960                                                                                       00014
500012                                                                                                                                                                                                                                               00015
*/


		** Header do comprovante tipo1
		cLin := "1" 
		cLin := cLin + "I" 
		cLin := cLin + "001" 
		cLin := cLin + Substr(mv_par02,1,2)+Substr(mv_par02,3,4) 
		cLin := cLin + Substr(Dtos(mv_par01),7,2)+Substr(Dtos(mv_par01),5,2)+Substr(Dtos(mv_par01),1,4) 
		cLin := cLin + "0237" 
		cLin := cLin + "0"+Substr(TMP0->RA_BCDEPSA,4,4) // Agencia
		cLin := cLin + StrZero(Val(Substr(TMP0->RA_CTDEPSA,1,7)),13) // Conta corrente
		cLin := cLin + " "+Substr(TMP0->RA_CTDEPSA,8,1) // DAC 
		cLin := cLin + StrZero(Val(TMP0->RA_CIC),11) 
		cLin := cLin + StrZero(Val(TMP0->RA_PIS),14) 
		cLin := cLin + StrZero(Val(TMP0->RA_RG),13) 
		cLin := cLin + StrZero(Val(TMP0->RA_NUMCP),9) 
		cLin := cLin + Substr(TMP0->RA_NOME,1,30) 
		cLin := cLin + StrZero(Val(TMP0->RA_MAT),12)
		_cDescFunc := Space(40)
		If SRJ->(DbSeek(xFilial("SRJ") + TMP0->RA_CODFUNC))
			_cDescFunc := TMP0->RA_CODFUNC + ' ' + SRJ->RJ_DESC+Space(15)
		Endif	
		cLin := cLin + _cDescFunc
		cLin := cLin + Substr(Dtos(TMP0->RA_ADMISSA),7,2)+Substr(Dtos(TMP0->RA_ADMISSA),5,2)+Substr(Dtos(TMP0->RA_ADMISSA),1,4) 
		cLin := cLin + Space(53)  
		cLin := cLin + Space(12) 
		cLin := cLin + StrZero(nSega,5)
		nSega++
	
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

		fTmp1Dep(TMP0->RA_MAT)
		

		// Detalhes do comprovante tipo 2

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
	
				If TMP1->RC_PD == '723' // I.R ADIANTAMENTO
					_n723Irad := TMP1->RC_VALOR
				Endif	



			Endif	

			TMP1->(DbSkip())			
		Enddo


		DbSelectarea("TMP1")
		TMP1->(DbGotop())
		While !TMP1->(Eof())		

			If TMP0->RA_MAT <> TMP1->RA_MAT
				TMP1->(DbSkip())
				Loop
			Endif		

			If SRV->(DbSeek(xFilial("SRV") + TMP1->RC_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito

					** - nova linha
					cLin := "2"
					cLin := cLin + StrZero(Val(SRV->RV_COD),4)
					cLin := cLin + SRV->RV_DESC
					cLin := cLin + StrZero(TMP1->RC_VALOR*100,12)
					cLin := cLin + '1'
					cLin := cLin + Space(198)
					cLin := cLin + Space(09)
					cLin := cLin + StrZero(nSega,5)					
					nSega++
					nSegd++

					cLin := cLin + cFnl 
					fWrite(nHdl,cLin,Len(cLin)) 

															
				Endif
				
			Endif
			TMP1->(DbSkip())
		
		Enddo
		// Totaliza creditos                     

		** - nova linha
		cLin := "2"
		cLin := cLin + "0000"
		cLin := cLin + "TOTAL DE PROVENTOS  "
		cLin := cLin + StrZero(_nVlCre*100,12)
		cLin := cLin + '2'
		cLin := cLin + Space(198)
		cLin := cLin + Space(09)
		cLin := cLin + StrZero(nSega,5)		
		_nVlCre := 0
		nSega++
		nSegd++		
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 


		// Descontos	
		DbSelectarea("TMP1")
		TMP1->(DbGotop())
		While !TMP1->(Eof())		

			If TMP0->RA_MAT <> TMP1->RA_MAT
				TMP1->(DbSkip())
				Loop
			Endif		

			If SRV->(DbSeek(xFilial("SRV") + TMP1->RC_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '2' // Desconto

					** - nova linha
					cLin := "2"
					cLin := cLin + StrZero(Val(SRV->RV_COD),4)
					cLin := cLin + SRV->RV_DESC
					cLin := cLin + StrZero(TMP1->RC_VALOR*100,12)
					cLin := cLin + '3'
					cLin := cLin + Space(198)
					cLin := cLin + Space(09)
					cLin := cLin + StrZero(nSega,5)
					nSega++					
					nSegd++					

					cLin := cLin + cFnl 
					fWrite(nHdl,cLin,Len(cLin)) 

															
				Endif
				
			Endif
			TMP1->(DbSkip())
		
		Enddo

		** - nova linha
		cLin := "2"
		cLin := cLin + "0000"
		cLin := cLin + "TOTAL DE DESCONTOS  "
		cLin := cLin + StrZero(_nVlDeb*100,12)
		cLin := cLin + '4'
		cLin := cLin + Space(198)
		cLin := cLin + Space(09)
		cLin := cLin + StrZero(nSega,5)
		_nVlDeb := 0
		nSega++		
		nSegd++		
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

	
		** - nova linha
		cLin := "2"
		cLin := cLin + "0000"
		cLin := cLin + "TOTAL LIQUIDO       "
		cLin := cLin + StrZero(_nVlLiq*100,12)
		cLin := cLin + '5'
		cLin := cLin + Space(198)
		cLin := cLin + Space(09)
		cLin := cLin + StrZero(nSega,5)
		_nVlLiq := 0
		nSega++		
		nSegd++		

		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 


		** - Mensagem do comprovante tipo - 3 
		cLin := "3" 
		cLin := cLin + "I.R ADIANTAMENTO: " + Transform(_n723Irad,"@E 999,999.99") + Space(12)
		cLin := cLin + Space(195)
		cLin := cLin + Space(09) 
		cLin := cLin + StrZero(nSega,5)		
		cLin := cLin + cFnl 
		nSega++		
		nSegd++
							
		fWrite(nHdl,cLin,Len(cLin)) 
	                             
	
		** - Informacoes gerais tipo - 4 
		cLin := "4" 
		cLin := cLin + Substr(Dtos(mv_par01),7,2)+Substr(Dtos(mv_par01),5,2)+Substr(Dtos(mv_par01),1,4) 
		cLin := cLin + StrZero(Val(TMP0->RA_DEPIR),2)
		cLin := cLin + StrZero(Val(TMP0->RA_DEPSF),2)
		cLin := cLin + StrZero(TMP0->RA_HRSEMAN,2)
		cLin := cLin + StrZero(_nVlSal*100,12)		
		cLin := cLin + "00" // faltas periodo de ferias 
		cLin := cLin + "S"  // faltas periodo de ferias 
		cLin := cLin + "00000000"  // data inicio periodo aquisitivo 
		cLin := cLin + "00000000"  // data fim periodo aquisitivo 
		cLin := cLin + "00000000"  // data inicio periodo gozo ferias
		cLin := cLin + "00000000"  // data fim periodo gozo ferias
		cLin := cLin + StrZero(_nVlSct*100,12) // base INSS
		cLin := cLin + StrZero(0,12) // base INSS 13.
		cLin := cLin + StrZero(_n701Irrf*100,12) // base IRRF salario
		cLin := cLin + StrZero(0,12) // base IRRF 13.
		cLin := cLin + StrZero(0,12) // base IRRF ferias.
		cLin := cLin + StrZero(0,12) // base IRRF PPR.
		cLin := cLin + StrZero(_n735Fgts*100,12) // base FGTS 
		cLin := cLin + StrZero(_n736Fgts*100,12) // valor FGTS
		cLin := cLin + Space(78)
		cLin := cLin + Space(9)
		cLin := cLin + StrZero(nSega,5)
		nSega++		
		nSegd++
		
		
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 
	                             


		** - Registro trailler do comprovante - tipo 5
		cLin := "5"
		cLin := cLin + StrZero(nSegd,5) // soma tipo 2 + tipo 3 + tipo 4
		cLin := cLin + Space(230)
		cLin := cLin + Space(09)
		cLin := cLin + StrZero(nSega,5)		
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 
		nSegd := 0
		nSega++		
		
		_n723Irad := _n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701Irrf := _n735Fgts := _nVlSct := 0

		TMP0->(DbSkip())
	
	Enddo

cLin := "9" 
cLin := cLin + StrZero(nSega,5)
cLin := cLin + Space(230) 
cLin := cLin + Space(9) 
cLin := cLin + StrZero(nSega,5)
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
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "' "
cQuery += "AND RC.RC_FILIAL = '" + xFilial("SRC")+ "' "
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '237' " 
cQuery += "AND RC.RC_MAT = RA.RA_MAT "
cQuery += "AND RC.RC_PD = '799' "
cQuery += "ORDER BY RA.RA_MAT "

TCQUERY cQuery NEW ALIAS "TMP0"
TcSetField("TMP0","RA_ADMISSA","D") // Muda a data de string para date.

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
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "' " 
cQuery += "AND RC.RC_FILIAL = '" + xFilial("SRC")+ "' "
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '237' " 
cQuery += "AND RA.RA_MAT = '"+ _cMat + "' " 
cQuery += "AND RC.RC_MAT = '"+ _cMat + "' " 
cQuery += "ORDER BY RA.RA_MAT, RC.RC_PD"

TCQUERY cQuery NEW ALIAS "TMP1" 

DbSelectArea("TMP1")
TMP1->(Dbgotop())                                                                      


Return
