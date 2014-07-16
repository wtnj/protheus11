/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE056  ºAutor  ³Marcos R. Roquitski º Data ³  26/04/04   º±±
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

User Function Nhgpe056()

SetPrvt("lEnd")


If MsgBox("Confirme Atualizacao do Arquivo de Responsaveis","Responsaveis","YESNO")

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
