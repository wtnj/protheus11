#include "rwmake.ch"        
#INCLUDE "TRM030.CH"
#include "report.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o       ³ TRM030   ³ Autor ³ Eduardo Ju              ³ Data ³ 30.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ Custo dos Treinamentos  		                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ TRM030                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³ BOPS ³  Motivo da Alteracao 		 	 	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tania     	³20/09/2006³100265³Acertos para o Relatorio personalizavel, do ³±±
±±³          	³          ³      ³Release 4. Inclusao do Ajusta SX1.          ³±±
±±³Eduardo Ju  	³23/01/2007³120221³Correcao do Filtro do Periodo.              ³±±
±±³Eduardo Ju  	³05/04/2007³122629³Validacao do cAliasQry.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM030()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta SX1 para trabalhar com range.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaTR030RSx1()
	Pergunte("TR030R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM030R3()	
EndIf  

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 30.05.06 ³±±
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
Local cAliasQry := "" 
Local lRet:= .T.     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:=TReport():New("TRM030",STR0009,"TR030R",{|oReport| PrintReport(oReport,cAliasQry)},STR0002+" "+STR0003)	//"Custo de Treinamento"#"Será impresso de acordo com os parametros solicitados pelo usuario"
//oReport:SetLandscape()	//Imprimir Somente Paisagem
oReport:SetTotalInLine(.F.) //Totaliza em linha
Pergunte("TR030R",.F.)

Aadd( aOrdem, STR0004)	// "Matricula"
Aadd( aOrdem, STR0005)	// "Centro de Custo"
Aadd( aOrdem, STR0006)	// "Nome" 
Aadd( aOrdem, STR0016) 	// "Data"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao:³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1 := TRSection():New(oReport,STR0041,{"RA4","RA1","RA2","RA9","RA0","RA7"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection1:SetTotalInLine(.F.) 

TRCell():New(oSection1,"RA4_CURSO","RA4",STR0031)		//Codigo do Curso    
TRCell():New(oSection1,"RA1_DESC","RA1","")			//Descricao do Curso
TRCell():New(oSection1,"RA4_SINONI","RA4",STR0032)		//Codigo do Sinonimo do Curso    
TRCell():New(oSection1,"RA9_DESCR","RA9","")			//Descricao do Sinonimo do Curso
TRCell():New(oSection1,"RA4_CALEND","RA4")				//Codigo do Calendario de Treinamento    
TRCell():New(oSection1,"RA2_DESC","RA2","")			//Descricao do Calendario de Treinamento    
TRCell():New(oSection1,"RA4_TURMA","RA4")				//Turma     
TRCell():New(oSection1,"RA4_DATAIN","RA4",STR0033)		//Periodo: Data Inicio do Curso
TRCell():New(oSection1,"RA4_DATAFI","RA4","",,,,,,,,.T.)		//Periodo: Data Final do Curso 
TRCell():New(oSection1,"RA4_ENTIDA","RA4",STR0034) 	//Codigo da Entidade do Curso 	
TRCell():New(oSection1,"RA0_DESC","RA0","")			//Descricao da Entidade do Curso 	
TRCell():New(oSection1,"RA2_INSTRU","RA2") 				//Codigo do Instrutor
TRCell():New(oSection1,"RA7_NOME","RA7")				//Nome do Instrutor
TRCell():New(oSection1,"RA4_HORAS","RA4")				//Horario
TRCell():New(oSection1,"RA2_DURACA","RA2")				//Duracao
TRCell():New(oSection1,"RA2_UNDURA","RA2","")			//Unidade de Duracao
TRCell():New(oSection1,"RA2_LOCAL","RA2")				//Local
oSection1:SetLineStyle()                                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,STR0042,{"RA4","SRA"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSection2:SetTotalInLine(.F.)

TRCell():New(oSection2,"RA4_MAT","RA4",STR0035)		//Matricula do Funcionario
TRCell():New(oSection2,"RA_NOME","SRA",STR0036)		//Nome do Funcionario
TRCell():New(oSection2,"RA4_VALOR","RA4",STR0037)		//Custo
TRCell():New(oSection2,"RA4_HORAS","RA4",STR0038)		//Horas 
TRCell():New(oSection2,"RA4_PRESEN","RA4",STR0039)		//Percentual de Presença
TRCell():New(oSection2,"RA4_NOTA","RA4",STR0040)		//Nota

TRFunction():New(oSection2:Cell("RA4_MAT"),/*cId*/,"COUNT",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
TRFunction():New(oSection2:Cell("RA4_VALOR"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
TRFunction():New(oSection2:Cell("RA4_HORAS" ),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/)

oSection2:SetTotalText({|| Alltrim(STR0029)}) //Total 

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 30.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio (Custo do Treinamento)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport,cAliasQry)

Local cFil 		:= ""
Local cMat 		:= ""
Local cCc  		:= ""
Local cNom 		:= ""
Local cCur 		:= ""
Local cGru 		:= ""
Local cDep 		:= ""
Local cCar 		:= "" 
Local dPer		:= ""
Local cRel		:= ""
Local cSituacao := ""
Local nFerProg  := ""
Local cSitFol   := "" 
Local cOrder:= ""
Local nOrdem  	:= 	oReport:Section(1):GetOrder()

#IFNDEF TOP
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local cArqDBF  	:= CriaTrab(NIL,.f.)
	Local aFields 	:= {}
	Local cAcessaRA4:= &("{ || " + ChkRH("TRM030","RA4","2") + "}")  
	Local cFiltro	:= ""
	Local cChave1	:= ""
	Local cChave2	:= ""                  
#ELSE
	Local lQuery    := .F. 
	Local i := 0
	Local cSitQuery := ""
#ENDIF	

#IFNDEF TOP
	//-- Transforma parametros Range em expressao (intervalo)
	MakeAdvplExpr("TR030R")	   
	cAliasQry := "SRA" 
#ELSE	
	//-- Transforma parametros Range em expressao SQL
	MakeSqlExpr("TR030R")
	cAliasQry := GetNextAlias()
#ENDIF

//+--------------------------------------------------------------+
//¦ Carregando variaveis mv_par?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
cFil 		:= mv_par01
cMat 		:= mv_par02
cCc  		:= mv_par03
cNom 		:= mv_par04
cCur 		:= mv_par05
cGru 		:= mv_par06
cDep 		:= mv_par07
cCar 		:= mv_par08
dPer		:= mv_par09
cRel		:= mv_par10
cSituacao 	:= mv_par11
nFerProg  	:= mv_par12

#IFNDEF TOP
	//-- Transforma parametros Range em expressao (intervalo)
	If nOrdem == 1 		// Matricula 
		cOrder  := "TR_FILIAL + TR_CURSO + TR_CALEND + TR_TURMA + TR_MAT"
		cChave1 := "cFilRA4 + cCurso + cCalend + cTurma"
		cChave2 := "TR_FILIAL + TR_CURSO + TR_CALEND + TR_TURMA"
	ElseIf nOrdem == 2	// Centro de Custo + Matricula
		cOrder  := "TR_FILIAL + TR_CC + TR_CURSO + TR_CALEND + TR_TURMA + TR_MAT"
		cChave1 := "cFilRA4 + cCentro + cCurso + cCalend + cTurma"
		cChave2 := "TR_FILIAL + TR_CC + TR_CURSO + TR_CALEND + TR_TURMA"
	ElseIf nOrdem == 3	// Nome	
		cOrder  := "TR_FILIAL + TR_CURSO + TR_CALEND + TR_TURMA + TR_NOME"
		cChave1 := "cFilRA4 + cCurso + cCalend + cTurma"
		cChave2 := "TR_FILIAL + TR_CURSO + TR_CALEND + TR_TURMA"
	ElseIf nOrdem == 4	// Data
		cOrder  := "TR_FILIAL + DTOS(TR_DATAIN) + TR_CURSO + TR_CALEND + TR_TURMA + TR_MAT"	
		cChave1 := "cFilRA4 + cDatain + Curso + cCalend + cTurma"
		cChave2 := "TR_FILIAL + DTOS(TR_DATAIN) + TR_CURSO + TR_CALEND + TR_TURMA"
	EndIf	

	If !Empty(cFil)
		cFiltro:= cFil
	EndIf  
	
	If !Empty(cMat)
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cMat
	EndIf  
	       
	If !Empty(cCur)
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cCur
	EndIf  
	
	If !Empty(dPer)
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += dPer
	EndIf 
	
	//Define um filtro para a tabela principal da secao
	oSection2:SetFilter(cFiltro)
	
	If !Empty(cCc)		//SRA
		cFiltro := cCc
	EndIf  
	       
	If !Empty(cNom)		//SRA
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cNom
	EndIf  
	       
	//Define um filtro para a tabela principal da secao
	oSection2:SetFilter(cFiltro,,,"SRA")

	AADD(aFields,{"TR_FILIAL" ,"C",02,0})
	AADD(aFields,{"TR_CC"     ,"C",09,0})
	AADD(aFields,{"TR_MAT"    ,"C",06,0})
	AADD(aFields,{"TR_NOME"   ,"C",30,0})
	AADD(aFields,{"TR_CURSO"  ,"C",04,0})
	AADD(aFields,{"TR_DESCURS","C",30,0})
	AADD(aFields,{"TR_GRUPO"  ,"C",02,0})
	AADD(aFields,{"TR_DEPTO"  ,"C",03,0})
	AADD(aFields,{"TR_CARGO"  ,"C",05,0})
	AADD(aFields,{"TR_CUSTO"  ,"N",12,2})
	AADD(aFields,{"TR_PRESEN" ,"N",06,2})
	AADD(aFields,{"TR_NOTA"   ,"N",06,2})
	AADD(aFields,{"TR_HORAS"  ,"N",07,2})
	AADD(aFields,{"TR_DATAIN" ,"D",08,0})
	AADD(aFields,{"TR_DATAFI" ,"D",08,0})
	AADD(aFields,{"TR_CALEND" ,"C",04,0})
	AADD(aFields,{"TR_DESCCAL","C",20,0})
	AADD(aFields,{"TR_TURMA"  ,"C",03,0})
	AADD(aFields,{"TR_ENTIDA" ,"C",04,0})
	AADD(aFields,{"TR_DESCEN" ,"C",15,0})
	AADD(aFields,{"TR_HORARI" ,"C",15,0})
	AADD(aFields,{"TR_DURACA" ,"C",07,0})
	AADD(aFields,{"TR_UNDURA" ,"C",01,0})
	AADD(aFields,{"TR_INSTRU" ,"C",06,0})
	AADD(aFields,{"TR_NOMEIN" ,"C",15,0})
	AADD(aFields,{"TR_LOCAL"  ,"C",15,0})
	AADD(aFields,{"TR_SINON"  ,"C",04,0})
	AADD(aFields,{"TR_DESCSI" ,"C",30,0})
	
	dbCreate(cArqDbf,aFields)
	dbUseArea(.T.,,cArqDbf,"TRA",.F.)
	
	cArqNtx  := CriaTrab(NIL,.f.)
	IndRegua("TRA",cArqNtx,cOrder,,,STR0012) //"Selecionando Registros..."
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Arquivo Principal: Cursos do Funcionario ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("RA4")	
	oReport:SetMeter(RecCount())
	
	While !Eof()
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
			 
		If !Eval(cAcessaRA4)
			dbSkip()
			Loop
		EndIf
	   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 			Calendario de Treinamento    			   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("RA2")
		dbSeek(xFilial("RA2")+RA4->RA4_CALEND+RA4->RA4_CURSO+RA4->RA4_TURMA)
		
		dbSelectArea("SRA")
		dbSetOrder(1)
		
		If dbSeek(RA4->RA4_FILIAL+RA4->RA4_MAT)		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Situacao do Funcionario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSitFol := TrmSitFol()  
			cCargo 	:= fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)		
				
			If	!Empty(cCc) 
				If &("!(SRA->" + cCc + ")")
					dbSelectArea("RA4")
					dbSkip()
					Loop
				EndIf
			EndIf			

			If	!Empty(cNom)
				If &("!(SRA->" + cNom + ")")
					dbSelectArea("RA4")
					dbSkip()
					Loop
				EndIf
			EndIf			

			If	(!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
				(cSitfol == "P" .And. nFerProg == 2)
				dbSelectArea("RA4")
				dbSkip()
				Loop
			EndIf			
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Cargo, Grupo e Departamento		 	   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  				
			dbSelectArea( "SQ3" )
			dbSetOrder(1)
			cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
			If dbSeek( cFil + cCargo + SRA->RA_CC ) .Or. dbSeek( cFil + cCargo ) 			
				If !Empty(cGru)
					If &("!" + cGru)
						dbSelectArea("RA4")
						dbSkip()
						Loop
					EndIf
				EndIf

				If !Empty(cDep)
					If &("!" + cDep)
						dbSelectArea("RA4")
						dbSkip()
						Loop
					EndIf
				EndIf

				If !Empty(cCar)
					If &("!" + cCar)
						dbSelectArea("RA4")
						dbSkip()
						Loop
					EndIf
				EndIf
			Else	
				dbSelectArea("RA4")
				dbSkip()
				Loop	
			EndIf
					
			RecLock("TRA",.T.)
			TRA->TR_FILIAL  	:= SRA->RA_FILIAL
			TRA->TR_CC      	:= SRA->RA_CC
			TRA->TR_MAT     	:= SRA->RA_MAT
			TRA->TR_NOME		:= SRA->RA_NOME
			TRA->TR_CURSO	 	:= RA4->RA4_CURSO
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
			TRA->TR_TURMA		:= RA4->RA4_TURMA
			TRA->TR_ENTIDA		:= RA4->RA4_ENTIDA
			TRA->TR_HORARI		:= RA2->RA2_HORARI
			TRA->TR_DURACA		:= STR(RA2->RA2_DURACA,7,2)
			TRA->TR_UNDURA		:= RA2->RA2_UNDURA
			TRA->TR_INSTRU		:= RA2->RA2_INSTRU
			TRA->TR_LOCAL		:= RA2->RA2_LOCAL
			TRA->TR_SINON		:= RA4->RA4_SINONI
			MsUnlock()
		EndIf		
	
	   	dbSelectArea("RA4")
	   	dbSkip()
	EndDo
	
	dbSelectArea("TRA")
	dbGotop()	
	
	TRPosition():New(oSection1,"RA4",1,{|| RhFilial("RA4",TRA->TR_FILIAL) + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA})
	TRPosition():New(oSection1,"RA4",3,{|| RhFilial("RA4",TRA->TR_FILIAL) + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA}) 
	TRPosition():New(oSection1,"RA1",1,{||	RhFilial("RA1",TRA->TR_FILIAL) + TRA->TR_CURSO}) 
	TRPosition():New(oSection1,"RA2",1,{|| RhFilial("RA2",TRA->TR_FILIAL) + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA})                            
	TRPosition():New(oSection1,"RA9",1,{|| RhFilial("RA9",TRA->TR_FILIAL) + TRA->TR_SINON}) 
	TRPosition():New(oSection1,"RA0",1,{|| RhFilial("RA0",TRA->TR_FILIAL) + TRA->TR_ENTIDA}) 
	TRPosition():New(oSection1,"RA7",1,{|| RhFilial("RA7",TRA->TR_FILIAL) + TRA->TR_INSTRU})
	
	TRPosition():New(oSection2,"RA4",3,{|| RhFilial("RA4",TRA->TR_FILIAL) + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA+TRA->TR_MAT})
	TRPosition():New(oSection2,"SRA",1,{|| RhFilial("SRA",TRA->TR_FILIAL) + TRA->TR_MAT}) 
	
	If	cRel == 1	// Sintetico
	   	oSection2:Hide()
	   	oSection2:SetTotalInLine(.T.) 
	EndIf
	
	While TRA->( !Eof() ) 
	
		oReport:IncMeter()
	
		If oReport:Cancel()
			Exit
		EndIf
	   
	  	//VALIDAR
		cFilRA4	:= TRA->TR_FILIAL	
		cCurso 	:= TRA->TR_CURSO 
	    cCalend := TRA->TR_CALEND
	    cTurma	:= TRA->TR_TURMA
	    cCentro := TRA->TR_CC
		cDataIn	:= dTos(TRA->TR_DATAIN)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao da Primeira Secao: Curso ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSection1:Init()
		oSection1:PrintLine()
				
		oSection2:Init()
		
		Do While ! Eof() .And. &cChave1 == &cChave2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da Segunda Secao: Funcionarios ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
			oSection2:PrintLine()  
			dbSelectArea("TRA")
			dbSkip()
		EndDo
	
		oSection2:Finish()
		oSection1:Finish()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino do Relatorio                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRA")
	dbCloseArea()
	fErase(cArqNtx + OrdBagExt())
	fErase(cArqDbf + GetDBExtension())

#ELSE	
	//-- Filtragem do relatório
	//-- Query do relatório da secao 1
	lQuery := .T.
	oReport:Section(1):BeginQuery()	
	
	If nOrdem == 1 		// Matricula 
		cOrder := "%RA4_FILIAL,RA4_CURSO,RA4_CALEND,RA4_TURMA,RA4_MAT%"
	ElseIf nOrdem == 2	// Centro de Custo + Matricula
		cOrder := "%RA4_FILIAL,RA_CC,RA4_CURSO,RA4_CALEND,RA4_TURMA,RA4_MAT%"
	ElseIf nOrdem == 3	// Nome	
		cOrder := "%RA4_FILIAL,RA4_CURSO,RA4_CALEND,RA4_TURMA,RA_NOME%"
	ElseIf nOrdem == 4	// Data
		cOrder := "%RA4_FILIAL,RA4_DATAIN,RA4_CURSO,RA4_CALEND,RA4_TURMA,RA4_MAT%"	
	EndIf
	
	BeginSql Alias cAliasQry
		SELECT 	RA4_CURSO,RA1_DESC,RA4_SINONI,RA9_DESCR,RA4_CALEND,RA2_DESC,RA4_TURMA,RA4_DATAIN,RA4_DATAFI,
				RA4_ENTIDA,RA0_DESC,RA2_INSTRU,RA7_NOME,RA4_HORAS,RA2_DURACA,RA2_UNDURA,RA2_LOCAL,RA4_VALOR,
				RA4_HORAS,RA4_PRESEN,RA4_NOTA,RA4_MAT,RA_NOME,Q3_GRUPO,Q3_DEPTO,Q3_CARGO,RA_SITFOLH, RA_FILIAL,
				RA_MAT, RA_ADMISSA, RA_DEMISSA				 
		FROM 	%table:RA4% RA4  
		LEFT JOIN %table:RA1% RA1
			ON RA1_FILIAL = %xFilial:RA1%
			AND RA1_CURSO = RA4_CURSO
			AND RA1.%NotDel%
		LEFT JOIN %table:RA2% RA2
			ON RA2_FILIAL = %xFilial:RA2%
			AND RA2_CALEND = RA4_CALEND
			AND RA2_CURSO = RA4_CURSO
			AND RA2_TURMA = RA4_TURMA
			AND RA2.%NotDel%
		LEFT JOIN %table:RA9% RA9
			ON RA9_FILIAL = %xFilial:RA9%
			AND RA9_SINONI   = RA4_SINONI
			AND RA9.%NotDel%
		LEFT JOIN %table:RA0% RA0
			ON RA0_FILIAL = %xFilial:RA1%
			AND RA0_ENTIDA = RA4_ENTIDA
			AND RA0.%NotDel%		
		LEFT JOIN %table:RA7% RA7
			ON RA7_FILIAL = %xFilial:RA7%
			AND RA7_INSTRU = RA2_INSTRU
			AND RA7.%NotDel%  
		LEFT JOIN %table:SRA% SRA
			ON RA_FILIAL = %xFilial:SRA%
			AND RA_MAT = RA4_MAT
			AND SRA.%NotDel% 
		LEFT JOIN %table:SQ3% SQ3
			ON Q3_FILIAL = %xFilial:SQ3%
			AND Q3_CARGO = RA_CARGO
			AND SQ3.%NotDel%			 								
		WHERE RA4_FILIAL = %xFilial:RA4% AND 
			RA4.%NotDel%							
		ORDER BY %Exp:cOrder%                 		
	EndSql
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery({cFil,cMat,cCc,cNom,cCur,cGru,cDep,cCar,dPer})	//*Array com os parametros do tipo Range*
	
	//-- Inicio da impressao do fluxo do relatório
	oReport:SetMeter(RA4->(LastRec()))

	//-- Utiliza a query do Pai
	oReport:Section(1):Section(1):SetParentQuery()
	oReport:Section(1):Section(1):SetParentFilter( { |cParam| (cAliasQry)->RA4_CALEND + (cAliasQry)->RA4_CURSO + (cAliasQry)->RA4_TURMA  == cParam },{ || (cAliasQry)->RA4_CALEND + (cAliasQry)->RA4_CURSO + (cAliasQry)->RA4_TURMA })
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do Relatorio Sintetico ou Analitico    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	cRel == 1	// Sintetico
	   	oReport:Section(1):Section(1):Hide()
	   	oReport:Section(1):Section(1):SetTotalInLine(.T.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Situacao do Funcionario ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	For i:= 1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,i,1)+"'"
		If ( i+1 ) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next i     
	If nFerProg = 1
		cSitQuery += ",'P'" 
	EndIf

	oReport:Section(1):Section(1):SetLineCondition({|| TrmSitFol() $ cSitQuery})
	oReport:Section(1):Print()	 	
#ENDIF	
	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaTR030RSx1³ Autor ³ Tania Bronzeri   ³ Data ³20/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta SX1 para Trabalhar com Range                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A partir do Release 4                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function AjustaTR030RSx1()

Local aRegs		:= {}
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

aHelp := {	"Informe intervalo de filiais que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de filiais que ",;
			"desea considerar para impresion ",;
			"del informe" }
aHelpI:= {	"Enter branch range to be considered ",;
			"to print report." }
cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues   Pergunta Espanhol    Pergunta Ingles   Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01 DefSPA1  DefEng1 Cnt01        Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","01","Filial ?"           ,"¿Sucursal ?"       ,"Branch ?"       ,"MV_CH1","C" ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR01",""    ,""      ,""    ,"RA4_FILIAL",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"XM0",""    ,"S"  ,""      ,""     ,""      ,cHelp}) 


aHelp := {	"Informe intervalo de matriculas que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de matriculas que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter registration range to be ",;
			"considered for printing the report." }
cHelp := ".RHMATRIC."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem  Pergunta Portugues  Pergunta Espanhol    Pergunta Ingles  Variavel  Tipo  Tamanho Decimal Presel GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3  GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","02","Matricula ?"       ,"¿Matricula ?"     ,"Registration ?","MV_CH2" ,"C"  ,99     ,0      ,0     ,"R" ,""     ,"MV_PAR02",""    ,""      ,""     ,"RA4_MAT",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""  ,"SRA",""    ,"S"  ,""     ,""       ,""     ,cHelp})


aHelp := {	"Informe intervalo de Centros de Custo ",;
			"que deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de centros de costo ",;
			"que desea considerar para impresion ",;
			"del informe." }
aHelpI:= {	"Enter the cost center range to be ",;
			"considered for printing the report." }
cHelp := ".RHCCUSTO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol   Pergunta Ingles  Variavel Tipo Tamanho  Decimal Presel GSC   Valid   Var01      Def01 DefSPA1  DefEng1  Cnt01   Var02  Def02  DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3  GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","03","Centro de Custo ?","¿Centro de Costo ?","Cost Center ?" ,"MV_CH3","C" ,99      ,0      ,0     ,"R"  ,""     ,"MV_PAR03",""    ,""      ,""    ,"RA_CC",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTT","004"  ,"S"  ,""      ,""      ,""     ,cHelp})


aHelp := {	"Informe intervalo de nomes de funcio-",;
			"narios que deseja considerar para im-",;
			"pressao do relatorio." }
aHelpE:= {	"Informe intervalo de nombres de empleados ",;
			"que desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of employee names to be ",;
			"considered for printing the report." }
cHelp := ".RHNOME."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol  Pergunta Ingles  Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1  Cnt01    Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3     GrgSxg  cPyme aHelpPor aHelpEng  aHelpSpa cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","04" ,"Nome ?"           ,"¿Nombre ?"       ,"Name ?"        ,"MV_CH4" ,"C"  ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR04",""    ,""      ,""     ,"RA_NOME",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""  ,"SRA01",""    ,"S"  ,""     ,""      ,""      ,cHelp})


aHelp := {	"Informe intervalo de Cursos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de Cursos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Courses to be considered ",;
			"for printing the report." }
cHelp := ".TR030R05."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01       Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","05" ,"Curso ?"          ,"¿Curso ?"       ,"Course ?"     ,"MV_CH5" ,"C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR05",""    ,""      ,""     ,"RA4_CURSO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"RA1",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Grupos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de Grupos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Groups to be considered ",;
			"for printing the report." }
cHelp := ".TR030R06."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","06" ,"Grupo ?"          ,"¿Grupo ?"       ,"Group ?"      ,"MV_CH6","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR06",""    ,""      ,""     ,"Q3_GRUPO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQ0",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Departamentos ",;
			"que deseja considerar para impressao ",;
			"do relatorio. " }
aHelpE:= {	"Informe intervalo de Sectores que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Department to be ",;
			"considered for printing the report." }
cHelp := ".TR030R07."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","07" ,"Departamento ?"   ,"¿Sector ?"      ,"Department ?" ,"MV_CH7","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR07",""    ,""      ,""     ,"Q3_DEPTO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQB",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Cargos que ",;
			"deseja considerar para impressao ",;
			"do relatorio. " }
aHelpE:= {	"Informe intervalo de Funciones que ",;
			"desea considerar para impresion del ",;
			"informe. " }
aHelpI:= {	"Enter range of Jobs to be considered ",;
			"for printing the report." }
cHelp := ".TR030R08."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","08" ,"Cargo ?"          ,"¿Funcion ?"      ,"Job ?"       ,"MV_CH8","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR08",""    ,""      ,""     ,"Q3_CARGO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQ3",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Periodos que ",;
			"deseja considerar para impressao do ",;
			"relatorio. Exemplo: 01/04/06-31/08/06." }
aHelpE:= {	"Informe intervalo de periodos que ",;
			"desea considerar para impresion del ",;
			"informe. Ejemplo: 01/04/06-31/08/06." }
aHelpI:= {	"Enter range of Periods to be considered ",;
			"for printing the report. Example: ",;
			"01/04/06-31/08/06." }
cHelp := ".TR030R09."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem  Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid        Var01      Def01       DefSPA1     DefEng1      Cnt01        Var02 Def02        DefSpa2     DefEng2    Cnt02 Var03 Def03  DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05  XF3 GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","09","Periodo ?"        ,"¿Periodo ?"     ,"Period ?"     ,"MV_CH9","D" ,99     ,0      ,0     ,"R",""           ,"MV_PAR09",""         ,""         ,""          ,"RA4_DATAIN",""   ,""         ,""         ,""        ,""   ,""   ,""    ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,aHelp   ,aHelpI  ,aHelpE  ,cHelp      })
Aadd(aRegs,{"TR030R","10","Relatorio ?"      ,"¿Informe ?"     ,"Report ?"     ,"MV_CHA","N" ,1      ,0      ,2     ,"C","NaoVazio()" ,"MV_PAR10","Sintetico","Sintetico","Summarized",""          ,""   ,"Analitico","Analitico","Detailed",""   ,""   ,""    ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,""      ,""      ,""      ,".RHTPREL."})
Aadd(aRegs,{"TR030R","11","Situacoes ?"      ,"¿Situaciones ?" ,"Status ?"     ,"MV_CHB","C" ,5      ,0      ,0     ,"G","fSituacao()","MV_PAR11",""         ,""         ,""          ,""          ,""   ,""         ,""         ,""        ,""   ,""   ,""    ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,""      ,""      ,""      ,".RHSITUA."})


aHelp := {	"Informe se deseja considerar Ferias ",;
			"Programadas." }
aHelpE:= {	"Informe si desea considerar ",;
			"Vacaciones Programadas." }
aHelpI:= {	"Inform if you want to consider ",;
			"Scheduled Vacation. " }
cHelp := ".TR030R12."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues     Pergunta Espanhol           Pergunta Ingles        Variavel Tipo Tamanho Decimal Presel GSC Valid          Var01      Def01 DefSPA1 DefEng1 Cnt01 Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05  XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR030R","12" ,"Ferias Programadas ?","¿Vacaciones Programadas ?","Scheduled Vacation?" ,"MV_CHC","N" ,1      ,0      ,1     ,"C","NaoVazio()" ,"MV_PAR12","Sim","Si"   ,"Yes"  ,""   ,""   ,"Nao","No"   ,"No"   ,""   ,""   ,""  ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


ValidPerg(aRegs,"TR030R",.T.)
                    
/*
PROGRAMA FONTE ORIGINAL ABAIXO
*/

User Function TRM030R3()	

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,AREGS,TITULO,WNREL,NORDEM")
SetPrvt("CARQDBF,AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM")
SetPrvt("CFIL,NTOTQT,NTOTVALOR,NTOTHORAS,NTOTGVL,NTOTGQT,NTOTGHR,NTOTFUNC")
SetPrvt("NCUSTO,NHORAS,NPRESENC,NNOTA,CAUXCURSO,CAUXTURMA,LRET")
SetPrvt("NTIPO,CCENTRO,CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET,LIMP")
SetPrvt("CENTIDA,CDESCEN,CHORARI,CDURACA,CUNDURA,CINSTRU,CNOMEIN,CLOCAL")
SetPrvt("cAcessaRA4,CSINON,CDESCSI,CCARGO")

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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Relato   ³ Autor ³ Equipe R.H.	        ³ Data ³ 16.03.99 ³±±
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
AADD(aFields,{"TR_HORAS"  ,"N",07,2})
AADD(aFields,{"TR_DATAIN" ,"D",08,0})
AADD(aFields,{"TR_DATAFI" ,"D",08,0})
AADD(aFields,{"TR_CALEND" ,"C",05,0})
AADD(aFields,{"TR_DESCCAL","C",20,0})
AADD(aFields,{"TR_TURMA"  ,"C",03,0})
AADD(aFields,{"TR_ENTIDA" ,"C",04,0})
AADD(aFields,{"TR_DESCEN" ,"C",15,0})
AADD(aFields,{"TR_HORARI" ,"C",15,0})
AADD(aFields,{"TR_DURACA" ,"C",07,0})
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
dbSeek(mv_par01+mv_par03+mv_par09,.T.) //Filial + Matricula+ Curso
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
		cCargo 	:= fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)		
		
		If 	(SRA->RA_FILIAL	< mv_par01) .Or. (SRA->RA_FILIAL	> mv_par02) .Or.;
			(SRA->RA_MAT  	< mv_par03) .Or. (SRA->RA_MAT 		> mv_par04)	.Or.;
			(SRA->RA_CC   	< mv_par05) .Or. (SRA->RA_CC  		> mv_par06)	.Or.;
			(SRA->RA_NOME 	< mv_par07) .Or. (SRA->RA_NOME		> mv_par08)	.Or.;
			(cCargo 		< mv_par15) .Or. (cCargo		 	> mv_par16)	.Or.;
			(!(cSitfol $ cSituacao) 	.And.(cSitFol <> "P"))				.Or.;
			(cSitfol == "P" .And. nFerProg == 2)
			
			dbSelectArea("RA4")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea( "SQ3" )
		dbSetOrder(1)
		cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
		If dbSeek( cFil + cCargo + SRA->RA_CC ) .Or. dbSeek( cFil + cCargo ) 			
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
		TRA->TR_DURACA		:= STR(RA2->RA2_DURACA,7,2)
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
cDtIni      := dtoc(TRA->TR_DATAIN)
cDtFim		:= dtoc(TRA->TR_DATAFI)

While !Eof()
    
	If lRet
		If nOrdem == 2
			FImpCC()
		EndIf
		lRet:= .F.
	EndIf		

	If mv_par19	== 1			// Sintetico
		If nOrdem != 2 .And. cCurso+cCalend+cTurma+cDtIni+cDtFim != TRA->TR_CURSO+TRA->TR_CALEND+TRA->TR_TURMA+dtoc(TRA->TR_DATAIN)+dtoc(TRA->TR_DATAFI)
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
			cDtIni      := dtoc(TRA->TR_DATAIN)
			cDtFim		:= dtoc(TRA->TR_DATAFI)
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
		If nOrdem != 2 .And. cCurso+cCalend+cTurma+cDtIni+cDtFim <> TRA->TR_CURSO+TRA->TR_CALEND+TRA->TR_TURMA+dtoc(TRA->TR_DATAIN)+dtoc(TRA->TR_DATAFI)
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
			cDtIni      := dtoc(TRA->TR_DATAIN)
			cDtFim		:= dtoc(TRA->TR_DATAFI)
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
		CCABEC1	:= STR0014	//"   FIL. MATR.  NOME                             QTDE.         CUSTO      HORAS   %PRES   NOTAS" 
	Else
		CCABEC1 := STR0015	//"   FIL. NOME                            MATR.   QTDE.         CUSTO      HORAS   %PRES   NOTAS"
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
	cAuxDet:= STR0020+cCalend+" - "+cDescCal + STR0017+cCurso+" - "+cDescCur +  STR0018+cTurma + STR0021+Dtoc(TRA->TR_DATAIN)+" - "+Dtoc(TRA->TR_DATAFI) // " CALENDARIO: " / " CURSO: " / "TURMA: " / " PERIODO: "
	IMPR(cAuxDet,"C")                                            

	cAuxDET := STR0030 + cSinon + " - " + cDescSi + STR0025+cInstru+" - "+cNomeIn	//"SINONIMO DO CURSO: " / " INSTRUTOR: " 
	IMPR(cAuxDet,"C")		
	
	cAuxDET	:= STR0024+cEntida+" - "+cDescEn  + STR0028+cLocal + STR0026+cHorari + STR0027+Transform(cDuraca,"9999.99")+" "+cUnDura  //"ENTIDADE: " / " LOCAL: "/ " HORARIO: " / " DURACAO: "
	IMPR(cAuxDet,"C")            		
	FImpCab()      
	DET 	:= Space(55)
	
Else							// Analitico
	If cAuxCurso+cAuxTurma == cCurso+cTurma
		cCurso  := Space(05)
		cAuxDet	:= ""
		cTurma	:= Space(03)
	Else
		cAuxCurso := cCurso
		cAuxTurma := cTurma
		
		cAuxDet:= STR0020+cCalend+" - "+cDescCal + STR0017+cCurso+" - "+cDescCur +  STR0018+cTurma + STR0021+Dtoc(TRA->TR_DATAIN)+" - "+Dtoc(TRA->TR_DATAFI) // " CALENDARIO: " / " CURSO: " / "TURMA: " / " PERIODO: "
		IMPR(cAuxDet,"C")                                            

		cAuxDET := STR0030 + cSinon + " - " + cDescSi + STR0025+cInstru+" - "+cNomeIn	//"SINONIMO DO CURSO: " / " INSTRUTOR: " 
		IMPR(cAuxDet,"C")		
		
		cAuxDET	:= STR0024+cEntida+" - "+cDescEn  + STR0028+cLocal + STR0026+cHorari + STR0027+Transform(cDuraca,"9999.99")+" "+cUnDura  //"ENTIDADE: " / " LOCAL: "/ " HORARIO: " / " DURACAO: "
		IMPR(cAuxDet,"C")            		
		FImpCab()		
	EndIf	
	If nOrdem != 3 
		DET := "   "
		DET += TRA->TR_FILIAL + Space(03) + TRA->TR_MAT + Space(01) + TRA->TR_NOME + Space(08)
 	Else
		DET := "   "
		DET += TRA->TR_FILIAL + Space(03) + TRA->TR_NOME + Space(01) + TRA->TR_MAT + Space(08)
	EndIf
	cCurso := cAuxCurso								
	cTurma := cAuxTurma
	DET += Space(2)
EndIf
DET += Transform(nCusto,"99999,999.99") + Space(03)
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
    DET := UPPER(STR0029)+ ":                 "	// "TOTAL:                 "
EndIf

DET += Space(24)
DET += Transform(nTotQt		,"99999") + Space(01)
DET += Transform(nTotValor	,"9999999,999.99") + Space(01) 
DET += Transform(nTotHoras	,"9999999.99") 
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