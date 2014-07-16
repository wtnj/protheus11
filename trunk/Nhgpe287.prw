/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE287  ºAutor  ³Marcos R. Roquitski º Data ³  23/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza arquivo QAA.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhgpe287()

SetPrvt("lEnd")


If MsgBox("Confirme Atualizacao do Arquivo de Responsaveis","Responsaveis","YESNO")

	CTT->(DbSetOrder(1))
	SRJ->(DbSetOrder(1)) 
	ZRG->(DbSetOrder(1))

	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))

	MsAguarde ( {|lEnd| Processo() },"Aguarde","Atualizando dados...",.T.)


Endif

Return


Static Function Processo()
	DbSelectArea("SRA")
	SRA->(DbGotop())

	While !SRA->(Eof())  

		If SRA->RA_FILIAL <> xFilial("SRA")
			SRA->(DbSkip())
			Loop
		Endif

		MsProcTxt(SRA->RA_MAT+" "+SRA->RA_NOME)
	
		QAA->(Dbseek(xFilial("SRA") + SRA->RA_MAT+Space(4)))
		If !QAA->(Found())
			// Grava QAA
			RecLock("QAA",.T.)
			QAA->QAA_FILIAL  := xFilial("SRA")
			QAA->QAA_TPUSR   := "1"
			QAA->QAA_MAT     := SRA->RA_MAT
			QAA->QAA_NOME    := SRA->RA_NOME
			QAA->QAA_CC      := SRA->RA_CC
			QAA->QAA_CODFUN  := SRA->RA_CODFUNC
			QAA->QAA_INICIO  := SRA->RA_ADMISSAO
			QAA->QAA_FIM     := SRA->RA_DEMISSAO
			QAA->QAA_STATUS  := "1"
			QAA->QAA_RECMAI  := "2"
			QAA->QAA_TPMAIL  := "1"
			QAA->QAA_DISTSN  := "2"
			QAA->QAA_TPWORD  := "1"
			QAA->QAA_TPRCBT  := "1"
			MsUnLock("QAA")				
		Else
			RecLock("QAA",.F.)
			QAA->QAA_CC      := SRA->RA_CC
			QAA->QAA_CODFUN  := SRA->RA_CODFUNC
			MsUnLock("QAA")						
		Endif

		If SRA->RA_SITFOLH <> "D" 

			IF !ZRG->(DbSeek(xFilial("ZRG")+SRA->RA_MAT))
				RecLock("ZRG",.T.)
				ZRG->ZRG_FILIAL := xFilial("ZRG")
				ZRG->ZRG_MAT    := SRA->RA_MAT
				ZRG->ZRG_NOME   := SRA->RA_NOME

				CTT->(DbSeek(xFilial("CTT")+SRA->RA_CC))
				If CTT->(Found())
					ZRG->ZRG_DESC  := CTT->CTT_DESC01
				Endif	
				ZRG->ZRG_CC     := SRA->RA_CC
				ZRG->ZRG_ADMI   := SRA->RA_ADMISSA
				ZRG->ZRG_CODF   := SRA->RA_CODFUNC
				ZRG->ZRG_TURNO  := SRA->RA_TNOTRAB
				SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
				If SRJ->(Found())
					ZRG->ZRG_DESCF := SRJ->RJ_DESC
				Endif	
				MsUnLock("ZRG")
			Else      

				RecLock("ZRG",.F.)
				ZRG->ZRG_CC     := SRA->RA_CC
				ZRG->ZRG_ADMI   := SRA->RA_ADMISSA
				ZRG->ZRG_CODF   := SRA->RA_CODFUNC
				ZRG->ZRG_TURNO  := SRA->RA_TNOTRAB
				SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
				If SRJ->(Found())
					ZRG->ZRG_DESCF := SRJ->RJ_DESC
				Endif	

			    If SRA->RA_CC <> ZRG->ZRG_CC
					ZRG->ZRG_CCRH    := SRA->RA_CC
				Endif

				ZRG->ZRG_CODF   := SRA->RA_CODFUNC
				SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
				If SRJ->(Found())
					ZRG->ZRG_DESCF := SRJ->RJ_DESC
				Endif	
				MsUnLock("ZRG")
			Endif
		Else
			If SRA->RA_SITFOLH == "D" 
				ZRG->(DbSeek(xFilial("ZRG")+SRA->RA_MAT))
				If ZRG->(Found())
					RecLock("ZRG",.F.)
						ZRG->(DbDelete())	
					MsUnLock("ZRG")		
				Endif
			Endif	
		Endif

		DbSelectArea("SRA")		
		SRA->(DbSkip())


	Enddo
	SRA->(DbCommitAll())		

	DbSelectArea("SRJ")
	SRJ->(DbGotop())

	While !SRJ->(Eof())
		MsProcTxt(SRJ->RJ_FUNCAO+" "+SRJ->RJ_DESC)
		QAC->(Dbseek(xFilial("QAC") + SRJ->RJ_FUNCAO+Space(04)))
		If  QAC->(Found())
			// Atualiza QAC
			RecLock("QAC",.F.)
			QAC->QAC_DESC    := SRJ->RJ_DESC
			MsUnLock("QAC")
		Else
			// Grava QAC
			RecLock("QAC",.T.)
			QAC->QAC_FUNCAO  := SRJ->RJ_FUNCAO
			QAC->QAC_DESC    := SRJ->RJ_DESC
			MsUnLock("QAC")
		Endif

		DbSelectArea("SRJ")
		SRJ->(DbSkip())

	Enddo
	SRJ->(DbCommitAll())		
Return(nil)
