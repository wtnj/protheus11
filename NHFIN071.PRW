/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN071  ºAutor  ³João Felipe da Rosa º Data ³  21/01/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aponta divergências                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WHB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"

User Function NhFin071()

cDesc1    := OemToAnsi("Este  relatorio   tem   como  objetivo  Imprimir ")
cDesc2    := OemToAnsi("os   erros   das   divergências  do  retorno  do ")
cDesc3    := OemToAnsi("arquivo da folha de pagamento do banco Bradesco.")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHQMT005"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO DE DIVERGÊNCIAS") 
cabec1    := " Nome"+Space(39)+ "Erro"
cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHFIN071"
lEnd      := .T.
Private _cOrigem 	
SetPrvt("_aStruct,_cTr1,lEnd, _cOrigem")


If !CopiaArq()
	Return
Endif

If !File(_cOrigem)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cOrigem,"Arquivo Retorno","INFO")
   Return
Endif

// Arquivo a ser trabalhado
_aStruct:={{ "LINHA","C",200,0}}

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cOrigem) SDF

If MsgYesNo("Confirma Importacao ","Valores")
   MsAguarde( {|lEnd| fImporta() },"Aguarde","Importando dados",.T.)
Endif

Ferase(_cTr1)
Return

Static Function fImporta()
Local _Descpr := Space(30)

//--------Mostra na tela a importação do arquivo----------//
DbSelectArea("TRB")
TRB->(DbgoTop())

While !TRB->(Eof())
	MsProcTxt(TRB->LINHA)
	TRB->(Dbskip())
Enddo

//------Imprime o relatório quando houver divergência-----//
SetPrint("TRB",wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,"TRB")

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| RptDetail() },"Imprimindo...")

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function RptDetail()
Local _lErro := .F.
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

TRB->(DbGotop())	
While TRB->(!Eof()) 

	If Prow() > 70
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	Endif

	If Substr(TRB->LINHA,121,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "ERRO AGÊNCIA EMPRESA"
		_lErro := .T.
	EndIf		          
	If Substr(TRB->LINHA,122,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "ERRO CONTA EMPRESA"
		_lErro := .T.
	EndIf		
	If Substr(TRB->LINHA,123,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "RAZÃO EMPRESA"
		_lErro := .T.
	EndIf		
	If Substr(TRB->LINHA,124,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "ERRO DATA DE DÉBITO"
		_lErro := .T.
	EndIf		
	If Substr(TRB->LINHA,151,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "ERRO AGÊNCIA FUNCIONÁRIO"
		_lErro := .T.
	EndIf		
	If Substr(TRB->LINHA,152,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "ERRO CONTA FUNCIONÁRIO"
		_lErro := .T.
	EndIf		
	If Substr(TRB->LINHA,15,1) == 'S'
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "ERRO NO VALOR TOTAL"
		_lErro := .T.
	EndIf		
	If	!_lErro
		@Prow()+1, 001 Psay Substr(TRB->LINHA,83,38) + Space(5) + "OK"
	EndIf
	TRB->(DbSkip())
		_lErro := .F.
EndDo
@ Prow()+1,000 PSAY __PrtThinLine()

DbCloseArea('TRB')

Return   


//----- cria a tela para importacao de arquivos -------//
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

	_cTipo :="Todos os Arquivos (*.*)       | *.*  | "
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