#include "rwmake.ch"        
#INCLUDE "TRM030.CH"

User Function trm030()        

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,AREGS,TITULO,WNREL,NORDEM")
SetPrvt("CARQDBF,AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM")
SetPrvt("CFIL,NTOTQT,NTOTVALOR,NTOTHORAS,NTOTGVL,NTOTGQT,NTOTGHR,NTOTFUNC")
SetPrvt("NCUSTO,NHORAS,NPRESENC,NNOTA,CAUXCURSO,CAUXTURMA,LRET")
SetPrvt("NTIPO,CCENTRO,CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET,LIMP")
SetPrvt("CENTIDA,CDESCEN,CHORARI,CDURACA,CUNDURA,CINSTRU,CNOMEIN,CLOCAL")
SetPrvt("cAcessaRA4,CSINON,CDESCSI") 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM030   ³ Autor ³ Cristina Ogura        ³ Data ³ 16.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Custo do Treinamentos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM030                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Custo Treinamento"
cDesc2  := STR0002 //"Ser  impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usu rio."
cString := "SRA"  			             	//-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005,STR0006,STR0016 } 	//"Matricula"###"Centro de Custo"###"Nome"###"Data"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Basicas)                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn  := { STR0007,1,STR0008,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
NomeProg := "TRM030"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR050"
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Colunas	:= 132
at_Prg  := "TRM030"
wCabec0 := 0
wCabec1 := ""
Contfl  := 1
Li      := 0
nPag    := 0
nTamanho:= "M"
cTit    := STR0009 //"Custo do Treinamento"
aRegs	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRR050",.F.)

Titulo   := STR0010 + DtoC(mv_par17) + STR0011 + DtoC(mv_par18)  //"Custo do Treinamento     Periodo:"###" a "

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
//³ mv_par17        //  Periodo De                               ³
//³ mv_par18        //  Periodo Ate                              ³
//³ mv_par19        //  Relatorio 1-Sintetico 2-Analitico        ³
//³ mv_par20        //  Status Funcionario                       ³
//³ mv_par21        //  Ferias Programadas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WnRel := "TRM030"	//-- Nome Default do relatorio em Disco.
WnRel := SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd)
If nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif
RptStatus({|lEnd| Relato()},cTit)// Substituido pelo assistente de conversao do AP5 IDE em 05/07/00 ==> RptStatus({|lEnd| Execute(Relato)},cTit)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Relato   ³ Autor ³ Equipe R.H.		     ³ Data ³ 16.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina Principal do Relatorio.							        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Relato()	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rdmake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Relato()

nOrdem  	:= aReturn[8]
cArqDBF  	:= CriaTrab(NIL,.f.)
aFields 	:= {}
lImp		:= .F.
Titulo   	:= STR0010 + DtoC(mv_par17) + STR0011 + DtoC(mv_par18)  //"Custo do Treinamento     Periodo:"###" a "
cAcessaRA4	:= &("{ || " + ChkRH("TRM030","RA4","2") + "}")
cSituacao 	:= mv_par20
nFerProg  	:= mv_par21
cSitFol   	:= ""

AADD(aFields,{"TR_FILIAL" ,"C",02,0})
AADD(aFields,{"TR_CC"     ,"C",09,0})
AADD(aFields,{"TR_MAT"    ,"C",06,0})
AADD(aFields,{"TR_NOME"   ,"C",30,0})
AADD(aFields,{"TR_CURSO"  ,"C",04,0})
AADD(aFields,{"TR_DESCURS","C",30,0})
AADD(aFields,{"TR_GRUPO"  ,"C",02,0})
AADD(aFields,{"TR_DEPTO"  ,"C",03,0})
AADD(aFields,{"TR_CARGO"  ,"C",06,0})
AADD(aFields,{"TR_CUSTO"  ,"N",12,2})
AADD(aFields,{"TR_PRESEN" ,"N",06,2})
AADD(aFields,{"TR_NOTA"   ,"N",06,2})
AADD(aFields,{"TR_HORAS"  ,"N",06,2})
AADD(aFields,{"TR_DATAIN" ,"D",08,0})
AADD(aFields,{"TR_DATAFI" ,"D",08,0})
AADD(aFields,{"TR_CALEND" ,"C",05,0})
AADD(aFields,{"TR_DESCCAL","C",20,0})
AADD(aFields,{"TR_TURMA"  ,"C",03,0})
AADD(aFields,{"TR_ENTIDA" ,"C",04,0})
AADD(aFields,{"TR_DESCEN" ,"C",15,0})
AADD(aFields,{"TR_HORARI" ,"C",15,0})
AADD(aFields,{"TR_DURACA" ,"C",06,0})
AADD(aFields,{"TR_UNDURA" ,"C",01,0})
AADD(aFields,{"TR_INSTRU" ,"C",06,0})
AADD(aFields,{"TR_NOMEIN" ,"C",15,0})
AADD(aFields,{"TR_LOCAL"  ,"C",15,0})
AADD(aFields,{"TR_SINON"  ,"C",04,0})
AADD(aFields,{"TR_DESCSI" ,"C",30,0})

dbCreate(cArqDbf,aFields)
dbUseArea(.T.,,cArqDbf,"TRA",.F.)

If nOrdem == 1 		// Matricula 
	cIndCond := "TR_FILIAL + TR_CURSO + TR_CALEND + TR_TURMA + TR_MAT"
ElseIf nOrdem == 2	// Centro de Custo + Matricula
	cIndCond := "TR_FILIAL + TR_CC + TR_CURSO + TR_CALEND + TR_TURMA + TR_MAT"
ElseIf nOrdem == 3	// Nome	
	cIndCond := "TR_FILIAL + TR_CURSO + TR_CALEND + TR_TURMA + TR_NOME"
ElseIf nOrdem == 4	// Data
	cIndCond := "TR_FILIAL + DTOS(TR_DATAIN) + TR_CURSO + TR_CALEND + TR_TURMA + TR_MAT"	
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0012) //"Selecionando Registros..."
dbGoTop()

dbSelectArea("RA4")
dbSetOrder(1)
dbSeek(mv_par01+mv_par03+mv_par09,.T.)
cInicio	:= "RA4->RA4_FILIAL + RA4->RA4_MAT + RA4->RA4_CURSO" 
cFim	:= mv_par02 + mv_par04 + mv_par10

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim
    
	If !Eval(cAcessaRA4)
		dbSkip()
		Loop
	EndIf

	If RA4->RA4_CURSO  < mv_par09 .Or. RA4->RA4_CURSO  > mv_par10 .Or.;
		RA4->RA4_DATAIN < mv_par17 .Or. RA4->RA4_DATAIN > mv_par18
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
		
		If (SRA->RA_MAT  	< mv_par03) .Or. (SRA->RA_MAT 		> mv_par04)	.Or.;
			(SRA->RA_CC   	< mv_par05) .Or. (SRA->RA_CC  		> mv_par06)	.Or.;
			(SRA->RA_NOME 	< mv_par07) .Or. (SRA->RA_NOME		> mv_par08)	.Or.;
			(SRA->RA_CARGO  < mv_par15) .Or. (SRA->RA_CARGO 	> mv_par16)	.Or.;
			(!(cSitfol $ cSituacao) 	.And.(cSitFol <> "P"))					.Or.;
			(cSitfol == "P" .And. nFerProg == 2)
			
			dbSelectArea("RA4")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea( "SQ3" )
		dbSetOrder(1)
		cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
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
			                            
		dbSelectArea("RA0") 
		dbSetOrder(1)
		cFil := If(xFilial("RA0") == Space(2),Space(2),SRA->RA_FILIAL)
		dbSeek(cFil+RA4->RA4_ENTIDA)
		
		dbSelectArea("RA1")
		dbSetOrder(1)
		cFil := If(xFilial("RA1") == Space(2),Space(2),SRA->RA_FILIAL)
		dbSeek(cFil+RA4->RA4_CURSO)

		dbSelectArea("RA2")
		dbSetOrder(1)
		cFil := If(xFilial("RA2") == Space(2),Space(2),SRA->RA_FILIAL)
		dbSeek(cFil+RA4->RA4_CALEND+RA4->RA4_CURSO+RA4->RA4_TURMA)   

		dbSelectArea("RA7")
		dbSetOrder(1)
		cFil := If(xFilial("RA7") == Space(2),Space(2),SRA->RA_FILIAL)
		dbSeek(cFil+RA2->RA2_INSTRU)
				
		RecLock("TRA",.T.)
			TRA->TR_FILIAL  	:= SRA->RA_FILIAL
			TRA->TR_CC      	:= SRA->RA_CC
			TRA->TR_MAT     	:= SRA->RA_MAT
			TRA->TR_NOME    	:= SRA->RA_NOME
			TRA->TR_CURSO	 	:= RA4->RA4_CURSO
			TRA->TR_DESCURS 	:= RA1->RA1_DESC
			TRA->TR_GRUPO   	:= SQ3->Q3_GRUPO
			TRA->TR_DEPTO   	:= SQ3->Q3_DEPTO
			TRA->TR_CARGO   	:= SQ3->Q3_CARGO
			TRA->TR_CUSTO	 	:= RA4->RA4_VALOR
			TRA->TR_PRESEN  	:= RA4->RA4_PRESEN
			TRA->TR_NOTA		:= RA4->RA4_NOTA
			TRA->TR_HORAS   	:= RA4->RA4_HORAS
			TRA->TR_DATAIN		:= RA4->RA4_DATAIN
			TRA->TR_DATAFI		:= RA4->RA4_DATAFI
			TRA->TR_CALEND		:= RA4->RA4_CALEND
			TRA->TR_DESCCAL		:= RA2->RA2_DESC
			TRA->TR_TURMA		:= RA4->RA4_TURMA
			TRA->TR_ENTIDA		:= RA4->RA4_ENTIDA
			TRA->TR_DESCEN		:= RA0->RA0_DESC
			TRA->TR_HORARI		:= RA2->RA2_HORARI
			TRA->TR_DURACA		:= STR(RA2->RA2_DURACA,6,2)
			TRA->TR_UNDURA		:= RA2->RA2_UNDURA
			TRA->TR_INSTRU		:= RA2->RA2_INSTRU
			TRA->TR_NOMEIN		:= RA7->RA7_NOME
			TRA->TR_LOCAL		:= RA2->RA2_LOCAL
			TRA->TR_SINON		:= RA4->RA4_SINONI
			TRA->TR_DESCSI		:= TrmDesc("RA9",RA4->RA4_SINONI,"RA9->RA9_DESCR")
		MsUnlock()
	EndIf		

   	dbSelectArea("RA4")
   	dbSkip()
EndDo

dbSelectArea("TRA")
dbGotop()

// Variaveis dos totais do relatorio
nTotQt		:= 0
nTotValor	:= 0
nTotHoras	:= 0 
nTotGQt		:= 0
nTotGVl		:= 0
nTotGHr		:= 0

// Variaveis de totais da ordem selecionada
nTotFunc	:= 0
nCusto		:= 0
nHoras		:= 0
nPresenc	:= 0
nNota		:= 0
cAuxCurso	:= ""
cAuxTurma	:= ""
lRet		:= .T.
nTipo 		:= 1
cCentro 	:= TRA->TR_CC
cCurso		:= TRA->TR_CURSO
cDescCur 	:= TRA->TR_DESCURS                  
cCalend		:= TRA->TR_CALEND
cDescCal	:= TRA->TR_DESCCAL
cTurma		:= TRA->TR_TURMA
cEntida		:= TRA->TR_ENTIDA
cDescEn		:= TRA->TR_DESCEN
cHorari		:= TRA->TR_HORARI
cDuraca		:= TRA->TR_DURACA
cUnDura		:= TRA->TR_UNDURA
cInstru		:= TRA->TR_INSTRU
cNomeIn		:= TRA->TR_NOMEIN
cLocal		:= TRA->TR_LOCAL
cSinon		:= TRA->TR_SINON
cDescSi		:= TRA->TR_DESCSI

While !Eof()

	If lRet
		If nOrdem == 2
			FImpCC()
		EndIf
		lRet:= .F.
	EndIf		

	If mv_par19	== 1				// Sintetico
		If nOrdem != 2 .And. cCurso+cCalend+cTurma != TRA->TR_CURSO+TRA->TR_CALEND+TRA->TR_TURMA
			nTipo 		:= 3	//Total
			FImpDet()
			FImpTot()				
			FZera()
			cCurso		:= TRA->TR_CURSO
			cDescCur 	:= TRA->TR_DESCURS
			cCalend		:= TRA->TR_CALEND
			cDescCal	:= TRA->TR_DESCCAL
			cTurma		:= TRA->TR_TURMA
			cEntida		:= TRA->TR_ENTIDA
			cDescEn		:= TRA->TR_DESCEN
			cHorari		:= TRA->TR_HORARI
			cDuraca		:= TRA->TR_DURACA
			cUnDura		:= TRA->TR_UNDURA
			cInstru		:= TRA->TR_INSTRU
			cNomeIn		:= TRA->TR_NOMEIN
			cLocal		:= TRA->TR_LOCAL
			cSinon		:= TRA->TR_SINON
			cDescSi		:= TRA->TR_DESCSI
		EndIf
		If nOrdem == 2 .And. cCentro != TRA->TR_CC			// Centro de custo
			nTipo 		:= 2 //Total C.C.
			FImpDet()
			FImpTot()
			FImpCC()
			FZera() 
			cCentro  	:= TRA->TR_CC
			cCurso		:= TRA->TR_CURSO
			cDescCur 	:= TRA->TR_DESCURS
			cCalend		:= TRA->TR_CALEND
			cDescCal	:= TRA->TR_DESCCAL
			cTurma		:= TRA->TR_TURMA
			cEntida		:= TRA->TR_ENTIDA
			cDescEn		:= TRA->TR_DESCEN
			cHorari		:= TRA->TR_HORARI
			cDuraca		:= TRA->TR_DURACA
			cUnDura		:= TRA->TR_UNDURA
			cInstru		:= TRA->TR_INSTRU
			cNomeIn		:= TRA->TR_NOMEIN
			cLocal		:= TRA->TR_LOCAL
			cSinon		:= TRA->TR_SINON
			cDescSi		:= TRA->TR_DESCSI			
		EndIf
		
		// Totais por curso
		nTotFunc 	++
		nCusto		+= TRA->TR_CUSTO
		nPresenc 	+= TRA->TR_PRESEN
		nNota		+= TRA->TR_NOTA
		nHoras		+= TRA->TR_HORAS
		
	Else								// Analitico
		If nOrdem != 2 .And. cCurso+cCalend+cTurma != TRA->TR_CURSO+TRA->TR_CALEND+TRA->TR_TURMA
			nTipo 		:= 3	//Total
			FImpTot()				
			cAuxCurso	:= ""
			cAuxTurma	:= ""
			cCurso   	:= TRA->TR_CURSO
			cDescCur 	:= TRA->TR_DESCURS
			cCalend		:= TRA->TR_CALEND
			cDescCal	:= TRA->TR_DESCCAL
			cTurma		:= TRA->TR_TURMA
			cEntida		:= TRA->TR_ENTIDA
			cDescEn		:= TRA->TR_DESCEN
			cHorari		:= TRA->TR_HORARI
			cDuraca		:= TRA->TR_DURACA
			cUnDura		:= TRA->TR_UNDURA
			cInstru		:= TRA->TR_INSTRU
			cNomeIn		:= TRA->TR_NOMEIN
			cLocal		:= TRA->TR_LOCAL
			cSinon		:= TRA->TR_SINON
			cDescSi		:= TRA->TR_DESCSI
		EndIf
		nTotFunc	:= 1
		nCusto		:= TRA->TR_CUSTO
		nPresenc 	:= TRA->TR_PRESEN
		nNota		:= TRA->TR_NOTA
		nHoras		:= TRA->TR_HORAS
		If nOrdem == 2 .And. cCentro != TRA->TR_CC
			nTipo 		:= 2	//Tot. C.C.
			FImpTot()
			FImpCC()
			cAuxCurso 	:= ""
			cAuxTurma 	:= ""
			cCurso	 	:= TRA->TR_CURSO
			cDescCur	:= TRA->TR_DESCURS
			cCentro   	:= TRA->TR_CC  
			cCalend	 	:= TRA->TR_CALEND
			cDescCal	:= TRA->TR_DESCCAL
			cTurma	 	:= TRA->TR_TURMA
			cEntida		:= TRA->TR_ENTIDA
			cDescEn		:= TRA->TR_DESCEN
			cHorari		:= TRA->TR_HORARI
			cDuraca		:= TRA->TR_DURACA
			cUnDura		:= TRA->TR_UNDURA
			cInstru		:= TRA->TR_INSTRU
			cNomeIn		:= TRA->TR_NOMEIN
			cLocal		:= TRA->TR_LOCAL
			cSinon		:= TRA->TR_SINON
			cDescSi		:= TRA->TR_DESCSI			
		EndIf
		FImpDet()		
	EndIf
	
	// Totais por centro de custo
	nTotQt		++
	nTotValor 	+= TRA->TR_CUSTO
	nTotHoras 	+= TRA->TR_HORAS
	
	// Totais do relatorio
	nTotGQt		++
	nTotGVl		+= TRA->TR_CUSTO
	nTotGHr 	+= TRA->TR_HORAS
	
	dbSelectArea("TRA")
	dbSkip()
EndDo

If !lRet
	If nOrdem == 2 
		nTipo := 2	//Tot. C.C. 
		If mv_par19 == 1
			FImpDet()
		EndIf
		FImpTot()
	
	ElseIf mv_par19 == 1 	//Sintetico
		nTipo := 3	//Total
		FImpDet()
		FImpTot()  
	
	ElseIf mv_par19 == 2	//Analitico
		nTipo := 3	//Total
		FImpTot()
	
	EndIf

	nTipo		:= 1	//Total Geral
	nTotQt		:= nTotGQt
	nTotValor 	:= nTotGVl
	nTotHoras 	:= nTotGHr
	
	FImpTot()
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

If lImp
	Impr("","F")
EndIf	

Set Device To Screen
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif
MS_FLUSH()
Return Nil
      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function FImpCab() ³ // Imprime Cabecalho do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FImpCab()

If mv_par19 == 1	// Sintetico
	CCABEC1	:= STR0013	//"                                           QTDE.      CUSTO  HORAS %PRES MD NOTAS"

Else					// Analitico
	If nOrdem != 3 
		CCABEC1	:= STR0014	//"   MATR.  NOME                             QTDE.      CUSTO  HORAS %PRES MD NOTAS"
	Else
		CCABEC1 := STR0015	//"   NOME                            MATR.   QTDE.      CUSTO  HORAS %PRES MD NOTAS"
	EndIf								
EndIf                               

Impr("","C")
Impr(CCABEC1, "C")
lImp := .T.
Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function FImpDet() ³ // Imprime as linhas de detalhe do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImpDet()
cAuxDet := ""
DET 	:= "   "
nPresenc:= nPresenc / nTotFunc
nNota	:= nNota	/ nTotFunc

If mv_par19 == 1			// Sintetico
	cAuxDET	:= STR0017+cCurso+" - "+cDescCur + STR0020+cCalend+" - "+cDescCal + STR0018+cTurma + STR0021+Dtoc(TRA->TR_DATAIN)+" - "+Dtoc(TRA->TR_DATAFI) //"CURSO: " / " CALENDARIO: " / " TURMA: " / " PERIODO: "
	IMPR(cAuxDet,"C")            
	
	cAuxDET := STR0030 + cSinon + " - " + cDescSi	//"SINONIMO DO CURSO: "
	IMPR(cAuxDet,"C")
	
	cAuxDET	:= STR0024+cEntida+" - "+cDescEn + STR0025+cInstru+" - "+cNomeIn + STR0026+cHorari + STR0027+cDuraca+" "+cUnDura + STR0028+cLocal //"ENTIDADE: " / " INSTRUTOR: " / " HORARIO: " / " DURACAO: " / " LOCAL: "
	IMPR(cAuxDet,"C")            
	FImpCab()
	DET 	:= Space(48)
	
Else							// Analitico
	If cAuxCurso+cAuxTurma == cCurso+cTurma
		cCurso  := Space(05)
		cAuxDet	:= ""
		cTurma	:= Space(03)
	Else
		cAuxCurso := cCurso
		cAuxTurma := cTurma
		cAuxDet   := STR0017+cCurso+" - "+cDescCur + STR0020+cCalend+" - "+cDescCal + STR0018+cTurma + STR0021+Dtoc(TRA->TR_DATAIN)+" - "+Dtoc(TRA->TR_DATAFI) //"CURSO: " / " CALENDARIO: " / " TURMA: " / " PERIODO: "
		IMPR(cAuxDet,"C")                                            

		cAuxDET := STR0030 + cSinon + " - " + cDescSi	//"SINONIMO DO CURSO: "
		IMPR(cAuxDet,"C")		
		
		cAuxDET	:= STR0024+cEntida+" - "+cDescEn + STR0025+cInstru+" - "+cNomeIn + STR0026+cHorari + STR0027+cDuraca+" "+cUnDura + STR0028+cLocal //"ENTIDADE: " / " INSTRUTOR: " / " HORARIO: " / " DURACAO: " / " LOCAL: "
		IMPR(cAuxDet,"C")            		
		FImpCab()
	EndIf	
	If nOrdem != 3 
		DET := "   "
		DET += TRA->TR_MAT + Space(01) + TRA->TR_NOME + Space(08)
 	Else
		DET := "   "
		DET += TRA->TR_NOME + Space(01) + TRA->TR_MAT + Space(08)
	EndIf
	cCurso := cAuxCurso								
	cTurma := cAuxTurma
EndIf
DET += Transform(nCusto,"99999,999.99") + Space(01)
DET += Transform(nHoras,"99999.99") + Space(03)			
DET += Transform(nPresenc,"999.9") + Space(02)
DET += Transform(nNota,"999.99") + Space(02)
IMPR(DET,"C")
Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function FImpCC() ³ // Imprime quebra do Centro de custo
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FImpCC()  

IMPR("","C")  
DET := STR0019 + TRA->TR_CC + " - " + DescCC(TRA->TR_CC)		// "CENTRO DE CUSTO: "
IMPR(DET,"C")
IMPR("","C")   
Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function FImpTot() ³ // Imprime os totais do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FImpTot()
IMPR("","C")
DET := ""
If nTipo == 1
	DET := STR0022	//"TOTAL GERAL:           "
ElseIf nTipo == 2
    DET := STR0023	//"TOTAL CENTRO DE CUSTO: "
ElseIf nTipo == 3
    DET := STR0029	//"TOTAL:                 "
EndIf

DET += Space(19)
DET += Transform(nTotQt		,"99999") + Space(01)
DET += Transform(nTotValor	,"99999,999.99") + Space(01) 
DET += Transform(nTotHoras	,"99999.99") 
IMPR(DET,"C")
Impr(Repl('-', colunas), "C")

nTotQt		:= 0
nTotValor	:= 0
nTotHoras	:= 0

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function FZera() ³ // Zera as variaveis do relatorio
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FZera()
nTotFunc 	:= 0
nCusto		:= 0
nPresenc	:= 0
nNota		:= 0
nHoras		:= 0
Return Nil			