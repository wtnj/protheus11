/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NHFAT022  บAutor ณFabio Nico          บ Data ณ  12/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Solicitacoes e Pedido de Compras              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANUTENCAO DE ATIVOS                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function NHMNT009()   

cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio  tem  como  objetivo  Imprimir ")
cDesc2    := OemToAnsi("Relatorio de SOLICITACOES e PEDIDO DE COMPRAS")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT009"
nLastKey  := 0
titulo    := OemToAnsi("SOLICITACAO E PEDIDOS DE COMPRAS")                
cabec1    := "O.S.  Cod.Bem             Descricao                         Cod.Produto      Descricao                 Num.SC      Data       Num.PC     Data       Quantidade      Preco       Total   Dt.Entrega     Solicitante "
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHMNT009"
_cPerg    := "MNT009" 

//MV_PAR01 -> DATA INICIAL
//MV_PAR02 -> DATA FINAL
//MV_PAR03 -> BEM INICIAL
//MV_PAR04 -> BEM FINAL
//MV_PAR05 -> encerrados sim/nao
//MV_PAR06 -> DE MATERIAL
//MV_PAR07 -> ATE MATERIAL
//MV_PAR08 -> DE CCUSTO
//MV_PAR09 -> ATE CCUSTO
//MV_PAR10 -> DE ORDEM
//MV_PAR11 -> ATE ORDEM
//MV_PAR12 -> DE STATUS
//MV_PAR13 -> ATE STATUS

Pergunte(_cPerg,.F.)                                      

cabec2    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

aDriver := ReadDriver()
cCompac := aDriver[1]      

Processa( {|| Gerando()   },"Gerando Dados para a Impressao") 

set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool
DbCloseArea("TMP")     

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ GERA OS DADOS PARA IMPRESSAO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function Gerando()
Local cQuery
Local _n1,_n2,_n3,_ni,_nj,_ng 

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------		

//cQuery := "SELECT C1_NUM,C1_PRODUTO,C1_DESCRI,C1_QUANT,C1_DATPRF,C1_SOLICIT,C1_USER,C1_PEDIDO,C1_ORDSERV, "
cQuery := "SELECT C1_NUM,C1_PRODUTO,C1_DESCRI,C1_QUANT,C1_DATPRF,C1_SOLICIT,C1_USER,C1_PEDIDO,C1_OS, "
cQuery += " C7_QUANT,C7_PRECO,C7_TOTAL,C7_NUM,C7_DATPRF,C7_EMISSAO, "
cQuery += " TJ_CODBEM,TJ_ORDEM,T9_NOME,C7.C7_ENCER "
cQuery += " FROM " + RetSqlName('STJ') + " TJ, " + RetSqlName('ST9') + " T9, " + RetSqlName('SC7') + " C7, "+ RetSqlName('SC1') + " C1 "
cQuery += " WHERE C1_NUM *= C7_NUMSC "
cQuery += " AND C1_ITEM *= C7_ITEMSC "
cQuery += " AND C1.C1_PRODUTO BETWEEN '"+mv_par06+"' AND '"+ mv_par07 +"' "
cQuery += " AND TJ.TJ_ORDEM BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"'"
cQuery += " AND TJ.TJ_STFOLUP BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"'"
cQuery += " AND TJ.TJ_CCUSTO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 +"' "
cQuery += " AND C1.C1_DATPRF BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " AND C1.C1_APROV <> 'R'"
cQuery += " AND T9.T9_CODBEM = TJ.TJ_CODBEM "
//cQuery += " AND TJ.TJ_ORDEM = C1.C1_ORDSERV "
cQuery += " AND TJ.TJ_ORDEM = C1.C1_OS'
cQuery += " AND TJ.TJ_CODBEM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " AND C1.D_E_L_E_T_ = ''  AND C7.D_E_L_E_T_ = '' AND TJ.D_E_L_E_T_ = '' AND T9.D_E_L_E_T_ = '' "
cQuery += " ORDER BY TJ_CODBEM "

MemoWrit('C:\TEMP\NHMNT009.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP" 

TMP->(DbGotop())     

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

While TMP->(!Eof())
	
	If Prow() > 65 
	   	_nPag  := _nPag + 1
    	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
    Endif

    If mv_par05 == 1
		If TMP->C7_ENCER == 'E'
			@Prow()+1, 001 psay TMP->TJ_ORDEM
			@Prow()  , 009 psay TMP->TJ_CODBEM
			@Prow()  , 025 psay TMP->T9_NOME
			@Prow()  , 062 psay TMP->C1_PRODUTO
			@Prow()  , 075 psay SUBSTR(TMP->C1_DESCRI,0,25)
			@Prow()  , 105 psay TMP->C1_NUM
			@Prow()  , 115 psay STOD(TMP->C1_DATPRF) Picture "99/99/9999" 
			@Prow()  , 127 psay TMP->C7_NUM
			@Prow()  , 135 psay STOD(TMP->C7_EMISSAO) Picture "99/99/9999" 
			@Prow()  , 152 psay TMP->C7_QUANT    Picture "@E 9999.99"
			@Prow()  , 160 psay TMP->C7_PRECO   Picture "@E 999,999.99"
			@Prow()  , 172 psay TMP->C7_TOTAL	Picture "@E 999,999.99"
			@Prow()  , 185 psay STOD(TMP->C7_DATPRF) Picture "99/99/9999" 
			@Prow()  , 200 psay TMP->C1_SOLICIT
		EndIf
	EndIf
	If mv_par05 == 2
		If TMP->C7_ENCER <> 'E'
			@Prow()+1, 001 psay TMP->TJ_ORDEM
			@Prow()  , 009 psay TMP->TJ_CODBEM
			@Prow()  , 025 psay TMP->T9_NOME
			@Prow()  , 062 psay TMP->C1_PRODUTO
			@Prow()  , 075 psay SUBSTR(TMP->C1_DESCRI,0,25)
			@Prow()  , 105 psay TMP->C1_NUM
			@Prow()  , 115 psay STOD(TMP->C1_DATPRF) Picture "99/99/9999" 
			@Prow()  , 127 psay TMP->C7_NUM
			@Prow()  , 135 psay STOD(TMP->C7_EMISSAO) Picture "99/99/9999" 
			@Prow()  , 152 psay TMP->C7_QUANT    Picture "@E 9999.99"
			@Prow()  , 160 psay TMP->C7_PRECO   Picture "@E 999,999.99"
			@Prow()  , 172 psay TMP->C7_TOTAL	Picture "@E 999,999.99"
			@Prow()  , 185 psay STOD(TMP->C7_DATPRF) Picture "99/99/9999" 
			@Prow()  , 200 psay TMP->C1_SOLICIT
		EndIf
	EndIf	

	TMP->(Dbskip())
enddo

Return(nil)