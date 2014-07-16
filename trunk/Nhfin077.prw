/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NHFIN077  ºAutor  ³Marcos R. Roquitski º Data ³ 09/10/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de despesas com projetos.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Nhfin077()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,_dDataEnt,_nNfGe,_nqTotpe,_nqIpi,_nBase1,_nJaEnt")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende,_nPosMes")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z,_aMes,j")
SetPrvt("_cArquivo,_aStruct,_cTr1,lEnd")

_aGrupo   := pswret()
_cCodUsr  := _agrupo[1,1]
cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("Despesas com projetos")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHFIN077"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "Pedido de Compra / Nota Fiscal / Contas a Pagar"
Cabec1    := "Pedido  Fornecedor                                   Vlr.Pedido  C.Pgto   Prefixo    Numero     Tipo  Parc.    Emissao     Vencimento   Vencto Real             Valor     Dt.Baixa        Fatura"
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
nPag      := 1  //Variavel que acumula numero da pagina
m_Pag     := 1
wnrel     := "NHFIN077"       //Nome Default do relatorio em Disco
_cPerg    := "COM007"         //Grupo de Parƒmetros que serÆo utilizados (cadastrar novo grupo no SX3)

_cArquivo := "PEDIDO.TXT"
lEnd      := .T.

If !File(_cArquivo)
   MsgBox("Arquivo de Entrada nao Localizado: " + _cArquivo,"Arquivo Retorno","INFO")
   Return
Endif

DbSelectArea("SRA")
DbSetorder(1)

// Arquivo a ser trabalhado
_aStruct:={{ "PEDIDO","C",06,0} }

_cTr1 := CriaTrab(_aStruct,.t.)
USE &_cTr1 Alias TRB New Exclusive
Append From (_cArquivo) SDF
                                     
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho)
If nLastKey == 27
	DbSelectArea("TRB")
	DbCloseArea()
	Ferase(_cTr1)
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	DbSelectArea("TRB")
	DbCloseArea()
	Ferase(_cTr1)
    Set Filter To
    Return
Endif
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da validação de dados em um campo qualquer
Processa( {|| Imprime() },"Imprimindo...")

DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DbSelectArea("TRB")
DbCloseArea()
Ferase(_cTr1)

Return


Static Function Gerando()
Local _cPedido := "("
	DbSelectArea("TRB")
	TRB->(DbGotop())
	
	While !TRB->(Eof())
		_cPedido += "'"+TRB->PEDIDO+"'"
		TRB->(DbSkip())
		If !Eof()
			_cPedido += ","
		Endif			
	Enddo
	_cPedido += ")"
   	IncProc("Processando..........")

	cQuery := "SELECT C7.C7_NUM,C7.C7_LOJA,C7.C7_FORNECE,C7.C7_TOTAL,C7.C7_COND,D1.D1_SERIE,D1.D1_DOC,D1.D1_LOJA,D1.D1_FORNECE,D1.D1_EMISSAO "
	cQuery += "FROM " + RetSqlName( 'SC7' ) + " C7, "+ RetSqlName( 'SD1' ) + " D1 "
	cQuery += "WHERE C7.C7_NUM IN " + _cPedido 
	cQuery += "AND D1.D1_FILIAL = '" + xFilial("SD1")+ "' "
	cQuery += "AND C7.C7_FILIAL = '" + xFilial("SC7")+ "' "
	cQuery += "AND C7.D_E_L_E_T_ = '' "
	cQuery += "AND D1.D_E_L_E_T_ = '' "
	cQuery += "AND D1.D1_PEDIDO = C7.C7_NUM "
	cQuery += "AND D1.D1_ITEMPC = C7.C7_ITEM "
	cQuery += "ORDER BY C7.C7_NUM,D1.D1_DOC "
	
	TCQUERY cQuery NEW ALIAS "TMP" 
	TcSetField("TMP","D1_EMISSAO","D")  // Muda a data de string para date

Return 

Static Function Imprime() 
Local _cNmFornec := '', n := 0, _nC7Total := 0, _cFinan := '', _cFina2 := '' 
SA2->(DbSetOrder(1)) 
SE2->(DbSetOrder(1)) 
TMP->(Dbgotop()) 
                          
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho) 
While !TMP->(Eof()) 
	
	_cNmFornec := Space(40) 
	SA2->(DbSeek(xFilial("SA2")+TMP->D1_FORNECE+TMP->D1_LOJA)) 
	If SA2->(Found()) 
		_cNmFornec := TMP->D1_FORNECE+" "+TMP->D1_LOJA+" "+SA2->A2_NREDUZ 
	Endif 

	If Prow() > 60 
		nPag := nPag + 1 
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho) 
	Endif 

	_cCond  := TMP->C7_NUM + TMP->D1_DOC 
	_cFinan := TMP->D1_SERIE + TMP->D1_DOC 
    _cFina2 := TMP->D1_FORNECE + TMP->D1_LOJA 

	@ Prow() + 1, 000 Psay TMP->C7_NUM 
	@ Prow()    , 008 Psay _cNmFornec 
	@ Prow()    , 068 Psay TMP->C7_COND 
	@ Prow()    , 080 Psay TMP->D1_SERIE 
	@ Prow()    , 085 Psay TMP->D1_DOC 

	// Totaliza SC7 
	While !TMP->(Eof()) .AND. TMP->C7_NUM + TMP->D1_DOC == _cCond 
		_nC7Total += TMP->C7_TOTAL 
		TMP->(DbSkip()) 
	Enddo 
	@ Prow()    , 050 Psay _nC7Total Picture "@E 999,999,999.99"
	_nC7Total := 0
  	
	// Contas a pagar	
    SE2->(DbSeek(xFilial("SE2")+_cFinan))
	While !SE2->(Eof()) .AND. _cFinan == SE2->E2_PREFIXO+SE2->E2_NUM
		If SE2->E2_FORNECE + SE2->E2_LOJA == _cFina2
			@ Prow() + 1, 085 Psay SE2->E2_NUM
			@ Prow()    , 100 Psay SE2->E2_TIPO
			@ Prow()    , 105 Psay SE2->E2_PARCELA
			@ Prow()    , 110 Psay SE2->E2_EMISSAO
			@ Prow()    , 124 Psay SE2->E2_VENCTO
			@ Prow()    , 138 Psay SE2->E2_VENCREA
			@ Prow()    , 152 Psay SE2->E2_VALOR Picture "@E 999,999,999.99"
			@ Prow()    , 174 Psay SE2->E2_BAIXA
			@ Prow()    , 186 Psay SE2->E2_FATURA
		Endif			
		SE2->(Dbskip())
	Enddo	
	@ Prow() + 1,000 Psay __PrtThinLine()
    
Enddo
@ Prow() + 1,000 Psay __PrtThinLine()
	
Return
