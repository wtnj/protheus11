#include "protheus.ch"
#include "rwmake.ch"  
#include "TRM010.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o       ³ TRM010   ³ Autor ³ Eduardo Ju              ³ Data ³ 19.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ Lista de Presenca                       		               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ TRM010                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³ BOPS ³  Motivo da Alteracao 					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Eduardo Ju / ³13/09/2006³099036³Transformacao em relatorio personalizavel   ³±±
±±³Tania        ³          ³      ³para o release 4.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM010()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	Pergunte("TRR030",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM010R3()	
EndIf  

RestArea( aArea )

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 16.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2 
Local aOrdem    := {}
Local cAliasQry := GetNextAlias()
//Private cCargo

oReport := TReport():New("TRM010",OemToAnsi(STR0001),"TRR030",{|oReport| PrintReport(oReport,cAliasQry)},OemToAnsi(STR0046)+" - "+OemToAnsi(STR0002)+" "+OemToAnsi(STR0003))
	//"Lista de Presença"###"Emite Lista de Presenca para os Treinamentos."###"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetLandscape()	//Imprimir Somente Paisagem
oReport:SetTotalInLine(.F.) 
Pergunte("TRR030",.F.)

Aadd( aOrdem, STR0004)	// "Nome"
Aadd( aOrdem, STR0005)	// "Matricula"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: Cabecalho				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
oSection1 := TRSection():New(oReport,OemToAnsi(STR0034),{"RA3","RA2","RA1","RA7","RA9"},aOrdem) 	//"Curso"
oSection1:SetTotalInLine(.F.)  
oSection1:SetHeaderBreak(.T.)

TRCell():New(oSection1,"RA3_CALEND","RA3",STR0033)	//Codigo do Calendario 
TRCell():New(oSection1,"RA2_DESC","RA2","")		//Descricado do Calendario
TRCell():New(oSection1,"RA3_CURSO","RA3",STR0034)	//Codigo do Curso
TRCell():New(oSection1,"RA1_DESC","RA1","")		//Descricao do Curso 
TRCell():New(oSection1,"RA2_SINON","RA2",STR0037)	//Sinonimo do Curso
TRCell():New(oSection1,"RA9_DESCR","RA9","")  		//Descricao do Sinonimo do Curso  
TRCell():New(oSection1,"RA3_TURMA","RA3",STR0035)	//Turma
TRCell():New(oSection1,"RA2_INSTRU","RA2",STR0036)	//Codigo do Instrutor
TRCell():New(oSection1,"RA7_NOME","RA7","") 		//Nome do Instrutor
TRCell():New(oSection1,"RA2_DATAIN","RA2",STR0038)	//Periodo: Data Inicio do Curso
TRCell():New(oSection1,"RA2_DATAFI","RA2","") 		//Periodo: Data Final do Curso 
TRCell():New(oSection1,"RA2_HORARI","RA2",STR0040)	//Horario
TRCell():New(oSection1,"RA2_LOCAL","RA2",STR0041)	//Local

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: Impressao dos Funcionarios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,OemToAnsi(STR0047),{"RA3","SRA","SQ3","SQ0","SQB"})	//"Relacao dos Participantes"
oSection2:SetTotalInLine(.F.)  
oSection2:SetHeaderBreak(.T.)
oSection2:SetLeftMargin(2)	//Identacao da Secao

TRCell():New(oSection2,"RA_FILIAL","SRA",STR0043)	//Filial
TRCell():New(oSection2,"RA3_MAT","RA3",STR0044)	//Matricula do Funcionario 
TRCell():New(oSection2,"RA_NOME","SRA")				//Nome do Funcionario
TRCell():New(oSection2,"VISTO"," " ,STR0042,/*Picture*/,10          ,/*lPixel*/, {|| '__________' } )	//"Visto"
TRCell():New(oSection2,"RA3_RESERV","RA3",STR0030,)	//Status da Reserva (Reservado) 
TRCell():New(oSection2,"Q3_GRUPO","SQ3")			//Codigo do Grupo 
TRCell():New(oSection2,"Q0_DESCRIC","SQ0","")		//Descricao do Grupo 
TRCell():New(oSection2,"Q3_DEPTO","SQ3",STR0031)	//Codigo do Depto
TRCell():New(oSection2,"QB_DESCRIC","SQB","")		//Descricao do Depto 
TRCell():New(oSection2,"Q3_CARGO","SQ3",STR0032)	//Cargo:= fGetCargo(SRA->RA_MAT)
TRCell():New(oSection2,"Q3_DESCSUM","SQ3","")		//Descricao do Cargo  

TRFunction():New(oSection2:Cell("RA3_MAT"),/*cId*/,"COUNT",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
oSection2:SetTotalText(OemToAnsi(STR0045))

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 19.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio (Lista de Presenca)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local cFil 		:= ""
Local cInicio 	:= ""
Local cFim    	:= ""
Local cCalend	:= ""
Local cCurso	:= ""                                           
Local cTurma	:= ""
Local cGrupo 	:= ""
Local cDepto	:= ""
Local cCC		:= ""
Local nOrdem  	:= osection1:GetOrder()

#IFNDEF TOP
	Local cAcessaRA3:= &("{ || " + ChkRH("TRM010","RA3","2") + "}")
	Local cFiltro	:= ""
	Local aFields 	:= {}
	Local cArqDBF	:= ""
#ELSE
	Local lQuery    := .F. 
	//Local cWhere	:= ""
	Local i			:= 0
	Local cSitQuery := ""
	Local cOrder	:= ""
#ENDIF

//+--------------------------------------------------------------+
//¦ Carregando variaveis mv_par?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
Local cFilDe 	:= If(!Empty(mv_par01),mv_par01,"  ")
Local cFilAte	:= If(!Empty(mv_par02),mv_par02,"99")
Local cMatDe 	:= If(!Empty(mv_par03),mv_par03,"      ")
Local cMatAte	:= If(!Empty(mv_par04),mv_par04,"999999")
Local cNomDe 	:= If(!Empty(mv_par05),mv_par05,"                              ")
Local cNomAte	:= If(!Empty(mv_par06),mv_par06,"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") 
Local cCalDe 	:= If(!Empty(mv_par07),mv_par07,"   ")
Local cCalAte	:= If(!Empty(mv_par08),mv_par08,"999")
Local cCurDe 	:= If(!Empty(mv_par09),mv_par09,"    ")
Local cCurAte	:= If(!Empty(mv_par10),mv_par10,"9999")
Local cTurDe 	:= If(!Empty(mv_par11),mv_par11,"   ")
Local cTurAte	:= If(!Empty(mv_par12),mv_par12,"999")
Local cGruDe 	:= If(!Empty(mv_par13),mv_par13,"  ")
Local cGruAte	:= If(!Empty(mv_par14),mv_par14,"99")
Local cDepDe 	:= If(!Empty(mv_par15),mv_par15,"   ")
Local cDepAte	:= If(!Empty(mv_par16),mv_par16,"9999")
Local cCarDe 	:= If(!Empty(mv_par17),mv_par17,"     ")
Local cCarAte	:= If(!Empty(mv_par18),mv_par18,"99999")
Local cSitCur	:= If(!Empty(mv_par19),mv_par19,"LRS")
Local nVias  	:= If(!Empty(mv_par20),mv_par20,1)
Local cSituacao	:= mv_par21
Local nFerProg 	:= mv_par22
Local cSitFol  	:= "" 

#IFNDEF TOP
	//+--------------------------------------------------------------+
	//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
	//+--------------------------------------------------------------+
	cArqDBF	:= CriaTrab(NIL,.f.)
	aFields := {}
	AADD(aFields,{"TR_FILIAL" 	,"C",02,0})
	AADD(aFields,{"TR_CC"     	,"C",09,0})
	AADD(aFields,{"TR_MAT"    	,"C",06,0})
	AADD(aFields,{"TR_NOME"   	,"C",30,0})
	AADD(aFields,{"TR_CALEND" 	,"C",04,0})
	AADD(aFields,{"TR_CURSO" 	,"C",04,0})
	AADD(aFields,{"TR_TURMA" 	,"C",03,0})
	AADD(aFields,{"TR_SITCUR" 	,"C",1,0})
	AADD(aFields,{"TR_GRUPO"  	,"C",02,0})
	AADD(aFields,{"TR_NOMEG"  	,"C",15,0})
	AADD(aFields,{"TR_DEPTO"  	,"C",03,0})
	AADD(aFields,{"TR_NOMED"  	,"C",20,0})
	AADD(aFields,{"TR_CARGO"  	,"C",05,0})
	AADD(aFields,{"TR_NOMEC"  	,"C",30,0})
	
	DbCreate(cArqDbf,aFields)
	DbUseArea(.T.,,cArqDbf,"TRA",.F.)
	If nOrdem == 1
		cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_NOME + TR_MAT"
	ElseIf nOrdem == 2
		cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_MAT"
	EndIf
	
	cArqNtx  := CriaTrab(NIL,.f.)
	IndRegua("TRA",cArqNtx,cIndCond,,,STR0012) //"Selecionando Registros..."
	dbGoTop()
	
	dbSelectArea("RA3")
	dbSetOrder(2)
	dbGoTop()
	
	cFil 	:= If(xFilial("RA3") == Space(2),Space(2),cFilDe)
	cInicio := "RA3->RA3_FILIAL + RA3->RA3_CALEND"
	cFim    := cFilAte + cCalAte
	dbSeek( cFilDe + cCalDe ,.T.)
	
	While !Eof() .And. &cInicio <= cFim
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		If !Eval(cAcessaRA3)
			dbSkip()  
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Intervalo de Impressao                          	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If 	(RA3->RA3_FILIAL 	< cFilDe) .Or. (RA3->RA3_FILIAL 	> cFilAte) .Or.;
			(RA3->RA3_MAT 		< cMatDe) .Or. (RA3->RA3_MAT 		> cMatAte) .Or.;
			(RA3->RA3_TURMA		< cTurDe) .Or. (RA3->RA3_TURMA		> cTurAte) .Or.;
			(RA3->RA3_CALEND 	< cCalDe) .Or. (RA3->RA3_CALEND 	> cCalAte) .Or.;
			(RA3->RA3_CURSO  	< cCurDe) .Or. (RA3->RA3_CURSO 	> cCurAte) .Or.;
		   	!(RA3->RA3_RESERV $ cSitCur)
			dbSkip()
			Loop
		EndIf 
				
		cGrupo 	:= ""
		cDepto	:= ""
		cCargo	:= ""
		cCC		:= ""
		
		dbSelectArea("RA2")
		dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)	
		
		dbSelectArea( "SRA" )
		dbSetOrder(1)	
		
		If dbSeek( RA3->RA3_FILIAL + RA3->RA3_MAT )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Situacao do Funcionario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSitFol := TrmSitFol()
			
			If (!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
				(cSitfol == "P"	 .And. nFerProg == 2) .Or.; 
				(SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) 
				dbSelectArea("RA3")
				RA3->(dbSkip())
				Loop
			EndIf                      
			
			cCargo  := fGetCargo(SRA->RA_MAT)
			cCC		:= SRA->RA_CC
				
			dbSelectArea("SQ3")
			dbSetOrder(1)
			cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
			
			If dbSeek( cFil + cCargo + cCC ) .Or. dbSeek( cFil + cCargo )
				cGrupo:= SQ3->Q3_GRUPO            
				cDepto:= SQ3->Q3_DEPTO            
	
				If 	(cGrupo < cGruDe) .Or. (cGrupo > cGruAte) .Or.;
					(cDepto < cDepDe) .Or. (cDepto > cDepAte) .Or.;
					(cCargo < cCarDe) .Or. (cCargo > cCarAte)
						
					dbSelectArea("RA3")
					RA3->(dbSkip())
					Loop					
				EndIf
			EndIf
			Reclock("TRA",.T.)
			TRA->TR_CALEND  := RA3->RA3_CALEND
			TRA->TR_CURSO   := RA3->RA3_CURSO
			TRA->TR_TURMA   := RA3->RA3_TURMA
			TRA->TR_FILIAL  := SRA->RA_FILIAL
			TRA->TR_CC      := SRA->RA_CC
			TRA->TR_MAT     := SRA->RA_MAT
			TRA->TR_NOME    := SRA->RA_NOME
			TRA->TR_SITCUR  := RA3->RA3_RESERV
			TRA->TR_GRUPO   := cGrupo 
			TRA->TR_NOMEG   := IIf(!Empty(cGrupo),TrmDesc("SQ0",cGrupo,"SQ0->Q0_DESCRIC"),Space(15))       
			TRA->TR_DEPTO   := cDepto 
			TRA->TR_NOMED   := IIf(!Empty(cDepto),TrmDesc("SQB",cDepto,"SQB->QB_DESCRIC"),Space(20))       
			TRA->TR_CARGO   := cCargo 
			TRA->TR_NOMEC   := IIf(!Empty(cCargo),TrmDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),Space(30))       			
			MsUnlock()	
		EndIf
		
		dbSelectArea("RA3")
		dbSkip()
	EndDo	
			
	dbSelectArea("TRA")
	dbGotop()
	
	TRPosition():New(oSection1,"RA3",2,{|| xFilial("RA3") + TRA->TR_CALEND+TRA->TR_MAT})
	TRPosition():New(oSection1,"RA2",1,{|| xFilial("RA2") + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA})  //VER SE USO .T. 
	TRPosition():New(oSection1,"RA1",1,{|| xFilial("RA1") + TRA->TR_CURSO})
	TRPosition():New(oSection1,"RA7",1,{|| xFilial("RA7") + RA2->RA2_INSTRU})	//ATENCAO
	TRPosition():New(oSection1,"RA9",2,{|| xFilial("RA9") + TRA->TR_CURSO})	//VER SE POSICIONO NO RA2
	
	TRPosition():New(oSection2,"RA3",2,{|| xFilial("RA3") + TRA->TR_CALEND+TRA->TR_MAT})
	TRPosition():New(oSection2,"SRA",1,{|| xFilial("SRA") + TRA->TR_MAT})
	TRPosition():New(oSection2,"SQ3",2,{|| xFilial("SQ3") + TRA->TR_GRUPO + TRA->TR_DEPTO + TRA->TR_CARGO})
	TRPosition():New(oSection2,"SQ0",1,{|| xFilial("SQ0") + TRA->TR_GRUPO})
	TRPosition():New(oSection2,"SQB",1,{|| xFilial("SQB") + TRA->TR_DEPTO})
	  
	Do While ! Eof()
		
		oReport:IncMeter()
			
		If oReport:Cancel()
			Exit
		EndIf
		
		cCalend	:= TRA->TR_CALEND
	    cCurso	:= TRA->TR_CURSO
	    cTurma	:= TRA->TR_TURMA
	    cFil1	:= TRA->TR_FILIAL
	    
	    oSection1:Init()
		oSection1:PrintLine()	
		oSection2:Init()
	    
		Do While ! Eof() .And.	cCalend + cCurso + cTurma + cFil1  == TRA->TR_CALEND + TRA->TR_CURSO + TRA->TR_TURMA + TRA->TR_FILIAL		
			oReport:SkipLine()
			oSection2:PrintLine()	
			DbSelectArea("TRA")
			DbSkip()	
		EndDo
		oSection2:Finish()
		oSection1:Finish()
	EndDo	
	
	TRA->(dbCloseArea())
	fErase(cArqNtx + OrdBagExt())
	fErase(cArqDbf + GetDBExtension())

#ELSE	
	//-- Filtragem do relatório
	//-- Query do relatório da secao 1
	lQuery := .T.  
	
	If nOrdem == 1 	// Nome	
		cOrder := "%RA3_CALEND,RA3_CURSO,RA3_TURMA,RA3_FILIAL,RA_NOME,RA3_MAT%"
	Else			// Matricula
		cOrder := "%RA3_CALEND,RA3_CURSO,RA3_TURMA,RA3_FILIAL,RA3_MAT%"
	EndIf        
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Treinamento Aberto-Baixado-Ambos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	          
	
	For i :=1 to Len(cSitCur)
   	cSitQuery += "'"+Subs(cSitCur,i,1)+"'"
   	If ( i+1 ) <= Len(cSitCur)
    	cSitQuery += "," 
   	Endif
	Next i     

	cSitQuery := "%" + cSitQuery + "%"
	
	/*cWhere := "%%"
	If mv_par08 == 1	//Aberto  
		cWhere := "%RA2_REALIZ <> 'S' AND%"
	ElseIf mv_par08 == 2 //Baixado
		cWhere := "%RA2_REALIZ = 'S' AND%"
	EndIf*/              

	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT	RA3_CALEND,RA2_DESC,RA3_CURSO,RA1_DESC,RA2_SINON,RA9_DESCR,RA3_TURMA,RA2_INSTRU,RA7_NOME,
				RA2_DATAIN,RA2_DATAFI,RA2_HORARI,RA2_LOCAL,RA_FILIAL,RA3_MAT,RA_NOME,RA3_RESERV,
				Q3_GRUPO,Q0_DESCRIC,Q3_DEPTO,QB_DESCRIC,Q3_DESCSUM
		
		FROM 	%table:RA3% RA3	  
			  
		LEFT JOIN %table:RA1% RA1
			ON RA1_FILIAL = %xFilial:RA1%
			AND RA1_CURSO = RA3_CURSO
			AND RA1.%NotDel%
		LEFT JOIN %table:RA2% RA2
			ON RA2_FILIAL = %xFilial:RA2%
			AND RA2_CALEND = RA3_CALEND
			AND RA2_CURSO = RA3_CURSO
			AND RA2_TURMA = RA3_TURMA
			AND RA2.%NotDel% 
		LEFT JOIN %table:RA9% RA9
			ON RA9_FILIAL = %xFilial:RA9%
			AND RA9_SINONI   = RA2_SINON
			AND RA9.%NotDel%
		LEFT JOIN %table:RA7% RA7
			ON RA7_FILIAL = %xFilial:RA7%
			AND RA7_INSTRU = RA2_INSTRU
			AND RA7.%NotDel%   			
		LEFT JOIN %table:SRA% SRA
			ON RA_FILIAL = %xFilial:SRA%
			AND RA_MAT = RA3_MAT
			AND SRA.%NotDel% 
		LEFT JOIN %table:SQ3% SQ3
			ON Q3_FILIAL = %xFilial:SQ3%
			AND Q3_CARGO = RA_CARGO
			AND SQ3.%NotDel%			 								
		LEFT JOIN %table:SQ0% SQ0
			ON Q0_FILIAL = %xFilial:SQ0%
			AND Q0_GRUPO = Q3_GRUPO
			AND SQ0.%NotDel%
		LEFT JOIN %table:SQB% SQB
			ON QB_FILIAL = %xFilial:SQB%
			AND QB_DEPTO = Q3_DEPTO
			AND SQB.%NotDel%					
		WHERE RA3_FILIAL = %xFilial:RA3%   	
			//%exp:cWhere%   
			
			AND RA3_FILIAL >= %Exp:cFilDe% AND RA3_FILIAL <=%Exp:cFilAte%  
			AND RA3_MAT >= %Exp:cMatDe% AND RA3_MAT <=%Exp:cMatAte% 
			AND RA_NOME >= %Exp:cNomDe% AND RA_NOME <=%Exp:cNomAte% 
			AND RA3_CALEND >= %Exp:cCalDe% AND RA3_CALEND <=%Exp:cCalAte%
			AND RA3_CURSO >= %Exp:cCurDe% AND RA3_CURSO <= %Exp:cCurAte%
			AND RA3_TURMA >= %Exp:cTurDe% AND RA3_TURMA <= %Exp:cTurAte%  
			AND Q3_GRUPO >= %Exp:cGruDe% AND Q3_GRUPO <= %Exp:cGruAte% 
			AND Q3_DEPTO >= %Exp:cDepDe% AND Q3_DEPTO <= %Exp:cDepAte% 
			AND Q3_CARGO >= %Exp:cCarDe% AND Q3_CARGO <= %Exp:cCarAte% 
 			AND RA3_RESERV IN (%exp:Upper(cSitQuery)%)	
			AND RA3.%NotDel%   										
		ORDER BY %Exp:cOrder%                 		
	EndSql
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery()	//*Array com os parametros do tipo Range*
		
	//-- Inicio da impressao do fluxo do relatório
	oReport:SetMeter(RA3->(LastRec()))

	//-- Utiliza a query do Pai
	oSection2:SetParentQuery()
	oSection2:SetParentFilter( { |cParam| (cAliasQry)->RA3_CALEND + (cAliasQry)->RA3_CURSO + (cAliasQry)->RA3_TURMA  == cParam },{ || (cAliasQry)->RA3_CALEND + (cAliasQry)->RA3_CURSO + (cAliasQry)->RA3_TURMA})	
	oSection1:Print()	 //Imprimir	
	
#ENDIF

Return Nil	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM010R3()        

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("TITULO,AT_PRG,WCABEC0,WCABEC1,CONTFL,LI")
SetPrvt("NPAG,NTAMANHO,CTIT,WNREL,NORDEM,CFILDE")
SetPrvt("CFILATE,CMATDE,CMATATE,CNOMDE,CNOMEDE,CNOMATE")
SetPrvt("CNOMEATE,CCALDE,CCALATE,CCURDE,CCURATE,CTURDE")
SetPrvt("CTURATE,CGRUDE,CGRUATE,CDEPDE,CDEPATE,CCARDE")
SetPrvt("CCARATE,CSITCUR,NVIAS,CARQDBF,AFIELDS,CINDCOND")
SetPrvt("CARQNTX,CFIL,CINICIO,CFIM,NIMPRVIAS,DET")
SetPrvt("CRESERVA,CCALEND,CCURSO,CTURMA,CFIL1")
SetPrvt("CGRUPO,CDEPTO,CCARGO,CCC") 
SetPrvt("CACESSARA3")
SetPrvt("LFALTA")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM010   ³ Autor ³ Equipe RH		        ³ Data ³ 16/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lista de Prsenca.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM010	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Lista de Presença"
cDesc2  := STR0002 //"Será impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usuário."
cString := "RA3"   //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005 } //"Nome"###"Matricula"

//+--------------------------------------------------------------+
//¦ Define Variaveis (Basicas)                                   ¦
//+--------------------------------------------------------------+
aReturn  := { STR0006,1,STR0007,2,2,1,"",1 } //"Zebrado"###"Administraçäo"
NomeProg := "TRM010"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR030"
lEnd     := .F.
lImp	 := .F.

//+--------------------------------------------------------------+
//¦ Define Variaveis (Programa)                                  ¦
//+--------------------------------------------------------------+
Colunas  := 132
Titulo   := STR0011 //"LISTA DE PRESENCA"
AT_PRG   := "TRM010"
wCabec0  := 1
wCabec1  := ""
Contfl   := 1
Li       := 0
nPag     := 0
nTamanho := "M"

cTit     := STR0011 //"LISTA DE PRESENCA"

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte("TRR030",.F.)

//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01        //  Filial  De                               ¦
//¦ mv_par02        //  Filial  Ate                              ¦
//¦ mv_par03        //  Matricula De                             ¦
//¦ mv_par04        //  Matricula Ate                            ¦
//¦ mv_par05        //  Nome De                                  ¦
//¦ mv_par06        //  Nome Ate                                 ¦
//¦ mv_par07        //  Calendario De                            ¦
//¦ mv_par08        //  Calendario Ate                           ¦
//¦ mv_par09        //  Curso De                                 ¦
//¦ mv_par10        //  Curso Ate                                ¦
//¦ mv_par11        //  Turma De                                 ¦
//¦ mv_par12        //  Turma Ate                                ¦
//¦ mv_par13        //  Grupo De                                 ¦
//¦ mv_par14        //  Grupo Ate                                ¦
//¦ mv_par15        //  Departamento De                          ¦
//¦ mv_par16        //  Departamento Ate                         ¦
//¦ mv_par17        //  Cargo De                                 ¦
//¦ mv_par18        //  Cargo Ate                                ¦
//¦ mv_par19        //  Situacao                                 ¦
//¦ mv_par20        //  Numeros de Vias                          ¦
//¦ mv_par21        //  Status Funcionario                       ¦
//¦ mv_par22        //  Ferias Programadas                       ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
WnRel :="TRM010"  //-- Nome Default do relatorio em Disco.
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Relato   ³ Autor ³  Equipe RH        	³ Data ³ 19/03/99 ³±±
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
Local nImprVias	:= 0

nOrdem  	:= aReturn[8]
cAcessaRA3	:= &("{ || " + ChkRH("TRM010","RA3","2") + "}")

//+--------------------------------------------------------------+
//¦ Carregando variaveis mv_par?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
cFilDe := If(!Empty(mv_par01),mv_par01,"  ")
cFilAte:= If(!Empty(mv_par02),mv_par02,"99")
cMatDe := If(!Empty(mv_par03),mv_par03,"      ")
cMatAte:= If(!Empty(mv_par04),mv_par04,"999999")
cNomDe := If(!Empty(mv_par05),mv_par05,"                              ")
cNomAte:= If(!Empty(mv_par06),mv_par06,"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
cCalDe := If(!Empty(mv_par07),mv_par07,"   ")
cCalAte:= If(!Empty(mv_par08),mv_par08,"999")
cCurDe := If(!Empty(mv_par09),mv_par09,"    ")
cCurAte:= If(!Empty(mv_par10),mv_par10,"9999")
cTurDe := If(!Empty(mv_par11),mv_par11,"   ")
cTurAte:= If(!Empty(mv_par12),mv_par12,"999")
cGruDe := If(!Empty(mv_par13),mv_par13,"  ")
cGruAte:= If(!Empty(mv_par14),mv_par14,"99")
cDepDe := If(!Empty(mv_par15),mv_par15,"   ")
cDepAte:= If(!Empty(mv_par16),mv_par16,"9999")
cCarDe := If(!Empty(mv_par17),mv_par17,"     ")
cCarAte:= If(!Empty(mv_par18),mv_par18,"99999")
cSitCur:= If(!Empty(mv_par19),mv_par19,"LRS")
nVias  := If(!Empty(mv_par20),mv_par20,1)
cSituacao:= mv_par21
nFerProg := mv_par22
cSitFol  := ""

//+--------------------------------------------------------------+
//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
//+--------------------------------------------------------------+
cArqDBF	:= CriaTrab(NIL,.f.)
aFields := {}
AADD(aFields,{"TR_FILIAL" 	,"C",02,0})
AADD(aFields,{"TR_CC"     	,"C",09,0})
AADD(aFields,{"TR_MAT"    	,"C",06,0})
AADD(aFields,{"TR_NOME"   	,"C",30,0})
AADD(aFields,{"TR_CALEND" 	,"C",04,0})
AADD(aFields,{"TR_CURSO" 	,"C",04,0})
AADD(aFields,{"TR_TURMA" 	,"C",03,0})
AADD(aFields,{"TR_SITCUR" 	,"C",1,0})
AADD(aFields,{"TR_GRUPO"  	,"C",2,0})
AADD(aFields,{"TR_NOMEG"  	,"C",15,0})
AADD(aFields,{"TR_DEPTO"  	,"C",3,0})
AADD(aFields,{"TR_NOMED"  	,"C",20,0})
AADD(aFields,{"TR_CARGO"  	,"C",6,0})
AADD(aFields,{"TR_NOMEC"  	,"C",30,0})

DbCreate(cArqDbf,aFields)
DbUseArea(.T.,,cArqDbf,"TRA",.F.)
If nOrdem == 1
	cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_NOME + TR_MAT"
ElseIf nOrdem == 2
	cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_MAT"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0012) //"Selecionando Registros..."
dbGoTop()

dbSelectArea( "RA3" )
dbSetOrder(2)
dbGoTop()

cFil 	:= If(xFilial("RA3") == Space(2),Space(2),cFilDe)
cInicio := "RA3->RA3_FILIAL + RA3->RA3_CALEND"
cFim    := cFilAte + cCalAte
dbSeek( cFilDe + cCalDe ,.T.)

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	//+--------------------------------------------------------------+
	//¦ Incrementa Regua de Processamento.                           ¦
	//+--------------------------------------------------------------+
	IncRegua()

	If lEnd
		IMPR(STR0026,"C") //"CANCELADO PELO USUARIO"
		Exit
	Endif

	
	If !Eval(cAcessaRA3)
		dbSkip()  
		Loop
	EndIf

	//+--------------------------------------------------------------+
	//¦ Consiste Parametrizaç¦o do Intervalo de Impress¦o.           ¦
	//+--------------------------------------------------------------+
	If 	(RA3->RA3_FILIAL 	< cFilDe) .Or. (RA3->RA3_FILIAL 	> cFilAte) .Or.;
		(RA3->RA3_MAT 		< cMatDe) .Or. (RA3->RA3_MAT 		> cMatAte) .Or.;
		(RA3->RA3_TURMA		< cTurDe) .Or. (RA3->RA3_TURMA		> cTurAte) .Or.;
		(RA3->RA3_CALEND 	< cCalDe) .Or. (RA3->RA3_CALEND 	> cCalAte) .Or.;
		(RA3->RA3_CURSO  	< cCurDe) .Or. (RA3->RA3_CURSO 	> cCurAte) .Or.;
	   	!(RA3->RA3_RESERV $ cSitCur)

		dbSkip()
		Loop
	EndIf                          
		
	// Inicializa as variaveis do SQ3 - Cargos	
	cGrupo 	:= ""
	cDepto	:= ""
	cCargo	:= ""
	cCC		:= ""
		
	dbSelectArea("RA2")
	dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)	
	
	dbSelectArea( "SRA" )
	dbSetOrder(1)	
	
	If dbSeek( RA3->RA3_FILIAL + RA3->RA3_MAT )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Situacao do Funcionario  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSitFol := TrmSitFol()
		
		If (!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
			(cSitfol == "P"	 .And. nFerProg == 2) .Or.; 
			(SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) 
			dbSelectArea( "RA3" )
			dbSkip()
			Loop
		EndIf                      
		cCargo  := fGetCargo(SRA->RA_MAT)
		cCC		:= SRA->RA_CC
			
		dbSelectArea( "SQ3" )
		dbSetOrder(1)
		cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
		If dbSeek( cFil + cCargo + cCC ) .Or. dbSeek( cFil + cCargo )
			cGrupo:= SQ3->Q3_GRUPO            
			cDepto:= SQ3->Q3_DEPTO            

			If 	(cGrupo < cGruDe) .Or. (cGrupo > cGruAte) .Or.;
				(cDepto < cDepDe) .Or. (cDepto > cDepAte) .Or.;
				(cCargo < cCarDe) .Or. (cCargo > cCarAte)
					
				dbSelectArea( "RA3" )
				dbSkip()
				Loop					
			EndIf
		EndIf
		
		Reclock("TRA",.T.)
			TRA->TR_CALEND  := RA3->RA3_CALEND
			TRA->TR_CURSO   := RA3->RA3_CURSO
			TRA->TR_TURMA   := RA3->RA3_TURMA
			TRA->TR_FILIAL  := SRA->RA_FILIAL
			TRA->TR_CC      := SRA->RA_CC
			TRA->TR_MAT     := SRA->RA_MAT
			TRA->TR_NOME    := SRA->RA_NOME
			TRA->TR_SITCUR  := RA3->RA3_RESERV
			TRA->TR_GRUPO   := cGrupo 
			TRA->TR_NOMEG   := IIf(!Empty(cGrupo),TrmDesc("SQ0",cGrupo,"SQ0->Q0_DESCRIC"),Space(15))       
			TRA->TR_DEPTO   := cDepto 
			TRA->TR_NOMED   := IIf(!Empty(cDepto),TrmDesc("SQB",cDepto,"SQB->QB_DESCRIC"),Space(20))       
			TRA->TR_CARGO   := cCargo 
			TRA->TR_NOMEC   := IIf(!Empty(cCargo),TrmDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),Space(30))       			
		MsUnlock()	
		
	EndIf
	
	dbSelectArea("RA3")
	dbSkip()
EndDo

For nImprVias := 1 To nVias

	dbSelectArea("TRA")
	dbGotop()

	SetRegua(RecCount())
   
	Do While ! Eof()
		cCalend	:= TRA->TR_CALEND
	    cCurso	:= TRA->TR_CURSO
	    cTurma	:= TRA->TR_TURMA
	    cFil1	:= TRA->TR_FILIAL
		Do While ! Eof() .And.	cCalend == TRA->TR_CALEND .And.;
								cCurso 	== TRA->TR_CURSO .And.;
								cTurma 	== TRA->TR_TURMA .And.;
								cFil1   == TRA->TR_FILIAL    
		
		    IncRegua()

			dbSelectArea("RA2")
			dbSetOrder(1)
			If ! dbSeek(xFilial("RA2")+TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA)

	            dbSelectArea("TRA")
	            dbSkip()
	            Loop
            EndIf
            
            dbSelectArea("TRA")
            //Imprime Cabecalho
			fImpCab()
			//Imprime Detalhe
			fImpDet()
        
			dbSelectArea("TRA")
			
		EndDo
	EndDo

Next nImprVias

//+--------------------------------------------------------------+
//¦ Termino do Relatorio                                         ¦
//+--------------------------------------------------------------+

dbSelectArea( "RA3" )
dbSetOrder(1)

If lImp
	IMPR("","F")
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

TRA->(dbCloseArea())
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpCab  ³ Autor ³ Equipe RH		        ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpCab()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpCab()

DET := STR0013 + PadR(TRA->TR_CALEND,4) + " - " + PadR(RA2->RA2_DESC,30) + Repl(" ",14) //"CALENDARIO: "
DET := DET + STR0014 + PadR(TRA->TR_CURSO,4) + " - " + PadR(TrmDesc("RA1",TRA->TR_CURSO,"RA1->RA1_DESC"),30) + Repl(" ",14) //"CURSO: "
DET := DET + STR0015 + PadR(TRA->TR_TURMA,3) //"TURMA: "
IMPR(DET,"C")

DET := STR0029 + RA2->RA2_SINON + " - " + TrmDesc("RA9",RA2->RA2_SINON,"RA9->RA9_DESCR")  //"SINONIMO DO CURSO: "
IMPR(DET,"C")

DET := STR0016 + DtoC(RA2->RA2_DATAIN) + STR0017 + DtoC(RA2->RA2_DATAFI) + Repl(" ",14) + STR0018 + PadR(RA2->RA2_HORARI,20) //"PERIODO: "###" A "###"HORARIO: "
DET := DET + Space(06) + STR0027 + RA2->RA2_LOCAL // "LOCAL: "
IMPR(DET,"C")
IMPR("","C")
//FIL. MATR.  MOME                                  VISTO          SIT.  GRUPO           DEPARTAMENTO         CARGO                   
//XX   XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX _____________________ XXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 

DET := STR0019 //"FIL. MATR.  MOME                                  VISTO          SIT.  GRUPO           DEPARTAMENTO         CARGO                   "
IMPR(DET,"C")
IMPR("","C")
IMPR("","C")
lImp := .T.
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpDet  ³ Autor ³ Equipe RH		        ³ Data ³ 19/03/99 ³±±
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

Local cReserva := ""

dbSelectArea( "TRA" )
While !Eof() .And.	RA2->RA2_CALEND+RA2->RA2_CURSO+RA2->RA2_TURMA == ;
						TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA
	If LI >= 60
		fImpCab()
	EndIf
	DET := TRA->TR_FILIAL + "   " + TRA->TR_MAT + " " + TRA->TR_NOME + " "

	dbSelectArea("RA4")
	dbSetOrder(3)                                          
	lFalta := .F.
	dbSeek(xFilial("RA4")+TRA->TR_CALEND)
	While !Eof() .And. RA4->RA4_CALEND == TRA->TR_CALEND
	    If RA4->RA4_MAT == TRA->TR_MAT .And. RA4->RA4_PRESEN != 100
	    	lFalta := .T.
	    EndIf
		dbSkip()                                       
	EndDo                
	
	dbSelectArea( "TRA" )
	
	If ! lFalta
		DET := DET + Repl("_",21) + " "
	Else
//		DET := DET + STR0028 + " " // "       FALTOU        "
		DET := DET + Repl("_",20)+"*" + " "
	EndIf

	If TRA->TR_SITCUR == "R"
		cReserva := STR0020 //"RESERVADO"
	ElseIf TRA->TR_SITCUR == "L"
		cReserva := STR0021 //"LISTA ESPERA"
	ElseIf TRA->TR_SITCUR == "S"
		cReserva := STR0022 //"SOLICITACAO"
	Else
		cReserva := STR0023 //"CONCLUIDO"
	EndIf

	DET := DET + PadR(cReserva,5) + " "
	DET := DET + PadR(TRA->TR_NOMEG,15)+ " "
	DET := DET + PadR(TRA->TR_NOMED,20) + " "
	DET := DET + PadR(TRA->TR_NOMEC,25)
	
	IMPR(DET,"C")
	IMPR("","C")
	IMPR("","C")

	dbSelectArea( "TRA" )
	dbSkip()
EndDo

IMPR("","C")
DET := REPL("-",132)
IMPR(DET,"C")
IMPR("","C")
		
dbSelectArea("RA7")
dbSeek(xFilial()+RA2->RA2_INSTRU)
DET := STR0024 + PadR(RA7->RA7_NOME,30) + " - " + Repl("_",85) //"INSTRUTOR: "
IMPR(DET,"C")
IMPR("","F")
LI := 00

Return Nil
