/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHGPE095  บAutor  ณMarcos R Roquitski  บ Data ณ  25/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo 13. Salario de terceiros                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "rwmake.ch" 
#include "protheus.ch" 

User Function Nhgpe095()

SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","U_fMov13()",0,3} ,;
             {"Calcula 1a. Parcela","U_fcal1prc()",0,4} ,;
             {"Email de Pagto","U_Nhgpe143()",0,5},;
             {"Imprime Liquido","U_Nhgpe144()",0,6},;
             {"Gera Liquido","U_fLiq131A()",0,7} }
                                                    
cCadastro := "Movimento mensal de terceiros 13o. Salario

mBrowse(,,,,"ZRA",,"ZRA_FIM<>Ctod(Space(08))",)

Return


User Function fMov13()

SetPrvt("aRotina,cCadastro,dDti,dDtf")

	aRotina := { {"Pesquisar","AxPesqui",0,1},;
	             {"Visualizar","AxVisual",0,2},;
	             {"Incluir","AxInclui",0,3},;
	             {"Alterar","AxAltera",0,4},;
	             {"Excluir","AxDeleta",0,5} }

	cCadastro := "Matricula: "+ZRA->ZRA_MAT + " " + Alltrim(ZRA->ZRA_NOME)

	DbSelectArea("ZRE")
	SET FILTER TO ZRE->ZRE_MAT == ZRA->ZRA_MAT 
	//Substr(DTOS(ZRC->ZRC_DATA),5,2)+Substr(DTOS(ZRC->ZRC_DATA),1,4) >= mv_par01 .AND. Substr(DTOS(ZRC->ZRC_DATA),5,2)+Substr(DTOS(ZRC->ZRC_DATA),1,4) <= mv_par02)
	ZRE->(DbGotop())

	mBrowse(,,,,"ZRE",,,)

	SET FILTER TO
	ZRE->(DbGotop())

	DbSelectArea("ZRA")

Return(.T.)

                                                             
User Function fcriazre()

SetPrvt("aRotina,cCadastro,dDti,dDtf")

	aRotina := { {"Pesquisar","AxPesqui",0,1},;
	             {"Visualizar","AxVisual",0,2},;
	             {"Incluir","AxInclui",0,3},;
	             {"Alterar","AxAltera",0,4},;
	             {"Excluir","AxDeleta",0,5} }

	DbSelectArea("ZRE")
	mBrowse(,,,,"ZRE",,,)

	DbSelectArea("ZRA")

Return(.T.)


User Function fCal1Prc()
Local _cVb101  := .F.
Local _nTotpro := 0
Local _nTotdes := 0
Local _cPd     := Space(1)
Local _VlrRef  := 0
Local _nNu     := 0
Local _nTeto   := 0
Local _nMaior  := 0
Local _nRaSal  := 0
Local _nAvos   := 0

ZRE->(DbSetOrder(1))

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

		If ZRA->ZRA_13CAL == 'N'
			ZRA->(DbSkip())
			Loop
		Endif

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
				_nAvos := 0
			Else	
				_nAvos := (13 - (Month(ZRA->ZRA_INICIO) + 1))
            Endif
		Endif        

		// Gera 1 Parcela 13. Salario
		If _nAvos > 0
			DbSelectArea("ZRE")
			ZRE->(DbSeek(xFilial("ZRE") +ZRA->ZRA_MAT + "144"))
			If !ZRE->(Found())
				RecLock("ZRE",.T.)
				ZRE->ZRE_FILIAL := xFilial("ZRE")
				ZRE->ZRE_MAT    := ZRA->ZRA_MAT
				ZRE->ZRE_PD     := "144"
				ZRE->ZRE_DESCPD := "1. PARC. 13 SAL"
				ZRE->ZRE_TIPO1  := "V"
				ZRE->ZRE_VALOR  := (((ZRA->ZRA_SALARIO * _nAvos)/12)/2)
				ZRE->ZRE_DATA   := dDataBase
				ZRE->ZRE_CC     := ZRA->ZRA_CCUSTO
				ZRE->ZRE_TIPO2  := "C"
				DbUnLock("ZRE")
			Else
				RecLock("ZRE",.F.)
				ZRE->ZRE_VALOR  := (((ZRA->ZRA_SALARIO * _nAvos)/12)/2)
				ZRE->ZRE_DATA   := dDataBase
				DbUnLock("ZRE")
			Endif

			_nTotpro := _nTotdes := 0
			// Totaliza Proventos/Descontos
			
			ZRE->(DbSeek(xFilial("ZRE") +ZRA->ZRA_MAT))
			While !ZRE->(Eof()) .AND. ZRE->ZRE_MAT == ZRA->ZRA_MAT
				If ZRE->ZRE_PD == '799'
					ZRE->(DbSkip())
					Loop
				Endif
				// Pesquisa verba 1 - Provento 2 - Desconto				
				ZRV->(DbSeek(xFilial("ZRV") + ZRE->ZRE_PD))
				If ZRV->(Found())
					_cPd := ZRV->ZRV_TIPOCO
				Endif
				If _cPd == "1"
					_nTotpro += ZRE->ZRE_VALOR
				Elseif 	_cPd == "2"
					_nTotdes += ZRE->ZRE_VALOR
				Endif
				ZRE->(DbSkip())
			Enddo
			
			// Grava Liquido
			ZRE->(DbSeek(xFilial("ZRE") +ZRA->ZRA_MAT + "799"))
			If !ZRE->(Found())
				RecLock("ZRE",.T.)
				ZRE->ZRE_FILIAL := xFilial("ZRE")
				ZRE->ZRE_MAT    := ZRA->ZRA_MAT
				ZRE->ZRE_PD     := "799"
				ZRE->ZRE_DESCPD := "LIQUIDO A RECEBER"
				ZRE->ZRE_TIPO1  := "V"
				ZRE->ZRE_VALOR  :=(_nTotpro  - _nTotdes)
				ZRE->ZRE_DATA   := dDataBase
				ZRE->ZRE_CC     := ZRA->ZRA_CCUSTO
				ZRE->ZRE_TIPO2  := "C"
				DbUnLock("ZRE")
			Else
				RecLock("ZRE",.F.)
				ZRE->ZRE_FILIAL := xFilial("ZRE")
				ZRE->ZRE_MAT    := ZRA->ZRA_MAT
				ZRE->ZRE_PD     := "799"
				ZRE->ZRE_DESCPD := "LIQUIDO A RECEBER"
				ZRE->ZRE_TIPO1  := "V"
				ZRE->ZRE_VALOR  :=(_nTotpro  - _nTotdes)
				ZRE->ZRE_DATA   := dDataBase
				ZRE->ZRE_CC     := ZRA->ZRA_CCUSTO
				ZRE->ZRE_TIPO2  := "C"
				DbUnLock("ZRE")
			Endif
		Endif
		DbSelectArea("ZRA")
		ZRA->(DbSkip())
	Enddo                                                                                                    
                                                   
Endif

Return(.T.)


User Function fLiq131A()

If MsgBox("Confirma geracao Liquido(s) 13a. 1a. Parcela?","Gera liquido(s)","YESNO")

	DbSelectArea("ZRE")
	ZRE->(DbGotop())
	While !ZRE->(Eof())
		If ZRE->ZRE_PD == '799'
			ZR1->(DbSeek(xFilial("ZR1") +ZRE->ZRE_MAT+DTOS(dDataBase)))
			If !ZR1->(Found())
				RecLock("ZR1",.T.)
				ZR1->ZR1_FILIAL := xFilial("ZRE")
				ZR1->ZR1_MAT    := ZRE->ZRE_MAT
				ZR1->ZR1_TIPO   := "4"    // 13o. 1a. Parcela.
				ZR1->ZR1_VALOR  := ZRE->ZRE_VALOR
				ZR1->ZR1_DATA   := dDataBase
				DbUnLock("ZR1")
			Endif
		Endif
		ZRE->(DbSkip())
	Enddo
Endif

Return(.t.)
