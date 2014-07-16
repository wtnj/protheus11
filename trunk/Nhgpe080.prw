/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE080  บAutor  ณMarcos R Roquitski  บ Data ณ  17/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Acumulado mensal/ppr.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"                                                                    
#include "protheus.ch"


User Function Nhgpe080()

SetPrvt("aRotina,cCadastro")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Consulta","U_fAcumul()",0,4} }

cCadastro := "Movimento mensal de Terceiros"

DbSelectArea("ZRA")
mBrowse(,,,,"ZRA",,"ZRA_FIM<>Ctod(Space(08))",)

Return


User Function fAcumul()

Pergunte("NHGP80",.T.) //ativa os parametros

SetPrvt("aRotina,cCadastro,dDti,dDtf,cMesAno,cTipo")

	aRotina := { {"Pesquisar","AxPesqui",0,1},;
	             {"Visualizar","AxVisual",0,2},;
	             {"Alterar","AxAltera",0,3},;
	             {"Nota Fiscal","U_fBasFin2()",0,4} ,;
    	         {"Financeiro","U_GerFin2()",0,4} }

	cCadastro := "Matricula: "+ZRA->ZRA_MAT + " " + Alltrim(ZRA->ZRA_NOME)

	If mv_par03 == 2
		DbSelectArea("ZRD")
		ZRD->(DbSetOrder(1))		
		SET FILTER TO ZRD->ZRD_MAT == ZRA->ZRA_MAT .AND. SUBSTR(DTOS(ZRD->ZRD_DATA),1,6) = mv_par01 .AND. ZRD->ZRD_TIPO2 == "P"
		ZRD->(DbGotop())
	Else
		DbSelectArea("ZRD")
		ZRD->(DbSetOrder(1))		
		SET FILTER TO ZRD->ZRD_MAT == ZRA->ZRA_MAT .AND. SUBSTR(DTOS(ZRD->ZRD_DATA),1,6) = mv_par01  .AND. ZRD->ZRD_TIPO2 <> "P"
		ZRD->(DbGotop())
	Endif	

	mBrowse(,,,,"ZRD")

	SET FILTER TO
	ZRD->(DbGotop())

	DbSelectArea("ZRA")

Return(.T.)

                                                             

User Function fBasFin2()
	_cNumero  := Space(06)
	_cPrefixo := "RH "
	_dVencto  := dDataBase
	_dEmissao := dDataBase

	_cNumero  := ZRD->ZRD_NUMER
	_cPrefixo := ZRD->ZRD_PREFI
	_dVencto  := ZRD->ZRD_VENCT
	_dEmissao := ZRD->ZRD_EMISS
	
	If Empty(Alltrim(_cPrefixo))
		_cPrefixo := "RH "
	Endif
	
	@ 100,050 To 320,500 Dialog oDlg Title OemToAnsi("Financeiro")
    @ 005,005 To 090,222 PROMPT "Dados Nota Fiscal" OF oDlg  PIXEL
	@ 015,010 Say OemToAnsi("Prefixo ") Size 30,8 OF oDlg PIXEL
	@ 030,010 Say OemToAnsi("Nota Fiscal") Size 30,8 OF oDlg PIXEL
	@ 045,010 Say OemToAnsi("Emissao    ") Size 30,8 OF oDlg PIXEL
	@ 060,010 Say OemToAnsi("Vencimento ") Size 30,8 OF oDlg PIXEL

	@ 015,050 Get _cPrefixo  PICTURE "@!"  Size 15,8  OF oDlg PIXEL
	@ 030,050 Get _cNumero   PICTURE "@!"  Size 25,8  OF oDlg PIXEL
	@ 045,050 Get _dEmissao  PICTURE "99/99/99"  Size 45,8  OF oDlg PIXEL
	@ 060,050 Get _dVencto   PICTURE "99/99/99"  Size 45,8  OF oDlg PIXEL
        
	@ 095,155 BMPBUTTON TYPE 01 ACTION fGravaFin()
	@ 095,192 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg CENTERED

Return

Static Function fGravaFin()
	ZRD->(DbGotop())
	While !ZRD->(Eof()) .AND. ZRD->ZRD_MAT == ZRA->ZRA_MAT

		RecLock("ZRD",.F.)
		ZRD->ZRD_PREFI  := _cPrefixo      
		ZRD->ZRD_NUMER  := _cNumero
		ZRD->ZRD_EMISS  := _dEmissao
		ZRD->ZRD_VENCT  := _dVencto
		DbUnLock("ZRD")
		ZRD->(DbSkip())	

	Enddo
	Close(oDlg)

Return


User Function GerFin2()
Local _nIrrf := _nPis := _nCofins := _nCsll := 0
Local _cFornece := Space(06)
Local _cNomFor  := Space(30)
Local nPar := 1

If MsgBox("Confirme lancamento no Financeiro ?","Financeiro","YESNO")

	// Pesquisao movimento do mes.
	ZRD->(DbGotop())
	While !ZRD->(Eof())

			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2") + ZRA->ZRA_FORNEC + ZRA->ZRA_LOJA))
			If SA2->(Found())
                    
				If Alltrim(SM0->M0_CODIGO) == 'NH'
					_cFornece := "002285"
					_cNomFor  := "IMPOSTOS S/SERVICOS"
				Elseif Alltrim(SM0->M0_CODIGO) == 'FN'
					_cFornece := "UNIAO"
					_cNomFor  := "UNIAO"
				Endif

				// Grava imposto PIS
				If ZRD->ZRD_PD == "501"
					DbSelectArea("SE2")
					DbSeek(xFilial("SE2")+ZRD->ZRD_PREFI+ZRD->ZRD_NUMER+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
					If !SE2->(Found())
						RecLock("SE2",.T.)
						SE2->E2_FILIAL    := xFilial("ZRA")
				        SE2->E2_PREFIXO   := ZRD->ZRD_PREFI
				        SE2->E2_NUM       := ZRD->ZRD_NUMER
				        SE2->E2_TIPO      := "TX"
				        SE2->E2_PARCELA   := StrZero(nPar,1)
				        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
				        SE2->E2_FORNECE   := _cFornece
				        SE2->E2_LOJA      := ZRA->ZRA_LOJA
				        SE2->E2_NOMFOR    := _cNomFor
				        SE2->E2_EMISSAO   := ZRD->ZRD_EMISS
				        SE2->E2_VENCTO    := ZRD->ZRD_VENCT
				        SE2->E2_VENCREA   := ZRD->ZRD_VENCT
				        SE2->E2_VENCORI   := ZRD->ZRD_VENCT
				        SE2->E2_VALOR     := ZRD->ZRD_VALOR 
				        SE2->E2_EMIS1     := ZRD->ZRD_EMISS
				        SE2->E2_SALDO     := ZRD->ZRD_VALOR
				        SE2->E2_MOEDA     := 1
				        SE2->E2_FATURA    := ""
				        SE2->E2_VLCRUZ    := ZRD->ZRD_VALOR
				        SE2->E2_ORIGEM    := "NHGPE079"
				        SE2->E2_CC        := ZRA->ZRA_CCUSTO
						SE2->E2_FLUXO     := "S"
						SE2->E2_FILORIG   := xFilial("SE2")
						SE2->E2_DESDOBR   := "N"
						SE2->E2_RATEIO    := "N"
						SE2->E2_CODRET    := "5952"
						_nPis             := ZRD->ZRD_VALOR						
				        MsUnlock("SE2")
						nPar++
					Endif			        
				Endif	

				// Grava imposto COFINS
				If ZRD->ZRD_PD == "502"
					DbSelectArea("SE2")
					DbSeek(xFilial("SE2")+ZRD->ZRD_PREFI+ZRD->ZRD_NUMER+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
					If !SE2->(Found())
						RecLock("SE2",.T.)
						SE2->E2_FILIAL    := xFilial("ZRA")
				        SE2->E2_PREFIXO   := ZRD->ZRD_PREFI
				        SE2->E2_NUM       := ZRD->ZRD_NUMER
				        SE2->E2_TIPO      := "TX"
				        SE2->E2_PARCELA   := StrZero(nPar,1)
				        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
				        SE2->E2_FORNECE   := _cFornece
				        SE2->E2_LOJA      := ZRA->ZRA_LOJA
				        SE2->E2_NOMFOR    := _cNomFor
				        SE2->E2_EMISSAO   := ZRD->ZRD_EMISS
				        SE2->E2_VENCTO    := ZRD->ZRD_VENCT
				        SE2->E2_VENCREA   := ZRD->ZRD_VENCT
				        SE2->E2_VENCORI   := ZRD->ZRD_VENCT
				        SE2->E2_VALOR     := ZRD->ZRD_VALOR 
				        SE2->E2_EMIS1     := ZRD->ZRD_EMISS
				        SE2->E2_SALDO     := ZRD->ZRD_VALOR
				        SE2->E2_MOEDA     := 1
				        SE2->E2_FATURA    := ""
				        SE2->E2_VLCRUZ    := ZRD->ZRD_VALOR
				        SE2->E2_ORIGEM    := "NHGPE079"
				        SE2->E2_CC        := ZRA->ZRA_CCUSTO
						SE2->E2_FLUXO     := "S"
						SE2->E2_FILORIG   := xFilial("SE2")
						SE2->E2_DESDOBR   := "N"
						SE2->E2_RATEIO    := "N"
						SE2->E2_CODRET    := "5952"
						_nCofins          := ZRD->ZRD_VALOR												
				        MsUnlock("SE2")
						nPar++
					Endif			        
				Endif	

				// Grava imposto CSL
				If ZRD->ZRD_PD == "503"
					DbSelectArea("SE2")
					DbSeek(xFilial("SE2")+ZRD->ZRD_PREFI+ZRD->ZRD_NUMER+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
					If !SE2->(Found())
						RecLock("SE2",.T.)
						SE2->E2_FILIAL    := xFilial("ZRA")
				        SE2->E2_PREFIXO   := ZRD->ZRD_PREFI
				        SE2->E2_NUM       := ZRD->ZRD_NUMER
				        SE2->E2_TIPO      := "TX"
				        SE2->E2_PARCELA   := StrZero(nPar,1)
				        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
				        SE2->E2_FORNECE   := _cFornece
				        SE2->E2_LOJA      := ZRA->ZRA_LOJA
				        SE2->E2_NOMFOR    := _cNomFor
				        SE2->E2_EMISSAO   := ZRD->ZRD_EMISS
				        SE2->E2_VENCTO    := ZRD->ZRD_VENCT
				        SE2->E2_VENCREA   := ZRD->ZRD_VENCT
				        SE2->E2_VENCORI   := ZRD->ZRD_VENCT
				        SE2->E2_VALOR     := ZRD->ZRD_VALOR 
				        SE2->E2_EMIS1     := ZRD->ZRD_EMISS
				        SE2->E2_SALDO     := ZRD->ZRD_VALOR
				        SE2->E2_MOEDA     := 1
				        SE2->E2_FATURA    := ""
				        SE2->E2_VLCRUZ    := ZRD->ZRD_VALOR
				        SE2->E2_ORIGEM    := "NHGPE079"
				        SE2->E2_CC        := ZRA->ZRA_CCUSTO
						SE2->E2_FLUXO     := "S"
						SE2->E2_FILORIG   := xFilial("SE2")
						SE2->E2_DESDOBR   := "N"
						SE2->E2_RATEIO    := "N"
						SE2->E2_CODRET    := "5952"
						_nCsll            := ZRD->ZRD_VALOR						
				        MsUnlock("SE2")
						nPar++
					Endif			        
				Endif	

				// Grava imposto IR
				If ZRD->ZRD_PD == "504"
					DbSelectArea("SE2")
					DbSeek(xFilial("SE2")+ZRD->ZRD_PREFI+ZRD->ZRD_NUMER+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
					If !SE2->(Found())
						RecLock("SE2",.T.)
						SE2->E2_FILIAL    := xFilial("ZRA")
				        SE2->E2_PREFIXO   := ZRD->ZRD_PREFI
				        SE2->E2_NUM       := ZRD->ZRD_NUMER
				        SE2->E2_TIPO      := "TX"
				        SE2->E2_PARCELA   := StrZero(nPar,1)
				        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
				        SE2->E2_FORNECE   := _cFornece
				        SE2->E2_LOJA      := ZRA->ZRA_LOJA
				        SE2->E2_NOMFOR    := _cNomFor
				        SE2->E2_EMISSAO   := ZRD->ZRD_EMISS
				        SE2->E2_VENCTO    := ZRD->ZRD_VENCT
				        SE2->E2_VENCREA   := ZRD->ZRD_VENCT
				        SE2->E2_VENCORI   := ZRD->ZRD_VENCT
				        SE2->E2_VALOR     := ZRD->ZRD_VALOR
				        SE2->E2_EMIS1     := ZRD->ZRD_EMISS
				        SE2->E2_SALDO     := ZRD->ZRD_VALOR
				        SE2->E2_MOEDA     := 1
				        SE2->E2_FATURA    := ""
				        SE2->E2_VLCRUZ    := ZRD->ZRD_VALOR
				        SE2->E2_ORIGEM    := "NHGPE079"
				        SE2->E2_CC        := ZRA->ZRA_CCUSTO
						SE2->E2_FLUXO     := "S"
						SE2->E2_FILORIG   := xFilial("SE2")
						SE2->E2_DESDOBR   := "N"
						SE2->E2_RATEIO    := "N"
						SE2->E2_CODRET    := "5952"
						_nIrrf            := ZRD->ZRD_VALOR
				        MsUnlock("SE2")
						nPar++
					Endif			        
                Endif
                
				// Grava total da N. Fiscal
				// Grava imposto CSL
				If ZRD->ZRD_PD == "101"

					DbSelectArea("SE2")
					DbSeek(xFilial("SE2")+ZRD->ZRD_PREFI+ZRD->ZRD_NUMER+" FOL"+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
					If !SE2->(Found())
						RecLock("SE2",.T.)
						SE2->E2_FILIAL    := xFilial("ZRA")
				        SE2->E2_PREFIXO   := ZRD->ZRD_PREFI
				        SE2->E2_NUM       := ZRD->ZRD_NUMER
				        SE2->E2_TIPO      := "NF"
				        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
				        SE2->E2_FORNECE   := ZRA->ZRA_FORNEC
				        SE2->E2_LOJA      := ZRA->ZRA_LOJA
				        SE2->E2_NOMFOR    := SA2->A2_NREDUZ
				        SE2->E2_EMISSAO   := ZRD->ZRD_EMISS
				        SE2->E2_VENCTO    := ZRD->ZRD_VENCT
				        SE2->E2_VENCREA   := ZRD->ZRD_VENCT
				        SE2->E2_VENCORI   := ZRD->ZRD_VENCT
				        SE2->E2_VALOR     := (ZRD->ZRD_VALOR - _nIrrf - _nPis - _nCofins - _nCsll)
				        SE2->E2_EMIS1     := ZRD->ZRD_EMISS
				        SE2->E2_SALDO     := (ZRD->ZRD_VALOR - _nIrrf - _nPis - _nCofins - _nCsll)
				        SE2->E2_MOEDA     := 1
				        SE2->E2_FATURA    := ""
				        SE2->E2_VLCRUZ    := (ZRD->ZRD_VALOR - _nIrrf - _nPis - _nCofins - _nCsll)
				        SE2->E2_ORIGEM    := "NHGPE079"
				        SE2->E2_CC        := ZRA->ZRA_CCUSTO
						SE2->E2_FLUXO     := "S"
						SE2->E2_FILORIG   := xFilial("SE2")
						SE2->E2_DESDOBR   := "N"
						SE2->E2_RATEIO    := "N"
						SE2->E2_IRRF      := _nIrrf
						SE2->E2_PIS       := _nPis
						SE2->E2_COFINS    := _nCofins
						SE2->E2_CSLL      := _nCsll
				        MsUnlock("SE2")
					Endif			        
				Endif
				_nTotImp := _nIrrf := _nPis := _nCofins := _nCsll := 0					

			Endif

		ZRD->(DbSkip())

	Enddo
	Alert("Nota fiscal gravada com sucesso !")			
	
Endif

Return
