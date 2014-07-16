/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE174  ºAutor  ³Marcos R Roquitski  º Data ³  10/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo holerite 13o. Salario 2a. Parcela.            º±±
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

User Function Nhgpe174()

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
		cArqDep := "C:\RELATO\FN13B" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	Else
		cArqDep := "C:\RELATO\NH13B" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	Endif	
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqDep)
	lEnd    := .F.

	MsAguarde ( {|lEnd| fArqDep() },"Aguarde","Gerando arquivo...",.T.)

Endif

Return


// Holerite Banco do Brasil
Static Function fArqDep()
Local nSega := nSegd := nSege := nSegt := 1
Local _nTotsa := 0
Local _nSalFunc := 0
Local _cMat := Space(06)
Local _n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701Irrf := _n735Fgts := _n715Fgts := _n723Irad := 0

	nlin := 0

	** Visao 1
	cLin := StrZero(0,20)
	cLin := cLin + "00"
	cLin := cLin + "0"
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),4) // Agencia
	cLin := cLin + fGeracc()
	cLin := cLin + "EDO001"
	cLin := cLin + "740201127006"
	cLin := cLin + "000001"
	cLin := cLin + "00315"
	cLin := cLin + "00001"
	cLin := cLin + Substr(Dtos(dDataBase),1,4)
	cLin := cLin + Substr(Dtos(dDataBase),5,2)
	cLin := cLin + "00"
	cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)				
	cLin := cLin + Space(12)
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))
	_nSeq  := 1
	_nFunc := 0
	

	** Visao 2
	DbSelectarea("TMP0")
	TMP0->(DbGotop())
	While !TMP0->(Eof())		

		_nSeq  := 1
		_nFunc++

		// Processa PROVENTOS
		_nLinPro :=  0
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito
					_nLinPro++
				Endif
			Endif
			IIf(SRI->RI_PD == '739',_n739Fgts := SRI->RI_VALOR,0)
			IIf(SRI->RI_PD == '705',_n705Irrf := SRI->RI_VALOR,0)
			IIF(SRI->RI_PD == '738',_n738Fgts := SRI->RI_VALOR,0)
			IIF(SRI->RI_PD == '718',_n718Inss := SRI->RI_VALOR,0)
			SRI->(DbSkip())
		Enddo


		// Processa DESCONTO
		DbSelectarea("SRC")
		SRI->(DbSeek(xFilial("SRC")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) 
				If 	SRV->RV_TIPOCOD == '2' // Desconto
					_nLinPro++
				Endif
			Endif
			SRI->(DbSkip())
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + "00"
		cLin := cLin + "1"
		cLin := cLin + Substr(TMP0->RA_BCDEPSA,4,4) // Agencia sem DV
		cLin := cLin + StrZero(Val(Substr(TMP0->RA_CTDEPSA,1,8)),11) // Conta corrente sem dv
		cLin := cLin + StrZero(_nLinPro+22,2)
		cLin := cLin + TMP0->RA_NOME + Space(10)
		cLin := cLin + TMP0->RA_CIC
		cLin := cLin + Space(09)
		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))


		** Visao 3
		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DEMONSTRATIVO DE PAGAMENTO"
		cLin := cLin + Space(22)
		cLin := cLin + "1"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		If SM0->M0_CODIGO == "FN"	// Fundicao
			cLin := StrZero(Val(TMP0->RA_MAT),20)     
			cLin := cLin + StrZero(_nSeq,2)
			cLin := cLin + "2"
			cLin := cLin + "EMPRESA: WHB FUNDICAO S/A               " + Space(08)
			cLin := cLin + "1"	
			cLin := cLin + Space(28)
			cLin := cLin + cFnl
			_nSeq++		
			fWrite(nHdl,cLin,Len(cLin))
		Else
			cLin := StrZero(Val(TMP0->RA_MAT),20)     
			cLin := cLin + StrZero(_nSeq,2)
			cLin := cLin + "2"
			cLin := cLin + "EMPRESA: WHB COMPONENTES AUTOMOTIVOS S/A" + Space(08)
			cLin := cLin + "1"	
			cLin := cLin + Space(28)
			cLin := cLin + cFnl
			_nSeq++		
			fWrite(nHdl,cLin,Len(cLin))
		Endif	

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "CNPJ   : "+ Transform(Substr(SM0->M0_CGC,1,14),"@R 99.999.999/9999-99")
		cLin := cLin + Space(21)
		cLin := cLin + "1"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FUNCIONARIO: "+ TMP0->RA_MAT + ' ' + Substr(TMP0->RA_NOME,1,28)
		cLin := cLin + "0"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		_cDescf := Space(20)
		SRJ->(DbSeek(xFilial("SRJ")+TMP0->RA_CODFUNC))
		If SRJ->(Found())
			_cDescf := SRJ->RJ_DESC
		Endif
	
		_cDescc := Space(20)
		CTT->(DbSeek(xFilial("CTT")+TMP0->RA_CC))
		If CTT->(Found())
			_cDescc := Substr(CTT->CTT_DESC01,1,20)
		Endif		

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "CENTRO DE CUSTO: "+ TMP0->RA_CC + '  ' + _cDescc
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "CARGO          : "+ TMP0->RA_CODFUNC + ' ' + _cDescf
		cLin := cLin + Space(06)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "AGENCIA/CONTA  : "+ Substr(TMP0->RA_BCDEPSA,4,4)+'-'+Substr(TMP0->RA_BCDEPSA,8,1)+'/'+ Substr(TMP0->RA_CTDEPSA,1,8)+'-'+Substr(TMP0->RA_CTDEPSA,9,1)
		cLin := cLin + Space(14)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DATA DE PAGTO  : "+ Substr(Dtos(mv_par04),7,2)+'/'+Substr(Dtos(mv_par04),5,2)+'/'+Substr(Dtos(mv_par04),1,4)
		cLin := cLin + Space(21)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + 'MES REFERENCIA : '+Substr(Dtos(dDataBase),5,2)+'/'+Substr(Dtos(dDataBase),1,4)
		cLin := cLin + Space(24)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"                     
		cLin := cLin + "FOLHA          : 13o. Sal. 2o. Parcela"
		cLin := cLin + Space(10)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		// Processa PROVENTOS
		_nTotPro :=  0
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito
					cLin := StrZero(Val(TMP0->RA_MAT),20)
					cLin := cLin + StrZero(_nSeq,2)
					cLin := cLin + "2"
					cLin := cLin + SRV->RV_COD + ' ' + SRV->RV_DESC + ' '+ Str(SRI->RI_HORAS,8,2) +  '  ' + Transform(SRI->RI_VALOR,"@E 99,999,999.99")
					cLin := cLin + "0"
					cLin := cLin + Space(28)
					cLin := cLin + cFnl
					_nTotPro += SRI->RI_VALOR
					_nSeq++
					fWrite(nHdl,cLin,Len(cLin))
				Endif
			Endif
			SRI->(DbSkip())
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "TOTAL DE VENCIMENTOS               " + Transform(_nTotPro,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotPro := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + Space(48)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DESCONTOS:"
		cLin := cLin + Space(38)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))
		

		// Processa DESCONTO
		_nTotDes := 0
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) 
				If 	SRV->RV_TIPOCOD == '2' // Desconto
					cLin := StrZero(Val(TMP0->RA_MAT),20)
					cLin := cLin + StrZero(_nSeq,2)
					cLin := cLin + "2"
					cLin := cLin + SRV->RV_COD + ' ' + SRV->RV_DESC + ' '+ Str(SRI->RI_HORAS,8,2) +  '  ' + Transform(SRI->RI_VALOR,"@E 99,999,999.99")
					cLin := cLin + "0"
					cLin := cLin + Space(28)
					cLin := cLin + cFnl     
					_nTotDes += SRI->RI_VALOR
					_nSeq++
					fWrite(nHdl,cLin,Len(cLin))
				Endif
			Endif
			SRI->(DbSkip())
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "TOTAL DE DESCONTOS                 " + Transform(_nTotDes,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "BASE DE CALCULO IRPF               " + Transform(_n705Irrf,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "BASE DE CALCULO FGTS               " + Transform(_n738Fgts,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + Space(48)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "LIQUIDO A RECEBER                  " + Transform(TMP0->RI_VALOR,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + Space(48)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		_nSalFunc := 0
		If TMP0->RA_CATFUNC == 'H'
			_nSalFunc := (TMP0->RA_SALARIO * 200)
		Else
			_nSalFunc := TMP0->RA_SALARIO		
		Endif	

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "SALARIO FIXO/BASE                  " + Transform(_nSalFunc,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "SALARIO CONTRIBUICAO INSS          " + Transform(_n718Inss,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FGTS                               " + Transform(_n739Fgts,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		TMP0->(DbSkip())

	Enddo


// Visao 4
cLin := "99999999999999999999" 
cLin := cLin + "99" 
cLin := cLin + "9" 
cLin := cLin + "999999999999999"
cLin := cLin + StrZero(_nFunc,11) 
cLin := cLin + Space(51) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 

DbSelectArea("TMP0")
DbCloseArea("TMP0")

Return(nil)


Static Function fGeracc()
Local _cRet,cConta
	cConta    := StrZero(Val(Substr(MV_PAR03,1,AT("-",MV_PAR03))),12,0)
	_cRet := StrZero(Val(cConta),11)
	
Return(_cRet)

// Liquidos
Static Function fTmp0Dep()

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA, " +  RetSqlName('SRI') + " RI "
cQuery += "WHERE RI.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '001' " 
cQuery += "AND RA.RA_MAT BETWEEN '"+ Mv_par06 + "' AND '"+ Mv_par07 + "' "
cQuery += "AND RI.RI_MAT = RA.RA_MAT "
cQuery += "AND RI.RI_FILIAL = '" + xFilial("SRI")+ "'"
cQuery += "AND RI.RI_PD = '797' " 
cQuery += "ORDER BY RA.RA_MAT "

TCQUERY cQuery NEW ALIAS "TMP0" 
// TcSetField("TMP","RI_DATA","D") // Muda a data de string para date.

DbSelectArea("TMP0")
TMP0->(Dbgotop())

