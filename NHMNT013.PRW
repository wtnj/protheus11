#include 'fivewin.ch'
#include 'topconn.ch'
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT013  ºAutor ³João Felipe da Rosa º Data ³  22/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE HORAS POR EQUIPAMENTOS                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque Custos                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHMNT013() 

SetPrvt("_totHoras")
aCols     := {}                  
cString   := "STJ"
cDesc1    := OemToAnsi("Este relatório tem por objetivo fornecer o total de horas por maquina parada")
cDesc2    := OemToAnsi("E a quantidade de vezes que ela parou")
cDesc3    := OemToAnsi("")
tamanho   := "M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT013"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("HORAS PARADAS POR MÁQUINA")                
cabec1    := OemToAnsi(" Paradas    Bem          Descrição                                  Família    C. Trab. C.Custo                                                T.Horas")    
cabec2    := " "
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHMNT013"
_cPerg    := "MNT013" 
_totHoras := 0
_nTam	  := 0
         
// mv_par01 -> de Bem
// mv_par02 -> ate Bem
// mv_par03 -> de OS
// mv_par04 -> ate OS
// mv_par05 -> Data inicio
// mv_par06 -> Data final
// mv_par07 -> De Hora
// mv_par08 -> Ate Hora
// mv_par09 -> de Centro de Trab
// mv_par10 -> ate Centro de Trab
// mv_par11 -> de Centro de Custo
// mv_par12 -> de Centro de Custo
// mv_par13 -> de Familia do bem
// mv_par14 -> ate Familia do bem
// mv_par15 -> Faixa de horas   
// MV_PAR16 -> DE OPERACAO
// MV_PAR17 -> ATE OPERACAO  
// MV_PAR18 -> DANIFICADA / PARADA
// MV_PAR19 -> QUEBRA POR MES? SIM/NAO       

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

Pergunte(_cPerg,.F.) 

IF !EMPTY(mv_par05) .AND. !EMPTY(MV_PAR06)
	titulo += " DE "+DTOC(MV_PAR05)+OEMTOANSI(" ATÉ ")+DTOC(MV_PAR06)
ENDIF

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]  

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando()
		//-----------------------------------------------------------------------
		//  monta a query para o STJ, ST9
		//-----------------------------------------------------------------------		

		cQuery := "SELECT T9.T9_CODBEM, T9.T9_NOME, T9.T9_CODFAMI, T9.T9_CENTRAB, T9.T9_CCUSTO,"
		cQuery += " TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ.TJ_DTPRINI, TJ.TJ_DTPRFIM, TJ.TJ_HOPRINI, TJ.TJ_HOPRFIM, TJ.TJ_TERMINO, TJ.TJ_HRDIGIT"

		cQuery += " FROM "+RetSqlName("ST9")+" T9 (nolock) " 

		cQuery += " LEFT JOIN "+RetSqlName('STJ')+" TJ (NOLOCK) ON " 
		cQuery += " 	TJ.TJ_CODBEM = T9.T9_CODBEM AND" 
		cQuery += " TJ.D_E_L_E_T_ = ' ' AND TJ.TJ_FILIAL = '"+XFILIAL("STJ")+"' AND "
		if mv_par18 == 1 //DANIFICADA
			cQuery += " TJ.TJ_MAQSIT = 'D' AND "
		EndIf
		if mv_par18 == 2 //parada
			cQuery += " TJ.TJ_MAQSIT = 'P' AND "
		EndIf
		cQuery += " (TJ.TJ_DTPRFIM >= '"+DTOS(MV_PAR05)+"' OR TJ.TJ_DTORIGI >= '"+DTOS(MV_PAR05)+"') AND"
		cQuery += " (TJ.TJ_DTPRINI <= '"+DTOS(MV_PAR06)+"' OR TJ.TJ_DTORIGI >= '"+DTOS(MV_PAR05)+"') AND"
//		cQuery += " TJ.TJ_DTORIGI >= '20070101' AND"
		cQuery += " TJ.TJ_SERVICO = '000000' AND"
		cQuery += " TJ.TJ_ORDEM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND"
		cQuery += " TJ.TJ_SITUACA = 'L'"
		
		cQuery += " WHERE T9.T9_CODBEM  BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND"
		cQuery += " SUBSTRING(T9_CODBEM,8,1) <> '.' AND "
		cQuery += " T9.T9_CODBEM NOT IN (SELECT DISTINCT TC_COMPONE FROM "+RetSqlName("STC")+" WHERE D_E_L_E_T_ = ' ' AND TC_FILIAL = '"+XFILIAL("SCT")+"' ) AND "
		cQuery += " T9.T9_OPERAC  BETWEEN '"+ mv_par16 +"' AND '"+ mv_par17 +"' AND"
		cQuery += " T9.T9_CENTRAB BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' AND"
		cQuery += " T9.T9_CCUSTO  BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' AND"
		cQuery += " T9.T9_CODFAMI BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "' AND"
		cQuery += " T9.T9_SITMAN <> 'I' AND T9.T9_SITBEM <> 'I' AND"
		cQuery += " T9.D_E_L_E_T_ = ' ' AND T9.T9_FILIAL = '"+XFILIAL("ST9")+"' "
		cQuery += " ORDER BY T9.T9_CODBEM, TJ.TJ_DTORIGI "

		MemoWrit('C:\TEMP\NHMNT013.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf             
		
		TcSetField("TRA1","TJ_DTPRINI","D")
		TcSetField("TRA1","TJ_DTPRFIM","D")		
		TcSetField("TRA1","TJ_DTORIGI","D")

Return

Static Function RptDetail()  

Local _CBem // Nome do bem para verificacao de redundancia
Local _nHpr := 0 //total de horas por bem
Local _nHoini := 0
Local _nHoFim := 0
Local _nDiasPr := 0
Local nHoras := 0
Local _nQparada := 0
Local _aMatTJ := {}
Local _aMatriz := {}
Local _aDescart := {}
Local _nTQtdPar := 0
Local _cCondicao   
Local _nMes

DbSelectArea('TRA1')              
DbGotop()
_CBem := TRA1->T9_CODBEM 
_nMes := MONTH(TRA1->TJ_DTORIGI)

If MV_PAR19 == 1//QUEBRA POR MES?
	_cCondicao := "MONTH(TRA1->TJ_DTORIGI) == "+STRZERO(_nMes,2)
	cabec1 += "    Mes"
Else
	_cCondicao := ".T."
EndIf

Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)                                    

While TRA1->( ! Eof() )
	                            	
    Aadd(_aMatTJ,{TRA1->T9_CODBEM,TRA1->T9_NOME,TRA1->T9_CODFAMI,TRA1->T9_CENTRAB,TRA1->T9_CCUSTO,0,0})

	While TRA1->T9_CODBEM == _CBem .AND. &(_cCondicao)
	  
		 IF TRA1->TJ_TERMINO == 'S' .AND. TRA1->TJ_DTPRFIM < MV_PAR05
		 	TRA1->(DBSKIP())
		 	LOOP
		 ENDIF
		 
		 IF TRA1->TJ_TERMINO == 'S' .AND. TRA1->TJ_DTPRINI > MV_PAR06
		    TRA1->(DBSKIP())
		    LOOP
		 ENDIF 
		 
		 IF TRA1->TJ_TERMINO == 'N' .AND. TRA1->TJ_DTORIGI > MV_PAR05
		    TRA1->(DBSKIP())
		    LOOP
		 ENDIF 
		 
		IF !EMPTY(TRA1->TJ_ORDEM)
			//TRA1->(DBSKIP())
//			LOOP
//		ENDIF
	        
			_nDiasPr := _nHoFim := _nHoIni := 0
	
			//CALCULA OS DIAS DE PARADA
	   	 	IF TRA1->TJ_TERMINO == 'S'
			        	
	        	IF TRA1->TJ_DTPRINI <= MV_PAR05
	        		_dDiIni := MV_PAR05
	   	    	ELSE
	        		_dDiIni := TRA1->TJ_DTPRINI
	        	ENDIF
		        	
	        	IF TRA1->TJ_DTPRFIM >= MV_PAR06
	        		_dDiFim := MV_PAR06
	   	    	ELSE
	       			_dDiFim := TRA1->TJ_DTPRFIM
	       		ENDIF
	
	        ELSE
				
				IF !EMPTY(TRA1->TJ_DTPRINI)
		        	IF TRA1->TJ_DTPRINI <= MV_PAR05
	    	    		_dDiIni := MV_PAR05
	   	    		ELSE
		        		_dDiIni := TRA1->TJ_DTPRINI
	    	    	ENDIF
				ELSE
					IF TRA1->TJ_DTORIGI <= MV_PAR05
						_dDiIni := MV_PAR05
					ELSE
						_dDiIni := TRA1->TJ_DTORIGI
					ENDIF        
				ENDIF
	
				IF !EMPTY(TRA1->TJ_DTPRFIM)
		        	
		        	IF TRA1->TJ_DTPRFIM >= MV_PAR06
	    	    		_dDiFim := MV_PAR06
	        		ELSE
		        		_dDiFim := TRA1->TJ_DTPRFIM
	    	    	ENDIF
	            ELSE
	            	_dDiFim := MV_PAR06
	            ENDIF
	
	        ENDIF
	        
			_dDiRef := _dDiIni //Dia de referencia recebe o Dia inicial
	        _nTHP	:= 0  //Total de Horas Paradas
	        
	        cQuery2 := " SELECT * FROM "+RetSqlName('ZAW')
	        cQuery2 += " WHERE ZAW_DTINI <= '"+DTOS(_dDiFim)+"'"
	        cQuery2 += " AND ZAW_DTFIM >= '"+DTOS(_dDiIni)+"'"
	        cQuery2 += " AND ZAW_CC = '"+TRA1->T9_CCUSTO+"'"
	        cQuery2 += " AND D_E_L_E_T_ = ''"
	        cQuery2 += " AND ZAW_FILIAL = '"+XFILIAL("ZAW")+"'"
	        
	        TCQUERY cQuery2 NEW ALIAS "TRB"
	        
			TcSetField("TRB","ZAW_DTINI","D")  // Muda a data de string para date   
			TcSetField("TRB","ZAW_DTFIM","D")  // Muda a data de string para date   
	
	        WHILE _dDiRef <= _dDiFim
	        
				_nHPID  := 0  //hora parada inicial do dia
	    	    _nHPFD  := 24 //hora parada final do dia
				_nLimHI := 0  //limite de hora inicial
				_nLimHF := 24 //limite de hora final
				_cDiasRemover := "" //dias que não serão calculados ex: "1/7" (dom e sáb)
	
				//SE FOR INFORMADO VALOR PARA HORA NAO BUSCA NA TABELA ZAW
				IF MV_PAR07 == "  :  " .AND. MV_PAR08 == "  :  "
	
					TRB->(DBGOTOP())    	    
		    	    While TRB->(!EOF())
		    	    	
		    	    	If TRB->ZAW_DTINI <= _dDiRef .AND. TRB->ZAW_DTFIM >= _dDiRef
							
							//verifica quais dias não serão trabalhados
			    	    	For _y:= 1 to 7 //dias da semana   
			    	    	
			    	    		If Substr(TRB->ZAW_SEMANA,_y,1) == "0" //significa que o dia _y da semana não será trabalhado
			    	    			_cDiasRemover += STRZERO(_y,1)+"/"
			    	    		EndIf
			
							Next    	    	
		
		    	    	    _nLimHI := HoraToInt(TRB->ZAW_HRINI)
		    	    	    _nLimHF := HoraToInt(TRB->ZAW_HRFIM)                                    
		    	    	    
		    	    	EndIf
		    	    	
		    	        TRB->(DBSKIP())
		    	    EndDo
		        ELSE
		        	//PEGA OS VALORES DOS PARAMETROS
		        	_nLimHI := HoraToInt(MV_PAR07)
		        	_nLimHF := HoraToInt(MV_PAR08)
		        	
		        ENDIF
	        	
	        	If StrZero(Dow(_dDiRef),1)$_cDiasRemover
	        		_dDiRef++
	        		Loop
	        	EndIf
	        	
	        	//-------------
	        	//Hora Inicial 
	        	//-------------
	        	If _dDiRef == TRA1->TJ_DTPRINI
	        		_nHPID := HoraToInt(TRA1->TJ_HOPRINI)
	        	ENDIF
	        	
	        	If _nHPID < _nLimHI
	        		_nHPID := _nLimHI
	        	EndIf
				
				//------------        	
	        	//Hora Final  
	        	//------------
	        	If _dDiRef == TRA1->TJ_DTPRFIM
	        		_nHPFD := HoraToInt(TRA1->TJ_HOPRFIM)
	        	EndIf
	        	
	        	IF _nHPFD > _nLimHF
	        		_nHPFD := _nLimHF 
	        	EndIf
	
				//Verifica se for a data de hoje para somar a hora atual        	
	        	IF _dDiRef == Date()
	        		If _nHPFD > HoraToInt(Time())
		        		_nHPFD := HoraToInt(Time())
					EndIf
				EndIf
				        	
	        	_nTHP += _nHPFD - _nHPID
	
				_dDiRef++
			EndDo
			
			TRB->(DBCLOSEAREA())
			
			_nHpr += _nTHP	
	
			 _nQparada += 1
		Endif			 

		TRA1->(DbSkip())

	End  
	
	_nTam := Len(Alltrim(Str(INT(_nHpr))))
	
	_nHpr := IntToHora(_nHpr,_nTam)	
	
	If _nMes < month(mv_par05)
		_nMes := month(mv_par05)
	EndIf
	
	aAdd(_aMatriz,{_aMatTJ[1][1],_aMatTJ[1][2],_aMatTJ[1][3],_aMatTJ[1][4],_aMatTJ[1][5], _nHpr, _nQparada,_nMes})

	_CBem := TRA1->T9_CODBEM
	_nMes := MONTH(TRA1->TJ_DTORIGI)

	IF MV_PAR19 == 1
		_cCondicao := "MONTH(TRA1->TJ_DTORIGI) == "+STRZERO(_nMes,2)
	EndIf

	_aMatTJ := {}
	_nHpr := 0
    _nQparada := 0
    
end

aSort(_aMatriz,,,{|x,y| x[5]+STRZERO(x[8],2) < y[5]+STRZERO(y[8],2)})

For x:=1 to len(_aMatriz)
	If fHoratoInt(_aMatriz[x][6]) >= mv_par15

	If Prow() > 60
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, "G", nTipo)
	Endif  

		@ Prow()+1 , 004 Psay _aMatriz[x][7] //_nQparada 
		_nTQtdPar += _aMatriz[x][7]
		@ Prow()   , 012 Psay ALLTRIM(_aMatriz[x][1]) //codbem
		@ Prow()   , 026 Psay SUBSTR(_aMatriz[x][2],1,40) //nome bem
	    @ Prow()   , 069 Psay _aMatriz[x][3] //cod fami
		@ Prow()   , 080 Psay _aMatriz[x][4] //centrab
		@ Prow()   , 089 Psay _aMatriz[x][5] //ccusto
	
		DbSelectArea("CTT")
		DbSetOrder(1) // filial + cc
		If DbSeek(xFilial("CTT")+_aMatriz[x][5])
			@ Prow()   ,  100 Psay Substr(CTT->CTT_DESC01,1,40)
		EndIf
		
		@ Prow()   , 143 Psay _aMatriz[x][6] //_nHpr
        IF MV_PAR19 == 1
			@ Prow()   , 153 Psay MesExtenso(_aMatriz[x][8]) //_nMes
	    ENDIF
	    
		_totHoras += fHoraToInt(_aMatriz[x][6])
		
	EndIf
Next

@ Prow()+1,000 PSAY __PrtThinLine()
@ Prow()+1,004 Psay _nTQtdPar
@ Prow()  ,070 Psay "Total de Horas Paradas : "

/*
For i:= 1 to len(_aDescart)
	@ Prow()+1 , 001 Psay OemtoAnsi("Bem ignorado no cálculo: ")+_aDescart[i]
NEXT
*/

_nTam := Len(Alltrim(Str(Int(_totHoras))))

@ Prow()  ,143 Psay IntToHora(_totHoras,_nTam)


Return(nil)

//--------------------------------------------------//   
//* FUNCAO QUE TRANSFORMA A HORA(STRING) EM INTEIRO*//
//* AUTOR: JOAO FELIPE DA ROSA                     *//
//--------------------------------------------------//

Static Function fHoraToInt(_cHora)
Local _nHora := 0 
Local _nHr
Local _nMn
	For i:=1 to Len(_cHora)
		If substr(_cHora,i,1) == ":"          // se encontrar ":"
			_nHr := Val(substr(_cHora,1,i))   // atribui a uma variavel o que vem antes de ":" convertido em int
			_nMn := Val(substr(_cHora,i+1,2)) // atribui a outra variavel o que vem depois de ":" convertido em int
			_nHora := ((_nHr*60)+_nMn)/60     // Soma a hora e minutos  
			exit
		EndIf
	Next
Return(_nHora)

Static Function IntToHora(nHora,nDigitos)

Local nHoras    := 0 
Local nMinutos  := 0 
Local cHora     := ""             
Local lNegativo := .F.

lNegativo := ( nHora < 0 ) 

nHora     := ABS( nHora ) 

nHoras    := Int(nHora)
nMinutos  := (nHora-nHoras)*60
                                                                                                                                 
nDigitos := Iif( ValType( nDigitos )=="N", nDigitos, 2 )// - If( lNegativo, 1, 0 ) 

cHora := If( lNegativo, "-", "" ) + StrZero( nHoras, nDigitos )+":"+StrZero( nMinutos, 2 )

Return(cHora)


