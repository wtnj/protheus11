#include "font.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NHCOM049  ºAutor ³Fabio Nico          º Data ³  15/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Pedido de Compras                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                    
±±ºUso       ³ ESTOQUE/CUSTOS                                             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NHCOM049()   
Local oPrint
SetPrvt("aGrupo,_cCodUsr,aCols,aGrupo,_cArqDBF,_aDBF,_cArqDBF,_cOrdem,_totalgeral,_totalcc,_totalped,_totalsol")

aCols	:= {}
Agrupo 	:= {}
cString   := "SD1"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir ")
cDesc2    := OemToAnsi("Relatorio de Pedido de Compras")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM049"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("PEDIDOS DE COMPRAS")
cabec1    := "Cod.Produto       Descricao                                                     Dt.Emissao     Ent.Prev.     Qtde.Sol    Vlr.Total     Qtde.Entr   Vlr.Custo    NF"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := "NHCOM049"
_cPerg    := "COM049"
_nTotal   := 0
_totalgeral := 0  
_totalped := 0
_totalsol := 0
_totalcc := 0

Pergunte(_cPerg,.F.)                                      
cabec2    := "Periodo de : " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
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


Static Function Gerando()
Local cQuery
Local _n1,_n2,_n3,_ni,_nj,_ng 

//-----------------------------------------------------------------------
// MONTA A QUERY
//-----------------------------------------------------------------------		


cQuery := " SELECT C7_NUM,C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL, C7_PENDEN,D1_CUSTO, C7_FORNECE, C7_LOJA, A2_NOME, C7_NUMSC, "
cQuery += " C7_EMISSAO, C7_DATPRF, D1_QUANT, D1_DOC "

cQuery += " FROM " + RetSqlName('SC7') + " C7 (nolock) "

cQuery += " INNER JOIN " + RetSqlName('SA2') + " A2 (nolock) ON"
cQuery += " 	A2_FILIAL = '"+xFilial("SA2")+"'"
cQuery += " AND A2_COD = C7_FORNECE "
cQuery += " AND A2_LOJA = C7_LOJA "   
cQuery += " AND A2.D_E_L_E_T_ = ''

cQuery += " LEFT JOIN " + RetSqlName('SD1') + " D1 (nolock) ON " 
cQuery += "     D1.D1_FILIAL  = C7_FILIAL "
cQuery += " AND D1.D1_ITEMPC  = C7_ITEM "
cQuery += " AND D1.D1_PEDIDO  = C7_NUM "
cQuery += " AND D1.D1_COD     = C7_PRODUTO "
cQuery += " AND D1.D_E_L_E_T_ = ''

cQuery += "WHERE C7_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += "AND C7_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += "AND C7_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += "AND C7_CONTA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
cQuery += "AND C7.D_E_L_E_T_ = ''
cQuery += " AND C7.C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += "ORDER BY C7_NUM"

MemoWrit('C:\TEMP\NHCOM049.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TMP" 

TMP->(DbGotop())     


Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

_pedido := TMP->C7_NUM

@Prow()+1, 001 psay 'PEDIDO :' + TMP->C7_NUM
@Prow()	 , 020 psay 'Fornece:' + TMP->C7_FORNECE
@Prow()	 , 040 psay TMP->A2_NOME
	

While TMP->(!Eof())

	if _pedido <> TMP->C7_NUM 
		@Prow()+1, 000 PSAY __PrtThinLine() 		                                
		@Prow()+1, 001 psay 'PEDIDO :' + TMP->C7_NUM
		@Prow()	 , 020 psay 'Fornece:' + TMP->C7_FORNECE
		@Prow()	 , 040 psay TMP->A2_NOME
		_pedido := TMP->C7_NUM
	endif

		@Prow()+1, 001 psay TMP->C7_PRODUTO
		@Prow()  , 020 psay TMP->C7_DESCRI
		@Prow()  , 080 psay STOD(TMP->C7_EMISSAO) Picture "99/99/9999" 
		@Prow()  , 095 psay STOD(TMP->C7_DATPRF) Picture "99/99/9999" 
		@Prow()  , 110 psay TMP->C7_QUANT	Picture "@E 9999.99"
		@Prow()  , 120 psay TMP->C7_TOTAL   Picture "@E 999,999.99" 
		@Prow()  , 135 psay TMP->D1_QUANT 	Picture "@E 9999.99"

		if  TMP->D1_CUSTO = 0
				@Prow()  , 145 psay TMP->C7_TOTAL   Picture "@E 999,999.99"
			else
				@Prow()  , 145 psay TMP->D1_CUSTO   Picture "@E 999,999.99"			
        endif
		if TMP->D1_DOC = ' '
				@Prow()  , 160 psay 'PEDIDO'
			else
				@Prow()  , 160 psay TMP->D1_DOC
		endif
		

		
	If Prow() > 65 
	   	_nPag  := _nPag + 1   
    	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
    Endif                                 
    
	_totalped := _totalped + TMP->C7_TOTAL
	if  TMP->D1_CUSTO = 0
		_totalsol := _totalsol + TMP->D1_CUSTO
		else
		_totalsol := _totalsol + TMP->C7_TOTAL
	endif
	

	TMP->(Dbskip())
	
enddo

@Prow()+1, 000 PSAY __PrtThinLine() 		                                
@Prow()+1, 050 psay "TOTAL GERAL ...: "
@Prow()  , 119 psay _totalped	Picture "@E 999,999.99" 
@Prow()  , 144 psay _totalsol	Picture "@E 999,999.99" 
       

Return(nil)