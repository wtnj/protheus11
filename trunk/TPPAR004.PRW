#Include "RwMake.ch"

/*=====================================================================*\
|	Data:	12/2008                                                     |
|	Módulo:	SIGAPPAP                                                    |
|	Tipo:	Cadastro                                                    |
|	Resumo:	Relatorio de Aprovação do Processo de Fabricação            |
\*=====================================================================*/

User Function TPPAR004

	Private oFont01		:= TFont():New("Times New Roman",,10,,.f.,,,,,.f. )
	Private oFont01n	:= TFont():New("Times New Roman",,10,,.t.,,,,,.f. )
	Private oFont02n	:= TFont():New("Times New Roman",,22,,.t.,,,,,.f. )
	Private oFont03		:= TFont():New("Times New Roman",,16,,.f.,,,,,.f. )
	Private oFont03n	:= TFont():New("Times New Roman",,16,,.t.,,,,,.f. )
	Private oFont04		:= TFont():New("Times New Roman",,12,,.f.,,,,,.f. )
	Private oFont04n	:= TFont():New("Times New Roman",,12,,.t.,,,,,.f. )
	Private oFont05		:= TFont():New("Arial",,12,,.f.,,,,,.f. )
	Private nMaxPag	:= 2
	Private nLin	:= 0
	//Private cPerg	:= PadR("TPPAR004",Len(SX1->X1_GRUPO))
	
	//Cria o Grupo de Perguntas
	//sfCriaPerg()
	
	//If ! Pergunte(cPerg,.t.)
	//	Return
	//EndIf
	
	Processa({|| sfProcessa() },"Gerando documento...")

Return
	
//Funcao: Processamento da Informacoes
Static Function sfProcessa()
/*	
	Local cQuery	:= ""
	Local aAreaZC6	:= ZC6->(GetArea())

	If Select("QRYZC6") <> 0
		dbSelectArea("QRYZC6")
		dbCloseArea()
	EndIf
	
	cQuery := "SELECT ZC6.R_E_C_N_O_ ZC6RECNO, * "
	cQuery += "FROM "+RetSqlName("ZC6")+" ZC6 "
	cQuery += "WHERE ZC6_FILIAL = '"+xFilial("ZC6")+"' AND ZC6.D_E_L_E_T_ = ' ' "
	cQuery += "AND ZC6_VEIC = '"+mv_par01+"' "
	cQuery += "AND ZC6_EMISS = '"+DtoS(mv_par02)+"' "
	cQuery += "AND ZC6_CODCLI = '"+mv_par03+"' "
	cQuery += "AND ZC6_LOJCLI = '"+mv_par04+"' "
	cQuery += "AND ZC6_PECA = '"+mv_par05+"' "
	cQuery += "AND ZC6_PLANTA = '"+mv_par06+"' "
	cQuery += "AND ZC6_DTREV = ' ' "
	cQuery += "AND ZC6_APROV != 'N' "
	
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "QRYZC6", .F., .T.)
	dbSelectArea("QRYZC6")
	

	If QRYZC6->(Eof())
		MsgStop("Nao ha dados para Impressão!")
		RestArea(aAreaZC6)
		Return
	EndIf
*/	

	//Cria Objeto para impressao Grafica
	oPrn := TMSPrinter():New("Aprovação de Processos de Fabricação")
	oPrn:Setup()

/*	
	While QRYZC6->(!Eof())

		dbSelectArea("ZC6")
		ZC6->(dbGoTo(QRYZC6->ZC6RECNO))
*/
		For nPag := 1 to nMaxPag
		
			//Impressao do Cabecalho
			sfCabecalho()
			
			//Impressao da Pagina
			If nPag == 1
				sfPagina1()
	
			ElseIf nPag == 2
				sfPagina2()
	
			EndIf
		
		
			//Finaliza a Pagina
			oPrn:EndPage()
		
		Next nPag
/*		
		QRYZC6->(dbSkip())
	EndDo
*/	
	oPrn:Preview()
	//oPrn:Print()
	
	//RestArea(aAreaZC6)
	
Return

//Funcao: Impressao do Cabecalho
Static Function sfCabecalho()
	
	nLin := 250

	//Inicia Pagina Nova
	oPrn:StartPage()
	
	//Box principal
    oPrn:Box(nLin,50,640,2270)
    
    //Logo da Empresa
	oPrn:SayBitmap(nLin+20,70,"\system\logo_whb.jpg",339,150)
	
    oPrn:line(nLin,460,640,460)//C
    
	//Primeira Linha do Cabecalho
    oPrn:Say (280,720, "APROVAÇÃO DO PROCESSO DE FABRICAÇÃO",oFont03n,100)
   // oPrn:Say (360,720, "FABRICAÇÃO Nº",oFont02n,100) 
    oPrn:Say (360,1030,ZC6->ZC6_DOCUM,oFont04n,100)
	oPrn:Say (360,1150, "/",oFont04n,100)
    oPrn:Say (360,1160,ZC6->ZC6_REV,oFont04n,100)
    
    oPrn:line(nLin,1940,640,1940)//C
    
    oPrn:Say(nLin+20,1960,"Folha:",oFont01,100)
    oPrn:Say(nLin+20,2140,AllTrim(Str(nPag))+"/"+AllTrim(Str(nMaxPag)),oFont03n,100)

    oPrn:Say(nLin+80,1960,"Chefe Projeto:",oFont01,100)
	oPrn:Say(nLin+120,2060,ZC6->ZC6_CHEFE,oFont03n,100)
    
    //Segunda Linha do Cabecalho
    nLin := 440
    oPrn:line(nLin,50,nLin,2270)//L

    oPrn:Say(nLin+10,70,"Fornecedor:",oFont01n,100)
    oPrn:Say(nLin+50,70,"WHB",oFont03,100)
    
    oPrn:Say(nLin+10,480,"Planta:",oFont01n,100)
    oPrn:Say(nLin+50,500,ZC6->ZC6_PLANTA,oFont03,100)

	oPrn:line(nLin,780,540,780)//C    
    oPrn:Say(nLin+10,800,"Veíc./Motor:",oFont01n,100)
    oPrn:Say(nLin+50,820,ZC6->ZC6_VEIC,oFont03,100)

    
	oPrn:line(nLin,1120,640,1120)//C    
    oPrn:Say(nLin+10,1140,"DMS/Início de Produção:",oFont01n,100)
    oPrn:Say(nLin+50,1160,DtoC(ZC6->ZC6_INICIO),oFont03,100)


	oPrn:line(nLin,1520,640,1520)//C    
    oPrn:Say(nLin+10,1540,"Data Emissão:",oFont01n,100)
    oPrn:Say(nLin+50,1560,DtoC(ZC6->ZC6_EMISS),oFont03n,100)

    oPrn:Say(nLin+10,1960,"Validação PV /",oFont01n,100)
    oPrn:Say(nLin+50,1980,ZC6->ZC6_VALID,oFont03,100)

    //Terceira Linha do Cabecalho
    nLin := 540
    oPrn:line(nLin,50,nLin,2270)//L

    oPrn:Say(nLin+10,70,"Nro. Peça:",oFont01n,100)
    oPrn:Say(nLin+50,90,ZC6->ZC6_PECA,oFont03,100)

    oPrn:Say(nLin+10,480,"Denominação:",oFont01n,100)
    oPrn:Say(nLin+50,500,ZC6->ZC6_DENOM,oFont01,100)

    oPrn:Say(nLin+10,1140,"Cliente:",oFont01n,100)
    oPrn:Say(nLin+50,1160,ZC6->ZC6_CODCLI,oFont03,100)

    oPrn:Say(nLin+10,1540,"Operação:",oFont01n,100)
    oPrn:Say(nLin+50,1560,"De "+AllTrim(ZC6->ZC6_OPEDE)+" até "+AllTrim(ZC6->ZC6_OPEATE),oFont03,100)

    oPrn:Say(nLin+10,1960,"Indíce / Data",oFont01n,100)
    oPrn:Say(nLin+50,1980,DtoC(ZC6->ZC6_DATA),oFont03,100)
	
Return

//Impressao dos Dados da Primeira Pagina
Static Function sfPagina1()
	nLin := 680

	//Box principal do item 1
    oPrn:Box(nLin,50,1840,2270)

    oPrn:Say(nLin,70,"Conforme Plano de Fabricação da peça verificar:",oFont03n,100)
    oPrn:Say(nLin,1820,"Motivo",oFont03,100)

    oPrn:line(nLin,1160,1840,1160)//C

    nLin := 740
    oPrn:line(nLin,50,nLin,2270)//L

    nLin := 760
    oPrn:Say(nLin,70,"1 - MÉTODO:",oFont04n,100)
    
    nLin := 840
    oPrn:Say(nLin,70,"1.1.Revisão de desenho validade pelo cliente.",oFont04,100)
    sfDetMotivo(nLin,"101")

    nLin := 910
    oPrn:Say(nLin,70,"1.2.FMEA/AMDEC prevêem ações para NPR > que os objetivos.",oFont04,100)
    sfDetMotivo(nLin,"102")

    nLin := 990
    oPrn:Say(nLin,70,"1.3.Conhecimento/definição de Características Especiais (CTFE/PSA)",oFont04,100)
    sfDetMotivo(nLin,"103")

    nLin := 1070
    oPrn:Say(nLin,70,"1.4.Método Trabalho/Planos de Controle definidos e validados.",oFont04,100)
    sfDetMotivo(nLin,"104")

    nLin := 1140
    oPrn:Say(nLin,70   ,"1.5.Os riscos vinculados ao processo foram previstos durante o",oFont04,100)
    oPrn:Say(nLin+40,70,"desenvolvimento",oFont04,100)
    sfDetMotivo(nLin,"105")

    nLin := 1220
    oPrn:Say(nLin,70   ,"1.6.Previsto a organização do processo de produção operacional até a",oFont04,100)
    oPrn:Say(nLin+40,70,"expedição dos produtos",oFont04,100)
    sfDetMotivo(nLin,"106")

    nLin := 1300
    oPrn:Say(nLin,70   ,"1.7.Coerência do fluxo de produção (seqüência de fabricação,",oFont04,100)
    oPrn:Say(nLin+40,70,"retrabalho, operações terceirizadas, rastreabilidade, risco de troca, peças",oFont04,100)
    oPrn:Say(nLin+80,70,"não-conformes e transporte.)",oFont04,100)
    sfDetMotivo(nLin+20,"107")

    nLin := 1440
    oPrn:Say(nLin,70   ,"1.8.Identificação do produto no processo e após liberação (etiquetagem,",oFont04,100)
    oPrn:Say(nLin+40,70,"armazenamento, expedição).",oFont04,100)
    sfDetMotivo(nLin,"108")

    nLin := 1520
    oPrn:Say(nLin,70   ,"1.9.Os monitoramentos do produto identificados no processo estão",oFont04,100)
    oPrn:Say(nLin+40,70,"adequados?",oFont04,100)
    sfDetMotivo(nLin,"109")

    nLin := 1620
    oPrn:Say(nLin,70,"1.10.Realizado e validado os estudos de capabilidade do processo?",oFont04,100)
    sfDetMotivo(nLin,"110")

    nLin := 1700
    oPrn:Say(nLin,70,"1.11.Amostras do produto disponíveis e validadas?",oFont04,100)
    sfDetMotivo(nLin,"111")
    
    nLin := 1780
    oPrn:Say(nLin,70,"1.12.Embalagem definida e disnponível",oFont04,100)
    sfDetMotivo(nLin,"112")


	//Box principal do item 2
	nLin := 1870
    oPrn:Box(nLin,50,2210,2270)
    oPrn:line(nLin,1160,2210,1160)//C

    nLin := 1880
    oPrn:Say(nLin,70,"2. MATERIAL",oFont04n,100)
    
    nLin := 1940
    oPrn:Say(nLin,70,"2.1.Os controles de Inspeção de Recebimento estao de acordo",oFont04,100)
    oPrn:Say(nLin+40,70,"com as necessidades (ensaios de validação do produto conforme)",oFont04,100)
    sfDetMotivo(nLin,"201")

    nLin := 2060
    oPrn:Say(nLin,70,"2.2.Características e Especificações de desenho controladas",oFont04,100)
    sfDetMotivo(nLin,"202")

    nLin := 2120
    oPrn:Say(nLin,70   ,"2.3.Os fornecedores de matéria-prima e componentes são",oFont04,100)
    oPrn:Say(nLin+40,70,"qualificados",oFont04,100)
    sfDetMotivo(nLin,"203")


	//Box principal do item 3
	nLin := 2230
    oPrn:Box(nLin,50,2400,2270)
	oPrn:line(nLin,1160,2400,1160)//C

    nLin := 2240
    oPrn:Say(nLin,70,"3. MEIOS DE MEDIÇÃO",oFont04n,100)
    
    nLin := 2300
    oPrn:Say(nLin,70,"3.1.Estão previstos os meios de controle para garantir uma",oFont04,100)
    oPrn:Say(nLin+40,70,"aprovação regular, conforme expectativas do cliente?",oFont04,100)
    sfDetMotivo(nLin,"301")


	//Box principal do item 4
	nLin := 2420
    oPrn:Box(nLin,50,2660,2270)
    oPrn:line(nLin,1160,2660,1160)//C

    nLin := 2430
    oPrn:Say(nLin,70,"4. MEIO AMBIENTE",oFont04n,100)
    
    nLin := 2490
    oPrn:Say(nLin,70,"4.1.As condições do ambiente de trabalho estão adequadas ao ",oFont04,100)
    oPrn:Say(nLin+40,70,"produto e ao processo",oFont04,100)
    sfDetMotivo(nLin,"401")

    nLin := 2600
    oPrn:Say(nLin,70,"4.2.Foram analisados riscos de acidentes no posto de trabalho?",oFont04,100)
    sfDetMotivo(nLin,"402")


	//Box principal do item 5
	nLin := 2690
    oPrn:Box(nLin,50,2850,2270)
    oPrn:line(nLin,1160,2850,1160)//C

    nLin := 2700
    oPrn:Say(nLin,70,"5. MÃO-DE-OBRA",oFont04n,100)
    
    nLin := 2760
    oPrn:Say(nLin,70,"5.1.Os operadores foram treinados? Os registros foram",oFont04,100)
    oPrn:Say(nLin+40,70,"preenchidos e mantidos (inclusive para treinamento on the job)",oFont04,100)
    sfDetMotivo(nLin,"501")
    
    nLin := 3100
    oPrn:Say(nLin,1800,"FM03.000005 - REV.003",oFont05,100)

Return

//Impressao dos Dados da Primeira Pagina
Static Function sfPagina2()
	nLin := 670

	//Box principal do item 1
    oPrn:Box(nLin,50,1140,2270)
    oPrn:line(nLin,1160,1140,1160)//C

    nLin := 680
    oPrn:Say(nLin,70,"6. MÁQUINA",oFont04n,100)
    
    nLin := 760
    oPrn:Say(nLin,70,"6.1. Equipamentos / máquinas.",oFont04,100)
    sfDetMotivo(nLin-10,"601")

    nLin := 840
    oPrn:Say(nLin,70,"6.2. Dispositivos identificados e liberados?",oFont04,100)
    sfDetMotivo(nLin-10,"602")

    nLin := 920
    oPrn:Say(nLin,70,"6.3. Acessórios",oFont04,100)
    sfDetMotivo(nLin-10,"603")

    nLin := 1000
    oPrn:Say(nLin,70,"6.4. Ferramenta",oFont04,100)
    sfDetMotivo(nLin-10,"604")

    nLin := 1090
    oPrn:Say(nLin,70,"6.5. Programas CNC (back-up na rede?)",oFont04,100)
    sfDetMotivo(nLin-10,"605")


	//Box principal do item Obsevações Adicinais
	nLin := 1170
	oPrn:Box(nLin,50,1400,2270)
	oPrn:line(nLin,1590,1400,1590)//C
	oPrn:line(nLin,2000,1400,2000)//C

	nLin := 1180
	oPrn:Say(nLin,70,"Observações Adicionais",oFont03,100)

	//Impressao da Observacao Adicional
	nLinObs := MLCount(ZC6->ZC6_OBSAD,200)

	nLin := 1240

	For nM := 1 to nLinObs
		oPrn:Say(nLin,70,Memoline(ZC6->ZC6_OBSAD,200,nM),oFont04,100)
		nLin += 50
		
		If nM == 3
			Exit
		EndIf

	Next nM
	
	//Box com informacoes das Correcoes a Fazer
	nLin := 1430
	oPrn:Box(nLin,50,2560,2270)
	oPrn:line(nLin,1590,2000,1590)//C
	oPrn:line(nLin,2000,2000,2000)//C

	nLin += 10
	oPrn:Say(nLin,70,"Correções a fazer:",oFont03,100)
	oPrn:Say(nLin,1700,"Responsável:",oFont03,100)
	oPrn:Say(nLin,2100,"Prazo",oFont03,100)

	nLin := 1500
	
	//Impressao das Correcoes a Fazer
	oPrn:Say(nLin,70,ZC6->ZC6_CORREC,oFont04,100)

	nLin := 2000
	oPrn:line(nLin,50,nLin,2270)//L

	nLin += 10
	oPrn:Say(nLin,70,"Cientes Assinatura:",oFont03n,100)
	
	oPrn:Say(nLin,640,"Produção:",oFont03,100)
	oPrn:Say(nLin,1160,"Qualidade:",oFont03,100)
	oPrn:Say(nLin,1640,"Engenharia:",oFont03,100)

	nLin := 2060
	oPrn:line(nLin,50,nLin,2270)//L
	
	oPrn:Say(nLin,70,"Resultados Obtidos:",oFont03n,100)
	
	nLin := 2110
	oPrn:line(nLin,50,nLin,2270)//L

	//Impressao dos Resultados Obtidos
	nLinObs := MLCount(ZC6->ZC6_RESULT,200)

	nLin := 2120

	For nM := 1 to nLinObs
		oPrn:Say(nLin,70,Memoline(ZC6->ZC6_RESULT,200,nM),oFont04,100)
		nLin += 52
		
		If nM == 8
			Exit
		EndIf

	Next nM

	//Box com informacoes das Aprovacoes Finais
	nLin := 2580
	oPrn:Box(nLin,50,2940,2270)
	
	nLin := 2630
	oPrn:Say(nLin,100,"Aprovação Final:",oFont03,100)
	oPrn:Say(nLin,600,"Engenharia: "+Posicione("QAA",1, xFilial("QAA")+ZC6->ZC6_ENG ,"QAA_NOME"),oFont03,100)
	oPrn:Say(nLin,1540,"Data: "+DtoC(ZC6->ZC6_DTENG),oFont03,100)
	
	nLin := 2730
	oPrn:Say(nLin,600,"Produção: "+Posicione("QAA",1, xFilial("QAA")+ZC6->ZC6_PROD ,"QAA_NOME"),oFont03,100)
	oPrn:Say(nLin,1540,"Data: "+DtoC(ZC6->ZC6_DTPROD),oFont03,100)

	nLin := 2830
	oPrn:Say(nLin,600,"Qualidade: "+Posicione("QAA",1, xFilial("QAA")+ZC6->ZC6_QUAL ,"QAA_NOME"),oFont03,100)
	oPrn:Say(nLin,1540,"Data: "+DtoC(ZC6->ZC6_DTQUAL),oFont03,100)

    nLin := 3100
    oPrn:Say(nLin,1800,"FM03.000005 - REV.003",oFont05,100)

Return


//Funcao que Imprime os campos para Ok e Não Ok (Motivos)
Static Function sfDetMotivo(mv_Linha,mv_Questao)
	Local cCpoQuest	:= "ZC6_QUE"+mv_Questao
	Local cCpoMotiv	:= "ZC6_MOT"+mv_Questao
	Local lOk		:= If(ZC6->&cCpoQuest=="1",.t.,.f.)


	oPrn:Box(mv_Linha,1170,mv_Linha+40,1170+40)
    If lOk
    	oPrn:line(mv_Linha,1170,mv_Linha+40,1170+40)//L
    	oPrn:line(mv_Linha+40,1170,mv_Linha,1170+40)//L
    EndIf
    oPrn:Say(mv_Linha,1220,"OK",oFont03n,100)


	oPrn:Box(mv_Linha,1320,mv_Linha+40,1320+40)
    If ! lOk
    	oPrn:line(mv_Linha,1320,mv_Linha+40,1320+40)//L
    	oPrn:line(mv_Linha+40,1320,mv_Linha,1320+40)//L
    EndIf

    oPrn:Say(mv_Linha,1380,"NÃO OK",oFont03n,100)
    
	If ! lOk
		oPrn:Say(mv_Linha,1600,ZC6->&cCpoMotiv ,oFont03,100)
	EndIf
    oPrn:line(mv_Linha+60,1560,mv_Linha+60,2270)//L

Return
/*
//Funcao para Criar o Grupo de Perguntas
Static Function sfCriaPerg()
	Local aRegs := {}
	Local i,j

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Veículo?"		,"","","mv_ch1","C",TamSX3("ZC6_VEIC")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZC6"})
	aAdd(aRegs,{cPerg,"02","Emissão?"		,"","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Cod Cliente?"	,"","","mv_ch3","C",TamSX3("A1_COD")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	aAdd(aRegs,{cPerg,"04","Loja?"			,"","","mv_ch4","C",TamSX3("A1_LOJA")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Peça?"			,"","","mv_ch5","C",TamSX3("ZC6_PECA")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","ZC6"})
	aAdd(aRegs,{cPerg,"06","Planta?"		,"","","mv_ch6","C",TamSX3("ZC6_PLANTA")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","ZC6"})

	For i:=1 to Len(aRegs)
	    If !dbSeek(cPerg+aRegs[i,2])
	        RecLock("SX1",.T.)
	        For j:=1 to FCount()
	            If j <= Len(aRegs[i])
	                FieldPut(j,aRegs[i,j])
	            Endif
	        Next
	        MsUnlock()
	    Endif
	Next

Return
*/