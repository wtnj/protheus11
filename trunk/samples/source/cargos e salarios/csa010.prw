#INCLUDE "Protheus.ch"
#INCLUDE "CSA010.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CSA010   ³ Autor ³ Equipe Desenvolv. R.H.³ Data ³ 04/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Aprovacao de Vagas de uma empresa.     		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSA010(void)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 		ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³      ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSA010()
Local cDesc1  := STR0001		//"Relatorio de Aprovacao de Aumento de Quadro de Funcionarios."
Local cDesc2  := STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0003		//"usuario."
Local cString := "RBE"
Local cAux	  := ""
Local aOrd	  := {STR0004}  	//"Centro de Custo"

Private aReturn  := {STR0005,1,STR0006,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
Private NomeProg := "CSA010"
Private nLastKey := 0
Private cPerg	 := "CS010A"
Private nOrdem 	 := 1
Private AT_PRG	 := "CSA010"
Private wCabec0  := 1
Private wCabec1	 :=	STR0007 //"     ANO/MES FUNCAO                          VL.ATUAL  VL.PREVISTO  VL.APROVADO QT.ATUAL QT.PREV. QT.APROV. DT. APROV. APROVADOR " 
							//      9999/01 123456789012345678901234567 123456789012 123456789012 123456789012  123456   123456    123456  99/99/9999 1234567890
Private Contfl   := 1
Private Li		 := 0
Private nTamanho := "M"
Private TITULO   := STR0008		//" Aprovacao de Aumento de Quadro "
Private cFilDe, cFilAte, cCCDe, cCCAte, cDtDe, cDtAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("CS010A",.F.)             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na pergunte                                 ³
//³ mv_par01				// Filial De                             ³
//³ mv_par02				// Filial Ate                            ³
//³ mv_par03				// Centro de Custo De                    ³
//³ mv_par04				// Centro de Custo Ate                   ³
//³ mv_par05				// Funcao De                             ³
//³ mv_par06				// Funcao Ate                            ³
//³ mv_par07				// Ano/Mes De                            ³
//³ mv_par08				// Ano/Mes Ate                           ³
//³ mv_par09				// Imprime:	   1-Analitico / 2-Sintetico ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="CSA010"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@TITULO,cDesc1,cDesc2,cDesc3,.F.,aOrd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilDe	:= Iif(xFilial("RBE")== Space(02), Space(02), mv_par01)
cFilAte	:= mv_par02
cCCDe	:= mv_par03
cCCAte	:= mv_par04
cFunDe 	:= mv_par05
cFunAte	:= mv_par06
cDtDe	:= mv_par07
cDtAte	:= mv_par08
nImprim	:= mv_par09
nTotFun := mv_par10
nTotPer := mv_par11

If 	Val(Substr(cDtDe,1,4)) < 1900 .Or.;
	Val(Substr(cDtAte,1,4)) < 1900
    Help("",1,"CSR060ANO")      // Verifique o Ano das perguntes
    Return Nil
EndIf             

If	Val(Substr(cDtDe,5,2)) < 1 	.Or.;
	Val(Substr(cDtDe,5,2)) > 12 	.Or.;
	Val(Substr(cDtAte,5,2)) < 1 	.Or.;
	Val(Substr(cDtAte,5,2)) > 12
	Help("",1,"CSR060MES")		// Verifique o Mes das perguntes	
	Return Nil
EndIf		

If 	cDtDe > cDtAte
	Help("",1,"CSR060MAIO")	// Ano/Mes De deve ser menor que ANO/MES Ate
	Return Nil
EndIf

cAux := cDtDe
While Val( cAux ) <= Val( cDtAte)
	nMes := Val(Substr(cAux,5,2)) + 1
	nAno := Val(Substr(cAux,1,4))
	If nMes > 12
		cAux := StrZero(nAno + 1,4) + "01"
	Else
		cAux := StrZero(nAno,4) + StrZero(nMes,2)
	EndIf
EndDo    

nOrdem  := aReturn[8]

If 	nLastKey == 27
	Return Nil
EndIf

SetDefault(aReturn,cString)

If 	nLastKey == 27
	Return Nil
EndIf

RptStatus({|lEnd| Cs010Imp()},TITULO)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CS010Imp ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 04/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Aprovacoes de vagas.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Cs010Imp()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico 											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function Cs010Imp()
Local cAcessaRBE:= &("{ || " + ChkRH(FunName(),"RBE","2") + "}")
Local cInicio	:=""
Local cFim		:=""                                    
Local cAuxCC	:= "!!!!!!!!!"
Local l1Vez		:= .T.
Local lPrimF 	:= .T.
Local lPrimP 	:= .T.
Local cAnoMes   := ""
Local cFunc  	:= ""
Local cDtApro   := ""                                                                        
Local nP_VLATUA := nP_VLPREV := nP_VLAPRO := nP_QTATUA := nP_QTPREV := nP_QTAPRO := 0	//Totais Periodo
Local nC_VLATUA := nC_VLPREV := nC_VLAPRO := nC_QTATUA := nC_QTPREV := nC_QTAPRO := 0	//Totais C.Custo
Local nG_VLATUA := nG_VLPREV := nG_VLAPRO := nG_QTATUA := nG_QTPREV := nG_QTAPRO := 0	//Totais Geral

dbSelectArea("RBE")
dbSetOrder(1)     
dbSeek(cFilDe+cCCDe+cDtDe+cFunDe,.T.)
cInicio := "RBE->RBE_FILIAL+RBE->RBE_CC+RBE->RBE_ANOMES+RBE->RBE_FUNCAO"
cFim    := cFilAte+cCCAte+cDtAte+cFunAte

SetRegua(RBE->(RecCount()))

While	!Eof() .And. &cInicio <= cFim

	If !Eval(cAcessaRBE)
		dbSkip()  
		Loop
	EndIf      

	If RBE->RBE_FILIAL < cFilDe .Or. RBE->RBE_FILIAL > cFilAte
		dbSkip()
		Loop
	EndIf
	
	If RBE->RBE_CC < cCCDe .Or. RBE->RBE_CC > cCCAte
		dbSkip()
		Loop
	EndIf
	
	If RBE->RBE_ANOMES < cDtDe .Or. RBE->RBE_ANOMES > cDtAte
		dbSkip()
		Loop
	EndIf
	
	If RBE->RBE_FUNCAO < cFunDe .Or. RBE->RBE_FUNCAO > cFunAte
		dbSkip()
		Loop
	EndIf
	
	IncRegua()
	
	If 	!l1Vez	
		cDet := ""
		IMPR(cDet,"C")			
	Else
		l1Vez := .F.
	EndIf

	cDet:=	Space(01)+RBE->RBE_FILIAL
	If 	cAuxCC # RBE->RBE_CC .Or.;
		(li >= 58 .And. cAuxCC == RBE->RBE_CC)
		cDet	:= STR0009 +RBE->RBE_CC+Space(01)+DescCC(RBE->RBE_CC,xFilial("SI3"),25)	//"Centro de Custo: "
		cAuxCC 	:= RBE->RBE_CC
		Impr(cDet,"C")         
		Impr("","C")
	EndIf	          

	//"     ANO/MES FUNCAO                          VL.ATUAL  VL.PREVISTO  VL.APROVADO QT.ATUAL QT.PREV. QT.APROV. DT. APROV. APROVADOR " 
	//      9999/01 123456789012345678901234567 123456789012 123456789012 123456789012  123456   123456    123456  99/99/9999 1234567890

	nC_VLATUA := 0
    nC_VLPREV := 0
    nC_VLAPRO := 0
    nC_QTATUA := 0
    nC_QTPREV := 0
    nC_QTAPRO := 0
    
	While RBE->RBE_CC == cAuxCC	// C.Custo

		If !Eval(cAcessaRBE)
			dbSkip()  
			Loop
		EndIf      

		If RBE->RBE_CC < cCCDe .Or. RBE->RBE_CC > cCCAte
			dbSkip()
			Loop
		EndIf

		If RBE->RBE_ANOMES < cDtDe .Or. RBE->RBE_ANOMES > cDtAte
			dbSkip()
			Loop
		EndIf
	
		cAnoMes := RBE->RBE_ANOMES
		lPrimP 	:= .T.	  		
		
		nP_VLATUA := 0
        nP_VLPREV := 0
        nP_VLAPRO := 0
        nP_QTATUA := 0
        nP_QTPREV := 0
        nP_QTAPRO := 0
	
		While RBE->RBE_CC+RBE->RBE_ANOMES == cAuxCC+cAnoMes  // Periodo
	
			If RBE->RBE_FUNCAO < cFunDe .Or. RBE->RBE_FUNCAO > cFunAte
				dbSkip()
				Loop
			EndIf

			lPrimF 	:= .T.	  

			cFunc	:= RBE->RBE_FUNCAO		
			While RBE->RBE_CC+RBE->RBE_ANOMES+RBE_FUNCAO == cAuxCC+cAnoMes+cFunc // Funcao
      
				If nImprim == 1		//Analitico
					If lPrimP == .T.
						cDet:= 	Space(05)+Substr(RBE->RBE_ANOMES,1,4)+"/"+Substr(RBE->RBE_ANOMES,5,2)
						cDet+= 	Space(01)+RBE->RBE_FUNCAO+" - "+FDesc("SRJ",RBE->RBE_FUNCAO,"RJ_DESC",20)
						lPrimP := .F.
						lPrimF := .F.
					ElseIf lPrimF == .T.
						cDet:= 	Space(12)
						cDet+= 	Space(01)+RBE->RBE_FUNCAO+" - "+FDesc("SRJ",RBE->RBE_FUNCAO,"RJ_DESC",20)					
						lPrimF := .F.	
					Else 
					    cDet:= Space(40)
					EndIf
		    
					cDet+= 	Space(27)+Transform(RBE->RBE_VLAPRO,"@E 99999,999.99")  			
					cDet+=	Space(21)+Transform(RBE->RBE_QTAPRO,"@E 999999")  
					cDtApro:= If(__SetCentury(),Dtoc(RBE->RBE_DTAPRO),Dtoc(RBE->RBE_DTAPRO)+Space(2))
					cDet+= 	Space(02)+cDtApro
					cDet+= 	Space(01)+Transform(RBE->RBE_USUARI,"@!")  			
					IMPR(cDet,"C")
				EndIf

				dbSkip()
			EndDo

			dbSelectArea("RBD")
			dbSetOrder(1)
			If dbSeek(xFilial("RBD")+cAuxCC+cAnoMes+cFunc) 
	
				If nImprim == 1 .And. nTotFun == 1
					If Li > 54
						Impr("","P")
					EndIf
					cDet := __PrtThinLine()
					Impr(cDet,"C")
				EndIf
		
				If nImprim == 2 .Or. nTotFun == 1 //Sim
					If nImprim == 2
						cDet:= Space(05)+Substr(RBD->RBD_ANOMES,1,4)+"/"+Substr(RBD->RBD_ANOMES,5,2)
					Else 
						cDet:= Space(05)+ STR0013 //"Total -"					
					Endif
					cDet+= 	Space(01)+cFunc+" - "+FDesc("SRJ",cFunc,"RJ_DESC",20)
					cDet+= 	Space(01)+Transform(RBD->RBD_VLATUA,"@E 99999,999.99")
					cDet+= 	Space(01)+Transform(RBD->RBD_VLPREV,"@E 99999,999.99")
					cDet+= 	Space(01)+Transform(RBD->RBD_VLAPRO,"@E 99999,999.99")  					
					cDet+= 	Space(02)+Transform(RBD->RBD_QTATUA,"@E 999999")
					cDet+=	Space(03)+Transform(RBD->RBD_QTPREV,"@E 999999") 
					cDet+=	Space(04)+Transform(RBD->RBD_QTAPRO,"@E 999999") 
					Impr(cDet,"C")
				EndIf
		
				If nImprim == 1 .And. nTotFun == 1
					cDet := __PrtThinLine()
					Impr(cDet,"C")
					Impr("","C")
				EndIf
			
		        nP_VLATUA += RBD->RBD_VLATUA
     			nP_VLPREV += RBD->RBD_VLPREV
        		nP_VLAPRO += RBD->RBD_VLAPRO
        		nP_QTATUA += RBD->RBD_QTATUA
        		nP_QTPREV += RBD->RBD_QTPREV
        		nP_QTAPRO += RBD->RBD_QTAPRO
	
			EndIf
		
			dbSelectArea("RBE")	
		EndDo

		// Total do Periodo
		If nImprim == 1 .And. nTotPer == 1
			If Li > 54
				Impr("","P")
			EndIf
			cDet := __PrtThinLine()
			Impr(cDet,"C")

			cDet:= 	Space(05)+STR0012	//"Total do Periodo - "
			cDet+= 	Space(01)+Substr(cAnoMes,1,4)+"/"+Substr(cAnoMes,5,2)+ Space(08)
			cDet+= 	Space(01)+Transform(nP_VLATUA,"@E 99999,999.99")
			cDet+= 	Space(01)+Transform(nP_VLPREV,"@E 99999,999.99")
			cDet+= 	Space(01)+Transform(nP_VLAPRO,"@E 99999,999.99")  					
			cDet+= 	Space(02)+Transform(nP_QTATUA,"@E 999999")
			cDet+=	Space(03)+Transform(nP_QTPREV,"@E 999999") 
			cDet+=	Space(04)+Transform(nP_QTAPRO,"@E 999999") 
			Impr(cDet,"C")

			cDet := __PrtThinLine()
			Impr(cDet,"C")
			Impr("","C")
		EndIf
        nC_VLATUA += nP_VLATUA
        nC_VLPREV += nP_VLPREV
        nC_VLAPRO += nP_VLAPRO
        nC_QTATUA += nP_QTATUA
        nC_QTPREV += nP_QTPREV
        nC_QTAPRO += nP_QTAPRO
	EndDo   

	// Total do Centro de Custo
	cDet := __PrtThinLine()
	Impr(cDet,"C")

	cDet:= 	Space(05)+STR0010		// "Total C.Custo - "
	cDet+= 	Space(01)+cAuxCC + Space(09)
	cDet+= 	Space(01)+Transform(nC_VLATUA,"@E 99999,999.99")
	cDet+= 	Space(01)+Transform(nC_VLPREV,"@E 99999,999.99")
	cDet+= 	Space(01)+Transform(nC_VLAPRO,"@E 99999,999.99")  					
	cDet+= 	Space(02)+Transform(nC_QTATUA,"@E 999999")
	cDet+=	Space(03)+Transform(nC_QTPREV,"@E 999999") 
	cDet+=	Space(04)+Transform(nC_QTAPRO,"@E 999999") 
	Impr(cDet,"C")

	cDet := __PrtThinLine()
	Impr(cDet,"C")           
	Impr("","C")	
	
	nG_VLATUA += nC_VLATUA
    nG_VLPREV += nC_VLPREV
    nG_VLAPRO += nC_VLAPRO
    nG_QTATUA += nC_QTATUA
    nG_QTPREV += nC_QTPREV
    nG_QTAPRO += nC_QTAPRO
    
EndDo	

// Total Geral
If Li > 54
	Impr("","P")
EndIf
cDet := __PrtThinLine()
Impr(cDet,"C")

cDet:= 	Space(05)+STR0011 + Space(22)	//"Total Geral: "
cDet+= 	Space(01)+Transform(nG_VLATUA,"@E 99999,999.99")
cDet+= 	Space(01)+Transform(nG_VLPREV,"@E 99999,999.99")
cDet+= 	Space(01)+Transform(nG_VLAPRO,"@E 99999,999.99")  					
cDet+= 	Space(02)+Transform(nG_QTATUA,"@E 999999")
cDet+=	Space(03)+Transform(nG_QTPREV,"@E 999999") 
cDet+=	Space(04)+Transform(nG_QTAPRO,"@E 999999") 
Impr(cDet,"C")
	
cDet := __PrtThinLine()
Impr(cDet,"C")

//--Termino do Relatorio                                      
IMPR("","F")

Set Device To Screen                  

dbSelectArea("RBE")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
EndIf

MS_FLUSH()

Return