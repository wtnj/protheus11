/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN059  บAutor  ณMarcos R Roquitski  บ Data ณ  23/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manutencao dos itens de contrato.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function Nhfin059()

SetPrvt("aRotina,cCadastro,_cNumero,_dVencto,_cParcela,_VlPrinc,_VlJuros,_VlPago,_SldDev")
SetPrvt("_nDesc,_nMulta,_nTxPerm,_VlPago2")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} ,;
             {"Baixa","U_fGeraBaix()",0,4},;
             {"Financeiro","U_fGeraFin()",0,4}}
             
cCadastro := "Cadastro de Contratos"

mBrowse(,,,,"SZX",,"ZX_DTPGTO<>Ctod(Space(08))",)

Return

User Function fGeraBaix()

	_cNumero  := SZX->ZX_NUMERO
	_dVencto  := SZX->ZX_VENCTO
	_nParcela := SZX->ZX_PARCELA
	_VlPrinc  := SZX->ZX_VLPRINC
	_VlJuros  := SZX->ZX_VLJUROS
	_VlPago   := SZX->ZX_VLPAGO
	_VlSldDev := SZX->ZX_SLDDEV
	_VlPrinc  := SZX->ZX_VLPRINC
	_VlJuros  := SZX->ZX_VLJUROS
	_SldDev   := SZX->ZX_SLDDEV
	
	_cBanco   := Space(06)
	_cAgencia := Space(06)
	_cConta   := Space(15)
	_cCheque  := Space(10)
	_dDatPag  := Ctod(Space(08))
	_cHist    := Space(40)
	_cBene    := Space(40)
	_nDesc    := 0
	_nMulta   := 0
	_nTxPerm  := 0
	_VlPago2  := SZX->ZX_VLPAGO


	@ 100,050 To 320,500 Dialog oDlg Title OemToAnsi("Baixa")
  @ 005,005 To 090,222 PROMPT "Dados do Emprestimo" OF oDlg  PIXEL
	@ 015,010 Say OemToAnsi("Numero     ") Size 35,8 OF oDlg PIXEL
	@ 025,010 Say OemToAnsi("Vencimento ") Size 35,8 OF oDlg PIXEL
	@ 035,010 Say OemToAnsi("Parcela    ") Size 35,8 OF oDlg PIXEL
	@ 055,010 Say OemToAnsi("Vl. Parcela") Size 35,8 OF oDlg PIXEL
	@ 065,010 Say OemToAnsi("Amortizacao") Size 35,8 OF oDlg PIXEL
	@ 055,125 Say OemToAnsi("Vl. Juros")   Size 35,8 OF oDlg PIXEL
	@ 065,125 Say OemToAnsi("Saldo Devedor")  Size 35,8 OF oDlg PIXEL

	@ 015,050 Get _cNumero   PICTURE "@!" When .F. Size 65,8  OF oDlg PIXEL
	@ 025,050 Get _dVencto   PICTURE "99/99/99" When .F. Size 65,8  OF oDlg PIXEL
	@ 035,050 Get _nParcela  PICTURE "999" When .F. Size 65,8  OF oDlg PIXEL
	@ 055,050 Get _VlPago    PICTURE "@E 999,999,999.99" When .F. Size 65,8  OF oDlg PIXEL
	@ 065,050 Get _VlPrinc   PICTURE "@E 999,999,999.99" When .F. Size 65,8  OF oDlg PIXEL
	@ 055,155 Get _VlJuros   PICTURE "@E 999,999,999.99" When .F. Size 65,8  OF oDlg PIXEL
	@ 065,155 Get _SldDev    PICTURE "@E 999,999,999.99" When .F. Size 65,8  OF oDlg PIXEL
         
	@ 095,155 BMPBUTTON TYPE 01 ACTION fGravaFin()
	@ 095,192 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg CENTERED

Return

Static Function fVldVlr(_nVlr)
	If _nVlr < 0
		MsgBox("Valor negativo Invalido. Corrija ","Validacao de valores","ALERT")
	Else	
		_VlPago2 := (_VlPago - _nDesc - _nMulta - _nTxPerm)
	Endif
	oDlg:Refresh()
Return


Static Function fGravaFin()
Local lReturn := .T., m, l,aVenc, _cNomFor, _cNaturez

	If (ZX_DTPGTO == Ctod(Space(08)))
		_cNomFor  := Space(30)
		_cNaturez := Space(15)

		SZT->(DbSetOrder(1))
		SZT->(DbSeek(xFilial("SZT") +  SZX->ZX_NUMERO))
		If SZT->(Found())

			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2") +  SZT->ZT_FORNEC + SZT->ZT_LOJA))
			If SA2->(Found())
				_cNomFor  := SA2->A2_NREDUZ
			Endif

			RecLock("SE2",.T.)

   	  	    SE2->E2_PREFIXO   := StrZero(Val(SZX->ZX_NUMERO),3)
   	  	    SE2->E2_NUM       := StrZero(SZX->ZX_PARCELA,3)+'/'+StrZero(Val(Alltrim(SZT->ZT_ITEM)),3)
  	        SE2->E2_TIPO      := "FI"
	        SE2->E2_NATUREZ   := SZT->ZT_NATURE
            SE2->E2_FORNECE   := SZT->ZT_FORNEC
	        SE2->E2_LOJA      := SZT->ZT_LOJA
	        SE2->E2_NOMFOR    := _cNomFor
	        SE2->E2_EMISSAO   := dDataBase               
	        SE2->E2_VENCTO    := _dVencto
	        SE2->E2_VENCREA   := _dVencto
	        SE2->E2_VENCORI   := _dVencto
	        SE2->E2_VALOR     := _VlPago2
	        SE2->E2_EMIS1     := dDataBase
	        SE2->E2_SALDO     := _VlPago2
	        SE2->E2_MOEDA     := 1
	        SE2->E2_FATURA    := ""
	        SE2->E2_VLCRUZ    := _VlPago2
	        SE2->E2_ORIGEM    := "FINA050"
	        SE2->E2_CC        := SZT->ZT_CC
			SE2->E2_FLUXO     := "S"
			SE2->E2_FILORIG   := xFilial("SE2")
			SE2->E2_DESDOBR   := "N"
			SE2->E2_RATEIO    := "N"
	        MsUnlock("SE2")

			RecLock("SZX",.F.)
			SZX->ZX_DTPGTO := dDataBase
			MsUnlock("SZX")

		Else
			MsgBox("Nao foi possivel gerar financeiro da parcela. Verifique o contrato !","Gera Financeiro","ALERT")
		Endif
	
	Else

		MsgBox("Lancamento ja baixado. Nao sera possivel gerar financeiro !","Gera financeiro","ALERT")	

	Endif
	
	
	
	Close(oDlg)

Return(lReturn)
 


// Gera parcelas no financeiro
User Function fGerafin()
Local lReturn := .T., m, l,aVenc, _cNomFor, _cNaturez
Local _cDescTipo := ''
_cNumero  := SZX->ZX_NUMERO

	SZT->(DbSetOrder(1))
	SZT->(DbSeek(xFilial("SZT") +  SZX->ZX_NUMERO))
	If !SZT->(Found())
		MsgBox("Nao foi possivel gerar financeiro do contrato. Verifique o contrato !","Gera Financeiro","ALERT")
		Return	
	Endif

	If MsgBox("** ATENCAO ** Confirma geracao de  parcelas no financeiro?","Financeiro","YESNO")

		SZX->(DbSetOrder(1))
		SZX->(DbSeek(xFilial("SZX") +  _cNumero))
		While !SZX->(Eof()) .and. _cNumero == SZX->ZX_NUMERO

			If (SZX->ZX_FINAN == Ctod(Space(08))) .and. SZX->ZX_DTPGTO == Ctod(Space(08)) .and. !Empty(SZT->ZT_FORNEC)
				_cNomFor  := Space(30)
				_cNaturez := Space(15)

				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2") +  SZT->ZT_FORNEC + SZT->ZT_LOJA))
				If SA2->(Found())
					_cNomFor  := SA2->A2_NREDUZ
				Endif

 		        SE2->(dbSetOrder(1))
		        SE2->(dbSeek(xFilial("SE2")+StrZero(SZX->ZX_PARCELA,3)+SZX->ZX_NUMERO+" FI"+SZT->ZT_FORNEC+SZT->ZT_LOJA))
				If !SE2->(Found())
					RecLock("SE2",.T.)
					SE2->E2_FILIAL    := xFilial("SZX")
        	  	    SE2->E2_PREFIXO   := StrZero(Val(SZX->ZX_NUMERO),3)
					If SZT->ZT_TIPO == 'LEA'
	        	  	    SE2->E2_NUM       := StrZero(SZX->ZX_PARCELA,3)+'/'+StrZero(SZT->ZT_PARCELA,3)					
					Else
	        	  	    SE2->E2_NUM       := StrZero(SZX->ZX_PARCELA,3)+'/'+StrZero(Val(Alltrim(SZT->ZT_ITEM)),3)
					Endif	        	  	    
		   	        SE2->E2_TIPO      := "FI"
   		  	        SE2->E2_NATUREZ   := SZT->ZT_NATURE
				    SE2->E2_FORNECE   := SZT->ZT_FORNEC
				    SE2->E2_LOJA      := SZT->ZT_LOJA
				    SE2->E2_NOMFOR    := _cNomFor
				    SE2->E2_EMISSAO   := dDataBase
				    SE2->E2_VENCTO    := SZX->ZX_VENCTO
				    SE2->E2_VENCREA   := SZX->ZX_VENCTO
				    SE2->E2_VENCORI   := SZX->ZX_VENCTO
				    SE2->E2_VALOR     := SZX->ZX_VLPAGO
				    SE2->E2_EMIS1     := dDataBase
				    SE2->E2_SALDO     := SZX->ZX_VLPAGO
				    SE2->E2_MOEDA     := 1
					SE2->E2_FATURA    := ""
				    SE2->E2_VLCRUZ    := SZX->ZX_VLPAGO
				    SE2->E2_ORIGEM    := "FINA050"
				    SE2->E2_CC        := SZT->ZT_CC
		 			SE2->E2_FLUXO     := "S"
					SE2->E2_FILORIG   := xFilial("SE2")
					SE2->E2_DESDOBR   := "N"
					SE2->E2_RATEIO    := "N"

                    _cDescTipo := ''
					If SX5->(DbSeek(xFilial("SX5")+"11"+SZT->ZT_TIPO)) // Tabela de Sub-Processo
                       _cDescTipo := Alltrim(SX5->X5_DESCRI)
                    Endif   
					SE2->E2_HIST      := _cDescTipo + ' CTRO: '+SZT->ZT_CONTRA
	 		        MsUnlock("SE2")
			      
					RecLock("SZX",.F.)
					SZX->ZX_DTPGTO := dDataBase
					SZX->ZX_FINAN  := dDataBase
					MsUnlock("SZX")
				Endif					

			Endif
			SZX->(Dbskip())
		
		Enddo
	Endif	

Return(lReturn)

