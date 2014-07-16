/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM045  ºAutor  ³Marcos R Roquitski  º Data ³  13/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de pedidos atendidos (NFS).                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#include "rwmake.ch"      
#INCLUDE "topconn.ch"

User Function Nhcom045()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,_dDataEnt,_nNfGe,_nqTotpe,_nqIpi,_nBase1,_nJaEnt")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende,_nPosMes")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z,_aMes,j")
SetPrvt("aSigla,x,k,_cSigla,lRet,_nSTotal")

_aGrupo   := pswret()
_cCodUsr  := _agrupo[1,1]
cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Previsao de Desembolso por Fornecedor")
cDesc3    := OemToAnsi("")
tamanho   := "P"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 80 
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM046"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "PREVISAO DE DESEMBOLSO P/FORNECEDOR"
Cabec1    := " Sigla      Descricao                            Total"
Cabec2    := " "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHCOM045"       //Nome Default do relatorio em Disco
_cPerg    := "COM007"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	
_aMes     := {}
_nPosMes  := 0

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

If Empty(TMP->D1_DOC)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| fMatriz()   },"Gerando Dados para a Impressao")

If Len(_aPed) <=0
	MsgBox("Nao existe dados para impressao","Relatorios","ALERT")
    DbSelectArea("TMP")
    DbCloseArea()
	Return
Endif	

Processa( {|| RptDet() },"Imprimindo...")

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

   	IncProc("Processando..........") 
	cQuery := "SELECT DATEPART(WK, D1.D1_DTDIGIT) AS 'DIA', * FROM " + RetSqlName( 'SD1' ) + " D1 "
	cQuery += "WHERE D1.D1_DTDIGIT BETWEEN '"+ DTOS(Mv_par06) + "'  AND '"+ DTOS(Mv_par07) + "' "
	cQuery += "AND D1.D1_FILIAL = '" + xFilial("SD1")+ "' "
	cQuery += "AND D1.D1_PEDIDO <> ' ' " 
	cQuery += "AND D1.D_E_L_E_T_ = ' ' " 
	cQuery += "AND D1.D1_GRUPO BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' "
	cQuery += "ORDER BY D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC "
	
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de string para date

Return

Static Function fMatriz()
Local lMatriz   := .t.,;
      _n7Quant  := 0,;
      _n7Quje   := 0,;
      _nAbeUni  := 0,;
      _nAbeIpi  := 0,;
      _nAberto  := 0,;
      _cNomeFor := Space(30)
SA2->(DbsetOrder(1))
TMP->(DbGoTop())
While TMP->(!Eof())
   	IncProc("Processando.........." + TMP->D1_PEDIDO ) 
	SC7->(DbSeek(xFilial("SD1")+TMP->D1_PEDIDO + TMP->D1_ITEMPC))
	If SC7->(Found()) 
		If !Empty(Alltrim(mv_par01))
			If SC7->C7_USER == Mv_par01
				If SC7->C7_SIGLA >=  Mv_par08  .AND. SC7->C7_SIGLA <=  Mv_par09
					_cNomeFor := Space(30)
					SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOCAL))
					IF SA2->(Found())
						_cNomeFor := Substr(SA2->A2_NOME,1,30)
					Endif
					AADD(_anPed,{SC7->C7_EMISSAO,; // 1
					TMP->D1_PEDIDO+TMP->D1_ITEMPC,; //2
					SC7->C7_FORNECE,; // 3
					_cNomeFor,; // 4
					TMP->D1_TOTAL,; //5
					SC7->C7_DATPRF,; // 6
					SC7->C7_COND,; // 7
    				Space(10),; // 8
 					SC7->C7_CC,; // 9
					SC7->C7_USER,; //10
					Space(30),; // 11
					SC7->C7_SIGLA,; // 12
					TMP->D1_VALIPI,; // 13
					TMP->DIA,; // 14
					TMP->D1_ITEMPC,; // 15
					TMP->D1_DOC,; // 16
					TMP->D1_DTDIGIT,; // 17
					TMP->D1_QUANT,; // 18
					TMP->D1_QUANT,; // 19
					TMP->D1_VUNIT,; // 20
					TMP->D1_IPI,; // 21
					0}) // 22
				Endif	
			Endif	
		Else
			If SC7->C7_SIGLA >=  Mv_par08  .AND. SC7->C7_SIGLA <=  Mv_par09
				_cNomeFor := Space(30)
				SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOCAL))
				IF SA2->(Found())
					_cNomeFor := Substr(SA2->A2_NOME,1,30)
				Endif	
				AADD(_anPed,{SC7->C7_EMISSAO,; // 1
				TMP->D1_PEDIDO+TMP->D1_ITEMPC,; //2
				SC7->C7_FORNECE,; // 3
				_cNomeFor,; // 4
				TMP->D1_TOTAL,; //5
				SC7->C7_DATPRF,; // 6
				SC7->C7_COND,; // 7
   				Space(10),; // 8
				SC7->C7_CC,; // 9
				SC7->C7_USER,; //10
				Space(30),; // 11
				SC7->C7_SIGLA,; // 12
				TMP->D1_VALIPI,; // 13
				TMP->DIA,; // 14
				TMP->D1_ITEMPC,; // 15
				TMP->D1_DOC,; // 16
				TMP->D1_DTDIGIT,; // 17
				TMP->D1_QUANT,; // 18
				TMP->D1_QUANT,; // 19
				TMP->D1_VUNIT,; // 20
				TMP->D1_IPI,; // 21
				0}) // 22
			Endif	
		Endif
	Endif
	TMP->(Dbskip())
Enddo

If Len(_anPed) > 0
	_n       := 1
	_z       := 1
	_n       := 1
	nSubTot  := 0
	_nTotpe  := 0
	_nIpi    := 0
	_nSaldo  := 0
	_c7Num   := Space(06)
	_nJaEnt  := 0
	While _n <= Len(_anPed)
	   	IncProc("Processando..........."+ _c7Num)
		_c7Num := Substr(_anPed[_n,2],1,6) + Dtos(_anPed[_n,17])
		While _c7Num == Substr(_anPed[_n,2],1,6) + Dtos(_anPed[_n,17])

			// Calcula qtde entregue
			_nTotpe := _anPed[_n,18] * _anPed[_n,20]
			_nIpi   := ((_nTotpe * _anPed[_n,21])/100)
		      
			nSubTot  += (_nTotpe + _nIpi)
			_n++

			If _n > Len(_anPed)
				Exit
			Endif

		Enddo
		_n--
		Aadd(_aPed,{_anPed[_n,1],_anPed[_n,2],_anPed[_n,3],_anPed[_n,4],_anPed[_n,5],_anPed[_n,6],_anPed[_n,7],;
			        _anPed[_n,8],_anPed[_n,9],_anPed[_n,10],_anPed[_n,11],_anPed[_n,12],_anPed[_n,13],_anPed[_n,14],;
			        _anPed[_n,15],_anPed[_n,16],_anPed[_n,17],_anPed[_n,18],_anPed[_n,19],_anPed[_n,20],_anPed[_n,21],_anPed[_n,22],0})

		_aPed[_z,20] = nSubTot
	    _z++
		_n++
		nSubTot  := 0
		_nTotpe  := 0
		_nIpi    := 0

	Enddo
Endif
If Len(_aPed) <=0
	MsgBox("Nao existe dados para impressao","Relatorios","ALERT")
	Return
Endif	
        
Return

Static Function RptDet()
Local _nAberto := 0, _aTotMes := {}, _aPosTmes := 0, lSd1 := .F.,_cX5Descri,_nSToGer

_n := 1

titulo := "PC Atendido "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)

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
dData2      := dData1 + 7
dData3      := dData2 + 7
dData4      := dData3 + 7
dData5      := dData4 + 7
dData6      := dData5 + 7
cCentroC    := _aPed[_n,9] // TMP->C7_CC
_nSemana    := _aPed[_n,14] // TMP->DIA
_n          := 1
_nTotAberto := 0
_nTotAtende := 0
_nSubAberto := 0
_nSubAtende := 0

// inicializa totalizadores
nSubTot     := 0
nTotGer     := 0
nTotCC      := 0
nConta      := 1
_lPri       := .T.
_nTotItem   := 0
_nTotCIpi   := 0
nTotIpi     := 0
_nNfGe      := 0
_c7Num      := Space(06)
j           := 1
lSd1        := .F.

While _n <= Len(_aPed)

	IncProc("Imprimindo Pedidos Atendidos "  + _aPed[_n,2] ) // + TMP->C7_NUM)

	_nTotPe  := _nIpi := _nSaldo := _nBase1 := 0
	_nSaldo  := (_aPed[_n,18] - _aPed[_n,19]) // Saldo
	_nTotpe  := _aPed[_n,20]
	_nAberto := _aPed[_n,23]
                                                                                  `
  	//nSusTot - variavel de subtotal para semanas
   	//nTotGer - variavel de total geral
	nSubTot += _nTotPe //+ _nIpi
	nTotGer += _nTotPe //+ _nIpi
	nTotIpi := _nTotPe //+ _nIpi

	_nTotAberto += _nAberto
	_nSubAberto += _nAberto
	_nTotAtende += (nTotIpi - _nAberto)
	_nSubAtende += (nTotIpi - _nAberto)
	_nSemana := _aPed[_n,14] // TMP->DIA

	SD1->(DbSetOrder(13))
	SD1->(DbSeek(xFilial("SD1")+Substr(_aPed[_n,2],1,6) ) )
	While !SD1->(Eof()) .And. SD1->D1_PEDIDO == Substr(_aPed[_n,2],1,6)

		If SD1->D1_DTDIGIT >=  Mv_par06 .And. SD1->D1_DTDIGIT <= Mv_par07 .And. SD1->D1_GRUPO >= Mv_par04 .And. SD1->D1_GRUPO <= Mv_par05
	       
			SC7->(DbSetOrder(1))
			SC7->(DbSeek(xFilial("SC7")+SD1->D1_PEDIDO + SD1->D1_ITEMPC))
			If SC7->(Found())

			   If SC7->C7_SIGLA >= Mv_par08  .AND. SC7->C7_SIGLA <= Mv_par09 .AND. SD1->D1_DTDIGIT == _aPed[_n,17] .AND. Substr(SC7->C7_PRODUTO,1,4) >= Mv_Par04 .And. Substr(SC7->C7_PRODUTO,1,4) <= Mv_Par05
					If _lPri
					_lPri := .F.
				Endif				

				_dDataEnt := SC7->C7_DATPRF
				_nTotpe   := _nIpi := _nTotPed := _Quant := 0

				_nPosMes  := Ascan(_aMes,{ |x| x[1] == Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4)+" "+SC7->C7_SIGLA })
				_nPosTMes := Ascan(_aTotMes,{ |x| x[1] == Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4)+" "+SC7->C7_SIGLA})
			
				_nTotpe  := SD1->D1_QUANT * SD1->D1_VUNIT
				_nIpi    := ((_nTotpe * SD1->D1_IPI)/100)
		
	       		If 	Month(_dDataEnt) > 0
					If _nPosMes == 0
						AADD(_aMes,{ Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4)+" "+SC7->C7_SIGLA, (_nTotpe+_nIpi),SC7->C7_SIGLA,Dtos(_dDataEnt)})
					Else
						_aMes[_nPosMes,2] += _nTotpe+_nIpi
					Endif

					If _nPosTmes == 0
						AADD(_aTotMes,{ Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4)+" "+SC7->C7_SIGLA, (_nTotpe+_nIpi),SC7->C7_SIGLA,Dtos(_dDataEnt)})
					Else
						_aTotMes[_nPosTmes,2] += _nTotpe+_nIpi
					Endif

					_nNfGe += _nTotpe+_nIpi
	
				Endif

				_nTotItem := _nTotItem + _nTotPe
				_nTotCIpi := _nTotCIpi + _nTotpe + _nIpi
             Endif
			Endif
		Endif  		
		SD1->(DbSkip())
	Enddo
	_lPri     := .T.
	_nTotItem := 0
	_nTotCIpi := 0
	_n++

Enddo 

If Prow() > 60
	_nPag := _nPag + 1
	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
Endif

SX5->(DbSetOrder(1))
_aTotMes := Asort(_aTotMes,,, { |x,y| x[3]+x[4] < y[3]+y[4] })
j := 1
_cSigla := Space(03)
_nSTotal := 0
_nSToGer := 0

For j := 1 To Len(_aTotMes)

	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
	Endif

	_cX5Descri := Space(20)
	SX5->(DbSeek(xFilial("SX5")+"ZE"))
	While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZE"
		If Alltrim(SX5->X5_CHAVE) == _aTotMes[j,3]
			_cX5Descri := Substr(SX5->X5_DESCRI,1,20)
			Exit //achou força a saida
		Endif
		SX5->(DbSkip())
	Enddo

	@ Prow()+1 , 001 Psay _aTotMes[j,3] + " " +_cX5Descri + " " + Substr(_aTotMes[j,1],1,7)
	@ Prow()   , 040 Psay Transform(_aTotMes[j,2], "@E 999,999,999.99")

	_nSTotal += _aTotMes[j,2]
	_nSToGer += _aTotMes[j,2]
	_cSigla := _aTotMes[j,3]

	If (j+1) <= Len(_aTotMes)
		If _cSigla <> _aTotMes[j+1,3]
			@ Prow()+1 ,001 Psay __PrtThinLine()
			@ Prow()+1 ,001 Psay "Total: "+_aTotMes[j,3] + " " +_cX5Descri
			@ Prow()   ,040 Psay transform(_nSTotal, "@E 999,999,999.99")
			@ Prow()+1 ,001 Psay __PrtThinLine()
			@ Prow()+1 ,001 Psay ""
			_nSTotal := 0
		Endif	
	Endif

	If (j+1) > Len(_aTotMes) 
			@ Prow()+1 ,001 Psay __PrtThinLine()
			@ Prow()+1 ,001 Psay "Total: "+_aTotMes[j,3] + " " + _cX5Descri
			@ Prow()   ,040 Psay transform(_nSTotal, "@E 999,999,999.99")
			@ Prow()+1 ,001 Psay __PrtThinLine()
			@ Prow()+1 ,001 Psay ""
			_nSTotal := 0
	Endif
	
Next

@ Prow()+1 ,001 Psay __PrtThinLine()
@ Prow()+1 ,010 Psay "Total Geral"
@ Prow()   ,040 Psay transform(_nSToGer, "@E 999,999,999.99")
@ Prow()+1 ,001 Psay __PrtThinLine()
      
Return(nil) 