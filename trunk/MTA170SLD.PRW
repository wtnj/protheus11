/*
+-----------------------------------------------------------------------------------------+
| Autor: João Felipe da Rosa                                                              |
| Data:  14/02/2008                                                                       |
+-----------------------------------------------------------------------------------------+
|Array: O parâmetro tem a seguinte estrutura:                                             |
|{nSaldo,SB2->B2_COD,SB2->B2_LOCAL}                                                       |
|nSaldo -> Saldo calculado pelo sistema                                                   |
|SB2->B2_COD -> Códido do produto                                                         |
|SB2->B2_LOCAL -> Armazém do produto                                                      |
|Retorno                                                                                  |
+-----------------------------------------------------------------------------------------+
|LOCALIZAÇÃO   : Localizado na função A170Point  (Geração  das  solicitações  de  compra).|
|EM QUE PONTO : É executado dentro do laço onde  é feito o cálculo  do  saldo  do  produto|
|de todos os almoxarifados. O resultado do cálculo do saldo é guardado na variável nSaldo.|
|O ponto de entrada é executado após a  atualização  desta  variável,  produto  a  produto|
|(todos os almoxarifados) .                                                               |
+-----------------------------------------------------------------------------------------+

*/

#include "topconn.ch"

User Function MT170SLD( )

Local nQuant:= PARAMIXB[1]
Local cProd := PARAMIXB[2]
Local cLocal:= PARAMIXB[3]
Local nNewSaldo := 0
Local cQuery,  cQuery2

cQuery := "SELECT SUM(C1_QUANT - C1_QUJE) AS C1_QUANT FROM "+RetSqlName('SC1')
cQuery += " WHERE SUBSTRING(C1_CONTA,1,6) = '104020'"
cQuery += " AND C1_PRODUTO = '"+cprod+"'"
cQuery += " AND C1_QUJE <> C1_QUANT"
cQuery += " AND C1_LOCAL = '"+clocal+"'"
cQuery += " AND C1_RESIDUO = ' '"
cQuery += " AND D_E_L_E_T_ = ' '"

TCQUERY cQuery NEW ALIAS 'TRA1'

cQuery2 := "SELECT SUM(C7_QUANT - C7_QUJE) AS C7_QUANT FROM "+RetSqlName('SC7')
cQuery2 += " WHERE SUBSTRING(C7_CONTA,1,6) = '104020'"
cQuery2 += " AND C7_PRODUTO = '"+cprod+"'"
cQuery2 += " AND C7_QUJE <> C7_QUANT"
cQuery2 += " AND C7_LOCAL = '"+clocal+"'"
cQuery2 += " AND C7_RESIDUO = ' '"
cQuery2 += " AND D_E_L_E_T_ = ' '"

TCQUERY cQuery2 NEW ALIAS 'TRB'
         
nNewSaldo := nquant - (TRA1->C1_QUANT + TRB->C7_QUANT)

/*If '045005'$cprod

//-- Manipulação pelo usuário do saldo do produto
ALERT(nquant)
ALERT(cprod)
ALERT(clocal)

EndIf
*/

TRA1->(DbCloseArea())
TRB->(DbCloseArea())

Return (nNewSaldo)



