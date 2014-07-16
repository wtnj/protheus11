#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHEST113   บAutor ณJoใo Felipe         บ Data ณ  19/02/08  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RELATำRIO DE FERRAMENTAS POR PEวA PRODUZIDA                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESTOQUE / CUSTOS                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NHEST113()   

cString   := "SD3"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("a rela็ใo de ferramentas usadas nas pe็as ")
cDesc3    := OemToAnsi("produzidas e seus custos.")
tamanho   := "G"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST113"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATำRIO DE FERRAMENTAS POR PEวA")
cabec1    := " C.Custo"
cabec2    := "      Produto        Descricao                       Quantidade     Custo Unit.      Custo Total          Emissใo"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHEST113"
_cPerg    := "EST113" 
 
// mv_par01 DE PEวA
// mv_par02 ATษ PEวA
// mv_par03 DE FERRAMENTA
// mv_par04 ATษ FERRAMENTA
// mv_par05 DE PERอODO
// mv_par06 ATษ PERอODO
// mv_par07 FORMA (ANALอTICO / SINTษTICO)
// mv_par08 SOMENTE PA (SIM / NAO)

Pergunte(_cPerg,.F.)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

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

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 
Processa( {|| RptDetail()   },"Imprimindo...") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool

Return

Static Function Gerando()
Local cQuery

If mv_par07 <> 3
	If mv_par07 == 1 // analํtico
		cQuery := " SELECT D3.D3_COD, B1.B1_DESC, SUM(D3.D3_QUANT) AS D3_QUANT, "
		cQuery += " SUM(D3.D3_CUSTO1) AS D3_CUSTO1,D3.D3_EMISSAO, D3.D3_CC, CTT.CTT_DESC01"
	ELSEIf mv_par07 == 2 //sint้tico
		cQuery := " SELECT SUM(D3.D3_QUANT) AS D3_QUANT, SUM(D3.D3_CUSTO1) AS D3_CUSTO1,"
		cQuery += "	SUBSTRING(D3.D3_EMISSAO,1,6) AS D3_EMISSAO , D3.D3_CC, CTT.CTT_DESC01, SUM(ZAG_QTDE) AS ZAG_QTDE"
	ENDIF
	
	cQuery += " FROM "+RETSQLNAME("SD3")+" D3 (NOLOCK) "
	
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" B1 (NOLOCK) ON "
	cQuery += " 	B1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND	D3.D3_COD = B1.B1_COD"
	cQuery += " AND B1.B1_TIPO = 'FE'" 
	cQuery += " AND B1.D_E_L_E_T_ = ' '"
	
	cQuery += " INNER JOIN "+RETSQLNAME("CTT")+" CTT (NOLOCK) ON "
	cQuery += " 	CTT.CTT_FILIAL='"+xFilial("CTT")+"'"
	cQuery += " AND CTT.CTT_CUSTO = D3.D3_CC"     
	cQuery += " AND CTT.D_E_L_E_T_ = '' "
	
	If mv_par07 == 2 //sint้tico
		cQuery += " LEFT JOIN "+RETSQLNAME("ZAG")+" ZAG (NOLOCK) ON "
		cQuery += "		ZAG.ZAG_FILIAL = '"+xFilial("ZAG")+"'"
		cQuery += " AND	ZAG.ZAG_PROD = D3.D3_COD"
		cQuery += " AND ZAG.ZAG_DATA  BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
		cQuery += " AND ZAG.D_E_L_E_T_ = '' "
	ENDIF
		
	cQuery += " WHERE D3.D3_CC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND D3.D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND D3.D3_EMISSAO BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
	cQuery += " AND D3.D_E_L_E_T_ = ' ' AND D3.D3_FILIAL = '"+xFilial("SD3")+"'"	

	If mv_par07 == 1 // analํtico
		cQuery += " GROUP BY D3.D3_COD, B1.B1_DESC, D3.D3_EMISSAO, D3.D3_CC, CTT.CTT_DESC01"
		cQuery += " ORDER BY D3.D3_CC"
	ELSEIf mv_par07 == 2 //sint้tico
		cQuery += " GROUP BY D3.D3_CC, CTT.CTT_DESC01, SUBSTRING(D3.D3_EMISSAO,1,6)"
		cQuery += " ORDER BY D3.D3_CC, SUBSTRING(D3.D3_EMISSAO,1,6)"
	EndIf
EndIf			

If mv_par07 == 3 // percentual
		cQuery := " SELECT ZAG.ZAG_PROD, "
		cQuery += " 	(SELECT SUM(ZA.ZAG_QTDE) "
		cQuery += " 	FROM ZAGNH0 ZA WHERE ZAG.ZAG_PROD = ZA.ZAG_PROD AND ZA.ZAG_DATA BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"')"
		cQuery += " 	AS ZAG_QTDE, D3.D3_CC, CTT.CTT_DESC01, SUM(D3.D3_QUANT) AS D3_QUANT, SUM(D3.D3_CUSTO1) AS D3_CUSTO1,"
		cQuery += " SUBSTRING(D3.D3_EMISSAO,1,6) AS D3_EMISSAO"
		cQuery += " FROM "+RETSQLNAME("SD3")+" D3, "+RETSQLNAME("SB1")+" B1, "+RETSQLNAME("CTT")+" CTT, "+RETSQLNAME("ZAG")+" ZAG"
		cQuery += " WHERE D3.D3_CC = CTT.CTT_CUSTO"
		cQuery += " AND D3.D3_CC = B1.B1_CC"
		cQuery += " AND B1.B1_COD = ZAG.ZAG_PROD"
		cQuery += " AND SUBSTRING(D3.D3_COD,1,2) = 'FE'"
		cQuery += " AND D3.D3_CC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
		cQuery += " AND D3.D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
		cQuery += " AND D3.D3_EMISSAO BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
		cQuery += " AND ZAG.ZAG_DATA  BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
		cQuery += " AND D3.D_E_L_E_T_ = ' '"
		cQuery += " AND B1.D_E_L_E_T_ = ' '"
		cQuery += " AND ZAG.D_E_L_E_T_ = ' '"
		cQuery += " AND CTT.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY ZAG.ZAG_PROD,D3.D3_CC, CTT.CTT_DESC01, SUBSTRING(D3.D3_EMISSAO,1,6)"
		cQuery += " ORDER BY D3.D3_CC, SUBSTRING(D3.D3_EMISSAO,1,6)"
EndIf
	
	TCQUERY cQuery NEW ALIAS "TRA1"

Return

Static Function RptDetail()

Local _cCC := ""
Local _nTotal := 0
Local _nTQtde := 0
Local _aFer	 := {} //matriz de custo de ferramentas
Local _aQtd	 := {} //matriz de quantidade
Local _aCst	 := {} //matriz de custo
Local _aMat  := {} //matriz principal
Local _aPrc  := {} //matriz de percentual
Local _cCCDesc := ""
Local _nSoma := 0
Local _aTotal := {}
Local _cCusto := 0
Local _cQuant := 0  
Local _n 	  := 0

If mv_par07 == 2 //sint้tico
	cabec1  := OemToAnsi(" Pe็a               Descri็ใo                          Janeiro      Fevereiro    Marco        Abril        Maio         Junho        Julho        Agosto       Setembro     Outubro      Novembro     Dezembro        Total")
	cabec2  := ""
EndIf

titulo += " De "+DtoC(mv_par05)+" at้ "+DtoC(mv_par06)

TRA1->(DbGoTop())	

If mv_par07 == 1 //analํtico
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

	While TRA1->(!Eof()) 
		If Prow() > 70
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		Endif
	    
		If _cCC <> TRA1->D3_CC
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
			@ Prow()+2 ,001 Psay TRA1->D3_CC+" - "+TRA1->CTT_DESC01
		EndIf

		_cCC := TRA1->D3_CC
		@ Prow()+1, 005 Psay TRA1->D3_COD
		@ Prow()  , 021 Psay TRA1->B1_DESC
		@ Prow()  , 055 Psay TRA1->D3_QUANT Picture("@e 9999")
		_nTQtde += TRA1->D3_QUANT
		@ Prow()  , 066 Psay TRA1->D3_CUSTO1 / TRA1->D3_QUANT Picture("@e 999,999.99")
		@ Prow()  , 084 Psay TRA1->D3_CUSTO1 Picture("@e 999,999.99")
		_nTotal += TRA1->D3_CUSTO1
		@ Prow()  , 105 Psay StoD(TRA1->D3_EMISSAO)
		
		TRA1->(DbSkip())
		If _cCC <> TRA1->D3_CC
			@ Prow()+1  , 001 Psay "Total:--->"
			@ Prow()  , 055 Psay _nTQtde Picture("@e 9999")
			@ Prow()  , 084 Psay _nTotal Picture("@e 999,999.99")
			_nTQtde := 0
			_nTotal := 0
		EndIf

	EndDo
EndIf
	
If mv_par07 == 2 //sint้tico
	
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	
	While TRA1->(!Eof())

		If _cCC <> TRA1->D3_CC
		   
		    _cCC := TRA1->D3_CC
		    _cCCDesc := TRA1->CTT_DESC01
	
			_aFer := {"       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",;
	    	  	  	  "       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",0}
			_aQnt := {"       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",;
		    		  "       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",0}
			_aCst := {"       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",;
	    			  "       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",0}
			_aPrc := {"       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",;
	    			  "       -    ","       -    ","       -    ","       -    ","       -    ","       -    ",0}

	    EndIf
		_aFer[Val(Substr(TRA1->D3_EMISSAO,5,2))] := TRA1->D3_CUSTO1
		_aFer[13] += TRA1->D3_CUSTO1
	    	
		_aQnt[Val(Substr(TRA1->D3_EMISSAO,5,2))] := TRA1->ZAG_QTDE
		If !Empty(TRA1->ZAG_QTDE)
			_aQnt[13] += TRA1->ZAG_QTDE
		EndIf

		_aCst[Val(Substr(TRA1->D3_EMISSAO,5,2))] := TRA1->D3_CUSTO1 / TRA1->ZAG_QTDE
		_aCst[13] += TRA1->D3_CUSTO1 / TRA1->ZAG_QTDE
			
		TRA1->(DbSkip())	

		If _cCC <> TRA1->D3_CC
			aAdd(_aMat,{_cCC, _cCCDesc, _aFer,_aQnt,_aCst})
		EndIf

	EndDo

// --- IMPRIME --- //

	For x:=1 to Len(_aMat)

		If Prow() > 70
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		Endif
		
		@ Prow() +2, 001 Psay ALLTRIM(_aMat[x][1])+" - "+_aMat[x][2]
		
		//IMPRIME A QUANTIDADE PRODUZIDA
		_nCol := 51
		For y:= 1 to 13
			If ValType(_aMat[x][4][y]) <> "C"
				@ Prow (), _nCol Psay _aMat[x][4][y] Picture "999999999999"
			Else 
				@ Prow (), _nCol Psay _aMat[x][4][y]
			EndIf
			_nCol += 13
		Next

		_nCol := 51
		@ Prow () +1, 001 Psay "CUSTO FERRAMENTAL -------->"
		For y:= 1 to 13
			If ValType(_aMat[x][3][y]) <> "C"
				@ Prow (), _nCol Psay _aMat[x][3][y] Picture "9,999,999.99"
			Else 
				@ Prow (), _nCol Psay _aMat[x][3][y]
			EndIf
			_nCol += 13
		Next

 		_nCol := 51
		@ Prow () +1, 001 Psay "CUSTO MEDIO POR PECA ----->"
		For y:= 1 to 13
			If ValType(_aMat[x][5][y]) <> "C"
				@ Prow (), _nCol Psay _aMat[x][5][y] Picture "9,999,999.99"
			Else 
				@ Prow (), _nCol Psay _aMat[x][5][y]
			EndIf
			_nCol += 13
		Next
	Next
EndIf

TRA1->(DbGoTop())     

If mv_par07 == 3 //PERCENTUAL

cabec1    := " C.Custo"
cabec2    := "          Pe็a            Descricao                        Qtde Produzida   %CC     Custo FE/QTDE    Valor Venda      Custo FE/Pว          %"

	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
	
	While TRA1->(!Eof())
		_cCC := TRA1->D3_CC
		While _cCC == TRA1->D3_CC
			_nSoma += TRA1->ZAG_QTDE
    		TRA1->(DbSkip())
 		EndDo
    	aAdd(_aTotal,{_cCC,_nSoma})
    	_nSoma := 0
    EndDo

	TRA1->(DbGoTop())
	
	@ Prow()+1 ,001 Psay AllTrim(TRA1->D3_CC)+" - "+TRA1->CTT_DESC01
	_cCC := TRA1->D3_CC
	_cCusto := TRA1->D3_CUSTO1
	_cQuant := TRA1->D3_QUANT
	_n := aScan(_aTotal,{|x| x[1]==TRA1->D3_CC})

	While TRA1->(!Eof()) 
		If Prow() > 70
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
		Endif
	    
		If _cCC <> TRA1->D3_CC
//			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
			@ Prow()+2 ,001 Psay AllTrim(TRA1->D3_CC)+" - "+TRA1->CTT_DESC01
			_cCC := TRA1->D3_CC
			_cCusto := TRA1->D3_CUSTO1
			_cQuant := TRA1->D3_QUANT
			_n := aScan(_aTotal,{|x| x[1]==TRA1->D3_CC})
			
		EndIf
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+TRA1->ZAG_PROD))
		
		@ Prow()+1 ,010 Psay ALLTRIM(TRA1->ZAG_PROD)+" - "+SB1->B1_DESC
		@ Prow()   ,065 Psay TRA1->ZAG_QTDE

		_nPPeca := (TRA1->ZAG_QTDE*100)/_aTotal[_n][2]

		@ Prow()   ,075 Psay Transform(_nPPeca,"@e 999") +"%" //PERCENTUAL DA PEวA DENTRO DO CC
		@ Prow()   ,085 Psay ( _cCusto * _nPPeca) Picture("@e 999999999.99") //CUSTO DAs PEวAs DENTRO DO CC
        @ Prow()   ,100 Psay SB1->B1_PRV1 Picture("@e 99,999.99") //valor de venda
		@ Prow()   ,115 Psay ((_cCusto * _nPPeca)) / TRA1->ZAG_QTDE Picture("@e 999999999.99") //CUSTO FERRAMENTAL POR PEวA
		@ Prow()   ,130 Psay Transform(((((_cCusto * _nPPeca)) / TRA1->ZAG_QTDE)*100)/SB1->B1_PRV1,"@e 999999999.99") +"%" //%
		TRA1->(DbSkip())
	EndDo
EndIf

@ Prow()+2,000 PSAY __PrtThinLine()

TRA1->(DbCloseArea())          

Return(nil)