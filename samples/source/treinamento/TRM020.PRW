#include "rwmake.ch"  
#INCLUDE "TRM020.CH"

User Function Trm020() 

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("TITULO,AT_PRG,WCABEC0,WCABEC1,CONTFL,LI")
SetPrvt("NPAG,NTAMANHO,CTIT")
SetPrvt("WNREL,NORDEM,CFILDE,CFILATE,CMATDE,CMATATE")
SetPrvt("CCCDE,CCCATE,CNOMDE,CNOMATE,CCURDE,CCURATE")
SetPrvt("CGRUDE,CGRUATE,CDEPDE,CDEPATE,CCARDE,CCARATE")
SetPrvt("NNECESS,CFIL,CINICIO,CFIM,LIMPDET")
SetPrvt("CRESERVA,DET,DETCURSO,LFIRST") 
SetPrvt("CARQDBF,AFIELDS,CACESSARA3,NCHAR,CORDEM") 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM020   ³ Autor ³ Equipe R.H.           ³ Data ³ 16/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Treinamentos (Solicitacao)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM020                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³      ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Treinamento"
cDesc2  := STR0002 //"Será impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usuário."
cString := "RA1"   //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005,STR0006 } //"Matricula"###"Centro de Custo"###"Nome"

//+--------------------------------------------------------------+
//¦ Define Variaveis (Basicas)                                   ¦
//+--------------------------------------------------------------+
aReturn  := { STR0007,1,STR0008,2,2,1,"",1 } //"Zebrado"###"Administraçäo"
NomeProg := "TRM020"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR040"
lEnd     := .F.

//+--------------------------------------------------------------+
//¦ Define Variaveis (Programa)                                  ¦
//+--------------------------------------------------------------+
Colunas  	:= 220
Titulo   	:= STR0009 //"SOLICITACAO/RESERVA DE TREINAMENTO"
AT_PRG   	:= "TRM020"
wCabec0  	:= 1
wCabec1  	:= STR0011 //"FIL. MATR.  NOME                           GRUPO           DEPARTAMENTO         CARGO                        SITUACAO     DT.SOLIC.  CALENDARIO                        PERIODO         TURMA C.CUSTO"
Contfl   	:= 1
Li       	:= 0
nPag     	:= 0
nTamanho 	:= "G"
nChar		:= 15
cTit     	:= STR0009 //"SOLICITACAO/RESERVA DE TREINAMENTO"

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte("TRR040",.F.)

//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01        //  Filial  De                               ¦
//¦ mv_par02        //  Filial  Ate                              ¦
//¦ mv_par03        //  Matricula De                             ¦
//¦ mv_par04        //  Matricula Ate                            ¦
//¦ mv_par05        //  Centro de Custo                          ¦
//¦ mv_par06        //  Centro de Custo                          ¦
//¦ mv_par07        //  Nome De                                  ¦
//¦ mv_par08        //  Nome Ate                                 ¦
//¦ mv_par09        //  Curso De                                 ¦
//¦ mv_par10        //  Curso Ate                                ¦
//¦ mv_par11        //  Grupo De                                 ¦
//¦ mv_par12        //  Grupo Ate                                ¦
//¦ mv_par13        //  Departamento De                          ¦
//¦ mv_par14        //  Departamento Ate                         ¦
//¦ mv_par15        //  Cargo De                                 ¦
//¦ mv_par16        //  Cargo Ate                                ¦
//¦ mv_par17        //  Treinamento por:Necessidade/Solic./Ambos ¦
//¦ mv_par18        //  Status Funcionario                       ¦
//¦ mv_par19        //  Ferias Programadas                       ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
WnRel :="TRM020"  //-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F., nTamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Relato()},cTit)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Relato   ³ Autor ³ Equipe R.H.		    ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina Principal do Relatorio.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Relato()	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rdmake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Relato()

Local lAchou := .F.
nOrdem  	:= aReturn[8]
cAcessaRA3	:= &("{ || " + ChkRH("TRM020","RA3","2") + "}")

If nOrdem == 1
	cOrdem := STR0004 		// "Matricula"
ElseIf nOrdem == 2
	cOrdem := STR0005 		// "Centro de Custo"
Else
	cOrdem := STR0006 		// "Nome"
EndIf
cOrdem := " ("+STR0016+cOrdem+")"	// "Ordem de "

cTit   := STR0009 + cOrdem 	// "SOLICITACAO/RESERVA DE TREINAMENTO"
Titulo := cTit

//+--------------------------------------------------------------+
//¦ Carregando variaveis mv_par?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
If(!Empty(mv_par01),cFilDe :=mv_par01,cFilDe :="  ")
If(!Empty(mv_par02),cFilAte:=mv_par02,cFilAte:="99")
If(!Empty(mv_par03),cMatDe :=mv_par03,cMatDe :="      ")
If(!Empty(mv_par04),cMatAte:=mv_par04,cMatAte:="999999")
If(!Empty(mv_par05),cCcDe  :=mv_par05,cCcDe  :="         ")
If(!Empty(mv_par06),cCcAte :=mv_par06,cCcAte :="999999999")
If(!Empty(mv_par07),cNomDe :=mv_par07,cNomDe :="                              ")
If(!Empty(mv_par08),cNomAte:=mv_par08,cNomAte:="ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
If(!Empty(mv_par09),cCurDe :=mv_par09,cCurDe :="    ")
If(!Empty(mv_par10),cCurAte:=mv_par10,cCurAte:="9999")
If(!Empty(mv_par11),cGruDe :=mv_par11,cGruDe :="  ")
If(!Empty(mv_par12),cGruAte:=mv_par12,cGruAte:="99")
If(!Empty(mv_par13),cDepDe :=mv_par13,cDepDe :="   ")
If(!Empty(mv_par14),cDepAte:=mv_par14,cDepAte:="999")
If(!Empty(mv_par15),cCarDe :=mv_par15,cCarDe :="     ")
If(!Empty(mv_par16),cCarAte:=mv_par16,cCarAte:="99999")
If(!Empty(mv_par17),nNecess:=mv_par17,nNecess:=3)
cSituacao := mv_par18
nFerProg  := mv_par19
cSitFol   := ""

cArqDBF  := CriaTrab(NIL,.f.)
aFields 	:= {}

AADD(aFields,{"TR_FILIAL" 	,"C",02,0})
AADD(aFields,{"TR_CC"     	,"C",09,0})
AADD(aFields,{"TR_MAT"    	,"C",06,0})
AADD(aFields,{"TR_NOME"   	,"C",30,0})
AADD(aFields,{"TR_CURSO"  	,"C",04,0})
AADD(aFields,{"TR_DESCUR"	,"C",30,0})
AADD(aFields,{"TR_GRUPO"  	,"C",02,0})
AADD(aFields,{"TR_DEPTO"  	,"C",03,0})
AADD(aFields,{"TR_CARGO"  	,"C",05,0})
AADD(aFields,{"TR_RESERV" 	,"C",01,0})
AADD(aFields,{"TR_DATA" 	,"D",08,0})
AADD(aFields,{"TR_CALEND"	,"C",04,0})
AADD(aFields,{"TR_TURMA"	,"C",03,0})
AADD(aFields,{"TR_DTINI"	,"D",08,0})
AADD(aFields,{"TR_DTFIM"	,"D",08,0})

dbCreate(cArqDbf,aFields)
dbUseArea(.T.,,cArqDbf,"TRA",.F.)

If nOrdem == 1		// Matricula 
	cIndCond := "TR_FILIAL + TR_CURSO + TR_MAT"
ElseIf nOrdem == 2	// Centro de Custo + Matricula
	cIndCond := "TR_FILIAL + TR_CURSO + TR_CC + TR_MAT"
Else				// Nome	
	cIndCond := "TR_FILIAL + TR_CURSO + TR_NOME"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0015) //"Selecionando Registros..."
dbGoTop()

dbSelectArea("RA3")
dbSetOrder(1)
dbSeek(cFilDe+cMatDe+cCurDe,.T.)
cInicio	:= "RA3->RA3_FILIAL + RA3->RA3_MAT + RA3->RA3_CURSO" 
cFim	:= cFilAte + cMatAte + cCurAte

lImpDet  := .F.

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	//+--------------------------------------------------------------+
	//¦ Incrementa Regua de Processamento.                           ¦
	//+--------------------------------------------------------------+
	IncRegua()
		
	If RA3->RA3_CURSO  < cCurDe .Or. RA3->RA3_CURSO  > cCurAte .Or.!Eval(cAcessaRA3)
		dbSkip()
		Loop
	EndIf

	dbSelectArea("RA2")
	dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ 			Buscar Nome e Centro de Custo  			   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(RA3->RA3_FILIAL+RA3->RA3_MAT)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Situacao do Funcionario  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFol := TrmSitFol()
	
	If (SRA->RA_MAT  	< cMatDe)	.Or. (SRA->RA_MAT 	> cMatAte) .Or.;
		(SRA->RA_CC   	< cCcDe) 	.Or. (SRA->RA_CC  	> cCcAte)  .Or.;
		(SRA->RA_NOME 	< cNomDe) 	.Or. (SRA->RA_NOME > cNomAte) .Or.;
		(SRA->RA_CARGO	< cCarDe) 	.Or. (SRA->RA_CARGO> cCarAte) .Or.;
		(!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
		(cSitfol == "P" .And. nFerProg == 2)
		dbSelectArea("RA3")
		dbSkip()
		Loop
	EndIf			

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³            Buscar o Grupo e Departamento		 	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SQ3" )
	dbSetOrder(1)
	cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
	If dbSeek( cFil + SRA->RA_CARGO + SRA->RA_CC ) .Or. dbSeek( cFil + SRA->RA_CARGO ) 
		If SQ3->Q3_GRUPO < cGruDe .Or. SQ3->Q3_GRUPO > cGruAte .Or.;
			SQ3->Q3_DEPTO < cDepDe .Or. SQ3->Q3_DEPTO > cDepAte
			dbSelectArea("RA3")
			dbSkip()
			Loop
		EndIf 
	Else
		dbSelectArea("RA3")
		dbSkip()
		Loop			
	EndIf                  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                  Descricao do Curso                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("RA1")
	dbSetOrder(1)
	cFil := If(xFilial("RA1") == Space(2),Space(2),RA3->RA3_FILIAL)
	dbSeek(cFil+RA3->RA3_CURSO)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³               Grava arquivo Temporario 		           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRA")
	RecLock("TRA",.T.)
	
		TRA->TR_FILIAL	:= RA3->RA3_FILIAL
		TRA->TR_MAT		:= RA3->RA3_MAT
		TRA->TR_CURSO	:= RA3->RA3_CURSO
		TRA->TR_RESERV	:= RA3->RA3_RESERV 
		TRA->TR_DATA	:= RA3->RA3_DATA
		TRA->TR_NOME	:= SRA->RA_NOME
		TRA->TR_CC		:= SRA->RA_CC
		TRA->TR_DESCUR	:= RA1->RA1_DESC
		TRA->TR_CARGO  	:= SQ3->Q3_CARGO
		TRA->TR_GRUPO	:= SQ3->Q3_GRUPO
		TRA->TR_DEPTO  	:= SQ3->Q3_DEPTO
		TRA->TR_CALEND 	:= RA3->RA3_CALEND
		TRA->TR_TURMA	:= RA3->RA3_TURMA
		
		dbSelectArea("RA2")
		dbSetOrder(1)                                                 
		cFil := If(xFilial("RA2") == Space(2),Space(2),RA3->RA3_FILIAL)
		dbSeek(cFil+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
		
		dbSelectArea("TRA")
		TRA->TR_DTINI	:= RA2->RA2_DATAIN
		TRA->TR_DTFIM	:= RA2->RA2_DATAFI
		
	MsUnlock()

    dbSelectArea("RA3")
	dbSkip()
EndDo

dbSelectArea("TRA")
dbGotop()

SetRegua(RecCount())
   
Do While ! Eof()
    cCurso := TRA->TR_CURSO 

	lFirst := .T.
    DETCURSO := STR0010 + PadR(TRA->TR_CURSO,4) + " - " + PadR(TRA->TR_DESCUR,30) //"CURSO: "
	
	Do While ! Eof() .And. cCurso == TRA->TR_CURSO    
	
	    IncRegua()
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³            Verifica necessidade do Cargo 	           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		 
		dbSelectArea("RA5")
		dbSetOrder(2)
		cFil := If(xFilial("RA5") == Space(2),Space(2),TRA->TR_FILIAL)
		
		lAchou := (dbSeek( cFil + TRA->TR_CARGO + TRA->TR_CC + TRA->TR_CURSO )) .Or.;
		(dbSeek( cFil + TRA->TR_CARGO + TRA->TR_CURSO ))		
		
			If nNecess == 1 	//Necessidade do Cargo

			If lAchou 
					If lFirst
						IMPR(DETCURSO,"C")
						IMPR("","C")
						lFirst := .F.
					EndIf
				
					lImpDet := .T.
					fImpDet()
	        	EndIf
	        
			Else  			//Solicitacao (S/ necessidade do cargo)     
			If !lAchou .Or. nNecess == 3
					If lFirst
						IMPR(DETCURSO,"C")
						IMPR("","C")
						lFirst := .F.
					EndIf
	
					lImpDet := .T.
					fImpDet()
				EndIf
			EndIf
		
		dbSelectArea("TRA")
		dbSkip()
	EndDo
	
	If lImpDet .And. ! Eof()
		IMPR("","P")
	EndIf
EndDo
    
If lImpDet
	IMPR("","F")
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRA")
dbCloseArea()
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

dbSelectArea("RA3")
dbSetOrder(1)

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpDet  ³ Autor ³ Equipe R.H.		    ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Detalhe											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpDet()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpDet()

If TRA->TR_RESERV == "R"
	cReserva := STR0012 //"RESERVADO"
ElseIf TRA->TR_RESERV == "L"
	cReserva := STR0013 //"LISTA ESPERA"
ElseIf TRA->TR_RESERV == "S"
	cReserva := STR0014 //"SOLICITACAO"
Else
	cReserva := ""
EndIf

DET := TRA->TR_FILIAL + "   " + TRA->TR_MAT + " " + TRA->TR_NOME + " "
DET += PadR(TrmDesc("SQ0",TRA->TR_GRUPO,"SQ0->Q0_DESCRIC"),15)+ " "
DET += PadR(TrmDesc("SQB",TRA->TR_DEPTO,"SQB->QB_DESCRIC"),20) + " "
DET += PadR(TrmDesc("SQ3",TRA->TR_CARGO,"SQ3->Q3_DESCSUM"),28) + " "
DET += PadR(cReserva,12)+ " "
DET += If(__SetCentury(),Dtoc(TRA->TR_DATA),Dtoc(TRA->TR_DATA)+Space(2)) + " "
DET += TRA->TR_CALEND +"-"+PadR(TrmDesc("RA2",TRA->TR_CALEND,"RA2->RA2_DESC"),20) + " "
DET += If(__SetCentury(),Dtoc(TRA->TR_DTINI),Dtoc(TRA->TR_DTINI)+Space(2)) + " - "
DET += If(__SetCentury(),Dtoc(TRA->TR_DTFIM),Dtoc(TRA->TR_DTFIM)+Space(2)) + " "
DET += TRA->TR_TURMA + Space(3)
DET += TRA->TR_CC +" - "+PadR(TrmDesc("SI3",TRA->TR_CC,"SI3->I3_DESC"),20)

IMPR(DET,"C")

Return Nil
