/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE213  ºAutor  ³Marcos R. Roquitski º Data ³  01/06/2012 º±±
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

User Function NhGpe213() 

SetPrvt("_cOrigem,_aStruct,_cTr1,lEnd")
SetPrvt("nHdl,cLin,cFnl,_cOrigem,lEnd,_cOk")

_cOrigem := ''
lEnd     := .T.
cArqItau := "C:\RELATO\EXTRA" + Substr(Dtos(dDataBase),5,4) + ".TXT" // 
cFnl     := CHR(13)+CHR(10)
nHdl     := fCreate(cArqItau)
lEnd     := .F.
_cOk     := .T.

fImpArq()

If !File(_cOrigem)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cOrigem,"Arquivo Retorno","INFO")
   Return
Endif
// Arquivo a ser trabalhado
_aStruct:={{ "LINHA","C",50,0}}

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cOrigem) SDF


If MsgYesNo("Confirma Importacao  ","Valores")
   MsAguarde ( {|lEnd| fImporta() },"Aguarde","Importando dados",.T.)
Endif


DbCloseArea("TRB")
Ferase(_cTr1)

Return


Static Function fImporta()
Local _Descpr := Space(30)

SRA->(DbSetOrder(1))

DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())

	_cOk := .F.
	
	If SRA->(DbSeek(xFilial("SRA")+Substr(TRB->LINHA,1,6)))
	
		MsProcTxt(SRA->RA_MAT + " "+Substr(SRA->RA_NOME,1,30))
		
		If !SR1->(DbSeek(xFilial("SR1")+SRA->RA_MAT + "138",Found()))
			// Movimento mensal - Provento
			DbSelectArea("SR1")
			RecLock("SR1",.T.)
			SR1->R1_FILIAL  := xFilial("SR1")
			SR1->R1_MAT     := SRA->RA_MAT
			SR1->R1_PD      := "138"
			SR1->R1_TIPO1   := "V"
			SR1->R1_HORAS   := 0
			SR1->R1_VALOR   := Val(Substr(TRB->LINHA,7,12))
			SR1->R1_DATA    := dDataBase
			SR1->R1_CC      := SRA->RA_CC  
			SR1->R1_TIPO2   := "I"
			MsUnlock("SR1")

			cLin := SRA->RA_MAT + "  "+SRA->RA_CIC+"  "+SRA->RA_NOME+"  "
			cLin := cLin + Transform((Val(Alltrim(Substr(TRB->LINHA,145,8)))/100),"@E 999,999,999.99") + "  I"
			cLin := cLin + cFnl
			fWrite(nHdl,cLin,Len(cLin))
			_cOk := .T.

		Else
	
			// Movimento mensal - Provento
			DbSelectArea("SR1")
			RecLock("SR1",.F.)
			SRC->RC_VALOR   += Val(Substr(TRB->LINHA,7,12))
			MsUnlock("SR1")
				
			cLin := SRA->RA_MAT + "  "+SRA->RA_CIC+"  "+SRA->RA_NOME+"  "
			cLin := cLin + Transform((Val(Alltrim(Substr(TRB->LINHA,145,8)))/100),"@E 999,999,999.99") + "  I"
			cLin := cLin + cFnl
			fWrite(nHdl,cLin,Len(cLin))
			_cOk := .T.

   		Endif

	Endif		
	If !_cOk 
		cLin := "***"+Substr(TRB->LINHA,52,11)+" "+Substr(TRB->LINHA,1,6)+ "  X"
		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))
	Endif
	_cOk := .F.
		
	DbSelectArea("TRB")
	TRB->(Dbskip())

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

	_cTipo :="Arquivo Tipo (*.*)       | *.* | "
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
