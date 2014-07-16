/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHCOM038  ºAutor  ³Marcos R Roquitski  º Data ³  06/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Estatistica de Atendimento de Solicitacao de Compras       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhcom038()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,_dDataEnt,_nNfGe,_nqTotpe,_nqIpi,_nBase1,_nJaEnt")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende,_nPosMes")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z,_aMes,j,cFilterUser")

_aGrupo   := pswret()
_cCodUsr  := _agrupo[1,1]
cString   := "SC7"
cDesc1    := OemToAnsi("Relatorio de atendimento Solicitacao de Compras X Entrega do produto")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM038"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "ESTATISTICA DE ATENDIMENTO DE SOLICITACAO DE COMPRAS"
Cabec1    := " NUM.SC ITEM  PRODUTO         DESCRICAO DO PRODUTO                    EMISSAO SC  DT.PREV.SC     QTDE SC  PEDIDO  ITEM DT.PEDIDO  DT.PREV.PC   N.FISCAL DT.ENT.NF     QTDE NF.  DIA ATRASO"
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHCOM038"       //Nome Default do relatorio em Disco
_cPerg    := "COM038"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	
_aMes     := {}
_nPosMes  := 0

//Mv_par01 :=	Centro de Custo de   
//Mv_par02 :=	Centro de Custo Ate  
//Mv_par03 :=	Grupo de 
//Mv_par04 :=	Grupo Ate 
//Mv_par05 :=	Data de 
//Mv_par06 :=	Data Ate 
//Mv_par07 :=	Produto de
//Mv_par08 :=	Produto Ate 
//mv_par09 :=   Solicitacao inicio
//mv_par10 :=   Solicitacao fim.

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

cFilterUser := Alltrim(aReturn[7])


nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

// inicio do processamento do relatório
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer
TMP->(DbGoTop())

If Empty(TMP->C1_NUM)
   MsgBox("Não existem dados para estes parâmetros...verifique!","Atencao","STOP")
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
     
	// QUERY REFEITA - LEFT JOIN - JOAOFR 01/04/14
	cQuery := "SELECT C1.C1_NUM,C1.C1_ITEM,C1.C1_PRODUTO,C1_DESCRI,C1.C1_DATPRF,C1.C1_QUANT,C7.C7_NUM,C7.C7_ITEM,C1.C1_EMISSAO,C7.C7_DATPRF,C7.C7_EMISSAO "
	cQuery += "FROM " + RetSqlName( 'SC1' ) +" C1 (NOLOCK) LEFT JOIN " + RetSqlName( 'SC7' ) +" C7 (NOLOCK) ON "
	cQuery += "C1.C1_NUM = C7.C7_NUMSC "
	cQuery += "AND C1.C1_ITEM = C7.C7_ITEMSC "
	cQuery += "AND C7.D_E_L_E_T_ = '' AND C7.C7_FILIAL = '"+XFILIAL('SC7')+"'"
	cQuery += "WHERE C1.C1_EMISSAO BETWEEN '"+ DTOS(Mv_par05) + "'  AND '"+ DTOS(Mv_par06) + "' "
	cQuery += "AND C1.D_E_L_E_T_ = '' AND C1.C1_FILIAL = '"+XFILIAL('SC1')+"'"
	cQuery += "AND C1.C1_CC BETWEEN '"+ Mv_par01 + "' AND '"+ Mv_par02 + "' "
	cQuery += "AND SUBSTRING(C1.C1_PRODUTO,1,4) BETWEEN '"+ Mv_par03 + "' AND '"+ Mv_par04 + "' "
	cQuery += "AND C1.C1_PRODUTO BETWEEN '"+ Mv_par07 + "' AND '"+ Mv_par08 + "' "
	cQuery += "AND C1.C1_NUM BETWEEN '"+ Mv_par09 + "' AND '"+ Mv_par10 + "' "

    MemoWrit('C:\TEMP\COM038.SQL',cQuery)
		
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","C1_EMISSAO","D")  // Muda a data de string para date
	TcSetField("TMP","C1_DATPRF","D")   // Muda a data de string para date
	TcSetField("TMP","C7_EMISSAO","D")  // Muda a data de string para date
	TcSetField("TMP","C7_DATPRF","D")   // Muda a data de string para date

Return



Static Function RptDet()
Local _Quant := _dData := _Doc := _Aten :=  _Parc := _Nate := _Hate := _Tosc := 0
Local _lOk := .F.
SZU->(DbSetOrder(2))
SD1->(DbSetOrder(13))
// imprime cabeçalho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
DbSelectArea("TMP")
TMP->(DbGotop())

While !Tmp->(Eof())      

	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
	Endif   

	SZU->(DbSeek(xFilial("SZU")+TMP->C1_NUM+TMP->C1_ITEM))
	If SZU->(Found())
		While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == TMP->C1_NUM+TMP->C1_ITEM

			If SZU->ZU_STATUS <> "A" .And. SZU->ZU_NIVEL < '9'
				_lOk := .F.
				Exit
			Endif	
			
			If Empty(SZU->ZU_STATUS) .And. SZU->ZU_NIVEL == '9'
				_lOk := .T.
				Exit
			Endif

			If SZU->ZU_STATUS == "A" .And. SZU->ZU_NIVEL == '9'
				_lOk := .T.
				Exit
			Endif
			SZU->(DbSkip())
		Enddo
	Endif

	If _lOk


		@ Prow() +1, 001 Psay TMP->C1_NUM
		@ Prow()   , 008 Psay TMP->C1_ITEM
		@ Prow()   , 014 Psay TMP->C1_PRODUTO
		@ Prow()   , 030 Psay Substr(TMP->C1_DESCRI,1,40)
		@ Prow()   , 072 Psay TMP->C1_EMISSAO
		@ Prow()   , 084 Psay TMP->C1_DATPRF
		@ Prow()   , 094 Psay TMP->C1_QUANT  Picture "@E 999,999.99"
		@ Prow()   , 106 Psay TMP->C7_NUM
		@ Prow()   , 114 Psay TMP->C7_ITEM
		@ Prow()   , 120 Psay TMP->C7_EMISSAO
		@ Prow()   , 132 Psay TMP->C7_DATPRF 
	
		// Imprime detalhes
		_Quant := 0
		_dData := Ctod(Space(8))
		_Doc   := Space(06)
		SD1->(DbSeek(xFilial("SD1")+TMP->C7_NUM+TMP->C7_ITEM))
		While !SD1->(Eof()) .And. SD1->D1_PEDIDO == TMP->C7_NUM  .AND. SD1->D1_ITEM == TMP->C7_ITEM
			_Doc   := SD1->D1_DOC
			_dData := SD1->D1_DTDIGIT
			_Quant += SD1->D1_QUANT
			SD1->(DbSkip())
		Enddo
		@ Prow()   , 145 Psay _Doc
		@ Prow()   , 153 Psay _dData
		@ Prow()   , 165 Psay _Quant Picture "@E 999,999.99"

		If _dData == Ctod(Space(08))
			@ Prow()   , 177 Psay (TMP->C1_DATPRF - dDataBase)  Picture "@E 999,999.99"
			If TMP->C1_DATPRF - dDataBase >= 0
				_Nate += 1		
			Else
				_Hate += 1
			Endif


		Else
			@ Prow()   , 177 Psay (TMP->C1_DATPRF - _dData)  Picture "@E 999,999.99"
			
			If _Quant == TMP->C1_QUANT .AND.  TMP->C1_DATPRF >= _dData
				_Aten += 1
			Else
			    _Parc += 1
			Endif	

		Endif
		_Tosc++
		_lOk := .F.
	                
	Endif
	DBSELECTAREA("TMP")
	TMP->(DbSkip())

Enddo 
@ Prow() + 1, 001 Psay __PrtThinLine() 
@ Prow()+1 , 165 Psay "  Total de SC: "+Transform(_Tosc,"@e 999,999")
@ Prow()+1 , 165 Psay "     Atendida: "+Transform(_Aten,"@e 999,999")
@ Prow()+1 , 165 Psay "    Em Atraso: "+Transform(_Parc,"@e 999,999")      
@ Prow()+1 , 165 Psay "Nao Atendidas: "+Transform(_Nate,"@e 999,999")      
@ Prow()+1 , 165 Psay "   Ha Atender: "+Transform(_Hate,"@e 999,999")      
@ Prow() + 1, 001 Psay __PrtThinLine() 
Return(nil)
