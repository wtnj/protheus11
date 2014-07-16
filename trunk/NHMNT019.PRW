#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHMNT019  ºAutor ³João Felipe da Rosa º Data ³  03/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO HISTORICO DE CONSUMO							  º±±
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

User Function NHMNT019()   

SetPrvt("_aGrupo,_cCodUsr,aCols")
aCols     := {}                  
cString   := "STG"
cDesc1    := OemToAnsi("Este relatório tem por objetivo fornecer o histórico de consumo")
cDesc2    := OemToAnsi("dos produtos de manutenção.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT019"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATORIO DE HISTORICO DE CONSUMOS")                        
cabec1    := OemToAnsi(" Data        O.S.    Bem             Descrição              Insumo         Descrição               Qtde.   Unidade   Etapa    Familia   C.Custo     Custo Unit.  Custo Total")    
cabec2    := " "
cabec3    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHMNT019"
_cPerg    := "MNT019"
_nTQTD    := 0
_nTCST    := 0
_nTotCust := 0
//_nTCUNI	  := 0
_nTCustUn := 0

// mv_par01 = de data 
// mv_par02 = até data
// mv_par03 = de ordem
// mv_par04 = ate ordem
// mv_par05 = do bem
// mv_par06 = ate bem
// mv_par07 = do insumo
// mv_par08 = ate insumo
// mv_par09 = etapa
// mv_par10 = da Fabrica
// mv_par11 = ate Fabrica
// mv_par12 = analitico/sintetico/resumido
// mv_par13 = de centro de custo
// mv_par14 = ate centro de custo

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

Pergunte(_cPerg,.F.) 

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

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
	//  monta a query para  
	//-----------------------------------------------------------------------		

	cQuery := " SELECT TJ.TJ_DTORIGI, TJ.TJ_ORDEM, T9.T9_CODBEM, T9.T9_NOME, TL.TL_CODIGO, B1.B1_DESC," 
	cQuery += " TL.TL_QUANTID, TL.TL_UNIDADE, T9.T9_CODFAMI,T9.T9_CENTRAB, TJ.TJ_CCUSTO,TL.TL_CUSTO, CTT.CTT_DESC01"

	//o relatório 03 - resumido não pega a Etapa
	If mv_par12 <> 3
		cQuery += ", TQ.TQ_ETAPA"
	EndIf

	cQuery += " FROM "+RetSqlName('STJ')+" TJ, "+RetSqlName('ST9')+" T9, "+RetSqlName('STL')+" TL, "
	cQuery += RetSqlName('SB1')+" B1, "+RetSqlName("CTT")+" CTT"
	If mv_par12 <> 3 
		cQuery += ", "+RetSqlName('STQ')+" TQ "
	EndIf
	cQuery += " WHERE T9.T9_CODBEM = TJ.TJ_CODBEM "
	cQuery += " AND TJ.TJ_ORDEM = TL.TL_ORDEM"
    cQuery += " AND CTT.CTT_CUSTO = TJ.TJ_CCUSTO"	
	If mv_par12 <> 3
		cQuery += " AND TJ.TJ_ORDEM = TQ.TQ_ORDEM"
		cQuery += " AND TL.TL_TAREFA = TQ.TQ_TAREFA"
	EndIf

	cQuery += " AND B1.B1_COD = TL.TL_CODIGO"
	cQuery += " AND T9.T9_CENTRAB BETWEEN '"+mv_par10+"' AND '"+mv_par11+"'"
    cQuery += " AND TL.TL_DTINICI >= '"+DtoS(mv_par01)+"'"
    cQuery += " AND TL.TL_DTFIM <= '"+DtoS(mv_par02)+"'"
//	cQuery += " AND TJ.TJ_DTORIGI BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	cQuery += " AND TJ.TJ_ORDEM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "	
	cQuery += " AND T9.T9_CODBEM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "	
	cQuery += " AND TL.TL_CODIGO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "	
	cQuery += " AND T9.T9_CCUSTO BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' "
    IF !Empty(mv_par09) .And. mv_par12 <> 3
		cQuery += " AND TQ.TQ_ETAPA = '"+mv_par09+"'"
	EndIf
	If mv_par12 <> 3		
		cQuery += " AND TQ.D_E_L_E_T_ = ' 'AND TQ.TQ_FILIAL = '"+xFilial('STQ')+"'"
	EndIf
	cQuery += " AND CTT.D_E_L_E_T_ = ' ' AND CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"	
	cQuery += " AND TJ.D_E_L_E_T_ = ' ' AND TJ.TJ_FILIAL = '"+xFilial('STJ')+"'"
	cQuery += " AND T9.D_E_L_E_T_ = ' ' AND T9.T9_FILIAL = '"+xFilial('ST9')+"'"
	cQuery += " AND TL.D_E_L_E_T_ = ' ' AND TL.TL_FILIAL = '"+xFilial('STL')+"'"
	cQuery += " AND B1.D_E_L_E_T_ = ' ' AND B1.B1_FILIAL = '"+xFilial('SB1')+"'"
//	cQuery += " GROUP BY TJ.TJ_DTORIGI, TJ.TJ_ORDEM, T9.T9_CODBEM, T9.T9_NOME, TL.TL_CODIGO, B1.B1_DESC,"
//	cQuery += " TL.TL_QUANTID, TL.TL_UNIDADE, T9.T9_CODFAMI, TJ.TJ_CCUSTO, T9.T9_CENTRAB,TL.TL_CUSTO"
//	If mv_par12 <> 3
//		cQuery += " ,TQ.TQ_ETAPA"
//	EndIf
	If mv_par12 == 1
		cQuery += " ORDER BY TJ.TJ_DTORIGI"
	ElseIf mv_par12 == 2
		tamanho   := "M"
		cQuery += " ORDER BY T9.T9_CODBEM, TL.TL_CODIGO, TJ.TJ_ORDEM"
        cabec1 := OemToAnsi(" Bem              Descrição                   Insumo            Descrição                 Qtde.   Unidade      Custo Unit.  Custo Total ")
	ElseIf mv_par12 == 3 
		tamanho   := "M"
		cQuery += " ORDER BY T9.T9_CENTRAB, TL.TL_CODIGO"
        cabec1 := OemToAnsi(" Fábrica          Insumo         Descrição                            Qtde.  Unidade    Custo Unit.  Custo Total ")
	EndIf

	MemoWrit('C:\TEMP\NHMNT019.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS 'TRA1'

	If	! USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf
    TcSetField("TRA1","TJ_DTORIGI","D")  // Muda a data de string para date    
Return

Static Function RptDetail()  
Local _aVerif := {"","","","","","",0}
Local _nTotQtd := 0

Local _cUni
Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    

DbSelectArea('TRA1')


While TRA1->( ! Eof() )
	If Prow() > 60		
		Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)
	Endif
//RELATORIO 01 - Analítico
	If mv_par12 == 1
		If TRA1->TJ_ORDEM <> _aVerif[2]
			@ Prow()+2, 001 Psay TRA1->TJ_DTORIGI 
			@ Prow()  , 013 Psay TRA1->TJ_ORDEM
			@ Prow()  , 021 Psay TRA1->T9_CODBEM
			@ Prow()  , 037 Psay Substr(TRA1->T9_NOME,1,20) 
			@ Prow()  , 060 Psay TRA1->TL_CODIGO 
			@ Prow()  , 075 Psay Substr(TRA1->B1_DESC,1,20) 
			@ Prow()  , 097 Psay TRA1->TL_QUANTID Picture "999.99"
			@ Prow()  , 109 Psay TRA1->TL_UNIDADE
			@ Prow()  , 117 Psay TRA1->TQ_ETAPA
			@ Prow()  , 126 Psay TRA1->T9_CODFAMI 
			@ Prow()  , 136 Psay TRA1->TJ_CCUSTO 
			@ Prow()  , 146 Psay TRA1->TL_CUSTO/TRA1->TL_QUANTID Picture "999,999.99"
			@ Prow()  , 160 Psay TRA1->TL_CUSTO Picture "999,999.99"
//			_nTotQtd  += TRA1->TL_QUANTID
//			_nTotCust += TRA1->TL_CUSTO
		Else
			@ Prow()+1, 060 Psay TRA1->TL_CODIGO 
			@ Prow()  , 075 Psay Substr(TRA1->B1_DESC,1,20) 
			@ Prow()  , 097 Psay TRA1->TL_QUANTID Picture "999.99" 
			@ Prow()  , 109 Psay TRA1->TL_UNIDADE
			@ Prow()  , 117 Psay TRA1->TQ_ETAPA
			@ Prow()  , 126 Psay TRA1->T9_CODFAMI 
			@ Prow()  , 136 Psay TRA1->TJ_CCUSTO 
			@ Prow()  , 146 Psay TRA1->TL_CUSTO/TRA1->TL_QUANTID Picture "999,999.99"
			@ Prow()  , 160 Psay TRA1->TL_CUSTO Picture "999,999.99"
//			_nTotQtd += TRA1->TL_QUANTID
//			_nTotCust += TRA1->TL_CUSTO
		EndIf
		_aVerif := {TRA1->T9_CODBEM,TRA1->TJ_ORDEM,TRA1->TJ_CCUSTO, TRA1->TL_CODIGO,TRA1->TL_UNIDADE,TRA1->T9_CENTRAB,TRA1->TL_QUANTID}
//		_nTCUNI += TRA1->TL_CUSTO/TRA1->TL_QUANTID
		_nTQTD += TRA1->TL_QUANTID
		_nTCST += TRA1->TL_CUSTO

   		TRA1->(DbSkip())

//RELATORIO 02 - Sintético
	ElseIf mv_par12 == 2
		If TRA1->T9_CODBEM <> _aVerif[1]
			@ Prow()+2, 001 Psay TRA1->T9_CODBEM
			@ Prow()  , 018 Psay Substr(TRA1->T9_NOME,1,20)
			@ Prow()  , 046 Psay TRA1->TL_CODIGO
		Else 
			@ Prow()+1, 046 Psay TRA1->TL_CODIGO
		EndIf
		@ Prow()  , 064 Psay Substr(TRA1->B1_DESC,1,20)

        _aVerif[1] := TRA1->T9_CODBEM
        _aVerif[4] := TRA1->TL_CODIGO
        _aVerif[5] := TRA1->TL_UNIDADE

        //Soma as quantidades de oleo usadas por cada bem
		While TRA1->T9_CODBEM == _aVerif[1] .And. TRA1->TL_CODIGO == _aVerif[4] .And. TRA1->TL_UNIDADE == _aVerif[5]
			If TRA1->TJ_ORDEM <> _aVerif[2] 
				_nTotQtd += TRA1->TL_QUANTID
				_nTotCust += TRA1->TL_CUSTO
			EndIf
			_cUni := TRA1->TL_UNIDADE
			_aVerif := {TRA1->T9_CODBEM,TRA1->TJ_ORDEM,TRA1->TJ_CCUSTO, TRA1->TL_CODIGO,TRA1->TL_UNIDADE,TRA1->T9_CENTRAB,TRA1->TL_QUANTID}
			TRA1->(DbSkip())
		EndDo
		@ Prow()  , 089 Psay _nTotQtd Picture "999.99"               //quantidade
		@ Prow()  , 100 Psay _cUni									 //unidade	
		@ Prow()  , 110 PSay _nTotCust/_nTotQtd Picture "999,999.99" //custo unitario
		@ Prow()  , 124 PSay _nTotCust Picture "999,999.99"			 //custo total
		_nTQTD += _nTotQtd
		_nTCST += _nTotCust
//		_nTCUNI += _nTotCust/_nTotQtd
		_nTotCust := 0
		_nTotQtd := 0

//RELATORIO 03 - Resumido
	ElseIf mv_par12 == 03

		If TRA1->T9_CENTRAB <> _aVerif[6]
			@ Prow()+2, 001 Psay TRA1->T9_CENTRAB
			@ Prow()  , 018 Psay TRA1->TL_CODIGO
		Else 
			@ Prow()+1, 018 Psay TRA1->TL_CODIGO
		EndIf
		@ Prow()  , 033 Psay Substr(TRA1->B1_DESC,1,30)
	    _aVerif[6] := TRA1->T9_CENTRAB
	    _aVerif[5] := TRA1->TL_UNIDADE
   	    _aVerif[4] := TRA1->TL_CODIGO

	    //Soma as quantidades de oleo usadas por cada fabrica
		While TRA1->T9_CENTRAB == _aVerif[6] .And. TRA1->TL_CODIGO == _aVerif[4] .And.;
		 	  TRA1->TL_UNIDADE == _aVerif[5] 
			_nTotQtd += TRA1->TL_QUANTID
			_nTotCust += TRA1->TL_CUSTO
			_cUni := TRA1->TL_UNIDADE
			_aVerif := {TRA1->T9_CODBEM,TRA1->TJ_ORDEM,TRA1->TJ_CCUSTO, TRA1->TL_CODIGO,TRA1->TL_UNIDADE,TRA1->T9_CENTRAB,TRA1->TL_QUANTID}
			TRA1->(DbSkip())
		EndDo
		@ Prow()  , 068 Psay _nTotQtd Picture "9999.99"					//quantidade
		@ Prow()  , 079 Psay _cUni  									//unidade
		@ Prow()  , 086 PSay _nTotCust/_nTotQtd Picture "999,999.99"	//custo unitario
		@ Prow()  , 100 PSay _nTotCust Picture "999,999.99"				//custo total
		_nTQTD += _nTotQtd
		_nTCST += _nTotCust
//		_nTCUNI += _nTotCust/_nTotQtd
		_nTotCust := 0
		_nTotQtd := 0
	EndIf
End
@ Prow()+1,000 PSAY __PrtThinLine()
//------------------------------------imprime totais---------------------------------------------//     
If mv_par12 == 01 //analitico
	@ Prow()+1, 001 PSAY "Total: --->"
	@ Prow()  , 097 PSAY _nTQTD  Picture "9999999.99"
//	@ Prow()  , 142 PSAY _nTCUNI Picture "999,999,999.99"
	@ Prow()  , 156 PSAY _nTCST  Picture "999,999,999.99"
EndIf
If mv_par12 == 02 //sintetico
	@ Prow()+1, 001 PSAY "Total: --->"
	@ Prow()  , 086 PSAY _nTQTD  Picture "9999999.99"
	@ Prow()  , 106 PSAY _nTCST  Picture "999,999,999.99"
//	@ Prow()  , 120 PSAY _nTCUNI Picture "999,999,999.99"	
EndIF
If mv_par12 == 03 //resumido
	@ Prow()+1, 001 PSAY "Total: --->"
	@ Prow()  , 065 PSAY _nTQTD  Picture "9999999.99"
//	@ Prow()  , 082 PSAY _nTCUNI Picture "999,999,999.99"
	@ Prow()  , 096 PSAY _nTCST  Picture "999,999,999.99"
EndIF
Return(nil)
  