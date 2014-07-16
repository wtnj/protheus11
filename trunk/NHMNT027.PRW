/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT027  ºAutor ³João Felipe da Rosa º Data ³  25/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ MTTR / MTBF / DISPONIBILIDADE                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MANUTENCAO DE ATIVOS                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "TOPCONN.CH"
#include "PROTHEUS.CH"
#include "MSGRAPHI.CH"

User Function NHMNT027()
Private _cDiasRe  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01 -> De Data ?       ³
//³mv_par02 -> Ate Data ?      ³
//³mv_par03 -> Turno ?         ³
//³mv_par04 -> De C.Custo ?    ³
//³mv_par05 -> Ate C.Custo ?   ³
//³mv_par06 -> De C.Trabalho ? ³
//³mv_par07 -> Ate C.Trabalho ?³
//³mv_par08 -> Do Bem ?        ³
//³mv_par09 -> Ate Bem ?       ³
//³mv_par10 -> De Operacao ?   ³
//³mv_par11 -> Ate Operacao ?  ³
//³mv_par12 -> De Servico ?    ³
//³mv_par13 -> Ate Servico ?   ³
//³mv_par14 -> Tipo de Parada ?³
//³mv_par15 -> Quebra por mes? ³
//³mv_par16 -> Tipo ?          ³ //1=relatorio 2=grafico
//³mv_par17 -> Informação ?    ³ //1=disponib. 2=mtbf 3=mttr
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Pergunte("MNT027",.T.)
   Return(nil)
Endif 

If mv_par16==1 //relatorio
	MNT27REL()
ElseIf mv_par16==2 //grafico
	MNT27GRF()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³ RELATORIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MNT27REL()	
//nPar      := nParam
cString   := "ST9"
cDesc1    := OemToAnsi("Imprime valores de disponibilidade de uso dos")
cDesc2    := OemToAnsi("equipamentos de manutenção.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT027" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := ""
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := ""
cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
M_PAG     := 1
wnrel     := nomeprog //"NHMNT027"
_cPerg    := "MNT027"

	cabec1 := OEMTOANSI(" PERÍODO DE "+DtoC(mv_par01)+" ATÉ "+DtoC(mv_par02))
	
	If mv_par17 == 1 //DISPONIBILIDADE
		titulo := OemToAnsi(" DISPONIBILIDADE DE MANUTENÇÃO DE EQUIPAMENTO") //título
		cabec1 += OemToAnsi("    FÓRMULA: 1 - (tempo de parada / tempo de uso)" )
	ElseIf mv_par17 == 2 //MTBF
		titulo := OemToAnsi(" TEMPO MÉDIO ENTRE FALHAS") //título
		cabec1 += OemToAnsi("    FÓRMULA: (tempo de uso - tempo de parada) / número de paradas" )
	ElseIf mv_par17 == 3 //MTTR 
		titulo := OemToAnsi(" TEMPO MÉDIO DE REPARO") //título
		cabec1 += OemToAnsi("    FÓRMULA: (tempo de parada / número de paradas)" )
	EndIf
	
	SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)
	
	if nlastKey ==27
	    Set Filter to
	    Return
	Endif
	
	SetDefault(aReturn,cString)
	
	nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CHAMADAS PARA AS FUNÇÕES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	If mv_par15 == 1 .AND. mv_par08 != mv_par09
		alert("Para quebra por mês, somente bens iguais!")
		Return .F.
	Endif
	
	Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
	Processa( {|| Calcula()   },"Imprimindo...")

	set filter to //remove o filtro da tabela

	If aReturn[5] == 1
		Set Printer To
		Commit
	    ourspool(wnrel) //Chamada do Spool de Impressao
	Endif                                          

	MS_FLUSH() //Libera fila de relatorios em spool

Return   

//ÚÄÄÄÄÄÄÄÄÄ¿
//³ GRAFICO ³
//ÀÄÄÄÄÄÄÄÄÄÙ
Static Function MNT27GRF()
	Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 
	Processa(  {|| Calcula()   },"Gerando Gráfico...") 
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO QUE GERA OS DADOS PARA IMPRESSAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery              

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MONTA A QUERY³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT T9_CCUSTO, T9_CODBEM, T9_NOME, T9_OPERAC, T9_DTCOMPR, CTT_DESC01,TJ_ORDEM,"
	cQuery += " TJ.TJ_DTPRINI, TJ.TJ_DTPRFIM,TJ.TJ_TERMINO, TJ.TJ_DTORIGI, TJ.TJ_HRDIGIT,"
	cQuery += " TJ.TJ_HOPRINI, TJ.TJ_HOPRFIM "
	cQuery += " FROM "+RetSqlName('ST9')+" T9 "

	cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON "
	cQuery += " 	CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "
	cQuery += " AND CTT_CUSTO = T9.T9_CCUSTO"
	cQuery += " AND CTT.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN " +RetSqlName("STJ")+" TJ ON "
	cQuery += " 	TJ.TJ_FILIAL = '"+xFilial("STJ")+"' "
    cQuery += " AND	T9_CODBEM = TJ_CODBEM"               
   	cQuery += " AND TJ.D_E_L_E_T_ = ' ' "
	cQuery += " AND TJ.TJ_SITUACA <> 'C'"
	cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
	   	
	if mv_par14 == 1 //Deficiente
		cQuery += " AND TJ.TJ_MAQSIT = 'D'"
	EndIf
	if mv_par14 == 2 //parada
		cQuery += " AND TJ.TJ_MAQSIT = 'P'"
	EndIf     
	
	cQuery += " AND ("
	cQuery += " 	(TJ.TJ_DTPRFIM = '' AND TJ.TJ_DTORIGI >= '"+DTOS(MV_PAR01)+"')"
	cQuery += " OR"
	cQuery += " 	(TJ.TJ_DTPRFIM >= '"+DTOS(MV_PAR01)+"')"
	cQuery += " 	)"
	cQuery += " AND ("
	cQuery += " 	(TJ.TJ_DTPRINI = '' AND TJ.TJ_DTORIGI >= '"+DTOS(MV_PAR01)+"') "
	cQuery += " OR"
	cQuery += " 	(TJ.TJ_DTPRINI <= '"+DTOS(MV_PAR02)+"')"
	cQuery += " )"

	cQuery += " WHERE SUBSTRING(T9.T9_CODBEM,8,1) = ' '"

	cQuery += " AND T9.T9_CCUSTO  BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
	cQuery += " AND T9.T9_CENTRAB BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
	cQuery += " AND T9.T9_CODBEM  BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"
	cQuery += " AND T9.T9_OPERAC  BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"

	cQuery += " AND T9.T9_SITMAN <> 'I' AND T9.T9_SITBEM <> 'I'"
	cQuery += " AND T9.D_E_L_E_T_ = ' ' AND T9.T9_FILIAL = '"+xFilial("ST9")+"'"
	
	If mv_par15 == 1
		cQuery += " ORDER BY TJ_DTORIGI, T9_CCUSTO, T9_CODBEM"     	
	Else
		cQuery += " ORDER BY T9_CCUSTO, T9_CODBEM"     	
	EndIf
	
	//MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1" 
	
	TcSetField("TRA1","T9_DTCOMPR","D")  // Muda a data de string para date   
	TcSetField("TRA1","TJ_DTPRINI","D")  // Muda a data de string para date   
	TcSetField("TRA1","TJ_DTPRFIM","D")  // Muda a data de string para date   
	TcSetField("TRA1","TJ_DTORIGI","D")  // Muda a data de string para date   
	                                                                           
	TRA1->(DbGotop())     
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA IMPRESSAO DO RELATÓRIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Calcula()
_aMat   := {}
_nSoma  := 0
_cBem   := ""
_nHPr   := 0 //horas paradas
_nHTt   := 0 //horas totais dentro do periodo solicitado
_aTurno := {0,0,0}
_nDiasPr := 0
_nQtdPr := 0
_nHoFim := 0
_nHoIni := 0
_dDiFim := 0
_dDiIni := 0
_nPerc  := 0
_aDescart := {}
_nMes := MONTH(TRA1->TJ_DTORIGI)

If mv_par16==1 .and. MV_PAR15 == 1//QUEBRA POR MES?
	_cCondic := "MONTH(TRA1->TJ_DTORIGI) == "+STRZERO(_nMes,2)
Else
	_cCondic := ".T."
EndIf

ProcRegua(TRA1->(RecCount()))

While TRA1->(!Eof())
    
	IncProc("OS: "+TRA1->(TJ_ORDEM))
	
	//adiciona o bem com os dados na matriz
	aAdd(_aMat,{TRA1->T9_CCUSTO,;
	            TRA1->CTT_DESC01,;
	            TRA1->T9_CODBEM,;
	            TRA1->T9_NOME,;
	            Iif(Empty(TRA1->T9_OPERAC),"?",TRA1->T9_OPERAC),;
	            _nHTt,;
	            _nHPr,;
	            _aTurno[1],;
	            _aTurno[2],;
	            _aTurno[3],;
	            0,;
	            TRA1->TJ_DTORIGI})
	
	_cBem := TRA1->T9_CODBEM
    
	_aTurno := {0,0,0}	
	
 	While _cBem == TRA1->T9_CODBEM .AND. &(_cCondic)
	
		IF TRA1->TJ_TERMINO == 'S' .AND. TRA1->TJ_DTPRFIM < MV_PAR01
			TRA1->(DBSKIP())
			LOOP
		ENDIF
		 
		IF TRA1->TJ_TERMINO == 'S' .AND. TRA1->TJ_DTPRINI > MV_PAR02
		   TRA1->(DBSKIP())
		   LOOP
		ENDIF 
		
		IF TRA1->TJ_TERMINO == 'N' .AND. TRA1->TJ_DTORIGI > MV_PAR01
		   TRA1->(DBSKIP())
		   LOOP
		ENDIF
		 		 
		_nDiasPr := _nHoFim := _nHoIni := 0

		//CALCULA OS DIAS DE PARADA
   	 	IF TRA1->TJ_TERMINO == 'S'
		        	
        	IF TRA1->TJ_DTPRINI <= MV_PAR01
        		_dDiIni := MV_PAR01
 	    	ELSE
        		_dDiIni := TRA1->TJ_DTPRINI
        	ENDIF
	        	
        	IF TRA1->TJ_DTPRFIM >= MV_PAR02
        		_dDiFim := MV_PAR02
   	    	ELSE
       			_dDiFim := TRA1->TJ_DTPRFIM
       		ENDIF

        ELSE
			
			IF EMPTY(TRA1->TJ_DTPRINI)
				IF TRA1->TJ_DTORIGI <= MV_PAR01
					_dDiIni := MV_PAR01
				ELSE
					_dDiIni := TRA1->TJ_DTORIGI
				ENDIF        
			ELSE
	        	IF TRA1->TJ_DTPRINI <= MV_PAR01
    	    		_dDiIni := MV_PAR01
   	    		ELSE
	        		_dDiIni := TRA1->TJ_DTPRINI
    	    	ENDIF
			ENDIF

			IF !EMPTY(TRA1->TJ_DTPRFIM)
	        	
	        	IF TRA1->TJ_DTPRFIM >= MV_PAR02
    	    		_dDiFim := MV_PAR02
        		ELSE
	        		_dDiFim := TRA1->TJ_DTPRFIM
    	    	ENDIF
            ELSE
            	_dDiFim := MV_PAR02
            ENDIF

        ENDIF

		_dDiRef := _dDiIni //Dia de referencia recebe o Dia inicial
        _nTHP	:= 0  //Total de Horas Paradas
        
		//-----------------------------
		// CALCULA HORAS ÚTEIS
		//-----------------------------
        cQuery2 := " SELECT * FROM "+RetSqlName('ZAW')
        cQuery2 += " WHERE ZAW_DTINI <= '"+DTOS(_dDiFim)+"'"
        cQuery2 += " AND ZAW_DTFIM >= '"+DTOS(_dDiIni)+"'"
        cQuery2 += " AND ZAW_CC = '"+TRA1->T9_CCUSTO+"'"
        cQuery2 += " AND D_E_L_E_T_ = ''"
        cQuery2 += " AND ZAW_FILIAL = '"+XFILIAL("ZAW")+"'"
        
        TCQUERY cQuery2 NEW ALIAS "TRB"
        
		TcSetField("TRB","ZAW_DTINI","D")  // Muda a data de string para date   
		TcSetField("TRB","ZAW_DTFIM","D")  // Muda a data de string para date   
		
		_nUtilHI := 0
		_nUtilHF := 24
		_nHTt    := 0
		_dDPar   := MV_PAR01
		
		WHILE _dDPar <= MV_PAR02
		
			_nUtilHI := 0
			_nUtilHF := 24

			TRB->(DBGOTOP())    	    
    	    While TRB->(!EOF())
    	    	
    	    	If TRB->ZAW_DTINI <= _dDPar .AND. TRB->ZAW_DTFIM >= _dDPar
					
					//verifica quais dias não serão trabalhados
	    	    	For _y:= 1 to 7 //dias da semana   
	    	    	
	    	    		If Substr(TRB->ZAW_SEMANA,_y,1) == "0" //significa que o dia _y da semana não será trabalhado
	    	    			_cDiasRe += STRZERO(_y,1)+"/"
	    	    		EndIf
	
					Next    	    	

    	    	    _nUtilHI := HoraToInt(TRB->ZAW_HRINI)
    	    	    _nUtilHF := HoraToInt(TRB->ZAW_HRFIM)
    	    	    
    	    	EndIf
    	    	
    	        TRB->(DBSKIP())
    	    EndDo 
    	    
           	If StrZero(Dow(_dDPar),1)$_cDiasRe
        		_dDPar++
        		Loop
        	EndIf
		    
			//CALCULA A HORA DISPONIVEL LEVANDO EM CONSIDERACAO OS TURNOS
		    if (mv_par15 == 1 .AND. MONTH(_dDPar) == _nMes) .OR. mv_par15 == 2

				If MV_PAR03==1 //Turno 1

					If _nUtilHI <= HoraToInt("06:34") .AND. _nUtilHF > HoraToInt("06:34")
						_nUtilHI := HoraToInt("06:34")
			
						If _nUtilHF > HoraToInt("14:51")
							_nutilHF := HoraToInt("14:51")
						EndIf

					ElseIf _nUtilHI > HoraToInt("14:51") .or. _nUtilHF < HoraToInt("06:34")
						_nUtilHI := 0
						_nUtilHF := 0
					EndIf
					
				EndIf
				
				If MV_PAR03==2 //Turno 2
					If _nUtilHI <= HoraToInt("14:51") .AND.  _nUtilHF > HoraToInt("14:51")
						_nUtilHI := HoraToInt("14:51")
			
						If _nUtilHF > HoraToInt("22:59")
							_nutilHF := HoraToInt("22:59")
						EndIf
						
					ElseIf _nUtilHI > HoraToInt("22:59") .or. _nUtilHF < HoraToInt("14:51")
						_nUtilHI := 0
						_nUtilHF := 0
					EndIf
					
				EndIf
				
				If MV_PAR03==3 //Turno 3
					If _nUtilHI >= HoraToInt("00:00") .AND. _nUtilHI < HoraToInt("06:34")
						
						If _nUtilHF >= HoraToInt("06:34") .AND. _nUtilHF <= HoraToInt("22:59")
							_nUtilHF := HoraToInt("06:34")
						ElseIf _nUtilHF > HoraToInt("22:59")
							_nHTt += HoraToInt("06:34")-_nUtilHI
							_nUtilHI := HoraToInt("22:59")
						EndIf
						
					ElseIf _nUtilHI >= HoraToInt("06:34") .AND. _nUtilHF <= HoraToInt("22:59")
						
						_nUtilHI := 0
						_nUtilHF := 0
						
					ElseIf _nUtilHF > HoraToInt("22:59")
						
						_nUtilHI := HoraToInt("22:59")
						
					EndIf
					
				EndIf
				
				_nHTt += _nUtilHF - _nUtilHI
			    
			EndIf
			
			_dDPar++
		ENDDO

		IF EMPTY(TRA1->TJ_ORDEM)
			_n := aScan(_aMat,{|x| x[3] == _cBem})
			_aMat[_n][6]  := _nHTt
			TRA1->(DBSKIP())  
			TRB->(DbCloseArea())
			LOOP
		ENDIF

		//------------------------------		
		//CALCULA HORAS PARADAS		
		//------------------------------		
        WHILE _dDiRef <= _dDiFim
        
			_nHPID  := 0  //hora parada inicial do dia
    	    _nHPFD  := 24 //hora parada final do dia
			_nLimHI := 0  //limite de hora inicial
			_nLimHF := 24 //limite de hora final
			_cDiasRe := "" //dias que não serão calculados ex: "1/7" (dom e sáb)
			
			TRB->(DBGOTOP())    	    
    	    While TRB->(!EOF())
    	    	
    	    	If TRB->ZAW_DTINI <= _dDiRef .AND. TRB->ZAW_DTFIM >= _dDiRef
					
					//verifica quais dias não serão trabalhados
	    	    	For _y:= 1 to 7 //dias da semana   
	    	    	
	    	    		If Substr(TRB->ZAW_SEMANA,_y,1) == "0" //significa que o dia _y da semana não será trabalhado
	    	    			_cDiasRe += STRZERO(_y,1)+"/"
	    	    		EndIf
	
					Next    	    	

    	    	    _nLimHI := HoraToInt(TRB->ZAW_HRINI)
    	    	    _nLimHF := HoraToInt(TRB->ZAW_HRFIM)                                    
    	    	    
    	    	EndIf
    	    	
    	        TRB->(DBSKIP())
    	    EndDo
        
        	If StrZero(Dow(_dDiRef),1)$_cDiasRe
        		_dDiRef++
        		Loop
        	EndIf
        	
        	//-------------
        	//Hora Inicial 
        	//-------------
        	If _dDiRef == TRA1->TJ_DTPRINI
        		_nHPID := HoraToInt(TRA1->TJ_HOPRINI)
        	ENDIF
        	
        	/*
        	If _nHPID < _nLimHI
        		_nHPID := _nLimHI
        	EndIf
			*/
			
			//------------        	
        	//Hora Final  
        	//------------
        	If _dDiRef == TRA1->TJ_DTPRFIM
        		_nHPFD := HoraToInt(TRA1->TJ_HOPRFIM)
        	EndIf
        	
        	/*
        	IF _nHPFD > _nLimHF
        		_nHPFD := _nLimHF 
        	EndIf
            */
            
			//Verifica se for a data de hoje para somar a hora atual        	
			IF _dDiRef == Date()
        		If _nHPFD > HoraToInt(Time())
	        		_nHPFD := HoraToInt(Time())
				EndIf
			EndIf

			//CALCULA AS HORAS PARADAS LEVANDO EM CONSIDERAÇÃO OS TURNOS
			If MV_PAR03==1 //Turno 1
				
				If _nHPID <= HoraToInt("06:34") .AND. _nHPFD > HoraToInt("06:34")
					_nHPID := HoraToInt("06:34")
					
					If _nHPFD > HoraToInt("14:51")
						_nHPFD := HoraToInt("14:51")
					EndIf
					
				ElseIf _nHPID > HoraToInt("14:51") .or. _nHPFD < HoraToInt("06:34")
					_nHPID := 0
					_nHPFD := 0
				EndIf
				
			EndIf
			
			If MV_PAR03==2 //Turno 2
				If _nHPID <= HoraToInt("14:51") .AND.  _nHPFD > HoraToInt("14:51")
					_nHPID := HoraToInt("14:51")
					
					If _nHPFD > HoraToInt("22:59")
						_nHPFD := HoraToInt("22:59")
					EndIf
					
				ElseIf _nHPID > HoraToInt("22:59") .or. _nHPFD < HoraToInt("14:51")
					_nHPID := 0
					_nHPFD := 0
				EndIf
				
			EndIf
						
			If MV_PAR03==3 //Turno 3
				If _nHPID >= HoraToInt("00:00") .AND. _nHPID < HoraToInt("06:34")
					
					If _nHPFD > HoraToInt("14:51") .AND. _nHPFD <= HoraToInt("22:59")
						_nHPFD := HoraToInt("14:51")
					ElseIf _nHPFD > HoraToInt("22:59")
						_nTHP += HoraToInt("14:51")-_nHPID
						_nHPID := HoraToInt("22:59")
					EndIf
					
				ElseIf _nHPID >= HoraToInt("06:34") .AND. _nHPFD <= HoraToInt("22:59")
					
					_nHPID := 0
					_nHPFD := 0
					
				ElseIf _nHPFD > HoraToInt("22:59")
					
					_nHPID := HoraToInt("22:59")
					
				EndIf
				
			EndIf
			
	

        	_nTHP += _nHPFD - _nHPID

			_dDiRef++
		EndDo
		
		TRB->(DBCLOSEAREA())

		_nHpr += _nTHP

		_nQtdPr++ //quantidade de paradas do bem
		
		TRA1->(DbSkip())		
    EndDo
   
   	If mv_par15 == 1
   		_n := aScan(_aMat,{|x| Month(x[12]) == _nMes})
   	Else
   		_n := aScan(_aMat,{|x| x[3] == _cBem})
   	EndIf
   	
   	//adiciona os dados  calculados na matriz
	_aMat[_n][6]  := _nHTt
	_aMat[_n][7]  := _nHPr
	_aMat[_n][8]  := _aTurno[1]
	_aMat[_n][9]  := _aTurno[2]
	_aMat[_n][10] := _aTurno[3]
	_aMat[_n][11] := _nQtdPr
	                        
	//zera as variáveis
	_nQtdPr := _nHTt := _nHPr := 0
	_aTurno := {0,0,0}  
	_nMes := MONTH(TRA1->TJ_DTORIGI)

	IF MV_PAR15 == 1
		_cCondic := "MONTH(TRA1->TJ_DTORIGI) == "+STRZERO(_nMes,2)
	EndIf

EndDo                                          

If mv_par16==1 //relatorio
	RptStatus({||fImprime()},"Imprimindo...")
ElseIf mv_par16==2 //grafico
	fGrafico()
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³ FUNCAO PARA IMPRESSAO DO RELATORIO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
Static Function fImprime()	
_cCC     := ""
_nLin    := 0
_ncnt    := 0
_nQtdBem := 0
_lCC	 := .T.
_x		 := 0

	IF MV_PAR06 == MV_PAR07
		Titulo += OemToAnsi(" - ( Fábrica: ")+MV_PAR06+")"
	ELSE
		Titulo += OemToAnsi(" - ( Fábrica: ")+MV_PAR06+OemToAnsi(" até ")+MV_PAR07+")"
	ENDIF
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	                                 	
	SetRegua(len(_aMat))
	
	If mv_par15 == 1 //quebra por mes
		Asort(_aMat,,,{|x,y| x[12] < y[12]})
	Else
		Asort(_aMat,,,{|x,y| x[1]+SUBSTR(x[5],1,3)+x[3] < y[1]+SUBSTR(y[5],1,3)+y[3]})
	EndIf
	
	_x := 1

  	If mv_par03 == 1
	  	@Prow() +1    , 001 Psay "TURNO 1"
	EndIf
  	If mv_par03 == 2
	  	@Prow() +1   , 001 Psay "TURNO 2"
	EndIf
  	If mv_par03 == 3
	  	@Prow() +1   , 001 Psay "TURNO 3"
	EndIf
    
    _nQtdBem := 0
    
	While _x <= len(_aMat)
		If Prow() > 65 
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	  	Endif

  		_cCC := _aMat[_x][1]
	  	If _lCC 
		  	@Prow() +2 , 001 Psay "C.CUSTO: "+AllTrim(_aMat[_x][1])+" - "+_aMat[_x][2]  //ccusto + desc

			@Prow() +1 , 003 Psay "BEM/OP: "
		Else
			@Prow() +2 , 003 Psay "BEM/OP: "
		EndIf
	
		_lCC := .T.
		_nLin := 15
		_ncnt := 0
		While _x <= len(_aMat) .And. _cCC == _aMat[_x][1] .AND. _nLin <= 200
			
			@Prow() , _nLin Psay AllTrim(_aMat[_x][3])+"-OP"+ALLTRIM(_aMat[_x][5])
			_nLin += 18
			_x++
			_ncnt++
			
			If _nLin > 200 .AND. _x <= len(_aMat) .AND. _cCC == _aMat[_x][1]
				_lCC := .F.
			EndIf
			
			If mv_par15 == 1 //quebra por mes
				_lCC  := .T.
				_nLin := 201
			EndIf

		EndDo		
		
		IF mv_par17 == 1
			@Prow() +1, 003 Psay "DISP.%: "
		ElseIf mv_par17 == 2
			@Prow() +1, 003 Psay "MTBF.: "
		ElseIf mv_par17 == 3
			@Prow() +1, 003 Psay "MTTR.: "		
		EndIf
	
		_nQtdBem := _ncnt
		_x       -= _ncnt
		_nSoma   := 0
		_nLin    := 20
		
		While _x <= len(_aMat) .And. _cCC == _aMat[_x][1] .AND. _nLin <= 200
			
/*
			If mv_par03 == 1 //turno 1
				If mv_par17 == 1 //DISPONIBILIDADE
					_nPerc := (1-((_aMat[_x][8]) / (_aMat[_x][6]/3)))*100
				ElseIf mv_par17 == 2 // MTBF
					_nPerc := ((_aMat[_x][6]/3) - (_aMat[_x][8])) / _aMat[_x][11] 
				ElseIf mv_par17 == 3 // MTTR
					_nPerc :=  _aMat[_x][8] / _aMat[_x][11] 
				EndIf
			EndIf
			If mv_par03 == 2 //turno 2 
				If mv_par17 == 1 //DISPONIBILIDADE
					_nPerc := (1-((_aMat[_x][9]) / (_aMat[_x][6]/3)))*100 
				ElseIf mv_par17 == 2 // MTBF
					_nPerc := ((_aMat[_x][6]/3) - (_aMat[_x][9])) / _aMat[_x][11] 
				ElseIf mv_par17 == 3 // MTTR
					_nPerc :=  _aMat[_x][9] / _aMat[_x][11] 
				EndIf
			EndIf
			If mv_par03 == 3 //turno 3  
				If mv_par17 == 1 //DISPONIBILIDADE
					_nPerc := (1-((_aMat[_x][10]) / (_aMat[_x][6]/3)))*100
				ElseIf mv_par17 == 2 // MTBF
					_nPerc := ((_aMat[_x][6]/3) - (_aMat[_x][10])) / _aMat[_x][11] 
				ElseIf mv_par17 == 3 // MTTR
					_nPerc :=  _aMat[_x][10] / _aMat[_x][11] 
				EndIf
			EndIf
			If mv_par03 == 4 //TODOS OS TURNOS
*/				If mv_par17 == 1 //DISPONIBILIDADE
					_nPerc := (1-((_aMat[_x][7]) / (_aMat[_x][6])))*100
				ElseIf mv_par17 == 2 // MTBF
					_nPerc := ((_aMat[_x][6]) - (_aMat[_x][7])) / _aMat[_x][11] 
				ElseIf mv_par17 == 3 // MTTR
					_nPerc :=  _aMat[_x][7] / _aMat[_x][11] 
				EndIf
//			EndIf
			
			_nSoma += _nPerc
			
			If mv_par17 == 1 //DISPONIBILIDADE
				If _nPerc <= 95
					@Prow()  , _nLin Psay "*"+ALLTRIM(Transform(_nPerc,"@e 999")) + "%*"			
				Else
					@Prow()  , _nLin Psay Transform(_nPerc,"@e 999") + "%"			
				EndIf
			ElseIf mv_par17 == 2 // MTBF 
				If _aMat[_x][11] == 0
					@Prow()  , _nLin-3 Psay Transform(_aMat[_x][6],"@e 9999.99")
				Else
					@Prow()  , _nLin-3 Psay Transform(_nPerc,"@e 9999.99")
				EndIf	
			ElseIf mv_par17 == 3 // MTTR
				If _aMat[_x][11] == 0
					@Prow()  , _nLin Psay "0,00"
				Else
					@Prow()  , _nLin-3 Psay Transform(_nPerc,"@e 9999.99")
				EndIf
			EndIf
			
			If mv_par15 == 1 //quebra por mes
				@Prow()  , 050 Psay MesExtenso(_aMat[_x][12])
			EndIf
							
			_nLin += 18
			_x++
			
			If mv_par15 == 1 //quebra por mes
				_lCC  := .T.
				_nLin := 201
			EndIf

		EndDo			
	
		IncRegua()
	EndDo

	@ prow()+1,000 PSAY __PrtThinLine()
	@ prow()+1,000 PSAY "MEDIA: "

	If mv_par17==1 //disponibilidade
		@ prow() ,009 PSAY Transform(_nSoma / _nQtdBem,"@e 999.99%")
	ElseIf mv_par17==2 //mtbf
		@ prow() ,009 PSAY Transform(_nSoma / _nQtdBem,"@e 9999.99")
	ElseIf mv_par17==3 //mttr
		@ prow() ,009 PSAY Transform(_nSoma / _nQtdBem,"@e 9999.99")
	EndIf
	
	TRA1->(DbCloseArea())

Return(nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ROTINA QUE GERA GRAFICO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrafico()
Private aGraf    := {} 
Private _nQtdBem := 0
Private cTit := ''

_nSoma := 0

ProcRegua(len(_aMat))

For _x:=1 to len(_aMat)
	IncProc(_aMat[_x][3])

	If mv_par17 == 1 //DISPONIBILIDADE
		cTit   := "DISPONIBILIDADE DE MANUTENÇÃO DE EQUIPAMENTO "
	ElseIf mv_par17 == 2 //MTBF
		cTit := "TEMPO MÉDIO ENTRE FALHAS"
	ElseIf mv_par17 == 3 // MTTR
		cTit := "TEMPO MÉDIO DE REPARO"
	EndIf
	
  /*
  	If mv_par03 == 1 //turno 1
		If mv_par17 == 1 //DISPONIBILIDADE
			_nPerc := (1-((_aMat[_x][8]) / (_aMat[_x][6]/3)))*100  
		ElseIf mv_par17 == 2 // MTBF
			_nPerc := ((_aMat[_x][6]/3) - (_aMat[_x][8])) / _aMat[_x][11]
		ElseIf mv_par17 == 3 // MTTR
			_nPerc :=  _aMat[_x][8] / _aMat[_x][11] 
		EndIf
	EndIf
	If mv_par03 == 2 //turno 2 
		If mv_par17 == 1 //DISPONIBILIDADE
			_nPerc := (1-((_aMat[_x][9]) / (_aMat[_x][6]/3)))*100 
		ElseIf mv_par17 == 2 // MTBF
			_nPerc := ((_aMat[_x][6]/3) - (_aMat[_x][9])) / _aMat[_x][11] 
		ElseIf mv_par17 == 3 // MTTR
			_nPerc :=  _aMat[_x][9] / _aMat[_x][11] 
		EndIf
	EndIf
	If mv_par03 == 3 //turno 3  
		If mv_par17 == 1 //DISPONIBILIDADE
			_nPerc := (1-((_aMat[_x][10]) / (_aMat[_x][6]/3)))*100
		ElseIf mv_par17 == 2 // MTBF
			_nPerc := ((_aMat[_x][6]/3) - (_aMat[_x][10])) / _aMat[_x][11] 
		ElseIf mv_par17 == 3 // MTTR
			_nPerc :=  _aMat[_x][10] / _aMat[_x][11] 
		EndIf
	EndIf
	If mv_par03 == 4 //TODOS OS TURNOS
  */
  		If mv_par17 == 1 //DISPONIBILIDADE
			_nPerc := (1-((_aMat[_x][7]) / (_aMat[_x][6])))*100
		ElseIf mv_par17 == 2 // MTBF
			_nPerc := ((_aMat[_x][6]) - (_aMat[_x][7])) / _aMat[_x][11] 
		ElseIf mv_par17 == 3 // MTTR
			_nPerc :=  _aMat[_x][7] / _aMat[_x][11] 
		EndIf
//	EndIf
	
	If mv_par17==2 //mtbf
		If _aMat[_x][11]==0
			_nPerc := _aMat[_x][6]
		EndIf
	EndIf
	
	aAdd(aGraf,{_aMat[_x][3],_nPerc})

	_nSoma += _nPerc
		
Next

MontaGrafico(aGraf,1,cTit)
	
TRA1->(DbCloseArea())

Return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Grafico   ºAutor  ³ João Felipe da Rosa º Data ³ 13/04/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Selecionar o tipo da serie de dados e o tipo de grafico    º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ aMatr  -> Array com os dados que serao processados         º±±
±±º          ³ nCbx   -> Tipo da Serie do gráfico 					      º±±
±±º          ³ cTit   -> Titulo do gráfico                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estudo                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaGrafico(aMatr,nCbx,cTit)
Local bOk       := {||oDlgGraf:End()}
Local bCanc     := {||oDlgGraf:End()}
Local bEnchoice := {||EnchoiceBar(oDlgGraf,bOk,bCanc)}
Local nX 	    := 0
Local aArea     := GetArea()
Local cCbx      := "Linha"
Local cTo 	    := ""
Local cCC 	    := ""
Local aCbx      := { "Linha","Área","Pontos","Barras","Piramid","Cilindro",;
				"Barras Horizontal","Piramid Horizontal","Cilindro Horizontal",;
				"Pizza","Forma","Linha rápida","Flexas","GANTT","Bolha"}
Private aMat      := aMatr
Private oDlgGraf
Private oGraphic
Private aSize     := MsAdvSize()
Private nSerie    := 0
Private aTabela

	aTabela		:= {{"tit 1", "tit 2",}}
	
	If mv_par17==1 //disponibilidade
		cMedia := Transform(_nSoma / len(aMat) , "@e 999.99%")
	ElseIf mv_par17==2 //mtbf
		cMedia := Transform(_nSoma / len(aMat),"@e 9999.99")
	ElseIf mv_par17==3 //mttr
		cMedia := Transform(_nSoma / len(aMat),"@e 9999.99")
	EndIf
	
	For nX := 1 To Len(aMat)
		Aadd(aTabela,{	aMat[nX,1],;
			     	    Transform(aMat[nX,2],"@e 99,999,999,999.99")})
	Next
	
	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	oDlgGraf := MsDialog():New(aSize[7],0,aSize[6],aSize[5],cTit,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	// Layout da janela
	oSay1 := TSay():New(20,5,{||cTit},oDlgGraf,,oFont1,,,,.T.,,)
	
	//group
	oGroup := tGroup():New(30,5,16,(aSize[5]/2)-5,,oDlgGraf,,,.T.)
	
	oSBox := TScrollBox():New(oDlgGraf,040,005,200, (aSize[5]/2)-10,.T.,.T.,.T.)
	
	nTam := Len(aMat) * 40
	nTam := Iif(nTam<200,200,nTam)
	
	@ 0,0 MSGRAPHIC oGraphic SIZE nTam, 200 OF oSBox PIXEL
	
	oGraphic:SetMargins(50,0,0,0)
	
	// Habilita a legenda
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
	nSerie  := oGraphic:CreateSerie(nCbx)
	
	If nSerie != GRP_CREATE_ERR
		If mv_par17 == 1 //DISPONIBILIDADE
			For _x:=1 to Len(aMat)
				oGraphic:Add(nSerie,ROUND(aMat[_x][2],2),Transform(aMat[_x][1],"@!"),Iif(aMat[_x][2] < 95,CLR_HRED,CLR_HBLUE))
			Next 
		Else
			aEval(aMat,{|e| oGraphic:Add(nSerie ,ROUND(e[2],2),Transform(e[1],"@!"),CLR_HBLUE)})
		EndIf
	Else
		IW_MSGBOX("Não foi possível criar a série.","Não foi possível criar a série.","STOP") //"Não foi possível criar a série."
	Endif
	                             
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
	oGraphic:SetTitle( "MÉDIA: "+cMedia,"", CLR_HBLUE , A_LEFTJUST , GRP_FOOT )
	
	//oGraphic:SetTitle( "", cTit, CLR_GREEN, A_RIGHTJUS , GRP_FOOT  ) //"Datas"
	
	@ 245, (aSize[5]/2)-45  BUTTON "&Salva BMP"      SIZE 40,14 OF oDlgGraf PIXEL ACTION GrafSavBmp( oGraphic ) //"&Salva BMP"
	@ 245, (aSize[5]/2)-90  BUTTON o3D PROMPT "&2D"  SIZE 40,14 OF oDlgGraf PIXEL ACTION f3d2d()
	@ 245, (aSize[5]/2)-135 BUTTON "Rotação &-"      SIZE 40,14 OF oDlgGraf WHEN oGraphic:l3D PIXEL ACTION oGraphic:ChgRotat( nSerie, 1, .T. ) // nRotation tem que estar entre 1 e 30 passos //"Rotação &-"
	@ 245, (aSize[5]/2)-180 BUTTON "Rotação &+"      SIZE 40,14 OF oDlgGraf WHEN oGraphic:l3D PIXEL ACTION oGraphic:ChgRotat( nSerie, 1, .F. ) // nRotation tem que estar entre 1 e 30 passos //"Rotação &+"
	@ 245, (aSize[5]/2)-225 BUTTON "S&howAxis"       SIZE 40,14 OF oDlgGraf PIXEL ACTION oGraphic:lAxisVisib := !oGraphic:lAxisVisib
	@ 238, (aSize[5]/2)-285 TO 262 ,(aSize[5]/2)-230 LABEL 'Zoom' OF oDlgGraf  PIXEL
	@ 245, (aSize[5]/2)-280 BUTTON "&In"             SIZE 20,14 OF oDlgGraf PIXEL ACTION oGraphic:ZoomIn()
	@ 245, (aSize[5]/2)-255 BUTTON "&Out"            SIZE 20,14 OF oDlgGraf PIXEL ACTION oGraphic:ZoomOut()
	@ 245, (aSize[5]/2)-365 MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 075, 120 OF oDlgGraf PIXEL ON CHANGE fAtuGraf(oSer:nAt)
	
	//@ 202, 050 TO 204 ,400 LABEL '' OF oDlgGraf  PIXEL
	
	If !__lPyme
		@ 264, (aSize[5]/2)-90 BUTTON "&Email" SIZE 40,14 OF oDlgGraf PIXEL ACTION PmsGrafMail(oGraphic,"Mat",{cTit},{"",""},1) // E-Mail
	Endif       
	
	@ 264, (aSize[5]/2)-45 BUTTON "&Sair" SIZE 40,14 OF oDlgGraf PIXEL ACTION oDlgGraf:End() //"&Sair"
	
	oDlgGraf:Activate(,,,.F.,{||.T.},,bEnchoice)
	
	RestArea(aArea)
	
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MUDA O GRÁFICO DE 3D PARA 2D E VICE VERSA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function f3d2d()
      
	oGraphic:l3D := !oGraphic:l3D
	o3d:cCaption := If(oGraphic:l3D, "&2D", "&3D")

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³ ATUALIZA O GRAFICO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
Static Function fAtuGraf(nCbx)
    
	oGraphic:End()
	
	nTam := Len(aMat) * 40
	nTam := Iif(nTam<200,200,nTam)
	
	@ 0,0 MSGRAPHIC oGraphic SIZE nTam, 200 OF oSBox PIXEL
	
	oGraphic:SetMargins(50,0,0,0)
	
	// Habilita a legenda
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
	nSerie  := oGraphic:CreateSerie(nCbx)
	
	If nSerie != GRP_CREATE_ERR
		If mv_par17 == 1 //DISPONIBILIDADE
			For _x:=1 to Len(aMat)
				oGraphic:Add(nSerie,ROUND(aMat[_x][2],2),Transform(aMat[_x][1],"@!"),Iif(aMat[_x][2] < 95,CLR_HRED,CLR_HBLUE))
			Next 
		Else
			aEval(aMat,{|e| oGraphic:Add(nSerie ,ROUND(e[2],2),Transform(e[1],"@!"),CLR_HBLUE)})
		EndIf
	Else
		IW_MSGBOX("Não foi possível criar a série.","Não foi possível criar a série.","STOP") //"Não foi possível criar a série."
	Endif
	                             
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
	oGraphic:SetTitle( "MÉDIA: "+cMedia,"", CLR_HBLUE , A_LEFTJUST , GRP_FOOT )
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRANSFORMA DE INTEIRO PARA HORA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ItoHora(nHora,nDigitos)
	Local nHoras    := 0 
	Local nMinutos  := 0 
	Local cHora     := ""             
	Local lNegativo := .F.
	lNegativo := ( nHora < 0 ) 
	nHora     := ABS( nHora ) 
	nHoras    := Int(nHora)
	nMinutos  := (nHora-nHoras)*60
	nDigitos := If( ValType( nDigitos )=="N", nDigitos, 2 ) - If( lNegativo, 1, 0 ) 
	cHora := If( lNegativo, "-", "" ) + StrZero( nHoras, nDigitos )+":"+StrZero( nMinutos, 2 )
Return(cHora)     
