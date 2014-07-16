/*---------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Módulo            ! SIGAPCP                                                 !
+------------------+---------------------------------------------------------+
!Nome              ! WHB_PCPR001                                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Programa de producao diaria                             !
+------------------+---------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                     !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 19/11/2010                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACÕES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descrição detalhada da atualização      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+-------*/
#Include "Protheus.ch"
#Include "rwmake.ch"
         
user Function pWhbr001()
Local aPergs := {}

	oRelato          := Relatorio():New()
	
	oRelato:cString  := "SC2"
    oRelato:cPerg    := padr("PWHBR001",10)
	oRelato:cNomePrg := "PWHBR001"
	oRelato:wnrel    := oRelato:cNomePrg
	oRelato:cTamanho := "G"

	//descricao
	oRelato:cDesc1   := "Relatório Programa de Produção Diária."

	//titulo
	oRelato:cTitulo  := "Programa de Produção Diária"

	//cabecalho
	oRelato:cCabec1  := "Ord  Inicio  Fim   Hr.Prod   Codigo/Peça                    OP       Peso     PC Placa    Peso Conj    Mold.H    Total Mold.      Ton.       Metal         Peças     Prova Eng.      Observação"
		    
	aAdd(aPergs,{"De Linha ?"     , "C",01,0,"G","","","","","","",""}) //mv_par01
	aAdd(aPergs,{"Ate Linha?"     , "C",01,0,"G","","","","","","",""}) //mv_par02
	aAdd(aPergs,{"De Data ?"      , "D",08,0,"G","","","","","","","99/99/9999"}) //mv_par03
	aAdd(aPergs,{"Ate Data ?"     , "D",08,0,"G","","","","","","","99/99/9999"}) //mv_par04
	aAdd(aPergs,{"Hora Inicial ?" , "C",05,0,"G","","","","","","","99:99"}) //mv_par05

	oRelato:AjustaSx1(aPergs)
	
	oRelato:Run({||Imprime()})

Return

/*-----------------+--------------------------------------------------------------+
!Nome              ! Imprime                                                      !
+------------------+--------------------------------------------------------------+
!Descrição         ! Função de impressão                                          !
+------------------+--------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                          !
+------------------+-------------------------------------------------------------*/
Static Function Imprime()
Local cTurno  // variavel auxiliar para guardar o turno
Local aTotal  := {0,0,0,0}
Local aTotGer := {0,0,0}
Local aTotLin := {}
Local cLinha  := ""
Local dDia    := CtoD("  /  /  ")
Private cAl   := getNextAlias()
Private aMat  := {}

	if EMPTY(MV_PAR05)
		mv_par05 := '06:35'
//		Alert('Informe o parâmetro Hora Inicial!')
//		return
	endif

	Processa( {|| Gerando()   },"Gerando Dados para a Impressao ...") 
	Processa( {|| Matriz()    },"Distribuindo por turnos ... ")
       
	aSort(aMat,,,{ |x,y| DtoS(x[14])+x[16]+x[15]+x[1] < DtoS(y[14])+y[16]+y[15]+y[1]} ) // ordena por linha + data + turno + horaini

	//-- verifica se existem valores a imprimir
	If Len(aMat)==0
		Alert("Arquivo vazio!")
		Return .F.
	EndIf
	
	cTurno := aMat[1][15]
	
	For xM:=1 to Len(aMat)+1 // +1 para imprimir o total do ultimo item
	                            
		//-- imprime os totais por turno
	    If xM > Len(aMat) .or. cTurno <> aMat[xM][15] .or. cLinha <> aMat[xM][16] .OR. dDia <> aMat[xM][14]
	    
	    	If cLinha <> ""
		    	@Prow() +2 ,   0 psay "Total do Turno "+cTurno
				@Prow()    , 117 psay aTotal[1] PICTURE("@E 999999")  	// Total Moldes
				@Prow()    , 128 psay aTotal[2] PICTURE("@E 9999")  	// Total Toneladas
				@Prow()    , 140 psay aTotal[3] PICTURE("@E 999.99")  	// Total Metal
				@Prow()    , 153 psay aTotal[4] PICTURE("@E 999,999") 	// Total Peças
		    	@ Prow()+1 ,   0 psay __PrtThinLine()
		    	
				aAdd(aTotLin,{cTurno,aTotal}) //-- acumula os totais gerais
				
		    	//-- controle para imprimir o total também para o ultimo item
		    	If xM<=Len(aMat)
		    		cTurno := aMat[xM][15]
		    		aTotal := {0,0,0,0}
		    	EndIf
			EndIf

	    EndIf

		//-- faz a quebra por linha e por data
		If xM > Len(aMat) .or. cLinha <> aMat[xM][16] .OR. dDia <> aMat[xM][14]

			If Len(aTotLin)>0
				//-- imprime os totais por turno pela 2ª vez
				aTotal := {0,0,0,0}
				
				@Prow() +2 ,   0 psay "Turno                           Moldes                 Ton.                Peças"
				@Prow() +1 ,   0 psay Repl("_",80)
				
				For xT:=1 to Len(aTotLin)
					@Prow() +1 ,  0 psay aTotLin[xT][1] + "º Turno"                 // Turno
					@Prow()    , 30 psay aTotLin[xT][2][1] PICTURE("@E 99999999") 	// Total Moldes no turno
					@Prow()    , 54 psay aTotLin[xT][2][2] PICTURE("@E 99999")     // Total Toneladas no turno
					@Prow()    , 70 psay aTotLin[xT][2][4] PICTURE("@E 99,999,999") // Total Peças no turno
					
					//-- acumula os totais por linha
					aTotal[1] += aTotLin[xT][2][1]
					aTotal[2] += aTotLin[xT][2][2]
					aTotal[3] += aTotLin[xT][2][4]
					
					//-- acumula os totais geraios
					aTotGer[1] += aTotLin[xT][2][1]
					aTotGer[2] += aTotLin[xT][2][2]
					aTotGer[3] += aTotLin[xT][2][4]
					
				Next
				
				//-- Total Por Linha
				@ Prow()+1 ,   0 psay __PrtThinLine()
				
				@Prow() +1 ,  0 psay "Total "+cLinha
				@Prow()    , 30 psay aTotal[1] PICTURE("@E 99999999")    	// Total Moldes geral
				@Prow()    , 54 psay aTotal[2] PICTURE("@E 99999")  	    // Total Toneladas geral
				@Prow()    , 70 psay aTotal[3] PICTURE("@E 99,999,999") 	// Total Peças geral
				             
				aTotal  := {0,0,0,0}
				aTotLin := {}
				
				If xM > Len(aMat) .or. dDia<>aMat[xM][14] //se mudou o dia
					//-- Total Geral
					@ Prow()+1 ,   0 psay __PrtThinLine()
								
					@Prow() +2 ,  0 psay "TOTAL DO DIA "+DtoC(dDia)
					@Prow()    , 30 psay aTotGer[1] PICTURE("@E 99999999")    	// Total Moldes geral
					@Prow()    , 52 psay aTotGer[2] PICTURE("@E 9999999")    	// Total Toneladas geral
					@Prow()    , 70 psay aTotGer[3] PICTURE("@E 99,999,999") 	// Total Peças geral
					
					aTotGer := {0,0,0}
				EndIf
			EndIf
								
			If xM <= Len(aMat)            
				oRelato:cTitulo := "Programa de Produção Diária ("+DtoC(aMat[xM][14])+") "+aMat[xM][16] 
				oRelato:Cabec()
				cLinha := aMat[xM][16] 
				dDia   := aMat[xM][14]
			Else
				Loop
			EndIf
		EndIf
		
		@Prow()+1  ,   1 psay aMat[xM][19]				 			// ordem
		@Prow()    ,   5 psay StrTran(aMat[xM][1],"Z","") 			// hora inicio
		@Prow()    ,  13 psay StrTran(aMat[xM][2],"Z","") 			// hora final
		@Prow()    ,  21 psay aMat[xM][18]              			// horas de producao
		@Prow()    ,  29 psay aMat[xM][3] 							// produto / desc
		@Prow()    ,  58 psay aMat[xM][4] 						 	// numero OP
		@Prow()    ,  67 psay aMat[xM][5]  PICTURE("@E 999.99")   	// Peso
		@Prow()    ,  80 psay aMat[xM][6]  PICTURE("@E 999")     	// PC Placa
	
		@Prow()    ,  92 psay aMat[xM][7]  PICTURE("@E 999.99")  	// Peso Conj
		@Prow()    , 103 psay aMat[xM][17] PICTURE("@E 999999")    	// Moldes / Hora
		@Prow()    , 117 psay aMat[xM][8]  PICTURE("@E 999999")    	// Total Moldes
		@Prow()    , 130 psay aMat[xM][9]  PICTURE("@E 999")  	    // Toneladas
		@Prow()    , 140 psay aMat[xM][10] PICTURE("@E 999.99")  	// Metal
		@Prow()    , 153 psay aMat[xM][11] PICTURE("@E 999,999") 	// Peças
		@Prow()    , 169 psay aMat[xM][12]							// Prova Eng

		nLinha := MlCount(AllTrim(aMat[xM][13]),35)
		For xL:=1 to nLinha
			@Prow()+Iif(xL==1,0,1)  , 181 psay MemoLine(aMat[xM][13],35,xL)
    	Next
		
		//-- acumula os totais por turno
		aTotal[1] += aMat[xM][8]
		aTotal[2] += aMat[xM][9]
		aTotal[3] += aMat[xM][10]
		aTotal[4] += aMat[xM][11]
		
	Next
	
Return(nil)

/*-----------------+--------------------------------------------------------------+
!Nome              ! Gerando                                                      !
+------------------+--------------------------------------------------------------+
!Descrição         ! Faz a query trazendo as ops dentro do período                !
+------------------+--------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                          !
+------------------+-------------------------------------------------------------*/
Static Function Gerando()

	beginSql Alias cAl
		select
		    C2.C2_NUM  
//		, 	C2.C2_OPHRINI
//		,	C2.C2_OPHRFIM
		,   C2.C2_PROVA
	    ,   C2.C2_OBSAPON		
		,	C2.C2_DISA
		,	C2.C2_DATPRI
		,   C2.C2_DATPRF
		,   C2.C2_QUANT
		,   C2.C2_PRODUTO
		,	C2.C2_ORDEM
		,   substring(B1.B1_COD,1,3)+substring(B1.B1_COD,9,4)+' / '+substring(B1.B1_DESC,1,15) as CODPECA
		,   B1.B1_PESO
		,   B1.B1_PPLACA
		,   B1.B1_PECJTRO
		,   B1_MOLDHR 
		,   PTONELADAS = C2.C2_QUANT * B1_PESO / 1000
		,	MOLDES = CASE
			WHEN B1_PPLACA > 0 THEN
				C2.C2_QUANT/B1_PPLACA
			ELSE
				0
			END
		,   PMETAL = CASE
			WHEN B1_PPLACA > 0 THEN
				((C2.C2_QUANT / B1_PPLACA) * B1_PECJTRO) / 1000
			ELSE
				0
			END
		
		from
			%table:SC2% C2 (NOLOCK)
		inner join %table:SB1% B1 (NOLOCK)
			on  B1.B1_FILIAL  = %xFilial:SB1%
			and B1.B1_COD     = C2.C2_PRODUTO
			and B1.B1_TIPO    = 'PA' //somente PA
			and B1.B1_MSBLQL <> '1'
			and B1.%NotDel%
		where
			C2.C2_FILIAL  = %xFilial:SC2%
		and C2.C2_DISA   >= %Exp:mv_par01%
		and C2.C2_DISA   <= %Exp:mv_par02%
//--		and C2.C2_DATPRF >= %Exp:mv_par03% 
		and C2.C2_DATPRI BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		and C2.C2_TPOP    = 'F' //Firme
		and C2.%NotDel%
		order by
			C2.C2_DISA
		, 	C2.C2_ORDEM
//--	,   C2.C2_DATPRI
//--	,   C2.C2_OPHRINI 
	
	endSql	
	
Return

/*-----------------+--------------------------------------------------------------+
!Nome              ! Matriz                                                       !
+------------------+--------------------------------------------------------------+
!Descrição         ! Funcao para dividir a op entre os turnos transcorridos       !
!                  ! desde a data / hora inicio ate a data / hora fim             !
+------------------+--------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                          !
+------------------+-------------------------------------------------------------*/
Static Function Matriz()
Local dDi
Local dDf
Local cHi
Local cHf
Local dDia
Local cHiT1 // hora ini do turno 1
Local cHfT1 // hora fim do turno 1
Local cHiT2 // hora ini do turno 2
Local cHfT2 // hora fim do turno 2
Local cHiT3 // hora ini do turno 3
Local cHfT3 // hora fim do turno 3
Local nQuant
Local nMolde
Local cHriRef
Local cDisa := ''

	//cHrFim := U_NHPCP035(SC2->C2_PRODUTO, SC2->C2_QUANT, cHrIni, dDtIni,"H") // 
	//dDtFim := U_NHPCP035(SC2->C2_PRODUTO, SC2->C2_QUANT, cHrIni, dDtIni,"D") // D = retorno data final

	While (cAl)->(!EoF())
	         
		//-- se mudar a disa, reinicia o horario inicial
		If cDisa <> (cAl)->C2_DISA
			cHriRef := mv_par05
			cDisa := (cAl)->C2_DISA
		Endif
		          
		dDi := StoD ( (cAl)->C2_DATPRI )
		dDf := U_NHPCP035((cAl)->C2_PRODUTO, (cAl)->C2_QUANT, cHriRef, dDi,"D") // D = retorno data final // StoD ( (cAl)->C2_DATPRF )
		cHi := cHriRef //(cAl)->C2_OPHRINI
		cHf := U_NHPCP035((cAl)->C2_PRODUTO, (cAl)->C2_QUANT, cHriRef, dDi,"H") // H = retorna hora final //(cAl)->C2_OPHRFIM
		
		cHriRef := IntToHora( HoraToInt(cHf) + 0.016 ) // hora final + 1 minuto
		
		cHiT1 := "06:35" // hora ini do turno 1
		cHfT1 := "14:51" // hora fim do turno 1
		cHiT2 := "14:52" // hora ini do turno 2
		cHfT2 := "22:59" // hora fim do turno 2
		cHiT3 := "23:00" // hora ini do turno 3
		cHfT3 := "06:34" // hora fim do turno 3
		
		//-- Se a OP inicia e termina no mesmo dia 
 		If dDi==dDf

			If cHi <= cHfT3 							// inicia no terceiro turno do dia anterior
				If cHf <= cHfT3 						// encerra no terceiro turno do dia anterior
					fAddMat(dDi-1,cHi,cHf,"3")
				ElseIf cHf >= cHiT1 .and. cHf <= cHfT1 	// encerra no primeiro turno
					fAddMat(dDi-1,cHi  ,cHfT3,"3") 
					fAddMat(dDi  ,cHiT1,cHf  ,"1") 
				ElseIf cHf >= cHiT2 .and. cHf <= cHfT2 	// encerra no segundo  turno
					fAddMat(dDi-1,cHi  ,cHfT3,"3") 
					fAddMat(dDi  ,cHiT1,cHfT1,"1") 
					fAddMat(dDi  ,cHiT2,cHf  ,"2")
				ElseIf cHf >= cHiT3 .and. cHf <= "23:59"// encerra no terceiro turno do mesmo dia
					fAddMat(dDi-1,cHi  ,cHfT3,"3") 
					fAddMat(dDi  ,cHiT1,cHfT1,"1") 
					fAddMat(dDi  ,cHiT2,cHfT2,"2")
					fAddMat(dDi  ,cHiT3,cHf  ,"3")
				EndIf
			ElseIf cHi >= cHiT1 .and. cHi <= cHfT1 		// inicia no primeiro turno
				If cHf >= cHiT1 .and. cHf <= cHfT1 		// encerra no primeiro turno
					fAddMat(dDi  ,cHi,cHf,"1") 
				ElseIf cHf >= cHiT2 .and. cHf <= cHfT2 	// encerra no segundo  turno
					fAddMat(dDi  ,cHi  ,cHfT1,"1") 
					fAddMat(dDi  ,cHiT2,cHf  ,"2")
				ElseIf cHf >= cHiT3 .and. cHf <= "23:59"// encerra no terceiro turno do mesmo dia
					fAddMat(dDi  ,cHi  ,cHfT1,"1") 
					fAddMat(dDi  ,cHiT2,cHfT2,"2")
					fAddMat(dDi  ,cHiT3,cHf  ,"3")
				EndIf
			ElseIf cHi >= cHiT2 .and. cHi <= cHfT2 		// inicia no segundo turno
				If cHf >= cHiT2 .and. cHf <= cHfT2 		// encerra no segundo  turno
					fAddMat(dDi  ,cHi,cHf  ,"2")
				ElseIf cHf >= cHiT3 .and. cHf <= "23:59"// encerra no terceiro turno do mesmo dia
					fAddMat(dDi  ,cHi  ,cHfT2,"2")
					fAddMat(dDi  ,cHiT3,cHf  ,"3")
				EndIf
			ElseIf cHi >= cHiT3 .and. cHi <= "23:59" 	// inicia no terceiro
				If cHf >= cHiT3 .and. cHf <= "23:59" 	// encerra no terceiro turno do mesmo dia
					fAddMat(dDi  ,cHi  ,cHf  ,"3")
				EndIf
			EndIf

		//-- Senao se a OP não termina no mesmo dia
		ElseIf dDi < dDf
		
			dDia := dDi  //variavel auxiliar
			
			If cHi <= cHfT3 							// inicia no terceiro turno do dia anterior
				fAddMat(dDia-1,cHi  ,cHfT3,"3")
				fAddMat(dDia  ,cHiT1,cHfT1,"1") 
				fAddMat(dDia  ,cHiT2,cHfT2,"2") 
				
				If dDf==dDia+1 .and. cHf <= cHfT3
					fAddMat(dDia  ,cHiT3, IntToHora(24+HoraToInt(cHf)),"3")
				Else
					fAddMat(dDia  ,cHiT3 , "30:34" ,"3" ) 
				EndIf
				
			ElseIf cHi >= cHiT1 .and. cHi <= cHfT1 		// inicia no primeiro turno
				fAddMat(dDia  ,cHi  ,cHfT1,"1") 
				fAddMat(dDia  ,cHiT2,cHfT2,"2") 

				If dDf==dDia+1 .and. cHf <= cHfT3
					fAddMat(dDia  ,cHiT3, IntToHora(24+HoraToInt(cHf)),"3")
				Else
					fAddMat(dDia  ,cHiT3 , "30:34" ,"3" ) 
				EndIf
			ElseIf cHi >= cHiT2 .and. cHi <= cHfT2      // inicia no segundo turno		   
				fAddMat(dDia  ,cHi  ,cHfT2,"2") 
				If dDf==dDia+1 .and. cHf <= cHfT3
					fAddMat(dDia  ,cHiT3, IntToHora(24+HoraToInt(cHf)),"3")
				Else
					fAddMat(dDia  ,cHiT3 , "30:34" ,"3" ) 
				EndIf
			ElseIf cHi >= cHiT3 .and. cHi <= "23:59" 	// inicia no terceiro turno

				If dDf==dDia+1 .and. cHf <= cHfT3
					fAddMat(dDia  ,cHi, IntToHora(24+HoraToInt(cHf)),"3")
				Else
					fAddMat(dDia  ,cHi , "30:34" ,"3" ) 
				EndIf

			EndIf
			
			dDia++
			
			While dDia < dDf

				fAddMat(dDia  ,cHiT1,cHfT1,"1") 
				fAddMat(dDia  ,cHiT2,cHfT2,"2") 

				If dDf==dDia+1 .and. cHf <= cHfT3
					fAddMat(dDia  ,cHiT3, IntToHora(24+HoraToInt(cHf)),"3")
				Else
					fAddMat(dDia  ,cHiT3 , "30:34" ,"3" ) 
				EndIf
			     
				dDia++
			EndDo			
             
			If cHf >= cHiT1 .and. cHf <= cHfT1
				fAddMat(dDia, cHiT1 , cHf , "1")
			ElseIf cHf >= cHiT2 .and. cHf <= cHfT2
				fAddMat(dDia, cHiT2 , cHf , "2")
			ElseIf cHf >= cHiT3 .and. cHf <= "23:59"
				fAddMat(dDia, cHiT3 , cHf , "3")
			EndIf
		
		EndIf					
		
		(cAl)->(DbSkip())
		
	EndDo

	(cAl)->(dbCloseArea())
		
Return(nil)     


/*-----------------+--------------------------------------------------------------+
!Nome              ! fAddMat                                                      !
+------------------+--------------------------------------------------------------+
!Descrição         ! Funcao para adicionar a programação da op na matriz de       !
!                  ! impressão, de acordo com a hora inicial/final da op/turno.   !
+------------------+--------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                          !
+------------------+-------------------------------------------------------------*/
Static Function fAddMat(dDt,cHri,cHrf,cTurno)
Local nMold
Local nQtde
Local nTon

	//-- calcula quantos moldes vai produzir no turno
	nMold := fMoldTurno((cAl)->B1_MOLDHR,cHri,cHrf)
	nQtde := nMold * (cAl)->B1_PPLACA 
	nTon  := nQtde * (cAl)->B1_PESO / 1000

	//-- verifica se a hora final é maior que 24, então diminui 24
	cHrf := Iif (HoraToInt(cHrf) > 24, IntToHora(HoraToInt(cHrf)-24), cHrf)
      
	//-- faz o filtro por data
	If dDt >= mv_par03 .and. dDt <= mv_par04 

		aAdd(aMat,{Iif(cTurno=="3" .and. cHri < "06:34","Z"+cHri,cHri),;
				   cHrf,;
				   (cAl)->CODPECA,;
				   (cAl)->C2_NUM,;
				   (cAl)->B1_PESO,;
				   (cAl)->B1_PPLACA,;
				   (cAl)->B1_PECJTRO,;
				   nMold,;    
				   nTon,;
				   (cAl)->PMETAL,;
				   nQtde,;
				   Iif((cAl)->C2_PROVA=="S","SIM","NÃO"),;
				   (cAl)->C2_OBSAPON,;
				   dDt,;
				   cTurno,;
				   Iif( (cAl)->C2_DISA == "3","KW", Iif(!Empty((cAl)->C2_DISA),"DISA "+(cAl)->C2_DISA,"LINHA NÃO ESPECIFICADA") ) ,;
				   (cAl)->B1_MOLDHR,;
				   IntToHora(Iif(cHrf <= cHrI,24+HoraToInt(cHrf),HoraToInt(cHrf)) - HoraToInt(cHri)),;
				   (cAl)->C2_ORDEM})
    EndIf
		
Return

/*-----------------+--------------------------------------------------------------+
!Nome              ! fMoldTurno                                                   !
+------------------+--------------------------------------------------------------+
!Descrição         ! Funcao para calcular a quantidade de moldes que será         !
!                  ! produzida no turno de acordo com a quantidade de             !
!                  ! moldes / hora                                                !
+------------------+--------------------------------------------------------------+
!Autor             ! João Felipe da Rosa                                          !
+------------------+-------------------------------------------------------------*/
Static Function fMoldTurno(nMoldHr,cHi,cHf)
Local nQuant
Local nHoras
	
	nHoras := HoraToInt(cHf) - HoraToInt(cHi)
	nQuant := Ceiling( nMoldHr * nHoras , 0)
	
Return nQuant