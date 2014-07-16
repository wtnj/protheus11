/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE084  ºAutor  ³Marcos R Roquitski  º Data ³  17/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Provisao de Ferias.                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

#include "rwmake.ch" 
#include "protheus.ch" 

User Function Nhgpe084() 

SetPrvt("aRotina,cCadastro,lEnd") 

lEnd      := .T.

If MsgBox("Confirme calculo de Provisao de Ferias","Provisao de Ferias","YESNO")
   MsAguarde ( {|lEnd| fCalcProv()},"Aguarde","Provisao de Ferias",.T.)	

Endif	

Return 


Static Function fCalcProv()
Local lFer := .T.

If MsgBox("Perido de provisaoo: "+MesExtenso(Month(dDataBase)) + "/"+StrZero(Year(dDataBase),4),"Provisao","YESNO")
	
	DbSelectArea("ZRA")
	ZRA->(DbGotop())
	While !ZRA->(Eof())

		If !Empty(Alltrim(ZRA->ZRA_SITFOLH))
			ZRA->(DbSkip())
			Loop
		Endif	

		ZRH->(DbSeek(xFilial("ZRH") +ZRA->ZRA_MAT))
		While ZRH->ZRH_MAT == ZRA->ZRA_MAT

			If ZRH->ZRH_DFERVE < 30
				RecLock("ZRH",.F.)
				ZRH->ZRH_DFERVE += 2.5
				DbUnLock("ZRH")
			    lFer := .F.
			Endif		

			ZRH->(Dbskip())

		Enddo

		If lFer
			RecLock("ZRH",.T.)
			ZRH->ZRH_FILIAL := xFilial("ZRH")
			ZRH->ZRH_MAT    :=	ZRA->ZRA_MAT		
			ZRH->ZRH_NOME   :=	ZRA->ZRA_NOME		
			ZRH->ZRH_SALMES :=	ZRA->ZRA_SALARI		
			ZRH->ZRH_SALDIA :=	ZRA->ZRA_SALARI/30		
			ZRH->ZRH_SALHRS :=	ZRA->ZRA_SALARI/205		
			ZRH->ZRH_DATABA :=	Ctod(StrZero(Day(ZRA->ZRA_INICIO),2)+"/"+StrZero(Month(ZRA->ZRA_INICIO),2)+"/"+Strzero(Year(dDataBase),4))
			ZRH->ZRH_DBASEA :=	Ctod(StrZero(Day(ZRA->ZRA_INICIO),2)+"/"+StrZero(Month(ZRA->ZRA_INICIO),2)+"/"+Strzero(Year(dDataBase)+1,4))
			ZRH->ZRH_DFERVE :=	2.5				
			ZRH->ZRH_ADMISS :=  ZRA->ZRA_INICIO
			DbUnLock("ZRH")
		Endif
		
		DbSelectArea("ZRA")		
		ZRA->(DbSkip())
	    lFer := .T.

	Enddo

Endif

Return
	