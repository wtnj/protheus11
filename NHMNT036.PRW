#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHMNT036  บAutor ณJoใo Felipe da Rosa บ Data ณ  24/10/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATำRIO DE ATENDIMENTO POR TURNOS                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NHMNT036()   

Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT036" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATำRIO DE ATENDIMENTO POR TURNOS") //tํtulo
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := ""
cabec2    := " O.S.     Bem           Descri็ใo do Bem                           C.Custo   Descri็ใo do C.Custo                       Dt. Inicial Hr. Inicial  Dt. Final   Hr. Final   Turno I.  Turno F."
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 
M_PAG     := 1 //Variavel que acumula numero da pagina 
wnrel     := nomeprog //"NH"
_cPerg    := "MNT036" 
_aOs      := {{},{},{}}
_aOsA     := {{},{},{}}
_aOsF     := {{},{},{}}
_aErro 	  := {}//OS que nใo contabilizram.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณMV_PAR01 = De Bem ?       ณ
//ณMV_PAR02 = Ate Bem ?      ณ
//ณMV_PAR03 = De Data ?      ณ
//ณMV_PAR04 = Ate Data       ณ
//ณMV_PAR05 = De Hora ?      ณ
//ณMV_PAR06 = Ate Hora ?     ณ
//ณMV_PAR07 = De  C.Custo ?  ณ
//ณMV_PAR08 = Ate C.Custo ?  ณ
//ณMV_PAR09 = De C.Trabalho ?ณ
//ณMV_PAR10 = De C.Trabalho ?ณ
//ณMV_PAR11 = De Servico ?   ณ
//ณMV_PAR12 = De Servico ?   ณ
//ณMV_PAR13 = Situacao da mแqณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif  

cabec1    := " Perํodo Consultado: 06:34 do dia "+DtoC(MV_PAR03)+" at้ 06:34 do dia "+DtoC(MV_PAR04+1)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCHAMADAS PARA AS FUNวีESณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit 
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFUNCAO QUE GERA OS DADOS PARA IMPRESSAOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function Gerando()
Local cQuery

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMONTA A QUERYณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := "SELECT TJ.TJ_ORDEM, TJ.TJ_CODBEM, T9.T9_NOME, TJ.TJ_CCUSTO, CTT.CTT_DESC01,"
cQuery += " TJ.TJ_DTORIGI, TJ.TJ_DTPRINI, TJ.TJ_DTPRFIM, TJ.TJ_HRDIGIT, TJ.TJ_HOPRFIM, TJ.TJ_TERMINO"
cQuery += " FROM "+RetSqlName("STJ")+" TJ, "+RetSqlName("ST9")+" T9, "+RetSqlName("CTT")+" CTT"
cQuery += " WHERE T9.T9_CODBEM = TJ.TJ_CODBEM"
cQuery += " AND TJ.TJ_SITUACA = 'L'"
cQuery += " AND CTT.CTT_CUSTO = TJ.TJ_CCUSTO" 
cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"

cQuery += " AND ((TJ.TJ_TERMINO='S' AND TJ.TJ_DTPRFIM BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"') OR "
cQuery += " (TJ.TJ_DTORIGI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"') OR "  
cQuery += " (TJ.TJ_DTORIGI = '"+DTOS(MV_PAR04+1)+"' AND TJ.TJ_HOPRINI < '06:34'))"


//cQuery += " AND ((TJ.TJ_DTORIGI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"') OR"  
//cQuery += " (TJ.TJ_DTORIGI = '"+DTOS(MV_PAR04+1)+"' AND TJ.TJ_HOPRINI < '06:34'))"
  


//cQuery += " AND ((TJ.TJ_DTPRFIM = '' AND TJ_TERMINO = 'N') OR (TJ.TJ_DTPRFIM >= '"+DTOS(MV_PAR03)+"'))

cQuery += " AND TJ.TJ_CCUSTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"            
cQuery += " AND TJ.TJ_CENTRAB BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
cQuery += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"

If mv_par13 == 1 //parada
	cQuery += " AND TJ.TJ_MAQSIT = 'P' "
ElseIf mv_par13 == 2 //deficiente
	cQuery += " AND TJ.TJ_MAQSIT = 'D' "
EndIf

cQuery += " AND TJ.D_E_L_E_T_  = '' AND TJ.TJ_FILIAL   = '"+xFilial("STJ")+"'"
cQuery += " AND T9.D_E_L_E_T_  = '' AND T9.T9_FILIAL   = '"+xFilial("ST9")+"'"
cQuery += " AND CTT.D_E_L_E_T_ = '' AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"

//MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TRA1->(DbGotop())     

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFUNCAO PARA IMPRESSAO DO RELATำRIOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function Imprime()

Local _aTPas := {0,0,0} // Total de O.S. Passadas para o pr๓ximo turno 1, 2 e 3
Local _cTurnoIni
Local _cTurnoFim
Local _ncnt := 0
Local _aMatr := {}
Private _aTIni := {0,0,0} // Total de O.S. Aberta  no turno 1, 2 e 3
Private _aTFim := {0,0,0} // Total de O.S. Fechada no turno 1, 2 e 3

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

//TRAZ NฺMERO DE LINHAS
While TRA1->(!Eof())  
    _ncnt++
	TRA1->(DbSkip())
EndDo      

TRA1->(DbGoTop())

SetRegua(_ncnt)

//Percorre os registros
While TRA1->(!Eof())  

	If Prow() > 60 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif
  	
  	IF TRA1->TJ_HRDIGIT >= "00:00" .AND. TRA1->TJ_HRDIGIT < "06:34" .AND. TRA1->TJ_DTORIGI == DTOS(MV_PAR03)
  		TRA1->(DBSKIP())
  		LOOP
  	ENDIF

	IncRegua()
	
	@PROW()+1, 001 PSAY TRA1->TJ_ORDEM                   //ORDEM DE SERVICO
	@PROW()  , 010 PSAY ALLTRIM(TRA1->TJ_CODBEM)         //CำDIGO DO BEM
	@PROW()  , 024 PSAY SUBSTR(TRA1->T9_NOME,1,40)       //DESCRICAO DO BEM
	@PROW()  , 067 PSAY TRA1->TJ_CCUSTO                  //C.CUSTO
	@PROW()  , 077 PSAY SUBSTR(TRA1->CTT_DESC01,1,40)	//DESCRIวรO DO C.CUSTO
	@PROW()  , 120 PSAY STOD(TRA1->TJ_DTORIGI)           //DATA DE ABERTURA DA OS
	@PROW()  , 134 PSAY TRA1->TJ_HRDIGIT                 //HORA DE ABERTURA DA OS
	@PROW()  , 145 PSAY STOD(TRA1->TJ_DTPRFIM)			//DATA DE PARADA FINAL
	@PROW()  , 159 PSAY TRA1->TJ_HOPRFIM					//HORA DE PARADA FINAL
	
	_CTURNOINI := ""
	_CTURNOFIM := ""
	
	IF !EMPTY(TRA1->TJ_HRDIGIT)
		
		IF TRA1->TJ_HRDIGIT >= "06:34" .AND. TRA1->TJ_HRDIGIT < "14:51"     //PRIMEIRO TURNO
			_ATINI[1]++
			aAdd(_aOsA[1],TRA1->TJ_ORDEM)		   	
			_CTURNOINI := "001"
		ELSEIF TRA1->TJ_HRDIGIT >= "14:51" .AND. TRA1->TJ_HRDIGIT < "22:59" //SEGUNDO TURNO
			_ATINI[2]++
			aAdd(_aOsA[2],TRA1->TJ_ORDEM)
			_CTURNOINI := "002"
		ELSEIF TRA1->TJ_HRDIGIT >= "22:59" .AND. TRA1->TJ_HRDIGIT < "24:00" .OR.; //TERCEIRO TURNO
		       (TRA1->TJ_HRDIGIT >= "00:00" .AND. TRA1->TJ_HRDIGIT < "06:34" .AND. TRA1->TJ_DTORIGI > DTOS(MV_PAR03))
			_ATINI[3]++
			aAdd(_aOsA[3],TRA1->TJ_ORDEM)
			_CTURNOINI := "003"
		ENDIF
	ENDIF
	
	IF !EMPTY(TRA1->TJ_HOPRFIM) .AND. TRA1->TJ_TERMINO == 'S'
		
		IF TRA1->TJ_HOPRFIM >= "06:34" .AND. TRA1->TJ_HOPRFIM < "14:51"     //PRIMEIRO TURNO
			_CTURNOFIM := "001"
		ELSEIF TRA1->TJ_HOPRFIM >= "14:51" .AND. TRA1->TJ_HOPRFIM < "22:59" //SEGUNDO TURNO
			_CTURNOFIM := "002"
		ELSEIF TRA1->TJ_HOPRFIM >= "22:59" .AND. TRA1->TJ_HOPRFIM < "24:00" .OR.; //TERCEIRO TURNO
		       TRA1->TJ_HOPRFIM >= "00:00" .AND. TRA1->TJ_HOPRFIM < "06:34"
			_CTURNOFIM := "003"
		ENDIF
	ENDIF
	
	//IMPRIME
	@PROW()  , 171 PSAY _CTURNOINI //TURNO EM QUE A O.S. INICIOU
	@PROW()  , 181 PSAY _CTURNOFIM //TURNO EM QUE A O.S. FINDOU
	
 	TRA1->(DBSKIP())
 	
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FECHADAS 1o TURNO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// 	_cQuery2 += " SELECT TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ.TJ_DTPRFIM, TJ.TJ_HRDIGIT, TJ.TJ_HOPRFIM "
 	_cQuery2 := "SELECT TJ.TJ_ORDEM AS OSFIM "
 	_cQuery2 += " FROM "+RetSqlName("STJ")+" TJ"
 	_cQuery2 += " WHERE TJ_DTPRFIM BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
 	_cQuery2 += " AND TJ.TJ_TERMINO = 'S'"
 	_cQuery2 += " AND TJ.TJ_SITUACA = 'L'"

	If mv_par13 == 1 //parada
		_cQuery2 += " AND TJ.TJ_MAQSIT = 'P' "
	ElseIf mv_par13 == 2 //deficiente
		_cQuery2 += " AND TJ.TJ_MAQSIT = 'D' "
	EndIf

 	_cQuery2 += " AND TJ.TJ_HOPRFIM BETWEEN '06:34' AND '14:50'"
	_cQuery2 += " AND TJ.TJ_CODBEM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	_cQuery2 += " AND TJ.TJ_CCUSTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	_cQuery2 += " AND TJ.TJ_CENTRAB BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	_cQuery2 += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'" 
 	_cQuery2 += " AND TJ.D_E_L_E_T_ = ''"

	TCQUERY _cQuery2 NEW ALIAS "TRC" 
    
	TRC->(DBGOTOP())
	WHILE TRC->(!EOF())
	
		aAdd(_aOsF[1],TRC->OSFIM)
		_aTFim[1]++
		TRC->(DBSKIP())
	ENDDO

	TRC->(DBCLOSEAREA())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FECHADAS 2o TURNO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// 	_cQuery2 += " SELECT TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ.TJ_DTPRFIM, TJ.TJ_HRDIGIT, TJ.TJ_HOPRFIM "
 	_cQuery2 := "SELECT TJ.TJ_ORDEM AS OSFIM "
 	_cQuery2 += " FROM "+RetSqlName("STJ")+" TJ"
 	_cQuery2 += " WHERE TJ_DTPRFIM BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
 	_cQuery2 += " AND TJ.TJ_TERMINO = 'S'"
 	_cQuery2 += " AND TJ.TJ_SITUACA = 'L'" 

	If mv_par13 == 1 //parada
		_cQuery2 += " AND TJ.TJ_MAQSIT = 'P' "
	ElseIf mv_par13 == 2 //deficiente
		_cQuery2 += " AND TJ.TJ_MAQSIT = 'D' "
	EndIf
	 	
 	_cQuery2 += " AND TJ.TJ_HOPRFIM BETWEEN '14:51' AND '22:58'"
	_cQuery2 += " AND TJ.TJ_CODBEM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	_cQuery2 += " AND TJ.TJ_CCUSTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	_cQuery2 += " AND TJ.TJ_CENTRAB BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	_cQuery2 += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'" 
 	_cQuery2 += " AND TJ.D_E_L_E_T_ = ''"

	TCQUERY _cQuery2 NEW ALIAS "TRC" 

	TRC->(DBGOTOP())
	WHILE TRC->(!EOF())
	
		aAdd(_aOsF[2],TRC->OSFIM)
		_aTFim[2]++
		TRC->(DBSKIP())
	ENDDO

	TRC->(DBCLOSEAREA()) 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FECHADAS 3o TURNO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// 	_cQuery2 += " SELECT TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ.TJ_DTPRFIM, TJ.TJ_HRDIGIT, TJ.TJ_HOPRFIM "
 	_cQuery2 := "SELECT TJ.TJ_ORDEM AS OSFIM "
 	_cQuery2 += " FROM "+RetSqlName("STJ")+" TJ"
 	_cQuery2 += " WHERE TJ.TJ_TERMINO = 'S'"
 	_cQuery2 += " AND TJ.TJ_SITUACA = 'L'"

	If mv_par13 == 1 //parada
		_cQuery2 += " AND TJ.TJ_MAQSIT = 'P' "
	ElseIf mv_par13 == 2 //deficiente
		_cQuery2 += " AND TJ.TJ_MAQSIT = 'D' "
	EndIf
 	
 	_cQuery2 += " AND ((TJ.TJ_HOPRFIM BETWEEN '22:59' AND '24:00' 
 	_cQuery2 += " AND TJ.TJ_DTPRFIM BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"') OR"
	_cQuery2 += " (TJ.TJ_HOPRFIM BETWEEN '00:00' AND '06:33'"
	_cQuery2 += " AND TJ.TJ_DTPRFIM BETWEEN '"+DTOS(MV_PAR03+1)+"' AND '"+DTOS(MV_PAR04+1)+"'))"
	_cQuery2 += " AND TJ.TJ_CODBEM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	_cQuery2 += " AND TJ.TJ_CCUSTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	_cQuery2 += " AND TJ.TJ_CENTRAB BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	_cQuery2 += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'" 
 	_cQuery2 += " AND TJ.D_E_L_E_T_ = ''"

	TCQUERY _cQuery2 NEW ALIAS "TRC" 

	TRC->(DBGOTOP())
	WHILE TRC->(!EOF())
	
		aAdd(_aOsF[3],TRC->OSFIM)
		_aTFim[3]++
		TRC->(DBSKIP())
	ENDDO

	TRC->(DBCLOSEAREA()) 
	
	
For _x := 0 to (MV_PAR04 - MV_PAR03)		

    _aMat := fOSPass(MV_PAR03+_x)

	_aTPas[1] += _aMat[1]
	_aTPas[2] += _aMat[2]
	_aTPas[3] += _aMat[3]

Next

If Prow() > 60 
	_nPag  := _nPag + 1   
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
Endif
  	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ IMPRIME OS TOTAIS ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@Prow()+1, 000 psay __PrtThinLine()        
@Prow()+1, 001 psay "Total:                               T1      T2      T3"
@Prow()+1, 001 psay "O.S. Abertas:                     "+Transform(_aTIni[1],"9,999")+Space(3)+;
													 	 Transform(_aTIni[2],"9,999")+Space(3)+;
													     Transform(_aTIni[3],"9,999")
@Prow()+1, 001 psay "O.S. Fechadas:                    "+Transform(_aTFim[1],"9,999")+Space(3)+;
														 Transform(_aTFim[2],"9,999")+Space(3)+;
														 Transform(_aTFim[3],"9,999")
@Prow()+1, 001 psay "O.S. Recebidas do turno anterior: "+Transform(_aTPas[1],"9,999")+Space(3)+;
													     Transform(_aTPas[2],"9,999")+Space(3)+;
														 Transform(_aTPas[3],"9,999") 

TRA1->(DbCloseArea())

/********************************************************************************************************* 

    ESTA PARTA ABAIXO SERVER PARA FAZER O TESTE DE MESA PARA CONFERIR SE OS RESULTADOS SรO CORRETOS
    
/*********************************************************************************************************    
    
/*
@Prow()+1, 001 psay "ABERTAS"
@Prow()+1, 001 psay ""
FOR _x:= 1 to Len(_aOsA[1])
	@Prow(), (_x * 8) psay _aOsA[1][_x]
Next
@Prow()+1, 001 psay ""

FOR _x:= 1 to Len(_aOsA[2])
	@Prow(), (_x * 8) psay _aOsA[2][_x]
Next
@Prow()+1, 001 psay ""

FOR _x:= 1 to Len(_aOsA[3])
	@Prow(), (_x * 8) psay _aOsA[3][_x]
Next


@Prow()+1, 001 psay "FECHADAS"
@Prow()+1, 001 psay ""
FOR _x:= 1 to Len(_aOsF[1])
	@Prow(), (_x * 8) psay _aOsF[1][_x]
Next
@Prow()+1, 001 psay ""

FOR _x:= 1 to Len(_aOsF[2])
	@Prow(), (_x * 8) psay _aOsF[2][_x]
Next
@Prow()+1, 001 psay ""

FOR _x:= 1 to Len(_aOsF[3])
	@Prow(), (_x * 8) psay _aOsF[3][_x]
Next

												 
@Prow()+1, 001 psay "PASSADAS"
@Prow()+1, 001 psay ""
FOR _x:= 1 to Len(_aOs[1])
	@Prow(), (_x * 8) psay _aOs[1][_x]
Next
@Prow()+1, 001 psay ""

FOR _x:= 1 to Len(_aOs[2])
	@Prow(), (_x * 8) psay _aOs[2][_x]
Next
@Prow()+1, 001 psay ""

FOR _x:= 1 to Len(_aOs[3])
	@Prow(), (_x * 8) psay _aOs[3][_x]
Next

*/


Return(nil)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CONTABILIZA O.S. RECEBIDA DO TURNO ANTERIOR ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function fOSPass(dData) 

Local _aMat := {0,0,0}
Local cQry

	cQry := " SELECT TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ.TJ_HRDIGIT, TJ.TJ_DTPRFIM, TJ.TJ_HOPRFIM, "
	cQry += " TJ.TJ_TERMINO, TJ.TJ_DTPRINI, TJ.TJ_HOPRINI"
	cQry += " FROM "+RetSqlName("STJ")+" TJ"
	cQry += " WHERE TJ.TJ_DTORIGI <= '"+DtoS(dData)+"'"
	cQry += " AND TJ.TJ_SITUACA = 'L'" 
	
	If mv_par13 == 1 //parada
		cQry += " AND TJ.TJ_MAQSIT = 'P' "
	ElseIf mv_par13 == 2 //deficiente
		cQry += " AND TJ.TJ_MAQSIT = 'D' "
	EndIf
	
	cQry += " AND ((TJ.TJ_DTPRFIM >= '"+DtoS(dData)+"' AND TJ.TJ_TERMINO = 'S') OR"
	cQry += " (TJ.TJ_DTPRFIM = '' AND TJ.TJ_TERMINO = 'N'))"
	cQry += " AND TJ.TJ_CODBEM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQry += " AND TJ.TJ_CCUSTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	cQry += " AND TJ.TJ_CENTRAB BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	cQry += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'" 
 	cQry += " AND TJ.D_E_L_E_T_ = ''" 
 	cQry += " ORDER BY TJ.TJ_TERMINO, TJ.TJ_ORDEM, TJ.TJ_DTORIGI, TJ.TJ_HOPRFIM"

	TCQUERY cQry NEW ALIAS "TRB"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ VERIFICA SE A O.S. FOI PASSADA PARA O TURNO SEGUINTE ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	WHILE TRB->(!EOF())

		//Ignora OS fechada com data final em branco
		If Empty(TRB->TJ_DTPRFIM) .AND. TRB->TJ_TERMINO = 'S'
			TRB->(DBSKIP())
			LOOP	
		EndIf
		
		//OS aberta contabiliza como passagem para os 3 turnos
		If TRB->TJ_TERMINO = 'N'
	
			IF (TRB->TJ_HRDIGIT < "06:34" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				_aMat[1]++
				aAdd(_aOs[1],TRB->TJ_ORDEM)
			ENDIF
			
		    IF (TRB->TJ_HRDIGIT < "14:51" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				_aMat[2]++
				aAdd(_aOs[2],TRB->TJ_ORDEM)
			ENDIF
			
			IF (TRB->TJ_HRDIGIT < "22:59" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				_aMat[3]++
				aAdd(_aOs[3],TRB->TJ_ORDEM)
			ENDIF
	
			TRB->(DBSKIP())
			LOOP
		EndIf
		
	    //Os aberta 
		If !Empty(TRB->TJ_DTPRFIM) .AND. !EMPTY(TRB->TJ_HOPRFIM) .AND. TRB->TJ_TERMINO == 'S'
		
		    If TRB->TJ_HOPRFIM >= "06:34" .AND. TRB->TJ_HOPRFIM < "14:51"     // PRIMEIRO TURNO
		   		
		   		IF (TRB->TJ_HRDIGIT < "06:34" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
		   			_aMat[1]++
		   			aAdd(_aOs[1],TRB->TJ_ORDEM)
		   		ENDIF
			   	
		    ElseIf TRB->TJ_HOPRFIM >= "14:51" .AND. TRB->TJ_HOPRFIM < "22:59" //SEGUNDO TURNO
	
		   		IF (TRB->TJ_HRDIGIT < "06:34" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
			   		_aMat[1]++
			   		aAdd(_aOs[1],TRB->TJ_ORDEM)
			   	ENDIF
				   	
			   	IF (TRB->TJ_HRDIGIT < "14:51" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
					_aMat[2]++
					aAdd(_aOs[2],TRB->TJ_ORDEM)		   	
			   	ENDIF

		    ElseIf TRB->TJ_HOPRFIM >= "22:59" .AND. TRB->TJ_HOPRFIM < "24:00"//TERCEIRO TURNO 22:59 ATE 24:00
		   		
		   		IF (TRB->TJ_HRDIGIT < "06:34" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
			   		_aMat[1]++
			   		aAdd(_aOs[1],TRB->TJ_ORDEM)
			   	ENDIF
				   	
			   	IF (TRB->TJ_HRDIGIT < "14:51" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
					_aMat[2]++
					aAdd(_aOs[2],TRB->TJ_ORDEM)		   	
			   	ENDIF
				   	
			   	IF (TRB->TJ_HRDIGIT < "22:59" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
			   		_aMat[3]++		 
			   		aAdd(_aOs[3],TRB->TJ_ORDEM)  	
			   	ENDIF
				   	
		    EndIf
			    
			IF TRB->TJ_DTPRFIM > DTOS(dData)
			
				IF TRB->TJ_HOPRFIM >= "00:00" .AND. TRB->TJ_HOPRFIM < "06:34" //pr๓ximo dia 3o turno 00:00 as 06:34 
					
			   		IF (TRB->TJ_HRDIGIT < "06:34" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				   		_aMat[1]++
				   		aAdd(_aOs[1],TRB->TJ_ORDEM)
				   	ENDIF
					   	
				   	IF (TRB->TJ_HRDIGIT < "14:51" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
						_aMat[2]++
						aAdd(_aOs[2],TRB->TJ_ORDEM)		   	
				   	ENDIF
					
				   	IF (TRB->TJ_HRDIGIT < "22:59" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				   		_aMat[3]++
				   		aAdd(_aOs[3],TRB->TJ_ORDEM)		   	
				   	ENDIF		
					
			    ELSEIf TRB->TJ_HOPRFIM >= "06:34" .AND. TRB->TJ_HOPRFIM < "14:51"     // PRIMEIRO TURNO
			   		
				   	IF (TRB->TJ_HRDIGIT < "14:51" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
						_aMat[2]++
						aAdd(_aOs[2],TRB->TJ_ORDEM)		   	
				   	ENDIF
			   	
				   	IF (TRB->TJ_HRDIGIT < "22:59" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				   		_aMat[3]++		 
				   		aAdd(_aOs[3],TRB->TJ_ORDEM)  	
				   	ENDIF

			    ElseIf TRB->TJ_HOPRFIM >= "14:51" .AND. TRB->TJ_HOPRFIM < "22:59" //SEGUNDO TURNO
	
				   	IF (TRB->TJ_HRDIGIT < "22:59" .AND. TRB->TJ_DTORIGI == DtoS(dData)) .OR. TRB->TJ_DTORIGI < DtoS(dData)
				   		_aMat[3]++		 
				   		aAdd(_aOs[3],TRB->TJ_ORDEM)  	
				   	ENDIF
			
			    ENDIF
			
		    ENDIF
	

			TRB->(DBSKIP())
			LOOP
		
			aAdd(_aErro, TRB->TJ_ORDEM) //este array guarda as o.s. que nใo contabilizaram. 
			TRB->(DbSkip())
		ENDIF
	
	EndDo 
	
	TRB->(DBCLOSEAREA())

Return _aMat
