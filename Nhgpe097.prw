/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE097  บAutor  ณMarcos R. Roquitski บ Data ณ  14/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo 2a. Parcela 13o. Salario                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch"                                                                    
#include "protheus.ch"

User Function Nhgpe097()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_f132Par()",0,3} ,;
             {"Calcular","U_f132Cal()",0,4},;
             {"Email","U_Nhgpe145()",0,5},;
             {"Imprime Liquidos","U_Nhgpe146()",0,6},;
             {"Gera Liquidos","U_fLiq132A()",0,7} }

             
cCadastro := "Movimento mensal de Terceiros"

mBrowse(,,,,"ZRA",,"ZRA_FIM<>Ctod(Space(08))",)

Return


User Function f132Par()

SetPrvt("aRotina,cCadastro,dDti,dDtf")

	aRotina := { {"Pesquisar","AxPesqui",0,1},;
	             {"Visualizar","AxVisual",0,2},;
	             {"Incluir","AxInclui",0,3},;
	             {"Alterar","AxAltera",0,4},;
	             {"Excluir","AxDeleta",0,5} }

	cCadastro := "Matricula: "+ZRA->ZRA_MAT + " " + Alltrim(ZRA->ZRA_NOME)

	DbSelectArea("ZRF")
	SET FILTER TO ZRF->ZRF_MAT == ZRA->ZRA_MAT
	ZRF->(DbGotop())

	mBrowse(,,,,"ZRF",,,)

	SET FILTER TO 
	ZRF->(DbGotop())

	DbSelectArea("ZRA")

Return(.T.)

                                                             
User Function f132Cal()
Local _cVb101  := .F.
Local _nTotpro := 0
Local _nTotdes := 0
Local _cPd     := Space(1)
Local _VlrRef  := 0
Local _nNu     := 0
Local _nTeto   := 0
Local _nMaior  := 0
Local _nRaSal  := 0




DbSelectArea("ZRF")
SET FILTER TO 
ZRF->(DbGotop())

ZRF->(DbSetOrder(1))

DbSelectArea("SX1")
DbSetOrder(1)
SX1->(DbSeek("GPE074"))
While !SX1->(Eof()) .and. SX1->X1_GRUPO = "GPE074"
	If SX1->X1_ORDEM == '01'
		RecLock('SX1',.f.)
		SX1->X1_CNT01 := ZRA->ZRA_MAT
		MsUnLock('SX1')
	Endif	

	If SX1->X1_ORDEM == '02'
		RecLock('SX1',.f.)
		SX1->X1_CNT01 := ZRA->ZRA_MAT
		MsUnLock('SX1')
	Endif	
	SX1->(DbSkip())	
Enddo
    

If Pergunte("GPE074")

	DbSelectArea("ZRA")
	If !Empty(mv_par01)
		ZRA->(DbSeek(xFilial("ZRA") + mv_par01))
	Else
	    ZRA->(DbGotop())	
	Endif	

	While !ZRA->(Eof()) .AND. ZRA->ZRA_MAT >= mv_par01 .AND. ZRA->ZRA_MAT <= mv_par02


		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			ZRA->(DbSkip())
			Loop
		Endif


		_nAvos := 0
		If Year(ZRA->ZRA_INICIO) < Year(dDataBase)
			_nAvos := 12

		Elseif Day(ZRA->ZRA_INICIO) <= 15
			If Month(ZRA->ZRA_INICIO) == 12
				_nAvos := 1
			Else
				_nAvos := 13 - Month(ZRA->ZRA_INICIO)
            Endif
        Else
			If (Month(ZRA->ZRA_INICIO) + 1) >= 12
				_nAvos := 1
			Else	
				_nAvos := (13 - (Month(ZRA->ZRA_INICIO) + 1))
            Endif
		Endif        

		_nTotpro := _nTotdes := 0
		// Totaliza Proventos/Descontos
		ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT))
		While !ZRF->(Eof()) .AND. ZRF->ZRF_MAT == ZRA->ZRA_MAT
			If ZRF->ZRF_PD == '799' .or. ZRF->ZRF_PD == '146'
				ZRF->(DbSkip())
				Loop
			Endif	
		
			// Pesquisa verba 1 - Provento 2 - Desconto
			ZRV->(DbSeek(xFilial("ZRV") + ZRF->ZRF_PD))
			If ZRV->(Found())
				_cPd := ZRV->ZRV_TIPOCO
			Endif
			If _cPd == "1"
				_nTotpro += ZRF->ZRF_VALOR
			Elseif 	_cPd == "2"
				_nTotdes += ZRF->ZRF_VALOR
			Endif
			ZRF->(DbSkip())
		Enddo


		// Gera 2 Parcela 13. Salario
		If _nAvos > 0
             
        	If ZRA->ZRA_13CAL <> 'N'
				DbSelectArea("ZRF")
				ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "146"))
				If !ZRF->(Found())
					RecLock("ZRF",.T.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "146"
					ZRF->ZRF_DESCPD := "2. PARC. 13 SAL"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := (((ZRA->ZRA_SALARIO * _nAvos)/12))
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"
					DbUnLock("ZRF")
				Else
					RecLock("ZRF",.F.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "146"
					ZRF->ZRF_DESCPD := "2. PARC. 13 SAL"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := (((ZRA->ZRA_SALARIO * _nAvos)/12))
					ZRF->ZRF_DATA   := dDataBase                                                                   
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO				
					DbUnLock("ZRF")
				Endif
			Endif	
        	If ZRA->ZRA_13CAL <> 'N'
				_nRaSal := ((ZRA->ZRA_SALARIO * _nAvos)/12)
			Endif	
			_nRaSal += _nTotPro
		
			// Calculo dos impostos
			If  ZRA->ZRA_PERPIS > 0 // IR Verba: 501
				ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "501"))
				If !ZRF->(Found())                                                                              
					RecLock("ZRF",.T.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "501"
					ZRF->ZRF_DESCPD := "PIS"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERPIS)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"					
					DbUnLock("ZRF")
				Else
					RecLock("ZRF",.F.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "501"
					ZRF->ZRF_DESCPD := "PIS"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERPIS)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"					
					DbUnLock("ZRC")
				Endif
			Endif

			If	ZRA->ZRA_PERPIS > 0 // Confins Verba: 502
				ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "502"))
				If !ZRF->(Found())
					RecLock("ZRF",.T.)
					ZRF->ZRF_FILIAL := xFilial("ZRC")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "502"
					ZRF->ZRF_DESCPD := "COFINS"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERCOF)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"					
					DbUnLock("ZRF")
				Else
					RecLock("ZRF",.F.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "502"
					ZRF->ZRF_DESCPD := "COFINS"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERCOF)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"					
					DbUnLock("ZRF")
				Endif
			Endif

			If	ZRA->ZRA_PERCSL > 0 // CSL Verba: 503

				ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "503"))
				If !ZRF->(Found())
					RecLock("ZRF",.T.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "503"
					ZRF->ZRF_DESCPD := "CSL"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERCSL)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"					
					DbUnLock("ZRF")
				Else
					RecLock("ZRF",.F.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "503"
					ZRF->ZRF_DESCPD := "CSL"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERCSL)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"					
					DbUnLock("ZRC")
				Endif
			Endif

			If ZRA->ZRA_PERIRF > 0 // IR Verba: 504
				ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "504"))
				If !ZRF->(Found())
					RecLock("ZRF",.T.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "504"
					ZRF->ZRF_DESCPD := "I.R"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERIRF)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"
					DbUnLock("ZRF")
				Else
					RecLock("ZRF",.F.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "504"
					ZRF->ZRF_DESCPD := "I.R"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ((_nRaSal * ZRA->ZRA_PERIRF)/100)
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"
					DbUnLock("ZRC")
				Endif
	        Endif

			DbSelectArea("ZRE")
			ZRE->(DbSeek(xFilial("ZRE") +ZRA->ZRA_MAT + "144"))
			If ZRE->(Found())
				ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "512"))
				If !ZRF->(Found())
					RecLock("ZRF",.T.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "512"
					ZRF->ZRF_DESCPD := "1.PARC. 13 SAL"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ZRE->ZRE_VALOR
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"
					DbUnLock("ZRF")
				Else
					RecLock("ZRF",.F.)
					ZRF->ZRF_FILIAL := xFilial("ZRF")
					ZRF->ZRF_MAT    := ZRA->ZRA_MAT
					ZRF->ZRF_PD     := "512"
					ZRF->ZRF_DESCPD := "1.PARC. 13 SAL"
					ZRF->ZRF_TIPO1  := "V"
					ZRF->ZRF_VALOR  := ZRE->ZRE_VALOR
					ZRF->ZRF_DATA   := dDataBase
					ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
					ZRF->ZRF_TIPO2  := "C"
					DbUnLock("ZRC")
				Endif
	        Endif

			_nTotpro := _nTotdes := 0
			// Totaliza Proventos/Descontos
			ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT))
			While !ZRF->(Eof()) .AND. ZRF->ZRF_MAT == ZRA->ZRA_MAT
				If ZRF->ZRF_PD == '799'
					ZRF->(DbSkip())
					Loop
				Endif	
		
				// Pesquisa verba 1 - Provento 2 - Desconto
				ZRV->(DbSeek(xFilial("ZRV") + ZRF->ZRF_PD))
				If ZRV->(Found())
					_cPd := ZRV->ZRV_TIPOCO
				Endif
				If _cPd == "1"
					_nTotpro += ZRF->ZRF_VALOR
				Elseif 	_cPd == "2"
					_nTotdes += ZRF->ZRF_VALOR
				Endif
				ZRF->(DbSkip())
			Enddo

			// Grava Liquido
			ZRF->(DbSeek(xFilial("ZRF") +ZRA->ZRA_MAT + "799"))
			If !ZRF->(Found())
				RecLock("ZRF",.T.)
				ZRF->ZRF_FILIAL := xFilial("ZRC")
				ZRF->ZRF_MAT    := ZRA->ZRA_MAT
				ZRF->ZRF_PD     := "799"
				ZRF->ZRF_DESCPD := "LIQUIDO A RECEBER"
				ZRF->ZRF_TIPO1  := "V"
				ZRF->ZRF_VALOR  :=(_nTotpro  - _nTotdes )
				ZRF->ZRF_DATA   := dDataBase
				ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
				ZRF->ZRF_TIPO2  := "C"
				DbUnLock("ZRF")
			Else
				RecLock("ZRF",.F.)
				ZRF->ZRF_FILIAL := xFilial("ZRF")
				ZRF->ZRF_MAT    := ZRA->ZRA_MAT
				ZRF->ZRF_PD     := "799"
				ZRF->ZRF_DESCPD := "LIQUIDO A RECEBER"
				ZRF->ZRF_TIPO1  := "V"
				ZRF->ZRF_VALOR  :=(_nTotpro  - _nTotdes)
				ZRF->ZRF_DATA   := dDataBase
				ZRF->ZRF_CC     := ZRA->ZRA_CCUSTO
				ZRF->ZRF_TIPO2  := "C"
				DbUnLock("ZRF")
			Endif
	    
	    Endif
		DbSelectArea("ZRA")
		ZRA->(DbSkip())

	Enddo                                                                                                    
                                                  
Endif

Return(.T.)


User Function fLiq132A()

If MsgBox("Confirma geracao Liquido(s) 13a. 2a. Parcela?","Gera liquido(s)","YESNO")

	DbSelectArea("ZRF")
	ZRF->(DbGotop())
	While !ZRF->(Eof())
		If ZRF->ZRF_PD == '799'
			ZR1->(DbSeek(xFilial("ZR1") +ZRF->ZRF_MAT+DTOS(dDataBase)))
			If !ZR1->(Found())
				RecLock("ZR1",.T.)
				ZR1->ZR1_FILIAL := xFilial("ZRF")
				ZR1->ZR1_MAT    := ZRF->ZRF_MAT
				ZR1->ZR1_TIPO   := "5"    // 13o. 2a. Parcela.
				ZR1->ZR1_VALOR  := ZRF->ZRF_VALOR
				ZR1->ZR1_DATA   := dDataBase
				DbUnLock("ZR1")
			Endif
		Endif
		ZRF->(DbSkip())
	Enddo

Endif

Return(.t.)

