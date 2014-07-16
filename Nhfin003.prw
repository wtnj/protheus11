/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao    ³ Nhfin003 ³ Autor ³ Marcos R. Roquitski   ³ Data ³ 19/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Leitura de Codigo de Barras de Bloquetos                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
#include "rwmake.ch"

User Function Nhfin003()

If SE2->E2_SALDO <=0
   MsgBox("Titulo baixado, Leitura do codigo de barras nao autorizado!","Atencao","INFO")
   Return
Elseif SE2->E2_SALDO <> SE2->E2_VALOR
   MsgBox("Atencao, VALOR do titulo diferente do SALDO, Verifique!","Atencao","INFO")
   Return
Endif

SetPrvt("C_PREFIXO,C_NUM,C_PARCELA,C_TIPO,C_NATUREZA,C_PORTADO")
SetPrvt("C_FORNECEDOR,C_LOJA,D_EMISSAO,D_VENCTO,D_VENCREA,N_VALOR")
SetPrvt("C_CCUSTO1,C_CCUSTO2,C_PLNCUST,C_HISTORICO,C_CODBARRAS,N_DESCONT")
SetPrvt("N_SALDO,C_NMFORNECEDOR,cCodig,nTotal,nConta,nVezes,_nVlrld")
SetPrvt("I,nResto,nDv,nValor,nSaldos,nBase,l,_cValord,_cValorp,_nVlrgr")

c_Prefixo    := SE2->E2_PREFIXO
c_Num        := SE2->E2_NUM
c_Parcela    := SE2->E2_PARCELA
c_Tipo       := SE2->E2_TIPO
c_Natureza   := SE2->E2_NATUREZ
c_Portado    := SE2->E2_PORTADO
c_Fornecedor := SE2->E2_FORNECE
c_Loja       := SE2->E2_LOJA
d_Emissao    := SE2->E2_EMISSAO
d_Vencto     := SE2->E2_VENCTO
d_Vencrea    := SE2->E2_VENCREA
n_Valor      := SE2->E2_VALOR
c_Ccusto1    := SE2->E2_CC
c_Historico  := SE2->E2_HIST
c_CodBarras  := SE2->E2_CODBAR+" " 
n_Descont    := SE2->E2_DESCONT
n_Saldo      := SE2->E2_SALDO
_nVlrld      := 0

// SA2->(DbOrderNickName("SA2_1"))
SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
c_NmFornecedor := Left(SA2->A2_NOME,22)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 135,002 To 500,750 Dialog DlgTitulos Title OemToAnsi("Leitura de Codigo de Barras")
@ 001,009 To 120,360
@ 011,015 Say OemToAnsi("Prefixo") Size 42,8
@ 021,015 Say OemToAnsi("Parcela") Size 42,8
@ 031,015 Say OemToAnsi("Natureza") Size 42,8
@ 041,015 Say OemToAnsi("Fornecedor") Size 42,8
@ 051,015 Say OemToAnsi("Nome Fornec") Size 42,8
@ 061,015 Say OemToAnsi("Vencimento") Size 42,8 
@ 071,015 Say OemToAnsi("Vlr. Titulo") Size 42,8
@ 081,015 Say OemToAnsi("Centro Custo") Size 42,8
@ 091,015 Say OemToAnsi("Historico") Size 42,8 
@ 011,215 Say OemToAnsi("No.Titulo") Size 42,8
@ 021,215 Say OemToAnsi("Tipo") Size 42,8
@ 031,215 Say OemToAnsi("Portador") Size 42,8
@ 041,215 Say OemToAnsi("Loja") Size 42,8
@ 051,215 Say OemToAnsi("DT.Emissao") Size 42,8
@ 061,215 Say OemToAnsi("Vencto Real") Size 42,8 
@ 071,215 Say OemToAnsi("Salo") Size 42,8

@ 130,009 To 160,360 TITLE " Leitura do Codigo de Barras "
@ 145,015 Say OemToAnsi("Codigo de Barras") Size 42,8

@ 145,072 Get c_CodBarras Picture Repli("9",50) Size 250,8
@ 011,060 Get c_Prefixo When .F. Size 25,8
@ 021,060 Get c_Parcela When .F. Size 25,8
@ 031,060 Get c_Natureza When .F. Size 25,8
@ 041,060 Get c_Fornecedor When .F. Size 25,8
@ 051,060 Get c_Nmfornecedor When .F. Size 90,8
@ 061,060 Get d_Vencto  When .F. Size 35,8
@ 071,060 Get n_Valor Picture "@E 999,999,999.99" When .F. Size 55,8
@ 081,060 Get c_Ccusto1 When .F. Size 25,8
@ 091,060 Get c_Historico When .F. Size 90,8
@ 011,270 Get c_Num When .F. Size 25,8
@ 021,270 Get c_Tipo When .F. Size 20,8
@ 031,270 Get c_Portado When .F. Size 45,8
@ 041,270 Get c_Loja When .F. Size 15,8
@ 051,270 Get d_Emissao When .F. Size 35,8
@ 061,270 Get d_Vencrea When .F. Size 35,8
@ 071,270 Get n_Saldo   Picture "@E 999,999,999.99" When .F. Size 55,8

@ 165,245 BMPBUTTON TYPE 01 ACTION CodigoBarra()
@ 165,285 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)

Activate Dialog DlgTitulos CENTERED

Return(nil)


Static Function CodigoBarra()

	If Len(Alltrim(c_CodBarras)) == 44 // Leitura LEITORA DE COD. BARRA

		cCodig := Substr(c_CodBarras,1,4)+Substr(c_CodBarras,6,39)
		nTotal := 0
		nConta := 2
		nVezes := 43
	
		For i := 1 to 43
			If nConta > 9
				nConta := 2
			Endif
			nTotal := nTotal + (Val(Substr(cCodig,nVezes,1)) * nConta)
			nConta := nConta + 1
			nVezes := nVezes - 1
		Next
		nResto := nTotal % 11
		nDv    := 11 - nResto
	
		If nDv == 10 .or. nDv == 11
			nDv := 1
		Endif
	
		if nDv <> Val(Substr(c_CodBarras,5,1))
			MsgBox("Erro na Leitura do Codigo de Barras !","Codigo de Barras","INFO")
			Return(nil)
		Endif
		nValor := SE2->E2_VALOR
		nSaldos := SE2->E2_VALOR
		_cValord := Substr(c_CodBarras,10,10)

	Else

		If !Empty(c_CodBarras)

			// Valida Campo1 Linha Digitada	
			cCodig := Substr(c_CodBarras,1,9)
			nConta := 2
			nVezes := 1
			nBase  := 0
			nTotal := 0
			nDv    := 0
			nResto := 0

			For l := 1 To 9

				nBase := (Val(Substr(cCodig,l,1)) * nConta)

				If nBase >= 10
					nBase := Val(Substr(Alltrim(Str(Int(nBase))),1,1)) + Val(Substr(Alltrim(Str(Int(nBase))),2,1))
				Endif
				nTotal := nTotal + nBase
				nBase  := 0 

				If nConta == 2
					nConta := 1
				Else
					nConta := nConta + 1
				Endif   
			Next
		
			If nTotal < 10
				nDv := 10 - nTotal
			Else
				nResto := nTotal % 10
				If nResto == 0
				    nDv := 0
				Else
					nDv    := 10 - nResto
				Endif    
			Endif		   
	
			If Val(Substr(c_CodBarras,10,1)) <> nDv
				MsgBox("Digito verificador nao confere no Campo 1","Linha Digitada","INFO")
				Return
			Endif 
	
 
			// Valida Campo2 Linha Digitada
			cCodig := Substr(c_CodBarras,11,10)
			nConta := 1
			nVezes := 1
			nBase  := 0
			nTotal := 0
			nDv    := 0
			nResto := 0
			l      := 0

			For l := 1 To 10

				nBase := (Val(Substr(cCodig,l,1)) * nConta)
	
				If nBase >= 10
					nBase := Val(Substr(Alltrim(Str(Int(nBase))),1,1)) + Val(Substr(Alltrim(Str(Int(nBase))),2,1))
				Endif
				nTotal := nTotal + nBase
				nBase  := 0 
				If nConta == 2
					nConta := 1
				Else
					nConta := nConta + 1
				Endif   
			Next
	
			If nTotal < 10
				nDv := 10 - nTotal
			Else
				nResto := nTotal % 10
				If nResto == 0
					nDv := 0
				Else
					nDv    := 10 - nResto
				Endif    
			Endif		   
	
			If Val(Substr(c_CodBarras,21,1)) <> nDv
				MsgBox("Digito verificador nao confere no Campo 2","Linha Digitada","INFO")
				Return
			Endif 

			 // Valida Campo3 Linha Digitada
			cCodig := Substr(c_CodBarras,22,10)
			nConta := 1
			nVezes := 1
			nBase  := 0
			nTotal := 0
			nDv    := 0
			nResto := 0
			l      := 0
		
			For l := 1 To 10

				nBase := (Val(Substr(cCodig,l,1)) * nConta)
	
				If nBase >= 10
					nBase := Val(Substr(Alltrim(Str(Int(nBase))),1,1)) + Val(Substr(Alltrim(Str(Int(nBase))),2,1))
				Endif
				nTotal := nTotal + nBase
				nBase  := 0

				If nConta == 2
					nConta := 1
				Else
					nConta := nConta + 1
				Endif   
			Next
	
			If nTotal < 10
				nDv := 10 - nTotal
			Else
				nResto := nTotal % 10
				If nResto == 0
					nDv := 0
				Else
					nDv    := 10 - nResto
				Endif   
			Endif		   
	
			If Val(Substr(c_CodBarras,32,1)) <> nDv
				MsgBox("Digito verificador nao confere no Campo 3.","Linha Digitada","INFO")
				Return
			Endif 
   
			If Len(Substr(c_CodBarras,34,4)) == 4 .And. Val(Substr(c_CodBarras,38,10)) > 0
				nValor  := Val(Substr(c_CodBarras,38,14)) / 100
				nSaldos := Val(Substr(c_CodBarras,38,10)) / 100
			
				_cValord := Substr(c_CodBarras,38,10)
				_cValorp := StrZero((SE2->E2_SALDO * 100),10)
			
				If _cValord <> _cValorp
					MsgBox("Valor digitado nao confere com o Saldo do Titulo . .","Linha Digitada","INFO")
		            Return
				Endif

				If nSaldos <> SE2->E2_SALDO
					MsgBox("Valor digitado nao confere com o Saldo do Titulo","Linha Digitada","INFO")
		            Return
				Endif
			Else
				nValor := SE2->E2_SALDO
				nSaldos := SE2->E2_SALDO
			Endif

		Else
			nValor := SE2->E2_SALDO
			nSaldos := SE2->E2_SALDO
		Endif

    Endif
	If Empty(Alltrim(_cValord))
		_nVlrld := 0			
	Else
		_nVlrld := (Val(_cValord) / 100)
	Endif	
	_nVlrgr := _nVlrld
		
	@ 200,050 To 500,400 Dialog DlgValores Title OemToAnsi("Confirmacao do valor do titulo")

	@ 011,020 Say OemToAnsi("Valor Cod.Barra") Size 35,8
	@ 025,020 Say OemToAnsi("Vencimento     ") Size 35,8
	@ 039,020 Say OemToAnsi("Portador       ") Size 35,8
	@ 053,020 Say OemToAnsi("Centro Custo   ") Size 35,8
                                                        
	@ 067,020 Say OemToAnsi("Valor Leitura  ") Size 35,8
	@ 081,020 Say OemToAnsi("Valor a Pagar  ") Size 35,8	     
     
	@ 010,070 Get nSaldos   PICTURE "@E 999,999,999.99" When .F. Size 65,8
	@ 024,070 Get d_Vencto  PICTURE "99/99/99" Valid(U_fDvencto(d_Vencto)) Size 45,8
	@ 038,070 Get c_Portado PICTURE "@!" F3 "SA6" Valid(Vazio() .or. Existcpo("SA6")) Size 35,8
	@ 053,070 Get c_cCusto1 PICTURE "@!" F3 "SI3" Valid(Vazio() .or. Existcpo("SI3")) Size 35,8
	@ 067,070 Get _nVlrld   PICTURE "@E 999,999,999.99" When .f. Size 65,8
	@ 081,070 Get _nVlrgr   PICTURE "@E 999,999,999.99" Valid(U_fVlrgr(_nVlrgr)) Size 65,8
      
	@ 105,050 BMPBUTTON TYPE 01 ACTION GravaDados()
	@ 105,090 BMPBUTTON TYPE 02 ACTION Close(DlgValores)
	Activate Dialog DlgValores CENTERED
	
Return

Static Function GravaDados()
	RecLock("SE2",.F.)
	SE2->E2_CODBAR  := c_CodBarras
	SE2->E2_VENCTO  := d_Vencto                           
	SE2->E2_VENCREA := d_Vencto
	SE2->E2_PORTADO := c_Portado
	SE2->E2_CC      := c_Ccusto1
	If _nVlrgr > 0
		SE2->E2_VALOR   := _nVlrgr
		SE2->E2_SALDO   := _nVlrgr
	Endif	
	MsUnlock("SE2")
	Close(DlgValores)
	Close(DlgTitulos)
Return(.T.)

User Function fVlrgr(_nVlr)
Local lRet := .F., _nDif := 0

	_nDif  := (SE2->E2_VALOR - _nVlr)
	
	If (_nDif > 1)
		MsgBox("Valor para pagamento superior a 1,00 do valor Original Verifique!","Alert")
	Elseif (_nDif < -1)
		MsgBox("Valor para pagamento Inferior a 1,00 do valor Original Verifique!","Alert")
	Else
		lRet := .T.	
	Endif	
Return(lRet)

User Function fDvencto(_dData)
Local lRet := .T.
Local _nD1 := 100
Local _nD2 := 100
Local _n5  := 5

_nD1 := GetMv("MV_FIND1")
_nD2 := GetMv("MV_FIND2") 

If _dData < SE2->E2_VENCTO
	MsgBox("Data de vencimento digitada MENOR que o vencimento original. Verifique!","Atencao","ALERT")
	lRet := .F.
Endif

Return(lRet)
