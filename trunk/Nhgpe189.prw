/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE189  ºAutor  ³Marcos R. Roquitski º Data ³  18/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa valores extras.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"  

User Function Nhgpe189()

SetPrvt("_cTipo, _cOrigem, _lSai, _aStruct, _cTr1, _cSituacao, lEnd")

_cOrigem  := Space(50)

//AjustaSX1()

If !Pergunte('GPE065',.T.)
   Return(nil)
Endif

fImpArq()

lEnd      := .T.

If !File(_cOrigem)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cOrigem,"Arquivo Retorno","INFO")
   Return
Endif

// Arquivo a ser trabalhado
_aStruct:={{ "MATR","C",06,0},;
          { "VALOR","N",12,2}}

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cOrigem) SDF

DbSelectArea("SRA")
DbSetorder(1)

If MsgYesNo("Confirma Importar valores EXTRAS","Importa Valores Extras")
   MsAguarde ( {|lEnd| fCalcPpr() },"Aguarde","Importando",.T.)
Endif

DbCloseArea("TRB")
FERASE(_cTr1 + ".DBF")

Return   


Static Function fCalcPpr()
      	
SR1->(DbSetOrder(1))
DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())

	If SRA->(DbSeek(xFilial("SRA")+TRB->MATR),Found())
		      
		* Grava no movimento mensal Desconto
		SR1->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+mv_par02,.t.))
		If SR1->R1_FILIAL==SRA->RA_FILIAL .AND. SR1->R1_MAT==SRA->RA_MAT .AND. SR1->R1_PD==mv_par02
			RecLock("SR1",.F.)
			If mv_par03 == "S"
				SR1->R1_VALOR += (TRB->VALOR/100)
			Else
				SR1->R1_VALOR := (TRB->VALOR/100)
			Endif					
			SR1->R1_DATA := mv_par01
			MsUnLock("SR1")
		Else
			RecLock("SR1",.T.)
			SR1->R1_FILIAL  := SRA->RA_FILIAL
			SR1->R1_MAT     := SRA->RA_MAT
			SR1->R1_PD      := mv_par02
			SR1->R1_TIPO1   := 'V'
			SR1->R1_VALOR   := (TRB->VALOR/100)
			SR1->R1_PARCELA := 0
			SR1->R1_CC      := SRA->RA_CC
			SR1->R1_TIPO2   := 'I'
			SR1->R1_DATA    := mv_par01
			MsUnLock("SR1")
		Endif

	Endif
    TRB->(DbSkip())

Enddo

Return




Static Function fImpArq()
_lSai     := .T.
_cOrigem  := Space(50)

@ 010,133 To 180,600 Dialog oDialogos Title "Importacao de Arquivo"

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
