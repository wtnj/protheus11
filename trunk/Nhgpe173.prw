/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE173  ºAutor  ³Marcos R Roquitski  º Data ³  08/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo holerite Mensal Banco do Brasil.              º±±
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

User Function Nhgpe173()   

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,")
SetPrvt("nHdl,cLin,cFnl,_cMat,_cMvGpe125")

_cMvGpe125s := Alltrim(GETMV("MV_GPE125S")) // Sequencial

SRC->(DbSetOrder(1))

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek("NHGP125"))
While !Sx1->(Eof()) .and. SX1->X1_GRUPO = "NHGP125"
	If SX1->X1_ORDEM == '08'
		RecLock('SX1')
		SX1->X1_CNT01 := _cMvGpe125s      
		MsUnLock('SX1')
	Endif	
	SX1->(DbSkip())
Enddo

If !Pergunte("NHGP125",.T.)
	Return
Endif

//Depositos
fTmp0Dep()
DbSelectArea("TMP0")
If !Empty(TMP0->RA_MAT) 
	If SM0->M0_CODIGO == "FN"	// Fundicao
		cArqDep := "C:\RELATO\FNHOB"+SM0->M0_CODFIL + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	Else
		cArqDep := "C:\RELATO\NHHOB"+SM0->M0_CODFIL + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
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
Local _n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701Irrf := _n735Fgts := _n715Fgts := _n723Irad := _n799Liqu := 0

	nlin := 0

	** Visao 1
	cLin := StrZero(0,20)
	cLin := cLin + "00"
	cLin := cLin + "0"
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),4) // Agencia
	cLin := cLin + fGeracc()
	cLin := cLin + "EDO001"

	If SM0->M0_CODIGO == "FN"
		cLin := cLin + "000000003307"  // Contrato Fundicao
	Else
		cLin := cLin + "000000003304"  // Contrato Usinagem
	Endif
		
	cLin := cLin + StrZero(Val(MV_PAR08),6)
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
		
		_n736Fgts := 0
		_n701Irrf := 0
		_n735Fgts := 0
		_n715Inss := 0
		_n723Irad := 0
		_n799Liqu := 0
        
		_nLinPro :=  0
		DbSelectarea("SRC")
		SRC->(DbSeek(xFilial("SRC")+TMP0->RA_MAT))
		While !SRC->(Eof()) .AND. SRC->RC_MAT == TMP0->RA_MAT .AND. SRC->RC_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRC->RC_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito
					_nLinPro++
				Endif
			Endif
			IIf(SRC->RC_PD == '736',_n736Fgts := SRC->RC_VALOR,0)
			IIf(SRC->RC_PD == '701',_n701Irrf := SRC->RC_VALOR,0)
			IIF(SRC->RC_PD == '735',_n735Fgts := SRC->RC_VALOR,0)
			IIF(SRC->RC_PD == '715',_n715Inss := SRC->RC_VALOR,0)
			IIF(SRC->RC_PD == '723',_n723Irad := SRC->RC_VALOR,0)
			IIF(SRC->RC_PD == '799',_n799Liqu := SRC->RC_VALOR,0)
			SRC->(DbSkip())
		Enddo


		// Processa DESCONTO
		DbSelectarea("SRC")
		SRC->(DbSeek(xFilial("SRC")+TMP0->RA_MAT))
		While !SRC->(Eof()) .AND. SRC->RC_MAT == TMP0->RA_MAT .AND. SRC->RC_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRC->RC_PD)) 
				If 	SRV->RV_TIPOCOD == '2' // Desconto
					_nLinPro++
				Endif
			Endif
			SRC->(DbSkip())
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + "00"
		cLin := cLin + "1"
		cLin := cLin + Substr(TMP0->RA_BCDEPSA,4,4) // Agencia sem DV
		cLin := cLin + StrZero(Val(Substr(TMP0->RA_CTDEPSA,1,8)),11) // Conta corrente sem dv
		cLin := cLin + StrZero(_nLinPro+23,2)
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
		cLin := cLin + "DATA DE ADMISSAO: "+ Substr(TMP0->RA_ADMISSA,7,2)+'/'+Substr(TMP0->RA_ADMISSA,5,2)+'/'+Substr(TMP0->RA_ADMISSA,1,4)
		cLin := cLin + Space(20)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "CARGO           : "+ TMP0->RA_CODFUNC + ' ' + _cDescf
		cLin := cLin + Space(05)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "AGENCIA/CONTA   : "+ Substr(TMP0->RA_BCDEPSA,4,4)+'-'+Substr(TMP0->RA_BCDEPSA,8,1)+'/'+ Substr(TMP0->RA_CTDEPSA,1,8)+'-'+Substr(TMP0->RA_CTDEPSA,9,1)
		cLin := cLin + Space(13)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DATA DE PAGTO   : "+ Substr(Dtos(mv_par04),7,2)+'/'+Substr(Dtos(mv_par04),5,2)+'/'+Substr(Dtos(mv_par04),1,4)
		cLin := cLin + Space(20)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + 'MES REFERENCIA  : '+Substr(Dtos(dDataBase),5,2)+'/'+Substr(Dtos(dDataBase),1,4)
		cLin := cLin + Space(23)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FOLHA           : MENSAL"
		cLin := cLin + Space(24)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		// Processa PROVENTOS
		_nTotPro :=  0
		DbSelectarea("SRC")
		SRC->(DbSeek(xFilial("SRC")+TMP0->RA_MAT))
		While !SRC->(Eof()) .AND. SRC->RC_MAT == TMP0->RA_MAT .AND. SRC->RC_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRC->RC_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito
					cLin := StrZero(Val(TMP0->RA_MAT),20)
					cLin := cLin + StrZero(_nSeq,2)
					cLin := cLin + "2"
					cLin := cLin + SRV->RV_COD + ' ' + SRV->RV_DESC + ' '+ Str(SRC->RC_HORAS,8,2) +  '  ' + Transform(SRC->RC_VALOR,"@E 99,999,999.99")
					cLin := cLin + "0"
					cLin := cLin + Space(28)
					cLin := cLin + cFnl
					_nTotPro += SRC->RC_VALOR
					_nSeq++
					fWrite(nHdl,cLin,Len(cLin))
				Endif
			Endif
			SRC->(DbSkip())
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
		DbSelectarea("SRC")
		SRC->(DbSeek(xFilial("SRC")+TMP0->RA_MAT))
		While !SRC->(Eof()) .AND. SRC->RC_MAT == TMP0->RA_MAT .AND. SRC->RC_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRC->RC_PD)) 
				If 	SRV->RV_TIPOCOD == '2' // Desconto
					cLin := StrZero(Val(TMP0->RA_MAT),20)
					cLin := cLin + StrZero(_nSeq,2)
					cLin := cLin + "2"
					cLin := cLin + SRV->RV_COD + ' ' + SRV->RV_DESC + ' '+ Str(SRC->RC_HORAS,8,2) +  '  ' + Transform(SRC->RC_VALOR,"@E 99,999,999.99")
					cLin := cLin + "0"
					cLin := cLin + Space(28)
					cLin := cLin + cFnl     
					_nTotDes += SRC->RC_VALOR
					_nSeq++
					fWrite(nHdl,cLin,Len(cLin))
				Endif
			Endif
			SRC->(DbSkip())
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
		cLin := cLin + "BASE DE CALCULO IRPF               " + Transform(_n701Irrf,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "BASE DE CALCULO FGTS               " + Transform(_n735Fgts,"@E 99,999,999.99")
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
		cLin := cLin + "LIQUIDO A RECEBER                  " + Transform(_n799Liqu,"@E 99,999,999.99")
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
			_nSalFunc := TMP0->RA_SALARIO

			cLin := StrZero(Val(TMP0->RA_MAT),20)
			cLin := cLin + StrZero(_nSeq,2)
			cLin := cLin + "2"
			cLin := cLin + "SALARIO HORA                       " + Transform(_nSalFunc,"@E 99,999,999.99")
			cLin := cLin + "0"
			cLin := cLin + Space(28)
			cLin := cLin + cFnl
			_nTotDes := 0
			_nSeq++
			fWrite(nHdl,cLin,Len(cLin))

		Else
			_nSalFunc := TMP0->RA_SALARIO		

			cLin := StrZero(Val(TMP0->RA_MAT),20)
			cLin := cLin + StrZero(_nSeq,2)
			cLin := cLin + "2"
			cLin := cLin + "SALARIO MENSAL                     " + Transform(_nSalFunc,"@E 99,999,999.99")
			cLin := cLin + "0"
			cLin := cLin + Space(28)
			cLin := cLin + cFnl
			_nTotDes := 0
			_nSeq++
			fWrite(nHdl,cLin,Len(cLin))

		Endif	

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "SALARIO CONTRIBUICAO INSS          " + Transform(_n715Inss,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FGTS                               " + Transform(_n736Fgts,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "IRPF ADIANTAMENTO                  " + Transform(_n723Irad,"@E 99,999,999.99")
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

// Grava sx6.

If SX6->(DbSeek(xFilial()+"MV_GPE125S"))
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD:= mv_par08
	MsUnlock("SX6")
Endif	


DbSelectArea("TMP0")
DbCloseArea("TMP0")

Return(nil)



Static Function fGeracc()
Local _cRet,cConta,i
Local cDac := ''

	cConta    := StrZero(Val(Substr(MV_PAR03,1,AT("-",MV_PAR03))),12,0)
	_cRet := StrZero(Val(cConta),11)
	
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

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA "
cQuery += "WHERE RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND RA.RA_CATFUNC NOT IN ('G','P','A') " 
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '001' " 
cQuery += "AND RA.RA_MAT BETWEEN '"+ Mv_par06 + "' AND '"+ Mv_par07 + "' "
cQuery += "ORDER BY RA.RA_MAT "

TCQUERY cQuery NEW ALIAS "TMP0" 

DbSelectArea("TMP0")
TMP0->(Dbgotop())

