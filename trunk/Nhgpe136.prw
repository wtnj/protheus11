/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE136  ºAutor  ³Marcos R Roquitski  º Data ³  05/10/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo de pagamentos Banco do Brasil.                º±±
±±º          ³ Tabela ZR1                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#include "topconn.ch" 

User Function Nhgpe136()

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,")
SetPrvt("nHdl,cLin,cFnl,_cNpj")

If Pergunte("NHGP125",.T.)

	
	If Substr(Alltrim(mv_par03),1,4) == '5289'
		_cNpj := '01261681000295'

	Else
		_cNpj := Substr(SM0->M0_CGC,1,14)

	Endif


	//Depositos
	fTmpDep()
	If !Empty(TMP->ZRA_MAT)
		If SM0->M0_CODIGO == "FN"	// Fundicao
			cArqDep := "\SYSTEM\FNBD" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
		Else
			cArqDep := "\SYSTEM\NHBD" + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
		Endif	
		cFnl    := CHR(13)+CHR(10)
		nHdl    := fCreate(cArqDep)
		lEnd    := .F.

		MsAguarde ( {|lEnd| fArqDep() },"Aguarde","Gerando arquivo...",.T.)
	Endif	


	// TED
	fTmpTed()
	If !Empty(TMT->ZRA_MAT)	
		If SM0->M0_CODIGO == "FN"	
			cArqTed := "\SYSTEM\FNBT" + Substr(Dtos(dDataBase),5,4) + ".REM" // TED
		Else
			cArqTed := "\SYSTEM\NHBT" + Substr(Dtos(dDataBase),5,4) + ".REM" // TED
		Endif	
		cFnl    := CHR(13)+CHR(10)
		nHdl    := fCreate(cArqTed)
		lEnd    := .F.

		MsAguarde ( {|lEnd| fArqTed() },"Aguarde","Gerando arquivo...",.T.)
	Endif


	// DOC
	fTmpDoc()
	If !Empty(TMD->ZRA_MAT)
		If SM0->M0_CODIGO == "FN"	
			cArqDoc := "\SYSTEM\FNBC" + Substr(Dtos(dDataBase),5,4) + ".REM" // DOC
		Else
			cArqDoc := "\SYSTEM\NHBC" + Substr(Dtos(dDataBase),5,4) + ".REM" // DOC
		Endif	
		cFnl    := CHR(13)+CHR(10)
		nHdl    := fCreate(cArqDoc)
		lEnd    := .F.

		MsAguarde ( {|lEnd| fArqDoc() },"Aguarde","Gerando arquivo...",.T.)

	Endif	

	U_Nhgpe126()
	

Endif	

Return

// Deposito em conta corrente Banco Do Brasil 001
Static Function fArqDep()
Local nSega := 1
Local _nTotsa := 0

	nlin := 0
	
	** Header
	cLin := "001"
	cLin := cLin + "0000"
	cLin := cLin + "0"
	cLin := cLin + Space(9)
	cLin := cLin + "2"
	
	//cLin := cLin + Substr(SM0->M0_CGC,1,14) 
	cLin := cLin + _cNpj
	
		
	cLin := cLin + Space(20)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	cLin := cLin + fGeracc()
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,30)
	cLin := cLin + "BANCO DO BRASIL"
	cLin := cLin + Space(25)
	cLin := cLin + "1"
	cLin := cLin + Dtos(date())
	cLin := cLin + Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)  
	cLin := cLin + "000000"
	cLin := cLin + "030"
	cLin := cLin + "00000"	    
	cLin := cLin + Space(51)
	cLin := cLin + "CSP"
	cLin := cLin + "000"
	cLin := cLin + Space(12)

	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	** SEGMENTO C
	cLin := "001"
	cLin := cLin + "0001"
	cLin := cLin + "1"
	cLin := cLin + "C"
	cLin := cLin + "20" // Transferencia
	cLin := cLin + "01" // Pagamentos a fornecedores
	cLin := cLin + "020"
	cLin := cLin + Space(01)
	cLin := cLin + "2"

	//cLin := cLin + Subst(SM0->M0_CGC,1,14)
	cLin := cLin + _cNpj	

	If SM0->M0_CODIGO == "FN"	

		If Substr(Alltrim(mv_par03),1,4) == '5289'
			cLin := cLin + "0009989010126"
		Else
			cLin := cLin + "0008416200126"		
		Endif	

	Elseif	SM0->M0_CODIGO == "NH"	
		cLin := cLin + "0007402010126"
	Else
		cLin := cLin + "0000000000000"	
	Endif

	cLin := cLin + Space(07)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	cLin := cLin + fGeracc()
	cLin := cLin + Subst(SM0->M0_NOMECOM,1,30)
	cLin := cLin + Space(40)
	cLin := cLin + Subst(SM0->M0_ENDCOB,1,30)
	cLin := cLin + "00000"
	cLin := cLin + Space(15)
	cLin := cLin + Substr(SM0->M0_CIDCOB,1,20) 
	cLin := cLin + Substr(SM0->M0_CEPCOB,1,8) 
	cLin := cLin + Substr(SM0->M0_ESTCOB,1,2) 
	cLin := cLin + Space(18) 

	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


TMP->(DbGotop())
While !TMP->(Eof())

	If TMP->ZRA_BANCO == mv_par01

		** SEGMENTO A 
		cLin := "001" 
		cLin := cLin + "0001" 
		cLin := cLin + "3" 
		cLin := cLin + StrZero(nSega,5) 
		cLin := cLin + "A" 
		cLin := cLin + "000" 
		cLin := cLin + "000" 
		cLin := cLin + "001" 
		cLin := cLin + fGeraag()
	
		cLin := cLin + Substr(TMP->ZRA_FAVORE,1,33)
		cLin := cLin + "00000000000000000"
		cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
		cLin := cLin + "BRL" 
		cLin := cLin + "000000000000000" 
		cLin := cLin + StrZero(TMP->ZR1_VALOR*100,15) 
		cLin := cLin + Space(20) 
		cLin := cLin + "00000000" 
		cLin := cLin + "000000000000000"  
		cLin := cLin + TMP->ZRA_CPFCGC
		cLin := cLin + Space(38) 
		cLin := cLin + "0" 
		cLin := cLin + Space(10) 
		nSega++
		_nTotsa += TMP->ZR1_VALOR
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

	Endif	
	TMP->(DbSkip())
	
Enddo

cLin := "001" 
cLin := cLin + "0001" 
cLin := cLin + "5" 
cLin := cLin + Space(09) 
cLin := cLin + StrZero(nSega+1,6) 
cLin := cLin + StrZero(_nTotsa*100,18) 
cLin := cLin + StrZero(0,18) 
cLin := cLin + Space(181) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

cLin := "001" 
cLin := cLin + "9999" 
cLin := cLin + "9" 
cLin := cLin + Space(09) 
cLin := cLin + "000001"
cLin := cLin + StrZero(nSega+3,6) 
cLin := cLin + "000000"
cLin := cLin + Space(205) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 


DbSelectArea("TMP")
DbCloseArea("TMP")


Return(nil)



// TED valores acima de 5.000,00 outros bancos # do Banco Do Brasil 001
Static Function fArqTed()
Local nSega := 1
Local _nTotsa := 0

	nlin := 0
	
	** Header
	cLin := "001"
	cLin := cLin + "0000"
	cLin := cLin + "0"
	cLin := cLin + Space(9)
	cLin := cLin + "2"

	//cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + _cNpj
		
	cLin := cLin + Space(20)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	cLin := cLin + fGeracc()
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,30)
	cLin := cLin + "BANCO DO BRASIL"
	cLin := cLin + Space(25)
	cLin := cLin + "1"
	cLin := cLin + Dtos(date())
	cLin := cLin + Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)  
	cLin := cLin + "000000"
	cLin := cLin + "030"
	cLin := cLin + "00000"	    
	cLin := cLin + Space(51)
	cLin := cLin + "CSP"
	cLin := cLin + "000"
	cLin := cLin + Space(12)

	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	** SEGMENTO C
	cLin := "001"
	cLin := cLin + "0001"
	cLin := cLin + "1"
	cLin := cLin + "C"
	cLin := cLin + "20" 
	cLin := cLin + "41" 
	cLin := cLin + "020"
	cLin := cLin + Space(01)
	cLin := cLin + "2"

	//cLin := cLin + Subst(SM0->M0_CGC,1,14)
	cLin := cLin + _cNpj

	If SM0->M0_CODIGO == "FN"	
		//cLin := cLin + "0008416200126"

		If Substr(Alltrim(mv_par03),1,4) == '5289'
			cLin := cLin + "0009989010126"
		Else
			cLin := cLin + "0008416200126"		
		Endif	

	Elseif	SM0->M0_CODIGO == "NH"	
		cLin := cLin + "0007402010126"
	Else
		cLin := cLin + "0000000000000"	
	Endif
	cLin := cLin + Space(07)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	cLin := cLin + fGeracc()
	cLin := cLin + Subst(SM0->M0_NOMECOM,1,30)
	cLin := cLin + Space(40)
	cLin := cLin + Subst(SM0->M0_ENDCOB,1,30)
	cLin := cLin + "00000"
	cLin := cLin + Space(15)
	cLin := cLin + Substr(SM0->M0_CIDCOB,1,20) 
	cLin := cLin + Substr(SM0->M0_CEPCOB,1,8) 
	cLin := cLin + Substr(SM0->M0_ESTCOB,1,2) 
	cLin := cLin + Space(18) 

	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


DbselectArea("TMT")
TMT->(DbGotop())
While !TMT->(Eof())

	** SEGMENTO A 
	cLin := "001" 
	cLin := cLin + "0001" 
	cLin := cLin + "3" 
	cLin := cLin + StrZero(nSega,5) 
	cLin := cLin + "A" 
	cLin := cLin + "000" 
	cLin := cLin + "018" 
	cLin := cLin + TMT->ZRA_BANCO
	cLin := cLin + fGeraat()
	
	cLin := cLin + Substr(TMT->ZRA_FAVORE,1,33)
	cLin := cLin + "00000000000000000"
	cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
	cLin := cLin + "BRL" 
	cLin := cLin + "000000000000000" 
	cLin := cLin + StrZero(TMT->ZR1_VALOR*100,15) 
	cLin := cLin + Space(20) 
	cLin := cLin + "00000000" 
	cLin := cLin + "000000000000000"  
	cLin := cLin + TMT->ZRA_CPFCGC
	cLin := cLin + Space(38) 
	cLin := cLin + "0" 
	cLin := cLin + Space(10) 
	nSega++
	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 

	
	** SEGMENTO B
	cLin := "001" 
	cLin := cLin + "0001" 
	cLin := cLin + "3" 
	cLin := cLin + StrZero(nSega,5) 
	cLin := cLin + "B" 
	cLin := cLin + Space(03) 
	cLin := cLin + Iif(Len(Trim(TMT->ZRA_CPFCGC))<14,"1","2") 
	cLin := cLin + StrZero(Val(TMT->ZRA_CPFCGC),14,0) 
	cLin := cLin + "RUA WIEGANO OLSEN            " 
	cLin := cLin + "001000" 
	cLin := cLin + Space(15) 
	cLin := cLin + "CIC            " 
	cLin := cLin + "CURITIBA            " 
	cLin := cLin + "81460070" 
	cLin := cLin + "PR" 
	cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
	cLin := cLin + StrZero(TMT->ZR1_VALOR*100,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + Space(30) 
					
	nSega++
	_nTotsa += TMT->ZR1_VALOR
	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 

	TMT->(DbSkip())

Enddo
cLin := "001"
cLin := cLin + "0001" 
cLin := cLin + "5" 
cLin := cLin + Space(09) 
cLin := cLin + StrZero(nSega+1,6) 
cLin := cLin + StrZero(_nTotsa*100,18) 
cLin := cLin + StrZero(0,18) 
cLin := cLin + Space(181) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

cLin := "001" 
cLin := cLin + "9999" 
cLin := cLin + "9" 
cLin := cLin + Space(09) 
cLin := cLin + "000001"
cLin := cLin + StrZero(nSega+3,6) 
cLin := cLin + "000000"
cLin := cLin + Space(205) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 


DbSelectArea("TMT")
DbCloseArea("TMT")


Return(nil)




// DOC valores abaixo de 5.000,00 outros bancos # do Banco Do Brasil 001
Static Function fArqDoc()
Local nSega := 1
Local _nTotsa := 0

	nlin := 0
	
	** Header
	cLin := "001"
	cLin := cLin + "0000"
	cLin := cLin + "0"
	cLin := cLin + Space(9)
	cLin := cLin + "2"

	//cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + _cNpj	

	cLin := cLin + Space(20)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	cLin := cLin + fGeracc()
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,30)
	cLin := cLin + "BANCO DO BRASIL"
	cLin := cLin + Space(25)
	cLin := cLin + "1"
	cLin := cLin + Dtos(date())
	cLin := cLin + Substr(TIME(),1,2)+Substr(TIME(),4,2)+Substr(TIME(),7,2)  
	cLin := cLin + "000000"
	cLin := cLin + "030"
	cLin := cLin + "00000"	    
	cLin := cLin + Space(51)
	cLin := cLin + "CSP"
	cLin := cLin + "000"
	cLin := cLin + Space(12)

	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))

	** SEGMENTO C
	cLin := "001"
	cLin := cLin + "0001"
	cLin := cLin + "1"
	cLin := cLin + "C"
	cLin := cLin + "20" 
	cLin := cLin + "03" 
	cLin := cLin + "020"
	cLin := cLin + Space(01)
	cLin := cLin + "2"

	//cLin := cLin + Subst(SM0->M0_CGC,1,14)
	cLin := cLin + _cNpj	

	If SM0->M0_CODIGO == "FN"	
		//cLin := cLin + "0008416200126"

		If Substr(Alltrim(mv_par03),1,4) == '5289'
			cLin := cLin + "0009989010126"
		Else
			cLin := cLin + "0008416200126"		
		Endif	

	Elseif	SM0->M0_CODIGO == "NH"	
		cLin := cLin + "0007402010126"
	Else
		cLin := cLin + "0000000000000"	
	Endif

	cLin := cLin + Space(07)
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),5) // Agencia
	cLin := cLin + Substr(mv_par02,5,1) // digito agencia
	cLin := cLin + fGeracc()
	cLin := cLin + Subst(SM0->M0_NOMECOM,1,30)
	cLin := cLin + Space(40)
	cLin := cLin + Subst(SM0->M0_ENDCOB,1,30)
	cLin := cLin + "00000"
	cLin := cLin + Space(15)
	cLin := cLin + Substr(SM0->M0_CIDCOB,1,20) 
	cLin := cLin + Substr(SM0->M0_CEPCOB,1,8) 
	cLin := cLin + Substr(SM0->M0_ESTCOB,1,2) 
	cLin := cLin + Space(18) 

	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


DbselectArea("TMD")
TMD->(DbGotop())
While !TMD->(Eof())

	** SEGMENTO A 
	cLin := "001" 
	cLin := cLin + "0001" 
	cLin := cLin + "3" 
	cLin := cLin + StrZero(nSega,5) 
	cLin := cLin + "A" 
	cLin := cLin + "000" 
	cLin := cLin + "700" 
	cLin := cLin + TMD->ZRA_BANCO
	cLin := cLin + fGerado()
	
	cLin := cLin + Substr(TMD->ZRA_FAVORE,1,33)
	cLin := cLin + "00000000000000000"
	cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
	cLin := cLin + "BRL" 
	cLin := cLin + "000000000000000" 
	cLin := cLin + StrZero(TMD->ZR1_VALOR*100,15) 
	cLin := cLin + Space(20) 
	cLin := cLin + "00000000" 
	cLin := cLin + "000000000000000"  
	cLin := cLin + TMD->ZRA_CPFCGC
	cLin := cLin + Space(38) 
	cLin := cLin + "0" 
	cLin := cLin + Space(10) 
	nSega++
	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 

	
	** SEGMENTO B
	cLin := "001" 
	cLin := cLin + "0001" 
	cLin := cLin + "3" 
	cLin := cLin + StrZero(nSega,5) 
	cLin := cLin + "B" 
	cLin := cLin + Space(03) 
	cLin := cLin + Iif(Len(Trim(TMD->ZRA_CPFCGC))<14,"1","2") 
	cLin := cLin + StrZero(Val(TMD->ZRA_CPFCGC),14,0) 
	cLin := cLin + "RUA WIEGANO OLSEN            " 
	cLin := cLin + "001000" 
	cLin := cLin + Space(15) 
	cLin := cLin + "CIC            " 
	cLin := cLin + "CURITIBA            " 
	cLin := cLin + "81460070" 
	cLin := cLin + "PR" 
	cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)
	cLin := cLin + StrZero(TMD->ZR1_VALOR*100,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + StrZero(0,15) 
	cLin := cLin + Space(30) 
					
	nSega++
	_nTotsa += TMD->ZR1_VALOR
	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 

	TMD->(DbSkip())

Enddo
cLin := "001"
cLin := cLin + "0001" 
cLin := cLin + "5" 
cLin := cLin + Space(09) 
cLin := cLin + StrZero(nSega+1,6) 
cLin := cLin + StrZero(_nTotsa*100,18) 
cLin := cLin + StrZero(0,18) 
cLin := cLin + Space(181) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

cLin := "001" 
cLin := cLin + "9999" 
cLin := cLin + "9" 
cLin := cLin + Space(09) 
cLin := cLin + "000001"
cLin := cLin + StrZero(nSega+3,6) 
cLin := cLin + "000000"
cLin := cLin + Space(205) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 


DbSelectArea("TMD")
DbCloseArea("TMD")

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
		_cRet := cConta+cDac+" "
	Else
		_cRet := cConta+cDac
	Endif
	
Return(_cRet)



Static Functio fGeraag()
Local _cAgencia := _cConta := _cRet :=  _cDac := ''

	_cAgencia  := StrZero(Val(Substr(TMP->ZRA_AGENCI,1,4)),5,0)+Substr(TMP->ZRA_AGENCI,5,1)
	_cConta    := StrZero(Val(Substr(TMP->ZRA_CONTA,1,AT("-",TMP->ZRA_CONTA))),12,0)

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
        _cConta := StrZero(Val(TMP->ZRA_CONTA),12)
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
        _cConta := StrZero(Val(TMT->ZRA_CONTA),12)
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
        _cConta := StrZero(Val(TMD->ZRA_CONTA),12)
		_cRet   := _cAgencia+_cConta+Space(02)
	Endif

Return(_cRet) 


// Deposito banco do Brasil
Static Function fTmpDep()
Local _cTipo := Alltrim(Str(MV_PAR05)) // MV_PAR05

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,R1.ZR1_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZR1') + " R1 "
cQuery += "WHERE R1.D_E_L_E_T_ = ' ' " 
cQuery  += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"
cQuery += " AND RA.D_E_L_E_T_ = ' ' " 
cQuery += " AND R1.ZR1_TIPO = '" + _cTipo + "'"

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif


cQuery += " AND R1.ZR1_MAT BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"
cQuery += " AND RA.ZRA_FIM = ' ' " 
cQuery += " AND RA.ZRA_BANCO = '001' " 
cQuery += " AND R1.ZR1_MAT = RA.ZRA_MAT " 
cQuery += " AND R1.ZR1_DATA BETWEEN '" + Dtos(mv_par04) + "' AND '" + Dtos(mv_par04) + "'"
cQuery += " ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TMP" 

DbSelectArea("TMP")
TMP->(Dbgotop())
Return


// Ted acima de 5000,00 de Outros bancos
Static Function fTmpTed()
Local _cTipo := Alltrim(Str(MV_PAR05)) //MV_PAR05

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,R1.ZR1_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZR1') + " R1 "
cQuery += "WHERE R1.D_E_L_E_T_ = ' ' " 
cQuery  += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"
cQuery += " AND RA.D_E_L_E_T_ = ' ' " 
cQuery += " AND R1.ZR1_TIPO = '" + _cTipo + "'"

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif



cQuery += " AND RA.ZRA_FIM = ' ' " 
cQuery += " AND R1.ZR1_MAT BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"
cQuery += " AND RA.ZRA_BANCO <> '001' " 
cQuery += " AND RA.ZRA_BANCO <> '' " 
cQuery += " AND R1.ZR1_VALOR >= 3000 " 
cQuery += " AND R1.ZR1_MAT = RA.ZRA_MAT " 
cQuery += " AND R1.ZR1_DATA BETWEEN '" + Dtos(mv_par04) + "' AND '" + Dtos(mv_par04) + "'"
cQuery += " ORDER BY RA.ZRA_MAT " 

TCQUERY cQuery NEW ALIAS "TMT" 

DbSelectArea("TMT")
TMT->(Dbgotop())
Return


// Doc para menor que 5000,00 de Outros bancos
Static Function fTmpDoc()
Local _cTipo := Alltrim(Str(MV_PAR05))

cQuery := "SELECT RA.ZRA_MAT,RA.ZRA_CPFCGC,RA.ZRA_BANCO,RA.ZRA_AGENCI,RA.ZRA_CONTA,RA.ZRA_FAVORE,R1.ZR1_VALOR FROM " + RetSqlName('ZRA') + " RA, " +  RetSqlName('ZR1') + " R1 "
cQuery += "WHERE R1.D_E_L_E_T_ = ' ' " 
cQuery  += "AND RA.ZRA_FILIAL = '" + xFilial("ZRA")+ "'"
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND R1.ZR1_TIPO = '" + _cTipo + " '"

If Substr(Alltrim(mv_par03),1,4) == '5289'  // Filial PE 
	cQuery += "AND RA.ZRA_TIPOFJ = '9' " // PE

Elseif Substr(Alltrim(mv_par03),1,4) == '5189'
	cQuery += "AND RA.ZRA_TIPOFJ = '8' " // CTBA

Else
	cQuery += "AND RA.ZRA_TIPOFJ = '7' " // PALMEIRA

Endif

cQuery += " AND RA.ZRA_FIM = ' ' "
cQuery += " AND R1.ZR1_MAT BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "'"
cQuery += " AND RA.ZRA_BANCO <> '001' "
cQuery += " AND RA.ZRA_BANCO <> '' "
cQuery += " AND R1.ZR1_VALOR < 3000 " 
cQuery += " AND R1.ZR1_MAT = RA.ZRA_MAT " 
cQuery += " AND R1.ZR1_DATA BETWEEN '" + Dtos(mv_par04) + "' AND '" + Dtos(mv_par04) + "'"
cQuery += " ORDER BY RA.ZRA_MAT "

TCQUERY cQuery NEW ALIAS "TMD" 

DbSelectArea("TMD")
TMT->(Dbgotop())
Return