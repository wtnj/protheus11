/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE065  ºAutor  ³Marcos R. Roquitski º Data ³  18/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa valores de descontos de Farmacia.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe065()

SetPrvt("_cTipo, _cOrigem, _lSai, _aStruct, _cTr1, _cSituacao, lEnd")

lEnd      := .T.
cArqItau  := "C:\RELATO\Verbas_" + Substr(Dtos(dDataBase),5,4) + ".TXT" // 
cFnl      := CHR(13)+CHR(10)
nHdl      := fCreate(cArqItau)
lEnd      := .F.
_cOk      := .T.
_cOrigem  := Space(50)

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

If MsgYesNo("Confirma Importar valores de desconto ","Importa Verbas")
   MsAguarde ( {|lEnd| fCalcPpr() },"Aguarde","Importando",.T.)
Endif

TRB->(DbCloseArea())
FERASE(_cTr1 + ".DBF")

Return   


//
Static Function fCalcPpr()
      	
SRC->(DbSetOrder(1))
DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())

	If TRB->VALOR > 0
	

		If SRA->(DbSeek(xFilial("SRA")+TRB->MATR),Found())


			If Empty(SRA->RA_DEMISSAO)

		      
				* Grava no movimento mensal Desconto
				SRC->(DbSeek(SRA->RA_FILIAL+ SRA->RA_MAT+mv_par02,.t.))
				If SRC->RC_FILIAL==SRA->RA_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT .AND. SRC->RC_PD==mv_par02
					RecLock("SRC",.F.)
					If mv_par03 == "S"
						SRC->RC_VALOR += (TRB->VALOR/100)
					Else
						SRC->RC_VALOR := (TRB->VALOR/100)
					Endif					
					SRC->RC_DATA := mv_par01
					MsUnLock("SRC")
				Else
					RecLock("SRC",.T.)
					SRC->RC_FILIAL  := SRA->RA_FILIAL
					SRC->RC_MAT     := SRA->RA_MAT
					SRC->RC_PD      := mv_par02
					SRC->RC_TIPO1   := 'V'
					SRC->RC_VALOR   := (TRB->VALOR/100)
					SRC->RC_PARCELA := 0
					SRC->RC_CC      := SRA->RA_CC
					SRC->RC_TIPO2   := 'I'
					SRC->RC_DATA    := mv_par01
					MsUnLock("SRC")
				Endif   

				cLin := SRA->RA_MAT + "  "+SRA->RA_NOME+"  "
				cLin := cLin + Transform((TRB->VALOR/100),"@E 999,999,999.99") + "  I"
				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				_cOk := .T.
				

			Else

				cLin := SRA->RA_MAT + "  "+SRA->RA_NOME+"  "
				cLin := cLin + Transform(SRC->RC_VALOR,"@E 999,999,999.99") + "  *"
				cLin := cLin + cFnl
				fWrite(nHdl,cLin,Len(cLin))
				_cOk := .T.
			
			
			Endif

    	Endif

	Endif
    TRB->(DbSkip())

Enddo 
fClose(nHdl) 

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


