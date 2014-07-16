/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NHCOM007        ³ Sergio L Tambosi      ³ Data ³ 10.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da Previsao de Desembolso por Fornecedor        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Chamada padr„o para programas em RDMake.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhcom007() 

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z,nTamSX1")

_aGrupo   := pswret()
_cCodUsr  := _agrupo[1,1]
cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Previsao de Desembolso por Fornecedor")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM007"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "PREVISAO DE DESEMBOLSO P/FORNECEDOR"
Cabec1    := " DT.EMIS.   PEDIDO  FORNECEDOR                                  VLR.TOTAL  DT.ENTR.    COND.PAGTO     1.o VCTO    2o. VCTO    3o. VCTO    4o. VCTO                  TOT.SEMANA                        Sigla  N.Fiscal"
Cabec2    := "It Produto   Descricao                                                                                        Qtde Um         Vlr.Unit             Vlr.Ipi           Vlr.Total  Vlr.Total(c/Ipi)"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
nTamSX1   := Len(SX1->X1_GRUPO)   
wnrel     := "NHCOM007"         //Nome Default do relatorio em Disco
_cPerg    := PADR("COM007",nTamSX1) //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)

aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

//Mv_par01 :=	Usuario
//Mv_par02 :=	Centro de Custo de   
//Mv_par03 :=	Centro de Custo Ate  
//Mv_par04 :=	Grupo de 
//Mv_par05 :=	Grupo Ate 
//Mv_par06 :=	Data de 
//Mv_par07 :=	Data Ate 
//Mv_par08 :=	Sigla de 
//Mv_par09 :=	Sigla Ate

//AjustaSx1()

If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer
TMP->(DbGoTop())

If Empty(TMP->C7_NUM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

fMatriz()

//inicio da impressao
If mv_par10 == 1
	Cabec1    := " DT.EMIS.   PEDIDO  FORNECEDOR                                  VLR.TOTAL  DT.ENTR.    COND.PAGTO     1.o VCTO    2o. VCTO    3o. VCTO    4o. VCTO                  TOT.SEMANA                         Sigla  N.Fiscal"
	Cabec2    := "It Produto   Descricao                                                                                        Qtde Um         Vlr.Unit             Vlr.Ipi           Vlr.Total  Vlr.Total(c/Ipi)"
	Processa( {|| RptDet1() },"Imprimindo...")
Else
	Cabec1    := " DT.EMIS.   PEDIDO  FORNECEDOR                                  VLR.TOTAL  DT.ENTR.    COND.PAGTO     1.o VCTO    2o. VCTO    3o. VCTO    4o. VCTO          VLR DO IPI   VLR.TOT.(C/IPI)      TOT.SEMANA    Sigla  N.Fiscal"
	Cabec2    := " "
	Processa( {|| RptDet2() },"Imprimindo...")
Endif	
DbSelectArea("TMP")
DbCloseArea()


Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

	cQuery := "SELECT C7.C7_EMISSAO, C7.C7_NUM,C7.C7_FORNECE, A2.A2_NOME, C7.C7_TOTAL, C7.C7_DATPRF, C7.C7_COND, "
	cQuery := cQuery + "E4.E4_COND, E4_COND, C7.C7_CC, C7.C7_USER, C7.C7_QUANT,C7.C7_QUJE, C7.C7_PRECO, "
	cQuery := cQuery + "Y1.Y1_NOME, C7.C7_SIGLA, C7.C7_VALIPI, DATEPART(WK,C7.C7_DATPRF) AS DIA, C7.C7_ITEM, C7.C7_IPI, C7.C7_VLDESC "
	cQuery := cQuery + "FROM " + RetSqlName( 'SC7' ) +" C7, " + RetSqlName( 'SA2' ) +" A2, "
	cQuery := cQuery + RetSqlName( 'SE4' ) +" E4, " + RetSqlName( 'SY1' ) +" Y1 "
	cQuery := cQuery + "WHERE C7.C7_FILIAL = '" + xFilial("SC7")+ "' "
	cQuery := cQuery + "AND A2.A2_FILIAL = '" + xFilial("SA2")+ "' "
	cQuery := cQuery + "AND E4.E4_FILIAL = '" + xFilial("SE4")+ "' "
	cQuery := cQuery + "AND Y1.Y1_FILIAL = '" + xFilial("SY1")+ "' "
	cQuery := cQuery + "AND SUBSTRING(C7.C7_PRODUTO,1,4) BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' "
	cQuery := cQuery + "AND C7.C7_DATPRF BETWEEN '"+ DTOS(Mv_par06) + "'  AND '"+ DTOS(Mv_par07) + "' "
	cQuery := cQuery + "AND C7.C7_CC BETWEEN '"+ Mv_par02 + "' AND '"+ Mv_par03 + "' "
	cQuery := cQuery + "AND C7.C7_SIGLA BETWEEN '"+ Mv_par08 + "' AND '"+ Mv_par09 + "' "
	If !Empty(Alltrim(mv_par01))
		cQuery := cQuery + "AND C7.C7_USER = '"+ Mv_par01 + "' "
	Endif
	cQuery := cQuery + "AND C7.C7_FORNECE = A2.A2_COD "
	cQuery := cQuery + "AND C7.C7_LOJA = A2.A2_LOJA "
	cQuery := cQuery + "AND C7.C7_COND = E4.E4_CODIGO "
	cQuery := cQuery + "AND C7.C7_USER = Y1.Y1_USER "
	cQuery := cQuery + "AND C7.C7_RESIDUO <> 'S' "
	cQuery := cQuery + "AND C7.D_E_L_E_T_ <> '*' "
	cQuery := cQuery + "AND A2.D_E_L_E_T_ <> '*' "
	// cQuery := cQuery + "GROUP BY C7.C7_NUM, C7.C7_DATPRF, C7.C7_FORNECE " 
	cQuery := cQuery + "ORDER BY 6,2,4" 

	//TCQuery Abre uma workarea com o resultado da query
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","C7_EMISSAO","D")  // Muda a data de string para date
	TcSetField("TMP","C7_DATPRF","D")  // Muda a data de string para date

Return


Static Function fMatriz()
Local lMatriz  := .t.,;
      _n7Quant := 0,;
      _n7Quje  := 0

TMP->(DbGoTop())
While TMP->(!Eof())

	AADD(_axPed,{TMP->C7_EMISSAO,;
				TMP->C7_NUM,;
				TMP->C7_FORNECE,;
				TMP->A2_NOME,;
				TMP->C7_TOTAL,;
				TMP->C7_DATPRF,;
				TMP->C7_COND,;
				TMP->E4_COND,;
				TMP->C7_CC,;
				TMP->C7_USER,;
				TMP->Y1_NOME,;
				TMP->C7_SIGLA,;
				TMP->C7_VALIPI,;
				TMP->DIA,;
				TMP->C7_ITEM,;
				Space(06),;
				Ctod(Space(08)),;
				TMP->C7_QUANT,;
				TMP->C7_QUJE,;
				TMP->C7_PRECO,;
				TMP->C7_IPI,;
				TMP->C7_VLDESC,})
	TMP->(Dbskip())
Enddo
_n := 1

SD1->(DbSetOrder(13))
For _n := 1 To Len(_axPed)
	SD1->(DbSeek(xFilial("SD1")+_axPed[_n,2]))
	While !SD1->(Eof()) .And. SD1->D1_PEDIDO == _axPed[_n,2]
		If SD1->D1_PEDIDO == _axPed[_n,2] .AND. SD1->D1_ITEMPC == _axPed[_n,15]
			_axPed[_n,16] := SD1->D1_DOC
			_axPed[_n,17] := SD1->D1_DTDIGIT
			Exit
		Endif
		SD1->(DbSkip())
	Enddo
Next

_n := 1
For _n := 1 To Len(_axPed)
	
	If Mv_Par11 == 2 
		If _axPed[_n,18] - _axPed[_n,19] > 0
			Aadd(_anPed,{_axPed[_n,1],_axPed[_n,2],_axPed[_n,3],_axPed[_n,4],_axPed[_n,5],_axPed[_n,6],_axPed[_n,7],;
			            _axPed[_n,8],_axPed[_n,9],_axPed[_n,10],_axPed[_n,11],_axPed[_n,12],_axPed[_n,13],_axPed[_n,14],;
	    		        _axPed[_n,15],_axPed[_n,16],_axPed[_n,17], _axPed[_n,18], _axPed[_n,19], _axPed[_n,20], _axPed[_n,21], _axPed[_n,22] })
		Endif
	Elseif Mv_Par11 == 3
		If _axPed[_n,18] - _axPed[_n,19] == 0
			Aadd(_anPed,{_axPed[_n,1],_axPed[_n,2],_axPed[_n,3],_axPed[_n,4],_axPed[_n,5],_axPed[_n,6],_axPed[_n,7],;
			            _axPed[_n,8],_axPed[_n,9],_axPed[_n,10],_axPed[_n,11],_axPed[_n,12],_axPed[_n,13],_axPed[_n,14],;
	    		        _axPed[_n,15],_axPed[_n,16],_axPed[_n,17], _axPed[_n,18], _axPed[_n,19], _axPed[_n,20], _axPed[_n,21], _axPed[_n,22] })
		Endif
	Elseif Mv_Par11 == 1
		Aadd(_anPed,{_axPed[_n,1],_axPed[_n,2],_axPed[_n,3],_axPed[_n,4],_axPed[_n,5],_axPed[_n,6],_axPed[_n,7],;
		            _axPed[_n,8],_axPed[_n,9],_axPed[_n,10],_axPed[_n,11],_axPed[_n,12],_axPed[_n,13],_axPed[_n,14],;
	    	        _axPed[_n,15],_axPed[_n,16],_axPed[_n,17], _axPed[_n,18], _axPed[_n,19], _axPed[_n,20], _axPed[_n,21], _axPed[_n,22] })
	Endif

Next

_z       := 1
_n       := 1
nSubTot  := 0
_nTotpe  := 0
_nIpi    := 0
_nSaldo  := 0
_c7Num   := Space(06)
While _n <= Len(_anPed)

	_c7Num := _anPed[_n,2]                                
	While _c7Num == _anPed[_n,2]
		_nSaldo  := _anPed[_n,18] - _anPed[_n,19]
		_n7Quant += _anPed[_n,18]
		_n7Quje  += _anPed[_n,19]
               
		If _nSaldo > 0 // Saldo do pedido
		   _nTotpe := _nSaldo * _anPed[_n,20]
		   _nIpi   := ((_nTotpe * _anPed[_n,21])/100)
		Else  // Quantidade Entrege
		   _nTotpe := _anPed[_n,18] * _anPed[_n,20]
		   _nIpi   := ((_nTotpe * _anPed[_n,21])/100)
		Endif		
		nSubTot  += (_nTotpe + _nIpi) - _anPed[_n,22]
		_n++

		If _n > Len(_anPed)
			Exit
		Endif			
	Enddo
	_n--
	Aadd(_aPed,{_anPed[_n,1],_anPed[_n,2],_anPed[_n,3],_anPed[_n,4],_anPed[_n,5],_anPed[_n,6],_anPed[_n,7],;
		        _anPed[_n,8],_anPed[_n,9],_anPed[_n,10],_anPed[_n,11],_anPed[_n,12],_anPed[_n,13],_anPed[_n,14],;
		        _anPed[_n,15],_anPed[_n,16],_anPed[_n,17],_anPed[_n,18],_anPed[_n,19],_anPed[_n,20],_anPed[_n,21]})

	_aPed[_z,18] = _n7Quant
	_aPed[_z,19] = _n7Quje
	_aPed[_z,20] = nSubTot
    _z++
	_n++
	nSubTot  := 0
	_nTotpe  := 0
	_nIpi    := 0
	_n7Quant := 0
	_n7Quje  := 0


Enddo



If Len(_axPed) <=0
	MsgBox("Nao existe dados para impressao","Relatorios","ALERT")
	Return
Endif	


Return



Static Function RptDet1()

_n := 1

If Mv_Par11 == 2
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS EM ABERTO"
Elseif Mv_Par11 == 3
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS ATENDIDOS"
Else
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS EM ABERTO/ATENDIDOS"
Endif

// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// calcula as datas finais para cada semana
dData1:= CTOD("//")
if _aPed[_n,14] < 7
   dData1 := Mv_par06 + 1 - _aPed[_n,14] // TMP->DIA      
else
   dData1 := Mv_par06 + 1
endif

// Inicializa variaveis
dData2 := dData1 + 7
dData3 := dData2 + 7
dData4 := dData3 + 7   
dData5 := dData4 + 7
dData6 := dData5 + 7   
cCentroC := _aPed[_n,9] // TMP->C7_CC
_nSemana := _aPed[_n,14] // TMP->DIA
_n := 1
_nTotAberto := 0
_nTotAtende := 0
_nSubAberto := 0
_nSubAtende := 0

// inicializa totalizadores   
nSubTot   := 0
nTotGer   := 0
nTotCC    := 0
nConta    := 1
_lPri     := .T.
_nTotItem := 0
_nTotCIpi := 0
nTotIpi   := 0
_c7Num    := Space(06)

While _n <= Len(_aPed)

	IncProc("Imprimindo Previsao de Desembolso "  + _aPed[_n,2] ) // + TMP->C7_NUM)
  
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
	Endif   


	@ Prow() +1, 001 Psay _aPed[_n,1]  // TMP->C7_EMISSAO
	@ Prow()   , 012 Psay _aPed[_n,2] // TMP->C7_NUM
	@ Prow()   , 020 Psay _aPed[_n,3] + " " + SUBSTR(_aPed[_n,4],1,30)	// TMP->C7_FORNECE + " " + SUBSTR(TMP->A2_NOME,1,30)	  	

	_nTotPe := _nIpi := _nSaldo := 0
	_nSaldo := (_aPed[_n,18] - _aPed[_n,19]) // Saldo
	_nTotpe := _aPed[_n,20]

	@ Prow()   , 075 Psay _aPed[_n,6] // TMP->C7_DATPRF
	@ Prow()   , 087 Psay SUBSTR(_aPed[_n,8],1,12) // SUBSTR(TMP->E4_COND,1,12)

	if substr(_aPed[_n,8],1,2) <> '  '
	   @ Prow()   , 102 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],1,2)))
	endif

	if substr(_aPed[_n,8],4,2) <> '  '
	   	@ Prow()   , 114 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],4,2)))
	endif

	if substr(_aPed[_n,8],8,2) <> '  '
	   	@ Prow()   , 126 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],7,2)))
	endif

	if substr(_aPed[_n,8],12,2) <> '  '
	   	@ Prow()   , 138 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],10,2)))
	endif
                                                                                  `
  	//nSusTot - variavel de subtotal para semanas
   	//nTotGer - variavel de total geral
	nSubTot += _nTotpe + _nIpi
	nTotGer += _nTotpe + _nIpi
	nTotIpi := _nTotpe + _nIpi

	If _nSaldo > 0 // Pedidos em aberto
		_nTotAberto += nTotIpi
		_nSubAberto += nTotIpi
	Else
		_nTotAtende += nTotIpi
		_nSubAtende += nTotIpi
	Endif
	@ Prow()   , 160 Psay transform(_aPed[_n,20],"@E 999,999,999.99")
	@ Prow()   , 201 Psay _aPed[_n,12] + "  " +_aPed[_n,16]
	_nSemana := _aPed[_n,14] // TMP->DIA

	// Imprime detalhes
	SC7->(DbSetOrder(1))
	SC7->(DbSeek(xFilial("SC7")+_aPed[_n,2]))
	While !SC7->(Eof()) .And. SC7->C7_NUM == _aPed[_n,2]
		If SC7->C7_SIGLA == _aPed[_n,12] .And. ;
			SC7->C7_DATPRF == _aPed[_n,6] .And. ;
			SUBSTRING(SC7->C7_PRODUTO,1,4) >=  Mv_par04  .And.  SUBSTRING(SC7->C7_PRODUTO,1,4) <= Mv_par05

			If _lPri
				@ Prow() + 1, 001 Psay __PrtThinLine()
				_lPri := .F.
			Endif				

			_nTotpe := _nIpi := _nTotPed := _Quant := 0
			_nSaldo := (SC7->C7_QUANT - SC7->C7_QUJE)
			If _nSaldo > 0
				_nTotpe  := _nSaldo * SC7->C7_PRECO
				_nIpi    := ((_nTotpe * SC7->C7_IPI)/100)
				_nQuant  := _nSaldo
			Else
				_nTotpe  := SC7->C7_QUJE * SC7->C7_PRECO
				_nIpi    := ((_nTotpe * SC7->C7_IPI)/100)
				_nQuant  := SC7->C7_QUJE
			Endif

			@ Prow() +1, 001 Psay SC7->C7_ITEM
			@ Prow()   , 004 Psay SC7->C7_PRODUTO
			@ Prow()   , 020 Psay Substr(SC7->C7_DESCRI,1,53)
			@ Prow()   , 075 Psay SC7->C7_DATPRF
			@ Prow()   , 106 Psay _nQuant Picture "@E 99999.99"
			@ Prow()   , 115 Psay SC7->C7_UM
			@ Prow()   , 120 Psay SC7->C7_PRECO  Picture "@E 999,999,999.99"
			@ Prow()   , 140 Psay SC7->C7_VALIPI Picture "@E 999,999,999.99"
			@ Prow()   , 159 Psay _nTotpe - SC7->C7_VLDESC Picture "@E 999,999,999.99"
			@ Prow()   , 178 Psay _nTotpe+_nIpi - SC7->C7_VLDESC  Picture "@E 999,999,999.99"
			@ Prow()   , 200 Psay SC7->C7_SIGLA

			_nTotItem := _nTotItem + _nTotPe
			_nTotCIpi := _nTotCIpi + _nTotpe + _nIpi

		Endif
		SC7->(DbSkip())
	Enddo
	If _nTotItem > 0
		@ Prow() +2, 001 Psay " "
	Endif
	_lPri     := .T.
	_nTotItem := 0
	_nTotCIpi := 0
	_n++

	If _n <= Len(_aPed)

	    If _aPed[_n,14] <> _nSemana

			If Prow() > 60
				_nPag := _nPag + 1
				Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
			Endif   

			@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"
			@ Prow()   , 160 Psay transform(nSubTot, "@E 999,999,999.99")

			If Mv_Par11 == 1
				@ Prow()+1 , 132 Psay "       Atendido"
				@ Prow()   , 160 Psay transform(_nSubAtende, "@E 999,999,999.99")
				@ Prow()+1 , 131 Psay "       Em Aberto"
				@ Prow()   , 160 Psay transform(_nSubAberto, "@E 999,999,999.99")
			Endif

			@ Prow()+1 , 132 Psay "Total Acumulado"
			@ Prow()   , 160 Psay transform(nTotGer, "@E 999,999,999.99")
			@ Prow() + 1, 001 Psay __PrtThinLine()
			@ Prow()+1 , 001 Psay " "

			_nSubTot    := 0
			_nSubAtende := 0
			_nSubAberto := 0   
			nSubtot     := 0			
			nConta := nConta +1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
		Endif

	Else
	
		If Prow() > 60
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
		Endif   


		@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"
		@ Prow()   , 160 Psay transform(nSubTot, "@E 999,999,999.99")
		If Mv_Par11 == 1
			@ Prow()+1 , 132 Psay "       Atendido"
			@ Prow()   , 160 Psay transform(_nSubAtende, "@E 999,999,999.99")
			@ Prow()+1 , 131 Psay "       Em Aberto"
			@ Prow()   , 160 Psay transform(_nSubAberto, "@E 999,999,999.99")
		Endif	
		@ Prow()+1 , 132 Psay "Total Acumulado"
		@ Prow()   , 160 Psay transform(nTotGer, "@E 999,999,999.99")
		@ Prow() + 1, 001 Psay __PrtThinLine()
		@ Prow()+1 , 001 Psay " "

	Endif		

Enddo

@ Prow()+1 , 136 Psay "Total Geral"
@ Prow()   , 160 Psay transform(nTotGer, "@E 999,999,999.99")
@ Prow()+1 , 136 Psay "   Atendido"
@ Prow()   , 160 Psay transform(_nTotAtende, "@E 999,999,999.99")
@ Prow()+1 , 136 Psay "  Em Aberto"
@ Prow()   , 160 Psay transform(_nTotAberto, "@E 999,999,999.99")
@ Prow() + 1, 001 Psay __PrtThinLine()
      
Return(nil)


Static Function RptDet2()
_n := 1

If Mv_Par11 == 2
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS EM ABERTO"
Elseif Mv_Par11 == 3
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS ATENDIDOS"
Else
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS EM ABERTO/ATENDIDOS"
Endif

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// calcula as datas finais para cada semana
          
dData1:= CTOD("//")
if _aPed[_n,14] < 7
   dData1 := Mv_par06 + 1 - _aPed[_n,14]
else
   dData1 := Mv_par06 + 1
endif

// inicializa variaveis    
nSubIpi  := 0
dData2   := dData1 + 7
dData3   := dData2 + 7
dData4   := dData3 + 7   
dData5   := dData4 + 7
dData6   := dData5 + 7   
cCentroC := _aPed[_n,9]
_nSemana := _aPed[_n,14]
_nTotAtende := 0
_nTotAberto := 0
_nSubAtende := 0
_nSubAberto := 0

// inicializa totalizadores   
nSubTot  := 0
nTotGer  := 0
nTotCC   := 0
nConta   := 1


While _n <= Len(_aPed)

   IncProc("Imprimindo Previsao de Desembolso " + _aPed[_n,2])
   
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif   

	@ Prow() +1, 001 Psay _aPed[_n,1]
	@ Prow()   , 012 Psay _aPed[_n,2]
	@ Prow()   , 020 Psay _aPed[_n,3] + " " + SUBSTR(_aPed[_n,4],1,30)	  	
	@ Prow()   , 059 Psay transform(_aPed[_n,20], "@E 999,999,999.99")
	@ Prow()   , 075 Psay _aPed[_n,6]
	@ Prow()   , 087 Psay SUBSTR(_aPed[_n,8],1,12) 

	if substr(_aPed[_n,8],1,2) <> '  ' 
	   @ Prow()   , 102 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],1,2)))
	endif
	if substr(_aPed[_n,8],4,2) <> '  ' 
   	@ Prow()   , 114 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],4,2))) 
	endif
	if substr(_aPed[_n,8],8,2) <> '  ' 
   	@ Prow()   , 126 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],7,2))) 
	endif           
	if substr(_aPed[_n,8],12,2) <> '  ' 
   	@ Prow()   , 138 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],10,2))) 
	endif           

  	//nSusTot - variavel de subtotal para semanas
    //nTotGer - variavel de total geral
	nSubTot += _aPed[_n,20]
	nTotGer += _aPed[_n,20]
	_nSaldo := 0
	_nSaldo := (_aPed[_n,18] - _aPed[_n,19]) // Saldo
	If _nSaldo > 20
		_nTotAberto += _aPed[_n,20]
		_nSubAberto += _aPed[_n,20]
	Else
		_nTotAtende += _aPed[_n,20]
		_nSubAtende += _aPed[_n,20]
	Endif

	@ Prow()   , 152 Psay transform(_aPed[_n,13],"@E 999,999,999.99")
	@ Prow()   , 170 Psay transform(_aPed[_n,20],"@E 999,999,999.99")
	@ Prow()   , 186 Psay transform(nSubTot,"@E 999,999,999.99")
	@ Prow()   , 206 Psay _aPed[_n,12] + "  " + _aPed[_n,16]
	_nSemana := _aPed[_n,14]
	_n++

	If _n <= Len(_aPed)
	    If _aPed[_n,14] <> _nSemana

			If Prow() > 60
				_nPag := _nPag + 1
				Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
			Endif   

			@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"
			@ Prow()   , 186 Psay transform(nSubTot, "@E 999,999,999.99")
	
			If Mv_Par11 == 1
				@ Prow()+1 , 132 Psay "       Atendido"
				@ Prow()   , 186 Psay transform(_nSubAtende, "@E 999,999,999.99")
				@ Prow()+1 , 131 Psay "       Em Aberto"
				@ Prow()   , 186 Psay transform(_nSubAberto, "@E 999,999,999.99")
			Endif	

			@ Prow()+1 , 132 Psay "Total Acumulado"
			@ Prow()   , 186 Psay transform(nTotGer, "@E 999,999,999.99")
			@ Prow() + 1, 001 Psay __PrtThinLine()
			@ Prow()+1 , 001 Psay " "
			nSubTot     := 0
			_nSubAtende := 0
			_nSubAberto := 0
			nConta := nConta +1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
		Endif
	Else

		If Prow() > 60
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
		Endif   

		@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"
		@ Prow()   , 186 Psay transform(nSubTot, "@E 999,999,999.99")

		If Mv_Par11 == 1
			@ Prow()+1 , 132 Psay "       Atendido"
			@ Prow()   , 186 Psay transform(_nSubAtende, "@E 999,999,999.99")
			@ Prow()+1 , 131 Psay "       Em Aberto"
			@ Prow()   , 186 Psay transform(_nSubAberto, "@E 999,999,999.99")
		Endif	

		@ Prow()+1 , 132 Psay "Total Acumulado"
		@ Prow()   , 186 Psay transform(nTotGer, "@E 999,999,999.99")
		@ Prow() + 1, 001 Psay __PrtThinLine()
	Endif		

Enddo

@ Prow()+1 , 136 Psay "Total Geral"
@ Prow()   , 186 Psay transform(nTotGer, "@E 999,999,999.99")                                   
@ Prow()+1 , 132 Psay "       Atendido"
@ Prow()   , 186 Psay transform(_nTotAtende, "@E 999,999,999.99")
@ Prow()+1 , 131 Psay "       Em Aberto"
@ Prow()   , 186 Psay transform(_nTotAberto, "@E 999,999,999.99")
@ Prow() + 1, 001 Psay __PrtThinLine()
      
Return(nil)      


Static Function AjustaSX1()

SetPrvt("_sAlias,cPerg,aRegs,cUltPerg,i,j")

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg   := "COM007"
aRegs   := {}

aadd(aRegs,{cPerg,"01","Usuario          ?","Usuario          ?","Usuario          ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","C.Custo de       ?","C.Custo de       ?","C.Custo de       ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aadd(aRegs,{cPerg,"03","C.Custo Ate      ?","C.Custo Ate      ?","C.Custo Ate      ?","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aadd(aRegs,{cPerg,"04","Grupo de         ?","Grupo de         ?","Grupo de         ?","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
aadd(aRegs,{cPerg,"05","Grupo Ate        ?","Grupo Ate        ?","Grupo Ate        ?","mv_ch5","C",04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
aadd(aRegs,{cPerg,"06","Data de          ?","Data de          ?","Data de          ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Data Ate         ?","Data Ate         ?","Data Ate         ?","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Sigla de         ?","Sigla de         ?","Sigla de         ?","mv_ch8","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","ZDE",""})
aadd(aRegs,{cPerg,"09","Sigla Ate        ?","Sigla Ate        ?","Sigla Ate        ?","mv_ch9","C",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","ZDE",""})

cUltPerg := aRegs[Len(aRegs)][2]

If SX1->(!DbSeek(cPerg + cUltPerg))

   SX1->(DbSeek(cPerg))

   While SX1->X1_Grupo == cPerg
      RecLock('SX1')
      SX1->(DbDelete())
   	SX1->(DbSkip())
      MsUnLock('SX1')
   End

   For i := 1 To Len(aRegs)
       RecLock("SX1", .T.)

	 For j := 1 to Len(aRegs[i])
	     FieldPut(j, aRegs[i, j])
	 Next
       MsUnlock()

       DbCommit()
   Next
EndIf                   

dbSelectArea(_sAlias)

Return