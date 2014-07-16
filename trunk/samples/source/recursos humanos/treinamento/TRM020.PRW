#include "rwmake.ch"  
#INCLUDE "TRM020.CH"
#include "protheus.ch"       
#include "report.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o       ³ TRM020   ³ Autor ³ Eduardo Ju              ³ Data ³ 24.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ Relatorio de Treinamentos (Solicitacao)   	               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ TRM020                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data 	   ³ BOPS ³  Motivo da Alteracao 				       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tania     	³18/09/2006³100265³Acertos para o Relatorio personalizavel, do ³±±
±±³          	³          ³      ³Release 4. Inclusao do Ajusta SX1.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM020()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta SX1 para trabalhar com range.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaTR020RSx1()
	Pergunte("TR020R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM020R3()	
EndIf  

RestArea( aArea )

Return

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("TRM020",STR0009,"TR020R",{|oReport| PrintReport(oReport,cAliasQry)},STR0017)	//"Solicitação de Treinamento"#"Este programa tem como objetivo imprimir a Solicitação de Treinamento conforme parâmetros selecionados"
oReport:SetTotalInLine(.F.) 
oReport:SetLandscape()	//Imprimir Somente Paisagem
Pergunte("TR020R",.F.)

Aadd( aOrdem, STR0004)	// "Matricula"
Aadd( aOrdem, STR0005)	// "Centro de Custo"
Aadd( aOrdem, STR0006)	// "Nome" 

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
oSection1 := TRSection():New(oReport,STR0018,{"RA3","RA1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Curso"
TRCell():New(oSection1,"RA3_CURSO","RA3",STR0018)	//Codigo do Curso    
TRCell():New(oSection1,"RA1_DESC","RA1","")		//Descricao do Curso    

TRPosition():New(oSection1,"RA1",1,{|| xFilial("RA1") + RA3->RA3_CURSO}) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//                 1                  2                  3                           4                5                6             7             8
//TRCell():New(<oParent>	, <cName>			, [ <cAlias> ]			, [ <cTitle> ]		,[ <cPicture> ] , [ <nSize> ]	 , [ <.lPixel.> ], [ <bBlock> ],; 
//             9                    10                  11                          12               13              14             15             16
//		[ <"cAlign"> ]		, [ <.lLineBreak.> ], [ <"cHeaderAlign"> ]	, [ <.lCellBreak.> ],[ <nColSpace> ], [<.lAutoSize.>], [ <nClrBack> ], [ <nClrFore> ])

oSection2 := TRSection():New(oSection1,STR0001,{"RA3","SRA","SQ3","SQ0","SQB"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Treinamento"	
TRCell():New(oSection2,"RA3_FILIAL","RA3",STR0019)			//Filial
TRCell():New(oSection2,"RA3_MAT","RA3",STR0020,,7) 			//Matricula do Funcionario
TRCell():New(oSection2,"RA_NOME","SRA",STR0021)				//Nome do Funcionario
TRCell():New(oSection2,"Q3_GRUPO","SQ3")					//Codigo do Grupo **SUPRIMIR CAMPO
TRCell():New(oSection2,"Q0_DESCRIC","SQ0",STR0022)			//Descricao do Grupo 
TRCell():New(oSection2,"Q3_DEPTO","SQ3","")					//Codigo do Depto **SUPRIMIR CAMPO
TRCell():New(oSection2,"QB_DESCRIC","SQB",STR0023,,10)		//Descricao do Depto 
TRCell():New(oSection2,"Q3_CARGO","SQ3")					//Cargo:= fGetCargo(SRA->RA_MAT) **SUPRIMIR CAMPO
TRCell():New(oSection2,"Q3_DESCSUM","SQ3",STR0024,,,,,,,,,,.F.)		//Descricao do Cargo  
TRCell():New(oSection2,"RA3_RESERV","RA3",STR0025)			//Status da Reserva (Reservado)
TRCell():New(oSection2,"RA3_DATA","RA3",STR0026,,12)		//Data da Solicitacao
TRCell():New(oSection2,"RA3_CALEND","RA3",STR0027)			//Calendario de Treinamento
TRCell():New(oSection2,"RA2_DESC","RA2","")					//Descricado do Calendario
TRCell():New(oSection2,"RA2_DATAIN","RA2",STR0028,,12)		//Periodo: Data Inicio do Curso
TRCell():New(oSection2,"RA2_DATAFI","RA2",,,12)				//Periodo: Data Final do Curso 
TRCell():New(oSection2,"RA3_TURMA","RA3")					//Turma     
TRCell():New(oSection2,"RA_CC","SRA")						//Centro de Custo
TRCell():New(oSection2,"I3_DESC","SI3","",,,,,,,,,,.F.)		//Descricao do Centro de Custo 

TRPosition():New(oSection2,"RA2",1,{|| xFilial("RA2") + RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA}) 
TRPosition():New(oSection2,"SRA",1,{|| xFilial("SRA") + RA3->RA3_MAT})
TRPosition():New(oSection2,"SQ0",1,{|| xFilial("SQ0") + SQ3->Q3_GRUPO})
TRPosition():New(oSection2,"SQB",1,{|| xFilial("SQB") + SQ3->Q3_DEPTO})
TRPosition():New(oSection2,"SI3",1,{|| xFilial("SI3") + SRA->RA_CC})

TRFunction():New(oSection2:Cell("RA3_MAT" ),/*cId*/,"COUNT",/*oBreak*/,/*cTitle*/,"9999"/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
oSection2:SetAutoSize()

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
Local cMat 		:= ""
Local cCc  		:= ""
Local cNom 		:= ""
Local cCur 		:= ""
Local cGru 		:= ""
Local cDep 		:= ""
Local cCar 		:= ""
Local nNecess	:= ""
Local cSituacao := ""
Local nFerProg  := ""
Local cSitFol   := "" 
Local nOrdem  	:= osection1:GetOrder()

#IFNDEF TOP
	Local cAcessaRA3:= &("{ || " + ChkRH("TRM020","RA3","2") + "}")
	Local cFiltro	:= ""
	Local aFields 	:= {}
	Local cArqDBF	:= ""
#ELSE
	Local lQuery    := .F. 
	Local cWhere	:= ""
	Local cOrder	:= ""
#ENDIF

#IFNDEF TOP
	//-- Transforma parametros Range em expressao (intervalo)
	MakeAdvplExpr("TR020R")	
#ELSE	
	//-- Transforma parametros Range em expressao SQL
	MakeSqlExpr("TR020R")
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
nNecess		:= If(!Empty(mv_par09),nNecess:=mv_par09,nNecess:=3)
cSituacao 	:= mv_par10
nFerProg  	:= mv_par11

#IFNDEF TOP	
	If !Empty(cFil)		//RA3
		cFiltro:= cFil 
	EndIf  
	
	If !Empty(cMat)		//RA3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cMat
	EndIf  
	       
	If !Empty(cCur)		//RA3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cCur 
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

	If !Empty(cGru)		//SQ3
		cFiltro := cGru 
	EndIf  
	
	If !Empty(cDep)		//SQ3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cDep 
	EndIf  
	
	If !Empty(cCar)		//SQ3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cCar 
	EndIf  
	
	//Define um filtro para a tabela principal da secao
	oSection2:SetFilter(cFiltro,,,"SQ3")
	
	cArqDBF  := CriaTrab(NIL,.f.)
	
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
	
	dbSelectArea("RA3")
	dbGoTop()
	
	oReport:SetMeter(RecCount())
	
	While !Eof()
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
				 
		If !Eval(cAcessaRA3)
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
		cCargo 	:= fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)
		
		If	!Empty(cCc) 
			If &("!(SRA->" + cCc + ")")
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
		EndIf			

		If	!Empty(cNom)
			If &("!(SRA->" + cNom + ")")
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
		EndIf			

		If	(!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
			(cSitfol == "P" .And. nFerProg == 2)
			dbSelectArea("RA3")
			dbSkip()
			Loop
		EndIf			
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cargo, Grupo e Departamento		 	   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	 	dbSelectArea( "SQ3" )
		dbSetOrder(1)
		cFil := If(xFilial("SQ3") == Space(2),Space(2),SRA->RA_FILIAL)
		If (dbSeek( cFil + cCargo + SRA->RA_CC ) .Or. dbSeek( cFil + cCargo ) )

			If !Empty(cGru)
				If &("!" + cGru)
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			EndIf 

			If !Empty( cDep)
				If &("!" + cDep)
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			EndIf 

			If !Empty(cCar)
				If &("!" + cCar)
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			EndIf 
		Else
			dbSelectArea("RA3")
			dbSkip()
			Loop			
		EndIf
	
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
			
		DbSelectArea("RA3")
		DbSkip()
	EndDo 
	
	dbSelectArea("TRA")
	dbGotop()
	
	TRPosition():New(oSection1,"RA1",1,{|| xFilial("RA1") + TRA->TR_CURSO})
	TRPosition():New(oSection1,"RA3",1,{|| xFilial("RA3") + TRA->TR_MAT})
	TRPosition():New(oSection2,"RA3",1,{|| xFilial("RA3") + TRA->TR_MAT}) 
	TRPosition():New(oSection2,"RA2",1,{|| xFilial("RA2") + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA})
	TRPosition():New(oSection2,"SRA",1,{|| xFilial("SRA") + TRA->TR_MAT})
	TRPosition():New(oSection2,"SQ0",1,{|| xFilial("SQ0") + TRA->TR_GRUPO})
	TRPosition():New(oSection2,"SQ3",2,{|| xFilial("SQ3") + TRA->TR_GRUPO + TRA->TR_DEPTO + TRA->TR_CARGO})
	   
	Do While ! Eof()
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		cCurso := TRA->TR_CURSO 
	    
		lFirst := .T.
		
		oSection1:Init()
		oSection1:SetTotalText( {|| STR0029 } )
		oSection1:PrintLine()
		
		oSection2:Init()	
		
		Do While !Eof() .And. cCurso == TRA->TR_CURSO    
			oSection2:SetTotalText( {|| STR0029 } )
		       
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
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao da Segunda Secao: Funcionarios			 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection2:Cell("Q3_GRUPO"):Disable()
					oSection2:Cell("Q3_DEPTO"):Disable()
					oSection2:Cell("Q3_CARGO"):Disable()
					oSection2:PrintLine()
					lFirst := .F.
	        	EndIf
	        
			Else  			//Solicitacao (S/ necessidade do cargo)     
				If !lAchou .Or. nNecess == 3
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao da Segunda Secao: Funcionarios			 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection2:Cell("Q3_GRUPO"):Disable()
					oSection2:Cell("Q3_DEPTO"):Disable()
					oSection2:Cell("Q3_CARGO"):Disable()
					oSection2:PrintLine()
					lFirst := .F.
				EndIf
			EndIf 
			
			dbSelectArea("TRA")
			dbSkip()
	
		EndDo 
	
		oSection2:Finish()
		oSection1:Finish()
		
	EndDo 
	fErase( cArqNtx + OrdBagExt() )
	fErase( cArqDBF )
	
#ELSE

	//-- Filtragem do relatório
	//-- Query do relatório da secao 1
	lQuery := .T.          
	//cOrder := "%RA3_FILIAL,RA3_CURSO%"   

	If nOrdem == 1		// Matricula 
		cOrder := "%RA3_CURSO,RA3_FILIAL,RA3_MAT%"	//"TR_FILIAL + TR_CURSO + TR_MAT"
	ElseIf nOrdem == 2	// Centro de Custo + Matricula
		cOrder := "%RA3_CURSO,RA3_FILIAL,RA_CC,RA3_MAT%"
	Else				// Nome	
		cOrder := "%RA3_CURSO,RA3_FILIAL,RA_NOME%"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Treinamento Aberto-Baixado-Ambos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	          
	/*cWhere := "%%"
	If mv_par08 == 1	//Aberto  
		cWhere := "%RA2_REALIZ <> 'S' AND%"
	ElseIf mv_par08 == 2 //Baixado
		cWhere := "%RA2_REALIZ = 'S' AND%"
	EndIf*/           
	
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
	
		SELECT	RA3_FILIAL,RA3_CURSO,RA1_DESC,RA3_MAT,RA_NOME,Q3_GRUPO,Q0_DESCRIC,Q3_DEPTO,
				QB_DESCRIC,Q3_CARGO,Q3_DESCSUM,RA3_RESERV,RA3_DATA,RA3_CALEND,RA2_DESC,
				RA2_DATAIN,RA2_DATAFI,RA3_TURMA,RA_CC/*,I3_DESC*/
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
		WHERE RA3_FILIAL = %xFilial:RA3% AND  	
			//%exp:cWhere%
			RA3.%NotDel%   										
		ORDER BY %Exp:cOrder%                 		
	EndSql
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery({cFil,cMat,cCc,cNom,cCur,cGru,cDep,cCar})	//*Array com os parametros do tipo Range*
		
	//-- Inicio da impressao do fluxo do relatório
	oReport:SetMeter(RA3->(LastRec()))

	//-- Utiliza a query do Pai
	oSection2:SetParentQuery()
	oSection2:SetParentFilter( { |cParam| (cAliasQry)->RA3_CURSO == cParam },{ || (cAliasQry)->RA3_CURSO })
	
	oSection2:Cell("Q3_GRUPO"):Disable()
	oSection2:Cell("Q3_DEPTO"):Disable()
	oSection2:Cell("Q3_CARGO"):Disable()
	oSection1:Print()	 //Imprimir

#ENDIF
	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaTR020RSx1³ Autor ³ Tania Bronzeri   ³ Data ³18/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta SX1 para Trabalhar com Range                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A partir do Release 4                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function AjustaTR020RSx1()

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
Aadd(aRegs,{"TR020R","01","Filial ?"           ,"¿Sucursal ?"       ,"Branch ?"       ,"MV_CH1","C" ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR01",""    ,""      ,""    ,"RA3_FILIAL",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"XM0",""    ,"S"  ,""      ,""     ,""      ,cHelp})


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
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol    Pergunta Ingles  Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1  Cnt01     Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3   GrgSxg  cPyme aHelpPor aHelpEng  aHelpSpa cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","02","Matricula ?"       ,"¿Matricula ?"     ,"Registration ?"  ,"MV_CH2" ,"C"  ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR02",""    ,""      ,""     ,"RA3_MAT",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""  ,"SRA",""    ,"S"  ,""     ,""       ,""     ,cHelp})


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
Aadd(aRegs,{"TR020R","03","Centro de Custo ?","¿Centro de Costo ?","Cost Center ?" ,"MV_CH3","C" ,99      ,0      ,0     ,"R"  ,""     ,"MV_PAR03",""    ,""      ,""    ,"RA_CC",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTT","004"  ,"S"  ,""      ,""      ,""     ,cHelp})


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
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","04" ,"Nome  ?"           ,"¿Nombre  ?"       ,"Name   ? "      ,"MV_CH4" ,"C"  ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR04",""    ,""      ,""     ,"RA_NOME",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""  ,"",""    ,"S"  ,""     ,""      ,""      ,cHelp}) //SRA01


aHelp := {	"Informe intervalo de Cursos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de Cursos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Courses to be considered ",;
			"for printing the report." }
cHelp := ".TR020R05."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01       Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","05" ,"Curso ?"          ,"¿Curso ?"       ,"Course ?"     ,"MV_CH5" ,"C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR05",""    ,""      ,""     ,"RA3_CURSO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"RA1",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Grupos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de Grupos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Groups to be considered ",;
			"for printing the report." }
cHelp := ".TR020R06."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","06" ,"Grupo ?"          ,"¿Grupo ?"       ,"Group ?"      ,"MV_CH6","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR06",""    ,""      ,""     ,"Q3_GRUPO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQ0",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Departamentos ",;
			"que deseja considerar para impressao ",;
			"do relatorio. " }
aHelpE:= {	"Informe intervalo de Sectores que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Department to be ",;
			"considered for printing the report." }
cHelp := ".TR020R07."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","07" ,"Departamento ?"   ,"¿Sector ?"      ,"Department ?" ,"MV_CH7","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR07",""    ,""      ,""     ,"Q3_DEPTO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQB",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Cargos que ",;
			"deseja considerar para impressao ",;
			"do relatorio. " }
aHelpE:= {	"Informe intervalo de Funciones que ",;
			"desea considerar para impresion del ",;
			"informe. " }
aHelpI:= {	"Enter range of Jobs to be considered ",;
			"for printing the report." }
cHelp := ".TR020R08."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","08" ,"Cargo ?"          ,"¿Funcion ?"      ,"Job ?"       ,"MV_CH8","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR08",""    ,""      ,""     ,"Q3_CARGO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQ3",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe se deseja gerar o Relatorio ",;
			"de Rreinamento por: Necessidade de ",;
			"Treinamento, Solicitacao de Treina-",;
			"mento ou Ambos. " }
aHelpE:= {	"Especifique si desea generar el ",;
			"informe de entrenamiento por: ",;
			"necesidad de entrenamiento, ",;
			"solicitud de entrenamiento o ambos. " }
aHelpI:= {	"Inform if you want to generate the ",;
			"Training Report by: Training Need, ",;
			"Training Requisition or Both. " }
cHelp := ".TR020R09."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol      Pergunta Ingles Variavel Tipo Tamanho Decimal Presel GSC Valid          Var01      Def01         DefSPA1     DefEng1     Cnt01 Var02 Def02         DefSpa2      DefEng2       Cnt02 Var03 Def03   DefSpa3  DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05  XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","09" ,"Treinamento por ?","¿Entrenamiento por ?","Training by ?","MV_CH9","N" ,1      ,0      ,3     ,"C","NaoVazio()" ,"MV_PAR09","Necessidade","Necesidad","Necessity",""   ,""   ,"Solicitacao","Solicitud","Requisition",""   ,""   ,"Ambos","Ambos","Both"  ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})
Aadd(aRegs,{"TR020R","10","Situacoes ?"       ,"¿Situaciones ?"      ,"Status ?"     ,"MV_CHA","C" ,5      ,0      ,0     ,"G","fSituacao()","MV_PAR10",""           ,""         ,""         ,""   ,""   ,""           ,""         ,""           ,""   ,""   ,""     ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,""      ,""      ,""      ,".RHSITUA."})


aHelp := {	"Informe se deseja considerar Ferias ",;
			"Programadas." }
aHelpE:= {	"Informe si desea considerar ",;
			"Vacaciones Programadas." }
aHelpI:= {	"Inform if you want to consider ",;
			"Scheduled Vacation. " }
cHelp := ".TR020R11."
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues     Pergunta Espanhol           Pergunta Ingles        Variavel Tipo Tamanho Decimal Presel GSC Valid          Var01      Def01 DefSPA1 DefEng1 Cnt01 Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05  XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{"TR020R","11" ,"Ferias Programadas ?","¿Vacaciones Programadas ?","Scheduled Vacation?" ,"MV_CHB","N" ,1      ,0      ,1     ,"C","NaoVazio()" ,"MV_PAR11","Sim","Si"   ,"Yes"  ,""   ,""   ,"Nao","NO"   ,"No"   ,""   ,""   ,""  ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


ValidPerg(aRegs,"TR020R",.T.)

                








//======>>>>>>>> Daqui para baixo, trata-se do release 3 ou anterior.
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
User Function TRM020R3()

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

Local lAchou 	:= .F.
Local cCargo	:= "" 

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
	cCargo 	:= fGetCargo(SRA->RA_MAT)
	
	If 	(SRA->RA_MAT  	< cMatDe)	.Or. (SRA->RA_MAT 	> cMatAte) .Or.;
		(SRA->RA_CC   	< cCcDe) 	.Or. (SRA->RA_CC  	> cCcAte)  .Or.;
		(SRA->RA_NOME 	< cNomDe) 	.Or. (SRA->RA_NOME > cNomAte) .Or.;
		(cCargo			< cCarDe) 	.Or. (cCargo		> cCarAte) .Or.;
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
	If dbSeek( cFil + cCargo + SRA->RA_CC ) .Or. dbSeek( cFil + cCargo ) 
		If 	SQ3->Q3_GRUPO < cGruDe .Or. SQ3->Q3_GRUPO > cGruAte .Or.;
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

