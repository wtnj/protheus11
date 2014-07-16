#include "rwmake.ch"        
#INCLUDE "TRM040.CH"

User Function trm040()       

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,CONTFL,LI,NPAG,NTAMANHO,ADRIVER")
SetPrvt("CTIT,TITULO,WNREL,NORDEM,CARQDBF")
SetPrvt("AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM,CFIL")
SetPrvt("LRET,AHORAS,AVALOR,ACHORAS,ACVALOR,ATHORAS")
SetPrvt("ATVALOR,CCURSO,CNOME,CCC,NMES,WCABEC0")
SetPrvt("WCABEC1,WCABEC2,NTOTAL,DET,NX,CAUX,LIMP")
SetPrvt("cAcessaRA4,nChar")


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM040   ³ Autor ³ Desenvolvimento R.H.  ³ Data ³ 16.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Custo do Treinamentos - Mensal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM040                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Custo Treinamento Mensal"
cDesc2  := STR0002 //"Ser  impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usu rio."
cString := "SRA"  			         	//-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005 } 		//"Curso"###"Centro de Custo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Basicas)                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn  := { STR0006,1,STR0007,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
NomeProg := "TRM040"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR060"
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
COLUNAS  := 220
at_Prg   := "TRM040"
Contfl   := 1
Li       := 0
nPag     := 0
nTamanho := "G"
aDriver	 := ReadDriver()
nChar	 := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRR060",.F.)

cTit   := STR0009 + Str(mv_par17,4) + STR0010 + IIf(mv_par18=1,STR0011,STR0012) //"Investimento em Treinamento no Ano de "###" em: "###" Valor"###" Horas"
Titulo := cTit
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Matricula De                             ³
//³ mv_par04        //  Matricula Ate                            ³
//³ mv_par05        //  Centro de Custo                          ³
//³ mv_par06        //  Centro de Custo                          ³
//³ mv_par07        //  Nome De                                  ³
//³ mv_par08        //  Nome Ate                                 ³
//³ mv_par09        //  Curso De                                 ³
//³ mv_par10        //  Curso Ate                                ³
//³ mv_par11        //  Grupo De                                 ³
//³ mv_par12        //  Grupo Ate                                ³
//³ mv_par13        //  Departamento De                          ³
//³ mv_par14        //  Departamento Ate                         ³
//³ mv_par15        //  Cargo De                                 ³
//³ mv_par16        //  Cargo Ate                                ³
//³ mv_par17        //  Ano (AAAA)                               ³
//³ mv_par18        //  Treinamento em 1-Valor      2-Horas      ³
//³ mv_par19        //  Status Funcionario                       ³
//³ mv_par20        //  Ferias Programadas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WnRel :="TRM040"	//-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,nTamanho)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|lEnd| Relato()},cTit)

Return


Static Function Relato()

nOrdem  	:= aReturn[8]
cArqDBF  	:= CriaTrab(NIL,.f.)
aFields 	:= {}
lImp		:= .F.
cTit   		:= STR0009 + Str(mv_par17,4) + STR0010 + IIf(mv_par18=1,STR0011,STR0012) //"Investimento em Treinamento no Ano de "###" em: "###" Valor"###" Horas"
Titulo 		:= cTit
cAcessaRA4	:= &("{ || " + ChkRH("TRM040","RA4","2") + "}")
cSituacao 	:= mv_par19
nFerProg  	:= mv_par20
cSitFol   	:= ""

AADD(aFields,{"TR_CC"		,"C",09,0})
AADD(aFields,{"TR_CURSO"	,"C",04,0})
AADD(aFields,{"TR_DESCUR"	,"C",30,0})
AADD(aFields,{"TR_CUSTO"	,"N",12,2})
AADD(aFields,{"TR_HORAS"	,"N",06,2})
AADD(aFields,{"TR_DATA"		,"D",08,0})

dbCreate(cArqDbf,aFields)
dbUseArea(.T.,,cArqDbf,"TRA",.F.)

If nOrdem == 1 		// Curso     
	cIndCond := "TR_CURSO"
Else                 // Centro de Custo + Curso    
	cIndCond := "TR_CC + TR_CURSO"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0013) //"Selecionando Registros..."
dbGoTop()

dbSelectArea("RA4")
dbSetOrder(1)
dbSeek(mv_par01+mv_par03+mv_par09,.T.)
cInicio	:= "RA4->RA4_FILIAL + RA4->RA4_MAT + RA4->RA4_CURSO" 
cFim		:= mv_par02 + mv_par04 + mv_par10

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	If !Eval(cAcessaRA4)
		dbSkip()
		Loop
	EndIf

	If RA4->RA4_CURSO  < mv_par09 .Or. RA4->RA4_CURSO  > mv_par10 .Or.;
		Year(RA4->RA4_DATAIN) # mv_par17
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("RA2")
	dbSeek(xFilial("RA2")+RA4->RA4_CALEND+RA4->RA4_CURSO+RA4->RA4_TURMA)
	dbSelectArea("SRA")
	dbSetOrder(1)
	
	If dbSeek(RA4->RA4_FILIAL+RA4->RA4_MAT)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Situacao do Funcionario  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSitFol := TrmSitFol()
		
		If (SRA->RA_MAT  	< mv_par03) .Or.	(SRA->RA_MAT > mv_par04) 	.Or.;
			(SRA->RA_CC   	< mv_par05) .Or.	(SRA->RA_CC  > mv_par06)  	.Or.;
			(SRA->RA_NOME 	< mv_par07) .Or.	(SRA->RA_NOME > mv_par08) 	.Or.;
			(SRA->RA_CARGO 	< mv_par15)	.Or.	(SRA->RA_CARGO > mv_par16)	.Or.;
			(!(cSitfol $ cSituacao) 	.And.	(cSitFol <> "P"))   			.Or.;
			(cSitfol == "P" .And. nFerProg == 2)
			
			dbSelectArea("RA4")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea( "SQ3" )
		dbSetOrder(1)
		cFil := If(xFilial("SQ3") == Space(2),Space(2),RA4->RA4_FILIAL)
		If dbSeek( cFil + SRA->RA_CARGO + SRA->RA_CC ) .Or. dbSeek( cFil + SRA->RA_CARGO )
			If SQ3->Q3_GRUPO < mv_par11 .Or. SQ3->Q3_GRUPO > mv_par12 .Or.;
				SQ3->Q3_DEPTO < mv_par13 .Or. SQ3->Q3_DEPTO > mv_par14
				dbSelectArea("RA4")
				dbSkip()
				Loop
			EndIf
		Else 
			dbSelectArea("RA4")
			dbSkip()
			Loop	
		EndIf
				
		dbSelectArea("RA1")
		dbSetOrder(1)
		cFil := If(xFilial("RA1") == Space(2),Space(2),RA4->RA4_FILIAL)
		dbSeek(cFil+RA4->RA4_CURSO)
				
		RecLock("TRA",.T.)
			TRA->TR_CC		:= SRA->RA_CC
			TRA->TR_CURSO	:= RA4->RA4_CURSO
			TRA->TR_DESCUR	:= RA1->RA1_DESC
			TRA->TR_CUSTO	:= RA4->RA4_VALOR
			TRA->TR_HORAS	:= RA4->RA4_HORAS
			TRA->TR_DATA 	:= RA4->RA4_DATAIN
		MsUnlock()
		
   		dbSelectArea("RA4")
	   	dbSkip()
	EndIf		
EndDo

lRet := .T.

aHoras := Array(12)
aValor := Array(12)
aCHoras:= Array(12)
aCValor:= Array(12)
aTHoras:= Array(12)
aTValor:= Array(12)

aFill(aHoras,0)
aFill(aValor,0)
aFill(aCHoras,0)
aFill(aCValor,0)
aFill(aTHoras,0)
aFill(aTValor,0)

dbSelectArea("TRA")
dbGotop()

// Seta a impressao para comprimido
//@ 0,0 PSAY &(aDriver[5])

cCurso 	:= TRA->TR_CURSO
cNome	:= TRA->TR_DESCUR
cCC 	:= TRA->TR_CC

While !Eof()

	FImpCab()
	If lRet
		If nOrdem == 2
			FImpCC()
		EndIf
		lRet:= .F.
	EndIf	
	
	nMes := Month(TRA->TR_DATA)
		
	If cCurso #TRA->TR_CURSO
		FImpDet()
		cCurso := TRA->TR_CURSO
		cNome	 := TRA->TR_DESCUR
	EndIf
	
	If nOrdem == 2 .And. cCC #TRA->TR_CC
		FImpDet()
		FTotCC()
		cCC 	:= TRA->TR_CC
		cCurso:= TRA->TR_CURSO
		cNome	:= TRA->TR_DESCUR
		FImpCC()
	EndIf
		
	aHoras[nMes] := aHoras[nMes] + TRA->TR_HORAS
	aValor[nMes] := aValor[nMes] + TRA->TR_CUSTO
	aCHoras[nMes]:= aCHoras[nMes] + TRA->TR_HORAS
	aCValor[nMes]:= aCValor[nMes] + TRA->TR_CUSTO
	aTHoras[nMes]:= aTHoras[nMes] + TRA->TR_HORAS
	aTValor[nMes]:= aTValor[nMes] + TRA->TR_CUSTO
	
	dbSkip()
EndDo

If !lRet
	FImpDet()
	If nOrdem == 2		
		FTotCC()
	EndIf
	FTotGeral()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRA")
dbCloseArea()
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

dbSelectArea("SRA")
dbSetOrder(1)

dbSelectArea("RA4")
dbSetOrder(1)

dbSelectArea("SQ3") 
dbSetOrder(1)

dbSelectArea("RA1")
dbSetOrder(1)

Set Device To Screen

If lImp
	Impr("","F")
EndIf	

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

// Imprime Cabecalho do relatorio
Static Function FImpCab()
wCabec0	:= 2
wCabec1	:= STR0017	//"                                           JAN         FEV         MAR         ABR         MAI         JUN         JUL         AGO         SET         OUT         NOV         DEZ "

If mv_par18 == 1		// Valor
	wCabec2  := STR0018	//"CURSO                                     VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR       VALOR           TOTAL"
Else	
	wCabec2  := STR0019	//"CURSO                                     HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS       HORAS           TOTAL"
EndIf	
Return Nil

// Imprime as linhas de detalhe do relatorio
Static Function FImpDet()

Local nx := 0

If LI > 60
	FImpCab()
EndIf

nTotal:= 0
DET 	:= ""
DET 	:= cCurso + SPACE(01) + cNome
DET 	:= DET + IIF(mv_par18==1,Space(01),Space(05))
For nx:= 1 To 12
	If mv_par18 == 1
		cAux 	:= Transform(aValor[nx],"@R 9999,999.99")
		nTotal	:= nTotal + aValor[nx]
	Else
		cAux 	:= Transform(aHoras[nx],"@R 999,999")
		nTotal	:= nTotal + aHoras[nx]
	EndIf	
	DET 	:= DET + cAux
	DET 	:= DET + IIF(mv_par18==1,Space(01),Space(05))
	cAux 	:= ""
Next nx 

DET := DET + IIF(mv_par18==1,Transform(nTotal,"@R 99999999,999.99"),Transform(nTotal,"999,999,999"))
IMPR(DET,"C")

aFill(aHoras,0)
aFill(aValor,0)
lImp := .T.
Return Nil

// Imprime o cabecalho da quebra por Centro de Custo
Static Function FImpCC()

If LI > 60
	FImpCab()
EndIf	

DET:=""
DET:= STR0014 + cCC + " - " + DescCC(cCC) //"CENTRO DE CUSTO: "
IMPR(DET,"C")

Return Nil

// Imprime os totais por Centro de custo
Static Function FTotCC()

Local nx := 0

If LI > 60
	FImpCab()
	FimpCC()
EndIf	

IMPR(Repl("-",COLUNAS),"C")

nTotal:=0
DET := ""
DET := STR0015 + IIF(mv_par18==1,Space(12),Space(16)) //"TOTAL DO CENTRO DE CUSTO"

For nx:=1 To 12
	If mv_par18 == 1
		cAux 	:= Transform(aCValor[nx],"@R 9999,999.99")
		nTotal:= nTotal + aCValor[nx]
	Else
		cAux 	:= Transform(aCHoras[nx],"999,999")
		nTotal:= nTotal + aCHoras[nx]
	EndIf	
	DET := DET + cAux
	DET := DET + IIF(mv_par18==1,Space(01),Space(05))
	cAux := ""
Next nx

DET := DET + IIF(mv_par18==1,Transform(nTotal,"@R 99999999,999.99"),Transform(nTotal,"999,999,999"))
IMPR(DET,"C")
IMPR("","C")

aFill(aCHoras,0)
aFill(aCValor,0)

Return Nil

// Imprime total geral dos meses
Static Function FTotGeral()

Local nx := 0

If LI > 60
	FImpCab()
EndIf	

nTotal:=0
DET := ""
DET := STR0016 + IIF(mv_par18==1,Space(12),Space(16)) //"TOTAL GERAL:            "

For nx:=1 To 12
	If mv_par18 == 1
		cAux 	:= Transform(aTValor[nx],"@R 9999,999.99")
		nTotal:= nTotal + aTValor[nx]
	Else
		cAux 	:= Transform(aTHoras[nx],"999,999")
		nTotal:= nTotal + aTHoras[nx]
	EndIf	
	DET := DET + cAux
	DET := DET + IIF(mv_par18==1,Space(01),Space(05))
	cAux := ""
Next nx

DET := DET + IIF(mv_par18==1,Transform(nTotal,"@R 99999999,999.99"),Transform(nTotal,"999,999,999"))
IMPR("","C")
IMPR(DET,"C")
IMPR("","C")

aFill(aTHoras,0)
aFill(aTValor,0)

Return Nil