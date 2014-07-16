/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE079  ºAutor  ³Marcos R Roquitski  º Data ³  23/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera lancamento no SE2.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function Nhgpe079()
SetPrvt("aRotina,cCadastro,lEnd") 

lEnd := .T.

If MsgBox("Confirme Lancamento financeiro","Financeiro","YESNO")
   MsAguarde ( {|lEnd| fGeraFin()},"Aguarde","Gerando dados para o financeiro",.T.)	

Endif	

Return 


Static Function fGeraFin()
If MsgBox("Perido de lancamento: "+MesExtenso(Month(dDataBase)) + "/"+StrZero(Year(dDataBase),4),"Fechamento","YESNO")

	DbSelectArea("ZRA")
	ZRA->(DbGotop())
	While !ZRA->(Eof())

		MsProcTxt("Matricula: "+ZRA->ZRA_MAT + " " + ZRA->ZRA_NOME)

		// Pesquisao movimento do mes.
		ZRC->(DbSeek(xFilial("ZRC") + ZRA->ZRA_MAT))
		If ZRC->(Found())

			If !Empty(ZRC->ZRC_PREFIX) .AND. !Empty(ZRC->ZRC_NUMERO) .AND. ZRA->ZRA_SALARI > 0

				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2") + ZRA->ZRA_FORNEC + ZRA->ZRA_LOJA))
				If SA2->(Found())

					// Grava total da N. Fiscal
					DbSelectArea("SE2")
					DbSeek(xFilial("SE2")+ZRC->ZRC_PREFIX+ZRC->ZRC_NUMERO+" FOL"+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
					If !SE2->(Found())
						RecLock("SE2",.T.)
						SE2->E2_FILIAL    := xFilial("ZRA")
				        SE2->E2_PREFIXO   := ZRC->ZRC_PREFIX
				        SE2->E2_NUM       := ZRC->ZRC_NUMERO
				        SE2->E2_TIPO      := "NF"
				        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
				        SE2->E2_FORNECE   := ZRA->ZRA_FORNEC
				        SE2->E2_LOJA      := ZRA->ZRA_LOJA
				        SE2->E2_NOMFOR    := SA2->A2_NREDUZ
				        SE2->E2_EMISSAO   := ZRC->ZRC_EMISSA
				        SE2->E2_VENCTO    := ZRC->ZRC_VENCTO
				        SE2->E2_VENCREA   := ZRC->ZRC_VENCTO
				        SE2->E2_VENCORI   := ZRC->ZRC_VENCTO
				        SE2->E2_VALOR     := ZRA->ZRA_SALARI
				        SE2->E2_EMIS1     := ZRC->ZRC_EMISSA
				        SE2->E2_SALDO     := ZRA->ZRA_SALARI
				        SE2->E2_MOEDA     := 1
				        SE2->E2_FATURA    := ""
				        SE2->E2_VLCRUZ    := ZRA->ZRA_SALARI
				        SE2->E2_ORIGEM    := "NHGPE079"
				        SE2->E2_CC        := ZRA->ZRA_CCUSTO
						SE2->E2_FLUXO     := "S"
						SE2->E2_FILORIG   := xFilial("SE2")
						SE2->E2_DESDOBR   := "N"
						SE2->E2_RATEIO    := "N"
				        MsUnlock("SE2")
					Endif			        
                    
					nPar := 1
					// Grava imposto PIS
					ZRC->(DbSeek(xFilial("ZRC") +ZRA->ZRA_MAT + "501")) 
					If ZRC->(Found())
						DbSelectArea("SE2")
						DbSeek(xFilial("SE2")+ZRC->ZRC_PREFIX+ZRC->ZRC_NUMERO+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
						If !SE2->(Found())
							RecLock("SE2",.T.)
							SE2->E2_FILIAL    := xFilial("ZRA")
					        SE2->E2_PREFIXO   := ZRC->ZRC_PREFIX
					        SE2->E2_NUM       := ZRC->ZRC_NUMERO
					        SE2->E2_TIPO      := "TX"
					        SE2->E2_PARCELA   := StrZero(nPar,1)
					        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
					        SE2->E2_FORNECE   := "002285"
					        SE2->E2_LOJA      := ZRA->ZRA_LOJA
					        SE2->E2_NOMFOR    := "IMPOSTOS S/SERVICOS"
					        SE2->E2_EMISSAO   := ZRC->ZRC_EMISSA
					        SE2->E2_VENCTO    := ZRC->ZRC_VENCTO
					        SE2->E2_VENCREA   := ZRC->ZRC_VENCTO
					        SE2->E2_VENCORI   := ZRC->ZRC_VENCTO
					        SE2->E2_VALOR     := ZRC->ZRC_VALOR 
					        SE2->E2_EMIS1     := ZRC->ZRC_EMISSA
					        SE2->E2_SALDO     := ZRC->ZRC_VALOR
					        SE2->E2_MOEDA     := 1
					        SE2->E2_FATURA    := ""
					        SE2->E2_VLCRUZ    := ZRC->ZRC_VALOR
					        SE2->E2_ORIGEM    := "NHGPE079"
					        SE2->E2_CC        := ZRA->ZRA_CCUSTO
							SE2->E2_FLUXO     := "S"
							SE2->E2_FILORIG   := xFilial("SE2")
							SE2->E2_DESDOBR   := "N"
							SE2->E2_RATEIO    := "N"
							SE2->E2_CODRET    := "5952"
					        MsUnlock("SE2")
						Endif			        
					Endif	

					nPar++
					// Grava imposto COFINS
					ZRC->(DbSeek(xFilial("ZRC") +ZRA->ZRA_MAT + "502"))
					If ZRC->(Found())
						DbSelectArea("SE2")
						DbSeek(xFilial("SE2")+ZRC->ZRC_PREFIX+ZRC->ZRC_NUMERO+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
						If !SE2->(Found())
							RecLock("SE2",.T.)
							SE2->E2_FILIAL    := xFilial("ZRA")
					        SE2->E2_PREFIXO   := ZRC->ZRC_PREFIX
					        SE2->E2_NUM       := ZRC->ZRC_NUMERO
					        SE2->E2_TIPO      := "TX"
					        SE2->E2_PARCELA   := StrZero(nPar,1)
					        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
					        SE2->E2_FORNECE   := "002285"
					        SE2->E2_LOJA      := ZRA->ZRA_LOJA
					        SE2->E2_NOMFOR    := "IMPOSTOS S/SERVICOS"
					        SE2->E2_EMISSAO   := ZRC->ZRC_EMISSA
					        SE2->E2_VENCTO    := ZRC->ZRC_VENCTO
					        SE2->E2_VENCREA   := ZRC->ZRC_VENCTO
					        SE2->E2_VENCORI   := ZRC->ZRC_VENCTO
					        SE2->E2_VALOR     := ZRC->ZRC_VALOR 
					        SE2->E2_EMIS1     := ZRC->ZRC_EMISSA
					        SE2->E2_SALDO     := ZRC->ZRC_VALOR
					        SE2->E2_MOEDA     := 1
					        SE2->E2_FATURA    := ""
					        SE2->E2_VLCRUZ    := ZRC->ZRC_VALOR
					        SE2->E2_ORIGEM    := "NHGPE079"
					        SE2->E2_CC        := ZRA->ZRA_CCUSTO
							SE2->E2_FLUXO     := "S"
							SE2->E2_FILORIG   := xFilial("SE2")
							SE2->E2_DESDOBR   := "N"
							SE2->E2_RATEIO    := "N"
							SE2->E2_CODRET    := "5952"
					        MsUnlock("SE2")
						Endif			        
					Endif	
					nPar++

					// Grava imposto CSL
					ZRC->(DbSeek(xFilial("ZRC") +ZRA->ZRA_MAT + "503"))
					If ZRC->(Found())
						DbSelectArea("SE2")
						DbSeek(xFilial("SE2")+ZRC->ZRC_PREFIX+ZRC->ZRC_NUMERO+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
						If !SE2->(Found())
							RecLock("SE2",.T.)
							SE2->E2_FILIAL    := xFilial("ZRA")
					        SE2->E2_PREFIXO   := ZRC->ZRC_PREFIX
					        SE2->E2_NUM       := ZRC->ZRC_NUMERO
					        SE2->E2_TIPO      := "TX"
					        SE2->E2_PARCELA   := StrZero(nPar,1)
					        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
					        SE2->E2_FORNECE   := "002285"
					        SE2->E2_LOJA      := ZRA->ZRA_LOJA
					        SE2->E2_NOMFOR    := "IMPOSTOS S/SERVICOS"
					        SE2->E2_EMISSAO   := ZRC->ZRC_EMISSA
					        SE2->E2_VENCTO    := ZRC->ZRC_VENCTO
					        SE2->E2_VENCREA   := ZRC->ZRC_VENCTO
					        SE2->E2_VENCORI   := ZRC->ZRC_VENCTO
					        SE2->E2_VALOR     := ZRC->ZRC_VALOR 
					        SE2->E2_EMIS1     := ZRC->ZRC_EMISSA
					        SE2->E2_SALDO     := ZRC->ZRC_VALOR
					        SE2->E2_MOEDA     := 1
					        SE2->E2_FATURA    := ""
					        SE2->E2_VLCRUZ    := ZRC->ZRC_VALOR
					        SE2->E2_ORIGEM    := "NHGPE079"
					        SE2->E2_CC        := ZRA->ZRA_CCUSTO
							SE2->E2_FLUXO     := "S"
							SE2->E2_FILORIG   := xFilial("SE2")
							SE2->E2_DESDOBR   := "N"
							SE2->E2_RATEIO    := "N"
							SE2->E2_CODRET    := "5952"
					        MsUnlock("SE2")
						Endif			        
					Endif	
					nPar++


					// Grava imposto IR
					ZRC->(DbSeek(xFilial("ZRC") +ZRA->ZRA_MAT + "504"))
					If ZRC->(Found())
						DbSelectArea("SE2")
						DbSeek(xFilial("SE2")+ZRC->ZRC_PREFIX+ZRC->ZRC_NUMERO+StrZero(nPar,1)+"TX "+ZRA->ZRA_FORNEC+ZRA->ZRA_LOJA)
						If !SE2->(Found())
							RecLock("SE2",.T.)
							SE2->E2_FILIAL    := xFilial("ZRA")
					        SE2->E2_PREFIXO   := ZRC->ZRC_PREFIX
					        SE2->E2_NUM       := ZRC->ZRC_NUMERO
					        SE2->E2_TIPO      := "TX"
					        SE2->E2_PARCELA   := StrZero(nPar,1)
					        SE2->E2_NATUREZ   := SA2->A2_NATUREZ
					        SE2->E2_FORNECE   := "002285"
					        SE2->E2_LOJA      := ZRA->ZRA_LOJA
					        SE2->E2_NOMFOR    := "IMPOSTOS S/SERVICOS"
					        SE2->E2_EMISSAO   := ZRC->ZRC_EMISSA
					        SE2->E2_VENCTO    := ZRC->ZRC_VENCTO
					        SE2->E2_VENCREA   := ZRC->ZRC_VENCTO
					        SE2->E2_VENCORI   := ZRC->ZRC_VENCTO
					        SE2->E2_VALOR     := ZRC->ZRC_VALOR
					        SE2->E2_EMIS1     := ZRC->ZRC_EMISSA
					        SE2->E2_SALDO     := ZRC->ZRC_VALOR
					        SE2->E2_MOEDA     := 1
					        SE2->E2_FATURA    := ""
					        SE2->E2_VLCRUZ    := ZRC->ZRC_VALOR
					        SE2->E2_ORIGEM    := "NHGPE079"
					        SE2->E2_CC        := ZRA->ZRA_CCUSTO
							SE2->E2_FLUXO     := "S"
							SE2->E2_FILORIG   := xFilial("SE2")
							SE2->E2_DESDOBR   := "N"
							SE2->E2_RATEIO    := "N"
							SE2->E2_CODRET    := "5952"
					        MsUnlock("SE2")
						Endif			        
					Endif	
					nPar++

				Endif

			Endif

		Endif
		DbSelectArea("ZRA")	
		ZRA->(Dbskip())
			
	Enddo

Endif

Return
