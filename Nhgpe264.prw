/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE264  ºAutor  ³ Marcos Roquitski   º Data ³  30/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera arquivo texto das horas do ponto ITESAPAR.            º±±
±±º          ³ Orderm de matricula                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function Nhgpe264() 

SetPrvt("_CARQUIVO,_ACPO,_CPD,_TURNO,_CCECUSTO,_CARQ,_cIntegra,_cOrigem")
SetPrvt("NOUTFILE,")


If MsgYesNo("Cuidado ! ! , Confirma a Conversao do Arquivo","Criando o Arquivo para Convercao")

	Processa( {|| _NhGpe264() } )

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


//
Static Function _NhGpe264()
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
DbUseArea( .T.,,_cArquivo,"ZTMP",.F.)
DbSelectArea("ZTMP")
Append from (_cIntegra) SDF
ZTMP->(DbGoTop())

ProcRegua(ZTMP->(RecCount()))

/*                          

// Verbas ITESAPAR        VERBAS TOTVS
      
   9-HORA EXTRA 50%           105
  10-HORA EXTRA 60%           106
  11-HORA EXTRA 75%           108
  12-HORA EXTRA 85%           109
  13-HORA EXTRA 100%          110
  14-HORA EXTRA 150%          111
  15-HORA EXTRA 70%           107
  16-HORAS EXTRAS 80%         116
  37-ADICIONAL NOTURNO PROPORCIONAL 864
  76-DESCONTO DE ATRASOS           427



  78-DESCONTO DE FALTAS INTEGRAIS  425
  79-DESCONTO DESCANSO SEM. REMUNER  429

 508-BANCO DE HORAS 50%
 509-BANCO DE HORAS 100%
 510-BANCO DE HORAS 150%
 511-Desconto Banco de Horas
 513-BANCO DE HORAS 80%

00003|009|00754|00000000000|                    |
00003|037|10850|00000000000|                    |
00013|009|00041|00000000000|                    |
00013|037|01728|00000000000|                    |
00013|078|02846|00000000000|                    |

01241|076|00206|00000000000|                    |
00476|009|00157|00000000000|                    |

*/
 
While ZTMP->(! Eof())
	
	IncProc()
	
	RecLock("ZTMP",.F.)
	If SubStr(ZTMP->LINHA,7,3)=="009"
		_cPD:="105"        
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="010"
		_cPD:="106"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="011"
		_cPD:="108"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="012"
		_cPD:="109"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="013"
		_cPD:="110"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="014"
		_cPD:="111"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="015"
		_cPD:="107"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="016"
		_cPD:="116"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="037"
		_cPD:="864"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="076"
		_cPD:="427"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="078"
		_cPD:="425"

	elseIf SubStr(ZTMP->LINHA,7,3)=="079"
		_cPD:="429"
	
	elseIf SubStr(ZTMP->LINHA,7,3)=="101"
		_cPD:="428"

	elseIf SubStr(ZTMP->LINHA,7,3)=="508"
		_cPD:="867"

	elseIf SubStr(ZTMP->LINHA,7,3)=="509"
		_cPD:="868"

	elseIf SubStr(ZTMP->LINHA,7,3)=="510"
		_cPD:="869"

	elseIf SubStr(ZTMP->LINHA,7,3)=="513"
		_cPD:="870"



	Else
		_cPD:="999"        	
	Endif

	_Turno    := ""
	_cCeCusto := Space(09)
	_cMatr    := Space(06)

	SRA->(DbSeek(xFilial("SRA")+ "0" + Substr(ZTMP->LINHA,1,5),.T.))	
	If SRA->(Found()) 
		_cCeCusto := SRA->RA_CC
		_Turno    := SRA->RA_TNOTRAB
		_cMatr    := SRA->RA_MAT
    
		ZTMP->LINHA :=  "2" + _cMatr +_cPD + SubStr(ZTMP->LINHA,11,3)+"."+SubStr(ZTMP->LINHA,14,2) + "000000000"+_cCeCusto
		MsUnLock("ZTMP")
	
	Endif
	
	ZTMP->(DbSkip())

Enddo


// Este Loop Trocou os codigos dos eventos, incluiu o ponto do decimal da 
// referencia das horas, e incluiu o centro de custo.

_cArq := "TP"+Str(Year(dDataBase),4)+StrZero(Month(dDataBase),2)+".TXT"
nOutFile := fCreate(_cArq,0)
If Ferror() #0
   MsgStop("Ocorreu o erro" + str(Ferror()) + " do DOS na criacao do arquivo")
EndIf

ZTMP->(DbGoTop())
ProcRegua(ZTMP->(RecCount()))

Do While ZTMP->(! Eof())
   IncProc()
   If SubStr(ZTMP->LINHA,1,1)=="2" .and. SubStr(ZTMP->LINHA,2,6)<>"000000"
      fWrite(nOutFile,ZTMP->LINHA+CHR(13)+CHR(10),33+2)
   EndIf   
   ZTMP->(DbSkip())
EndDo

//Tranformou o Arquivo temporario novamente em arquivo texto para ser 
//executado pela rotina de Importacao de Variaveis (GPEA210).

FClose(nOutFile)
ZTMP->(DbCloseArea())

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

//
Static Function Origem()
	_cTipo :="Arquivo Tipo (*.TXT)       | *.TXT | "
	_cOrigem := cGetFile(_cTipo,,0,,.T.,49)     	 

Return
                         
//              
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
