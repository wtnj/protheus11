/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RHGP08    ºAutor  ³ Maner              º Data ³  05/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo texto das horas do ponto.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Rhgp08()

SetPrvt("_CARQUIVO,_ACPO,_CPD,_TURNO,_CCECUSTO,_CARQ,_cIntegra,_cOrigem")
SetPrvt("NOUTFILE,")

If MsgYesNo("Cuidado ! ! , Confirma a Conversao do Arquivo INTEGRA","Criando o Arquivo para Convercao")
	Processa( {|| RHGP08A() } )
	If !Empty(_cIntegra)
		MsgInfo("Informe o Nome do Arquivo TP"+Str(Year(dDataBase),4)+StrZero(Month(dDataBase),2)+".TXT")

		SRC->(DbGoBottom())
		GetMv("MV_RECANT")
		RecLock("SX6",.F.)
			SX6->X6_CONTEUD:=Str(SRC->(Recno()))
		MsUnLock("SX6")

		If MsgYesNo("Continua a Geracao dos Dados ! ! !", "Convertendo os Valores Variaveis")
			GPEA210()
		Endif   
		SRC->(DbGoBottom())
		GetMv("MV_RECPOS")
		RecLock("SX6",.F.)
			SX6->X6_CONTEUD:=Str(SRC->(Recno()))
		MsUnLock("SX6")
	Endif	
EndIf
Return   

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHGP08A
Static Function RHGP08A()
_cIntegra := ''

DbSelectArea("SRA")
DbSetOrder(1)
SRA->(DbGoTop())

If !CopiaArq()
	Return
Endif

_cIntegra := _cOrigem  
lEnd      := .T.

If !File(_cIntegra)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cArquivo,"Arquivo Retorno","INFO")
   Return
Endif


// Criar Arquivo Provisorio para armazenar e manipular o arquivo Texto gerado
// pelo Relogio Ponto.

_cArquivo := "TP"+Str(Year(dDataBase),4)+StrZero(Month(dDataBase),2)
_aCpo     := {{"LINHA","C",33,0}} 

DbCreate(_cArquivo,_aCpo)
DbUseArea( .T.,,_cArquivo,"TMP",.F.)
DbSelectArea("TMP")
Append from (_cIntegra) SDF
TMP->(DbGoTop())

ProcRegua(TMP->(RecCount()))
 
Do While TMP->(! Eof())
   IncProc()
   RecLock("TMP",.F.)
   If SubStr(TMP->LINHA,8,3)=="201"
      _cPD:="105"
   elseIf SubStr(TMP->LINHA,8,3)=="203"
      _cPD:="110"
   elseIf SubStr(TMP->LINHA,8,3)=="204"
      _cPD:="111"
   elseIf SubStr(TMP->LINHA,8,3)=="205"
      _cPD:="113"
   elseIf SubStr(TMP->LINHA,8,3)=="210"
      _cPD:="106"
   elseIf SubStr(TMP->LINHA,8,3)=="070"
      _cPD:="107"
   elseIf SubStr(TMP->LINHA,8,3)=="211"
      _cPD:="108"
   elseIf SubStr(TMP->LINHA,8,3)=="212"
      _cPD:="109"
   elseIf SubStr(TMP->LINHA,8,3)=="080"
      _cPD:="116"
   elseIf SubStr(TMP->LINHA,8,3)=="612"
      _cPD:="425"
   elseIf SubStr(TMP->LINHA,8,3)=="706"
      _cPD:="429"
   elseIf SubStr(TMP->LINHA,8,3)=="728"
      _cPD:="427"
   elseIf SubStr(TMP->LINHA,8,3)=="733"    
      _cPD:="428"
   elseIf SubStr(TMP->LINHA,8,3)=="110"
      _cPD:="110"
   elseIf SubStr(TMP->LINHA,8,3)=="141"
      _cPD:="141"
   elseIf SubStr(TMP->LINHA,8,3)=="143"
      _cPD:="143"
   elseIf SubStr(TMP->LINHA,8,3)=="145"
      _cPD:="145"
   elseIf SubStr(TMP->LINHA,8,3)=="147"
      _cPD:="147"
   else
      _cPD:="999"
   EndIf
// Inclusao em 09/08/01 - Maner
   _Turno := ""
   _cCeCusto:=Space(09)
//
   SRA->(DbSeek(xFilial("SRA")+"0"+SubStr(TMP->LINHA,2,5),.T.))
   If "0"+SubStr(TMP->LINHA,2,5)==SRA->RA_MAT
      _cCeCusto:= SRA->RA_CC
      _Turno := SRA->RA_TNOTRAB
   EndIf
// Inclusao em 09/08/01 - Maner
   If _Turno == "017"
      If     _cPD == "105"
         _cPD := "305"
      elseIf _cPD == "106"
         _cPD := "306"
      elseIf _cPD == "107"
         _cPD:= "307"
      elseIf _cPD == "108"
         _cPD:= "308"
      elseIf _cPD == "109"
         _cPD:= "309"
      elseIf _cPD == "110"
         _cPD:= "310"
      elseIf _cPD == "111"
         _cPD:= "311"
      elseIf _cPD == "116"
         _cPD:= "316"
      elseIf _cPD == "113"
         _cPD:= "313"
      Endif
   Endif
//   
   TMP->LINHA := SubStr(TMP->LINHA,1,1)+"0"+SubStr(TMP->LINHA,2,5)+_cPD+SubStr(TMP->LINHA,11,3)+"."+SubStr(TMP->LINHA,14,10)+_cCeCusto
   MsUnLock("TMP")
   TMP->(DbSkip())
EndDo

// Este Loop Trocou os codigos dos eventos, incluiu o ponto do decimal da 
// referencia das horas, e incluiu o centro de custo.

_cArq := "TP"+Str(Year(dDataBase),4)+StrZero(Month(dDataBase),2)+".TXT"
nOutFile := fCreate(_cArq,0)
If Ferror() #0
   MsgStop("Ocorreu o erro" + str(Ferror()) + " do DOS na criacao do arquivo")
EndIf

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

Do While TMP->(! Eof())
   IncProc()
   If SubStr(TMP->LINHA,1,1)=="2" .and. SubStr(TMP->LINHA,2,6)<>"000000"
      fWrite(nOutFile,TMP->LINHA+CHR(13)+CHR(10),33+2)
   EndIf   
   TMP->(DbSkip())
EndDo

//Tranformou o Arquivo temporario novamente em arquivo texto para ser 
//executado pela rotina de Importacao de Variaveis (GPEA210).

FClose(nOutFile)
Return   
       

//
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

//      
Static Function fConfArq()
	If Empty(_cOrigem)
		MsgBox("Arquivo para Processamento nao Informado","Atencao","INFO")
	Else
		Close(oDialogos)
		_lSai := .T.
	Endif
Return

