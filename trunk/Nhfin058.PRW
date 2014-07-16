/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN058  บAutor  ณMarcos R Roquitski  บ Data ณ  23/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao de Contratos.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"

User Function Nhfin058()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0, 3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","U_fExcParc()",0,5} ,;
             {"Gera Parcelas","U_fGeraParc()",0 , 2}}

cCadastro := "Cadastro de Contratos"

mBrowse(,,,,"SZT",,"ZT_DTPARC<>Ctod(Space(08))",)

Return


User Function fGeraParc()
Local _nD1 := _nD2 := _nD3 := _nPm := _nVlrPrin := _nTaxaMensal := _nParcela := _nJuros := _nAmort := _nSldDev := _nPar := 0
Local _cNumero := SZX->ZX_NUMERO, i := 1, _dDatav := Ctod(Space(08))
If MsgBox("Confima Liberacao no Financeiro ?","Liberacao","YESNO")

	If SZT->ZT_TIPO == "LEA" // Leasing

		If (SZT->ZT_DTPARC == Ctod(Space(08)))

			_nParcela := SZT->ZT_PARCELA
			_nVlrPrin := SZT->ZT_VALOR
			_nTaxaMensal := SZT->ZT_TAXA

			_nD1 := (_nVlrPrin * (_nTaxaMensal/100))
			_nD2 := (1 - ((1 + (_nTaxaMensal/100))**-_nParcela))
			_nPm := (_nD1/_nD2)
			_nAmort := _nVlrPrin
			_dDatav := SZT->ZT_DATA

			DbSelectArea("SZX")
			While i <= SZT->ZT_PARCELA

				_nJuros  := _nAmort * (1 +_nTaxaMensal/100)**1
		        _nJuros  := (_nJuros - _nAmort)
		        _nSldDev := (_nAmort - (_nPm - _nJuros))
				_dDatav  += 30
				_dDatav  := Ctod(StrZero(DAY(SZT->ZT_DATA),2) +"/"+ StrZero(Month(_dDatav),2) +"/"+ Str(Year(_dDatav)))

				RecLock("SZX",.T.)
				SZX->ZX_FILIAL  := xFilial("SZX")
				SZX->ZX_NUMERO  := SZT->ZT_NUMERO
				SZX->ZX_VENCTO  := _dDatav
				SZX->ZX_PARCELA := i
				SZX->ZX_VLPRINC := (_nPm - _nJuros)
				SZX->ZX_VLJUROS := _nJuros
				SZX->ZX_VLPAGO  := _nPm
				SZX->ZX_SLDDEV  := _nSldDev
				MsUnLock("SZX")
				_nJuros := 0
				_nAmort := _nSldDev
				i++
			Enddo			
			DbSelectArea("SZT")
			RecLock("SZT",.F.)			
			SZT->ZT_DTPARC := dDataBase
			MsUnLock("SZT")
		Else
			MsgBox("Contrato ja processado! Cancele o processamento para gerar novamente as parcelas.","Geracao de Parcelas","ALERT")
		Endif

	Else

		If (SZT->ZT_DTPARC == Ctod(Space(08)))

			If Val(SZT->ZT_ITEM) - SZT->ZT_PARCELA == 0
				_nParcela := SZT->ZT_PARCELA				
			Else	
				_nParcela := (Val(SZT->ZT_ITEM) - SZT->ZT_PARCELA) + 1
			Endif
			_nVlrPrin := SZT->ZT_VALOR
			_nTaxaMensal := SZT->ZT_TAXA

			_nD1 := _nVlrPrin 
			_nD2 := SZT->ZT_PARCELA
			_nPm := (_nD1/_nD2)
			_nAmort := _nVlrPrin
			_dDatav := SZT->ZT_DATA
			_nPar := _nParcela
				
			DbSelectArea("SZX")
			While i <= SZT->ZT_PARCELA

		        _nJuros  := 0
		        _nSldDev := (_nAmort - (_nPm - _nJuros))
				_dDatav  += 30
				_dDatav  := Ctod(StrZero(DAY(SZT->ZT_DATA),2) +"/"+ StrZero(Month(_dDatav),2) +"/"+ Str(Year(_dDatav)))

				RecLock("SZX",.T.)
				SZX->ZX_FILIAL  := xFilial("SZX")
				SZX->ZX_NUMERO  := SZT->ZT_NUMERO
				SZX->ZX_VENCTO  := _dDatav
				SZX->ZX_PARCELA := _nPar
				SZX->ZX_VLPRINC := (_nPm - _nJuros)
				SZX->ZX_VLJUROS := _nJuros
				SZX->ZX_VLPAGO  := _nPm
				SZX->ZX_SLDDEV  := _nSldDev
				MsUnLock("SZX")
				_nJuros := 0
				_nAmort := _nSldDev
				i++
				_nPar++
			Enddo
			DbSelectArea("SZT")
			RecLock("SZT",.F.)
			SZT->ZT_DTPARC := dDataBase
			MsUnLock("SZT")
		Else
			MsgBox("Contrato ja processado! Cancele o processamento para gerar novamente as parcelas.","Geracao de Parcelas","ALERT")
		Endif


	/*
	Elseif SZT->ZT_TIPO == "FNM" // Finame

		If (SZT->ZT_DTPARC == Ctod(Space(08)))

			_nParcela    := SZT->ZT_PARCELA
			_nVlrPrin    := SZT->ZT_VALOR
			_nTaxaMensal := (SZT->ZT_VALIND + SZT->ZT_COMISSA + SZT->ZT_SPREAD)
			_nVlPriConv  := (SZT->ZT_VALOR / ZBL->ZBL_VALOR) // Valor convertido

			DbSelectArea("SZX")
			While i <= SZT->ZT_PARCELA

				_nD1     := ((_nTaxaMensal/100)+1)
				_nD2     := ((dDataBase-SZT->ZT_DATA)/360)
				_nD3     := (((_nD1)**_nD2)-1)
				_nJuros  := (_nD3 * _nVlPriConv)
				_nSldDev := _nVlPriConv + _nJuros

				_dDatav  += 30
				_dDatav  := Ctod(StrZero(DAY(SZT->ZT_DATA),2) +"/"+ StrZero(Month(_dDatav),2) +"/"+ Str(Year(_dDatav)))

				RecLock("SZX",.T.)
				SZX->ZX_FILIAL  := xFilial("SZX")
				SZX->ZX_NUMERO  := SZT->ZT_NUMERO
				SZX->ZX_VENCTO  := _dDatav
				SZX->ZX_PARCELA := i
				SZX->ZX_VLPRINC := _nVlPriConv
				SZX->ZX_VLJUROS := _nJuros
				--SZX->ZX_VLPAGO  := _nPm
				SZX->ZX_SLDDEV  := _nSldDev
				MsUnLock("SZX") 
				
				_nJuros := 0
				_nAmort := _nSldDev
				i++

			Enddo			
			DbSelectArea("SZT")
			RecLock("SZT",.F.)			
			SZT->ZT_DTPARC := dDataBase
			MsUnLock("SZT")

		Else

			MsgBox("Contrato ja processado! Cancele o processamento para gerar novamente as parcelas.","Geracao de Parcelas","ALERT")

		Endif

    */
	
	Endif

Endif
Return

User Function fExcParc()
	If MsgBox("Confima Exclusao do Contrato ?","Exclusao contrato","YESNO")

		If SZT->ZT_DTPARC <> Ctod(Space(8))
	
			If MsgBox("ATENCAO, Contrato com Parcelas geradas no financeiro. Cofirma exclusao do Contrato ?","Exclusao contrato","YESNO")

				DbSelectArea("SZX")
				SZX->(DbSetOrder(1))
				SZX->(DbSeek(xFilial("SZX") +  SZT->ZT_NUMERO))
				While !SZX->(Eof()) .AND. SZT->ZT_NUMERO == SZX->ZX_NUMERO
					RecLock("SZX",.F.)			
					SZX->(DbDelete())
					MsUnLock("SZX")
					SZX->(DbSkip())
				Enddo

				DbSelectArea("SZT")
				RecLock("SZT",.F.)
				SZT->(DbDelete())
				MsUnLock("SZT")
				SZT->(DbSkip())
			Endif

		Endif			

	Endif

Return
