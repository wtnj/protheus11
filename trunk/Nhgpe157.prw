/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE157  ºAutor  ³Marcos R Roquitski  º Data ³  09/04/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo Visa Vale novos funcionarios.                 º±±
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

User Function Nhgpe157()

SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,CCODNH,CCODFN")
SetPrvt("nHdl,cLin,cFnl")

If !Pergunte("GPE105",.T.)
	Return 
Endif

// 
fTmpTodos()
If !Empty(TMP->RA_MAT)
	If SM0->M0_CODIGO == "FN"	
		cArqTed  := "FNBT" + Substr(Dtos(dDataBase),5,4) + ".REM" // TED
		cCodVisa := "00000144410"
	Else
		cArqTed  := "NHBT" + Substr(Dtos(dDataBase),5,4) + ".REM" // TED
		cCodVisa := "00000061410"
	Endif	
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqTed)
	lEnd    := .F.

	MsAguarde ( {|lEnd| fArqVisa() },"Aguarde","Gerando arquivo...",.T.)

Endif	

Return


// Layout Visa Vale.
Static Function fArqVisa()
Local nSega := 3
Local _nTotsa := 0
Local nReg5 := 0
Local nValor := 0
Local nTotVlr := 0
Local _nSalario := 0

	nlin := 0
	
	** Header
	cLin := "0"
	cLin := cLin + Substr(Dtos(dDataBase),7,2)+Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
	cLin := cLin + "A001"
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,35)
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + "00000000000"
	cLin := cLin + cCodVisa // Numero do contrato
	cLin := cLin + "000000" // Numero do pedido do cliente	
	cLin := cLin + "07052010"
	cLin := cLin + "1"		
	cLin := cLin + "1"		
	cLin := cLin + Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)
	cLin := cLin + Space(18)
	cLin := cLin + "007"		
	cLin := cLin + Space(267)			
	cLin := cLin + "000001"

	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))


	** REGISTRO FILIAL OU POSTO DE PESSOA JURIDICA
	cLin := "1"
	cLin := cLin + Substr(SM0->M0_CGC,1,14)
	cLin := cLin + "0000000000"
	cLin := cLin + Substr(SM0->M0_NOMECOM,1,35)
	cLin := cLin + "0041"
	
	// Primeiro interlocutor
	cLin := cLin + "MARCIO LIZEIKO                     " 
	cLin := cLin + "RUA WIEGANO OLSEN, 1000                 "
	cLin := cLin + "000033411236"
	cLin := cLin + "001236"
	
	
	 // Segundo interlocutor	
	cLin := cLin + Space(35)
	cLin := cLin + Space(40)
	cLin := cLin + "000000000000"
	cLin := cLin + "000000"    
	

	 // Terceiro interlocutor
	cLin := cLin + Space(35)
	cLin := cLin + Space(40)
	cLin := cLin + "000000000000"
	cLin := cLin + "000000"    

	cLin := cLin + Space(20)
	cLin := cLin + Space(31) // Brancos
	cLin := cLin + "000002" // Sequencial

	cLin := cLin + cFnl 
	fWrite(nHdl,cLin,Len(cLin)) 


DbselectArea("TMP")
TMP->(DbGotop())
While !TMP->(Eof())


	If TMP->RA_CATFUNC = 'H'
		_nSalario := (TMP->RA_SALARIO * TMP->RA_HRSMES)	   
	
	Else
		_nSalario := TMP->RA_SALARIO
	
	Endif      

	If _nSalario <= 2378.00

		** REGISTRO DE USUARIOS (FUNCIONARIOS)
		cLin := "5"
		cLin := cLin + StrZero((nValor * 100),11)
		cLin := cLin + Space(01)
		cLin := cLin + TMP->RA_MAT + Space(7)
		cLin := cLin + Space(54)
		cLin := cLin + Substr(Dtos(TMP->RA_NASC),7,2)+Substr(Dtos(TMP->RA_NASC),5,2)+Substr(Dtos(TMP->RA_NASC),1,4)
		cLin := cLin + TMP->RA_CIC
		cLin := cLin + "1"
		cLin := cLin + Substr(TMP->RA_RG,1,13)
		cLin := cLin + Space(20)
		cLin := cLin + Space(06)	
		cLin := cLin + StrZero(Val(TMP->RA_PIS),15) // + Space(04)
		cLin := cLin + TMP->RA_SEXO
		cLin := cLin + Space(01) // TMP->RA_ESTCIVI
		cLin := cLin + TMP->RA_ENDEREC + TMP->RA_COMPLEM
		cLin := cLin + "00000"
		cLin := cLin + STRZERO(VAL(TMP->RA_CEP),8)
		cLin := cLin + TMP->RA_MUNICIP + Space(08)
		cLin := cLin + TMP->RA_BAIRRO + Space(15)
		cLin := cLin + TMP->RA_ESTADO	
		cLin := cLin + Substr(TMP->RA_MAE,1,35)
		cLin := cLin + "R"
		cLin := cLin + "0041"
		cLin := cLin + "33411900"	
		cLin := cLin + "1900"	
		cLin := cLin + "0000"	
		cLin := cLin + "00000000"	
		cLin := cLin + Space(01)
		cLin := cLin + Substr(Dtos(TMP->RA_ADMISSA),7,2)+Substr(Dtos(TMP->RA_ADMISSA),5,2)+Substr(Dtos(TMP->RA_ADMISSA),1,4)
		cLin := cLin + Space(01)

		If Empty(TMP->RA_NOMECMP)
			cLin := cLin + TMP->RA_NOME + Space(10)
		Else
			cLin := cLin + Substr(TMP->RA_NOMECMP,1,40)
		Endif
		cLin := cLin + Space(06)
		cLin := cLin + StrZero(nSega,6) 
	
		nReg5++
		nSega++
	    nTotVlr += nValor
		cLin := cLin + cFnl 
		fWrite(nHdl,cLin,Len(cLin)) 

    Endif
	TMP->(DbSkip())

Enddo
cLin := "9"
cLin := cLin + StrZero(nReg5,6) 
cLin := cLin + StrZero((nTotVlr*100),15) 
cLin := cLin + Space(372) 
cLin := cLin + StrZero(nSega,6) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 


DbSelectArea("TMP")
DbCloseArea("TMP")

Return(nil)


// Todos Funcionarios      
Static Function fTmpTodos()

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA "
cQuery += "WHERE RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_SITFOLH IN (' ','F','A') " 
cQuery += "AND RA.RA_CATFUNC IN ('H','M') " 
cQuery += "AND RA.RA_MAT BETWEEN '"+ Mv_par03 + "' AND '"+ Mv_par04 + "' "
cQuery += "AND RA.RA_CC BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "

	//_cZemp := StrZero(mv_par05,1)

	_cZemp := mv_par05


	If Mv_par05 $ '2/3/4/5' // 2-fundicao/3-usinagem/4-forjaria/5-virabrequim
	    cQuery  += " AND RA.RA_ZEMP = '" + _cZemp + "' "

		If Mv_par05 == '3'
			cQuery  += " AND RA.RA_CODFUNC <> '1193' "
		Endif
 
		If Mv_par05 == '2'
			cQuery  += " AND RA.RA_CODFUNC <> '0321' "
		Endif

	Elseif Mv_par05 == '7'
	    cQuery  += " AND RA.RA_ZEMP IN ('2','4','5') "
		cQuery  += " AND RA.RA_CODFUNC <> '0321' "
	Endif

    
	/*
	If Mv_par05 == 1 // Usinagem
    cQuery  += "AND RA.RA_ZEMP = '" + _cZemp + "' "
	cQuery  += "AND RA.RA_CODFUNC <> '1193' "	    
	Endif

	If Mv_par05 == 2 // Fundicao 
    cQuery  += "AND RA.RA_ZEMP = '" + _cZemp + "' "
	cQuery  += "AND RA.RA_CODFUNC <> '0321' "	    
	Endif
    */
    
cQuery += "ORDER BY RA.RA_MAT " 

TCQUERY cQuery NEW ALIAS "TMP" 
TcSetField("TMP","RA_ADMISSA","D") // Muda a data de string para date.
TcSetField("TMP","RA_NASC","D") // Muda a data de string para date.
Return


