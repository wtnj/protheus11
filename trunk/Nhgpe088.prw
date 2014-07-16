/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE088  ºAutor  ³Marcos R Roquitski  º Data ³  18/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa saldos de vale transportes.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhGpe088()

SetPrvt("_cOrigem,_aStruct,_cTr1,lEnd")

_cArquivo := "VTURBS.TXT"
lEnd      := .T.

fImpArq()

If !File(_cOrigem)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cOrigem,"Arquivo Retorno","INFO")
   Return
Endif


DbSelectArea("SRA")
DbSetorder(1)

// Arquivo a ser trabalhado
_aStruct := {{"LINHA","C",50,0}}
           
_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cOrigem) SDF

If MsgYesNo("Importa saldo de vale transporte","Transporte")
   MsAguarde ( {|lEnd| fImporta() },"Aguarde","Importando dados",.T.)
Endif
DbSelectArea("TRB")
DbCloseArea()

Ferase(_cTr1)
Return


Static Function fImporta()
Local _nVuniatu := 0

SR0->(DbSetOrder(1))
SR0->(DbGotop())
While !SR0->(Eof())
	RecLock("SR0",.F.)
	SR0->R0_QDIAINF := 0
	SR0->R0_QDIACAL := 0
	SR0->R0_VALCAL  := 0
	SR0->R0_DIASPRO := 0
	MsUnlock("SR0")
	SR0->(DbSkip())
Enddo	


SRN->(DbSetOrder(1))

DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())
	If SRA->(DbSeek(xFilial("SRA")+Substr(TRB->LINHA,1,6)),Found())

		MsProcTxt(SRA->RA_MAT+" "+Substr(SRA->RA_NOME,1,30))

		If SRN->(DbSeek(xFilial("SRN")+Substr(TRB->LINHA,12,2)),Found())
			_nVuniatu := SRN->RN_VUNIATU
		Endif

		If SR0->(DbSeek(xFilial("SRA")+Substr(TRB->LINHA,1,6)+Substr(TRB->LINHA,12,2)),Found()) // Movimento Vale transporte
			RecLock("SR0",.F.)
			SR0->R0_QDIAINF := IIF( Val(Substr(TRB->LINHA,8,3)) > 50,4,2)
			SR0->R0_QDIACAL := Val(Substr(TRB->LINHA,8,3))
			SR0->R0_VALCAL  := Val(Substr(TRB->LINHA,8,3)) * _nVuniatu
			MsUnlock("SR0")
		Else
			RecLock("SR0",.T.)
			SR0->R0_FILIAL  := xFilial("SR0")
			SR0->R0_MAT     := SRA->RA_MAT
			SR0->R0_MEIO    := Substr(TRB->LINHA,12,2)
			SR0->R0_DIASPRO := 0
			SR0->R0_QDIAINF := IIF( Val(Substr(TRB->LINHA,8,3)) > 50,4,2)
			SR0->R0_QDIACAL := Val(Substr(TRB->LINHA,8,3))		
			SR0->R0_VALCAL  := Val(Substr(TRB->LINHA,8,3)) * _nVuniatu
			SR0->R0_QDIADIF := 0
			SR0->R0_VALDIF  := 0						
			SR0->R0_CC      := SRA->RA_CC
			SR0->R0_SALBASE := SRA->RA_SALARIO
			SR0->R0_QDNUTIL := 0
			MsUnlock("SR0")
		
		Endif
			_nVuniatu := 0
	Endif

	TRB->(Dbskip())
Enddo

Return 

Static Function fImpArq()
_lSai     := .T.
_cOrigem  := Space(50)

@ 010,133 To 180,600 Dialog oDialogos Title "Importacao de Arquivo URBS"

@ 021,005 Say "Origem" Size  15,8
@ 021,030 Get _cOrigem Size 130,8 When .F. 

@ 021,180 Button    "_Localizar" Size 36,16 Action Origem()
@ 060,070 BmpButton Type 2 Action fFecha()
@ 060,120 BmpButton Type 1 Action fConfArq()

Activate Dialog oDialogos CENTERED

Return(.t.)


Static Function Origem()
	_cTipo :="Arquivo Tipo (*.TXT)       | *.TXT | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)     	 
Return


Static Function fFecha()
	Close(oDialogos)
Return

      
Static Function fConfArq()
	If Empty(_cOrigem)
		MsgBox("Arquivo para Processamento nao Informado","Atencao","INFO")
	Else
		Close(oDialogos)
	Endif
Return
