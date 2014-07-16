/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNHFIN055  บAutor  ณMarcos R Roquitski  บ Data ณ  03/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio do movimento do caixinha.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#INCLUDE "PROTHEUS.CH"

User Function Nhfin055()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tiene como objetivo imprimir o"
Local cDesc2         := "informe de movimento do Caixinha conforme"
Local cDesc3         := "parametros informados pelo usuario."
Local titulo         :=  "Movimento do Caixinha"
Local nLin           := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "NHFIN055" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey     := 0
Private cPerg        := "FIR560"
Private CONTFL       := 1
Private m_pag      	 := 1
Private wnrel      	 := "NHFIN055" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SEU"

dbSelectArea("SEU")
dbSetOrder(4)

Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
//          10        20        30        40        50        60        70        80        90        100       110
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
Cabec1       	:= "Descricao                       Usuario          Comprovante  Nro. Interno  Numero de   Data de              Valor"+IIf(mv_par05==1,"           Rendido","")
Cabec2       	:= "                                                              de Movimento  Adiant.     Digitacao                      "

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Bruno Sobieski     บ Data ณ  02/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cAdia,lSaldo	:=	.T.
Local aArea
Local cCaixa		:=	""
Local lPrinted 	:=	.F.
Local cbtxt	      	:= Space(10)
Local cbcont	     	:= 1
	
Private nSaldo	:=	0
Private	nSaldoTot:= 0

dbSelectArea("SEU")
dbSetOrder(4)
SetRegua(RecCount())

DbSeek(xFilial()+mv_par01+DTOS(mv_par03),.T.)

While !EOF() .And.xFilial() == EU_FILIAL .And. EU_CAIXA <= MV_PAR02
	IncRegua()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If mv_par05 <> 1 .And.(EU_TIPO	==	"01" .And. EU_SLDADIA == 0)
		DbSkip()
		Loop
	Endif
	If EU_TIPO == "02"
		DbSkip()
		Loop
	Endif
	//Vou me posicionar no primeiro registro para porcessar de acordo com a data de inicio.
	If EU_DTDIGIT > mv_par04 .And. cCaixa == EU_CAIXA
		SET->(DbSetOrder(1))
		SET->(DbSeek(xFilial()+SEU->EU_CAIXA))
		SET->(DbSkip())
		If !SET->(EOF())  .and. SET->ET_FILIAL == xFilial("SET") .and. (SET->ET_CODIGO >= mv_par01 .and. SET->ET_CODIGO <= mv_par02)
			SEU->(DbSeek(xFilial()+SET->ET_CODIGO+DTOS(mv_par03),.T.))
		Else
			Exit
		EndIf    
	Endif

	dbSelectArea("SEU")
	If EU_CAIXA < MV_PAR01 .or. EU_CAIXA > MV_PAR02
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	//Posicionar no primeiro registro de acordo com a data escolhida.
	If cCaixa <> EU_CAIXA .And. mv_par06 == 1
		SEU->(DbSeek(xFilial()+EU_CAIXA+DTOS(mv_par03),.T.))
		If !lSaldo
			nLin+=2
			@nLin, 077 PSAY IIf(mv_par06==1,"Saldo Caixa ----->","Total Gastos ---->")
			@nLin, 098 PSAY nSaldo	PICTURE PesqPict("SEU","EU_VALOR",16)
			nSaldoTot	+=	nSaldo
			nSaldo	:=	0
			lSaldo	:=	.T.
			lPrinted :=	.F.
		Endif
	Endif
	
	If mv_par06 == 1 .And. !Empty(EU_NROADIA)
		aArea	:=	GetArea()
		DbSetOrder(3)
		DbSeek(xFilial()+EU_NROADIA)
		If EU_SLDADIA > 0 .Or.	mv_par05 == 1
			RestArea(aArea)
			DbSkip()
			Loop
		Endif
		RestArea(aArea)
	Endif
	
	If mv_par06 == 2 .And. EU_TIPO <> "00" //So listar despesas
		DbSkip()
		Loop
	Endif
	
	If !lPrinted
		If !Empty(cCaixa)
			nLin+=2
		Else
			nLin++
		Endif
		SET->(DbSetOrder(1))
		SET->(DbSeek(xFilial()+SEU->EU_CAIXA))
		@nLin, 05 PSAY "Caixinha  " + SEU->EU_CAIXA + " - "+SET->ET_NOME //"Caja chica "
		cCaixa	:=	EU_CAIXA
		lPrinted	:=	.T.
	Endif
	lSaldo	:=	.F.
	
	If SEU->EU_DTDIGIT >= mv_par03 .and. SEU->EU_DTDIGIT <= mv_par04
		nLin++
		F560Print(@nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)	
		If mv_par05 == 1 .And.EU_TIPO =="01"
			@nLin,116	PSAY	EU_VALOR - EU_SLDADIA PICTURE PesqPict("SEU","EU_VALOR",16)
			If EU_VALOR <> EU_SLDADIA
				nLin++
				@nLin,002 PSAY	"Detalhes de Antecip."
				aArea	:=	GetArea()
				DbSetOrder(3)
				cAdia	:=	EU_NUM
				DbSeek(xFilial()+cAdia)
				While !EOF()	.And.	xFilial() == EU_FILIAL .And. EU_NROADIA == cAdia
					nLin++
					F560Print(@nLin,4,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					DbSkip()
				Enddo
				RestArea(aArea)
			Endif
		Endif
	EndIf
	dbSkip() // Avanca o ponteiro do registro no arquivo
	If cCaixa <> EU_CAIXA .And. !lSaldo
		nLin+=2
		@nLin, 077 PSAY IIf(mv_par06==1,"Saldo Caixa --->","Total Gastos ---->") //"Saldo Caja ---->"###"Total Gastos ---->"
		@nLin, 098 PSAY nSaldo	PICTURE PesqPict("SEU","EU_VALOR",16)
		nSaldoTot	+=	nSaldo
		nSaldo	:=	0
		lSaldo	:=	.T.
		lPrinted	:=	.F.
	Endif
EndDo
If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
If !lSaldo
	nLin+=2
	@nLin, 077 PSAY IIf(mv_par06==1,"Saldo Caixa ----->","Total Gastos ---->") //"Saldo Caja ---->"###"Total Gastos ---->"
	@nLin, 098 PSAY nSaldo	PICTURE PesqPict("SEU","EU_VALOR",16)
	nSaldoTot	+=	nSaldo
Endif
If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
If mv_par06 == 2
	nLin++
	nLin++
	@nLin, 071 PSAY "Total Geral Gastos ---->"
	@nLin, 098 PSAY nSaldoTot	PICTURE PesqPict("SEU","EU_VALOR",16)
Endif
If nLin != 80

	If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	nLin += 5
	@nLin, 010 PSAY "______________________                   ______________________            ______________________"
	nLin++
	@nLin, 010 PSAY " Responsavel Caixa                            Gerencia                          Contabilidade "
	Roda(cbcont,cbtxt,Tamanho)
Else
	If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	nLin += 5
	@nLin, 010 PSAY "______________________                   ______________________            ______________________"
	nLin++
	@nLin, 010 PSAY " Responsavel Caixa                            Gerencia                          Contabilidade "
	Roda(cbcont,cbtxt,Tamanho)
Endif
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณF560Print บ Autor ณ Bruno Sobieski     บ Data ณ  02/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Imprime um item.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function F560Print(nLin,nDesp,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Local cTipo	:=	""

Do Case
	Case EU_TIPO == "00"
		cTipo	:=	IIf(Empty(EU_HISTOR),"Gasto",EU_HISTOR) //"Gasto"
	Case EU_TIPO == "01"
		cTipo	:=	IIf(Empty(EU_HISTOR),"Antecip.","Ant. "+ Substr(EU_HISTOR,1,20)) //"Anticipo"###"Ant. "
	Case EU_TIPO == "02"
		cTipo	:=	"Dev. Antecip."
	Case EU_TIPO == "10"
		cTipo	:=	"Reposicao"
	Case EU_TIPO == "11"
		cTipo	:=	IIf(Empty(EU_HISTOR),"Transf. por cierre",EU_HISTOR) //"Transf. por cierre"
	Case EU_TIPO == "12"
		cTipo	:=	IIf(Empty(EU_HISTOR),"Dev. por Caixa Menor",EU_HISTOR) //"Dev. por cierre Caja Menor"
	Case EU_TIPO == "13"
		cTipo	:=	IIf(Empty(EU_HISTOR),"Repos. Caixa Menor",EU_HISTOR) //"Repos. Caja Menor"
Endcase
If nLin > 58 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin,000+nDesp	PSAY	cTipo
@nLin,029			PSAY	Substr(EU_BENEF,1,19)
@nLin,049			PSAY	EU_NRCOMP 	PICTURE PesqPict("SEU","EU_NRCOMP")
@nLin,062			PSAY	EU_NUM		PICTURE PesqPict("SEU","EU_NUM")
@nLin,076			PSAY	EU_NROADIA	PICTURE PesqPict("SEU","EU_NROADIA")
@nLin,088			PSAY	DTOC(EU_DTDIGIT)
nSigno	:=	IIf(mv_par06 == 2 .Or. !(EU_TIPO$"00|01|11|13"),1,-1)
If nDesp == 0
	@nLin,098			PSAY	(EU_VALOR*nSigno)	PICTURE PesqPict("SEU","EU_VALOR",16)
Else
	If EU_TIPO == "02" //Devolucao de adiantamento
		@nLin,098		PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
	Endif
	@nLin,116			PSAY	EU_VALOR	PICTURE PesqPict("SEU","EU_VALOR",16)
Endif
If nDesp == 0 .Or. EU_TIPO == "02"
	nSaldo		+=	(EU_VALOR*nSigno)
Endif

Return
