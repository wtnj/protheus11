/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHEST209  º Autor ³Guilherme D. Camargo º Data ³  27/09/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO DE ENTRADAS E SAÍDAS                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTOQUE / CUSTOS                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function NHEST209()  
Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Este relatório tem o objetivo de  apresentar")
cDesc2    := OemToAnsi("os dados referentes à entradas e saídas.")
cDesc3    := OemToAnsi("")
tamanho   := "G"                                                                                          
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST209"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELATÓRIO DE ENTRADAS E SAÍDAS")
cabec1    := "  SAÍDAS"
cabec2    := " Emissão      Cliente   Nome                         Num. Nota   Serie  Grupo  CFOP   Produto           Descrição                    C. Custo    INSS Pat    Cod Ativ   NCM          Total NF           Val IPI"
cabec3    := ""
cabec11   := "  ENTRADAS"
cabec22   := " Digitação    Forn/Cli  Nome                         Documento    Serie  Grupo  CFOP   Produto           Descrição                    C. Custo   INSS Pat  Cod Ativ  NCM         Total            Val IPI"

cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG	  := 1
wnrel     := nomeprog //"NH"
_cPerg    := "EST209" 

Pergunte(_cPerg,.F.)
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
Processa(  {|| Gerando()   },"Gerando Dados para a Impressão") 
RptStatus( {|| Imprime()   },"Imprimindo...")
set filter to //remove o filtro da tabela
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          
MS_FLUSH() //Libera fila de relatorios em spool
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO QUE GERA OS DADOS PARA IMPRESSAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gerando()
Local cQuery

cQuery := "SELECT D2.D2_EMISSAO, D2.D2_CLIENTE,LEFT(A1.A1_NOME,25) AS _NOMEs,D2.D2_DOC,D2.D2_SERIE,D2.D2_CF,D2.D2_COD, D2.D2_CCUSTO,B5.B5_INSPAT,B5.B5_CODATIV,LEFT(B1.B1_DESC,25)AS _DESCs,B1.B1_POSIPI,D2.D2_GRUPO,SUM(D2.D2_TOTAL) AS _TOTAL,SUM(D2.D2_VALIPI) AS _VALIPI"
cQuery += " FROM " + RetSqlName('SD2') +" D2 , " + RetSqlName('SA1') + " A1 , " + RetSqlName('SB1') + " B1 , " + RetSqlName('SB5') + " B5, " + RetSqlName('SF4') + " F4 " 
cQuery += " WHERE D2.D_E_L_E_T_ = ''"
cQuery += " AND D2.D2_FILIAL = '" + xFilial('SD2')+ "' AND A1.A1_FILIAL = '" + xFilial('SA1')+ "' AND B1.B1_FILIAL = '" + xFilial('SB1')+ "' AND F4.F4_FILIAL = '" + xFilial('SF4')+ "' AND B5.B5_FILIAL = '" + xFilial('SB5')+ "'"
cQuery += " AND D2.D2_EMISSAO BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND D2.D2_TES = F4.F4_CODIGO"     
cQuery += " AND F4.F4_DUPLIC = 'S'"     
cQuery += " AND D2.D2_COD = B5.B5_COD"
cQuery += " AND D2.D2_COD = B1.B1_COD"
cQuery += " AND A1.A1_COD = D2.D2_CLIENTE"
cQuery += " AND A1.A1_LOJA = D2.D2_LOJA"
cQuery += " GROUP BY D2.D2_EMISSAO, D2.D2_CLIENTE,A1.A1_NOME,D2.D2_DOC,D2.D2_SERIE,D2.D2_CF,D2.D2_COD, D2.D2_CCUSTO,B5.B5_INSPAT,B5.B5_CODATIV,B1.B1_DESC,B1.B1_POSIPI,D2.D2_GRUPO"
TCQUERY cQuery NEW ALIAS "TRA1"
TcSetField("TRA1","D2_EMISSAO","D")
//MemoWrit('C:\TEMP\'+nomeprog+'1.SQL',cQuery)
TRA1->( DbGoTop() )

cQuery := "SELECT D1.D1_DTDIGIT, D1.D1_FORNECE, LEFT(A1.A1_NOME,25) AS _NOMEe,D1.D1_DOC,D1.D1_SERIE,D1.D1_CF,D1.D1_COD,D1.D1_CC,B5.B5_INSPAT,B5.B5_CODATIV, LEFT(B1.B1_DESC, 25) AS _DESC,B1.B1_POSIPI,D1.D1_GRUPO,SUM(D1.D1_TOTAL) AS _TOTe,SUM(D1.D1_VALIPI) AS _IPIe"
cQuery += " FROM " + RetSqlName('SD1') + " D1, " + RetSqlName('SA1') + " A1, " + RetSqlName('SB1') + " B1, " + RetSqlName('SB5') + " B5"
cQuery += " WHERE D1.D_E_L_E_T_ = ''"
cQuery += " AND D1.D1_FILIAL = '" + xFilial('SD1')+ "' AND A1.A1_FILIAL = '" + xFilial('SA1')+ "' AND B1.B1_FILIAL = '" + xFilial('SB1')+ "' AND B5.B5_FILIAL = '" + xFilial('SB5')+ "'"
cQuery += " AND D1.D1_DTDIGIT BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND D1.D1_COD = B1.B1_COD"
cQuery += " AND D1.D1_COD = B5.B5_COD"
cQuery += " AND A1.A1_COD = D1.D1_FORNECE"
cQuery += " AND A1.A1_LOJA = D1.D1_LOJA"
cQuery += " AND D1.D1_CF IN ('1201','2201')"
cQuery += " GROUP BY D1.D1_DTDIGIT, D1.D1_FORNECE,A1.A1_NOME,D1.D1_DOC,D1.D1_SERIE,D1.D1_CF,D1.D1_COD,D1.D1_CC,B5.B5_INSPAT,B5.B5_CODATIV, B1.B1_DESC,B1.B1_POSIPI,D1.D1_GRUPO"
TCQUERY cQuery NEW ALIAS "TRA2" 
TcSetField("TRA2","D1_DTDIGIT","D")
//MemoWrit('C:\TEMP\'+nomeprog+'2.SQL',cQuery)
TRA2->(DbGotop())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA IMPRESSAO DO RELATÓRIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Imprime()
Local _nSoma := 0
Local _nIPI := 0
Local nTotal := 0
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
SetRegua(TRA1->(RECCOUNT()))
While TRA1->(!Eof())  
	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif
	IncRegua()
	@Prow()+1, 001 psay DTOC(TRA1->D2_EMISSAO)
	@Prow()  , 014 psay TRA1->D2_CLIENTE
  	@Prow()  , 024 psay TRA1->_NOMEs
  	@Prow()  , 053 psay TRA1->D2_DOC
  	@Prow()  , 065 psay TRA1->D2_SERIE
  	@Prow()  , 072 psay TRA1->D2_GRUPO
  	@Prow()  , 079 psay TRA1->D2_CF
  	@Prow()  , 086 psay TRA1->D2_COD
  	@Prow()  , 104 psay TRA1->_DESCs
  	@Prow()  , 133 psay TRA1->D2_CCUSTO
  	@Prow()  , 145 psay TRA1->B5_INSPAT
   	@Prow()  , 157 psay TRA1->B5_CODATIV
  	@Prow()  , 168 psay TRA1->B1_POSIPI
  	
  	@Prow()  , 181 psay TRA1->_TOTAL
  	@Prow()  , 200 psay TRA1->_VALIPI
  	_nSoma += TRA1->_TOTAL
  	_nIPI  += TRA1->_VALIPI
	TRA1->(DbSkip())
EndDo
@ prow()+1,000 PSAY __PrtThinLine()
@ prow()+1,181 PSAY "Total Geral:"
@ prow()  ,200 PSAY _nSoma
@ prow()+1,181 PSAY "Total IPI:"
@ prow()  ,200 PSAY _nIPI
_nSoma := 0
_nIPI  := 0
Cabec(Titulo, Cabec11, Cabec22, NomeProg, Tamanho, nTipo)
While TRA2->(!Eof())
	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec11, Cabec22, NomeProg, Tamanho, nTipo) 
  	Endif
	@Prow()+1, 001 psay DTOC(TRA2->D1_DTDIGIT)
	@Prow()  , 014 psay TRA2->D1_FORNECE
	@Prow()  , 024 psay TRA2->_NOMEe
	@Prow()  , 053 psay TRA2->D1_DOC
	@Prow()  , 066 psay TRA2->D1_SERIE
	@Prow()  , 073 psay TRA2->D1_GRUPO
	@Prow()  , 080 psay TRA2->D1_CF
	@Prow()  , 087 psay TRA2->D1_COD
	@Prow()  , 105 psay TRA2->_DESC
	@Prow()  , 134 psay TRA2->D1_CC
	@Prow()  , 145 psay TRA2->B5_INSPAT
	@Prow()  , 155 psay TRA2->B5_CODATIV
	@Prow()  , 165 psay TRA2->B1_POSIPI
	@Prow()  , 177 psay TRA2->_TOTe
	@Prow()  , 194 psay TRA2->_IPIe
	_nSoma += TRA2->_TOTe
	_nIPI  += TRA2->_IPIe
	TRA2->(DbSkip())
Enddo
@ prow()+1,000 PSAY __PrtThinLine()
@ prow()+1,177 PSAY "Total Geral:"
@ prow()  ,194 PSAY _nSoma
@ prow()+1,177 PSAY "Total IPI:"
@ prow()  ,194 PSAY _nIPI
_nSoma := 0
_nIPI  := 0
TRA1->(DbCloseArea())
TRA2->(DbCloseArea())
Return(nil)