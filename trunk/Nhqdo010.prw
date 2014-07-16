/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHQD010   ºAutor  ³Marcos R. Roquitski º Data ³  22/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao da tabela SX5.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NhQdo010()
	SetPrvt("lEnd,cSeq,cQdh,cDoc")
	If MsgBox("Confirme atualizacao da tabela QDH","Sequencial","YESNO")
		MsAguarde ( {|lEnd| fProcQdh() },"Processando","Aguarde...",.T.)
   Endif
Return nil


Static Function fProcQdh()
	DbSelectArea("QDH")
	QDH->(DbsetOrder(1))
	QDH->(DbGotop())
	While !Eof()
		MsProcTxt("Documento: "+QDH->QDH_DOCTO)
		cQdh := Substr(QDH->QDH_DOCTO,1,4)
		cDoc := QDH->QDH_DOCTO
		cSeq := Substr(QDH->QDH_DOCTO,5,6)
		QDH->(DbSkip())
		If Substr(QDH->QDH_DOCTO,1,4) <> cQdh
			fGrava()
		Endif
	Enddo
Return Nil


Static Function fGrava()
	DbSelectArea("SX5")
   RecLock("SX5",.T.)
   SX5->X5_TABELA  := "ZF"
   SX5->X5_CHAVE   := cDoc
	SX5->X5_DESCRI  := cSeq
	SX5->X5_DESCSPA := cSeq
	SX5->X5_DESCENG := cSeq
   MsUnlock("SX5")
	DbSelectArea("QDH")
Return

