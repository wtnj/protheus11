/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE147  บAutor  ณMarcos R. Roquitski บ Data ณ  16/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo PPR  Terceiros.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ WHB                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch"                                                                    
#include "protheus.ch"

User Function Nhgpe147()

SetPrvt("aRotina,cCadastro,")

aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fPprPar()",0,3} ,;
             {"Calcular","U_fPprCal()",0,4},;
             {"Email","U_Nhgpe148()",0,5},;
             {"Imprime Liquidos","U_Nhgpe149()",0,6},;
             {"Gera Liquidos","U_fPprLiq()",0,7} }

             
cCadastro := "Movimento mensal de Terceiros"

mBrowse(,,,,"ZRA",,"ZRA_FIM<>Ctod(Space(08))",)

Return


User Function fPprPar()

SetPrvt("aRotina,cCadastro,dDti,dDtf")

	aRotina := { {"Pesquisar","AxPesqui",0,1},;
	             {"Visualizar","AxVisual",0,2},;
	             {"Incluir","AxInclui",0,3},;
	             {"Alterar","AxAltera",0,4},;
	             {"Excluir","AxDeleta",0,5} }

	cCadastro := "Matricula: "+ZRA->ZRA_MAT + " " + Alltrim(ZRA->ZRA_NOME)

	DbSelectArea("ZRP")
	SET FILTER TO ZRP->ZRP_MAT == ZRA->ZRA_MAT
	ZRP->(DbGotop())

	mBrowse(,,,,"ZRP",,,)

	SET FILTER TO 
	ZRP->(DbGotop())

	DbSelectArea("ZRA")

Return(.T.)

                                                         
User Function fPprCal()
Local _cVb101  := .F.
Local _nTotpro := 0
Local _nTotdes := 0
Local _cPd     := Space(1)
Local _VlrRef  := 0
Local _nNu     := 0
Local _nTeto   := 0
Local _nMaior  := 0
Local _nRaSal  := 0




DbSelectArea("ZRP")
SET FILTER TO 
ZRP->(DbGotop())

ZRP->(DbSetOrder(1))

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


		// Gera PPR
		DbSelectArea("ZRP")
		ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT + "110"))
		If !ZRP->(Found())
			RecLock("ZRP",.T.)
			ZRP->ZRP_FILIAL := xFilial("ZRP")
			ZRP->ZRP_MAT    := ZRA->ZRA_MAT
			ZRP->ZRP_PD     := "110"
			ZRP->ZRP_DESCPD := "PPR"                 
			ZRP->ZRP_TIPO1  := "V"
			ZRP->ZRP_VALOR  := ZRA->ZRA_SALARI
			ZRP->ZRP_DATA   := dDataBase
			ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
			ZRP->ZRP_TIPO2  := "C"
			DbUnLock("ZRP")
			_nRaSal := ZRA->ZRA_SALARI
		Else
			_nRaSal := ZRP->ZRP_VALOR 
		Endif
		
		// Calculo dos impostos
		If  ZRA->ZRA_PERPIS > 0 // IR Verba: 501
			ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT + "501"))
			If !ZRP->(Found())                                                                              
				RecLock("ZRP",.T.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "501"
				ZRP->ZRP_DESCPD := "PIS"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERPIS)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"					
				DbUnLock("ZRP")
			Else
				RecLock("ZRP",.F.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "501"
				ZRP->ZRP_DESCPD := "PIS"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERPIS)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"					
				DbUnLock("ZRC")
			Endif
		Endif

		If	ZRA->ZRA_PERPIS > 0 // Confins Verba: 502
			ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT + "502"))
			If !ZRP->(Found())
				RecLock("ZRP",.T.)
				ZRP->ZRP_FILIAL := xFilial("ZRC")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "502"
				ZRP->ZRP_DESCPD := "COFINS"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERCOF)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"					
				DbUnLock("ZRP")
			Else
				RecLock("ZRP",.F.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "502"
				ZRP->ZRP_DESCPD := "COFINS"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERCOF)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"					
				DbUnLock("ZRP")
			Endif
		Endif

		If	ZRA->ZRA_PERCSL > 0 // CSL Verba: 503
			ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT + "503"))
			If !ZRP->(Found())
				RecLock("ZRP",.T.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "503"
				ZRP->ZRP_DESCPD := "CSL"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERCSL)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"					
				DbUnLock("ZRP")
			Else
				RecLock("ZRP",.F.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "503"
				ZRP->ZRP_DESCPD := "CSL"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERCSL)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"					
				DbUnLock("ZRC")
			Endif
		Endif

		If ZRA->ZRA_PERIRF > 0 // IR Verba: 504
			ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT + "504"))
			If !ZRP->(Found())
				RecLock("ZRP",.T.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "504"
				ZRP->ZRP_DESCPD := "I.R"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERIRF)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"
				DbUnLock("ZRP")
			Else
				RecLock("ZRP",.F.)
				ZRP->ZRP_FILIAL := xFilial("ZRP")
				ZRP->ZRP_MAT    := ZRA->ZRA_MAT
				ZRP->ZRP_PD     := "504"
				ZRP->ZRP_DESCPD := "I.R"
				ZRP->ZRP_TIPO1  := "V"
				ZRP->ZRP_VALOR  := ((_nRaSal * ZRA->ZRA_PERIRF)/100)
				ZRP->ZRP_DATA   := dDataBase
				ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
				ZRP->ZRP_TIPO2  := "C"
				DbUnLock("ZRC")
			Endif
        Endif

		_nTotpro := _nTotdes := 0
		// Totaliza Proventos/Descontos
		ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT))
		While !ZRP->(Eof()) .AND. ZRP->ZRP_MAT == ZRA->ZRA_MAT
			If ZRP->ZRP_PD == '799'
				ZRP->(DbSkip())
				Loop
			Endif	
		
			// Pesquisa verba 1 - Provento 2 - Desconto
			ZRV->(DbSeek(xFilial("ZRV") + ZRP->ZRP_PD))
			If ZRV->(Found())
				_cPd := ZRV->ZRV_TIPOCO
			Endif
			If _cPd == "1"
				_nTotpro += ZRP->ZRP_VALOR
			Elseif 	_cPd == "2"
				_nTotdes += ZRP->ZRP_VALOR
			Endif
			ZRP->(DbSkip())
		Enddo

		// Grava Liquido
		ZRP->(DbSeek(xFilial("ZRP") +ZRA->ZRA_MAT + "799"))
		If !ZRP->(Found())
			RecLock("ZRP",.T.)
			ZRP->ZRP_FILIAL := xFilial("ZRP")
			ZRP->ZRP_MAT    := ZRA->ZRA_MAT
			ZRP->ZRP_PD     := "799"
			ZRP->ZRP_DESCPD := "LIQUIDO A RECEBER"
			ZRP->ZRP_TIPO1  := "V"
			ZRP->ZRP_VALOR  :=(_nTotpro  - _nTotdes )
			ZRP->ZRP_DATA   := dDataBase
			ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
			ZRP->ZRP_TIPO2  := "C"
			DbUnLock("ZRP")
		Else
			RecLock("ZRP",.F.)
			ZRP->ZRP_FILIAL := xFilial("ZRP")
			ZRP->ZRP_MAT    := ZRA->ZRA_MAT
			ZRP->ZRP_PD     := "799"
			ZRP->ZRP_DESCPD := "LIQUIDO A RECEBER"
			ZRP->ZRP_TIPO1  := "V"
			ZRP->ZRP_VALOR  :=(_nTotpro  - _nTotdes)
			ZRP->ZRP_DATA   := dDataBase
			ZRP->ZRP_CC     := ZRA->ZRA_CCUSTO
			ZRP->ZRP_TIPO2  := "C"
			DbUnLock("ZRP")
		Endif
	    
		DbSelectArea("ZRA")
		ZRA->(DbSkip())

	Enddo                                                                                                    
                                                  
Endif

Return(.T.)


User Function fPprLiqA()

If MsgBox("Confirma geracao Liquido(s) PPR ?","Gera liquido(s)","YESNO")

	DbSelectArea("ZRP")
	ZRP->(DbGotop())
	While !ZRP->(Eof())
		If ZRP->ZRP_PD == '799'
			ZR1->(DbSeek(xFilial("ZR1") +ZRP->ZRP_MAT+DTOS(dDataBase)))
			If !ZR1->(Found())
				RecLock("ZR1",.T.)
				ZR1->ZR1_FILIAL := xFilial("ZRP")
				ZR1->ZR1_MAT    := ZRP->ZRP_MAT
				ZR1->ZR1_TIPO   := "5"    // 13o. 2a. Parcela.
				ZR1->ZR1_VALOR  := ZRP->ZRP_VALOR
				ZR1->ZR1_DATA   := dDataBase
				DbUnLock("ZR1")
			Endif
		Endif
		ZRP->(DbSkip())
	Enddo

Endif

Return(.t.)
		