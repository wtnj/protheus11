/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE209  ºAutor  ³Marcos R. Roquitski º Data ³  22/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa valores consignado Banco do Brasil.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhGpe209()

SetPrvt("_cOrigem,_aStruct,_cTr1,lEnd")
SetPrvt("nHdl,cLin,cFnl,_cOrigem,lEnd,_cOk")

_cOrigem := ''
lEnd     := .T.
cArqItau := "C:\RELATO\BBCON" + Substr(Dtos(dDataBase),5,4) + ".TXT" // 
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
_aStruct:={{ "LINHA","C",200,0}}

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cOrigem) SDF


If MsgYesNo("Confirma Importacao  ","Valores")
   MsAguarde ( {|lEnd| fImporta() },"Aguarde","Importando dados",.T.)
Endif


DbCloseArea("TRB")
Ferase(_cTr1)

Return

/*
00100000         201261681000104000297520           03306500000009525912WHB FUNDICAO S/A              BANCO DO BRASIL SA                      21702201204454400000508100000CDC241                                                               
0010000111201102201200010000001201261681000104      000297520           03306500000009525912WHB FUNDICAO S/A              01                                                                                                                    
0010001300001H0ANTONIO MARCOS DE LIMA MORANO       006872769000000000024211 2 00000000000000000 21003201202360401201210012015000522164000534615000024521000529204787914476           01000000000000000000                                       
0010001300002H0BRUNO COCATO DOS SANTOS             043591649120000000027641 2 00000000000000000 21003201202220401201210112013000231126000236196000014336000229305787934956           01000000000000000000                                       
0010001300003H0ALEXANDRE FRANCISCO LEAL            024534159560000000040401 2 00000000000000000 21003201202360501201210012015001200000001228579000056296001214958787993678           01000000000000000000                                       
*/



Static Function fImporta()
Local _Descpr := Space(30)

SRA->(DbSetOrder(5))

DbSelectArea("TRB")
TRB->(DbgoTop())
While !TRB->(Eof())

	If Substr(TRB->LINHA,8,1) == '3'

		_cOk := .F.
	
		If SRA->(DbSeek(xFilial("SRA")+Substr(TRB->LINHA,52,11),Found()))

			While !SRA->(Eof()) .and. SRA->RA_CIC == Substr(TRB->LINHA,52,11)

				If Empty(SRA->RA_DEMISSAO)

					MsProcTxt(SRA->RA_MAT + " "+Substr(SRA->RA_NOME,1,30))
		
					If !SRC->(DbSeek(xFilial("SRC")+SRA->RA_MAT + "492",Found()))
						// Movimento mensal - Provento
						DbSelectArea("SRC")
						RecLock("SRC",.T.)
						SRC->RC_FILIAL  := xFilial("SRC")
						SRC->RC_MAT     := SRA->RA_MAT
						SRC->RC_PD      := "492"
						SRC->RC_TIPO1   := "V"
						SRC->RC_HORAS   := 0
						SRC->RC_VALOR   := (Val(Alltrim(Substr(TRB->LINHA,145,8)))/100)
						SRC->RC_DATA    := dDataBase
						SRC->RC_CC      := SRA->RA_CC  
						SRC->RC_TIPO2   := "I"
						MsUnlock("SRC")

						cLin := SRA->RA_MAT + "  "+SRA->RA_CIC+"  "+SRA->RA_NOME+"  "
						cLin := cLin + Transform((Val(Alltrim(Substr(TRB->LINHA,145,8)))/100),"@E 999,999,999.99") + "  I"
						cLin := cLin + cFnl
						fWrite(nHdl,cLin,Len(cLin))
						_cOk := .T.

					Else
	
						// Movimento mensal - Provento
						DbSelectArea("SRC")
						RecLock("SRC",.F.)
						SRC->RC_VALOR   += (Val(Alltrim(Substr(TRB->LINHA,145,8)))/100)
						MsUnlock("SRC")
					
						cLin := SRA->RA_MAT + "  "+SRA->RA_CIC+"  "+SRA->RA_NOME+"  "
						cLin := cLin + Transform((Val(Alltrim(Substr(TRB->LINHA,145,8)))/100),"@E 999,999,999.99") + "  I"
						cLin := cLin + cFnl
						fWrite(nHdl,cLin,Len(cLin))
						_cOk := .T.

					Endif	

				Endif	
    	    	SRA->(DbSkip())
        	
			Enddo	
	
		Endif
	Endif		
	If !_cOk 
		cLin := "***"+Substr(TRB->LINHA,52,11)+" "+Substr(TRB->LINHA,16,35)
		cLin := cLin + Transform((Val(Alltrim(Substr(TRB->LINHA,145,8)))/100),"@E 999,999,999.99") + "  X"
		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))
	Endif
	
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
