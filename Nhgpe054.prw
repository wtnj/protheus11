#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHGPE054  ºAutor  ³Marcos R. Roquitski º Data ³  21/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Requerimento de seguro-desemprego.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE 'SEGDES.CH'

User Function NhGpe054()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTIT,CDESC1,CDESC2,CDESC3,CSTRING,CALIAS")
SetPrvt("AORD,WNREL,CPERG,CFILANTE,LEND,LFIRST")
SetPrvt("ARETURN,AINFO,NLASTKEY,NSALARIO,NSALHORA,NSALDIA")
SetPrvt("NSALMES,NORDEM,CFILDE,CFILATE,CMATDE,CMATATE")
SetPrvt("CCCDE,CCCATE,NVIAS,DDTBASE,CVERBAS,DDEMIDE,DDEMIATE")
SetPrvt("CNOME,CEND,CCEP,CUF,CFONE,CMAE,CTPINSC")
SetPrvt("CCGC,CCNAE,CPIS,CCTPS,CCTSERIE,CCTUF")
SetPrvt("CCBO,COCUP,DADMISSAO,DDEMISSAO,CSEXO,CGRINSTRU")
SetPrvt("DNASCIM,CHRSEMANA,CMAT,CFIL,CCC,CNMESES")
SetPrvt("C6SALARIOS,CINDENIZ,DDTULTSAL,DDTPENSAL,DDTANTSAL,CTIPO")
SetPrvt("CVALOR,NVALULT,NVALPEN,NVALANT,AVALSAL,NLUGAR")
SetPrvt("NVALULTSAL,NVALPENSAL,NVALANTSAL,NX,SALMES,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> #INCLUDE 'SEGDES.CH'

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	#DEFINE PSAY SAY

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ SegDes   ¦ Autor ¦ R.H. - Fernando Joly  ¦ Data ¦ 10.10.96 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Requerimento de Seguro-Desemprego - S.D.                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ RDMake ( DOS e Windows )                                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Especifico para Clientes MicroSiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦         ATUALIZACOES SOFRIDAS DESDE A CONSTRUÇAO INICIAL.             ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦Programador ¦ Data   ¦ BOPS ¦  Motivo da Alteracao                     ¦¦¦
¦¦+------------+--------+------+------------------------------------------¦¦¦
¦¦¦Aldo        ¦10/09/97¦xxxxxx¦Acerto nos valores dos tres ult.aumentos. ¦¦¦
¦¦¦Cristina    ¦02/06/98¦xxxxxx¦Conversao para outros idiomas.            ¦¦¦
¦¦¦Fernando J. ¦30/06/98¦14205a¦Inclusao da funçäo fSomaAcl para a soma   ¦¦¦
¦¦¦            ¦        ¦      ¦de verbas do acumulado dos 3 últimos      ¦¦¦
¦¦¦            ¦        ¦      ¦meses ao Salario.                         ¦¦¦
¦¦¦Kleber      ¦24/09/98¦XXXXXX¦Criada um novo grupo de perguntas(SEGDES).¦¦¦
¦¦¦Kleber      ¦07/10/98¦XXXXXX¦Acerto do acumulados de verbas.           ¦¦¦
¦¦¦Kleber      ¦19/02/99¦XXXXXX¦Na perg GPR30A Imprimir uma via do Form.  ¦¦¦
¦¦¦Mauro       ¦05/07/99¦17893a¦Apos Impress¦o posicionar SRA no Inicio.  ¦¦¦
¦¦¦Kleber      ¦02/08/99¦18632b¦Alt.Param. Ano (p/4dig.) Funcao FSomaACL. ¦¦¦
¦¦¦Marina      ¦15/12/99¦XXXXXX¦Acerto data/salario dos 3 ultimos meses de¦¦¦
¦¦¦            ¦        ¦      ¦Acordo com a data de admissao.            ¦¦¦
¦¦¦Marina      ¦15/12/99¦XXXXXX¦Acerto do campo Grau de Instru‡ao de acor-¦¦¦
¦¦¦            ¦        ¦      ¦com a tabela de INSS(1 a 9).              ¦¦¦
¦¦¦Marina      ¦15/12/99¦XXXXXX¦Inclusao dos parametros Data Demissao De e¦¦¦
¦¦¦            ¦        ¦      ¦Data Demissao Ate.                        ¦¦¦
¦¦¦Emerson     ¦31/03/00¦XXXXXX¦Retirada a funcao SetPrc - Probl. Protheus¦¦¦ 
¦¦¦Marina      ¦30/08/00¦      ¦Validacao Filial/Acesso.Retirada parte DOS¦¦¦
¦¦¦Natie       ¦05/02/01¦XXXXXX¦Inclusao da Pergunte "Compl.Verbas Acumul"¦¦¦
¦¦¦            ¦        ¦      ¦Alteracao Ordem Pergunte Dt Demis.De/Ate  ¦¦¦
¦¦¦            ¦        ¦      ¦Retirada FSomaAcl()para ultimo salario e  ¦¦¦
¦¦¦            ¦        ¦      ¦Inclusao fc fSomaSRR()-Soma verbas do SRR ¦¦¦
¦¦¦            ¦        ¦      ¦ao inves do SRC                           ¦¦¦
¦¦¦Natie       ¦22/03/01¦008162¦Retirada chr(15) na impressao             ¦¦¦
¦¦¦Natie       ¦23/04/01¦------¦Alteracao de Pergunte                     ¦¦¦
¦¦¦Natie       ¦25/04/01¦008941¦Acerto montagem  dDtPenSal e dDtAntSal    ¦¦¦
¦¦¦Natie       ¦20/06/01¦------¦Acerto Val.Salariais qdo ha aumento sal.  ¦¦¦
¦¦¦Natie       ¦29/08/01¦009963¦PrnFlush-Descarrega spool impressao teste ¦¦¦
¦¦¦Priscila    ¦28/12/01¦xxxxxx¦Acerto na contagem dos Meses Trabalhados  ¦¦¦
¦¦¦            ¦        ¦      ¦Utilizando a Funcao fMesesTrab.           ¦¦¦
¦¦¦Natie       ¦11/12/01¦009963¦Acerto Impressao-teste                    ¦¦¦
¦¦¦Priscila    ¦25/06/02¦015780¦Ajuste p/ Impressao, qdo Cal.Resc. mes se ¦¦¦
¦¦¦Priscila    ¦        ¦      ¦guinte e nao foi feito o Fechamento Atual.¦¦¦
¦¦¦Priscila    ¦09/09/02¦------¦Ajuste no salto de pagina.                ¦¦¦
¦¦¦            ¦	    ¦------¦Acerto nos Valores dos 3 Ultimos Salarios.¦¦¦
¦¦¦            ¦	    ¦------¦Ajuste para posicionar correto no SRA.    ¦¦¦
¦¦¦Priscila    ¦17/09/02¦------¦Ajuste na impressao em Disco.             ¦¦¦
¦¦¦+----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

//+--------------------------------------------------------------+
//¦ Define Variaveis Locais (Basicas)                            ¦
//+--------------------------------------------------------------+
cTit     := STR0001 // ' REQUERIMENTO DE SEGURO-DESEMPREGO - S.D. '
cDesc1   := STR0002 // 'Requerimento de Seguro-Desemprego - S.D.'
cDesc2   := STR0003 // 'Será impresso de acordo com os parametros solicitados pelo'
cDesc3   := STR0004 // 'usuario.'
cString  := 'SRA'
cAlias   := 'SRA'
aOrd     := {STR0005,STR0006}	// 'Matricula'###'Centro de Custo'
WnRel    := 'SEGDES'
cPerg    := 'SEGDES'                    
cFilAnte := '··'
lEnd     := .F.
lFirst   := .T.
aReturn  := { STR0007,1,STR0008,2,2,1,'',1 }	// 'Zebrado'###'Administraçäo'	
aInfo    := {}
nLastKey := 0
nSalario := 0 
nSalHora := 0
nSalDia  := 0
nSalMes  := 0
nLinha	 := 0
aRegs    := {}


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cAcessaSRA	:= &( " { || " + ChkRH( "SEGDES" , "SRA" , "2" ) + " } " )

//+--------------------------------------------------------------+                      
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte('SEGDES',.F.)
   
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01        //  FiLial De                                ¦
//¦ mv_par02        //  FiLial Ate                               ¦
//¦ mv_par03        //  Matricula De                             ¦
//¦ mv_par04        //  Matricula Ate                            ¦
//¦ mv_par05        //  Centro De Custo De                       ¦
//¦ mv_par06        //  Centro De Custo Ate                      ¦
//¦ mv_par07        //  Nº de Vias                               ¦
//¦ mv_par08        //  Data Base                                ¦
//¦ mv_par09        //  Verbas a serem somadas ao Salario        ¦
//¦ mv_par10        //  Compl.Verbas a somar ao Salario          ¦
//¦ mv_par11        //  Data Demissao De                         ¦
//¦ mv_par12        //  Data Demissao Ate                        ¦
//+--------------------------------------------------------------+
   
//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,'P')

//+--------------------------------------------------------------+
//¦ Carregando variaveis mv_par?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
nOrdem  := aReturn[8]
cFilDe  := If(!Empty(mv_par01), mv_par01 ,'00')
cFilAte := If(!Empty(mv_par02), mv_par02 ,'99')
cMatDe  := If(!Empty(mv_par03), mv_par03,'00000')
cMatAte := If(!Empty(mv_par04), mv_par04,'99999')
cCCDe   := If(!Empty(mv_par05), mv_par05,'0        ')
cCCAte  := If(!Empty(mv_par06), mv_par06,'999999999')
nVias   := If(!Empty(mv_par07), If(mv_par07<=0,1,mv_par07),1)
dDtBase := If(!Empty(mv_par08), If(Empty(mv_par08),dDataBase,mv_par08),dDataBase)
cVerbas := ALLTRIM(mv_par09)
cVerbas += ALLTRIM(mv_par10)
dDemiDe  := mv_par11
dDemiAte := mv_par12
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Impressao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! fInicia(cString)
	Return
Endif     

If aReturn[5] = 1
	SetPrc(0,0)
EndIf

RptStatus({|| fSegDes()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(fSegDes)})
Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	Function fSegDes
Static Function fSegDes()

dbSelectArea('SRA')
dbSetOrder(nOrdem)
SetRegua(RecCount())
dbSeek(cFilDe + cMatDe,.T.)

Do While !Eof()	
	//+--------------------------------------------------------------+
	//¦ Incrementa Regua de Processamento.                           ¦
	//+--------------------------------------------------------------+
	IncRegua()

	//+--------------------------------------------------------------+
	//¦ Processa Quebra de Filial.                                   ¦
	//+--------------------------------------------------------------+
	If SRA->RA_FILIAL #cFilAnte
		If	!fInfo(@aInfo,SRA->RA_FILIAL)
			dbSkip()
			Loop
		Endif		
		cFilAnte := SRA->RA_FILIAL		
	Endif		
	
	//+--------------------------------------------------------------+
	//¦ Cancela Impres¦o ao se pressionar <ALT> + <A>.               ¦
	//+--------------------------------------------------------------+
	If lEnd
		@ pRow()+ 1, 00 PSAY STR0009 // ' CANCELADO PELO OPERADOR . . . '
		Exit
	EndIF
	
	//+--------------------------------------------------------------+
	//¦ Consiste Parametrizaç¦o do Intervalo de Impress¦o.           ¦
	//+--------------------------------------------------------------+
	If 	(SRA->RA_Filial < cFilDe)	.Or. (SRA->RA_FILIAL > cFilAte)	.Or.;
		(SRA->RA_MAT < cMatDe)		.Or. (SRA->RA_MAT > cMatAte)	.Or.;
		(SRA->RA_CC < cCcDe)		.Or. (SRA->RA_CC > cCCAte) 
        SRA->(dbSkip())
		Loop
	EndIf
	//+--------------------------------------------------------------+
	//¦ Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         ¦
	//+--------------------------------------------------------------+
	cAlias := Alias()                                                            
	lAchouSrg := .F.
	dbSelectArea('SRG')     
	If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
		While ! EOF() .And. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			If (SRG->RG_DATADEM < dDemiDe) .Or. (SRG->RG_DATADEM > dDemiAte) 
				SRG->(dbSkip())
				Loop
			EndIf
			lAchouSrg := .T.
			Exit
		Enddo
	EndIf    
		/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Caso nao encontre o funcionario no SRG, le o proximo funcionario no SRA³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/	
	If ! lAchouSrg .OR.(SRG->RG_DATADEM < dDemiDe) .Or. (SRG->RG_DATADEM > dDemiAte) 
		dbSelectArea("SRA")
		dbSkip()
		Loop
	ENdif
	

  	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		dbSelectArea("SRA")
   		dbSkip()
  		Loop
	EndIF


	//--Carregar a descricao do tipo da rescisao		
	cIndeniz   := fPHist82(SRG->RG_Filial,'32',SRG->RG_TipoRes,32,1)
	
	//+--------------------------------------------------------------+
	//¦ Variaveis utilizadas na impressao.                           ¦
	//+--------------------------------------------------------------+
	cNome      := Left(SRA->RA_Nome,30)
	cEnd       := AllTrim(Left(SRA->RA_Endereco,30)) + ' ' + AllTrim(Left(SRA->RA_Complem,15)) + ' , ' + AllTrim(Left(SRA->RA_Bairro,15))
	cEnd       := cEnd + Space(60-Len(cEnd))				  
	cCep       := Transform(Left(SRA->RA_Cep,8),'@R #####-###')	
	cUF        := Left(SRA->RA_Estado,2)
	cFone      := Left(SRA->RA_Telefon,8)
	cMae       := Left(SRA->RA_Mae,40)
	cTpInsc    := If(aInfo[15]==1,'2','1') //-- 1=C.G.C. 2=C.E.I.
	cCgc       := Transform(Left(aInfo[8],14),If(cTpInsc=='1','@R ##.###.###/####-##','@R '))
	cCNAE      := Left(aInfo[16],5)
	cPis       := Left(SRA->RA_Pis,11)
	cCTPS      := Left(SRA->RA_NumCp,7)
	cCTSerie   := Left(SRA->RA_SerCp,5)		
	cCTUF      := Left(SRA->RA_UFCP,2)
	cCBO       := Left(SRA->RA_CBO,5)
	cOcup      := DescFun(SRA->RA_CodFunc,SRA->RA_Filial)
	dAdmissao  := SRA->RA_Admissa
	dDemissao  := SRG->RG_DATADEM
	cSexo      := If(Sra->RA_Sexo=='M','1','2')
	dNascim    := SRA->RA_Nasc
	cHrSemana  := StrZero(Int(SRA->RA_HrSeman),2)
	cMat       := Left(SRA->RA_Mat,6)
	cFil       := Left(SRA->RA_Filial,2)
	cCC        := Left(SRA->RA_CC,9)
	If Val(SRA->RA_MesTrab)> 0
		cNMeses    := If(Val(SRA->RA_MesTrab)<=36,Left(SRA->RA_MesTrab,2),'36')
	Else
		//-- Calculo do numero de meses trabalhados. 
		cNMeses    := fMesesTrab (SRA->RA_ADMISSA,SRG->RG_DATADEM)
		cNMeses    := If(cNMeses<=36,StrZero(cNMeses,2),'36')
	Endif
	c6Salarios := If(Val(cNMeses)+SRA->RA_MesesAnt>=6,'1','2')
	
	//+--------------------------------------------------------------+
	//¦ Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         ¦
	//+--------------------------------------------------------------+
	cAlias := Alias()
	dbSelectArea('SRG')
	If dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.)
		cIndeniz   := fPHist82(SRA->RA_Filial,'32',SRG->RG_TipoRes,32,1)
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
	//¦ Pesquisando os Tres Ultimos Salarios ( Datas e Valores )     ¦
	//+--------------------------------------------------------------+	
	//-- Data do Ultimo Salario.
	dDTUltSal := dDemissao

	//-- Data do Penultimo Salario.
	dDTPenSal := If(Month(dDemissao)-1#0,CtoD('01/' +StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )
	If MesAno(dDtPenSal) < MesAno(dAdmissao)
	  dDTPenSal := CTOD("  /  /  ")
    Endif

	//-- Data do Antepenultimo Salario.	
	dDTAntSal := If(Month(dDtPenSal)-1#0,CtoD('01/'+StrZero(Month(dDtPenSal)-1,2)+'/'+Right(StrZero(Year(dDtPenSal),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDtPenSal)-1,4),2)) )	
	If MesAno(dDtAntSal) < MesAno(dAdmissao)
	  dDTAntSal := CTOD("  /  /  ")
    Endif
	
	cTipo   := "A"
	cValor  := SRA->RA_SALARIO
	nSalario:= 0

	fCalcSal()
	
	nValUlt := 0
	nValPen := 0
	nValAnt := 0

    // Arquivo do mes atual
	fSomaSrr(StrZero(Year(dDTUltSal),4), StrZero(Month(dDTUltSal),2), cVerbas, @nValUlt)	

	If !Empty(dDTPenSal)
		fSomaAcl(StrZero(Year(dDTPenSal),4), StrZero(Month(dDTPenSal),2), cVerbas, @nValPen)
	Endif
	If !Empty(dDTAntSal)
		fSomaAcl(StrZero(Year(dDTAntSal),4), StrZero(Month(dDTAntSal),2), cVerbas, @nValAnt)
	Endif
	
	aValSal:={}
	Aadd(aValSal,{Right(StrZero(Year(dDTUltSal),4),2)+StrZero(Month(dDTUltSal),2) ,nSalario+nValUlt,"A"})
	If !Empty(dDTPenSal)
		Aadd(aValSal,{Right(StrZero(Year(dDTPenSal),4),2)+StrZero(Month(dDTPenSal),2) ,nSalario+nValPen," "})
	Endif
	If !Empty(dDTAntSal)
		Aadd(aValSal,{Right(StrZero(Year(dDTAntSal),4),2)+StrZero(Month(dDTAntSal),2) ,nSalario+nValAnt," "})
	Endif
	
	cAlias := Alias()
	dbSelectArea('SR3')	
	dbSeek(SRA->RA_Filial+SRA->RA_Mat,.f.)
	While !Eof() .And. SRA->RA_Filial+SRA->RA_Mat == SR3->R3_Filial+SR3->R3_Mat
		nLugar:=aScan(aValSal,{ |x| x[1] == Right(StrZero(Year(SR3->R3_DATA),4),2)+StrZero(Month(SR3->R3_DATA),2)} )
		IF nLugar > 0 
			cValor  := SR3->R3_VALOR
		Endif		
		fCalcSal()
		If nLugar > 0
			If nLugar == 1 
			   aValSal[nLugar,2] := nSalario + nValUlt
			ElseIf nLugar == 2
			   aValSal[nLugar,2] := nSalario + nValPen
			ElseIf nLugar == 3
			   aValSal[nLugar,2] := nSalario + nValAnt
			EndIf
		Else
			IF StrZero(Year(SR3->R3_DATA),4) + StrZero(Month(SR3->R3_DATA),2) <= MesAno(dDTAntSal)
			   aValSal[3,2] := nSalario + nValAnt
			Endif			   
			If StrZero(Year(SR3->R3_DATA),4) + StrZero(Month(SR3->R3_DATA),2) <= MesAno(dDTPenSal)
			   aValSal[2,2] := nSalario + nValPen
		    Endif   		   
		Endif
		dbSkip()
	EndDo	

	nValUltSal := aValSal[1,2]	
	If Len(aValSal) >= 2
		nValPenSal := aValSal[2,2]
	Else
		nValPenSal := 0
	Endif
	If Len(aValSal) >= 3	
		nValAntSal := aValSal[3,2]
	Else
		nValAntSal := 0
	Endif

	dbSelectArea(cAlias)

	//+--------------------------------------------------------------+
	//¦** Inicio da Impressao do Requerimento de Seguro-Desemprego **¦
	//+--------------------------------------------------------------+	
	For Nx := 1 to nVias
		fImpSeg()
		If aReturn[5] # 1
			If lFirst  
				fInicia()
				Pergunte("GPR30A",.T.)                 
				lFirst	:= If(mv_par01 = 1 ,.F. , .T. )    //  Impressao Correta ? Sim/Nao 
				If lFirst == .T.       						// Se impressao esta incorreta, zera contador para imprimir o numero de vias correto
					nx := 0 
				EndIf
			EndIf    
    	Endif
	Next Nx

	//+--------------------------------------------------------------+
	//¦** Final  da Impressao do Requerimento de Seguro-Desemprego **¦
	//+--------------------------------------------------------------+
	dbSkip()	
EndDo	

//+--------------------------------------------------------------+
//¦ Termino do Relatorio.                                        ¦
//+--------------------------------------------------------------+
dbSelectArea( 'SRA' )
RetIndex('SRA')
dbSetOrder(1)   
dbGoTop()
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(WnRel)
Endif

MS_Flush()

Return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ fImpSeg  ¦ Autor ¦ Kleber D. Gomes       ¦ Data ¦ 19.02.99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Requerimento de Seguro-Desemprego             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ fImpSeg()                                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function fImpSeg
Static Function fImpSeg()

//+--------------------------------------------------------------+
//¦** Inicio da Impressao do Requerimento de Seguro-Desemprego **¦
//+--------------------------------------------------------------+


@ nLinha, 09 PSAY cNome
nLinha	+= 3
@ nLinha, 09 PSAY cEnd 
nLinha	+= 3
@ nLinha, 09 PSAY Space(35) + cCep + Space(12) + cUF
nLinha	+= 3
@ nLinha, 09 PSAY cMae 
nLinha	+= 3
@ nLinha, 09 PSAY Space(08) + cTpInsc + Space(5) + cCgc + Space(12) + cCNAE
nLinha	+= 3
@ nLinha, 09 PSAY cPIS + Space(13) + cCTPS + Space(5) + cCTSerie + Space(5) + cCTUF
nLinha	+= 3
@ nLinha,09 PSAY cCBO + Space(6) + cOcup
nLinha	+= 5
@ nLinha, 09 PSAY StrZero(Day(dAdmissao),2) + Space(3) + StrZero(Month(dAdmissao),2) + Space(2) + Right(StrZero(Year(dAdmissao),4),2) + Space(5) + StrZero(Day(dDemissao),2) + Space(3) + StrZero(Month(dDemissao),2) + Space(2) + Right(StrZero(Year(dDemissao),4),2) + Space(13) + cSexo + Space(4) + Space(1) + cGrInstru+Space(9) + StrZero(Day(dNascim),2) + Space(3) + StrZero(Month(dNascim),2) + Space(2) + Right(StrZero(Year(dNascim),4),2) + Space(5) + cHrSemana
nLinha	+= 3
@ nLinha, 09 PSAY StrZero(Month(dDtAntSal),2) + Space(7) + Transform(nValAntSal,'@E 999,999,999.99') + Space(3) + StrZero(Month(dDtPenSal),2) + Space(7) + Transform(nValPenSal,'@E 999,999,999.99') + Space(3) + StrZero(Month(dDtUltSal),2) + Space(7) + Transform(nValUltSal,'@E 999,999,999.99')
nLinha	+= 3
@ nLinha, 09 PSAY Space(6) + Transform(nValAntSal+nValPenSal+nValUltSal,'@E 999,999,999.99')
nLinha	+= 3
@ nLinha, 09 PSAY Space(26) + cNMeses + Space(26) + c6Salarios + Space(25) + cIndeniz  	
nLinha	+= 18
@ nLinha, 09 PSAY cPis
nLinha	+= 3
@ nLinha, 09 PSAY cNome		
nLinha	+= 22
@ nLinha, 00 PSAY ' '

 
Return



/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ fCalcSal ¦ Autor ¦ Mauro                 ¦ Data ¦ 29.03.95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Calcula Salario Dia Hora e Mes                             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ fSalario(Salario,Salhora,Saldia,Salmes,Tipo)               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ Codigo = Codigo da Verba que deseja                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function fCalcSal
Static Function fCalcSal()

If SRA->RA_TIPOPGT == "M" .And. SRA->RA_CATFUNC $ "M·C"
	SalMes  := cValor
ElseIf SRA->RA_TIPOPGT == "S" .And. SRA->RA_CATFUNC $ "S·T"
	SalMes  := cValor / 7 * 30
ElseIf SRA->RA_CATFUNC $ "H·T"
	SalMes  := cValor * If(cTipo #Nil .And. cTipo == "A",SRA->RA_HRSMES,(Normal + Descanso))
ElseIf SRA->RA_CATFUNC $ "D"
	SalMes  := ( cValor * 30 )
EndIf

nSalario  := SalMes

Return


/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ fSomaSRR ¦ Autor ¦ R.H.                  ¦ Data ¦ 05.02.01 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Soma Verbas do arquivo SRR                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ fSomaSrr(cAno, cMes, cVerbas, nValor)                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ CAno 	-Ano do ultimo salario                            ¦¦¦
¦¦¦          ¦ CMes 	-Mes do ultimo salario                            ¦¦¦
¦¦¦          ¦ CVerbas  -Verbas a serem somada                            ¦¦¦
¦¦¦          ¦ nValor   -Valor das verbas                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*/

static Function fSomaSrr(cAno, cMes, cVerbas, nValor)

Local lRet    := .T.
Local nX      := 0
Local nNu     := 0
Local cPD     := ''
Local cPesq   := ''
Local cFilSRR := If(Empty(xFilial('SRR')),xFilial('SRR'),SRA->RA_FILIAL)
Local dDtGerar:= ctod('  /  /  ')	

//-- Reinicializa Variaveis
cAno    := If(Empty(cAno),StrZero(Year(dDTUltSal),4),cAno)
cMes    := If(Empty(cMes),StrZero(Month(dDTUltSal),2),cMes)
cVerbas := If(Empty(cVerbas),'',AllTrim(cVerbas))
nValor  := If(Empty(nValUlt).Or.ValType(nValUlt)#'N',0,nValUlt)

Begin Sequence

	If Empty(cVerbas) .Or. Len(cVerbas) < 3 .Or. ;
		!SRR->(dbSeek((cPesq := cFilSRR + SRA->RA_MAT +'R'+ cAno + cMes), .T.))
		lRet := .F.
		Break
	EndIf

	cPD := ''
	nNu := 0
	For nX := 1 to Len(cVerbas)
		nNu ++
		cPD += Subs(cVerbas,nX,1) 
		If nNu == 3
			cPD += 'ú'
			nNu := 0
		EndIf
	Next nX

	dbSelectarea('SRG')
	If dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.)
		dDtGerar := SRG->RG_DTGERAR
		dbSelectArea("SRR")
		dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.)
		While !EOF() .And. RR_FILIAL+RR_MAT == cFil+cMat
			If dDtGerar == SRR->RR_DATA
				If SRR->RR_PD $ cPD	
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fImpTeste ºAutor  ³R.H. - Natie        º Data ³  11/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Testa impressao de Formulario Teste                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function fImpTeste(cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descarrega teste de impressao                                ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_Flush()
fInicia(cString)

Pergunte("GPR30A",.T.)                 
lFirst	:= If(mv_par01 = 1 ,.F. , .T. )
           
Return lFirst


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³R.H.Natie           º Data ³  11/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa Impressao                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function fInicia(cString)
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
