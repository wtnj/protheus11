/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE077  ºAutor  ³Marcos R Roquitski  º Data ³  17/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fechamento de terceiros.                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

#include "rwmake.ch" 
#include "protheus.ch" 

User Function Nhgpe077() 

SetPrvt("aRotina,cCadastro,lEnd") 

lEnd      := .T.

If MsgBox("Confirme fechamento mensal ","Fechamento mensal","YESNO")
   MsAguarde ( {|lEnd| fFechaFolTer()},"Aguarde","Fechamento mensal",.T.)	

Endif	

Return 


Static Function fFechaFolTer()
Local lFer := .T.
If MsgBox("Perido de fechamento: "+MesExtenso(Month(dDataBase)) + "/"+StrZero(Year(dDataBase),4),"Fechamento","YESNO")
	
	DbSelectArea("ZRC")
	ZRC->(DbGotop())
	While !ZRC->(Eof())

		MsProcTxt("Matricula: "+ZRC->ZRC_MAT)

		RecLock("ZRD",.T.)
		ZRD->ZRD_FILIAL := xFilial("ZRD")
		ZRD->ZRD_MAT    := ZRC->ZRC_MAT
		ZRD->ZRD_NOME   := ZRC->ZRC_NOME
		ZRD->ZRD_PD     := ZRC->ZRC_PD
		ZRD->ZRD_DESCP  := ZRC->ZRC_DESCPD
		ZRD->ZRD_TIPO1  := ZRC->ZRC_TIPO1
		ZRD->ZRD_VALOR  := ZRC->ZRC_VALOR
		ZRD->ZRD_DATA   := ZRC->ZRC_DATA
		ZRD->ZRD_CC     := ZRC->ZRC_CC
		ZRD->ZRD_TIPO2  := ZRC->ZRC_TIPO2
		DbUnLock("ZRD")
		ZRC->(DbSkip())

	Enddo 

	DbSelectArea("ZRC")
	ZRC->(DbGotop())
	While !ZRC->(Eof())
		If ZRC->ZRC_PARCEL <= 0
			RecLock("ZRC",.F.)
			ZRC->(DbDelete())
			DbUnLock("ZRC")
		Endif
		ZRC->(DbSkip())
	Enddo

Endif

Return