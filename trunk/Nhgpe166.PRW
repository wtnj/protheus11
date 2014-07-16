#INCLUDE "RWMAKE.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#INCLUDE 'SEGDES.CH'
#INCLUDE 'protheus.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัอออออออออหอออออออัอออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma     ณSEGDES   บAutor  ณMicrosiga                บ Data ณ  10-01-02  บฑฑ
ฑฑฬอออออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.        ณRequerimento de Seguro-Desemprego - S.D.	 	 	 	        บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso          ณAP6                                                            บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ			     	        ATUALIZACOES OCORRIDAS                              บฑฑ
ฑฑฬฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบProgramador  ณData    ณ BOPS/FNC  ณ  Motivo da Alteracao                     ณฑฑ
ฑฑฬฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบPriscila     ณ30/09/02ณ015780     ณAjuste p/ Impressao, qdo Cal.Resc. mes se ณฑฑ
ฑฑบ             ณ        ณ           ณguinte e nao foi feito o Fechamento Atual.ณฑฑ
ฑฑบ             ณ        ณ-----------ณAjuste no salto de pagina.                ณฑฑ
ฑฑบ             ณ        ณ-----------ณAcerto nos Valores dos 3 Ultimos Salarios.ณฑฑ
ฑฑบ             ณ        ณ-----------ณAjuste para posicionar correto no SRA.    ณฑฑ
ฑฑบ             ณ        ณ-----------ณAjuste na impressao em Disco.             ณฑฑ
ฑฑบ             ณ        ณ-----------ณValidacao Impr.Rescisao somente Efetiva.  ณฑฑ
ฑฑบEmerson      ณ06/01/03ณ-----------ณBuscar o codigo CBO no cadastro de funcoesณฑฑ
ฑฑบ             ณ        ณ-----------ณde acordo com os novos codigos CBO/2002.  ณฑฑ
ฑฑบPriscila     ณ15/05/03ณ063264     ณAjuste p/ trazer correto os valores dos 3 ณฑฑ
ฑฑบ             ณ        ณ           ณultimos salarios.                         ณฑฑ
ฑฑบSilvia       ณ30/09/03ณ066800     ณAjuste no calculo dos 3 ult.salario       ณฑฑ
ฑฑบPedro Eloy   ณ12/02/04ณ069232     |Definicao das variaveis atribuindo o :=0  ณฑฑ
ฑฑบPedro Eloy   ณ02/06/04ณ068748     |Foi tratado os valores AntPen. e Penul.   ณฑฑ 
ฑฑบ             ณ17/08/04ณ073442     ณTroca da fSomaAcl por fBuscaAcm- verifica ณฑฑ
ฑฑบ             ณ        ณ-----------ณas transf. do funcionario                 ณฑฑ
ฑฑบ             ณ13/09/04ณ-----------ณNovo lay-out - Resol. 393/2004            ณฑฑ
ฑฑบ             ณ15/02/05ณ075395     ณFaz a impressao dos salarios juntamente   ณฑฑ
ฑฑบ             ณ        ณ-----------ณcom as verbas incorporadas -Busca id 318  ณฑฑ
ฑฑบPedro Eloy   ณ13/07/05ณSADVLQ     ณAjuste no retorno do campo SRA->RA_SerCp  ณฑฑ
ฑฑบ             ณ        ณ-----------ณbusca a serie da carteira trabalhista.    ณฑฑ
ฑฑบ             ณ29/07/05ณ082433     ณImpressao do campo telefone do Funcion.   ณฑฑ
ฑฑบRicardo D.   ณ05/01/06ณ090269     ณAjuste na pesquisa do penultimo salario noณฑฑ
ฑฑบ             ณ        ณ           ณcaso em que a demissao ocorrer no mes se- ณฑฑ
ฑฑบ             ณ        ณ           ณguinte ao mes aberto.                     ณฑฑ
ฑฑบTania/Ricardoณ22/02/06ณ092668     ณAcerto para impressao das verbas no acumu-ณฑฑ
ฑฑบ             ณ        ณ           ณlado quando em Top.                       ณฑฑ
ฑฑบNatie        ณ04/07/06ณ101533     ณAjuste na impressao do cpo Endereco       ณฑฑ
ฑฑบNatie        ณ28/11/06ณ111215     ณAjuste na impressao do Cep qdo nao havia  ณฑฑ
ฑฑบ             ณ        ณ           ณimpressao de complemento  de endereco     ณฑฑ
ฑฑบPedro Eloy   ณ01/06/07ณ126187     ณTratamento na emissao do aviso indenizado.ณฑฑ
ฑฑบNatie        ณ06/06/07ณ096700     ณAjuste na composicao dos meses trabalhadosณฑฑ
ฑฑบMarcelo      ณ20/01/09ณ155069     ณConversao p/ permitir impressao em formatoณฑฑ
ฑฑบ             ณ        ณ           ณgrafico. Inclusao das funcoes: AjustaSX e ณฑฑ
ฑฑบ             ณ        ณ           ณfIncSpace.                                ณฑฑ
ฑฑบMarcelo      ณ06/03/09ณ004737/2009ณCriacao de pergunta p/definir se as verbasณฑฑ
ฑฑบ             ณ        ณ           ณinformadas serao somadas no ultimo salarioณฑฑ
ฑฑบMarcelo      ณ27/05/09ณ013064/2009ณAjuste em fSegDes para considerar sempre aณฑฑ
ฑฑบ             ณ        ณ           ณdata de demissao na apuracao dos meses    ณฑฑ
ฑฑบ             ณ        ณ           ณtrabalhados.                              ณฑฑ
ฑฑบReginaldo    ณ19/08/09ณ020743/2009ณ Ajuste no grupo de campos filial.        ณฑฑ
ฑฑบMarcelo      ณ11/09/09ณ022163/2009ณAjustes na funcao fIncSpace e no valor dasณฑฑ
ฑฑบ             ณ        ณ           ณmargens horizontal e vertical p/ corrigir ณฑฑ
ฑฑบ             ณ        ณ           ณa impressao no formato grafico.           ณฑฑ
ฑฑศอออออออออออออฯออออออออฯอออออออออออฯออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function Nhgpe166() // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis utilizadas no programa atraves da funcao    ณ
//ณ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ณ
//ณ identificando as variaveis publicas do sistema utilizadas no codigo ณ
//ณ Incluido pelo assistente de conversao do AP5 IDE                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private NSALARIO	:=0,NSALHORA	:=0,NORDEM		:=0
Private NSALMES		:=0,NSALDIA		:=0,NLUGAR		:=0
Private NVALULT		:=0,NVALPEN		:=0,NVALANT		:=0
Private NVALULTSAL	:=0,NVALPENSAL	:=0,NVALANTSAL	:=0,NX		:=0

SetPrvt("CTIT,CDESC1,CDESC2,CDESC3,CSTRING,CALIAS")
SetPrvt("AORD,WNREL,CPERG,CFILANTE,LEND,LFIRST")
SetPrvt("ARETURN,AINFO,NLASTKEY")
SetPrvt("CFILDE,CFILATE,CMATDE,CMATATE,CCOMPL")
SetPrvt("CCCDE,CCCATE,NVIAS,DDTBASE,CVERBAS,DDEMIDE,DDEMIATE")
SetPrvt("CNOME,CEND,CCEP,CUF,CFONE,CMAE,CTPINSC")
SetPrvt("CCGC,CCNAE,CPIS,CCTPS,CCTSERIE,CCTUF")
SetPrvt("CCBO,COCUP,DADMISSAO,DDEMISSAO,CSEXO,CGRINSTRU")
SetPrvt("DNASCIM,CHRSEMANA,CMAT,CFIL,CCC,CNMESES")
SetPrvt("C6SALARIOS,CINDENIZ,DDTULTSAL,DDTPENSAL,DDTANTSAL,CTIPO")
SetPrvt("CVALOR,CCPF,aCodFol, cEndCompl")

//+--------------------------------------------------------------+
//ฆ Define Variaveis Locais (Basicas)                            ฆ
//+--------------------------------------------------------------+
cTit     :=	STR0001 // ' REQUERIMENTO DE SEGURO-DESEMPREGO - S.D. '
cDesc1   :=	STR0002 // 'Requerimento de Seguro-Desemprego - S.D.'
cDesc2   :=	STR0003 // 'Serแ impresso de acordo com os parametros solicitados pelo'
cDesc3   :=	STR0004 // 'usuario.'
cString  :=	'SRA'
cAlias   :=	'SRA'
aOrd     :=	{STR0005,STR0006}	// 'Matricula'###'Centro de Custo'
WnRel    :=	'SEGDES'
cPerg    :=	'SEGDES'                    
cFilAnte :=	"ทท"
lEnd     :=	.F.
lFirst   :=	.T.
aReturn  :=	{ STR0007,1,STR0008,2,2,1,'',1 }	// 'Zebrado'###'Administra็ไo'	
aInfo    :=	{}
nLastKey :=	0
nLinha	 :=	0
aRegs    :=	{}

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Variaveis de Acesso do Usuario                               ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cAcessaSRA	:= &( " { || " + ChkRH( "SEGDES" , "SRA" , "2" ) + " } " )

AjustaSX()

//+--------------------------------------------------------------+                      
//ฆ Verifica as perguntas selecionadas                           ฆ
//+--------------------------------------------------------------+
pergunte('SEGDES',.F.)
   
//+--------------------------------------------------------------+
//ฆ Variaveis utilizadas para parametros                         ฆ
//ฆ MV_PAR01        //  FiLial De                                ฆ
//ฆ MV_PAR02        //  FiLial Ate                               ฆ
//ฆ MV_PAR03        //  Matricula De                             ฆ
//ฆ MV_PAR04        //  Matricula Ate                            ฆ
//ฆ MV_PAR05        //  Centro De Custo De                       ฆ
//ฆ MV_PAR06        //  Centro De Custo Ate                      ฆ
//ฆ MV_PAR07        //  Nบ de Vias                               ฆ
//ฆ MV_PAR08        //  Data Base                                ฆ
//ฆ MV_PAR09        //  Verbas a serem somadas ao Salario        ฆ
//ฆ MV_PAR10        //  Compl.Verbas a somar ao Salario          ฆ
//ฆ MV_PAR11        //  Data Demissao De                         ฆ
//ฆ MV_PAR12        //  Data Demissao Ate                        ฆ
//ฆ MV_PAR13        //  1=impressao Grafica; 2=Impressao Zebrada ฆ
//ฆ MV_PAR14        //  Somar verbas da Rescisao; 1=Sim; 2=Nao   ฆ
//+--------------------------------------------------------------+
   
//+--------------------------------------------------------------+
//ฆ Envia controle para a funcao SETPRINT                        ฆ
//+--------------------------------------------------------------+
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,'M')

//+--------------------------------------------------------------+
//ฆ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ฆ
//+--------------------------------------------------------------+
nOrdem   := aReturn[8]

cFilDe	 := If(!Empty(MV_PAR01), MV_PAR01, Space(FWGETTAMFILIAL))
cFilAte	 := If(!Empty(MV_PAR02), MV_PAR02, Replicate("Z", FWGETTAMFILIAL))
cMatDe	 := If(!Empty(MV_PAR03), MV_PAR03, Space(GetSx3Cache("RA_MAT", "X3_TAMANHO")))
cMatAte	 := If(!Empty(MV_PAR04), MV_PAR04, Replicate("Z", GetSx3Cache("RA_MAT", "X3_TAMANHO")) )
cCCDe	 := If(!Empty(MV_PAR05), MV_PAR05, Space(GetSx3Cache("RA_CC", "X3_TAMANHO")))
cCCAte	 := If(!Empty(MV_PAR06), MV_PAR06, Replicate("Z", GetSx3Cache("RA_CC", "X3_TAMANHO")) )
nVias	 := If(!Empty(MV_PAR07), IIf(MV_PAR07 <= 0, 1, MV_PAR07), 1)
dDtBase  := If(!Empty(MV_PAR08), IIf(Empty(MV_PAR08), dDataBase, MV_PAR08), dDataBase)
cVerbas  := AllTrim(MV_PAR09) + AllTrim(MV_PAR10)
dDemiDe  := MV_PAR11
dDemiAte := MV_PAR12
   
Private nTipoRel := MV_PAR13 // 1= impressao Grafica; 2= Impressao Zebrada
Private nVerbRes := MV_PAR14 // Somar verbas da Rescisao; 1=Sim; 2=Nao

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Objetos p/ Impresssao Grafica  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oFont10
Private oFont12

oFont10	:= TFont():New("Arial",09,09,,.F.,100,,100,,,.F.)   
oFont11	:= TFont():New("Arial",11,11,,.F.,100,,100,,,.F.)   
   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fTransVerba()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa Impressao                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ! fInicia(cString)
	Return
Endif     

If nTipoRel = 1
	lFirst := .T.
	oPrint := TMSPrinter():New( STR0001 )
	oPrint:SetPortrait()
Endif	

nLinha	:= 6

RptStatus({|| fSegDes()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(fSegDes)})

If nTipoRel == 1
	oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir
Endif                  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSEGDES   บAutor  ณMicrosiga           บ Data ณ  10-01-02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fSegDes()

Local nCont := 0
Local nX
Local nTam	:= 0 

dbSelectArea('SRA')
dbSetOrder(nOrdem)
SetRegua(RecCount())
dbSeek(cFilDe + cMatDe,.T.)

Do While !Eof()	
	//+------------------------------------------- -----------------+
	//ฆ Incrementa Regua de Processamento.                           ฆ
	//+--------------------------------------------------------------+
	IncRegua()

	//+--------------------------------------------------------------+
	//ฆ Processa Quebra de Filial.                                   ฆ
	//+--------------------------------------------------------------+
	If SRA->RA_FILIAL != cFilAnte
		If	!fInfo(@aInfo,SRA->RA_FILIAL) .or. !( Fp_CodFol(@aCodFol,Sra->Ra_FILIAL) )
			dbSkip()
			Loop
		Endif		
		cFilAnte := SRA->RA_FILIAL		
	Endif		
	
	//+--------------------------------------------------------------+
	//ฆ Cancela Impresฆo ao se pressionar <ALT> + <A>.               ฆ
	//+--------------------------------------------------------------+
	If lEnd
		@ pRow()+ 1, 00 PSAY STR0009 // ' CANCELADO PELO OPERADOR . . . '
		Exit
	EndIF
	
	//+--------------------------------------------------------------+
	//ฆ Consiste Parametriza็ฆo do Intervalo de Impressฆo.           ฆ
	//+--------------------------------------------------------------+
	If 	(SRA->RA_FILIAL < cFilDe)	.Or. (SRA->RA_FILIAL > cFilAte)	.Or.;
		(SRA->RA_MAT < cMatDe)		.Or. (SRA->RA_MAT > cMatAte)	.Or.;
		(SRA->RA_CC < cCcDe)		.Or. (SRA->RA_CC > cCCAte) 
        SRA->(dbSkip())
		Loop
	EndIf
	
	//+--------------------------------------------------------------+
	//ฆ Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         ฆ
	//+--------------------------------------------------------------+
	cAlias := Alias()                                                            
	lAchouSrg := .F.
	dbSelectArea('SRG')     
	If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
		While ! EOF() .And. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			If (SRG->RG_DATADEM < dDemiDe) .Or. (SRG->RG_DATADEM > dDemiAte) .Or. SRG->RG_EFETIVA == "N"
				SRG->(dbSkip())
				Loop
			EndIf
			lAchouSrg := .T.
			Exit
		Enddo
	EndIf    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso nao encontre o funcionario no SRG, le o proximo funcionario no SRAณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ! lAchouSrg .OR.(SRG->RG_DATADEM < dDemiDe) .Or. (SRG->RG_DATADEM > dDemiAte) .Or. SRG->RG_EFETIVA == "N"
		dbSelectArea("SRA")
		dbSkip()
		Loop
	Endif
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณConsiste Filiais e Acessos                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		dbSelectArea("SRA")
   		dbSkip()
  		Loop
	EndIF


	//--Carregar a descricao do tipo da rescisao		
	cIndeniz   := fPHist82(SRG->RG_FILIAL,'32',SRG->RG_TipoRes,32,1)
	
	//+--------------------------------------------------------------+
	//ฆ Variaveis utilizadas na impressao.                           ฆ
	//+--------------------------------------------------------------+
	cNome      := Left(SRA->RA_Nome,38)
	cMae       := Left(SRA->RA_Mae,38)     
	cEndCompl  := AllTrim(SRA->RA_Endereco) + '-' + AllTrim(SRA->RA_Bairro)   + '-' + AllTrim(SRA->RA_MUNICIP)   + ' ' + alltrim(SRA->RA_Complem) 
	cEnd       := Left(cEndCompl, If( nTipoRel=1, 40, 38 )) 	
	cCompl	   := If( nTipoRel=1, substr(cEndCompl,41,16) , substr(cEndCompl,39,14) )
	If Len(cCompl) < 14 
		nTam	:= 14 - Len(cCompl)
		cCompl	:= cCompl+space(nTam)
	Endif 
	cCep       := Transform(Left(SRA->RA_Cep,8),'@R #####-###')
	cUF        := Left(SRA->RA_Estado,2)
	cFone      := Left(alltrim(SRA->RA_Telefon),10)
	cTpInsc    := If(aInfo[15]==1,'2','1') //-- 1=C.G.C. 2=C.E.I.
	cCgc       := Transform(Left(aInfo[8],14),'@R ')
	cCNAE      := Left(aInfo[16],5)
	cPis       := Left(SRA->RA_Pis,11)
	cCTPS      := Left(SRA->RA_NumCp,7)
	cCTSerie   := Right(Alltrim(SRA->RA_SerCp),3)
	cCTUF      := Left(SRA->RA_UFCP,2)
	cCBO       := fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDtBase)
	cOcup      := DescFun(SRA->RA_CodFunc,SRA->RA_FILIAL)
	dAdmissao  := SRA->RA_Admissa
	dDemissao  := SRG->RG_DATADEM
	cSexo      := If(Sra->RA_Sexo=='M','1','2')
	dNascim    := SRA->RA_Nasc
	cHrSemana  := StrZero(Int(SRA->RA_HRSEMAN),2)
	cMat       := SRA->RA_MAT
	cFil       := SRA->RA_FILIAL
	cCC        := SRA->RA_CC
	cCpf	   := SRA->RA_CIC
	cNMeses    := fMesesTrab (SRA->RA_ADMISSA, SRG->RG_DATADEM)
	cNMeses	   := If (SRA->RA_MESESAN > 0,cNMeses + SRA->RA_MESESAN,CNMeses) 
	cNMeses    := If(cNMeses<=36,StrZero(cNMeses,2),'36')
	c6Salarios := If(Val(cNMeses)+SRA->RA_MesesAnt>=6,'1','2')
	
	//+--------------------------------------------------------------+
	//ฆ Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         ฆ
	//+--------------------------------------------------------------+
	cAlias := Alias()
	dbSelectArea('SRG')
	If dbSeek(SRA->RA_FILIAL+SRA->RA_Mat,.F.)
		cIndeniz   := fPHist82(SRA->RA_FILIAL,'32',SRG->RG_TipoRes,32,1)
	Else
		cIndeniz   := ' '	
	EndIf
	dbSelectArea(cAlias)

	If cIndeniz == "I"
	   cIndeniz := "1"
	Else
	   cIndeniz := "2"
	Endif
	
	//
	cGrInstru := "1"
	If SRA->RA_GRINRAI == "10"
		cGrInstru := "1"
	Elseif SRA->RA_GRINRAI == "20"
		cGrInstru := "2"					
	Elseif SRA->RA_GRINRAI == "25"
		cGrInstru := "3"					
	Elseif SRA->RA_GRINRAI == "30"
		cGrInstru := "4"					
	Elseif SRA->RA_GRINRAI == "35"
		cGrInstru := "5"					
	Elseif SRA->RA_GRINRAI == "40"
		cGrInstru := "6"					
	Elseif SRA->RA_GRINRAI == "45"
		cGrInstru := "7"					
	Elseif SRA->RA_GRINRAI == "50"
		cGrInstru := "8"					
	Else
		cGrInstru := "9"					
	Endif

	//+--------------------------------------------------------------+
	//ฆ Pesquisando os Tres Ultimos Salarios ( Datas e Valores )     ฆ
	//+--------------------------------------------------------------+	
	cTipo   	:= "A"
	nSalMes		:= 0				   				//--  Incluso verbas que incorporam  ao salario 
	nVAlUlt 	:= nValPen		:= nValant		:=0
	NValUltSal	:= nValPenSal	:= nValAntSal	:=0
	dDTUltSal 	:= dDemissao						//-- Data do Ultimo Salario 

	//-- Data do Penultimo Salario.
	dDTPenSal := If(Month(dDemissao)-1 != 0, CtoD('01/' +StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )
	If MesAno(dDtPenSal) < MesAno(dAdmissao)
		dDTPenSal 	:= CTOD("  /  /  ")
 		nValPenSal 	:= 0.00
    Endif

	//-- Data do Antepenultimo Salario.	
	dDTAntSal := If(Month(dDtPenSal)-1 != 0,CtoD('01/'+StrZero(Month(dDtPenSal)-1,2)+'/'+Right(StrZero(Year(dDtPenSal),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDtPenSal)-1,4),2)) )	
	If MesAno(dDtAntSal) < MesAno(dAdmissao)
		dDTAntSal 	:= CTOD("  /  /  ")
		nValAntSal 	:= 0.00
    Endif
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณBusca Salario ( + verba incorporada)do Movto Acumulado                 ณ  
	ณSomar verbas informadas nos parametros                                 ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	//fSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,cTipo)
	nSalMes		:= SRG->RG_SALMES   				//--  Incluso verbas que incorporam  ao salario 
	nValUltSal 	:= nSalMes
		
	fSomaSrr(StrZero(Year(dDTUltSal),4), StrZero(Month(dDTUltSal),2), cVerbas, @nValUlt)
    //--Penultimo 
	If !Empty(dDTPenSal)              
		nValPen := fBuscaAcm(cVerbas + acodfol[318,1]  ,,dDTPenSal,dDTPenSal,"V")	//-- Salario do mes + verbas que incorporaram  ao salario
		//--Pesquisa no movimento mensal quando o mes corrente estiver aberto
		//--e nao encontrar salario nos acumulados anuais.
		If nValPen == 0 .And. MesAno(dDTPenSal) == SuperGetMv("MV_FOLMES")
			If SRC->(Dbseek(SRA->(RA_FILIAL+RA_MAT)))
				While !SRC->(eof()) .And. SRA->(RA_FILIAL+RA_MAT) == SRC->(RC_FILIAL+RC_MAT)
					If SRC->RC_PD $cVerbas + acodfol[318,1]
						nValPen += SRC->RC_VALOR
					Endif
					SRC->(dbskip())
				Enddo
			Endif
		Endif
	Endif
	//--Antepenultimo
	If !Empty(dDTAntSal)
		nValAnt := fBuscaAcm(cVerbas + acodfol[318,1], NIL, dDTAntSal, dDTAntSal, "V") 	//-- Salario do mes + verbas que incorporaram  ao salario 
	Endif
	
	//--Somar verbas informardas aos salarios
	nValUltSal += If( nVerbRes == 1, nValUlt, 0 )
	nValPenSal += nValPen
	nValAntSal += nValAnt

	/*
	If SM0->M0_CODIGO = 'IT'	
		nValAntSal := MV_PAR16	
		nValPenSal := MV_PAR18
		nValUltSal := MV_PAR20
	Endif
	*/
		

	//+--------------------------------------------------------------+
	//ฆ** Inicio da Impressao do Requerimento de Seguro-Desemprego **ฆ
	//+--------------------------------------------------------------+	
	For Nx := 1 to nVias
		If nCont >= 2
			SetPrc(0,0)
			nLinha	:= 10
		Else
			nCont:= nCont + 1
		Endif

		If nTipoRel == 1
			fImpSegGraf(Nx)
		Else
			fImpSeg()
		EndIf			
			
		If aReturn[5] != 1
			If lFirst  
				fInicia(cString)
				nLinha	:= 10
				Pergunte("GPR30A",.T.)                 
				lFirst	:= If(MV_PAR01 = 1 ,.F. , .T. )    //  Impressao Correta ? Sim/Nao 
				If lFirst == .T.       						// Se impressao esta incorreta, zera contador para imprimir o numero de vias correto
					nx := 0 
					Loop 
				EndIf
			EndIf    
    	Endif
	Next Nx

	//+--------------------------------------------------------------+
	//ฆ** Final  da Impressao do Requerimento de Seguro-Desemprego **ฆ
	//+--------------------------------------------------------------+
	dbSelectArea("SRA")
	dbSkip()	
EndDo	

//+--------------------------------------------------------------+
//ฆ Termino do Relatorio.                                        ฆ
//+--------------------------------------------------------------+
dbSelectArea( 'SRA' )
RetIndex('SRA')
dbSetOrder(1)   
dbGoTop()
Set Device To Screen

If aReturn[5] == 1 .And. nTipoRel != 1
	Set Printer To
	dbCommitAll()
	OurSpool(WnRel)
Endif

MS_Flush()

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImpSeg   บAutor  ณMicrosiga           บ Data ณ  10-01-02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do Requerimento de Seguro-Desemprego			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fImpSeg()
Local nColIni	:= 08
//+--------------------------------------------------------------+
//ฆ** Inicio da Impressao do Requerimento de Seguro-Desemprego **ฆ
//+--------------------------------------------------------------+
@ nLinha, nColIni PSAY  fPluSpace( cNome ) 
nLinha	+= 3 
@ nLinha, nColIni PSAY  fPluSpace( cMae )
nLinha	+= 3 
@ nLinha, nColIni PSAY fPluSpace( cEnd )
nLinha	+= 3
@ nLinha, nColini      PSAY fPluSpace( cCompl )
@ nLinha, nColIni+ 30  PSAY fPluSpace( cCep )
@ nLinha, nColIni+ 50  PSAY fPluSpace( cUF )
@ nLinha, nColIni+ 56  PSAY fPluSpace( cFone )
nLinha	+= 3 
@ nLinha, nColIni      PSAY fPluSpace( cPIS )
@ nLinha, nColIni+ 26  PSAY fPluSpace( cCTPS ) 
@ nLinha, nColIni+ 40  PSAY fPluSpace( cCTSerie )
@ nLinha, nColIni+ 46  PSAY fPluSpace( cCTUF )
@ nLinha, nColIni+ 54  PSAY fPluSpace( cCPF )
nLinha	+= 3
@ nLinha, nColIni+ 08  PSAY fPluSpace( cTpInsc )
@ nLinha, nColIni+ 13  PSAY fPluSpace( cCgc )
@ nLinha, nColIni+ 44  PSAY fPluSpace( cCNAE )
nLinha	+= 3
@ nLinha, nColIni      PSAY fPluSpace( cCBO )
@ nLinha, nColIni+ 14  PSAY cOcup 
nLinha	+= 6
@ nLinha, nColIni     PSAY fPluSpace( StrZero(Day(dAdmissao),2) ) + fPluSpace( StrZero(Month(dAdmissao),2) )+ fPluSpace( Right(StrZero(Year(dAdmissao),4),2))
@ nLinha, nColIni+ 15 PSAY fPluSpace( StrZero(Day(dDemissao),2) ) + fPluSpace( StrZero(Month(dDemissao),2) )+ fPluSpace( Right(StrZero(Year(dDemissao),4),2))
@ nLinha, nColIni+ 38 PSAY fPluSpace( cSexo )
@ nLinha, nColIni+ 50 PSAY fPluSpace( cGrInstru )
@ nLinha, nColIni+ 55 PSAY fPluSpace( StrZero(Day(dNascim),2) )+ fPluSpace( StrZero(Month(dNascim),2)) + fPluSpace( Right(StrZero(Year(dNascim),4),2))
@ nLinha, nColIni+ 70 PSAY fPluSpace( cHrSemana )
nLinha	+= 3
                                                       
/*
If SM0->M0_CODIGO == 'IT'
	@ nLinha, nColIni     PSAY fPluSpace(mv_par15)
	@ nLinha, nColIni+ 05 PSAY fPluSpace( Transform(nValAntSal*100,'@E 9999999999' )) // mv_par16
	@ nLinha, nColIni+ 25 PSAY fPluSpace(mv_par17)
	@ nLinha, nColIni+ 30 PSAY fPluSpace( Transform(nValPenSal*100,'@E 9999999999')) // mv_par18
	@ nLinha, nColIni+ 51 PSAY fPluSpace(mv_par19)
	@ nLinha, nColIni+ 56 PSAY fPluSpace( Transform(nValUltSal*100,'@E 9999999999')) // mv_par20
Endif
*/

	@ nLinha, nColIni     PSAY fPluSpace( StrZero(Month(dDtAntSal),2))
	@ nLinha, nColIni+ 05 PSAY fPluSpace( Transform(nValAntSal*100,'@E 9999999999' ))

	@ nLinha, nColIni+ 25 PSAY fPluSpace( StrZero(Month(dDtPenSal),2) )
	@ nLinha, nColIni+ 30 PSAY fPluSpace( Transform(nValPenSal*100,'@E 9999999999'))

	@ nLinha, nColIni+ 51 PSAY fPluSpace( StrZero(Month(dDtUltSal),2) )
	@ nLinha, nColIni+ 56 PSAY fPluSpace( Transform(nValUltSal*100,'@E 9999999999'))
	



nLinha	+= 3
@ nLinha, nColIni     PSAY fPluSpace( Transform( ( nValAntSal+nValPenSal+nValUltSal) *100,'@E 9999999999'))
@ nLinha, nColIni+ 72 PSAY fPluSpace( cNMeses  )
nLinha	+= 3
@ nLinha, nColIni+ 20 PSAY fPluSpace( c6Salarios)
@ nLinha, nColIni+ 39 PSAY fPluSpace( cIndeniz  )
nLinha	+= 15
@ nLinha, nColIni PSAY fPluSpace( cPis )
nLinha	+= 3
@ nLinha, nColIni PSAY fPluSpace( cNome )
nLinha	+= 09
@ nLinha, 00 PSAY ' '

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSomaSRR  บAutor  ณMicrosiga           บ Data ณ  10-01-02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Soma Verbas do arquivo SRR								  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑฬParametrosณ CAno 	-Ano do ultimo salario                            บฑฑ
ฑฑบ          ณ CMes 	-Mes do ultimo salario                            บฑฑ
ฑฑบ          ณ CVerbas  -Verbas a serem somada                            บฑฑ
ฑฑบ          ณ nValor   -Valor das verbas                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
static Function fSomaSrr(cAno, cMes, cVerbas, nValor)

Local lRet    := .T.
Local cPesq   := ''
Local cFilSRR := xFilial('SRR', SRA->RA_FILIAL)
Local dDtGerar:= ctod('  /  /  ')	

//-- Reinicializa Variaveis
cAno    := If(Empty(cAno), StrZero(Year(dDTUltSal),4), cAno)
cMes    := If(Empty(cMes), StrZero(Month(dDTUltSal),2), cMes)
cVerbas := If(Empty(cVerbas), '', AllTrim(cVerbas))
nValor  := If(Empty(nValUlt) .OR. ValType(nValUlt) != 'N', 0, nValUlt)

Begin Sequence

	If Empty(cVerbas) .Or. Len(cVerbas) < 3 .Or. ;
		!SRR->(dbSeek((cPesq := cFilSRR + SRA->RA_MAT +'R'+ cAno + cMes), .T.))
		lRet := .F.
		Break
	EndIf


	dbSelectarea('SRG')
	If dbSeek(SRA->RA_FILIAL+SRA->RA_Mat,.F.)
		dDtGerar := SRG->RG_DTGERAR
		dbSelectArea("SRR")
		dbSeek(SRA->RA_FILIAL+SRA->RA_Mat,.F.)
		While !EOF() .And. RR_FILIAL+RR_MAT == cFil+cMat
			If dDtGerar == SRR->RR_DATA
				If SRR->RR_PD $ cVerbas
					If PosSrv(SRR->RR_PD,SRR->RR_FILIAL,"RV_TIPOCOD") $ "1*3"
				  		nValor += SRR->RR_VALOR
					Else
						nValor -= SRR->RR_VALOR
					EndIf
				Endif
			EndIf
			SRR->(DbSkip())
		Enddo	
	EndIf

	If nValor == 0
		lRet := .F.
		Break
	EndIf

End Sequence
dbSelectArea('SRA')
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfInicia   บAutor  ณR.H.Natie           บ Data ณ  11/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicializa Impressao                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fInicia(cString)

//--Lendo os Driver's de Impressora e gravando no Array--// 
MS_Flush()
aDriver := ReadDriver()
If nLastKey == 27
	Return .F.
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return  .F. 
Endif
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTransVerbaบAutor ณR.H.                บ Data ณ  17/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function  fTransVerba()
Local cPD	:= ""
Local nX	:= 0

For nX := 1 to Len(cVerbas) step 3 
	cPD += Subs(cVerbas,nX,3)
	cPD += "/" 
Next nX

cVerbas:= cPD

Return( )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPluSpace บAutor  ณR.H.                บ Data ณ  14/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function  fPluSpace( cDet )
Local cDetF :=""
Local nX	:= 0

For nX := 1 to Len(cDet)
	cDetF += Subs(cDet,nX,1) + space(1)
Next nX    

Return(cDetF)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณfImpSegGraf บAutor  ณMicrosiga           บ Data ณ 10-01-09  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao GRAFICA do Requerimento de Seguro-Desemprego     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fImpSegGraf( nNumVias )

Local nLinha   := 340
Local nColun   := 040
Local nTresSal := 0
Local cDtAdmis := ""
Local cDtDemis := ""
Local cDtNasci := ""

oPrint:StartPage() //Inicia uma nova pagina

oPrint:say( nLinha, nColun, fIncSpace(cNome), oFont10, 100 ) //Nome
nLinha += 150

oPrint:say( nLinha, nColun, fIncSpace(cMae),  oFont10, 100 ) //Nome da Mae
nLinha += 160

oPrint:say( nLinha, nColun, fIncSpace(cEnd),  oFont10, 100 ) //Endereco
nLinha += 150
                                                                       
oPrint:say( nLinha, nColun,      fIncSpace(cCompl), oFont10, 100 ) //Complemento endereco
oPrint:say( nLinha, nColun+0990, fIncSpace(cCep),   oFont10, 100 ) //CEP
oPrint:say( nLinha, nColun+1480, fIncSpace(cUF),    oFont10, 100 ) //UF
oPrint:say( nLinha, nColun+1690, fIncSpace(cFone),  oFont10, 100 ) //Telefone
nLinha += 140
                                                                     
oPrint:say( nLinha, nColun,      fIncSpace(cPIS ),    oFont11, 100 ) //Pis
oPrint:say( nLinha, nColun+0750, fIncSpace(cCTPS),    oFont11, 100 ) //CTPS
oPrint:say( nLinha, nColun+1178, fIncSpace(cCTSerie), oFont11, 100 ) //Serie CTPS
oPrint:say( nLinha, nColun+1358, fIncSpace(cCTUF),    oFont11, 100 ) //UF CTPS
oPrint:say( nLinha, nColun+1610, fIncSpace(cCPF),     oFont11, 100 ) //CPF
nLinha += 160        

oPrint:say( nLinha, nColun+0210, fIncSpace(cTpInsc), oFont11, 100 ) //Tipo Inscricao
oPrint:say( nLinha, nColun+0370, fIncSpace(cCgc),    oFont11, 100 ) //CNPJ/CEI
oPrint:say( nLinha, nColun+1310, fIncSpace(cCNAE),   oFont11, 100 ) //Atividade economia
nLinha += 140       

oPrint:say( nLinha, nColun,      fIncSpace( Transform(cCBO,'@R 99999 9'),  oFont11, 100 ) ) //CBO
oPrint:say( nLinha, nColun+0400, fIncSpace(cOcup), oFont10, 100 ) //Ocupacao
nLinha += 300  

cDtAdmis := StrZero(Day(dAdmissao),2) + StrZero(Month(dAdmissao),2) + Right(StrZero(Year(dAdmissao),4),2)
cDtDemis := StrZero(Day(dDemissao),2) + StrZero(Month(dDemissao),2) + Right(StrZero(Year(dDemissao),4),2)
cDtNasci := StrZero(Day(dNascim),2)   + StrZero(Month(dNascim),2)   + Right(StrZero(Year(dNascim),4),2)

oPrint:say( nLinha, nColun,      fIncSpace(cDtAdmis),  oFont11, 100 ) //Data admissao
oPrint:say( nLinha, nColun+0430, fIncSpace(cDtDemis),  oFont11, 100 ) //Data dispensa
oPrint:say( nLinha, nColun+1100, fIncSpace(cSexo),     oFont10, 100 ) //Sexo
oPrint:say( nLinha, nColun+1480, fIncSpace(cGrInstru), oFont10, 100 ) //Grau de instrucao
oPrint:say( nLinha, nColun+1660, fIncSpace(cDtNasci),  oFont11, 100 ) //Data nascimento
oPrint:say( nLinha, nColun+2100, fIncSpace(cHrSemana), oFont10, 100 ) //Horas trabalhadas por semana
nLinha += 160


/*
If SM0->M0_CODIGO == 'IT'
	oPrint:say( nLinha, nColun,      fIncSpace (StrZero(Val(mv_par15),2)))  				 	//Mes antepenultimo salario
	oPrint:say( nLinha, nColun+0250, fIncSpace ( Transform(nValAntSal*100,'@E 9999999999') ) )		//Antepenultimo salario
	oPrint:say( nLinha, nColun+0750, fIncSpace (StrZero(Val(mv_par17),2)))						//Mes penultimo salario
	oPrint:say( nLinha, nColun+1010, fIncSpace ( Transform(nValPenSal*100,'@E 9999999999') ) )		//Penultimo salario
	oPrint:say( nLinha, nColun+1520, fIncSpace (StrZero(Val(mv_par19),2)))						//Mes ultimo salario
	oPrint:say( nLinha, nColun+1760, fIncSpace ( Transform(nValUltSal*100,'@E 9999999999') ) )		//Ultimo salario
Endif
*/


oPrint:say( nLinha, nColun,      fIncSpace ( StrZero(Month(dDtAntSal),2) ) )  				 	//Mes antepenultimo salario
oPrint:say( nLinha, nColun+0250, fIncSpace ( Transform(nValAntSal*100,'@E 9999999999') ) )		//Antepenultimo salario
oPrint:say( nLinha, nColun+0750, fIncSpace ( StrZero(Month(dDtPenSal),2)))						//Mes penultimo salario
oPrint:say( nLinha, nColun+1010, fIncSpace ( Transform(nValPenSal*100,'@E 9999999999') ) )		//Penultimo salario
oPrint:say( nLinha, nColun+1520, fIncSpace ( StrZero(Month(dDtUltSal),2)))						//Mes ultimo salario
oPrint:say( nLinha, nColun+1760, fIncSpace ( Transform(nValUltSal*100,'@E 9999999999') ) )		//Ultimo salario


nLinha += 150  

nTresSal := Transform( ( nValAntSal+nValPenSal+nValUltSal) *100,'@E 9999999999') 

oPrint:say( nLinha, nColun+0090, fIncSpace (nTresSal), oFont10, 100 ) //Soma 3 ultimos salarios
oPrint:say( nLinha, nColun+2180, fIncSpace (cNMeses),  oFont10, 100 ) //Qtd meses com vinculo ultimos 36 meses
nLinha += 150  

oPrint:say( nLinha, nColun+0580, fIncSpace(c6Salarios), oFont10, 100 ) //Recebeu ultimos 6 meses
oPrint:say( nLinha, nColun+1140, fIncSpace(cIndeniz),   oFont10, 100 ) //Aviso previo indenizado
nLinha += 725  
                
If nNumVias == 2      
	oPrint:say( nLinha, nColun,    fIncSpace(cPis),  oFont11, 100 ) //Pis 2o. Via
	nLinha += 140  
	
	oPrint:say( nLinha, nColun,    fIncSpace(cNome), oFont11, 100 ) //Nome 2o. Via
EndIf

oPrint:EndPage() //Finaliza a pagina

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIncSpace บAutor  ณMicrosiga           บ Data ณ  10-01-09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tratamento dos espacos para impressao no formato grafico   บฑฑ
ฑฑบ          ณ fonte Arial 10                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fIncSpace( cTexto )

	Local cTextoFim := ""
	Local nPos 		:= 1
	Local i 		:= 1  

	nQtdLetras := Len( cTexto )

	For i := 1 To nQtdLetras
		If Upper( SubStr( cTexto, nPos, 1 ) ) $ "I|-|1|-|,|.|:|'"
			cTextoFim += Space(1)
			cTextoFim += SubStr( cTexto, nPos, 1 ) + Space(3)					
		ElseIf Upper( SubStr( cTexto, nPos, 1 ) ) == " " 
			cTextoFim += Space(5)
		Else
			cTextoFim += SubStr( cTexto, nPos, 1 ) + Space(3)
		EndIf
		nPos++
	Next i    

Return(cTextoFim)
                       

     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX  บAutor  ณMicrosiga           บ Data ณ  10-01-09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta dicionario de dados                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AjustaSX()

Local aArea     := getArea()
Local aRegs     := {}
Local cPerg		:= "SEGDES"
Local cHelp13 	:= "" 
Local cHelp14 	:= "" 

Local aHelpPor  := {}
Local aHelpSpa  := {}
Local aHelpEng  := {}
                                
cHelp13 	:= ".GPRPPP19." 
cHelp14 	:= ".SEGDES01."

//Atualiza Help do Somar Verbas Rescisao
AADD(aHelpPor, 'Somar as verbas de rescisใo no valor')
AADD(aHelpPor, 'do ๚ltimo Salแrio ?'                 )

AADD(aHelpSpa, 'ฟSumar los conceptos de rescision al')
AADD(aHelpSpa, 'valor del ultimo Sueldo?'            )

AADD(aHelpEng, 'Add the types of funds in the amount')
AADD(aHelpEng, 'of last salary'                      )

PutSX1Help("P"+cHelp14, aHelpPor, aHelpSpa, aHelpEng )

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  ณ        Grupo  Ordem Pergunta Portugues            Pergunta Espanhol            Pergunta Ingles            Variavel      Tipo  	Tamanho Decimal Presel  GSC   	Valid       	                      Var01      	Def01       DefSPA1          	DefEng1      Cnt01    Var02  	Def02   	         DefSpa2              DefEng2	   	      Cnt02     Var03 	Def03    	DefSpa3   	DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp    ณ
  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
Aadd(aRegs,{cPerg,"13","Tipo de Impressao ?"         ,"ฟTipo de Impressao ?"      , "Tipo de Impressao ?   " , "mv_chd"    ,"N"    ,1		,0		,2		,"C"	,""									 ,"MV_PAR13"   ,"Grafico"	,"Grafico"			,"Grafico"	,""		,""			,"Zebrado"			,"Zebrado"			,"Zebrado"			,""			,""		,""			,""			,""				,""		,""		,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,"S"	, 			, 			, 			,cHelp13})
aAdd(aRegs,{cPerg,"14","Somar verbas Resc ?"         ,"ฟSomar verbas Resc ?"      , "Somar verbas Resc ?   " , "mv_che"    ,"N"	,1		,0		,0		,"C"	,""	                     	         ,"MV_PAR14"   ,"Sim "		,"Si"		     	,"Yes "		,""		,""			,"Nao" 	            ,"No"		        ,"No"			    ,""			,""		,""			,""			,""				,""		,""		,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,"" 	,"S"	,aHelpPor	,aHelpSpa	,aHelpEng   ,cHelp14})

ValidPerg( aRegs, cPerg, .T. )

RestArea( aArea )

Return
