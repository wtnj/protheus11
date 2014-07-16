/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE053  ºAutor  ³Marcos R. Roquitski º Data ³  22/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do PPR.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhGpe053()

SetPrvt("_cArquivo,_aStruct,_cTr1,lEnd")

_cArquivo := "ABS001.TXT"
lEnd      := .T.

If !File(_cArquivo)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cArquivo,"Arquivo Retorno","INFO")
   Return
Endif

DbSelectArea("SRA")
DbSetorder(1)

// Arquivo a ser trabalhado
_aStruct:={{ "MATR","C",06,0},;
          { "FALTAS","N",02,0}}

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cArquivo) SDF

If MsgYesNo("Confirma Importacao do Absenteismo","Absenteismo")
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
	If SRA->(DbSeek(xFilial("SRA")+TRB->MATR),Found())
		MsProcTxt(SRA->RA_MAT + " "+Substr(SRA->RA_NOME,1,30))
		RecLock("SRA",.F.)
		SRA->RA_FALTAS := TRB->FALTAS
		MsUnlock("SRA")
	Endif
	TRB->(Dbskip())
Enddo

Return