#include "rwmake.ch"        
#INCLUDE "TRM060.CH"

User Function trm060()       

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,TITULO,WNREL,NORDEM")
SetPrvt("CARQDBF,AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM")
SetPrvt("CFIL,NTOTGVL,NTOTGHR")
SetPrvt("CAUXCURSO,CAUXTURMA,LRET")
SetPrvt("LOK,CCENTRO,CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET,LIMP")
SetPrvt("cAcessaRA3,cAcessaRA4,CSINON,CDESCSI") 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM060   ³ Autor ³  Equipe RH		    ³ Data ³ 20.10.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Treinamentos Solicitados ou Baixados                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM060                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³ 					                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Treinamentos Solicitados ou Baixados"
cDesc2  := STR0002 //"Ser  impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usu rio."
cString := "SRA"   //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005,STR0006,STR0016 } 	//"Matricula"###"Centro de Custo"###"Nome"###"Data"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Basicas)                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn  := { STR0007,1,STR0008,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
NomeProg := "TRM060"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR60A"
lEnd     := .F.
lImp	 := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Colunas  := 132
at_Prg   := "TRM060"
wCabec0  := 0
wCabec1  := ""
Contfl   := 1
Li       := 0
nPag     := 0
nTamanho := "M"
cTit     := STR0009 //"Treinamentos Solicitados ou Baixados"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("TRR60A",.F.)

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
//³ mv_par19        //  Treinamento 1-Aberto 2-Baixado 3-Ambos   ³
//³ mv_par20        //  Status Funcionario                       ³
//³ mv_par21        //  Ferias Programadas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WnRel :="TRM060"	//-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|lEnd| Relato()},cTit)
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Relato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Relato()

nOrdem  	:= aReturn[8]
cArqDBF 	:= CriaTrab(NIL,.f.)
aFields 	:= {}
Titulo   	:= STR0010 + DtoC(mv_par17) + STR0011 + DtoC(mv_par18)  //"Custo do Treinamento     Periodo:"###" a "
cAcessaRA3	:= &("{ || " + ChkRH("TRM060","RA3","2") + "}")
cAcessaRA4	:= &("{ || " + ChkRH("TRM060","RA4","2") + "}")
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
AADD(aFields,{"TR_DATAIN"	,"D",08,0})
AADD(aFields,{"TR_DATAFI"	,"D",08,0})
AADD(aFields,{"TR_CALEND"	,"C",05,0})
AADD(aFields,{"TR_DESCCAL"	,"C",20,0})
AADD(aFields,{"TR_TURMA"	,"C",03,0})
AADD(aFields,{"TR_SITUAC"	,"C",13,0})
AADD(aFields,{"TR_SINON"	,"C",04,0})
AADD(aFields,{"TR_DESCSI"	,"C",30,0})

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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Treinamentos Baixados ou Ambos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par19 == 2 .or. mv_par19 == 3 

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
			If 	(SRA->RA_MAT  < mv_par03)	.Or. (SRA->RA_MAT > mv_par04)		.Or.;
				(SRA->RA_CC   < mv_par05) 	.Or. (SRA->RA_CC  > mv_par06) 	.Or.;
				(SRA->RA_NOME < mv_par07) 	.Or. (SRA->RA_NOME > mv_par08)	.Or.;
				(SRA->RA_CARGO < mv_par15) .Or. (SRA->RA_CARGO > mv_par16)	.Or.;
				(!(cSitfol $ cSituacao) 	.And.	(cSitFol <> "P"))   			.Or.;
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
		
			dbSelectArea("RA1")
			dbSetOrder(1)
			cFil := If(xFilial("RA1") == Space(2),Space(2),SRA->RA_FILIAL)
			dbSeek(cFil+RA4->RA4_CURSO)

			dbSelectArea("RA2")
			dbSetOrder(1)
			cFil := If(xFilial("RA2") == Space(2),Space(2),SRA->RA_FILIAL)
			dbSeek(cFil+RA4->RA4_CALEND+RA4->RA4_CURSO+RA4->RA4_TURMA)
				
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
				TRA->TR_DATAIN		:= RA4->RA4_DATAIN
				TRA->TR_DATAFI		:= RA4->RA4_DATAFI
				TRA->TR_CALEND		:= RA4->RA4_CALEND
				TRA->TR_DESCCAL		:= RA2->RA2_DESC
				TRA->TR_TURMA		:= RA4->RA4_TURMA
				TRA->TR_SITUAC		:= STR0025 	//"CONCLUIDO"
				TRA->TR_SINON		:= RA2->RA2_SINON
				TRA->TR_DESCSI		:= TrmDesc("RA9",RA2->RA2_SINON,"RA9->RA9_DESCR")
			MsUnlock()
		EndIf		
		
		dbSelectArea("RA4")
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Treinamentos em aberto ou Ambos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par19 == 1 .or. mv_par19 == 3 

	dbSelectArea("RA3")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03+mv_par09,.T.)
	cInicio	:= "RA3->RA3_FILIAL + RA3->RA3_MAT + RA3->RA3_CURSO" 
	cFim	:= mv_par02 + mv_par04 + mv_par10

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim
            
		If !Eval(cAcessaRA3)
			dbSkip()
			Loop
		EndIf

		If RA3->RA3_CURSO  < mv_par09 .Or. RA3->RA3_CURSO  > mv_par10 .Or.;
			RA3->RA3_DATA < mv_par17 .Or. RA3->RA3_DATA > mv_par18
			dbSkip()
			Loop
		EndIf
	
	 	dbSelectArea("RA2")
		dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
		dbSelectArea("SRA")
		dbSetOrder(1)
	
		If dbSeek(RA3->RA3_FILIAL+RA3->RA3_MAT)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Situacao do Funcionario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cSitFol := TrmSitFol()

			If (SRA->RA_MAT  < mv_par03)	.Or. 	(SRA->RA_MAT > mv_par04) 	.Or.;
				(SRA->RA_CC   < mv_par05) 	.Or. 	(SRA->RA_CC  > mv_par06)  	.Or.;
				(SRA->RA_NOME < mv_par07) 	.Or. 	(SRA->RA_NOME > mv_par08) 	.Or.;
				(SRA->RA_CARGO	< mv_par15) .Or.	(SRA->RA_CARGO > mv_par16)	.Or.;
				(!(cSitfol $ cSituacao) 	.And.	(cSitFol <> "P"))   			.Or.;
				(cSitfol == "P" .And. nFerProg == 2)
				
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
				
			dbSelectArea( "SQ3" )
			dbSetOrder(1)
			cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
			If dbSeek( cFil + SRA->RA_CARGO + SRA->RA_CC ) .OR. dbSeek( cFil + SRA->RA_CARGO )
				If SQ3->Q3_GRUPO < mv_par11 .Or. SQ3->Q3_GRUPO > mv_par12 .Or.;
					SQ3->Q3_DEPTO < mv_par13 .Or. SQ3->Q3_DEPTO > mv_par14
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			Else
				dbSelectArea("RA3")
				dbSkip()
				Loop	
			EndIf
		
			dbSelectArea("RA1")
			dbSetOrder(1)
			cFil := If(xFilial("RA1") == Space(2),Space(2),SRA->RA_FILIAL)
			dbSeek(cFil+RA3->RA3_CURSO)

			dbSelectArea("RA2")
			dbSetOrder(1)
			cFil := If(xFilial("RA2") == Space(2),Space(2),SRA->RA_FILIAL)
			dbSeek(cFil+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
				
			RecLock("TRA",.T.)
				TRA->TR_FILIAL  	:= SRA->RA_FILIAL
				TRA->TR_CC      	:= SRA->RA_CC
				TRA->TR_MAT     	:= SRA->RA_MAT
				TRA->TR_NOME    	:= SRA->RA_NOME
				TRA->TR_CURSO	 	:= RA3->RA3_CURSO
				TRA->TR_DESCURS 	:= RA1->RA1_DESC
				TRA->TR_GRUPO   	:= SQ3->Q3_GRUPO
				TRA->TR_DEPTO   	:= SQ3->Q3_DEPTO
				TRA->TR_CARGO   	:= SQ3->Q3_CARGO
				TRA->TR_DATAIN		:= RA3->RA3_DATA
				TRA->TR_DATAFI		:= RA3->RA3_DATA
				TRA->TR_CALEND		:= RA3->RA3_CALEND
				TRA->TR_DESCCAL		:= RA2->RA2_DESC
				TRA->TR_TURMA		:= RA3->RA3_TURMA  
				TRA->TR_SINON		:= RA2->RA2_SINON
				TRA->TR_DESCSI		:= TrmDesc("RA9",RA2->RA2_SINON,"RA9->RA9_DESCR")
				
				cSituac := " "
				If RA3->RA3_RESERVA == "S"
				   cSituac := STR0022	//"Solicitacao"
				ElseIf RA3->RA3_RESERVA == "R"
				   cSituac := STR0023	//"Reserva"
				Else 
					cSituac := STR0024	//"Lista Espera" 
				EndIf
				TRA->TR_SITUAC		:= cSituac
			MsUnlock()
		EndIf		
		
		dbSelectArea("RA3")
		dbSkip()
	EndDo
EndIf

dbSelectArea("TRA")
dbGotop()

// Variaveis de totais da ordem selecionada
cAuxCurso	:= ""
cAuxTurma	:= ""
lRet		:= .T.
lOk			:= .F.
cCentro 	:= TRA->TR_CC
cCurso		:= TRA->TR_CURSO
cDescCur 	:= TRA->TR_DESCURS                  
cCalend		:= TRA->TR_CALEND
cDescCal	:= TRA->TR_DESCCAL
cTurma		:= TRA->TR_TURMA
cSinon 		:= TRA->TR_SINON
cDescSi		:= TRA->TR_DESCSI

While !Eof()
	If lRet
		If nOrdem == 2
			FImpCC()
		EndIf
		lRet:= .F.
	EndIf		

	If cCurso+cCalend+cTurma # TRA->TR_CURSO+TRA->TR_CALEND+TRA->TR_TURMA
		cAuxCurso	:= ""
		cAuxTurma	:= ""
		cCurso   	:= TRA->TR_CURSO
		cDescCur 	:= TRA->TR_DESCURS
		cCalend		:= TRA->TR_CALEND
		cDescCal	:= TRA->TR_DESCCAL
		cTurma		:= TRA->TR_TURMA
		cSinon 		:= TRA->TR_SINON
		cDescSi		:= TRA->TR_DESCSI
	EndIf
	If nOrdem == 2 .And. cCentro #TRA->TR_CC
		FImpCC()
		cAuxCurso	:= ""
		cAuxTurma 	:= ""
		cCurso	 	:= TRA->TR_CURSO
		cDescCur	:= TRA->TR_DESCURS
		cCentro   	:= TRA->TR_CC  
		cCalend	 	:= TRA->TR_CALEND
		cDescCal	:= TRA->TR_DESCCAL
		cTurma	 	:= TRA->TR_TURMA
		cSinon 		:= TRA->TR_SINON
		cDescSi		:= TRA->TR_DESCSI
	EndIf
	FImpDet()		

	dbSelectArea("TRA")
	dbSkip()
EndDo

If !lRet
	If nOrdem == 2
		FImpDet()
	EndIf	
	lOk := .T.
EndIf	

If lImp
	Impr("","F")
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

dbSelectArea("RA3")
dbSetOrder(1)

dbSelectArea("RA4")
dbSetOrder(1)

dbSelectArea("SQ3") 
dbSetOrder(1)

dbSelectArea("RA1")
dbSetOrder(1)

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Cabecalho do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImpCab()

If nOrdem #3 
	cCabec1	:= STR0014	//"MATR.  NOME 									GRUPO 			 DEPARTAMENTO 			 CARGO 					 SITUACAO"                           
Else
	cCabec1 := STR0015	//"NOME                             MATR. GRUPO 			 DEPARTAMENTO 			 CARGO 					 SITUACAO"                           
EndIf						  
Impr("","C")
Impr(CCABEC1, "C")
lImp := .T.
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime as linhas de detalhe do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fImpDet()

cAuxDet := ""
DET :="   "

If cAuxCurso+cAuxTurma == cCurso+cTurma
	cCurso   := Space(05)
	cAuxDet 	:= ""
	cTurma	:= Space(03)
Else
	cAuxCurso := cCurso
	cAuxTurma := cTurma        
	If nOrdem == 2 
		Impr("","C")
	ElseIf lImp
		Impr(Repl('-', colunas), "C")
	EndIf
	cAuxDet	:= STR0017+cCurso+" - "+cDescCur + STR0020+cCalend+" - "+cDescCal + STR0018+cTurma + STR0021+Dtoc(TRA->TR_DATAIN)+" - "+Dtoc(TRA->TR_DATAFI) //"CURSO: " / " CALENDARIO: " / " TURMA: " / " PERIODO: "
	IMPR(cAuxDet,"C")
	
	cAuxDet	:= STR0026+cSinon+" - "+cDescSi //"SINONIMO DE CURSO: "
	IMPR(cAuxDet,"C")
	
	FimpCab()
EndIf	

If nOrdem #3 
	DET := "   "
	DET := DET + TRA->TR_MAT + Space(01) + TRA->TR_NOME + Space(02)
Else
	DET := "   "
	DET := DET + TRA->TR_NOME + Space(01) + TRA->TR_MAT + Space(02)
EndIf
	
cCurso := cAuxCurso								
cTurma := cAuxTurma

DET := DET + PadR(TrmDesc("SQ0",TRA->TR_GRUPO,"SQ0->Q0_DESCRIC"),15)+ " " 
DET := DET + PadR(TrmDesc("SQB",TRA->TR_DEPTO,"SQB->QB_DESCRIC"),20) + " " 
DET := DET + PadR(TrmDesc("SQ3",TRA->TR_CARGO,"SQ3->Q3_DESCSUM"),30) + " "
DET := DET + TRA->TR_SITUAC

IMPR(DET,"C")
Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime quebra do Centro de custo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FImpCC()

If lImp
	Impr(Repl('-', colunas), "C")
	IMPR("","C")
EndIf
DET := STR0019 + TRA->TR_CC + " - " + DescCC(TRA->TR_CC)		// "CENTRO DE CUSTO: "
IMPR(DET,"C")   

Return (Nil)