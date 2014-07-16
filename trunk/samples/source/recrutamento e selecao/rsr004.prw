#INCLUDE "rwmake.ch"
#INCLUDE "RSR004.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSR004    º Autor ³Emerson Grassi Rochaº Data ³  31/10/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime Testes realizados pelos candidatos.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaRsp                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RSR004()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,AREGS,TITULO,WNREL,NORDEM")
SetPrvt("CARQDBF,AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM")
SetPrvt("CFIL,NTOTGVL,NTOTGHR")
SetPrvt("CAUXCURSO,CAUXTURMA,LRET")
SetPrvt("LOK,CCENTRO,CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET")
SetPrvt("NNOTA,NPONTOS,CCHAVE,CFIL,CCURRIC,CTESTE,CQUESTAO,LFIRST,CALTERNA,NRECNO")

aOrd 	:= {}
cDesc1  := OemtoAnsi(STR0001) //"Este programa tem como objetivo imprimir relatorio "
cDesc2  := OemtoAnsi(STR0002) //"de acordo com os parametros informados pelo usuario."
cDesc3  := OemtoAnsi(STR0003) //"Testes realizados"
aRegs	:= {}
cPerg	:= "RSR04A"
cString := "SQD"
Titulo  := OemtoAnsi(STR0003) //"Testes realizados"
lEnd  	:= .F.
nTamanho:= "M"
nomeprog:= "RSR004" // Nome do programa para impressao no cabecalho
aReturn := { STR0005, 1, STR0006, 2, 2, 1, "", 1}	//"Zebrado"###"Administracao"
nLastKey:= 0
wnrel   := "RSR004" // Nome do arquivo usado para impressao em disco
cCabec  := ""
At_prg  := "RSR004"
WCabec0 := 1
Contfl  := 1
Li      := 0
Colunas := 132

dbSelectArea("SQD")
dbSetOrder(1)

// Forca a inclusao da pergunte
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  			  Grupo   	Ordem		Pergunta               		PerSpa	PerEng	Variavel		Tipo	Tam.	Dec.	Presel	GSC	Valid				Var01			Def01				DefSpa	DefEng	Cnt01				Var02		Def02				DefSpa	DefEng	Cnt02	Var03	Def03	DefSpa	DefEng	Cnt03	Var04	Def04	DefSpa	DefEng	Cnt04	Var05	Def05	DefSpa	DefEng	Cnt05	XF3		GRPSXG ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("RSR04A",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Curriculo De                             ³
//³ mv_par04        //  Curriculo Ate                            ³
//³ mv_par05        //  Teste De                                 ³
//³ mv_par06        //  Teste Ate                                ³
//³ mv_par07        //  Nota De                                  ³
//³ mv_par08        //  Nota Ate                                 ³
//³ mv_par09        //  Relatorio: Analitico / Sintetico         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel 	:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| Relato()},Titulo)
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Relato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Relato()

mv_par01:= If(xFilial("SQR") == "  ","  ",mv_par01)

If mv_par09 == 2 // Sintetico 

	WCabec1 			:= STR0007 //"Filial Curriculo Nome                            Teste  Nota"
	
	dbSelectArea("SQR")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "SQR->QR_FILIAL + SQR->QR_CURRIC" 
	cFim	:= mv_par02 + mv_par04

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If SQR->QR_FILIAL < mv_par01 .Or. SQR->QR_FILIAL > mv_par02 .Or.;
			SQR->QR_CURRIC < mv_par03 .or. SQR->QR_CURRIC > mv_par04 .Or.;
			SQR->QR_TESTE < mv_par05 .Or. SQR->QR_TESTE > mv_par06
			dbSkip()
			Loop
		EndIf              
		nNota 	:= 0
	   	cChave 	:= SQR->QR_CURRIC + SQR->QR_TESTE
		While !Eof() .And. (SQR->QR_CURRIC + SQR->QR_TESTE == cChave)
  		
			// Buscar Valor das Alternativas selecionadas
			dbSelectArea("SQO")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			nPontos := 0
			If dbSeek( cFil + SQR->QR_QUESTAO )
				 nPontos := ( SQO->QO_PONTOS * SQR->QR_RESULTA / 100 )
			EndIf   
			nNota 	+= nPontos 
			cCurric := SQR->QR_CURRIC
			cTeste  := SQR->QR_TESTE
			
			dbSelectArea("SQR")
			dbSetOrder(1)
			dbSkip()
		EndDo
		                                           
		If nNota >= mv_par07 .And. nNota  <= mv_par08
		                                       
			// Buscar Teste
			dbSelectArea("SQQ")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)			
			dbSeek( cFil + cTeste )
			
			// Buscar Curriculo
			dbSelectArea("SQG")
			dbSetOrder(1)  
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			dbSeek( cFil + cCurric )

   		// Impressao de detalhe
			DET := "  "
			DET := DET + SQG->QG_FILIAL 	+ Space(05)
			DET := DET + SQG->QG_CURRIC 	+ Space(02)
			DET := DET + SQG->QG_NOME 	+ Space(01)
			DET := DET + cTeste +" - "+ SQQ->QQ_DESCRIC + Space(01)
			DET := DET + Str(nNota,6,2)

			IMPR(DET,"C")
    	EndIf
      
		dbSelectArea("SQR")
		dbSetOrder(1)
	Enddo
	
Else // Analitico

	WCabec1 			:= STR0008 //"Filial Curriculo Nome                            Teste  Questao Alternativa Pontos"

	dbSelectArea("SQR")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "SQR->QR_FILIAL + SQR->QR_CURRIC" 
	cFim	:= mv_par02 + mv_par04

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If SQR->QR_FILIAL < mv_par01 .Or. SQR->QR_FILIAL > mv_par02 .Or.;
			SQR->QR_CURRIC < mv_par03 .or. SQR->QR_CURRIC > mv_par04 .Or.;
			SQR->QR_TESTE < mv_par05 .Or. SQR->QR_TESTE > mv_par06
			dbSkip()
			Loop
		EndIf   
		
		// Verificar a Nota do Candidato
		nRecno 	:= Recno()      
		nNota		:= 0                   
		cChave 	:= SQR->QR_CURRIC + SQR->QR_TESTE
		While !Eof() .And. (SQR->QR_CURRIC + SQR->QR_TESTE == cChave)
  		
			// Buscar Valor das Alternativas selecionadas
			dbSelectArea("SQO")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			nPontos := 0
			If dbSeek( cFil + SQR->QR_QUESTAO )
				 nPontos := ( SQO->QO_PONTOS * SQR->QR_RESULTA / 100 )
			EndIf   
			nNota 	+= nPontos 

			dbSelectArea("SQR")
			dbSetOrder(1)
			dbSkip()
		EndDo    
		If nNota >= mv_par07 .And. nNota  <= mv_par08
			dbGoto(nRecno)
		Else
			Loop	
		EndIf	
		//------------		
		
		nNota 	:= 0           
	   	cChave 	:= SQR->QR_CURRIC + SQR->QR_TESTE
	   	lFirst	:= .T.
		While !Eof() .And. (SQR->QR_CURRIC + SQR->QR_TESTE == cChave)
		
			// Buscar Valor das Alternativas selecionadas
			dbSelectArea("SQO")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			nPontos := 0
			If dbSeek( cFil + SQR->QR_QUESTAO )
				nPontos := ( SQO->QO_PONTOS * SQR->QR_RESULTA / 100 )
			EndIf     
			nNota		+= nPontos
			cCurric 	:= SQR->QR_CURRIC
			cTeste  	:= SQR->QR_TESTE
			cQuestao := SQR->QR_QUESTAO
			cAlterna	:= SQR->QR_ALTERNA

			// Buscar Teste
			dbSelectArea("SQQ")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)			
			dbSeek( cFil + cTeste )

			// Buscar Curriculo
			dbSelectArea("SQG")
			dbSetOrder(1)  
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			dbSeek( cFil + cCurric )
	
   			// Impressao de detalhe
	   		If lFirst
				DET := "  "
				DET := DET + SQG->QG_FILIAL 	+ Space(05)
				DET := DET + SQG->QG_CURRIC 	+ Space(02)
				DET := DET + SQG->QG_NOME 	+ Space(01)
				DET := DET + cTeste +" - "+ SQQ->QQ_DESCRIC + Space(04)
			Else 
				DET := Space(88)
			EndIf	
			DET := DET + cQuestao 			+ Space(08)
			DET := DET + cAlterna			+ Space(05)			
			DET := DET + Str(nPontos,6,2)

			IMPR(DET,"C")
         	lFirst := .F.
         
			dbSelectArea("SQR")
			dbSetOrder(1)
			dbSkip()
		EndDo    
		IMPR("","C")
		IMPR("Total de Pontos: "+Space(89)+Str(nNota,6,2),"C")
		IMPR(Repl("-",Colunas),"C")
	Enddo

EndIf

// Fim do Relatorio
IMPR("","F")

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil
