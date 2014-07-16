/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE114  ºAutor  ³Marcos R. Roquitski º Data ³  20/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao de Ferias.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhGpe114()

SetPrvt("_cArquivo,_aStruct,_cTr1,lEnd,_lSai,_cOrigem")

Pergunte("GPE114",.T.)

If !CopiaArq()
	Return
Endif

_cArquivo := _cOrigem
lEnd      := .T.

If !File(_cArquivo)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cArquivo,"Arquivo Retorno","INFO")
   Return
Endif

DbSelectArea("SRF")
DbSetorder(1)

// Arquivo a ser trabalhado
_aStruct:={{ "MATR","C",06,0} }

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cArquivo) SDF

If MsgYesNo("Confirma Importacao Programacao de Ferias","Ferias")
   MsAguarde ( {|lEnd| fImporta() },"Aguarde","Importando dados",.T.)
Endif
DbSelectArea("TRB")
DbCloseArea()

Ferase(_cTr1)
Return


Static Function fImporta()

DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())
	If SRF->(DbSeek(xFilial("SRF")+TRB->MATR),Found())
		MsProcTxt(SRF->RF_MAT)
		RecLock("SRF",.F.)
		SRF->RF_DATAINI := Mv_par01
		SRF->RF_DFEPRO1 := Mv_par02
		SRF->RF_DABPRO1 := Mv_PAR03
		MsUnlock("SRF")
	Endif
	TRB->(Dbskip())
Enddo

Return


Static Function CopiaArq()
_lSai     := .T.
_cOrigem  := Space(50)

@ 010,133 To 180,600 Dialog oDialogos Title "Copia arquivo..."

@ 021,005 Say "Origem" Size  15,8
@ 021,030 Get _cOrigem Size 130,8 When .F. 

@ 021,180 Button    "_Localizar" Size 36,16 Action Origem()
@ 060,070 BmpButton Type 2 Action fFecha()
@ 060,120 BmpButton Type 1 Action fConfArq()

Activate Dialog oDialogos CENTERED

Return(_lSai)


Static Function Origem()

	_cTipo :="Arquivo Tipo (*.TXT)       | *.TXT | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)     	 

Return
              
Static Function fFecha()
	Close(oDialogos)
	_lSai := .F.
Return
      
Static Function fConfArq()
	If Empty(_cOrigem)
		MsgBox("Arquivo para Processamento nao Informado","Atencao","INFO")
	Else
		Close(oDialogos)
		_lSai := .T.
	Endif
Return
